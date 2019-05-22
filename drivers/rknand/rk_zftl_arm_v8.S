/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2019-04-27
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
	bls	.L61
	mov	x5, x3
	ldrh	w3, [x2]
	mov	w12, 6
	ldr	x11, [x0]
	add	w3, w3, 1
	strh	w3, [x2]
	adrp	x2, .LANCHOR4
	umull	x12, w1, w12
	ldr	x8, [x2, #:lo12:.LANCHOR4]
	mov	w2, -1
	add	x10, x8, x12
	strh	w2, [x10, 2]
	strh	w2, [x8, x12]
	cbnz	x11, .L44
	str	x10, [x0]
	ret
.L44:
	stp	x29, x30, [sp, -32]!
	adrp	x2, .LANCHOR9
	uxtw	x3, w1
	adrp	x7, .LANCHOR8
	add	x29, sp, 0
	ldr	x15, [x2, #:lo12:.LANCHOR9]
	adrp	x2, .LANCHOR7
	ldrh	w4, [x10, 4]
	ldr	x13, [x2, #:lo12:.LANCHOR7]
	stp	x19, x20, [sp, 16]
	ldrh	w6, [x15, x3, lsl 1]
	lsl	x3, x3, 2
	ldrh	w16, [x7, #:lo12:.LANCHOR8]
	ldr	w2, [x13, x3]
	mul	w6, w6, w4
	ldrh	w3, [x13, x3]
	ubfx	x2, x2, 11, 8
	and	w3, w3, 2047
	cbz	w6, .L45
	madd	w2, w16, w2, w3
	add	w6, w6, w2, uxth
.L45:
	sub	x2, x11, x8
	mov	x3, -6148914691236517206
	asr	x2, x2, 1
	movk	x3, 0xaaab, lsl 0
	cmp	w4, 0
	ldrh	w30, [x5, #:lo12:.LANCHOR6]
	csinv	w6, w6, wzr, ne
	mov	x7, x11
	mul	x2, x2, x3
	mov	w4, 0
	mov	w19, 65535
	mov	w20, 6
	and	w2, w2, 65535
.L52:
	add	w4, w4, 1
	and	w4, w4, 65535
	cmp	w4, w30
	bhi	.L41
	cmp	w1, w2
	beq	.L41
	uxtw	x5, w2
	ldrh	w17, [x7, 4]
	ldrh	w3, [x15, x5, lsl 1]
	lsl	x5, x5, 2
	mul	w14, w3, w17
	ldr	w3, [x13, x5]
	ldrh	w5, [x13, x5]
	ubfx	x3, x3, 11, 8
	and	w5, w5, 2047
	cbz	w14, .L48
	cbz	w17, .L56
	madd	w3, w16, w3, w5
	add	w3, w14, w3, uxth
.L49:
	cmp	w6, w3
	bcc	.L50
.L54:
	ldrh	w3, [x7]
	cmp	w3, w19
	bne	.L51
	strh	w2, [x10, 2]
	strh	w1, [x7]
.L41:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L51:
	umaddl	x7, w3, w20, x8
	mov	w2, w3
	b	.L52
.L50:
	ldrh	w3, [x7, 2]
	cmp	x11, x7
	strh	w3, [x10, 2]
	strh	w2, [x8, x12]
	bne	.L53
	strh	w1, [x11, 2]
	str	x10, [x0]
	b	.L41
.L53:
	ldrh	w0, [x7, 2]
	mov	w2, 6
	umull	x0, w0, w2
	strh	w1, [x8, x0]
	strh	w1, [x7, 2]
	b	.L41
.L48:
	cbnz	w17, .L54
.L56:
	mov	w3, -1
	b	.L49
.L61:
	ret
	.size	_insert_data_list, .-_insert_data_list
	.section	.text._list_get_gc_head_node.isra.2,"ax",@progbits
	.align	2
	.type	_list_get_gc_head_node.isra.2, %function
_list_get_gc_head_node.isra.2:
	and	w1, w1, 65535
	cbz	x0, .L68
	adrp	x2, .LANCHOR4
	mov	w3, 65535
	mov	w4, 6
	ldr	x2, [x2, #:lo12:.LANCHOR4]
.L65:
	cbz	w1, .L66
	ldrh	w0, [x0]
	cmp	w0, w3
	bne	.L67
	ret
.L67:
	sub	w1, w1, #1
	umaddl	x0, w0, w4, x2
	and	w1, w1, 65535
	b	.L65
.L68:
	mov	w0, 65535
	ret
.L66:
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
	beq	.L70
	ldrh	w3, [x1, 48]
	cmp	w3, w19
	beq	.L70
	ldrh	w1, [x1, 80]
	cmp	w1, w19
	beq	.L70
	adrp	x1, .LANCHOR4
	mov	w22, 6
	ldr	x3, [x0]
	mov	x25, x1
	umull	x22, w19, w22
	ldr	x24, [x1, #:lo12:.LANCHOR4]
	add	x23, x24, x22
	cmp	x23, x3
	beq	.L70
	mov	x20, x0
	ldrh	w0, [x23, 2]
	mov	w1, 65535
	mov	x21, x2
	cmp	w0, w1
	bne	.L74
	ldrh	w1, [x24, x22]
	cmp	w1, w0
	bne	.L74
	adrp	x1, .LANCHOR11
	adrp	x0, .LC0
	mov	w2, 255
	add	x1, x1, :lo12:.LANCHOR11
	add	x0, x0, :lo12:.LC0
	bl	printf
.L74:
	ldrh	w1, [x23, 2]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L75
	ldrh	w0, [x24, x22]
	cmp	w0, w1
	beq	.L70
.L75:
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
	bcs	.L70
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
.L70:
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
	.section	.text.nandc_de_cs.constprop.29,"ax",@progbits
	.align	2
	.type	nandc_de_cs.constprop.29, %function
nandc_de_cs.constprop.29:
	adrp	x0, .LANCHOR13
	ldr	x1, [x0, #:lo12:.LANCHOR13]
	ldr	w0, [x1]
	and	w0, w0, -256
	and	w0, w0, -131073
	str	w0, [x1]
	ret
	.size	nandc_de_cs.constprop.29, .-nandc_de_cs.constprop.29
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
	tbz	x0, 12, .L84
	adrp	x1, .LANCHOR15
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR15
	add	x0, x0, :lo12:.LC1
	bl	printf
.L84:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L85
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
.L85:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L86
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 8]
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
.L86:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L87
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 9]
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
.L87:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L88
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 10]
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
.L88:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L89
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 12]
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
.L89:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L90
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 13]
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
.L90:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L91
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 14]
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
.L91:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L92
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 23]
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
.L92:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L93
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 18]
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	printf
.L93:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L94
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 19]
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	printf
.L94:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L95
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 20]
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	bl	printf
.L95:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L96
	adrp	x0, .LANCHOR17
	ldrb	w1, [x0, #:lo12:.LANCHOR17]
	adrp	x0, .LC13
	add	x0, x0, :lo12:.LC13
	bl	printf
.L96:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L97
	adrp	x0, .LANCHOR0
	ldrb	w1, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printf
.L97:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L98
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 22]
	adrp	x0, .LC15
	add	x0, x0, :lo12:.LC15
	bl	printf
.L98:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L99
	adrp	x0, .LANCHOR18
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	adrp	x0, .LC16
	add	x0, x0, :lo12:.LC16
	bl	printf
.L99:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L100
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 16]
	adrp	x0, .LC17
	add	x0, x0, :lo12:.LC17
	and	w1, w1, 1
	bl	printf
.L100:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L101
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC18
	add	x0, x0, :lo12:.LC18
	ubfx	x1, x1, 1, 1
	bl	printf
.L101:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L102
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC19
	add	x0, x0, :lo12:.LC19
	ubfx	x1, x1, 2, 1
	bl	printf
.L102:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L103
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC20
	add	x0, x0, :lo12:.LC20
	ubfx	x1, x1, 3, 1
	bl	printf
.L103:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L104
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC21
	add	x0, x0, :lo12:.LC21
	ubfx	x1, x1, 4, 1
	bl	printf
.L104:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L105
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC22
	add	x0, x0, :lo12:.LC22
	ubfx	x1, x1, 5, 1
	bl	printf
.L105:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L106
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC23
	add	x0, x0, :lo12:.LC23
	ubfx	x1, x1, 6, 1
	bl	printf
.L106:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L107
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	ubfx	x1, x1, 7, 1
	bl	printf
.L107:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L108
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w1, [x0, 17]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	and	w1, w1, 1
	bl	printf
.L108:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L109
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC26
	add	x0, x0, :lo12:.LC26
	ubfx	x1, x1, 9, 1
	bl	printf
.L109:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L110
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC27
	add	x0, x0, :lo12:.LC27
	ubfx	x1, x1, 10, 1
	bl	printf
.L110:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L111
	adrp	x0, .LANCHOR19
	ldrb	w2, [x0, #:lo12:.LANCHOR19]
	adrp	x0, .LANCHOR0
	ldrb	w1, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LC28
	add	x0, x0, :lo12:.LC28
	bl	printf
.L111:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L112
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	ldrb	w2, [x0, 11]
	ldrb	w1, [x0, 10]
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	bl	printf
.L112:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L113
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	ldrb	w2, [x0, 9]
	ldrb	w1, [x0, 8]
	adrp	x0, .LC30
	add	x0, x0, :lo12:.LC30
	bl	printf
.L113:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L83
	adrp	x0, .LANCHOR21
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ldrb	w1, [x0, #:lo12:.LANCHOR21]
	adrp	x0, .LC31
	add	x0, x0, :lo12:.LC31
	b	printf
.L83:
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
.L207:
	ldr	w0, [sp, 12]
	sub	w1, w0, #1
	str	w1, [sp, 12]
	cbnz	w0, .L207
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
	bhi	.L220
	ret
.L214:
	cmp	w0, 35
	bne	.L216
	ldrsb	w0, [x3, x2]
	b	.L221
.L216:
	ldrsb	w0, [x10, w11, sxtw]
	b	.L221
.L220:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L217:
	mov	w0, 85
	str	w0, [x4, 8]
	add	x0, x5, :lo12:.LANCHOR23
	ldrsb	w0, [x2, x0]
	str	w0, [x4, 4]
	mov	w0, 200
	bl	timer_delay_ns
	ldrb	w0, [x8]
	cmp	w0, 34
	bne	.L214
	ldrsb	w0, [x7, x2]
.L221:
	str	w0, [x4]
	add	x2, x2, 1
	ldrb	w0, [x6]
	cmp	w0, w2
	bhi	.L217
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
	beq	.L223
	mov	w3, 160
	umaddl	x1, w3, w0, x1
.L223:
	ubfiz	x0, x0, 8, 8
	mov	x3, 0
	add	x2, x2, x0
	mov	w0, 54
	add	x4, x4, x1
	cmp	w5, w3, uxtb
	str	w0, [x2, 2056]
	bhi	.L230
	mov	w0, 22
	str	w0, [x2, 2056]
	ret
.L230:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L226:
	ldrb	w0, [x6, x3]
	str	w0, [x2, 2052]
	mov	w0, 120
	bl	timer_delay_ns
	ldrsb	w0, [x4, x3]
	str	w0, [x2, 2048]
	add	x3, x3, 1
	cmp	w5, w3, uxtb
	bhi	.L226
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
	bhi	.L237
	adrp	x8, .LANCHOR27
	and	w0, w0, 255
	sxtw	x7, w0
	ldr	x1, [x8, #:lo12:.LANCHOR27]
	add	x1, x1, x7
	ldrb	w1, [x1, 120]
	cbz	w1, .L237
	stp	x29, x30, [sp, -16]!
	mov	w1, 0
	add	x29, sp, 0
	bl	hynix_set_rr_para
	ldr	x0, [x8, #:lo12:.LANCHOR27]
	add	x0, x0, x7
	strb	wzr, [x0, 120]
	ldp	x29, x30, [sp], 16
	ret
.L237:
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
	bne	.L241
	str	w1, [x2, 80]
	ret
.L241:
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
	bne	.L244
	ldr	w0, [x0, 80]
.L246:
	ubfx	x0, x0, 8, 8
	ret
.L244:
	ldr	w0, [x0, 304]
	b	.L246
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
	beq	.L248
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
	bne	.L250
	mov	w3, 8321
	str	w3, [x2, 8]
	str	w0, [x2, 80]
	mov	w0, 38
	str	w0, [x2, 84]
	mov	w0, 39
	str	w0, [x2, 84]
.L251:
	str	w1, [x2]
	ret
.L250:
	mov	w3, 8322
	str	w3, [x2, 344]
	str	w0, [x2, 304]
	mov	w0, 38
	str	w0, [x2, 308]
	mov	w0, 39
	str	w0, [x2, 308]
	b	.L251
.L248:
	and	w1, w1, -8193
	b	.L251
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
	bhi	.L256
	adrp	x1, .LANCHOR29
	adrp	x0, .LC0
	mov	w2, 677
	add	x1, x1, :lo12:.LANCHOR29
	add	x0, x0, :lo12:.LC0
	bl	printf
.L256:
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
.L259:
	str	w4, [x2, 2056]
	mov	w0, 120
	str	w19, [x2, 2052]
	str	w6, [x2, 2052]
	str	w7, [x2, 2052]
	bl	timer_delay_ns
	ldr	w3, [x2, 2048]
	and	w3, w3, 255
	bics	wzr, w20, w3
	bne	.L259
	cmp	w3, 255
	beq	.L259
	bl	nandc_de_cs.constprop.29
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
	ubfx	x6, x0, 21, 3
	and	w1, w0, 2097151
	tst	x0, 50331648
	bne	.L263
	adrp	x0, .LANCHOR0
	adrp	x5, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L264
	ldrb	w0, [x5, #:lo12:.LANCHOR1]
	cbz	w0, .L263
.L264:
	adrp	x0, .LANCHOR2
	ldrh	w3, [x0, #:lo12:.LANCHOR2]
	ldrb	w0, [x5, #:lo12:.LANCHOR1]
	udiv	w4, w1, w3
	mul	w4, w4, w3
	sub	w3, w1, w4
	cbz	w0, .L265
	add	w1, w4, w3, lsl 1
.L263:
	mov	w0, w6
	b	flash_wait_device_ready_raw
.L265:
	adrp	x5, .LANCHOR3
	add	x5, x5, :lo12:.LANCHOR3
	ldrh	w3, [x5, w3, uxtw 1]
	add	w1, w3, w4
	b	.L263
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
.L275:
	ldr	x0, [x3, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbnz	x0, 9, .L276
	mov	w0, 10
	bl	timer_delay_ns
	subs	w2, w2, #1
	bne	.L275
	mov	w0, -1
.L273:
	ldp	x29, x30, [sp], 32
	ret
.L276:
	mov	w0, 0
	b	.L273
	.size	nandc_wait_flash_ready_no_delay, .-nandc_wait_flash_ready_no_delay
	.section	.text.zftl_flash_enter_slc_mode,"ax",@progbits
	.align	2
	.global	zftl_flash_enter_slc_mode
	.type	zftl_flash_enter_slc_mode, %function
zftl_flash_enter_slc_mode:
	adrp	x1, .LANCHOR0
	ldrb	w1, [x1, #:lo12:.LANCHOR0]
	cbz	w1, .L279
	adrp	x2, .LANCHOR13
	and	x0, x0, 255
	cmp	w1, 1
	ldr	x4, [x2, #:lo12:.LANCHOR13]
	bne	.L282
.L302:
	adrp	x1, .LANCHOR31+29
	ldrb	w1, [x1, #:lo12:.LANCHOR31+29]
	cbz	w1, .L279
	add	x0, x0, 8
	add	x0, x4, x0, lsl 8
	str	w1, [x0, 8]
	ret
.L282:
	cmp	w1, 2
	bne	.L284
	adrp	x1, .LANCHOR32
	add	x1, x1, :lo12:.LANCHOR32
	ldrb	w2, [x1, x0]
	cbz	w2, .L279
	strb	wzr, [x1, x0]
	b	.L302
.L284:
	cmp	w1, 3
	bne	.L279
	adrp	x1, .LANCHOR32
	sxtw	x2, w0
	add	x1, x1, :lo12:.LANCHOR32
	ldrb	w3, [x1, x2]
	cbz	w3, .L279
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
.L279:
	ret
	.size	zftl_flash_enter_slc_mode, .-zftl_flash_enter_slc_mode
	.section	.text.zftl_flash_exit_slc_mode,"ax",@progbits
	.align	2
	.global	zftl_flash_exit_slc_mode
	.type	zftl_flash_exit_slc_mode, %function
zftl_flash_exit_slc_mode:
	adrp	x1, .LANCHOR0
	ldrb	w1, [x1, #:lo12:.LANCHOR0]
	cbz	w1, .L303
	adrp	x2, .LANCHOR13
	and	x0, x0, 255
	cmp	w1, 1
	ldr	x4, [x2, #:lo12:.LANCHOR13]
	bne	.L306
	adrp	x1, .LANCHOR31+30
	ldrb	w1, [x1, #:lo12:.LANCHOR31+30]
.L328:
	cbz	w1, .L303
	add	x0, x0, 8
	add	x0, x4, x0, lsl 8
	str	w1, [x0, 8]
	ret
.L306:
	cmp	w1, 2
	bne	.L308
	adrp	x2, .LANCHOR32
	add	x2, x2, :lo12:.LANCHOR32
	ldrb	w1, [x2, x0]
	cbnz	w1, .L303
	adrp	x1, .LANCHOR31
	add	x1, x1, :lo12:.LANCHOR31
	mov	w5, 4
	ldrb	w3, [x1, 12]
	ldrb	w1, [x1, 30]
	cmp	w3, 2
	csel	w3, w3, w5, eq
	strb	w3, [x2, x0]
	b	.L328
.L308:
	cmp	w1, 3
	bne	.L303
	adrp	x2, .LANCHOR32
	sxtw	x5, w0
	add	x2, x2, :lo12:.LANCHOR32
	ldrb	w1, [x2, x5]
	cbnz	w1, .L303
	adrp	x3, .LANCHOR31
	add	x3, x3, :lo12:.LANCHOR31
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
	bne	.L311
	str	w0, [x4, 2048]
.L312:
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
.L311:
	ldrb	w1, [x2, x5]
	str	w1, [x4, 2048]
	b	.L312
.L303:
	ret
	.size	zftl_flash_exit_slc_mode, .-zftl_flash_exit_slc_mode
	.section	.text.flash_start_page_read,"ax",@progbits
	.align	2
	.global	flash_start_page_read
	.type	flash_start_page_read, %function
flash_start_page_read:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	adrp	x0, .LANCHOR18
	stp	x21, x22, [sp, 32]
	ubfx	x22, x1, 21, 3
	and	w19, w1, 2097151
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	ubfx	x21, x1, 24, 2
	cmp	w0, w22
	bhi	.L330
	adrp	x1, .LANCHOR33
	adrp	x0, .LC0
	mov	w2, 845
	add	x1, x1, :lo12:.LANCHOR33
	add	x0, x0, :lo12:.LC0
	bl	printf
.L330:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w8, [x0, w22, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x7, [x0, #:lo12:.LANCHOR13]
	mov	w0, w8
	bl	nandc_cs
	cbnz	w21, .L331
	mov	w0, w19
	bl	slc_phy_page_address_calc
	mov	w19, w0
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L332
	mov	w0, w8
	bl	zftl_flash_enter_slc_mode
.L332:
	ubfiz	x1, x8, 8, 8
	and	w0, w19, 255
	add	x1, x7, x1
	ldp	x21, x22, [sp, 32]
	str	wzr, [x1, 2056]
	str	wzr, [x1, 2052]
	str	wzr, [x1, 2052]
	str	w0, [x1, 2052]
	lsr	w0, w19, 8
	str	w0, [x1, 2052]
	lsr	w19, w19, 16
	str	w19, [x1, 2052]
	str	w20, [x1, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	nandc_de_cs.constprop.29
.L331:
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L333
	sxtw	x0, w8
	add	x0, x0, 8
	add	x0, x7, x0, lsl 8
	str	w21, [x0, 8]
	b	.L332
.L333:
	mov	w0, w8
	bl	zftl_flash_exit_slc_mode
	b	.L332
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
.L340:
	ldr	x0, [x3, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbnz	x0, 9, .L341
	mov	w0, 10
	bl	timer_delay_ns
	subs	w2, w2, #1
	bne	.L340
	mov	w0, -1
.L338:
	ldp	x29, x30, [sp], 32
	ret
.L341:
	mov	w0, 0
	b	.L338
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
.L345:
	cmp	w4, w0
	bhi	.L348
	ldp	x29, x30, [sp], 16
	b	nandc_wait_flash_ready
.L348:
	cmp	w5, 67
	bne	.L346
	ldrsb	w6, [x1, x0]
.L350:
	add	x0, x0, 1
	str	w6, [x3]
	b	.L345
.L346:
	ldrsb	w6, [x2, x0]
	b	.L350
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
	adrp	x0, .LANCHOR34
	add	x0, x0, :lo12:.LANCHOR34
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
	adrp	x2, .LANCHOR35
	add	x2, x2, :lo12:.LANCHOR35
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
	cbz	w2, .L355
	stp	x29, x30, [sp, -16]!
	mov	x4, x0
	mov	x2, 7
	mov	w0, 18
	add	x29, sp, 0
	str	w6, [x4, 8]
	mul	x1, x1, x2
	str	w0, [x4, 4]
	adrp	x0, .LANCHOR36
	add	x0, x0, :lo12:.LANCHOR36
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
.L358:
	b	nandc_wait_flash_ready
.L355:
	str	w6, [x0, 8]
	mov	w2, 20
	str	w2, [x0, 4]
	adrp	x2, .LANCHOR37
	add	x2, x2, :lo12:.LANCHOR37
	ldrb	w1, [x2, x1]
	str	w1, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	b	.L358
	.size	toshiba_tlc_set_rr_para, .-toshiba_tlc_set_rr_para
	.section	.text.flash_erase_duplane_block,"ax",@progbits
	.align	2
	.global	flash_erase_duplane_block
	.type	flash_erase_duplane_block, %function
flash_erase_duplane_block:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 255
	adrp	x0, .LANCHOR18
	stp	x21, x22, [sp, 32]
	str	x25, [sp, 64]
	mov	w21, w2
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	mov	w20, w3
	stp	x23, x24, [sp, 48]
	and	w25, w1, 255
	cmp	w0, w19
	bhi	.L362
	adrp	x1, .LANCHOR38
	adrp	x0, .LC0
	mov	w2, 588
	add	x1, x1, :lo12:.LANCHOR38
	add	x0, x0, :lo12:.LC0
	bl	printf
.L362:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w22, [x0, w19, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x24, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR14
	and	x19, x22, 255
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	add	x23, x19, 8
	add	x23, x24, x23, lsl 8
	tbz	x0, 4, .L363
	adrp	x0, .LC32
	mov	w3, w20
	mov	w2, w21
	mov	w1, w22
	add	x0, x0, :lo12:.LC32
	bl	printf
.L363:
	bl	nandc_wait_flash_ready
	mov	w0, w22
	bl	nandc_cs
	mov	w0, w22
	cbnz	w25, .L364
	bl	zftl_flash_enter_slc_mode
.L365:
	add	x24, x24, x19, lsl 8
	mov	w0, 96
	str	w0, [x24, 2056]
	and	w0, w21, 255
	str	w0, [x24, 2052]
	lsr	w0, w21, 8
	str	w0, [x24, 2052]
	lsr	w0, w21, 16
	str	w0, [x24, 2052]
	adrp	x0, .LANCHOR39
	ldrb	w0, [x0, #:lo12:.LANCHOR39]
	cbnz	w0, .L368
	mov	w0, 208
	str	w0, [x24, 2056]
	mov	w19, 5
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	and	w5, w0, w19
.L366:
	mov	w0, 96
	str	w0, [x24, 2056]
	and	w0, w20, 255
	str	w0, [x24, 2052]
	lsr	w0, w20, 8
	str	w0, [x24, 2052]
	lsr	w20, w20, 16
	str	w20, [x24, 2052]
	mov	w0, 208
	str	w0, [x24, 2056]
	mov	w19, 5
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	mov	w2, w0
	bl	nandc_de_cs.constprop.29
	and	w19, w2, w19
	orr	w19, w19, w5
	cbz	w19, .L367
	adrp	x0, .LC33
	mov	w1, w21
	add	x0, x0, :lo12:.LC33
	bl	printf
.L367:
	mov	w0, w19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L364:
	bl	zftl_flash_exit_slc_mode
	b	.L365
.L368:
	mov	w5, 0
	b	.L366
	.size	flash_erase_duplane_block, .-flash_erase_duplane_block
	.section	.text.flash_erase_block_en,"ax",@progbits
	.align	2
	.global	flash_erase_block_en
	.type	flash_erase_block_en, %function
flash_erase_block_en:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w23, w0, 255
	adrp	x0, .LANCHOR18
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	mov	w21, w2
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	and	w26, w1, 255
	stp	x19, x20, [sp, 16]
	and	w22, w2, 2097151
	cmp	w0, w23
	bhi	.L377
	adrp	x1, .LANCHOR40
	adrp	x0, .LC0
	mov	w2, 633
	add	x1, x1, :lo12:.LANCHOR40
	add	x0, x0, :lo12:.LC0
	bl	printf
.L377:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w20, [x0, w23, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x25, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR14
	and	x19, x20, 255
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	add	x24, x19, 8
	add	x24, x25, x24, lsl 8
	tbz	x0, 4, .L378
	adrp	x0, .LC34
	mov	w3, w26
	mov	w2, w21
	mov	w1, w20
	add	x0, x0, :lo12:.LC34
	bl	printf
.L378:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w26, .L379
	bl	zftl_flash_enter_slc_mode
.L380:
	add	x0, x25, x19, lsl 8
	mov	w1, 96
	str	w1, [x0, 2056]
	and	w1, w21, 255
	str	w1, [x0, 2052]
	lsr	w1, w22, 8
	str	w1, [x0, 2052]
	lsr	w22, w22, 16
	str	w22, [x0, 2052]
	mov	w1, 208
	str	w1, [x0, 2056]
	bl	nandc_wait_flash_ready
	mov	x0, x24
	bl	flash_read_status
	mov	w19, w0
	bl	nandc_de_cs.constprop.29
	mov	w0, 5
	ands	w19, w19, w0
	beq	.L381
	adrp	x0, .LANCHOR2
	mov	w3, w19
	mov	w1, w23
	ldrh	w2, [x0, #:lo12:.LANCHOR2]
	adrp	x0, .LC35
	add	x0, x0, :lo12:.LC35
	udiv	w2, w21, w2
	bl	printf
.L381:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L379:
	bl	zftl_flash_exit_slc_mode
	b	.L380
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
	adrp	x0, .LANCHOR31
	add	x0, x0, :lo12:.LANCHOR31
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
.L391:
	ldrb	w0, [x22]
	cmp	w0, w19
	bhi	.L394
	ldp	x19, x20, [sp, 16]
	mov	w1, 0
	ldp	x21, x22, [sp, 32]
	adrp	x0, .LC36
	ldp	x23, x24, [sp, 48]
	add	x0, x0, :lo12:.LC36
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	b	printf
.L394:
	add	x0, x24, :lo12:.LANCHOR30
	mov	w21, 0
	ldrb	w25, [x0, w19, sxtw]
.L392:
	cmp	w20, w21, uxth
	bhi	.L393
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L391
.L393:
	ldrh	w1, [x23]
	mov	w0, w25
	mul	w1, w1, w21
	add	w21, w21, 1
	bl	flash_erase_block
	b	.L392
	.size	flash_erase_all, .-flash_erase_all
	.section	.text.flash_start_plane_read,"ax",@progbits
	.align	2
	.global	flash_start_plane_read
	.type	flash_start_plane_read, %function
flash_start_plane_read:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ubfx	x19, x0, 24, 2
	stp	x21, x22, [sp, 32]
	ubfx	x22, x0, 21, 3
	and	w21, w0, 2097151
	adrp	x0, .LANCHOR18
	and	w20, w1, 2097151
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	cmp	w0, w22
	bhi	.L397
	adrp	x1, .LANCHOR41
	adrp	x0, .LC0
	mov	w2, 940
	add	x1, x1, :lo12:.LANCHOR41
	add	x0, x0, :lo12:.LC0
	bl	printf
.L397:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w7, [x0, w22, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x10, [x0, #:lo12:.LANCHOR13]
	mov	w0, w7
	bl	nandc_cs
	adrp	x8, .LANCHOR16
	cbnz	w19, .L398
	mov	w0, w21
	bl	slc_phy_page_address_calc
	mov	w21, w0
	mov	w0, w20
	bl	slc_phy_page_address_calc
	mov	w20, w0
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L399
	mov	w0, w7
	bl	zftl_flash_enter_slc_mode
.L399:
	adrp	x0, .LANCHOR20
	and	x4, x7, 255
	add	x1, x0, :lo12:.LANCHOR20
	add	x4, x10, x4, lsl 8
	and	w3, w21, 255
	and	w6, w20, 255
	lsr	w5, w20, 8
	lsr	w20, w20, 16
	ldrb	w11, [x1, 8]
	ldrb	w2, [x1, 16]
	str	w11, [x4, 2056]
	cmp	w2, 1
	lsr	w2, w21, 8
	lsr	w21, w21, 16
	bne	.L401
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	str	w3, [x4, 2052]
	str	w2, [x4, 2052]
	ldrb	w0, [x1, 9]
	str	w21, [x4, 2052]
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	ldr	x0, [x8, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L402
	cbz	w19, .L402
	str	w19, [x4, 2056]
.L402:
	str	wzr, [x4, 2056]
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
.L415:
	ldp	x21, x22, [sp, 32]
	str	w6, [x4, 2052]
	str	w5, [x4, 2052]
	mov	w0, 48
	str	w20, [x4, 2052]
	str	w0, [x4, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	nandc_de_cs.constprop.29
.L398:
	ldr	x0, [x8, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L400
	sxtw	x0, w7
	add	x0, x0, 8
	add	x0, x10, x0, lsl 8
	str	w19, [x0, 8]
	b	.L399
.L400:
	mov	w0, w7
	bl	zftl_flash_exit_slc_mode
	b	.L399
.L401:
	str	w3, [x4, 2052]
	ldr	x1, [x8, #:lo12:.LANCHOR16]
	str	w2, [x4, 2052]
	str	w21, [x4, 2052]
	ldrb	w1, [x1, 12]
	cmp	w1, 3
	bne	.L404
	cbz	w19, .L404
	str	w19, [x4, 2056]
.L404:
	add	x0, x0, :lo12:.LANCHOR20
	ldrb	w0, [x0, 9]
	str	w0, [x4, 2056]
	b	.L415
	.size	flash_start_plane_read, .-flash_start_plane_read
	.section	.text.flash_set_interface_mode,"ax",@progbits
	.align	2
	.global	flash_set_interface_mode
	.type	flash_set_interface_mode, %function
flash_set_interface_mode:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR42
	stp	x19, x20, [sp, 16]
	adrp	x21, .LANCHOR14
	stp	x23, x24, [sp, 48]
	adrp	x20, .LANCHOR43
	mov	w23, w0
	add	x22, x22, :lo12:.LANCHOR42
	add	x20, x20, :lo12:.LANCHOR43
	add	x21, x21, :lo12:.LANCHOR14
	str	x25, [sp, 64]
	mov	x25, 0
.L429:
	adrp	x0, .LANCHOR13
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	lsl	x0, x25, 3
	ldrb	w24, [x0, x22]
	cmp	w24, 69
	beq	.L417
	add	w0, w24, 119
	cmp	w24, 44
	and	w1, w0, 255
	cset	w2, eq
	cmp	w1, 18
	bhi	.L430
	mov	x0, 32769
	movk	x0, 0x4, lsl 16
	lsr	x0, x0, x1
	mvn	x0, x0
.L418:
	and	w0, w0, 1
	eor	w0, w0, 1
	orr	w0, w2, w0
	cbz	w0, .L419
.L417:
	ldrb	w1, [x20]
	cmp	w23, 1
	bne	.L420
	tbz	x1, 0, .L419
	ldr	w0, [x21]
	tbz	x0, 12, .L421
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	bl	printf
.L421:
	add	x0, x19, x25, lsl 8
	mov	w1, 239
	cmp	w24, 44
	str	w1, [x0, 2056]
	mov	w1, 137
	ccmp	w24, w1, 4, ne
	mov	w1, 1
	bne	.L422
	str	w1, [x0, 2052]
	mov	w1, 5
.L452:
	str	w1, [x0, 2048]
.L427:
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
.L419:
	add	x25, x25, 1
	cmp	x25, 4
	bne	.L429
	bl	nandc_wait_flash_ready
	ldr	x25, [sp, 64]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L430:
	mov	x0, 1
	b	.L418
.L422:
	cmp	w24, 155
	bne	.L424
	str	w1, [x0, 2052]
	mov	w1, 3
	b	.L452
.L424:
	mov	w2, 128
	str	w2, [x0, 2052]
	b	.L452
.L420:
	tbz	x1, 2, .L419
	ldr	w0, [x21]
	tbz	x0, 12, .L425
	adrp	x0, .LC38
	add	x0, x0, :lo12:.LC38
	bl	printf
.L425:
	add	x0, x19, x25, lsl 8
	mov	w1, 239
	cmp	w24, 44
	str	w1, [x0, 2056]
	mov	w1, 137
	ccmp	w24, w1, 4, ne
	bne	.L426
	mov	w1, 1
	str	w1, [x0, 2052]
	mov	w1, 35
	b	.L452
.L426:
	cmp	w24, 155
	bne	.L428
	mov	w1, 1
	str	w1, [x0, 2052]
	mov	w1, 37
	b	.L452
.L428:
	mov	w1, 128
	str	w1, [x0, 2052]
	str	wzr, [x0, 2048]
	b	.L427
	.size	flash_set_interface_mode, .-flash_set_interface_mode
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
	bl	nandc_de_cs.constprop.29
	ldrb	w2, [x8]
	sub	w0, w2, #1
	and	w0, w0, 255
	cmp	w0, 253
	bhi	.L454
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
.L454:
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
	adrp	x2, .LANCHOR31+9
	ubfiz	x0, x0, 8, 8
	add	x29, sp, 0
	ldrb	w3, [x2, #:lo12:.LANCHOR31+9]
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
.L460:
	ldr	w1, [x19, 2048]
	strb	w1, [x21, x0]
	add	x0, x0, 1
	cmp	x0, 16384
	bne	.L460
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
	b	nandc_de_cs.constprop.29
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
	adrp	x1, .LANCHOR31+29
	str	x19, [sp, 16]
	mov	x0, x2
	ldrb	w1, [x1, #:lo12:.LANCHOR31+29]
	add	x2, x2, 8
	add	x2, x4, x2, lsl 8
	cbz	w1, .L464
.L474:
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
	beq	.L463
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L463
	adrp	x0, .LC41
	mov	w1, w5
	add	x0, x0, :lo12:.LC41
	bl	printf
.L463:
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L464:
	mov	w1, 162
	b	.L474
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
	adrp	x2, .LANCHOR44
	mov	w1, 1
	strb	w0, [x2, #:lo12:.LANCHOR44]
	adrp	x2, .LANCHOR28
	ldrb	w2, [x2, #:lo12:.LANCHOR28]
	cmp	w2, 9
	adrp	x2, .LANCHOR13
	ldr	x2, [x2, #:lo12:.LANCHOR13]
	bne	.L478
	str	w1, [x2, 16]
	cmp	w0, 70
	beq	.L485
	cmp	w0, 60
	beq	.L486
	cmp	w0, 40
	cset	w1, eq
	add	w1, w1, 1
.L479:
	lsl	w1, w1, 25
	orr	w1, w1, 1
	str	w1, [x2, 32]
	ret
.L485:
	mov	w1, 0
	b	.L479
.L486:
	mov	w1, 3
	b	.L479
.L478:
	str	w1, [x2, 8]
	cmp	w0, 16
	mov	w1, 4096
	bne	.L481
.L484:
	and	w1, w1, -17
.L482:
	orr	w1, w1, 1
	str	w1, [x2, 12]
	ret
.L481:
	cmp	w0, 24
	bne	.L483
	orr	w1, w1, 16
	b	.L482
.L483:
	orr	w1, w1, 262144
	cmp	w0, 40
	orr	w1, w1, 16
	bne	.L482
	b	.L484
	.size	nandc_bch_sel, .-nandc_bch_sel
	.section	.text.zftl_nandc_get_irq_status,"ax",@progbits
	.align	2
	.global	zftl_nandc_get_irq_status
	.type	zftl_nandc_get_irq_status, %function
zftl_nandc_get_irq_status:
	adrp	x1, .LANCHOR28
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	cmp	w1, 9
	bne	.L492
	ldr	w0, [x0, 296]
	ret
.L492:
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
	stp	x29, x30, [sp, -64]!
	and	w1, w1, 255
	adrp	x4, .LANCHOR47
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w23, w0, 255
	adrp	x0, .LANCHOR28
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	add	w20, w1, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	adrp	x24, .LANCHOR13
	cmp	w0, 9
	bne	.L498
	ubfiz	w19, w23, 1, 1
	mov	w0, 1
	orr	w19, w19, 8
	asr	w20, w20, 1
	bfi	w19, w0, 5, 2
	adrp	x0, .LANCHOR45
	orr	w19, w19, 536870912
	orr	w19, w19, 1024
	ldrb	w0, [x0, #:lo12:.LANCHOR45]
	and	w19, w19, -17
	bfi	w19, w20, 22, 6
	orr	w19, w19, 128
	cbz	w0, .L499
	adrp	x0, .LANCHOR46
	ldrb	w1, [x0, #:lo12:.LANCHOR46]
	orr	w0, w19, 512
	cmp	w1, 0
	csel	w19, w0, w19, ne
.L499:
	add	x21, x4, :lo12:.LANCHOR47
	add	x0, x2, 63
	and	w20, w20, 63
	and	x0, x0, -64
	ubfiz	x1, x20, 10, 6
	ubfiz	x20, x20, 2, 6
	add	x1, x0, x1
	stp	x2, x3, [x21, 8]
	and	x0, x2, -64
	stp	w2, w3, [x21, 24]
	bl	flush_dcache_range
	ldr	x0, [x21, 16]
	add	x1, x0, 63
	and	x0, x0, -64
	and	x1, x1, -64
	add	x1, x1, x20
	bl	flush_dcache_range
	ldr	x1, [x24, #:lo12:.LANCHOR13]
	mov	w0, 1
	str	w0, [x21, 32]
	mov	w2, 16
	ldr	w0, [x21, 24]
	cmp	w23, 0
	str	w0, [x1, 52]
	ldr	w0, [x21, 28]
	str	w0, [x1, 56]
	ldr	w0, [x1, 48]
	bfi	w0, w2, 9, 5
	mov	w2, 2
	orr	w0, w0, 448
	bfi	w0, w2, 3, 3
	cset	w2, eq
	orr	w0, w0, 4
	bfi	w0, w2, 1, 1
	adrp	x2, .LANCHOR48
	orr	w0, w0, 1
	ldrh	w2, [x2, #:lo12:.LANCHOR48]
	bfi	w0, w2, 16, 11
	str	w0, [x1, 48]
	str	w19, [x1, 16]
	orr	w19, w19, 4
	str	w19, [x1, 16]
.L497:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L498:
	ldr	x0, [x24, #:lo12:.LANCHOR13]
	ubfiz	w19, w23, 1, 1
	orr	w19, w19, 8
	asr	w20, w20, 1
	ldr	w22, [x0, 12]
	mov	w0, 16
	bfi	w22, w0, 8, 8
	mov	w0, 1
	bfi	w19, w0, 5, 2
	and	w22, w22, -9
	orr	w19, w19, 536870912
	and	w22, w22, -225
	orr	w19, w19, 1024
	and	w19, w19, -17
	bfi	w19, w20, 22, 6
	cbz	w23, .L501
	adrp	x0, .LANCHOR44
	ubfx	x1, x1, 1, 7
	ldr	x8, [x4, #:lo12:.LANCHOR47]
	add	x1, x3, x1, lsl 2
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	mov	w5, 128
	cmp	w0, 24
	mov	w0, 64
	csel	w5, w5, w0, hi
	mov	w0, 0
.L503:
	add	w7, w5, w0
	cmp	x3, x1
	bne	.L504
.L505:
	add	x21, x4, :lo12:.LANCHOR47
	ldr	x0, [x4, #:lo12:.LANCHOR47]
	and	w20, w20, 63
	ubfiz	x1, x20, 10, 6
	ubfiz	x20, x20, 7, 6
	stp	x2, x0, [x21, 8]
	stp	w2, w0, [x21, 24]
	add	x0, x2, 63
	and	x0, x0, -64
	add	x1, x0, x1
	and	x0, x2, -64
	bl	flush_dcache_range
	ldr	x0, [x21, 16]
	add	x1, x0, 63
	and	x0, x0, -64
	and	x1, x1, -64
	add	x1, x1, x20
	bl	flush_dcache_range
	ldr	x1, [x24, #:lo12:.LANCHOR13]
	mov	w0, 1
	str	w0, [x21, 32]
	cmp	w23, 0
	ldr	w0, [x21, 24]
	cset	w2, eq
	str	w0, [x1, 20]
	ldr	w0, [x21, 28]
	str	w0, [x1, 24]
	mov	w0, 8660
	bfi	w0, w2, 1, 1
	orr	w0, w0, 1
	str	w0, [x1, 16]
	str	w22, [x1, 12]
	str	w19, [x1, 8]
	orr	w19, w19, 4
	str	w19, [x1, 8]
	b	.L497
.L504:
	ldrh	w10, [x3]
	and	x0, x0, 4294967292
	ldrh	w6, [x3, 2]
	add	x3, x3, 4
	orr	x6, x10, x6, lsl 16
	str	w6, [x8, x0]
	mov	w0, w7
	b	.L503
.L501:
	ldr	x1, [x4, #:lo12:.LANCHOR47]
	str	w0, [x1]
	b	.L505
	.size	nandc_xfer_start, .-nandc_xfer_start
	.section	.text.nandc_set_seed,"ax",@progbits
	.align	2
	.global	nandc_set_seed
	.type	nandc_set_seed, %function
nandc_set_seed:
	and	x0, x0, 127
	adrp	x1, .LANCHOR49
	add	x1, x1, :lo12:.LANCHOR49
	ldrh	w0, [x1, x0, lsl 1]
	adrp	x1, .LANCHOR46
	ldrb	w2, [x1, #:lo12:.LANCHOR46]
	orr	w1, w0, -1073741824
	cmp	w2, 0
	csel	w0, w1, w0, ne
	adrp	x1, .LANCHOR28
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	cmp	w1, 9
	adrp	x1, .LANCHOR13
	ldr	x1, [x1, #:lo12:.LANCHOR13]
	bne	.L515
	str	w0, [x1, 520]
	ret
.L515:
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
	cbz	w0, .L520
	adrp	x0, .LANCHOR19
	ldrb	w0, [x0, #:lo12:.LANCHOR19]
	cbnz	w0, .L520
	bl	zftl_flash_exit_slc_mode
.L520:
	adrp	x19, .LANCHOR21
	mov	w0, 0
	bl	hynix_reconfig_rr_para
	ldrb	w0, [x19, #:lo12:.LANCHOR21]
	cbz	w0, .L521
	adrp	x0, .LANCHOR43
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	tbz	x0, 0, .L521
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
	bl	nandc_set_if_mode
	strb	wzr, [x19, #:lo12:.LANCHOR21]
.L521:
	adrp	x3, .LANCHOR46
	ldrb	w0, [x3, #:lo12:.LANCHOR46]
	cbz	w0, .L522
	mov	w0, 0
	strb	wzr, [x3, #:lo12:.LANCHOR46]
	bl	nandc_set_seed
	mov	w0, 1
	strb	w0, [x3, #:lo12:.LANCHOR46]
.L522:
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
	adrp	x1, .LANCHOR46
	strb	w0, [x1, #:lo12:.LANCHOR46]
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
	adrp	x0, .LANCHOR50
	add	x1, x0, :lo12:.LANCHOR50
	mov	w2, 0
.L539:
	and	w3, w2, 255
	strb	wzr, [x1, 2]
	add	w4, w3, 1
	strb	w3, [x1, 1]
	strb	w4, [x1]
	add	w2, w2, 1
	str	xzr, [x1, 16]
	cmp	w2, 32
	add	x1, x1, 64
	bne	.L539
	add	x0, x0, :lo12:.LANCHOR50
	mov	w1, -1
	strb	w1, [x0, 1984]
	adrp	x0, .LANCHOR51
	strb	wzr, [x0, #:lo12:.LANCHOR51]
	adrp	x0, .LANCHOR52
	strb	w2, [x0, #:lo12:.LANCHOR52]
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
	bne	.L547
	ldrb	w0, [x20, 1]
	cmp	w0, 255
	bne	.L543
	adrp	x1, .LANCHOR53
	adrp	x0, .LC0
	mov	w2, 74
	add	x1, x1, :lo12:.LANCHOR53
	add	x0, x0, :lo12:.LC0
	bl	printf
.L543:
	ldrb	w0, [x20, 1]
	strb	w0, [x19]
.L541:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L547:
	adrp	x0, .LANCHOR50
	add	x2, x0, :lo12:.LANCHOR50
	mov	x19, x0
.L548:
	sbfiz	x0, x1, 6, 32
	mov	w21, w1
	ldrb	w1, [x2, x0]
	cmp	w1, 255
	bne	.L548
	ldrb	w0, [x20, 1]
	cmp	w0, 255
	bne	.L545
	adrp	x1, .LANCHOR53
	adrp	x0, .LC0
	mov	w2, 81
	add	x1, x1, :lo12:.LANCHOR53
	add	x0, x0, :lo12:.LC0
	bl	printf
.L545:
	add	x0, x19, :lo12:.LANCHOR50
	sbfiz	x21, x21, 6, 32
	ldrb	w1, [x20, 1]
	strb	w1, [x0, x21]
	b	.L541
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
	adrp	x0, .LANCHOR54
	ldr	x19, [sp, 16]
	add	x0, x0, :lo12:.LANCHOR54
	ldp	x29, x30, [sp], 32
	b	buf_add_tail
	.size	queue_read_cmd, .-queue_read_cmd
	.section	.text.buf_free,"ax",@progbits
	.align	2
	.global	buf_free
	.type	buf_free, %function
buf_free:
	ldrb	w1, [x0, 2]
	adrp	x2, .LANCHOR51
	and	w1, w1, 8
	strb	w1, [x0, 2]
	cbz	w1, .L553
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L553
	stp	x29, x30, [sp, -16]!
	mov	x1, x0
	add	x0, x2, :lo12:.LANCHOR51
	add	x29, sp, 0
	bl	buf_add_tail
	adrp	x1, .LANCHOR52
	ldp	x29, x30, [sp], 16
	ldrb	w0, [x1, #:lo12:.LANCHOR52]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR52]
	ret
.L553:
	ldrb	w1, [x2, #:lo12:.LANCHOR51]
	strb	w1, [x0]
	adrp	x1, .LANCHOR52
	ldrb	w0, [x0, 1]
	strb	w0, [x2, #:lo12:.LANCHOR51]
	ldrb	w0, [x1, #:lo12:.LANCHOR52]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR52]
	ret
	.size	buf_free, .-buf_free
	.section	.text.buf_alloc,"ax",@progbits
	.align	2
	.global	buf_alloc
	.type	buf_alloc, %function
buf_alloc:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR52
	and	w20, w0, 255
	ldrb	w0, [x19, #:lo12:.LANCHOR52]
	cbz	w0, .L566
.L569:
	adrp	x2, .LANCHOR51
	adrp	x1, .LANCHOR50
	add	x0, x1, :lo12:.LANCHOR50
	ldrb	w3, [x2, #:lo12:.LANCHOR51]
	ubfiz	x4, x3, 6, 8
	add	x0, x0, x4
	mov	x4, x2
	cbz	w20, .L567
.L568:
	add	x1, x1, :lo12:.LANCHOR50
	sbfiz	x3, x3, 6, 32
	add	x2, x1, x3
	ldrb	w5, [x1, x3]
	strb	w5, [x4, #:lo12:.LANCHOR51]
	ldrb	w4, [x19, #:lo12:.LANCHOR52]
	strh	wzr, [x2, 50]
	sub	w4, w4, #1
	strb	w4, [x19, #:lo12:.LANCHOR52]
	mov	w4, 1
	strb	wzr, [x2, 56]
	strb	w4, [x2, 2]
	mov	w4, -1
	strb	wzr, [x2, 57]
	strb	w4, [x1, x3]
	mov	w1, -1
	str	xzr, [x2, 16]
	str	w1, [x2, 36]
	b	.L565
.L566:
	mov	w2, 121
	adrp	x1, .LANCHOR55
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR55
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldrb	w0, [x19, #:lo12:.LANCHOR52]
	cbnz	w0, .L569
.L571:
	mov	x0, 0
.L565:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L567:
	ldrb	w2, [x19, #:lo12:.LANCHOR52]
	cmp	w2, 1
	bne	.L568
	b	.L571
	.size	buf_alloc, .-buf_alloc
	.section	.text.buf_remove_buf,"ax",@progbits
	.align	2
	.global	buf_remove_buf
	.type	buf_remove_buf, %function
buf_remove_buf:
	ldrb	w4, [x1, 1]
	ldrb	w2, [x0]
	cmp	w4, w2
	bne	.L579
	ldrb	w1, [x1]
	strb	w1, [x0]
.L583:
	mov	w0, 1
	ret
.L580:
	mov	w3, w2
	sbfiz	x2, x2, 6, 32
	ldrb	w2, [x0, x2]
	cmp	w4, w2
	bne	.L581
	sbfiz	x3, x3, 6, 32
	ldrb	w2, [x1]
	strb	w2, [x0, x3]
	mov	w0, -1
	strb	w0, [x1]
	b	.L583
.L579:
	adrp	x0, .LANCHOR50
	add	x0, x0, :lo12:.LANCHOR50
.L581:
	cmp	w2, 255
	bne	.L580
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
	adrp	x19, .LANCHOR52
	mov	x20, x0
	ldrb	w0, [x19, #:lo12:.LANCHOR52]
	cbnz	w0, .L585
	adrp	x1, .LANCHOR56
	adrp	x0, .LC0
	mov	w2, 172
	add	x1, x1, :lo12:.LANCHOR56
	add	x0, x0, :lo12:.LC0
	bl	printf
.L585:
	ldrb	w0, [x19, #:lo12:.LANCHOR52]
	cbz	w0, .L584
	mov	x1, x20
	adrp	x0, .LANCHOR51
	add	x0, x0, :lo12:.LANCHOR51
	bl	buf_remove_buf
	cmp	w0, 1
	bne	.L584
	ldrb	w0, [x19, #:lo12:.LANCHOR52]
	sub	w0, w0, #1
	strb	w0, [x19, #:lo12:.LANCHOR52]
	ldrb	w0, [x20, 2]
	orr	w0, w0, 1
	strb	w0, [x20, 2]
.L584:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	buf_remove_free, .-buf_remove_free
	.section	.text.flash_check_bad_block,"ax",@progbits
	.align	2
	.global	flash_check_bad_block
	.type	flash_check_bad_block, %function
flash_check_bad_block:
	adrp	x3, .LANCHOR31
	add	x3, x3, :lo12:.LANCHOR31
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
	adrp	x0, .LANCHOR31
	add	x0, x0, :lo12:.LANCHOR31
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
	adrp	x0, .LANCHOR57
	add	x0, x0, :lo12:.LANCHOR57
	bl	buf_add_tail
	adrp	x1, .LANCHOR58
	ldp	x29, x30, [sp], 16
	ldrb	w0, [x1, #:lo12:.LANCHOR58]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x1, #:lo12:.LANCHOR58]
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
	cbnz	w0, .L597
	adrp	x0, .LANCHOR59
	ldr	w0, [x0, #:lo12:.LANCHOR59]
	ret
.L597:
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
	adrp	x0, .LANCHOR60
	ldrh	w0, [x0, #:lo12:.LANCHOR60]
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
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 65535
	adrp	x0, .LANCHOR6
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	and	w24, w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	and	w25, w2, 65535
	stp	x21, x22, [sp, 32]
	str	x27, [sp, 80]
	cmp	w0, w20
	bhi	.L606
	adrp	x1, .LANCHOR61
	adrp	x0, .LC0
	mov	w2, 339
	add	x1, x1, :lo12:.LANCHOR61
	add	x0, x0, :lo12:.LC0
	bl	printf
.L606:
	adrp	x22, .LANCHOR9
	uxtw	x19, w20
	lsl	x26, x19, 1
	adrp	x23, .LANCHOR14
	ldr	x0, [x22, #:lo12:.LANCHOR9]
	adrp	x27, .LANCHOR7
	ldrh	w21, [x0, x26]
	ldr	w0, [x23, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L607
	ldr	x0, [x27, #:lo12:.LANCHOR7]
	mov	w4, w21
	mov	w2, w24
	mov	w1, w20
	add	x0, x0, x19, lsl 2
	ldrb	w3, [x0, 2]
	adrp	x0, .LANCHOR62
	ldrh	w6, [x0, #:lo12:.LANCHOR62]
	adrp	x0, .LANCHOR63+56
	ubfx	x3, x3, 5, 3
	ldrh	w5, [x0, #:lo12:.LANCHOR63+56]
	adrp	x0, .LC43
	add	x0, x0, :lo12:.LC43
	bl	printf
.L607:
	ldr	x0, [x27, #:lo12:.LANCHOR7]
	add	x19, x0, x19, lsl 2
	ldrb	w2, [x19, 2]
	tst	w2, 224
	bne	.L608
	cbz	w21, .L628
	adrp	x1, .LANCHOR61
	adrp	x0, .LC0
	mov	w2, 344
	add	x1, x1, :lo12:.LANCHOR61
	add	x0, x0, :lo12:.LC0
	bl	printf
.L628:
	mov	w0, 0
	b	.L605
.L608:
	adrp	x0, .LANCHOR63
	add	x1, x0, :lo12:.LANCHOR63
	ldrh	w0, [x0, #:lo12:.LANCHOR63]
	cmp	w0, w20
	beq	.L628
	adrp	x21, .LANCHOR10
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	ldrh	w3, [x0, 48]
	cmp	w3, w20
	beq	.L628
	ldrh	w3, [x0, 16]
	cmp	w3, w20
	beq	.L628
	ldrh	w3, [x0, 80]
	cmp	w3, w20
	beq	.L628
	ldrh	w4, [x1, 56]
	add	x1, x1, 58
	mov	w3, 0
.L610:
	cmp	w3, w4
	bcc	.L611
	cbnz	w24, .L615
	adrp	x1, .LANCHOR64
	ldrh	w5, [x1, #:lo12:.LANCHOR64]
	cmp	w20, w5
	beq	.L628
	adrp	x3, .LANCHOR65
	add	x3, x3, :lo12:.LANCHOR65
	mov	x1, 0
.L614:
	ldrh	w6, [x1, x3]
	cmp	w20, w6
	bne	.L613
	ldr	w0, [x23, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L628
	ldr	x0, [x22, #:lo12:.LANCHOR9]
	mov	w4, w20
	ubfx	x2, x2, 5, 3
	mov	w1, w20
	ldrh	w3, [x0, x26]
	adrp	x0, .LC44
	add	x0, x0, :lo12:.LC44
	bl	printf
	b	.L628
.L611:
	ldrh	w5, [x1], 2
	cmp	w5, w20
	beq	.L628
	add	w3, w3, 1
	b	.L610
.L613:
	add	x1, x1, 2
	cmp	x1, 16
	bne	.L614
	ubfiz	x19, x25, 7, 16
	add	x19, x19, 136
	add	x19, x0, x19
.L616:
	ldr	w0, [x23, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L617
	ldr	x0, [x22, #:lo12:.LANCHOR9]
	adrp	x1, .LANCHOR62
	mov	w5, w4
	ubfx	x3, x2, 5, 3
	ldrh	w6, [x1, #:lo12:.LANCHOR62]
	mov	w2, w24
	mov	w1, w20
	ldrh	w4, [x0, x26]
	adrp	x0, .LC43
	add	x0, x0, :lo12:.LC43
	bl	printf
.L617:
	mov	x0, x19
	add	x1, x19, 128
	mov	w2, 65535
.L620:
	ldrh	w3, [x0]
	cmp	w3, w2
	bne	.L618
	strh	w20, [x0]
	cbz	w24, .L619
	ldr	x1, [x21, #:lo12:.LANCHOR10]
	ldrh	w0, [x1, 124]
	add	w0, w0, 1
	strh	w0, [x1, 124]
.L638:
	mov	w0, 1
.L605:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L615:
	add	x19, x0, 392
	b	.L616
.L619:
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	add	x25, x0, x25, uxth 1
	ldrh	w0, [x25, 120]
	add	w0, w0, 1
	strh	w0, [x25, 120]
	b	.L638
.L618:
	add	x0, x0, 2
	cmp	x1, x0
	bne	.L620
	b	.L638
	.size	gc_add_sblk, .-gc_add_sblk
	.section	.text.gc_mark_bad_ppa,"ax",@progbits
	.align	2
	.global	gc_mark_bad_ppa
	.type	gc_mark_bad_ppa, %function
gc_mark_bad_ppa:
	stp	x29, x30, [sp, -64]!
	adrp	x1, .LANCHOR66
	mov	w3, w0
	add	x29, sp, 0
	ldrh	w1, [x1, #:lo12:.LANCHOR66]
	stp	x19, x20, [sp, 16]
	mov	w19, 21
	sub	w19, w19, w1
	str	x23, [sp, 48]
	lsr	w2, w0, w1
	adrp	x1, .LANCHOR67
	mov	w23, 1
	stp	x21, x22, [sp, 32]
	ldrb	w1, [x1, #:lo12:.LANCHOR67]
	lsl	w19, w23, w19
	sub	w19, w19, #1
	adrp	x20, .LANCHOR63
	and	w19, w19, w2
	add	x21, x20, :lo12:.LANCHOR63
	and	w22, w2, 65535
	adrp	x0, .LC45
	mov	w2, w22
	add	x0, x0, :lo12:.LC45
	udiv	w19, w19, w1
	ldr	w1, [x21, 328]
	and	w19, w19, 65535
	bl	printf
	mov	w1, w23
	mov	w2, 0
	mov	w0, w19
	bl	gc_add_sblk
	ldr	w0, [x21, 328]
	mov	w1, 0
.L640:
	cmp	w1, w0
	bcc	.L642
	cmp	w0, 5
	bhi	.L641
	add	x20, x20, :lo12:.LANCHOR63
	add	w1, w0, 1
	str	w1, [x20, 328]
	add	x20, x20, x0, uxtw 1
	strh	w22, [x20, 332]
.L641:
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L642:
	add	x2, x21, x1, sxtw 1
	ldrh	w2, [x2, 332]
	cmp	w2, w22
	beq	.L641
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L640
	.size	gc_mark_bad_ppa, .-gc_mark_bad_ppa
	.section	.text.gc_get_src_ppa_from_index,"ax",@progbits
	.align	2
	.global	gc_get_src_ppa_from_index
	.type	gc_get_src_ppa_from_index, %function
gc_get_src_ppa_from_index:
	adrp	x1, .LANCHOR68
	ubfiz	x0, x0, 2, 16
	ldr	x1, [x1, #:lo12:.LANCHOR68]
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
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR69
	stp	x23, x24, [sp, 48]
	add	x22, x22, :lo12:.LANCHOR69
	adrp	x23, .LANCHOR50
	add	x21, x23, :lo12:.LANCHOR50
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
.L646:
	ldrb	w0, [x22]
	cmp	w0, 255
	bne	.L659
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L659:
	sxtw	x26, w0
	add	x1, x23, :lo12:.LANCHOR50
	lsl	x3, x26, 6
	add	x2, x1, x3
	ldrb	w0, [x1, x3]
	ldr	w1, [x2, 52]
	strb	w0, [x22]
	ldrh	w24, [x2, 48]
	cbz	w1, .L647
	ldr	w2, [x2, 40]
	adrp	x0, .LANCHOR63
	add	x0, x0, :lo12:.LANCHOR63
	mov	w3, 1
	str	w2, [x0, 324]
	strh	w3, [x0, 320]
	adrp	x0, .LC46
	add	x0, x0, :lo12:.LC46
	bl	printf
	adrp	x1, .LANCHOR70
	adrp	x0, .LC0
	mov	w2, 673
	add	x1, x1, :lo12:.LANCHOR70
	add	x0, x0, :lo12:.LC0
	bl	printf
.L647:
	adrp	x25, .LANCHOR71
	ldrb	w0, [x25, #:lo12:.LANCHOR71]
	cmp	w0, 3
	bne	.L648
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrb	w19, [x0, 89]
	add	w19, w19, w19, lsl 1
	and	w19, w19, 1023
.L649:
	adrp	x0, .LANCHOR14
	adrp	x28, .LANCHOR74
	and	x20, x24, 65535
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L650
	ldr	x1, [x28, #:lo12:.LANCHOR74]
	add	x0, x21, x26, lsl 6
	mov	w3, w24
	ldrb	w2, [x0, 1]
	adrp	x0, .LC47
	ldrb	w4, [x1, x20]
	add	x0, x0, :lo12:.LC47
	mov	w1, w24
	bl	printf
.L650:
	ldr	x1, [x28, #:lo12:.LANCHOR74]
	add	x0, x21, x26, lsl 6
	mov	x27, x20
	ldrb	w0, [x0, 1]
	ldrb	w1, [x1, x20]
	cmp	w1, w0
	beq	.L651
	adrp	x1, .LANCHOR70
	adrp	x0, .LC0
	mov	w2, 682
	add	x1, x1, :lo12:.LANCHOR70
	add	x0, x0, :lo12:.LC0
	bl	printf
.L651:
	add	x0, x21, x26, lsl 6
	ldrb	w0, [x0, 61]
	cmp	w0, 3
	beq	.L652
	ldrb	w0, [x25, #:lo12:.LANCHOR71]
	cmp	w0, 3
	bne	.L652
	adrp	x0, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L652
	adrp	x0, .LANCHOR72
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	cbz	w0, .L653
	adrp	x0, .LANCHOR73
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	cbnz	w0, .L652
.L653:
	ldr	x1, [x28, #:lo12:.LANCHOR74]
	mov	x0, 0
	add	x20, x1, x20
.L654:
	cmp	w19, w0, uxth
	bls	.L646
	ldrb	w1, [x20, x0]
	add	x0, x0, 1
	add	x1, x21, x1, lsl 6
	strb	wzr, [x1, 61]
	b	.L654
.L648:
	adrp	x0, .LANCHOR72
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	cbz	w0, .L661
	adrp	x0, .LANCHOR73
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	cbz	w0, .L661
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrb	w19, [x0, 89]
	ubfiz	w19, w19, 1, 8
	b	.L649
.L661:
	mov	w19, 1
	b	.L649
.L652:
	adrp	x0, .LANCHOR63
	add	x0, x0, :lo12:.LANCHOR63
	add	x19, x20, x19, uxth
	mov	x20, x0
	strh	w24, [x0, 316]
	mov	w24, -1
.L655:
	cmp	x19, x27
	beq	.L646
	ldr	x1, [x28, #:lo12:.LANCHOR74]
	ldrb	w0, [x1, x27]
	strb	w24, [x1, x27]
	add	x27, x27, 1
	sbfiz	x1, x0, 6, 32
	ubfiz	x0, x0, 6, 8
	add	x1, x21, x1
	add	x0, x21, x0
	strb	wzr, [x1, 61]
	bl	buf_free
	ldrb	w0, [x20, 7]
	sub	w0, w0, #1
	strb	w0, [x20, 7]
	b	.L655
	.size	gc_write_completed, .-gc_write_completed
	.section	.text.gc_get_src_blk,"ax",@progbits
	.align	2
	.global	gc_get_src_blk
	.type	gc_get_src_blk, %function
gc_get_src_blk:
	adrp	x0, .LANCHOR10
	ldr	x2, [x0, #:lo12:.LANCHOR10]
	adrp	x0, .LANCHOR76
	ldrb	w3, [x0, #:lo12:.LANCHOR76]
	ldrh	w0, [x2, 124]
	cbz	w0, .L676
	add	x1, x2, 392
	mov	w4, 1
.L677:
	add	x5, x1, 128
	mov	w6, 65535
.L681:
	ldrh	w0, [x1]
	cmp	w0, w6
	beq	.L679
	mov	w5, -1
	strh	w5, [x1]
	cbz	w4, .L680
	ldrh	w1, [x2, 124]
	sub	w1, w1, #1
	strh	w1, [x2, 124]
	ret
.L676:
	add	x0, x2, x3, sxtw 1
	ldrh	w0, [x0, 120]
	cbz	w0, .L682
	ubfiz	x1, x3, 7, 8
	mov	w4, 0
	add	x1, x1, 136
	add	x1, x2, x1
	b	.L677
.L680:
	add	x2, x2, x3, uxtb 1
	ldrh	w1, [x2, 120]
	sub	w1, w1, #1
	strh	w1, [x2, 120]
	ret
.L679:
	add	x1, x1, 2
	cmp	x1, x5
	bne	.L681
	ret
.L682:
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
	adrp	x20, .LANCHOR63
	add	x0, x20, :lo12:.LANCHOR63
	stp	x21, x22, [sp, 32]
	ldrb	w1, [x0, 7]
	cbz	w1, .L691
	adrp	x1, .LANCHOR52
	ldrb	w1, [x1, #:lo12:.LANCHOR52]
	cmp	w1, 1
	bhi	.L691
	ldrh	w19, [x0, 316]
	adrp	x2, .LANCHOR78
	adrp	x0, .LANCHOR77
	adrp	x21, .LANCHOR74
	ldrb	w2, [x2, #:lo12:.LANCHOR78]
	add	w1, w19, 24
	ldrh	w0, [x0, #:lo12:.LANCHOR77]
	ldr	x4, [x21, #:lo12:.LANCHOR74]
	mul	w0, w0, w2
	cmp	w0, w1
	csel	w1, w0, w1, ls
	adrp	x0, .LANCHOR50
	add	x0, x0, :lo12:.LANCHOR50
.L686:
	cmp	w19, w1
	bcc	.L689
.L691:
	mov	w0, 0
	b	.L684
.L689:
	uxtw	x22, w19
	ldrb	w2, [x4, x22]
	cmp	w2, 255
	beq	.L687
	sbfiz	x3, x2, 6, 32
	add	x3, x0, x3
	ldrb	w3, [x3, 61]
	cbnz	w3, .L687
	ubfiz	x2, x2, 6, 8
	add	x0, x0, x2
	bl	buf_free
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L688
	ldr	x0, [x21, #:lo12:.LANCHOR74]
	mov	w1, w19
	ldrb	w2, [x0, x22]
	adrp	x0, .LC48
	add	x0, x0, :lo12:.LC48
	bl	printf
.L688:
	ldr	x0, [x21, #:lo12:.LANCHOR74]
	add	x20, x20, :lo12:.LANCHOR63
	mov	w1, -1
	strb	w1, [x0, x22]
	ldrb	w0, [x20, 7]
	sub	w0, w0, #1
	strb	w0, [x20, 7]
	mov	w0, 1
.L684:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L687:
	add	w19, w19, 1
	b	.L686
	.size	gc_free_temp_buf, .-gc_free_temp_buf
	.section	.text.print_gc_debug_info,"ax",@progbits
	.align	2
	.global	print_gc_debug_info
	.type	print_gc_debug_info, %function
print_gc_debug_info:
	adrp	x2, .LANCHOR79
	adrp	x1, .LANCHOR63
	add	x0, x1, :lo12:.LANCHOR63
	ldrh	w6, [x2, #:lo12:.LANCHOR79]
	adrp	x2, .LANCHOR52
	ldrh	w1, [x1, #:lo12:.LANCHOR63]
	ldrb	w5, [x0, 7]
	ldrb	w4, [x2, #:lo12:.LANCHOR52]
	ldrh	w3, [x0, 314]
	ldrh	w2, [x0, 2]
	adrp	x0, .LC49
	add	x0, x0, :lo12:.LC49
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
	bne	.L701
	mov	w1, w0
	adrp	x0, .LANCHOR80
	ldr	x0, [x0, #:lo12:.LANCHOR80]
.L703:
	b	_list_get_gc_head_node.isra.2
.L701:
	cmp	w1, 2
	bne	.L702
	b	zftl_get_gc_node.part.9
.L702:
	mov	w1, w0
	adrp	x0, .LANCHOR81
	ldr	x0, [x0, #:lo12:.LANCHOR81]
	b	.L703
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
	cbz	w19, .L705
	mov	w0, w19
.L704:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L705:
	and	w20, w2, 255
	cbnz	w21, .L707
	adrp	x24, .LANCHOR82
	adrp	x26, .LANCHOR14
	adrp	x27, .LC50
	and	w22, w20, 65535
	add	x26, x26, :lo12:.LANCHOR14
	add	x27, x27, :lo12:.LC50
	strh	wzr, [x24, #:lo12:.LANCHOR82]
	mov	w23, 0
	mov	w25, 0
.L708:
	cmp	w25, w22
	bcs	.L713
	ldrh	w6, [x24, #:lo12:.LANCHOR82]
	add	x7, x24, :lo12:.LANCHOR82
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w2, w6, 1
	and	w2, w2, 65535
	strh	w2, [x24, #:lo12:.LANCHOR82]
	and	w1, w0, 65535
	mov	w0, 65535
	mov	w28, w1
	cmp	w1, w0
	beq	.L709
	ldr	w0, [x26]
	adrp	x6, .LANCHOR9
	uxtw	x4, w1
	tbz	x0, 8, .L710
	ldr	x0, [x6, #:lo12:.LANCHOR9]
	stp	x6, x4, [x29, 96]
	ldrh	w3, [x0, x4, lsl 1]
	mov	x0, x27
	bl	printf
	ldp	x6, x4, [x29, 96]
.L710:
	ldr	x0, [x6, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, x4, lsl 1]
	adrp	x0, .LANCHOR62
	ldrh	w0, [x0, #:lo12:.LANCHOR62]
	cmp	w1, w0
	bcs	.L711
	mov	w2, 0
	mov	w1, 0
	mov	w0, w28
	bl	gc_add_sblk
	cbz	w0, .L712
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w22, w23
	bcs	.L712
.L713:
	ldr	x0, [x29, 112]
	tbz	x0, 1, .L715
	adrp	x25, .LANCHOR84
	adrp	x24, .LANCHOR83
	add	x27, x25, :lo12:.LANCHOR84
	add	x24, x24, :lo12:.LANCHOR83
	mov	w28, 0
	mov	w26, 65535
.L716:
	cmp	w28, w22
	beq	.L720
	ldrh	w6, [x24]
	mov	w1, 5
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x24]
	and	w1, w0, 65535
	cmp	w1, w26
	beq	.L717
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x1]
	ldrh	w1, [x27]
	cmp	w2, w1
	bcs	.L717
	mov	w2, 0
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L719
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w22, w23
	bcs	.L719
.L720:
	cmp	w23, w22
	adrp	x0, .LANCHOR85
	bcs	.L722
	ldrh	w1, [x0, #:lo12:.LANCHOR85]
	adrp	x3, .LANCHOR78
	adrp	x0, .LANCHOR77
	ldrh	w2, [x25, #:lo12:.LANCHOR84]
	ldrb	w3, [x3, #:lo12:.LANCHOR78]
	ldrh	w0, [x0, #:lo12:.LANCHOR77]
	mul	w0, w0, w3
	sub	w0, w0, w1, lsr 2
	cmp	w2, w0
	bge	.L715
	add	w1, w2, w1, lsr 3
	strh	w1, [x25, #:lo12:.LANCHOR84]
.L715:
	ldr	x0, [x29, 112]
	tbz	x0, 0, .L723
	cmp	w23, w22
	bcs	.L723
	adrp	x24, .LANCHOR86
	add	x24, x24, :lo12:.LANCHOR86
	mov	w25, 65535
.L728:
	ldrh	w6, [x24]
	mov	w0, w6
	bl	zftl_get_gc_node.part.9
	add	w6, w6, 1
	strh	w6, [x24]
	cmp	w25, w0, uxth
	beq	.L724
	mov	w2, 0
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L725
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w22, w23
	bhi	.L725
.L726:
	adrp	x0, .LANCHOR85
	adrp	x1, .LANCHOR62
	ldrh	w0, [x0, #:lo12:.LANCHOR85]
	ldrh	w2, [x1, #:lo12:.LANCHOR62]
	cmp	w2, w0, lsr 1
	bls	.L723
	sub	w0, w2, w0, lsr 3
	b	.L803
.L711:
	strh	wzr, [x24, #:lo12:.LANCHOR82]
	b	.L713
.L709:
	strh	wzr, [x7]
	b	.L713
.L712:
	add	w25, w25, 1
	and	w25, w25, 65535
	b	.L708
.L717:
	strh	wzr, [x24]
	b	.L720
.L719:
	add	w28, w28, 1
	and	w28, w28, 65535
	b	.L716
.L722:
	ldrh	w1, [x25, #:lo12:.LANCHOR84]
	ldrh	w0, [x0, #:lo12:.LANCHOR85]
	cmp	w1, w0
	bls	.L715
	sub	w0, w1, w0, lsr 3
	strh	w0, [x25, #:lo12:.LANCHOR84]
	b	.L715
.L724:
	strh	wzr, [x24]
.L727:
	cmp	w23, w22
	bcs	.L726
	adrp	x1, .LANCHOR62
	adrp	x0, .LANCHOR85
	ldrh	w2, [x1, #:lo12:.LANCHOR62]
	ldrh	w0, [x0, #:lo12:.LANCHOR85]
	cmp	w2, w0
	bcs	.L723
	add	w0, w2, w0, lsr 3
.L803:
	strh	w0, [x1, #:lo12:.LANCHOR62]
.L723:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L750
	ldr	w2, [x29, 112]
	adrp	x0, .LC51
	mov	w4, w20
	mov	w3, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC51
	bl	printf
.L750:
	mov	w0, w23
	b	.L704
.L725:
	add	w19, w19, 1
	and	w19, w19, 65535
	cmp	w22, w19
	bne	.L728
	b	.L727
.L707:
	adrp	x0, .LANCHOR63+318
	strh	wzr, [x0, #:lo12:.LANCHOR63+318]
	adrp	x0, .LANCHOR87
	strh	wzr, [x0, #:lo12:.LANCHOR87]
	ldr	w0, [x29, 112]
	and	w0, w0, 1
	str	w0, [x29, 104]
	ldr	x0, [x29, 112]
	tbz	x0, 0, .L753
	adrp	x1, .LANCHOR89
	adrp	x25, .LANCHOR88
	str	x1, [x29, 96]
	adrp	x26, .LANCHOR90
	ldrh	w0, [x25, #:lo12:.LANCHOR88]
	ldrh	w2, [x1, #:lo12:.LANCHOR89]
	cmp	w0, w2, lsr 2
	bcc	.L730
	ldrh	w1, [x26, #:lo12:.LANCHOR90]
	cmp	w1, w0
	bls	.L754
.L730:
	ldrh	w0, [x26, #:lo12:.LANCHOR90]
	adrp	x22, .LANCHOR86
	lsr	w0, w0, 2
	strh	w0, [x22, #:lo12:.LANCHOR86]
	mov	w0, 0
	bl	zftl_get_gc_node.part.9
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L756
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x3, [x2, #:lo12:.LANCHOR9]
	adrp	x2, .LANCHOR85
	ldrh	w2, [x2, #:lo12:.LANCHOR85]
	ldrh	w1, [x3, x1]
	cmp	w1, w2, lsr 2
	bcs	.L756
	strh	wzr, [x22, #:lo12:.LANCHOR86]
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cmp	w0, 0
	cset	w23, ne
.L732:
	add	x22, x22, :lo12:.LANCHOR86
	and	w28, w20, 65535
	mov	w24, 64
	mov	w27, 65535
.L734:
	ldrh	w6, [x22]
	mov	w0, w6
	bl	zftl_get_gc_node.part.9
	add	w6, w6, 1
	strh	w6, [x22]
	cmp	w27, w0, uxth
	beq	.L731
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L733
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w23, w28
	bcs	.L731
.L733:
	sub	w24, w24, #1
	ands	w24, w24, 65535
	bne	.L734
.L731:
	ldr	x0, [x29, 96]
	ldrh	w1, [x25, #:lo12:.LANCHOR88]
	ldrh	w0, [x0, #:lo12:.LANCHOR89]
	cmp	w1, w0, lsr 3
	bhi	.L751
	ldrh	w0, [x26, #:lo12:.LANCHOR90]
	add	w0, w0, 8
	cmp	w1, w0
	ble	.L729
.L751:
	adrp	x24, .LANCHOR82
	and	w26, w20, 65535
	mov	w22, 64
	mov	w25, 65535
	strh	wzr, [x24, #:lo12:.LANCHOR82]
	add	x24, x24, :lo12:.LANCHOR82
.L736:
	ldrh	w6, [x24]
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x24]
	cmp	w25, w0, uxth
	beq	.L729
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L735
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w23, w26
	bcs	.L729
.L735:
	sub	w22, w22, #1
	ands	w22, w22, 65535
	bne	.L736
.L729:
	ldr	x0, [x29, 112]
	tbz	x0, 1, .L737
	adrp	x24, .LANCHOR83
	adrp	x28, .LANCHOR91
	adrp	x25, .LANCHOR78
	add	x26, x24, :lo12:.LANCHOR83
	add	x27, x28, :lo12:.LANCHOR91
	add	x25, x25, :lo12:.LANCHOR78
	strh	wzr, [x24, #:lo12:.LANCHOR83]
	mov	w22, 64
.L742:
	ldrh	w6, [x26]
	mov	w1, 5
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x26]
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L738
	cmp	w20, 1
	bne	.L739
	adrp	x3, .LANCHOR77
	ldrb	w2, [x25]
	ldrh	w3, [x3, #:lo12:.LANCHOR77]
	mul	w3, w2, w3
	adrp	x2, .LANCHOR85
	ldrh	w2, [x2, #:lo12:.LANCHOR85]
	sub	w2, w3, w2, lsr 3
	strh	w2, [x27]
.L739:
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x1]
	ldrh	w1, [x27]
	cmp	w2, w1
	bcs	.L740
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L741
	add	w5, w23, 1
	add	w19, w19, 1
	and	w23, w5, 65535
	and	w19, w19, 65535
	cmp	w23, w20
	bcc	.L741
.L738:
	cmp	w23, w20
	adrp	x0, .LANCHOR85
	adrp	x3, .LANCHOR78
	bcc	.L743
	cbnz	w19, .L744
	adrp	x1, .LANCHOR92
	ldrh	w2, [x1, #:lo12:.LANCHOR92]
	adrp	x1, .LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	cmp	w2, w1
	bls	.L744
.L743:
	ldrh	w2, [x0, #:lo12:.LANCHOR85]
	adrp	x0, .LANCHOR77
	ldrb	w3, [x3, #:lo12:.LANCHOR78]
	ldrh	w0, [x0, #:lo12:.LANCHOR77]
	ldrh	w1, [x28, #:lo12:.LANCHOR91]
	lsr	w2, w2, 3
	mul	w0, w0, w3
	sub	w0, w0, w2
	cmp	w1, w0
	bge	.L737
	add	w1, w1, w2
	strh	w1, [x28, #:lo12:.LANCHOR91]
.L737:
	ldr	w0, [x29, 104]
	cbz	w0, .L723
	adrp	x25, .LANCHOR82
	adrp	x22, .LANCHOR94
	adrp	x26, .LANCHOR89
	adrp	x27, .LANCHOR88
	add	x28, x22, :lo12:.LANCHOR94
	add	x26, x26, :lo12:.LANCHOR89
	add	x27, x27, :lo12:.LANCHOR88
	strh	wzr, [x25, #:lo12:.LANCHOR82]
	mov	w24, 64
.L748:
	ldrh	w6, [x25, #:lo12:.LANCHOR82]
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x25, #:lo12:.LANCHOR82]
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L745
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w1, [x2, x1]
	ldrh	w2, [x28]
	cmp	w2, w1
	bls	.L746
	cmp	w1, 2
	bls	.L746
	ldrh	w2, [x26]
	ldrh	w1, [x27]
	cmp	w1, w2, lsr 1
	bls	.L745
.L746:
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L747
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w23, w20
	bcs	.L745
.L747:
	sub	w24, w24, #1
	ands	w24, w24, 65535
	bne	.L748
.L745:
	cmp	w23, w20
	adrp	x0, .LANCHOR85
	bcs	.L749
	ldrh	w0, [x0, #:lo12:.LANCHOR85]
	ldrh	w1, [x22, #:lo12:.LANCHOR94]
	cmp	w1, w0, lsr 1
	bls	.L723
	sub	w0, w1, w0, lsr 3
	strh	w0, [x22, #:lo12:.LANCHOR94]
	b	.L723
.L756:
	mov	w23, 0
	b	.L732
.L753:
	mov	w23, 0
	b	.L729
.L740:
	strh	wzr, [x24, #:lo12:.LANCHOR83]
	b	.L738
.L741:
	sub	w22, w22, #1
	ands	w22, w22, 65535
	bne	.L742
	b	.L738
.L744:
	ldrh	w0, [x0, #:lo12:.LANCHOR85]
	ldrb	w1, [x3, #:lo12:.LANCHOR78]
	ldrh	w2, [x28, #:lo12:.LANCHOR91]
	mul	w1, w1, w0
	cmp	w2, w1
	ble	.L737
	sub	w0, w2, w0, lsr 3
	strh	w0, [x28, #:lo12:.LANCHOR91]
	b	.L737
.L749:
	ldrh	w1, [x0, #:lo12:.LANCHOR85]
	adrp	x0, .LANCHOR78
	ldrh	w2, [x22, #:lo12:.LANCHOR94]
	ldrb	w0, [x0, #:lo12:.LANCHOR78]
	mul	w0, w0, w1
	sub	w0, w0, #32
	cmp	w2, w0
	bge	.L723
	add	w1, w2, w1, lsr 3
	strh	w1, [x22, #:lo12:.LANCHOR94]
	b	.L723
.L754:
	mov	w23, 0
	b	.L731
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
	bne	.L805
	adrp	x2, .LANCHOR95
	adrp	x0, .LANCHOR96
	add	x2, x2, :lo12:.LANCHOR95
	add	x0, x0, :lo12:.LANCHOR96
.L807:
	b	_insert_free_list
.L805:
	cmp	w0, 16
	bne	.L806
	adrp	x2, .LANCHOR97
	adrp	x0, .LANCHOR98
	add	x2, x2, :lo12:.LANCHOR97
	add	x0, x0, :lo12:.LANCHOR98
	b	.L807
.L806:
	adrp	x2, .LANCHOR99
	adrp	x0, .LANCHOR100
	add	x2, x2, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
	b	.L807
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
	bne	.L809
	adrp	x2, .LANCHOR90
	adrp	x0, .LANCHOR12
	add	x2, x2, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR12
.L812:
	b	_insert_data_list
.L809:
	cmp	w2, 96
	bne	.L810
	adrp	x2, .LANCHOR88
	adrp	x0, .LANCHOR81
	add	x2, x2, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LANCHOR81
	b	.L812
.L810:
	cmp	w2, 160
	bne	.L808
	adrp	x2, .LANCHOR92
	adrp	x0, .LANCHOR80
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR80
	b	.L812
.L808:
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
	beq	.L814
	cbnz	w21, .L814
	mov	w1, w19
	adrp	x0, .LC52
	add	x0, x0, :lo12:.LC52
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR10]
	mov	w1, -1
	strh	w1, [x0, 588]
.L815:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L814:
	adrp	x2, .LANCHOR97
	adrp	x20, .LANCHOR99
	ldrh	w0, [x2, #:lo12:.LANCHOR97]
	ldrh	w1, [x20, #:lo12:.LANCHOR99]
	cmp	w0, w1
	bls	.L816
	lsr	w1, w0, 3
	cmp	w21, 0
	adrp	x0, .LANCHOR98
	csel	w1, w1, wzr, ne
	add	x2, x2, :lo12:.LANCHOR97
	add	x0, x0, :lo12:.LANCHOR98
.L830:
	bl	_list_pop_index_node
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	bne	.L821
	adrp	x0, .LANCHOR95
	ldrh	w5, [x20, #:lo12:.LANCHOR99]
	mov	w2, w22
	mov	w1, w19
	ldrh	w4, [x0, #:lo12:.LANCHOR95]
	adrp	x0, .LANCHOR96
	ldr	x3, [x0, #:lo12:.LANCHOR96]
	adrp	x0, .LC53
	add	x0, x0, :lo12:.LC53
	bl	printf
.L821:
	cbz	w21, .L815
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L815
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
	adrp	x0, .LC54
	ubfx	x3, x2, 3, 2
	and	w5, w5, 2047
	ubfx	x2, x2, 5, 3
	add	x0, x0, :lo12:.LC54
	bl	printf
	b	.L815
.L816:
	cbnz	w21, .L819
	lsr	w1, w1, 2
.L820:
	adrp	x0, .LANCHOR100
	add	x2, x20, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
	b	.L830
.L819:
	mov	w1, 7
	mul	w1, w0, w1
	lsr	w1, w1, 3
	b	.L820
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
	bne	.L832
	adrp	x2, .LANCHOR97
	adrp	x0, .LANCHOR99
	ldrh	w3, [x2, #:lo12:.LANCHOR97]
	ldrh	w1, [x0, #:lo12:.LANCHOR99]
	cmp	w3, w1
	bcc	.L833
	adrp	x4, .LANCHOR95
	ldrh	w4, [x4, #:lo12:.LANCHOR95]
	cmp	w4, w3
	bls	.L834
	cbz	w1, .L834
.L833:
	add	x2, x0, :lo12:.LANCHOR99
	lsr	w1, w1, 1
.L853:
	adrp	x0, .LANCHOR100
	add	x0, x0, :lo12:.LANCHOR100
	b	.L852
.L834:
	adrp	x0, .LANCHOR98
	add	x2, x2, :lo12:.LANCHOR97
	add	x0, x0, :lo12:.LANCHOR98
	mov	w1, 0
.L852:
	bl	_list_pop_index_node
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	bne	.L837
	adrp	x0, .LANCHOR99
	mov	w2, w20
	mov	w1, w19
	ldrh	w5, [x0, #:lo12:.LANCHOR99]
	adrp	x0, .LANCHOR95
	ldrh	w4, [x0, #:lo12:.LANCHOR95]
	adrp	x0, .LANCHOR96
	ldr	x3, [x0, #:lo12:.LANCHOR96]
	adrp	x0, .LC53
	add	x0, x0, :lo12:.LC53
	bl	printf
	b	.L837
.L832:
	adrp	x21, .LANCHOR10
	and	w0, w0, 65535
	ldr	x1, [x21, #:lo12:.LANCHOR10]
	ldrh	w19, [x1, 590]
	mov	w1, 65535
	cmp	w19, w1
	beq	.L836
	cmp	w20, 1
	beq	.L836
	mov	w1, w19
	adrp	x0, .LC55
	add	x0, x0, :lo12:.LC55
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	mov	w1, -1
	strh	w1, [x0, 590]
.L837:
	mov	w0, w19
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L836:
	adrp	x2, .LANCHOR95
	adrp	x4, .LANCHOR99
	ldrh	w1, [x2, #:lo12:.LANCHOR95]
	ldrh	w3, [x4, #:lo12:.LANCHOR99]
	cmp	w1, w3
	bcc	.L838
	adrp	x5, .LANCHOR97
	ldrh	w5, [x5, #:lo12:.LANCHOR97]
	cmp	w5, w1
	bls	.L839
	cbz	w3, .L839
.L838:
	cmp	w20, 1
	lsr	w3, w3, 1
	csel	w0, w3, w0, eq
	add	x2, x4, :lo12:.LANCHOR99
	mov	w1, w0
	b	.L853
.L839:
	lsr	w1, w1, 1
	cmp	w20, 1
	csel	w0, w1, w0, eq
	add	x2, x2, :lo12:.LANCHOR95
	mov	w1, w0
	adrp	x0, .LANCHOR96
	add	x0, x0, :lo12:.LANCHOR96
	b	.L852
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
	bne	.L855
	adrp	x2, .LANCHOR90
	adrp	x0, .LANCHOR12
	add	x2, x2, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR12
.L858:
	b	_list_remove_node
.L855:
	cmp	w2, 96
	bne	.L856
	adrp	x2, .LANCHOR88
	adrp	x0, .LANCHOR81
	add	x2, x2, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LANCHOR81
	b	.L858
.L856:
	cmp	w2, 160
	bne	.L854
	adrp	x2, .LANCHOR92
	adrp	x0, .LANCHOR80
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR80
	b	.L858
.L854:
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
	bne	.L860
	adrp	x2, .LANCHOR95
	adrp	x0, .LANCHOR96
	add	x2, x2, :lo12:.LANCHOR95
	add	x0, x0, :lo12:.LANCHOR96
.L862:
	b	_list_remove_node
.L860:
	cmp	w0, 16
	bne	.L861
	adrp	x2, .LANCHOR97
	adrp	x0, .LANCHOR98
	add	x2, x2, :lo12:.LANCHOR97
	add	x0, x0, :lo12:.LANCHOR98
	b	.L862
.L861:
	adrp	x2, .LANCHOR99
	adrp	x0, .LANCHOR100
	add	x2, x2, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
	b	.L862
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
	bne	.L864
	adrp	x2, .LANCHOR90
	adrp	x0, .LANCHOR12
	add	x2, x2, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR12
.L867:
	b	_list_update_data_list
.L864:
	cmp	w2, 96
	bne	.L865
	adrp	x2, .LANCHOR88
	adrp	x0, .LANCHOR81
	add	x2, x2, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LANCHOR81
	b	.L867
.L865:
	cmp	w2, 160
	bne	.L863
	adrp	x2, .LANCHOR92
	adrp	x0, .LANCHOR80
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR80
	b	.L867
.L863:
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
	adrp	x0, .LC56
	stp	x23, x24, [sp, 80]
	add	x0, x0, :lo12:.LC56
	bl	printf
	ldr	x19, [x19]
	cbz	x19, .L868
	mov	x24, -6148914691236517206
	adrp	x22, .LC57
	adrp	x21, .LANCHOR101
	add	x22, x22, :lo12:.LC57
	add	x21, x21, :lo12:.LANCHOR101
	mov	w20, 0
	adrp	x23, .LANCHOR4
	movk	x24, 0xaaab, lsl 0
.L872:
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
	beq	.L868
	ldr	x0, [x23, #:lo12:.LANCHOR4]
	mov	w1, 6
	add	w20, w20, 1
	and	w20, w20, 65535
	umaddl	x19, w19, w1, x0
	ldrh	w0, [x21]
	cmp	w0, w20
	bcs	.L872
.L868:
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
	adrp	x1, .LANCHOR95
	adrp	x0, .LANCHOR96
	add	x1, x1, :lo12:.LANCHOR95
	add	x29, sp, 0
	add	x0, x0, :lo12:.LANCHOR96
	bl	print_list_info
	adrp	x1, .LANCHOR97
	adrp	x0, .LANCHOR98
	add	x1, x1, :lo12:.LANCHOR97
	add	x0, x0, :lo12:.LANCHOR98
	bl	print_list_info
	adrp	x1, .LANCHOR99
	adrp	x0, .LANCHOR100
	add	x1, x1, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LANCHOR100
	bl	print_list_info
	adrp	x1, .LANCHOR90
	adrp	x0, .LANCHOR12
	add	x1, x1, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR12
	bl	print_list_info
	adrp	x1, .LANCHOR88
	adrp	x0, .LANCHOR81
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LANCHOR81
	bl	print_list_info
	ldp	x29, x30, [sp], 16
	adrp	x1, .LANCHOR92
	adrp	x0, .LANCHOR80
	add	x1, x1, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR80
	b	print_list_info
	.size	dump_all_list_info, .-dump_all_list_info
	.section	.text.ftl_tmp_into_update,"ax",@progbits
	.align	2
	.global	ftl_tmp_into_update
	.type	ftl_tmp_into_update, %function
ftl_tmp_into_update:
	adrp	x0, .LANCHOR102
	ldr	x0, [x0, #:lo12:.LANCHOR102]
	ldr	w1, [x0, 16]
	cmp	w1, 2048
	bls	.L877
	ldr	w2, [x0, 20]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 16]
.L877:
	ldr	w1, [x0, 24]
	cmp	w1, 2048
	bls	.L878
	ldr	w2, [x0, 28]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 24]
.L878:
	ldr	w1, [x0, 32]
	cmp	w1, 1024
	bls	.L879
	ldr	w2, [x0, 36]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 32]
.L879:
	ldr	w1, [x0, 40]
	cmp	w1, 1024
	bls	.L876
	ldr	w2, [x0, 44]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 40]
.L876:
	ret
	.size	ftl_tmp_into_update, .-ftl_tmp_into_update
	.section	.text.ftl_get_blk_list_in_sblk,"ax",@progbits
	.align	2
	.global	ftl_get_blk_list_in_sblk
	.type	ftl_get_blk_list_in_sblk, %function
ftl_get_blk_list_in_sblk:
	adrp	x2, .LANCHOR7
	and	w0, w0, 65535
	adrp	x7, .LANCHOR66
	add	x7, x7, :lo12:.LANCHOR66
	ldr	x2, [x2, #:lo12:.LANCHOR7]
	mov	w3, 0
	mov	w13, 21
	add	x2, x2, x0, uxth 2
	ldrb	w12, [x2, 3]
	adrp	x2, .LANCHOR78
	ldrb	w10, [x2, #:lo12:.LANCHOR78]
	adrp	x2, .LANCHOR67
	ldrb	w6, [x2, #:lo12:.LANCHOR67]
	and	w2, w6, 65535
	mul	w0, w0, w2
	sub	w2, w2, #1
	sxth	w5, w2
	and	w4, w0, 65535
	mov	w0, 0
.L882:
	cmp	w3, w10
	blt	.L886
	sxtw	x2, w0
	mov	w3, -1
.L887:
	cmp	w10, w2
	bgt	.L888
	ret
.L886:
	asr	w2, w12, w3
	tbnz	x2, 0, .L883
	sdiv	w2, w3, w6
	ldrh	w8, [x7]
	sbfiz	x11, x0, 1, 32
	cmp	w6, 1
	sub	w8, w13, w8
	lsl	w2, w2, w8
	add	w2, w4, w2
	and	w2, w2, 65535
	bhi	.L884
.L889:
	add	w0, w0, 1
	strh	w2, [x1, x11]
.L883:
	add	w3, w3, 1
	b	.L882
.L884:
	and	w8, w5, w3
	add	w2, w2, w8
	b	.L889
.L888:
	strh	w3, [x1, x2, lsl 1]
	add	x2, x2, 1
	b	.L887
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
	adrp	x1, .LANCHOR66
	stp	x19, x20, [sp, 16]
	mov	w19, 21
	adrp	x22, .LANCHOR103
	ldrh	w1, [x1, #:lo12:.LANCHOR66]
	sub	w1, w19, w1
	mov	w19, 1
	lsl	w19, w19, w1
	sub	w19, w19, #1
	and	w19, w19, w0
	asr	w20, w0, w1
	adrp	x0, .LANCHOR72
	sxth	w19, w19
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	cbz	w0, .L891
	adrp	x0, .LANCHOR73
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	cbnz	w0, .L891
	ldrh	w2, [x22, #:lo12:.LANCHOR103]
	cmp	w21, 0
	cset	w1, eq
	mov	w0, w20
	mul	w2, w2, w19
	bl	flash_erase_block_en
.L891:
	ldrh	w2, [x22, #:lo12:.LANCHOR103]
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
	adrp	x25, .LANCHOR104
	stp	x21, x22, [sp, 32]
	ubfiz	x22, x26, 2, 16
	add	x0, x0, x22
	stp	x27, x28, [sp, 80]
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR67
	mov	w20, w1
	add	x25, x25, :lo12:.LANCHOR104
	ldrb	w28, [x0, 3]
	add	x24, x24, :lo12:.LANCHOR67
	add	x27, x29, 112
	mov	w19, 0
.L897:
	ldrb	w0, [x25]
	cmp	w19, w0
	bge	.L908
	ldrb	w1, [x24]
	adrp	x0, .LANCHOR103
	mov	w21, 0
	ldrh	w3, [x0, #:lo12:.LANCHOR103]
	sub	w4, w1, #1
	mov	w0, 0
	mul	w6, w19, w1
	mul	w5, w26, w1
	b	.L909
.L899:
	add	w2, w0, w6
	asr	w2, w28, w2
	tbnz	x2, 0, .L898
	and	w2, w0, w4
	add	w2, w2, w5
	mul	w2, w2, w3
	str	w2, [x27, w21, sxtw 2]
	add	w21, w21, 1
.L898:
	add	w0, w0, 1
.L909:
	cmp	w0, w1
	blt	.L899
	cmp	w1, 4
	bne	.L900
	mov	x3, 0
.L901:
	cmp	w21, w3
	bgt	.L902
.L903:
	add	w19, w19, 1
	b	.L897
.L902:
	ldr	w2, [x27, x3, lsl 2]
	mov	w1, w20
	str	x3, [x29, 104]
	mov	w0, w19
	bl	flash_erase_block_en
	ldr	x3, [x29, 104]
	add	x3, x3, 1
	b	.L901
.L900:
	cmp	w21, 2
	bne	.L904
	adrp	x0, .LANCHOR72
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	cbz	w0, .L905
	adrp	x0, .LANCHOR73
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	cbnz	w0, .L905
	ldp	w2, w3, [x29, 112]
	cmp	w20, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_duplane_block
.L905:
	ldp	w2, w3, [x29, 112]
	mov	w1, w20
	mov	w0, w19
	bl	flash_erase_duplane_block
	b	.L903
.L904:
	cmp	w21, 1
	bne	.L903
	adrp	x0, .LANCHOR72
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	cbz	w0, .L907
	adrp	x0, .LANCHOR73
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	cbnz	w0, .L907
	ldr	w2, [x29, 112]
	cmp	w20, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_block_en
.L907:
	ldr	w2, [x29, 112]
	mov	w1, w20
	mov	w0, w19
	bl	flash_erase_block_en
	b	.L903
.L908:
	adrp	x2, .LANCHOR102
	ldr	x3, [x23, #:lo12:.LANCHOR7]
	cbnz	w20, .L910
	ldrh	w1, [x3, x22]
	add	w0, w1, 1
	and	w0, w0, 2047
	bfi	w1, w0, 0, 11
	strh	w1, [x3, x22]
	ldr	x1, [x2, #:lo12:.LANCHOR102]
	ldr	w2, [x1, 84]
	add	w2, w2, 1
	str	w2, [x1, 84]
	ldrh	w2, [x1, 96]
	cmp	w2, w0
	bge	.L912
	strh	w0, [x1, 96]
.L912:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L910:
	ldr	w1, [x3, x22]
	ubfx	x0, x1, 11, 8
	add	w0, w0, 1
	and	w0, w0, 255
	bfi	w1, w0, 11, 8
	str	w1, [x3, x22]
	and	w0, w0, 65535
	ldr	x1, [x2, #:lo12:.LANCHOR102]
	ldr	w2, [x1, 80]
	add	w2, w2, 1
	str	w2, [x1, 80]
	ldrh	w2, [x1, 98]
	cmp	w2, w0
	bcs	.L912
	strh	w0, [x1, 98]
	b	.L912
	.size	ftl_erase_sblk, .-ftl_erase_sblk
	.section	.text.ftl_alloc_sys_blk,"ax",@progbits
	.align	2
	.global	ftl_alloc_sys_blk
	.type	ftl_alloc_sys_blk, %function
ftl_alloc_sys_blk:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR102
	add	x29, sp, 0
	ldr	x1, [x0, #:lo12:.LANCHOR102]
	ldrh	w2, [x1, 136]
	str	x19, [sp, 16]
	mov	x19, x0
	cmp	w2, 63
	bls	.L922
	strh	wzr, [x1, 136]
.L922:
	ldrh	w0, [x1, 112]
	cbnz	w0, .L923
	adrp	x1, .LANCHOR105
	adrp	x0, .LC0
	mov	w2, 1130
	add	x1, x1, :lo12:.LANCHOR105
	add	x0, x0, :lo12:.LC0
	bl	printf
.L923:
	ldr	x1, [x19, #:lo12:.LANCHOR102]
	mov	w5, 65535
.L926:
	ldrh	w2, [x1, 136]
.L924:
	mov	w3, w2
	cmp	w2, 63
	ble	.L925
	strh	wzr, [x1, 136]
	b	.L926
.L925:
	add	x4, x2, 1
	add	x0, x1, x4, lsl 1
	ldrh	w0, [x0, 158]
	cmp	w0, w5
	bne	.L929
	mov	x2, x4
	b	.L924
.L929:
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
	adrp	x0, .LANCHOR102
	mov	x19, x0
	ldr	x1, [x0, #:lo12:.LANCHOR102]
	ldrh	w2, [x1, 138]
	cmp	w2, 63
	bls	.L932
	strh	wzr, [x1, 138]
.L932:
	ldrh	w0, [x1, 112]
	cmp	w0, 63
	bls	.L933
	adrp	x1, .LANCHOR106
	adrp	x0, .LC0
	mov	w2, 1154
	add	x1, x1, :lo12:.LANCHOR106
	add	x0, x0, :lo12:.LC0
	bl	printf
.L933:
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	mov	w4, 65535
.L936:
	ldrh	w1, [x0, 138]
.L934:
	mov	w2, w1
	cmp	w1, 63
	ble	.L935
	strh	wzr, [x0, 138]
	b	.L936
.L935:
	add	x3, x1, 1
	add	x5, x0, x3, lsl 1
	ldrh	w5, [x5, 158]
	cmp	w5, w4
	bne	.L937
	add	x2, x0, x2, sxtw 1
	strh	w20, [x2, 160]
	strh	w1, [x0, 138]
	ldrh	w1, [x0, 112]
	ldp	x19, x20, [sp, 16]
	add	w1, w1, 1
	strh	w1, [x0, 112]
	ldp	x29, x30, [sp], 32
	ret
.L937:
	mov	x1, x3
	b	.L934
	.size	ftl_free_sys_blk, .-ftl_free_sys_blk
	.section	.text.ftl_info_data_recovery,"ax",@progbits
	.align	2
	.global	ftl_info_data_recovery
	.type	ftl_info_data_recovery, %function
ftl_info_data_recovery:
	ldrh	w2, [x0]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L950
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
	bne	.L940
	ldrb	w0, [x0, 4]
	bfi	w1, w0, 5, 3
	strb	w1, [x21, 2]
	mov	w0, w2
	bl	zftl_remove_free_node
	ldrb	w0, [x21, 2]
	adrp	x1, .LANCHOR102
	ldr	x3, [x1, #:lo12:.LANCHOR102]
	tbz	x0, 3, .L944
	ldrh	w2, [x3, 116]
	sub	w2, w2, #1
	strh	w2, [x3, 116]
.L945:
	and	w0, w0, 224
	cmp	w0, 160
	bne	.L947
	ldr	w0, [x20, x19]
	ldr	x1, [x1, #:lo12:.LANCHOR102]
	ubfx	x2, x0, 11, 8
	add	w2, w2, 1
	bfi	w0, w2, 11, 8
	str	w0, [x20, x19]
	ldrh	w0, [x1, 120]
	sub	w0, w0, #1
	strh	w0, [x1, 120]
.L940:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L944:
	tst	w0, 24
	bne	.L946
	ldrh	w2, [x3, 114]
	sub	w2, w2, #1
	strh	w2, [x3, 114]
	b	.L945
.L946:
	ldrh	w2, [x3, 118]
	sub	w2, w2, #1
	strh	w2, [x3, 118]
	b	.L945
.L947:
	ldrh	w2, [x20, x19]
	cmp	w0, 64
	add	w3, w2, 1
	bfi	w2, w3, 0, 11
	strh	w2, [x20, x19]
	bne	.L948
	ldr	x1, [x1, #:lo12:.LANCHOR102]
	ldrh	w0, [x1, 122]
	sub	w0, w0, #1
	strh	w0, [x1, 122]
	b	.L940
.L948:
	cmp	w0, 96
	bne	.L940
	ldr	x1, [x1, #:lo12:.LANCHOR102]
	ldrh	w0, [x1, 124]
	sub	w0, w0, #1
	strh	w0, [x1, 124]
	b	.L940
.L950:
	ret
	.size	ftl_info_data_recovery, .-ftl_info_data_recovery
	.section	.text.ftl_get_ppa_from_index,"ax",@progbits
	.align	2
	.global	ftl_get_ppa_from_index
	.type	ftl_get_ppa_from_index, %function
ftl_get_ppa_from_index:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR10
	adrp	x3, .LANCHOR78
	and	w0, w0, 65535
	add	x29, sp, 0
	ldr	x2, [x1, #:lo12:.LANCHOR10]
	adrp	x1, .LANCHOR85
	ldrb	w3, [x3, #:lo12:.LANCHOR78]
	ldrh	w1, [x1, #:lo12:.LANCHOR85]
	stp	x19, x20, [sp, 16]
	mul	w1, w1, w3
	cmp	w0, w1
	bge	.L954
	add	x2, x2, 16
.L955:
	ldrb	w1, [x2, 9]
	sdiv	w19, w0, w1
	msub	w0, w19, w1, w0
	add	x0, x2, x0, uxth 1
	ldrh	w20, [x0, 16]
	mov	w0, 65535
	cmp	w20, w0
	bne	.L956
	adrp	x1, .LANCHOR107
	adrp	x0, .LC0
	mov	w2, 1593
	add	x1, x1, :lo12:.LANCHOR107
	add	x0, x0, :lo12:.LC0
	bl	printf
.L956:
	adrp	x0, .LANCHOR103
	ldrh	w0, [x0, #:lo12:.LANCHOR103]
	madd	w0, w0, w20, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L954:
	sub	w0, w0, w1
	add	x2, x2, 48
	and	w0, w0, 65535
	b	.L955
	.size	ftl_get_ppa_from_index, .-ftl_get_ppa_from_index
	.section	.text.lpa_hash_get_ppa,"ax",@progbits
	.align	2
	.global	lpa_hash_get_ppa
	.type	lpa_hash_get_ppa, %function
lpa_hash_get_ppa:
	and	x2, x0, 255
	adrp	x1, .LANCHOR108
	add	x1, x1, :lo12:.LANCHOR108
	mov	w3, 65535
	ldrh	w1, [x1, x2, lsl 1]
	adrp	x2, .LANCHOR109
	ldr	x4, [x2, #:lo12:.LANCHOR109]
	adrp	x2, .LANCHOR110
	ldr	x5, [x2, #:lo12:.LANCHOR110]
.L959:
	cmp	w1, w3
	bne	.L961
	mov	w0, -1
	ret
.L961:
	uxtw	x2, w1
	ldr	w6, [x4, x2, lsl 2]
	cmp	w0, w6
	bne	.L960
	mov	w0, w1
	b	ftl_get_ppa_from_index
.L960:
	ldrh	w1, [x5, x2, lsl 1]
	b	.L959
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
	bne	.L963
	adrp	x1, .LANCHOR111
	adrp	x0, .LC0
	mov	w2, 1716
	add	x1, x1, :lo12:.LANCHOR111
	add	x0, x0, :lo12:.LC0
	bl	printf
.L963:
	adrp	x0, .LANCHOR85
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR85]
	cmp	w1, w0
	bne	.L964
	adrp	x1, .LANCHOR111
	adrp	x0, .LC0
	mov	w2, 1717
	add	x1, x1, :lo12:.LANCHOR111
	add	x0, x0, :lo12:.LC0
	bl	printf
.L964:
	ldrh	w0, [x19, 6]
	cbnz	w0, .L965
	adrp	x1, .LANCHOR111
	adrp	x0, .LC0
	mov	w2, 1718
	add	x1, x1, :lo12:.LANCHOR111
	add	x0, x0, :lo12:.LC0
	bl	printf
.L965:
	ldrb	w0, [x19, 5]
	mov	w2, 65535
	add	x0, x0, 8
	ldrh	w3, [x19, x0, lsl 1]
	adrp	x0, .LANCHOR78
	ldrb	w4, [x0, #:lo12:.LANCHOR78]
.L966:
	cmp	w3, w2
	ldrb	w1, [x19, 5]
	beq	.L968
	adrp	x0, .LANCHOR103
	add	w1, w1, 1
	and	w1, w1, 255
	ldrh	w2, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR103]
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
	bne	.L962
	add	w2, w2, 1
	strb	wzr, [x19, 5]
	strh	w2, [x19, 2]
.L962:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L968:
	add	w1, w1, 1
	and	w1, w1, 255
	strb	w1, [x19, 5]
	cmp	w1, w4
	bne	.L967
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 5]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L967:
	ldrb	w0, [x19, 5]
	add	x0, x0, 8
	ldrh	w3, [x19, x0, lsl 1]
	b	.L966
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
	bcs	.L972
	adrp	x1, .LANCHOR112
	adrp	x0, .LC0
	mov	w2, 1749
	add	x1, x1, :lo12:.LANCHOR112
	add	x0, x0, :lo12:.LC0
	bl	printf
.L972:
	adrp	x20, .LANCHOR102
	mov	w1, 0
	mov	w0, w19
	bl	ftl_erase_phy_blk
	ldr	x0, [x20, #:lo12:.LANCHOR102]
	ldrh	w0, [x0, 130]
	bl	ftl_free_sys_blk
	ldr	x0, [x20, #:lo12:.LANCHOR102]
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
	adrp	x2, .LANCHOR113
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR113]
	cmp	w1, 4
	bhi	.L975
	cbnz	w0, .L975
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR113]
	ret
.L975:
	adrp	x0, .LANCHOR6
	strh	wzr, [x3, #:lo12:.LANCHOR113]
	mov	x1, 0
	mov	w2, 0
	ldrh	w5, [x0, #:lo12:.LANCHOR6]
	adrp	x0, .LANCHOR9
	mov	w8, 65535
	ldr	x6, [x0, #:lo12:.LANCHOR9]
	adrp	x0, .LANCHOR7
	ldr	x7, [x0, #:lo12:.LANCHOR7]
	mov	w0, 0
.L977:
	cmp	w5, w1, uxth
	bhi	.L980
	adrp	x1, .LANCHOR10
	ldr	x1, [x1, #:lo12:.LANCHOR10]
	str	w2, [x1, 524]
	adrp	x2, .LANCHOR102
	str	w0, [x1, 528]
	ldr	x2, [x2, #:lo12:.LANCHOR102]
	ldrh	w2, [x2, 120]
	cbz	w2, .L974
	udiv	w0, w0, w2
	str	w0, [x1, 532]
.L974:
	ret
.L980:
	ldrh	w3, [x6, x1, lsl 1]
	cmp	w3, w8
	beq	.L978
	add	x4, x7, x1, lsl 2
	ldrb	w4, [x4, 2]
	and	w4, w4, 224
	cmp	w4, 160
	bne	.L979
	add	w0, w0, w3
.L978:
	add	x1, x1, 1
	b	.L977
.L979:
	add	w2, w2, w3
	b	.L978
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
	cbnz	w0, .L988
	adrp	x1, .LANCHOR114
	mov	w0, 1
	str	w0, [x1, #:lo12:.LANCHOR114]
.L986:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L988:
	mov	w0, 0
	b	.L986
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
	beq	.L991
	adrp	x0, .LANCHOR9
	uxtw	x1, w19
	lsl	x2, x1, 1
	ldr	x3, [x0, #:lo12:.LANCHOR9]
	ldrh	w0, [x3, x2]
	cbnz	w0, .L992
	adrp	x0, .LANCHOR7
	mov	w2, 0
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x1, x0, x1, lsl 2
	adrp	x0, .LC58
	add	x0, x0, :lo12:.LC58
	ldrb	w3, [x1, 2]
	mov	w1, w19
	ubfx	x3, x3, 5, 3
	bl	printf
.L997:
	mov	w0, 0
	b	.L990
.L992:
	sub	w0, w0, #1
	strh	w0, [x3, x2]
.L991:
	adrp	x20, .LANCHOR64
	ldrh	w0, [x20, #:lo12:.LANCHOR64]
	cmp	w19, w0
	beq	.L997
	mov	w1, 65535
	cmp	w0, w1
	bne	.L994
	strh	w19, [x20, #:lo12:.LANCHOR64]
	b	.L997
.L994:
	bl	ftl_vpn_update
	cmp	w0, 0
	adrp	x1, .LANCHOR115
	cset	w0, ne
	ldrh	w3, [x20, #:lo12:.LANCHOR64]
	ldrh	w2, [x1, #:lo12:.LANCHOR115]
	strh	w19, [x20, #:lo12:.LANCHOR64]
	add	w2, w2, 1
	and	w2, w2, 65535
	cmp	w2, 7
	csel	w2, w2, wzr, ls
	strh	w2, [x1, #:lo12:.LANCHOR115]
	and	x2, x2, 65535
	adrp	x1, .LANCHOR65
	add	x1, x1, :lo12:.LANCHOR65
	strh	w3, [x1, x2, lsl 1]
.L990:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	ftl_vpn_decrement, .-ftl_vpn_decrement
	.section	.text.lpa_hash_update_ppa,"ax",@progbits
	.align	2
	.global	lpa_hash_update_ppa
	.type	lpa_hash_update_ppa, %function
lpa_hash_update_ppa:
	adrp	x3, .LANCHOR108
	and	x5, x0, 255
	add	x4, x3, :lo12:.LANCHOR108
	mov	w7, 65535
	and	w2, w2, 65535
	mov	w12, w7
	ldrh	w6, [x4, x5, lsl 1]
	adrp	x4, .LANCHOR109
	ldr	x8, [x4, #:lo12:.LANCHOR109]
	adrp	x4, .LANCHOR110
	ldr	x4, [x4, #:lo12:.LANCHOR110]
.L1000:
	cmp	w6, w12
	beq	.L1004
	uxtw	x11, w6
	lsl	x10, x11, 2
	add	x13, x8, x10
	ldr	w10, [x8, x10]
	cmp	w0, w10
	lsl	x10, x11, 1
	bne	.L1001
	mov	w6, -1
	str	w6, [x13]
	cmp	w7, w12
	bne	.L1002
	add	x6, x3, :lo12:.LANCHOR108
	ldrh	w7, [x4, x10]
	strh	w7, [x6, x5, lsl 1]
.L1003:
	mov	w6, -1
	strh	w6, [x4, x11, lsl 1]
.L1004:
	uxtw	x6, w2
	add	x3, x3, :lo12:.LANCHOR108
	cmn	w1, #1
	str	w0, [x8, x6, lsl 2]
	ldrh	w0, [x3, x5, lsl 1]
	strh	w2, [x3, x5, lsl 1]
	strh	w0, [x4, x6, lsl 1]
	beq	.L1011
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LANCHOR66
	add	x29, sp, 0
	ldrh	w3, [x0, #:lo12:.LANCHOR66]
	mov	w0, 21
	sub	w2, w0, w3
	mov	w0, 1
	lsr	w1, w1, w3
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w1, w0, w1
	adrp	x0, .LANCHOR67
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	udiv	w0, w1, w0
	bl	ftl_vpn_decrement
	mov	w0, -1
	ldp	x29, x30, [sp], 16
	ret
.L1002:
	ldrh	w6, [x4, x10]
	strh	w6, [x4, w7, uxtw 1]
	b	.L1003
.L1001:
	mov	w7, w6
	ldrh	w6, [x4, x10]
	b	.L1000
.L1011:
	mov	w0, -1
	ret
	.size	lpa_hash_update_ppa, .-lpa_hash_update_ppa
	.section	.text.ftl_mask_bad_block,"ax",@progbits
	.align	2
	.global	ftl_mask_bad_block
	.type	ftl_mask_bad_block, %function
ftl_mask_bad_block:
	stp	x29, x30, [sp, -32]!
	adrp	x2, .LANCHOR67
	ubfx	x1, x0, 21, 3
	mov	w3, 21
	add	x29, sp, 0
	ldrb	w5, [x2, #:lo12:.LANCHOR67]
	stp	x19, x20, [sp, 16]
	cmp	w5, 1
	mul	w2, w1, w5
	and	w19, w2, 255
	adrp	x2, .LANCHOR66
	ldrh	w2, [x2, #:lo12:.LANCHOR66]
	lsr	w0, w0, w2
	sub	w2, w3, w2
	mov	w3, 1
	lsl	w3, w3, w2
	sub	w3, w3, #1
	and	w3, w3, w0
	and	w4, w3, 65535
	udiv	w3, w3, w5
	and	w20, w3, 65535
	bls	.L1015
	sub	w2, w5, #1
	and	w2, w2, w4
	add	w2, w19, w2
	and	w19, w2, 255
.L1015:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 14, .L1016
	adrp	x0, .LC59
	and	w3, w3, 65535
	mov	w2, w19
	add	x0, x0, :lo12:.LC59
	bl	printf
.L1016:
	adrp	x0, .LANCHOR6
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w0, w20
	bls	.L1014
	adrp	x0, .LANCHOR7
	mov	w2, 1
	lsl	w2, w2, w19
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x20, x0, x20, uxth 2
	ldrb	w19, [x20, 3]
	orr	w2, w2, w19
	strb	w2, [x20, 3]
.L1014:
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
	adrp	x24, .LANCHOR63
	stp	x27, x28, [sp, 80]
	and	w28, w0, 65535
	add	x0, x24, :lo12:.LANCHOR63
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	ldr	w0, [x0, 328]
	cbz	w0, .L1033
	adrp	x25, .LANCHOR78
	adrp	x27, .LANCHOR66
	add	x25, x25, :lo12:.LANCHOR78
	add	x22, x27, :lo12:.LANCHOR66
	mov	w23, 0
.L1024:
	ldrb	w0, [x25]
	cmp	w0, w23
	bhi	.L1031
.L1033:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1031:
	adrp	x0, .LANCHOR67
	ldrh	w3, [x27, #:lo12:.LANCHOR66]
	mov	w2, 21
	ldrb	w1, [x0, #:lo12:.LANCHOR67]
	sub	w2, w2, w3
	and	w0, w1, 65535
	cmp	w1, 1
	sdiv	w19, w23, w1
	lsl	w19, w19, w2
	madd	w19, w28, w0, w19
	and	w19, w19, 65535
	bls	.L1025
	sub	w0, w0, #1
	and	w0, w0, w23
	add	w19, w19, w0
	and	w19, w19, 65535
.L1025:
	adrp	x26, .LC60
	add	x21, x24, :lo12:.LANCHOR63
	add	x26, x26, :lo12:.LC60
	mov	w20, 0
.L1026:
	ldr	w0, [x21, 328]
	cmp	w20, w0
	bcc	.L1030
	add	w23, w23, 1
	and	w23, w23, 65535
	b	.L1024
.L1030:
	add	x0, x21, x20, sxtw 1
	ldrh	w0, [x0, 332]
	cmp	w0, w19
	bne	.L1027
	mov	w1, w19
	mov	x0, x26
	bl	printf
	ldrh	w0, [x22]
	lsl	w0, w19, w0
	bl	ftl_mask_bad_block
	ldr	w1, [x21, 328]
	mov	w0, w20
.L1028:
	cmp	w0, w1
	bcc	.L1029
	sub	w1, w1, #1
	str	w1, [x21, 328]
.L1027:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1026
.L1029:
	add	w2, w0, 1
	add	x0, x21, x0, sxtw 1
	add	x3, x21, x2, sxtw 1
	ldrh	w3, [x3, 332]
	strh	w3, [x0, 332]
	and	w0, w2, 65535
	b	.L1028
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
	stp	x21, x22, [sp, 32]
	ldr	x4, [x23, #:lo12:.LANCHOR7]
	lsl	x21, x24, 2
	stp	x19, x20, [sp, 16]
	mov	x19, x24
	add	x20, x4, x21
	ldrb	w0, [x20, 2]
	ubfx	x22, x0, 5, 3
	tbz	x0, 3, .L1039
	adrp	x1, .LANCHOR102
	ldrh	w2, [x4, x21]
	adrp	x8, .LANCHOR116
	ldr	x7, [x1, #:lo12:.LANCHOR102]
	and	w3, w2, 2047
	ldr	w2, [x4, x21]
	ldrh	w8, [x8, #:lo12:.LANCHOR116]
	ldrh	w1, [x7, 74]
	ubfx	x6, x2, 11, 8
	adrp	x2, .LANCHOR8
	add	w1, w3, w1
	ldrh	w2, [x2, #:lo12:.LANCHOR8]
	and	w5, w1, 65535
	ldrh	w1, [x7, 72]
	add	w1, w6, w1
	udiv	w7, w5, w2
	and	w1, w1, 65535
	add	w7, w7, w1
	cmp	w7, w8
	ble	.L1040
	adrp	x1, .LANCHOR93
	adrp	x7, .LANCHOR97
	ldrh	w5, [x1, #:lo12:.LANCHOR93]
	adrp	x1, .LANCHOR92
	ldrh	w7, [x7, #:lo12:.LANCHOR97]
	ldrh	w1, [x1, #:lo12:.LANCHOR92]
	add	w5, w5, 7
	add	w1, w1, w7
	cmp	w5, w1
	blt	.L1041
.L1057:
	mov	w1, 2
	bfi	w0, w1, 3, 2
.L1055:
	strb	w0, [x20, 2]
.L1042:
	ldrb	w0, [x20, 2]
	ands	w0, w0, 24
	bne	.L1046
	mul	w2, w6, w2
	ldrh	w0, [x4, x21]
	add	w2, w2, w2, lsl 1
	add	w2, w3, w2, lsr 2
	ubfx	x2, x2, 2, 9
	bfi	w0, w2, 0, 11
	strh	w0, [x4, x21]
.L1039:
	mov	w0, w19
	bl	zftl_remove_data_node
	ldr	x0, [x23, #:lo12:.LANCHOR7]
	add	w22, w22, 6
	and	w22, w22, 7
	add	x21, x0, x21
	cmp	w22, 4
	ldrb	w0, [x21, 2]
	and	w0, w0, 31
	strb	w0, [x21, 2]
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x24, lsl 1]
	bhi	.L1048
	mov	w0, w19
	bl	gc_free_bad_sblk
.L1048:
	ldrb	w0, [x20, 2]
	tbz	x0, 3, .L1049
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrh	w1, [x0, 584]
	cmp	w1, w19
	bne	.L1050
	mov	w1, -1
	ldrh	w2, [x0, 588]
	strh	w1, [x0, 584]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L1049
	strh	w19, [x0, 588]
	mov	w1, w19
	adrp	x0, .LC61
	add	x0, x0, :lo12:.LC61
.L1056:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	b	printf
.L1041:
	adrp	x1, .LANCHOR117
	adrp	x7, .LANCHOR95
	ldrh	w5, [x1, #:lo12:.LANCHOR117]
	adrp	x1, .LANCHOR90
	ldrh	w7, [x7, #:lo12:.LANCHOR95]
	ldrh	w1, [x1, #:lo12:.LANCHOR90]
	add	w5, w5, 7
	add	w1, w1, w7
	adrp	x7, .LANCHOR88
	ldrh	w7, [x7, #:lo12:.LANCHOR88]
	add	w1, w1, w7
	cmp	w5, w1
	blt	.L1057
.L1045:
	and	w0, w0, -25
	b	.L1055
.L1040:
	madd	w1, w2, w1, w5
	adrp	x5, .LANCHOR118
	ldrh	w5, [x5, #:lo12:.LANCHOR118]
	cmp	w1, w5
	ble	.L1042
	adrp	x1, .LANCHOR117
	adrp	x7, .LANCHOR95
	ldrh	w5, [x1, #:lo12:.LANCHOR117]
	adrp	x1, .LANCHOR90
	ldrh	w7, [x7, #:lo12:.LANCHOR95]
	ldrh	w1, [x1, #:lo12:.LANCHOR90]
	add	w5, w5, 7
	add	w1, w1, w7
	adrp	x7, .LANCHOR88
	ldrh	w7, [x7, #:lo12:.LANCHOR88]
	add	w1, w1, w7
	cmp	w5, w1
	bge	.L1045
	adrp	x1, .LANCHOR93
	adrp	x7, .LANCHOR97
	ldrh	w5, [x1, #:lo12:.LANCHOR93]
	adrp	x1, .LANCHOR92
	ldrh	w7, [x7, #:lo12:.LANCHOR97]
	ldrh	w1, [x1, #:lo12:.LANCHOR92]
	add	w5, w5, 7
	add	w1, w1, w7
	cmp	w5, w1
	blt	.L1045
	b	.L1057
.L1046:
	cmp	w0, 16
	bne	.L1039
	sdiv	w2, w3, w2
	ldr	w0, [x4, x21]
	add	w2, w2, w2, lsl 1
	add	w2, w6, w2, lsr 2
	ubfx	x2, x2, 2, 6
	bfi	w0, w2, 11, 8
	str	w0, [x4, x21]
	b	.L1039
.L1050:
	ldrh	w1, [x0, 586]
	cmp	w1, w19
	bne	.L1049
	mov	w1, -1
	ldrh	w2, [x0, 590]
	strh	w1, [x0, 586]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L1049
	strh	w19, [x0, 590]
	mov	w1, w19
	adrp	x0, .LC62
	add	x0, x0, :lo12:.LC62
	b	.L1056
.L1049:
	mov	w0, w19
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
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
	adrp	x21, .LANCHOR63
	stp	x23, x24, [sp, 48]
	adrp	x22, .LC63
	adrp	x23, .LANCHOR9
	add	x21, x21, :lo12:.LANCHOR63
	mov	x24, x23
	add	x22, x22, :lo12:.LC63
	stp	x19, x20, [sp, 16]
	mov	w20, 0
	stp	x25, x26, [sp, 64]
.L1059:
	ldrh	w0, [x21, 56]
	cmp	w0, w20
	bhi	.L1073
	strh	wzr, [x21, 56]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1073:
	add	x0, x21, x20, sxtw 1
	ldrh	w25, [x0, 58]
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	mov	x19, x25
	lsl	x26, x25, 1
	ldrh	w2, [x0, x26]
	cbz	w2, .L1060
	mov	w1, w25
	mov	x0, x22
	bl	printf
.L1060:
	ldr	x0, [x24, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x26]
	adrp	x0, .LANCHOR7
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x25, x0, x25, lsl 2
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L1061
	ldrb	w2, [x25, 2]
	adrp	x0, .LC64
	mov	w1, w19
	add	x0, x0, :lo12:.LC64
	ubfx	x2, x2, 5, 3
	bl	printf
.L1061:
	ldrb	w0, [x25, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L1062
	tst	w0, 192
	bne	.L1063
.L1062:
	adrp	x1, .LANCHOR119
	adrp	x0, .LC0
	mov	w2, 932
	add	x1, x1, :lo12:.LANCHOR119
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1063:
	mov	w0, w19
	bl	ftl_free_sblk
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrh	w2, [x0, 124]
	cbz	w2, .L1064
	add	x3, x0, 392
	mov	w1, 0
.L1066:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L1065
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 392]
	strh	w2, [x0, 124]
.L1064:
	ldrh	w2, [x0, 120]
	cbz	w2, .L1067
	add	x3, x0, 136
	mov	w1, 0
.L1069:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L1068
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 136]
	strh	w2, [x0, 120]
.L1067:
	ldrh	w2, [x0, 122]
	cbz	w2, .L1070
	add	x3, x0, 264
	mov	w1, 0
.L1072:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L1071
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 264]
	strh	w2, [x0, 122]
.L1070:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1059
.L1065:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L1066
	b	.L1064
.L1068:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L1069
	b	.L1067
.L1071:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L1072
	b	.L1070
	.size	gc_free_src_blk, .-gc_free_src_blk
	.section	.text.print_ftl_debug_info,"ax",@progbits
	.align	2
	.global	print_ftl_debug_info
	.type	print_ftl_debug_info, %function
print_ftl_debug_info:
	sub	sp, sp, #64
	adrp	x2, .LANCHOR88
	adrp	x8, .LANCHOR120
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	ldrh	w7, [x2, #:lo12:.LANCHOR88]
	adrp	x2, .LANCHOR90
	stp	x19, x20, [sp, 48]
	adrp	x19, .LANCHOR102
	adrp	x20, .LANCHOR10
	ldrh	w6, [x2, #:lo12:.LANCHOR90]
	adrp	x2, .LANCHOR99
	ldr	x1, [x19, #:lo12:.LANCHOR102]
	ldrh	w5, [x2, #:lo12:.LANCHOR99]
	adrp	x2, .LANCHOR97
	ldr	x0, [x20, #:lo12:.LANCHOR10]
	ldrh	w4, [x2, #:lo12:.LANCHOR97]
	adrp	x2, .LANCHOR95
	ldr	w8, [x8, #:lo12:.LANCHOR120]
	ldrh	w3, [x2, #:lo12:.LANCHOR95]
	ldrh	w2, [x1, 146]
	ldrh	w1, [x1, 148]
	str	w8, [sp, 24]
	ldr	w8, [x0, 528]
	str	w8, [sp, 16]
	ldr	w0, [x0, 524]
	str	w0, [sp, 8]
	adrp	x0, .LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	str	w0, [sp]
	adrp	x0, .LC65
	add	x0, x0, :lo12:.LC65
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	adrp	x1, .LANCHOR121
	ldrb	w3, [x1, #:lo12:.LANCHOR121]
	ldr	w4, [x0, 8]
	ldr	w5, [x0, 64]
	ldr	w1, [x0, 20]
	ldr	w2, [x0, 28]
	adrp	x0, .LC66
	add	x0, x0, :lo12:.LC66
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	ldr	w1, [x0, 52]
	ldr	w2, [x0, 60]
	ldr	w3, [x0, 16]
	adrp	x0, .LC67
	add	x0, x0, :lo12:.LC67
	lsr	w3, w3, 11
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR102]
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
	adrp	x0, .LANCHOR79
	ldrh	w5, [x0, #:lo12:.LANCHOR79]
	adrp	x0, .LANCHOR84
	ldrh	w4, [x0, #:lo12:.LANCHOR84]
	adrp	x0, .LANCHOR62
	ldrh	w3, [x0, #:lo12:.LANCHOR62]
	adrp	x0, .LANCHOR94
	ldrh	w2, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR91
	ldrh	w1, [x0, #:lo12:.LANCHOR91]
	adrp	x0, .LC69
	add	x0, x0, :lo12:.LC69
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR10]
	ldp	x29, x30, [sp, 32]
	ldp	x19, x20, [sp, 48]
	add	sp, sp, 64
	ldrh	w4, [x0, 590]
	ldrh	w3, [x0, 588]
	ldrh	w2, [x0, 586]
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
	cbnz	x0, .L1099
	adrp	x1, .LANCHOR122
	add	x1, x1, :lo12:.LANCHOR122
	mov	w2, 668
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	bl	print_ftl_debug_info
	mov	w0, -1
.L1098:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L1102:
	mov	x1, x19
	adrp	x0, .LANCHOR57
	add	x0, x0, :lo12:.LANCHOR57
	bl	buf_add_tail
	adrp	x1, .LANCHOR102
	ldrb	w3, [x19, 56]
	ldrb	w0, [x21, #:lo12:.LANCHOR58]
	ldr	x1, [x1, #:lo12:.LANCHOR102]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x21, #:lo12:.LANCHOR58]
	ldr	w2, [x1, 16]
	add	w2, w2, w3
	str	w2, [x1, 16]
	ldr	w2, [x1, 32]
	add	w2, w2, 1
	str	w2, [x1, 32]
	b	.L1098
.L1099:
	mov	x19, x0
	adrp	x0, .LANCHOR123
	mov	x20, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR123]
	ldrb	w2, [x19, 56]
	cmp	w2, w1
	bls	.L1104
	adrp	x1, .LANCHOR122
	adrp	x0, .LC0
	mov	w2, 673
	add	x1, x1, :lo12:.LANCHOR122
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1104:
	ldrb	w0, [x19, 56]
	adrp	x21, .LANCHOR58
	cbz	w0, .L1101
	ldrb	w1, [x20, #:lo12:.LANCHOR123]
	cmp	w1, w0
	bcs	.L1102
.L1101:
	mov	x0, x19
	bl	buf_free
	ldrb	w0, [x21, #:lo12:.LANCHOR58]
	b	.L1098
	.size	ftl_write_buf, .-ftl_write_buf
	.section	.text.ftl_write_completed,"ax",@progbits
	.align	2
	.global	ftl_write_completed
	.type	ftl_write_completed, %function
ftl_write_completed:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR50
	add	x19, x19, :lo12:.LANCHOR50
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR124
	mov	x22, x19
	add	x21, x21, :lo12:.LANCHOR124
	stp	x23, x24, [sp, 48]
	mov	w24, 0
.L1110:
	ldrb	w0, [x21]
	cmp	w0, 255
	bne	.L1118
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1118:
	lsl	x1, x0, 6
	ubfiz	x20, x0, 6, 8
	add	x23, x19, x1
	add	x20, x19, x20
	ldrb	w1, [x19, x1]
	strb	w1, [x21]
	ldr	w1, [x23, 52]
	cmn	w1, #1
	bne	.L1111
	adrp	x1, .LANCHOR66
	ldr	w3, [x23, 40]
	mov	w5, 65535
	ldrh	w2, [x1, #:lo12:.LANCHOR66]
	mov	w1, 21
	sub	w4, w1, w2
	mov	w1, 1
	lsr	w2, w3, w2
	lsl	w1, w1, w4
	sub	w1, w1, #1
	and	w1, w1, w2
	adrp	x2, .LANCHOR67
	ldrb	w2, [x2, #:lo12:.LANCHOR67]
	udiv	w1, w1, w2
	adrp	x2, .LANCHOR10
	mov	x23, x2
	ldr	x4, [x2, #:lo12:.LANCHOR10]
	and	w24, w1, 65535
	and	w1, w1, w5
	ldr	w6, [x4, 560]
	cmp	w6, w5
	bne	.L1112
	str	w1, [x4, 560]
	str	w3, [x4, 564]
.L1112:
	add	x0, x22, x0, lsl 6
	ldr	w2, [x0, 36]
	adrp	x0, .LC71
	add	x0, x0, :lo12:.LC71
	bl	printf
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	ldr	w1, [x0, 556]
	add	w1, w1, 1
	str	w1, [x0, 556]
	ldrh	w1, [x0, 16]
	cmp	w1, w24
	bne	.L1113
	strh	wzr, [x0, 22]
.L1114:
	mov	x0, x20
	mov	w24, 1
	bl	ftl_write_buf
	b	.L1110
.L1113:
	ldrh	w1, [x0, 48]
	cmp	w1, w24
	bne	.L1114
	strh	wzr, [x0, 54]
	b	.L1114
.L1111:
	cbz	w24, .L1116
	ldp	w1, w2, [x23, 36]
	adrp	x0, .LC72
	add	x0, x0, :lo12:.LC72
	bl	printf
	mov	x0, x20
	bl	ftl_write_buf
	b	.L1110
.L1116:
	ldrh	w2, [x23, 48]
	ldr	w0, [x23, 36]
	ldr	w1, [x23, 44]
	bl	lpa_hash_update_ppa
	ldrb	w0, [x23, 2]
	tbz	x0, 2, .L1117
	and	w0, w0, -3
	strb	w0, [x23, 2]
	b	.L1110
.L1117:
	mov	x0, x20
	bl	buf_free
	b	.L1110
	.size	ftl_write_completed, .-ftl_write_completed
	.section	.text.zftl_add_read_buf,"ax",@progbits
	.align	2
	.global	zftl_add_read_buf
	.type	zftl_add_read_buf, %function
zftl_add_read_buf:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	cbnz	x0, .L1121
	mov	w2, 964
	adrp	x1, .LANCHOR125
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR125
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	print_ftl_debug_info
.L1121:
	ldrb	w1, [x0, 56]
	mov	x19, x0
	adrp	x0, .LANCHOR123
	ldrb	w0, [x0, #:lo12:.LANCHOR123]
	cmp	w1, w0
	bls	.L1123
	adrp	x1, .LANCHOR125
	adrp	x0, .LC0
	mov	w2, 969
	add	x1, x1, :lo12:.LANCHOR125
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1123:
	mov	x1, x19
	adrp	x0, .LANCHOR126
	add	x0, x0, :lo12:.LANCHOR126
	bl	buf_add_tail
	adrp	x1, .LANCHOR127
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ldrb	w0, [x1, #:lo12:.LANCHOR127]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR127]
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
	beq	.L1128
	adrp	x0, .LANCHOR7
	lsl	w22, w22, 1
	ldr	x21, [x0, #:lo12:.LANCHOR7]
	add	x21, x21, x19, uxth 2
	ldrb	w0, [x21, 2]
	tst	w0, 224
	beq	.L1129
	adrp	x1, .LANCHOR128
	adrp	x0, .LC0
	mov	w2, 833
	add	x1, x1, :lo12:.LANCHOR128
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1129:
	ldrb	w0, [x21, 2]
	bfi	w0, w20, 5, 3
	ubfx	x1, x0, 3, 2
	orr	w22, w22, w1
	bfi	w0, w22, 3, 2
	strb	w0, [x21, 2]
.L1130:
	mov	w0, w19
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1128:
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
	mov	w2, 843
	adrp	x1, .LANCHOR128
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR128
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L1130
	.size	ftl_alloc_sblk, .-ftl_alloc_sblk
	.section	.text.sblk_init,"ax",@progbits
	.align	2
	.global	sblk_init
	.type	sblk_init, %function
sblk_init:
	adrp	x1, .LANCHOR54
	mov	w0, -1
	strb	w0, [x1, #:lo12:.LANCHOR54]
	adrp	x1, .LANCHOR124
	strb	w0, [x1, #:lo12:.LANCHOR124]
	adrp	x1, .LANCHOR129
	strb	w0, [x1, #:lo12:.LANCHOR129]
	adrp	x1, .LANCHOR69
	strb	w0, [x1, #:lo12:.LANCHOR69]
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
	adrp	x19, .LANCHOR54
	str	x21, [sp, 32]
	ldrb	w1, [x19, #:lo12:.LANCHOR54]
	bl	printf
	ldrb	w19, [x19, #:lo12:.LANCHOR54]
	cmp	w19, 255
	beq	.L1137
	adrp	x1, .LANCHOR50
	ubfiz	x19, x19, 6, 8
	add	x1, x1, :lo12:.LANCHOR50
	adrp	x21, .LC75
	add	x19, x1, x19
	add	x21, x21, :lo12:.LC75
	mov	x20, x1
.L1139:
	ldrb	w2, [x19, 58]
	mov	x0, x21
	ldrb	w1, [x19, 1]
	ldr	w3, [x19, 40]
	bl	printf
	ldrb	w19, [x19]
	cmp	w19, 255
	beq	.L1137
	ubfiz	x19, x19, 6, 8
	add	x19, x20, x19
	b	.L1139
.L1137:
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
	adrp	x2, .LANCHOR54
	ldrb	w2, [x2, #:lo12:.LANCHOR54]
	cmp	w2, 255
	beq	.L1155
	adrp	x3, .LANCHOR66
	adrp	x7, .LANCHOR50
	add	x7, x7, :lo12:.LANCHOR50
	adrp	x10, .L1151
	ldrh	w8, [x3, #:lo12:.LANCHOR66]
	mov	w3, 21
	ubfx	x11, x0, 21, 3
	add	x10, x10, :lo12:.L1151
	sub	w4, w3, w8
	mov	w3, 1
	mov	x12, x7
	lsl	w3, w3, w4
	adrp	x4, .LANCHOR67
	sub	w3, w3, #1
	ldrb	w6, [x4, #:lo12:.LANCHOR67]
	and	w3, w3, 65535
	asr	w4, w0, w8
	sub	w6, w6, #1
	and	w6, w6, 65535
	and	w4, w4, w6
	and	w4, w4, w3
.L1154:
	add	x0, x7, x2, lsl 6
	ldr	w5, [x0, 40]
	ubfx	x13, x5, 21, 3
	cmp	w11, w13
	bne	.L1149
	lsr	w5, w5, w8
	and	w5, w6, w5
	and	w5, w3, w5
	ldrb	w0, [x0, 58]
	cmp	w4, w5
	bne	.L1150
	cmp	w1, 1
	bne	.L1147
	cmp	w0, 7
	ccmp	w0, 9, 4, ne
	beq	.L1149
	ret
.L1150:
	cmp	w1, 3
	bhi	.L1149
	ldrb	w5, [x10,w1,uxtw]
	adr	x13, .Lrtx1151
	add	x5, x13, w5, sxtb #2
	br	x5
.Lrtx1151:
	.section	.rodata.queue_lun_state,"a",@progbits
	.align	0
	.align	2
.L1151:
	.byte	(.L1147 - .Lrtx1151) / 4
	.byte	(.L1152 - .Lrtx1151) / 4
	.byte	(.L1153 - .Lrtx1151) / 4
	.byte	(.L1147 - .Lrtx1151) / 4
	.section	.text.queue_lun_state
.L1152:
	cmp	w0, 7
	ccmp	w0, 9, 4, ne
	beq	.L1149
	ret
.L1153:
	cmp	w0, 11
	bne	.L1147
.L1149:
	lsl	x2, x2, 6
	ldrb	w2, [x12, x2]
	cmp	w2, 255
	bne	.L1154
.L1155:
	mov	w0, 0
.L1147:
	ret
	.size	queue_lun_state, .-queue_lun_state
	.section	.text.queue_remove_completed_req,"ax",@progbits
	.align	2
	.global	queue_remove_completed_req
	.type	queue_remove_completed_req, %function
queue_remove_completed_req:
	adrp	x4, .LANCHOR124
	adrp	x8, .LANCHOR69
	adrp	x1, .LANCHOR54
	adrp	x7, .LANCHOR129
	adrp	x3, .LANCHOR50
	ldrb	w14, [x4, #:lo12:.LANCHOR124]
	add	x5, x3, :lo12:.LANCHOR50
	ldrb	w2, [x1, #:lo12:.LANCHOR54]
	ldrb	w12, [x8, #:lo12:.LANCHOR69]
	mov	x11, x5
	ldrb	w13, [x7, #:lo12:.LANCHOR129]
	add	x16, x8, :lo12:.LANCHOR69
	add	x7, x7, :lo12:.LANCHOR129
	add	x10, x4, :lo12:.LANCHOR124
	mov	w6, 0
	mov	w15, -1
.L1158:
	cmp	w2, 255
	beq	.L1159
	sbfiz	x8, x2, 6, 32
	sxtw	x0, w2
	add	x4, x5, x8
	ldrb	w4, [x4, 58]
	sub	w4, w4, #12
	and	w4, w4, 255
	cmp	w4, 1
	bls	.L1160
	cbz	w6, .L1157
	strb	w2, [x1, #:lo12:.LANCHOR54]
	ret
.L1160:
	lsl	x6, x0, 6
	ldrb	w2, [x5, x8]
	add	x4, x5, x6
	strb	w15, [x5, x6]
	ldrb	w6, [x4, 59]
	cmp	w6, 1
	bne	.L1163
	ldrh	w4, [x4, 50]
	cbnz	w4, .L1171
	mov	w4, w14
	mov	x6, x10
.L1164:
	cmp	w4, 255
	bne	.L1169
	add	x3, x3, :lo12:.LANCHOR50
	strb	w2, [x1, #:lo12:.LANCHOR54]
	add	x0, x3, x0, lsl 6
	ldrb	w0, [x0, 1]
	strb	w0, [x6]
	ret
.L1163:
	cbnz	w6, .L1165
	ldr	w4, [x4, 36]
	cmn	w4, #1
	beq	.L1165
	mov	w4, w13
	mov	x6, x7
	b	.L1164
.L1171:
	mov	w4, w12
	mov	x6, x16
	b	.L1164
.L1169:
	mov	w6, w4
	sbfiz	x4, x4, 6, 32
	ldrb	w4, [x11, x4]
	cmp	w4, 255
	bne	.L1169
	add	x0, x11, x0, lsl 6
	sbfiz	x6, x6, 6, 32
	ldrb	w0, [x0, 1]
	strb	w0, [x11, x6]
.L1165:
	mov	w6, 1
	b	.L1158
.L1159:
	cbz	w6, .L1157
	mov	w0, -1
	strb	w0, [x1, #:lo12:.LANCHOR54]
.L1157:
	ret
	.size	queue_remove_completed_req, .-queue_remove_completed_req
	.section	.text.pm_alloc_new_blk,"ax",@progbits
	.align	2
	.global	pm_alloc_new_blk
	.type	pm_alloc_new_blk, %function
pm_alloc_new_blk:
	stp	x29, x30, [sp, -64]!
	adrp	x2, .LANCHOR78
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR102
	stp	x21, x22, [sp, 32]
	ldr	x1, [x20, #:lo12:.LANCHOR102]
	ldrb	w2, [x2, #:lo12:.LANCHOR78]
	ldrh	w0, [x1, 690]
	str	x23, [sp, 48]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, 690]
	cmp	w2, w0
	bls	.L1182
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x0, 672]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1183
.L1182:
	adrp	x19, .LC76
	add	x19, x19, :lo12:.LC76
	adrp	x23, .LANCHOR7
.L1195:
	mov	w0, 1
	bl	ftl_alloc_sblk
	mov	w1, 0
	and	w21, w0, 65535
	bl	ftl_erase_sblk
	add	x14, x20, :lo12:.LANCHOR102
	ldr	x1, [x20, #:lo12:.LANCHOR102]
	mov	w0, w21
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	tst	w0, 65535
	bne	.L1184
	mov	w1, w21
	mov	x0, x19
	bl	printf
	ldr	x1, [x23, #:lo12:.LANCHOR7]
	add	x1, x1, x21, uxth 2
	ldrb	w0, [x1, 2]
	orr	w0, w0, -32
	strb	w0, [x1, 2]
	b	.L1195
.L1184:
	ldr	x0, [x14]
	adrp	x1, .LANCHOR130
	mov	w2, 1
	mov	w19, 0
	add	x0, x0, 416
	str	w2, [x1, #:lo12:.LANCHOR130]
	mov	w1, 65535
	strh	wzr, [x0, 274]
.L1186:
	ldrh	w2, [x0]
	cmp	w2, w1
	beq	.L1185
	add	w19, w19, 1
	add	x0, x0, 2
	and	w19, w19, 65535
	cmp	w19, 128
	bne	.L1186
	adrp	x1, .LANCHOR131
	adrp	x0, .LC0
	mov	w2, 194
	add	x1, x1, :lo12:.LANCHOR131
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1185:
	ldr	x0, [x20, #:lo12:.LANCHOR102]
	add	x19, x0, x19, sxtw 1
	ldrh	w1, [x0, 688]
	strh	w21, [x19, 416]
	add	w1, w1, 1
	strh	w1, [x0, 688]
.L1183:
	ldr	x1, [x20, #:lo12:.LANCHOR102]
	ldrh	w0, [x1, 690]
	add	x0, x0, 336
	ldrh	w19, [x1, x0, lsl 1]
	mov	w0, 65533
	sub	w1, w19, #1
	cmp	w0, w1, uxth
	bcs	.L1188
	adrp	x1, .LANCHOR131
	adrp	x0, .LC0
	mov	w2, 199
	add	x1, x1, :lo12:.LANCHOR131
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1188:
	adrp	x1, .LANCHOR66
	ldr	x0, [x20, #:lo12:.LANCHOR102]
	mov	w2, 21
	ldrh	w1, [x1, #:lo12:.LANCHOR66]
	sub	w2, w2, w1
	strh	wzr, [x0, 696]
	strh	w19, [x0, 692]
	asr	w4, w19, w2
	strh	w4, [x0, 694]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1191
	mov	w0, 1
	and	w4, w4, 65535
	lsl	w2, w0, w2
	mov	w3, w19
	adrp	x0, .LC77
	sub	w2, w2, #1
	mov	w1, w19
	add	x0, x0, :lo12:.LC77
	bl	printf
.L1191:
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
	adrp	x0, .LANCHOR132
	add	x0, x0, :lo12:.LANCHOR132
	mov	x1, 0
	add	x29, sp, 0
	mov	w2, 65535
	str	x19, [sp, 16]
.L1200:
	lsl	x3, x1, 4
	and	w19, w1, 65535
	ldrh	w3, [x3, x0]
	cmp	w3, w2
	beq	.L1199
	add	x1, x1, 1
	cmp	x1, 32
	bne	.L1200
	add	x0, x0, 2
	mov	w19, w1
	mov	x2, x0
	mov	w4, 32768
	mov	w1, 0
.L1202:
	ldrh	w3, [x2]
	tbnz	x3, 15, .L1201
	cmp	w3, w4
	bcs	.L1201
	mov	w4, w3
	mov	w19, w1
.L1201:
	add	w1, w1, 1
	add	x2, x2, 16
	and	w1, w1, 65535
	cmp	w1, 32
	bne	.L1202
	cmp	w19, 32
	bne	.L1199
	adrp	x1, .LANCHOR133
	mov	w2, -1
	ldrb	w3, [x1, #:lo12:.LANCHOR133]
	mov	w1, 0
.L1204:
	ldrh	w5, [x0]
	cmp	w5, w2
	bcs	.L1203
	ldrh	w4, [x0, -2]
	cmp	w4, w3
	csel	w2, w2, w5, eq
	csel	w19, w19, w1, eq
.L1203:
	add	w1, w1, 1
	add	x0, x0, 16
	and	w1, w1, 65535
	cmp	w1, 32
	bne	.L1204
	cmp	w19, 32
	bne	.L1199
	adrp	x1, .LANCHOR134
	adrp	x0, .LC0
	mov	w2, 297
	add	x1, x1, :lo12:.LANCHOR134
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1199:
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
	adrp	x0, .LANCHOR135
	str	xzr, [x0, #:lo12:.LANCHOR135]
	adrp	x0, .LANCHOR136
	str	wzr, [x0, #:lo12:.LANCHOR136]
	adrp	x0, .LANCHOR137
	str	xzr, [x0, #:lo12:.LANCHOR137]
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
	cbnz	w0, .L1212
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1213:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 256
	bne	.L1213
.L1219:
	adrp	x20, .LANCHOR138
	add	x20, x20, :lo12:.LANCHOR138
	mov	w2, 1024
	mov	w1, 255
	mov	x0, x20
	add	x19, x19, :lo12:.LANCHOR3
	bl	ftl_memset
	mov	x0, 0
.L1214:
	ldrh	w1, [x0, x19]
	add	x0, x0, 2
	cmp	x0, 512
	strh	w1, [x20, w1, sxtw 1]
	bne	.L1214
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1212:
	cmp	w0, 1
	bne	.L1215
	add	x3, x19, :lo12:.LANCHOR3
	mov	x1, 0
.L1218:
	and	w0, w1, 65535
	cmp	x1, 3
	bls	.L1216
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 2
	sub	w0, w2, w0
	and	w0, w0, 65535
.L1216:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L1218
	b	.L1219
.L1215:
	cmp	w0, 2
	bne	.L1220
	add	x3, x19, :lo12:.LANCHOR3
	mov	w1, 65535
	mov	x0, 0
.L1222:
	cmp	x0, 2
	and	w2, w0, 65535
	csel	w2, w2, w1, cc
	strh	w2, [x3, x0, lsl 1]
	add	w1, w1, 2
	add	x0, x0, 1
	and	w1, w1, 65535
	cmp	x0, 256
	bne	.L1222
	b	.L1219
.L1220:
	cmp	w0, 3
	bne	.L1223
	add	x3, x19, :lo12:.LANCHOR3
	mov	x1, 0
.L1226:
	and	w0, w1, 65535
	cmp	x1, 5
	bls	.L1224
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 4
	sub	w0, w2, w0
	and	w0, w0, 65535
.L1224:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L1226
	b	.L1219
.L1223:
	cmp	w0, 4
	bne	.L1227
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
.L1229:
	and	w3, w0, 1
	ubfiz	w2, w0, 1, 15
	add	w3, w3, 6
	add	w0, w0, 1
	sub	w2, w2, w3
	strh	w2, [x1], 2
	and	w0, w0, 65535
	cmp	w0, 256
	bne	.L1229
	b	.L1219
.L1227:
	cmp	w0, 5
	bne	.L1230
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1231:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 16
	bne	.L1231
	add	x1, x1, 32
.L1232:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 496
	bne	.L1232
	b	.L1219
.L1230:
	cmp	w0, 8
	bne	.L1233
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1234:
	strh	w0, [x0, x1]
	add	x0, x0, 2
	cmp	x0, 512
	bne	.L1234
	b	.L1219
.L1233:
	cmp	w0, 9
	bne	.L1219
	add	x0, x19, :lo12:.LANCHOR3
	mov	w1, 1
	add	x0, x0, 6
	strh	wzr, [x19, #:lo12:.LANCHOR3]
	strh	w1, [x0, -4]
	mov	w1, 2
	strh	w1, [x0, -2]
	mov	w1, 3
.L1235:
	strh	w1, [x0], 2
	add	w1, w1, 2
	and	w1, w1, 65535
	cmp	w1, 509
	bne	.L1235
	b	.L1219
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
	tbz	x0, 12, .L1252
	adrp	x1, .LANCHOR139
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR139
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1252:
	adrp	x22, .LANCHOR31
	add	x19, x22, :lo12:.LANCHOR31
	adrp	x23, .LANCHOR2
	adrp	x24, .LANCHOR18
	adrp	x21, .LANCHOR30
	mov	w2, 8
	ldrh	w0, [x19, 26]
	adrp	x20, .LANCHOR141
	ldrb	w1, [x19, 12]
	strh	w0, [x23, #:lo12:.LANCHOR2]
	ldrh	w0, [x19, 10]
	strb	wzr, [x24, #:lo12:.LANCHOR18]
	sdiv	w0, w0, w1
	adrp	x1, .LANCHOR140
	strh	w0, [x1, #:lo12:.LANCHOR140]
	mov	w1, 0
	add	x0, x21, :lo12:.LANCHOR30
	bl	ftl_memset
	add	x0, x20, :lo12:.LANCHOR141
	mov	w2, 32
	mov	w1, 0
	bl	ftl_memset
	mov	x15, x21
	mov	x11, x20
	adrp	x12, .LANCHOR32
	adrp	x14, .LANCHOR42
	mov	x7, x22
	add	x12, x12, :lo12:.LANCHOR32
	add	x20, x14, :lo12:.LANCHOR42
	add	x21, x19, 1
	mov	x10, 0
.L1254:
	ldrb	w2, [x19]
	mov	w0, 2
	strb	w0, [x10, x12]
	add	x1, x20, x10, lsl 3
	mov	x0, x21
	bl	flash_mem_cmp8
	cbnz	w0, .L1253
	ldrb	w2, [x24, #:lo12:.LANCHOR18]
	add	x1, x11, :lo12:.LANCHOR141
	add	w0, w2, 1
	strb	w0, [x24, #:lo12:.LANCHOR18]
	and	w0, w10, 255
	str	wzr, [x1, x2, lsl 2]
	add	x1, x15, :lo12:.LANCHOR30
	strb	w0, [x1, x2]
	bl	zftl_flash_enter_slc_mode
.L1253:
	add	x10, x10, 1
	cmp	x10, 4
	bne	.L1254
	add	x0, x7, :lo12:.LANCHOR31
	ldrb	w1, [x0, 8]
	cmp	w1, 2
	beq	.L1255
.L1259:
	add	x7, x7, :lo12:.LANCHOR31
	ldrb	w0, [x24, #:lo12:.LANCHOR18]
	ldp	x19, x20, [sp, 16]
	ldrb	w1, [x7, 13]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	mul	w0, w0, w1
	ldrh	w1, [x7, 14]
	ldp	x29, x30, [sp], 64
	mul	w0, w0, w1
	adrp	x1, .LANCHOR142
	strh	w0, [x1, #:lo12:.LANCHOR142]
	ret
.L1255:
	ldrh	w1, [x23, #:lo12:.LANCHOR2]
	add	x14, x14, :lo12:.LANCHOR42
	ldrb	w12, [x0, 13]
	add	x10, x0, 1
	ldrb	w20, [x7, #:lo12:.LANCHOR31]
	add	x19, x24, :lo12:.LANCHOR18
	ldrb	w21, [x0, 23]
	add	x11, x11, :lo12:.LANCHOR141
	add	x15, x15, :lo12:.LANCHOR30
	mov	x13, 0
	mul	w12, w12, w1
	ldrh	w1, [x0, 14]
	and	w1, w1, 65280
	mul	w12, w12, w1
	lsl	w22, w12, 1
.L1258:
	mov	w2, w20
	add	x1, x14, x13, lsl 3
	mov	x0, x10
	bl	flash_mem_cmp8
	cbnz	w0, .L1256
	ldrb	w1, [x19]
	cmp	w21, 0
	csel	w2, w12, w22, eq
	add	w0, w1, 1
	strb	w0, [x19]
	str	w2, [x11, x1, lsl 2]
	strb	w13, [x15, x1]
.L1256:
	add	x13, x13, 1
	cmp	x13, 4
	bne	.L1258
	b	.L1259
	.size	flash_die_info_init, .-flash_die_info_init
	.section	.text.lpa_hash_init,"ax",@progbits
	.align	2
	.global	lpa_hash_init
	.type	lpa_hash_init, %function
lpa_hash_init:
	stp	x29, x30, [sp, -16]!
	mov	w2, 512
	mov	w1, 255
	adrp	x0, .LANCHOR108
	add	x29, sp, 0
	add	x0, x0, :lo12:.LANCHOR108
	bl	ftl_memset
	adrp	x0, .LANCHOR85
	mov	w1, 255
	ldp	x29, x30, [sp], 16
	ldrh	w2, [x0, #:lo12:.LANCHOR85]
	adrp	x0, .LANCHOR78
	ldrb	w0, [x0, #:lo12:.LANCHOR78]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR110
	ldr	x0, [x0, #:lo12:.LANCHOR110]
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
	tbz	x0, 12, .L1272
	adrp	x1, .LANCHOR143
	adrp	x0, .LC78
	mov	w3, 0
	mov	w2, 224
	add	x1, x1, :lo12:.LANCHOR143
	add	x0, x0, :lo12:.LC78
	bl	printf
.L1272:
	adrp	x20, .LANCHOR85
	adrp	x22, .LANCHOR78
	adrp	x19, .LANCHOR108
	add	x19, x19, :lo12:.LANCHOR108
	mov	w2, 512
	mov	w1, 255
	mov	x0, x19
	bl	ftl_memset
	ldrh	w2, [x20, #:lo12:.LANCHOR85]
	adrp	x21, .LANCHOR110
	ldrb	w0, [x22, #:lo12:.LANCHOR78]
	mov	w1, 255
	add	x20, x20, :lo12:.LANCHOR85
	mul	w2, w2, w0
	ldr	x0, [x21, #:lo12:.LANCHOR110]
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR109
	ldrb	w3, [x22, #:lo12:.LANCHOR78]
	ldr	x5, [x21, #:lo12:.LANCHOR110]
	mov	w1, 0
	ldr	x4, [x0, #:lo12:.LANCHOR109]
.L1273:
	ldrh	w0, [x20]
	mul	w0, w0, w3
	cmp	w1, w0, lsl 1
	blt	.L1275
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L1275:
	uxtw	x2, w1
	ldr	w0, [x4, x2, lsl 2]
	cmn	w0, #1
	beq	.L1274
	and	x0, x0, 255
	ldrh	w6, [x19, x0, lsl 1]
	strh	w1, [x19, x0, lsl 1]
	strh	w6, [x5, x2, lsl 1]
.L1274:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L1273
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
	adrp	x1, .LANCHOR31
	add	x1, x1, :lo12:.LANCHOR31
	adrp	x0, .LANCHOR2
	adrp	x3, .LANCHOR59
	strb	wzr, [x19, 10]
	mov	w4, 1
	ldrb	w2, [x1, 9]
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	mul	w0, w2, w0
	strb	w0, [x19, 4]
	ubfx	x0, x0, 8, 8
	strb	w0, [x19, 5]
	adrp	x0, .LANCHOR44
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	strb	w0, [x19, 7]
	add	x0, x3, :lo12:.LANCHOR59
	ldrb	w3, [x3, #:lo12:.LANCHOR59]
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
.L1284:
	cmp	w3, w1, uxtb
	bhi	.L1285
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1285:
	ldrb	w0, [x1, x2]
	add	x1, x1, 1
	ldrb	w5, [x19, 10]
	lsl	w0, w4, w0
	orr	w0, w0, w5
	strb	w0, [x19, 10]
	b	.L1284
	.size	zftl_read_flash_info, .-zftl_read_flash_info
	.section	.text.gc_static_wearleveling,"ax",@progbits
	.align	2
	.global	gc_static_wearleveling
	.type	gc_static_wearleveling, %function
gc_static_wearleveling:
	stp	x29, x30, [sp, -160]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR102
	stp	x19, x20, [sp, 16]
	ldr	x0, [x25, #:lo12:.LANCHOR102]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	ldr	w1, [x0, 32]
	mov	w0, 10240
	cmp	w1, w0
	bls	.L1288
	bl	ftl_tmp_into_update
.L1288:
	adrp	x19, .LANCHOR10
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w1, [x0, 568]
	ldr	w2, [x0, 12]
	add	w1, w1, 860160
	add	w1, w1, 3840
	cmp	w2, w1
	bhi	.L1289
	ldr	x3, [x25, #:lo12:.LANCHOR102]
	ldr	w1, [x0, 572]
	add	w1, w1, 32
	ldr	w3, [x3, 36]
	cmp	w3, w1
	bls	.L1338
.L1289:
	ldr	x1, [x25, #:lo12:.LANCHOR102]
	mov	w20, 65535
	adrp	x8, .LANCHOR14
	mov	w21, w20
	add	x8, x8, :lo12:.LANCHOR14
	mov	w28, 0
	mov	w27, 0
	mov	w22, 0
	ldr	w3, [x1, 36]
	adrp	x23, .LANCHOR7
	ldrh	w24, [x1, 134]
	str	w2, [x0, 568]
	str	w3, [x0, 572]
	adrp	x0, .LANCHOR6
	add	x10, x0, :lo12:.LANCHOR6
	str	wzr, [x29, 128]
	str	wzr, [x29, 136]
	stp	wzr, wzr, [x29, 148]
	str	wzr, [x29, 156]
.L1291:
	ldrh	w0, [x10]
	cmp	w0, w24
	bhi	.L1300
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w2, 128
	mov	w1, 255
	adrp	x24, .LANCHOR14
	add	x0, x0, 264
	strh	wzr, [x0, -142]
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w3, [x24, #:lo12:.LANCHOR14]
	ldr	x2, [x23, #:lo12:.LANCHOR7]
	ldrh	w5, [x0, 586]
	mov	x1, x5
	lsl	x0, x5, 2
	add	x26, x2, x0
	tbz	x3, 10, .L1301
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
.L1301:
	ldrb	w0, [x26, 2]
	tbz	x0, 3, .L1302
	ldrb	w0, [x26, 2]
	and	w1, w0, 192
	cmp	w1, 64
	bne	.L1303
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w1, 0
	mov	w2, 1
	ldrh	w0, [x0, 586]
	bl	gc_add_sblk
	adrp	x0, .LANCHOR63+318
	mov	w1, 1
	strh	w1, [x0, #:lo12:.LANCHOR63+318]
.L1302:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w3, [x24, #:lo12:.LANCHOR14]
	ldr	x2, [x23, #:lo12:.LANCHOR7]
	ldrh	w5, [x0, 584]
	mov	x1, x5
	lsl	x0, x5, 2
	add	x26, x2, x0
	tbz	x3, 10, .L1304
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
.L1304:
	ldrb	w0, [x26, 2]
	tbz	x0, 3, .L1305
	ldrb	w0, [x26, 2]
	and	w1, w0, 192
	cmp	w1, 64
	bne	.L1306
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w1, 0
	mov	w2, 1
	ldrh	w0, [x0, 584]
	bl	gc_add_sblk
	adrp	x0, .LANCHOR63+318
	mov	w1, 1
	strh	w1, [x0, #:lo12:.LANCHOR63+318]
.L1305:
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1307
	ldr	w6, [x29, 128]
	adrp	x2, .LANCHOR9
	ldr	x1, [x23, #:lo12:.LANCHOR7]
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
.L1307:
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1308
	ldr	w6, [x29, 136]
	adrp	x2, .LANCHOR9
	ldr	x1, [x23, #:lo12:.LANCHOR7]
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
.L1308:
	ldr	x0, [x25, #:lo12:.LANCHOR102]
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
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1309
	adrp	x0, .LC84
	and	w4, w4, 65535
	and	w3, w3, 65535
	mov	w2, w28
	mov	w1, w27
	add	x0, x0, :lo12:.LC84
	bl	printf
.L1309:
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1310
	adrp	x0, .LANCHOR144
	ldr	w3, [x29, 156]
	mov	w4, w22
	mov	w2, w21
	ldrh	w6, [x0, #:lo12:.LANCHOR144]
	adrp	x0, .LANCHOR145
	mov	w1, w20
	ldrh	w5, [x0, #:lo12:.LANCHOR145]
	adrp	x0, .LC85
	add	x0, x0, :lo12:.LC85
	bl	printf
.L1310:
	sub	w0, w22, w21
	str	w0, [x29, 148]
	adrp	x0, .LANCHOR144
	ldr	w1, [x29, 148]
	ldrh	w0, [x0, #:lo12:.LANCHOR144]
	cmp	w1, w0
	bgt	.L1311
	adrp	x1, .LANCHOR145
	ldr	w0, [x29, 156]
	ldrh	w1, [x1, #:lo12:.LANCHOR145]
	sub	w0, w0, w20
	cmp	w0, w1
	ble	.L1339
.L1311:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	adrp	x28, .LANCHOR63
	add	x28, x28, :lo12:.LANCHOR63
	mov	w27, 0
	mov	w22, 0
	ldrh	w26, [x0, 580]
	ldr	x0, [x25, #:lo12:.LANCHOR102]
	ldrh	w0, [x0, 134]
	str	w0, [x29, 152]
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	str	x0, [x29, 136]
	adrp	x0, .LANCHOR145
	add	x0, x0, :lo12:.LANCHOR145
	str	x0, [x29, 128]
.L1313:
	ldr	x0, [x29, 136]
	ldr	w1, [x29, 152]
	ldrh	w0, [x0]
	cmp	w1, w0
	bcc	.L1323
.L1322:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	str	w26, [x0, 580]
.L1312:
	cbz	w21, .L1325
	ldr	x2, [x25, #:lo12:.LANCHOR102]
	adrp	x0, .LANCHOR6
	ldrh	w5, [x0, #:lo12:.LANCHOR6]
	ldr	x0, [x23, #:lo12:.LANCHOR7]
	ldrh	w1, [x2, 134]
	add	x0, x0, x1, uxth 2
.L1326:
	cmp	w1, w5
	bcc	.L1328
	ldrh	w0, [x2, 72]
	add	w0, w21, w0
	strh	w0, [x2, 72]
	ldrh	w0, [x2, 98]
	cmp	w21, w0
	bcs	.L1325
	sub	w21, w0, w21
	strh	w21, [x2, 98]
.L1325:
	cbz	w20, .L1331
	ldr	x2, [x25, #:lo12:.LANCHOR102]
	adrp	x0, .LANCHOR6
	ldrh	w6, [x0, #:lo12:.LANCHOR6]
	ldr	x0, [x23, #:lo12:.LANCHOR7]
	ldrh	w1, [x2, 134]
	add	x0, x0, x1, uxth 2
.L1332:
	cmp	w1, w6
	bcc	.L1334
	ldrh	w0, [x2, 74]
	add	w0, w20, w0
	strh	w0, [x2, 74]
	ldrh	w0, [x2, 96]
	cmp	w20, w0
	bcs	.L1331
	sub	w20, w0, w20
	strh	w20, [x2, 96]
.L1331:
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L1290
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x1]
	adrp	x1, .LANCHOR85
	ldrh	w1, [x1, #:lo12:.LANCHOR85]
	cmp	w2, w1
	bhi	.L1290
	add	w22, w22, 1
	mov	w2, 1
	mov	w1, 0
	bl	gc_add_sblk
.L1290:
	add	w0, w22, w27
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L1300:
	uxtw	x7, w24
	ldr	x6, [x23, #:lo12:.LANCHOR7]
	lsl	x2, x7, 2
	add	x11, x6, x2
	ldrb	w0, [x11, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L1292
	ubfx	x4, x0, 3, 2
	tbz	x4, 0, .L1293
	ldr	w0, [x6, x2]
	ldrh	w1, [x6, x2]
	ubfx	x0, x0, 11, 8
	and	w1, w1, 2047
.L1294:
	ldr	w3, [x29, 148]
	add	w27, w27, 1
	and	w27, w27, 65535
	cmp	w20, w1
	add	w3, w3, w1
	str	w3, [x29, 148]
	bls	.L1337
	ldr	x3, [x19, #:lo12:.LANCHOR10]
	mov	w20, w1
	strh	w24, [x3, 586]
.L1337:
	ldr	w3, [x29, 156]
	cmp	w3, w1
	bcs	.L1297
	str	w24, [x29, 128]
	str	w1, [x29, 156]
.L1297:
	mov	w3, 65535
	cmp	w0, w3
	bne	.L1296
.L1298:
	cmp	w0, 9
	ccmp	w1, 9, 0, hi
	bhi	.L1292
	ldr	w0, [x8]
	tbz	x0, 8, .L1292
	adrp	x0, .LANCHOR9
	ldr	w3, [x6, x2]
	ldrh	w2, [x6, x2]
	mov	w1, w24
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
.L1292:
	add	w24, w24, 1
	and	w24, w24, 65535
	b	.L1291
.L1293:
	tst	w0, 24
	bne	.L1295
	ldrh	w1, [x6, x2]
	mov	w0, 65535
	and	w1, w1, 2047
	b	.L1294
.L1295:
	ldr	w0, [x6, x2]
	mov	w1, 65535
	ubfx	x0, x0, 11, 8
.L1296:
	ldr	w3, [x29, 152]
	add	w28, w28, 1
	and	w28, w28, 65535
	cmp	w21, w0
	add	w3, w3, w0
	str	w3, [x29, 152]
	bls	.L1299
	ldr	x3, [x19, #:lo12:.LANCHOR10]
	mov	w21, w0
	strh	w24, [x3, 584]
.L1299:
	cmp	w22, w0
	bcs	.L1298
	mov	w22, w0
	str	w24, [x29, 136]
	b	.L1298
.L1303:
	tst	w0, 224
	bne	.L1302
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	mov	w0, 65535
	ldrh	w2, [x1, 590]
	cmp	w2, w0
	bne	.L1302
	ldrh	w0, [x1, 586]
	ldrh	w1, [x1, 588]
	cmp	w1, w0
	beq	.L1302
	bl	zftl_remove_free_node
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldrh	w1, [x0, 586]
	strh	w1, [x0, 590]
	mov	w1, -1
	strh	w1, [x0, 586]
	b	.L1302
.L1306:
	tst	w0, 224
	bne	.L1305
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	mov	w0, 65535
	ldrh	w2, [x1, 588]
	cmp	w2, w0
	bne	.L1305
	ldrh	w0, [x1, 584]
	ldrh	w1, [x1, 590]
	cmp	w1, w0
	beq	.L1305
	bl	zftl_remove_free_node
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldrh	w1, [x0, 584]
	strh	w1, [x0, 588]
	mov	w1, -1
	strh	w1, [x0, 584]
	b	.L1305
.L1323:
	add	w7, w26, 1
	ldr	x4, [x23, #:lo12:.LANCHOR7]
	and	w26, w7, 65535
	cmp	w0, w26
	csel	w26, w26, wzr, hi
	uxtw	x8, w26
	lsl	x3, x8, 2
	add	x0, x4, x3
	ldrb	w0, [x0, 2]
	tst	w0, 192
	beq	.L1315
	and	w2, w0, 224
	cmp	w2, 224
	beq	.L1315
	ubfx	x0, x0, 3, 2
	and	w1, w0, 1
	tbz	x0, 0, .L1316
	cmp	w2, 160
.L1403:
	bne	.L1318
	adrp	x0, .LANCHOR144
	ldr	w2, [x29, 148]
	ldrh	w0, [x0, #:lo12:.LANCHOR144]
	cmp	w2, w0
	ble	.L1319
	ldr	w0, [x4, x3]
	ubfx	x0, x0, 11, 8
	cmp	w0, w21
	bls	.L1320
	cbz	w1, .L1319
	ldrh	w0, [x4, x3]
	and	w0, w0, 2047
	cmp	w0, w20
	bgt	.L1319
.L1320:
	stp	x4, x8, [x29, 104]
	mov	w2, 1
	str	x3, [x29, 120]
	mov	w1, 0
	mov	w0, w26
	bl	gc_add_sblk
	mov	w0, 1
	strh	w0, [x28, 318]
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	add	w22, w22, 1
	ldp	x4, x8, [x29, 104]
	ldr	x3, [x29, 120]
	tbz	x0, 10, .L1319
	adrp	x0, .LANCHOR9
	ldr	w6, [x4, x3]
	ldrh	w5, [x4, x3]
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldr	x0, [x23, #:lo12:.LANCHOR7]
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
.L1404:
	bl	printf
.L1319:
	cmp	w22, 4
	ccmp	w27, 4, 2, ls
	bhi	.L1322
.L1315:
	ldr	w0, [x29, 152]
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w0, [x29, 152]
	b	.L1313
.L1316:
	cmp	w0, 2
	b	.L1403
.L1318:
	ldr	x2, [x29, 128]
	ldr	w0, [x29, 156]
	sub	w0, w0, w20
	ldrh	w2, [x2]
	cmp	w0, w2
	ble	.L1319
	ldrh	w0, [x4, x3]
	add	w2, w20, 8
	and	w0, w0, 2047
	cmp	w0, w2
	ble	.L1321
	cbz	w1, .L1319
	ldr	w0, [x4, x3]
	add	w1, w21, 4
	ubfx	x0, x0, 11, 8
	cmp	w0, w1
	bgt	.L1319
.L1321:
	stp	x4, x8, [x29, 104]
	mov	w2, 1
	str	x3, [x29, 120]
	mov	w1, 0
	mov	w0, w26
	bl	gc_add_sblk
	mov	w0, 1
	strh	w0, [x28, 318]
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	add	w27, w27, 1
	ldp	x4, x8, [x29, 104]
	ldr	x3, [x29, 120]
	tbz	x0, 10, .L1319
	adrp	x0, .LANCHOR9
	ldr	w6, [x4, x3]
	ldrh	w5, [x4, x3]
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldr	x0, [x23, #:lo12:.LANCHOR7]
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
	b	.L1404
.L1339:
	mov	w27, 0
	mov	w22, 0
	b	.L1312
.L1328:
	ldr	w3, [x0]
	ubfx	x4, x3, 11, 8
	cmp	w21, w4
	bhi	.L1327
	ldrb	w6, [x0, 2]
	tst	w6, 24
	beq	.L1327
	sub	w4, w4, w21
	bfi	w3, w4, 11, 8
	str	w3, [x0]
.L1327:
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 65535
	b	.L1326
.L1334:
	ldrh	w3, [x0]
	and	w4, w3, 2047
	cmp	w4, w20
	blt	.L1333
	ldrb	w5, [x0, 2]
	and	w5, w5, 24
	cmp	w5, 16
	beq	.L1333
	sub	w4, w4, w20
	bfi	w3, w4, 0, 11
	strh	w3, [x0]
.L1333:
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 65535
	b	.L1332
.L1338:
	mov	w27, 0
	mov	w22, 0
	b	.L1290
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
	adrp	x20, .LANCHOR92
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR88
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR99
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR102
	mul	w2, w2, w0
	ldr	x0, [x28, #:lo12:.LANCHOR4]
	adrp	x24, .LANCHOR95
	adrp	x23, .LANCHOR97
	adrp	x21, .LANCHOR90
	bl	ftl_memset
	str	x28, [x29, 168]
	adrp	x0, .LANCHOR101
	adrp	x2, .LANCHOR78
	adrp	x3, .LANCHOR77
	mov	w1, 16
	strh	w1, [x0, #:lo12:.LANCHOR101]
	adrp	x10, .LANCHOR96
	ldrb	w0, [x2, #:lo12:.LANCHOR78]
	adrp	x8, .LANCHOR98
	ldrh	w1, [x3, #:lo12:.LANCHOR77]
	adrp	x7, .LANCHOR100
	adrp	x6, .LANCHOR81
	adrp	x5, .LANCHOR12
	adrp	x4, .LANCHOR80
	str	xzr, [x10, #:lo12:.LANCHOR96]
	str	xzr, [x8, #:lo12:.LANCHOR98]
	adrp	x28, .LANCHOR7
	mul	w1, w0, w1
	mov	w0, 32768
	str	xzr, [x7, #:lo12:.LANCHOR100]
	str	xzr, [x6, #:lo12:.LANCHOR81]
	str	xzr, [x5, #:lo12:.LANCHOR12]
	sdiv	w0, w0, w1
	str	xzr, [x4, #:lo12:.LANCHOR80]
	strh	wzr, [x24, #:lo12:.LANCHOR95]
	strh	wzr, [x23, #:lo12:.LANCHOR97]
	strh	wzr, [x22, #:lo12:.LANCHOR99]
	sxth	w0, w0
	str	w0, [x29, 188]
	ldr	x0, [x25, #:lo12:.LANCHOR102]
	strh	wzr, [x21, #:lo12:.LANCHOR90]
	strh	wzr, [x20, #:lo12:.LANCHOR92]
	strh	wzr, [x19, #:lo12:.LANCHOR88]
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
.L1406:
	ldr	x0, [x29, 176]
	ldrh	w0, [x0]
	cmp	w26, w0
	blt	.L1422
	ldr	x0, [x25, #:lo12:.LANCHOR102]
	ldrh	w1, [x24, #:lo12:.LANCHOR95]
	ldp	x25, x26, [sp, 64]
	strh	w1, [x0, 114]
	ldrh	w1, [x23, #:lo12:.LANCHOR97]
	strh	w1, [x0, 118]
	ldrh	w1, [x22, #:lo12:.LANCHOR99]
	strh	w1, [x0, 116]
	ldrh	w1, [x21, #:lo12:.LANCHOR90]
	strh	w1, [x0, 122]
	ldrh	w1, [x20, #:lo12:.LANCHOR92]
	strh	w1, [x0, 120]
	ldrh	w1, [x19, #:lo12:.LANCHOR88]
	strh	w1, [x0, 124]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L1422:
	ldr	x4, [x28, #:lo12:.LANCHOR7]
	sxtw	x2, w26
	add	x4, x4, x2, lsl 2
	ldrb	w6, [x4, 3]
	cbz	w6, .L1423
	ldr	x0, [x29, 112]
	mov	w1, 0
	ldr	x7, [x25, #:lo12:.LANCHOR102]
	ldrb	w8, [x0, #:lo12:.LANCHOR78]
	ldr	x0, [x29, 104]
	ldrh	w10, [x0, #:lo12:.LANCHOR77]
	mov	w0, 0
.L1408:
	cmp	w1, w8
	blt	.L1411
	cbz	w0, .L1412
	mov	w1, 32768
	sdiv	w0, w1, w0
	add	w0, w0, 1
	sxth	w0, w0
.L1407:
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
	beq	.L1413
	adrp	x5, .LANCHOR10
	ldr	x5, [x5, #:lo12:.LANCHOR10]
	ldrh	w6, [x5, 16]
	cmp	w26, w6
	beq	.L1413
	ldrh	w6, [x5, 48]
	cmp	w26, w6
	beq	.L1413
	ldrh	w5, [x5, 80]
	cmp	w26, w5
	beq	.L1413
	cmp	w0, 64
	bne	.L1414
	ldr	x0, [x29, 128]
	add	x2, x21, :lo12:.LANCHOR90
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR12
.L1426:
	bl	_insert_data_list
.L1413:
	add	w3, w26, 1
	sxth	w26, w3
	b	.L1406
.L1411:
	asr	w5, w6, w1
	tbnz	x5, 0, .L1409
	add	w0, w10, w0
	sxth	w0, w0
.L1410:
	add	w1, w1, 1
	b	.L1408
.L1409:
	ldrh	w5, [x7, 146]
	add	w5, w5, 1
	strh	w5, [x7, 146]
	b	.L1410
.L1412:
	ldrb	w1, [x4, 2]
	mov	w5, -1
	orr	w1, w1, -32
	strb	w1, [x4, 2]
	adrp	x1, .LANCHOR9
	ldr	x1, [x1, #:lo12:.LANCHOR9]
	strh	w5, [x1, x2, lsl 1]
	b	.L1407
.L1423:
	ldr	w0, [x29, 188]
	b	.L1407
.L1414:
	cmp	w0, 96
	bne	.L1415
	ldr	x0, [x29, 136]
	add	x2, x19, :lo12:.LANCHOR88
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR81
	b	.L1426
.L1415:
	cmp	w0, 160
	bne	.L1416
	ldr	x0, [x29, 120]
	add	x2, x20, :lo12:.LANCHOR92
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR80
	b	.L1426
.L1416:
	cbnz	w0, .L1413
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w2, [x0, x2, lsl 1]
	cbz	w2, .L1417
	str	x4, [x29, 96]
	mov	w1, w26
	mov	x0, x27
	bl	printf
	ldr	x4, [x29, 96]
	ldrb	w0, [x4, 2]
	tbz	x0, 4, .L1418
	mov	w1, 5
.L1425:
	bfi	w0, w1, 5, 3
	strb	w0, [x4, 2]
	mov	w2, 0
	mov	w1, 1
	mov	w0, w26
	bl	gc_add_sblk
	b	.L1413
.L1418:
	mov	w1, 2
	b	.L1425
.L1417:
	ands	w1, w1, 24
	bne	.L1420
	ldr	x0, [x29, 160]
	add	x2, x24, :lo12:.LANCHOR95
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR96
.L1427:
	bl	_insert_free_list
	b	.L1413
.L1420:
	cmp	w1, 16
	bne	.L1421
	ldr	x0, [x29, 152]
	add	x2, x23, :lo12:.LANCHOR97
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR98
	b	.L1427
.L1421:
	ldr	x0, [x29, 144]
	add	x2, x22, :lo12:.LANCHOR99
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR100
	b	.L1427
	.size	zftl_sblk_list_init, .-zftl_sblk_list_init
	.section	.text.ftl_open_sblk_init,"ax",@progbits
	.align	2
	.global	ftl_open_sblk_init
	.type	ftl_open_sblk_init, %function
ftl_open_sblk_init:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR78
	stp	x21, x22, [sp, 32]
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	adrp	x21, .LC76
	adrp	x23, .LANCHOR85
	mov	w22, w1
	add	x23, x23, :lo12:.LANCHOR85
	add	x20, x20, :lo12:.LANCHOR78
	add	x21, x21, :lo12:.LC76
	stp	x25, x26, [sp, 64]
.L1429:
.L1432:
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
	beq	.L1433
	ldrb	w0, [x20]
	mul	w0, w1, w0
	and	w0, w0, 65535
.L1430:
	ldrb	w2, [x20]
	adrp	x26, .LANCHOR9
	strh	w0, [x19, 12]
	ubfiz	x25, x24, 1, 16
	mul	w2, w2, w1
	adrp	x1, .LANCHOR109
	ldr	x3, [x1, #:lo12:.LANCHOR109]
	mov	w1, 255
	lsl	w2, w2, 2
	add	x0, x3, x0, uxth 2
	bl	ftl_memset
	ldr	x0, [x26, #:lo12:.LANCHOR9]
	ldrh	w1, [x19, 6]
	strh	w1, [x0, x25]
	ldrb	w0, [x19, 9]
	cbnz	w0, .L1428
	mov	w1, w24
	mov	x0, x21
	bl	printf
	ldr	x0, [x26, #:lo12:.LANCHOR9]
	mov	w1, -1
	strh	w1, [x0, x25]
	mov	w0, 7
	strb	w0, [x19, 4]
	b	.L1432
.L1433:
	mov	w0, 0
	b	.L1430
.L1428:
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
	stp	x29, x30, [sp, -368]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR146
	stp	x21, x22, [sp, 32]
	ldrh	w0, [x20, #:lo12:.LANCHOR146]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w0, 128
	stp	x27, x28, [sp, 80]
	bls	.L1436
	adrp	x1, .LANCHOR147
	adrp	x0, .LC0
	mov	w2, 78
	add	x1, x1, :lo12:.LANCHOR147
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1436:
	add	x28, x29, 112
	mov	w2, 256
	mov	w1, 0
	mov	x0, x28
	bl	ftl_memset
	adrp	x23, .LANCHOR67
	adrp	x5, .LANCHOR102
	adrp	x0, .LANCHOR66
	mov	w2, 21
	ldrb	w12, [x23, #:lo12:.LANCHOR67]
	ldr	x7, [x5, #:lo12:.LANCHOR102]
	ldrh	w11, [x0, #:lo12:.LANCHOR66]
	ldrh	w13, [x20, #:lo12:.LANCHOR146]
	add	x4, x7, 704
	sub	w0, w2, w11
	mov	w2, 1
	ldrh	w1, [x7, 698]
	lsl	w2, w2, w0
	sub	w2, w2, #1
	add	x1, x1, 176
	add	x1, x7, x1, lsl 2
.L1437:
	cmp	x4, x1
	bne	.L1441
	adrp	x24, .LANCHOR78
	adrp	x25, .LANCHOR85
	adrp	x26, .LANCHOR14
	adrp	x27, .LC89
	ldrb	w22, [x24, #:lo12:.LANCHOR78]
	add	x20, x20, :lo12:.LANCHOR146
	ldrh	w0, [x25, #:lo12:.LANCHOR85]
	add	x26, x26, :lo12:.LANCHOR14
	add	x27, x27, :lo12:.LC89
	mov	w19, 0
	str	wzr, [x29, 108]
	mul	w22, w22, w0
	and	w22, w22, 65535
.L1442:
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L1448
	ldr	w0, [x29, 108]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 368
	ret
.L1441:
	ldr	w0, [x4]
	add	x8, x7, 416
	mov	x3, 0
	lsr	w0, w0, w11
	and	w0, w0, w2
	udiv	w0, w0, w12
	and	w0, w0, 65535
.L1438:
	cmp	w13, w3, uxth
	bhi	.L1440
	add	x4, x4, 4
	b	.L1437
.L1440:
	ldrh	w10, [x8]
	cmp	w10, w0
	bne	.L1439
	ldrh	w10, [x28, x3, lsl 1]
	add	w10, w10, 1
	strh	w10, [x28, x3, lsl 1]
.L1439:
	add	x3, x3, 1
	add	x8, x8, 2
	b	.L1438
.L1448:
	ldr	x1, [x5, #:lo12:.LANCHOR102]
	sxtw	x21, w19
	add	x0, x21, 208
	ldrb	w2, [x23, #:lo12:.LANCHOR67]
	ldrh	w3, [x1, x0, lsl 1]
	ldrh	w0, [x1, 692]
	sdiv	w0, w0, w2
	cmp	w0, w3
	bne	.L1443
	ldrb	w0, [x24, #:lo12:.LANCHOR78]
	ldrh	w2, [x25, #:lo12:.LANCHOR85]
	mul	w0, w0, w2
	strh	w0, [x28, x21, lsl 1]
.L1443:
	ldrh	w0, [x28, x21, lsl 1]
	cmp	w22, w0
	bls	.L1444
	cbnz	w0, .L1449
.L1446:
	mov	w0, 65535
	cmp	w3, w0
	beq	.L1445
	ldr	w0, [x26]
	tbz	x0, 12, .L1447
	ldrh	w4, [x1, 688]
	mov	w2, 0
	str	x5, [x29, 96]
	mov	w1, w19
	mov	x0, x27
	bl	printf
	ldr	x5, [x29, 96]
.L1447:
	ldr	x0, [x5, #:lo12:.LANCHOR102]
	add	x21, x21, 208
	str	x5, [x29, 96]
	ldrh	w0, [x0, x21, lsl 1]
	bl	ftl_free_sblk
	ldr	x5, [x29, 96]
	mov	w1, -1
	ldr	x0, [x5, #:lo12:.LANCHOR102]
	strh	w1, [x0, x21, lsl 1]
	ldrh	w1, [x0, 688]
	sub	w1, w1, #1
	strh	w1, [x0, 688]
	b	.L1445
.L1444:
	cbz	w0, .L1446
.L1445:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1442
.L1449:
	mov	w22, w0
	str	w19, [x29, 108]
	b	.L1445
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
	tbz	x0, 12, .L1456
	adrp	x2, .LANCHOR148
	adrp	x0, .LC90
	add	x2, x2, :lo12:.LANCHOR148
	mov	w1, 105
	add	x0, x0, :lo12:.LC90
	bl	printf
.L1456:
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
	adrp	x1, .LANCHOR31
	ldp	x29, x30, [sp], 32
	add	x1, x1, :lo12:.LANCHOR31
	add	x0, x0, 48
	b	ftl_memcpy
	.size	flash_info_data_init, .-flash_info_data_init
	.section	.text.ftl_memcpy32,"ax",@progbits
	.align	2
	.global	ftl_memcpy32
	.type	ftl_memcpy32, %function
ftl_memcpy32:
	mov	x3, 0
.L1462:
	cmp	w2, w3
	bhi	.L1463
	ret
.L1463:
	ldr	w4, [x1, x3, lsl 2]
	str	w4, [x0, x3, lsl 2]
	add	x3, x3, 1
	b	.L1462
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
	tbz	x0, 12, .L1468
	adrp	x1, .LANCHOR149
	adrp	x0, .LC91
	mov	x2, x19
	add	x1, x1, :lo12:.LANCHOR149
	add	x0, x0, :lo12:.LC91
	bl	printf
.L1468:
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
	bne	.L1469
	mov	w0, 8
	strb	w0, [x20, #:lo12:.LANCHOR28]
.L1469:
	ldr	w1, [x19, 128]
	mov	w0, 12336
	movk	w0, 0x5639, lsl 16
	cmp	w1, w0
	bne	.L1470
	mov	w0, 9
	strb	w0, [x20, #:lo12:.LANCHOR28]
.L1470:
	ldrb	w0, [x20, #:lo12:.LANCHOR28]
	cmp	w0, 9
	adrp	x0, .LANCHOR45
	bne	.L1471
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR45]
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
	tbz	x0, 12, .L1473
	ldr	w1, [x19]
	ldr	w2, [x19, 8]
	ldr	w3, [x19, 80]
	ldr	w4, [x19, 84]
	ldr	w5, [x19, 88]
.L1486:
	adrp	x0, .LC92
	add	x0, x0, :lo12:.LC92
	bl	printf
.L1473:
	adrp	x0, .LANCHOR46
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR46]
	adrp	x0, .LANCHOR48
	strh	wzr, [x0, #:lo12:.LANCHOR48]
	adrp	x0, .LANCHOR44
	strb	wzr, [x0, #:lo12:.LANCHOR44]
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1467
	ldrb	w1, [x20, #:lo12:.LANCHOR28]
	adrp	x0, .LC93
	add	x0, x0, :lo12:.LC93
	bl	printf
.L1467:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1471:
	strb	wzr, [x0, #:lo12:.LANCHOR45]
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
	adrp	x1, .LANCHOR47
	str	x0, [x1, #:lo12:.LANCHOR47]
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1473
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	ldr	w1, [x0]
	ldr	w2, [x0, 344]
	ldr	w3, [x0, 304]
	ldr	w4, [x0, 308]
	ldr	w5, [x0, 312]
	b	.L1486
	.size	nandc_init, .-nandc_init
	.section	.text.buf_init,"ax",@progbits
	.align	2
	.global	buf_init
	.type	buf_init, %function
buf_init:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR50
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	x19, x0, :lo12:.LANCHOR50
	stp	x21, x22, [sp, 32]
	mov	x20, x0
	adrp	x22, .LANCHOR123
	add	x22, x22, :lo12:.LANCHOR123
	mov	w21, 0
.L1488:
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
	ldrb	w0, [x22]
	lsl	w0, w0, 1
	bl	ftl_malloc
	str	x0, [x19, -40]
	cmp	w21, 32
	bne	.L1488
	add	x0, x20, :lo12:.LANCHOR50
	mov	w1, -1
	strb	w1, [x0, 1984]
	adrp	x0, .LANCHOR51
	strb	wzr, [x0, #:lo12:.LANCHOR51]
	adrp	x0, .LANCHOR52
	ldp	x19, x20, [sp, 16]
	strb	w21, [x0, #:lo12:.LANCHOR52]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
	.size	buf_init, .-buf_init
	.section	.text.gc_init,"ax",@progbits
	.align	2
	.global	gc_init
	.type	gc_init, %function
gc_init:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR76
	mov	w2, 344
	mov	w1, 0
	add	x29, sp, 0
	strb	wzr, [x0, #:lo12:.LANCHOR76]
	adrp	x0, .LANCHOR150
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR63
	strb	wzr, [x0, #:lo12:.LANCHOR150]
	adrp	x0, .LANCHOR151
	add	x19, x20, :lo12:.LANCHOR63
	str	wzr, [x0, #:lo12:.LANCHOR151]
	adrp	x0, .LANCHOR87
	strh	wzr, [x0, #:lo12:.LANCHOR87]
	mov	x0, x19
	bl	ftl_memset
	str	xzr, [x19, 8]
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR63]
	adrp	x0, .LANCHOR85
	adrp	x4, .LANCHOR94
	adrp	x20, .LANCHOR77
	ldrh	w1, [x0, #:lo12:.LANCHOR85]
	lsr	w2, w1, 1
	lsr	w0, w1, 2
	strh	w2, [x19, 38]
	adrp	x2, .LANCHOR86
	strh	w0, [x19, 36]
	adrp	x19, .LANCHOR78
	strh	wzr, [x2, #:lo12:.LANCHOR86]
	adrp	x2, .LANCHOR82
	ldrb	w3, [x19, #:lo12:.LANCHOR78]
	strh	wzr, [x2, #:lo12:.LANCHOR82]
	adrp	x2, .LANCHOR83
	strh	wzr, [x2, #:lo12:.LANCHOR83]
	mul	w2, w1, w3
	and	w2, w2, 65535
	sub	w5, w2, #32
	strh	w5, [x4, #:lo12:.LANCHOR94]
	adrp	x4, .LANCHOR91
	strh	w2, [x4, #:lo12:.LANCHOR91]
	adrp	x2, .LANCHOR84
	strh	w1, [x2, #:lo12:.LANCHOR84]
	adrp	x1, .LANCHOR62
	strh	w0, [x1, #:lo12:.LANCHOR62]
	ldrh	w0, [x20, #:lo12:.LANCHOR77]
	mul	w0, w0, w3
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR152
	str	x0, [x1, #:lo12:.LANCHOR152]
	ldrb	w1, [x19, #:lo12:.LANCHOR78]
	ldrh	w0, [x20, #:lo12:.LANCHOR77]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR153
	str	x0, [x1, #:lo12:.LANCHOR153]
	ldrh	w1, [x20, #:lo12:.LANCHOR77]
	ldrb	w0, [x19, #:lo12:.LANCHOR78]
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR74
	str	x0, [x1, #:lo12:.LANCHOR74]
	ldrb	w1, [x19, #:lo12:.LANCHOR78]
	ldrh	w0, [x20, #:lo12:.LANCHOR77]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR68
	str	x0, [x1, #:lo12:.LANCHOR68]
	ldrb	w1, [x19, #:lo12:.LANCHOR78]
	ldrh	w0, [x20, #:lo12:.LANCHOR77]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR154
	ldp	x19, x20, [sp, 16]
	str	x0, [x1, #:lo12:.LANCHOR154]
	adrp	x0, .LANCHOR89
	adrp	x1, .LANCHOR79
	ldp	x29, x30, [sp], 32
	ldrh	w0, [x0, #:lo12:.LANCHOR89]
	lsr	w0, w0, 2
	strh	w0, [x1, #:lo12:.LANCHOR79]
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
.L1495:
	cmp	w1, w3
	bhi	.L1496
	ret
.L1496:
	lsr	w2, w0, 2
	ldrb	w5, [x4, x3]
	add	w2, w2, w0, lsl 5
	add	x3, x3, 1
	add	w2, w2, w5
	eor	w0, w0, w2
	b	.L1495
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
	adrp	x0, .LANCHOR59
	ldr	w0, [x0, #:lo12:.LANCHOR59]
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
	adrp	x21, .LC95
	stp	x23, x24, [sp, 48]
	mov	x22, x1
	stp	x25, x26, [sp, 64]
	adrp	x23, .LC94
	mov	x26, x0
	mov	w24, w2
	uxtw	x25, w3
	add	x23, x23, :lo12:.LC94
	add	x21, x21, :lo12:.LC95
	stp	x19, x20, [sp, 16]
	str	x27, [sp, 80]
	mov	x19, 0
	mov	w20, 0
	adrp	x27, .LC96
.L1503:
	cmp	x25, x19
	bne	.L1509
	ldp	x19, x20, [sp, 16]
	adrp	x1, .LC96
	ldp	x21, x22, [sp, 32]
	add	x1, x1, :lo12:.LC96
	ldp	x23, x24, [sp, 48]
	adrp	x0, .LC97
	ldp	x25, x26, [sp, 64]
	add	x0, x0, :lo12:.LC97
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L1509:
	cbnz	w20, .L1504
	mov	w2, w19
	mov	x1, x26
	mov	x0, x23
	bl	printf
.L1504:
	cmp	w24, 4
	bne	.L1505
	ldr	w1, [x22, x19, lsl 2]
.L1511:
	mov	x0, x21
	add	w20, w20, 1
	bl	printf
	cmp	w20, 15
	bls	.L1508
	mov	w20, 0
	add	x1, x27, :lo12:.LC96
	adrp	x0, .LC97
	add	x0, x0, :lo12:.LC97
	bl	printf
.L1508:
	add	x19, x19, 1
	b	.L1503
.L1505:
	cmp	w24, 2
	bne	.L1507
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L1511
.L1507:
	ldrb	w1, [x22, x19]
	b	.L1511
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
	bne	.L1513
	mov	w0, -89
	strb	w0, [x12, 16]
	adrp	x0, .LANCHOR155+17
	mov	w1, -9
	strb	w1, [x0, #:lo12:.LANCHOR155+17]
.L1577:
	mov	w23, 7
	b	.L1620
.L1513:
	cmp	w8, 3
	bne	.L1515
	mov	x10, 0
.L1516:
	sub	w0, w10, #80
	strb	w0, [x6, x10]
	add	x10, x10, 1
	cmp	x10, 8
	bne	.L1516
	mov	w23, w10
.L1514:
	sub	w0, w8, #1
	cmp	w0, 1
	bhi	.L1522
	adrp	x7, .LANCHOR18
	adrp	x8, .LANCHOR30
	add	x7, x7, :lo12:.LANCHOR18
	add	x8, x8, :lo12:.LANCHOR30
	mov	w5, 0
	mov	w11, 55
.L1523:
	ldrb	w0, [x7]
	cmp	w0, w5
	bhi	.L1529
.L1530:
	strb	w10, [x12, 1]
	strb	w23, [x12, 2]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1515:
	cmp	w8, 4
	bne	.L1517
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
	b	.L1514
.L1517:
	cmp	w8, 5
	bne	.L1518
	mov	w0, 56
	strb	w0, [x7, 128]
	mov	w0, 57
	strb	w0, [x7, 129]
	mov	w0, 58
	mov	w23, 8
	strb	w0, [x7, 130]
	mov	w0, 59
	strb	w0, [x7, 131]
.L1620:
	mov	w10, 4
	b	.L1514
.L1518:
	cmp	w8, 6
	bne	.L1519
	mov	w0, 14
	strb	w0, [x7, 128]
	mov	w0, 15
	strb	w0, [x7, 129]
	mov	w0, 16
	mov	w23, 12
	strb	w0, [x7, 130]
	mov	w0, 17
	strb	w0, [x7, 131]
	b	.L1620
.L1519:
	cmp	w8, 7
	bne	.L1520
	mov	x0, 0
.L1521:
	sub	w1, w0, #80
	strb	w1, [x6, x0]
	add	x0, x0, 1
	cmp	x0, 8
	bne	.L1521
	mov	w0, -44
	mov	w23, 12
	strb	w0, [x7, 136]
	mov	w10, 10
	mov	w0, -43
	strb	w0, [x7, 137]
	b	.L1514
.L1520:
	cmp	w8, 8
	bne	.L1577
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
	b	.L1514
.L1529:
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
.L1524:
	str	w11, [x4, 2056]
	ldrb	w0, [x6, x3]
	str	w0, [x4, 2052]
	mov	w0, 80
	bl	timer_delay_ns
	ldr	w0, [x4, 2048]
	strb	w0, [x2, x3]
	add	x3, x3, 1
	cmp	w10, w3, uxtb
	bhi	.L1524
	adrp	x3, .LANCHOR155
	add	x3, x3, :lo12:.LANCHOR155
	mov	x0, 0
.L1527:
	add	x14, x2, x0
	add	x13, x3, x0
	mov	x1, 1
.L1526:
	lsl	x4, x1, 2
	lsl	x15, x1, 3
	ldrb	w16, [x2, x0]
	add	x1, x1, 1
	cmp	x1, 7
	ldrb	w4, [x13, x4]
	add	w4, w4, w16
	strb	w4, [x14, x15]
	bne	.L1526
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L1527
	add	w5, w5, 1
	strb	wzr, [x2, 16]
	strb	wzr, [x2, 24]
	and	w5, w5, 255
	strb	wzr, [x2, 32]
	strb	wzr, [x2, 40]
	strb	wzr, [x2, 48]
	strb	wzr, [x2, 41]
	strb	wzr, [x2, 49]
	b	.L1523
.L1522:
	sub	w0, w8, #3
	cmp	w0, 5
	bhi	.L1530
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
.L1531:
	ldrb	w0, [x19]
	cmp	w0, w11
	bls	.L1530
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
	bne	.L1532
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
.L1623:
	str	w0, [x4, 2052]
	mov	w0, 48
	str	wzr, [x4, 2052]
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	cmp	w20, 1
	ccmp	w8, 8, 4, hi
	beq	.L1578
	cmp	w8, 7
	mov	w0, 32
	mov	w1, 2
	csel	w1, w1, w0, ne
.L1539:
	adrp	x6, .LANCHOR156
	mov	x2, 0
	ldr	x0, [x6, #:lo12:.LANCHOR156]
.L1540:
	ldr	w3, [x4, 2048]
	strb	w3, [x0, x2]
	add	x2, x2, 1
	cmp	w1, w2, uxtb
	bhi	.L1540
	cmp	w8, 8
	bne	.L1541
	mov	w1, 0
.L1543:
	ldrb	w2, [x0]
	cmp	w2, 50
	beq	.L1542
	ldrb	w2, [x0, 1]
	cmp	w2, 5
	beq	.L1542
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1543
.L1544:
	adrp	x0, .LC98
	mov	w1, 0
	add	x0, x0, :lo12:.LC98
	bl	printf
.L1546:
	b	.L1546
.L1532:
	mov	w0, 54
	str	w0, [x4, 2056]
	cmp	w8, 4
	bne	.L1534
	mov	w0, 64
	str	w6, [x4, 2052]
	str	w0, [x4, 2048]
	mov	w0, 204
.L1621:
	str	w0, [x4, 2052]
	mov	w0, 77
	b	.L1622
.L1534:
	cmp	w20, 1
	bhi	.L1536
	ldrb	w0, [x7, 128]
	str	w0, [x4, 2052]
	mov	w0, 82
.L1622:
	str	w0, [x4, 2048]
.L1535:
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
	bne	.L1537
	mov	w0, 31
	str	w0, [x4, 2052]
.L1538:
	mov	w0, 2
	b	.L1623
.L1536:
	cmp	w8, 7
	bne	.L1535
	mov	w0, 174
	str	w0, [x4, 2052]
	str	wzr, [x4, 2048]
	mov	w0, 176
	b	.L1621
.L1537:
	str	wzr, [x4, 2052]
	b	.L1538
.L1578:
	mov	w1, 16
	b	.L1539
.L1542:
	cmp	w1, 6
	bhi	.L1544
.L1545:
	ldr	x3, [x6, #:lo12:.LANCHOR156]
	mov	x0, 0
.L1555:
	cmp	w15, w0
	bgt	.L1556
	ldr	x1, [x6, #:lo12:.LANCHOR156]
	mov	w6, 8
	add	x2, x1, x21
.L1558:
	mov	x0, 0
.L1557:
	ldrh	w16, [x2, x0, lsl 1]
	mvn	w16, w16
	strh	w16, [x2, x0, lsl 1]
	add	x0, x0, 1
	cmp	w14, w0
	bgt	.L1557
	add	x2, x2, x22, uxtw 1
	subs	w6, w6, #1
	bne	.L1558
	mov	x6, x1
	mov	w16, 0
	mov	w26, 1
.L1559:
	mov	w0, 0
	mov	w2, 0
.L1563:
	mov	x30, x6
	lsl	w25, w26, w2
	mov	w24, 16
	mov	w17, 0
.L1561:
	ldrh	w27, [x30]
	add	x30, x30, x21
	bics	wzr, w25, w27
	cinc	w17, w17, eq
	subs	w24, w24, #1
	bne	.L1561
	cmp	w17, 8
	bls	.L1562
	orr	w0, w0, w25
	and	w0, w0, 65535
.L1562:
	add	w2, w2, 1
	cmp	w2, 16
	bne	.L1563
	strh	w0, [x6], 2
	add	w16, w16, 1
	cmp	w14, w16
	bgt	.L1559
	mov	x0, 0
	mov	w2, 0
.L1566:
	ldr	w6, [x1, x0]
	add	x0, x0, 4
	cmp	w6, 0
	cinc	w2, w2, eq
	cmp	x0, 32
	bne	.L1566
	cmp	w2, 7
	ble	.L1567
	mov	w3, 1024
	mov	w2, 1
	adrp	x0, .LC99
	add	x0, x0, :lo12:.LC99
	bl	rknand_print_hex
	adrp	x0, .LC98
	mov	w1, 0
	add	x0, x0, :lo12:.LC98
	bl	printf
.L1568:
	b	.L1568
.L1541:
	cmp	w8, 7
	bne	.L1547
	mov	w1, 0
.L1549:
	ldrb	w2, [x0]
	cmp	w2, 12
	beq	.L1548
	ldrb	w2, [x0, 1]
	cmp	w2, 10
	beq	.L1548
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1549
.L1550:
	adrp	x0, .LC98
	mov	w1, 0
	add	x0, x0, :lo12:.LC98
	bl	printf
.L1551:
	b	.L1551
.L1548:
	cmp	w1, 6
	bls	.L1545
	b	.L1550
.L1547:
	cmp	w8, 6
	bne	.L1545
	mov	x1, 0
.L1552:
	ldrb	w2, [x0, x1]
	cmp	w2, 12
	beq	.L1545
	add	x2, x0, x1
	ldrb	w2, [x2, 8]
	cmp	w2, 4
	beq	.L1545
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L1552
	adrp	x0, .LC98
	mov	w1, 0
	add	x0, x0, :lo12:.LC98
	bl	printf
.L1554:
	b	.L1554
.L1556:
	ldr	w1, [x4, 2048]
	strb	w1, [x3, x0]
	add	x0, x0, 1
	b	.L1555
.L1567:
	cmp	w8, 6
	beq	.L1580
	cmp	w8, 7
	beq	.L1581
	cmp	w8, 8
	mov	x1, 5
	mov	x0, 8
	csel	x0, x0, x1, ne
.L1569:
	mov	x1, x5
	mov	w5, 0
.L1570:
	mov	x2, 0
.L1571:
	ldrb	w6, [x3, x2]
	strb	w6, [x1, x2]
	add	x2, x2, 1
	cmp	w10, w2, uxtb
	bhi	.L1571
	add	w5, w5, 1
	add	x3, x3, x13
	add	x1, x1, x0
	cmp	w23, w5
	bgt	.L1570
	mov	w5, 255
	str	w5, [x4, 2056]
	bl	nandc_wait_flash_ready
	cmp	w20, 1
	bhi	.L1573
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
.L1624:
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	add	w11, w11, 1
	and	w11, w11, 255
	b	.L1531
.L1580:
	mov	x0, 4
	b	.L1569
.L1581:
	mov	x0, 10
	b	.L1569
.L1573:
	cmp	w8, 8
	bne	.L1575
	mov	w0, 190
	b	.L1624
.L1575:
	mov	w0, 56
	b	.L1624
	.size	hynix_get_read_retry_default, .-hynix_get_read_retry_default
	.section	.text.flash_get_read_retry_tbl,"ax",@progbits
	.align	2
	.global	flash_get_read_retry_tbl
	.type	flash_get_read_retry_tbl, %function
flash_get_read_retry_tbl:
	adrp	x0, .LANCHOR31+19
	ldrb	w0, [x0, #:lo12:.LANCHOR31+19]
	sub	w1, w0, #1
	and	w1, w1, 255
	cmp	w1, 7
	bhi	.L1625
	b	hynix_get_read_retry_default
.L1625:
	ret
	.size	flash_get_read_retry_tbl, .-flash_get_read_retry_tbl
	.section	.text.nandc_xfer_done,"ax",@progbits
	.align	2
	.global	nandc_xfer_done
	.type	nandc_xfer_done, %function
nandc_xfer_done:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR157
	adrp	x1, .LANCHOR28
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR13
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w1, 9
	strb	wzr, [x0, #:lo12:.LANCHOR157]
	bne	.L1628
	ldr	x20, [x19, #:lo12:.LANCHOR13]
	mov	x24, x0
	mov	w21, 0
	ldr	w0, [x20, 16]
	str	w0, [x29, 64]
	ldr	w0, [x20, 48]
	tbnz	x0, 1, .L1629
	adrp	x22, .LC103
	adrp	x23, .LC102
	add	x22, x22, :lo12:.LC103
	add	x23, x23, :lo12:.LC102
.L1630:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1633
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 16]
	str	w0, [x29, 64]
	bne	.L1630
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
	b	.L1630
.L1629:
	adrp	x22, .LC101
	adrp	x23, .LC102
	add	x22, x22, :lo12:.LC101
	add	x23, x23, :lo12:.LC102
.L1631:
	ldr	w1, [x20, 64]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 6
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L1633
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1632
	ldr	w0, [x29, 72]
	tbz	x0, 17, .L1632
	ldr	w1, [x29, 72]
	adrp	x0, .LC100
	add	x0, x0, :lo12:.LC100
	ubfx	x1, x1, 17, 1
.L1665:
	bl	printf
	b	.L1633
.L1632:
	ldr	w0, [x29, 64]
	add	w21, w21, 1
	ubfx	x0, x0, 22, 6
	cmp	w21, w0, lsl 12
	bne	.L1631
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
	tbz	x0, 13, .L1631
	mov	w0, 1
	strb	w0, [x24, #:lo12:.LANCHOR157]
.L1633:
	adrp	x0, .LANCHOR47+32
	ldp	x19, x20, [sp, 16]
	str	wzr, [x0, #:lo12:.LANCHOR47+32]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1628:
	ldr	x20, [x19, #:lo12:.LANCHOR13]
	mov	w21, 0
	ldr	w0, [x20, 8]
	str	w0, [x29, 64]
	ldr	w0, [x20, 16]
	tbnz	x0, 1, .L1639
	adrp	x22, .LC103
	adrp	x23, .LC102
	add	x22, x22, :lo12:.LC103
	add	x23, x23, :lo12:.LC102
.L1640:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1633
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 8]
	str	w0, [x29, 64]
	bne	.L1640
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
	b	.L1640
.L1639:
	adrp	x22, .LC101
	adrp	x23, .LC102
	add	x22, x22, :lo12:.LC101
	add	x23, x23, :lo12:.LC102
.L1641:
	ldr	w1, [x20, 28]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 5
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L1633
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1642
	ldr	w0, [x29, 72]
	tbz	x0, 17, .L1642
	adrp	x0, .LC104
	ldr	w1, [x29, 72]
	add	x0, x0, :lo12:.LC104
	b	.L1665
.L1642:
	add	w21, w21, 1
	tst	x21, 16777215
	bne	.L1641
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
	b	.L1641
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
	cbnz	w22, .L1685
	adrp	x0, .LANCHOR28
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cmp	w0, 9
	bne	.L1668
	adrp	x22, .LANCHOR13
	lsr	w19, w19, 2
	mov	w3, 1
	mov	w2, 0
	ldr	x5, [x22, #:lo12:.LANCHOR13]
	mov	w0, 0
.L1669:
	cmp	w2, w19
	bcc	.L1673
	ldr	w19, [x5]
	cmp	w3, 0
	mov	w1, 512
	csel	w0, w0, w1, eq
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1675
	mov	w1, w19
	adrp	x0, .LC105
	add	x0, x0, :lo12:.LC105
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	orr	w19, w19, 131072
	str	w19, [x0]
	mov	w0, -1
.L1675:
	tbz	x19, 13, .L1676
	adrp	x1, .LANCHOR157
	ldrb	w1, [x1, #:lo12:.LANCHOR157]
	cbz	w1, .L1676
	mov	w1, w19
	adrp	x0, .LC106
	add	x0, x0, :lo12:.LC106
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	mov	w1, 1
	str	w1, [x0, 16]
.L1704:
	mov	w0, -1
.L1667:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1673:
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
	tbnz	x1, 2, .L1687
	ldr	w1, [x29, 56]
	tbnz	x1, 18, .L1687
	ldr	w4, [x29, 56]
	ldr	w1, [x29, 56]
	ubfx	x4, x4, 3, 7
	ubfx	x1, x1, 19, 7
	cmp	w4, w1
	ldr	w1, [x29, 56]
	ble	.L1671
	ubfx	x1, x1, 3, 7
.L1672:
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1670:
	add	w2, w2, 1
	b	.L1669
.L1671:
	ubfx	x1, x1, 19, 7
	b	.L1672
.L1687:
	mov	w0, -1
	b	.L1670
.L1668:
	adrp	x0, .LANCHOR44
	lsr	w4, w19, 1
	mov	w3, 64
	mov	w1, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	mov	w2, 0
	adrp	x6, .LANCHOR47
	cmp	w0, 25
	mov	w0, 128
	csel	w3, w3, w0, cc
	mov	w0, 0
.L1678:
	add	w5, w3, w0
	cmp	w2, w4
	bcc	.L1679
	adrp	x22, .LANCHOR13
	lsr	w19, w19, 2
	mov	w3, 0
	mov	w0, 0
	ldr	x4, [x22, #:lo12:.LANCHOR13]
.L1680:
	cmp	w3, w19
	bcc	.L1684
	str	wzr, [x4, 16]
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	ldr	w19, [x4]
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1676
	mov	w1, w19
	adrp	x0, .LC107
	add	x0, x0, :lo12:.LC107
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	orr	w19, w19, 131072
	str	w19, [x0]
	b	.L1704
.L1679:
	ldr	x7, [x6, #:lo12:.LANCHOR47]
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
	b	.L1678
.L1684:
	uxtw	x1, w3
	add	x1, x1, 8
	ldr	w1, [x4, x1, lsl 2]
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	tbnz	x1, 2, .L1690
	ldr	w1, [x29, 56]
	tbnz	x1, 15, .L1690
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
	bls	.L1682
	ubfx	x2, x1, 3, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 27, 1
.L1703:
	orr	w1, w2, w1, lsl 5
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1681:
	add	w3, w3, 1
	b	.L1680
.L1682:
	ubfx	x2, x1, 16, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 29, 1
	b	.L1703
.L1690:
	mov	w0, -1
	b	.L1681
.L1676:
	cmn	w0, #1
	beq	.L1667
	ldr	w1, [x21]
	cmn	w1, #1
	bne	.L1667
	ldr	w1, [x21, 4]
	cmn	w1, #1
	bne	.L1667
	ldr	w1, [x20]
	cmn	w1, #1
	mov	w1, 512
	csel	w0, w0, w1, ne
	b	.L1667
.L1685:
	mov	w0, 0
	b	.L1667
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
	stp	x23, x24, [sp, 48]
	mov	w22, w1
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR14
	stp	x25, x26, [sp, 64]
	mov	w24, w4
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	mov	x25, x2
	mov	x26, x3
	and	w20, w1, 2097151
	ubfx	x23, x22, 24, 2
	tbz	x0, 4, .L1706
	mov	w3, w1
	adrp	x0, .LC108
	mov	w2, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC108
	bl	printf
.L1706:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	nandc_cs
	adrp	x7, .LANCHOR16
	cbnz	w23, .L1707
	mov	w0, w21
	bl	zftl_flash_enter_slc_mode
.L1708:
	ubfiz	x4, x21, 8, 8
	lsr	w0, w20, 8
	add	x4, x19, x4
	and	w22, w22, 255
	str	wzr, [x4, 2056]
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	str	w22, [x4, 2052]
	str	w0, [x4, 2052]
	lsr	w0, w20, 16
	str	w0, [x4, 2052]
	mov	w0, 48
	str	w0, [x4, 2056]
	ldr	x0, [x7, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1710
	cbz	w23, .L1710
	add	w20, w20, w20, lsl 1
	sub	w0, w20, #1
	add	w0, w0, w23
.L1719:
	bl	nandc_set_seed
	bl	nandc_wait_flash_ready
	mov	w0, 5
	str	w0, [x4, 2056]
	str	wzr, [x4, 2052]
	mov	w0, 224
	str	wzr, [x4, 2052]
	mov	w2, w24
	str	w0, [x4, 2056]
	mov	x3, x25
	mov	x4, x26
	mov	w1, 0
	mov	w0, w21
	bl	nandc_xfer
	mov	w2, w0
	bl	nandc_de_cs.constprop.29
	mov	w0, w2
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1707:
	ldr	x0, [x7, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1709
	sxtw	x0, w21
	add	x0, x0, 8
	add	x0, x19, x0, lsl 8
	str	w23, [x0, 8]
	b	.L1708
.L1709:
	mov	w0, w21
	bl	zftl_flash_exit_slc_mode
	b	.L1708
.L1710:
	mov	w0, w20
	b	.L1719
	.size	flash_read_page, .-flash_read_page
	.section	.text.micron_read_retrial,"ax",@progbits
	.align	2
	.global	micron_read_retrial
	.type	micron_read_retrial, %function
micron_read_retrial:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w24, w0, 255
	adrp	x0, .LANCHOR44
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	mov	w22, w1
	stp	x25, x26, [sp, 64]
	mov	x25, x2
	stp	x27, x28, [sp, 80]
	mov	x26, x3
	ldrb	w20, [x0, #:lo12:.LANCHOR44]
	and	x19, x24, 255
	str	w4, [x29, 116]
	bl	nandc_wait_flash_ready
	adrp	x0, .LANCHOR13
	mov	w21, 0
	add	w20, w20, w20, lsl 1
	mov	w28, -1
	ldr	x0, [x0, #:lo12:.LANCHOR13]
	asr	w20, w20, 2
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR159
	add	x0, x0, :lo12:.LANCHOR159
	str	x0, [x29, 104]
	ldr	x0, [x29, 120]
	add	x23, x0, x19, lsl 8
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	str	x0, [x29, 96]
.L1721:
	ldr	x0, [x29, 104]
	ldrb	w0, [x0]
	cmp	w21, w0
	bcc	.L1726
.L1725:
	ldr	x0, [x29, 120]
	add	x19, x0, x19, lsl 8
	mov	w0, 239
	str	w0, [x19, 2056]
	mov	w0, 137
	str	w0, [x19, 2052]
	mov	w0, 200
	bl	timer_delay_ns
	str	wzr, [x19, 2048]
	str	wzr, [x19, 2048]
	cmp	w28, w20
	str	wzr, [x19, 2048]
	str	wzr, [x19, 2048]
	bcc	.L1727
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L1727:
	cmp	w28, 256
	ccmn	w28, #1, 4, ne
	bne	.L1728
	adrp	x0, .LC110
	mov	w4, w28
	mov	w3, w21
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC110
	bl	printf
.L1728:
	bl	nandc_wait_flash_ready
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1726:
	mov	w0, 239
	str	w0, [x23, 2056]
	mov	w0, 137
	str	w0, [x23, 2052]
	add	w27, w21, 1
	mov	w0, 200
	bl	timer_delay_ns
	str	w27, [x23, 2048]
	str	wzr, [x23, 2048]
	mov	x3, x26
	ldr	w4, [x29, 116]
	mov	x2, x25
	str	wzr, [x23, 2048]
	mov	w1, w22
	str	wzr, [x23, 2048]
	mov	w0, w24
	bl	flash_read_page
	mov	w7, w0
	ldr	x0, [x29, 96]
	ldr	w0, [x0]
	tbz	x0, 12, .L1722
	mov	w4, w7
	str	w7, [x29, 112]
	mov	w3, w28
	mov	w2, w22
	mov	w1, w21
	adrp	x0, .LC109
	add	x0, x0, :lo12:.LC109
	bl	printf
	ldr	w7, [x29, 112]
.L1722:
	cmn	w7, #1
	beq	.L1723
	adrp	x0, .LANCHOR156
	cmn	w28, #1
	csel	w28, w28, w7, ne
	cmp	w7, w20
	ldr	x25, [x0, #:lo12:.LANCHOR156]
	adrp	x0, .LANCHOR158
	ldr	x26, [x0, #:lo12:.LANCHOR158]
	bcc	.L1729
.L1723:
	mov	w21, w27
	b	.L1721
.L1729:
	mov	w28, w7
	b	.L1725
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
	cbnz	w4, .L1744
	str	x0, [x29, 120]
	sxtw	x0, w24
	add	x0, x0, 8
	add	x0, x25, x0, lsl 8
	str	x0, [x29, 112]
.L1751:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, 36
	bne	.L1745
	mov	w1, w20
	mov	x0, x21
	mov	w2, 0
	bl	toshiba_tlc_set_rr_para
	ldr	x1, [x29, 112]
	mov	w0, 93
	str	w0, [x1, 8]
.L1746:
	mov	w4, w28
	mov	x3, x27
	mov	x2, x26
	mov	w1, w23
	mov	w0, w24
	bl	flash_read_page
	mov	w4, w0
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 4, .L1747
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC111
	add	x0, x0, :lo12:.LC111
	bl	printf
	ldr	w4, [x29, 108]
.L1747:
	cmn	w4, #1
	beq	.L1748
	adrp	x0, .LANCHOR156
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x26, [x0, #:lo12:.LANCHOR156]
	adrp	x0, .LANCHOR158
	ldr	x27, [x0, #:lo12:.LANCHOR158]
	adrp	x0, .LANCHOR44
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1766
.L1748:
	ldr	w0, [x29, 136]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1751
.L1750:
	ldrb	w0, [x22, #:lo12:.LANCHOR24]
	cmp	w0, 36
	bne	.L1752
	mov	w2, 0
.L1789:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_tlc_set_rr_para
	b	.L1753
.L1745:
	mov	w1, w20
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
	b	.L1746
.L1766:
	mov	w19, w4
	b	.L1750
.L1752:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
.L1753:
	ldrb	w0, [x22, #:lo12:.LANCHOR24]
	cmp	w0, 36
	bne	.L1762
	ldr	x0, [x29, 128]
	add	x25, x25, x0, lsl 8
	mov	w0, 85
	str	w0, [x25, 2056]
	mov	w0, 255
	str	wzr, [x25, 2052]
	str	wzr, [x25, 2048]
	str	w0, [x25, 2056]
.L1762:
	adrp	x0, .LANCHOR44
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1763
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1763:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1764
	adrp	x0, .LC113
	mov	w4, w19
	mov	w3, w20
	mov	w2, w23
	mov	w1, w20
	add	x0, x0, :lo12:.LC113
	bl	printf
.L1764:
	bl	nandc_wait_flash_ready
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1744:
	str	x0, [x29, 112]
	sxtw	x0, w24
	add	x0, x0, 8
	add	x0, x25, x0, lsl 8
	str	x0, [x29, 136]
.L1760:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cmp	w0, 36
	bne	.L1754
	mov	x0, x21
	mov	w2, 1
	mov	w1, w20
	bl	toshiba_tlc_set_rr_para
	mov	w0, 93
.L1788:
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
	tbz	x0, 4, .L1756
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC112
	add	x0, x0, :lo12:.LC112
	bl	printf
	ldr	w4, [x29, 108]
.L1756:
	cmn	w4, #1
	beq	.L1757
	adrp	x0, .LANCHOR156
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x26, [x0, #:lo12:.LANCHOR156]
	adrp	x0, .LANCHOR158
	ldr	x27, [x0, #:lo12:.LANCHOR158]
	adrp	x0, .LANCHOR44
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1767
.L1757:
	ldr	w0, [x29, 120]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1760
.L1759:
	ldrb	w0, [x22, #:lo12:.LANCHOR24]
	cmp	w0, 36
	bne	.L1761
	mov	w2, 1
	b	.L1789
.L1754:
	mov	x0, x21
	mov	w1, w20
	bl	toshiba_3d_set_tlc_rr_para
	mov	w0, 38
	b	.L1788
.L1767:
	mov	w19, w4
	b	.L1759
.L1761:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_tlc_rr_para
	b	.L1753
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
	bls	.L1808
	adrp	x0, .LANCHOR21
	ldrb	w0, [x0, #:lo12:.LANCHOR21]
	cbz	w0, .L1809
	mov	w23, 1
	mov	w0, 1
	bl	nandc_set_if_mode
.L1792:
	and	x0, x19, 255
	mov	w1, 92
	add	x0, x22, x0, lsl 8
	str	w1, [x0, 2056]
	mov	w1, 197
	str	w1, [x0, 2056]
.L1791:
	sxtw	x0, w19
	mov	w20, 1
	add	x0, x0, 8
	mov	w24, -1
	add	x0, x22, x0, lsl 8
	str	x0, [x29, 96]
.L1793:
	adrp	x0, .LANCHOR159
	ldrb	w0, [x0, #:lo12:.LANCHOR159]
	add	w0, w0, 1
	cmp	w20, w0
	bcc	.L1802
	mov	w28, w24
.L1801:
	ldr	x0, [x29, 120]
	mov	w1, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1803
	bl	sandisk_set_rr_para
.L1804:
	sxtw	x19, w19
	mov	w0, 255
	add	x19, x19, 8
	add	x22, x22, x19, lsl 8
	str	w0, [x22, 8]
	adrp	x0, .LANCHOR44
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L1805
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L1805:
	cmp	w28, 256
	ccmn	w28, #1, 4, ne
	bne	.L1806
	adrp	x0, .LC113
	mov	w4, w28
	mov	w3, w20
	mov	w2, w25
	mov	w1, w20
	add	x0, x0, :lo12:.LC113
	bl	printf
.L1806:
	bl	nandc_wait_flash_ready
	cbz	w23, .L1790
	mov	w0, 4
	bl	nandc_set_if_mode
.L1790:
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1809:
	mov	w23, 0
	b	.L1792
.L1808:
	mov	w23, 0
	b	.L1791
.L1802:
	ldr	x0, [x29, 120]
	mov	w1, w20
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1794
	bl	sandisk_set_rr_para
.L1795:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	cmp	w0, 34
	bne	.L1796
	adrp	x0, .LANCHOR159
	ldrb	w0, [x0, #:lo12:.LANCHOR159]
	sub	w0, w0, #3
	cmp	w20, w0
	bne	.L1796
	ldr	x1, [x29, 96]
	mov	w0, 179
	str	w0, [x1, 8]
.L1796:
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
	beq	.L1799
	cmn	w24, #1
	csel	w24, w24, w0, ne
	adrp	x0, .LANCHOR156
	ldr	x26, [x0, #:lo12:.LANCHOR156]
	adrp	x0, .LANCHOR158
	ldr	x27, [x0, #:lo12:.LANCHOR158]
	adrp	x0, .LANCHOR44
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L1801
.L1799:
	add	w20, w20, 1
	b	.L1793
.L1794:
	bl	toshiba_set_rr_para
	b	.L1795
.L1803:
	bl	toshiba_set_rr_para
	b	.L1804
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
	adrp	x6, .LANCHOR44
	add	x6, x6, :lo12:.LANCHOR44
	mov	w5, 0
	adrp	x7, .LANCHOR156
	adrp	x8, .LANCHOR158
.L1823:
	cmp	w5, w24
	bcc	.L1828
.L1827:
	adrp	x0, .LANCHOR44
	add	x23, x28, x23
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	strb	w20, [x23, 8]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1829
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1829:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1830
	adrp	x0, .LC114
	mov	w4, w19
	mov	w3, w5
	mov	w2, w22
	mov	w1, w5
	add	x0, x0, :lo12:.LC114
	bl	printf
.L1830:
	bl	nandc_wait_flash_ready
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1828:
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
	beq	.L1825
	ldrb	w1, [x6]
	cmn	w19, #1
	csel	w19, w19, w0, ne
	ldr	x25, [x7, #:lo12:.LANCHOR156]
	ldr	x26, [x8, #:lo12:.LANCHOR158]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L1831
.L1825:
	add	w5, w5, 1
	b	.L1823
.L1831:
	mov	w19, w0
	b	.L1827
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
	adrp	x25, .LANCHOR44
	str	w4, [x29, 136]
	bl	nandc_get_ddr_para
	add	x25, x25, :lo12:.LANCHOR44
	str	w0, [x29, 132]
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	mov	w28, 0
	str	x0, [x29, 120]
	mov	w26, 0
	adrp	x0, .LC115
	mov	w27, 0
	add	x0, x0, :lo12:.LC115
	mov	w19, 1024
	mov	w21, -1
	mov	w7, 6
	str	wzr, [x29, 140]
	str	x0, [x29, 112]
.L1847:
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
	tbz	x0, 4, .L1842
	ldr	x0, [x29, 112]
	mov	w3, w4
	mov	w1, w7
	str	w4, [x29, 108]
	str	w7, [x29, 128]
	mov	w2, w22
	bl	printf
	ldr	w4, [x29, 108]
	ldr	w7, [x29, 128]
.L1842:
	add	w0, w19, 1
	cmp	w4, w0
	bhi	.L1843
	adrp	x0, .LANCHOR156
	ldr	x23, [x0, #:lo12:.LANCHOR156]
	adrp	x0, .LANCHOR158
	ldr	x24, [x0, #:lo12:.LANCHOR158]
	ldrb	w0, [x25]
	cmp	w4, w0, lsr 2
	bcs	.L1853
	add	w27, w27, 1
	cmp	w27, 7
	bls	.L1853
	sub	w28, w7, w27
	mov	w19, w4
	mov	w21, 0
.L1845:
	ldr	w0, [x29, 140]
	cmp	w27, w26
	csel	w28, w28, w0, cs
.L1846:
	cbz	w28, .L1848
	adrp	x0, .LANCHOR44
	mov	w1, 3
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	udiv	w0, w0, w1
	cmp	w0, w19
	bls	.L1848
	mov	w1, w28
	adrp	x0, .LC116
	add	x0, x0, :lo12:.LC116
	bl	printf
	mov	w0, w28
.L1864:
	bl	nandc_set_ddr_para
	cbz	w21, .L1841
	mov	w2, w22
	mov	w1, w20
	adrp	x0, .LC117
	add	x0, x0, :lo12:.LC117
	bl	printf
	mov	w0, w20
	bl	flash_reset
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
	bl	nandc_set_if_mode
	adrp	x0, .LANCHOR32
	add	x0, x0, :lo12:.LANCHOR32
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
	adrp	x0, .LC118
	add	x0, x0, :lo12:.LC118
	bl	printf
	adrp	x0, .LANCHOR44
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	cmp	w19, w0
	bhi	.L1855
	adrp	x1, .LANCHOR160
	ldr	w0, [x1, #:lo12:.LANCHOR160]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR160]
	cmp	w0, 100
	bls	.L1851
	adrp	x0, .LANCHOR21
	strb	wzr, [x0, #:lo12:.LANCHOR21]
.L1841:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1843:
	cmp	w27, w26
	bls	.L1854
	sub	w0, w28, w27
	str	w0, [x29, 140]
	cmp	w27, 7
	bhi	.L1846
	mov	w26, w27
.L1854:
	mov	w27, 0
	b	.L1844
.L1853:
	mov	w28, w7
	mov	w19, w4
	mov	w21, 0
.L1844:
	add	w7, w7, 2
	cmp	w7, 50
	bne	.L1847
	b	.L1845
.L1848:
	ldrb	w0, [x29, 132]
	b	.L1864
.L1855:
	mov	w19, w21
.L1851:
	adrp	x20, .LANCHOR43
	ldrb	w0, [x20, #:lo12:.LANCHOR43]
	bl	flash_set_interface_mode
	ldrb	w0, [x20, #:lo12:.LANCHOR43]
	bl	nandc_set_if_mode
	b	.L1841
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
	bhi	.L1866
	adrp	x1, .LANCHOR161
	adrp	x0, .LC0
	mov	w2, 398
	add	x1, x1, :lo12:.LANCHOR161
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1866:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w21, [x0, w20, sxtw]
	ldrb	w0, [x25, #:lo12:.LANCHOR18]
	cmp	w0, w20
	bcs	.L1867
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbnz	x0, 6, .L1868
.L1892:
	mov	w0, -1
.L1865:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1868:
	mov	w3, w19
	mov	w2, w20
	mov	w1, w21
	adrp	x0, .LC119
	add	x0, x0, :lo12:.LC119
	bl	printf
	b	.L1892
.L1867:
	tst	x19, 50331648
	bne	.L1870
	adrp	x0, .LANCHOR0
	adrp	x1, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L1871
	ldrb	w0, [x1, #:lo12:.LANCHOR1]
	cbz	w0, .L1870
.L1871:
	adrp	x0, .LANCHOR2
	ldrb	w1, [x1, #:lo12:.LANCHOR1]
	ldrh	w2, [x0, #:lo12:.LANCHOR2]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L1872
	add	w19, w0, w19, lsl 1
.L1870:
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w21
	bl	flash_read_page
	cmn	w0, #1
	bne	.L1865
	adrp	x20, .LANCHOR46
	ldrb	w25, [x20, #:lo12:.LANCHOR46]
	cbnz	w25, .L1873
.L1876:
	adrp	x0, .LANCHOR162
	ldr	x5, [x0, #:lo12:.LANCHOR162]
	cbnz	x5, .L1874
.L1875:
	ldrb	w4, [x20, #:lo12:.LANCHOR46]
	mov	w3, -1
	mov	w2, w19
	mov	w1, 0
	adrp	x0, .LC120
	add	x0, x0, :lo12:.LC120
	bl	printf
	adrp	x0, .LANCHOR21
	ldrb	w0, [x0, #:lo12:.LANCHOR21]
	cbz	w0, .L1892
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
.L1872:
	adrp	x1, .LANCHOR3
	add	x1, x1, :lo12:.LANCHOR3
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
	b	.L1870
.L1873:
	strb	wzr, [x20, #:lo12:.LANCHOR46]
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w21
	bl	flash_read_page
	strb	w25, [x20, #:lo12:.LANCHOR46]
	cmn	w0, #1
	beq	.L1876
	b	.L1865
.L1874:
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w21
	blr	x5
	cmn	w0, #1
	beq	.L1875
	b	.L1865
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
	adrp	x0, .LANCHOR140
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	mov	x24, x2
	ldrh	w19, [x0, #:lo12:.LANCHOR140]
	adrp	x0, .LANCHOR31+26
	stp	x21, x22, [sp, 32]
	and	w21, w1, 65535
	ldrh	w26, [x0, #:lo12:.LANCHOR31+26]
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
	bne	.L1894
	mov	w27, 0
	mov	w28, 2
.L1895:
	cmp	w27, w19
	ble	.L1898
.L1894:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1899
	ldr	w3, [x22]
	adrp	x0, .LC121
	mov	w2, w19
	mov	w1, w21
	add	x0, x0, :lo12:.LC121
	bl	printf
.L1899:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1898:
	add	w20, w27, w19
	mov	w4, w25
	mov	x3, x22
	mov	x2, x24
	mov	w0, w23
	sdiv	w20, w20, w28
	add	w1, w26, w20, sxth
	bl	flash_read_page_en
	cmp	w0, 512
	bne	.L1896
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L1895
.L1896:
	add	w20, w20, 1
	sxth	w27, w20
	b	.L1895
	.size	flash_get_last_written_page, .-flash_get_last_written_page
	.section	.text.flash_get_last_written_page_ext,"ax",@progbits
	.align	2
	.global	flash_get_last_written_page_ext
	.type	flash_get_last_written_page_ext, %function
flash_get_last_written_page_ext:
	adrp	x4, .LANCHOR66
	mov	w6, 21
	and	w0, w0, 65535
	mov	w5, 1
	ldrh	w4, [x4, #:lo12:.LANCHOR66]
	sub	w6, w6, w4
	mov	w4, w3
	mov	x3, x2
	mov	x2, x1
	lsl	w5, w5, w6
	sub	w5, w5, #1
	and	w1, w5, w0
	asr	w0, w0, w6
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
	adrp	x20, .LANCHOR43
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	ldrb	w0, [x20, #:lo12:.LANCHOR43]
	adrp	x19, .LANCHOR21
	stp	x23, x24, [sp, 48]
	mov	w21, 1
	mov	w23, w1
	str	x25, [sp, 64]
	strb	w21, [x19, #:lo12:.LANCHOR21]
	adrp	x24, .LANCHOR164
	bl	flash_set_interface_mode
	adrp	x25, .LANCHOR163
	ldrb	w0, [x20, #:lo12:.LANCHOR43]
	bl	nandc_set_if_mode
	ldr	x3, [x25, #:lo12:.LANCHOR163]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR164]
	mov	w1, w23
	mov	w0, w22
	bl	flash_ddr_tuning_read
	ldr	x3, [x25, #:lo12:.LANCHOR163]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR164]
	mov	w1, w23
	mov	w0, w22
	bl	flash_read_page
	cmn	w0, #1
	mov	x0, x19
	bne	.L1906
	ldrb	w1, [x20, #:lo12:.LANCHOR43]
	tbz	x1, 0, .L1906
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, w21
	bl	nandc_set_if_mode
	strb	wzr, [x19, #:lo12:.LANCHOR21]
.L1907:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1906:
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR21]
	b	.L1907
	.size	flash_ddr_para_scan, .-flash_ddr_para_scan
	.section	.text.flash_complete_plane_page_read,"ax",@progbits
	.align	2
	.global	flash_complete_plane_page_read
	.type	flash_complete_plane_page_read, %function
flash_complete_plane_page_read:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 2097151
	ubfx	x20, x0, 24, 2
	str	x23, [sp, 48]
	ubfx	x23, x0, 21, 3
	adrp	x0, .LANCHOR18
	stp	x21, x22, [sp, 32]
	mov	x21, x1
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	mov	x22, x2
	cmp	w0, w23
	bhi	.L1913
	adrp	x1, .LANCHOR165
	adrp	x0, .LC0
	mov	w2, 886
	add	x1, x1, :lo12:.LANCHOR165
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1913:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w6, [x0, w23, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x4, [x0, #:lo12:.LANCHOR13]
	mov	w0, w6
	bl	nandc_cs
	cbnz	w20, .L1914
	mov	w0, w19
	bl	slc_phy_page_address_calc
	mov	w19, w0
.L1914:
	adrp	x0, .LANCHOR20+16
	and	x1, x6, 255
	and	w3, w19, 255
	lsr	w2, w19, 8
	ldrb	w0, [x0, #:lo12:.LANCHOR20+16]
	adrp	x5, .LANCHOR16
	cmp	w0, 1
	lsr	w0, w19, 16
	bne	.L1915
	add	x1, x4, x1, lsl 8
	mov	w4, 6
.L1926:
	str	w4, [x1, 2056]
	str	wzr, [x1, 2052]
	str	wzr, [x1, 2052]
	str	w3, [x1, 2052]
	str	w2, [x1, 2052]
	str	w0, [x1, 2052]
.L1924:
	mov	w0, 224
	str	w0, [x1, 2056]
	ldr	x0, [x5, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1918
	cbz	w20, .L1918
	add	w19, w19, w19, lsl 1
	sub	w20, w20, #1
	add	w0, w19, w20
.L1925:
	bl	nandc_set_seed
	adrp	x0, .LANCHOR31+9
	mov	x4, x22
	mov	x3, x21
	mov	w1, 0
	ldrb	w2, [x0, #:lo12:.LANCHOR31+9]
	mov	w0, w6
	bl	nandc_xfer
	mov	w2, w0
	bl	nandc_de_cs.constprop.29
	ldr	x23, [sp, 48]
	mov	w0, w2
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1915:
	ldr	x7, [x5, #:lo12:.LANCHOR16]
	add	x1, x4, x1, lsl 8
	ldrb	w7, [x7, 12]
	cmp	w7, 3
	bne	.L1917
	mov	w4, 5
	b	.L1926
.L1917:
	str	wzr, [x1, 2056]
	str	wzr, [x1, 2052]
	str	wzr, [x1, 2052]
	str	w3, [x1, 2052]
	str	w2, [x1, 2052]
	str	w0, [x1, 2052]
	mov	w0, 5
	str	w0, [x1, 2056]
	str	wzr, [x1, 2052]
	str	wzr, [x1, 2052]
	b	.L1924
.L1918:
	mov	w0, w19
	b	.L1925
	.size	flash_complete_plane_page_read, .-flash_complete_plane_page_read
	.section	.text.flash_complete_page_read,"ax",@progbits
	.align	2
	.global	flash_complete_page_read
	.type	flash_complete_page_read, %function
flash_complete_page_read:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 2097151
	stp	x23, x24, [sp, 48]
	mov	w23, w0
	adrp	x0, .LANCHOR18
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	ubfx	x20, x23, 21, 3
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	mov	x24, x1
	stp	x27, x28, [sp, 80]
	mov	x25, x2
	ubfx	x21, x23, 24, 2
	cmp	w0, w20
	bhi	.L1928
	adrp	x1, .LANCHOR166
	adrp	x0, .LC0
	mov	w2, 1008
	add	x1, x1, :lo12:.LANCHOR166
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1928:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w22, [x0, w20, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x4, [x0, #:lo12:.LANCHOR13]
	mov	w0, w22
	bl	nandc_cs
	cbnz	w21, .L1929
	mov	w0, w19
	bl	slc_phy_page_address_calc
	mov	w19, w0
.L1929:
	ubfiz	x0, x22, 8, 8
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
	bne	.L1930
	cbz	w21, .L1930
	sub	w0, w21, #1
	add	w1, w19, w19, lsl 1
	add	w0, w0, w1
.L1957:
	adrp	x20, .LANCHOR31
	add	x28, x20, :lo12:.LANCHOR31
	bl	nandc_set_seed
	mov	x4, x25
	mov	x3, x24
	ldrb	w2, [x28, 9]
	mov	w1, 0
	mov	w0, w22
	bl	nandc_xfer
	cmn	w0, #1
	bne	.L1932
	adrp	x26, .LANCHOR46
	ldrb	w27, [x26, #:lo12:.LANCHOR46]
	cbz	w27, .L1933
	ldrb	w4, [x28, 9]
	mov	x3, x25
	strb	wzr, [x26, #:lo12:.LANCHOR46]
	mov	x2, x24
	orr	w1, w19, w21, lsl 24
	mov	w0, w22
	bl	flash_read_page
	strb	w27, [x26, #:lo12:.LANCHOR46]
	cbnz	w21, .L1934
.L1939:
	adrp	x1, .LANCHOR0
	ldrb	w1, [x1, #:lo12:.LANCHOR0]
	cbz	w1, .L1934
	adrp	x1, .LANCHOR44
	ldrb	w1, [x1, #:lo12:.LANCHOR44]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	blt	.L1934
	add	x20, x20, :lo12:.LANCHOR31
	ldrb	w1, [x20, 19]
	sub	w1, w1, #4
	and	w1, w1, 255
	cmp	w1, 4
	mov	w1, 256
	csel	w0, w0, w1, hi
.L1927:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1930:
	mov	w0, w19
	b	.L1957
.L1934:
	cmn	w0, #1
	bne	.L1927
.L1940:
	adrp	x0, .LANCHOR162
	ldr	x5, [x0, #:lo12:.LANCHOR162]
	cbnz	x5, .L1936
.L1938:
	adrp	x0, .LANCHOR46
	mov	w3, -1
	mov	w2, w23
	mov	w1, 0
	ldrb	w4, [x0, #:lo12:.LANCHOR46]
	adrp	x0, .LC122
	add	x0, x0, :lo12:.LC122
	bl	printf
	adrp	x0, .LANCHOR21
	ldrb	w0, [x0, #:lo12:.LANCHOR21]
	cbnz	w0, .L1937
	mov	w0, -1
	b	.L1927
.L1936:
	add	x0, x20, :lo12:.LANCHOR31
	mov	x3, x25
	mov	x2, x24
	orr	w1, w19, w21, lsl 24
	ldrb	w4, [x0, 9]
	mov	w0, w22
	blr	x5
	cmn	w0, #1
	beq	.L1938
	b	.L1927
.L1937:
	add	x20, x20, :lo12:.LANCHOR31
	orr	w1, w19, w21, lsl 24
	mov	x3, x25
	mov	x2, x24
	mov	w0, w22
	ldrb	w4, [x20, 9]
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	flash_ddr_tuning_read
.L1932:
	cbz	w21, .L1939
	b	.L1927
.L1933:
	cbnz	w21, .L1940
	b	.L1939
	.size	flash_complete_page_read, .-flash_complete_page_read
	.section	.text.queue_wait_first_req_completed,"ax",@progbits
	.align	2
	.type	queue_wait_first_req_completed, %function
queue_wait_first_req_completed:
	stp	x29, x30, [sp, -96]!
	adrp	x0, .LANCHOR54
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldrb	w0, [x0, #:lo12:.LANCHOR54]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w0, 255
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	bne	.L1959
.L1992:
	mov	w21, 0
	b	.L1958
.L1959:
	adrp	x19, .LANCHOR50
	sxtw	x20, w0
	add	x1, x19, :lo12:.LANCHOR50
	add	x1, x1, x20, lsl 6
	ldrb	w2, [x1, 58]
	ldr	w21, [x1, 40]
	sub	w3, w2, #1
	cmp	w3, 10
	bhi	.L1992
	adrp	x1, .L1962
	add	x1, x1, :lo12:.L1962
	ldrh	w1, [x1,w3,uxtw #1]
	adr	x3, .Lrtx1962
	add	x1, x3, w1, sxth #2
	br	x1
.Lrtx1962:
	.section	.rodata.queue_wait_first_req_completed,"a",@progbits
	.align	0
	.align	2
.L1962:
	.2byte	(.L1961 - .Lrtx1962) / 4
	.2byte	(.L1963 - .Lrtx1962) / 4
	.2byte	(.L1964 - .Lrtx1962) / 4
	.2byte	(.L1964 - .Lrtx1962) / 4
	.2byte	(.L1964 - .Lrtx1962) / 4
	.2byte	(.L1964 - .Lrtx1962) / 4
	.2byte	(.L1965 - .Lrtx1962) / 4
	.2byte	(.L1966 - .Lrtx1962) / 4
	.2byte	(.L1967 - .Lrtx1962) / 4
	.2byte	(.L1964 - .Lrtx1962) / 4
	.2byte	(.L1967 - .Lrtx1962) / 4
	.section	.text.queue_wait_first_req_completed
.L1961:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L1992
	add	x0, x19, :lo12:.LANCHOR50
	add	x0, x0, x20, lsl 6
	ldp	x1, x2, [x0, 8]
	cbz	x2, .L1969
	ldrb	w3, [x0, 56]
	adrp	x0, .LANCHOR123
	ldrb	w0, [x0, #:lo12:.LANCHOR123]
	cmp	w3, w0
	csel	x1, x1, x2, ne
.L1969:
	add	x19, x19, :lo12:.LANCHOR50
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
	b	.L1992
.L1963:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L1992
	add	x0, x19, :lo12:.LANCHOR50
	lsl	x2, x20, 6
	add	x1, x0, x2
	ldrb	w21, [x0, x2]
	add	x0, x0, x21, lsl 6
	ldr	x24, [x0, 8]
	ldp	x26, x0, [x1, 8]
	cbz	x0, .L1970
	ldrb	w2, [x1, 56]
	adrp	x1, .LANCHOR123
	ldrb	w1, [x1, #:lo12:.LANCHOR123]
	cmp	w2, w1
	csel	x26, x26, x0, ne
.L1970:
	add	x0, x19, :lo12:.LANCHOR50
	add	x0, x0, x21, lsl 6
	ldr	x1, [x0, 16]
	cbz	x1, .L1971
	ldrb	w2, [x0, 56]
	adrp	x0, .LANCHOR123
	ldrb	w0, [x0, #:lo12:.LANCHOR123]
	cmp	w2, w0
	csel	x24, x24, x1, ne
.L1971:
	add	x22, x19, :lo12:.LANCHOR50
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
	beq	.L1972
	ldr	w0, [x27, 36]
	cmn	w0, #1
	beq	.L1973
	ldr	x1, [x27, 24]
	ldr	w1, [x1, 4]
	cmp	w0, w1
	beq	.L1973
.L1972:
	add	x22, x19, :lo12:.LANCHOR50
	adrp	x2, .LANCHOR123
	add	x22, x22, x20, lsl 6
	ldrb	w4, [x2, #:lo12:.LANCHOR123]
	mov	x2, x26
	ldr	x3, [x22, 24]
	ldr	w1, [x22, 40]
	ubfx	x0, x1, 21, 3
	and	w1, w1, -14680065
	bl	flash_read_page_en
	mov	w23, w0
	ldr	w2, [x22, 36]
	cmn	w2, #1
	beq	.L1974
	ldr	x0, [x22, 24]
	ldr	w4, [x0, 4]
	cmp	w2, w4
	beq	.L1974
	adrp	x1, .LANCHOR14
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 6, .L1974
	ldr	w3, [x0]
	adrp	x0, .LC123
	ldr	w1, [x22, 40]
	add	x0, x0, :lo12:.LC123
	bl	printf
.L1974:
	add	x0, x19, :lo12:.LANCHOR50
	add	x0, x0, x20, lsl 6
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L1973
	ldr	x0, [x0, 24]
	ldr	w0, [x0, 4]
	cmp	w1, w0
	beq	.L1973
	adrp	x1, .LANCHOR167
	adrp	x0, .LC0
	mov	w2, 360
	add	x1, x1, :lo12:.LANCHOR167
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1973:
	add	x0, x19, :lo12:.LANCHOR50
	mov	w1, 13
	add	x20, x0, x20, lsl 6
	cmn	w25, #1
	strb	w1, [x20, 58]
	ldrb	w1, [x20, 2]
	str	w23, [x20, 52]
	orr	w1, w1, 8
	strb	w1, [x20, 2]
	beq	.L1975
	add	x0, x0, x21, lsl 6
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L1977
	ldr	x0, [x0, 24]
	ldr	w0, [x0, 4]
	cmp	w1, w0
	beq	.L1977
.L1975:
	add	x20, x19, :lo12:.LANCHOR50
	adrp	x2, .LANCHOR123
	add	x20, x20, x21, lsl 6
	ldrb	w4, [x2, #:lo12:.LANCHOR123]
	mov	x2, x24
	ldr	x3, [x20, 24]
	ldr	w1, [x20, 40]
	ubfx	x0, x1, 21, 3
	and	w1, w1, -14680065
	bl	flash_read_page_en
	ldr	w2, [x20, 36]
	cmn	w2, #1
	beq	.L1979
	ldr	x0, [x20, 24]
	ldr	w4, [x0, 4]
	cmp	w2, w4
	beq	.L1979
	adrp	x1, .LANCHOR14
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 6, .L1979
	ldr	w3, [x0]
	adrp	x0, .LC123
	ldr	w1, [x20, 40]
	add	x0, x0, :lo12:.LC123
	bl	printf
.L1979:
	add	x0, x19, :lo12:.LANCHOR50
	add	x0, x0, x21, lsl 6
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L1977
	ldr	x0, [x0, 24]
	ldr	w0, [x0, 4]
	cmp	w1, w0
	beq	.L1977
	adrp	x1, .LANCHOR167
	adrp	x0, .LC0
	mov	w2, 375
	add	x1, x1, :lo12:.LANCHOR167
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1977:
	add	x19, x19, :lo12:.LANCHOR50
	mov	w0, 13
	add	x21, x19, x21, lsl 6
	strb	w0, [x21, 58]
	ldrb	w0, [x21, 2]
	str	w23, [x21, 52]
	orr	w0, w0, 8
	strb	w0, [x21, 2]
	b	.L1992
.L1964:
	mov	w0, w21
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w21, w0
	tbz	x21, 6, .L1992
	mov	w0, 5
	tst	w21, w0
	beq	.L1980
	add	x19, x19, :lo12:.LANCHOR50
	mov	w0, 12
	add	x20, x19, x20, lsl 6
	mov	w4, 12
	mov	w2, w21
	ldrb	w1, [x20, 1]
	ldr	w3, [x20, 40]
	strb	w0, [x20, 58]
	adrp	x0, .LC124
	add	x0, x0, :lo12:.LC124
	bl	printf
.L2056:
	mov	w0, -1
	str	w0, [x20, 52]
	b	.L1958
.L1980:
	add	x21, x19, :lo12:.LANCHOR50
	mov	w0, 13
	add	x21, x21, x20, lsl 6
	strb	w0, [x21, 58]
	adrp	x0, .LANCHOR102
	ldr	x0, [x0, #:lo12:.LANCHOR102]
	ldr	w1, [x0, 156]
	mov	w0, 20041
	str	wzr, [x21, 52]
	movk	w0, 0x444b, lsl 16
	cmp	w1, w0
	bne	.L1992
	ldrh	w0, [x21, 50]
	cbnz	w0, .L1992
	adrp	x2, .LANCHOR123
	adrp	x22, .LANCHOR163
	ldr	w1, [x21, 40]
	ldrb	w4, [x2, #:lo12:.LANCHOR123]
	adrp	x2, .LANCHOR164
	ldr	x3, [x22, #:lo12:.LANCHOR163]
	ldr	x2, [x2, #:lo12:.LANCHOR164]
	ubfx	x0, x1, 21, 3
	and	w1, w1, -14680065
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1981
	ldr	x1, [x22, #:lo12:.LANCHOR163]
	ldr	x2, [x21, 24]
	ldr	w1, [x1]
	ldr	w2, [x2]
	cmp	w2, w1
	beq	.L1992
.L1981:
	add	x19, x19, :lo12:.LANCHOR50
	adrp	x1, .LANCHOR46
	add	x20, x19, x20, lsl 6
	mov	w3, w0
	ldrb	w4, [x1, #:lo12:.LANCHOR46]
	adrp	x0, .LC125
	add	x0, x0, :lo12:.LC125
	ldrb	w1, [x20, 1]
	ldr	w2, [x20, 40]
	bl	printf
	mov	w0, -1
	str	w0, [x20, 52]
	b	.L1992
.L1967:
	cmp	w2, 11
	add	x22, x19, :lo12:.LANCHOR50
	ubfiz	x0, x0, 6, 8
	mov	w1, 3
	mov	w2, 10
	add	x0, x22, x0
	csel	w2, w2, w1, eq
	ubfx	x3, x21, 21, 3
.L1983:
	ldrb	w1, [x0]
	cmp	w1, 255
	bne	.L1990
	mov	w21, -1
	b	.L1958
.L1990:
	sxtw	x23, w1
	ubfiz	x0, x1, 6, 8
	add	x1, x22, x23, lsl 6
	add	x0, x22, x0
	ldrb	w4, [x1, 58]
	cmp	w4, w2
	bne	.L1983
	ldr	w1, [x1, 40]
	ubfx	x1, x1, 21, 3
	cmp	w3, w1
	bne	.L1983
	mov	w0, w21
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w21, w0
	tbnz	x21, 6, .L1985
.L2055:
	mov	w21, 0
	b	.L1986
.L1985:
	tst	x21, 15
	beq	.L1987
	add	x22, x22, x20, lsl 6
	mov	w2, w0
	mov	w4, 12
	adrp	x0, .LC126
	add	x0, x0, :lo12:.LC126
	ldrb	w1, [x22, 1]
	ldr	w3, [x22, 40]
	bl	printf
	mov	w0, 12
	strb	w0, [x22, 58]
	mov	w0, -1
	str	w0, [x22, 52]
.L1986:
	add	x1, x19, :lo12:.LANCHOR50
	add	x20, x1, x20, lsl 6
	add	x1, x1, x23, lsl 6
	ldrb	w0, [x20, 58]
	strb	w0, [x1, 58]
	ldr	w0, [x20, 52]
	str	w0, [x1, 52]
.L1958:
	mov	w0, w21
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1987:
	add	x21, x22, x20, lsl 6
	mov	w0, 13
	strb	w0, [x21, 58]
	adrp	x0, .LANCHOR102
	ldr	x0, [x0, #:lo12:.LANCHOR102]
	ldr	w1, [x0, 156]
	mov	w0, 20041
	str	wzr, [x21, 52]
	movk	w0, 0x444b, lsl 16
	cmp	w1, w0
	bne	.L2055
	ldrh	w0, [x21, 50]
	cbnz	w0, .L2055
	adrp	x2, .LANCHOR123
	adrp	x22, .LANCHOR163
	ldr	w1, [x21, 40]
	ldrb	w4, [x2, #:lo12:.LANCHOR123]
	adrp	x2, .LANCHOR164
	ldr	x3, [x22, #:lo12:.LANCHOR163]
	ldr	x2, [x2, #:lo12:.LANCHOR164]
	ubfx	x0, x1, 21, 3
	and	w1, w1, -14680065
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1989
	ldr	x1, [x22, #:lo12:.LANCHOR163]
	ldr	x2, [x21, 24]
	ldr	w1, [x1]
	ldr	w2, [x2]
	cmp	w2, w1
	beq	.L2055
.L1989:
	add	x21, x19, :lo12:.LANCHOR50
	adrp	x1, .LANCHOR46
	add	x21, x21, x20, lsl 6
	mov	w3, w0
	ldrb	w4, [x1, #:lo12:.LANCHOR46]
	adrp	x0, .LC127
	add	x0, x0, :lo12:.LC127
	ldrb	w1, [x21, 1]
	ldr	w2, [x21, 40]
	bl	printf
	mov	w0, -1
	str	w0, [x21, 52]
	b	.L2055
.L1965:
	mov	w0, w21
	mov	w1, 32
	bl	flash_wait_device_ready
	mov	w21, w0
	tbz	x21, 5, .L1992
	add	x19, x19, :lo12:.LANCHOR50
	tst	x21, 15
	add	x20, x19, x20, lsl 6
	beq	.L1991
	mov	w0, 12
	strb	w0, [x20, 58]
	b	.L2056
.L1991:
	mov	w0, 13
	str	wzr, [x20, 52]
	strb	w0, [x20, 58]
	b	.L1992
.L1966:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L1992
	add	x19, x19, :lo12:.LANCHOR50
	add	x19, x19, x20, lsl 6
	str	w0, [x19, 52]
	mov	w0, 7
	strb	w0, [x19, 58]
	b	.L1992
	.size	queue_wait_first_req_completed, .-queue_wait_first_req_completed
	.section	.text.sblk_wait_write_queue_completed,"ax",@progbits
	.align	2
	.global	sblk_wait_write_queue_completed
	.type	sblk_wait_write_queue_completed, %function
sblk_wait_write_queue_completed:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR54
	add	x19, x19, :lo12:.LANCHOR54
.L2058:
	ldrb	w0, [x19]
	cmp	w0, 255
	bne	.L2059
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2059:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2058
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
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w0
	stp	x21, x22, [sp, 32]
	mov	x20, x1
	mov	x21, x2
	mov	w22, w3
	bl	sblk_wait_write_queue_completed
	ubfx	x0, x19, 21, 3
	mov	w4, w22
	mov	x3, x21
	mov	x2, x20
	mov	w1, w19
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
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
	stp	x19, x20, [sp, 16]
	adrp	x21, .LANCHOR50
	stp	x23, x24, [sp, 48]
	mov	x19, x0
	stp	x25, x26, [sp, 64]
	mov	x23, x0
	adrp	x26, .LANCHOR168
	mov	w20, w22
	add	x26, x26, :lo12:.LANCHOR168
	add	x21, x21, :lo12:.LANCHOR50
	stp	x27, x28, [sp, 80]
	adrp	x27, .LANCHOR103
.L2066:
	cbnz	w20, .L2076
.L2089:
	adrp	x19, .LANCHOR50
	add	x19, x19, :lo12:.LANCHOR50
.L2077:
	cbnz	w22, .L2079
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2076:
	ldrb	w24, [x19]
	ldr	w25, [x19, 40]
.L2067:
	mov	w1, 0
	mov	w0, w25
	bl	queue_lun_state
	cbnz	w0, .L2068
	cmp	w20, 1
	beq	.L2073
	ldrb	w0, [x26]
	cbnz	w0, .L2070
.L2073:
	mov	x0, x19
	bl	queue_read_cmd
	b	.L2071
.L2068:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2067
.L2070:
	ldrb	w0, [x19]
	ubfx	x4, x25, 21, 3
	cmp	w0, 255
	bne	.L2072
	str	w4, [x29, 124]
	mov	w2, 661
	adrp	x1, .LANCHOR169
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR169
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldr	w4, [x29, 124]
.L2072:
	ldrb	w28, [x19]
	sbfiz	x2, x28, 6, 32
	add	x3, x21, x2
	ldr	w1, [x3, 40]
	ubfx	x0, x1, 21, 3
	cmp	w4, w0
	bne	.L2073
	ldrh	w0, [x27, #:lo12:.LANCHOR103]
	add	w25, w0, w25
	cmp	w1, w25
	bne	.L2073
	ldr	w0, [x19, 40]
	adrp	x25, .LANCHOR54
	ldrb	w24, [x21, x2]
	add	x25, x25, :lo12:.LANCHOR54
	stp	x3, x2, [x29, 104]
	sub	w20, w20, #1
	bl	flash_start_plane_read
	strb	wzr, [x19, 59]
	mov	w5, 2
	mov	w4, -1
	strb	w5, [x19, 58]
	mov	x1, x19
	strb	w4, [x19]
	mov	x0, x25
	stp	w5, w4, [x29, 120]
	bl	buf_add_tail
	ldp	x3, x2, [x29, 104]
	strb	wzr, [x3, 59]
	ldp	w5, w4, [x29, 120]
	strb	w5, [x3, 58]
	ubfiz	x1, x28, 6, 8
	mov	x0, x25
	add	x1, x21, x1
	strb	w4, [x21, x2]
	bl	buf_add_tail
.L2071:
	subs	w20, w20, #1
	beq	.L2089
	ubfiz	x19, x24, 6, 8
	add	x19, x21, x19
	b	.L2066
.L2079:
	ldrb	w0, [x23, 58]
	cmp	w0, 13
	bne	.L2078
	ldrb	w0, [x23]
	sub	w22, w22, #1
	cmp	w0, 255
	beq	.L2078
	ubfiz	x23, x0, 6, 8
	add	x23, x19, x23
.L2078:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2077
	.size	sblk_read_page, .-sblk_read_page
	.section	.text.flash_prog_page,"ax",@progbits
	.align	2
	.global	flash_prog_page
	.type	flash_prog_page, %function
flash_prog_page:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	adrp	x0, .LANCHOR13
	stp	x23, x24, [sp, 48]
	stp	x21, x22, [sp, 32]
	and	x19, x20, 255
	ldr	x24, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR14
	stp	x25, x26, [sp, 64]
	mov	w21, w1
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	add	x22, x19, 8
	str	x27, [sp, 80]
	mov	x26, x2
	add	x22, x24, x22, lsl 8
	and	w23, w1, 2097151
	ubfx	x25, x21, 24, 2
	mov	x27, x3
	tbz	x0, 4, .L2092
	adrp	x0, .LC128
	mov	w3, w4
	mov	w2, w25
	add	x0, x0, :lo12:.LC128
	bl	printf
.L2092:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	hynix_reconfig_rr_para
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w25, .L2093
	bl	zftl_flash_enter_slc_mode
.L2094:
	add	x19, x24, x19, lsl 8
	mov	w0, 128
	str	w0, [x19, 2056]
	and	w0, w21, 255
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w23, 8
	str	w0, [x19, 2052]
	lsr	w0, w23, 16
	str	w0, [x19, 2052]
	mov	w0, w23
	bl	nandc_set_seed
	adrp	x0, .LANCHOR31+9
	mov	x3, x27
	mov	x2, x26
	ldrb	w1, [x0, #:lo12:.LANCHOR31+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	mov	w0, 16
	str	w0, [x19, 2056]
	bl	nandc_wait_flash_ready
	mov	x0, x22
	bl	flash_read_status
	mov	w2, w0
	bl	nandc_de_cs.constprop.29
	and	w19, w2, 4
	tbz	x2, 2, .L2091
	adrp	x0, .LC129
	mov	w2, w19
	mov	w1, w21
	add	x0, x0, :lo12:.LC129
	bl	printf
.L2091:
	mov	w0, w19
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2093:
	bl	zftl_flash_exit_slc_mode
	b	.L2094
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
	adrp	x22, .LANCHOR156
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	ldr	x0, [x22, #:lo12:.LANCHOR156]
	adrp	x21, .LANCHOR158
	and	w19, w1, 65535
	str	x23, [sp, 48]
	mov	w1, 165
	bl	ftl_memset
	ldr	x0, [x21, #:lo12:.LANCHOR158]
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
	bne	.L2104
.L2106:
	mov	w21, -1
.L2105:
	mov	w1, w19
	mov	w0, w20
	bl	flash_erase_block
	ldr	x23, [sp, 48]
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L2104:
	adrp	x23, .LANCHOR31
	add	x23, x23, :lo12:.LANCHOR31
	ldr	x3, [x21, #:lo12:.LANCHOR158]
	mov	w1, w19
	ldr	x2, [x22, #:lo12:.LANCHOR156]
	mov	w0, w20
	ldrb	w4, [x23, 9]
	bl	flash_prog_page
	cmn	w0, #1
	beq	.L2106
	ldrb	w4, [x23, 9]
	mov	w1, w19
	ldr	x3, [x21, #:lo12:.LANCHOR158]
	mov	w0, w20
	ldr	x2, [x22, #:lo12:.LANCHOR156]
	bl	flash_read_page
	cmn	w0, #1
	beq	.L2106
	ldr	x0, [x22, #:lo12:.LANCHOR156]
	ldr	w1, [x0]
	mov	w0, 42405
	movk	w0, 0xa5a5, lsl 16
	cmp	w1, w0
	bne	.L2106
	ldr	x0, [x21, #:lo12:.LANCHOR158]
	ldr	w1, [x0]
	mov	w0, 23130
	movk	w0, 0x5a5a, lsl 16
	cmp	w1, w0
	csetm	w21, ne
	b	.L2105
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
	cbnz	w0, .L2114
	adrp	x20, .LANCHOR31
	add	x20, x20, :lo12:.LANCHOR31
	ldrb	w0, [x20, 19]
	sub	w0, w0, #5
	and	w3, w0, 255
	cmp	w3, 63
	bhi	.L2114
	and	w19, w2, 65535
	mov	x2, 16391
	movk	x2, 0x4000, lsl 16
	movk	x2, 0x8000, lsl 48
	lsr	x0, x2, x3
	tbz	x0, 0, .L2114
	adrp	x21, .LANCHOR138
	mov	w23, w1
	add	x21, x21, :lo12:.LANCHOR138
	mov	w25, 65535
	adrp	x24, .LANCHOR156
.L2116:
	ldrh	w0, [x20, 10]
	cmp	w0, w19
	bhi	.L2117
.L2114:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2117:
	ldrh	w0, [x21, w19, sxtw 1]
	cmp	w0, w25
	bne	.L2114
	ldr	x0, [x24, #:lo12:.LANCHOR156]
	mov	w2, 16384
	mov	w1, 255
	bl	ftl_memset
	ldr	x3, [x24, #:lo12:.LANCHOR156]
	add	w1, w19, w23
	ldrb	w4, [x20, 9]
	add	w19, w19, 1
	mov	x2, x3
	mov	w0, w22
	and	w19, w19, 65535
	bl	flash_prog_page
	b	.L2116
	.size	id_block_prog_msb_ff_data, .-id_block_prog_msb_ff_data
	.section	.text.flash_dual_page_prog,"ax",@progbits
	.align	2
	.global	flash_dual_page_prog
	.type	flash_dual_page_prog, %function
flash_dual_page_prog:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	adrp	x0, .LANCHOR13
	stp	x23, x24, [sp, 48]
	stp	x19, x20, [sp, 16]
	and	x19, x22, 255
	ldr	x23, [x0, #:lo12:.LANCHOR13]
	add	x0, x19, 8
	stp	x27, x28, [sp, 80]
	mov	x27, x2
	stp	x25, x26, [sp, 64]
	mov	w21, w1
	add	x0, x23, x0, lsl 8
	str	x0, [x29, 104]
	adrp	x0, .LANCHOR14
	str	x0, [x29, 96]
	mov	x28, x3
	mov	x25, x4
	ldr	w2, [x0, #:lo12:.LANCHOR14]
	mov	x26, x5
	and	w20, w1, 2097151
	ubfx	x24, x21, 24, 2
	tbz	x2, 4, .L2120
	adrp	x0, .LC128
	mov	w3, w6
	mov	w2, w24
	add	x0, x0, :lo12:.LC128
	bl	printf
.L2120:
	bl	nandc_wait_flash_ready
	mov	w0, w22
	bl	nandc_cs
	mov	w0, w22
	cbnz	w24, .L2121
	bl	zftl_flash_enter_slc_mode
.L2122:
	add	x19, x23, x19, lsl 8
	mov	w24, 128
	and	w0, w21, 255
	adrp	x22, .LANCHOR31
	add	x22, x22, :lo12:.LANCHOR31
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
	ldrb	w1, [x22, 9]
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
	ldrb	w1, [x22, 9]
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
	bl	nandc_de_cs.constprop.29
	and	w19, w2, 4
	tbz	x2, 2, .L2119
	ldr	x0, [x29, 96]
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2119
	adrp	x0, .LC129
	mov	w2, w19
	mov	w1, w21
	add	x0, x0, :lo12:.LC129
	bl	printf
.L2119:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2121:
	bl	zftl_flash_exit_slc_mode
	b	.L2122
	.size	flash_dual_page_prog, .-flash_dual_page_prog
	.section	.text.fw_flash_page_prog.constprop.26,"ax",@progbits
	.align	2
	.type	fw_flash_page_prog.constprop.26, %function
fw_flash_page_prog.constprop.26:
	stp	x29, x30, [sp, -64]!
	adrp	x4, .LANCHOR31
	add	x4, x4, :lo12:.LANCHOR31
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x20, x1
	stp	x21, x22, [sp, 32]
	mov	x21, x2
	str	x23, [sp, 48]
	ldrb	w19, [x4, 9]
	udiv	w19, w0, w19
	adrp	x0, .LANCHOR44
	ldrb	w23, [x0, #:lo12:.LANCHOR44]
	adrp	x0, .LANCHOR17
	ldrb	w0, [x0, #:lo12:.LANCHOR17]
	bl	nandc_bch_sel
	ldrb	w0, [x4, 7]
	cmp	w0, 9
	bne	.L2135
	adrp	x22, .LANCHOR156
	mov	w2, 16384
	mov	w1, 255
	ldr	x0, [x22, #:lo12:.LANCHOR156]
	bl	ftl_memset
	ldr	x5, [x22, #:lo12:.LANCHOR156]
	mov	w6, 4
	mov	x3, x21
	mov	x2, x20
	mov	x4, x5
	mov	w1, w19
	mov	w0, 0
	bl	flash_dual_page_prog
.L2138:
	mov	w3, w0
	mov	w0, w23
	bl	nandc_bch_sel
	ldr	x23, [sp, 48]
	mov	w0, w3
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L2135:
	mov	w4, 4
	mov	x3, x21
	mov	x2, x20
	mov	w1, w19
	mov	w0, 0
	bl	flash_prog_page
	b	.L2138
	.size	fw_flash_page_prog.constprop.26, .-fw_flash_page_prog.constprop.26
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
	adrp	x22, .LANCHOR135
	stp	x27, x28, [sp, 80]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	ldr	x27, [x22, #:lo12:.LANCHOR135]
	bls	.L2140
	cmp	w1, 575
	bhi	.L2141
	mov	x21, x2
	mov	w20, w3
	cbnz	x27, .L2142
	mov	w0, 262144
	bl	ftl_malloc
	str	x0, [x22, #:lo12:.LANCHOR135]
	cbnz	x0, .L2143
.L2148:
	mov	w0, -1
.L2139:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 272
	ret
.L2143:
	mov	w2, 262144
	mov	w1, 0
	bl	ftl_memset
.L2142:
	adrp	x23, .LANCHOR137
	ldr	x0, [x23, #:lo12:.LANCHOR137]
	cbz	x0, .L2145
.L2149:
	adrp	x1, .LANCHOR136
	mov	w2, 1
	ldr	x0, [x22, #:lo12:.LANCHOR135]
	cmp	w19, 64
	str	w2, [x1, #:lo12:.LANCHOR136]
	bhi	.L2246
	mov	w1, 64
	sub	w19, w1, w19
	sub	w2, w20, w19
	ubfiz	x19, x19, 9, 25
	lsl	w2, w2, 9
	add	x1, x21, x19
.L2252:
	bl	ftl_memcpy
.L2251:
	mov	w0, 0
	b	.L2139
.L2145:
	mov	w0, 262144
	bl	ftl_malloc
	str	x0, [x23, #:lo12:.LANCHOR137]
	cbnz	x0, .L2149
	b	.L2148
.L2246:
	mov	w2, 576
	sub	w2, w2, w19
	cmp	w20, w2
	sub	w19, w19, #64
	csel	w2, w20, w2, ls
	ubfiz	x19, x19, 9, 25
	lsl	w2, w2, 9
	mov	x1, x21
	add	x0, x0, x19
	b	.L2252
.L2140:
	cmp	w1, 575
	bls	.L2251
.L2141:
	adrp	x0, .LANCHOR136
	ldr	w0, [x0, #:lo12:.LANCHOR136]
	cbz	w0, .L2251
	adrp	x1, .LANCHOR31
	add	x0, x1, :lo12:.LANCHOR31
	str	x1, [x29, 152]
	adrp	x8, .LANCHOR19
	ldrb	w20, [x0, 9]
	ldrh	w19, [x0, 26]
	adrp	x0, .LANCHOR0
	mov	x7, x0
	ldrb	w2, [x0, #:lo12:.LANCHOR0]
	str	w2, [x29, 188]
	uxtw	x0, w2
	cbz	w0, .L2199
	ldrb	w0, [x8, #:lo12:.LANCHOR19]
	cmp	w0, 0
	cset	w0, eq
	str	w0, [x29, 176]
.L2151:
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	ldrb	w0, [x8, #:lo12:.LANCHOR19]
	strb	w0, [x7, #:lo12:.LANCHOR0]
	mov	w0, 35899
	ldr	w1, [x27]
	movk	w0, 0xfcdc, lsl 16
	cmp	w1, w0
	bne	.L2153
	ldr	x0, [x29, 152]
	mov	w2, 65023
	mov	w3, 4097
	add	x1, x0, :lo12:.LANCHOR31
	ldrh	w0, [x1, 10]
	ldrb	w1, [x1, 12]
	lsl	w0, w0, 2
	sdiv	w26, w0, w1
	add	x1, x27, 258048
	mov	w0, 512
	add	x1, x1, 2044
	cmp	w26, 512
	csel	w26, w26, w0, lt
	mov	w0, 0
.L2157:
	ldr	w4, [x1]
	cbnz	w4, .L2155
	ldr	w4, [x27, w0, uxtw 2]
	add	w0, w0, 1
	str	w4, [x1, 2048]
	cmp	w0, w3
	sub	w2, w2, #1
	csel	w0, w0, wzr, cc
	sub	x1, x1, #4
	cmp	w2, 4096
	bne	.L2157
.L2155:
	ldr	w1, [x27, w2, uxtw 2]
	mul	w19, w19, w20
	mov	w3, w26
	adrp	x0, .LC130
	add	x0, x0, :lo12:.LC130
	bl	printf
	str	wzr, [x29, 184]
	and	w0, w19, 65535
	str	wzr, [x29, 200]
	str	w0, [x29, 140]
	adrp	x0, .LANCHOR46
	add	x0, x0, :lo12:.LANCHOR46
	str	x0, [x29, 192]
.L2195:
	adrp	x20, .LANCHOR137
	mov	w1, 0
	mov	w2, 512
	ldr	x0, [x20, #:lo12:.LANCHOR137]
	bl	ftl_memset
	adrp	x0, .LANCHOR27
	ldr	w1, [x29, 200]
	ldr	x0, [x0, #:lo12:.LANCHOR27]
	add	x0, x0, x1, uxtw
	ldrb	w19, [x0, 32]
	cmp	w19, 255
	beq	.L2158
	ldr	w0, [x29, 140]
	mul	w19, w19, w0
	ldr	w0, [x29, 176]
	cbz	w0, .L2159
	cmp	w1, 1
	adrp	x8, .LANCHOR0
	adrp	x7, .LANCHOR19
	bne	.L2160
	ldrb	w0, [x29, 188]
	strb	w0, [x8, #:lo12:.LANCHOR0]
	strb	w0, [x7, #:lo12:.LANCHOR19]
.L2159:
	ldr	x0, [x29, 152]
	add	x25, x0, :lo12:.LANCHOR31
	ldr	x0, [x29, 192]
	ldrb	w22, [x25, 9]
	ldrh	w23, [x25, 26]
	ldrb	w0, [x0]
	str	w0, [x29, 136]
	udiv	w1, w19, w22
	ldr	x0, [x29, 192]
	mul	w23, w22, w23
	and	w21, w23, 65535
	strb	wzr, [x0]
	mov	w0, 0
	bl	flash_erase_block
	udiv	w23, w19, w21
	ldrb	w0, [x25, 12]
	msub	w23, w23, w21, w19
	ldrh	w21, [x25, 10]
	sub	w24, w19, w23
	lsl	w21, w21, 2
	cmp	w19, w24
	sdiv	w0, w21, w0
	str	w0, [x29, 180]
	bne	.L2202
	adrp	x0, .LANCHOR28
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cmp	w0, 9
	bne	.L2202
	ldr	x21, [x20, #:lo12:.LANCHOR137]
	mov	w2, 1024
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	mov	w0, 18766
	movk	w0, 0x464e, lsl 16
	str	w0, [x21]
	mov	w0, 12
	str	w0, [x21, 4]
	adrp	x0, .LANCHOR19
	strb	wzr, [x21, 16]
	str	wzr, [x21, 12]
	ldrb	w0, [x0, #:lo12:.LANCHOR19]
	cbz	w0, .L2162
	ldrb	w0, [x25, 29]
	strb	w0, [x21, 16]
.L2162:
	mov	w0, 4
	strb	w0, [x21, 17]
	adrp	x0, .LANCHOR31
	add	x0, x0, :lo12:.LANCHOR31
	cmp	w22, 8
	strb	wzr, [x21, 20]
	strh	wzr, [x21, 22]
	ldrh	w1, [x0, 10]
	ldrb	w0, [x0, 12]
	sdiv	w0, w1, w0
	mov	w1, 16
	strh	w0, [x21, 18]
	mov	w0, 70
	csel	w0, w0, w1, hi
	strb	w0, [x21, 21]
	mov	w1, 12
	add	x0, x21, 12
	bl	js_hash
	str	w0, [x21, 8]
	sub	w0, w26, #4
	str	w0, [x29, 204]
.L2161:
	adrp	x0, .LANCHOR19
	mov	x25, x27
	add	x0, x0, :lo12:.LANCHOR19
	mov	w28, 0
	str	x0, [x29, 168]
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	str	x0, [x29, 160]
.L2164:
	ldr	w0, [x29, 180]
	cmp	w0, w28
	bhi	.L2175
	ldr	x0, [x29, 152]
	mov	w22, 4
	ldr	x21, [x20, #:lo12:.LANCHOR137]
	mov	w23, 0
	add	x0, x0, :lo12:.LANCHOR31
	str	wzr, [x29, 168]
	ldrb	w1, [x0, 9]
	ldrh	w28, [x0, 26]
	uxtw	x0, w1
	mul	w28, w0, w28
	adrp	x0, .LANCHOR46
	and	w28, w28, 65535
	strb	wzr, [x0, #:lo12:.LANCHOR46]
	udiv	w0, w19, w28
	msub	w28, w0, w28, w19
	sub	w0, w19, w28
	stp	w0, w1, [x29, 144]
	and	w0, w28, 3
	str	w0, [x29, 180]
	ldr	w0, [x29, 204]
	str	w0, [x29, 160]
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	str	x0, [x29, 112]
.L2176:
	ldr	w0, [x29, 160]
	cmp	w23, w0
	bcc	.L2190
	ldr	x0, [x29, 192]
	ldrb	w1, [x29, 136]
	strb	w1, [x0]
	ldr	w0, [x29, 176]
	cbz	w0, .L2191
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	adrp	x0, .LANCHOR0
	strb	wzr, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LANCHOR19
	strb	wzr, [x0, #:lo12:.LANCHOR19]
.L2191:
	ldr	w0, [x29, 204]
	mov	x2, 0
	lsl	w1, w0, 7
	adrp	x0, .LANCHOR137
	ldr	x0, [x0, #:lo12:.LANCHOR137]
.L2192:
	mov	w20, w2
	cmp	w2, w1
	bcc	.L2193
	ldr	w0, [x29, 184]
	add	w0, w0, 1
	str	w0, [x29, 184]
	cmp	w0, 5
	bls	.L2158
	b	.L2198
.L2199:
	str	wzr, [x29, 176]
	b	.L2151
.L2160:
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	strb	wzr, [x8, #:lo12:.LANCHOR0]
	strb	wzr, [x7, #:lo12:.LANCHOR19]
	b	.L2159
.L2202:
	mov	x21, 0
	str	w26, [x29, 204]
	b	.L2161
.L2175:
	ldr	x2, [x29, 168]
	add	w4, w23, w28
	lsr	w4, w4, 2
	adrp	x0, .LANCHOR3
	add	w1, w4, 1
	add	x0, x0, :lo12:.LANCHOR3
	ldrb	w2, [x2]
	ldrh	w0, [x0, w1, sxtw 1]
	cbz	w2, .L2166
	adrp	x0, .LANCHOR1
	ldrb	w7, [x0, #:lo12:.LANCHOR1]
	lsl	w0, w1, 1
	cmp	w7, 0
	csel	w0, w0, w1, ne
.L2166:
	adrp	x1, .LANCHOR28
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	cmp	w1, 9
	bne	.L2168
.L2249:
	str	w0, [x29, 208]
	mov	w0, 61424
	str	w0, [x29, 212]
	ldr	x0, [x29, 160]
	ldrh	w0, [x0, w4, sxtw 1]
	cbnz	w2, .L2170
	mov	w4, w0
.L2171:
	mul	w0, w22, w4
	cbnz	x21, .L2172
	str	w4, [x29, 148]
	add	x2, x29, 208
	mov	x1, x25
	add	w0, w0, w24
	bl	fw_flash_page_prog.constprop.26
	adrp	x0, .LANCHOR19
	ldr	w4, [x29, 148]
	ldrb	w0, [x0, #:lo12:.LANCHOR19]
	cbnz	w0, .L2173
	udiv	w1, w24, w22
	add	w2, w4, 1
	bl	id_block_prog_msb_ff_data
.L2173:
	ldr	w0, [x29, 204]
	add	x25, x25, 2048
	add	w0, w0, 16
	cmp	w28, w0
	bcc	.L2174
	ldr	w0, [x29, 204]
	add	w1, w0, 20
	add	x0, x27, 2048
	cmp	w28, w1
	csel	x25, x0, x25, cc
.L2174:
	add	w5, w28, 4
	mov	x21, 0
	and	w28, w5, 65535
	b	.L2164
.L2168:
	sub	w0, w0, #1
	lsl	w0, w0, 2
	b	.L2249
.L2170:
	adrp	x0, .LANCHOR1
	ldrb	w1, [x0, #:lo12:.LANCHOR1]
	lsl	w0, w4, 1
	cmp	w1, 0
	csel	w4, w0, w4, ne
	b	.L2171
.L2172:
	add	x2, x29, 208
	mov	x1, x21
	add	w0, w0, w24
	bl	fw_flash_page_prog.constprop.26
	b	.L2174
.L2190:
	add	w20, w28, w23
	ldr	w0, [x29, 180]
	adrp	x1, .LANCHOR19
	sub	w25, w22, w0
	ldr	x0, [x29, 112]
	udiv	w20, w20, w22
	ldrb	w1, [x1, #:lo12:.LANCHOR19]
	and	w25, w25, 65535
	and	w20, w20, 65535
	ldrh	w0, [x0, w20, sxtw 1]
	cbnz	w1, .L2177
	mov	w20, w0
.L2178:
	adrp	x0, .LANCHOR17
	ldr	w1, [x29, 144]
	ldrb	w24, [x0, #:lo12:.LANCHOR17]
	ldr	w0, [x29, 180]
	add	w0, w0, w1
	ldr	w1, [x29, 148]
	madd	w20, w1, w20, w0
	adrp	x0, .LANCHOR31+9
	ldrb	w0, [x0, #:lo12:.LANCHOR31+9]
	udiv	w20, w20, w0
	adrp	x0, .LANCHOR44
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	str	w0, [x29, 132]
	mov	w0, w24
	bl	nandc_bch_sel
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	str	x0, [x29, 120]
.L2179:
	mov	w4, w22
	add	x3, x29, 208
	mov	x2, x21
	mov	w1, w20
	mov	w0, 0
	bl	flash_read_page
	mov	w5, w0
	cmn	w0, #1
	bne	.L2180
	ldr	x0, [x29, 192]
	ldrb	w6, [x0]
	cbnz	w6, .L2181
.L2184:
	adrp	x0, .LANCHOR162
	ldr	x6, [x0, #:lo12:.LANCHOR162]
	cbnz	x6, .L2182
.L2183:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cbz	w0, .L2180
	mov	w4, w22
	add	x3, x29, 208
	mov	x2, x21
	mov	w1, w20
	mov	w0, 0
	bl	flash_ddr_tuning_read
	b	.L2250
.L2177:
	adrp	x0, .LANCHOR1
	ldrb	w1, [x0, #:lo12:.LANCHOR1]
	lsl	w0, w20, 1
	cmp	w1, 0
	csel	w20, w0, w20, ne
	b	.L2178
.L2181:
	ldr	x0, [x29, 192]
	mov	w1, w20
	str	w6, [x29, 108]
	mov	w4, w22
	str	w5, [x29, 128]
	add	x3, x29, 208
	mov	x2, x21
	strb	wzr, [x0]
	mov	w0, 0
	bl	flash_read_page
	cmn	w0, #1
	ldr	x1, [x29, 192]
	ldr	w6, [x29, 108]
	ldr	w5, [x29, 128]
	strb	w6, [x1]
	beq	.L2184
.L2250:
	mov	w5, w0
.L2180:
	cmn	w5, #1
	cset	w3, eq
	cmp	w24, 16
	cset	w0, ne
	tst	w3, w0
	beq	.L2186
	mov	w0, 16
	mov	w24, 16
	bl	nandc_bch_sel
	b	.L2179
.L2182:
	str	w5, [x29, 128]
	mov	w4, w22
	add	x3, x29, 208
	mov	x2, x21
	mov	w1, w20
	mov	w0, 0
	blr	x6
	cmn	w0, #1
	ldr	w5, [x29, 128]
	beq	.L2183
	b	.L2250
.L2186:
	ldr	w0, [x29, 132]
	bl	nandc_bch_sel
	cmp	w3, 0
	ldr	w0, [x29, 168]
	csinv	w0, w0, wzr, eq
	str	w0, [x29, 168]
	ldr	w0, [x29, 144]
	cmp	w23, 0
	ccmp	w19, w0, 0, eq
	bne	.L2188
	ldr	w0, [x29, 168]
	cbnz	w0, .L2188
	ldr	w1, [x21]
	mov	w0, 18766
	movk	w0, 0x464e, lsl 16
	cmp	w1, w0
	bne	.L2188
	ldr	w0, [x29, 160]
	ldrb	w22, [x21, 17]
	add	w0, w0, w25
	str	w0, [x29, 160]
.L2189:
	add	w23, w25, w23
	and	w23, w23, 65535
	b	.L2176
.L2188:
	ubfiz	x0, x25, 9, 16
	str	wzr, [x29, 180]
	add	x21, x21, x0
	b	.L2189
.L2193:
	ldr	w4, [x0, x2, lsl 2]
	add	x2, x2, 1
	add	x3, x27, x2, lsl 2
	ldr	w3, [x3, -4]
	cmp	w4, w3
	beq	.L2192
	mov	w2, 512
	mov	w1, 0
	bl	ftl_memset
	mov	w1, w20
	adrp	x0, .LC131
	add	x0, x0, :lo12:.LC131
	bl	printf
	mov	w1, w19
	mov	w0, 0
	bl	flash_erase_block
.L2158:
	ldr	w0, [x29, 200]
	add	w0, w0, 1
	str	w0, [x29, 200]
	cmp	w0, 4
	bne	.L2195
.L2198:
	ldrb	w1, [x29, 188]
	adrp	x0, .LANCHOR0
	strb	w1, [x0, #:lo12:.LANCHOR0]
	mov	w1, 2
	adrp	x0, .LANCHOR32
	strb	w1, [x0, #:lo12:.LANCHOR32]
	mov	w0, 0
	bl	zftl_flash_enter_slc_mode
	ldr	w0, [x29, 184]
	cbnz	w0, .L2153
	adrp	x0, .LC132
	mov	w1, 0
	add	x0, x0, :lo12:.LC132
	bl	printf
.L2153:
	adrp	x0, .LANCHOR136
	adrp	x19, .LANCHOR135
	str	wzr, [x0, #:lo12:.LANCHOR136]
	ldr	x0, [x19, #:lo12:.LANCHOR135]
	cbz	x0, .L2197
	bl	free
	str	xzr, [x19, #:lo12:.LANCHOR135]
.L2197:
	adrp	x19, .LANCHOR137
	ldr	x0, [x19, #:lo12:.LANCHOR137]
	cbz	x0, .L2251
	bl	free
	str	xzr, [x19, #:lo12:.LANCHOR137]
	b	.L2251
	.size	idb_write_data, .-idb_write_data
	.section	.text.flash_start_tlc_page_prog,"ax",@progbits
	.align	2
	.global	flash_start_tlc_page_prog
	.type	flash_start_tlc_page_prog, %function
flash_start_tlc_page_prog:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	str	x25, [sp, 64]
	and	w25, w0, 255
	adrp	x0, .LANCHOR18
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	and	w19, w3, 255
	stp	x23, x24, [sp, 48]
	and	w21, w1, 255
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	and	w22, w2, 255
	mov	w20, w4
	mov	x23, x5
	mov	x24, x6
	cmp	w0, w19
	bhi	.L2254
	adrp	x1, .LANCHOR170
	adrp	x0, .LC0
	mov	w2, 726
	add	x1, x1, :lo12:.LANCHOR170
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2254:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w4, [x0, w19, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	mov	w0, w4
	bl	nandc_cs
	cbz	w25, .L2255
	sxtw	x0, w4
	add	x0, x0, 8
	add	x0, x19, x0, lsl 8
	str	w25, [x0, 8]
.L2255:
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
	adrp	x0, .LANCHOR31+9
	mov	x3, x24
	mov	x2, x23
	ldrb	w1, [x0, #:lo12:.LANCHOR31+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	ldr	x25, [sp, 64]
	ldp	x23, x24, [sp, 48]
	str	w22, [x19, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	b	nandc_de_cs.constprop.29
	.size	flash_start_tlc_page_prog, .-flash_start_tlc_page_prog
	.section	.text.queue_tlc_prog_cmd,"ax",@progbits
	.align	2
	.type	queue_tlc_prog_cmd, %function
queue_tlc_prog_cmd:
	stp	x29, x30, [sp, -48]!
	mov	w2, 26
	mov	w1, 1
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	x0, [x0]
	ldr	w20, [x0, 40]
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	str	x21, [sp, 32]
	and	w21, w20, 2097151
	ubfx	x20, x20, 21, 3
	mov	w4, w21
	ldrb	w0, [x0, 60]
	mov	w3, w20
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldp	x7, x0, [x19]
	mov	w4, w21
	mov	w3, w20
	mov	w2, 26
	mov	w1, 2
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x0, [x19, 16]
	mov	w4, w21
	ldr	x7, [x19]
	mov	w3, w20
	mov	w2, 16
	mov	w1, 3
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	ldr	x1, [x19]
	mov	w0, 4
	strb	w0, [x1, 58]
	mov	w0, 1
	strb	w0, [x1, 59]
	mov	w0, -1
	strb	w0, [x1]
	adrp	x0, .LANCHOR54
	add	x0, x0, :lo12:.LANCHOR54
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
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
.L2263:
	mov	w1, 1
	mov	w0, w20
	bl	queue_lun_state
	cbnz	w0, .L2264
	mov	x0, x19
	bl	queue_tlc_prog_cmd
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2264:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2263
	.size	sblk_tlc_prog_one_page, .-sblk_tlc_prog_one_page
	.section	.text.sblk_xlc_prog_pages,"ax",@progbits
	.align	2
	.global	sblk_xlc_prog_pages
	.type	sblk_xlc_prog_pages, %function
sblk_xlc_prog_pages:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	x0, [x0]
	stp	x21, x22, [sp, 32]
	mov	x22, x1
	stp	x23, x24, [sp, 48]
	mov	w24, w2
	ldr	w20, [x0, 40]
.L2267:
	mov	w1, 1
	mov	w0, w20
	bl	queue_lun_state
	cbnz	w0, .L2268
	cmp	w24, 2
	bne	.L2269
	ldr	x0, [x19]
	mov	w2, 17
	ldr	x1, [x22]
	ldr	w20, [x0, 40]
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	and	w23, w20, 2097151
	ldrb	w0, [x0, 60]
	ubfx	x20, x20, 21, 3
	mov	w4, w23
	mov	w3, w20
	ldr	w21, [x1, 40]
	mov	w1, 1
	bl	flash_start_tlc_page_prog
	and	w21, w21, 2097151
	bl	nandc_wait_flash_ready
	ldr	x7, [x19]
	mov	w4, w21
	ldr	x0, [x22]
	mov	w3, w20
	mov	w2, 26
	mov	w1, 1
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldp	x7, x0, [x19]
	mov	w4, w23
	mov	w3, w20
	mov	w1, w24
	mov	w2, 17
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x7, [x19]
	mov	w4, w21
	ldr	x0, [x22, 8]
	mov	w3, w20
	mov	w1, w24
	mov	w2, 26
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x7, [x19]
	mov	w4, w23
	ldr	x0, [x19, 16]
	mov	w3, w20
	mov	w2, 17
	mov	w1, 3
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x0, [x22, 16]
	mov	w1, 3
	ldr	x7, [x19]
	mov	w4, w21
	mov	w3, w20
	mov	w2, 16
	ldr	x5, [x0, 8]
	ldr	x6, [x0, 24]
	ldrb	w0, [x7, 60]
	bl	flash_start_tlc_page_prog
	ldr	x1, [x19]
	mov	w0, 5
	strb	w0, [x1, 58]
	mov	w0, 1
	strb	w0, [x1, 59]
	mov	w0, -1
	strb	w0, [x1]
	adrp	x0, .LANCHOR54
	add	x0, x0, :lo12:.LANCHOR54
	bl	buf_add_tail
.L2270:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L2268:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2267
.L2269:
	mov	x0, x19
	bl	queue_tlc_prog_cmd
	b	.L2270
	.size	sblk_xlc_prog_pages, .-sblk_xlc_prog_pages
	.section	.text.sblk_3d_tlc_dump_prog,"ax",@progbits
	.align	2
	.global	sblk_3d_tlc_dump_prog
	.type	sblk_3d_tlc_dump_prog, %function
sblk_3d_tlc_dump_prog:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	adrp	x0, .LC133
	add	x0, x0, :lo12:.LC133
	ldr	w3, [x19, 40]
	str	x21, [sp, 32]
	and	w20, w3, 2097151
	mov	w2, w3
	ubfx	x21, x3, 21, 3
	mov	w1, w20
	bl	printf
	ldr	x5, [x19, 8]
	mov	w4, w20
	ldr	x6, [x19, 24]
	mov	w3, w21
	mov	w2, 26
	mov	w1, 1
	mov	w0, 0
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x5, [x19, 8]
	mov	w4, w20
	ldr	x6, [x19, 24]
	mov	w3, w21
	mov	w2, 26
	mov	w1, 2
	mov	w0, 0
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x5, [x19, 8]
	mov	w4, w20
	ldr	x6, [x19, 24]
	mov	w3, w21
	mov	w2, 16
	mov	w1, 3
	mov	w0, 0
	bl	flash_start_tlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x21, [sp, 32]
	ldr	w0, [x19, 40]
	mov	w1, 64
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
	str	x23, [sp, 48]
	and	w19, w1, 255
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	mov	w20, w2
	mov	x22, x3
	mov	x23, x4
	cmp	w0, w19
	bhi	.L2275
	adrp	x1, .LANCHOR171
	adrp	x0, .LC0
	mov	w2, 756
	add	x1, x1, :lo12:.LANCHOR171
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2275:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w4, [x0, w19, sxtw]
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
	adrp	x0, .LANCHOR31+9
	mov	x3, x23
	mov	x2, x22
	ldrb	w1, [x0, #:lo12:.LANCHOR31+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	ldr	x23, [sp, 48]
	str	w21, [x19, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
	.size	flash_start_3d_mlc_page_prog, .-flash_start_3d_mlc_page_prog
	.section	.text.sblk_3d_mlc_prog_pages,"ax",@progbits
	.align	2
	.global	sblk_3d_mlc_prog_pages
	.type	sblk_3d_mlc_prog_pages, %function
sblk_3d_mlc_prog_pages:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	ldr	x0, [x0]
	ldr	w19, [x0, 40]
	str	x21, [sp, 32]
.L2278:
	mov	w1, 1
	mov	w0, w19
	bl	queue_lun_state
	cbnz	w0, .L2279
	ldr	x0, [x20]
	ldr	w19, [x0, 40]
	and	w21, w19, 2097151
	ubfx	x19, x19, 21, 3
	mov	w0, w19
	bl	zftl_flash_exit_slc_mode
	ldr	x0, [x20]
	mov	w2, w21
	mov	w1, w19
	ldr	x3, [x0, 8]
	ldr	x4, [x0, 24]
	mov	w0, 16
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x0, [x20, 8]
	add	w2, w21, 1
	mov	w1, w19
	ldr	x3, [x0, 8]
	ldr	x4, [x0, 24]
	mov	w0, 16
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_de_cs.constprop.29
	ldr	x1, [x20]
	mov	w0, 4
	strb	w0, [x1, 58]
	mov	w0, 1
	strb	w0, [x1, 59]
	mov	w0, -1
	strb	w0, [x1]
	adrp	x0, .LANCHOR54
	add	x0, x0, :lo12:.LANCHOR54
	bl	buf_add_tail
	ldr	x21, [sp, 32]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L2279:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2278
	.size	sblk_3d_mlc_prog_pages, .-sblk_3d_mlc_prog_pages
	.section	.text.sblk_mlc_dump_prog,"ax",@progbits
	.align	2
	.global	sblk_mlc_dump_prog
	.type	sblk_mlc_dump_prog, %function
sblk_mlc_dump_prog:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	w20, [x0, 40]
	str	x21, [sp, 32]
	and	w21, w20, 2097151
	ubfx	x20, x20, 21, 3
	mov	w0, w20
	bl	zftl_flash_exit_slc_mode
	ldr	w2, [x19, 40]
	mov	w1, w21
	adrp	x0, .LC134
	add	x0, x0, :lo12:.LC134
	add	w3, w2, 1
	bl	printf
	ldr	x3, [x19, 8]
	mov	w2, w21
	ldr	x4, [x19, 24]
	mov	w1, w20
	mov	w0, 16
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	x3, [x19, 8]
	add	w2, w21, 1
	ldr	x4, [x19, 24]
	mov	w1, w20
	mov	w0, 16
	bl	flash_start_3d_mlc_page_prog
	bl	nandc_wait_flash_ready
	ldr	w0, [x19, 40]
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w2, w0
	bl	nandc_de_cs.constprop.29
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
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR18
	stp	x25, x26, [sp, 64]
	and	w24, w0, 255
	stp	x19, x20, [sp, 16]
	mov	x25, x2
	stp	x21, x22, [sp, 32]
	mov	x26, x3
	ldrb	w0, [x23, #:lo12:.LANCHOR18]
	and	w20, w1, 2097151
	str	x27, [sp, 80]
	ubfx	x27, x1, 21, 3
	ubfx	x22, x1, 24, 2
	cmp	w0, w27
	bhi	.L2284
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 803
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2284:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w21, [x0, w27, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	bl	nandc_rdy_status
	cbnz	w0, .L2285
	ldrb	w0, [x23, #:lo12:.LANCHOR18]
	cmp	w0, 1
	bne	.L2286
	bl	nandc_wait_flash_ready
.L2285:
	mov	w0, w21
	bl	hynix_reconfig_rr_para
	mov	w0, w21
	bl	nandc_cs
	cbnz	w22, .L2287
	mov	w0, w20
	bl	slc_phy_page_address_calc
	mov	w20, w0
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L2288
	mov	w0, w21
	bl	zftl_flash_enter_slc_mode
.L2288:
	ubfiz	x21, x21, 8, 8
	mov	w0, 128
	add	x19, x19, x21
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
	adrp	x0, .LANCHOR31+9
	mov	x3, x26
	mov	x2, x25
	ldrb	w1, [x0, #:lo12:.LANCHOR31+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	ldr	x27, [sp, 80]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	str	w24, [x19, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 96
	b	nandc_de_cs.constprop.29
.L2286:
	mov	w2, 64
	mov	w1, w20
	mov	w0, w27
	bl	flash_wait_device_ready_raw
	b	.L2285
.L2287:
	mov	w0, w21
	bl	zftl_flash_exit_slc_mode
	b	.L2288
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
	adrp	x0, .LANCHOR54
	ldr	w3, [x19, 40]
	ldrb	w1, [x0, #:lo12:.LANCHOR54]
	cmp	w1, 255
	beq	.L2294
	adrp	x2, .LANCHOR50
	add	x2, x2, :lo12:.LANCHOR50
	ubfx	x3, x3, 21, 3
	mov	x6, x2
.L2296:
	add	x4, x2, x1, lsl 6
	ldr	w5, [x4, 40]
	ubfx	x5, x5, 21, 3
	cmp	w3, w5
	bne	.L2295
	ldrb	w5, [x4, 58]
	cmp	w5, 7
	bne	.L2295
	mov	w1, 3
	strb	w1, [x4, 58]
.L2294:
	mov	w1, 3
	strb	w1, [x19, 58]
	mov	w1, 1
	strb	w1, [x19, 59]
	mov	w1, -1
	strb	w1, [x19]
	mov	x1, x19
	add	x0, x0, :lo12:.LANCHOR54
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	buf_add_tail
.L2295:
	lsl	x1, x1, 6
	ldrb	w1, [x6, x1]
	cmp	w1, 255
	bne	.L2296
	b	.L2294
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
	str	x27, [sp, 80]
	cbz	w0, .L2303
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L2303
	ldr	w1, [x19, 40]
	adrp	x0, .LC135
	mov	w2, w20
	add	x0, x0, :lo12:.LC135
	bl	printf
.L2303:
	adrp	x25, .LANCHOR39
	adrp	x23, .LANCHOR50
	add	x25, x25, :lo12:.LANCHOR39
	add	x23, x23, :lo12:.LANCHOR50
	mov	w21, 0
	mov	w24, 1
.L2304:
	cbnz	w20, .L2315
.L2328:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2315:
	ldrb	w26, [x19]
	ldr	w22, [x19, 40]
.L2305:
	mov	w1, 1
	mov	w0, w22
	bl	queue_lun_state
	cbnz	w0, .L2306
	cmp	w20, 1
	beq	.L2307
	ldrb	w0, [x25]
	cbnz	w0, .L2308
.L2307:
	mov	x0, x19
	bl	queue_prog_cmd
.L2309:
	subs	w20, w20, #1
	beq	.L2328
	ubfiz	x19, x26, 6, 8
	add	x19, x23, x19
	b	.L2304
.L2306:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2305
.L2308:
	ldrb	w0, [x19]
	ubfx	x27, x22, 21, 3
	cmp	w0, 255
	bne	.L2310
	adrp	x1, .LANCHOR173
	adrp	x0, .LC0
	mov	w2, 583
	add	x1, x1, :lo12:.LANCHOR173
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2310:
	ldrb	w0, [x19]
	add	x0, x23, x0, lsl 6
	ldr	w5, [x0, 40]
	ubfx	x0, x5, 21, 3
	cmp	w27, w0
	bne	.L2311
	adrp	x0, .LANCHOR66
	ldrh	w2, [x0, #:lo12:.LANCHOR66]
	adrp	x0, .LANCHOR67
	ldrb	w3, [x0, #:lo12:.LANCHOR67]
	mov	w0, 21
	sub	w0, w0, w2
	lsl	w1, w24, w2
	sub	w3, w3, #1
	sub	w1, w1, #1
	lsl	w0, w24, w0
	sub	w0, w0, #1
	and	w0, w0, w3
	lsr	w4, w22, w2
	and	w0, w0, 65535
	and	w1, w1, 65535
	and	w4, w0, w4
	lsr	w2, w5, w2
	and	w0, w0, w2
	and	w22, w1, w22
	cmp	w4, w0
	and	w1, w1, w5
	ccmp	w22, w1, 0, ne
	bne	.L2311
	cmp	w21, w3
	beq	.L2311
	ldr	w1, [x19, 40]
	mov	w0, 17
	ldr	x2, [x19, 8]
	add	w21, w21, 1
	ldr	x3, [x19, 24]
	bl	flash_start_page_prog
	strb	w24, [x19, 59]
	mov	w0, 9
	strb	w0, [x19, 58]
	mov	w0, -1
	strb	w0, [x19]
	mov	x1, x19
	adrp	x0, .LANCHOR54
	add	x0, x0, :lo12:.LANCHOR54
	bl	buf_add_tail
	b	.L2309
.L2311:
	mov	x0, x19
	mov	w21, 0
	bl	queue_prog_cmd
	b	.L2309
	.size	sblk_prog_page, .-sblk_prog_page
	.section	.text.ftl_flush,"ax",@progbits
	.align	2
	.global	ftl_flush
	.type	ftl_flush, %function
ftl_flush:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR121
	add	x29, sp, 0
	ldrb	w1, [x0, #:lo12:.LANCHOR121]
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	adrp	x20, .LANCHOR174
	cbz	w1, .L2331
	ldrb	w2, [x20, #:lo12:.LANCHOR174]
	adrp	x0, .LANCHOR50
	add	x0, x0, :lo12:.LANCHOR50
	add	x0, x0, x2, lsl 6
	bl	sblk_prog_page
.L2331:
	mov	w0, -1
	strb	wzr, [x19, #:lo12:.LANCHOR121]
	strb	w0, [x20, #:lo12:.LANCHOR174]
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
	stp	x23, x24, [sp, 48]
	and	w23, w0, 255
	and	w0, w5, 255
	stp	x19, x20, [sp, 16]
	str	w0, [x29, 124]
	adrp	x0, .LANCHOR18
	stp	x21, x22, [sp, 32]
	mov	w20, w1
	stp	x27, x28, [sp, 80]
	mov	x22, x2
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	mov	x21, x3
	stp	x25, x26, [sp, 64]
	mov	w28, w4
	ubfx	x19, x20, 24, 2
	cmp	w0, w23
	bhi	.L2337
	adrp	x1, .LANCHOR175
	adrp	x0, .LC0
	mov	w2, 546
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2337:
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	ldrb	w27, [x0, w23, sxtw]
	cbnz	w19, .L2348
	adrp	x0, .LANCHOR0
	ldrb	w1, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LANCHOR1
	cbz	w1, .L2339
	ldrb	w1, [x0, #:lo12:.LANCHOR1]
	cbz	w1, .L2348
.L2339:
	adrp	x1, .LANCHOR2
	ldrb	w0, [x0, #:lo12:.LANCHOR1]
	ldrh	w1, [x1, #:lo12:.LANCHOR2]
	udiv	w19, w20, w1
	mul	w19, w19, w1
	sub	w1, w20, w19
	cbz	w0, .L2340
	add	w19, w19, w1, lsl 1
.L2338:
	adrp	x24, .LANCHOR14
	adrp	x25, .LC136
	add	x24, x24, :lo12:.LANCHOR14
	add	x25, x25, :lo12:.LC136
	adrp	x26, .LANCHOR163
.L2344:
	ldr	w0, [x24]
	tbz	x0, 4, .L2341
	mov	w3, w19
	mov	w2, w20
	mov	w1, w27
	mov	x0, x25
	bl	printf
.L2341:
	mov	w4, w28
	mov	x3, x21
	mov	x2, x22
	mov	w1, w19
	mov	w0, w27
	bl	flash_prog_page
	mov	w5, w0
	ldr	w0, [x29, 124]
	cbz	w0, .L2342
	adrp	x6, .LANCHOR164
	ldr	x3, [x26, #:lo12:.LANCHOR163]
	mov	w4, w28
	str	x6, [x29, 112]
	ldr	x2, [x6, #:lo12:.LANCHOR164]
	mov	w1, w20
	mov	w0, w23
	str	w5, [x29, 104]
	bl	flash_read_page_en
	cmp	w0, 512
	ldr	x6, [x29, 112]
	mov	w4, w0
	ccmn	w0, #1, 4, ne
	mov	x7, x6
	beq	.L2343
	ldr	x0, [x6, #:lo12:.LANCHOR164]
	ldr	w1, [x22]
	ldr	w5, [x29, 104]
	ldr	w0, [x0]
	cmp	w1, w0
	bne	.L2343
	ldr	x0, [x26, #:lo12:.LANCHOR163]
	ldr	w1, [x21]
	ldr	w0, [x0]
	cmp	w1, w0
	beq	.L2342
.L2343:
	str	w4, [x29, 112]
	mov	w3, 4
	str	x7, [x29, 104]
	mov	w2, w3
	mov	x1, x22
	adrp	x0, .LC137
	add	x0, x0, :lo12:.LC137
	bl	rknand_print_hex
	mov	w3, 4
	mov	x1, x21
	mov	w2, w3
	adrp	x0, .LC138
	add	x0, x0, :lo12:.LC138
	bl	rknand_print_hex
	adrp	x0, .LANCHOR163
	mov	w3, 4
	mov	w2, w3
	ldr	x1, [x0, #:lo12:.LANCHOR163]
	adrp	x0, .LC139
	add	x0, x0, :lo12:.LC139
	bl	rknand_print_hex
	ldr	x7, [x29, 104]
	mov	w3, 4
	adrp	x0, .LC140
	mov	w2, w3
	add	x0, x0, :lo12:.LC140
	ldr	x1, [x7, #:lo12:.LANCHOR164]
	bl	rknand_print_hex
	ldr	w4, [x29, 112]
	cmp	w4, 512
	beq	.L2344
.L2346:
	mov	w1, w20
	adrp	x0, .LC141
	add	x0, x0, :lo12:.LC141
	bl	printf
	mov	w2, 577
	adrp	x1, .LANCHOR175
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC0
	bl	printf
	mov	w0, -1
.L2345:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2340:
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	ldrh	w0, [x0, w1, uxtw 1]
	add	w19, w0, w19
	b	.L2338
.L2348:
	mov	w19, w20
	b	.L2338
.L2342:
	mov	w0, w5
	cmn	w5, #1
	bne	.L2345
	b	.L2346
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
	adrp	x25, .LANCHOR176
	stp	x21, x22, [sp, 32]
	adrp	x26, .LANCHOR104
	and	w21, w0, 65535
	add	x0, x26, :lo12:.LANCHOR104
	stp	x19, x20, [sp, 16]
	mov	w23, 0
	stp	x27, x28, [sp, 80]
	mov	w20, 0
	adrp	x27, .LANCHOR67
	str	x0, [x29, 112]
	str	wzr, [x24, #:lo12:ftl_tmp_buffer]
	add	x0, x27, :lo12:.LANCHOR67
	str	wzr, [x25, #:lo12:.LANCHOR176]
	str	x0, [x29, 96]
.L2365:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cmp	w0, w20
	bls	.L2375
	add	x0, x27, :lo12:.LANCHOR67
	mov	w22, 0
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	str	x0, [x29, 104]
	b	.L2376
.L2374:
	ldr	x0, [x29, 104]
	ldr	w0, [x0]
	tbz	x0, 12, .L2366
	adrp	x0, .LC142
	mov	w1, w21
	add	x0, x0, :lo12:.LC142
	bl	printf
.L2366:
	ldr	x0, [x29, 96]
	ldrb	w19, [x0]
	madd	w19, w21, w19, w22
	and	w19, w19, 65535
	cbnz	w20, .L2367
	adrp	x0, .LANCHOR27
	ldr	x0, [x0, #:lo12:.LANCHOR27]
	ldrb	w0, [x0, 47]
	cmp	w0, w19
	bcs	.L2368
.L2367:
	and	w28, w20, 255
	mov	w1, w19
	mov	w0, w28
	bl	flash_check_bad_block
	cbnz	w0, .L2368
	adrp	x0, .LANCHOR103
	mov	w1, w23
	ldrh	w7, [x0, #:lo12:.LANCHOR103]
	mov	w0, w28
	mul	w26, w7, w19
	mov	w2, w26
	bl	flash_erase_block_en
	cbz	w0, .L2369
	adrp	x0, .LANCHOR71
	ldrb	w0, [x0, #:lo12:.LANCHOR71]
	cmp	w0, 2
	bne	.L2391
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L2391
	mov	w2, w26
	mov	w1, 1
	mov	w0, w28
	bl	flash_erase_block_en
	cbnz	w0, .L2391
.L2373:
	adrp	x0, .LANCHOR71
	mov	w23, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR71]
	add	w26, w26, w0, lsl 24
.L2372:
	adrp	x0, .LANCHOR123
	mov	w5, 1
	add	x3, x25, :lo12:.LANCHOR176
	add	x2, x24, :lo12:ftl_tmp_buffer
	ldrb	w4, [x0, #:lo12:.LANCHOR123]
	mov	w1, w26
	mov	w0, w28
	bl	flash_prog_page_en
	cbz	w0, .L2368
.L2391:
	mov	w1, w19
	mov	w0, w28
	bl	flash_mask_bad_block
.L2368:
	add	w22, w22, 1
	and	w22, w22, 65535
.L2376:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, w22
	bhi	.L2374
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2365
.L2369:
	cbz	w23, .L2372
	b	.L2373
.L2375:
	cbz	w23, .L2377
	adrp	x0, .LANCHOR7
	mov	w1, 2
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x21, x0, x21, uxth 2
	ldrb	w0, [x21, 2]
	bfi	w0, w1, 3, 2
	strb	w0, [x21, 2]
.L2377:
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
	bne	.L2392
	mov	w2, 2231
	adrp	x1, .LANCHOR177
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC0
	bl	printf
	adrp	x0, .LC141
	mov	w1, w20
	add	x0, x0, :lo12:.LC141
	bl	printf
.L2392:
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
	stp	x29, x30, [sp, -112]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR123
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR179
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR103
	stp	x27, x28, [sp, 80]
	mov	x26, x23
	ldrb	w2, [x21, #:lo12:.LANCHOR123]
	add	x25, x22, :lo12:.LANCHOR179
	add	x28, x23, :lo12:.LANCHOR103
	mov	w24, 0
	stp	x19, x20, [sp, 16]
	mov	w27, w0
	adrp	x20, .LANCHOR178
	lsl	w2, w2, 1
	add	x0, x20, :lo12:.LANCHOR178
	bl	ftl_memset
.L2396:
	add	x0, x22, :lo12:.LANCHOR179
	ldrb	w6, [x22, #:lo12:.LANCHOR179]
	ldrh	w19, [x23, #:lo12:.LANCHOR103]
	ldrh	w4, [x0, 2]
	adrp	x0, .LANCHOR102
	ldr	x0, [x0, #:lo12:.LANCHOR102]
	ldr	w3, [x0, 4]
	add	w3, w3, 1
	str	w3, [x0, 4]
	add	x0, x20, :lo12:.LANCHOR178
	str	w27, [x20, #:lo12:.LANCHOR178]
	str	w3, [x0, 4]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2397
	mov	w2, w4
	mov	w1, w6
	str	w4, [x29, 96]
	adrp	x0, .LC143
	str	w6, [x29, 104]
	add	x0, x0, :lo12:.LC143
	bl	printf
	ldr	w4, [x29, 96]
	ldr	w6, [x29, 104]
.L2397:
	adrp	x1, .LANCHOR85
	ldrh	w0, [x25, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR85]
	cmp	w1, w0
	bhi	.L2398
	adrp	x19, .LANCHOR180
	adrp	x3, .LC0
	add	x19, x19, :lo12:.LANCHOR180
	add	x3, x3, :lo12:.LC0
.L2405:
	ldrb	w0, [x25, 1]
	adrp	x4, .LANCHOR27
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x25, 1]
	cmp	w0, 7
	bls	.L2399
	mov	x0, 0
.L2404:
	ldr	x2, [x4, #:lo12:.LANCHOR27]
	add	w1, w0, 8
	and	w24, w0, 65535
	add	x1, x2, x1, sxtw
	ldrb	w2, [x1, 32]
	add	w1, w2, 127
	and	w1, w1, 255
	cmp	w1, 125
	bhi	.L2400
	mov	x0, x3
	stp	x4, x3, [x29, 96]
	mov	w2, 748
	mov	x1, x19
	bl	printf
	ldp	x4, x3, [x29, 96]
.L2403:
	strb	w24, [x25, 1]
	mov	w24, 1
.L2399:
	ldr	x0, [x4, #:lo12:.LANCHOR27]
	ldrb	w1, [x25, 1]
	add	x0, x0, x1
	ldrb	w0, [x0, 40]
	strb	w0, [x25]
	cmp	w0, 255
	beq	.L2405
	ldrh	w19, [x28]
	mul	w19, w19, w0
	mov	w0, 0
	mov	w1, w19
	bl	flash_erase_block
	ldrb	w4, [x21, #:lo12:.LANCHOR123]
	mov	w1, w19
	add	x3, x20, :lo12:.LANCHOR178
	adrp	x2, ftl_info_data_buffer
	mov	w0, 0
	add	x2, x2, :lo12:ftl_info_data_buffer
	add	w19, w19, 1
	bl	ftl_prog_page
	mov	w0, 1
	strh	w0, [x25, 2]
.L2406:
	ldrb	w4, [x21, #:lo12:.LANCHOR123]
	mov	w1, w19
	add	x3, x20, :lo12:.LANCHOR178
	adrp	x2, ftl_info_data_buffer
	mov	w0, 0
	add	x2, x2, :lo12:ftl_info_data_buffer
	bl	ftl_prog_page
	cmn	w0, #1
	ldrh	w1, [x25, 2]
	adrp	x0, .LANCHOR181
	add	w1, w1, 1
	strh	w1, [x25, 2]
	beq	.L2407
	ldrb	w1, [x0, #:lo12:.LANCHOR181]
	cbz	w1, .L2408
.L2407:
	strb	wzr, [x0, #:lo12:.LANCHOR181]
	b	.L2396
.L2400:
	cmp	w2, 255
	bne	.L2403
	add	x0, x0, 1
	cmp	x0, 8
	bne	.L2404
	mov	w24, w0
	b	.L2403
.L2398:
	madd	w19, w19, w6, w4
	cbnz	w0, .L2406
	mov	w1, w19
	bl	flash_erase_block
	b	.L2406
.L2408:
	cbnz	w24, .L2409
.L2417:
	adrp	x0, .LANCHOR179
	ldrb	w0, [x0, #:lo12:.LANCHOR179]
	cmp	w0, 255
	bne	.L2411
	adrp	x1, .LANCHOR180
	adrp	x0, .LC0
	mov	w2, 784
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2411:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2409:
	ldrb	w19, [x25, 1]
	adrp	x20, .LANCHOR180
	adrp	x21, .LC0
	add	x20, x20, :lo12:.LANCHOR180
	add	w19, w19, 1
	add	x21, x21, :lo12:.LC0
	adrp	x22, .LANCHOR27
.L2412:
	cmp	w19, 7
	bhi	.L2417
	ldr	x1, [x22, #:lo12:.LANCHOR27]
	add	w0, w19, 8
	add	x0, x1, x0, sxtw
	ldrb	w23, [x0, 32]
	add	w0, w23, 127
	and	w0, w0, 255
	cmp	w0, 125
	bhi	.L2413
	mov	w2, 777
	mov	x1, x20
	mov	x0, x21
	bl	printf
.L2414:
	ldrh	w1, [x26, #:lo12:.LANCHOR103]
	mov	w0, 0
	mul	w1, w1, w23
	bl	flash_erase_block
	b	.L2415
.L2413:
	cmp	w23, 255
	bne	.L2414
.L2415:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2412
	.size	ftl_info_flush, .-ftl_info_flush
	.section	.text.ftl_info_blk_init,"ax",@progbits
	.align	2
	.global	ftl_info_blk_init
	.type	ftl_info_blk_init, %function
ftl_info_blk_init:
	stp	x29, x30, [sp, -128]!
	adrp	x0, .LANCHOR182
	adrp	x1, .LANCHOR181
	mov	w2, 16384
	add	x29, sp, 0
	strb	wzr, [x0, #:lo12:.LANCHOR182]
	mov	w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR181]
	adrp	x1, .LANCHOR183
	stp	x19, x20, [sp, 16]
	adrp	x20, ftl_info_data_buffer
	strb	w0, [x1, #:lo12:.LANCHOR183]
	adrp	x1, .LANCHOR7
	add	x0, x20, :lo12:ftl_info_data_buffer
	stp	x21, x22, [sp, 32]
	str	x0, [x1, #:lo12:.LANCHOR7]
	adrp	x1, .LANCHOR6
	adrp	x21, .LANCHOR102
	stp	x23, x24, [sp, 48]
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	adrp	x24, .LANCHOR27
	stp	x25, x26, [sp, 64]
	adrp	x22, .LANCHOR179
	stp	x27, x28, [sp, 80]
	adrp	x26, .LANCHOR103
	add	x1, x0, x1, lsl 2
	str	x1, [x21, #:lo12:.LANCHOR102]
	mov	w1, 0
	bl	ftl_memset
	mov	w1, 0
	mov	w2, 16384
	adrp	x0, ftl_ext_info_data_buffer
	add	x0, x0, :lo12:ftl_ext_info_data_buffer
	bl	ftl_memset
	adrp	x23, .LANCHOR123
	ldr	x1, [x24, #:lo12:.LANCHOR27]
	add	x0, x22, :lo12:.LANCHOR179
	mov	w27, 21574
	add	x26, x26, :lo12:.LANCHOR103
	add	x23, x23, :lo12:.LANCHOR123
	mov	x19, 7
	strb	wzr, [x0, 1]
	movk	w27, 0x494c, lsl 16
	ldrb	w1, [x1, 40]
	strb	w1, [x22, #:lo12:.LANCHOR179]
	strh	wzr, [x0, 2]
.L2433:
	ldr	x1, [x24, #:lo12:.LANCHOR27]
	add	w0, w19, 8
	sxth	w25, w19
	mov	w28, w19
	add	x0, x1, x0, sxtw
	ldrb	w0, [x0, 32]
	cmp	w0, 255
	bne	.L2432
.L2437:
	sub	x19, x19, #1
	cmn	x19, #1
	bne	.L2433
	mov	w25, 0
.L2434:
	adrp	x23, .LANCHOR14
	ldr	w0, [x23, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2438
	ldr	x0, [x21, #:lo12:.LANCHOR102]
	mov	w2, 4800
	mov	w1, w19
	ldr	w3, [x0]
	adrp	x0, .LC145
	add	x0, x0, :lo12:.LC145
	bl	printf
.L2438:
	cmn	w19, #1
	bne	.L2439
	mov	w1, 0
	mov	w2, 16384
	add	x0, x20, :lo12:ftl_info_data_buffer
	bl	ftl_memset
	ldr	x0, [x21, #:lo12:.LANCHOR102]
	mov	w1, 21574
	movk	w1, 0x494c, lsl 16
	str	w1, [x0]
	mov	w1, 22
	movk	w1, 0x6, lsl 16
	str	w1, [x0, 12]
	mov	w0, w19
.L2431:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2432:
	ldrh	w6, [x26]
	add	x8, x20, :lo12:ftl_info_data_buffer
	ldrb	w4, [x23]
	adrp	x7, .LANCHOR178
	add	x7, x7, :lo12:.LANCHOR178
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
	bne	.L2435
	ldrb	w4, [x23]
	mov	x3, x7
	mov	x2, x8
	add	w1, w6, 1
	mov	w0, 0
	bl	ftl_read_page
	mov	w5, w0
.L2435:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2436
	ldr	x0, [x21, #:lo12:.LANCHOR102]
	mov	w2, w5
	str	w5, [x29, 124]
	mov	w3, 672
	mov	w1, w28
	ldr	w4, [x0]
	adrp	x0, .LC144
	add	x0, x0, :lo12:.LC144
	bl	printf
	ldr	w5, [x29, 124]
.L2436:
	cmn	w5, #1
	beq	.L2437
	ldr	x0, [x21, #:lo12:.LANCHOR102]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L2437
	mov	w19, w25
	b	.L2434
.L2439:
	ldr	x1, [x24, #:lo12:.LANCHOR27]
	add	w0, w25, 8
	add	x20, x20, :lo12:ftl_info_data_buffer
	mov	w4, 4
	mov	x2, x20
	adrp	x27, .LANCHOR123
	add	x0, x1, x0, sxtw
	mov	w28, 21574
	add	x27, x27, :lo12:.LANCHOR123
	movk	w28, 0x494c, lsl 16
	ldrb	w1, [x0, 32]
	add	x0, x22, :lo12:.LANCHOR179
	strb	w1, [x22, #:lo12:.LANCHOR179]
	strb	w25, [x0, 1]
	adrp	x25, .LANCHOR178
	add	x25, x25, :lo12:.LANCHOR178
	mov	w0, 0
	mov	x3, x25
	bl	flash_get_last_written_page
	sxth	w24, w0
	add	w0, w0, 1
	and	w19, w0, 65535
	adrp	x0, .LANCHOR103
	ldrb	w26, [x22, #:lo12:.LANCHOR179]
	ldrh	w0, [x0, #:lo12:.LANCHOR103]
	madd	w26, w26, w0, w24
.L2441:
	tbnz	w24, #31, .L2445
	ldrb	w4, [x27]
	mov	x3, x25
	mov	x2, x20
	mov	w1, w26
	mov	w0, 0
	bl	ftl_read_page
	cmn	w0, #1
	beq	.L2442
	ldr	x0, [x21, #:lo12:.LANCHOR102]
	ldr	w0, [x0]
	cmp	w0, w28
	bne	.L2442
.L2445:
	add	x22, x22, :lo12:.LANCHOR179
	strh	w19, [x22, 2]
	bl	ftl_tmp_into_update
	ldr	x1, [x21, #:lo12:.LANCHOR102]
	ldr	w0, [x1, 64]
	add	w0, w0, 1
	str	w0, [x1, 64]
	mov	w0, 0
	bl	ftl_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	ldr	w0, [x23, #:lo12:.LANCHOR14]
	tbnz	x0, 14, .L2443
.L2460:
	mov	w0, 0
	b	.L2431
.L2442:
	sub	w24, w24, #1
	sub	w26, w26, #1
	sxth	w24, w24
	b	.L2441
.L2443:
	ldr	x0, [x21, #:lo12:.LANCHOR102]
	ldr	w1, [x0, 156]
	adrp	x0, .LC146
	add	x0, x0, :lo12:.LC146
	bl	printf
	b	.L2460
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
	cbz	w1, .L2462
	str	wzr, [x0, 520]
.L2462:
	adrp	x20, .LANCHOR85
	adrp	x22, .LANCHOR184
	adrp	x21, .LANCHOR66
	add	x20, x20, :lo12:.LANCHOR85
	add	x22, x22, :lo12:.LANCHOR184
	add	x21, x21, :lo12:.LANCHOR66
	mov	w0, 0
	bl	ftl_total_vpn_update
.L2463:
	adrp	x23, .LANCHOR102
	mov	x24, x23
.L2466:
	ldr	x0, [x23, #:lo12:.LANCHOR102]
	ldr	w1, [x0, 56]
	add	w1, w1, 1
	str	w1, [x0, 56]
	ldrh	w1, [x0, 140]
	ldrh	w0, [x20]
	cmp	w1, w0
	bcc	.L2464
	bl	ftl_ext_alloc_new_blk
.L2464:
	ldr	x0, [x24, #:lo12:.LANCHOR102]
	ldrh	w1, [x0, 130]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2465
	adrp	x0, .LC0
	mov	w2, 1819
	mov	x1, x22
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2465:
	ldr	x1, [x24, #:lo12:.LANCHOR102]
	mov	w19, 21
	ldrh	w0, [x21]
	adrp	x26, .LANCHOR123
	adrp	x27, .LANCHOR178
	add	x25, x27, :lo12:.LANCHOR178
	sub	w0, w19, w0
	mov	w19, 1
	ldrh	w2, [x1, 130]
	lsl	w19, w19, w0
	sub	w19, w19, #1
	and	w19, w19, w2
	asr	w28, w2, w0
	adrp	x0, .LANCHOR103
	ldrh	w2, [x0, #:lo12:.LANCHOR103]
	ldrh	w0, [x1, 140]
	mov	w1, 0
	madd	w19, w19, w2, w0
	ldrb	w2, [x26, #:lo12:.LANCHOR123]
	mov	x0, x25
	and	w19, w19, 65535
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x0, [x24, #:lo12:.LANCHOR102]
	mov	w1, w19
	ldrb	w4, [x26, #:lo12:.LANCHOR123]
	mov	x3, x25
	str	wzr, [x27, #:lo12:.LANCHOR178]
	adrp	x2, ftl_ext_info_data_buffer
	add	x2, x2, :lo12:ftl_ext_info_data_buffer
	ldr	w0, [x0, 56]
	str	w0, [x25, 4]
	mov	w0, w28
	bl	ftl_prog_page
	ldr	x2, [x24, #:lo12:.LANCHOR102]
	ldrh	w1, [x2, 140]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 140]
	cmp	w1, 1
	beq	.L2466
	cmn	w0, #1
	adrp	x0, .LANCHOR183
	beq	.L2467
	ldrb	w1, [x0, #:lo12:.LANCHOR183]
	cbz	w1, .L2468
.L2467:
	strb	wzr, [x0, #:lo12:.LANCHOR183]
	b	.L2463
.L2468:
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
	adrp	x0, .LANCHOR113
	mov	w4, 4
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR102
	strh	wzr, [x0, #:lo12:.LANCHOR113]
	mov	w19, 21
	ldr	x0, [x20, #:lo12:.LANCHOR102]
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR178
	ldrh	w1, [x0, 130]
	adrp	x0, .LANCHOR66
	stp	x25, x26, [sp, 64]
	add	x3, x24, :lo12:.LANCHOR178
	ldrh	w0, [x0, #:lo12:.LANCHOR66]
	adrp	x25, ftl_ext_info_data_buffer
	add	x2, x25, :lo12:ftl_ext_info_data_buffer
	sub	w0, w19, w0
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
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2479
	ldr	x0, [x20, #:lo12:.LANCHOR102]
	adrp	x1, .LANCHOR185
	and	w4, w21, 65535
	mov	w3, w22
	mov	w2, 1863
	add	x1, x1, :lo12:.LANCHOR185
	ldrh	w5, [x0, 130]
	adrp	x0, .LC147
	add	x0, x0, :lo12:.LC147
	bl	printf
.L2479:
	adrp	x26, .LANCHOR123
	adrp	x28, .LANCHOR103
	mov	w5, 20038
	add	x26, x26, :lo12:.LANCHOR123
	add	x28, x28, :lo12:.LANCHOR103
	mov	w23, 0
	movk	w5, 0x4549, lsl 16
.L2480:
	and	w21, w22, 65535
	sub	w0, w21, w23
	tbnz	x0, 15, .L2485
	ldrh	w0, [x28]
	sub	w1, w22, w23
	ldrb	w4, [x26]
	add	x3, x24, :lo12:.LANCHOR178
	str	w5, [x29, 108]
	add	x2, x25, :lo12:ftl_ext_info_data_buffer
	madd	w1, w0, w19, w1
	mov	w0, w27
	bl	flash_read_page_en
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	ldr	w5, [x29, 108]
	beq	.L2481
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x0]
	cmp	w0, w5
	bne	.L2481
.L2485:
	bl	zftl_sblk_list_init
	ldr	x0, [x20, #:lo12:.LANCHOR102]
	ldrh	w1, [x0, 140]
	cmp	w1, w22
	bgt	.L2483
	add	w21, w21, 1
	strh	w21, [x0, 140]
	bl	ftl_ext_info_flush
.L2483:
	adrp	x0, .LANCHOR10
	mov	w1, -1
	ldp	x19, x20, [sp, 16]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	strh	w1, [x0, 584]
	strh	w1, [x0, 586]
	strh	w1, [x0, 588]
	strh	w1, [x0, 590]
	mov	w1, 65535
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	str	w1, [x0, 560]
	str	wzr, [x0, 520]
	mov	w1, -1
	str	wzr, [x0, 604]
	str	wzr, [x0, 608]
	str	w1, [x0, 564]
	adrp	x0, .LANCHOR64
	strh	w1, [x0, #:lo12:.LANCHOR64]
	mov	w0, 0
	ldp	x29, x30, [sp], 112
	ret
.L2481:
	add	w23, w23, 1
	b	.L2480
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
	adrp	x19, .LANCHOR102
	mov	w0, 1
	bl	ftl_alloc_sblk
	mov	w1, 0
	mov	w21, w0
	bl	ftl_erase_sblk
	ldr	x1, [x19, #:lo12:.LANCHOR102]
	mov	w0, w21
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	ldrh	w20, [x0, 672]
	strh	wzr, [x0, 690]
	mov	w0, 65533
	sub	w1, w20, #1
	cmp	w0, w1, uxth
	bcs	.L2494
	adrp	x1, .LANCHOR186
	adrp	x0, .LC0
	mov	w2, 2053
	add	x1, x1, :lo12:.LANCHOR186
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2494:
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	mov	w2, 256
	mov	w1, 255
	add	x0, x0, 416
	strh	wzr, [x0, 280]
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	mov	w2, 4096
	mov	w1, 0
	add	x0, x0, 704
	bl	ftl_memset
	adrp	x1, .LANCHOR66
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	ldrh	w2, [x1, #:lo12:.LANCHOR66]
	mov	w1, 21
	sub	w1, w1, w2
	strh	w21, [x0, 416]
	adrp	x21, .LANCHOR10
	strh	w20, [x0, 692]
	asr	w1, w20, w1
	strh	w1, [x0, 694]
	mov	w1, 1
	strh	w1, [x0, 688]
	adrp	x1, .LANCHOR187
	ldrh	w1, [x1, #:lo12:.LANCHOR187]
	strh	w1, [x0, 698]
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	mov	w1, 20038
	movk	w1, 0x4549, lsl 16
	str	w1, [x0]
	bl	ftl_alloc_sys_blk
	mov	w20, w0
	mov	w1, 0
	bl	ftl_erase_phy_blk
	ldr	x0, [x19, #:lo12:.LANCHOR102]
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
	ldr	x1, [x19, #:lo12:.LANCHOR102]
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
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	mov	w2, 128
	mov	w1, 255
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
	adrp	x0, .LC148
	add	x0, x0, :lo12:.LC148
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR188
	stp	x21, x22, [sp, 32]
	add	x20, x20, :lo12:.LANCHOR188
	stp	x25, x26, [sp, 64]
	adrp	x22, .LANCHOR27
	mov	x25, x22
	stp	x23, x24, [sp, 48]
	mov	w19, 8
	adrp	x23, .LC0
	bl	printf
.L2499:
	ldr	x0, [x22, #:lo12:.LANCHOR27]
	add	x0, x0, x19, sxtw
	ldrb	w21, [x0, 32]
	add	w0, w21, 127
	and	w0, w0, 255
	cmp	w0, 125
	bhi	.L2497
	mov	w2, 2107
	mov	x1, x20
	add	x0, x23, :lo12:.LC0
	bl	printf
.L2497:
	cmp	w21, 255
	beq	.L2498
	adrp	x0, .LANCHOR103
	ldrh	w1, [x0, #:lo12:.LANCHOR103]
	mov	w0, 0
	mul	w1, w1, w21
	bl	flash_erase_block
.L2498:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L2499
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
.L2500:
	cmp	x0, x2
	bne	.L2501
	adrp	x21, .LANCHOR102
	mov	w1, 21574
	adrp	x24, .LANCHOR60
	add	x24, x24, :lo12:.LANCHOR60
	ldr	x0, [x21, #:lo12:.LANCHOR102]
	movk	w1, 0x494c, lsl 16
	mov	w20, 0
	mov	w26, 1
	strh	wzr, [x0, 148]
	str	w1, [x0]
.L2502:
	ldrh	w0, [x19, #:lo12:.LANCHOR6]
	adrp	x23, .LANCHOR67
	cmp	w0, w20
	bhi	.L2511
	ldr	x0, [x25, #:lo12:.LANCHOR27]
	mov	w4, 3
	ldrb	w2, [x23, #:lo12:.LANCHOR67]
	mov	w10, 15
	ldr	x6, [x21, #:lo12:.LANCHOR102]
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
.L2514:
	cmp	w2, 4
	add	x1, x1, 4
	csel	w7, w10, w4, eq
	strb	w7, [x1, -1]
	ldrb	w7, [x1, -2]
	orr	w7, w7, -32
	strb	w7, [x1, -2]
	cmp	x1, x0
	bne	.L2514
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
	tbz	x0, 12, .L2515
	adrp	x0, .LC149
	mov	w3, w20
	mov	w2, 128
	mov	w1, 2154
	add	x0, x0, :lo12:.LC149
	bl	printf
.L2515:
	ldr	x0, [x21, #:lo12:.LANCHOR102]
	mov	w2, 128
	mov	w1, 255
	add	x0, x0, 160
	bl	ftl_memset
	adrp	x0, .LANCHOR104
	ldrb	w13, [x23, #:lo12:.LANCHOR67]
	ldr	x2, [x21, #:lo12:.LANCHOR102]
	mov	w4, 21
	ldrb	w15, [x0, #:lo12:.LANCHOR104]
	adrp	x0, .LANCHOR66
	and	w16, w13, 65535
	ldr	x14, [x22, #:lo12:.LANCHOR7]
	ldrh	w0, [x0, #:lo12:.LANCHOR66]
	mov	w3, 0
	ldrh	w12, [x2, 134]
	sub	w0, w4, w0
	mul	w1, w20, w16
	mov	w4, 1
	lsl	w4, w4, w0
	and	w1, w1, 65535
	and	w4, w4, 65535
.L2516:
	cmp	w20, w12
	bcc	.L2522
	ldrh	w0, [x19, #:lo12:.LANCHOR6]
	strh	w3, [x2, 112]
	sub	w0, w0, w12
	strh	wzr, [x2, 114]
	strh	w0, [x2, 116]
	strh	wzr, [x2, 118]
	strh	w12, [x2, 132]
	bl	ftl_low_format_data_init
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2501:
	ldrb	w1, [x0, 2]
	add	x0, x0, 4
	and	w1, w1, 31
	bfi	w1, w3, 3, 2
	strb	w1, [x0, -2]
	b	.L2500
.L2511:
	adrp	x0, .LANCHOR73
	strh	w20, [x24]
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	cbnz	w0, .L2503
	mov	w0, w20
	bl	ftl_test_block
.L2503:
	ldrb	w11, [x23, #:lo12:.LANCHOR67]
	adrp	x0, .LANCHOR104
	ldr	x6, [x22, #:lo12:.LANCHOR7]
	mov	w7, 0
	ldrb	w14, [x0, #:lo12:.LANCHOR104]
	mov	w10, 0
	ldr	x13, [x21, #:lo12:.LANCHOR102]
	mov	w8, 0
	mul	w12, w20, w11
	add	x6, x6, x20, uxth 2
.L2504:
	cmp	w8, w14
	bcs	.L2508
	add	w15, w11, w7
	b	.L2509
.L2507:
	add	w1, w7, w12
	mov	w0, w8
	bl	flash_check_bad_block
	cbz	w0, .L2505
	ldrb	w1, [x6, 3]
	lsl	w0, w26, w7
	orr	w0, w0, w1
	strb	w0, [x6, 3]
	ldrh	w0, [x13, 148]
	add	w0, w0, 1
	strh	w0, [x13, 148]
.L2506:
	add	w7, w7, 1
.L2509:
	cmp	w7, w15
	bne	.L2507
	add	w8, w8, 1
	sub	w12, w12, w11
	and	w8, w8, 65535
	b	.L2504
.L2505:
	add	w10, w10, 1
	and	w10, w10, 65535
	b	.L2506
.L2508:
	cbnz	w10, .L2510
	ldrb	w0, [x6, 2]
	orr	w0, w0, -32
	strb	w0, [x6, 2]
.L2510:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2502
.L2522:
	add	x10, x14, x20, uxth 2
	mov	w6, 0
	mov	w8, 0
	mov	w5, 0
	ldrb	w0, [x10, 2]
	orr	w0, w0, -32
	strb	w0, [x10, 2]
.L2517:
	cmp	w5, w15
	bcc	.L2524
	add	w20, w20, 1
	add	w1, w1, w16
	and	w20, w20, 65535
	and	w1, w1, 65535
	b	.L2516
.L2520:
	ldrb	w11, [x10, 3]
	add	w17, w8, w7
	asr	w11, w11, w17
	tbnz	x11, 0, .L2518
	cmp	w13, 1
	bls	.L2523
	and	w0, w0, 1
	add	w0, w1, w0
	and	w0, w0, 65535
.L2519:
	add	x11, x2, x3, sxtw 1
	add	w3, w3, 1
	and	w3, w3, 65535
	add	w0, w0, w6
	strh	w0, [x11, 160]
.L2518:
	add	x7, x7, 1
.L2521:
	and	w0, w7, 65535
	cmp	w0, w16
	bcc	.L2520
	add	w5, w5, 1
	add	w6, w4, w6
	and	w5, w5, 65535
	add	w8, w8, w13
	and	w6, w6, 65535
	b	.L2517
.L2523:
	mov	w0, w1
	b	.L2519
.L2524:
	mov	x7, 0
	b	.L2521
	.size	ftl_low_format, .-ftl_low_format
	.section	.text.ftl_re_low_format,"ax",@progbits
	.align	2
	.global	ftl_re_low_format
	.type	ftl_re_low_format, %function
ftl_re_low_format:
	stp	x29, x30, [sp, -16]!
	mov	w1, 1
	adrp	x0, .LC150
	add	x0, x0, :lo12:.LC150
	add	x29, sp, 0
	bl	printf
	bl	sblk_init
	bl	ftl_info_blk_init
	bl	ftl_ext_info_init
	adrp	x0, .LANCHOR102
	adrp	x2, .LANCHOR6
	mov	w3, 0
	mov	w4, 0
	ldr	x0, [x0, #:lo12:.LANCHOR102]
	mov	w5, 0
	ldrh	w7, [x2, #:lo12:.LANCHOR6]
	adrp	x2, .LANCHOR7
	ldr	x2, [x2, #:lo12:.LANCHOR7]
	ldrh	w1, [x0, 134]
	add	x2, x2, x1, uxth 2
.L2535:
	cmp	w1, w7
	bcc	.L2539
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
.L2539:
	ldrb	w6, [x2, 2]
	and	w8, w6, 31
	strb	w8, [x2, 2]
	ands	w6, w6, 24
	bne	.L2536
	add	w5, w5, 1
	and	w5, w5, 65535
.L2537:
	add	w1, w1, 1
	add	x2, x2, 4
	and	w1, w1, 65535
	b	.L2535
.L2536:
	cmp	w6, 16
	bne	.L2538
	add	w4, w4, 1
	and	w4, w4, 65535
	b	.L2537
.L2538:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L2537
	.size	ftl_re_low_format, .-ftl_re_low_format
	.section	.text.ftl_prog_ppa_page,"ax",@progbits
	.align	2
	.global	ftl_prog_ppa_page
	.type	ftl_prog_ppa_page, %function
ftl_prog_ppa_page:
	ubfx	x5, x0, 21, 3
	mov	w4, w3
	mov	x3, x2
	mov	x2, x1
	and	w1, w0, 2097151
	mov	w0, w5
	b	ftl_prog_page
	.size	ftl_prog_ppa_page, .-ftl_prog_ppa_page
	.section	.text.ftl_write_last_log_page,"ax",@progbits
	.align	2
	.global	ftl_write_last_log_page
	.type	ftl_write_last_log_page, %function
ftl_write_last_log_page:
	ldrh	w1, [x0, 6]
	cmp	w1, 1
	bne	.L2544
	stp	x29, x30, [sp, -48]!
	adrp	x1, .LANCHOR109
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	ldr	x20, [x1, #:lo12:.LANCHOR109]
	ldrh	w22, [x0, 12]
	bl	ftl_get_new_free_page
	mov	w21, w0
	cmn	w0, #1
	beq	.L2545
	ldrh	w0, [x19]
	add	x20, x20, x22, uxth 2
	bl	ftl_vpn_decrement
	adrp	x0, .LANCHOR176
	mov	w1, 15555
	add	x6, x0, :lo12:.LANCHOR176
	movk	w1, 0xf55f, lsl 16
	str	w1, [x0, #:lo12:.LANCHOR176]
	adrp	x0, .LANCHOR85
	ldrh	w1, [x0, #:lo12:.LANCHOR85]
	adrp	x0, .LANCHOR78
	ldrb	w0, [x0, #:lo12:.LANCHOR78]
	mul	w1, w1, w0
	mov	x0, x20
	lsl	w1, w1, 2
	bl	js_hash
	stp	w0, wzr, [x6, 4]
	adrp	x0, .LANCHOR123
	mov	x2, x6
	mov	x1, x20
	ldrb	w3, [x0, #:lo12:.LANCHOR123]
	mov	w0, w21
	str	wzr, [x6, 12]
	bl	ftl_prog_ppa_page
.L2545:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L2544:
	mov	w0, -1
	ret
	.size	ftl_write_last_log_page, .-ftl_write_last_log_page
	.section	.text.ftl_open_sblk_recovery,"ax",@progbits
	.align	2
	.global	ftl_open_sblk_recovery
	.type	ftl_open_sblk_recovery, %function
ftl_open_sblk_recovery:
	stp	x29, x30, [sp, -224]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR14
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	stp	x25, x26, [sp, 64]
	mov	x25, x1
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	tbz	x0, 12, .L2551
	ldrh	w1, [x19, 2]
	adrp	x0, .LC151
	add	x0, x0, :lo12:.LC151
	bl	printf
.L2551:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2552
	ldrb	w1, [x19, 5]
	adrp	x0, .LC152
	add	x0, x0, :lo12:.LC152
	bl	printf
.L2552:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2553
	ldrh	w1, [x19]
	adrp	x0, .LC153
	add	x0, x0, :lo12:.LC153
	bl	printf
.L2553:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2554
	ldrh	w2, [x19, 18]
	adrp	x0, .LC154
	ldrh	w1, [x19, 16]
	add	x0, x0, :lo12:.LC154
	bl	printf
.L2554:
	ldrh	w0, [x19, 10]
	strh	w0, [x19, 14]
	adrp	x0, .LANCHOR6
	ldrh	w1, [x19]
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w1, w0
	bcs	.L2550
	mov	w0, 1
	add	x26, x29, 160
	bl	buf_alloc
	mov	x20, x0
	mov	w2, 64
	mov	w1, 255
	mov	x0, x26
	bl	ftl_memset
	ldrb	w22, [x19, 5]
	adrp	x0, .LANCHOR123
	ldrh	w23, [x19, 2]
	add	x0, x0, :lo12:.LANCHOR123
	mov	w27, 2
	adrp	x24, .LANCHOR85
	str	x0, [x29, 128]
	str	wzr, [x29, 152]
.L2556:
	ldrh	w0, [x24, #:lo12:.LANCHOR85]
	cmp	w0, w23
	bhi	.L2569
.L2559:
	ldrh	w0, [x19, 10]
	ldrh	w1, [x19, 6]
	ldrh	w2, [x24, #:lo12:.LANCHOR85]
	add	w1, w1, w0
	ldrb	w0, [x19, 9]
	strh	w23, [x19, 2]
	strb	w22, [x19, 5]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L2570
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 1493
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2570:
	adrp	x2, .LANCHOR109
	ldrh	w3, [x19, 10]
	mov	w0, 0
	mov	w1, 0
	ldr	x4, [x2, #:lo12:.LANCHOR109]
	str	x2, [x29, 136]
.L2571:
	cmp	w1, w3
	bcc	.L2573
	ldrb	w22, [x19, 9]
	adrp	x23, .LANCHOR9
	ldrh	w1, [x24, #:lo12:.LANCHOR85]
	madd	w22, w22, w1, w0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	sub	w22, w22, w3
	and	w22, w22, 65535
	tbz	x0, 12, .L2574
	ldrh	w1, [x19]
	ldr	x2, [x23, #:lo12:.LANCHOR9]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC155
	mov	w2, w22
	add	x0, x0, :lo12:.LC155
	bl	printf
.L2574:
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	ldrh	w1, [x19]
	strh	w22, [x0, x1, lsl 1]
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 14, .L2575
	ldp	w1, w2, [x29, 160]
	adrp	x0, .LC156
	ldp	w3, w4, [x29, 168]
	add	x0, x0, :lo12:.LC156
	bl	printf
.L2575:
	adrp	x25, .LANCHOR123
	ldr	x0, [x20, 8]
	mov	w1, 0
	mov	x23, 0
	ldrb	w2, [x25, #:lo12:.LANCHOR123]
	lsl	w2, w2, 9
	bl	ftl_memset
	adrp	x0, .LC158
	add	x0, x0, :lo12:.LC158
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR78
	add	x0, x0, :lo12:.LANCHOR78
	str	x0, [x29, 112]
.L2576:
	adrp	x0, .LANCHOR78
	str	w23, [x29, 148]
	ldrb	w0, [x0, #:lo12:.LANCHOR78]
	mul	w0, w0, w27
	cmp	w23, w0
	bcc	.L2589
	mov	x0, x20
	bl	buf_free
	ldrh	w1, [x19, 12]
	ldrh	w0, [x24, #:lo12:.LANCHOR85]
	ldrb	w2, [x19, 9]
	madd	w0, w0, w2, w1
	mov	x1, -4
	add	x0, x1, x0, sxtw 2
	ldr	x1, [x29, 136]
	ldr	x1, [x1, #:lo12:.LANCHOR109]
	ldr	w0, [x1, x0]
	cmn	w0, #1
	beq	.L2590
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 1567
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2590:
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bne	.L2550
	mov	x0, x19
	bl	ftl_write_last_log_page
.L2550:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 224
	ret
.L2569:
	ldrb	w22, [x19, 5]
	adrp	x0, .LANCHOR103
	add	x0, x0, :lo12:.LANCHOR103
	str	x0, [x29, 136]
.L2557:
	ldrb	w0, [x19, 9]
	cmp	w0, w22
	bhi	.L2568
	add	w23, w23, 1
	strb	wzr, [x19, 5]
	and	w23, w23, 65535
	b	.L2556
.L2568:
	add	x0, x19, x22, sxtw 1
	mov	w1, 65535
	ldrh	w0, [x0, 16]
	cmp	w0, w1
	beq	.L2558
	ldr	x1, [x29, 136]
	ldr	x2, [x20, 24]
	ldrh	w1, [x1]
	madd	w0, w1, w0, w23
	ldr	x1, [x20, 8]
	str	w0, [x29, 148]
	adrp	x0, .LANCHOR123
	ldrb	w3, [x0, #:lo12:.LANCHOR123]
	ldr	w0, [x29, 148]
	bl	ftl_read_ppa_page
	mov	w28, w0
	cmp	w0, 512
	beq	.L2559
	cmn	w0, #1
	beq	.L2560
	ldr	x0, [x20, 24]
	ldr	w1, [x0]
	cmn	w1, #1
	bne	.L2560
	ldr	w0, [x0, 4]
	cmn	w0, #1
	bne	.L2560
	ldr	x0, [x20, 8]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L2559
.L2560:
	adrp	x0, .LANCHOR182
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR182]
	ldrb	w0, [x19, 9]
	ldrh	w1, [x19, 10]
	madd	w0, w0, w23, w22
	cmp	w1, w0
	beq	.L2561
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 1412
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2561:
	ldrh	w0, [x19, 10]
	ldrh	w1, [x19, 6]
	ldrb	w2, [x19, 9]
	add	w1, w1, w0
	ldrh	w0, [x24, #:lo12:.LANCHOR85]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L2562
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 1413
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2562:
	cmn	w28, #1
	beq	.L2564
	ldr	x0, [x20, 24]
	ldr	w0, [x0, 4]
	cmn	w0, #1
	beq	.L2564
	bl	lpa_hash_get_ppa
	cbz	x25, .L2566
	ldr	x3, [x20, 24]
	ldr	w1, [x3, 8]
	cmp	w0, w1
	beq	.L2566
	cmn	w0, #1
	beq	.L2566
	adrp	x4, .LANCHOR66
	mov	w28, 21
	mov	w27, 1
	ldrh	w5, [x4, #:lo12:.LANCHOR66]
	sub	w1, w28, w5
	lsr	w2, w0, w5
	adrp	x5, .LANCHOR67
	lsl	w1, w27, w1
	sub	w1, w1, #1
	and	w1, w1, w2
	ldrb	w2, [x5, #:lo12:.LANCHOR67]
	udiv	w1, w1, w2
	ldrh	w2, [x25]
	cmp	w2, w1, uxth
	bne	.L2566
	ldr	x1, [x29, 128]
	adrp	x6, .LANCHOR178
	ldr	w7, [x3]
	add	x2, x6, :lo12:.LANCHOR178
	str	w7, [x29, 120]
	str	x6, [x29, 152]
	ldrb	w3, [x1]
	ldr	x1, [x20, 8]
	stp	x5, x4, [x29, 104]
	bl	ftl_read_ppa_page
	ldr	x6, [x29, 152]
	ldr	w7, [x29, 120]
	ldr	w0, [x6, #:lo12:.LANCHOR178]
	cmp	w7, w0
	bhi	.L2566
	ldr	x0, [x20, 24]
	ldr	w0, [x0, 8]
	cmn	w0, #1
	beq	.L2564
	ldp	x5, x4, [x29, 104]
	ldrh	w1, [x4, #:lo12:.LANCHOR66]
	sub	w28, w28, w1
	lsr	w0, w0, w1
	lsl	w27, w27, w28
	sub	w27, w27, #1
	and	w27, w27, w0
	ldrb	w0, [x5, #:lo12:.LANCHOR67]
	udiv	w0, w27, w0
	bl	ftl_vpn_decrement
.L2564:
	ldrh	w0, [x19, 6]
	mov	w27, 4
	sub	w0, w0, #1
	strh	w0, [x19, 6]
	ldrh	w0, [x19, 10]
	add	w0, w0, 1
	strh	w0, [x19, 10]
	mov	w0, 1
	str	w0, [x29, 152]
.L2558:
	add	w22, w22, 1
	and	w22, w22, 65535
	b	.L2557
.L2573:
	ldrh	w2, [x19, 12]
	add	w2, w2, w1
	ldr	w2, [x4, x2, lsl 2]
	cmn	w2, #1
	beq	.L2572
	add	w22, w0, 1
	and	w0, w22, 65535
.L2572:
	add	w1, w1, 1
	b	.L2571
.L2589:
	ldr	w0, [x26, x23, lsl 2]
	adrp	x28, .LANCHOR102
	cmn	w0, #1
	bne	.L2577
.L2581:
	ldr	x1, [x28, #:lo12:.LANCHOR102]
	mov	w22, -1
	ldr	x0, [x20, 24]
	ldr	w1, [x1, 8]
	stp	w1, w22, [x0]
	stp	w22, wzr, [x0, 8]
	ldr	x0, [x20, 8]
	str	wzr, [x0]
.L2578:
	ldr	w0, [x29, 152]
	cbz	w0, .L2583
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bls	.L2583
	add	x0, x21, :lo12:.LANCHOR14
	mov	x28, x0
	add	x0, x25, :lo12:.LANCHOR123
	str	x0, [x29, 128]
.L2630:
	mov	x0, x19
	bl	ftl_get_new_free_page
	mov	w4, w0
	ldr	w0, [x28]
	tbz	x0, 14, .L2585
	ldr	x0, [x20, 24]
	mov	w1, w4
	str	w4, [x29, 104]
	ldr	w2, [x0, 4]
	ldr	x0, [x29, 120]
	bl	printf
	ldr	w4, [x29, 104]
.L2585:
	ldr	x0, [x29, 112]
	ldr	w2, [x29, 148]
	ldrh	w1, [x19, 6]
	ldrb	w0, [x0]
	mul	w0, w0, w27
	add	w0, w0, 1
	sub	w0, w0, w2
	cmp	w1, w0
	bls	.L2583
	ldr	x0, [x29, 128]
	ldr	x1, [x20, 8]
	ldr	x2, [x20, 24]
	ldrb	w3, [x0]
	mov	w0, w4
	bl	ftl_prog_ppa_page
	mov	w1, w0
	ldrh	w0, [x19]
	str	w1, [x29, 104]
	bl	ftl_vpn_decrement
	ldr	w1, [x29, 104]
	cmn	w22, #1
	ccmn	w1, #1, 4, ne
	beq	.L2586
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 14, .L2587
	ldr	x0, [x20, 24]
	ldrh	w1, [x19, 12]
	ldrh	w3, [x19, 10]
	add	w3, w3, w1
	ldp	w1, w2, [x0, 4]
	sub	w3, w3, #1
	adrp	x0, .LC159
	add	x0, x0, :lo12:.LC159
	bl	printf
.L2587:
	ldr	x0, [x20, 24]
	ldrh	w1, [x19, 12]
	ldrh	w2, [x19, 10]
	add	w2, w2, w1
	ldr	w1, [x0, 8]
	ldr	w0, [x0, 4]
	sub	w2, w2, #1
	bl	lpa_hash_update_ppa
.L2583:
	add	x23, x23, 1
	b	.L2576
.L2577:
	ldrb	w3, [x25, #:lo12:.LANCHOR123]
	ldr	x1, [x20, 8]
	ldr	x2, [x20, 24]
	bl	ftl_read_ppa_page
	mov	w22, w0
	ldr	x0, [x20, 24]
	ldr	w0, [x0, 4]
	bl	lpa_hash_get_ppa
	mov	w4, w0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 14, .L2579
	ldr	x0, [x20, 24]
	mov	w1, w4
	ldr	w2, [x26, x23, lsl 2]
	str	w4, [x29, 128]
	ldr	w3, [x0, 4]
	adrp	x0, .LC157
	add	x0, x0, :lo12:.LC157
	bl	printf
	ldr	w4, [x29, 128]
.L2579:
	ldr	x2, [x28, #:lo12:.LANCHOR102]
	ldr	w0, [x26, x23, lsl 2]
	cmp	w4, w0
	ldr	x0, [x20, 24]
	ldr	w1, [x2, 8]
	csinv	w22, w22, wzr, eq
	cmn	w22, #1
	add	w3, w1, 1
	str	w3, [x2, 8]
	str	w1, [x0]
	mov	w1, 1
	str	w4, [x0, 8]
	str	w1, [x0, 12]
	bne	.L2578
	b	.L2581
.L2586:
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bls	.L2583
	cmn	w22, #1
	bne	.L2630
	b	.L2583
.L2566:
	ldr	x3, [x20, 24]
	adrp	x0, .LANCHOR120
	ldr	w0, [x0, #:lo12:.LANCHOR120]
	ldr	w1, [x3, 4]
	cmp	w1, w0
	bcs	.L2564
	ldrb	w0, [x19, 9]
	ldrh	w1, [x24, #:lo12:.LANCHOR85]
	ldrh	w2, [x19, 10]
	mul	w0, w0, w1
	sub	w0, w0, #1
	cmp	w2, w0
	bge	.L2564
	adrp	x0, .LANCHOR102
	ldr	w1, [x3]
	ldr	x0, [x0, #:lo12:.LANCHOR102]
	ldr	w4, [x0, 8]
	cmp	w1, w4
	bls	.L2567
	str	w1, [x0, 8]
.L2567:
	ldrh	w0, [x19, 12]
	add	w2, w2, w0
	ldp	w0, w1, [x3, 4]
	bl	lpa_hash_update_ppa
	ldr	w0, [x29, 164]
	str	w0, [x29, 160]
	ldr	w0, [x29, 168]
	str	w0, [x29, 164]
	ldr	w0, [x29, 172]
	str	w0, [x29, 168]
	ldr	w0, [x29, 148]
	str	w0, [x29, 172]
	b	.L2564
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
	adrp	x21, .LANCHOR85
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR103
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR102
	mov	x25, x1
	add	x21, x21, :lo12:.LANCHOR85
	mov	x20, x23
	add	x22, x22, :lo12:.LANCHOR103
	mov	w24, 65535
	str	x27, [sp, 80]
.L2653:
	ldr	x0, [x23, #:lo12:.LANCHOR102]
	ldr	w1, [x0, 48]
	ldrh	w2, [x0, 696]
	add	w1, w1, 1
	str	w1, [x0, 48]
	ldrh	w1, [x21]
	cmp	w2, w1
	bcs	.L2654
	ldrh	w0, [x0, 692]
	cmp	w0, w24
	bne	.L2655
.L2654:
	bl	pm_alloc_new_blk
	mov	w0, 0
	bl	ftl_info_flush
.L2655:
	ldr	x0, [x20, #:lo12:.LANCHOR102]
	ldrh	w0, [x0, 692]
	cmp	w0, w24
	bne	.L2656
	adrp	x1, .LANCHOR190
	adrp	x0, .LC0
	mov	w2, 230
	add	x1, x1, :lo12:.LANCHOR190
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2656:
	ldr	x0, [x20, #:lo12:.LANCHOR102]
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
	ldr	x0, [x20, #:lo12:.LANCHOR102]
	str	w19, [x3]
	ldr	w1, [x0, 48]
	ldrb	w0, [x0, 694]
	str	w1, [x3, 4]
	adrp	x1, .LANCHOR123
	ldrb	w4, [x1, #:lo12:.LANCHOR123]
	mov	w1, w26
	bl	ftl_prog_page
	ldr	x2, [x20, #:lo12:.LANCHOR102]
	ldrh	w1, [x2, 696]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 696]
	cmp	w1, 1
	adrp	x1, .LANCHOR192
	beq	.L2657
	ldrb	w3, [x1, #:lo12:.LANCHOR192]
	cbz	w3, .L2658
.L2657:
	strb	wzr, [x1, #:lo12:.LANCHOR192]
	b	.L2653
.L2658:
	cmn	w0, #1
	bne	.L2660
	mov	w1, w26
	adrp	x0, .LC160
	add	x0, x0, :lo12:.LC160
	bl	printf
	b	.L2653
.L2660:
	ldrh	w0, [x2, 698]
	cmp	w19, w0
	bcs	.L2661
	add	x19, x2, x19, uxtw 2
	str	w26, [x19, 704]
.L2661:
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
	bls	.L2666
	adrp	x25, .LANCHOR75
	str	x25, [x29, 136]
	ldrb	w0, [x25, #:lo12:.LANCHOR75]
	cbnz	w0, .L2668
	adrp	x0, .LANCHOR72
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	cbz	w0, .L2666
.L2668:
	adrp	x0, .LANCHOR7
	ubfiz	x14, x20, 2, 16
	mov	x15, x0
	ldr	x1, [x0, #:lo12:.LANCHOR7]
	add	x1, x1, x14
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 160
	bne	.L2688
	adrp	x0, .LANCHOR71
	ldrb	w10, [x0, #:lo12:.LANCHOR71]
.L2669:
	add	x22, x29, 176
	adrp	x23, .LANCHOR85
	str	w10, [x29, 128]
	mov	w0, w20
	mov	w24, 0
	mov	w25, 0
	strh	w20, [x22, -32]!
	mov	w27, 0
	add	x1, x22, 16
	bl	ftl_get_blk_list_in_sblk
	ldrh	w1, [x23, #:lo12:.LANCHOR85]
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
	adrp	x0, .LC161
	ubfx	x5, x5, 11, 8
	add	x0, x0, :lo12:.LC161
	ubfx	x3, x2, 3, 2
	and	w4, w4, 2047
	ubfx	x2, x2, 5, 3
	bl	printf
	mov	w0, 1
	bl	buf_alloc
	mov	x19, x0
	ldr	w10, [x29, 128]
	adrp	x12, .LANCHOR103
	add	x14, x23, :lo12:.LANCHOR85
	add	x12, x12, :lo12:.LANCHOR103
.L2670:
	ldrh	w0, [x14]
	cmp	w0, w25
	bls	.L2676
	lsl	w11, w25, 1
	adrp	x26, .LC162
	sub	w11, w11, #1
	mov	w27, 0
	add	x26, x26, :lo12:.LC162
	b	.L2680
.L2688:
	mov	w10, 1
	b	.L2669
.L2678:
	ldrh	w13, [x22, x28]
	mov	w0, 65535
	cmp	w13, w0
	bne	.L2671
.L2677:
	add	w24, w24, 1
	and	w24, w24, 65535
.L2672:
	cmp	w10, w24
	bcs	.L2678
	add	w27, w27, 1
	and	w27, w27, 65535
.L2680:
	ldrb	w0, [x29, 153]
	cmp	w0, w27
	bls	.L2679
	sxtw	x28, w27
	mov	w24, 1
	add	x28, x28, 8
	lsl	x28, x28, 1
	b	.L2672
.L2671:
	ldrh	w21, [x12]
	cmp	w10, 3
	mul	w21, w21, w13
	bne	.L2673
	add	w21, w25, w21
	orr	w21, w21, w24, lsl 24
.L2674:
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
	bne	.L2677
.L2676:
	mov	w4, w24
	mov	w3, w27
	mov	w2, w25
	mov	w1, w20
	adrp	x24, .LANCHOR123
	adrp	x0, .LC163
	add	x0, x0, :lo12:.LC163
	bl	printf
	ldr	x0, [x19, 8]
	mov	w1, 0
	ldrb	w2, [x24, #:lo12:.LANCHOR123]
	adrp	x26, .LC164
	adrp	x27, .LANCHOR71
	add	x26, x26, :lo12:.LC164
	add	x27, x27, :lo12:.LANCHOR71
	lsl	w2, w2, 9
	bl	ftl_memset
	ldr	x0, [x19, 24]
	mov	w1, 0
	ldrb	w2, [x24, #:lo12:.LANCHOR123]
	lsl	w2, w2, 1
	bl	ftl_memset
.L2681:
	ldrh	w0, [x23, #:lo12:.LANCHOR85]
	cmp	w0, w25
	bls	.L2686
	ldr	x0, [x29, 136]
	lsl	w28, w25, 1
	mov	w21, 0
	add	x0, x0, :lo12:.LANCHOR75
	str	x0, [x29, 128]
	b	.L2687
.L2673:
	cmp	w10, 2
	bne	.L2675
	adrp	x0, .LANCHOR71
	add	w21, w21, w11
	add	w21, w21, w24
	ldrb	w3, [x0, #:lo12:.LANCHOR71]
	orr	w21, w21, w3, lsl 24
	b	.L2674
.L2675:
	add	w21, w25, w21
	b	.L2674
.L2679:
	add	w8, w25, 1
	and	w25, w8, 65535
	b	.L2670
.L2685:
	mov	w2, w21
	mov	w1, w25
	mov	x0, x26
	bl	printf
	ldr	x0, [x29, 128]
	adrp	x2, .LANCHOR103
	ldrb	w1, [x0]
	sxtw	x0, w21
	cbz	w1, .L2682
	add	x0, x0, 8
	ldrh	w1, [x2, #:lo12:.LANCHOR103]
	ldrh	w0, [x22, x0, lsl 1]
	mul	w0, w0, w1
	orr	w0, w0, w25
	str	w0, [x19, 40]
	mov	x0, x19
	bl	sblk_3d_tlc_dump_prog
.L2683:
	add	w21, w21, 1
	and	w21, w21, 65535
.L2687:
	ldrb	w0, [x29, 153]
	cmp	w0, w21
	bhi	.L2685
	add	w8, w25, 1
	and	w25, w8, 65535
	b	.L2681
.L2682:
	ldrb	w1, [x27]
	add	x0, x0, 8
	cmp	w1, 2
	bne	.L2684
	ldrh	w0, [x22, x0, lsl 1]
	ldrh	w1, [x2, #:lo12:.LANCHOR103]
	mul	w0, w0, w1
	orr	w0, w0, w28
	orr	w0, w0, 33554432
	str	w0, [x19, 40]
	mov	x0, x19
	bl	sblk_mlc_dump_prog
	b	.L2683
.L2684:
	ldrh	w1, [x22, x0, lsl 1]
	mov	w5, 0
	ldrh	w0, [x2, #:lo12:.LANCHOR103]
	ldrb	w4, [x24, #:lo12:.LANCHOR123]
	ldr	x2, [x19, 8]
	ldr	x3, [x19, 24]
	mul	w1, w1, w0
	orr	w1, w1, w25
	str	w1, [x19, 40]
	ubfx	x0, x1, 21, 3
	and	w1, w1, -14680065
	bl	flash_prog_page_en
	b	.L2683
.L2686:
	mov	x0, x19
	bl	buf_free
	adrp	x0, .LC165
	mov	w1, w20
	add	x0, x0, :lo12:.LC165
	bl	printf
.L2666:
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
	tbz	x0, 12, .L2697
	adrp	x2, .LANCHOR193
	adrp	x0, .LC90
	add	x2, x2, :lo12:.LANCHOR193
	mov	w1, 324
	add	x0, x0, :lo12:.LC90
	bl	printf
.L2697:
	adrp	x23, .LANCHOR194
	adrp	x20, .LANCHOR27
	mov	w2, 64
	mov	w1, 0
	ldr	x0, [x23, #:lo12:.LANCHOR194]
	adrp	x21, .LANCHOR195
	adrp	x22, .LANCHOR2
	adrp	x24, .LC167
	adrp	x25, .LANCHOR140
	add	x22, x22, :lo12:.LANCHOR2
	add	x24, x24, :lo12:.LC167
	add	x25, x25, :lo12:.LANCHOR140
	bl	ftl_memset
	add	x27, x21, :lo12:.LANCHOR195
	ldr	x1, [x20, #:lo12:.LANCHOR27]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC166
	add	x0, x0, :lo12:.LC166
	mov	w26, 0
	bl	rknand_print_hex
	ldr	x6, [x20, #:lo12:.LANCHOR27]
	add	x0, x6, 16
	ldr	w1, [x6, 8]
	bl	js_hash
	str	w0, [x6, 12]
.L2698:
	add	x28, x21, :lo12:.LANCHOR195
	ldrb	w4, [x21, #:lo12:.LANCHOR195]
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
	blt	.L2699
	ldr	x6, [x20, #:lo12:.LANCHOR27]
	ldrb	w7, [x28, 1]
	strh	wzr, [x28, 2]
	ldr	w0, [x6, 4]
	ldrh	w1, [x6, 16]
	add	w0, w0, 1
	str	w0, [x6, 4]
	ldrb	w0, [x21, #:lo12:.LANCHOR195]
	add	w1, w1, 1
	strb	w0, [x28, 1]
	mov	x0, x6
	strb	w7, [x21, #:lo12:.LANCHOR195]
	strh	w1, [x0, 16]!
	ldr	w1, [x6, 8]
	bl	js_hash
	ldrh	w19, [x22]
	str	w0, [x6, 12]
	mul	w19, w19, w7
.L2708:
	mov	w1, w19
	mov	w0, 0
	bl	flash_erase_block
	b	.L2700
.L2703:
	mov	w26, 1
	b	.L2698
.L2699:
	madd	w19, w19, w4, w3
	cbz	w1, .L2708
.L2700:
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	mov	w1, w19
	ldr	x3, [x23, #:lo12:.LANCHOR194]
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
	bne	.L2701
	mov	w1, w19
	adrp	x0, .LC168
	add	x0, x0, :lo12:.LC168
	bl	printf
	b	.L2698
.L2701:
	cbz	w26, .L2703
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
	tbz	x0, 12, .L2710
	ldr	x4, [x20, #:lo12:.LANCHOR27]
	adrp	x2, .LANCHOR196
	adrp	x0, .LC169
	mov	w3, 2048
	add	x2, x2, :lo12:.LANCHOR196
	mov	w1, 50
	add	x0, x0, :lo12:.LC169
	bl	printf
.L2710:
	adrp	x21, .LANCHOR194
	adrp	x24, .LANCHOR2
	mov	w22, 21321
	add	x26, x24, :lo12:.LANCHOR2
	mov	x23, x21
	mov	w19, 4
	movk	w22, 0x5359, lsl 16
.L2713:
	ldrh	w1, [x26]
	mov	w4, 4
	ldr	x3, [x21, #:lo12:.LANCHOR194]
	mov	w0, 0
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	add	x27, x21, :lo12:.LANCHOR194
	add	x25, x20, :lo12:.LANCHOR27
	mul	w1, w1, w19
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2711
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	ldr	w0, [x2]
	cmp	w0, w22
	beq	.L2712
.L2711:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L2713
.L2738:
	mov	w0, -1
.L2709:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2721:
	ldr	x0, [x25]
	ldr	w1, [x0]
	cmp	w1, w22
	bne	.L2722
	ldr	w21, [x0, 4]
.L2715:
	add	x22, x19, :lo12:.LANCHOR195
	ldrh	w0, [x24, #:lo12:.LANCHOR2]
	ldr	x3, [x23, #:lo12:.LANCHOR194]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	ldrb	w1, [x22, 1]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2716
	ldr	x0, [x20, #:lo12:.LANCHOR27]
	mov	w1, 21321
	movk	w1, 0x5359, lsl 16
	ldr	w2, [x0]
	cmp	w2, w1
	bne	.L2716
	ldr	w1, [x0, 4]
	cmp	w21, w1
	bcs	.L2716
	ldrb	w1, [x0, 37]
	ldrb	w0, [x0, 36]
	strb	w1, [x19, #:lo12:.LANCHOR195]
	strb	w0, [x22, 1]
.L2716:
	ldrb	w1, [x19, #:lo12:.LANCHOR195]
	add	x21, x19, :lo12:.LANCHOR195
	ldr	x3, [x23, #:lo12:.LANCHOR194]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	mov	w0, 0
	bl	flash_get_last_written_page
	and	w25, w0, 65535
	add	w1, w25, 1
	ldrb	w22, [x19, #:lo12:.LANCHOR195]
	strh	w1, [x21, 2]
	mov	w21, 0
	ldrh	w1, [x24, #:lo12:.LANCHOR2]
	mov	w24, 21321
	movk	w24, 0x5359, lsl 16
	mul	w22, w22, w1
	add	w22, w22, w0, sxth
.L2717:
	sub	w0, w25, w21
	sxth	w19, w0
	tbz	w19, #31, .L2720
	cmn	w19, #1
	bne	.L2719
	ldr	x0, [x20, #:lo12:.LANCHOR27]
	ldr	w1, [x0]
	adrp	x0, .LC170
	add	x0, x0, :lo12:.LC170
	bl	printf
	b	.L2738
.L2720:
	ldr	x3, [x23, #:lo12:.LANCHOR194]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR27]
	sub	w1, w22, w21
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L2718
	ldr	x0, [x20, #:lo12:.LANCHOR27]
	ldr	w0, [x0]
	cmp	w0, w24
	beq	.L2719
.L2718:
	add	w21, w21, 1
	b	.L2717
.L2719:
	cmp	w21, 1
	bls	.L2723
	bl	flash_info_flush
.L2723:
	mov	w0, 0
	b	.L2709
.L2712:
	adrp	x19, .LANCHOR195
	add	x1, x19, :lo12:.LANCHOR195
	ldrb	w3, [x2, 37]
	mov	w4, 4
	ldrb	w0, [x2, 36]
	strb	w3, [x1, 1]
	ldrh	w1, [x26]
	ldr	x3, [x27]
	strb	w0, [x19, #:lo12:.LANCHOR195]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	bne	.L2721
.L2722:
	mov	w21, 0
	b	.L2715
	.size	flash_info_blk_init, .-flash_info_blk_init
	.section	.text.nand_flash_init,"ax",@progbits
	.align	2
	.global	nand_flash_init
	.type	nand_flash_init, %function
nand_flash_init:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR14
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	tbz	x0, 12, .L2740
	adrp	x2, .LANCHOR197
	adrp	x0, .LC90
	add	x2, x2, :lo12:.LANCHOR197
	mov	w1, 2490
	add	x0, x0, :lo12:.LC90
	bl	printf
.L2740:
	adrp	x0, .LANCHOR160
	adrp	x23, .LANCHOR16
	adrp	x22, .LANCHOR42
	add	x24, x22, :lo12:.LANCHOR42
	str	wzr, [x0, #:lo12:.LANCHOR160]
	mov	x0, x19
	bl	nandc_init
	adrp	x19, .LANCHOR31
	add	x0, x19, :lo12:.LANCHOR31
	mov	x25, x24
	str	x0, [x23, #:lo12:.LANCHOR16]
	adrp	x0, .LANCHOR18
	mov	w1, 1
	mov	w21, 0
	mov	w26, 44
	strb	w1, [x0, #:lo12:.LANCHOR18]
	mov	w2, 8
	mov	w1, 0
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
	bl	ftl_memset
	mov	w2, 32
	mov	w1, 0
	adrp	x0, .LANCHOR141
	add	x0, x0, :lo12:.LANCHOR141
	bl	ftl_memset
.L2746:
	mov	x1, x24
	mov	w0, w21
	bl	flash_read_id
	cbnz	w21, .L2741
	ldrb	w0, [x25]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 253
	bls	.L2742
.L2744:
	mov	w19, -2
.L2739:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2742:
	ldrb	w0, [x25, 1]
	cmp	w0, 255
	beq	.L2744
.L2741:
	ldrb	w0, [x24]
	cmp	w0, 181
	bne	.L2745
	strb	w26, [x24]
.L2745:
	add	w21, w21, 1
	add	x24, x24, 8
	and	w21, w21, 255
	cmp	w21, 4
	bne	.L2746
	adrp	x0, .LANCHOR198
	add	x8, x0, :lo12:.LANCHOR198
	add	x8, x8, 1
	mov	x7, x0
	add	x12, x22, :lo12:.LANCHOR42
	mov	x10, 0
.L2749:
	ldrb	w2, [x8, -1]
	mov	w11, w10
	lsl	x24, x10, 5
	mov	x1, x12
	mov	x0, x8
	bl	flash_mem_cmp8
	cbnz	w0, .L2747
	add	x0, x7, :lo12:.LANCHOR198
	ubfiz	x11, x11, 5, 32
	add	x24, x0, x24
	add	x0, x0, x11
	adrp	x1, .LANCHOR199
	add	x4, x1, :lo12:.LANCHOR199
	ldrb	w3, [x0, 22]
	mov	x0, 0
.L2748:
	lsl	x5, x0, 5
	mov	w2, w0
	ldrb	w5, [x5, x4]
	cmp	w5, w3
	beq	.L2750
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L2748
	mov	w2, w0
.L2750:
	ubfiz	x0, x2, 5, 32
	add	x1, x1, :lo12:.LANCHOR199
	add	x1, x1, x0
	mov	w2, 32
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	bl	ftl_memcpy
	add	x21, x19, :lo12:.LANCHOR31
	mov	x1, x24
	adrp	x24, .LANCHOR28
	mov	w2, 32
	mov	x0, x21
	bl	ftl_memcpy
	ldrb	w0, [x24, #:lo12:.LANCHOR28]
	cmp	w0, 8
	bhi	.L2751
	ldrb	w1, [x21, 20]
	cmp	w1, 60
	bls	.L2752
	mov	w1, 60
	strb	w1, [x21, 20]
.L2752:
	cmp	w0, 8
	bne	.L2751
	ldrb	w0, [x22, #:lo12:.LANCHOR42]
	mov	w1, 137
	cmp	w0, 44
	ccmp	w0, w1, 4, ne
	bne	.L2751
	add	x0, x19, :lo12:.LANCHOR31
	ldrb	w1, [x0, 28]
	cmp	w1, 3
	bne	.L2751
	strb	wzr, [x0, 28]
.L2751:
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2753
	adrp	x2, .LANCHOR197
	adrp	x0, .LC90
	add	x2, x2, :lo12:.LANCHOR197
	mov	w1, 2515
	add	x0, x0, :lo12:.LC90
	bl	printf
.L2753:
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR164
	adrp	x22, .LANCHOR27
	add	x21, x19, :lo12:.LANCHOR31
	str	x0, [x1, #:lo12:.LANCHOR164]
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR156
	str	x0, [x1, #:lo12:.LANCHOR156]
	mov	w0, 2048
	bl	ftl_malloc
	str	x0, [x22, #:lo12:.LANCHOR27]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR163
	str	x0, [x1, #:lo12:.LANCHOR163]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR158
	str	x0, [x1, #:lo12:.LANCHOR158]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR194
	str	x0, [x1, #:lo12:.LANCHOR194]
	adrp	x0, .LANCHOR200
	strb	wzr, [x0, #:lo12:.LANCHOR200]
	bl	flash_die_info_init
	ldrb	w0, [x21, 18]
	bl	flash_lsb_page_tbl_build
	ldrb	w0, [x21, 20]
	adrp	x21, .LANCHOR162
	bl	nandc_bch_sel
	str	xzr, [x21, #:lo12:.LANCHOR162]
	ldr	x1, [x23, #:lo12:.LANCHOR16]
	adrp	x23, .LANCHOR43
	ldrh	w0, [x1, 16]
	ldrb	w1, [x1, 28]
	ubfx	x2, x0, 8, 3
	strb	w2, [x23, #:lo12:.LANCHOR43]
	adrp	x2, .LANCHOR168
	ubfx	x3, x0, 3, 1
	strb	w3, [x2, #:lo12:.LANCHOR168]
	adrp	x2, .LANCHOR39
	ubfx	x3, x0, 4, 1
	strb	w3, [x2, #:lo12:.LANCHOR39]
	adrp	x2, .LANCHOR75
	ubfx	x3, x0, 12, 1
	strb	w3, [x2, #:lo12:.LANCHOR75]
	adrp	x2, .LANCHOR72
	ubfx	x3, x0, 13, 1
	strb	w3, [x2, #:lo12:.LANCHOR72]
	adrp	x2, .LANCHOR1
	ubfx	x3, x0, 14, 1
	lsr	w0, w0, 15
	strb	w3, [x2, #:lo12:.LANCHOR1]
	adrp	x2, .LANCHOR73
	strb	w0, [x2, #:lo12:.LANCHOR73]
	adrp	x0, .LANCHOR0
	mov	w2, 60
	strb	w1, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LANCHOR17
	strb	w2, [x0, #:lo12:.LANCHOR17]
	ldrb	w2, [x24, #:lo12:.LANCHOR28]
	cmp	w2, 9
	bne	.L2754
	mov	w2, 70
	strb	w2, [x0, #:lo12:.LANCHOR17]
.L2754:
	adrp	x0, .LANCHOR19
	strb	w1, [x0, #:lo12:.LANCHOR19]
	add	x1, x19, :lo12:.LANCHOR31
	ldrb	w1, [x1, 7]
	cmp	w1, 9
	bne	.L2755
	strb	wzr, [x0, #:lo12:.LANCHOR19]
.L2755:
	add	x19, x19, :lo12:.LANCHOR31
	adrp	x25, .LANCHOR24
	ldrh	w1, [x19, 16]
	ldrb	w0, [x19, 19]
	strb	w0, [x25, #:lo12:.LANCHOR24]
	tbz	x1, 6, .L2757
	sub	w1, w0, #17
	and	w1, w1, 255
	cmp	w1, 2
	ccmp	w0, 21, 4, hi
	bne	.L2758
	adrp	x1, micron_read_retrial
	add	x1, x1, :lo12:micron_read_retrial
	str	x1, [x21, #:lo12:.LANCHOR162]
	cmp	w0, 21
	adrp	x0, .LANCHOR159
	beq	.L2759
	mov	w1, 15
.L2806:
	strb	w1, [x0, #:lo12:.LANCHOR159]
	b	.L2757
.L2747:
	add	x10, x10, 1
	add	x8, x8, 32
	cmp	x10, 38
	bne	.L2749
	b	.L2744
.L2759:
	mov	w1, 4
	b	.L2806
.L2758:
	sub	w1, w0, #65
	cmp	w0, 33
	and	w1, w1, 255
	ccmp	w1, 1, 0, ne
	bhi	.L2761
	adrp	x0, toshiba_read_retrial
	add	x0, x0, :lo12:toshiba_read_retrial
	str	x0, [x21, #:lo12:.LANCHOR162]
	adrp	x0, .LANCHOR26
	mov	w1, 4
	strb	w1, [x0, #:lo12:.LANCHOR26]
.L2808:
	mov	w1, 7
	adrp	x0, .LANCHOR159
	b	.L2806
.L2761:
	sub	w2, w0, #34
	sub	w1, w0, #67
	and	w2, w2, 255
	and	w1, w1, 255
	cmp	w2, 1
	ccmp	w1, 1, 0, hi
	bhi	.L2762
	adrp	x2, toshiba_read_retrial
	add	x2, x2, :lo12:toshiba_read_retrial
	str	x2, [x21, #:lo12:.LANCHOR162]
	cmp	w0, 35
	mov	w2, 68
	ccmp	w0, w2, 4, ne
	adrp	x0, .LANCHOR159
	beq	.L2763
	mov	w2, 7
.L2805:
	strb	w2, [x0, #:lo12:.LANCHOR159]
	cmp	w1, 1
	adrp	x0, .LANCHOR26
	bhi	.L2765
	mov	w1, 4
.L2807:
	strb	w1, [x0, #:lo12:.LANCHOR26]
.L2757:
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2766
	adrp	x2, .LANCHOR197
	adrp	x0, .LC90
	add	x2, x2, :lo12:.LANCHOR197
	mov	w1, 2573
	add	x0, x0, :lo12:.LC90
	bl	printf
.L2766:
	adrp	x24, .LANCHOR21
	ldrb	w0, [x23, #:lo12:.LANCHOR43]
	strb	wzr, [x24, #:lo12:.LANCHOR21]
	tbz	x0, 0, .L2767
	mov	w0, 4
	bl	nandc_set_if_mode
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
.L2809:
	bl	nandc_set_if_mode
	bl	flash_info_blk_init
	mov	w19, w0
	cmn	w0, #1
	bne	.L2769
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2770
	adrp	x2, .LANCHOR197
	adrp	x0, .LC90
	add	x2, x2, :lo12:.LANCHOR197
	mov	w1, 2605
	add	x0, x0, :lo12:.LC90
	bl	printf
.L2770:
	ldr	x0, [x22, #:lo12:.LANCHOR27]
	mov	w1, 17
	strb	w1, [x0, 32]
	mov	w0, 0
	bl	zftl_flash_exit_slc_mode
	b	.L2739
.L2763:
	mov	w2, 17
	b	.L2805
.L2765:
	mov	w1, 5
	b	.L2807
.L2762:
	sub	w0, w0, #36
	and	w0, w0, 255
	cmp	w0, 1
	bhi	.L2757
	adrp	x0, toshiba_3d_read_retrial
	add	x0, x0, :lo12:toshiba_3d_read_retrial
	str	x0, [x21, #:lo12:.LANCHOR162]
	b	.L2808
.L2767:
	mov	w0, 4
	b	.L2809
.L2769:
	ldrb	w0, [x25, #:lo12:.LANCHOR24]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 7
	bhi	.L2771
	adrp	x0, hynix_read_retrial
	add	x0, x0, :lo12:hynix_read_retrial
	str	x0, [x21, #:lo12:.LANCHOR162]
.L2771:
	ldrb	w0, [x23, #:lo12:.LANCHOR43]
	tbz	x0, 2, .L2773
	ldr	x0, [x22, #:lo12:.LANCHOR27]
	ldrb	w0, [x0, 19]
	cbz	w0, .L2773
	adrp	x0, .LANCHOR195
	ldrb	w1, [x0, #:lo12:.LANCHOR195]
	adrp	x0, .LANCHOR2
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_ddr_para_scan
	ldrb	w0, [x24, #:lo12:.LANCHOR21]
	cbnz	w0, .L2773
	ldr	x0, [x22, #:lo12:.LANCHOR27]
	strb	wzr, [x0, 19]
	bl	flash_info_flush
.L2773:
	ldr	w0, [x20, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2775
	adrp	x2, .LANCHOR197
	adrp	x0, .LC90
	add	x2, x2, :lo12:.LANCHOR197
	mov	w1, 2671
	add	x0, x0, :lo12:.LC90
	bl	printf
.L2775:
	bl	nand_flash_print_info
	mov	w19, 0
	b	.L2739
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
	adrp	x25, .LANCHOR85
	stp	x21, x22, [sp, 80]
	bl	buf_alloc
	ldr	x28, [x0, 8]
	adrp	x26, .LANCHOR103
	adrp	x27, .LANCHOR123
	mov	x24, x0
	add	x25, x25, :lo12:.LANCHOR85
	add	x26, x26, :lo12:.LANCHOR103
	add	x27, x27, :lo12:.LANCHOR123
	mov	w19, 0
.L2811:
	ldrh	w0, [x25]
	cmp	w0, w19
	bhi	.L2813
	add	x1, x28, 704
	mov	w3, 32
	mov	w2, 4
	adrp	x0, .LC171
	add	x0, x0, :lo12:.LC171
	bl	rknand_print_hex
	mov	x0, x24
	bl	buf_free
	cbz	w20, .L2814
	adrp	x1, .LANCHOR201
	adrp	x0, .LC0
	mov	w2, 1351
	add	x1, x1, :lo12:.LANCHOR201
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2814:
	mov	w0, w20
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 144
	ret
.L2813:
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
	adrp	x0, .LC162
	add	x0, x0, :lo12:.LC162
	bl	printf
	cmp	w22, 512
	ccmn	w22, #1, 4, ne
	csinc	w20, w20, wzr, ne
	b	.L2811
	.size	ftl_sysblk_dump, .-ftl_sysblk_dump
	.section	.text.dump_ftl_info,"ax",@progbits
	.align	2
	.global	dump_ftl_info
	.type	dump_ftl_info, %function
dump_ftl_info:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR52
	add	x29, sp, 0
	ldrb	w1, [x0, #:lo12:.LANCHOR52]
	adrp	x0, .LC172
	stp	x19, x20, [sp, 16]
	add	x0, x0, :lo12:.LC172
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR102
	adrp	x19, .LANCHOR10
	adrp	x20, .LANCHOR85
	bl	printf
	adrp	x21, .LANCHOR6
	adrp	x0, .LANCHOR179
	add	x1, x0, :lo12:.LANCHOR179
	ldrh	w3, [x1, 2]
	ldrb	w2, [x1, 1]
	ldrb	w1, [x0, #:lo12:.LANCHOR179]
	adrp	x0, .LC173
	add	x0, x0, :lo12:.LC173
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR102]
	ldrh	w2, [x0, 140]
	ldrh	w1, [x0, 130]
	adrp	x0, .LC174
	add	x0, x0, :lo12:.LC174
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	adrp	x0, .LC175
	add	x0, x0, :lo12:.LC175
	ldrh	w5, [x1, 26]
	ldrh	w4, [x1, 22]
	ldrb	w3, [x1, 21]
	ldrh	w2, [x1, 18]
	ldrh	w1, [x1, 16]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	adrp	x0, .LC176
	add	x0, x0, :lo12:.LC176
	ldrh	w5, [x1, 58]
	ldrh	w4, [x1, 54]
	ldrb	w3, [x1, 53]
	ldrh	w2, [x1, 50]
	ldrh	w1, [x1, 48]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	adrp	x19, .LANCHOR78
	adrp	x0, .LC177
	add	x0, x0, :lo12:.LC177
	ldrh	w5, [x1, 90]
	ldrh	w4, [x1, 86]
	ldrb	w3, [x1, 85]
	ldrh	w2, [x1, 82]
	ldrh	w1, [x1, 80]
	bl	printf
	ldrb	w0, [x19, #:lo12:.LANCHOR78]
	mov	w2, 4
	ldrh	w3, [x20, #:lo12:.LANCHOR85]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR109
	ldr	x1, [x0, #:lo12:.LANCHOR109]
	adrp	x0, .LC178
	lsl	w3, w3, 1
	add	x0, x0, :lo12:.LC178
	bl	rknand_print_hex
	adrp	x0, .LANCHOR9
	ldrh	w3, [x21, #:lo12:.LANCHOR6]
	mov	w2, 2
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	adrp	x0, .LC179
	add	x0, x0, :lo12:.LC179
	bl	rknand_print_hex
	ldr	x1, [x22, #:lo12:.LANCHOR102]
	mov	w2, 4
	adrp	x0, .LC171
	add	x0, x0, :lo12:.LC171
	add	x1, x1, 704
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	adrp	x0, .LANCHOR7
	ldrh	w3, [x21, #:lo12:.LANCHOR6]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR7]
	adrp	x0, .LC180
	add	x0, x0, :lo12:.LC180
	bl	rknand_print_hex
	mov	w3, 256
	mov	w2, 2
	adrp	x1, .LANCHOR108
	adrp	x0, .LC181
	add	x1, x1, :lo12:.LANCHOR108
	add	x0, x0, :lo12:.LC181
	bl	rknand_print_hex
	ldrb	w0, [x19, #:lo12:.LANCHOR78]
	mov	w2, 2
	ldrh	w3, [x20, #:lo12:.LANCHOR85]
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR110
	ldp	x29, x30, [sp], 48
	lsl	w3, w3, 1
	ldr	x1, [x0, #:lo12:.LANCHOR110]
	adrp	x0, .LC182
	add	x0, x0, :lo12:.LC182
	b	rknand_print_hex
	.size	dump_ftl_info, .-dump_ftl_info
	.section	.text.pm_ppa_update_check,"ax",@progbits
	.align	2
	.global	pm_ppa_update_check
	.type	pm_ppa_update_check, %function
pm_ppa_update_check:
	adrp	x3, .LANCHOR66
	mov	w4, 21
	ldrh	w3, [x3, #:lo12:.LANCHOR66]
	sub	w5, w4, w3
	mov	w4, 1
	lsr	w3, w2, w3
	lsl	w4, w4, w5
	sub	w4, w4, #1
	and	w4, w4, w3
	adrp	x3, .LANCHOR67
	ldrb	w3, [x3, #:lo12:.LANCHOR67]
	udiv	w4, w4, w3
	adrp	x3, .LANCHOR7
	ldr	x3, [x3, #:lo12:.LANCHOR7]
	add	x4, x3, x4, uxth 2
	ldrb	w3, [x4, 2]
	ubfx	x3, x3, 5, 3
	cmp	w3, 1
	ccmp	w3, 7, 4, ne
	bne	.L2825
	stp	x29, x30, [sp, -16]!
	mov	w3, w2
	mov	w2, w1
	mov	x1, x0
	add	x29, sp, 0
	adrp	x0, .LC183
	add	x0, x0, :lo12:.LC183
	bl	printf
	bl	dump_ftl_info
	mov	w0, -1
	ldp	x29, x30, [sp], 16
	ret
.L2825:
	mov	w0, 0
	ret
	.size	pm_ppa_update_check, .-pm_ppa_update_check
	.section	.text.load_l2p_region,"ax",@progbits
	.align	2
	.type	load_l2p_region, %function
load_l2p_region:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w1, 65535
	stp	x21, x22, [sp, 32]
	and	w19, w0, 65535
	stp	x23, x24, [sp, 48]
	cmp	w20, 31
	bls	.L2831
	adrp	x1, .LANCHOR202
	adrp	x0, .LC0
	mov	w2, 31
	add	x1, x1, :lo12:.LANCHOR202
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2831:
	adrp	x22, .LANCHOR102
	ldr	x0, [x22, #:lo12:.LANCHOR102]
	ldrh	w2, [x0, 698]
	cmp	w2, w19
	bcs	.L2832
	mov	w1, w19
	adrp	x0, .LC184
	add	x0, x0, :lo12:.LC184
	bl	printf
	adrp	x0, .LANCHOR203
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR203]
	mov	x0, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR102]
	ldrh	w0, [x0, 698]
	cmp	w0, w19
	bcs	.L2834
	mov	w2, 35
.L2839:
	adrp	x1, .LANCHOR202
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR202
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L2834
.L2832:
	add	x0, x0, x19, sxtw 2
	sbfiz	x20, x20, 4, 32
	ldr	w21, [x0, 704]
	adrp	x0, .LANCHOR132
	add	x0, x0, :lo12:.LANCHOR132
	add	x23, x0, x20
	strh	w19, [x0, x20]
	strh	wzr, [x23, 2]
	cbnz	w21, .L2835
	mov	w2, 0
	mov	w1, w19
	adrp	x0, .LC185
	add	x0, x0, :lo12:.LC185
	bl	printf
	adrp	x0, .LANCHOR203
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR203]
	ldr	x0, [x23, 8]
	bl	ftl_memset
.L2834:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L2835:
	adrp	x20, .LANCHOR191
	adrp	x24, .LANCHOR123
	ldr	x1, [x23, 8]
	mov	w0, w21
	ldr	x2, [x20, #:lo12:.LANCHOR191]
	ldrb	w3, [x24, #:lo12:.LANCHOR123]
	bl	ftl_read_ppa_page
	ldr	x1, [x20, #:lo12:.LANCHOR191]
	ldr	w2, [x1]
	cmp	w2, w19
	beq	.L2836
	mov	w4, w21
	mov	w3, w0
	mov	w1, w19
	adrp	x0, .LC186
	add	x0, x0, :lo12:.LC186
	bl	printf
	ldr	x1, [x22, #:lo12:.LANCHOR102]
	mov	w2, 4
	adrp	x0, .LC187
	add	x0, x0, :lo12:.LC187
	add	x1, x1, 704
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	ldr	x1, [x23, 8]
	mov	w2, 4
	ldrb	w3, [x24, #:lo12:.LANCHOR123]
	adrp	x0, .LC188
	add	x0, x0, :lo12:.LC188
	lsl	w3, w3, 7
	bl	rknand_print_hex
	ldr	x1, [x20, #:lo12:.LANCHOR191]
	adrp	x0, .LC189
	mov	w3, 16
	mov	w2, 4
	add	x0, x0, :lo12:.LC189
	bl	rknand_print_hex
.L2836:
	ldr	x0, [x20, #:lo12:.LANCHOR191]
	ldr	w0, [x0]
	cmp	w19, w0
	beq	.L2834
	mov	w2, 59
	b	.L2839
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.pm_gc,"ax",@progbits
	.align	2
	.global	pm_gc
	.type	pm_gc, %function
pm_gc:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR102
	adrp	x19, .LANCHOR146
	stp	x21, x22, [sp, 32]
	ldr	x0, [x20, #:lo12:.LANCHOR102]
	stp	x23, x24, [sp, 48]
	ldrh	w1, [x0, 688]
	ldrh	w0, [x19, #:lo12:.LANCHOR146]
	str	x25, [sp, 64]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L2842
	bl	pm_free_sblk
	ldr	x2, [x20, #:lo12:.LANCHOR102]
	ldrh	w1, [x19, #:lo12:.LANCHOR146]
	sub	w1, w1, #1
	ldrh	w3, [x2, 688]
	cmp	w3, w1
	blt	.L2842
	add	x0, x2, x0, uxth 1
	ldrh	w21, [x0, 416]
	mov	w0, 65535
	cmp	w21, w0
	bne	.L2844
	adrp	x1, .LANCHOR204
	add	x1, x1, :lo12:.LANCHOR204
	mov	w2, 131
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	bl	pm_free_sblk
	ldr	x1, [x20, #:lo12:.LANCHOR102]
	add	x0, x1, x0, uxth 1
	ldrh	w21, [x0, 416]
.L2844:
	bl	pm_select_ram_region
	and	x24, x0, 65535
	adrp	x1, .LANCHOR132
	lsl	x0, x24, 4
	add	x2, x1, :lo12:.LANCHOR132
	mov	x22, x24
	add	x19, x2, x0
	mov	x23, x1
	ldrh	w0, [x2, x0]
	mov	w2, 65535
	cmp	w0, w2
	beq	.L2845
	ldr	x1, [x19, 8]
	cbz	x1, .L2845
	ldrsh	w2, [x19, 2]
	tbz	w2, #31, .L2845
	bl	pm_write_page
	ldrh	w0, [x19, 2]
	and	w0, w0, 32767
	strh	w0, [x19, 2]
.L2845:
	add	x1, x23, :lo12:.LANCHOR132
	adrp	x25, .LANCHOR66
	add	x24, x1, x24, lsl 4
	add	x25, x25, :lo12:.LANCHOR66
	mov	w19, 0
.L2846:
	ldr	x1, [x20, #:lo12:.LANCHOR102]
	ldrh	w0, [x1, 698]
	cmp	w0, w19
	bhi	.L2848
	bl	pm_free_sblk
.L2842:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2848:
	add	x1, x1, x19, sxtw 2
	ldrh	w3, [x25]
	mov	w0, 21
	sub	w2, w0, w3
	mov	w0, 1
	ldr	w1, [x1, 704]
	lsl	w0, w0, w2
	sub	w0, w0, #1
	lsr	w1, w1, w3
	and	w0, w0, w1
	adrp	x1, .LANCHOR67
	ldrb	w1, [x1, #:lo12:.LANCHOR67]
	udiv	w0, w0, w1
	cmp	w21, w0, uxth
	bne	.L2847
	mov	w1, w22
	mov	w0, w19
	bl	load_l2p_region
	ldr	x1, [x24, 8]
	mov	w0, w19
	bl	pm_write_page
	mov	w0, -1
	strh	w0, [x24]
.L2847:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2846
	.size	pm_gc, .-pm_gc
	.section	.text.pm_flush_id,"ax",@progbits
	.align	2
	.global	pm_flush_id
	.type	pm_flush_id, %function
pm_flush_id:
	stp	x29, x30, [sp, -32]!
	ubfiz	x0, x0, 4, 16
	adrp	x2, .LANCHOR132
	add	x2, x2, :lo12:.LANCHOR132
	add	x29, sp, 0
	str	x19, [sp, 16]
	add	x19, x2, x0
	ldrh	w0, [x2, x0]
	ldr	x1, [x19, 8]
	bl	pm_write_page
	ldrh	w0, [x19, 2]
	and	w0, w0, 32767
	strh	w0, [x19, 2]
	adrp	x19, .LANCHOR130
	ldr	w0, [x19, #:lo12:.LANCHOR130]
	cbz	w0, .L2854
	bl	pm_gc
	str	wzr, [x19, #:lo12:.LANCHOR130]
.L2854:
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
	adrp	x19, .LANCHOR132
	add	x19, x19, :lo12:.LANCHOR132
	mov	w20, 0
	add	x19, x19, 2
.L2861:
	ldrsh	w0, [x19]
	tbz	w0, #31, .L2860
	mov	w0, w20
	bl	pm_flush_id
.L2860:
	add	w20, w20, 1
	add	x19, x19, 16
	and	w20, w20, 65535
	cmp	w20, 32
	bne	.L2861
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
	adrp	x0, .LANCHOR130
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR132
	str	wzr, [x0, #:lo12:.LANCHOR130]
	adrp	x0, .LANCHOR192
	stp	x25, x26, [sp, 64]
	add	x21, x19, :lo12:.LANCHOR132
	strb	w1, [x0, #:lo12:.LANCHOR192]
	mov	w0, 64
	stp	x27, x28, [sp, 80]
	bl	ftl_malloc
	adrp	x1, .LANCHOR191
	mov	x20, x19
	add	x23, x21, 512
	adrp	x19, .LANCHOR123
	mov	x22, x1
	add	x19, x19, :lo12:.LANCHOR123
	str	x0, [x1, #:lo12:.LANCHOR191]
	mov	w25, -1
.L2871:
	strh	w25, [x21]
	strh	wzr, [x21, 2]
	cbz	w24, .L2870
	ldrb	w0, [x19]
	lsl	w0, w0, 9
	bl	ftl_malloc
	str	x0, [x21, 8]
.L2870:
	add	x21, x21, 16
	cmp	x21, x23
	bne	.L2871
	add	x0, x20, :lo12:.LANCHOR132
	adrp	x19, .LANCHOR102
	ldr	x24, [x22, #:lo12:.LANCHOR191]
	mov	w4, 4
	ldr	x25, [x0, 8]
	mov	x3, x24
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	mov	x2, x25
	ldrh	w1, [x0, 692]
	ldrb	w0, [x0, 694]
	bl	flash_get_last_written_page
	sxth	w26, w0
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	mov	w23, w26
	ldrh	w2, [x0, 696]
	cmp	w2, w26
	bgt	.L2872
	ldrh	w1, [x0, 692]
	mov	w3, w26
	adrp	x0, .LC190
	add	x0, x0, :lo12:.LC190
	adrp	x27, .LANCHOR103
	adrp	x28, .LANCHOR123
	add	x27, x27, :lo12:.LANCHOR103
	add	x28, x28, :lo12:.LANCHOR123
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	ldrsh	w21, [x0, 696]
.L2873:
	cmp	w21, w26
	ble	.L2875
	adrp	x0, .LANCHOR182
	mov	w1, 1
	add	w23, w23, 1
	strb	w1, [x0, #:lo12:.LANCHOR182]
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	strh	w23, [x0, 696]
	bl	pm_free_sblk
.L2872:
	add	x20, x20, :lo12:.LANCHOR132
	mov	w0, -1
	ldr	x1, [x20, 8]
	bl	pm_write_page
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
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
.L2875:
	ldr	x0, [x19, #:lo12:.LANCHOR102]
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
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	str	w4, [x29, 108]
	mov	w2, w22
	ldr	w1, [x0, 48]
	ldrh	w3, [x0, 694]
	add	w1, w1, 1
	str	w1, [x0, 48]
	adrp	x0, .LC191
	add	x0, x0, :lo12:.LC191
	ldr	w1, [x24]
	bl	printf
	ldr	w4, [x29, 108]
	cmp	w4, 512
	ccmn	w4, #1, 4, ne
	beq	.L2874
	ldr	x1, [x19, #:lo12:.LANCHOR102]
	ldr	w0, [x24]
	ldrh	w2, [x1, 698]
	cmp	w0, w2
	bcs	.L2874
	add	x0, x1, x0, uxtw 2
	str	w22, [x0, 704]
.L2874:
	add	w21, w21, 1
	sxth	w21, w21
	b	.L2873
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
	adrp	x0, .LANCHOR120
	stp	x23, x24, [sp, 48]
	stp	x19, x20, [sp, 16]
	mov	w24, w2
	stp	x21, x22, [sp, 32]
	mov	x23, x1
	ldr	w2, [x0, #:lo12:.LANCHOR120]
	str	x27, [sp, 80]
	cmp	w25, w2
	bcc	.L2885
	mov	w1, w25
	adrp	x0, .LC192
	add	x0, x0, :lo12:.LC192
	bl	printf
	mov	w0, -1
	cbnz	w24, .L2884
	str	w0, [x23]
.L2884:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2885:
	adrp	x0, .LANCHOR123
	adrp	x21, .LANCHOR132
	mov	x19, 0
	ldrb	w20, [x0, #:lo12:.LANCHOR123]
	add	x0, x21, :lo12:.LANCHOR132
	add	x0, x0, 8
	lsl	w22, w20, 7
	udiv	w22, w25, w22
	and	w26, w22, 65535
.L2891:
	ldr	x1, [x0]
	cbz	x1, .L2887
	ldrh	w1, [x0, -8]
	cmp	w1, w26
	bne	.L2887
.L2888:
	ubfiz	w20, w20, 7, 9
	msub	w25, w26, w20, w25
	and	x25, x25, 65535
	cbnz	w24, .L2889
	add	x0, x21, :lo12:.LANCHOR132
	add	x0, x0, x19, lsl 4
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x25, lsl 2]
	str	w0, [x23]
.L2890:
	add	x21, x21, :lo12:.LANCHOR132
	add	x19, x21, x19, lsl 4
	ldrh	w0, [x19, 2]
	mvn	x1, x0
	tst	x1, 32767
	beq	.L2894
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L2894:
	mov	w0, 0
	b	.L2884
.L2889:
	add	x0, x21, :lo12:.LANCHOR132
	ldr	w2, [x23]
	add	x0, x0, x19, lsl 4
	ldr	x1, [x0, 8]
	str	w2, [x1, x25, lsl 2]
	ldrh	w1, [x0, 2]
	orr	w1, w1, -32768
	strh	w1, [x0, 2]
	adrp	x0, .LANCHOR133
	strb	w22, [x0, #:lo12:.LANCHOR133]
	b	.L2890
.L2887:
	add	w19, w19, 1
	add	x0, x0, 16
	and	x19, x19, 65535
	cmp	w19, 32
	bne	.L2891
	bl	pm_select_ram_region
	and	x19, x0, 65535
	sbfiz	x1, x19, 4, 32
	add	x2, x21, :lo12:.LANCHOR132
	add	x3, x2, x1
	mov	w27, w0
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L2892
	ldrsh	w1, [x3, 2]
	tbz	w1, #31, .L2892
	bl	pm_flush_id
.L2892:
	adrp	x0, .LANCHOR205
	mov	w1, w27
	strb	w19, [x0, #:lo12:.LANCHOR205]
	mov	w0, w26
	bl	load_l2p_region
	b	.L2888
	.size	pm_log2phys, .-pm_log2phys
	.section	.text.gc_recovery,"ax",@progbits
	.align	2
	.global	gc_recovery
	.type	gc_recovery, %function
gc_recovery:
	sub	sp, sp, #240
	adrp	x0, .LANCHOR76
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	stp	x21, x22, [sp, 64]
	adrp	x21, .LANCHOR10
	stp	x19, x20, [sp, 48]
	ldr	x20, [x21, #:lo12:.LANCHOR10]
	strb	wzr, [x0, #:lo12:.LANCHOR76]
	adrp	x0, .LANCHOR150
	stp	x23, x24, [sp, 80]
	strb	wzr, [x0, #:lo12:.LANCHOR150]
	stp	x25, x26, [sp, 96]
	stp	x27, x28, [sp, 112]
	bl	gc_init
	add	x0, x20, 80
	ldrh	w1, [x20, 80]
	str	x0, [x29, 176]
	mov	w0, 65535
	cmp	w1, w0
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	beq	.L2901
	mov	w1, -1
	strh	w1, [x0, 130]
	mov	w0, 1
	bl	buf_alloc
	mov	x26, x0
	ldrb	w0, [x20, 89]
	add	x1, x20, 80
	adrp	x3, .LANCHOR103
	adrp	x2, .LANCHOR71
	sub	w0, w0, #1
	str	x3, [x29, 152]
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x3, #:lo12:.LANCHOR103]
	str	x2, [x29, 168]
	ldrh	w0, [x0, 16]
	mul	w1, w0, w1
	ldrb	w0, [x2, #:lo12:.LANCHOR71]
	str	w1, [x29, 200]
	cmp	w0, 3
	bne	.L2902
	adrp	x0, .LANCHOR85
	ldrh	w0, [x0, #:lo12:.LANCHOR85]
	sub	w0, w0, #1
	add	w0, w0, w1
	orr	w0, w0, 50331648
.L2946:
	str	w0, [x26, 40]
.L2903:
	mov	w1, 1
	mov	x0, x26
	bl	sblk_read_page
	ldr	w0, [x26, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2904
	ldr	x0, [x26, 24]
	ldr	w1, [x0]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	cmp	w1, w0
	beq	.L2905
.L2904:
	mov	x0, x26
	bl	buf_free
	ldr	x1, [x26, 24]
	ldr	x0, [x26, 8]
	ldr	w2, [x1, 12]
	str	w2, [sp, 16]
	ldr	w2, [x1, 8]
	str	w2, [sp, 8]
	ldr	w2, [x1, 4]
	str	w2, [sp]
	ldp	w3, w4, [x0]
	ldp	w5, w6, [x0, 8]
	adrp	x0, .LC193
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC193
	ldr	w1, [x26, 40]
	ldr	w2, [x26, 52]
	bl	printf
.L2950:
	adrp	x0, .LANCHOR9
	ldrh	w1, [x20, 80]
	mov	w22, 0
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x1, lsl 1]
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	ldrh	w1, [x20, 80]
	strh	w1, [x0, 130]
.L2906:
	ldrh	w0, [x20, 80]
	bl	ftl_dump_write_open_sblk
	ldrh	w1, [x20, 80]
	mov	w2, w22
	adrp	x0, .LC195
	add	x0, x0, :lo12:.LC195
	bl	printf
	mov	w0, -1
	strh	w0, [x20, 80]
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	mov	w1, 65535
	ldrh	w0, [x0, 130]
	cmp	w0, w1
	beq	.L2933
	bl	ftl_free_sblk
.L2933:
	adrp	x0, .LANCHOR102
	ldr	x1, [x0, #:lo12:.LANCHOR102]
	mov	w0, -1
	strh	w0, [x1, 126]
	ldr	x1, [x21, #:lo12:.LANCHOR10]
	strh	w0, [x1, 130]
	mov	w0, 0
	bl	ftl_info_flush
.L2900:
	ldp	x19, x20, [sp, 48]
	ldp	x21, x22, [sp, 64]
	ldp	x23, x24, [sp, 80]
	ldp	x25, x26, [sp, 96]
	ldp	x27, x28, [sp, 112]
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 240
	ret
.L2902:
	cmp	w0, 2
	bne	.L2903
	adrp	x0, .LANCHOR85
	ldrh	w0, [x0, #:lo12:.LANCHOR85]
	add	w0, w1, w0, lsl 1
	sub	w0, w0, #1
	orr	w0, w0, 33554432
	b	.L2946
.L2905:
	adrp	x28, .LANCHOR77
	adrp	x22, .LANCHOR78
	adrp	x27, .LANCHOR152
	ldr	x1, [x26, 8]
	ldrb	w0, [x22, #:lo12:.LANCHOR78]
	adrp	x24, .LANCHOR153
	ldrh	w2, [x28, #:lo12:.LANCHOR77]
	mul	w2, w2, w0
	ldr	x0, [x27, #:lo12:.LANCHOR152]
	lsl	w2, w2, 2
	bl	ftl_memcpy
	ldrb	w1, [x22, #:lo12:.LANCHOR78]
	ldrh	w0, [x28, #:lo12:.LANCHOR77]
	mul	w0, w0, w1
	ldr	x1, [x26, 8]
	lsl	w2, w0, 2
	add	x1, x1, x0, sxtw 2
	ldr	x0, [x24, #:lo12:.LANCHOR153]
	bl	ftl_memcpy
	str	x28, [x29, 144]
	adrp	x0, .LANCHOR85
	ldrh	w14, [x0, #:lo12:.LANCHOR85]
	ldr	x0, [x29, 168]
	ldrb	w0, [x0, #:lo12:.LANCHOR71]
	cmp	w0, 2
	beq	.L2907
.L2947:
	str	w0, [x29, 184]
	adrp	x25, .LC194
	ldr	x0, [x29, 152]
	mov	w23, 0
	mov	w22, 0
	add	x0, x0, :lo12:.LANCHOR103
	str	x0, [x29, 128]
	add	x0, x25, :lo12:.LC194
	str	x0, [x29, 120]
.L2909:
	sub	w0, w23, #1
	str	w0, [x29, 188]
	cmp	w23, w14
	beq	.L2918
	mov	x19, 0
	b	.L2919
.L2907:
	lsl	w14, w14, 1
	mov	w0, 1
	b	.L2947
.L2915:
	ldr	x1, [x29, 128]
	ldr	x0, [x29, 160]
	ldrh	w1, [x1]
	ldrh	w0, [x0, 96]
	mul	w0, w0, w1
	ldr	x1, [x29, 136]
	str	w0, [x29, 200]
	ldrb	w1, [x1]
	cmp	w1, 3
	bne	.L2910
	add	w0, w23, w0
	orr	w0, w0, w25, lsl 24
.L2948:
	str	w0, [x26, 40]
	mov	w1, 1
	str	w14, [x29, 112]
	mov	x0, x26
	bl	sblk_read_page
	ldr	x0, [x27, #:lo12:.LANCHOR152]
	ldr	w14, [x29, 112]
	ldr	w3, [x0, x28]
	ldr	x0, [x26, 24]
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bne	.L2913
	ldr	x1, [x24, #:lo12:.LANCHOR153]
	ldr	w2, [x1, x28]
	ldr	w1, [x0, 8]
	cmp	w2, w1
	beq	.L2914
.L2913:
	ldr	x1, [x24, #:lo12:.LANCHOR153]
	ldr	w2, [x0, 12]
	str	w2, [sp]
	str	w14, [x29, 112]
	ldr	w4, [x1, x28]
	ldr	w5, [x0]
	ldr	w7, [x0, 8]
	ldr	w1, [x26, 40]
	ldr	w2, [x26, 52]
	ldr	x0, [x29, 120]
	bl	printf
	ldr	x0, [x27, #:lo12:.LANCHOR152]
	ldr	w14, [x29, 112]
	ldr	w0, [x0, x28]
	cmn	w0, #1
	beq	.L2914
	mov	x0, x26
	bl	buf_free
	b	.L2950
.L2910:
	cmp	w1, 2
	bne	.L2912
	ldr	w1, [x29, 188]
	add	w0, w0, w1
	add	w0, w0, w25
	orr	w0, w0, 33554432
	b	.L2948
.L2912:
	add	w0, w23, w0
	b	.L2948
.L2914:
	add	w22, w22, 1
	add	w25, w25, 1
	add	x28, x28, 4
.L2917:
	ldr	w0, [x29, 184]
	cmp	w0, w25
	bcs	.L2915
	add	x19, x19, 1
.L2919:
	ldr	x0, [x29, 176]
	ldrb	w0, [x0, 9]
	cmp	w0, w19
	ble	.L2916
	add	x0, x20, x19, lsl 1
	str	x0, [x29, 160]
	ldr	x0, [x29, 168]
	sbfiz	x28, x22, 2, 32
	mov	w25, 1
	add	x0, x0, :lo12:.LANCHOR71
	str	x0, [x29, 136]
	b	.L2917
.L2916:
	add	w23, w23, 1
	b	.L2909
.L2918:
	mov	x0, x26
	bl	buf_free
	ldr	x3, [x29, 144]
	adrp	x25, .LANCHOR9
	ldr	x0, [x29, 176]
	mov	w22, 0
	ldrh	w2, [x20, 80]
	mov	w28, 0
	ldr	x1, [x25, #:lo12:.LANCHOR9]
	ldrh	w3, [x3, #:lo12:.LANCHOR77]
	ldrb	w0, [x0, 9]
	str	x25, [x29, 144]
	str	wzr, [x29, 188]
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	adrp	x0, .LANCHOR66
	add	x0, x0, :lo12:.LANCHOR66
	str	x0, [x29, 112]
.L2920:
	sub	w0, w28, #1
	str	w0, [x29, 136]
	cmp	w23, w28
	beq	.L2931
	mov	x26, 0
	b	.L2932
.L2928:
	ldr	w0, [x29, 188]
	ldr	x1, [x27, #:lo12:.LANCHOR152]
	sbfiz	x0, x0, 2, 32
	ldr	w5, [x1, x0]
	cmn	w5, #1
	beq	.L2921
	ldr	x1, [x24, #:lo12:.LANCHOR153]
	str	w5, [x29, 108]
	ldr	w0, [x1, x0]
	str	w0, [x29, 160]
	mov	w0, w5
	bl	lpa_hash_get_ppa
	str	w0, [x29, 204]
	cmn	w0, #1
	ldr	w5, [x29, 108]
	bne	.L2922
	mov	w0, w5
	str	w5, [x29, 108]
	mov	w2, 0
	add	x1, x29, 204
	bl	pm_log2phys
	ldr	w5, [x29, 108]
.L2922:
	ldr	x0, [x29, 128]
	ldr	x1, [x29, 152]
	ldrh	w0, [x0, 96]
	ldrh	w1, [x1, #:lo12:.LANCHOR103]
	mul	w0, w0, w1
	ldr	x1, [x29, 168]
	ldrb	w1, [x1, #:lo12:.LANCHOR71]
	cmp	w1, 3
	bne	.L2923
	add	w0, w28, w0
	orr	w0, w0, w25, lsl 24
.L2949:
	str	w0, [x29, 200]
	mov	w19, 21
	ldr	x0, [x29, 112]
	mov	w2, 1
	ldr	w1, [x29, 160]
	ldrh	w0, [x0]
	sub	w19, w19, w0
	lsr	w0, w1, w0
	lsl	w19, w2, w19
	sub	w19, w19, #1
	and	w19, w19, w0
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	udiv	w19, w19, w0
	ldr	w0, [x29, 204]
	cmp	w1, w0
	and	x19, x19, 65535
	bne	.L2926
	add	x1, x29, 200
	mov	w0, w5
	bl	pm_log2phys
	add	w22, w22, 1
	mov	w0, w19
	bl	ftl_vpn_decrement
.L2927:
	ldr	w0, [x29, 188]
	add	w0, w0, 1
	str	w0, [x29, 188]
	adrp	x0, .LANCHOR7
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x0, x0, x19, lsl 2
	ldrb	w0, [x0, 2]
	tst	w0, 224
	bne	.L2921
	ldr	x0, [x29, 144]
	lsl	x19, x19, 1
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, x19]
	cbz	w1, .L2921
	strh	wzr, [x0, x19]
.L2921:
	add	w25, w25, 1
.L2930:
	ldr	w0, [x29, 184]
	cmp	w0, w25
	bcs	.L2928
	add	x26, x26, 1
.L2932:
	ldr	x0, [x29, 176]
	ldrb	w0, [x0, 9]
	cmp	w0, w26
	ble	.L2929
	add	x0, x20, x26, lsl 1
	mov	w25, 1
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR67
	add	x0, x0, :lo12:.LANCHOR67
	str	x0, [x29, 120]
	b	.L2930
.L2923:
	cmp	w1, 2
	bne	.L2925
	ldr	w1, [x29, 136]
	add	w0, w0, w1
	add	w0, w0, w25
	orr	w0, w0, 33554432
	b	.L2949
.L2925:
	add	w0, w28, w0
	b	.L2949
.L2926:
	ldr	w1, [x29, 200]
	cmp	w0, w1
	cinc	w22, w22, eq
	b	.L2927
.L2929:
	add	w28, w28, 1
	b	.L2920
.L2931:
	ldr	x0, [x29, 144]
	ldrh	w1, [x20, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	w22, [x0, x1, lsl 1]
	ldrh	w0, [x20, 80]
	bl	zftl_insert_data_list
	b	.L2906
.L2901:
	ldrh	w0, [x0, 130]
	cmp	w0, w1
	beq	.L2900
	adrp	x19, .LANCHOR102
	ldr	x1, [x19, #:lo12:.LANCHOR102]
	ldrh	w1, [x1, 126]
	cmp	w1, w0
	bne	.L2935
	bl	pm_flush
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	ldrh	w0, [x0, 130]
	bl	ftl_free_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR102]
	mov	w1, -1
	strh	w1, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
.L2935:
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	mov	w1, -1
	strh	w1, [x0, 130]
	b	.L2900
	.size	gc_recovery, .-gc_recovery
	.section	.text.zftl_init,"ax",@progbits
	.align	2
	.global	zftl_init
	.type	zftl_init, %function
zftl_init:
	stp	x29, x30, [sp, -112]!
	adrp	x1, .LANCHOR57
	mov	w0, -1
	add	x29, sp, 0
	strb	w0, [x1, #:lo12:.LANCHOR57]
	adrp	x1, .LANCHOR58
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR85
	strb	wzr, [x1, #:lo12:.LANCHOR58]
	adrp	x1, .LANCHOR126
	stp	x19, x20, [sp, 16]
	adrp	x21, .LANCHOR78
	strb	w0, [x1, #:lo12:.LANCHOR126]
	adrp	x1, .LANCHOR127
	stp	x23, x24, [sp, 48]
	adrp	x20, .LANCHOR203
	strb	wzr, [x1, #:lo12:.LANCHOR127]
	adrp	x1, .LANCHOR174
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR6
	strb	w0, [x1, #:lo12:.LANCHOR174]
	adrp	x0, .LANCHOR121
	mov	w1, -1
	stp	x27, x28, [sp, 80]
	strb	wzr, [x0, #:lo12:.LANCHOR121]
	adrp	x0, .LANCHOR206
	str	w1, [x0, #:lo12:.LANCHOR206]
	adrp	x1, .LC196
	adrp	x0, .LC97
	add	x1, x1, :lo12:.LC196
	add	x0, x0, :lo12:.LC97
	bl	printf
	adrp	x1, .LANCHOR31
	add	x1, x1, :lo12:.LANCHOR31
	adrp	x0, .LANCHOR71
	adrp	x2, .LANCHOR123
	adrp	x3, .LANCHOR77
	adrp	x4, .LANCHOR67
	ldrb	w5, [x1, 12]
	strb	w5, [x0, #:lo12:.LANCHOR71]
	ldrb	w0, [x1, 9]
	strb	w0, [x2, #:lo12:.LANCHOR123]
	ldrh	w2, [x1, 10]
	strh	w2, [x3, #:lo12:.LANCHOR77]
	adrp	x3, .LANCHOR18
	ldrh	w7, [x1, 14]
	ubfiz	w10, w0, 9, 7
	ldrb	w6, [x3, #:lo12:.LANCHOR18]
	adrp	x3, .LANCHOR104
	sdiv	w8, w2, w5
	strh	w7, [x23, #:lo12:.LANCHOR6]
	strb	w6, [x3, #:lo12:.LANCHOR104]
	ldrb	w3, [x1, 13]
	adrp	x1, .LANCHOR2
	strb	w3, [x4, #:lo12:.LANCHOR67]
	ldrh	w4, [x1, #:lo12:.LANCHOR2]
	adrp	x1, .LANCHOR103
	strh	w8, [x22, #:lo12:.LANCHOR85]
	mul	w6, w6, w3
	strh	w4, [x1, #:lo12:.LANCHOR103]
	strh	w10, [x20, #:lo12:.LANCHOR203]
	mov	w3, 1
	and	w6, w6, 255
	mov	w1, 0
	strb	w6, [x21, #:lo12:.LANCHOR78]
.L2952:
	cmp	w4, w3
	bcs	.L2953
	mul	w2, w0, w2
	adrp	x3, .LANCHOR66
	sub	w1, w1, #1
	mov	w4, 0
	strh	w1, [x3, #:lo12:.LANCHOR66]
	mov	w1, 1
	mul	w3, w2, w7
	lsr	w11, w3, 21
.L2954:
	cmp	w11, w1
	bcs	.L2955
	mov	w1, 57344
	sub	w4, w4, #1
	movk	w1, 0x1c, lsl 16
	mul	w3, w3, w6
	adrp	x28, .LANCHOR120
	sub	w11, w10, #1
	mul	w1, w6, w1
	adrp	x24, .LANCHOR187
	mul	w8, w8, w6
	adrp	x27, .LANCHOR208
	mul	w2, w2, w6
	adrp	x26, .LANCHOR146
	lsl	w1, w1, w4
	adrp	x4, .LANCHOR59
	sub	w2, w2, #1
	adrp	x25, .LANCHOR89
	str	w1, [x4, #:lo12:.LANCHOR59]
	adrp	x4, .LANCHOR207
	str	w3, [x4, #:lo12:.LANCHOR207]
	add	w3, w1, 24576
	str	w3, [x27, #:lo12:.LANCHOR208]
	udiv	w0, w3, w0
	udiv	w3, w3, w2
	adrp	x2, .LANCHOR117
	str	w0, [x28, #:lo12:.LANCHOR120]
	add	w0, w11, w0, lsl 2
	add	w3, w3, 8
	udiv	w0, w0, w10
	strh	w0, [x24, #:lo12:.LANCHOR187]
	ubfiz	w0, w0, 4, 16
	sdiv	w0, w0, w8
	adrp	x8, .LANCHOR93
	str	x8, [x29, 104]
	strh	w3, [x8, #:lo12:.LANCHOR93]
	strh	w0, [x26, #:lo12:.LANCHOR146]
	add	w0, w7, w7, lsl 1
	asr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR117]
	lsr	w0, w7, 4
	strh	w0, [x25, #:lo12:.LANCHOR89]
	cmp	w0, 79
	bhi	.L2956
	mov	w0, 80
	strh	w0, [x25, #:lo12:.LANCHOR89]
.L2956:
	adrp	x7, .LANCHOR118
	mov	w0, 2000
	adrp	x3, .LANCHOR116
	adrp	x6, .LANCHOR145
	strh	w0, [x7, #:lo12:.LANCHOR118]
	mov	w0, 50
	adrp	x2, .LANCHOR144
	strh	w0, [x3, #:lo12:.LANCHOR116]
	mov	w0, 256
	strh	w0, [x6, #:lo12:.LANCHOR145]
	mov	w0, 48
	strh	w0, [x2, #:lo12:.LANCHOR144]
	adrp	x0, .LANCHOR8
	mov	w8, 32
	cmp	w5, 2
	strh	w8, [x0, #:lo12:.LANCHOR8]
	beq	.L2957
	adrp	x5, .LANCHOR75
	ldrb	w5, [x5, #:lo12:.LANCHOR75]
	cbz	w5, .L2958
.L2957:
	mov	w5, 150
	strh	w5, [x3, #:lo12:.LANCHOR116]
	mov	w3, 64
	strh	w3, [x2, #:lo12:.LANCHOR144]
	mov	w2, 12
	strh	w2, [x0, #:lo12:.LANCHOR8]
	adrp	x2, .LANCHOR0
	ldrb	w2, [x2, #:lo12:.LANCHOR0]
	cbnz	w2, .L2958
	mov	w2, 4
	strh	w2, [x0, #:lo12:.LANCHOR8]
	mov	w0, 600
	strh	w0, [x7, #:lo12:.LANCHOR118]
	mov	w0, 128
	strh	w0, [x6, #:lo12:.LANCHOR145]
.L2958:
	adrp	x19, .LANCHOR14
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2960
	str	x4, [x29, 96]
	adrp	x0, .LC197
	add	x0, x0, :lo12:.LC197
	bl	printf
	ldr	x4, [x29, 96]
.L2960:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2961
	ldr	w1, [x4, #:lo12:.LANCHOR207]
	adrp	x0, .LC198
	add	x0, x0, :lo12:.LC198
	bl	printf
.L2961:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2962
	ldr	w1, [x28, #:lo12:.LANCHOR120]
	adrp	x0, .LC199
	add	x0, x0, :lo12:.LC199
	bl	printf
.L2962:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2963
	ldr	w1, [x27, #:lo12:.LANCHOR208]
	adrp	x0, .LC200
	add	x0, x0, :lo12:.LC200
	bl	printf
.L2963:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2964
	ldrh	w1, [x24, #:lo12:.LANCHOR187]
	adrp	x0, .LC201
	add	x0, x0, :lo12:.LC201
	bl	printf
.L2964:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2965
	ldrh	w1, [x20, #:lo12:.LANCHOR203]
	adrp	x0, .LC202
	add	x0, x0, :lo12:.LC202
	bl	printf
.L2965:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2966
	ldrh	w1, [x26, #:lo12:.LANCHOR146]
	adrp	x0, .LC203
	add	x0, x0, :lo12:.LC203
	bl	printf
.L2966:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2967
	ldrh	w1, [x25, #:lo12:.LANCHOR89]
	adrp	x0, .LC204
	add	x0, x0, :lo12:.LC204
	bl	printf
.L2967:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2968
	ldr	x0, [x29, 104]
	ldrh	w1, [x0, #:lo12:.LANCHOR93]
	adrp	x0, .LC205
	add	x0, x0, :lo12:.LC205
	bl	printf
.L2968:
	bl	buf_init
	adrp	x25, .LANCHOR10
	ldrh	w1, [x23, #:lo12:.LANCHOR6]
	mov	w0, 6
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR4
	str	x0, [x1, #:lo12:.LANCHOR4]
	ldrb	w1, [x21, #:lo12:.LANCHOR78]
	ldrh	w0, [x22, #:lo12:.LANCHOR85]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR110
	adrp	x2, ftl_ext_info_data_buffer
	add	x2, x2, :lo12:ftl_ext_info_data_buffer
	str	x0, [x1, #:lo12:.LANCHOR110]
	adrp	x0, .LANCHOR109
	ldrh	w1, [x22, #:lo12:.LANCHOR85]
	str	x2, [x0, #:lo12:.LANCHOR109]
	ldrb	w0, [x21, #:lo12:.LANCHOR78]
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
	tbz	x0, 12, .L2969
	adrp	x0, .LC206
	add	x0, x0, :lo12:.LC206
	bl	printf
.L2969:
	ldrh	w0, [x22, #:lo12:.LANCHOR85]
	ldrb	w21, [x21, #:lo12:.LANCHOR78]
	ldrh	w1, [x23, #:lo12:.LANCHOR6]
	ldrh	w22, [x24, #:lo12:.LANCHOR187]
	mul	w21, w0, w21
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	add	w21, w1, w21, lsl 2
	lsl	w1, w1, 2
	lsl	w21, w21, 1
	add	w22, w1, w22, lsl 2
	add	w21, w21, 632
	add	w22, w22, 704
	tbz	x0, 12, .L2970
	ldrh	w3, [x20, #:lo12:.LANCHOR203]
	adrp	x0, .LC207
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC207
	bl	printf
.L2970:
	ldrh	w0, [x20, #:lo12:.LANCHOR203]
	cmp	w21, w0
	bhi	.L2971
	cmp	w22, w0
	bls	.L2972
.L2971:
.L3015:
	b	.L3015
.L2953:
	add	w1, w1, 1
	lsl	w3, w3, 1
	and	w1, w1, 65535
	b	.L2952
.L2955:
	add	w4, w4, 1
	lsl	w1, w1, 1
	and	w4, w4, 65535
	b	.L2954
.L2972:
	bl	sblk_init
	bl	ftl_info_blk_init
	cmn	w0, #1
	beq	.L2951
	bl	ftl_ext_info_init
	adrp	x19, .LANCHOR102
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
	ldr	x1, [x19, #:lo12:.LANCHOR102]
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
	adrp	x0, .LANCHOR182
	ldrb	w0, [x0, #:lo12:.LANCHOR182]
	cbz	w0, .L2974
	ldr	x1, [x19, #:lo12:.LANCHOR102]
	ldr	w0, [x1, 68]
	add	w0, w0, 1
	str	w0, [x1, 68]
.L2974:
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	print_ftl_debug_info
	mov	w0, 0
.L2951:
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
	cbnz	w0, .L3019
	bl	zftl_init
.L3019:
	mov	w19, w0
	bl	idb_init
	mov	w1, w19
	adrp	x0, .LC208
	add	x0, x0, :lo12:.LC208
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
	adrp	x1, .LANCHOR77
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	ldr	x21, [x0, #:lo12:.LANCHOR10]
	stp	x25, x26, [sp, 64]
	ldrh	w26, [x1, #:lo12:.LANCHOR77]
	add	x1, x21, 80
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR14
	stp	x19, x20, [sp, 16]
	stp	x27, x28, [sp, 80]
	stp	x0, x1, [x29, 128]
	ldrb	w1, [x1, 9]
	mul	w26, w26, w1
	ldr	w1, [x24, #:lo12:.LANCHOR14]
	tbz	x1, 8, .L3022
	ldrh	w1, [x21, 80]
	adrp	x0, .LC209
	add	x0, x0, :lo12:.LC209
	bl	printf
.L3022:
	adrp	x23, .LANCHOR9
	ldrh	w1, [x21, 80]
	sub	w2, w26, #1
	mov	x22, 0
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	mov	w25, 0
	strh	w2, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR123
	add	x0, x0, :lo12:.LANCHOR123
	str	x0, [x29, 104]
.L3023:
	mov	w28, w22
	cmp	w26, w22
	bhi	.L3033
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3034
	ldr	x0, [x29, 128]
	mov	w3, w25
	ldr	x1, [x23, #:lo12:.LANCHOR9]
	ldrh	w2, [x21, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrh	w2, [x1, x2, lsl 1]
	ldrh	w1, [x0, 80]
	adrp	x0, .LC212
	add	x0, x0, :lo12:.LC212
	bl	printf
.L3034:
	ldrh	w1, [x21, 80]
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, x1, lsl 1]
	cmp	w25, w0
	beq	.L3035
	adrp	x1, .LANCHOR209
	adrp	x0, .LC0
	mov	w2, 617
	add	x1, x1, :lo12:.LANCHOR209
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3035:
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
.L3033:
	adrp	x27, .LANCHOR152
	lsl	x19, x22, 2
	ldr	x0, [x27, #:lo12:.LANCHOR152]
	ldr	w2, [x0, x19]
	cmn	w2, #1
	beq	.L3024
	adrp	x0, .LANCHOR123
	ldrb	w20, [x0, #:lo12:.LANCHOR123]
	lsl	w20, w20, 7
	udiv	w20, w2, w20
	and	w0, w20, 65535
	str	w0, [x29, 156]
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3025
	ldr	w1, [x29, 156]
	adrp	x0, .LC210
	mov	w3, w22
	add	x0, x0, :lo12:.LC210
	bl	printf
.L3025:
	sub	w28, w26, w28
	add	x28, x28, x22
	lsl	x0, x28, 2
	str	x0, [x29, 144]
	adrp	x0, .LC211
	add	x0, x0, :lo12:.LC211
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR66
	add	x0, x0, :lo12:.LANCHOR66
	str	x0, [x29, 112]
.L3026:
	ldr	x0, [x29, 144]
	cmp	x0, x19
	bne	.L3032
.L3024:
	add	x22, x22, 1
	b	.L3023
.L3032:
	ldr	x0, [x27, #:lo12:.LANCHOR152]
	ldr	w20, [x0, x19]
	cmn	w20, #1
	beq	.L3027
	ldr	x0, [x29, 104]
	ldr	w1, [x29, 156]
	ldrb	w0, [x0]
	lsl	w0, w0, 7
	udiv	w0, w20, w0
	cmp	w1, w0, uxth
	bne	.L3027
	adrp	x0, .LANCHOR153
	ldr	x0, [x0, #:lo12:.LANCHOR153]
	ldr	w28, [x0, x19]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 172]
	cmn	w0, #1
	bne	.L3028
	mov	w2, 0
	add	x1, x29, 172
	mov	w0, w20
	bl	pm_log2phys
.L3028:
	ldr	w3, [x29, 172]
	cmp	w28, w3
	bne	.L3029
	adrp	x0, .LANCHOR154
	mov	w2, 1
	add	x1, x29, 168
	add	w25, w25, 1
	ldr	x0, [x0, #:lo12:.LANCHOR154]
	ldr	w0, [x0, x19]
	str	w0, [x29, 168]
	mov	w0, w20
	bl	pm_log2phys
	ldr	x0, [x29, 112]
	ldrh	w1, [x0]
	mov	w0, 21
	sub	w2, w0, w1
	mov	w0, 1
	lsr	w28, w28, w1
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w28, w0, w28
	adrp	x0, .LANCHOR67
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	udiv	w0, w28, w0
.L3055:
	bl	ftl_vpn_decrement
	ldr	x0, [x27, #:lo12:.LANCHOR152]
	mov	w1, -1
	str	w1, [x0, x19]
.L3027:
	add	x19, x19, 4
	b	.L3026
.L3029:
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3031
	ldr	x0, [x29, 120]
	mov	w2, w28
	mov	w1, w20
	bl	printf
.L3031:
	ldr	x0, [x29, 136]
	ldrh	w0, [x0]
	b	.L3055
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
	adrp	x19, .LANCHOR63
	add	x1, x19, :lo12:.LANCHOR63
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	adrp	x20, .LANCHOR78
	stp	x25, x26, [sp, 64]
	ldrb	w6, [x20, #:lo12:.LANCHOR78]
	ldrb	w0, [x1, 4]
	add	x2, x1, x0, sxtw 1
	ldrh	w21, [x2, 40]
	ldrh	w2, [x1, 2]
.L3057:
	cmp	w21, w5
	beq	.L3059
	cbz	w4, .L3060
	add	x1, x19, :lo12:.LANCHOR63
	strh	w2, [x1, 2]
.L3060:
	cbz	w3, .L3061
	add	x1, x19, :lo12:.LANCHOR63
	strb	w0, [x1, 4]
.L3061:
	mov	w0, 1
	adrp	x22, .LANCHOR103
	bl	buf_alloc
	adrp	x23, .LANCHOR71
	mov	x24, x0
	add	x22, x22, :lo12:.LANCHOR103
	add	x23, x23, :lo12:.LANCHOR71
	mov	w26, 1
.L3062:
	add	x25, x19, :lo12:.LANCHOR63
	ldrb	w1, [x25, 6]
	cmp	w26, w1
	ble	.L3070
	mov	x0, x24
	bl	buf_free
	ldrb	w0, [x25, 4]
	ldrb	w1, [x20, #:lo12:.LANCHOR78]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x25, 4]
	cmp	w1, w0
	bne	.L3056
	ldrh	w0, [x25, 2]
	strb	wzr, [x25, 4]
	add	w0, w0, 1
	strh	w0, [x25, 2]
.L3056:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L3059:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, w6
	bne	.L3058
	add	w2, w2, 1
	mov	w0, 0
	and	w2, w2, 65535
	mov	w4, 1
.L3058:
	add	x3, x1, x0, sxtw 1
	ldrh	w21, [x3, 40]
	mov	w3, 1
	b	.L3057
.L3070:
	ldrh	w0, [x22]
	cmp	w1, 3
	mul	w2, w0, w21
	ldrh	w0, [x25, 2]
	bne	.L3063
	add	w0, w0, w2
	orr	w0, w0, w26, lsl 24
.L3079:
	str	w0, [x24, 40]
	mov	w1, 1
	mov	x0, x24
	bl	sblk_read_page
	ldr	w0, [x24, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L3067
	ldr	x0, [x24, 24]
	ldr	w25, [x0, 4]
	mov	w0, w25
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L3068
	adrp	x0, .LANCHOR120
	ldr	w0, [x0, #:lo12:.LANCHOR120]
	cmp	w25, w0
	bcs	.L3068
	mov	w2, 0
	add	x1, x29, 92
	mov	w0, w25
	bl	pm_log2phys
.L3068:
	ldr	w2, [x24, 40]
	ldr	w0, [x29, 92]
	cmp	w2, w0
	bne	.L3067
	add	x1, x19, :lo12:.LANCHOR63
	adrp	x4, .LANCHOR68
	ldr	x4, [x4, #:lo12:.LANCHOR68]
	ldrh	w0, [x1, 24]
	ubfiz	x3, x0, 2, 16
	add	w0, w0, 1
	str	w2, [x4, x3]
	strh	w0, [x1, 24]
.L3067:
	add	x1, x19, :lo12:.LANCHOR63
	add	w26, w26, 1
	ldrh	w0, [x1, 26]
	add	w0, w0, 1
	strh	w0, [x1, 26]
	b	.L3062
.L3063:
	cmp	w1, 2
	bne	.L3065
	lsl	w0, w0, 1
	sub	w1, w0, #1
	add	w0, w26, w2
	add	w0, w1, w0
	ldrb	w1, [x23]
	orr	w0, w0, w1, lsl 24
	b	.L3079
.L3065:
	add	w0, w0, w2
	b	.L3079
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
	adrp	x19, .LANCHOR63
	stp	x21, x22, [sp, 32]
	ldrh	w1, [x19, #:lo12:.LANCHOR63]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w1, w0
	bne	.L3081
	adrp	x1, .LANCHOR210
	adrp	x0, .LC0
	mov	w2, 1052
	add	x1, x1, :lo12:.LANCHOR210
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3081:
	ldrh	w1, [x19, #:lo12:.LANCHOR63]
	mov	w0, 65535
	cmp	w1, w0
	beq	.L3101
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3083
	adrp	x2, .LANCHOR9
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC213
	add	x0, x0, :lo12:.LC213
	bl	printf
.L3083:
	ldrh	w0, [x19, #:lo12:.LANCHOR63]
	add	x14, x19, :lo12:.LANCHOR63
	add	x1, x14, 40
	bl	ftl_get_blk_list_in_sblk
	and	w1, w0, 255
	strb	w1, [x14, 5]
	cbnz	w1, .L3084
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR63]
.L3101:
	mov	w0, 0
	b	.L3080
.L3084:
	adrp	x4, .LANCHOR7
	ldrh	w3, [x19, #:lo12:.LANCHOR63]
	mov	x22, x4
	ldr	x1, [x4, #:lo12:.LANCHOR7]
	mov	x2, x3
	add	x1, x1, x3, lsl 2
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 32
	beq	.L3085
	cmp	w1, 224
	beq	.L3085
	cbz	w1, .L3086
	adrp	x1, .LANCHOR10
	ldr	x1, [x1, #:lo12:.LANCHOR10]
	ldrh	w3, [x1, 16]
	cmp	w3, w2
	beq	.L3085
	ldrh	w3, [x1, 48]
	cmp	w3, w2
	beq	.L3085
	ldrh	w1, [x1, 80]
	cmp	w1, w2
	bne	.L3115
.L3085:
	add	x0, x19, :lo12:.LANCHOR63
	mov	w1, -1
	strh	w1, [x19, #:lo12:.LANCHOR63]
	strh	wzr, [x0, 24]
	b	.L3101
.L3086:
	adrp	x0, .LANCHOR9
	mov	x20, x0
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x1, x3, lsl 1]
	cbz	w1, .L3088
	adrp	x1, .LANCHOR210
	adrp	x0, .LC0
	mov	w2, 1072
	add	x1, x1, :lo12:.LANCHOR210
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3088:
	ldrh	w1, [x19, #:lo12:.LANCHOR63]
	ldr	x0, [x20, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x1, lsl 1]
	b	.L3085
.L3115:
	and	w0, w0, 255
	sub	w0, w0, #1
	add	x0, x14, x0, sxtw 1
	ldrh	w21, [x0, 40]
	mov	w0, 65535
	cmp	w21, w0
	bne	.L3089
	adrp	x1, .LANCHOR210
	adrp	x0, .LC0
	mov	w2, 1080
	add	x1, x1, :lo12:.LANCHOR210
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3089:
	adrp	x1, .LANCHOR103
	ldr	x3, [x22, #:lo12:.LANCHOR7]
	adrp	x2, .LANCHOR85
	adrp	x23, .LANCHOR77
	ldrh	w20, [x1, #:lo12:.LANCHOR103]
	mov	x24, x2
	ldrh	w1, [x19, #:lo12:.LANCHOR63]
	ldrh	w0, [x2, #:lo12:.LANCHOR85]
	add	x1, x3, x1, lsl 2
	sub	w0, w0, #1
	and	w0, w0, 65535
	mul	w20, w20, w21
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 160
	bne	.L3102
	adrp	x1, .LANCHOR71
	ldrb	w21, [x1, #:lo12:.LANCHOR71]
	cmp	w21, 2
	orr	w20, w20, w21, lsl 24
	beq	.L3091
	and	w21, w21, 65535
.L3090:
	add	x22, x19, :lo12:.LANCHOR63
	orr	w20, w0, w20
	mov	w0, 1
	strb	w21, [x22, 6]
	strh	wzr, [x22, 2]
	strb	wzr, [x22, 4]
	strh	wzr, [x22, 26]
	strh	wzr, [x22, 28]
	bl	buf_alloc
	str	w20, [x0, 40]
	mov	x25, x0
	mov	w1, 1
	adrp	x20, .LANCHOR68
	bl	sblk_read_page
	ldrh	w2, [x23, #:lo12:.LANCHOR77]
	adrp	x23, .LANCHOR78
	mov	w1, 255
	ldrb	w0, [x23, #:lo12:.LANCHOR78]
	mul	w2, w2, w0
	ldr	x0, [x20, #:lo12:.LANCHOR68]
	lsl	w2, w2, 2
	bl	ftl_memset
	strh	wzr, [x22, 24]
	ldr	w0, [x25, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3092
.L3117:
	mov	x0, x25
	bl	buf_free
	mov	w0, -1
.L3080:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L3091:
	ldrh	w0, [x23, #:lo12:.LANCHOR77]
	sub	w0, w0, #1
	and	w0, w0, 65535
	b	.L3090
.L3102:
	mov	w21, 1
	b	.L3090
.L3092:
	ldr	x0, [x25, 24]
	ldr	w1, [x0]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	cmp	w1, w0
	beq	.L3093
	mov	w2, 1113
	adrp	x1, .LANCHOR210
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR210
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3117
.L3093:
	ldrb	w0, [x23, #:lo12:.LANCHOR78]
	adrp	x22, .LANCHOR66
	ldrh	w1, [x24, #:lo12:.LANCHOR85]
	adrp	x23, .LANCHOR67
	ldr	x24, [x25, 8]
	add	x22, x22, :lo12:.LANCHOR66
	add	x23, x23, :lo12:.LANCHOR67
	mov	x26, 0
	mul	w0, w0, w1
	mul	w21, w21, w0
	and	w21, w21, 65535
.L3094:
	cmp	w21, w26
	bgt	.L3099
	mov	x0, x25
	bl	buf_free
	adrp	x0, .LANCHOR9
	ldrh	w1, [x19, #:lo12:.LANCHOR63]
	add	x3, x19, :lo12:.LANCHOR63
	mov	x20, x0
	ldr	x4, [x0, #:lo12:.LANCHOR9]
	ubfiz	x2, x1, 1, 16
	ldrh	w3, [x3, 24]
	ldrh	w2, [x4, x2]
	cmp	w2, w3
	beq	.L3100
	adrp	x0, .LC214
	add	x0, x0, :lo12:.LC214
	bl	printf
.L3100:
	add	x0, x19, :lo12:.LANCHOR63
	ldrh	w2, [x19, #:lo12:.LANCHOR63]
	ldr	x1, [x20, #:lo12:.LANCHOR9]
	ldrh	w3, [x0, 24]
	strh	w3, [x1, x2, lsl 1]
	strh	wzr, [x0, 28]
	ldrh	w0, [x0, 24]
	b	.L3080
.L3099:
	ldr	w0, [x24, x26, lsl 2]
	cmn	w0, #1
	beq	.L3096
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L3097
	ldr	w0, [x24, x26, lsl 2]
	mov	w2, 0
	add	x1, x29, 92
	bl	pm_log2phys
.L3097:
	ldrh	w1, [x22]
	mov	w0, 21
	ldr	w3, [x29, 92]
	sub	w2, w0, w1
	mov	w0, 1
	lsl	w0, w0, w2
	sub	w0, w0, #1
	lsr	w1, w3, w1
	and	w0, w0, w1
	ldrb	w1, [x23]
	ldrh	w2, [x19, #:lo12:.LANCHOR63]
	udiv	w0, w0, w1
	add	x1, x19, :lo12:.LANCHOR63
	cmp	w0, w2
	bne	.L3096
	ldrh	w0, [x1, 24]
	ldr	x4, [x20, #:lo12:.LANCHOR68]
	ubfiz	x2, x0, 2, 16
	add	w0, w0, 1
	str	w3, [x4, x2]
	strh	w0, [x1, 24]
.L3096:
	add	x26, x26, 1
	b	.L3094
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
	beq	.L3119
	adrp	x21, .LANCHOR211
	adrp	x22, .LC0
	add	x21, x21, :lo12:.LANCHOR211
	add	x22, x22, :lo12:.LC0
	mov	w20, 11
.L3127:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w2, 0
	add	x1, x29, 76
	ldr	w0, [x0, 544]
	bl	pm_log2phys
	ldr	w0, [x29, 76]
	cmn	w0, #1
	beq	.L3120
	mov	w0, 1
	bl	buf_alloc
	ldr	w1, [x29, 76]
	mov	x23, x0
	str	w1, [x0, 40]
	mov	w1, 1
	bl	sblk_read_page
	ldr	w0, [x23, 52]
	cmp	w0, 256
	bne	.L3121
	adrp	x0, .LANCHOR66
	ldr	w2, [x29, 76]
	mov	w1, 1
	ldrh	w3, [x0, #:lo12:.LANCHOR66]
	mov	w0, 21
	sub	w0, w0, w3
	lsr	w2, w2, w3
	lsl	w0, w1, w0
	sub	w0, w0, #1
	and	w0, w0, w2
	adrp	x2, .LANCHOR67
	ldrb	w3, [x2, #:lo12:.LANCHOR67]
	mov	w2, 0
	udiv	w0, w0, w3
	bl	gc_add_sblk
.L3121:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	x1, [x23, 24]
	ldr	w0, [x0, 544]
	ldr	w1, [x1, 4]
	cmp	w1, w0
	beq	.L3122
	mov	w2, 1552
	mov	x1, x21
	mov	x0, x22
	bl	printf
.L3122:
	mov	x0, x23
	bl	buf_free
.L3120:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	adrp	x2, .LANCHOR120
	ldr	w2, [x2, #:lo12:.LANCHOR120]
	ldr	w1, [x0, 544]
	add	w1, w1, 1
	str	w1, [x0, 544]
	cmp	w1, w2
	bcc	.L3123
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
.L3118:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L3123:
	ldr	w0, [x29, 76]
	cmn	w0, #1
	bne	.L3118
	sub	w20, w20, #1
	ands	w20, w20, 65535
	bne	.L3127
	b	.L3118
.L3119:
	ldr	w1, [x0, 536]
	adrp	x3, .LANCHOR102
	ldr	w2, [x0, 12]
	add	w1, w1, 12959744
	add	w1, w1, 256
	cmp	w2, w1
	bhi	.L3129
	ldr	x4, [x3, #:lo12:.LANCHOR102]
	mov	w5, 5000
	ldr	w1, [x0, 540]
	add	w1, w1, w5
	ldr	w4, [x4, 44]
	cmp	w4, w1
	bls	.L3118
.L3129:
	ldr	x1, [x3, #:lo12:.LANCHOR102]
	ldr	w1, [x1, 44]
	str	w1, [x0, 540]
	str	w2, [x0, 536]
	str	wzr, [x0, 544]
	b	.L3118
	.size	gc_scan_static_data, .-gc_scan_static_data
	.section	.text.ftl_sblk_dump,"ax",@progbits
	.align	2
	.global	ftl_sblk_dump
	.type	ftl_sblk_dump, %function
ftl_sblk_dump:
	sub	sp, sp, #272
	and	x0, x0, 65535
	stp	x29, x30, [sp, 48]
	add	x29, sp, 48
	stp	x23, x24, [sp, 96]
	adrp	x24, .LANCHOR7
	lsl	x23, x0, 2
	stp	x0, x1, [x29, 144]
	stp	x21, x22, [sp, 80]
	mov	x21, x0
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	stp	x19, x20, [sp, 64]
	add	x1, x0, x23
	stp	x25, x26, [sp, 112]
	stp	x27, x28, [sp, 128]
	ldr	w5, [x0, x23]
	ldrb	w2, [x1, 2]
	mov	w1, w21
	ldrh	w4, [x0, x23]
	adrp	x0, .LC215
	ubfx	x5, x5, 11, 8
	add	x0, x0, :lo12:.LC215
	ubfx	x3, x2, 3, 2
	and	w4, w4, 2047
	ubfx	x2, x2, 5, 3
	bl	printf
	mov	w0, 65535
	cmp	w21, w0
	beq	.L3156
	adrp	x0, .LANCHOR6
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w0, w21
	bls	.L3156
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	add	x0, x0, x23
	ldrb	w0, [x0, 2]
	and	w0, w0, 224
	cmp	w0, 160
	bne	.L3157
	adrp	x0, .LANCHOR71
	ldrb	w25, [x0, #:lo12:.LANCHOR71]
.L3137:
	add	x28, x29, 224
	adrp	x19, .LANCHOR85
	mov	w0, w21
	mov	w27, 0
	mov	w20, 0
	strh	w21, [x28, -32]!
	add	x1, x28, 16
	bl	ftl_get_blk_list_in_sblk
	ldrh	w2, [x19, #:lo12:.LANCHOR85]
	and	w1, w0, 255
	strb	w1, [x29, 201]
	and	w4, w0, 255
	strb	wzr, [x29, 197]
	mov	w3, w25
	strh	wzr, [x29, 194]
	adrp	x0, .LC216
	mul	w1, w1, w2
	strh	wzr, [x29, 202]
	strh	w1, [x29, 198]
	add	x0, x0, :lo12:.LC216
	ldr	x1, [x24, #:lo12:.LANCHOR7]
	add	x1, x1, x23
	ldrb	w2, [x1, 2]
	mov	w1, w21
	ubfx	x2, x2, 5, 3
	bl	printf
	mov	w0, 1
	bl	buf_alloc
	str	x19, [x29, 136]
	mov	x26, x0
	stp	wzr, wzr, [x29, 164]
	adrp	x0, .LANCHOR103
	add	x0, x0, :lo12:.LANCHOR103
	str	x0, [x29, 112]
.L3138:
	ldr	x0, [x29, 136]
	ldrh	w0, [x0, #:lo12:.LANCHOR85]
	cmp	w0, w20
	bls	.L3153
	lsl	w0, w20, 1
	str	wzr, [x29, 172]
	sub	w0, w0, #1
	str	w0, [x29, 160]
	adrp	x0, .LC162
	add	x0, x0, :lo12:.LC162
	str	x0, [x29, 120]
	b	.L3154
.L3157:
	mov	w25, 1
	b	.L3137
.L3150:
	ldr	x0, [x29, 128]
	ldrh	w10, [x28, x0]
	mov	w0, 65535
	cmp	w10, w0
	beq	.L3139
	ldr	x0, [x29, 112]
	cmp	w25, 3
	ldrh	w19, [x0]
	mul	w19, w19, w10
	bne	.L3140
	add	w19, w20, w19
	orr	w19, w19, w22, lsl 24
.L3141:
	str	w19, [x26, 40]
	mov	w1, 1
	str	w10, [x29, 104]
	mov	x0, x26
	bl	sblk_read_page
	ldr	x1, [x26, 24]
	mov	w3, w19
	ldr	x0, [x26, 8]
	ldr	w11, [x26, 52]
	ldr	w10, [x29, 104]
	ldr	w2, [x1, 12]
	mov	w4, w11
	str	w2, [sp, 32]
	str	w11, [x29, 108]
	ldr	w2, [x1, 8]
	str	w2, [sp, 24]
	ldr	w2, [x1, 4]
	str	w2, [sp, 16]
	mov	w2, w20
	ldr	w1, [x1]
	str	w1, [sp, 8]
	ldr	w1, [x0, 12]
	str	w1, [sp]
	mov	w1, w10
	ldp	w5, w6, [x0]
	ldr	w7, [x0, 8]
	ldr	x0, [x29, 120]
	bl	printf
	ldr	w11, [x29, 108]
	mov	w1, 32
	ldr	w0, [x29, 164]
	cmp	w11, 512
	ccmn	w11, #1, 4, ne
	csinc	w0, w0, wzr, ne
	str	w0, [x29, 164]
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	add	x0, x0, x23
	ldrb	w0, [x0, 2]
	and	w0, w0, 224
	cmp	w0, 224
	ccmp	w0, w1, 4, ne
	beq	.L3139
	ldr	x0, [x26, 24]
	ldr	w0, [x0, 4]
	bl	lpa_hash_get_ppa
	str	w0, [x29, 188]
	cmn	w0, #1
	bne	.L3144
	ldr	x0, [x26, 24]
	mov	w2, 0
	add	x1, x29, 188
	ldr	w0, [x0, 4]
	bl	pm_log2phys
.L3144:
	ldr	w0, [x29, 188]
	cmp	w19, w0
	bne	.L3145
	ldr	w0, [x29, 168]
	mov	w1, w19
	add	w0, w0, 1
	str	w0, [x29, 168]
	ldr	x0, [x26, 24]
	ldr	w3, [x29, 168]
	ldr	w2, [x0, 4]
	adrp	x0, .LC217
	add	x0, x0, :lo12:.LC217
	bl	printf
.L3145:
	ldr	x0, [x29, 152]
	cbz	x0, .L3147
	ubfiz	x19, x27, 2, 32
	ldr	w2, [x0, x19]
	ldr	x0, [x26, 24]
	ldr	w0, [x0, 4]
	cmp	w0, w2
	beq	.L3148
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3148
	adrp	x0, .LC218
	mov	w1, w27
	add	x0, x0, :lo12:.LC218
	bl	printf
.L3148:
	ldr	x1, [x26, 24]
	ldr	x0, [x29, 152]
	ldr	w1, [x1, 4]
	ldr	w0, [x0, x19]
	cmp	w1, w0
	beq	.L3147
	cmn	w0, #1
	beq	.L3147
	adrp	x1, .LANCHOR212
	adrp	x0, .LC0
	mov	w2, 1312
	add	x1, x1, :lo12:.LANCHOR212
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3147:
	add	w27, w27, 1
.L3139:
	add	w22, w22, 1
	and	w22, w22, 65535
.L3152:
	cmp	w25, w22
	bcs	.L3150
	ldr	w0, [x29, 172]
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w0, [x29, 172]
.L3154:
	ldrb	w0, [x29, 201]
	ldr	w1, [x29, 172]
	cmp	w0, w1
	bls	.L3151
	ldrsw	x0, [x29, 172]
	mov	w22, 1
	add	x0, x0, 8
	lsl	x0, x0, 1
	str	x0, [x29, 128]
	b	.L3152
.L3140:
	cmp	w25, 2
	bne	.L3142
	ldr	w0, [x29, 160]
	add	w19, w19, w0
	adrp	x0, .LANCHOR71
	add	w19, w19, w22
	ldrb	w0, [x0, #:lo12:.LANCHOR71]
	orr	w19, w19, w0, lsl 24
	b	.L3141
.L3142:
	add	w19, w20, w19
	b	.L3141
.L3151:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L3138
.L3153:
	mov	x0, x26
	bl	buf_free
	adrp	x0, .LANCHOR9
	ldr	x1, [x29, 144]
	ldr	w3, [x29, 168]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w2, [x0, x1, lsl 1]
	mov	w1, w21
	adrp	x0, .LC219
	add	x0, x0, :lo12:.LC219
	bl	printf
	ldr	w0, [x29, 164]
.L3135:
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 272
	ret
.L3156:
	mov	w0, 0
	b	.L3135
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
	tbz	x0, 12, .L3168
	mov	w3, w2
	adrp	x0, .LC220
	mov	w2, w1
	add	x0, x0, :lo12:.LC220
	mov	w1, w19
	bl	printf
.L3168:
	cbnz	w19, .L3169
	adrp	x0, .LANCHOR59
	mov	w19, 24576
	ldr	w0, [x0, #:lo12:.LANCHOR59]
.L3170:
	add	w1, w20, w25
	cmp	w0, w1
	bcc	.L3199
	adrp	x1, .LANCHOR102
	adrp	x26, .LANCHOR123
	add	w19, w19, w20
	str	x1, [x29, 120]
	ldr	x2, [x1, #:lo12:.LANCHOR102]
	str	x26, [x29, 168]
	ldr	w0, [x2, 24]
	add	w0, w0, w25
	str	w0, [x2, 24]
	ldrb	w0, [x26, #:lo12:.LANCHOR123]
	add	w2, w25, w19
	stp	w2, wzr, [x29, 160]
	sub	w2, w2, #1
	udiv	w27, w19, w0
	udiv	w0, w2, w0
	mov	w20, w27
	sub	w24, w0, w27
	str	w0, [x29, 156]
	add	w24, w24, 1
	adrp	x0, .LANCHOR127
	add	x28, x0, :lo12:.LANCHOR127
.L3172:
	cbnz	w24, .L3197
	ldr	w0, [x29, 164]
.L3167:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 208
	ret
.L3169:
	cmp	w19, 3
	bhi	.L3199
	lsl	w19, w19, 13
	mov	w0, 8192
	b	.L3170
.L3197:
	ldr	x0, [x29, 168]
	cmp	w20, w27
	ldrb	w1, [x0, #:lo12:.LANCHOR123]
	ldr	w0, [x29, 156]
	and	w23, w1, 65535
	ccmp	w20, w0, 4, ne
	bne	.L3200
	cmp	w20, w27
	bne	.L3174
	udiv	w3, w19, w1
	and	w0, w25, 65535
	msub	w1, w3, w1, w19
	and	w26, w1, 65535
	sub	w23, w23, w26
	and	w23, w23, 65535
	cmp	w25, w23
	csel	w23, w0, w23, cc
.L3173:
	adrp	x21, .LANCHOR50
	add	x1, x21, :lo12:.LANCHOR50
	add	x1, x1, 2
	mov	w0, 0
.L3177:
	ldr	w2, [x1, 34]
	cmp	w20, w2
	bne	.L3175
	ldrb	w2, [x1]
	tbz	x2, 3, .L3175
	add	x1, x21, :lo12:.LANCHOR50
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
.L3176:
	add	w20, w20, 1
	sub	w24, w24, #1
.L3183:
	adrp	x0, .LANCHOR52
	ldrb	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, 2
	bls	.L3184
	cbnz	w24, .L3172
.L3184:
	adrp	x0, .LANCHOR127
	ldrb	w1, [x0, #:lo12:.LANCHOR127]
	cbz	w1, .L3172
	adrp	x23, .LANCHOR126
	add	x0, x21, :lo12:.LANCHOR50
	ldrb	w2, [x23, #:lo12:.LANCHOR126]
	add	x0, x0, x2, lsl 6
	bl	sblk_read_page
	adrp	x0, .LANCHOR213
	add	x0, x0, :lo12:.LANCHOR213
	str	x0, [x29, 136]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	str	x0, [x29, 128]
.L3186:
	ldrb	w0, [x28]
	cbnz	w0, .L3196
	mov	w0, -1
	strb	wzr, [x28]
	strb	w0, [x23, #:lo12:.LANCHOR126]
	b	.L3172
.L3174:
	ldr	w0, [x29, 160]
	msub	w23, w1, w20, w0
	and	w23, w23, 255
.L3200:
	mov	w26, 0
	b	.L3173
.L3175:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L3177
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 188]
	cmn	w0, #1
	bne	.L3178
	mov	w2, 0
	add	x1, x29, 188
	mov	w0, w20
	bl	pm_log2phys
.L3178:
	ldr	w0, [x29, 188]
	cmn	w0, #1
	bne	.L3179
	ldr	x0, [x29, 168]
	mov	w23, 0
	add	x26, x0, :lo12:.LANCHOR123
.L3180:
	ldrb	w0, [x26]
	cmp	w23, w0
	bcs	.L3176
	madd	w0, w20, w0, w23
	cmp	w19, w0
	bhi	.L3181
	ldr	w1, [x29, 160]
	cmp	w1, w0
	bls	.L3181
	mov	x0, x22
	add	x22, x22, 512
	mov	w2, 512
	mov	w1, 0
	bl	ftl_memset
.L3181:
	add	w23, w23, 1
	b	.L3180
.L3179:
	mov	w0, 0
	bl	buf_alloc
	cbz	x0, .L3183
	ldr	x2, [x29, 120]
	ldr	x4, [x2, #:lo12:.LANCHOR102]
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
	b	.L3176
.L3196:
	ldrb	w0, [x23, #:lo12:.LANCHOR126]
	cmp	w0, 255
	bne	.L3187
	ldp	x0, x1, [x29, 128]
	mov	w2, 1080
	bl	printf
.L3187:
	ldrb	w26, [x23, #:lo12:.LANCHOR126]
	add	x1, x21, :lo12:.LANCHOR50
	ubfiz	x2, x26, 6, 8
	lsl	x0, x26, 6
	add	x2, x1, x2
	str	x2, [x29, 144]
	add	x2, x1, x0
	ldrb	w0, [x1, x0]
	strb	w0, [x23, #:lo12:.LANCHOR126]
	ldr	w10, [x2, 52]
	cmn	w10, #1
	bne	.L3188
	adrp	x0, .LANCHOR10
	str	w10, [x29, 164]
	ldr	x1, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x1, 552]
	add	w0, w0, 1
	str	w0, [x1, 552]
.L3189:
	add	x1, x21, :lo12:.LANCHOR50
	add	x1, x1, x26, lsl 6
	ldr	x0, [x1, 24]
	ldr	w3, [x1, 36]
	ldr	w1, [x0, 4]
	cmp	w1, w3
	bne	.L3190
	cmn	w10, #1
	bne	.L3191
.L3190:
	adrp	x1, .LANCHOR10
	add	x11, x21, :lo12:.LANCHOR50
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
	adrp	x0, .LC222
	ldr	w4, [x11, 40]
	add	x0, x0, :lo12:.LC222
	bl	printf
	ldr	x11, [x29, 112]
	adrp	x0, .LANCHOR66
	ldrh	w3, [x0, #:lo12:.LANCHOR66]
	mov	w0, 21
	ldr	w1, [x11, 40]
	sub	w2, w0, w3
	mov	w0, 1
	lsl	w0, w0, w2
	sub	w0, w0, #1
	lsr	w1, w1, w3
	and	w0, w0, w1
	adrp	x1, .LANCHOR67
	ldrb	w2, [x1, #:lo12:.LANCHOR67]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
	ldr	w10, [x29, 152]
.L3191:
	add	x0, x21, :lo12:.LANCHOR50
	add	x0, x0, x26, lsl 6
	ldr	x1, [x0, 24]
	ldr	w0, [x0, 36]
	ldr	w1, [x1, 4]
	cmp	w1, w0
	bne	.L3192
	cmn	w10, #1
	bne	.L3193
.L3192:
	ldp	x0, x1, [x29, 128]
	mov	w2, 1101
	bl	printf
.L3193:
	add	x0, x21, :lo12:.LANCHOR50
	ldr	x1, [x29, 168]
	add	x0, x0, x26, lsl 6
	ldrb	w1, [x1, #:lo12:.LANCHOR123]
	ldrb	w2, [x0, 56]
	cmp	w1, w2
	bls	.L3194
	ldrb	w1, [x0, 57]
	lsl	w2, w2, 9
	ldp	x3, x0, [x0, 8]
	ubfiz	x1, x1, 9, 8
	add	x1, x3, x1
	bl	ftl_memcpy
.L3195:
	ldr	x1, [x29, 144]
	adrp	x0, .LANCHOR129
	add	x0, x0, :lo12:.LANCHOR129
	bl	buf_remove_buf
	ldr	x0, [x29, 144]
	bl	buf_free
	ldrb	w0, [x28]
	sub	w0, w0, #1
	strb	w0, [x28]
	b	.L3186
.L3188:
	cmp	w10, 256
	bne	.L3189
	adrp	x0, .LANCHOR66
	ldr	w3, [x2, 40]
	mov	w4, 21
	mov	w5, 1
	ldrh	w0, [x0, #:lo12:.LANCHOR66]
	ldr	w2, [x2, 36]
	sub	w4, w4, w0
	stp	w10, w5, [x29, 108]
	lsr	w0, w3, w0
	lsl	w4, w5, w4
	sub	w4, w4, #1
	and	w4, w4, w0
	adrp	x0, .LANCHOR67
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	udiv	w4, w4, w0
	adrp	x0, .LC221
	add	x0, x0, :lo12:.LC221
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
	b	.L3189
.L3194:
	ldrb	w1, [x0, 2]
	and	w1, w1, -9
	strb	w1, [x0, 2]
	b	.L3195
.L3199:
	mov	w0, -1
	b	.L3167
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
	adrp	x19, .LANCHOR63
	stp	x21, x22, [sp, 48]
	add	x22, x19, :lo12:.LANCHOR63
	adrp	x20, .LANCHOR10
	stp	x23, x24, [sp, 64]
	stp	x25, x26, [sp, 80]
	ldr	x0, [x22, 8]
	stp	x27, x28, [sp, 96]
	ldr	x21, [x20, #:lo12:.LANCHOR10]
	cbnz	x0, .L3222
	mov	w0, 1
	bl	buf_alloc
	str	x0, [x22, 8]
.L3222:
	add	x0, x19, :lo12:.LANCHOR63
	ldr	x22, [x0, 8]
	cbnz	x22, .L3223
	adrp	x1, .LANCHOR214
	adrp	x0, .LC0
	mov	w2, 495
	add	x1, x1, :lo12:.LANCHOR214
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3223:
	adrp	x2, .LANCHOR103
	add	x28, x21, 96
	add	x27, x21, 80
	add	x2, x2, :lo12:.LANCHOR103
	mov	w26, 0
.L3224:
	ldrb	w0, [x27, 9]
	cmp	w26, w0
	bge	.L3233
	adrp	x25, .LANCHOR71
	mov	w24, 1
	add	x23, x19, :lo12:.LANCHOR63
	add	x25, x25, :lo12:.LANCHOR71
	b	.L3234
.L3232:
	ldrh	w0, [x28]
	ldrh	w1, [x2]
	ldrb	w3, [x25]
	cmp	w3, 3
	mul	w1, w0, w1
	ldrh	w0, [x23, 16]
	bne	.L3225
	add	w0, w0, w1
	orr	w0, w0, w24, lsl 24
.L3246:
	str	w0, [x22, 40]
	mov	w1, 1
	str	x2, [x29, 104]
	mov	x0, x22
	bl	sblk_read_page
	ldr	w0, [x22, 52]
	adrp	x1, .LANCHOR152
	ldr	x2, [x29, 104]
	cmn	w0, #1
	beq	.L3228
	ldrh	w0, [x23, 22]
	ldr	x4, [x1, #:lo12:.LANCHOR152]
	ldr	x3, [x22, 24]
	lsl	x0, x0, 2
	ldr	w5, [x4, x0]
	ldr	w4, [x3, 4]
	cmp	w5, w4
	bne	.L3228
	adrp	x4, .LANCHOR153
	ldr	x4, [x4, #:lo12:.LANCHOR153]
	ldr	w4, [x4, x0]
	ldr	w0, [x3, 8]
	cmp	w4, w0
	beq	.L3229
.L3228:
	add	x4, x1, :lo12:.LANCHOR152
	ldrh	w0, [x23, 22]
	ldr	x1, [x1, #:lo12:.LANCHOR152]
	ldr	w0, [x1, x0, lsl 2]
	cmn	w0, #1
	beq	.L3229
	adrp	x19, .LANCHOR77
	ldrb	w3, [x27, 9]
	str	x4, [x29, 104]
	mov	w2, 4
	ldrh	w0, [x19, #:lo12:.LANCHOR77]
	mul	w3, w3, w0
	adrp	x0, .LC223
	add	x0, x0, :lo12:.LC223
	bl	rknand_print_hex
	ldrh	w0, [x19, #:lo12:.LANCHOR77]
	adrp	x19, .LANCHOR153
	ldrb	w3, [x27, 9]
	mov	w2, 4
	ldr	x1, [x19, #:lo12:.LANCHOR153]
	mul	w3, w3, w0
	adrp	x0, .LC224
	add	x0, x0, :lo12:.LC224
	bl	rknand_print_hex
	adrp	x0, .LANCHOR14
	ldr	x4, [x29, 104]
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L3230
	ldr	x1, [x22, 24]
	ldrh	w0, [x23, 22]
	ldr	x2, [x4]
	ldr	x3, [x19, #:lo12:.LANCHOR153]
	lsl	x0, x0, 2
	ldr	w4, [x1, 12]
	str	w4, [sp]
	ldr	w4, [x3, x0]
	ldp	w5, w6, [x1]
	ldr	w3, [x2, x0]
	adrp	x0, .LC225
	ldr	w7, [x1, 8]
	add	x0, x0, :lo12:.LC225
	ldr	w1, [x22, 40]
	ldr	w2, [x22, 52]
	bl	printf
.L3230:
	ldr	x0, [x20, #:lo12:.LANCHOR10]
	mov	x1, 0
	ldrh	w0, [x0, 80]
	bl	ftl_sblk_dump
	adrp	x0, .LANCHOR9
	ldrh	w1, [x21, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x1, lsl 1]
	mov	w0, -1
.L3221:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 128
	ret
.L3225:
	cmp	w3, 2
	bne	.L3227
	sub	w0, w0, #1
	add	w1, w24, w1
	add	w0, w0, w1
	orr	w0, w0, 33554432
	b	.L3246
.L3227:
	add	w0, w0, w1
	b	.L3246
.L3229:
	ldrh	w0, [x23, 22]
	add	w24, w24, 1
	add	w0, w0, 1
	strh	w0, [x23, 22]
.L3234:
	ldrh	w0, [x23, 20]
	cmp	w24, w0
	ble	.L3232
	add	w26, w26, 1
	add	x28, x28, 2
	b	.L3224
.L3233:
	add	x19, x19, :lo12:.LANCHOR63
	ldrh	w0, [x19, 16]
	add	w1, w0, 1
	strh	w1, [x19, 16]
	adrp	x1, .LANCHOR72
	ldrb	w1, [x1, #:lo12:.LANCHOR72]
	cbz	w1, .L3235
	add	w0, w0, 2
	strh	w0, [x19, 16]
.L3235:
.L3231:
	mov	w0, 0
	b	.L3221
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
	adrp	x0, .LANCHOR85
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldrh	w23, [x0, #:lo12:.LANCHOR85]
	ldrb	w0, [x22, 9]
	ldrh	w19, [x22, 12]
	mul	w23, w23, w0
	adrp	x0, .LANCHOR109
	str	x0, [x29, 104]
	ldr	x1, [x0, #:lo12:.LANCHOR109]
	add	x19, x1, x19, lsl 2
	add	x1, x19, x23, sxtw 2
	ldr	w1, [x1, -4]
	cmn	w1, #1
	beq	.L3248
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	mov	w2, 1640
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3248:
	adrp	x27, .LANCHOR123
	mov	x24, 0
	add	x0, x27, :lo12:.LANCHOR123
	mov	w21, 0
	str	x0, [x29, 96]
.L3249:
	cmp	w24, w23
	blt	.L3255
	adrp	x0, .LANCHOR14
	adrp	x19, .LANCHOR9
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3256
	ldrh	w1, [x22]
	ldr	x2, [x19, #:lo12:.LANCHOR9]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC229
	mov	w2, w21
	add	x0, x0, :lo12:.LC229
	bl	printf
.L3256:
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
.L3255:
	ldr	w2, [x19, x24, lsl 2]
	cmn	w2, #1
	beq	.L3250
	ldrb	w20, [x27, #:lo12:.LANCHOR123]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	lsl	w20, w20, 7
	udiv	w20, w2, w20
	and	w20, w20, 65535
	tbz	x0, 12, .L3251
	adrp	x0, .LC226
	mov	w3, w24
	mov	w1, w20
	add	x0, x0, :lo12:.LC226
	bl	printf
.L3251:
	adrp	x25, .LANCHOR103
	adrp	x26, .LC227
	mov	x28, x24
	add	x25, x25, :lo12:.LANCHOR103
	add	x26, x26, :lo12:.LC227
.L3254:
	ldr	w1, [x19, x28, lsl 2]
	cmn	w1, #1
	beq	.L3252
	ldr	x0, [x29, 96]
	ldrb	w2, [x0]
	lsl	w2, w2, 7
	udiv	w1, w1, w2
	cmp	w20, w1, uxth
	bne	.L3252
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
	cbz	w0, .L3253
	ldr	x0, [x29, 104]
	mov	w3, w23
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR109]
	adrp	x0, .LC228
	add	x0, x0, :lo12:.LC228
	bl	rknand_print_hex
.L3253:
	ldr	w0, [x19, x28, lsl 2]
	add	w21, w21, 1
	mov	w2, 1
	add	x1, x29, 124
	and	w21, w21, 65535
	bl	pm_log2phys
	mov	w0, -1
	str	w0, [x19, x28, lsl 2]
.L3252:
	add	x28, x28, 1
	cmp	w23, w28
	bgt	.L3254
.L3250:
	add	x24, x24, 1
	b	.L3249
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
	beq	.L3278
	bl	zftl_insert_data_list
.L3278:
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
	bne	.L3280
	mov	w20, 65535
	cmp	w21, w20
	beq	.L3280
	mov	w1, w21
	adrp	x0, .LC230
	add	x0, x0, :lo12:.LC230
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w0, [x0, 564]
	bl	gc_mark_bad_ppa
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w1, -1
	str	w20, [x0, 560]
	str	w1, [x0, 564]
.L3280:
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
	adrp	x0, .LANCHOR50
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	add	x23, x0, :lo12:.LANCHOR50
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
.L3284:
	adrp	x2, .LANCHOR58
	ldrb	w1, [x2, #:lo12:.LANCHOR58]
	cbz	w1, .L3286
	adrp	x3, .LANCHOR57
	adrp	x0, .LANCHOR50
	add	x0, x0, :lo12:.LANCHOR50
	sub	w1, w1, #1
	ldrb	w4, [x3, #:lo12:.LANCHOR57]
	strb	w1, [x2, #:lo12:.LANCHOR58]
	ubfiz	x27, x4, 6, 8
	add	x5, x0, x27
	stp	x4, x5, [x29, 112]
	lsl	x4, x4, 6
	add	x5, x0, x4
	ldrb	w0, [x0, x4]
	strb	w0, [x3, #:lo12:.LANCHOR57]
	adrp	x0, .LANCHOR120
	ldr	w2, [x5, 36]
	mov	x19, x0
	ldr	w1, [x0, #:lo12:.LANCHOR120]
	cmp	w2, w1
	bcc	.L3288
	adrp	x1, .LANCHOR216
	adrp	x0, .LC0
	mov	w2, 502
	add	x1, x1, :lo12:.LANCHOR216
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3288:
	ldr	x0, [x29, 112]
	ldr	w1, [x19, #:lo12:.LANCHOR120]
	add	x0, x23, x0, lsl 6
	ldr	w22, [x0, 36]
	cmp	w22, w1
	bcc	.L3289
	ldr	x0, [x29, 120]
	bl	buf_free
	mov	w0, -1
.L3283:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L3289:
	ldrb	w21, [x0, 57]
	ldrb	w20, [x0, 56]
	ldr	x26, [x0, 8]
	ldr	x28, [x0, 24]
	adrp	x0, .LANCHOR121
	str	x0, [x29, 104]
	ldrb	w1, [x0, #:lo12:.LANCHOR121]
	cbz	w1, .L3291
	adrp	x0, .LANCHOR174
	ldrb	w1, [x0, #:lo12:.LANCHOR174]
	add	x1, x23, x1, lsl 6
.L3292:
	ldrb	w0, [x1]
	cmp	w0, 255
	bne	.L3293
	ldr	w0, [x1, 36]
	cmp	w22, w0
	bne	.L3291
	ldr	x0, [x1, 8]
	ubfiz	x21, x21, 9, 8
	lsl	w2, w20, 9
	add	x1, x26, x21
	add	x0, x0, x21
	bl	ftl_memcpy
	ldr	x0, [x29, 120]
	bl	buf_free
	b	.L3284
.L3293:
	ubfiz	x1, x0, 6, 8
	add	x1, x23, x1
	b	.L3292
.L3291:
	mov	w0, w22
	bl	lpa_hash_get_ppa
	str	w0, [x29, 140]
	cmn	w0, #1
	bne	.L3295
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w22
	bl	pm_log2phys
.L3295:
	adrp	x25, .LANCHOR10
	add	x1, x23, 2
	mov	w0, 0
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 16
.L3298:
	ldr	w2, [x1, 34]
	cmp	w22, w2
	bne	.L3296
	ldrb	w2, [x1]
	tbz	x2, 3, .L3296
	ubfiz	x0, x0, 6, 32
	and	w2, w2, -9
	add	x0, x23, x0
	strb	w2, [x0, 2]
	ldr	x24, [x0, 8]
	ldr	w0, [x0, 40]
	str	w0, [x29, 140]
.L3297:
	adrp	x0, .LANCHOR123
	str	x0, [x29, 96]
	ldrb	w1, [x0, #:lo12:.LANCHOR123]
	cmp	w20, w1
	bcs	.L3322
	add	w20, w21, w20
	cbz	x24, .L3300
	cbz	w21, .L3301
	lsl	w2, w21, 9
	mov	x1, x24
	mov	x0, x26
	bl	ftl_memcpy
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 48
.L3301:
	ldr	x0, [x29, 96]
	ldrb	w2, [x0, #:lo12:.LANCHOR123]
	cmp	w20, w2
	bcc	.L3302
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 16
.L3322:
	mov	w24, 0
	b	.L3299
.L3296:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L3298
	mov	x24, 0
	b	.L3297
.L3302:
	ubfiz	x0, x20, 9, 9
	sub	w2, w2, w20
	add	x1, x24, x0
	lsl	w2, w2, 9
	add	x0, x26, x0
	bl	ftl_memcpy
	b	.L3322
.L3300:
	ldr	w0, [x29, 140]
	cmn	w0, #1
	beq	.L3303
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
	bne	.L3304
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L3305
.L3304:
	ldr	x1, [x25, #:lo12:.LANCHOR10]
	mov	w3, w22
	ldr	w4, [x27, 52]
	ldr	w2, [x29, 140]
	ldr	w0, [x1, 552]
	add	w0, w0, 1
	str	w0, [x1, 552]
	adrp	x0, .LC231
	add	x0, x0, :lo12:.LC231
	ldrb	w1, [x27, 1]
	bl	printf
	ldr	x1, [x27, 24]
	mov	w3, 4
	adrp	x0, .LC189
	mov	w2, w3
	add	x0, x0, :lo12:.LC189
	bl	rknand_print_hex
.L3305:
	ldr	x0, [x27, 24]
	ldr	w0, [x0, 4]
	cmp	w22, w0
	bne	.L3306
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L3307
.L3306:
	adrp	x1, .LANCHOR216
	adrp	x0, .LC0
	mov	w2, 573
	add	x1, x1, :lo12:.LANCHOR216
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3307:
	cbz	w21, .L3308
	ldr	w0, [x29, 140]
	lsl	w2, w21, 9
	cmn	w0, #1
	beq	.L3309
	ldr	x1, [x27, 8]
	mov	x0, x26
	bl	ftl_memcpy
.L3310:
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 48
.L3308:
	ldr	x0, [x29, 96]
	ldrb	w2, [x0, #:lo12:.LANCHOR123]
	cmp	w20, w2
	bcc	.L3311
	bls	.L3312
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 16
.L3312:
	cbz	x27, .L3299
	ldrb	w0, [x27, 2]
	mov	x1, x27
	and	w0, w0, -9
	strb	w0, [x27, 2]
	adrp	x0, .LANCHOR129
	add	x0, x0, :lo12:.LANCHOR129
	bl	buf_remove_buf
	mov	x0, x27
	bl	buf_free
.L3299:
	ldrh	w0, [x19, 6]
	cbnz	w0, .L3314
	bl	ftl_flush
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L3314:
	mov	x0, x19
	bl	ftl_get_new_free_page
	ldr	x1, [x29, 112]
	adrp	x20, .LANCHOR174
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
	add	x0, x20, :lo12:.LANCHOR174
	bl	buf_add_tail
	ldr	x0, [x29, 104]
	ldrb	w2, [x0, #:lo12:.LANCHOR121]
	add	w2, w2, 1
	and	w2, w2, 255
	strb	w2, [x0, #:lo12:.LANCHOR121]
	adrp	x0, .LANCHOR217
	cmp	w2, 2
	str	wzr, [x0, #:lo12:.LANCHOR217]
	ldrh	w0, [x19, 6]
	bhi	.L3315
	cmp	w0, 1
	bne	.L3287
.L3315:
	ldrb	w1, [x19, 5]
	cmp	w1, 0
	mov	w1, 0
	cset	w4, ne
	cmp	w0, 1
	ldrb	w0, [x20, #:lo12:.LANCHOR174]
	csinc	w4, w2, w4, eq
	mov	w3, w0
.L3319:
	cmp	w1, w4
	bne	.L3320
	strb	w3, [x20, #:lo12:.LANCHOR174]
	and	w1, w1, 255
	ldr	x3, [x29, 104]
	sub	w2, w2, w1
	ubfiz	x0, x0, 6, 8
	add	x0, x23, x0
	strb	w2, [x3, #:lo12:.LANCHOR121]
	bl	sblk_prog_page
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bne	.L3287
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	mov	x0, x19
	bl	ftl_write_last_log_page
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L3287:
	adrp	x0, .LANCHOR58
	ldrb	w0, [x0, #:lo12:.LANCHOR58]
	cbnz	w0, .L3284
.L3286:
	bl	ftl_write_completed
	mov	w0, 0
	b	.L3283
.L3311:
	ldr	w0, [x29, 140]
	sub	w2, w2, w20
	lsl	w2, w2, 9
	cmn	w0, #1
	ubfiz	x0, x20, 7, 9
	beq	.L3313
	ldr	x1, [x27, 8]
	lsl	x0, x0, 2
	add	x1, x1, x0
	add	x0, x26, x0
	bl	ftl_memcpy
	b	.L3312
.L3313:
	mov	w1, 0
	add	x0, x26, x0, lsl 2
	bl	ftl_memset
	b	.L3312
.L3320:
	ubfiz	x3, x3, 6, 8
	add	w1, w1, 1
	ldrb	w3, [x23, x3]
	b	.L3319
.L3321:
	lsl	w2, w21, 9
	mov	x27, 0
	mov	w24, 0
.L3309:
	mov	w1, 0
	mov	x0, x26
	bl	ftl_memset
	b	.L3310
.L3303:
	cbnz	w21, .L3321
	mov	w24, 0
	mov	x27, 0
	b	.L3308
	.size	ftl_write_commit, .-ftl_write_commit
	.section	.text.gc_do_copy_back,"ax",@progbits
	.align	2
	.global	gc_do_copy_back
	.type	gc_do_copy_back, %function
gc_do_copy_back:
	sub	sp, sp, #224
	adrp	x0, .LANCHOR76
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	ldrb	w0, [x0, #:lo12:.LANCHOR76]
	stp	x19, x20, [sp, 32]
	stp	x21, x22, [sp, 48]
	stp	x23, x24, [sp, 64]
	stp	x25, x26, [sp, 80]
	stp	x27, x28, [sp, 96]
	cbnz	w0, .L3345
	bl	buf_alloc
	mov	x19, x0
	cbz	x0, .L3344
	adrp	x20, .LANCHOR63
	add	x3, x20, :lo12:.LANCHOR63
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
	bne	.L3347
	adrp	x1, .LANCHOR218
	adrp	x0, .LC0
	mov	w2, 732
	add	x1, x1, :lo12:.LANCHOR218
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3347:
	ldr	x0, [x19, 24]
	ldr	w21, [x0, 4]
	mov	w0, w21
	bl	lpa_hash_get_ppa
	str	w0, [x29, 160]
	cmn	w0, #1
	bne	.L3348
	mov	w2, 0
	add	x1, x29, 160
	mov	w0, w21
	bl	pm_log2phys
.L3348:
	ldr	w23, [x29, 160]
	cmp	w22, w23
	bne	.L3349
	adrp	x0, .LANCHOR50
	add	x0, x0, :lo12:.LANCHOR50
	add	x1, x0, 2
	add	x0, x0, 2050
.L3352:
	ldr	w2, [x1, 34]
	cmp	w21, w2
	bne	.L3350
	ldrb	w2, [x1]
	tbz	x2, 1, .L3350
	mov	x0, x19
	bl	buf_free
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3344
	add	x20, x20, :lo12:.LANCHOR63
	adrp	x0, .LC232
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC232
	ldrh	w3, [x20, 26]
	bl	printf
.L3344:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 224
	ret
.L3350:
	add	x1, x1, 64
	cmp	x1, x0
	bne	.L3352
	adrp	x0, .LANCHOR123
	mov	w1, 10
	strb	wzr, [x19, 57]
	ldrb	w0, [x0, #:lo12:.LANCHOR123]
	strb	w0, [x19, 56]
	ldrb	w0, [x19, 2]
	str	w21, [x19, 36]
	orr	w0, w0, w1
	strb	w0, [x19, 2]
	ldr	x0, [x19, 24]
	ldr	w0, [x0]
	str	w0, [x19, 32]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3353
	mov	w0, w21
	bl	lpa_hash_get_ppa
	add	x1, x20, :lo12:.LANCHOR63
	mov	w3, w0
	mov	w4, w22
	adrp	x0, .LC233
	mov	w2, w23
	add	x0, x0, :lo12:.LC233
	ldrh	w5, [x1, 26]
	mov	w1, w21
	bl	printf
.L3353:
	mov	x0, x19
	bl	ftl_gc_write_buf
	bl	ftl_write_commit
	add	x20, x20, :lo12:.LANCHOR63
	adrp	x0, .LANCHOR102
	ldr	x1, [x0, #:lo12:.LANCHOR102]
	ldr	w0, [x1, 60]
	add	w0, w0, 1
	str	w0, [x1, 60]
	ldrh	w0, [x20, 28]
	add	w0, w0, 1
	strh	w0, [x20, 28]
	b	.L3344
.L3349:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3354
	add	x20, x20, :lo12:.LANCHOR63
	mov	w0, w21
	bl	lpa_hash_get_ppa
	mov	w3, w0
	mov	w4, w22
	adrp	x0, .LC233
	ldrh	w5, [x20, 26]
	mov	w2, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC233
	bl	printf
.L3354:
	mov	x0, x19
	bl	buf_free
	b	.L3344
.L3345:
	adrp	x1, .LANCHOR10
	adrp	x0, .LANCHOR71
	stp	x0, x1, [x29, 128]
	adrp	x24, .LANCHOR63
	ldr	x22, [x1, #:lo12:.LANCHOR10]
	ldrb	w25, [x0, #:lo12:.LANCHOR71]
	add	x22, x22, 80
	cmp	w25, 3
	bne	.L3355
	adrp	x0, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR75]
	cbz	w0, .L3356
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w19, [x22, 9]
	ldrh	w20, [x0, 314]
	add	w21, w19, w19, lsl 1
	sub	w19, w19, w19, lsl 2
	sdiv	w21, w20, w21
	madd	w19, w21, w19, w20
	and	w19, w19, 65535
.L3357:
	adrp	x1, .LANCHOR77
	ldrb	w0, [x22, 9]
	add	x4, x24, :lo12:.LANCHOR63
	mov	w2, 0
	ldrh	w3, [x1, #:lo12:.LANCHOR77]
	mul	w8, w25, w0
	ldrh	w10, [x4, 24]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR153
	ldr	x7, [x0, #:lo12:.LANCHOR153]
	sub	w3, w3, #1
.L3360:
	cmp	w2, w8
	blt	.L3362
.L3391:
	mov	w23, 1
	b	.L3358
.L3356:
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w20, [x22, 9]
	ldrh	w1, [x0, 314]
	adrp	x0, .LANCHOR219
	add	x0, x0, :lo12:.LANCHOR219
	sdiv	w19, w1, w20
	ldrh	w23, [x0, w19, sxtw 1]
	msub	w19, w19, w20, w1
	and	w19, w19, 65535
	lsr	w21, w23, 3
	and	w23, w23, 7
	cmp	w23, 1
	madd	w20, w21, w20, w19
	add	w20, w20, w20, lsl 1
	and	w20, w20, 65535
	beq	.L3357
.L3358:
	adrp	x0, .LANCHOR14
	str	x0, [x29, 112]
	ldr	w1, [x0, #:lo12:.LANCHOR14]
	tbz	x1, 8, .L3363
	adrp	x0, .LANCHOR153
	ubfiz	x1, x20, 2, 16
	mov	w6, w20
	mov	w3, w19
	ldr	x2, [x0, #:lo12:.LANCHOR153]
	add	x0, x24, :lo12:.LANCHOR63
	ldrh	w4, [x0, 314]
	adrp	x0, .LC234
	ldr	w5, [x2, x1]
	add	x0, x0, :lo12:.LC234
	mov	w2, w23
	mov	w1, w21
	bl	printf
.L3363:
	adrp	x0, .LANCHOR50
	str	wzr, [x29, 152]
	add	x0, x0, :lo12:.LANCHOR50
	str	x0, [x29, 120]
.L3364:
	ldrb	w1, [x22, 9]
	ldr	w0, [x29, 152]
	ldrh	w26, [x29, 152]
	and	w0, w0, 65535
	str	w0, [x29, 156]
	mul	w3, w25, w1
	cmp	w0, w3
	blt	.L3376
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR71]
	cmp	w0, 3
	add	x0, x29, 160
	bne	.L3377
	adrp	x2, .LANCHOR75
	ldr	x3, [x29, 160]
	ldrb	w2, [x2, #:lo12:.LANCHOR75]
	cbz	w2, .L3378
.L3381:
	strb	wzr, [x3, 60]
	b	.L3379
.L3355:
	adrp	x0, .LANCHOR72
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	cbnz	w0, .L3359
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w19, [x22, 9]
	mov	w25, 1
	ldrh	w20, [x0, 314]
	sdiv	w21, w20, w19
	msub	w19, w21, w19, w20
	and	w19, w19, 65535
	b	.L3357
.L3359:
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w19, [x22, 9]
	mov	w25, 2
	ldrh	w20, [x0, 314]
	sdiv	w21, w20, w19
	msub	w19, w21, w19, w20
	and	w19, w19, 65535
	b	.L3357
.L3362:
	add	w5, w20, w2
	cmp	w5, w3
	beq	.L3391
	sbfiz	x5, x5, 2, 32
	ldr	w0, [x7, x5]
	cmn	w0, #1
	bne	.L3361
	ldrh	w6, [x4, 26]
	cmp	w6, w10
	bcs	.L3344
	mov	w0, w6
	bl	gc_get_src_ppa_from_index
	add	w6, w6, 1
	strh	w6, [x4, 26]
	str	w0, [x7, x5]
.L3361:
	add	w2, w2, 1
	and	w2, w2, 65535
	b	.L3360
.L3376:
	ldr	w0, [x29, 156]
	add	w0, w20, w0
	str	w0, [x29, 144]
	sxtw	x27, w0
	adrp	x0, .LANCHOR74
	ldr	x0, [x0, #:lo12:.LANCHOR74]
	ldrb	w0, [x0, x27]
	cmp	w0, 255
	bne	.L3365
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L3366
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	bl	gc_write_completed
	bl	gc_free_temp_buf
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbz	x0, .L3344
.L3366:
	adrp	x0, .LANCHOR74
	ldrb	w1, [x28, 1]
	adrp	x5, .LANCHOR77
	adrp	x6, .LANCHOR153
	ldr	x0, [x0, #:lo12:.LANCHOR74]
	strb	w1, [x0, x27]
	add	x1, x24, :lo12:.LANCHOR63
	strb	w23, [x28, 61]
	ldrh	w7, [x5, #:lo12:.LANCHOR77]
	ldrb	w0, [x1, 7]
	add	w0, w0, 1
	strb	w0, [x1, 7]
	add	w0, w26, w20
	strh	w0, [x28, 48]
	ldr	w1, [x29, 144]
	ldrb	w0, [x22, 9]
	mul	w0, w0, w7
	sub	w0, w0, #1
	cmp	w1, w0
	bne	.L3367
	adrp	x0, .LANCHOR152
	adrp	x4, .LANCHOR78
	stp	x6, x5, [x29, 96]
	ldr	x1, [x0, #:lo12:.LANCHOR152]
	mov	w0, -1
	str	x4, [x29, 144]
	str	w0, [x1, x27, lsl 2]
	ldr	x0, [x28, 8]
	ldrb	w2, [x4, #:lo12:.LANCHOR78]
	mul	w2, w2, w7
	lsl	w2, w2, 2
	bl	ftl_memcpy
	ldp	x6, x5, [x29, 96]
	ldr	x4, [x29, 144]
	ldr	x7, [x28, 8]
	ldrh	w0, [x5, #:lo12:.LANCHOR77]
	ldrb	w1, [x4, #:lo12:.LANCHOR78]
	mul	w0, w0, w1
	ldr	x1, [x6, #:lo12:.LANCHOR153]
	lsl	w2, w0, 2
	add	x0, x7, x0, sxtw 2
	bl	ftl_memcpy
	adrp	x0, .LANCHOR123
	mov	w1, 0
	ldrb	w2, [x0, #:lo12:.LANCHOR123]
	ldr	x0, [x28, 24]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x6, [x28, 24]
	mov	w0, 15555
	ldr	x5, [x29, 104]
	movk	w0, 0xf55f, lsl 16
	ldr	x4, [x29, 144]
	ldrh	w1, [x5, #:lo12:.LANCHOR77]
	str	w0, [x6]
	ldrb	w0, [x4, #:lo12:.LANCHOR78]
	mul	w1, w1, w0
	ldr	x0, [x28, 8]
	lsl	w1, w1, 2
	bl	js_hash
	str	w0, [x6, 4]
	ldr	x0, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x0, 132]
	str	w0, [x6, 8]
.L3365:
	adrp	x0, .LANCHOR74
	ldr	w5, [x29, 156]
	add	x1, x29, 160
	ldr	x4, [x0, #:lo12:.LANCHOR74]
	adrp	x0, .LANCHOR50
	add	x3, x0, :lo12:.LANCHOR50
	ldrb	w2, [x4, x27]
	ubfiz	x0, x2, 6, 8
	add	x0, x3, x0
	add	x3, x3, x2, lsl 6
	str	x0, [x1, w5, sxtw 3]
	mov	w0, 2
	adrp	x5, .LANCHOR154
	strh	w0, [x3, 50]
	ldr	x0, [x29, 128]
	strb	w23, [x3, 61]
	ldrb	w0, [x0, #:lo12:.LANCHOR71]
	cmp	w0, 3
	bne	.L3371
	udiv	w0, w26, w0
	adrp	x6, .LANCHOR103
	ldrh	w6, [x6, #:lo12:.LANCHOR103]
	add	w1, w0, w19
	add	w0, w0, w0, lsl 1
	add	x1, x22, x1, sxtw 1
	sub	w0, w26, w0
	and	w0, w0, 65535
	add	w0, w0, 1
	ldrh	w1, [x1, 16]
	mul	w1, w1, w6
	ldrh	w6, [x3, 48]
	orr	w1, w1, w21
	str	w1, [x3, 40]
	ldr	x3, [x5, #:lo12:.LANCHOR154]
	orr	w0, w1, w0, lsl 24
	str	w0, [x3, x6, lsl 2]
.L3372:
	ldr	x0, [x29, 112]
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3375
	ldr	x0, [x29, 120]
	ldrb	w4, [x4, x27]
	ldr	w1, [x29, 156]
	add	x2, x0, x2, lsl 6
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w3, [x0, 6]
	ldr	x0, [x2, 24]
	ldrb	w7, [x2, 1]
	ldrh	w6, [x2, 48]
	ldr	w0, [x0, 4]
	str	w0, [sp, 8]
	mov	w0, 3
	udiv	w26, w26, w0
	adrp	x0, .LC235
	add	x0, x0, :lo12:.LC235
	add	w26, w26, w19
	str	w26, [sp]
	ldr	w5, [x2, 40]
	mov	w2, w23
	bl	printf
.L3375:
	ldr	w0, [x29, 152]
	add	w0, w0, 1
	str	w0, [x29, 152]
	b	.L3364
.L3367:
	lsl	x0, x27, 2
	str	x0, [x29, 144]
	ldr	x0, [x6, #:lo12:.LANCHOR153]
	lsl	x1, x27, 2
	ldr	w0, [x0, x1]
	mov	w1, 1
	str	w0, [x28, 40]
	mov	x0, x28
	bl	sblk_read_page
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3369
	adrp	x0, .LANCHOR66
	ldr	w1, [x28, 40]
	ldrh	w4, [x0, #:lo12:.LANCHOR66]
	mov	w0, 21
	sub	w2, w0, w4
	mov	w0, 1
	lsr	w1, w1, w4
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR67
	ldrb	w2, [x1, #:lo12:.LANCHOR67]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3369
	ldr	x0, [x28, 24]
	mov	w1, -1
	str	w1, [x0, 4]
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmp	w0, w1, 4, ne
	bne	.L3369
	adrp	x1, .LANCHOR218
	adrp	x0, .LC0
	mov	w2, 847
	add	x1, x1, :lo12:.LANCHOR218
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3369:
	ldr	x0, [x28, 24]
	adrp	x1, .LANCHOR120
	ldr	w1, [x1, #:lo12:.LANCHOR120]
	ldr	w2, [x0, 4]
	cmp	w2, w1
	bcc	.L3370
	mov	w1, -1
	str	w1, [x0, 4]
.L3370:
	adrp	x1, .LANCHOR152
	lsl	x3, x27, 2
	ldr	w2, [x0, 4]
	ldr	x1, [x1, #:lo12:.LANCHOR152]
	str	w2, [x1, x3]
	ldr	w1, [x28, 40]
	str	w1, [x0, 8]
	b	.L3365
.L3371:
	cmp	w0, 2
	bne	.L3373
	adrp	x0, .LANCHOR72
	adrp	x1, .LANCHOR103
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	cbnz	w0, .L3374
	ldr	w0, [x29, 156]
	ldrh	w1, [x1, #:lo12:.LANCHOR103]
	add	w0, w19, w0
	add	x0, x22, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w1, w21
.L3435:
	orr	w0, w0, 33554432
	str	w0, [x3, 40]
.L3373:
	ldr	x0, [x29, 120]
	add	x0, x0, x2, lsl 6
	ldrh	w1, [x0, 48]
	ldr	w3, [x0, 40]
	ldr	x0, [x5, #:lo12:.LANCHOR154]
	str	w3, [x0, x1, lsl 2]
	b	.L3372
.L3374:
	add	w0, w19, w26, lsr 1
	ldrh	w1, [x1, #:lo12:.LANCHOR103]
	add	x0, x22, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w1, w21
	and	w1, w26, 1
	add	w0, w0, w1
	b	.L3435
.L3378:
	cmp	w23, 1
	bne	.L3380
	mov	w2, 9
.L3434:
	strb	w2, [x3, 60]
.L3379:
	mov	w2, w1
	add	x1, x0, 24
	bl	sblk_xlc_prog_pages
.L3382:
	adrp	x1, .LANCHOR75
	ldrb	w3, [x22, 9]
	ldrb	w1, [x1, #:lo12:.LANCHOR75]
	and	w0, w3, 65535
	cbz	w1, .L3387
	add	w0, w0, w0, lsl 1
.L3388:
	adrp	x1, .LANCHOR102
	add	x24, x24, :lo12:.LANCHOR63
	ldr	x1, [x1, #:lo12:.LANCHOR102]
	ldr	w2, [x1, 52]
	add	w2, w2, w0
	str	w2, [x1, 52]
	ldrh	w1, [x24, 314]
	add	w0, w0, w1
	adrp	x1, .LANCHOR77
	and	w0, w0, 65535
	strh	w0, [x24, 314]
	ldrh	w1, [x1, #:lo12:.LANCHOR77]
	mul	w1, w1, w3
	cmp	w0, w1
	blt	.L3389
	ldr	x0, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	strh	wzr, [x0, 86]
.L3389:
	bl	gc_write_completed
	b	.L3344
.L3380:
	cmp	w23, 2
	bne	.L3381
	mov	w2, 13
	b	.L3434
.L3377:
	adrp	x2, .LANCHOR72
	ldrb	w2, [x2, #:lo12:.LANCHOR72]
	cbz	w2, .L3392
	adrp	x2, .LANCHOR73
	ldrb	w2, [x2, #:lo12:.LANCHOR73]
	cbnz	w2, .L3384
.L3383:
	sub	w1, w3, #1
.L3385:
	cmp	w2, w1
	blt	.L3386
	ldr	x0, [x0, w1, sxtw 3]
	mov	w1, -1
	strb	w1, [x0]
	mov	w1, w3
	ldr	x0, [x29, 160]
	bl	sblk_prog_page
	b	.L3382
.L3392:
	mov	w2, 0
	b	.L3383
.L3384:
	bl	sblk_3d_mlc_prog_pages
	b	.L3382
.L3386:
	ldr	x4, [x0, w2, sxtw 3]
	add	w2, w2, 1
	ldr	x5, [x0, w2, sxtw 3]
	and	w2, w2, 65535
	ldrb	w5, [x5, 1]
	strb	w5, [x4]
	b	.L3385
.L3387:
	adrp	x1, .LANCHOR72
	ldrb	w2, [x1, #:lo12:.LANCHOR72]
	mov	w1, w0
	ubfiz	w0, w0, 1, 15
	cmp	w2, 0
	csel	w0, w0, w1, ne
	b	.L3388
	.size	gc_do_copy_back, .-gc_do_copy_back
	.section	.text.zftl_do_gc,"ax",@progbits
	.align	2
	.global	zftl_do_gc
	.type	zftl_do_gc, %function
zftl_do_gc:
	sub	sp, sp, #128
	adrp	x1, .LANCHOR99
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x19, .LANCHOR150
	stp	x21, x22, [sp, 48]
	ldrh	w22, [x1, #:lo12:.LANCHOR99]
	adrp	x1, .LANCHOR95
	stp	x23, x24, [sp, 64]
	adrp	x23, .LANCHOR10
	ldrh	w21, [x1, #:lo12:.LANCHOR95]
	stp	x25, x26, [sp, 80]
	ldrb	w1, [x19, #:lo12:.LANCHOR150]
	add	w21, w22, w21
	stp	x27, x28, [sp, 96]
	ldr	x20, [x23, #:lo12:.LANCHOR10]
	cmp	w1, 6
	bhi	.L3544
	mov	w25, w0
	and	w21, w21, 65535
	adrp	x0, .L3439
	add	x0, x0, :lo12:.L3439
	ldrh	w0, [x0,w1,uxtw #1]
	adr	x1, .Lrtx3439
	add	x0, x1, w0, sxth #2
	br	x0
.Lrtx3439:
	.section	.rodata.zftl_do_gc,"a",@progbits
	.align	0
	.align	2
.L3439:
	.2byte	(.L3438 - .Lrtx3439) / 4
	.2byte	(.L3440 - .Lrtx3439) / 4
	.2byte	(.L3441 - .Lrtx3439) / 4
	.2byte	(.L3442 - .Lrtx3439) / 4
	.2byte	(.L3443 - .Lrtx3439) / 4
	.2byte	(.L3444 - .Lrtx3439) / 4
	.2byte	(.L3445 - .Lrtx3439) / 4
	.section	.text.zftl_do_gc
.L3444:
	adrp	x20, .LANCHOR63
	add	x24, x20, :lo12:.LANCHOR63
	mov	w22, 0
.L3446:
	bl	gc_check_data_one_wl
	cbz	w0, .L3540
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	add	x20, x20, :lo12:.LANCHOR63
	strh	wzr, [x20, 56]
	ldrh	w0, [x0, 80]
	bl	ftl_free_sblk
	adrp	x2, .LANCHOR102
	ldr	x1, [x23, #:lo12:.LANCHOR10]
	mov	w0, -1
	ldr	x2, [x2, #:lo12:.LANCHOR102]
	strh	w0, [x1, 80]
	strh	w0, [x2, 126]
	strh	w0, [x1, 130]
	ldr	x0, [x20, 8]
	bl	buf_free
	strb	wzr, [x19, #:lo12:.LANCHOR150]
	str	xzr, [x20, 8]
	b	.L3611
.L3438:
	adrp	x0, .LANCHOR97
	adrp	x27, .LANCHOR90
	ldrh	w2, [x20, 80]
	ldrh	w0, [x0, #:lo12:.LANCHOR97]
	ldrh	w24, [x27, #:lo12:.LANCHOR90]
	add	w22, w22, w0
	adrp	x0, .LANCHOR88
	str	x0, [x29, 104]
	and	w22, w22, 65535
	ldrh	w1, [x0, #:lo12:.LANCHOR88]
	add	w24, w24, w1
	mov	w1, 65535
	and	w24, w24, 65535
	cmp	w2, w1
	beq	.L3447
	cbnz	w25, .L3448
	adrp	x0, .LANCHOR79
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	cmp	w21, w0, lsl 1
	blt	.L3448
.L3544:
	mov	w20, 16
	b	.L3436
.L3448:
	adrp	x5, .LANCHOR87
	mov	w1, 5
	adrp	x25, .LANCHOR76
	ldrh	w0, [x5, #:lo12:.LANCHOR87]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x5, #:lo12:.LANCHOR87]
	bl	zftl_get_gc_node
	and	w3, w0, 65535
	mov	w1, 65535
	cmp	w3, w1
	beq	.L3449
	adrp	x4, .LANCHOR9
	ubfiz	x3, x3, 1, 16
	adrp	x1, .LANCHOR151
	mov	x26, x1
	ldr	x4, [x4, #:lo12:.LANCHOR9]
	ldr	w2, [x1, #:lo12:.LANCHOR151]
	add	w2, w2, 1
	str	w2, [x1, #:lo12:.LANCHOR151]
	ldrh	w3, [x4, x3]
	adrp	x4, .LANCHOR85
	ldrh	w4, [x4, #:lo12:.LANCHOR85]
	cmp	w4, w3
	bcs	.L3450
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	cmp	w2, w1, lsr 4
	bls	.L3449
	adrp	x1, .LANCHOR91
	ldrh	w1, [x1, #:lo12:.LANCHOR91]
	cmp	w1, w3
	bls	.L3449
.L3450:
	ldrb	w2, [x25, #:lo12:.LANCHOR76]
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L3451
	mov	w0, 1
	str	wzr, [x26, #:lo12:.LANCHOR151]
	strb	w0, [x19, #:lo12:.LANCHOR150]
	b	.L3544
.L3449:
	strh	wzr, [x5, #:lo12:.LANCHOR87]
.L3451:
	cmp	w22, 15
	bls	.L3546
	adrp	x0, .LANCHOR92
	ldrh	w1, [x0, #:lo12:.LANCHOR92]
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w1, w0
	bhi	.L3546
	cmp	w24, 0
	cset	w24, eq
	add	w24, w24, 1
.L3452:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3453
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	mov	w4, w22
	ldrb	w2, [x25, #:lo12:.LANCHOR76]
	mov	w3, w21
	mov	w1, 1983
	ldrh	w7, [x0, 122]
	ldrh	w6, [x0, 120]
	ldrh	w5, [x0, 124]
	ldrh	w0, [x20, 80]
	str	w0, [sp]
	adrp	x0, .LC236
	add	x0, x0, :lo12:.LC236
	bl	printf
.L3453:
	ldrb	w0, [x25, #:lo12:.LANCHOR76]
	mov	w2, 1
	mov	w1, w24
	bl	gc_search_src_blk
	cmp	w0, 0
	ble	.L3454
.L3455:
	mov	w0, 1
.L3613:
	strb	w0, [x19, #:lo12:.LANCHOR150]
	b	.L3544
.L3546:
	mov	w24, 2
	b	.L3452
.L3454:
	ldrb	w0, [x25, #:lo12:.LANCHOR76]
	mov	w2, 1
	mov	w1, 3
	bl	gc_search_src_blk
	cmp	w0, 0
	bgt	.L3455
	b	.L3544
.L3447:
	adrp	x28, .LANCHOR14
	ldr	w0, [x28, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3457
	adrp	x0, .LANCHOR76
	ldrh	w7, [x20, 122]
	ldrh	w6, [x20, 120]
	mov	w4, w22
	ldrh	w5, [x20, 124]
	mov	w3, w21
	ldrb	w2, [x0, #:lo12:.LANCHOR76]
	mov	w1, 1995
	str	w25, [sp]
	adrp	x0, .LC236
	add	x0, x0, :lo12:.LC236
	bl	printf
.L3457:
	cmp	w25, 1
	bne	.L3458
	bl	gc_scan_static_data
	adrp	x26, .LANCHOR76
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	ldrh	w0, [x0, 122]
	cbz	w0, .L3459
.L3460:
	mov	w0, 1
	strb	w0, [x26, #:lo12:.LANCHOR76]
	b	.L3613
.L3459:
	bl	gc_static_wearleveling
	mov	w20, w0
	cbnz	w0, .L3460
	cbnz	w22, .L3461
.L3465:
	mov	w20, 16
.L3462:
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	adrp	x3, .LANCHOR76
	mov	w1, 1
	mov	x23, x3
	strb	w1, [x3, #:lo12:.LANCHOR76]
	ldrh	w5, [x0, 124]
	cbz	w5, .L3470
	strb	w1, [x19, #:lo12:.LANCHOR150]
	ldr	w1, [x28, #:lo12:.LANCHOR14]
	strb	wzr, [x3, #:lo12:.LANCHOR76]
	tbz	x1, 8, .L3436
	ldrh	w7, [x0, 122]
	mov	w4, w22
	ldrh	w6, [x0, 120]
	mov	w3, w21
	adrp	x0, .LC237
	mov	w2, 0
	mov	w1, 2085
	add	x0, x0, :lo12:.LC237
	bl	printf
.L3436:
	mov	w0, w20
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 128
	ret
.L3461:
	cmp	w21, w24
	adrp	x1, .LANCHOR92
	adrp	x2, .LANCHOR89
	bcs	.L3463
	ldrh	w0, [x2, #:lo12:.LANCHOR89]
	cmp	w0, w21
	bhi	.L3464
.L3463:
	ldrh	w2, [x2, #:lo12:.LANCHOR89]
	add	w0, w21, w24
	cmp	w0, w2
	blt	.L3464
	adrp	x0, .LANCHOR93
	ldrh	w2, [x1, #:lo12:.LANCHOR92]
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w2, w0
	bcc	.L3465
.L3464:
	adrp	x5, .LANCHOR151
	adrp	x2, .LANCHOR6
	mov	w6, 1
	strb	w6, [x26, #:lo12:.LANCHOR76]
	ldr	w0, [x5, #:lo12:.LANCHOR151]
	ldrh	w2, [x2, #:lo12:.LANCHOR6]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR151]
	cmp	w0, w2, lsr 5
	bls	.L3466
	ldrh	w0, [x1, #:lo12:.LANCHOR92]
	cmp	w0, w22
	bls	.L3466
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w0, w0, 65535
	mov	w1, 65535
	cmp	w0, w1
	beq	.L3465
	adrp	x1, .LANCHOR9
	ubfiz	x0, x0, 1, 16
	adrp	x2, .LANCHOR78
	ldr	x1, [x1, #:lo12:.LANCHOR9]
	ldrb	w2, [x2, #:lo12:.LANCHOR78]
	ldrh	w1, [x1, x0]
	adrp	x0, .LANCHOR85
	ldrh	w0, [x0, #:lo12:.LANCHOR85]
	mul	w0, w0, w2
	cmp	w1, w0
	bgt	.L3465
	mov	w0, w6
	str	wzr, [x5, #:lo12:.LANCHOR151]
	mov	w2, 4
	mov	w1, 2
.L3601:
	bl	gc_search_src_blk
	and	w0, w0, 65535
	cbz	w0, .L3465
	b	.L3455
.L3466:
	adrp	x0, .LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR92]
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w1, w0
	bcc	.L3468
	mov	w2, 1
	mov	w1, 2
	mov	w0, w2
	b	.L3601
.L3468:
	ldrh	w0, [x27, #:lo12:.LANCHOR90]
	cbnz	w0, .L3469
	ldr	x0, [x29, 104]
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w0, 8
	bls	.L3462
.L3469:
	mov	w1, 1
	mov	w2, 4
	mov	w0, w1
	b	.L3601
.L3458:
	adrp	x0, .LANCHOR79
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	cmp	w0, w21
	bcc	.L3544
	b	.L3465
.L3470:
	adrp	x2, .LANCHOR79
	mov	x26, x2
	ldrh	w4, [x2, #:lo12:.LANCHOR79]
	cmp	w21, w4
	bcs	.L3471
	cbz	w22, .L3472
	cmp	w22, 16
	bls	.L3473
	adrp	x0, .LANCHOR92
	ldrh	w2, [x0, #:lo12:.LANCHOR92]
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w2, w0
	bhi	.L3473
	str	x3, [x29, 104]
	mov	w2, 4
	mov	w0, w1
	bl	gc_search_src_blk
	ldr	x3, [x29, 104]
	tst	w0, 65535
	bne	.L3474
	ldrb	w0, [x3, #:lo12:.LANCHOR76]
	mov	w2, 4
	mov	w1, 3
.L3607:
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L3475:
	cbnz	w0, .L3477
	b	.L3436
.L3474:
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w3, w0, 65535
	mov	w1, 65535
	cmp	w3, w1
	beq	.L3477
	adrp	x4, .LANCHOR9
	ubfiz	x3, x3, 1, 16
	adrp	x1, .LANCHOR151
	mov	x21, x1
	ldr	x4, [x4, #:lo12:.LANCHOR9]
	ldr	w2, [x1, #:lo12:.LANCHOR151]
	add	w2, w2, 1
	str	w2, [x1, #:lo12:.LANCHOR151]
	ldrh	w3, [x4, x3]
	adrp	x4, .LANCHOR85
	ldrh	w4, [x4, #:lo12:.LANCHOR85]
	cmp	w4, w3
	bcs	.L3478
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	cmp	w2, w1, lsr 4
	bls	.L3477
	adrp	x1, .LANCHOR91
	ldrh	w1, [x1, #:lo12:.LANCHOR91]
	cmp	w1, w3
	bls	.L3477
.L3478:
	ldrb	w2, [x23, #:lo12:.LANCHOR76]
	mov	w1, 0
	bl	gc_add_sblk
	str	wzr, [x21, #:lo12:.LANCHOR151]
	adrp	x0, .LANCHOR114
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR114]
.L3477:
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR150]
	b	.L3436
.L3473:
	mov	w2, 1
	mov	w0, w2
	mov	w1, 2
.L3610:
	bl	gc_search_src_blk
	tst	w0, 65535
	bne	.L3477
	mov	w2, 2
	b	.L3603
.L3472:
	ldr	w1, [x28, #:lo12:.LANCHOR14]
	strb	wzr, [x3, #:lo12:.LANCHOR76]
	tbz	x1, 8, .L3480
	ldrh	w7, [x0, 122]
	mov	w5, 0
	ldrh	w6, [x0, 120]
	mov	w4, 0
	adrp	x0, .LC237
	mov	w3, w21
	mov	w2, 0
	mov	w1, 2115
	add	x0, x0, :lo12:.LC237
	bl	printf
.L3480:
	cmp	w21, 16
	bls	.L3481
	mov	w2, 4
.L3603:
	mov	w1, 3
	ldrb	w0, [x23, #:lo12:.LANCHOR76]
	b	.L3607
.L3481:
	mov	w2, 1
	ldrb	w0, [x23, #:lo12:.LANCHOR76]
	mov	w1, w2
	b	.L3610
.L3471:
	cmp	w25, 1
	bne	.L3436
	cmp	w21, w4, lsl 1
	bge	.L3482
	cmp	w24, w22, lsr 1
	bcs	.L3483
	adrp	x0, .LANCHOR92
	ldrh	w1, [x0, #:lo12:.LANCHOR92]
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w1, w0
	bcs	.L3483
	adrp	x0, .LANCHOR89
	ldrh	w0, [x0, #:lo12:.LANCHOR89]
	lsr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR79]
	b	.L3436
.L3483:
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w25, w0, 65535
	mov	w1, 65535
	mov	w28, w25
	cmp	w25, w1
	bne	.L3484
.L3489:
	cmp	w22, 1
	bhi	.L3485
.L3486:
	cmp	w21, w24
	adrp	x21, .LANCHOR89
	bcs	.L3493
	strb	wzr, [x23, #:lo12:.LANCHOR76]
	mov	w0, 4
	bl	zftl_get_gc_node.part.9
	and	w0, w0, 65535
	mov	w1, 65535
	cmp	w0, w1
	beq	.L3493
	adrp	x1, .LANCHOR9
	ubfiz	x0, x0, 1, 16
	adrp	x2, .LANCHOR78
	ldr	x1, [x1, #:lo12:.LANCHOR9]
	ldrb	w2, [x2, #:lo12:.LANCHOR78]
	ldrh	w1, [x1, x0]
	adrp	x0, .LANCHOR85
	ldrh	w0, [x0, #:lo12:.LANCHOR85]
	mul	w0, w0, w2
	cmp	w1, w0, lsr 1
	ble	.L3495
.L3493:
	ldrh	w0, [x21, #:lo12:.LANCHOR89]
	lsr	w0, w0, 2
	strh	w0, [x26, #:lo12:.LANCHOR79]
	b	.L3436
.L3484:
	adrp	x2, .LANCHOR151
	adrp	x3, .LANCHOR6
	uxtw	x25, w25
	ldr	w1, [x2, #:lo12:.LANCHOR151]
	ldrh	w3, [x3, #:lo12:.LANCHOR6]
	add	w1, w1, 1
	str	w1, [x2, #:lo12:.LANCHOR151]
	cmp	w1, w3, lsr 4
	adrp	x3, .LANCHOR9
	bls	.L3487
	ldr	x1, [x3, #:lo12:.LANCHOR9]
	str	wzr, [x2, #:lo12:.LANCHOR151]
	ldrh	w2, [x1, x25, lsl 1]
	adrp	x1, .LANCHOR91
	ldrh	w1, [x1, #:lo12:.LANCHOR91]
	cmp	w2, w1
	bcs	.L3487
	str	x3, [x29, 96]
	mov	w2, 1
	mov	w1, 0
	bl	gc_add_sblk
	ldr	x3, [x29, 96]
	cbnz	w0, .L3477
.L3487:
	ldr	x0, [x3, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, x25, lsl 1]
	adrp	x0, .LANCHOR85
	ldrh	w0, [x0, #:lo12:.LANCHOR85]
	cmp	w1, w0, lsr 1
	bhi	.L3488
	mov	w2, 0
	mov	w1, 1
	mov	w0, w28
	bl	gc_add_sblk
	b	.L3477
.L3488:
	ldr	x2, [x29, 104]
	ldrh	w0, [x27, #:lo12:.LANCHOR90]
	ldrh	w2, [x2, #:lo12:.LANCHOR88]
	add	w0, w0, w2
	adrp	x2, .LANCHOR89
	ldrh	w2, [x2, #:lo12:.LANCHOR89]
	cmp	w0, w2, lsl 1
	ble	.L3489
	adrp	x0, .LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w0, w1
	bcc	.L3486
	b	.L3489
.L3485:
	mov	w1, 1
	strb	w1, [x23, #:lo12:.LANCHOR76]
	cmp	w22, 16
	bls	.L3490
	adrp	x0, .LANCHOR92
	ldrh	w2, [x0, #:lo12:.LANCHOR92]
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w2, w0
	bhi	.L3490
	mov	w2, 4
	mov	w0, w1
	bl	gc_search_src_blk
	ands	w0, w0, 65535
	bne	.L3491
	mov	w2, 4
.L3602:
	ldrb	w0, [x23, #:lo12:.LANCHOR76]
	mov	w1, 3
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L3491:
	adrp	x1, .LANCHOR89
	cmp	w21, w24, lsr 1
	ldrh	w1, [x1, #:lo12:.LANCHOR89]
	bls	.L3605
	lsr	w1, w1, 2
.L3606:
	strh	w1, [x26, #:lo12:.LANCHOR79]
	b	.L3475
.L3490:
	mov	w2, 1
	mov	w1, 2
	mov	w0, w2
	bl	gc_search_src_blk
	ands	w0, w0, 65535
	bne	.L3491
	mov	w2, 2
	b	.L3602
.L3495:
	mov	w1, 3
	mov	w2, 4
	mov	w0, 0
	bl	gc_search_src_blk
	ldrh	w1, [x21, #:lo12:.LANCHOR89]
	and	w0, w0, 65535
.L3605:
	lsr	w1, w1, 1
	b	.L3606
.L3482:
	adrp	x0, .LANCHOR89
	mov	w20, 0
	ldrh	w0, [x0, #:lo12:.LANCHOR89]
	lsr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR79]
	b	.L3436
.L3440:
	adrp	x7, .LANCHOR63
	mov	w0, 65535
	ldrh	w1, [x7, #:lo12:.LANCHOR63]
	cmp	w1, w0
	bne	.L3496
	bl	gc_get_src_blk
	strh	w0, [x7, #:lo12:.LANCHOR63]
.L3496:
	ldrh	w3, [x7, #:lo12:.LANCHOR63]
	mov	w0, 65535
	add	x1, x7, :lo12:.LANCHOR63
	cmp	w3, w0
	beq	.L3612
	adrp	x0, .LANCHOR7
	ldrh	w5, [x1, 56]
	uxtw	x4, w3
	ldr	x2, [x0, #:lo12:.LANCHOR7]
	add	x2, x2, x4, lsl 2
	cbz	w5, .L3498
	add	x1, x1, 58
	mov	w0, 0
.L3500:
	ldrh	w6, [x1], 2
	cmp	w6, w3
	bne	.L3499
.L3504:
	adrp	x0, .LANCHOR63
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR63]
	b	.L3544
.L3499:
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w5, w0
	bne	.L3500
.L3498:
	ldrb	w0, [x2, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L3501
	tst	w0, 192
	bne	.L3502
.L3501:
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, x4, lsl 1]
	cbz	w0, .L3504
	mov	w2, 2348
	adrp	x1, .LANCHOR220
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR220
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3504
.L3502:
	mov	w0, 2
	b	.L3613
.L3441:
	bl	gc_scan_src_blk
	cmn	w0, #1
	bne	.L3505
	mov	w0, 3
	b	.L3613
.L3505:
	adrp	x20, .LANCHOR63
	mov	w2, 65535
	add	x0, x20, :lo12:.LANCHOR63
	ldrh	w1, [x20, #:lo12:.LANCHOR63]
	cmp	w1, w2
	beq	.L3455
	ldrh	w2, [x0, 24]
	cbz	w2, .L3506
	mov	w1, 4
	strh	wzr, [x0, 26]
	strb	w1, [x19, #:lo12:.LANCHOR150]
	b	.L3544
.L3506:
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR150]
	adrp	x0, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	mov	x19, x0
	ldr	x2, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x2, x1]
	cbz	w1, .L3507
	adrp	x1, .LANCHOR220
	adrp	x0, .LC0
	mov	w2, 2376
	add	x1, x1, :lo12:.LANCHOR220
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3507:
	ldrh	w0, [x20, #:lo12:.LANCHOR63]
	add	x21, x20, :lo12:.LANCHOR63
	bl	ftl_free_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR9]
	ldrh	w1, [x20, #:lo12:.LANCHOR63]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x21, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w0, 8
	bhi	.L3508
	strh	w0, [x21, 30]
	b	.L3504
.L3508:
	strh	wzr, [x21, 30]
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	b	.L3504
.L3442:
	adrp	x20, .LANCHOR63
	adrp	x23, .LANCHOR85
	add	x22, x20, :lo12:.LANCHOR63
	add	x23, x23, :lo12:.LANCHOR85
.L3581:
	bl	gc_scan_src_blk_one_page
	ldrh	w1, [x22, 2]
	ldrh	w0, [x23]
	cmp	w1, w0
	bcs	.L3510
	cmp	w21, 7
	bls	.L3581
	b	.L3544
.L3510:
	ldrh	w3, [x22, 24]
	adrp	x0, .LANCHOR14
	cbz	w3, .L3511
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	mov	w1, 4
	strh	wzr, [x22, 26]
	strb	w1, [x19, #:lo12:.LANCHOR150]
	adrp	x19, .LANCHOR9
	tbz	x0, 8, .L3512
	ldrh	w1, [x22]
	ldr	x2, [x19, #:lo12:.LANCHOR9]
	ubfiz	x0, x1, 1, 16
	ldrh	w2, [x2, x0]
	adrp	x0, .LC238
	add	x0, x0, :lo12:.LC238
	bl	printf
.L3512:
	ldrh	w2, [x20, #:lo12:.LANCHOR63]
	add	x0, x20, :lo12:.LANCHOR63
	ldr	x1, [x19, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, 24]
	ldrh	w1, [x1, x2, lsl 1]
	cmp	w1, w0
	beq	.L3513
	adrp	x1, .LANCHOR220
	adrp	x0, .LC0
	mov	w2, 2410
	add	x1, x1, :lo12:.LANCHOR220
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3513:
	add	x0, x20, :lo12:.LANCHOR63
	ldrh	w1, [x20, #:lo12:.LANCHOR63]
	ldrh	w2, [x0, 24]
	ldr	x0, [x19, #:lo12:.LANCHOR9]
	strh	w2, [x0, x1, lsl 1]
	b	.L3544
.L3511:
	adrp	x2, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	ldrh	w1, [x22]
	ldr	x21, [x2, #:lo12:.LANCHOR7]
	mov	w2, 1
	strb	w2, [x19, #:lo12:.LANCHOR150]
	add	x21, x21, x1, uxth 2
	tbz	x0, 8, .L3514
	ldrb	w2, [x21, 2]
	adrp	x0, .LC239
	add	x0, x0, :lo12:.LC239
	ubfx	x2, x2, 5, 3
	bl	printf
.L3514:
	ldrb	w0, [x21, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L3515
	tst	w0, 192
	bne	.L3516
.L3515:
	adrp	x1, .LANCHOR220
	adrp	x0, .LC0
	mov	w2, 2420
	add	x1, x1, :lo12:.LANCHOR220
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3516:
	ldrh	w0, [x20, #:lo12:.LANCHOR63]
	add	x19, x20, :lo12:.LANCHOR63
	bl	ftl_free_sblk
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR63]
	ldrh	w0, [x19, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w0, 8
	bhi	.L3517
	strh	w0, [x19, 30]
	b	.L3544
.L3517:
	strh	wzr, [x19, 30]
.L3611:
	bl	flt_sys_flush
	b	.L3544
.L3443:
	ldrh	w1, [x20, 80]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L3518
	adrp	x0, .LANCHOR76
	ldrb	w22, [x0, #:lo12:.LANCHOR76]
	cmp	w22, 1
	bne	.L3518
	bl	ftl_flush
	adrp	x0, .LANCHOR63
	add	x1, x0, :lo12:.LANCHOR63
	mov	x21, x0
	ldrh	w1, [x1, 318]
	cbz	w1, .L3519
	mov	w0, w22
	mov	w1, 5
.L3608:
	bl	zftl_gc_get_free_sblk
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	beq	.L3521
	adrp	x0, .LANCHOR7
	ldr	x22, [x0, #:lo12:.LANCHOR7]
	add	x22, x22, x19, uxth 2
	ldrb	w0, [x22, 2]
	tst	w0, 224
	beq	.L3522
	adrp	x1, .LANCHOR220
	adrp	x0, .LC0
	mov	w2, 2449
	add	x1, x1, :lo12:.LANCHOR220
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3522:
	ldrb	w0, [x22, 2]
	mov	w1, 5
	bfi	w0, w1, 5, 3
	orr	w0, w0, 16
	strb	w0, [x22, 2]
.L3543:
	mov	w1, 1
	mov	w0, w19
	bl	ftl_erase_sblk
	adrp	x22, .LANCHOR77
	mov	w0, 5
	strb	w0, [x20, 84]
	add	x1, x20, 96
	mov	w0, w19
	bl	ftl_get_blk_list_in_sblk
	and	w0, w0, 255
	adrp	x1, .LANCHOR85
	strb	w0, [x20, 89]
	strh	w19, [x20, 80]
	ldrh	w1, [x1, #:lo12:.LANCHOR85]
	strh	wzr, [x20, 82]
	strb	wzr, [x20, 85]
	strh	wzr, [x20, 90]
	mul	w0, w0, w1
	ldrh	w2, [x22, #:lo12:.LANCHOR77]
	strh	w0, [x20, 86]
	adrp	x20, .LANCHOR78
	mov	w1, 255
	ldrb	w0, [x20, #:lo12:.LANCHOR78]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR152
	ldr	x0, [x0, #:lo12:.LANCHOR152]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x20, #:lo12:.LANCHOR78]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR77]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR153
	ldr	x0, [x0, #:lo12:.LANCHOR153]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x20, #:lo12:.LANCHOR78]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR77]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR74
	ldr	x0, [x0, #:lo12:.LANCHOR74]
	bl	ftl_memset
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	mov	w1, -1
	str	w19, [x0, 132]
	strh	w1, [x0, 128]
	strh	w1, [x0, 130]
	bl	pm_flush
	bl	ftl_ext_info_flush
	adrp	x0, .LANCHOR102
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR102]
	strh	w19, [x0, 126]
	add	x0, x21, :lo12:.LANCHOR63
	str	w1, [x0, 324]
	strh	wzr, [x0, 314]
	strh	wzr, [x0, 56]
	strh	wzr, [x0, 316]
	strh	wzr, [x0, 320]
	mov	w0, 0
	bl	ftl_info_flush
	b	.L3544
.L3519:
	mov	w1, 5
	mov	w0, 0
	b	.L3608
.L3518:
	cmp	w25, 1
	mov	w22, 4
	csinc	w22, w22, wzr, eq
	cmp	w21, 15
	mov	w0, w22
	add	w22, w22, 4
	adrp	x25, .LANCHOR76
	adrp	x24, .LANCHOR63
	csel	w22, w22, w0, ls
	add	x25, x25, :lo12:.LANCHOR76
	add	x21, x24, :lo12:.LANCHOR63
	add	x26, x20, 80
.L3525:
	sub	w22, w22, #1
	and	w22, w22, 255
	cmp	w22, 255
	beq	.L3544
	bl	gc_do_copy_back
	ldrb	w0, [x25]
	cbnz	w0, .L3526
	adrp	x0, .LANCHOR52
	ldrb	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, 3
	bhi	.L3527
	bl	ftl_write_commit
.L3527:
	ldrh	w1, [x21, 26]
	ldrh	w0, [x21, 24]
	cmp	w1, w0
	bcc	.L3525
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR150]
	bl	ftl_write_commit
	bl	ftl_flush
	adrp	x0, .LANCHOR9
	ldrh	w2, [x21]
	mov	x19, x0
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x1, x2, lsl 1]
	cbz	w1, .L3529
	adrp	x1, .LANCHOR220
	adrp	x0, .LC0
	mov	w2, 2524
	add	x1, x1, :lo12:.LANCHOR220
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3529:
	ldrh	w0, [x24, #:lo12:.LANCHOR63]
	ldr	x2, [x19, #:lo12:.LANCHOR9]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbnz	w1, .L3530
	bl	ftl_free_sblk
	b	.L3504
.L3530:
	mov	w2, 1
	mov	w1, 0
	bl	gc_add_sblk
	b	.L3504
.L3526:
	ldrh	w0, [x21, 320]
	cbz	w0, .L3531
	strh	wzr, [x21, 320]
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	w0, [x21, 324]
	cmn	w0, #1
	beq	.L3532
	bl	ftl_mask_bad_block
.L3532:
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	add	x20, x24, :lo12:.LANCHOR63
	strh	wzr, [x20, 56]
	ldrh	w0, [x0, 80]
	str	wzr, [x20, 324]
	bl	ftl_free_sblk
	adrp	x2, .LANCHOR102
	ldr	x1, [x23, #:lo12:.LANCHOR10]
	mov	w0, -1
	ldr	x2, [x2, #:lo12:.LANCHOR102]
	strh	w0, [x1, 80]
	strh	w0, [x2, 126]
	strh	w0, [x1, 130]
	ldr	x0, [x20, 8]
	cbz	x0, .L3533
	bl	buf_free
.L3533:
	add	x24, x24, :lo12:.LANCHOR63
	str	xzr, [x24, 8]
	bl	flt_sys_flush
	mov	w2, 2562
	strb	wzr, [x19, #:lo12:.LANCHOR150]
	adrp	x1, .LANCHOR220
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR220
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3544
.L3531:
	ldrh	w0, [x26, 6]
	ldrh	w1, [x21, 26]
	cmp	w0, 1
	ldrh	w0, [x21, 24]
	bls	.L3534
	cmp	w1, w0
	bcc	.L3525
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR150]
	ldrh	w0, [x21, 56]
	add	w1, w0, 1
	strh	w1, [x21, 56]
	add	x0, x21, x0, sxtw 1
	ldrh	w1, [x21]
	strh	w1, [x0, 58]
	mov	w0, -1
	strh	w0, [x21]
	b	.L3544
.L3534:
	mov	w2, 5
	strb	w2, [x19, #:lo12:.LANCHOR150]
	cmp	w1, w0
	bcc	.L3535
	ldrh	w0, [x21, 56]
	add	w1, w0, 1
	strh	w1, [x21, 56]
	add	x0, x21, x0, sxtw 1
	ldrh	w1, [x21]
	strh	w1, [x0, 58]
	mov	w0, -1
	strh	w0, [x21]
.L3535:
	bl	ftl_flush
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	ldrh	w1, [x20, 80]
	strh	w1, [x0, 128]
	bl	pm_flush
	bl	ftl_ext_info_flush
	add	x0, x24, :lo12:.LANCHOR63
	adrp	x1, .LANCHOR85
	adrp	x2, .LANCHOR71
	ldrh	w1, [x1, #:lo12:.LANCHOR85]
	ldrb	w2, [x2, #:lo12:.LANCHOR71]
	strh	wzr, [x0, 16]
	strh	w1, [x0, 18]
	cmp	w2, 2
	strh	w2, [x0, 20]
	bne	.L3537
	ubfiz	w1, w1, 1, 15
	strh	w1, [x0, 18]
	adrp	x1, .LANCHOR72
	ldrb	w1, [x1, #:lo12:.LANCHOR72]
	cbnz	w1, .L3537
	mov	w1, 1
	strh	w1, [x0, 20]
.L3537:
	add	x24, x24, :lo12:.LANCHOR63
	strh	wzr, [x24, 22]
	b	.L3544
.L3540:
	ldrh	w1, [x24, 16]
	ldrh	w0, [x24, 18]
	cmp	w1, w0
	bcc	.L3541
	mov	w0, 6
	strb	w0, [x19, #:lo12:.LANCHOR150]
	ldr	x0, [x24, 8]
	bl	buf_free
	str	xzr, [x24, 8]
	b	.L3544
.L3541:
	cmp	w21, 15
	bls	.L3446
	cmp	w25, 1
	bne	.L3544
	add	w22, w22, 1
	and	w22, w22, 255
	cmp	w22, 4
	bls	.L3446
	b	.L3544
.L3445:
	bl	gc_update_l2p_map_new
	mov	w21, -1
	bl	gc_free_src_blk
	bl	ftl_flush
	bl	pm_flush
	strh	w21, [x20, 80]
	bl	ftl_ext_info_flush
	adrp	x0, .LANCHOR102
	ldr	x0, [x0, #:lo12:.LANCHOR102]
	strh	w21, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
.L3612:
	strb	wzr, [x19, #:lo12:.LANCHOR150]
	b	.L3544
.L3521:
	mov	w2, 2455
	adrp	x1, .LANCHOR220
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR220
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3543
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
	tbz	x0, 12, .L3615
	ldr	w4, [x23]
	mov	w3, w2
	adrp	x0, .LC240
	mov	w2, w1
	add	x0, x0, :lo12:.LC240
	mov	w1, w27
	bl	printf
.L3615:
	cbnz	w27, .L3616
	adrp	x0, .LANCHOR59
	mov	w27, 24576
	ldr	w0, [x0, #:lo12:.LANCHOR59]
.L3617:
	add	w1, w19, w20
	cmp	w0, w1
	bcc	.L3631
	adrp	x24, .LANCHOR123
	add	w27, w27, w19
	sub	w19, w20, #1
	adrp	x25, .LANCHOR102
	ldrb	w0, [x24, #:lo12:.LANCHOR123]
	add	w19, w19, w27
	add	x24, x24, :lo12:.LANCHOR123
	udiv	w22, w27, w0
	udiv	w19, w19, w0
	add	w0, w27, w20
	str	w0, [x29, 108]
	mov	w26, w22
	sub	w21, w19, w22
	add	w21, w21, 1
.L3619:
	cbnz	w21, .L3627
	adrp	x20, .LANCHOR95
	adrp	x19, .LANCHOR99
	add	x20, x20, :lo12:.LANCHOR95
	add	x19, x19, :lo12:.LANCHOR99
	bl	ftl_write_commit
	bl	ftl_flush
	mov	w1, 1
	mov	w0, 0
	bl	zftl_do_gc
.L3628:
	ldrh	w0, [x20]
	ldrh	w1, [x19]
	add	w0, w0, w1
	cmp	w0, 7
	ble	.L3629
	mov	w0, 0
.L3614:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L3616:
	cmp	w27, 3
	bhi	.L3631
	lsl	w27, w27, 13
	mov	w0, 8192
	b	.L3617
.L3627:
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L3620
	bl	ftl_write_commit
	b	.L3619
.L3620:
	ldrb	w3, [x24]
	cmp	w26, w22
	strb	wzr, [x0, 57]
	ccmp	w26, w19, 4, ne
	strb	w3, [x0, 56]
	bne	.L3623
	cmp	w26, w22
	bne	.L3624
	udiv	w0, w27, w3
	msub	w0, w0, w3, w27
	and	w0, w0, 255
	strb	w0, [x28, 57]
	sub	w3, w3, w0
	and	w3, w3, 255
	cmp	w20, w3
	csel	w3, w20, w3, cc
.L3636:
	strb	w3, [x28, 56]
.L3623:
	ldr	x3, [x28, 8]
	mov	x1, x23
	ldrb	w0, [x28, 57]
	sub	w21, w21, #1
	ldrb	w2, [x28, 56]
	ubfiz	x0, x0, 9, 8
	lsl	w2, w2, 9
	add	x0, x3, x0
	bl	ftl_memcpy
	ldr	x1, [x25, #:lo12:.LANCHOR102]
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
	b	.L3619
.L3624:
	ldr	w0, [x29, 108]
	msub	w3, w3, w26, w0
	b	.L3636
.L3629:
	mov	w1, 1
	mov	w0, 0
	bl	zftl_do_gc
	b	.L3628
.L3631:
	mov	w0, -1
	b	.L3614
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
	bne	.L3642
	mov	w3, w2
	mov	w0, 0
	mov	x2, x20
	bl	idb_write_data
.L3642:
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
	adrp	x2, .LANCHOR59
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	ldr	w2, [x2, #:lo12:.LANCHOR59]
	add	w1, w0, w1
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w2, w1
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	bcc	.L3665
	adrp	x24, .LANCHOR221
	add	w22, w0, 24576
	adrp	x0, .LANCHOR14
	str	x0, [x29, 104]
	ldr	w1, [x24, #:lo12:.LANCHOR221]
	ldr	w2, [x0, #:lo12:.LANCHOR14]
	add	w1, w19, w1
	str	w1, [x24, #:lo12:.LANCHOR221]
	tbz	x2, 12, .L3646
	adrp	x0, .LC241
	mov	w4, 0
	mov	w3, w19
	mov	w2, w22
	add	x0, x0, :lo12:.LC241
	bl	printf
.L3646:
	adrp	x23, .LANCHOR102
	adrp	x26, .LANCHOR123
	ldr	x0, [x23, #:lo12:.LANCHOR102]
	ldr	w27, [x0, 8]
	add	w1, w27, 1
	str	w1, [x0, 8]
	bl	ftl_write_commit
	bl	ftl_flush
	ldrb	w21, [x26, #:lo12:.LANCHOR123]
	udiv	w20, w22, w21
	msub	w25, w20, w21, w22
	cbz	w25, .L3647
	sub	w21, w21, w25
	mov	w0, w20
	cmp	w21, w19
	csel	w21, w21, w19, ls
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	bne	.L3648
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
.L3648:
	ldr	w0, [x29, 120]
	and	w28, w21, 65535
	cmn	w0, #1
	beq	.L3650
	mov	w0, 0
	bl	buf_alloc
	mov	x3, x0
	cbz	x0, .L3650
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
	ldr	x1, [x23, #:lo12:.LANCHOR102]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L3650:
	add	w20, w20, 1
	sub	w19, w19, w28
.L3647:
	cbz	w19, .L3652
	bl	ftl_flush
.L3652:
	adrp	x25, .LANCHOR66
	add	x21, x26, :lo12:.LANCHOR123
	add	x25, x25, :lo12:.LANCHOR66
	mov	w0, -1
	str	w0, [x29, 124]
.L3653:
	ldrb	w0, [x21]
	cmp	w19, w0
	bcs	.L3658
	cbz	w19, .L3660
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	bne	.L3661
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
.L3661:
	ldr	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3660
	mov	w0, 0
	bl	buf_alloc
	mov	x21, x0
	cbz	x0, .L3660
	strb	wzr, [x0, 57]
	strb	w19, [x0, 56]
	stp	w27, w20, [x21, 32]
	ldrb	w0, [x26, #:lo12:.LANCHOR123]
	cmp	w19, w0
	bcc	.L3663
	adrp	x1, .LANCHOR222
	adrp	x0, .LC0
	mov	w2, 1251
	add	x1, x1, :lo12:.LANCHOR222
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3663:
	ldr	x0, [x21, 8]
	lsl	w2, w19, 9
	mov	w1, 0
	bl	ftl_memset
	mov	x0, x21
	bl	ftl_write_buf
	bl	ftl_write_commit
	ldr	x1, [x23, #:lo12:.LANCHOR102]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L3660:
	ldr	w1, [x24, #:lo12:.LANCHOR221]
	cmp	w1, 8192
	bls	.L3666
	ldr	x0, [x29, 104]
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3664
	adrp	x0, .LC241
	mov	w4, 0
	mov	w3, w19
	mov	w2, w22
	add	x0, x0, :lo12:.LC241
	bl	printf
.L3664:
	str	wzr, [x24, #:lo12:.LANCHOR221]
	bl	flt_sys_flush
	adrp	x0, .LANCHOR114
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR114]
.L3666:
	mov	w0, 0
	b	.L3644
.L3658:
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3654
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbz	x0, .L3656
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
.L3692:
	ldr	x1, [x23, #:lo12:.LANCHOR102]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L3656:
	ldrb	w0, [x21]
	add	w20, w20, 1
	sub	w19, w19, w0
	b	.L3653
.L3654:
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
	ldr	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3656
	add	x1, x29, 124
	mov	w2, 1
	mov	w0, w20
	bl	pm_log2phys
	ldrh	w3, [x25]
	mov	w0, 21
	ldr	w1, [x29, 120]
	sub	w2, w0, w3
	mov	w0, 1
	lsr	w1, w1, w3
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR67
	ldrb	w1, [x1, #:lo12:.LANCHOR67]
	udiv	w0, w0, w1
	bl	ftl_vpn_decrement
	b	.L3692
.L3665:
	mov	w0, -1
.L3644:
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
	.section	.bss.IDByte,"aw",@nobits
	.align	2
	.set	.LANCHOR42,. + 0
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
	.set	.LANCHOR66,. + 0
	.type	_c_ftl_block_addr_log2, %object
	.size	_c_ftl_block_addr_log2, 2
_c_ftl_block_addr_log2:
	.zero	2
	.section	.bss._c_ftl_block_align_addr,"aw",@nobits
	.align	1
	.set	.LANCHOR103,. + 0
	.type	_c_ftl_block_align_addr, %object
	.size	_c_ftl_block_align_addr, 2
_c_ftl_block_align_addr:
	.zero	2
	.section	.bss._c_ftl_byte_pre_page,"aw",@nobits
	.align	1
	.set	.LANCHOR203,. + 0
	.type	_c_ftl_byte_pre_page, %object
	.size	_c_ftl_byte_pre_page, 2
_c_ftl_byte_pre_page:
	.zero	2
	.section	.bss._c_ftl_nand_blks_per_die,"aw",@nobits
	.align	1
	.type	_c_ftl_nand_blks_per_die, %object
	.size	_c_ftl_nand_blks_per_die, 2
_c_ftl_nand_blks_per_die:
	.zero	2
	.section	.bss._c_ftl_nand_die_num,"aw",@nobits
	.set	.LANCHOR104,. + 0
	.type	_c_ftl_nand_die_num, %object
	.size	_c_ftl_nand_die_num, 1
_c_ftl_nand_die_num:
	.zero	1
	.section	.bss._c_ftl_nand_planes_num,"aw",@nobits
	.set	.LANCHOR78,. + 0
	.type	_c_ftl_nand_planes_num, %object
	.size	_c_ftl_nand_planes_num, 1
_c_ftl_nand_planes_num:
	.zero	1
	.section	.bss._c_ftl_nand_type,"aw",@nobits
	.set	.LANCHOR71,. + 0
	.type	_c_ftl_nand_type, %object
	.size	_c_ftl_nand_type, 1
_c_ftl_nand_type:
	.zero	1
	.section	.bss._c_ftl_page_pre_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR77,. + 0
	.type	_c_ftl_page_pre_blk, %object
	.size	_c_ftl_page_pre_blk, 2
_c_ftl_page_pre_blk:
	.zero	2
	.section	.bss._c_ftl_page_pre_slc_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR85,. + 0
	.type	_c_ftl_page_pre_slc_blk, %object
	.size	_c_ftl_page_pre_slc_blk, 2
_c_ftl_page_pre_slc_blk:
	.zero	2
	.section	.bss._c_ftl_planes_per_die,"aw",@nobits
	.set	.LANCHOR67,. + 0
	.type	_c_ftl_planes_per_die, %object
	.size	_c_ftl_planes_per_die, 1
_c_ftl_planes_per_die:
	.zero	1
	.section	.bss._c_ftl_pm_page_num,"aw",@nobits
	.align	1
	.set	.LANCHOR187,. + 0
	.type	_c_ftl_pm_page_num, %object
	.size	_c_ftl_pm_page_num, 2
_c_ftl_pm_page_num:
	.zero	2
	.section	.bss._c_ftl_sec_per_page,"aw",@nobits
	.set	.LANCHOR123,. + 0
	.type	_c_ftl_sec_per_page, %object
	.size	_c_ftl_sec_per_page, 1
_c_ftl_sec_per_page:
	.zero	1
	.section	.bss._c_max_pm_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR146,. + 0
	.type	_c_max_pm_sblk, %object
	.size	_c_max_pm_sblk, 2
_c_max_pm_sblk:
	.zero	2
	.section	.bss._c_mix_max_slc_ec_count,"aw",@nobits
	.align	1
	.set	.LANCHOR118,. + 0
	.type	_c_mix_max_slc_ec_count, %object
	.size	_c_mix_max_slc_ec_count, 2
_c_mix_max_slc_ec_count:
	.zero	2
	.section	.bss._c_mix_max_xlc_ec_count,"aw",@nobits
	.align	1
	.set	.LANCHOR116,. + 0
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
	.set	.LANCHOR145,. + 0
	.type	_c_swl_slc_gc_th, %object
	.size	_c_swl_slc_gc_th, 2
_c_swl_slc_gc_th:
	.zero	2
	.section	.bss._c_swl_xlc_gc_th,"aw",@nobits
	.align	1
	.set	.LANCHOR144,. + 0
	.type	_c_swl_xlc_gc_th, %object
	.size	_c_swl_xlc_gc_th, 2
_c_swl_xlc_gc_th:
	.zero	2
	.section	.bss._c_totle_data_density,"aw",@nobits
	.align	2
	.set	.LANCHOR208,. + 0
	.type	_c_totle_data_density, %object
	.size	_c_totle_data_density, 4
_c_totle_data_density:
	.zero	4
	.section	.bss._c_totle_log_page,"aw",@nobits
	.align	2
	.set	.LANCHOR120,. + 0
	.type	_c_totle_log_page, %object
	.size	_c_totle_log_page, 4
_c_totle_log_page:
	.zero	4
	.section	.bss._c_totle_phy_density,"aw",@nobits
	.align	2
	.set	.LANCHOR207,. + 0
	.type	_c_totle_phy_density, %object
	.size	_c_totle_phy_density, 4
_c_totle_phy_density:
	.zero	4
	.section	.bss._c_user_data_density,"aw",@nobits
	.align	2
	.set	.LANCHOR59,. + 0
	.type	_c_user_data_density, %object
	.size	_c_user_data_density, 4
_c_user_data_density:
	.zero	4
	.section	.bss._gc_after_discard_en,"aw",@nobits
	.align	2
	.set	.LANCHOR114,. + 0
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
	.set	.LANCHOR117,. + 0
	.type	_max_slc_super_block, %object
	.size	_max_slc_super_block, 2
_max_slc_super_block:
	.zero	2
	.section	.bss._max_xlc_super_block,"aw",@nobits
	.align	1
	.set	.LANCHOR93,. + 0
	.type	_max_xlc_super_block, %object
	.size	_max_xlc_super_block, 2
_max_xlc_super_block:
	.zero	2
	.section	.bss._min_slc_super_block,"aw",@nobits
	.align	1
	.set	.LANCHOR89,. + 0
	.type	_min_slc_super_block, %object
	.size	_min_slc_super_block, 2
_min_slc_super_block:
	.zero	2
	.section	.bss.discard_sector_count,"aw",@nobits
	.align	2
	.set	.LANCHOR221,. + 0
	.type	discard_sector_count, %object
	.size	discard_sector_count, 4
discard_sector_count:
	.zero	4
	.section	.bss.fill_spare_size,"aw",@nobits
	.align	1
	.set	.LANCHOR48,. + 0
	.type	fill_spare_size, %object
	.size	fill_spare_size, 2
fill_spare_size:
	.zero	2
	.section	.bss.flash_ddr_tuning_sdr_read_count,"aw",@nobits
	.align	2
	.set	.LANCHOR160,. + 0
	.type	flash_ddr_tuning_sdr_read_count, %object
	.size	flash_ddr_tuning_sdr_read_count, 4
flash_ddr_tuning_sdr_read_count:
	.zero	4
	.section	.bss.flash_read_retry,"aw",@nobits
	.align	3
	.set	.LANCHOR162,. + 0
	.type	flash_read_retry, %object
	.size	flash_read_retry, 8
flash_read_retry:
	.zero	8
	.section	.bss.free_buf_count,"aw",@nobits
	.set	.LANCHOR52,. + 0
	.type	free_buf_count, %object
	.size	free_buf_count, 1
free_buf_count:
	.zero	1
	.section	.bss.free_mix_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR99,. + 0
	.type	free_mix_sblk, %object
	.size	free_mix_sblk, 2
free_mix_sblk:
	.zero	2
	.section	.bss.free_slc_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR95,. + 0
	.type	free_slc_sblk, %object
	.size	free_slc_sblk, 2
free_slc_sblk:
	.zero	2
	.section	.bss.free_xlc_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR97,. + 0
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
	.set	.LANCHOR183,. + 0
	.type	ftl_ext_info_first_write, %object
	.size	ftl_ext_info_first_write, 1
ftl_ext_info_first_write:
	.zero	1
	.section	.bss.ftl_flush_jiffies,"aw",@nobits
	.align	2
	.set	.LANCHOR217,. + 0
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
	.set	.LANCHOR178,. + 0
	.type	ftl_info_spare, %object
	.size	ftl_info_spare, 256
ftl_info_spare:
	.zero	256
	.section	.bss.ftl_low_format_cur_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR60,. + 0
	.type	ftl_low_format_cur_blk, %object
	.size	ftl_low_format_cur_blk, 2
ftl_low_format_cur_blk:
	.zero	2
	.section	.bss.ftl_power_lost_flag,"aw",@nobits
	.set	.LANCHOR182,. + 0
	.type	ftl_power_lost_flag, %object
	.size	ftl_power_lost_flag, 1
ftl_power_lost_flag:
	.zero	1
	.section	.bss.ftl_sblk_lpa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR109,. + 0
	.type	ftl_sblk_lpa_tbl, %object
	.size	ftl_sblk_lpa_tbl, 8
ftl_sblk_lpa_tbl:
	.zero	8
	.section	.bss.ftl_sblk_update_list,"aw",@nobits
	.align	3
	.set	.LANCHOR65,. + 0
	.type	ftl_sblk_update_list, %object
	.size	ftl_sblk_update_list, 16
ftl_sblk_update_list:
	.zero	16
	.section	.bss.ftl_sblk_update_list_offset,"aw",@nobits
	.align	1
	.set	.LANCHOR115,. + 0
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
	.set	.LANCHOR64,. + 0
	.type	ftl_sblk_vpn_update_id, %object
	.size	ftl_sblk_vpn_update_id, 2
ftl_sblk_vpn_update_id:
	.zero	2
	.section	.bss.ftl_sys_info_first_write,"aw",@nobits
	.set	.LANCHOR181,. + 0
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
	.set	.LANCHOR176,. + 0
	.type	ftl_tmp_spare, %object
	.size	ftl_tmp_spare, 256
ftl_tmp_spare:
	.zero	256
	.section	.bss.ftl_vpn_update_count,"aw",@nobits
	.align	1
	.set	.LANCHOR113,. + 0
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
	.set	.LANCHOR50,. + 0
	.type	g_buf, %object
	.size	g_buf, 2048
g_buf:
	.zero	2048
	.section	.bss.g_die_addr,"aw",@nobits
	.align	2
	.set	.LANCHOR141,. + 0
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
	.set	.LANCHOR72,. + 0
	.type	g_flash_3d_mlc_flag, %object
	.size	g_flash_3d_mlc_flag, 1
g_flash_3d_mlc_flag:
	.zero	1
	.section	.bss.g_flash_3d_tlc_flag,"aw",@nobits
	.set	.LANCHOR75,. + 0
	.type	g_flash_3d_tlc_flag, %object
	.size	g_flash_3d_tlc_flag, 1
g_flash_3d_tlc_flag:
	.zero	1
	.section	.bss.g_flash_blk_info,"aw",@nobits
	.align	3
	.set	.LANCHOR195,. + 0
	.type	g_flash_blk_info, %object
	.size	g_flash_blk_info, 4
g_flash_blk_info:
	.zero	4
	.section	.bss.g_flash_cur_mode,"aw",@nobits
	.align	3
	.set	.LANCHOR32,. + 0
	.type	g_flash_cur_mode, %object
	.size	g_flash_cur_mode, 4
g_flash_cur_mode:
	.zero	4
	.section	.bss.g_flash_interface_mode,"aw",@nobits
	.set	.LANCHOR43,. + 0
	.type	g_flash_interface_mode, %object
	.size	g_flash_interface_mode, 1
g_flash_interface_mode:
	.zero	1
	.section	.bss.g_flash_multi_page_prog_en,"aw",@nobits
	.set	.LANCHOR39,. + 0
	.type	g_flash_multi_page_prog_en, %object
	.size	g_flash_multi_page_prog_en, 1
g_flash_multi_page_prog_en:
	.zero	1
	.section	.bss.g_flash_multi_page_read_en,"aw",@nobits
	.set	.LANCHOR168,. + 0
	.type	g_flash_multi_page_read_en, %object
	.size	g_flash_multi_page_read_en, 1
g_flash_multi_page_read_en:
	.zero	1
	.section	.bss.g_flash_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR164,. + 0
	.type	g_flash_page_buffer, %object
	.size	g_flash_page_buffer, 8
g_flash_page_buffer:
	.zero	8
	.section	.bss.g_flash_reversd_blks,"aw",@nobits
	.set	.LANCHOR200,. + 0
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
	.set	.LANCHOR163,. + 0
	.type	g_flash_spare_buffer, %object
	.size	g_flash_spare_buffer, 8
g_flash_spare_buffer:
	.zero	8
	.section	.bss.g_flash_sys_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR194,. + 0
	.type	g_flash_sys_spare_buffer, %object
	.size	g_flash_sys_spare_buffer, 8
g_flash_sys_spare_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR156,. + 0
	.type	g_flash_tmp_page_buffer, %object
	.size	g_flash_tmp_page_buffer, 8
g_flash_tmp_page_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR158,. + 0
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
	.set	.LANCHOR179,. + 0
	.type	g_ftl_info_blk, %object
	.size	g_ftl_info_blk, 4
g_ftl_info_blk:
	.zero	4
	.section	.bss.g_gc_info,"aw",@nobits
	.align	3
	.set	.LANCHOR63,. + 0
	.type	g_gc_info, %object
	.size	g_gc_info, 344
g_gc_info:
	.zero	344
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
	.set	.LANCHOR159,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.zero	1
	.section	.bss.g_msb_page_tbl,"aw",@nobits
	.align	2
	.set	.LANCHOR138,. + 0
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
	.set	.LANCHOR44,. + 0
	.type	g_nandc_ecc_bits, %object
	.size	g_nandc_ecc_bits, 1
g_nandc_ecc_bits:
	.zero	1
	.section	.bss.g_nandc_tran_timeout,"aw",@nobits
	.set	.LANCHOR157,. + 0
	.type	g_nandc_tran_timeout, %object
	.size	g_nandc_tran_timeout, 1
g_nandc_tran_timeout:
	.zero	1
	.section	.bss.g_nandc_v6_master_info,"aw",@nobits
	.align	3
	.set	.LANCHOR47,. + 0
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
	.set	.LANCHOR73,. + 0
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
	.set	.LANCHOR140,. + 0
	.type	g_slc_page_num, %object
	.size	g_slc_page_num, 2
g_slc_page_num:
	.zero	2
	.section	.bss.g_totle_phy_block,"aw",@nobits
	.align	1
	.set	.LANCHOR142,. + 0
	.type	g_totle_phy_block, %object
	.size	g_totle_phy_block, 2
g_totle_phy_block:
	.zero	2
	.section	.bss.gc_des_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR154,. + 0
	.type	gc_des_ppa_tbl, %object
	.size	gc_des_ppa_tbl, 8
gc_des_ppa_tbl:
	.zero	8
	.section	.bss.gc_free_slc_sblk_th,"aw",@nobits
	.align	1
	.set	.LANCHOR79,. + 0
	.type	gc_free_slc_sblk_th, %object
	.size	gc_free_slc_sblk_th, 2
gc_free_slc_sblk_th:
	.zero	2
	.section	.bss.gc_lpa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR152,. + 0
	.type	gc_lpa_tbl, %object
	.size	gc_lpa_tbl, 8
gc_lpa_tbl:
	.zero	8
	.section	.bss.gc_mode,"aw",@nobits
	.set	.LANCHOR76,. + 0
	.type	gc_mode, %object
	.size	gc_mode, 1
gc_mode:
	.zero	1
	.section	.bss.gc_page_buf_id,"aw",@nobits
	.align	3
	.set	.LANCHOR74,. + 0
	.type	gc_page_buf_id, %object
	.size	gc_page_buf_id, 8
gc_page_buf_id:
	.zero	8
	.section	.bss.gc_pre_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR153,. + 0
	.type	gc_pre_ppa_tbl, %object
	.size	gc_pre_ppa_tbl, 8
gc_pre_ppa_tbl:
	.zero	8
	.section	.bss.gc_search_count,"aw",@nobits
	.align	2
	.set	.LANCHOR151,. + 0
	.type	gc_search_count, %object
	.size	gc_search_count, 4
gc_search_count:
	.zero	4
	.section	.bss.gc_slc_cache_index,"aw",@nobits
	.align	1
	.set	.LANCHOR82,. + 0
	.type	gc_slc_cache_index, %object
	.size	gc_slc_cache_index, 2
gc_slc_cache_index:
	.zero	2
	.section	.bss.gc_slc_data_index,"aw",@nobits
	.align	1
	.set	.LANCHOR86,. + 0
	.type	gc_slc_data_index, %object
	.size	gc_slc_data_index, 2
gc_slc_data_index:
	.zero	2
	.section	.bss.gc_slc_mode_tlc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR84,. + 0
	.type	gc_slc_mode_tlc_vpn_th, %object
	.size	gc_slc_mode_tlc_vpn_th, 2
gc_slc_mode_tlc_vpn_th:
	.zero	2
	.section	.bss.gc_slc_mode_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR62,. + 0
	.type	gc_slc_mode_vpn_th, %object
	.size	gc_slc_mode_vpn_th, 2
gc_slc_mode_vpn_th:
	.zero	2
	.section	.bss.gc_state,"aw",@nobits
	.set	.LANCHOR150,. + 0
	.type	gc_state, %object
	.size	gc_state, 1
gc_state:
	.zero	1
	.section	.bss.gc_tlc_mode_slc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR94,. + 0
	.type	gc_tlc_mode_slc_vpn_th, %object
	.size	gc_tlc_mode_slc_vpn_th, 2
gc_tlc_mode_slc_vpn_th:
	.zero	2
	.section	.bss.gc_tlc_mode_tlc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR91,. + 0
	.type	gc_tlc_mode_tlc_vpn_th, %object
	.size	gc_tlc_mode_tlc_vpn_th, 2
gc_tlc_mode_tlc_vpn_th:
	.zero	2
	.section	.bss.gc_valid_page_ppa,"aw",@nobits
	.align	3
	.set	.LANCHOR68,. + 0
	.type	gc_valid_page_ppa, %object
	.size	gc_valid_page_ppa, 8
gc_valid_page_ppa:
	.zero	8
	.section	.bss.gc_xlc_data_index,"aw",@nobits
	.align	1
	.set	.LANCHOR83,. + 0
	.type	gc_xlc_data_index, %object
	.size	gc_xlc_data_index, 2
gc_xlc_data_index:
	.zero	2
	.section	.bss.gc_xlc_search_index,"aw",@nobits
	.align	1
	.set	.LANCHOR87,. + 0
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
	.set	.LANCHOR81,. + 0
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
	.set	.LANCHOR80,. + 0
	.type	gp_data_xlc_data_head, %object
	.size	gp_data_xlc_data_head, 8
gp_data_xlc_data_head:
	.zero	8
	.section	.bss.gp_flash_check_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR137,. + 0
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
	.set	.LANCHOR100,. + 0
	.type	gp_free_mix_head, %object
	.size	gp_free_mix_head, 8
gp_free_mix_head:
	.zero	8
	.section	.bss.gp_free_slc_head,"aw",@nobits
	.align	3
	.set	.LANCHOR96,. + 0
	.type	gp_free_slc_head, %object
	.size	gp_free_slc_head, 8
gp_free_slc_head:
	.zero	8
	.section	.bss.gp_free_xlc_head,"aw",@nobits
	.align	3
	.set	.LANCHOR98,. + 0
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
	.set	.LANCHOR102,. + 0
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
	.set	.LANCHOR135,. + 0
	.type	idb_buf, %object
	.size	idb_buf, 8
idb_buf:
	.zero	8
	.section	.bss.idb_need_write_back,"aw",@nobits
	.align	2
	.set	.LANCHOR136,. + 0
	.type	idb_need_write_back, %object
	.size	idb_need_write_back, 4
idb_need_write_back:
	.zero	4
	.section	.bss.lpa_hash,"aw",@nobits
	.align	3
	.set	.LANCHOR108,. + 0
	.type	lpa_hash, %object
	.size	lpa_hash, 512
lpa_hash:
	.zero	512
	.section	.bss.lpa_hash_index,"aw",@nobits
	.align	3
	.set	.LANCHOR110,. + 0
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
	.set	.LANCHOR45,. + 0
	.type	nandc_hw_seed, %object
	.size	nandc_hw_seed, 1
nandc_hw_seed:
	.zero	1
	.section	.bss.nandc_randomizer_en,"aw",@nobits
	.set	.LANCHOR46,. + 0
	.type	nandc_randomizer_en, %object
	.size	nandc_randomizer_en, 1
nandc_randomizer_en:
	.zero	1
	.section	.bss.p_free_buf_head,"aw",@nobits
	.set	.LANCHOR51,. + 0
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
	.section	.bss.pm_gc_enable,"aw",@nobits
	.align	2
	.set	.LANCHOR130,. + 0
	.type	pm_gc_enable, %object
	.size	pm_gc_enable, 4
pm_gc_enable:
	.zero	4
	.section	.bss.pm_last_load_ram_id,"aw",@nobits
	.set	.LANCHOR205,. + 0
	.type	pm_last_load_ram_id, %object
	.size	pm_last_load_ram_id, 1
pm_last_load_ram_id:
	.zero	1
	.section	.bss.pm_last_update_ram_id,"aw",@nobits
	.set	.LANCHOR133,. + 0
	.type	pm_last_update_ram_id, %object
	.size	pm_last_update_ram_id, 1
pm_last_update_ram_id:
	.zero	1
	.section	.bss.pm_ram_info,"aw",@nobits
	.align	3
	.set	.LANCHOR132,. + 0
	.type	pm_ram_info, %object
	.size	pm_ram_info, 512
pm_ram_info:
	.zero	512
	.section	.bss.read_ahead_lpa,"aw",@nobits
	.align	2
	.set	.LANCHOR206,. + 0
	.type	read_ahead_lpa, %object
	.size	read_ahead_lpa, 4
read_ahead_lpa:
	.zero	4
	.section	.bss.read_buf_count,"aw",@nobits
	.set	.LANCHOR127,. + 0
	.type	read_buf_count, %object
	.size	read_buf_count, 1
read_buf_count:
	.zero	1
	.section	.bss.read_buf_head,"aw",@nobits
	.set	.LANCHOR126,. + 0
	.type	read_buf_head, %object
	.size	read_buf_head, 1
read_buf_head:
	.zero	1
	.section	.bss.sblk_gc_write_completed_queue_head,"aw",@nobits
	.set	.LANCHOR69,. + 0
	.type	sblk_gc_write_completed_queue_head, %object
	.size	sblk_gc_write_completed_queue_head, 1
sblk_gc_write_completed_queue_head:
	.zero	1
	.section	.bss.sblk_queue_head,"aw",@nobits
	.set	.LANCHOR54,. + 0
	.type	sblk_queue_head, %object
	.size	sblk_queue_head, 1
sblk_queue_head:
	.zero	1
	.section	.bss.sblk_read_completed_queue_head,"aw",@nobits
	.set	.LANCHOR129,. + 0
	.type	sblk_read_completed_queue_head, %object
	.size	sblk_read_completed_queue_head, 1
sblk_read_completed_queue_head:
	.zero	1
	.section	.bss.sblk_write_completed_queue_head,"aw",@nobits
	.set	.LANCHOR124,. + 0
	.type	sblk_write_completed_queue_head, %object
	.size	sblk_write_completed_queue_head, 1
sblk_write_completed_queue_head:
	.zero	1
	.section	.bss.slc_cache_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR88,. + 0
	.type	slc_cache_sblk, %object
	.size	slc_cache_sblk, 2
slc_cache_sblk:
	.zero	2
	.section	.bss.slc_data_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR90,. + 0
	.type	slc_data_sblk, %object
	.size	slc_data_sblk, 2
slc_data_sblk:
	.zero	2
	.section	.bss.write_buf_count,"aw",@nobits
	.set	.LANCHOR58,. + 0
	.type	write_buf_count, %object
	.size	write_buf_count, 1
write_buf_count:
	.zero	1
	.section	.bss.write_buf_head,"aw",@nobits
	.set	.LANCHOR57,. + 0
	.type	write_buf_head, %object
	.size	write_buf_head, 1
write_buf_head:
	.zero	1
	.section	.bss.write_commit_count,"aw",@nobits
	.set	.LANCHOR121,. + 0
	.type	write_commit_count, %object
	.size	write_commit_count, 1
write_commit_count:
	.zero	1
	.section	.bss.write_commit_head,"aw",@nobits
	.set	.LANCHOR174,. + 0
	.type	write_commit_head, %object
	.size	write_commit_head, 1
write_commit_head:
	.zero	1
	.section	.bss.xlc_data_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR92,. + 0
	.type	xlc_data_sblk, %object
	.size	xlc_data_sblk, 2
xlc_data_sblk:
	.zero	2
	.section	.bss.zftl_print_list_count,"aw",@nobits
	.align	1
	.set	.LANCHOR101,. + 0
	.type	zftl_print_list_count, %object
	.size	zftl_print_list_count, 2
zftl_print_list_count:
	.zero	2
	.section	.data.g_nand_para_info,"aw",@progbits
	.align	3
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
	.section	.data.nand_opt_para,"aw",@progbits
	.align	3
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
	.section	.data.sd15_tlc_rr,"aw",@progbits
	.align	3
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
	.section	.data.tlc_prog_order,"aw",@progbits
	.align	3
	.set	.LANCHOR219,. + 0
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
	.byte	4
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
	.byte	4
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
	.section	.rodata.__func__.10034,"a",@progbits
	.align	3
	.set	.LANCHOR211,. + 0
	.type	__func__.10034, %object
	.size	__func__.10034, 20
__func__.10034:
	.string	"gc_scan_static_data"
	.section	.rodata.__func__.10101,"a",@progbits
	.align	3
	.set	.LANCHOR220,. + 0
	.type	__func__.10101, %object
	.size	__func__.10101, 11
__func__.10101:
	.string	"zftl_do_gc"
	.section	.rodata.__func__.10194,"a",@progbits
	.align	3
	.set	.LANCHOR5,. + 0
	.type	__func__.10194, %object
	.size	__func__.10194, 18
__func__.10194:
	.string	"_list_remove_node"
	.section	.rodata.__func__.10219,"a",@progbits
	.align	3
	.set	.LANCHOR11,. + 0
	.type	__func__.10219, %object
	.size	__func__.10219, 23
__func__.10219:
	.string	"_list_update_data_list"
	.section	.rodata.__func__.10327,"a",@progbits
	.align	3
	.set	.LANCHOR180,. + 0
	.type	__func__.10327, %object
	.size	__func__.10327, 15
__func__.10327:
	.string	"ftl_info_flush"
	.section	.rodata.__func__.10359,"a",@progbits
	.align	3
	.set	.LANCHOR128,. + 0
	.type	__func__.10359, %object
	.size	__func__.10359, 15
__func__.10359:
	.string	"ftl_alloc_sblk"
	.section	.rodata.__func__.10401,"a",@progbits
	.align	3
	.set	.LANCHOR105,. + 0
	.type	__func__.10401, %object
	.size	__func__.10401, 18
__func__.10401:
	.string	"ftl_alloc_sys_blk"
	.section	.rodata.__func__.10411,"a",@progbits
	.align	3
	.set	.LANCHOR106,. + 0
	.type	__func__.10411, %object
	.size	__func__.10411, 17
__func__.10411:
	.string	"ftl_free_sys_blk"
	.section	.rodata.__func__.10446,"a",@progbits
	.align	3
	.set	.LANCHOR212,. + 0
	.type	__func__.10446, %object
	.size	__func__.10446, 14
__func__.10446:
	.string	"ftl_sblk_dump"
	.section	.rodata.__func__.10470,"a",@progbits
	.align	3
	.set	.LANCHOR201,. + 0
	.type	__func__.10470, %object
	.size	__func__.10470, 16
__func__.10470:
	.string	"ftl_sysblk_dump"
	.section	.rodata.__func__.10492,"a",@progbits
	.align	3
	.set	.LANCHOR189,. + 0
	.type	__func__.10492, %object
	.size	__func__.10492, 23
__func__.10492:
	.string	"ftl_open_sblk_recovery"
	.section	.rodata.__func__.10522,"a",@progbits
	.align	3
	.set	.LANCHOR107,. + 0
	.type	__func__.10522, %object
	.size	__func__.10522, 23
__func__.10522:
	.string	"ftl_get_ppa_from_index"
	.section	.rodata.__func__.10543,"a",@progbits
	.align	3
	.set	.LANCHOR215,. + 0
	.type	__func__.10543, %object
	.size	__func__.10543, 19
__func__.10543:
	.string	"ftl_update_l2p_map"
	.section	.rodata.__func__.10562,"a",@progbits
	.align	3
	.set	.LANCHOR111,. + 0
	.type	__func__.10562, %object
	.size	__func__.10562, 22
__func__.10562:
	.string	"ftl_get_new_free_page"
	.section	.rodata.__func__.10573,"a",@progbits
	.align	3
	.set	.LANCHOR112,. + 0
	.type	__func__.10573, %object
	.size	__func__.10573, 22
__func__.10573:
	.string	"ftl_ext_alloc_new_blk"
	.section	.rodata.__func__.10598,"a",@progbits
	.align	3
	.set	.LANCHOR184,. + 0
	.type	__func__.10598, %object
	.size	__func__.10598, 19
__func__.10598:
	.string	"ftl_ext_info_flush"
	.section	.rodata.__func__.10610,"a",@progbits
	.align	3
	.set	.LANCHOR185,. + 0
	.type	__func__.10610, %object
	.size	__func__.10610, 18
__func__.10610:
	.string	"ftl_ext_info_init"
	.section	.rodata.__func__.10649,"a",@progbits
	.align	3
	.set	.LANCHOR186,. + 0
	.type	__func__.10649, %object
	.size	__func__.10649, 25
__func__.10649:
	.string	"ftl_low_format_data_init"
	.section	.rodata.__func__.10664,"a",@progbits
	.align	3
	.set	.LANCHOR188,. + 0
	.type	__func__.10664, %object
	.size	__func__.10664, 15
__func__.10664:
	.string	"ftl_low_format"
	.section	.rodata.__func__.10712,"a",@progbits
	.align	3
	.set	.LANCHOR177,. + 0
	.type	__func__.10712, %object
	.size	__func__.10712, 14
__func__.10712:
	.string	"ftl_prog_page"
	.section	.rodata.__func__.10834,"a",@progbits
	.align	3
	.set	.LANCHOR167,. + 0
	.type	__func__.10834, %object
	.size	__func__.10834, 31
__func__.10834:
	.string	"queue_wait_first_req_completed"
	.section	.rodata.__func__.10888,"a",@progbits
	.align	3
	.set	.LANCHOR173,. + 0
	.type	__func__.10888, %object
	.size	__func__.10888, 15
__func__.10888:
	.string	"sblk_prog_page"
	.section	.rodata.__func__.10915,"a",@progbits
	.align	3
	.set	.LANCHOR169,. + 0
	.type	__func__.10915, %object
	.size	__func__.10915, 15
__func__.10915:
	.string	"sblk_read_page"
	.section	.rodata.__func__.10975,"a",@progbits
	.align	3
	.set	.LANCHOR202,. + 0
	.type	__func__.10975, %object
	.size	__func__.10975, 16
__func__.10975:
	.string	"load_l2p_region"
	.section	.rodata.__func__.10989,"a",@progbits
	.align	3
	.set	.LANCHOR147,. + 0
	.type	__func__.10989, %object
	.size	__func__.10989, 13
__func__.10989:
	.string	"pm_free_sblk"
	.section	.rodata.__func__.11009,"a",@progbits
	.align	3
	.set	.LANCHOR204,. + 0
	.type	__func__.11009, %object
	.size	__func__.11009, 6
__func__.11009:
	.string	"pm_gc"
	.section	.rodata.__func__.11025,"a",@progbits
	.align	3
	.set	.LANCHOR131,. + 0
	.type	__func__.11025, %object
	.size	__func__.11025, 17
__func__.11025:
	.string	"pm_alloc_new_blk"
	.section	.rodata.__func__.11035,"a",@progbits
	.align	3
	.set	.LANCHOR190,. + 0
	.type	__func__.11035, %object
	.size	__func__.11035, 14
__func__.11035:
	.string	"pm_write_page"
	.section	.rodata.__func__.11053,"a",@progbits
	.align	3
	.set	.LANCHOR134,. + 0
	.type	__func__.11053, %object
	.size	__func__.11053, 21
__func__.11053:
	.string	"pm_select_ram_region"
	.section	.rodata.__func__.8553,"a",@progbits
	.align	3
	.set	.LANCHOR161,. + 0
	.type	__func__.8553, %object
	.size	__func__.8553, 19
__func__.8553:
	.string	"flash_read_page_en"
	.section	.rodata.__func__.8595,"a",@progbits
	.align	3
	.set	.LANCHOR175,. + 0
	.type	__func__.8595, %object
	.size	__func__.8595, 19
__func__.8595:
	.string	"flash_prog_page_en"
	.section	.rodata.__func__.8611,"a",@progbits
	.align	3
	.set	.LANCHOR38,. + 0
	.type	__func__.8611, %object
	.size	__func__.8611, 26
__func__.8611:
	.string	"flash_erase_duplane_block"
	.section	.rodata.__func__.8622,"a",@progbits
	.align	3
	.set	.LANCHOR40,. + 0
	.type	__func__.8622, %object
	.size	__func__.8622, 21
__func__.8622:
	.string	"flash_erase_block_en"
	.section	.rodata.__func__.8636,"a",@progbits
	.align	3
	.set	.LANCHOR29,. + 0
	.type	__func__.8636, %object
	.size	__func__.8636, 28
__func__.8636:
	.string	"flash_wait_device_ready_raw"
	.section	.rodata.__func__.8660,"a",@progbits
	.align	3
	.set	.LANCHOR170,. + 0
	.type	__func__.8660, %object
	.size	__func__.8660, 26
__func__.8660:
	.string	"flash_start_tlc_page_prog"
	.section	.rodata.__func__.8671,"a",@progbits
	.align	3
	.set	.LANCHOR171,. + 0
	.type	__func__.8671, %object
	.size	__func__.8671, 29
__func__.8671:
	.string	"flash_start_3d_mlc_page_prog"
	.section	.rodata.__func__.8689,"a",@progbits
	.align	3
	.set	.LANCHOR172,. + 0
	.type	__func__.8689, %object
	.size	__func__.8689, 22
__func__.8689:
	.string	"flash_start_page_prog"
	.section	.rodata.__func__.8700,"a",@progbits
	.align	3
	.set	.LANCHOR33,. + 0
	.type	__func__.8700, %object
	.size	__func__.8700, 22
__func__.8700:
	.string	"flash_start_page_read"
	.section	.rodata.__func__.8713,"a",@progbits
	.align	3
	.set	.LANCHOR165,. + 0
	.type	__func__.8713, %object
	.size	__func__.8713, 31
__func__.8713:
	.string	"flash_complete_plane_page_read"
	.section	.rodata.__func__.8725,"a",@progbits
	.align	3
	.set	.LANCHOR41,. + 0
	.type	__func__.8725, %object
	.size	__func__.8725, 23
__func__.8725:
	.string	"flash_start_plane_read"
	.section	.rodata.__func__.8738,"a",@progbits
	.align	3
	.set	.LANCHOR166,. + 0
	.type	__func__.8738, %object
	.size	__func__.8738, 25
__func__.8738:
	.string	"flash_complete_page_read"
	.section	.rodata.__func__.9070,"a",@progbits
	.align	3
	.set	.LANCHOR139,. + 0
	.type	__func__.9070, %object
	.size	__func__.9070, 20
__func__.9070:
	.string	"flash_die_info_init"
	.section	.rodata.__func__.9080,"a",@progbits
	.align	3
	.set	.LANCHOR15,. + 0
	.type	__func__.9080, %object
	.size	__func__.9080, 22
__func__.9080:
	.string	"nand_flash_print_info"
	.section	.rodata.__func__.9125,"a",@progbits
	.align	3
	.set	.LANCHOR197,. + 0
	.type	__func__.9125, %object
	.size	__func__.9125, 16
__func__.9125:
	.string	"nand_flash_init"
	.section	.rodata.__func__.9148,"a",@progbits
	.align	3
	.set	.LANCHOR149,. + 0
	.type	__func__.9148, %object
	.size	__func__.9148, 11
__func__.9148:
	.string	"nandc_init"
	.section	.rodata.__func__.9317,"a",@progbits
	.align	3
	.set	.LANCHOR53,. + 0
	.type	__func__.9317, %object
	.size	__func__.9317, 13
__func__.9317:
	.string	"buf_add_tail"
	.section	.rodata.__func__.9330,"a",@progbits
	.align	3
	.set	.LANCHOR55,. + 0
	.type	__func__.9330, %object
	.size	__func__.9330, 10
__func__.9330:
	.string	"buf_alloc"
	.section	.rodata.__func__.9344,"a",@progbits
	.align	3
	.set	.LANCHOR56,. + 0
	.type	__func__.9344, %object
	.size	__func__.9344, 16
__func__.9344:
	.string	"buf_remove_free"
	.section	.rodata.__func__.9357,"a",@progbits
	.align	3
	.set	.LANCHOR196,. + 0
	.type	__func__.9357, %object
	.size	__func__.9357, 20
__func__.9357:
	.string	"flash_info_blk_init"
	.section	.rodata.__func__.9368,"a",@progbits
	.align	3
	.set	.LANCHOR148,. + 0
	.type	__func__.9368, %object
	.size	__func__.9368, 21
__func__.9368:
	.string	"flash_info_data_init"
	.section	.rodata.__func__.9390,"a",@progbits
	.align	3
	.set	.LANCHOR193,. + 0
	.type	__func__.9390, %object
	.size	__func__.9390, 17
__func__.9390:
	.string	"flash_info_flush"
	.section	.rodata.__func__.9466,"a",@progbits
	.align	3
	.set	.LANCHOR143,. + 0
	.type	__func__.9466, %object
	.size	__func__.9466, 17
__func__.9466:
	.string	"lpa_rebuild_hash"
	.section	.rodata.__func__.9513,"a",@progbits
	.align	3
	.set	.LANCHOR216,. + 0
	.type	__func__.9513, %object
	.size	__func__.9513, 17
__func__.9513:
	.string	"ftl_write_commit"
	.section	.rodata.__func__.9531,"a",@progbits
	.align	3
	.set	.LANCHOR122,. + 0
	.type	__func__.9531, %object
	.size	__func__.9531, 14
__func__.9531:
	.string	"ftl_write_buf"
	.section	.rodata.__func__.9576,"a",@progbits
	.align	3
	.set	.LANCHOR125,. + 0
	.type	__func__.9576, %object
	.size	__func__.9576, 18
__func__.9576:
	.string	"zftl_add_read_buf"
	.section	.rodata.__func__.9609,"a",@progbits
	.align	3
	.set	.LANCHOR213,. + 0
	.type	__func__.9609, %object
	.size	__func__.9609, 10
__func__.9609:
	.string	"zftl_read"
	.section	.rodata.__func__.9640,"a",@progbits
	.align	3
	.set	.LANCHOR222,. + 0
	.type	__func__.9640, %object
	.size	__func__.9640, 13
__func__.9640:
	.string	"_ftl_discard"
	.section	.rodata.__func__.9787,"a",@progbits
	.align	3
	.set	.LANCHOR61,. + 0
	.type	__func__.9787, %object
	.size	__func__.9787, 12
__func__.9787:
	.string	"gc_add_sblk"
	.section	.rodata.__func__.9834,"a",@progbits
	.align	3
	.set	.LANCHOR214,. + 0
	.type	__func__.9834, %object
	.size	__func__.9834, 21
__func__.9834:
	.string	"gc_check_data_one_wl"
	.section	.rodata.__func__.9868,"a",@progbits
	.align	3
	.set	.LANCHOR209,. + 0
	.type	__func__.9868, %object
	.size	__func__.9868, 22
__func__.9868:
	.string	"gc_update_l2p_map_new"
	.section	.rodata.__func__.9881,"a",@progbits
	.align	3
	.set	.LANCHOR70,. + 0
	.type	__func__.9881, %object
	.size	__func__.9881, 19
__func__.9881:
	.string	"gc_write_completed"
	.section	.rodata.__func__.9910,"a",@progbits
	.align	3
	.set	.LANCHOR218,. + 0
	.type	__func__.9910, %object
	.size	__func__.9910, 16
__func__.9910:
	.string	"gc_do_copy_back"
	.section	.rodata.__func__.9932,"a",@progbits
	.align	3
	.set	.LANCHOR119,. + 0
	.type	__func__.9932, %object
	.size	__func__.9932, 16
__func__.9932:
	.string	"gc_free_src_blk"
	.section	.rodata.__func__.9976,"a",@progbits
	.align	3
	.set	.LANCHOR210,. + 0
	.type	__func__.9976, %object
	.size	__func__.9976, 16
__func__.9976:
	.string	"gc_scan_src_blk"
	.section	.rodata._list_remove_node.str1.1,"aMS",@progbits,1
.LC0:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
	.section	.rodata.dump_ftl_info.str1.1,"aMS",@progbits,1
.LC172:
	.string	"free_buf_count: %d\n"
.LC173:
	.string	"g_ftl_info_blk blk:0x%x, index:0x%x, page:0x%x\n"
.LC174:
	.string	"ftl_ext_info_blk blk:0x%x, page:0x%x\n"
.LC175:
	.string	"ac_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC176:
	.string	"tmp_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC177:
	.string	"gc_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC178:
	.string	"lpa:"
.LC179:
	.string	"vpn:"
.LC180:
	.string	"sblk:"
.LC181:
	.string	"lpa_hash:"
.LC182:
	.string	"lpa_hash_index:"
	.section	.rodata.dump_sblk_queue.str1.1,"aMS",@progbits,1
.LC74:
	.string	"dump_sblk_queue: %d\n"
.LC75:
	.string	"buf id= %d state = %d ppa = %x\n"
	.section	.rodata.flash_complete_page_read.str1.1,"aMS",@progbits,1
.LC122:
	.string	"flash_complete_page_read %x %x error_ecc %d %d\n"
	.section	.rodata.flash_ddr_tuning_read.str1.1,"aMS",@progbits,1
.LC115:
	.string	"%d flash_ddr_tuning_read %x ecc=%d\n"
.LC116:
	.string	"sync para %d\n"
.LC117:
	.string	"DDR mode Read error %x %x\n"
.LC118:
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
.LC121:
	.string	"flash_get_last_written_page: %x %x %x\n"
	.section	.rodata.flash_info_blk_init.str1.1,"aMS",@progbits,1
.LC169:
	.string	"...%d @ %s %d %p\n"
.LC170:
	.string	"no sys info %x\n"
	.section	.rodata.flash_info_data_init.str1.1,"aMS",@progbits,1
.LC90:
	.string	"...%d @ %s\n"
	.section	.rodata.flash_info_flush.str1.1,"aMS",@progbits,1
.LC166:
	.string	"finfo:"
.LC167:
	.string	"flash_info_flush id = %x, page = %x\n"
.LC168:
	.string	"sys_info_flush error:%x\n"
	.section	.rodata.flash_mask_bad_block.str1.1,"aMS",@progbits,1
.LC42:
	.string	"flash_mask_bad_block %d %d\n"
	.section	.rodata.flash_prog_page.str1.1,"aMS",@progbits,1
.LC128:
	.string	"flash_prog_page %x %x %x\n"
.LC129:
	.string	"flash_prog_page page_addr = %x status = %x\n"
	.section	.rodata.flash_prog_page_en.str1.1,"aMS",@progbits,1
.LC136:
	.string	"flash_prog_page_en:%x %x %x\n"
.LC137:
	.string	"w d:"
.LC138:
	.string	"w s:"
.LC139:
	.string	"spare"
.LC140:
	.string	"data"
.LC141:
	.string	"write error: %x\n"
	.section	.rodata.flash_read_id.str1.1,"aMS",@progbits,1
.LC39:
	.string	"No.%d FLASH ID:%x %x %x %x %x %x\n"
	.section	.rodata.flash_read_otp_data.str1.1,"aMS",@progbits,1
.LC40:
	.string	"otp:%x %x %x %x\n"
	.section	.rodata.flash_read_page.str1.1,"aMS",@progbits,1
.LC108:
	.string	"flash_read_page %x %x %x\n"
	.section	.rodata.flash_read_page_en.str1.1,"aMS",@progbits,1
.LC119:
	.string	"flash_read_page_en %x %x %x\n"
.LC120:
	.string	"flash_read_page_en %x %x error_ecc %d %d\n"
	.section	.rodata.flash_set_interface_mode.str1.1,"aMS",@progbits,1
.LC37:
	.string	"nand sdr mode %x\n"
.LC38:
	.string	"nand ddr mode %x\n"
	.section	.rodata.ftl_alloc_new_data_sblk.str1.1,"aMS",@progbits,1
.LC230:
	.string	"error gc_add_sblk: %x\n"
	.section	.rodata.ftl_alloc_sblk.str1.1,"aMS",@progbits,1
.LC73:
	.string	"alloc sblk %x %d\n"
	.section	.rodata.ftl_dump_write_open_sblk.str1.1,"aMS",@progbits,1
.LC161:
	.string	"ftl_sblk_dump_write = %x %d %d %d %d\n"
.LC162:
	.string	"blk= %x, page=%x, ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC163:
	.string	"ftl_sblk_dump_write2 = %x %d %d %d\n"
.LC164:
	.string	"ftl_sblk_dump_write = %x %x\n"
.LC165:
	.string	"ftl_sblk_dump_write done = %x\n"
	.section	.rodata.ftl_ext_info_init.str1.1,"aMS",@progbits,1
.LC147:
	.string	"%s %d %d %x %x\n"
	.section	.rodata.ftl_free_sblk.str1.1,"aMS",@progbits,1
.LC61:
	.string	"swl_tlc_free_mini_ec_blk sblk %x\n"
.LC62:
	.string	"swl_slc_free_mini_ec_blk sblk %x\n"
	.section	.rodata.ftl_info_blk_init.str1.1,"aMS",@progbits,1
.LC144:
	.string	"%d %x @%d %x\n"
.LC145:
	.string	"ftl_info_blk_init %d %d %x\n"
.LC146:
	.string	"ink flag: %x\n"
	.section	.rodata.ftl_info_flush.str1.1,"aMS",@progbits,1
.LC143:
	.string	"g_ftl_info_blk blk = %x, page = %x version = %d\n"
	.section	.rodata.ftl_low_format.str1.1,"aMS",@progbits,1
.LC148:
	.string	"ftl_low_format %d\n"
.LC149:
	.string	"low format %d %d %d %d\n"
	.section	.rodata.ftl_mask_bad_block.str1.1,"aMS",@progbits,1
.LC59:
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
	.string	"sblk = %x, vpn0 = %d, vpn1 = %d\n"
.LC156:
	.string	"dump_write_lpa = %x %x %x %x\n"
.LC157:
	.string	"dump write new ppa = %x, last ppa = %x lpa = %x\n"
.LC158:
	.string	"dump write = %x %x\n"
.LC159:
	.string	"dump write hash update = %x %x %x\n"
	.section	.rodata.ftl_re_low_format.str1.1,"aMS",@progbits,1
.LC150:
	.string	"re low format %d\n"
	.section	.rodata.ftl_sblk_dump.str1.1,"aMS",@progbits,1
.LC215:
	.string	"ftl_sblk_dump = %x %d %d %d %d\n"
.LC216:
	.string	"ftl_sblk_dump = %x %x %x %x\n"
.LC217:
	.string	"page_addr = %x, lpa=%x vpn = %d\n"
.LC218:
	.string	"index= %x, lpa=%x\n"
.LC219:
	.string	"block = %x, vpn=%x check vpn = %d\n"
	.section	.rodata.ftl_sysblk_dump.str1.1,"aMS",@progbits,1
.LC171:
	.string	"l2p:"
	.section	.rodata.ftl_test_block.str1.1,"aMS",@progbits,1
.LC142:
	.string	"low format %d\n"
	.section	.rodata.ftl_update_l2p_map.str1.1,"aMS",@progbits,1
.LC226:
	.string	"ftl_update_l2p_map: %x %x %x\n"
.LC227:
	.string	"ftl_update_l2p_map"
.LC228:
	.string	"lpa_tbl:"
.LC229:
	.string	"sblk %x vpn: %d %d\n"
	.section	.rodata.ftl_vpn_decrement.str1.1,"aMS",@progbits,1
.LC58:
	.string	"ftl_vpn_decrement %x = %d, %d\n"
	.section	.rodata.ftl_write_commit.str1.1,"aMS",@progbits,1
.LC231:
	.string	"%d read error: ppa:%x, lpa:%x, status:%x\n"
	.section	.rodata.ftl_write_completed.str1.1,"aMS",@progbits,1
.LC71:
	.string	"ftl prog error =%x, lpa = %x, ppa= %x\n"
.LC72:
	.string	"ftl re prog: lpa = %x, ppa= %x\n"
	.section	.rodata.gc_add_sblk.str1.1,"aMS",@progbits,1
.LC43:
	.string	"gc_add_sblk = %d, %d, %d, %d, %d, %d\n"
.LC44:
	.string	"gc_add_sblk = %d, %d, %d,last update:%d, %d\n"
	.section	.rodata.gc_check_data_one_wl.str1.1,"aMS",@progbits,1
.LC223:
	.string	"gc_lpa:"
.LC224:
	.string	"gc_ppa:"
.LC225:
	.string	"err: ppa = %x, status = %x, %x %x spare: %x %x %x %x\n"
	.section	.rodata.gc_do_copy_back.str1.1,"aMS",@progbits,1
.LC232:
	.string	"gc page in buf: lpa %x ppa = %x pageindex= %x\n"
.LC233:
	.string	"gc_do_copy_back: lpa %x des_ppa = %x %x gc_ppa= %x page_index= %d\n"
.LC234:
	.string	"gc_do_copy_back: %x %x %x %x gc_ppa:%x %x\n"
.LC235:
	.string	"%d prog_step: %x %x buf id= %x ppa = %x hash=%x id = %x plane = %x lpa=%x\n"
	.section	.rodata.gc_free_bad_sblk.str1.1,"aMS",@progbits,1
.LC60:
	.string	"gc_free_bad_sblk 0x%x\n"
	.section	.rodata.gc_free_src_blk.str1.1,"aMS",@progbits,1
.LC63:
	.string	"gc_free_src_blk = %x, vpn = %d\n"
.LC64:
	.string	"gc_free_src_blk %x, %d\n"
	.section	.rodata.gc_free_temp_buf.str1.1,"aMS",@progbits,1
.LC48:
	.string	"%d gc_free_temp_buf buf id= %x\n"
	.section	.rodata.gc_mark_bad_ppa.str1.1,"aMS",@progbits,1
.LC45:
	.string	"gc_mark_bad_ppa %d %x %x\n"
	.section	.rodata.gc_recovery.str1.1,"aMS",@progbits,1
.LC193:
	.string	"ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC194:
	.string	"ppa = %x, status = %x, %x %x spare: %x %x %x %x\n"
.LC195:
	.string	"gc_recovery: %x vpn = %x\n"
	.section	.rodata.gc_scan_src_blk.str1.1,"aMS",@progbits,1
.LC213:
	.string	"gc_scan_src_blk = %x, vpn = %d\n"
.LC214:
	.string	"gc_scan_src_blk = %x, s vpn0 = %d, c vpn1 = %d\n"
	.section	.rodata.gc_search_src_blk.str1.1,"aMS",@progbits,1
.LC50:
	.string	"zftl_get_gc_node cache = %x index = %d vpn = %x\n"
.LC51:
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
.LC209:
	.string	"gc_update_l2p_map_new sblk %x\n"
.LC210:
	.string	"gc_update_l2p_map_new: %x %x %x\n"
.LC211:
	.string	"lpa: %x %x %x\n"
.LC212:
	.string	"gc_update_l2p_map_new: %x vpn = %x vpn1 = %x done\n"
	.section	.rodata.gc_write_completed.str1.1,"aMS",@progbits,1
.LC46:
	.string	"status: %x, ppa: %x\n"
.LC47:
	.string	"gc_write_completed: %x  %x  %x %x\n"
	.section	.rodata.hynix_get_read_retry_default.str1.1,"aMS",@progbits,1
.LC98:
	.string	"otp error! %d"
.LC99:
	.string	"rr"
	.section	.rodata.hynix_read_retrial.str1.1,"aMS",@progbits,1
.LC114:
	.string	"hynix RR %d row=%x, count %d, status=%d\n"
	.section	.rodata.idb_write_data.str1.1,"aMS",@progbits,1
.LC130:
	.string	"1 write_idblock fix data %x %x %x\n"
.LC131:
	.string	"write_idblock check fail! %x\n"
.LC132:
	.string	"write_idblock fail! %x\n"
	.section	.rodata.load_l2p_region.str1.1,"aMS",@progbits,1
.LC184:
	.string	"region_id = %d, pm_max_region = %d\n"
.LC185:
	.string	"load_l2p_region no ppa = %x , %x, all setting 0xff....\n"
.LC186:
	.string	"load_l2p_region = %x,%x,%x, %x\n"
.LC187:
	.string	"pm_ppa:"
.LC188:
	.string	"data:"
.LC189:
	.string	"spare:"
	.section	.rodata.lpa_rebuild_hash.str1.1,"aMS",@progbits,1
.LC78:
	.string	"%s %d %d\n"
	.section	.rodata.micron_read_retrial.str1.1,"aMS",@progbits,1
.LC109:
	.string	"micron %d row=%x,last status %d,status = %d\n"
.LC110:
	.string	"micron RR %d row=%x,count %d,status=%d\n"
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
.LC91:
	.string	"...%s enter... %p\n"
.LC92:
	.string	"0:%x %x %x %x %x\n"
.LC93:
	.string	"g_nandc_ver...%d\n"
	.section	.rodata.nandc_xfer.str1.1,"aMS",@progbits,1
.LC105:
	.string	"dqs data abort %x\n"
.LC106:
	.string	"dqs data timeout %x\n"
.LC107:
	.string	"xfer error %x\n"
	.section	.rodata.nandc_xfer_done.str1.1,"aMS",@progbits,1
.LC100:
	.string	"flash_abort_clear = %d\n"
.LC101:
	.string	"%d mtrans_cnt = %d page_num = %d\n"
.LC102:
	.string	"nandc:"
.LC103:
	.string	"%d flReg.d32=%x %x\n"
.LC104:
	.string	"nandc_xfer_done read error %x\n"
	.section	.rodata.pm_alloc_new_blk.str1.1,"aMS",@progbits,1
.LC76:
	.string	"blk %x is bad block\n"
.LC77:
	.string	"pm_alloc_new_blk: %x %x %x %x\n"
	.section	.rodata.pm_free_sblk.str1.1,"aMS",@progbits,1
.LC89:
	.string	"ftl_free_no_use_map_blk %x %x %x %d\n"
	.section	.rodata.pm_init.str1.1,"aMS",@progbits,1
.LC190:
	.string	"pm_init posr %x %x %x\n"
.LC191:
	.string	"pm_init recovery %x %x %x\n"
	.section	.rodata.pm_log2phys.str1.1,"aMS",@progbits,1
.LC192:
	.string	"pm_log2phys  lpn = %d, max lpn = %d\n"
	.section	.rodata.pm_ppa_update_check.str1.1,"aMS",@progbits,1
.LC183:
	.string	"%s w error lpn = %x, max ppa = %d\n"
	.section	.rodata.pm_write_page.str1.1,"aMS",@progbits,1
.LC160:
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
	.string	"swl : %x %x %x %x\n"
	.section	.rodata.print_gc_debug_info.str1.1,"aMS",@progbits,1
.LC49:
	.string	"gc: b:%x,p:%x,i:%x; free buf=%d %d free slc th: %d\n"
	.section	.rodata.print_list_info.str1.1,"aMS",@progbits,1
.LC56:
	.string	"list count:%p %d\n"
.LC57:
	.string	"%d: node:%x %x %x %x, %d %d %d %d %d\n"
	.section	.rodata.queue_wait_first_req_completed.str1.1,"aMS",@progbits,1
.LC123:
	.string	"read: %x %x %x %x\n"
.LC124:
	.string	"0set buf %d,status = %x, ppa = %x lun state = %d\n"
.LC125:
	.string	"prog end %x %x error_ecc %d %d\n"
.LC126:
	.string	"1set buf %d,status = %x, ppa = %x lun state = %d\n"
.LC127:
	.string	"dp prog end %x %x error_ecc %d %d\n"
	.section	.rodata.random_seed,"a",@progbits
	.align	3
	.set	.LANCHOR49,. + 0
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
.LC208:
	.string	"zftl_init %x\n"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",@progbits,1
.LC94:
	.string	"%s 0x%x:"
.LC95:
	.string	"%x "
.LC96:
	.string	""
.LC97:
	.string	"%s\n"
	.section	.rodata.sandisk_prog_test_bad_block.str1.1,"aMS",@progbits,1
.LC41:
	.string	"bad block test:%x %x\n"
	.section	.rodata.sblk_3d_tlc_dump_prog.str1.1,"aMS",@progbits,1
.LC133:
	.string	"sblk_3d_tlc_dump_prog wl_addr= %x ppa = %x ppa = %x\n"
	.section	.rodata.sblk_mlc_dump_prog.str1.1,"aMS",@progbits,1
.LC134:
	.string	"sblk_mlc_dump_prog wl_addr= %x ppa = %x ppa = %x\n"
	.section	.rodata.sblk_prog_page.str1.1,"aMS",@progbits,1
.LC135:
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
	.section	.rodata.toshiba_3D_tlc_value,"a",@progbits
	.align	3
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
	.section	.rodata.toshiba_3d_read_retrial.str1.1,"aMS",@progbits,1
.LC111:
	.string	"toshiba SRR %d row=%x, status=%d\n"
.LC112:
	.string	"toshiba TRR %d row=%x, status=%d\n"
.LC113:
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
.LC241:
	.string	"ftl_discard:(%x, %x, %x, %x)\n"
	.section	.rodata.zftl_do_gc.str1.1,"aMS",@progbits,1
.LC236:
	.string	"gc %d: %d %d %d %d %d %d %d\n"
.LC237:
	.string	"gc %d: %d %d %d %d %d %d\n"
.LC238:
	.string	"GC_STATE_SCAN_ALL_PAGE = %x, vpn0 = %d, vpn1 = %d\n"
.LC239:
	.string	"gc free %x, %d\n"
	.section	.rodata.zftl_gc_get_free_sblk.str1.1,"aMS",@progbits,1
.LC52:
	.string	"swl_tlc_free_mini_ec_blk alloc sblk %x\n"
.LC53:
	.string	"zftl_get_free_sblk %x %d, %p %d %d\n"
.LC54:
	.string	"zftl_gc_get_free_sblk %x %x %x, %d %d %d\n"
	.section	.rodata.zftl_get_free_sblk.str1.1,"aMS",@progbits,1
.LC55:
	.string	"swl_slc_free_mini_ec_blk alloc sblk %x\n"
	.section	.rodata.zftl_init.str1.1,"aMS",@progbits,1
.LC196:
	.string	"FTL version: 6.0.16 20190427"
.LC197:
	.string	"_c_user_data_density := %d\n"
.LC198:
	.string	"_c_totle_phy_density := %d\n"
.LC199:
	.string	"_c_totle_log_page := %d\n"
.LC200:
	.string	"_c_totle_data_density := %d\n"
.LC201:
	.string	"_c_ftl_pm_page_num := %d\n"
.LC202:
	.string	"_c_ftl_byte_pre_page := %d\n"
.LC203:
	.string	"_c_max_pm_sblk := %d\n"
.LC204:
	.string	"_min_slc_super_block := %d\n"
.LC205:
	.string	"_max_xlc_super_block := %d\n"
.LC206:
	.string	"gp_ftl_ext_info %p %p %p\n"
.LC207:
	.string	"flash info size: %d %d %d\n"
	.section	.rodata.zftl_read.str1.1,"aMS",@progbits,1
.LC220:
	.string	"ftl_read %x %x %x\n"
.LC221:
	.string	"ftl_read refresh =%x, lpa = %x, ppa= %x\n"
.LC222:
	.string	"id=%d, status = %x, lpa = %x, ppa = %x spare = %x %x %x %x\n"
	.section	.rodata.zftl_sblk_list_init.str1.1,"aMS",@progbits,1
.LC88:
	.string	"free blk vpn error: %x %x\n"
	.section	.rodata.zftl_write.str1.1,"aMS",@progbits,1
.LC240:
	.string	"ftlwrite %x %x %x %x\n"
	.hidden	free
