/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2018-06-15
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
	adrp	x0, .LANCHOR0
	ldrb	w1, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printf
.L111:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L112
	adrp	x0, .LANCHOR19
	add	x0, x0, :lo12:.LANCHOR19
	ldrb	w2, [x0, 11]
	ldrb	w1, [x0, 10]
	adrp	x0, .LC28
	add	x0, x0, :lo12:.LC28
	bl	printf
.L112:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L113
	adrp	x0, .LANCHOR19
	add	x0, x0, :lo12:.LANCHOR19
	ldrb	w2, [x0, 9]
	ldrb	w1, [x0, 8]
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	bl	printf
.L113:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L83
	adrp	x0, .LANCHOR20
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ldrb	w1, [x0, #:lo12:.LANCHOR20]
	adrp	x0, .LC30
	add	x0, x0, :lo12:.LC30
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
	adrp	x6, .LANCHOR25
	add	x6, x6, :lo12:.LANCHOR25
	adrp	x3, .LANCHOR21
	add	x3, x3, :lo12:.LANCHOR21
	umull	x2, w2, w0
	adrp	x0, .LANCHOR22
	add	x7, x0, :lo12:.LANCHOR22
	mov	x5, x0
	ldrb	w0, [x6]
	add	x3, x3, x2
	add	x7, x7, x2
	adrp	x8, .LANCHOR23
	mov	x2, 0
	adrp	x10, .LANCHOR24
	add	x8, x8, :lo12:.LANCHOR23
	add	x10, x10, :lo12:.LANCHOR24
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
	add	x0, x5, :lo12:.LANCHOR22
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
	adrp	x2, .LANCHOR26
	and	w1, w1, 255
	mov	x3, 32
	and	w0, w0, 255
	ldr	x2, [x2, #:lo12:.LANCHOR26]
	mov	x4, 0
	add	x6, x2, 128
	add	x2, x2, 112
	ldrb	w5, [x2, 1]
	cmp	w5, w4, uxtb
	umaddl	x3, w1, w5, x3
	mov	w1, 160
	umaddl	x1, w1, w0, x3
	ubfiz	x0, x0, 8, 8
	add	x2, x2, x1
	adrp	x1, .LANCHOR13
	ldr	x3, [x1, #:lo12:.LANCHOR13]
	add	x3, x3, x0
	mov	w0, 54
	str	w0, [x3, 2056]
	bhi	.L228
	mov	w0, 22
	str	w0, [x3, 2056]
	ret
.L228:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L224:
	ldrb	w0, [x6, x4]
	str	w0, [x3, 2052]
	mov	w0, 120
	bl	timer_delay_ns
	ldrsb	w0, [x2, x4]
	str	w0, [x3, 2048]
	add	x4, x4, 1
	cmp	w5, w4, uxtb
	bhi	.L224
	mov	w0, 22
	str	w0, [x3, 2056]
	ldp	x29, x30, [sp], 16
	ret
	.size	hynix_set_rr_para, .-hynix_set_rr_para
	.section	.text.hynix_reconfig_rr_para,"ax",@progbits
	.align	2
	.global	hynix_reconfig_rr_para
	.type	hynix_reconfig_rr_para, %function
hynix_reconfig_rr_para:
	adrp	x1, .LANCHOR23
	ldrb	w1, [x1, #:lo12:.LANCHOR23]
	sub	w1, w1, #1
	and	w1, w1, 255
	cmp	w1, 6
	bhi	.L235
	adrp	x8, .LANCHOR26
	and	w0, w0, 255
	sxtw	x7, w0
	ldr	x1, [x8, #:lo12:.LANCHOR26]
	add	x1, x1, x7
	ldrb	w1, [x1, 120]
	cbz	w1, .L235
	stp	x29, x30, [sp, -16]!
	mov	w1, 0
	add	x29, sp, 0
	bl	hynix_set_rr_para
	ldr	x0, [x8, #:lo12:.LANCHOR26]
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
	adrp	x1, .LANCHOR27
	and	w0, w0, 255
	adrp	x2, .LANCHOR13
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
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
	adrp	x0, .LANCHOR27
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
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
	adrp	x0, .LANCHOR27
	and	w1, w1, -32769
	orr	w1, w1, 196608
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
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
	adrp	x1, .LANCHOR28
	adrp	x0, .LC0
	mov	w2, 599
	add	x1, x1, :lo12:.LANCHOR28
	add	x0, x0, :lo12:.LC0
	bl	printf
.L254:
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
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
	ldrb	w0, [x5, #:lo12:.LANCHOR1]
	udiv	w4, w1, w3
	mul	w4, w4, w3
	sub	w3, w1, w4
	cbz	w0, .L263
	add	w1, w4, w3, lsl 1
.L261:
	mov	w0, w6
	b	flash_wait_device_ready_raw
.L263:
	adrp	x5, .LANCHOR3
	add	x5, x5, :lo12:.LANCHOR3
	ldrh	w3, [x5, w3, uxtw 1]
	add	w1, w3, w4
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
	.section	.text.nandc_wait_flash_ready,"ax",@progbits
	.align	2
	.global	nandc_wait_flash_ready
	.type	nandc_wait_flash_ready, %function
nandc_wait_flash_ready:
	mov	w2, 34464
	stp	x29, x30, [sp, -32]!
	movk	w2, 0x1, lsl 16
	adrp	x3, .LANCHOR13
	add	x29, sp, 0
.L273:
	mov	w0, 100
	bl	timer_delay_ns
	ldr	x0, [x3, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbnz	x0, 9, .L274
	subs	w2, w2, #1
	bne	.L273
	mov	w0, -1
.L271:
	ldp	x29, x30, [sp], 32
	ret
.L274:
	mov	w0, 0
	b	.L271
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
	adrp	x0, .LANCHOR25
	adrp	x2, .LANCHOR21
	add	x2, x2, :lo12:.LANCHOR21
	ldrb	w4, [x0, #:lo12:.LANCHOR25]
	adrp	x0, .LANCHOR23
	ldrb	w5, [x0, #:lo12:.LANCHOR23]
	mov	w0, 5
	umull	x1, w1, w0
	adrp	x0, .LANCHOR22
	add	x0, x0, :lo12:.LANCHOR22
	add	x2, x2, x1
	add	x1, x0, x1
	mov	x0, 0
.L278:
	cmp	w4, w0
	bhi	.L281
	ldp	x29, x30, [sp], 16
	b	nandc_wait_flash_ready
.L281:
	cmp	w5, 67
	bne	.L279
	ldrsb	w6, [x1, x0]
.L283:
	add	x0, x0, 1
	str	w6, [x3]
	b	.L278
.L279:
	ldrsb	w6, [x2, x0]
	b	.L283
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
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
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
	adrp	x2, .LANCHOR31
	add	x2, x2, :lo12:.LANCHOR31
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
	cbz	w2, .L288
	stp	x29, x30, [sp, -16]!
	mov	x4, x0
	mov	x2, 7
	mov	w0, 18
	add	x29, sp, 0
	str	w6, [x4, 8]
	mul	x1, x1, x2
	str	w0, [x4, 4]
	adrp	x0, .LANCHOR32
	add	x0, x0, :lo12:.LANCHOR32
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
.L291:
	b	nandc_wait_flash_ready
.L288:
	str	w6, [x0, 8]
	mov	w2, 20
	str	w2, [x0, 4]
	adrp	x2, .LANCHOR33
	add	x2, x2, :lo12:.LANCHOR33
	ldrb	w1, [x2, x1]
	str	w1, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	b	.L291
	.size	toshiba_tlc_set_rr_para, .-toshiba_tlc_set_rr_para
	.section	.text.zftl_flash_enter_slc_mode,"ax",@progbits
	.align	2
	.global	zftl_flash_enter_slc_mode
	.type	zftl_flash_enter_slc_mode, %function
zftl_flash_enter_slc_mode:
	adrp	x1, .LANCHOR0
	and	x0, x0, 255
	ldrb	w2, [x1, #:lo12:.LANCHOR0]
	cbz	w2, .L294
	adrp	x1, .LANCHOR13
	cmp	w2, 1
	ldr	x1, [x1, #:lo12:.LANCHOR13]
	bne	.L297
.L314:
	adrp	x2, .LANCHOR34+29
	ldrb	w2, [x2, #:lo12:.LANCHOR34+29]
	cbz	w2, .L294
	add	x0, x0, 8
	add	x0, x1, x0, lsl 8
	str	w2, [x0, 8]
	ret
.L297:
	cmp	w2, 2
	bne	.L299
	adrp	x2, .LANCHOR35
	add	x2, x2, :lo12:.LANCHOR35
	ldrb	w3, [x2, x0]
	cbz	w3, .L294
	strb	wzr, [x2, x0]
	b	.L314
.L299:
	cmp	w2, 3
	bne	.L294
	adrp	x2, .LANCHOR35
	sxtw	x3, w0
	add	x2, x2, :lo12:.LANCHOR35
	ldrb	w4, [x2, x3]
	cbz	w4, .L294
	ubfiz	x0, x0, 8, 8
	strb	wzr, [x2, x3]
	add	x0, x1, x0
	mov	w1, 239
	str	w1, [x0, 2056]
	mov	w1, 145
	str	w1, [x0, 2052]
	mov	w1, 1
	str	wzr, [x0, 2048]
	str	w1, [x0, 2048]
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
	b	nandc_wait_flash_ready
.L294:
	ret
	.size	zftl_flash_enter_slc_mode, .-zftl_flash_enter_slc_mode
	.section	.text.zftl_flash_exit_slc_mode,"ax",@progbits
	.align	2
	.global	zftl_flash_exit_slc_mode
	.type	zftl_flash_exit_slc_mode, %function
zftl_flash_exit_slc_mode:
	adrp	x1, .LANCHOR0
	and	x0, x0, 255
	ldrb	w2, [x1, #:lo12:.LANCHOR0]
	cbz	w2, .L315
	adrp	x1, .LANCHOR13
	cmp	w2, 1
	ldr	x1, [x1, #:lo12:.LANCHOR13]
	bne	.L318
	adrp	x2, .LANCHOR34+30
	ldrb	w2, [x2, #:lo12:.LANCHOR34+30]
.L335:
	cbz	w2, .L315
	add	x0, x0, 8
	add	x0, x1, x0, lsl 8
	str	w2, [x0, 8]
	ret
.L318:
	cmp	w2, 2
	bne	.L320
	adrp	x3, .LANCHOR35
	add	x3, x3, :lo12:.LANCHOR35
	ldrb	w2, [x3, x0]
	cbnz	w2, .L315
	adrp	x2, .LANCHOR34
	add	x2, x2, :lo12:.LANCHOR34
	mov	w5, 4
	ldrb	w4, [x2, 12]
	ldrb	w2, [x2, 30]
	cmp	w4, 2
	csel	w4, w4, w5, eq
	strb	w4, [x3, x0]
	b	.L335
.L320:
	cmp	w2, 3
	bne	.L315
	adrp	x3, .LANCHOR35
	sxtw	x4, w0
	add	x3, x3, :lo12:.LANCHOR35
	ldrb	w2, [x3, x4]
	cbnz	w2, .L315
	ubfiz	x0, x0, 8, 8
	adrp	x2, .LANCHOR34+12
	add	x0, x1, x0
	mov	w1, 239
	ldrb	w2, [x2, #:lo12:.LANCHOR34+12]
	mov	w5, 4
	str	w1, [x0, 2056]
	cmp	w2, 2
	mov	w1, 145
	str	w1, [x0, 2052]
	csel	w2, w2, w5, eq
	str	w2, [x0, 2048]
	mov	w1, 1
	str	w1, [x0, 2048]
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
	strb	w2, [x3, x4]
	b	nandc_wait_flash_ready
.L315:
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
	bhi	.L337
	adrp	x1, .LANCHOR36
	adrp	x0, .LC0
	mov	w2, 741
	add	x1, x1, :lo12:.LANCHOR36
	add	x0, x0, :lo12:.LC0
	bl	printf
.L337:
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	ldrb	w7, [x0, w22, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x6, [x0, #:lo12:.LANCHOR13]
	mov	w0, w7
	bl	nandc_cs
	cbnz	w21, .L338
	mov	w0, w19
	bl	slc_phy_page_address_calc
	mov	w19, w0
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L339
	mov	w0, w7
	bl	zftl_flash_enter_slc_mode
.L339:
	ubfiz	x1, x7, 8, 8
	and	w0, w19, 255
	add	x1, x6, x1
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
.L338:
	adrp	x0, .LANCHOR16
	ldr	x0, [x0, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L340
	sxtw	x0, w7
	add	x0, x0, 8
	add	x0, x6, x0, lsl 8
	str	w21, [x0, 8]
	b	.L339
.L340:
	mov	w0, w7
	bl	zftl_flash_exit_slc_mode
	b	.L339
	.size	flash_start_page_read, .-flash_start_page_read
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
	bhi	.L346
	adrp	x1, .LANCHOR37
	adrp	x0, .LC0
	mov	w2, 510
	add	x1, x1, :lo12:.LANCHOR37
	add	x0, x0, :lo12:.LC0
	bl	printf
.L346:
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	ldrb	w22, [x0, w19, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x24, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR14
	and	x19, x22, 255
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	add	x23, x19, 8
	add	x23, x24, x23, lsl 8
	tbz	x0, 4, .L347
	adrp	x0, .LC31
	mov	w3, w20
	mov	w2, w21
	mov	w1, w22
	add	x0, x0, :lo12:.LC31
	bl	printf
.L347:
	bl	nandc_wait_flash_ready
	mov	w0, w22
	bl	nandc_cs
	mov	w0, w22
	cbnz	w25, .L348
	bl	zftl_flash_enter_slc_mode
.L349:
	add	x24, x24, x19, lsl 8
	mov	w0, 96
	str	w0, [x24, 2056]
	and	w0, w21, 255
	str	w0, [x24, 2052]
	lsr	w0, w21, 8
	str	w0, [x24, 2052]
	lsr	w0, w21, 16
	str	w0, [x24, 2052]
	adrp	x0, .LANCHOR38
	ldrb	w0, [x0, #:lo12:.LANCHOR38]
	cbnz	w0, .L352
	mov	w0, 208
	str	w0, [x24, 2056]
	mov	w19, 5
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	and	w5, w0, w19
.L350:
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
	cbz	w19, .L351
	adrp	x0, .LC32
	mov	w1, w21
	add	x0, x0, :lo12:.LC32
	bl	printf
.L351:
	mov	w0, w19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L348:
	bl	zftl_flash_exit_slc_mode
	b	.L349
.L352:
	mov	w5, 0
	b	.L350
	.size	flash_erase_duplane_block, .-flash_erase_duplane_block
	.section	.text.flash_erase_block_en,"ax",@progbits
	.align	2
	.global	flash_erase_block_en
	.type	flash_erase_block_en, %function
flash_erase_block_en:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 255
	adrp	x0, .LANCHOR18
	stp	x21, x22, [sp, 32]
	str	x25, [sp, 64]
	mov	w21, w2
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	and	w22, w2, 2097151
	stp	x23, x24, [sp, 48]
	and	w25, w1, 255
	cmp	w0, w19
	bhi	.L361
	adrp	x1, .LANCHOR39
	adrp	x0, .LC0
	mov	w2, 555
	add	x1, x1, :lo12:.LANCHOR39
	add	x0, x0, :lo12:.LC0
	bl	printf
.L361:
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	ldrb	w20, [x0, w19, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x24, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR14
	and	x19, x20, 255
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	add	x23, x19, 8
	add	x23, x24, x23, lsl 8
	tbz	x0, 4, .L362
	adrp	x0, .LC33
	mov	w2, w21
	mov	w1, w20
	add	x0, x0, :lo12:.LC33
	bl	printf
.L362:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w25, .L363
	bl	zftl_flash_enter_slc_mode
.L364:
	add	x0, x24, x19, lsl 8
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
	mov	x0, x23
	bl	flash_read_status
	mov	w19, w0
	bl	nandc_de_cs.constprop.29
	mov	w0, 5
	ands	w19, w19, w0
	beq	.L365
	adrp	x0, .LANCHOR2
	mov	w2, w19
	ldrh	w1, [x0, #:lo12:.LANCHOR2]
	adrp	x0, .LC34
	add	x0, x0, :lo12:.LC34
	udiv	w1, w21, w1
	bl	printf
.L365:
	mov	w0, w19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L363:
	bl	zftl_flash_exit_slc_mode
	b	.L364
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
	adrp	x0, .LANCHOR34
	add	x0, x0, :lo12:.LANCHOR34
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
	adrp	x24, .LANCHOR29
	ldrb	w1, [x0, 13]
	mul	w20, w20, w1
	and	w20, w20, 65535
.L375:
	ldrb	w0, [x22]
	cmp	w0, w19
	bhi	.L378
	ldp	x19, x20, [sp, 16]
	mov	w1, 0
	ldp	x21, x22, [sp, 32]
	adrp	x0, .LC35
	ldp	x23, x24, [sp, 48]
	add	x0, x0, :lo12:.LC35
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	b	printf
.L378:
	add	x0, x24, :lo12:.LANCHOR29
	mov	w21, 0
	ldrb	w25, [x0, w19, sxtw]
.L376:
	cmp	w20, w21, uxth
	bhi	.L377
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L375
.L377:
	ldrh	w1, [x23]
	mov	w0, w25
	mul	w1, w1, w21
	add	w21, w21, 1
	bl	flash_erase_block
	b	.L376
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
	bhi	.L381
	adrp	x1, .LANCHOR40
	adrp	x0, .LC0
	mov	w2, 836
	add	x1, x1, :lo12:.LANCHOR40
	add	x0, x0, :lo12:.LC0
	bl	printf
.L381:
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	ldrb	w6, [x0, w22, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x8, [x0, #:lo12:.LANCHOR13]
	mov	w0, w6
	bl	nandc_cs
	adrp	x7, .LANCHOR16
	cbnz	w19, .L382
	mov	w0, w21
	bl	slc_phy_page_address_calc
	mov	w21, w0
	mov	w0, w20
	bl	slc_phy_page_address_calc
	mov	w20, w0
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L383
	mov	w0, w6
	bl	zftl_flash_enter_slc_mode
.L383:
	and	x4, x6, 255
	adrp	x0, .LANCHOR19
	add	x1, x0, :lo12:.LANCHOR19
	add	x4, x8, x4, lsl 8
	and	w3, w21, 255
	and	w6, w20, 255
	lsr	w5, w20, 8
	lsr	w20, w20, 16
	ldrb	w10, [x1, 8]
	ldrb	w2, [x1, 16]
	str	w10, [x4, 2056]
	cmp	w2, 1
	lsr	w2, w21, 8
	lsr	w21, w21, 16
	bne	.L385
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	str	w3, [x4, 2052]
	str	w2, [x4, 2052]
	ldrb	w0, [x1, 9]
	str	w21, [x4, 2052]
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	ldr	x0, [x7, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L386
	cbz	w19, .L386
	str	w19, [x4, 2056]
.L386:
	str	wzr, [x4, 2056]
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
.L399:
	ldp	x21, x22, [sp, 32]
	str	w6, [x4, 2052]
	str	w5, [x4, 2052]
	mov	w0, 48
	str	w20, [x4, 2052]
	str	w0, [x4, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	nandc_de_cs.constprop.29
.L382:
	ldr	x0, [x7, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L384
	sxtw	x0, w6
	add	x0, x0, 8
	add	x0, x8, x0, lsl 8
	str	w19, [x0, 8]
	b	.L383
.L384:
	mov	w0, w6
	bl	zftl_flash_exit_slc_mode
	b	.L383
.L385:
	str	w3, [x4, 2052]
	ldr	x1, [x7, #:lo12:.LANCHOR16]
	str	w2, [x4, 2052]
	str	w21, [x4, 2052]
	ldrb	w1, [x1, 12]
	cmp	w1, 3
	bne	.L388
	cbz	w19, .L388
	str	w19, [x4, 2056]
.L388:
	add	x0, x0, :lo12:.LANCHOR19
	ldrb	w0, [x0, 9]
	str	w0, [x4, 2056]
	b	.L399
	.size	flash_start_plane_read, .-flash_start_plane_read
	.section	.text.flash_set_interface_mode,"ax",@progbits
	.align	2
	.global	flash_set_interface_mode
	.type	flash_set_interface_mode, %function
flash_set_interface_mode:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR41
	stp	x21, x22, [sp, 32]
	adrp	x23, .LANCHOR14
	adrp	x22, .LANCHOR42
	str	x25, [sp, 64]
	add	x24, x24, :lo12:.LANCHOR41
	add	x22, x22, :lo12:.LANCHOR42
	add	x23, x23, :lo12:.LANCHOR14
	mov	w25, w0
	stp	x19, x20, [sp, 16]
	mov	x20, 0
.L410:
	lsl	x0, x20, 3
	ldrb	w21, [x0, x24]
	mov	w0, 69
	cmp	w21, 152
	ccmp	w21, w0, 4, ne
	beq	.L401
	cmp	w21, 44
	bne	.L402
.L401:
	adrp	x0, .LANCHOR13
	ldrb	w1, [x22]
	cmp	w25, 1
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	bne	.L403
	tbz	x1, 0, .L402
	ldr	w0, [x23]
	tbz	x0, 12, .L404
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	bl	printf
.L404:
	add	x0, x19, x20, lsl 8
	mov	w1, 239
	cmp	w21, 44
	str	w1, [x0, 2056]
	mov	w1, 1
	bne	.L405
	str	w1, [x0, 2052]
	mov	w1, 5
.L425:
	str	w1, [x0, 2048]
.L409:
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
.L402:
	add	x20, x20, 1
	cmp	x20, 4
	bne	.L410
	bl	nandc_wait_flash_ready
	ldr	x25, [sp, 64]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L405:
	mov	w2, 128
	str	w2, [x0, 2052]
	b	.L425
.L403:
	tbz	x1, 2, .L402
	ldr	w0, [x23]
	tbz	x0, 12, .L407
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	bl	printf
.L407:
	add	x0, x19, x20, lsl 8
	mov	w1, 239
	cmp	w21, 44
	str	w1, [x0, 2056]
	bne	.L408
	mov	w1, 1
	str	w1, [x0, 2052]
	mov	w1, 35
	b	.L425
.L408:
	mov	w1, 128
	str	w1, [x0, 2052]
	str	wzr, [x0, 2048]
	b	.L409
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
	bhi	.L427
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
.L427:
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
	adrp	x2, .LANCHOR34+9
	ubfiz	x0, x0, 8, 8
	add	x29, sp, 0
	ldrb	w3, [x2, #:lo12:.LANCHOR34+9]
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
	adrp	x20, .LANCHOR34
	ldr	x19, [x1, #:lo12:.LANCHOR13]
	add	x1, x20, :lo12:.LANCHOR34
	str	x21, [sp, 32]
	mov	x0, x2
	add	x2, x2, 8
	ldrb	w1, [x1, 29]
	add	x2, x19, x2, lsl 8
	cbz	w1, .L433
.L447:
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
	beq	.L435
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L435
	adrp	x0, .LC39
	mov	w1, w4
	add	x0, x0, :lo12:.LC39
	bl	printf
.L435:
	add	x20, x20, :lo12:.LANCHOR34
	ldrb	w0, [x20, 30]
	cbz	w0, .L432
	str	w0, [x19, 2056]
.L432:
	mov	w0, w21
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L433:
	mov	w1, 162
	b	.L447
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
	adrp	x2, .LANCHOR43
	mov	w1, 1
	strb	w0, [x2, #:lo12:.LANCHOR43]
	adrp	x2, .LANCHOR27
	ldrb	w2, [x2, #:lo12:.LANCHOR27]
	cmp	w2, 9
	adrp	x2, .LANCHOR13
	ldr	x2, [x2, #:lo12:.LANCHOR13]
	bne	.L451
	str	w1, [x2, 16]
	cmp	w0, 70
	beq	.L458
	cmp	w0, 60
	beq	.L459
	cmp	w0, 40
	cset	w1, eq
	add	w1, w1, 1
.L452:
	lsl	w1, w1, 25
	orr	w1, w1, 1
	str	w1, [x2, 32]
	ret
.L458:
	mov	w1, 0
	b	.L452
.L459:
	mov	w1, 3
	b	.L452
.L451:
	str	w1, [x2, 8]
	cmp	w0, 16
	mov	w1, 4096
	bne	.L454
.L457:
	and	w1, w1, -17
.L455:
	orr	w1, w1, 1
	str	w1, [x2, 12]
	ret
.L454:
	cmp	w0, 24
	bne	.L456
	orr	w1, w1, 16
	b	.L455
.L456:
	orr	w1, w1, 262144
	cmp	w0, 40
	orr	w1, w1, 16
	bne	.L455
	b	.L457
	.size	nandc_bch_sel, .-nandc_bch_sel
	.section	.text.zftl_nandc_get_irq_status,"ax",@progbits
	.align	2
	.global	zftl_nandc_get_irq_status
	.type	zftl_nandc_get_irq_status, %function
zftl_nandc_get_irq_status:
	adrp	x1, .LANCHOR27
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
	cmp	w1, 9
	bne	.L465
	ldr	w0, [x0, 296]
	ret
.L465:
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
	adrp	x4, .LANCHOR46
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w23, w0, 255
	adrp	x0, .LANCHOR27
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	add	w20, w1, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
	adrp	x24, .LANCHOR13
	cmp	w0, 9
	bne	.L471
	ubfiz	w19, w23, 1, 1
	mov	w0, 1
	orr	w19, w19, 8
	asr	w20, w20, 1
	bfi	w19, w0, 5, 2
	adrp	x0, .LANCHOR44
	orr	w19, w19, 536870912
	orr	w19, w19, 1024
	ldrb	w0, [x0, #:lo12:.LANCHOR44]
	and	w19, w19, -17
	bfi	w19, w20, 22, 6
	orr	w19, w19, 128
	cbz	w0, .L472
	adrp	x0, .LANCHOR45
	ldrb	w1, [x0, #:lo12:.LANCHOR45]
	orr	w0, w19, 512
	cmp	w1, 0
	csel	w19, w0, w19, ne
.L472:
	add	x21, x4, :lo12:.LANCHOR46
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
	adrp	x2, .LANCHOR47
	orr	w0, w0, 1
	ldrh	w2, [x2, #:lo12:.LANCHOR47]
	bfi	w0, w2, 16, 11
	str	w0, [x1, 48]
	str	w19, [x1, 16]
	orr	w19, w19, 4
	str	w19, [x1, 16]
.L470:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L471:
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
	cbz	w23, .L474
	adrp	x0, .LANCHOR43
	ubfx	x1, x1, 1, 7
	ldr	x8, [x4, #:lo12:.LANCHOR46]
	add	x1, x3, x1, lsl 2
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	mov	w5, 128
	cmp	w0, 24
	mov	w0, 64
	csel	w5, w5, w0, hi
	mov	w0, 0
.L476:
	add	w7, w5, w0
	cmp	x3, x1
	bne	.L477
.L478:
	add	x21, x4, :lo12:.LANCHOR46
	ldr	x0, [x4, #:lo12:.LANCHOR46]
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
	b	.L470
.L477:
	ldrh	w10, [x3]
	and	x0, x0, 4294967292
	ldrh	w6, [x3, 2]
	add	x3, x3, 4
	orr	x6, x10, x6, lsl 16
	str	w6, [x8, x0]
	mov	w0, w7
	b	.L476
.L474:
	ldr	x1, [x4, #:lo12:.LANCHOR46]
	str	w0, [x1]
	b	.L478
	.size	nandc_xfer_start, .-nandc_xfer_start
	.section	.text.nandc_set_seed,"ax",@progbits
	.align	2
	.global	nandc_set_seed
	.type	nandc_set_seed, %function
nandc_set_seed:
	and	x0, x0, 127
	adrp	x1, .LANCHOR48
	add	x1, x1, :lo12:.LANCHOR48
	ldrh	w0, [x1, x0, lsl 1]
	adrp	x1, .LANCHOR45
	ldrb	w2, [x1, #:lo12:.LANCHOR45]
	orr	w1, w0, -1073741824
	cmp	w2, 0
	csel	w0, w1, w0, ne
	adrp	x1, .LANCHOR27
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
	cmp	w1, 9
	adrp	x1, .LANCHOR13
	ldr	x1, [x1, #:lo12:.LANCHOR13]
	bne	.L488
	str	w0, [x1, 520]
	ret
.L488:
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
	adrp	x19, .LANCHOR20
	mov	w0, 0
	bl	hynix_reconfig_rr_para
	ldrb	w0, [x19, #:lo12:.LANCHOR20]
	cbz	w0, .L493
	adrp	x0, .LANCHOR42
	ldrb	w0, [x0, #:lo12:.LANCHOR42]
	tbz	x0, 0, .L493
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
	bl	nandc_set_if_mode
	strb	wzr, [x19, #:lo12:.LANCHOR20]
.L493:
	adrp	x3, .LANCHOR45
	ldrb	w0, [x3, #:lo12:.LANCHOR45]
	cbz	w0, .L494
	mov	w0, 0
	strb	wzr, [x3, #:lo12:.LANCHOR45]
	bl	nandc_set_seed
	mov	w0, 1
	strb	w0, [x3, #:lo12:.LANCHOR45]
.L494:
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
	adrp	x1, .LANCHOR45
	strb	w0, [x1, #:lo12:.LANCHOR45]
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
	adrp	x0, .LANCHOR49
	add	x1, x0, :lo12:.LANCHOR49
	mov	w2, 0
.L508:
	and	w3, w2, 255
	strb	wzr, [x1, 2]
	add	w4, w3, 1
	strb	w3, [x1, 1]
	strb	w4, [x1]
	add	w2, w2, 1
	str	xzr, [x1, 16]
	cmp	w2, 32
	add	x1, x1, 64
	bne	.L508
	add	x0, x0, :lo12:.LANCHOR49
	mov	w1, -1
	strb	w1, [x0, 1984]
	adrp	x0, .LANCHOR50
	strb	wzr, [x0, #:lo12:.LANCHOR50]
	adrp	x0, .LANCHOR51
	strb	w2, [x0, #:lo12:.LANCHOR51]
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
	bne	.L516
	ldrb	w0, [x20, 1]
	cmp	w0, 255
	bne	.L512
	adrp	x1, .LANCHOR52
	adrp	x0, .LC0
	mov	w2, 74
	add	x1, x1, :lo12:.LANCHOR52
	add	x0, x0, :lo12:.LC0
	bl	printf
.L512:
	ldrb	w0, [x20, 1]
	strb	w0, [x19]
.L510:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L516:
	adrp	x0, .LANCHOR49
	add	x2, x0, :lo12:.LANCHOR49
	mov	x19, x0
.L517:
	sbfiz	x0, x1, 6, 32
	mov	w21, w1
	ldrb	w1, [x2, x0]
	cmp	w1, 255
	bne	.L517
	ldrb	w0, [x20, 1]
	cmp	w0, 255
	bne	.L514
	adrp	x1, .LANCHOR52
	adrp	x0, .LC0
	mov	w2, 81
	add	x1, x1, :lo12:.LANCHOR52
	add	x0, x0, :lo12:.LC0
	bl	printf
.L514:
	add	x0, x19, :lo12:.LANCHOR49
	sbfiz	x21, x21, 6, 32
	ldrb	w1, [x20, 1]
	strb	w1, [x0, x21]
	b	.L510
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
	adrp	x0, .LANCHOR53
	ldr	x19, [sp, 16]
	add	x0, x0, :lo12:.LANCHOR53
	ldp	x29, x30, [sp], 32
	b	buf_add_tail
	.size	queue_read_cmd, .-queue_read_cmd
	.section	.text.buf_free,"ax",@progbits
	.align	2
	.global	buf_free
	.type	buf_free, %function
buf_free:
	ldrb	w1, [x0, 2]
	adrp	x2, .LANCHOR50
	and	w1, w1, 8
	strb	w1, [x0, 2]
	cbz	w1, .L522
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L522
	stp	x29, x30, [sp, -16]!
	mov	x1, x0
	add	x0, x2, :lo12:.LANCHOR50
	add	x29, sp, 0
	bl	buf_add_tail
	adrp	x1, .LANCHOR51
	ldp	x29, x30, [sp], 16
	ldrb	w0, [x1, #:lo12:.LANCHOR51]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR51]
	ret
.L522:
	ldrb	w1, [x2, #:lo12:.LANCHOR50]
	strb	w1, [x0]
	adrp	x1, .LANCHOR51
	ldrb	w0, [x0, 1]
	strb	w0, [x2, #:lo12:.LANCHOR50]
	ldrb	w0, [x1, #:lo12:.LANCHOR51]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR51]
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
	adrp	x19, .LANCHOR51
	and	w20, w0, 255
	ldrb	w0, [x19, #:lo12:.LANCHOR51]
	cbz	w0, .L535
.L538:
	adrp	x2, .LANCHOR50
	adrp	x1, .LANCHOR49
	add	x0, x1, :lo12:.LANCHOR49
	ldrb	w3, [x2, #:lo12:.LANCHOR50]
	ubfiz	x4, x3, 6, 8
	add	x0, x0, x4
	mov	x4, x2
	cbz	w20, .L536
.L537:
	add	x1, x1, :lo12:.LANCHOR49
	sbfiz	x3, x3, 6, 32
	add	x2, x1, x3
	ldrb	w5, [x1, x3]
	strb	w5, [x4, #:lo12:.LANCHOR50]
	ldrb	w4, [x19, #:lo12:.LANCHOR51]
	strh	wzr, [x2, 50]
	sub	w4, w4, #1
	strb	w4, [x19, #:lo12:.LANCHOR51]
	mov	w4, 1
	strb	wzr, [x2, 56]
	strb	w4, [x2, 2]
	mov	w4, -1
	strb	wzr, [x2, 57]
	strb	w4, [x1, x3]
	mov	w1, -1
	str	xzr, [x2, 16]
	str	w1, [x2, 36]
	b	.L534
.L535:
	mov	w2, 121
	adrp	x1, .LANCHOR54
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR54
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldrb	w0, [x19, #:lo12:.LANCHOR51]
	cbnz	w0, .L538
.L540:
	mov	x0, 0
.L534:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L536:
	ldrb	w2, [x19, #:lo12:.LANCHOR51]
	cmp	w2, 1
	bne	.L537
	b	.L540
	.size	buf_alloc, .-buf_alloc
	.section	.text.buf_remove_buf,"ax",@progbits
	.align	2
	.global	buf_remove_buf
	.type	buf_remove_buf, %function
buf_remove_buf:
	ldrb	w4, [x1, 1]
	ldrb	w2, [x0]
	cmp	w4, w2
	bne	.L548
	ldrb	w1, [x1]
	strb	w1, [x0]
.L552:
	mov	w0, 1
	ret
.L549:
	mov	w3, w2
	sbfiz	x2, x2, 6, 32
	ldrb	w2, [x0, x2]
	cmp	w4, w2
	bne	.L550
	sbfiz	x3, x3, 6, 32
	ldrb	w2, [x1]
	strb	w2, [x0, x3]
	mov	w0, -1
	strb	w0, [x1]
	b	.L552
.L548:
	adrp	x0, .LANCHOR49
	add	x0, x0, :lo12:.LANCHOR49
.L550:
	cmp	w2, 255
	bne	.L549
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
	adrp	x19, .LANCHOR51
	mov	x20, x0
	ldrb	w0, [x19, #:lo12:.LANCHOR51]
	cbnz	w0, .L554
	adrp	x1, .LANCHOR55
	adrp	x0, .LC0
	mov	w2, 172
	add	x1, x1, :lo12:.LANCHOR55
	add	x0, x0, :lo12:.LC0
	bl	printf
.L554:
	ldrb	w0, [x19, #:lo12:.LANCHOR51]
	cbz	w0, .L553
	mov	x1, x20
	adrp	x0, .LANCHOR50
	add	x0, x0, :lo12:.LANCHOR50
	bl	buf_remove_buf
	cmp	w0, 1
	bne	.L553
	ldrb	w0, [x19, #:lo12:.LANCHOR51]
	sub	w0, w0, #1
	strb	w0, [x19, #:lo12:.LANCHOR51]
	ldrb	w0, [x20, 2]
	orr	w0, w0, 1
	strb	w0, [x20, 2]
.L553:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	buf_remove_free, .-buf_remove_free
	.section	.text.flash_check_bad_block,"ax",@progbits
	.align	2
	.global	flash_check_bad_block
	.type	flash_check_bad_block, %function
flash_check_bad_block:
	adrp	x3, .LANCHOR34
	add	x3, x3, :lo12:.LANCHOR34
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
	adrp	x2, .LANCHOR26
	ldr	x2, [x2, #:lo12:.LANCHOR26]
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
	adrp	x0, .LANCHOR34
	add	x0, x0, :lo12:.LANCHOR34
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	ldrh	w19, [x0, 14]
	ldrb	w1, [x0, 13]
	adrp	x0, .LC40
	add	x0, x0, :lo12:.LC40
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
	adrp	x0, .LANCHOR26
	ldr	x2, [x0, #:lo12:.LANCHOR26]
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
	adrp	x0, .LANCHOR56
	add	x0, x0, :lo12:.LANCHOR56
	bl	buf_add_tail
	adrp	x1, .LANCHOR57
	ldp	x29, x30, [sp], 16
	ldrb	w0, [x1, #:lo12:.LANCHOR57]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x1, #:lo12:.LANCHOR57]
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
	cbnz	w0, .L566
	adrp	x0, .LANCHOR58
	ldr	w0, [x0, #:lo12:.LANCHOR58]
	ret
.L566:
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
	adrp	x0, .LANCHOR59
	ldrh	w0, [x0, #:lo12:.LANCHOR59]
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
	bhi	.L575
	adrp	x1, .LANCHOR60
	adrp	x0, .LC0
	mov	w2, 258
	add	x1, x1, :lo12:.LANCHOR60
	add	x0, x0, :lo12:.LC0
	bl	printf
.L575:
	adrp	x22, .LANCHOR9
	uxtw	x19, w20
	lsl	x26, x19, 1
	adrp	x23, .LANCHOR14
	ldr	x0, [x22, #:lo12:.LANCHOR9]
	adrp	x27, .LANCHOR7
	ldrh	w21, [x0, x26]
	ldr	w0, [x23, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L576
	ldr	x0, [x27, #:lo12:.LANCHOR7]
	mov	w4, w21
	mov	w2, w24
	mov	w1, w20
	add	x0, x0, x19, lsl 2
	ldrb	w3, [x0, 2]
	adrp	x0, .LANCHOR61
	ldrh	w6, [x0, #:lo12:.LANCHOR61]
	adrp	x0, .LANCHOR62+56
	ubfx	x3, x3, 5, 3
	ldrh	w5, [x0, #:lo12:.LANCHOR62+56]
	adrp	x0, .LC41
	add	x0, x0, :lo12:.LC41
	bl	printf
.L576:
	ldr	x0, [x27, #:lo12:.LANCHOR7]
	add	x19, x0, x19, lsl 2
	ldrb	w2, [x19, 2]
	tst	w2, 224
	bne	.L577
	cbz	w21, .L597
	adrp	x1, .LANCHOR60
	adrp	x0, .LC0
	mov	w2, 263
	add	x1, x1, :lo12:.LANCHOR60
	add	x0, x0, :lo12:.LC0
	bl	printf
.L597:
	mov	w0, 0
	b	.L574
.L577:
	adrp	x0, .LANCHOR62
	add	x1, x0, :lo12:.LANCHOR62
	ldrh	w0, [x0, #:lo12:.LANCHOR62]
	cmp	w0, w20
	beq	.L597
	adrp	x21, .LANCHOR10
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	ldrh	w3, [x0, 48]
	cmp	w3, w20
	beq	.L597
	ldrh	w3, [x0, 16]
	cmp	w3, w20
	beq	.L597
	ldrh	w3, [x0, 80]
	cmp	w3, w20
	beq	.L597
	ldrh	w4, [x1, 56]
	add	x1, x1, 58
	mov	w3, 0
.L579:
	cmp	w3, w4
	bcc	.L580
	cbnz	w24, .L584
	adrp	x1, .LANCHOR63
	ldrh	w5, [x1, #:lo12:.LANCHOR63]
	cmp	w20, w5
	beq	.L597
	adrp	x3, .LANCHOR64
	add	x3, x3, :lo12:.LANCHOR64
	mov	x1, 0
.L583:
	ldrh	w6, [x1, x3]
	cmp	w20, w6
	bne	.L582
	ldr	w0, [x23, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L597
	ldr	x0, [x22, #:lo12:.LANCHOR9]
	mov	w4, w20
	ubfx	x2, x2, 5, 3
	mov	w1, w20
	ldrh	w3, [x0, x26]
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	printf
	b	.L597
.L580:
	ldrh	w5, [x1], 2
	cmp	w5, w20
	beq	.L597
	add	w3, w3, 1
	b	.L579
.L582:
	add	x1, x1, 2
	cmp	x1, 16
	bne	.L583
	ubfiz	x19, x25, 7, 16
	add	x19, x19, 136
	add	x19, x0, x19
.L585:
	ldr	w0, [x23, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L586
	ldr	x0, [x22, #:lo12:.LANCHOR9]
	adrp	x1, .LANCHOR61
	mov	w5, w4
	ubfx	x3, x2, 5, 3
	ldrh	w6, [x1, #:lo12:.LANCHOR61]
	mov	w2, w24
	mov	w1, w20
	ldrh	w4, [x0, x26]
	adrp	x0, .LC41
	add	x0, x0, :lo12:.LC41
	bl	printf
.L586:
	mov	x0, x19
	add	x1, x19, 128
	mov	w2, 65535
.L589:
	ldrh	w3, [x0]
	cmp	w3, w2
	bne	.L587
	strh	w20, [x0]
	cbz	w24, .L588
	ldr	x1, [x21, #:lo12:.LANCHOR10]
	ldrh	w0, [x1, 124]
	add	w0, w0, 1
	strh	w0, [x1, 124]
.L607:
	mov	w0, 1
.L574:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L584:
	add	x19, x0, 392
	b	.L585
.L588:
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	add	x25, x0, x25, uxth 1
	ldrh	w0, [x25, 120]
	add	w0, w0, 1
	strh	w0, [x25, 120]
	b	.L607
.L587:
	add	x0, x0, 2
	cmp	x1, x0
	bne	.L589
	b	.L607
	.size	gc_add_sblk, .-gc_add_sblk
	.section	.text.gc_get_src_ppa_from_index,"ax",@progbits
	.align	2
	.global	gc_get_src_ppa_from_index
	.type	gc_get_src_ppa_from_index, %function
gc_get_src_ppa_from_index:
	adrp	x1, .LANCHOR65
	ubfiz	x0, x0, 2, 16
	ldr	x1, [x1, #:lo12:.LANCHOR65]
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
	adrp	x23, .LANCHOR66
	stp	x21, x22, [sp, 32]
	adrp	x24, .LANCHOR49
	add	x23, x23, :lo12:.LANCHOR66
	add	x22, x24, :lo12:.LANCHOR49
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
.L610:
	ldrb	w19, [x23]
	cmp	w19, 255
	bne	.L621
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L621:
	lsl	x1, x19, 6
	add	x0, x24, :lo12:.LANCHOR49
	add	x2, x0, x1
	ldrb	w0, [x0, x1]
	ldr	w1, [x2, 52]
	strb	w0, [x23]
	ldrh	w25, [x2, 48]
	cbz	w1, .L611
	ldr	w2, [x2, 40]
	adrp	x0, .LANCHOR62
	add	x0, x0, :lo12:.LANCHOR62
	mov	w3, 1
	str	w2, [x0, 324]
	strh	w3, [x0, 320]
	adrp	x0, .LC43
	add	x0, x0, :lo12:.LC43
	bl	printf
	adrp	x1, .LANCHOR67
	adrp	x0, .LC0
	mov	w2, 539
	add	x1, x1, :lo12:.LANCHOR67
	add	x0, x0, :lo12:.LC0
	bl	printf
.L611:
	adrp	x26, .LANCHOR68
	ldrb	w0, [x26, #:lo12:.LANCHOR68]
	cmp	w0, 3
	bne	.L622
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrb	w20, [x0, 89]
	add	w20, w20, w20, lsl 1
	and	w20, w20, 1023
.L612:
	adrp	x0, .LANCHOR14
	adrp	x28, .LANCHOR69
	and	x21, x25, 65535
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L613
	ldr	x1, [x28, #:lo12:.LANCHOR69]
	add	x0, x22, x19, lsl 6
	mov	w3, w25
	ldrb	w2, [x0, 1]
	adrp	x0, .LC44
	ldrb	w4, [x1, x21]
	add	x0, x0, :lo12:.LC44
	mov	w1, w25
	bl	printf
.L613:
	ldr	x1, [x28, #:lo12:.LANCHOR69]
	add	x0, x22, x19, lsl 6
	mov	x27, x21
	ldrb	w0, [x0, 1]
	ldrb	w1, [x1, x21]
	cmp	w1, w0
	beq	.L614
	adrp	x1, .LANCHOR67
	adrp	x0, .LC0
	mov	w2, 546
	add	x1, x1, :lo12:.LANCHOR67
	add	x0, x0, :lo12:.LC0
	bl	printf
.L614:
	add	x19, x22, x19, lsl 6
	ldrb	w0, [x19, 61]
	cmp	w0, 3
	beq	.L615
	ldrb	w0, [x26, #:lo12:.LANCHOR68]
	cmp	w0, 3
	bne	.L615
	adrp	x0, .LANCHOR70
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	cbnz	w0, .L615
	ldr	x1, [x28, #:lo12:.LANCHOR69]
	mov	x0, 0
	add	x21, x1, x21
.L616:
	cmp	w20, w0, uxth
	bls	.L610
	ldrb	w1, [x21, x0]
	add	x0, x0, 1
	add	x1, x22, x1, lsl 6
	strb	wzr, [x1, 61]
	b	.L616
.L622:
	mov	w20, 1
	b	.L612
.L615:
	adrp	x19, .LANCHOR62
	add	x19, x19, :lo12:.LANCHOR62
	add	x20, x21, x20, uxth
	mov	w21, -1
	strh	w25, [x19, 316]
.L617:
	cmp	x20, x27
	beq	.L610
	ldr	x1, [x28, #:lo12:.LANCHOR69]
	ldrb	w0, [x1, x27]
	strb	w21, [x1, x27]
	add	x27, x27, 1
	sbfiz	x1, x0, 6, 32
	ubfiz	x0, x0, 6, 8
	add	x1, x22, x1
	add	x0, x22, x0
	strb	wzr, [x1, 61]
	bl	buf_free
	ldrb	w0, [x19, 7]
	sub	w0, w0, #1
	strb	w0, [x19, 7]
	b	.L617
	.size	gc_write_completed, .-gc_write_completed
	.section	.text.gc_get_src_blk,"ax",@progbits
	.align	2
	.global	gc_get_src_blk
	.type	gc_get_src_blk, %function
gc_get_src_blk:
	adrp	x0, .LANCHOR10
	ldr	x2, [x0, #:lo12:.LANCHOR10]
	adrp	x0, .LANCHOR71
	ldrb	w3, [x0, #:lo12:.LANCHOR71]
	ldrh	w0, [x2, 124]
	cbz	w0, .L634
	add	x1, x2, 392
	mov	w4, 1
.L635:
	add	x5, x1, 128
	mov	w6, 65535
.L639:
	ldrh	w0, [x1]
	cmp	w0, w6
	beq	.L637
	mov	w5, -1
	strh	w5, [x1]
	cbz	w4, .L638
	ldrh	w1, [x2, 124]
	sub	w1, w1, #1
	strh	w1, [x2, 124]
	ret
.L634:
	add	x0, x2, x3, sxtw 1
	ldrh	w0, [x0, 120]
	cbz	w0, .L640
	ubfiz	x1, x3, 7, 8
	mov	w4, 0
	add	x1, x1, 136
	add	x1, x2, x1
	b	.L635
.L638:
	add	x2, x2, x3, uxtb 1
	ldrh	w1, [x2, 120]
	sub	w1, w1, #1
	strh	w1, [x2, 120]
	ret
.L637:
	add	x1, x1, 2
	cmp	x1, x5
	bne	.L639
	ret
.L640:
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
	adrp	x20, .LANCHOR62
	add	x0, x20, :lo12:.LANCHOR62
	stp	x21, x22, [sp, 32]
	ldrb	w1, [x0, 7]
	cbz	w1, .L649
	adrp	x1, .LANCHOR51
	ldrb	w1, [x1, #:lo12:.LANCHOR51]
	cmp	w1, 1
	bhi	.L649
	ldrh	w19, [x0, 316]
	adrp	x2, .LANCHOR73
	adrp	x0, .LANCHOR72
	adrp	x21, .LANCHOR69
	ldrb	w2, [x2, #:lo12:.LANCHOR73]
	add	w1, w19, 24
	ldrh	w0, [x0, #:lo12:.LANCHOR72]
	ldr	x4, [x21, #:lo12:.LANCHOR69]
	mul	w0, w0, w2
	cmp	w0, w1
	csel	w1, w0, w1, ls
	adrp	x0, .LANCHOR49
	add	x0, x0, :lo12:.LANCHOR49
.L644:
	cmp	w19, w1
	bcc	.L647
.L649:
	mov	w0, 0
	b	.L642
.L647:
	uxtw	x22, w19
	ldrb	w2, [x4, x22]
	cmp	w2, 255
	beq	.L645
	sbfiz	x3, x2, 6, 32
	add	x3, x0, x3
	ldrb	w3, [x3, 61]
	cbnz	w3, .L645
	ubfiz	x2, x2, 6, 8
	add	x0, x0, x2
	bl	buf_free
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L646
	ldr	x0, [x21, #:lo12:.LANCHOR69]
	mov	w1, w19
	ldrb	w2, [x0, x22]
	adrp	x0, .LC45
	add	x0, x0, :lo12:.LC45
	bl	printf
.L646:
	ldr	x0, [x21, #:lo12:.LANCHOR69]
	add	x20, x20, :lo12:.LANCHOR62
	mov	w1, -1
	strb	w1, [x0, x22]
	ldrb	w0, [x20, 7]
	sub	w0, w0, #1
	strb	w0, [x20, 7]
	mov	w0, 1
.L642:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L645:
	add	w19, w19, 1
	b	.L644
	.size	gc_free_temp_buf, .-gc_free_temp_buf
	.section	.text.print_gc_debug_info,"ax",@progbits
	.align	2
	.global	print_gc_debug_info
	.type	print_gc_debug_info, %function
print_gc_debug_info:
	adrp	x2, .LANCHOR74
	adrp	x1, .LANCHOR62
	add	x0, x1, :lo12:.LANCHOR62
	ldrh	w6, [x2, #:lo12:.LANCHOR74]
	adrp	x2, .LANCHOR51
	ldrh	w1, [x1, #:lo12:.LANCHOR62]
	ldrb	w5, [x0, 7]
	ldrb	w4, [x2, #:lo12:.LANCHOR51]
	ldrh	w3, [x0, 314]
	ldrh	w2, [x0, 2]
	adrp	x0, .LC46
	add	x0, x0, :lo12:.LC46
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
	bne	.L659
	mov	w1, w0
	adrp	x0, .LANCHOR75
	ldr	x0, [x0, #:lo12:.LANCHOR75]
.L661:
	b	_list_get_gc_head_node.isra.2
.L659:
	cmp	w1, 2
	bne	.L660
	b	zftl_get_gc_node.part.9
.L660:
	mov	w1, w0
	adrp	x0, .LANCHOR76
	ldr	x0, [x0, #:lo12:.LANCHOR76]
	b	.L661
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
	cbz	w19, .L663
	mov	w0, w19
.L662:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L663:
	and	w20, w2, 255
	cbnz	w21, .L665
	adrp	x24, .LANCHOR77
	adrp	x26, .LANCHOR14
	adrp	x27, .LC47
	and	w22, w20, 65535
	add	x26, x26, :lo12:.LANCHOR14
	add	x27, x27, :lo12:.LC47
	strh	wzr, [x24, #:lo12:.LANCHOR77]
	mov	w23, 0
	mov	w25, 0
.L666:
	cmp	w25, w22
	bcs	.L671
	ldrh	w6, [x24, #:lo12:.LANCHOR77]
	add	x7, x24, :lo12:.LANCHOR77
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w2, w6, 1
	and	w2, w2, 65535
	strh	w2, [x24, #:lo12:.LANCHOR77]
	and	w1, w0, 65535
	mov	w0, 65535
	mov	w28, w1
	cmp	w1, w0
	beq	.L667
	ldr	w0, [x26]
	adrp	x6, .LANCHOR9
	uxtw	x4, w1
	tbz	x0, 8, .L668
	ldr	x0, [x6, #:lo12:.LANCHOR9]
	stp	x6, x4, [x29, 96]
	ldrh	w3, [x0, x4, lsl 1]
	mov	x0, x27
	bl	printf
	ldp	x6, x4, [x29, 96]
.L668:
	ldr	x0, [x6, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, x4, lsl 1]
	adrp	x0, .LANCHOR61
	ldrh	w0, [x0, #:lo12:.LANCHOR61]
	cmp	w1, w0
	bcs	.L669
	mov	w2, 0
	mov	w1, 0
	mov	w0, w28
	bl	gc_add_sblk
	cbz	w0, .L670
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w22, w23
	bcs	.L670
.L671:
	ldr	x0, [x29, 112]
	tbz	x0, 1, .L673
	adrp	x25, .LANCHOR79
	adrp	x24, .LANCHOR78
	add	x27, x25, :lo12:.LANCHOR79
	add	x24, x24, :lo12:.LANCHOR78
	mov	w28, 0
	mov	w26, 65535
.L674:
	cmp	w28, w22
	beq	.L678
	ldrh	w6, [x24]
	mov	w1, 5
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x24]
	and	w1, w0, 65535
	cmp	w1, w26
	beq	.L675
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x1]
	ldrh	w1, [x27]
	cmp	w2, w1
	bcs	.L675
	mov	w2, 0
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L677
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w22, w23
	bcs	.L677
.L678:
	cmp	w23, w22
	adrp	x0, .LANCHOR80
	bcs	.L680
	ldrh	w1, [x0, #:lo12:.LANCHOR80]
	adrp	x3, .LANCHOR73
	adrp	x0, .LANCHOR72
	ldrh	w2, [x25, #:lo12:.LANCHOR79]
	ldrb	w3, [x3, #:lo12:.LANCHOR73]
	ldrh	w0, [x0, #:lo12:.LANCHOR72]
	mul	w0, w0, w3
	sub	w0, w0, w1, lsr 2
	cmp	w2, w0
	bge	.L673
	add	w1, w2, w1, lsr 3
	strh	w1, [x25, #:lo12:.LANCHOR79]
.L673:
	ldr	x0, [x29, 112]
	tbz	x0, 0, .L681
	cmp	w23, w22
	bcs	.L681
	adrp	x24, .LANCHOR81
	add	x24, x24, :lo12:.LANCHOR81
	mov	w25, 65535
.L686:
	ldrh	w6, [x24]
	mov	w0, w6
	bl	zftl_get_gc_node.part.9
	add	w6, w6, 1
	strh	w6, [x24]
	cmp	w25, w0, uxth
	beq	.L682
	mov	w2, 0
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L683
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w22, w23
	bhi	.L683
.L684:
	adrp	x0, .LANCHOR80
	adrp	x1, .LANCHOR61
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	ldrh	w2, [x1, #:lo12:.LANCHOR61]
	cmp	w2, w0, lsr 1
	bls	.L681
	sub	w0, w2, w0, lsr 3
	b	.L761
.L669:
	strh	wzr, [x24, #:lo12:.LANCHOR77]
	b	.L671
.L667:
	strh	wzr, [x7]
	b	.L671
.L670:
	add	w25, w25, 1
	and	w25, w25, 65535
	b	.L666
.L675:
	strh	wzr, [x24]
	b	.L678
.L677:
	add	w28, w28, 1
	and	w28, w28, 65535
	b	.L674
.L680:
	ldrh	w1, [x25, #:lo12:.LANCHOR79]
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w1, w0
	bls	.L673
	sub	w0, w1, w0, lsr 3
	strh	w0, [x25, #:lo12:.LANCHOR79]
	b	.L673
.L682:
	strh	wzr, [x24]
.L685:
	cmp	w23, w22
	bcs	.L684
	adrp	x1, .LANCHOR61
	adrp	x0, .LANCHOR80
	ldrh	w2, [x1, #:lo12:.LANCHOR61]
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w2, w0
	bcs	.L681
	add	w0, w2, w0, lsr 3
.L761:
	strh	w0, [x1, #:lo12:.LANCHOR61]
.L681:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L708
	ldr	w2, [x29, 112]
	adrp	x0, .LC48
	mov	w4, w20
	mov	w3, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC48
	bl	printf
.L708:
	mov	w0, w23
	b	.L662
.L683:
	add	w19, w19, 1
	and	w19, w19, 65535
	cmp	w22, w19
	bne	.L686
	b	.L685
.L665:
	adrp	x0, .LANCHOR62+318
	strh	wzr, [x0, #:lo12:.LANCHOR62+318]
	adrp	x0, .LANCHOR82
	strh	wzr, [x0, #:lo12:.LANCHOR82]
	ldr	w0, [x29, 112]
	and	w0, w0, 1
	str	w0, [x29, 104]
	ldr	x0, [x29, 112]
	tbz	x0, 0, .L711
	adrp	x1, .LANCHOR84
	adrp	x25, .LANCHOR83
	str	x1, [x29, 96]
	adrp	x26, .LANCHOR85
	ldrh	w0, [x25, #:lo12:.LANCHOR83]
	ldrh	w2, [x1, #:lo12:.LANCHOR84]
	cmp	w0, w2, lsr 2
	bcc	.L688
	ldrh	w1, [x26, #:lo12:.LANCHOR85]
	cmp	w1, w0
	bls	.L712
.L688:
	ldrh	w0, [x26, #:lo12:.LANCHOR85]
	adrp	x22, .LANCHOR81
	lsr	w0, w0, 2
	strh	w0, [x22, #:lo12:.LANCHOR81]
	mov	w0, 0
	bl	zftl_get_gc_node.part.9
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L714
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x3, [x2, #:lo12:.LANCHOR9]
	adrp	x2, .LANCHOR80
	ldrh	w2, [x2, #:lo12:.LANCHOR80]
	ldrh	w1, [x3, x1]
	cmp	w1, w2, lsr 2
	bcs	.L714
	strh	wzr, [x22, #:lo12:.LANCHOR81]
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cmp	w0, 0
	cset	w23, ne
.L690:
	add	x22, x22, :lo12:.LANCHOR81
	and	w28, w20, 65535
	mov	w24, 64
	mov	w27, 65535
.L692:
	ldrh	w6, [x22]
	mov	w0, w6
	bl	zftl_get_gc_node.part.9
	add	w6, w6, 1
	strh	w6, [x22]
	cmp	w27, w0, uxth
	beq	.L689
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L691
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w23, w28
	bcs	.L689
.L691:
	sub	w24, w24, #1
	ands	w24, w24, 65535
	bne	.L692
.L689:
	ldr	x0, [x29, 96]
	ldrh	w1, [x25, #:lo12:.LANCHOR83]
	ldrh	w0, [x0, #:lo12:.LANCHOR84]
	cmp	w1, w0, lsr 3
	bhi	.L709
	ldrh	w0, [x26, #:lo12:.LANCHOR85]
	add	w0, w0, 8
	cmp	w1, w0
	ble	.L687
.L709:
	adrp	x24, .LANCHOR77
	and	w26, w20, 65535
	mov	w22, 64
	mov	w25, 65535
	strh	wzr, [x24, #:lo12:.LANCHOR77]
	add	x24, x24, :lo12:.LANCHOR77
.L694:
	ldrh	w6, [x24]
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x24]
	cmp	w25, w0, uxth
	beq	.L687
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L693
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w23, w26
	bcs	.L687
.L693:
	sub	w22, w22, #1
	ands	w22, w22, 65535
	bne	.L694
.L687:
	ldr	x0, [x29, 112]
	tbz	x0, 1, .L695
	adrp	x24, .LANCHOR78
	adrp	x28, .LANCHOR86
	adrp	x25, .LANCHOR73
	add	x26, x24, :lo12:.LANCHOR78
	add	x27, x28, :lo12:.LANCHOR86
	add	x25, x25, :lo12:.LANCHOR73
	strh	wzr, [x24, #:lo12:.LANCHOR78]
	mov	w22, 64
.L700:
	ldrh	w6, [x26]
	mov	w1, 5
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x26]
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L696
	cmp	w20, 1
	bne	.L697
	adrp	x3, .LANCHOR72
	ldrb	w2, [x25]
	ldrh	w3, [x3, #:lo12:.LANCHOR72]
	mul	w3, w2, w3
	adrp	x2, .LANCHOR80
	ldrh	w2, [x2, #:lo12:.LANCHOR80]
	sub	w2, w3, w2, lsr 3
	strh	w2, [x27]
.L697:
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x1]
	ldrh	w1, [x27]
	cmp	w2, w1
	bcs	.L698
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L699
	add	w5, w23, 1
	add	w19, w19, 1
	and	w23, w5, 65535
	and	w19, w19, 65535
	cmp	w23, w20
	bcc	.L699
.L696:
	cmp	w23, w20
	adrp	x0, .LANCHOR80
	adrp	x3, .LANCHOR73
	bcc	.L701
	cbnz	w19, .L702
	adrp	x1, .LANCHOR87
	ldrh	w2, [x1, #:lo12:.LANCHOR87]
	adrp	x1, .LANCHOR88
	ldrh	w1, [x1, #:lo12:.LANCHOR88]
	cmp	w2, w1
	bls	.L702
.L701:
	ldrh	w2, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR72
	ldrb	w3, [x3, #:lo12:.LANCHOR73]
	ldrh	w0, [x0, #:lo12:.LANCHOR72]
	ldrh	w1, [x28, #:lo12:.LANCHOR86]
	lsr	w2, w2, 3
	mul	w0, w0, w3
	sub	w0, w0, w2
	cmp	w1, w0
	bge	.L695
	add	w1, w1, w2
	strh	w1, [x28, #:lo12:.LANCHOR86]
.L695:
	ldr	w0, [x29, 104]
	cbz	w0, .L681
	adrp	x25, .LANCHOR77
	adrp	x22, .LANCHOR89
	adrp	x26, .LANCHOR84
	adrp	x27, .LANCHOR83
	add	x28, x22, :lo12:.LANCHOR89
	add	x26, x26, :lo12:.LANCHOR84
	add	x27, x27, :lo12:.LANCHOR83
	strh	wzr, [x25, #:lo12:.LANCHOR77]
	mov	w24, 64
.L706:
	ldrh	w6, [x25, #:lo12:.LANCHOR77]
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x25, #:lo12:.LANCHOR77]
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L703
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w1, [x2, x1]
	ldrh	w2, [x28]
	cmp	w2, w1
	bls	.L704
	cmp	w1, 2
	bls	.L704
	ldrh	w2, [x26]
	ldrh	w1, [x27]
	cmp	w1, w2, lsr 1
	bls	.L703
.L704:
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L705
	add	w5, w23, 1
	and	w23, w5, 65535
	cmp	w23, w20
	bcs	.L703
.L705:
	sub	w24, w24, #1
	ands	w24, w24, 65535
	bne	.L706
.L703:
	cmp	w23, w20
	adrp	x0, .LANCHOR80
	bcs	.L707
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	ldrh	w1, [x22, #:lo12:.LANCHOR89]
	cmp	w1, w0, lsr 1
	bls	.L681
	sub	w0, w1, w0, lsr 3
	strh	w0, [x22, #:lo12:.LANCHOR89]
	b	.L681
.L714:
	mov	w23, 0
	b	.L690
.L711:
	mov	w23, 0
	b	.L687
.L698:
	strh	wzr, [x24, #:lo12:.LANCHOR78]
	b	.L696
.L699:
	sub	w22, w22, #1
	ands	w22, w22, 65535
	bne	.L700
	b	.L696
.L702:
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	ldrb	w1, [x3, #:lo12:.LANCHOR73]
	ldrh	w2, [x28, #:lo12:.LANCHOR86]
	mul	w1, w1, w0
	cmp	w2, w1
	ble	.L695
	sub	w0, w2, w0, lsr 3
	strh	w0, [x28, #:lo12:.LANCHOR86]
	b	.L695
.L707:
	ldrh	w1, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR73
	ldrh	w2, [x22, #:lo12:.LANCHOR89]
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	mul	w0, w0, w1
	sub	w0, w0, #32
	cmp	w2, w0
	bge	.L681
	add	w1, w2, w1, lsr 3
	strh	w1, [x22, #:lo12:.LANCHOR89]
	b	.L681
.L712:
	mov	w23, 0
	b	.L689
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
	bne	.L763
	adrp	x2, .LANCHOR90
	adrp	x0, .LANCHOR91
	add	x2, x2, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR91
.L765:
	b	_insert_free_list
.L763:
	cmp	w0, 16
	bne	.L764
	adrp	x2, .LANCHOR92
	adrp	x0, .LANCHOR93
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR93
	b	.L765
.L764:
	adrp	x2, .LANCHOR94
	adrp	x0, .LANCHOR95
	add	x2, x2, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LANCHOR95
	b	.L765
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
	bne	.L767
	adrp	x2, .LANCHOR85
	adrp	x0, .LANCHOR12
	add	x2, x2, :lo12:.LANCHOR85
	add	x0, x0, :lo12:.LANCHOR12
.L770:
	b	_insert_data_list
.L767:
	cmp	w2, 96
	bne	.L768
	adrp	x2, .LANCHOR83
	adrp	x0, .LANCHOR76
	add	x2, x2, :lo12:.LANCHOR83
	add	x0, x0, :lo12:.LANCHOR76
	b	.L770
.L768:
	cmp	w2, 160
	bne	.L766
	adrp	x2, .LANCHOR87
	adrp	x0, .LANCHOR75
	add	x2, x2, :lo12:.LANCHOR87
	add	x0, x0, :lo12:.LANCHOR75
	b	.L770
.L766:
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
	beq	.L772
	cbnz	w21, .L772
	mov	w1, w19
	adrp	x0, .LC49
	add	x0, x0, :lo12:.LC49
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR10]
	mov	w1, -1
	strh	w1, [x0, 588]
.L773:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L772:
	adrp	x2, .LANCHOR92
	adrp	x20, .LANCHOR94
	ldrh	w0, [x2, #:lo12:.LANCHOR92]
	ldrh	w1, [x20, #:lo12:.LANCHOR94]
	cmp	w0, w1
	bls	.L774
	lsr	w1, w0, 3
	cmp	w21, 0
	adrp	x0, .LANCHOR93
	csel	w1, w1, wzr, ne
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR93
.L788:
	bl	_list_pop_index_node
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	bne	.L779
	adrp	x0, .LANCHOR90
	ldrh	w5, [x20, #:lo12:.LANCHOR94]
	mov	w2, w22
	mov	w1, w19
	ldrh	w4, [x0, #:lo12:.LANCHOR90]
	adrp	x0, .LANCHOR91
	ldr	x3, [x0, #:lo12:.LANCHOR91]
	adrp	x0, .LC50
	add	x0, x0, :lo12:.LC50
	bl	printf
.L779:
	cbz	w21, .L773
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L773
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
	adrp	x0, .LC51
	ubfx	x3, x2, 3, 2
	and	w5, w5, 2047
	ubfx	x2, x2, 5, 3
	add	x0, x0, :lo12:.LC51
	bl	printf
	b	.L773
.L774:
	cbnz	w21, .L777
	lsr	w1, w1, 2
.L778:
	adrp	x0, .LANCHOR95
	add	x2, x20, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LANCHOR95
	b	.L788
.L777:
	mov	w1, 7
	mul	w1, w0, w1
	lsr	w1, w1, 3
	b	.L778
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
	bne	.L790
	adrp	x2, .LANCHOR92
	adrp	x0, .LANCHOR94
	ldrh	w3, [x2, #:lo12:.LANCHOR92]
	ldrh	w1, [x0, #:lo12:.LANCHOR94]
	cmp	w3, w1
	bcc	.L791
	adrp	x4, .LANCHOR90
	ldrh	w4, [x4, #:lo12:.LANCHOR90]
	cmp	w4, w3
	bls	.L792
	cbz	w1, .L792
.L791:
	add	x2, x0, :lo12:.LANCHOR94
	lsr	w1, w1, 1
.L811:
	adrp	x0, .LANCHOR95
	add	x0, x0, :lo12:.LANCHOR95
	b	.L810
.L792:
	adrp	x0, .LANCHOR93
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR93
	mov	w1, 0
.L810:
	bl	_list_pop_index_node
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	bne	.L795
	adrp	x0, .LANCHOR94
	mov	w2, w20
	mov	w1, w19
	ldrh	w5, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR90
	ldrh	w4, [x0, #:lo12:.LANCHOR90]
	adrp	x0, .LANCHOR91
	ldr	x3, [x0, #:lo12:.LANCHOR91]
	adrp	x0, .LC50
	add	x0, x0, :lo12:.LC50
	bl	printf
	b	.L795
.L790:
	adrp	x21, .LANCHOR10
	and	w0, w0, 65535
	ldr	x1, [x21, #:lo12:.LANCHOR10]
	ldrh	w19, [x1, 590]
	mov	w1, 65535
	cmp	w19, w1
	beq	.L794
	cmp	w20, 1
	beq	.L794
	mov	w1, w19
	adrp	x0, .LC52
	add	x0, x0, :lo12:.LC52
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	mov	w1, -1
	strh	w1, [x0, 590]
.L795:
	mov	w0, w19
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L794:
	adrp	x2, .LANCHOR90
	adrp	x4, .LANCHOR94
	ldrh	w1, [x2, #:lo12:.LANCHOR90]
	ldrh	w3, [x4, #:lo12:.LANCHOR94]
	cmp	w1, w3
	bcc	.L796
	adrp	x5, .LANCHOR92
	ldrh	w5, [x5, #:lo12:.LANCHOR92]
	cmp	w5, w1
	bls	.L797
	cbz	w3, .L797
.L796:
	cmp	w20, 1
	lsr	w3, w3, 1
	csel	w0, w3, w0, eq
	add	x2, x4, :lo12:.LANCHOR94
	mov	w1, w0
	b	.L811
.L797:
	lsr	w1, w1, 1
	cmp	w20, 1
	csel	w0, w1, w0, eq
	add	x2, x2, :lo12:.LANCHOR90
	mov	w1, w0
	adrp	x0, .LANCHOR91
	add	x0, x0, :lo12:.LANCHOR91
	b	.L810
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
	bne	.L813
	adrp	x2, .LANCHOR85
	adrp	x0, .LANCHOR12
	add	x2, x2, :lo12:.LANCHOR85
	add	x0, x0, :lo12:.LANCHOR12
.L816:
	b	_list_remove_node
.L813:
	cmp	w2, 96
	bne	.L814
	adrp	x2, .LANCHOR83
	adrp	x0, .LANCHOR76
	add	x2, x2, :lo12:.LANCHOR83
	add	x0, x0, :lo12:.LANCHOR76
	b	.L816
.L814:
	cmp	w2, 160
	bne	.L812
	adrp	x2, .LANCHOR87
	adrp	x0, .LANCHOR75
	add	x2, x2, :lo12:.LANCHOR87
	add	x0, x0, :lo12:.LANCHOR75
	b	.L816
.L812:
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
	bne	.L818
	adrp	x2, .LANCHOR90
	adrp	x0, .LANCHOR91
	add	x2, x2, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LANCHOR91
.L820:
	b	_list_remove_node
.L818:
	cmp	w0, 16
	bne	.L819
	adrp	x2, .LANCHOR92
	adrp	x0, .LANCHOR93
	add	x2, x2, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR93
	b	.L820
.L819:
	adrp	x2, .LANCHOR94
	adrp	x0, .LANCHOR95
	add	x2, x2, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LANCHOR95
	b	.L820
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
	bne	.L822
	adrp	x2, .LANCHOR85
	adrp	x0, .LANCHOR12
	add	x2, x2, :lo12:.LANCHOR85
	add	x0, x0, :lo12:.LANCHOR12
.L825:
	b	_list_update_data_list
.L822:
	cmp	w2, 96
	bne	.L823
	adrp	x2, .LANCHOR83
	adrp	x0, .LANCHOR76
	add	x2, x2, :lo12:.LANCHOR83
	add	x0, x0, :lo12:.LANCHOR76
	b	.L825
.L823:
	cmp	w2, 160
	bne	.L821
	adrp	x2, .LANCHOR87
	adrp	x0, .LANCHOR75
	add	x2, x2, :lo12:.LANCHOR87
	add	x0, x0, :lo12:.LANCHOR75
	b	.L825
.L821:
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
	adrp	x0, .LC53
	stp	x23, x24, [sp, 80]
	add	x0, x0, :lo12:.LC53
	bl	printf
	ldr	x19, [x19]
	cbz	x19, .L826
	mov	x24, -6148914691236517206
	adrp	x22, .LC54
	adrp	x21, .LANCHOR96
	add	x22, x22, :lo12:.LC54
	add	x21, x21, :lo12:.LANCHOR96
	mov	w20, 0
	adrp	x23, .LANCHOR4
	movk	x24, 0xaaab, lsl 0
.L830:
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
	beq	.L826
	ldr	x0, [x23, #:lo12:.LANCHOR4]
	mov	w1, 6
	add	w20, w20, 1
	and	w20, w20, 65535
	umaddl	x19, w19, w1, x0
	ldrh	w0, [x21]
	cmp	w0, w20
	bcs	.L830
.L826:
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
	adrp	x1, .LANCHOR90
	adrp	x0, .LANCHOR91
	add	x1, x1, :lo12:.LANCHOR90
	add	x29, sp, 0
	add	x0, x0, :lo12:.LANCHOR91
	bl	print_list_info
	adrp	x1, .LANCHOR92
	adrp	x0, .LANCHOR93
	add	x1, x1, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LANCHOR93
	bl	print_list_info
	adrp	x1, .LANCHOR94
	adrp	x0, .LANCHOR95
	add	x1, x1, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LANCHOR95
	bl	print_list_info
	adrp	x1, .LANCHOR85
	adrp	x0, .LANCHOR12
	add	x1, x1, :lo12:.LANCHOR85
	add	x0, x0, :lo12:.LANCHOR12
	bl	print_list_info
	adrp	x1, .LANCHOR83
	adrp	x0, .LANCHOR76
	add	x1, x1, :lo12:.LANCHOR83
	add	x0, x0, :lo12:.LANCHOR76
	bl	print_list_info
	ldp	x29, x30, [sp], 16
	adrp	x1, .LANCHOR87
	adrp	x0, .LANCHOR75
	add	x1, x1, :lo12:.LANCHOR87
	add	x0, x0, :lo12:.LANCHOR75
	b	print_list_info
	.size	dump_all_list_info, .-dump_all_list_info
	.section	.text.ftl_tmp_into_update,"ax",@progbits
	.align	2
	.global	ftl_tmp_into_update
	.type	ftl_tmp_into_update, %function
ftl_tmp_into_update:
	adrp	x0, .LANCHOR97
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	ldr	w1, [x0, 16]
	cmp	w1, 2048
	bls	.L835
	ldr	w2, [x0, 20]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 16]
.L835:
	ldr	w1, [x0, 24]
	cmp	w1, 2048
	bls	.L836
	ldr	w2, [x0, 28]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 24]
.L836:
	ldr	w1, [x0, 32]
	cmp	w1, 1024
	bls	.L837
	ldr	w2, [x0, 36]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 32]
.L837:
	ldr	w1, [x0, 40]
	cmp	w1, 1024
	bls	.L834
	ldr	w2, [x0, 44]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 40]
.L834:
	ret
	.size	ftl_tmp_into_update, .-ftl_tmp_into_update
	.section	.text.ftl_get_blk_list_in_sblk,"ax",@progbits
	.align	2
	.global	ftl_get_blk_list_in_sblk
	.type	ftl_get_blk_list_in_sblk, %function
ftl_get_blk_list_in_sblk:
	adrp	x2, .LANCHOR7
	and	w0, w0, 65535
	adrp	x7, .LANCHOR99
	add	x7, x7, :lo12:.LANCHOR99
	ldr	x2, [x2, #:lo12:.LANCHOR7]
	mov	w3, 0
	mov	w13, 21
	add	x2, x2, x0, uxth 2
	ldrb	w12, [x2, 3]
	adrp	x2, .LANCHOR73
	ldrb	w10, [x2, #:lo12:.LANCHOR73]
	adrp	x2, .LANCHOR98
	ldrb	w6, [x2, #:lo12:.LANCHOR98]
	and	w2, w6, 65535
	mul	w0, w0, w2
	sub	w2, w2, #1
	sxth	w5, w2
	and	w4, w0, 65535
	mov	w0, 0
.L840:
	cmp	w3, w10
	blt	.L844
	sxtw	x2, w0
	mov	w3, -1
.L845:
	cmp	w10, w2
	bgt	.L846
	ret
.L844:
	asr	w2, w12, w3
	tbnz	x2, 0, .L841
	sdiv	w2, w3, w6
	ldrh	w8, [x7]
	sbfiz	x11, x0, 1, 32
	cmp	w6, 1
	sub	w8, w13, w8
	lsl	w2, w2, w8
	add	w2, w4, w2
	and	w2, w2, 65535
	bhi	.L842
.L847:
	add	w0, w0, 1
	strh	w2, [x1, x11]
.L841:
	add	w3, w3, 1
	b	.L840
.L842:
	and	w8, w5, w3
	add	w2, w2, w8
	b	.L847
.L846:
	strh	w3, [x1, x2, lsl 1]
	add	x2, x2, 1
	b	.L845
	.size	ftl_get_blk_list_in_sblk, .-ftl_get_blk_list_in_sblk
	.section	.text.ftl_free_sblk,"ax",@progbits
	.align	2
	.global	ftl_free_sblk
	.type	ftl_free_sblk, %function
ftl_free_sblk:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR7
	str	x23, [sp, 48]
	and	x23, x0, 65535
	ldr	x4, [x22, #:lo12:.LANCHOR7]
	lsl	x21, x23, 2
	stp	x19, x20, [sp, 16]
	mov	x19, x23
	add	x20, x4, x21
	ldrb	w0, [x20, 2]
	tbz	x0, 3, .L850
	adrp	x1, .LANCHOR97
	ldrh	w2, [x4, x21]
	adrp	x8, .LANCHOR100
	ldr	x7, [x1, #:lo12:.LANCHOR97]
	and	w3, w2, 2047
	ldr	w2, [x4, x21]
	ldrh	w8, [x8, #:lo12:.LANCHOR100]
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
	ble	.L851
	adrp	x1, .LANCHOR88
	adrp	x7, .LANCHOR92
	ldrh	w5, [x1, #:lo12:.LANCHOR88]
	adrp	x1, .LANCHOR87
	ldrh	w7, [x7, #:lo12:.LANCHOR92]
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	add	w5, w5, 7
	add	w1, w1, w7
	cmp	w5, w1
	blt	.L852
.L867:
	mov	w1, 2
	bfi	w0, w1, 3, 2
.L865:
	strb	w0, [x20, 2]
.L853:
	ldrb	w0, [x20, 2]
	ands	w0, w0, 24
	bne	.L857
	mul	w2, w6, w2
	ldrh	w0, [x4, x21]
	add	w2, w2, w2, lsl 1
	add	w2, w3, w2, lsr 2
	ubfx	x2, x2, 2, 9
	bfi	w0, w2, 0, 11
	strh	w0, [x4, x21]
.L850:
	mov	w0, w19
	bl	zftl_remove_data_node
	ldr	x0, [x22, #:lo12:.LANCHOR7]
	add	x21, x0, x21
	ldrb	w0, [x21, 2]
	and	w0, w0, 31
	strb	w0, [x21, 2]
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x23, lsl 1]
	ldrb	w0, [x20, 2]
	tbz	x0, 3, .L859
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrh	w1, [x0, 584]
	cmp	w1, w19
	bne	.L860
	mov	w1, -1
	ldrh	w2, [x0, 588]
	strh	w1, [x0, 584]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L860
	strh	w19, [x0, 588]
	mov	w1, w19
	adrp	x0, .LC55
	add	x0, x0, :lo12:.LC55
.L866:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	b	printf
.L852:
	adrp	x1, .LANCHOR101
	adrp	x7, .LANCHOR90
	ldrh	w5, [x1, #:lo12:.LANCHOR101]
	adrp	x1, .LANCHOR85
	ldrh	w7, [x7, #:lo12:.LANCHOR90]
	ldrh	w1, [x1, #:lo12:.LANCHOR85]
	add	w5, w5, 7
	add	w1, w1, w7
	adrp	x7, .LANCHOR83
	ldrh	w7, [x7, #:lo12:.LANCHOR83]
	add	w1, w1, w7
	cmp	w5, w1
	blt	.L867
.L856:
	and	w0, w0, -25
	b	.L865
.L851:
	madd	w1, w2, w1, w5
	adrp	x5, .LANCHOR102
	ldrh	w5, [x5, #:lo12:.LANCHOR102]
	cmp	w1, w5
	ble	.L853
	adrp	x1, .LANCHOR101
	adrp	x7, .LANCHOR90
	ldrh	w5, [x1, #:lo12:.LANCHOR101]
	adrp	x1, .LANCHOR85
	ldrh	w7, [x7, #:lo12:.LANCHOR90]
	ldrh	w1, [x1, #:lo12:.LANCHOR85]
	add	w5, w5, 7
	add	w1, w1, w7
	adrp	x7, .LANCHOR83
	ldrh	w7, [x7, #:lo12:.LANCHOR83]
	add	w1, w1, w7
	cmp	w5, w1
	bge	.L856
	adrp	x1, .LANCHOR88
	adrp	x7, .LANCHOR92
	ldrh	w5, [x1, #:lo12:.LANCHOR88]
	adrp	x1, .LANCHOR87
	ldrh	w7, [x7, #:lo12:.LANCHOR92]
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	add	w5, w5, 7
	add	w1, w1, w7
	cmp	w5, w1
	blt	.L856
	b	.L867
.L857:
	cmp	w0, 16
	bne	.L850
	sdiv	w2, w3, w2
	ldr	w0, [x4, x21]
	add	w2, w2, w2, lsl 1
	add	w2, w6, w2, lsr 2
	ubfx	x2, x2, 2, 6
	bfi	w0, w2, 11, 8
	str	w0, [x4, x21]
	b	.L850
.L860:
	ldrh	w1, [x0, 586]
	cmp	w1, w19
	bne	.L859
	mov	w1, -1
	ldrh	w2, [x0, 590]
	strh	w1, [x0, 586]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L859
	strh	w19, [x0, 590]
	mov	w1, w19
	adrp	x0, .LC56
	add	x0, x0, :lo12:.LC56
	b	.L866
.L859:
	mov	w0, w19
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
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
	adrp	x21, .LANCHOR62
	stp	x23, x24, [sp, 48]
	adrp	x22, .LC57
	adrp	x23, .LANCHOR9
	add	x21, x21, :lo12:.LANCHOR62
	mov	x24, x23
	add	x22, x22, :lo12:.LC57
	stp	x19, x20, [sp, 16]
	mov	w20, 0
	stp	x25, x26, [sp, 64]
.L869:
	ldrh	w0, [x21, 56]
	cmp	w0, w20
	bhi	.L883
	strh	wzr, [x21, 56]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L883:
	add	x0, x21, x20, sxtw 1
	ldrh	w25, [x0, 58]
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	mov	x19, x25
	lsl	x26, x25, 1
	ldrh	w2, [x0, x26]
	cbz	w2, .L870
	mov	w1, w25
	mov	x0, x22
	bl	printf
.L870:
	ldr	x0, [x24, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x26]
	adrp	x0, .LANCHOR7
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x25, x0, x25, lsl 2
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L871
	ldrb	w2, [x25, 2]
	adrp	x0, .LC58
	mov	w1, w19
	add	x0, x0, :lo12:.LC58
	ubfx	x2, x2, 5, 3
	bl	printf
.L871:
	ldrb	w0, [x25, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L872
	tst	w0, 192
	bne	.L873
.L872:
	adrp	x1, .LANCHOR103
	adrp	x0, .LC0
	mov	w2, 793
	add	x1, x1, :lo12:.LANCHOR103
	add	x0, x0, :lo12:.LC0
	bl	printf
.L873:
	mov	w0, w19
	bl	ftl_free_sblk
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrh	w2, [x0, 124]
	cbz	w2, .L874
	add	x3, x0, 392
	mov	w1, 0
.L876:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L875
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 392]
	strh	w2, [x0, 124]
.L874:
	ldrh	w2, [x0, 120]
	cbz	w2, .L877
	add	x3, x0, 136
	mov	w1, 0
.L879:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L878
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 136]
	strh	w2, [x0, 120]
.L877:
	ldrh	w2, [x0, 122]
	cbz	w2, .L880
	add	x3, x0, 264
	mov	w1, 0
.L882:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L881
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 264]
	strh	w2, [x0, 122]
.L880:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L869
.L875:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L876
	b	.L874
.L878:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L879
	b	.L877
.L881:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L882
	b	.L880
	.size	gc_free_src_blk, .-gc_free_src_blk
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
	adrp	x1, .LANCHOR99
	stp	x19, x20, [sp, 16]
	mov	w19, 21
	adrp	x22, .LANCHOR105
	ldrh	w1, [x1, #:lo12:.LANCHOR99]
	sub	w1, w19, w1
	mov	w19, 1
	lsl	w19, w19, w1
	sub	w19, w19, #1
	and	w19, w19, w0
	asr	w20, w0, w1
	adrp	x0, .LANCHOR104
	sxth	w19, w19
	ldrb	w0, [x0, #:lo12:.LANCHOR104]
	cbz	w0, .L907
	ldrh	w2, [x22, #:lo12:.LANCHOR105]
	cmp	w21, 0
	cset	w1, eq
	mov	w0, w20
	mul	w2, w2, w19
	bl	flash_erase_block_en
.L907:
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
	adrp	x24, .LANCHOR98
	mov	w20, w1
	add	x25, x25, :lo12:.LANCHOR106
	ldrb	w28, [x0, 3]
	add	x24, x24, :lo12:.LANCHOR98
	add	x27, x29, 112
	mov	w19, 0
.L913:
	ldrb	w0, [x25]
	cmp	w19, w0
	bge	.L924
	ldrb	w1, [x24]
	adrp	x0, .LANCHOR105
	mov	w21, 0
	ldrh	w3, [x0, #:lo12:.LANCHOR105]
	sub	w4, w1, #1
	mov	w0, 0
	mul	w6, w19, w1
	mul	w5, w26, w1
	b	.L925
.L915:
	add	w2, w0, w6
	asr	w2, w28, w2
	tbnz	x2, 0, .L914
	and	w2, w0, w4
	add	w2, w2, w5
	mul	w2, w2, w3
	str	w2, [x27, w21, sxtw 2]
	add	w21, w21, 1
.L914:
	add	w0, w0, 1
.L925:
	cmp	w0, w1
	blt	.L915
	cmp	w1, 4
	bne	.L916
	mov	x3, 0
.L917:
	cmp	w21, w3
	bgt	.L918
.L919:
	add	w19, w19, 1
	b	.L913
.L918:
	ldr	w2, [x27, x3, lsl 2]
	mov	w1, w20
	str	x3, [x29, 104]
	mov	w0, w19
	bl	flash_erase_block_en
	ldr	x3, [x29, 104]
	add	x3, x3, 1
	b	.L917
.L916:
	cmp	w21, 2
	bne	.L920
	adrp	x0, .LANCHOR104
	ldrb	w0, [x0, #:lo12:.LANCHOR104]
	cbz	w0, .L921
	ldp	w2, w3, [x29, 112]
	cmp	w20, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_duplane_block
.L921:
	ldp	w2, w3, [x29, 112]
	mov	w1, w20
	mov	w0, w19
	bl	flash_erase_duplane_block
	b	.L919
.L920:
	cmp	w21, 1
	bne	.L919
	adrp	x0, .LANCHOR104
	ldrb	w0, [x0, #:lo12:.LANCHOR104]
	cbz	w0, .L923
	ldr	w2, [x29, 112]
	cmp	w20, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_block_en
.L923:
	ldr	w2, [x29, 112]
	mov	w1, w20
	mov	w0, w19
	bl	flash_erase_block_en
	b	.L919
.L924:
	adrp	x2, .LANCHOR97
	ldr	x3, [x23, #:lo12:.LANCHOR7]
	cbnz	w20, .L926
	ldrh	w1, [x3, x22]
	add	w0, w1, 1
	and	w0, w0, 2047
	bfi	w1, w0, 0, 11
	strh	w1, [x3, x22]
	ldr	x1, [x2, #:lo12:.LANCHOR97]
	ldr	w2, [x1, 84]
	add	w2, w2, 1
	str	w2, [x1, 84]
	ldrh	w2, [x1, 96]
	cmp	w2, w0
	bge	.L928
	strh	w0, [x1, 96]
.L928:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L926:
	ldr	w1, [x3, x22]
	ubfx	x0, x1, 11, 8
	add	w0, w0, 1
	and	w0, w0, 255
	bfi	w1, w0, 11, 8
	str	w1, [x3, x22]
	and	w0, w0, 65535
	ldr	x1, [x2, #:lo12:.LANCHOR97]
	ldr	w2, [x1, 80]
	add	w2, w2, 1
	str	w2, [x1, 80]
	ldrh	w2, [x1, 98]
	cmp	w2, w0
	bcs	.L928
	strh	w0, [x1, 98]
	b	.L928
	.size	ftl_erase_sblk, .-ftl_erase_sblk
	.section	.text.ftl_alloc_sys_blk,"ax",@progbits
	.align	2
	.global	ftl_alloc_sys_blk
	.type	ftl_alloc_sys_blk, %function
ftl_alloc_sys_blk:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR97
	add	x29, sp, 0
	ldr	x1, [x0, #:lo12:.LANCHOR97]
	ldrh	w2, [x1, 136]
	str	x19, [sp, 16]
	mov	x19, x0
	cmp	w2, 63
	bls	.L938
	strh	wzr, [x1, 136]
.L938:
	ldrh	w0, [x1, 112]
	cbnz	w0, .L939
	adrp	x1, .LANCHOR107
	adrp	x0, .LC0
	mov	w2, 1118
	add	x1, x1, :lo12:.LANCHOR107
	add	x0, x0, :lo12:.LC0
	bl	printf
.L939:
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	mov	w5, 65535
.L942:
	ldrh	w2, [x1, 136]
.L940:
	mov	w3, w2
	cmp	w2, 63
	ble	.L941
	strh	wzr, [x1, 136]
	b	.L942
.L941:
	add	x4, x2, 1
	add	x0, x1, x4, lsl 1
	ldrh	w0, [x0, 158]
	cmp	w0, w5
	bne	.L945
	mov	x2, x4
	b	.L940
.L945:
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
	adrp	x0, .LANCHOR97
	mov	x19, x0
	ldr	x1, [x0, #:lo12:.LANCHOR97]
	ldrh	w2, [x1, 138]
	cmp	w2, 63
	bls	.L948
	strh	wzr, [x1, 138]
.L948:
	ldrh	w0, [x1, 112]
	cmp	w0, 63
	bls	.L949
	adrp	x1, .LANCHOR108
	adrp	x0, .LC0
	mov	w2, 1142
	add	x1, x1, :lo12:.LANCHOR108
	add	x0, x0, :lo12:.LC0
	bl	printf
.L949:
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	mov	w4, 65535
.L952:
	ldrh	w1, [x0, 138]
.L950:
	mov	w2, w1
	cmp	w1, 63
	ble	.L951
	strh	wzr, [x0, 138]
	b	.L952
.L951:
	add	x3, x1, 1
	add	x5, x0, x3, lsl 1
	ldrh	w5, [x5, 158]
	cmp	w5, w4
	bne	.L953
	add	x2, x0, x2, sxtw 1
	strh	w20, [x2, 160]
	strh	w1, [x0, 138]
	ldrh	w1, [x0, 112]
	ldp	x19, x20, [sp, 16]
	add	w1, w1, 1
	strh	w1, [x0, 112]
	ldp	x29, x30, [sp], 32
	ret
.L953:
	mov	x1, x3
	b	.L950
	.size	ftl_free_sys_blk, .-ftl_free_sys_blk
	.section	.text.ftl_info_data_recovery,"ax",@progbits
	.align	2
	.global	ftl_info_data_recovery
	.type	ftl_info_data_recovery, %function
ftl_info_data_recovery:
	ldrh	w2, [x0]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L966
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
	bne	.L956
	ldrb	w0, [x0, 4]
	bfi	w1, w0, 5, 3
	strb	w1, [x21, 2]
	mov	w0, w2
	bl	zftl_remove_free_node
	ldrb	w0, [x21, 2]
	adrp	x1, .LANCHOR97
	ldr	x3, [x1, #:lo12:.LANCHOR97]
	tbz	x0, 3, .L960
	ldrh	w2, [x3, 116]
	sub	w2, w2, #1
	strh	w2, [x3, 116]
.L961:
	and	w0, w0, 224
	cmp	w0, 160
	bne	.L963
	ldr	w0, [x20, x19]
	ldr	x1, [x1, #:lo12:.LANCHOR97]
	ubfx	x2, x0, 11, 8
	add	w2, w2, 1
	bfi	w0, w2, 11, 8
	str	w0, [x20, x19]
	ldrh	w0, [x1, 120]
	sub	w0, w0, #1
	strh	w0, [x1, 120]
.L956:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L960:
	tst	w0, 24
	bne	.L962
	ldrh	w2, [x3, 114]
	sub	w2, w2, #1
	strh	w2, [x3, 114]
	b	.L961
.L962:
	ldrh	w2, [x3, 118]
	sub	w2, w2, #1
	strh	w2, [x3, 118]
	b	.L961
.L963:
	ldrh	w2, [x20, x19]
	cmp	w0, 64
	add	w3, w2, 1
	bfi	w2, w3, 0, 11
	strh	w2, [x20, x19]
	bne	.L964
	ldr	x1, [x1, #:lo12:.LANCHOR97]
	ldrh	w0, [x1, 122]
	sub	w0, w0, #1
	strh	w0, [x1, 122]
	b	.L956
.L964:
	cmp	w0, 96
	bne	.L956
	ldr	x1, [x1, #:lo12:.LANCHOR97]
	ldrh	w0, [x1, 124]
	sub	w0, w0, #1
	strh	w0, [x1, 124]
	b	.L956
.L966:
	ret
	.size	ftl_info_data_recovery, .-ftl_info_data_recovery
	.section	.text.ftl_get_ppa_from_index,"ax",@progbits
	.align	2
	.global	ftl_get_ppa_from_index
	.type	ftl_get_ppa_from_index, %function
ftl_get_ppa_from_index:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR10
	adrp	x3, .LANCHOR73
	and	w0, w0, 65535
	add	x29, sp, 0
	ldr	x2, [x1, #:lo12:.LANCHOR10]
	adrp	x1, .LANCHOR80
	ldrb	w3, [x3, #:lo12:.LANCHOR73]
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	stp	x19, x20, [sp, 16]
	mul	w1, w1, w3
	cmp	w0, w1
	bge	.L970
	add	x2, x2, 16
.L971:
	ldrb	w1, [x2, 9]
	sdiv	w19, w0, w1
	msub	w0, w19, w1, w0
	add	x0, x2, x0, uxth 1
	ldrh	w20, [x0, 16]
	mov	w0, 65535
	cmp	w20, w0
	bne	.L972
	adrp	x1, .LANCHOR109
	adrp	x0, .LC0
	mov	w2, 1529
	add	x1, x1, :lo12:.LANCHOR109
	add	x0, x0, :lo12:.LC0
	bl	printf
.L972:
	adrp	x0, .LANCHOR105
	ldrh	w0, [x0, #:lo12:.LANCHOR105]
	madd	w0, w0, w20, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L970:
	sub	w0, w0, w1
	add	x2, x2, 48
	and	w0, w0, 65535
	b	.L971
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
.L975:
	cmp	w1, w3
	bne	.L977
	mov	w0, -1
	ret
.L977:
	uxtw	x2, w1
	ldr	w6, [x4, x2, lsl 2]
	cmp	w0, w6
	bne	.L976
	mov	w0, w1
	b	ftl_get_ppa_from_index
.L976:
	ldrh	w1, [x5, x2, lsl 1]
	b	.L975
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
	bne	.L979
	adrp	x1, .LANCHOR113
	adrp	x0, .LC0
	mov	w2, 1644
	add	x1, x1, :lo12:.LANCHOR113
	add	x0, x0, :lo12:.LC0
	bl	printf
.L979:
	adrp	x0, .LANCHOR80
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w1, w0
	bne	.L980
	adrp	x1, .LANCHOR113
	adrp	x0, .LC0
	mov	w2, 1645
	add	x1, x1, :lo12:.LANCHOR113
	add	x0, x0, :lo12:.LC0
	bl	printf
.L980:
	ldrh	w0, [x19, 6]
	cbnz	w0, .L981
	adrp	x1, .LANCHOR113
	adrp	x0, .LC0
	mov	w2, 1646
	add	x1, x1, :lo12:.LANCHOR113
	add	x0, x0, :lo12:.LC0
	bl	printf
.L981:
	ldrb	w0, [x19, 5]
	mov	w2, 65535
	add	x0, x0, 8
	ldrh	w3, [x19, x0, lsl 1]
	adrp	x0, .LANCHOR73
	ldrb	w4, [x0, #:lo12:.LANCHOR73]
.L982:
	cmp	w3, w2
	ldrb	w1, [x19, 5]
	beq	.L984
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
	bne	.L978
	add	w2, w2, 1
	strb	wzr, [x19, 5]
	strh	w2, [x19, 2]
.L978:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L984:
	add	w1, w1, 1
	and	w1, w1, 255
	strb	w1, [x19, 5]
	cmp	w1, w4
	bne	.L983
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 5]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L983:
	ldrb	w0, [x19, 5]
	add	x0, x0, 8
	ldrh	w3, [x19, x0, lsl 1]
	b	.L982
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
	bcs	.L988
	adrp	x1, .LANCHOR114
	adrp	x0, .LC0
	mov	w2, 1677
	add	x1, x1, :lo12:.LANCHOR114
	add	x0, x0, :lo12:.LC0
	bl	printf
.L988:
	adrp	x20, .LANCHOR97
	mov	w1, 0
	mov	w0, w19
	bl	ftl_erase_phy_blk
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	ldrh	w0, [x0, 130]
	bl	ftl_free_sys_blk
	ldr	x0, [x20, #:lo12:.LANCHOR97]
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
	bhi	.L991
	cbnz	w0, .L991
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR115]
	ret
.L991:
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
.L993:
	cmp	w5, w1, uxth
	bhi	.L996
	adrp	x1, .LANCHOR10
	ldr	x1, [x1, #:lo12:.LANCHOR10]
	str	w2, [x1, 524]
	adrp	x2, .LANCHOR97
	str	w0, [x1, 528]
	ldr	x2, [x2, #:lo12:.LANCHOR97]
	ldrh	w2, [x2, 120]
	cbz	w2, .L990
	udiv	w0, w0, w2
	str	w0, [x1, 532]
.L990:
	ret
.L996:
	ldrh	w3, [x6, x1, lsl 1]
	cmp	w3, w8
	beq	.L994
	add	x4, x7, x1, lsl 2
	ldrb	w4, [x4, 2]
	and	w4, w4, 224
	cmp	w4, 160
	bne	.L995
	add	w0, w0, w3
.L994:
	add	x1, x1, 1
	b	.L993
.L995:
	add	w2, w2, w3
	b	.L994
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
	cbnz	w0, .L1004
	adrp	x1, .LANCHOR116
	mov	w0, 1
	str	w0, [x1, #:lo12:.LANCHOR116]
.L1002:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1004:
	mov	w0, 0
	b	.L1002
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
	beq	.L1007
	adrp	x0, .LANCHOR9
	ubfiz	x1, x19, 1, 16
	ldr	x2, [x0, #:lo12:.LANCHOR9]
	ldrh	w0, [x2, x1]
	cbnz	w0, .L1008
	adrp	x0, .LC59
	mov	w2, 0
	mov	w1, w19
	add	x0, x0, :lo12:.LC59
	bl	printf
.L1013:
	mov	w0, 0
	b	.L1006
.L1008:
	sub	w0, w0, #1
	strh	w0, [x2, x1]
.L1007:
	adrp	x20, .LANCHOR63
	ldrh	w0, [x20, #:lo12:.LANCHOR63]
	cmp	w19, w0
	beq	.L1013
	mov	w1, 65535
	cmp	w0, w1
	bne	.L1010
	strh	w19, [x20, #:lo12:.LANCHOR63]
	b	.L1013
.L1010:
	bl	ftl_vpn_update
	cmp	w0, 0
	adrp	x1, .LANCHOR117
	cset	w0, ne
	ldrh	w3, [x20, #:lo12:.LANCHOR63]
	ldrh	w2, [x1, #:lo12:.LANCHOR117]
	strh	w19, [x20, #:lo12:.LANCHOR63]
	add	w2, w2, 1
	and	w2, w2, 65535
	cmp	w2, 7
	csel	w2, w2, wzr, ls
	strh	w2, [x1, #:lo12:.LANCHOR117]
	and	x2, x2, 65535
	adrp	x1, .LANCHOR64
	add	x1, x1, :lo12:.LANCHOR64
	strh	w3, [x1, x2, lsl 1]
.L1006:
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
.L1016:
	cmp	w6, w12
	beq	.L1020
	uxtw	x11, w6
	lsl	x10, x11, 2
	add	x13, x8, x10
	ldr	w10, [x8, x10]
	cmp	w0, w10
	lsl	x10, x11, 1
	bne	.L1017
	mov	w6, -1
	str	w6, [x13]
	cmp	w7, w12
	bne	.L1018
	add	x6, x3, :lo12:.LANCHOR110
	ldrh	w7, [x4, x10]
	strh	w7, [x6, x5, lsl 1]
.L1019:
	mov	w6, -1
	strh	w6, [x4, x11, lsl 1]
.L1020:
	uxtw	x6, w2
	add	x3, x3, :lo12:.LANCHOR110
	cmn	w1, #1
	str	w0, [x8, x6, lsl 2]
	ldrh	w0, [x3, x5, lsl 1]
	strh	w2, [x3, x5, lsl 1]
	strh	w0, [x4, x6, lsl 1]
	beq	.L1027
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LANCHOR99
	add	x29, sp, 0
	ldrh	w3, [x0, #:lo12:.LANCHOR99]
	mov	w0, 21
	sub	w2, w0, w3
	mov	w0, 1
	lsr	w1, w1, w3
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w1, w0, w1
	adrp	x0, .LANCHOR98
	ldrb	w0, [x0, #:lo12:.LANCHOR98]
	udiv	w0, w1, w0
	bl	ftl_vpn_decrement
	mov	w0, -1
	ldp	x29, x30, [sp], 16
	ret
.L1018:
	ldrh	w6, [x4, x10]
	strh	w6, [x4, w7, uxtw 1]
	b	.L1019
.L1017:
	mov	w7, w6
	ldrh	w6, [x4, x10]
	b	.L1016
.L1027:
	mov	w0, -1
	ret
	.size	lpa_hash_update_ppa, .-lpa_hash_update_ppa
	.section	.text.ftl_mask_bad_block,"ax",@progbits
	.align	2
	.global	ftl_mask_bad_block
	.type	ftl_mask_bad_block, %function
ftl_mask_bad_block:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR99
	mov	w2, 21
	add	x29, sp, 0
	ldrh	w3, [x1, #:lo12:.LANCHOR99]
	stp	x19, x20, [sp, 16]
	ubfx	x20, x0, 21, 3
	sub	w1, w2, w3
	mov	w2, 1
	lsr	w0, w0, w3
	lsl	w2, w2, w1
	sub	w2, w2, #1
	and	w2, w2, w0
	adrp	x0, .LANCHOR98
	ldrb	w0, [x0, #:lo12:.LANCHOR98]
	udiv	w2, w2, w0
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	and	w19, w2, 65535
	tbz	x0, 14, .L1031
	adrp	x0, .LC60
	mov	w2, w19
	mov	w1, w20
	add	x0, x0, :lo12:.LC60
	bl	printf
.L1031:
	adrp	x0, .LANCHOR6
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w0, w19
	bls	.L1030
	adrp	x0, .LANCHOR7
	mov	w1, 1
	lsl	w1, w1, w20
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x19, x0, x19, uxth 2
	ldrb	w0, [x19, 3]
	orr	w1, w1, w0
	strb	w1, [x19, 3]
.L1030:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	ftl_mask_bad_block, .-ftl_mask_bad_block
	.section	.text.print_ftl_debug_info,"ax",@progbits
	.align	2
	.global	print_ftl_debug_info
	.type	print_ftl_debug_info, %function
print_ftl_debug_info:
	sub	sp, sp, #64
	adrp	x1, .LANCHOR87
	adrp	x0, .LANCHOR10
	adrp	x7, .LANCHOR118
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	ldrh	w6, [x1, #:lo12:.LANCHOR87]
	adrp	x1, .LANCHOR83
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldr	w7, [x7, #:lo12:.LANCHOR118]
	ldrh	w5, [x1, #:lo12:.LANCHOR83]
	adrp	x1, .LANCHOR85
	str	w7, [sp, 8]
	ldrh	w4, [x1, #:lo12:.LANCHOR85]
	adrp	x1, .LANCHOR94
	ldr	w7, [x0, 528]
	ldrh	w3, [x1, #:lo12:.LANCHOR94]
	adrp	x1, .LANCHOR92
	str	w7, [sp]
	ldrh	w2, [x1, #:lo12:.LANCHOR92]
	adrp	x1, .LANCHOR90
	ldr	w7, [x0, 524]
	adrp	x0, .LC61
	ldrh	w1, [x1, #:lo12:.LANCHOR90]
	add	x0, x0, :lo12:.LC61
	str	x19, [sp, 48]
	adrp	x19, .LANCHOR97
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	adrp	x1, .LANCHOR119
	ldrb	w3, [x1, #:lo12:.LANCHOR119]
	ldr	w4, [x0, 8]
	ldr	w5, [x0, 64]
	ldr	w1, [x0, 20]
	ldr	w2, [x0, 28]
	adrp	x0, .LC62
	add	x0, x0, :lo12:.LC62
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	ldr	w1, [x0, 52]
	ldr	w2, [x0, 60]
	ldr	w3, [x0, 16]
	adrp	x0, .LC63
	add	x0, x0, :lo12:.LC63
	lsr	w3, w3, 11
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR97]
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
	adrp	x0, .LC64
	add	x0, x0, :lo12:.LC64
	bl	printf
	ldr	x19, [sp, 48]
	adrp	x0, .LANCHOR74
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 64
	ldrh	w5, [x0, #:lo12:.LANCHOR74]
	adrp	x0, .LANCHOR79
	ldrh	w4, [x0, #:lo12:.LANCHOR79]
	adrp	x0, .LANCHOR61
	ldrh	w3, [x0, #:lo12:.LANCHOR61]
	adrp	x0, .LANCHOR89
	ldrh	w2, [x0, #:lo12:.LANCHOR89]
	adrp	x0, .LANCHOR86
	ldrh	w1, [x0, #:lo12:.LANCHOR86]
	adrp	x0, .LC65
	add	x0, x0, :lo12:.LC65
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
	cbnz	x0, .L1040
	adrp	x1, .LANCHOR120
	add	x1, x1, :lo12:.LANCHOR120
	mov	w2, 661
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	bl	print_ftl_debug_info
	mov	w0, -1
.L1039:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L1043:
	mov	x1, x19
	adrp	x0, .LANCHOR56
	add	x0, x0, :lo12:.LANCHOR56
	bl	buf_add_tail
	adrp	x1, .LANCHOR97
	ldrb	w3, [x19, 56]
	ldrb	w0, [x21, #:lo12:.LANCHOR57]
	ldr	x1, [x1, #:lo12:.LANCHOR97]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x21, #:lo12:.LANCHOR57]
	ldr	w2, [x1, 16]
	add	w2, w2, w3
	str	w2, [x1, 16]
	ldr	w2, [x1, 32]
	add	w2, w2, 1
	str	w2, [x1, 32]
	b	.L1039
.L1040:
	mov	x19, x0
	adrp	x0, .LANCHOR121
	mov	x20, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR121]
	ldrb	w2, [x19, 56]
	cmp	w2, w1
	bls	.L1045
	adrp	x1, .LANCHOR120
	adrp	x0, .LC0
	mov	w2, 666
	add	x1, x1, :lo12:.LANCHOR120
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1045:
	ldrb	w0, [x19, 56]
	adrp	x21, .LANCHOR57
	cbz	w0, .L1042
	ldrb	w1, [x20, #:lo12:.LANCHOR121]
	cmp	w1, w0
	bcs	.L1043
.L1042:
	mov	x0, x19
	bl	buf_free
	ldrb	w0, [x21, #:lo12:.LANCHOR57]
	b	.L1039
	.size	ftl_write_buf, .-ftl_write_buf
	.section	.text.ftl_write_completed,"ax",@progbits
	.align	2
	.global	ftl_write_completed
	.type	ftl_write_completed, %function
ftl_write_completed:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR122
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR49
	adrp	x22, .LANCHOR99
	add	x20, x20, :lo12:.LANCHOR122
	add	x19, x19, :lo12:.LANCHOR49
	add	x22, x22, :lo12:.LANCHOR99
	stp	x23, x24, [sp, 48]
	str	x25, [sp, 64]
.L1051:
	ldrb	w0, [x20]
	cmp	w0, 255
	bne	.L1057
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1057:
	ubfiz	x21, x0, 6, 8
	sbfiz	x0, x0, 6, 32
	add	x23, x19, x0
	add	x21, x19, x21
	ldrb	w0, [x19, x0]
	strb	w0, [x20]
	ldr	w0, [x23, 52]
	cmn	w0, #1
	bne	.L1052
	ldp	w2, w3, [x23, 36]
	mov	w1, 21
	ldrh	w0, [x22]
	mov	w25, 1
	sub	w1, w1, w0
	lsr	w0, w3, w0
	lsl	w1, w25, w1
	sub	w1, w1, #1
	and	w1, w1, w0
	adrp	x0, .LANCHOR98
	ldrb	w0, [x0, #:lo12:.LANCHOR98]
	udiv	w1, w1, w0
	adrp	x0, .LC66
	add	x0, x0, :lo12:.LC66
	and	w24, w1, 65535
	mov	w1, w24
	bl	printf
	mov	w1, w25
	mov	w2, 0
	mov	w0, w24
	bl	gc_add_sblk
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldr	w1, [x0, 556]
	add	w1, w1, w25
	str	w1, [x0, 556]
	ldrh	w1, [x0, 16]
	cmp	w1, w24
	bne	.L1053
	strh	wzr, [x0, 22]
.L1054:
	mov	x0, x21
	bl	ftl_write_buf
	b	.L1051
.L1053:
	ldrh	w1, [x0, 48]
	cmp	w1, w24
	bne	.L1054
	strh	wzr, [x0, 54]
	b	.L1054
.L1052:
	ldrh	w2, [x23, 48]
	ldr	w0, [x23, 36]
	ldr	w1, [x23, 44]
	bl	lpa_hash_update_ppa
	ldrb	w0, [x23, 2]
	tbz	x0, 2, .L1056
	and	w0, w0, -3
	strb	w0, [x23, 2]
	b	.L1051
.L1056:
	mov	x0, x21
	bl	buf_free
	b	.L1051
	.size	ftl_write_completed, .-ftl_write_completed
	.section	.text.zftl_add_read_buf,"ax",@progbits
	.align	2
	.global	zftl_add_read_buf
	.type	zftl_add_read_buf, %function
zftl_add_read_buf:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	cbnz	x0, .L1060
	mov	w2, 948
	adrp	x1, .LANCHOR123
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR123
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	print_ftl_debug_info
.L1060:
	ldrb	w1, [x0, 56]
	mov	x19, x0
	adrp	x0, .LANCHOR121
	ldrb	w0, [x0, #:lo12:.LANCHOR121]
	cmp	w1, w0
	bls	.L1062
	adrp	x1, .LANCHOR123
	adrp	x0, .LC0
	mov	w2, 953
	add	x1, x1, :lo12:.LANCHOR123
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1062:
	mov	x1, x19
	adrp	x0, .LANCHOR124
	add	x0, x0, :lo12:.LANCHOR124
	bl	buf_add_tail
	adrp	x1, .LANCHOR125
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ldrb	w0, [x1, #:lo12:.LANCHOR125]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR125]
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
	beq	.L1067
	adrp	x0, .LANCHOR7
	lsl	w22, w22, 1
	ldr	x21, [x0, #:lo12:.LANCHOR7]
	add	x21, x21, x19, uxth 2
	ldrb	w0, [x21, 2]
	tst	w0, 224
	beq	.L1068
	adrp	x1, .LANCHOR126
	adrp	x0, .LC0
	mov	w2, 827
	add	x1, x1, :lo12:.LANCHOR126
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1068:
	ldrb	w0, [x21, 2]
	bfi	w0, w20, 5, 3
	ubfx	x1, x0, 3, 2
	orr	w22, w22, w1
	bfi	w0, w22, 3, 2
	strb	w0, [x21, 2]
.L1069:
	mov	w0, w19
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1067:
	bl	print_ftl_debug_info
	adrp	x21, .LC67
	mov	w2, w20
	add	x21, x21, :lo12:.LC67
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
	mov	w2, 837
	adrp	x1, .LANCHOR126
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR126
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L1069
	.size	ftl_alloc_sblk, .-ftl_alloc_sblk
	.section	.text.sblk_init,"ax",@progbits
	.align	2
	.global	sblk_init
	.type	sblk_init, %function
sblk_init:
	adrp	x1, .LANCHOR53
	mov	w0, -1
	strb	w0, [x1, #:lo12:.LANCHOR53]
	adrp	x1, .LANCHOR122
	strb	w0, [x1, #:lo12:.LANCHOR122]
	adrp	x1, .LANCHOR127
	strb	w0, [x1, #:lo12:.LANCHOR127]
	adrp	x1, .LANCHOR66
	strb	w0, [x1, #:lo12:.LANCHOR66]
	mov	w0, 0
	ret
	.size	sblk_init, .-sblk_init
	.section	.text.dump_sblk_queue,"ax",@progbits
	.align	2
	.global	dump_sblk_queue
	.type	dump_sblk_queue, %function
dump_sblk_queue:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LC68
	add	x0, x0, :lo12:.LC68
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR53
	str	x21, [sp, 32]
	ldrb	w1, [x19, #:lo12:.LANCHOR53]
	bl	printf
	ldrb	w19, [x19, #:lo12:.LANCHOR53]
	cmp	w19, 255
	beq	.L1076
	adrp	x1, .LANCHOR49
	ubfiz	x19, x19, 6, 8
	add	x1, x1, :lo12:.LANCHOR49
	adrp	x21, .LC69
	add	x19, x1, x19
	add	x21, x21, :lo12:.LC69
	mov	x20, x1
.L1078:
	ldrb	w2, [x19, 58]
	mov	x0, x21
	ldrb	w1, [x19, 1]
	ldr	w3, [x19, 40]
	bl	printf
	ldrb	w19, [x19]
	cmp	w19, 255
	beq	.L1076
	ubfiz	x19, x19, 6, 8
	add	x19, x20, x19
	b	.L1078
.L1076:
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
	adrp	x2, .LANCHOR53
	ldrb	w2, [x2, #:lo12:.LANCHOR53]
	cmp	w2, 255
	beq	.L1094
	adrp	x3, .LANCHOR99
	adrp	x7, .LANCHOR49
	add	x7, x7, :lo12:.LANCHOR49
	adrp	x10, .L1090
	ldrh	w8, [x3, #:lo12:.LANCHOR99]
	mov	w3, 21
	ubfx	x11, x0, 21, 3
	add	x10, x10, :lo12:.L1090
	sub	w4, w3, w8
	mov	w3, 1
	mov	x12, x7
	lsl	w3, w3, w4
	adrp	x4, .LANCHOR98
	sub	w3, w3, #1
	ldrb	w6, [x4, #:lo12:.LANCHOR98]
	and	w3, w3, 65535
	asr	w4, w0, w8
	sub	w6, w6, #1
	and	w6, w6, 65535
	and	w4, w4, w6
	and	w4, w4, w3
.L1093:
	add	x0, x7, x2, lsl 6
	ldr	w5, [x0, 40]
	ubfx	x13, x5, 21, 3
	cmp	w11, w13
	bne	.L1088
	lsr	w5, w5, w8
	and	w5, w6, w5
	and	w5, w3, w5
	ldrb	w0, [x0, 58]
	cmp	w4, w5
	bne	.L1089
	cmp	w1, 1
	bne	.L1086
	cmp	w0, 6
	ccmp	w0, 8, 4, ne
	beq	.L1088
	ret
.L1089:
	cmp	w1, 3
	bhi	.L1088
	ldrb	w5, [x10,w1,uxtw]
	adr	x13, .Lrtx1090
	add	x5, x13, w5, sxtb #2
	br	x5
.Lrtx1090:
	.section	.rodata.queue_lun_state,"a",@progbits
	.align	0
	.align	2
.L1090:
	.byte	(.L1086 - .Lrtx1090) / 4
	.byte	(.L1091 - .Lrtx1090) / 4
	.byte	(.L1092 - .Lrtx1090) / 4
	.byte	(.L1086 - .Lrtx1090) / 4
	.section	.text.queue_lun_state
.L1091:
	cmp	w0, 6
	ccmp	w0, 8, 4, ne
	beq	.L1088
	ret
.L1092:
	cmp	w0, 10
	bne	.L1086
.L1088:
	lsl	x2, x2, 6
	ldrb	w2, [x12, x2]
	cmp	w2, 255
	bne	.L1093
.L1094:
	mov	w0, 0
.L1086:
	ret
	.size	queue_lun_state, .-queue_lun_state
	.section	.text.queue_remove_completed_req,"ax",@progbits
	.align	2
	.global	queue_remove_completed_req
	.type	queue_remove_completed_req, %function
queue_remove_completed_req:
	adrp	x4, .LANCHOR122
	adrp	x8, .LANCHOR66
	adrp	x1, .LANCHOR53
	adrp	x7, .LANCHOR127
	adrp	x3, .LANCHOR49
	ldrb	w14, [x4, #:lo12:.LANCHOR122]
	add	x5, x3, :lo12:.LANCHOR49
	ldrb	w2, [x1, #:lo12:.LANCHOR53]
	ldrb	w12, [x8, #:lo12:.LANCHOR66]
	mov	x11, x5
	ldrb	w13, [x7, #:lo12:.LANCHOR127]
	add	x16, x8, :lo12:.LANCHOR66
	add	x7, x7, :lo12:.LANCHOR127
	add	x10, x4, :lo12:.LANCHOR122
	mov	w6, 0
	mov	w15, -1
.L1097:
	cmp	w2, 255
	beq	.L1098
	sbfiz	x8, x2, 6, 32
	sxtw	x0, w2
	add	x4, x5, x8
	ldrb	w4, [x4, 58]
	sub	w4, w4, #11
	and	w4, w4, 255
	cmp	w4, 1
	bls	.L1099
	cbz	w6, .L1096
	strb	w2, [x1, #:lo12:.LANCHOR53]
	ret
.L1099:
	lsl	x6, x0, 6
	ldrb	w2, [x5, x8]
	add	x4, x5, x6
	strb	w15, [x5, x6]
	ldrb	w6, [x4, 59]
	cmp	w6, 1
	bne	.L1102
	ldrh	w4, [x4, 50]
	cbnz	w4, .L1110
	mov	w4, w14
	mov	x6, x10
.L1103:
	cmp	w4, 255
	bne	.L1108
	add	x3, x3, :lo12:.LANCHOR49
	strb	w2, [x1, #:lo12:.LANCHOR53]
	add	x0, x3, x0, lsl 6
	ldrb	w0, [x0, 1]
	strb	w0, [x6]
	ret
.L1102:
	cbnz	w6, .L1104
	ldr	w4, [x4, 36]
	cmn	w4, #1
	beq	.L1104
	mov	w4, w13
	mov	x6, x7
	b	.L1103
.L1110:
	mov	w4, w12
	mov	x6, x16
	b	.L1103
.L1108:
	mov	w6, w4
	sbfiz	x4, x4, 6, 32
	ldrb	w4, [x11, x4]
	cmp	w4, 255
	bne	.L1108
	add	x0, x11, x0, lsl 6
	sbfiz	x6, x6, 6, 32
	ldrb	w0, [x0, 1]
	strb	w0, [x11, x6]
.L1104:
	mov	w6, 1
	b	.L1097
.L1098:
	cbz	w6, .L1096
	mov	w0, -1
	strb	w0, [x1, #:lo12:.LANCHOR53]
.L1096:
	ret
	.size	queue_remove_completed_req, .-queue_remove_completed_req
	.section	.text.pm_alloc_new_blk,"ax",@progbits
	.align	2
	.global	pm_alloc_new_blk
	.type	pm_alloc_new_blk, %function
pm_alloc_new_blk:
	stp	x29, x30, [sp, -64]!
	adrp	x2, .LANCHOR73
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR97
	stp	x21, x22, [sp, 32]
	ldr	x1, [x20, #:lo12:.LANCHOR97]
	ldrb	w2, [x2, #:lo12:.LANCHOR73]
	ldrh	w0, [x1, 690]
	str	x23, [sp, 48]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, 690]
	cmp	w2, w0
	bls	.L1121
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x0, 672]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1122
.L1121:
	adrp	x19, .LC70
	add	x19, x19, :lo12:.LC70
	adrp	x23, .LANCHOR7
.L1134:
	mov	w0, 1
	bl	ftl_alloc_sblk
	mov	w1, 0
	and	w21, w0, 65535
	bl	ftl_erase_sblk
	add	x14, x20, :lo12:.LANCHOR97
	ldr	x1, [x20, #:lo12:.LANCHOR97]
	mov	w0, w21
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	tst	w0, 65535
	bne	.L1123
	mov	w1, w21
	mov	x0, x19
	bl	printf
	ldr	x1, [x23, #:lo12:.LANCHOR7]
	add	x1, x1, x21, uxth 2
	ldrb	w0, [x1, 2]
	orr	w0, w0, -32
	strb	w0, [x1, 2]
	b	.L1134
.L1123:
	ldr	x0, [x14]
	adrp	x1, .LANCHOR128
	mov	w2, 1
	mov	w19, 0
	add	x0, x0, 416
	str	w2, [x1, #:lo12:.LANCHOR128]
	mov	w1, 65535
	strh	wzr, [x0, 274]
.L1125:
	ldrh	w2, [x0]
	cmp	w2, w1
	beq	.L1124
	add	w19, w19, 1
	add	x0, x0, 2
	and	w19, w19, 65535
	cmp	w19, 128
	bne	.L1125
	adrp	x1, .LANCHOR129
	adrp	x0, .LC0
	mov	w2, 194
	add	x1, x1, :lo12:.LANCHOR129
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1124:
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	add	x19, x0, x19, sxtw 1
	ldrh	w1, [x0, 688]
	strh	w21, [x19, 416]
	add	w1, w1, 1
	strh	w1, [x0, 688]
.L1122:
	ldr	x1, [x20, #:lo12:.LANCHOR97]
	ldrh	w0, [x1, 690]
	add	x0, x0, 336
	ldrh	w19, [x1, x0, lsl 1]
	mov	w0, 65533
	sub	w1, w19, #1
	cmp	w0, w1, uxth
	bcs	.L1127
	adrp	x1, .LANCHOR129
	adrp	x0, .LC0
	mov	w2, 199
	add	x1, x1, :lo12:.LANCHOR129
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1127:
	adrp	x1, .LANCHOR99
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	mov	w2, 21
	ldrh	w1, [x1, #:lo12:.LANCHOR99]
	sub	w2, w2, w1
	strh	wzr, [x0, 696]
	strh	w19, [x0, 692]
	asr	w4, w19, w2
	strh	w4, [x0, 694]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1130
	mov	w0, 1
	and	w4, w4, 65535
	lsl	w2, w0, w2
	mov	w3, w19
	adrp	x0, .LC71
	sub	w2, w2, #1
	mov	w1, w19
	add	x0, x0, :lo12:.LC71
	bl	printf
.L1130:
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
	adrp	x0, .LANCHOR130
	add	x0, x0, :lo12:.LANCHOR130
	mov	x1, 0
	add	x29, sp, 0
	mov	w2, 65535
	str	x19, [sp, 16]
.L1139:
	lsl	x3, x1, 4
	and	w19, w1, 65535
	ldrh	w3, [x3, x0]
	cmp	w3, w2
	beq	.L1138
	add	x1, x1, 1
	cmp	x1, 32
	bne	.L1139
	add	x0, x0, 2
	mov	w19, w1
	mov	x2, x0
	mov	w4, 32768
	mov	w1, 0
.L1141:
	ldrh	w3, [x2]
	tbnz	x3, 15, .L1140
	cmp	w3, w4
	bcs	.L1140
	mov	w4, w3
	mov	w19, w1
.L1140:
	add	w1, w1, 1
	add	x2, x2, 16
	and	w1, w1, 65535
	cmp	w1, 32
	bne	.L1141
	cmp	w19, 32
	bne	.L1138
	adrp	x1, .LANCHOR131
	mov	w2, -1
	ldrb	w3, [x1, #:lo12:.LANCHOR131]
	mov	w1, 0
.L1143:
	ldrh	w5, [x0]
	cmp	w5, w2
	bcs	.L1142
	ldrh	w4, [x0, -2]
	cmp	w4, w3
	csel	w2, w2, w5, eq
	csel	w19, w19, w1, eq
.L1142:
	add	w1, w1, 1
	add	x0, x0, 16
	and	w1, w1, 65535
	cmp	w1, 32
	bne	.L1143
	cmp	w19, 32
	bne	.L1138
	adrp	x1, .LANCHOR132
	adrp	x0, .LC0
	mov	w2, 297
	add	x1, x1, :lo12:.LANCHOR132
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1138:
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	pm_select_ram_region, .-pm_select_ram_region
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
	cbnz	w0, .L1150
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1151:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 256
	bne	.L1151
.L1157:
	adrp	x20, .LANCHOR133
	add	x20, x20, :lo12:.LANCHOR133
	mov	w2, 1024
	mov	w1, 255
	mov	x0, x20
	add	x19, x19, :lo12:.LANCHOR3
	bl	ftl_memset
	mov	x0, 0
.L1152:
	ldrh	w1, [x0, x19]
	add	x0, x0, 2
	cmp	x0, 512
	strh	w1, [x20, w1, sxtw 1]
	bne	.L1152
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1150:
	cmp	w0, 1
	bne	.L1153
	add	x3, x19, :lo12:.LANCHOR3
	mov	x1, 0
.L1156:
	and	w0, w1, 65535
	cmp	x1, 3
	bls	.L1154
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 2
	sub	w0, w2, w0
	and	w0, w0, 65535
.L1154:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L1156
	b	.L1157
.L1153:
	cmp	w0, 2
	bne	.L1158
	add	x3, x19, :lo12:.LANCHOR3
	mov	w1, 65535
	mov	x0, 0
.L1160:
	cmp	x0, 2
	and	w2, w0, 65535
	csel	w2, w2, w1, cc
	strh	w2, [x3, x0, lsl 1]
	add	w1, w1, 2
	add	x0, x0, 1
	and	w1, w1, 65535
	cmp	x0, 256
	bne	.L1160
	b	.L1157
.L1158:
	cmp	w0, 3
	bne	.L1161
	add	x3, x19, :lo12:.LANCHOR3
	mov	x1, 0
.L1164:
	and	w0, w1, 65535
	cmp	x1, 5
	bls	.L1162
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 4
	sub	w0, w2, w0
	and	w0, w0, 65535
.L1162:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L1164
	b	.L1157
.L1161:
	cmp	w0, 4
	bne	.L1165
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
.L1167:
	and	w3, w0, 1
	ubfiz	w2, w0, 1, 15
	add	w3, w3, 6
	add	w0, w0, 1
	sub	w2, w2, w3
	strh	w2, [x1], 2
	and	w0, w0, 65535
	cmp	w0, 256
	bne	.L1167
	b	.L1157
.L1165:
	cmp	w0, 5
	bne	.L1168
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1169:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 16
	bne	.L1169
	add	x1, x1, 32
.L1170:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 496
	bne	.L1170
	b	.L1157
.L1168:
	cmp	w0, 8
	bne	.L1157
	add	x1, x19, :lo12:.LANCHOR3
	mov	x0, 0
.L1171:
	strh	w0, [x0, x1]
	add	x0, x0, 2
	cmp	x0, 512
	bne	.L1171
	b	.L1157
	.size	flash_lsb_page_tbl_build, .-flash_lsb_page_tbl_build
	.section	.text.flash_die_info_init,"ax",@progbits
	.align	2
	.global	flash_die_info_init
	.type	flash_die_info_init, %function
flash_die_info_init:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR14
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	tbz	x0, 12, .L1187
	adrp	x1, .LANCHOR134
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR134
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1187:
	adrp	x23, .LANCHOR34
	add	x19, x23, :lo12:.LANCHOR34
	adrp	x25, .LANCHOR2
	adrp	x26, .LANCHOR18
	adrp	x22, .LANCHOR29
	add	x21, x22, :lo12:.LANCHOR29
	ldrh	w0, [x19, 26]
	mov	w2, 8
	ldrb	w1, [x19, 12]
	adrp	x24, .LANCHOR136
	strh	w0, [x25, #:lo12:.LANCHOR2]
	add	x20, x24, :lo12:.LANCHOR136
	ldrh	w0, [x19, 10]
	add	x19, x19, 1
	strb	wzr, [x26, #:lo12:.LANCHOR18]
	sdiv	w0, w0, w1
	adrp	x1, .LANCHOR135
	strh	w0, [x1, #:lo12:.LANCHOR135]
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	mov	w2, 32
	mov	w1, 0
	mov	x0, x20
	bl	ftl_memset
	ldrb	w13, [x23, #:lo12:.LANCHOR34]
	mov	x7, x23
	adrp	x14, .LANCHOR41
	add	x11, x26, :lo12:.LANCHOR18
	add	x23, x14, :lo12:.LANCHOR41
	mov	x8, 0
.L1189:
	mov	w2, w13
	add	x1, x23, x8, lsl 3
	mov	x0, x19
	bl	flash_mem_cmp8
	cbnz	w0, .L1188
	ldrb	w1, [x11]
	add	w0, w1, 1
	strb	w0, [x11]
	str	wzr, [x20, x1, lsl 2]
	strb	w8, [x21, x1]
.L1188:
	add	x8, x8, 1
	cmp	x8, 4
	bne	.L1189
	add	x0, x7, :lo12:.LANCHOR34
	ldrb	w1, [x0, 8]
	cmp	w1, 2
	beq	.L1190
.L1194:
	add	x7, x7, :lo12:.LANCHOR34
	ldrb	w0, [x26, #:lo12:.LANCHOR18]
	ldp	x19, x20, [sp, 16]
	ldrb	w1, [x7, 13]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	mul	w0, w0, w1
	ldrh	w1, [x7, 14]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	mul	w0, w0, w1
	adrp	x1, .LANCHOR137
	strh	w0, [x1, #:lo12:.LANCHOR137]
	ret
.L1190:
	ldrh	w1, [x25, #:lo12:.LANCHOR2]
	add	x14, x14, :lo12:.LANCHOR41
	ldrb	w11, [x0, 13]
	add	x8, x0, 1
	ldrb	w20, [x0, 23]
	add	x19, x26, :lo12:.LANCHOR18
	add	x15, x24, :lo12:.LANCHOR136
	add	x22, x22, :lo12:.LANCHOR29
	mov	x12, 0
	mul	w11, w11, w1
	ldrh	w1, [x0, 14]
	and	w1, w1, 65280
	mul	w11, w11, w1
	lsl	w21, w11, 1
.L1193:
	mov	w2, w13
	add	x1, x14, x12, lsl 3
	mov	x0, x8
	bl	flash_mem_cmp8
	cbnz	w0, .L1191
	ldrb	w1, [x19]
	cmp	w20, 0
	csel	w2, w11, w21, eq
	add	w0, w1, 1
	strb	w0, [x19]
	str	w2, [x15, x1, lsl 2]
	strb	w12, [x22, x1]
.L1191:
	add	x12, x12, 1
	cmp	x12, 4
	bne	.L1193
	b	.L1194
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
	adrp	x0, .LANCHOR80
	mov	w1, 255
	ldp	x29, x30, [sp], 16
	ldrh	w2, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR73
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
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
	tbz	x0, 12, .L1207
	adrp	x1, .LANCHOR138
	adrp	x0, .LC72
	mov	w3, 0
	mov	w2, 222
	add	x1, x1, :lo12:.LANCHOR138
	add	x0, x0, :lo12:.LC72
	bl	printf
.L1207:
	adrp	x20, .LANCHOR80
	adrp	x22, .LANCHOR73
	adrp	x19, .LANCHOR110
	add	x19, x19, :lo12:.LANCHOR110
	mov	w2, 512
	mov	w1, 255
	mov	x0, x19
	bl	ftl_memset
	ldrh	w2, [x20, #:lo12:.LANCHOR80]
	adrp	x21, .LANCHOR112
	ldrb	w0, [x22, #:lo12:.LANCHOR73]
	mov	w1, 255
	add	x20, x20, :lo12:.LANCHOR80
	mul	w2, w2, w0
	ldr	x0, [x21, #:lo12:.LANCHOR112]
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR111
	ldrb	w3, [x22, #:lo12:.LANCHOR73]
	ldr	x5, [x21, #:lo12:.LANCHOR112]
	mov	w1, 0
	ldr	x4, [x0, #:lo12:.LANCHOR111]
.L1208:
	ldrh	w0, [x20]
	mul	w0, w0, w3
	cmp	w1, w0, lsl 1
	blt	.L1210
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L1210:
	uxtw	x2, w1
	ldr	w0, [x4, x2, lsl 2]
	cmn	w0, #1
	beq	.L1209
	and	x0, x0, 255
	ldrh	w6, [x19, x0, lsl 1]
	strh	w1, [x19, x0, lsl 1]
	strh	w6, [x5, x2, lsl 1]
.L1209:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L1208
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
	adrp	x1, .LANCHOR34
	add	x1, x1, :lo12:.LANCHOR34
	adrp	x0, .LANCHOR2
	mov	w4, 1
	ldrb	w3, [x1, 9]
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	mul	w0, w3, w0
	and	w2, w0, 65535
	strb	w2, [x19, 4]
	ubfx	x0, x2, 8, 8
	strb	w0, [x19, 5]
	adrp	x0, .LANCHOR43
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	strb	w0, [x19, 7]
	ldrb	w0, [x1, 13]
	mul	w0, w0, w2
	ldrh	w2, [x1, 14]
	strb	wzr, [x19, 10]
	mul	w0, w0, w2
	ldrb	w2, [x1, 8]
	strb	w3, [x19, 6]
	mul	w0, w0, w2
	strb	w0, [x19]
	ubfx	x2, x0, 8, 8
	strb	w2, [x19, 1]
	ubfx	x2, x0, 16, 8
	lsr	w0, w0, 24
	strb	w2, [x19, 2]
	adrp	x2, .LANCHOR29
	strb	w0, [x19, 3]
	mov	w0, 32
	strb	w0, [x19, 8]
	add	x2, x2, :lo12:.LANCHOR29
	ldrb	w0, [x1, 7]
	mov	x1, 0
	strb	w0, [x19, 9]
	adrp	x0, .LANCHOR18
	ldrb	w3, [x0, #:lo12:.LANCHOR18]
.L1219:
	cmp	w3, w1, uxtb
	bhi	.L1220
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1220:
	ldrb	w0, [x1, x2]
	add	x1, x1, 1
	ldrb	w5, [x19, 10]
	lsl	w0, w4, w0
	orr	w0, w0, w5
	strb	w0, [x19, 10]
	b	.L1219
	.size	zftl_read_flash_info, .-zftl_read_flash_info
	.section	.text.gc_static_wearleveling,"ax",@progbits
	.align	2
	.global	gc_static_wearleveling
	.type	gc_static_wearleveling, %function
gc_static_wearleveling:
	stp	x29, x30, [sp, -160]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR97
	stp	x19, x20, [sp, 16]
	ldr	x0, [x25, #:lo12:.LANCHOR97]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	ldr	w1, [x0, 32]
	mov	w0, 10240
	cmp	w1, w0
	bls	.L1223
	bl	ftl_tmp_into_update
.L1223:
	adrp	x19, .LANCHOR10
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w1, [x0, 568]
	ldr	w2, [x0, 12]
	add	w1, w1, 860160
	add	w1, w1, 3840
	cmp	w2, w1
	bhi	.L1224
	ldr	x3, [x25, #:lo12:.LANCHOR97]
	ldr	w1, [x0, 572]
	add	w1, w1, 32
	ldr	w3, [x3, 36]
	cmp	w3, w1
	bls	.L1273
.L1224:
	ldr	x1, [x25, #:lo12:.LANCHOR97]
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
.L1226:
	ldrh	w0, [x10]
	cmp	w0, w24
	bhi	.L1235
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
	tbz	x3, 10, .L1236
	adrp	x3, .LANCHOR9
	ldrb	w4, [x26, 2]
	ldr	x6, [x3, #:lo12:.LANCHOR9]
	ldr	w3, [x2, x0]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC74
	add	x0, x0, :lo12:.LC74
	ldrh	w7, [x6, x5, lsl 1]
	ubfx	x3, x3, 11, 8
	ldrb	w6, [x26, 3]
	ubfx	x5, x4, 5, 3
	and	w2, w2, 2047
	ubfx	x4, x4, 3, 2
	bl	printf
.L1236:
	ldrb	w0, [x26, 2]
	tbz	x0, 3, .L1237
	ldrb	w0, [x26, 2]
	and	w1, w0, 192
	cmp	w1, 64
	bne	.L1238
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w1, 0
	mov	w2, 1
	ldrh	w0, [x0, 586]
	bl	gc_add_sblk
	adrp	x0, .LANCHOR62+318
	mov	w1, 1
	strh	w1, [x0, #:lo12:.LANCHOR62+318]
.L1237:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	w3, [x24, #:lo12:.LANCHOR14]
	ldr	x2, [x23, #:lo12:.LANCHOR7]
	ldrh	w5, [x0, 584]
	mov	x1, x5
	lsl	x0, x5, 2
	add	x26, x2, x0
	tbz	x3, 10, .L1239
	adrp	x3, .LANCHOR9
	ldrb	w4, [x26, 2]
	ldr	x6, [x3, #:lo12:.LANCHOR9]
	ldr	w3, [x2, x0]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC75
	add	x0, x0, :lo12:.LC75
	ldrh	w7, [x6, x5, lsl 1]
	ubfx	x3, x3, 11, 8
	ldrb	w6, [x26, 3]
	ubfx	x5, x4, 5, 3
	and	w2, w2, 2047
	ubfx	x4, x4, 3, 2
	bl	printf
.L1239:
	ldrb	w0, [x26, 2]
	tbz	x0, 3, .L1240
	ldrb	w0, [x26, 2]
	and	w1, w0, 192
	cmp	w1, 64
	bne	.L1241
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w1, 0
	mov	w2, 1
	ldrh	w0, [x0, 584]
	bl	gc_add_sblk
	adrp	x0, .LANCHOR62+318
	mov	w1, 1
	strh	w1, [x0, #:lo12:.LANCHOR62+318]
.L1240:
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1242
	ldr	w6, [x29, 128]
	adrp	x2, .LANCHOR9
	ldr	x1, [x23, #:lo12:.LANCHOR7]
	ldr	x7, [x2, #:lo12:.LANCHOR9]
	lsl	x0, x6, 2
	add	x5, x1, x0
	ldr	w3, [x1, x0]
	ldrh	w2, [x1, x0]
	adrp	x0, .LC76
	ldrh	w7, [x7, x6, lsl 1]
	add	x0, x0, :lo12:.LC76
	ldrb	w6, [x5, 3]
	ubfx	x3, x3, 11, 8
	ldr	w1, [x29, 128]
	and	w2, w2, 2047
	ldrb	w4, [x5, 2]
	ubfx	x5, x4, 5, 3
	ubfx	x4, x4, 3, 2
	bl	printf
.L1242:
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1243
	ldr	w6, [x29, 136]
	adrp	x2, .LANCHOR9
	ldr	x1, [x23, #:lo12:.LANCHOR7]
	ldr	x7, [x2, #:lo12:.LANCHOR9]
	lsl	x0, x6, 2
	add	x5, x1, x0
	ldr	w3, [x1, x0]
	ldrh	w2, [x1, x0]
	adrp	x0, .LC77
	ldrh	w7, [x7, x6, lsl 1]
	add	x0, x0, :lo12:.LC77
	ldrb	w6, [x5, 3]
	ubfx	x3, x3, 11, 8
	ldr	w1, [x29, 136]
	and	w2, w2, 2047
	ldrb	w4, [x5, 2]
	ubfx	x5, x4, 5, 3
	ubfx	x4, x4, 3, 2
	bl	printf
.L1243:
	ldr	x0, [x25, #:lo12:.LANCHOR97]
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
	tbz	x0, 10, .L1244
	adrp	x0, .LC78
	and	w4, w4, 65535
	and	w3, w3, 65535
	mov	w2, w28
	mov	w1, w27
	add	x0, x0, :lo12:.LC78
	bl	printf
.L1244:
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 10, .L1245
	adrp	x0, .LANCHOR139
	ldr	w3, [x29, 156]
	mov	w4, w22
	mov	w2, w21
	ldrh	w6, [x0, #:lo12:.LANCHOR139]
	adrp	x0, .LANCHOR140
	mov	w1, w20
	ldrh	w5, [x0, #:lo12:.LANCHOR140]
	adrp	x0, .LC79
	add	x0, x0, :lo12:.LC79
	bl	printf
.L1245:
	sub	w0, w22, w21
	str	w0, [x29, 148]
	adrp	x0, .LANCHOR139
	ldr	w1, [x29, 148]
	ldrh	w0, [x0, #:lo12:.LANCHOR139]
	cmp	w1, w0
	bgt	.L1246
	adrp	x1, .LANCHOR140
	ldr	w0, [x29, 156]
	ldrh	w1, [x1, #:lo12:.LANCHOR140]
	sub	w0, w0, w20
	cmp	w0, w1
	ble	.L1274
.L1246:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	adrp	x28, .LANCHOR62
	add	x28, x28, :lo12:.LANCHOR62
	mov	w27, 0
	mov	w22, 0
	ldrh	w26, [x0, 580]
	ldr	x0, [x25, #:lo12:.LANCHOR97]
	ldrh	w0, [x0, 134]
	str	w0, [x29, 152]
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	str	x0, [x29, 136]
	adrp	x0, .LANCHOR140
	add	x0, x0, :lo12:.LANCHOR140
	str	x0, [x29, 128]
.L1248:
	ldr	x0, [x29, 136]
	ldr	w1, [x29, 152]
	ldrh	w0, [x0]
	cmp	w1, w0
	bcc	.L1258
.L1257:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	str	w26, [x0, 580]
.L1247:
	cbz	w21, .L1260
	ldr	x2, [x25, #:lo12:.LANCHOR97]
	adrp	x0, .LANCHOR6
	ldrh	w5, [x0, #:lo12:.LANCHOR6]
	ldr	x0, [x23, #:lo12:.LANCHOR7]
	ldrh	w1, [x2, 134]
	add	x0, x0, x1, uxth 2
.L1261:
	cmp	w1, w5
	bcc	.L1263
	ldrh	w0, [x2, 72]
	add	w0, w21, w0
	strh	w0, [x2, 72]
	ldrh	w0, [x2, 98]
	cmp	w21, w0
	bcs	.L1260
	sub	w21, w0, w21
	strh	w21, [x2, 98]
.L1260:
	cbz	w20, .L1266
	ldr	x2, [x25, #:lo12:.LANCHOR97]
	adrp	x0, .LANCHOR6
	ldrh	w6, [x0, #:lo12:.LANCHOR6]
	ldr	x0, [x23, #:lo12:.LANCHOR7]
	ldrh	w1, [x2, 134]
	add	x0, x0, x1, uxth 2
.L1267:
	cmp	w1, w6
	bcc	.L1269
	ldrh	w0, [x2, 74]
	add	w0, w20, w0
	strh	w0, [x2, 74]
	ldrh	w0, [x2, 96]
	cmp	w20, w0
	bcs	.L1266
	sub	w20, w0, w20
	strh	w20, [x2, 96]
.L1266:
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w1, w0, 65535
	mov	w2, 65535
	cmp	w1, w2
	beq	.L1225
	adrp	x2, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x1]
	adrp	x1, .LANCHOR80
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	cmp	w2, w1
	bhi	.L1225
	add	w22, w22, 1
	mov	w2, 1
	mov	w1, 0
	bl	gc_add_sblk
.L1225:
	add	w0, w22, w27
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L1235:
	uxtw	x7, w24
	ldr	x6, [x23, #:lo12:.LANCHOR7]
	lsl	x2, x7, 2
	add	x11, x6, x2
	ldrb	w0, [x11, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L1227
	ubfx	x4, x0, 3, 2
	tbz	x4, 0, .L1228
	ldr	w0, [x6, x2]
	ldrh	w1, [x6, x2]
	ubfx	x0, x0, 11, 8
	and	w1, w1, 2047
.L1229:
	ldr	w3, [x29, 148]
	add	w27, w27, 1
	and	w27, w27, 65535
	cmp	w20, w1
	add	w3, w3, w1
	str	w3, [x29, 148]
	bls	.L1272
	ldr	x3, [x19, #:lo12:.LANCHOR10]
	mov	w20, w1
	strh	w24, [x3, 586]
.L1272:
	ldr	w3, [x29, 156]
	cmp	w3, w1
	bcs	.L1232
	str	w24, [x29, 128]
	str	w1, [x29, 156]
.L1232:
	mov	w3, 65535
	cmp	w0, w3
	bne	.L1231
.L1233:
	cmp	w0, 9
	ccmp	w1, 9, 0, hi
	bhi	.L1227
	ldr	w0, [x8]
	tbz	x0, 8, .L1227
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
	adrp	x0, .LC73
	ubfx	x5, x5, 5, 3
	add	x0, x0, :lo12:.LC73
	bl	printf
	ldp	x8, x10, [x29, 112]
.L1227:
	add	w24, w24, 1
	and	w24, w24, 65535
	b	.L1226
.L1228:
	tst	w0, 24
	bne	.L1230
	ldrh	w1, [x6, x2]
	mov	w0, 65535
	and	w1, w1, 2047
	b	.L1229
.L1230:
	ldr	w0, [x6, x2]
	mov	w1, 65535
	ubfx	x0, x0, 11, 8
.L1231:
	ldr	w3, [x29, 152]
	add	w28, w28, 1
	and	w28, w28, 65535
	cmp	w21, w0
	add	w3, w3, w0
	str	w3, [x29, 152]
	bls	.L1234
	ldr	x3, [x19, #:lo12:.LANCHOR10]
	mov	w21, w0
	strh	w24, [x3, 584]
.L1234:
	cmp	w22, w0
	bcs	.L1233
	mov	w22, w0
	str	w24, [x29, 136]
	b	.L1233
.L1238:
	tst	w0, 224
	bne	.L1237
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w1, 65535
	ldrh	w2, [x0, 590]
	cmp	w2, w1
	bne	.L1237
	ldrh	w0, [x0, 586]
	bl	zftl_remove_free_node
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldrh	w1, [x0, 586]
	strh	w1, [x0, 590]
	mov	w1, -1
	strh	w1, [x0, 586]
	b	.L1237
.L1241:
	tst	w0, 224
	bne	.L1240
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w1, 65535
	ldrh	w2, [x0, 588]
	cmp	w2, w1
	bne	.L1240
	ldrh	w0, [x0, 584]
	bl	zftl_remove_free_node
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldrh	w1, [x0, 584]
	strh	w1, [x0, 588]
	mov	w1, -1
	strh	w1, [x0, 584]
	b	.L1240
.L1258:
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
	beq	.L1250
	and	w2, w0, 224
	cmp	w2, 224
	beq	.L1250
	ubfx	x0, x0, 3, 2
	and	w1, w0, 1
	tbz	x0, 0, .L1251
	cmp	w2, 160
.L1338:
	bne	.L1253
	adrp	x0, .LANCHOR139
	ldr	w2, [x29, 148]
	ldrh	w0, [x0, #:lo12:.LANCHOR139]
	cmp	w2, w0
	ble	.L1254
	ldr	w0, [x4, x3]
	add	w2, w21, 2
	ubfx	x0, x0, 11, 8
	cmp	w0, w2
	ble	.L1255
	cbz	w1, .L1254
	ldrh	w0, [x4, x3]
	and	w0, w0, 2047
	cmp	w0, w20
	bgt	.L1254
.L1255:
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
	tbz	x0, 10, .L1254
	adrp	x0, .LANCHOR9
	ldr	w6, [x4, x3]
	ldrh	w5, [x4, x3]
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldr	x0, [x23, #:lo12:.LANCHOR7]
	ubfx	x6, x6, 11, 8
	ldrh	w4, [x28, 56]
	and	w5, w5, 2047
	add	x3, x0, x3
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	ldrb	w2, [x3, 2]
	ldrh	w3, [x1, x8, lsl 1]
	mov	w1, w26
	ubfx	x2, x2, 5, 3
.L1339:
	bl	printf
.L1254:
	cmp	w22, 4
	ccmp	w27, 4, 2, ls
	bhi	.L1257
.L1250:
	ldr	w0, [x29, 152]
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w0, [x29, 152]
	b	.L1248
.L1251:
	cmp	w0, 2
	b	.L1338
.L1253:
	ldr	x2, [x29, 128]
	ldr	w0, [x29, 156]
	sub	w0, w0, w20
	ldrh	w2, [x2]
	cmp	w0, w2
	ble	.L1254
	ldrh	w0, [x4, x3]
	add	w2, w20, 2
	and	w0, w0, 2047
	cmp	w0, w2
	ble	.L1256
	cbz	w1, .L1254
	ldr	w0, [x4, x3]
	add	w1, w21, 2
	ubfx	x0, x0, 11, 8
	cmp	w0, w1
	bgt	.L1254
.L1256:
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
	tbz	x0, 10, .L1254
	adrp	x0, .LANCHOR9
	ldr	w6, [x4, x3]
	ldrh	w5, [x4, x3]
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldr	x0, [x23, #:lo12:.LANCHOR7]
	ubfx	x6, x6, 11, 8
	and	w5, w5, 2047
	ldrh	w4, [x28, 56]
	add	x3, x0, x3
	adrp	x0, .LC81
	add	x0, x0, :lo12:.LC81
	ldrb	w2, [x3, 2]
	ldrh	w3, [x1, x8, lsl 1]
	mov	w1, w26
	ubfx	x2, x2, 5, 3
	b	.L1339
.L1274:
	mov	w27, 0
	mov	w22, 0
	b	.L1247
.L1263:
	ldr	w3, [x0]
	ubfx	x4, x3, 11, 8
	cmp	w21, w4
	bhi	.L1262
	ldrb	w6, [x0, 2]
	tst	w6, 24
	beq	.L1262
	sub	w4, w4, w21
	bfi	w3, w4, 11, 8
	str	w3, [x0]
.L1262:
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 65535
	b	.L1261
.L1269:
	ldrh	w3, [x0]
	and	w4, w3, 2047
	cmp	w4, w20
	blt	.L1268
	ldrb	w5, [x0, 2]
	and	w5, w5, 24
	cmp	w5, 16
	beq	.L1268
	sub	w4, w4, w20
	bfi	w3, w4, 0, 11
	strh	w3, [x0]
.L1268:
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 65535
	b	.L1267
.L1273:
	mov	w27, 0
	mov	w22, 0
	b	.L1225
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
	adrp	x20, .LANCHOR87
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR83
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR94
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR97
	mul	w2, w2, w0
	ldr	x0, [x28, #:lo12:.LANCHOR4]
	adrp	x24, .LANCHOR90
	adrp	x23, .LANCHOR92
	adrp	x21, .LANCHOR85
	bl	ftl_memset
	str	x28, [x29, 168]
	adrp	x0, .LANCHOR96
	adrp	x2, .LANCHOR73
	adrp	x3, .LANCHOR72
	mov	w1, 16
	strh	w1, [x0, #:lo12:.LANCHOR96]
	adrp	x10, .LANCHOR91
	ldrb	w0, [x2, #:lo12:.LANCHOR73]
	adrp	x8, .LANCHOR93
	ldrh	w1, [x3, #:lo12:.LANCHOR72]
	adrp	x7, .LANCHOR95
	adrp	x6, .LANCHOR76
	adrp	x5, .LANCHOR12
	adrp	x4, .LANCHOR75
	str	xzr, [x10, #:lo12:.LANCHOR91]
	str	xzr, [x8, #:lo12:.LANCHOR93]
	adrp	x28, .LANCHOR7
	mul	w1, w0, w1
	mov	w0, 32768
	str	xzr, [x7, #:lo12:.LANCHOR95]
	str	xzr, [x6, #:lo12:.LANCHOR76]
	str	xzr, [x5, #:lo12:.LANCHOR12]
	sdiv	w0, w0, w1
	str	xzr, [x4, #:lo12:.LANCHOR75]
	strh	wzr, [x24, #:lo12:.LANCHOR90]
	strh	wzr, [x23, #:lo12:.LANCHOR92]
	strh	wzr, [x22, #:lo12:.LANCHOR94]
	sxth	w0, w0
	str	w0, [x29, 188]
	ldr	x0, [x25, #:lo12:.LANCHOR97]
	strh	wzr, [x21, #:lo12:.LANCHOR85]
	strh	wzr, [x20, #:lo12:.LANCHOR87]
	strh	wzr, [x19, #:lo12:.LANCHOR83]
	strh	wzr, [x0, 146]
	ldrsh	w26, [x0, 134]
	add	x0, x27, :lo12:.LANCHOR6
	adrp	x27, .LC82
	add	x27, x27, :lo12:.LC82
	stp	x3, x2, [x29, 104]
	stp	x4, x5, [x29, 120]
	stp	x6, x7, [x29, 136]
	stp	x8, x10, [x29, 152]
	str	x0, [x29, 176]
.L1341:
	ldr	x0, [x29, 176]
	ldrh	w0, [x0]
	cmp	w26, w0
	blt	.L1357
	ldr	x0, [x25, #:lo12:.LANCHOR97]
	ldrh	w1, [x24, #:lo12:.LANCHOR90]
	ldp	x25, x26, [sp, 64]
	strh	w1, [x0, 114]
	ldrh	w1, [x23, #:lo12:.LANCHOR92]
	strh	w1, [x0, 118]
	ldrh	w1, [x22, #:lo12:.LANCHOR94]
	strh	w1, [x0, 116]
	ldrh	w1, [x21, #:lo12:.LANCHOR85]
	strh	w1, [x0, 122]
	ldrh	w1, [x20, #:lo12:.LANCHOR87]
	strh	w1, [x0, 120]
	ldrh	w1, [x19, #:lo12:.LANCHOR83]
	strh	w1, [x0, 124]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L1357:
	ldr	x4, [x28, #:lo12:.LANCHOR7]
	sxtw	x2, w26
	add	x4, x4, x2, lsl 2
	ldrb	w6, [x4, 3]
	cbz	w6, .L1358
	ldr	x0, [x29, 112]
	mov	w1, 0
	ldr	x7, [x25, #:lo12:.LANCHOR97]
	ldrb	w8, [x0, #:lo12:.LANCHOR73]
	ldr	x0, [x29, 104]
	ldrh	w10, [x0, #:lo12:.LANCHOR72]
	mov	w0, 0
.L1343:
	cmp	w1, w8
	blt	.L1346
	cbz	w0, .L1347
	mov	w1, 32768
	sdiv	w0, w1, w0
	add	w0, w0, 1
	sxth	w0, w0
.L1342:
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
	beq	.L1348
	adrp	x5, .LANCHOR10
	ldr	x5, [x5, #:lo12:.LANCHOR10]
	ldrh	w6, [x5, 16]
	cmp	w26, w6
	beq	.L1348
	ldrh	w6, [x5, 48]
	cmp	w26, w6
	beq	.L1348
	ldrh	w5, [x5, 80]
	cmp	w26, w5
	beq	.L1348
	cmp	w0, 64
	bne	.L1349
	ldr	x0, [x29, 128]
	add	x2, x21, :lo12:.LANCHOR85
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR12
.L1361:
	bl	_insert_data_list
.L1348:
	add	w3, w26, 1
	sxth	w26, w3
	b	.L1341
.L1346:
	asr	w5, w6, w1
	tbnz	x5, 0, .L1344
	add	w0, w10, w0
	sxth	w0, w0
.L1345:
	add	w1, w1, 1
	b	.L1343
.L1344:
	ldrh	w5, [x7, 146]
	add	w5, w5, 1
	strh	w5, [x7, 146]
	b	.L1345
.L1347:
	ldrb	w1, [x4, 2]
	mov	w5, -1
	orr	w1, w1, -32
	strb	w1, [x4, 2]
	adrp	x1, .LANCHOR9
	ldr	x1, [x1, #:lo12:.LANCHOR9]
	strh	w5, [x1, x2, lsl 1]
	b	.L1342
.L1358:
	ldr	w0, [x29, 188]
	b	.L1342
.L1349:
	cmp	w0, 96
	bne	.L1350
	ldr	x0, [x29, 136]
	add	x2, x19, :lo12:.LANCHOR83
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR76
	b	.L1361
.L1350:
	cmp	w0, 160
	bne	.L1351
	ldr	x0, [x29, 120]
	add	x2, x20, :lo12:.LANCHOR87
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR75
	b	.L1361
.L1351:
	cbnz	w0, .L1348
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w2, [x0, x2, lsl 1]
	cbz	w2, .L1352
	str	x4, [x29, 96]
	mov	w1, w26
	mov	x0, x27
	bl	printf
	ldr	x4, [x29, 96]
	ldrb	w0, [x4, 2]
	tbz	x0, 4, .L1353
	mov	w1, 5
.L1360:
	bfi	w0, w1, 5, 3
	strb	w0, [x4, 2]
	mov	w2, 0
	mov	w1, 1
	mov	w0, w26
	bl	gc_add_sblk
	b	.L1348
.L1353:
	mov	w1, 2
	b	.L1360
.L1352:
	ands	w1, w1, 24
	bne	.L1355
	ldr	x0, [x29, 160]
	add	x2, x24, :lo12:.LANCHOR90
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR91
.L1362:
	bl	_insert_free_list
	b	.L1348
.L1355:
	cmp	w1, 16
	bne	.L1356
	ldr	x0, [x29, 152]
	add	x2, x23, :lo12:.LANCHOR92
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR93
	b	.L1362
.L1356:
	ldr	x0, [x29, 144]
	add	x2, x22, :lo12:.LANCHOR94
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR95
	b	.L1362
	.size	zftl_sblk_list_init, .-zftl_sblk_list_init
	.section	.text.ftl_open_sblk_init,"ax",@progbits
	.align	2
	.global	ftl_open_sblk_init
	.type	ftl_open_sblk_init, %function
ftl_open_sblk_init:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR73
	stp	x21, x22, [sp, 32]
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	adrp	x21, .LC70
	adrp	x23, .LANCHOR80
	mov	w22, w1
	add	x23, x23, :lo12:.LANCHOR80
	add	x20, x20, :lo12:.LANCHOR73
	add	x21, x21, :lo12:.LC70
	stp	x25, x26, [sp, 64]
.L1364:
.L1367:
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
	beq	.L1368
	ldrb	w0, [x20]
	mul	w0, w1, w0
	and	w0, w0, 65535
.L1365:
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
	cbnz	w0, .L1363
	mov	w1, w24
	mov	x0, x21
	bl	printf
	ldr	x0, [x26, #:lo12:.LANCHOR9]
	mov	w1, -1
	strh	w1, [x0, x25]
	mov	w0, 7
	strb	w0, [x19, 4]
	b	.L1367
.L1368:
	mov	w0, 0
	b	.L1365
.L1363:
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
	adrp	x20, .LANCHOR141
	stp	x21, x22, [sp, 32]
	ldrh	w0, [x20, #:lo12:.LANCHOR141]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w0, 128
	stp	x27, x28, [sp, 80]
	bls	.L1371
	adrp	x1, .LANCHOR142
	adrp	x0, .LC0
	mov	w2, 78
	add	x1, x1, :lo12:.LANCHOR142
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1371:
	add	x28, x29, 112
	mov	w2, 256
	mov	w1, 0
	mov	x0, x28
	bl	ftl_memset
	adrp	x23, .LANCHOR98
	adrp	x5, .LANCHOR97
	adrp	x0, .LANCHOR99
	mov	w2, 21
	ldrb	w12, [x23, #:lo12:.LANCHOR98]
	ldr	x7, [x5, #:lo12:.LANCHOR97]
	ldrh	w11, [x0, #:lo12:.LANCHOR99]
	ldrh	w13, [x20, #:lo12:.LANCHOR141]
	add	x4, x7, 704
	sub	w0, w2, w11
	mov	w2, 1
	ldrh	w1, [x7, 698]
	lsl	w2, w2, w0
	sub	w2, w2, #1
	add	x1, x1, 176
	add	x1, x7, x1, lsl 2
.L1372:
	cmp	x4, x1
	bne	.L1376
	adrp	x24, .LANCHOR73
	adrp	x25, .LANCHOR80
	adrp	x26, .LANCHOR14
	adrp	x27, .LC83
	ldrb	w22, [x24, #:lo12:.LANCHOR73]
	add	x20, x20, :lo12:.LANCHOR141
	ldrh	w0, [x25, #:lo12:.LANCHOR80]
	add	x26, x26, :lo12:.LANCHOR14
	add	x27, x27, :lo12:.LC83
	mov	w19, 0
	str	wzr, [x29, 108]
	mul	w22, w22, w0
	and	w22, w22, 65535
.L1377:
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L1383
	ldr	w0, [x29, 108]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 368
	ret
.L1376:
	ldr	w0, [x4]
	add	x8, x7, 416
	mov	x3, 0
	lsr	w0, w0, w11
	and	w0, w0, w2
	udiv	w0, w0, w12
	and	w0, w0, 65535
.L1373:
	cmp	w13, w3, uxth
	bhi	.L1375
	add	x4, x4, 4
	b	.L1372
.L1375:
	ldrh	w10, [x8]
	cmp	w10, w0
	bne	.L1374
	ldrh	w10, [x28, x3, lsl 1]
	add	w10, w10, 1
	strh	w10, [x28, x3, lsl 1]
.L1374:
	add	x3, x3, 1
	add	x8, x8, 2
	b	.L1373
.L1383:
	ldr	x1, [x5, #:lo12:.LANCHOR97]
	sxtw	x21, w19
	add	x0, x21, 208
	ldrb	w2, [x23, #:lo12:.LANCHOR98]
	ldrh	w3, [x1, x0, lsl 1]
	ldrh	w0, [x1, 692]
	sdiv	w0, w0, w2
	cmp	w0, w3
	bne	.L1378
	ldrb	w0, [x24, #:lo12:.LANCHOR73]
	ldrh	w2, [x25, #:lo12:.LANCHOR80]
	mul	w0, w0, w2
	strh	w0, [x28, x21, lsl 1]
.L1378:
	ldrh	w0, [x28, x21, lsl 1]
	cmp	w22, w0
	bls	.L1379
	cbnz	w0, .L1384
.L1381:
	mov	w0, 65535
	cmp	w3, w0
	beq	.L1380
	ldr	w0, [x26]
	tbz	x0, 12, .L1382
	ldrh	w4, [x1, 688]
	mov	w2, 0
	str	x5, [x29, 96]
	mov	w1, w19
	mov	x0, x27
	bl	printf
	ldr	x5, [x29, 96]
.L1382:
	ldr	x0, [x5, #:lo12:.LANCHOR97]
	add	x21, x21, 208
	str	x5, [x29, 96]
	ldrh	w0, [x0, x21, lsl 1]
	bl	ftl_free_sblk
	ldr	x5, [x29, 96]
	mov	w1, -1
	ldr	x0, [x5, #:lo12:.LANCHOR97]
	strh	w1, [x0, x21, lsl 1]
	ldrh	w1, [x0, 688]
	sub	w1, w1, #1
	strh	w1, [x0, 688]
	b	.L1380
.L1379:
	cbz	w0, .L1381
.L1380:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1377
.L1384:
	mov	w22, w0
	str	w19, [x29, 108]
	b	.L1380
	.size	pm_free_sblk, .-pm_free_sblk
	.section	.text.idb_init,"ax",@progbits
	.align	2
	.global	idb_init
	.type	idb_init, %function
idb_init:
	stp	x29, x30, [sp, -16]!
	mov	w2, 262144
	mov	w1, 0
	adrp	x0, idb_buf
	add	x29, sp, 0
	add	x0, x0, :lo12:idb_buf
	bl	ftl_memset
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	idb_init, .-idb_init
	.section	.text.ftl_memcpy,"ax",@progbits
	.align	2
	.global	ftl_memcpy
	.type	ftl_memcpy, %function
ftl_memcpy:
	uxtw	x2, w2
	b	memcpy
	.size	ftl_memcpy, .-ftl_memcpy
	.section	.text.flash_into_data_init,"ax",@progbits
	.align	2
	.global	flash_into_data_init
	.type	flash_into_data_init, %function
flash_into_data_init:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR14
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	str	x19, [sp, 16]
	tbz	x0, 12, .L1393
	adrp	x2, .LANCHOR143
	adrp	x0, .LC84
	add	x2, x2, :lo12:.LANCHOR143
	mov	w1, 100
	add	x0, x0, :lo12:.LC84
	bl	printf
.L1393:
	adrp	x19, .LANCHOR26
	mov	w2, 2048
	mov	w1, 0
	ldr	x0, [x19, #:lo12:.LANCHOR26]
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR26]
	mov	w1, 21321
	movk	w1, 0x5359, lsl 16
	mov	w2, 32
	add	x0, x0, 80
	str	w1, [x0, -80]
	mov	w1, 2032
	str	w1, [x0, -72]
	mov	w1, 1
	strh	w1, [x0, -64]
	adrp	x1, .LANCHOR19
	add	x1, x1, :lo12:.LANCHOR19
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR26]
	mov	w2, 32
	ldr	x19, [sp, 16]
	adrp	x1, .LANCHOR34
	ldp	x29, x30, [sp], 32
	add	x1, x1, :lo12:.LANCHOR34
	add	x0, x0, 48
	b	ftl_memcpy
	.size	flash_into_data_init, .-flash_into_data_init
	.section	.text.ftl_memcpy32,"ax",@progbits
	.align	2
	.global	ftl_memcpy32
	.type	ftl_memcpy32, %function
ftl_memcpy32:
	mov	x3, 0
.L1399:
	cmp	w2, w3
	bhi	.L1400
	ret
.L1400:
	ldr	w4, [x1, x3, lsl 2]
	str	w4, [x0, x3, lsl 2]
	add	x3, x3, 1
	b	.L1399
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
	tbz	x0, 12, .L1405
	adrp	x1, .LANCHOR144
	adrp	x0, .LC85
	mov	x2, x19
	add	x1, x1, :lo12:.LANCHOR144
	add	x0, x0, :lo12:.LC85
	bl	printf
.L1405:
	adrp	x20, .LANCHOR27
	mov	w0, 6
	ldr	w2, [x19, 352]
	mov	w1, 12336
	strb	w0, [x20, #:lo12:.LANCHOR27]
	adrp	x0, .LANCHOR13
	movk	w1, 0x5638, lsl 16
	mov	x22, x0
	str	x19, [x0, #:lo12:.LANCHOR13]
	cmp	w2, w1
	bne	.L1406
	mov	w0, 8
	strb	w0, [x20, #:lo12:.LANCHOR27]
.L1406:
	ldr	w1, [x19, 128]
	mov	w0, 12336
	movk	w0, 0x5639, lsl 16
	cmp	w1, w0
	bne	.L1407
	mov	w0, 9
	strb	w0, [x20, #:lo12:.LANCHOR27]
.L1407:
	ldrb	w0, [x20, #:lo12:.LANCHOR27]
	cmp	w0, 9
	adrp	x0, .LANCHOR44
	bne	.L1408
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR44]
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
	tbz	x0, 12, .L1410
	ldr	w1, [x19]
	ldr	w2, [x19, 8]
	ldr	w3, [x19, 80]
	ldr	w4, [x19, 84]
	ldr	w5, [x19, 88]
.L1423:
	adrp	x0, .LC86
	add	x0, x0, :lo12:.LC86
	bl	printf
.L1410:
	adrp	x0, .LANCHOR45
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR45]
	adrp	x0, .LANCHOR47
	strh	wzr, [x0, #:lo12:.LANCHOR47]
	adrp	x0, .LANCHOR43
	strb	wzr, [x0, #:lo12:.LANCHOR43]
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1404
	ldrb	w1, [x20, #:lo12:.LANCHOR27]
	adrp	x0, .LC87
	add	x0, x0, :lo12:.LC87
	bl	printf
.L1404:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1408:
	strb	wzr, [x0, #:lo12:.LANCHOR44]
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
	adrp	x1, .LANCHOR46
	str	x0, [x1, #:lo12:.LANCHOR46]
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1410
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	ldr	w1, [x0]
	ldr	w2, [x0, 344]
	ldr	w3, [x0, 304]
	ldr	w4, [x0, 308]
	ldr	w5, [x0, 312]
	b	.L1423
	.size	nandc_init, .-nandc_init
	.section	.text.buf_init,"ax",@progbits
	.align	2
	.global	buf_init
	.type	buf_init, %function
buf_init:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR49
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	x19, x0, :lo12:.LANCHOR49
	stp	x21, x22, [sp, 32]
	mov	x20, x0
	adrp	x22, .LANCHOR121
	add	x22, x22, :lo12:.LANCHOR121
	mov	w21, 0
.L1425:
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
	bne	.L1425
	add	x0, x20, :lo12:.LANCHOR49
	mov	w1, -1
	strb	w1, [x0, 1984]
	adrp	x0, .LANCHOR50
	strb	wzr, [x0, #:lo12:.LANCHOR50]
	adrp	x0, .LANCHOR51
	ldp	x19, x20, [sp, 16]
	strb	w21, [x0, #:lo12:.LANCHOR51]
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
	adrp	x0, .LANCHOR71
	mov	w2, 328
	mov	w1, 0
	add	x29, sp, 0
	strb	wzr, [x0, #:lo12:.LANCHOR71]
	adrp	x0, .LANCHOR145
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR62
	strb	wzr, [x0, #:lo12:.LANCHOR145]
	adrp	x0, .LANCHOR146
	add	x19, x20, :lo12:.LANCHOR62
	str	wzr, [x0, #:lo12:.LANCHOR146]
	adrp	x0, .LANCHOR82
	strh	wzr, [x0, #:lo12:.LANCHOR82]
	mov	x0, x19
	bl	ftl_memset
	str	xzr, [x19, 8]
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR62]
	adrp	x0, .LANCHOR80
	adrp	x4, .LANCHOR89
	adrp	x20, .LANCHOR72
	ldrh	w1, [x0, #:lo12:.LANCHOR80]
	lsr	w2, w1, 1
	lsr	w0, w1, 2
	strh	w2, [x19, 38]
	adrp	x2, .LANCHOR81
	strh	w0, [x19, 36]
	adrp	x19, .LANCHOR73
	strh	wzr, [x2, #:lo12:.LANCHOR81]
	adrp	x2, .LANCHOR77
	ldrb	w3, [x19, #:lo12:.LANCHOR73]
	strh	wzr, [x2, #:lo12:.LANCHOR77]
	adrp	x2, .LANCHOR78
	strh	wzr, [x2, #:lo12:.LANCHOR78]
	mul	w2, w1, w3
	and	w2, w2, 65535
	sub	w5, w2, #32
	strh	w5, [x4, #:lo12:.LANCHOR89]
	adrp	x4, .LANCHOR86
	strh	w2, [x4, #:lo12:.LANCHOR86]
	adrp	x2, .LANCHOR79
	strh	w1, [x2, #:lo12:.LANCHOR79]
	adrp	x1, .LANCHOR61
	strh	w0, [x1, #:lo12:.LANCHOR61]
	ldrh	w0, [x20, #:lo12:.LANCHOR72]
	mul	w0, w0, w3
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR147
	str	x0, [x1, #:lo12:.LANCHOR147]
	ldrb	w1, [x19, #:lo12:.LANCHOR73]
	ldrh	w0, [x20, #:lo12:.LANCHOR72]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR148
	str	x0, [x1, #:lo12:.LANCHOR148]
	ldrh	w1, [x20, #:lo12:.LANCHOR72]
	ldrb	w0, [x19, #:lo12:.LANCHOR73]
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR69
	str	x0, [x1, #:lo12:.LANCHOR69]
	ldrb	w1, [x19, #:lo12:.LANCHOR73]
	ldrh	w0, [x20, #:lo12:.LANCHOR72]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR65
	str	x0, [x1, #:lo12:.LANCHOR65]
	ldrb	w1, [x19, #:lo12:.LANCHOR73]
	ldrh	w0, [x20, #:lo12:.LANCHOR72]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR149
	ldp	x19, x20, [sp, 16]
	str	x0, [x1, #:lo12:.LANCHOR149]
	adrp	x0, .LANCHOR84
	adrp	x1, .LANCHOR74
	ldp	x29, x30, [sp], 32
	ldrh	w0, [x0, #:lo12:.LANCHOR84]
	lsr	w0, w0, 2
	strh	w0, [x1, #:lo12:.LANCHOR74]
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
.L1432:
	cmp	w1, w3
	bhi	.L1433
	ret
.L1433:
	lsr	w2, w0, 2
	ldrb	w5, [x4, x3]
	add	w2, w2, w0, lsl 5
	add	x3, x3, 1
	add	w2, w2, w5
	eor	w0, w0, w2
	b	.L1432
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
	adrp	x0, .LANCHOR58
	ldr	w0, [x0, #:lo12:.LANCHOR58]
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
	adrp	x21, .LC89
	stp	x23, x24, [sp, 48]
	mov	x22, x1
	stp	x25, x26, [sp, 64]
	adrp	x23, .LC88
	mov	x26, x0
	mov	w24, w2
	uxtw	x25, w3
	add	x23, x23, :lo12:.LC88
	add	x21, x21, :lo12:.LC89
	stp	x19, x20, [sp, 16]
	str	x27, [sp, 80]
	mov	x19, 0
	mov	w20, 0
	adrp	x27, .LC90
.L1440:
	cmp	x25, x19
	bne	.L1446
	ldp	x19, x20, [sp, 16]
	adrp	x1, .LC90
	ldp	x21, x22, [sp, 32]
	add	x1, x1, :lo12:.LC90
	ldp	x23, x24, [sp, 48]
	adrp	x0, .LC91
	ldp	x25, x26, [sp, 64]
	add	x0, x0, :lo12:.LC91
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L1446:
	cbnz	w20, .L1441
	mov	w2, w19
	mov	x1, x26
	mov	x0, x23
	bl	printf
.L1441:
	cmp	w24, 4
	bne	.L1442
	ldr	w1, [x22, x19, lsl 2]
.L1448:
	mov	x0, x21
	add	w20, w20, 1
	bl	printf
	cmp	w20, 15
	bls	.L1445
	mov	w20, 0
	add	x1, x27, :lo12:.LC90
	adrp	x0, .LC91
	add	x0, x0, :lo12:.LC91
	bl	printf
.L1445:
	add	x19, x19, 1
	b	.L1440
.L1442:
	cmp	w24, 2
	bne	.L1444
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L1448
.L1444:
	ldrb	w1, [x22, x19]
	b	.L1448
	.size	rknand_print_hex, .-rknand_print_hex
	.section	.text.hynix_get_read_retry_default,"ax",@progbits
	.align	2
	.global	hynix_get_read_retry_default
	.type	hynix_get_read_retry_default, %function
hynix_get_read_retry_default:
	stp	x29, x30, [sp, -144]!
	mov	w2, -83
	mov	w1, -82
	add	x29, sp, 0
	stp	x27, x28, [sp, 80]
	stp	x21, x22, [sp, 32]
	str	w0, [x29, 140]
	adrp	x0, .LANCHOR26
	stp	x19, x20, [sp, 16]
	ldr	x28, [x0, #:lo12:.LANCHOR26]
	stp	x23, x24, [sp, 48]
	add	x0, x28, 112
	str	x0, [x29, 112]
	ldrb	w0, [x29, 140]
	add	x22, x28, 128
	stp	x25, x26, [sp, 64]
	strb	w0, [x28, 112]
	mov	w0, -84
	ldr	w3, [x29, 140]
	strb	w0, [x28, 128]
	mov	w0, -81
	strb	w2, [x28, 129]
	cmp	w3, 2
	strb	w1, [x28, 130]
	strb	w0, [x28, 131]
	bne	.L1450
	mov	w0, -89
	strb	w0, [x28, 128]
	adrp	x0, .LANCHOR150+17
	mov	w1, -9
	strb	w1, [x0, #:lo12:.LANCHOR150+17]
.L1505:
	mov	w0, 7
	b	.L1540
.L1450:
	ldr	w3, [x29, 140]
	cmp	w3, 3
	bne	.L1452
	mov	x6, 0
.L1453:
	sub	w0, w6, #80
	strb	w0, [x22, x6]
	add	x6, x6, 1
	cmp	x6, 8
	bne	.L1453
	stp	w6, w6, [x29, 132]
.L1451:
	ldr	w0, [x29, 140]
	sub	w0, w0, #1
	cmp	w0, 1
	bhi	.L1458
	adrp	x7, .LANCHOR18
	adrp	x11, .LANCHOR29
	add	x24, x7, :lo12:.LANCHOR18
	add	x25, x11, :lo12:.LANCHOR29
	mov	w20, 0
	mov	w26, 55
.L1459:
	ldrb	w0, [x24]
	cmp	w0, w20
	bhi	.L1465
.L1466:
	ldr	x0, [x29, 112]
	ldrb	w1, [x29, 136]
	strb	w1, [x0, 1]
	ldrb	w1, [x29, 132]
	strb	w1, [x0, 2]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1452:
	ldr	w3, [x29, 140]
	cmp	w3, 4
	bne	.L1454
	mov	w3, -52
	strb	w3, [x28, 128]
	mov	w3, -65
	strb	w3, [x28, 129]
	mov	w3, -86
	strb	w3, [x28, 130]
	mov	w3, -85
	strb	w0, [x28, 135]
	strb	w3, [x28, 131]
	mov	w0, 8
	mov	w3, -51
	strb	w2, [x28, 133]
	strb	w3, [x28, 132]
	strb	w1, [x28, 134]
	str	w0, [x29, 132]
.L1541:
	str	w0, [x29, 136]
	b	.L1451
.L1454:
	ldr	w0, [x29, 140]
	cmp	w0, 5
	bne	.L1455
	mov	w0, 56
	strb	w0, [x28, 128]
	mov	w0, 57
	strb	w0, [x28, 129]
	mov	w0, 58
	strb	w0, [x28, 130]
	mov	w0, 59
	strb	w0, [x28, 131]
	mov	w0, 8
.L1540:
	str	w0, [x29, 132]
	mov	w0, 4
	b	.L1541
.L1455:
	ldr	w0, [x29, 140]
	cmp	w0, 6
	bne	.L1456
	mov	w0, 14
	strb	w0, [x28, 128]
	mov	w0, 15
	strb	w0, [x28, 129]
	mov	w0, 16
	strb	w0, [x28, 130]
	mov	w0, 17
	strb	w0, [x28, 131]
	mov	w0, 12
	b	.L1540
.L1456:
	ldr	w0, [x29, 140]
	cmp	w0, 7
	bne	.L1505
	mov	x0, 0
.L1457:
	sub	w1, w0, #80
	strb	w1, [x22, x0]
	add	x0, x0, 1
	cmp	x0, 8
	bne	.L1457
	mov	w0, -44
	strb	w0, [x28, 136]
	mov	w0, -43
	strb	w0, [x28, 137]
	mov	w0, 12
	str	w0, [x29, 132]
	mov	w0, 10
	b	.L1541
.L1465:
	ldrb	w0, [x25, w20, sxtw]
	mov	x1, 32
	mov	w2, 160
	mov	x21, 0
	umaddl	x2, w2, w0, x1
	ldr	x1, [x29, 112]
	ubfiz	x0, x0, 8, 8
	add	x19, x1, x2
	adrp	x1, .LANCHOR13
	ldr	x4, [x1, #:lo12:.LANCHOR13]
	add	x23, x4, x0
.L1460:
	str	w26, [x23, 2056]
	ldrb	w0, [x22, x21]
	str	w0, [x23, 2052]
	mov	w0, 80
	bl	timer_delay_ns
	ldr	w0, [x23, 2048]
	strb	w0, [x19, x21]
	add	x21, x21, 1
	ldr	w0, [x29, 136]
	cmp	w0, w21, uxtb
	bhi	.L1460
	adrp	x3, .LANCHOR150
	add	x3, x3, :lo12:.LANCHOR150
	mov	x0, 0
.L1463:
	add	x15, x19, x0
	add	x14, x3, x0
	mov	x1, 1
.L1462:
	lsl	x4, x1, 2
	lsl	x16, x1, 3
	ldrb	w17, [x19, x0]
	add	x1, x1, 1
	cmp	x1, 7
	ldrb	w4, [x14, x4]
	add	w4, w4, w17
	strb	w4, [x15, x16]
	bne	.L1462
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L1463
	add	w5, w20, 1
	strb	wzr, [x19, 16]
	strb	wzr, [x19, 24]
	and	w20, w5, 255
	strb	wzr, [x19, 32]
	strb	wzr, [x19, 40]
	strb	wzr, [x19, 48]
	strb	wzr, [x19, 41]
	strb	wzr, [x19, 49]
	b	.L1459
.L1458:
	ldr	w0, [x29, 140]
	sub	w0, w0, #3
	cmp	w0, 4
	bhi	.L1466
	ldp	w0, w1, [x29, 132]
	adrp	x19, .LANCHOR18
	add	x19, x19, :lo12:.LANCHOR18
	sub	w13, w1, #1
	mul	w15, w0, w1
	and	x13, x13, 255
	asr	w0, w15, 2
	stp	w0, wzr, [x29, 124]
	lsl	w0, w15, 4
	str	w0, [x29, 120]
	ldr	w0, [x29, 124]
	lsl	w22, w0, 1
	sbfiz	x21, x0, 2, 32
	ldr	w0, [x29, 140]
	sub	w20, w0, #5
	add	x0, x13, 1
	str	x0, [x29, 96]
.L1467:
	ldrb	w0, [x19]
	ldr	w1, [x29, 128]
	cmp	w0, w1
	bls	.L1466
	ldr	w1, [x29, 128]
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	mov	w10, 160
	mov	w23, 255
	ldrb	w4, [x0, w1, sxtw]
	mov	x0, 32
	umaddl	x10, w10, w4, x0
	ldr	x0, [x29, 112]
	ubfiz	x4, x4, 8, 8
	add	x0, x0, x10
	str	x0, [x29, 104]
	adrp	x0, .LANCHOR13
	ldr	x0, [x0, #:lo12:.LANCHOR13]
	add	x27, x0, x4
	str	w23, [x27, 2056]
	bl	nandc_wait_flash_ready
	mov	w0, 54
	str	w0, [x27, 2056]
	ldr	w0, [x29, 140]
	cmp	w0, 4
	bne	.L1468
	mov	w0, 64
	str	w23, [x27, 2052]
	str	w0, [x27, 2048]
	mov	w0, 204
.L1542:
	str	w0, [x27, 2052]
	mov	w0, 77
	b	.L1543
.L1468:
	cmp	w20, 1
	bhi	.L1470
	ldrb	w0, [x28, 128]
	str	w0, [x27, 2052]
	mov	w0, 82
.L1543:
	str	w0, [x27, 2048]
	mov	w0, 22
	str	w0, [x27, 2056]
	mov	w0, 23
	str	w0, [x27, 2056]
	mov	w0, 4
	str	w0, [x27, 2056]
	mov	w0, 25
	str	w0, [x27, 2056]
	str	wzr, [x27, 2056]
	str	wzr, [x27, 2052]
	ldr	w0, [x29, 140]
	str	wzr, [x27, 2052]
	cmp	w0, 6
	bne	.L1471
	mov	w0, 31
	str	w0, [x27, 2052]
.L1472:
	mov	w23, 2
	str	w23, [x27, 2052]
	str	wzr, [x27, 2052]
	mov	w0, 48
	str	w0, [x27, 2056]
	bl	nandc_wait_flash_ready
	cmp	w20, 1
	bls	.L1506
	ldr	w0, [x29, 140]
	cmp	w0, 7
	mov	w0, 32
	csel	w23, w23, w0, ne
.L1473:
	adrp	x3, .LANCHOR151
	mov	x1, 0
	ldr	x0, [x3, #:lo12:.LANCHOR151]
.L1474:
	ldr	w2, [x27, 2048]
	strb	w2, [x0, x1]
	add	x1, x1, 1
	cmp	w23, w1, uxtb
	bhi	.L1474
	ldr	w1, [x29, 140]
	cmp	w1, 7
	bne	.L1475
	mov	w1, 0
.L1477:
	ldrb	w2, [x0]
	cmp	w2, 12
	beq	.L1476
	ldrb	w2, [x0, 1]
	cmp	w2, 10
	beq	.L1476
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1477
.L1478:
	adrp	x0, .LC92
	mov	w1, 0
	add	x0, x0, :lo12:.LC92
	bl	printf
.L1480:
	b	.L1480
.L1470:
	mov	w0, 174
	str	w0, [x27, 2052]
	str	wzr, [x27, 2048]
	mov	w0, 176
	b	.L1542
.L1471:
	str	wzr, [x27, 2052]
	b	.L1472
.L1506:
	mov	w23, 16
	b	.L1473
.L1476:
	cmp	w1, 6
	bhi	.L1478
.L1479:
	ldr	x2, [x3, #:lo12:.LANCHOR151]
	mov	x0, 0
.L1484:
	ldr	w1, [x29, 120]
	cmp	w1, w0
	bgt	.L1485
	ldr	x1, [x3, #:lo12:.LANCHOR151]
	mov	w16, 8
	add	x3, x1, x21
.L1487:
	mov	x0, 0
.L1486:
	ldr	w17, [x3, x0, lsl 2]
	ldr	w4, [x29, 124]
	mvn	w17, w17
	str	w17, [x3, x0, lsl 2]
	add	x0, x0, 1
	cmp	w4, w0
	bgt	.L1486
	add	x3, x3, x22, uxtw 2
	subs	w16, w16, #1
	bne	.L1487
	mov	x17, x1
	mov	w23, 0
	mov	w26, 1
.L1488:
	mov	w3, 0
	mov	w0, 0
.L1492:
	mov	x25, x17
	lsl	w16, w26, w0
	mov	w24, 16
	mov	w30, 0
.L1490:
	ldr	w4, [x25]
	add	x25, x25, x21
	bics	wzr, w16, w4
	cinc	w30, w30, eq
	subs	w24, w24, #1
	bne	.L1490
	cmp	w30, 9
	orr	w16, w3, w16
	add	w0, w0, 1
	csel	w3, w16, w3, cs
	cmp	w0, 32
	bne	.L1492
	ldr	w0, [x29, 124]
	add	w23, w23, 1
	str	w3, [x17], 4
	cmp	w0, w23
	bgt	.L1488
	mov	x0, 0
	mov	w3, 0
.L1495:
	ldr	w16, [x1, x0]
	add	x0, x0, 4
	cmp	w16, 0
	cinc	w3, w3, eq
	cmp	x0, 32
	bne	.L1495
	cmp	w3, 7
	ble	.L1496
	mov	w3, 1024
	mov	w2, 1
	adrp	x0, .LC93
	add	x0, x0, :lo12:.LC93
	bl	rknand_print_hex
	adrp	x0, .LC92
	mov	w1, 0
	add	x0, x0, :lo12:.LC92
	bl	printf
.L1497:
	b	.L1497
.L1475:
	ldr	w1, [x29, 140]
	cmp	w1, 6
	bne	.L1479
	mov	x1, 0
.L1481:
	ldrb	w2, [x0, x1]
	cmp	w2, 12
	beq	.L1479
	add	x2, x0, x1
	ldrb	w2, [x2, 8]
	cmp	w2, 4
	beq	.L1479
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L1481
	adrp	x0, .LC92
	mov	w1, 0
	add	x0, x0, :lo12:.LC92
	bl	printf
.L1483:
	b	.L1483
.L1485:
	ldr	w1, [x27, 2048]
	strb	w1, [x2, x0]
	add	x0, x0, 1
	b	.L1484
.L1496:
	ldr	w0, [x29, 140]
	cmp	w0, 6
	beq	.L1508
	cmp	w0, 7
	mov	x1, 10
	mov	x0, 8
	csel	x0, x0, x1, ne
.L1498:
	ldr	x10, [x29, 104]
	mov	w3, 0
.L1499:
	mov	x1, 0
.L1500:
	ldrb	w16, [x2, x1]
	ldr	w4, [x29, 136]
	strb	w16, [x10, x1]
	add	x1, x1, 1
	cmp	w4, w1, uxtb
	bhi	.L1500
	ldr	x1, [x29, 96]
	add	w3, w3, 1
	add	x10, x10, x0
	add	x2, x2, x1
	ldr	w1, [x29, 132]
	cmp	w1, w3
	bgt	.L1499
	mov	w23, 255
	str	w23, [x27, 2056]
	bl	nandc_wait_flash_ready
	cmp	w20, 1
	bhi	.L1502
	mov	w0, 54
	str	w0, [x27, 2056]
	ldrb	w0, [x28, 128]
	str	w0, [x27, 2052]
	str	wzr, [x27, 2048]
	mov	w0, 22
	str	w0, [x27, 2056]
	mov	w0, 48
	str	wzr, [x27, 2056]
	str	wzr, [x27, 2052]
	str	wzr, [x27, 2052]
	str	w23, [x27, 2052]
	str	w23, [x27, 2052]
	str	w23, [x27, 2052]
.L1544:
	str	w0, [x27, 2056]
	bl	nandc_wait_flash_ready
	ldr	w0, [x29, 128]
	add	w11, w0, 1
	and	w0, w11, 255
	str	w0, [x29, 128]
	b	.L1467
.L1508:
	mov	x0, 4
	b	.L1498
.L1502:
	mov	w0, 56
	b	.L1544
	.size	hynix_get_read_retry_default, .-hynix_get_read_retry_default
	.section	.text.flash_get_read_retry_tbl,"ax",@progbits
	.align	2
	.global	flash_get_read_retry_tbl
	.type	flash_get_read_retry_tbl, %function
flash_get_read_retry_tbl:
	adrp	x0, .LANCHOR34+19
	ldrb	w0, [x0, #:lo12:.LANCHOR34+19]
	sub	w1, w0, #1
	and	w1, w1, 255
	cmp	w1, 6
	bhi	.L1545
	b	hynix_get_read_retry_default
.L1545:
	ret
	.size	flash_get_read_retry_tbl, .-flash_get_read_retry_tbl
	.section	.text.nandc_xfer_done,"ax",@progbits
	.align	2
	.global	nandc_xfer_done
	.type	nandc_xfer_done, %function
nandc_xfer_done:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR152
	adrp	x1, .LANCHOR27
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR13
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w1, 9
	strb	wzr, [x0, #:lo12:.LANCHOR152]
	bne	.L1548
	ldr	x20, [x19, #:lo12:.LANCHOR13]
	mov	x24, x0
	mov	w21, 0
	ldr	w0, [x20, 16]
	str	w0, [x29, 64]
	ldr	w0, [x20, 48]
	tbnz	x0, 1, .L1549
	adrp	x22, .LC97
	adrp	x23, .LC96
	add	x22, x22, :lo12:.LC97
	add	x23, x23, :lo12:.LC96
.L1550:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1553
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 16]
	str	w0, [x29, 64]
	bne	.L1550
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
	b	.L1550
.L1549:
	adrp	x22, .LC95
	adrp	x23, .LC96
	add	x22, x22, :lo12:.LC95
	add	x23, x23, :lo12:.LC96
.L1551:
	ldr	w1, [x20, 64]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 6
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L1553
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1552
	ldr	w0, [x29, 72]
	tbz	x0, 17, .L1552
	ldr	w1, [x29, 72]
	adrp	x0, .LC94
	add	x0, x0, :lo12:.LC94
	ubfx	x1, x1, 17, 1
.L1585:
	bl	printf
	b	.L1553
.L1552:
	ldr	w0, [x29, 64]
	add	w21, w21, 1
	ubfx	x0, x0, 22, 6
	cmp	w21, w0, lsl 12
	bne	.L1551
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
	tbz	x0, 13, .L1551
	mov	w0, 1
	strb	w0, [x24, #:lo12:.LANCHOR152]
.L1553:
	adrp	x0, .LANCHOR46+32
	ldp	x19, x20, [sp, 16]
	str	wzr, [x0, #:lo12:.LANCHOR46+32]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1548:
	ldr	x20, [x19, #:lo12:.LANCHOR13]
	mov	w21, 0
	ldr	w0, [x20, 8]
	str	w0, [x29, 64]
	ldr	w0, [x20, 16]
	tbnz	x0, 1, .L1559
	adrp	x22, .LC97
	adrp	x23, .LC96
	add	x22, x22, :lo12:.LC97
	add	x23, x23, :lo12:.LC96
.L1560:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1553
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 8]
	str	w0, [x29, 64]
	bne	.L1560
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
	b	.L1560
.L1559:
	adrp	x22, .LC95
	adrp	x23, .LC96
	add	x22, x22, :lo12:.LC95
	add	x23, x23, :lo12:.LC96
.L1561:
	ldr	w1, [x20, 28]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 5
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L1553
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1562
	ldr	w0, [x29, 72]
	tbz	x0, 17, .L1562
	adrp	x0, .LC98
	ldr	w1, [x29, 72]
	add	x0, x0, :lo12:.LC98
	b	.L1585
.L1562:
	add	w21, w21, 1
	tst	x21, 16777215
	bne	.L1561
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
	b	.L1561
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
	cbnz	w22, .L1605
	adrp	x0, .LANCHOR27
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
	cmp	w0, 9
	bne	.L1588
	adrp	x22, .LANCHOR13
	lsr	w19, w19, 2
	mov	w3, 1
	mov	w2, 0
	ldr	x5, [x22, #:lo12:.LANCHOR13]
	mov	w0, 0
.L1589:
	cmp	w2, w19
	bcc	.L1593
	ldr	w19, [x5]
	cmp	w3, 0
	mov	w1, 512
	csel	w0, w0, w1, eq
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1595
	mov	w1, w19
	adrp	x0, .LC99
	add	x0, x0, :lo12:.LC99
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	orr	w19, w19, 131072
	str	w19, [x0]
	mov	w0, -1
.L1595:
	tbz	x19, 13, .L1596
	adrp	x1, .LANCHOR152
	ldrb	w1, [x1, #:lo12:.LANCHOR152]
	cbz	w1, .L1596
	mov	w1, w19
	adrp	x0, .LC100
	add	x0, x0, :lo12:.LC100
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	mov	w1, 1
	str	w1, [x0, 16]
.L1624:
	mov	w0, -1
.L1587:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1593:
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
	tbnz	x1, 2, .L1607
	ldr	w1, [x29, 56]
	tbnz	x1, 18, .L1607
	ldr	w4, [x29, 56]
	ldr	w1, [x29, 56]
	ubfx	x4, x4, 3, 7
	ubfx	x1, x1, 19, 7
	cmp	w4, w1
	ldr	w1, [x29, 56]
	ble	.L1591
	ubfx	x1, x1, 3, 7
.L1592:
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1590:
	add	w2, w2, 1
	b	.L1589
.L1591:
	ubfx	x1, x1, 19, 7
	b	.L1592
.L1607:
	mov	w0, -1
	b	.L1590
.L1588:
	adrp	x0, .LANCHOR43
	lsr	w4, w19, 1
	mov	w3, 64
	mov	w1, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	mov	w2, 0
	adrp	x6, .LANCHOR46
	cmp	w0, 25
	mov	w0, 128
	csel	w3, w3, w0, cc
	mov	w0, 0
.L1598:
	add	w5, w3, w0
	cmp	w2, w4
	bcc	.L1599
	adrp	x22, .LANCHOR13
	lsr	w19, w19, 2
	mov	w3, 0
	mov	w0, 0
	ldr	x4, [x22, #:lo12:.LANCHOR13]
.L1600:
	cmp	w3, w19
	bcc	.L1604
	str	wzr, [x4, 16]
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	ldr	w19, [x4]
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1596
	mov	w1, w19
	adrp	x0, .LC101
	add	x0, x0, :lo12:.LC101
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	orr	w19, w19, 131072
	str	w19, [x0]
	b	.L1624
.L1599:
	ldr	x7, [x6, #:lo12:.LANCHOR46]
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
	b	.L1598
.L1604:
	uxtw	x1, w3
	add	x1, x1, 8
	ldr	w1, [x4, x1, lsl 2]
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	tbnz	x1, 2, .L1610
	ldr	w1, [x29, 56]
	tbnz	x1, 15, .L1610
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
	bls	.L1602
	ubfx	x2, x1, 3, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 27, 1
.L1623:
	orr	w1, w2, w1, lsl 5
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1601:
	add	w3, w3, 1
	b	.L1600
.L1602:
	ubfx	x2, x1, 16, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 29, 1
	b	.L1623
.L1610:
	mov	w0, -1
	b	.L1601
.L1596:
	cmn	w0, #1
	beq	.L1587
	ldr	w1, [x21]
	cmn	w1, #1
	bne	.L1587
	ldr	w1, [x21, 4]
	cmn	w1, #1
	bne	.L1587
	ldr	w1, [x20]
	cmn	w1, #1
	mov	w1, 512
	csel	w0, w0, w1, ne
	b	.L1587
.L1605:
	mov	w0, 0
	b	.L1587
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
	tbz	x0, 4, .L1626
	mov	w3, w1
	adrp	x0, .LC102
	mov	w2, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC102
	bl	printf
.L1626:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	nandc_cs
	adrp	x6, .LANCHOR16
	cbnz	w23, .L1627
	mov	w0, w21
	bl	zftl_flash_enter_slc_mode
.L1628:
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
	ldr	x0, [x6, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1630
	cbz	w23, .L1630
	add	w20, w20, w20, lsl 1
	sub	w0, w20, #1
	add	w0, w0, w23
.L1639:
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
.L1627:
	ldr	x0, [x6, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1629
	sxtw	x0, w21
	add	x0, x0, 8
	add	x0, x19, x0, lsl 8
	str	w23, [x0, 8]
	b	.L1628
.L1629:
	mov	w0, w21
	bl	zftl_flash_exit_slc_mode
	b	.L1628
.L1630:
	mov	w0, w20
	b	.L1639
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
	adrp	x0, .LANCHOR43
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	mov	w22, w1
	stp	x25, x26, [sp, 64]
	mov	x25, x2
	stp	x27, x28, [sp, 80]
	mov	x26, x3
	ldrb	w20, [x0, #:lo12:.LANCHOR43]
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
	adrp	x0, .LANCHOR154
	add	x0, x0, :lo12:.LANCHOR154
	str	x0, [x29, 104]
	ldr	x0, [x29, 120]
	add	x23, x0, x19, lsl 8
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	str	x0, [x29, 96]
.L1641:
	ldr	x0, [x29, 104]
	ldrb	w0, [x0]
	cmp	w21, w0
	bcc	.L1646
.L1645:
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
	bcc	.L1647
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L1647:
	cmp	w28, 256
	ccmn	w28, #1, 4, ne
	bne	.L1640
	adrp	x0, .LC104
	mov	w4, w28
	mov	w3, w21
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC104
	bl	printf
.L1640:
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1646:
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
	tbz	x0, 12, .L1642
	str	w7, [x29, 112]
	mov	w4, w28
	mov	w3, w21
	mov	w2, w22
	mov	w1, w21
	adrp	x0, .LC103
	add	x0, x0, :lo12:.LC103
	bl	printf
	ldr	w7, [x29, 112]
.L1642:
	cmn	w7, #1
	beq	.L1643
	adrp	x0, .LANCHOR151
	cmn	w28, #1
	csel	w28, w28, w7, ne
	cmp	w7, w20
	ldr	x25, [x0, #:lo12:.LANCHOR151]
	adrp	x0, .LANCHOR153
	ldr	x26, [x0, #:lo12:.LANCHOR153]
	bcc	.L1649
.L1643:
	mov	w21, w27
	b	.L1641
.L1649:
	mov	w28, w7
	b	.L1645
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
	adrp	x22, .LANCHOR23
	mov	w1, 46
	mov	w2, 56
	ldr	x25, [x0, #:lo12:.LANCHOR13]
	and	x0, x24, 255
	add	x21, x0, 8
	str	x0, [x29, 128]
	ldrb	w0, [x22, #:lo12:.LANCHOR23]
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
	add	x0, x22, :lo12:.LANCHOR23
	cbnz	w4, .L1664
	str	x0, [x29, 120]
	sxtw	x0, w24
	add	x0, x0, 8
	add	x0, x25, x0, lsl 8
	str	x0, [x29, 112]
.L1671:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, 36
	bne	.L1665
	mov	w1, w20
	mov	x0, x21
	mov	w2, 0
	bl	toshiba_tlc_set_rr_para
	ldr	x1, [x29, 112]
	mov	w0, 93
	str	w0, [x1, 8]
.L1666:
	mov	w4, w28
	mov	x3, x27
	mov	x2, x26
	mov	w1, w23
	mov	w0, w24
	bl	flash_read_page
	mov	w4, w0
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 4, .L1667
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC105
	add	x0, x0, :lo12:.LC105
	bl	printf
	ldr	w4, [x29, 108]
.L1667:
	cmn	w4, #1
	beq	.L1668
	adrp	x0, .LANCHOR151
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x26, [x0, #:lo12:.LANCHOR151]
	adrp	x0, .LANCHOR153
	ldr	x27, [x0, #:lo12:.LANCHOR153]
	adrp	x0, .LANCHOR43
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1686
.L1668:
	ldr	w0, [x29, 136]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1671
.L1670:
	ldrb	w0, [x22, #:lo12:.LANCHOR23]
	cmp	w0, 36
	bne	.L1672
	mov	w2, 0
.L1709:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_tlc_set_rr_para
	b	.L1673
.L1665:
	mov	w1, w20
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
	b	.L1666
.L1686:
	mov	w19, w4
	b	.L1670
.L1672:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
.L1673:
	ldrb	w0, [x22, #:lo12:.LANCHOR23]
	cmp	w0, 36
	bne	.L1682
	ldr	x0, [x29, 128]
	add	x25, x25, x0, lsl 8
	mov	w0, 85
	str	w0, [x25, 2056]
	mov	w0, 255
	str	wzr, [x25, 2052]
	str	wzr, [x25, 2048]
	str	w0, [x25, 2056]
.L1682:
	adrp	x0, .LANCHOR43
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1683
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1683:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1684
	adrp	x0, .LC107
	mov	w4, w19
	mov	w3, w20
	mov	w2, w23
	mov	w1, w20
	add	x0, x0, :lo12:.LC107
	bl	printf
.L1684:
	bl	nandc_wait_flash_ready
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1664:
	str	x0, [x29, 112]
	sxtw	x0, w24
	add	x0, x0, 8
	add	x0, x25, x0, lsl 8
	str	x0, [x29, 136]
.L1680:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cmp	w0, 36
	bne	.L1674
	mov	x0, x21
	mov	w2, 1
	mov	w1, w20
	bl	toshiba_tlc_set_rr_para
	mov	w0, 93
.L1708:
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
	tbz	x0, 4, .L1676
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC106
	add	x0, x0, :lo12:.LC106
	bl	printf
	ldr	w4, [x29, 108]
.L1676:
	cmn	w4, #1
	beq	.L1677
	adrp	x0, .LANCHOR151
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x26, [x0, #:lo12:.LANCHOR151]
	adrp	x0, .LANCHOR153
	ldr	x27, [x0, #:lo12:.LANCHOR153]
	adrp	x0, .LANCHOR43
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1687
.L1677:
	ldr	w0, [x29, 120]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1680
.L1679:
	ldrb	w0, [x22, #:lo12:.LANCHOR23]
	cmp	w0, 36
	bne	.L1681
	mov	w2, 1
	b	.L1709
.L1674:
	mov	x0, x21
	mov	w1, w20
	bl	toshiba_3d_set_tlc_rr_para
	mov	w0, 38
	b	.L1708
.L1687:
	mov	w19, w4
	b	.L1679
.L1681:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_tlc_rr_para
	b	.L1673
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
	adrp	x1, .LANCHOR23
	str	x1, [x29, 120]
	ldr	x22, [x0, #:lo12:.LANCHOR13]
	and	x0, x19, 255
	add	x21, x0, 8
	str	x0, [x29, 104]
	ldrb	w0, [x1, #:lo12:.LANCHOR23]
	add	x21, x22, x21, lsl 8
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	bls	.L1728
	adrp	x0, .LANCHOR20
	ldrb	w0, [x0, #:lo12:.LANCHOR20]
	cbz	w0, .L1729
	mov	w23, 1
	mov	w0, 1
	bl	nandc_set_if_mode
.L1712:
	and	x0, x19, 255
	mov	w1, 92
	add	x0, x22, x0, lsl 8
	str	w1, [x0, 2056]
	mov	w1, 197
	str	w1, [x0, 2056]
.L1711:
	sxtw	x0, w19
	mov	w20, 1
	add	x0, x0, 8
	mov	w24, -1
	add	x0, x22, x0, lsl 8
	str	x0, [x29, 96]
.L1713:
	adrp	x0, .LANCHOR154
	ldrb	w0, [x0, #:lo12:.LANCHOR154]
	add	w0, w0, 1
	cmp	w20, w0
	bcc	.L1722
	mov	w28, w24
.L1721:
	ldr	x0, [x29, 120]
	mov	w1, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR23]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1723
	bl	sandisk_set_rr_para
.L1724:
	sxtw	x19, w19
	mov	w0, 255
	add	x19, x19, 8
	add	x22, x22, x19, lsl 8
	str	w0, [x22, 8]
	adrp	x0, .LANCHOR43
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L1725
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L1725:
	cmp	w28, 256
	ccmn	w28, #1, 4, ne
	bne	.L1726
	adrp	x0, .LC107
	mov	w4, w28
	mov	w3, w20
	mov	w2, w25
	mov	w1, w20
	add	x0, x0, :lo12:.LC107
	bl	printf
.L1726:
	bl	nandc_wait_flash_ready
	cbz	w23, .L1710
	mov	w0, 4
	bl	nandc_set_if_mode
.L1710:
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1729:
	mov	w23, 0
	b	.L1712
.L1728:
	mov	w23, 0
	b	.L1711
.L1722:
	ldr	x0, [x29, 120]
	mov	w1, w20
	ldrb	w0, [x0, #:lo12:.LANCHOR23]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1714
	bl	sandisk_set_rr_para
.L1715:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0, #:lo12:.LANCHOR23]
	cmp	w0, 34
	bne	.L1716
	adrp	x0, .LANCHOR154
	ldrb	w0, [x0, #:lo12:.LANCHOR154]
	sub	w0, w0, #3
	cmp	w20, w0
	bne	.L1716
	ldr	x1, [x29, 96]
	mov	w0, 179
	str	w0, [x1, 8]
.L1716:
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
	beq	.L1719
	cmn	w24, #1
	csel	w24, w24, w0, ne
	adrp	x0, .LANCHOR151
	ldr	x26, [x0, #:lo12:.LANCHOR151]
	adrp	x0, .LANCHOR153
	ldr	x27, [x0, #:lo12:.LANCHOR153]
	adrp	x0, .LANCHOR43
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L1721
.L1719:
	add	w20, w20, 1
	b	.L1713
.L1714:
	bl	toshiba_set_rr_para
	b	.L1715
.L1723:
	bl	toshiba_set_rr_para
	b	.L1724
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
	adrp	x0, .LANCHOR26
	stp	x27, x28, [sp, 80]
	stp	x21, x22, [sp, 32]
	mov	w27, w4
	ldr	x28, [x0, #:lo12:.LANCHOR26]
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
	adrp	x6, .LANCHOR43
	add	x6, x6, :lo12:.LANCHOR43
	mov	w5, 0
	adrp	x7, .LANCHOR151
	adrp	x8, .LANCHOR153
.L1743:
	cmp	w5, w24
	bcc	.L1748
.L1747:
	adrp	x0, .LANCHOR43
	add	x23, x28, x23
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	strb	w20, [x23, 8]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1749
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1749:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1742
	adrp	x0, .LC108
	mov	w4, w19
	mov	w3, w5
	mov	w2, w22
	mov	w1, w5
	add	x0, x0, :lo12:.LC108
	bl	printf
.L1742:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1748:
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
	beq	.L1745
	ldrb	w1, [x6]
	cmn	w19, #1
	csel	w19, w19, w0, ne
	ldr	x25, [x7, #:lo12:.LANCHOR151]
	ldr	x26, [x8, #:lo12:.LANCHOR153]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L1751
.L1745:
	add	w5, w5, 1
	b	.L1743
.L1751:
	mov	w19, w0
	b	.L1747
	.size	hynix_read_retrial, .-hynix_read_retrial
	.section	.text.flash_ddr_tuning_read,"ax",@progbits
	.align	2
	.global	flash_ddr_tuning_read
	.type	flash_ddr_tuning_read, %function
flash_ddr_tuning_read:
	stp	x29, x30, [sp, -144]!
	and	w0, w0, 255
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	stp	x21, x22, [sp, 32]
	adrp	x21, .LC109
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR43
	stp	x25, x26, [sp, 64]
	add	x21, x21, :lo12:.LC109
	stp	x27, x28, [sp, 80]
	mov	x26, x3
	str	w4, [x29, 120]
	add	x22, x22, :lo12:.LANCHOR43
	str	x2, [x29, 128]
	mov	w28, 0
	str	w0, [x29, 136]
	bl	nandc_get_ddr_para
	mov	w23, 0
	str	w0, [x29, 124]
	mov	w24, 0
	adrp	x0, .LANCHOR14
	mov	w27, 1024
	add	x0, x0, :lo12:.LANCHOR14
	mov	w25, 6
	mov	w19, -1
	str	wzr, [x29, 140]
	str	x0, [x29, 112]
.L1767:
	mov	w0, w25
	bl	nandc_set_ddr_para
	ldr	w4, [x29, 120]
	mov	x3, x26
	ldrb	w0, [x29, 136]
	mov	w1, w20
	ldr	x2, [x29, 128]
	bl	flash_read_page
	mov	w4, w0
	ldr	x0, [x29, 112]
	ldr	w0, [x0]
	tbz	x0, 4, .L1762
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w20
	mov	w1, w25
	mov	x0, x21
	bl	printf
	ldr	w4, [x29, 108]
.L1762:
	add	w0, w27, 1
	cmp	w4, w0
	bhi	.L1763
	adrp	x0, .LANCHOR151
	ldr	x0, [x0, #:lo12:.LANCHOR151]
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR153
	ldr	x26, [x0, #:lo12:.LANCHOR153]
	ldrb	w0, [x22]
	cmp	w4, w0, lsr 2
	bcs	.L1772
	add	w24, w24, 1
	cmp	w24, 7
	bls	.L1772
	sub	w28, w25, w24
	mov	w27, w4
	mov	w19, 0
.L1765:
	ldr	w0, [x29, 140]
	cmp	w24, w23
	csel	w28, w28, w0, cs
.L1766:
	cbz	w28, .L1768
	adrp	x0, .LANCHOR43
	mov	w1, 3
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	udiv	w0, w0, w1
	cmp	w0, w27
	bls	.L1768
	mov	w1, w28
	adrp	x0, .LC110
	add	x0, x0, :lo12:.LC110
	bl	printf
	mov	w0, w28
.L1782:
	bl	nandc_set_ddr_para
	cbz	w19, .L1761
	ldr	w1, [x29, 136]
	adrp	x0, .LC111
	mov	w2, w20
	add	x0, x0, :lo12:.LC111
	mov	w27, w19
	bl	printf
.L1761:
	mov	w0, w27
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1763:
	cmp	w24, w23
	bls	.L1773
	sub	w0, w28, w24
	str	w0, [x29, 140]
	cmp	w24, 7
	bhi	.L1766
	mov	w23, w24
.L1773:
	mov	w24, 0
	b	.L1764
.L1772:
	mov	w28, w25
	mov	w27, w4
	mov	w19, 0
.L1764:
	add	w25, w25, 2
	cmp	w25, 50
	bne	.L1767
	b	.L1765
.L1768:
	ldrb	w0, [x29, 124]
	b	.L1782
	.size	flash_ddr_tuning_read, .-flash_ddr_tuning_read
	.section	.text.flash_read_page_en,"ax",@progbits
	.align	2
	.global	flash_read_page_en
	.type	flash_read_page_en, %function
flash_read_page_en:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w21, w0, 255
	adrp	x0, .LANCHOR18
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	mov	x22, x2
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	str	x27, [sp, 80]
	mov	x23, x3
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	mov	w24, w4
	ubfx	x26, x19, 24, 2
	mov	x25, x0
	cmp	w1, w21
	bhi	.L1784
	adrp	x1, .LANCHOR155
	adrp	x0, .LC0
	mov	w2, 377
	add	x1, x1, :lo12:.LANCHOR155
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1784:
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	ldrb	w20, [x0, w21, sxtw]
	ldrb	w0, [x25, #:lo12:.LANCHOR18]
	cmp	w0, w21
	bcs	.L1785
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 6, .L1785
	adrp	x0, .LC112
	mov	w3, w19
	mov	w2, w21
	mov	w1, w20
	add	x0, x0, :lo12:.LC112
	bl	printf
.L1785:
	cbnz	w26, .L1786
	adrp	x0, .LANCHOR0
	adrp	x1, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L1787
	ldrb	w0, [x1, #:lo12:.LANCHOR1]
	cbz	w0, .L1786
.L1787:
	adrp	x0, .LANCHOR2
	ldrb	w1, [x1, #:lo12:.LANCHOR1]
	ldrh	w2, [x0, #:lo12:.LANCHOR2]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L1788
	add	w19, w0, w19, lsl 1
.L1786:
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w20
	bl	flash_read_page
	mov	w21, w0
	cmn	w0, #1
	bne	.L1783
	adrp	x25, .LANCHOR45
	mov	x26, x25
	ldrb	w27, [x25, #:lo12:.LANCHOR45]
	cbnz	w27, .L1790
.L1793:
	adrp	x0, .LANCHOR156
	ldr	x5, [x0, #:lo12:.LANCHOR156]
	cbnz	x5, .L1791
.L1792:
	ldrb	w4, [x26, #:lo12:.LANCHOR45]
	mov	w3, -1
	mov	w2, w19
	mov	w1, 0
	adrp	x0, .LC113
	add	x0, x0, :lo12:.LC113
	bl	printf
	adrp	x0, .LANCHOR20
	ldrb	w0, [x0, #:lo12:.LANCHOR20]
	cbz	w0, .L1783
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w20
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	b	flash_ddr_tuning_read
.L1788:
	adrp	x1, .LANCHOR3
	add	x1, x1, :lo12:.LANCHOR3
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
	b	.L1786
.L1790:
	strb	wzr, [x25, #:lo12:.LANCHOR45]
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w20
	bl	flash_read_page
	strb	w27, [x25, #:lo12:.LANCHOR45]
	cmn	w0, #1
	beq	.L1793
.L1811:
	mov	w21, w0
.L1783:
	mov	w0, w21
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1791:
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w20
	blr	x5
	cmn	w0, #1
	beq	.L1792
	b	.L1811
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
	adrp	x0, .LANCHOR135
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	mov	x24, x2
	ldrh	w19, [x0, #:lo12:.LANCHOR135]
	adrp	x0, .LANCHOR34+26
	stp	x21, x22, [sp, 32]
	and	w21, w1, 65535
	ldrh	w26, [x0, #:lo12:.LANCHOR34+26]
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
	bne	.L1813
	mov	w27, 0
	mov	w28, 2
.L1814:
	cmp	w27, w19
	ble	.L1817
.L1813:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L1818
	ldr	w3, [x22]
	adrp	x0, .LC114
	mov	w2, w19
	mov	w1, w21
	add	x0, x0, :lo12:.LC114
	bl	printf
.L1818:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1817:
	add	w20, w27, w19
	mov	w4, w25
	mov	x3, x22
	mov	x2, x24
	mov	w0, w23
	sdiv	w20, w20, w28
	add	w1, w26, w20, sxth
	bl	flash_read_page_en
	cmp	w0, 512
	bne	.L1815
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L1814
.L1815:
	add	w20, w20, 1
	sxth	w27, w20
	b	.L1814
	.size	flash_get_last_written_page, .-flash_get_last_written_page
	.section	.text.flash_get_last_written_page_ext,"ax",@progbits
	.align	2
	.global	flash_get_last_written_page_ext
	.type	flash_get_last_written_page_ext, %function
flash_get_last_written_page_ext:
	adrp	x4, .LANCHOR99
	mov	w6, 21
	and	w0, w0, 65535
	mov	w5, 1
	ldrh	w4, [x4, #:lo12:.LANCHOR99]
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
	adrp	x20, .LANCHOR26
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	tbz	x0, 12, .L1825
	ldr	x4, [x20, #:lo12:.LANCHOR26]
	adrp	x2, .LANCHOR157
	adrp	x0, .LC115
	mov	w3, 2048
	add	x2, x2, :lo12:.LANCHOR157
	mov	w1, 49
	add	x0, x0, :lo12:.LC115
	bl	printf
.L1825:
	adrp	x21, .LANCHOR158
	adrp	x23, .LANCHOR2
	mov	w24, 21321
	add	x26, x23, :lo12:.LANCHOR2
	mov	x22, x21
	mov	w19, 4
	movk	w24, 0x5359, lsl 16
.L1828:
	ldrh	w1, [x26]
	mov	w4, 4
	ldr	x3, [x21, #:lo12:.LANCHOR158]
	mov	w0, 0
	ldr	x2, [x20, #:lo12:.LANCHOR26]
	add	x27, x21, :lo12:.LANCHOR158
	add	x25, x20, :lo12:.LANCHOR26
	mul	w1, w1, w19
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1826
	ldr	x2, [x20, #:lo12:.LANCHOR26]
	ldr	w0, [x2]
	cmp	w0, w24
	beq	.L1827
.L1826:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L1828
.L1852:
	mov	w0, -1
.L1824:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1836:
	ldr	x0, [x25]
	ldr	w1, [x0]
	cmp	w1, w24
	bne	.L1837
	ldr	w19, [x0, 4]
.L1830:
	add	x24, x21, :lo12:.LANCHOR159
	ldrh	w0, [x23, #:lo12:.LANCHOR2]
	ldr	x3, [x22, #:lo12:.LANCHOR158]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR26]
	ldrb	w1, [x24, 1]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1831
	ldr	x0, [x20, #:lo12:.LANCHOR26]
	mov	w1, 21321
	movk	w1, 0x5359, lsl 16
	ldr	w2, [x0]
	cmp	w2, w1
	bne	.L1831
	ldr	w1, [x0, 4]
	cmp	w19, w1
	bcs	.L1831
	ldrb	w1, [x0, 37]
	ldrb	w0, [x0, 36]
	strb	w1, [x21, #:lo12:.LANCHOR159]
	strb	w0, [x24, 1]
.L1831:
	ldrb	w1, [x21, #:lo12:.LANCHOR159]
	add	x24, x21, :lo12:.LANCHOR159
	ldr	x3, [x22, #:lo12:.LANCHOR158]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR26]
	mov	w0, 0
	bl	flash_get_last_written_page
	sxth	w19, w0
	add	w0, w0, 1
	ldrb	w21, [x21, #:lo12:.LANCHOR159]
	strh	w0, [x24, 2]
	ldrh	w0, [x23, #:lo12:.LANCHOR2]
	mov	w23, 21321
	movk	w23, 0x5359, lsl 16
	madd	w21, w21, w0, w19
.L1832:
	tbz	w19, #31, .L1834
	cmn	w19, #1
	bne	.L1835
	ldr	x0, [x20, #:lo12:.LANCHOR26]
	ldr	w1, [x0]
	adrp	x0, .LC116
	add	x0, x0, :lo12:.LC116
	bl	printf
	b	.L1852
.L1834:
	ldr	x3, [x22, #:lo12:.LANCHOR158]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR26]
	mov	w1, w21
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1833
	ldr	x0, [x20, #:lo12:.LANCHOR26]
	ldr	w0, [x0]
	cmp	w0, w23
	bne	.L1833
.L1835:
	mov	w0, 0
	b	.L1824
.L1833:
	sub	w19, w19, #1
	sub	w21, w21, #1
	sxth	w19, w19
	b	.L1832
.L1827:
	adrp	x21, .LANCHOR159
	add	x1, x21, :lo12:.LANCHOR159
	ldrb	w3, [x2, 37]
	mov	w4, 4
	ldrb	w0, [x2, 36]
	strb	w3, [x1, 1]
	ldrh	w1, [x26]
	ldr	x3, [x27]
	strb	w0, [x21, #:lo12:.LANCHOR159]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	bne	.L1836
.L1837:
	mov	w19, 0
	b	.L1830
	.size	flash_info_blk_init, .-flash_info_blk_init
	.section	.text.flash_ddr_para_scan,"ax",@progbits
	.align	2
	.global	flash_ddr_para_scan
	.type	flash_ddr_para_scan, %function
flash_ddr_para_scan:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR42
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	ldrb	w0, [x20, #:lo12:.LANCHOR42]
	adrp	x19, .LANCHOR20
	stp	x23, x24, [sp, 48]
	mov	w21, 1
	mov	w23, w1
	str	x25, [sp, 64]
	strb	w21, [x19, #:lo12:.LANCHOR20]
	adrp	x24, .LANCHOR161
	bl	flash_set_interface_mode
	adrp	x25, .LANCHOR160
	ldrb	w0, [x20, #:lo12:.LANCHOR42]
	bl	nandc_set_if_mode
	ldr	x3, [x25, #:lo12:.LANCHOR160]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR161]
	mov	w1, w23
	mov	w0, w22
	bl	flash_ddr_tuning_read
	ldr	x3, [x25, #:lo12:.LANCHOR160]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR161]
	mov	w1, w23
	mov	w0, w22
	bl	flash_read_page
	cmn	w0, #1
	mov	x0, x19
	bne	.L1854
	ldrb	w1, [x20, #:lo12:.LANCHOR42]
	tbz	x1, 0, .L1854
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, w21
	bl	nandc_set_if_mode
	strb	wzr, [x19, #:lo12:.LANCHOR20]
.L1855:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1854:
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR20]
	b	.L1855
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
	bhi	.L1861
	adrp	x1, .LANCHOR162
	adrp	x0, .LC0
	mov	w2, 782
	add	x1, x1, :lo12:.LANCHOR162
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1861:
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	ldrb	w6, [x0, w23, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x4, [x0, #:lo12:.LANCHOR13]
	mov	w0, w6
	bl	nandc_cs
	cbnz	w20, .L1862
	mov	w0, w19
	bl	slc_phy_page_address_calc
	mov	w19, w0
.L1862:
	adrp	x0, .LANCHOR19+16
	and	x1, x6, 255
	and	w3, w19, 255
	lsr	w2, w19, 8
	ldrb	w0, [x0, #:lo12:.LANCHOR19+16]
	adrp	x5, .LANCHOR16
	cmp	w0, 1
	lsr	w0, w19, 16
	bne	.L1863
	add	x1, x4, x1, lsl 8
	mov	w4, 6
.L1874:
	str	w4, [x1, 2056]
	str	wzr, [x1, 2052]
	str	wzr, [x1, 2052]
	str	w3, [x1, 2052]
	str	w2, [x1, 2052]
	str	w0, [x1, 2052]
.L1872:
	mov	w0, 224
	str	w0, [x1, 2056]
	ldr	x0, [x5, #:lo12:.LANCHOR16]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1866
	cbz	w20, .L1866
	add	w19, w19, w19, lsl 1
	sub	w20, w20, #1
	add	w0, w19, w20
.L1873:
	bl	nandc_set_seed
	adrp	x0, .LANCHOR34+9
	mov	x4, x22
	mov	x3, x21
	mov	w1, 0
	ldrb	w2, [x0, #:lo12:.LANCHOR34+9]
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
.L1863:
	ldr	x7, [x5, #:lo12:.LANCHOR16]
	add	x1, x4, x1, lsl 8
	ldrb	w7, [x7, 12]
	cmp	w7, 3
	bne	.L1865
	mov	w4, 5
	b	.L1874
.L1865:
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
	b	.L1872
.L1866:
	mov	w0, w19
	b	.L1873
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
	bhi	.L1876
	adrp	x1, .LANCHOR163
	adrp	x0, .LC0
	mov	w2, 904
	add	x1, x1, :lo12:.LANCHOR163
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1876:
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	ldrb	w22, [x0, w20, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x4, [x0, #:lo12:.LANCHOR13]
	mov	w0, w22
	bl	nandc_cs
	cbnz	w21, .L1877
	mov	w0, w19
	bl	slc_phy_page_address_calc
	mov	w19, w0
.L1877:
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
	bne	.L1878
	cbz	w21, .L1878
	sub	w0, w21, #1
	add	w1, w19, w19, lsl 1
	add	w0, w0, w1
.L1905:
	adrp	x20, .LANCHOR34
	add	x28, x20, :lo12:.LANCHOR34
	bl	nandc_set_seed
	mov	x4, x25
	mov	x3, x24
	ldrb	w2, [x28, 9]
	mov	w1, 0
	mov	w0, w22
	bl	nandc_xfer
	cmn	w0, #1
	bne	.L1880
	adrp	x26, .LANCHOR45
	ldrb	w27, [x26, #:lo12:.LANCHOR45]
	cbz	w27, .L1881
	ldrb	w4, [x28, 9]
	mov	x3, x25
	strb	wzr, [x26, #:lo12:.LANCHOR45]
	mov	x2, x24
	orr	w1, w19, w21, lsl 24
	mov	w0, w22
	bl	flash_read_page
	strb	w27, [x26, #:lo12:.LANCHOR45]
	cbnz	w21, .L1882
.L1887:
	adrp	x1, .LANCHOR0
	ldrb	w1, [x1, #:lo12:.LANCHOR0]
	cbz	w1, .L1882
	adrp	x1, .LANCHOR43
	ldrb	w1, [x1, #:lo12:.LANCHOR43]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	blt	.L1882
	add	x20, x20, :lo12:.LANCHOR34
	ldrb	w1, [x20, 19]
	sub	w1, w1, #4
	and	w1, w1, 255
	cmp	w1, 3
	mov	w1, 256
	csel	w0, w0, w1, hi
.L1875:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1878:
	mov	w0, w19
	b	.L1905
.L1882:
	cmn	w0, #1
	bne	.L1875
.L1888:
	adrp	x0, .LANCHOR156
	ldr	x5, [x0, #:lo12:.LANCHOR156]
	cbnz	x5, .L1884
.L1886:
	adrp	x0, .LANCHOR45
	mov	w3, -1
	mov	w2, w23
	mov	w1, 0
	ldrb	w4, [x0, #:lo12:.LANCHOR45]
	adrp	x0, .LC117
	add	x0, x0, :lo12:.LC117
	bl	printf
	adrp	x0, .LANCHOR20
	ldrb	w0, [x0, #:lo12:.LANCHOR20]
	cbnz	w0, .L1885
	mov	w0, -1
	b	.L1875
.L1884:
	add	x0, x20, :lo12:.LANCHOR34
	mov	x3, x25
	mov	x2, x24
	orr	w1, w19, w21, lsl 24
	ldrb	w4, [x0, 9]
	mov	w0, w22
	blr	x5
	cmn	w0, #1
	beq	.L1886
	b	.L1875
.L1885:
	add	x20, x20, :lo12:.LANCHOR34
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
.L1880:
	cbz	w21, .L1887
	b	.L1875
.L1881:
	cbnz	w21, .L1888
	b	.L1887
	.size	flash_complete_page_read, .-flash_complete_page_read
	.section	.text.queue_wait_first_req_completed,"ax",@progbits
	.align	2
	.type	queue_wait_first_req_completed, %function
queue_wait_first_req_completed:
	stp	x29, x30, [sp, -96]!
	adrp	x0, .LANCHOR53
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldrb	w0, [x0, #:lo12:.LANCHOR53]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w0, 255
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	bne	.L1907
.L1936:
	mov	w22, 0
	b	.L1906
.L1907:
	adrp	x19, .LANCHOR49
	sxtw	x20, w0
	add	x1, x19, :lo12:.LANCHOR49
	add	x1, x1, x20, lsl 6
	ldrb	w2, [x1, 58]
	ldr	w22, [x1, 40]
	sub	w3, w2, #1
	cmp	w3, 9
	bhi	.L1936
	adrp	x1, .L1910
	add	x1, x1, :lo12:.L1910
	ldrh	w1, [x1,w3,uxtw #1]
	adr	x3, .Lrtx1910
	add	x1, x3, w1, sxth #2
	br	x1
.Lrtx1910:
	.section	.rodata.queue_wait_first_req_completed,"a",@progbits
	.align	0
	.align	2
.L1910:
	.2byte	(.L1909 - .Lrtx1910) / 4
	.2byte	(.L1911 - .Lrtx1910) / 4
	.2byte	(.L1912 - .Lrtx1910) / 4
	.2byte	(.L1912 - .Lrtx1910) / 4
	.2byte	(.L1912 - .Lrtx1910) / 4
	.2byte	(.L1913 - .Lrtx1910) / 4
	.2byte	(.L1914 - .Lrtx1910) / 4
	.2byte	(.L1915 - .Lrtx1910) / 4
	.2byte	(.L1912 - .Lrtx1910) / 4
	.2byte	(.L1915 - .Lrtx1910) / 4
	.section	.text.queue_wait_first_req_completed
.L1909:
	mov	w1, 64
	mov	w0, w22
	bl	flash_wait_device_ready
	tbz	x0, 6, .L1936
	add	x0, x19, :lo12:.LANCHOR49
	add	x0, x0, x20, lsl 6
	ldp	x1, x2, [x0, 8]
	cbz	x2, .L1917
	ldrb	w3, [x0, 56]
	adrp	x0, .LANCHOR121
	ldrb	w0, [x0, #:lo12:.LANCHOR121]
	cmp	w3, w0
	csel	x1, x1, x2, ne
.L1917:
	add	x19, x19, :lo12:.LANCHOR49
	mov	w0, w22
	add	x20, x19, x20, lsl 6
	ldr	x2, [x20, 24]
	bl	flash_complete_page_read
	str	w0, [x20, 52]
	mov	w0, 12
	strb	w0, [x20, 58]
	ldrb	w0, [x20, 2]
	orr	w0, w0, 8
	strb	w0, [x20, 2]
	b	.L1936
.L1911:
	mov	w1, 64
	mov	w0, w22
	bl	flash_wait_device_ready
	tbz	x0, 6, .L1936
	add	x0, x19, :lo12:.LANCHOR49
	lsl	x2, x20, 6
	add	x1, x0, x2
	ldrb	w21, [x0, x2]
	add	x0, x0, x21, lsl 6
	ldr	x24, [x0, 8]
	ldp	x26, x0, [x1, 8]
	cbz	x0, .L1918
	ldrb	w2, [x1, 56]
	adrp	x1, .LANCHOR121
	ldrb	w1, [x1, #:lo12:.LANCHOR121]
	cmp	w2, w1
	csel	x26, x26, x0, ne
.L1918:
	add	x0, x19, :lo12:.LANCHOR49
	add	x0, x0, x21, lsl 6
	ldr	x1, [x0, 16]
	cbz	x1, .L1919
	ldrb	w2, [x0, 56]
	adrp	x0, .LANCHOR121
	ldrb	w0, [x0, #:lo12:.LANCHOR121]
	cmp	w2, w0
	csel	x24, x24, x1, ne
.L1919:
	add	x22, x19, :lo12:.LANCHOR49
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
	beq	.L1920
	ldr	w0, [x27, 36]
	cmn	w0, #1
	beq	.L1921
	ldr	x1, [x27, 24]
	ldr	w1, [x1, 4]
	cmp	w0, w1
	beq	.L1921
.L1920:
	add	x22, x19, :lo12:.LANCHOR49
	adrp	x2, .LANCHOR121
	add	x22, x22, x20, lsl 6
	ldrb	w4, [x2, #:lo12:.LANCHOR121]
	mov	x2, x26
	ldr	x3, [x22, 24]
	ldr	w1, [x22, 40]
	ubfx	x0, x1, 21, 3
	and	w1, w1, -14680065
	bl	flash_read_page_en
	mov	w23, w0
	ldr	w2, [x22, 36]
	cmn	w2, #1
	beq	.L1922
	ldr	x0, [x22, 24]
	ldr	w4, [x0, 4]
	cmp	w2, w4
	beq	.L1922
	adrp	x1, .LANCHOR14
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 6, .L1922
	ldr	w3, [x0]
	adrp	x0, .LC118
	ldr	w1, [x22, 40]
	add	x0, x0, :lo12:.LC118
	bl	printf
.L1922:
	add	x0, x19, :lo12:.LANCHOR49
	add	x0, x0, x20, lsl 6
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L1921
	ldr	x0, [x0, 24]
	ldr	w0, [x0, 4]
	cmp	w1, w0
	beq	.L1921
	adrp	x1, .LANCHOR164
	adrp	x0, .LC0
	mov	w2, 338
	add	x1, x1, :lo12:.LANCHOR164
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1921:
	add	x0, x19, :lo12:.LANCHOR49
	mov	w1, 12
	add	x20, x0, x20, lsl 6
	cmn	w25, #1
	strb	w1, [x20, 58]
	ldrb	w1, [x20, 2]
	str	w23, [x20, 52]
	orr	w1, w1, 8
	strb	w1, [x20, 2]
	beq	.L1923
	add	x0, x0, x21, lsl 6
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L1925
	ldr	x0, [x0, 24]
	ldr	w0, [x0, 4]
	cmp	w1, w0
	beq	.L1925
.L1923:
	add	x20, x19, :lo12:.LANCHOR49
	adrp	x2, .LANCHOR121
	add	x20, x20, x21, lsl 6
	ldrb	w4, [x2, #:lo12:.LANCHOR121]
	mov	x2, x24
	ldr	x3, [x20, 24]
	ldr	w1, [x20, 40]
	ubfx	x0, x1, 21, 3
	and	w1, w1, -14680065
	bl	flash_read_page_en
	ldr	w2, [x20, 36]
	cmn	w2, #1
	beq	.L1927
	ldr	x0, [x20, 24]
	ldr	w4, [x0, 4]
	cmp	w2, w4
	beq	.L1927
	adrp	x1, .LANCHOR14
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 6, .L1927
	ldr	w3, [x0]
	adrp	x0, .LC118
	ldr	w1, [x20, 40]
	add	x0, x0, :lo12:.LC118
	bl	printf
.L1927:
	add	x0, x19, :lo12:.LANCHOR49
	add	x0, x0, x21, lsl 6
	ldr	w1, [x0, 36]
	cmn	w1, #1
	beq	.L1925
	ldr	x0, [x0, 24]
	ldr	w0, [x0, 4]
	cmp	w1, w0
	beq	.L1925
	adrp	x1, .LANCHOR164
	adrp	x0, .LC0
	mov	w2, 353
	add	x1, x1, :lo12:.LANCHOR164
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1925:
	add	x19, x19, :lo12:.LANCHOR49
	mov	w0, 12
	add	x21, x19, x21, lsl 6
	strb	w0, [x21, 58]
	ldrb	w0, [x21, 2]
	str	w23, [x21, 52]
	orr	w0, w0, 8
	strb	w0, [x21, 2]
	b	.L1936
.L1912:
	mov	w0, w22
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w22, w0
	tbz	x22, 6, .L1936
	add	x19, x19, :lo12:.LANCHOR49
	mov	w0, 5
	add	x20, x19, x20, lsl 6
	tst	w22, w0
	beq	.L1935
	ldrb	w1, [x20, 1]
	mov	w0, 11
	ldr	w3, [x20, 40]
	mov	w4, 11
	ldr	w2, [x20, 52]
	strb	w0, [x20, 58]
	adrp	x0, .LC119
	add	x0, x0, :lo12:.LC119
	bl	printf
.L1996:
	mov	w0, -1
	str	w0, [x20, 52]
	b	.L1906
.L1915:
	cmp	w2, 10
	add	x21, x19, :lo12:.LANCHOR49
	ubfiz	x0, x0, 6, 8
	mov	w1, 3
	mov	w2, 9
	add	x0, x21, x0
	csel	w2, w2, w1, eq
	ubfx	x3, x22, 21, 3
.L1930:
	ldrb	w1, [x0]
	cmp	w1, 255
	bne	.L1934
	mov	w22, -1
	b	.L1906
.L1934:
	sxtw	x23, w1
	ubfiz	x0, x1, 6, 8
	add	x1, x21, x23, lsl 6
	add	x0, x21, x0
	ldrb	w4, [x1, 58]
	cmp	w4, w2
	bne	.L1930
	ldr	w1, [x1, 40]
	ubfx	x1, x1, 21, 3
	cmp	w3, w1
	bne	.L1930
	mov	w0, w22
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w24, w0
	and	w22, w0, 64
	tbz	x24, 6, .L1932
	add	x21, x21, x20, lsl 6
	ands	w22, w0, 15
	beq	.L1933
	ldrb	w1, [x21, 1]
	mov	w4, 11
	ldr	w3, [x21, 40]
	adrp	x0, .LC119
	ldr	w2, [x21, 52]
	add	x0, x0, :lo12:.LC119
	mov	w22, w24
	bl	printf
	mov	w0, 11
	strb	w0, [x21, 58]
	mov	w0, -1
	str	w0, [x21, 52]
.L1932:
	add	x1, x19, :lo12:.LANCHOR49
	add	x20, x1, x20, lsl 6
	add	x1, x1, x23, lsl 6
	ldrb	w0, [x20, 58]
	strb	w0, [x1, 58]
	ldr	w0, [x20, 52]
	str	w0, [x1, 52]
.L1906:
	mov	w0, w22
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1933:
	mov	w0, 12
	str	wzr, [x21, 52]
	strb	w0, [x21, 58]
	b	.L1932
.L1913:
	mov	w0, w22
	mov	w1, 32
	bl	flash_wait_device_ready
	mov	w22, w0
	tbz	x22, 5, .L1936
	add	x19, x19, :lo12:.LANCHOR49
	tst	x22, 15
	add	x20, x19, x20, lsl 6
	beq	.L1935
	mov	w0, 11
	strb	w0, [x20, 58]
	b	.L1996
.L1935:
	mov	w0, 12
	str	wzr, [x20, 52]
	strb	w0, [x20, 58]
	b	.L1936
.L1914:
	mov	w1, 64
	mov	w0, w22
	bl	flash_wait_device_ready
	tbz	x0, 6, .L1936
	add	x19, x19, :lo12:.LANCHOR49
	add	x19, x19, x20, lsl 6
	str	w0, [x19, 52]
	mov	w0, 6
	strb	w0, [x19, 58]
	b	.L1936
	.size	queue_wait_first_req_completed, .-queue_wait_first_req_completed
	.section	.text.sblk_wait_write_queue_completed,"ax",@progbits
	.align	2
	.global	sblk_wait_write_queue_completed
	.type	sblk_wait_write_queue_completed, %function
sblk_wait_write_queue_completed:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR53
	add	x19, x19, :lo12:.LANCHOR53
.L1998:
	ldrb	w0, [x19]
	cmp	w0, 255
	bne	.L1999
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1999:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1998
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
	adrp	x21, .LANCHOR49
	stp	x23, x24, [sp, 48]
	mov	x19, x0
	stp	x25, x26, [sp, 64]
	mov	x23, x0
	adrp	x26, .LANCHOR165
	mov	w20, w22
	add	x26, x26, :lo12:.LANCHOR165
	add	x21, x21, :lo12:.LANCHOR49
	stp	x27, x28, [sp, 80]
	adrp	x27, .LANCHOR105
.L2006:
	cbnz	w20, .L2016
.L2029:
	adrp	x19, .LANCHOR49
	add	x19, x19, :lo12:.LANCHOR49
.L2017:
	cbnz	w22, .L2019
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2016:
	ldrb	w24, [x19]
	ldr	w25, [x19, 40]
.L2007:
	mov	w1, 0
	mov	w0, w25
	bl	queue_lun_state
	cbnz	w0, .L2008
	cmp	w20, 1
	beq	.L2013
	ldrb	w0, [x26]
	cbnz	w0, .L2010
.L2013:
	mov	x0, x19
	bl	queue_read_cmd
	b	.L2011
.L2008:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2007
.L2010:
	ldrb	w0, [x19]
	ubfx	x4, x25, 21, 3
	cmp	w0, 255
	bne	.L2012
	str	w4, [x29, 124]
	mov	w2, 624
	adrp	x1, .LANCHOR166
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR166
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldr	w4, [x29, 124]
.L2012:
	ldrb	w28, [x19]
	sbfiz	x2, x28, 6, 32
	add	x3, x21, x2
	ldr	w1, [x3, 40]
	ubfx	x0, x1, 21, 3
	cmp	w4, w0
	bne	.L2013
	ldrh	w0, [x27, #:lo12:.LANCHOR105]
	add	w25, w0, w25
	cmp	w1, w25
	bne	.L2013
	ldr	w0, [x19, 40]
	adrp	x25, .LANCHOR53
	ldrb	w24, [x21, x2]
	add	x25, x25, :lo12:.LANCHOR53
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
.L2011:
	subs	w20, w20, #1
	beq	.L2029
	ubfiz	x19, x24, 6, 8
	add	x19, x21, x19
	b	.L2006
.L2019:
	ldrb	w0, [x23, 58]
	cmp	w0, 12
	bne	.L2018
	ldrb	w0, [x23]
	sub	w22, w22, #1
	cmp	w0, 255
	beq	.L2018
	ubfiz	x23, x0, 6, 8
	add	x23, x19, x23
.L2018:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2017
	.size	sblk_read_page, .-sblk_read_page
	.section	.text.gc_check_data_one_wl,"ax",@progbits
	.align	2
	.global	gc_check_data_one_wl
	.type	gc_check_data_one_wl, %function
gc_check_data_one_wl:
	sub	sp, sp, #112
	adrp	x0, .LANCHOR10
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x19, .LANCHOR62
	add	x20, x19, :lo12:.LANCHOR62
	stp	x21, x22, [sp, 48]
	ldr	x21, [x0, #:lo12:.LANCHOR10]
	stp	x23, x24, [sp, 64]
	ldr	x0, [x20, 8]
	stp	x25, x26, [sp, 80]
	str	x27, [sp, 96]
	cbnz	x0, .L2032
	mov	w0, 1
	bl	buf_alloc
	str	x0, [x20, 8]
.L2032:
	add	x0, x19, :lo12:.LANCHOR62
	ldr	x20, [x0, 8]
	cbnz	x20, .L2033
	adrp	x1, .LANCHOR167
	adrp	x0, .LC0
	mov	w2, 366
	add	x1, x1, :lo12:.LANCHOR167
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2033:
	adrp	x26, .LANCHOR105
	adrp	x27, .LANCHOR68
	add	x25, x21, 96
	add	x26, x26, :lo12:.LANCHOR105
	add	x27, x27, :lo12:.LANCHOR68
	mov	w24, 0
.L2034:
	ldrb	w0, [x21, 89]
	cmp	w24, w0
	bge	.L2043
	mov	w23, 1
	add	x22, x19, :lo12:.LANCHOR62
	b	.L2044
.L2042:
	ldrh	w0, [x25]
	ldrh	w1, [x26]
	ldrb	w2, [x27]
	cmp	w2, 3
	mul	w1, w0, w1
	ldrh	w0, [x22, 16]
	bne	.L2035
	add	w0, w0, w1
	orr	w0, w0, w23, lsl 24
.L2055:
	str	w0, [x20, 40]
	mov	w1, 1
	mov	x0, x20
	bl	sblk_read_page
	ldr	w2, [x20, 52]
	adrp	x1, .LANCHOR147
	cmn	w2, #1
	beq	.L2038
	ldrh	w0, [x22, 22]
	ldr	x4, [x1, #:lo12:.LANCHOR147]
	ldr	x3, [x20, 24]
	lsl	x0, x0, 2
	ldr	w5, [x4, x0]
	ldr	w4, [x3, 4]
	cmp	w5, w4
	bne	.L2038
	adrp	x4, .LANCHOR148
	ldr	x4, [x4, #:lo12:.LANCHOR148]
	ldr	w4, [x4, x0]
	ldr	w0, [x3, 8]
	cmp	w4, w0
	beq	.L2039
.L2038:
	ldrh	w0, [x22, 22]
	ldr	x1, [x1, #:lo12:.LANCHOR147]
	lsl	x0, x0, 2
	ldr	w3, [x1, x0]
	cmn	w3, #1
	beq	.L2039
	adrp	x1, .LANCHOR14
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 10, .L2040
	ldr	x1, [x20, 24]
	adrp	x4, .LANCHOR148
	ldr	x4, [x4, #:lo12:.LANCHOR148]
	ldr	w5, [x1, 12]
	str	w5, [sp]
	ldr	w4, [x4, x0]
	adrp	x0, .LC120
	ldp	w5, w6, [x1]
	add	x0, x0, :lo12:.LC120
	ldr	w7, [x1, 8]
	ldr	w1, [x20, 40]
	bl	printf
.L2040:
	adrp	x0, .LANCHOR9
	ldrh	w1, [x21, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x1, lsl 1]
	mov	w0, -1
.L2031:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	ldr	x27, [sp, 96]
	add	sp, sp, 112
	ret
.L2035:
	cmp	w2, 2
	bne	.L2037
	sub	w0, w0, #1
	add	w1, w23, w1
	add	w0, w0, w1
	orr	w0, w0, 33554432
	b	.L2055
.L2037:
	add	w0, w0, w1
	b	.L2055
.L2039:
	ldrh	w0, [x22, 22]
	add	w23, w23, 1
	add	w0, w0, 1
	strh	w0, [x22, 22]
.L2044:
	ldrh	w0, [x22, 20]
	cmp	w23, w0
	ble	.L2042
	add	w24, w24, 1
	add	x25, x25, 2
	b	.L2034
.L2043:
.L2041:
	add	x19, x19, :lo12:.LANCHOR62
	ldrh	w0, [x19, 16]
	add	w0, w0, 1
	strh	w0, [x19, 16]
	mov	w0, 0
	b	.L2031
	.size	gc_check_data_one_wl, .-gc_check_data_one_wl
	.section	.text.flash_prog_page,"ax",@progbits
	.align	2
	.global	flash_prog_page
	.type	flash_prog_page, %function
flash_prog_page:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	stp	x21, x22, [sp, 32]
	adrp	x0, .LANCHOR13
	adrp	x22, .LANCHOR14
	stp	x25, x26, [sp, 64]
	ldr	x25, [x0, #:lo12:.LANCHOR13]
	mov	w21, w1
	ldr	w0, [x22, #:lo12:.LANCHOR14]
	and	x19, x20, 255
	stp	x23, x24, [sp, 48]
	add	x23, x19, 8
	stp	x27, x28, [sp, 80]
	mov	x26, x2
	mov	x27, x3
	add	x23, x25, x23, lsl 8
	and	w24, w1, 2097151
	ubfx	x28, x21, 24, 2
	tbz	x0, 4, .L2057
	adrp	x0, .LC121
	mov	w3, w4
	mov	w2, w28
	add	x0, x0, :lo12:.LC121
	bl	printf
.L2057:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	hynix_reconfig_rr_para
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w28, .L2058
	bl	zftl_flash_enter_slc_mode
.L2059:
	add	x19, x25, x19, lsl 8
	mov	w0, 128
	str	w0, [x19, 2056]
	and	w0, w21, 255
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w24, 8
	str	w0, [x19, 2052]
	lsr	w0, w24, 16
	str	w0, [x19, 2052]
	mov	w0, w24
	bl	nandc_set_seed
	adrp	x0, .LANCHOR34+9
	mov	x3, x27
	mov	x2, x26
	ldrb	w1, [x0, #:lo12:.LANCHOR34+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	mov	w0, 16
	str	w0, [x19, 2056]
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	mov	w2, w0
	bl	nandc_de_cs.constprop.29
	and	w19, w2, 4
	tbz	x2, 2, .L2056
	ldr	w0, [x22, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2056
	adrp	x0, .LC122
	mov	w2, w19
	mov	w1, w21
	add	x0, x0, :lo12:.LC122
	bl	printf
.L2056:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2058:
	bl	zftl_flash_exit_slc_mode
	b	.L2059
	.size	flash_prog_page, .-flash_prog_page
	.section	.text.flash_test_blk,"ax",@progbits
	.align	2
	.global	flash_test_blk
	.type	flash_test_blk, %function
flash_test_blk:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w1, 65535
	stp	x21, x22, [sp, 32]
	ands	w21, w0, 255
	str	x23, [sp, 48]
	bne	.L2072
	adrp	x0, .LANCHOR168
	ldrb	w0, [x0, #:lo12:.LANCHOR168]
	cmp	w0, w19
	bhi	.L2076
.L2072:
	adrp	x22, .LANCHOR160
	adrp	x23, .LANCHOR161
	mov	w2, 32
	mov	w1, 165
	ldr	x0, [x22, #:lo12:.LANCHOR160]
	bl	ftl_memset
	ldr	x0, [x23, #:lo12:.LANCHOR161]
	mov	w2, 8
	mov	w1, 90
	bl	ftl_memset
	adrp	x0, .LANCHOR2
	ldrh	w20, [x0, #:lo12:.LANCHOR2]
	mov	w0, w21
	mul	w20, w20, w19
	mov	w1, w20
	bl	flash_erase_block
	cmn	w0, #1
	beq	.L2074
	adrp	x19, .LANCHOR34
	add	x19, x19, :lo12:.LANCHOR34
	ldr	x3, [x22, #:lo12:.LANCHOR160]
	mov	w1, w20
	ldr	x2, [x23, #:lo12:.LANCHOR161]
	mov	w0, w21
	ldrb	w4, [x19, 9]
	bl	flash_prog_page
	cmn	w0, #1
	beq	.L2074
	ldrb	w4, [x19, 9]
	mov	w1, w20
	ldr	x3, [x22, #:lo12:.LANCHOR160]
	mov	w0, w21
	ldr	x2, [x23, #:lo12:.LANCHOR161]
	bl	flash_read_page
	mov	w19, w0
	cmn	w0, #1
	beq	.L2074
	ldr	x0, [x23, #:lo12:.LANCHOR161]
	ldr	w1, [x0]
	mov	w0, 23130
	movk	w0, 0x5a5a, lsl 16
	cmp	w1, w0
	bne	.L2074
	ldr	x0, [x22, #:lo12:.LANCHOR160]
	ldr	w1, [x0]
	mov	w0, 42405
	movk	w0, 0xa5a5, lsl 16
	cmp	w1, w0
	beq	.L2075
.L2074:
	mov	w19, -1
.L2075:
	mov	w1, w20
	mov	w0, w21
	bl	flash_erase_block
	mov	w0, w19
.L2071:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L2076:
	mov	w0, 0
	b	.L2071
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
	adrp	x0, .LANCHOR169
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	ldrb	w0, [x0, #:lo12:.LANCHOR169]
	str	x25, [sp, 64]
	cbnz	w0, .L2087
	adrp	x20, .LANCHOR34
	add	x20, x20, :lo12:.LANCHOR34
	ldrb	w0, [x20, 19]
	sub	w0, w0, #5
	and	w3, w0, 255
	cmp	w3, 63
	bhi	.L2087
	and	w19, w2, 65535
	mov	x2, 16391
	movk	x2, 0x4000, lsl 16
	movk	x2, 0x8000, lsl 48
	lsr	x0, x2, x3
	tbz	x0, 0, .L2087
	adrp	x21, .LANCHOR133
	mov	w23, w1
	add	x21, x21, :lo12:.LANCHOR133
	mov	w25, 65535
	adrp	x24, .LANCHOR151
.L2089:
	ldrh	w0, [x20, 10]
	cmp	w0, w19
	bhi	.L2090
.L2087:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2090:
	ldrh	w0, [x21, w19, sxtw 1]
	cmp	w0, w25
	bne	.L2087
	ldr	x0, [x24, #:lo12:.LANCHOR151]
	mov	w2, 16384
	mov	w1, 255
	bl	ftl_memset
	ldr	x3, [x24, #:lo12:.LANCHOR151]
	add	w1, w19, w23
	ldrb	w4, [x20, 9]
	add	w19, w19, 1
	mov	x2, x3
	mov	w0, w22
	and	w19, w19, 65535
	bl	flash_prog_page
	b	.L2089
	.size	id_block_prog_msb_ff_data, .-id_block_prog_msb_ff_data
	.section	.text.idb_write_data,"ax",@progbits
	.align	2
	.global	idb_write_data
	.type	idb_write_data, %function
idb_write_data:
	stp	x29, x30, [sp, -256]!
	add	w0, w1, w3
	mov	w4, w1
	cmp	w0, 63
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	bls	.L2093
	cmp	w1, 575
	bhi	.L2094
	adrp	x0, .LANCHOR170
	mov	x1, x2
	mov	w2, 1
	cmp	w4, 64
	str	w2, [x0, #:lo12:.LANCHOR170]
	adrp	x0, idb_buf
	bhi	.L2095
	mov	w2, 64
	sub	w4, w2, w4
	sub	w2, w3, w4
	ubfiz	x4, x4, 9, 25
	lsl	w2, w2, 9
	add	x1, x1, x4
	add	x0, x0, :lo12:idb_buf
.L2171:
	bl	ftl_memcpy
.L2150:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 256
	ret
.L2095:
	mov	w2, 576
	sub	w2, w2, w4
	cmp	w3, w2
	sub	w4, w4, #64
	csel	w2, w3, w2, ls
	ubfiz	x4, x4, 9, 25
	add	x0, x0, :lo12:idb_buf
	lsl	w2, w2, 9
	add	x0, x0, x4
	b	.L2171
.L2093:
	cmp	w1, 575
	bls	.L2150
.L2094:
	adrp	x0, .LANCHOR170
	ldr	w0, [x0, #:lo12:.LANCHOR170]
	cbz	w0, .L2150
	adrp	x3, .LANCHOR34
	add	x1, x3, :lo12:.LANCHOR34
	str	x3, [x29, 176]
	adrp	x3, idb_buf
	add	x6, x3, :lo12:idb_buf
	mov	w4, 4097
	ldrh	w0, [x1, 10]
	ldrb	w2, [x1, 9]
	ldrb	w1, [x1, 12]
	mul	w2, w0, w2
	lsl	w0, w0, 2
	and	w2, w2, 65535
	str	w2, [x29, 132]
	sdiv	w27, w0, w1
	mov	w0, 512
	adrp	x1, idb_buf+262140
	add	x1, x1, :lo12:idb_buf+262140
	mov	w2, 65535
	cmp	w27, 512
	csel	w27, w27, w0, lt
	mov	w0, 0
.L2100:
	ldr	w5, [x1]
	cbnz	w5, .L2098
	ldr	w5, [x6, w0, uxtw 2]
	add	w0, w0, 1
	str	w5, [x1], -4
	cmp	w0, w4
	sub	w2, w2, #1
	csel	w0, w0, wzr, cc
	cmp	w2, 4096
	bne	.L2100
.L2098:
	add	x0, x3, :lo12:idb_buf
	mov	w3, w27
	ldr	w1, [x0, w2, uxtw 2]
	adrp	x0, .LC123
	add	x0, x0, :lo12:.LC123
	bl	printf
	stp	wzr, wzr, [x29, 168]
	adrp	x0, gp_flash_check_buf
	add	x0, x0, :lo12:gp_flash_check_buf
	str	x0, [x29, 184]
.L2134:
	adrp	x0, gp_flash_check_buf
	add	x20, x0, :lo12:gp_flash_check_buf
	mov	w1, 0
	mov	w2, 512
	mov	x0, x20
	bl	ftl_memset
	adrp	x0, .LANCHOR26
	ldr	w1, [x29, 172]
	ldr	x0, [x0, #:lo12:.LANCHOR26]
	add	x0, x0, x1, uxtw
	ldrb	w0, [x0, 32]
	cmp	w0, 255
	beq	.L2101
	ldr	w1, [x29, 132]
	adrp	x19, .LANCHOR45
	mul	w26, w0, w1
	ldr	x0, [x29, 176]
	add	x25, x0, :lo12:.LANCHOR34
	ldrb	w0, [x19, #:lo12:.LANCHOR45]
	str	w0, [x29, 128]
	strb	wzr, [x19, #:lo12:.LANCHOR45]
	mov	w0, 0
	ldrb	w21, [x25, 9]
	ldrh	w23, [x25, 10]
	udiv	w1, w26, w21
	mul	w23, w21, w23
	and	w22, w23, 65535
	bl	flash_erase_block
	udiv	w23, w26, w22
	msub	w23, w23, w22, w26
	sub	w24, w26, w23
	cmp	w26, w24
	bne	.L2140
	adrp	x0, .LANCHOR27
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
	cmp	w0, 9
	bne	.L2140
	mov	w2, 1024
	mov	w1, 0
	mov	x0, x20
	bl	ftl_memset
	adrp	x1, gp_flash_check_buf
	mov	w0, 18766
	movk	w0, 0x464e, lsl 16
	ldrb	w2, [x25, 12]
	str	w0, [x1, #:lo12:gp_flash_check_buf]
	cmp	w21, 8
	ldrb	w0, [x25, 29]
	mov	w1, 12
	strb	w0, [x20, 16]
	mov	w0, 4
	strb	w0, [x20, 17]
	ldrh	w0, [x25, 10]
	str	w1, [x20, 4]
	strb	wzr, [x20, 20]
	str	wzr, [x20, 12]
	sdiv	w0, w0, w2
	mov	w2, 16
	strh	w0, [x20, 18]
	mov	w0, 70
	csel	w0, w0, w2, hi
	ldr	x2, [x29, 184]
	strb	w0, [x2, 21]
	adrp	x0, gp_flash_check_buf+12
	strh	wzr, [x2, 22]
	add	x0, x0, :lo12:gp_flash_check_buf+12
	bl	js_hash
	ldr	x1, [x29, 184]
	mov	x6, x1
	str	w0, [x1, 8]
	sub	w0, w27, #4
	str	w0, [x29, 164]
.L2102:
	adrp	x22, idb_buf
	adrp	x28, .LANCHOR169
	add	x22, x22, :lo12:idb_buf
	add	x0, x28, :lo12:.LANCHOR169
	adrp	x25, .LANCHOR3
	str	x0, [x29, 152]
	mov	w20, 0
	add	x0, x25, :lo12:.LANCHOR3
	str	x0, [x29, 144]
.L2104:
	cmp	w27, w20
	bhi	.L2115
	ldr	x0, [x29, 176]
	add	x25, x19, :lo12:.LANCHOR45
	strb	wzr, [x19, #:lo12:.LANCHOR45]
	mov	w21, 4
	add	x0, x0, :lo12:.LANCHOR34
	mov	w22, 0
	str	wzr, [x29, 144]
	ldrb	w1, [x0, 9]
	ldrh	w28, [x0, 10]
	uxtw	x0, w1
	mul	w28, w0, w28
	and	w28, w28, 65535
	udiv	w0, w26, w28
	msub	w28, w0, w28, w26
	sub	w0, w26, w28
	stp	w0, w1, [x29, 136]
	and	w0, w28, 3
	str	w0, [x29, 152]
	ldr	w0, [x29, 164]
	str	w0, [x29, 160]
	adrp	x0, gp_flash_check_buf
	add	x20, x0, :lo12:gp_flash_check_buf
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	str	x0, [x29, 104]
.L2116:
	ldr	w0, [x29, 160]
	cmp	w22, w0
	bcc	.L2130
	adrp	x0, .LANCHOR45
	ldrb	w1, [x29, 128]
	adrp	x3, idb_buf
	add	x3, x3, :lo12:idb_buf
	strb	w1, [x0, #:lo12:.LANCHOR45]
	mov	x1, 0
	ldr	w0, [x29, 164]
	lsl	w0, w0, 7
.L2131:
	mov	w19, w1
	cmp	w1, w0
	bcc	.L2132
	ldr	w0, [x29, 168]
	add	w0, w0, 1
	str	w0, [x29, 168]
	cmp	w0, 5
	bls	.L2101
	b	.L2136
.L2140:
	mov	x6, 0
	str	w27, [x29, 164]
	b	.L2102
.L2115:
	ldr	x2, [x29, 152]
	add	w5, w23, w20
	lsr	w5, w5, 2
	add	x0, x25, :lo12:.LANCHOR3
	add	w1, w5, 1
	ldrb	w2, [x2]
	ldrh	w0, [x0, w1, sxtw 1]
	cbz	w2, .L2106
	adrp	x0, .LANCHOR1
	ldrb	w3, [x0, #:lo12:.LANCHOR1]
	lsl	w0, w1, 1
	cmp	w3, 0
	csel	w0, w0, w1, ne
.L2106:
	adrp	x1, .LANCHOR27
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
	cmp	w1, 9
	bne	.L2108
.L2169:
	str	w0, [x29, 192]
	mov	w0, 61424
	str	w0, [x29, 196]
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, w5, sxtw 1]
	cbnz	w2, .L2110
	mov	w5, w0
.L2111:
	mul	w1, w21, w5
	adrp	x2, .LANCHOR43
	adrp	x0, .LANCHOR17
	cbnz	x6, .L2112
	ldr	x3, [x29, 176]
	add	w1, w1, w24
	ldrb	w7, [x2, #:lo12:.LANCHOR43]
	add	x3, x3, :lo12:.LANCHOR34
	ldrb	w0, [x0, #:lo12:.LANCHOR17]
	str	w5, [x29, 140]
	str	w7, [x29, 160]
	ldrb	w6, [x3, 9]
	udiv	w6, w1, w6
	bl	nandc_bch_sel
	mov	w1, w6
	mov	w4, 4
	add	x3, x29, 192
	mov	x2, x22
	mov	w0, 0
	bl	flash_prog_page
	ldr	w7, [x29, 160]
	mov	w0, w7
	bl	nandc_bch_sel
	ldrb	w0, [x28, #:lo12:.LANCHOR169]
	ldr	w5, [x29, 140]
	cbnz	w0, .L2113
	udiv	w1, w24, w21
	add	w2, w5, 1
	bl	id_block_prog_msb_ff_data
.L2113:
	add	x22, x22, 2048
.L2114:
	add	w20, w20, 4
	mov	x6, 0
	and	w20, w20, 65535
	b	.L2104
.L2108:
	sub	w0, w0, #1
	lsl	w0, w0, 2
	b	.L2169
.L2110:
	adrp	x0, .LANCHOR1
	ldrb	w1, [x0, #:lo12:.LANCHOR1]
	lsl	w0, w5, 1
	cmp	w1, 0
	csel	w5, w0, w5, ne
	b	.L2111
.L2112:
	ldr	x3, [x29, 176]
	add	w1, w1, w24
	ldrb	w7, [x2, #:lo12:.LANCHOR43]
	add	x3, x3, :lo12:.LANCHOR34
	ldrb	w0, [x0, #:lo12:.LANCHOR17]
	str	w7, [x29, 160]
	ldrb	w5, [x3, 9]
	udiv	w5, w1, w5
	bl	nandc_bch_sel
	mov	x2, x6
	mov	w4, 4
	add	x3, x29, 192
	mov	w1, w5
	mov	w0, 0
	bl	flash_prog_page
	ldr	w7, [x29, 160]
	mov	w0, w7
	bl	nandc_bch_sel
	b	.L2114
.L2130:
	add	w19, w28, w22
	ldr	w0, [x29, 152]
	adrp	x1, .LANCHOR169
	sub	w24, w21, w0
	ldr	x0, [x29, 104]
	udiv	w19, w19, w21
	ldrb	w1, [x1, #:lo12:.LANCHOR169]
	and	w24, w24, 65535
	and	w19, w19, 65535
	ldrh	w0, [x0, w19, sxtw 1]
	cbnz	w1, .L2117
	mov	w19, w0
.L2118:
	adrp	x0, .LANCHOR17
	ldr	w1, [x29, 136]
	ldrb	w23, [x0, #:lo12:.LANCHOR17]
	ldr	w0, [x29, 152]
	add	w0, w0, w1
	ldr	w1, [x29, 140]
	madd	w19, w1, w19, w0
	ldr	x0, [x29, 176]
	add	x0, x0, :lo12:.LANCHOR34
	ldrb	w0, [x0, 9]
	udiv	w19, w19, w0
	adrp	x0, .LANCHOR43
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	str	w0, [x29, 124]
	mov	w0, w23
	bl	nandc_bch_sel
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	str	x0, [x29, 112]
.L2119:
	mov	w4, w21
	add	x3, x29, 192
	mov	x2, x20
	mov	w1, w19
	mov	w0, 0
	bl	flash_read_page
	mov	w5, w0
	cmn	w0, #1
	bne	.L2120
	ldrb	w6, [x25]
	cbnz	w6, .L2121
.L2124:
	adrp	x0, .LANCHOR156
	ldr	x6, [x0, #:lo12:.LANCHOR156]
	cbnz	x6, .L2122
.L2123:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cbz	w0, .L2120
	mov	w4, w21
	add	x3, x29, 192
	mov	x2, x20
	mov	w1, w19
	mov	w0, 0
	bl	flash_ddr_tuning_read
	b	.L2170
.L2117:
	adrp	x0, .LANCHOR1
	ldrb	w1, [x0, #:lo12:.LANCHOR1]
	lsl	w0, w19, 1
	cmp	w1, 0
	csel	w19, w0, w19, ne
	b	.L2118
.L2121:
	str	w6, [x29, 100]
	mov	w4, w21
	str	w5, [x29, 120]
	add	x3, x29, 192
	strb	wzr, [x25]
	mov	x2, x20
	mov	w1, w19
	mov	w0, 0
	bl	flash_read_page
	cmn	w0, #1
	ldr	w6, [x29, 100]
	strb	w6, [x25]
	ldr	w5, [x29, 120]
	beq	.L2124
.L2170:
	mov	w5, w0
.L2120:
	cmn	w5, #1
	cset	w3, eq
	cmp	w23, 16
	cset	w0, ne
	tst	w3, w0
	beq	.L2126
	mov	w0, 16
	mov	w23, 16
	bl	nandc_bch_sel
	b	.L2119
.L2122:
	str	w5, [x29, 120]
	mov	w4, w21
	add	x3, x29, 192
	mov	x2, x20
	mov	w1, w19
	mov	w0, 0
	blr	x6
	cmn	w0, #1
	ldr	w5, [x29, 120]
	beq	.L2123
	b	.L2170
.L2126:
	ldr	w0, [x29, 124]
	bl	nandc_bch_sel
	cmp	w3, 0
	ldr	w0, [x29, 144]
	csinv	w0, w0, wzr, eq
	str	w0, [x29, 144]
	ldr	w0, [x29, 136]
	cmp	w22, 0
	ccmp	w26, w0, 0, eq
	bne	.L2128
	ldr	w0, [x29, 144]
	cbnz	w0, .L2128
	ldr	w1, [x20]
	mov	w0, 18766
	movk	w0, 0x464e, lsl 16
	cmp	w1, w0
	bne	.L2128
	ldr	w0, [x29, 160]
	ldrb	w21, [x20, 17]
	add	w0, w0, w24
	str	w0, [x29, 160]
.L2129:
	add	w22, w24, w22
	and	w22, w22, 65535
	b	.L2116
.L2128:
	ubfiz	x0, x24, 9, 16
	str	wzr, [x29, 152]
	add	x20, x20, x0
	b	.L2129
.L2132:
	ldr	x4, [x29, 184]
	lsl	x2, x1, 2
	add	x1, x1, 1
	ldr	w4, [x2, x4]
	ldr	w2, [x3, x2]
	cmp	w4, w2
	beq	.L2131
	ldr	x0, [x29, 184]
	mov	w2, 512
	mov	w1, 0
	bl	ftl_memset
	mov	w1, w19
	adrp	x0, .LC124
	add	x0, x0, :lo12:.LC124
	bl	printf
	mov	w1, w26
	mov	w0, 0
	bl	flash_erase_block
.L2101:
	ldr	w0, [x29, 172]
	add	w0, w0, 1
	str	w0, [x29, 172]
	cmp	w0, 4
	bne	.L2134
	ldr	w0, [x29, 168]
	cbnz	w0, .L2136
	adrp	x0, .LC125
	mov	w1, 0
	add	x0, x0, :lo12:.LC125
	bl	printf
.L2136:
	adrp	x0, .LANCHOR170
	str	wzr, [x0, #:lo12:.LANCHOR170]
	b	.L2150
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
	bhi	.L2173
	adrp	x1, .LANCHOR171
	adrp	x0, .LC0
	mov	w2, 648
	add	x1, x1, :lo12:.LANCHOR171
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2173:
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	ldrb	w4, [x0, w19, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	mov	w0, w4
	bl	nandc_cs
	cbz	w25, .L2174
	sxtw	x0, w4
	add	x0, x0, 8
	add	x0, x19, x0, lsl 8
	str	w25, [x0, 8]
.L2174:
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
	adrp	x0, .LANCHOR34+9
	mov	x3, x24
	mov	x2, x23
	ldrb	w1, [x0, #:lo12:.LANCHOR34+9]
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
	adrp	x0, .LANCHOR53
	add	x0, x0, :lo12:.LANCHOR53
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
.L2182:
	mov	w1, 1
	mov	w0, w20
	bl	queue_lun_state
	cbnz	w0, .L2183
	mov	x0, x19
	bl	queue_tlc_prog_cmd
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2183:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2182
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
.L2186:
	mov	w1, 1
	mov	w0, w20
	bl	queue_lun_state
	cbnz	w0, .L2187
	cmp	w24, 2
	bne	.L2188
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
	adrp	x0, .LANCHOR53
	add	x0, x0, :lo12:.LANCHOR53
	bl	buf_add_tail
.L2189:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L2187:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2186
.L2188:
	mov	x0, x19
	bl	queue_tlc_prog_cmd
	b	.L2189
	.size	sblk_xlc_prog_pages, .-sblk_xlc_prog_pages
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
	bhi	.L2192
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 699
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2192:
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	ldrb	w21, [x0, w27, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	bl	nandc_rdy_status
	cbnz	w0, .L2193
	ldrb	w0, [x23, #:lo12:.LANCHOR18]
	cmp	w0, 1
	bne	.L2194
	bl	nandc_wait_flash_ready
.L2193:
	mov	w0, w21
	bl	hynix_reconfig_rr_para
	mov	w0, w21
	bl	nandc_cs
	cbnz	w22, .L2195
	mov	w0, w20
	bl	slc_phy_page_address_calc
	mov	w20, w0
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L2196
	mov	w0, w21
	bl	zftl_flash_enter_slc_mode
.L2196:
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
	adrp	x0, .LANCHOR34+9
	mov	x3, x26
	mov	x2, x25
	ldrb	w1, [x0, #:lo12:.LANCHOR34+9]
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
.L2194:
	mov	w2, 64
	mov	w1, w20
	mov	w0, w27
	bl	flash_wait_device_ready_raw
	b	.L2193
.L2195:
	mov	w0, w21
	bl	zftl_flash_exit_slc_mode
	b	.L2196
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
	adrp	x0, .LANCHOR53
	ldr	w3, [x19, 40]
	ldrb	w1, [x0, #:lo12:.LANCHOR53]
	cmp	w1, 255
	beq	.L2202
	adrp	x2, .LANCHOR49
	add	x2, x2, :lo12:.LANCHOR49
	ubfx	x3, x3, 21, 3
	mov	x6, x2
.L2204:
	add	x4, x2, x1, lsl 6
	ldr	w5, [x4, 40]
	ubfx	x5, x5, 21, 3
	cmp	w3, w5
	bne	.L2203
	ldrb	w5, [x4, 58]
	cmp	w5, 6
	bne	.L2203
	mov	w1, 3
	strb	w1, [x4, 58]
.L2202:
	mov	w1, 3
	strb	w1, [x19, 58]
	mov	w1, 1
	strb	w1, [x19, 59]
	mov	w1, -1
	strb	w1, [x19]
	mov	x1, x19
	add	x0, x0, :lo12:.LANCHOR53
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	buf_add_tail
.L2203:
	lsl	x1, x1, 6
	ldrb	w1, [x6, x1]
	cmp	w1, 255
	bne	.L2204
	b	.L2202
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
	cbz	w0, .L2211
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L2211
	ldr	w1, [x19, 40]
	adrp	x0, .LC126
	mov	w2, w20
	add	x0, x0, :lo12:.LC126
	bl	printf
.L2211:
	adrp	x25, .LANCHOR38
	adrp	x23, .LANCHOR49
	add	x25, x25, :lo12:.LANCHOR38
	add	x23, x23, :lo12:.LANCHOR49
	mov	w21, 0
	mov	w24, 1
.L2212:
	cbnz	w20, .L2223
.L2236:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2223:
	ldrb	w26, [x19]
	ldr	w22, [x19, 40]
.L2213:
	mov	w1, 1
	mov	w0, w22
	bl	queue_lun_state
	cbnz	w0, .L2214
	cmp	w20, 1
	beq	.L2215
	ldrb	w0, [x25]
	cbnz	w0, .L2216
.L2215:
	mov	x0, x19
	bl	queue_prog_cmd
.L2217:
	subs	w20, w20, #1
	beq	.L2236
	ubfiz	x19, x26, 6, 8
	add	x19, x23, x19
	b	.L2212
.L2214:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L2213
.L2216:
	ldrb	w0, [x19]
	ubfx	x27, x22, 21, 3
	cmp	w0, 255
	bne	.L2218
	adrp	x1, .LANCHOR173
	adrp	x0, .LC0
	mov	w2, 546
	add	x1, x1, :lo12:.LANCHOR173
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2218:
	ldrb	w0, [x19]
	add	x0, x23, x0, lsl 6
	ldr	w5, [x0, 40]
	ubfx	x0, x5, 21, 3
	cmp	w27, w0
	bne	.L2219
	adrp	x0, .LANCHOR99
	ldrh	w2, [x0, #:lo12:.LANCHOR99]
	adrp	x0, .LANCHOR98
	ldrb	w3, [x0, #:lo12:.LANCHOR98]
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
	bne	.L2219
	cmp	w21, w3
	beq	.L2219
	ldr	w1, [x19, 40]
	mov	w0, 17
	ldr	x2, [x19, 8]
	add	w21, w21, 1
	ldr	x3, [x19, 24]
	bl	flash_start_page_prog
	strb	w24, [x19, 59]
	mov	w0, 8
	strb	w0, [x19, 58]
	mov	w0, -1
	strb	w0, [x19]
	mov	x1, x19
	adrp	x0, .LANCHOR53
	add	x0, x0, :lo12:.LANCHOR53
	bl	buf_add_tail
	b	.L2217
.L2219:
	mov	x0, x19
	mov	w21, 0
	bl	queue_prog_cmd
	b	.L2217
	.size	sblk_prog_page, .-sblk_prog_page
	.section	.text.ftl_flush,"ax",@progbits
	.align	2
	.global	ftl_flush
	.type	ftl_flush, %function
ftl_flush:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR119
	add	x29, sp, 0
	ldrb	w1, [x0, #:lo12:.LANCHOR119]
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	adrp	x20, .LANCHOR174
	cbz	w1, .L2239
	ldrb	w2, [x20, #:lo12:.LANCHOR174]
	adrp	x0, .LANCHOR49
	add	x0, x0, :lo12:.LANCHOR49
	add	x0, x0, x2, lsl 6
	bl	sblk_prog_page
.L2239:
	mov	w0, -1
	strb	wzr, [x19, #:lo12:.LANCHOR119]
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
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	adrp	x0, .LANCHOR18
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	mov	w20, w1
	stp	x25, x26, [sp, 64]
	mov	x24, x2
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	mov	x23, x3
	mov	w25, w4
	and	w21, w5, 255
	ubfx	x19, x20, 24, 2
	cmp	w0, w22
	bhi	.L2245
	adrp	x1, .LANCHOR175
	adrp	x0, .LC0
	mov	w2, 473
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2245:
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	ldrb	w26, [x0, w22, sxtw]
	cbnz	w19, .L2255
	adrp	x0, .LANCHOR0
	ldrb	w1, [x0, #:lo12:.LANCHOR0]
	adrp	x0, .LANCHOR1
	cbz	w1, .L2247
	ldrb	w1, [x0, #:lo12:.LANCHOR1]
	cbz	w1, .L2255
.L2247:
	adrp	x1, .LANCHOR2
	ldrb	w0, [x0, #:lo12:.LANCHOR1]
	ldrh	w1, [x1, #:lo12:.LANCHOR2]
	udiv	w19, w20, w1
	mul	w19, w19, w1
	sub	w1, w20, w19
	cbz	w0, .L2248
	add	w19, w19, w1, lsl 1
.L2246:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 4, .L2249
	adrp	x0, .LC127
	mov	w2, w20
	mov	w1, w26
	add	x0, x0, :lo12:.LC127
	bl	printf
.L2249:
	mov	w1, w19
	mov	w4, w25
	mov	x3, x23
	mov	x2, x24
	mov	w0, w26
	bl	flash_prog_page
	mov	w19, w0
	cbz	w21, .L2250
	adrp	x26, .LANCHOR160
	adrp	x21, .LANCHOR161
	mov	w4, w25
	mov	w1, w20
	ldr	x3, [x26, #:lo12:.LANCHOR160]
	mov	w0, w22
	ldr	x2, [x21, #:lo12:.LANCHOR161]
	bl	flash_read_page_en
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2251
	ldr	x0, [x21, #:lo12:.LANCHOR161]
	ldr	w1, [x24]
	ldr	w0, [x0]
	cmp	w1, w0
	bne	.L2251
	ldr	x0, [x26, #:lo12:.LANCHOR160]
	ldr	w1, [x23]
	ldr	w0, [x0]
	cmp	w1, w0
	beq	.L2250
.L2251:
	ldr	x1, [x26, #:lo12:.LANCHOR160]
	mov	w3, 4
	adrp	x0, .LC128
	mov	w2, w3
	add	x0, x0, :lo12:.LC128
	bl	rknand_print_hex
	ldr	x1, [x21, #:lo12:.LANCHOR161]
	mov	w3, 4
	adrp	x0, .LC129
	mov	w2, w3
	add	x0, x0, :lo12:.LC129
	bl	rknand_print_hex
.L2252:
	mov	w1, w20
	adrp	x0, .LC130
	add	x0, x0, :lo12:.LC130
	bl	printf
	mov	w2, 499
	adrp	x1, .LANCHOR175
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR175
	add	x0, x0, :lo12:.LC0
	bl	printf
	mov	w0, -1
	b	.L2253
.L2248:
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	ldrh	w0, [x0, w1, uxtw 1]
	add	w19, w0, w19
	b	.L2246
.L2255:
	mov	w19, w20
	b	.L2246
.L2250:
	mov	w0, w19
	cmn	w19, #1
	beq	.L2252
.L2253:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
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
	adrp	x25, .LANCHOR176
	stp	x21, x22, [sp, 32]
	adrp	x26, .LANCHOR106
	and	w21, w0, 65535
	add	x0, x26, :lo12:.LANCHOR106
	stp	x19, x20, [sp, 16]
	mov	w23, 0
	stp	x27, x28, [sp, 80]
	mov	w20, 0
	adrp	x27, .LANCHOR98
	str	x0, [x29, 112]
	str	wzr, [x24, #:lo12:ftl_tmp_buffer]
	add	x0, x27, :lo12:.LANCHOR98
	str	wzr, [x25, #:lo12:.LANCHOR176]
	str	x0, [x29, 96]
.L2267:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cmp	w0, w20
	bls	.L2277
	add	x0, x27, :lo12:.LANCHOR98
	mov	w22, 0
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	str	x0, [x29, 104]
	b	.L2278
.L2276:
	ldr	x0, [x29, 104]
	ldr	w0, [x0]
	tbz	x0, 12, .L2268
	adrp	x0, .LC131
	mov	w1, w21
	add	x0, x0, :lo12:.LC131
	bl	printf
.L2268:
	ldr	x0, [x29, 96]
	ldrb	w19, [x0]
	madd	w19, w21, w19, w22
	and	w19, w19, 65535
	cbnz	w20, .L2269
	adrp	x0, .LANCHOR26
	ldr	x0, [x0, #:lo12:.LANCHOR26]
	ldrb	w0, [x0, 47]
	cmp	w0, w19
	bcs	.L2270
.L2269:
	and	w28, w20, 255
	mov	w1, w19
	mov	w0, w28
	bl	flash_check_bad_block
	cbnz	w0, .L2270
	adrp	x0, .LANCHOR105
	mov	w1, w23
	ldrh	w7, [x0, #:lo12:.LANCHOR105]
	mov	w0, w28
	mul	w26, w7, w19
	mov	w2, w26
	bl	flash_erase_block_en
	cbz	w0, .L2271
	adrp	x0, .LANCHOR68
	ldrb	w0, [x0, #:lo12:.LANCHOR68]
	cmp	w0, 2
	bne	.L2293
	adrp	x0, .LANCHOR0
	ldrb	w0, [x0, #:lo12:.LANCHOR0]
	cbz	w0, .L2293
	mov	w2, w26
	mov	w1, 1
	mov	w0, w28
	bl	flash_erase_block_en
	cbnz	w0, .L2293
.L2275:
	adrp	x0, .LANCHOR68
	mov	w23, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR68]
	add	w26, w26, w0, lsl 24
.L2274:
	adrp	x0, .LANCHOR121
	mov	w5, 1
	add	x3, x25, :lo12:.LANCHOR176
	add	x2, x24, :lo12:ftl_tmp_buffer
	ldrb	w4, [x0, #:lo12:.LANCHOR121]
	mov	w1, w26
	mov	w0, w28
	bl	flash_prog_page_en
	cbz	w0, .L2270
.L2293:
	mov	w1, w19
	mov	w0, w28
	bl	flash_mask_bad_block
.L2270:
	add	w22, w22, 1
	and	w22, w22, 65535
.L2278:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, w22
	bhi	.L2276
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2267
.L2271:
	cbz	w23, .L2274
	b	.L2275
.L2277:
	cbz	w23, .L2279
	adrp	x0, .LANCHOR7
	mov	w1, 2
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x21, x0, x21, uxth 2
	ldrb	w0, [x21, 2]
	bfi	w0, w1, 3, 2
	strb	w0, [x21, 2]
.L2279:
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
	bne	.L2294
	mov	w2, 2151
	adrp	x1, .LANCHOR177
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC0
	bl	printf
	adrp	x0, .LC130
	mov	w1, w20
	add	x0, x0, :lo12:.LC130
	bl	printf
.L2294:
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
	adrp	x21, .LANCHOR121
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR179
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR105
	stp	x27, x28, [sp, 80]
	mov	x26, x23
	ldrb	w2, [x21, #:lo12:.LANCHOR121]
	add	x25, x22, :lo12:.LANCHOR179
	add	x28, x23, :lo12:.LANCHOR105
	mov	w24, 0
	stp	x19, x20, [sp, 16]
	mov	w27, w0
	adrp	x20, .LANCHOR178
	lsl	w2, w2, 1
	add	x0, x20, :lo12:.LANCHOR178
	bl	ftl_memset
.L2298:
	add	x0, x22, :lo12:.LANCHOR179
	ldrb	w6, [x22, #:lo12:.LANCHOR179]
	ldrh	w19, [x23, #:lo12:.LANCHOR105]
	ldrh	w4, [x0, 2]
	adrp	x0, .LANCHOR97
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	ldr	w3, [x0, 4]
	add	w3, w3, 1
	str	w3, [x0, 4]
	add	x0, x20, :lo12:.LANCHOR178
	str	w27, [x20, #:lo12:.LANCHOR178]
	str	w3, [x0, 4]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2299
	mov	w2, w4
	mov	w1, w6
	str	w4, [x29, 96]
	adrp	x0, .LC132
	str	w6, [x29, 104]
	add	x0, x0, :lo12:.LC132
	bl	printf
	ldr	w4, [x29, 96]
	ldr	w6, [x29, 104]
.L2299:
	adrp	x1, .LANCHOR80
	ldrh	w0, [x25, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	cmp	w1, w0
	bhi	.L2300
	adrp	x19, .LANCHOR180
	adrp	x3, .LC0
	add	x19, x19, :lo12:.LANCHOR180
	add	x3, x3, :lo12:.LC0
.L2307:
	ldrb	w0, [x25, 1]
	adrp	x4, .LANCHOR26
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x25, 1]
	cmp	w0, 7
	bls	.L2301
	mov	x0, 0
.L2306:
	ldr	x2, [x4, #:lo12:.LANCHOR26]
	add	w1, w0, 8
	and	w24, w0, 65535
	add	x1, x2, x1, sxtw
	ldrb	w2, [x1, 32]
	add	w1, w2, 127
	and	w1, w1, 255
	cmp	w1, 125
	bhi	.L2302
	mov	x0, x3
	stp	x4, x3, [x29, 96]
	mov	w2, 742
	mov	x1, x19
	bl	printf
	ldp	x4, x3, [x29, 96]
.L2305:
	strb	w24, [x25, 1]
	mov	w24, 1
.L2301:
	ldr	x0, [x4, #:lo12:.LANCHOR26]
	ldrb	w1, [x25, 1]
	add	x0, x0, x1
	ldrb	w0, [x0, 40]
	strb	w0, [x25]
	cmp	w0, 255
	beq	.L2307
	ldrh	w19, [x28]
	mul	w19, w19, w0
	mov	w0, 0
	mov	w1, w19
	bl	flash_erase_block
	ldrb	w4, [x21, #:lo12:.LANCHOR121]
	mov	w1, w19
	add	x3, x20, :lo12:.LANCHOR178
	adrp	x2, ftl_info_data_buffer
	mov	w0, 0
	add	x2, x2, :lo12:ftl_info_data_buffer
	add	w19, w19, 1
	bl	ftl_prog_page
	mov	w0, 1
	strh	w0, [x25, 2]
.L2308:
	ldrb	w4, [x21, #:lo12:.LANCHOR121]
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
	beq	.L2309
	ldrb	w1, [x0, #:lo12:.LANCHOR181]
	cbz	w1, .L2310
.L2309:
	strb	wzr, [x0, #:lo12:.LANCHOR181]
	b	.L2298
.L2302:
	cmp	w2, 255
	bne	.L2305
	add	x0, x0, 1
	cmp	x0, 8
	bne	.L2306
	mov	w24, w0
	b	.L2305
.L2300:
	madd	w19, w19, w6, w4
	cbnz	w0, .L2308
	mov	w1, w19
	bl	flash_erase_block
	b	.L2308
.L2310:
	cbnz	w24, .L2311
.L2319:
	adrp	x0, .LANCHOR179
	ldrb	w0, [x0, #:lo12:.LANCHOR179]
	cmp	w0, 255
	bne	.L2313
	adrp	x1, .LANCHOR180
	adrp	x0, .LC0
	mov	w2, 778
	add	x1, x1, :lo12:.LANCHOR180
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2313:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2311:
	ldrb	w19, [x25, 1]
	adrp	x20, .LANCHOR180
	adrp	x21, .LC0
	add	x20, x20, :lo12:.LANCHOR180
	add	w19, w19, 1
	add	x21, x21, :lo12:.LC0
	adrp	x22, .LANCHOR26
.L2314:
	cmp	w19, 7
	bhi	.L2319
	ldr	x1, [x22, #:lo12:.LANCHOR26]
	add	w0, w19, 8
	add	x0, x1, x0, sxtw
	ldrb	w23, [x0, 32]
	add	w0, w23, 127
	and	w0, w0, 255
	cmp	w0, 125
	bhi	.L2315
	mov	w2, 771
	mov	x1, x20
	mov	x0, x21
	bl	printf
.L2316:
	ldrh	w1, [x26, #:lo12:.LANCHOR105]
	mov	w0, 0
	mul	w1, w1, w23
	bl	flash_erase_block
	b	.L2317
.L2315:
	cmp	w23, 255
	bne	.L2316
.L2317:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2314
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
	adrp	x22, .LANCHOR97
	stp	x25, x26, [sp, 64]
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	adrp	x21, .LANCHOR179
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR26
	stp	x27, x28, [sp, 80]
	adrp	x26, .LANCHOR105
	add	x1, x0, x1, lsl 2
	str	x1, [x22, #:lo12:.LANCHOR97]
	mov	w1, 0
	bl	ftl_memset
	mov	w1, 0
	mov	w2, 16384
	adrp	x0, ftl_ext_info_data_buffer
	add	x0, x0, :lo12:ftl_ext_info_data_buffer
	bl	ftl_memset
	adrp	x25, .LANCHOR121
	ldr	x1, [x23, #:lo12:.LANCHOR26]
	add	x0, x21, :lo12:.LANCHOR179
	mov	w27, 21574
	add	x26, x26, :lo12:.LANCHOR105
	add	x25, x25, :lo12:.LANCHOR121
	mov	x19, 7
	strb	wzr, [x0, 1]
	movk	w27, 0x494c, lsl 16
	ldrb	w1, [x1, 40]
	strb	w1, [x21, #:lo12:.LANCHOR179]
	strh	wzr, [x0, 2]
.L2335:
	ldr	x1, [x23, #:lo12:.LANCHOR26]
	add	w0, w19, 8
	sxth	w24, w19
	mov	w28, w19
	add	x0, x1, x0, sxtw
	ldrb	w0, [x0, 32]
	cmp	w0, 255
	bne	.L2334
.L2339:
	sub	x19, x19, #1
	cmn	x19, #1
	bne	.L2335
	mov	w24, 0
.L2336:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2340
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	mov	w2, 4800
	mov	w1, w19
	ldr	w3, [x0]
	adrp	x0, .LC134
	add	x0, x0, :lo12:.LC134
	bl	printf
.L2340:
	cmn	w19, #1
	bne	.L2341
	mov	w1, 0
	mov	w2, 16384
	add	x0, x20, :lo12:ftl_info_data_buffer
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	mov	w1, 21574
	movk	w1, 0x494c, lsl 16
	str	w1, [x0]
	mov	w1, 8
	movk	w1, 0x6, lsl 16
	str	w1, [x0, 12]
	mov	w0, w19
.L2333:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2334:
	ldrh	w6, [x26]
	add	x8, x20, :lo12:ftl_info_data_buffer
	ldrb	w4, [x25]
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
	bne	.L2337
	ldrb	w4, [x25]
	mov	x3, x7
	mov	x2, x8
	add	w1, w6, 1
	mov	w0, 0
	bl	ftl_read_page
	mov	w5, w0
.L2337:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2338
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	mov	w2, w5
	str	w5, [x29, 124]
	mov	w3, 672
	mov	w1, w28
	ldr	w4, [x0]
	adrp	x0, .LC133
	add	x0, x0, :lo12:.LC133
	bl	printf
	ldr	w5, [x29, 124]
.L2338:
	cmn	w5, #1
	beq	.L2339
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L2339
	mov	w19, w24
	b	.L2336
.L2341:
	ldr	x1, [x23, #:lo12:.LANCHOR26]
	add	w0, w24, 8
	add	x20, x20, :lo12:ftl_info_data_buffer
	mov	w4, 4
	mov	x2, x20
	adrp	x26, .LANCHOR121
	add	x0, x1, x0, sxtw
	mov	w27, 21574
	add	x26, x26, :lo12:.LANCHOR121
	movk	w27, 0x494c, lsl 16
	ldrb	w1, [x0, 32]
	add	x0, x21, :lo12:.LANCHOR179
	strb	w1, [x21, #:lo12:.LANCHOR179]
	strb	w24, [x0, 1]
	adrp	x24, .LANCHOR178
	add	x24, x24, :lo12:.LANCHOR178
	mov	w0, 0
	mov	x3, x24
	bl	flash_get_last_written_page
	sxth	w23, w0
	add	w0, w0, 1
	and	w19, w0, 65535
	adrp	x0, .LANCHOR105
	ldrb	w25, [x21, #:lo12:.LANCHOR179]
	ldrh	w0, [x0, #:lo12:.LANCHOR105]
	madd	w25, w25, w0, w23
.L2343:
	tbnz	w23, #31, .L2346
	ldrb	w4, [x26]
	mov	x3, x24
	mov	x2, x20
	mov	w1, w25
	mov	w0, 0
	bl	ftl_read_page
	cmn	w0, #1
	beq	.L2344
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L2344
.L2346:
	add	x21, x21, :lo12:.LANCHOR179
	strh	w19, [x21, 2]
	bl	ftl_tmp_into_update
	ldr	x1, [x22, #:lo12:.LANCHOR97]
	ldr	w0, [x1, 64]
	add	w0, w0, 1
	str	w0, [x1, 64]
	mov	w0, 0
	bl	ftl_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	mov	w0, 0
	b	.L2333
.L2344:
	sub	w23, w23, #1
	sub	w25, w25, #1
	sxth	w23, w23
	b	.L2343
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
	cbz	w1, .L2362
	str	wzr, [x0, 520]
.L2362:
	adrp	x20, .LANCHOR80
	adrp	x22, .LANCHOR184
	adrp	x21, .LANCHOR99
	add	x20, x20, :lo12:.LANCHOR80
	add	x22, x22, :lo12:.LANCHOR184
	add	x21, x21, :lo12:.LANCHOR99
	mov	w0, 0
	bl	ftl_total_vpn_update
.L2363:
	adrp	x23, .LANCHOR97
	mov	x24, x23
.L2366:
	ldr	x0, [x23, #:lo12:.LANCHOR97]
	ldr	w1, [x0, 56]
	add	w1, w1, 1
	str	w1, [x0, 56]
	ldrh	w1, [x0, 140]
	ldrh	w0, [x20]
	cmp	w1, w0
	bcc	.L2364
	bl	ftl_ext_alloc_new_blk
.L2364:
	ldr	x0, [x24, #:lo12:.LANCHOR97]
	ldrh	w1, [x0, 130]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2365
	adrp	x0, .LC0
	mov	w2, 1747
	mov	x1, x22
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2365:
	ldr	x1, [x24, #:lo12:.LANCHOR97]
	mov	w19, 21
	ldrh	w0, [x21]
	adrp	x26, .LANCHOR121
	adrp	x27, .LANCHOR178
	add	x25, x27, :lo12:.LANCHOR178
	sub	w0, w19, w0
	mov	w19, 1
	ldrh	w2, [x1, 130]
	lsl	w19, w19, w0
	sub	w19, w19, #1
	and	w19, w19, w2
	asr	w28, w2, w0
	adrp	x0, .LANCHOR105
	ldrh	w2, [x0, #:lo12:.LANCHOR105]
	ldrh	w0, [x1, 140]
	mov	w1, 0
	madd	w19, w19, w2, w0
	ldrb	w2, [x26, #:lo12:.LANCHOR121]
	mov	x0, x25
	and	w19, w19, 65535
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x0, [x24, #:lo12:.LANCHOR97]
	mov	w1, w19
	ldrb	w4, [x26, #:lo12:.LANCHOR121]
	mov	x3, x25
	str	wzr, [x27, #:lo12:.LANCHOR178]
	adrp	x2, ftl_ext_info_data_buffer
	add	x2, x2, :lo12:ftl_ext_info_data_buffer
	ldr	w0, [x0, 56]
	str	w0, [x25, 4]
	mov	w0, w28
	bl	ftl_prog_page
	ldr	x2, [x24, #:lo12:.LANCHOR97]
	ldrh	w1, [x2, 140]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 140]
	cmp	w1, 1
	beq	.L2366
	cmn	w0, #1
	adrp	x0, .LANCHOR183
	beq	.L2367
	ldrb	w1, [x0, #:lo12:.LANCHOR183]
	cbz	w1, .L2368
.L2367:
	strb	wzr, [x0, #:lo12:.LANCHOR183]
	b	.L2363
.L2368:
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
	mov	w4, 4
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR97
	strh	wzr, [x0, #:lo12:.LANCHOR115]
	mov	w19, 21
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR178
	ldrh	w1, [x0, 130]
	adrp	x0, .LANCHOR99
	stp	x25, x26, [sp, 64]
	add	x3, x24, :lo12:.LANCHOR178
	ldrh	w0, [x0, #:lo12:.LANCHOR99]
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
	tbz	x0, 12, .L2379
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	adrp	x1, .LANCHOR185
	and	w4, w21, 65535
	mov	w3, w22
	mov	w2, 1791
	add	x1, x1, :lo12:.LANCHOR185
	ldrh	w5, [x0, 130]
	adrp	x0, .LC135
	add	x0, x0, :lo12:.LC135
	bl	printf
.L2379:
	adrp	x26, .LANCHOR121
	adrp	x28, .LANCHOR105
	mov	w5, 20038
	add	x26, x26, :lo12:.LANCHOR121
	add	x28, x28, :lo12:.LANCHOR105
	mov	w23, 0
	movk	w5, 0x4549, lsl 16
.L2380:
	and	w21, w22, 65535
	sub	w0, w21, w23
	tbnz	x0, 15, .L2385
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
	beq	.L2381
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x0]
	cmp	w0, w5
	bne	.L2381
.L2385:
	bl	zftl_sblk_list_init
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	ldrh	w1, [x0, 140]
	cmp	w1, w22
	bgt	.L2383
	add	w21, w21, 1
	strh	w21, [x0, 140]
	bl	ftl_ext_info_flush
.L2383:
	adrp	x0, .LANCHOR10
	mov	w1, -1
	ldp	x19, x20, [sp, 16]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	strh	w1, [x0, 584]
	ldp	x25, x26, [sp, 64]
	strh	w1, [x0, 586]
	ldp	x27, x28, [sp, 80]
	strh	w1, [x0, 588]
	strh	w1, [x0, 590]
	str	wzr, [x0, 520]
	str	wzr, [x0, 604]
	str	wzr, [x0, 608]
	adrp	x0, .LANCHOR63
	strh	w1, [x0, #:lo12:.LANCHOR63]
	mov	w0, 0
	ldp	x29, x30, [sp], 112
	ret
.L2381:
	add	w23, w23, 1
	b	.L2380
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
	adrp	x19, .LANCHOR97
	mov	w0, 1
	bl	ftl_alloc_sblk
	mov	w1, 0
	mov	w21, w0
	bl	ftl_erase_sblk
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	mov	w0, w21
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	ldrh	w20, [x0, 672]
	strh	wzr, [x0, 690]
	mov	w0, 65533
	sub	w1, w20, #1
	cmp	w0, w1, uxth
	bcs	.L2394
	adrp	x1, .LANCHOR186
	adrp	x0, .LC0
	mov	w2, 1974
	add	x1, x1, :lo12:.LANCHOR186
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2394:
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	mov	w2, 256
	mov	w1, 255
	add	x0, x0, 416
	strh	wzr, [x0, 280]
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	mov	w2, 4096
	mov	w1, 0
	add	x0, x0, 704
	bl	ftl_memset
	adrp	x1, .LANCHOR99
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	ldrh	w2, [x1, #:lo12:.LANCHOR99]
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
	ldr	x0, [x19, #:lo12:.LANCHOR97]
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
	ldr	x1, [x19, #:lo12:.LANCHOR97]
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
	adrp	x0, .LC136
	add	x0, x0, :lo12:.LC136
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR188
	stp	x21, x22, [sp, 32]
	add	x20, x20, :lo12:.LANCHOR188
	stp	x25, x26, [sp, 64]
	adrp	x22, .LANCHOR26
	mov	x25, x22
	stp	x23, x24, [sp, 48]
	mov	w19, 8
	adrp	x23, .LC0
	bl	printf
.L2399:
	ldr	x0, [x22, #:lo12:.LANCHOR26]
	add	x0, x0, x19, sxtw
	ldrb	w21, [x0, 32]
	add	w0, w21, 127
	and	w0, w0, 255
	cmp	w0, 125
	bhi	.L2397
	mov	w2, 2028
	mov	x1, x20
	add	x0, x23, :lo12:.LC0
	bl	printf
.L2397:
	cmp	w21, 255
	beq	.L2398
	adrp	x0, .LANCHOR105
	ldrh	w1, [x0, #:lo12:.LANCHOR105]
	mov	w0, 0
	mul	w1, w1, w21
	bl	flash_erase_block
.L2398:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L2399
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
.L2400:
	cmp	x0, x2
	bne	.L2401
	adrp	x21, .LANCHOR97
	mov	w1, 21574
	adrp	x24, .LANCHOR59
	add	x24, x24, :lo12:.LANCHOR59
	ldr	x0, [x21, #:lo12:.LANCHOR97]
	movk	w1, 0x494c, lsl 16
	mov	w20, 0
	mov	w26, 1
	strh	wzr, [x0, 148]
	str	w1, [x0]
.L2402:
	ldrh	w0, [x19, #:lo12:.LANCHOR6]
	adrp	x23, .LANCHOR98
	cmp	w0, w20
	bhi	.L2410
	ldr	x0, [x25, #:lo12:.LANCHOR26]
	mov	w4, 3
	ldrb	w2, [x23, #:lo12:.LANCHOR98]
	mov	w10, 15
	ldr	x6, [x21, #:lo12:.LANCHOR97]
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
.L2413:
	cmp	w2, 4
	add	x1, x1, 4
	csel	w7, w10, w4, eq
	strb	w7, [x1, -1]
	ldrb	w7, [x1, -2]
	orr	w7, w7, -32
	strb	w7, [x1, -2]
	cmp	x1, x0
	bne	.L2413
	mul	w5, w5, w8
	mov	w4, 16
	add	w0, w3, w8
	sdiv	w4, w4, w2
	add	w0, w5, w0, uxth
	strh	w0, [x6, 148]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	add	w4, w20, w4
	and	w4, w4, 65535
	strh	w4, [x6, 134]
	tbz	x0, 12, .L2414
	adrp	x0, .LC137
	mov	w3, w20
	mov	w2, 128
	mov	w1, 2074
	add	x0, x0, :lo12:.LC137
	bl	printf
.L2414:
	ldr	x0, [x21, #:lo12:.LANCHOR97]
	mov	w2, 128
	mov	w1, 255
	add	x0, x0, 160
	bl	ftl_memset
	adrp	x0, .LANCHOR106
	ldrb	w13, [x23, #:lo12:.LANCHOR98]
	ldr	x2, [x21, #:lo12:.LANCHOR97]
	mov	w4, 21
	ldrb	w15, [x0, #:lo12:.LANCHOR106]
	adrp	x0, .LANCHOR99
	and	w16, w13, 65535
	ldr	x14, [x22, #:lo12:.LANCHOR7]
	ldrh	w0, [x0, #:lo12:.LANCHOR99]
	mov	w3, 0
	ldrh	w12, [x2, 134]
	sub	w0, w4, w0
	mul	w1, w20, w16
	mov	w4, 1
	lsl	w4, w4, w0
	and	w1, w1, 65535
	and	w4, w4, 65535
.L2415:
	cmp	w20, w12
	bcc	.L2421
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
.L2401:
	ldrb	w1, [x0, 2]
	add	x0, x0, 4
	and	w1, w1, 31
	bfi	w1, w3, 3, 2
	strb	w1, [x0, -2]
	b	.L2400
.L2410:
	strh	w20, [x24]
	mov	w0, w20
	bl	ftl_test_block
	ldrb	w11, [x23, #:lo12:.LANCHOR98]
	adrp	x0, .LANCHOR106
	ldr	x6, [x22, #:lo12:.LANCHOR7]
	mov	w7, 0
	ldrb	w14, [x0, #:lo12:.LANCHOR106]
	mov	w10, 0
	ldr	x13, [x21, #:lo12:.LANCHOR97]
	mov	w8, 0
	mul	w12, w20, w11
	add	x6, x6, x20, uxth 2
.L2403:
	cmp	w8, w14
	bcs	.L2407
	add	w15, w11, w7
	b	.L2408
.L2406:
	add	w1, w7, w12
	mov	w0, w8
	bl	flash_check_bad_block
	cbz	w0, .L2404
	ldrb	w1, [x6, 3]
	lsl	w0, w26, w7
	orr	w0, w0, w1
	strb	w0, [x6, 3]
	ldrh	w0, [x13, 148]
	add	w0, w0, 1
	strh	w0, [x13, 148]
.L2405:
	add	w7, w7, 1
.L2408:
	cmp	w7, w15
	bne	.L2406
	add	w8, w8, 1
	sub	w12, w12, w11
	and	w8, w8, 65535
	b	.L2403
.L2404:
	add	w10, w10, 1
	and	w10, w10, 65535
	b	.L2405
.L2407:
	cbnz	w10, .L2409
	ldrb	w0, [x6, 2]
	orr	w0, w0, -32
	strb	w0, [x6, 2]
.L2409:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2402
.L2421:
	add	x10, x14, x20, uxth 2
	mov	w6, 0
	mov	w8, 0
	mov	w5, 0
	ldrb	w0, [x10, 2]
	orr	w0, w0, -32
	strb	w0, [x10, 2]
.L2416:
	cmp	w5, w15
	bcc	.L2423
	add	w20, w20, 1
	add	w1, w16, w1
	and	w20, w20, 65535
	and	w1, w1, 65535
	b	.L2415
.L2419:
	ldrb	w11, [x10, 3]
	add	w17, w8, w7
	asr	w11, w11, w17
	tbnz	x11, 0, .L2417
	cmp	w13, 1
	bls	.L2422
	and	w0, w0, 1
	add	w0, w1, w0
	and	w0, w0, 65535
.L2418:
	add	x11, x2, x3, sxtw 1
	add	w3, w3, 1
	and	w3, w3, 65535
	add	w0, w0, w6
	strh	w0, [x11, 160]
.L2417:
	add	x7, x7, 1
.L2420:
	and	w0, w7, 65535
	cmp	w0, w16
	bcc	.L2419
	add	w5, w5, 1
	add	w6, w6, w4
	and	w5, w5, 65535
	add	w8, w8, w13
	and	w6, w6, 65535
	b	.L2416
.L2422:
	mov	w0, w1
	b	.L2418
.L2423:
	mov	x7, 0
	b	.L2420
	.size	ftl_low_format, .-ftl_low_format
	.section	.text.ftl_re_low_format,"ax",@progbits
	.align	2
	.global	ftl_re_low_format
	.type	ftl_re_low_format, %function
ftl_re_low_format:
	stp	x29, x30, [sp, -16]!
	mov	w1, 1
	adrp	x0, .LC138
	add	x0, x0, :lo12:.LC138
	add	x29, sp, 0
	bl	printf
	bl	sblk_init
	bl	ftl_info_blk_init
	bl	ftl_ext_info_init
	adrp	x0, .LANCHOR97
	adrp	x2, .LANCHOR6
	mov	w3, 0
	mov	w4, 0
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	mov	w5, 0
	ldrh	w7, [x2, #:lo12:.LANCHOR6]
	adrp	x2, .LANCHOR7
	ldr	x2, [x2, #:lo12:.LANCHOR7]
	ldrh	w1, [x0, 134]
	add	x2, x2, x1, uxth 2
.L2434:
	cmp	w1, w7
	bcc	.L2438
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
.L2438:
	ldrb	w6, [x2, 2]
	and	w8, w6, 31
	strb	w8, [x2, 2]
	ands	w6, w6, 24
	bne	.L2435
	add	w5, w5, 1
	and	w5, w5, 65535
.L2436:
	add	w1, w1, 1
	add	x2, x2, 4
	and	w1, w1, 65535
	b	.L2434
.L2435:
	cmp	w6, 16
	bne	.L2437
	add	w4, w4, 1
	and	w4, w4, 65535
	b	.L2436
.L2437:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L2436
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
	bne	.L2443
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
	beq	.L2444
	ldrh	w0, [x19]
	add	x20, x20, x22, uxth 2
	bl	ftl_vpn_decrement
	adrp	x0, .LANCHOR176
	mov	w1, 15555
	add	x6, x0, :lo12:.LANCHOR176
	movk	w1, 0xf55f, lsl 16
	str	w1, [x0, #:lo12:.LANCHOR176]
	adrp	x0, .LANCHOR80
	ldrh	w1, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR73
	ldrb	w0, [x0, #:lo12:.LANCHOR73]
	mul	w1, w1, w0
	mov	x0, x20
	lsl	w1, w1, 2
	bl	js_hash
	stp	w0, wzr, [x6, 4]
	adrp	x0, .LANCHOR121
	mov	x2, x6
	mov	x1, x20
	ldrb	w3, [x0, #:lo12:.LANCHOR121]
	mov	w0, w21
	str	wzr, [x6, 12]
	bl	ftl_prog_ppa_page
.L2444:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L2443:
	mov	w0, -1
	ret
	.size	ftl_write_last_log_page, .-ftl_write_last_log_page
	.section	.text.ftl_open_sblk_recovery,"ax",@progbits
	.align	2
	.global	ftl_open_sblk_recovery
	.type	ftl_open_sblk_recovery, %function
ftl_open_sblk_recovery:
	stp	x29, x30, [sp, -144]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR14
	stp	x27, x28, [sp, 80]
	mov	x28, x0
	ldr	w0, [x22, #:lo12:.LANCHOR14]
	stp	x25, x26, [sp, 64]
	mov	x25, x1
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	tbz	x0, 12, .L2450
	ldrh	w1, [x28, 2]
	adrp	x0, .LC139
	add	x0, x0, :lo12:.LC139
	bl	printf
.L2450:
	ldr	w0, [x22, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2451
	ldrb	w1, [x28, 5]
	adrp	x0, .LC140
	add	x0, x0, :lo12:.LC140
	bl	printf
.L2451:
	ldr	w0, [x22, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2452
	ldrh	w1, [x28]
	adrp	x0, .LC141
	add	x0, x0, :lo12:.LC141
	bl	printf
.L2452:
	ldr	w0, [x22, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2453
	ldrh	w2, [x28, 18]
	adrp	x0, .LC142
	ldrh	w1, [x28, 16]
	add	x0, x0, :lo12:.LC142
	bl	printf
.L2453:
	ldrh	w0, [x28, 10]
	strh	w0, [x28, 14]
	adrp	x0, .LANCHOR6
	ldrh	w1, [x28]
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w1, w0
	bcs	.L2449
	mov	w0, 1
	bl	buf_alloc
	ldrb	w20, [x28, 5]
	mov	x19, x0
	ldrh	w21, [x28, 2]
	adrp	x26, .LANCHOR121
	mov	w27, 0
	add	x0, x26, :lo12:.LANCHOR121
	adrp	x23, .LANCHOR80
	str	x0, [x29, 128]
.L2456:
	ldrh	w0, [x23, #:lo12:.LANCHOR80]
	cmp	w0, w21
	bhi	.L2469
.L2459:
	ldrh	w0, [x28, 10]
	ldrh	w1, [x28, 6]
	ldrh	w2, [x23, #:lo12:.LANCHOR80]
	add	w1, w1, w0
	ldrb	w0, [x28, 9]
	strh	w21, [x28, 2]
	strb	w20, [x28, 5]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L2470
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 1473
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2470:
	adrp	x21, .LANCHOR111
	ldrh	w3, [x28, 10]
	mov	w0, 0
	mov	w1, 0
	ldr	x5, [x21, #:lo12:.LANCHOR111]
.L2471:
	cmp	w1, w3
	bcc	.L2473
	ldrb	w20, [x28, 9]
	adrp	x24, .LANCHOR9
	ldrh	w1, [x23, #:lo12:.LANCHOR80]
	madd	w20, w20, w1, w0
	ldr	w0, [x22, #:lo12:.LANCHOR14]
	sub	w20, w20, w3
	and	w20, w20, 65535
	tbz	x0, 12, .L2474
	ldrh	w1, [x28]
	ldr	x2, [x24, #:lo12:.LANCHOR9]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC143
	mov	w2, w20
	add	x0, x0, :lo12:.LC143
	bl	printf
.L2474:
	ldr	x0, [x24, #:lo12:.LANCHOR9]
	adrp	x25, .LANCHOR121
	ldrh	w1, [x28]
	adrp	x24, .LANCHOR73
	adrp	x26, .LC144
	add	x24, x24, :lo12:.LANCHOR73
	add	x25, x25, :lo12:.LANCHOR121
	add	x26, x26, :lo12:.LC144
	strh	w20, [x0, x1, lsl 1]
	mov	w20, 0
	mov	x0, x19
	bl	buf_free
.L2475:
	ldrb	w0, [x24]
	cmp	w20, w0, lsl 1
	bcc	.L2478
	ldrh	w1, [x28, 12]
	ldrh	w0, [x23, #:lo12:.LANCHOR80]
	ldrb	w2, [x28, 9]
	madd	w0, w0, w2, w1
	mov	x1, -4
	add	x0, x1, x0, sxtw 2
	ldr	x1, [x21, #:lo12:.LANCHOR111]
	ldr	w0, [x1, x0]
	cmn	w0, #1
	beq	.L2479
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 1503
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2479:
	ldrh	w0, [x28, 6]
	cmp	w0, 1
	bne	.L2449
	ldp	x19, x20, [sp, 16]
	mov	x0, x28
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	b	ftl_write_last_log_page
.L2469:
	ldrb	w20, [x28, 5]
	adrp	x24, .LANCHOR105
	add	x0, x24, :lo12:.LANCHOR105
	str	x0, [x29, 136]
.L2457:
	ldrb	w0, [x28, 9]
	cmp	w0, w20
	bhi	.L2468
	add	w21, w21, 1
	strb	wzr, [x28, 5]
	and	w21, w21, 65535
	b	.L2456
.L2468:
	add	x0, x28, x20, sxtw 1
	mov	w1, 65535
	ldrh	w0, [x0, 16]
	cmp	w0, w1
	beq	.L2458
	ldr	x1, [x29, 136]
	ldrb	w3, [x26, #:lo12:.LANCHOR121]
	ldr	x2, [x19, 24]
	ldrh	w5, [x1]
	ldr	x1, [x19, 8]
	madd	w0, w5, w0, w21
	bl	ftl_read_ppa_page
	mov	w24, w0
	cmp	w0, 512
	beq	.L2459
	cmn	w0, #1
	beq	.L2460
	ldr	x0, [x19, 24]
	ldr	w1, [x0]
	cmn	w1, #1
	bne	.L2460
	ldr	w0, [x0, 4]
	cmn	w0, #1
	bne	.L2460
	ldr	x0, [x19, 8]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L2459
.L2460:
	adrp	x0, .LANCHOR182
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR182]
	ldrb	w0, [x28, 9]
	ldrh	w1, [x28, 10]
	madd	w0, w0, w21, w20
	cmp	w1, w0
	beq	.L2461
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 1396
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2461:
	ldrh	w0, [x28, 10]
	ldrh	w1, [x28, 6]
	ldrb	w2, [x28, 9]
	add	w1, w1, w0
	ldrh	w0, [x23, #:lo12:.LANCHOR80]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L2462
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 1397
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2462:
	cmn	w24, #1
	beq	.L2464
	ldr	x0, [x19, 24]
	ldr	w0, [x0, 4]
	cmn	w0, #1
	beq	.L2464
	bl	lpa_hash_get_ppa
	cbz	x25, .L2466
	ldr	x3, [x19, 24]
	ldr	w1, [x3, 8]
	cmp	w0, w1
	beq	.L2466
	cmn	w0, #1
	beq	.L2466
	adrp	x6, .LANCHOR99
	mov	w5, 21
	mov	w27, 1
	ldrh	w7, [x6, #:lo12:.LANCHOR99]
	sub	w1, w5, w7
	lsr	w2, w0, w7
	adrp	x7, .LANCHOR98
	lsl	w1, w27, w1
	sub	w1, w1, #1
	and	w1, w1, w2
	ldrb	w2, [x7, #:lo12:.LANCHOR98]
	udiv	w1, w1, w2
	ldrh	w2, [x25]
	cmp	w2, w1, uxth
	bne	.L2466
	ldr	x1, [x29, 128]
	adrp	x8, .LANCHOR178
	ldr	w10, [x3]
	add	x2, x8, :lo12:.LANCHOR178
	stp	w5, w10, [x29, 112]
	str	x8, [x29, 120]
	ldrb	w3, [x1]
	ldr	x1, [x19, 8]
	stp	x7, x6, [x29, 96]
	bl	ftl_read_ppa_page
	ldr	x8, [x29, 120]
	ldr	w10, [x29, 116]
	ldr	w0, [x8, #:lo12:.LANCHOR178]
	cmp	w10, w0
	bhi	.L2466
	ldr	x0, [x19, 24]
	ldr	w0, [x0, 8]
	cmn	w0, #1
	beq	.L2464
	ldp	x7, x6, [x29, 96]
	ldr	w5, [x29, 112]
	ldrh	w1, [x6, #:lo12:.LANCHOR99]
	sub	w5, w5, w1
	lsr	w0, w0, w1
	lsl	w27, w27, w5
	sub	w27, w27, #1
	and	w27, w27, w0
	ldrb	w0, [x7, #:lo12:.LANCHOR98]
	udiv	w0, w27, w0
	bl	ftl_vpn_decrement
.L2464:
	ldrh	w0, [x28, 6]
	mov	w27, 1
	sub	w0, w0, #1
	strh	w0, [x28, 6]
	ldrh	w0, [x28, 10]
	add	w0, w0, 1
	strh	w0, [x28, 10]
.L2458:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2457
.L2473:
	ldrh	w2, [x28, 12]
	add	w2, w2, w1
	ldr	w2, [x5, x2, lsl 2]
	cmn	w2, #1
	beq	.L2472
	add	w20, w0, 1
	and	w0, w20, 65535
.L2472:
	add	w1, w1, 1
	b	.L2471
.L2478:
	cbz	w27, .L2476
	ldrh	w0, [x28, 6]
	cmp	w0, 1
	bls	.L2476
	mov	x0, x28
	bl	ftl_get_new_free_page
	mov	w4, w0
	ldr	w0, [x22, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2477
	mov	w1, w4
	str	w4, [x29, 136]
	mov	x0, x26
	bl	printf
	ldr	w4, [x29, 136]
.L2477:
	adrp	x0, .LANCHOR97
	ldr	x2, [x19, 24]
	ldr	x1, [x19, 8]
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	ldr	w0, [x0, 8]
	str	w0, [x2]
	str	wzr, [x2, 12]
	mov	w0, -1
	stp	w0, w0, [x2, 4]
	mov	w0, w4
	str	wzr, [x1]
	ldrb	w3, [x25]
	bl	ftl_prog_ppa_page
	ldrh	w0, [x28]
	bl	ftl_vpn_decrement
.L2476:
	add	w20, w20, 1
	b	.L2475
.L2466:
	ldr	x3, [x19, 24]
	adrp	x0, .LANCHOR118
	ldr	w0, [x0, #:lo12:.LANCHOR118]
	ldr	w1, [x3, 4]
	cmp	w1, w0
	bcs	.L2464
	ldrb	w0, [x28, 9]
	ldrh	w1, [x23, #:lo12:.LANCHOR80]
	ldrh	w2, [x28, 10]
	mul	w0, w0, w1
	sub	w0, w0, #1
	cmp	w2, w0
	bge	.L2464
	adrp	x0, .LANCHOR97
	ldr	w1, [x3]
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	ldr	w5, [x0, 8]
	cmp	w1, w5
	bls	.L2467
	str	w1, [x0, 8]
.L2467:
	ldrh	w0, [x28, 12]
	add	w2, w2, w0
	ldp	w0, w1, [x3, 4]
	bl	lpa_hash_update_ppa
	b	.L2464
.L2449:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
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
	adrp	x21, .LANCHOR80
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR105
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR97
	mov	x25, x1
	add	x21, x21, :lo12:.LANCHOR80
	mov	x20, x23
	add	x22, x22, :lo12:.LANCHOR105
	mov	w24, 65535
	str	x27, [sp, 80]
.L2529:
	ldr	x0, [x23, #:lo12:.LANCHOR97]
	ldr	w1, [x0, 48]
	ldrh	w2, [x0, 696]
	add	w1, w1, 1
	str	w1, [x0, 48]
	ldrh	w1, [x21]
	cmp	w2, w1
	bcs	.L2530
	ldrh	w0, [x0, 692]
	cmp	w0, w24
	bne	.L2531
.L2530:
	bl	pm_alloc_new_blk
	mov	w0, 0
	bl	ftl_info_flush
.L2531:
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	ldrh	w0, [x0, 692]
	cmp	w0, w24
	bne	.L2532
	adrp	x1, .LANCHOR190
	adrp	x0, .LC0
	mov	w2, 230
	add	x1, x1, :lo12:.LANCHOR190
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2532:
	ldr	x0, [x20, #:lo12:.LANCHOR97]
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
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	str	w19, [x3]
	ldr	w1, [x0, 48]
	ldrb	w0, [x0, 694]
	str	w1, [x3, 4]
	adrp	x1, .LANCHOR121
	ldrb	w4, [x1, #:lo12:.LANCHOR121]
	mov	w1, w26
	bl	ftl_prog_page
	ldr	x2, [x20, #:lo12:.LANCHOR97]
	ldrh	w1, [x2, 696]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 696]
	cmp	w1, 1
	adrp	x1, .LANCHOR192
	beq	.L2533
	ldrb	w3, [x1, #:lo12:.LANCHOR192]
	cbz	w3, .L2534
.L2533:
	strb	wzr, [x1, #:lo12:.LANCHOR192]
	b	.L2529
.L2534:
	cmn	w0, #1
	bne	.L2536
	mov	w1, w26
	adrp	x0, .LC145
	add	x0, x0, :lo12:.LC145
	bl	printf
	b	.L2529
.L2536:
	ldrh	w0, [x2, 698]
	cmp	w19, w0
	bcs	.L2537
	add	x19, x2, x19, uxtw 2
	str	w26, [x19, 704]
.L2537:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
	.size	pm_write_page, .-pm_write_page
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
	tbz	x0, 12, .L2543
	adrp	x2, .LANCHOR193
	adrp	x0, .LC84
	add	x2, x2, :lo12:.LANCHOR193
	mov	w1, 251
	add	x0, x0, :lo12:.LC84
	bl	printf
.L2543:
	adrp	x23, .LANCHOR158
	adrp	x20, .LANCHOR26
	mov	w2, 64
	mov	w1, 0
	ldr	x0, [x23, #:lo12:.LANCHOR158]
	adrp	x21, .LANCHOR159
	adrp	x22, .LANCHOR2
	adrp	x24, .LC147
	adrp	x25, .LANCHOR135
	add	x22, x22, :lo12:.LANCHOR2
	add	x24, x24, :lo12:.LC147
	add	x25, x25, :lo12:.LANCHOR135
	bl	ftl_memset
	add	x27, x21, :lo12:.LANCHOR159
	ldr	x1, [x20, #:lo12:.LANCHOR26]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC146
	add	x0, x0, :lo12:.LC146
	mov	w26, 0
	bl	rknand_print_hex
	ldr	x6, [x20, #:lo12:.LANCHOR26]
	add	x0, x6, 16
	ldr	w1, [x6, 8]
	bl	js_hash
	str	w0, [x6, 12]
.L2544:
	add	x28, x21, :lo12:.LANCHOR159
	ldrb	w4, [x21, #:lo12:.LANCHOR159]
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
	blt	.L2545
	ldr	x6, [x20, #:lo12:.LANCHOR26]
	ldrb	w7, [x28, 1]
	strh	wzr, [x28, 2]
	ldr	w0, [x6, 4]
	ldrh	w1, [x6, 16]
	add	w0, w0, 1
	str	w0, [x6, 4]
	ldrb	w0, [x21, #:lo12:.LANCHOR159]
	add	w1, w1, 1
	strb	w0, [x28, 1]
	mov	x0, x6
	strb	w7, [x21, #:lo12:.LANCHOR159]
	strh	w1, [x0, 16]!
	ldr	w1, [x6, 8]
	bl	js_hash
	ldrh	w19, [x22]
	str	w0, [x6, 12]
	mul	w19, w19, w7
.L2554:
	mov	w1, w19
	mov	w0, 0
	bl	flash_erase_block
	b	.L2546
.L2549:
	mov	w26, 1
	b	.L2544
.L2545:
	madd	w19, w19, w4, w3
	cbz	w1, .L2554
.L2546:
	ldr	x2, [x20, #:lo12:.LANCHOR26]
	mov	w1, w19
	ldr	x3, [x23, #:lo12:.LANCHOR158]
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
	bne	.L2547
	mov	w1, w19
	adrp	x0, .LC148
	add	x0, x0, :lo12:.LC148
	bl	printf
	b	.L2544
.L2547:
	cbz	w26, .L2549
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
	.size	flash_info_flush, .-flash_info_flush
	.section	.text.nand_flash_init,"ax",@progbits
	.align	2
	.global	nand_flash_init
	.type	nand_flash_init, %function
nand_flash_init:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR14
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	tbz	x0, 12, .L2556
	adrp	x2, .LANCHOR194
	adrp	x0, .LC84
	add	x2, x2, :lo12:.LANCHOR194
	mov	w1, 2209
	add	x0, x0, :lo12:.LC84
	bl	printf
.L2556:
	mov	x0, x19
	adrp	x23, .LANCHOR16
	bl	nandc_init
	adrp	x19, .LANCHOR34
	adrp	x20, .LANCHOR41
	add	x0, x19, :lo12:.LANCHOR34
	add	x24, x20, :lo12:.LANCHOR41
	str	x0, [x23, #:lo12:.LANCHOR16]
	adrp	x25, .LANCHOR35
	adrp	x0, .LANCHOR18
	add	x25, x25, :lo12:.LANCHOR35
	mov	x26, x24
	mov	w1, 1
	mov	x22, 0
	mov	w27, 2
	mov	w28, 44
	strb	w1, [x0, #:lo12:.LANCHOR18]
	mov	w2, 8
	mov	w1, 0
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	bl	ftl_memset
	mov	w2, 32
	mov	w1, 0
	adrp	x0, .LANCHOR136
	add	x0, x0, :lo12:.LANCHOR136
	bl	ftl_memset
.L2562:
	mov	x1, x24
	mov	w0, w22
	bl	flash_read_id
	strb	w27, [x22, x25]
	cbnz	x22, .L2557
	ldrb	w0, [x26]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 253
	bls	.L2558
.L2560:
	mov	w19, -2
.L2555:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2558:
	ldrb	w0, [x26, 1]
	cmp	w0, 255
	beq	.L2560
.L2557:
	ldrb	w0, [x24]
	cmp	w0, 181
	bne	.L2561
	strb	w28, [x24]
.L2561:
	add	x22, x22, 1
	add	x24, x24, 8
	cmp	x22, 4
	bne	.L2562
	adrp	x0, .LANCHOR195
	add	x8, x0, :lo12:.LANCHOR195
	add	x8, x8, 1
	mov	x7, x0
	add	x12, x20, :lo12:.LANCHOR41
	mov	x10, 0
.L2565:
	ldrb	w2, [x8, -1]
	mov	w11, w10
	lsl	x24, x10, 5
	mov	x1, x12
	mov	x0, x8
	bl	flash_mem_cmp8
	cbnz	w0, .L2563
	add	x0, x7, :lo12:.LANCHOR195
	ubfiz	x11, x11, 5, 32
	add	x24, x0, x24
	add	x0, x0, x11
	adrp	x1, .LANCHOR196
	add	x4, x1, :lo12:.LANCHOR196
	ldrb	w3, [x0, 22]
	mov	x0, 0
.L2564:
	lsl	x5, x0, 5
	mov	w2, w0
	ldrb	w5, [x5, x4]
	cmp	w5, w3
	beq	.L2566
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L2564
	mov	w2, w0
.L2566:
	ubfiz	x0, x2, 5, 32
	add	x1, x1, :lo12:.LANCHOR196
	add	x1, x1, x0
	mov	w2, 32
	adrp	x0, .LANCHOR19
	add	x0, x0, :lo12:.LANCHOR19
	bl	ftl_memcpy
	add	x22, x19, :lo12:.LANCHOR34
	mov	x1, x24
	adrp	x24, .LANCHOR27
	mov	w2, 32
	mov	x0, x22
	bl	ftl_memcpy
	ldrb	w0, [x24, #:lo12:.LANCHOR27]
	cmp	w0, 8
	bhi	.L2567
	ldrb	w1, [x22, 20]
	cmp	w1, 60
	bls	.L2568
	mov	w1, 60
	strb	w1, [x22, 20]
.L2568:
	cmp	w0, 8
	bne	.L2567
	ldrb	w0, [x20, #:lo12:.LANCHOR41]
	cmp	w0, 44
	bne	.L2567
	add	x0, x19, :lo12:.LANCHOR34
	ldrb	w1, [x0, 28]
	cmp	w1, 3
	bne	.L2567
	strb	wzr, [x0, 28]
.L2567:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2569
	adrp	x2, .LANCHOR194
	adrp	x0, .LC84
	add	x2, x2, :lo12:.LANCHOR194
	mov	w1, 2233
	add	x0, x0, :lo12:.LC84
	bl	printf
.L2569:
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR161
	adrp	x22, .LANCHOR26
	add	x20, x19, :lo12:.LANCHOR34
	str	x0, [x1, #:lo12:.LANCHOR161]
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR151
	str	x0, [x1, #:lo12:.LANCHOR151]
	mov	w0, 2048
	bl	ftl_malloc
	str	x0, [x22, #:lo12:.LANCHOR26]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR160
	str	x0, [x1, #:lo12:.LANCHOR160]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR153
	str	x0, [x1, #:lo12:.LANCHOR153]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR158
	str	x0, [x1, #:lo12:.LANCHOR158]
	adrp	x0, .LANCHOR168
	strb	wzr, [x0, #:lo12:.LANCHOR168]
	bl	flash_die_info_init
	ldrb	w0, [x20, 18]
	bl	flash_lsb_page_tbl_build
	ldrb	w0, [x20, 20]
	adrp	x20, .LANCHOR156
	bl	nandc_bch_sel
	str	xzr, [x20, #:lo12:.LANCHOR156]
	ldr	x1, [x23, #:lo12:.LANCHOR16]
	adrp	x23, .LANCHOR42
	ldrh	w0, [x1, 16]
	ubfx	x2, x0, 8, 3
	strb	w2, [x23, #:lo12:.LANCHOR42]
	adrp	x2, .LANCHOR165
	ubfx	x3, x0, 3, 1
	strb	w3, [x2, #:lo12:.LANCHOR165]
	adrp	x2, .LANCHOR38
	ubfx	x3, x0, 4, 1
	strb	w3, [x2, #:lo12:.LANCHOR38]
	adrp	x2, .LANCHOR70
	ubfx	x3, x0, 12, 1
	strb	w3, [x2, #:lo12:.LANCHOR70]
	adrp	x2, .LANCHOR104
	ubfx	x3, x0, 13, 1
	ubfx	x0, x0, 14, 1
	strb	w3, [x2, #:lo12:.LANCHOR104]
	adrp	x2, .LANCHOR1
	strb	w0, [x2, #:lo12:.LANCHOR1]
	mov	w2, 60
	ldrb	w0, [x1, 28]
	adrp	x1, .LANCHOR0
	strb	w0, [x1, #:lo12:.LANCHOR0]
	adrp	x1, .LANCHOR17
	strb	w2, [x1, #:lo12:.LANCHOR17]
	ldrb	w2, [x24, #:lo12:.LANCHOR27]
	cmp	w2, 9
	bne	.L2570
	mov	w2, 70
	strb	w2, [x1, #:lo12:.LANCHOR17]
.L2570:
	add	x19, x19, :lo12:.LANCHOR34
	adrp	x1, .LANCHOR169
	adrp	x25, .LANCHOR23
	strb	w0, [x1, #:lo12:.LANCHOR169]
	ldrh	w1, [x19, 16]
	ldrb	w0, [x19, 19]
	strb	w0, [x25, #:lo12:.LANCHOR23]
	tbz	x1, 6, .L2572
	sub	w1, w0, #17
	and	w1, w1, 255
	cmp	w1, 2
	bhi	.L2573
	adrp	x1, micron_read_retrial
	add	x1, x1, :lo12:micron_read_retrial
	str	x1, [x20, #:lo12:.LANCHOR156]
	cmp	w0, 19
	adrp	x0, .LANCHOR154
	beq	.L2574
	mov	w1, 7
.L2618:
	strb	w1, [x0, #:lo12:.LANCHOR154]
	b	.L2572
.L2563:
	add	x10, x10, 1
	add	x8, x8, 32
	cmp	x10, 30
	bne	.L2565
	b	.L2560
.L2574:
	mov	w1, 15
	b	.L2618
.L2573:
	sub	w1, w0, #65
	cmp	w0, 33
	and	w1, w1, 255
	ccmp	w1, 1, 0, ne
	bhi	.L2576
	adrp	x0, toshiba_read_retrial
	add	x0, x0, :lo12:toshiba_read_retrial
	str	x0, [x20, #:lo12:.LANCHOR156]
	adrp	x0, .LANCHOR25
	mov	w1, 4
	strb	w1, [x0, #:lo12:.LANCHOR25]
.L2620:
	mov	w1, 7
	adrp	x0, .LANCHOR154
	b	.L2618
.L2576:
	sub	w2, w0, #34
	sub	w1, w0, #67
	and	w2, w2, 255
	and	w1, w1, 255
	cmp	w2, 1
	ccmp	w1, 1, 0, hi
	bhi	.L2577
	adrp	x2, toshiba_read_retrial
	add	x2, x2, :lo12:toshiba_read_retrial
	str	x2, [x20, #:lo12:.LANCHOR156]
	cmp	w0, 35
	mov	w2, 68
	ccmp	w0, w2, 4, ne
	adrp	x0, .LANCHOR154
	beq	.L2578
	mov	w2, 7
.L2617:
	strb	w2, [x0, #:lo12:.LANCHOR154]
	cmp	w1, 1
	adrp	x0, .LANCHOR25
	bhi	.L2580
	mov	w1, 4
.L2619:
	strb	w1, [x0, #:lo12:.LANCHOR25]
.L2572:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2581
	adrp	x2, .LANCHOR194
	adrp	x0, .LC84
	add	x2, x2, :lo12:.LANCHOR194
	mov	w1, 2281
	add	x0, x0, :lo12:.LC84
	bl	printf
.L2581:
	adrp	x24, .LANCHOR20
	ldrb	w0, [x23, #:lo12:.LANCHOR42]
	strb	wzr, [x24, #:lo12:.LANCHOR20]
	tbz	x0, 0, .L2582
	mov	w0, 4
	bl	nandc_set_if_mode
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
.L2621:
	bl	nandc_set_if_mode
	bl	flash_info_blk_init
	mov	w19, w0
	cmn	w0, #1
	bne	.L2584
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2585
	adrp	x2, .LANCHOR194
	adrp	x0, .LC84
	add	x2, x2, :lo12:.LANCHOR194
	mov	w1, 2301
	add	x0, x0, :lo12:.LC84
	bl	printf
.L2585:
	ldr	x0, [x22, #:lo12:.LANCHOR26]
	mov	w1, 17
	strb	w1, [x0, 32]
	b	.L2555
.L2578:
	mov	w2, 17
	b	.L2617
.L2580:
	mov	w1, 5
	b	.L2619
.L2577:
	sub	w0, w0, #36
	and	w0, w0, 255
	cmp	w0, 1
	bhi	.L2572
	adrp	x0, toshiba_3d_read_retrial
	add	x0, x0, :lo12:toshiba_3d_read_retrial
	str	x0, [x20, #:lo12:.LANCHOR156]
	b	.L2620
.L2582:
	mov	w0, 4
	b	.L2621
.L2584:
	ldrb	w0, [x25, #:lo12:.LANCHOR23]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 6
	bhi	.L2586
	adrp	x0, hynix_read_retrial
	add	x0, x0, :lo12:hynix_read_retrial
	str	x0, [x20, #:lo12:.LANCHOR156]
.L2586:
	ldrb	w0, [x23, #:lo12:.LANCHOR42]
	tbz	x0, 2, .L2588
	ldr	x0, [x22, #:lo12:.LANCHOR26]
	ldrb	w0, [x0, 19]
	cbz	w0, .L2588
	adrp	x0, .LANCHOR159
	ldrb	w1, [x0, #:lo12:.LANCHOR159]
	adrp	x0, .LANCHOR2
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_ddr_para_scan
	ldrb	w0, [x24, #:lo12:.LANCHOR20]
	cbnz	w0, .L2588
	ldr	x0, [x22, #:lo12:.LANCHOR26]
	strb	wzr, [x0, 19]
	bl	flash_info_flush
.L2588:
	ldr	w0, [x21, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2590
	adrp	x2, .LANCHOR194
	adrp	x0, .LC84
	add	x2, x2, :lo12:.LANCHOR194
	mov	w1, 2356
	add	x0, x0, :lo12:.LC84
	bl	printf
.L2590:
	bl	nand_flash_print_info
	mov	w19, 0
	b	.L2555
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
	adrp	x26, .LANCHOR80
	stp	x21, x22, [sp, 80]
	bl	buf_alloc
	ldr	x24, [x0, 8]
	adrp	x27, .LANCHOR105
	adrp	x28, .LANCHOR121
	mov	x25, x0
	add	x26, x26, :lo12:.LANCHOR80
	add	x27, x27, :lo12:.LANCHOR105
	add	x28, x28, :lo12:.LANCHOR121
	mov	w19, 0
.L2623:
	ldrh	w0, [x26]
	cmp	w0, w19
	bhi	.L2625
	mov	x0, x25
	bl	buf_free
	cbz	w20, .L2626
	adrp	x1, .LANCHOR197
	adrp	x0, .LC0
	mov	w2, 1339
	add	x1, x1, :lo12:.LANCHOR197
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2626:
	mov	w0, w20
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 144
	ret
.L2625:
	ldrh	w21, [x27]
	ldrb	w3, [x28]
	ldr	x1, [x25, 8]
	ldr	x2, [x25, 24]
	madd	w21, w21, w23, w19
	mov	w0, w21
	bl	ftl_read_ppa_page
	mov	w22, w0
	ldr	x1, [x25, 24]
	mov	w4, w0
	ldr	x0, [x25, 8]
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
	adrp	x0, .LC149
	add	x0, x0, :lo12:.LC149
	bl	printf
	mov	w3, 32
	mov	w2, 4
	add	x1, x24, 704
	adrp	x0, .LC150
	add	x0, x0, :lo12:.LC150
	bl	rknand_print_hex
	cmp	w22, 512
	ccmn	w22, #1, 4, ne
	csinc	w20, w20, wzr, ne
	b	.L2623
	.size	ftl_sysblk_dump, .-ftl_sysblk_dump
	.section	.text.dump_ftl_info,"ax",@progbits
	.align	2
	.global	dump_ftl_info
	.type	dump_ftl_info, %function
dump_ftl_info:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR51
	add	x29, sp, 0
	ldrb	w1, [x0, #:lo12:.LANCHOR51]
	adrp	x0, .LC151
	stp	x19, x20, [sp, 16]
	add	x0, x0, :lo12:.LC151
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR97
	adrp	x19, .LANCHOR10
	adrp	x20, .LANCHOR80
	bl	printf
	adrp	x21, .LANCHOR6
	adrp	x0, .LANCHOR179
	add	x1, x0, :lo12:.LANCHOR179
	ldrh	w3, [x1, 2]
	ldrb	w2, [x1, 1]
	ldrb	w1, [x0, #:lo12:.LANCHOR179]
	adrp	x0, .LC152
	add	x0, x0, :lo12:.LC152
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	ldrh	w2, [x0, 140]
	ldrh	w1, [x0, 130]
	adrp	x0, .LC153
	add	x0, x0, :lo12:.LC153
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	adrp	x0, .LC154
	add	x0, x0, :lo12:.LC154
	ldrh	w5, [x1, 26]
	ldrh	w4, [x1, 22]
	ldrb	w3, [x1, 21]
	ldrh	w2, [x1, 18]
	ldrh	w1, [x1, 16]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	adrp	x0, .LC155
	add	x0, x0, :lo12:.LC155
	ldrh	w5, [x1, 58]
	ldrh	w4, [x1, 54]
	ldrb	w3, [x1, 53]
	ldrh	w2, [x1, 50]
	ldrh	w1, [x1, 48]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR10]
	adrp	x19, .LANCHOR73
	adrp	x0, .LC156
	add	x0, x0, :lo12:.LC156
	ldrh	w5, [x1, 90]
	ldrh	w4, [x1, 86]
	ldrb	w3, [x1, 85]
	ldrh	w2, [x1, 82]
	ldrh	w1, [x1, 80]
	bl	printf
	ldrb	w0, [x19, #:lo12:.LANCHOR73]
	mov	w2, 4
	ldrh	w3, [x20, #:lo12:.LANCHOR80]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR111
	ldr	x1, [x0, #:lo12:.LANCHOR111]
	adrp	x0, .LC157
	lsl	w3, w3, 1
	add	x0, x0, :lo12:.LC157
	bl	rknand_print_hex
	adrp	x0, .LANCHOR9
	ldrh	w3, [x21, #:lo12:.LANCHOR6]
	mov	w2, 2
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	adrp	x0, .LC158
	add	x0, x0, :lo12:.LC158
	bl	rknand_print_hex
	ldr	x1, [x22, #:lo12:.LANCHOR97]
	mov	w2, 4
	adrp	x0, .LC150
	add	x0, x0, :lo12:.LC150
	add	x1, x1, 704
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	adrp	x0, .LANCHOR7
	ldrh	w3, [x21, #:lo12:.LANCHOR6]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR7]
	adrp	x0, .LC159
	add	x0, x0, :lo12:.LC159
	bl	rknand_print_hex
	mov	w3, 256
	mov	w2, 2
	adrp	x1, .LANCHOR110
	adrp	x0, .LC160
	add	x1, x1, :lo12:.LANCHOR110
	add	x0, x0, :lo12:.LC160
	bl	rknand_print_hex
	ldrb	w0, [x19, #:lo12:.LANCHOR73]
	mov	w2, 2
	ldrh	w3, [x20, #:lo12:.LANCHOR80]
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR112
	ldp	x29, x30, [sp], 48
	lsl	w3, w3, 1
	ldr	x1, [x0, #:lo12:.LANCHOR112]
	adrp	x0, .LC161
	add	x0, x0, :lo12:.LC161
	b	rknand_print_hex
	.size	dump_ftl_info, .-dump_ftl_info
	.section	.text.pm_ppa_update_check,"ax",@progbits
	.align	2
	.global	pm_ppa_update_check
	.type	pm_ppa_update_check, %function
pm_ppa_update_check:
	adrp	x3, .LANCHOR99
	mov	w4, 21
	ldrh	w3, [x3, #:lo12:.LANCHOR99]
	sub	w5, w4, w3
	mov	w4, 1
	lsr	w3, w2, w3
	lsl	w4, w4, w5
	sub	w4, w4, #1
	and	w4, w4, w3
	adrp	x3, .LANCHOR98
	ldrb	w3, [x3, #:lo12:.LANCHOR98]
	udiv	w4, w4, w3
	adrp	x3, .LANCHOR7
	ldr	x3, [x3, #:lo12:.LANCHOR7]
	add	x4, x3, x4, uxth 2
	ldrb	w3, [x4, 2]
	ubfx	x3, x3, 5, 3
	cmp	w3, 1
	ccmp	w3, 7, 4, ne
	bne	.L2637
	stp	x29, x30, [sp, -16]!
	mov	w3, w2
	mov	w2, w1
	mov	x1, x0
	add	x29, sp, 0
	adrp	x0, .LC162
	add	x0, x0, :lo12:.LC162
	bl	printf
	bl	dump_ftl_info
	mov	w0, -1
	ldp	x29, x30, [sp], 16
	ret
.L2637:
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
	bls	.L2643
	adrp	x1, .LANCHOR198
	adrp	x0, .LC0
	mov	w2, 31
	add	x1, x1, :lo12:.LANCHOR198
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2643:
	adrp	x22, .LANCHOR97
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	ldrh	w2, [x0, 698]
	cmp	w2, w19
	bcs	.L2644
	mov	w1, w19
	adrp	x0, .LC163
	add	x0, x0, :lo12:.LC163
	bl	printf
	adrp	x0, .LANCHOR199
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR199]
	mov	x0, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	ldrh	w0, [x0, 698]
	cmp	w0, w19
	bcs	.L2646
	mov	w2, 35
.L2651:
	adrp	x1, .LANCHOR198
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR198
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L2646
.L2644:
	add	x0, x0, x19, sxtw 2
	sbfiz	x20, x20, 4, 32
	ldr	w21, [x0, 704]
	adrp	x0, .LANCHOR130
	add	x0, x0, :lo12:.LANCHOR130
	add	x23, x0, x20
	strh	w19, [x0, x20]
	strh	wzr, [x23, 2]
	cbnz	w21, .L2647
	mov	w2, 0
	mov	w1, w19
	adrp	x0, .LC164
	add	x0, x0, :lo12:.LC164
	bl	printf
	adrp	x0, .LANCHOR199
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR199]
	ldr	x0, [x23, 8]
	bl	ftl_memset
.L2646:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L2647:
	adrp	x20, .LANCHOR191
	adrp	x24, .LANCHOR121
	ldr	x1, [x23, 8]
	mov	w0, w21
	ldr	x2, [x20, #:lo12:.LANCHOR191]
	ldrb	w3, [x24, #:lo12:.LANCHOR121]
	bl	ftl_read_ppa_page
	ldr	x1, [x20, #:lo12:.LANCHOR191]
	ldr	w2, [x1]
	cmp	w2, w19
	beq	.L2648
	mov	w4, w21
	mov	w3, w0
	mov	w1, w19
	adrp	x0, .LC165
	add	x0, x0, :lo12:.LC165
	bl	printf
	ldr	x1, [x22, #:lo12:.LANCHOR97]
	mov	w2, 4
	adrp	x0, .LC166
	add	x0, x0, :lo12:.LC166
	add	x1, x1, 704
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	ldr	x1, [x23, 8]
	mov	w2, 4
	ldrb	w3, [x24, #:lo12:.LANCHOR121]
	adrp	x0, .LC167
	add	x0, x0, :lo12:.LC167
	lsl	w3, w3, 7
	bl	rknand_print_hex
	ldr	x1, [x20, #:lo12:.LANCHOR191]
	adrp	x0, .LC168
	mov	w3, 16
	mov	w2, 4
	add	x0, x0, :lo12:.LC168
	bl	rknand_print_hex
.L2648:
	ldr	x0, [x20, #:lo12:.LANCHOR191]
	ldr	w0, [x0]
	cmp	w19, w0
	beq	.L2646
	mov	w2, 59
	b	.L2651
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.pm_gc,"ax",@progbits
	.align	2
	.global	pm_gc
	.type	pm_gc, %function
pm_gc:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR97
	adrp	x19, .LANCHOR141
	stp	x21, x22, [sp, 32]
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	stp	x23, x24, [sp, 48]
	ldrh	w1, [x0, 688]
	ldrh	w0, [x19, #:lo12:.LANCHOR141]
	str	x25, [sp, 64]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L2654
	bl	pm_free_sblk
	ldr	x2, [x20, #:lo12:.LANCHOR97]
	ldrh	w1, [x19, #:lo12:.LANCHOR141]
	sub	w1, w1, #1
	ldrh	w3, [x2, 688]
	cmp	w3, w1
	blt	.L2654
	add	x0, x2, x0, uxth 1
	ldrh	w21, [x0, 416]
	mov	w0, 65535
	cmp	w21, w0
	bne	.L2656
	adrp	x1, .LANCHOR200
	add	x1, x1, :lo12:.LANCHOR200
	mov	w2, 131
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	bl	pm_free_sblk
	ldr	x1, [x20, #:lo12:.LANCHOR97]
	add	x0, x1, x0, uxth 1
	ldrh	w21, [x0, 416]
.L2656:
	bl	pm_select_ram_region
	and	x24, x0, 65535
	adrp	x1, .LANCHOR130
	lsl	x0, x24, 4
	add	x2, x1, :lo12:.LANCHOR130
	mov	x22, x24
	add	x19, x2, x0
	mov	x23, x1
	ldrh	w0, [x2, x0]
	mov	w2, 65535
	cmp	w0, w2
	beq	.L2657
	ldr	x1, [x19, 8]
	cbz	x1, .L2657
	ldrsh	w2, [x19, 2]
	tbz	w2, #31, .L2657
	bl	pm_write_page
	ldrh	w0, [x19, 2]
	and	w0, w0, 32767
	strh	w0, [x19, 2]
.L2657:
	add	x1, x23, :lo12:.LANCHOR130
	adrp	x25, .LANCHOR99
	add	x24, x1, x24, lsl 4
	add	x25, x25, :lo12:.LANCHOR99
	mov	w19, 0
.L2658:
	ldr	x1, [x20, #:lo12:.LANCHOR97]
	ldrh	w0, [x1, 698]
	cmp	w0, w19
	bhi	.L2660
	bl	pm_free_sblk
.L2654:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2660:
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
	adrp	x1, .LANCHOR98
	ldrb	w1, [x1, #:lo12:.LANCHOR98]
	udiv	w0, w0, w1
	cmp	w21, w0, uxth
	bne	.L2659
	mov	w1, w22
	mov	w0, w19
	bl	load_l2p_region
	ldr	x1, [x24, 8]
	mov	w0, w19
	bl	pm_write_page
	mov	w0, -1
	strh	w0, [x24]
.L2659:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2658
	.size	pm_gc, .-pm_gc
	.section	.text.pm_flush_id,"ax",@progbits
	.align	2
	.global	pm_flush_id
	.type	pm_flush_id, %function
pm_flush_id:
	stp	x29, x30, [sp, -32]!
	ubfiz	x0, x0, 4, 16
	adrp	x2, .LANCHOR130
	add	x2, x2, :lo12:.LANCHOR130
	add	x29, sp, 0
	str	x19, [sp, 16]
	add	x19, x2, x0
	ldrh	w0, [x2, x0]
	ldr	x1, [x19, 8]
	bl	pm_write_page
	ldrh	w0, [x19, 2]
	and	w0, w0, 32767
	strh	w0, [x19, 2]
	adrp	x19, .LANCHOR128
	ldr	w0, [x19, #:lo12:.LANCHOR128]
	cbz	w0, .L2666
	bl	pm_gc
	str	wzr, [x19, #:lo12:.LANCHOR128]
.L2666:
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
	adrp	x19, .LANCHOR130
	add	x19, x19, :lo12:.LANCHOR130
	mov	w20, 0
	add	x19, x19, 2
.L2673:
	ldrsh	w0, [x19]
	tbz	w0, #31, .L2672
	mov	w0, w20
	bl	pm_flush_id
.L2672:
	add	w20, w20, 1
	add	x19, x19, 16
	and	w20, w20, 65535
	cmp	w20, 32
	bne	.L2673
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
	adrp	x0, .LANCHOR128
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	adrp	x20, .LANCHOR130
	str	wzr, [x0, #:lo12:.LANCHOR128]
	adrp	x0, .LANCHOR192
	stp	x25, x26, [sp, 64]
	add	x19, x20, :lo12:.LANCHOR130
	strb	w1, [x0, #:lo12:.LANCHOR192]
	mov	w0, 64
	stp	x27, x28, [sp, 80]
	bl	ftl_malloc
	adrp	x1, .LANCHOR191
	adrp	x22, .LANCHOR121
	add	x23, x19, 512
	mov	x21, x1
	add	x22, x22, :lo12:.LANCHOR121
	str	x0, [x1, #:lo12:.LANCHOR191]
	mov	w25, -1
.L2683:
	strh	w25, [x19]
	strh	wzr, [x19, 2]
	cbz	w24, .L2682
	ldrb	w0, [x22]
	lsl	w0, w0, 9
	bl	ftl_malloc
	str	x0, [x19, 8]
.L2682:
	add	x19, x19, 16
	cmp	x19, x23
	bne	.L2683
	add	x0, x20, :lo12:.LANCHOR130
	adrp	x19, .LANCHOR97
	ldr	x24, [x21, #:lo12:.LANCHOR191]
	mov	w4, 4
	ldr	x25, [x0, 8]
	mov	x3, x24
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	mov	x2, x25
	ldrh	w1, [x0, 692]
	ldrb	w0, [x0, 694]
	bl	flash_get_last_written_page
	sxth	w26, w0
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	mov	w23, w26
	ldrh	w2, [x0, 696]
	cmp	w2, w26
	bgt	.L2684
	ldrh	w1, [x0, 692]
	mov	w3, w26
	adrp	x0, .LC169
	add	x0, x0, :lo12:.LC169
	adrp	x27, .LANCHOR105
	adrp	x28, .LANCHOR121
	add	x27, x27, :lo12:.LANCHOR105
	add	x28, x28, :lo12:.LANCHOR121
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	ldrsh	w21, [x0, 696]
.L2685:
	cmp	w21, w26
	ble	.L2687
	adrp	x0, .LANCHOR182
	mov	w1, 1
	add	x20, x20, :lo12:.LANCHOR130
	add	w23, w23, 1
	strb	w1, [x0, #:lo12:.LANCHOR182]
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	strh	w23, [x0, 696]
	bl	pm_free_sblk
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
.L2684:
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
.L2687:
	ldr	x0, [x19, #:lo12:.LANCHOR97]
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
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	str	w4, [x29, 108]
	mov	w2, w22
	ldr	w1, [x0, 48]
	ldrh	w3, [x0, 694]
	add	w1, w1, 1
	str	w1, [x0, 48]
	adrp	x0, .LC170
	add	x0, x0, :lo12:.LC170
	ldr	w1, [x24]
	bl	printf
	ldr	w4, [x29, 108]
	cmp	w4, 512
	ccmn	w4, #1, 4, ne
	beq	.L2686
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	ldr	w0, [x24]
	ldrh	w2, [x1, 698]
	cmp	w0, w2
	bcs	.L2686
	add	x0, x1, x0, uxtw 2
	str	w22, [x0, 704]
.L2686:
	add	w21, w21, 1
	sxth	w21, w21
	b	.L2685
	.size	pm_init, .-pm_init
	.section	.text.pm_log2phys,"ax",@progbits
	.align	2
	.global	pm_log2phys
	.type	pm_log2phys, %function
pm_log2phys:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	x22, x1
	adrp	x1, .LANCHOR121
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	ldrb	w1, [x1, #:lo12:.LANCHOR121]
	stp	x23, x24, [sp, 48]
	mov	w23, w2
	lsl	w21, w1, 7
	ubfiz	w20, w1, 7, 9
	adrp	x1, .LANCHOR118
	udiv	w21, w0, w21
	ldr	w2, [x1, #:lo12:.LANCHOR118]
	cmp	w0, w2
	and	w25, w21, 65535
	msub	w20, w25, w20, w0
	bcc	.L2697
	mov	w1, w0
	adrp	x0, .LC171
	add	x0, x0, :lo12:.LC171
	bl	printf
	mov	w0, -1
.L2696:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2697:
	adrp	x24, .LANCHOR130
	add	x0, x24, :lo12:.LANCHOR130
	and	x20, x20, 65535
	add	x0, x0, 8
	mov	x19, 0
.L2703:
	ldr	x1, [x0]
	cbz	x1, .L2699
	ldrh	w1, [x0, -8]
	cmp	w1, w25
	bne	.L2699
.L2700:
	cbnz	w23, .L2701
	add	x0, x24, :lo12:.LANCHOR130
	add	x0, x0, x19, lsl 4
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x20, lsl 2]
	str	w0, [x22]
.L2702:
	add	x24, x24, :lo12:.LANCHOR130
	add	x19, x24, x19, lsl 4
	ldrh	w0, [x19, 2]
	mvn	x1, x0
	tst	x1, 32767
	beq	.L2705
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L2705:
	mov	w0, 0
	b	.L2696
.L2701:
	add	x0, x24, :lo12:.LANCHOR130
	ldr	w2, [x22]
	add	x0, x0, x19, lsl 4
	ldr	x1, [x0, 8]
	str	w2, [x1, x20, lsl 2]
	ldrh	w1, [x0, 2]
	orr	w1, w1, -32768
	strh	w1, [x0, 2]
	adrp	x0, .LANCHOR131
	strb	w21, [x0, #:lo12:.LANCHOR131]
	b	.L2702
.L2699:
	add	w19, w19, 1
	add	x0, x0, 16
	and	x19, x19, 65535
	cmp	w19, 32
	bne	.L2703
	bl	pm_select_ram_region
	and	x19, x0, 65535
	sbfiz	x1, x19, 4, 32
	add	x2, x24, :lo12:.LANCHOR130
	add	x3, x2, x1
	mov	w26, w0
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L2704
	ldrsh	w1, [x3, 2]
	tbz	w1, #31, .L2704
	bl	pm_flush_id
.L2704:
	adrp	x0, .LANCHOR201
	mov	w1, w26
	strb	w19, [x0, #:lo12:.LANCHOR201]
	mov	w0, w25
	bl	load_l2p_region
	b	.L2700
	.size	pm_log2phys, .-pm_log2phys
	.section	.text.gc_recovery,"ax",@progbits
	.align	2
	.global	gc_recovery
	.type	gc_recovery, %function
gc_recovery:
	sub	sp, sp, #240
	adrp	x0, .LANCHOR71
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	stp	x21, x22, [sp, 64]
	adrp	x21, .LANCHOR10
	stp	x19, x20, [sp, 48]
	ldr	x20, [x21, #:lo12:.LANCHOR10]
	strb	wzr, [x0, #:lo12:.LANCHOR71]
	adrp	x0, .LANCHOR145
	stp	x23, x24, [sp, 80]
	strb	wzr, [x0, #:lo12:.LANCHOR145]
	stp	x25, x26, [sp, 96]
	stp	x27, x28, [sp, 112]
	bl	gc_init
	add	x0, x20, 80
	ldrh	w1, [x20, 80]
	str	x0, [x29, 176]
	mov	w0, 65535
	cmp	w1, w0
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	beq	.L2712
	mov	w1, -1
	strh	w1, [x0, 130]
	mov	w0, 1
	bl	buf_alloc
	mov	x25, x0
	ldrb	w0, [x20, 89]
	add	x1, x20, 80
	adrp	x3, .LANCHOR105
	adrp	x2, .LANCHOR68
	sub	w0, w0, #1
	str	x3, [x29, 152]
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x3, #:lo12:.LANCHOR105]
	str	x2, [x29, 168]
	ldrh	w0, [x0, 16]
	mul	w1, w0, w1
	ldrb	w0, [x2, #:lo12:.LANCHOR68]
	str	w1, [x29, 200]
	cmp	w0, 3
	bne	.L2713
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	sub	w0, w0, #1
	add	w0, w0, w1
	orr	w0, w0, 50331648
.L2757:
	str	w0, [x25, 40]
.L2714:
	mov	w1, 1
	mov	x0, x25
	bl	sblk_read_page
	ldr	w0, [x25, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2715
	ldr	x0, [x25, 24]
	ldr	w1, [x0]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	cmp	w1, w0
	beq	.L2716
.L2715:
	mov	x0, x25
	bl	buf_free
	ldr	x1, [x25, 24]
	ldr	x0, [x25, 8]
	ldr	w2, [x1, 12]
	str	w2, [sp, 16]
	ldr	w2, [x1, 8]
	str	w2, [sp, 8]
	ldr	w2, [x1, 4]
	str	w2, [sp]
	ldp	w3, w4, [x0]
	ldp	w5, w6, [x0, 8]
	adrp	x0, .LC172
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC172
	ldr	w1, [x25, 40]
	ldr	w2, [x25, 52]
	bl	printf
.L2761:
	adrp	x0, .LANCHOR9
	ldrh	w1, [x20, 80]
	mov	w28, 0
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x1, lsl 1]
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	ldrh	w1, [x20, 80]
	strh	w1, [x0, 130]
.L2717:
	ldrh	w1, [x20, 80]
	mov	w2, w28
	adrp	x0, .LC174
	add	x0, x0, :lo12:.LC174
	bl	printf
	mov	w0, -1
	strh	w0, [x20, 80]
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	mov	w1, 65535
	ldrh	w0, [x0, 130]
	cmp	w0, w1
	beq	.L2744
	bl	ftl_free_sblk
.L2744:
	adrp	x0, .LANCHOR97
	ldr	x1, [x0, #:lo12:.LANCHOR97]
	mov	w0, -1
	strh	w0, [x1, 126]
	ldr	x1, [x21, #:lo12:.LANCHOR10]
	strh	w0, [x1, 130]
	mov	w0, 0
	bl	ftl_info_flush
.L2711:
	ldp	x19, x20, [sp, 48]
	ldp	x21, x22, [sp, 64]
	ldp	x23, x24, [sp, 80]
	ldp	x25, x26, [sp, 96]
	ldp	x27, x28, [sp, 112]
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 240
	ret
.L2713:
	cmp	w0, 2
	bne	.L2714
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	add	w0, w1, w0, lsl 1
	sub	w0, w0, #1
	orr	w0, w0, 33554432
	b	.L2757
.L2716:
	adrp	x19, .LANCHOR72
	adrp	x22, .LANCHOR73
	adrp	x23, .LANCHOR147
	ldr	x1, [x25, 8]
	ldrb	w0, [x22, #:lo12:.LANCHOR73]
	adrp	x24, .LANCHOR148
	ldrh	w2, [x19, #:lo12:.LANCHOR72]
	mul	w2, w2, w0
	ldr	x0, [x23, #:lo12:.LANCHOR147]
	lsl	w2, w2, 2
	bl	ftl_memcpy
	ldrb	w1, [x22, #:lo12:.LANCHOR73]
	ldrh	w0, [x19, #:lo12:.LANCHOR72]
	mul	w0, w0, w1
	ldr	x1, [x25, 8]
	lsl	w2, w0, 2
	add	x1, x1, x0, sxtw 2
	ldr	x0, [x24, #:lo12:.LANCHOR148]
	bl	ftl_memcpy
	str	x19, [x29, 144]
	adrp	x0, .LANCHOR80
	ldrh	w14, [x0, #:lo12:.LANCHOR80]
	ldr	x0, [x29, 168]
	ldrb	w0, [x0, #:lo12:.LANCHOR68]
	cmp	w0, 2
	beq	.L2718
.L2758:
	str	w0, [x29, 184]
	adrp	x26, .LC173
	ldr	x0, [x29, 152]
	mov	w22, 0
	mov	w28, 0
	add	x0, x0, :lo12:.LANCHOR105
	str	x0, [x29, 128]
	add	x0, x26, :lo12:.LC173
	str	x0, [x29, 120]
.L2720:
	sub	w0, w22, #1
	str	w0, [x29, 188]
	cmp	w22, w14
	beq	.L2729
	mov	x27, 0
	b	.L2730
.L2718:
	lsl	w14, w14, 1
	mov	w0, 1
	b	.L2758
.L2726:
	ldr	x1, [x29, 128]
	ldr	x0, [x29, 160]
	ldrh	w1, [x1]
	ldrh	w0, [x0, 96]
	mul	w0, w0, w1
	ldr	x1, [x29, 136]
	str	w0, [x29, 200]
	ldrb	w1, [x1]
	cmp	w1, 3
	bne	.L2721
	add	w0, w22, w0
	orr	w0, w0, w26, lsl 24
.L2759:
	str	w0, [x25, 40]
	mov	w1, 1
	str	w14, [x29, 112]
	mov	x0, x25
	bl	sblk_read_page
	ldr	x0, [x23, #:lo12:.LANCHOR147]
	ldr	w14, [x29, 112]
	ldr	w3, [x0, x19]
	ldr	x0, [x25, 24]
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bne	.L2724
	ldr	x1, [x24, #:lo12:.LANCHOR148]
	ldr	w2, [x1, x19]
	ldr	w1, [x0, 8]
	cmp	w2, w1
	beq	.L2725
.L2724:
	ldr	x1, [x24, #:lo12:.LANCHOR148]
	ldr	w2, [x0, 12]
	str	w2, [sp]
	str	w14, [x29, 112]
	ldr	w4, [x1, x19]
	ldr	w5, [x0]
	ldr	w7, [x0, 8]
	ldr	w1, [x25, 40]
	ldr	w2, [x25, 52]
	ldr	x0, [x29, 120]
	bl	printf
	ldr	x0, [x23, #:lo12:.LANCHOR147]
	ldr	w14, [x29, 112]
	ldr	w0, [x0, x19]
	cmn	w0, #1
	beq	.L2725
	mov	x0, x25
	bl	buf_free
	b	.L2761
.L2721:
	cmp	w1, 2
	bne	.L2723
	ldr	w1, [x29, 188]
	add	w0, w0, w1
	add	w0, w0, w26
	orr	w0, w0, 33554432
	b	.L2759
.L2723:
	add	w0, w22, w0
	b	.L2759
.L2725:
	add	w28, w28, 1
	add	w26, w26, 1
	add	x19, x19, 4
.L2728:
	ldr	w0, [x29, 184]
	cmp	w0, w26
	bcs	.L2726
	add	x27, x27, 1
.L2730:
	ldr	x0, [x29, 176]
	ldrb	w0, [x0, 9]
	cmp	w0, w27
	ble	.L2727
	add	x0, x20, x27, lsl 1
	str	x0, [x29, 160]
	ldr	x0, [x29, 168]
	sbfiz	x19, x28, 2, 32
	mov	w26, 1
	add	x0, x0, :lo12:.LANCHOR68
	str	x0, [x29, 136]
	b	.L2728
.L2727:
	add	w22, w22, 1
	b	.L2720
.L2729:
	mov	x0, x25
	bl	buf_free
	ldr	x3, [x29, 144]
	adrp	x25, .LANCHOR9
	ldr	x0, [x29, 176]
	mov	w28, 0
	ldrh	w2, [x20, 80]
	mov	w27, 0
	ldr	x1, [x25, #:lo12:.LANCHOR9]
	ldrh	w3, [x3, #:lo12:.LANCHOR72]
	ldrb	w0, [x0, 9]
	str	x25, [x29, 144]
	str	wzr, [x29, 188]
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	adrp	x0, .LANCHOR99
	add	x0, x0, :lo12:.LANCHOR99
	str	x0, [x29, 112]
.L2731:
	sub	w0, w27, #1
	str	w0, [x29, 136]
	cmp	w22, w27
	beq	.L2742
	mov	x26, 0
	b	.L2743
.L2739:
	ldr	w0, [x29, 188]
	ldr	x1, [x23, #:lo12:.LANCHOR147]
	sbfiz	x0, x0, 2, 32
	ldr	w6, [x1, x0]
	cmn	w6, #1
	beq	.L2732
	ldr	x1, [x24, #:lo12:.LANCHOR148]
	str	w6, [x29, 108]
	ldr	w0, [x1, x0]
	str	w0, [x29, 160]
	mov	w0, w6
	bl	lpa_hash_get_ppa
	str	w0, [x29, 204]
	cmn	w0, #1
	ldr	w6, [x29, 108]
	bne	.L2733
	mov	w0, w6
	str	w6, [x29, 108]
	mov	w2, 0
	add	x1, x29, 204
	bl	pm_log2phys
	ldr	w6, [x29, 108]
.L2733:
	ldr	x0, [x29, 128]
	ldr	x1, [x29, 152]
	ldrh	w0, [x0, 96]
	ldrh	w1, [x1, #:lo12:.LANCHOR105]
	mul	w0, w0, w1
	ldr	x1, [x29, 168]
	ldrb	w1, [x1, #:lo12:.LANCHOR68]
	cmp	w1, 3
	bne	.L2734
	add	w0, w27, w0
	orr	w0, w0, w25, lsl 24
.L2760:
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
	bne	.L2737
	add	x1, x29, 200
	mov	w0, w6
	bl	pm_log2phys
	add	w28, w28, 1
	mov	w0, w19
	bl	ftl_vpn_decrement
.L2738:
	ldr	w0, [x29, 188]
	add	w0, w0, 1
	str	w0, [x29, 188]
	adrp	x0, .LANCHOR7
	ldr	x0, [x0, #:lo12:.LANCHOR7]
	add	x0, x0, x19, lsl 2
	ldrb	w0, [x0, 2]
	tst	w0, 224
	bne	.L2732
	ldr	x0, [x29, 144]
	lsl	x19, x19, 1
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, x19]
	cbz	w1, .L2732
	strh	wzr, [x0, x19]
.L2732:
	add	w25, w25, 1
.L2741:
	ldr	w0, [x29, 184]
	cmp	w0, w25
	bcs	.L2739
	add	x26, x26, 1
.L2743:
	ldr	x0, [x29, 176]
	ldrb	w0, [x0, 9]
	cmp	w0, w26
	ble	.L2740
	add	x0, x20, x26, lsl 1
	mov	w25, 1
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR98
	add	x0, x0, :lo12:.LANCHOR98
	str	x0, [x29, 120]
	b	.L2741
.L2734:
	cmp	w1, 2
	bne	.L2736
	ldr	w1, [x29, 136]
	add	w0, w0, w1
	add	w0, w0, w25
	orr	w0, w0, 33554432
	b	.L2760
.L2736:
	add	w0, w27, w0
	b	.L2760
.L2737:
	ldr	w1, [x29, 200]
	cmp	w0, w1
	cinc	w28, w28, eq
	b	.L2738
.L2740:
	add	w27, w27, 1
	b	.L2731
.L2742:
	ldr	x0, [x29, 144]
	ldrh	w1, [x20, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	strh	w28, [x0, x1, lsl 1]
	b	.L2717
.L2712:
	ldrh	w0, [x0, 130]
	cmp	w0, w1
	beq	.L2711
	adrp	x19, .LANCHOR97
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	ldrh	w1, [x1, 126]
	cmp	w1, w0
	bne	.L2746
	bl	pm_flush
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	ldrh	w0, [x0, 130]
	bl	ftl_free_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	mov	w1, -1
	strh	w1, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
.L2746:
	ldr	x0, [x21, #:lo12:.LANCHOR10]
	mov	w1, -1
	strh	w1, [x0, 130]
	b	.L2711
	.size	gc_recovery, .-gc_recovery
	.section	.text.zftl_init,"ax",@progbits
	.align	2
	.global	zftl_init
	.type	zftl_init, %function
zftl_init:
	stp	x29, x30, [sp, -112]!
	adrp	x1, .LANCHOR56
	mov	w0, -1
	add	x29, sp, 0
	strb	w0, [x1, #:lo12:.LANCHOR56]
	adrp	x1, .LANCHOR57
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR80
	strb	wzr, [x1, #:lo12:.LANCHOR57]
	adrp	x1, .LANCHOR124
	stp	x19, x20, [sp, 16]
	adrp	x21, .LANCHOR73
	strb	w0, [x1, #:lo12:.LANCHOR124]
	adrp	x1, .LANCHOR125
	stp	x23, x24, [sp, 48]
	adrp	x20, .LANCHOR199
	strb	wzr, [x1, #:lo12:.LANCHOR125]
	adrp	x1, .LANCHOR174
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR6
	strb	w0, [x1, #:lo12:.LANCHOR174]
	adrp	x0, .LANCHOR119
	mov	w1, -1
	stp	x27, x28, [sp, 80]
	strb	wzr, [x0, #:lo12:.LANCHOR119]
	adrp	x0, .LANCHOR202
	str	w1, [x0, #:lo12:.LANCHOR202]
	adrp	x1, .LC175
	adrp	x0, .LC91
	add	x1, x1, :lo12:.LC175
	add	x0, x0, :lo12:.LC91
	bl	printf
	adrp	x1, .LANCHOR34
	add	x1, x1, :lo12:.LANCHOR34
	adrp	x0, .LANCHOR68
	adrp	x2, .LANCHOR121
	adrp	x3, .LANCHOR72
	adrp	x4, .LANCHOR98
	ldrb	w5, [x1, 12]
	strb	w5, [x0, #:lo12:.LANCHOR68]
	ldrb	w0, [x1, 9]
	strb	w0, [x2, #:lo12:.LANCHOR121]
	ldrh	w2, [x1, 10]
	strh	w2, [x3, #:lo12:.LANCHOR72]
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
	strb	w3, [x4, #:lo12:.LANCHOR98]
	ldrh	w4, [x1, #:lo12:.LANCHOR2]
	adrp	x1, .LANCHOR105
	strh	w8, [x22, #:lo12:.LANCHOR80]
	mul	w6, w6, w3
	strh	w4, [x1, #:lo12:.LANCHOR105]
	strh	w10, [x20, #:lo12:.LANCHOR199]
	mov	w3, 1
	and	w6, w6, 255
	mov	w1, 0
	strb	w6, [x21, #:lo12:.LANCHOR73]
.L2763:
	cmp	w4, w3
	bcs	.L2764
	mul	w2, w0, w2
	adrp	x3, .LANCHOR99
	sub	w1, w1, #1
	mov	w4, 0
	strh	w1, [x3, #:lo12:.LANCHOR99]
	mov	w1, 1
	mul	w3, w2, w7
	lsr	w11, w3, 21
.L2765:
	cmp	w11, w1
	bcs	.L2766
	mov	w1, 57344
	sub	w4, w4, #1
	movk	w1, 0x1c, lsl 16
	mul	w3, w3, w6
	adrp	x28, .LANCHOR118
	sub	w11, w10, #1
	mul	w1, w6, w1
	adrp	x24, .LANCHOR187
	mul	w8, w8, w6
	adrp	x27, .LANCHOR204
	mul	w2, w2, w6
	adrp	x26, .LANCHOR141
	lsl	w1, w1, w4
	adrp	x4, .LANCHOR58
	sub	w2, w2, #1
	adrp	x25, .LANCHOR84
	str	w1, [x4, #:lo12:.LANCHOR58]
	adrp	x4, .LANCHOR203
	str	w3, [x4, #:lo12:.LANCHOR203]
	add	w3, w1, 24576
	str	w3, [x27, #:lo12:.LANCHOR204]
	udiv	w0, w3, w0
	udiv	w3, w3, w2
	adrp	x2, .LANCHOR101
	str	w0, [x28, #:lo12:.LANCHOR118]
	add	w0, w11, w0, lsl 2
	add	w3, w3, 8
	udiv	w0, w0, w10
	strh	w0, [x24, #:lo12:.LANCHOR187]
	ubfiz	w0, w0, 4, 16
	sdiv	w0, w0, w8
	adrp	x8, .LANCHOR88
	str	x8, [x29, 104]
	strh	w3, [x8, #:lo12:.LANCHOR88]
	strh	w0, [x26, #:lo12:.LANCHOR141]
	add	w0, w7, w7, lsl 1
	asr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR101]
	lsr	w0, w7, 4
	strh	w0, [x25, #:lo12:.LANCHOR84]
	cmp	w0, 79
	bhi	.L2767
	mov	w0, 80
	strh	w0, [x25, #:lo12:.LANCHOR84]
.L2767:
	adrp	x7, .LANCHOR102
	mov	w0, 2000
	adrp	x3, .LANCHOR100
	adrp	x6, .LANCHOR140
	strh	w0, [x7, #:lo12:.LANCHOR102]
	mov	w0, 50
	adrp	x2, .LANCHOR139
	strh	w0, [x3, #:lo12:.LANCHOR100]
	mov	w0, 256
	strh	w0, [x6, #:lo12:.LANCHOR140]
	mov	w0, 48
	strh	w0, [x2, #:lo12:.LANCHOR139]
	adrp	x0, .LANCHOR8
	mov	w8, 32
	cmp	w5, 2
	strh	w8, [x0, #:lo12:.LANCHOR8]
	beq	.L2768
	adrp	x5, .LANCHOR70
	ldrb	w5, [x5, #:lo12:.LANCHOR70]
	cbz	w5, .L2769
.L2768:
	mov	w5, 150
	strh	w5, [x3, #:lo12:.LANCHOR100]
	mov	w3, 64
	strh	w3, [x2, #:lo12:.LANCHOR139]
	mov	w2, 12
	strh	w2, [x0, #:lo12:.LANCHOR8]
	adrp	x2, .LANCHOR0
	ldrb	w2, [x2, #:lo12:.LANCHOR0]
	cbnz	w2, .L2769
	mov	w2, 4
	strh	w2, [x0, #:lo12:.LANCHOR8]
	mov	w0, 600
	strh	w0, [x7, #:lo12:.LANCHOR102]
	mov	w0, 128
	strh	w0, [x6, #:lo12:.LANCHOR140]
.L2769:
	adrp	x19, .LANCHOR14
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2771
	str	x4, [x29, 96]
	adrp	x0, .LC176
	add	x0, x0, :lo12:.LC176
	bl	printf
	ldr	x4, [x29, 96]
.L2771:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2772
	ldr	w1, [x4, #:lo12:.LANCHOR203]
	adrp	x0, .LC177
	add	x0, x0, :lo12:.LC177
	bl	printf
.L2772:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2773
	ldr	w1, [x28, #:lo12:.LANCHOR118]
	adrp	x0, .LC178
	add	x0, x0, :lo12:.LC178
	bl	printf
.L2773:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2774
	ldr	w1, [x27, #:lo12:.LANCHOR204]
	adrp	x0, .LC179
	add	x0, x0, :lo12:.LC179
	bl	printf
.L2774:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2775
	ldrh	w1, [x24, #:lo12:.LANCHOR187]
	adrp	x0, .LC180
	add	x0, x0, :lo12:.LC180
	bl	printf
.L2775:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2776
	ldrh	w1, [x20, #:lo12:.LANCHOR199]
	adrp	x0, .LC181
	add	x0, x0, :lo12:.LC181
	bl	printf
.L2776:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2777
	ldrh	w1, [x26, #:lo12:.LANCHOR141]
	adrp	x0, .LC182
	add	x0, x0, :lo12:.LC182
	bl	printf
.L2777:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2778
	ldrh	w1, [x25, #:lo12:.LANCHOR84]
	adrp	x0, .LC183
	add	x0, x0, :lo12:.LC183
	bl	printf
.L2778:
	ldr	w0, [x19, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2779
	ldr	x0, [x29, 104]
	ldrh	w1, [x0, #:lo12:.LANCHOR88]
	adrp	x0, .LC184
	add	x0, x0, :lo12:.LC184
	bl	printf
.L2779:
	bl	buf_init
	adrp	x25, .LANCHOR10
	ldrh	w1, [x23, #:lo12:.LANCHOR6]
	mov	w0, 6
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR4
	str	x0, [x1, #:lo12:.LANCHOR4]
	ldrb	w1, [x21, #:lo12:.LANCHOR73]
	ldrh	w0, [x22, #:lo12:.LANCHOR80]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR112
	adrp	x2, ftl_ext_info_data_buffer
	add	x2, x2, :lo12:ftl_ext_info_data_buffer
	str	x0, [x1, #:lo12:.LANCHOR112]
	adrp	x0, .LANCHOR111
	ldrh	w1, [x22, #:lo12:.LANCHOR80]
	str	x2, [x0, #:lo12:.LANCHOR111]
	ldrb	w0, [x21, #:lo12:.LANCHOR73]
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
	tbz	x0, 12, .L2780
	adrp	x0, .LC185
	add	x0, x0, :lo12:.LC185
	bl	printf
.L2780:
	ldrh	w0, [x22, #:lo12:.LANCHOR80]
	ldrb	w21, [x21, #:lo12:.LANCHOR73]
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
	tbz	x0, 12, .L2781
	ldrh	w3, [x20, #:lo12:.LANCHOR199]
	adrp	x0, .LC186
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC186
	bl	printf
.L2781:
	ldrh	w0, [x20, #:lo12:.LANCHOR199]
	cmp	w21, w0
	bhi	.L2782
	cmp	w22, w0
	bls	.L2783
.L2782:
.L2826:
	b	.L2826
.L2764:
	add	w1, w1, 1
	lsl	w3, w3, 1
	and	w1, w1, 65535
	b	.L2763
.L2766:
	add	w4, w4, 1
	lsl	w1, w1, 1
	and	w4, w4, 65535
	b	.L2765
.L2783:
	bl	sblk_init
	bl	ftl_info_blk_init
	cmn	w0, #1
	beq	.L2762
	bl	ftl_ext_info_init
	adrp	x19, .LANCHOR97
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
	ldr	x1, [x19, #:lo12:.LANCHOR97]
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
	cbz	w0, .L2785
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	ldr	w0, [x1, 68]
	add	w0, w0, 1
	str	w0, [x1, 68]
.L2785:
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	print_ftl_debug_info
	mov	w0, 0
.L2762:
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
	cbnz	w0, .L2830
	bl	zftl_init
.L2830:
	mov	w19, w0
	bl	idb_init
	mov	w1, w19
	adrp	x0, .LC187
	add	x0, x0, :lo12:.LC187
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
	adrp	x1, .LANCHOR72
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	ldr	x21, [x0, #:lo12:.LANCHOR10]
	stp	x25, x26, [sp, 64]
	ldrh	w26, [x1, #:lo12:.LANCHOR72]
	add	x1, x21, 80
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR14
	stp	x19, x20, [sp, 16]
	stp	x27, x28, [sp, 80]
	stp	x0, x1, [x29, 128]
	ldrb	w1, [x1, 9]
	mul	w26, w26, w1
	ldr	w1, [x24, #:lo12:.LANCHOR14]
	tbz	x1, 8, .L2833
	ldrh	w1, [x21, 80]
	adrp	x0, .LC188
	add	x0, x0, :lo12:.LC188
	bl	printf
.L2833:
	adrp	x23, .LANCHOR9
	ldrh	w1, [x21, 80]
	sub	w2, w26, #1
	mov	x22, 0
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	mov	w25, 0
	strh	w2, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR121
	add	x0, x0, :lo12:.LANCHOR121
	str	x0, [x29, 104]
.L2834:
	mov	w28, w22
	cmp	w26, w22
	bhi	.L2844
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L2845
	ldr	x0, [x29, 128]
	mov	w3, w25
	ldr	x1, [x23, #:lo12:.LANCHOR9]
	ldrh	w2, [x21, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldrh	w2, [x1, x2, lsl 1]
	ldrh	w1, [x0, 80]
	adrp	x0, .LC191
	add	x0, x0, :lo12:.LC191
	bl	printf
.L2845:
	ldrh	w1, [x21, 80]
	ldr	x0, [x23, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, x1, lsl 1]
	cmp	w25, w0
	beq	.L2846
	adrp	x1, .LANCHOR205
	adrp	x0, .LC0
	mov	w2, 483
	add	x1, x1, :lo12:.LANCHOR205
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2846:
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
.L2844:
	adrp	x27, .LANCHOR147
	lsl	x19, x22, 2
	ldr	x0, [x27, #:lo12:.LANCHOR147]
	ldr	w2, [x0, x19]
	cmn	w2, #1
	beq	.L2835
	adrp	x0, .LANCHOR121
	ldrb	w20, [x0, #:lo12:.LANCHOR121]
	lsl	w20, w20, 7
	udiv	w20, w2, w20
	and	w0, w20, 65535
	str	w0, [x29, 156]
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L2836
	ldr	w1, [x29, 156]
	adrp	x0, .LC189
	mov	w3, w22
	add	x0, x0, :lo12:.LC189
	bl	printf
.L2836:
	sub	w28, w26, w28
	add	x28, x28, x22
	lsl	x0, x28, 2
	str	x0, [x29, 144]
	adrp	x0, .LC190
	add	x0, x0, :lo12:.LC190
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR99
	add	x0, x0, :lo12:.LANCHOR99
	str	x0, [x29, 112]
.L2837:
	ldr	x0, [x29, 144]
	cmp	x0, x19
	bne	.L2843
.L2835:
	add	x22, x22, 1
	b	.L2834
.L2843:
	ldr	x0, [x27, #:lo12:.LANCHOR147]
	ldr	w20, [x0, x19]
	cmn	w20, #1
	beq	.L2838
	ldr	x0, [x29, 104]
	ldr	w1, [x29, 156]
	ldrb	w0, [x0]
	lsl	w0, w0, 7
	udiv	w0, w20, w0
	cmp	w1, w0, uxth
	bne	.L2838
	adrp	x0, .LANCHOR148
	ldr	x0, [x0, #:lo12:.LANCHOR148]
	ldr	w28, [x0, x19]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 172]
	cmn	w0, #1
	bne	.L2839
	mov	w2, 0
	add	x1, x29, 172
	mov	w0, w20
	bl	pm_log2phys
.L2839:
	ldr	w3, [x29, 172]
	cmp	w28, w3
	bne	.L2840
	adrp	x0, .LANCHOR149
	mov	w2, 1
	add	x1, x29, 168
	add	w25, w25, 1
	ldr	x0, [x0, #:lo12:.LANCHOR149]
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
	adrp	x0, .LANCHOR98
	ldrb	w0, [x0, #:lo12:.LANCHOR98]
	udiv	w0, w28, w0
.L2866:
	bl	ftl_vpn_decrement
	ldr	x0, [x27, #:lo12:.LANCHOR147]
	mov	w1, -1
	str	w1, [x0, x19]
.L2838:
	add	x19, x19, 4
	b	.L2837
.L2840:
	ldr	w0, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L2842
	ldr	x0, [x29, 120]
	mov	w2, w28
	mov	w1, w20
	bl	printf
.L2842:
	ldr	x0, [x29, 136]
	ldrh	w0, [x0]
	b	.L2866
	.size	gc_update_l2p_map_new, .-gc_update_l2p_map_new
	.section	.text.gc_scan_src_blk_one_page,"ax",@progbits
	.align	2
	.global	gc_scan_src_blk_one_page
	.type	gc_scan_src_blk_one_page, %function
gc_scan_src_blk_one_page:
	stp	x29, x30, [sp, -96]!
	mov	w5, 0
	mov	w6, 0
	mov	w7, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR62
	add	x1, x19, :lo12:.LANCHOR62
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	str	x25, [sp, 64]
	ldrb	w0, [x1, 4]
	add	x2, x1, x0, sxtw 1
	ldrh	w3, [x2, 40]
	adrp	x2, .LANCHOR73
	ldrb	w4, [x2, #:lo12:.LANCHOR73]
	ldrh	w2, [x1, 2]
.L2868:
	cmp	w3, w7
	beq	.L2870
	cbz	w6, .L2871
	add	x1, x19, :lo12:.LANCHOR62
	strb	w0, [x1, 4]
.L2871:
	cbz	w5, .L2872
	add	x0, x19, :lo12:.LANCHOR62
	strh	w2, [x0, 2]
.L2872:
	adrp	x0, .LANCHOR105
	ldrh	w22, [x0, #:lo12:.LANCHOR105]
	adrp	x0, .LANCHOR68
	mov	x23, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR68]
	mul	w22, w22, w3
	cmp	w1, 2
	bne	.L2873
	add	x0, x19, :lo12:.LANCHOR62
	ldrb	w1, [x0, 6]
	cbnz	w1, .L2873
	ldrh	w0, [x0, 2]
	add	w22, w22, w0, lsl 1
.L2874:
	add	x1, x19, :lo12:.LANCHOR62
	ldrb	w0, [x1, 4]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x1, 4]
	cmp	w4, w0
	bne	.L2875
	ldrh	w0, [x1, 2]
	strb	wzr, [x1, 4]
	add	w0, w0, 1
	strh	w0, [x1, 2]
.L2875:
	mov	w0, 1
	add	x19, x19, :lo12:.LANCHOR62
	bl	buf_alloc
	add	x23, x23, :lo12:.LANCHOR68
	mov	x21, x0
	mov	w20, 0
	adrp	x24, .LANCHOR65
.L2885:
	ldrb	w0, [x19, 6]
	cmp	w0, 3
	bne	.L2876
	cbz	w20, .L2877
.L2876:
	cmp	w0, w20
	bgt	.L2878
.L2886:
	mov	x0, x21
	bl	buf_free
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2870:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, w4
	bne	.L2869
	add	w2, w2, 1
	mov	w5, 1
	and	w2, w2, 65535
	mov	w0, 0
.L2869:
	add	x3, x1, x0, sxtw 1
	mov	w6, 1
	ldrh	w3, [x3, 40]
	b	.L2868
.L2873:
	add	x0, x19, :lo12:.LANCHOR62
	ldrh	w0, [x0, 2]
	add	w22, w0, w22
	b	.L2874
.L2878:
	ldrb	w1, [x23]
	cmp	w1, 2
	bne	.L2879
	cbnz	w0, .L2879
	add	w0, w20, w22
	orr	w0, w0, 33554432
.L2899:
	str	w0, [x21, 40]
	mov	w1, 1
	mov	x0, x21
	bl	sblk_read_page
	ldr	w0, [x21, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2882
	ldr	x0, [x21, 24]
	ldr	w25, [x0, 4]
	mov	w0, w25
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L2883
	mov	w2, 0
	add	x1, x29, 92
	mov	w0, w25
	bl	pm_log2phys
.L2883:
	ldr	w0, [x29, 92]
	cmp	w22, w0
	bne	.L2882
	ldrh	w0, [x19, 24]
	ldr	x2, [x24, #:lo12:.LANCHOR65]
	ubfiz	x1, x0, 2, 16
	add	w0, w0, 1
	str	w22, [x2, x1]
	strh	w0, [x19, 24]
.L2882:
	ldrh	w0, [x19, 26]
	add	w0, w0, 1
	strh	w0, [x19, 26]
.L2877:
	add	w20, w20, 1
	cmp	w20, 4
	bne	.L2885
	b	.L2886
.L2879:
	orr	w0, w22, w20, lsl 24
	b	.L2899
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
	adrp	x19, .LANCHOR62
	stp	x21, x22, [sp, 32]
	ldrh	w1, [x19, #:lo12:.LANCHOR62]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w1, w0
	bne	.L2901
	adrp	x1, .LANCHOR206
	adrp	x0, .LC0
	mov	w2, 920
	add	x1, x1, :lo12:.LANCHOR206
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2901:
	ldrh	w1, [x19, #:lo12:.LANCHOR62]
	mov	w0, 65535
	cmp	w1, w0
	beq	.L2921
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L2903
	adrp	x2, .LANCHOR9
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR9]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC192
	add	x0, x0, :lo12:.LC192
	bl	printf
.L2903:
	ldrh	w0, [x19, #:lo12:.LANCHOR62]
	add	x14, x19, :lo12:.LANCHOR62
	add	x1, x14, 40
	bl	ftl_get_blk_list_in_sblk
	and	w1, w0, 255
	strb	w1, [x14, 5]
	cbnz	w1, .L2904
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR62]
.L2921:
	mov	w0, 0
	b	.L2900
.L2904:
	adrp	x4, .LANCHOR7
	ldrh	w3, [x19, #:lo12:.LANCHOR62]
	mov	x22, x4
	ldr	x1, [x4, #:lo12:.LANCHOR7]
	mov	x2, x3
	add	x1, x1, x3, lsl 2
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 32
	beq	.L2905
	cmp	w1, 224
	beq	.L2905
	cbz	w1, .L2906
	adrp	x1, .LANCHOR10
	ldr	x1, [x1, #:lo12:.LANCHOR10]
	ldrh	w3, [x1, 16]
	cmp	w3, w2
	beq	.L2905
	ldrh	w3, [x1, 48]
	cmp	w3, w2
	beq	.L2905
	ldrh	w1, [x1, 80]
	cmp	w1, w2
	bne	.L2935
.L2905:
	add	x0, x19, :lo12:.LANCHOR62
	mov	w1, -1
	strh	w1, [x19, #:lo12:.LANCHOR62]
	strh	wzr, [x0, 24]
	b	.L2921
.L2906:
	adrp	x0, .LANCHOR9
	mov	x20, x0
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x1, x3, lsl 1]
	cbz	w1, .L2908
	adrp	x1, .LANCHOR206
	adrp	x0, .LC0
	mov	w2, 940
	add	x1, x1, :lo12:.LANCHOR206
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2908:
	ldrh	w1, [x19, #:lo12:.LANCHOR62]
	ldr	x0, [x20, #:lo12:.LANCHOR9]
	strh	wzr, [x0, x1, lsl 1]
	b	.L2905
.L2935:
	and	w0, w0, 255
	sub	w0, w0, #1
	add	x0, x14, x0, sxtw 1
	ldrh	w21, [x0, 40]
	mov	w0, 65535
	cmp	w21, w0
	bne	.L2909
	adrp	x1, .LANCHOR206
	adrp	x0, .LC0
	mov	w2, 948
	add	x1, x1, :lo12:.LANCHOR206
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2909:
	adrp	x1, .LANCHOR105
	ldr	x3, [x22, #:lo12:.LANCHOR7]
	adrp	x2, .LANCHOR80
	adrp	x23, .LANCHOR72
	ldrh	w20, [x1, #:lo12:.LANCHOR105]
	mov	x24, x2
	ldrh	w1, [x19, #:lo12:.LANCHOR62]
	ldrh	w0, [x2, #:lo12:.LANCHOR80]
	add	x1, x3, x1, lsl 2
	sub	w0, w0, #1
	and	w0, w0, 65535
	mul	w20, w20, w21
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 160
	bne	.L2922
	adrp	x1, .LANCHOR68
	ldrb	w21, [x1, #:lo12:.LANCHOR68]
	cmp	w21, 2
	orr	w20, w20, w21, lsl 24
	beq	.L2911
	and	w21, w21, 65535
.L2910:
	add	x22, x19, :lo12:.LANCHOR62
	orr	w20, w0, w20
	mov	w0, 1
	strb	w21, [x22, 6]
	strh	wzr, [x22, 2]
	strb	wzr, [x22, 4]
	strh	wzr, [x22, 26]
	bl	buf_alloc
	str	w20, [x0, 40]
	mov	x25, x0
	mov	w1, 1
	adrp	x20, .LANCHOR65
	bl	sblk_read_page
	ldrh	w2, [x23, #:lo12:.LANCHOR72]
	adrp	x23, .LANCHOR73
	mov	w1, 255
	ldrb	w0, [x23, #:lo12:.LANCHOR73]
	mul	w2, w2, w0
	ldr	x0, [x20, #:lo12:.LANCHOR65]
	lsl	w2, w2, 2
	bl	ftl_memset
	strh	wzr, [x22, 24]
	ldr	w0, [x25, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L2912
.L2937:
	mov	x0, x25
	bl	buf_free
	mov	w0, -1
.L2900:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2911:
	ldrh	w0, [x23, #:lo12:.LANCHOR72]
	sub	w0, w0, #1
	and	w0, w0, 65535
	b	.L2910
.L2922:
	mov	w21, 1
	b	.L2910
.L2912:
	ldr	x0, [x25, 24]
	ldr	w1, [x0]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	cmp	w1, w0
	beq	.L2913
	mov	w2, 980
	adrp	x1, .LANCHOR206
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR206
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L2937
.L2913:
	ldrb	w0, [x23, #:lo12:.LANCHOR73]
	adrp	x22, .LANCHOR99
	ldrh	w1, [x24, #:lo12:.LANCHOR80]
	adrp	x23, .LANCHOR98
	ldr	x24, [x25, 8]
	add	x22, x22, :lo12:.LANCHOR99
	add	x23, x23, :lo12:.LANCHOR98
	mov	x26, 0
	mul	w0, w0, w1
	mul	w21, w21, w0
	and	w21, w21, 65535
.L2914:
	cmp	w21, w26
	bgt	.L2919
	mov	x0, x25
	bl	buf_free
	adrp	x0, .LANCHOR9
	ldrh	w1, [x19, #:lo12:.LANCHOR62]
	add	x3, x19, :lo12:.LANCHOR62
	mov	x20, x0
	ldr	x4, [x0, #:lo12:.LANCHOR9]
	ubfiz	x2, x1, 1, 16
	ldrh	w3, [x3, 24]
	ldrh	w2, [x4, x2]
	cmp	w2, w3
	beq	.L2920
	adrp	x0, .LC193
	add	x0, x0, :lo12:.LC193
	bl	printf
.L2920:
	add	x0, x19, :lo12:.LANCHOR62
	ldrh	w2, [x19, #:lo12:.LANCHOR62]
	ldr	x1, [x20, #:lo12:.LANCHOR9]
	ldrh	w3, [x0, 24]
	strh	w3, [x1, x2, lsl 1]
	strh	wzr, [x0, 28]
	ldrh	w0, [x0, 24]
	b	.L2900
.L2919:
	ldr	w0, [x24, x26, lsl 2]
	cmn	w0, #1
	beq	.L2916
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L2917
	ldr	w0, [x24, x26, lsl 2]
	mov	w2, 0
	add	x1, x29, 92
	bl	pm_log2phys
.L2917:
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
	ldrh	w2, [x19, #:lo12:.LANCHOR62]
	udiv	w0, w0, w1
	add	x1, x19, :lo12:.LANCHOR62
	cmp	w0, w2
	bne	.L2916
	ldrh	w0, [x1, 24]
	ldr	x4, [x20, #:lo12:.LANCHOR65]
	ubfiz	x2, x0, 2, 16
	add	w0, w0, 1
	str	w3, [x4, x2]
	strh	w0, [x1, 24]
.L2916:
	add	x26, x26, 1
	b	.L2914
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
	beq	.L2939
	adrp	x21, .LANCHOR207
	adrp	x22, .LC0
	add	x21, x21, :lo12:.LANCHOR207
	add	x22, x22, :lo12:.LC0
	mov	w20, 11
.L2947:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	mov	w2, 0
	add	x1, x29, 76
	ldr	w0, [x0, 544]
	bl	pm_log2phys
	ldr	w0, [x29, 76]
	cmn	w0, #1
	beq	.L2940
	mov	w0, 1
	bl	buf_alloc
	ldr	w1, [x29, 76]
	mov	x23, x0
	str	w1, [x0, 40]
	mov	w1, 1
	bl	sblk_read_page
	ldr	w0, [x23, 52]
	cmp	w0, 256
	bne	.L2941
	adrp	x0, .LANCHOR99
	ldr	w2, [x29, 76]
	mov	w1, 1
	ldrh	w3, [x0, #:lo12:.LANCHOR99]
	mov	w0, 21
	sub	w0, w0, w3
	lsr	w2, w2, w3
	lsl	w0, w1, w0
	sub	w0, w0, #1
	and	w0, w0, w2
	adrp	x2, .LANCHOR98
	ldrb	w3, [x2, #:lo12:.LANCHOR98]
	mov	w2, 0
	udiv	w0, w0, w3
	bl	gc_add_sblk
.L2941:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	ldr	x1, [x23, 24]
	ldr	w0, [x0, 544]
	ldr	w1, [x1, 4]
	cmp	w1, w0
	beq	.L2942
	mov	w2, 1419
	mov	x1, x21
	mov	x0, x22
	bl	printf
.L2942:
	mov	x0, x23
	bl	buf_free
.L2940:
	ldr	x0, [x19, #:lo12:.LANCHOR10]
	adrp	x2, .LANCHOR118
	ldr	w2, [x2, #:lo12:.LANCHOR118]
	ldr	w1, [x0, 544]
	add	w1, w1, 1
	str	w1, [x0, 544]
	cmp	w1, w2
	bcc	.L2943
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
.L2938:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2943:
	ldr	w0, [x29, 76]
	cmn	w0, #1
	bne	.L2938
	sub	w20, w20, #1
	ands	w20, w20, 65535
	bne	.L2947
	b	.L2938
.L2939:
	ldr	w1, [x0, 536]
	adrp	x3, .LANCHOR97
	ldr	w2, [x0, 12]
	add	w1, w1, 12959744
	add	w1, w1, 256
	cmp	w2, w1
	bhi	.L2949
	ldr	x4, [x3, #:lo12:.LANCHOR97]
	ldr	w1, [x0, 540]
	add	w1, w1, 98304
	ldr	w4, [x4, 44]
	add	w1, w1, 1696
	cmp	w4, w1
	bls	.L2938
.L2949:
	ldr	x1, [x3, #:lo12:.LANCHOR97]
	ldr	w1, [x1, 44]
	str	w1, [x0, 540]
	str	w2, [x0, 536]
	str	wzr, [x0, 544]
	b	.L2938
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
	adrp	x0, .LC194
	ubfx	x5, x5, 11, 8
	add	x0, x0, :lo12:.LC194
	ubfx	x3, x2, 3, 2
	and	w4, w4, 2047
	ubfx	x2, x2, 5, 3
	bl	printf
	mov	w0, 65535
	cmp	w21, w0
	beq	.L2976
	adrp	x0, .LANCHOR6
	ldrh	w0, [x0, #:lo12:.LANCHOR6]
	cmp	w0, w21
	bls	.L2976
	ldr	x0, [x24, #:lo12:.LANCHOR7]
	add	x0, x0, x23
	ldrb	w0, [x0, 2]
	and	w0, w0, 224
	cmp	w0, 160
	bne	.L2977
	adrp	x0, .LANCHOR68
	ldrb	w25, [x0, #:lo12:.LANCHOR68]
.L2957:
	add	x28, x29, 224
	adrp	x19, .LANCHOR80
	mov	w0, w21
	mov	w27, 0
	mov	w20, 0
	strh	w21, [x28, -32]!
	add	x1, x28, 16
	bl	ftl_get_blk_list_in_sblk
	ldrh	w2, [x19, #:lo12:.LANCHOR80]
	and	w1, w0, 255
	strb	w1, [x29, 201]
	and	w4, w0, 255
	strb	wzr, [x29, 197]
	mov	w3, w25
	strh	wzr, [x29, 194]
	adrp	x0, .LC195
	mul	w1, w1, w2
	strh	wzr, [x29, 202]
	strh	w1, [x29, 198]
	add	x0, x0, :lo12:.LC195
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
	adrp	x0, .LANCHOR105
	add	x0, x0, :lo12:.LANCHOR105
	str	x0, [x29, 112]
.L2958:
	ldr	x0, [x29, 136]
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w0, w20
	bls	.L2973
	lsl	w0, w20, 1
	str	wzr, [x29, 172]
	sub	w0, w0, #1
	str	w0, [x29, 160]
	adrp	x0, .LC149
	add	x0, x0, :lo12:.LC149
	str	x0, [x29, 120]
	b	.L2974
.L2977:
	mov	w25, 1
	b	.L2957
.L2970:
	ldr	x0, [x29, 128]
	ldrh	w10, [x28, x0]
	mov	w0, 65535
	cmp	w10, w0
	beq	.L2959
	ldr	x0, [x29, 112]
	cmp	w25, 3
	ldrh	w19, [x0]
	mul	w19, w19, w10
	bne	.L2960
	add	w19, w20, w19
	orr	w19, w19, w22, lsl 24
.L2961:
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
	beq	.L2959
	ldr	x0, [x26, 24]
	ldr	w0, [x0, 4]
	bl	lpa_hash_get_ppa
	str	w0, [x29, 188]
	cmn	w0, #1
	bne	.L2964
	ldr	x0, [x26, 24]
	mov	w2, 0
	add	x1, x29, 188
	ldr	w0, [x0, 4]
	bl	pm_log2phys
.L2964:
	ldr	w0, [x29, 188]
	cmp	w19, w0
	bne	.L2965
	ldr	w0, [x29, 168]
	mov	w1, w19
	add	w0, w0, 1
	str	w0, [x29, 168]
	ldr	x0, [x26, 24]
	ldr	w3, [x29, 168]
	ldr	w2, [x0, 4]
	adrp	x0, .LC196
	add	x0, x0, :lo12:.LC196
	bl	printf
.L2965:
	ldr	x0, [x29, 152]
	cbz	x0, .L2967
	ubfiz	x19, x27, 2, 32
	ldr	w2, [x0, x19]
	ldr	x0, [x26, 24]
	ldr	w0, [x0, 4]
	cmp	w0, w2
	beq	.L2968
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L2968
	adrp	x0, .LC197
	mov	w1, w27
	add	x0, x0, :lo12:.LC197
	bl	printf
.L2968:
	ldr	x1, [x26, 24]
	ldr	x0, [x29, 152]
	ldr	w1, [x1, 4]
	ldr	w0, [x0, x19]
	cmp	w1, w0
	beq	.L2967
	cmn	w0, #1
	beq	.L2967
	adrp	x1, .LANCHOR208
	adrp	x0, .LC0
	mov	w2, 1300
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2967:
	add	w27, w27, 1
.L2959:
	add	w22, w22, 1
	and	w22, w22, 65535
.L2972:
	cmp	w25, w22
	bcs	.L2970
	ldr	w0, [x29, 172]
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w0, [x29, 172]
.L2974:
	ldrb	w0, [x29, 201]
	ldr	w1, [x29, 172]
	cmp	w0, w1
	bls	.L2971
	ldrsw	x0, [x29, 172]
	mov	w22, 1
	add	x0, x0, 8
	lsl	x0, x0, 1
	str	x0, [x29, 128]
	b	.L2972
.L2960:
	cmp	w25, 2
	bne	.L2962
	ldr	w0, [x29, 160]
	add	w19, w19, w0
	adrp	x0, .LANCHOR68
	add	w19, w19, w22
	ldrb	w0, [x0, #:lo12:.LANCHOR68]
	orr	w19, w19, w0, lsl 24
	b	.L2961
.L2962:
	add	w19, w20, w19
	b	.L2961
.L2971:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2958
.L2973:
	mov	x0, x26
	bl	buf_free
	adrp	x0, .LANCHOR9
	ldr	x1, [x29, 144]
	ldr	w3, [x29, 168]
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w2, [x0, x1, lsl 1]
	mov	w1, w21
	adrp	x0, .LC198
	add	x0, x0, :lo12:.LC198
	bl	printf
	ldr	w0, [x29, 164]
.L2955:
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 272
	ret
.L2976:
	mov	w0, 0
	b	.L2955
	.size	ftl_sblk_dump, .-ftl_sblk_dump
	.section	.text.zftl_read,"ax",@progbits
	.align	2
	.global	zftl_read
	.type	zftl_read, %function
zftl_read:
	stp	x29, x30, [sp, -192]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w0
	adrp	x0, .LANCHOR14
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	mov	w19, w1
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	mov	w26, w2
	stp	x23, x24, [sp, 48]
	mov	x22, x3
	stp	x27, x28, [sp, 80]
	tbz	x0, 12, .L2988
	mov	w3, w2
	adrp	x0, .LC199
	mov	w2, w1
	add	x0, x0, :lo12:.LC199
	mov	w1, w20
	bl	printf
.L2988:
	cbnz	w20, .L2989
	adrp	x0, .LANCHOR58
	mov	w20, 24576
	ldr	w0, [x0, #:lo12:.LANCHOR58]
.L2990:
	add	w1, w19, w26
	cmp	w0, w1
	bcc	.L3018
	adrp	x1, .LANCHOR97
	add	w20, w20, w19
	add	w3, w26, w20
	stp	w3, wzr, [x29, 160]
	ldr	x2, [x1, #:lo12:.LANCHOR97]
	sub	w3, w3, #1
	str	x1, [x29, 120]
	ldr	w0, [x2, 24]
	add	w0, w0, w26
	str	w0, [x2, 24]
	adrp	x0, .LANCHOR121
	str	x0, [x29, 168]
	ldrb	w2, [x0, #:lo12:.LANCHOR121]
	adrp	x0, .LANCHOR125
	add	x28, x0, :lo12:.LANCHOR125
	udiv	w27, w20, w2
	udiv	w2, w3, w2
	mov	w21, w27
	sub	w25, w2, w27
	str	w2, [x29, 156]
	add	w25, w25, 1
.L2992:
	cbnz	w25, .L3016
	ldr	w0, [x29, 164]
.L2987:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L2989:
	cmp	w20, 3
	bhi	.L3018
	lsl	w20, w20, 13
	mov	w0, 8192
	b	.L2990
.L3016:
	ldr	x0, [x29, 168]
	cmp	w21, w27
	ldrb	w1, [x0, #:lo12:.LANCHOR121]
	ldr	w0, [x29, 156]
	and	w19, w1, 65535
	ccmp	w21, w0, 4, ne
	bne	.L3019
	cmp	w21, w27
	bne	.L2994
	udiv	w24, w20, w1
	and	w0, w26, 65535
	msub	w1, w24, w1, w20
	and	w24, w1, 65535
	sub	w19, w19, w24
	and	w19, w19, 65535
	cmp	w26, w19
	csel	w19, w0, w19, cc
.L2993:
	adrp	x23, .LANCHOR49
	add	x1, x23, :lo12:.LANCHOR49
	add	x1, x1, 2
	mov	w0, 0
.L2997:
	ldr	w2, [x1, 34]
	cmp	w21, w2
	bne	.L2995
	ldrb	w2, [x1]
	tbz	x2, 3, .L2995
	add	x1, x23, :lo12:.LANCHOR49
	ubfiz	x0, x0, 6, 32
	add	x0, x1, x0
	lsl	w2, w19, 9
	ubfiz	x19, x19, 9, 16
	ubfiz	x24, x24, 9, 16
	ldr	x1, [x0, 8]
	mov	x0, x22
	add	x22, x22, x19
	add	x1, x1, x24
	bl	ftl_memcpy
.L2996:
	add	w21, w21, 1
	sub	w25, w25, #1
.L3003:
	adrp	x0, .LANCHOR51
	ldrb	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, 2
	bls	.L3004
	cbnz	w25, .L2992
.L3004:
	adrp	x0, .LANCHOR125
	ldrb	w1, [x0, #:lo12:.LANCHOR125]
	cbz	w1, .L2992
	adrp	x24, .LANCHOR124
	add	x0, x23, :lo12:.LANCHOR49
	ldrb	w2, [x24, #:lo12:.LANCHOR124]
	add	x0, x0, x2, lsl 6
	bl	sblk_read_page
	adrp	x0, .LANCHOR209
	add	x0, x0, :lo12:.LANCHOR209
	str	x0, [x29, 136]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	str	x0, [x29, 128]
.L3006:
	ldrb	w0, [x28]
	cbnz	w0, .L3015
	mov	w0, -1
	strb	wzr, [x28]
	strb	w0, [x24, #:lo12:.LANCHOR124]
	b	.L2992
.L2994:
	ldr	w0, [x29, 160]
	msub	w19, w1, w21, w0
	and	w19, w19, 255
.L3019:
	mov	w24, 0
	b	.L2993
.L2995:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L2997
	mov	w0, w21
	bl	lpa_hash_get_ppa
	str	w0, [x29, 188]
	cmn	w0, #1
	bne	.L2998
	mov	w2, 0
	add	x1, x29, 188
	mov	w0, w21
	bl	pm_log2phys
.L2998:
	ldr	w0, [x29, 188]
	cmn	w0, #1
	bne	.L2999
	ldr	x0, [x29, 168]
	mov	w19, 0
	add	x24, x0, :lo12:.LANCHOR121
.L3000:
	ldrb	w0, [x24]
	cmp	w19, w0
	bcs	.L2996
	madd	w0, w21, w0, w19
	cmp	w20, w0
	bhi	.L3001
	ldr	w1, [x29, 160]
	cmp	w1, w0
	bls	.L3001
	mov	x0, x22
	add	x22, x22, 512
	mov	w2, 512
	mov	w1, 0
	bl	ftl_memset
.L3001:
	add	w19, w19, 1
	b	.L3000
.L2999:
	mov	w0, 0
	bl	buf_alloc
	cbz	x0, .L3003
	ldr	x2, [x29, 120]
	ldr	x3, [x2, #:lo12:.LANCHOR97]
	ldr	w2, [x3, 40]
	add	w2, w2, 1
	str	w2, [x3, 40]
	ldr	w2, [x29, 188]
	strb	w19, [x0, 56]
	ubfiz	x19, x19, 9, 16
	str	x22, [x0, 16]
	add	x22, x22, x19
	strb	w24, [x0, 57]
	stp	w21, w2, [x0, 36]
	str	w2, [x0, 44]
	bl	zftl_add_read_buf
	b	.L2996
.L3015:
	ldrb	w0, [x24, #:lo12:.LANCHOR124]
	cmp	w0, 255
	bne	.L3007
	ldp	x0, x1, [x29, 128]
	mov	w2, 1064
	bl	printf
.L3007:
	ldrb	w19, [x24, #:lo12:.LANCHOR124]
	add	x0, x23, :lo12:.LANCHOR49
	ubfiz	x1, x19, 6, 8
	lsl	x2, x19, 6
	add	x1, x0, x1
	str	x1, [x29, 144]
	add	x1, x0, x2
	ldrb	w0, [x0, x2]
	strb	w0, [x24, #:lo12:.LANCHOR124]
	ldr	w8, [x1, 52]
	cmn	w8, #1
	bne	.L3008
	adrp	x0, .LANCHOR10
	str	w8, [x29, 164]
	ldr	x1, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x1, 552]
	add	w0, w0, 1
	str	w0, [x1, 552]
.L3009:
	add	x10, x23, :lo12:.LANCHOR49
	add	x10, x10, x19, lsl 6
	ldr	x0, [x10, 24]
	ldr	w2, [x10, 36]
	ldr	w1, [x0, 4]
	cmp	w1, w2
	beq	.L3010
	adrp	x1, .LANCHOR10
	str	w8, [x29, 152]
	str	x10, [x29, 112]
	ldr	x3, [x1, #:lo12:.LANCHOR10]
	ldr	w1, [x3, 552]
	add	w1, w1, 1
	str	w1, [x3, 552]
	ldrb	w1, [x10, 1]
	ldp	w4, w5, [x0]
	ldp	w6, w7, [x0, 8]
	adrp	x0, .LC201
	ldr	w3, [x10, 40]
	add	x0, x0, :lo12:.LC201
	bl	printf
	ldr	x10, [x29, 112]
	adrp	x0, .LANCHOR99
	ldrh	w3, [x0, #:lo12:.LANCHOR99]
	mov	w0, 21
	ldr	w1, [x10, 40]
	sub	w2, w0, w3
	mov	w0, 1
	lsl	w0, w0, w2
	sub	w0, w0, #1
	lsr	w1, w1, w3
	and	w0, w0, w1
	adrp	x1, .LANCHOR98
	ldrb	w2, [x1, #:lo12:.LANCHOR98]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
	ldr	w8, [x29, 152]
.L3010:
	add	x0, x23, :lo12:.LANCHOR49
	add	x0, x0, x19, lsl 6
	ldr	x1, [x0, 24]
	ldr	w0, [x0, 36]
	ldr	w1, [x1, 4]
	cmp	w1, w0
	bne	.L3011
	cmn	w8, #1
	bne	.L3012
.L3011:
	ldp	x0, x1, [x29, 128]
	mov	w2, 1085
	bl	printf
.L3012:
	add	x0, x23, :lo12:.LANCHOR49
	add	x19, x0, x19, lsl 6
	ldr	x0, [x29, 168]
	ldrb	w2, [x19, 56]
	ldrb	w0, [x0, #:lo12:.LANCHOR121]
	cmp	w0, w2
	bls	.L3013
	ldrb	w0, [x19, 57]
	lsl	w2, w2, 9
	ldr	x1, [x19, 8]
	ubfiz	x0, x0, 9, 8
	add	x1, x1, x0
	ldr	x0, [x19, 16]
	bl	ftl_memcpy
.L3014:
	ldr	x1, [x29, 144]
	adrp	x0, .LANCHOR127
	add	x0, x0, :lo12:.LANCHOR127
	bl	buf_remove_buf
	ldr	x0, [x29, 144]
	bl	buf_free
	ldrb	w0, [x28]
	sub	w0, w0, #1
	strb	w0, [x28]
	b	.L3006
.L3008:
	cmp	w8, 256
	bne	.L3009
	adrp	x0, .LANCHOR99
	mov	w4, 21
	ldp	w2, w3, [x1, 36]
	mov	w5, 1
	ldrh	w0, [x0, #:lo12:.LANCHOR99]
	str	w5, [x29, 152]
	sub	w4, w4, w0
	lsr	w0, w3, w0
	lsl	w4, w5, w4
	sub	w4, w4, #1
	and	w4, w4, w0
	adrp	x0, .LANCHOR98
	ldrb	w0, [x0, #:lo12:.LANCHOR98]
	udiv	w4, w4, w0
	adrp	x0, .LC200
	add	x0, x0, :lo12:.LC200
	stp	w8, w4, [x29, 108]
	and	w1, w4, 65535
	bl	printf
	ldr	w4, [x29, 112]
	mov	w2, 0
	ldr	w5, [x29, 152]
	mov	w0, w4
	mov	w1, w5
	bl	gc_add_sblk
	ldr	w8, [x29, 108]
	b	.L3009
.L3013:
	ldrb	w0, [x19, 2]
	and	w0, w0, -9
	strb	w0, [x19, 2]
	b	.L3014
.L3018:
	mov	w0, -1
	b	.L2987
	.size	zftl_read, .-zftl_read
	.section	.text.zftl_vendor_read,"ax",@progbits
	.align	2
	.global	zftl_vendor_read
	.type	zftl_vendor_read, %function
zftl_vendor_read:
	mov	x3, x2
	mov	w2, w1
	add	w1, w0, 512
	mov	w0, 2
	b	zftl_read
	.size	zftl_vendor_read, .-zftl_vendor_read
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
	adrp	x0, .LANCHOR80
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldrh	w23, [x0, #:lo12:.LANCHOR80]
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
	beq	.L3041
	adrp	x1, .LANCHOR210
	adrp	x0, .LC0
	mov	w2, 1576
	add	x1, x1, :lo12:.LANCHOR210
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3041:
	adrp	x27, .LANCHOR121
	mov	x24, 0
	add	x0, x27, :lo12:.LANCHOR121
	mov	w21, 0
	str	x0, [x29, 96]
.L3042:
	cmp	w24, w23
	blt	.L3048
	adrp	x0, .LANCHOR14
	adrp	x19, .LANCHOR9
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3049
	ldrh	w1, [x22]
	ldr	x2, [x19, #:lo12:.LANCHOR9]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC205
	mov	w2, w21
	add	x0, x0, :lo12:.LC205
	bl	printf
.L3049:
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
.L3048:
	ldr	w2, [x19, x24, lsl 2]
	cmn	w2, #1
	beq	.L3043
	ldrb	w20, [x27, #:lo12:.LANCHOR121]
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	lsl	w20, w20, 7
	udiv	w20, w2, w20
	and	w20, w20, 65535
	tbz	x0, 12, .L3044
	adrp	x0, .LC202
	mov	w3, w24
	mov	w1, w20
	add	x0, x0, :lo12:.LC202
	bl	printf
.L3044:
	adrp	x25, .LANCHOR105
	adrp	x26, .LC203
	mov	x28, x24
	add	x25, x25, :lo12:.LANCHOR105
	add	x26, x26, :lo12:.LC203
.L3047:
	ldr	w1, [x19, x28, lsl 2]
	cmn	w1, #1
	beq	.L3045
	ldr	x0, [x29, 96]
	ldrb	w2, [x0]
	lsl	w2, w2, 7
	udiv	w1, w1, w2
	cmp	w20, w1, uxth
	bne	.L3045
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
	cbz	w0, .L3046
	ldr	x0, [x29, 104]
	mov	w3, w23
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR111]
	adrp	x0, .LC204
	add	x0, x0, :lo12:.LC204
	bl	rknand_print_hex
.L3046:
	ldr	w0, [x19, x28, lsl 2]
	add	w21, w21, 1
	mov	w2, 1
	add	x1, x29, 124
	and	w21, w21, 65535
	bl	pm_log2phys
	mov	w0, -1
	str	w0, [x19, x28, lsl 2]
.L3045:
	add	x28, x28, 1
	cmp	w23, w28
	bgt	.L3047
.L3043:
	add	x24, x24, 1
	b	.L3042
	.size	ftl_update_l2p_map, .-ftl_update_l2p_map
	.section	.text.ftl_alloc_new_data_sblk,"ax",@progbits
	.align	2
	.global	ftl_alloc_new_data_sblk
	.type	ftl_alloc_new_data_sblk, %function
ftl_alloc_new_data_sblk:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	x19, x0
	bl	ftl_update_l2p_map
	bl	pm_flush
	ldrh	w0, [x19]
	mov	w1, 65535
	cmp	w0, w1
	beq	.L3071
	bl	zftl_insert_data_list
.L3071:
	adrp	x0, .LANCHOR10
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	add	x0, x0, 16
	cmp	x19, x0
	mov	x0, x19
	cset	w1, ne
	add	w1, w1, 2
	bl	ftl_open_sblk_init
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	lpa_rebuild_hash
	ldr	x19, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
	.size	ftl_alloc_new_data_sblk, .-ftl_alloc_new_data_sblk
	.section	.text.ftl_write_commit,"ax",@progbits
	.align	2
	.global	ftl_write_commit
	.type	ftl_write_commit, %function
ftl_write_commit:
	stp	x29, x30, [sp, -144]!
	adrp	x0, .LANCHOR49
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	add	x23, x0, :lo12:.LANCHOR49
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
.L3076:
	adrp	x2, .LANCHOR57
	ldrb	w1, [x2, #:lo12:.LANCHOR57]
	cbz	w1, .L3078
	adrp	x3, .LANCHOR56
	adrp	x0, .LANCHOR49
	add	x0, x0, :lo12:.LANCHOR49
	sub	w1, w1, #1
	ldrb	w4, [x3, #:lo12:.LANCHOR56]
	strb	w1, [x2, #:lo12:.LANCHOR57]
	ubfiz	x27, x4, 6, 8
	add	x5, x0, x27
	stp	x4, x5, [x29, 112]
	lsl	x4, x4, 6
	add	x5, x0, x4
	ldrb	w0, [x0, x4]
	strb	w0, [x3, #:lo12:.LANCHOR56]
	adrp	x0, .LANCHOR118
	ldr	w2, [x5, 36]
	mov	x19, x0
	ldr	w1, [x0, #:lo12:.LANCHOR118]
	cmp	w2, w1
	bcc	.L3080
	adrp	x1, .LANCHOR211
	adrp	x0, .LC0
	mov	w2, 495
	add	x1, x1, :lo12:.LANCHOR211
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3080:
	ldr	x0, [x29, 112]
	ldr	w1, [x19, #:lo12:.LANCHOR118]
	add	x0, x23, x0, lsl 6
	ldr	w22, [x0, 36]
	cmp	w22, w1
	bcc	.L3081
	ldr	x0, [x29, 120]
	bl	buf_free
	mov	w0, -1
.L3075:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L3081:
	ldrb	w21, [x0, 57]
	ldrb	w20, [x0, 56]
	ldr	x26, [x0, 8]
	ldr	x28, [x0, 24]
	adrp	x0, .LANCHOR119
	str	x0, [x29, 104]
	ldrb	w1, [x0, #:lo12:.LANCHOR119]
	cbz	w1, .L3083
	adrp	x0, .LANCHOR174
	ldrb	w1, [x0, #:lo12:.LANCHOR174]
	add	x1, x23, x1, lsl 6
.L3084:
	ldrb	w0, [x1]
	cmp	w0, 255
	bne	.L3085
	ldr	w0, [x1, 36]
	cmp	w22, w0
	bne	.L3083
	ldr	x0, [x1, 8]
	ubfiz	x21, x21, 9, 8
	lsl	w2, w20, 9
	add	x1, x26, x21
	add	x0, x0, x21
	bl	ftl_memcpy
	ldr	x0, [x29, 120]
	bl	buf_free
	b	.L3076
.L3085:
	ubfiz	x1, x0, 6, 8
	add	x1, x23, x1
	b	.L3084
.L3083:
	mov	w0, w22
	bl	lpa_hash_get_ppa
	str	w0, [x29, 140]
	cmn	w0, #1
	bne	.L3087
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w22
	bl	pm_log2phys
.L3087:
	adrp	x25, .LANCHOR10
	add	x1, x23, 2
	mov	w0, 0
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 16
.L3090:
	ldr	w2, [x1, 34]
	cmp	w22, w2
	bne	.L3088
	ldrb	w2, [x1]
	tbz	x2, 3, .L3088
	ubfiz	x0, x0, 6, 32
	and	w2, w2, -9
	add	x0, x23, x0
	strb	w2, [x0, 2]
	ldr	x24, [x0, 8]
	ldr	w0, [x0, 40]
	str	w0, [x29, 140]
.L3089:
	adrp	x0, .LANCHOR121
	str	x0, [x29, 96]
	ldrb	w1, [x0, #:lo12:.LANCHOR121]
	cmp	w20, w1
	bcs	.L3114
	add	w20, w21, w20
	cbz	x24, .L3092
	cbz	w21, .L3093
	lsl	w2, w21, 9
	mov	x1, x24
	mov	x0, x26
	bl	ftl_memcpy
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 48
.L3093:
	ldr	x0, [x29, 96]
	ldrb	w2, [x0, #:lo12:.LANCHOR121]
	cmp	w20, w2
	bcc	.L3094
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 16
.L3114:
	mov	w24, 0
	b	.L3091
.L3088:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L3090
	mov	x24, 0
	b	.L3089
.L3094:
	ubfiz	x0, x20, 9, 9
	sub	w2, w2, w20
	add	x1, x24, x0
	lsl	w2, w2, 9
	add	x0, x26, x0
	bl	ftl_memcpy
	b	.L3114
.L3092:
	ldr	w0, [x29, 140]
	cmn	w0, #1
	beq	.L3095
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
	bne	.L3096
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L3097
.L3096:
	ldr	x1, [x25, #:lo12:.LANCHOR10]
	mov	w3, w22
	ldr	w4, [x27, 52]
	ldr	w2, [x29, 140]
	ldr	w0, [x1, 552]
	add	w0, w0, 1
	str	w0, [x1, 552]
	adrp	x0, .LC206
	add	x0, x0, :lo12:.LC206
	ldrb	w1, [x27, 1]
	bl	printf
	ldr	x1, [x27, 24]
	mov	w3, 4
	adrp	x0, .LC168
	mov	w2, w3
	add	x0, x0, :lo12:.LC168
	bl	rknand_print_hex
.L3097:
	ldr	x0, [x27, 24]
	ldr	w0, [x0, 4]
	cmp	w22, w0
	bne	.L3098
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L3099
.L3098:
	adrp	x1, .LANCHOR211
	adrp	x0, .LC0
	mov	w2, 566
	add	x1, x1, :lo12:.LANCHOR211
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3099:
	cbz	w21, .L3100
	ldr	w0, [x29, 140]
	lsl	w2, w21, 9
	cmn	w0, #1
	beq	.L3101
	ldr	x1, [x27, 8]
	mov	x0, x26
	bl	ftl_memcpy
.L3102:
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 48
.L3100:
	ldr	x0, [x29, 96]
	ldrb	w2, [x0, #:lo12:.LANCHOR121]
	cmp	w20, w2
	bcc	.L3103
	bls	.L3104
	ldr	x19, [x25, #:lo12:.LANCHOR10]
	add	x19, x19, 16
.L3104:
	cbz	x27, .L3091
	ldrb	w0, [x27, 2]
	mov	x1, x27
	and	w0, w0, -9
	strb	w0, [x27, 2]
	adrp	x0, .LANCHOR127
	add	x0, x0, :lo12:.LANCHOR127
	bl	buf_remove_buf
	mov	x0, x27
	bl	buf_free
.L3091:
	ldrh	w0, [x19, 6]
	cbnz	w0, .L3106
	bl	ftl_flush
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L3106:
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
	ldrb	w2, [x0, #:lo12:.LANCHOR119]
	add	w2, w2, 1
	and	w2, w2, 255
	strb	w2, [x0, #:lo12:.LANCHOR119]
	adrp	x0, .LANCHOR212
	cmp	w2, 2
	str	wzr, [x0, #:lo12:.LANCHOR212]
	ldrh	w0, [x19, 6]
	bhi	.L3107
	cmp	w0, 1
	bne	.L3079
.L3107:
	ldrb	w1, [x19, 5]
	cmp	w1, 0
	mov	w1, 0
	cset	w4, ne
	cmp	w0, 1
	ldrb	w0, [x20, #:lo12:.LANCHOR174]
	csinc	w4, w2, w4, eq
	mov	w3, w0
.L3111:
	cmp	w1, w4
	bne	.L3112
	strb	w3, [x20, #:lo12:.LANCHOR174]
	and	w1, w1, 255
	ldr	x3, [x29, 104]
	sub	w2, w2, w1
	ubfiz	x0, x0, 6, 8
	add	x0, x23, x0
	strb	w2, [x3, #:lo12:.LANCHOR119]
	bl	sblk_prog_page
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bne	.L3079
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	mov	x0, x19
	bl	ftl_write_last_log_page
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L3079:
	adrp	x0, .LANCHOR57
	ldrb	w0, [x0, #:lo12:.LANCHOR57]
	cbnz	w0, .L3076
.L3078:
	bl	ftl_write_completed
	mov	w0, 0
	b	.L3075
.L3103:
	ldr	w0, [x29, 140]
	sub	w2, w2, w20
	lsl	w2, w2, 9
	cmn	w0, #1
	ubfiz	x0, x20, 7, 9
	beq	.L3105
	ldr	x1, [x27, 8]
	lsl	x0, x0, 2
	add	x1, x1, x0
	add	x0, x26, x0
	bl	ftl_memcpy
	b	.L3104
.L3105:
	mov	w1, 0
	add	x0, x26, x0, lsl 2
	bl	ftl_memset
	b	.L3104
.L3112:
	ubfiz	x3, x3, 6, 8
	add	w1, w1, 1
	ldrb	w3, [x23, x3]
	b	.L3111
.L3113:
	lsl	w2, w21, 9
	mov	x27, 0
	mov	w24, 0
.L3101:
	mov	w1, 0
	mov	x0, x26
	bl	ftl_memset
	b	.L3102
.L3095:
	cbnz	w21, .L3113
	mov	w24, 0
	mov	x27, 0
	b	.L3100
	.size	ftl_write_commit, .-ftl_write_commit
	.section	.text.gc_do_copy_back,"ax",@progbits
	.align	2
	.global	gc_do_copy_back
	.type	gc_do_copy_back, %function
gc_do_copy_back:
	sub	sp, sp, #224
	adrp	x0, .LANCHOR71
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	ldrb	w0, [x0, #:lo12:.LANCHOR71]
	stp	x19, x20, [sp, 32]
	stp	x21, x22, [sp, 48]
	stp	x23, x24, [sp, 64]
	stp	x25, x26, [sp, 80]
	stp	x27, x28, [sp, 96]
	cbnz	w0, .L3137
	bl	buf_alloc
	mov	x19, x0
	cbz	x0, .L3136
	adrp	x20, .LANCHOR62
	add	x3, x20, :lo12:.LANCHOR62
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
	bne	.L3139
	adrp	x1, .LANCHOR213
	adrp	x0, .LC0
	mov	w2, 595
	add	x1, x1, :lo12:.LANCHOR213
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3139:
	ldr	x0, [x19, 24]
	ldr	w21, [x0, 4]
	mov	w0, w21
	bl	lpa_hash_get_ppa
	str	w0, [x29, 160]
	cmn	w0, #1
	bne	.L3140
	mov	w2, 0
	add	x1, x29, 160
	mov	w0, w21
	bl	pm_log2phys
.L3140:
	ldr	w23, [x29, 160]
	cmp	w22, w23
	bne	.L3141
	adrp	x0, .LANCHOR49
	add	x0, x0, :lo12:.LANCHOR49
	add	x1, x0, 2
	add	x0, x0, 2050
.L3144:
	ldr	w2, [x1, 34]
	cmp	w21, w2
	bne	.L3142
	ldrb	w2, [x1]
	tbz	x2, 1, .L3142
	mov	x0, x19
	bl	buf_free
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3136
	add	x20, x20, :lo12:.LANCHOR62
	adrp	x0, .LC207
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC207
	ldrh	w3, [x20, 26]
	bl	printf
.L3136:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 224
	ret
.L3142:
	add	x1, x1, 64
	cmp	x0, x1
	bne	.L3144
	adrp	x0, .LANCHOR121
	mov	w1, 10
	strb	wzr, [x19, 57]
	ldrb	w0, [x0, #:lo12:.LANCHOR121]
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
	tbz	x0, 8, .L3145
	mov	w0, w21
	bl	lpa_hash_get_ppa
	add	x1, x20, :lo12:.LANCHOR62
	mov	w3, w0
	mov	w4, w22
	adrp	x0, .LC208
	mov	w2, w23
	add	x0, x0, :lo12:.LC208
	ldrh	w5, [x1, 26]
	mov	w1, w21
	bl	printf
.L3145:
	mov	x0, x19
	bl	ftl_gc_write_buf
	bl	ftl_write_commit
	add	x20, x20, :lo12:.LANCHOR62
	adrp	x0, .LANCHOR97
	ldr	x1, [x0, #:lo12:.LANCHOR97]
	ldr	w0, [x1, 60]
	add	w0, w0, 1
	str	w0, [x1, 60]
	ldrh	w0, [x20, 28]
	add	w0, w0, 1
	strh	w0, [x20, 28]
	b	.L3136
.L3141:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3146
	add	x20, x20, :lo12:.LANCHOR62
	mov	w0, w21
	bl	lpa_hash_get_ppa
	mov	w3, w0
	mov	w4, w22
	adrp	x0, .LC208
	ldrh	w5, [x20, 26]
	mov	w2, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC208
	bl	printf
.L3146:
	mov	x0, x19
	bl	buf_free
	b	.L3136
.L3137:
	adrp	x1, .LANCHOR10
	adrp	x0, .LANCHOR68
	stp	x0, x1, [x29, 128]
	adrp	x24, .LANCHOR62
	ldr	x22, [x1, #:lo12:.LANCHOR10]
	ldrb	w25, [x0, #:lo12:.LANCHOR68]
	add	x22, x22, 80
	cmp	w25, 3
	bne	.L3147
	adrp	x0, .LANCHOR70
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	cbz	w0, .L3148
	add	x0, x24, :lo12:.LANCHOR62
	ldrb	w19, [x22, 9]
	ldrh	w20, [x0, 314]
	add	w21, w19, w19, lsl 1
	sub	w19, w19, w19, lsl 2
	sdiv	w21, w20, w21
	madd	w19, w21, w19, w20
	and	w19, w19, 65535
.L3149:
	adrp	x1, .LANCHOR72
	ldrb	w0, [x22, 9]
	add	x4, x24, :lo12:.LANCHOR62
	mov	w2, 0
	ldrh	w3, [x1, #:lo12:.LANCHOR72]
	mul	w8, w25, w0
	ldrh	w10, [x4, 24]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR148
	ldr	x7, [x0, #:lo12:.LANCHOR148]
	sub	w3, w3, #1
.L3152:
	cmp	w2, w8
	blt	.L3154
.L3181:
	mov	w23, 1
	b	.L3150
.L3148:
	add	x0, x24, :lo12:.LANCHOR62
	ldrb	w20, [x22, 9]
	ldrh	w1, [x0, 314]
	adrp	x0, .LANCHOR214
	add	x0, x0, :lo12:.LANCHOR214
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
	beq	.L3149
.L3150:
	adrp	x0, .LANCHOR14
	str	x0, [x29, 112]
	ldr	w1, [x0, #:lo12:.LANCHOR14]
	tbz	x1, 8, .L3155
	adrp	x0, .LANCHOR148
	ubfiz	x1, x20, 2, 16
	mov	w6, w20
	mov	w3, w19
	ldr	x2, [x0, #:lo12:.LANCHOR148]
	add	x0, x24, :lo12:.LANCHOR62
	ldrh	w4, [x0, 314]
	adrp	x0, .LC209
	ldr	w5, [x2, x1]
	add	x0, x0, :lo12:.LC209
	mov	w2, w23
	mov	w1, w21
	bl	printf
.L3155:
	adrp	x0, .LANCHOR49
	str	wzr, [x29, 152]
	add	x0, x0, :lo12:.LANCHOR49
	str	x0, [x29, 120]
.L3156:
	ldrb	w2, [x22, 9]
	ldr	w0, [x29, 152]
	ldrh	w26, [x29, 152]
	and	w0, w0, 65535
	str	w0, [x29, 156]
	mul	w1, w25, w2
	cmp	w0, w1
	blt	.L3168
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR68]
	cmp	w0, 3
	add	x0, x29, 160
	beq	.L3169
	sub	w3, w1, #1
	mov	w2, 0
.L3170:
	cmp	w2, w3
	blt	.L3176
	ldr	x0, [x0, w3, sxtw 3]
	mov	w2, -1
	strb	w2, [x0]
	ldr	x0, [x29, 160]
	bl	sblk_prog_page
	b	.L3175
.L3147:
	adrp	x0, .LANCHOR104
	ldrb	w0, [x0, #:lo12:.LANCHOR104]
	cbnz	w0, .L3151
	add	x0, x24, :lo12:.LANCHOR62
	ldrb	w19, [x22, 9]
	mov	w25, 1
	ldrh	w20, [x0, 314]
	sdiv	w21, w20, w19
	msub	w19, w21, w19, w20
	and	w19, w19, 65535
	b	.L3149
.L3151:
	add	x0, x24, :lo12:.LANCHOR62
	ldrb	w19, [x22, 9]
	mov	w25, 2
	ldrh	w20, [x0, 314]
	sdiv	w21, w20, w19
	msub	w19, w21, w19, w20
	and	w19, w19, 65535
	b	.L3149
.L3154:
	add	w5, w20, w2
	cmp	w5, w3
	beq	.L3181
	sbfiz	x5, x5, 2, 32
	ldr	w0, [x7, x5]
	cmn	w0, #1
	bne	.L3153
	ldrh	w6, [x4, 26]
	cmp	w6, w10
	bcs	.L3136
	mov	w0, w6
	bl	gc_get_src_ppa_from_index
	add	w6, w6, 1
	strh	w6, [x4, 26]
	str	w0, [x7, x5]
.L3153:
	add	w2, w2, 1
	and	w2, w2, 65535
	b	.L3152
.L3168:
	ldr	w0, [x29, 156]
	add	w0, w20, w0
	str	w0, [x29, 144]
	sxtw	x27, w0
	adrp	x0, .LANCHOR69
	ldr	x0, [x0, #:lo12:.LANCHOR69]
	ldrb	w0, [x0, x27]
	cmp	w0, 255
	bne	.L3157
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L3158
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	bl	gc_write_completed
	bl	gc_free_temp_buf
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbz	x0, .L3136
.L3158:
	adrp	x0, .LANCHOR69
	ldrb	w1, [x28, 1]
	adrp	x5, .LANCHOR72
	adrp	x6, .LANCHOR148
	ldr	x0, [x0, #:lo12:.LANCHOR69]
	strb	w1, [x0, x27]
	add	x1, x24, :lo12:.LANCHOR62
	strb	w23, [x28, 61]
	ldrh	w7, [x5, #:lo12:.LANCHOR72]
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
	bne	.L3159
	adrp	x0, .LANCHOR147
	adrp	x4, .LANCHOR73
	stp	x6, x5, [x29, 96]
	ldr	x1, [x0, #:lo12:.LANCHOR147]
	mov	w0, -1
	str	x4, [x29, 144]
	str	w0, [x1, x27, lsl 2]
	ldr	x0, [x28, 8]
	ldrb	w2, [x4, #:lo12:.LANCHOR73]
	mul	w2, w2, w7
	lsl	w2, w2, 2
	bl	ftl_memcpy
	ldp	x6, x5, [x29, 96]
	ldr	x4, [x29, 144]
	ldr	x7, [x28, 8]
	ldrh	w0, [x5, #:lo12:.LANCHOR72]
	ldrb	w1, [x4, #:lo12:.LANCHOR73]
	mul	w0, w0, w1
	ldr	x1, [x6, #:lo12:.LANCHOR148]
	lsl	w2, w0, 2
	add	x0, x7, x0, sxtw 2
	bl	ftl_memcpy
	adrp	x0, .LANCHOR121
	mov	w1, 0
	ldrb	w2, [x0, #:lo12:.LANCHOR121]
	ldr	x0, [x28, 24]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x6, [x28, 24]
	mov	w0, 15555
	ldr	x5, [x29, 104]
	movk	w0, 0xf55f, lsl 16
	ldr	x4, [x29, 144]
	ldrh	w1, [x5, #:lo12:.LANCHOR72]
	str	w0, [x6]
	ldrb	w0, [x4, #:lo12:.LANCHOR73]
	mul	w1, w1, w0
	ldr	x0, [x28, 8]
	lsl	w1, w1, 2
	bl	js_hash
	str	w0, [x6, 4]
	ldr	x0, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x0, 132]
	str	w0, [x6, 8]
.L3157:
	adrp	x0, .LANCHOR69
	ldr	w5, [x29, 156]
	add	x1, x29, 160
	ldr	x4, [x0, #:lo12:.LANCHOR69]
	adrp	x0, .LANCHOR49
	add	x3, x0, :lo12:.LANCHOR49
	ldrb	w2, [x4, x27]
	ubfiz	x0, x2, 6, 8
	add	x0, x3, x0
	add	x3, x3, x2, lsl 6
	str	x0, [x1, w5, sxtw 3]
	mov	w0, 2
	adrp	x5, .LANCHOR149
	strh	w0, [x3, 50]
	ldr	x0, [x29, 128]
	strb	w23, [x3, 61]
	ldrb	w0, [x0, #:lo12:.LANCHOR68]
	cmp	w0, 3
	bne	.L3163
	udiv	w0, w26, w0
	adrp	x6, .LANCHOR105
	ldrh	w6, [x6, #:lo12:.LANCHOR105]
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
	ldr	x3, [x5, #:lo12:.LANCHOR149]
	orr	w0, w1, w0, lsl 24
	str	w0, [x3, x6, lsl 2]
.L3164:
	ldr	x0, [x29, 112]
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3167
	ldr	x0, [x29, 120]
	ldrb	w4, [x4, x27]
	ldr	w1, [x29, 156]
	add	x2, x0, x2, lsl 6
	add	x0, x24, :lo12:.LANCHOR62
	ldrb	w3, [x0, 6]
	ldr	x0, [x2, 24]
	ldrb	w7, [x2, 1]
	ldrh	w6, [x2, 48]
	ldr	w0, [x0, 4]
	str	w0, [sp, 8]
	mov	w0, 3
	udiv	w26, w26, w0
	adrp	x0, .LC210
	add	x0, x0, :lo12:.LC210
	add	w26, w26, w19
	str	w26, [sp]
	ldr	w5, [x2, 40]
	mov	w2, w23
	bl	printf
.L3167:
	ldr	w0, [x29, 152]
	add	w0, w0, 1
	str	w0, [x29, 152]
	b	.L3156
.L3159:
	lsl	x0, x27, 2
	str	x0, [x29, 144]
	ldr	x0, [x6, #:lo12:.LANCHOR148]
	lsl	x1, x27, 2
	ldr	w0, [x0, x1]
	mov	w1, 1
	str	w0, [x28, 40]
	mov	x0, x28
	bl	sblk_read_page
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3161
	adrp	x0, .LANCHOR99
	ldr	w1, [x28, 40]
	ldrh	w4, [x0, #:lo12:.LANCHOR99]
	mov	w0, 21
	sub	w2, w0, w4
	mov	w0, 1
	lsr	w1, w1, w4
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR98
	ldrb	w2, [x1, #:lo12:.LANCHOR98]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3161
	ldr	x0, [x28, 24]
	mov	w1, -1
	str	w1, [x0, 4]
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmp	w0, w1, 4, ne
	bne	.L3161
	adrp	x1, .LANCHOR213
	adrp	x0, .LC0
	mov	w2, 710
	add	x1, x1, :lo12:.LANCHOR213
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3161:
	ldr	x0, [x28, 24]
	adrp	x1, .LANCHOR118
	ldr	w1, [x1, #:lo12:.LANCHOR118]
	ldr	w2, [x0, 4]
	cmp	w2, w1
	bcc	.L3162
	mov	w1, -1
	str	w1, [x0, 4]
.L3162:
	adrp	x1, .LANCHOR147
	lsl	x3, x27, 2
	ldr	w2, [x0, 4]
	ldr	x1, [x1, #:lo12:.LANCHOR147]
	str	w2, [x1, x3]
	ldr	w1, [x28, 40]
	str	w1, [x0, 8]
	b	.L3157
.L3163:
	cmp	w0, 2
	bne	.L3165
	adrp	x0, .LANCHOR104
	adrp	x1, .LANCHOR105
	ldrb	w0, [x0, #:lo12:.LANCHOR104]
	cbnz	w0, .L3166
	ldr	w0, [x29, 156]
	ldrh	w1, [x1, #:lo12:.LANCHOR105]
	add	w0, w19, w0
	add	x0, x22, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w1, w21
.L3224:
	orr	w0, w0, 33554432
	str	w0, [x3, 40]
.L3165:
	ldr	x0, [x29, 120]
	add	x0, x0, x2, lsl 6
	ldrh	w1, [x0, 48]
	ldr	w3, [x0, 40]
	ldr	x0, [x5, #:lo12:.LANCHOR149]
	str	w3, [x0, x1, lsl 2]
	b	.L3164
.L3166:
	add	w0, w19, w26, lsr 1
	ldrh	w1, [x1, #:lo12:.LANCHOR105]
	add	x0, x22, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w1, w21
	and	w1, w26, 1
	add	w0, w0, w1
	b	.L3224
.L3169:
	adrp	x1, .LANCHOR70
	ldrb	w3, [x1, #:lo12:.LANCHOR70]
	ldr	x1, [x29, 160]
	cbz	w3, .L3171
.L3174:
	strb	wzr, [x1, 60]
	b	.L3172
.L3171:
	cmp	w23, 1
	bne	.L3173
	mov	w3, 9
.L3223:
	strb	w3, [x1, 60]
.L3172:
	add	x1, x0, 24
	bl	sblk_xlc_prog_pages
.L3175:
	adrp	x1, .LANCHOR70
	ldrb	w3, [x22, 9]
	ldrb	w1, [x1, #:lo12:.LANCHOR70]
	and	w0, w3, 65535
	cbz	w1, .L3177
	add	w0, w0, w0, lsl 1
.L3178:
	adrp	x1, .LANCHOR97
	add	x24, x24, :lo12:.LANCHOR62
	ldr	x1, [x1, #:lo12:.LANCHOR97]
	ldr	w2, [x1, 52]
	add	w2, w2, w0
	str	w2, [x1, 52]
	ldrh	w1, [x24, 314]
	add	w0, w0, w1
	adrp	x1, .LANCHOR72
	and	w0, w0, 65535
	strh	w0, [x24, 314]
	ldrh	w1, [x1, #:lo12:.LANCHOR72]
	mul	w1, w1, w3
	cmp	w0, w1
	blt	.L3179
	ldr	x0, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR10]
	strh	wzr, [x0, 86]
.L3179:
	bl	gc_write_completed
	b	.L3136
.L3173:
	cmp	w23, 2
	bne	.L3174
	mov	w3, 13
	b	.L3223
.L3176:
	ldr	x4, [x0, w2, sxtw 3]
	add	w2, w2, 1
	ldr	x5, [x0, w2, sxtw 3]
	and	w2, w2, 65535
	ldrb	w5, [x5, 1]
	strb	w5, [x4]
	b	.L3170
.L3177:
	adrp	x1, .LANCHOR104
	ldrb	w2, [x1, #:lo12:.LANCHOR104]
	mov	w1, w0
	ubfiz	w0, w0, 1, 15
	cmp	w2, 0
	csel	w0, w0, w1, ne
	b	.L3178
	.size	gc_do_copy_back, .-gc_do_copy_back
	.section	.text.zftl_do_gc,"ax",@progbits
	.align	2
	.global	zftl_do_gc
	.type	zftl_do_gc, %function
zftl_do_gc:
	sub	sp, sp, #128
	adrp	x1, .LANCHOR94
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x21, x22, [sp, 48]
	stp	x19, x20, [sp, 32]
	adrp	x19, .LANCHOR145
	ldrh	w22, [x1, #:lo12:.LANCHOR94]
	adrp	x1, .LANCHOR90
	stp	x23, x24, [sp, 64]
	adrp	x23, .LANCHOR10
	ldrh	w21, [x1, #:lo12:.LANCHOR90]
	stp	x25, x26, [sp, 80]
	ldrb	w1, [x19, #:lo12:.LANCHOR145]
	add	w21, w22, w21
	stp	x27, x28, [sp, 96]
	ldr	x24, [x23, #:lo12:.LANCHOR10]
	cmp	w1, 6
	bhi	.L3330
	mov	w26, w0
	and	w21, w21, 65535
	adrp	x0, .L3228
	add	x0, x0, :lo12:.L3228
	ldrh	w0, [x0,w1,uxtw #1]
	adr	x1, .Lrtx3228
	add	x0, x1, w0, sxth #2
	br	x0
.Lrtx3228:
	.section	.rodata.zftl_do_gc,"a",@progbits
	.align	0
	.align	2
.L3228:
	.2byte	(.L3227 - .Lrtx3228) / 4
	.2byte	(.L3229 - .Lrtx3228) / 4
	.2byte	(.L3230 - .Lrtx3228) / 4
	.2byte	(.L3231 - .Lrtx3228) / 4
	.2byte	(.L3232 - .Lrtx3228) / 4
	.2byte	(.L3233 - .Lrtx3228) / 4
	.2byte	(.L3234 - .Lrtx3228) / 4
	.section	.text.zftl_do_gc
.L3233:
	adrp	x20, .LANCHOR62
	add	x24, x20, :lo12:.LANCHOR62
	mov	w22, 0
.L3235:
	bl	gc_check_data_one_wl
	cbz	w0, .L3326
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	add	x20, x20, :lo12:.LANCHOR62
	strh	wzr, [x20, 56]
	ldrh	w0, [x0, 80]
	bl	ftl_free_sblk
	adrp	x2, .LANCHOR97
	ldr	x1, [x23, #:lo12:.LANCHOR10]
	mov	w0, -1
	ldr	x2, [x2, #:lo12:.LANCHOR97]
	strh	w0, [x1, 80]
	strh	w0, [x2, 126]
	strh	w0, [x1, 130]
	ldr	x0, [x20, 8]
	bl	buf_free
	strb	wzr, [x19, #:lo12:.LANCHOR145]
	str	xzr, [x20, 8]
	b	.L3394
.L3227:
	adrp	x0, .LANCHOR92
	adrp	x28, .LANCHOR85
	adrp	x27, .LANCHOR83
	ldrh	w1, [x24, 80]
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	ldrh	w25, [x28, #:lo12:.LANCHOR85]
	add	w22, w22, w0
	ldrh	w0, [x27, #:lo12:.LANCHOR83]
	and	w22, w22, 65535
	add	w25, w25, w0
	mov	w0, 65535
	and	w25, w25, 65535
	cmp	w1, w0
	beq	.L3236
	cbnz	w26, .L3237
	adrp	x0, .LANCHOR74
	ldrh	w0, [x0, #:lo12:.LANCHOR74]
	cmp	w21, w0, lsl 1
	blt	.L3237
.L3330:
	mov	w20, 16
	b	.L3225
.L3237:
	adrp	x5, .LANCHOR82
	mov	w1, 5
	adrp	x26, .LANCHOR71
	ldrh	w0, [x5, #:lo12:.LANCHOR82]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x5, #:lo12:.LANCHOR82]
	bl	zftl_get_gc_node
	and	w3, w0, 65535
	mov	w1, 65535
	cmp	w3, w1
	beq	.L3238
	adrp	x4, .LANCHOR9
	ubfiz	x3, x3, 1, 16
	adrp	x1, .LANCHOR146
	mov	x20, x1
	ldr	x4, [x4, #:lo12:.LANCHOR9]
	ldr	w2, [x1, #:lo12:.LANCHOR146]
	add	w2, w2, 1
	str	w2, [x1, #:lo12:.LANCHOR146]
	ldrh	w3, [x4, x3]
	adrp	x4, .LANCHOR80
	ldrh	w4, [x4, #:lo12:.LANCHOR80]
	cmp	w4, w3
	bcs	.L3239
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	cmp	w2, w1, lsr 4
	bls	.L3238
	adrp	x1, .LANCHOR86
	ldrh	w1, [x1, #:lo12:.LANCHOR86]
	cmp	w1, w3
	bls	.L3238
.L3239:
	ldrb	w2, [x26, #:lo12:.LANCHOR71]
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L3240
	mov	w0, 1
	str	wzr, [x20, #:lo12:.LANCHOR146]
	strb	w0, [x19, #:lo12:.LANCHOR145]
	b	.L3330
.L3238:
	strh	wzr, [x5, #:lo12:.LANCHOR82]
.L3240:
	cmp	w22, 15
	bls	.L3332
	adrp	x0, .LANCHOR87
	ldrh	w1, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR88
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w1, w0
	bhi	.L3332
	cmp	w25, 0
	cset	w20, eq
	add	w20, w20, 1
.L3241:
	adrp	x0, .LANCHOR14
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 8, .L3242
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	mov	w4, w22
	ldrb	w2, [x26, #:lo12:.LANCHOR71]
	mov	w3, w21
	mov	w1, 1848
	ldrh	w7, [x0, 122]
	ldrh	w6, [x0, 120]
	ldrh	w5, [x0, 124]
	ldrh	w0, [x24, 80]
	str	w0, [sp]
	adrp	x0, .LC211
	add	x0, x0, :lo12:.LC211
	bl	printf
.L3242:
	ldrb	w0, [x26, #:lo12:.LANCHOR71]
	mov	w2, 1
	mov	w1, w20
	bl	gc_search_src_blk
	cmp	w0, 0
	ble	.L3243
.L3244:
	mov	w0, 1
.L3396:
	strb	w0, [x19, #:lo12:.LANCHOR145]
	b	.L3330
.L3332:
	mov	w20, 2
	b	.L3241
.L3243:
	ldrb	w0, [x26, #:lo12:.LANCHOR71]
	mov	w2, 1
	mov	w1, 3
	bl	gc_search_src_blk
	cmp	w0, 0
	bgt	.L3244
	b	.L3330
.L3236:
	cmp	w26, 1
	bne	.L3246
	bl	gc_scan_static_data
	adrp	x24, .LANCHOR71
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	ldrh	w0, [x0, 122]
	cbz	w0, .L3247
.L3248:
	mov	w0, 1
	strb	w0, [x24, #:lo12:.LANCHOR71]
	b	.L3396
.L3247:
	bl	gc_static_wearleveling
	mov	w20, w0
	cbnz	w0, .L3248
	cbnz	w22, .L3249
.L3253:
	mov	w20, 16
.L3250:
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	adrp	x3, .LANCHOR71
	mov	w1, 1
	mov	x23, x3
	strb	w1, [x3, #:lo12:.LANCHOR71]
	ldrh	w5, [x0, 124]
	cbz	w5, .L3258
	strb	w1, [x19, #:lo12:.LANCHOR145]
	adrp	x1, .LANCHOR14
	strb	wzr, [x3, #:lo12:.LANCHOR71]
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 8, .L3225
	ldrh	w7, [x0, 122]
	mov	w4, w22
	ldrh	w6, [x0, 120]
	mov	w3, w21
	adrp	x0, .LC212
	mov	w2, 0
	mov	w1, 1946
	add	x0, x0, :lo12:.LC212
	bl	printf
.L3225:
	mov	w0, w20
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 128
	ret
.L3249:
	cmp	w21, w25
	adrp	x1, .LANCHOR87
	adrp	x2, .LANCHOR84
	bcs	.L3251
	ldrh	w0, [x2, #:lo12:.LANCHOR84]
	cmp	w21, w0, lsl 1
	blt	.L3252
.L3251:
	ldrh	w2, [x2, #:lo12:.LANCHOR84]
	add	w0, w21, w25
	cmp	w0, w2, lsl 1
	blt	.L3252
	adrp	x0, .LANCHOR88
	ldrh	w2, [x1, #:lo12:.LANCHOR87]
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w2, w0
	bcc	.L3253
.L3252:
	adrp	x5, .LANCHOR146
	adrp	x2, .LANCHOR6
	mov	w6, 1
	strb	w6, [x24, #:lo12:.LANCHOR71]
	ldr	w0, [x5, #:lo12:.LANCHOR146]
	ldrh	w2, [x2, #:lo12:.LANCHOR6]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR146]
	cmp	w0, w2, lsr 5
	bls	.L3254
	ldrh	w0, [x1, #:lo12:.LANCHOR87]
	cmp	w0, w22
	bls	.L3254
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w0, w0, 65535
	mov	w1, 65535
	cmp	w0, w1
	beq	.L3253
	adrp	x1, .LANCHOR9
	ubfiz	x0, x0, 1, 16
	adrp	x2, .LANCHOR73
	ldr	x1, [x1, #:lo12:.LANCHOR9]
	ldrb	w2, [x2, #:lo12:.LANCHOR73]
	ldrh	w1, [x1, x0]
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	mul	w0, w0, w2
	cmp	w1, w0
	bgt	.L3253
	mov	w0, w6
	str	wzr, [x5, #:lo12:.LANCHOR146]
	mov	w2, 4
	mov	w1, 2
.L3384:
	bl	gc_search_src_blk
	and	w0, w0, 65535
	cbz	w0, .L3253
	b	.L3244
.L3254:
	adrp	x0, .LANCHOR88
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w1, w0
	bcc	.L3256
	mov	w2, 1
	mov	w1, 2
	mov	w0, w2
	b	.L3384
.L3256:
	ldrh	w0, [x28, #:lo12:.LANCHOR85]
	cbnz	w0, .L3257
	ldrh	w0, [x27, #:lo12:.LANCHOR83]
	cmp	w0, 8
	bls	.L3250
.L3257:
	mov	w1, 1
	mov	w2, 4
	mov	w0, w1
	b	.L3384
.L3246:
	adrp	x0, .LANCHOR74
	ldrh	w0, [x0, #:lo12:.LANCHOR74]
	cmp	w0, w21
	bcc	.L3330
	b	.L3253
.L3258:
	adrp	x2, .LANCHOR74
	mov	x24, x2
	ldrh	w4, [x2, #:lo12:.LANCHOR74]
	cmp	w21, w4
	bcs	.L3259
	cbz	w22, .L3260
	cmp	w22, 16
	bls	.L3261
	adrp	x0, .LANCHOR87
	ldrh	w2, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR88
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w2, w0
	bhi	.L3261
	str	x3, [x29, 104]
	mov	w2, 4
	mov	w0, w1
	bl	gc_search_src_blk
	ldr	x3, [x29, 104]
	tst	w0, 65535
	bne	.L3262
	ldrb	w0, [x3, #:lo12:.LANCHOR71]
	mov	w2, 4
	mov	w1, 3
.L3386:
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L3263:
	cbnz	w0, .L3265
	b	.L3225
.L3262:
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w3, w0, 65535
	mov	w1, 65535
	cmp	w3, w1
	beq	.L3265
	adrp	x4, .LANCHOR9
	ubfiz	x3, x3, 1, 16
	adrp	x1, .LANCHOR146
	mov	x21, x1
	ldr	x4, [x4, #:lo12:.LANCHOR9]
	ldr	w2, [x1, #:lo12:.LANCHOR146]
	add	w2, w2, 1
	str	w2, [x1, #:lo12:.LANCHOR146]
	ldrh	w3, [x4, x3]
	adrp	x4, .LANCHOR80
	ldrh	w4, [x4, #:lo12:.LANCHOR80]
	cmp	w4, w3
	bcs	.L3266
	adrp	x1, .LANCHOR6
	ldrh	w1, [x1, #:lo12:.LANCHOR6]
	cmp	w2, w1, lsr 4
	bls	.L3265
	adrp	x1, .LANCHOR86
	ldrh	w1, [x1, #:lo12:.LANCHOR86]
	cmp	w1, w3
	bls	.L3265
.L3266:
	ldrb	w2, [x23, #:lo12:.LANCHOR71]
	mov	w1, 0
	bl	gc_add_sblk
	str	wzr, [x21, #:lo12:.LANCHOR146]
	adrp	x0, .LANCHOR116
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR116]
.L3265:
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR145]
	b	.L3225
.L3261:
	mov	w2, 1
	mov	w0, w2
	mov	w1, 2
.L3393:
	bl	gc_search_src_blk
	tst	w0, 65535
	bne	.L3265
	mov	w2, 2
.L3389:
	mov	w1, 3
	ldrb	w0, [x23, #:lo12:.LANCHOR71]
	b	.L3386
.L3260:
	adrp	x1, .LANCHOR14
	strb	wzr, [x3, #:lo12:.LANCHOR71]
	ldr	w1, [x1, #:lo12:.LANCHOR14]
	tbz	x1, 8, .L3268
	ldrh	w7, [x0, 122]
	mov	w5, 0
	ldrh	w6, [x0, 120]
	mov	w4, 0
	adrp	x0, .LC212
	mov	w3, w21
	mov	w2, 0
	mov	w1, 1976
	add	x0, x0, :lo12:.LC212
	bl	printf
.L3268:
	cmp	w21, 16
	bls	.L3269
	mov	w2, 4
	b	.L3389
.L3269:
	mov	w2, 1
	ldrb	w0, [x23, #:lo12:.LANCHOR71]
	mov	w1, w2
	b	.L3393
.L3259:
	cmp	w26, 1
	bne	.L3225
	cmp	w21, w4, lsl 1
	bge	.L3270
	cmp	w25, w22, lsr 1
	bcs	.L3271
	adrp	x0, .LANCHOR87
	ldrh	w1, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR88
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w1, w0
	bcs	.L3271
	adrp	x0, .LANCHOR84
	ldrh	w0, [x0, #:lo12:.LANCHOR84]
	lsr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR74]
	b	.L3225
.L3271:
	mov	w1, 5
	mov	w0, 0
	bl	zftl_get_gc_node
	and	w26, w0, 65535
	mov	w1, 65535
	mov	w3, w26
	cmp	w26, w1
	bne	.L3272
.L3277:
	cmp	w22, 1
	bhi	.L3273
.L3274:
	cmp	w21, w25
	adrp	x21, .LANCHOR84
	bcs	.L3281
	strb	wzr, [x23, #:lo12:.LANCHOR71]
	mov	w0, 4
	bl	zftl_get_gc_node.part.9
	and	w0, w0, 65535
	mov	w1, 65535
	cmp	w0, w1
	beq	.L3281
	adrp	x1, .LANCHOR9
	ubfiz	x0, x0, 1, 16
	adrp	x2, .LANCHOR73
	ldr	x1, [x1, #:lo12:.LANCHOR9]
	ldrb	w2, [x2, #:lo12:.LANCHOR73]
	ldrh	w1, [x1, x0]
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	mul	w0, w0, w2
	cmp	w1, w0, lsr 1
	ble	.L3283
.L3281:
	ldrh	w0, [x21, #:lo12:.LANCHOR84]
	lsr	w0, w0, 2
	strh	w0, [x24, #:lo12:.LANCHOR74]
	b	.L3225
.L3272:
	adrp	x2, .LANCHOR146
	adrp	x4, .LANCHOR6
	uxtw	x26, w26
	ldr	w1, [x2, #:lo12:.LANCHOR146]
	ldrh	w4, [x4, #:lo12:.LANCHOR6]
	add	w1, w1, 1
	str	w1, [x2, #:lo12:.LANCHOR146]
	cmp	w1, w4, lsr 4
	adrp	x4, .LANCHOR9
	bls	.L3275
	ldr	x1, [x4, #:lo12:.LANCHOR9]
	str	wzr, [x2, #:lo12:.LANCHOR146]
	ldrh	w2, [x1, x26, lsl 1]
	adrp	x1, .LANCHOR86
	ldrh	w1, [x1, #:lo12:.LANCHOR86]
	cmp	w2, w1
	bcs	.L3275
	str	x4, [x29, 96]
	mov	w2, 1
	str	w3, [x29, 104]
	mov	w1, 0
	bl	gc_add_sblk
	ldr	w3, [x29, 104]
	ldr	x4, [x29, 96]
	cbnz	w0, .L3265
.L3275:
	ldr	x0, [x4, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, x26, lsl 1]
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w1, w0, lsr 1
	bhi	.L3276
	mov	w2, 0
	mov	w1, 1
	mov	w0, w3
	bl	gc_add_sblk
	b	.L3265
.L3276:
	ldrh	w2, [x27, #:lo12:.LANCHOR83]
	ldrh	w0, [x28, #:lo12:.LANCHOR85]
	add	w0, w0, w2
	adrp	x2, .LANCHOR84
	ldrh	w2, [x2, #:lo12:.LANCHOR84]
	cmp	w0, w2, lsl 1
	ble	.L3277
	adrp	x0, .LANCHOR86
	ldrh	w0, [x0, #:lo12:.LANCHOR86]
	cmp	w0, w1
	bcc	.L3274
	b	.L3277
.L3273:
	mov	w1, 1
	strb	w1, [x23, #:lo12:.LANCHOR71]
	cmp	w22, 16
	bls	.L3278
	adrp	x0, .LANCHOR87
	ldrh	w2, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR88
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w2, w0
	bhi	.L3278
	mov	w2, 4
	mov	w0, w1
	bl	gc_search_src_blk
	ands	w0, w0, 65535
	bne	.L3279
	mov	w2, 4
.L3385:
	ldrb	w0, [x23, #:lo12:.LANCHOR71]
	mov	w1, 3
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L3279:
	adrp	x1, .LANCHOR84
	cmp	w21, w25, lsr 1
	ldrh	w1, [x1, #:lo12:.LANCHOR84]
	bls	.L3387
	lsr	w1, w1, 2
.L3388:
	strh	w1, [x24, #:lo12:.LANCHOR74]
	b	.L3263
.L3278:
	mov	w2, 1
	mov	w1, 2
	mov	w0, w2
	bl	gc_search_src_blk
	ands	w0, w0, 65535
	bne	.L3279
	mov	w2, 2
	b	.L3385
.L3283:
	mov	w1, 3
	mov	w2, 4
	mov	w0, 0
	bl	gc_search_src_blk
	ldrh	w1, [x21, #:lo12:.LANCHOR84]
	and	w0, w0, 65535
.L3387:
	lsr	w1, w1, 1
	b	.L3388
.L3270:
	adrp	x0, .LANCHOR84
	mov	w20, 0
	ldrh	w0, [x0, #:lo12:.LANCHOR84]
	lsr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR74]
	b	.L3225
.L3229:
	adrp	x7, .LANCHOR62
	mov	w0, 65535
	ldrh	w1, [x7, #:lo12:.LANCHOR62]
	cmp	w1, w0
	bne	.L3284
	bl	gc_get_src_blk
	strh	w0, [x7, #:lo12:.LANCHOR62]
.L3284:
	ldrh	w3, [x7, #:lo12:.LANCHOR62]
	mov	w0, 65535
	add	x1, x7, :lo12:.LANCHOR62
	cmp	w3, w0
	beq	.L3395
	adrp	x0, .LANCHOR7
	ldrh	w5, [x1, 56]
	uxtw	x4, w3
	ldr	x2, [x0, #:lo12:.LANCHOR7]
	add	x2, x2, x4, lsl 2
	cbz	w5, .L3286
	add	x1, x1, 58
	mov	w0, 0
.L3288:
	ldrh	w6, [x1], 2
	cmp	w6, w3
	bne	.L3287
.L3292:
	adrp	x0, .LANCHOR62
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR62]
	b	.L3330
.L3287:
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w5, w0
	bne	.L3288
.L3286:
	ldrb	w0, [x2, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L3289
	tst	w0, 192
	bne	.L3290
.L3289:
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, x4, lsl 1]
	cbz	w0, .L3292
	mov	w2, 2209
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3292
.L3290:
	mov	w0, 2
	b	.L3396
.L3230:
	bl	gc_scan_src_blk
	cmn	w0, #1
	bne	.L3293
	mov	w0, 3
	b	.L3396
.L3293:
	adrp	x20, .LANCHOR62
	mov	w2, 65535
	add	x0, x20, :lo12:.LANCHOR62
	ldrh	w1, [x20, #:lo12:.LANCHOR62]
	cmp	w1, w2
	beq	.L3244
	ldrh	w2, [x0, 24]
	cbz	w2, .L3294
	mov	w1, 4
	strh	wzr, [x0, 26]
	strb	w1, [x19, #:lo12:.LANCHOR145]
	b	.L3330
.L3294:
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR145]
	adrp	x0, .LANCHOR9
	ubfiz	x1, x1, 1, 16
	mov	x19, x0
	ldr	x2, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x2, x1]
	cbz	w1, .L3295
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	mov	w2, 2237
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3295:
	ldrh	w0, [x20, #:lo12:.LANCHOR62]
	add	x21, x20, :lo12:.LANCHOR62
	bl	ftl_free_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR9]
	ldrh	w1, [x20, #:lo12:.LANCHOR62]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x21, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w0, 8
	bhi	.L3296
	strh	w0, [x21, 30]
	b	.L3292
.L3296:
	strh	wzr, [x21, 30]
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	b	.L3292
.L3231:
	adrp	x20, .LANCHOR62
	adrp	x23, .LANCHOR80
	add	x22, x20, :lo12:.LANCHOR62
	add	x23, x23, :lo12:.LANCHOR80
.L3365:
	bl	gc_scan_src_blk_one_page
	ldrh	w1, [x22, 2]
	ldrh	w0, [x23]
	cmp	w1, w0
	bcs	.L3298
	cmp	w21, 7
	bls	.L3365
	b	.L3330
.L3298:
	ldrh	w3, [x22, 24]
	adrp	x0, .LANCHOR14
	cbz	w3, .L3299
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	mov	w1, 4
	strh	wzr, [x22, 26]
	strb	w1, [x19, #:lo12:.LANCHOR145]
	adrp	x19, .LANCHOR9
	tbz	x0, 8, .L3300
	ldrh	w1, [x22]
	ldr	x2, [x19, #:lo12:.LANCHOR9]
	ubfiz	x0, x1, 1, 16
	ldrh	w2, [x2, x0]
	adrp	x0, .LC213
	add	x0, x0, :lo12:.LC213
	bl	printf
.L3300:
	ldrh	w2, [x20, #:lo12:.LANCHOR62]
	add	x0, x20, :lo12:.LANCHOR62
	ldr	x1, [x19, #:lo12:.LANCHOR9]
	ldrh	w0, [x0, 24]
	ldrh	w1, [x1, x2, lsl 1]
	cmp	w1, w0
	beq	.L3301
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	mov	w2, 2271
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3301:
	add	x0, x20, :lo12:.LANCHOR62
	ldrh	w1, [x20, #:lo12:.LANCHOR62]
	ldrh	w2, [x0, 24]
	ldr	x0, [x19, #:lo12:.LANCHOR9]
	strh	w2, [x0, x1, lsl 1]
	b	.L3330
.L3299:
	adrp	x2, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	ldrh	w1, [x22]
	ldr	x21, [x2, #:lo12:.LANCHOR7]
	mov	w2, 1
	strb	w2, [x19, #:lo12:.LANCHOR145]
	add	x21, x21, x1, uxth 2
	tbz	x0, 8, .L3302
	ldrb	w2, [x21, 2]
	adrp	x0, .LC214
	add	x0, x0, :lo12:.LC214
	ubfx	x2, x2, 5, 3
	bl	printf
.L3302:
	ldrb	w0, [x21, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L3303
	tst	w0, 192
	bne	.L3304
.L3303:
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	mov	w2, 2281
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3304:
	ldrh	w0, [x20, #:lo12:.LANCHOR62]
	add	x19, x20, :lo12:.LANCHOR62
	bl	ftl_free_sblk
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR62]
	ldrh	w0, [x19, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w0, 8
	bhi	.L3305
	strh	w0, [x19, 30]
	b	.L3330
.L3305:
	strh	wzr, [x19, 30]
.L3394:
	bl	flt_sys_flush
	b	.L3330
.L3232:
	ldrh	w1, [x24, 80]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L3306
	adrp	x0, .LANCHOR71
	ldrb	w22, [x0, #:lo12:.LANCHOR71]
	cmp	w22, 1
	bne	.L3306
	bl	ftl_flush
	adrp	x0, .LANCHOR62
	add	x1, x0, :lo12:.LANCHOR62
	mov	x20, x0
	ldrh	w1, [x1, 318]
	cbz	w1, .L3307
	mov	w0, w22
	mov	w1, 5
.L3391:
	bl	zftl_gc_get_free_sblk
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	beq	.L3309
	adrp	x0, .LANCHOR7
	ldr	x21, [x0, #:lo12:.LANCHOR7]
	add	x21, x21, x19, uxth 2
	ldrb	w0, [x21, 2]
	tst	w0, 224
	beq	.L3310
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	mov	w2, 2310
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3310:
	ldrb	w0, [x21, 2]
	mov	w1, 5
	bfi	w0, w1, 5, 3
	orr	w0, w0, 16
	strb	w0, [x21, 2]
.L3329:
	mov	w1, 1
	mov	w0, w19
	bl	ftl_erase_sblk
	adrp	x22, .LANCHOR72
	mov	w0, 5
	strb	w0, [x24, 84]
	add	x1, x24, 96
	mov	w0, w19
	bl	ftl_get_blk_list_in_sblk
	and	w0, w0, 255
	adrp	x1, .LANCHOR80
	adrp	x21, .LANCHOR73
	strb	w0, [x24, 89]
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	ldrh	w2, [x22, #:lo12:.LANCHOR72]
	strh	w19, [x24, 80]
	strh	wzr, [x24, 82]
	mul	w0, w0, w1
	strb	wzr, [x24, 85]
	strh	w0, [x24, 86]
	mov	w1, 255
	ldrb	w0, [x21, #:lo12:.LANCHOR73]
	strh	wzr, [x24, 90]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR147
	ldr	x0, [x0, #:lo12:.LANCHOR147]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x21, #:lo12:.LANCHOR73]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR72]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR148
	ldr	x0, [x0, #:lo12:.LANCHOR148]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x21, #:lo12:.LANCHOR73]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR72]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR69
	ldr	x0, [x0, #:lo12:.LANCHOR69]
	bl	ftl_memset
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	mov	w1, -1
	str	w19, [x0, 132]
	strh	w1, [x0, 128]
	strh	w1, [x0, 130]
	bl	pm_flush
	bl	ftl_ext_info_flush
	adrp	x0, .LANCHOR97
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	strh	w19, [x0, 126]
	add	x0, x20, :lo12:.LANCHOR62
	str	w1, [x0, 324]
	strh	wzr, [x0, 314]
	strh	wzr, [x0, 56]
	strh	wzr, [x0, 316]
	strh	wzr, [x0, 320]
	mov	w0, 0
	bl	ftl_info_flush
	b	.L3330
.L3307:
	mov	w1, 5
	mov	w0, 0
	b	.L3391
.L3306:
	cmp	w26, 1
	mov	w22, 4
	csinc	w22, w22, wzr, eq
	cmp	w21, 15
	mov	w0, w22
	add	w22, w22, 4
	adrp	x25, .LANCHOR71
	adrp	x21, .LANCHOR62
	csel	w22, w22, w0, ls
	add	x25, x25, :lo12:.LANCHOR71
	add	x20, x21, :lo12:.LANCHOR62
	add	x26, x24, 80
.L3313:
	sub	w22, w22, #1
	and	w22, w22, 255
	cmp	w22, 255
	beq	.L3330
	bl	gc_do_copy_back
	ldrb	w0, [x25]
	cbnz	w0, .L3314
	adrp	x0, .LANCHOR51
	ldrb	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, 3
	bhi	.L3315
	bl	ftl_write_commit
.L3315:
	ldrh	w1, [x20, 26]
	ldrh	w0, [x20, 24]
	cmp	w1, w0
	bcc	.L3313
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR145]
	bl	ftl_write_commit
	bl	ftl_flush
	adrp	x0, .LANCHOR9
	ldrh	w2, [x20]
	mov	x19, x0
	ldr	x1, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x1, x2, lsl 1]
	cbz	w1, .L3317
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	mov	w2, 2385
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3317:
	ldrh	w0, [x21, #:lo12:.LANCHOR62]
	ldr	x2, [x19, #:lo12:.LANCHOR9]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbnz	w1, .L3318
	bl	ftl_free_sblk
	b	.L3292
.L3318:
	mov	w2, 1
	mov	w1, 0
	bl	gc_add_sblk
	b	.L3292
.L3314:
	ldrh	w0, [x20, 320]
	cbz	w0, .L3319
	ldr	w0, [x20, 324]
	strh	wzr, [x20, 320]
	cmn	w0, #1
	beq	.L3320
	bl	ftl_mask_bad_block
.L3320:
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	add	x20, x21, :lo12:.LANCHOR62
	strh	wzr, [x20, 56]
	ldrh	w0, [x0, 80]
	str	wzr, [x20, 324]
	bl	ftl_free_sblk
	adrp	x2, .LANCHOR97
	ldr	x1, [x23, #:lo12:.LANCHOR10]
	mov	w0, -1
	ldr	x2, [x2, #:lo12:.LANCHOR97]
	strh	w0, [x1, 80]
	strh	w0, [x2, 126]
	strh	w0, [x1, 130]
	ldr	x0, [x20, 8]
	cbz	x0, .L3321
	bl	buf_free
.L3321:
	add	x21, x21, :lo12:.LANCHOR62
	str	xzr, [x21, 8]
	bl	flt_sys_flush
	mov	w2, 2421
	strb	wzr, [x19, #:lo12:.LANCHOR145]
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3330
.L3319:
	ldrh	w0, [x26, 6]
	ldrh	w1, [x20, 26]
	cmp	w0, 1
	ldrh	w0, [x20, 24]
	bls	.L3322
	cmp	w1, w0
	bcc	.L3313
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR145]
	ldrh	w0, [x20, 56]
	add	w1, w0, 1
	strh	w1, [x20, 56]
	add	x0, x20, x0, sxtw 1
	ldrh	w1, [x20]
	strh	w1, [x0, 58]
	mov	w0, -1
	strh	w0, [x20]
	b	.L3330
.L3322:
	mov	w2, 5
	strb	w2, [x19, #:lo12:.LANCHOR145]
	cmp	w1, w0
	bcc	.L3323
	ldrh	w0, [x20, 56]
	add	w1, w0, 1
	strh	w1, [x20, 56]
	add	x0, x20, x0, sxtw 1
	ldrh	w1, [x20]
	strh	w1, [x0, 58]
	mov	w0, -1
	strh	w0, [x20]
.L3323:
	bl	ftl_flush
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	x0, [x23, #:lo12:.LANCHOR10]
	ldrh	w1, [x24, 80]
	strh	w1, [x0, 128]
	bl	pm_flush
	bl	ftl_ext_info_flush
	add	x0, x21, :lo12:.LANCHOR62
	adrp	x1, .LANCHOR80
	adrp	x2, .LANCHOR68
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	ldrb	w2, [x2, #:lo12:.LANCHOR68]
	strh	wzr, [x0, 16]
	strh	w1, [x0, 18]
	cmp	w2, 2
	strh	w2, [x0, 20]
	bne	.L3324
	ubfiz	w1, w1, 1, 15
	strh	w1, [x0, 18]
	mov	w1, 1
	strh	w1, [x0, 20]
.L3324:
	add	x21, x21, :lo12:.LANCHOR62
	strh	wzr, [x21, 22]
	b	.L3330
.L3326:
	ldrh	w1, [x24, 16]
	ldrh	w0, [x24, 18]
	cmp	w1, w0
	bcc	.L3327
	mov	w0, 6
	strb	w0, [x19, #:lo12:.LANCHOR145]
	ldr	x0, [x24, 8]
	bl	buf_free
	str	xzr, [x24, 8]
	b	.L3330
.L3327:
	cmp	w21, 15
	bls	.L3235
	cmp	w26, 1
	bne	.L3330
	add	w22, w22, 1
	and	w22, w22, 255
	cmp	w22, 4
	bls	.L3235
	b	.L3330
.L3234:
	bl	gc_update_l2p_map_new
	mov	w20, -1
	bl	gc_free_src_blk
	bl	ftl_flush
	bl	pm_flush
	strh	w20, [x24, 80]
	bl	ftl_ext_info_flush
	adrp	x0, .LANCHOR97
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	strh	w20, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
.L3395:
	strb	wzr, [x19, #:lo12:.LANCHOR145]
	b	.L3330
.L3309:
	mov	w2, 2316
	adrp	x1, .LANCHOR215
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3329
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
	mov	x24, x3
	stp	x25, x26, [sp, 64]
	tbz	x0, 12, .L3398
	mov	w3, w2
	adrp	x0, .LC215
	mov	w2, w1
	add	x0, x0, :lo12:.LC215
	mov	w1, w27
	bl	printf
.L3398:
	cbnz	w27, .L3399
	adrp	x0, .LANCHOR58
	mov	w27, 24576
	ldr	w0, [x0, #:lo12:.LANCHOR58]
.L3400:
	add	w1, w19, w20
	cmp	w0, w1
	bcc	.L3414
	adrp	x23, .LANCHOR121
	add	w27, w27, w19
	sub	w19, w20, #1
	adrp	x25, .LANCHOR97
	ldrb	w0, [x23, #:lo12:.LANCHOR121]
	add	w19, w19, w27
	add	x23, x23, :lo12:.LANCHOR121
	udiv	w22, w27, w0
	udiv	w19, w19, w0
	add	w0, w27, w20
	str	w0, [x29, 108]
	mov	w26, w22
	sub	w21, w19, w22
	add	w21, w21, 1
.L3402:
	cbnz	w21, .L3410
	adrp	x20, .LANCHOR90
	adrp	x19, .LANCHOR94
	add	x20, x20, :lo12:.LANCHOR90
	add	x19, x19, :lo12:.LANCHOR94
	bl	ftl_write_commit
	bl	ftl_flush
	mov	w1, 1
	mov	w0, 0
	bl	zftl_do_gc
.L3411:
	ldrh	w0, [x20]
	ldrh	w1, [x19]
	add	w0, w0, w1
	cmp	w0, 7
	ble	.L3412
	mov	w0, 0
.L3397:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L3399:
	cmp	w27, 3
	bhi	.L3414
	lsl	w27, w27, 13
	mov	w0, 8192
	b	.L3400
.L3410:
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L3403
	bl	ftl_write_commit
	b	.L3402
.L3403:
	ldrb	w3, [x23]
	cmp	w26, w22
	strb	wzr, [x0, 57]
	ccmp	w26, w19, 4, ne
	strb	w3, [x0, 56]
	bne	.L3406
	cmp	w26, w22
	bne	.L3407
	udiv	w0, w27, w3
	msub	w0, w0, w3, w27
	and	w0, w0, 255
	strb	w0, [x28, 57]
	sub	w3, w3, w0
	and	w3, w3, 255
	cmp	w20, w3
	csel	w3, w20, w3, cc
.L3419:
	strb	w3, [x28, 56]
.L3406:
	ldr	x3, [x28, 8]
	mov	x1, x24
	ldrb	w0, [x28, 57]
	sub	w21, w21, #1
	ldrb	w2, [x28, 56]
	ubfiz	x0, x0, 9, 8
	lsl	w2, w2, 9
	add	x0, x3, x0
	bl	ftl_memcpy
	ldr	x1, [x25, #:lo12:.LANCHOR97]
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
	add	x24, x24, x0
	b	.L3402
.L3407:
	ldr	w0, [x29, 108]
	msub	w3, w3, w26, w0
	b	.L3419
.L3412:
	mov	w1, 1
	mov	w0, 0
	bl	zftl_do_gc
	b	.L3411
.L3414:
	mov	w0, -1
	b	.L3397
	.size	zftl_write, .-zftl_write
	.section	.text.zftl_vendor_write,"ax",@progbits
	.align	2
	.global	zftl_vendor_write
	.type	zftl_vendor_write, %function
zftl_vendor_write:
	mov	x3, x2
	mov	w2, w1
	add	w1, w0, 512
	mov	w0, 2
	b	zftl_write
	.size	zftl_vendor_write, .-zftl_vendor_write
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
	bne	.L3425
	mov	w3, w2
	mov	w0, 0
	mov	x2, x20
	bl	idb_write_data
.L3425:
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
	adrp	x2, .LANCHOR58
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	ldr	w2, [x2, #:lo12:.LANCHOR58]
	add	w1, w0, w1
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w2, w1
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	bcc	.L3448
	adrp	x24, .LANCHOR216
	add	w22, w0, 24576
	adrp	x0, .LANCHOR14
	str	x0, [x29, 104]
	ldr	w1, [x24, #:lo12:.LANCHOR216]
	ldr	w2, [x0, #:lo12:.LANCHOR14]
	add	w1, w19, w1
	str	w1, [x24, #:lo12:.LANCHOR216]
	tbz	x2, 12, .L3429
	adrp	x0, .LC216
	mov	w4, 0
	mov	w3, w19
	mov	w2, w22
	add	x0, x0, :lo12:.LC216
	bl	printf
.L3429:
	adrp	x23, .LANCHOR97
	adrp	x26, .LANCHOR121
	ldr	x0, [x23, #:lo12:.LANCHOR97]
	ldr	w27, [x0, 8]
	add	w1, w27, 1
	str	w1, [x0, 8]
	bl	ftl_write_commit
	bl	ftl_flush
	ldrb	w21, [x26, #:lo12:.LANCHOR121]
	udiv	w20, w22, w21
	msub	w25, w20, w21, w22
	cbz	w25, .L3430
	sub	w21, w21, w25
	mov	w0, w20
	cmp	w21, w19
	csel	w21, w21, w19, ls
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	bne	.L3431
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
.L3431:
	ldr	w0, [x29, 120]
	and	w28, w21, 65535
	cmn	w0, #1
	beq	.L3433
	mov	w0, 0
	bl	buf_alloc
	mov	x3, x0
	cbz	x0, .L3433
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
	ldr	x1, [x23, #:lo12:.LANCHOR97]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L3433:
	add	w20, w20, 1
	sub	w19, w19, w28
.L3430:
	cbz	w19, .L3435
	bl	ftl_flush
.L3435:
	adrp	x25, .LANCHOR99
	add	x21, x26, :lo12:.LANCHOR121
	add	x25, x25, :lo12:.LANCHOR99
	mov	w0, -1
	str	w0, [x29, 124]
.L3436:
	ldrb	w0, [x21]
	cmp	w19, w0
	bcs	.L3441
	cbz	w19, .L3443
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	bne	.L3444
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
.L3444:
	ldr	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3443
	mov	w0, 0
	bl	buf_alloc
	mov	x21, x0
	cbz	x0, .L3443
	strb	wzr, [x0, 57]
	strb	w19, [x0, 56]
	stp	w27, w20, [x21, 32]
	ldrb	w0, [x26, #:lo12:.LANCHOR121]
	cmp	w19, w0
	bcc	.L3446
	adrp	x1, .LANCHOR217
	adrp	x0, .LC0
	mov	w2, 1235
	add	x1, x1, :lo12:.LANCHOR217
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3446:
	ldr	x0, [x21, 8]
	lsl	w2, w19, 9
	mov	w1, 0
	bl	ftl_memset
	mov	x0, x21
	bl	ftl_write_buf
	bl	ftl_write_commit
	ldr	x1, [x23, #:lo12:.LANCHOR97]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L3443:
	ldr	w1, [x24, #:lo12:.LANCHOR216]
	cmp	w1, 8192
	bls	.L3449
	ldr	x0, [x29, 104]
	ldr	w0, [x0, #:lo12:.LANCHOR14]
	tbz	x0, 12, .L3447
	adrp	x0, .LC216
	mov	w4, 0
	mov	w3, w19
	mov	w2, w22
	add	x0, x0, :lo12:.LC216
	bl	printf
.L3447:
	str	wzr, [x24, #:lo12:.LANCHOR216]
	bl	flt_sys_flush
	adrp	x0, .LANCHOR116
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR116]
.L3449:
	mov	w0, 0
	b	.L3427
.L3441:
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3437
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbz	x0, .L3439
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
.L3475:
	ldr	x1, [x23, #:lo12:.LANCHOR97]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L3439:
	ldrb	w0, [x21]
	add	w20, w20, 1
	sub	w19, w19, w0
	b	.L3436
.L3437:
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
	ldr	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3439
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
	adrp	x1, .LANCHOR98
	ldrb	w1, [x1, #:lo12:.LANCHOR98]
	udiv	w0, w0, w1
	bl	ftl_vpn_decrement
	b	.L3475
.L3448:
	mov	w0, -1
.L3427:
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
	.set	.LANCHOR41,. + 0
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
	.set	.LANCHOR99,. + 0
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
	.set	.LANCHOR199,. + 0
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
	.set	.LANCHOR106,. + 0
	.type	_c_ftl_nand_die_num, %object
	.size	_c_ftl_nand_die_num, 1
_c_ftl_nand_die_num:
	.zero	1
	.section	.bss._c_ftl_nand_planes_num,"aw",@nobits
	.set	.LANCHOR73,. + 0
	.type	_c_ftl_nand_planes_num, %object
	.size	_c_ftl_nand_planes_num, 1
_c_ftl_nand_planes_num:
	.zero	1
	.section	.bss._c_ftl_nand_type,"aw",@nobits
	.set	.LANCHOR68,. + 0
	.type	_c_ftl_nand_type, %object
	.size	_c_ftl_nand_type, 1
_c_ftl_nand_type:
	.zero	1
	.section	.bss._c_ftl_page_pre_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR72,. + 0
	.type	_c_ftl_page_pre_blk, %object
	.size	_c_ftl_page_pre_blk, 2
_c_ftl_page_pre_blk:
	.zero	2
	.section	.bss._c_ftl_page_pre_slc_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR80,. + 0
	.type	_c_ftl_page_pre_slc_blk, %object
	.size	_c_ftl_page_pre_slc_blk, 2
_c_ftl_page_pre_slc_blk:
	.zero	2
	.section	.bss._c_ftl_planes_per_die,"aw",@nobits
	.set	.LANCHOR98,. + 0
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
	.set	.LANCHOR121,. + 0
	.type	_c_ftl_sec_per_page, %object
	.size	_c_ftl_sec_per_page, 1
_c_ftl_sec_per_page:
	.zero	1
	.section	.bss._c_max_pm_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR141,. + 0
	.type	_c_max_pm_sblk, %object
	.size	_c_max_pm_sblk, 2
_c_max_pm_sblk:
	.zero	2
	.section	.bss._c_mix_max_slc_ec_count,"aw",@nobits
	.align	1
	.set	.LANCHOR102,. + 0
	.type	_c_mix_max_slc_ec_count, %object
	.size	_c_mix_max_slc_ec_count, 2
_c_mix_max_slc_ec_count:
	.zero	2
	.section	.bss._c_mix_max_xlc_ec_count,"aw",@nobits
	.align	1
	.set	.LANCHOR100,. + 0
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
	.set	.LANCHOR140,. + 0
	.type	_c_swl_slc_gc_th, %object
	.size	_c_swl_slc_gc_th, 2
_c_swl_slc_gc_th:
	.zero	2
	.section	.bss._c_swl_xlc_gc_th,"aw",@nobits
	.align	1
	.set	.LANCHOR139,. + 0
	.type	_c_swl_xlc_gc_th, %object
	.size	_c_swl_xlc_gc_th, 2
_c_swl_xlc_gc_th:
	.zero	2
	.section	.bss._c_totle_data_density,"aw",@nobits
	.align	2
	.set	.LANCHOR204,. + 0
	.type	_c_totle_data_density, %object
	.size	_c_totle_data_density, 4
_c_totle_data_density:
	.zero	4
	.section	.bss._c_totle_log_page,"aw",@nobits
	.align	2
	.set	.LANCHOR118,. + 0
	.type	_c_totle_log_page, %object
	.size	_c_totle_log_page, 4
_c_totle_log_page:
	.zero	4
	.section	.bss._c_totle_phy_density,"aw",@nobits
	.align	2
	.set	.LANCHOR203,. + 0
	.type	_c_totle_phy_density, %object
	.size	_c_totle_phy_density, 4
_c_totle_phy_density:
	.zero	4
	.section	.bss._c_user_data_density,"aw",@nobits
	.align	2
	.set	.LANCHOR58,. + 0
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
	.set	.LANCHOR101,. + 0
	.type	_max_slc_super_block, %object
	.size	_max_slc_super_block, 2
_max_slc_super_block:
	.zero	2
	.section	.bss._max_xlc_super_block,"aw",@nobits
	.align	1
	.set	.LANCHOR88,. + 0
	.type	_max_xlc_super_block, %object
	.size	_max_xlc_super_block, 2
_max_xlc_super_block:
	.zero	2
	.section	.bss._min_slc_super_block,"aw",@nobits
	.align	1
	.set	.LANCHOR84,. + 0
	.type	_min_slc_super_block, %object
	.size	_min_slc_super_block, 2
_min_slc_super_block:
	.zero	2
	.section	.bss.discard_sector_count,"aw",@nobits
	.align	2
	.set	.LANCHOR216,. + 0
	.type	discard_sector_count, %object
	.size	discard_sector_count, 4
discard_sector_count:
	.zero	4
	.section	.bss.fill_spare_size,"aw",@nobits
	.align	1
	.set	.LANCHOR47,. + 0
	.type	fill_spare_size, %object
	.size	fill_spare_size, 2
fill_spare_size:
	.zero	2
	.section	.bss.flash_read_retry,"aw",@nobits
	.align	3
	.set	.LANCHOR156,. + 0
	.type	flash_read_retry, %object
	.size	flash_read_retry, 8
flash_read_retry:
	.zero	8
	.section	.bss.free_buf_count,"aw",@nobits
	.set	.LANCHOR51,. + 0
	.type	free_buf_count, %object
	.size	free_buf_count, 1
free_buf_count:
	.zero	1
	.section	.bss.free_mix_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR94,. + 0
	.type	free_mix_sblk, %object
	.size	free_mix_sblk, 2
free_mix_sblk:
	.zero	2
	.section	.bss.free_slc_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR90,. + 0
	.type	free_slc_sblk, %object
	.size	free_slc_sblk, 2
free_slc_sblk:
	.zero	2
	.section	.bss.free_xlc_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR92,. + 0
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
	.set	.LANCHOR212,. + 0
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
	.set	.LANCHOR59,. + 0
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
	.set	.LANCHOR111,. + 0
	.type	ftl_sblk_lpa_tbl, %object
	.size	ftl_sblk_lpa_tbl, 8
ftl_sblk_lpa_tbl:
	.zero	8
	.section	.bss.ftl_sblk_update_list,"aw",@nobits
	.align	3
	.set	.LANCHOR64,. + 0
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
	.set	.LANCHOR63,. + 0
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
	.set	.LANCHOR49,. + 0
	.type	g_buf, %object
	.size	g_buf, 2048
g_buf:
	.zero	2048
	.section	.bss.g_die_addr,"aw",@nobits
	.align	2
	.set	.LANCHOR136,. + 0
	.type	g_die_addr, %object
	.size	g_die_addr, 32
g_die_addr:
	.zero	32
	.section	.bss.g_die_cs_idx,"aw",@nobits
	.align	2
	.set	.LANCHOR29,. + 0
	.type	g_die_cs_idx, %object
	.size	g_die_cs_idx, 8
g_die_cs_idx:
	.zero	8
	.section	.bss.g_flash_3d_mlc_flag,"aw",@nobits
	.set	.LANCHOR104,. + 0
	.type	g_flash_3d_mlc_flag, %object
	.size	g_flash_3d_mlc_flag, 1
g_flash_3d_mlc_flag:
	.zero	1
	.section	.bss.g_flash_3d_tlc_flag,"aw",@nobits
	.set	.LANCHOR70,. + 0
	.type	g_flash_3d_tlc_flag, %object
	.size	g_flash_3d_tlc_flag, 1
g_flash_3d_tlc_flag:
	.zero	1
	.section	.bss.g_flash_blk_info,"aw",@nobits
	.align	3
	.set	.LANCHOR159,. + 0
	.type	g_flash_blk_info, %object
	.size	g_flash_blk_info, 4
g_flash_blk_info:
	.zero	4
	.section	.bss.g_flash_cur_mode,"aw",@nobits
	.align	3
	.set	.LANCHOR35,. + 0
	.type	g_flash_cur_mode, %object
	.size	g_flash_cur_mode, 4
g_flash_cur_mode:
	.zero	4
	.section	.bss.g_flash_interface_mode,"aw",@nobits
	.set	.LANCHOR42,. + 0
	.type	g_flash_interface_mode, %object
	.size	g_flash_interface_mode, 1
g_flash_interface_mode:
	.zero	1
	.section	.bss.g_flash_multi_page_prog_en,"aw",@nobits
	.set	.LANCHOR38,. + 0
	.type	g_flash_multi_page_prog_en, %object
	.size	g_flash_multi_page_prog_en, 1
g_flash_multi_page_prog_en:
	.zero	1
	.section	.bss.g_flash_multi_page_read_en,"aw",@nobits
	.set	.LANCHOR165,. + 0
	.type	g_flash_multi_page_read_en, %object
	.size	g_flash_multi_page_read_en, 1
g_flash_multi_page_read_en:
	.zero	1
	.section	.bss.g_flash_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR161,. + 0
	.type	g_flash_page_buffer, %object
	.size	g_flash_page_buffer, 8
g_flash_page_buffer:
	.zero	8
	.section	.bss.g_flash_reversd_blks,"aw",@nobits
	.set	.LANCHOR168,. + 0
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
	.set	.LANCHOR160,. + 0
	.type	g_flash_spare_buffer, %object
	.size	g_flash_spare_buffer, 8
g_flash_spare_buffer:
	.zero	8
	.section	.bss.g_flash_sys_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR158,. + 0
	.type	g_flash_sys_spare_buffer, %object
	.size	g_flash_sys_spare_buffer, 8
g_flash_sys_spare_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR151,. + 0
	.type	g_flash_tmp_page_buffer, %object
	.size	g_flash_tmp_page_buffer, 8
g_flash_tmp_page_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR153,. + 0
	.type	g_flash_tmp_spare_buffer, %object
	.size	g_flash_tmp_spare_buffer, 8
g_flash_tmp_spare_buffer:
	.zero	8
	.section	.bss.g_flash_toggle_mode_en,"aw",@nobits
	.set	.LANCHOR20,. + 0
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
	.set	.LANCHOR62,. + 0
	.type	g_gc_info, %object
	.size	g_gc_info, 328
g_gc_info:
	.zero	328
	.section	.bss.g_idb_ecc_bits,"aw",@nobits
	.set	.LANCHOR17,. + 0
	.type	g_idb_ecc_bits, %object
	.size	g_idb_ecc_bits, 1
g_idb_ecc_bits:
	.zero	1
	.section	.bss.g_idb_slc_mode_enable,"aw",@nobits
	.set	.LANCHOR169,. + 0
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
	.set	.LANCHOR25,. + 0
	.type	g_maxRegNum, %object
	.size	g_maxRegNum, 1
g_maxRegNum:
	.zero	1
	.section	.bss.g_maxRetryCount,"aw",@nobits
	.set	.LANCHOR154,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.zero	1
	.section	.bss.g_msb_page_tbl,"aw",@nobits
	.align	2
	.set	.LANCHOR133,. + 0
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
	.set	.LANCHOR19,. + 0
	.type	g_nand_opt_para, %object
	.size	g_nand_opt_para, 32
g_nand_opt_para:
	.zero	32
	.section	.bss.g_nandc_ecc_bits,"aw",@nobits
	.set	.LANCHOR43,. + 0
	.type	g_nandc_ecc_bits, %object
	.size	g_nandc_ecc_bits, 1
g_nandc_ecc_bits:
	.zero	1
	.section	.bss.g_nandc_tran_timeout,"aw",@nobits
	.set	.LANCHOR152,. + 0
	.type	g_nandc_tran_timeout, %object
	.size	g_nandc_tran_timeout, 1
g_nandc_tran_timeout:
	.zero	1
	.section	.bss.g_nandc_v6_master_info,"aw",@nobits
	.align	3
	.set	.LANCHOR46,. + 0
	.type	g_nandc_v6_master_info, %object
	.size	g_nandc_v6_master_info, 40
g_nandc_v6_master_info:
	.zero	40
	.section	.bss.g_nandc_ver,"aw",@nobits
	.set	.LANCHOR27,. + 0
	.type	g_nandc_ver, %object
	.size	g_nandc_ver, 1
g_nandc_ver:
	.zero	1
	.section	.bss.g_pm_spare,"aw",@nobits
	.align	3
	.set	.LANCHOR191,. + 0
	.type	g_pm_spare, %object
	.size	g_pm_spare, 8
g_pm_spare:
	.zero	8
	.section	.bss.g_retryMode,"aw",@nobits
	.set	.LANCHOR23,. + 0
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
	.set	.LANCHOR135,. + 0
	.type	g_slc_page_num, %object
	.size	g_slc_page_num, 2
g_slc_page_num:
	.zero	2
	.section	.bss.g_totle_phy_block,"aw",@nobits
	.align	1
	.set	.LANCHOR137,. + 0
	.type	g_totle_phy_block, %object
	.size	g_totle_phy_block, 2
g_totle_phy_block:
	.zero	2
	.section	.bss.gc_des_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR149,. + 0
	.type	gc_des_ppa_tbl, %object
	.size	gc_des_ppa_tbl, 8
gc_des_ppa_tbl:
	.zero	8
	.section	.bss.gc_free_slc_sblk_th,"aw",@nobits
	.align	1
	.set	.LANCHOR74,. + 0
	.type	gc_free_slc_sblk_th, %object
	.size	gc_free_slc_sblk_th, 2
gc_free_slc_sblk_th:
	.zero	2
	.section	.bss.gc_lpa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR147,. + 0
	.type	gc_lpa_tbl, %object
	.size	gc_lpa_tbl, 8
gc_lpa_tbl:
	.zero	8
	.section	.bss.gc_mode,"aw",@nobits
	.set	.LANCHOR71,. + 0
	.type	gc_mode, %object
	.size	gc_mode, 1
gc_mode:
	.zero	1
	.section	.bss.gc_page_buf_id,"aw",@nobits
	.align	3
	.set	.LANCHOR69,. + 0
	.type	gc_page_buf_id, %object
	.size	gc_page_buf_id, 8
gc_page_buf_id:
	.zero	8
	.section	.bss.gc_pre_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR148,. + 0
	.type	gc_pre_ppa_tbl, %object
	.size	gc_pre_ppa_tbl, 8
gc_pre_ppa_tbl:
	.zero	8
	.section	.bss.gc_search_count,"aw",@nobits
	.align	2
	.set	.LANCHOR146,. + 0
	.type	gc_search_count, %object
	.size	gc_search_count, 4
gc_search_count:
	.zero	4
	.section	.bss.gc_slc_cache_index,"aw",@nobits
	.align	1
	.set	.LANCHOR77,. + 0
	.type	gc_slc_cache_index, %object
	.size	gc_slc_cache_index, 2
gc_slc_cache_index:
	.zero	2
	.section	.bss.gc_slc_data_index,"aw",@nobits
	.align	1
	.set	.LANCHOR81,. + 0
	.type	gc_slc_data_index, %object
	.size	gc_slc_data_index, 2
gc_slc_data_index:
	.zero	2
	.section	.bss.gc_slc_mode_tlc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR79,. + 0
	.type	gc_slc_mode_tlc_vpn_th, %object
	.size	gc_slc_mode_tlc_vpn_th, 2
gc_slc_mode_tlc_vpn_th:
	.zero	2
	.section	.bss.gc_slc_mode_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR61,. + 0
	.type	gc_slc_mode_vpn_th, %object
	.size	gc_slc_mode_vpn_th, 2
gc_slc_mode_vpn_th:
	.zero	2
	.section	.bss.gc_state,"aw",@nobits
	.set	.LANCHOR145,. + 0
	.type	gc_state, %object
	.size	gc_state, 1
gc_state:
	.zero	1
	.section	.bss.gc_tlc_mode_slc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR89,. + 0
	.type	gc_tlc_mode_slc_vpn_th, %object
	.size	gc_tlc_mode_slc_vpn_th, 2
gc_tlc_mode_slc_vpn_th:
	.zero	2
	.section	.bss.gc_tlc_mode_tlc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR86,. + 0
	.type	gc_tlc_mode_tlc_vpn_th, %object
	.size	gc_tlc_mode_tlc_vpn_th, 2
gc_tlc_mode_tlc_vpn_th:
	.zero	2
	.section	.bss.gc_valid_page_ppa,"aw",@nobits
	.align	3
	.set	.LANCHOR65,. + 0
	.type	gc_valid_page_ppa, %object
	.size	gc_valid_page_ppa, 8
gc_valid_page_ppa:
	.zero	8
	.section	.bss.gc_xlc_data_index,"aw",@nobits
	.align	1
	.set	.LANCHOR78,. + 0
	.type	gc_xlc_data_index, %object
	.size	gc_xlc_data_index, 2
gc_xlc_data_index:
	.zero	2
	.section	.bss.gc_xlc_search_index,"aw",@nobits
	.align	1
	.set	.LANCHOR82,. + 0
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
	.set	.LANCHOR76,. + 0
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
	.set	.LANCHOR75,. + 0
	.type	gp_data_xlc_data_head, %object
	.size	gp_data_xlc_data_head, 8
gp_data_xlc_data_head:
	.zero	8
	.section	.bss.gp_flash_check_buf,"aw",@nobits
	.align	3
	.type	gp_flash_check_buf, %object
	.size	gp_flash_check_buf, 262144
gp_flash_check_buf:
	.zero	262144
	.section	.bss.gp_flash_info,"aw",@nobits
	.align	3
	.set	.LANCHOR26,. + 0
	.type	gp_flash_info, %object
	.size	gp_flash_info, 8
gp_flash_info:
	.zero	8
	.section	.bss.gp_free_mix_head,"aw",@nobits
	.align	3
	.set	.LANCHOR95,. + 0
	.type	gp_free_mix_head, %object
	.size	gp_free_mix_head, 8
gp_free_mix_head:
	.zero	8
	.section	.bss.gp_free_slc_head,"aw",@nobits
	.align	3
	.set	.LANCHOR91,. + 0
	.type	gp_free_slc_head, %object
	.size	gp_free_slc_head, 8
gp_free_slc_head:
	.zero	8
	.section	.bss.gp_free_xlc_head,"aw",@nobits
	.align	3
	.set	.LANCHOR93,. + 0
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
	.set	.LANCHOR97,. + 0
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
	.type	idb_buf, %object
	.size	idb_buf, 262144
idb_buf:
	.zero	262144
	.section	.bss.idb_need_write_back,"aw",@nobits
	.align	2
	.set	.LANCHOR170,. + 0
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
	.set	.LANCHOR44,. + 0
	.type	nandc_hw_seed, %object
	.size	nandc_hw_seed, 1
nandc_hw_seed:
	.zero	1
	.section	.bss.nandc_randomizer_en,"aw",@nobits
	.set	.LANCHOR45,. + 0
	.type	nandc_randomizer_en, %object
	.size	nandc_randomizer_en, 1
nandc_randomizer_en:
	.zero	1
	.section	.bss.p_free_buf_head,"aw",@nobits
	.set	.LANCHOR50,. + 0
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
	.set	.LANCHOR128,. + 0
	.type	pm_gc_enable, %object
	.size	pm_gc_enable, 4
pm_gc_enable:
	.zero	4
	.section	.bss.pm_last_load_ram_id,"aw",@nobits
	.set	.LANCHOR201,. + 0
	.type	pm_last_load_ram_id, %object
	.size	pm_last_load_ram_id, 1
pm_last_load_ram_id:
	.zero	1
	.section	.bss.pm_last_update_ram_id,"aw",@nobits
	.set	.LANCHOR131,. + 0
	.type	pm_last_update_ram_id, %object
	.size	pm_last_update_ram_id, 1
pm_last_update_ram_id:
	.zero	1
	.section	.bss.pm_ram_info,"aw",@nobits
	.align	3
	.set	.LANCHOR130,. + 0
	.type	pm_ram_info, %object
	.size	pm_ram_info, 512
pm_ram_info:
	.zero	512
	.section	.bss.read_ahead_lpa,"aw",@nobits
	.align	2
	.set	.LANCHOR202,. + 0
	.type	read_ahead_lpa, %object
	.size	read_ahead_lpa, 4
read_ahead_lpa:
	.zero	4
	.section	.bss.read_buf_count,"aw",@nobits
	.set	.LANCHOR125,. + 0
	.type	read_buf_count, %object
	.size	read_buf_count, 1
read_buf_count:
	.zero	1
	.section	.bss.read_buf_head,"aw",@nobits
	.set	.LANCHOR124,. + 0
	.type	read_buf_head, %object
	.size	read_buf_head, 1
read_buf_head:
	.zero	1
	.section	.bss.sblk_gc_write_completed_queue_head,"aw",@nobits
	.set	.LANCHOR66,. + 0
	.type	sblk_gc_write_completed_queue_head, %object
	.size	sblk_gc_write_completed_queue_head, 1
sblk_gc_write_completed_queue_head:
	.zero	1
	.section	.bss.sblk_queue_head,"aw",@nobits
	.set	.LANCHOR53,. + 0
	.type	sblk_queue_head, %object
	.size	sblk_queue_head, 1
sblk_queue_head:
	.zero	1
	.section	.bss.sblk_read_completed_queue_head,"aw",@nobits
	.set	.LANCHOR127,. + 0
	.type	sblk_read_completed_queue_head, %object
	.size	sblk_read_completed_queue_head, 1
sblk_read_completed_queue_head:
	.zero	1
	.section	.bss.sblk_write_completed_queue_head,"aw",@nobits
	.set	.LANCHOR122,. + 0
	.type	sblk_write_completed_queue_head, %object
	.size	sblk_write_completed_queue_head, 1
sblk_write_completed_queue_head:
	.zero	1
	.section	.bss.slc_cache_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR83,. + 0
	.type	slc_cache_sblk, %object
	.size	slc_cache_sblk, 2
slc_cache_sblk:
	.zero	2
	.section	.bss.slc_data_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR85,. + 0
	.type	slc_data_sblk, %object
	.size	slc_data_sblk, 2
slc_data_sblk:
	.zero	2
	.section	.bss.write_buf_count,"aw",@nobits
	.set	.LANCHOR57,. + 0
	.type	write_buf_count, %object
	.size	write_buf_count, 1
write_buf_count:
	.zero	1
	.section	.bss.write_buf_head,"aw",@nobits
	.set	.LANCHOR56,. + 0
	.type	write_buf_head, %object
	.size	write_buf_head, 1
write_buf_head:
	.zero	1
	.section	.bss.write_commit_count,"aw",@nobits
	.set	.LANCHOR119,. + 0
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
	.set	.LANCHOR87,. + 0
	.type	xlc_data_sblk, %object
	.size	xlc_data_sblk, 2
xlc_data_sblk:
	.zero	2
	.section	.bss.zftl_print_list_count,"aw",@nobits
	.align	1
	.set	.LANCHOR96,. + 0
	.type	zftl_print_list_count, %object
	.size	zftl_print_list_count, 2
zftl_print_list_count:
	.zero	2
	.section	.data.g_nand_para_info,"aw",@progbits
	.align	3
	.set	.LANCHOR34,. + 0
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
	.set	.LANCHOR150,. + 0
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
	.set	.LANCHOR196,. + 0
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
	.set	.LANCHOR33,. + 0
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
	.set	.LANCHOR32,. + 0
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
	.set	.LANCHOR214,. + 0
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
	.set	.LANCHOR195,. + 0
	.type	zftl_nand_flash_para_tbl, %object
	.size	zftl_nand_flash_para_tbl, 960
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
	.byte	2
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
	.byte	3
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
	.byte	60
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
	.hword	473
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
	.section	.rodata.__func__.10041,"a",@progbits
	.align	3
	.set	.LANCHOR5,. + 0
	.type	__func__.10041, %object
	.size	__func__.10041, 18
__func__.10041:
	.string	"_list_remove_node"
	.section	.rodata.__func__.10066,"a",@progbits
	.align	3
	.set	.LANCHOR11,. + 0
	.type	__func__.10066, %object
	.size	__func__.10066, 23
__func__.10066:
	.string	"_list_update_data_list"
	.section	.rodata.__func__.10174,"a",@progbits
	.align	3
	.set	.LANCHOR180,. + 0
	.type	__func__.10174, %object
	.size	__func__.10174, 15
__func__.10174:
	.string	"ftl_info_flush"
	.section	.rodata.__func__.10206,"a",@progbits
	.align	3
	.set	.LANCHOR126,. + 0
	.type	__func__.10206, %object
	.size	__func__.10206, 15
__func__.10206:
	.string	"ftl_alloc_sblk"
	.section	.rodata.__func__.10247,"a",@progbits
	.align	3
	.set	.LANCHOR107,. + 0
	.type	__func__.10247, %object
	.size	__func__.10247, 18
__func__.10247:
	.string	"ftl_alloc_sys_blk"
	.section	.rodata.__func__.10257,"a",@progbits
	.align	3
	.set	.LANCHOR108,. + 0
	.type	__func__.10257, %object
	.size	__func__.10257, 17
__func__.10257:
	.string	"ftl_free_sys_blk"
	.section	.rodata.__func__.10292,"a",@progbits
	.align	3
	.set	.LANCHOR208,. + 0
	.type	__func__.10292, %object
	.size	__func__.10292, 14
__func__.10292:
	.string	"ftl_sblk_dump"
	.section	.rodata.__func__.10316,"a",@progbits
	.align	3
	.set	.LANCHOR197,. + 0
	.type	__func__.10316, %object
	.size	__func__.10316, 16
__func__.10316:
	.string	"ftl_sysblk_dump"
	.section	.rodata.__func__.10335,"a",@progbits
	.align	3
	.set	.LANCHOR189,. + 0
	.type	__func__.10335, %object
	.size	__func__.10335, 23
__func__.10335:
	.string	"ftl_open_sblk_recovery"
	.section	.rodata.__func__.10361,"a",@progbits
	.align	3
	.set	.LANCHOR109,. + 0
	.type	__func__.10361, %object
	.size	__func__.10361, 23
__func__.10361:
	.string	"ftl_get_ppa_from_index"
	.section	.rodata.__func__.10382,"a",@progbits
	.align	3
	.set	.LANCHOR210,. + 0
	.type	__func__.10382, %object
	.size	__func__.10382, 19
__func__.10382:
	.string	"ftl_update_l2p_map"
	.section	.rodata.__func__.10400,"a",@progbits
	.align	3
	.set	.LANCHOR113,. + 0
	.type	__func__.10400, %object
	.size	__func__.10400, 22
__func__.10400:
	.string	"ftl_get_new_free_page"
	.section	.rodata.__func__.10411,"a",@progbits
	.align	3
	.set	.LANCHOR114,. + 0
	.type	__func__.10411, %object
	.size	__func__.10411, 22
__func__.10411:
	.string	"ftl_ext_alloc_new_blk"
	.section	.rodata.__func__.10436,"a",@progbits
	.align	3
	.set	.LANCHOR184,. + 0
	.type	__func__.10436, %object
	.size	__func__.10436, 19
__func__.10436:
	.string	"ftl_ext_info_flush"
	.section	.rodata.__func__.10448,"a",@progbits
	.align	3
	.set	.LANCHOR185,. + 0
	.type	__func__.10448, %object
	.size	__func__.10448, 18
__func__.10448:
	.string	"ftl_ext_info_init"
	.section	.rodata.__func__.10485,"a",@progbits
	.align	3
	.set	.LANCHOR186,. + 0
	.type	__func__.10485, %object
	.size	__func__.10485, 25
__func__.10485:
	.string	"ftl_low_format_data_init"
	.section	.rodata.__func__.10500,"a",@progbits
	.align	3
	.set	.LANCHOR188,. + 0
	.type	__func__.10500, %object
	.size	__func__.10500, 15
__func__.10500:
	.string	"ftl_low_format"
	.section	.rodata.__func__.10548,"a",@progbits
	.align	3
	.set	.LANCHOR177,. + 0
	.type	__func__.10548, %object
	.size	__func__.10548, 14
__func__.10548:
	.string	"ftl_prog_page"
	.section	.rodata.__func__.10665,"a",@progbits
	.align	3
	.set	.LANCHOR164,. + 0
	.type	__func__.10665, %object
	.size	__func__.10665, 31
__func__.10665:
	.string	"queue_wait_first_req_completed"
	.section	.rodata.__func__.10718,"a",@progbits
	.align	3
	.set	.LANCHOR173,. + 0
	.type	__func__.10718, %object
	.size	__func__.10718, 15
__func__.10718:
	.string	"sblk_prog_page"
	.section	.rodata.__func__.10745,"a",@progbits
	.align	3
	.set	.LANCHOR166,. + 0
	.type	__func__.10745, %object
	.size	__func__.10745, 15
__func__.10745:
	.string	"sblk_read_page"
	.section	.rodata.__func__.10784,"a",@progbits
	.align	3
	.set	.LANCHOR198,. + 0
	.type	__func__.10784, %object
	.size	__func__.10784, 16
__func__.10784:
	.string	"load_l2p_region"
	.section	.rodata.__func__.10798,"a",@progbits
	.align	3
	.set	.LANCHOR142,. + 0
	.type	__func__.10798, %object
	.size	__func__.10798, 13
__func__.10798:
	.string	"pm_free_sblk"
	.section	.rodata.__func__.10818,"a",@progbits
	.align	3
	.set	.LANCHOR200,. + 0
	.type	__func__.10818, %object
	.size	__func__.10818, 6
__func__.10818:
	.string	"pm_gc"
	.section	.rodata.__func__.10834,"a",@progbits
	.align	3
	.set	.LANCHOR129,. + 0
	.type	__func__.10834, %object
	.size	__func__.10834, 17
__func__.10834:
	.string	"pm_alloc_new_blk"
	.section	.rodata.__func__.10844,"a",@progbits
	.align	3
	.set	.LANCHOR190,. + 0
	.type	__func__.10844, %object
	.size	__func__.10844, 14
__func__.10844:
	.string	"pm_write_page"
	.section	.rodata.__func__.10862,"a",@progbits
	.align	3
	.set	.LANCHOR132,. + 0
	.type	__func__.10862, %object
	.size	__func__.10862, 21
__func__.10862:
	.string	"pm_select_ram_region"
	.section	.rodata.__func__.8511,"a",@progbits
	.align	3
	.set	.LANCHOR155,. + 0
	.type	__func__.8511, %object
	.size	__func__.8511, 19
__func__.8511:
	.string	"flash_read_page_en"
	.section	.rodata.__func__.8540,"a",@progbits
	.align	3
	.set	.LANCHOR175,. + 0
	.type	__func__.8540, %object
	.size	__func__.8540, 19
__func__.8540:
	.string	"flash_prog_page_en"
	.section	.rodata.__func__.8555,"a",@progbits
	.align	3
	.set	.LANCHOR37,. + 0
	.type	__func__.8555, %object
	.size	__func__.8555, 26
__func__.8555:
	.string	"flash_erase_duplane_block"
	.section	.rodata.__func__.8566,"a",@progbits
	.align	3
	.set	.LANCHOR39,. + 0
	.type	__func__.8566, %object
	.size	__func__.8566, 21
__func__.8566:
	.string	"flash_erase_block_en"
	.section	.rodata.__func__.8580,"a",@progbits
	.align	3
	.set	.LANCHOR28,. + 0
	.type	__func__.8580, %object
	.size	__func__.8580, 28
__func__.8580:
	.string	"flash_wait_device_ready_raw"
	.section	.rodata.__func__.8604,"a",@progbits
	.align	3
	.set	.LANCHOR171,. + 0
	.type	__func__.8604, %object
	.size	__func__.8604, 26
__func__.8604:
	.string	"flash_start_tlc_page_prog"
	.section	.rodata.__func__.8622,"a",@progbits
	.align	3
	.set	.LANCHOR172,. + 0
	.type	__func__.8622, %object
	.size	__func__.8622, 22
__func__.8622:
	.string	"flash_start_page_prog"
	.section	.rodata.__func__.8633,"a",@progbits
	.align	3
	.set	.LANCHOR36,. + 0
	.type	__func__.8633, %object
	.size	__func__.8633, 22
__func__.8633:
	.string	"flash_start_page_read"
	.section	.rodata.__func__.8646,"a",@progbits
	.align	3
	.set	.LANCHOR162,. + 0
	.type	__func__.8646, %object
	.size	__func__.8646, 31
__func__.8646:
	.string	"flash_complete_plane_page_read"
	.section	.rodata.__func__.8658,"a",@progbits
	.align	3
	.set	.LANCHOR40,. + 0
	.type	__func__.8658, %object
	.size	__func__.8658, 23
__func__.8658:
	.string	"flash_start_plane_read"
	.section	.rodata.__func__.8671,"a",@progbits
	.align	3
	.set	.LANCHOR163,. + 0
	.type	__func__.8671, %object
	.size	__func__.8671, 25
__func__.8671:
	.string	"flash_complete_page_read"
	.section	.rodata.__func__.8982,"a",@progbits
	.align	3
	.set	.LANCHOR134,. + 0
	.type	__func__.8982, %object
	.size	__func__.8982, 20
__func__.8982:
	.string	"flash_die_info_init"
	.section	.rodata.__func__.8992,"a",@progbits
	.align	3
	.set	.LANCHOR15,. + 0
	.type	__func__.8992, %object
	.size	__func__.8992, 22
__func__.8992:
	.string	"nand_flash_print_info"
	.section	.rodata.__func__.9036,"a",@progbits
	.align	3
	.set	.LANCHOR194,. + 0
	.type	__func__.9036, %object
	.size	__func__.9036, 16
__func__.9036:
	.string	"nand_flash_init"
	.section	.rodata.__func__.9059,"a",@progbits
	.align	3
	.set	.LANCHOR144,. + 0
	.type	__func__.9059, %object
	.size	__func__.9059, 11
__func__.9059:
	.string	"nandc_init"
	.section	.rodata.__func__.9219,"a",@progbits
	.align	3
	.set	.LANCHOR52,. + 0
	.type	__func__.9219, %object
	.size	__func__.9219, 13
__func__.9219:
	.string	"buf_add_tail"
	.section	.rodata.__func__.9232,"a",@progbits
	.align	3
	.set	.LANCHOR54,. + 0
	.type	__func__.9232, %object
	.size	__func__.9232, 10
__func__.9232:
	.string	"buf_alloc"
	.section	.rodata.__func__.9246,"a",@progbits
	.align	3
	.set	.LANCHOR55,. + 0
	.type	__func__.9246, %object
	.size	__func__.9246, 16
__func__.9246:
	.string	"buf_remove_free"
	.section	.rodata.__func__.9258,"a",@progbits
	.align	3
	.set	.LANCHOR157,. + 0
	.type	__func__.9258, %object
	.size	__func__.9258, 20
__func__.9258:
	.string	"flash_info_blk_init"
	.section	.rodata.__func__.9269,"a",@progbits
	.align	3
	.set	.LANCHOR143,. + 0
	.type	__func__.9269, %object
	.size	__func__.9269, 21
__func__.9269:
	.string	"flash_into_data_init"
	.section	.rodata.__func__.9291,"a",@progbits
	.align	3
	.set	.LANCHOR193,. + 0
	.type	__func__.9291, %object
	.size	__func__.9291, 17
__func__.9291:
	.string	"flash_info_flush"
	.section	.rodata.__func__.9367,"a",@progbits
	.align	3
	.set	.LANCHOR138,. + 0
	.type	__func__.9367, %object
	.size	__func__.9367, 17
__func__.9367:
	.string	"lpa_rebuild_hash"
	.section	.rodata.__func__.9414,"a",@progbits
	.align	3
	.set	.LANCHOR211,. + 0
	.type	__func__.9414, %object
	.size	__func__.9414, 17
__func__.9414:
	.string	"ftl_write_commit"
	.section	.rodata.__func__.9432,"a",@progbits
	.align	3
	.set	.LANCHOR120,. + 0
	.type	__func__.9432, %object
	.size	__func__.9432, 14
__func__.9432:
	.string	"ftl_write_buf"
	.section	.rodata.__func__.9476,"a",@progbits
	.align	3
	.set	.LANCHOR123,. + 0
	.type	__func__.9476, %object
	.size	__func__.9476, 18
__func__.9476:
	.string	"zftl_add_read_buf"
	.section	.rodata.__func__.9509,"a",@progbits
	.align	3
	.set	.LANCHOR209,. + 0
	.type	__func__.9509, %object
	.size	__func__.9509, 10
__func__.9509:
	.string	"zftl_read"
	.section	.rodata.__func__.9540,"a",@progbits
	.align	3
	.set	.LANCHOR217,. + 0
	.type	__func__.9540, %object
	.size	__func__.9540, 13
__func__.9540:
	.string	"_ftl_discard"
	.section	.rodata.__func__.9659,"a",@progbits
	.align	3
	.set	.LANCHOR60,. + 0
	.type	__func__.9659, %object
	.size	__func__.9659, 12
__func__.9659:
	.string	"gc_add_sblk"
	.section	.rodata.__func__.9680,"a",@progbits
	.align	3
	.set	.LANCHOR167,. + 0
	.type	__func__.9680, %object
	.size	__func__.9680, 21
__func__.9680:
	.string	"gc_check_data_one_wl"
	.section	.rodata.__func__.9714,"a",@progbits
	.align	3
	.set	.LANCHOR205,. + 0
	.type	__func__.9714, %object
	.size	__func__.9714, 22
__func__.9714:
	.string	"gc_update_l2p_map_new"
	.section	.rodata.__func__.9727,"a",@progbits
	.align	3
	.set	.LANCHOR67,. + 0
	.type	__func__.9727, %object
	.size	__func__.9727, 19
__func__.9727:
	.string	"gc_write_completed"
	.section	.rodata.__func__.9756,"a",@progbits
	.align	3
	.set	.LANCHOR213,. + 0
	.type	__func__.9756, %object
	.size	__func__.9756, 16
__func__.9756:
	.string	"gc_do_copy_back"
	.section	.rodata.__func__.9778,"a",@progbits
	.align	3
	.set	.LANCHOR103,. + 0
	.type	__func__.9778, %object
	.size	__func__.9778, 16
__func__.9778:
	.string	"gc_free_src_blk"
	.section	.rodata.__func__.9823,"a",@progbits
	.align	3
	.set	.LANCHOR206,. + 0
	.type	__func__.9823, %object
	.size	__func__.9823, 16
__func__.9823:
	.string	"gc_scan_src_blk"
	.section	.rodata.__func__.9881,"a",@progbits
	.align	3
	.set	.LANCHOR207,. + 0
	.type	__func__.9881, %object
	.size	__func__.9881, 20
__func__.9881:
	.string	"gc_scan_static_data"
	.section	.rodata.__func__.9948,"a",@progbits
	.align	3
	.set	.LANCHOR215,. + 0
	.type	__func__.9948, %object
	.size	__func__.9948, 11
__func__.9948:
	.string	"zftl_do_gc"
	.section	.rodata._list_remove_node.str1.1,"aMS",@progbits,1
.LC0:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
	.section	.rodata.dump_ftl_info.str1.1,"aMS",@progbits,1
.LC151:
	.string	"free_buf_count: %d\n"
.LC152:
	.string	"g_ftl_info_blk blk:0x%x, index:0x%x, page:0x%x\n"
.LC153:
	.string	"ftl_ext_info_blk blk:0x%x, page:0x%x\n"
.LC154:
	.string	"ac_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC155:
	.string	"tmp_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC156:
	.string	"gc_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC157:
	.string	"lpa:"
.LC158:
	.string	"vpn:"
.LC159:
	.string	"sblk:"
.LC160:
	.string	"lpa_hash:"
.LC161:
	.string	"lpa_hash_index:"
	.section	.rodata.dump_sblk_queue.str1.1,"aMS",@progbits,1
.LC68:
	.string	"dump_sblk_queue: %d\n"
.LC69:
	.string	"buf id= %d state = %d ppa = %x\n"
	.section	.rodata.flash_complete_page_read.str1.1,"aMS",@progbits,1
.LC117:
	.string	"flash_complete_page_read %x %x error_ecc %d %d\n"
	.section	.rodata.flash_ddr_tuning_read.str1.1,"aMS",@progbits,1
.LC109:
	.string	"%d flash_ddr_tuning_read %x ecc=%d\n"
.LC110:
	.string	"sync para %d\n"
.LC111:
	.string	"DDR mode Read error %x %x\n"
	.section	.rodata.flash_erase_all.str1.1,"aMS",@progbits,1
.LC35:
	.string	"erase done: %x\n"
	.section	.rodata.flash_erase_block_en.str1.1,"aMS",@progbits,1
.LC33:
	.string	"flash_erase_block %x %x\n"
.LC34:
	.string	"flash_erase_block block = %x status = %x\n"
	.section	.rodata.flash_erase_duplane_block.str1.1,"aMS",@progbits,1
.LC31:
	.string	"flash_erase_duplane_block %x %x %x\n"
.LC32:
	.string	"flash_erase_duplane_block pageadd = %x status = %x\n"
	.section	.rodata.flash_get_last_written_page.str1.1,"aMS",@progbits,1
.LC114:
	.string	"flash_get_last_written_page: %x %x %x\n"
	.section	.rodata.flash_info_blk_init.str1.1,"aMS",@progbits,1
.LC115:
	.string	"...%d @ %s %d %p\n"
.LC116:
	.string	"no sys info %x\n"
	.section	.rodata.flash_info_flush.str1.1,"aMS",@progbits,1
.LC146:
	.string	"finfo:"
.LC147:
	.string	"flash_info_flush id = %x, page = %x\n"
.LC148:
	.string	"sys_info_flush error:%x\n"
	.section	.rodata.flash_into_data_init.str1.1,"aMS",@progbits,1
.LC84:
	.string	"...%d @ %s\n"
	.section	.rodata.flash_mask_bad_block.str1.1,"aMS",@progbits,1
.LC40:
	.string	"flash_mask_bad_block %d %d\n"
	.section	.rodata.flash_prog_page.str1.1,"aMS",@progbits,1
.LC121:
	.string	"flash_prog_page %x %x %x\n"
.LC122:
	.string	"flash_prog_page page_addr = %x status = %x\n"
	.section	.rodata.flash_prog_page_en.str1.1,"aMS",@progbits,1
.LC127:
	.string	"flash_prog_page_en:%x %x\n"
.LC128:
	.string	"spare"
.LC129:
	.string	"data"
.LC130:
	.string	"write error: %x\n"
	.section	.rodata.flash_read_id.str1.1,"aMS",@progbits,1
.LC38:
	.string	"No.%d FLASH ID:%x %x %x %x %x %x\n"
	.section	.rodata.flash_read_page.str1.1,"aMS",@progbits,1
.LC102:
	.string	"flash_read_page %x %x %x\n"
	.section	.rodata.flash_read_page_en.str1.1,"aMS",@progbits,1
.LC112:
	.string	"flash_read_page_en %x %x %x\n"
.LC113:
	.string	"flash_read_page_en %x %x error_ecc %d %d\n"
	.section	.rodata.flash_set_interface_mode.str1.1,"aMS",@progbits,1
.LC36:
	.string	"nand sdr mode %x\n"
.LC37:
	.string	"nand ddr mode %x\n"
	.section	.rodata.ftl_alloc_sblk.str1.1,"aMS",@progbits,1
.LC67:
	.string	"alloc sblk %x %d\n"
	.section	.rodata.ftl_ext_info_init.str1.1,"aMS",@progbits,1
.LC135:
	.string	"%s %d %d %x %x\n"
	.section	.rodata.ftl_free_sblk.str1.1,"aMS",@progbits,1
.LC55:
	.string	"swl_tlc_free_mini_ec_blk sblk %x\n"
.LC56:
	.string	"swl_slc_free_mini_ec_blk sblk %x\n"
	.section	.rodata.ftl_info_blk_init.str1.1,"aMS",@progbits,1
.LC133:
	.string	"%d %x @%d %x\n"
.LC134:
	.string	"ftl_info_blk_init %d %d %x\n"
	.section	.rodata.ftl_info_flush.str1.1,"aMS",@progbits,1
.LC132:
	.string	"g_ftl_info_blk blk = %x, page = %x version = %d\n"
	.section	.rodata.ftl_low_format.str1.1,"aMS",@progbits,1
.LC136:
	.string	"ftl_low_format %d\n"
.LC137:
	.string	"low format %d %d %d %d\n"
	.section	.rodata.ftl_mask_bad_block.str1.1,"aMS",@progbits,1
.LC60:
	.string	"mask bad block:cs %x block: %x\n"
	.section	.rodata.ftl_open_sblk_recovery.str1.1,"aMS",@progbits,1
.LC139:
	.string	"saved_active_page  = %x\n"
.LC140:
	.string	"saved_active_plane = %x\n"
.LC141:
	.string	"sblk = %x\n"
.LC142:
	.string	"phy_blk = %x %x\n"
.LC143:
	.string	"sblk = %x, vpn0 = %d, vpn1 = %d\n"
.LC144:
	.string	"dump write = %x\n"
	.section	.rodata.ftl_re_low_format.str1.1,"aMS",@progbits,1
.LC138:
	.string	"re low format %d\n"
	.section	.rodata.ftl_sblk_dump.str1.1,"aMS",@progbits,1
.LC194:
	.string	"ftl_sblk_dump = %x %d %d %d %d\n"
.LC195:
	.string	"ftl_sblk_dump = %x %x %x %x\n"
.LC196:
	.string	"page_addr = %x, lpa=%x vpn = %d\n"
.LC197:
	.string	"index= %x, lpa=%x\n"
.LC198:
	.string	"block = %x, vpn=%x check vpn = %d\n"
	.section	.rodata.ftl_sysblk_dump.str1.1,"aMS",@progbits,1
.LC149:
	.string	"blk= %x, page=%x, ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC150:
	.string	"l2p:"
	.section	.rodata.ftl_test_block.str1.1,"aMS",@progbits,1
.LC131:
	.string	"low format %d\n"
	.section	.rodata.ftl_update_l2p_map.str1.1,"aMS",@progbits,1
.LC202:
	.string	"ftl_update_l2p_map: %x %x %x\n"
.LC203:
	.string	"ftl_update_l2p_map"
.LC204:
	.string	"lpa_tbl:"
.LC205:
	.string	"sblk %x vpn: %d %d\n"
	.section	.rodata.ftl_vpn_decrement.str1.1,"aMS",@progbits,1
.LC59:
	.string	"ftl_vpn_decrement %x = %d\n"
	.section	.rodata.ftl_write_commit.str1.1,"aMS",@progbits,1
.LC206:
	.string	"%d read error: ppa:%x, lpa:%x, status:%x\n"
	.section	.rodata.ftl_write_completed.str1.1,"aMS",@progbits,1
.LC66:
	.string	"ftl prog error =%x, lpa = %x, ppa= %x\n"
	.section	.rodata.gc_add_sblk.str1.1,"aMS",@progbits,1
.LC41:
	.string	"gc_add_sblk = %d, %d, %d, %d, %d, %d\n"
.LC42:
	.string	"gc_add_sblk = %d, %d, %d,last update:%d, %d\n"
	.section	.rodata.gc_check_data_one_wl.str1.1,"aMS",@progbits,1
.LC120:
	.string	"1ppa = %x, status = %x, %x %x spare: %x %x %x %x\n"
	.section	.rodata.gc_do_copy_back.str1.1,"aMS",@progbits,1
.LC207:
	.string	"gc page in buf: lpa %x ppa = %x pageindex= %x\n"
.LC208:
	.string	"gc_do_copy_back: lpa %x des_ppa = %x %x gc_ppa= %x page_index= %d\n"
.LC209:
	.string	"gc_do_copy_back: %x %x %x %x gc_ppa:%x %x\n"
.LC210:
	.string	"%d prog_step: %x %x buf id= %x ppa = %x hash=%x id = %x plane = %x lpa=%x\n"
	.section	.rodata.gc_free_src_blk.str1.1,"aMS",@progbits,1
.LC57:
	.string	"gc_free_src_blk = %x, vpn = %d\n"
.LC58:
	.string	"gc_free_src_blk %x, %d\n"
	.section	.rodata.gc_free_temp_buf.str1.1,"aMS",@progbits,1
.LC45:
	.string	"%d gc_free_temp_buf buf id= %x\n"
	.section	.rodata.gc_recovery.str1.1,"aMS",@progbits,1
.LC172:
	.string	"ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC173:
	.string	"ppa = %x, status = %x, %x %x spare: %x %x %x %x\n"
.LC174:
	.string	"gc_recovery: %x vpn = %x\n"
	.section	.rodata.gc_scan_src_blk.str1.1,"aMS",@progbits,1
.LC192:
	.string	"gc_scan_src_blk = %x, vpn = %d\n"
.LC193:
	.string	"gc_scan_src_blk = %x, s vpn0 = %d, c vpn1 = %d\n"
	.section	.rodata.gc_search_src_blk.str1.1,"aMS",@progbits,1
.LC47:
	.string	"zftl_get_gc_node cache = %x index = %d vpn = %x\n"
.LC48:
	.string	"gc_search_src_blk mode = %x, src mode = %x, count= %d %d\n"
	.section	.rodata.gc_static_wearleveling.str1.1,"aMS",@progbits,1
.LC73:
	.string	"gc_static_wearleveling: min blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC74:
	.string	"gc_static_wearleveling: min slc blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC75:
	.string	"gc_static_wearleveling: min tlc blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC76:
	.string	"gc_static_wearleveling: max slc blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC77:
	.string	"gc_static_wearleveling: max xlc blk: %x,sec=%d,xec = %d ,mode=%d, func=%x, bbt=%x vpn = %d\n"
.LC78:
	.string	"gc_static_wearleveling: slc blk: %x, tlc blk: %d avg slc ec: %d, avg tlc ec: %d \n"
.LC79:
	.string	"gc_static_wearleveling: min slc ec: %x, min tlc ec: %d max slc ec: %d, max tlc ec: %d; %d %d\n"
.LC80:
	.string	"swl add tlc gc = %x, %d, %d, %d, %d, %d\n"
.LC81:
	.string	"swl add slc gc  = %x, %d, %d, %d, %d, %d\n"
	.section	.rodata.gc_update_l2p_map_new.str1.1,"aMS",@progbits,1
.LC188:
	.string	"gc_update_l2p_map_new sblk %x\n"
.LC189:
	.string	"gc_update_l2p_map_new: %x %x %x\n"
.LC190:
	.string	"lpa: %x %x %x\n"
.LC191:
	.string	"gc_update_l2p_map_new: %x vpn = %x vpn1 = %x done\n"
	.section	.rodata.gc_write_completed.str1.1,"aMS",@progbits,1
.LC43:
	.string	"status: %x, ppa: %x\n"
.LC44:
	.string	"gc_write_completed: %x  %x  %x %x\n"
	.section	.rodata.hynix_get_read_retry_default.str1.1,"aMS",@progbits,1
.LC92:
	.string	"otp error! %d"
.LC93:
	.string	"rr"
	.section	.rodata.hynix_read_retrial.str1.1,"aMS",@progbits,1
.LC108:
	.string	"hynix RR %d row=%x, count %d, status=%d\n"
	.section	.rodata.idb_write_data.str1.1,"aMS",@progbits,1
.LC123:
	.string	"1 write_idblock fix data %x %x %x\n"
.LC124:
	.string	"write_idblock check fail! %x\n"
.LC125:
	.string	"write_idblock fail! %x\n"
	.section	.rodata.load_l2p_region.str1.1,"aMS",@progbits,1
.LC163:
	.string	"region_id = %d, pm_max_region = %d\n"
.LC164:
	.string	"load_l2p_region no ppa = %x , %x, all setting 0xff....\n"
.LC165:
	.string	"load_l2p_region = %x,%x,%x, %x\n"
.LC166:
	.string	"pm_ppa:"
.LC167:
	.string	"data:"
.LC168:
	.string	"spare:"
	.section	.rodata.lpa_rebuild_hash.str1.1,"aMS",@progbits,1
.LC72:
	.string	"%s %d %d\n"
	.section	.rodata.micron_read_retrial.str1.1,"aMS",@progbits,1
.LC103:
	.string	"micron %d row=%x,count %d,status=%d\n"
.LC104:
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
	.string	"MultiPlaneProgCmd: %x %x\n"
.LC29:
	.string	"MultiPlaneReadCmd: %x %x\n"
.LC30:
	.string	"g_flash_toggle_mode_en: %x\n"
	.section	.rodata.nandc_init.str1.1,"aMS",@progbits,1
.LC85:
	.string	"...%s enter... %p\n"
.LC86:
	.string	"0:%x %x %x %x %x\n"
.LC87:
	.string	"g_nandc_ver...%d\n"
	.section	.rodata.nandc_xfer.str1.1,"aMS",@progbits,1
.LC99:
	.string	"dqs data abort %x\n"
.LC100:
	.string	"dqs data timeout %x\n"
.LC101:
	.string	"xfer error %x\n"
	.section	.rodata.nandc_xfer_done.str1.1,"aMS",@progbits,1
.LC94:
	.string	"flash_abort_clear = %d\n"
.LC95:
	.string	"%d mtrans_cnt = %d page_num = %d\n"
.LC96:
	.string	"nandc:"
.LC97:
	.string	"%d flReg.d32=%x %x\n"
.LC98:
	.string	"nandc_xfer_done read error %x\n"
	.section	.rodata.pm_alloc_new_blk.str1.1,"aMS",@progbits,1
.LC70:
	.string	"blk %x is bad block\n"
.LC71:
	.string	"pm_alloc_new_blk: %x %x %x %x\n"
	.section	.rodata.pm_free_sblk.str1.1,"aMS",@progbits,1
.LC83:
	.string	"ftl_free_no_use_map_blk %x %x %x %d\n"
	.section	.rodata.pm_init.str1.1,"aMS",@progbits,1
.LC169:
	.string	"pm_init posr %x %x %x\n"
.LC170:
	.string	"pm_init recovery %x %x %x\n"
	.section	.rodata.pm_log2phys.str1.1,"aMS",@progbits,1
.LC171:
	.string	"pm_log2phys  lpn = %d, max lpn = %d\n"
	.section	.rodata.pm_ppa_update_check.str1.1,"aMS",@progbits,1
.LC162:
	.string	"%s w error lpn = %x, max ppa = %d\n"
	.section	.rodata.pm_write_page.str1.1,"aMS",@progbits,1
.LC145:
	.string	"pm_write_page write error: %x\n"
	.section	.rodata.print_ftl_debug_info.str1.1,"aMS",@progbits,1
.LC61:
	.string	"free blk: s:%x,t:%x,m:%x, data blk:s:%x,%x,t%x vpn: s:%x t:%x, max_vpn: %x\n"
.LC62:
	.string	"totle w: %d MB,r: %d MB %d dv:0x%X,poc:%d\n"
.LC63:
	.string	"gc xlc page: %d,gc slc page: %d, tmp w: %d MB\n"
.LC64:
	.string	"slc ec: %d,%d,%d,%d,%d,tlc ec: %d,%d,%d,%d,%d\n"
.LC65:
	.string	"gc th: tlc_tlc: %d tlc_slc: %d slc_slc: %d slc_tlc:%d free_th: %d\n"
	.section	.rodata.print_gc_debug_info.str1.1,"aMS",@progbits,1
.LC46:
	.string	"gc: b:%x,p:%x,i:%x; free buf=%d %d free slc th: %d\n"
	.section	.rodata.print_list_info.str1.1,"aMS",@progbits,1
.LC53:
	.string	"list count:%p %d\n"
.LC54:
	.string	"%d: node:%x %x %x %x, %d %d %d %d %d\n"
	.section	.rodata.queue_wait_first_req_completed.str1.1,"aMS",@progbits,1
.LC118:
	.string	"read: %x %x %x %x\n"
.LC119:
	.string	"set buf %d,status = %x, ppa = %x lun state = %d\n"
	.section	.rodata.random_seed,"a",@progbits
	.align	3
	.set	.LANCHOR48,. + 0
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
.LC187:
	.string	"zftl_init %x\n"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",@progbits,1
.LC88:
	.string	"%s 0x%x:"
.LC89:
	.string	"%x "
.LC90:
	.string	""
.LC91:
	.string	"%s\n"
	.section	.rodata.sandisk_prog_test_bad_block.str1.1,"aMS",@progbits,1
.LC39:
	.string	"bad block test:%x %x\n"
	.section	.rodata.sblk_prog_page.str1.1,"aMS",@progbits,1
.LC126:
	.string	"sblk_prog_page ppa = %x, count = %d\n"
	.section	.rodata.toshiba_15ref_value,"a",@progbits
	.align	3
	.set	.LANCHOR21,. + 0
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
	.set	.LANCHOR31,. + 0
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
	.set	.LANCHOR30,. + 0
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
.LC105:
	.string	"toshiba SRR %d row=%x, status=%d\n"
.LC106:
	.string	"toshiba TRR %d row=%x, status=%d\n"
.LC107:
	.string	"toshiba RR %d row=%x,count %d,status=%d\n"
	.section	.rodata.toshiba_A19ref_value,"a",@progbits
	.align	3
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
	.section	.rodata.toshiba_ref_value,"a",@progbits
	.align	3
	.set	.LANCHOR24,. + 0
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
.LC216:
	.string	"ftl_discard:(%x, %x, %x, %x)\n"
	.section	.rodata.zftl_do_gc.str1.1,"aMS",@progbits,1
.LC211:
	.string	"gc %d: %d %d %d %d %d %d %d\n"
.LC212:
	.string	"gc %d: %d %d %d %d %d %d\n"
.LC213:
	.string	"GC_STATE_SCAN_ALL_PAGE = %x, vpn0 = %d, vpn1 = %d\n"
.LC214:
	.string	"gc free %x, %d\n"
	.section	.rodata.zftl_gc_get_free_sblk.str1.1,"aMS",@progbits,1
.LC49:
	.string	"swl_tlc_free_mini_ec_blk alloc sblk %x\n"
.LC50:
	.string	"zftl_get_free_sblk %x %d, %p %d %d\n"
.LC51:
	.string	"zftl_gc_get_free_sblk %x %x %x, %d %d %d\n"
	.section	.rodata.zftl_get_free_sblk.str1.1,"aMS",@progbits,1
.LC52:
	.string	"swl_slc_free_mini_ec_blk alloc sblk %x\n"
	.section	.rodata.zftl_init.str1.1,"aMS",@progbits,1
.LC175:
	.string	"FTL version: 6.0.8 20180615"
.LC176:
	.string	"_c_user_data_density := %d\n"
.LC177:
	.string	"_c_totle_phy_density := %d\n"
.LC178:
	.string	"_c_totle_log_page := %d\n"
.LC179:
	.string	"_c_totle_data_density := %d\n"
.LC180:
	.string	"_c_ftl_pm_page_num := %d\n"
.LC181:
	.string	"_c_ftl_byte_pre_page := %d\n"
.LC182:
	.string	"_c_max_pm_sblk := %d\n"
.LC183:
	.string	"_min_slc_super_block := %d\n"
.LC184:
	.string	"_max_xlc_super_block := %d\n"
.LC185:
	.string	"gp_ftl_ext_info %p %p %p\n"
.LC186:
	.string	"flash info size: %d %d %d\n"
	.section	.rodata.zftl_read.str1.1,"aMS",@progbits,1
.LC199:
	.string	"ftl_read %x %x %x\n"
.LC200:
	.string	"ftl_read refresh =%x, lpa = %x, ppa= %x\n"
.LC201:
	.string	"id=%d, lpa = %x, ppa = %x spare = %x %x %x %x\n"
	.section	.rodata.zftl_sblk_list_init.str1.1,"aMS",@progbits,1
.LC82:
	.string	"free blk vpn error: %x %x\n"
	.section	.rodata.zftl_write.str1.1,"aMS",@progbits,1
.LC215:
	.string	"ftlwrite %x %x %x\n"
	.hidden	free
