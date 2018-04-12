/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2018-04-11
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
	.section	.text._list_remove_node,"ax",@progbits
	.align	2
	.type	_list_remove_node, %function
_list_remove_node:
	stp	x29, x30, [sp, -64]!
	and	w1, w1, 65535
	mov	w3, 6
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR0
	stp	x19, x20, [sp, 16]
	umull	x20, w1, w3
	stp	x23, x24, [sp, 48]
	mov	w1, 65535
	ldr	x24, [x21, #:lo12:.LANCHOR0]
	add	x19, x24, x20
	ldrh	w4, [x24, x20]
	ldrh	w3, [x19, 2]
	cmp	w4, w1
	ldr	x1, [x0]
	bne	.L7
	cmp	w3, w4
	bne	.L7
	cmp	x19, x1
	bne	.L6
.L7:
	mov	x22, x0
	mov	x23, x2
	mov	w0, 65535
	cmp	w3, w0
	bne	.L9
	cmp	x19, x1
	beq	.L9
	adrp	x1, .LANCHOR1
	adrp	x0, .LC0
	mov	w2, 184
	add	x1, x1, :lo12:.LANCHOR1
	add	x0, x0, :lo12:.LC0
	bl	printf
.L9:
	ldr	x0, [x22]
	ldrh	w3, [x24, x20]
	cmp	x19, x0
	mov	w0, 65535
	bne	.L10
	cmp	w3, w0
	bne	.L11
	str	xzr, [x22]
.L12:
	mov	w0, -1
	strh	w0, [x24, x20]
	strh	w0, [x19, 2]
	ldrh	w0, [x23]
	sub	w0, w0, #1
	strh	w0, [x23]
.L6:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L11:
	ldr	x0, [x21, #:lo12:.LANCHOR0]
	mov	w1, 6
	umaddl	x3, w3, w1, x0
	mov	w0, -1
	str	x3, [x22]
	strh	w0, [x3, 2]
	b	.L12
.L10:
	cmp	w3, w0
	ldrh	w0, [x19, 2]
	bne	.L13
	cmp	w0, w3
	beq	.L12
	mov	w1, 6
	mov	w2, -1
	umull	x0, w0, w1
	ldr	x1, [x21, #:lo12:.LANCHOR0]
	strh	w2, [x1, x0]
	b	.L12
.L13:
	ldr	x1, [x21, #:lo12:.LANCHOR0]
	mov	w2, 6
	umaddl	x4, w3, w2, x1
	strh	w0, [x4, 2]
	ldrh	w0, [x19, 2]
	umull	x0, w0, w2
	strh	w3, [x1, x0]
	b	.L12
	.size	_list_remove_node, .-_list_remove_node
	.section	.text._list_pop_index_node,"ax",@progbits
	.align	2
	.type	_list_pop_index_node, %function
_list_pop_index_node:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldr	x20, [x0]
	cbz	x20, .L21
	adrp	x3, .LANCHOR0
	and	w1, w1, 65535
	mov	w4, 65535
	mov	w5, 6
	ldr	x19, [x3, #:lo12:.LANCHOR0]
.L17:
	cbnz	w1, .L18
.L20:
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
.L15:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L18:
	ldrh	w3, [x20]
	cmp	w3, w4
	beq	.L20
	sub	w1, w1, #1
	umaddl	x20, w3, w5, x19
	and	w1, w1, 65535
	b	.L17
.L21:
	mov	w0, 65535
	b	.L15
	.size	_list_pop_index_node, .-_list_pop_index_node
	.section	.text._insert_free_list,"ax",@progbits
	.align	2
	.type	_insert_free_list, %function
_insert_free_list:
	adrp	x3, .LANCHOR2
	and	w1, w1, 65535
	ldrh	w3, [x3, #:lo12:.LANCHOR2]
	cmp	w3, w1
	bls	.L23
	ldrh	w3, [x2]
	mov	w5, 6
	ldr	x8, [x0]
	add	w3, w3, 1
	strh	w3, [x2]
	adrp	x2, .LANCHOR0
	umull	x12, w1, w5
	ldr	x6, [x2, #:lo12:.LANCHOR0]
	mov	w2, -1
	add	x7, x6, x12
	strh	w2, [x7, 2]
	strh	w2, [x6, x12]
	cbnz	x8, .L25
.L30:
	str	x7, [x0]
	ret
.L25:
	adrp	x2, .LANCHOR3
	mov	x3, -6148914691236517206
	movk	x3, 0xaaab, lsl 0
	mov	w10, w5
	ldr	x11, [x2, #:lo12:.LANCHOR3]
	ubfiz	x2, x1, 2, 16
	mov	w14, 65535
	ldr	w4, [x11, x2]
	ldrh	w2, [x11, x2]
	ubfx	x4, x4, 11, 8
	and	w2, w2, 2047
	add	w4, w2, w4, lsl 3
	sub	x2, x8, x6
	asr	x2, x2, 1
	and	w4, w4, 4095
	mul	x2, x2, x3
	mov	x3, x8
	and	w2, w2, 65535
.L28:
	ubfiz	x13, x2, 2, 16
	ldr	w5, [x11, x13]
	ldrh	w13, [x11, x13]
	ubfx	x5, x5, 11, 8
	and	w13, w13, 2047
	add	w5, w13, w5, lsl 3
	and	w5, w5, 4095
	cmp	w4, w5
	bls	.L26
	ldrh	w5, [x3]
	cmp	w5, w14
	bne	.L27
	strh	w2, [x7, 2]
	strh	w1, [x3]
	ret
.L27:
	umaddl	x3, w5, w10, x6
	mov	w2, w5
	b	.L28
.L26:
	ldrh	w4, [x3, 2]
	cmp	x8, x3
	strh	w4, [x7, 2]
	strh	w2, [x6, x12]
	bne	.L29
	strh	w1, [x8, 2]
	b	.L30
.L29:
	ldrh	w0, [x3, 2]
	mov	w2, 6
	umull	x0, w0, w2
	strh	w1, [x6, x0]
	strh	w1, [x3, 2]
.L23:
	ret
	.size	_insert_free_list, .-_insert_free_list
	.section	.text._insert_data_list,"ax",@progbits
	.align	2
	.type	_insert_data_list, %function
_insert_data_list:
	adrp	x4, .LANCHOR2
	and	w1, w1, 65535
	ldrh	w3, [x4, #:lo12:.LANCHOR2]
	cmp	w3, w1
	bls	.L47
	ldrh	w3, [x2]
	mov	w11, 6
	ldr	x8, [x0]
	add	w3, w3, 1
	strh	w3, [x2]
	adrp	x2, .LANCHOR0
	umull	x13, w1, w11
	ldr	x6, [x2, #:lo12:.LANCHOR0]
	mov	w2, -1
	add	x7, x6, x13
	strh	w2, [x7, 2]
	strh	w2, [x6, x13]
	cbnz	x8, .L34
	str	x7, [x0]
	ret
.L34:
	stp	x29, x30, [sp, -32]!
	adrp	x2, .LANCHOR4
	mov	x3, -6148914691236517206
	mov	w12, -1
	add	x29, sp, 0
	ldr	x15, [x2, #:lo12:.LANCHOR4]
	ubfiz	x2, x1, 1, 16
	movk	x3, 0xaaab, lsl 0
	ldrh	w30, [x4, #:lo12:.LANCHOR2]
	mov	x5, x8
	stp	x19, x20, [sp, 16]
	mov	w10, 0
	mov	w19, 65535
	ldrh	w16, [x15, x2]
	ldrh	w2, [x7, 4]
	cmp	w2, 0
	mul	w14, w16, w2
	sub	x2, x8, x6
	asr	x2, x2, 1
	csel	w14, w14, w12, ne
	mul	x2, x2, x3
	adrp	x3, .LANCHOR3
	ldr	x17, [x3, #:lo12:.LANCHOR3]
	and	w2, w2, 65535
.L42:
	add	w10, w10, 1
	and	w10, w10, 65535
	cmp	w10, w30
	bhi	.L31
	cmp	w1, w2
	beq	.L31
	uxtw	x4, w2
	ldrh	w20, [x5, 4]
	cmp	w20, 0
	ldrh	w3, [x15, x4, lsl 1]
	mul	w3, w3, w20
	csel	w3, w3, w12, ne
	cmp	w14, w3
	bne	.L38
	lsl	x4, x4, 2
	ldr	w3, [x17, x4]
	ldrh	w4, [x17, x4]
	ubfx	x3, x3, 11, 8
	and	w4, w4, 2047
	add	w3, w4, w3, lsl 3
	and	w3, w3, 4095
	cmp	w16, w3
	bhi	.L40
.L39:
	ldrh	w3, [x5, 2]
	cmp	x8, x5
	strh	w3, [x7, 2]
	strh	w2, [x6, x13]
	bne	.L43
	strh	w1, [x8, 2]
	str	x7, [x0]
	b	.L31
.L38:
	bcc	.L39
.L40:
	ldrh	w3, [x5]
	cmp	w3, w19
	bne	.L41
	strh	w2, [x7, 2]
	strh	w1, [x5]
.L31:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L41:
	umaddl	x5, w3, w11, x6
	mov	w2, w3
	b	.L42
.L43:
	ldrh	w0, [x5, 2]
	mov	w2, 6
	umull	x0, w0, w2
	strh	w1, [x6, x0]
	strh	w1, [x5, 2]
	b	.L31
.L47:
	ret
	.size	_insert_data_list, .-_insert_data_list
	.section	.text._list_get_gc_head_node.isra.2,"ax",@progbits
	.align	2
	.type	_list_get_gc_head_node.isra.2, %function
_list_get_gc_head_node.isra.2:
	and	w1, w1, 65535
	cbz	x0, .L54
	adrp	x2, .LANCHOR0
	mov	w3, 65535
	mov	w4, 6
	ldr	x2, [x2, #:lo12:.LANCHOR0]
.L51:
	cbz	w1, .L52
	ldrh	w0, [x0]
	cmp	w0, w3
	bne	.L53
	ret
.L53:
	sub	w1, w1, #1
	umaddl	x0, w0, w4, x2
	and	w1, w1, 65535
	b	.L51
.L54:
	mov	w0, 65535
	ret
.L52:
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
	adrp	x1, .LANCHOR5
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldr	x1, [x1, #:lo12:.LANCHOR5]
	ldrh	w3, [x1, 16]
	str	x25, [sp, 64]
	cmp	w3, w19
	beq	.L56
	ldrh	w3, [x1, 48]
	cmp	w3, w19
	beq	.L56
	ldrh	w1, [x1, 80]
	cmp	w1, w19
	beq	.L56
	adrp	x1, .LANCHOR0
	mov	w22, 6
	ldr	x3, [x0]
	mov	x25, x1
	umull	x22, w19, w22
	ldr	x24, [x1, #:lo12:.LANCHOR0]
	add	x23, x24, x22
	cmp	x23, x3
	beq	.L56
	mov	x20, x0
	ldrh	w0, [x23, 2]
	mov	w1, 65535
	mov	x21, x2
	cmp	w0, w1
	bne	.L60
	ldrh	w1, [x24, x22]
	cmp	w1, w0
	bne	.L60
	adrp	x1, .LANCHOR6
	adrp	x0, .LC0
	mov	w2, 251
	add	x1, x1, :lo12:.LANCHOR6
	add	x0, x0, :lo12:.LC0
	bl	printf
.L60:
	ldrh	w1, [x23, 2]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L61
	ldrh	w0, [x24, x22]
	cmp	w0, w1
	beq	.L56
.L61:
	adrp	x0, .LANCHOR4
	ubfiz	x2, x19, 1, 16
	mov	x5, -6148914691236517206
	mov	w4, -1
	ldr	x0, [x0, #:lo12:.LANCHOR4]
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
	ldr	x2, [x25, #:lo12:.LANCHOR0]
	add	x1, x2, x1
	ldrh	w1, [x1, 4]
	cmp	w1, 0
	mul	w0, w0, w1
	csel	w0, w0, w4, ne
	cmp	w3, w0
	bcs	.L56
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
.L56:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
	.size	_list_update_data_list, .-_list_update_data_list
	.section	.text.nand_flash_print_info,"ax",@progbits
	.align	2
	.global	nand_flash_print_info
	.type	nand_flash_print_info, %function
nand_flash_print_info:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR7
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L68
	adrp	x1, .LANCHOR8
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR8
	add	x0, x0, :lo12:.LC1
	bl	printf
.L68:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L69
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w6, [x0, 6]
	ldrb	w5, [x0, 5]
	ldrb	w4, [x0, 4]
	ldrb	w3, [x0, 3]
	ldrb	w2, [x0, 2]
	ldrb	w1, [x0, 1]
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
.L69:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L70
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w1, [x0, 8]
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
.L70:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L71
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w1, [x0, 9]
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
.L71:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L72
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, 10]
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
.L72:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L73
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w1, [x0, 12]
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
.L73:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L74
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w1, [x0, 13]
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
.L74:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L75
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, 14]
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
.L75:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L76
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w1, [x0, 23]
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
.L76:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L77
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w1, [x0, 18]
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	printf
.L77:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L78
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w1, [x0, 19]
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	printf
.L78:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L79
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w1, [x0, 20]
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	bl	printf
.L79:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L80
	adrp	x0, .LANCHOR10
	ldrb	w1, [x0, #:lo12:.LANCHOR10]
	adrp	x0, .LC13
	add	x0, x0, :lo12:.LC13
	bl	printf
.L80:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L81
	adrp	x0, .LANCHOR11
	ldrb	w1, [x0, #:lo12:.LANCHOR11]
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printf
.L81:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L82
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w1, [x0, 22]
	adrp	x0, .LC15
	add	x0, x0, :lo12:.LC15
	bl	printf
.L82:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L83
	adrp	x0, .LANCHOR12
	ldrb	w1, [x0, #:lo12:.LANCHOR12]
	adrp	x0, .LC16
	add	x0, x0, :lo12:.LC16
	bl	printf
.L83:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L84
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w1, [x0, 16]
	adrp	x0, .LC17
	add	x0, x0, :lo12:.LC17
	and	w1, w1, 1
	bl	printf
.L84:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L85
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC18
	add	x0, x0, :lo12:.LC18
	ubfx	x1, x1, 1, 1
	bl	printf
.L85:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L86
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC19
	add	x0, x0, :lo12:.LC19
	ubfx	x1, x1, 2, 1
	bl	printf
.L86:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L87
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC20
	add	x0, x0, :lo12:.LC20
	ubfx	x1, x1, 3, 1
	bl	printf
.L87:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L88
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC21
	add	x0, x0, :lo12:.LC21
	ubfx	x1, x1, 4, 1
	bl	printf
.L88:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L89
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC22
	add	x0, x0, :lo12:.LC22
	ubfx	x1, x1, 5, 1
	bl	printf
.L89:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L90
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC23
	add	x0, x0, :lo12:.LC23
	ubfx	x1, x1, 6, 1
	bl	printf
.L90:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L91
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	ubfx	x1, x1, 7, 1
	bl	printf
.L91:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L92
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w1, [x0, 17]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	and	w1, w1, 1
	bl	printf
.L92:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L93
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC26
	add	x0, x0, :lo12:.LC26
	ubfx	x1, x1, 9, 1
	bl	printf
.L93:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L94
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC27
	add	x0, x0, :lo12:.LC27
	ubfx	x1, x1, 10, 1
	bl	printf
.L94:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L95
	adrp	x0, .LANCHOR11
	ldrb	w1, [x0, #:lo12:.LANCHOR11]
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printf
.L95:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L96
	adrp	x0, .LANCHOR13
	add	x0, x0, :lo12:.LANCHOR13
	ldrb	w2, [x0, 11]
	ldrb	w1, [x0, 10]
	adrp	x0, .LC28
	add	x0, x0, :lo12:.LC28
	bl	printf
.L96:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L97
	adrp	x0, .LANCHOR13
	add	x0, x0, :lo12:.LANCHOR13
	ldrb	w2, [x0, 9]
	ldrb	w1, [x0, 8]
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	bl	printf
.L97:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L67
	adrp	x0, .LANCHOR14
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ldrb	w1, [x0, #:lo12:.LANCHOR14]
	adrp	x0, .LC30
	add	x0, x0, :lo12:.LC30
	b	printf
.L67:
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
.L191:
	ldr	w0, [sp, 12]
	sub	w1, w0, #1
	str	w1, [sp, 12]
	cbnz	w0, .L191
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
	adrp	x6, .LANCHOR19
	add	x6, x6, :lo12:.LANCHOR19
	adrp	x3, .LANCHOR15
	add	x3, x3, :lo12:.LANCHOR15
	umull	x2, w2, w0
	adrp	x0, .LANCHOR16
	add	x7, x0, :lo12:.LANCHOR16
	mov	x5, x0
	ldrb	w0, [x6]
	add	x3, x3, x2
	add	x7, x7, x2
	adrp	x8, .LANCHOR17
	mov	x2, 0
	adrp	x10, .LANCHOR18
	add	x8, x8, :lo12:.LANCHOR17
	add	x10, x10, :lo12:.LANCHOR18
	cmp	w0, w2
	bhi	.L204
	ret
.L198:
	cmp	w0, 35
	bne	.L200
	ldrsb	w0, [x3, x2]
	b	.L205
.L200:
	ldrsb	w0, [x10, w11, sxtw]
	b	.L205
.L204:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L201:
	mov	w0, 85
	str	w0, [x4, 8]
	add	x0, x5, :lo12:.LANCHOR16
	ldrsb	w0, [x2, x0]
	str	w0, [x4, 4]
	mov	w0, 200
	bl	timer_delay_ns
	ldrb	w0, [x8]
	cmp	w0, 34
	bne	.L198
	ldrsb	w0, [x7, x2]
.L205:
	str	w0, [x4]
	add	x2, x2, 1
	ldrb	w0, [x6]
	cmp	w0, w2
	bhi	.L201
	ldp	x29, x30, [sp], 16
	ret
	.size	toshiba_set_rr_para, .-toshiba_set_rr_para
	.section	.text.hynix_set_rr_para,"ax",@progbits
	.align	2
	.type	hynix_set_rr_para, %function
hynix_set_rr_para:
	adrp	x2, .LANCHOR20
	and	w1, w1, 255
	mov	x3, 32
	and	w0, w0, 255
	ldr	x2, [x2, #:lo12:.LANCHOR20]
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
	adrp	x1, .LANCHOR21
	ldr	x3, [x1, #:lo12:.LANCHOR21]
	add	x3, x3, x0
	mov	w0, 54
	str	w0, [x3, 2056]
	bhi	.L212
	mov	w0, 22
	str	w0, [x3, 2056]
	ret
.L212:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L208:
	ldrb	w0, [x6, x4]
	str	w0, [x3, 2052]
	mov	w0, 120
	bl	timer_delay_ns
	ldrsb	w0, [x2, x4]
	str	w0, [x3, 2048]
	add	x4, x4, 1
	cmp	w5, w4, uxtb
	bhi	.L208
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
	adrp	x1, .LANCHOR17
	ldrb	w1, [x1, #:lo12:.LANCHOR17]
	sub	w1, w1, #1
	and	w1, w1, 255
	cmp	w1, 6
	bhi	.L219
	adrp	x8, .LANCHOR20
	and	w0, w0, 255
	sxtw	x7, w0
	ldr	x1, [x8, #:lo12:.LANCHOR20]
	add	x1, x1, x7
	ldrb	w1, [x1, 120]
	cbz	w1, .L219
	stp	x29, x30, [sp, -16]!
	mov	w1, 0
	add	x29, sp, 0
	bl	hynix_set_rr_para
	ldr	x0, [x8, #:lo12:.LANCHOR20]
	add	x0, x0, x7
	strb	wzr, [x0, 120]
	ldp	x29, x30, [sp], 16
	ret
.L219:
	ret
	.size	hynix_reconfig_rr_para, .-hynix_reconfig_rr_para
	.section	.text.nandc_set_ddr_para,"ax",@progbits
	.align	2
	.global	nandc_set_ddr_para
	.type	nandc_set_ddr_para, %function
nandc_set_ddr_para:
	adrp	x1, .LANCHOR22
	and	w0, w0, 255
	adrp	x2, .LANCHOR21
	ldrb	w1, [x1, #:lo12:.LANCHOR22]
	ldr	x2, [x2, #:lo12:.LANCHOR21]
	cmp	w1, 9
	lsl	w1, w0, 16
	lsl	w0, w0, 8
	orr	w1, w1, w0
	orr	w1, w1, 3
	bne	.L223
	str	w1, [x2, 80]
	ret
.L223:
	str	w1, [x2, 304]
	ret
	.size	nandc_set_ddr_para, .-nandc_set_ddr_para
	.section	.text.nandc_get_ddr_para,"ax",@progbits
	.align	2
	.global	nandc_get_ddr_para
	.type	nandc_get_ddr_para, %function
nandc_get_ddr_para:
	adrp	x0, .LANCHOR22
	ldrb	w0, [x0, #:lo12:.LANCHOR22]
	cmp	w0, 9
	adrp	x0, .LANCHOR21
	ldr	x0, [x0, #:lo12:.LANCHOR21]
	bne	.L226
	ldr	w0, [x0, 80]
.L228:
	ubfx	x0, x0, 8, 8
	ret
.L226:
	ldr	w0, [x0, 304]
	b	.L228
	.size	nandc_get_ddr_para, .-nandc_get_ddr_para
	.section	.text.nandc_set_if_mode,"ax",@progbits
	.align	2
	.global	nandc_set_if_mode
	.type	nandc_set_if_mode, %function
nandc_set_if_mode:
	adrp	x1, .LANCHOR21
	and	w0, w0, 255
	tst	w0, 6
	ldr	x2, [x1, #:lo12:.LANCHOR21]
	ldr	w1, [x2]
	beq	.L230
	tst	x0, 4
	orr	w1, w1, 24576
	adrp	x0, .LANCHOR22
	and	w1, w1, -32769
	orr	w1, w1, 196608
	ldrb	w0, [x0, #:lo12:.LANCHOR22]
	orr	w3, w1, 32768
	csel	w1, w3, w1, ne
	cmp	w0, 9
	mov	w0, 4099
	movk	w0, 0x10, lsl 16
	bne	.L232
	mov	w3, 8321
	str	w3, [x2, 8]
	str	w0, [x2, 80]
	mov	w0, 38
	str	w0, [x2, 84]
	mov	w0, 39
	str	w0, [x2, 84]
.L233:
	str	w1, [x2]
	ret
.L232:
	mov	w3, 8322
	str	w3, [x2, 344]
	str	w0, [x2, 304]
	mov	w0, 38
	str	w0, [x2, 308]
	mov	w0, 39
	str	w0, [x2, 308]
	b	.L233
.L230:
	and	w1, w1, -8193
	b	.L233
	.size	nandc_set_if_mode, .-nandc_set_if_mode
	.section	.text.nandc_cs,"ax",@progbits
	.align	2
	.global	nandc_cs
	.type	nandc_cs, %function
nandc_cs:
	adrp	x1, .LANCHOR21
	mov	w2, 1
	lsl	w0, w2, w0
	ldr	x3, [x1, #:lo12:.LANCHOR21]
	ldr	w1, [x3]
	bfi	w1, w0, 0, 8
	str	w1, [x3]
	ret
	.size	nandc_cs, .-nandc_cs
	.section	.text.nandc_de_cs,"ax",@progbits
	.align	2
	.global	nandc_de_cs
	.type	nandc_de_cs, %function
nandc_de_cs:
	adrp	x0, .LANCHOR21
	ldr	x1, [x0, #:lo12:.LANCHOR21]
	ldr	w0, [x1]
	and	w0, w0, -256
	and	w0, w0, -131073
	str	w0, [x1]
	ret
	.size	nandc_de_cs, .-nandc_de_cs
	.section	.text.flash_wait_device_ready_raw,"ax",@progbits
	.align	2
	.global	flash_wait_device_ready_raw
	.type	flash_wait_device_ready_raw, %function
flash_wait_device_ready_raw:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	str	x21, [sp, 32]
	and	w21, w0, 255
	adrp	x0, .LANCHOR12
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	mov	w20, w2
	ldrb	w0, [x0, #:lo12:.LANCHOR12]
	cmp	w0, w21
	bhi	.L239
	adrp	x1, .LANCHOR23
	adrp	x0, .LC0
	mov	w2, 599
	add	x1, x1, :lo12:.LANCHOR23
	add	x0, x0, :lo12:.LC0
	bl	printf
.L239:
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	ldrb	w5, [x0, w21, sxtw]
	adrp	x0, .LANCHOR21
	ldr	x4, [x0, #:lo12:.LANCHOR21]
	mov	w0, w5
	bl	nandc_cs
	ubfiz	x2, x5, 8, 8
	lsr	w6, w19, 8
	lsr	w7, w19, 16
	and	w19, w19, 255
	add	x2, x4, x2
	mov	w4, 120
.L242:
	str	w4, [x2, 2056]
	mov	w0, 120
	str	w19, [x2, 2052]
	str	w6, [x2, 2052]
	str	w7, [x2, 2052]
	bl	timer_delay_ns
	ldr	w3, [x2, 2048]
	and	w3, w3, 255
	bics	wzr, w20, w3
	bne	.L242
	cmp	w3, 255
	beq	.L242
	mov	w0, w5
	bl	nandc_de_cs
	ldp	x19, x20, [sp, 16]
	mov	w0, w3
	ldr	x21, [sp, 32]
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
	bne	.L246
	adrp	x0, .LANCHOR11
	adrp	x5, .LANCHOR25
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	cbz	w0, .L247
	ldrb	w0, [x5, #:lo12:.LANCHOR25]
	cbz	w0, .L246
.L247:
	adrp	x0, .LANCHOR26
	ldrh	w3, [x0, #:lo12:.LANCHOR26]
	ldrb	w0, [x5, #:lo12:.LANCHOR25]
	udiv	w4, w1, w3
	mul	w4, w4, w3
	sub	w3, w1, w4
	cbz	w0, .L248
	add	w1, w4, w3, lsl 1
.L246:
	mov	w0, w6
	b	flash_wait_device_ready_raw
.L248:
	adrp	x5, .LANCHOR27
	add	x5, x5, :lo12:.LANCHOR27
	ldrh	w3, [x5, w3, uxtw 1]
	add	w1, w3, w4
	b	.L246
	.size	flash_wait_device_ready, .-flash_wait_device_ready
	.section	.text.nandc_wait_flash_ready,"ax",@progbits
	.align	2
	.global	nandc_wait_flash_ready
	.type	nandc_wait_flash_ready, %function
nandc_wait_flash_ready:
	mov	w2, 34464
	stp	x29, x30, [sp, -32]!
	movk	w2, 0x1, lsl 16
	adrp	x3, .LANCHOR21
	add	x29, sp, 0
.L257:
	mov	w0, 100
	bl	timer_delay_ns
	ldr	x0, [x3, #:lo12:.LANCHOR21]
	ldr	w0, [x0]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbnz	x0, 9, .L258
	subs	w2, w2, #1
	bne	.L257
	mov	w0, -1
.L255:
	ldp	x29, x30, [sp], 32
	ret
.L258:
	mov	w0, 0
	b	.L255
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
	adrp	x0, .LANCHOR19
	adrp	x2, .LANCHOR15
	add	x2, x2, :lo12:.LANCHOR15
	ldrb	w4, [x0, #:lo12:.LANCHOR19]
	adrp	x0, .LANCHOR17
	ldrb	w5, [x0, #:lo12:.LANCHOR17]
	mov	w0, 5
	umull	x1, w1, w0
	adrp	x0, .LANCHOR16
	add	x0, x0, :lo12:.LANCHOR16
	add	x2, x2, x1
	add	x1, x0, x1
	mov	x0, 0
.L262:
	cmp	w4, w0
	bhi	.L265
	ldp	x29, x30, [sp], 16
	b	nandc_wait_flash_ready
.L265:
	cmp	w5, 67
	bne	.L263
	ldrsb	w6, [x1, x0]
.L267:
	add	x0, x0, 1
	str	w6, [x3]
	b	.L262
.L263:
	ldrsb	w6, [x2, x0]
	b	.L267
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
	adrp	x0, .LANCHOR28
	add	x0, x0, :lo12:.LANCHOR28
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
	adrp	x2, .LANCHOR29
	add	x2, x2, :lo12:.LANCHOR29
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
	cbz	w2, .L272
	stp	x29, x30, [sp, -16]!
	mov	x4, x0
	mov	x2, 7
	mov	w0, 18
	add	x29, sp, 0
	str	w6, [x4, 8]
	mul	x1, x1, x2
	str	w0, [x4, 4]
	adrp	x0, .LANCHOR30
	add	x0, x0, :lo12:.LANCHOR30
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
.L275:
	b	nandc_wait_flash_ready
.L272:
	str	w6, [x0, 8]
	mov	w2, 20
	str	w2, [x0, 4]
	adrp	x2, .LANCHOR31
	add	x2, x2, :lo12:.LANCHOR31
	ldrb	w1, [x2, x1]
	str	w1, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	b	.L275
	.size	toshiba_tlc_set_rr_para, .-toshiba_tlc_set_rr_para
	.section	.text.zftl_flash_enter_slc_mode,"ax",@progbits
	.align	2
	.global	zftl_flash_enter_slc_mode
	.type	zftl_flash_enter_slc_mode, %function
zftl_flash_enter_slc_mode:
	adrp	x1, .LANCHOR11
	and	x0, x0, 255
	ldrb	w2, [x1, #:lo12:.LANCHOR11]
	cbz	w2, .L278
	adrp	x1, .LANCHOR21
	cmp	w2, 1
	ldr	x1, [x1, #:lo12:.LANCHOR21]
	bne	.L281
.L298:
	adrp	x2, .LANCHOR32+29
	ldrb	w2, [x2, #:lo12:.LANCHOR32+29]
	cbz	w2, .L278
	add	x0, x0, 8
	add	x0, x1, x0, lsl 8
	str	w2, [x0, 8]
	ret
.L281:
	cmp	w2, 2
	bne	.L283
	adrp	x2, .LANCHOR33
	add	x2, x2, :lo12:.LANCHOR33
	ldrb	w3, [x2, x0]
	cbz	w3, .L278
	strb	wzr, [x2, x0]
	b	.L298
.L283:
	cmp	w2, 3
	bne	.L278
	adrp	x2, .LANCHOR33
	sxtw	x3, w0
	add	x2, x2, :lo12:.LANCHOR33
	ldrb	w4, [x2, x3]
	cbz	w4, .L278
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
.L278:
	ret
	.size	zftl_flash_enter_slc_mode, .-zftl_flash_enter_slc_mode
	.section	.text.zftl_flash_exit_slc_mode,"ax",@progbits
	.align	2
	.global	zftl_flash_exit_slc_mode
	.type	zftl_flash_exit_slc_mode, %function
zftl_flash_exit_slc_mode:
	adrp	x1, .LANCHOR11
	and	x0, x0, 255
	ldrb	w2, [x1, #:lo12:.LANCHOR11]
	cbz	w2, .L299
	adrp	x1, .LANCHOR21
	cmp	w2, 1
	ldr	x1, [x1, #:lo12:.LANCHOR21]
	bne	.L302
	adrp	x2, .LANCHOR32+30
	ldrb	w2, [x2, #:lo12:.LANCHOR32+30]
.L319:
	cbz	w2, .L299
	add	x0, x0, 8
	add	x0, x1, x0, lsl 8
	str	w2, [x0, 8]
	ret
.L302:
	cmp	w2, 2
	bne	.L304
	adrp	x3, .LANCHOR33
	add	x3, x3, :lo12:.LANCHOR33
	ldrb	w2, [x3, x0]
	cbnz	w2, .L299
	adrp	x2, .LANCHOR32
	add	x2, x2, :lo12:.LANCHOR32
	mov	w5, 4
	ldrb	w4, [x2, 12]
	ldrb	w2, [x2, 30]
	cmp	w4, 2
	csel	w4, w4, w5, eq
	strb	w4, [x3, x0]
	b	.L319
.L304:
	cmp	w2, 3
	bne	.L299
	adrp	x3, .LANCHOR33
	sxtw	x4, w0
	add	x3, x3, :lo12:.LANCHOR33
	ldrb	w2, [x3, x4]
	cbnz	w2, .L299
	ubfiz	x0, x0, 8, 8
	adrp	x2, .LANCHOR32+12
	add	x0, x1, x0
	mov	w1, 239
	ldrb	w2, [x2, #:lo12:.LANCHOR32+12]
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
.L299:
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
	adrp	x0, .LANCHOR12
	stp	x21, x22, [sp, 32]
	ubfx	x22, x1, 21, 3
	and	w19, w1, 2097151
	ldrb	w0, [x0, #:lo12:.LANCHOR12]
	ubfx	x21, x1, 24, 2
	cmp	w0, w22
	bhi	.L321
	adrp	x1, .LANCHOR34
	adrp	x0, .LC0
	mov	w2, 736
	add	x1, x1, :lo12:.LANCHOR34
	add	x0, x0, :lo12:.LC0
	bl	printf
.L321:
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	ldrb	w7, [x0, w22, sxtw]
	adrp	x0, .LANCHOR21
	ldr	x6, [x0, #:lo12:.LANCHOR21]
	mov	w0, w7
	bl	nandc_cs
	cbnz	w21, .L322
	adrp	x0, .LANCHOR11
	adrp	x1, .LANCHOR25
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	cbz	w0, .L323
	ldrb	w0, [x1, #:lo12:.LANCHOR25]
	cbz	w0, .L324
.L323:
	adrp	x0, .LANCHOR26
	ldrb	w1, [x1, #:lo12:.LANCHOR25]
	ldrh	w2, [x0, #:lo12:.LANCHOR26]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L325
	add	w19, w0, w19, lsl 1
.L324:
	mov	w0, w7
	bl	zftl_flash_enter_slc_mode
	b	.L326
.L325:
	adrp	x1, .LANCHOR27
	add	x1, x1, :lo12:.LANCHOR27
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
.L326:
	ubfiz	x0, x7, 8, 8
	and	w1, w19, 255
	add	x0, x6, x0
	ldp	x21, x22, [sp, 32]
	str	wzr, [x0, 2056]
	str	wzr, [x0, 2052]
	str	wzr, [x0, 2052]
	str	w1, [x0, 2052]
	lsr	w1, w19, 8
	str	w1, [x0, 2052]
	lsr	w19, w19, 16
	str	w19, [x0, 2052]
	str	w20, [x0, 2056]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	nandc_de_cs
.L322:
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L327
	sxtw	x0, w7
	add	x0, x0, 8
	add	x0, x6, x0, lsl 8
	str	w21, [x0, 8]
	b	.L326
.L327:
	mov	w0, w7
	bl	zftl_flash_exit_slc_mode
	b	.L326
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
	adrp	x0, .LANCHOR12
	stp	x21, x22, [sp, 32]
	str	x25, [sp, 64]
	mov	w22, w2
	ldrb	w0, [x0, #:lo12:.LANCHOR12]
	mov	w21, w3
	stp	x23, x24, [sp, 48]
	and	w25, w1, 255
	cmp	w0, w19
	bhi	.L333
	adrp	x1, .LANCHOR35
	adrp	x0, .LC0
	mov	w2, 510
	add	x1, x1, :lo12:.LANCHOR35
	add	x0, x0, :lo12:.LC0
	bl	printf
.L333:
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	ldrb	w20, [x0, w19, sxtw]
	adrp	x0, .LANCHOR21
	ldr	x24, [x0, #:lo12:.LANCHOR21]
	adrp	x0, .LANCHOR7
	and	x19, x20, 255
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	add	x23, x19, 8
	add	x23, x24, x23, lsl 8
	tbz	x0, 4, .L334
	adrp	x0, .LC31
	mov	w3, w21
	mov	w2, w22
	mov	w1, w20
	add	x0, x0, :lo12:.LC31
	bl	printf
.L334:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w25, .L335
	bl	zftl_flash_enter_slc_mode
.L336:
	add	x24, x24, x19, lsl 8
	mov	w0, 96
	str	w0, [x24, 2056]
	and	w0, w22, 255
	str	w0, [x24, 2052]
	lsr	w0, w22, 8
	str	w0, [x24, 2052]
	lsr	w0, w22, 16
	str	w0, [x24, 2052]
	adrp	x0, .LANCHOR36
	ldrb	w0, [x0, #:lo12:.LANCHOR36]
	cbnz	w0, .L339
	mov	w0, 208
	str	w0, [x24, 2056]
	mov	w19, 5
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	and	w5, w0, w19
.L337:
	mov	w0, 96
	str	w0, [x24, 2056]
	and	w0, w21, 255
	str	w0, [x24, 2052]
	lsr	w0, w21, 8
	str	w0, [x24, 2052]
	lsr	w21, w21, 16
	str	w21, [x24, 2052]
	mov	w0, 208
	str	w0, [x24, 2056]
	mov	w19, 5
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	mov	w2, w0
	mov	w0, w20
	bl	nandc_de_cs
	and	w19, w2, w19
	orr	w19, w19, w5
	cbz	w19, .L338
	adrp	x0, .LC32
	mov	w1, w22
	add	x0, x0, :lo12:.LC32
	bl	printf
.L338:
	mov	w0, w19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L335:
	bl	zftl_flash_exit_slc_mode
	b	.L336
.L339:
	mov	w5, 0
	b	.L337
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
	adrp	x0, .LANCHOR12
	stp	x21, x22, [sp, 32]
	str	x25, [sp, 64]
	mov	w21, w2
	ldrb	w0, [x0, #:lo12:.LANCHOR12]
	and	w22, w2, 2097151
	stp	x23, x24, [sp, 48]
	and	w25, w1, 255
	cmp	w0, w19
	bhi	.L348
	adrp	x1, .LANCHOR37
	adrp	x0, .LC0
	mov	w2, 555
	add	x1, x1, :lo12:.LANCHOR37
	add	x0, x0, :lo12:.LC0
	bl	printf
.L348:
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	ldrb	w20, [x0, w19, sxtw]
	adrp	x0, .LANCHOR21
	ldr	x24, [x0, #:lo12:.LANCHOR21]
	adrp	x0, .LANCHOR7
	and	x19, x20, 255
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	add	x23, x19, 8
	add	x23, x24, x23, lsl 8
	tbz	x0, 4, .L349
	adrp	x0, .LC33
	mov	w2, w21
	mov	w1, w20
	add	x0, x0, :lo12:.LC33
	bl	printf
.L349:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w25, .L350
	bl	zftl_flash_enter_slc_mode
.L351:
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
	mov	w0, w20
	bl	nandc_de_cs
	mov	w0, 5
	ands	w19, w19, w0
	beq	.L352
	adrp	x0, .LANCHOR26
	mov	w2, w19
	ldrh	w1, [x0, #:lo12:.LANCHOR26]
	adrp	x0, .LC34
	add	x0, x0, :lo12:.LC34
	udiv	w1, w21, w1
	bl	printf
.L352:
	mov	w0, w19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L350:
	bl	zftl_flash_exit_slc_mode
	b	.L351
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
	adrp	x23, .LANCHOR26
	stp	x21, x22, [sp, 32]
	add	x23, x23, :lo12:.LANCHOR26
	ldrh	w20, [x0, 14]
	adrp	x22, .LANCHOR12
	str	x25, [sp, 64]
	add	x22, x22, :lo12:.LANCHOR12
	adrp	x24, .LANCHOR24
	ldrb	w1, [x0, 13]
	mul	w20, w20, w1
	and	w20, w20, 65535
.L362:
	ldrb	w0, [x22]
	cmp	w0, w19
	bhi	.L365
	ldp	x19, x20, [sp, 16]
	mov	w1, 0
	ldp	x21, x22, [sp, 32]
	adrp	x0, .LC35
	ldp	x23, x24, [sp, 48]
	add	x0, x0, :lo12:.LC35
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	b	printf
.L365:
	add	x0, x24, :lo12:.LANCHOR24
	mov	w21, 0
	ldrb	w25, [x0, w19, sxtw]
.L363:
	cmp	w20, w21, uxth
	bhi	.L364
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L362
.L364:
	ldrh	w1, [x23]
	mov	w0, w25
	mul	w1, w1, w21
	add	w21, w21, 1
	bl	flash_erase_block
	b	.L363
	.size	flash_erase_all, .-flash_erase_all
	.section	.text.flash_set_interface_mode,"ax",@progbits
	.align	2
	.global	flash_set_interface_mode
	.type	flash_set_interface_mode, %function
flash_set_interface_mode:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR38
	stp	x21, x22, [sp, 32]
	adrp	x23, .LANCHOR7
	adrp	x22, .LANCHOR39
	str	x25, [sp, 64]
	add	x24, x24, :lo12:.LANCHOR38
	add	x22, x22, :lo12:.LANCHOR39
	add	x23, x23, :lo12:.LANCHOR7
	mov	w25, w0
	stp	x19, x20, [sp, 16]
	mov	x20, 0
.L377:
	lsl	x0, x20, 3
	ldrb	w21, [x0, x24]
	mov	w0, 69
	cmp	w21, 152
	ccmp	w21, w0, 4, ne
	beq	.L368
	cmp	w21, 44
	bne	.L369
.L368:
	adrp	x0, .LANCHOR21
	ldrb	w1, [x22]
	cmp	w25, 1
	ldr	x19, [x0, #:lo12:.LANCHOR21]
	bne	.L370
	tbz	x1, 0, .L369
	ldr	w0, [x23]
	tbz	x0, 12, .L371
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	bl	printf
.L371:
	add	x0, x19, x20, lsl 8
	mov	w1, 239
	cmp	w21, 44
	str	w1, [x0, 2056]
	mov	w1, 1
	bne	.L372
	str	w1, [x0, 2052]
	mov	w1, 5
.L392:
	str	w1, [x0, 2048]
.L376:
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
.L369:
	add	x20, x20, 1
	cmp	x20, 4
	bne	.L377
	bl	nandc_wait_flash_ready
	ldr	x25, [sp, 64]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L372:
	mov	w2, 128
	str	w2, [x0, 2052]
	b	.L392
.L370:
	tbz	x1, 2, .L369
	ldr	w0, [x23]
	tbz	x0, 12, .L374
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	bl	printf
.L374:
	add	x0, x19, x20, lsl 8
	mov	w1, 239
	cmp	w21, 44
	str	w1, [x0, 2056]
	bne	.L375
	mov	w1, 1
	str	w1, [x0, 2052]
	mov	w1, 35
	b	.L392
.L375:
	mov	w1, 128
	str	w1, [x0, 2052]
	str	wzr, [x0, 2048]
	b	.L376
	.size	flash_set_interface_mode, .-flash_set_interface_mode
	.section	.text.flash_reset,"ax",@progbits
	.align	2
	.global	flash_reset
	.type	flash_reset, %function
flash_reset:
	adrp	x1, .LANCHOR21
	ubfiz	x0, x0, 8, 8
	add	x0, x0, 2048
	ldr	x1, [x1, #:lo12:.LANCHOR21]
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
	adrp	x0, .LANCHOR21
	mov	x8, x1
	add	x29, sp, 0
	ldr	x4, [x0, #:lo12:.LANCHOR21]
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
	mov	w0, w10
	bl	nandc_de_cs
	ldrb	w2, [x8]
	sub	w0, w2, #1
	and	w0, w0, 255
	cmp	w0, 253
	bhi	.L394
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
.L394:
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
	adrp	x2, .LANCHOR21
	ldr	x4, [x2, #:lo12:.LANCHOR21]
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
	adrp	x1, .LANCHOR21
	and	x2, x0, 255
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR32
	ldr	x19, [x1, #:lo12:.LANCHOR21]
	add	x1, x20, :lo12:.LANCHOR32
	str	x21, [sp, 32]
	mov	x0, x2
	add	x2, x2, 8
	ldrb	w1, [x1, 29]
	add	x2, x19, x2, lsl 8
	cbz	w1, .L400
.L414:
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
	beq	.L402
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L402
	adrp	x0, .LC39
	mov	w1, w4
	add	x0, x0, :lo12:.LC39
	bl	printf
.L402:
	add	x20, x20, :lo12:.LANCHOR32
	ldrb	w0, [x20, 30]
	cbz	w0, .L399
	str	w0, [x19, 2056]
.L399:
	mov	w0, w21
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L400:
	mov	w1, 162
	b	.L414
	.size	sandisk_prog_test_bad_block, .-sandisk_prog_test_bad_block
	.section	.text.nandc_rdy_status,"ax",@progbits
	.align	2
	.global	nandc_rdy_status
	.type	nandc_rdy_status, %function
nandc_rdy_status:
	adrp	x0, .LANCHOR21
	sub	sp, sp, #16
	ldr	x0, [x0, #:lo12:.LANCHOR21]
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
	adrp	x2, .LANCHOR40
	mov	w1, 1
	strb	w0, [x2, #:lo12:.LANCHOR40]
	adrp	x2, .LANCHOR22
	ldrb	w2, [x2, #:lo12:.LANCHOR22]
	cmp	w2, 9
	adrp	x2, .LANCHOR21
	ldr	x2, [x2, #:lo12:.LANCHOR21]
	bne	.L418
	str	w1, [x2, 16]
	cmp	w0, 70
	beq	.L425
	cmp	w0, 60
	beq	.L426
	cmp	w0, 40
	cset	w1, eq
	add	w1, w1, 1
.L419:
	lsl	w1, w1, 25
	orr	w1, w1, 1
	str	w1, [x2, 32]
	ret
.L425:
	mov	w1, 0
	b	.L419
.L426:
	mov	w1, 3
	b	.L419
.L418:
	str	w1, [x2, 8]
	cmp	w0, 16
	mov	w1, 4096
	bne	.L421
.L424:
	and	w1, w1, -17
.L422:
	orr	w1, w1, 1
	str	w1, [x2, 12]
	ret
.L421:
	cmp	w0, 24
	bne	.L423
	orr	w1, w1, 16
	b	.L422
.L423:
	orr	w1, w1, 262144
	cmp	w0, 40
	orr	w1, w1, 16
	bne	.L422
	b	.L424
	.size	nandc_bch_sel, .-nandc_bch_sel
	.section	.text.zftl_nandc_get_irq_status,"ax",@progbits
	.align	2
	.global	zftl_nandc_get_irq_status
	.type	zftl_nandc_get_irq_status, %function
zftl_nandc_get_irq_status:
	adrp	x1, .LANCHOR22
	ldrb	w1, [x1, #:lo12:.LANCHOR22]
	cmp	w1, 9
	bne	.L432
	ldr	w0, [x0, 296]
	ret
.L432:
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
	adrp	x4, .LANCHOR43
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w23, w0, 255
	adrp	x0, .LANCHOR22
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	add	w20, w1, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR22]
	adrp	x24, .LANCHOR21
	cmp	w0, 9
	bne	.L438
	ubfiz	w19, w23, 1, 1
	mov	w0, 1
	orr	w19, w19, 8
	asr	w20, w20, 1
	bfi	w19, w0, 5, 2
	adrp	x0, .LANCHOR41
	orr	w19, w19, 536870912
	orr	w19, w19, 1024
	ldrb	w0, [x0, #:lo12:.LANCHOR41]
	and	w19, w19, -17
	bfi	w19, w20, 22, 6
	orr	w19, w19, 128
	cbz	w0, .L439
	adrp	x0, .LANCHOR42
	ldrb	w1, [x0, #:lo12:.LANCHOR42]
	orr	w0, w19, 512
	cmp	w1, 0
	csel	w19, w0, w19, ne
.L439:
	add	x21, x4, :lo12:.LANCHOR43
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
	ldr	x1, [x24, #:lo12:.LANCHOR21]
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
	adrp	x2, .LANCHOR44
	orr	w0, w0, 1
	ldrh	w2, [x2, #:lo12:.LANCHOR44]
	bfi	w0, w2, 16, 11
	str	w0, [x1, 48]
	str	w19, [x1, 16]
	orr	w19, w19, 4
	str	w19, [x1, 16]
.L437:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L438:
	ldr	x0, [x24, #:lo12:.LANCHOR21]
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
	cbz	w23, .L441
	adrp	x0, .LANCHOR40
	ubfx	x1, x1, 1, 7
	ldr	x8, [x4, #:lo12:.LANCHOR43]
	add	x1, x3, x1, lsl 2
	ldrb	w0, [x0, #:lo12:.LANCHOR40]
	mov	w5, 128
	cmp	w0, 24
	mov	w0, 64
	csel	w5, w5, w0, hi
	mov	w0, 0
.L443:
	add	w7, w5, w0
	cmp	x3, x1
	bne	.L444
.L445:
	add	x21, x4, :lo12:.LANCHOR43
	ldr	x0, [x4, #:lo12:.LANCHOR43]
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
	ldr	x1, [x24, #:lo12:.LANCHOR21]
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
	b	.L437
.L444:
	ldrh	w10, [x3]
	and	x0, x0, 4294967292
	ldrh	w6, [x3, 2]
	add	x3, x3, 4
	orr	x6, x10, x6, lsl 16
	str	w6, [x8, x0]
	mov	w0, w7
	b	.L443
.L441:
	ldr	x1, [x4, #:lo12:.LANCHOR43]
	str	w0, [x1]
	b	.L445
	.size	nandc_xfer_start, .-nandc_xfer_start
	.section	.text.nandc_set_seed,"ax",@progbits
	.align	2
	.global	nandc_set_seed
	.type	nandc_set_seed, %function
nandc_set_seed:
	and	x0, x0, 127
	adrp	x1, .LANCHOR45
	add	x1, x1, :lo12:.LANCHOR45
	ldrh	w0, [x1, x0, lsl 1]
	adrp	x1, .LANCHOR42
	ldrb	w2, [x1, #:lo12:.LANCHOR42]
	orr	w1, w0, -1073741824
	cmp	w2, 0
	csel	w0, w1, w0, ne
	adrp	x1, .LANCHOR22
	ldrb	w1, [x1, #:lo12:.LANCHOR22]
	cmp	w1, 9
	adrp	x1, .LANCHOR21
	ldr	x1, [x1, #:lo12:.LANCHOR21]
	bne	.L455
	str	w0, [x1, 520]
	ret
.L455:
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
	adrp	x19, .LANCHOR14
	mov	w0, 0
	bl	hynix_reconfig_rr_para
	ldrb	w0, [x19, #:lo12:.LANCHOR14]
	cbz	w0, .L460
	adrp	x0, .LANCHOR39
	ldrb	w0, [x0, #:lo12:.LANCHOR39]
	tbz	x0, 0, .L460
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
	bl	nandc_set_if_mode
	strb	wzr, [x19, #:lo12:.LANCHOR14]
.L460:
	adrp	x3, .LANCHOR42
	ldrb	w0, [x3, #:lo12:.LANCHOR42]
	cbz	w0, .L461
	mov	w0, 0
	strb	wzr, [x3, #:lo12:.LANCHOR42]
	bl	nandc_set_seed
	mov	w0, 1
	strb	w0, [x3, #:lo12:.LANCHOR42]
.L461:
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
	adrp	x1, .LANCHOR42
	strb	w0, [x1, #:lo12:.LANCHOR42]
	ret
	.size	nandc_randomizer_enable, .-nandc_randomizer_enable
	.section	.text.nandc_get_chip_if,"ax",@progbits
	.align	2
	.global	nandc_get_chip_if
	.type	nandc_get_chip_if, %function
nandc_get_chip_if:
	adrp	x1, .LANCHOR21
	ubfiz	x0, x0, 8, 8
	add	x0, x0, 2048
	ldr	x1, [x1, #:lo12:.LANCHOR21]
	add	x0, x1, x0
	ret
	.size	nandc_get_chip_if, .-nandc_get_chip_if
	.section	.text.buf_reinit,"ax",@progbits
	.align	2
	.global	buf_reinit
	.type	buf_reinit, %function
buf_reinit:
	adrp	x0, .LANCHOR46
	add	x1, x0, :lo12:.LANCHOR46
	mov	w2, 0
.L475:
	and	w3, w2, 255
	strb	wzr, [x1, 2]
	add	w4, w3, 1
	strb	w3, [x1, 1]
	strb	w4, [x1]
	add	w2, w2, 1
	str	xzr, [x1, 16]
	cmp	w2, 32
	add	x1, x1, 64
	bne	.L475
	add	x0, x0, :lo12:.LANCHOR46
	mov	w1, -1
	strb	w1, [x0, 1984]
	adrp	x0, .LANCHOR47
	strb	wzr, [x0, #:lo12:.LANCHOR47]
	adrp	x0, .LANCHOR48
	strb	w2, [x0, #:lo12:.LANCHOR48]
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
	bne	.L483
	ldrb	w0, [x20, 1]
	cmp	w0, 255
	bne	.L479
	adrp	x1, .LANCHOR49
	adrp	x0, .LC0
	mov	w2, 74
	add	x1, x1, :lo12:.LANCHOR49
	add	x0, x0, :lo12:.LC0
	bl	printf
.L479:
	ldrb	w0, [x20, 1]
	strb	w0, [x19]
.L477:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L483:
	adrp	x0, .LANCHOR46
	add	x2, x0, :lo12:.LANCHOR46
	mov	x19, x0
.L484:
	sbfiz	x0, x1, 6, 32
	mov	w21, w1
	ldrb	w1, [x2, x0]
	cmp	w1, 255
	bne	.L484
	ldrb	w0, [x20, 1]
	cmp	w0, 255
	bne	.L481
	adrp	x1, .LANCHOR49
	adrp	x0, .LC0
	mov	w2, 81
	add	x1, x1, :lo12:.LANCHOR49
	add	x0, x0, :lo12:.LC0
	bl	printf
.L481:
	add	x0, x19, :lo12:.LANCHOR46
	sbfiz	x21, x21, 6, 32
	ldrb	w1, [x20, 1]
	strb	w1, [x0, x21]
	b	.L477
	.size	buf_add_tail, .-buf_add_tail
	.section	.text.buf_free,"ax",@progbits
	.align	2
	.global	buf_free
	.type	buf_free, %function
buf_free:
	ldrb	w1, [x0, 2]
	adrp	x2, .LANCHOR47
	and	w1, w1, 8
	strb	w1, [x0, 2]
	cbz	w1, .L487
	stp	x29, x30, [sp, -16]!
	mov	x1, x0
	add	x0, x2, :lo12:.LANCHOR47
	add	x29, sp, 0
	bl	buf_add_tail
	adrp	x1, .LANCHOR48
	ldp	x29, x30, [sp], 16
	ldrb	w0, [x1, #:lo12:.LANCHOR48]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR48]
	ret
.L487:
	ldrb	w1, [x2, #:lo12:.LANCHOR47]
	strb	w1, [x0]
	adrp	x1, .LANCHOR48
	ldrb	w0, [x0, 1]
	strb	w0, [x2, #:lo12:.LANCHOR47]
	ldrb	w0, [x1, #:lo12:.LANCHOR48]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR48]
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
	adrp	x19, .LANCHOR48
	and	w20, w0, 255
	ldrb	w0, [x19, #:lo12:.LANCHOR48]
	cbz	w0, .L494
.L497:
	adrp	x3, .LANCHOR47
	adrp	x1, .LANCHOR46
	add	x0, x1, :lo12:.LANCHOR46
	ldrb	w2, [x3, #:lo12:.LANCHOR47]
	ubfiz	x4, x2, 6, 8
	add	x0, x0, x4
	mov	x4, x3
	cbz	w20, .L495
.L496:
	add	x1, x1, :lo12:.LANCHOR46
	sbfiz	x2, x2, 6, 32
	add	x3, x1, x2
	ldrb	w5, [x1, x2]
	strb	w5, [x4, #:lo12:.LANCHOR47]
	ldrb	w4, [x19, #:lo12:.LANCHOR48]
	strh	wzr, [x3, 50]
	sub	w4, w4, #1
	strb	w4, [x19, #:lo12:.LANCHOR48]
	mov	w4, 1
	str	xzr, [x3, 16]
	strb	w4, [x3, 2]
	mov	w4, -1
	strb	w4, [x1, x2]
	mov	w1, -1
	str	w1, [x3, 36]
	b	.L493
.L494:
	mov	w2, 121
	adrp	x1, .LANCHOR50
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR50
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldrb	w0, [x19, #:lo12:.LANCHOR48]
	cbnz	w0, .L497
.L499:
	mov	x0, 0
.L493:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L495:
	ldrb	w3, [x19, #:lo12:.LANCHOR48]
	cmp	w3, 1
	bne	.L496
	b	.L499
	.size	buf_alloc, .-buf_alloc
	.section	.text.buf_remove_buf,"ax",@progbits
	.align	2
	.global	buf_remove_buf
	.type	buf_remove_buf, %function
buf_remove_buf:
	ldrb	w4, [x1, 1]
	ldrb	w2, [x0]
	cmp	w4, w2
	bne	.L507
	ldrb	w1, [x1]
	strb	w1, [x0]
.L511:
	mov	w0, 1
	ret
.L508:
	mov	w3, w2
	sbfiz	x2, x2, 6, 32
	ldrb	w2, [x0, x2]
	cmp	w4, w2
	bne	.L509
	sbfiz	x3, x3, 6, 32
	ldrb	w2, [x1]
	strb	w2, [x0, x3]
	mov	w0, -1
	strb	w0, [x1]
	b	.L511
.L507:
	adrp	x0, .LANCHOR46
	add	x0, x0, :lo12:.LANCHOR46
.L509:
	cmp	w2, 255
	bne	.L508
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
	adrp	x19, .LANCHOR48
	mov	x20, x0
	ldrb	w0, [x19, #:lo12:.LANCHOR48]
	cbnz	w0, .L513
	adrp	x1, .LANCHOR51
	adrp	x0, .LC0
	mov	w2, 170
	add	x1, x1, :lo12:.LANCHOR51
	add	x0, x0, :lo12:.LC0
	bl	printf
.L513:
	ldrb	w0, [x19, #:lo12:.LANCHOR48]
	cbz	w0, .L512
	mov	x1, x20
	adrp	x0, .LANCHOR47
	add	x0, x0, :lo12:.LANCHOR47
	bl	buf_remove_buf
	cmp	w0, 1
	bne	.L512
	ldrb	w0, [x19, #:lo12:.LANCHOR48]
	sub	w0, w0, #1
	strb	w0, [x19, #:lo12:.LANCHOR48]
	ldrb	w0, [x20, 2]
	orr	w0, w0, 1
	strb	w0, [x20, 2]
.L512:
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
	adrp	x2, .LANCHOR20
	ldr	x2, [x2, #:lo12:.LANCHOR20]
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
	adrp	x0, .LANCHOR20
	ldr	x2, [x0, #:lo12:.LANCHOR20]
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
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	bl	buf_add_tail
	adrp	x1, .LANCHOR53
	ldp	x29, x30, [sp], 16
	ldrb	w0, [x1, #:lo12:.LANCHOR53]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x1, #:lo12:.LANCHOR53]
	ret
	.size	ftl_gc_write_buf, .-ftl_gc_write_buf
	.section	.text.zftl_cache_flush,"ax",@progbits
	.align	2
	.global	zftl_cache_flush
	.type	zftl_cache_flush, %function
zftl_cache_flush:
	ret
	.size	zftl_cache_flush, .-zftl_cache_flush
	.section	.text.ftl_read_buf,"ax",@progbits
	.align	2
	.global	ftl_read_buf
	.type	ftl_read_buf, %function
ftl_read_buf:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w0
	adrp	x0, .LANCHOR54
	str	x21, [sp, 32]
	mov	x21, x1
	ldr	w0, [x0, #:lo12:.LANCHOR54]
	cmp	w0, w20
	bhi	.L525
	adrp	x1, .LANCHOR55
	adrp	x0, .LC0
	mov	w2, 887
	add	x1, x1, :lo12:.LANCHOR55
	add	x0, x0, :lo12:.LC0
	bl	printf
.L525:
	adrp	x19, .LANCHOR46
	add	x1, x19, :lo12:.LANCHOR46
	add	x1, x1, 2
	mov	w0, 0
.L528:
	ldr	w2, [x1, 34]
	cmp	w20, w2
	bne	.L526
	ldrb	w2, [x1]
	tbz	x2, 3, .L526
	ubfiz	x0, x0, 6, 32
	add	x19, x19, :lo12:.LANCHOR46
	add	x19, x19, x0
	orr	w0, w2, 4
	strb	w0, [x19, 2]
	tbnz	x2, 0, .L524
	mov	x0, x19
	bl	buf_remove_free
.L524:
	mov	x0, x19
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L526:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L528
	adrp	x0, .LANCHOR56
	ldr	w1, [x0, #:lo12:.LANCHOR56]
	cmn	w1, #1
	bne	.L529
	str	w20, [x0, #:lo12:.LANCHOR56]
	adrp	x0, .LANCHOR57
	str	x21, [x0, #:lo12:.LANCHOR57]
.L529:
	mov	x19, 0
	b	.L524
	.size	ftl_read_buf, .-ftl_read_buf
	.section	.text.ftl_read_buf_free,"ax",@progbits
	.align	2
	.global	ftl_read_buf_free
	.type	ftl_read_buf_free, %function
ftl_read_buf_free:
	mov	x5, x0
	stp	x29, x30, [sp, -16]!
	mov	x1, x0
	adrp	x0, .LANCHOR58
	add	x29, sp, 0
	add	x0, x0, :lo12:.LANCHOR58
	bl	buf_remove_buf
	ldrb	w0, [x5, 2]
	tbz	x0, 1, .L536
	and	w0, w0, -5
	strb	w0, [x5, 2]
	ldp	x29, x30, [sp], 16
	ret
.L536:
	ldp	x29, x30, [sp], 16
	mov	x0, x5
	b	buf_free
	.size	ftl_read_buf_free, .-ftl_read_buf_free
	.section	.text.zftl_get_density,"ax",@progbits
	.align	2
	.global	zftl_get_density
	.type	zftl_get_density, %function
zftl_get_density:
	cbnz	w0, .L541
	adrp	x0, .LANCHOR59
	ldr	w0, [x0, #:lo12:.LANCHOR59]
	ret
.L541:
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
	adrp	x0, .LANCHOR2
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
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
	adrp	x0, .LANCHOR2
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	and	w22, w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	and	w23, w2, 65535
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	cmp	w0, w20
	bhi	.L549
	adrp	x1, .LANCHOR61
	adrp	x0, .LC0
	mov	w2, 252
	add	x1, x1, :lo12:.LANCHOR61
	add	x0, x0, :lo12:.LC0
	bl	printf
.L549:
	adrp	x24, .LANCHOR4
	uxtw	x19, w20
	lsl	x26, x19, 1
	adrp	x25, .LANCHOR7
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	adrp	x27, .LANCHOR3
	ldrh	w21, [x0, x26]
	ldr	w0, [x25, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L550
	ldr	x0, [x27, #:lo12:.LANCHOR3]
	mov	w4, w21
	mov	w2, w22
	mov	w1, w20
	add	x0, x0, x19, lsl 2
	ldrb	w3, [x0, 2]
	adrp	x0, .LANCHOR62
	ldrh	w6, [x0, #:lo12:.LANCHOR62]
	adrp	x0, .LANCHOR63+56
	ubfx	x3, x3, 5, 3
	ldrh	w5, [x0, #:lo12:.LANCHOR63+56]
	adrp	x0, .LC41
	add	x0, x0, :lo12:.LC41
	bl	printf
.L550:
	ldr	x0, [x27, #:lo12:.LANCHOR3]
	add	x19, x0, x19, lsl 2
	ldrb	w3, [x19, 2]
	tst	w3, 224
	bne	.L551
	cbz	w21, .L566
	adrp	x1, .LANCHOR61
	adrp	x0, .LC0
	mov	w2, 257
	add	x1, x1, :lo12:.LANCHOR61
	add	x0, x0, :lo12:.LC0
	bl	printf
.L566:
	mov	w0, 0
	b	.L548
.L551:
	adrp	x0, .LANCHOR63
	add	x1, x0, :lo12:.LANCHOR63
	ldrh	w0, [x0, #:lo12:.LANCHOR63]
	cmp	w0, w20
	beq	.L566
	adrp	x21, .LANCHOR5
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	ldrh	w2, [x0, 48]
	cmp	w2, w20
	beq	.L566
	ldrh	w2, [x0, 16]
	cmp	w2, w20
	beq	.L566
	ldrh	w2, [x0, 80]
	cmp	w2, w20
	beq	.L566
	ldrh	w5, [x1, 56]
	add	x1, x1, 58
	mov	w2, 0
.L553:
	cmp	w2, w5
	bcc	.L554
	cbnz	w22, .L555
	ubfiz	x19, x23, 7, 16
	add	x19, x19, 136
	add	x19, x0, x19
.L556:
	ldr	w0, [x25, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L557
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	adrp	x1, .LANCHOR62
	ubfx	x3, x3, 5, 3
	mov	w2, w22
	ldrh	w6, [x1, #:lo12:.LANCHOR62]
	mov	w1, w20
	ldrh	w4, [x0, x26]
	adrp	x0, .LC41
	add	x0, x0, :lo12:.LC41
	bl	printf
.L557:
	mov	x0, x19
	add	x1, x19, 128
	mov	w2, 65535
.L560:
	ldrh	w3, [x0]
	cmp	w3, w2
	bne	.L558
	strh	w20, [x0]
	cbz	w22, .L559
	ldr	x1, [x21, #:lo12:.LANCHOR5]
	ldrh	w0, [x1, 124]
	add	w0, w0, 1
	strh	w0, [x1, 124]
.L575:
	mov	w0, 1
.L548:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L554:
	ldrh	w4, [x1], 2
	cmp	w4, w20
	beq	.L566
	add	w2, w2, 1
	b	.L553
.L555:
	add	x19, x0, 392
	b	.L556
.L559:
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	add	x23, x0, x23, uxth 1
	ldrh	w0, [x23, 120]
	add	w0, w0, 1
	strh	w0, [x23, 120]
	b	.L575
.L558:
	add	x0, x0, 2
	cmp	x1, x0
	bne	.L560
	b	.L575
	.size	gc_add_sblk, .-gc_add_sblk
	.section	.text.gc_get_src_ppa_from_index,"ax",@progbits
	.align	2
	.global	gc_get_src_ppa_from_index
	.type	gc_get_src_ppa_from_index, %function
gc_get_src_ppa_from_index:
	adrp	x1, .LANCHOR64
	ubfiz	x0, x0, 2, 16
	ldr	x1, [x1, #:lo12:.LANCHOR64]
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
	adrp	x23, .LANCHOR65
	stp	x21, x22, [sp, 32]
	adrp	x24, .LANCHOR46
	add	x23, x23, :lo12:.LANCHOR65
	add	x22, x24, :lo12:.LANCHOR46
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
.L578:
	ldrb	w19, [x23]
	cmp	w19, 255
	bne	.L589
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L589:
	lsl	x1, x19, 6
	add	x0, x24, :lo12:.LANCHOR46
	add	x2, x0, x1
	ldrb	w0, [x0, x1]
	ldr	w1, [x2, 52]
	strb	w0, [x23]
	ldrh	w25, [x2, 48]
	cbz	w1, .L579
	ldr	w2, [x2, 40]
	adrp	x0, .LANCHOR63
	add	x0, x0, :lo12:.LANCHOR63
	mov	w3, 1
	str	w2, [x0, 320]
	strh	w3, [x0, 318]
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	printf
	adrp	x1, .LANCHOR66
	adrp	x0, .LC0
	mov	w2, 519
	add	x1, x1, :lo12:.LANCHOR66
	add	x0, x0, :lo12:.LC0
	bl	printf
.L579:
	adrp	x26, .LANCHOR67
	ldrb	w0, [x26, #:lo12:.LANCHOR67]
	cmp	w0, 3
	bne	.L590
	adrp	x0, .LANCHOR5
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldrb	w20, [x0, 89]
	add	w20, w20, w20, lsl 1
	and	w20, w20, 1023
.L580:
	adrp	x0, .LANCHOR7
	adrp	x28, .LANCHOR68
	and	x21, x25, 65535
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L581
	ldr	x1, [x28, #:lo12:.LANCHOR68]
	add	x0, x22, x19, lsl 6
	mov	w3, w25
	ldrb	w2, [x0, 1]
	adrp	x0, .LC43
	ldrb	w4, [x1, x21]
	add	x0, x0, :lo12:.LC43
	mov	w1, w25
	bl	printf
.L581:
	ldr	x1, [x28, #:lo12:.LANCHOR68]
	add	x0, x22, x19, lsl 6
	mov	x27, x21
	ldrb	w0, [x0, 1]
	ldrb	w1, [x1, x21]
	cmp	w1, w0
	beq	.L582
	adrp	x1, .LANCHOR66
	adrp	x0, .LC0
	mov	w2, 526
	add	x1, x1, :lo12:.LANCHOR66
	add	x0, x0, :lo12:.LC0
	bl	printf
.L582:
	add	x19, x22, x19, lsl 6
	ldrb	w0, [x19, 61]
	cmp	w0, 3
	beq	.L583
	ldrb	w0, [x26, #:lo12:.LANCHOR67]
	cmp	w0, 3
	bne	.L583
	adrp	x0, .LANCHOR69
	ldrb	w0, [x0, #:lo12:.LANCHOR69]
	cbnz	w0, .L583
	ldr	x1, [x28, #:lo12:.LANCHOR68]
	mov	x0, 0
	add	x21, x1, x21
.L584:
	cmp	w20, w0, uxth
	bls	.L578
	ldrb	w1, [x21, x0]
	add	x0, x0, 1
	add	x1, x22, x1, lsl 6
	strb	wzr, [x1, 61]
	b	.L584
.L590:
	mov	w20, 1
	b	.L580
.L583:
	adrp	x19, .LANCHOR63
	add	x19, x19, :lo12:.LANCHOR63
	add	x20, x21, x20, uxth
	mov	w21, -1
	strh	w25, [x19, 316]
.L585:
	cmp	x20, x27
	beq	.L578
	ldr	x1, [x28, #:lo12:.LANCHOR68]
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
	b	.L585
	.size	gc_write_completed, .-gc_write_completed
	.section	.text.gc_get_src_blk,"ax",@progbits
	.align	2
	.global	gc_get_src_blk
	.type	gc_get_src_blk, %function
gc_get_src_blk:
	adrp	x0, .LANCHOR5
	ldr	x2, [x0, #:lo12:.LANCHOR5]
	adrp	x0, .LANCHOR70
	ldrb	w3, [x0, #:lo12:.LANCHOR70]
	ldrh	w0, [x2, 124]
	cbz	w0, .L602
	add	x1, x2, 392
	mov	w4, 1
.L603:
	add	x5, x1, 128
	mov	w6, 65535
.L607:
	ldrh	w0, [x1]
	cmp	w0, w6
	beq	.L605
	mov	w5, -1
	strh	w5, [x1]
	cbz	w4, .L606
	ldrh	w1, [x2, 124]
	sub	w1, w1, #1
	strh	w1, [x2, 124]
	ret
.L602:
	add	x0, x2, x3, sxtw 1
	ldrh	w0, [x0, 120]
	cbz	w0, .L608
	ubfiz	x1, x3, 7, 8
	mov	w4, 0
	add	x1, x1, 136
	add	x1, x2, x1
	b	.L603
.L606:
	add	x2, x2, x3, uxtb 1
	ldrh	w1, [x2, 120]
	sub	w1, w1, #1
	strh	w1, [x2, 120]
	ret
.L605:
	add	x1, x1, 2
	cmp	x1, x5
	bne	.L607
	ret
.L608:
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
	cbz	w1, .L617
	adrp	x1, .LANCHOR48
	ldrb	w1, [x1, #:lo12:.LANCHOR48]
	cmp	w1, 1
	bhi	.L617
	ldrh	w19, [x0, 316]
	adrp	x2, .LANCHOR72
	adrp	x0, .LANCHOR71
	adrp	x21, .LANCHOR68
	ldrb	w2, [x2, #:lo12:.LANCHOR72]
	add	w1, w19, 24
	ldrh	w0, [x0, #:lo12:.LANCHOR71]
	ldr	x4, [x21, #:lo12:.LANCHOR68]
	mul	w0, w0, w2
	cmp	w0, w1
	csel	w1, w0, w1, ls
	adrp	x0, .LANCHOR46
	add	x0, x0, :lo12:.LANCHOR46
.L612:
	cmp	w19, w1
	bcc	.L615
.L617:
	mov	w0, 0
	b	.L610
.L615:
	uxtw	x22, w19
	ldrb	w2, [x4, x22]
	cmp	w2, 255
	beq	.L613
	sbfiz	x3, x2, 6, 32
	add	x3, x0, x3
	ldrb	w3, [x3, 61]
	cbnz	w3, .L613
	ubfiz	x2, x2, 6, 8
	add	x0, x0, x2
	bl	buf_free
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L614
	ldr	x0, [x21, #:lo12:.LANCHOR68]
	mov	w1, w19
	ldrb	w2, [x0, x22]
	adrp	x0, .LC44
	add	x0, x0, :lo12:.LC44
	bl	printf
.L614:
	ldr	x0, [x21, #:lo12:.LANCHOR68]
	add	x20, x20, :lo12:.LANCHOR63
	mov	w1, -1
	strb	w1, [x0, x22]
	ldrb	w0, [x20, 7]
	sub	w0, w0, #1
	strb	w0, [x20, 7]
	mov	w0, 1
.L610:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L613:
	add	w19, w19, 1
	b	.L612
	.size	gc_free_temp_buf, .-gc_free_temp_buf
	.section	.text.print_gc_debug_info,"ax",@progbits
	.align	2
	.global	print_gc_debug_info
	.type	print_gc_debug_info, %function
print_gc_debug_info:
	adrp	x2, .LANCHOR73
	adrp	x1, .LANCHOR63
	add	x0, x1, :lo12:.LANCHOR63
	ldrh	w6, [x2, #:lo12:.LANCHOR73]
	adrp	x2, .LANCHOR48
	ldrh	w1, [x1, #:lo12:.LANCHOR63]
	ldrb	w5, [x0, 7]
	ldrb	w4, [x2, #:lo12:.LANCHOR48]
	ldrh	w3, [x0, 314]
	ldrh	w2, [x0, 2]
	adrp	x0, .LC45
	add	x0, x0, :lo12:.LC45
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
	bne	.L627
	mov	w1, w0
	adrp	x0, .LANCHOR74
	ldr	x0, [x0, #:lo12:.LANCHOR74]
.L629:
	b	_list_get_gc_head_node.isra.2
.L627:
	cmp	w1, 2
	mov	w1, w0
	bne	.L628
	adrp	x0, .LANCHOR75
	ldr	x0, [x0, #:lo12:.LANCHOR75]
	b	.L629
.L628:
	adrp	x0, .LANCHOR76
	ldr	x0, [x0, #:lo12:.LANCHOR76]
	b	.L629
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
	adrp	x0, .LANCHOR5
	stp	x23, x24, [sp, 48]
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	add	x0, x0, x21, sxtw 1
	ldrh	w19, [x0, 120]
	cbz	w19, .L631
	mov	w0, w19
.L630:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L631:
	and	w20, w2, 255
	cbnz	w21, .L633
	adrp	x24, .LANCHOR77
	adrp	x26, .LANCHOR7
	adrp	x27, .LC46
	and	w23, w20, 65535
	add	x26, x26, :lo12:.LANCHOR7
	add	x27, x27, :lo12:.LC46
	strh	wzr, [x24, #:lo12:.LANCHOR77]
	mov	w22, 0
	mov	w25, 0
.L634:
	cmp	w25, w23
	bcs	.L639
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
	beq	.L635
	ldr	w0, [x26]
	adrp	x6, .LANCHOR4
	uxtw	x4, w1
	tbz	x0, 8, .L636
	ldr	x0, [x6, #:lo12:.LANCHOR4]
	stp	x6, x4, [x29, 96]
	ldrh	w3, [x0, x4, lsl 1]
	mov	x0, x27
	bl	printf
	ldp	x6, x4, [x29, 96]
.L636:
	ldr	x0, [x6, #:lo12:.LANCHOR4]
	ldrh	w1, [x0, x4, lsl 1]
	adrp	x0, .LANCHOR62
	ldrh	w0, [x0, #:lo12:.LANCHOR62]
	cmp	w1, w0
	bcs	.L637
	mov	w2, 0
	mov	w1, 0
	mov	w0, w28
	bl	gc_add_sblk
	cbz	w0, .L638
	add	w5, w22, 1
	and	w22, w5, 65535
	cmp	w23, w22
	bcs	.L638
.L639:
	ldr	x0, [x29, 112]
	tbz	x0, 1, .L641
	adrp	x25, .LANCHOR79
	adrp	x28, .LANCHOR78
	add	x27, x25, :lo12:.LANCHOR79
	add	x28, x28, :lo12:.LANCHOR78
	mov	w26, 65535
.L642:
	cmp	w19, w23
	beq	.L646
	ldrh	w6, [x28]
	mov	w1, 5
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x28]
	and	w1, w0, 65535
	cmp	w1, w26
	beq	.L643
	adrp	x2, .LANCHOR4
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR4]
	ldrh	w2, [x2, x1]
	ldrh	w1, [x27]
	cmp	w2, w1
	bcs	.L644
	mov	w2, 0
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L645
	add	w5, w22, 1
	and	w22, w5, 65535
	cmp	w23, w22
	bcs	.L645
.L646:
	ldrh	w1, [x25, #:lo12:.LANCHOR79]
	cmp	w22, w23
	adrp	x0, .LANCHOR80
	bcs	.L648
	ldrh	w3, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR72
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	lsr	w2, w3, 3
	mul	w0, w0, w3
	sub	w0, w0, w2
	cmp	w1, w0
	bge	.L641
	add	w1, w1, w2
	strh	w1, [x25, #:lo12:.LANCHOR79]
.L641:
	ldr	x0, [x29, 112]
	tbz	x0, 0, .L649
	cmp	w22, w23
	bcs	.L649
	adrp	x25, .LANCHOR81
	add	x25, x25, :lo12:.LANCHOR81
	mov	w24, 64
	adrp	x26, .LANCHOR75
	mov	w27, 65535
.L654:
	ldrh	w6, [x25]
	ldr	x0, [x26, #:lo12:.LANCHOR75]
	mov	w1, w6
	bl	_list_get_gc_head_node.isra.2
	add	w6, w6, 1
	strh	w6, [x25]
	cmp	w27, w0, uxth
	beq	.L650
	mov	w2, 0
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L651
	add	w5, w22, 1
	and	w22, w5, 65535
	cmp	w23, w22
	bhi	.L651
.L652:
	adrp	x1, .LANCHOR62
	adrp	x2, .LANCHOR80
	ldrh	w0, [x1, #:lo12:.LANCHOR62]
	ldrh	w2, [x2, #:lo12:.LANCHOR80]
	cmp	w0, w2, lsr 1
	bls	.L649
	sub	w0, w0, #8
	b	.L728
.L637:
	strh	wzr, [x24, #:lo12:.LANCHOR77]
	b	.L639
.L635:
	strh	wzr, [x7]
	b	.L639
.L638:
	add	w25, w25, 1
	and	w25, w25, 65535
	b	.L634
.L644:
	strh	wzr, [x28]
	b	.L646
.L643:
	strh	wzr, [x24, #:lo12:.LANCHOR77]
	b	.L646
.L645:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L642
.L648:
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w1, w0
	bls	.L641
	sub	w0, w1, w0, lsr 3
	strh	w0, [x25, #:lo12:.LANCHOR79]
	b	.L641
.L650:
	strh	wzr, [x25]
.L653:
	cmp	w22, w23
	bcs	.L652
	adrp	x1, .LANCHOR62
	adrp	x2, .LANCHOR80
	ldrh	w0, [x1, #:lo12:.LANCHOR62]
	ldrh	w2, [x2, #:lo12:.LANCHOR80]
	cmp	w2, w0
	bls	.L649
	add	w0, w0, 8
.L728:
	strh	w0, [x1, #:lo12:.LANCHOR62]
.L649:
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L676
	ldr	w2, [x29, 112]
	adrp	x0, .LC47
	mov	w4, w20
	mov	w3, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC47
	bl	printf
.L676:
	mov	w0, w22
	b	.L630
.L651:
	sub	w24, w24, #1
	ands	w24, w24, 65535
	bne	.L654
	b	.L653
.L633:
	ldr	w0, [x29, 112]
	adrp	x3, .LANCHOR81
	and	w0, w0, 1
	str	w0, [x29, 104]
	ldr	x0, [x29, 112]
	strh	wzr, [x3, #:lo12:.LANCHOR81]
	tbz	x0, 0, .L678
	adrp	x23, .LANCHOR82
	adrp	x24, .LANCHOR83
	ldrh	w0, [x23, #:lo12:.LANCHOR82]
	ldrh	w1, [x24, #:lo12:.LANCHOR83]
	cmp	w0, w1, lsr 1
	bcc	.L679
	adrp	x1, .LANCHOR84
	mov	w22, 0
	ldrh	w1, [x1, #:lo12:.LANCHOR84]
	cmp	w1, w0
	bls	.L657
.L726:
	add	x26, x3, :lo12:.LANCHOR81
	and	w28, w20, 65535
	mov	w25, 64
	mov	w27, 65535
.L660:
	adrp	x0, .LANCHOR75
	ldrh	w6, [x26]
	ldr	x0, [x0, #:lo12:.LANCHOR75]
	mov	w1, w6
	bl	_list_get_gc_head_node.isra.2
	add	w6, w6, 1
	strh	w6, [x26]
	cmp	w27, w0, uxth
	beq	.L658
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L659
	add	w5, w22, 1
	and	w22, w5, 65535
	cmp	w22, w28
	bcc	.L659
.L657:
	ldrh	w1, [x24, #:lo12:.LANCHOR83]
	ldrh	w0, [x23, #:lo12:.LANCHOR82]
	cmp	w0, w1, lsr 1
	bls	.L655
	adrp	x24, .LANCHOR77
	and	w27, w20, 65535
	mov	w23, 64
	mov	w26, 65535
	strh	wzr, [x24, #:lo12:.LANCHOR77]
	add	x24, x24, :lo12:.LANCHOR77
.L662:
	ldrh	w6, [x24]
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x24]
	cmp	w26, w0, uxth
	beq	.L655
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L661
	add	w5, w22, 1
	and	w22, w5, 65535
	cmp	w22, w27
	bcs	.L655
.L661:
	sub	w23, w23, #1
	ands	w23, w23, 65535
	bne	.L662
.L655:
	ldr	x0, [x29, 112]
	tbz	x0, 1, .L663
	adrp	x28, .LANCHOR78
	adrp	x24, .LANCHOR85
	add	x27, x24, :lo12:.LANCHOR85
	mov	w23, 64
	strh	wzr, [x28, #:lo12:.LANCHOR78]
	add	x28, x28, :lo12:.LANCHOR78
	mov	w25, 65535
	adrp	x26, .LANCHOR4
.L668:
	ldrh	w6, [x28]
	mov	w1, 5
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x28]
	and	w1, w0, 65535
	cmp	w1, w25
	beq	.L664
	ldr	x2, [x26, #:lo12:.LANCHOR4]
	ubfiz	x1, x1, 1, 16
	ldrh	w2, [x2, x1]
	ldrh	w1, [x27]
	cmp	w2, w1
	bcs	.L665
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L666
	add	w5, w22, 1
	add	w19, w19, 1
	and	w22, w5, 65535
	and	w19, w19, 65535
	cmp	w22, w20
	bcc	.L666
.L667:
	cmp	w22, w20
	adrp	x4, .LANCHOR80
	adrp	x2, .LANCHOR72
	bcc	.L669
	cbnz	w19, .L670
	adrp	x0, .LANCHOR86
	ldrh	w1, [x0, #:lo12:.LANCHOR86]
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w1, w0
	bls	.L670
.L669:
	adrp	x1, .LANCHOR71
	ldrb	w2, [x2, #:lo12:.LANCHOR72]
	ldrh	w0, [x24, #:lo12:.LANCHOR85]
	ldrh	w1, [x1, #:lo12:.LANCHOR71]
	mul	w2, w1, w2
	ldrh	w1, [x4, #:lo12:.LANCHOR80]
	sub	w1, w2, w1, lsr 3
	cmp	w0, w1
	bge	.L663
	add	w0, w0, 4
.L727:
	strh	w0, [x24, #:lo12:.LANCHOR85]
.L663:
	ldr	w0, [x29, 104]
	cbz	w0, .L649
	adrp	x25, .LANCHOR78
	adrp	x23, .LANCHOR88
	add	x28, x23, :lo12:.LANCHOR88
	mov	w24, 64
	strh	wzr, [x25, #:lo12:.LANCHOR78]
	add	x25, x25, :lo12:.LANCHOR78
	mov	w26, 65535
	adrp	x27, .LANCHOR4
.L674:
	ldrh	w0, [x25]
	mov	w1, 3
	bl	zftl_get_gc_node
	and	w1, w0, 65535
	cmp	w1, w26
	beq	.L671
	ldr	x2, [x27, #:lo12:.LANCHOR4]
	ubfiz	x1, x1, 1, 16
	ldrh	w1, [x2, x1]
	ldrh	w2, [x28]
	cmp	w2, w1
	bls	.L672
	cmp	w1, 2
	bhi	.L673
.L672:
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L673
	add	w5, w22, 1
	and	w22, w5, 65535
	cmp	w22, w20
	bcs	.L671
.L673:
	sub	w24, w24, #1
	ands	w24, w24, 65535
	bne	.L674
.L671:
	cmp	w22, w20
	adrp	x2, .LANCHOR80
	bcs	.L675
	ldrh	w0, [x23, #:lo12:.LANCHOR88]
	ldrh	w1, [x2, #:lo12:.LANCHOR80]
	cmp	w0, w1, lsr 1
	bls	.L649
	sub	w0, w0, #4
	strh	w0, [x23, #:lo12:.LANCHOR88]
	b	.L649
.L679:
	mov	w22, 0
	b	.L726
.L658:
	strh	wzr, [x26]
	b	.L657
.L659:
	sub	w4, w25, #1
	ands	w25, w4, 65535
	bne	.L660
	b	.L657
.L678:
	mov	w22, 0
	b	.L655
.L665:
	strh	wzr, [x28]
	b	.L667
.L664:
	adrp	x0, .LANCHOR77
	strh	wzr, [x0, #:lo12:.LANCHOR77]
	b	.L667
.L666:
	sub	w23, w23, #1
	ands	w23, w23, 65535
	bne	.L668
	b	.L667
.L670:
	ldrh	w1, [x4, #:lo12:.LANCHOR80]
	ldrb	w2, [x2, #:lo12:.LANCHOR72]
	ldrh	w0, [x24, #:lo12:.LANCHOR85]
	mul	w1, w1, w2
	cmp	w0, w1
	ble	.L663
	sub	w0, w0, #4
	b	.L727
.L675:
	ldrh	w0, [x2, #:lo12:.LANCHOR80]
	adrp	x2, .LANCHOR72
	ldrh	w1, [x23, #:lo12:.LANCHOR88]
	ldrb	w2, [x2, #:lo12:.LANCHOR72]
	mul	w0, w0, w2
	sub	w0, w0, #32
	cmp	w1, w0
	bge	.L649
	add	w1, w1, 4
	strh	w1, [x23, #:lo12:.LANCHOR88]
	b	.L649
	.size	gc_search_src_blk, .-gc_search_src_blk
	.section	.text.zftl_insert_free_list,"ax",@progbits
	.align	2
	.global	zftl_insert_free_list
	.type	zftl_insert_free_list, %function
zftl_insert_free_list:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR3
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x0, x0, x1, uxth 2
	ldrb	w0, [x0, 2]
	ands	w0, w0, 24
	bne	.L730
	adrp	x2, .LANCHOR89
	adrp	x0, .LANCHOR90
	add	x2, x2, :lo12:.LANCHOR89
	add	x0, x0, :lo12:.LANCHOR90
.L732:
	b	_insert_free_list
.L730:
	cmp	w0, 16
	bne	.L731
	adrp	x2, .LANCHOR91
	adrp	x0, .LANCHOR92
	add	x2, x2, :lo12:.LANCHOR91
	add	x0, x0, :lo12:.LANCHOR92
	b	.L732
.L731:
	adrp	x2, .LANCHOR93
	adrp	x0, .LANCHOR94
	add	x2, x2, :lo12:.LANCHOR93
	add	x0, x0, :lo12:.LANCHOR94
	b	.L732
	.size	zftl_insert_free_list, .-zftl_insert_free_list
	.section	.text.zftl_insert_data_list,"ax",@progbits
	.align	2
	.global	zftl_insert_data_list
	.type	zftl_insert_data_list, %function
zftl_insert_data_list:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR3
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x0, x0, x1, uxth 2
	ldrb	w2, [x0, 2]
	and	w2, w2, 224
	cmp	w2, 64
	bne	.L734
	adrp	x2, .LANCHOR84
	adrp	x0, .LANCHOR75
	add	x2, x2, :lo12:.LANCHOR84
	add	x0, x0, :lo12:.LANCHOR75
.L737:
	b	_insert_data_list
.L734:
	cmp	w2, 96
	bne	.L735
	adrp	x2, .LANCHOR82
	adrp	x0, .LANCHOR76
	add	x2, x2, :lo12:.LANCHOR82
	add	x0, x0, :lo12:.LANCHOR76
	b	.L737
.L735:
	cmp	w2, 160
	bne	.L733
	adrp	x2, .LANCHOR86
	adrp	x0, .LANCHOR74
	add	x2, x2, :lo12:.LANCHOR86
	add	x0, x0, :lo12:.LANCHOR74
	b	.L737
.L733:
	ret
	.size	zftl_insert_data_list, .-zftl_insert_data_list
	.section	.text.zftl_get_free_sblk,"ax",@progbits
	.align	2
	.global	zftl_get_free_sblk
	.type	zftl_get_free_sblk, %function
zftl_get_free_sblk:
	stp	x29, x30, [sp, -48]!
	and	w0, w0, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR93
	str	x21, [sp, 32]
	and	w21, w1, 65535
	cmp	w21, 5
	bne	.L739
	adrp	x1, .LANCHOR91
	add	x2, x1, :lo12:.LANCHOR91
	ldrh	w3, [x1, #:lo12:.LANCHOR91]
	ldrh	w1, [x20, #:lo12:.LANCHOR93]
	cmp	w3, w1
	bls	.L740
	mov	w1, w0
	adrp	x0, .LANCHOR92
	add	x0, x0, :lo12:.LANCHOR92
.L744:
	bl	_list_pop_index_node
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	bne	.L742
	adrp	x0, .LANCHOR89
	ldrh	w5, [x20, #:lo12:.LANCHOR93]
	mov	w2, w21
	mov	w1, w19
	ldrh	w4, [x0, #:lo12:.LANCHOR89]
	adrp	x0, .LANCHOR90
	ldr	x3, [x0, #:lo12:.LANCHOR90]
	adrp	x0, .LC48
	add	x0, x0, :lo12:.LC48
	bl	printf
.L742:
	mov	w0, w19
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L740:
	mov	w1, w0
	add	x2, x20, :lo12:.LANCHOR93
	adrp	x0, .LANCHOR94
	add	x0, x0, :lo12:.LANCHOR94
	b	.L744
.L739:
	adrp	x1, .LANCHOR89
	add	x2, x1, :lo12:.LANCHOR89
	ldrh	w3, [x1, #:lo12:.LANCHOR89]
	ldrh	w1, [x20, #:lo12:.LANCHOR93]
	cmp	w3, w1
	bls	.L740
	mov	w1, w0
	adrp	x0, .LANCHOR90
	add	x0, x0, :lo12:.LANCHOR90
	b	.L744
	.size	zftl_get_free_sblk, .-zftl_get_free_sblk
	.section	.text.zftl_remove_data_node,"ax",@progbits
	.align	2
	.global	zftl_remove_data_node
	.type	zftl_remove_data_node, %function
zftl_remove_data_node:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR3
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x0, x0, x1, uxth 2
	ldrb	w2, [x0, 2]
	and	w2, w2, 224
	cmp	w2, 64
	bne	.L746
	adrp	x2, .LANCHOR84
	adrp	x0, .LANCHOR75
	add	x2, x2, :lo12:.LANCHOR84
	add	x0, x0, :lo12:.LANCHOR75
.L749:
	b	_list_remove_node
.L746:
	cmp	w2, 96
	bne	.L747
	adrp	x2, .LANCHOR82
	adrp	x0, .LANCHOR76
	add	x2, x2, :lo12:.LANCHOR82
	add	x0, x0, :lo12:.LANCHOR76
	b	.L749
.L747:
	cmp	w2, 160
	bne	.L745
	adrp	x2, .LANCHOR86
	adrp	x0, .LANCHOR74
	add	x2, x2, :lo12:.LANCHOR86
	add	x0, x0, :lo12:.LANCHOR74
	b	.L749
.L745:
	ret
	.size	zftl_remove_data_node, .-zftl_remove_data_node
	.section	.text.zftl_remove_free_node,"ax",@progbits
	.align	2
	.global	zftl_remove_free_node
	.type	zftl_remove_free_node, %function
zftl_remove_free_node:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR3
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x0, x0, x1, uxth 2
	ldrb	w0, [x0, 2]
	ands	w0, w0, 24
	bne	.L751
	adrp	x2, .LANCHOR89
	adrp	x0, .LANCHOR90
	add	x2, x2, :lo12:.LANCHOR89
	add	x0, x0, :lo12:.LANCHOR90
.L753:
	b	_list_remove_node
.L751:
	cmp	w0, 16
	bne	.L752
	adrp	x2, .LANCHOR91
	adrp	x0, .LANCHOR92
	add	x2, x2, :lo12:.LANCHOR91
	add	x0, x0, :lo12:.LANCHOR92
	b	.L753
.L752:
	adrp	x2, .LANCHOR93
	adrp	x0, .LANCHOR94
	add	x2, x2, :lo12:.LANCHOR93
	add	x0, x0, :lo12:.LANCHOR94
	b	.L753
	.size	zftl_remove_free_node, .-zftl_remove_free_node
	.section	.text.zftl_list_update_data_list,"ax",@progbits
	.align	2
	.global	zftl_list_update_data_list
	.type	zftl_list_update_data_list, %function
zftl_list_update_data_list:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR3
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x0, x0, x1, uxth 2
	ldrb	w2, [x0, 2]
	and	w2, w2, 224
	cmp	w2, 64
	bne	.L755
	adrp	x2, .LANCHOR84
	adrp	x0, .LANCHOR75
	add	x2, x2, :lo12:.LANCHOR84
	add	x0, x0, :lo12:.LANCHOR75
.L758:
	b	_list_update_data_list
.L755:
	cmp	w2, 96
	bne	.L756
	adrp	x2, .LANCHOR82
	adrp	x0, .LANCHOR76
	add	x2, x2, :lo12:.LANCHOR82
	add	x0, x0, :lo12:.LANCHOR76
	b	.L758
.L756:
	cmp	w2, 160
	bne	.L754
	adrp	x2, .LANCHOR86
	adrp	x0, .LANCHOR74
	add	x2, x2, :lo12:.LANCHOR86
	add	x0, x0, :lo12:.LANCHOR74
	b	.L758
.L754:
	ret
	.size	zftl_list_update_data_list, .-zftl_list_update_data_list
	.section	.text.print_list_info,"ax",@progbits
	.align	2
	.global	print_list_info
	.type	print_list_info, %function
print_list_info:
	sub	sp, sp, #112
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	ldrh	w2, [x1]
	ldr	x1, [x0]
	stp	x19, x20, [sp, 48]
	mov	x19, x0
	stp	x21, x22, [sp, 64]
	adrp	x0, .LC49
	stp	x23, x24, [sp, 80]
	add	x0, x0, :lo12:.LC49
	str	x25, [sp, 96]
	bl	printf
	ldr	x19, [x19]
	cbz	x19, .L759
	mov	x23, -6148914691236517206
	adrp	x21, .LC50
	add	x21, x21, :lo12:.LC50
	mov	w20, 0
	adrp	x22, .LANCHOR0
	movk	x23, 0xaaab, lsl 0
	adrp	x24, .LANCHOR3
	adrp	x25, .LANCHOR4
.L766:
	ldr	x2, [x22, #:lo12:.LANCHOR0]
	ldr	x1, [x24, #:lo12:.LANCHOR3]
	sub	x2, x19, x2
	ldr	x8, [x25, #:lo12:.LANCHOR4]
	asr	x2, x2, 1
	ldrh	w5, [x19, 4]
	ldrh	w4, [x19, 2]
	mul	x2, x2, x23
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
	mov	x0, x21
	bl	printf
	ldrh	w19, [x19]
	mov	w0, 65535
	cmp	w19, w0
	beq	.L759
	ldr	x0, [x22, #:lo12:.LANCHOR0]
	mov	w1, 6
	add	w20, w20, 1
	cmp	w20, 33
	umaddl	x19, w19, w1, x0
	bne	.L766
.L759:
	ldp	x19, x20, [sp, 48]
	ldp	x21, x22, [sp, 64]
	ldp	x23, x24, [sp, 80]
	ldp	x29, x30, [sp, 32]
	ldr	x25, [sp, 96]
	add	sp, sp, 112
	ret
	.size	print_list_info, .-print_list_info
	.section	.text.dump_all_list_info,"ax",@progbits
	.align	2
	.global	dump_all_list_info
	.type	dump_all_list_info, %function
dump_all_list_info:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR89
	adrp	x0, .LANCHOR90
	add	x1, x1, :lo12:.LANCHOR89
	add	x29, sp, 0
	add	x0, x0, :lo12:.LANCHOR90
	bl	print_list_info
	adrp	x1, .LANCHOR91
	adrp	x0, .LANCHOR92
	add	x1, x1, :lo12:.LANCHOR91
	add	x0, x0, :lo12:.LANCHOR92
	bl	print_list_info
	adrp	x1, .LANCHOR93
	adrp	x0, .LANCHOR94
	add	x1, x1, :lo12:.LANCHOR93
	add	x0, x0, :lo12:.LANCHOR94
	bl	print_list_info
	adrp	x1, .LANCHOR84
	adrp	x0, .LANCHOR75
	add	x1, x1, :lo12:.LANCHOR84
	add	x0, x0, :lo12:.LANCHOR75
	bl	print_list_info
	adrp	x1, .LANCHOR82
	adrp	x0, .LANCHOR76
	add	x1, x1, :lo12:.LANCHOR82
	add	x0, x0, :lo12:.LANCHOR76
	bl	print_list_info
	ldp	x29, x30, [sp], 16
	adrp	x1, .LANCHOR86
	adrp	x0, .LANCHOR74
	add	x1, x1, :lo12:.LANCHOR86
	add	x0, x0, :lo12:.LANCHOR74
	b	print_list_info
	.size	dump_all_list_info, .-dump_all_list_info
	.section	.text.ftl_get_blk_list_in_sblk,"ax",@progbits
	.align	2
	.global	ftl_get_blk_list_in_sblk
	.type	ftl_get_blk_list_in_sblk, %function
ftl_get_blk_list_in_sblk:
	adrp	x2, .LANCHOR3
	and	w0, w0, 65535
	adrp	x7, .LANCHOR96
	add	x7, x7, :lo12:.LANCHOR96
	ldr	x2, [x2, #:lo12:.LANCHOR3]
	mov	w3, 0
	mov	w13, 21
	add	x2, x2, x0, uxth 2
	ldrb	w12, [x2, 3]
	adrp	x2, .LANCHOR72
	ldrb	w10, [x2, #:lo12:.LANCHOR72]
	adrp	x2, .LANCHOR95
	ldrb	w6, [x2, #:lo12:.LANCHOR95]
	and	w2, w6, 65535
	mul	w0, w0, w2
	sub	w2, w2, #1
	sxth	w5, w2
	and	w4, w0, 65535
	mov	w0, 0
.L771:
	cmp	w3, w10
	blt	.L775
	sxtw	x2, w0
	mov	w3, -1
.L776:
	cmp	w10, w2
	bgt	.L777
	ret
.L775:
	asr	w2, w12, w3
	tbnz	x2, 0, .L772
	sdiv	w2, w3, w6
	ldrh	w8, [x7]
	sbfiz	x11, x0, 1, 32
	cmp	w6, 1
	sub	w8, w13, w8
	lsl	w2, w2, w8
	add	w2, w4, w2
	and	w2, w2, 65535
	bhi	.L773
.L778:
	add	w0, w0, 1
	strh	w2, [x1, x11]
.L772:
	add	w3, w3, 1
	b	.L771
.L773:
	and	w8, w5, w3
	add	w2, w2, w8
	b	.L778
.L777:
	strh	w3, [x1, x2, lsl 1]
	add	x2, x2, 1
	b	.L776
	.size	ftl_get_blk_list_in_sblk, .-ftl_get_blk_list_in_sblk
	.section	.text.ftl_free_sblk,"ax",@progbits
	.align	2
	.global	ftl_free_sblk
	.type	ftl_free_sblk, %function
ftl_free_sblk:
	stp	x29, x30, [sp, -48]!
	adrp	x1, .LANCHOR3
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	x20, x0, 65535
	ldr	x2, [x1, #:lo12:.LANCHOR3]
	lsl	x19, x20, 2
	stp	x21, x22, [sp, 32]
	mov	x22, x20
	add	x0, x2, x19
	mov	x21, x1
	ldrb	w3, [x0, 2]
	tbz	x3, 3, .L780
	adrp	x1, .LANCHOR97
	ldr	x3, [x1, #:lo12:.LANCHOR97]
	ldrh	w1, [x2, x19]
	ldrh	w4, [x3, 74]
	ubfx	x1, x1, 0, 11
	add	w1, w1, w4
	adrp	x4, .LANCHOR98
	ldrh	w4, [x4, #:lo12:.LANCHOR98]
	cmp	w4, w1, uxth
	bcc	.L781
	ldr	w1, [x2, x19]
	ldrh	w2, [x3, 72]
	ubfx	x1, x1, 11, 8
	add	w1, w1, w2
	adrp	x2, .LANCHOR99
	ldrh	w2, [x2, #:lo12:.LANCHOR99]
	cmp	w2, w1, uxth
	bcs	.L780
.L781:
	adrp	x1, .LANCHOR86
	adrp	x2, .LANCHOR91
	ldrh	w1, [x1, #:lo12:.LANCHOR86]
	ldrh	w2, [x2, #:lo12:.LANCHOR91]
	add	w1, w1, w2
	adrp	x2, .LANCHOR87
	ldrh	w2, [x2, #:lo12:.LANCHOR87]
	cmp	w1, w2
	bge	.L782
	ldrb	w1, [x0, 2]
	mov	w2, 2
	bfi	w1, w2, 3, 2
.L787:
	strb	w1, [x0, 2]
.L780:
	mov	w0, w22
	bl	zftl_remove_data_node
	mov	w0, w22
	bl	zftl_insert_free_list
	ldr	x0, [x21, #:lo12:.LANCHOR3]
	ldp	x21, x22, [sp, 32]
	add	x0, x0, x19
	ldrb	w1, [x0, 2]
	and	w1, w1, 31
	strb	w1, [x0, 2]
	adrp	x0, .LANCHOR4
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	strh	wzr, [x0, x20, lsl 1]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L782:
	adrp	x1, .LANCHOR84
	adrp	x2, .LANCHOR89
	ldrh	w1, [x1, #:lo12:.LANCHOR84]
	ldrh	w2, [x2, #:lo12:.LANCHOR89]
	add	w1, w1, w2
	adrp	x2, .LANCHOR82
	ldrh	w2, [x2, #:lo12:.LANCHOR82]
	add	w1, w1, w2
	adrp	x2, .LANCHOR100
	ldrh	w2, [x2, #:lo12:.LANCHOR100]
	cmp	w1, w2
	bge	.L780
	ldrb	w1, [x0, 2]
	and	w1, w1, -25
	b	.L787
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
	adrp	x22, .LC51
	adrp	x23, .LANCHOR4
	add	x21, x21, :lo12:.LANCHOR63
	mov	x24, x23
	add	x22, x22, :lo12:.LC51
	stp	x19, x20, [sp, 16]
	mov	w20, 0
	stp	x25, x26, [sp, 64]
.L789:
	ldrh	w0, [x21, 56]
	cmp	w0, w20
	bhi	.L804
	strh	wzr, [x21, 56]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L804:
	add	x0, x21, x20, sxtw 1
	ldrh	w25, [x0, 58]
	ldr	x0, [x23, #:lo12:.LANCHOR4]
	mov	x19, x25
	lsl	x26, x25, 1
	ldrh	w2, [x0, x26]
	cbz	w2, .L790
	mov	w1, w25
	mov	x0, x22
	bl	printf
.L790:
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	ldrh	w0, [x0, x26]
	cbnz	w0, .L791
	adrp	x0, .LANCHOR3
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x25, x0, x25, lsl 2
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L792
	ldrb	w2, [x25, 2]
	adrp	x0, .LC52
	mov	w1, w19
	add	x0, x0, :lo12:.LC52
	ubfx	x2, x2, 5, 3
	bl	printf
.L792:
	ldrb	w0, [x25, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L793
	tst	w0, 192
	bne	.L794
.L793:
	adrp	x1, .LANCHOR101
	adrp	x0, .LC0
	mov	w2, 770
	add	x1, x1, :lo12:.LANCHOR101
	add	x0, x0, :lo12:.LC0
	bl	printf
.L794:
	mov	w0, w19
	bl	ftl_free_sblk
	adrp	x0, .LANCHOR5
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldrh	w2, [x0, 124]
	cbz	w2, .L795
	add	x3, x0, 392
	mov	w1, 0
.L797:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L796
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 392]
	strh	w2, [x0, 124]
.L795:
	ldrh	w2, [x0, 120]
	cbz	w2, .L798
	add	x3, x0, 136
	mov	w1, 0
.L800:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L799
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 136]
	strh	w2, [x0, 120]
.L798:
	ldrh	w2, [x0, 122]
	cbz	w2, .L801
	add	x3, x0, 264
	mov	w1, 0
.L803:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L802
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 264]
	strh	w2, [x0, 122]
.L801:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L789
.L796:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L797
	b	.L795
.L799:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L800
	b	.L798
.L802:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L803
	b	.L801
.L791:
	mov	w2, 0
	mov	w1, 1
	mov	w0, w19
	bl	gc_add_sblk
	b	.L801
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
	adrp	x1, .LANCHOR96
	stp	x19, x20, [sp, 16]
	mov	w19, 21
	adrp	x22, .LANCHOR103
	ldrh	w1, [x1, #:lo12:.LANCHOR96]
	sub	w1, w19, w1
	mov	w19, 1
	lsl	w19, w19, w1
	sub	w19, w19, #1
	and	w19, w19, w0
	asr	w20, w0, w1
	adrp	x0, .LANCHOR102
	sxth	w19, w19
	ldrb	w0, [x0, #:lo12:.LANCHOR102]
	cbz	w0, .L828
	ldrh	w2, [x22, #:lo12:.LANCHOR103]
	cmp	w21, 0
	cset	w1, eq
	mov	w0, w20
	mul	w2, w2, w19
	bl	flash_erase_block_en
.L828:
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
	adrp	x23, .LANCHOR3
	stp	x25, x26, [sp, 64]
	and	w26, w0, 65535
	ldr	x0, [x23, #:lo12:.LANCHOR3]
	adrp	x25, .LANCHOR104
	stp	x21, x22, [sp, 32]
	ubfiz	x22, x26, 2, 16
	add	x0, x0, x22
	stp	x27, x28, [sp, 80]
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR95
	mov	w20, w1
	add	x25, x25, :lo12:.LANCHOR104
	ldrb	w28, [x0, 3]
	add	x24, x24, :lo12:.LANCHOR95
	add	x27, x29, 112
	mov	w19, 0
.L834:
	ldrb	w0, [x25]
	cmp	w19, w0
	bge	.L845
	ldrb	w1, [x24]
	adrp	x0, .LANCHOR103
	mov	w21, 0
	ldrh	w3, [x0, #:lo12:.LANCHOR103]
	sub	w4, w1, #1
	mov	w0, 0
	mul	w6, w19, w1
	mul	w5, w26, w1
	b	.L846
.L836:
	add	w2, w0, w6
	asr	w2, w28, w2
	tbnz	x2, 0, .L835
	and	w2, w0, w4
	add	w2, w2, w5
	mul	w2, w2, w3
	str	w2, [x27, w21, sxtw 2]
	add	w21, w21, 1
.L835:
	add	w0, w0, 1
.L846:
	cmp	w0, w1
	blt	.L836
	cmp	w1, 4
	bne	.L837
	mov	x3, 0
.L838:
	cmp	w21, w3
	bgt	.L839
.L840:
	add	w19, w19, 1
	b	.L834
.L839:
	ldr	w2, [x27, x3, lsl 2]
	mov	w1, w20
	str	x3, [x29, 104]
	mov	w0, w19
	bl	flash_erase_block_en
	ldr	x3, [x29, 104]
	add	x3, x3, 1
	b	.L838
.L837:
	cmp	w21, 2
	bne	.L841
	adrp	x0, .LANCHOR102
	ldrb	w0, [x0, #:lo12:.LANCHOR102]
	cbz	w0, .L842
	ldp	w2, w3, [x29, 112]
	cmp	w20, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_duplane_block
.L842:
	ldp	w2, w3, [x29, 112]
	mov	w1, w20
	mov	w0, w19
	bl	flash_erase_duplane_block
	b	.L840
.L841:
	cmp	w21, 1
	bne	.L840
	adrp	x0, .LANCHOR102
	ldrb	w0, [x0, #:lo12:.LANCHOR102]
	cbz	w0, .L844
	ldr	w2, [x29, 112]
	cmp	w20, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_block_en
.L844:
	ldr	w2, [x29, 112]
	mov	w1, w20
	mov	w0, w19
	bl	flash_erase_block_en
	b	.L840
.L845:
	adrp	x2, .LANCHOR97
	ldr	x3, [x23, #:lo12:.LANCHOR3]
	cbnz	w20, .L847
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
	bge	.L849
	strh	w0, [x1, 96]
.L849:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L847:
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
	bcs	.L849
	strh	w0, [x1, 98]
	b	.L849
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
	bls	.L859
	strh	wzr, [x1, 136]
.L859:
	ldrh	w0, [x1, 112]
	cbnz	w0, .L860
	adrp	x1, .LANCHOR105
	adrp	x0, .LC0
	mov	w2, 1012
	add	x1, x1, :lo12:.LANCHOR105
	add	x0, x0, :lo12:.LC0
	bl	printf
.L860:
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	mov	w5, 65535
.L863:
	ldrh	w2, [x1, 136]
.L861:
	mov	w3, w2
	cmp	w2, 63
	ble	.L862
	strh	wzr, [x1, 136]
	b	.L863
.L862:
	add	x4, x2, 1
	add	x0, x1, x4, lsl 1
	ldrh	w0, [x0, 158]
	cmp	w0, w5
	bne	.L866
	mov	x2, x4
	b	.L861
.L866:
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
	bls	.L869
	strh	wzr, [x1, 138]
.L869:
	ldrh	w0, [x1, 112]
	cmp	w0, 63
	bls	.L870
	adrp	x1, .LANCHOR106
	adrp	x0, .LC0
	mov	w2, 1036
	add	x1, x1, :lo12:.LANCHOR106
	add	x0, x0, :lo12:.LC0
	bl	printf
.L870:
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	mov	w4, 65535
.L873:
	ldrh	w1, [x0, 138]
.L871:
	mov	w2, w1
	cmp	w1, 63
	ble	.L872
	strh	wzr, [x0, 138]
	b	.L873
.L872:
	add	x3, x1, 1
	add	x5, x0, x3, lsl 1
	ldrh	w5, [x5, 158]
	cmp	w5, w4
	bne	.L874
	add	x2, x0, x2, sxtw 1
	strh	w20, [x2, 160]
	strh	w1, [x0, 138]
	ldrh	w1, [x0, 112]
	ldp	x19, x20, [sp, 16]
	add	w1, w1, 1
	strh	w1, [x0, 112]
	ldp	x29, x30, [sp], 32
	ret
.L874:
	mov	x1, x3
	b	.L871
	.size	ftl_free_sys_blk, .-ftl_free_sys_blk
	.section	.text.ftl_info_data_recovery,"ax",@progbits
	.align	2
	.global	ftl_info_data_recovery
	.type	ftl_info_data_recovery, %function
ftl_info_data_recovery:
	ldrh	w2, [x0]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L887
	stp	x29, x30, [sp, -48]!
	adrp	x1, .LANCHOR3
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ubfiz	x19, x2, 2, 16
	ldr	x20, [x1, #:lo12:.LANCHOR3]
	str	x21, [sp, 32]
	add	x21, x20, x19
	ldrb	w1, [x21, 2]
	tst	w1, 224
	bne	.L877
	ldrb	w0, [x0, 4]
	bfi	w1, w0, 5, 3
	strb	w1, [x21, 2]
	mov	w0, w2
	bl	zftl_remove_free_node
	ldrb	w0, [x21, 2]
	adrp	x1, .LANCHOR97
	ldr	x3, [x1, #:lo12:.LANCHOR97]
	tbz	x0, 3, .L881
	ldrh	w2, [x3, 116]
	sub	w2, w2, #1
	strh	w2, [x3, 116]
.L882:
	and	w0, w0, 224
	cmp	w0, 160
	bne	.L884
	ldr	w0, [x20, x19]
	ldr	x1, [x1, #:lo12:.LANCHOR97]
	ubfx	x2, x0, 11, 8
	add	w2, w2, 1
	bfi	w0, w2, 11, 8
	str	w0, [x20, x19]
	ldrh	w0, [x1, 120]
	sub	w0, w0, #1
	strh	w0, [x1, 120]
.L877:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L881:
	tst	w0, 24
	bne	.L883
	ldrh	w2, [x3, 114]
	sub	w2, w2, #1
	strh	w2, [x3, 114]
	b	.L882
.L883:
	ldrh	w2, [x3, 118]
	sub	w2, w2, #1
	strh	w2, [x3, 118]
	b	.L882
.L884:
	ldrh	w2, [x20, x19]
	cmp	w0, 64
	add	w3, w2, 1
	bfi	w2, w3, 0, 11
	strh	w2, [x20, x19]
	bne	.L885
	ldr	x1, [x1, #:lo12:.LANCHOR97]
	ldrh	w0, [x1, 122]
	sub	w0, w0, #1
	strh	w0, [x1, 122]
	b	.L877
.L885:
	cmp	w0, 96
	bne	.L877
	ldr	x1, [x1, #:lo12:.LANCHOR97]
	ldrh	w0, [x1, 124]
	sub	w0, w0, #1
	strh	w0, [x1, 124]
	b	.L877
.L887:
	ret
	.size	ftl_info_data_recovery, .-ftl_info_data_recovery
	.section	.text.ftl_get_ppa_from_index,"ax",@progbits
	.align	2
	.global	ftl_get_ppa_from_index
	.type	ftl_get_ppa_from_index, %function
ftl_get_ppa_from_index:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR5
	adrp	x3, .LANCHOR72
	and	w0, w0, 65535
	add	x29, sp, 0
	ldr	x2, [x1, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR80
	ldrb	w3, [x3, #:lo12:.LANCHOR72]
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	stp	x19, x20, [sp, 16]
	mul	w1, w1, w3
	cmp	w0, w1
	bge	.L891
	add	x2, x2, 16
.L892:
	ldrb	w1, [x2, 9]
	sdiv	w19, w0, w1
	msub	w0, w19, w1, w0
	add	x0, x2, x0, uxth 1
	ldrh	w20, [x0, 16]
	mov	w0, 65535
	cmp	w20, w0
	bne	.L893
	adrp	x1, .LANCHOR107
	adrp	x0, .LC0
	mov	w2, 1421
	add	x1, x1, :lo12:.LANCHOR107
	add	x0, x0, :lo12:.LC0
	bl	printf
.L893:
	adrp	x0, .LANCHOR103
	ldrh	w0, [x0, #:lo12:.LANCHOR103]
	madd	w0, w0, w20, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L891:
	sub	w0, w0, w1
	add	x2, x2, 48
	and	w0, w0, 65535
	b	.L892
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
.L896:
	cmp	w1, w3
	bne	.L898
	mov	w0, -1
	ret
.L898:
	uxtw	x2, w1
	ldr	w6, [x4, x2, lsl 2]
	cmp	w0, w6
	bne	.L897
	mov	w0, w1
	b	ftl_get_ppa_from_index
.L897:
	ldrh	w1, [x5, x2, lsl 1]
	b	.L896
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
	bne	.L900
	adrp	x1, .LANCHOR111
	adrp	x0, .LC0
	mov	w2, 1536
	add	x1, x1, :lo12:.LANCHOR111
	add	x0, x0, :lo12:.LC0
	bl	printf
.L900:
	adrp	x0, .LANCHOR80
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w1, w0
	bne	.L901
	adrp	x1, .LANCHOR111
	adrp	x0, .LC0
	mov	w2, 1537
	add	x1, x1, :lo12:.LANCHOR111
	add	x0, x0, :lo12:.LC0
	bl	printf
.L901:
	ldrh	w0, [x19, 6]
	cbnz	w0, .L902
	adrp	x1, .LANCHOR111
	adrp	x0, .LC0
	mov	w2, 1538
	add	x1, x1, :lo12:.LANCHOR111
	add	x0, x0, :lo12:.LC0
	bl	printf
.L902:
	ldrb	w0, [x19, 5]
	mov	w2, 65535
	add	x0, x0, 8
	ldrh	w3, [x19, x0, lsl 1]
	adrp	x0, .LANCHOR72
	ldrb	w4, [x0, #:lo12:.LANCHOR72]
.L903:
	cmp	w3, w2
	ldrb	w1, [x19, 5]
	beq	.L905
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
	bne	.L899
	add	w2, w2, 1
	strb	wzr, [x19, 5]
	strh	w2, [x19, 2]
.L899:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L905:
	add	w1, w1, 1
	and	w1, w1, 255
	strb	w1, [x19, 5]
	cmp	w1, w4
	bne	.L904
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 5]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L904:
	ldrb	w0, [x19, 5]
	add	x0, x0, 8
	ldrh	w3, [x19, x0, lsl 1]
	b	.L903
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
	bcs	.L909
	adrp	x1, .LANCHOR112
	adrp	x0, .LC0
	mov	w2, 1569
	add	x1, x1, :lo12:.LANCHOR112
	add	x0, x0, :lo12:.LC0
	bl	printf
.L909:
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
	adrp	x2, .LANCHOR113
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR113]
	cmp	w1, 4
	bhi	.L912
	cbnz	w0, .L912
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR113]
	ret
.L912:
	adrp	x0, .LANCHOR2
	strh	wzr, [x3, #:lo12:.LANCHOR113]
	mov	x1, 0
	mov	w2, 0
	ldrh	w5, [x0, #:lo12:.LANCHOR2]
	adrp	x0, .LANCHOR4
	mov	w8, 65535
	ldr	x6, [x0, #:lo12:.LANCHOR4]
	adrp	x0, .LANCHOR3
	ldr	x7, [x0, #:lo12:.LANCHOR3]
	mov	w0, 0
.L914:
	cmp	w5, w1, uxth
	bhi	.L917
	adrp	x1, .LANCHOR5
	ldr	x1, [x1, #:lo12:.LANCHOR5]
	str	w2, [x1, 524]
	adrp	x2, .LANCHOR97
	str	w0, [x1, 528]
	ldr	x2, [x2, #:lo12:.LANCHOR97]
	ldrh	w2, [x2, 120]
	cbz	w2, .L911
	udiv	w0, w0, w2
	str	w0, [x1, 532]
.L911:
	ret
.L917:
	ldrh	w3, [x6, x1, lsl 1]
	cmp	w3, w8
	beq	.L915
	add	x4, x7, x1, lsl 2
	ldrb	w4, [x4, 2]
	and	w4, w4, 224
	cmp	w4, 160
	bne	.L916
	add	w0, w0, w3
.L915:
	add	x1, x1, 1
	b	.L914
.L916:
	add	w2, w2, w3
	b	.L915
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
	adrp	x0, .LANCHOR4
	ubfiz	x19, x19, 1, 16
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	ldrh	w0, [x0, x19]
	ldr	x19, [sp, 16]
	cmp	w0, 0
	cset	w0, eq
	ldp	x29, x30, [sp], 32
	ret
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
	beq	.L926
	adrp	x0, .LANCHOR4
	ubfiz	x1, x19, 1, 16
	ldr	x2, [x0, #:lo12:.LANCHOR4]
	ldrh	w0, [x2, x1]
	cbnz	w0, .L927
	adrp	x0, .LC53
	mov	w2, 0
	mov	w1, w19
	add	x0, x0, :lo12:.LC53
	bl	printf
.L930:
	mov	w0, 0
	b	.L925
.L927:
	sub	w0, w0, #1
	strh	w0, [x2, x1]
.L926:
	adrp	x20, .LANCHOR114
	ldrh	w0, [x20, #:lo12:.LANCHOR114]
	cmp	w19, w0
	beq	.L930
	mov	w1, 65535
	cmp	w0, w1
	bne	.L929
	strh	w19, [x20, #:lo12:.LANCHOR114]
	b	.L930
.L929:
	bl	ftl_vpn_update
	cmp	w0, 0
	cset	w0, ne
	strh	w19, [x20, #:lo12:.LANCHOR114]
.L925:
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
.L933:
	cmp	w6, w12
	beq	.L937
	uxtw	x11, w6
	lsl	x10, x11, 2
	add	x13, x8, x10
	ldr	w10, [x8, x10]
	cmp	w0, w10
	lsl	x10, x11, 1
	bne	.L934
	mov	w6, -1
	str	w6, [x13]
	cmp	w7, w12
	bne	.L935
	add	x6, x3, :lo12:.LANCHOR108
	ldrh	w7, [x4, x10]
	strh	w7, [x6, x5, lsl 1]
.L936:
	mov	w6, -1
	strh	w6, [x4, x11, lsl 1]
.L937:
	uxtw	x6, w2
	add	x3, x3, :lo12:.LANCHOR108
	cmn	w1, #1
	str	w0, [x8, x6, lsl 2]
	ldrh	w0, [x3, x5, lsl 1]
	strh	w2, [x3, x5, lsl 1]
	strh	w0, [x4, x6, lsl 1]
	beq	.L944
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LANCHOR96
	add	x29, sp, 0
	ldrh	w3, [x0, #:lo12:.LANCHOR96]
	mov	w0, 21
	sub	w2, w0, w3
	mov	w0, 1
	lsr	w1, w1, w3
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w1, w0, w1
	adrp	x0, .LANCHOR95
	ldrb	w0, [x0, #:lo12:.LANCHOR95]
	udiv	w0, w1, w0
	bl	ftl_vpn_decrement
	mov	w0, -1
	ldp	x29, x30, [sp], 16
	ret
.L935:
	ldrh	w6, [x4, x10]
	strh	w6, [x4, w7, uxtw 1]
	b	.L936
.L934:
	mov	w7, w6
	ldrh	w6, [x4, x10]
	b	.L933
.L944:
	mov	w0, -1
	ret
	.size	lpa_hash_update_ppa, .-lpa_hash_update_ppa
	.section	.text.ftl_mask_bad_block,"ax",@progbits
	.align	2
	.global	ftl_mask_bad_block
	.type	ftl_mask_bad_block, %function
ftl_mask_bad_block:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR96
	mov	w2, 21
	add	x29, sp, 0
	ldrh	w3, [x1, #:lo12:.LANCHOR96]
	stp	x19, x20, [sp, 16]
	ubfx	x20, x0, 21, 3
	sub	w1, w2, w3
	mov	w2, 1
	lsr	w0, w0, w3
	lsl	w2, w2, w1
	sub	w2, w2, #1
	and	w2, w2, w0
	adrp	x0, .LANCHOR95
	ldrb	w0, [x0, #:lo12:.LANCHOR95]
	udiv	w2, w2, w0
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	and	w19, w2, 65535
	tbz	x0, 14, .L948
	adrp	x0, .LC54
	mov	w2, w19
	mov	w1, w20
	add	x0, x0, :lo12:.LC54
	bl	printf
.L948:
	adrp	x0, .LANCHOR2
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	cmp	w0, w19
	bls	.L947
	adrp	x0, .LANCHOR3
	mov	w1, 1
	lsl	w1, w1, w20
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x19, x0, x19, uxth 2
	ldrb	w0, [x19, 3]
	orr	w1, w1, w0
	strb	w1, [x19, 3]
.L947:
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
	adrp	x1, .LANCHOR86
	adrp	x0, .LANCHOR5
	adrp	x7, .LANCHOR54
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	ldrh	w6, [x1, #:lo12:.LANCHOR86]
	adrp	x1, .LANCHOR82
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldr	w7, [x7, #:lo12:.LANCHOR54]
	ldrh	w5, [x1, #:lo12:.LANCHOR82]
	adrp	x1, .LANCHOR84
	str	w7, [sp, 8]
	ldrh	w4, [x1, #:lo12:.LANCHOR84]
	adrp	x1, .LANCHOR93
	ldr	w7, [x0, 528]
	ldrh	w3, [x1, #:lo12:.LANCHOR93]
	adrp	x1, .LANCHOR91
	str	w7, [sp]
	ldrh	w2, [x1, #:lo12:.LANCHOR91]
	adrp	x1, .LANCHOR89
	ldr	w7, [x0, 524]
	adrp	x0, .LC55
	ldrh	w1, [x1, #:lo12:.LANCHOR89]
	add	x0, x0, :lo12:.LC55
	str	x19, [sp, 48]
	adrp	x19, .LANCHOR97
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	adrp	x1, .LANCHOR115
	ldrb	w3, [x1, #:lo12:.LANCHOR115]
	ldr	w4, [x0, 8]
	ldr	w5, [x0, 64]
	ldr	w1, [x0, 20]
	ldr	w2, [x0, 28]
	adrp	x0, .LC56
	add	x0, x0, :lo12:.LC56
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	ldr	w1, [x0, 52]
	ldr	w2, [x0, 60]
	ldr	w3, [x0, 16]
	adrp	x0, .LC57
	add	x0, x0, :lo12:.LC57
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
	adrp	x0, .LC58
	add	x0, x0, :lo12:.LC58
	bl	printf
	ldr	x19, [sp, 48]
	adrp	x0, .LANCHOR73
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 64
	ldrh	w5, [x0, #:lo12:.LANCHOR73]
	adrp	x0, .LANCHOR79
	ldrh	w4, [x0, #:lo12:.LANCHOR79]
	adrp	x0, .LANCHOR62
	ldrh	w3, [x0, #:lo12:.LANCHOR62]
	adrp	x0, .LANCHOR88
	ldrh	w2, [x0, #:lo12:.LANCHOR88]
	adrp	x0, .LANCHOR85
	ldrh	w1, [x0, #:lo12:.LANCHOR85]
	adrp	x0, .LC59
	add	x0, x0, :lo12:.LC59
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
	cbnz	x0, .L957
	adrp	x1, .LANCHOR116
	add	x1, x1, :lo12:.LANCHOR116
	mov	w2, 639
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	bl	print_ftl_debug_info
	mov	w0, -1
.L956:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L960:
	mov	x1, x19
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	bl	buf_add_tail
	adrp	x1, .LANCHOR97
	ldrb	w3, [x19, 56]
	ldrb	w0, [x21, #:lo12:.LANCHOR53]
	ldr	x1, [x1, #:lo12:.LANCHOR97]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x21, #:lo12:.LANCHOR53]
	ldr	w2, [x1, 16]
	add	w2, w2, w3
	str	w2, [x1, 16]
	ldr	w2, [x1, 32]
	add	w2, w2, 1
	str	w2, [x1, 32]
	b	.L956
.L957:
	mov	x19, x0
	adrp	x0, .LANCHOR117
	mov	x20, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR117]
	ldrb	w2, [x19, 56]
	cmp	w2, w1
	bls	.L962
	adrp	x1, .LANCHOR116
	adrp	x0, .LC0
	mov	w2, 644
	add	x1, x1, :lo12:.LANCHOR116
	add	x0, x0, :lo12:.LC0
	bl	printf
.L962:
	ldrb	w0, [x19, 56]
	adrp	x21, .LANCHOR53
	cbz	w0, .L959
	ldrb	w1, [x20, #:lo12:.LANCHOR117]
	cmp	w1, w0
	bcs	.L960
.L959:
	mov	x0, x19
	bl	buf_free
	ldrb	w0, [x21, #:lo12:.LANCHOR53]
	b	.L956
	.size	ftl_write_buf, .-ftl_write_buf
	.section	.text.ftl_write_completed,"ax",@progbits
	.align	2
	.global	ftl_write_completed
	.type	ftl_write_completed, %function
ftl_write_completed:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR118
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR46
	adrp	x22, .LANCHOR96
	add	x20, x20, :lo12:.LANCHOR118
	add	x19, x19, :lo12:.LANCHOR46
	add	x22, x22, :lo12:.LANCHOR96
	stp	x23, x24, [sp, 48]
	str	x25, [sp, 64]
.L968:
	ldrb	w0, [x20]
	cmp	w0, 255
	bne	.L974
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L974:
	ubfiz	x21, x0, 6, 8
	sbfiz	x0, x0, 6, 32
	add	x23, x19, x0
	add	x21, x19, x21
	ldrb	w0, [x19, x0]
	strb	w0, [x20]
	ldr	w0, [x23, 52]
	cmn	w0, #1
	bne	.L969
	ldp	w2, w3, [x23, 36]
	mov	w1, 21
	ldrh	w0, [x22]
	mov	w25, 1
	sub	w1, w1, w0
	lsr	w0, w3, w0
	lsl	w1, w25, w1
	sub	w1, w1, #1
	and	w1, w1, w0
	adrp	x0, .LANCHOR95
	ldrb	w0, [x0, #:lo12:.LANCHOR95]
	udiv	w1, w1, w0
	adrp	x0, .LC60
	add	x0, x0, :lo12:.LC60
	and	w24, w1, 65535
	mov	w1, w24
	bl	printf
	mov	w1, w25
	mov	w2, 0
	mov	w0, w24
	bl	gc_add_sblk
	adrp	x0, .LANCHOR5
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldr	w1, [x0, 556]
	add	w1, w1, w25
	str	w1, [x0, 556]
	ldrh	w1, [x0, 16]
	cmp	w1, w24
	bne	.L970
	strh	wzr, [x0, 22]
.L971:
	mov	x0, x21
	bl	ftl_write_buf
	b	.L968
.L970:
	ldrh	w1, [x0, 48]
	cmp	w1, w24
	bne	.L971
	strh	wzr, [x0, 54]
	b	.L971
.L969:
	ldrh	w2, [x23, 48]
	ldr	w0, [x23, 36]
	ldr	w1, [x23, 44]
	bl	lpa_hash_update_ppa
	ldrb	w0, [x23, 2]
	tbz	x0, 2, .L973
	and	w0, w0, -3
	strb	w0, [x23, 2]
	b	.L968
.L973:
	mov	x0, x21
	bl	buf_free
	b	.L968
	.size	ftl_write_completed, .-ftl_write_completed
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
	beq	.L978
	adrp	x0, .LANCHOR3
	lsl	w22, w22, 1
	ldr	x21, [x0, #:lo12:.LANCHOR3]
	add	x21, x21, x19, uxth 2
	ldrb	w0, [x21, 2]
	tst	w0, 224
	beq	.L979
	adrp	x1, .LANCHOR119
	adrp	x0, .LC0
	mov	w2, 757
	add	x1, x1, :lo12:.LANCHOR119
	add	x0, x0, :lo12:.LC0
	bl	printf
.L979:
	ldrb	w0, [x21, 2]
	bfi	w0, w20, 5, 3
	ubfx	x1, x0, 3, 2
	orr	w22, w22, w1
	bfi	w0, w22, 3, 2
	strb	w0, [x21, 2]
.L980:
	mov	w0, w19
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L978:
	bl	print_ftl_debug_info
	adrp	x21, .LC61
	mov	w2, w20
	add	x21, x21, :lo12:.LC61
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
	mov	w2, 767
	adrp	x1, .LANCHOR119
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR119
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L980
	.size	ftl_alloc_sblk, .-ftl_alloc_sblk
	.section	.text.sblk_init,"ax",@progbits
	.align	2
	.global	sblk_init
	.type	sblk_init, %function
sblk_init:
	adrp	x1, .LANCHOR120
	mov	w0, -1
	strb	w0, [x1, #:lo12:.LANCHOR120]
	adrp	x1, .LANCHOR118
	strb	w0, [x1, #:lo12:.LANCHOR118]
	adrp	x1, .LANCHOR58
	strb	w0, [x1, #:lo12:.LANCHOR58]
	adrp	x1, .LANCHOR65
	strb	w0, [x1, #:lo12:.LANCHOR65]
	mov	w0, 0
	ret
	.size	sblk_init, .-sblk_init
	.section	.text.dump_sblk_queue,"ax",@progbits
	.align	2
	.global	dump_sblk_queue
	.type	dump_sblk_queue, %function
dump_sblk_queue:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LC62
	add	x0, x0, :lo12:.LC62
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR120
	str	x21, [sp, 32]
	ldrb	w1, [x19, #:lo12:.LANCHOR120]
	bl	printf
	ldrb	w19, [x19, #:lo12:.LANCHOR120]
	cmp	w19, 255
	beq	.L987
	adrp	x1, .LANCHOR46
	ubfiz	x19, x19, 6, 8
	add	x1, x1, :lo12:.LANCHOR46
	adrp	x21, .LC63
	add	x19, x1, x19
	add	x21, x21, :lo12:.LC63
	mov	x20, x1
.L989:
	ldrb	w2, [x19, 58]
	mov	x0, x21
	ldrb	w1, [x19, 1]
	ldr	w3, [x19, 40]
	bl	printf
	ldrb	w19, [x19]
	cmp	w19, 255
	beq	.L987
	ubfiz	x19, x19, 6, 8
	add	x19, x20, x19
	b	.L989
.L987:
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
	adrp	x2, .LANCHOR120
	ldrb	w2, [x2, #:lo12:.LANCHOR120]
	cmp	w2, 255
	beq	.L1006
	adrp	x3, .LANCHOR96
	adrp	x7, .LANCHOR46
	add	x7, x7, :lo12:.LANCHOR46
	adrp	x10, .L1002
	ldrh	w8, [x3, #:lo12:.LANCHOR96]
	mov	w3, 21
	ubfx	x11, x0, 21, 3
	add	x10, x10, :lo12:.L1002
	sub	w4, w3, w8
	mov	w3, 1
	mov	x12, x7
	lsl	w3, w3, w4
	adrp	x4, .LANCHOR95
	sub	w3, w3, #1
	ldrb	w6, [x4, #:lo12:.LANCHOR95]
	and	w3, w3, 65535
	asr	w4, w0, w8
	sub	w6, w6, #1
	and	w6, w6, 65535
	and	w4, w4, w6
	and	w4, w4, w3
.L1005:
	add	x0, x7, x2, lsl 6
	ldr	w5, [x0, 40]
	ubfx	x13, x5, 21, 3
	cmp	w11, w13
	bne	.L999
	lsr	w5, w5, w8
	and	w5, w6, w5
	and	w5, w3, w5
	ldrb	w0, [x0, 58]
	cmp	w4, w5
	bne	.L1000
	cmp	w1, 1
	bne	.L997
	cmp	w0, 6
	ccmp	w0, 8, 4, ne
	beq	.L999
	ret
.L1000:
	cmp	w1, 3
	bhi	.L999
	ldrb	w5, [x10,w1,uxtw]
	adr	x13, .Lrtx1002
	add	x5, x13, w5, sxtb #2
	br	x5
.Lrtx1002:
	.section	.rodata.queue_lun_state,"a",@progbits
	.align	0
	.align	2
.L1002:
	.byte	(.L1001 - .Lrtx1002) / 4
	.byte	(.L1003 - .Lrtx1002) / 4
	.byte	(.L1004 - .Lrtx1002) / 4
	.byte	(.L997 - .Lrtx1002) / 4
	.section	.text.queue_lun_state
.L1001:
	cmp	w0, 2
	beq	.L999
	ret
.L1003:
	cmp	w0, 6
	ccmp	w0, 8, 4, ne
	beq	.L999
	ret
.L1004:
	cmp	w0, 10
	bne	.L997
.L999:
	lsl	x2, x2, 6
	ldrb	w2, [x12, x2]
	cmp	w2, 255
	bne	.L1005
.L1006:
	mov	w0, 0
.L997:
	ret
	.size	queue_lun_state, .-queue_lun_state
	.section	.text.queue_remove_completed_req,"ax",@progbits
	.align	2
	.global	queue_remove_completed_req
	.type	queue_remove_completed_req, %function
queue_remove_completed_req:
	adrp	x6, .LANCHOR120
	ldrb	w2, [x6, #:lo12:.LANCHOR120]
	cmp	w2, 255
	beq	.L1008
	adrp	x0, .LANCHOR46
	lsl	x4, x2, 6
	add	x5, x0, :lo12:.LANCHOR46
	add	x3, x5, x4
	ldrb	w1, [x3, 58]
	sub	w1, w1, #11
	and	w1, w1, 255
	cmp	w1, 1
	mov	x1, x0
	bhi	.L1008
	ldrb	w0, [x5, x4]
	strb	w0, [x6, #:lo12:.LANCHOR120]
	mov	w0, -1
	strb	w0, [x5, x4]
	ldrb	w0, [x3, 59]
	cmp	w0, 1
	bne	.L1010
	ldrh	w0, [x3, 50]
	cbnz	w0, .L1011
	adrp	x0, .LANCHOR118
	ldrb	w3, [x0, #:lo12:.LANCHOR118]
	add	x0, x0, :lo12:.LANCHOR118
.L1012:
	cmp	w3, 255
	bne	.L1016
	add	x1, x1, :lo12:.LANCHOR46
	add	x1, x1, x2, lsl 6
	ldrb	w1, [x1, 1]
	strb	w1, [x0]
	ret
.L1011:
	adrp	x0, .LANCHOR65
	ldrb	w3, [x0, #:lo12:.LANCHOR65]
	add	x0, x0, :lo12:.LANCHOR65
	b	.L1012
.L1010:
	cbnz	w0, .L1008
	ldr	w0, [x3, 36]
	cmn	w0, #1
	beq	.L1008
	adrp	x0, .LANCHOR58
	ldrb	w3, [x0, #:lo12:.LANCHOR58]
	add	x0, x0, :lo12:.LANCHOR58
	b	.L1012
.L1016:
	add	x0, x1, :lo12:.LANCHOR46
.L1023:
	mov	w1, w3
	sbfiz	x3, x3, 6, 32
	ldrb	w3, [x0, x3]
	cmp	w3, 255
	bne	.L1023
	add	x2, x0, x2, lsl 6
	sbfiz	x1, x1, 6, 32
	ldrb	w2, [x2, 1]
	strb	w2, [x0, x1]
	ret
.L1008:
	ret
	.size	queue_remove_completed_req, .-queue_remove_completed_req
	.section	.text.pm_alloc_new_blk,"ax",@progbits
	.align	2
	.global	pm_alloc_new_blk
	.type	pm_alloc_new_blk, %function
pm_alloc_new_blk:
	stp	x29, x30, [sp, -64]!
	adrp	x2, .LANCHOR72
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR97
	stp	x21, x22, [sp, 32]
	ldr	x1, [x20, #:lo12:.LANCHOR97]
	ldrb	w2, [x2, #:lo12:.LANCHOR72]
	ldrh	w0, [x1, 690]
	str	x23, [sp, 48]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, 690]
	cmp	w2, w0
	bls	.L1025
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x0, 672]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1026
.L1025:
	adrp	x19, .LC64
	add	x19, x19, :lo12:.LC64
	adrp	x23, .LANCHOR3
.L1038:
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
	bne	.L1027
	mov	w1, w21
	mov	x0, x19
	bl	printf
	ldr	x1, [x23, #:lo12:.LANCHOR3]
	add	x1, x1, x21, uxth 2
	ldrb	w0, [x1, 2]
	orr	w0, w0, -32
	strb	w0, [x1, 2]
	b	.L1038
.L1027:
	ldr	x0, [x14]
	adrp	x1, .LANCHOR121
	mov	w2, 1
	mov	w19, 0
	add	x0, x0, 416
	str	w2, [x1, #:lo12:.LANCHOR121]
	mov	w1, 65535
	strh	wzr, [x0, 274]
.L1029:
	ldrh	w2, [x0]
	cmp	w2, w1
	beq	.L1028
	add	w19, w19, 1
	add	x0, x0, 2
	and	w19, w19, 65535
	cmp	w19, 128
	bne	.L1029
	adrp	x1, .LANCHOR122
	adrp	x0, .LC0
	mov	w2, 192
	add	x1, x1, :lo12:.LANCHOR122
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1028:
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	add	x19, x0, x19, sxtw 1
	ldrh	w1, [x0, 688]
	strh	w21, [x19, 416]
	add	w1, w1, 1
	strh	w1, [x0, 688]
.L1026:
	ldr	x1, [x20, #:lo12:.LANCHOR97]
	ldrh	w0, [x1, 690]
	add	x0, x0, 336
	ldrh	w19, [x1, x0, lsl 1]
	mov	w0, 65533
	sub	w1, w19, #1
	cmp	w0, w1, uxth
	bcs	.L1031
	adrp	x1, .LANCHOR122
	adrp	x0, .LC0
	mov	w2, 197
	add	x1, x1, :lo12:.LANCHOR122
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1031:
	adrp	x1, .LANCHOR96
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	mov	w2, 21
	ldrh	w1, [x1, #:lo12:.LANCHOR96]
	sub	w2, w2, w1
	strh	wzr, [x0, 696]
	strh	w19, [x0, 692]
	asr	w4, w19, w2
	strh	w4, [x0, 694]
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L1034
	mov	w0, 1
	and	w4, w4, 65535
	lsl	w2, w0, w2
	mov	w3, w19
	adrp	x0, .LC65
	sub	w2, w2, #1
	mov	w1, w19
	add	x0, x0, :lo12:.LC65
	bl	printf
.L1034:
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
	adrp	x0, .LANCHOR123
	add	x0, x0, :lo12:.LANCHOR123
	mov	x1, 0
	add	x29, sp, 0
	mov	w2, 65535
	str	x19, [sp, 16]
.L1043:
	lsl	x3, x1, 4
	and	w19, w1, 65535
	ldrh	w3, [x3, x0]
	cmp	w3, w2
	beq	.L1042
	add	x1, x1, 1
	cmp	x1, 32
	bne	.L1043
	add	x0, x0, 2
	mov	w19, w1
	mov	x2, x0
	mov	w4, 32768
	mov	w1, 0
.L1045:
	ldrh	w3, [x2]
	tbnz	x3, 15, .L1044
	cmp	w3, w4
	bcs	.L1044
	mov	w4, w3
	mov	w19, w1
.L1044:
	add	w1, w1, 1
	add	x2, x2, 16
	and	w1, w1, 65535
	cmp	w1, 32
	bne	.L1045
	cmp	w19, 32
	bne	.L1042
	adrp	x1, .LANCHOR124
	mov	w2, -1
	ldrb	w3, [x1, #:lo12:.LANCHOR124]
	mov	w1, 0
.L1047:
	ldrh	w5, [x0]
	cmp	w5, w2
	bcs	.L1046
	ldrh	w4, [x0, -2]
	cmp	w4, w3
	csel	w2, w2, w5, eq
	csel	w19, w19, w1, eq
.L1046:
	add	w1, w1, 1
	add	x0, x0, 16
	and	w1, w1, 65535
	cmp	w1, 32
	bne	.L1047
	cmp	w19, 32
	bne	.L1042
	adrp	x1, .LANCHOR125
	adrp	x0, .LC0
	mov	w2, 295
	add	x1, x1, :lo12:.LANCHOR125
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1042:
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
	adrp	x19, .LANCHOR27
	cbnz	w0, .L1054
	add	x1, x19, :lo12:.LANCHOR27
	mov	x0, 0
.L1055:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 256
	bne	.L1055
.L1061:
	adrp	x20, .LANCHOR126
	add	x20, x20, :lo12:.LANCHOR126
	mov	w2, 1024
	mov	w1, 255
	mov	x0, x20
	add	x19, x19, :lo12:.LANCHOR27
	bl	ftl_memset
	mov	x0, 0
.L1056:
	ldrh	w1, [x0, x19]
	add	x0, x0, 2
	cmp	x0, 512
	strh	w1, [x20, w1, sxtw 1]
	bne	.L1056
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1054:
	cmp	w0, 1
	bne	.L1057
	add	x3, x19, :lo12:.LANCHOR27
	mov	x1, 0
.L1060:
	and	w0, w1, 65535
	cmp	x1, 3
	bls	.L1058
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 2
	sub	w0, w2, w0
	and	w0, w0, 65535
.L1058:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L1060
	b	.L1061
.L1057:
	cmp	w0, 2
	bne	.L1062
	add	x3, x19, :lo12:.LANCHOR27
	mov	w1, 65535
	mov	x0, 0
.L1064:
	cmp	x0, 2
	and	w2, w0, 65535
	csel	w2, w2, w1, cc
	strh	w2, [x3, x0, lsl 1]
	add	w1, w1, 2
	add	x0, x0, 1
	and	w1, w1, 65535
	cmp	x0, 256
	bne	.L1064
	b	.L1061
.L1062:
	cmp	w0, 3
	bne	.L1065
	add	x3, x19, :lo12:.LANCHOR27
	mov	x1, 0
.L1068:
	and	w0, w1, 65535
	cmp	x1, 5
	bls	.L1066
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 4
	sub	w0, w2, w0
	and	w0, w0, 65535
.L1066:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L1068
	b	.L1061
.L1065:
	cmp	w0, 4
	bne	.L1069
	add	x1, x19, :lo12:.LANCHOR27
	mov	w2, 1
	add	x1, x1, 16
	strh	wzr, [x19, #:lo12:.LANCHOR27]
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
.L1071:
	and	w3, w0, 1
	ubfiz	w2, w0, 1, 15
	add	w3, w3, 6
	add	w0, w0, 1
	sub	w2, w2, w3
	strh	w2, [x1], 2
	and	w0, w0, 65535
	cmp	w0, 256
	bne	.L1071
	b	.L1061
.L1069:
	cmp	w0, 5
	bne	.L1072
	add	x1, x19, :lo12:.LANCHOR27
	mov	x0, 0
.L1073:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 16
	bne	.L1073
	add	x1, x1, 32
.L1074:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 496
	bne	.L1074
	b	.L1061
.L1072:
	cmp	w0, 8
	bne	.L1061
	add	x1, x19, :lo12:.LANCHOR27
	mov	x0, 0
.L1075:
	strh	w0, [x0, x1]
	add	x0, x0, 2
	cmp	x0, 512
	bne	.L1075
	b	.L1061
	.size	flash_lsb_page_tbl_build, .-flash_lsb_page_tbl_build
	.section	.text.flash_die_info_init,"ax",@progbits
	.align	2
	.global	flash_die_info_init
	.type	flash_die_info_init, %function
flash_die_info_init:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR7
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	tbz	x0, 12, .L1091
	adrp	x1, .LANCHOR127
	adrp	x0, .LC1
	add	x1, x1, :lo12:.LANCHOR127
	add	x0, x0, :lo12:.LC1
	bl	printf
.L1091:
	adrp	x23, .LANCHOR32
	add	x19, x23, :lo12:.LANCHOR32
	adrp	x25, .LANCHOR26
	adrp	x26, .LANCHOR12
	adrp	x22, .LANCHOR24
	add	x21, x22, :lo12:.LANCHOR24
	ldrh	w0, [x19, 26]
	mov	w2, 8
	ldrb	w1, [x19, 12]
	adrp	x24, .LANCHOR129
	strh	w0, [x25, #:lo12:.LANCHOR26]
	add	x20, x24, :lo12:.LANCHOR129
	ldrh	w0, [x19, 10]
	add	x19, x19, 1
	strb	wzr, [x26, #:lo12:.LANCHOR12]
	sdiv	w0, w0, w1
	adrp	x1, .LANCHOR128
	strh	w0, [x1, #:lo12:.LANCHOR128]
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	mov	w2, 32
	mov	w1, 0
	mov	x0, x20
	bl	ftl_memset
	ldrb	w13, [x23, #:lo12:.LANCHOR32]
	mov	x7, x23
	adrp	x14, .LANCHOR38
	add	x11, x26, :lo12:.LANCHOR12
	add	x23, x14, :lo12:.LANCHOR38
	mov	x8, 0
.L1093:
	mov	w2, w13
	add	x1, x23, x8, lsl 3
	mov	x0, x19
	bl	flash_mem_cmp8
	cbnz	w0, .L1092
	ldrb	w1, [x11]
	add	w0, w1, 1
	strb	w0, [x11]
	str	wzr, [x20, x1, lsl 2]
	strb	w8, [x21, x1]
.L1092:
	add	x8, x8, 1
	cmp	x8, 4
	bne	.L1093
	add	x0, x7, :lo12:.LANCHOR32
	ldrb	w1, [x0, 8]
	cmp	w1, 2
	beq	.L1094
.L1098:
	add	x7, x7, :lo12:.LANCHOR32
	ldrb	w0, [x26, #:lo12:.LANCHOR12]
	ldp	x19, x20, [sp, 16]
	ldrb	w1, [x7, 13]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	mul	w0, w0, w1
	ldrh	w1, [x7, 14]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	mul	w0, w0, w1
	adrp	x1, .LANCHOR130
	strh	w0, [x1, #:lo12:.LANCHOR130]
	ret
.L1094:
	ldrh	w1, [x25, #:lo12:.LANCHOR26]
	add	x14, x14, :lo12:.LANCHOR38
	ldrb	w11, [x0, 13]
	add	x8, x0, 1
	ldrb	w20, [x0, 23]
	add	x19, x26, :lo12:.LANCHOR12
	add	x15, x24, :lo12:.LANCHOR129
	add	x22, x22, :lo12:.LANCHOR24
	mov	x12, 0
	mul	w11, w11, w1
	ldrh	w1, [x0, 14]
	and	w1, w1, 65280
	mul	w11, w11, w1
	lsl	w21, w11, 1
.L1097:
	mov	w2, w13
	add	x1, x14, x12, lsl 3
	mov	x0, x8
	bl	flash_mem_cmp8
	cbnz	w0, .L1095
	ldrb	w1, [x19]
	cmp	w20, 0
	csel	w2, w11, w21, eq
	add	w0, w1, 1
	strb	w0, [x19]
	str	w2, [x15, x1, lsl 2]
	strb	w12, [x22, x1]
.L1095:
	add	x12, x12, 1
	cmp	x12, 4
	bne	.L1097
	b	.L1098
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
	adrp	x0, .LANCHOR80
	mov	w1, 255
	ldp	x29, x30, [sp], 16
	ldrh	w2, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR72
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
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
	adrp	x0, .LANCHOR7
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	tbz	x0, 12, .L1111
	adrp	x1, .LANCHOR131
	adrp	x0, .LC66
	mov	w3, 0
	mov	w2, 218
	add	x1, x1, :lo12:.LANCHOR131
	add	x0, x0, :lo12:.LC66
	bl	printf
.L1111:
	adrp	x20, .LANCHOR80
	adrp	x22, .LANCHOR72
	adrp	x19, .LANCHOR108
	add	x19, x19, :lo12:.LANCHOR108
	mov	w2, 512
	mov	w1, 255
	mov	x0, x19
	bl	ftl_memset
	ldrh	w2, [x20, #:lo12:.LANCHOR80]
	adrp	x21, .LANCHOR110
	ldrb	w0, [x22, #:lo12:.LANCHOR72]
	mov	w1, 255
	add	x20, x20, :lo12:.LANCHOR80
	mul	w2, w2, w0
	ldr	x0, [x21, #:lo12:.LANCHOR110]
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR109
	ldrb	w3, [x22, #:lo12:.LANCHOR72]
	ldr	x5, [x21, #:lo12:.LANCHOR110]
	mov	w1, 0
	ldr	x4, [x0, #:lo12:.LANCHOR109]
.L1112:
	ldrh	w0, [x20]
	mul	w0, w0, w3
	cmp	w1, w0, lsl 1
	blt	.L1114
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L1114:
	uxtw	x2, w1
	ldr	w0, [x4, x2, lsl 2]
	cmn	w0, #1
	beq	.L1113
	and	x0, x0, 255
	ldrh	w6, [x19, x0, lsl 1]
	strh	w1, [x19, x0, lsl 1]
	strh	w6, [x5, x2, lsl 1]
.L1113:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L1112
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
	adrp	x0, .LANCHOR26
	mov	w4, 1
	ldrb	w3, [x1, 9]
	ldrh	w0, [x0, #:lo12:.LANCHOR26]
	mul	w0, w3, w0
	and	w2, w0, 65535
	strb	w2, [x19, 4]
	ubfx	x0, x2, 8, 8
	strb	w0, [x19, 5]
	adrp	x0, .LANCHOR40
	ldrb	w0, [x0, #:lo12:.LANCHOR40]
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
	adrp	x2, .LANCHOR24
	strb	w0, [x19, 3]
	mov	w0, 32
	strb	w0, [x19, 8]
	add	x2, x2, :lo12:.LANCHOR24
	ldrb	w0, [x1, 7]
	mov	x1, 0
	strb	w0, [x19, 9]
	adrp	x0, .LANCHOR12
	ldrb	w3, [x0, #:lo12:.LANCHOR12]
.L1123:
	cmp	w3, w1, uxtb
	bhi	.L1124
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1124:
	ldrb	w0, [x1, x2]
	add	x1, x1, 1
	ldrb	w5, [x19, 10]
	lsl	w0, w4, w0
	orr	w0, w0, w5
	strb	w0, [x19, 10]
	b	.L1123
	.size	zftl_read_flash_info, .-zftl_read_flash_info
	.section	.text.gc_static_wearleveling,"ax",@progbits
	.align	2
	.global	gc_static_wearleveling
	.type	gc_static_wearleveling, %function
gc_static_wearleveling:
	stp	x29, x30, [sp, -160]!
	mov	w1, 10240
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR97
	stp	x19, x20, [sp, 16]
	ldr	x5, [x22, #:lo12:.LANCHOR97]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldr	w0, [x5, 32]
	cmp	w0, w1
	bls	.L1127
	ldr	w1, [x5, 36]
	add	w1, w1, w0, lsr 10
	and	w0, w0, 1023
	stp	w0, w1, [x5, 32]
.L1127:
	adrp	x25, .LANCHOR5
	ldr	w3, [x5, 36]
	ldr	x0, [x25, #:lo12:.LANCHOR5]
	ldr	w1, [x0, 568]
	ldr	w2, [x0, 12]
	add	w1, w1, 860160
	add	w1, w1, 3840
	cmp	w2, w1
	bhi	.L1128
	ldr	w1, [x0, 572]
	add	w1, w1, 32
	cmp	w3, w1
	bls	.L1126
.L1128:
	adrp	x21, .LANCHOR3
	ldrh	w10, [x5, 134]
	adrp	x23, .LANCHOR2
	mov	w27, 65535
	ldr	x8, [x21, #:lo12:.LANCHOR3]
	mov	w19, w27
	ldrh	w11, [x23, #:lo12:.LANCHOR2]
	mov	w12, w27
	str	w2, [x0, 568]
	mov	w4, 0
	add	x8, x8, x10, uxth 2
	str	w3, [x0, 572]
	mov	w1, 0
	mov	w20, 0
	mov	w26, 0
	mov	w3, 0
	mov	w2, 0
.L1130:
	cmp	w10, w11
	bcc	.L1134
	ldrh	w0, [x5, 96]
	cmp	w0, w20
	bcs	.L1135
	strh	w20, [x5, 96]
.L1135:
	ldrh	w0, [x5, 98]
	cmp	w0, w26
	bcs	.L1136
	strh	w26, [x5, 98]
.L1136:
	udiv	w3, w3, w1
	adrp	x24, .LANCHOR7
	udiv	w4, w4, w2
	ldr	w0, [x24, #:lo12:.LANCHOR7]
	strh	w3, [x5, 88]
	strh	w4, [x5, 90]
	tbz	x0, 10, .L1137
	adrp	x0, .LC67
	and	w4, w4, 65535
	and	w3, w3, 65535
	add	x0, x0, :lo12:.LC67
	bl	printf
.L1137:
	ldr	w0, [x24, #:lo12:.LANCHOR7]
	adrp	x28, .LANCHOR132
	tbz	x0, 10, .L1138
	adrp	x0, .LANCHOR133
	ldrh	w6, [x28, #:lo12:.LANCHOR132]
	mov	w4, w26
	mov	w3, w20
	ldrh	w5, [x0, #:lo12:.LANCHOR133]
	mov	w2, w19
	adrp	x0, .LC68
	mov	w1, w27
	add	x0, x0, :lo12:.LC68
	bl	printf
.L1138:
	ldr	x0, [x25, #:lo12:.LANCHOR5]
	mov	w1, 255
	mov	w2, 128
	add	x0, x0, 264
	strh	wzr, [x0, -142]
	bl	ftl_memset
	sub	w0, w26, w19
	str	w0, [x29, 148]
	ldrh	w0, [x28, #:lo12:.LANCHOR132]
	ldr	w1, [x29, 148]
	cmp	w1, w0
	bgt	.L1139
	adrp	x1, .LANCHOR133
	sub	w0, w20, w27
	ldrh	w1, [x1, #:lo12:.LANCHOR133]
	cmp	w0, w1
	bgt	.L1139
.L1146:
	cbnz	w19, .L1140
.L1148:
	cbz	w27, .L1126
	ldr	x2, [x22, #:lo12:.LANCHOR97]
	ldr	x1, [x21, #:lo12:.LANCHOR3]
	ldrh	w5, [x23, #:lo12:.LANCHOR2]
	ldrh	w0, [x2, 134]
	add	x1, x1, x0, uxth 2
.L1153:
	cmp	w0, w5
	bcc	.L1155
	ldrh	w0, [x2, 74]
	add	w0, w27, w0
	strh	w0, [x2, 74]
	ldrh	w0, [x2, 96]
	cmp	w27, w0
	bcs	.L1126
	sub	w7, w0, w27
	strh	w7, [x2, 96]
.L1126:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L1134:
	ldrb	w0, [x8, 2]
	tbz	x0, 3, .L1131
	ldr	w0, [x8]
	ldrh	w6, [x8]
	ubfx	x0, x0, 11, 8
	and	w6, w6, 2047
.L1132:
	cmp	w6, w27
	add	w1, w1, 1
	csel	w7, w6, w27, cc
	cmp	w6, w20
	csel	w20, w6, w20, hi
	and	w1, w1, 65535
	add	w3, w3, w6
	and	w27, w7, 65535
	and	w20, w20, 65535
	cmp	w0, w12
	bne	.L1156
	b	.L1157
.L1131:
	tst	w0, 24
	bne	.L1133
	ldrh	w6, [x8]
	mov	w0, 65535
	and	w6, w6, 2047
	b	.L1132
.L1133:
	ldr	w0, [x8]
	ubfx	x0, x0, 11, 8
.L1156:
	cmp	w0, w19
	add	w2, w2, 1
	csel	w19, w0, w19, cc
	cmp	w0, w26
	add	w4, w4, w0
	csel	w0, w0, w26, hi
	and	w2, w2, 65535
	and	w19, w19, 65535
	and	w26, w0, 65535
.L1157:
	add	w10, w10, 1
	add	x8, x8, 4
	and	w10, w10, 65535
	b	.L1130
.L1139:
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	adrp	x25, .LANCHOR63
	stp	wzr, wzr, [x29, 152]
	ldrh	w26, [x0, 134]
	add	x0, x23, :lo12:.LANCHOR2
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR133
	add	x0, x0, :lo12:.LANCHOR133
	str	x0, [x29, 120]
	add	x0, x25, :lo12:.LANCHOR63
	str	x0, [x29, 136]
.L1142:
	ldr	x0, [x29, 128]
	ldrh	w0, [x0]
	cmp	w0, w26
	bls	.L1146
	uxtw	x25, w26
	ldr	x4, [x21, #:lo12:.LANCHOR3]
	lsl	x3, x25, 2
	add	x0, x4, x3
	ldrb	w0, [x0, 2]
	tst	w0, 192
	beq	.L1143
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L1143
	tbz	x0, 4, .L1144
	ldrh	w0, [x28, #:lo12:.LANCHOR132]
	ldr	w1, [x29, 148]
	cmp	w1, w0
	ble	.L1145
	ldr	w0, [x4, x3]
	add	w1, w19, 1
	ubfx	x0, x0, 11, 8
	cmp	w0, w1
	bgt	.L1145
	stp	x4, x3, [x29, 104]
	mov	w2, 1
	mov	w1, 0
	mov	w0, w26
	bl	gc_add_sblk
	ldr	w0, [x29, 156]
	ldp	x4, x3, [x29, 104]
	add	w0, w0, 1
	str	w0, [x29, 156]
	ldr	w0, [x24, #:lo12:.LANCHOR7]
	tbz	x0, 10, .L1145
	adrp	x0, .LANCHOR4
	ldr	w6, [x4, x3]
	ldrh	w5, [x4, x3]
	ldr	x1, [x0, #:lo12:.LANCHOR4]
	ldr	x0, [x21, #:lo12:.LANCHOR3]
	ubfx	x6, x6, 11, 8
	and	w5, w5, 2047
	add	x3, x0, x3
	ldr	x0, [x29, 136]
	ldrb	w2, [x3, 2]
	ldrh	w4, [x0, 56]
	adrp	x0, .LC69
	ldrh	w3, [x1, x25, lsl 1]
	add	x0, x0, :lo12:.LC69
	ubfx	x2, x2, 5, 3
	mov	w1, w26
.L1180:
	bl	printf
.L1145:
	ldr	w0, [x29, 156]
	cmp	w0, 4
	ldr	w0, [x29, 152]
	ccmp	w0, 4, 2, ls
	bhi	.L1146
.L1143:
	add	w8, w26, 1
	and	w26, w8, 65535
	b	.L1142
.L1144:
	ldr	x1, [x29, 120]
	sub	w0, w20, w27
	ldrh	w1, [x1]
	cmp	w0, w1
	ble	.L1145
	ldrh	w0, [x4, x3]
	add	w1, w27, 1
	and	w0, w0, 2047
	cmp	w0, w1
	bgt	.L1145
	stp	x4, x3, [x29, 104]
	mov	w2, 1
	mov	w1, 0
	mov	w0, w26
	bl	gc_add_sblk
	ldr	w0, [x29, 152]
	ldp	x4, x3, [x29, 104]
	add	w0, w0, 1
	str	w0, [x29, 152]
	ldr	w0, [x24, #:lo12:.LANCHOR7]
	tbz	x0, 10, .L1145
	adrp	x0, .LANCHOR4
	ldr	w6, [x4, x3]
	ldrh	w5, [x4, x3]
	ldr	x1, [x0, #:lo12:.LANCHOR4]
	ldr	x0, [x21, #:lo12:.LANCHOR3]
	ubfx	x6, x6, 11, 8
	and	w5, w5, 2047
	add	x3, x0, x3
	ldr	x0, [x29, 136]
	ldrb	w2, [x3, 2]
	ldrh	w4, [x0, 56]
	adrp	x0, .LC70
	ldrh	w3, [x1, x25, lsl 1]
	add	x0, x0, :lo12:.LC70
	ubfx	x2, x2, 5, 3
	mov	w1, w26
	b	.L1180
.L1140:
	ldr	x2, [x22, #:lo12:.LANCHOR97]
	ldr	x1, [x21, #:lo12:.LANCHOR3]
	ldrh	w5, [x23, #:lo12:.LANCHOR2]
	ldrh	w0, [x2, 134]
	add	x1, x1, x0, uxth 2
.L1149:
	cmp	w0, w5
	bcc	.L1151
	ldrh	w0, [x2, 72]
	add	w0, w19, w0
	strh	w0, [x2, 72]
	ldrh	w0, [x2, 98]
	cmp	w19, w0
	bcs	.L1148
	sub	w19, w0, w19
	strh	w19, [x2, 98]
	b	.L1148
.L1151:
	ldr	w3, [x1]
	ubfx	x4, x3, 11, 8
	cmp	w19, w4
	bhi	.L1150
	sub	w4, w4, w19
	bfi	w3, w4, 11, 8
	str	w3, [x1]
.L1150:
	add	w0, w0, 1
	add	x1, x1, 4
	and	w0, w0, 65535
	b	.L1149
.L1155:
	ldrh	w3, [x1]
	and	w4, w3, 2047
	cmp	w4, w27
	blt	.L1154
	sub	w4, w4, w27
	bfi	w3, w4, 0, 11
	strh	w3, [x1]
.L1154:
	add	w0, w0, 1
	add	x1, x1, 4
	and	w0, w0, 65535
	b	.L1153
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
	adrp	x27, .LANCHOR2
	adrp	x28, .LANCHOR0
	stp	x19, x20, [sp, 16]
	ldrh	w2, [x27, #:lo12:.LANCHOR2]
	adrp	x20, .LANCHOR86
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR82
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR93
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR97
	mul	w2, w2, w0
	ldr	x0, [x28, #:lo12:.LANCHOR0]
	adrp	x24, .LANCHOR89
	adrp	x23, .LANCHOR91
	adrp	x21, .LANCHOR84
	bl	ftl_memset
	str	x28, [x29, 168]
	adrp	x2, .LANCHOR72
	adrp	x3, .LANCHOR80
	adrp	x10, .LANCHOR90
	adrp	x8, .LANCHOR92
	ldrb	w0, [x2, #:lo12:.LANCHOR72]
	adrp	x7, .LANCHOR94
	ldrh	w1, [x3, #:lo12:.LANCHOR80]
	adrp	x6, .LANCHOR76
	adrp	x5, .LANCHOR75
	adrp	x4, .LANCHOR74
	str	xzr, [x10, #:lo12:.LANCHOR90]
	adrp	x28, .LANCHOR3
	str	xzr, [x8, #:lo12:.LANCHOR92]
	mul	w1, w0, w1
	mov	w0, 32768
	str	xzr, [x7, #:lo12:.LANCHOR94]
	str	xzr, [x6, #:lo12:.LANCHOR76]
	str	xzr, [x5, #:lo12:.LANCHOR75]
	sdiv	w0, w0, w1
	str	xzr, [x4, #:lo12:.LANCHOR74]
	strh	wzr, [x24, #:lo12:.LANCHOR89]
	strh	wzr, [x23, #:lo12:.LANCHOR91]
	strh	wzr, [x22, #:lo12:.LANCHOR93]
	sxth	w0, w0
	str	w0, [x29, 188]
	ldr	x0, [x25, #:lo12:.LANCHOR97]
	strh	wzr, [x21, #:lo12:.LANCHOR84]
	strh	wzr, [x20, #:lo12:.LANCHOR86]
	strh	wzr, [x19, #:lo12:.LANCHOR82]
	strh	wzr, [x0, 146]
	ldrsh	w26, [x0, 134]
	add	x0, x27, :lo12:.LANCHOR2
	adrp	x27, .LC71
	add	x27, x27, :lo12:.LC71
	stp	x3, x2, [x29, 104]
	stp	x4, x5, [x29, 120]
	stp	x6, x7, [x29, 136]
	stp	x8, x10, [x29, 152]
	str	x0, [x29, 176]
.L1182:
	ldr	x0, [x29, 176]
	ldrh	w0, [x0]
	cmp	w26, w0
	blt	.L1198
	ldr	x0, [x25, #:lo12:.LANCHOR97]
	ldrh	w1, [x24, #:lo12:.LANCHOR89]
	ldp	x25, x26, [sp, 64]
	strh	w1, [x0, 114]
	ldrh	w1, [x23, #:lo12:.LANCHOR91]
	strh	w1, [x0, 118]
	ldrh	w1, [x22, #:lo12:.LANCHOR93]
	strh	w1, [x0, 116]
	ldrh	w1, [x21, #:lo12:.LANCHOR84]
	strh	w1, [x0, 122]
	ldrh	w1, [x20, #:lo12:.LANCHOR86]
	strh	w1, [x0, 120]
	ldrh	w1, [x19, #:lo12:.LANCHOR82]
	strh	w1, [x0, 124]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L1198:
	ldr	x4, [x28, #:lo12:.LANCHOR3]
	sxtw	x2, w26
	add	x4, x4, x2, lsl 2
	ldrb	w6, [x4, 3]
	cbz	w6, .L1199
	ldr	x0, [x29, 112]
	mov	w1, 0
	ldr	x7, [x25, #:lo12:.LANCHOR97]
	ldrb	w8, [x0, #:lo12:.LANCHOR72]
	ldr	x0, [x29, 104]
	ldrh	w10, [x0, #:lo12:.LANCHOR80]
	mov	w0, 0
.L1184:
	cmp	w1, w8
	blt	.L1187
	cbz	w0, .L1188
	mov	w1, 32768
	sdiv	w0, w1, w0
	sxth	w0, w0
.L1183:
	ldr	x3, [x29, 168]
	mov	w1, 6
	smull	x1, w26, w1
	ldr	x5, [x3, #:lo12:.LANCHOR0]
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
	beq	.L1189
	adrp	x5, .LANCHOR5
	ldr	x5, [x5, #:lo12:.LANCHOR5]
	ldrh	w6, [x5, 16]
	cmp	w26, w6
	beq	.L1189
	ldrh	w6, [x5, 48]
	cmp	w26, w6
	beq	.L1189
	ldrh	w5, [x5, 80]
	cmp	w26, w5
	beq	.L1189
	cmp	w0, 64
	bne	.L1190
	ldr	x0, [x29, 128]
	add	x2, x21, :lo12:.LANCHOR84
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR75
.L1202:
	bl	_insert_data_list
.L1189:
	add	w3, w26, 1
	sxth	w26, w3
	b	.L1182
.L1187:
	asr	w5, w6, w1
	tbnz	x5, 0, .L1185
	add	w0, w10, w0
	sxth	w0, w0
.L1186:
	add	w1, w1, 1
	b	.L1184
.L1185:
	ldrh	w5, [x7, 146]
	add	w5, w5, 1
	strh	w5, [x7, 146]
	b	.L1186
.L1188:
	ldrb	w1, [x4, 2]
	mov	w5, -1
	orr	w1, w1, -32
	strb	w1, [x4, 2]
	adrp	x1, .LANCHOR4
	ldr	x1, [x1, #:lo12:.LANCHOR4]
	strh	w5, [x1, x2, lsl 1]
	b	.L1183
.L1199:
	ldr	w0, [x29, 188]
	b	.L1183
.L1190:
	cmp	w0, 96
	bne	.L1191
	ldr	x0, [x29, 136]
	add	x2, x19, :lo12:.LANCHOR82
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR76
	b	.L1202
.L1191:
	cmp	w0, 160
	bne	.L1192
	ldr	x0, [x29, 120]
	add	x2, x20, :lo12:.LANCHOR86
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR74
	b	.L1202
.L1192:
	cbnz	w0, .L1189
	adrp	x0, .LANCHOR4
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	ldrh	w2, [x0, x2, lsl 1]
	cbz	w2, .L1193
	str	x4, [x29, 96]
	mov	w1, w26
	mov	x0, x27
	bl	printf
	ldr	x4, [x29, 96]
	ldrb	w0, [x4, 2]
	tbz	x0, 4, .L1194
	mov	w1, 5
.L1201:
	bfi	w0, w1, 5, 3
	strb	w0, [x4, 2]
	mov	w2, 0
	mov	w1, 1
	mov	w0, w26
	bl	gc_add_sblk
	b	.L1189
.L1194:
	mov	w1, 2
	b	.L1201
.L1193:
	ands	w1, w1, 24
	bne	.L1196
	ldr	x0, [x29, 160]
	add	x2, x24, :lo12:.LANCHOR89
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR90
.L1203:
	bl	_insert_free_list
	b	.L1189
.L1196:
	cmp	w1, 16
	bne	.L1197
	ldr	x0, [x29, 152]
	add	x2, x23, :lo12:.LANCHOR91
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR92
	b	.L1203
.L1197:
	ldr	x0, [x29, 144]
	add	x2, x22, :lo12:.LANCHOR93
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR94
	b	.L1203
	.size	zftl_sblk_list_init, .-zftl_sblk_list_init
	.section	.text.ftl_open_sblk_init,"ax",@progbits
	.align	2
	.global	ftl_open_sblk_init
	.type	ftl_open_sblk_init, %function
ftl_open_sblk_init:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR72
	stp	x21, x22, [sp, 32]
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	adrp	x21, .LC64
	adrp	x23, .LANCHOR80
	mov	w22, w1
	add	x23, x23, :lo12:.LANCHOR80
	add	x20, x20, :lo12:.LANCHOR72
	add	x21, x21, :lo12:.LC64
	stp	x25, x26, [sp, 64]
.L1205:
.L1208:
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
	beq	.L1209
	ldrb	w0, [x20]
	mul	w0, w1, w0
	and	w0, w0, 65535
.L1206:
	ldrb	w2, [x20]
	adrp	x26, .LANCHOR4
	strh	w0, [x19, 12]
	ubfiz	x25, x24, 1, 16
	mul	w2, w2, w1
	adrp	x1, .LANCHOR109
	ldr	x3, [x1, #:lo12:.LANCHOR109]
	mov	w1, 255
	lsl	w2, w2, 2
	add	x0, x3, x0, uxth 2
	bl	ftl_memset
	ldr	x0, [x26, #:lo12:.LANCHOR4]
	ldrh	w1, [x19, 6]
	strh	w1, [x0, x25]
	ldrb	w0, [x19, 9]
	cbnz	w0, .L1204
	mov	w1, w24
	mov	x0, x21
	bl	printf
	ldr	x0, [x26, #:lo12:.LANCHOR4]
	mov	w1, -1
	strh	w1, [x0, x25]
	mov	w0, 7
	strb	w0, [x19, 4]
	b	.L1208
.L1209:
	mov	w0, 0
	b	.L1206
.L1204:
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
	adrp	x20, .LANCHOR134
	stp	x21, x22, [sp, 32]
	ldrh	w0, [x20, #:lo12:.LANCHOR134]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w0, 128
	stp	x27, x28, [sp, 80]
	bls	.L1212
	adrp	x1, .LANCHOR135
	adrp	x0, .LC0
	mov	w2, 76
	add	x1, x1, :lo12:.LANCHOR135
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1212:
	add	x28, x29, 112
	mov	w2, 256
	mov	w1, 0
	mov	x0, x28
	bl	ftl_memset
	adrp	x23, .LANCHOR95
	adrp	x5, .LANCHOR97
	adrp	x0, .LANCHOR96
	mov	w2, 21
	ldrb	w12, [x23, #:lo12:.LANCHOR95]
	ldr	x7, [x5, #:lo12:.LANCHOR97]
	ldrh	w11, [x0, #:lo12:.LANCHOR96]
	ldrh	w13, [x20, #:lo12:.LANCHOR134]
	add	x4, x7, 704
	sub	w0, w2, w11
	mov	w2, 1
	ldrh	w1, [x7, 698]
	lsl	w2, w2, w0
	sub	w2, w2, #1
	add	x1, x1, 176
	add	x1, x7, x1, lsl 2
.L1213:
	cmp	x4, x1
	bne	.L1217
	adrp	x24, .LANCHOR72
	adrp	x25, .LANCHOR80
	adrp	x26, .LANCHOR7
	adrp	x27, .LC72
	ldrb	w22, [x24, #:lo12:.LANCHOR72]
	add	x20, x20, :lo12:.LANCHOR134
	ldrh	w0, [x25, #:lo12:.LANCHOR80]
	add	x26, x26, :lo12:.LANCHOR7
	add	x27, x27, :lo12:.LC72
	mov	w19, 0
	str	wzr, [x29, 108]
	mul	w22, w22, w0
	and	w22, w22, 65535
.L1218:
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L1224
	ldr	w0, [x29, 108]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 368
	ret
.L1217:
	ldr	w0, [x4]
	add	x8, x7, 416
	mov	x3, 0
	lsr	w0, w0, w11
	and	w0, w0, w2
	udiv	w0, w0, w12
	and	w0, w0, 65535
.L1214:
	cmp	w13, w3, uxth
	bhi	.L1216
	add	x4, x4, 4
	b	.L1213
.L1216:
	ldrh	w10, [x8]
	cmp	w10, w0
	bne	.L1215
	ldrh	w10, [x28, x3, lsl 1]
	add	w10, w10, 1
	strh	w10, [x28, x3, lsl 1]
.L1215:
	add	x3, x3, 1
	add	x8, x8, 2
	b	.L1214
.L1224:
	ldr	x1, [x5, #:lo12:.LANCHOR97]
	sxtw	x21, w19
	add	x0, x21, 208
	ldrb	w2, [x23, #:lo12:.LANCHOR95]
	ldrh	w3, [x1, x0, lsl 1]
	ldrh	w0, [x1, 692]
	sdiv	w0, w0, w2
	cmp	w0, w3
	bne	.L1219
	ldrb	w0, [x24, #:lo12:.LANCHOR72]
	ldrh	w2, [x25, #:lo12:.LANCHOR80]
	mul	w0, w0, w2
	strh	w0, [x28, x21, lsl 1]
.L1219:
	ldrh	w0, [x28, x21, lsl 1]
	cmp	w22, w0
	bls	.L1220
	cbnz	w0, .L1225
.L1222:
	mov	w0, 65535
	cmp	w3, w0
	beq	.L1221
	ldr	w0, [x26]
	tbz	x0, 12, .L1223
	ldrh	w4, [x1, 688]
	mov	w2, 0
	str	x5, [x29, 96]
	mov	w1, w19
	mov	x0, x27
	bl	printf
	ldr	x5, [x29, 96]
.L1223:
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
	b	.L1221
.L1220:
	cbz	w0, .L1222
.L1221:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1218
.L1225:
	mov	w22, w0
	str	w19, [x29, 108]
	b	.L1221
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
	adrp	x0, .LANCHOR7
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	str	x19, [sp, 16]
	tbz	x0, 12, .L1234
	adrp	x2, .LANCHOR136
	adrp	x0, .LC73
	add	x2, x2, :lo12:.LANCHOR136
	mov	w1, 100
	add	x0, x0, :lo12:.LC73
	bl	printf
.L1234:
	adrp	x19, .LANCHOR20
	mov	w2, 2048
	mov	w1, 0
	ldr	x0, [x19, #:lo12:.LANCHOR20]
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR20]
	mov	w1, 21321
	movk	w1, 0x5359, lsl 16
	mov	w2, 32
	add	x0, x0, 80
	str	w1, [x0, -80]
	mov	w1, 2032
	str	w1, [x0, -72]
	mov	w1, 1
	strh	w1, [x0, -64]
	adrp	x1, .LANCHOR13
	add	x1, x1, :lo12:.LANCHOR13
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR20]
	mov	w2, 32
	ldr	x19, [sp, 16]
	adrp	x1, .LANCHOR32
	ldp	x29, x30, [sp], 32
	add	x1, x1, :lo12:.LANCHOR32
	add	x0, x0, 48
	b	ftl_memcpy
	.size	flash_into_data_init, .-flash_into_data_init
	.section	.text.ftl_memcpy32,"ax",@progbits
	.align	2
	.global	ftl_memcpy32
	.type	ftl_memcpy32, %function
ftl_memcpy32:
	mov	x3, 0
.L1240:
	cmp	w2, w3
	bhi	.L1241
	ret
.L1241:
	ldr	w4, [x1, x3, lsl 2]
	str	w4, [x0, x3, lsl 2]
	add	x3, x3, 1
	b	.L1240
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
	adrp	x21, .LANCHOR7
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	str	wzr, [x29, 56]
	tbz	x0, 12, .L1246
	adrp	x1, .LANCHOR137
	adrp	x0, .LC74
	mov	x2, x19
	add	x1, x1, :lo12:.LANCHOR137
	add	x0, x0, :lo12:.LC74
	bl	printf
.L1246:
	adrp	x20, .LANCHOR22
	mov	w0, 6
	ldr	w2, [x19, 352]
	mov	w1, 12336
	strb	w0, [x20, #:lo12:.LANCHOR22]
	adrp	x0, .LANCHOR21
	movk	w1, 0x5638, lsl 16
	mov	x22, x0
	str	x19, [x0, #:lo12:.LANCHOR21]
	cmp	w2, w1
	bne	.L1247
	mov	w0, 8
	strb	w0, [x20, #:lo12:.LANCHOR22]
.L1247:
	ldr	w1, [x19, 128]
	mov	w0, 12336
	movk	w0, 0x5639, lsl 16
	cmp	w1, w0
	bne	.L1248
	mov	w0, 9
	strb	w0, [x20, #:lo12:.LANCHOR22]
.L1248:
	ldrb	w0, [x20, #:lo12:.LANCHOR22]
	cmp	w0, 9
	adrp	x0, .LANCHOR41
	bne	.L1249
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR41]
	ldr	w0, [x29, 56]
	orr	w0, w0, 256
	str	w0, [x29, 56]
	ldr	w0, [x29, 56]
	str	w0, [x19]
	str	wzr, [x19, 520]
	mov	w0, 4225
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
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L1251
	ldr	w1, [x19]
	ldr	w2, [x19, 8]
	ldr	w3, [x19, 80]
	ldr	w4, [x19, 84]
	ldr	w5, [x19, 88]
.L1264:
	adrp	x0, .LC75
	add	x0, x0, :lo12:.LC75
	bl	printf
.L1251:
	adrp	x0, .LANCHOR42
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR42]
	adrp	x0, .LANCHOR44
	strh	wzr, [x0, #:lo12:.LANCHOR44]
	adrp	x0, .LANCHOR40
	strb	wzr, [x0, #:lo12:.LANCHOR40]
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L1245
	ldrb	w1, [x20, #:lo12:.LANCHOR22]
	adrp	x0, .LC76
	add	x0, x0, :lo12:.LC76
	bl	printf
.L1245:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1249:
	strb	wzr, [x0, #:lo12:.LANCHOR41]
	ldr	w0, [x29, 56]
	orr	w0, w0, 256
	str	w0, [x29, 56]
	ldr	w0, [x29, 56]
	str	w0, [x19]
	str	wzr, [x19, 336]
	mov	w0, 4225
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
	adrp	x1, .LANCHOR43
	str	x0, [x1, #:lo12:.LANCHOR43]
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L1251
	ldr	x0, [x22, #:lo12:.LANCHOR21]
	ldr	w1, [x0]
	ldr	w2, [x0, 344]
	ldr	w3, [x0, 304]
	ldr	w4, [x0, 308]
	ldr	w5, [x0, 312]
	b	.L1264
	.size	nandc_init, .-nandc_init
	.section	.text.buf_init,"ax",@progbits
	.align	2
	.global	buf_init
	.type	buf_init, %function
buf_init:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR46
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	x19, x0, :lo12:.LANCHOR46
	stp	x21, x22, [sp, 32]
	mov	x20, x0
	adrp	x22, .LANCHOR117
	add	x22, x22, :lo12:.LANCHOR117
	mov	w21, 0
.L1266:
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
	bne	.L1266
	add	x0, x20, :lo12:.LANCHOR46
	mov	w1, -1
	strb	w1, [x0, 1984]
	adrp	x0, .LANCHOR47
	strb	wzr, [x0, #:lo12:.LANCHOR47]
	adrp	x0, .LANCHOR48
	ldp	x19, x20, [sp, 16]
	strb	w21, [x0, #:lo12:.LANCHOR48]
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
	adrp	x0, .LANCHOR70
	mov	w2, 328
	mov	w1, 0
	add	x29, sp, 0
	strb	wzr, [x0, #:lo12:.LANCHOR70]
	adrp	x0, .LANCHOR138
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR63
	add	x19, x20, :lo12:.LANCHOR63
	strb	wzr, [x0, #:lo12:.LANCHOR138]
	mov	x0, x19
	bl	ftl_memset
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR63]
	adrp	x0, .LANCHOR80
	str	xzr, [x19, 8]
	adrp	x4, .LANCHOR88
	adrp	x20, .LANCHOR71
	ldrh	w1, [x0, #:lo12:.LANCHOR80]
	lsr	w2, w1, 1
	lsr	w0, w1, 2
	strh	w2, [x19, 38]
	adrp	x2, .LANCHOR81
	strh	w0, [x19, 36]
	adrp	x19, .LANCHOR72
	strh	wzr, [x2, #:lo12:.LANCHOR81]
	adrp	x2, .LANCHOR77
	ldrb	w3, [x19, #:lo12:.LANCHOR72]
	strh	wzr, [x2, #:lo12:.LANCHOR77]
	adrp	x2, .LANCHOR78
	strh	wzr, [x2, #:lo12:.LANCHOR78]
	mul	w2, w1, w3
	and	w2, w2, 65535
	sub	w5, w2, #32
	strh	w5, [x4, #:lo12:.LANCHOR88]
	adrp	x4, .LANCHOR85
	strh	w2, [x4, #:lo12:.LANCHOR85]
	adrp	x2, .LANCHOR79
	strh	w1, [x2, #:lo12:.LANCHOR79]
	adrp	x1, .LANCHOR62
	strh	w0, [x1, #:lo12:.LANCHOR62]
	ldrh	w0, [x20, #:lo12:.LANCHOR71]
	mul	w0, w0, w3
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR139
	str	x0, [x1, #:lo12:.LANCHOR139]
	ldrb	w1, [x19, #:lo12:.LANCHOR72]
	ldrh	w0, [x20, #:lo12:.LANCHOR71]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR140
	str	x0, [x1, #:lo12:.LANCHOR140]
	ldrh	w1, [x20, #:lo12:.LANCHOR71]
	ldrb	w0, [x19, #:lo12:.LANCHOR72]
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR68
	str	x0, [x1, #:lo12:.LANCHOR68]
	ldrb	w1, [x19, #:lo12:.LANCHOR72]
	ldrh	w0, [x20, #:lo12:.LANCHOR71]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR64
	str	x0, [x1, #:lo12:.LANCHOR64]
	ldrb	w1, [x19, #:lo12:.LANCHOR72]
	ldrh	w0, [x20, #:lo12:.LANCHOR71]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR141
	ldp	x19, x20, [sp, 16]
	str	x0, [x1, #:lo12:.LANCHOR141]
	adrp	x0, .LANCHOR83
	ldp	x29, x30, [sp], 32
	ldrh	w1, [x0, #:lo12:.LANCHOR83]
	adrp	x0, .LANCHOR73
	strh	w1, [x0, #:lo12:.LANCHOR73]
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
.L1273:
	cmp	w1, w3
	bhi	.L1274
	ret
.L1274:
	lsr	w2, w0, 2
	ldrb	w5, [x4, x3]
	add	w2, w2, w0, lsl 5
	add	x3, x3, 1
	add	w2, w2, w5
	eor	w0, w0, w2
	b	.L1273
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
	adrp	x21, .LC78
	stp	x23, x24, [sp, 48]
	mov	x22, x1
	stp	x25, x26, [sp, 64]
	adrp	x23, .LC77
	mov	x26, x0
	mov	w24, w2
	uxtw	x25, w3
	add	x23, x23, :lo12:.LC77
	add	x21, x21, :lo12:.LC78
	stp	x19, x20, [sp, 16]
	str	x27, [sp, 80]
	mov	x19, 0
	mov	w20, 0
	adrp	x27, .LC79
.L1281:
	cmp	x25, x19
	bne	.L1287
	ldp	x19, x20, [sp, 16]
	adrp	x1, .LC79
	ldp	x21, x22, [sp, 32]
	add	x1, x1, :lo12:.LC79
	ldp	x23, x24, [sp, 48]
	adrp	x0, .LC80
	ldp	x25, x26, [sp, 64]
	add	x0, x0, :lo12:.LC80
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L1287:
	cbnz	w20, .L1282
	mov	w2, w19
	mov	x1, x26
	mov	x0, x23
	bl	printf
.L1282:
	cmp	w24, 4
	bne	.L1283
	ldr	w1, [x22, x19, lsl 2]
.L1289:
	mov	x0, x21
	add	w20, w20, 1
	bl	printf
	cmp	w20, 15
	bls	.L1286
	mov	w20, 0
	add	x1, x27, :lo12:.LC79
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	bl	printf
.L1286:
	add	x19, x19, 1
	b	.L1281
.L1283:
	cmp	w24, 2
	bne	.L1285
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L1289
.L1285:
	ldrb	w1, [x22, x19]
	b	.L1289
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
	adrp	x0, .LANCHOR20
	stp	x19, x20, [sp, 16]
	ldr	x28, [x0, #:lo12:.LANCHOR20]
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
	bne	.L1291
	mov	w0, -89
	strb	w0, [x28, 128]
	adrp	x0, .LANCHOR142+17
	mov	w1, -9
	strb	w1, [x0, #:lo12:.LANCHOR142+17]
.L1346:
	mov	w0, 7
	b	.L1381
.L1291:
	ldr	w3, [x29, 140]
	cmp	w3, 3
	bne	.L1293
	mov	x6, 0
.L1294:
	sub	w0, w6, #80
	strb	w0, [x22, x6]
	add	x6, x6, 1
	cmp	x6, 8
	bne	.L1294
	stp	w6, w6, [x29, 132]
.L1292:
	ldr	w0, [x29, 140]
	sub	w0, w0, #1
	cmp	w0, 1
	bhi	.L1299
	adrp	x7, .LANCHOR12
	adrp	x11, .LANCHOR24
	add	x24, x7, :lo12:.LANCHOR12
	add	x25, x11, :lo12:.LANCHOR24
	mov	w20, 0
	mov	w26, 55
.L1300:
	ldrb	w0, [x24]
	cmp	w0, w20
	bhi	.L1306
.L1307:
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
.L1293:
	ldr	w3, [x29, 140]
	cmp	w3, 4
	bne	.L1295
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
.L1382:
	str	w0, [x29, 136]
	b	.L1292
.L1295:
	ldr	w0, [x29, 140]
	cmp	w0, 5
	bne	.L1296
	mov	w0, 56
	strb	w0, [x28, 128]
	mov	w0, 57
	strb	w0, [x28, 129]
	mov	w0, 58
	strb	w0, [x28, 130]
	mov	w0, 59
	strb	w0, [x28, 131]
	mov	w0, 8
.L1381:
	str	w0, [x29, 132]
	mov	w0, 4
	b	.L1382
.L1296:
	ldr	w0, [x29, 140]
	cmp	w0, 6
	bne	.L1297
	mov	w0, 14
	strb	w0, [x28, 128]
	mov	w0, 15
	strb	w0, [x28, 129]
	mov	w0, 16
	strb	w0, [x28, 130]
	mov	w0, 17
	strb	w0, [x28, 131]
	mov	w0, 12
	b	.L1381
.L1297:
	ldr	w0, [x29, 140]
	cmp	w0, 7
	bne	.L1346
	mov	x0, 0
.L1298:
	sub	w1, w0, #80
	strb	w1, [x22, x0]
	add	x0, x0, 1
	cmp	x0, 8
	bne	.L1298
	mov	w0, -44
	strb	w0, [x28, 136]
	mov	w0, -43
	strb	w0, [x28, 137]
	mov	w0, 12
	str	w0, [x29, 132]
	mov	w0, 10
	b	.L1382
.L1306:
	ldrb	w0, [x25, w20, sxtw]
	mov	x1, 32
	mov	w2, 160
	mov	x21, 0
	umaddl	x2, w2, w0, x1
	ldr	x1, [x29, 112]
	ubfiz	x0, x0, 8, 8
	add	x19, x1, x2
	adrp	x1, .LANCHOR21
	ldr	x4, [x1, #:lo12:.LANCHOR21]
	add	x23, x4, x0
.L1301:
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
	bhi	.L1301
	adrp	x3, .LANCHOR142
	add	x3, x3, :lo12:.LANCHOR142
	mov	x0, 0
.L1304:
	add	x15, x19, x0
	add	x14, x3, x0
	mov	x1, 1
.L1303:
	lsl	x4, x1, 2
	lsl	x16, x1, 3
	ldrb	w17, [x19, x0]
	add	x1, x1, 1
	cmp	x1, 7
	ldrb	w4, [x14, x4]
	add	w4, w4, w17
	strb	w4, [x15, x16]
	bne	.L1303
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L1304
	add	w5, w20, 1
	strb	wzr, [x19, 16]
	strb	wzr, [x19, 24]
	and	w20, w5, 255
	strb	wzr, [x19, 32]
	strb	wzr, [x19, 40]
	strb	wzr, [x19, 48]
	strb	wzr, [x19, 41]
	strb	wzr, [x19, 49]
	b	.L1300
.L1299:
	ldr	w0, [x29, 140]
	sub	w0, w0, #3
	cmp	w0, 4
	bhi	.L1307
	ldp	w0, w1, [x29, 132]
	adrp	x19, .LANCHOR12
	add	x19, x19, :lo12:.LANCHOR12
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
.L1308:
	ldrb	w0, [x19]
	ldr	w1, [x29, 128]
	cmp	w0, w1
	bls	.L1307
	ldr	w1, [x29, 128]
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	mov	w10, 160
	mov	w23, 255
	ldrb	w4, [x0, w1, sxtw]
	mov	x0, 32
	umaddl	x10, w10, w4, x0
	ldr	x0, [x29, 112]
	ubfiz	x4, x4, 8, 8
	add	x0, x0, x10
	str	x0, [x29, 104]
	adrp	x0, .LANCHOR21
	ldr	x0, [x0, #:lo12:.LANCHOR21]
	add	x27, x0, x4
	str	w23, [x27, 2056]
	bl	nandc_wait_flash_ready
	mov	w0, 54
	str	w0, [x27, 2056]
	ldr	w0, [x29, 140]
	cmp	w0, 4
	bne	.L1309
	mov	w0, 64
	str	w23, [x27, 2052]
	str	w0, [x27, 2048]
	mov	w0, 204
.L1383:
	str	w0, [x27, 2052]
	mov	w0, 77
	b	.L1384
.L1309:
	cmp	w20, 1
	bhi	.L1311
	ldrb	w0, [x28, 128]
	str	w0, [x27, 2052]
	mov	w0, 82
.L1384:
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
	bne	.L1312
	mov	w0, 31
	str	w0, [x27, 2052]
.L1313:
	mov	w23, 2
	str	w23, [x27, 2052]
	str	wzr, [x27, 2052]
	mov	w0, 48
	str	w0, [x27, 2056]
	bl	nandc_wait_flash_ready
	cmp	w20, 1
	bls	.L1347
	ldr	w0, [x29, 140]
	cmp	w0, 7
	mov	w0, 32
	csel	w23, w23, w0, ne
.L1314:
	adrp	x3, .LANCHOR143
	mov	x1, 0
	ldr	x0, [x3, #:lo12:.LANCHOR143]
.L1315:
	ldr	w2, [x27, 2048]
	strb	w2, [x0, x1]
	add	x1, x1, 1
	cmp	w23, w1, uxtb
	bhi	.L1315
	ldr	w1, [x29, 140]
	cmp	w1, 7
	bne	.L1316
	mov	w1, 0
.L1318:
	ldrb	w2, [x0]
	cmp	w2, 12
	beq	.L1317
	ldrb	w2, [x0, 1]
	cmp	w2, 10
	beq	.L1317
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1318
.L1319:
	adrp	x0, .LC81
	mov	w1, 0
	add	x0, x0, :lo12:.LC81
	bl	printf
.L1321:
	b	.L1321
.L1311:
	mov	w0, 174
	str	w0, [x27, 2052]
	str	wzr, [x27, 2048]
	mov	w0, 176
	b	.L1383
.L1312:
	str	wzr, [x27, 2052]
	b	.L1313
.L1347:
	mov	w23, 16
	b	.L1314
.L1317:
	cmp	w1, 6
	bhi	.L1319
.L1320:
	ldr	x2, [x3, #:lo12:.LANCHOR143]
	mov	x0, 0
.L1325:
	ldr	w1, [x29, 120]
	cmp	w1, w0
	bgt	.L1326
	ldr	x1, [x3, #:lo12:.LANCHOR143]
	mov	w16, 8
	add	x3, x1, x21
.L1328:
	mov	x0, 0
.L1327:
	ldr	w17, [x3, x0, lsl 2]
	ldr	w4, [x29, 124]
	mvn	w17, w17
	str	w17, [x3, x0, lsl 2]
	add	x0, x0, 1
	cmp	w4, w0
	bgt	.L1327
	add	x3, x3, x22, uxtw 2
	subs	w16, w16, #1
	bne	.L1328
	mov	x17, x1
	mov	w23, 0
	mov	w26, 1
.L1329:
	mov	w3, 0
	mov	w0, 0
.L1333:
	mov	x25, x17
	lsl	w16, w26, w0
	mov	w24, 16
	mov	w30, 0
.L1331:
	ldr	w4, [x25]
	add	x25, x25, x21
	bics	wzr, w16, w4
	cinc	w30, w30, eq
	subs	w24, w24, #1
	bne	.L1331
	cmp	w30, 9
	orr	w16, w3, w16
	add	w0, w0, 1
	csel	w3, w16, w3, cs
	cmp	w0, 32
	bne	.L1333
	ldr	w0, [x29, 124]
	add	w23, w23, 1
	str	w3, [x17], 4
	cmp	w0, w23
	bgt	.L1329
	mov	x0, 0
	mov	w3, 0
.L1336:
	ldr	w16, [x1, x0]
	add	x0, x0, 4
	cmp	w16, 0
	cinc	w3, w3, eq
	cmp	x0, 32
	bne	.L1336
	cmp	w3, 7
	ble	.L1337
	mov	w3, 1024
	mov	w2, 1
	adrp	x0, .LC82
	add	x0, x0, :lo12:.LC82
	bl	rknand_print_hex
	adrp	x0, .LC81
	mov	w1, 0
	add	x0, x0, :lo12:.LC81
	bl	printf
.L1338:
	b	.L1338
.L1316:
	ldr	w1, [x29, 140]
	cmp	w1, 6
	bne	.L1320
	mov	x1, 0
.L1322:
	ldrb	w2, [x0, x1]
	cmp	w2, 12
	beq	.L1320
	add	x2, x0, x1
	ldrb	w2, [x2, 8]
	cmp	w2, 4
	beq	.L1320
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L1322
	adrp	x0, .LC81
	mov	w1, 0
	add	x0, x0, :lo12:.LC81
	bl	printf
.L1324:
	b	.L1324
.L1326:
	ldr	w1, [x27, 2048]
	strb	w1, [x2, x0]
	add	x0, x0, 1
	b	.L1325
.L1337:
	ldr	w0, [x29, 140]
	cmp	w0, 6
	beq	.L1349
	cmp	w0, 7
	mov	x1, 10
	mov	x0, 8
	csel	x0, x0, x1, ne
.L1339:
	ldr	x10, [x29, 104]
	mov	w3, 0
.L1340:
	mov	x1, 0
.L1341:
	ldrb	w16, [x2, x1]
	ldr	w4, [x29, 136]
	strb	w16, [x10, x1]
	add	x1, x1, 1
	cmp	w4, w1, uxtb
	bhi	.L1341
	ldr	x1, [x29, 96]
	add	w3, w3, 1
	add	x10, x10, x0
	add	x2, x2, x1
	ldr	w1, [x29, 132]
	cmp	w1, w3
	bgt	.L1340
	mov	w23, 255
	str	w23, [x27, 2056]
	bl	nandc_wait_flash_ready
	cmp	w20, 1
	bhi	.L1343
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
.L1385:
	str	w0, [x27, 2056]
	bl	nandc_wait_flash_ready
	ldr	w0, [x29, 128]
	add	w11, w0, 1
	and	w0, w11, 255
	str	w0, [x29, 128]
	b	.L1308
.L1349:
	mov	x0, 4
	b	.L1339
.L1343:
	mov	w0, 56
	b	.L1385
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
	cmp	w1, 6
	bhi	.L1386
	b	hynix_get_read_retry_default
.L1386:
	ret
	.size	flash_get_read_retry_tbl, .-flash_get_read_retry_tbl
	.section	.text.nandc_xfer_done,"ax",@progbits
	.align	2
	.global	nandc_xfer_done
	.type	nandc_xfer_done, %function
nandc_xfer_done:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR144
	adrp	x1, .LANCHOR22
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR21
	ldrb	w1, [x1, #:lo12:.LANCHOR22]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w1, 9
	strb	wzr, [x0, #:lo12:.LANCHOR144]
	bne	.L1389
	ldr	x20, [x19, #:lo12:.LANCHOR21]
	mov	x24, x0
	mov	w21, 0
	ldr	w0, [x20, 16]
	str	w0, [x29, 64]
	ldr	w0, [x20, 48]
	tbnz	x0, 1, .L1390
	adrp	x22, .LC86
	adrp	x23, .LC85
	add	x22, x22, :lo12:.LC86
	add	x23, x23, :lo12:.LC85
.L1391:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1394
	ldr	x0, [x19, #:lo12:.LANCHOR21]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 16]
	str	w0, [x29, 64]
	bne	.L1391
	ldr	w2, [x29, 64]
	mov	w1, w21
	ldr	w3, [x20, 64]
	mov	x0, x22
	ubfx	x3, x3, 16, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR21]
	mov	w3, 64
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1391
.L1390:
	adrp	x22, .LC84
	adrp	x23, .LC85
	add	x22, x22, :lo12:.LC84
	add	x23, x23, :lo12:.LC85
.L1392:
	ldr	w1, [x20, 64]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 6
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L1394
	ldr	x0, [x19, #:lo12:.LANCHOR21]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1393
	ldr	w0, [x29, 72]
	tbz	x0, 17, .L1393
	ldr	w1, [x29, 72]
	adrp	x0, .LC83
	add	x0, x0, :lo12:.LC83
	ubfx	x1, x1, 17, 1
.L1426:
	bl	printf
	b	.L1394
.L1393:
	ldr	w0, [x29, 64]
	add	w21, w21, 1
	ubfx	x0, x0, 22, 6
	cmp	w21, w0, lsl 12
	bne	.L1392
	ldr	w2, [x20, 64]
	mov	w1, w21
	ldr	w3, [x29, 64]
	mov	x0, x22
	ubfx	x2, x2, 16, 5
	ubfx	x3, x3, 22, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR21]
	mov	x0, x23
	mov	w3, 64
	mov	w2, 4
	bl	rknand_print_hex
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1392
	mov	w0, 1
	strb	w0, [x24, #:lo12:.LANCHOR144]
.L1394:
	adrp	x0, .LANCHOR43+32
	ldp	x19, x20, [sp, 16]
	str	wzr, [x0, #:lo12:.LANCHOR43+32]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1389:
	ldr	x20, [x19, #:lo12:.LANCHOR21]
	mov	w21, 0
	ldr	w0, [x20, 8]
	str	w0, [x29, 64]
	ldr	w0, [x20, 16]
	tbnz	x0, 1, .L1400
	adrp	x22, .LC86
	adrp	x23, .LC85
	add	x22, x22, :lo12:.LC86
	add	x23, x23, :lo12:.LC85
.L1401:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1394
	ldr	x0, [x19, #:lo12:.LANCHOR21]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 8]
	str	w0, [x29, 64]
	bne	.L1401
	ldr	w2, [x29, 64]
	mov	w1, w21
	ldr	w3, [x20, 28]
	mov	x0, x22
	ubfx	x3, x3, 16, 5
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR21]
	mov	w3, 64
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1401
.L1400:
	adrp	x22, .LC84
	adrp	x23, .LC85
	add	x22, x22, :lo12:.LC84
	add	x23, x23, :lo12:.LC85
.L1402:
	ldr	w1, [x20, 28]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 5
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L1394
	ldr	x0, [x19, #:lo12:.LANCHOR21]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1403
	ldr	w0, [x29, 72]
	tbz	x0, 17, .L1403
	adrp	x0, .LC87
	ldr	w1, [x29, 72]
	add	x0, x0, :lo12:.LC87
	b	.L1426
.L1403:
	add	w21, w21, 1
	tst	x21, 16777215
	bne	.L1402
	ldr	w2, [x20, 28]
	mov	w1, w21
	ldr	w3, [x29, 64]
	mov	x0, x22
	ubfx	x2, x2, 16, 5
	ubfx	x3, x3, 22, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR21]
	mov	w3, 64
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1402
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
	cbnz	w22, .L1446
	adrp	x0, .LANCHOR22
	ldrb	w0, [x0, #:lo12:.LANCHOR22]
	cmp	w0, 9
	bne	.L1429
	adrp	x22, .LANCHOR21
	lsr	w19, w19, 2
	mov	w3, 1
	mov	w2, 0
	ldr	x5, [x22, #:lo12:.LANCHOR21]
	mov	w0, 0
.L1430:
	cmp	w2, w19
	bcc	.L1434
	ldr	w19, [x5]
	cmp	w3, 0
	mov	w1, 512
	csel	w0, w0, w1, eq
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1436
	mov	w1, w19
	adrp	x0, .LC88
	add	x0, x0, :lo12:.LC88
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR21]
	orr	w19, w19, 131072
	str	w19, [x0]
	mov	w0, -1
.L1436:
	tbz	x19, 13, .L1437
	adrp	x1, .LANCHOR144
	ldrb	w1, [x1, #:lo12:.LANCHOR144]
	cbz	w1, .L1437
	mov	w1, w19
	adrp	x0, .LC89
	add	x0, x0, :lo12:.LC89
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR21]
	mov	w1, 1
	str	w1, [x0, 16]
.L1465:
	mov	w0, -1
.L1428:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1434:
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
	tbnz	x1, 2, .L1448
	ldr	w1, [x29, 56]
	tbnz	x1, 18, .L1448
	ldr	w4, [x29, 56]
	ldr	w1, [x29, 56]
	ubfx	x4, x4, 3, 7
	ubfx	x1, x1, 19, 7
	cmp	w4, w1
	ldr	w1, [x29, 56]
	ble	.L1432
	ubfx	x1, x1, 3, 7
.L1433:
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1431:
	add	w2, w2, 1
	b	.L1430
.L1432:
	ubfx	x1, x1, 19, 7
	b	.L1433
.L1448:
	mov	w0, -1
	b	.L1431
.L1429:
	adrp	x0, .LANCHOR40
	lsr	w4, w19, 1
	mov	w3, 64
	mov	w1, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR40]
	mov	w2, 0
	adrp	x6, .LANCHOR43
	cmp	w0, 25
	mov	w0, 128
	csel	w3, w3, w0, cc
	mov	w0, 0
.L1439:
	add	w5, w3, w0
	cmp	w2, w4
	bcc	.L1440
	adrp	x22, .LANCHOR21
	lsr	w19, w19, 2
	mov	w3, 0
	mov	w0, 0
	ldr	x4, [x22, #:lo12:.LANCHOR21]
.L1441:
	cmp	w3, w19
	bcc	.L1445
	str	wzr, [x4, 16]
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	ldr	w19, [x4]
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1437
	mov	w1, w19
	adrp	x0, .LC90
	add	x0, x0, :lo12:.LC90
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR21]
	orr	w19, w19, 131072
	str	w19, [x0]
	b	.L1465
.L1440:
	ldr	x7, [x6, #:lo12:.LANCHOR43]
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
	b	.L1439
.L1445:
	uxtw	x1, w3
	add	x1, x1, 8
	ldr	w1, [x4, x1, lsl 2]
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	tbnz	x1, 2, .L1451
	ldr	w1, [x29, 56]
	tbnz	x1, 15, .L1451
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
	bls	.L1443
	ubfx	x2, x1, 3, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 27, 1
.L1464:
	orr	w1, w2, w1, lsl 5
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1442:
	add	w3, w3, 1
	b	.L1441
.L1443:
	ubfx	x2, x1, 16, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 29, 1
	b	.L1464
.L1451:
	mov	w0, -1
	b	.L1442
.L1437:
	cmn	w0, #1
	beq	.L1428
	ldr	w1, [x21]
	cmn	w1, #1
	bne	.L1428
	ldr	w1, [x21, 4]
	cmn	w1, #1
	bne	.L1428
	ldr	w1, [x20]
	cmn	w1, #1
	mov	w1, 512
	csel	w0, w0, w1, ne
	b	.L1428
.L1446:
	mov	w0, 0
	b	.L1428
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
	adrp	x0, .LANCHOR21
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	mov	w22, w1
	ldr	x19, [x0, #:lo12:.LANCHOR21]
	adrp	x0, .LANCHOR7
	stp	x25, x26, [sp, 64]
	mov	w24, w4
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	mov	x25, x2
	mov	x26, x3
	and	w20, w1, 2097151
	ubfx	x23, x22, 24, 2
	tbz	x0, 4, .L1467
	mov	w3, w1
	adrp	x0, .LC91
	mov	w2, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC91
	bl	printf
.L1467:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	nandc_cs
	adrp	x6, .LANCHOR9
	cbnz	w23, .L1468
	mov	w0, w21
	bl	zftl_flash_enter_slc_mode
.L1469:
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
	ldr	x0, [x6, #:lo12:.LANCHOR9]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1471
	cbz	w23, .L1471
	add	w20, w20, w20, lsl 1
	sub	w0, w20, #1
	add	w0, w0, w23
.L1480:
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
	mov	w0, 0
	bl	nandc_de_cs
	mov	w0, w2
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1468:
	ldr	x0, [x6, #:lo12:.LANCHOR9]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1470
	sxtw	x0, w21
	add	x0, x0, 8
	add	x0, x19, x0, lsl 8
	str	w23, [x0, 8]
	b	.L1469
.L1470:
	mov	w0, w21
	bl	zftl_flash_exit_slc_mode
	b	.L1469
.L1471:
	mov	w0, w20
	b	.L1480
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
	adrp	x0, .LANCHOR40
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	mov	w22, w1
	stp	x25, x26, [sp, 64]
	mov	x25, x2
	stp	x27, x28, [sp, 80]
	mov	x26, x3
	ldrb	w20, [x0, #:lo12:.LANCHOR40]
	and	x19, x24, 255
	str	w4, [x29, 116]
	bl	nandc_wait_flash_ready
	adrp	x0, .LANCHOR21
	mov	w21, 0
	add	w20, w20, w20, lsl 1
	mov	w28, -1
	ldr	x0, [x0, #:lo12:.LANCHOR21]
	asr	w20, w20, 2
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR146
	add	x0, x0, :lo12:.LANCHOR146
	str	x0, [x29, 104]
	ldr	x0, [x29, 120]
	add	x23, x0, x19, lsl 8
	adrp	x0, .LANCHOR7
	add	x0, x0, :lo12:.LANCHOR7
	str	x0, [x29, 96]
.L1482:
	ldr	x0, [x29, 104]
	ldrb	w0, [x0]
	cmp	w21, w0
	bcc	.L1487
.L1486:
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
	bcc	.L1488
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L1488:
	cmp	w28, 256
	ccmn	w28, #1, 4, ne
	bne	.L1481
	adrp	x0, .LC93
	mov	w4, w28
	mov	w3, w21
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC93
	bl	printf
.L1481:
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1487:
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
	tbz	x0, 12, .L1483
	str	w7, [x29, 112]
	mov	w4, w28
	mov	w3, w21
	mov	w2, w22
	mov	w1, w21
	adrp	x0, .LC92
	add	x0, x0, :lo12:.LC92
	bl	printf
	ldr	w7, [x29, 112]
.L1483:
	cmn	w7, #1
	beq	.L1484
	adrp	x0, .LANCHOR143
	cmn	w28, #1
	csel	w28, w28, w7, ne
	cmp	w7, w20
	ldr	x25, [x0, #:lo12:.LANCHOR143]
	adrp	x0, .LANCHOR145
	ldr	x26, [x0, #:lo12:.LANCHOR145]
	bcc	.L1490
.L1484:
	mov	w21, w27
	b	.L1482
.L1490:
	mov	w28, w7
	b	.L1486
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
	adrp	x0, .LANCHOR21
	adrp	x22, .LANCHOR17
	mov	w1, 46
	mov	w2, 56
	ldr	x25, [x0, #:lo12:.LANCHOR21]
	and	x0, x24, 255
	add	x21, x0, 8
	str	x0, [x29, 128]
	ldrb	w0, [x22, #:lo12:.LANCHOR17]
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
	add	x0, x22, :lo12:.LANCHOR17
	cbnz	w4, .L1505
	str	x0, [x29, 120]
	sxtw	x0, w24
	add	x0, x0, 8
	add	x0, x25, x0, lsl 8
	str	x0, [x29, 112]
.L1512:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, 36
	bne	.L1506
	mov	w1, w20
	mov	x0, x21
	mov	w2, 0
	bl	toshiba_tlc_set_rr_para
	ldr	x1, [x29, 112]
	mov	w0, 93
	str	w0, [x1, 8]
.L1507:
	mov	w4, w28
	mov	x3, x27
	mov	x2, x26
	mov	w1, w23
	mov	w0, w24
	bl	flash_read_page
	mov	w4, w0
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 4, .L1508
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC94
	add	x0, x0, :lo12:.LC94
	bl	printf
	ldr	w4, [x29, 108]
.L1508:
	cmn	w4, #1
	beq	.L1509
	adrp	x0, .LANCHOR143
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x26, [x0, #:lo12:.LANCHOR143]
	adrp	x0, .LANCHOR145
	ldr	x27, [x0, #:lo12:.LANCHOR145]
	adrp	x0, .LANCHOR40
	ldrb	w0, [x0, #:lo12:.LANCHOR40]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1527
.L1509:
	ldr	w0, [x29, 136]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1512
.L1511:
	ldrb	w0, [x22, #:lo12:.LANCHOR17]
	cmp	w0, 36
	bne	.L1513
	mov	w2, 0
.L1550:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_tlc_set_rr_para
	b	.L1514
.L1506:
	mov	w1, w20
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
	b	.L1507
.L1527:
	mov	w19, w4
	b	.L1511
.L1513:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
.L1514:
	ldrb	w0, [x22, #:lo12:.LANCHOR17]
	cmp	w0, 36
	bne	.L1523
	ldr	x0, [x29, 128]
	add	x25, x25, x0, lsl 8
	mov	w0, 85
	str	w0, [x25, 2056]
	mov	w0, 255
	str	wzr, [x25, 2052]
	str	wzr, [x25, 2048]
	str	w0, [x25, 2056]
.L1523:
	adrp	x0, .LANCHOR40
	ldrb	w0, [x0, #:lo12:.LANCHOR40]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1524
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1524:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1525
	adrp	x0, .LC96
	mov	w4, w19
	mov	w3, w20
	mov	w2, w23
	mov	w1, w20
	add	x0, x0, :lo12:.LC96
	bl	printf
.L1525:
	bl	nandc_wait_flash_ready
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1505:
	str	x0, [x29, 112]
	sxtw	x0, w24
	add	x0, x0, 8
	add	x0, x25, x0, lsl 8
	str	x0, [x29, 136]
.L1521:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cmp	w0, 36
	bne	.L1515
	mov	x0, x21
	mov	w2, 1
	mov	w1, w20
	bl	toshiba_tlc_set_rr_para
	mov	w0, 93
.L1549:
	ldr	x1, [x29, 136]
	mov	w4, w28
	mov	x3, x27
	mov	x2, x26
	str	w0, [x1, 8]
	mov	w1, w23
	mov	w0, w24
	bl	flash_read_page
	mov	w4, w0
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 4, .L1517
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC95
	add	x0, x0, :lo12:.LC95
	bl	printf
	ldr	w4, [x29, 108]
.L1517:
	cmn	w4, #1
	beq	.L1518
	adrp	x0, .LANCHOR143
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x26, [x0, #:lo12:.LANCHOR143]
	adrp	x0, .LANCHOR145
	ldr	x27, [x0, #:lo12:.LANCHOR145]
	adrp	x0, .LANCHOR40
	ldrb	w0, [x0, #:lo12:.LANCHOR40]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1528
.L1518:
	ldr	w0, [x29, 120]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1521
.L1520:
	ldrb	w0, [x22, #:lo12:.LANCHOR17]
	cmp	w0, 36
	bne	.L1522
	mov	w2, 1
	b	.L1550
.L1515:
	mov	x0, x21
	mov	w1, w20
	bl	toshiba_3d_set_tlc_rr_para
	mov	w0, 38
	b	.L1549
.L1528:
	mov	w19, w4
	b	.L1520
.L1522:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_tlc_rr_para
	b	.L1514
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
	adrp	x0, .LANCHOR21
	adrp	x1, .LANCHOR17
	str	x1, [x29, 120]
	ldr	x22, [x0, #:lo12:.LANCHOR21]
	and	x0, x19, 255
	add	x21, x0, 8
	str	x0, [x29, 104]
	ldrb	w0, [x1, #:lo12:.LANCHOR17]
	add	x21, x22, x21, lsl 8
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	bls	.L1569
	adrp	x0, .LANCHOR14
	ldrb	w0, [x0, #:lo12:.LANCHOR14]
	cbz	w0, .L1570
	mov	w23, 1
	mov	w0, 1
	bl	nandc_set_if_mode
.L1553:
	and	x0, x19, 255
	mov	w1, 92
	add	x0, x22, x0, lsl 8
	str	w1, [x0, 2056]
	mov	w1, 197
	str	w1, [x0, 2056]
.L1552:
	sxtw	x0, w19
	mov	w20, 1
	add	x0, x0, 8
	mov	w24, -1
	add	x0, x22, x0, lsl 8
	str	x0, [x29, 96]
.L1554:
	adrp	x0, .LANCHOR146
	ldrb	w0, [x0, #:lo12:.LANCHOR146]
	add	w0, w0, 1
	cmp	w20, w0
	bcc	.L1563
	mov	w28, w24
.L1562:
	ldr	x0, [x29, 120]
	mov	w1, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR17]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1564
	bl	sandisk_set_rr_para
.L1565:
	sxtw	x19, w19
	mov	w0, 255
	add	x19, x19, 8
	add	x22, x22, x19, lsl 8
	str	w0, [x22, 8]
	adrp	x0, .LANCHOR40
	ldrb	w0, [x0, #:lo12:.LANCHOR40]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L1566
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L1566:
	cmp	w28, 256
	ccmn	w28, #1, 4, ne
	bne	.L1567
	adrp	x0, .LC96
	mov	w4, w28
	mov	w3, w20
	mov	w2, w25
	mov	w1, w20
	add	x0, x0, :lo12:.LC96
	bl	printf
.L1567:
	bl	nandc_wait_flash_ready
	cbz	w23, .L1551
	mov	w0, 4
	bl	nandc_set_if_mode
.L1551:
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1570:
	mov	w23, 0
	b	.L1553
.L1569:
	mov	w23, 0
	b	.L1552
.L1563:
	ldr	x0, [x29, 120]
	mov	w1, w20
	ldrb	w0, [x0, #:lo12:.LANCHOR17]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1555
	bl	sandisk_set_rr_para
.L1556:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0, #:lo12:.LANCHOR17]
	cmp	w0, 34
	bne	.L1557
	adrp	x0, .LANCHOR146
	ldrb	w0, [x0, #:lo12:.LANCHOR146]
	sub	w0, w0, #3
	cmp	w20, w0
	bne	.L1557
	ldr	x1, [x29, 96]
	mov	w0, 179
	str	w0, [x1, 8]
.L1557:
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
	beq	.L1560
	cmn	w24, #1
	csel	w24, w24, w0, ne
	adrp	x0, .LANCHOR143
	ldr	x26, [x0, #:lo12:.LANCHOR143]
	adrp	x0, .LANCHOR145
	ldr	x27, [x0, #:lo12:.LANCHOR145]
	adrp	x0, .LANCHOR40
	ldrb	w0, [x0, #:lo12:.LANCHOR40]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L1562
.L1560:
	add	w20, w20, 1
	b	.L1554
.L1555:
	bl	toshiba_set_rr_para
	b	.L1556
.L1564:
	bl	toshiba_set_rr_para
	b	.L1565
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
	adrp	x0, .LANCHOR20
	stp	x27, x28, [sp, 80]
	stp	x21, x22, [sp, 32]
	mov	w27, w4
	ldr	x28, [x0, #:lo12:.LANCHOR20]
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
	adrp	x6, .LANCHOR40
	add	x6, x6, :lo12:.LANCHOR40
	mov	w5, 0
	adrp	x7, .LANCHOR143
	adrp	x8, .LANCHOR145
.L1584:
	cmp	w5, w24
	bcc	.L1589
.L1588:
	adrp	x0, .LANCHOR40
	add	x23, x28, x23
	ldrb	w0, [x0, #:lo12:.LANCHOR40]
	strb	w20, [x23, 8]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1590
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1590:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1583
	adrp	x0, .LC97
	mov	w4, w19
	mov	w3, w5
	mov	w2, w22
	mov	w1, w5
	add	x0, x0, :lo12:.LC97
	bl	printf
.L1583:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1589:
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
	beq	.L1586
	ldrb	w1, [x6]
	cmn	w19, #1
	csel	w19, w19, w0, ne
	ldr	x25, [x7, #:lo12:.LANCHOR143]
	ldr	x26, [x8, #:lo12:.LANCHOR145]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L1592
.L1586:
	add	w5, w5, 1
	b	.L1584
.L1592:
	mov	w19, w0
	b	.L1588
	.size	hynix_read_retrial, .-hynix_read_retrial
	.section	.text.flash_ddr_tunning_read,"ax",@progbits
	.align	2
	.global	flash_ddr_tunning_read
	.type	flash_ddr_tunning_read, %function
flash_ddr_tunning_read:
	stp	x29, x30, [sp, -144]!
	and	w0, w0, 255
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	stp	x21, x22, [sp, 32]
	adrp	x21, .LC98
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR40
	stp	x25, x26, [sp, 64]
	add	x21, x21, :lo12:.LC98
	stp	x27, x28, [sp, 80]
	mov	x26, x3
	str	w4, [x29, 120]
	add	x22, x22, :lo12:.LANCHOR40
	str	x2, [x29, 128]
	mov	w28, 0
	str	w0, [x29, 136]
	bl	nandc_get_ddr_para
	mov	w23, 0
	str	w0, [x29, 124]
	mov	w24, 0
	adrp	x0, .LANCHOR7
	mov	w27, 1024
	add	x0, x0, :lo12:.LANCHOR7
	mov	w25, 6
	mov	w19, -1
	str	wzr, [x29, 140]
	str	x0, [x29, 112]
.L1608:
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
	tbz	x0, 4, .L1603
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w20
	mov	w1, w25
	mov	x0, x21
	bl	printf
	ldr	w4, [x29, 108]
.L1603:
	add	w0, w27, 1
	cmp	w4, w0
	bhi	.L1604
	adrp	x0, .LANCHOR143
	ldr	x0, [x0, #:lo12:.LANCHOR143]
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR145
	ldr	x26, [x0, #:lo12:.LANCHOR145]
	ldrb	w0, [x22]
	cmp	w4, w0, lsr 2
	bcs	.L1613
	add	w24, w24, 1
	cmp	w24, 7
	bls	.L1613
	sub	w28, w25, w24
	mov	w27, w4
	mov	w19, 0
.L1606:
	ldr	w0, [x29, 140]
	cmp	w24, w23
	csel	w28, w28, w0, cs
.L1607:
	cbz	w28, .L1609
	adrp	x0, .LANCHOR40
	mov	w1, 3
	ldrb	w0, [x0, #:lo12:.LANCHOR40]
	udiv	w0, w0, w1
	cmp	w0, w27
	bls	.L1609
	mov	w1, w28
	adrp	x0, .LC99
	add	x0, x0, :lo12:.LC99
	bl	printf
	mov	w0, w28
.L1623:
	bl	nandc_set_ddr_para
	cbz	w19, .L1602
	ldr	w1, [x29, 136]
	adrp	x0, .LC100
	mov	w2, w20
	add	x0, x0, :lo12:.LC100
	mov	w27, w19
	bl	printf
.L1602:
	mov	w0, w27
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1604:
	cmp	w24, w23
	bls	.L1614
	sub	w0, w28, w24
	str	w0, [x29, 140]
	cmp	w24, 7
	bhi	.L1607
	mov	w23, w24
.L1614:
	mov	w24, 0
	b	.L1605
.L1613:
	mov	w28, w25
	mov	w27, w4
	mov	w19, 0
.L1605:
	add	w25, w25, 2
	cmp	w25, 50
	bne	.L1608
	b	.L1606
.L1609:
	ldrb	w0, [x29, 124]
	b	.L1623
	.size	flash_ddr_tunning_read, .-flash_ddr_tunning_read
	.section	.text.flash_read_page_en,"ax",@progbits
	.align	2
	.global	flash_read_page_en
	.type	flash_read_page_en, %function
flash_read_page_en:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	adrp	x0, .LANCHOR12
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	mov	w19, w1
	ldrb	w0, [x0, #:lo12:.LANCHOR12]
	mov	x22, x2
	stp	x25, x26, [sp, 64]
	mov	x23, x3
	str	x27, [sp, 80]
	mov	w24, w4
	ubfx	x21, x19, 24, 2
	cmp	w0, w20
	bhi	.L1625
	adrp	x1, .LANCHOR147
	adrp	x0, .LC0
	mov	w2, 378
	add	x1, x1, :lo12:.LANCHOR147
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1625:
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	ldrb	w20, [x0, w20, sxtw]
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 4, .L1626
	adrp	x0, .LC101
	mov	w2, w19
	mov	w1, w20
	add	x0, x0, :lo12:.LC101
	bl	printf
.L1626:
	cbnz	w21, .L1627
	adrp	x0, .LANCHOR11
	adrp	x1, .LANCHOR25
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	cbz	w0, .L1628
	ldrb	w0, [x1, #:lo12:.LANCHOR25]
	cbz	w0, .L1627
.L1628:
	adrp	x0, .LANCHOR26
	ldrb	w1, [x1, #:lo12:.LANCHOR25]
	ldrh	w2, [x0, #:lo12:.LANCHOR26]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L1629
	add	w19, w0, w19, lsl 1
.L1627:
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w20
	bl	flash_read_page
	mov	w21, w0
	cmn	w0, #1
	bne	.L1624
	adrp	x25, .LANCHOR42
	mov	x26, x25
	ldrb	w27, [x25, #:lo12:.LANCHOR42]
	cbnz	w27, .L1631
.L1634:
	adrp	x0, .LANCHOR148
	ldr	x5, [x0, #:lo12:.LANCHOR148]
	cbnz	x5, .L1632
.L1633:
	ldrb	w4, [x26, #:lo12:.LANCHOR42]
	mov	w3, -1
	mov	w2, w19
	mov	w1, 0
	adrp	x0, .LC102
	add	x0, x0, :lo12:.LC102
	bl	printf
	adrp	x0, .LANCHOR14
	ldrb	w0, [x0, #:lo12:.LANCHOR14]
	cbz	w0, .L1624
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
	b	flash_ddr_tunning_read
.L1629:
	adrp	x1, .LANCHOR27
	add	x1, x1, :lo12:.LANCHOR27
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
	b	.L1627
.L1631:
	strb	wzr, [x25, #:lo12:.LANCHOR42]
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w20
	bl	flash_read_page
	strb	w27, [x25, #:lo12:.LANCHOR42]
	cmn	w0, #1
	beq	.L1634
.L1652:
	mov	w21, w0
.L1624:
	mov	w0, w21
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1632:
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w20
	blr	x5
	cmn	w0, #1
	beq	.L1633
	b	.L1652
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
	adrp	x0, .LANCHOR128
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	mov	x24, x2
	ldrh	w19, [x0, #:lo12:.LANCHOR128]
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
	bne	.L1654
	mov	w27, 0
	mov	w28, 2
.L1655:
	cmp	w27, w19
	ble	.L1658
.L1654:
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L1659
	ldr	w3, [x22]
	adrp	x0, .LC103
	mov	w2, w19
	mov	w1, w21
	add	x0, x0, :lo12:.LC103
	bl	printf
.L1659:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1658:
	add	w20, w27, w19
	mov	w4, w25
	mov	x3, x22
	mov	x2, x24
	mov	w0, w23
	sdiv	w20, w20, w28
	add	w1, w26, w20, sxth
	bl	flash_read_page_en
	cmp	w0, 512
	bne	.L1656
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L1655
.L1656:
	add	w20, w20, 1
	sxth	w27, w20
	b	.L1655
	.size	flash_get_last_written_page, .-flash_get_last_written_page
	.section	.text.flash_get_last_written_page_ext,"ax",@progbits
	.align	2
	.global	flash_get_last_written_page_ext
	.type	flash_get_last_written_page_ext, %function
flash_get_last_written_page_ext:
	adrp	x4, .LANCHOR96
	mov	w6, 21
	and	w0, w0, 65535
	mov	w5, 1
	ldrh	w4, [x4, #:lo12:.LANCHOR96]
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
	adrp	x0, .LANCHOR7
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR20
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	tbz	x0, 12, .L1666
	ldr	x4, [x20, #:lo12:.LANCHOR20]
	adrp	x2, .LANCHOR149
	adrp	x0, .LC104
	mov	w3, 2048
	add	x2, x2, :lo12:.LANCHOR149
	mov	w1, 49
	add	x0, x0, :lo12:.LC104
	bl	printf
.L1666:
	adrp	x21, .LANCHOR150
	adrp	x23, .LANCHOR26
	mov	w24, 21321
	add	x26, x23, :lo12:.LANCHOR26
	mov	x22, x21
	mov	w19, 4
	movk	w24, 0x5359, lsl 16
.L1669:
	ldrh	w1, [x26]
	mov	w4, 4
	ldr	x3, [x21, #:lo12:.LANCHOR150]
	mov	w0, 0
	ldr	x2, [x20, #:lo12:.LANCHOR20]
	add	x27, x21, :lo12:.LANCHOR150
	add	x25, x20, :lo12:.LANCHOR20
	mul	w1, w1, w19
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1667
	ldr	x2, [x20, #:lo12:.LANCHOR20]
	ldr	w0, [x2]
	cmp	w0, w24
	beq	.L1668
.L1667:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L1669
.L1693:
	mov	w0, -1
.L1665:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1677:
	ldr	x0, [x25]
	ldr	w1, [x0]
	cmp	w1, w24
	bne	.L1678
	ldr	w19, [x0, 4]
.L1671:
	add	x24, x21, :lo12:.LANCHOR151
	ldrh	w0, [x23, #:lo12:.LANCHOR26]
	ldr	x3, [x22, #:lo12:.LANCHOR150]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR20]
	ldrb	w1, [x24, 1]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1672
	ldr	x0, [x20, #:lo12:.LANCHOR20]
	mov	w1, 21321
	movk	w1, 0x5359, lsl 16
	ldr	w2, [x0]
	cmp	w2, w1
	bne	.L1672
	ldr	w1, [x0, 4]
	cmp	w19, w1
	bcs	.L1672
	ldrb	w1, [x0, 37]
	ldrb	w0, [x0, 36]
	strb	w1, [x21, #:lo12:.LANCHOR151]
	strb	w0, [x24, 1]
.L1672:
	ldrb	w1, [x21, #:lo12:.LANCHOR151]
	add	x24, x21, :lo12:.LANCHOR151
	ldr	x3, [x22, #:lo12:.LANCHOR150]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR20]
	mov	w0, 0
	bl	flash_get_last_written_page
	sxth	w19, w0
	add	w0, w0, 1
	ldrb	w21, [x21, #:lo12:.LANCHOR151]
	strh	w0, [x24, 2]
	ldrh	w0, [x23, #:lo12:.LANCHOR26]
	mov	w23, 21321
	movk	w23, 0x5359, lsl 16
	madd	w21, w21, w0, w19
.L1673:
	tbz	w19, #31, .L1675
	cmn	w19, #1
	bne	.L1676
	ldr	x0, [x20, #:lo12:.LANCHOR20]
	ldr	w1, [x0]
	adrp	x0, .LC105
	add	x0, x0, :lo12:.LC105
	bl	printf
	b	.L1693
.L1675:
	ldr	x3, [x22, #:lo12:.LANCHOR150]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR20]
	mov	w1, w21
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1674
	ldr	x0, [x20, #:lo12:.LANCHOR20]
	ldr	w0, [x0]
	cmp	w0, w23
	bne	.L1674
.L1676:
	mov	w0, 0
	b	.L1665
.L1674:
	sub	w19, w19, #1
	sub	w21, w21, #1
	sxth	w19, w19
	b	.L1673
.L1668:
	adrp	x21, .LANCHOR151
	add	x1, x21, :lo12:.LANCHOR151
	ldrb	w3, [x2, 37]
	mov	w4, 4
	ldrb	w0, [x2, 36]
	strb	w3, [x1, 1]
	ldrh	w1, [x26]
	ldr	x3, [x27]
	strb	w0, [x21, #:lo12:.LANCHOR151]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	bne	.L1677
.L1678:
	mov	w19, 0
	b	.L1671
	.size	flash_info_blk_init, .-flash_info_blk_init
	.section	.text.flash_ddr_para_scan,"ax",@progbits
	.align	2
	.global	flash_ddr_para_scan
	.type	flash_ddr_para_scan, %function
flash_ddr_para_scan:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR39
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	ldrb	w0, [x20, #:lo12:.LANCHOR39]
	adrp	x19, .LANCHOR14
	stp	x23, x24, [sp, 48]
	mov	w21, 1
	mov	w23, w1
	str	x25, [sp, 64]
	strb	w21, [x19, #:lo12:.LANCHOR14]
	adrp	x24, .LANCHOR153
	bl	flash_set_interface_mode
	adrp	x25, .LANCHOR152
	ldrb	w0, [x20, #:lo12:.LANCHOR39]
	bl	nandc_set_if_mode
	ldr	x3, [x25, #:lo12:.LANCHOR152]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR153]
	mov	w1, w23
	mov	w0, w22
	bl	flash_ddr_tunning_read
	ldr	x3, [x25, #:lo12:.LANCHOR152]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR153]
	mov	w1, w23
	mov	w0, w22
	bl	flash_read_page
	cmn	w0, #1
	mov	x0, x19
	bne	.L1695
	ldrb	w1, [x20, #:lo12:.LANCHOR39]
	tbz	x1, 0, .L1695
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, w21
	bl	nandc_set_if_mode
	strb	wzr, [x19, #:lo12:.LANCHOR14]
.L1696:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1695:
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR14]
	b	.L1696
	.size	flash_ddr_para_scan, .-flash_ddr_para_scan
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
	adrp	x0, .LANCHOR12
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	ubfx	x20, x23, 21, 3
	ldrb	w0, [x0, #:lo12:.LANCHOR12]
	mov	x24, x1
	stp	x27, x28, [sp, 80]
	mov	x25, x2
	ubfx	x21, x23, 24, 2
	cmp	w0, w20
	bhi	.L1702
	adrp	x1, .LANCHOR154
	adrp	x0, .LC0
	mov	w2, 789
	add	x1, x1, :lo12:.LANCHOR154
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1702:
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	ldrb	w22, [x0, w20, sxtw]
	adrp	x0, .LANCHOR21
	ldr	x4, [x0, #:lo12:.LANCHOR21]
	mov	w0, w22
	bl	nandc_cs
	cbnz	w21, .L1703
	adrp	x0, .LANCHOR11
	adrp	x1, .LANCHOR25
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	cbz	w0, .L1704
	ldrb	w0, [x1, #:lo12:.LANCHOR25]
	cbz	w0, .L1703
.L1704:
	adrp	x0, .LANCHOR26
	ldrb	w1, [x1, #:lo12:.LANCHOR25]
	ldrh	w2, [x0, #:lo12:.LANCHOR26]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L1705
	add	w19, w0, w19, lsl 1
.L1703:
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
	adrp	x0, .LANCHOR9
	ldr	x0, [x0, #:lo12:.LANCHOR9]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1706
	cbz	w21, .L1706
	sub	w0, w21, #1
	add	w1, w19, w19, lsl 1
	add	w0, w0, w1
.L1739:
	adrp	x20, .LANCHOR32
	add	x28, x20, :lo12:.LANCHOR32
	bl	nandc_set_seed
	mov	x4, x25
	mov	x3, x24
	ldrb	w2, [x28, 9]
	mov	w1, 0
	mov	w0, w22
	bl	nandc_xfer
	cmn	w0, #1
	bne	.L1708
	adrp	x26, .LANCHOR42
	ldrb	w27, [x26, #:lo12:.LANCHOR42]
	cbz	w27, .L1709
	ldrb	w4, [x28, 9]
	mov	x3, x25
	strb	wzr, [x26, #:lo12:.LANCHOR42]
	mov	x2, x24
	orr	w1, w19, w21, lsl 24
	mov	w0, w22
	bl	flash_read_page
	strb	w27, [x26, #:lo12:.LANCHOR42]
	cbnz	w21, .L1710
.L1715:
	adrp	x1, .LANCHOR11
	ldrb	w1, [x1, #:lo12:.LANCHOR11]
	cbz	w1, .L1710
	adrp	x1, .LANCHOR40
	ldrb	w1, [x1, #:lo12:.LANCHOR40]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	blt	.L1710
	add	x20, x20, :lo12:.LANCHOR32
	ldrb	w1, [x20, 19]
	sub	w1, w1, #4
	and	w1, w1, 255
	cmp	w1, 3
	mov	w1, 256
	csel	w0, w0, w1, hi
.L1701:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1705:
	adrp	x1, .LANCHOR27
	add	x1, x1, :lo12:.LANCHOR27
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
	b	.L1703
.L1706:
	mov	w0, w19
	b	.L1739
.L1710:
	cmn	w0, #1
	bne	.L1701
.L1716:
	adrp	x0, .LANCHOR148
	ldr	x5, [x0, #:lo12:.LANCHOR148]
	cbnz	x5, .L1712
.L1714:
	adrp	x0, .LANCHOR42
	mov	w3, -1
	mov	w2, w23
	mov	w1, 0
	ldrb	w4, [x0, #:lo12:.LANCHOR42]
	adrp	x0, .LC106
	add	x0, x0, :lo12:.LC106
	bl	printf
	adrp	x0, .LANCHOR14
	ldrb	w0, [x0, #:lo12:.LANCHOR14]
	cbnz	w0, .L1713
	mov	w0, -1
	b	.L1701
.L1712:
	add	x0, x20, :lo12:.LANCHOR32
	mov	x3, x25
	mov	x2, x24
	orr	w1, w19, w21, lsl 24
	ldrb	w4, [x0, 9]
	mov	w0, w22
	blr	x5
	cmn	w0, #1
	beq	.L1714
	b	.L1701
.L1713:
	add	x20, x20, :lo12:.LANCHOR32
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
	b	flash_ddr_tunning_read
.L1709:
	cbz	w21, .L1715
	b	.L1716
.L1708:
	cbnz	w21, .L1701
	b	.L1715
	.size	flash_complete_page_read, .-flash_complete_page_read
	.section	.text.queue_wait_first_req_completed,"ax",@progbits
	.align	2
	.type	queue_wait_first_req_completed, %function
queue_wait_first_req_completed:
	stp	x29, x30, [sp, -64]!
	adrp	x0, .LANCHOR120
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldrb	w0, [x0, #:lo12:.LANCHOR120]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w0, 255
	bne	.L1741
.L1759:
	mov	w21, 0
	b	.L1740
.L1741:
	adrp	x19, .LANCHOR46
	sxtw	x22, w0
	add	x1, x19, :lo12:.LANCHOR46
	add	x1, x1, x22, lsl 6
	ldrb	w2, [x1, 58]
	ldr	w21, [x1, 40]
	sub	w3, w2, #1
	cmp	w3, 9
	bhi	.L1759
	adrp	x1, .L1744
	add	x1, x1, :lo12:.L1744
	ldrb	w1, [x1,w3,uxtw]
	adr	x3, .Lrtx1744
	add	x1, x3, w1, sxtb #2
	br	x1
.Lrtx1744:
	.section	.rodata.queue_wait_first_req_completed,"a",@progbits
	.align	0
	.align	2
.L1744:
	.byte	(.L1743 - .Lrtx1744) / 4
	.byte	(.L1743 - .Lrtx1744) / 4
	.byte	(.L1745 - .Lrtx1744) / 4
	.byte	(.L1745 - .Lrtx1744) / 4
	.byte	(.L1745 - .Lrtx1744) / 4
	.byte	(.L1746 - .Lrtx1744) / 4
	.byte	(.L1747 - .Lrtx1744) / 4
	.byte	(.L1748 - .Lrtx1744) / 4
	.byte	(.L1745 - .Lrtx1744) / 4
	.byte	(.L1748 - .Lrtx1744) / 4
	.section	.text.queue_wait_first_req_completed
.L1743:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L1759
	add	x19, x19, :lo12:.LANCHOR46
	add	x19, x19, x22, lsl 6
	ldp	x1, x0, [x19, 8]
	ldr	x2, [x19, 24]
	cmp	x0, 0
	csel	x1, x0, x1, ne
	mov	w0, w21
	bl	flash_complete_page_read
	str	w0, [x19, 52]
	mov	w0, 12
	strb	w0, [x19, 58]
	ldrb	w0, [x19, 2]
	orr	w0, w0, 8
	strb	w0, [x19, 2]
	b	.L1759
.L1745:
	mov	w0, w21
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w21, w0
	tbz	x21, 6, .L1759
	add	x19, x19, :lo12:.LANCHOR46
	mov	w0, 5
	add	x19, x19, x22, lsl 6
	tst	w21, w0
	beq	.L1758
	ldrb	w1, [x19, 1]
	mov	w0, 11
	ldr	w3, [x19, 40]
	mov	w4, 11
	ldr	w2, [x19, 52]
	strb	w0, [x19, 58]
	adrp	x0, .LC107
	add	x0, x0, :lo12:.LC107
	bl	printf
.L1777:
	mov	w0, -1
	str	w0, [x19, 52]
	b	.L1740
.L1748:
	cmp	w2, 10
	add	x20, x19, :lo12:.LANCHOR46
	ubfiz	x0, x0, 6, 8
	mov	w1, 3
	mov	w2, 9
	add	x0, x20, x0
	csel	w2, w2, w1, eq
	ubfx	x3, x21, 21, 3
.L1753:
	ldrb	w1, [x0]
	cmp	w1, 255
	bne	.L1757
	mov	w21, -1
	b	.L1740
.L1757:
	sxtw	x23, w1
	ubfiz	x0, x1, 6, 8
	add	x1, x20, x23, lsl 6
	add	x0, x20, x0
	ldrb	w4, [x1, 58]
	cmp	w4, w2
	bne	.L1753
	ldr	w1, [x1, 40]
	ubfx	x1, x1, 21, 3
	cmp	w3, w1
	bne	.L1753
	mov	w0, w21
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w24, w0
	and	w21, w0, 64
	tbz	x24, 6, .L1755
	add	x20, x20, x22, lsl 6
	ands	w21, w0, 15
	beq	.L1756
	ldrb	w1, [x20, 1]
	mov	w4, 11
	ldr	w3, [x20, 40]
	adrp	x0, .LC107
	ldr	w2, [x20, 52]
	add	x0, x0, :lo12:.LC107
	mov	w21, w24
	bl	printf
	mov	w0, 11
	strb	w0, [x20, 58]
	mov	w0, -1
	str	w0, [x20, 52]
.L1755:
	add	x1, x19, :lo12:.LANCHOR46
	add	x22, x1, x22, lsl 6
	add	x1, x1, x23, lsl 6
	ldrb	w0, [x22, 58]
	strb	w0, [x1, 58]
	ldr	w0, [x22, 52]
	str	w0, [x1, 52]
.L1740:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1756:
	mov	w0, 12
	str	wzr, [x20, 52]
	strb	w0, [x20, 58]
	b	.L1755
.L1746:
	mov	w0, w21
	mov	w1, 32
	bl	flash_wait_device_ready
	mov	w21, w0
	tbz	x21, 5, .L1759
	add	x19, x19, :lo12:.LANCHOR46
	tst	x21, 15
	add	x19, x19, x22, lsl 6
	beq	.L1758
	mov	w0, 11
	strb	w0, [x19, 58]
	b	.L1777
.L1758:
	mov	w0, 12
	str	wzr, [x19, 52]
	strb	w0, [x19, 58]
	b	.L1759
.L1747:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L1759
	add	x19, x19, :lo12:.LANCHOR46
	add	x19, x19, x22, lsl 6
	str	w0, [x19, 52]
	mov	w0, 6
	strb	w0, [x19, 58]
	b	.L1759
	.size	queue_wait_first_req_completed, .-queue_wait_first_req_completed
	.section	.text.sblk_wait_write_queue_completed,"ax",@progbits
	.align	2
	.global	sblk_wait_write_queue_completed
	.type	sblk_wait_write_queue_completed, %function
sblk_wait_write_queue_completed:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR120
	add	x19, x19, :lo12:.LANCHOR120
.L1779:
	ldrb	w0, [x19]
	cmp	w0, 255
	bne	.L1780
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1780:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1779
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
	.section	.text.ftl_open_sblk_read_test,"ax",@progbits
	.align	2
	.global	ftl_open_sblk_read_test
	.type	ftl_open_sblk_read_test, %function
ftl_open_sblk_read_test:
	stp	x29, x30, [sp, -96]!
	and	w14, w0, 65535
	mov	w0, w14
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR80
	adrp	x24, .LANCHOR117
	add	x23, x23, :lo12:.LANCHOR80
	add	x24, x24, :lo12:.LANCHOR117
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	add	x1, x29, 80
	mov	w20, 0
	bl	ftl_get_blk_list_in_sblk
	strb	w0, [x29, 73]
	strh	w14, [x29, 64]
.L1787:
	ldrh	w0, [x23]
	cmp	w0, w20
	bls	.L1786
	adrp	x22, .LANCHOR72
	adrp	x21, .LANCHOR155
	mov	w19, 0
	add	x22, x22, :lo12:.LANCHOR72
	add	x21, x21, :lo12:.LANCHOR155
	b	.L1789
.L1792:
	add	x0, x29, 64
	mov	w1, 65535
	add	x0, x0, x19, sxtw 1
	ldrh	w0, [x0, 16]
	cmp	w0, w1
	bne	.L1788
.L1791:
	add	w19, w19, 1
	and	w19, w19, 65535
.L1789:
	ldrb	w0, [x22]
	cmp	w0, w19
	bhi	.L1792
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1787
.L1788:
	adrp	x1, .LANCHOR103
	ldrb	w3, [x24]
	mov	x2, x21
	ldrh	w4, [x1, #:lo12:.LANCHOR103]
	adrp	x1, ftl_tmp_buffer
	add	x1, x1, :lo12:ftl_tmp_buffer
	madd	w0, w4, w0, w20
	bl	ftl_read_ppa_page
	cmp	w0, 512
	bne	.L1791
.L1786:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 96
	ret
	.size	ftl_open_sblk_read_test, .-ftl_open_sblk_read_test
	.section	.text.sblk_read_page,"ax",@progbits
	.align	2
	.global	sblk_read_page
	.type	sblk_read_page, %function
sblk_read_page:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w21, w1, 255
	stp	x19, x20, [sp, 16]
	mov	w22, w21
	stp	x23, x24, [sp, 48]
	mov	x20, x0
	adrp	x23, .LANCHOR120
	adrp	x24, .LANCHOR46
	mov	x19, x0
	add	x23, x23, :lo12:.LANCHOR120
	add	x24, x24, :lo12:.LANCHOR46
	stp	x25, x26, [sp, 64]
.L1798:
	cbnz	w22, .L1802
.L1810:
	adrp	x19, .LANCHOR46
	add	x19, x19, :lo12:.LANCHOR46
.L1803:
	cbnz	w21, .L1806
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1802:
	ldrb	w25, [x19]
	ldr	w26, [x19, 40]
.L1799:
	mov	w1, 0
	mov	w0, w26
	bl	queue_lun_state
	cbnz	w0, .L1800
	ldr	w1, [x19, 40]
	mov	w0, 48
	bl	flash_start_page_read
	strb	wzr, [x19, 59]
	mov	w0, 1
	strb	w0, [x19, 58]
	mov	w0, -1
	strb	w0, [x19]
	mov	x1, x19
	mov	x0, x23
	bl	buf_add_tail
	subs	w22, w22, #1
	beq	.L1810
	ubfiz	x19, x25, 6, 8
	add	x19, x24, x19
	b	.L1798
.L1800:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1799
.L1806:
	ldrb	w0, [x20, 58]
	cmp	w0, 12
	bne	.L1804
	ldrb	w20, [x20]
	sub	w21, w21, #1
	add	x20, x19, x20, lsl 6
	b	.L1803
.L1804:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1803
	.size	sblk_read_page, .-sblk_read_page
	.section	.text.gc_check_data_one_wl,"ax",@progbits
	.align	2
	.global	gc_check_data_one_wl
	.type	gc_check_data_one_wl, %function
gc_check_data_one_wl:
	sub	sp, sp, #112
	adrp	x0, .LANCHOR5
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x19, .LANCHOR63
	add	x20, x19, :lo12:.LANCHOR63
	stp	x21, x22, [sp, 48]
	ldr	x21, [x0, #:lo12:.LANCHOR5]
	stp	x23, x24, [sp, 64]
	ldr	x0, [x20, 8]
	stp	x25, x26, [sp, 80]
	str	x27, [sp, 96]
	cbnz	x0, .L1813
	mov	w0, 1
	bl	buf_alloc
	str	x0, [x20, 8]
.L1813:
	add	x0, x19, :lo12:.LANCHOR63
	ldr	x20, [x0, 8]
	cbnz	x20, .L1814
	adrp	x1, .LANCHOR156
	adrp	x0, .LC0
	mov	w2, 348
	add	x1, x1, :lo12:.LANCHOR156
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1814:
	adrp	x26, .LANCHOR103
	adrp	x27, .LANCHOR67
	add	x25, x21, 96
	add	x26, x26, :lo12:.LANCHOR103
	add	x27, x27, :lo12:.LANCHOR67
	mov	w24, 0
.L1815:
	ldrb	w0, [x21, 89]
	cmp	w24, w0
	bge	.L1824
	mov	w23, 1
	add	x22, x19, :lo12:.LANCHOR63
	b	.L1825
.L1823:
	ldrh	w0, [x25]
	ldrh	w1, [x26]
	ldrb	w2, [x27]
	cmp	w2, 3
	mul	w1, w0, w1
	ldrh	w0, [x22, 16]
	bne	.L1816
	add	w0, w0, w1
	orr	w0, w0, w23, lsl 24
.L1836:
	str	w0, [x20, 40]
	mov	w1, 1
	mov	x0, x20
	bl	sblk_read_page
	ldr	w2, [x20, 52]
	adrp	x1, .LANCHOR139
	cmn	w2, #1
	beq	.L1819
	ldrh	w0, [x22, 22]
	ldr	x4, [x1, #:lo12:.LANCHOR139]
	ldr	x3, [x20, 24]
	lsl	x0, x0, 2
	ldr	w5, [x4, x0]
	ldr	w4, [x3, 4]
	cmp	w5, w4
	bne	.L1819
	adrp	x4, .LANCHOR140
	ldr	x4, [x4, #:lo12:.LANCHOR140]
	ldr	w4, [x4, x0]
	ldr	w0, [x3, 8]
	cmp	w4, w0
	beq	.L1820
.L1819:
	ldrh	w0, [x22, 22]
	ldr	x1, [x1, #:lo12:.LANCHOR139]
	lsl	x0, x0, 2
	ldr	w3, [x1, x0]
	cmn	w3, #1
	beq	.L1820
	adrp	x1, .LANCHOR7
	ldr	w1, [x1, #:lo12:.LANCHOR7]
	tbz	x1, 10, .L1821
	ldr	x1, [x20, 24]
	adrp	x4, .LANCHOR140
	ldr	x4, [x4, #:lo12:.LANCHOR140]
	ldr	w5, [x1, 12]
	str	w5, [sp]
	ldr	w4, [x4, x0]
	adrp	x0, .LC108
	ldp	w5, w6, [x1]
	add	x0, x0, :lo12:.LC108
	ldr	w7, [x1, 8]
	ldr	w1, [x20, 40]
	bl	printf
.L1821:
	adrp	x0, .LANCHOR4
	ldrh	w1, [x21, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	strh	wzr, [x0, x1, lsl 1]
	mov	w0, -1
.L1812:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	ldr	x27, [sp, 96]
	add	sp, sp, 112
	ret
.L1816:
	cmp	w2, 2
	bne	.L1818
	sub	w0, w0, #1
	add	w1, w23, w1
	add	w0, w0, w1
	orr	w0, w0, 33554432
	b	.L1836
.L1818:
	add	w0, w0, w1
	b	.L1836
.L1820:
	ldrh	w0, [x22, 22]
	add	w23, w23, 1
	add	w0, w0, 1
	strh	w0, [x22, 22]
.L1825:
	ldrh	w0, [x22, 20]
	cmp	w23, w0
	ble	.L1823
	add	w24, w24, 1
	add	x25, x25, 2
	b	.L1815
.L1824:
.L1822:
	add	x19, x19, :lo12:.LANCHOR63
	ldrh	w0, [x19, 16]
	add	w0, w0, 1
	strh	w0, [x19, 16]
	mov	w0, 0
	b	.L1812
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
	adrp	x0, .LANCHOR21
	adrp	x22, .LANCHOR7
	stp	x25, x26, [sp, 64]
	ldr	x25, [x0, #:lo12:.LANCHOR21]
	mov	w21, w1
	ldr	w0, [x22, #:lo12:.LANCHOR7]
	and	x19, x20, 255
	stp	x23, x24, [sp, 48]
	add	x23, x19, 8
	stp	x27, x28, [sp, 80]
	mov	x26, x2
	mov	x27, x3
	add	x23, x25, x23, lsl 8
	and	w24, w1, 2097151
	ubfx	x28, x21, 24, 2
	tbz	x0, 4, .L1838
	adrp	x0, .LC109
	mov	w3, w4
	mov	w2, w28
	add	x0, x0, :lo12:.LC109
	bl	printf
.L1838:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	hynix_reconfig_rr_para
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w28, .L1839
	bl	zftl_flash_enter_slc_mode
.L1840:
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
	adrp	x0, .LANCHOR32+9
	mov	x3, x27
	mov	x2, x26
	ldrb	w1, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	mov	w0, 16
	str	w0, [x19, 2056]
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	mov	w2, w0
	mov	w0, w20
	bl	nandc_de_cs
	and	w19, w2, 4
	tbz	x2, 2, .L1837
	ldr	w0, [x22, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L1837
	adrp	x0, .LC110
	mov	w2, w19
	mov	w1, w21
	add	x0, x0, :lo12:.LC110
	bl	printf
.L1837:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1839:
	bl	zftl_flash_exit_slc_mode
	b	.L1840
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
	bne	.L1853
	adrp	x0, .LANCHOR157
	ldrb	w0, [x0, #:lo12:.LANCHOR157]
	cmp	w0, w19
	bhi	.L1857
.L1853:
	adrp	x22, .LANCHOR152
	adrp	x23, .LANCHOR153
	mov	w2, 32
	mov	w1, 165
	ldr	x0, [x22, #:lo12:.LANCHOR152]
	bl	ftl_memset
	ldr	x0, [x23, #:lo12:.LANCHOR153]
	mov	w2, 8
	mov	w1, 90
	bl	ftl_memset
	adrp	x0, .LANCHOR26
	ldrh	w20, [x0, #:lo12:.LANCHOR26]
	mov	w0, w21
	mul	w20, w20, w19
	mov	w1, w20
	bl	flash_erase_block
	cmn	w0, #1
	beq	.L1855
	adrp	x19, .LANCHOR32
	add	x19, x19, :lo12:.LANCHOR32
	ldr	x3, [x22, #:lo12:.LANCHOR152]
	mov	w1, w20
	ldr	x2, [x23, #:lo12:.LANCHOR153]
	mov	w0, w21
	ldrb	w4, [x19, 9]
	bl	flash_prog_page
	cmn	w0, #1
	beq	.L1855
	ldrb	w4, [x19, 9]
	mov	w1, w20
	ldr	x3, [x22, #:lo12:.LANCHOR152]
	mov	w0, w21
	ldr	x2, [x23, #:lo12:.LANCHOR153]
	bl	flash_read_page
	mov	w19, w0
	cmn	w0, #1
	beq	.L1855
	ldr	x0, [x23, #:lo12:.LANCHOR153]
	ldr	w1, [x0]
	mov	w0, 23130
	movk	w0, 0x5a5a, lsl 16
	cmp	w1, w0
	bne	.L1855
	ldr	x0, [x22, #:lo12:.LANCHOR152]
	ldr	w1, [x0]
	mov	w0, 42405
	movk	w0, 0xa5a5, lsl 16
	cmp	w1, w0
	beq	.L1856
.L1855:
	mov	w19, -1
.L1856:
	mov	w1, w20
	mov	w0, w21
	bl	flash_erase_block
	mov	w0, w19
.L1852:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1857:
	mov	w0, 0
	b	.L1852
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
	adrp	x0, .LANCHOR158
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	ldrb	w0, [x0, #:lo12:.LANCHOR158]
	str	x25, [sp, 64]
	cbnz	w0, .L1868
	adrp	x20, .LANCHOR32
	add	x20, x20, :lo12:.LANCHOR32
	ldrb	w0, [x20, 19]
	sub	w0, w0, #5
	and	w3, w0, 255
	cmp	w3, 63
	bhi	.L1868
	and	w19, w2, 65535
	mov	x2, 16391
	movk	x2, 0x4000, lsl 16
	movk	x2, 0x8000, lsl 48
	lsr	x0, x2, x3
	tbz	x0, 0, .L1868
	adrp	x21, .LANCHOR126
	mov	w23, w1
	add	x21, x21, :lo12:.LANCHOR126
	mov	w25, 65535
	adrp	x24, .LANCHOR143
.L1870:
	ldrh	w0, [x20, 10]
	cmp	w0, w19
	bhi	.L1871
.L1868:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1871:
	ldrh	w0, [x21, w19, sxtw 1]
	cmp	w0, w25
	bne	.L1868
	ldr	x0, [x24, #:lo12:.LANCHOR143]
	mov	w2, 16384
	mov	w1, 255
	bl	ftl_memset
	ldr	x3, [x24, #:lo12:.LANCHOR143]
	add	w1, w19, w23
	ldrb	w4, [x20, 9]
	add	w19, w19, 1
	mov	x2, x3
	mov	w0, w22
	and	w19, w19, 65535
	bl	flash_prog_page
	b	.L1870
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
	bls	.L1874
	cmp	w1, 575
	bhi	.L1875
	adrp	x0, .LANCHOR159
	mov	x1, x2
	mov	w2, 1
	cmp	w4, 64
	str	w2, [x0, #:lo12:.LANCHOR159]
	adrp	x0, idb_buf
	bhi	.L1876
	mov	w2, 64
	sub	w4, w2, w4
	sub	w2, w3, w4
	ubfiz	x4, x4, 9, 25
	lsl	w2, w2, 9
	add	x1, x1, x4
	add	x0, x0, :lo12:idb_buf
.L1952:
	bl	ftl_memcpy
.L1931:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 256
	ret
.L1876:
	mov	w2, 576
	sub	w2, w2, w4
	cmp	w3, w2
	sub	w4, w4, #64
	csel	w2, w3, w2, ls
	ubfiz	x4, x4, 9, 25
	add	x0, x0, :lo12:idb_buf
	lsl	w2, w2, 9
	add	x0, x0, x4
	b	.L1952
.L1874:
	cmp	w1, 575
	bls	.L1931
.L1875:
	adrp	x0, .LANCHOR159
	ldr	w0, [x0, #:lo12:.LANCHOR159]
	cbz	w0, .L1931
	adrp	x3, .LANCHOR32
	add	x1, x3, :lo12:.LANCHOR32
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
.L1881:
	ldr	w5, [x1]
	cbnz	w5, .L1879
	ldr	w5, [x6, w0, uxtw 2]
	add	w0, w0, 1
	str	w5, [x1], -4
	cmp	w0, w4
	sub	w2, w2, #1
	csel	w0, w0, wzr, cc
	cmp	w2, 4096
	bne	.L1881
.L1879:
	add	x0, x3, :lo12:idb_buf
	mov	w3, w27
	ldr	w1, [x0, w2, uxtw 2]
	adrp	x0, .LC111
	add	x0, x0, :lo12:.LC111
	bl	printf
	stp	wzr, wzr, [x29, 168]
	adrp	x0, gp_flash_check_buf
	add	x0, x0, :lo12:gp_flash_check_buf
	str	x0, [x29, 184]
.L1915:
	adrp	x0, gp_flash_check_buf
	add	x20, x0, :lo12:gp_flash_check_buf
	mov	w1, 0
	mov	w2, 512
	mov	x0, x20
	bl	ftl_memset
	adrp	x0, .LANCHOR20
	ldr	w1, [x29, 172]
	ldr	x0, [x0, #:lo12:.LANCHOR20]
	add	x0, x0, x1, uxtw
	ldrb	w0, [x0, 32]
	cmp	w0, 255
	beq	.L1882
	ldr	w1, [x29, 132]
	adrp	x19, .LANCHOR42
	mul	w26, w0, w1
	ldr	x0, [x29, 176]
	add	x25, x0, :lo12:.LANCHOR32
	ldrb	w0, [x19, #:lo12:.LANCHOR42]
	str	w0, [x29, 128]
	strb	wzr, [x19, #:lo12:.LANCHOR42]
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
	bne	.L1921
	adrp	x0, .LANCHOR22
	ldrb	w0, [x0, #:lo12:.LANCHOR22]
	cmp	w0, 9
	bne	.L1921
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
.L1883:
	adrp	x22, idb_buf
	adrp	x28, .LANCHOR158
	add	x22, x22, :lo12:idb_buf
	add	x0, x28, :lo12:.LANCHOR158
	adrp	x25, .LANCHOR27
	str	x0, [x29, 152]
	mov	w20, 0
	add	x0, x25, :lo12:.LANCHOR27
	str	x0, [x29, 144]
.L1885:
	cmp	w27, w20
	bhi	.L1896
	ldr	x0, [x29, 176]
	add	x25, x19, :lo12:.LANCHOR42
	strb	wzr, [x19, #:lo12:.LANCHOR42]
	mov	w21, 4
	add	x0, x0, :lo12:.LANCHOR32
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
	adrp	x0, .LANCHOR27
	add	x0, x0, :lo12:.LANCHOR27
	str	x0, [x29, 104]
.L1897:
	ldr	w0, [x29, 160]
	cmp	w22, w0
	bcc	.L1911
	adrp	x0, .LANCHOR42
	ldrb	w1, [x29, 128]
	adrp	x3, idb_buf
	add	x3, x3, :lo12:idb_buf
	strb	w1, [x0, #:lo12:.LANCHOR42]
	mov	x1, 0
	ldr	w0, [x29, 164]
	lsl	w0, w0, 7
.L1912:
	mov	w19, w1
	cmp	w1, w0
	bcc	.L1913
	ldr	w0, [x29, 168]
	add	w0, w0, 1
	str	w0, [x29, 168]
	cmp	w0, 5
	bls	.L1882
	b	.L1917
.L1921:
	mov	x6, 0
	str	w27, [x29, 164]
	b	.L1883
.L1896:
	ldr	x2, [x29, 152]
	add	w5, w23, w20
	lsr	w5, w5, 2
	add	x0, x25, :lo12:.LANCHOR27
	add	w1, w5, 1
	ldrb	w2, [x2]
	ldrh	w0, [x0, w1, sxtw 1]
	cbz	w2, .L1887
	adrp	x0, .LANCHOR25
	ldrb	w3, [x0, #:lo12:.LANCHOR25]
	lsl	w0, w1, 1
	cmp	w3, 0
	csel	w0, w0, w1, ne
.L1887:
	adrp	x1, .LANCHOR22
	ldrb	w1, [x1, #:lo12:.LANCHOR22]
	cmp	w1, 9
	bne	.L1889
.L1950:
	str	w0, [x29, 192]
	mov	w0, 61424
	str	w0, [x29, 196]
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, w5, sxtw 1]
	cbnz	w2, .L1891
	mov	w5, w0
.L1892:
	mul	w1, w21, w5
	adrp	x2, .LANCHOR40
	adrp	x0, .LANCHOR10
	cbnz	x6, .L1893
	ldr	x3, [x29, 176]
	add	w1, w1, w24
	ldrb	w7, [x2, #:lo12:.LANCHOR40]
	add	x3, x3, :lo12:.LANCHOR32
	ldrb	w0, [x0, #:lo12:.LANCHOR10]
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
	ldrb	w0, [x28, #:lo12:.LANCHOR158]
	ldr	w5, [x29, 140]
	cbnz	w0, .L1894
	udiv	w1, w24, w21
	add	w2, w5, 1
	bl	id_block_prog_msb_ff_data
.L1894:
	add	x22, x22, 2048
.L1895:
	add	w20, w20, 4
	mov	x6, 0
	and	w20, w20, 65535
	b	.L1885
.L1889:
	sub	w0, w0, #1
	lsl	w0, w0, 2
	b	.L1950
.L1891:
	adrp	x0, .LANCHOR25
	ldrb	w1, [x0, #:lo12:.LANCHOR25]
	lsl	w0, w5, 1
	cmp	w1, 0
	csel	w5, w0, w5, ne
	b	.L1892
.L1893:
	ldr	x3, [x29, 176]
	add	w1, w1, w24
	ldrb	w7, [x2, #:lo12:.LANCHOR40]
	add	x3, x3, :lo12:.LANCHOR32
	ldrb	w0, [x0, #:lo12:.LANCHOR10]
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
	b	.L1895
.L1911:
	add	w19, w28, w22
	ldr	w0, [x29, 152]
	adrp	x1, .LANCHOR158
	sub	w24, w21, w0
	ldr	x0, [x29, 104]
	udiv	w19, w19, w21
	ldrb	w1, [x1, #:lo12:.LANCHOR158]
	and	w24, w24, 65535
	and	w19, w19, 65535
	ldrh	w0, [x0, w19, sxtw 1]
	cbnz	w1, .L1898
	mov	w19, w0
.L1899:
	adrp	x0, .LANCHOR10
	ldr	w1, [x29, 136]
	ldrb	w23, [x0, #:lo12:.LANCHOR10]
	ldr	w0, [x29, 152]
	add	w0, w0, w1
	ldr	w1, [x29, 140]
	madd	w19, w1, w19, w0
	ldr	x0, [x29, 176]
	add	x0, x0, :lo12:.LANCHOR32
	ldrb	w0, [x0, 9]
	udiv	w19, w19, w0
	adrp	x0, .LANCHOR40
	ldrb	w0, [x0, #:lo12:.LANCHOR40]
	str	w0, [x29, 124]
	mov	w0, w23
	bl	nandc_bch_sel
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	str	x0, [x29, 112]
.L1900:
	mov	w4, w21
	add	x3, x29, 192
	mov	x2, x20
	mov	w1, w19
	mov	w0, 0
	bl	flash_read_page
	mov	w5, w0
	cmn	w0, #1
	bne	.L1901
	ldrb	w6, [x25]
	cbnz	w6, .L1902
.L1905:
	adrp	x0, .LANCHOR148
	ldr	x6, [x0, #:lo12:.LANCHOR148]
	cbnz	x6, .L1903
.L1904:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cbz	w0, .L1901
	mov	w4, w21
	add	x3, x29, 192
	mov	x2, x20
	mov	w1, w19
	mov	w0, 0
	bl	flash_ddr_tunning_read
	b	.L1951
.L1898:
	adrp	x0, .LANCHOR25
	ldrb	w1, [x0, #:lo12:.LANCHOR25]
	lsl	w0, w19, 1
	cmp	w1, 0
	csel	w19, w0, w19, ne
	b	.L1899
.L1902:
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
	beq	.L1905
.L1951:
	mov	w5, w0
.L1901:
	cmn	w5, #1
	cset	w3, eq
	cmp	w23, 16
	cset	w0, ne
	tst	w3, w0
	beq	.L1907
	mov	w0, 16
	mov	w23, 16
	bl	nandc_bch_sel
	b	.L1900
.L1903:
	str	w5, [x29, 120]
	mov	w4, w21
	add	x3, x29, 192
	mov	x2, x20
	mov	w1, w19
	mov	w0, 0
	blr	x6
	cmn	w0, #1
	ldr	w5, [x29, 120]
	beq	.L1904
	b	.L1951
.L1907:
	ldr	w0, [x29, 124]
	bl	nandc_bch_sel
	cmp	w3, 0
	ldr	w0, [x29, 144]
	csinv	w0, w0, wzr, eq
	str	w0, [x29, 144]
	ldr	w0, [x29, 136]
	cmp	w22, 0
	ccmp	w26, w0, 0, eq
	bne	.L1909
	ldr	w0, [x29, 144]
	cbnz	w0, .L1909
	ldr	w1, [x20]
	mov	w0, 18766
	movk	w0, 0x464e, lsl 16
	cmp	w1, w0
	bne	.L1909
	ldr	w0, [x29, 160]
	ldrb	w21, [x20, 17]
	add	w0, w0, w24
	str	w0, [x29, 160]
.L1910:
	add	w22, w24, w22
	and	w22, w22, 65535
	b	.L1897
.L1909:
	ubfiz	x0, x24, 9, 16
	str	wzr, [x29, 152]
	add	x20, x20, x0
	b	.L1910
.L1913:
	ldr	x4, [x29, 184]
	lsl	x2, x1, 2
	add	x1, x1, 1
	ldr	w4, [x2, x4]
	ldr	w2, [x3, x2]
	cmp	w4, w2
	beq	.L1912
	ldr	x0, [x29, 184]
	mov	w2, 512
	mov	w1, 0
	bl	ftl_memset
	mov	w1, w19
	adrp	x0, .LC112
	add	x0, x0, :lo12:.LC112
	bl	printf
	mov	w1, w26
	mov	w0, 0
	bl	flash_erase_block
.L1882:
	ldr	w0, [x29, 172]
	add	w0, w0, 1
	str	w0, [x29, 172]
	cmp	w0, 4
	bne	.L1915
	ldr	w0, [x29, 168]
	cbnz	w0, .L1917
	adrp	x0, .LC113
	mov	w1, 0
	add	x0, x0, :lo12:.LC113
	bl	printf
.L1917:
	adrp	x0, .LANCHOR159
	str	wzr, [x0, #:lo12:.LANCHOR159]
	b	.L1931
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
	adrp	x0, .LANCHOR12
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	and	w19, w3, 255
	stp	x23, x24, [sp, 48]
	and	w21, w1, 255
	ldrb	w0, [x0, #:lo12:.LANCHOR12]
	and	w22, w2, 255
	mov	w20, w4
	mov	x23, x5
	mov	x24, x6
	cmp	w0, w19
	bhi	.L1954
	adrp	x1, .LANCHOR160
	adrp	x0, .LC0
	mov	w2, 648
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1954:
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	ldrb	w26, [x0, w19, sxtw]
	adrp	x0, .LANCHOR21
	ldr	x19, [x0, #:lo12:.LANCHOR21]
	mov	w0, w26
	bl	nandc_cs
	cbz	w25, .L1955
	sxtw	x0, w26
	add	x0, x0, 8
	add	x0, x19, x0, lsl 8
	str	w25, [x0, 8]
.L1955:
	ubfiz	x0, x26, 8, 8
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
	mov	x3, x24
	mov	x2, x23
	ldrb	w1, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	mov	w0, w26
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	str	w22, [x19, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	b	nandc_de_cs
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
	adrp	x0, .LANCHOR120
	add	x0, x0, :lo12:.LANCHOR120
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
.L1963:
	mov	w1, 1
	mov	w0, w20
	bl	queue_lun_state
	cbnz	w0, .L1964
	mov	x0, x19
	bl	queue_tlc_prog_cmd
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1964:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1963
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
.L1967:
	mov	w1, 1
	mov	w0, w20
	bl	queue_lun_state
	cbnz	w0, .L1968
	cmp	w24, 2
	bne	.L1969
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
	adrp	x0, .LANCHOR120
	add	x0, x0, :lo12:.LANCHOR120
	bl	buf_add_tail
.L1970:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1968:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1967
.L1969:
	mov	x0, x19
	bl	queue_tlc_prog_cmd
	b	.L1970
	.size	sblk_xlc_prog_pages, .-sblk_xlc_prog_pages
	.section	.text.flash_start_page_prog,"ax",@progbits
	.align	2
	.global	flash_start_page_prog
	.type	flash_start_page_prog, %function
flash_start_page_prog:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR12
	stp	x23, x24, [sp, 48]
	and	w23, w0, 255
	stp	x19, x20, [sp, 16]
	mov	x24, x2
	stp	x21, x22, [sp, 32]
	mov	x25, x3
	ldrb	w0, [x26, #:lo12:.LANCHOR12]
	and	w19, w1, 2097151
	str	x27, [sp, 80]
	ubfx	x27, x1, 21, 3
	ubfx	x22, x1, 24, 2
	cmp	w0, w27
	bhi	.L1973
	adrp	x1, .LANCHOR161
	adrp	x0, .LC0
	mov	w2, 685
	add	x1, x1, :lo12:.LANCHOR161
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1973:
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	ldrb	w21, [x0, w27, sxtw]
	adrp	x0, .LANCHOR21
	ldr	x20, [x0, #:lo12:.LANCHOR21]
	bl	nandc_rdy_status
	cbnz	w0, .L1974
	ldrb	w0, [x26, #:lo12:.LANCHOR12]
	cmp	w0, 1
	bne	.L1975
	bl	nandc_wait_flash_ready
.L1974:
	mov	w0, w21
	bl	hynix_reconfig_rr_para
	mov	w0, w21
	bl	nandc_cs
	cbnz	w22, .L1976
	adrp	x0, .LANCHOR11
	adrp	x1, .LANCHOR25
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	cbz	w0, .L1977
	ldrb	w0, [x1, #:lo12:.LANCHOR25]
	cbz	w0, .L1978
.L1977:
	adrp	x0, .LANCHOR26
	ldrb	w1, [x1, #:lo12:.LANCHOR25]
	ldrh	w2, [x0, #:lo12:.LANCHOR26]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L1979
	add	w19, w0, w19, lsl 1
.L1978:
	mov	w0, w21
	bl	zftl_flash_enter_slc_mode
	b	.L1980
.L1975:
	mov	w2, 64
	mov	w1, w19
	mov	w0, w27
	bl	flash_wait_device_ready_raw
	b	.L1974
.L1979:
	adrp	x1, .LANCHOR27
	add	x1, x1, :lo12:.LANCHOR27
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
.L1980:
	ubfiz	x0, x21, 8, 8
	add	x20, x20, x0
	mov	w0, 128
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
	mov	x3, x25
	mov	x2, x24
	ldrb	w1, [x0, #:lo12:.LANCHOR32+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	ldr	x27, [sp, 80]
	ldp	x25, x26, [sp, 64]
	mov	w0, w21
	ldp	x21, x22, [sp, 32]
	str	w23, [x20, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 96
	b	nandc_de_cs
.L1976:
	mov	w0, w21
	bl	zftl_flash_exit_slc_mode
	b	.L1980
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
	adrp	x0, .LANCHOR120
	ldr	w3, [x19, 40]
	ldrb	w1, [x0, #:lo12:.LANCHOR120]
	cmp	w1, 255
	beq	.L1986
	adrp	x2, .LANCHOR46
	add	x2, x2, :lo12:.LANCHOR46
	ubfx	x3, x3, 21, 3
	mov	x6, x2
.L1988:
	add	x4, x2, x1, lsl 6
	ldr	w5, [x4, 40]
	ubfx	x5, x5, 21, 3
	cmp	w3, w5
	bne	.L1987
	ldrb	w5, [x4, 58]
	cmp	w5, 6
	bne	.L1987
	mov	w1, 3
	strb	w1, [x4, 58]
.L1986:
	mov	w1, 3
	strb	w1, [x19, 58]
	mov	w1, 1
	strb	w1, [x19, 59]
	mov	w1, -1
	strb	w1, [x19]
	mov	x1, x19
	add	x0, x0, :lo12:.LANCHOR120
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	buf_add_tail
.L1987:
	lsl	x1, x1, 6
	ldrb	w1, [x6, x1]
	cmp	w1, 255
	bne	.L1988
	b	.L1986
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
	cbz	w0, .L1995
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L1995
	ldr	w1, [x19, 40]
	adrp	x0, .LC114
	mov	w2, w20
	add	x0, x0, :lo12:.LC114
	bl	printf
.L1995:
	adrp	x25, .LANCHOR36
	adrp	x23, .LANCHOR46
	add	x25, x25, :lo12:.LANCHOR36
	add	x23, x23, :lo12:.LANCHOR46
	mov	w21, 0
	mov	w24, 1
.L1996:
	cbnz	w20, .L2006
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2006:
	ldrb	w26, [x19]
	ldr	w22, [x19, 40]
.L1997:
	mov	w1, 1
	mov	w0, w22
	bl	queue_lun_state
	cbnz	w0, .L1998
	cmp	w20, 1
	beq	.L1999
	ldrb	w0, [x25]
	cbnz	w0, .L2000
.L1999:
	mov	x0, x19
	bl	queue_prog_cmd
.L2001:
	ubfiz	x19, x26, 6, 8
	sub	w20, w20, #1
	add	x19, x23, x19
	b	.L1996
.L1998:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1997
.L2000:
	ldrb	w0, [x19]
	ubfx	x27, x22, 21, 3
	cmp	w0, 255
	bne	.L2002
	adrp	x1, .LANCHOR162
	adrp	x0, .LC0
	mov	w2, 489
	add	x1, x1, :lo12:.LANCHOR162
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2002:
	ldrb	w0, [x19]
	add	x0, x23, x0, lsl 6
	ldr	w5, [x0, 40]
	ubfx	x0, x5, 21, 3
	cmp	w27, w0
	bne	.L2003
	adrp	x0, .LANCHOR96
	ldrh	w2, [x0, #:lo12:.LANCHOR96]
	adrp	x0, .LANCHOR95
	ldrb	w3, [x0, #:lo12:.LANCHOR95]
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
	bne	.L2003
	cmp	w21, w3
	beq	.L2003
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
	adrp	x0, .LANCHOR120
	add	x0, x0, :lo12:.LANCHOR120
	bl	buf_add_tail
	b	.L2001
.L2003:
	mov	x0, x19
	mov	w21, 0
	bl	queue_prog_cmd
	b	.L2001
	.size	sblk_prog_page, .-sblk_prog_page
	.section	.text.ftl_flush,"ax",@progbits
	.align	2
	.global	ftl_flush
	.type	ftl_flush, %function
ftl_flush:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR115
	add	x29, sp, 0
	ldrb	w1, [x0, #:lo12:.LANCHOR115]
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	adrp	x20, .LANCHOR163
	cbz	w1, .L2018
	ldrb	w2, [x20, #:lo12:.LANCHOR163]
	adrp	x0, .LANCHOR46
	add	x0, x0, :lo12:.LANCHOR46
	add	x0, x0, x2, lsl 6
	bl	sblk_prog_page
.L2018:
	mov	w0, -1
	strb	wzr, [x19, #:lo12:.LANCHOR115]
	strb	w0, [x20, #:lo12:.LANCHOR163]
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
	adrp	x0, .LANCHOR12
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	mov	w20, w1
	stp	x25, x26, [sp, 64]
	mov	x24, x2
	ldrb	w0, [x0, #:lo12:.LANCHOR12]
	mov	x23, x3
	mov	w25, w4
	and	w21, w5, 255
	ubfx	x19, x20, 24, 2
	cmp	w0, w22
	bhi	.L2024
	adrp	x1, .LANCHOR164
	adrp	x0, .LC0
	mov	w2, 473
	add	x1, x1, :lo12:.LANCHOR164
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2024:
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
	ldrb	w26, [x0, w22, sxtw]
	cbnz	w19, .L2034
	adrp	x0, .LANCHOR11
	ldrb	w1, [x0, #:lo12:.LANCHOR11]
	adrp	x0, .LANCHOR25
	cbz	w1, .L2026
	ldrb	w1, [x0, #:lo12:.LANCHOR25]
	cbz	w1, .L2034
.L2026:
	adrp	x1, .LANCHOR26
	ldrb	w0, [x0, #:lo12:.LANCHOR25]
	ldrh	w1, [x1, #:lo12:.LANCHOR26]
	udiv	w19, w20, w1
	mul	w19, w19, w1
	sub	w1, w20, w19
	cbz	w0, .L2027
	add	w19, w19, w1, lsl 1
.L2025:
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 4, .L2028
	adrp	x0, .LC115
	mov	w2, w20
	mov	w1, w26
	add	x0, x0, :lo12:.LC115
	bl	printf
.L2028:
	mov	w1, w19
	mov	w4, w25
	mov	x3, x23
	mov	x2, x24
	mov	w0, w26
	bl	flash_prog_page
	mov	w19, w0
	cbz	w21, .L2029
	adrp	x26, .LANCHOR152
	adrp	x21, .LANCHOR153
	mov	w4, w25
	mov	w1, w20
	ldr	x3, [x26, #:lo12:.LANCHOR152]
	mov	w0, w22
	ldr	x2, [x21, #:lo12:.LANCHOR153]
	bl	flash_read_page_en
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2030
	ldr	x0, [x21, #:lo12:.LANCHOR153]
	ldr	w1, [x24]
	ldr	w0, [x0]
	cmp	w1, w0
	bne	.L2030
	ldr	x0, [x26, #:lo12:.LANCHOR152]
	ldr	w1, [x23]
	ldr	w0, [x0]
	cmp	w1, w0
	beq	.L2029
.L2030:
	ldr	x1, [x26, #:lo12:.LANCHOR152]
	mov	w3, 4
	adrp	x0, .LC116
	mov	w2, w3
	add	x0, x0, :lo12:.LC116
	bl	rknand_print_hex
	ldr	x1, [x21, #:lo12:.LANCHOR153]
	mov	w3, 4
	adrp	x0, .LC117
	mov	w2, w3
	add	x0, x0, :lo12:.LC117
	bl	rknand_print_hex
.L2031:
	mov	w1, w20
	adrp	x0, .LC118
	add	x0, x0, :lo12:.LC118
	bl	printf
	mov	w2, 499
	adrp	x1, .LANCHOR164
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR164
	add	x0, x0, :lo12:.LC0
	bl	printf
	mov	w0, -1
	b	.L2032
.L2027:
	adrp	x0, .LANCHOR27
	add	x0, x0, :lo12:.LANCHOR27
	ldrh	w0, [x0, w1, uxtw 1]
	add	w19, w0, w19
	b	.L2025
.L2034:
	mov	w19, w20
	b	.L2025
.L2029:
	mov	w0, w19
	cmn	w19, #1
	beq	.L2031
.L2032:
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
	adrp	x25, .LANCHOR155
	stp	x21, x22, [sp, 32]
	adrp	x26, .LANCHOR104
	and	w21, w0, 65535
	add	x0, x26, :lo12:.LANCHOR104
	stp	x19, x20, [sp, 16]
	mov	w23, 0
	stp	x27, x28, [sp, 80]
	mov	w20, 0
	adrp	x27, .LANCHOR95
	str	x0, [x29, 112]
	str	wzr, [x24, #:lo12:ftl_tmp_buffer]
	add	x0, x27, :lo12:.LANCHOR95
	str	wzr, [x25, #:lo12:.LANCHOR155]
	str	x0, [x29, 96]
.L2046:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cmp	w0, w20
	bls	.L2056
	add	x0, x27, :lo12:.LANCHOR95
	mov	w22, 0
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR7
	add	x0, x0, :lo12:.LANCHOR7
	str	x0, [x29, 104]
	b	.L2057
.L2055:
	ldr	x0, [x29, 104]
	ldr	w0, [x0]
	tbz	x0, 12, .L2047
	adrp	x0, .LC119
	mov	w1, w21
	add	x0, x0, :lo12:.LC119
	bl	printf
.L2047:
	ldr	x0, [x29, 96]
	ldrb	w19, [x0]
	madd	w19, w21, w19, w22
	and	w19, w19, 65535
	cbnz	w20, .L2048
	adrp	x0, .LANCHOR20
	ldr	x0, [x0, #:lo12:.LANCHOR20]
	ldrb	w0, [x0, 47]
	cmp	w0, w19
	bcs	.L2049
.L2048:
	and	w28, w20, 255
	mov	w1, w19
	mov	w0, w28
	bl	flash_check_bad_block
	cbnz	w0, .L2049
	adrp	x0, .LANCHOR103
	mov	w1, w23
	ldrh	w7, [x0, #:lo12:.LANCHOR103]
	mov	w0, w28
	mul	w26, w7, w19
	mov	w2, w26
	bl	flash_erase_block_en
	cbz	w0, .L2050
	adrp	x0, .LANCHOR67
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	cmp	w0, 2
	bne	.L2072
	adrp	x0, .LANCHOR11
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	cbz	w0, .L2072
	mov	w2, w26
	mov	w1, 1
	mov	w0, w28
	bl	flash_erase_block_en
	cbnz	w0, .L2072
.L2054:
	adrp	x0, .LANCHOR67
	mov	w23, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	add	w26, w26, w0, lsl 24
.L2053:
	adrp	x0, .LANCHOR117
	mov	w5, 1
	add	x3, x25, :lo12:.LANCHOR155
	add	x2, x24, :lo12:ftl_tmp_buffer
	ldrb	w4, [x0, #:lo12:.LANCHOR117]
	mov	w1, w26
	mov	w0, w28
	bl	flash_prog_page_en
	cbz	w0, .L2049
.L2072:
	mov	w1, w19
	mov	w0, w28
	bl	flash_mask_bad_block
.L2049:
	add	w22, w22, 1
	and	w22, w22, 65535
.L2057:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, w22
	bhi	.L2055
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2046
.L2050:
	cbz	w23, .L2053
	b	.L2054
.L2056:
	cbz	w23, .L2058
	adrp	x0, .LANCHOR3
	mov	w1, 2
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x21, x0, x21, uxth 2
	ldrb	w0, [x21, 2]
	bfi	w0, w1, 3, 2
	strb	w0, [x21, 2]
.L2058:
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
	bne	.L2073
	mov	w2, 2052
	adrp	x1, .LANCHOR165
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR165
	add	x0, x0, :lo12:.LC0
	bl	printf
	adrp	x0, .LC118
	mov	w1, w20
	add	x0, x0, :lo12:.LC118
	bl	printf
.L2073:
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
	adrp	x21, .LANCHOR117
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR167
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR103
	stp	x27, x28, [sp, 80]
	mov	x26, x23
	ldrb	w2, [x21, #:lo12:.LANCHOR117]
	add	x25, x22, :lo12:.LANCHOR167
	add	x28, x23, :lo12:.LANCHOR103
	mov	w24, 0
	stp	x19, x20, [sp, 16]
	mov	w27, w0
	adrp	x20, .LANCHOR166
	lsl	w2, w2, 1
	add	x0, x20, :lo12:.LANCHOR166
	bl	ftl_memset
.L2077:
	add	x0, x22, :lo12:.LANCHOR167
	ldrb	w6, [x22, #:lo12:.LANCHOR167]
	ldrh	w19, [x23, #:lo12:.LANCHOR103]
	ldrh	w4, [x0, 2]
	adrp	x0, .LANCHOR97
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	ldr	w3, [x0, 4]
	add	w3, w3, 1
	str	w3, [x0, 4]
	add	x0, x20, :lo12:.LANCHOR166
	str	w27, [x20, #:lo12:.LANCHOR166]
	str	w3, [x0, 4]
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2078
	mov	w2, w4
	mov	w1, w6
	str	w4, [x29, 96]
	adrp	x0, .LC120
	str	w6, [x29, 104]
	add	x0, x0, :lo12:.LC120
	bl	printf
	ldr	w4, [x29, 96]
	ldr	w6, [x29, 104]
.L2078:
	adrp	x1, .LANCHOR80
	ldrh	w0, [x25, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	cmp	w1, w0
	bhi	.L2079
	adrp	x19, .LANCHOR168
	adrp	x3, .LC0
	add	x19, x19, :lo12:.LANCHOR168
	add	x3, x3, :lo12:.LC0
.L2086:
	ldrb	w0, [x25, 1]
	adrp	x4, .LANCHOR20
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x25, 1]
	cmp	w0, 7
	bls	.L2080
	mov	x0, 0
.L2085:
	ldr	x2, [x4, #:lo12:.LANCHOR20]
	add	w1, w0, 8
	and	w24, w0, 65535
	add	x1, x2, x1, sxtw
	ldrb	w2, [x1, 32]
	add	w1, w2, 127
	and	w1, w1, 255
	cmp	w1, 125
	bhi	.L2081
	mov	x0, x3
	stp	x4, x3, [x29, 96]
	mov	w2, 672
	mov	x1, x19
	bl	printf
	ldp	x4, x3, [x29, 96]
.L2084:
	strb	w24, [x25, 1]
	mov	w24, 1
.L2080:
	ldr	x0, [x4, #:lo12:.LANCHOR20]
	ldrb	w1, [x25, 1]
	add	x0, x0, x1
	ldrb	w0, [x0, 40]
	strb	w0, [x25]
	cmp	w0, 255
	beq	.L2086
	ldrh	w19, [x28]
	mul	w19, w19, w0
	mov	w0, 0
	mov	w1, w19
	bl	flash_erase_block
	ldrb	w4, [x21, #:lo12:.LANCHOR117]
	mov	w1, w19
	add	x3, x20, :lo12:.LANCHOR166
	adrp	x2, ftl_info_data_buffer
	mov	w0, 0
	add	x2, x2, :lo12:ftl_info_data_buffer
	add	w19, w19, 1
	bl	ftl_prog_page
	mov	w0, 1
	strh	w0, [x25, 2]
.L2087:
	ldrb	w4, [x21, #:lo12:.LANCHOR117]
	mov	w1, w19
	add	x3, x20, :lo12:.LANCHOR166
	adrp	x2, ftl_info_data_buffer
	mov	w0, 0
	add	x2, x2, :lo12:ftl_info_data_buffer
	bl	ftl_prog_page
	cmn	w0, #1
	ldrh	w1, [x25, 2]
	adrp	x0, .LANCHOR169
	add	w1, w1, 1
	strh	w1, [x25, 2]
	beq	.L2088
	ldrb	w1, [x0, #:lo12:.LANCHOR169]
	cbz	w1, .L2089
.L2088:
	strb	wzr, [x0, #:lo12:.LANCHOR169]
	b	.L2077
.L2081:
	cmp	w2, 255
	bne	.L2084
	add	x0, x0, 1
	cmp	x0, 8
	bne	.L2085
	mov	w24, w0
	b	.L2084
.L2079:
	madd	w19, w19, w6, w4
	cbnz	w0, .L2087
	mov	w1, w19
	bl	flash_erase_block
	b	.L2087
.L2089:
	cbnz	w24, .L2090
.L2098:
	adrp	x0, .LANCHOR167
	ldrb	w0, [x0, #:lo12:.LANCHOR167]
	cmp	w0, 255
	bne	.L2092
	adrp	x1, .LANCHOR168
	adrp	x0, .LC0
	mov	w2, 708
	add	x1, x1, :lo12:.LANCHOR168
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2092:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2090:
	ldrb	w19, [x25, 1]
	adrp	x20, .LANCHOR168
	adrp	x21, .LC0
	add	x20, x20, :lo12:.LANCHOR168
	add	w19, w19, 1
	add	x21, x21, :lo12:.LC0
	adrp	x22, .LANCHOR20
.L2093:
	cmp	w19, 7
	bhi	.L2098
	ldr	x1, [x22, #:lo12:.LANCHOR20]
	add	w0, w19, 8
	add	x0, x1, x0, sxtw
	ldrb	w23, [x0, 32]
	add	w0, w23, 127
	and	w0, w0, 255
	cmp	w0, 125
	bhi	.L2094
	mov	w2, 701
	mov	x1, x20
	mov	x0, x21
	bl	printf
.L2095:
	ldrh	w1, [x26, #:lo12:.LANCHOR103]
	mov	w0, 0
	mul	w1, w1, w23
	bl	flash_erase_block
	b	.L2096
.L2094:
	cmp	w23, 255
	bne	.L2095
.L2096:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2093
	.size	ftl_info_flush, .-ftl_info_flush
	.section	.text.ftl_info_blk_init,"ax",@progbits
	.align	2
	.global	ftl_info_blk_init
	.type	ftl_info_blk_init, %function
ftl_info_blk_init:
	stp	x29, x30, [sp, -128]!
	adrp	x0, .LANCHOR170
	adrp	x1, .LANCHOR169
	mov	w2, 16384
	add	x29, sp, 0
	strb	wzr, [x0, #:lo12:.LANCHOR170]
	mov	w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR169]
	adrp	x1, .LANCHOR171
	stp	x19, x20, [sp, 16]
	adrp	x20, ftl_info_data_buffer
	strb	w0, [x1, #:lo12:.LANCHOR171]
	adrp	x1, .LANCHOR3
	add	x0, x20, :lo12:ftl_info_data_buffer
	stp	x21, x22, [sp, 32]
	str	x0, [x1, #:lo12:.LANCHOR3]
	adrp	x1, .LANCHOR2
	adrp	x22, .LANCHOR97
	stp	x25, x26, [sp, 64]
	ldrh	w1, [x1, #:lo12:.LANCHOR2]
	adrp	x21, .LANCHOR167
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR20
	stp	x27, x28, [sp, 80]
	adrp	x26, .LANCHOR103
	add	x1, x0, x1, lsl 2
	str	x1, [x22, #:lo12:.LANCHOR97]
	mov	w1, 0
	bl	ftl_memset
	mov	w1, 0
	mov	w2, 16384
	adrp	x0, ftl_ext_info_data_buffer
	add	x0, x0, :lo12:ftl_ext_info_data_buffer
	bl	ftl_memset
	adrp	x25, .LANCHOR117
	ldr	x1, [x23, #:lo12:.LANCHOR20]
	add	x0, x21, :lo12:.LANCHOR167
	mov	w27, 21574
	add	x26, x26, :lo12:.LANCHOR103
	add	x25, x25, :lo12:.LANCHOR117
	mov	x19, 7
	strb	wzr, [x0, 1]
	movk	w27, 0x494c, lsl 16
	ldrb	w1, [x1, 40]
	strb	w1, [x21, #:lo12:.LANCHOR167]
	strh	wzr, [x0, 2]
.L2114:
	ldr	x1, [x23, #:lo12:.LANCHOR20]
	add	w0, w19, 8
	sxth	w24, w19
	mov	w28, w19
	add	x0, x1, x0, sxtw
	ldrb	w0, [x0, 32]
	cmp	w0, 255
	bne	.L2113
.L2118:
	sub	x19, x19, #1
	cmn	x19, #1
	bne	.L2114
	mov	w24, 0
.L2115:
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2119
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	mov	w2, 4800
	mov	w1, w19
	ldr	w3, [x0]
	adrp	x0, .LC122
	add	x0, x0, :lo12:.LC122
	bl	printf
.L2119:
	cmn	w19, #1
	bne	.L2120
	mov	w1, 0
	mov	w2, 16384
	add	x0, x20, :lo12:ftl_info_data_buffer
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	mov	w1, 21574
	movk	w1, 0x494c, lsl 16
	str	w1, [x0]
	mov	w0, w19
.L2112:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2113:
	ldrh	w6, [x26]
	add	x8, x20, :lo12:ftl_info_data_buffer
	ldrb	w4, [x25]
	adrp	x7, .LANCHOR166
	add	x7, x7, :lo12:.LANCHOR166
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
	bne	.L2116
	ldrb	w4, [x25]
	mov	x3, x7
	mov	x2, x8
	add	w1, w6, 1
	mov	w0, 0
	bl	ftl_read_page
	mov	w5, w0
.L2116:
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2117
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	mov	w2, w5
	str	w5, [x29, 124]
	mov	w3, 580
	mov	w1, w28
	ldr	w4, [x0]
	adrp	x0, .LC121
	add	x0, x0, :lo12:.LC121
	bl	printf
	ldr	w5, [x29, 124]
.L2117:
	cmn	w5, #1
	beq	.L2118
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L2118
	mov	w19, w24
	b	.L2115
.L2120:
	ldr	x1, [x23, #:lo12:.LANCHOR20]
	add	w0, w24, 8
	add	x20, x20, :lo12:ftl_info_data_buffer
	mov	w4, 4
	mov	x2, x20
	adrp	x26, .LANCHOR117
	add	x0, x1, x0, sxtw
	mov	w27, 21574
	add	x26, x26, :lo12:.LANCHOR117
	movk	w27, 0x494c, lsl 16
	ldrb	w1, [x0, 32]
	add	x0, x21, :lo12:.LANCHOR167
	strb	w1, [x21, #:lo12:.LANCHOR167]
	strb	w24, [x0, 1]
	adrp	x24, .LANCHOR166
	add	x24, x24, :lo12:.LANCHOR166
	mov	w0, 0
	mov	x3, x24
	bl	flash_get_last_written_page
	sxth	w23, w0
	add	w0, w0, 1
	and	w19, w0, 65535
	adrp	x0, .LANCHOR103
	ldrb	w25, [x21, #:lo12:.LANCHOR167]
	ldrh	w0, [x0, #:lo12:.LANCHOR103]
	madd	w25, w25, w0, w23
.L2122:
	tbnz	w23, #31, .L2127
	ldrb	w4, [x26]
	mov	x3, x24
	mov	x2, x20
	mov	w1, w25
	mov	w0, 0
	bl	ftl_read_page
	cmn	w0, #1
	beq	.L2123
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L2123
.L2127:
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	add	x21, x21, :lo12:.LANCHOR167
	strh	w19, [x21, 2]
	ldr	w1, [x0, 16]
	cmp	w1, 2048
	bhi	.L2124
.L2125:
	ldr	w1, [x0, 24]
	cmp	w1, 2048
	bls	.L2128
	ldr	w2, [x0, 28]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 24]
.L2128:
	ldr	w1, [x0, 32]
	cmp	w1, 1024
	bls	.L2129
	ldr	w2, [x0, 36]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 32]
.L2129:
	ldr	w1, [x0, 40]
	cmp	w1, 1024
	bls	.L2130
	ldr	w2, [x0, 44]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 40]
.L2130:
	ldr	w1, [x0, 64]
	add	w1, w1, 1
	str	w1, [x0, 64]
	mov	w0, 0
	bl	ftl_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	mov	w0, 0
	b	.L2112
.L2123:
	sub	w23, w23, #1
	sub	w25, w25, #1
	sxth	w23, w23
	b	.L2122
.L2124:
	ldr	w2, [x0, 20]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 16]
	b	.L2125
	.size	ftl_info_blk_init, .-ftl_info_blk_init
	.section	.text.ftl_ext_info_flush,"ax",@progbits
	.align	2
	.global	ftl_ext_info_flush
	.type	ftl_ext_info_flush, %function
ftl_ext_info_flush:
	stp	x29, x30, [sp, -96]!
	adrp	x0, .LANCHOR5
	add	x29, sp, 0
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldr	w1, [x0, 520]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbz	w1, .L2146
	str	wzr, [x0, 520]
.L2146:
	adrp	x20, .LANCHOR80
	adrp	x22, .LANCHOR172
	adrp	x21, .LANCHOR96
	add	x20, x20, :lo12:.LANCHOR80
	add	x22, x22, :lo12:.LANCHOR172
	add	x21, x21, :lo12:.LANCHOR96
	mov	w0, 0
	bl	ftl_total_vpn_update
.L2147:
	adrp	x23, .LANCHOR97
	mov	x24, x23
.L2150:
	ldr	x0, [x23, #:lo12:.LANCHOR97]
	ldr	w1, [x0, 56]
	add	w1, w1, 1
	str	w1, [x0, 56]
	ldrh	w1, [x0, 140]
	ldrh	w0, [x20]
	cmp	w1, w0
	bcc	.L2148
	bl	ftl_ext_alloc_new_blk
.L2148:
	ldr	x0, [x24, #:lo12:.LANCHOR97]
	ldrh	w1, [x0, 130]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2149
	adrp	x0, .LC0
	mov	w2, 1639
	mov	x1, x22
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2149:
	ldr	x1, [x24, #:lo12:.LANCHOR97]
	mov	w19, 21
	ldrh	w0, [x21]
	adrp	x26, .LANCHOR117
	adrp	x27, .LANCHOR166
	add	x25, x27, :lo12:.LANCHOR166
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
	ldrb	w2, [x26, #:lo12:.LANCHOR117]
	mov	x0, x25
	and	w19, w19, 65535
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x0, [x24, #:lo12:.LANCHOR97]
	mov	w1, w19
	ldrb	w4, [x26, #:lo12:.LANCHOR117]
	mov	x3, x25
	str	wzr, [x27, #:lo12:.LANCHOR166]
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
	beq	.L2150
	cmn	w0, #1
	adrp	x0, .LANCHOR171
	beq	.L2151
	ldrb	w1, [x0, #:lo12:.LANCHOR171]
	cbz	w1, .L2152
.L2151:
	strb	wzr, [x0, #:lo12:.LANCHOR171]
	b	.L2147
.L2152:
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
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR97
	strh	wzr, [x0, #:lo12:.LANCHOR113]
	ldr	x0, [x23, #:lo12:.LANCHOR97]
	stp	x19, x20, [sp, 16]
	mov	w19, 1
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR166
	stp	x21, x22, [sp, 32]
	adrp	x26, ftl_ext_info_data_buffer
	ldrh	w20, [x0, 130]
	adrp	x0, .LANCHOR96
	stp	x27, x28, [sp, 80]
	add	x3, x25, :lo12:.LANCHOR166
	ldrh	w1, [x0, #:lo12:.LANCHOR96]
	mov	w0, 21
	add	x2, x26, :lo12:ftl_ext_info_data_buffer
	sub	w0, w0, w1
	lsl	w19, w19, w0
	sub	w19, w19, #1
	and	w19, w19, w20
	asr	w20, w20, w0
	and	w20, w20, 255
	mov	w1, w19
	mov	w0, w20
	bl	flash_get_last_written_page
	sxth	w22, w0
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2163
	adrp	x1, .LANCHOR173
	adrp	x0, .LC66
	mov	w3, w22
	mov	w2, 1683
	add	x1, x1, :lo12:.LANCHOR173
	add	x0, x0, :lo12:.LC66
	bl	printf
.L2163:
	adrp	x27, .LANCHOR117
	adrp	x28, .LANCHOR103
	mov	w5, 20038
	add	x27, x27, :lo12:.LANCHOR117
	add	x28, x28, :lo12:.LANCHOR103
	mov	w24, 0
	movk	w5, 0x4549, lsl 16
.L2164:
	and	w21, w22, 65535
	sub	w0, w21, w24
	tbnz	x0, 15, .L2169
	ldrh	w0, [x28]
	sub	w1, w22, w24
	ldrb	w4, [x27]
	add	x3, x25, :lo12:.LANCHOR166
	str	w5, [x29, 108]
	add	x2, x26, :lo12:ftl_ext_info_data_buffer
	madd	w1, w0, w19, w1
	mov	w0, w20
	bl	flash_read_page_en
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	ldr	w5, [x29, 108]
	beq	.L2165
	adrp	x0, .LANCHOR5
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldr	w0, [x0]
	cmp	w0, w5
	bne	.L2165
.L2169:
	bl	zftl_sblk_list_init
	ldr	x0, [x23, #:lo12:.LANCHOR97]
	ldrh	w1, [x0, 140]
	cmp	w1, w22
	bgt	.L2167
	add	w21, w21, 1
	strh	w21, [x0, 140]
	bl	ftl_ext_info_flush
.L2167:
	adrp	x0, .LANCHOR5
	mov	w1, -1
	ldp	x19, x20, [sp, 16]
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	str	wzr, [x0, 520]
	str	wzr, [x0, 604]
	str	wzr, [x0, 608]
	adrp	x0, .LANCHOR114
	strh	w1, [x0, #:lo12:.LANCHOR114]
	mov	w0, 0
	ldp	x29, x30, [sp], 112
	ret
.L2165:
	add	w24, w24, 1
	b	.L2164
	.size	ftl_ext_info_init, .-ftl_ext_info_init
	.section	.text.ftl_low_format,"ax",@progbits
	.align	2
	.global	ftl_low_format
	.type	ftl_low_format, %function
ftl_low_format:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR174
	stp	x21, x22, [sp, 32]
	add	x20, x20, :lo12:.LANCHOR174
	stp	x25, x26, [sp, 64]
	adrp	x22, .LANCHOR20
	mov	x25, x22
	stp	x23, x24, [sp, 48]
	mov	w19, 8
	adrp	x23, .LC0
.L2180:
	ldr	x0, [x22, #:lo12:.LANCHOR20]
	add	x0, x0, x19, sxtw
	ldrb	w21, [x0, 32]
	add	w0, w21, 127
	and	w0, w0, 255
	cmp	w0, 125
	bhi	.L2178
	mov	w2, 1854
	mov	x1, x20
	add	x0, x23, :lo12:.LC0
	bl	printf
.L2178:
	cmp	w21, 255
	beq	.L2179
	adrp	x0, .LANCHOR103
	ldrh	w1, [x0, #:lo12:.LANCHOR103]
	mov	w0, 0
	mul	w1, w1, w21
	bl	flash_erase_block
.L2179:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L2180
	bl	sblk_init
	adrp	x19, .LANCHOR97
	bl	ftl_info_blk_init
	adrp	x22, .LANCHOR3
	mov	w1, 0
	mov	w2, 16384
	adrp	x0, ftl_info_data_buffer
	add	x0, x0, :lo12:ftl_info_data_buffer
	bl	ftl_memset
	adrp	x20, .LANCHOR2
	ldr	x3, [x19, #:lo12:.LANCHOR97]
	mov	w5, 1
	ldr	x1, [x22, #:lo12:.LANCHOR3]
	ldrh	w4, [x20, #:lo12:.LANCHOR2]
	ldrh	w0, [x3, 134]
	add	x1, x1, x0, uxth 2
.L2181:
	cmp	w0, w4
	bcc	.L2182
	mov	w0, 21574
	adrp	x24, .LANCHOR60
	add	x24, x24, :lo12:.LANCHOR60
	movk	w0, 0x494c, lsl 16
	strh	wzr, [x3, 148]
	mov	w21, 0
	mov	w26, 1
	str	w0, [x3]
.L2183:
	ldrh	w0, [x20, #:lo12:.LANCHOR2]
	adrp	x23, .LANCHOR95
	cmp	w0, w21
	bhi	.L2191
	adrp	x21, .LANCHOR5
	mov	w2, 16384
	mov	w1, 0
	adrp	x0, ftl_ext_info_data_buffer
	add	x0, x0, :lo12:ftl_ext_info_data_buffer
	bl	ftl_memset
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	mov	w1, 20038
	ldr	x6, [x19, #:lo12:.LANCHOR97]
	movk	w1, 0x4549, lsl 16
	mov	w4, 3
	mov	w10, 15
	ldrh	w3, [x6, 148]
	str	w1, [x0]
	ldr	x0, [x25, #:lo12:.LANCHOR20]
	ldrb	w2, [x23, #:lo12:.LANCHOR95]
	ldr	x1, [x22, #:lo12:.LANCHOR3]
	cmp	w2, 1
	and	w8, w2, 65535
	ldrb	w0, [x0, 47]
	csinc	w4, w4, wzr, ne
	and	w4, w4, 255
	udiv	w0, w0, w2
	and	w5, w0, 65535
	ubfiz	x0, x0, 2, 8
	add	x0, x0, 4
	add	w24, w5, 1
	add	x0, x1, x0
.L2194:
	cmp	w2, 4
	add	x1, x1, 4
	csel	w7, w10, w4, eq
	strb	w7, [x1, -1]
	ldrb	w7, [x1, -2]
	orr	w7, w7, -32
	strb	w7, [x1, -2]
	cmp	x1, x0
	bne	.L2194
	mul	w5, w5, w8
	mov	w4, 16
	add	w0, w8, w3
	sdiv	w4, w4, w2
	add	w0, w5, w0, uxth
	strh	w0, [x6, 148]
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	add	w4, w24, w4
	and	w4, w4, 65535
	strh	w4, [x6, 134]
	tbz	x0, 12, .L2195
	adrp	x0, .LC123
	mov	w3, w24
	mov	w2, 128
	mov	w1, 1901
	add	x0, x0, :lo12:.LC123
	bl	printf
.L2195:
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	mov	w2, 128
	mov	w1, 255
	add	x0, x0, 160
	bl	ftl_memset
	ldrb	w6, [x23, #:lo12:.LANCHOR95]
	adrp	x0, .LANCHOR104
	ldr	x11, [x22, #:lo12:.LANCHOR3]
	adrp	x22, .LANCHOR96
	ldr	x8, [x19, #:lo12:.LANCHOR97]
	and	w7, w6, 65535
	ldrb	w12, [x0, #:lo12:.LANCHOR104]
	mov	w2, 21
	ldrh	w0, [x22, #:lo12:.LANCHOR96]
	mov	w23, 0
	mul	w1, w24, w7
	sub	w0, w2, w0
	ldrh	w10, [x8, 134]
	mov	w2, 1
	and	w1, w1, 65535
	lsl	w2, w2, w0
	and	w2, w2, 65535
.L2196:
	cmp	w24, w10
	bcc	.L2202
	adrp	x0, .LANCHOR4
	ldrh	w2, [x20, #:lo12:.LANCHOR2]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	lsl	w2, w2, 1
	bl	ftl_memset
	bl	zftl_sblk_list_init
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	ldrh	w1, [x20, #:lo12:.LANCHOR2]
	ldrh	w2, [x0, 134]
	strh	w23, [x0, 112]
	sub	w1, w1, w2
	strh	wzr, [x0, 114]
	strh	w1, [x0, 116]
	strh	wzr, [x0, 118]
	mov	w0, 1
	bl	ftl_alloc_sblk
	mov	w23, w0
	mov	w1, 0
	bl	ftl_erase_sblk
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	mov	w0, w23
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	ldrh	w20, [x0, 672]
	strh	wzr, [x0, 690]
	mov	w0, 65533
	sub	w1, w20, #1
	cmp	w0, w1, uxth
	bcs	.L2203
	adrp	x1, .LANCHOR174
	adrp	x0, .LC0
	mov	w2, 1932
	add	x1, x1, :lo12:.LANCHOR174
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2203:
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	mov	w2, 256
	mov	w1, 255
	add	x0, x0, 416
	strh	wzr, [x0, 280]
	bl	ftl_memset
	ldrh	w2, [x22, #:lo12:.LANCHOR96]
	mov	w1, 21
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	sub	w1, w1, w2
	asr	w1, w20, w1
	strh	w1, [x0, 694]
	mov	w1, 1
	strh	w1, [x0, 688]
	adrp	x1, .LANCHOR175
	strh	w20, [x0, 692]
	ldrh	w1, [x1, #:lo12:.LANCHOR175]
	strh	w23, [x0, 416]
	strh	w1, [x0, 698]
	bl	ftl_alloc_sys_blk
	mov	w20, w0
	mov	w1, 0
	bl	ftl_erase_phy_blk
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	mov	w1, 2
	strh	w20, [x0, 130]
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	add	x0, x0, 16
	bl	ftl_open_sblk_init
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	mov	w1, 3
	add	x0, x0, 48
	bl	ftl_open_sblk_init
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	add	x0, x0, 136
	ldrh	w2, [x1, 134]
	strh	w2, [x0, -10]
	mov	w2, -1
	strh	wzr, [x0, -12]
	strh	w2, [x0, -56]
	strh	w2, [x0, -6]
	mov	w2, -1
	strh	wzr, [x0, -16]
	str	w2, [x0, 408]
	strh	wzr, [x0, -14]
	strh	w2, [x1, 126]
	mov	w2, 256
	mov	w1, 255
	bl	ftl_memset
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	mov	w2, 128
	mov	w1, 255
	add	x0, x0, 392
	bl	ftl_memset
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	ftl_info_blk_init
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2182:
	ldrb	w2, [x1, 2]
	add	w0, w0, 1
	and	w0, w0, 65535
	add	x1, x1, 4
	and	w2, w2, 31
	bfi	w2, w5, 3, 2
	strb	w2, [x1, -2]
	b	.L2181
.L2191:
	strh	w21, [x24]
	mov	w0, w21
	bl	ftl_test_block
	ldrb	w11, [x23, #:lo12:.LANCHOR95]
	adrp	x0, .LANCHOR104
	ldr	x6, [x22, #:lo12:.LANCHOR3]
	mov	w7, 0
	ldrb	w14, [x0, #:lo12:.LANCHOR104]
	mov	w10, 0
	ldr	x13, [x19, #:lo12:.LANCHOR97]
	mov	w8, 0
	mul	w12, w21, w11
	add	x6, x6, x21, uxth 2
.L2184:
	cmp	w8, w14
	bcs	.L2188
	add	w15, w11, w7
	b	.L2189
.L2187:
	add	w1, w7, w12
	mov	w0, w8
	bl	flash_check_bad_block
	cbz	w0, .L2185
	ldrb	w1, [x6, 3]
	lsl	w0, w26, w7
	orr	w0, w0, w1
	strb	w0, [x6, 3]
	ldrh	w0, [x13, 148]
	add	w0, w0, 1
	strh	w0, [x13, 148]
.L2186:
	add	w7, w7, 1
.L2189:
	cmp	w7, w15
	bne	.L2187
	add	w8, w8, 1
	sub	w12, w12, w11
	and	w8, w8, 65535
	b	.L2184
.L2185:
	add	w10, w10, 1
	and	w10, w10, 65535
	b	.L2186
.L2188:
	cbnz	w10, .L2190
	ldrb	w0, [x6, 2]
	orr	w0, w0, -32
	strb	w0, [x6, 2]
.L2190:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L2183
.L2202:
	add	x13, x11, x24, uxth 2
	mov	w14, 0
	mov	w15, 0
	mov	w3, 0
	ldrb	w0, [x13, 2]
	orr	w0, w0, -32
	strb	w0, [x13, 2]
.L2197:
	cmp	w3, w12
	bcc	.L2205
	add	w24, w24, 1
	add	w1, w7, w1
	and	w24, w24, 65535
	and	w1, w1, 65535
	b	.L2196
.L2200:
	ldrb	w5, [x13, 3]
	add	w16, w15, w4
	asr	w5, w5, w16
	tbnz	x5, 0, .L2198
	cmp	w6, 1
	bls	.L2204
	and	w0, w0, 1
	add	w0, w1, w0
	and	w0, w0, 65535
.L2199:
	add	x5, x8, x23, sxtw 1
	add	w23, w23, 1
	and	w23, w23, 65535
	add	w0, w0, w14
	strh	w0, [x5, 160]
.L2198:
	add	x4, x4, 1
.L2201:
	and	w0, w4, 65535
	cmp	w0, w7
	bcc	.L2200
	add	w3, w3, 1
	add	w0, w2, w14
	and	w3, w3, 65535
	add	w15, w15, w6
	and	w14, w0, 65535
	b	.L2197
.L2204:
	mov	w0, w1
	b	.L2199
.L2205:
	mov	x4, 0
	b	.L2201
	.size	ftl_low_format, .-ftl_low_format
	.section	.text.ftl_re_low_format_test,"ax",@progbits
	.align	2
	.global	ftl_re_low_format_test
	.type	ftl_re_low_format_test, %function
ftl_re_low_format_test:
	stp	x29, x30, [sp, -64]!
	mov	w1, 1
	adrp	x0, .LC124
	add	x0, x0, :lo12:.LC124
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR97
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR2
	str	x23, [sp, 48]
	bl	printf
	bl	sblk_init
	bl	ftl_info_blk_init
	bl	ftl_ext_info_init
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	adrp	x3, .LANCHOR3
	ldrh	w2, [x21, #:lo12:.LANCHOR2]
	mov	w4, 0
	ldr	x3, [x3, #:lo12:.LANCHOR3]
	mov	w5, 0
	mov	w6, 0
	ldrh	w1, [x0, 134]
	add	x3, x3, x1, uxth 2
.L2216:
	cmp	w1, w2
	bcc	.L2220
	adrp	x23, .LANCHOR4
	strh	w6, [x0, 114]
	strh	w5, [x0, 118]
	lsl	w2, w2, 1
	strh	w4, [x0, 116]
	mov	w1, 0
	strh	wzr, [x0, 122]
	strh	wzr, [x0, 120]
	strh	wzr, [x0, 124]
	ldr	x0, [x23, #:lo12:.LANCHOR4]
	bl	ftl_memset
	bl	zftl_sblk_list_init
	mov	w0, 1
	bl	ftl_alloc_sblk
	mov	w1, 0
	mov	w22, w0
	bl	ftl_erase_sblk
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	mov	w0, w22
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	ldrh	w20, [x0, 672]
	strh	wzr, [x0, 690]
	mov	w0, 65533
	sub	w1, w20, #1
	cmp	w0, w1, uxth
	bcs	.L2221
	adrp	x1, .LANCHOR176
	adrp	x0, .LC0
	mov	w2, 2004
	add	x1, x1, :lo12:.LANCHOR176
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2221:
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
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	lsr	w1, w20, 14
	and	w20, w20, 16383
	ldrh	w2, [x21, #:lo12:.LANCHOR2]
	strh	w1, [x0, 694]
	mov	w1, 1
	strh	w1, [x0, 688]
	adrp	x1, .LANCHOR175
	strh	w20, [x0, 692]
	adrp	x20, .LANCHOR5
	ldrh	w1, [x1, #:lo12:.LANCHOR175]
	lsl	w2, w2, 1
	strh	w22, [x0, 416]
	strh	w1, [x0, 698]
	mov	w1, 0
	ldr	x0, [x23, #:lo12:.LANCHOR4]
	bl	ftl_memset
	ldr	x0, [x20, #:lo12:.LANCHOR5]
	mov	w1, 2
	add	x0, x0, 16
	bl	ftl_open_sblk_init
	ldr	x0, [x20, #:lo12:.LANCHOR5]
	mov	w1, 3
	add	x0, x0, 48
	bl	ftl_open_sblk_init
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	ldr	x0, [x20, #:lo12:.LANCHOR5]
	add	x0, x0, 136
	ldrh	w2, [x1, 134]
	strh	w2, [x0, -10]
	mov	w2, -1
	strh	wzr, [x0, -12]
	strh	w2, [x0, -56]
	strh	w2, [x0, -6]
	mov	w2, -1
	strh	wzr, [x0, -16]
	str	w2, [x0, 408]
	strh	wzr, [x0, -14]
	strh	w2, [x1, 126]
	mov	w2, 256
	mov	w1, 255
	bl	ftl_memset
	ldr	x0, [x20, #:lo12:.LANCHOR5]
	mov	w2, 128
	mov	w1, 255
	add	x0, x0, 392
	bl	ftl_memset
	ldr	x0, [x20, #:lo12:.LANCHOR5]
	str	wzr, [x0, 520]
	str	wzr, [x0, 524]
	str	wzr, [x0, 528]
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	ftl_info_blk_init
	ldr	x23, [sp, 48]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L2220:
	ldrb	w7, [x3, 2]
	and	w8, w7, 31
	strb	w8, [x3, 2]
	ands	w7, w7, 24
	bne	.L2217
	add	w6, w6, 1
	and	w6, w6, 65535
.L2218:
	add	w1, w1, 1
	add	x3, x3, 4
	and	w1, w1, 65535
	b	.L2216
.L2217:
	cmp	w7, 16
	bne	.L2219
	add	w5, w5, 1
	and	w5, w5, 65535
	b	.L2218
.L2219:
	add	w4, w4, 1
	and	w4, w4, 65535
	b	.L2218
	.size	ftl_re_low_format_test, .-ftl_re_low_format_test
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
	bne	.L2226
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
	beq	.L2227
	ldrh	w0, [x19]
	add	x20, x20, x22, uxth 2
	bl	ftl_vpn_decrement
	adrp	x0, .LANCHOR155
	mov	w1, 15555
	add	x6, x0, :lo12:.LANCHOR155
	movk	w1, 0xf55f, lsl 16
	str	w1, [x0, #:lo12:.LANCHOR155]
	adrp	x0, .LANCHOR80
	ldrh	w1, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR72
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	mul	w1, w1, w0
	mov	x0, x20
	lsl	w1, w1, 2
	bl	js_hash
	stp	w0, wzr, [x6, 4]
	adrp	x0, .LANCHOR117
	mov	x2, x6
	mov	x1, x20
	ldrb	w3, [x0, #:lo12:.LANCHOR117]
	mov	w0, w21
	str	wzr, [x6, 12]
	bl	ftl_prog_ppa_page
.L2227:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L2226:
	mov	w0, -1
	ret
	.size	ftl_write_last_log_page, .-ftl_write_last_log_page
	.section	.text.ftl_open_sblk_recovery,"ax",@progbits
	.align	2
	.global	ftl_open_sblk_recovery
	.type	ftl_open_sblk_recovery, %function
ftl_open_sblk_recovery:
	sub	sp, sp, #192
	stp	x29, x30, [sp, 48]
	add	x29, sp, 48
	stp	x21, x22, [sp, 80]
	adrp	x22, .LANCHOR7
	stp	x27, x28, [sp, 128]
	mov	x28, x0
	ldr	w0, [x22, #:lo12:.LANCHOR7]
	stp	x25, x26, [sp, 112]
	mov	x25, x1
	stp	x19, x20, [sp, 64]
	stp	x23, x24, [sp, 96]
	tbz	x0, 12, .L2233
	ldrh	w1, [x28, 2]
	adrp	x0, .LC125
	add	x0, x0, :lo12:.LC125
	bl	printf
.L2233:
	ldr	w0, [x22, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2234
	ldrb	w1, [x28, 5]
	adrp	x0, .LC126
	add	x0, x0, :lo12:.LC126
	bl	printf
.L2234:
	ldr	w0, [x22, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2235
	ldrh	w1, [x28]
	adrp	x0, .LC127
	add	x0, x0, :lo12:.LC127
	bl	printf
.L2235:
	ldr	w0, [x22, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2236
	ldrh	w2, [x28, 18]
	adrp	x0, .LC128
	ldrh	w1, [x28, 16]
	add	x0, x0, :lo12:.LC128
	bl	printf
.L2236:
	ldrh	w0, [x28, 10]
	adrp	x26, .LANCHOR117
	strh	w0, [x28, 14]
	mov	w27, 0
	mov	w0, 1
	adrp	x23, .LANCHOR80
	bl	buf_alloc
	ldrb	w20, [x28, 5]
	ldrh	w21, [x28, 2]
	mov	x19, x0
	add	x0, x26, :lo12:.LANCHOR117
	str	x0, [x29, 128]
.L2237:
	ldrh	w0, [x23, #:lo12:.LANCHOR80]
	cmp	w0, w21
	bhi	.L2251
.L2240:
	ldrh	w0, [x28, 10]
	ldrh	w1, [x28, 6]
	ldrh	w2, [x23, #:lo12:.LANCHOR80]
	add	w1, w1, w0
	ldrb	w0, [x28, 9]
	strh	w21, [x28, 2]
	strb	w20, [x28, 5]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L2252
	adrp	x1, .LANCHOR177
	adrp	x0, .LC0
	mov	w2, 1365
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2252:
	adrp	x21, .LANCHOR109
	ldrh	w3, [x28, 10]
	mov	w0, 0
	mov	w1, 0
	ldr	x4, [x21, #:lo12:.LANCHOR109]
.L2253:
	cmp	w1, w3
	bcc	.L2255
	ldrb	w20, [x28, 9]
	adrp	x24, .LANCHOR4
	ldrh	w1, [x23, #:lo12:.LANCHOR80]
	madd	w20, w20, w1, w0
	ldr	w0, [x22, #:lo12:.LANCHOR7]
	sub	w20, w20, w3
	and	w20, w20, 65535
	tbz	x0, 12, .L2256
	ldrh	w1, [x28]
	ldr	x2, [x24, #:lo12:.LANCHOR4]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC130
	mov	w2, w20
	add	x0, x0, :lo12:.LC130
	bl	printf
.L2256:
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	adrp	x25, .LANCHOR117
	ldrh	w1, [x28]
	adrp	x24, .LANCHOR72
	adrp	x26, .LC131
	add	x24, x24, :lo12:.LANCHOR72
	add	x25, x25, :lo12:.LANCHOR117
	add	x26, x26, :lo12:.LC131
	strh	w20, [x0, x1, lsl 1]
	mov	w20, 0
	mov	x0, x19
	bl	buf_free
.L2257:
	ldrb	w0, [x24]
	cmp	w20, w0, lsl 1
	bcc	.L2260
	ldrh	w1, [x28, 12]
	ldrh	w0, [x23, #:lo12:.LANCHOR80]
	ldrb	w2, [x28, 9]
	madd	w0, w0, w2, w1
	mov	x1, -4
	add	x0, x1, x0, sxtw 2
	ldr	x1, [x21, #:lo12:.LANCHOR109]
	ldr	w0, [x1, x0]
	cmn	w0, #1
	beq	.L2261
	adrp	x1, .LANCHOR177
	adrp	x0, .LC0
	mov	w2, 1395
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2261:
	ldrh	w0, [x28, 6]
	cmp	w0, 1
	bne	.L2232
	ldp	x19, x20, [sp, 64]
	mov	x0, x28
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 192
	b	ftl_write_last_log_page
.L2251:
	ldrb	w20, [x28, 5]
	adrp	x0, .LANCHOR103
	add	x0, x0, :lo12:.LANCHOR103
	str	x0, [x29, 136]
.L2238:
	ldrb	w0, [x28, 9]
	cmp	w0, w20
	bhi	.L2250
	add	w21, w21, 1
	strb	wzr, [x28, 5]
	and	w21, w21, 65535
	b	.L2237
.L2250:
	add	x0, x28, x20, sxtw 1
	ldrh	w11, [x0, 16]
	mov	w0, 65535
	cmp	w11, w0
	beq	.L2239
	ldr	x0, [x29, 136]
	ldrb	w3, [x26, #:lo12:.LANCHOR117]
	ldr	x1, [x19, 8]
	ldr	x2, [x19, 24]
	ldrh	w10, [x0]
	madd	w10, w10, w11, w21
	stp	w11, w10, [x29, 116]
	mov	w0, w10
	bl	ftl_read_ppa_page
	mov	w24, w0
	cmp	w0, 512
	beq	.L2240
	cmn	w0, #1
	ldp	w11, w10, [x29, 116]
	beq	.L2241
	ldr	x0, [x19, 24]
	ldr	w1, [x0]
	cmn	w1, #1
	bne	.L2241
	ldr	w0, [x0, 4]
	cmn	w0, #1
	bne	.L2241
	ldr	x0, [x19, 8]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L2240
.L2241:
	ldr	w0, [x22, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2242
	ldr	x1, [x19, 24]
	mov	w4, w24
	ldr	x0, [x19, 8]
	mov	w3, w10
	ldr	w2, [x1, 12]
	str	w2, [sp, 32]
	ldr	w2, [x1, 8]
	str	w2, [sp, 24]
	ldr	w2, [x1, 4]
	str	w2, [sp, 16]
	mov	w2, w21
	ldr	w1, [x1]
	str	w1, [sp, 8]
	ldr	w1, [x0, 12]
	str	w1, [sp]
	mov	w1, w11
	ldp	w5, w6, [x0]
	ldr	w7, [x0, 8]
	adrp	x0, .LC129
	add	x0, x0, :lo12:.LC129
	bl	printf
.L2242:
	adrp	x0, .LANCHOR170
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR170]
	ldrb	w0, [x28, 9]
	ldrh	w1, [x28, 10]
	madd	w0, w0, w21, w20
	cmp	w1, w0
	beq	.L2243
	adrp	x1, .LANCHOR177
	adrp	x0, .LC0
	mov	w2, 1288
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2243:
	ldrh	w0, [x28, 10]
	ldrh	w1, [x28, 6]
	ldrb	w2, [x28, 9]
	add	w1, w1, w0
	ldrh	w0, [x23, #:lo12:.LANCHOR80]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L2244
	adrp	x1, .LANCHOR177
	adrp	x0, .LC0
	mov	w2, 1289
	add	x1, x1, :lo12:.LANCHOR177
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2244:
	cmn	w24, #1
	beq	.L2246
	ldr	x0, [x19, 24]
	ldr	w0, [x0, 4]
	cmn	w0, #1
	beq	.L2246
	bl	lpa_hash_get_ppa
	cbz	x25, .L2248
	ldr	x3, [x19, 24]
	ldr	w1, [x3, 8]
	cmp	w0, w1
	beq	.L2248
	cmn	w0, #1
	beq	.L2248
	adrp	x4, .LANCHOR96
	mov	w27, 21
	mov	w24, 1
	ldrh	w5, [x4, #:lo12:.LANCHOR96]
	sub	w1, w27, w5
	lsr	w2, w0, w5
	adrp	x5, .LANCHOR95
	lsl	w1, w24, w1
	sub	w1, w1, #1
	and	w1, w1, w2
	ldrb	w2, [x5, #:lo12:.LANCHOR95]
	udiv	w1, w1, w2
	ldrh	w2, [x25]
	cmp	w2, w1, uxth
	bne	.L2248
	ldr	x1, [x29, 128]
	adrp	x6, .LANCHOR166
	ldr	w7, [x3]
	add	x2, x6, :lo12:.LANCHOR166
	str	w7, [x29, 116]
	str	x6, [x29, 120]
	ldrb	w3, [x1]
	ldr	x1, [x19, 8]
	stp	x5, x4, [x29, 96]
	bl	ftl_read_ppa_page
	ldr	x6, [x29, 120]
	ldr	w7, [x29, 116]
	ldr	w0, [x6, #:lo12:.LANCHOR166]
	cmp	w7, w0
	bhi	.L2248
	ldr	x0, [x19, 24]
	ldr	w0, [x0, 8]
	cmn	w0, #1
	beq	.L2246
	ldp	x5, x4, [x29, 96]
	ldrh	w1, [x4, #:lo12:.LANCHOR96]
	sub	w27, w27, w1
	lsr	w0, w0, w1
	lsl	w24, w24, w27
	sub	w24, w24, #1
	and	w24, w24, w0
	ldrb	w0, [x5, #:lo12:.LANCHOR95]
	udiv	w0, w24, w0
	bl	ftl_vpn_decrement
.L2246:
	ldrh	w0, [x28, 6]
	mov	w27, 1
	sub	w0, w0, #1
	strh	w0, [x28, 6]
	ldrh	w0, [x28, 10]
	add	w0, w0, 1
	strh	w0, [x28, 10]
.L2239:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2238
.L2255:
	ldrh	w2, [x28, 12]
	add	w2, w2, w1
	ldr	w2, [x4, x2, lsl 2]
	cmn	w2, #1
	beq	.L2254
	add	w20, w0, 1
	and	w0, w20, 65535
.L2254:
	add	w1, w1, 1
	b	.L2253
.L2260:
	cbz	w27, .L2258
	ldrh	w0, [x28, 6]
	cmp	w0, 1
	bls	.L2258
	mov	x0, x28
	bl	ftl_get_new_free_page
	mov	w4, w0
	ldr	w0, [x22, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2259
	mov	w1, w4
	str	w4, [x29, 136]
	mov	x0, x26
	bl	printf
	ldr	w4, [x29, 136]
.L2259:
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
.L2258:
	add	w20, w20, 1
	b	.L2257
.L2248:
	ldr	x3, [x19, 24]
	adrp	x0, .LANCHOR54
	ldr	w0, [x0, #:lo12:.LANCHOR54]
	ldr	w1, [x3, 4]
	cmp	w1, w0
	bcs	.L2246
	ldrb	w0, [x28, 9]
	ldrh	w1, [x23, #:lo12:.LANCHOR80]
	ldrh	w2, [x28, 10]
	mul	w0, w0, w1
	sub	w0, w0, #1
	cmp	w2, w0
	bge	.L2246
	adrp	x0, .LANCHOR97
	ldr	w1, [x3]
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	ldr	w4, [x0, 8]
	cmp	w1, w4
	bls	.L2249
	str	w1, [x0, 8]
.L2249:
	ldrh	w0, [x28, 12]
	add	w2, w2, w0
	ldp	w0, w1, [x3, 4]
	bl	lpa_hash_update_ppa
	b	.L2246
.L2232:
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 192
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
	adrp	x22, .LANCHOR103
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR97
	mov	x25, x1
	add	x21, x21, :lo12:.LANCHOR80
	mov	x20, x23
	add	x22, x22, :lo12:.LANCHOR103
	mov	w24, 65535
	str	x27, [sp, 80]
.L2314:
	ldr	x0, [x23, #:lo12:.LANCHOR97]
	ldr	w1, [x0, 48]
	ldrh	w2, [x0, 696]
	add	w1, w1, 1
	str	w1, [x0, 48]
	ldrh	w1, [x21]
	cmp	w2, w1
	bcs	.L2315
	ldrh	w0, [x0, 692]
	cmp	w0, w24
	bne	.L2316
.L2315:
	bl	pm_alloc_new_blk
	mov	w0, 0
	bl	ftl_info_flush
.L2316:
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	ldrh	w0, [x0, 692]
	cmp	w0, w24
	bne	.L2317
	adrp	x1, .LANCHOR178
	adrp	x0, .LC0
	mov	w2, 228
	add	x1, x1, :lo12:.LANCHOR178
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2317:
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	adrp	x27, .LANCHOR179
	ldrh	w1, [x22]
	mov	w2, 64
	ldrh	w26, [x0, 692]
	ldrh	w0, [x0, 696]
	madd	w26, w26, w1, w0
	ldr	x0, [x27, #:lo12:.LANCHOR179]
	mov	w1, 0
	bl	ftl_memset
	ldr	x3, [x27, #:lo12:.LANCHOR179]
	mov	x2, x25
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	str	w19, [x3]
	ldr	w1, [x0, 48]
	ldrb	w0, [x0, 694]
	str	w1, [x3, 4]
	adrp	x1, .LANCHOR117
	ldrb	w4, [x1, #:lo12:.LANCHOR117]
	mov	w1, w26
	bl	ftl_prog_page
	ldr	x2, [x20, #:lo12:.LANCHOR97]
	ldrh	w1, [x2, 696]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 696]
	cmp	w1, 1
	adrp	x1, .LANCHOR180
	beq	.L2318
	ldrb	w3, [x1, #:lo12:.LANCHOR180]
	cbz	w3, .L2319
.L2318:
	strb	wzr, [x1, #:lo12:.LANCHOR180]
	b	.L2314
.L2319:
	cmn	w0, #1
	bne	.L2321
	mov	w1, w26
	adrp	x0, .LC132
	add	x0, x0, :lo12:.LC132
	bl	printf
	b	.L2314
.L2321:
	ldrh	w0, [x2, 698]
	cmp	w19, w0
	bcs	.L2322
	add	x19, x2, x19, uxtw 2
	str	w26, [x19, 704]
.L2322:
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
	adrp	x0, .LANCHOR7
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	tbz	x0, 12, .L2328
	adrp	x2, .LANCHOR181
	adrp	x0, .LC73
	add	x2, x2, :lo12:.LANCHOR181
	mov	w1, 251
	add	x0, x0, :lo12:.LC73
	bl	printf
.L2328:
	adrp	x23, .LANCHOR150
	adrp	x20, .LANCHOR20
	mov	w2, 64
	mov	w1, 0
	ldr	x0, [x23, #:lo12:.LANCHOR150]
	adrp	x21, .LANCHOR151
	adrp	x22, .LANCHOR26
	adrp	x24, .LC134
	adrp	x25, .LANCHOR128
	add	x22, x22, :lo12:.LANCHOR26
	add	x24, x24, :lo12:.LC134
	add	x25, x25, :lo12:.LANCHOR128
	bl	ftl_memset
	add	x27, x21, :lo12:.LANCHOR151
	ldr	x1, [x20, #:lo12:.LANCHOR20]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC133
	add	x0, x0, :lo12:.LC133
	mov	w26, 0
	bl	rknand_print_hex
	ldr	x6, [x20, #:lo12:.LANCHOR20]
	add	x0, x6, 16
	ldr	w1, [x6, 8]
	bl	js_hash
	str	w0, [x6, 12]
.L2329:
	add	x28, x21, :lo12:.LANCHOR151
	ldrb	w4, [x21, #:lo12:.LANCHOR151]
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
	blt	.L2330
	ldr	x6, [x20, #:lo12:.LANCHOR20]
	ldrb	w7, [x28, 1]
	strh	wzr, [x28, 2]
	ldr	w0, [x6, 4]
	ldrh	w1, [x6, 16]
	add	w0, w0, 1
	str	w0, [x6, 4]
	ldrb	w0, [x21, #:lo12:.LANCHOR151]
	add	w1, w1, 1
	strb	w0, [x28, 1]
	mov	x0, x6
	strb	w7, [x21, #:lo12:.LANCHOR151]
	strh	w1, [x0, 16]!
	ldr	w1, [x6, 8]
	bl	js_hash
	ldrh	w19, [x22]
	str	w0, [x6, 12]
	mul	w19, w19, w7
.L2339:
	mov	w1, w19
	mov	w0, 0
	bl	flash_erase_block
	b	.L2331
.L2334:
	mov	w26, 1
	b	.L2329
.L2330:
	madd	w19, w19, w4, w3
	cbz	w1, .L2339
.L2331:
	ldr	x2, [x20, #:lo12:.LANCHOR20]
	mov	w1, w19
	ldr	x3, [x23, #:lo12:.LANCHOR150]
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
	bne	.L2332
	mov	w1, w19
	adrp	x0, .LC135
	add	x0, x0, :lo12:.LC135
	bl	printf
	b	.L2329
.L2332:
	cbz	w26, .L2334
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
	adrp	x21, .LANCHOR7
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	tbz	x0, 12, .L2341
	adrp	x2, .LANCHOR182
	adrp	x0, .LC73
	add	x2, x2, :lo12:.LANCHOR182
	mov	w1, 2101
	add	x0, x0, :lo12:.LC73
	bl	printf
.L2341:
	adrp	x22, .LANCHOR9
	adrp	x20, .LANCHOR38
	add	x24, x20, :lo12:.LANCHOR38
	mov	x0, x19
	adrp	x25, .LANCHOR33
	bl	nandc_init
	add	x25, x25, :lo12:.LANCHOR33
	mov	x26, x24
	adrp	x19, .LANCHOR32
	mov	x23, 0
	add	x0, x19, :lo12:.LANCHOR32
	mov	w27, 2
	str	x0, [x22, #:lo12:.LANCHOR9]
	mov	w28, 44
.L2347:
	mov	x1, x24
	mov	w0, w23
	bl	flash_read_id
	strb	w27, [x23, x25]
	cbnz	x23, .L2342
	ldrb	w0, [x26]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 253
	bls	.L2343
.L2345:
	mov	w19, -2
.L2340:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2343:
	ldrb	w0, [x26, 1]
	cmp	w0, 255
	beq	.L2345
.L2342:
	ldrb	w0, [x24]
	cmp	w0, 181
	bne	.L2346
	strb	w28, [x24]
.L2346:
	add	x23, x23, 1
	add	x24, x24, 8
	cmp	x23, 4
	bne	.L2347
	adrp	x0, .LANCHOR183
	add	x8, x0, :lo12:.LANCHOR183
	add	x8, x8, 1
	mov	x7, x0
	add	x12, x20, :lo12:.LANCHOR38
	mov	x10, 0
.L2350:
	ldrb	w2, [x8, -1]
	mov	w11, w10
	lsl	x24, x10, 5
	mov	x1, x12
	mov	x0, x8
	bl	flash_mem_cmp8
	cbnz	w0, .L2348
	add	x0, x7, :lo12:.LANCHOR183
	ubfiz	x11, x11, 5, 32
	add	x24, x0, x24
	add	x0, x0, x11
	adrp	x1, .LANCHOR184
	add	x4, x1, :lo12:.LANCHOR184
	ldrb	w3, [x0, 22]
	mov	x0, 0
.L2349:
	lsl	x5, x0, 5
	mov	w2, w0
	ldrb	w5, [x5, x4]
	cmp	w5, w3
	beq	.L2351
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L2349
	mov	w2, w0
.L2351:
	ubfiz	x0, x2, 5, 32
	add	x1, x1, :lo12:.LANCHOR184
	add	x1, x1, x0
	mov	w2, 32
	adrp	x0, .LANCHOR13
	add	x0, x0, :lo12:.LANCHOR13
	bl	ftl_memcpy
	add	x23, x19, :lo12:.LANCHOR32
	mov	x1, x24
	adrp	x24, .LANCHOR22
	mov	w2, 32
	mov	x0, x23
	bl	ftl_memcpy
	ldrb	w0, [x24, #:lo12:.LANCHOR22]
	cmp	w0, 8
	bhi	.L2352
	ldrb	w1, [x23, 20]
	cmp	w1, 60
	bls	.L2353
	mov	w1, 60
	strb	w1, [x23, 20]
.L2353:
	cmp	w0, 8
	bne	.L2352
	ldrb	w0, [x20, #:lo12:.LANCHOR38]
	cmp	w0, 44
	bne	.L2352
	add	x0, x19, :lo12:.LANCHOR32
	ldrb	w1, [x0, 28]
	cmp	w1, 3
	bne	.L2352
	strb	wzr, [x0, 28]
.L2352:
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2354
	adrp	x2, .LANCHOR182
	adrp	x0, .LC73
	add	x2, x2, :lo12:.LANCHOR182
	mov	w1, 2122
	add	x0, x0, :lo12:.LC73
	bl	printf
.L2354:
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR153
	adrp	x25, .LANCHOR20
	add	x20, x19, :lo12:.LANCHOR32
	adrp	x23, .LANCHOR39
	str	x0, [x1, #:lo12:.LANCHOR153]
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR143
	str	x0, [x1, #:lo12:.LANCHOR143]
	mov	w0, 2048
	bl	ftl_malloc
	str	x0, [x25, #:lo12:.LANCHOR20]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR152
	str	x0, [x1, #:lo12:.LANCHOR152]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR145
	str	x0, [x1, #:lo12:.LANCHOR145]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR150
	str	x0, [x1, #:lo12:.LANCHOR150]
	adrp	x0, .LANCHOR157
	strb	wzr, [x0, #:lo12:.LANCHOR157]
	bl	flash_die_info_init
	ldrb	w0, [x20, 18]
	bl	flash_lsb_page_tbl_build
	ldrb	w0, [x20, 20]
	adrp	x20, .LANCHOR148
	bl	nandc_bch_sel
	str	xzr, [x20, #:lo12:.LANCHOR148]
	ldr	x1, [x22, #:lo12:.LANCHOR9]
	mov	x22, x25
	ldrh	w0, [x1, 16]
	ubfx	x2, x0, 8, 3
	strb	w2, [x23, #:lo12:.LANCHOR39]
	adrp	x2, .LANCHOR185
	ubfx	x3, x0, 3, 1
	strb	w3, [x2, #:lo12:.LANCHOR185]
	adrp	x2, .LANCHOR36
	ubfx	x3, x0, 4, 1
	strb	w3, [x2, #:lo12:.LANCHOR36]
	adrp	x2, .LANCHOR69
	ubfx	x3, x0, 12, 1
	strb	w3, [x2, #:lo12:.LANCHOR69]
	adrp	x2, .LANCHOR102
	ubfx	x3, x0, 13, 1
	ubfx	x0, x0, 14, 1
	strb	w3, [x2, #:lo12:.LANCHOR102]
	adrp	x2, .LANCHOR25
	strb	w0, [x2, #:lo12:.LANCHOR25]
	mov	w2, 60
	ldrb	w0, [x1, 28]
	adrp	x1, .LANCHOR11
	strb	w0, [x1, #:lo12:.LANCHOR11]
	adrp	x1, .LANCHOR10
	strb	w2, [x1, #:lo12:.LANCHOR10]
	ldrb	w2, [x24, #:lo12:.LANCHOR22]
	cmp	w2, 9
	bne	.L2355
	mov	w2, 70
	strb	w2, [x1, #:lo12:.LANCHOR10]
.L2355:
	add	x19, x19, :lo12:.LANCHOR32
	adrp	x1, .LANCHOR158
	adrp	x25, .LANCHOR17
	strb	w0, [x1, #:lo12:.LANCHOR158]
	ldrh	w1, [x19, 16]
	ldrb	w0, [x19, 19]
	strb	w0, [x25, #:lo12:.LANCHOR17]
	tbz	x1, 6, .L2357
	sub	w1, w0, #17
	and	w1, w1, 255
	cmp	w1, 2
	bhi	.L2358
	adrp	x1, micron_read_retrial
	add	x1, x1, :lo12:micron_read_retrial
	str	x1, [x20, #:lo12:.LANCHOR148]
	cmp	w0, 19
	adrp	x0, .LANCHOR146
	beq	.L2359
	mov	w1, 7
.L2402:
	strb	w1, [x0, #:lo12:.LANCHOR146]
	b	.L2357
.L2348:
	add	x10, x10, 1
	add	x8, x8, 32
	cmp	x10, 30
	bne	.L2350
	b	.L2345
.L2359:
	mov	w1, 15
	b	.L2402
.L2358:
	sub	w1, w0, #65
	cmp	w0, 33
	and	w1, w1, 255
	ccmp	w1, 1, 0, ne
	bhi	.L2361
	adrp	x0, toshiba_read_retrial
	add	x0, x0, :lo12:toshiba_read_retrial
	str	x0, [x20, #:lo12:.LANCHOR148]
	adrp	x0, .LANCHOR19
	mov	w1, 4
	strb	w1, [x0, #:lo12:.LANCHOR19]
.L2404:
	mov	w1, 7
	adrp	x0, .LANCHOR146
	b	.L2402
.L2361:
	sub	w2, w0, #34
	sub	w1, w0, #67
	and	w2, w2, 255
	and	w1, w1, 255
	cmp	w2, 1
	ccmp	w1, 1, 0, hi
	bhi	.L2362
	adrp	x2, toshiba_read_retrial
	add	x2, x2, :lo12:toshiba_read_retrial
	str	x2, [x20, #:lo12:.LANCHOR148]
	cmp	w0, 35
	mov	w2, 68
	ccmp	w0, w2, 4, ne
	adrp	x0, .LANCHOR146
	beq	.L2363
	mov	w2, 7
.L2401:
	strb	w2, [x0, #:lo12:.LANCHOR146]
	cmp	w1, 1
	adrp	x0, .LANCHOR19
	bhi	.L2365
	mov	w1, 4
.L2403:
	strb	w1, [x0, #:lo12:.LANCHOR19]
.L2357:
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2366
	adrp	x2, .LANCHOR182
	adrp	x0, .LC73
	add	x2, x2, :lo12:.LANCHOR182
	mov	w1, 2170
	add	x0, x0, :lo12:.LC73
	bl	printf
.L2366:
	adrp	x24, .LANCHOR14
	ldrb	w0, [x23, #:lo12:.LANCHOR39]
	strb	wzr, [x24, #:lo12:.LANCHOR14]
	tbz	x0, 0, .L2367
	mov	w0, 4
	bl	nandc_set_if_mode
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
.L2405:
	bl	nandc_set_if_mode
	bl	flash_info_blk_init
	mov	w19, w0
	cmn	w0, #1
	bne	.L2369
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2340
	adrp	x2, .LANCHOR182
	mov	w1, 2190
	add	x2, x2, :lo12:.LANCHOR182
	adrp	x0, .LC73
	add	x0, x0, :lo12:.LC73
	bl	printf
	b	.L2340
.L2363:
	mov	w2, 17
	b	.L2401
.L2365:
	mov	w1, 5
	b	.L2403
.L2362:
	sub	w0, w0, #36
	and	w0, w0, 255
	cmp	w0, 1
	bhi	.L2357
	adrp	x0, toshiba_3d_read_retrial
	add	x0, x0, :lo12:toshiba_3d_read_retrial
	str	x0, [x20, #:lo12:.LANCHOR148]
	b	.L2404
.L2367:
	mov	w0, 4
	b	.L2405
.L2369:
	ldrb	w0, [x25, #:lo12:.LANCHOR17]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 6
	bhi	.L2370
	adrp	x0, hynix_read_retrial
	add	x0, x0, :lo12:hynix_read_retrial
	str	x0, [x20, #:lo12:.LANCHOR148]
.L2370:
	ldrb	w0, [x23, #:lo12:.LANCHOR39]
	tbz	x0, 2, .L2372
	ldr	x0, [x22, #:lo12:.LANCHOR20]
	ldrb	w0, [x0, 19]
	cbz	w0, .L2372
	adrp	x0, .LANCHOR151
	ldrb	w1, [x0, #:lo12:.LANCHOR151]
	adrp	x0, .LANCHOR26
	ldrh	w0, [x0, #:lo12:.LANCHOR26]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_ddr_para_scan
	ldrb	w0, [x24, #:lo12:.LANCHOR14]
	cbnz	w0, .L2372
	ldr	x0, [x22, #:lo12:.LANCHOR20]
	strb	wzr, [x0, 19]
	bl	flash_info_flush
.L2372:
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2374
	adrp	x2, .LANCHOR182
	adrp	x0, .LC73
	add	x2, x2, :lo12:.LANCHOR182
	mov	w1, 2243
	add	x0, x0, :lo12:.LC73
	bl	printf
.L2374:
	bl	nand_flash_print_info
	mov	w19, 0
	b	.L2340
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
	adrp	x27, .LANCHOR103
	adrp	x28, .LANCHOR117
	mov	x25, x0
	add	x26, x26, :lo12:.LANCHOR80
	add	x27, x27, :lo12:.LANCHOR103
	add	x28, x28, :lo12:.LANCHOR117
	mov	w19, 0
.L2407:
	ldrh	w0, [x26]
	cmp	w0, w19
	bhi	.L2409
	mov	x0, x25
	bl	buf_free
	cbz	w20, .L2410
	adrp	x1, .LANCHOR186
	adrp	x0, .LC0
	mov	w2, 1232
	add	x1, x1, :lo12:.LANCHOR186
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2410:
	mov	w0, w20
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 144
	ret
.L2409:
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
	adrp	x0, .LC129
	add	x0, x0, :lo12:.LC129
	bl	printf
	mov	w3, 32
	mov	w2, 4
	add	x1, x24, 704
	adrp	x0, .LC136
	add	x0, x0, :lo12:.LC136
	bl	rknand_print_hex
	cmp	w22, 512
	ccmn	w22, #1, 4, ne
	csinc	w20, w20, wzr, ne
	b	.L2407
	.size	ftl_sysblk_dump, .-ftl_sysblk_dump
	.section	.text.dump_ftl_info,"ax",@progbits
	.align	2
	.global	dump_ftl_info
	.type	dump_ftl_info, %function
dump_ftl_info:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR48
	add	x29, sp, 0
	ldrb	w1, [x0, #:lo12:.LANCHOR48]
	adrp	x0, .LC137
	stp	x19, x20, [sp, 16]
	add	x0, x0, :lo12:.LC137
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR97
	adrp	x19, .LANCHOR5
	adrp	x20, .LANCHOR80
	bl	printf
	adrp	x21, .LANCHOR2
	adrp	x0, .LANCHOR167
	add	x1, x0, :lo12:.LANCHOR167
	ldrh	w3, [x1, 2]
	ldrb	w2, [x1, 1]
	ldrb	w1, [x0, #:lo12:.LANCHOR167]
	adrp	x0, .LC138
	add	x0, x0, :lo12:.LC138
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR97]
	ldrh	w2, [x0, 140]
	ldrh	w1, [x0, 130]
	adrp	x0, .LC139
	add	x0, x0, :lo12:.LC139
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR5]
	adrp	x0, .LC140
	add	x0, x0, :lo12:.LC140
	ldrh	w5, [x1, 26]
	ldrh	w4, [x1, 22]
	ldrb	w3, [x1, 21]
	ldrh	w2, [x1, 18]
	ldrh	w1, [x1, 16]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR5]
	adrp	x0, .LC141
	add	x0, x0, :lo12:.LC141
	ldrh	w5, [x1, 58]
	ldrh	w4, [x1, 54]
	ldrb	w3, [x1, 53]
	ldrh	w2, [x1, 50]
	ldrh	w1, [x1, 48]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR5]
	adrp	x19, .LANCHOR72
	adrp	x0, .LC142
	add	x0, x0, :lo12:.LC142
	ldrh	w5, [x1, 90]
	ldrh	w4, [x1, 86]
	ldrb	w3, [x1, 85]
	ldrh	w2, [x1, 82]
	ldrh	w1, [x1, 80]
	bl	printf
	ldrb	w0, [x19, #:lo12:.LANCHOR72]
	mov	w2, 4
	ldrh	w3, [x20, #:lo12:.LANCHOR80]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR109
	ldr	x1, [x0, #:lo12:.LANCHOR109]
	adrp	x0, .LC143
	lsl	w3, w3, 1
	add	x0, x0, :lo12:.LC143
	bl	rknand_print_hex
	adrp	x0, .LANCHOR4
	ldrh	w3, [x21, #:lo12:.LANCHOR2]
	mov	w2, 2
	ldr	x1, [x0, #:lo12:.LANCHOR4]
	adrp	x0, .LC144
	add	x0, x0, :lo12:.LC144
	bl	rknand_print_hex
	ldr	x1, [x22, #:lo12:.LANCHOR97]
	mov	w2, 4
	adrp	x0, .LC136
	add	x0, x0, :lo12:.LC136
	add	x1, x1, 704
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	adrp	x0, .LANCHOR3
	ldrh	w3, [x21, #:lo12:.LANCHOR2]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR3]
	adrp	x0, .LC145
	add	x0, x0, :lo12:.LC145
	bl	rknand_print_hex
	mov	w3, 256
	mov	w2, 2
	adrp	x1, .LANCHOR108
	adrp	x0, .LC146
	add	x1, x1, :lo12:.LANCHOR108
	add	x0, x0, :lo12:.LC146
	bl	rknand_print_hex
	ldrb	w0, [x19, #:lo12:.LANCHOR72]
	mov	w2, 2
	ldrh	w3, [x20, #:lo12:.LANCHOR80]
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR110
	ldp	x29, x30, [sp], 48
	lsl	w3, w3, 1
	ldr	x1, [x0, #:lo12:.LANCHOR110]
	adrp	x0, .LC147
	add	x0, x0, :lo12:.LC147
	b	rknand_print_hex
	.size	dump_ftl_info, .-dump_ftl_info
	.section	.text.pm_ppa_update_check,"ax",@progbits
	.align	2
	.global	pm_ppa_update_check
	.type	pm_ppa_update_check, %function
pm_ppa_update_check:
	adrp	x3, .LANCHOR96
	mov	w4, 21
	ldrh	w3, [x3, #:lo12:.LANCHOR96]
	sub	w5, w4, w3
	mov	w4, 1
	lsr	w3, w2, w3
	lsl	w4, w4, w5
	sub	w4, w4, #1
	and	w4, w4, w3
	adrp	x3, .LANCHOR95
	ldrb	w3, [x3, #:lo12:.LANCHOR95]
	udiv	w4, w4, w3
	adrp	x3, .LANCHOR3
	ldr	x3, [x3, #:lo12:.LANCHOR3]
	add	x4, x3, x4, uxth 2
	ldrb	w3, [x4, 2]
	ubfx	x3, x3, 5, 3
	cmp	w3, 1
	ccmp	w3, 7, 4, ne
	bne	.L2421
	stp	x29, x30, [sp, -16]!
	mov	w3, w2
	mov	w2, w1
	mov	x1, x0
	add	x29, sp, 0
	adrp	x0, .LC148
	add	x0, x0, :lo12:.LC148
	bl	printf
	bl	dump_ftl_info
	mov	w0, -1
	ldp	x29, x30, [sp], 16
	ret
.L2421:
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
	bls	.L2427
	adrp	x1, .LANCHOR187
	adrp	x0, .LC0
	mov	w2, 31
	add	x1, x1, :lo12:.LANCHOR187
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2427:
	adrp	x23, .LANCHOR97
	ldr	x0, [x23, #:lo12:.LANCHOR97]
	ldrh	w2, [x0, 698]
	cmp	w2, w19
	bcs	.L2428
	mov	w1, w19
	adrp	x0, .LC149
	add	x0, x0, :lo12:.LC149
	bl	printf
	adrp	x0, .LANCHOR188
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR188]
	mov	x0, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	ldr	x0, [x23, #:lo12:.LANCHOR97]
	ldrh	w0, [x0, 698]
	cmp	w0, w19
	bcs	.L2430
	mov	w2, 35
.L2435:
	adrp	x1, .LANCHOR187
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR187
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L2430
.L2428:
	add	x0, x0, x19, sxtw 2
	sbfiz	x20, x20, 4, 32
	ldr	w21, [x0, 704]
	adrp	x0, .LANCHOR123
	add	x0, x0, :lo12:.LANCHOR123
	add	x22, x0, x20
	strh	w19, [x0, x20]
	strh	wzr, [x22, 2]
	cbnz	w21, .L2431
	mov	w2, 0
	mov	w1, w19
	adrp	x0, .LC150
	add	x0, x0, :lo12:.LC150
	bl	printf
	adrp	x0, .LANCHOR188
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR188]
	ldr	x0, [x22, 8]
	bl	ftl_memset
.L2430:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L2431:
	adrp	x20, .LANCHOR179
	adrp	x24, .LANCHOR117
	ldr	x1, [x22, 8]
	mov	w0, w21
	ldr	x2, [x20, #:lo12:.LANCHOR179]
	ldrb	w3, [x24, #:lo12:.LANCHOR117]
	bl	ftl_read_ppa_page
	ldr	x1, [x20, #:lo12:.LANCHOR179]
	ldr	w2, [x1]
	cmp	w2, w19
	beq	.L2432
	mov	w4, w21
	mov	w3, w0
	mov	w1, w19
	adrp	x0, .LC151
	add	x0, x0, :lo12:.LC151
	bl	printf
	ldr	x1, [x23, #:lo12:.LANCHOR97]
	mov	w2, 4
	adrp	x0, .LC152
	add	x0, x0, :lo12:.LC152
	add	x1, x1, 704
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	ldr	x1, [x22, 8]
	mov	w2, 4
	ldrb	w3, [x24, #:lo12:.LANCHOR117]
	adrp	x0, .LC153
	add	x0, x0, :lo12:.LC153
	lsl	w3, w3, 7
	bl	rknand_print_hex
	ldr	x1, [x20, #:lo12:.LANCHOR179]
	mov	w2, 4
	mov	w3, 16
	adrp	x0, .LC154
	add	x0, x0, :lo12:.LC154
	bl	rknand_print_hex
	adrp	x0, .LANCHOR96
	ldrh	w2, [x0, #:lo12:.LANCHOR96]
	mov	w0, 21
	sub	w1, w0, w2
	mov	w0, 1
	lsr	w21, w21, w2
	lsl	w0, w0, w1
	adrp	x1, .LANCHOR95
	sub	w0, w0, #1
	ldrb	w2, [x1, #:lo12:.LANCHOR95]
	and	w0, w0, w21
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
.L2432:
	ldr	x0, [x20, #:lo12:.LANCHOR179]
	ldr	w0, [x0]
	cmp	w19, w0
	beq	.L2430
	mov	w2, 57
	b	.L2435
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
	adrp	x19, .LANCHOR134
	stp	x21, x22, [sp, 32]
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	stp	x23, x24, [sp, 48]
	ldrh	w1, [x0, 688]
	ldrh	w0, [x19, #:lo12:.LANCHOR134]
	str	x25, [sp, 64]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L2438
	bl	pm_free_sblk
	ldr	x2, [x20, #:lo12:.LANCHOR97]
	ldrh	w1, [x19, #:lo12:.LANCHOR134]
	sub	w1, w1, #1
	ldrh	w3, [x2, 688]
	cmp	w3, w1
	blt	.L2438
	add	x0, x2, x0, uxth 1
	ldrh	w21, [x0, 416]
	mov	w0, 65535
	cmp	w21, w0
	bne	.L2440
	adrp	x1, .LANCHOR189
	add	x1, x1, :lo12:.LANCHOR189
	mov	w2, 129
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	bl	pm_free_sblk
	ldr	x1, [x20, #:lo12:.LANCHOR97]
	add	x0, x1, x0, uxth 1
	ldrh	w21, [x0, 416]
.L2440:
	bl	pm_select_ram_region
	and	x24, x0, 65535
	adrp	x1, .LANCHOR123
	lsl	x0, x24, 4
	add	x2, x1, :lo12:.LANCHOR123
	mov	x22, x24
	add	x19, x2, x0
	mov	x23, x1
	ldrh	w0, [x2, x0]
	mov	w2, 65535
	cmp	w0, w2
	beq	.L2441
	ldr	x1, [x19, 8]
	cbz	x1, .L2441
	ldrsh	w2, [x19, 2]
	tbz	w2, #31, .L2441
	bl	pm_write_page
	ldrh	w0, [x19, 2]
	and	w0, w0, 32767
	strh	w0, [x19, 2]
.L2441:
	add	x1, x23, :lo12:.LANCHOR123
	adrp	x25, .LANCHOR96
	add	x24, x1, x24, lsl 4
	add	x25, x25, :lo12:.LANCHOR96
	mov	w19, 0
.L2442:
	ldr	x1, [x20, #:lo12:.LANCHOR97]
	ldrh	w0, [x1, 698]
	cmp	w0, w19
	bhi	.L2444
	bl	pm_free_sblk
.L2438:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2444:
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
	adrp	x1, .LANCHOR95
	ldrb	w1, [x1, #:lo12:.LANCHOR95]
	udiv	w0, w0, w1
	cmp	w21, w0, uxth
	bne	.L2443
	mov	w1, w22
	mov	w0, w19
	bl	load_l2p_region
	ldr	x1, [x24, 8]
	mov	w0, w19
	bl	pm_write_page
	mov	w0, -1
	strh	w0, [x24]
.L2443:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2442
	.size	pm_gc, .-pm_gc
	.section	.text.pm_flush_id,"ax",@progbits
	.align	2
	.global	pm_flush_id
	.type	pm_flush_id, %function
pm_flush_id:
	stp	x29, x30, [sp, -32]!
	ubfiz	x0, x0, 4, 16
	adrp	x2, .LANCHOR123
	add	x2, x2, :lo12:.LANCHOR123
	add	x29, sp, 0
	str	x19, [sp, 16]
	add	x19, x2, x0
	ldrh	w0, [x2, x0]
	ldr	x1, [x19, 8]
	bl	pm_write_page
	ldrh	w0, [x19, 2]
	and	w0, w0, 32767
	strh	w0, [x19, 2]
	adrp	x19, .LANCHOR121
	ldr	w0, [x19, #:lo12:.LANCHOR121]
	cbz	w0, .L2450
	bl	pm_gc
	str	wzr, [x19, #:lo12:.LANCHOR121]
.L2450:
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
	adrp	x19, .LANCHOR123
	add	x19, x19, :lo12:.LANCHOR123
	mov	w20, 0
	add	x19, x19, 2
.L2457:
	ldrsh	w0, [x19]
	tbz	w0, #31, .L2456
	mov	w0, w20
	bl	pm_flush_id
.L2456:
	add	w20, w20, 1
	add	x19, x19, 16
	and	w20, w20, 65535
	cmp	w20, 32
	bne	.L2457
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
	adrp	x0, .LANCHOR121
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	adrp	x20, .LANCHOR123
	str	wzr, [x0, #:lo12:.LANCHOR121]
	adrp	x0, .LANCHOR180
	stp	x25, x26, [sp, 64]
	add	x19, x20, :lo12:.LANCHOR123
	strb	w1, [x0, #:lo12:.LANCHOR180]
	mov	w0, 64
	stp	x27, x28, [sp, 80]
	bl	ftl_malloc
	adrp	x1, .LANCHOR179
	adrp	x22, .LANCHOR117
	add	x23, x19, 512
	mov	x21, x1
	add	x22, x22, :lo12:.LANCHOR117
	str	x0, [x1, #:lo12:.LANCHOR179]
	mov	w25, -1
.L2467:
	strh	w25, [x19]
	strh	wzr, [x19, 2]
	cbz	w24, .L2466
	ldrb	w0, [x22]
	lsl	w0, w0, 9
	bl	ftl_malloc
	str	x0, [x19, 8]
.L2466:
	add	x19, x19, 16
	cmp	x19, x23
	bne	.L2467
	add	x0, x20, :lo12:.LANCHOR123
	adrp	x19, .LANCHOR97
	ldr	x24, [x21, #:lo12:.LANCHOR179]
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
	bgt	.L2468
	ldrh	w1, [x0, 692]
	mov	w3, w26
	adrp	x0, .LC155
	add	x0, x0, :lo12:.LC155
	adrp	x27, .LANCHOR103
	adrp	x28, .LANCHOR117
	add	x27, x27, :lo12:.LANCHOR103
	add	x28, x28, :lo12:.LANCHOR117
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	ldrsh	w21, [x0, 696]
.L2469:
	cmp	w21, w26
	ble	.L2471
	adrp	x0, .LANCHOR170
	mov	w1, 1
	add	x20, x20, :lo12:.LANCHOR123
	add	w23, w23, 1
	strb	w1, [x0, #:lo12:.LANCHOR170]
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	strh	w23, [x0, 696]
	bl	pm_free_sblk
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
.L2468:
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
.L2471:
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
	adrp	x0, .LC156
	add	x0, x0, :lo12:.LC156
	ldr	w1, [x24]
	bl	printf
	ldr	w4, [x29, 108]
	cmp	w4, 512
	ccmn	w4, #1, 4, ne
	beq	.L2470
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	ldr	w0, [x24]
	ldrh	w2, [x1, 698]
	cmp	w0, w2
	bcs	.L2470
	add	x0, x1, x0, uxtw 2
	str	w22, [x0, 704]
.L2470:
	add	w21, w21, 1
	sxth	w21, w21
	b	.L2469
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
	adrp	x1, .LANCHOR117
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	ldrb	w1, [x1, #:lo12:.LANCHOR117]
	stp	x23, x24, [sp, 48]
	mov	w23, w2
	lsl	w21, w1, 7
	ubfiz	w20, w1, 7, 9
	adrp	x1, .LANCHOR54
	udiv	w21, w0, w21
	ldr	w2, [x1, #:lo12:.LANCHOR54]
	cmp	w0, w2
	and	w25, w21, 65535
	msub	w20, w25, w20, w0
	bcc	.L2481
	mov	w1, w0
	adrp	x0, .LC157
	add	x0, x0, :lo12:.LC157
	bl	printf
	mov	w0, -1
.L2480:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2481:
	adrp	x24, .LANCHOR123
	add	x0, x24, :lo12:.LANCHOR123
	and	x20, x20, 65535
	add	x0, x0, 8
	mov	x19, 0
.L2487:
	ldr	x1, [x0]
	cbz	x1, .L2483
	ldrh	w1, [x0, -8]
	cmp	w1, w25
	bne	.L2483
.L2484:
	cbnz	w23, .L2485
	add	x0, x24, :lo12:.LANCHOR123
	add	x0, x0, x19, lsl 4
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x20, lsl 2]
	str	w0, [x22]
.L2486:
	add	x24, x24, :lo12:.LANCHOR123
	add	x19, x24, x19, lsl 4
	ldrh	w0, [x19, 2]
	mvn	x1, x0
	tst	x1, 32767
	beq	.L2489
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L2489:
	mov	w0, 0
	b	.L2480
.L2485:
	add	x0, x24, :lo12:.LANCHOR123
	ldr	w2, [x22]
	add	x0, x0, x19, lsl 4
	ldr	x1, [x0, 8]
	str	w2, [x1, x20, lsl 2]
	ldrh	w1, [x0, 2]
	orr	w1, w1, -32768
	strh	w1, [x0, 2]
	adrp	x0, .LANCHOR124
	strb	w21, [x0, #:lo12:.LANCHOR124]
	b	.L2486
.L2483:
	add	w19, w19, 1
	add	x0, x0, 16
	and	x19, x19, 65535
	cmp	w19, 32
	bne	.L2487
	bl	pm_select_ram_region
	and	x19, x0, 65535
	sbfiz	x1, x19, 4, 32
	add	x2, x24, :lo12:.LANCHOR123
	add	x3, x2, x1
	mov	w26, w0
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L2488
	ldrsh	w1, [x3, 2]
	tbz	w1, #31, .L2488
	bl	pm_flush_id
.L2488:
	adrp	x0, .LANCHOR190
	mov	w1, w26
	strb	w19, [x0, #:lo12:.LANCHOR190]
	mov	w0, w25
	bl	load_l2p_region
	b	.L2484
	.size	pm_log2phys, .-pm_log2phys
	.section	.text.ftl_read_ahead,"ax",@progbits
	.align	2
	.global	ftl_read_ahead
	.type	ftl_read_ahead, %function
ftl_read_ahead:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR56
	stp	x21, x22, [sp, 32]
	ldr	w0, [x20, #:lo12:.LANCHOR56]
	stp	x23, x24, [sp, 48]
	cmn	w0, #1
	beq	.L2504
	mov	w0, 0
	bl	buf_alloc
	mov	x19, x0
	mov	w0, -1
	cbz	x19, .L2495
	ldr	w21, [x20, #:lo12:.LANCHOR56]
	str	w21, [x19, 36]
	str	w0, [x20, #:lo12:.LANCHOR56]
	mov	w0, w21
	ldr	x20, [x19, 8]
	ldr	x22, [x19, 24]
	bl	lpa_hash_get_ppa
	str	w0, [x29, 76]
	cmn	w0, #1
	bne	.L2498
	mov	w2, 0
	add	x1, x29, 76
	mov	w0, w21
	bl	pm_log2phys
.L2498:
	ldr	w0, [x29, 76]
	stp	w0, w0, [x19, 40]
	cmn	w0, #1
	bne	.L2499
	adrp	x0, .LANCHOR117
	mov	w1, 0
	ldrb	w2, [x0, #:lo12:.LANCHOR117]
	mov	x0, x20
	lsl	w2, w2, 9
	bl	ftl_memset
	ldrb	w0, [x19, 2]
	orr	w0, w0, 8
	strb	w0, [x19, 2]
.L2504:
	mov	w0, 0
.L2495:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2499:
	mov	w1, 1
	mov	x0, x19
	bl	sblk_read_page
	ldr	w23, [x19, 52]
	cmn	w23, #1
	bne	.L2500
	ldrb	w0, [x19, 2]
	and	w0, w0, -9
	strb	w0, [x19, 2]
	adrp	x0, .LANCHOR5
	ldr	x1, [x0, #:lo12:.LANCHOR5]
	ldr	w0, [x1, 552]
	add	w0, w0, 1
	str	w0, [x1, 552]
.L2501:
	ldr	w5, [x22, 4]
	cmp	w21, w5
	beq	.L2502
	ldrb	w1, [x19, 1]
	adrp	x0, .LC159
	ldr	w4, [x22]
	mov	w2, w21
	ldp	w6, w7, [x22, 8]
	add	x0, x0, :lo12:.LC159
	ldr	w3, [x29, 76]
	bl	printf
.L2502:
	ldr	w0, [x22, 4]
	cmp	w21, w0
	bne	.L2503
	cmn	w23, #1
	bne	.L2504
.L2503:
	mov	w2, 874
	adrp	x1, .LANCHOR191
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR191
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L2504
.L2500:
	cmp	w23, 256
	bne	.L2501
	adrp	x0, .LANCHOR96
	mov	w20, 21
	mov	w24, 1
	ldrh	w1, [x0, #:lo12:.LANCHOR96]
	ldr	w0, [x29, 76]
	sub	w20, w20, w1
	ldp	w2, w3, [x19, 36]
	lsr	w0, w0, w1
	lsl	w20, w24, w20
	sub	w20, w20, #1
	and	w20, w20, w0
	adrp	x0, .LANCHOR95
	ldrb	w0, [x0, #:lo12:.LANCHOR95]
	udiv	w20, w20, w0
	adrp	x0, .LC158
	add	x0, x0, :lo12:.LC158
	and	w1, w20, 65535
	bl	printf
	mov	w2, 0
	mov	w1, w24
	mov	w0, w20
	bl	gc_add_sblk
	b	.L2501
	.size	ftl_read_ahead, .-ftl_read_ahead
	.section	.text.gc_recovery,"ax",@progbits
	.align	2
	.global	gc_recovery
	.type	gc_recovery, %function
gc_recovery:
	sub	sp, sp, #240
	adrp	x0, .LANCHOR70
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	stp	x21, x22, [sp, 64]
	adrp	x21, .LANCHOR5
	stp	x19, x20, [sp, 48]
	ldr	x20, [x21, #:lo12:.LANCHOR5]
	strb	wzr, [x0, #:lo12:.LANCHOR70]
	adrp	x0, .LANCHOR138
	stp	x23, x24, [sp, 80]
	strb	wzr, [x0, #:lo12:.LANCHOR138]
	stp	x25, x26, [sp, 96]
	stp	x27, x28, [sp, 112]
	bl	gc_init
	add	x0, x20, 80
	ldrh	w1, [x20, 80]
	str	x0, [x29, 168]
	mov	w0, 65535
	cmp	w1, w0
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	beq	.L2509
	mov	w1, -1
	strh	w1, [x0, 130]
	mov	w0, 1
	bl	buf_alloc
	mov	x27, x0
	ldrb	w0, [x20, 89]
	add	x1, x20, 80
	adrp	x3, .LANCHOR103
	adrp	x2, .LANCHOR67
	sub	w0, w0, #1
	str	x3, [x29, 128]
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x3, #:lo12:.LANCHOR103]
	str	x2, [x29, 160]
	ldrh	w0, [x0, 16]
	mul	w1, w0, w1
	ldrb	w0, [x2, #:lo12:.LANCHOR67]
	str	w1, [x29, 200]
	cmp	w0, 3
	bne	.L2510
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	sub	w0, w0, #1
	add	w0, w0, w1
	orr	w0, w0, 50331648
.L2557:
	str	w0, [x27, 40]
.L2511:
	mov	w1, 1
	mov	x0, x27
	bl	sblk_read_page
	ldr	w0, [x27, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2512
	ldr	x0, [x27, 24]
	ldr	w1, [x0]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	cmp	w1, w0
	beq	.L2513
.L2512:
	mov	x0, x27
	bl	buf_free
	ldr	x1, [x27, 24]
	ldr	x0, [x27, 8]
	ldr	w2, [x1, 12]
	str	w2, [sp, 16]
	ldr	w2, [x1, 8]
	str	w2, [sp, 8]
	ldr	w2, [x1, 4]
	str	w2, [sp]
	ldp	w3, w4, [x0]
	ldp	w5, w6, [x0, 8]
	adrp	x0, .LC160
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC160
	ldr	w1, [x27, 40]
	ldr	w2, [x27, 52]
	bl	printf
.L2561:
	adrp	x0, .LANCHOR4
	ldrh	w1, [x20, 80]
	mov	w22, 0
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	strh	wzr, [x0, x1, lsl 1]
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	ldrh	w1, [x20, 80]
	strh	w1, [x0, 130]
.L2514:
	ldrh	w1, [x20, 80]
	mov	w2, w22
	adrp	x0, .LC163
	add	x0, x0, :lo12:.LC163
	bl	printf
	mov	w0, -1
	strh	w0, [x20, 80]
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	mov	w1, 65535
	ldrh	w0, [x0, 130]
	cmp	w0, w1
	beq	.L2543
	bl	ftl_free_sblk
.L2543:
	adrp	x0, .LANCHOR97
	ldr	x1, [x0, #:lo12:.LANCHOR97]
	mov	w0, -1
	strh	w0, [x1, 126]
	ldr	x1, [x21, #:lo12:.LANCHOR5]
	strh	w0, [x1, 130]
	mov	w0, 0
	bl	ftl_info_flush
.L2508:
	ldp	x19, x20, [sp, 48]
	ldp	x21, x22, [sp, 64]
	ldp	x23, x24, [sp, 80]
	ldp	x25, x26, [sp, 96]
	ldp	x27, x28, [sp, 112]
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 240
	ret
.L2510:
	cmp	w0, 2
	bne	.L2511
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	add	w0, w1, w0, lsl 1
	sub	w0, w0, #1
	orr	w0, w0, 33554432
	b	.L2557
.L2513:
	adrp	x26, .LANCHOR71
	adrp	x19, .LANCHOR72
	adrp	x22, .LANCHOR139
	ldr	x1, [x27, 8]
	ldrb	w0, [x19, #:lo12:.LANCHOR72]
	ldrh	w2, [x26, #:lo12:.LANCHOR71]
	mul	w2, w2, w0
	ldr	x0, [x22, #:lo12:.LANCHOR139]
	lsl	w2, w2, 2
	bl	ftl_memcpy
	ldrb	w1, [x19, #:lo12:.LANCHOR72]
	adrp	x19, .LANCHOR140
	ldrh	w0, [x26, #:lo12:.LANCHOR71]
	mul	w0, w0, w1
	ldr	x1, [x27, 8]
	lsl	w2, w0, 2
	add	x1, x1, x0, sxtw 2
	ldr	x0, [x19, #:lo12:.LANCHOR140]
	bl	ftl_memcpy
	str	x26, [x29, 120]
	adrp	x0, .LANCHOR80
	stp	x19, x22, [x29, 144]
	ldrh	w24, [x0, #:lo12:.LANCHOR80]
	ldr	x0, [x29, 160]
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	cmp	w0, 2
	beq	.L2515
.L2558:
	str	w0, [x29, 180]
	adrp	x23, .LC161
	ldr	x0, [x29, 128]
	add	x23, x23, :lo12:.LC161
	mov	w26, 0
	mov	w22, 0
	add	x0, x0, :lo12:.LANCHOR103
	str	x0, [x29, 104]
.L2517:
	sub	w0, w26, #1
	str	w0, [x29, 184]
	cmp	w26, w24
	beq	.L2526
	mov	x19, 0
	b	.L2527
.L2515:
	lsl	w24, w24, 1
	mov	w0, 1
	b	.L2558
.L2523:
	ldr	x1, [x29, 104]
	ldr	x0, [x29, 136]
	ldrh	w1, [x1]
	ldrh	w0, [x0, 96]
	mul	w0, w0, w1
	ldr	x1, [x29, 112]
	str	w0, [x29, 200]
	ldrb	w1, [x1]
	cmp	w1, 3
	bne	.L2518
	add	w0, w26, w0
	orr	w0, w0, w25, lsl 24
.L2559:
	str	w0, [x27, 40]
	mov	w1, 1
	mov	x0, x27
	bl	sblk_read_page
	ldr	x0, [x29, 152]
	ldr	x0, [x0, #:lo12:.LANCHOR139]
	ldr	w3, [x0, x28]
	ldr	x0, [x27, 24]
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bne	.L2521
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR140]
	ldr	w2, [x1, x28]
	ldr	w1, [x0, 8]
	cmp	w2, w1
	beq	.L2522
.L2521:
	ldr	x1, [x29, 144]
	ldr	w2, [x0, 12]
	str	w2, [sp]
	ldr	x1, [x1, #:lo12:.LANCHOR140]
	ldr	w5, [x0]
	ldr	w7, [x0, 8]
	mov	x0, x23
	ldr	w2, [x27, 52]
	ldr	w4, [x1, x28]
	ldr	w1, [x27, 40]
	bl	printf
	ldr	x0, [x29, 152]
	ldr	x0, [x0, #:lo12:.LANCHOR139]
	ldr	w0, [x0, x28]
	cmn	w0, #1
	beq	.L2522
	mov	x0, x27
	bl	buf_free
	b	.L2561
.L2518:
	cmp	w1, 2
	bne	.L2520
	ldr	w1, [x29, 184]
	add	w0, w0, w1
	add	w0, w0, w25
	orr	w0, w0, 33554432
	b	.L2559
.L2520:
	add	w0, w26, w0
	b	.L2559
.L2522:
	add	w22, w22, 1
	add	w25, w25, 1
	add	x28, x28, 4
.L2525:
	ldr	w0, [x29, 180]
	cmp	w0, w25
	bcs	.L2523
	add	x19, x19, 1
.L2527:
	ldr	x0, [x29, 168]
	ldrb	w0, [x0, 9]
	cmp	w0, w19
	ble	.L2524
	add	x0, x20, x19, lsl 1
	str	x0, [x29, 136]
	ldr	x0, [x29, 160]
	sbfiz	x28, x22, 2, 32
	mov	w25, 1
	add	x0, x0, :lo12:.LANCHOR67
	str	x0, [x29, 112]
	b	.L2525
.L2524:
	add	w26, w26, 1
	b	.L2517
.L2526:
	mov	x0, x27
	bl	buf_free
	ldr	x3, [x29, 120]
	adrp	x24, .LANCHOR4
	ldr	x0, [x29, 168]
	mov	w22, 0
	ldrh	w2, [x20, 80]
	mov	w23, 0
	ldr	x1, [x24, #:lo12:.LANCHOR4]
	mov	w27, 0
	ldrh	w3, [x3, #:lo12:.LANCHOR71]
	ldrb	w0, [x0, 9]
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	adrp	x0, .LANCHOR96
	add	x0, x0, :lo12:.LANCHOR96
	str	x0, [x29, 96]
.L2528:
	sub	w0, w23, #1
	str	w0, [x29, 120]
	cmp	w26, w23
	beq	.L2541
	str	xzr, [x29, 184]
	b	.L2542
.L2538:
	ldr	x1, [x29, 152]
	sbfiz	x0, x27, 2, 32
	ldr	x1, [x1, #:lo12:.LANCHOR139]
	ldr	w28, [x1, x0]
	cmn	w28, #1
	beq	.L2529
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR140]
	ldr	w0, [x1, x0]
	str	w0, [x29, 136]
	mov	w0, w28
	bl	lpa_hash_get_ppa
	str	w0, [x29, 204]
	cmn	w0, #1
	bne	.L2530
	mov	w2, 0
	add	x1, x29, 204
	mov	w0, w28
	bl	pm_log2phys
.L2530:
	ldr	x0, [x29, 112]
	ldr	x1, [x29, 128]
	ldrh	w0, [x0, 96]
	ldrh	w1, [x1, #:lo12:.LANCHOR103]
	mul	w0, w0, w1
	ldr	x1, [x29, 160]
	ldrb	w1, [x1, #:lo12:.LANCHOR67]
	cmp	w1, 3
	bne	.L2531
	add	w0, w23, w0
	orr	w0, w0, w25, lsl 24
.L2560:
	str	w0, [x29, 200]
	mov	w19, 21
	ldr	x0, [x29, 96]
	mov	w4, 1
	ldr	w1, [x29, 136]
	ldrh	w0, [x0]
	sub	w19, w19, w0
	lsr	w0, w1, w0
	lsl	w19, w4, w19
	sub	w19, w19, #1
	and	w19, w19, w0
	ldr	x0, [x29, 104]
	ldrb	w0, [x0]
	udiv	w19, w19, w0
	ldr	w0, [x29, 204]
	cmp	w1, w0
	and	x19, x19, 65535
	bne	.L2534
	ldr	w2, [x29, 200]
	mov	w1, w28
	str	w4, [x29, 136]
	adrp	x0, .LC162
	add	x0, x0, :lo12:.LC162
	bl	pm_ppa_update_check
	ldr	w4, [x29, 136]
	cbz	w0, .L2535
.L2555:
	b	.L2555
.L2531:
	cmp	w1, 2
	bne	.L2533
	ldr	w1, [x29, 120]
	add	w0, w0, w1
	add	w0, w0, w25
	orr	w0, w0, 33554432
	b	.L2560
.L2533:
	add	w0, w23, w0
	b	.L2560
.L2535:
	mov	w2, w4
	add	x1, x29, 200
	mov	w0, w28
	bl	pm_log2phys
	add	w22, w22, 1
	mov	w0, w19
	bl	ftl_vpn_decrement
.L2537:
	adrp	x0, .LANCHOR3
	add	w27, w27, 1
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x0, x0, x19, lsl 2
	ldrb	w0, [x0, 2]
	tst	w0, 224
	bne	.L2529
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	lsl	x19, x19, 1
	ldrh	w1, [x0, x19]
	cbz	w1, .L2529
	strh	wzr, [x0, x19]
.L2529:
	add	w25, w25, 1
.L2540:
	ldr	w0, [x29, 180]
	cmp	w0, w25
	bcs	.L2538
	ldr	x0, [x29, 184]
	add	x0, x0, 1
	str	x0, [x29, 184]
.L2542:
	ldr	x0, [x29, 168]
	ldr	w1, [x29, 184]
	ldrb	w0, [x0, 9]
	cmp	w0, w1
	ble	.L2539
	ldr	x0, [x29, 184]
	mov	w25, 1
	add	x0, x20, x0, lsl 1
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR95
	add	x0, x0, :lo12:.LANCHOR95
	str	x0, [x29, 104]
	b	.L2540
.L2534:
	ldr	w1, [x29, 200]
	cmp	w0, w1
	cinc	w22, w22, eq
	b	.L2537
.L2539:
	add	w23, w23, 1
	b	.L2528
.L2541:
	ldrh	w1, [x20, 80]
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	strh	w22, [x0, x1, lsl 1]
	b	.L2514
.L2509:
	ldrh	w0, [x0, 130]
	cmp	w0, w1
	beq	.L2508
	adrp	x19, .LANCHOR97
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	ldrh	w1, [x1, 126]
	cmp	w1, w0
	bne	.L2545
	bl	pm_flush
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	ldrh	w0, [x0, 130]
	bl	ftl_free_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	mov	w1, -1
	strh	w1, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
.L2545:
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	mov	w1, -1
	strh	w1, [x0, 130]
	b	.L2508
	.size	gc_recovery, .-gc_recovery
	.section	.text.zftl_init,"ax",@progbits
	.align	2
	.global	zftl_init
	.type	zftl_init, %function
zftl_init:
	stp	x29, x30, [sp, -112]!
	adrp	x1, .LANCHOR52
	mov	w0, -1
	add	x29, sp, 0
	strb	w0, [x1, #:lo12:.LANCHOR52]
	adrp	x1, .LANCHOR53
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR80
	strb	wzr, [x1, #:lo12:.LANCHOR53]
	adrp	x1, .LANCHOR163
	stp	x19, x20, [sp, 16]
	adrp	x21, .LANCHOR72
	strb	w0, [x1, #:lo12:.LANCHOR163]
	adrp	x0, .LANCHOR115
	mov	w1, -1
	stp	x23, x24, [sp, 48]
	strb	wzr, [x0, #:lo12:.LANCHOR115]
	adrp	x0, .LANCHOR56
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR2
	str	w1, [x0, #:lo12:.LANCHOR56]
	adrp	x1, .LC164
	stp	x27, x28, [sp, 80]
	add	x1, x1, :lo12:.LC164
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	bl	printf
	adrp	x20, .LANCHOR188
	adrp	x1, .LANCHOR32
	add	x1, x1, :lo12:.LANCHOR32
	adrp	x0, .LANCHOR67
	adrp	x2, .LANCHOR117
	adrp	x7, .LANCHOR95
	ldrb	w5, [x1, 12]
	strb	w5, [x0, #:lo12:.LANCHOR67]
	ldrb	w0, [x1, 9]
	strb	w0, [x2, #:lo12:.LANCHOR117]
	adrp	x2, .LANCHOR71
	ldrh	w3, [x1, 10]
	strh	w3, [x2, #:lo12:.LANCHOR71]
	adrp	x2, .LANCHOR12
	ldrh	w8, [x1, 14]
	ubfiz	w11, w0, 9, 7
	ldrb	w4, [x2, #:lo12:.LANCHOR12]
	adrp	x2, .LANCHOR104
	sdiv	w6, w3, w5
	strh	w8, [x23, #:lo12:.LANCHOR2]
	strb	w4, [x2, #:lo12:.LANCHOR104]
	ldrb	w2, [x1, 13]
	adrp	x1, .LANCHOR26
	strb	w2, [x7, #:lo12:.LANCHOR95]
	ldrh	w7, [x1, #:lo12:.LANCHOR26]
	adrp	x1, .LANCHOR103
	strh	w6, [x22, #:lo12:.LANCHOR80]
	mul	w4, w4, w2
	strh	w7, [x1, #:lo12:.LANCHOR103]
	strh	w11, [x20, #:lo12:.LANCHOR188]
	mov	w2, 1
	and	w4, w4, 255
	mov	w1, 0
	strb	w4, [x21, #:lo12:.LANCHOR72]
.L2563:
	cmp	w7, w2
	bcs	.L2564
	mul	w3, w0, w3
	adrp	x2, .LANCHOR96
	sub	w1, w1, #1
	adrp	x10, .LANCHOR192
	strh	w1, [x2, #:lo12:.LANCHOR96]
	mov	w1, 57344
	movk	w1, 0x1c, lsl 16
	adrp	x28, .LANCHOR54
	mul	w7, w3, w8
	adrp	x24, .LANCHOR175
	mul	w1, w4, w1
	adrp	x27, .LANCHOR193
	mul	w3, w3, w4
	adrp	x26, .LANCHOR134
	lsr	w2, w7, 21
	mul	w6, w6, w4
	mul	w7, w7, w4
	sub	w3, w3, #1
	str	w7, [x10, #:lo12:.LANCHOR192]
	sub	w7, w11, #1
	mul	w1, w1, w2
	adrp	x2, .LANCHOR59
	adrp	x25, .LANCHOR83
	str	w1, [x2, #:lo12:.LANCHOR59]
	add	w2, w1, 24576
	str	w2, [x27, #:lo12:.LANCHOR193]
	udiv	w0, w2, w0
	udiv	w2, w2, w3
	str	w0, [x28, #:lo12:.LANCHOR54]
	add	w0, w7, w0, lsl 2
	add	w2, w2, 8
	udiv	w0, w0, w11
	strh	w0, [x24, #:lo12:.LANCHOR175]
	ubfiz	w0, w0, 4, 16
	sdiv	w0, w0, w6
	adrp	x6, .LANCHOR87
	str	x6, [x29, 104]
	strh	w2, [x6, #:lo12:.LANCHOR87]
	adrp	x2, .LANCHOR100
	strh	w0, [x26, #:lo12:.LANCHOR134]
	add	w0, w8, w8, lsl 1
	asr	w0, w0, 2
	strh	w0, [x2, #:lo12:.LANCHOR100]
	lsr	w0, w8, 4
	strh	w0, [x25, #:lo12:.LANCHOR83]
	cmp	w0, 79
	bhi	.L2565
	mov	w0, 80
	strh	w0, [x25, #:lo12:.LANCHOR83]
.L2565:
	adrp	x2, .LANCHOR98
	mov	w0, 4000
	adrp	x4, .LANCHOR99
	mov	w3, 1024
	strh	w0, [x2, #:lo12:.LANCHOR98]
	mov	w0, 50
	strh	w0, [x4, #:lo12:.LANCHOR99]
	adrp	x0, .LANCHOR133
	mov	w6, 64
	cmp	w5, 2
	strh	w3, [x0, #:lo12:.LANCHOR133]
	adrp	x3, .LANCHOR132
	strh	w6, [x3, #:lo12:.LANCHOR132]
	beq	.L2566
	adrp	x5, .LANCHOR69
	ldrb	w5, [x5, #:lo12:.LANCHOR69]
	cbz	w5, .L2567
.L2566:
	mov	w5, 150
	strh	w5, [x4, #:lo12:.LANCHOR99]
	mov	w4, 128
	strh	w4, [x3, #:lo12:.LANCHOR132]
	adrp	x3, .LANCHOR11
	ldrb	w3, [x3, #:lo12:.LANCHOR11]
	cbnz	w3, .L2567
	mov	w3, 600
	strh	w3, [x2, #:lo12:.LANCHOR98]
	mov	w2, 512
	strh	w2, [x0, #:lo12:.LANCHOR133]
.L2567:
	adrp	x19, .LANCHOR7
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2569
	str	x10, [x29, 96]
	adrp	x0, .LC165
	add	x0, x0, :lo12:.LC165
	bl	printf
	ldr	x10, [x29, 96]
.L2569:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2570
	ldr	w1, [x10, #:lo12:.LANCHOR192]
	adrp	x0, .LC166
	add	x0, x0, :lo12:.LC166
	bl	printf
.L2570:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2571
	ldr	w1, [x28, #:lo12:.LANCHOR54]
	adrp	x0, .LC167
	add	x0, x0, :lo12:.LC167
	bl	printf
.L2571:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2572
	ldr	w1, [x27, #:lo12:.LANCHOR193]
	adrp	x0, .LC168
	add	x0, x0, :lo12:.LC168
	bl	printf
.L2572:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2573
	ldrh	w1, [x24, #:lo12:.LANCHOR175]
	adrp	x0, .LC169
	add	x0, x0, :lo12:.LC169
	bl	printf
.L2573:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2574
	ldrh	w1, [x20, #:lo12:.LANCHOR188]
	adrp	x0, .LC170
	add	x0, x0, :lo12:.LC170
	bl	printf
.L2574:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2575
	ldrh	w1, [x26, #:lo12:.LANCHOR134]
	adrp	x0, .LC171
	add	x0, x0, :lo12:.LC171
	bl	printf
.L2575:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2576
	ldrh	w1, [x25, #:lo12:.LANCHOR83]
	adrp	x0, .LC172
	add	x0, x0, :lo12:.LC172
	bl	printf
.L2576:
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2577
	ldr	x0, [x29, 104]
	ldrh	w1, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LC173
	add	x0, x0, :lo12:.LC173
	bl	printf
.L2577:
	bl	buf_init
	adrp	x25, .LANCHOR5
	ldrh	w1, [x23, #:lo12:.LANCHOR2]
	mov	w0, 6
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR0
	str	x0, [x1, #:lo12:.LANCHOR0]
	ldrb	w1, [x21, #:lo12:.LANCHOR72]
	ldrh	w0, [x22, #:lo12:.LANCHOR80]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR110
	adrp	x2, ftl_ext_info_data_buffer
	add	x2, x2, :lo12:ftl_ext_info_data_buffer
	str	x0, [x1, #:lo12:.LANCHOR110]
	adrp	x0, .LANCHOR109
	ldrh	w1, [x22, #:lo12:.LANCHOR80]
	str	x2, [x0, #:lo12:.LANCHOR109]
	ldrb	w0, [x21, #:lo12:.LANCHOR72]
	mul	w1, w1, w0
	lsl	w0, w1, 1
	adrp	x1, .LANCHOR4
	add	x3, x2, x0, sxtw 2
	str	x3, [x1, #:lo12:.LANCHOR4]
	ldrh	w1, [x23, #:lo12:.LANCHOR2]
	add	w1, w0, w1, lsr 1
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	add	x1, x2, x1, sxtw 2
	str	x1, [x25, #:lo12:.LANCHOR5]
	tbz	x0, 12, .L2578
	adrp	x0, .LC174
	add	x0, x0, :lo12:.LC174
	bl	printf
.L2578:
	ldrh	w0, [x22, #:lo12:.LANCHOR80]
	ldrb	w21, [x21, #:lo12:.LANCHOR72]
	ldrh	w1, [x23, #:lo12:.LANCHOR2]
	ldrh	w22, [x24, #:lo12:.LANCHOR175]
	mul	w21, w0, w21
	ldr	w0, [x19, #:lo12:.LANCHOR7]
	add	w21, w1, w21, lsl 2
	lsl	w1, w1, 2
	lsl	w21, w21, 1
	add	w22, w1, w22, lsl 2
	add	w21, w21, 612
	add	w22, w22, 704
	tbz	x0, 12, .L2579
	ldrh	w3, [x20, #:lo12:.LANCHOR188]
	adrp	x0, .LC175
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC175
	bl	printf
.L2579:
	ldrh	w0, [x20, #:lo12:.LANCHOR188]
	cmp	w21, w0
	bhi	.L2580
	cmp	w22, w0
	bls	.L2581
.L2580:
.L2624:
	b	.L2624
.L2564:
	add	w1, w1, 1
	lsl	w2, w2, 1
	and	w1, w1, 65535
	b	.L2563
.L2581:
	bl	sblk_init
	bl	ftl_info_blk_init
	cmn	w0, #1
	beq	.L2562
	bl	ftl_ext_info_init
	adrp	x19, .LANCHOR97
	mov	w0, 1
	bl	pm_init
	bl	lpa_rebuild_hash
	ldr	x0, [x25, #:lo12:.LANCHOR5]
	mov	x1, 0
	add	x0, x0, 16
	bl	ftl_open_sblk_recovery
	ldr	x0, [x25, #:lo12:.LANCHOR5]
	add	x1, x0, 16
	add	x0, x0, 48
	bl	ftl_open_sblk_recovery
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	ldr	w0, [x1, 8]
	add	w0, w0, 16
	str	w0, [x1, 8]
	ldr	x0, [x25, #:lo12:.LANCHOR5]
	add	x0, x0, 16
	bl	ftl_info_data_recovery
	ldr	x0, [x25, #:lo12:.LANCHOR5]
	add	x0, x0, 48
	bl	ftl_info_data_recovery
	ldr	x0, [x25, #:lo12:.LANCHOR5]
	add	x0, x0, 80
	bl	ftl_info_data_recovery
	bl	gc_recovery
	bl	pm_flush
	mov	w0, 1
	bl	ftl_total_vpn_update
	adrp	x0, .LANCHOR170
	ldrb	w0, [x0, #:lo12:.LANCHOR170]
	cbz	w0, .L2583
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	ldr	w0, [x1, 68]
	add	w0, w0, 1
	str	w0, [x1, 68]
.L2583:
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	print_ftl_debug_info
	mov	w0, 0
.L2562:
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
	cbnz	w0, .L2628
	bl	zftl_init
.L2628:
	mov	w19, w0
	bl	idb_init
	mov	w1, w19
	adrp	x0, .LC176
	add	x0, x0, :lo12:.LC176
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
	adrp	x0, .LANCHOR5
	adrp	x1, .LANCHOR71
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldr	x20, [x0, #:lo12:.LANCHOR5]
	stp	x25, x26, [sp, 64]
	ldrh	w25, [x1, #:lo12:.LANCHOR71]
	add	x1, x20, 80
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR7
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	str	x1, [x29, 144]
	ldrb	w1, [x1, 9]
	str	x0, [x29, 128]
	mul	w25, w25, w1
	ldr	w1, [x21, #:lo12:.LANCHOR7]
	tbz	x1, 8, .L2631
	ldrh	w1, [x20, 80]
	adrp	x0, .LC177
	add	x0, x0, :lo12:.LC177
	bl	printf
.L2631:
	adrp	x23, .LANCHOR4
	ldrh	w1, [x20, 80]
	sub	w2, w25, #1
	mov	x22, 0
	ldr	x0, [x23, #:lo12:.LANCHOR4]
	mov	w24, 0
	strh	w2, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR117
	add	x0, x0, :lo12:.LANCHOR117
	str	x0, [x29, 104]
.L2632:
	mov	w27, w22
	cmp	w25, w22
	bhi	.L2642
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L2643
	ldr	x0, [x29, 128]
	mov	w3, w24
	ldr	x1, [x23, #:lo12:.LANCHOR4]
	ldrh	w2, [x20, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldrh	w2, [x1, x2, lsl 1]
	ldrh	w1, [x0, 80]
	adrp	x0, .LC181
	add	x0, x0, :lo12:.LC181
	bl	printf
.L2643:
	ldrh	w1, [x20, 80]
	ldr	x0, [x23, #:lo12:.LANCHOR4]
	ldrh	w0, [x0, x1, lsl 1]
	cmp	w24, w0
	beq	.L2644
	adrp	x1, .LANCHOR194
	adrp	x0, .LC0
	mov	w2, 463
	add	x1, x1, :lo12:.LANCHOR194
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2644:
	ldrh	w1, [x20, 80]
	ldr	x0, [x23, #:lo12:.LANCHOR4]
	strh	w24, [x0, x1, lsl 1]
	ldrh	w0, [x20, 80]
	bl	zftl_insert_data_list
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L2642:
	adrp	x26, .LANCHOR139
	lsl	x19, x22, 2
	ldr	x0, [x26, #:lo12:.LANCHOR139]
	ldr	w2, [x0, x19]
	cmn	w2, #1
	beq	.L2633
	adrp	x0, .LANCHOR117
	ldrb	w0, [x0, #:lo12:.LANCHOR117]
	lsl	w0, w0, 7
	udiv	w0, w2, w0
	and	w0, w0, 65535
	str	w0, [x29, 156]
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L2634
	ldr	w1, [x29, 156]
	adrp	x0, .LC178
	mov	w3, w22
	add	x0, x0, :lo12:.LC178
	bl	printf
.L2634:
	sub	w27, w25, w27
	add	x27, x27, x22
	lsl	x0, x27, 2
	str	x0, [x29, 136]
	adrp	x0, .LC180
	add	x0, x0, :lo12:.LC180
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR96
	add	x0, x0, :lo12:.LANCHOR96
	str	x0, [x29, 112]
.L2635:
	ldr	x0, [x29, 136]
	cmp	x0, x19
	bne	.L2641
.L2633:
	add	x22, x22, 1
	b	.L2632
.L2641:
	ldr	x0, [x26, #:lo12:.LANCHOR139]
	ldr	w28, [x0, x19]
	cmn	w28, #1
	beq	.L2636
	ldr	x0, [x29, 104]
	ldr	w1, [x29, 156]
	ldrb	w0, [x0]
	lsl	w0, w0, 7
	udiv	w0, w28, w0
	cmp	w1, w0, uxth
	bne	.L2636
	adrp	x0, .LANCHOR140
	ldr	x0, [x0, #:lo12:.LANCHOR140]
	ldr	w27, [x0, x19]
	mov	w0, w28
	bl	lpa_hash_get_ppa
	str	w0, [x29, 172]
	cmn	w0, #1
	bne	.L2637
	mov	w2, 0
	add	x1, x29, 172
	mov	w0, w28
	bl	pm_log2phys
.L2637:
	ldr	w3, [x29, 172]
	cmp	w27, w3
	bne	.L2638
	adrp	x0, .LANCHOR141
	mov	w2, 1
	add	x1, x29, 168
	add	w24, w24, 1
	ldr	x0, [x0, #:lo12:.LANCHOR141]
	ldr	w0, [x0, x19]
	str	w0, [x29, 168]
	mov	w0, w28
	bl	pm_log2phys
	ldr	x0, [x29, 112]
	mov	w1, 21
	ldrh	w0, [x0]
	sub	w2, w1, w0
	mov	w1, 1
	lsr	w0, w27, w0
	lsl	w1, w1, w2
	sub	w1, w1, #1
	and	w1, w1, w0
	adrp	x0, .LANCHOR95
	ldrb	w0, [x0, #:lo12:.LANCHOR95]
	udiv	w1, w1, w0
	and	w1, w1, 65535
	str	w1, [x29, 152]
	mov	w0, w1
	bl	ftl_vpn_decrement
	ldr	x0, [x29, 144]
	ldr	w1, [x29, 152]
	ldrh	w0, [x0]
	cmp	w0, w1
	bne	.L2639
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L2639
	ldr	w3, [x29, 172]
	adrp	x0, .LC179
	mov	w2, w27
	mov	w1, w28
	add	x0, x0, :lo12:.LC179
	bl	printf
.L2639:
	ldr	x0, [x26, #:lo12:.LANCHOR139]
	mov	w1, -1
	str	w1, [x0, x19]
.L2636:
	add	x19, x19, 4
	b	.L2635
.L2638:
	ldr	w0, [x21, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L2640
	ldr	x0, [x29, 120]
	mov	w2, w27
	mov	w1, w28
	bl	printf
.L2640:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0]
	bl	ftl_vpn_decrement
	b	.L2639
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
	adrp	x19, .LANCHOR63
	add	x1, x19, :lo12:.LANCHOR63
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	str	x25, [sp, 64]
	ldrb	w0, [x1, 4]
	add	x2, x1, x0, sxtw 1
	ldrh	w3, [x2, 40]
	adrp	x2, .LANCHOR72
	ldrb	w4, [x2, #:lo12:.LANCHOR72]
	ldrh	w2, [x1, 2]
.L2668:
	cmp	w3, w7
	beq	.L2670
	cbz	w6, .L2671
	add	x1, x19, :lo12:.LANCHOR63
	strb	w0, [x1, 4]
.L2671:
	cbz	w5, .L2672
	add	x0, x19, :lo12:.LANCHOR63
	strh	w2, [x0, 2]
.L2672:
	adrp	x0, .LANCHOR103
	ldrh	w22, [x0, #:lo12:.LANCHOR103]
	adrp	x0, .LANCHOR67
	mov	x23, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR67]
	mul	w22, w22, w3
	cmp	w1, 2
	bne	.L2673
	add	x0, x19, :lo12:.LANCHOR63
	ldrb	w1, [x0, 6]
	cbnz	w1, .L2673
	ldrh	w0, [x0, 2]
	add	w22, w22, w0, lsl 1
.L2674:
	add	x1, x19, :lo12:.LANCHOR63
	ldrb	w0, [x1, 4]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x1, 4]
	cmp	w4, w0
	bne	.L2675
	ldrh	w0, [x1, 2]
	strb	wzr, [x1, 4]
	add	w0, w0, 1
	strh	w0, [x1, 2]
.L2675:
	mov	w0, 1
	add	x19, x19, :lo12:.LANCHOR63
	bl	buf_alloc
	add	x23, x23, :lo12:.LANCHOR67
	mov	x21, x0
	mov	w20, 0
	adrp	x24, .LANCHOR64
.L2685:
	ldrb	w0, [x19, 6]
	cmp	w0, 3
	bne	.L2676
	cbz	w20, .L2677
.L2676:
	cmp	w0, w20
	bgt	.L2678
.L2686:
	mov	x0, x21
	bl	buf_free
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2670:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, w4
	bne	.L2669
	add	w2, w2, 1
	mov	w5, 1
	and	w2, w2, 65535
	mov	w0, 0
.L2669:
	add	x3, x1, x0, sxtw 1
	mov	w6, 1
	ldrh	w3, [x3, 40]
	b	.L2668
.L2673:
	add	x0, x19, :lo12:.LANCHOR63
	ldrh	w0, [x0, 2]
	add	w22, w0, w22
	b	.L2674
.L2678:
	ldrb	w1, [x23]
	cmp	w1, 2
	bne	.L2679
	cbnz	w0, .L2679
	add	w0, w20, w22
	orr	w0, w0, 33554432
.L2699:
	str	w0, [x21, 40]
	mov	w1, 1
	mov	x0, x21
	bl	sblk_read_page
	ldr	w0, [x21, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2682
	ldr	x0, [x21, 24]
	ldr	w25, [x0, 4]
	mov	w0, w25
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L2683
	mov	w2, 0
	add	x1, x29, 92
	mov	w0, w25
	bl	pm_log2phys
.L2683:
	ldr	w0, [x29, 92]
	cmp	w22, w0
	bne	.L2682
	ldrh	w0, [x19, 24]
	ldr	x2, [x24, #:lo12:.LANCHOR64]
	ubfiz	x1, x0, 2, 16
	add	w0, w0, 1
	str	w22, [x2, x1]
	strh	w0, [x19, 24]
.L2682:
	ldrh	w0, [x19, 26]
	add	w0, w0, 1
	strh	w0, [x19, 26]
.L2677:
	add	w20, w20, 1
	cmp	w20, 4
	bne	.L2685
	b	.L2686
.L2679:
	orr	w0, w22, w20, lsl 24
	b	.L2699
	.size	gc_scan_src_blk_one_page, .-gc_scan_src_blk_one_page
	.section	.text.gc_scan_static_data,"ax",@progbits
	.align	2
	.global	gc_scan_static_data
	.type	gc_scan_static_data, %function
gc_scan_static_data:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR5
	stp	x21, x22, [sp, 32]
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	ldr	w1, [x0, 544]
	str	x23, [sp, 48]
	cmn	w1, #1
	beq	.L2701
	adrp	x21, .LANCHOR195
	adrp	x22, .LC0
	add	x21, x21, :lo12:.LANCHOR195
	add	x22, x22, :lo12:.LC0
	mov	w20, 11
.L2709:
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	mov	w2, 0
	add	x1, x29, 76
	ldr	w0, [x0, 544]
	bl	pm_log2phys
	ldr	w0, [x29, 76]
	cmn	w0, #1
	beq	.L2702
	mov	w0, 1
	bl	buf_alloc
	ldr	w1, [x29, 76]
	mov	x23, x0
	str	w1, [x0, 40]
	mov	w1, 1
	bl	sblk_read_page
	ldr	w0, [x23, 52]
	cmp	w0, 256
	bne	.L2703
	adrp	x0, .LANCHOR96
	ldr	w2, [x29, 76]
	mov	w1, 1
	ldrh	w3, [x0, #:lo12:.LANCHOR96]
	mov	w0, 21
	sub	w0, w0, w3
	lsr	w2, w2, w3
	lsl	w0, w1, w0
	sub	w0, w0, #1
	and	w0, w0, w2
	adrp	x2, .LANCHOR95
	ldrb	w3, [x2, #:lo12:.LANCHOR95]
	mov	w2, 0
	udiv	w0, w0, w3
	bl	gc_add_sblk
.L2703:
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	ldr	x1, [x23, 24]
	ldr	w0, [x0, 544]
	ldr	w1, [x1, 4]
	cmp	w1, w0
	beq	.L2704
	mov	w2, 1369
	mov	x1, x21
	mov	x0, x22
	bl	printf
.L2704:
	mov	x0, x23
	bl	buf_free
.L2702:
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	adrp	x2, .LANCHOR54
	ldr	w2, [x2, #:lo12:.LANCHOR54]
	ldr	w1, [x0, 544]
	add	w1, w1, 1
	str	w1, [x0, 544]
	cmp	w1, w2
	bcc	.L2705
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
.L2700:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2705:
	ldr	w0, [x29, 76]
	cmn	w0, #1
	bne	.L2700
	sub	w20, w20, #1
	ands	w20, w20, 65535
	bne	.L2709
	b	.L2700
.L2701:
	adrp	x1, .LANCHOR97
	ldr	x1, [x1, #:lo12:.LANCHOR97]
	ldr	w2, [x1, 40]
	cmp	w2, 20480
	bls	.L2711
	ldr	w3, [x1, 44]
	add	w3, w3, w2, lsr 10
	and	w2, w2, 1023
	stp	w2, w3, [x1, 40]
.L2711:
	ldr	w2, [x0, 536]
	ldr	w3, [x0, 12]
	add	w2, w2, 12959744
	add	w2, w2, 256
	cmp	w3, w2
	ldr	w2, [x1, 44]
	bhi	.L2712
	ldr	w1, [x0, 540]
	add	w1, w1, 98304
	add	w1, w1, 1696
	cmp	w2, w1
	bls	.L2700
.L2712:
	str	w3, [x0, 536]
	str	w2, [x0, 540]
	str	wzr, [x0, 544]
	b	.L2700
	.size	gc_scan_static_data, .-gc_scan_static_data
	.section	.text.ftl_sblk_dump,"ax",@progbits
	.align	2
	.global	ftl_sblk_dump
	.type	ftl_sblk_dump, %function
ftl_sblk_dump:
	sub	sp, sp, #272
	stp	x29, x30, [sp, 48]
	add	x29, sp, 48
	stp	x21, x22, [sp, 80]
	and	w21, w0, 65535
	stp	x19, x20, [sp, 64]
	mov	w0, 65535
	stp	x23, x24, [sp, 96]
	cmp	w21, w0
	stp	x25, x26, [sp, 112]
	stp	x27, x28, [sp, 128]
	beq	.L2739
	adrp	x0, .LANCHOR2
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	cmp	w0, w21
	bls	.L2739
	uxtw	x0, w21
	adrp	x25, .LANCHOR3
	str	x0, [x29, 136]
	lsl	x0, x0, 2
	str	x0, [x29, 160]
	ldr	x0, [x25, #:lo12:.LANCHOR3]
	ldr	x2, [x29, 160]
	add	x0, x0, x2
	ldrb	w0, [x0, 2]
	and	w0, w0, 224
	cmp	w0, 160
	bne	.L2740
	adrp	x0, .LANCHOR67
	ldrb	w24, [x0, #:lo12:.LANCHOR67]
.L2720:
	add	x28, x29, 224
	adrp	x19, .LANCHOR80
	str	x1, [x29, 152]
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
	mov	w3, w24
	strh	wzr, [x29, 194]
	adrp	x0, .LC182
	mul	w1, w1, w2
	ldr	x2, [x29, 160]
	strh	w1, [x29, 198]
	add	x0, x0, :lo12:.LC182
	ldr	x1, [x25, #:lo12:.LANCHOR3]
	strh	wzr, [x29, 202]
	add	x1, x1, x2
	ldrb	w2, [x1, 2]
	mov	w1, w21
	ubfx	x2, x2, 5, 3
	bl	printf
	mov	w0, 1
	bl	buf_alloc
	str	x19, [x29, 128]
	mov	x26, x0
	stp	wzr, wzr, [x29, 168]
	adrp	x0, .LANCHOR103
	add	x0, x0, :lo12:.LANCHOR103
	str	x0, [x29, 104]
.L2721:
	ldr	x0, [x29, 128]
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w0, w20
	bls	.L2736
	lsl	w0, w20, 1
	mov	w23, 0
	sub	w0, w0, #1
	str	w0, [x29, 148]
	adrp	x0, .LC129
	add	x0, x0, :lo12:.LC129
	str	x0, [x29, 112]
	b	.L2737
.L2740:
	mov	w24, 1
	b	.L2720
.L2733:
	ldr	x0, [x29, 120]
	ldrh	w10, [x28, x0]
	mov	w0, 65535
	cmp	w10, w0
	beq	.L2722
	ldr	x0, [x29, 104]
	cmp	w24, 3
	ldrh	w19, [x0]
	mul	w19, w19, w10
	bne	.L2723
	add	w19, w20, w19
	orr	w19, w19, w22, lsl 24
.L2724:
	str	w19, [x26, 40]
	mov	w1, 1
	str	w10, [x29, 100]
	mov	x0, x26
	bl	sblk_read_page
	ldr	x1, [x26, 24]
	mov	w3, w19
	ldr	x0, [x26, 8]
	ldr	w11, [x26, 52]
	ldr	w10, [x29, 100]
	ldr	w2, [x1, 12]
	mov	w4, w11
	str	w2, [sp, 32]
	str	w11, [x29, 144]
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
	ldr	x0, [x29, 112]
	bl	printf
	ldr	w11, [x29, 144]
	ldr	w0, [x29, 168]
	cmp	w11, 512
	ldr	x1, [x29, 160]
	ccmn	w11, #1, 4, ne
	csinc	w0, w0, wzr, ne
	str	w0, [x29, 168]
	ldr	x0, [x25, #:lo12:.LANCHOR3]
	add	x0, x0, x1
	mov	w1, 32
	ldrb	w0, [x0, 2]
	and	w0, w0, 224
	cmp	w0, 224
	ccmp	w0, w1, 4, ne
	beq	.L2722
	ldr	x0, [x26, 24]
	ldr	w0, [x0, 4]
	bl	lpa_hash_get_ppa
	str	w0, [x29, 188]
	cmn	w0, #1
	bne	.L2727
	ldr	x0, [x26, 24]
	mov	w2, 0
	add	x1, x29, 188
	ldr	w0, [x0, 4]
	bl	pm_log2phys
.L2727:
	ldr	w0, [x29, 188]
	cmp	w19, w0
	bne	.L2728
	ldr	w0, [x29, 172]
	mov	w1, w19
	add	w0, w0, 1
	str	w0, [x29, 172]
	ldr	x0, [x26, 24]
	ldr	w3, [x29, 172]
	ldr	w2, [x0, 4]
	adrp	x0, .LC183
	add	x0, x0, :lo12:.LC183
	bl	printf
.L2728:
	ldr	x0, [x29, 152]
	cbz	x0, .L2730
	ubfiz	x19, x27, 2, 32
	ldr	w2, [x0, x19]
	ldr	x0, [x26, 24]
	ldr	w0, [x0, 4]
	cmp	w0, w2
	beq	.L2731
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2731
	adrp	x0, .LC184
	mov	w1, w27
	add	x0, x0, :lo12:.LC184
	bl	printf
.L2731:
	ldr	x1, [x26, 24]
	ldr	x0, [x29, 152]
	ldr	w1, [x1, 4]
	ldr	w0, [x0, x19]
	cmp	w1, w0
	beq	.L2730
	cmn	w0, #1
	beq	.L2730
	adrp	x1, .LANCHOR196
	adrp	x0, .LC0
	mov	w2, 1193
	add	x1, x1, :lo12:.LANCHOR196
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2730:
	add	w27, w27, 1
.L2722:
	add	w22, w22, 1
	and	w22, w22, 65535
.L2735:
	cmp	w24, w22
	bcs	.L2733
	add	w23, w23, 1
	and	w23, w23, 65535
.L2737:
	ldrb	w0, [x29, 201]
	cmp	w0, w23
	bls	.L2734
	sxtw	x0, w23
	mov	w22, 1
	add	x0, x0, 8
	lsl	x0, x0, 1
	str	x0, [x29, 120]
	b	.L2735
.L2723:
	cmp	w24, 2
	bne	.L2725
	ldr	w0, [x29, 148]
	add	w19, w19, w0
	adrp	x0, .LANCHOR67
	add	w19, w19, w22
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	orr	w19, w19, w0, lsl 24
	b	.L2724
.L2725:
	add	w19, w20, w19
	b	.L2724
.L2734:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2721
.L2736:
	mov	x0, x26
	bl	buf_free
	adrp	x0, .LANCHOR4
	ldr	x1, [x29, 136]
	ldr	w3, [x29, 172]
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	ldrh	w2, [x0, x1, lsl 1]
	mov	w1, w21
	adrp	x0, .LC185
	add	x0, x0, :lo12:.LC185
	bl	printf
	ldr	w0, [x29, 168]
.L2718:
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 272
	ret
.L2739:
	mov	w0, 0
	b	.L2718
	.size	ftl_sblk_dump, .-ftl_sblk_dump
	.section	.text.zftl_read,"ax",@progbits
	.align	2
	.global	zftl_read
	.type	zftl_read, %function
zftl_read:
	stp	x29, x30, [sp, -160]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	w21, w0
	adrp	x0, .LANCHOR7
	stp	x23, x24, [sp, 48]
	stp	x19, x20, [sp, 16]
	mov	w24, w2
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	mov	w19, w1
	stp	x25, x26, [sp, 64]
	mov	x23, x3
	stp	x27, x28, [sp, 80]
	tbz	x0, 12, .L2751
	mov	w3, w2
	adrp	x0, .LC186
	mov	w2, w1
	add	x0, x0, :lo12:.LC186
	mov	w1, w21
	bl	printf
.L2751:
	cbnz	w21, .L2752
	adrp	x0, .LANCHOR59
	mov	w21, 24576
	ldr	w0, [x0, #:lo12:.LANCHOR59]
.L2753:
	add	w1, w19, w24
	cmp	w0, w1
	bcc	.L2777
	adrp	x1, .LANCHOR97
	adrp	x25, .LANCHOR117
	add	w21, w21, w19
	str	x1, [x29, 120]
	ldr	x2, [x1, #:lo12:.LANCHOR97]
	ldr	w0, [x2, 24]
	add	w0, w0, w24
	str	w0, [x2, 24]
	ldrb	w0, [x25, #:lo12:.LANCHOR117]
	add	w2, w24, w21
	stp	w2, wzr, [x29, 136]
	sub	w2, w2, #1
	udiv	w27, w21, w0
	udiv	w0, w2, w0
	mov	w20, w27
	sub	w26, w0, w27
	str	w0, [x29, 132]
	add	w26, w26, 1
	adrp	x0, .LANCHOR197
	add	x0, x0, :lo12:.LANCHOR197
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR46
	add	x0, x0, :lo12:.LANCHOR46
	str	x0, [x29, 104]
.L2755:
	cbnz	w26, .L2775
	ldr	w0, [x29, 140]
.L2750:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L2752:
	cmp	w21, 3
	bhi	.L2777
	lsl	w21, w21, 13
	mov	w0, 8192
	b	.L2753
.L2775:
	ldrb	w1, [x25, #:lo12:.LANCHOR117]
	cmp	w20, w27
	ldr	w0, [x29, 132]
	and	w19, w1, 65535
	ccmp	w20, w0, 4, ne
	bne	.L2778
	cmp	w20, w27
	bne	.L2757
	udiv	w22, w21, w1
	and	w0, w24, 65535
	msub	w1, w22, w1, w21
	and	w22, w1, 65535
	sub	w19, w19, w22
	and	w19, w19, 65535
	cmp	w24, w19
	csel	w19, w0, w19, cc
.L2756:
	adrp	x0, .LANCHOR46
	add	x1, x0, :lo12:.LANCHOR46
	add	x1, x1, 2
	mov	w0, 0
.L2760:
	ldr	w2, [x1, 34]
	cmp	w20, w2
	bne	.L2758
	ldrb	w2, [x1]
	tbz	x2, 3, .L2758
	ldr	x1, [x29, 104]
	ubfiz	x0, x0, 6, 32
	lsl	w2, w19, 9
	ubfiz	x19, x19, 9, 16
	add	x0, x1, x0
	ubfiz	x22, x22, 9, 16
	ldr	x1, [x0, 8]
	mov	x0, x23
	add	x23, x23, x19
	add	x1, x1, x22
	bl	ftl_memcpy
.L2759:
	add	w20, w20, 1
	sub	w26, w26, #1
	b	.L2755
.L2757:
	ldr	w0, [x29, 136]
	msub	w19, w1, w20, w0
	and	w19, w19, 255
.L2778:
	mov	w22, 0
	b	.L2756
.L2758:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L2760
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 156]
	cmn	w0, #1
	bne	.L2761
	mov	w2, 0
	add	x1, x29, 156
	mov	w0, w20
	bl	pm_log2phys
.L2761:
	ldr	w0, [x29, 156]
	cmn	w0, #1
	bne	.L2762
	add	x22, x25, :lo12:.LANCHOR117
	mov	w19, 0
.L2763:
	ldrb	w0, [x22]
	cmp	w19, w0
	bcs	.L2759
	madd	w0, w20, w0, w19
	cmp	w21, w0
	bhi	.L2764
	ldr	w1, [x29, 136]
	cmp	w1, w0
	bls	.L2764
	mov	x0, x23
	add	x23, x23, 512
	mov	w2, 512
	mov	w1, 0
	bl	ftl_memset
.L2764:
	add	w19, w19, 1
	b	.L2763
.L2762:
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L2766
	bl	ftl_read_ahead
	b	.L2755
.L2766:
	ldr	x0, [x29, 120]
	ldr	x1, [x0, #:lo12:.LANCHOR97]
	ldr	w0, [x1, 40]
	add	w0, w0, 1
	str	w0, [x1, 40]
	ldr	w0, [x29, 156]
	stp	w0, w0, [x28, 40]
	ldrb	w0, [x25, #:lo12:.LANCHOR117]
	cmp	w0, w19
	bne	.L2768
	str	x23, [x28, 16]
.L2768:
	mov	w1, 1
	mov	x0, x28
	bl	sblk_read_page
	ldr	w10, [x28, 52]
	cmn	w10, #1
	bne	.L2769
	adrp	x0, .LANCHOR5
	str	w10, [x29, 140]
	ldr	x1, [x0, #:lo12:.LANCHOR5]
	ldr	w0, [x1, 552]
	add	w0, w0, 1
	str	w0, [x1, 552]
.L2770:
	ldr	x0, [x28, 24]
	ldr	w5, [x0, 4]
	cmp	w20, w5
	beq	.L2771
	ldr	w4, [x0]
	mov	w2, w20
	ldp	w6, w7, [x0, 8]
	str	w10, [x29, 128]
	ldrb	w1, [x28, 1]
	adrp	x0, .LC159
	ldr	w3, [x29, 156]
	add	x0, x0, :lo12:.LC159
	bl	printf
	adrp	x0, .LANCHOR96
	ldr	w1, [x29, 156]
	ldrh	w3, [x0, #:lo12:.LANCHOR96]
	mov	w0, 21
	sub	w2, w0, w3
	mov	w0, 1
	lsr	w1, w1, w3
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR95
	ldrb	w2, [x1, #:lo12:.LANCHOR95]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
	ldr	w10, [x29, 128]
.L2771:
	ldr	x0, [x28, 24]
	ldr	w0, [x0, 4]
	cmp	w20, w0
	bne	.L2772
	cmn	w10, #1
	bne	.L2773
.L2772:
	ldr	x1, [x29, 112]
	adrp	x0, .LC0
	mov	w2, 1030
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2773:
	ldr	x0, [x28, 16]
	cbnz	x0, .L2774
	ldr	x1, [x28, 8]
	ubfiz	x22, x22, 9, 16
	lsl	w2, w19, 9
	mov	x0, x23
	add	x1, x1, x22
	bl	ftl_memcpy
.L2774:
	ubfiz	x19, x19, 9, 16
	mov	x0, x28
	add	x23, x23, x19
	bl	buf_free
	b	.L2759
.L2769:
	cmp	w10, 256
	bne	.L2770
	adrp	x0, .LANCHOR96
	mov	w4, 21
	mov	w5, 1
	stp	w10, w5, [x29, 96]
	ldrh	w1, [x0, #:lo12:.LANCHOR96]
	ldr	w0, [x29, 156]
	sub	w4, w4, w1
	ldp	w2, w3, [x28, 36]
	lsl	w4, w5, w4
	lsr	w0, w0, w1
	sub	w4, w4, #1
	and	w4, w4, w0
	adrp	x0, .LANCHOR95
	ldrb	w0, [x0, #:lo12:.LANCHOR95]
	udiv	w4, w4, w0
	adrp	x0, .LC187
	add	x0, x0, :lo12:.LC187
	and	w1, w4, 65535
	str	w4, [x29, 128]
	bl	printf
	ldr	w5, [x29, 100]
	mov	w2, 0
	ldr	w4, [x29, 128]
	mov	w1, w5
	mov	w0, w4
	bl	gc_add_sblk
	ldr	w10, [x29, 96]
	b	.L2770
.L2777:
	mov	w0, -1
	b	.L2750
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
	.section	.text.vpn_check,"ax",@progbits
	.align	2
	.global	vpn_check
	.type	vpn_check, %function
vpn_check:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR5
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR4
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR54
	stp	x25, x26, [sp, 64]
	adrp	x24, .LANCHOR2
	stp	x27, x28, [sp, 80]
	bl	dump_ftl_info
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	add	x23, x23, :lo12:.LANCHOR54
	add	x25, x24, :lo12:.LANCHOR2
	mov	w22, 0
	adrp	x20, check_vpc_tbl
	ldrh	w3, [x0, 80]
	ldrh	w2, [x0, 48]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC188
	add	x0, x0, :lo12:.LC188
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	ldr	x3, [x19, #:lo12:.LANCHOR4]
	ldrh	w1, [x0, 16]
	ldrh	w2, [x0, 22]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x3, x0]
	adrp	x0, .LC189
	add	x0, x0, :lo12:.LC189
	sub	w4, w3, w2
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	ldr	x3, [x19, #:lo12:.LANCHOR4]
	ldrh	w1, [x0, 48]
	ldrh	w2, [x0, 54]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x3, x0]
	adrp	x0, .LC190
	add	x0, x0, :lo12:.LC190
	sub	w4, w3, w2
	bl	printf
	mov	w2, 4608
	mov	w1, 0
	add	x0, x20, :lo12:check_vpc_tbl
	bl	ftl_memset
.L2794:
	ldr	w0, [x23]
	cmp	w22, w0
	bcc	.L2802
	adrp	x0, .LANCHOR2
	adrp	x24, .LC193
	add	x5, x0, :lo12:.LANCHOR2
	mov	x28, x0
	add	x24, x24, :lo12:.LC193
	mov	w23, 0
	mov	w22, 0
.L2803:
	ldrh	w0, [x5]
	cmp	w0, w22
	bhi	.L2805
	adrp	x24, .LANCHOR198
	adrp	x25, .LC0
	add	x22, x28, :lo12:.LANCHOR2
	add	x24, x24, :lo12:.LANCHOR198
	add	x25, x25, :lo12:.LC0
	mov	w21, 0
.L2806:
	ldrh	w0, [x22]
	cmp	w0, w21
	bhi	.L2812
	mov	w2, w23
	adrp	x1, .LANCHOR198
	adrp	x0, .LC195
	add	x1, x1, :lo12:.LANCHOR198
	add	x0, x0, :lo12:.LC195
	bl	printf
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2802:
	mov	w0, w22
	bl	lpa_hash_get_ppa
	str	w0, [x29, 124]
	cmn	w0, #1
	bne	.L2795
	mov	w2, 0
	add	x1, x29, 124
	mov	w0, w22
	bl	pm_log2phys
.L2796:
	ldr	w2, [x29, 124]
	cmn	w2, #1
	beq	.L2798
	adrp	x0, .LANCHOR96
	mov	w3, 21
	ldrh	w0, [x0, #:lo12:.LANCHOR96]
	sub	w1, w3, w0
	mov	w3, 1
	lsr	w0, w2, w0
	lsl	w3, w3, w1
	sub	w3, w3, #1
	and	w3, w3, w0
	adrp	x0, .LANCHOR95
	ldrb	w0, [x0, #:lo12:.LANCHOR95]
	udiv	w3, w3, w0
	ldrh	w0, [x24, #:lo12:.LANCHOR2]
	and	w26, w3, 65535
	and	w3, w3, 65535
	cmp	w0, w26
	bls	.L2799
	add	x0, x20, :lo12:check_vpc_tbl
	sxtw	x3, w3
	ldrh	w1, [x0, x3, lsl 1]
	add	w1, w1, 1
	strh	w1, [x0, x3, lsl 1]
.L2800:
	ldrh	w0, [x25]
	cmp	w0, w26
	bhi	.L2798
	adrp	x1, .LANCHOR198
	adrp	x0, .LC0
	mov	w2, 1266
	add	x1, x1, :lo12:.LANCHOR198
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2798:
	add	w22, w22, 1
	b	.L2794
.L2795:
	adrp	x1, .LANCHOR96
	ldrh	w3, [x1, #:lo12:.LANCHOR96]
	mov	w1, 21
	sub	w2, w1, w3
	mov	w1, 1
	lsr	w0, w0, w3
	lsl	w1, w1, w2
	sub	w1, w1, #1
	and	w0, w1, w0
	adrp	x1, .LANCHOR95
	ldrb	w1, [x1, #:lo12:.LANCHOR95]
	udiv	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR2]
	cmp	w1, w0, uxth
	bhi	.L2796
	mov	w2, 1256
	adrp	x1, .LANCHOR198
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR198
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L2796
.L2799:
	mov	w1, w22
	adrp	x0, .LC191
	add	x0, x0, :lo12:.LC191
	bl	printf
	adrp	x0, .LANCHOR117
	mov	w2, 4
	ldrb	w3, [x0, #:lo12:.LANCHOR117]
	adrp	x0, .LANCHOR123+8
	ldr	x1, [x0, #:lo12:.LANCHOR123+8]
	adrp	x0, .LC192
	lsl	w3, w3, 7
	add	x0, x0, :lo12:.LC192
	bl	rknand_print_hex
	b	.L2800
.L2805:
	uxtw	x0, w22
	ldr	x1, [x19, #:lo12:.LANCHOR4]
	lsl	x27, x0, 1
	add	x25, x20, :lo12:check_vpc_tbl
	sxtw	x26, w22
	ldrh	w3, [x1, x27]
	ldrh	w2, [x25, x26, lsl 1]
	cmp	w3, w2
	beq	.L2804
	adrp	x1, .LANCHOR3
	str	x5, [x29, 104]
	ldr	x1, [x1, #:lo12:.LANCHOR3]
	add	x0, x1, x0, lsl 2
	mov	w1, w22
	ldrb	w4, [x0, 2]
	mov	x0, x24
	ubfx	x4, x4, 5, 3
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR4]
	mov	w1, 65535
	ldr	x5, [x29, 104]
	ldrh	w0, [x0, x27]
	cmp	w0, w1
	beq	.L2804
	ldrh	w1, [x25, x26, lsl 1]
	cmp	w1, w0
	bls	.L2804
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	ldrh	w1, [x0, 16]
	cmp	w1, w22
	beq	.L2804
	ldrh	w1, [x0, 80]
	cmp	w1, w22
	beq	.L2804
	ldrh	w0, [x0, 48]
	cmp	w0, w22
	csinc	w23, w23, wzr, eq
.L2804:
	add	w0, w22, 1
	and	w22, w0, 65535
	b	.L2803
.L2812:
	adrp	x0, .LANCHOR3
	uxtw	x26, w21
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x0, x0, x26, lsl 2
	ldrb	w0, [x0, 2]
	tst	w0, 224
	bne	.L2808
	add	x0, x20, :lo12:check_vpc_tbl
	sxtw	x27, w21
	ldrh	w0, [x0, x27, lsl 1]
	cbnz	w0, .L2809
	ldr	x0, [x19, #:lo12:.LANCHOR4]
	lsl	x28, x26, 1
	ldrh	w0, [x0, x28]
	cbz	w0, .L2810
	adrp	x0, .LC194
	mov	w1, w21
	add	x0, x0, :lo12:.LC194
	bl	printf
.L2810:
	ldr	x0, [x19, #:lo12:.LANCHOR4]
	strh	wzr, [x0, x28]
.L2809:
	ldr	x0, [x19, #:lo12:.LANCHOR4]
	ldrh	w0, [x0, x26, lsl 1]
	cbz	w0, .L2808
	add	x0, x20, :lo12:check_vpc_tbl
	ldrh	w0, [x0, x27, lsl 1]
	cbz	w0, .L2808
	mov	w2, 1298
	mov	x1, x24
	mov	x0, x25
	bl	printf
.L2808:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L2806
	.size	vpn_check, .-vpn_check
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
	bne	.L2824
	adrp	x1, .LANCHOR199
	adrp	x0, .LC0
	mov	w2, 897
	add	x1, x1, :lo12:.LANCHOR199
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2824:
	ldrh	w1, [x19, #:lo12:.LANCHOR63]
	mov	w0, 65535
	cmp	w1, w0
	beq	.L2846
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L2826
	adrp	x2, .LANCHOR4
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR4]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC196
	add	x0, x0, :lo12:.LC196
	bl	printf
.L2826:
	ldrh	w0, [x19, #:lo12:.LANCHOR63]
	add	x14, x19, :lo12:.LANCHOR63
	add	x1, x14, 40
	bl	ftl_get_blk_list_in_sblk
	and	w1, w0, 255
	strb	w1, [x14, 5]
	cbnz	w1, .L2827
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR63]
.L2846:
	mov	w0, 0
	b	.L2823
.L2827:
	adrp	x4, .LANCHOR3
	ldrh	w3, [x19, #:lo12:.LANCHOR63]
	mov	x22, x4
	ldr	x1, [x4, #:lo12:.LANCHOR3]
	mov	x2, x3
	add	x1, x1, x3, lsl 2
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 32
	beq	.L2828
	cmp	w1, 224
	beq	.L2828
	cbz	w1, .L2829
	adrp	x1, .LANCHOR5
	ldr	x1, [x1, #:lo12:.LANCHOR5]
	ldrh	w3, [x1, 16]
	cmp	w3, w2
	beq	.L2828
	ldrh	w3, [x1, 48]
	cmp	w3, w2
	beq	.L2828
	ldrh	w1, [x1, 80]
	cmp	w1, w2
	bne	.L2860
.L2828:
	add	x0, x19, :lo12:.LANCHOR63
	mov	w1, -1
	strh	w1, [x19, #:lo12:.LANCHOR63]
	strh	wzr, [x0, 24]
	b	.L2846
.L2829:
	adrp	x0, .LANCHOR4
	mov	x20, x0
	ldr	x1, [x0, #:lo12:.LANCHOR4]
	ldrh	w1, [x1, x3, lsl 1]
	cbz	w1, .L2831
	adrp	x1, .LANCHOR199
	adrp	x0, .LC0
	mov	w2, 917
	add	x1, x1, :lo12:.LANCHOR199
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2831:
	ldrh	w1, [x19, #:lo12:.LANCHOR63]
	ldr	x0, [x20, #:lo12:.LANCHOR4]
	strh	wzr, [x0, x1, lsl 1]
	b	.L2828
.L2860:
	and	w0, w0, 255
	sub	w0, w0, #1
	add	x0, x14, x0, sxtw 1
	ldrh	w21, [x0, 40]
	mov	w0, 65535
	cmp	w21, w0
	bne	.L2832
	adrp	x1, .LANCHOR199
	adrp	x0, .LC0
	mov	w2, 925
	add	x1, x1, :lo12:.LANCHOR199
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2832:
	adrp	x1, .LANCHOR103
	ldr	x3, [x22, #:lo12:.LANCHOR3]
	adrp	x2, .LANCHOR80
	adrp	x23, .LANCHOR71
	ldrh	w20, [x1, #:lo12:.LANCHOR103]
	mov	x24, x2
	ldrh	w1, [x19, #:lo12:.LANCHOR63]
	ldrh	w0, [x2, #:lo12:.LANCHOR80]
	add	x1, x3, x1, lsl 2
	sub	w0, w0, #1
	and	w0, w0, 65535
	mul	w20, w20, w21
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 160
	bne	.L2847
	adrp	x1, .LANCHOR67
	ldrb	w21, [x1, #:lo12:.LANCHOR67]
	cmp	w21, 2
	orr	w20, w20, w21, lsl 24
	beq	.L2834
	and	w21, w21, 65535
.L2833:
	add	x22, x19, :lo12:.LANCHOR63
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
	adrp	x20, .LANCHOR64
	bl	sblk_read_page
	ldrh	w2, [x23, #:lo12:.LANCHOR71]
	adrp	x23, .LANCHOR72
	mov	w1, 255
	ldrb	w0, [x23, #:lo12:.LANCHOR72]
	mul	w2, w2, w0
	ldr	x0, [x20, #:lo12:.LANCHOR64]
	lsl	w2, w2, 2
	bl	ftl_memset
	strh	wzr, [x22, 24]
	ldr	w0, [x25, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L2835
.L2837:
	mov	x0, x25
	bl	buf_free
	mov	w0, -1
.L2823:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2834:
	ldrh	w0, [x23, #:lo12:.LANCHOR71]
	sub	w0, w0, #1
	and	w0, w0, 65535
	b	.L2833
.L2847:
	mov	w21, 1
	b	.L2833
.L2835:
	ldr	x0, [x25, 24]
	mov	w22, 15555
	movk	w22, 0xf55f, lsl 16
	ldr	w0, [x0]
	cmp	w0, w22
	beq	.L2836
	ldrh	w0, [x19, #:lo12:.LANCHOR63]
	mov	x1, 0
	bl	ftl_sblk_dump
	ldr	x0, [x25, 24]
	ldr	w0, [x0]
	cmp	w0, w22
	beq	.L2837
	mov	w2, 955
	adrp	x1, .LANCHOR199
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR199
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L2837
.L2836:
	ldrb	w0, [x23, #:lo12:.LANCHOR72]
	adrp	x22, .LANCHOR96
	ldrh	w1, [x24, #:lo12:.LANCHOR80]
	adrp	x23, .LANCHOR95
	ldr	x24, [x25, 8]
	add	x22, x22, :lo12:.LANCHOR96
	add	x23, x23, :lo12:.LANCHOR95
	mov	x26, 0
	mul	w0, w0, w1
	mul	w21, w21, w0
	and	w21, w21, 65535
.L2838:
	cmp	w21, w26
	bgt	.L2843
	mov	x0, x25
	bl	buf_free
	ldrh	w1, [x19, #:lo12:.LANCHOR63]
	adrp	x20, .LANCHOR4
	add	x0, x19, :lo12:.LANCHOR63
	ldr	x3, [x20, #:lo12:.LANCHOR4]
	ubfiz	x2, x1, 1, 16
	ldrh	w2, [x3, x2]
	ldrh	w3, [x0, 24]
	cmp	w2, w3
	beq	.L2844
	adrp	x0, .LC197
	add	x0, x0, :lo12:.LC197
	bl	printf
.L2844:
	ldrh	w2, [x19, #:lo12:.LANCHOR63]
	add	x0, x19, :lo12:.LANCHOR63
	ldr	x1, [x20, #:lo12:.LANCHOR4]
	ldrh	w0, [x0, 24]
	ldrh	w1, [x1, x2, lsl 1]
	cmp	w1, w0
	bcs	.L2845
	bl	vpn_check
.L2845:
	add	x0, x19, :lo12:.LANCHOR63
	ldrh	w2, [x19, #:lo12:.LANCHOR63]
	ldr	x1, [x20, #:lo12:.LANCHOR4]
	ldrh	w3, [x0, 24]
	strh	w3, [x1, x2, lsl 1]
	strh	wzr, [x0, 28]
	ldrh	w0, [x0, 24]
	b	.L2823
.L2843:
	ldr	w0, [x24, x26, lsl 2]
	cmn	w0, #1
	beq	.L2840
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L2841
	ldr	w0, [x24, x26, lsl 2]
	mov	w2, 0
	add	x1, x29, 92
	bl	pm_log2phys
.L2841:
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
	bne	.L2840
	ldrh	w0, [x1, 24]
	ldr	x4, [x20, #:lo12:.LANCHOR64]
	ubfiz	x2, x0, 2, 16
	add	w0, w0, 1
	str	w3, [x4, x2]
	strh	w0, [x1, 24]
.L2840:
	add	x26, x26, 1
	b	.L2838
	.size	gc_scan_src_blk, .-gc_scan_src_blk
	.section	.text.ftl_scan_all_data,"ax",@progbits
	.align	2
	.global	ftl_scan_all_data
	.type	ftl_scan_all_data, %function
ftl_scan_all_data:
	sub	sp, sp, #160
	mov	w0, 0
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	mov	w20, 0
	stp	x23, x24, [sp, 64]
	adrp	x23, .LANCHOR54
	stp	x27, x28, [sp, 96]
	add	x28, x23, :lo12:.LANCHOR54
	stp	x21, x22, [sp, 48]
	adrp	x24, .LC200
	stp	x25, x26, [sp, 80]
	bl	buf_alloc
	mov	w1, 0
	mov	x19, x0
	adrp	x0, .LC198
	add	x0, x0, :lo12:.LC198
	bl	printf
	add	x0, x24, :lo12:.LC200
	str	x0, [x29, 120]
.L2863:
	ldr	w0, [x23, #:lo12:.LANCHOR54]
	cmp	w20, w0
	bcc	.L2876
	mov	x0, x19
	bl	buf_free
	ldp	x29, x30, [sp, 16]
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	add	sp, sp, 160
	ret
.L2876:
	mov	w0, -1
	str	w0, [x19, 36]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 140]
	cmn	w0, #1
	bne	.L2864
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w20
	bl	pm_log2phys
.L2864:
	tst	x20, 4095
	bne	.L2865
	ldr	w2, [x29, 140]
	adrp	x0, .LC199
	mov	w1, w20
	add	x0, x0, :lo12:.LC199
	bl	printf
.L2865:
	ldr	w0, [x29, 140]
	stp	w0, w0, [x19, 40]
	cmn	w0, #1
	bne	.L2866
.L2868:
	add	w20, w20, 1
	b	.L2863
.L2866:
	mov	w1, 1
	mov	x0, x19
	bl	sblk_read_page
	ldr	w3, [x19, 52]
	ldr	x0, [x19, 24]
	cmp	w3, 256
	ccmn	w3, #1, 4, ne
	beq	.L2867
	ldr	w1, [x0, 4]
	cmp	w20, w1
	beq	.L2868
.L2867:
	ldr	x1, [x19, 8]
	add	x27, x24, :lo12:.LC200
	adrp	x25, .LANCHOR117
	adrp	x26, .LC201
	adrp	x22, .LANCHOR123
	ldr	w2, [x1, 4]
	str	w2, [sp, 8]
	ldr	w1, [x1]
	str	w1, [sp]
	mov	w1, w20
	ldp	w4, w5, [x0]
	ldp	w6, w7, [x0, 8]
	mov	x0, x27
	ldr	w2, [x19, 40]
	bl	printf
	ldr	x1, [x19, 24]
	ldr	w0, [x1, 8]
	cmn	w0, #1
	bne	.L2869
.L2871:
	ldrb	w21, [x25, #:lo12:.LANCHOR117]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	add	x22, x22, :lo12:.LANCHOR123
	mov	w4, w0
	add	x0, x26, :lo12:.LC201
	lsl	w27, w21, 7
	ubfiz	w3, w21, 7, 9
	sub	w3, w3, #1
	add	x21, x22, 8
	and	w3, w3, w20
	adrp	x26, .LC203
	sdiv	w27, w20, w27
	and	w3, w3, 65535
	add	x22, x22, 520
	add	x26, x26, :lo12:.LC203
	mov	w1, w20
	and	w25, w27, 65535
	mov	w2, w25
	bl	printf
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w20
	bl	pm_log2phys
.L2870:
	ldr	x1, [x21]
	cbz	x1, .L2875
	ldrh	w0, [x21, -8]
	cmp	w0, w25
	bne	.L2875
	mov	w3, 4096
	mov	w2, 4
	mov	x0, x26
	bl	rknand_print_hex
.L2875:
	add	x21, x21, 16
	cmp	x22, x21
	bne	.L2870
	b	.L2868
.L2869:
	ldr	w21, [x1, 4]
	ldr	w1, [x28]
	cmp	w21, w1
	bcs	.L2871
	str	w0, [x19, 40]
	mov	w1, 1
	mov	x0, x19
	bl	sblk_read_page
	ldr	x1, [x19, 8]
	ldr	x0, [x19, 24]
	ldr	w2, [x1, 4]
	str	w2, [sp, 8]
	ldr	w1, [x1]
	str	w1, [sp]
	mov	w1, w20
	ldp	w4, w5, [x0]
	ldp	w6, w7, [x0, 8]
	mov	x0, x27
	ldr	w2, [x19, 40]
	ldr	w3, [x19, 52]
	bl	printf
	mov	w0, w21
	bl	lpa_hash_get_ppa
	str	w0, [x29, 140]
	cmn	w0, #1
	bne	.L2872
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w21
	bl	pm_log2phys
.L2872:
	ldr	w0, [x29, 140]
	mov	w1, 1
	str	w0, [x19, 40]
	mov	x0, x19
	bl	sblk_read_page
	ldr	x1, [x19, 8]
	ldr	x0, [x19, 24]
	ldr	w2, [x1, 4]
	str	w2, [sp, 8]
	ldr	w1, [x1]
	str	w1, [sp]
	mov	w1, w21
	ldp	w4, w5, [x0]
	ldp	w6, w7, [x0, 8]
	ldr	w2, [x19, 40]
	ldr	w3, [x19, 52]
	ldr	x0, [x29, 120]
	bl	printf
	ldrb	w3, [x25, #:lo12:.LANCHOR117]
	mov	w0, w21
	str	w3, [x29, 104]
	lsl	w2, w3, 7
	udiv	w2, w21, w2
	and	w27, w2, 65535
	str	w2, [x29, 112]
	bl	lpa_hash_get_ppa
	mov	w4, w0
	ldr	w3, [x29, 104]
	mov	w1, w21
	ldr	w2, [x29, 112]
	add	x0, x26, :lo12:.LC201
	ubfiz	w3, w3, 7, 9
	and	w2, w2, 65535
	sub	w3, w3, #1
	and	w3, w3, w21
	and	w3, w3, 65535
	bl	printf
	mov	w0, w21
	mov	w2, 0
	add	x1, x29, 140
	bl	pm_log2phys
	add	x0, x22, :lo12:.LANCHOR123
	adrp	x5, .LC202
	add	x21, x0, 8
	add	x4, x0, 520
	add	x5, x5, :lo12:.LC202
.L2874:
	ldr	x1, [x21]
	cbz	x1, .L2873
	ldrh	w0, [x21, -8]
	cmp	w0, w27
	bne	.L2873
	mov	x0, x5
	stp	x4, x5, [x29, 104]
	mov	w3, 4096
	mov	w2, 4
	bl	rknand_print_hex
	ldp	x4, x5, [x29, 104]
.L2873:
	add	x21, x21, 16
	cmp	x4, x21
	bne	.L2874
	b	.L2871
	.size	ftl_scan_all_data, .-ftl_scan_all_data
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
	adrp	x0, .LANCHOR109
	str	x0, [x29, 104]
	ldr	x1, [x0, #:lo12:.LANCHOR109]
	add	x19, x1, x19, lsl 2
	add	x1, x19, x23, sxtw 2
	ldr	w1, [x1, -4]
	cmn	w1, #1
	beq	.L2887
	adrp	x1, .LANCHOR200
	adrp	x0, .LC0
	mov	w2, 1468
	add	x1, x1, :lo12:.LANCHOR200
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2887:
	adrp	x27, .LANCHOR117
	mov	x24, 0
	add	x0, x27, :lo12:.LANCHOR117
	mov	w21, 0
	str	x0, [x29, 96]
.L2888:
	cmp	w24, w23
	blt	.L2894
	adrp	x0, .LANCHOR7
	adrp	x19, .LANCHOR4
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L2895
	ldrh	w1, [x22]
	ldr	x2, [x19, #:lo12:.LANCHOR4]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC207
	mov	w2, w21
	add	x0, x0, :lo12:.LC207
	bl	printf
.L2895:
	ldrh	w1, [x22]
	ldr	x0, [x19, #:lo12:.LANCHOR4]
	ldp	x23, x24, [sp, 48]
	ldp	x19, x20, [sp, 16]
	strh	w21, [x0, x1, lsl 1]
	ldp	x25, x26, [sp, 64]
	ldp	x21, x22, [sp, 32]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2894:
	ldr	w2, [x19, x24, lsl 2]
	cmn	w2, #1
	beq	.L2889
	ldrb	w20, [x27, #:lo12:.LANCHOR117]
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	lsl	w20, w20, 7
	udiv	w20, w2, w20
	and	w20, w20, 65535
	tbz	x0, 12, .L2890
	adrp	x0, .LC204
	mov	w3, w24
	mov	w1, w20
	add	x0, x0, :lo12:.LC204
	bl	printf
.L2890:
	adrp	x25, .LANCHOR103
	adrp	x26, .LC205
	mov	x28, x24
	add	x25, x25, :lo12:.LANCHOR103
	add	x26, x26, :lo12:.LC205
.L2893:
	ldr	w1, [x19, x28, lsl 2]
	cmn	w1, #1
	beq	.L2891
	ldr	x0, [x29, 96]
	ldrb	w2, [x0]
	lsl	w2, w2, 7
	udiv	w1, w1, w2
	cmp	w20, w1, uxth
	bne	.L2891
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
	cbz	w0, .L2892
	ldr	x0, [x29, 104]
	mov	w3, w23
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR109]
	adrp	x0, .LC206
	add	x0, x0, :lo12:.LC206
	bl	rknand_print_hex
.L2892:
	ldr	w0, [x19, x28, lsl 2]
	add	w21, w21, 1
	mov	w2, 1
	add	x1, x29, 124
	and	w21, w21, 65535
	bl	pm_log2phys
	mov	w0, -1
	str	w0, [x19, x28, lsl 2]
.L2891:
	add	x28, x28, 1
	cmp	w23, w28
	bgt	.L2893
.L2889:
	add	x24, x24, 1
	b	.L2888
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
	beq	.L2917
	bl	zftl_insert_data_list
.L2917:
	adrp	x0, .LANCHOR5
	ldr	x0, [x0, #:lo12:.LANCHOR5]
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
	adrp	x0, .LANCHOR46
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	add	x26, x0, :lo12:.LANCHOR46
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
.L2922:
	adrp	x3, .LANCHOR53
	ldrb	w1, [x3, #:lo12:.LANCHOR53]
	cbz	w1, .L2924
	adrp	x4, .LANCHOR52
	adrp	x2, .LANCHOR46
	add	x2, x2, :lo12:.LANCHOR46
	sub	w1, w1, #1
	ldrb	w0, [x4, #:lo12:.LANCHOR52]
	str	x0, [x29, 104]
	strb	w1, [x3, #:lo12:.LANCHOR53]
	adrp	x1, .LANCHOR54
	ubfiz	x27, x0, 6, 8
	add	x5, x2, x27
	str	x5, [x29, 120]
	lsl	x5, x0, 6
	ldr	w1, [x1, #:lo12:.LANCHOR54]
	add	x0, x2, x5
	ldrb	w5, [x2, x5]
	ldr	w22, [x0, 36]
	strb	w5, [x4, #:lo12:.LANCHOR52]
	cmp	w22, w1
	bcc	.L2926
	ldr	x0, [x29, 120]
	bl	buf_free
	mov	w0, -1
.L2921:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L2926:
	ldrb	w21, [x0, 57]
	ldrb	w20, [x0, 56]
	ldr	x24, [x0, 8]
	ldr	x28, [x0, 24]
	adrp	x0, .LANCHOR115
	str	x0, [x29, 112]
	ldrb	w1, [x0, #:lo12:.LANCHOR115]
	cbz	w1, .L2928
	adrp	x0, .LANCHOR163
	ldrb	w1, [x0, #:lo12:.LANCHOR163]
	add	x1, x2, x1, lsl 6
.L2929:
	ldrb	w0, [x1]
	cmp	w0, 255
	bne	.L2930
	ldr	w0, [x1, 36]
	cmp	w22, w0
	bne	.L2928
	ldr	x0, [x1, 8]
	ubfiz	x21, x21, 9, 8
	lsl	w2, w20, 9
	add	x1, x24, x21
	add	x0, x0, x21
	bl	ftl_memcpy
	ldr	x0, [x29, 120]
	bl	buf_free
	b	.L2922
.L2930:
	ubfiz	x1, x0, 6, 8
	add	x1, x26, x1
	b	.L2929
.L2928:
	mov	w0, w22
	bl	lpa_hash_get_ppa
	str	w0, [x29, 140]
	cmn	w0, #1
	bne	.L2932
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w22
	bl	pm_log2phys
.L2932:
	adrp	x25, .LANCHOR5
	add	x1, x26, 2
	mov	w0, 0
	ldr	x19, [x25, #:lo12:.LANCHOR5]
	add	x19, x19, 16
.L2935:
	ldr	w2, [x1, 34]
	cmp	w22, w2
	bne	.L2933
	ldrb	w2, [x1]
	tbz	x2, 3, .L2933
	ubfiz	x0, x0, 6, 32
	and	w2, w2, -9
	add	x0, x26, x0
	strb	w2, [x0, 2]
	ldr	x23, [x0, 8]
	ldr	w0, [x0, 40]
	str	w0, [x29, 140]
.L2934:
	adrp	x0, .LANCHOR117
	str	x0, [x29, 96]
	ldrb	w1, [x0, #:lo12:.LANCHOR117]
	cmp	w20, w1
	bcs	.L2959
	add	w20, w21, w20
	cbz	x23, .L2937
	cbz	w21, .L2938
	lsl	w2, w21, 9
	mov	x1, x23
	mov	x0, x24
	bl	ftl_memcpy
	ldr	x19, [x25, #:lo12:.LANCHOR5]
	add	x19, x19, 48
.L2938:
	ldr	x0, [x29, 96]
	ldrb	w2, [x0, #:lo12:.LANCHOR117]
	cmp	w20, w2
	bcc	.L2939
	ldr	x19, [x25, #:lo12:.LANCHOR5]
	add	x19, x19, 16
.L2959:
	mov	w23, 0
	b	.L2936
.L2933:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L2935
	mov	x23, 0
	b	.L2934
.L2939:
	ubfiz	x0, x20, 9, 9
	sub	w2, w2, w20
	add	x1, x23, x0
	lsl	w2, w2, 9
	add	x0, x24, x0
	bl	ftl_memcpy
	b	.L2959
.L2937:
	ldr	w0, [x29, 140]
	cmn	w0, #1
	beq	.L2940
	mov	w0, 1
	bl	buf_alloc
	ldr	w1, [x29, 140]
	mov	x27, x0
	stp	w22, w1, [x0, 36]
	mov	w1, 1
	bl	sblk_read_page
	ldr	x0, [x27, 24]
	ldr	w23, [x0, 12]
	ldr	w0, [x0, 4]
	add	w23, w23, 1
	cmp	w22, w0
	bne	.L2941
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L2942
.L2941:
	ldrb	w1, [x27, 1]
	mov	w3, w22
	ldr	w4, [x27, 52]
	adrp	x0, .LC208
	ldr	w2, [x29, 140]
	add	x0, x0, :lo12:.LC208
	bl	printf
	ldr	x1, [x27, 24]
	mov	w3, 4
	adrp	x0, .LC154
	mov	w2, w3
	add	x0, x0, :lo12:.LC154
	bl	rknand_print_hex
	adrp	x0, .LANCHOR96
	ldr	w1, [x29, 140]
	ldrh	w3, [x0, #:lo12:.LANCHOR96]
	mov	w0, 21
	sub	w2, w0, w3
	mov	w0, 1
	lsr	w1, w1, w3
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR95
	ldrb	w2, [x1, #:lo12:.LANCHOR95]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
.L2942:
	ldr	x0, [x27, 24]
	ldr	w0, [x0, 4]
	cmp	w22, w0
	bne	.L2943
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L2944
.L2943:
	adrp	x1, .LANCHOR201
	adrp	x0, .LC0
	mov	w2, 544
	add	x1, x1, :lo12:.LANCHOR201
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2944:
	cbz	w21, .L2945
	ldr	w0, [x29, 140]
	lsl	w2, w21, 9
	cmn	w0, #1
	beq	.L2946
	ldr	x1, [x27, 8]
	mov	x0, x24
	bl	ftl_memcpy
.L2947:
	ldr	x19, [x25, #:lo12:.LANCHOR5]
	add	x19, x19, 48
.L2945:
	ldr	x0, [x29, 96]
	ldrb	w2, [x0, #:lo12:.LANCHOR117]
	cmp	w20, w2
	bcc	.L2948
	bls	.L2949
	ldr	x19, [x25, #:lo12:.LANCHOR5]
	add	x19, x19, 16
.L2949:
	cbz	x27, .L2936
	ldrb	w0, [x27, 2]
	mov	x1, x27
	and	w0, w0, -9
	strb	w0, [x27, 2]
	adrp	x0, .LANCHOR58
	add	x0, x0, :lo12:.LANCHOR58
	bl	buf_remove_buf
	mov	x0, x27
	bl	buf_free
.L2936:
	ldrh	w0, [x19, 6]
	cbnz	w0, .L2951
	bl	ftl_flush
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L2951:
	mov	x0, x19
	bl	ftl_get_new_free_page
	ldr	x1, [x29, 104]
	adrp	x20, .LANCHOR163
	lsl	x2, x1, 6
	add	x1, x26, x2
	ldr	w3, [x1, 32]
	stp	w3, w22, [x28]
	str	w23, [x28, 12]
	ldr	w3, [x29, 140]
	str	w3, [x28, 8]
	stp	w0, w3, [x1, 40]
	mov	w0, -1
	strb	w0, [x26, x2]
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
	add	x0, x20, :lo12:.LANCHOR163
	bl	buf_add_tail
	ldr	x0, [x29, 112]
	ldrb	w2, [x0, #:lo12:.LANCHOR115]
	add	w2, w2, 1
	and	w2, w2, 255
	strb	w2, [x0, #:lo12:.LANCHOR115]
	adrp	x0, .LANCHOR202
	cmp	w2, 2
	str	wzr, [x0, #:lo12:.LANCHOR202]
	ldrh	w0, [x19, 6]
	bhi	.L2952
	cmp	w0, 1
	bne	.L2925
.L2952:
	ldrb	w1, [x19, 5]
	cmp	w1, 0
	mov	w1, 0
	cset	w4, ne
	cmp	w0, 1
	ldrb	w0, [x20, #:lo12:.LANCHOR163]
	csinc	w4, w2, w4, eq
	mov	w3, w0
.L2956:
	cmp	w1, w4
	bne	.L2957
	strb	w3, [x20, #:lo12:.LANCHOR163]
	and	w1, w1, 255
	ldr	x3, [x29, 112]
	sub	w2, w2, w1
	ubfiz	x0, x0, 6, 8
	add	x0, x26, x0
	strb	w2, [x3, #:lo12:.LANCHOR115]
	bl	sblk_prog_page
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bne	.L2925
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	mov	x0, x19
	bl	ftl_write_last_log_page
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L2925:
	adrp	x0, .LANCHOR53
	ldrb	w0, [x0, #:lo12:.LANCHOR53]
	cbnz	w0, .L2922
.L2924:
	bl	ftl_write_completed
	mov	w0, 0
	b	.L2921
.L2948:
	ldr	w0, [x29, 140]
	sub	w2, w2, w20
	lsl	w2, w2, 9
	cmn	w0, #1
	ubfiz	x0, x20, 7, 9
	beq	.L2950
	ldr	x1, [x27, 8]
	lsl	x0, x0, 2
	add	x1, x1, x0
	add	x0, x24, x0
	bl	ftl_memcpy
	b	.L2949
.L2950:
	mov	w1, 0
	add	x0, x24, x0, lsl 2
	bl	ftl_memset
	b	.L2949
.L2957:
	ubfiz	x3, x3, 6, 8
	add	w1, w1, 1
	ldrb	w3, [x26, x3]
	b	.L2956
.L2958:
	lsl	w2, w21, 9
	mov	x27, 0
	mov	w23, 0
.L2946:
	mov	w1, 0
	mov	x0, x24
	bl	ftl_memset
	b	.L2947
.L2940:
	cbnz	w21, .L2958
	mov	w23, 0
	mov	x27, 0
	b	.L2945
	.size	ftl_write_commit, .-ftl_write_commit
	.section	.text.gc_do_copy_back,"ax",@progbits
	.align	2
	.global	gc_do_copy_back
	.type	gc_do_copy_back, %function
gc_do_copy_back:
	sub	sp, sp, #224
	adrp	x0, .LANCHOR70
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	stp	x19, x20, [sp, 32]
	stp	x21, x22, [sp, 48]
	stp	x23, x24, [sp, 64]
	stp	x25, x26, [sp, 80]
	stp	x27, x28, [sp, 96]
	cbnz	w0, .L2982
	bl	buf_alloc
	mov	x19, x0
	cbz	x0, .L2981
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
	bne	.L2984
	adrp	x0, .LANCHOR96
	ldrh	w1, [x0, #:lo12:.LANCHOR96]
	mov	w0, 21
	sub	w2, w0, w1
	mov	w0, 1
	lsr	w1, w22, w1
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR95
	ldrb	w2, [x1, #:lo12:.LANCHOR95]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
.L2984:
	ldr	w0, [x19, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L2985
	adrp	x1, .LANCHOR203
	adrp	x0, .LC0
	mov	w2, 573
	add	x1, x1, :lo12:.LANCHOR203
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2985:
	ldr	x0, [x19, 24]
	ldr	w21, [x0, 4]
	mov	w0, w21
	bl	lpa_hash_get_ppa
	str	w0, [x29, 160]
	cmn	w0, #1
	bne	.L2986
	mov	w2, 0
	add	x1, x29, 160
	mov	w0, w21
	bl	pm_log2phys
.L2986:
	ldr	w23, [x29, 160]
	cmp	w22, w23
	bne	.L2987
	adrp	x0, .LANCHOR46
	add	x0, x0, :lo12:.LANCHOR46
	add	x1, x0, 2
	add	x0, x0, 2050
.L2990:
	ldr	w2, [x1, 34]
	cmp	w21, w2
	bne	.L2988
	ldrb	w2, [x1]
	tbz	x2, 1, .L2988
	mov	x0, x19
	bl	buf_free
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L2981
	add	x20, x20, :lo12:.LANCHOR63
	adrp	x0, .LC209
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC209
	ldrh	w3, [x20, 26]
	bl	printf
.L2981:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 224
	ret
.L2988:
	add	x1, x1, 64
	cmp	x0, x1
	bne	.L2990
	adrp	x0, .LANCHOR117
	mov	w1, 10
	strb	wzr, [x19, 57]
	ldrb	w0, [x0, #:lo12:.LANCHOR117]
	strb	w0, [x19, 56]
	ldrb	w0, [x19, 2]
	str	w21, [x19, 36]
	orr	w0, w0, w1
	strb	w0, [x19, 2]
	ldr	x0, [x19, 24]
	ldr	w0, [x0]
	str	w0, [x19, 32]
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L2991
	mov	w0, w21
	bl	lpa_hash_get_ppa
	add	x1, x20, :lo12:.LANCHOR63
	mov	w3, w0
	mov	w4, w22
	adrp	x0, .LC210
	mov	w2, w23
	add	x0, x0, :lo12:.LC210
	ldrh	w5, [x1, 26]
	mov	w1, w21
	bl	printf
.L2991:
	mov	x0, x19
	bl	ftl_gc_write_buf
	bl	ftl_write_commit
	add	x20, x20, :lo12:.LANCHOR63
	adrp	x0, .LANCHOR97
	ldr	x1, [x0, #:lo12:.LANCHOR97]
	ldr	w0, [x1, 60]
	add	w0, w0, 1
	str	w0, [x1, 60]
	ldrh	w0, [x20, 28]
	add	w0, w0, 1
	strh	w0, [x20, 28]
	b	.L2981
.L2987:
	adrp	x0, .LANCHOR7
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L2992
	add	x20, x20, :lo12:.LANCHOR63
	mov	w0, w21
	bl	lpa_hash_get_ppa
	mov	w3, w0
	mov	w4, w22
	adrp	x0, .LC210
	ldrh	w5, [x20, 26]
	mov	w2, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC210
	bl	printf
.L2992:
	mov	x0, x19
	bl	buf_free
	b	.L2981
.L2982:
	adrp	x1, .LANCHOR5
	adrp	x0, .LANCHOR67
	stp	x0, x1, [x29, 128]
	adrp	x24, .LANCHOR63
	ldr	x22, [x1, #:lo12:.LANCHOR5]
	ldrb	w25, [x0, #:lo12:.LANCHOR67]
	add	x22, x22, 80
	cmp	w25, 3
	bne	.L2993
	adrp	x0, .LANCHOR69
	ldrb	w0, [x0, #:lo12:.LANCHOR69]
	cbz	w0, .L2994
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w19, [x22, 9]
	ldrh	w20, [x0, 314]
	add	w21, w19, w19, lsl 1
	sub	w19, w19, w19, lsl 2
	sdiv	w21, w20, w21
	madd	w19, w21, w19, w20
	and	w19, w19, 65535
.L2995:
	adrp	x1, .LANCHOR71
	ldrb	w0, [x22, 9]
	add	x4, x24, :lo12:.LANCHOR63
	mov	w2, 0
	ldrh	w3, [x1, #:lo12:.LANCHOR71]
	mul	w8, w25, w0
	ldrh	w10, [x4, 24]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR140
	ldr	x7, [x0, #:lo12:.LANCHOR140]
	sub	w3, w3, #1
.L2998:
	cmp	w2, w8
	blt	.L3000
.L3027:
	mov	w23, 1
	b	.L2996
.L2994:
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w20, [x22, 9]
	ldrh	w1, [x0, 314]
	adrp	x0, .LANCHOR204
	add	x0, x0, :lo12:.LANCHOR204
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
	beq	.L2995
.L2996:
	adrp	x0, .LANCHOR7
	str	x0, [x29, 112]
	ldr	w1, [x0, #:lo12:.LANCHOR7]
	tbz	x1, 8, .L3001
	adrp	x0, .LANCHOR140
	ubfiz	x1, x20, 2, 16
	mov	w6, w20
	mov	w3, w19
	ldr	x2, [x0, #:lo12:.LANCHOR140]
	add	x0, x24, :lo12:.LANCHOR63
	ldrh	w4, [x0, 314]
	adrp	x0, .LC211
	ldr	w5, [x2, x1]
	add	x0, x0, :lo12:.LC211
	mov	w2, w23
	mov	w1, w21
	bl	printf
.L3001:
	adrp	x0, .LANCHOR46
	str	wzr, [x29, 152]
	add	x0, x0, :lo12:.LANCHOR46
	str	x0, [x29, 120]
.L3002:
	ldrb	w2, [x22, 9]
	ldr	w0, [x29, 152]
	ldrh	w26, [x29, 152]
	and	w0, w0, 65535
	str	w0, [x29, 156]
	mul	w1, w25, w2
	cmp	w0, w1
	blt	.L3014
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	cmp	w0, 3
	add	x0, x29, 160
	beq	.L3015
	sub	w3, w1, #1
	mov	w2, 0
.L3016:
	cmp	w2, w3
	blt	.L3022
	ldr	x0, [x0, w3, sxtw 3]
	mov	w2, -1
	strb	w2, [x0]
	ldr	x0, [x29, 160]
	bl	sblk_prog_page
	b	.L3021
.L2993:
	adrp	x0, .LANCHOR102
	ldrb	w0, [x0, #:lo12:.LANCHOR102]
	cbnz	w0, .L2997
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w19, [x22, 9]
	mov	w25, 1
	ldrh	w20, [x0, 314]
	sdiv	w21, w20, w19
	msub	w19, w21, w19, w20
	and	w19, w19, 65535
	b	.L2995
.L2997:
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w19, [x22, 9]
	mov	w25, 2
	ldrh	w20, [x0, 314]
	sdiv	w21, w20, w19
	msub	w19, w21, w19, w20
	and	w19, w19, 65535
	b	.L2995
.L3000:
	add	w5, w20, w2
	cmp	w5, w3
	beq	.L3027
	sbfiz	x5, x5, 2, 32
	ldr	w0, [x7, x5]
	cmn	w0, #1
	bne	.L2999
	ldrh	w6, [x4, 26]
	cmp	w6, w10
	bcs	.L2981
	mov	w0, w6
	bl	gc_get_src_ppa_from_index
	add	w6, w6, 1
	strh	w6, [x4, 26]
	str	w0, [x7, x5]
.L2999:
	add	w2, w2, 1
	and	w2, w2, 65535
	b	.L2998
.L3014:
	ldr	w0, [x29, 156]
	add	w0, w20, w0
	str	w0, [x29, 144]
	sxtw	x27, w0
	adrp	x0, .LANCHOR68
	ldr	x0, [x0, #:lo12:.LANCHOR68]
	ldrb	w0, [x0, x27]
	cmp	w0, 255
	bne	.L3003
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L3004
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	bl	gc_write_completed
	bl	gc_free_temp_buf
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbz	x0, .L2981
.L3004:
	adrp	x0, .LANCHOR68
	ldrb	w1, [x28, 1]
	adrp	x5, .LANCHOR71
	adrp	x6, .LANCHOR140
	ldr	x0, [x0, #:lo12:.LANCHOR68]
	strb	w1, [x0, x27]
	add	x1, x24, :lo12:.LANCHOR63
	strb	w23, [x28, 61]
	ldrh	w7, [x5, #:lo12:.LANCHOR71]
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
	bne	.L3005
	adrp	x0, .LANCHOR139
	adrp	x4, .LANCHOR72
	stp	x6, x5, [x29, 96]
	ldr	x1, [x0, #:lo12:.LANCHOR139]
	mov	w0, -1
	str	x4, [x29, 144]
	str	w0, [x1, x27, lsl 2]
	ldr	x0, [x28, 8]
	ldrb	w2, [x4, #:lo12:.LANCHOR72]
	mul	w2, w2, w7
	lsl	w2, w2, 2
	bl	ftl_memcpy
	ldp	x6, x5, [x29, 96]
	ldr	x4, [x29, 144]
	ldr	x7, [x28, 8]
	ldrh	w0, [x5, #:lo12:.LANCHOR71]
	ldrb	w1, [x4, #:lo12:.LANCHOR72]
	mul	w0, w0, w1
	ldr	x1, [x6, #:lo12:.LANCHOR140]
	lsl	w2, w0, 2
	add	x0, x7, x0, sxtw 2
	bl	ftl_memcpy
	adrp	x0, .LANCHOR117
	mov	w1, 0
	ldrb	w2, [x0, #:lo12:.LANCHOR117]
	ldr	x0, [x28, 24]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x6, [x28, 24]
	mov	w0, 15555
	ldr	x5, [x29, 104]
	movk	w0, 0xf55f, lsl 16
	ldr	x4, [x29, 144]
	ldrh	w1, [x5, #:lo12:.LANCHOR71]
	str	w0, [x6]
	ldrb	w0, [x4, #:lo12:.LANCHOR72]
	mul	w1, w1, w0
	ldr	x0, [x28, 8]
	lsl	w1, w1, 2
	bl	js_hash
	str	w0, [x6, 4]
	ldr	x0, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldr	w0, [x0, 132]
	str	w0, [x6, 8]
.L3003:
	adrp	x0, .LANCHOR68
	ldr	w5, [x29, 156]
	add	x3, x29, 160
	ldr	x4, [x0, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR46
	add	x2, x0, :lo12:.LANCHOR46
	ldrb	w1, [x4, x27]
	ubfiz	x0, x1, 6, 8
	add	x0, x2, x0
	add	x2, x2, x1, lsl 6
	str	x0, [x3, w5, sxtw 3]
	mov	w0, 2
	adrp	x5, .LANCHOR141
	strh	w0, [x2, 50]
	ldr	x0, [x29, 128]
	strb	w23, [x2, 61]
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	cmp	w0, 3
	bne	.L3009
	udiv	w0, w26, w0
	adrp	x6, .LANCHOR103
	ldrh	w6, [x6, #:lo12:.LANCHOR103]
	add	w3, w0, w19
	add	w0, w0, w0, lsl 1
	add	x3, x22, x3, sxtw 1
	sub	w0, w26, w0
	and	w0, w0, 65535
	add	w0, w0, 1
	ldrh	w3, [x3, 16]
	mul	w3, w3, w6
	ldrh	w6, [x2, 48]
	orr	w3, w3, w21
	str	w3, [x2, 40]
	ldr	x2, [x5, #:lo12:.LANCHOR141]
	orr	w0, w3, w0, lsl 24
	str	w0, [x2, x6, lsl 2]
.L3010:
	ldr	x0, [x29, 112]
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L3013
	ldr	x0, [x29, 120]
	mov	w2, w23
	ldrb	w4, [x4, x27]
	add	x1, x0, x1, lsl 6
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w3, [x0, 6]
	ldr	x0, [x1, 24]
	ldrb	w7, [x1, 1]
	ldrh	w6, [x1, 48]
	ldr	w0, [x0, 4]
	str	w0, [sp, 8]
	mov	w0, 3
	udiv	w26, w26, w0
	adrp	x0, .LC212
	add	x0, x0, :lo12:.LC212
	add	w26, w26, w19
	str	w26, [sp]
	ldr	w5, [x1, 40]
	ldr	w1, [x29, 156]
	bl	printf
.L3013:
	ldr	w0, [x29, 152]
	add	w0, w0, 1
	str	w0, [x29, 152]
	b	.L3002
.L3005:
	lsl	x0, x27, 2
	str	x0, [x29, 144]
	ldr	x0, [x6, #:lo12:.LANCHOR140]
	lsl	x1, x27, 2
	ldr	w0, [x0, x1]
	mov	w1, 1
	str	w0, [x28, 40]
	mov	x0, x28
	bl	sblk_read_page
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3007
	adrp	x0, .LANCHOR96
	ldr	w1, [x28, 40]
	ldrh	w4, [x0, #:lo12:.LANCHOR96]
	mov	w0, 21
	sub	w2, w0, w4
	mov	w0, 1
	lsr	w1, w1, w4
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR95
	ldrb	w2, [x1, #:lo12:.LANCHOR95]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L3007
	ldr	x0, [x28, 24]
	mov	w1, -1
	str	w1, [x0, 4]
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmp	w0, w1, 4, ne
	bne	.L3007
	adrp	x1, .LANCHOR203
	adrp	x0, .LC0
	mov	w2, 688
	add	x1, x1, :lo12:.LANCHOR203
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3007:
	ldr	x0, [x28, 24]
	adrp	x1, .LANCHOR54
	ldr	w1, [x1, #:lo12:.LANCHOR54]
	ldr	w2, [x0, 4]
	cmp	w2, w1
	bcc	.L3008
	mov	w1, -1
	str	w1, [x0, 4]
.L3008:
	adrp	x1, .LANCHOR139
	lsl	x3, x27, 2
	ldr	w2, [x0, 4]
	ldr	x1, [x1, #:lo12:.LANCHOR139]
	str	w2, [x1, x3]
	ldr	w1, [x28, 40]
	str	w1, [x0, 8]
	b	.L3003
.L3009:
	cmp	w0, 2
	bne	.L3011
	adrp	x0, .LANCHOR102
	adrp	x3, .LANCHOR103
	ldrb	w0, [x0, #:lo12:.LANCHOR102]
	cbnz	w0, .L3012
	ldr	w0, [x29, 156]
	ldrh	w3, [x3, #:lo12:.LANCHOR103]
	add	w0, w19, w0
	add	x0, x22, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w3, w21
.L3073:
	orr	w0, w0, 33554432
	str	w0, [x2, 40]
.L3011:
	ldr	x0, [x29, 120]
	add	x0, x0, x1, lsl 6
	ldrh	w2, [x0, 48]
	ldr	w3, [x0, 40]
	ldr	x0, [x5, #:lo12:.LANCHOR141]
	str	w3, [x0, x2, lsl 2]
	b	.L3010
.L3012:
	add	w0, w19, w26, lsr 1
	ldrh	w3, [x3, #:lo12:.LANCHOR103]
	add	x0, x22, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w3, w21
	and	w3, w26, 1
	add	w0, w0, w3
	b	.L3073
.L3015:
	adrp	x1, .LANCHOR69
	ldrb	w3, [x1, #:lo12:.LANCHOR69]
	ldr	x1, [x29, 160]
	cbz	w3, .L3017
.L3020:
	strb	wzr, [x1, 60]
	b	.L3018
.L3017:
	cmp	w23, 1
	bne	.L3019
	mov	w3, 9
.L3072:
	strb	w3, [x1, 60]
.L3018:
	add	x1, x0, 24
	bl	sblk_xlc_prog_pages
.L3021:
	adrp	x1, .LANCHOR69
	ldrb	w3, [x22, 9]
	ldrb	w1, [x1, #:lo12:.LANCHOR69]
	and	w0, w3, 65535
	cbz	w1, .L3023
	add	w0, w0, w0, lsl 1
.L3024:
	adrp	x1, .LANCHOR97
	add	x24, x24, :lo12:.LANCHOR63
	ldr	x1, [x1, #:lo12:.LANCHOR97]
	ldr	w2, [x1, 52]
	add	w2, w2, w0
	str	w2, [x1, 52]
	ldrh	w1, [x24, 314]
	add	w0, w0, w1
	adrp	x1, .LANCHOR71
	and	w0, w0, 65535
	strh	w0, [x24, 314]
	ldrh	w1, [x1, #:lo12:.LANCHOR71]
	mul	w1, w1, w3
	cmp	w0, w1
	blt	.L3025
	ldr	x0, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	strh	wzr, [x0, 86]
.L3025:
	bl	gc_write_completed
	b	.L2981
.L3019:
	cmp	w23, 2
	bne	.L3020
	mov	w3, 13
	b	.L3072
.L3022:
	ldr	x4, [x0, w2, sxtw 3]
	add	w2, w2, 1
	ldr	x5, [x0, w2, sxtw 3]
	and	w2, w2, 65535
	ldrb	w5, [x5, 1]
	strb	w5, [x4]
	b	.L3016
.L3023:
	adrp	x1, .LANCHOR102
	ldrb	w2, [x1, #:lo12:.LANCHOR102]
	mov	w1, w0
	ubfiz	w0, w0, 1, 15
	cmp	w2, 0
	csel	w0, w0, w1, ne
	b	.L3024
	.size	gc_do_copy_back, .-gc_do_copy_back
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
	bcc	.L3095
	adrp	x24, .LANCHOR205
	add	w22, w0, 24576
	adrp	x0, .LANCHOR7
	str	x0, [x29, 104]
	ldr	w1, [x24, #:lo12:.LANCHOR205]
	ldr	w2, [x0, #:lo12:.LANCHOR7]
	add	w1, w19, w1
	str	w1, [x24, #:lo12:.LANCHOR205]
	tbz	x2, 12, .L3076
	adrp	x0, .LC213
	mov	w4, 0
	mov	w3, w19
	mov	w2, w22
	add	x0, x0, :lo12:.LC213
	bl	printf
.L3076:
	adrp	x23, .LANCHOR97
	adrp	x26, .LANCHOR117
	ldr	x0, [x23, #:lo12:.LANCHOR97]
	ldr	w27, [x0, 8]
	add	w1, w27, 1
	str	w1, [x0, 8]
	bl	ftl_write_commit
	bl	ftl_flush
	ldrb	w21, [x26, #:lo12:.LANCHOR117]
	udiv	w20, w22, w21
	msub	w25, w20, w21, w22
	cbz	w25, .L3077
	sub	w21, w21, w25
	mov	w0, w20
	cmp	w21, w19
	csel	w21, w21, w19, ls
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	bne	.L3078
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
.L3078:
	ldr	w0, [x29, 120]
	and	w28, w21, 65535
	cmn	w0, #1
	beq	.L3080
	mov	w0, 0
	bl	buf_alloc
	mov	x3, x0
	cbz	x0, .L3080
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
.L3080:
	add	w20, w20, 1
	sub	w19, w19, w28
.L3077:
	cbz	w19, .L3082
	bl	ftl_flush
.L3082:
	adrp	x25, .LANCHOR96
	add	x21, x26, :lo12:.LANCHOR117
	add	x25, x25, :lo12:.LANCHOR96
	mov	w0, -1
	str	w0, [x29, 124]
.L3083:
	ldrb	w0, [x21]
	cmp	w19, w0
	bcs	.L3088
	cbz	w19, .L3090
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	bne	.L3091
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
.L3091:
	ldr	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3090
	mov	w0, 0
	bl	buf_alloc
	mov	x21, x0
	cbz	x0, .L3090
	strb	wzr, [x0, 57]
	strb	w19, [x0, 56]
	stp	w27, w20, [x21, 32]
	ldrb	w0, [x26, #:lo12:.LANCHOR117]
	cmp	w19, w0
	bcc	.L3093
	adrp	x1, .LANCHOR206
	adrp	x0, .LC0
	mov	w2, 1177
	add	x1, x1, :lo12:.LANCHOR206
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3093:
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
.L3090:
	ldr	w1, [x24, #:lo12:.LANCHOR205]
	cmp	w1, 8192
	bls	.L3096
	ldr	x0, [x29, 104]
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 12, .L3094
	adrp	x0, .LC213
	mov	w4, 0
	mov	w3, w19
	mov	w2, w22
	add	x0, x0, :lo12:.LC213
	bl	printf
.L3094:
	str	wzr, [x24, #:lo12:.LANCHOR205]
	bl	flt_sys_flush
	adrp	x0, .LANCHOR207
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR207]
.L3096:
	mov	w0, 0
	b	.L3074
.L3088:
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3084
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbz	x0, .L3086
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
.L3122:
	ldr	x1, [x23, #:lo12:.LANCHOR97]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L3086:
	ldrb	w0, [x21]
	add	w20, w20, 1
	sub	w19, w19, w0
	b	.L3083
.L3084:
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
	ldr	w0, [x29, 120]
	cmn	w0, #1
	beq	.L3086
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
	adrp	x1, .LANCHOR95
	ldrb	w1, [x1, #:lo12:.LANCHOR95]
	udiv	w0, w0, w1
	bl	ftl_vpn_decrement
	b	.L3122
.L3095:
	mov	w0, -1
.L3074:
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
	.section	.text.zftl_do_gc,"ax",@progbits
	.align	2
	.global	zftl_do_gc
	.type	zftl_do_gc, %function
zftl_do_gc:
	sub	sp, sp, #96
	adrp	x2, .LANCHOR89
	adrp	x1, .LANCHOR93
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x19, .LANCHOR138
	stp	x23, x24, [sp, 64]
	adrp	x24, .LANCHOR5
	ldrh	w20, [x2, #:lo12:.LANCHOR89]
	stp	x21, x22, [sp, 48]
	ldrb	w2, [x19, #:lo12:.LANCHOR138]
	ldrh	w21, [x1, #:lo12:.LANCHOR93]
	stp	x25, x26, [sp, 80]
	cmp	w2, 6
	ldr	x23, [x24, #:lo12:.LANCHOR5]
	add	w20, w21, w20
	bhi	.L3231
	mov	w22, w0
	and	w20, w20, 65535
	adrp	x0, .L3127
	mov	x25, x1
	add	x0, x0, :lo12:.L3127
	ldrh	w0, [x0,w2,uxtw #1]
	adr	x1, .Lrtx3127
	add	x0, x1, w0, sxth #2
	br	x0
.Lrtx3127:
	.section	.rodata.zftl_do_gc,"a",@progbits
	.align	0
	.align	2
.L3127:
	.2byte	(.L3126 - .Lrtx3127) / 4
	.2byte	(.L3128 - .Lrtx3127) / 4
	.2byte	(.L3129 - .Lrtx3127) / 4
	.2byte	(.L3130 - .Lrtx3127) / 4
	.2byte	(.L3131 - .Lrtx3127) / 4
	.2byte	(.L3132 - .Lrtx3127) / 4
	.2byte	(.L3133 - .Lrtx3127) / 4
	.section	.text.zftl_do_gc
.L3132:
	adrp	x21, .LANCHOR63
	add	x25, x21, :lo12:.LANCHOR63
	mov	w23, 0
.L3134:
	bl	gc_check_data_one_wl
	cbz	w0, .L3199
	ldr	x0, [x24, #:lo12:.LANCHOR5]
	add	x21, x21, :lo12:.LANCHOR63
	strh	wzr, [x21, 56]
	ldrh	w0, [x0, 80]
	bl	ftl_free_sblk
	adrp	x2, .LANCHOR97
	ldr	x1, [x24, #:lo12:.LANCHOR5]
	mov	w0, -1
	ldr	x2, [x2, #:lo12:.LANCHOR97]
	strh	w0, [x1, 80]
	strh	w0, [x2, 126]
	strh	w0, [x1, 130]
	ldr	x0, [x21, 8]
	bl	buf_free
	strb	wzr, [x19, #:lo12:.LANCHOR138]
	str	xzr, [x21, 8]
	b	.L3255
.L3126:
	adrp	x0, .LANCHOR91
	mov	w1, 65535
	ldrh	w4, [x0, #:lo12:.LANCHOR91]
	ldrh	w0, [x23, 80]
	add	w21, w21, w4
	and	w21, w21, 65535
	cmp	w0, w1
	beq	.L3135
	adrp	x1, .LANCHOR7
	cmp	w21, 7
	mov	w22, 3
	adrp	x24, .LANCHOR70
	ldr	w1, [x1, #:lo12:.LANCHOR7]
	csinc	w22, w22, wzr, hi
	tbz	x1, 8, .L3137
	ldrh	w7, [x23, 122]
	mov	w4, w21
	ldrh	w6, [x23, 120]
	mov	w3, w20
	ldrh	w5, [x23, 124]
	mov	w1, 1705
	ldrb	w2, [x24, #:lo12:.LANCHOR70]
	str	w0, [sp]
	adrp	x0, .LC214
	add	x0, x0, :lo12:.LC214
	bl	printf
.L3137:
	ldrb	w0, [x24, #:lo12:.LANCHOR70]
	mov	w2, 1
	mov	w1, w22
	bl	gc_search_src_blk
	cmp	w0, 0
	ble	.L3231
.L3138:
	mov	w0, 1
.L3254:
	strb	w0, [x19, #:lo12:.LANCHOR138]
	b	.L3231
.L3135:
	adrp	x0, .LANCHOR84
	cmp	w22, 1
	ldrh	w25, [x0, #:lo12:.LANCHOR84]
	adrp	x0, .LANCHOR82
	ldrh	w26, [x0, #:lo12:.LANCHOR82]
	bne	.L3139
	bl	gc_scan_static_data
	bl	gc_static_wearleveling
.L3140:
	ldr	x2, [x24, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR70
	mov	w0, 1
	mov	x24, x1
	strb	w0, [x1, #:lo12:.LANCHOR70]
	ldrh	w5, [x2, 124]
	cbz	w5, .L3142
	strb	w0, [x19, #:lo12:.LANCHOR138]
	adrp	x0, .LANCHOR7
	strb	wzr, [x1, #:lo12:.LANCHOR70]
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L3231
	ldrh	w7, [x2, 122]
	mov	w4, w21
	ldrh	w6, [x2, 120]
	mov	w3, w20
	mov	w2, 0
	mov	w1, 1762
	adrp	x0, .LC215
	add	x0, x0, :lo12:.LC215
	bl	printf
	b	.L3231
.L3139:
	adrp	x0, .LANCHOR73
	ldrh	w0, [x0, #:lo12:.LANCHOR73]
	cmp	w0, w20
	bcs	.L3140
.L3231:
	mov	w0, 16
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 96
	ret
.L3142:
	adrp	x23, .LANCHOR73
	ldrh	w1, [x23, #:lo12:.LANCHOR73]
	cmp	w20, w1
	bcs	.L3143
	cmp	w21, 1
	bls	.L3144
	cmp	w21, 16
	bls	.L3145
	adrp	x1, .LANCHOR86
	ldrh	w2, [x1, #:lo12:.LANCHOR86]
	adrp	x1, .LANCHOR87
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	cmp	w2, w1
	bcs	.L3145
	mov	w2, 16
	mov	w1, 3
.L3251:
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L3146:
	cbnz	w0, .L3138
	b	.L3231
.L3145:
	mov	w2, 2
	mov	w1, w2
	mov	w0, 1
.L3257:
	bl	gc_search_src_blk
	tst	w0, 65535
	bne	.L3138
	mov	w2, 2
	b	.L3252
.L3144:
	adrp	x0, .LANCHOR7
	strb	wzr, [x24, #:lo12:.LANCHOR70]
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	tbz	x0, 8, .L3148
	ldrh	w7, [x2, 122]
	adrp	x0, .LC215
	ldrh	w6, [x2, 120]
	mov	w5, 0
	mov	w4, w21
	mov	w3, w20
	mov	w2, 0
	mov	w1, 1778
	add	x0, x0, :lo12:.LC215
	bl	printf
.L3148:
	cmp	w20, 16
	bls	.L3149
	mov	w2, 4
.L3252:
	mov	w1, 3
	ldrb	w0, [x24, #:lo12:.LANCHOR70]
	b	.L3251
.L3149:
	mov	w2, 1
	ldrb	w0, [x24, #:lo12:.LANCHOR70]
	mov	w1, w2
	b	.L3257
.L3143:
	cmp	w22, 1
	lsl	w1, w1, 1
	bne	.L3151
	cmp	w20, w1
	bge	.L3151
	add	w0, w25, w26
	and	w0, w0, 65535
	cmp	w0, w21, lsr 1
	bcs	.L3152
	adrp	x1, .LANCHOR86
	ldrh	w2, [x1, #:lo12:.LANCHOR86]
	adrp	x1, .LANCHOR87
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	cmp	w2, w1
	bcs	.L3152
.L3156:
	adrp	x0, .LANCHOR83
	ldrh	w0, [x0, #:lo12:.LANCHOR83]
	lsr	w0, w0, 1
	strh	w0, [x23, #:lo12:.LANCHOR73]
	b	.L3231
.L3152:
	cmp	w21, 1
	adrp	x22, .LANCHOR83
	bls	.L3153
	cmp	w21, 16
	bls	.L3154
	mov	w2, 8
	mov	w1, 3
	mov	w0, 1
.L3249:
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L3155:
	ldrh	w1, [x22, #:lo12:.LANCHOR83]
	strh	w1, [x23, #:lo12:.LANCHOR73]
	b	.L3146
.L3154:
	mov	w2, 2
	mov	w0, 1
	mov	w1, w2
	bl	gc_search_src_blk
	ands	w0, w0, 65535
	bne	.L3155
	mov	w2, 2
	mov	w1, 3
	ldrb	w0, [x24, #:lo12:.LANCHOR70]
	b	.L3249
.L3153:
	cmp	w20, w0
	bcs	.L3156
	strb	wzr, [x24, #:lo12:.LANCHOR70]
	mov	w2, 8
	mov	w1, 3
	mov	w0, 0
	b	.L3249
.L3151:
	cmp	w20, w1
	bge	.L3156
	b	.L3231
.L3128:
	adrp	x7, .LANCHOR63
	mov	w0, 65535
	ldrh	w1, [x7, #:lo12:.LANCHOR63]
	cmp	w1, w0
	bne	.L3157
	bl	gc_get_src_blk
	strh	w0, [x7, #:lo12:.LANCHOR63]
.L3157:
	ldrh	w3, [x7, #:lo12:.LANCHOR63]
	mov	w0, 65535
	add	x1, x7, :lo12:.LANCHOR63
	cmp	w3, w0
	beq	.L3158
	adrp	x0, .LANCHOR3
	ldrh	w5, [x1, 56]
	uxtw	x4, w3
	ldr	x2, [x0, #:lo12:.LANCHOR3]
	add	x2, x2, x4, lsl 2
	cbz	w5, .L3159
	add	x1, x1, 58
	mov	w0, 0
.L3161:
	ldrh	w6, [x1], 2
	cmp	w6, w3
	bne	.L3160
.L3165:
	adrp	x0, .LANCHOR63
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR63]
	b	.L3231
.L3160:
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w5, w0
	bne	.L3161
.L3159:
	ldrb	w0, [x2, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L3162
	tst	w0, 192
	bne	.L3163
.L3162:
	adrp	x0, .LANCHOR4
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	ldrh	w0, [x0, x4, lsl 1]
	cbz	w0, .L3165
	mov	w2, 1972
	adrp	x1, .LANCHOR208
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3165
.L3163:
	mov	w0, 2
	b	.L3254
.L3158:
	strb	wzr, [x19, #:lo12:.LANCHOR138]
	b	.L3231
.L3129:
	bl	gc_scan_src_blk
	cmn	w0, #1
	bne	.L3166
	mov	w0, 3
	b	.L3254
.L3166:
	adrp	x20, .LANCHOR63
	mov	w2, 65535
	add	x1, x20, :lo12:.LANCHOR63
	ldrh	w0, [x20, #:lo12:.LANCHOR63]
	cmp	w0, w2
	beq	.L3138
	ldrh	w2, [x1, 24]
	cbz	w2, .L3167
	mov	w0, 4
	strh	wzr, [x1, 26]
	strb	w0, [x19, #:lo12:.LANCHOR138]
	b	.L3231
.L3167:
	mov	w1, 1
	strb	w1, [x19, #:lo12:.LANCHOR138]
	adrp	x19, .LANCHOR4
	ubfiz	x0, x0, 1, 16
	ldr	x1, [x19, #:lo12:.LANCHOR4]
	ldrh	w0, [x1, x0]
	cbz	w0, .L3168
	adrp	x1, .LANCHOR208
	adrp	x0, .LC0
	mov	w2, 2000
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3168:
	ldrh	w0, [x20, #:lo12:.LANCHOR63]
	add	x21, x20, :lo12:.LANCHOR63
	ldr	x2, [x19, #:lo12:.LANCHOR4]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbnz	w1, .L3165
	bl	ftl_free_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR4]
	ldrh	w1, [x20, #:lo12:.LANCHOR63]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x21, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w0, 8
	bhi	.L3170
	strh	w0, [x21, 30]
	b	.L3165
.L3170:
	strh	wzr, [x21, 30]
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	b	.L3165
.L3130:
	adrp	x22, .LANCHOR63
	adrp	x23, .LANCHOR80
	add	x21, x22, :lo12:.LANCHOR63
	add	x23, x23, :lo12:.LANCHOR80
.L3232:
	bl	gc_scan_src_blk_one_page
	ldrh	w1, [x21, 2]
	ldrh	w0, [x23]
	cmp	w1, w0
	bcs	.L3171
	cmp	w20, 7
	bls	.L3232
	b	.L3231
.L3171:
	ldrh	w3, [x21, 24]
	adrp	x0, .LANCHOR7
	cbz	w3, .L3172
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	mov	w1, 4
	strh	wzr, [x21, 26]
	strb	w1, [x19, #:lo12:.LANCHOR138]
	adrp	x19, .LANCHOR4
	tbz	x0, 8, .L3173
	ldrh	w1, [x21]
	ldr	x2, [x19, #:lo12:.LANCHOR4]
	ubfiz	x0, x1, 1, 16
	ldrh	w2, [x2, x0]
	adrp	x0, .LC216
	add	x0, x0, :lo12:.LC216
	bl	printf
.L3173:
	ldrh	w2, [x22, #:lo12:.LANCHOR63]
	add	x0, x22, :lo12:.LANCHOR63
	ldr	x1, [x19, #:lo12:.LANCHOR4]
	ldrh	w0, [x0, 24]
	ldrh	w1, [x1, x2, lsl 1]
	cmp	w1, w0
	beq	.L3174
	adrp	x1, .LANCHOR208
	adrp	x0, .LC0
	mov	w2, 2034
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3174:
	add	x0, x22, :lo12:.LANCHOR63
	ldrh	w1, [x22, #:lo12:.LANCHOR63]
	ldrh	w2, [x0, 24]
	ldr	x0, [x19, #:lo12:.LANCHOR4]
	strh	w2, [x0, x1, lsl 1]
	b	.L3231
.L3172:
	adrp	x2, .LANCHOR3
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	ldrh	w1, [x21]
	ldr	x20, [x2, #:lo12:.LANCHOR3]
	mov	w2, 1
	strb	w2, [x19, #:lo12:.LANCHOR138]
	add	x20, x20, x1, uxth 2
	tbz	x0, 8, .L3175
	ldrb	w2, [x20, 2]
	adrp	x0, .LC217
	add	x0, x0, :lo12:.LC217
	ubfx	x2, x2, 5, 3
	bl	printf
.L3175:
	ldrb	w0, [x20, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L3176
	tst	w0, 192
	bne	.L3177
.L3176:
	adrp	x1, .LANCHOR208
	adrp	x0, .LC0
	mov	w2, 2044
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3177:
	ldrh	w0, [x22, #:lo12:.LANCHOR63]
	add	x19, x22, :lo12:.LANCHOR63
	bl	ftl_free_sblk
	mov	w0, -1
	strh	w0, [x22, #:lo12:.LANCHOR63]
	ldrh	w0, [x19, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w0, 8
	bhi	.L3178
	strh	w0, [x19, 30]
	b	.L3231
.L3178:
	strh	wzr, [x19, 30]
.L3255:
	bl	flt_sys_flush
	b	.L3231
.L3131:
	ldrh	w1, [x23, 80]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L3179
	adrp	x0, .LANCHOR70
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	cmp	w0, 1
	bne	.L3179
	bl	ftl_flush
	ldrh	w0, [x25, #:lo12:.LANCHOR93]
	cbz	w0, .L3180
.L3253:
	lsr	w0, w0, 1
	mov	w1, 5
	bl	zftl_get_free_sblk
	and	w21, w0, 65535
	mov	w19, w21
	mov	w0, 65535
	cmp	w21, w0
	beq	.L3182
	adrp	x0, .LANCHOR3
	ldr	x20, [x0, #:lo12:.LANCHOR3]
	add	x20, x20, x21, uxth 2
	ldrb	w0, [x20, 2]
	tst	w0, 224
	beq	.L3183
	adrp	x1, .LANCHOR208
	adrp	x0, .LC0
	mov	w2, 2069
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3183:
	ldrb	w0, [x20, 2]
	mov	w1, 5
	bfi	w0, w1, 5, 3
	orr	w0, w0, 16
	strb	w0, [x20, 2]
.L3202:
	mov	w1, 1
	mov	w0, w19
	bl	ftl_erase_sblk
	adrp	x22, .LANCHOR71
	mov	w0, 5
	strb	w0, [x23, 84]
	add	x1, x23, 96
	mov	w0, w19
	bl	ftl_get_blk_list_in_sblk
	and	w0, w0, 255
	adrp	x1, .LANCHOR80
	adrp	x20, .LANCHOR72
	strb	w0, [x23, 89]
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	ldrh	w2, [x22, #:lo12:.LANCHOR71]
	strh	w19, [x23, 80]
	strh	wzr, [x23, 82]
	mul	w0, w0, w1
	strb	wzr, [x23, 85]
	strh	w0, [x23, 86]
	mov	w1, 255
	ldrb	w0, [x20, #:lo12:.LANCHOR72]
	strh	wzr, [x23, 90]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR139
	ldr	x0, [x0, #:lo12:.LANCHOR139]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x20, #:lo12:.LANCHOR72]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR71]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR140
	ldr	x0, [x0, #:lo12:.LANCHOR140]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x20, #:lo12:.LANCHOR72]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR71]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR68
	ldr	x0, [x0, #:lo12:.LANCHOR68]
	bl	ftl_memset
	ldr	x0, [x24, #:lo12:.LANCHOR5]
	mov	w1, -1
	str	w21, [x0, 132]
	strh	w1, [x0, 128]
	strh	w1, [x0, 130]
	bl	pm_flush
	bl	ftl_ext_info_flush
	adrp	x0, .LANCHOR97
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	strh	w19, [x0, 126]
	adrp	x0, .LANCHOR63
	add	x0, x0, :lo12:.LANCHOR63
	str	w1, [x0, 320]
	strh	wzr, [x0, 314]
	strh	wzr, [x0, 56]
	strh	wzr, [x0, 316]
	strh	wzr, [x0, 318]
	mov	w0, 0
	bl	ftl_info_flush
	b	.L3231
.L3180:
	adrp	x0, .LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	b	.L3253
.L3179:
	cmp	w22, 1
	mov	w22, 4
	csinc	w22, w22, wzr, eq
	cmp	w20, 15
	mov	w0, w22
	add	w22, w22, 4
	adrp	x25, .LANCHOR70
	adrp	x21, .LANCHOR63
	csel	w22, w22, w0, ls
	add	x25, x25, :lo12:.LANCHOR70
	add	x20, x21, :lo12:.LANCHOR63
	add	x26, x23, 80
.L3186:
	sub	w22, w22, #1
	and	w22, w22, 255
	cmp	w22, 255
	beq	.L3231
	bl	gc_do_copy_back
	ldrb	w0, [x25]
	cbnz	w0, .L3187
	adrp	x0, .LANCHOR48
	ldrb	w0, [x0, #:lo12:.LANCHOR48]
	cmp	w0, 3
	bhi	.L3188
	bl	ftl_write_commit
.L3188:
	ldrh	w1, [x20, 26]
	ldrh	w0, [x20, 24]
	cmp	w1, w0
	bcc	.L3186
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR138]
	bl	ftl_write_commit
	bl	ftl_flush
	adrp	x0, .LANCHOR4
	ldrh	w2, [x20]
	mov	x20, x0
	ldr	x1, [x0, #:lo12:.LANCHOR4]
	ldrh	w1, [x1, x2, lsl 1]
	cbz	w1, .L3190
	adrp	x1, .LANCHOR208
	adrp	x0, .LC0
	mov	w2, 2144
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC0
	bl	printf
.L3190:
	ldrh	w1, [x21, #:lo12:.LANCHOR63]
	add	x19, x21, :lo12:.LANCHOR63
	ldr	x2, [x20, #:lo12:.LANCHOR4]
	ubfiz	x0, x1, 1, 16
	ldrh	w2, [x2, x0]
	cbnz	w2, .L3191
	mov	w0, w1
	bl	ftl_free_sblk
	b	.L3165
.L3191:
	ldrh	w3, [x19, 24]
	adrp	x22, .LANCHOR64
	adrp	x0, .LC218
	add	x0, x0, :lo12:.LC218
	bl	printf
	ldr	x1, [x22, #:lo12:.LANCHOR64]
	mov	w2, 4
	ldrh	w3, [x19, 24]
	adrp	x0, .LC219
	add	x0, x0, :lo12:.LC219
	add	w3, w3, 1
	bl	rknand_print_hex
	ldrh	w1, [x21, #:lo12:.LANCHOR63]
	ldr	x2, [x20, #:lo12:.LANCHOR4]
	ldrh	w5, [x19, 28]
	ubfiz	x0, x1, 1, 16
	ldrh	w4, [x19, 26]
	ldrh	w3, [x19, 24]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC220
	add	x0, x0, :lo12:.LC220
	bl	printf
	ldrh	w0, [x21, #:lo12:.LANCHOR63]
	mov	x1, 0
	bl	ftl_sblk_dump
	bl	gc_scan_src_blk
	ldrh	w1, [x21, #:lo12:.LANCHOR63]
	ldr	x2, [x20, #:lo12:.LANCHOR4]
	ldrh	w3, [x19, 24]
	ubfiz	x0, x1, 1, 16
	ldrh	w2, [x2, x0]
	adrp	x0, .LC221
	add	x0, x0, :lo12:.LC221
	bl	printf
	ldrh	w3, [x19, 24]
	mov	w2, 4
	ldr	x1, [x22, #:lo12:.LANCHOR64]
	adrp	x0, .LC222
	add	x0, x0, :lo12:.LC222
	bl	rknand_print_hex
	b	.L3165
.L3187:
	ldrh	w0, [x20, 318]
	cbz	w0, .L3192
	ldr	w0, [x20, 320]
	strh	wzr, [x20, 318]
	cmn	w0, #1
	beq	.L3193
	bl	ftl_mask_bad_block
.L3193:
	ldr	x0, [x24, #:lo12:.LANCHOR5]
	add	x20, x21, :lo12:.LANCHOR63
	strh	wzr, [x20, 56]
	ldrh	w0, [x0, 80]
	str	wzr, [x20, 320]
	bl	ftl_free_sblk
	adrp	x2, .LANCHOR97
	ldr	x1, [x24, #:lo12:.LANCHOR5]
	mov	w0, -1
	ldr	x2, [x2, #:lo12:.LANCHOR97]
	strh	w0, [x1, 80]
	strh	w0, [x2, 126]
	strh	w0, [x1, 130]
	ldr	x0, [x20, 8]
	cbz	x0, .L3194
	bl	buf_free
.L3194:
	add	x21, x21, :lo12:.LANCHOR63
	str	xzr, [x21, 8]
	bl	flt_sys_flush
	mov	w2, 2177
	strb	wzr, [x19, #:lo12:.LANCHOR138]
	adrp	x1, .LANCHOR208
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3231
.L3192:
	ldrh	w0, [x26, 6]
	ldrh	w1, [x20, 26]
	cmp	w0, 1
	ldrh	w0, [x20, 24]
	bls	.L3195
	cmp	w1, w0
	bcc	.L3186
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR138]
	ldrh	w0, [x20, 56]
	add	w1, w0, 1
	strh	w1, [x20, 56]
	add	x0, x20, x0, sxtw 1
	ldrh	w1, [x20]
	strh	w1, [x0, 58]
	mov	w0, -1
	strh	w0, [x20]
	b	.L3231
.L3195:
	mov	w2, 5
	strb	w2, [x19, #:lo12:.LANCHOR138]
	cmp	w1, w0
	bcc	.L3196
	ldrh	w0, [x20, 56]
	add	w1, w0, 1
	strh	w1, [x20, 56]
	add	x0, x20, x0, sxtw 1
	ldrh	w1, [x20]
	strh	w1, [x0, 58]
	mov	w0, -1
	strh	w0, [x20]
.L3196:
	bl	ftl_flush
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	x0, [x24, #:lo12:.LANCHOR5]
	ldrh	w1, [x23, 80]
	strh	w1, [x0, 128]
	bl	pm_flush
	bl	ftl_ext_info_flush
	add	x0, x21, :lo12:.LANCHOR63
	adrp	x1, .LANCHOR80
	adrp	x2, .LANCHOR67
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	ldrb	w2, [x2, #:lo12:.LANCHOR67]
	strh	wzr, [x0, 16]
	strh	w1, [x0, 18]
	cmp	w2, 2
	strh	w2, [x0, 20]
	bne	.L3197
	ubfiz	w1, w1, 1, 15
	strh	w1, [x0, 18]
	mov	w1, 1
	strh	w1, [x0, 20]
.L3197:
	add	x21, x21, :lo12:.LANCHOR63
	strh	wzr, [x21, 22]
	b	.L3231
.L3199:
	ldrh	w1, [x25, 16]
	ldrh	w0, [x25, 18]
	cmp	w1, w0
	bcc	.L3200
	mov	w0, 6
	strb	w0, [x19, #:lo12:.LANCHOR138]
	ldr	x0, [x25, 8]
	bl	buf_free
	str	xzr, [x25, 8]
	b	.L3231
.L3200:
	cmp	w20, 7
	bls	.L3134
	cmp	w22, 1
	bne	.L3231
	add	w23, w23, 1
	and	w23, w23, 255
	cmp	w23, 4
	bls	.L3134
	b	.L3231
.L3133:
	bl	gc_update_l2p_map_new
	mov	w20, -1
	bl	gc_free_src_blk
	bl	ftl_flush
	bl	pm_flush
	strh	w20, [x23, 80]
	bl	ftl_ext_info_flush
	adrp	x0, .LANCHOR97
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	strh	w20, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
	strb	wzr, [x19, #:lo12:.LANCHOR138]
	bl	print_ftl_debug_info
	b	.L3231
.L3182:
	mov	w2, 2075
	adrp	x1, .LANCHOR208
	adrp	x0, .LC0
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC0
	bl	printf
	b	.L3202
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
	adrp	x0, .LANCHOR7
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	mov	w19, w1
	ldr	w0, [x0, #:lo12:.LANCHOR7]
	mov	w20, w2
	stp	x21, x22, [sp, 32]
	mov	x24, x3
	stp	x25, x26, [sp, 64]
	tbz	x0, 12, .L3259
	mov	w3, w2
	adrp	x0, .LC223
	mov	w2, w1
	add	x0, x0, :lo12:.LC223
	mov	w1, w27
	bl	printf
.L3259:
	cbnz	w27, .L3260
	adrp	x0, .LANCHOR59
	mov	w27, 24576
	ldr	w0, [x0, #:lo12:.LANCHOR59]
.L3261:
	add	w1, w19, w20
	cmp	w0, w1
	bcc	.L3275
	adrp	x23, .LANCHOR117
	add	w27, w27, w19
	sub	w19, w20, #1
	adrp	x25, .LANCHOR97
	ldrb	w0, [x23, #:lo12:.LANCHOR117]
	add	w19, w19, w27
	add	x23, x23, :lo12:.LANCHOR117
	udiv	w22, w27, w0
	udiv	w19, w19, w0
	add	w0, w27, w20
	str	w0, [x29, 108]
	mov	w26, w22
	sub	w21, w19, w22
	add	w21, w21, 1
.L3263:
	cbnz	w21, .L3271
	adrp	x20, .LANCHOR89
	adrp	x19, .LANCHOR93
	add	x20, x20, :lo12:.LANCHOR89
	add	x19, x19, :lo12:.LANCHOR93
	bl	ftl_write_commit
	mov	w1, 1
	mov	w0, 0
	bl	zftl_do_gc
.L3272:
	ldrh	w0, [x20]
	ldrh	w1, [x19]
	add	w0, w0, w1
	cmp	w0, 7
	ble	.L3273
	mov	w0, 0
.L3258:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L3260:
	cmp	w27, 3
	bhi	.L3275
	lsl	w27, w27, 13
	mov	w0, 8192
	b	.L3261
.L3271:
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L3264
	bl	ftl_write_commit
	b	.L3263
.L3264:
	ldrb	w3, [x23]
	cmp	w26, w22
	strb	wzr, [x0, 57]
	ccmp	w26, w19, 4, ne
	strb	w3, [x0, 56]
	bne	.L3267
	cmp	w26, w22
	bne	.L3268
	udiv	w0, w27, w3
	msub	w0, w0, w3, w27
	and	w0, w0, 255
	strb	w0, [x28, 57]
	sub	w3, w3, w0
	and	w3, w3, 255
	cmp	w20, w3
	csel	w3, w20, w3, cc
.L3280:
	strb	w3, [x28, 56]
.L3267:
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
	b	.L3263
.L3268:
	ldr	w0, [x29, 108]
	msub	w3, w3, w26, w0
	b	.L3280
.L3273:
	mov	w1, 1
	mov	w0, 0
	bl	zftl_do_gc
	b	.L3272
.L3275:
	mov	w0, -1
	b	.L3258
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
	bne	.L3286
	mov	w3, w2
	mov	w0, 0
	mov	x2, x20
	bl	idb_write_data
.L3286:
	mov	x3, x20
	mov	w2, w19
	mov	w1, w22
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	b	zftl_write
	.size	ftl_write, .-ftl_write
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
	.global	ftl_ext_info_first_write
	.global	ftl_sys_info_first_write
	.global	ftl_low_format_cur_blk
	.global	ftl_power_lost_flag
	.global	ftl_vpn_update_count
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
	.global	check_vpc_tbl
	.global	p_read_ahead_ext_buf
	.global	discard_sector_count
	.global	read_ahead_lpa
	.global	write_commit_count
	.global	write_commit_head
	.global	write_buf_count
	.global	write_buf_head
	.global	ftl_flush_jiffies
	.global	lpa_hash
	.global	lpa_hash_index
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
	.set	.LANCHOR38,. + 0
	.type	IDByte, %object
	.size	IDByte, 32
IDByte:
	.zero	32
	.section	.bss._c_ftl_blk_pre_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR2,. + 0
	.type	_c_ftl_blk_pre_plane, %object
	.size	_c_ftl_blk_pre_plane, 2
_c_ftl_blk_pre_plane:
	.zero	2
	.section	.bss._c_ftl_block_addr_log2,"aw",@nobits
	.align	1
	.set	.LANCHOR96,. + 0
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
	.set	.LANCHOR188,. + 0
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
	.set	.LANCHOR72,. + 0
	.type	_c_ftl_nand_planes_num, %object
	.size	_c_ftl_nand_planes_num, 1
_c_ftl_nand_planes_num:
	.zero	1
	.section	.bss._c_ftl_nand_type,"aw",@nobits
	.set	.LANCHOR67,. + 0
	.type	_c_ftl_nand_type, %object
	.size	_c_ftl_nand_type, 1
_c_ftl_nand_type:
	.zero	1
	.section	.bss._c_ftl_page_pre_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR71,. + 0
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
	.set	.LANCHOR95,. + 0
	.type	_c_ftl_planes_per_die, %object
	.size	_c_ftl_planes_per_die, 1
_c_ftl_planes_per_die:
	.zero	1
	.section	.bss._c_ftl_pm_page_num,"aw",@nobits
	.align	1
	.set	.LANCHOR175,. + 0
	.type	_c_ftl_pm_page_num, %object
	.size	_c_ftl_pm_page_num, 2
_c_ftl_pm_page_num:
	.zero	2
	.section	.bss._c_ftl_sec_per_page,"aw",@nobits
	.set	.LANCHOR117,. + 0
	.type	_c_ftl_sec_per_page, %object
	.size	_c_ftl_sec_per_page, 1
_c_ftl_sec_per_page:
	.zero	1
	.section	.bss._c_max_pm_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR134,. + 0
	.type	_c_max_pm_sblk, %object
	.size	_c_max_pm_sblk, 2
_c_max_pm_sblk:
	.zero	2
	.section	.bss._c_mix_max_slc_ec_count,"aw",@nobits
	.align	1
	.set	.LANCHOR98,. + 0
	.type	_c_mix_max_slc_ec_count, %object
	.size	_c_mix_max_slc_ec_count, 2
_c_mix_max_slc_ec_count:
	.zero	2
	.section	.bss._c_mix_max_xlc_ec_count,"aw",@nobits
	.align	1
	.set	.LANCHOR99,. + 0
	.type	_c_mix_max_xlc_ec_count, %object
	.size	_c_mix_max_xlc_ec_count, 2
_c_mix_max_xlc_ec_count:
	.zero	2
	.section	.bss._c_swl_slc_gc_th,"aw",@nobits
	.align	1
	.set	.LANCHOR133,. + 0
	.type	_c_swl_slc_gc_th, %object
	.size	_c_swl_slc_gc_th, 2
_c_swl_slc_gc_th:
	.zero	2
	.section	.bss._c_swl_xlc_gc_th,"aw",@nobits
	.align	1
	.set	.LANCHOR132,. + 0
	.type	_c_swl_xlc_gc_th, %object
	.size	_c_swl_xlc_gc_th, 2
_c_swl_xlc_gc_th:
	.zero	2
	.section	.bss._c_totle_data_density,"aw",@nobits
	.align	2
	.set	.LANCHOR193,. + 0
	.type	_c_totle_data_density, %object
	.size	_c_totle_data_density, 4
_c_totle_data_density:
	.zero	4
	.section	.bss._c_totle_log_page,"aw",@nobits
	.align	2
	.set	.LANCHOR54,. + 0
	.type	_c_totle_log_page, %object
	.size	_c_totle_log_page, 4
_c_totle_log_page:
	.zero	4
	.section	.bss._c_totle_phy_density,"aw",@nobits
	.align	2
	.set	.LANCHOR192,. + 0
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
	.set	.LANCHOR207,. + 0
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
	.set	.LANCHOR100,. + 0
	.type	_max_slc_super_block, %object
	.size	_max_slc_super_block, 2
_max_slc_super_block:
	.zero	2
	.section	.bss._max_xlc_super_block,"aw",@nobits
	.align	1
	.set	.LANCHOR87,. + 0
	.type	_max_xlc_super_block, %object
	.size	_max_xlc_super_block, 2
_max_xlc_super_block:
	.zero	2
	.section	.bss._min_slc_super_block,"aw",@nobits
	.align	1
	.set	.LANCHOR83,. + 0
	.type	_min_slc_super_block, %object
	.size	_min_slc_super_block, 2
_min_slc_super_block:
	.zero	2
	.section	.bss.check_vpc_tbl,"aw",@nobits
	.align	3
	.type	check_vpc_tbl, %object
	.size	check_vpc_tbl, 4608
check_vpc_tbl:
	.zero	4608
	.section	.bss.discard_sector_count,"aw",@nobits
	.align	2
	.set	.LANCHOR205,. + 0
	.type	discard_sector_count, %object
	.size	discard_sector_count, 4
discard_sector_count:
	.zero	4
	.section	.bss.fill_spare_size,"aw",@nobits
	.align	1
	.set	.LANCHOR44,. + 0
	.type	fill_spare_size, %object
	.size	fill_spare_size, 2
fill_spare_size:
	.zero	2
	.section	.bss.flash_read_retry,"aw",@nobits
	.align	3
	.set	.LANCHOR148,. + 0
	.type	flash_read_retry, %object
	.size	flash_read_retry, 8
flash_read_retry:
	.zero	8
	.section	.bss.free_buf_count,"aw",@nobits
	.set	.LANCHOR48,. + 0
	.type	free_buf_count, %object
	.size	free_buf_count, 1
free_buf_count:
	.zero	1
	.section	.bss.free_mix_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR93,. + 0
	.type	free_mix_sblk, %object
	.size	free_mix_sblk, 2
free_mix_sblk:
	.zero	2
	.section	.bss.free_slc_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR89,. + 0
	.type	free_slc_sblk, %object
	.size	free_slc_sblk, 2
free_slc_sblk:
	.zero	2
	.section	.bss.free_xlc_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR91,. + 0
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
	.set	.LANCHOR171,. + 0
	.type	ftl_ext_info_first_write, %object
	.size	ftl_ext_info_first_write, 1
ftl_ext_info_first_write:
	.zero	1
	.section	.bss.ftl_flush_jiffies,"aw",@nobits
	.align	2
	.set	.LANCHOR202,. + 0
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
	.set	.LANCHOR166,. + 0
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
	.set	.LANCHOR170,. + 0
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
	.section	.bss.ftl_sblk_vpn,"aw",@nobits
	.align	3
	.set	.LANCHOR4,. + 0
	.type	ftl_sblk_vpn, %object
	.size	ftl_sblk_vpn, 8
ftl_sblk_vpn:
	.zero	8
	.section	.bss.ftl_sblk_vpn_update_id,"aw",@nobits
	.align	1
	.set	.LANCHOR114,. + 0
	.type	ftl_sblk_vpn_update_id, %object
	.size	ftl_sblk_vpn_update_id, 2
ftl_sblk_vpn_update_id:
	.zero	2
	.section	.bss.ftl_sys_info_first_write,"aw",@nobits
	.set	.LANCHOR169,. + 0
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
	.set	.LANCHOR155,. + 0
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
	.set	.LANCHOR26,. + 0
	.type	g_block_align_addr, %object
	.size	g_block_align_addr, 2
g_block_align_addr:
	.zero	2
	.section	.bss.g_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR46,. + 0
	.type	g_buf, %object
	.size	g_buf, 2048
g_buf:
	.zero	2048
	.section	.bss.g_die_addr,"aw",@nobits
	.align	2
	.set	.LANCHOR129,. + 0
	.type	g_die_addr, %object
	.size	g_die_addr, 32
g_die_addr:
	.zero	32
	.section	.bss.g_die_cs_idx,"aw",@nobits
	.align	2
	.set	.LANCHOR24,. + 0
	.type	g_die_cs_idx, %object
	.size	g_die_cs_idx, 8
g_die_cs_idx:
	.zero	8
	.section	.bss.g_flash_3d_mlc_flag,"aw",@nobits
	.set	.LANCHOR102,. + 0
	.type	g_flash_3d_mlc_flag, %object
	.size	g_flash_3d_mlc_flag, 1
g_flash_3d_mlc_flag:
	.zero	1
	.section	.bss.g_flash_3d_tlc_flag,"aw",@nobits
	.set	.LANCHOR69,. + 0
	.type	g_flash_3d_tlc_flag, %object
	.size	g_flash_3d_tlc_flag, 1
g_flash_3d_tlc_flag:
	.zero	1
	.section	.bss.g_flash_blk_info,"aw",@nobits
	.align	3
	.set	.LANCHOR151,. + 0
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
	.set	.LANCHOR39,. + 0
	.type	g_flash_interface_mode, %object
	.size	g_flash_interface_mode, 1
g_flash_interface_mode:
	.zero	1
	.section	.bss.g_flash_multi_page_prog_en,"aw",@nobits
	.set	.LANCHOR36,. + 0
	.type	g_flash_multi_page_prog_en, %object
	.size	g_flash_multi_page_prog_en, 1
g_flash_multi_page_prog_en:
	.zero	1
	.section	.bss.g_flash_multi_page_read_en,"aw",@nobits
	.set	.LANCHOR185,. + 0
	.type	g_flash_multi_page_read_en, %object
	.size	g_flash_multi_page_read_en, 1
g_flash_multi_page_read_en:
	.zero	1
	.section	.bss.g_flash_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR153,. + 0
	.type	g_flash_page_buffer, %object
	.size	g_flash_page_buffer, 8
g_flash_page_buffer:
	.zero	8
	.section	.bss.g_flash_reversd_blks,"aw",@nobits
	.set	.LANCHOR157,. + 0
	.type	g_flash_reversd_blks, %object
	.size	g_flash_reversd_blks, 1
g_flash_reversd_blks:
	.zero	1
	.section	.bss.g_flash_slc_mode,"aw",@nobits
	.set	.LANCHOR11,. + 0
	.type	g_flash_slc_mode, %object
	.size	g_flash_slc_mode, 1
g_flash_slc_mode:
	.zero	1
	.section	.bss.g_flash_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR152,. + 0
	.type	g_flash_spare_buffer, %object
	.size	g_flash_spare_buffer, 8
g_flash_spare_buffer:
	.zero	8
	.section	.bss.g_flash_sys_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR150,. + 0
	.type	g_flash_sys_spare_buffer, %object
	.size	g_flash_sys_spare_buffer, 8
g_flash_sys_spare_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR143,. + 0
	.type	g_flash_tmp_page_buffer, %object
	.size	g_flash_tmp_page_buffer, 8
g_flash_tmp_page_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR145,. + 0
	.type	g_flash_tmp_spare_buffer, %object
	.size	g_flash_tmp_spare_buffer, 8
g_flash_tmp_spare_buffer:
	.zero	8
	.section	.bss.g_flash_toggle_mode_en,"aw",@nobits
	.set	.LANCHOR14,. + 0
	.type	g_flash_toggle_mode_en, %object
	.size	g_flash_toggle_mode_en, 1
g_flash_toggle_mode_en:
	.zero	1
	.section	.bss.g_ftl_info_blk,"aw",@nobits
	.align	6
	.set	.LANCHOR167,. + 0
	.type	g_ftl_info_blk, %object
	.size	g_ftl_info_blk, 4
g_ftl_info_blk:
	.zero	4
	.section	.bss.g_gc_info,"aw",@nobits
	.align	3
	.set	.LANCHOR63,. + 0
	.type	g_gc_info, %object
	.size	g_gc_info, 328
g_gc_info:
	.zero	328
	.section	.bss.g_idb_ecc_bits,"aw",@nobits
	.set	.LANCHOR10,. + 0
	.type	g_idb_ecc_bits, %object
	.size	g_idb_ecc_bits, 1
g_idb_ecc_bits:
	.zero	1
	.section	.bss.g_idb_slc_mode_enable,"aw",@nobits
	.set	.LANCHOR158,. + 0
	.type	g_idb_slc_mode_enable, %object
	.size	g_idb_slc_mode_enable, 1
g_idb_slc_mode_enable:
	.zero	1
	.section	.bss.g_lsb_page_tbl,"aw",@nobits
	.align	2
	.set	.LANCHOR27,. + 0
	.type	g_lsb_page_tbl, %object
	.size	g_lsb_page_tbl, 512
g_lsb_page_tbl:
	.zero	512
	.section	.bss.g_maxRegNum,"aw",@nobits
	.set	.LANCHOR19,. + 0
	.type	g_maxRegNum, %object
	.size	g_maxRegNum, 1
g_maxRegNum:
	.zero	1
	.section	.bss.g_maxRetryCount,"aw",@nobits
	.set	.LANCHOR146,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.zero	1
	.section	.bss.g_msb_page_tbl,"aw",@nobits
	.align	2
	.set	.LANCHOR126,. + 0
	.type	g_msb_page_tbl, %object
	.size	g_msb_page_tbl, 1024
g_msb_page_tbl:
	.zero	1024
	.section	.bss.g_nand_max_die,"aw",@nobits
	.set	.LANCHOR12,. + 0
	.type	g_nand_max_die, %object
	.size	g_nand_max_die, 1
g_nand_max_die:
	.zero	1
	.section	.bss.g_nand_opt_para,"aw",@nobits
	.align	3
	.set	.LANCHOR13,. + 0
	.type	g_nand_opt_para, %object
	.size	g_nand_opt_para, 32
g_nand_opt_para:
	.zero	32
	.section	.bss.g_nandc_ecc_bits,"aw",@nobits
	.set	.LANCHOR40,. + 0
	.type	g_nandc_ecc_bits, %object
	.size	g_nandc_ecc_bits, 1
g_nandc_ecc_bits:
	.zero	1
	.section	.bss.g_nandc_tran_timeout,"aw",@nobits
	.set	.LANCHOR144,. + 0
	.type	g_nandc_tran_timeout, %object
	.size	g_nandc_tran_timeout, 1
g_nandc_tran_timeout:
	.zero	1
	.section	.bss.g_nandc_v6_master_info,"aw",@nobits
	.align	3
	.set	.LANCHOR43,. + 0
	.type	g_nandc_v6_master_info, %object
	.size	g_nandc_v6_master_info, 40
g_nandc_v6_master_info:
	.zero	40
	.section	.bss.g_nandc_ver,"aw",@nobits
	.set	.LANCHOR22,. + 0
	.type	g_nandc_ver, %object
	.size	g_nandc_ver, 1
g_nandc_ver:
	.zero	1
	.section	.bss.g_pm_spare,"aw",@nobits
	.align	3
	.set	.LANCHOR179,. + 0
	.type	g_pm_spare, %object
	.size	g_pm_spare, 8
g_pm_spare:
	.zero	8
	.section	.bss.g_retryMode,"aw",@nobits
	.set	.LANCHOR17,. + 0
	.type	g_retryMode, %object
	.size	g_retryMode, 1
g_retryMode:
	.zero	1
	.section	.bss.g_slc_mode_addr2,"aw",@nobits
	.set	.LANCHOR25,. + 0
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
	.set	.LANCHOR128,. + 0
	.type	g_slc_page_num, %object
	.size	g_slc_page_num, 2
g_slc_page_num:
	.zero	2
	.section	.bss.g_totle_phy_block,"aw",@nobits
	.align	1
	.set	.LANCHOR130,. + 0
	.type	g_totle_phy_block, %object
	.size	g_totle_phy_block, 2
g_totle_phy_block:
	.zero	2
	.section	.bss.gc_des_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR141,. + 0
	.type	gc_des_ppa_tbl, %object
	.size	gc_des_ppa_tbl, 8
gc_des_ppa_tbl:
	.zero	8
	.section	.bss.gc_free_slc_sblk_th,"aw",@nobits
	.align	1
	.set	.LANCHOR73,. + 0
	.type	gc_free_slc_sblk_th, %object
	.size	gc_free_slc_sblk_th, 2
gc_free_slc_sblk_th:
	.zero	2
	.section	.bss.gc_lpa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR139,. + 0
	.type	gc_lpa_tbl, %object
	.size	gc_lpa_tbl, 8
gc_lpa_tbl:
	.zero	8
	.section	.bss.gc_mode,"aw",@nobits
	.set	.LANCHOR70,. + 0
	.type	gc_mode, %object
	.size	gc_mode, 1
gc_mode:
	.zero	1
	.section	.bss.gc_page_buf_id,"aw",@nobits
	.align	3
	.set	.LANCHOR68,. + 0
	.type	gc_page_buf_id, %object
	.size	gc_page_buf_id, 8
gc_page_buf_id:
	.zero	8
	.section	.bss.gc_pre_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR140,. + 0
	.type	gc_pre_ppa_tbl, %object
	.size	gc_pre_ppa_tbl, 8
gc_pre_ppa_tbl:
	.zero	8
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
	.set	.LANCHOR62,. + 0
	.type	gc_slc_mode_vpn_th, %object
	.size	gc_slc_mode_vpn_th, 2
gc_slc_mode_vpn_th:
	.zero	2
	.section	.bss.gc_state,"aw",@nobits
	.set	.LANCHOR138,. + 0
	.type	gc_state, %object
	.size	gc_state, 1
gc_state:
	.zero	1
	.section	.bss.gc_tlc_mode_slc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR88,. + 0
	.type	gc_tlc_mode_slc_vpn_th, %object
	.size	gc_tlc_mode_slc_vpn_th, 2
gc_tlc_mode_slc_vpn_th:
	.zero	2
	.section	.bss.gc_tlc_mode_tlc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR85,. + 0
	.type	gc_tlc_mode_tlc_vpn_th, %object
	.size	gc_tlc_mode_tlc_vpn_th, 2
gc_tlc_mode_tlc_vpn_th:
	.zero	2
	.section	.bss.gc_valid_page_ppa,"aw",@nobits
	.align	3
	.set	.LANCHOR64,. + 0
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
	.section	.bss.gp_blk_info,"aw",@nobits
	.align	3
	.set	.LANCHOR3,. + 0
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
	.set	.LANCHOR75,. + 0
	.type	gp_data_slc_data_head, %object
	.size	gp_data_slc_data_head, 8
gp_data_slc_data_head:
	.zero	8
	.section	.bss.gp_data_xlc_data_head,"aw",@nobits
	.align	3
	.set	.LANCHOR74,. + 0
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
	.set	.LANCHOR20,. + 0
	.type	gp_flash_info, %object
	.size	gp_flash_info, 8
gp_flash_info:
	.zero	8
	.section	.bss.gp_free_mix_head,"aw",@nobits
	.align	3
	.set	.LANCHOR94,. + 0
	.type	gp_free_mix_head, %object
	.size	gp_free_mix_head, 8
gp_free_mix_head:
	.zero	8
	.section	.bss.gp_free_slc_head,"aw",@nobits
	.align	3
	.set	.LANCHOR90,. + 0
	.type	gp_free_slc_head, %object
	.size	gp_free_slc_head, 8
gp_free_slc_head:
	.zero	8
	.section	.bss.gp_free_xlc_head,"aw",@nobits
	.align	3
	.set	.LANCHOR92,. + 0
	.type	gp_free_xlc_head, %object
	.size	gp_free_xlc_head, 8
gp_free_xlc_head:
	.zero	8
	.section	.bss.gp_ftl_ext_info,"aw",@nobits
	.align	3
	.set	.LANCHOR5,. + 0
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
	.set	.LANCHOR9,. + 0
	.type	gp_nand_para_info, %object
	.size	gp_nand_para_info, 8
gp_nand_para_info:
	.zero	8
	.section	.bss.gp_nandc,"aw",@nobits
	.align	3
	.set	.LANCHOR21,. + 0
	.type	gp_nandc, %object
	.size	gp_nandc, 8
gp_nandc:
	.zero	8
	.section	.bss.gp_sblk_list_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR0,. + 0
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
	.set	.LANCHOR159,. + 0
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
	.set	.LANCHOR41,. + 0
	.type	nandc_hw_seed, %object
	.size	nandc_hw_seed, 1
nandc_hw_seed:
	.zero	1
	.section	.bss.nandc_randomizer_en,"aw",@nobits
	.set	.LANCHOR42,. + 0
	.type	nandc_randomizer_en, %object
	.size	nandc_randomizer_en, 1
nandc_randomizer_en:
	.zero	1
	.section	.bss.p_free_buf_head,"aw",@nobits
	.set	.LANCHOR47,. + 0
	.type	p_free_buf_head, %object
	.size	p_free_buf_head, 1
p_free_buf_head:
	.zero	1
	.section	.bss.p_read_ahead_ext_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR57,. + 0
	.type	p_read_ahead_ext_buf, %object
	.size	p_read_ahead_ext_buf, 8
p_read_ahead_ext_buf:
	.zero	8
	.section	.bss.pm_first_write,"aw",@nobits
	.set	.LANCHOR180,. + 0
	.type	pm_first_write, %object
	.size	pm_first_write, 1
pm_first_write:
	.zero	1
	.section	.bss.pm_gc_enable,"aw",@nobits
	.align	2
	.set	.LANCHOR121,. + 0
	.type	pm_gc_enable, %object
	.size	pm_gc_enable, 4
pm_gc_enable:
	.zero	4
	.section	.bss.pm_last_load_ram_id,"aw",@nobits
	.set	.LANCHOR190,. + 0
	.type	pm_last_load_ram_id, %object
	.size	pm_last_load_ram_id, 1
pm_last_load_ram_id:
	.zero	1
	.section	.bss.pm_last_update_ram_id,"aw",@nobits
	.set	.LANCHOR124,. + 0
	.type	pm_last_update_ram_id, %object
	.size	pm_last_update_ram_id, 1
pm_last_update_ram_id:
	.zero	1
	.section	.bss.pm_ram_info,"aw",@nobits
	.align	3
	.set	.LANCHOR123,. + 0
	.type	pm_ram_info, %object
	.size	pm_ram_info, 512
pm_ram_info:
	.zero	512
	.section	.bss.read_ahead_lpa,"aw",@nobits
	.align	2
	.set	.LANCHOR56,. + 0
	.type	read_ahead_lpa, %object
	.size	read_ahead_lpa, 4
read_ahead_lpa:
	.zero	4
	.section	.bss.sblk_gc_write_completed_queue_head,"aw",@nobits
	.set	.LANCHOR65,. + 0
	.type	sblk_gc_write_completed_queue_head, %object
	.size	sblk_gc_write_completed_queue_head, 1
sblk_gc_write_completed_queue_head:
	.zero	1
	.section	.bss.sblk_queue_head,"aw",@nobits
	.set	.LANCHOR120,. + 0
	.type	sblk_queue_head, %object
	.size	sblk_queue_head, 1
sblk_queue_head:
	.zero	1
	.section	.bss.sblk_read_completed_queue_head,"aw",@nobits
	.set	.LANCHOR58,. + 0
	.type	sblk_read_completed_queue_head, %object
	.size	sblk_read_completed_queue_head, 1
sblk_read_completed_queue_head:
	.zero	1
	.section	.bss.sblk_write_completed_queue_head,"aw",@nobits
	.set	.LANCHOR118,. + 0
	.type	sblk_write_completed_queue_head, %object
	.size	sblk_write_completed_queue_head, 1
sblk_write_completed_queue_head:
	.zero	1
	.section	.bss.slc_cache_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR82,. + 0
	.type	slc_cache_sblk, %object
	.size	slc_cache_sblk, 2
slc_cache_sblk:
	.zero	2
	.section	.bss.slc_data_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR84,. + 0
	.type	slc_data_sblk, %object
	.size	slc_data_sblk, 2
slc_data_sblk:
	.zero	2
	.section	.bss.write_buf_count,"aw",@nobits
	.set	.LANCHOR53,. + 0
	.type	write_buf_count, %object
	.size	write_buf_count, 1
write_buf_count:
	.zero	1
	.section	.bss.write_buf_head,"aw",@nobits
	.set	.LANCHOR52,. + 0
	.type	write_buf_head, %object
	.size	write_buf_head, 1
write_buf_head:
	.zero	1
	.section	.bss.write_commit_count,"aw",@nobits
	.set	.LANCHOR115,. + 0
	.type	write_commit_count, %object
	.size	write_commit_count, 1
write_commit_count:
	.zero	1
	.section	.bss.write_commit_head,"aw",@nobits
	.set	.LANCHOR163,. + 0
	.type	write_commit_head, %object
	.size	write_commit_head, 1
write_commit_head:
	.zero	1
	.section	.bss.xlc_data_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR86,. + 0
	.type	xlc_data_sblk, %object
	.size	xlc_data_sblk, 2
xlc_data_sblk:
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
	.set	.LANCHOR142,. + 0
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
	.set	.LANCHOR184,. + 0
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
	.set	.LANCHOR31,. + 0
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
	.set	.LANCHOR30,. + 0
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
	.set	.LANCHOR204,. + 0
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
	.set	.LANCHOR7,. + 0
	.type	zftl_debug, %object
	.size	zftl_debug, 4
zftl_debug:
	.word	17476
	.section	.data.zftl_nand_flash_para_tbl,"aw",@progbits
	.align	3
	.set	.LANCHOR183,. + 0
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
	.byte	2
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
	.byte	2
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
	.byte	2
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
	.byte	2
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
	.byte	2
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
	.hword	9695
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
	.byte	2
	.hword	1096
	.hword	9695
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
	.byte	2
	.hword	1096
	.hword	9695
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
	.section	.rodata.__func__.10035,"a",@progbits
	.align	3
	.set	.LANCHOR1,. + 0
	.type	__func__.10035, %object
	.size	__func__.10035, 18
__func__.10035:
	.string	"_list_remove_node"
	.section	.rodata.__func__.10060,"a",@progbits
	.align	3
	.set	.LANCHOR6,. + 0
	.type	__func__.10060, %object
	.size	__func__.10060, 23
__func__.10060:
	.string	"_list_update_data_list"
	.section	.rodata.__func__.10159,"a",@progbits
	.align	3
	.set	.LANCHOR168,. + 0
	.type	__func__.10159, %object
	.size	__func__.10159, 15
__func__.10159:
	.string	"ftl_info_flush"
	.section	.rodata.__func__.10191,"a",@progbits
	.align	3
	.set	.LANCHOR119,. + 0
	.type	__func__.10191, %object
	.size	__func__.10191, 15
__func__.10191:
	.string	"ftl_alloc_sblk"
	.section	.rodata.__func__.10233,"a",@progbits
	.align	3
	.set	.LANCHOR105,. + 0
	.type	__func__.10233, %object
	.size	__func__.10233, 18
__func__.10233:
	.string	"ftl_alloc_sys_blk"
	.section	.rodata.__func__.10243,"a",@progbits
	.align	3
	.set	.LANCHOR106,. + 0
	.type	__func__.10243, %object
	.size	__func__.10243, 17
__func__.10243:
	.string	"ftl_free_sys_blk"
	.section	.rodata.__func__.10278,"a",@progbits
	.align	3
	.set	.LANCHOR196,. + 0
	.type	__func__.10278, %object
	.size	__func__.10278, 14
__func__.10278:
	.string	"ftl_sblk_dump"
	.section	.rodata.__func__.10302,"a",@progbits
	.align	3
	.set	.LANCHOR186,. + 0
	.type	__func__.10302, %object
	.size	__func__.10302, 16
__func__.10302:
	.string	"ftl_sysblk_dump"
	.section	.rodata.__func__.10321,"a",@progbits
	.align	3
	.set	.LANCHOR177,. + 0
	.type	__func__.10321, %object
	.size	__func__.10321, 23
__func__.10321:
	.string	"ftl_open_sblk_recovery"
	.section	.rodata.__func__.10347,"a",@progbits
	.align	3
	.set	.LANCHOR107,. + 0
	.type	__func__.10347, %object
	.size	__func__.10347, 23
__func__.10347:
	.string	"ftl_get_ppa_from_index"
	.section	.rodata.__func__.10368,"a",@progbits
	.align	3
	.set	.LANCHOR200,. + 0
	.type	__func__.10368, %object
	.size	__func__.10368, 19
__func__.10368:
	.string	"ftl_update_l2p_map"
	.section	.rodata.__func__.10386,"a",@progbits
	.align	3
	.set	.LANCHOR111,. + 0
	.type	__func__.10386, %object
	.size	__func__.10386, 22
__func__.10386:
	.string	"ftl_get_new_free_page"
	.section	.rodata.__func__.10397,"a",@progbits
	.align	3
	.set	.LANCHOR112,. + 0
	.type	__func__.10397, %object
	.size	__func__.10397, 22
__func__.10397:
	.string	"ftl_ext_alloc_new_blk"
	.section	.rodata.__func__.10422,"a",@progbits
	.align	3
	.set	.LANCHOR172,. + 0
	.type	__func__.10422, %object
	.size	__func__.10422, 19
__func__.10422:
	.string	"ftl_ext_info_flush"
	.section	.rodata.__func__.10434,"a",@progbits
	.align	3
	.set	.LANCHOR173,. + 0
	.type	__func__.10434, %object
	.size	__func__.10434, 18
__func__.10434:
	.string	"ftl_ext_info_init"
	.section	.rodata.__func__.10480,"a",@progbits
	.align	3
	.set	.LANCHOR174,. + 0
	.type	__func__.10480, %object
	.size	__func__.10480, 15
__func__.10480:
	.string	"ftl_low_format"
	.section	.rodata.__func__.10524,"a",@progbits
	.align	3
	.set	.LANCHOR176,. + 0
	.type	__func__.10524, %object
	.size	__func__.10524, 23
__func__.10524:
	.string	"ftl_re_low_format_test"
	.section	.rodata.__func__.10534,"a",@progbits
	.align	3
	.set	.LANCHOR165,. + 0
	.type	__func__.10534, %object
	.size	__func__.10534, 14
__func__.10534:
	.string	"ftl_prog_page"
	.section	.rodata.__func__.10709,"a",@progbits
	.align	3
	.set	.LANCHOR162,. + 0
	.type	__func__.10709, %object
	.size	__func__.10709, 15
__func__.10709:
	.string	"sblk_prog_page"
	.section	.rodata.__func__.10769,"a",@progbits
	.align	3
	.set	.LANCHOR187,. + 0
	.type	__func__.10769, %object
	.size	__func__.10769, 16
__func__.10769:
	.string	"load_l2p_region"
	.section	.rodata.__func__.10783,"a",@progbits
	.align	3
	.set	.LANCHOR135,. + 0
	.type	__func__.10783, %object
	.size	__func__.10783, 13
__func__.10783:
	.string	"pm_free_sblk"
	.section	.rodata.__func__.10803,"a",@progbits
	.align	3
	.set	.LANCHOR189,. + 0
	.type	__func__.10803, %object
	.size	__func__.10803, 6
__func__.10803:
	.string	"pm_gc"
	.section	.rodata.__func__.10819,"a",@progbits
	.align	3
	.set	.LANCHOR122,. + 0
	.type	__func__.10819, %object
	.size	__func__.10819, 17
__func__.10819:
	.string	"pm_alloc_new_blk"
	.section	.rodata.__func__.10829,"a",@progbits
	.align	3
	.set	.LANCHOR178,. + 0
	.type	__func__.10829, %object
	.size	__func__.10829, 14
__func__.10829:
	.string	"pm_write_page"
	.section	.rodata.__func__.10847,"a",@progbits
	.align	3
	.set	.LANCHOR125,. + 0
	.type	__func__.10847, %object
	.size	__func__.10847, 21
__func__.10847:
	.string	"pm_select_ram_region"
	.section	.rodata.__func__.8490,"a",@progbits
	.align	3
	.set	.LANCHOR147,. + 0
	.type	__func__.8490, %object
	.size	__func__.8490, 19
__func__.8490:
	.string	"flash_read_page_en"
	.section	.rodata.__func__.8519,"a",@progbits
	.align	3
	.set	.LANCHOR164,. + 0
	.type	__func__.8519, %object
	.size	__func__.8519, 19
__func__.8519:
	.string	"flash_prog_page_en"
	.section	.rodata.__func__.8534,"a",@progbits
	.align	3
	.set	.LANCHOR35,. + 0
	.type	__func__.8534, %object
	.size	__func__.8534, 26
__func__.8534:
	.string	"flash_erase_duplane_block"
	.section	.rodata.__func__.8545,"a",@progbits
	.align	3
	.set	.LANCHOR37,. + 0
	.type	__func__.8545, %object
	.size	__func__.8545, 21
__func__.8545:
	.string	"flash_erase_block_en"
	.section	.rodata.__func__.8559,"a",@progbits
	.align	3
	.set	.LANCHOR23,. + 0
	.type	__func__.8559, %object
	.size	__func__.8559, 28
__func__.8559:
	.string	"flash_wait_device_ready_raw"
	.section	.rodata.__func__.8583,"a",@progbits
	.align	3
	.set	.LANCHOR160,. + 0
	.type	__func__.8583, %object
	.size	__func__.8583, 26
__func__.8583:
	.string	"flash_start_tlc_page_prog"
	.section	.rodata.__func__.8596,"a",@progbits
	.align	3
	.set	.LANCHOR161,. + 0
	.type	__func__.8596, %object
	.size	__func__.8596, 22
__func__.8596:
	.string	"flash_start_page_prog"
	.section	.rodata.__func__.8609,"a",@progbits
	.align	3
	.set	.LANCHOR34,. + 0
	.type	__func__.8609, %object
	.size	__func__.8609, 22
__func__.8609:
	.string	"flash_start_page_read"
	.section	.rodata.__func__.8624,"a",@progbits
	.align	3
	.set	.LANCHOR154,. + 0
	.type	__func__.8624, %object
	.size	__func__.8624, 25
__func__.8624:
	.string	"flash_complete_page_read"
	.section	.rodata.__func__.8937,"a",@progbits
	.align	3
	.set	.LANCHOR127,. + 0
	.type	__func__.8937, %object
	.size	__func__.8937, 20
__func__.8937:
	.string	"flash_die_info_init"
	.section	.rodata.__func__.8947,"a",@progbits
	.align	3
	.set	.LANCHOR8,. + 0
	.type	__func__.8947, %object
	.size	__func__.8947, 22
__func__.8947:
	.string	"nand_flash_print_info"
	.section	.rodata.__func__.8991,"a",@progbits
	.align	3
	.set	.LANCHOR182,. + 0
	.type	__func__.8991, %object
	.size	__func__.8991, 16
__func__.8991:
	.string	"nand_flash_init"
	.section	.rodata.__func__.9011,"a",@progbits
	.align	3
	.set	.LANCHOR137,. + 0
	.type	__func__.9011, %object
	.size	__func__.9011, 11
__func__.9011:
	.string	"nandc_init"
	.section	.rodata.__func__.9171,"a",@progbits
	.align	3
	.set	.LANCHOR49,. + 0
	.type	__func__.9171, %object
	.size	__func__.9171, 13
__func__.9171:
	.string	"buf_add_tail"
	.section	.rodata.__func__.9184,"a",@progbits
	.align	3
	.set	.LANCHOR50,. + 0
	.type	__func__.9184, %object
	.size	__func__.9184, 10
__func__.9184:
	.string	"buf_alloc"
	.section	.rodata.__func__.9198,"a",@progbits
	.align	3
	.set	.LANCHOR51,. + 0
	.type	__func__.9198, %object
	.size	__func__.9198, 16
__func__.9198:
	.string	"buf_remove_free"
	.section	.rodata.__func__.9210,"a",@progbits
	.align	3
	.set	.LANCHOR149,. + 0
	.type	__func__.9210, %object
	.size	__func__.9210, 20
__func__.9210:
	.string	"flash_info_blk_init"
	.section	.rodata.__func__.9221,"a",@progbits
	.align	3
	.set	.LANCHOR136,. + 0
	.type	__func__.9221, %object
	.size	__func__.9221, 21
__func__.9221:
	.string	"flash_into_data_init"
	.section	.rodata.__func__.9243,"a",@progbits
	.align	3
	.set	.LANCHOR181,. + 0
	.type	__func__.9243, %object
	.size	__func__.9243, 17
__func__.9243:
	.string	"flash_info_flush"
	.section	.rodata.__func__.9316,"a",@progbits
	.align	3
	.set	.LANCHOR131,. + 0
	.type	__func__.9316, %object
	.size	__func__.9316, 17
__func__.9316:
	.string	"lpa_rebuild_hash"
	.section	.rodata.__func__.9368,"a",@progbits
	.align	3
	.set	.LANCHOR201,. + 0
	.type	__func__.9368, %object
	.size	__func__.9368, 17
__func__.9368:
	.string	"ftl_write_commit"
	.section	.rodata.__func__.9379,"a",@progbits
	.align	3
	.set	.LANCHOR116,. + 0
	.type	__func__.9379, %object
	.size	__func__.9379, 14
__func__.9379:
	.string	"ftl_write_buf"
	.section	.rodata.__func__.9430,"a",@progbits
	.align	3
	.set	.LANCHOR191,. + 0
	.type	__func__.9430, %object
	.size	__func__.9430, 15
__func__.9430:
	.string	"ftl_read_ahead"
	.section	.rodata.__func__.9438,"a",@progbits
	.align	3
	.set	.LANCHOR55,. + 0
	.type	__func__.9438, %object
	.size	__func__.9438, 13
__func__.9438:
	.string	"ftl_read_buf"
	.section	.rodata.__func__.9476,"a",@progbits
	.align	3
	.set	.LANCHOR197,. + 0
	.type	__func__.9476, %object
	.size	__func__.9476, 10
__func__.9476:
	.string	"zftl_read"
	.section	.rodata.__func__.9502,"a",@progbits
	.align	3
	.set	.LANCHOR206,. + 0
	.type	__func__.9502, %object
	.size	__func__.9502, 13
__func__.9502:
	.string	"_ftl_discard"
	.section	.rodata.__func__.9543,"a",@progbits
	.align	3
	.set	.LANCHOR198,. + 0
	.type	__func__.9543, %object
	.size	__func__.9543, 10
__func__.9543:
	.string	"vpn_check"
	.section	.rodata.__func__.9665,"a",@progbits
	.align	3
	.set	.LANCHOR61,. + 0
	.type	__func__.9665, %object
	.size	__func__.9665, 12
__func__.9665:
	.string	"gc_add_sblk"
	.section	.rodata.__func__.9683,"a",@progbits
	.align	3
	.set	.LANCHOR156,. + 0
	.type	__func__.9683, %object
	.size	__func__.9683, 21
__func__.9683:
	.string	"gc_check_data_one_wl"
	.section	.rodata.__func__.9717,"a",@progbits
	.align	3
	.set	.LANCHOR194,. + 0
	.type	__func__.9717, %object
	.size	__func__.9717, 22
__func__.9717:
	.string	"gc_update_l2p_map_new"
	.section	.rodata.__func__.9730,"a",@progbits
	.align	3
	.set	.LANCHOR66,. + 0
	.type	__func__.9730, %object
	.size	__func__.9730, 19
__func__.9730:
	.string	"gc_write_completed"
	.section	.rodata.__func__.9759,"a",@progbits
	.align	3
	.set	.LANCHOR203,. + 0
	.type	__func__.9759, %object
	.size	__func__.9759, 16
__func__.9759:
	.string	"gc_do_copy_back"
	.section	.rodata.__func__.9781,"a",@progbits
	.align	3
	.set	.LANCHOR101,. + 0
	.type	__func__.9781, %object
	.size	__func__.9781, 16
__func__.9781:
	.string	"gc_free_src_blk"
	.section	.rodata.__func__.9826,"a",@progbits
	.align	3
	.set	.LANCHOR199,. + 0
	.type	__func__.9826, %object
	.size	__func__.9826, 16
__func__.9826:
	.string	"gc_scan_src_blk"
	.section	.rodata.__func__.9885,"a",@progbits
	.align	3
	.set	.LANCHOR195,. + 0
	.type	__func__.9885, %object
	.size	__func__.9885, 20
__func__.9885:
	.string	"gc_scan_static_data"
	.section	.rodata.__func__.9946,"a",@progbits
	.align	3
	.set	.LANCHOR208,. + 0
	.type	__func__.9946, %object
	.size	__func__.9946, 11
__func__.9946:
	.string	"zftl_do_gc"
	.section	.rodata._list_remove_node.str1.1,"aMS",@progbits,1
.LC0:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
	.section	.rodata.dump_ftl_info.str1.1,"aMS",@progbits,1
.LC137:
	.string	"free_buf_count: %d\n"
.LC138:
	.string	"g_ftl_info_blk blk:0x%x, index:0x%x, page:0x%x\n"
.LC139:
	.string	"ftl_ext_info_blk blk:0x%x, page:0x%x\n"
.LC140:
	.string	"ac_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC141:
	.string	"tmp_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC142:
	.string	"gc_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC143:
	.string	"lpa:"
.LC144:
	.string	"vpn:"
.LC145:
	.string	"sblk:"
.LC146:
	.string	"lpa_hash:"
.LC147:
	.string	"lpa_hash_index:"
	.section	.rodata.dump_sblk_queue.str1.1,"aMS",@progbits,1
.LC62:
	.string	"dump_sblk_queue: %d\n"
.LC63:
	.string	"buf id= %d state = %d ppa = %x\n"
	.section	.rodata.flash_complete_page_read.str1.1,"aMS",@progbits,1
.LC106:
	.string	"flash_complete_page_read %x %x error_ecc %d %d\n"
	.section	.rodata.flash_ddr_tunning_read.str1.1,"aMS",@progbits,1
.LC98:
	.string	"%d flash_ddr_tunning_read %x ecc=%d\n"
.LC99:
	.string	"sync para %d\n"
.LC100:
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
.LC103:
	.string	"flash_get_last_written_page: %x %x %x\n"
	.section	.rodata.flash_info_blk_init.str1.1,"aMS",@progbits,1
.LC104:
	.string	"...%d @ %s %d %p\n"
.LC105:
	.string	"no sys info %x\n"
	.section	.rodata.flash_info_flush.str1.1,"aMS",@progbits,1
.LC133:
	.string	"finfo:"
.LC134:
	.string	"flash_info_flush id = %x, page = %x\n"
.LC135:
	.string	"sys_info_flush error:%x\n"
	.section	.rodata.flash_into_data_init.str1.1,"aMS",@progbits,1
.LC73:
	.string	"...%d @ %s\n"
	.section	.rodata.flash_mask_bad_block.str1.1,"aMS",@progbits,1
.LC40:
	.string	"flash_mask_bad_block %d %d\n"
	.section	.rodata.flash_prog_page.str1.1,"aMS",@progbits,1
.LC109:
	.string	"flash_prog_page %x %x %x\n"
.LC110:
	.string	"flash_prog_page page_addr = %x status = %x\n"
	.section	.rodata.flash_prog_page_en.str1.1,"aMS",@progbits,1
.LC115:
	.string	"flash_prog_page_en:%x %x\n"
.LC116:
	.string	"spare"
.LC117:
	.string	"data"
.LC118:
	.string	"write error: %x\n"
	.section	.rodata.flash_read_id.str1.1,"aMS",@progbits,1
.LC38:
	.string	"No.%d FLASH ID:%x %x %x %x %x %x\n"
	.section	.rodata.flash_read_page.str1.1,"aMS",@progbits,1
.LC91:
	.string	"flash_read_page %x %x %x\n"
	.section	.rodata.flash_read_page_en.str1.1,"aMS",@progbits,1
.LC101:
	.string	"flash_read_page_en %x %x\n"
.LC102:
	.string	"flash_read_page_en %x %x error_ecc %d %d\n"
	.section	.rodata.flash_set_interface_mode.str1.1,"aMS",@progbits,1
.LC36:
	.string	"nand sdr mode %x\n"
.LC37:
	.string	"nand ddr mode %x\n"
	.section	.rodata.ftl_alloc_sblk.str1.1,"aMS",@progbits,1
.LC61:
	.string	"alloc sblk %x %d\n"
	.section	.rodata.ftl_info_blk_init.str1.1,"aMS",@progbits,1
.LC121:
	.string	"%d %x @%d %x\n"
.LC122:
	.string	"ftl_info_blk_init %d %d %x\n"
	.section	.rodata.ftl_info_flush.str1.1,"aMS",@progbits,1
.LC120:
	.string	"g_ftl_info_blk blk = %x, page = %x version = %d\n"
	.section	.rodata.ftl_low_format.str1.1,"aMS",@progbits,1
.LC123:
	.string	"low format %d %d %d %d\n"
	.section	.rodata.ftl_mask_bad_block.str1.1,"aMS",@progbits,1
.LC54:
	.string	"mask bad block:cs %x block: %x\n"
	.section	.rodata.ftl_open_sblk_recovery.str1.1,"aMS",@progbits,1
.LC125:
	.string	"saved_active_page  = %x\n"
.LC126:
	.string	"saved_active_plane = %x\n"
.LC127:
	.string	"sblk = %x\n"
.LC128:
	.string	"phy_blk = %x %x\n"
.LC129:
	.string	"blk= %x, page=%x, ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC130:
	.string	"sblk = %x, vpn0 = %d, vpn1 = %d\n"
.LC131:
	.string	"dump write = %x\n"
	.section	.rodata.ftl_re_low_format_test.str1.1,"aMS",@progbits,1
.LC124:
	.string	"re low format %d\n"
	.section	.rodata.ftl_read_ahead.str1.1,"aMS",@progbits,1
.LC158:
	.string	"ftl_read_ahead refresh =%x, lpa = %x, ppa= %x\n"
.LC159:
	.string	"id=%d, lpa = %x, ppa = %x spare = %x %x %x %x\n"
	.section	.rodata.ftl_sblk_dump.str1.1,"aMS",@progbits,1
.LC182:
	.string	"ftl_sblk_dump = %x %x %x %x\n"
.LC183:
	.string	"page_addr = %x, lpa=%x vpn = %d\n"
.LC184:
	.string	"index= %x, lpa=%x\n"
.LC185:
	.string	"block = %x, vpn=%x check vpn = %d\n"
	.section	.rodata.ftl_scan_all_data.str1.1,"aMS",@progbits,1
.LC198:
	.string	"ftl_scan_all_data = %x\n"
.LC199:
	.string	"scan lpa = %x ppa= %x\n"
.LC200:
	.string	"lba = %x,addr= %x, ststus = %x, spare= %x %x %x %x data=%x %x\n"
.LC201:
	.string	"lba = %x, id= %x, index = %x hash ppa = %x\n"
.LC202:
	.string	"0pm:"
.LC203:
	.string	"1pm:"
	.section	.rodata.ftl_sysblk_dump.str1.1,"aMS",@progbits,1
.LC136:
	.string	"l2p:"
	.section	.rodata.ftl_test_block.str1.1,"aMS",@progbits,1
.LC119:
	.string	"low format %d\n"
	.section	.rodata.ftl_update_l2p_map.str1.1,"aMS",@progbits,1
.LC204:
	.string	"ftl_update_l2p_map: %x %x %x\n"
.LC205:
	.string	"ftl_update_l2p_map"
.LC206:
	.string	"lpa_tbl:"
.LC207:
	.string	"sblk %x vpn: %d %d\n"
	.section	.rodata.ftl_vpn_decrement.str1.1,"aMS",@progbits,1
.LC53:
	.string	"ftl_vpn_decrement %x = %d\n"
	.section	.rodata.ftl_write_commit.str1.1,"aMS",@progbits,1
.LC208:
	.string	"%d read error: ppa:%x, lpa:%x, status:%x\n"
	.section	.rodata.ftl_write_completed.str1.1,"aMS",@progbits,1
.LC60:
	.string	"ftl prog error =%x, lpa = %x, ppa= %x\n"
	.section	.rodata.gc_add_sblk.str1.1,"aMS",@progbits,1
.LC41:
	.string	"gc_add_sblk = %d, %d, %d, %d, %d, %d\n"
	.section	.rodata.gc_check_data_one_wl.str1.1,"aMS",@progbits,1
.LC108:
	.string	"1ppa = %x, status = %x, %x %x spare: %x %x %x %x\n"
	.section	.rodata.gc_do_copy_back.str1.1,"aMS",@progbits,1
.LC209:
	.string	"gc page in buf: lpa %x ppa = %x pageindex= %x\n"
.LC210:
	.string	"gc_do_copy_back: lpa %x des_ppa = %x %x gc_ppa= %x page_index= %d\n"
.LC211:
	.string	"gc_do_copy_back: %x %x %x %x gc_ppa:%x %x\n"
.LC212:
	.string	"%d prog_step: %x %x buf id= %x ppa = %x hash=%x id = %x plane = %x lpa=%x\n"
	.section	.rodata.gc_free_src_blk.str1.1,"aMS",@progbits,1
.LC51:
	.string	"gc_free_src_blk = %x, vpn = %d\n"
.LC52:
	.string	"gc_free_src_blk %x, %d\n"
	.section	.rodata.gc_free_temp_buf.str1.1,"aMS",@progbits,1
.LC44:
	.string	"%d gc_free_temp_buf buf id= %x\n"
	.section	.rodata.gc_recovery.str1.1,"aMS",@progbits,1
.LC160:
	.string	"ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC161:
	.string	"ppa = %x, status = %x, %x %x spare: %x %x %x %x\n"
.LC162:
	.string	"gc_recovery"
.LC163:
	.string	"gc_recovery: %x vpn = %x\n"
	.section	.rodata.gc_scan_src_blk.str1.1,"aMS",@progbits,1
.LC196:
	.string	"gc_scan_src_blk = %x, vpn = %d\n"
.LC197:
	.string	"gc_scan_src_blk = %x, s vpn0 = %d, c vpn1 = %d\n"
	.section	.rodata.gc_search_src_blk.str1.1,"aMS",@progbits,1
.LC46:
	.string	"zftl_get_gc_node cache = %x index = %d vpn = %x\n"
.LC47:
	.string	"gc_search_src_blk mode = %x, src mode = %x, count= %d %d\n"
	.section	.rodata.gc_static_wearleveling.str1.1,"aMS",@progbits,1
.LC67:
	.string	"gc_static_wearleveling: slc blk: %d, tlc blk: %d avg slc ec: %d, avg tlc ec: %d \n"
.LC68:
	.string	"gc_static_wearleveling: min slc ec: %d, min tlc ec: %d max slc ec: %d, max tlc ec: %d; %d %d\n"
.LC69:
	.string	"swl add tlc gc = %d, %d, %d, %d, %d, %d\n"
.LC70:
	.string	"swl add slc gc  = %d, %d, %d, %d, %d, %d\n"
	.section	.rodata.gc_update_l2p_map_new.str1.1,"aMS",@progbits,1
.LC177:
	.string	"gc_update_l2p_map_new sblk %x\n"
.LC178:
	.string	"gc_update_l2p_map_new: %x %x %x\n"
.LC179:
	.string	"0lpa: %x %x %x\n"
.LC180:
	.string	"lpa: %x %x %x\n"
.LC181:
	.string	"gc_update_l2p_map_new: %x vpn = %x vpn1 = %x done\n"
	.section	.rodata.gc_write_completed.str1.1,"aMS",@progbits,1
.LC42:
	.string	"status: %x, ppa: %x\n"
.LC43:
	.string	"gc_write_completed: %x  %x  %x %x\n"
	.section	.rodata.hynix_get_read_retry_default.str1.1,"aMS",@progbits,1
.LC81:
	.string	"otp error! %d"
.LC82:
	.string	"rr"
	.section	.rodata.hynix_read_retrial.str1.1,"aMS",@progbits,1
.LC97:
	.string	"hynix RR %d row=%x, count %d, status=%d\n"
	.section	.rodata.idb_write_data.str1.1,"aMS",@progbits,1
.LC111:
	.string	"1 write_idblock fix data %x %x %x\n"
.LC112:
	.string	"write_idblock check fail! %x\n"
.LC113:
	.string	"write_idblock fail! %x\n"
	.section	.rodata.load_l2p_region.str1.1,"aMS",@progbits,1
.LC149:
	.string	"region_id = %d, pm_max_region = %d\n"
.LC150:
	.string	"load_l2p_region no ppa = %x , %x, all setting 0xff....\n"
.LC151:
	.string	"load_l2p_region = %x,%x,%x, %x\n"
.LC152:
	.string	"pm_ppa:"
.LC153:
	.string	"data:"
.LC154:
	.string	"spare:"
	.section	.rodata.lpa_rebuild_hash.str1.1,"aMS",@progbits,1
.LC66:
	.string	"%s %d %d\n"
	.section	.rodata.micron_read_retrial.str1.1,"aMS",@progbits,1
.LC92:
	.string	"micron %d row=%x,count %d,status=%d\n"
.LC93:
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
.LC74:
	.string	"...%s enter... %p\n"
.LC75:
	.string	"0:%x %x %x %x %x\n"
.LC76:
	.string	"g_nandc_ver...%d\n"
	.section	.rodata.nandc_xfer.str1.1,"aMS",@progbits,1
.LC88:
	.string	"dqs data abort %x\n"
.LC89:
	.string	"dqs data timeout %x\n"
.LC90:
	.string	"xfer error %x\n"
	.section	.rodata.nandc_xfer_done.str1.1,"aMS",@progbits,1
.LC83:
	.string	"flash_abort_clear = %d\n"
.LC84:
	.string	"%d mtrans_cnt = %d page_num = %d\n"
.LC85:
	.string	"nandc:"
.LC86:
	.string	"%d flReg.d32=%x %x\n"
.LC87:
	.string	"nandc_xfer_done read error %x\n"
	.section	.rodata.pm_alloc_new_blk.str1.1,"aMS",@progbits,1
.LC64:
	.string	"blk %x is bad block\n"
.LC65:
	.string	"pm_alloc_new_blk: %x %x %x %x\n"
	.section	.rodata.pm_free_sblk.str1.1,"aMS",@progbits,1
.LC72:
	.string	"ftl_free_no_use_map_blk %x %x %x %d\n"
	.section	.rodata.pm_init.str1.1,"aMS",@progbits,1
.LC155:
	.string	"pm_init posr %x %x %x\n"
.LC156:
	.string	"pm_init recovery %x %x %x\n"
	.section	.rodata.pm_log2phys.str1.1,"aMS",@progbits,1
.LC157:
	.string	"pm_log2phys  lpn = %d, max lpn = %d\n"
	.section	.rodata.pm_ppa_update_check.str1.1,"aMS",@progbits,1
.LC148:
	.string	"%s w error lpn = %x, max ppa = %d\n"
	.section	.rodata.pm_write_page.str1.1,"aMS",@progbits,1
.LC132:
	.string	"pm_write_page write error: %x\n"
	.section	.rodata.print_ftl_debug_info.str1.1,"aMS",@progbits,1
.LC55:
	.string	"free blk: s:%x,t:%x,m:%x, data blk:s:%x,%x,t%x vpn: s:%x t:%x, max_vpn: %x\n"
.LC56:
	.string	"totle w: %d MB,r: %d MB %d dv:0x%X,poc:%d\n"
.LC57:
	.string	"gc xlc page: %d,gc slc page: %d, tmp w: %d MB\n"
.LC58:
	.string	"slc ec: %d,%d,%d,%d,%d,tlc ec: %d,%d,%d,%d,%d\n"
.LC59:
	.string	"gc th: tlc_tlc: %d tlc_slc: %d slc_slc: %d slc_tlc:%d free_th: %d\n"
	.section	.rodata.print_gc_debug_info.str1.1,"aMS",@progbits,1
.LC45:
	.string	"gc: b:%x,p:%x,i:%x; free buf=%d %d free slc th: %d\n"
	.section	.rodata.print_list_info.str1.1,"aMS",@progbits,1
.LC49:
	.string	"list count:%p %d\n"
.LC50:
	.string	"%d: node:%x %x %x %x, %d %d %d %d %d\n"
	.section	.rodata.queue_wait_first_req_completed.str1.1,"aMS",@progbits,1
.LC107:
	.string	"set buf %d,status = %x, ppa = %x lun state = %d\n"
	.section	.rodata.random_seed,"a",@progbits
	.align	3
	.set	.LANCHOR45,. + 0
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
.LC176:
	.string	"zftl_init %x\n"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",@progbits,1
.LC77:
	.string	"%s 0x%x:"
.LC78:
	.string	"%x "
.LC79:
	.string	""
.LC80:
	.string	"%s\n"
	.section	.rodata.sandisk_prog_test_bad_block.str1.1,"aMS",@progbits,1
.LC39:
	.string	"bad block test:%x %x\n"
	.section	.rodata.sblk_prog_page.str1.1,"aMS",@progbits,1
.LC114:
	.string	"sblk_prog_page ppa = %x, count = %d\n"
	.section	.rodata.toshiba_15ref_value,"a",@progbits
	.align	3
	.set	.LANCHOR15,. + 0
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
	.set	.LANCHOR29,. + 0
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
	.set	.LANCHOR28,. + 0
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
.LC94:
	.string	"toshiba SRR %d row=%x, status=%d\n"
.LC95:
	.string	"toshiba TRR %d row=%x, status=%d\n"
.LC96:
	.string	"toshiba RR %d row=%x,count %d,status=%d\n"
	.section	.rodata.toshiba_A19ref_value,"a",@progbits
	.align	3
	.set	.LANCHOR16,. + 0
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
	.set	.LANCHOR18,. + 0
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
	.section	.rodata.vpn_check.str1.1,"aMS",@progbits,1
.LC188:
	.string	"acblk = %x, tempblk = %x, gc_des = %x\n"
.LC189:
	.string	"acblk = %x, free page = %x, vpn = %x %x\n"
.LC190:
	.string	"tmp_blk = %x, free page = %x, vpn = %x %x\n"
.LC191:
	.string	"vpn_check lpa = %x, ppa = %x, blk = %x\n"
.LC192:
	.string	"l2p"
.LC193:
	.string	"vpn_check %x = c %x  s %x function: %x\n"
.LC194:
	.string	"vpn_check blk = %x fix vpc\n"
.LC195:
	.string	"...%s exit...%d\n"
	.section	.rodata.zftl_discard.str1.1,"aMS",@progbits,1
.LC213:
	.string	"ftl_discard:(%x, %x, %x, %x)\n"
	.section	.rodata.zftl_do_gc.str1.1,"aMS",@progbits,1
.LC214:
	.string	"gc %d: %d %d %d %d %d %d %d\n"
.LC215:
	.string	"gc %d: %d %d %d %d %d %d\n"
.LC216:
	.string	"GC_STATE_SCAN_ALL_PAGE = %x, vpn0 = %d, vpn1 = %d\n"
.LC217:
	.string	"gc free %x, %d\n"
.LC218:
	.string	"error gc slc free sblk = %x, vpn = %d %d\n"
.LC219:
	.string	"vpage0:"
.LC220:
	.string	"block %x, vpn = %d %d %d %d\n"
.LC221:
	.string	"block %x, vpn = %d %d\n"
.LC222:
	.string	"vpage1:"
	.section	.rodata.zftl_get_free_sblk.str1.1,"aMS",@progbits,1
.LC48:
	.string	"zftl_get_free_sblk %x %d, %p %d %d\n"
	.section	.rodata.zftl_init.str1.1,"aMS",@progbits,1
.LC164:
	.string	"FTL version: 6.0.7 20180411"
.LC165:
	.string	"_c_user_data_density := %d\n"
.LC166:
	.string	"_c_totle_phy_density := %d\n"
.LC167:
	.string	"_c_totle_log_page := %d\n"
.LC168:
	.string	"_c_totle_data_density := %d\n"
.LC169:
	.string	"_c_ftl_pm_page_num := %d\n"
.LC170:
	.string	"_c_ftl_byte_pre_page := %d\n"
.LC171:
	.string	"_c_max_pm_sblk := %d\n"
.LC172:
	.string	"_min_slc_super_block := %d\n"
.LC173:
	.string	"_max_xlc_super_block := %d\n"
.LC174:
	.string	"gp_ftl_ext_info %p %p %p\n"
.LC175:
	.string	"flash info size: %d %d %d\n"
	.section	.rodata.zftl_read.str1.1,"aMS",@progbits,1
.LC186:
	.string	"ftl_read %x %x %x\n"
.LC187:
	.string	"ftl_read refresh =%x, lpa = %x, ppa= %x\n"
	.section	.rodata.zftl_sblk_list_init.str1.1,"aMS",@progbits,1
.LC71:
	.string	"free blk vpn error: %x %x\n"
	.section	.rodata.zftl_write.str1.1,"aMS",@progbits,1
.LC223:
	.string	"ftlwrite %x %x %x\n"
	.hidden	free
