/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2018-03-15
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
	adrp	x3, .LANCHOR0
	and	w1, w1, 65535
	mov	w5, 65535
	ldr	x7, [x0]
	ldr	x4, [x3, #:lo12:.LANCHOR0]
	mov	w3, 6
	umull	x1, w1, w3
	add	x6, x4, x1
	ldrh	w3, [x4, x1]
	cmp	w3, w5
	ldrh	w5, [x6, 2]
	bne	.L7
	cmp	w5, w3
	bne	.L7
	cmp	x6, x7
	bne	.L6
.L7:
	mov	w8, 65535
	cmp	w5, w8
	bne	.L9
	cmp	x6, x7
	beq	.L9
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR1
	adrp	x0, .LC0
	mov	w2, 182
	add	x29, sp, 0
	add	x1, x1, :lo12:.LANCHOR1
	add	x0, x0, :lo12:.LC0
	bl	printf
.L10:
	b	.L10
.L9:
	cmp	x6, x7
	mov	w7, 65535
	bne	.L11
	cmp	w3, w7
	bne	.L12
	str	xzr, [x0]
.L13:
	mov	w0, -1
	strh	w0, [x4, x1]
	strh	w0, [x6, 2]
	ldrh	w0, [x2]
	sub	w0, w0, #1
	strh	w0, [x2]
.L6:
	ret
.L12:
	mov	w5, 6
	umaddl	x3, w3, w5, x4
	str	x3, [x0]
	mov	w0, -1
	strh	w0, [x3, 2]
	b	.L13
.L11:
	cmp	w3, w7
	bne	.L14
	cmp	w5, w3
	beq	.L13
	mov	w0, 6
	umull	x5, w5, w0
	mov	w0, -1
	strh	w0, [x4, x5]
	b	.L13
.L14:
	mov	w7, 6
	umaddl	x0, w3, w7, x4
	strh	w5, [x0, 2]
	ldrh	w0, [x6, 2]
	umull	x0, w0, w7
	strh	w3, [x4, x0]
	b	.L13
	.size	_list_remove_node, .-_list_remove_node
	.section	.text._list_pop_index_node,"ax",@progbits
	.align	2
	.type	_list_pop_index_node, %function
_list_pop_index_node:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldr	x20, [x0]
	cbz	x20, .L24
	adrp	x3, .LANCHOR0
	and	w1, w1, 65535
	mov	w4, 65535
	mov	w5, 6
	ldr	x19, [x3, #:lo12:.LANCHOR0]
.L20:
	cbnz	w1, .L21
.L23:
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
.L18:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L21:
	ldrh	w3, [x20]
	cmp	w3, w4
	beq	.L23
	sub	w1, w1, #1
	umaddl	x20, w3, w5, x19
	and	w1, w1, 65535
	b	.L20
.L24:
	mov	w0, 65535
	b	.L18
	.size	_list_pop_index_node, .-_list_pop_index_node
	.section	.text._insert_free_list,"ax",@progbits
	.align	2
	.type	_insert_free_list, %function
_insert_free_list:
	adrp	x3, .LANCHOR2
	and	w1, w1, 65535
	ldrh	w3, [x3, #:lo12:.LANCHOR2]
	cmp	w3, w1
	bls	.L26
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
	cbnz	x8, .L28
.L33:
	str	x7, [x0]
	ret
.L28:
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
.L31:
	ubfiz	x13, x2, 2, 16
	ldr	w5, [x11, x13]
	ldrh	w13, [x11, x13]
	ubfx	x5, x5, 11, 8
	and	w13, w13, 2047
	add	w5, w13, w5, lsl 3
	and	w5, w5, 4095
	cmp	w4, w5
	bls	.L29
	ldrh	w5, [x3]
	cmp	w5, w14
	bne	.L30
	strh	w2, [x7, 2]
	strh	w1, [x3]
	ret
.L30:
	umaddl	x3, w5, w10, x6
	mov	w2, w5
	b	.L31
.L29:
	ldrh	w4, [x3, 2]
	cmp	x8, x3
	strh	w4, [x7, 2]
	strh	w2, [x6, x12]
	bne	.L32
	strh	w1, [x8, 2]
	b	.L33
.L32:
	ldrh	w0, [x3, 2]
	mov	w2, 6
	umull	x0, w0, w2
	strh	w1, [x6, x0]
	strh	w1, [x3, 2]
.L26:
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
	bls	.L50
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
	cbnz	x8, .L37
	str	x7, [x0]
	ret
.L37:
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
.L45:
	add	w10, w10, 1
	and	w10, w10, 65535
	cmp	w10, w30
	bhi	.L34
	cmp	w1, w2
	beq	.L34
	uxtw	x4, w2
	ldrh	w20, [x5, 4]
	cmp	w20, 0
	ldrh	w3, [x15, x4, lsl 1]
	mul	w3, w3, w20
	csel	w3, w3, w12, ne
	cmp	w14, w3
	bne	.L41
	lsl	x4, x4, 2
	ldr	w3, [x17, x4]
	ldrh	w4, [x17, x4]
	ubfx	x3, x3, 11, 8
	and	w4, w4, 2047
	add	w3, w4, w3, lsl 3
	and	w3, w3, 4095
	cmp	w16, w3
	bhi	.L43
.L42:
	ldrh	w3, [x5, 2]
	cmp	x8, x5
	strh	w3, [x7, 2]
	strh	w2, [x6, x13]
	bne	.L46
	strh	w1, [x8, 2]
	str	x7, [x0]
	b	.L34
.L41:
	bcc	.L42
.L43:
	ldrh	w3, [x5]
	cmp	w3, w19
	bne	.L44
	strh	w2, [x7, 2]
	strh	w1, [x5]
.L34:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L44:
	umaddl	x5, w3, w11, x6
	mov	w2, w3
	b	.L45
.L46:
	ldrh	w0, [x5, 2]
	mov	w2, 6
	umull	x0, w0, w2
	strh	w1, [x6, x0]
	strh	w1, [x5, 2]
	b	.L34
.L50:
	ret
	.size	_insert_data_list, .-_insert_data_list
	.section	.text._list_get_gc_head_node.isra.2,"ax",@progbits
	.align	2
	.type	_list_get_gc_head_node.isra.2, %function
_list_get_gc_head_node.isra.2:
	and	w1, w1, 65535
	cbz	x0, .L57
	adrp	x2, .LANCHOR0
	mov	w3, 65535
	mov	w4, 6
	ldr	x2, [x2, #:lo12:.LANCHOR0]
.L54:
	cbz	w1, .L55
	ldrh	w0, [x0]
	cmp	w0, w3
	bne	.L56
	ret
.L56:
	sub	w1, w1, #1
	umaddl	x0, w0, w4, x2
	and	w1, w1, 65535
	b	.L54
.L57:
	mov	w0, 65535
	ret
.L55:
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
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w1, 65535
	adrp	x1, .LANCHOR5
	ldr	x1, [x1, #:lo12:.LANCHOR5]
	ldrh	w3, [x1, 16]
	str	x21, [sp, 32]
	cmp	w3, w19
	beq	.L59
	ldrh	w3, [x1, 48]
	cmp	w3, w19
	beq	.L59
	ldrh	w1, [x1, 80]
	cmp	w1, w19
	beq	.L59
	adrp	x1, .LANCHOR0
	mov	w3, 6
	ldr	x4, [x1, #:lo12:.LANCHOR0]
	umull	x3, w19, w3
	ldr	x1, [x0]
	add	x5, x4, x3
	cmp	x5, x1
	beq	.L59
	ldrh	w1, [x5, 2]
	mov	x20, x0
	mov	x21, x2
	mov	w0, 65535
	cmp	w1, w0
	bne	.L61
	ldrh	w0, [x4, x3]
	cmp	w0, w1
	bne	.L61
	adrp	x1, .LANCHOR6
	adrp	x0, .LC0
	mov	w2, 249
	add	x1, x1, :lo12:.LANCHOR6
	add	x0, x0, :lo12:.LC0
	bl	printf
.L62:
	b	.L62
.L61:
	adrp	x0, .LANCHOR4
	ubfiz	x2, x19, 1, 16
	ldrh	w5, [x5, 4]
	mov	w6, -1
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	cmp	w5, 0
	ldrh	w3, [x0, x2]
	mov	w2, 6
	umull	x1, w1, w2
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	mul	w3, w3, w5
	asr	x5, x1, 1
	add	x1, x4, x1
	csel	w3, w3, w6, ne
	mul	x5, x5, x2
	ldrh	w1, [x1, 4]
	cmp	w1, 0
	ldrh	w0, [x0, x5, lsl 1]
	mul	w0, w0, w1
	csel	w0, w0, w6, ne
	cmp	w3, w0
	bcs	.L59
	mov	x2, x21
	mov	w1, w19
	mov	x0, x20
	bl	_list_remove_node
	mov	x2, x21
	mov	w1, w19
	mov	x0, x20
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	_insert_data_list
.L59:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
	.size	_list_update_data_list, .-_list_update_data_list
	.section	.text.nand_flash_print_info,"ax",@progbits
	.align	2
	.global	nand_flash_print_info
	.type	nand_flash_print_info, %function
nand_flash_print_info:
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
.L70:
	ldr	w0, [sp, 12]
	sub	w1, w0, #1
	str	w1, [sp, 12]
	cbnz	w0, .L70
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
	adrp	x6, .LANCHOR11
	add	x6, x6, :lo12:.LANCHOR11
	adrp	x3, .LANCHOR7
	add	x3, x3, :lo12:.LANCHOR7
	umull	x2, w2, w0
	adrp	x0, .LANCHOR8
	add	x7, x0, :lo12:.LANCHOR8
	mov	x5, x0
	ldrb	w0, [x6]
	add	x3, x3, x2
	add	x7, x7, x2
	adrp	x8, .LANCHOR9
	mov	x2, 0
	adrp	x10, .LANCHOR10
	add	x8, x8, :lo12:.LANCHOR9
	add	x10, x10, :lo12:.LANCHOR10
	cmp	w0, w2
	bhi	.L83
	ret
.L77:
	cmp	w0, 35
	bne	.L79
	ldrsb	w0, [x3, x2]
	b	.L84
.L79:
	ldrsb	w0, [x10, w11, sxtw]
	b	.L84
.L83:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L80:
	mov	w0, 85
	str	w0, [x4, 8]
	add	x0, x5, :lo12:.LANCHOR8
	ldrsb	w0, [x2, x0]
	str	w0, [x4, 4]
	mov	w0, 200
	bl	timer_delay_ns
	ldrb	w0, [x8]
	cmp	w0, 34
	bne	.L77
	ldrsb	w0, [x7, x2]
.L84:
	str	w0, [x4]
	add	x2, x2, 1
	ldrb	w0, [x6]
	cmp	w0, w2
	bhi	.L80
	ldp	x29, x30, [sp], 16
	ret
	.size	toshiba_set_rr_para, .-toshiba_set_rr_para
	.section	.text.hynix_set_rr_para,"ax",@progbits
	.align	2
	.type	hynix_set_rr_para, %function
hynix_set_rr_para:
	adrp	x2, .LANCHOR12
	and	w1, w1, 255
	mov	x3, 32
	and	w0, w0, 255
	ldr	x2, [x2, #:lo12:.LANCHOR12]
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
	bhi	.L91
	mov	w0, 22
	str	w0, [x3, 2056]
	ret
.L91:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L87:
	ldrb	w0, [x6, x4]
	str	w0, [x3, 2052]
	mov	w0, 120
	bl	timer_delay_ns
	ldrsb	w0, [x2, x4]
	str	w0, [x3, 2048]
	add	x4, x4, 1
	cmp	w5, w4, uxtb
	bhi	.L87
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
	adrp	x1, .LANCHOR9
	ldrb	w1, [x1, #:lo12:.LANCHOR9]
	sub	w1, w1, #1
	and	w1, w1, 255
	cmp	w1, 6
	bhi	.L98
	adrp	x8, .LANCHOR12
	and	w0, w0, 255
	sxtw	x7, w0
	ldr	x1, [x8, #:lo12:.LANCHOR12]
	add	x1, x1, x7
	ldrb	w1, [x1, 120]
	cbz	w1, .L98
	stp	x29, x30, [sp, -16]!
	mov	w1, 0
	add	x29, sp, 0
	bl	hynix_set_rr_para
	ldr	x0, [x8, #:lo12:.LANCHOR12]
	add	x0, x0, x7
	strb	wzr, [x0, 120]
	ldp	x29, x30, [sp], 16
	ret
.L98:
	ret
	.size	hynix_reconfig_rr_para, .-hynix_reconfig_rr_para
	.section	.text.nandc_set_ddr_para,"ax",@progbits
	.align	2
	.global	nandc_set_ddr_para
	.type	nandc_set_ddr_para, %function
nandc_set_ddr_para:
	adrp	x1, .LANCHOR14
	and	w0, w0, 255
	adrp	x2, .LANCHOR13
	ldrb	w1, [x1, #:lo12:.LANCHOR14]
	ldr	x2, [x2, #:lo12:.LANCHOR13]
	cmp	w1, 9
	lsl	w1, w0, 16
	lsl	w0, w0, 8
	orr	w1, w1, w0
	orr	w1, w1, 3
	bne	.L102
	str	w1, [x2, 80]
	ret
.L102:
	str	w1, [x2, 304]
	ret
	.size	nandc_set_ddr_para, .-nandc_set_ddr_para
	.section	.text.nandc_get_ddr_para,"ax",@progbits
	.align	2
	.global	nandc_get_ddr_para
	.type	nandc_get_ddr_para, %function
nandc_get_ddr_para:
	adrp	x0, .LANCHOR14
	ldrb	w0, [x0, #:lo12:.LANCHOR14]
	cmp	w0, 9
	adrp	x0, .LANCHOR13
	ldr	x0, [x0, #:lo12:.LANCHOR13]
	bne	.L105
	ldr	w0, [x0, 80]
.L107:
	ubfx	x0, x0, 8, 8
	ret
.L105:
	ldr	w0, [x0, 304]
	b	.L107
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
	beq	.L109
	tst	x0, 4
	orr	w1, w1, 24576
	adrp	x0, .LANCHOR14
	and	w1, w1, -32769
	orr	w1, w1, 196608
	ldrb	w0, [x0, #:lo12:.LANCHOR14]
	orr	w3, w1, 32768
	csel	w1, w3, w1, ne
	cmp	w0, 9
	mov	w0, 4099
	movk	w0, 0x10, lsl 16
	bne	.L111
	mov	w3, 8321
	str	w3, [x2, 8]
	str	w0, [x2, 80]
	mov	w0, 38
	str	w0, [x2, 84]
	mov	w0, 39
	str	w0, [x2, 84]
.L112:
	str	w1, [x2]
	ret
.L111:
	mov	w3, 8322
	str	w3, [x2, 344]
	str	w0, [x2, 304]
	mov	w0, 38
	str	w0, [x2, 308]
	mov	w0, 39
	str	w0, [x2, 308]
	b	.L112
.L109:
	and	w1, w1, -8193
	b	.L112
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
	.section	.text.flash_wait_device_ready_raw,"ax",@progbits
	.align	2
	.global	flash_wait_device_ready_raw
	.type	flash_wait_device_ready_raw, %function
flash_wait_device_ready_raw:
	stp	x29, x30, [sp, -16]!
	mov	w5, w1
	adrp	x1, .LANCHOR15
	and	w0, w0, 255
	add	x29, sp, 0
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	cmp	w1, w0
	bhi	.L118
	adrp	x1, .LANCHOR16
	adrp	x0, .LC0
	mov	w2, 620
	add	x1, x1, :lo12:.LANCHOR16
	add	x0, x0, :lo12:.LC0
	bl	printf
.L119:
	b	.L119
.L118:
	adrp	x1, .LANCHOR17
	add	x1, x1, :lo12:.LANCHOR17
	mov	w7, w2
	ldrb	w6, [x1, w0, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x4, [x0, #:lo12:.LANCHOR13]
	mov	w0, w6
	bl	nandc_cs
	ubfiz	x3, x6, 8, 8
	add	x3, x4, x3
	mov	w0, 120
	and	w1, w5, 255
	str	w0, [x3, 2056]
	str	w1, [x3, 2052]
	lsr	w1, w5, 8
	str	w1, [x3, 2052]
	lsr	w5, w5, 16
	str	w5, [x3, 2052]
.L126:
	bl	timer_delay_ns
	ldr	w2, [x3, 2048]
	and	w2, w2, 255
	bics	wzr, w7, w2
	bne	.L121
	cmp	w2, 255
	beq	.L121
	mov	w0, w6
	bl	nandc_de_cs
	ldp	x29, x30, [sp], 16
	mov	w0, w2
	ret
.L121:
	mov	w0, 20
	b	.L126
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
	bne	.L128
	adrp	x0, .LANCHOR18
	adrp	x5, .LANCHOR19
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	cbz	w0, .L129
	ldrb	w0, [x5, #:lo12:.LANCHOR19]
	cbz	w0, .L128
.L129:
	adrp	x0, .LANCHOR20
	ldrh	w3, [x0, #:lo12:.LANCHOR20]
	ldrb	w0, [x5, #:lo12:.LANCHOR19]
	udiv	w4, w1, w3
	mul	w4, w4, w3
	sub	w3, w1, w4
	cbz	w0, .L130
	add	w1, w4, w3, lsl 1
.L128:
	mov	w0, w6
	b	flash_wait_device_ready_raw
.L130:
	adrp	x5, .LANCHOR21
	add	x5, x5, :lo12:.LANCHOR21
	ldrh	w3, [x5, w3, uxtw 1]
	add	w1, w3, w4
	b	.L128
	.size	flash_wait_device_ready, .-flash_wait_device_ready
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
.L139:
	mov	w0, 100
	bl	timer_delay_ns
	ldr	x0, [x3, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbnz	x0, 9, .L140
	subs	w2, w2, #1
	bne	.L139
	mov	w0, -1
.L137:
	ldp	x29, x30, [sp], 32
	ret
.L140:
	mov	w0, 0
	b	.L137
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
	adrp	x0, .LANCHOR11
	adrp	x2, .LANCHOR7
	add	x2, x2, :lo12:.LANCHOR7
	ldrb	w4, [x0, #:lo12:.LANCHOR11]
	adrp	x0, .LANCHOR9
	ldrb	w5, [x0, #:lo12:.LANCHOR9]
	mov	w0, 5
	umull	x1, w1, w0
	adrp	x0, .LANCHOR8
	add	x0, x0, :lo12:.LANCHOR8
	add	x2, x2, x1
	add	x1, x0, x1
	mov	x0, 0
.L144:
	cmp	w4, w0
	bhi	.L147
	ldp	x29, x30, [sp], 16
	b	nandc_wait_flash_ready
.L147:
	cmp	w5, 67
	bne	.L145
	ldrsb	w6, [x1, x0]
.L149:
	add	x0, x0, 1
	str	w6, [x3]
	b	.L144
.L145:
	ldrsb	w6, [x2, x0]
	b	.L149
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
	adrp	x0, .LANCHOR22
	add	x0, x0, :lo12:.LANCHOR22
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
	adrp	x2, .LANCHOR23
	add	x2, x2, :lo12:.LANCHOR23
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
	cbz	w2, .L154
	stp	x29, x30, [sp, -16]!
	mov	x4, x0
	mov	x2, 7
	mov	w0, 18
	add	x29, sp, 0
	str	w6, [x4, 8]
	mul	x1, x1, x2
	str	w0, [x4, 4]
	adrp	x0, .LANCHOR24
	add	x0, x0, :lo12:.LANCHOR24
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
.L157:
	b	nandc_wait_flash_ready
.L154:
	str	w6, [x0, 8]
	mov	w2, 20
	str	w2, [x0, 4]
	adrp	x2, .LANCHOR25
	add	x2, x2, :lo12:.LANCHOR25
	ldrb	w1, [x2, x1]
	str	w1, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	b	.L157
	.size	toshiba_tlc_set_rr_para, .-toshiba_tlc_set_rr_para
	.section	.text.zftl_flash_enter_slc_mode,"ax",@progbits
	.align	2
	.global	zftl_flash_enter_slc_mode
	.type	zftl_flash_enter_slc_mode, %function
zftl_flash_enter_slc_mode:
	adrp	x1, .LANCHOR18
	and	x0, x0, 255
	ldrb	w2, [x1, #:lo12:.LANCHOR18]
	cbz	w2, .L160
	adrp	x1, .LANCHOR13
	cmp	w2, 1
	ldr	x1, [x1, #:lo12:.LANCHOR13]
	bne	.L163
.L180:
	adrp	x2, .LANCHOR26+29
	ldrb	w2, [x2, #:lo12:.LANCHOR26+29]
	cbz	w2, .L160
	add	x0, x0, 8
	add	x0, x1, x0, lsl 8
	str	w2, [x0, 8]
	ret
.L163:
	cmp	w2, 2
	bne	.L165
	adrp	x2, .LANCHOR27
	ldrb	w3, [x2, #:lo12:.LANCHOR27]
	cbz	w3, .L160
	strb	wzr, [x2, #:lo12:.LANCHOR27]
	b	.L180
.L165:
	cmp	w2, 3
	bne	.L160
	adrp	x2, .LANCHOR27
	ldrb	w3, [x2, #:lo12:.LANCHOR27]
	cbz	w3, .L160
	ubfiz	x0, x0, 8, 8
	strb	wzr, [x2, #:lo12:.LANCHOR27]
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
.L160:
	ret
	.size	zftl_flash_enter_slc_mode, .-zftl_flash_enter_slc_mode
	.section	.text.zftl_flash_exit_slc_mode,"ax",@progbits
	.align	2
	.global	zftl_flash_exit_slc_mode
	.type	zftl_flash_exit_slc_mode, %function
zftl_flash_exit_slc_mode:
	adrp	x1, .LANCHOR18
	and	x0, x0, 255
	ldrb	w2, [x1, #:lo12:.LANCHOR18]
	cbz	w2, .L181
	adrp	x1, .LANCHOR13
	cmp	w2, 1
	ldr	x1, [x1, #:lo12:.LANCHOR13]
	bne	.L184
	adrp	x2, .LANCHOR26+30
	ldrb	w2, [x2, #:lo12:.LANCHOR26+30]
.L201:
	cbz	w2, .L181
	add	x0, x0, 8
	add	x0, x1, x0, lsl 8
	str	w2, [x0, 8]
	ret
.L184:
	cmp	w2, 2
	bne	.L186
	adrp	x4, .LANCHOR27
	ldrb	w2, [x4, #:lo12:.LANCHOR27]
	cbnz	w2, .L181
	adrp	x2, .LANCHOR26
	add	x2, x2, :lo12:.LANCHOR26
	mov	w5, 4
	ldrb	w3, [x2, 12]
	ldrb	w2, [x2, 30]
	cmp	w3, 2
	csel	w3, w3, w5, eq
	strb	w3, [x4, #:lo12:.LANCHOR27]
	b	.L201
.L186:
	cmp	w2, 3
	bne	.L181
	adrp	x3, .LANCHOR27
	ldrb	w2, [x3, #:lo12:.LANCHOR27]
	cbnz	w2, .L181
	ubfiz	x0, x0, 8, 8
	adrp	x2, .LANCHOR26+12
	add	x0, x1, x0
	mov	w1, 239
	ldrb	w2, [x2, #:lo12:.LANCHOR26+12]
	mov	w4, 4
	str	w1, [x0, 2056]
	cmp	w2, 2
	mov	w1, 145
	str	w1, [x0, 2052]
	csel	w2, w2, w4, eq
	str	w2, [x0, 2048]
	mov	w1, 1
	str	w1, [x0, 2048]
	str	wzr, [x0, 2048]
	str	wzr, [x0, 2048]
	strb	w2, [x3, #:lo12:.LANCHOR27]
	b	nandc_wait_flash_ready
.L181:
	ret
	.size	zftl_flash_exit_slc_mode, .-zftl_flash_exit_slc_mode
	.section	.text.flash_erase_duplane_block,"ax",@progbits
	.align	2
	.global	flash_erase_duplane_block
	.type	flash_erase_duplane_block, %function
flash_erase_duplane_block:
	stp	x29, x30, [sp, -80]!
	and	w0, w0, 255
	add	x29, sp, 0
	str	x25, [sp, 64]
	and	w25, w1, 255
	adrp	x1, .LANCHOR15
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	stp	x23, x24, [sp, 48]
	cmp	w1, w0
	bhi	.L203
	adrp	x1, .LANCHOR28
	adrp	x0, .LC0
	mov	w2, 531
	add	x1, x1, :lo12:.LANCHOR28
	add	x0, x0, :lo12:.LC0
	bl	printf
.L204:
	b	.L204
.L203:
	adrp	x1, .LANCHOR17
	add	x1, x1, :lo12:.LANCHOR17
	mov	w22, w2
	mov	w21, w3
	ldrb	w20, [x1, w0, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x24, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR29
	and	x19, x20, 255
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	add	x23, x19, 8
	add	x23, x24, x23, lsl 8
	tbz	x0, 4, .L205
	adrp	x0, .LC1
	mov	w1, w20
	add	x0, x0, :lo12:.LC1
	bl	printf
.L205:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w25, .L206
	bl	zftl_flash_enter_slc_mode
.L207:
	add	x24, x24, x19, lsl 8
	mov	w0, 96
	str	w0, [x24, 2056]
	and	w0, w22, 255
	str	w0, [x24, 2052]
	lsr	w0, w22, 8
	str	w0, [x24, 2052]
	lsr	w0, w22, 16
	str	w0, [x24, 2052]
	adrp	x0, .LANCHOR30
	ldrb	w0, [x0, #:lo12:.LANCHOR30]
	cbnz	w0, .L210
	mov	w0, 208
	str	w0, [x24, 2056]
	mov	w19, 5
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	and	w5, w0, w19
.L208:
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
	cbz	w19, .L209
	adrp	x0, .LC2
	mov	w1, w22
	add	x0, x0, :lo12:.LC2
	bl	printf
.L209:
	mov	w0, w19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L206:
	bl	zftl_flash_exit_slc_mode
	b	.L207
.L210:
	mov	w5, 0
	b	.L208
	.size	flash_erase_duplane_block, .-flash_erase_duplane_block
	.section	.text.flash_erase_block_en,"ax",@progbits
	.align	2
	.global	flash_erase_block_en
	.type	flash_erase_block_en, %function
flash_erase_block_en:
	stp	x29, x30, [sp, -64]!
	and	w0, w0, 255
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w24, w1, 255
	adrp	x1, .LANCHOR15
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	cmp	w1, w0
	bhi	.L219
	adrp	x1, .LANCHOR31
	adrp	x0, .LC0
	mov	w2, 576
	add	x1, x1, :lo12:.LANCHOR31
	add	x0, x0, :lo12:.LC0
	bl	printf
.L220:
	b	.L220
.L219:
	adrp	x1, .LANCHOR17
	add	x1, x1, :lo12:.LANCHOR17
	mov	w21, w2
	ldrb	w20, [x1, w0, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x23, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR29
	and	x19, x20, 255
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	add	x22, x19, 8
	add	x22, x23, x22, lsl 8
	tbz	x0, 4, .L221
	adrp	x0, .LC3
	mov	w1, w20
	add	x0, x0, :lo12:.LC3
	bl	printf
.L221:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w24, .L222
	bl	zftl_flash_enter_slc_mode
.L223:
	add	x0, x23, x19, lsl 8
	mov	w2, 96
	and	w1, w21, 2097151
	str	w2, [x0, 2056]
	and	w2, w21, 255
	str	w2, [x0, 2052]
	lsr	w2, w1, 8
	str	w2, [x0, 2052]
	lsr	w1, w1, 16
	str	w1, [x0, 2052]
	mov	w1, 208
	str	w1, [x0, 2056]
	bl	nandc_wait_flash_ready
	mov	x0, x22
	bl	flash_read_status
	mov	w19, w0
	mov	w0, w20
	bl	nandc_de_cs
	mov	w0, 5
	ands	w19, w19, w0
	beq	.L224
	adrp	x0, .LANCHOR20
	mov	w2, w19
	ldrh	w1, [x0, #:lo12:.LANCHOR20]
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	udiv	w1, w21, w1
	bl	printf
.L224:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L222:
	bl	zftl_flash_exit_slc_mode
	b	.L223
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
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR20
	stp	x21, x22, [sp, 32]
	add	x23, x23, :lo12:.LANCHOR20
	ldrh	w20, [x0, 14]
	adrp	x22, .LANCHOR15
	str	x25, [sp, 64]
	add	x22, x22, :lo12:.LANCHOR15
	adrp	x24, .LANCHOR17
	ldrb	w1, [x0, 13]
	mul	w20, w20, w1
	and	w20, w20, 65535
.L234:
	ldrb	w0, [x22]
	cmp	w0, w19
	bhi	.L237
	ldp	x19, x20, [sp, 16]
	mov	w1, 0
	ldp	x21, x22, [sp, 32]
	adrp	x0, .LC5
	ldp	x23, x24, [sp, 48]
	add	x0, x0, :lo12:.LC5
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	b	printf
.L237:
	add	x0, x24, :lo12:.LANCHOR17
	mov	w21, 0
	ldrb	w25, [x0, w19, sxtw]
.L235:
	cmp	w20, w21, uxth
	bhi	.L236
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L234
.L236:
	ldrh	w1, [x23]
	mov	w0, w25
	mul	w1, w1, w21
	add	w21, w21, 1
	bl	flash_erase_block
	b	.L235
	.size	flash_erase_all, .-flash_erase_all
	.section	.text.flash_set_interface_mode,"ax",@progbits
	.align	2
	.global	flash_set_interface_mode
	.type	flash_set_interface_mode, %function
flash_set_interface_mode:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR13
	adrp	x5, .LANCHOR33
	add	x5, x5, :lo12:.LANCHOR33
	add	x29, sp, 0
	ldr	x6, [x1, #:lo12:.LANCHOR13]
	adrp	x1, .LANCHOR32
	mov	x2, 0
	mov	w11, 69
	ldrb	w1, [x1, #:lo12:.LANCHOR32]
	mov	w7, 239
	mov	w8, 128
	mov	w12, 1
	and	w10, w1, 4
	and	w4, w1, 1
	mov	w13, 35
	mov	w14, 5
.L247:
	lsl	x1, x2, 3
	ldrb	w3, [x1, x5]
	cmp	w3, 152
	ccmp	w3, w11, 4, ne
	beq	.L240
	cmp	w3, 44
	bne	.L241
.L240:
	cmp	w0, 1
	bne	.L242
	cbz	w4, .L241
	add	x1, x6, x2, lsl 8
	cmp	w3, 44
	str	w7, [x1, 2056]
	bne	.L243
	str	w0, [x1, 2052]
	str	w14, [x1, 2048]
.L246:
	str	wzr, [x1, 2048]
	str	wzr, [x1, 2048]
	str	wzr, [x1, 2048]
.L241:
	add	x2, x2, 1
	cmp	x2, 4
	bne	.L247
	bl	nandc_wait_flash_ready
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L243:
	str	w8, [x1, 2052]
	str	w0, [x1, 2048]
	b	.L246
.L242:
	cbz	w10, .L241
	add	x1, x6, x2, lsl 8
	cmp	w3, 44
	str	w7, [x1, 2056]
	bne	.L245
	str	w12, [x1, 2052]
	str	w13, [x1, 2048]
	b	.L246
.L245:
	str	w8, [x1, 2052]
	str	wzr, [x1, 2048]
	b	.L246
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
	mov	w0, w10
	bl	nandc_de_cs
	ldrb	w2, [x8]
	sub	w0, w2, #1
	and	w0, w0, 255
	cmp	w0, 253
	bhi	.L257
	ldrb	w7, [x8, 5]
	add	w1, w10, 1
	ldrb	w6, [x8, 4]
	adrp	x0, .LC6
	ldrb	w5, [x8, 3]
	add	x0, x0, :lo12:.LC6
	ldrb	w4, [x8, 2]
	ldrb	w3, [x8, 1]
	ldp	x29, x30, [sp], 16
	b	printf
.L257:
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
	adrp	x2, .LANCHOR26+9
	ubfiz	x0, x0, 8, 8
	add	x29, sp, 0
	ldrb	w3, [x2, #:lo12:.LANCHOR26+9]
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
	stp	x29, x30, [sp, -16]!
	adrp	x2, .LANCHOR13
	and	w0, w0, 255
	add	x29, sp, 0
	ldr	x4, [x2, #:lo12:.LANCHOR13]
	adrp	x2, .LANCHOR26
	add	x3, x2, :lo12:.LANCHOR26
	mov	x5, x2
	sxtw	x2, w0
	add	x2, x2, 8
	ldrb	w3, [x3, 29]
	add	x2, x4, x2, lsl 8
	cbz	w3, .L263
.L270:
	ubfiz	x0, x0, 8, 8
	str	w3, [x2, 8]
	add	x4, x4, x0
	mov	w0, 128
	str	w0, [x4, 2056]
	and	w0, w1, 255
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	str	w0, [x4, 2052]
	lsr	w0, w1, 8
	str	w0, [x4, 2052]
	lsr	w1, w1, 16
	str	w1, [x4, 2052]
	mov	w0, 16
	str	w0, [x4, 2056]
	bl	nandc_wait_flash_ready
	mov	w0, 112
	str	w0, [x4, 2056]
	mov	w0, 80
	bl	timer_delay_ns
	add	x2, x5, :lo12:.LANCHOR26
	ldr	w0, [x4, 2048]
	mov	w1, 5
	and	w0, w0, w1
	ldrb	w1, [x2, 30]
	cbz	w1, .L262
	str	w1, [x4, 2056]
.L262:
	ldp	x29, x30, [sp], 16
	ret
.L263:
	mov	w3, 162
	b	.L270
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
	adrp	x2, .LANCHOR34
	mov	w1, 1
	strb	w0, [x2, #:lo12:.LANCHOR34]
	adrp	x2, .LANCHOR14
	ldrb	w2, [x2, #:lo12:.LANCHOR14]
	cmp	w2, 9
	adrp	x2, .LANCHOR13
	ldr	x2, [x2, #:lo12:.LANCHOR13]
	bne	.L274
	str	w1, [x2, 16]
	cmp	w0, 70
	beq	.L281
	cmp	w0, 60
	beq	.L282
	cmp	w0, 40
	cset	w1, eq
	add	w1, w1, 1
.L275:
	lsl	w1, w1, 25
	orr	w1, w1, 1
	str	w1, [x2, 32]
	ret
.L281:
	mov	w1, 0
	b	.L275
.L282:
	mov	w1, 3
	b	.L275
.L274:
	str	w1, [x2, 8]
	cmp	w0, 16
	mov	w1, 4096
	bne	.L277
.L280:
	and	w1, w1, -17
.L278:
	orr	w1, w1, 1
	str	w1, [x2, 12]
	ret
.L277:
	cmp	w0, 24
	bne	.L279
	orr	w1, w1, 16
	b	.L278
.L279:
	orr	w1, w1, 262144
	cmp	w0, 40
	orr	w1, w1, 16
	bne	.L278
	b	.L280
	.size	nandc_bch_sel, .-nandc_bch_sel
	.section	.text.zftl_nandc_get_irq_status,"ax",@progbits
	.align	2
	.global	zftl_nandc_get_irq_status
	.type	zftl_nandc_get_irq_status, %function
zftl_nandc_get_irq_status:
	adrp	x1, .LANCHOR14
	ldrb	w1, [x1, #:lo12:.LANCHOR14]
	cmp	w1, 9
	bne	.L288
	ldr	w0, [x0, 296]
	ret
.L288:
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
	adrp	x4, .LANCHOR37
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w23, w0, 255
	adrp	x0, .LANCHOR14
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	add	w20, w1, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR14]
	adrp	x24, .LANCHOR13
	cmp	w0, 9
	bne	.L294
	ubfiz	w19, w23, 1, 1
	mov	w0, 1
	orr	w19, w19, 8
	asr	w20, w20, 1
	bfi	w19, w0, 5, 2
	adrp	x0, .LANCHOR35
	orr	w19, w19, 536870912
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	orr	w19, w19, 1024
	and	w19, w19, -17
	bfi	w19, w20, 22, 6
	cbz	w0, .L295
	adrp	x0, .LANCHOR36
	ldrb	w1, [x0, #:lo12:.LANCHOR36]
	orr	w0, w19, 512
	cmp	w1, 0
	csel	w19, w0, w19, ne
.L295:
	add	x21, x4, :lo12:.LANCHOR37
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
	adrp	x2, .LANCHOR38
	orr	w0, w0, 1
	ldrh	w2, [x2, #:lo12:.LANCHOR38]
	bfi	w0, w2, 16, 11
	str	w0, [x1, 48]
	str	w19, [x1, 16]
	orr	w19, w19, 4
	str	w19, [x1, 16]
.L293:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L294:
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
	cbz	w23, .L297
	adrp	x0, .LANCHOR34
	ubfx	x1, x1, 1, 7
	ldr	x8, [x4, #:lo12:.LANCHOR37]
	add	x1, x3, x1, lsl 2
	ldrb	w0, [x0, #:lo12:.LANCHOR34]
	mov	w5, 128
	cmp	w0, 24
	mov	w0, 64
	csel	w5, w5, w0, hi
	mov	w0, 0
.L299:
	add	w7, w5, w0
	cmp	x3, x1
	bne	.L300
.L301:
	add	x21, x4, :lo12:.LANCHOR37
	ldr	x0, [x4, #:lo12:.LANCHOR37]
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
	b	.L293
.L300:
	ldrh	w10, [x3]
	and	x0, x0, 4294967292
	ldrh	w6, [x3, 2]
	add	x3, x3, 4
	orr	x6, x10, x6, lsl 16
	str	w6, [x8, x0]
	mov	w0, w7
	b	.L299
.L297:
	ldr	x1, [x4, #:lo12:.LANCHOR37]
	str	w0, [x1]
	b	.L301
	.size	nandc_xfer_start, .-nandc_xfer_start
	.section	.text.nandc_set_seed,"ax",@progbits
	.align	2
	.global	nandc_set_seed
	.type	nandc_set_seed, %function
nandc_set_seed:
	and	x0, x0, 127
	adrp	x1, .LANCHOR39
	add	x1, x1, :lo12:.LANCHOR39
	ldrh	w0, [x1, x0, lsl 1]
	adrp	x1, .LANCHOR36
	ldrb	w2, [x1, #:lo12:.LANCHOR36]
	orr	w1, w0, -1073741824
	cmp	w2, 0
	csel	w0, w1, w0, ne
	adrp	x1, .LANCHOR14
	ldrb	w1, [x1, #:lo12:.LANCHOR14]
	cmp	w1, 9
	adrp	x1, .LANCHOR13
	ldr	x1, [x1, #:lo12:.LANCHOR13]
	bne	.L311
	str	w0, [x1, 520]
	ret
.L311:
	str	w0, [x1, 336]
	ret
	.size	nandc_set_seed, .-nandc_set_seed
	.section	.text.flash_start_page_read,"ax",@progbits
	.align	2
	.global	flash_start_page_read
	.type	flash_start_page_read, %function
flash_start_page_read:
	stp	x29, x30, [sp, -16]!
	and	w11, w0, 255
	adrp	x0, .LANCHOR15
	ubfx	x2, x1, 21, 3
	add	x29, sp, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cmp	w0, w2
	bhi	.L316
	adrp	x1, .LANCHOR40
	adrp	x0, .LC0
	mov	w2, 759
	add	x1, x1, :lo12:.LANCHOR40
	add	x0, x0, :lo12:.LC0
	bl	printf
.L317:
	b	.L317
.L316:
	adrp	x0, .LANCHOR17
	add	x0, x0, :lo12:.LANCHOR17
	and	w6, w1, 2097151
	ubfx	x10, x1, 24, 2
	ldrb	w8, [x0, w2, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x7, [x0, #:lo12:.LANCHOR13]
	mov	w0, w8
	bl	nandc_cs
	adrp	x12, .LANCHOR41
	cbnz	w10, .L318
	adrp	x0, .LANCHOR18
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	adrp	x0, .LANCHOR19
	cbz	w1, .L319
	ldrb	w1, [x0, #:lo12:.LANCHOR19]
	cbz	w1, .L320
.L319:
	adrp	x1, .LANCHOR20
	ldrb	w0, [x0, #:lo12:.LANCHOR19]
	ldrh	w1, [x1, #:lo12:.LANCHOR20]
	udiv	w2, w6, w1
	mul	w2, w2, w1
	sub	w6, w6, w2
	cbz	w0, .L321
	add	w6, w2, w6, lsl 1
.L320:
	mov	w0, w8
	bl	zftl_flash_enter_slc_mode
	b	.L322
.L321:
	adrp	x3, .LANCHOR21
	add	x3, x3, :lo12:.LANCHOR21
	ldrh	w6, [x3, w6, uxtw 1]
	add	w6, w6, w2
.L322:
	ubfiz	x2, x8, 8, 8
	and	w0, w6, 255
	add	x2, x7, x2
	str	wzr, [x2, 2056]
	str	wzr, [x2, 2052]
	str	wzr, [x2, 2052]
	str	w0, [x2, 2052]
	lsr	w0, w6, 8
	str	w0, [x2, 2052]
	lsr	w0, w6, 16
	str	w0, [x2, 2052]
	ldr	x0, [x12, #:lo12:.LANCHOR41]
	str	w11, [x2, 2056]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L324
	cbz	w10, .L324
	add	w6, w6, w6, lsl 1
	sub	w0, w10, #1
	add	w0, w6, w0
.L333:
	bl	nandc_set_seed
	ldp	x29, x30, [sp], 16
	mov	w0, 0
	b	nandc_de_cs
.L318:
	ldr	x0, [x12, #:lo12:.LANCHOR41]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L323
	sxtw	x0, w8
	add	x0, x0, 8
	add	x0, x7, x0, lsl 8
	str	w10, [x0, 8]
	b	.L322
.L323:
	mov	w0, w8
	bl	zftl_flash_exit_slc_mode
	b	.L322
.L324:
	mov	w0, w6
	b	.L333
	.size	flash_start_page_read, .-flash_start_page_read
	.section	.text.zftl_flash_de_init,"ax",@progbits
	.align	2
	.global	zftl_flash_de_init
	.type	zftl_flash_de_init, %function
zftl_flash_de_init:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	nandc_wait_flash_ready
	mov	w0, 0
	bl	hynix_reconfig_rr_para
	adrp	x15, .LANCHOR42
	ldrb	w0, [x15, #:lo12:.LANCHOR42]
	cbz	w0, .L335
	adrp	x0, .LANCHOR32
	ldrb	w0, [x0, #:lo12:.LANCHOR32]
	tbz	x0, 0, .L335
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
	bl	nandc_set_if_mode
	strb	wzr, [x15, #:lo12:.LANCHOR42]
.L335:
	adrp	x3, .LANCHOR36
	ldrb	w0, [x3, #:lo12:.LANCHOR36]
	cbz	w0, .L336
	mov	w0, 0
	strb	wzr, [x3, #:lo12:.LANCHOR36]
	bl	nandc_set_seed
	mov	w0, 1
	strb	w0, [x3, #:lo12:.LANCHOR36]
.L336:
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	zftl_flash_de_init, .-zftl_flash_de_init
	.section	.text.nandc_randomizer_enable,"ax",@progbits
	.align	2
	.global	nandc_randomizer_enable
	.type	nandc_randomizer_enable, %function
nandc_randomizer_enable:
	adrp	x1, .LANCHOR36
	strb	w0, [x1, #:lo12:.LANCHOR36]
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
	adrp	x0, .LANCHOR43
	add	x1, x0, :lo12:.LANCHOR43
	mov	w2, 0
.L350:
	and	w3, w2, 255
	strb	wzr, [x1, 2]
	add	w4, w3, 1
	strb	w3, [x1, 1]
	strb	w4, [x1]
	add	w2, w2, 1
	str	xzr, [x1, 16]
	cmp	w2, 32
	add	x1, x1, 64
	bne	.L350
	add	x0, x0, :lo12:.LANCHOR43
	mov	w1, -1
	strb	w1, [x0, 1984]
	adrp	x0, .LANCHOR44
	strb	wzr, [x0, #:lo12:.LANCHOR44]
	adrp	x0, .LANCHOR45
	strb	w2, [x0, #:lo12:.LANCHOR45]
	ret
	.size	buf_reinit, .-buf_reinit
	.section	.text.buf_add_tail,"ax",@progbits
	.align	2
	.global	buf_add_tail
	.type	buf_add_tail, %function
buf_add_tail:
	stp	x29, x30, [sp, -16]!
	mov	w2, -1
	add	x29, sp, 0
	strb	w2, [x1]
	ldrb	w3, [x0]
	cmp	w3, 255
	bne	.L360
	ldrb	w1, [x1, 1]
	cmp	w1, 255
	bne	.L354
	adrp	x1, .LANCHOR46
	adrp	x0, .LC0
	mov	w2, 74
	add	x1, x1, :lo12:.LANCHOR46
	add	x0, x0, :lo12:.LC0
	bl	printf
.L355:
	b	.L355
.L354:
	strb	w1, [x0]
.L352:
	ldp	x29, x30, [sp], 16
	ret
.L357:
	sbfiz	x0, x0, 6, 32
	strb	w1, [x2, x0]
	b	.L352
.L360:
	adrp	x2, .LANCHOR43
	add	x2, x2, :lo12:.LANCHOR43
.L361:
	mov	w0, w3
	sbfiz	x3, x3, 6, 32
	ldrb	w3, [x2, x3]
	cmp	w3, 255
	bne	.L361
	ldrb	w1, [x1, 1]
	cmp	w1, 255
	bne	.L357
	adrp	x1, .LANCHOR46
	adrp	x0, .LC0
	mov	w2, 81
	add	x1, x1, :lo12:.LANCHOR46
	add	x0, x0, :lo12:.LC0
	bl	printf
.L358:
	b	.L358
	.size	buf_add_tail, .-buf_add_tail
	.section	.text.buf_free,"ax",@progbits
	.align	2
	.global	buf_free
	.type	buf_free, %function
buf_free:
	ldrb	w1, [x0, 2]
	adrp	x2, .LANCHOR44
	and	w1, w1, 8
	strb	w1, [x0, 2]
	cbz	w1, .L364
	stp	x29, x30, [sp, -16]!
	mov	x1, x0
	add	x0, x2, :lo12:.LANCHOR44
	add	x29, sp, 0
	bl	buf_add_tail
	adrp	x1, .LANCHOR45
	ldp	x29, x30, [sp], 16
	ldrb	w0, [x1, #:lo12:.LANCHOR45]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR45]
	ret
.L364:
	ldrb	w1, [x2, #:lo12:.LANCHOR44]
	strb	w1, [x0]
	adrp	x1, .LANCHOR45
	ldrb	w0, [x0, 1]
	strb	w0, [x2, #:lo12:.LANCHOR44]
	ldrb	w0, [x1, #:lo12:.LANCHOR45]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR45]
	ret
	.size	buf_free, .-buf_free
	.section	.text.buf_alloc,"ax",@progbits
	.align	2
	.global	buf_alloc
	.type	buf_alloc, %function
buf_alloc:
	adrp	x1, .LANCHOR45
	ldrb	w3, [x1, #:lo12:.LANCHOR45]
	cbnz	w3, .L371
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR47
	adrp	x0, .LC0
	mov	w2, 121
	add	x29, sp, 0
	add	x1, x1, :lo12:.LANCHOR47
	add	x0, x0, :lo12:.LC0
	bl	printf
.L372:
	b	.L372
.L371:
	adrp	x6, .LANCHOR44
	and	w7, w0, 255
	mov	x5, x1
	adrp	x1, .LANCHOR43
	ldrb	w2, [x6, #:lo12:.LANCHOR44]
	add	x4, x1, :lo12:.LANCHOR43
	ubfiz	x0, x2, 6, 8
	add	x0, x4, x0
	cbnz	w7, .L373
	cmp	w3, 1
	beq	.L375
.L373:
	add	x1, x1, :lo12:.LANCHOR43
	sbfiz	x2, x2, 6, 32
	add	x4, x1, x2
	sub	w3, w3, #1
	strb	w3, [x5, #:lo12:.LANCHOR45]
	mov	w3, 1
	ldrb	w7, [x1, x2]
	strb	w3, [x4, 2]
	mov	w3, -1
	strb	w7, [x6, #:lo12:.LANCHOR44]
	strb	w3, [x1, x2]
	mov	w1, -1
	strh	wzr, [x4, 50]
	str	xzr, [x4, 16]
	str	w1, [x4, 36]
.L370:
	ret
.L375:
	mov	x0, 0
	b	.L370
	.size	buf_alloc, .-buf_alloc
	.section	.text.buf_remove_buf,"ax",@progbits
	.align	2
	.global	buf_remove_buf
	.type	buf_remove_buf, %function
buf_remove_buf:
	ldrb	w4, [x1, 1]
	ldrb	w2, [x0]
	cmp	w4, w2
	bne	.L382
	ldrb	w1, [x1]
	strb	w1, [x0]
.L386:
	mov	w0, 1
	ret
.L383:
	mov	w3, w2
	sbfiz	x2, x2, 6, 32
	ldrb	w2, [x0, x2]
	cmp	w4, w2
	bne	.L384
	sbfiz	x3, x3, 6, 32
	ldrb	w2, [x1]
	strb	w2, [x0, x3]
	mov	w0, -1
	strb	w0, [x1]
	b	.L386
.L382:
	adrp	x0, .LANCHOR43
	add	x0, x0, :lo12:.LANCHOR43
.L384:
	cmp	w2, 255
	bne	.L383
	mov	w0, 0
	ret
	.size	buf_remove_buf, .-buf_remove_buf
	.section	.text.buf_remove_free,"ax",@progbits
	.align	2
	.global	buf_remove_free
	.type	buf_remove_free, %function
buf_remove_free:
	stp	x29, x30, [sp, -16]!
	adrp	x6, .LANCHOR45
	mov	x5, x0
	add	x29, sp, 0
	ldrb	w0, [x6, #:lo12:.LANCHOR45]
	cbnz	w0, .L388
	adrp	x1, .LANCHOR48
	adrp	x0, .LC0
	mov	w2, 170
	add	x1, x1, :lo12:.LANCHOR48
	add	x0, x0, :lo12:.LC0
	bl	printf
.L389:
	b	.L389
.L388:
	mov	x1, x5
	adrp	x0, .LANCHOR44
	add	x0, x0, :lo12:.LANCHOR44
	bl	buf_remove_buf
	cmp	w0, 1
	bne	.L387
	ldrb	w0, [x6, #:lo12:.LANCHOR45]
	sub	w0, w0, #1
	strb	w0, [x6, #:lo12:.LANCHOR45]
	ldrb	w0, [x5, 2]
	orr	w0, w0, 1
	strb	w0, [x5, 2]
.L387:
	ldp	x29, x30, [sp], 16
	ret
	.size	buf_remove_free, .-buf_remove_free
	.section	.text.flash_check_bad_block,"ax",@progbits
	.align	2
	.global	flash_check_bad_block
	.type	flash_check_bad_block, %function
flash_check_bad_block:
	adrp	x3, .LANCHOR26
	add	x3, x3, :lo12:.LANCHOR26
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
	adrp	x2, .LANCHOR12
	ldr	x2, [x2, #:lo12:.LANCHOR12]
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
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	ldrh	w19, [x0, 14]
	ldrb	w1, [x0, 13]
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
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
	adrp	x0, .LANCHOR12
	ldr	x2, [x0, #:lo12:.LANCHOR12]
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
	adrp	x0, .LANCHOR49
	add	x0, x0, :lo12:.LANCHOR49
	bl	buf_add_tail
	adrp	x1, .LANCHOR50
	ldp	x29, x30, [sp], 16
	ldrb	w0, [x1, #:lo12:.LANCHOR50]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x1, #:lo12:.LANCHOR50]
	ret
	.size	ftl_gc_write_buf, .-ftl_gc_write_buf
	.section	.text.ftl_write_buf,"ax",@progbits
	.align	2
	.global	ftl_write_buf
	.type	ftl_write_buf, %function
ftl_write_buf:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	cbnz	x0, .L398
	adrp	x1, .LANCHOR51
	adrp	x0, .LC0
	mov	w2, 591
	add	x1, x1, :lo12:.LANCHOR51
	add	x0, x0, :lo12:.LC0
	bl	printf
.L399:
	b	.L399
.L398:
	adrp	x2, .LANCHOR52
	ldrb	w1, [x0, 56]
	mov	x19, x0
	ldrb	w2, [x2, #:lo12:.LANCHOR52]
	cmp	w2, w1
	bcs	.L400
	adrp	x1, .LANCHOR51
	adrp	x0, .LC0
	mov	w2, 596
	add	x1, x1, :lo12:.LANCHOR51
	add	x0, x0, :lo12:.LC0
	bl	printf
.L401:
	b	.L401
.L400:
	adrp	x20, .LANCHOR50
	cbnz	w1, .L402
	bl	buf_free
	ldrb	w0, [x20, #:lo12:.LANCHOR50]
.L397:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L402:
	mov	x1, x0
	adrp	x0, .LANCHOR49
	add	x0, x0, :lo12:.LANCHOR49
	bl	buf_add_tail
	adrp	x1, .LANCHOR53
	ldrb	w3, [x19, 56]
	ldrb	w0, [x20, #:lo12:.LANCHOR50]
	ldr	x1, [x1, #:lo12:.LANCHOR53]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x20, #:lo12:.LANCHOR50]
	ldr	w2, [x1, 16]
	add	w2, w2, w3
	str	w2, [x1, 16]
	ldr	w2, [x1, 32]
	add	w2, w2, 1
	str	w2, [x1, 32]
	b	.L397
	.size	ftl_write_buf, .-ftl_write_buf
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
	stp	x29, x30, [sp, -32]!
	adrp	x2, .LANCHOR54
	add	x29, sp, 0
	str	x19, [sp, 16]
	ldr	w2, [x2, #:lo12:.LANCHOR54]
	cmp	w2, w0
	bhi	.L407
	adrp	x1, .LANCHOR55
	adrp	x0, .LC0
	mov	w2, 834
	add	x1, x1, :lo12:.LANCHOR55
	add	x0, x0, :lo12:.LC0
	bl	printf
.L408:
	b	.L408
.L407:
	adrp	x19, .LANCHOR43
	add	x3, x19, :lo12:.LANCHOR43
	add	x3, x3, 2
	mov	w2, 0
.L411:
	ldr	w4, [x3, 34]
	cmp	w0, w4
	bne	.L409
	ldrb	w4, [x3]
	tbz	x4, 3, .L409
	add	x19, x19, :lo12:.LANCHOR43
	ubfiz	x2, x2, 6, 32
	add	x19, x19, x2
	orr	w0, w4, 4
	strb	w0, [x19, 2]
	tbnz	x4, 0, .L406
	mov	x0, x19
	bl	buf_remove_free
.L406:
	mov	x0, x19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L409:
	add	w2, w2, 1
	add	x3, x3, 64
	cmp	w2, 32
	bne	.L411
	adrp	x2, .LANCHOR56
	ldr	w3, [x2, #:lo12:.LANCHOR56]
	cmn	w3, #1
	bne	.L412
	str	w0, [x2, #:lo12:.LANCHOR56]
	adrp	x0, .LANCHOR57
	str	x1, [x0, #:lo12:.LANCHOR57]
.L412:
	mov	x19, 0
	b	.L406
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
	tbz	x0, 1, .L419
	and	w0, w0, -5
	strb	w0, [x5, 2]
	ldp	x29, x30, [sp], 16
	ret
.L419:
	ldp	x29, x30, [sp], 16
	mov	x0, x5
	b	buf_free
	.size	ftl_read_buf_free, .-ftl_read_buf_free
	.section	.text.zftl_get_density,"ax",@progbits
	.align	2
	.global	zftl_get_density
	.type	zftl_get_density, %function
zftl_get_density:
	cbnz	w0, .L424
	adrp	x0, .LANCHOR59
	ldr	w0, [x0, #:lo12:.LANCHOR59]
	ret
.L424:
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
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	cmp	w0, w20
	bhi	.L432
	adrp	x1, .LANCHOR61
	adrp	x0, .LC0
	mov	w2, 252
	add	x1, x1, :lo12:.LANCHOR61
	add	x0, x0, :lo12:.LC0
	bl	printf
.L433:
	b	.L433
.L432:
	adrp	x24, .LANCHOR4
	uxtw	x19, w20
	lsl	x26, x19, 1
	adrp	x25, .LANCHOR29
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	and	w23, w1, 65535
	and	w22, w2, 65535
	adrp	x27, .LANCHOR3
	ldrh	w21, [x0, x26]
	ldr	w0, [x25, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L434
	ldr	x0, [x27, #:lo12:.LANCHOR3]
	mov	w4, w21
	mov	w2, w23
	mov	w1, w20
	add	x0, x0, x19, lsl 2
	ldrb	w3, [x0, 2]
	adrp	x0, .LANCHOR62
	ldrh	w6, [x0, #:lo12:.LANCHOR62]
	adrp	x0, .LANCHOR63+56
	ubfx	x3, x3, 5, 3
	ldrh	w5, [x0, #:lo12:.LANCHOR63+56]
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
.L434:
	ldr	x0, [x27, #:lo12:.LANCHOR3]
	add	x19, x0, x19, lsl 2
	ldrb	w3, [x19, 2]
	tst	w3, 224
	bne	.L435
	cbz	w21, .L450
	adrp	x1, .LANCHOR61
	adrp	x0, .LC0
	mov	w2, 257
	add	x1, x1, :lo12:.LANCHOR61
	add	x0, x0, :lo12:.LC0
	bl	printf
.L437:
	b	.L437
.L435:
	adrp	x1, .LANCHOR63
	add	x0, x1, :lo12:.LANCHOR63
	ldrh	w1, [x1, #:lo12:.LANCHOR63]
	cmp	w1, w20
	beq	.L450
	adrp	x21, .LANCHOR5
	ldr	x1, [x21, #:lo12:.LANCHOR5]
	ldrh	w2, [x1, 48]
	cmp	w2, w20
	beq	.L450
	ldrh	w2, [x1, 16]
	cmp	w2, w20
	beq	.L450
	ldrh	w2, [x1, 80]
	cmp	w2, w20
	beq	.L450
	ldrh	w5, [x0, 56]
	add	x0, x0, 58
	mov	w2, 0
.L438:
	cmp	w2, w5
	bcc	.L439
	ubfiz	x19, x22, 7, 16
	add	x0, x1, 392
	add	x19, x19, 136
	cmp	w23, 0
	add	x1, x1, x19
	csel	x19, x1, x0, eq
	ldr	w0, [x25, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L441
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	adrp	x1, .LANCHOR62
	ubfx	x3, x3, 5, 3
	mov	w2, w23
	ldrh	w6, [x1, #:lo12:.LANCHOR62]
	mov	w1, w20
	ldrh	w4, [x0, x26]
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
.L441:
	mov	x0, x19
	add	x1, x19, 128
	mov	w2, 65535
.L444:
	ldrh	w3, [x0]
	cmp	w3, w2
	bne	.L442
	strh	w20, [x0]
	cbz	w23, .L443
	ldr	x1, [x21, #:lo12:.LANCHOR5]
	ldrh	w0, [x1, 124]
	add	w0, w0, 1
	strh	w0, [x1, 124]
.L461:
	mov	w0, 1
.L431:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L439:
	ldrh	w4, [x0], 2
	cmp	w4, w20
	beq	.L450
	add	w2, w2, 1
	b	.L438
.L443:
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	add	x22, x0, x22, uxth 1
	ldrh	w0, [x22, 120]
	add	w0, w0, 1
	strh	w0, [x22, 120]
	b	.L461
.L442:
	add	x0, x0, 2
	cmp	x0, x1
	bne	.L444
	b	.L461
.L450:
	mov	w0, 0
	b	.L431
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
	adrp	x23, .LANCHOR43
	stp	x21, x22, [sp, 32]
	add	x24, x23, :lo12:.LANCHOR43
	adrp	x22, .LANCHOR65
	add	x22, x22, :lo12:.LANCHOR65
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
.L464:
	ldrb	w19, [x22]
	cmp	w19, 255
	bne	.L477
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L477:
	lsl	x1, x19, 6
	add	x0, x23, :lo12:.LANCHOR43
	add	x2, x0, x1
	ldrb	w0, [x0, x1]
	ldr	w1, [x2, 52]
	strb	w0, [x22]
	ldrh	w26, [x2, 48]
	cbz	w1, .L465
	ldr	w2, [x2, 40]
	adrp	x0, .LANCHOR63
	add	x0, x0, :lo12:.LANCHOR63
	mov	w3, 1
	str	w2, [x0, 320]
	strh	w3, [x0, 318]
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
	adrp	x1, .LANCHOR66
	adrp	x0, .LC0
	mov	w2, 519
	add	x1, x1, :lo12:.LANCHOR66
	add	x0, x0, :lo12:.LC0
	bl	printf
.L466:
	b	.L466
.L465:
	adrp	x0, .LANCHOR67
	mov	x28, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR67]
	cmp	w1, 3
	bne	.L478
	adrp	x0, .LANCHOR5
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldrb	w20, [x0, 89]
	add	w20, w20, w20, lsl 1
	and	w20, w20, 1023
.L467:
	adrp	x0, .LANCHOR29
	adrp	x27, .LANCHOR68
	and	x21, x26, 65535
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L468
	ldr	x1, [x27, #:lo12:.LANCHOR68]
	add	x0, x24, x19, lsl 6
	mov	w3, w26
	ldrb	w2, [x0, 1]
	adrp	x0, .LC10
	ldrb	w4, [x1, x21]
	add	x0, x0, :lo12:.LC10
	mov	w1, w26
	bl	printf
.L468:
	ldr	x0, [x27, #:lo12:.LANCHOR68]
	add	x19, x24, x19, lsl 6
	mov	x25, x21
	add	x2, x0, x21
	ldrb	w1, [x0, x21]
	ldrb	w0, [x19, 1]
	cmp	w1, w0
	beq	.L469
	adrp	x1, .LANCHOR66
	adrp	x0, .LC0
	mov	w2, 526
	add	x1, x1, :lo12:.LANCHOR66
	add	x0, x0, :lo12:.LC0
	bl	printf
.L470:
	b	.L470
.L478:
	mov	w20, 1
	b	.L467
.L469:
	ldrb	w0, [x19, 61]
	cmp	w0, 3
	beq	.L471
	ldrb	w0, [x28, #:lo12:.LANCHOR67]
	cmp	w0, 3
	bne	.L471
	adrp	x0, .LANCHOR69
	ldrb	w0, [x0, #:lo12:.LANCHOR69]
	cbnz	w0, .L471
	mov	x0, 0
.L472:
	cmp	w20, w0, uxth
	bls	.L464
	ldrb	w1, [x2, x0]
	add	x0, x0, 1
	add	x1, x24, x1, lsl 6
	strb	wzr, [x1, 61]
	b	.L472
.L471:
	adrp	x19, .LANCHOR63
	add	x19, x19, :lo12:.LANCHOR63
	add	x20, x21, x20, uxth
	mov	w21, -1
	strh	w26, [x19, 316]
.L473:
	cmp	x25, x20
	beq	.L464
	ldr	x1, [x27, #:lo12:.LANCHOR68]
	ldrb	w0, [x1, x25]
	strb	w21, [x1, x25]
	add	x25, x25, 1
	sbfiz	x1, x0, 6, 32
	ubfiz	x0, x0, 6, 8
	add	x1, x24, x1
	add	x0, x24, x0
	strb	wzr, [x1, 61]
	bl	buf_free
	ldrb	w0, [x19, 7]
	sub	w0, w0, #1
	strb	w0, [x19, 7]
	b	.L473
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
	cbz	w0, .L487
	add	x1, x2, 392
	mov	w4, 1
.L488:
	add	x5, x1, 128
	mov	w6, 65535
.L492:
	ldrh	w0, [x1]
	cmp	w0, w6
	beq	.L490
	mov	w5, -1
	strh	w5, [x1]
	cbz	w4, .L491
	ldrh	w1, [x2, 124]
	sub	w1, w1, #1
	strh	w1, [x2, 124]
	ret
.L487:
	add	x0, x2, x3, sxtw 1
	ldrh	w0, [x0, 120]
	cbz	w0, .L493
	ubfiz	x1, x3, 7, 8
	mov	w4, 0
	add	x1, x1, 136
	add	x1, x2, x1
	b	.L488
.L491:
	add	x2, x2, x3, uxtb 1
	ldrh	w1, [x2, 120]
	sub	w1, w1, #1
	strh	w1, [x2, 120]
	ret
.L490:
	add	x1, x1, 2
	cmp	x1, x5
	bne	.L492
	ret
.L493:
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
	cbz	w1, .L502
	adrp	x1, .LANCHOR45
	ldrb	w1, [x1, #:lo12:.LANCHOR45]
	cmp	w1, 1
	bhi	.L502
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
	adrp	x0, .LANCHOR43
	add	x0, x0, :lo12:.LANCHOR43
.L497:
	cmp	w19, w1
	bcc	.L500
.L502:
	mov	w0, 0
	b	.L495
.L500:
	uxtw	x22, w19
	ldrb	w2, [x4, x22]
	cmp	w2, 255
	beq	.L498
	sbfiz	x3, x2, 6, 32
	add	x3, x0, x3
	ldrb	w3, [x3, 61]
	cbnz	w3, .L498
	ubfiz	x2, x2, 6, 8
	add	x0, x0, x2
	bl	buf_free
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L499
	ldr	x0, [x21, #:lo12:.LANCHOR68]
	mov	w1, w19
	ldrb	w2, [x0, x22]
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	printf
.L499:
	ldr	x0, [x21, #:lo12:.LANCHOR68]
	add	x20, x20, :lo12:.LANCHOR63
	mov	w1, -1
	strb	w1, [x0, x22]
	ldrb	w0, [x20, 7]
	sub	w0, w0, #1
	strb	w0, [x20, 7]
	mov	w0, 1
.L495:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L498:
	add	w19, w19, 1
	b	.L497
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
	adrp	x2, .LANCHOR45
	ldrh	w1, [x1, #:lo12:.LANCHOR63]
	ldrb	w5, [x0, 7]
	ldrb	w4, [x2, #:lo12:.LANCHOR45]
	ldrh	w3, [x0, 314]
	ldrh	w2, [x0, 2]
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
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
	bne	.L512
	mov	w1, w0
	adrp	x0, .LANCHOR74
	ldr	x0, [x0, #:lo12:.LANCHOR74]
.L514:
	b	_list_get_gc_head_node.isra.2
.L512:
	cmp	w1, 2
	mov	w1, w0
	bne	.L513
	adrp	x0, .LANCHOR75
	ldr	x0, [x0, #:lo12:.LANCHOR75]
	b	.L514
.L513:
	adrp	x0, .LANCHOR76
	ldr	x0, [x0, #:lo12:.LANCHOR76]
	b	.L514
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
	cbz	w19, .L516
	mov	w0, w19
.L515:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L516:
	and	w20, w2, 255
	cbnz	w21, .L518
	adrp	x24, .LANCHOR77
	adrp	x26, .LANCHOR29
	adrp	x27, .LC13
	and	w23, w20, 65535
	add	x26, x26, :lo12:.LANCHOR29
	add	x27, x27, :lo12:.LC13
	strh	wzr, [x24, #:lo12:.LANCHOR77]
	mov	w22, 0
	mov	w25, 0
.L519:
	cmp	w25, w23
	bcs	.L524
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
	beq	.L520
	ldr	w0, [x26]
	adrp	x6, .LANCHOR4
	uxtw	x4, w1
	tbz	x0, 8, .L521
	ldr	x0, [x6, #:lo12:.LANCHOR4]
	stp	x6, x4, [x29, 96]
	ldrh	w3, [x0, x4, lsl 1]
	mov	x0, x27
	bl	printf
	ldp	x6, x4, [x29, 96]
.L521:
	ldr	x0, [x6, #:lo12:.LANCHOR4]
	ldrh	w1, [x0, x4, lsl 1]
	adrp	x0, .LANCHOR62
	ldrh	w0, [x0, #:lo12:.LANCHOR62]
	cmp	w1, w0
	bcs	.L522
	mov	w2, 0
	mov	w1, 0
	mov	w0, w28
	bl	gc_add_sblk
	cbz	w0, .L523
	add	w5, w22, 1
	and	w22, w5, 65535
	cmp	w23, w22
	bcs	.L523
.L524:
	ldr	x0, [x29, 112]
	tbz	x0, 1, .L526
	adrp	x25, .LANCHOR79
	adrp	x28, .LANCHOR78
	add	x27, x25, :lo12:.LANCHOR79
	add	x28, x28, :lo12:.LANCHOR78
	mov	w26, 65535
.L527:
	cmp	w19, w23
	beq	.L531
	ldrh	w6, [x28]
	mov	w1, 5
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x28]
	and	w1, w0, 65535
	cmp	w1, w26
	beq	.L528
	adrp	x2, .LANCHOR4
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR4]
	ldrh	w2, [x2, x1]
	ldrh	w1, [x27]
	cmp	w2, w1
	bcs	.L529
	mov	w2, 0
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L530
	add	w5, w22, 1
	and	w22, w5, 65535
	cmp	w23, w22
	bcs	.L530
.L531:
	ldrh	w1, [x25, #:lo12:.LANCHOR79]
	cmp	w22, w23
	adrp	x0, .LANCHOR80
	bcs	.L533
	ldrh	w3, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR72
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	lsr	w2, w3, 3
	mul	w0, w0, w3
	sub	w0, w0, w2
	cmp	w1, w0
	bge	.L526
	add	w1, w1, w2
	strh	w1, [x25, #:lo12:.LANCHOR79]
.L526:
	ldr	x0, [x29, 112]
	tbz	x0, 0, .L534
	cmp	w22, w23
	bcs	.L534
	adrp	x25, .LANCHOR81
	add	x25, x25, :lo12:.LANCHOR81
	mov	w24, 64
	adrp	x26, .LANCHOR75
	mov	w27, 65535
.L539:
	ldrh	w6, [x25]
	ldr	x0, [x26, #:lo12:.LANCHOR75]
	mov	w1, w6
	bl	_list_get_gc_head_node.isra.2
	add	w6, w6, 1
	strh	w6, [x25]
	cmp	w27, w0, uxth
	beq	.L535
	mov	w2, 0
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L536
	add	w5, w22, 1
	and	w22, w5, 65535
	cmp	w23, w22
	bhi	.L536
.L537:
	adrp	x1, .LANCHOR62
	adrp	x2, .LANCHOR80
	ldrh	w0, [x1, #:lo12:.LANCHOR62]
	ldrh	w2, [x2, #:lo12:.LANCHOR80]
	cmp	w0, w2, lsr 1
	bls	.L534
	sub	w0, w0, #8
	b	.L613
.L522:
	strh	wzr, [x24, #:lo12:.LANCHOR77]
	b	.L524
.L520:
	strh	wzr, [x7]
	b	.L524
.L523:
	add	w25, w25, 1
	and	w25, w25, 65535
	b	.L519
.L529:
	strh	wzr, [x28]
	b	.L531
.L528:
	strh	wzr, [x24, #:lo12:.LANCHOR77]
	b	.L531
.L530:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L527
.L533:
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w1, w0
	bls	.L526
	sub	w0, w1, w0, lsr 3
	strh	w0, [x25, #:lo12:.LANCHOR79]
	b	.L526
.L535:
	strh	wzr, [x25]
.L538:
	cmp	w22, w23
	bcs	.L537
	adrp	x1, .LANCHOR62
	adrp	x2, .LANCHOR80
	ldrh	w0, [x1, #:lo12:.LANCHOR62]
	ldrh	w2, [x2, #:lo12:.LANCHOR80]
	cmp	w2, w0
	bls	.L534
	add	w0, w0, 8
.L613:
	strh	w0, [x1, #:lo12:.LANCHOR62]
.L534:
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L561
	ldr	w2, [x29, 112]
	adrp	x0, .LC14
	mov	w4, w20
	mov	w3, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC14
	bl	printf
.L561:
	mov	w0, w22
	b	.L515
.L536:
	sub	w24, w24, #1
	ands	w24, w24, 65535
	bne	.L539
	b	.L538
.L518:
	ldr	w0, [x29, 112]
	adrp	x3, .LANCHOR81
	and	w0, w0, 1
	str	w0, [x29, 104]
	ldr	x0, [x29, 112]
	strh	wzr, [x3, #:lo12:.LANCHOR81]
	tbz	x0, 0, .L563
	adrp	x23, .LANCHOR82
	adrp	x24, .LANCHOR83
	ldrh	w0, [x23, #:lo12:.LANCHOR82]
	ldrh	w1, [x24, #:lo12:.LANCHOR83]
	cmp	w0, w1, lsr 1
	bcc	.L564
	adrp	x1, .LANCHOR84
	mov	w22, 0
	ldrh	w1, [x1, #:lo12:.LANCHOR84]
	cmp	w1, w0
	bls	.L542
.L611:
	add	x26, x3, :lo12:.LANCHOR81
	and	w28, w20, 65535
	mov	w25, 64
	mov	w27, 65535
.L545:
	adrp	x0, .LANCHOR75
	ldrh	w6, [x26]
	ldr	x0, [x0, #:lo12:.LANCHOR75]
	mov	w1, w6
	bl	_list_get_gc_head_node.isra.2
	add	w6, w6, 1
	strh	w6, [x26]
	cmp	w27, w0, uxth
	beq	.L543
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L544
	add	w5, w22, 1
	and	w22, w5, 65535
	cmp	w22, w28
	bcc	.L544
.L542:
	ldrh	w1, [x24, #:lo12:.LANCHOR83]
	ldrh	w0, [x23, #:lo12:.LANCHOR82]
	cmp	w0, w1, lsr 1
	bls	.L540
	adrp	x24, .LANCHOR77
	and	w27, w20, 65535
	mov	w23, 64
	mov	w26, 65535
	strh	wzr, [x24, #:lo12:.LANCHOR77]
	add	x24, x24, :lo12:.LANCHOR77
.L547:
	ldrh	w6, [x24]
	mov	w1, 3
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x24]
	cmp	w26, w0, uxth
	beq	.L540
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L546
	add	w5, w22, 1
	and	w22, w5, 65535
	cmp	w22, w27
	bcs	.L540
.L546:
	sub	w23, w23, #1
	ands	w23, w23, 65535
	bne	.L547
.L540:
	ldr	x0, [x29, 112]
	tbz	x0, 1, .L548
	adrp	x28, .LANCHOR78
	adrp	x24, .LANCHOR85
	add	x27, x24, :lo12:.LANCHOR85
	mov	w23, 64
	strh	wzr, [x28, #:lo12:.LANCHOR78]
	add	x28, x28, :lo12:.LANCHOR78
	mov	w25, 65535
	adrp	x26, .LANCHOR4
.L553:
	ldrh	w6, [x28]
	mov	w1, 5
	mov	w0, w6
	bl	zftl_get_gc_node
	add	w6, w6, 1
	strh	w6, [x28]
	and	w1, w0, 65535
	cmp	w1, w25
	beq	.L549
	ldr	x2, [x26, #:lo12:.LANCHOR4]
	ubfiz	x1, x1, 1, 16
	ldrh	w2, [x2, x1]
	ldrh	w1, [x27]
	cmp	w2, w1
	bcs	.L550
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L551
	add	w5, w22, 1
	add	w19, w19, 1
	and	w22, w5, 65535
	and	w19, w19, 65535
	cmp	w22, w20
	bcc	.L551
.L552:
	cmp	w22, w20
	adrp	x4, .LANCHOR80
	adrp	x2, .LANCHOR72
	bcc	.L554
	cbnz	w19, .L555
	adrp	x0, .LANCHOR86
	ldrh	w1, [x0, #:lo12:.LANCHOR86]
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w1, w0
	bls	.L555
.L554:
	adrp	x1, .LANCHOR71
	ldrb	w2, [x2, #:lo12:.LANCHOR72]
	ldrh	w0, [x24, #:lo12:.LANCHOR85]
	ldrh	w1, [x1, #:lo12:.LANCHOR71]
	mul	w2, w1, w2
	ldrh	w1, [x4, #:lo12:.LANCHOR80]
	sub	w1, w2, w1, lsr 3
	cmp	w0, w1
	bge	.L548
	add	w0, w0, 4
.L612:
	strh	w0, [x24, #:lo12:.LANCHOR85]
.L548:
	ldr	w0, [x29, 104]
	cbz	w0, .L534
	adrp	x25, .LANCHOR78
	adrp	x23, .LANCHOR88
	add	x28, x23, :lo12:.LANCHOR88
	mov	w24, 64
	strh	wzr, [x25, #:lo12:.LANCHOR78]
	add	x25, x25, :lo12:.LANCHOR78
	mov	w26, 65535
	adrp	x27, .LANCHOR4
.L559:
	ldrh	w0, [x25]
	mov	w1, 3
	bl	zftl_get_gc_node
	and	w1, w0, 65535
	cmp	w1, w26
	beq	.L556
	ldr	x2, [x27, #:lo12:.LANCHOR4]
	ubfiz	x1, x1, 1, 16
	ldrh	w1, [x2, x1]
	ldrh	w2, [x28]
	cmp	w2, w1
	bls	.L557
	cmp	w1, 2
	bhi	.L558
.L557:
	mov	w2, w21
	mov	w1, 0
	bl	gc_add_sblk
	cbz	w0, .L558
	add	w5, w22, 1
	and	w22, w5, 65535
	cmp	w22, w20
	bcs	.L556
.L558:
	sub	w24, w24, #1
	ands	w24, w24, 65535
	bne	.L559
.L556:
	cmp	w22, w20
	adrp	x2, .LANCHOR80
	bcs	.L560
	ldrh	w0, [x23, #:lo12:.LANCHOR88]
	ldrh	w1, [x2, #:lo12:.LANCHOR80]
	cmp	w0, w1, lsr 1
	bls	.L534
	sub	w0, w0, #4
	strh	w0, [x23, #:lo12:.LANCHOR88]
	b	.L534
.L564:
	mov	w22, 0
	b	.L611
.L543:
	strh	wzr, [x26]
	b	.L542
.L544:
	sub	w4, w25, #1
	ands	w25, w4, 65535
	bne	.L545
	b	.L542
.L563:
	mov	w22, 0
	b	.L540
.L550:
	strh	wzr, [x28]
	b	.L552
.L549:
	adrp	x0, .LANCHOR77
	strh	wzr, [x0, #:lo12:.LANCHOR77]
	b	.L552
.L551:
	sub	w23, w23, #1
	ands	w23, w23, 65535
	bne	.L553
	b	.L552
.L555:
	ldrh	w1, [x4, #:lo12:.LANCHOR80]
	ldrb	w2, [x2, #:lo12:.LANCHOR72]
	ldrh	w0, [x24, #:lo12:.LANCHOR85]
	mul	w1, w1, w2
	cmp	w0, w1
	ble	.L548
	sub	w0, w0, #4
	b	.L612
.L560:
	ldrh	w0, [x2, #:lo12:.LANCHOR80]
	adrp	x2, .LANCHOR72
	ldrh	w1, [x23, #:lo12:.LANCHOR88]
	ldrb	w2, [x2, #:lo12:.LANCHOR72]
	mul	w0, w0, w2
	sub	w0, w0, #32
	cmp	w1, w0
	bge	.L534
	add	w1, w1, 4
	strh	w1, [x23, #:lo12:.LANCHOR88]
	b	.L534
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
	bne	.L615
	adrp	x2, .LANCHOR89
	adrp	x0, .LANCHOR90
	add	x2, x2, :lo12:.LANCHOR89
	add	x0, x0, :lo12:.LANCHOR90
.L617:
	b	_insert_free_list
.L615:
	cmp	w0, 16
	bne	.L616
	adrp	x2, .LANCHOR91
	adrp	x0, .LANCHOR92
	add	x2, x2, :lo12:.LANCHOR91
	add	x0, x0, :lo12:.LANCHOR92
	b	.L617
.L616:
	adrp	x2, .LANCHOR93
	adrp	x0, .LANCHOR94
	add	x2, x2, :lo12:.LANCHOR93
	add	x0, x0, :lo12:.LANCHOR94
	b	.L617
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
	bne	.L619
	adrp	x2, .LANCHOR84
	adrp	x0, .LANCHOR75
	add	x2, x2, :lo12:.LANCHOR84
	add	x0, x0, :lo12:.LANCHOR75
.L622:
	b	_insert_data_list
.L619:
	cmp	w2, 96
	bne	.L620
	adrp	x2, .LANCHOR82
	adrp	x0, .LANCHOR76
	add	x2, x2, :lo12:.LANCHOR82
	add	x0, x0, :lo12:.LANCHOR76
	b	.L622
.L620:
	cmp	w2, 160
	bne	.L618
	adrp	x2, .LANCHOR86
	adrp	x0, .LANCHOR74
	add	x2, x2, :lo12:.LANCHOR86
	add	x0, x0, :lo12:.LANCHOR74
	b	.L622
.L618:
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
	bne	.L624
	adrp	x1, .LANCHOR91
	add	x2, x1, :lo12:.LANCHOR91
	ldrh	w3, [x1, #:lo12:.LANCHOR91]
	ldrh	w1, [x20, #:lo12:.LANCHOR93]
	cmp	w3, w1
	bls	.L625
	mov	w1, w0
	adrp	x0, .LANCHOR92
	add	x0, x0, :lo12:.LANCHOR92
.L629:
	bl	_list_pop_index_node
	and	w19, w0, 65535
	mov	w0, 65535
	cmp	w19, w0
	bne	.L627
	adrp	x0, .LANCHOR89
	ldrh	w5, [x20, #:lo12:.LANCHOR93]
	mov	w2, w21
	mov	w1, w19
	ldrh	w4, [x0, #:lo12:.LANCHOR89]
	adrp	x0, .LANCHOR90
	ldr	x3, [x0, #:lo12:.LANCHOR90]
	adrp	x0, .LC15
	add	x0, x0, :lo12:.LC15
	bl	printf
.L627:
	mov	w0, w19
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L625:
	mov	w1, w0
	add	x2, x20, :lo12:.LANCHOR93
	adrp	x0, .LANCHOR94
	add	x0, x0, :lo12:.LANCHOR94
	b	.L629
.L624:
	adrp	x1, .LANCHOR89
	add	x2, x1, :lo12:.LANCHOR89
	ldrh	w3, [x1, #:lo12:.LANCHOR89]
	ldrh	w1, [x20, #:lo12:.LANCHOR93]
	cmp	w3, w1
	bls	.L625
	mov	w1, w0
	adrp	x0, .LANCHOR90
	add	x0, x0, :lo12:.LANCHOR90
	b	.L629
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
	bne	.L631
	adrp	x2, .LANCHOR84
	adrp	x0, .LANCHOR75
	add	x2, x2, :lo12:.LANCHOR84
	add	x0, x0, :lo12:.LANCHOR75
.L634:
	b	_list_remove_node
.L631:
	cmp	w2, 96
	bne	.L632
	adrp	x2, .LANCHOR82
	adrp	x0, .LANCHOR76
	add	x2, x2, :lo12:.LANCHOR82
	add	x0, x0, :lo12:.LANCHOR76
	b	.L634
.L632:
	cmp	w2, 160
	bne	.L630
	adrp	x2, .LANCHOR86
	adrp	x0, .LANCHOR74
	add	x2, x2, :lo12:.LANCHOR86
	add	x0, x0, :lo12:.LANCHOR74
	b	.L634
.L630:
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
	bne	.L636
	adrp	x2, .LANCHOR89
	adrp	x0, .LANCHOR90
	add	x2, x2, :lo12:.LANCHOR89
	add	x0, x0, :lo12:.LANCHOR90
.L638:
	b	_list_remove_node
.L636:
	cmp	w0, 16
	bne	.L637
	adrp	x2, .LANCHOR91
	adrp	x0, .LANCHOR92
	add	x2, x2, :lo12:.LANCHOR91
	add	x0, x0, :lo12:.LANCHOR92
	b	.L638
.L637:
	adrp	x2, .LANCHOR93
	adrp	x0, .LANCHOR94
	add	x2, x2, :lo12:.LANCHOR93
	add	x0, x0, :lo12:.LANCHOR94
	b	.L638
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
	bne	.L640
	adrp	x2, .LANCHOR84
	adrp	x0, .LANCHOR75
	add	x2, x2, :lo12:.LANCHOR84
	add	x0, x0, :lo12:.LANCHOR75
.L643:
	b	_list_update_data_list
.L640:
	cmp	w2, 96
	bne	.L641
	adrp	x2, .LANCHOR82
	adrp	x0, .LANCHOR76
	add	x2, x2, :lo12:.LANCHOR82
	add	x0, x0, :lo12:.LANCHOR76
	b	.L643
.L641:
	cmp	w2, 160
	bne	.L639
	adrp	x2, .LANCHOR86
	adrp	x0, .LANCHOR74
	add	x2, x2, :lo12:.LANCHOR86
	add	x0, x0, :lo12:.LANCHOR74
	b	.L643
.L639:
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
	adrp	x0, .LC16
	stp	x23, x24, [sp, 80]
	add	x0, x0, :lo12:.LC16
	str	x25, [sp, 96]
	bl	printf
	ldr	x19, [x19]
	cbz	x19, .L644
	mov	x23, -6148914691236517206
	adrp	x21, .LC17
	add	x21, x21, :lo12:.LC17
	mov	w20, 0
	adrp	x22, .LANCHOR0
	movk	x23, 0xaaab, lsl 0
	adrp	x24, .LANCHOR3
	adrp	x25, .LANCHOR4
.L651:
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
	beq	.L644
	ldr	x0, [x22, #:lo12:.LANCHOR0]
	mov	w1, 6
	add	w20, w20, 1
	cmp	w20, 33
	umaddl	x19, w19, w1, x0
	bne	.L651
.L644:
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
	adrp	x6, .LANCHOR96
	add	x6, x6, :lo12:.LANCHOR96
	ldr	x2, [x2, #:lo12:.LANCHOR3]
	mov	w3, 0
	mov	w12, 21
	add	x2, x2, x0, uxth 2
	ldrb	w11, [x2, 3]
	adrp	x2, .LANCHOR72
	ldrb	w8, [x2, #:lo12:.LANCHOR72]
	adrp	x2, .LANCHOR95
	ldrb	w5, [x2, #:lo12:.LANCHOR95]
	mul	w0, w0, w5
	and	w4, w0, 65535
	mov	w0, 0
.L656:
	cmp	w3, w8
	blt	.L660
	sxtw	x2, w0
	mov	w3, -1
.L661:
	cmp	w8, w2
	bgt	.L662
	ret
.L660:
	asr	w2, w11, w3
	tbnz	x2, 0, .L657
	sdiv	w2, w3, w5
	ldrh	w7, [x6]
	sbfiz	x10, x0, 1, 32
	cmp	w5, 1
	sub	w7, w12, w7
	lsl	w2, w2, w7
	add	w2, w4, w2
	and	w2, w2, 65535
	bhi	.L658
.L663:
	add	w0, w0, 1
	strh	w2, [x1, x10]
.L657:
	add	w3, w3, 1
	b	.L656
.L658:
	and	w7, w3, 1
	add	w2, w2, w7
	b	.L663
.L662:
	strh	w3, [x1, x2, lsl 1]
	add	x2, x2, 1
	b	.L661
	.size	ftl_get_blk_list_in_sblk, .-ftl_get_blk_list_in_sblk
	.section	.text.ftl_free_sblk,"ax",@progbits
	.align	2
	.global	ftl_free_sblk
	.type	ftl_free_sblk, %function
ftl_free_sblk:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	and	x19, x0, 65535
	mov	w0, w19
	bl	zftl_remove_data_node
	mov	w0, w19
	bl	zftl_insert_free_list
	adrp	x0, .LANCHOR3
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x0, x0, x19, lsl 2
	ldrb	w1, [x0, 2]
	and	w1, w1, 31
	strb	w1, [x0, 2]
	adrp	x0, .LANCHOR4
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	strh	wzr, [x0, x19, lsl 1]
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
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
	adrp	x22, .LC18
	adrp	x23, .LANCHOR4
	add	x21, x21, :lo12:.LANCHOR63
	mov	x24, x23
	add	x22, x22, :lo12:.LC18
	stp	x19, x20, [sp, 16]
	mov	w20, 0
	stp	x25, x26, [sp, 64]
.L667:
	ldrh	w0, [x21, 56]
	cmp	w0, w20
	bhi	.L683
	strh	wzr, [x21, 56]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L683:
	add	x0, x21, x20, sxtw 1
	ldrh	w25, [x0, 58]
	ldr	x0, [x23, #:lo12:.LANCHOR4]
	mov	x19, x25
	lsl	x26, x25, 1
	ldrh	w2, [x0, x26]
	cbz	w2, .L668
	mov	w1, w25
	mov	x0, x22
	bl	printf
.L668:
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	ldrh	w0, [x0, x26]
	cbnz	w0, .L669
	adrp	x0, .LANCHOR3
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x25, x0, x25, lsl 2
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L670
	ldrb	w2, [x25, 2]
	adrp	x0, .LC19
	mov	w1, w19
	add	x0, x0, :lo12:.LC19
	ubfx	x2, x2, 5, 3
	bl	printf
.L670:
	ldrb	w0, [x25, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L671
	tst	w0, 192
	bne	.L672
.L671:
	adrp	x1, .LANCHOR97
	adrp	x0, .LC0
	mov	w2, 770
	add	x1, x1, :lo12:.LANCHOR97
	add	x0, x0, :lo12:.LC0
	bl	printf
.L673:
	b	.L673
.L672:
	mov	w0, w19
	bl	ftl_free_sblk
	adrp	x0, .LANCHOR5
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldrh	w2, [x0, 124]
	cbz	w2, .L674
	add	x3, x0, 392
	mov	w1, 0
.L676:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L675
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 392]
	strh	w2, [x0, 124]
.L674:
	ldrh	w2, [x0, 120]
	cbz	w2, .L677
	add	x3, x0, 136
	mov	w1, 0
.L679:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L678
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 136]
	strh	w2, [x0, 120]
.L677:
	ldrh	w2, [x0, 122]
	cbz	w2, .L680
	add	x3, x0, 264
	mov	w1, 0
.L682:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L681
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 264]
	strh	w2, [x0, 122]
.L680:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L667
.L675:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L676
	b	.L674
.L678:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L679
	b	.L677
.L681:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L682
	b	.L680
.L669:
	mov	w2, 0
	mov	w1, 1
	mov	w0, w19
	bl	gc_add_sblk
	b	.L680
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
	adrp	x22, .LANCHOR99
	ldrh	w1, [x1, #:lo12:.LANCHOR96]
	sub	w1, w19, w1
	mov	w19, 1
	lsl	w19, w19, w1
	sub	w19, w19, #1
	and	w19, w19, w0
	asr	w20, w0, w1
	adrp	x0, .LANCHOR98
	sxth	w19, w19
	ldrb	w0, [x0, #:lo12:.LANCHOR98]
	cbz	w0, .L707
	ldrh	w2, [x22, #:lo12:.LANCHOR99]
	cmp	w21, 0
	cset	w1, eq
	mov	w0, w20
	mul	w2, w2, w19
	bl	flash_erase_block_en
.L707:
	ldrh	w2, [x22, #:lo12:.LANCHOR99]
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
	stp	x29, x30, [sp, -160]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR3
	stp	x25, x26, [sp, 64]
	and	w25, w0, 65535
	ldr	x0, [x21, #:lo12:.LANCHOR3]
	mov	w22, w1
	stp	x19, x20, [sp, 16]
	ubfiz	x20, x25, 2, 16
	add	x0, x0, x20
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR100
	adrp	x23, .LANCHOR95
	add	x24, x24, :lo12:.LANCHOR100
	add	x23, x23, :lo12:.LANCHOR95
	ldrb	w26, [x0, 3]
	mov	w19, 0
	str	x27, [sp, 80]
	add	x27, x29, 96
.L713:
	ldrb	w0, [x24]
	cmp	w19, w0
	bge	.L720
	ldrb	w3, [x23]
	adrp	x0, .LANCHOR99
	mov	w1, 0
	ldrh	w4, [x0, #:lo12:.LANCHOR99]
	mov	w0, 0
	mul	w6, w19, w3
	mul	w5, w25, w3
	b	.L721
.L715:
	add	w2, w0, w6
	asr	w2, w26, w2
	tbnz	x2, 0, .L714
	and	w2, w0, 1
	add	w2, w2, w5
	mul	w2, w2, w4
	str	w2, [x27, w1, sxtw 2]
	add	w1, w1, 1
.L714:
	add	w0, w0, 1
.L721:
	cmp	w0, w3
	blt	.L715
	cmp	w1, 2
	bne	.L716
	adrp	x0, .LANCHOR98
	ldrb	w0, [x0, #:lo12:.LANCHOR98]
	cbz	w0, .L717
	ldp	w2, w3, [x29, 96]
	cmp	w22, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_duplane_block
.L717:
	ldp	w2, w3, [x29, 96]
	mov	w1, w22
	mov	w0, w19
	bl	flash_erase_duplane_block
.L718:
	add	w19, w19, 1
	b	.L713
.L716:
	cmp	w1, 1
	bne	.L718
	adrp	x0, .LANCHOR98
	ldrb	w0, [x0, #:lo12:.LANCHOR98]
	cbz	w0, .L719
	ldr	w2, [x29, 96]
	cmp	w22, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_block_en
.L719:
	ldr	w2, [x29, 96]
	mov	w1, w22
	mov	w0, w19
	bl	flash_erase_block_en
	b	.L718
.L720:
	adrp	x2, .LANCHOR53
	ldr	x3, [x21, #:lo12:.LANCHOR3]
	cbnz	w22, .L722
	ldrh	w1, [x3, x20]
	add	w0, w1, 1
	and	w0, w0, 2047
	bfi	w1, w0, 0, 11
	strh	w1, [x3, x20]
	ldr	x1, [x2, #:lo12:.LANCHOR53]
	ldr	w2, [x1, 84]
	add	w2, w2, 1
	str	w2, [x1, 84]
	ldrh	w2, [x1, 96]
	cmp	w2, w0
	bge	.L724
	strh	w0, [x1, 96]
.L724:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L722:
	ldr	w1, [x3, x20]
	ubfx	x0, x1, 11, 8
	add	w0, w0, 1
	and	w0, w0, 255
	bfi	w1, w0, 11, 8
	str	w1, [x3, x20]
	and	w0, w0, 65535
	ldr	x1, [x2, #:lo12:.LANCHOR53]
	ldr	w2, [x1, 80]
	add	w2, w2, 1
	str	w2, [x1, 80]
	ldrh	w2, [x1, 98]
	cmp	w2, w0
	bcs	.L724
	strh	w0, [x1, 98]
	b	.L724
	.size	ftl_erase_sblk, .-ftl_erase_sblk
	.section	.text.ftl_alloc_sys_blk,"ax",@progbits
	.align	2
	.global	ftl_alloc_sys_blk
	.type	ftl_alloc_sys_blk, %function
ftl_alloc_sys_blk:
	adrp	x0, .LANCHOR53
	ldr	x1, [x0, #:lo12:.LANCHOR53]
	ldrh	w0, [x1, 136]
	cmp	w0, 63
	bls	.L734
	strh	wzr, [x1, 136]
.L734:
	ldrh	w3, [x1, 112]
	cbnz	w3, .L735
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR101
	adrp	x0, .LC0
	mov	w2, 983
	add	x29, sp, 0
	add	x1, x1, :lo12:.LANCHOR101
	add	x0, x0, :lo12:.LC0
	bl	printf
.L736:
	b	.L736
.L735:
	mov	w6, 65535
.L741:
	ldrh	w2, [x1, 136]
.L737:
	mov	w4, w2
	cmp	w2, 63
	ble	.L738
	strh	wzr, [x1, 136]
	b	.L741
.L738:
	add	x5, x2, 1
	add	x0, x1, x5, lsl 1
	ldrh	w0, [x0, 158]
	cmp	w0, w6
	bne	.L742
	mov	x2, x5
	b	.L737
.L742:
	add	x4, x1, x4, sxtw 1
	mov	w5, -1
	sub	w3, w3, #1
	strh	w5, [x4, 160]
	strh	w2, [x1, 136]
	strh	w3, [x1, 112]
	ret
	.size	ftl_alloc_sys_blk, .-ftl_alloc_sys_blk
	.section	.text.ftl_free_sys_blk,"ax",@progbits
	.align	2
	.global	ftl_free_sys_blk
	.type	ftl_free_sys_blk, %function
ftl_free_sys_blk:
	adrp	x1, .LANCHOR53
	and	w0, w0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR53]
	ldrh	w2, [x1, 138]
	cmp	w2, 63
	bls	.L747
	strh	wzr, [x1, 138]
.L747:
	ldrh	w3, [x1, 112]
	cmp	w3, 63
	bls	.L748
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR102
	adrp	x0, .LC0
	mov	w2, 1007
	add	x29, sp, 0
	add	x1, x1, :lo12:.LANCHOR102
	add	x0, x0, :lo12:.LC0
	bl	printf
.L749:
	b	.L749
.L748:
	mov	w6, 65535
.L754:
	ldrh	w2, [x1, 138]
.L750:
	mov	w4, w2
	cmp	w2, 63
	ble	.L751
	strh	wzr, [x1, 138]
	b	.L754
.L751:
	add	x5, x2, 1
	add	x7, x1, x5, lsl 1
	ldrh	w7, [x7, 158]
	cmp	w7, w6
	bne	.L752
	add	x4, x1, x4, sxtw 1
	add	w3, w3, 1
	strh	w0, [x4, 160]
	strh	w2, [x1, 138]
	strh	w3, [x1, 112]
	ret
.L752:
	mov	x2, x5
	b	.L750
	.size	ftl_free_sys_blk, .-ftl_free_sys_blk
	.section	.text.ftl_info_data_recovery,"ax",@progbits
	.align	2
	.global	ftl_info_data_recovery
	.type	ftl_info_data_recovery, %function
ftl_info_data_recovery:
	ldrh	w2, [x0]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L768
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
	bne	.L758
	ldrb	w0, [x0, 4]
	bfi	w1, w0, 5, 3
	strb	w1, [x21, 2]
	mov	w0, w2
	bl	zftl_remove_free_node
	ldrb	w0, [x21, 2]
	adrp	x1, .LANCHOR53
	ldr	x3, [x1, #:lo12:.LANCHOR53]
	tbz	x0, 3, .L762
	ldrh	w2, [x3, 116]
	sub	w2, w2, #1
	strh	w2, [x3, 116]
.L763:
	and	w0, w0, 224
	cmp	w0, 160
	bne	.L765
	ldr	w0, [x20, x19]
	ldr	x1, [x1, #:lo12:.LANCHOR53]
	ubfx	x2, x0, 11, 8
	add	w2, w2, 1
	bfi	w0, w2, 11, 8
	str	w0, [x20, x19]
	ldrh	w0, [x1, 120]
	sub	w0, w0, #1
	strh	w0, [x1, 120]
.L758:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L762:
	tst	w0, 24
	bne	.L764
	ldrh	w2, [x3, 114]
	sub	w2, w2, #1
	strh	w2, [x3, 114]
	b	.L763
.L764:
	ldrh	w2, [x3, 118]
	sub	w2, w2, #1
	strh	w2, [x3, 118]
	b	.L763
.L765:
	ldrh	w2, [x20, x19]
	cmp	w0, 64
	add	w3, w2, 1
	bfi	w2, w3, 0, 11
	strh	w2, [x20, x19]
	bne	.L766
	ldr	x1, [x1, #:lo12:.LANCHOR53]
	ldrh	w0, [x1, 122]
	sub	w0, w0, #1
	strh	w0, [x1, 122]
	b	.L758
.L766:
	cmp	w0, 96
	bne	.L758
	ldr	x1, [x1, #:lo12:.LANCHOR53]
	ldrh	w0, [x1, 124]
	sub	w0, w0, #1
	strh	w0, [x1, 124]
	b	.L758
.L768:
	ret
	.size	ftl_info_data_recovery, .-ftl_info_data_recovery
	.section	.text.ftl_get_ppa_from_index,"ax",@progbits
	.align	2
	.global	ftl_get_ppa_from_index
	.type	ftl_get_ppa_from_index, %function
ftl_get_ppa_from_index:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR5
	adrp	x2, .LANCHOR72
	ldr	x3, [x0, #:lo12:.LANCHOR5]
	adrp	x0, .LANCHOR80
	ldrb	w2, [x2, #:lo12:.LANCHOR72]
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	mul	w0, w0, w2
	cmp	w1, w0
	bge	.L772
	add	x3, x3, 16
.L773:
	ldrb	w2, [x3, 9]
	sdiv	w4, w1, w2
	msub	w1, w4, w2, w1
	add	x1, x3, x1, uxth 1
	ldrh	w0, [x1, 16]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L774
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR103
	adrp	x0, .LC0
	mov	w2, 1385
	add	x29, sp, 0
	add	x1, x1, :lo12:.LANCHOR103
	add	x0, x0, :lo12:.LC0
	bl	printf
.L775:
	b	.L775
.L772:
	sub	w1, w1, w0
	add	x3, x3, 48
	and	w1, w1, 65535
	b	.L773
.L774:
	adrp	x1, .LANCHOR99
	ldrh	w1, [x1, #:lo12:.LANCHOR99]
	madd	w0, w1, w0, w4
	ret
	.size	ftl_get_ppa_from_index, .-ftl_get_ppa_from_index
	.section	.text.lpa_hash_get_ppa,"ax",@progbits
	.align	2
	.global	lpa_hash_get_ppa
	.type	lpa_hash_get_ppa, %function
lpa_hash_get_ppa:
	and	x2, x0, 255
	adrp	x1, .LANCHOR104
	add	x1, x1, :lo12:.LANCHOR104
	mov	w3, 65535
	ldrh	w1, [x1, x2, lsl 1]
	adrp	x2, .LANCHOR105
	ldr	x4, [x2, #:lo12:.LANCHOR105]
	adrp	x2, .LANCHOR106
	ldr	x5, [x2, #:lo12:.LANCHOR106]
.L780:
	cmp	w1, w3
	bne	.L782
	mov	w0, -1
	ret
.L782:
	uxtw	x2, w1
	ldr	w6, [x4, x2, lsl 2]
	cmp	w0, w6
	bne	.L781
	mov	w0, w1
	b	ftl_get_ppa_from_index
.L781:
	ldrh	w1, [x5, x2, lsl 1]
	b	.L780
	.size	lpa_hash_get_ppa, .-lpa_hash_get_ppa
	.section	.text.ftl_get_new_free_page,"ax",@progbits
	.align	2
	.global	ftl_get_new_free_page
	.type	ftl_get_new_free_page, %function
ftl_get_new_free_page:
	stp	x29, x30, [sp, -16]!
	mov	x1, x0
	mov	w2, 65535
	add	x29, sp, 0
	ldrh	w0, [x0]
	cmp	w0, w2
	bne	.L784
	adrp	x1, .LANCHOR107
	adrp	x0, .LC0
	mov	w2, 1500
	add	x1, x1, :lo12:.LANCHOR107
	add	x0, x0, :lo12:.LC0
	bl	printf
.L785:
	b	.L785
.L784:
	adrp	x0, .LANCHOR80
	ldrh	w3, [x1, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w3, w0
	bne	.L786
	adrp	x1, .LANCHOR107
	adrp	x0, .LC0
	mov	w2, 1501
	add	x1, x1, :lo12:.LANCHOR107
	add	x0, x0, :lo12:.LC0
	bl	printf
.L787:
	b	.L787
.L786:
	ldrh	w4, [x1, 6]
	cbnz	w4, .L788
	adrp	x1, .LANCHOR107
	adrp	x0, .LC0
	mov	w2, 1502
	add	x1, x1, :lo12:.LANCHOR107
	add	x0, x0, :lo12:.LC0
	bl	printf
.L789:
	b	.L789
.L788:
	ldrb	w0, [x1, 5]
	mov	w3, w2
	add	x0, x0, 8
	ldrh	w5, [x1, x0, lsl 1]
	adrp	x0, .LANCHOR72
	ldrb	w6, [x0, #:lo12:.LANCHOR72]
.L790:
	cmp	w5, w3
	ldrb	w2, [x1, 5]
	beq	.L792
	adrp	x0, .LANCHOR99
	sub	w4, w4, #1
	strh	w4, [x1, 6]
	add	w2, w2, 1
	ldrh	w0, [x0, #:lo12:.LANCHOR99]
	and	w2, w2, 255
	ldrh	w4, [x1, 10]
	cmp	w6, w2
	ldrh	w3, [x1, 2]
	add	w4, w4, 1
	strb	w2, [x1, 5]
	mul	w0, w0, w5
	strh	w4, [x1, 10]
	orr	w0, w0, w3
	bne	.L783
	add	w3, w3, 1
	strb	wzr, [x1, 5]
	strh	w3, [x1, 2]
.L783:
	ldp	x29, x30, [sp], 16
	ret
.L792:
	add	w2, w2, 1
	and	w2, w2, 255
	strb	w2, [x1, 5]
	cmp	w2, w6
	bne	.L791
	ldrh	w0, [x1, 2]
	strb	wzr, [x1, 5]
	add	w0, w0, 1
	strh	w0, [x1, 2]
.L791:
	ldrb	w0, [x1, 5]
	add	x0, x0, 8
	ldrh	w5, [x1, x0, lsl 1]
	b	.L790
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
	and	w1, w0, 65535
	mov	w2, 65533
	mov	w19, w1
	sub	w1, w1, #1
	cmp	w2, w1, uxth
	bcs	.L796
	adrp	x1, .LANCHOR108
	adrp	x0, .LC0
	mov	w2, 1533
	add	x1, x1, :lo12:.LANCHOR108
	add	x0, x0, :lo12:.LC0
	bl	printf
.L797:
	b	.L797
.L796:
	adrp	x20, .LANCHOR53
	mov	w1, 0
	bl	ftl_erase_phy_blk
	ldr	x0, [x20, #:lo12:.LANCHOR53]
	ldrh	w0, [x0, 130]
	bl	ftl_free_sys_blk
	ldr	x0, [x20, #:lo12:.LANCHOR53]
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
	adrp	x2, .LANCHOR109
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR109]
	cmp	w1, 4
	bhi	.L800
	cbnz	w0, .L800
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR109]
	ret
.L800:
	adrp	x0, .LANCHOR2
	strh	wzr, [x3, #:lo12:.LANCHOR109]
	mov	x1, 0
	mov	w2, 0
	ldrh	w5, [x0, #:lo12:.LANCHOR2]
	adrp	x0, .LANCHOR4
	mov	w8, 65535
	ldr	x6, [x0, #:lo12:.LANCHOR4]
	adrp	x0, .LANCHOR3
	ldr	x7, [x0, #:lo12:.LANCHOR3]
	mov	w0, 0
.L802:
	cmp	w5, w1, uxth
	bhi	.L805
	adrp	x1, .LANCHOR5
	ldr	x1, [x1, #:lo12:.LANCHOR5]
	str	w2, [x1, 524]
	adrp	x2, .LANCHOR53
	str	w0, [x1, 528]
	ldr	x2, [x2, #:lo12:.LANCHOR53]
	ldrh	w2, [x2, 120]
	cbz	w2, .L799
	udiv	w0, w0, w2
	str	w0, [x1, 532]
.L799:
	ret
.L805:
	ldrh	w3, [x6, x1, lsl 1]
	cmp	w3, w8
	beq	.L803
	add	x4, x7, x1, lsl 2
	ldrb	w4, [x4, 2]
	and	w4, w4, 224
	cmp	w4, 160
	bne	.L804
	add	w0, w0, w3
.L803:
	add	x1, x1, 1
	b	.L802
.L804:
	add	w2, w2, w3
	b	.L803
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
	beq	.L814
	adrp	x0, .LANCHOR4
	ubfiz	x1, x19, 1, 16
	ldr	x2, [x0, #:lo12:.LANCHOR4]
	ldrh	w0, [x2, x1]
	cbnz	w0, .L815
	adrp	x0, .LC20
	mov	w2, 0
	mov	w1, w19
	add	x0, x0, :lo12:.LC20
	bl	printf
.L818:
	mov	w0, 0
	b	.L813
.L815:
	sub	w0, w0, #1
	strh	w0, [x2, x1]
.L814:
	adrp	x20, .LANCHOR110
	ldrh	w0, [x20, #:lo12:.LANCHOR110]
	cmp	w19, w0
	beq	.L818
	mov	w1, 65535
	cmp	w0, w1
	bne	.L817
	strh	w19, [x20, #:lo12:.LANCHOR110]
	b	.L818
.L817:
	bl	ftl_vpn_update
	cmp	w0, 0
	cset	w0, ne
	strh	w19, [x20, #:lo12:.LANCHOR110]
.L813:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	ftl_vpn_decrement, .-ftl_vpn_decrement
	.section	.text.lpa_hash_update_ppa,"ax",@progbits
	.align	2
	.global	lpa_hash_update_ppa
	.type	lpa_hash_update_ppa, %function
lpa_hash_update_ppa:
	adrp	x3, .LANCHOR104
	and	x5, x0, 255
	add	x4, x3, :lo12:.LANCHOR104
	mov	w7, 65535
	and	w2, w2, 65535
	mov	w12, w7
	ldrh	w6, [x4, x5, lsl 1]
	adrp	x4, .LANCHOR105
	ldr	x8, [x4, #:lo12:.LANCHOR105]
	adrp	x4, .LANCHOR106
	ldr	x4, [x4, #:lo12:.LANCHOR106]
.L821:
	cmp	w6, w12
	beq	.L825
	uxtw	x11, w6
	lsl	x10, x11, 2
	add	x13, x8, x10
	ldr	w10, [x8, x10]
	cmp	w0, w10
	lsl	x10, x11, 1
	bne	.L822
	mov	w6, -1
	str	w6, [x13]
	cmp	w7, w12
	bne	.L823
	add	x6, x3, :lo12:.LANCHOR104
	ldrh	w7, [x4, x10]
	strh	w7, [x6, x5, lsl 1]
.L824:
	mov	w6, -1
	strh	w6, [x4, x11, lsl 1]
.L825:
	uxtw	x6, w2
	add	x3, x3, :lo12:.LANCHOR104
	cmn	w1, #1
	str	w0, [x8, x6, lsl 2]
	ldrh	w0, [x3, x5, lsl 1]
	strh	w2, [x3, x5, lsl 1]
	strh	w0, [x4, x6, lsl 1]
	beq	.L832
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
.L823:
	ldrh	w6, [x4, x10]
	strh	w6, [x4, w7, uxtw 1]
	b	.L824
.L822:
	mov	w7, w6
	ldrh	w6, [x4, x10]
	b	.L821
.L832:
	mov	w0, -1
	ret
	.size	lpa_hash_update_ppa, .-lpa_hash_update_ppa
	.section	.text.ftl_write_completed,"ax",@progbits
	.align	2
	.global	ftl_write_completed
	.type	ftl_write_completed, %function
ftl_write_completed:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR111
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR43
	adrp	x22, .LANCHOR96
	add	x20, x20, :lo12:.LANCHOR111
	add	x19, x19, :lo12:.LANCHOR43
	add	x22, x22, :lo12:.LANCHOR96
	stp	x23, x24, [sp, 48]
	str	x25, [sp, 64]
.L836:
	ldrb	w0, [x20]
	cmp	w0, 255
	bne	.L842
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L842:
	ubfiz	x21, x0, 6, 8
	sbfiz	x0, x0, 6, 32
	add	x23, x19, x0
	add	x21, x19, x21
	ldrb	w0, [x19, x0]
	strb	w0, [x20]
	ldr	w0, [x23, 52]
	cmn	w0, #1
	bne	.L837
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
	adrp	x0, .LC21
	add	x0, x0, :lo12:.LC21
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
	bne	.L838
	strh	wzr, [x0, 22]
.L839:
	mov	x0, x21
	bl	ftl_write_buf
	b	.L836
.L838:
	ldrh	w1, [x0, 48]
	cmp	w1, w24
	bne	.L839
	strh	wzr, [x0, 54]
	b	.L839
.L837:
	ldrh	w2, [x23, 48]
	ldr	w0, [x23, 36]
	ldr	w1, [x23, 44]
	bl	lpa_hash_update_ppa
	ldrb	w0, [x23, 2]
	tbz	x0, 2, .L841
	and	w0, w0, -3
	strb	w0, [x23, 2]
	b	.L836
.L841:
	mov	x0, x21
	bl	buf_free
	b	.L836
	.size	ftl_write_completed, .-ftl_write_completed
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
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	and	w19, w2, 255
	tbz	x0, 14, .L845
	adrp	x0, .LC22
	mov	w2, w19
	mov	w1, w20
	add	x0, x0, :lo12:.LC22
	bl	printf
.L845:
	adrp	x0, .LANCHOR2
	ldrh	w0, [x0, #:lo12:.LANCHOR2]
	cmp	w0, w19
	bls	.L844
	adrp	x0, .LANCHOR3
	mov	w1, 1
	lsl	w1, w1, w20
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x19, x0, x19, uxtb 2
	ldrb	w0, [x19, 3]
	orr	w1, w1, w0
	strb	w1, [x19, 3]
.L844:
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
	adrp	x0, .LC23
	ldrh	w1, [x1, #:lo12:.LANCHOR89]
	add	x0, x0, :lo12:.LC23
	str	x19, [sp, 48]
	adrp	x19, .LANCHOR53
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	adrp	x1, .LANCHOR112
	ldrb	w3, [x1, #:lo12:.LANCHOR112]
	ldr	w4, [x0, 8]
	ldr	w5, [x0, 64]
	ldr	w1, [x0, 20]
	ldr	w2, [x0, 28]
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	ldr	w1, [x0, 52]
	ldr	w2, [x0, 60]
	ldr	w3, [x0, 16]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	lsr	w3, w3, 11
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR53]
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
	adrp	x0, .LC26
	add	x0, x0, :lo12:.LC26
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
	adrp	x0, .LC27
	add	x0, x0, :lo12:.LC27
	b	printf
	.size	print_ftl_debug_info, .-print_ftl_debug_info
	.section	.text.ftl_alloc_sblk,"ax",@progbits
	.align	2
	.global	ftl_alloc_sblk
	.type	ftl_alloc_sblk, %function
ftl_alloc_sblk:
	stp	x29, x30, [sp, -48]!
	cmp	w0, 5
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w22, w0, 65535
	stp	x19, x20, [sp, 16]
	cset	w21, eq
	mov	w1, w22
	mov	w20, w0
	mov	w0, 0
	bl	zftl_get_free_sblk
	and	w19, w0, 65535
	mov	w1, 65535
	cmp	w19, w1
	beq	.L855
	adrp	x1, .LANCHOR3
	ldr	x1, [x1, #:lo12:.LANCHOR3]
	add	x19, x1, x19, uxth 2
	ldrb	w2, [x19, 2]
	tst	w2, 224
	beq	.L856
	adrp	x1, .LANCHOR113
	adrp	x0, .LC0
	mov	w2, 752
	add	x1, x1, :lo12:.LANCHOR113
	add	x0, x0, :lo12:.LC0
	bl	printf
.L857:
	b	.L857
.L856:
	bfi	w2, w20, 5, 3
	lsl	w21, w21, 1
	ubfx	x1, x2, 3, 2
	orr	w21, w21, w1
	bfi	w2, w21, 3, 2
	strb	w2, [x19, 2]
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L855:
	bl	print_ftl_debug_info
	adrp	x21, .LC28
	mov	w2, w20
	add	x21, x21, :lo12:.LC28
	mov	w1, w19
	mov	x0, x21
	bl	printf
	mov	w1, w22
	mov	w0, 0
	bl	zftl_get_free_sblk
	and	w1, w0, 65535
	mov	w2, w20
	mov	x0, x21
	bl	printf
	bl	dump_all_list_info
	adrp	x1, .LANCHOR113
	adrp	x0, .LC0
	mov	w2, 762
	add	x1, x1, :lo12:.LANCHOR113
	add	x0, x0, :lo12:.LC0
	bl	printf
.L858:
	b	.L858
	.size	ftl_alloc_sblk, .-ftl_alloc_sblk
	.section	.text.sblk_init,"ax",@progbits
	.align	2
	.global	sblk_init
	.type	sblk_init, %function
sblk_init:
	adrp	x1, .LANCHOR114
	mov	w0, -1
	strb	w0, [x1, #:lo12:.LANCHOR114]
	adrp	x1, .LANCHOR111
	strb	w0, [x1, #:lo12:.LANCHOR111]
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
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR114
	str	x21, [sp, 32]
	ldrb	w1, [x19, #:lo12:.LANCHOR114]
	bl	printf
	ldrb	w19, [x19, #:lo12:.LANCHOR114]
	cmp	w19, 255
	beq	.L863
	adrp	x1, .LANCHOR43
	ubfiz	x19, x19, 6, 8
	add	x1, x1, :lo12:.LANCHOR43
	adrp	x21, .LC30
	add	x19, x1, x19
	add	x21, x21, :lo12:.LC30
	mov	x20, x1
.L865:
	ldrb	w2, [x19, 58]
	mov	x0, x21
	ldrb	w1, [x19, 1]
	ldr	w3, [x19, 40]
	bl	printf
	ldrb	w19, [x19]
	cmp	w19, 255
	beq	.L863
	ubfiz	x19, x19, 6, 8
	add	x19, x20, x19
	b	.L865
.L863:
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
	adrp	x2, .LANCHOR114
	ldrb	w2, [x2, #:lo12:.LANCHOR114]
	cmp	w2, 255
	beq	.L882
	adrp	x3, .LANCHOR96
	adrp	x7, .LANCHOR43
	add	x7, x7, :lo12:.LANCHOR43
	adrp	x10, .L878
	ldrh	w8, [x3, #:lo12:.LANCHOR96]
	mov	w3, 21
	ubfx	x11, x0, 21, 3
	add	x10, x10, :lo12:.L878
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
.L881:
	add	x0, x7, x2, lsl 6
	ldr	w5, [x0, 40]
	ubfx	x13, x5, 21, 3
	cmp	w11, w13
	bne	.L875
	lsr	w5, w5, w8
	and	w5, w6, w5
	and	w5, w3, w5
	ldrb	w0, [x0, 58]
	cmp	w4, w5
	bne	.L876
	cmp	w1, 1
	bne	.L873
	cmp	w0, 6
	ccmp	w0, 8, 4, ne
	beq	.L875
	ret
.L876:
	cmp	w1, 3
	bhi	.L875
	ldrb	w5, [x10,w1,uxtw]
	adr	x13, .Lrtx878
	add	x5, x13, w5, sxtb #2
	br	x5
.Lrtx878:
	.section	.rodata.queue_lun_state,"a",@progbits
	.align	0
	.align	2
.L878:
	.byte	(.L877 - .Lrtx878) / 4
	.byte	(.L879 - .Lrtx878) / 4
	.byte	(.L880 - .Lrtx878) / 4
	.byte	(.L873 - .Lrtx878) / 4
	.section	.text.queue_lun_state
.L877:
	cmp	w0, 2
	beq	.L875
	ret
.L879:
	cmp	w0, 6
	ccmp	w0, 8, 4, ne
	beq	.L875
	ret
.L880:
	cmp	w0, 10
	bne	.L873
.L875:
	lsl	x2, x2, 6
	ldrb	w2, [x12, x2]
	cmp	w2, 255
	bne	.L881
.L882:
	mov	w0, 0
.L873:
	ret
	.size	queue_lun_state, .-queue_lun_state
	.section	.text.queue_remove_completed_req,"ax",@progbits
	.align	2
	.global	queue_remove_completed_req
	.type	queue_remove_completed_req, %function
queue_remove_completed_req:
	adrp	x6, .LANCHOR114
	ldrb	w2, [x6, #:lo12:.LANCHOR114]
	cmp	w2, 255
	beq	.L884
	adrp	x0, .LANCHOR43
	lsl	x4, x2, 6
	add	x5, x0, :lo12:.LANCHOR43
	add	x3, x5, x4
	ldrb	w1, [x3, 58]
	sub	w1, w1, #11
	and	w1, w1, 255
	cmp	w1, 1
	mov	x1, x0
	bhi	.L884
	ldrb	w0, [x5, x4]
	strb	w0, [x6, #:lo12:.LANCHOR114]
	mov	w0, -1
	strb	w0, [x5, x4]
	ldrb	w0, [x3, 59]
	cmp	w0, 1
	bne	.L886
	ldrh	w0, [x3, 50]
	cbnz	w0, .L887
	adrp	x0, .LANCHOR111
	ldrb	w3, [x0, #:lo12:.LANCHOR111]
	add	x0, x0, :lo12:.LANCHOR111
.L888:
	cmp	w3, 255
	bne	.L892
	add	x1, x1, :lo12:.LANCHOR43
	add	x1, x1, x2, lsl 6
	ldrb	w1, [x1, 1]
	strb	w1, [x0]
	ret
.L887:
	adrp	x0, .LANCHOR65
	ldrb	w3, [x0, #:lo12:.LANCHOR65]
	add	x0, x0, :lo12:.LANCHOR65
	b	.L888
.L886:
	cbnz	w0, .L884
	ldr	w0, [x3, 36]
	cmn	w0, #1
	beq	.L884
	adrp	x0, .LANCHOR58
	ldrb	w3, [x0, #:lo12:.LANCHOR58]
	add	x0, x0, :lo12:.LANCHOR58
	b	.L888
.L892:
	add	x0, x1, :lo12:.LANCHOR43
.L899:
	mov	w1, w3
	sbfiz	x3, x3, 6, 32
	ldrb	w3, [x0, x3]
	cmp	w3, 255
	bne	.L899
	add	x2, x0, x2, lsl 6
	sbfiz	x1, x1, 6, 32
	ldrb	w2, [x2, 1]
	strb	w2, [x0, x1]
	ret
.L884:
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
	adrp	x20, .LANCHOR53
	stp	x21, x22, [sp, 32]
	ldr	x1, [x20, #:lo12:.LANCHOR53]
	ldrb	w2, [x2, #:lo12:.LANCHOR72]
	ldrh	w0, [x1, 690]
	str	x23, [sp, 48]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, 690]
	cmp	w2, w0
	bls	.L901
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x0, 672]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L902
.L901:
	adrp	x21, .LC31
	add	x21, x21, :lo12:.LC31
	adrp	x23, .LANCHOR3
.L916:
	mov	w0, 1
	bl	ftl_alloc_sblk
	mov	w1, 0
	and	w19, w0, 65535
	bl	ftl_erase_sblk
	add	x13, x20, :lo12:.LANCHOR53
	ldr	x1, [x20, #:lo12:.LANCHOR53]
	mov	w0, w19
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	tst	w0, 65535
	bne	.L903
	mov	w1, w19
	mov	x0, x21
	bl	printf
	ldr	x0, [x23, #:lo12:.LANCHOR3]
	add	x19, x0, x19, uxth 2
	ldrb	w0, [x19, 2]
	orr	w0, w0, -32
	strb	w0, [x19, 2]
	b	.L916
.L903:
	ldr	x1, [x13]
	adrp	x0, .LANCHOR115
	mov	w2, 1
	mov	w3, 65535
	str	w2, [x0, #:lo12:.LANCHOR115]
	add	x2, x1, 416
	mov	w0, 0
	strh	wzr, [x1, 690]
.L905:
	ldrh	w4, [x2]
	cmp	w4, w3
	beq	.L904
	add	w0, w0, 1
	add	x2, x2, 2
	cmp	w0, 128
	bne	.L905
	adrp	x1, .LANCHOR116
	adrp	x0, .LC0
	mov	w2, 188
	add	x1, x1, :lo12:.LANCHOR116
	add	x0, x0, :lo12:.LC0
	bl	printf
.L907:
	b	.L907
.L908:
	adrp	x1, .LANCHOR96
	mov	w2, 21
	strh	wzr, [x0, 696]
	ldrh	w1, [x1, #:lo12:.LANCHOR96]
	strh	w3, [x0, 692]
	sub	w2, w2, w1
	asr	w4, w3, w2
	strh	w4, [x0, 694]
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L912
	mov	w0, 1
	and	w4, w4, 65535
	lsl	w2, w0, w2
	mov	w1, w3
	adrp	x0, .LC32
	sub	w2, w2, #1
	add	x0, x0, :lo12:.LC32
	bl	printf
.L912:
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L904:
	add	x0, x1, x0, sxtw 1
	strh	w19, [x0, 416]
	ldrh	w0, [x1, 688]
	add	w0, w0, 1
	strh	w0, [x1, 688]
.L902:
	ldr	x0, [x20, #:lo12:.LANCHOR53]
	ldrh	w1, [x0, 690]
	add	x1, x1, 336
	ldrh	w3, [x0, x1, lsl 1]
	mov	w1, 65533
	sub	w2, w3, #1
	cmp	w1, w2, uxth
	bcs	.L908
	adrp	x1, .LANCHOR116
	adrp	x0, .LC0
	mov	w2, 193
	add	x1, x1, :lo12:.LANCHOR116
	add	x0, x0, :lo12:.LC0
	bl	printf
.L909:
	b	.L909
	.size	pm_alloc_new_blk, .-pm_alloc_new_blk
	.section	.text.pm_select_ram_region,"ax",@progbits
	.align	2
	.global	pm_select_ram_region
	.type	pm_select_ram_region, %function
pm_select_ram_region:
	adrp	x1, .LANCHOR117
	add	x1, x1, :lo12:.LANCHOR117
	mov	x2, 0
	mov	w3, 65535
.L921:
	lsl	x4, x2, 4
	and	w0, w2, 65535
	ldrh	w4, [x4, x1]
	cmp	w4, w3
	beq	.L920
	add	x2, x2, 1
	cmp	x2, 32
	bne	.L921
	add	x1, x1, 2
	mov	w0, w2
	mov	x3, x1
	mov	w5, 32768
	mov	w2, 0
.L923:
	ldrh	w4, [x3]
	tbnz	x4, 15, .L922
	cmp	w4, w5
	bcs	.L922
	mov	w5, w4
	mov	w0, w2
.L922:
	add	w2, w2, 1
	add	x3, x3, 16
	and	w2, w2, 65535
	cmp	w2, 32
	bne	.L923
	cmp	w0, 32
	bne	.L920
	adrp	x2, .LANCHOR118
	mov	w3, -1
	ldrb	w4, [x2, #:lo12:.LANCHOR118]
	mov	w2, 0
.L925:
	ldrh	w6, [x1]
	cmp	w6, w3
	bcs	.L924
	ldrh	w5, [x1, -2]
	cmp	w5, w4
	csel	w3, w3, w6, eq
	csel	w0, w0, w2, eq
.L924:
	add	w2, w2, 1
	add	x1, x1, 16
	and	w2, w2, 65535
	cmp	w2, 32
	bne	.L925
	cmp	w0, 32
	bne	.L920
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR119
	adrp	x0, .LC0
	mov	w2, 289
	add	x29, sp, 0
	add	x1, x1, :lo12:.LANCHOR119
	add	x0, x0, :lo12:.LC0
	bl	printf
.L926:
	b	.L926
.L920:
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
	adrp	x19, .LANCHOR21
	cbnz	w0, .L935
	add	x1, x19, :lo12:.LANCHOR21
	mov	x0, 0
.L936:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 256
	bne	.L936
.L942:
	adrp	x20, .LANCHOR120
	add	x20, x20, :lo12:.LANCHOR120
	mov	w2, 1024
	mov	w1, 255
	mov	x0, x20
	add	x19, x19, :lo12:.LANCHOR21
	bl	ftl_memset
	mov	x0, 0
.L937:
	ldrh	w1, [x0, x19]
	add	x0, x0, 2
	cmp	x0, 512
	strh	w1, [x20, w1, sxtw 1]
	bne	.L937
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L935:
	cmp	w0, 1
	bne	.L938
	add	x3, x19, :lo12:.LANCHOR21
	mov	x1, 0
.L941:
	and	w0, w1, 65535
	cmp	x1, 3
	bls	.L939
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 2
	sub	w0, w2, w0
	and	w0, w0, 65535
.L939:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L941
	b	.L942
.L938:
	cmp	w0, 2
	bne	.L943
	add	x3, x19, :lo12:.LANCHOR21
	mov	w1, 65535
	mov	x0, 0
.L945:
	cmp	x0, 2
	and	w2, w0, 65535
	csel	w2, w2, w1, cc
	strh	w2, [x3, x0, lsl 1]
	add	w1, w1, 2
	add	x0, x0, 1
	and	w1, w1, 65535
	cmp	x0, 256
	bne	.L945
	b	.L942
.L943:
	cmp	w0, 3
	bne	.L946
	add	x3, x19, :lo12:.LANCHOR21
	mov	x1, 0
.L949:
	and	w0, w1, 65535
	cmp	x1, 5
	bls	.L947
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 4
	sub	w0, w2, w0
	and	w0, w0, 65535
.L947:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L949
	b	.L942
.L946:
	cmp	w0, 4
	bne	.L950
	add	x1, x19, :lo12:.LANCHOR21
	mov	w2, 1
	add	x1, x1, 16
	strh	wzr, [x19, #:lo12:.LANCHOR21]
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
.L952:
	and	w3, w0, 1
	ubfiz	w2, w0, 1, 15
	add	w3, w3, 6
	add	w0, w0, 1
	sub	w2, w2, w3
	strh	w2, [x1], 2
	and	w0, w0, 65535
	cmp	w0, 256
	bne	.L952
	b	.L942
.L950:
	cmp	w0, 5
	bne	.L953
	add	x1, x19, :lo12:.LANCHOR21
	mov	x0, 0
.L954:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 16
	bne	.L954
	add	x1, x1, 32
.L955:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 496
	bne	.L955
	b	.L942
.L953:
	cmp	w0, 8
	bne	.L942
	add	x1, x19, :lo12:.LANCHOR21
	mov	x0, 0
.L956:
	strh	w0, [x0, x1]
	add	x0, x0, 2
	cmp	x0, 512
	bne	.L956
	b	.L942
	.size	flash_lsb_page_tbl_build, .-flash_lsb_page_tbl_build
	.section	.text.flash_die_info_init,"ax",@progbits
	.align	2
	.global	flash_die_info_init
	.type	flash_die_info_init, %function
flash_die_info_init:
	stp	x29, x30, [sp, -80]!
	mov	w2, 8
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR26
	add	x19, x23, :lo12:.LANCHOR26
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR20
	adrp	x26, .LANCHOR15
	adrp	x22, .LANCHOR17
	ldrh	w0, [x19, 26]
	add	x21, x22, :lo12:.LANCHOR17
	ldrb	w1, [x19, 12]
	adrp	x24, .LANCHOR122
	strh	w0, [x25, #:lo12:.LANCHOR20]
	add	x20, x24, :lo12:.LANCHOR122
	ldrh	w0, [x19, 10]
	add	x19, x19, 1
	strb	wzr, [x26, #:lo12:.LANCHOR15]
	sdiv	w0, w0, w1
	adrp	x1, .LANCHOR121
	strh	w0, [x1, #:lo12:.LANCHOR121]
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	mov	w2, 32
	mov	w1, 0
	mov	x0, x20
	bl	ftl_memset
	ldrb	w13, [x23, #:lo12:.LANCHOR26]
	mov	x7, x23
	adrp	x14, .LANCHOR33
	add	x11, x26, :lo12:.LANCHOR15
	add	x23, x14, :lo12:.LANCHOR33
	mov	x8, 0
.L973:
	mov	w2, w13
	add	x1, x23, x8, lsl 3
	mov	x0, x19
	bl	flash_mem_cmp8
	cbnz	w0, .L972
	ldrb	w1, [x11]
	add	w0, w1, 1
	strb	w0, [x11]
	str	wzr, [x20, x1, lsl 2]
	strb	w8, [x21, x1]
.L972:
	add	x8, x8, 1
	cmp	x8, 4
	bne	.L973
	add	x0, x7, :lo12:.LANCHOR26
	ldrb	w1, [x0, 8]
	cmp	w1, 2
	beq	.L974
.L978:
	add	x7, x7, :lo12:.LANCHOR26
	ldrb	w0, [x26, #:lo12:.LANCHOR15]
	ldp	x19, x20, [sp, 16]
	ldrb	w1, [x7, 13]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	mul	w0, w0, w1
	ldrh	w1, [x7, 14]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	mul	w0, w0, w1
	adrp	x1, .LANCHOR123
	strh	w0, [x1, #:lo12:.LANCHOR123]
	ret
.L974:
	ldrh	w1, [x25, #:lo12:.LANCHOR20]
	add	x14, x14, :lo12:.LANCHOR33
	ldrb	w11, [x0, 13]
	add	x8, x0, 1
	ldrb	w20, [x0, 23]
	add	x19, x26, :lo12:.LANCHOR15
	add	x15, x24, :lo12:.LANCHOR122
	add	x22, x22, :lo12:.LANCHOR17
	mov	x12, 0
	mul	w11, w11, w1
	ldrh	w1, [x0, 14]
	and	w1, w1, 65280
	mul	w11, w11, w1
	lsl	w21, w11, 1
.L977:
	mov	w2, w13
	add	x1, x14, x12, lsl 3
	mov	x0, x8
	bl	flash_mem_cmp8
	cbnz	w0, .L975
	ldrb	w1, [x19]
	cmp	w20, 0
	csel	w2, w11, w21, eq
	add	w0, w1, 1
	strb	w0, [x19]
	str	w2, [x15, x1, lsl 2]
	strb	w12, [x22, x1]
.L975:
	add	x12, x12, 1
	cmp	x12, 4
	bne	.L977
	b	.L978
	.size	flash_die_info_init, .-flash_die_info_init
	.section	.text.lpa_hash_init,"ax",@progbits
	.align	2
	.global	lpa_hash_init
	.type	lpa_hash_init, %function
lpa_hash_init:
	stp	x29, x30, [sp, -16]!
	mov	w2, 512
	mov	w1, 255
	adrp	x0, .LANCHOR104
	add	x29, sp, 0
	add	x0, x0, :lo12:.LANCHOR104
	bl	ftl_memset
	adrp	x0, .LANCHOR80
	mov	w1, 255
	ldp	x29, x30, [sp], 16
	ldrh	w2, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR72
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR106
	ldr	x0, [x0, #:lo12:.LANCHOR106]
	lsl	w2, w2, 2
	b	ftl_memset
	.size	lpa_hash_init, .-lpa_hash_init
	.section	.text.lpa_rebuild_hash,"ax",@progbits
	.align	2
	.global	lpa_rebuild_hash
	.type	lpa_rebuild_hash, %function
lpa_rebuild_hash:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR29
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	tbz	x0, 12, .L988
	adrp	x1, .LANCHOR124
	adrp	x0, .LC33
	mov	w3, 0
	mov	w2, 219
	add	x1, x1, :lo12:.LANCHOR124
	add	x0, x0, :lo12:.LC33
	bl	printf
.L988:
	adrp	x20, .LANCHOR80
	adrp	x22, .LANCHOR72
	adrp	x19, .LANCHOR104
	add	x19, x19, :lo12:.LANCHOR104
	mov	w2, 512
	mov	w1, 255
	mov	x0, x19
	bl	ftl_memset
	ldrh	w2, [x20, #:lo12:.LANCHOR80]
	adrp	x21, .LANCHOR106
	ldrb	w0, [x22, #:lo12:.LANCHOR72]
	mov	w1, 255
	add	x20, x20, :lo12:.LANCHOR80
	mul	w2, w2, w0
	ldr	x0, [x21, #:lo12:.LANCHOR106]
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR105
	ldrb	w3, [x22, #:lo12:.LANCHOR72]
	ldr	x5, [x21, #:lo12:.LANCHOR106]
	mov	w1, 0
	ldr	x4, [x0, #:lo12:.LANCHOR105]
.L989:
	ldrh	w0, [x20]
	mul	w0, w0, w3
	cmp	w1, w0, lsl 1
	blt	.L991
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L991:
	uxtw	x2, w1
	ldr	w0, [x4, x2, lsl 2]
	cmn	w0, #1
	beq	.L990
	and	x0, x0, 255
	ldrh	w6, [x19, x0, lsl 1]
	strh	w1, [x19, x0, lsl 1]
	strh	w6, [x5, x2, lsl 1]
.L990:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L989
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
	adrp	x1, .LANCHOR26
	add	x1, x1, :lo12:.LANCHOR26
	adrp	x0, .LANCHOR20
	mov	w4, 1
	ldrb	w3, [x1, 9]
	ldrh	w0, [x0, #:lo12:.LANCHOR20]
	mul	w0, w3, w0
	and	w2, w0, 65535
	strb	w2, [x19, 4]
	ubfx	x0, x2, 8, 8
	strb	w0, [x19, 5]
	adrp	x0, .LANCHOR34
	ldrb	w0, [x0, #:lo12:.LANCHOR34]
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
	adrp	x2, .LANCHOR17
	strb	w0, [x19, 3]
	mov	w0, 32
	strb	w0, [x19, 8]
	add	x2, x2, :lo12:.LANCHOR17
	ldrb	w0, [x1, 7]
	mov	x1, 0
	strb	w0, [x19, 9]
	adrp	x0, .LANCHOR15
	ldrb	w3, [x0, #:lo12:.LANCHOR15]
.L1000:
	cmp	w3, w1, uxtb
	bhi	.L1001
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1001:
	ldrb	w0, [x1, x2]
	add	x1, x1, 1
	ldrb	w5, [x19, 10]
	lsl	w0, w4, w0
	orr	w0, w0, w5
	strb	w0, [x19, 10]
	b	.L1000
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
	adrp	x22, .LANCHOR53
	stp	x19, x20, [sp, 16]
	ldr	x5, [x22, #:lo12:.LANCHOR53]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldr	w0, [x5, 32]
	cmp	w0, w1
	bls	.L1004
	ldr	w1, [x5, 36]
	add	w1, w1, w0, lsr 10
	and	w0, w0, 1023
	stp	w0, w1, [x5, 32]
.L1004:
	adrp	x25, .LANCHOR5
	ldr	w3, [x5, 36]
	ldr	x0, [x25, #:lo12:.LANCHOR5]
	ldr	w1, [x0, 568]
	ldr	w2, [x0, 12]
	add	w1, w1, 860160
	add	w1, w1, 3840
	cmp	w2, w1
	bhi	.L1005
	ldr	w1, [x0, 572]
	add	w1, w1, 32
	cmp	w3, w1
	bls	.L1003
.L1005:
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
.L1007:
	cmp	w10, w11
	bcc	.L1011
	ldrh	w0, [x5, 96]
	cmp	w0, w20
	bcs	.L1012
	strh	w20, [x5, 96]
.L1012:
	ldrh	w0, [x5, 98]
	cmp	w0, w26
	bcs	.L1013
	strh	w26, [x5, 98]
.L1013:
	udiv	w3, w3, w1
	adrp	x24, .LANCHOR29
	udiv	w4, w4, w2
	ldr	w0, [x24, #:lo12:.LANCHOR29]
	strh	w3, [x5, 88]
	strh	w4, [x5, 90]
	tbz	x0, 10, .L1014
	adrp	x0, .LC34
	and	w4, w4, 65535
	and	w3, w3, 65535
	add	x0, x0, :lo12:.LC34
	bl	printf
.L1014:
	ldr	w0, [x24, #:lo12:.LANCHOR29]
	adrp	x28, .LANCHOR125
	tbz	x0, 10, .L1015
	adrp	x0, .LANCHOR126
	ldrh	w6, [x28, #:lo12:.LANCHOR125]
	mov	w4, w26
	mov	w3, w20
	ldrh	w5, [x0, #:lo12:.LANCHOR126]
	mov	w2, w19
	adrp	x0, .LC35
	mov	w1, w27
	add	x0, x0, :lo12:.LC35
	bl	printf
.L1015:
	ldr	x0, [x25, #:lo12:.LANCHOR5]
	mov	w1, 255
	mov	w2, 128
	add	x0, x0, 264
	strh	wzr, [x0, -142]
	bl	ftl_memset
	sub	w0, w26, w19
	str	w0, [x29, 148]
	ldrh	w0, [x28, #:lo12:.LANCHOR125]
	ldr	w1, [x29, 148]
	cmp	w1, w0
	bgt	.L1016
	adrp	x1, .LANCHOR126
	sub	w0, w20, w27
	ldrh	w1, [x1, #:lo12:.LANCHOR126]
	cmp	w0, w1
	bgt	.L1016
.L1023:
	cbnz	w19, .L1017
.L1025:
	cbz	w27, .L1003
	ldr	x2, [x22, #:lo12:.LANCHOR53]
	ldr	x1, [x21, #:lo12:.LANCHOR3]
	ldrh	w5, [x23, #:lo12:.LANCHOR2]
	ldrh	w0, [x2, 134]
	add	x1, x1, x0, uxth 2
.L1030:
	cmp	w0, w5
	bcc	.L1032
	ldrh	w0, [x2, 74]
	add	w0, w27, w0
	strh	w0, [x2, 74]
	ldrh	w0, [x2, 96]
	cmp	w27, w0
	bcs	.L1003
	sub	w7, w0, w27
	strh	w7, [x2, 96]
.L1003:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L1011:
	ldrb	w0, [x8, 2]
	tbz	x0, 3, .L1008
	ldr	w0, [x8]
	ldrh	w6, [x8]
	ubfx	x0, x0, 11, 8
	and	w6, w6, 2047
.L1009:
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
	bne	.L1033
	b	.L1034
.L1008:
	tst	w0, 24
	bne	.L1010
	ldrh	w6, [x8]
	mov	w0, 65535
	and	w6, w6, 2047
	b	.L1009
.L1010:
	ldr	w0, [x8]
	ubfx	x0, x0, 11, 8
.L1033:
	cmp	w0, w19
	add	w2, w2, 1
	csel	w19, w0, w19, cc
	cmp	w0, w26
	add	w4, w4, w0
	csel	w0, w0, w26, hi
	and	w2, w2, 65535
	and	w19, w19, 65535
	and	w26, w0, 65535
.L1034:
	add	w10, w10, 1
	add	x8, x8, 4
	and	w10, w10, 65535
	b	.L1007
.L1016:
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	adrp	x25, .LANCHOR63
	stp	wzr, wzr, [x29, 152]
	ldrh	w26, [x0, 134]
	add	x0, x23, :lo12:.LANCHOR2
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR126
	add	x0, x0, :lo12:.LANCHOR126
	str	x0, [x29, 120]
	add	x0, x25, :lo12:.LANCHOR63
	str	x0, [x29, 136]
.L1019:
	ldr	x0, [x29, 128]
	ldrh	w0, [x0]
	cmp	w0, w26
	bls	.L1023
	uxtw	x25, w26
	ldr	x4, [x21, #:lo12:.LANCHOR3]
	lsl	x3, x25, 2
	add	x0, x4, x3
	ldrb	w0, [x0, 2]
	tst	w0, 192
	beq	.L1020
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L1020
	tbz	x0, 4, .L1021
	ldrh	w0, [x28, #:lo12:.LANCHOR125]
	ldr	w1, [x29, 148]
	cmp	w1, w0
	ble	.L1022
	ldr	w0, [x4, x3]
	add	w1, w19, 1
	ubfx	x0, x0, 11, 8
	cmp	w0, w1
	bgt	.L1022
	stp	x4, x3, [x29, 104]
	mov	w2, 1
	mov	w1, 0
	mov	w0, w26
	bl	gc_add_sblk
	ldr	w0, [x29, 156]
	ldp	x4, x3, [x29, 104]
	add	w0, w0, 1
	str	w0, [x29, 156]
	ldr	w0, [x24, #:lo12:.LANCHOR29]
	tbz	x0, 10, .L1022
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
	adrp	x0, .LC36
	ldrh	w3, [x1, x25, lsl 1]
	add	x0, x0, :lo12:.LC36
	ubfx	x2, x2, 5, 3
	mov	w1, w26
.L1057:
	bl	printf
.L1022:
	ldr	w0, [x29, 156]
	cmp	w0, 4
	ldr	w0, [x29, 152]
	ccmp	w0, 4, 2, ls
	bhi	.L1023
.L1020:
	add	w8, w26, 1
	and	w26, w8, 65535
	b	.L1019
.L1021:
	ldr	x1, [x29, 120]
	sub	w0, w20, w27
	ldrh	w1, [x1]
	cmp	w0, w1
	ble	.L1022
	ldrh	w0, [x4, x3]
	add	w1, w27, 1
	and	w0, w0, 2047
	cmp	w0, w1
	bgt	.L1022
	stp	x4, x3, [x29, 104]
	mov	w2, 1
	mov	w1, 0
	mov	w0, w26
	bl	gc_add_sblk
	ldr	w0, [x29, 152]
	ldp	x4, x3, [x29, 104]
	add	w0, w0, 1
	str	w0, [x29, 152]
	ldr	w0, [x24, #:lo12:.LANCHOR29]
	tbz	x0, 10, .L1022
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
	adrp	x0, .LC37
	ldrh	w3, [x1, x25, lsl 1]
	add	x0, x0, :lo12:.LC37
	ubfx	x2, x2, 5, 3
	mov	w1, w26
	b	.L1057
.L1017:
	ldr	x2, [x22, #:lo12:.LANCHOR53]
	ldr	x1, [x21, #:lo12:.LANCHOR3]
	ldrh	w5, [x23, #:lo12:.LANCHOR2]
	ldrh	w0, [x2, 134]
	add	x1, x1, x0, uxth 2
.L1026:
	cmp	w0, w5
	bcc	.L1028
	ldrh	w0, [x2, 72]
	add	w0, w19, w0
	strh	w0, [x2, 72]
	ldrh	w0, [x2, 98]
	cmp	w19, w0
	bcs	.L1025
	sub	w19, w0, w19
	strh	w19, [x2, 98]
	b	.L1025
.L1028:
	ldr	w3, [x1]
	ubfx	x4, x3, 11, 8
	cmp	w19, w4
	bhi	.L1027
	sub	w4, w4, w19
	bfi	w3, w4, 11, 8
	str	w3, [x1]
.L1027:
	add	w0, w0, 1
	add	x1, x1, 4
	and	w0, w0, 65535
	b	.L1026
.L1032:
	ldrh	w3, [x1]
	and	w4, w3, 2047
	cmp	w4, w27
	blt	.L1031
	sub	w4, w4, w27
	bfi	w3, w4, 0, 11
	strh	w3, [x1]
.L1031:
	add	w0, w0, 1
	add	x1, x1, 4
	and	w0, w0, 65535
	b	.L1030
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
	adrp	x25, .LANCHOR53
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
	ldr	x0, [x25, #:lo12:.LANCHOR53]
	strh	wzr, [x21, #:lo12:.LANCHOR84]
	strh	wzr, [x20, #:lo12:.LANCHOR86]
	strh	wzr, [x19, #:lo12:.LANCHOR82]
	strh	wzr, [x0, 146]
	ldrsh	w26, [x0, 134]
	add	x0, x27, :lo12:.LANCHOR2
	adrp	x27, .LC38
	add	x27, x27, :lo12:.LC38
	stp	x3, x2, [x29, 104]
	stp	x4, x5, [x29, 120]
	stp	x6, x7, [x29, 136]
	stp	x8, x10, [x29, 152]
	str	x0, [x29, 176]
.L1059:
	ldr	x0, [x29, 176]
	ldrh	w0, [x0]
	cmp	w26, w0
	blt	.L1075
	ldr	x0, [x25, #:lo12:.LANCHOR53]
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
.L1075:
	ldr	x4, [x28, #:lo12:.LANCHOR3]
	sxtw	x2, w26
	add	x4, x4, x2, lsl 2
	ldrb	w6, [x4, 3]
	cbz	w6, .L1076
	ldr	x0, [x29, 112]
	mov	w1, 0
	ldr	x7, [x25, #:lo12:.LANCHOR53]
	ldrb	w8, [x0, #:lo12:.LANCHOR72]
	ldr	x0, [x29, 104]
	ldrh	w10, [x0, #:lo12:.LANCHOR80]
	mov	w0, 0
.L1061:
	cmp	w1, w8
	blt	.L1064
	cbz	w0, .L1065
	mov	w1, 32768
	sdiv	w0, w1, w0
	sxth	w0, w0
.L1060:
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
	beq	.L1066
	adrp	x5, .LANCHOR5
	ldr	x5, [x5, #:lo12:.LANCHOR5]
	ldrh	w6, [x5, 16]
	cmp	w26, w6
	beq	.L1066
	ldrh	w6, [x5, 48]
	cmp	w26, w6
	beq	.L1066
	ldrh	w5, [x5, 80]
	cmp	w26, w5
	beq	.L1066
	cmp	w0, 64
	bne	.L1067
	ldr	x0, [x29, 128]
	add	x2, x21, :lo12:.LANCHOR84
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR75
.L1079:
	bl	_insert_data_list
.L1066:
	add	w3, w26, 1
	sxth	w26, w3
	b	.L1059
.L1064:
	asr	w5, w6, w1
	tbnz	x5, 0, .L1062
	add	w0, w10, w0
	sxth	w0, w0
.L1063:
	add	w1, w1, 1
	b	.L1061
.L1062:
	ldrh	w5, [x7, 146]
	add	w5, w5, 1
	strh	w5, [x7, 146]
	b	.L1063
.L1065:
	ldrb	w1, [x4, 2]
	mov	w5, -1
	orr	w1, w1, -32
	strb	w1, [x4, 2]
	adrp	x1, .LANCHOR4
	ldr	x1, [x1, #:lo12:.LANCHOR4]
	strh	w5, [x1, x2, lsl 1]
	b	.L1060
.L1076:
	ldr	w0, [x29, 188]
	b	.L1060
.L1067:
	cmp	w0, 96
	bne	.L1068
	ldr	x0, [x29, 136]
	add	x2, x19, :lo12:.LANCHOR82
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR76
	b	.L1079
.L1068:
	cmp	w0, 160
	bne	.L1069
	ldr	x0, [x29, 120]
	add	x2, x20, :lo12:.LANCHOR86
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR74
	b	.L1079
.L1069:
	cbnz	w0, .L1066
	adrp	x0, .LANCHOR4
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	ldrh	w2, [x0, x2, lsl 1]
	cbz	w2, .L1070
	str	x4, [x29, 96]
	mov	w1, w26
	mov	x0, x27
	bl	printf
	ldr	x4, [x29, 96]
	ldrb	w0, [x4, 2]
	tbz	x0, 4, .L1071
	mov	w1, 5
.L1078:
	bfi	w0, w1, 5, 3
	strb	w0, [x4, 2]
	mov	w2, 0
	mov	w1, 1
	mov	w0, w26
	bl	gc_add_sblk
	b	.L1066
.L1071:
	mov	w1, 2
	b	.L1078
.L1070:
	ands	w1, w1, 24
	bne	.L1073
	ldr	x0, [x29, 160]
	add	x2, x24, :lo12:.LANCHOR89
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR90
.L1080:
	bl	_insert_free_list
	b	.L1066
.L1073:
	cmp	w1, 16
	bne	.L1074
	ldr	x0, [x29, 152]
	add	x2, x23, :lo12:.LANCHOR91
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR92
	b	.L1080
.L1074:
	ldr	x0, [x29, 144]
	add	x2, x22, :lo12:.LANCHOR93
	mov	w1, w26
	add	x0, x0, :lo12:.LANCHOR94
	b	.L1080
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
	adrp	x21, .LC31
	adrp	x23, .LANCHOR80
	mov	w22, w1
	add	x23, x23, :lo12:.LANCHOR80
	add	x20, x20, :lo12:.LANCHOR72
	add	x21, x21, :lo12:.LC31
	stp	x25, x26, [sp, 64]
.L1082:
.L1085:
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
	beq	.L1086
	ldrb	w0, [x20]
	mul	w0, w1, w0
	and	w0, w0, 65535
.L1083:
	ldrb	w2, [x20]
	adrp	x26, .LANCHOR4
	strh	w0, [x19, 12]
	ubfiz	x25, x24, 1, 16
	mul	w2, w2, w1
	adrp	x1, .LANCHOR105
	ldr	x3, [x1, #:lo12:.LANCHOR105]
	mov	w1, 255
	lsl	w2, w2, 2
	add	x0, x3, x0, uxth 2
	bl	ftl_memset
	ldr	x0, [x26, #:lo12:.LANCHOR4]
	ldrh	w1, [x19, 6]
	strh	w1, [x0, x25]
	ldrb	w0, [x19, 9]
	cbnz	w0, .L1081
	mov	w1, w24
	mov	x0, x21
	bl	printf
	ldr	x0, [x26, #:lo12:.LANCHOR4]
	mov	w1, -1
	strh	w1, [x0, x25]
	mov	w0, 7
	strb	w0, [x19, 4]
	b	.L1085
.L1086:
	mov	w0, 0
	b	.L1083
.L1081:
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
	adrp	x20, .LANCHOR127
	stp	x21, x22, [sp, 32]
	ldrh	w0, [x20, #:lo12:.LANCHOR127]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w0, 128
	stp	x27, x28, [sp, 80]
	bls	.L1089
	adrp	x1, .LANCHOR128
	adrp	x0, .LC0
	mov	w2, 74
	add	x1, x1, :lo12:.LANCHOR128
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1090:
	b	.L1090
.L1089:
	add	x23, x29, 112
	mov	w2, 256
	mov	w1, 0
	mov	x0, x23
	bl	ftl_memset
	adrp	x24, .LANCHOR53
	adrp	x0, .LANCHOR96
	mov	w2, 21
	ldr	x5, [x24, #:lo12:.LANCHOR53]
	ldrh	w8, [x0, #:lo12:.LANCHOR96]
	ldrh	w11, [x20, #:lo12:.LANCHOR127]
	add	x4, x5, 704
	sub	w0, w2, w8
	mov	w2, 1
	ldrh	w1, [x5, 698]
	lsl	w2, w2, w0
	adrp	x0, .LANCHOR95
	add	x1, x1, 176
	sub	w2, w2, #1
	ldrb	w10, [x0, #:lo12:.LANCHOR95]
	add	x1, x5, x1, lsl 2
	mov	x27, x0
.L1091:
	cmp	x4, x1
	bne	.L1095
	adrp	x1, .LANCHOR72
	adrp	x0, .LANCHOR80
	add	x20, x20, :lo12:.LANCHOR127
	add	x27, x27, :lo12:.LANCHOR95
	ldrh	w2, [x0, #:lo12:.LANCHOR80]
	add	x26, x1, :lo12:.LANCHOR72
	ldrb	w21, [x1, #:lo12:.LANCHOR72]
	add	x25, x0, :lo12:.LANCHOR80
	mov	w28, 0
	mov	w19, 0
	mul	w21, w21, w2
	mov	w2, 65535
	and	w21, w21, 65535
.L1096:
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L1101
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 368
	ret
.L1095:
	ldr	w0, [x4]
	add	x6, x5, 416
	mov	x3, 0
	lsr	w0, w0, w8
	and	w0, w0, w2
	udiv	w0, w0, w10
	and	w0, w0, 65535
.L1092:
	cmp	w11, w3, uxth
	bhi	.L1094
	add	x4, x4, 4
	b	.L1091
.L1094:
	ldrh	w7, [x6]
	cmp	w7, w0
	bne	.L1093
	ldrh	w7, [x23, x3, lsl 1]
	add	w7, w7, 1
	strh	w7, [x23, x3, lsl 1]
.L1093:
	add	x3, x3, 1
	add	x6, x6, 2
	b	.L1092
.L1101:
	ldr	x1, [x24, #:lo12:.LANCHOR53]
	sxtw	x22, w19
	add	x0, x22, 208
	ldrb	w3, [x27]
	ldrh	w0, [x1, x0, lsl 1]
	ldrh	w1, [x1, 692]
	sdiv	w1, w1, w3
	cmp	w1, w0
	bne	.L1097
	ldrb	w1, [x26]
	ldrh	w3, [x25]
	mul	w1, w1, w3
	strh	w1, [x23, x22, lsl 1]
.L1097:
	ldrh	w1, [x23, x22, lsl 1]
	cmp	w21, w1
	bls	.L1098
	cbnz	w1, .L1102
.L1100:
	cmp	w0, w2
	beq	.L1099
	str	w2, [x29, 108]
	bl	ftl_free_sblk
	ldr	x0, [x24, #:lo12:.LANCHOR53]
	add	x22, x22, 208
	mov	w1, -1
	ldr	w2, [x29, 108]
	strh	w1, [x0, x22, lsl 1]
	ldrh	w1, [x0, 688]
	sub	w1, w1, #1
	strh	w1, [x0, 688]
	b	.L1099
.L1098:
	cbz	w1, .L1100
.L1099:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1096
.L1102:
	mov	w28, w19
	mov	w21, w1
	b	.L1099
	.size	pm_free_sblk, .-pm_free_sblk
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
	mov	w2, 2048
	mov	w1, 0
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR12
	ldr	x0, [x19, #:lo12:.LANCHOR12]
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR12]
	mov	w1, 21321
	movk	w1, 0x5359, lsl 16
	mov	w2, 32
	add	x0, x0, 80
	str	w1, [x0, -80]
	mov	w1, 2032
	str	w1, [x0, -72]
	mov	w1, 1
	strh	w1, [x0, -64]
	adrp	x1, .LANCHOR129
	add	x1, x1, :lo12:.LANCHOR129
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR12]
	mov	w2, 32
	ldr	x19, [sp, 16]
	adrp	x1, .LANCHOR26
	ldp	x29, x30, [sp], 32
	add	x1, x1, :lo12:.LANCHOR26
	add	x0, x0, 48
	b	ftl_memcpy
	.size	flash_into_data_init, .-flash_into_data_init
	.section	.text.ftl_memcpy32,"ax",@progbits
	.align	2
	.global	ftl_memcpy32
	.type	ftl_memcpy32, %function
ftl_memcpy32:
	mov	x3, 0
.L1108:
	cmp	w2, w3
	bhi	.L1109
	ret
.L1109:
	ldr	w4, [x1, x3, lsl 2]
	str	w4, [x0, x3, lsl 2]
	add	x3, x3, 1
	b	.L1108
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
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR14
	mov	w2, 6
	add	x29, sp, 0
	strb	w2, [x1, #:lo12:.LANCHOR14]
	adrp	x2, .LANCHOR13
	str	wzr, [x29, 24]
	str	x0, [x2, #:lo12:.LANCHOR13]
	mov	w2, 12336
	ldr	w3, [x0, 352]
	movk	w2, 0x5638, lsl 16
	cmp	w3, w2
	bne	.L1114
	mov	w2, 8
	strb	w2, [x1, #:lo12:.LANCHOR14]
.L1114:
	ldr	w3, [x0, 128]
	mov	w2, 12336
	movk	w2, 0x5639, lsl 16
	cmp	w3, w2
	bne	.L1115
	mov	w2, 9
	strb	w2, [x1, #:lo12:.LANCHOR14]
.L1115:
	ldrb	w1, [x1, #:lo12:.LANCHOR14]
	cmp	w1, 9
	adrp	x1, .LANCHOR35
	bne	.L1116
	mov	w2, 1
	strb	w2, [x1, #:lo12:.LANCHOR35]
	ldr	w1, [x29, 24]
	orr	w1, w1, 256
	str	w1, [x29, 24]
	ldr	w1, [x29, 24]
	str	w1, [x0]
	str	wzr, [x0, 520]
	mov	w1, 4225
	str	w1, [x0, 4]
	mov	w1, 8321
	str	w1, [x0, 8]
	mov	w1, 4099
	movk	w1, 0x10, lsl 16
	str	w1, [x0, 80]
	mov	w1, 38
	str	w1, [x0, 84]
	mov	w1, 39
	str	w1, [x0, 84]
.L1117:
	adrp	x0, .LANCHOR36
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR36]
	adrp	x0, .LANCHOR38
	strh	wzr, [x0, #:lo12:.LANCHOR38]
	adrp	x0, .LANCHOR34
	strb	wzr, [x0, #:lo12:.LANCHOR34]
	ldp	x29, x30, [sp], 32
	ret
.L1116:
	strb	wzr, [x1, #:lo12:.LANCHOR35]
	ldr	w1, [x29, 24]
	orr	w1, w1, 256
	str	w1, [x29, 24]
	ldr	w1, [x29, 24]
	str	w1, [x0]
	str	wzr, [x0, 336]
	mov	w1, 4225
	str	w1, [x0, 4]
	mov	w1, 8321
	str	w1, [x0, 344]
	mov	w1, 4099
	movk	w1, 0x10, lsl 16
	str	w1, [x0, 304]
	mov	w1, 38
	str	w1, [x0, 308]
	mov	w1, 39
	str	w1, [x0, 308]
	mov	w0, 2048
	bl	ftl_malloc
	adrp	x1, .LANCHOR37
	str	x0, [x1, #:lo12:.LANCHOR37]
	b	.L1117
	.size	nandc_init, .-nandc_init
	.section	.text.buf_init,"ax",@progbits
	.align	2
	.global	buf_init
	.type	buf_init, %function
buf_init:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR43
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	x19, x0, :lo12:.LANCHOR43
	stp	x21, x22, [sp, 32]
	mov	x20, x0
	adrp	x22, .LANCHOR52
	add	x22, x22, :lo12:.LANCHOR52
	mov	w21, 0
.L1120:
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
	bne	.L1120
	add	x0, x20, :lo12:.LANCHOR43
	mov	w1, -1
	strb	w1, [x0, 1984]
	adrp	x0, .LANCHOR44
	strb	wzr, [x0, #:lo12:.LANCHOR44]
	adrp	x0, .LANCHOR45
	ldp	x19, x20, [sp, 16]
	strb	w21, [x0, #:lo12:.LANCHOR45]
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
	adrp	x0, .LANCHOR130
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR63
	add	x19, x20, :lo12:.LANCHOR63
	strb	wzr, [x0, #:lo12:.LANCHOR130]
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
	adrp	x1, .LANCHOR131
	str	x0, [x1, #:lo12:.LANCHOR131]
	ldrb	w1, [x19, #:lo12:.LANCHOR72]
	ldrh	w0, [x20, #:lo12:.LANCHOR71]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR132
	str	x0, [x1, #:lo12:.LANCHOR132]
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
	adrp	x1, .LANCHOR133
	ldp	x19, x20, [sp, 16]
	str	x0, [x1, #:lo12:.LANCHOR133]
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
.L1127:
	cmp	w1, w3
	bhi	.L1128
	ret
.L1128:
	lsr	w2, w0, 2
	ldrb	w5, [x4, x3]
	add	w2, w2, w0, lsl 5
	add	x3, x3, 1
	add	w2, w2, w5
	eor	w0, w0, w2
	b	.L1127
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
	adrp	x21, .LC40
	stp	x23, x24, [sp, 48]
	mov	x22, x1
	stp	x25, x26, [sp, 64]
	adrp	x23, .LC39
	mov	x26, x0
	mov	w24, w2
	uxtw	x25, w3
	add	x23, x23, :lo12:.LC39
	add	x21, x21, :lo12:.LC40
	stp	x19, x20, [sp, 16]
	str	x27, [sp, 80]
	mov	x19, 0
	mov	w20, 0
	adrp	x27, .LC41
.L1135:
	cmp	x25, x19
	bne	.L1141
	ldp	x19, x20, [sp, 16]
	adrp	x1, .LC41
	ldp	x21, x22, [sp, 32]
	add	x1, x1, :lo12:.LC41
	ldp	x23, x24, [sp, 48]
	adrp	x0, .LC42
	ldp	x25, x26, [sp, 64]
	add	x0, x0, :lo12:.LC42
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L1141:
	cbnz	w20, .L1136
	mov	w2, w19
	mov	x1, x26
	mov	x0, x23
	bl	printf
.L1136:
	cmp	w24, 4
	bne	.L1137
	ldr	w1, [x22, x19, lsl 2]
.L1143:
	mov	x0, x21
	add	w20, w20, 1
	bl	printf
	cmp	w20, 15
	bls	.L1140
	mov	w20, 0
	add	x1, x27, :lo12:.LC41
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	printf
.L1140:
	add	x19, x19, 1
	b	.L1135
.L1137:
	cmp	w24, 2
	bne	.L1139
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L1143
.L1139:
	ldrb	w1, [x22, x19]
	b	.L1143
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
	adrp	x0, .LANCHOR12
	stp	x19, x20, [sp, 16]
	ldr	x28, [x0, #:lo12:.LANCHOR12]
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
	bne	.L1145
	mov	w0, -89
	strb	w0, [x28, 128]
	adrp	x0, .LANCHOR134+17
	mov	w1, -9
	strb	w1, [x0, #:lo12:.LANCHOR134+17]
.L1200:
	mov	w0, 7
	b	.L1235
.L1145:
	ldr	w3, [x29, 140]
	cmp	w3, 3
	bne	.L1147
	mov	x6, 0
.L1148:
	sub	w0, w6, #80
	strb	w0, [x22, x6]
	add	x6, x6, 1
	cmp	x6, 8
	bne	.L1148
	stp	w6, w6, [x29, 132]
.L1146:
	ldr	w0, [x29, 140]
	sub	w0, w0, #1
	cmp	w0, 1
	bhi	.L1153
	adrp	x7, .LANCHOR15
	adrp	x11, .LANCHOR17
	add	x24, x7, :lo12:.LANCHOR15
	add	x25, x11, :lo12:.LANCHOR17
	mov	w20, 0
	mov	w26, 55
.L1154:
	ldrb	w0, [x24]
	cmp	w0, w20
	bhi	.L1160
.L1161:
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
.L1147:
	ldr	w3, [x29, 140]
	cmp	w3, 4
	bne	.L1149
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
.L1236:
	str	w0, [x29, 136]
	b	.L1146
.L1149:
	ldr	w0, [x29, 140]
	cmp	w0, 5
	bne	.L1150
	mov	w0, 56
	strb	w0, [x28, 128]
	mov	w0, 57
	strb	w0, [x28, 129]
	mov	w0, 58
	strb	w0, [x28, 130]
	mov	w0, 59
	strb	w0, [x28, 131]
	mov	w0, 8
.L1235:
	str	w0, [x29, 132]
	mov	w0, 4
	b	.L1236
.L1150:
	ldr	w0, [x29, 140]
	cmp	w0, 6
	bne	.L1151
	mov	w0, 14
	strb	w0, [x28, 128]
	mov	w0, 15
	strb	w0, [x28, 129]
	mov	w0, 16
	strb	w0, [x28, 130]
	mov	w0, 17
	strb	w0, [x28, 131]
	mov	w0, 12
	b	.L1235
.L1151:
	ldr	w0, [x29, 140]
	cmp	w0, 7
	bne	.L1200
	mov	x0, 0
.L1152:
	sub	w1, w0, #80
	strb	w1, [x22, x0]
	add	x0, x0, 1
	cmp	x0, 8
	bne	.L1152
	mov	w0, -44
	strb	w0, [x28, 136]
	mov	w0, -43
	strb	w0, [x28, 137]
	mov	w0, 12
	str	w0, [x29, 132]
	mov	w0, 10
	b	.L1236
.L1160:
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
.L1155:
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
	bhi	.L1155
	adrp	x3, .LANCHOR134
	add	x3, x3, :lo12:.LANCHOR134
	mov	x0, 0
.L1158:
	add	x15, x19, x0
	add	x14, x3, x0
	mov	x1, 1
.L1157:
	lsl	x4, x1, 2
	lsl	x16, x1, 3
	ldrb	w17, [x19, x0]
	add	x1, x1, 1
	cmp	x1, 7
	ldrb	w4, [x14, x4]
	add	w4, w4, w17
	strb	w4, [x15, x16]
	bne	.L1157
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L1158
	add	w5, w20, 1
	strb	wzr, [x19, 16]
	strb	wzr, [x19, 24]
	and	w20, w5, 255
	strb	wzr, [x19, 32]
	strb	wzr, [x19, 40]
	strb	wzr, [x19, 48]
	strb	wzr, [x19, 41]
	strb	wzr, [x19, 49]
	b	.L1154
.L1153:
	ldr	w0, [x29, 140]
	sub	w0, w0, #3
	cmp	w0, 4
	bhi	.L1161
	ldp	w0, w1, [x29, 132]
	adrp	x19, .LANCHOR15
	add	x19, x19, :lo12:.LANCHOR15
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
.L1162:
	ldrb	w0, [x19]
	ldr	w1, [x29, 128]
	cmp	w0, w1
	bls	.L1161
	ldr	w1, [x29, 128]
	adrp	x0, .LANCHOR17
	add	x0, x0, :lo12:.LANCHOR17
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
	bne	.L1163
	mov	w0, 64
	str	w23, [x27, 2052]
	str	w0, [x27, 2048]
	mov	w0, 204
.L1237:
	str	w0, [x27, 2052]
	mov	w0, 77
	b	.L1238
.L1163:
	cmp	w20, 1
	bhi	.L1165
	ldrb	w0, [x28, 128]
	str	w0, [x27, 2052]
	mov	w0, 82
.L1238:
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
	bne	.L1166
	mov	w0, 31
	str	w0, [x27, 2052]
.L1167:
	mov	w23, 2
	str	w23, [x27, 2052]
	str	wzr, [x27, 2052]
	mov	w0, 48
	str	w0, [x27, 2056]
	bl	nandc_wait_flash_ready
	cmp	w20, 1
	bls	.L1201
	ldr	w0, [x29, 140]
	cmp	w0, 7
	mov	w0, 32
	csel	w23, w23, w0, ne
.L1168:
	adrp	x3, .LANCHOR135
	mov	x1, 0
	ldr	x0, [x3, #:lo12:.LANCHOR135]
.L1169:
	ldr	w2, [x27, 2048]
	strb	w2, [x0, x1]
	add	x1, x1, 1
	cmp	w23, w1, uxtb
	bhi	.L1169
	ldr	w1, [x29, 140]
	cmp	w1, 7
	bne	.L1170
	mov	w1, 0
.L1172:
	ldrb	w2, [x0]
	cmp	w2, 12
	beq	.L1171
	ldrb	w2, [x0, 1]
	cmp	w2, 10
	beq	.L1171
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1172
.L1173:
	adrp	x0, .LC43
	mov	w1, 0
	add	x0, x0, :lo12:.LC43
	bl	printf
.L1175:
	b	.L1175
.L1165:
	mov	w0, 174
	str	w0, [x27, 2052]
	str	wzr, [x27, 2048]
	mov	w0, 176
	b	.L1237
.L1166:
	str	wzr, [x27, 2052]
	b	.L1167
.L1201:
	mov	w23, 16
	b	.L1168
.L1171:
	cmp	w1, 6
	bhi	.L1173
.L1174:
	ldr	x2, [x3, #:lo12:.LANCHOR135]
	mov	x0, 0
.L1179:
	ldr	w1, [x29, 120]
	cmp	w1, w0
	bgt	.L1180
	ldr	x1, [x3, #:lo12:.LANCHOR135]
	mov	w16, 8
	add	x3, x1, x21
.L1182:
	mov	x0, 0
.L1181:
	ldr	w17, [x3, x0, lsl 2]
	ldr	w4, [x29, 124]
	mvn	w17, w17
	str	w17, [x3, x0, lsl 2]
	add	x0, x0, 1
	cmp	w4, w0
	bgt	.L1181
	add	x3, x3, x22, uxtw 2
	subs	w16, w16, #1
	bne	.L1182
	mov	x17, x1
	mov	w23, 0
	mov	w26, 1
.L1183:
	mov	w3, 0
	mov	w0, 0
.L1187:
	mov	x25, x17
	lsl	w16, w26, w0
	mov	w24, 16
	mov	w30, 0
.L1185:
	ldr	w4, [x25]
	add	x25, x25, x21
	bics	wzr, w16, w4
	cinc	w30, w30, eq
	subs	w24, w24, #1
	bne	.L1185
	cmp	w30, 9
	orr	w16, w3, w16
	add	w0, w0, 1
	csel	w3, w16, w3, cs
	cmp	w0, 32
	bne	.L1187
	ldr	w0, [x29, 124]
	add	w23, w23, 1
	str	w3, [x17], 4
	cmp	w0, w23
	bgt	.L1183
	mov	x0, 0
	mov	w3, 0
.L1190:
	ldr	w16, [x1, x0]
	add	x0, x0, 4
	cmp	w16, 0
	cinc	w3, w3, eq
	cmp	x0, 32
	bne	.L1190
	cmp	w3, 7
	ble	.L1191
	mov	w3, 1024
	mov	w2, 1
	adrp	x0, .LC44
	add	x0, x0, :lo12:.LC44
	bl	rknand_print_hex
	adrp	x0, .LC43
	mov	w1, 0
	add	x0, x0, :lo12:.LC43
	bl	printf
.L1192:
	b	.L1192
.L1170:
	ldr	w1, [x29, 140]
	cmp	w1, 6
	bne	.L1174
	mov	x1, 0
.L1176:
	ldrb	w2, [x0, x1]
	cmp	w2, 12
	beq	.L1174
	add	x2, x0, x1
	ldrb	w2, [x2, 8]
	cmp	w2, 4
	beq	.L1174
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L1176
	adrp	x0, .LC43
	mov	w1, 0
	add	x0, x0, :lo12:.LC43
	bl	printf
.L1178:
	b	.L1178
.L1180:
	ldr	w1, [x27, 2048]
	strb	w1, [x2, x0]
	add	x0, x0, 1
	b	.L1179
.L1191:
	ldr	w0, [x29, 140]
	cmp	w0, 6
	beq	.L1203
	cmp	w0, 7
	mov	x1, 10
	mov	x0, 8
	csel	x0, x0, x1, ne
.L1193:
	ldr	x10, [x29, 104]
	mov	w3, 0
.L1194:
	mov	x1, 0
.L1195:
	ldrb	w16, [x2, x1]
	ldr	w4, [x29, 136]
	strb	w16, [x10, x1]
	add	x1, x1, 1
	cmp	w4, w1, uxtb
	bhi	.L1195
	ldr	x1, [x29, 96]
	add	w3, w3, 1
	add	x10, x10, x0
	add	x2, x2, x1
	ldr	w1, [x29, 132]
	cmp	w1, w3
	bgt	.L1194
	mov	w23, 255
	str	w23, [x27, 2056]
	bl	nandc_wait_flash_ready
	cmp	w20, 1
	bhi	.L1197
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
.L1239:
	str	w0, [x27, 2056]
	bl	nandc_wait_flash_ready
	ldr	w0, [x29, 128]
	add	w11, w0, 1
	and	w0, w11, 255
	str	w0, [x29, 128]
	b	.L1162
.L1203:
	mov	x0, 4
	b	.L1193
.L1197:
	mov	w0, 56
	b	.L1239
	.size	hynix_get_read_retry_default, .-hynix_get_read_retry_default
	.section	.text.flash_get_read_retry_tbl,"ax",@progbits
	.align	2
	.global	flash_get_read_retry_tbl
	.type	flash_get_read_retry_tbl, %function
flash_get_read_retry_tbl:
	adrp	x0, .LANCHOR26+19
	ldrb	w0, [x0, #:lo12:.LANCHOR26+19]
	sub	w1, w0, #1
	and	w1, w1, 255
	cmp	w1, 6
	bhi	.L1240
	b	hynix_get_read_retry_default
.L1240:
	ret
	.size	flash_get_read_retry_tbl, .-flash_get_read_retry_tbl
	.section	.text.nandc_xfer_done,"ax",@progbits
	.align	2
	.global	nandc_xfer_done
	.type	nandc_xfer_done, %function
nandc_xfer_done:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR14
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR13
	ldrb	w0, [x0, #:lo12:.LANCHOR14]
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	cmp	w0, 9
	ldr	x20, [x19, #:lo12:.LANCHOR13]
	bne	.L1243
	ldr	w0, [x20, 16]
	mov	w21, 0
	str	w0, [x29, 64]
	ldr	w0, [x20, 48]
	tbnz	x0, 1, .L1244
	adrp	x22, .LC47
	adrp	x23, .LC46
	add	x22, x22, :lo12:.LC47
	add	x23, x23, :lo12:.LC46
.L1245:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1248
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 16]
	str	w0, [x29, 64]
	bne	.L1245
	ldr	w2, [x29, 64]
	mov	w1, w21
	ldr	w3, [x20, 64]
	mov	x0, x22
	ubfx	x3, x3, 16, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR13]
	mov	w3, 256
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1245
.L1244:
	adrp	x22, .LC45
	adrp	x23, .LC46
	add	x22, x22, :lo12:.LC45
	add	x23, x23, :lo12:.LC46
.L1246:
	ldr	w1, [x20, 64]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 6
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	blt	.L1250
.L1248:
	adrp	x0, .LANCHOR37+32
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	str	wzr, [x0, #:lo12:.LANCHOR37+32]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	ret
.L1250:
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1247
	ldr	w0, [x29, 72]
	tbnz	x0, 17, .L1248
.L1247:
	add	w21, w21, 1
	tst	x21, 16777215
	bne	.L1246
	ldr	w2, [x20, 64]
	mov	w1, w21
	ldr	w3, [x29, 64]
	mov	x0, x22
	ubfx	x2, x2, 16, 5
	ubfx	x3, x3, 22, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR13]
	mov	w3, 256
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1246
.L1243:
	ldr	w0, [x20, 8]
	mov	w21, 0
	str	w0, [x29, 64]
	ldr	w0, [x20, 16]
	tbnz	x0, 1, .L1254
	adrp	x22, .LC47
	adrp	x23, .LC46
	add	x22, x22, :lo12:.LC47
	add	x23, x23, :lo12:.LC46
.L1255:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1248
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 8]
	str	w0, [x29, 64]
	bne	.L1255
	ldr	w2, [x29, 64]
	mov	w1, w21
	ldr	w3, [x20, 28]
	mov	x0, x22
	ubfx	x3, x3, 16, 5
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR13]
	mov	w3, 256
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1255
.L1254:
	adrp	x22, .LC45
	adrp	x23, .LC46
	add	x22, x22, :lo12:.LC45
	add	x23, x23, :lo12:.LC46
.L1256:
	ldr	w1, [x20, 28]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 5
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L1248
	ldr	x0, [x19, #:lo12:.LANCHOR13]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1257
	ldr	w0, [x29, 72]
	tbz	x0, 17, .L1257
	ldr	w1, [x29, 72]
	adrp	x0, .LC48
	add	x0, x0, :lo12:.LC48
	bl	printf
	b	.L1248
.L1257:
	add	w21, w21, 1
	tst	x21, 16777215
	bne	.L1256
	ldr	w2, [x20, 28]
	mov	w1, w21
	ldr	w3, [x29, 64]
	mov	x0, x22
	ubfx	x2, x2, 16, 5
	ubfx	x3, x3, 22, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR13]
	mov	w3, 256
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1256
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
	and	w22, w1, 255
	mov	x21, x3
	mov	w1, w19
	mov	x3, x4
	mov	x2, x21
	mov	w0, w22
	mov	x20, x4
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	cbnz	w22, .L1295
	adrp	x0, .LANCHOR14
	ldrb	w0, [x0, #:lo12:.LANCHOR14]
	cmp	w0, 9
	bne	.L1279
	adrp	x1, .LANCHOR13
	lsr	w19, w19, 2
	mov	x20, x1
	mov	w3, 1
	ldr	x5, [x1, #:lo12:.LANCHOR13]
	mov	w2, 0
	mov	w0, 0
.L1280:
	cmp	w2, w19
	bcc	.L1284
	ldr	w19, [x5]
	cmp	w3, 0
	mov	w1, 512
	csel	w0, w0, w1, eq
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1278
	mov	w1, w19
	adrp	x0, .LC49
	add	x0, x0, :lo12:.LC49
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR13]
	orr	w19, w19, 131072
.L1308:
	str	w19, [x0]
	mov	w0, -1
.L1278:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1284:
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
	tbnz	x1, 2, .L1297
	ldr	w1, [x29, 56]
	tbnz	x1, 18, .L1297
	ldr	w4, [x29, 56]
	ldr	w1, [x29, 56]
	ubfx	x4, x4, 3, 7
	ubfx	x1, x1, 19, 7
	cmp	w4, w1
	ldr	w1, [x29, 56]
	ble	.L1282
	ubfx	x1, x1, 3, 7
.L1283:
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1281:
	add	w2, w2, 1
	b	.L1280
.L1282:
	ubfx	x1, x1, 19, 7
	b	.L1283
.L1297:
	mov	w0, -1
	b	.L1281
.L1279:
	adrp	x0, .LANCHOR34
	lsr	w4, w19, 1
	mov	w3, 64
	mov	w1, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR34]
	mov	w2, 0
	adrp	x6, .LANCHOR37
	cmp	w0, 25
	mov	w0, 128
	csel	w3, w3, w0, cc
	mov	w0, 0
.L1287:
	add	w5, w3, w0
	cmp	w2, w4
	bcc	.L1288
	adrp	x22, .LANCHOR13
	lsr	w19, w19, 2
	mov	w3, 0
	mov	w0, 0
	ldr	x4, [x22, #:lo12:.LANCHOR13]
.L1289:
	cmp	w3, w19
	bcc	.L1293
	str	wzr, [x4, 16]
	cmn	w0, #1
	beq	.L1294
	ldr	w1, [x20]
	cmn	w1, #1
	bne	.L1294
	ldr	w1, [x20, 4]
	cmn	w1, #1
	bne	.L1294
	ldr	w1, [x21]
	cmn	w1, #1
	mov	w1, 512
	csel	w0, w0, w1, ne
.L1294:
	ldr	w19, [x4]
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1278
	mov	w1, w19
	adrp	x0, .LC50
	add	x0, x0, :lo12:.LC50
	bl	printf
	orr	w19, w19, 131072
	ldr	x0, [x22, #:lo12:.LANCHOR13]
	b	.L1308
.L1288:
	ldr	x7, [x6, #:lo12:.LANCHOR37]
	and	x0, x0, 4294967292
	ldr	w0, [x7, x0]
	lsl	w7, w2, 2
	add	w2, w2, 1
	strb	w0, [x20, x7]
	lsr	w7, w0, 8
	strb	w7, [x20, w1, uxtw]
	add	w7, w1, 1
	lsr	w8, w0, 16
	lsr	w0, w0, 24
	strb	w8, [x20, x7]
	add	w7, w1, 2
	add	w1, w1, 4
	strb	w0, [x20, x7]
	mov	w0, w5
	b	.L1287
.L1293:
	uxtw	x1, w3
	add	x1, x1, 8
	ldr	w1, [x4, x1, lsl 2]
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	tbnz	x1, 2, .L1300
	ldr	w1, [x29, 56]
	tbnz	x1, 15, .L1300
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
	bls	.L1291
	ubfx	x2, x1, 3, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 27, 1
.L1307:
	orr	w1, w2, w1, lsl 5
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1290:
	add	w3, w3, 1
	b	.L1289
.L1291:
	ubfx	x2, x1, 16, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 29, 1
	b	.L1307
.L1300:
	mov	w0, -1
	b	.L1290
.L1295:
	mov	w0, 0
	b	.L1278
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
	adrp	x0, .LANCHOR29
	stp	x25, x26, [sp, 64]
	mov	w24, w4
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	mov	x25, x2
	mov	x26, x3
	and	w20, w1, 2097151
	ubfx	x23, x22, 24, 2
	tbz	x0, 4, .L1310
	mov	w3, w1
	adrp	x0, .LC51
	mov	w2, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC51
	bl	printf
.L1310:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	nandc_cs
	adrp	x6, .LANCHOR41
	cbnz	w23, .L1311
	mov	w0, w21
	bl	zftl_flash_enter_slc_mode
.L1312:
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
	ldr	x0, [x6, #:lo12:.LANCHOR41]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1314
	cbz	w23, .L1314
	add	w20, w20, w20, lsl 1
	sub	w0, w20, #1
	add	w0, w0, w23
.L1323:
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
.L1311:
	ldr	x0, [x6, #:lo12:.LANCHOR41]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1313
	sxtw	x0, w21
	add	x0, x0, 8
	add	x0, x19, x0, lsl 8
	str	w23, [x0, 8]
	b	.L1312
.L1313:
	mov	w0, w21
	bl	zftl_flash_exit_slc_mode
	b	.L1312
.L1314:
	mov	w0, w20
	b	.L1323
	.size	flash_read_page, .-flash_read_page
	.section	.text.micron_read_retrial,"ax",@progbits
	.align	2
	.global	micron_read_retrial
	.type	micron_read_retrial, %function
micron_read_retrial:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	and	w25, w0, 255
	adrp	x0, .LANCHOR34
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	mov	x26, x3
	stp	x23, x24, [sp, 48]
	mov	w24, w2
	stp	x27, x28, [sp, 80]
	mov	w28, w5
	ldrb	w21, [x0, #:lo12:.LANCHOR34]
	mov	x27, x4
	bl	nandc_wait_flash_ready
	and	x20, x25, 255
	adrp	x0, .LANCHOR13
	adrp	x5, .LANCHOR137
	add	w21, w21, w21, lsl 1
	add	x5, x5, :lo12:.LANCHOR137
	ldr	x6, [x0, #:lo12:.LANCHOR13]
	asr	w21, w21, 2
	mov	w23, 0
	mov	w19, -1
	mov	w8, 239
	mov	w10, 137
	add	x22, x6, x20, lsl 8
.L1325:
	ldrb	w0, [x5]
	cmp	w23, w0
	bcc	.L1329
.L1328:
	add	x6, x6, x20, lsl 8
	mov	w0, 239
	str	w0, [x6, 2056]
	mov	w0, 137
	str	w0, [x6, 2052]
	mov	w0, 200
	bl	timer_delay_ns
	str	wzr, [x6, 2048]
	str	wzr, [x6, 2048]
	cmp	w19, w21
	str	wzr, [x6, 2048]
	str	wzr, [x6, 2048]
	bcc	.L1330
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1330:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1324
	adrp	x0, .LC52
	mov	w4, w19
	mov	w3, w23
	mov	w2, w24
	mov	w1, w23
	add	x0, x0, :lo12:.LC52
	bl	printf
.L1324:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1329:
	str	w8, [x22, 2056]
	mov	w0, 200
	str	w10, [x22, 2052]
	stp	x5, x6, [x29, 96]
	stp	w8, w10, [x29, 116]
	bl	timer_delay_ns
	add	w7, w23, 1
	str	w7, [x22, 2048]
	str	wzr, [x22, 2048]
	mov	w4, w28
	str	wzr, [x22, 2048]
	mov	x3, x27
	str	wzr, [x22, 2048]
	mov	x2, x26
	str	w7, [x29, 124]
	mov	w1, w24
	mov	w0, w25
	bl	flash_read_page
	ldp	w8, w10, [x29, 116]
	cmn	w0, #1
	ldr	w7, [x29, 124]
	ldp	x5, x6, [x29, 96]
	beq	.L1326
	adrp	x1, .LANCHOR135
	cmn	w19, #1
	csel	w19, w19, w0, ne
	cmp	w0, w21
	ldr	x26, [x1, #:lo12:.LANCHOR135]
	adrp	x1, .LANCHOR136
	ldr	x27, [x1, #:lo12:.LANCHOR136]
	bcc	.L1332
.L1326:
	mov	w23, w7
	b	.L1325
.L1332:
	mov	w19, w0
	b	.L1328
	.size	micron_read_retrial, .-micron_read_retrial
	.section	.text.toshiba_3d_read_retrial,"ax",@progbits
	.align	2
	.global	toshiba_3d_read_retrial
	.type	toshiba_3d_read_retrial, %function
toshiba_3d_read_retrial:
	stp	x29, x30, [sp, -128]!
	and	w6, w1, 255
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR9
	stp	x25, x26, [sp, 64]
	and	w25, w0, 255
	stp	x27, x28, [sp, 80]
	mov	x27, x3
	stp	x23, x24, [sp, 48]
	mov	x28, x4
	mov	w23, w2
	stp	x19, x20, [sp, 16]
	str	w5, [x29, 124]
	bl	nandc_wait_flash_ready
	adrp	x0, .LANCHOR13
	mov	w1, 46
	mov	w2, 56
	ldr	x26, [x0, #:lo12:.LANCHOR13]
	and	x0, x25, 255
	add	x21, x0, 8
	str	x0, [x29, 112]
	ldrb	w0, [x22, #:lo12:.LANCHOR9]
	add	x21, x26, x21, lsl 8
	cmp	w0, 36
	mov	w0, 26
	csel	w1, w2, w1, ne
	str	w1, [x29, 96]
	mov	w1, 10
	csel	w0, w1, w0, ne
	str	w0, [x29, 104]
	cbnz	w6, .L1344
	sxtw	x24, w25
	add	x0, x22, :lo12:.LANCHOR9
	add	x24, x24, 8
	mov	w19, -1
	add	x24, x26, x24, lsl 8
	mov	w20, 1
	str	x0, [x29, 96]
.L1351:
	ldr	x0, [x29, 96]
	ldrb	w0, [x0]
	cmp	w0, 36
	bne	.L1345
	mov	x0, x21
	mov	w2, 0
	mov	w1, w20
	bl	toshiba_tlc_set_rr_para
	mov	w0, 93
	str	w0, [x24, 8]
.L1346:
	ldr	w4, [x29, 124]
	mov	x3, x28
	mov	x2, x27
	mov	w1, w23
	mov	w0, w25
	bl	flash_read_page
	mov	w4, w0
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 4, .L1347
	mov	w3, w4
	str	w4, [x29, 120]
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC53
	add	x0, x0, :lo12:.LC53
	bl	printf
	ldr	w4, [x29, 120]
.L1347:
	cmn	w4, #1
	beq	.L1348
	adrp	x0, .LANCHOR135
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x27, [x0, #:lo12:.LANCHOR135]
	adrp	x0, .LANCHOR136
	ldr	x28, [x0, #:lo12:.LANCHOR136]
	adrp	x0, .LANCHOR34
	ldrb	w0, [x0, #:lo12:.LANCHOR34]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1366
.L1348:
	ldr	w0, [x29, 104]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1351
.L1350:
	ldrb	w0, [x22, #:lo12:.LANCHOR9]
	cmp	w0, 36
	bne	.L1352
	mov	w2, 0
.L1389:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_tlc_set_rr_para
	b	.L1353
.L1345:
	mov	w1, w20
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
	b	.L1346
.L1366:
	mov	w19, w4
	b	.L1350
.L1352:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
.L1353:
	ldrb	w0, [x22, #:lo12:.LANCHOR9]
	cmp	w0, 36
	bne	.L1362
	ldr	x0, [x29, 112]
	add	x26, x26, x0, lsl 8
	mov	w0, 85
	str	w0, [x26, 2056]
	mov	w0, 255
	str	wzr, [x26, 2052]
	str	wzr, [x26, 2048]
	str	w0, [x26, 2056]
.L1362:
	adrp	x0, .LANCHOR34
	ldrb	w0, [x0, #:lo12:.LANCHOR34]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1363
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1363:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1364
	adrp	x0, .LC55
	mov	w4, w19
	mov	w3, w20
	mov	w2, w23
	mov	w1, w20
	add	x0, x0, :lo12:.LC55
	bl	printf
.L1364:
	bl	nandc_wait_flash_ready
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1344:
	sxtw	x24, w25
	orr	w23, w23, w6, lsl 24
	add	x24, x24, 8
	add	x0, x22, :lo12:.LANCHOR9
	add	x24, x26, x24, lsl 8
	mov	w19, -1
	mov	w20, 1
	str	x0, [x29, 104]
.L1360:
	ldr	x0, [x29, 104]
	ldrb	w0, [x0]
	cmp	w0, 36
	bne	.L1354
	mov	x0, x21
	mov	w2, 1
	mov	w1, w20
	bl	toshiba_tlc_set_rr_para
	mov	w0, 93
.L1388:
	str	w0, [x24, 8]
	mov	x3, x28
	mov	x2, x27
	mov	w1, w23
	ldr	w4, [x29, 124]
	mov	w0, w25
	bl	flash_read_page
	mov	w4, w0
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 4, .L1356
	mov	w3, w4
	str	w4, [x29, 120]
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC54
	add	x0, x0, :lo12:.LC54
	bl	printf
	ldr	w4, [x29, 120]
.L1356:
	cmn	w4, #1
	beq	.L1357
	adrp	x0, .LANCHOR135
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x27, [x0, #:lo12:.LANCHOR135]
	adrp	x0, .LANCHOR136
	ldr	x28, [x0, #:lo12:.LANCHOR136]
	adrp	x0, .LANCHOR34
	ldrb	w0, [x0, #:lo12:.LANCHOR34]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1367
.L1357:
	ldr	w0, [x29, 96]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1360
.L1359:
	ldrb	w0, [x22, #:lo12:.LANCHOR9]
	cmp	w0, 36
	bne	.L1361
	mov	w2, 1
	b	.L1389
.L1354:
	mov	x0, x21
	mov	w1, w20
	bl	toshiba_3d_set_tlc_rr_para
	mov	w0, 38
	b	.L1388
.L1367:
	mov	w19, w4
	b	.L1359
.L1361:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_tlc_rr_para
	b	.L1353
	.size	toshiba_3d_read_retrial, .-toshiba_3d_read_retrial
	.section	.text.toshiba_read_retrial,"ax",@progbits
	.align	2
	.global	toshiba_read_retrial
	.type	toshiba_read_retrial, %function
toshiba_read_retrial:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	mov	x27, x3
	stp	x19, x20, [sp, 16]
	mov	x28, x4
	stp	x25, x26, [sp, 64]
	and	w19, w0, 255
	stp	x23, x24, [sp, 48]
	and	x26, x19, 255
	stp	w5, w2, [x29, 120]
	bl	nandc_wait_flash_ready
	adrp	x0, .LANCHOR13
	adrp	x1, .LANCHOR9
	str	x1, [x29, 112]
	add	x21, x26, 8
	ldr	x22, [x0, #:lo12:.LANCHOR13]
	ldrb	w0, [x1, #:lo12:.LANCHOR9]
	sub	w0, w0, #67
	add	x21, x22, x21, lsl 8
	and	w0, w0, 255
	cmp	w0, 1
	bls	.L1408
	adrp	x0, .LANCHOR42
	ldrb	w0, [x0, #:lo12:.LANCHOR42]
	cbz	w0, .L1409
	mov	w23, 1
	mov	w0, 1
	bl	nandc_set_if_mode
.L1392:
	add	x0, x22, x26, lsl 8
	mov	w1, 92
	str	w1, [x0, 2056]
	mov	w1, 197
	str	w1, [x0, 2056]
.L1391:
	sxtw	x0, w19
	mov	w20, 1
	add	x0, x0, 8
	mov	w24, -1
	add	x0, x22, x0, lsl 8
	str	x0, [x29, 104]
.L1393:
	adrp	x0, .LANCHOR137
	ldrb	w0, [x0, #:lo12:.LANCHOR137]
	add	w0, w0, 1
	cmp	w20, w0
	bcc	.L1402
	mov	w25, w24
.L1401:
	ldr	x0, [x29, 112]
	mov	w1, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR9]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1403
	bl	sandisk_set_rr_para
.L1404:
	sxtw	x19, w19
	mov	w0, 255
	add	x19, x19, 8
	add	x22, x22, x19, lsl 8
	str	w0, [x22, 8]
	adrp	x0, .LANCHOR34
	ldrb	w0, [x0, #:lo12:.LANCHOR34]
	add	w0, w0, w0, lsl 1
	cmp	w25, w0, lsr 2
	bcc	.L1405
	cmn	w25, #1
	mov	w0, 256
	csel	w25, w25, w0, eq
.L1405:
	cmp	w25, 256
	ccmn	w25, #1, 4, ne
	bne	.L1406
	ldr	w2, [x29, 124]
	adrp	x0, .LC55
	mov	w4, w25
	mov	w3, w20
	mov	w1, w20
	add	x0, x0, :lo12:.LC55
	bl	printf
.L1406:
	bl	nandc_wait_flash_ready
	cbz	w23, .L1390
	mov	w0, 4
	bl	nandc_set_if_mode
.L1390:
	mov	w0, w25
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1409:
	mov	w23, 0
	b	.L1392
.L1408:
	mov	w23, 0
	b	.L1391
.L1402:
	ldr	x0, [x29, 112]
	mov	w1, w20
	ldrb	w0, [x0, #:lo12:.LANCHOR9]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1394
	bl	sandisk_set_rr_para
.L1395:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, #:lo12:.LANCHOR9]
	cmp	w0, 34
	bne	.L1396
	adrp	x0, .LANCHOR137
	ldrb	w0, [x0, #:lo12:.LANCHOR137]
	sub	w0, w0, #3
	cmp	w20, w0
	bne	.L1396
	ldr	x1, [x29, 104]
	mov	w0, 179
	str	w0, [x1, 8]
.L1396:
	add	x0, x22, x26, lsl 8
	mov	w1, 38
	ldr	w4, [x29, 120]
	mov	x3, x28
	mov	x2, x27
	str	w1, [x0, 2056]
	mov	w1, 93
	str	w1, [x0, 2056]
	mov	w0, w19
	ldr	w1, [x29, 124]
	bl	flash_read_page
	mov	w25, w0
	cmn	w0, #1
	beq	.L1399
	cmn	w24, #1
	csel	w24, w24, w0, ne
	adrp	x0, .LANCHOR135
	ldr	x27, [x0, #:lo12:.LANCHOR135]
	adrp	x0, .LANCHOR136
	ldr	x28, [x0, #:lo12:.LANCHOR136]
	adrp	x0, .LANCHOR34
	ldrb	w0, [x0, #:lo12:.LANCHOR34]
	add	w0, w0, w0, lsl 1
	cmp	w25, w0, lsr 2
	bcc	.L1401
.L1399:
	add	w20, w20, 1
	b	.L1393
.L1394:
	bl	toshiba_set_rr_para
	b	.L1395
.L1403:
	bl	toshiba_set_rr_para
	b	.L1404
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
	adrp	x0, .LANCHOR12
	stp	x27, x28, [sp, 80]
	stp	x21, x22, [sp, 32]
	mov	w27, w5
	ldr	x28, [x0, #:lo12:.LANCHOR12]
	mov	w22, w2
	stp	x25, x26, [sp, 64]
	mov	x25, x3
	add	x28, x28, 112
	stp	x19, x20, [sp, 16]
	add	x0, x28, x23
	mov	x26, x4
	mov	x21, x23
	mov	w19, -1
	ldrb	w24, [x28, 2]
	ldrb	w20, [x0, 8]
	bl	nandc_wait_flash_ready
	adrp	x6, .LANCHOR34
	add	x6, x6, :lo12:.LANCHOR34
	mov	w5, 0
	adrp	x7, .LANCHOR135
	adrp	x8, .LANCHOR136
.L1423:
	cmp	w5, w24
	bcc	.L1428
.L1427:
	adrp	x0, .LANCHOR34
	add	x23, x28, x23
	ldrb	w0, [x0, #:lo12:.LANCHOR34]
	strb	w20, [x23, 8]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1429
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1429:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1422
	adrp	x0, .LC56
	mov	w4, w19
	mov	w3, w5
	mov	w2, w22
	mov	w1, w5
	add	x0, x0, :lo12:.LC56
	bl	printf
.L1422:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1428:
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
	beq	.L1425
	ldrb	w1, [x6]
	cmn	w19, #1
	csel	w19, w19, w0, ne
	ldr	x25, [x7, #:lo12:.LANCHOR135]
	ldr	x26, [x8, #:lo12:.LANCHOR136]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L1431
.L1425:
	add	w5, w5, 1
	b	.L1423
.L1431:
	mov	w19, w0
	b	.L1427
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
	adrp	x21, .LC57
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR34
	stp	x25, x26, [sp, 64]
	add	x21, x21, :lo12:.LC57
	stp	x27, x28, [sp, 80]
	mov	x26, x3
	str	w4, [x29, 120]
	add	x22, x22, :lo12:.LANCHOR34
	str	x2, [x29, 128]
	mov	w28, 0
	str	w0, [x29, 136]
	bl	nandc_get_ddr_para
	mov	w23, 0
	str	w0, [x29, 124]
	mov	w24, 0
	adrp	x0, .LANCHOR29
	mov	w27, 1024
	add	x0, x0, :lo12:.LANCHOR29
	mov	w25, 6
	mov	w19, -1
	str	wzr, [x29, 140]
	str	x0, [x29, 112]
.L1447:
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
	tbz	x0, 4, .L1442
	mov	w3, w4
	str	w4, [x29, 108]
	mov	w2, w20
	mov	w1, w25
	mov	x0, x21
	bl	printf
	ldr	w4, [x29, 108]
.L1442:
	add	w0, w27, 1
	cmp	w4, w0
	bhi	.L1443
	adrp	x0, .LANCHOR135
	ldr	x0, [x0, #:lo12:.LANCHOR135]
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR136
	ldr	x26, [x0, #:lo12:.LANCHOR136]
	ldrb	w0, [x22]
	cmp	w4, w0, lsr 2
	bcs	.L1452
	add	w24, w24, 1
	cmp	w24, 7
	bls	.L1452
	sub	w28, w25, w24
	mov	w27, w4
	mov	w19, 0
.L1445:
	ldr	w0, [x29, 140]
	cmp	w24, w23
	csel	w28, w28, w0, cs
.L1446:
	cbz	w28, .L1448
	adrp	x0, .LANCHOR34
	mov	w1, 3
	ldrb	w0, [x0, #:lo12:.LANCHOR34]
	udiv	w0, w0, w1
	cmp	w0, w27
	bls	.L1448
	mov	w1, w28
	adrp	x0, .LC58
	add	x0, x0, :lo12:.LC58
	bl	printf
	mov	w0, w28
.L1462:
	bl	nandc_set_ddr_para
	cbz	w19, .L1441
	ldr	w1, [x29, 136]
	adrp	x0, .LC59
	mov	w2, w20
	add	x0, x0, :lo12:.LC59
	mov	w27, w19
	bl	printf
.L1441:
	mov	w0, w27
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1443:
	cmp	w24, w23
	bls	.L1453
	sub	w0, w28, w24
	str	w0, [x29, 140]
	cmp	w24, 7
	bhi	.L1446
	mov	w23, w24
.L1453:
	mov	w24, 0
	b	.L1444
.L1452:
	mov	w28, w25
	mov	w27, w4
	mov	w19, 0
.L1444:
	add	w25, w25, 2
	cmp	w25, 50
	bne	.L1447
	b	.L1445
.L1448:
	ldrb	w0, [x29, 124]
	b	.L1462
	.size	flash_ddr_tunning_read, .-flash_ddr_tunning_read
	.section	.text.flash_read_page_en,"ax",@progbits
	.align	2
	.global	flash_read_page_en
	.type	flash_read_page_en, %function
flash_read_page_en:
	stp	x29, x30, [sp, -96]!
	and	w0, w0, 255
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	adrp	x1, .LANCHOR15
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	cmp	w1, w0
	bhi	.L1464
	adrp	x1, .LANCHOR138
	adrp	x0, .LC0
	mov	w2, 399
	add	x1, x1, :lo12:.LANCHOR138
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1465:
	b	.L1465
.L1464:
	adrp	x1, .LANCHOR17
	add	x1, x1, :lo12:.LANCHOR17
	mov	x22, x2
	mov	x23, x3
	mov	w24, w4
	ldrb	w20, [x1, w0, sxtw]
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 4, .L1466
	adrp	x0, .LC60
	mov	w2, w19
	mov	w1, w20
	add	x0, x0, :lo12:.LC60
	bl	printf
.L1466:
	tst	x19, 50331648
	bne	.L1467
	adrp	x0, .LANCHOR18
	adrp	x1, .LANCHOR19
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	cbz	w0, .L1468
	ldrb	w0, [x1, #:lo12:.LANCHOR19]
	cbz	w0, .L1467
.L1468:
	adrp	x0, .LANCHOR20
	ldrb	w1, [x1, #:lo12:.LANCHOR19]
	ldrh	w2, [x0, #:lo12:.LANCHOR20]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L1469
	add	w19, w0, w19, lsl 1
.L1467:
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w20
	bl	flash_read_page
	mov	w21, w0
	cmn	w0, #1
	bne	.L1463
	adrp	x25, .LANCHOR36
	mov	x26, x25
	ldrb	w27, [x25, #:lo12:.LANCHOR36]
	cbnz	w27, .L1471
.L1474:
	adrp	x0, .LANCHOR139
	ldr	x6, [x0, #:lo12:.LANCHOR139]
	cbnz	x6, .L1472
.L1473:
	ldrb	w4, [x26, #:lo12:.LANCHOR36]
	mov	w3, -1
	mov	w2, w19
	mov	w1, 0
	adrp	x0, .LC61
	add	x0, x0, :lo12:.LC61
	bl	printf
	adrp	x0, .LANCHOR42
	ldrb	w0, [x0, #:lo12:.LANCHOR42]
	cbz	w0, .L1463
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
.L1469:
	adrp	x1, .LANCHOR21
	add	x1, x1, :lo12:.LANCHOR21
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
	b	.L1467
.L1471:
	strb	wzr, [x25, #:lo12:.LANCHOR36]
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w20
	bl	flash_read_page
	strb	w27, [x25, #:lo12:.LANCHOR36]
	cmn	w0, #1
	beq	.L1474
.L1492:
	mov	w21, w0
.L1463:
	mov	w0, w21
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1472:
	mov	w5, w24
	mov	x4, x23
	mov	x3, x22
	mov	w2, w19
	mov	w1, 0
	mov	w0, w20
	blr	x6
	cmn	w0, #1
	bne	.L1492
	b	.L1473
	.size	flash_read_page_en, .-flash_read_page_en
	.section	.text.flash_get_last_written_page,"ax",@progbits
	.align	2
	.global	flash_get_last_written_page
	.type	flash_get_last_written_page, %function
flash_get_last_written_page:
	stp	x29, x30, [sp, -96]!
	and	w1, w1, 65535
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w21, w0, 255
	adrp	x0, .LANCHOR121
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	mov	x22, x2
	ldrh	w19, [x0, #:lo12:.LANCHOR121]
	adrp	x0, .LANCHOR26+26
	stp	x23, x24, [sp, 48]
	mov	x23, x3
	ldrh	w25, [x0, #:lo12:.LANCHOR26+26]
	sub	w19, w19, #1
	sxth	w19, w19
	mov	w24, w4
	mov	w0, w21
	str	x27, [sp, 80]
	mul	w25, w25, w1
	add	w1, w19, w25
	bl	flash_read_page_en
	cmp	w0, 512
	bne	.L1494
	mov	w26, 0
	mov	w27, 2
.L1495:
	cmp	w26, w19
	ble	.L1498
.L1494:
	mov	w0, w19
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1498:
	add	w20, w26, w19
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w0, w21
	sdiv	w20, w20, w27
	add	w1, w25, w20, sxth
	bl	flash_read_page_en
	cmp	w0, 512
	bne	.L1496
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L1495
.L1496:
	add	w20, w20, 1
	sxth	w26, w20
	b	.L1495
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
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR20
	stp	x23, x24, [sp, 48]
	mov	w24, 21321
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR140
	stp	x27, x28, [sp, 80]
	mov	x21, x26
	add	x27, x22, :lo12:.LANCHOR20
	stp	x19, x20, [sp, 16]
	movk	w24, 0x5359, lsl 16
	mov	w19, 4
.L1504:
	ldrh	w1, [x27]
	adrp	x20, .LANCHOR12
	ldr	x3, [x26, #:lo12:.LANCHOR140]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR12]
	mov	w0, 0
	add	x28, x26, :lo12:.LANCHOR140
	add	x25, x20, :lo12:.LANCHOR12
	mul	w1, w1, w19
	mov	x23, x20
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1502
	ldr	x2, [x20, #:lo12:.LANCHOR12]
	ldr	w0, [x2]
	cmp	w0, w24
	beq	.L1503
.L1502:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L1504
.L1525:
	mov	w0, -1
.L1501:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1512:
	ldr	x0, [x25]
	ldr	w1, [x0]
	cmp	w1, w24
	bne	.L1513
	ldr	w19, [x0, 4]
.L1506:
	add	x24, x20, :lo12:.LANCHOR141
	ldrh	w0, [x22, #:lo12:.LANCHOR20]
	ldr	x3, [x21, #:lo12:.LANCHOR140]
	mov	w4, 4
	ldr	x2, [x23, #:lo12:.LANCHOR12]
	ldrb	w1, [x24, 1]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1507
	ldr	x0, [x23, #:lo12:.LANCHOR12]
	mov	w1, 21321
	movk	w1, 0x5359, lsl 16
	ldr	w2, [x0]
	cmp	w2, w1
	bne	.L1507
	ldr	w1, [x0, 4]
	cmp	w19, w1
	bcs	.L1507
	ldrb	w1, [x0, 37]
	ldrb	w0, [x0, 36]
	strb	w1, [x20, #:lo12:.LANCHOR141]
	strb	w0, [x24, 1]
.L1507:
	ldrb	w1, [x20, #:lo12:.LANCHOR141]
	add	x24, x20, :lo12:.LANCHOR141
	ldr	x3, [x21, #:lo12:.LANCHOR140]
	mov	w4, 4
	ldr	x2, [x23, #:lo12:.LANCHOR12]
	mov	w0, 0
	bl	flash_get_last_written_page
	sxth	w19, w0
	add	w0, w0, 1
	ldrb	w20, [x20, #:lo12:.LANCHOR141]
	strh	w0, [x24, 2]
	ldrh	w0, [x22, #:lo12:.LANCHOR20]
	mov	w22, 21321
	movk	w22, 0x5359, lsl 16
	madd	w20, w20, w0, w19
.L1508:
	tbz	w19, #31, .L1510
	cmn	w19, #1
	bne	.L1511
	ldr	x0, [x23, #:lo12:.LANCHOR12]
	ldr	w1, [x0]
	adrp	x0, .LC62
	add	x0, x0, :lo12:.LC62
	bl	printf
	b	.L1525
.L1510:
	ldr	x3, [x21, #:lo12:.LANCHOR140]
	mov	w4, 4
	ldr	x2, [x23, #:lo12:.LANCHOR12]
	mov	w1, w20
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1509
	ldr	x0, [x23, #:lo12:.LANCHOR12]
	ldr	w0, [x0]
	cmp	w0, w22
	bne	.L1509
.L1511:
	mov	w0, 0
	b	.L1501
.L1509:
	sub	w19, w19, #1
	sub	w20, w20, #1
	sxth	w19, w19
	b	.L1508
.L1503:
	adrp	x20, .LANCHOR141
	add	x1, x20, :lo12:.LANCHOR141
	ldrb	w3, [x2, 37]
	mov	w4, 4
	ldrb	w0, [x2, 36]
	strb	w3, [x1, 1]
	ldrh	w1, [x27]
	ldr	x3, [x28]
	strb	w0, [x20, #:lo12:.LANCHOR141]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	bne	.L1512
.L1513:
	mov	w19, 0
	b	.L1506
	.size	flash_info_blk_init, .-flash_info_blk_init
	.section	.text.flash_ddr_para_scan,"ax",@progbits
	.align	2
	.global	flash_ddr_para_scan
	.type	flash_ddr_para_scan, %function
flash_ddr_para_scan:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR32
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	ldrb	w0, [x20, #:lo12:.LANCHOR32]
	adrp	x19, .LANCHOR42
	stp	x23, x24, [sp, 48]
	mov	w21, 1
	mov	w23, w1
	str	x25, [sp, 64]
	strb	w21, [x19, #:lo12:.LANCHOR42]
	adrp	x24, .LANCHOR143
	bl	flash_set_interface_mode
	adrp	x25, .LANCHOR142
	ldrb	w0, [x20, #:lo12:.LANCHOR32]
	bl	nandc_set_if_mode
	ldr	x3, [x25, #:lo12:.LANCHOR142]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR143]
	mov	w1, w23
	mov	w0, w22
	bl	flash_ddr_tunning_read
	ldr	x3, [x25, #:lo12:.LANCHOR142]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR143]
	mov	w1, w23
	mov	w0, w22
	bl	flash_read_page
	cmn	w0, #1
	mov	x0, x19
	bne	.L1527
	ldrb	w1, [x20, #:lo12:.LANCHOR32]
	tbz	x1, 0, .L1527
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, w21
	bl	nandc_set_if_mode
	strb	wzr, [x19, #:lo12:.LANCHOR42]
.L1528:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1527:
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR42]
	b	.L1528
	.size	flash_ddr_para_scan, .-flash_ddr_para_scan
	.section	.text.flash_complete_page_read,"ax",@progbits
	.align	2
	.global	flash_complete_page_read
	.type	flash_complete_page_read, %function
flash_complete_page_read:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	w23, w0
	adrp	x0, .LANCHOR15
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	mov	x24, x1
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	ubfx	x1, x23, 21, 3
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cmp	w0, w1
	bhi	.L1534
	adrp	x1, .LANCHOR144
	adrp	x0, .LC0
	mov	w2, 812
	add	x1, x1, :lo12:.LANCHOR144
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1535:
	b	.L1535
.L1534:
	adrp	x0, .LANCHOR17
	add	x0, x0, :lo12:.LANCHOR17
	ubfx	x21, x23, 24, 2
	mov	x25, x2
	and	w19, w23, 2097151
	ldrb	w22, [x0, w1, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x4, [x0, #:lo12:.LANCHOR13]
	mov	w0, w22
	bl	nandc_cs
	cbnz	w21, .L1536
	adrp	x0, .LANCHOR18
	adrp	x1, .LANCHOR19
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	cbz	w0, .L1537
	ldrb	w0, [x1, #:lo12:.LANCHOR19]
	cbz	w0, .L1536
.L1537:
	adrp	x0, .LANCHOR20
	ldrb	w1, [x1, #:lo12:.LANCHOR19]
	ldrh	w2, [x0, #:lo12:.LANCHOR20]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L1538
	add	w19, w0, w19, lsl 1
.L1536:
	ubfiz	x0, x22, 8, 8
	mov	w1, 5
	add	x0, x4, x0
	adrp	x20, .LANCHOR26
	add	x28, x20, :lo12:.LANCHOR26
	mov	x4, x25
	mov	x3, x24
	str	w1, [x0, 2056]
	and	w1, w19, 255
	str	wzr, [x0, 2052]
	str	wzr, [x0, 2052]
	str	w1, [x0, 2052]
	lsr	w1, w19, 8
	ldrb	w2, [x28, 9]
	str	w1, [x0, 2052]
	lsr	w1, w19, 16
	str	w1, [x0, 2052]
	mov	w1, 224
	str	w1, [x0, 2056]
	mov	w1, 0
	mov	w0, w22
	bl	nandc_xfer
	cmn	w0, #1
	bne	.L1539
	adrp	x26, .LANCHOR36
	ldrb	w27, [x26, #:lo12:.LANCHOR36]
	cbz	w27, .L1540
	ldrb	w4, [x28, 9]
	mov	x3, x25
	strb	wzr, [x26, #:lo12:.LANCHOR36]
	mov	x2, x24
	orr	w1, w19, w21, lsl 24
	mov	w0, w22
	bl	flash_read_page
	strb	w27, [x26, #:lo12:.LANCHOR36]
	cbnz	w21, .L1541
.L1546:
	adrp	x1, .LANCHOR18
	ldrb	w1, [x1, #:lo12:.LANCHOR18]
	cbz	w1, .L1541
	adrp	x1, .LANCHOR34
	ldrb	w1, [x1, #:lo12:.LANCHOR34]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	blt	.L1541
	add	x20, x20, :lo12:.LANCHOR26
	ldrb	w1, [x20, 19]
	sub	w1, w1, #4
	and	w1, w1, 255
	cmp	w1, 3
	mov	w1, 256
	csel	w0, w0, w1, hi
.L1533:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1538:
	adrp	x1, .LANCHOR21
	add	x1, x1, :lo12:.LANCHOR21
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
	b	.L1536
.L1541:
	cmn	w0, #1
	bne	.L1533
.L1547:
	adrp	x0, .LANCHOR139
	ldr	x6, [x0, #:lo12:.LANCHOR139]
	cbnz	x6, .L1543
.L1545:
	adrp	x0, .LANCHOR36
	mov	w3, -1
	mov	w2, w23
	mov	w1, 0
	ldrb	w4, [x0, #:lo12:.LANCHOR36]
	adrp	x0, .LC63
	add	x0, x0, :lo12:.LC63
	bl	printf
	adrp	x0, .LANCHOR42
	ldrb	w0, [x0, #:lo12:.LANCHOR42]
	cbnz	w0, .L1544
	mov	w0, -1
	b	.L1533
.L1543:
	add	x0, x20, :lo12:.LANCHOR26
	mov	x4, x25
	mov	x3, x24
	mov	w2, w19
	mov	w1, w21
	ldrb	w5, [x0, 9]
	mov	w0, w22
	blr	x6
	cmn	w0, #1
	beq	.L1545
	b	.L1533
.L1544:
	add	x20, x20, :lo12:.LANCHOR26
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
.L1539:
	cbnz	w21, .L1533
	b	.L1546
.L1540:
	cbz	w21, .L1546
	b	.L1547
	.size	flash_complete_page_read, .-flash_complete_page_read
	.section	.text.queue_wait_first_req_completed,"ax",@progbits
	.align	2
	.type	queue_wait_first_req_completed, %function
queue_wait_first_req_completed:
	stp	x29, x30, [sp, -64]!
	adrp	x0, .LANCHOR114
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldrb	w0, [x0, #:lo12:.LANCHOR114]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w0, 255
	bne	.L1568
.L1586:
	mov	w21, 0
	b	.L1567
.L1568:
	adrp	x19, .LANCHOR43
	sxtw	x22, w0
	add	x1, x19, :lo12:.LANCHOR43
	add	x1, x1, x22, lsl 6
	ldrb	w2, [x1, 58]
	ldr	w21, [x1, 40]
	sub	w3, w2, #1
	cmp	w3, 9
	bhi	.L1586
	adrp	x1, .L1571
	add	x1, x1, :lo12:.L1571
	ldrb	w1, [x1,w3,uxtw]
	adr	x3, .Lrtx1571
	add	x1, x3, w1, sxtb #2
	br	x1
.Lrtx1571:
	.section	.rodata.queue_wait_first_req_completed,"a",@progbits
	.align	0
	.align	2
.L1571:
	.byte	(.L1570 - .Lrtx1571) / 4
	.byte	(.L1570 - .Lrtx1571) / 4
	.byte	(.L1572 - .Lrtx1571) / 4
	.byte	(.L1572 - .Lrtx1571) / 4
	.byte	(.L1572 - .Lrtx1571) / 4
	.byte	(.L1573 - .Lrtx1571) / 4
	.byte	(.L1574 - .Lrtx1571) / 4
	.byte	(.L1575 - .Lrtx1571) / 4
	.byte	(.L1572 - .Lrtx1571) / 4
	.byte	(.L1575 - .Lrtx1571) / 4
	.section	.text.queue_wait_first_req_completed
.L1570:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L1586
	add	x19, x19, :lo12:.LANCHOR43
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
	b	.L1586
.L1572:
	mov	w0, w21
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w21, w0
	tbz	x21, 6, .L1586
	add	x19, x19, :lo12:.LANCHOR43
	mov	w0, 5
	add	x19, x19, x22, lsl 6
	tst	w21, w0
	beq	.L1585
	ldrb	w1, [x19, 1]
	mov	w0, 11
	ldr	w3, [x19, 40]
	mov	w4, 11
	ldr	w2, [x19, 52]
	strb	w0, [x19, 58]
	adrp	x0, .LC64
	add	x0, x0, :lo12:.LC64
	bl	printf
.L1604:
	mov	w0, -1
	str	w0, [x19, 52]
	b	.L1567
.L1575:
	cmp	w2, 10
	add	x20, x19, :lo12:.LANCHOR43
	ubfiz	x0, x0, 6, 8
	mov	w1, 3
	mov	w2, 9
	add	x0, x20, x0
	csel	w2, w2, w1, eq
	ubfx	x3, x21, 21, 3
.L1580:
	ldrb	w1, [x0]
	cmp	w1, 255
	bne	.L1584
	mov	w21, -1
	b	.L1567
.L1584:
	sxtw	x23, w1
	ubfiz	x0, x1, 6, 8
	add	x1, x20, x23, lsl 6
	add	x0, x20, x0
	ldrb	w4, [x1, 58]
	cmp	w4, w2
	bne	.L1580
	ldr	w1, [x1, 40]
	ubfx	x1, x1, 21, 3
	cmp	w3, w1
	bne	.L1580
	mov	w0, w21
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w24, w0
	and	w21, w0, 64
	tbz	x24, 6, .L1582
	add	x20, x20, x22, lsl 6
	ands	w21, w0, 15
	beq	.L1583
	ldrb	w1, [x20, 1]
	mov	w4, 11
	ldr	w3, [x20, 40]
	adrp	x0, .LC64
	ldr	w2, [x20, 52]
	add	x0, x0, :lo12:.LC64
	mov	w21, w24
	bl	printf
	mov	w0, 11
	strb	w0, [x20, 58]
	mov	w0, -1
	str	w0, [x20, 52]
.L1582:
	add	x1, x19, :lo12:.LANCHOR43
	add	x22, x1, x22, lsl 6
	add	x1, x1, x23, lsl 6
	ldrb	w0, [x22, 58]
	strb	w0, [x1, 58]
	ldr	w0, [x22, 52]
	str	w0, [x1, 52]
.L1567:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1583:
	mov	w0, 12
	str	wzr, [x20, 52]
	strb	w0, [x20, 58]
	b	.L1582
.L1573:
	mov	w0, w21
	mov	w1, 32
	bl	flash_wait_device_ready
	mov	w21, w0
	tbz	x21, 5, .L1586
	add	x19, x19, :lo12:.LANCHOR43
	tst	x21, 15
	add	x19, x19, x22, lsl 6
	beq	.L1585
	mov	w0, 11
	strb	w0, [x19, 58]
	b	.L1604
.L1585:
	mov	w0, 12
	str	wzr, [x19, 52]
	strb	w0, [x19, 58]
	b	.L1586
.L1574:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L1586
	add	x19, x19, :lo12:.LANCHOR43
	add	x19, x19, x22, lsl 6
	str	w0, [x19, 52]
	mov	w0, 6
	strb	w0, [x19, 58]
	b	.L1586
	.size	queue_wait_first_req_completed, .-queue_wait_first_req_completed
	.section	.text.sblk_wait_write_queue_completed,"ax",@progbits
	.align	2
	.global	sblk_wait_write_queue_completed
	.type	sblk_wait_write_queue_completed, %function
sblk_wait_write_queue_completed:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR114
	add	x19, x19, :lo12:.LANCHOR114
.L1606:
	ldrb	w0, [x19]
	cmp	w0, 255
	bne	.L1607
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1607:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1606
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
	and	w13, w0, 65535
	mov	w0, w13
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR80
	adrp	x24, .LANCHOR52
	add	x23, x23, :lo12:.LANCHOR80
	add	x24, x24, :lo12:.LANCHOR52
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	add	x1, x29, 80
	mov	w20, 0
	bl	ftl_get_blk_list_in_sblk
	strb	w0, [x29, 73]
	strh	w13, [x29, 64]
.L1614:
	ldrh	w0, [x23]
	cmp	w0, w20
	bls	.L1613
	adrp	x22, .LANCHOR72
	adrp	x21, .LANCHOR145
	mov	w19, 0
	add	x22, x22, :lo12:.LANCHOR72
	add	x21, x21, :lo12:.LANCHOR145
	b	.L1616
.L1619:
	add	x0, x29, 64
	mov	w1, 65535
	add	x0, x0, x19, sxtw 1
	ldrh	w0, [x0, 16]
	cmp	w0, w1
	bne	.L1615
.L1618:
	add	w19, w19, 1
	and	w19, w19, 65535
.L1616:
	ldrb	w0, [x22]
	cmp	w0, w19
	bhi	.L1619
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1614
.L1615:
	adrp	x1, .LANCHOR99
	ldrb	w3, [x24]
	mov	x2, x21
	ldrh	w4, [x1, #:lo12:.LANCHOR99]
	adrp	x1, ftl_tmp_buffer
	add	x1, x1, :lo12:ftl_tmp_buffer
	madd	w0, w4, w0, w20
	bl	ftl_read_ppa_page
	cmp	w0, 512
	bne	.L1618
.L1613:
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
	adrp	x23, .LANCHOR114
	adrp	x24, .LANCHOR43
	mov	x19, x0
	add	x23, x23, :lo12:.LANCHOR114
	add	x24, x24, :lo12:.LANCHOR43
	stp	x25, x26, [sp, 64]
.L1625:
	cbnz	w22, .L1629
.L1637:
	adrp	x19, .LANCHOR43
	add	x19, x19, :lo12:.LANCHOR43
.L1630:
	cbnz	w21, .L1633
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1629:
	ldrb	w25, [x19]
	ldr	w26, [x19, 40]
.L1626:
	mov	w1, 0
	mov	w0, w26
	bl	queue_lun_state
	cbnz	w0, .L1627
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
	beq	.L1637
	ubfiz	x19, x25, 6, 8
	add	x19, x24, x19
	b	.L1625
.L1627:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1626
.L1633:
	ldrb	w0, [x20, 58]
	cmp	w0, 12
	bne	.L1631
	ldrb	w20, [x20]
	sub	w21, w21, #1
	add	x20, x19, x20, lsl 6
	b	.L1630
.L1631:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1630
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
	stp	x21, x22, [sp, 48]
	add	x21, x19, :lo12:.LANCHOR63
	ldr	x20, [x0, #:lo12:.LANCHOR5]
	stp	x23, x24, [sp, 64]
	ldr	x0, [x21, 8]
	stp	x25, x26, [sp, 80]
	str	x27, [sp, 96]
	cbnz	x0, .L1640
	mov	w0, 1
	bl	buf_alloc
	str	x0, [x21, 8]
.L1640:
	add	x0, x19, :lo12:.LANCHOR63
	ldr	x21, [x0, 8]
	cbz	x21, .L1641
	adrp	x26, .LANCHOR99
	adrp	x27, .LANCHOR67
	add	x25, x20, 96
	add	x26, x26, :lo12:.LANCHOR99
	add	x27, x27, :lo12:.LANCHOR67
	mov	w24, 0
.L1642:
	ldrb	w0, [x20, 89]
	cmp	w24, w0
	bge	.L1652
	mov	w23, 1
	add	x22, x19, :lo12:.LANCHOR63
	b	.L1653
.L1641:
	adrp	x1, .LANCHOR146
	adrp	x0, .LC0
	mov	w2, 348
	add	x1, x1, :lo12:.LANCHOR146
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1643:
	b	.L1643
.L1651:
	ldrh	w0, [x25]
	ldrh	w1, [x26]
	ldrb	w2, [x27]
	cmp	w2, 3
	mul	w1, w0, w1
	ldrh	w0, [x22, 16]
	bne	.L1644
	add	w0, w0, w1
	orr	w0, w0, w23, lsl 24
.L1664:
	str	w0, [x21, 40]
	mov	w1, 1
	mov	x0, x21
	bl	sblk_read_page
	ldr	w2, [x21, 52]
	adrp	x1, .LANCHOR131
	cmn	w2, #1
	beq	.L1647
	ldrh	w0, [x22, 22]
	ldr	x4, [x1, #:lo12:.LANCHOR131]
	ldr	x3, [x21, 24]
	lsl	x0, x0, 2
	ldr	w5, [x4, x0]
	ldr	w4, [x3, 4]
	cmp	w5, w4
	bne	.L1647
	adrp	x4, .LANCHOR132
	ldr	x4, [x4, #:lo12:.LANCHOR132]
	ldr	w4, [x4, x0]
	ldr	w0, [x3, 8]
	cmp	w4, w0
	beq	.L1648
.L1647:
	ldrh	w0, [x22, 22]
	ldr	x1, [x1, #:lo12:.LANCHOR131]
	lsl	x0, x0, 2
	ldr	w3, [x1, x0]
	cmn	w3, #1
	beq	.L1648
	adrp	x1, .LANCHOR29
	ldr	w1, [x1, #:lo12:.LANCHOR29]
	tbz	x1, 10, .L1649
	ldr	x1, [x21, 24]
	adrp	x4, .LANCHOR132
	ldr	x4, [x4, #:lo12:.LANCHOR132]
	ldr	w5, [x1, 12]
	str	w5, [sp]
	ldr	w4, [x4, x0]
	adrp	x0, .LC65
	ldp	w5, w6, [x1]
	add	x0, x0, :lo12:.LC65
	ldr	w7, [x1, 8]
	ldr	w1, [x21, 40]
	bl	printf
.L1649:
	adrp	x0, .LANCHOR4
	ldrh	w1, [x20, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	strh	wzr, [x0, x1, lsl 1]
	mov	w0, -1
.L1639:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	ldr	x27, [sp, 96]
	add	sp, sp, 112
	ret
.L1644:
	cmp	w2, 2
	bne	.L1646
	sub	w0, w0, #1
	add	w1, w23, w1
	add	w0, w0, w1
	orr	w0, w0, 33554432
	b	.L1664
.L1646:
	add	w0, w0, w1
	b	.L1664
.L1648:
	ldrh	w0, [x22, 22]
	add	w23, w23, 1
	add	w0, w0, 1
	strh	w0, [x22, 22]
.L1653:
	ldrh	w0, [x22, 20]
	cmp	w23, w0
	ble	.L1651
	add	w24, w24, 1
	add	x25, x25, 2
	b	.L1642
.L1652:
.L1650:
	add	x19, x19, :lo12:.LANCHOR63
	ldrh	w0, [x19, 16]
	add	w0, w0, 1
	strh	w0, [x19, 16]
	mov	w0, 0
	b	.L1639
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
	adrp	x0, .LANCHOR13
	stp	x23, x24, [sp, 48]
	stp	x21, x22, [sp, 32]
	and	x19, x20, 255
	ldr	x24, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR29
	stp	x25, x26, [sp, 64]
	mov	w21, w1
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	add	x22, x19, 8
	str	x27, [sp, 80]
	mov	x25, x2
	mov	x26, x3
	add	x22, x24, x22, lsl 8
	and	w23, w1, 2097151
	ubfx	x27, x21, 24, 2
	tbz	x0, 4, .L1666
	adrp	x0, .LC66
	mov	w3, w4
	mov	w2, w27
	add	x0, x0, :lo12:.LC66
	bl	printf
.L1666:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	hynix_reconfig_rr_para
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w27, .L1667
	bl	zftl_flash_enter_slc_mode
.L1668:
	add	x19, x24, x19, lsl 8
	mov	w0, 128
	and	w21, w21, 255
	str	w0, [x19, 2056]
	lsr	w0, w23, 8
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w21, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w23, 16
	str	w0, [x19, 2052]
	mov	w0, w23
	bl	nandc_set_seed
	adrp	x0, .LANCHOR26+9
	mov	x3, x26
	mov	x2, x25
	ldrb	w1, [x0, #:lo12:.LANCHOR26+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	mov	w0, 16
	str	w0, [x19, 2056]
	bl	nandc_wait_flash_ready
	mov	x0, x22
	bl	flash_read_status
	mov	w2, w0
	mov	w0, w20
	bl	nandc_de_cs
	ldr	x27, [sp, 80]
	and	w0, w2, 4
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1667:
	bl	zftl_flash_exit_slc_mode
	b	.L1668
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
	bne	.L1674
	adrp	x0, .LANCHOR147
	ldrb	w0, [x0, #:lo12:.LANCHOR147]
	cmp	w0, w19
	bhi	.L1678
.L1674:
	adrp	x22, .LANCHOR142
	adrp	x23, .LANCHOR143
	mov	w2, 32
	mov	w1, 165
	ldr	x0, [x22, #:lo12:.LANCHOR142]
	bl	ftl_memset
	ldr	x0, [x23, #:lo12:.LANCHOR143]
	mov	w2, 8
	mov	w1, 90
	bl	ftl_memset
	adrp	x0, .LANCHOR20
	ldrh	w20, [x0, #:lo12:.LANCHOR20]
	mov	w0, w21
	mul	w20, w20, w19
	mov	w1, w20
	bl	flash_erase_block
	cmn	w0, #1
	beq	.L1676
	adrp	x19, .LANCHOR26
	add	x19, x19, :lo12:.LANCHOR26
	ldr	x3, [x22, #:lo12:.LANCHOR142]
	mov	w1, w20
	ldr	x2, [x23, #:lo12:.LANCHOR143]
	mov	w0, w21
	ldrb	w4, [x19, 9]
	bl	flash_prog_page
	cmn	w0, #1
	beq	.L1676
	ldrb	w4, [x19, 9]
	mov	w1, w20
	ldr	x3, [x22, #:lo12:.LANCHOR142]
	mov	w0, w21
	ldr	x2, [x23, #:lo12:.LANCHOR143]
	bl	flash_read_page
	mov	w19, w0
	cmn	w0, #1
	beq	.L1676
	ldr	x0, [x23, #:lo12:.LANCHOR143]
	ldr	w1, [x0]
	mov	w0, 23130
	movk	w0, 0x5a5a, lsl 16
	cmp	w1, w0
	bne	.L1676
	ldr	x0, [x22, #:lo12:.LANCHOR142]
	ldr	w1, [x0]
	mov	w0, 42405
	movk	w0, 0xa5a5, lsl 16
	cmp	w1, w0
	beq	.L1677
.L1676:
	mov	w19, -1
.L1677:
	mov	w1, w20
	mov	w0, w21
	bl	flash_erase_block
	mov	w0, w19
.L1673:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1678:
	mov	w0, 0
	b	.L1673
	.size	flash_test_blk, .-flash_test_blk
	.section	.text.flash_start_tlc_page_prog,"ax",@progbits
	.align	2
	.global	flash_start_tlc_page_prog
	.type	flash_start_tlc_page_prog, %function
flash_start_tlc_page_prog:
	stp	x29, x30, [sp, -48]!
	and	w8, w0, 255
	adrp	x0, .LANCHOR15
	and	w3, w3, 255
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	str	x21, [sp, 32]
	cmp	w0, w3
	bhi	.L1690
	adrp	x1, .LANCHOR148
	adrp	x0, .LC0
	mov	w2, 671
	add	x1, x1, :lo12:.LANCHOR148
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1691:
	b	.L1691
.L1690:
	adrp	x0, .LANCHOR17
	add	x0, x0, :lo12:.LANCHOR17
	and	w7, w1, 255
	and	w21, w2, 255
	ldrb	w20, [x0, w3, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x19, [x0, #:lo12:.LANCHOR13]
	mov	w0, w20
	bl	nandc_cs
	cbz	w8, .L1692
	sxtw	x0, w20
	add	x0, x0, 8
	add	x0, x19, x0, lsl 8
	str	w8, [x0, 8]
.L1692:
	ubfiz	x0, x20, 8, 8
	add	x19, x19, x0
	mov	w0, 128
	str	w7, [x19, 2056]
	str	w0, [x19, 2056]
	and	w0, w4, 255
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w4, 8
	str	w0, [x19, 2052]
	lsr	w0, w4, 16
	add	w4, w4, w4, lsl 1
	str	w0, [x19, 2052]
	sub	w0, w4, #1
	add	w0, w0, w7
	bl	nandc_set_seed
	mov	x3, x6
	adrp	x0, .LANCHOR26+9
	mov	x2, x5
	ldrb	w1, [x0, #:lo12:.LANCHOR26+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	str	w21, [x19, 2056]
	mov	w0, w20
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
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
	adrp	x0, .LANCHOR114
	add	x0, x0, :lo12:.LANCHOR114
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
.L1700:
	mov	w1, 1
	mov	w0, w20
	bl	queue_lun_state
	cbnz	w0, .L1701
	mov	x0, x19
	bl	queue_tlc_prog_cmd
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1701:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1700
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
.L1704:
	mov	w1, 1
	mov	w0, w20
	bl	queue_lun_state
	cbnz	w0, .L1705
	cmp	w24, 2
	bne	.L1706
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
	adrp	x0, .LANCHOR114
	add	x0, x0, :lo12:.LANCHOR114
	bl	buf_add_tail
.L1707:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1705:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1704
.L1706:
	mov	x0, x19
	bl	queue_tlc_prog_cmd
	b	.L1707
	.size	sblk_xlc_prog_pages, .-sblk_xlc_prog_pages
	.section	.text.flash_start_page_prog,"ax",@progbits
	.align	2
	.global	flash_start_page_prog
	.type	flash_start_page_prog, %function
flash_start_page_prog:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	str	x25, [sp, 64]
	mov	w25, w1
	adrp	x1, .LANCHOR15
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	and	w22, w0, 255
	stp	x19, x20, [sp, 16]
	mov	x24, x3
	ldrb	w0, [x1, #:lo12:.LANCHOR15]
	ubfx	x3, x25, 21, 3
	cmp	w0, w3
	bhi	.L1710
	adrp	x1, .LANCHOR149
	adrp	x0, .LC0
	mov	w2, 708
	add	x1, x1, :lo12:.LANCHOR149
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1711:
	b	.L1711
.L1710:
	adrp	x0, .LANCHOR17
	add	x0, x0, :lo12:.LANCHOR17
	mov	x23, x2
	and	w19, w25, 2097151
	ldrb	w21, [x0, w3, sxtw]
	adrp	x0, .LANCHOR13
	ldr	x20, [x0, #:lo12:.LANCHOR13]
	bl	nandc_rdy_status
	cbnz	w0, .L1712
	ldrb	w0, [x1, #:lo12:.LANCHOR15]
	cmp	w0, 1
	bne	.L1713
	bl	nandc_wait_flash_ready
.L1712:
	mov	w0, w21
	bl	hynix_reconfig_rr_para
	mov	w0, w21
	bl	nandc_cs
	tst	x25, 50331648
	bne	.L1714
	adrp	x0, .LANCHOR18
	adrp	x1, .LANCHOR19
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	cbz	w0, .L1715
	ldrb	w0, [x1, #:lo12:.LANCHOR19]
	cbz	w0, .L1716
.L1715:
	adrp	x0, .LANCHOR20
	ldrb	w1, [x1, #:lo12:.LANCHOR19]
	ldrh	w2, [x0, #:lo12:.LANCHOR20]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L1717
	add	w19, w0, w19, lsl 1
.L1716:
	mov	w0, w21
	bl	zftl_flash_enter_slc_mode
	b	.L1718
.L1713:
	mov	w2, 64
	mov	w1, w19
	mov	w0, w3
	bl	flash_wait_device_ready_raw
	b	.L1712
.L1717:
	adrp	x1, .LANCHOR21
	add	x1, x1, :lo12:.LANCHOR21
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
.L1718:
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
	adrp	x0, .LANCHOR26+9
	mov	x3, x24
	mov	x2, x23
	ldrb	w1, [x0, #:lo12:.LANCHOR26+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	ldr	x25, [sp, 64]
	ldp	x23, x24, [sp, 48]
	str	w22, [x20, 2056]
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	b	nandc_de_cs
.L1714:
	mov	w0, w21
	bl	zftl_flash_exit_slc_mode
	b	.L1718
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
	adrp	x0, .LANCHOR114
	ldr	w3, [x19, 40]
	ldrb	w1, [x0, #:lo12:.LANCHOR114]
	cmp	w1, 255
	beq	.L1724
	adrp	x2, .LANCHOR43
	add	x2, x2, :lo12:.LANCHOR43
	ubfx	x3, x3, 21, 3
	mov	x6, x2
.L1726:
	add	x4, x2, x1, lsl 6
	ldr	w5, [x4, 40]
	ubfx	x5, x5, 21, 3
	cmp	w3, w5
	bne	.L1725
	ldrb	w5, [x4, 58]
	cmp	w5, 6
	bne	.L1725
	mov	w1, 3
	strb	w1, [x4, 58]
.L1724:
	mov	w1, 3
	strb	w1, [x19, 58]
	mov	w1, 1
	strb	w1, [x19, 59]
	mov	w1, -1
	strb	w1, [x19]
	mov	x1, x19
	add	x0, x0, :lo12:.LANCHOR114
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	buf_add_tail
.L1725:
	lsl	x1, x1, 6
	ldrb	w1, [x6, x1]
	cmp	w1, 255
	bne	.L1726
	b	.L1724
	.size	queue_prog_cmd, .-queue_prog_cmd
	.section	.text.sblk_prog_page,"ax",@progbits
	.align	2
	.global	sblk_prog_page
	.type	sblk_prog_page, %function
sblk_prog_page:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w0, [x0, 50]
	and	w20, w1, 255
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cbz	w0, .L1733
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L1733
	ldr	w1, [x19, 40]
	adrp	x0, .LC67
	mov	w2, w20
	add	x0, x0, :lo12:.LC67
	bl	printf
.L1733:
	adrp	x24, .LANCHOR30
	adrp	x22, .LANCHOR43
	add	x24, x24, :lo12:.LANCHOR30
	add	x22, x22, :lo12:.LANCHOR43
	mov	w21, 0
	mov	w23, 1
.L1734:
	cbnz	w20, .L1745
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1745:
	ldrb	w25, [x19]
	ldr	w26, [x19, 40]
.L1735:
	mov	w1, 1
	mov	w0, w26
	bl	queue_lun_state
	cbnz	w0, .L1736
	cmp	w20, 1
	beq	.L1737
	ldrb	w0, [x24]
	cbnz	w0, .L1738
.L1737:
	mov	x0, x19
	bl	queue_prog_cmd
.L1739:
	ubfiz	x19, x25, 6, 8
	sub	w20, w20, #1
	add	x19, x22, x19
	b	.L1734
.L1736:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1735
.L1738:
	ldrb	w0, [x19]
	ubfx	x1, x26, 21, 3
	cmp	w0, 255
	bne	.L1740
	adrp	x1, .LANCHOR150
	adrp	x0, .LC0
	mov	w2, 486
	add	x1, x1, :lo12:.LANCHOR150
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1741:
	b	.L1741
.L1740:
	sbfiz	x0, x0, 6, 32
	add	x0, x22, x0
	ldr	w5, [x0, 40]
	ubfx	x0, x5, 21, 3
	cmp	w1, w0
	bne	.L1742
	adrp	x0, .LANCHOR96
	ldrh	w2, [x0, #:lo12:.LANCHOR96]
	adrp	x0, .LANCHOR95
	ldrb	w3, [x0, #:lo12:.LANCHOR95]
	mov	w0, 21
	sub	w0, w0, w2
	lsl	w1, w23, w2
	sub	w3, w3, #1
	sub	w1, w1, #1
	lsl	w0, w23, w0
	sub	w0, w0, #1
	and	w0, w0, w3
	lsr	w4, w26, w2
	and	w0, w0, 65535
	and	w1, w1, 65535
	and	w4, w0, w4
	lsr	w2, w5, w2
	and	w0, w0, w2
	and	w26, w1, w26
	cmp	w4, w0
	and	w1, w1, w5
	ccmp	w26, w1, 0, ne
	bne	.L1742
	cmp	w21, w3
	beq	.L1742
	ldr	w1, [x19, 40]
	mov	w0, 17
	ldr	x2, [x19, 8]
	add	w21, w21, 1
	ldr	x3, [x19, 24]
	bl	flash_start_page_prog
	strb	w23, [x19, 59]
	mov	w0, 8
	strb	w0, [x19, 58]
	mov	w0, -1
	strb	w0, [x19]
	mov	x1, x19
	adrp	x0, .LANCHOR114
	add	x0, x0, :lo12:.LANCHOR114
	bl	buf_add_tail
	b	.L1739
.L1742:
	mov	x0, x19
	mov	w21, 0
	bl	queue_prog_cmd
	b	.L1739
	.size	sblk_prog_page, .-sblk_prog_page
	.section	.text.ftl_flush,"ax",@progbits
	.align	2
	.global	ftl_flush
	.type	ftl_flush, %function
ftl_flush:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR112
	add	x29, sp, 0
	ldrb	w1, [x0, #:lo12:.LANCHOR112]
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	adrp	x20, .LANCHOR151
	cbz	w1, .L1757
	ldrb	w2, [x20, #:lo12:.LANCHOR151]
	adrp	x0, .LANCHOR43
	add	x0, x0, :lo12:.LANCHOR43
	add	x0, x0, x2, lsl 6
	bl	sblk_prog_page
.L1757:
	mov	w0, -1
	strb	wzr, [x19, #:lo12:.LANCHOR112]
	strb	w0, [x20, #:lo12:.LANCHOR151]
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
	stp	x23, x24, [sp, 48]
	and	w24, w0, 255
	adrp	x0, .LANCHOR15
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	stp	x25, x26, [sp, 64]
	cmp	w0, w24
	bhi	.L1763
	adrp	x1, .LANCHOR152
	adrp	x0, .LC0
	mov	w2, 494
	add	x1, x1, :lo12:.LANCHOR152
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1764:
	b	.L1764
.L1763:
	adrp	x0, .LANCHOR17
	add	x0, x0, :lo12:.LANCHOR17
	mov	w20, w1
	mov	x23, x2
	mov	x22, x3
	mov	w25, w4
	and	w21, w5, 255
	ldrb	w26, [x0, w24, sxtw]
	tst	x20, 50331648
	bne	.L1775
	adrp	x0, .LANCHOR18
	ldrb	w1, [x0, #:lo12:.LANCHOR18]
	adrp	x0, .LANCHOR19
	cbz	w1, .L1766
	ldrb	w1, [x0, #:lo12:.LANCHOR19]
	cbz	w1, .L1775
.L1766:
	adrp	x1, .LANCHOR20
	ldrb	w0, [x0, #:lo12:.LANCHOR19]
	ldrh	w1, [x1, #:lo12:.LANCHOR20]
	udiv	w19, w20, w1
	mul	w19, w19, w1
	sub	w1, w20, w19
	cbz	w0, .L1767
	add	w19, w19, w1, lsl 1
.L1765:
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 4, .L1768
	adrp	x0, .LC68
	mov	w2, w20
	mov	w1, w26
	add	x0, x0, :lo12:.LC68
	bl	printf
.L1768:
	mov	w0, w26
	mov	w4, w25
	mov	x3, x22
	mov	x2, x23
	mov	w1, w19
	bl	flash_prog_page
	mov	w26, w0
	cbz	w21, .L1769
	adrp	x21, .LANCHOR142
	adrp	x19, .LANCHOR143
	mov	w4, w25
	mov	w1, w20
	ldr	x3, [x21, #:lo12:.LANCHOR142]
	mov	w0, w24
	ldr	x2, [x19, #:lo12:.LANCHOR143]
	bl	flash_read_page_en
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L1770
	ldr	x0, [x19, #:lo12:.LANCHOR143]
	ldr	w1, [x23]
	ldr	w0, [x0]
	cmp	w1, w0
	bne	.L1770
	ldr	x0, [x21, #:lo12:.LANCHOR142]
	ldr	w1, [x22]
	ldr	w0, [x0]
	cmp	w1, w0
	beq	.L1769
.L1770:
	ldr	x1, [x21, #:lo12:.LANCHOR142]
	mov	w3, 4
	adrp	x0, .LC69
	mov	w2, w3
	add	x0, x0, :lo12:.LC69
	bl	rknand_print_hex
	ldr	x1, [x19, #:lo12:.LANCHOR143]
	mov	w3, 4
	adrp	x0, .LC70
	mov	w2, w3
	add	x0, x0, :lo12:.LC70
	bl	rknand_print_hex
.L1771:
	mov	w1, w20
	adrp	x0, .LC71
	add	x0, x0, :lo12:.LC71
	bl	printf
	adrp	x1, .LANCHOR152
	adrp	x0, .LC0
	mov	w2, 520
	add	x1, x1, :lo12:.LANCHOR152
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1773:
	b	.L1773
.L1767:
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	ldrh	w0, [x0, w1, uxtw 1]
	add	w19, w0, w19
	b	.L1765
.L1775:
	mov	w19, w20
	b	.L1765
.L1769:
	cmn	w26, #1
	beq	.L1771
	mov	w0, w26
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
	adrp	x25, .LANCHOR145
	stp	x21, x22, [sp, 32]
	adrp	x26, .LANCHOR100
	and	w21, w0, 65535
	add	x0, x26, :lo12:.LANCHOR100
	stp	x19, x20, [sp, 16]
	mov	w23, 0
	stp	x27, x28, [sp, 80]
	mov	w20, 0
	adrp	x27, .LANCHOR95
	str	x0, [x29, 112]
	str	wzr, [x24, #:lo12:ftl_tmp_buffer]
	add	x0, x27, :lo12:.LANCHOR95
	str	wzr, [x25, #:lo12:.LANCHOR145]
	str	x0, [x29, 96]
.L1787:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0]
	cmp	w0, w20
	bls	.L1797
	add	x0, x27, :lo12:.LANCHOR95
	mov	w22, 0
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	str	x0, [x29, 104]
	b	.L1798
.L1796:
	ldr	x0, [x29, 104]
	ldr	w0, [x0]
	tbz	x0, 12, .L1788
	adrp	x0, .LC72
	mov	w1, w21
	add	x0, x0, :lo12:.LC72
	bl	printf
.L1788:
	ldr	x0, [x29, 96]
	ldrb	w19, [x0]
	madd	w19, w21, w19, w22
	and	w19, w19, 65535
	cbnz	w20, .L1789
	adrp	x0, .LANCHOR12
	ldr	x0, [x0, #:lo12:.LANCHOR12]
	ldrb	w0, [x0, 47]
	cmp	w0, w19
	bcs	.L1790
.L1789:
	and	w28, w20, 255
	mov	w1, w19
	mov	w0, w28
	bl	flash_check_bad_block
	cbnz	w0, .L1790
	adrp	x0, .LANCHOR99
	mov	w1, w23
	ldrh	w7, [x0, #:lo12:.LANCHOR99]
	mov	w0, w28
	mul	w26, w7, w19
	mov	w2, w26
	bl	flash_erase_block_en
	cbz	w0, .L1791
	adrp	x0, .LANCHOR67
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	cmp	w0, 2
	bne	.L1813
	adrp	x0, .LANCHOR18
	ldrb	w0, [x0, #:lo12:.LANCHOR18]
	cbz	w0, .L1813
	mov	w2, w26
	mov	w1, 1
	mov	w0, w28
	bl	flash_erase_block_en
	cbnz	w0, .L1813
.L1795:
	adrp	x0, .LANCHOR67
	mov	w23, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	add	w26, w26, w0, lsl 24
.L1794:
	adrp	x0, .LANCHOR52
	mov	w5, 1
	add	x3, x25, :lo12:.LANCHOR145
	add	x2, x24, :lo12:ftl_tmp_buffer
	ldrb	w4, [x0, #:lo12:.LANCHOR52]
	mov	w1, w26
	mov	w0, w28
	bl	flash_prog_page_en
	cbz	w0, .L1790
.L1813:
	mov	w1, w19
	mov	w0, w28
	bl	flash_mask_bad_block
.L1790:
	add	w22, w22, 1
	and	w22, w22, 65535
.L1798:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, w22
	bhi	.L1796
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1787
.L1791:
	cbz	w23, .L1794
	b	.L1795
.L1797:
	cbz	w23, .L1799
	adrp	x0, .LANCHOR3
	mov	w1, 2
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x21, x0, x21, uxth 2
	ldrb	w0, [x21, 2]
	bfi	w0, w1, 3, 2
	strb	w0, [x21, 2]
.L1799:
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
	mov	w5, 1
	mov	w4, w23
	mov	x3, x22
	mov	x2, x21
	mov	w1, w20
	mov	w0, w19
	bl	flash_prog_page_en
	cmn	w0, #1
	bne	.L1814
	adrp	x1, .LANCHOR153
	adrp	x0, .LC0
	mov	w2, 2013
	add	x1, x1, :lo12:.LANCHOR153
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1816:
	b	.L1816
.L1814:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
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
	adrp	x21, .LANCHOR52
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR155
	ldrb	w2, [x21, #:lo12:.LANCHOR52]
	mov	x23, x22
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR99
	stp	x27, x28, [sp, 80]
	mov	w26, 0
	stp	x19, x20, [sp, 16]
	lsl	w2, w2, 1
	adrp	x20, .LANCHOR154
	str	w0, [x29, 108]
	mov	x24, x25
	add	x27, x22, :lo12:.LANCHOR155
	add	x28, x25, :lo12:.LANCHOR99
	add	x0, x20, :lo12:.LANCHOR154
	bl	ftl_memset
.L1819:
	add	x0, x22, :lo12:.LANCHOR155
	ldr	w1, [x29, 108]
	ldrb	w6, [x22, #:lo12:.LANCHOR155]
	ldrh	w19, [x25, #:lo12:.LANCHOR99]
	ldrh	w4, [x0, 2]
	adrp	x0, .LANCHOR53
	ldr	x0, [x0, #:lo12:.LANCHOR53]
	ldr	w3, [x0, 4]
	add	w3, w3, 1
	str	w3, [x0, 4]
	add	x0, x20, :lo12:.LANCHOR154
	str	w1, [x20, #:lo12:.LANCHOR154]
	str	w3, [x0, 4]
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L1820
	mov	w2, w4
	mov	w1, w6
	stp	w4, w6, [x29, 100]
	adrp	x0, .LC73
	add	x0, x0, :lo12:.LC73
	bl	printf
	ldp	w4, w6, [x29, 100]
.L1820:
	adrp	x1, .LANCHOR80
	ldrh	w0, [x27, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	cmp	w1, w0
	bhi	.L1821
	adrp	x1, .LANCHOR12
	ldrb	w0, [x27, 1]
	ldrb	w2, [x27]
	mov	w4, 0
	ldr	x6, [x1, #:lo12:.LANCHOR12]
.L1828:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 7
	bls	.L1822
	mov	x1, 0
.L1827:
	add	x3, x6, x1
	and	w7, w1, 65535
	ldrb	w8, [x3, 40]
	add	w3, w8, 127
	and	w3, w3, 255
	cmp	w3, 125
	bhi	.L1823
	add	x1, x23, :lo12:.LANCHOR155
	strb	w0, [x1, 1]
	cbz	w4, .L1824
	strb	w2, [x23, #:lo12:.LANCHOR155]
.L1824:
	adrp	x1, .LANCHOR156
	adrp	x0, .LC0
	mov	w2, 668
	add	x1, x1, :lo12:.LANCHOR156
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1825:
	b	.L1825
.L1823:
	cmp	w8, 255
	bne	.L1826
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L1827
	mov	w7, w1
.L1826:
	and	w0, w7, 255
	mov	w26, 1
.L1822:
	add	w1, w0, 8
	mov	w4, 1
	add	x1, x6, x1, sxtw
	ldrb	w2, [x1, 32]
	cmp	w2, 255
	beq	.L1828
	ldrh	w19, [x28]
	strb	w0, [x27, 1]
	mov	w0, 0
	strb	w2, [x27]
	mul	w19, w19, w2
	mov	w1, w19
	bl	flash_erase_block
	ldrb	w4, [x21, #:lo12:.LANCHOR52]
	mov	w1, w19
	add	x3, x20, :lo12:.LANCHOR154
	adrp	x2, ftl_info_data_buffer
	mov	w0, 0
	add	x2, x2, :lo12:ftl_info_data_buffer
	bl	ftl_prog_page
	mov	w0, 1
	add	w19, w19, w0
	strh	w0, [x27, 2]
.L1829:
	ldrb	w4, [x21, #:lo12:.LANCHOR52]
	mov	w1, w19
	add	x3, x20, :lo12:.LANCHOR154
	adrp	x2, ftl_info_data_buffer
	mov	w0, 0
	add	x2, x2, :lo12:ftl_info_data_buffer
	bl	ftl_prog_page
	cmn	w0, #1
	ldrh	w1, [x27, 2]
	add	w1, w1, 1
	strh	w1, [x27, 2]
	beq	.L1819
	cbnz	w26, .L1830
.L1838:
	ldrb	w0, [x23, #:lo12:.LANCHOR155]
	cmp	w0, 255
	bne	.L1854
	adrp	x1, .LANCHOR156
	adrp	x0, .LC0
	mov	w2, 703
	add	x1, x1, :lo12:.LANCHOR156
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1839:
	b	.L1839
.L1821:
	madd	w19, w19, w6, w4
	cbnz	w0, .L1829
	mov	w1, w19
	bl	flash_erase_block
	b	.L1829
.L1830:
	ldrb	w19, [x27, 1]
	add	x24, x24, :lo12:.LANCHOR99
	adrp	x20, .LANCHOR12
	add	w19, w19, 1
.L1833:
	cmp	w19, 7
	bhi	.L1838
	ldr	x1, [x20, #:lo12:.LANCHOR12]
	add	w0, w19, 8
	add	x0, x1, x0, sxtw
	ldrb	w0, [x0, 32]
	add	w1, w0, 127
	and	w1, w1, 255
	cmp	w1, 125
	bhi	.L1834
	adrp	x1, .LANCHOR156
	adrp	x0, .LC0
	mov	w2, 696
	add	x1, x1, :lo12:.LANCHOR156
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1835:
	b	.L1835
.L1834:
	cmp	w0, 255
	beq	.L1836
	ldrh	w1, [x24]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_erase_block
.L1836:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1833
.L1854:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
	.size	ftl_info_flush, .-ftl_info_flush
	.section	.text.ftl_info_blk_init,"ax",@progbits
	.align	2
	.global	ftl_info_blk_init
	.type	ftl_info_blk_init, %function
ftl_info_blk_init:
	stp	x29, x30, [sp, -128]!
	adrp	x0, .LANCHOR157
	adrp	x1, .LANCHOR3
	mov	w2, 16384
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, ftl_info_data_buffer
	strb	wzr, [x0, #:lo12:.LANCHOR157]
	add	x0, x20, :lo12:ftl_info_data_buffer
	str	x0, [x1, #:lo12:.LANCHOR3]
	adrp	x1, .LANCHOR2
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR2]
	adrp	x21, .LANCHOR155
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR99
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR12
	add	x1, x0, x1, lsl 2
	stp	x27, x28, [sp, 80]
	str	x1, [x22, #:lo12:.LANCHOR53]
	mov	w1, 0
	bl	ftl_memset
	adrp	x25, .LANCHOR52
	mov	w1, 0
	mov	w2, 16384
	adrp	x0, ftl_ext_info_data_buffer
	add	x0, x0, :lo12:ftl_ext_info_data_buffer
	bl	ftl_memset
	mov	w27, 21574
	ldr	x1, [x23, #:lo12:.LANCHOR12]
	add	x0, x21, :lo12:.LANCHOR155
	add	x26, x26, :lo12:.LANCHOR99
	add	x25, x25, :lo12:.LANCHOR52
	mov	x19, 7
	movk	w27, 0x494c, lsl 16
	strb	wzr, [x0, 1]
	ldrb	w1, [x1, 40]
	strb	w1, [x21, #:lo12:.LANCHOR155]
	strh	wzr, [x0, 2]
.L1858:
	ldr	x1, [x23, #:lo12:.LANCHOR12]
	add	w0, w19, 8
	sxth	w24, w19
	mov	w28, w19
	add	x0, x1, x0, sxtw
	ldrb	w0, [x0, 32]
	cmp	w0, 255
	bne	.L1857
.L1862:
	sub	x19, x19, #1
	cmn	x19, #1
	bne	.L1858
	mov	w24, 0
.L1859:
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L1863
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	mov	w2, 4800
	mov	w1, w19
	ldr	w3, [x0]
	adrp	x0, .LC75
	add	x0, x0, :lo12:.LC75
	bl	printf
.L1863:
	cmn	w19, #1
	bne	.L1864
	mov	w1, 0
	mov	w2, 16384
	add	x0, x20, :lo12:ftl_info_data_buffer
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	mov	w1, 21574
	movk	w1, 0x494c, lsl 16
	str	w1, [x0]
	mov	w0, w19
.L1856:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1857:
	ldrh	w6, [x26]
	add	x8, x20, :lo12:ftl_info_data_buffer
	ldrb	w4, [x25]
	adrp	x7, .LANCHOR154
	add	x7, x7, :lo12:.LANCHOR154
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
	bne	.L1860
	ldrb	w4, [x25]
	mov	x3, x7
	mov	x2, x8
	add	w1, w6, 1
	mov	w0, 0
	bl	ftl_read_page
	mov	w5, w0
.L1860:
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L1861
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	mov	w2, w5
	str	w5, [x29, 124]
	mov	w3, 576
	mov	w1, w28
	ldr	w4, [x0]
	adrp	x0, .LC74
	add	x0, x0, :lo12:.LC74
	bl	printf
	ldr	w5, [x29, 124]
.L1861:
	cmn	w5, #1
	beq	.L1862
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L1862
	mov	w19, w24
	b	.L1859
.L1864:
	ldr	x1, [x23, #:lo12:.LANCHOR12]
	add	w0, w24, 8
	add	x20, x20, :lo12:ftl_info_data_buffer
	mov	w4, 4
	mov	x2, x20
	adrp	x26, .LANCHOR52
	add	x0, x1, x0, sxtw
	mov	w27, 21574
	add	x26, x26, :lo12:.LANCHOR52
	movk	w27, 0x494c, lsl 16
	ldrb	w1, [x0, 32]
	add	x0, x21, :lo12:.LANCHOR155
	strb	w1, [x21, #:lo12:.LANCHOR155]
	strb	w24, [x0, 1]
	adrp	x24, .LANCHOR154
	add	x24, x24, :lo12:.LANCHOR154
	mov	w0, 0
	mov	x3, x24
	bl	flash_get_last_written_page
	sxth	w23, w0
	add	w0, w0, 1
	and	w19, w0, 65535
	adrp	x0, .LANCHOR99
	ldrb	w25, [x21, #:lo12:.LANCHOR155]
	ldrh	w0, [x0, #:lo12:.LANCHOR99]
	madd	w25, w25, w0, w23
.L1866:
	tbnz	w23, #31, .L1871
	ldrb	w4, [x26]
	mov	x3, x24
	mov	x2, x20
	mov	w1, w25
	mov	w0, 0
	bl	ftl_read_page
	cmn	w0, #1
	beq	.L1867
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L1867
.L1871:
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	add	x21, x21, :lo12:.LANCHOR155
	strh	w19, [x21, 2]
	ldr	w1, [x0, 16]
	cmp	w1, 2048
	bhi	.L1868
.L1869:
	ldr	w1, [x0, 24]
	cmp	w1, 2048
	bls	.L1872
	ldr	w2, [x0, 28]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 24]
.L1872:
	ldr	w1, [x0, 32]
	cmp	w1, 1024
	bls	.L1873
	ldr	w2, [x0, 36]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 32]
.L1873:
	ldr	w1, [x0, 40]
	cmp	w1, 1024
	bls	.L1874
	ldr	w2, [x0, 44]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 40]
.L1874:
	ldr	w1, [x0, 64]
	add	w1, w1, 1
	str	w1, [x0, 64]
	mov	w0, 0
	bl	ftl_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	mov	w0, 0
	b	.L1856
.L1867:
	sub	w23, w23, #1
	sub	w25, w25, #1
	sxth	w23, w23
	b	.L1866
.L1868:
	ldr	w2, [x0, 20]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 16]
	b	.L1869
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
	str	x27, [sp, 80]
	cbz	w1, .L1890
	str	wzr, [x0, 520]
.L1890:
	adrp	x24, .LANCHOR53
	adrp	x20, .LANCHOR80
	adrp	x21, .LANCHOR96
	add	x20, x20, :lo12:.LANCHOR80
	mov	x22, x24
	add	x21, x21, :lo12:.LANCHOR96
	mov	w0, 0
	bl	ftl_total_vpn_update
.L1899:
	ldr	x0, [x24, #:lo12:.LANCHOR53]
	ldr	w1, [x0, 56]
	add	w1, w1, 1
	str	w1, [x0, 56]
	ldrh	w1, [x0, 140]
	ldrh	w0, [x20]
	cmp	w1, w0
	bcc	.L1891
	bl	ftl_ext_alloc_new_blk
.L1891:
	ldr	x2, [x22, #:lo12:.LANCHOR53]
	mov	w0, 65535
	ldrh	w1, [x2, 130]
	cmp	w1, w0
	bne	.L1892
	adrp	x1, .LANCHOR158
	adrp	x0, .LC0
	mov	w2, 1603
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1893:
	b	.L1893
.L1892:
	ldrh	w0, [x21]
	mov	w19, 21
	adrp	x25, .LANCHOR52
	adrp	x26, .LANCHOR154
	sub	w0, w19, w0
	mov	w19, 1
	add	x23, x26, :lo12:.LANCHOR154
	asr	w27, w1, w0
	lsl	w19, w19, w0
	adrp	x0, .LANCHOR99
	sub	w19, w19, #1
	and	w19, w19, w1
	ldrh	w1, [x0, #:lo12:.LANCHOR99]
	ldrh	w0, [x2, 140]
	ldrb	w2, [x25, #:lo12:.LANCHOR52]
	madd	w19, w19, w1, w0
	lsl	w2, w2, 1
	mov	w1, 0
	mov	x0, x23
	bl	ftl_memset
	and	w19, w19, 65535
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	mov	w1, w19
	ldrb	w4, [x25, #:lo12:.LANCHOR52]
	mov	x3, x23
	str	wzr, [x26, #:lo12:.LANCHOR154]
	adrp	x2, ftl_ext_info_data_buffer
	add	x2, x2, :lo12:ftl_ext_info_data_buffer
	ldr	w0, [x0, 56]
	str	w0, [x23, 4]
	mov	w0, w27
	bl	ftl_prog_page
	ldr	x2, [x22, #:lo12:.LANCHOR53]
	ldrh	w1, [x2, 140]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 140]
	cmp	w1, 1
	beq	.L1899
	cmn	w0, #1
	beq	.L1899
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
	.size	ftl_ext_info_flush, .-ftl_ext_info_flush
	.section	.text.ftl_ext_info_init,"ax",@progbits
	.align	2
	.global	ftl_ext_info_init
	.type	ftl_ext_info_init, %function
ftl_ext_info_init:
	stp	x29, x30, [sp, -112]!
	adrp	x0, .LANCHOR109
	mov	w4, 4
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR53
	strh	wzr, [x0, #:lo12:.LANCHOR109]
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	adrp	x25, ftl_ext_info_data_buffer
	stp	x23, x24, [sp, 48]
	add	x2, x25, :lo12:ftl_ext_info_data_buffer
	ldrh	w19, [x0, 130]
	adrp	x0, .LANCHOR96
	stp	x27, x28, [sp, 80]
	adrp	x24, .LANCHOR154
	ldrh	w1, [x0, #:lo12:.LANCHOR96]
	mov	w0, 21
	and	w26, w19, 16383
	add	x3, x24, :lo12:.LANCHOR154
	sub	w0, w0, w1
	mov	w1, w26
	asr	w19, w19, w0
	and	w19, w19, 255
	mov	w0, w19
	bl	flash_get_last_written_page
	sxth	w21, w0
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L1905
	adrp	x1, .LANCHOR159
	adrp	x0, .LC33
	mov	w3, w21
	mov	w2, 1646
	add	x1, x1, :lo12:.LANCHOR159
	add	x0, x0, :lo12:.LC33
	bl	printf
.L1905:
	adrp	x27, .LANCHOR52
	adrp	x28, .LANCHOR99
	mov	w5, 20038
	add	x27, x27, :lo12:.LANCHOR52
	add	x28, x28, :lo12:.LANCHOR99
	mov	w23, 0
	movk	w5, 0x4549, lsl 16
.L1906:
	and	w20, w21, 65535
	sub	w0, w20, w23
	tbnz	x0, 15, .L1911
	ldrh	w0, [x28]
	sub	w1, w21, w23
	ldrb	w4, [x27]
	add	x3, x24, :lo12:.LANCHOR154
	str	w5, [x29, 108]
	add	x2, x25, :lo12:ftl_ext_info_data_buffer
	madd	w1, w0, w26, w1
	mov	w0, w19
	bl	flash_read_page_en
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	ldr	w5, [x29, 108]
	beq	.L1907
	adrp	x0, .LANCHOR5
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldr	w0, [x0]
	cmp	w0, w5
	bne	.L1907
.L1911:
	bl	zftl_sblk_list_init
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	ldrh	w1, [x0, 140]
	cmp	w1, w21
	bgt	.L1909
	add	w20, w20, 1
	strh	w20, [x0, 140]
	bl	ftl_ext_info_flush
.L1909:
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
	adrp	x0, .LANCHOR110
	strh	w1, [x0, #:lo12:.LANCHOR110]
	mov	w0, 0
	ldp	x29, x30, [sp], 112
	ret
.L1907:
	add	w23, w23, 1
	b	.L1906
	.size	ftl_ext_info_init, .-ftl_ext_info_init
	.section	.text.ftl_low_format,"ax",@progbits
	.align	2
	.global	ftl_low_format
	.type	ftl_low_format, %function
ftl_low_format:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR99
	stp	x21, x22, [sp, 32]
	add	x20, x20, :lo12:.LANCHOR99
	stp	x25, x26, [sp, 64]
	adrp	x21, .LANCHOR12
	mov	x25, x21
	stp	x23, x24, [sp, 48]
	mov	w19, 8
.L1923:
	ldr	x0, [x21, #:lo12:.LANCHOR12]
	add	x0, x0, x19, sxtw
	ldrb	w0, [x0, 32]
	add	w1, w0, 127
	and	w1, w1, 255
	cmp	w1, 125
	bhi	.L1920
	adrp	x1, .LANCHOR160
	adrp	x0, .LC0
	mov	w2, 1817
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1921:
	b	.L1921
.L1920:
	cmp	w0, 255
	beq	.L1922
	ldrh	w1, [x20]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_erase_block
.L1922:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L1923
	bl	sblk_init
	adrp	x19, .LANCHOR53
	bl	ftl_info_blk_init
	adrp	x22, .LANCHOR3
	mov	w1, 0
	mov	w2, 16384
	adrp	x0, ftl_info_data_buffer
	add	x0, x0, :lo12:ftl_info_data_buffer
	bl	ftl_memset
	adrp	x20, .LANCHOR2
	ldr	x3, [x19, #:lo12:.LANCHOR53]
	mov	w5, 1
	ldr	x1, [x22, #:lo12:.LANCHOR3]
	ldrh	w4, [x20, #:lo12:.LANCHOR2]
	ldrh	w0, [x3, 134]
	add	x1, x1, x0, uxth 2
.L1924:
	cmp	w0, w4
	bcc	.L1925
	mov	w0, 21574
	adrp	x24, .LANCHOR60
	add	x24, x24, :lo12:.LANCHOR60
	movk	w0, 0x494c, lsl 16
	strh	wzr, [x3, 148]
	mov	w21, 0
	mov	w26, 1
	str	w0, [x3]
.L1926:
	ldrh	w0, [x20, #:lo12:.LANCHOR2]
	adrp	x23, .LANCHOR95
	cmp	w0, w21
	bhi	.L1934
	adrp	x21, .LANCHOR5
	mov	w2, 16384
	mov	w1, 0
	adrp	x0, ftl_ext_info_data_buffer
	add	x0, x0, :lo12:ftl_ext_info_data_buffer
	bl	ftl_memset
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	mov	w1, 20038
	ldr	x7, [x19, #:lo12:.LANCHOR53]
	movk	w1, 0x4549, lsl 16
	ldr	x2, [x22, #:lo12:.LANCHOR3]
	mov	w5, 3
	ldrh	w3, [x7, 148]
	str	w1, [x0]
	mov	w1, 2
	ldr	x0, [x25, #:lo12:.LANCHOR12]
	ldrb	w6, [x23, #:lo12:.LANCHOR95]
	cmp	w6, 1
	ldrb	w0, [x0, 47]
	csinc	w5, w5, wzr, ne
	csinc	w1, w1, wzr, ne
	and	w5, w5, 255
	and	w1, w1, 65535
	udiv	w0, w0, w6
	and	w8, w0, 65535
	ubfiz	x0, x0, 2, 8
	add	x0, x0, 4
	add	w24, w8, 1
	add	x0, x2, x0
.L1935:
	ldrb	w4, [x2, 2]
	add	x2, x2, 4
	strb	w5, [x2, -1]
	orr	w4, w4, -32
	strb	w4, [x2, -2]
	cmp	x2, x0
	bne	.L1935
	add	w0, w1, w3
	mov	w4, 16
	mul	w1, w1, w8
	sdiv	w4, w4, w6
	add	w1, w1, w0, uxth
	adrp	x0, .LANCHOR29
	strh	w1, [x7, 148]
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	add	w4, w24, w4
	and	w4, w4, 65535
	strh	w4, [x7, 134]
	tbz	x0, 12, .L1936
	adrp	x0, .LC76
	mov	w3, w24
	mov	w2, 128
	mov	w1, 1862
	add	x0, x0, :lo12:.LC76
	bl	printf
.L1936:
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	mov	w2, 128
	mov	w1, 255
	add	x0, x0, 160
	bl	ftl_memset
	ldrb	w6, [x23, #:lo12:.LANCHOR95]
	adrp	x0, .LANCHOR100
	ldr	x11, [x22, #:lo12:.LANCHOR3]
	adrp	x22, .LANCHOR96
	ldr	x8, [x19, #:lo12:.LANCHOR53]
	and	w7, w6, 65535
	ldrb	w12, [x0, #:lo12:.LANCHOR100]
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
.L1937:
	cmp	w24, w10
	bcc	.L1943
	adrp	x0, .LANCHOR4
	ldrh	w2, [x20, #:lo12:.LANCHOR2]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	lsl	w2, w2, 1
	bl	ftl_memset
	bl	zftl_sblk_list_init
	ldr	x0, [x19, #:lo12:.LANCHOR53]
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
	ldr	x1, [x19, #:lo12:.LANCHOR53]
	mov	w0, w23
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	mov	w1, 65533
	ldrh	w20, [x0, 672]
	strh	wzr, [x0, 690]
	sub	w2, w20, #1
	cmp	w1, w2, uxth
	bcs	.L1944
	adrp	x1, .LANCHOR160
	adrp	x0, .LC0
	mov	w2, 1893
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1945:
	b	.L1945
.L1925:
	ldrb	w2, [x1, 2]
	add	w0, w0, 1
	and	w0, w0, 65535
	add	x1, x1, 4
	and	w2, w2, 31
	bfi	w2, w5, 3, 2
	strb	w2, [x1, -2]
	b	.L1924
.L1934:
	strh	w21, [x24]
	mov	w0, w21
	bl	ftl_test_block
	ldrb	w11, [x23, #:lo12:.LANCHOR95]
	adrp	x0, .LANCHOR100
	ldr	x6, [x22, #:lo12:.LANCHOR3]
	mov	w7, 0
	ldrb	w14, [x0, #:lo12:.LANCHOR100]
	mov	w10, 0
	ldr	x13, [x19, #:lo12:.LANCHOR53]
	mov	w8, 0
	mul	w12, w21, w11
	add	x6, x6, x21, uxth 2
.L1927:
	cmp	w8, w14
	bcs	.L1931
	add	w15, w11, w7
	b	.L1932
.L1930:
	add	w1, w7, w12
	mov	w0, w8
	bl	flash_check_bad_block
	cbz	w0, .L1928
	ldrb	w1, [x6, 3]
	lsl	w0, w26, w7
	orr	w0, w0, w1
	strb	w0, [x6, 3]
	ldrh	w0, [x13, 148]
	add	w0, w0, 1
	strh	w0, [x13, 148]
.L1929:
	add	w7, w7, 1
.L1932:
	cmp	w7, w15
	bne	.L1930
	add	w8, w8, 1
	sub	w12, w12, w11
	and	w8, w8, 65535
	b	.L1927
.L1928:
	add	w10, w10, 1
	and	w10, w10, 65535
	b	.L1929
.L1931:
	cbnz	w10, .L1933
	ldrb	w0, [x6, 2]
	orr	w0, w0, -32
	strb	w0, [x6, 2]
.L1933:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L1926
.L1943:
	add	x13, x11, x24, uxth 2
	mov	w14, 0
	mov	w15, 0
	mov	w3, 0
	ldrb	w0, [x13, 2]
	orr	w0, w0, -32
	strb	w0, [x13, 2]
.L1938:
	cmp	w3, w12
	bcc	.L1947
	add	w24, w24, 1
	add	w1, w7, w1
	and	w24, w24, 65535
	and	w1, w1, 65535
	b	.L1937
.L1941:
	ldrb	w5, [x13, 3]
	add	w16, w15, w4
	asr	w5, w5, w16
	tbnz	x5, 0, .L1939
	cmp	w6, 1
	bls	.L1946
	and	w0, w0, 1
	add	w0, w1, w0
	and	w0, w0, 65535
.L1940:
	add	x5, x8, x23, sxtw 1
	add	w23, w23, 1
	and	w23, w23, 65535
	add	w0, w0, w14
	strh	w0, [x5, 160]
.L1939:
	add	x4, x4, 1
.L1942:
	and	w0, w4, 65535
	cmp	w0, w7
	bcc	.L1941
	add	w3, w3, 1
	add	w0, w2, w14
	and	w3, w3, 65535
	add	w15, w15, w6
	and	w14, w0, 65535
	b	.L1938
.L1946:
	mov	w0, w1
	b	.L1940
.L1947:
	mov	x4, 0
	b	.L1942
.L1944:
	strh	wzr, [x0, 696]
	mov	w2, 256
	mov	w1, 255
	add	x0, x0, 416
	bl	ftl_memset
	ldrh	w2, [x22, #:lo12:.LANCHOR96]
	mov	w1, 21
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	sub	w1, w1, w2
	asr	w1, w20, w1
	strh	w1, [x0, 694]
	mov	w1, 1
	strh	w1, [x0, 688]
	adrp	x1, .LANCHOR161
	strh	w20, [x0, 692]
	ldrh	w1, [x1, #:lo12:.LANCHOR161]
	strh	w23, [x0, 416]
	strh	w1, [x0, 698]
	bl	ftl_alloc_sys_blk
	mov	w20, w0
	mov	w1, 0
	bl	ftl_erase_phy_blk
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	mov	w1, 2
	strh	w20, [x0, 130]
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	add	x0, x0, 16
	bl	ftl_open_sblk_init
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	mov	w1, 3
	add	x0, x0, 48
	bl	ftl_open_sblk_init
	ldr	x1, [x19, #:lo12:.LANCHOR53]
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
	.size	ftl_low_format, .-ftl_low_format
	.section	.text.ftl_re_low_format_test,"ax",@progbits
	.align	2
	.global	ftl_re_low_format_test
	.type	ftl_re_low_format_test, %function
ftl_re_low_format_test:
	stp	x29, x30, [sp, -64]!
	mov	w1, 1
	adrp	x0, .LC77
	add	x0, x0, :lo12:.LC77
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR53
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR2
	str	x23, [sp, 48]
	bl	printf
	bl	sblk_init
	bl	ftl_info_blk_init
	bl	ftl_ext_info_init
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	adrp	x3, .LANCHOR3
	ldrh	w2, [x21, #:lo12:.LANCHOR2]
	mov	w4, 0
	ldr	x3, [x3, #:lo12:.LANCHOR3]
	mov	w5, 0
	mov	w6, 0
	ldrh	w1, [x0, 134]
	add	x3, x3, x1, uxth 2
.L1958:
	cmp	w1, w2
	bcc	.L1962
	adrp	x22, .LANCHOR4
	strh	w6, [x0, 114]
	strh	w5, [x0, 118]
	lsl	w2, w2, 1
	strh	w4, [x0, 116]
	mov	w1, 0
	strh	wzr, [x0, 122]
	strh	wzr, [x0, 120]
	strh	wzr, [x0, 124]
	ldr	x0, [x22, #:lo12:.LANCHOR4]
	bl	ftl_memset
	bl	zftl_sblk_list_init
	mov	w0, 1
	bl	ftl_alloc_sblk
	mov	w1, 0
	mov	w23, w0
	bl	ftl_erase_sblk
	ldr	x1, [x19, #:lo12:.LANCHOR53]
	mov	w0, w23
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	mov	w1, 65533
	ldrh	w20, [x0, 672]
	strh	wzr, [x0, 690]
	sub	w2, w20, #1
	cmp	w1, w2, uxth
	bcs	.L1963
	adrp	x1, .LANCHOR162
	adrp	x0, .LC0
	mov	w2, 1965
	add	x1, x1, :lo12:.LANCHOR162
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1964:
	b	.L1964
.L1962:
	ldrb	w7, [x3, 2]
	and	w8, w7, 31
	strb	w8, [x3, 2]
	ands	w7, w7, 24
	bne	.L1959
	add	w6, w6, 1
	and	w6, w6, 65535
.L1960:
	add	w1, w1, 1
	add	x3, x3, 4
	and	w1, w1, 65535
	b	.L1958
.L1959:
	cmp	w7, 16
	bne	.L1961
	add	w5, w5, 1
	and	w5, w5, 65535
	b	.L1960
.L1961:
	add	w4, w4, 1
	and	w4, w4, 65535
	b	.L1960
.L1963:
	strh	wzr, [x0, 696]
	mov	w2, 256
	mov	w1, 255
	add	x0, x0, 416
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	mov	w2, 4096
	mov	w1, 0
	add	x0, x0, 704
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	lsr	w1, w20, 14
	and	w20, w20, 16383
	ldrh	w2, [x21, #:lo12:.LANCHOR2]
	strh	w1, [x0, 694]
	mov	w1, 1
	strh	w1, [x0, 688]
	adrp	x1, .LANCHOR161
	strh	w20, [x0, 692]
	adrp	x20, .LANCHOR5
	ldrh	w1, [x1, #:lo12:.LANCHOR161]
	lsl	w2, w2, 1
	strh	w23, [x0, 416]
	strh	w1, [x0, 698]
	mov	w1, 0
	ldr	x0, [x22, #:lo12:.LANCHOR4]
	bl	ftl_memset
	ldr	x0, [x20, #:lo12:.LANCHOR5]
	mov	w1, 2
	add	x0, x0, 16
	bl	ftl_open_sblk_init
	ldr	x0, [x20, #:lo12:.LANCHOR5]
	mov	w1, 3
	add	x0, x0, 48
	bl	ftl_open_sblk_init
	ldr	x1, [x19, #:lo12:.LANCHOR53]
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
	bne	.L1969
	stp	x29, x30, [sp, -48]!
	adrp	x1, .LANCHOR105
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	ldr	x20, [x1, #:lo12:.LANCHOR105]
	ldrh	w22, [x0, 12]
	bl	ftl_get_new_free_page
	mov	w21, w0
	cmn	w0, #1
	beq	.L1970
	ldrh	w0, [x19]
	add	x20, x20, x22, uxth 2
	bl	ftl_vpn_decrement
	adrp	x0, .LANCHOR145
	mov	w1, 15555
	add	x6, x0, :lo12:.LANCHOR145
	movk	w1, 0xf55f, lsl 16
	str	w1, [x0, #:lo12:.LANCHOR145]
	adrp	x0, .LANCHOR80
	ldrh	w1, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR72
	ldrb	w0, [x0, #:lo12:.LANCHOR72]
	mul	w1, w1, w0
	mov	x0, x20
	lsl	w1, w1, 2
	bl	js_hash
	stp	w0, wzr, [x6, 4]
	adrp	x0, .LANCHOR52
	mov	x2, x6
	mov	x1, x20
	ldrb	w3, [x0, #:lo12:.LANCHOR52]
	mov	w0, w21
	str	wzr, [x6, 12]
	bl	ftl_prog_ppa_page
.L1970:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L1969:
	mov	w0, -1
	ret
	.size	ftl_write_last_log_page, .-ftl_write_last_log_page
	.section	.text.ftl_open_sblk_recovery,"ax",@progbits
	.align	2
	.global	ftl_open_sblk_recovery
	.type	ftl_open_sblk_recovery, %function
ftl_open_sblk_recovery:
	sub	sp, sp, #176
	stp	x29, x30, [sp, 48]
	add	x29, sp, 48
	stp	x21, x22, [sp, 80]
	adrp	x22, .LANCHOR29
	stp	x27, x28, [sp, 128]
	mov	x28, x0
	ldr	w0, [x22, #:lo12:.LANCHOR29]
	stp	x25, x26, [sp, 112]
	mov	x25, x1
	stp	x19, x20, [sp, 64]
	stp	x23, x24, [sp, 96]
	tbz	x0, 12, .L1976
	ldrh	w1, [x28, 2]
	adrp	x0, .LC78
	add	x0, x0, :lo12:.LC78
	bl	printf
.L1976:
	ldr	w0, [x22, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L1977
	ldrb	w1, [x28, 5]
	adrp	x0, .LC79
	add	x0, x0, :lo12:.LC79
	bl	printf
.L1977:
	ldr	w0, [x22, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L1978
	ldrh	w1, [x28]
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	bl	printf
.L1978:
	ldr	w0, [x22, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L1979
	ldrh	w2, [x28, 18]
	adrp	x0, .LC81
	ldrh	w1, [x28, 16]
	add	x0, x0, :lo12:.LC81
	bl	printf
.L1979:
	ldrh	w0, [x28, 10]
	adrp	x26, .LANCHOR52
	strh	w0, [x28, 14]
	mov	w27, 0
	mov	w0, 1
	adrp	x23, .LANCHOR80
	bl	buf_alloc
	ldrb	w20, [x28, 5]
	ldrh	w21, [x28, 2]
	mov	x19, x0
	add	x0, x26, :lo12:.LANCHOR52
	str	x0, [x29, 120]
.L1980:
	ldrh	w0, [x23, #:lo12:.LANCHOR80]
	cmp	w0, w21
	bhi	.L1996
.L1983:
	strb	w20, [x28, 5]
	ldrh	w0, [x23, #:lo12:.LANCHOR80]
	ldrb	w20, [x28, 9]
	ldrh	w2, [x28, 10]
	ldrh	w1, [x28, 6]
	strh	w21, [x28, 2]
	mul	w20, w20, w0
	add	w1, w1, w2
	cmp	w1, w20
	bne	.L1997
	adrp	x21, .LANCHOR105
	mov	w0, 0
	mov	w1, 0
	ldr	x4, [x21, #:lo12:.LANCHOR105]
.L1998:
	cmp	w1, w2
	bcc	.L2001
	sub	w20, w20, w2
	adrp	x24, .LANCHOR4
	add	w0, w0, w20
	and	w20, w0, 65535
	ldr	w0, [x22, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L2002
	ldrh	w1, [x28]
	ldr	x2, [x24, #:lo12:.LANCHOR4]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC83
	mov	w2, w20
	add	x0, x0, :lo12:.LC83
	bl	printf
.L2002:
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	adrp	x25, .LANCHOR52
	ldrh	w1, [x28]
	adrp	x24, .LANCHOR72
	adrp	x26, .LC84
	add	x24, x24, :lo12:.LANCHOR72
	add	x25, x25, :lo12:.LANCHOR52
	add	x26, x26, :lo12:.LC84
	strh	w20, [x0, x1, lsl 1]
	mov	w20, 0
	mov	x0, x19
	bl	buf_free
.L2003:
	ldrb	w0, [x24]
	cmp	w20, w0, lsl 1
	bcc	.L2006
	ldrh	w1, [x28, 12]
	ldrh	w0, [x23, #:lo12:.LANCHOR80]
	ldrb	w2, [x28, 9]
	madd	w0, w0, w2, w1
	mov	x1, -4
	add	x0, x1, x0, sxtw 2
	ldr	x1, [x21, #:lo12:.LANCHOR105]
	ldr	w0, [x1, x0]
	cmn	w0, #1
	beq	.L2007
	adrp	x1, .LANCHOR163
	adrp	x0, .LC0
	mov	w2, 1359
	add	x1, x1, :lo12:.LANCHOR163
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2008:
	b	.L2008
.L1996:
	ldrb	w20, [x28, 5]
	adrp	x24, .LANCHOR99
	add	x24, x24, :lo12:.LANCHOR99
.L1981:
	ldrb	w0, [x28, 9]
	cmp	w0, w20
	bhi	.L1995
	add	w21, w21, 1
	strb	wzr, [x28, 5]
	and	w21, w21, 65535
	b	.L1980
.L1995:
	add	x0, x28, x20, sxtw 1
	ldrh	w12, [x0, 16]
	mov	w0, 65535
	cmp	w12, w0
	beq	.L1982
	ldrh	w11, [x24]
	ldrb	w3, [x26, #:lo12:.LANCHOR52]
	ldr	x1, [x19, 8]
	ldr	x2, [x19, 24]
	madd	w11, w11, w12, w21
	stp	w12, w11, [x29, 108]
	mov	w0, w11
	bl	ftl_read_ppa_page
	mov	w10, w0
	cmp	w0, 512
	beq	.L1983
	cmn	w0, #1
	ldp	w12, w11, [x29, 108]
	beq	.L1984
	ldr	x0, [x19, 24]
	ldr	w1, [x0]
	cmn	w1, #1
	bne	.L1984
	ldr	w0, [x0, 4]
	cmn	w0, #1
	bne	.L1984
	ldr	x0, [x19, 8]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L1983
.L1984:
	ldr	w0, [x22, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L1985
	ldr	x1, [x19, 24]
	mov	w4, w10
	ldr	x0, [x19, 8]
	mov	w3, w11
	str	w10, [x29, 112]
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
	mov	w1, w12
	ldp	w5, w6, [x0]
	ldr	w7, [x0, 8]
	adrp	x0, .LC82
	add	x0, x0, :lo12:.LC82
	bl	printf
	ldr	w10, [x29, 112]
.L1985:
	ldrb	w2, [x28, 9]
	adrp	x0, .LANCHOR157
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR157]
	ldrh	w0, [x28, 10]
	madd	w1, w21, w2, w20
	cmp	w0, w1
	beq	.L1986
	adrp	x1, .LANCHOR163
	adrp	x0, .LC0
	mov	w2, 1255
	add	x1, x1, :lo12:.LANCHOR163
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1987:
	b	.L1987
.L1986:
	ldrh	w1, [x28, 6]
	add	w1, w1, w0
	ldrh	w0, [x23, #:lo12:.LANCHOR80]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L1988
	adrp	x1, .LANCHOR163
	adrp	x0, .LC0
	mov	w2, 1256
	add	x1, x1, :lo12:.LANCHOR163
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1989:
	b	.L1989
.L1988:
	cmn	w10, #1
	beq	.L1991
	ldr	x5, [x19, 24]
	str	x5, [x29, 112]
	ldr	w0, [x5, 4]
	cmn	w0, #1
	beq	.L1991
	bl	lpa_hash_get_ppa
	cbz	x25, .L1993
	ldr	x5, [x29, 112]
	ldr	w1, [x5, 8]
	cmp	w0, w1
	beq	.L1993
	cmn	w0, #1
	beq	.L1993
	adrp	x3, .LANCHOR96
	mov	w1, 21
	adrp	x27, .LANCHOR95
	ldrh	w6, [x3, #:lo12:.LANCHOR96]
	sub	w4, w1, w6
	mov	w1, 1
	lsr	w2, w0, w6
	lsl	w1, w1, w4
	sub	w1, w1, #1
	and	w1, w1, w2
	ldrb	w2, [x27, #:lo12:.LANCHOR95]
	mov	x4, x3
	udiv	w1, w1, w2
	ldrh	w2, [x25]
	cmp	w2, w1, uxth
	bne	.L1993
	ldr	x1, [x29, 120]
	ldr	w6, [x5]
	adrp	x5, .LANCHOR154
	str	w6, [x29, 108]
	add	x2, x5, :lo12:.LANCHOR154
	str	x5, [x29, 112]
	ldrb	w3, [x1]
	ldr	x1, [x19, 8]
	str	x4, [x29, 96]
	bl	ftl_read_ppa_page
	ldr	x5, [x29, 112]
	ldr	w6, [x29, 108]
	ldr	w0, [x5, #:lo12:.LANCHOR154]
	cmp	w6, w0
	bhi	.L1993
	ldr	x0, [x19, 24]
	ldr	w1, [x0, 8]
	cmn	w1, #1
	beq	.L1991
	ldr	x4, [x29, 96]
	mov	w0, 21
	ldrh	w3, [x4, #:lo12:.LANCHOR96]
	sub	w2, w0, w3
	mov	w0, 1
	lsr	w1, w1, w3
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	ldrb	w1, [x27, #:lo12:.LANCHOR95]
	udiv	w0, w0, w1
	bl	ftl_vpn_decrement
.L1991:
	ldrh	w0, [x28, 6]
	mov	w27, 1
	sub	w0, w0, #1
	strh	w0, [x28, 6]
	ldrh	w0, [x28, 10]
	add	w0, w0, 1
	strh	w0, [x28, 10]
.L1982:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1981
.L1997:
	adrp	x1, .LANCHOR163
	adrp	x0, .LC0
	mov	w2, 1332
	add	x1, x1, :lo12:.LANCHOR163
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1999:
	b	.L1999
.L2001:
	ldrh	w3, [x28, 12]
	add	w3, w3, w1
	ldr	w3, [x4, x3, lsl 2]
	cmn	w3, #1
	beq	.L2000
	add	w0, w0, 1
	and	w0, w0, 65535
.L2000:
	add	w1, w1, 1
	b	.L1998
.L2006:
	cbz	w27, .L2004
	ldrh	w0, [x28, 6]
	cmp	w0, 1
	bls	.L2004
	mov	x0, x28
	bl	ftl_get_new_free_page
	mov	w4, w0
	ldr	w0, [x22, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L2005
	mov	w1, w4
	str	w4, [x29, 120]
	mov	x0, x26
	bl	printf
	ldr	w4, [x29, 120]
.L2005:
	adrp	x0, .LANCHOR53
	ldr	x2, [x19, 24]
	ldr	x1, [x19, 8]
	ldr	x0, [x0, #:lo12:.LANCHOR53]
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
.L2004:
	add	w20, w20, 1
	b	.L2003
.L2007:
	ldrh	w0, [x28, 6]
	cmp	w0, 1
	bne	.L1975
	ldp	x19, x20, [sp, 64]
	mov	x0, x28
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 176
	b	ftl_write_last_log_page
.L1993:
	ldr	x3, [x19, 24]
	adrp	x0, .LANCHOR54
	ldr	w0, [x0, #:lo12:.LANCHOR54]
	ldr	w1, [x3, 4]
	cmp	w1, w0
	bcs	.L1991
	ldrb	w0, [x28, 9]
	ldrh	w1, [x23, #:lo12:.LANCHOR80]
	ldrh	w2, [x28, 10]
	mul	w0, w0, w1
	sub	w0, w0, #1
	cmp	w2, w0
	bge	.L1991
	adrp	x0, .LANCHOR53
	ldr	w1, [x3]
	ldr	x0, [x0, #:lo12:.LANCHOR53]
	ldr	w4, [x0, 8]
	cmp	w1, w4
	bls	.L1994
	str	w1, [x0, 8]
.L1994:
	ldrh	w0, [x28, 12]
	add	w2, w2, w0
	ldp	w0, w1, [x3, 4]
	bl	lpa_hash_update_ppa
	b	.L1991
.L1975:
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 176
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
	adrp	x20, .LANCHOR80
	stp	x21, x22, [sp, 32]
	mov	w19, w0
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR53
	mov	x24, x1
	add	x20, x20, :lo12:.LANCHOR80
	mov	x21, x22
	stp	x25, x26, [sp, 64]
	mov	w23, 65535
	str	x27, [sp, 80]
.L2058:
	adrp	x25, .LANCHOR99
.L2063:
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	ldr	w1, [x0, 48]
	ldrh	w2, [x0, 696]
	add	w1, w1, 1
	str	w1, [x0, 48]
	ldrh	w1, [x20]
	cmp	w2, w1
	bcs	.L2059
	ldrh	w0, [x0, 692]
	cmp	w0, w23
	bne	.L2060
.L2059:
	bl	pm_alloc_new_blk
	mov	w0, 0
	bl	ftl_info_flush
.L2060:
	ldr	x1, [x21, #:lo12:.LANCHOR53]
	ldrh	w0, [x1, 692]
	cmp	w0, w23
	bne	.L2061
	adrp	x1, .LANCHOR164
	adrp	x0, .LC0
	mov	w2, 224
	add	x1, x1, :lo12:.LANCHOR164
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2062:
	b	.L2062
.L2061:
	ldrh	w1, [x1, 696]
	adrp	x27, .LANCHOR165
	ldrh	w26, [x25, #:lo12:.LANCHOR99]
	mov	w2, 64
	madd	w26, w26, w0, w1
	ldr	x0, [x27, #:lo12:.LANCHOR165]
	mov	w1, 0
	bl	ftl_memset
	ldr	x3, [x27, #:lo12:.LANCHOR165]
	mov	x2, x24
	ldr	x0, [x21, #:lo12:.LANCHOR53]
	str	w19, [x3]
	ldr	w1, [x0, 48]
	ldrb	w0, [x0, 694]
	str	w1, [x3, 4]
	adrp	x1, .LANCHOR52
	ldrb	w4, [x1, #:lo12:.LANCHOR52]
	mov	w1, w26
	bl	ftl_prog_page
	ldr	x2, [x21, #:lo12:.LANCHOR53]
	ldrh	w1, [x2, 696]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 696]
	cmp	w1, 1
	beq	.L2063
	cmn	w0, #1
	bne	.L2064
	mov	w1, w26
	adrp	x0, .LC85
	add	x0, x0, :lo12:.LC85
	bl	printf
	b	.L2058
.L2064:
	ldrh	w0, [x2, 698]
	cmp	w19, w0
	bcs	.L2065
	add	x19, x2, x19, uxtw 2
	str	w26, [x19, 704]
.L2065:
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
	mov	w2, 64
	mov	w1, 0
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR140
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR12
	ldr	x0, [x23, #:lo12:.LANCHOR140]
	adrp	x24, .LC87
	stp	x21, x22, [sp, 32]
	add	x24, x24, :lo12:.LC87
	stp	x25, x26, [sp, 64]
	adrp	x21, .LANCHOR141
	stp	x27, x28, [sp, 80]
	adrp	x22, .LANCHOR20
	bl	ftl_memset
	adrp	x25, .LANCHOR121
	ldr	x1, [x20, #:lo12:.LANCHOR12]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC86
	add	x0, x0, :lo12:.LC86
	add	x22, x22, :lo12:.LANCHOR20
	add	x25, x25, :lo12:.LANCHOR121
	add	x27, x21, :lo12:.LANCHOR141
	bl	rknand_print_hex
	mov	w26, 0
	ldr	x6, [x20, #:lo12:.LANCHOR12]
	add	x0, x6, 16
	ldr	w1, [x6, 8]
	bl	js_hash
	str	w0, [x6, 12]
.L2070:
	add	x28, x21, :lo12:.LANCHOR141
	ldrb	w4, [x21, #:lo12:.LANCHOR141]
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
	blt	.L2071
	ldr	x6, [x20, #:lo12:.LANCHOR12]
	ldrb	w7, [x28, 1]
	strh	wzr, [x28, 2]
	ldr	w0, [x6, 4]
	ldrh	w1, [x6, 16]
	add	w0, w0, 1
	str	w0, [x6, 4]
	ldrb	w0, [x21, #:lo12:.LANCHOR141]
	add	w1, w1, 1
	strb	w0, [x28, 1]
	mov	x0, x6
	strb	w7, [x21, #:lo12:.LANCHOR141]
	strh	w1, [x0, 16]!
	ldr	w1, [x6, 8]
	bl	js_hash
	ldrh	w19, [x22]
	str	w0, [x6, 12]
	mul	w19, w19, w7
.L2077:
	mov	w1, w19
	mov	w0, 0
	bl	flash_erase_block
	b	.L2072
.L2075:
	mov	w26, 1
	b	.L2070
.L2071:
	madd	w19, w19, w4, w3
	cbz	w1, .L2077
.L2072:
	ldr	x2, [x20, #:lo12:.LANCHOR12]
	mov	w1, w19
	ldr	x3, [x23, #:lo12:.LANCHOR140]
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
	bne	.L2073
	mov	w1, w19
	adrp	x0, .LC88
	add	x0, x0, :lo12:.LC88
	bl	printf
	b	.L2070
.L2073:
	cbz	w26, .L2075
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
	stp	x29, x30, [sp, -80]!
	mov	w2, 2
	adrp	x1, .LANCHOR27
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR41
	stp	x23, x24, [sp, 48]
	adrp	x21, .LANCHOR33
	add	x23, x21, :lo12:.LANCHOR33
	stp	x19, x20, [sp, 16]
	str	x25, [sp, 64]
	mov	x24, x23
	strb	w2, [x1, #:lo12:.LANCHOR27]
	bl	nandc_init
	adrp	x19, .LANCHOR26
	mov	w20, 0
	add	x0, x19, :lo12:.LANCHOR26
	mov	w25, 44
	str	x0, [x22, #:lo12:.LANCHOR41]
.L2084:
	mov	x1, x23
	mov	w0, w20
	bl	flash_read_id
	cbnz	w20, .L2079
	ldrb	w0, [x24]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 253
	bls	.L2080
.L2082:
	mov	w0, -2
.L2078:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2080:
	ldrb	w0, [x24, 1]
	cmp	w0, 255
	beq	.L2082
.L2079:
	ldrb	w0, [x23]
	cmp	w0, 181
	bne	.L2083
	strb	w25, [x23]
.L2083:
	add	w20, w20, 1
	add	x23, x23, 8
	and	w20, w20, 255
	cmp	w20, 4
	bne	.L2084
	adrp	x0, .LANCHOR166
	add	x8, x0, :lo12:.LANCHOR166
	add	x8, x8, 1
	mov	x7, x0
	add	x12, x21, :lo12:.LANCHOR33
	mov	x10, 0
.L2087:
	ldrb	w2, [x8, -1]
	mov	w11, w10
	lsl	x23, x10, 5
	mov	x1, x12
	mov	x0, x8
	bl	flash_mem_cmp8
	cbnz	w0, .L2085
	add	x0, x7, :lo12:.LANCHOR166
	ubfiz	x11, x11, 5, 32
	add	x23, x0, x23
	add	x0, x0, x11
	adrp	x1, .LANCHOR167
	add	x4, x1, :lo12:.LANCHOR167
	ldrb	w3, [x0, 22]
	mov	x0, 0
.L2086:
	lsl	x5, x0, 5
	mov	w2, w0
	ldrb	w5, [x5, x4]
	cmp	w5, w3
	beq	.L2088
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L2086
	mov	w2, w0
.L2088:
	ubfiz	x0, x2, 5, 32
	add	x1, x1, :lo12:.LANCHOR167
	add	x1, x1, x0
	mov	w2, 32
	adrp	x0, .LANCHOR129
	add	x20, x19, :lo12:.LANCHOR26
	add	x0, x0, :lo12:.LANCHOR129
	bl	ftl_memcpy
	mov	x1, x23
	mov	w2, 32
	mov	x0, x20
	bl	ftl_memcpy
	adrp	x1, .LANCHOR14
	mov	x23, x1
	ldrb	w0, [x1, #:lo12:.LANCHOR14]
	cmp	w0, 8
	bhi	.L2089
	ldrb	w1, [x20, 20]
	cmp	w1, 60
	bls	.L2090
	mov	w1, 60
	strb	w1, [x20, 20]
.L2090:
	cmp	w0, 8
	bne	.L2089
	ldrb	w0, [x21, #:lo12:.LANCHOR33]
	cmp	w0, 44
	bne	.L2089
	add	x0, x19, :lo12:.LANCHOR26
	ldrb	w1, [x0, 28]
	cmp	w1, 3
	bne	.L2089
	strb	wzr, [x0, 28]
.L2089:
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR143
	adrp	x21, .LANCHOR12
	add	x20, x19, :lo12:.LANCHOR26
	str	x0, [x1, #:lo12:.LANCHOR143]
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR135
	str	x0, [x1, #:lo12:.LANCHOR135]
	mov	w0, 2048
	bl	ftl_malloc
	str	x0, [x21, #:lo12:.LANCHOR12]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR142
	str	x0, [x1, #:lo12:.LANCHOR142]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR136
	str	x0, [x1, #:lo12:.LANCHOR136]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR140
	str	x0, [x1, #:lo12:.LANCHOR140]
	adrp	x0, .LANCHOR147
	strb	wzr, [x0, #:lo12:.LANCHOR147]
	bl	flash_die_info_init
	ldrb	w0, [x20, 18]
	bl	flash_lsb_page_tbl_build
	ldrb	w0, [x20, 20]
	adrp	x20, .LANCHOR139
	bl	nandc_bch_sel
	str	xzr, [x20, #:lo12:.LANCHOR139]
	ldr	x1, [x22, #:lo12:.LANCHOR41]
	adrp	x22, .LANCHOR32
	ldrh	w0, [x1, 16]
	lsr	w3, w0, 8
	ubfx	x4, x0, 3, 1
	and	w2, w3, 7
	strb	w2, [x22, #:lo12:.LANCHOR32]
	adrp	x2, .LANCHOR168
	strb	w4, [x2, #:lo12:.LANCHOR168]
	adrp	x2, .LANCHOR30
	ubfx	x4, x0, 4, 1
	strb	w4, [x2, #:lo12:.LANCHOR30]
	adrp	x2, .LANCHOR69
	ubfx	x4, x0, 12, 1
	strb	w4, [x2, #:lo12:.LANCHOR69]
	adrp	x2, .LANCHOR98
	ubfx	x4, x0, 13, 1
	ubfx	x0, x0, 14, 1
	strb	w4, [x2, #:lo12:.LANCHOR98]
	adrp	x2, .LANCHOR19
	strb	w0, [x2, #:lo12:.LANCHOR19]
	mov	w2, 60
	ldrb	w0, [x1, 28]
	adrp	x1, .LANCHOR18
	strb	w0, [x1, #:lo12:.LANCHOR18]
	adrp	x1, .LANCHOR169
	strb	w2, [x1, #:lo12:.LANCHOR169]
	ldrb	w2, [x23, #:lo12:.LANCHOR14]
	cmp	w2, 9
	bne	.L2091
	mov	w2, 70
	strb	w2, [x1, #:lo12:.LANCHOR169]
.L2091:
	add	x19, x19, :lo12:.LANCHOR26
	adrp	x1, .LANCHOR170
	adrp	x23, .LANCHOR9
	strb	w0, [x1, #:lo12:.LANCHOR170]
	ldrh	w1, [x19, 16]
	ldrb	w0, [x19, 19]
	strb	w0, [x23, #:lo12:.LANCHOR9]
	tbz	x1, 6, .L2093
	sub	w1, w0, #17
	and	w1, w1, 255
	cmp	w1, 2
	bhi	.L2094
	adrp	x1, micron_read_retrial
	add	x1, x1, :lo12:micron_read_retrial
	str	x1, [x20, #:lo12:.LANCHOR139]
	cmp	w0, 19
	adrp	x0, .LANCHOR137
	beq	.L2095
	mov	w1, 7
.L2122:
	strb	w1, [x0, #:lo12:.LANCHOR137]
	b	.L2093
.L2085:
	add	x10, x10, 1
	add	x8, x8, 32
	cmp	x10, 25
	bne	.L2087
	b	.L2082
.L2095:
	mov	w1, 15
	b	.L2122
.L2094:
	sub	w1, w0, #65
	cmp	w0, 33
	and	w1, w1, 255
	ccmp	w1, 1, 0, ne
	bhi	.L2097
	adrp	x0, toshiba_read_retrial
	add	x0, x0, :lo12:toshiba_read_retrial
	str	x0, [x20, #:lo12:.LANCHOR139]
	adrp	x0, .LANCHOR11
	mov	w1, 4
	strb	w1, [x0, #:lo12:.LANCHOR11]
.L2124:
	mov	w1, 7
	adrp	x0, .LANCHOR137
	b	.L2122
.L2097:
	sub	w2, w0, #34
	sub	w1, w0, #67
	and	w2, w2, 255
	and	w1, w1, 255
	cmp	w2, 1
	ccmp	w1, 1, 0, hi
	bhi	.L2098
	adrp	x2, toshiba_read_retrial
	add	x2, x2, :lo12:toshiba_read_retrial
	str	x2, [x20, #:lo12:.LANCHOR139]
	cmp	w0, 35
	mov	w2, 68
	ccmp	w0, w2, 4, ne
	adrp	x0, .LANCHOR137
	beq	.L2099
	mov	w2, 7
.L2121:
	strb	w2, [x0, #:lo12:.LANCHOR137]
	cmp	w1, 1
	adrp	x0, .LANCHOR11
	bhi	.L2101
	mov	w1, 4
.L2123:
	strb	w1, [x0, #:lo12:.LANCHOR11]
.L2093:
	adrp	x19, .LANCHOR42
	mov	w0, 4
	strb	wzr, [x19, #:lo12:.LANCHOR42]
	tbz	x3, 0, .L2102
	bl	nandc_set_if_mode
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
.L2102:
	bl	nandc_set_if_mode
	bl	flash_info_blk_init
	cmn	w0, #1
	beq	.L2078
	ldrb	w0, [x23, #:lo12:.LANCHOR9]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 6
	bhi	.L2104
	adrp	x0, hynix_read_retrial
	add	x0, x0, :lo12:hynix_read_retrial
	str	x0, [x20, #:lo12:.LANCHOR139]
.L2104:
	ldrb	w0, [x22, #:lo12:.LANCHOR32]
	tbnz	x0, 2, .L2105
.L2125:
	mov	w0, 0
	b	.L2078
.L2099:
	mov	w2, 17
	b	.L2121
.L2101:
	mov	w1, 5
	b	.L2123
.L2098:
	sub	w0, w0, #36
	and	w0, w0, 255
	cmp	w0, 1
	bhi	.L2093
	adrp	x0, toshiba_3d_read_retrial
	add	x0, x0, :lo12:toshiba_3d_read_retrial
	str	x0, [x20, #:lo12:.LANCHOR139]
	b	.L2124
.L2105:
	ldr	x0, [x21, #:lo12:.LANCHOR12]
	ldrb	w0, [x0, 19]
	cbz	w0, .L2125
	adrp	x0, .LANCHOR141
	ldrb	w1, [x0, #:lo12:.LANCHOR141]
	adrp	x0, .LANCHOR20
	ldrh	w0, [x0, #:lo12:.LANCHOR20]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_ddr_para_scan
	ldrb	w0, [x19, #:lo12:.LANCHOR42]
	cbnz	w0, .L2125
	ldr	x0, [x21, #:lo12:.LANCHOR12]
	strb	wzr, [x0, 19]
	bl	flash_info_flush
	b	.L2125
	.size	nand_flash_init, .-nand_flash_init
	.section	.text.ftl_sysblk_dump,"ax",@progbits
	.align	2
	.global	ftl_sysblk_dump
	.type	ftl_sysblk_dump, %function
ftl_sysblk_dump:
	sub	sp, sp, #144
	stp	x29, x30, [sp, 48]
	add	x29, sp, 48
	stp	x23, x24, [sp, 96]
	stp	x25, x26, [sp, 112]
	adrp	x26, .LANCHOR80
	stp	x27, x28, [sp, 128]
	add	x26, x26, :lo12:.LANCHOR80
	stp	x19, x20, [sp, 64]
	adrp	x27, .LANCHOR99
	stp	x21, x22, [sp, 80]
	and	w22, w0, 65535
	mov	w0, 1
	bl	buf_alloc
	ldr	x23, [x0, 8]
	adrp	x28, .LANCHOR52
	mov	x24, x0
	add	x27, x27, :lo12:.LANCHOR99
	add	x28, x28, :lo12:.LANCHOR52
	mov	w25, 0
	mov	w19, 0
.L2127:
	ldrh	w0, [x26]
	cmp	w0, w19
	bhi	.L2129
	mov	x0, x24
	bl	buf_free
	cbz	w25, .L2130
	adrp	x1, .LANCHOR171
	adrp	x0, .LC0
	mov	w2, 1199
	add	x1, x1, :lo12:.LANCHOR171
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2131:
	b	.L2131
.L2129:
	ldrh	w20, [x27]
	ldrb	w3, [x28]
	ldr	x1, [x24, 8]
	ldr	x2, [x24, 24]
	madd	w20, w20, w22, w19
	mov	w0, w20
	bl	ftl_read_ppa_page
	mov	w21, w0
	ldr	x1, [x24, 24]
	mov	w4, w0
	ldr	x0, [x24, 8]
	mov	w3, w20
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
	mov	w1, w22
	ldp	w5, w6, [x0]
	ldr	w7, [x0, 8]
	adrp	x0, .LC82
	add	x0, x0, :lo12:.LC82
	bl	printf
	mov	w3, 32
	mov	w2, 4
	add	x1, x23, 704
	adrp	x0, .LC89
	add	x0, x0, :lo12:.LC89
	bl	rknand_print_hex
	cmp	w21, 512
	ccmn	w21, #1, 4, ne
	csinc	w25, w25, wzr, ne
	b	.L2127
.L2130:
	mov	w0, 0
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 144
	ret
	.size	ftl_sysblk_dump, .-ftl_sysblk_dump
	.section	.text.dump_ftl_info,"ax",@progbits
	.align	2
	.global	dump_ftl_info
	.type	dump_ftl_info, %function
dump_ftl_info:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR155
	add	x1, x0, :lo12:.LANCHOR155
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR5
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR53
	ldrh	w3, [x1, 2]
	adrp	x20, .LANCHOR80
	ldrb	w2, [x1, 1]
	adrp	x21, .LANCHOR2
	ldrb	w1, [x0, #:lo12:.LANCHOR155]
	adrp	x0, .LC90
	add	x0, x0, :lo12:.LC90
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	ldrh	w2, [x0, 140]
	ldrh	w1, [x0, 130]
	adrp	x0, .LC91
	add	x0, x0, :lo12:.LC91
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR5]
	adrp	x0, .LC92
	add	x0, x0, :lo12:.LC92
	ldrh	w5, [x1, 26]
	ldrh	w4, [x1, 22]
	ldrb	w3, [x1, 21]
	ldrh	w2, [x1, 18]
	ldrh	w1, [x1, 16]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR5]
	adrp	x0, .LC93
	add	x0, x0, :lo12:.LC93
	ldrh	w5, [x1, 58]
	ldrh	w4, [x1, 54]
	ldrb	w3, [x1, 53]
	ldrh	w2, [x1, 50]
	ldrh	w1, [x1, 48]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR5]
	adrp	x19, .LANCHOR72
	adrp	x0, .LC94
	add	x0, x0, :lo12:.LC94
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
	adrp	x0, .LANCHOR105
	ldr	x1, [x0, #:lo12:.LANCHOR105]
	adrp	x0, .LC95
	lsl	w3, w3, 1
	add	x0, x0, :lo12:.LC95
	bl	rknand_print_hex
	adrp	x0, .LANCHOR4
	ldrh	w3, [x21, #:lo12:.LANCHOR2]
	mov	w2, 2
	ldr	x1, [x0, #:lo12:.LANCHOR4]
	adrp	x0, .LC96
	add	x0, x0, :lo12:.LC96
	bl	rknand_print_hex
	ldr	x1, [x22, #:lo12:.LANCHOR53]
	mov	w3, 32
	mov	w2, 4
	adrp	x0, .LC89
	add	x1, x1, 704
	add	x0, x0, :lo12:.LC89
	bl	rknand_print_hex
	adrp	x0, .LANCHOR3
	ldrh	w3, [x21, #:lo12:.LANCHOR2]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR3]
	adrp	x0, .LC97
	add	x0, x0, :lo12:.LC97
	bl	rknand_print_hex
	mov	w3, 256
	mov	w2, 2
	adrp	x1, .LANCHOR104
	adrp	x0, .LC98
	add	x1, x1, :lo12:.LANCHOR104
	add	x0, x0, :lo12:.LC98
	bl	rknand_print_hex
	ldrb	w0, [x19, #:lo12:.LANCHOR72]
	mov	w2, 2
	ldrh	w3, [x20, #:lo12:.LANCHOR80]
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR106
	ldp	x29, x30, [sp], 48
	lsl	w3, w3, 1
	ldr	x1, [x0, #:lo12:.LANCHOR106]
	adrp	x0, .LC99
	add	x0, x0, :lo12:.LC99
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
	bne	.L2139
	stp	x29, x30, [sp, -16]!
	mov	w3, w2
	mov	w2, w1
	mov	x1, x0
	add	x29, sp, 0
	adrp	x0, .LC100
	add	x0, x0, :lo12:.LC100
	bl	printf
	bl	dump_ftl_info
	mov	w0, -1
	ldp	x29, x30, [sp], 16
	ret
.L2139:
	mov	w0, 0
	ret
	.size	pm_ppa_update_check, .-pm_ppa_update_check
	.section	.text.load_l2p_region,"ax",@progbits
	.align	2
	.type	load_l2p_region, %function
load_l2p_region:
	stp	x29, x30, [sp, -64]!
	and	w1, w1, 65535
	cmp	w1, 31
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	bls	.L2145
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 30
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2146:
	b	.L2146
.L2145:
	adrp	x23, .LANCHOR53
	and	w19, w0, 65535
	ldr	x0, [x23, #:lo12:.LANCHOR53]
	ldrh	w2, [x0, 698]
	cmp	w2, w19
	bcs	.L2147
	mov	w1, w19
	adrp	x0, .LC101
	add	x0, x0, :lo12:.LC101
	bl	printf
	adrp	x0, .LANCHOR173
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR173]
	mov	x0, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	ldr	x0, [x23, #:lo12:.LANCHOR53]
	ldrh	w0, [x0, 698]
	cmp	w0, w19
	bcs	.L2151
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 34
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2149:
	b	.L2149
.L2147:
	add	x0, x0, x19, sxtw 2
	sbfiz	x1, x1, 4, 32
	ldr	w21, [x0, 704]
	adrp	x0, .LANCHOR117
	add	x0, x0, :lo12:.LANCHOR117
	add	x22, x0, x1
	strh	w19, [x0, x1]
	strh	wzr, [x22, 2]
	cbnz	w21, .L2150
	adrp	x0, .LANCHOR173
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR173]
	ldr	x0, [x22, 8]
	bl	ftl_memset
.L2151:
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L2150:
	adrp	x20, .LANCHOR165
	adrp	x0, .LANCHOR52
	ldr	x1, [x22, 8]
	ldrb	w3, [x0, #:lo12:.LANCHOR52]
	mov	w0, w21
	ldr	x2, [x20, #:lo12:.LANCHOR165]
	bl	ftl_read_ppa_page
	ldr	x1, [x20, #:lo12:.LANCHOR165]
	ldr	w2, [x1]
	cmp	w2, w19
	beq	.L2152
	mov	w4, w21
	mov	w3, w0
	mov	w1, w19
	adrp	x0, .LC102
	add	x0, x0, :lo12:.LC102
	bl	printf
	ldr	x1, [x23, #:lo12:.LANCHOR53]
	mov	w2, 4
	adrp	x0, .LC103
	add	x0, x0, :lo12:.LC103
	add	x1, x1, 704
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	ldr	x1, [x22, 8]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC104
	add	x0, x0, :lo12:.LC104
	bl	rknand_print_hex
	ldr	x1, [x20, #:lo12:.LANCHOR165]
	mov	w2, 4
	mov	w3, 16
	adrp	x0, .LC105
	add	x0, x0, :lo12:.LC105
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
.L2152:
	ldr	x0, [x20, #:lo12:.LANCHOR165]
	ldr	w0, [x0]
	cmp	w19, w0
	beq	.L2151
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 55
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2153:
	b	.L2153
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.pm_gc,"ax",@progbits
	.align	2
	.global	pm_gc
	.type	pm_gc, %function
pm_gc:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR53
	adrp	x20, .LANCHOR127
	stp	x21, x22, [sp, 32]
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	stp	x23, x24, [sp, 48]
	ldrh	w1, [x0, 688]
	ldrh	w0, [x20, #:lo12:.LANCHOR127]
	str	x25, [sp, 64]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L2157
	bl	pm_free_sblk
	ldr	x2, [x19, #:lo12:.LANCHOR53]
	ldrh	w1, [x20, #:lo12:.LANCHOR127]
	sub	w1, w1, #1
	ldrh	w3, [x2, 688]
	cmp	w3, w1
	blt	.L2157
	add	x0, x2, x0, uxth 1
	mov	w23, 65535
	ldrh	w20, [x0, 416]
	cmp	w20, w23
	bne	.L2159
	adrp	x1, .LANCHOR174
	adrp	x0, .LC0
	mov	w2, 127
	add	x1, x1, :lo12:.LANCHOR174
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2160:
	b	.L2160
.L2159:
	bl	pm_select_ram_region
	and	x24, x0, 65535
	adrp	x1, .LANCHOR117
	lsl	x0, x24, 4
	add	x2, x1, :lo12:.LANCHOR117
	mov	x22, x19
	add	x19, x2, x0
	mov	x21, x24
	ldrh	w0, [x2, x0]
	cmp	w0, w23
	mov	x23, x1
	beq	.L2161
	ldr	x1, [x19, 8]
	cbz	x1, .L2161
	ldrsh	w2, [x19, 2]
	tbz	w2, #31, .L2161
	bl	pm_write_page
	ldrh	w0, [x19, 2]
	and	w0, w0, 32767
	strh	w0, [x19, 2]
.L2161:
	add	x1, x23, :lo12:.LANCHOR117
	adrp	x25, .LANCHOR96
	add	x24, x1, x24, lsl 4
	add	x25, x25, :lo12:.LANCHOR96
	mov	w19, 0
.L2162:
	ldr	x1, [x22, #:lo12:.LANCHOR53]
	ldrh	w0, [x1, 698]
	cmp	w0, w19
	bhi	.L2164
	bl	pm_free_sblk
.L2157:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2164:
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
	cmp	w20, w0, uxth
	bne	.L2163
	mov	w1, w21
	mov	w0, w19
	bl	load_l2p_region
	ldr	x1, [x24, 8]
	mov	w0, w19
	bl	pm_write_page
.L2163:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2162
	.size	pm_gc, .-pm_gc
	.section	.text.pm_flush_id,"ax",@progbits
	.align	2
	.global	pm_flush_id
	.type	pm_flush_id, %function
pm_flush_id:
	stp	x29, x30, [sp, -32]!
	ubfiz	x0, x0, 4, 16
	adrp	x2, .LANCHOR117
	add	x2, x2, :lo12:.LANCHOR117
	add	x29, sp, 0
	str	x19, [sp, 16]
	add	x19, x2, x0
	ldrh	w0, [x2, x0]
	ldr	x1, [x19, 8]
	bl	pm_write_page
	ldrh	w0, [x19, 2]
	and	w0, w0, 32767
	strh	w0, [x19, 2]
	adrp	x19, .LANCHOR115
	ldr	w0, [x19, #:lo12:.LANCHOR115]
	cbz	w0, .L2170
	bl	pm_gc
	str	wzr, [x19, #:lo12:.LANCHOR115]
.L2170:
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
	adrp	x19, .LANCHOR117
	add	x19, x19, :lo12:.LANCHOR117
	mov	w20, 0
	add	x19, x19, 2
.L2177:
	ldrsh	w0, [x19]
	tbz	w0, #31, .L2176
	mov	w0, w20
	bl	pm_flush_id
.L2176:
	add	w20, w20, 1
	add	x19, x19, 16
	and	w20, w20, 65535
	cmp	w20, 32
	bne	.L2177
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
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	w24, w0
	adrp	x0, .LANCHOR115
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	adrp	x20, .LANCHOR117
	stp	x25, x26, [sp, 64]
	add	x19, x20, :lo12:.LANCHOR117
	str	wzr, [x0, #:lo12:.LANCHOR115]
	mov	w0, 64
	stp	x27, x28, [sp, 80]
	bl	ftl_malloc
	adrp	x1, .LANCHOR165
	adrp	x22, .LANCHOR52
	add	x23, x19, 512
	mov	x21, x1
	add	x22, x22, :lo12:.LANCHOR52
	str	x0, [x1, #:lo12:.LANCHOR165]
	mov	w25, -1
.L2187:
	strh	w25, [x19]
	strh	wzr, [x19, 2]
	cbz	w24, .L2186
	ldrb	w0, [x22]
	lsl	w0, w0, 9
	bl	ftl_malloc
	str	x0, [x19, 8]
.L2186:
	add	x19, x19, 16
	cmp	x19, x23
	bne	.L2187
	add	x0, x20, :lo12:.LANCHOR117
	adrp	x19, .LANCHOR53
	ldr	x24, [x21, #:lo12:.LANCHOR165]
	mov	w4, 4
	ldr	x25, [x0, 8]
	mov	x3, x24
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	mov	x2, x25
	ldrh	w1, [x0, 692]
	ldrb	w0, [x0, 694]
	bl	flash_get_last_written_page
	sxth	w26, w0
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	mov	w23, w26
	ldrh	w2, [x0, 696]
	cmp	w2, w26
	bgt	.L2188
	ldrh	w1, [x0, 692]
	mov	w3, w26
	adrp	x0, .LC106
	add	x0, x0, :lo12:.LC106
	adrp	x27, .LANCHOR99
	adrp	x28, .LANCHOR52
	add	x27, x27, :lo12:.LANCHOR99
	add	x28, x28, :lo12:.LANCHOR52
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	ldrsh	w21, [x0, 696]
.L2189:
	cmp	w21, w26
	ble	.L2191
	adrp	x0, .LANCHOR157
	mov	w1, 1
	add	x20, x20, :lo12:.LANCHOR117
	add	w23, w23, 1
	strb	w1, [x0, #:lo12:.LANCHOR157]
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	strh	w23, [x0, 696]
	bl	pm_free_sblk
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
.L2188:
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
.L2191:
	ldr	x0, [x19, #:lo12:.LANCHOR53]
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
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	str	w4, [x29, 108]
	mov	w2, w22
	ldr	w1, [x0, 48]
	ldrh	w3, [x0, 694]
	add	w1, w1, 1
	str	w1, [x0, 48]
	adrp	x0, .LC107
	add	x0, x0, :lo12:.LC107
	ldr	w1, [x24]
	bl	printf
	ldr	w4, [x29, 108]
	cmp	w4, 512
	ccmn	w4, #1, 4, ne
	beq	.L2190
	ldr	x1, [x19, #:lo12:.LANCHOR53]
	ldr	w0, [x24]
	ldrh	w2, [x1, 698]
	cmp	w0, w2
	bcs	.L2190
	add	x0, x1, x0, uxtw 2
	str	w22, [x0, 704]
.L2190:
	add	w21, w21, 1
	sxth	w21, w21
	b	.L2189
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
	adrp	x1, .LANCHOR52
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	ldrb	w1, [x1, #:lo12:.LANCHOR52]
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
	bcc	.L2201
	mov	w1, w0
	adrp	x0, .LC108
	add	x0, x0, :lo12:.LC108
	bl	printf
	mov	w0, -1
.L2200:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2201:
	adrp	x24, .LANCHOR117
	add	x0, x24, :lo12:.LANCHOR117
	and	x20, x20, 65535
	add	x0, x0, 8
	mov	x19, 0
.L2207:
	ldr	x1, [x0]
	cbz	x1, .L2203
	ldrh	w1, [x0, -8]
	cmp	w1, w25
	bne	.L2203
.L2204:
	cbnz	w23, .L2205
	add	x0, x24, :lo12:.LANCHOR117
	add	x0, x0, x19, lsl 4
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x20, lsl 2]
	str	w0, [x22]
.L2206:
	add	x24, x24, :lo12:.LANCHOR117
	add	x19, x24, x19, lsl 4
	ldrh	w0, [x19, 2]
	mvn	x1, x0
	tst	x1, 32767
	beq	.L2209
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L2209:
	mov	w0, 0
	b	.L2200
.L2205:
	add	x0, x24, :lo12:.LANCHOR117
	ldr	w2, [x22]
	add	x0, x0, x19, lsl 4
	ldr	x1, [x0, 8]
	str	w2, [x1, x20, lsl 2]
	ldrh	w1, [x0, 2]
	orr	w1, w1, -32768
	strh	w1, [x0, 2]
	adrp	x0, .LANCHOR118
	strb	w21, [x0, #:lo12:.LANCHOR118]
	b	.L2206
.L2203:
	add	w19, w19, 1
	add	x0, x0, 16
	and	x19, x19, 65535
	cmp	w19, 32
	bne	.L2207
	bl	pm_select_ram_region
	and	x19, x0, 65535
	sbfiz	x1, x19, 4, 32
	add	x2, x24, :lo12:.LANCHOR117
	add	x3, x2, x1
	mov	w26, w0
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L2208
	ldrsh	w1, [x3, 2]
	tbz	w1, #31, .L2208
	bl	pm_flush_id
.L2208:
	adrp	x0, .LANCHOR175
	mov	w1, w26
	strb	w19, [x0, #:lo12:.LANCHOR175]
	mov	w0, w25
	bl	load_l2p_region
	b	.L2204
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
	beq	.L2216
	mov	w0, 0
	bl	buf_alloc
	mov	x19, x0
	mov	w0, -1
	cbz	x19, .L2215
	ldr	w21, [x20, #:lo12:.LANCHOR56]
	str	w21, [x19, 36]
	str	w0, [x20, #:lo12:.LANCHOR56]
	mov	w0, w21
	bl	lpa_hash_get_ppa
	str	w0, [x29, 76]
	ldr	x20, [x19, 8]
	cmn	w0, #1
	ldr	x22, [x19, 24]
	bne	.L2218
	mov	w2, 0
	add	x1, x29, 76
	mov	w0, w21
	bl	pm_log2phys
.L2218:
	ldr	w0, [x29, 76]
	stp	w0, w0, [x19, 40]
	cmn	w0, #1
	bne	.L2219
	adrp	x0, .LANCHOR52
	mov	w1, 0
	ldrb	w2, [x0, #:lo12:.LANCHOR52]
	mov	x0, x20
	lsl	w2, w2, 9
	bl	ftl_memset
	ldrb	w0, [x19, 2]
	orr	w0, w0, 8
	strb	w0, [x19, 2]
.L2216:
	mov	w0, 0
.L2215:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2219:
	mov	w1, 1
	mov	x0, x19
	bl	sblk_read_page
	ldr	w23, [x19, 52]
	cmn	w23, #1
	bne	.L2220
	ldrb	w0, [x19, 2]
	and	w0, w0, -9
	strb	w0, [x19, 2]
	adrp	x0, .LANCHOR5
	ldr	x1, [x0, #:lo12:.LANCHOR5]
	ldr	w0, [x1, 552]
	add	w0, w0, 1
	str	w0, [x1, 552]
.L2221:
	ldr	w5, [x22, 4]
	cmp	w21, w5
	beq	.L2222
	ldrb	w1, [x19, 1]
	adrp	x0, .LC110
	ldr	w4, [x22]
	mov	w2, w21
	ldp	w6, w7, [x22, 8]
	add	x0, x0, :lo12:.LC110
	ldr	w3, [x29, 76]
	bl	printf
.L2222:
	ldr	w0, [x22, 4]
	cmp	w21, w0
	bne	.L2223
	cmn	w23, #1
	bne	.L2216
.L2223:
	adrp	x1, .LANCHOR176
	adrp	x0, .LC0
	mov	w2, 821
	add	x1, x1, :lo12:.LANCHOR176
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2224:
	b	.L2224
.L2220:
	cmp	w23, 256
	bne	.L2221
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
	adrp	x0, .LC109
	add	x0, x0, :lo12:.LC109
	and	w1, w20, 65535
	bl	printf
	mov	w2, 0
	mov	w1, w24
	mov	w0, w20
	bl	gc_add_sblk
	b	.L2221
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
	adrp	x0, .LANCHOR130
	stp	x23, x24, [sp, 80]
	strb	wzr, [x0, #:lo12:.LANCHOR130]
	stp	x25, x26, [sp, 96]
	stp	x27, x28, [sp, 112]
	bl	gc_init
	add	x0, x20, 80
	ldrh	w1, [x20, 80]
	str	x0, [x29, 168]
	mov	w0, 65535
	cmp	w1, w0
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	beq	.L2231
	mov	w1, -1
	strh	w1, [x0, 130]
	mov	w0, 1
	bl	buf_alloc
	mov	x27, x0
	ldrb	w0, [x20, 89]
	add	x1, x20, 80
	adrp	x3, .LANCHOR99
	adrp	x2, .LANCHOR67
	sub	w0, w0, #1
	str	x3, [x29, 128]
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x3, #:lo12:.LANCHOR99]
	str	x2, [x29, 160]
	ldrh	w0, [x0, 16]
	mul	w1, w0, w1
	ldrb	w0, [x2, #:lo12:.LANCHOR67]
	str	w1, [x29, 200]
	cmp	w0, 3
	bne	.L2232
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	sub	w0, w0, #1
	add	w0, w0, w1
	orr	w0, w0, 50331648
.L2279:
	str	w0, [x27, 40]
.L2233:
	mov	w1, 1
	mov	x0, x27
	bl	sblk_read_page
	ldr	w0, [x27, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2234
	ldr	x0, [x27, 24]
	ldr	w1, [x0]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	cmp	w1, w0
	beq	.L2235
.L2234:
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
	adrp	x0, .LC111
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC111
	ldr	w1, [x27, 40]
	ldr	w2, [x27, 52]
	bl	printf
.L2283:
	adrp	x0, .LANCHOR4
	ldrh	w1, [x20, 80]
	mov	w22, 0
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	strh	wzr, [x0, x1, lsl 1]
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	ldrh	w1, [x20, 80]
	strh	w1, [x0, 130]
.L2236:
	ldrh	w1, [x20, 80]
	mov	w2, w22
	adrp	x0, .LC114
	add	x0, x0, :lo12:.LC114
	bl	printf
	mov	w0, -1
	strh	w0, [x20, 80]
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	mov	w1, 65535
	ldrh	w0, [x0, 130]
	cmp	w0, w1
	beq	.L2265
	bl	ftl_free_sblk
.L2265:
	adrp	x0, .LANCHOR53
	ldr	x1, [x0, #:lo12:.LANCHOR53]
	mov	w0, -1
	strh	w0, [x1, 126]
	ldr	x1, [x21, #:lo12:.LANCHOR5]
	strh	w0, [x1, 130]
	mov	w0, 0
	bl	ftl_info_flush
.L2230:
	ldp	x19, x20, [sp, 48]
	ldp	x21, x22, [sp, 64]
	ldp	x23, x24, [sp, 80]
	ldp	x25, x26, [sp, 96]
	ldp	x27, x28, [sp, 112]
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 240
	ret
.L2232:
	cmp	w0, 2
	bne	.L2233
	adrp	x0, .LANCHOR80
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	add	w0, w1, w0, lsl 1
	sub	w0, w0, #1
	orr	w0, w0, 33554432
	b	.L2279
.L2235:
	adrp	x26, .LANCHOR71
	adrp	x19, .LANCHOR72
	adrp	x22, .LANCHOR131
	ldr	x1, [x27, 8]
	ldrb	w0, [x19, #:lo12:.LANCHOR72]
	ldrh	w2, [x26, #:lo12:.LANCHOR71]
	mul	w2, w2, w0
	ldr	x0, [x22, #:lo12:.LANCHOR131]
	lsl	w2, w2, 2
	bl	ftl_memcpy
	ldrb	w1, [x19, #:lo12:.LANCHOR72]
	adrp	x19, .LANCHOR132
	ldrh	w0, [x26, #:lo12:.LANCHOR71]
	mul	w0, w0, w1
	ldr	x1, [x27, 8]
	lsl	w2, w0, 2
	add	x1, x1, x0, sxtw 2
	ldr	x0, [x19, #:lo12:.LANCHOR132]
	bl	ftl_memcpy
	str	x26, [x29, 120]
	adrp	x0, .LANCHOR80
	stp	x19, x22, [x29, 144]
	ldrh	w24, [x0, #:lo12:.LANCHOR80]
	ldr	x0, [x29, 160]
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	cmp	w0, 2
	beq	.L2237
.L2280:
	str	w0, [x29, 180]
	adrp	x23, .LC112
	ldr	x0, [x29, 128]
	add	x23, x23, :lo12:.LC112
	mov	w26, 0
	mov	w22, 0
	add	x0, x0, :lo12:.LANCHOR99
	str	x0, [x29, 104]
.L2239:
	sub	w0, w26, #1
	str	w0, [x29, 184]
	cmp	w26, w24
	beq	.L2248
	mov	x19, 0
	b	.L2249
.L2237:
	lsl	w24, w24, 1
	mov	w0, 1
	b	.L2280
.L2245:
	ldr	x1, [x29, 104]
	ldr	x0, [x29, 136]
	ldrh	w1, [x1]
	ldrh	w0, [x0, 96]
	mul	w0, w0, w1
	ldr	x1, [x29, 112]
	str	w0, [x29, 200]
	ldrb	w1, [x1]
	cmp	w1, 3
	bne	.L2240
	add	w0, w26, w0
	orr	w0, w0, w25, lsl 24
.L2281:
	str	w0, [x27, 40]
	mov	w1, 1
	mov	x0, x27
	bl	sblk_read_page
	ldr	x0, [x29, 152]
	ldr	x0, [x0, #:lo12:.LANCHOR131]
	ldr	w3, [x0, x28]
	ldr	x0, [x27, 24]
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bne	.L2243
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR132]
	ldr	w2, [x1, x28]
	ldr	w1, [x0, 8]
	cmp	w2, w1
	beq	.L2244
.L2243:
	ldr	x1, [x29, 144]
	ldr	w2, [x0, 12]
	str	w2, [sp]
	ldr	x1, [x1, #:lo12:.LANCHOR132]
	ldr	w5, [x0]
	ldr	w7, [x0, 8]
	mov	x0, x23
	ldr	w2, [x27, 52]
	ldr	w4, [x1, x28]
	ldr	w1, [x27, 40]
	bl	printf
	ldr	x0, [x29, 152]
	ldr	x0, [x0, #:lo12:.LANCHOR131]
	ldr	w0, [x0, x28]
	cmn	w0, #1
	beq	.L2244
	mov	x0, x27
	bl	buf_free
	b	.L2283
.L2240:
	cmp	w1, 2
	bne	.L2242
	ldr	w1, [x29, 184]
	add	w0, w0, w1
	add	w0, w0, w25
	orr	w0, w0, 33554432
	b	.L2281
.L2242:
	add	w0, w26, w0
	b	.L2281
.L2244:
	add	w22, w22, 1
	add	w25, w25, 1
	add	x28, x28, 4
.L2247:
	ldr	w0, [x29, 180]
	cmp	w0, w25
	bcs	.L2245
	add	x19, x19, 1
.L2249:
	ldr	x0, [x29, 168]
	ldrb	w0, [x0, 9]
	cmp	w0, w19
	ble	.L2246
	add	x0, x20, x19, lsl 1
	str	x0, [x29, 136]
	ldr	x0, [x29, 160]
	sbfiz	x28, x22, 2, 32
	mov	w25, 1
	add	x0, x0, :lo12:.LANCHOR67
	str	x0, [x29, 112]
	b	.L2247
.L2246:
	add	w26, w26, 1
	b	.L2239
.L2248:
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
.L2250:
	sub	w0, w23, #1
	str	w0, [x29, 120]
	cmp	w26, w23
	beq	.L2263
	str	xzr, [x29, 184]
	b	.L2264
.L2260:
	ldr	x1, [x29, 152]
	sbfiz	x0, x27, 2, 32
	ldr	x1, [x1, #:lo12:.LANCHOR131]
	ldr	w28, [x1, x0]
	cmn	w28, #1
	beq	.L2251
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR132]
	ldr	w0, [x1, x0]
	str	w0, [x29, 136]
	mov	w0, w28
	bl	lpa_hash_get_ppa
	str	w0, [x29, 204]
	cmn	w0, #1
	bne	.L2252
	mov	w2, 0
	add	x1, x29, 204
	mov	w0, w28
	bl	pm_log2phys
.L2252:
	ldr	x0, [x29, 112]
	ldr	x1, [x29, 128]
	ldrh	w0, [x0, 96]
	ldrh	w1, [x1, #:lo12:.LANCHOR99]
	mul	w0, w0, w1
	ldr	x1, [x29, 160]
	ldrb	w1, [x1, #:lo12:.LANCHOR67]
	cmp	w1, 3
	bne	.L2253
	add	w0, w23, w0
	orr	w0, w0, w25, lsl 24
.L2282:
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
	bne	.L2256
	ldr	w2, [x29, 200]
	mov	w1, w28
	str	w4, [x29, 136]
	adrp	x0, .LC113
	add	x0, x0, :lo12:.LC113
	bl	pm_ppa_update_check
	ldr	w4, [x29, 136]
	cbz	w0, .L2257
.L2277:
	b	.L2277
.L2253:
	cmp	w1, 2
	bne	.L2255
	ldr	w1, [x29, 120]
	add	w0, w0, w1
	add	w0, w0, w25
	orr	w0, w0, 33554432
	b	.L2282
.L2255:
	add	w0, w23, w0
	b	.L2282
.L2257:
	mov	w2, w4
	add	x1, x29, 200
	mov	w0, w28
	bl	pm_log2phys
	add	w22, w22, 1
	mov	w0, w19
	bl	ftl_vpn_decrement
.L2259:
	adrp	x0, .LANCHOR3
	add	w27, w27, 1
	ldr	x0, [x0, #:lo12:.LANCHOR3]
	add	x0, x0, x19, lsl 2
	ldrb	w0, [x0, 2]
	tst	w0, 224
	bne	.L2251
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	lsl	x19, x19, 1
	ldrh	w1, [x0, x19]
	cbz	w1, .L2251
	strh	wzr, [x0, x19]
.L2251:
	add	w25, w25, 1
.L2262:
	ldr	w0, [x29, 180]
	cmp	w0, w25
	bcs	.L2260
	ldr	x0, [x29, 184]
	add	x0, x0, 1
	str	x0, [x29, 184]
.L2264:
	ldr	x0, [x29, 168]
	ldr	w1, [x29, 184]
	ldrb	w0, [x0, 9]
	cmp	w0, w1
	ble	.L2261
	ldr	x0, [x29, 184]
	mov	w25, 1
	add	x0, x20, x0, lsl 1
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR95
	add	x0, x0, :lo12:.LANCHOR95
	str	x0, [x29, 104]
	b	.L2262
.L2256:
	ldr	w1, [x29, 200]
	cmp	w0, w1
	cinc	w22, w22, eq
	b	.L2259
.L2261:
	add	w23, w23, 1
	b	.L2250
.L2263:
	ldrh	w1, [x20, 80]
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	strh	w22, [x0, x1, lsl 1]
	b	.L2236
.L2231:
	ldrh	w0, [x0, 130]
	cmp	w0, w1
	beq	.L2230
	adrp	x19, .LANCHOR53
	ldr	x1, [x19, #:lo12:.LANCHOR53]
	ldrh	w1, [x1, 126]
	cmp	w1, w0
	bne	.L2267
	bl	pm_flush
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	ldrh	w0, [x0, 130]
	bl	ftl_free_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR53]
	mov	w1, -1
	strh	w1, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
.L2267:
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	mov	w1, -1
	strh	w1, [x0, 130]
	b	.L2230
	.size	gc_recovery, .-gc_recovery
	.section	.text.zftl_init,"ax",@progbits
	.align	2
	.global	zftl_init
	.type	zftl_init, %function
zftl_init:
	stp	x29, x30, [sp, -64]!
	adrp	x1, .LANCHOR49
	mov	w0, -1
	add	x29, sp, 0
	strb	w0, [x1, #:lo12:.LANCHOR49]
	adrp	x1, .LANCHOR50
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR72
	strb	wzr, [x1, #:lo12:.LANCHOR50]
	adrp	x1, .LANCHOR151
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR2
	strb	w0, [x1, #:lo12:.LANCHOR151]
	adrp	x0, .LANCHOR112
	mov	w1, -1
	str	x23, [sp, 48]
	strb	wzr, [x0, #:lo12:.LANCHOR112]
	adrp	x0, .LANCHOR56
	adrp	x21, .LANCHOR80
	adrp	x22, .LANCHOR173
	str	w1, [x0, #:lo12:.LANCHOR56]
	adrp	x1, .LC115
	adrp	x0, .LC42
	add	x1, x1, :lo12:.LC115
	add	x0, x0, :lo12:.LC42
	bl	printf
	adrp	x2, .LANCHOR26
	add	x2, x2, :lo12:.LANCHOR26
	adrp	x0, .LANCHOR67
	adrp	x1, .LANCHOR52
	adrp	x6, .LANCHOR95
	ldrb	w4, [x2, 12]
	strb	w4, [x0, #:lo12:.LANCHOR67]
	ldrb	w0, [x2, 9]
	strb	w0, [x1, #:lo12:.LANCHOR52]
	adrp	x1, .LANCHOR71
	ldrh	w7, [x2, 10]
	strh	w7, [x1, #:lo12:.LANCHOR71]
	adrp	x1, .LANCHOR15
	ubfiz	w10, w0, 9, 7
	strh	w10, [x22, #:lo12:.LANCHOR173]
	ldrb	w5, [x1, #:lo12:.LANCHOR15]
	adrp	x1, .LANCHOR100
	sdiv	w3, w7, w4
	strb	w5, [x1, #:lo12:.LANCHOR100]
	ldrb	w1, [x2, 13]
	strb	w1, [x6, #:lo12:.LANCHOR95]
	ldrh	w6, [x2, 14]
	mov	w2, 0
	strh	w3, [x21, #:lo12:.LANCHOR80]
	mul	w5, w5, w1
	adrp	x1, .LANCHOR20
	strh	w6, [x19, #:lo12:.LANCHOR2]
	and	w8, w5, 255
	ldrh	w5, [x1, #:lo12:.LANCHOR20]
	adrp	x1, .LANCHOR99
	strb	w8, [x20, #:lo12:.LANCHOR72]
	strh	w5, [x1, #:lo12:.LANCHOR99]
	mov	w1, 1
.L2285:
	cmp	w5, w1
	bcs	.L2286
	adrp	x1, .LANCHOR96
	sub	w2, w2, #1
	adrp	x23, .LANCHOR161
	mul	w3, w3, w8
	strh	w2, [x1, #:lo12:.LANCHOR96]
	mul	w2, w0, w7
	mov	w1, 57344
	movk	w1, 0x1c, lsl 16
	mul	w5, w2, w6
	mul	w1, w8, w1
	mul	w2, w2, w8
	lsr	w7, w5, 21
	mul	w5, w5, w8
	sub	w2, w2, #1
	mul	w1, w1, w7
	adrp	x7, .LANCHOR59
	str	w1, [x7, #:lo12:.LANCHOR59]
	add	w1, w1, 24576
	adrp	x7, .LANCHOR177
	udiv	w0, w1, w0
	str	w5, [x7, #:lo12:.LANCHOR177]
	adrp	x5, .LANCHOR178
	str	w1, [x5, #:lo12:.LANCHOR178]
	adrp	x5, .LANCHOR54
	udiv	w1, w1, w2
	str	w0, [x5, #:lo12:.LANCHOR54]
	sub	w5, w10, #1
	add	w0, w5, w0, lsl 2
	add	w1, w1, 8
	udiv	w0, w0, w10
	strh	w0, [x23, #:lo12:.LANCHOR161]
	ubfiz	w0, w0, 4, 16
	sdiv	w0, w0, w3
	adrp	x3, .LANCHOR127
	strh	w0, [x3, #:lo12:.LANCHOR127]
	adrp	x0, .LANCHOR87
	strh	w1, [x0, #:lo12:.LANCHOR87]
	adrp	x1, .LANCHOR179
	add	w0, w6, w6, lsl 1
	asr	w0, w0, 2
	strh	w0, [x1, #:lo12:.LANCHOR179]
	adrp	x1, .LANCHOR83
	lsr	w0, w6, 4
	cmp	w0, 79
	strh	w0, [x1, #:lo12:.LANCHOR83]
	bhi	.L2287
	mov	w0, 80
	strh	w0, [x1, #:lo12:.LANCHOR83]
.L2287:
	adrp	x1, .LANCHOR180
	mov	w0, 4000
	adrp	x3, .LANCHOR181
	mov	w2, 1024
	strh	w0, [x1, #:lo12:.LANCHOR180]
	mov	w0, 50
	strh	w0, [x3, #:lo12:.LANCHOR181]
	adrp	x0, .LANCHOR126
	mov	w5, 64
	cmp	w4, 2
	strh	w2, [x0, #:lo12:.LANCHOR126]
	adrp	x2, .LANCHOR125
	strh	w5, [x2, #:lo12:.LANCHOR125]
	beq	.L2288
	adrp	x4, .LANCHOR69
	ldrb	w4, [x4, #:lo12:.LANCHOR69]
	cbz	w4, .L2289
.L2288:
	mov	w4, 150
	strh	w4, [x3, #:lo12:.LANCHOR181]
	mov	w3, 128
	strh	w3, [x2, #:lo12:.LANCHOR125]
	adrp	x2, .LANCHOR18
	ldrb	w2, [x2, #:lo12:.LANCHOR18]
	cbnz	w2, .L2289
	mov	w2, 600
	strh	w2, [x1, #:lo12:.LANCHOR180]
	mov	w1, 512
	strh	w1, [x0, #:lo12:.LANCHOR126]
.L2289:
	bl	buf_init
	ldrh	w1, [x19, #:lo12:.LANCHOR2]
	mov	w0, 6
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR0
	str	x0, [x1, #:lo12:.LANCHOR0]
	ldrb	w1, [x20, #:lo12:.LANCHOR72]
	ldrh	w0, [x21, #:lo12:.LANCHOR80]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR106
	adrp	x3, .LANCHOR4
	str	x0, [x1, #:lo12:.LANCHOR106]
	adrp	x0, .LANCHOR105
	adrp	x1, ftl_ext_info_data_buffer
	add	x2, x1, :lo12:ftl_ext_info_data_buffer
	ldrb	w1, [x20, #:lo12:.LANCHOR72]
	str	x2, [x0, #:lo12:.LANCHOR105]
	ldrh	w0, [x21, #:lo12:.LANCHOR80]
	mul	w0, w0, w1
	lsl	w1, w0, 1
	add	x4, x2, x1, sxtw 2
	str	x4, [x3, #:lo12:.LANCHOR4]
	ldrh	w3, [x19, #:lo12:.LANCHOR2]
	adrp	x19, .LANCHOR5
	add	w1, w1, w3, lsr 1
	add	w0, w3, w0, lsl 2
	add	x1, x2, x1, sxtw 2
	str	x1, [x19, #:lo12:.LANCHOR5]
	ldrh	w1, [x23, #:lo12:.LANCHOR161]
	lsl	w2, w3, 2
	lsl	w0, w0, 1
	add	w0, w0, 612
	add	w1, w2, w1, lsl 2
	ldrh	w2, [x22, #:lo12:.LANCHOR173]
	add	w1, w1, 704
	cmp	w0, w2
	bhi	.L2291
	cmp	w1, w2
	bls	.L2292
.L2291:
.L2302:
	b	.L2302
.L2286:
	add	w2, w2, 1
	lsl	w1, w1, 1
	and	w2, w2, 65535
	b	.L2285
.L2292:
	bl	sblk_init
	bl	ftl_info_blk_init
	cmn	w0, #1
	beq	.L2284
	bl	ftl_ext_info_init
	adrp	x20, .LANCHOR53
	mov	w0, 1
	bl	pm_init
	bl	lpa_rebuild_hash
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	mov	x1, 0
	add	x0, x0, 16
	bl	ftl_open_sblk_recovery
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	add	x1, x0, 16
	add	x0, x0, 48
	bl	ftl_open_sblk_recovery
	ldr	x1, [x20, #:lo12:.LANCHOR53]
	ldr	w0, [x1, 8]
	add	w0, w0, 16
	str	w0, [x1, 8]
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	add	x0, x0, 16
	bl	ftl_info_data_recovery
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	add	x0, x0, 48
	bl	ftl_info_data_recovery
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	add	x0, x0, 80
	bl	ftl_info_data_recovery
	bl	gc_recovery
	bl	pm_flush
	mov	w0, 1
	bl	ftl_total_vpn_update
	adrp	x0, .LANCHOR157
	ldrb	w0, [x0, #:lo12:.LANCHOR157]
	cbz	w0, .L2294
	ldr	x1, [x20, #:lo12:.LANCHOR53]
	ldr	w0, [x1, 68]
	add	w0, w0, 1
	str	w0, [x1, 68]
.L2294:
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	print_ftl_debug_info
	mov	w0, 0
.L2284:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
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
	cbnz	w0, .L2306
	bl	zftl_init
.L2306:
	mov	w19, w0
	mov	w1, w0
	adrp	x0, .LC116
	add	x0, x0, :lo12:.LC116
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
	stp	x21, x22, [sp, 32]
	ldr	x22, [x0, #:lo12:.LANCHOR5]
	stp	x25, x26, [sp, 64]
	ldrh	w25, [x1, #:lo12:.LANCHOR71]
	add	x1, x22, 80
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR29
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	str	x1, [x29, 144]
	ldrb	w1, [x1, 9]
	str	x0, [x29, 128]
	mul	w25, w25, w1
	ldr	w1, [x20, #:lo12:.LANCHOR29]
	tbz	x1, 8, .L2309
	ldrh	w1, [x22, 80]
	adrp	x0, .LC117
	add	x0, x0, :lo12:.LC117
	bl	printf
.L2309:
	adrp	x24, .LANCHOR4
	ldrh	w1, [x22, 80]
	sub	w2, w25, #1
	mov	x21, 0
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	mov	w23, 0
	strh	w2, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR52
	add	x0, x0, :lo12:.LANCHOR52
	str	x0, [x29, 104]
.L2310:
	mov	w27, w21
	cmp	w25, w21
	bhi	.L2320
	ldr	w0, [x20, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L2321
	ldr	x0, [x29, 128]
	mov	w3, w23
	ldr	x1, [x24, #:lo12:.LANCHOR4]
	ldrh	w2, [x22, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldrh	w2, [x1, x2, lsl 1]
	ldrh	w1, [x0, 80]
	adrp	x0, .LC121
	add	x0, x0, :lo12:.LC121
	bl	printf
.L2321:
	ldrh	w0, [x22, 80]
	ldr	x1, [x24, #:lo12:.LANCHOR4]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	cmp	w23, w2
	beq	.L2322
	adrp	x1, .LANCHOR182
	adrp	x0, .LC0
	mov	w2, 463
	add	x1, x1, :lo12:.LANCHOR182
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2323:
	b	.L2323
.L2320:
	adrp	x26, .LANCHOR131
	lsl	x19, x21, 2
	ldr	x0, [x26, #:lo12:.LANCHOR131]
	ldr	w2, [x0, x19]
	cmn	w2, #1
	beq	.L2311
	adrp	x0, .LANCHOR52
	ldrb	w0, [x0, #:lo12:.LANCHOR52]
	lsl	w0, w0, 7
	udiv	w0, w2, w0
	and	w0, w0, 65535
	str	w0, [x29, 156]
	ldr	w0, [x20, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L2312
	ldr	w1, [x29, 156]
	adrp	x0, .LC118
	mov	w3, w21
	add	x0, x0, :lo12:.LC118
	bl	printf
.L2312:
	sub	w27, w25, w27
	add	x27, x27, x21
	lsl	x0, x27, 2
	str	x0, [x29, 136]
	adrp	x0, .LC120
	add	x0, x0, :lo12:.LC120
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR96
	add	x0, x0, :lo12:.LANCHOR96
	str	x0, [x29, 112]
.L2313:
	ldr	x0, [x29, 136]
	cmp	x0, x19
	bne	.L2319
.L2311:
	add	x21, x21, 1
	b	.L2310
.L2319:
	ldr	x0, [x26, #:lo12:.LANCHOR131]
	ldr	w28, [x0, x19]
	cmn	w28, #1
	beq	.L2314
	ldr	x0, [x29, 104]
	ldr	w1, [x29, 156]
	ldrb	w0, [x0]
	lsl	w0, w0, 7
	udiv	w0, w28, w0
	cmp	w1, w0, uxth
	bne	.L2314
	adrp	x0, .LANCHOR132
	ldr	x0, [x0, #:lo12:.LANCHOR132]
	ldr	w27, [x0, x19]
	mov	w0, w28
	bl	lpa_hash_get_ppa
	str	w0, [x29, 172]
	cmn	w0, #1
	bne	.L2315
	mov	w2, 0
	add	x1, x29, 172
	mov	w0, w28
	bl	pm_log2phys
.L2315:
	ldr	w3, [x29, 172]
	cmp	w27, w3
	bne	.L2316
	adrp	x0, .LANCHOR133
	mov	w2, 1
	add	x1, x29, 168
	add	w23, w23, 1
	ldr	x0, [x0, #:lo12:.LANCHOR133]
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
	bne	.L2317
	ldr	w0, [x20, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L2317
	ldr	w3, [x29, 172]
	adrp	x0, .LC119
	mov	w2, w27
	mov	w1, w28
	add	x0, x0, :lo12:.LC119
	bl	printf
.L2317:
	ldr	x0, [x26, #:lo12:.LANCHOR131]
	mov	w1, -1
	str	w1, [x0, x19]
.L2314:
	add	x19, x19, 4
	b	.L2313
.L2316:
	ldr	w0, [x20, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L2318
	ldr	x0, [x29, 120]
	mov	w2, w27
	mov	w1, w28
	bl	printf
.L2318:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0]
	bl	ftl_vpn_decrement
	b	.L2317
.L2322:
	strh	w23, [x1, x0]
	ldrh	w0, [x22, 80]
	bl	zftl_insert_data_list
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
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
.L2347:
	cmp	w3, w7
	beq	.L2349
	cbz	w6, .L2350
	add	x1, x19, :lo12:.LANCHOR63
	strb	w0, [x1, 4]
.L2350:
	cbz	w5, .L2351
	add	x0, x19, :lo12:.LANCHOR63
	strh	w2, [x0, 2]
.L2351:
	adrp	x0, .LANCHOR99
	ldrh	w22, [x0, #:lo12:.LANCHOR99]
	adrp	x0, .LANCHOR67
	mov	x23, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR67]
	mul	w22, w22, w3
	cmp	w1, 2
	bne	.L2352
	add	x0, x19, :lo12:.LANCHOR63
	ldrb	w1, [x0, 6]
	cbnz	w1, .L2352
	ldrh	w0, [x0, 2]
	add	w22, w22, w0, lsl 1
.L2353:
	add	x1, x19, :lo12:.LANCHOR63
	ldrb	w0, [x1, 4]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x1, 4]
	cmp	w4, w0
	bne	.L2354
	ldrh	w0, [x1, 2]
	strb	wzr, [x1, 4]
	add	w0, w0, 1
	strh	w0, [x1, 2]
.L2354:
	mov	w0, 1
	add	x19, x19, :lo12:.LANCHOR63
	bl	buf_alloc
	add	x23, x23, :lo12:.LANCHOR67
	mov	x21, x0
	mov	w20, 0
	adrp	x24, .LANCHOR64
.L2364:
	ldrb	w0, [x19, 6]
	cmp	w0, 3
	bne	.L2355
	cbz	w20, .L2356
.L2355:
	cmp	w0, w20
	bgt	.L2357
.L2365:
	mov	x0, x21
	bl	buf_free
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2349:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, w4
	bne	.L2348
	add	w2, w2, 1
	mov	w5, 1
	and	w2, w2, 65535
	mov	w0, 0
.L2348:
	add	x3, x1, x0, sxtw 1
	mov	w6, 1
	ldrh	w3, [x3, 40]
	b	.L2347
.L2352:
	add	x0, x19, :lo12:.LANCHOR63
	ldrh	w0, [x0, 2]
	add	w22, w0, w22
	b	.L2353
.L2357:
	ldrb	w1, [x23]
	cmp	w1, 2
	bne	.L2358
	cbnz	w0, .L2358
	add	w0, w20, w22
	orr	w0, w0, 33554432
.L2378:
	str	w0, [x21, 40]
	mov	w1, 1
	mov	x0, x21
	bl	sblk_read_page
	ldr	w0, [x21, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2361
	ldr	x0, [x21, 24]
	ldr	w25, [x0, 4]
	mov	w0, w25
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L2362
	mov	w2, 0
	add	x1, x29, 92
	mov	w0, w25
	bl	pm_log2phys
.L2362:
	ldr	w0, [x29, 92]
	cmp	w22, w0
	bne	.L2361
	ldrh	w0, [x19, 24]
	ldr	x2, [x24, #:lo12:.LANCHOR64]
	ubfiz	x1, x0, 2, 16
	add	w0, w0, 1
	str	w22, [x2, x1]
	strh	w0, [x19, 24]
.L2361:
	ldrh	w0, [x19, 26]
	add	w0, w0, 1
	strh	w0, [x19, 26]
.L2356:
	add	w20, w20, 1
	cmp	w20, 4
	bne	.L2364
	b	.L2365
.L2358:
	orr	w0, w22, w20, lsl 24
	b	.L2378
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
	beq	.L2380
	adrp	x21, .LANCHOR96
	adrp	x22, .LANCHOR95
	add	x21, x21, :lo12:.LANCHOR96
	add	x22, x22, :lo12:.LANCHOR95
	mov	w20, 11
.L2389:
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	mov	w2, 0
	add	x1, x29, 76
	ldr	w0, [x0, 544]
	bl	pm_log2phys
	ldr	w0, [x29, 76]
	cmn	w0, #1
	beq	.L2381
	mov	w0, 1
	bl	buf_alloc
	ldr	w1, [x29, 76]
	mov	x23, x0
	str	w1, [x0, 40]
	mov	w1, 1
	bl	sblk_read_page
	ldr	w0, [x23, 52]
	cmp	w0, 256
	bne	.L2382
	ldrh	w3, [x21]
	mov	w0, 21
	ldr	w2, [x29, 76]
	mov	w1, 1
	sub	w0, w0, w3
	lsr	w2, w2, w3
	ldrb	w3, [x22]
	lsl	w0, w1, w0
	sub	w0, w0, #1
	and	w0, w0, w2
	mov	w2, 0
	udiv	w0, w0, w3
	bl	gc_add_sblk
.L2382:
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	ldr	x1, [x23, 24]
	ldr	w0, [x0, 544]
	ldr	w1, [x1, 4]
	cmp	w1, w0
	beq	.L2383
	adrp	x1, .LANCHOR183
	adrp	x0, .LC0
	mov	w2, 1369
	add	x1, x1, :lo12:.LANCHOR183
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2384:
	b	.L2384
.L2383:
	mov	x0, x23
	bl	buf_free
.L2381:
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	adrp	x2, .LANCHOR54
	ldr	w2, [x2, #:lo12:.LANCHOR54]
	ldr	w1, [x0, 544]
	add	w1, w1, 1
	str	w1, [x0, 544]
	cmp	w1, w2
	bcc	.L2385
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
.L2379:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2385:
	ldr	w0, [x29, 76]
	cmn	w0, #1
	bne	.L2379
	sub	w20, w20, #1
	ands	w20, w20, 65535
	bne	.L2389
	b	.L2379
.L2380:
	adrp	x1, .LANCHOR53
	ldr	x1, [x1, #:lo12:.LANCHOR53]
	ldr	w2, [x1, 40]
	cmp	w2, 20480
	bls	.L2391
	ldr	w3, [x1, 44]
	add	w3, w3, w2, lsr 10
	and	w2, w2, 1023
	stp	w2, w3, [x1, 40]
.L2391:
	ldr	w2, [x0, 536]
	ldr	w3, [x0, 12]
	add	w2, w2, 12959744
	add	w2, w2, 256
	cmp	w3, w2
	ldr	w2, [x1, 44]
	bhi	.L2392
	ldr	w1, [x0, 540]
	add	w1, w1, 98304
	add	w1, w1, 1696
	cmp	w2, w1
	bls	.L2379
.L2392:
	str	w3, [x0, 536]
	str	w2, [x0, 540]
	str	wzr, [x0, 544]
	b	.L2379
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
	and	w22, w0, 65535
	stp	x19, x20, [sp, 64]
	mov	w0, 65535
	stp	x23, x24, [sp, 96]
	cmp	w22, w0
	stp	x25, x26, [sp, 112]
	stp	x27, x28, [sp, 128]
	beq	.L2419
	uxtw	x0, w22
	str	x0, [x29, 144]
	lsl	x14, x0, 2
	adrp	x0, .LANCHOR3
	mov	x13, x0
	ldr	x2, [x0, #:lo12:.LANCHOR3]
	add	x2, x2, x14
	ldrb	w2, [x2, 2]
	and	w2, w2, 224
	cmp	w2, 160
	bne	.L2420
	adrp	x0, .LANCHOR67
	ldrb	w24, [x0, #:lo12:.LANCHOR67]
.L2400:
	add	x28, x29, 224
	str	x1, [x29, 160]
	mov	w0, w22
	strh	w22, [x28, -32]!
	add	x1, x28, 16
	bl	ftl_get_blk_list_in_sblk
	adrp	x2, .LANCHOR80
	and	w1, w0, 255
	strb	w1, [x29, 201]
	ldrh	w3, [x2, #:lo12:.LANCHOR80]
	strh	wzr, [x29, 194]
	strb	wzr, [x29, 197]
	strh	wzr, [x29, 202]
	mul	w1, w1, w3
	str	x2, [x29, 136]
	strh	w1, [x29, 198]
	adrp	x1, .LANCHOR29
	str	x1, [x29, 152]
	ldr	w3, [x1, #:lo12:.LANCHOR29]
	tbz	x3, 12, .L2401
	ldr	x1, [x13, #:lo12:.LANCHOR3]
	and	w4, w0, 255
	mov	w3, w24
	adrp	x0, .LC122
	add	x1, x1, x14
	add	x0, x0, :lo12:.LC122
	ldrb	w2, [x1, 2]
	mov	w1, w22
	ubfx	x2, x2, 5, 3
	bl	printf
.L2401:
	mov	w0, 1
	bl	buf_alloc
	mov	w26, 0
	mov	x21, x0
	mov	w27, 0
	adrp	x0, .LANCHOR99
	mov	w19, 0
	add	x0, x0, :lo12:.LANCHOR99
	str	wzr, [x29, 172]
	str	x0, [x29, 112]
.L2402:
	ldr	x0, [x29, 136]
	ldrh	w0, [x0, #:lo12:.LANCHOR80]
	cmp	w0, w19
	bls	.L2416
	lsl	w0, w19, 1
	mov	w23, 0
	sub	w0, w0, #1
	str	w0, [x29, 168]
	adrp	x0, .LC82
	add	x0, x0, :lo12:.LC82
	str	x0, [x29, 120]
	b	.L2417
.L2420:
	mov	w24, 1
	b	.L2400
.L2413:
	ldr	x0, [x29, 128]
	ldrh	w11, [x28, x0]
	mov	w0, 65535
	cmp	w11, w0
	beq	.L2403
	ldr	x0, [x29, 112]
	cmp	w24, 3
	ldrh	w8, [x0]
	mul	w8, w8, w11
	bne	.L2404
	add	w8, w19, w8
	orr	w25, w8, w20, lsl 24
.L2405:
	str	w25, [x21, 40]
	mov	w1, 1
	str	w11, [x29, 100]
	mov	x0, x21
	bl	sblk_read_page
	ldr	x1, [x21, 24]
	mov	w3, w25
	ldr	x0, [x21, 8]
	ldr	w12, [x21, 52]
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
	ldr	w0, [x29, 172]
	cmp	w12, 512
	ccmn	w12, #1, 4, ne
	csinc	w0, w0, wzr, ne
	str	w0, [x29, 172]
	ldr	x0, [x21, 24]
	ldr	w3, [x0, 4]
	str	w3, [x29, 104]
	mov	w0, w3
	bl	lpa_hash_get_ppa
	str	w0, [x29, 188]
	cmn	w0, #1
	ldr	w3, [x29, 104]
	bne	.L2408
	mov	w2, 0
	add	x1, x29, 188
	mov	w0, w3
	bl	pm_log2phys
.L2408:
	ldr	w0, [x29, 188]
	cmp	w25, w0
	bne	.L2409
	ldr	x0, [x21, 24]
	add	w26, w26, 1
	mov	w3, w26
	mov	w1, w25
	ldr	w2, [x0, 4]
	adrp	x0, .LC123
	add	x0, x0, :lo12:.LC123
	bl	printf
.L2409:
	ldr	x0, [x29, 160]
	cbz	x0, .L2410
	ubfiz	x3, x27, 2, 32
	ldr	w2, [x0, x3]
	ldr	x0, [x21, 24]
	ldr	w0, [x0, 4]
	cmp	w0, w2
	beq	.L2411
	ldr	x0, [x29, 152]
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L2411
	str	x3, [x29, 104]
	mov	w1, w27
	adrp	x0, .LC124
	add	x0, x0, :lo12:.LC124
	bl	printf
	ldr	x3, [x29, 104]
.L2411:
	ldr	x1, [x21, 24]
	ldr	x0, [x29, 160]
	ldr	w1, [x1, 4]
	ldr	w0, [x0, x3]
	cmp	w1, w0
	beq	.L2410
	cmn	w0, #1
	beq	.L2410
	adrp	x1, .LANCHOR184
	adrp	x0, .LC0
	mov	w2, 1160
	add	x1, x1, :lo12:.LANCHOR184
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2412:
	b	.L2412
.L2404:
	cmp	w24, 2
	bne	.L2406
	ldr	w0, [x29, 168]
	add	w8, w8, w0
	adrp	x0, .LANCHOR67
	add	w8, w8, w20
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	orr	w25, w8, w0, lsl 24
	b	.L2405
.L2406:
	add	w25, w19, w8
	b	.L2405
.L2410:
	add	w27, w27, 1
.L2403:
	add	w20, w20, 1
	and	w20, w20, 65535
.L2415:
	cmp	w24, w20
	bcs	.L2413
	add	w23, w23, 1
	and	w23, w23, 65535
.L2417:
	ldrb	w0, [x29, 201]
	cmp	w0, w23
	bls	.L2414
	sxtw	x0, w23
	mov	w20, 1
	add	x0, x0, 8
	lsl	x0, x0, 1
	str	x0, [x29, 128]
	b	.L2415
.L2414:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2402
.L2416:
	mov	x0, x21
	bl	buf_free
	ldr	x0, [x29, 152]
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L2418
	adrp	x0, .LANCHOR4
	ldr	x1, [x29, 144]
	mov	w3, w26
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	ldrh	w2, [x0, x1, lsl 1]
	adrp	x0, .LC125
	mov	w1, w22
	add	x0, x0, :lo12:.LC125
	bl	printf
.L2418:
	ldr	w0, [x29, 172]
.L2398:
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 272
	ret
.L2419:
	mov	w0, 0
	b	.L2398
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
	adrp	x0, .LANCHOR29
	stp	x23, x24, [sp, 48]
	stp	x19, x20, [sp, 16]
	mov	w24, w2
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	mov	w19, w1
	stp	x25, x26, [sp, 64]
	mov	x23, x3
	stp	x27, x28, [sp, 80]
	tbz	x0, 12, .L2440
	mov	w3, w2
	adrp	x0, .LC126
	mov	w2, w1
	add	x0, x0, :lo12:.LC126
	mov	w1, w21
	bl	printf
.L2440:
	cbnz	w21, .L2441
	adrp	x0, .LANCHOR59
	mov	w21, 24576
	ldr	w0, [x0, #:lo12:.LANCHOR59]
.L2442:
	add	w1, w19, w24
	cmp	w0, w1
	bcc	.L2467
	adrp	x1, .LANCHOR53
	adrp	x25, .LANCHOR52
	add	w21, w21, w19
	str	x1, [x29, 120]
	ldr	x2, [x1, #:lo12:.LANCHOR53]
	ldr	w0, [x2, 24]
	add	w0, w0, w24
	str	w0, [x2, 24]
	ldrb	w0, [x25, #:lo12:.LANCHOR52]
	add	w2, w24, w21
	stp	w2, wzr, [x29, 136]
	sub	w2, w2, #1
	udiv	w27, w21, w0
	udiv	w0, w2, w0
	mov	w20, w27
	sub	w26, w0, w27
	str	w0, [x29, 132]
	add	w26, w26, 1
	adrp	x0, .LC110
	add	x0, x0, :lo12:.LC110
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR43
	add	x0, x0, :lo12:.LANCHOR43
	str	x0, [x29, 104]
.L2444:
	cbnz	w26, .L2465
	ldr	w0, [x29, 140]
.L2439:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L2441:
	cmp	w21, 3
	bhi	.L2467
	lsl	w21, w21, 13
	mov	w0, 8192
	b	.L2442
.L2465:
	ldrb	w1, [x25, #:lo12:.LANCHOR52]
	cmp	w20, w27
	ldr	w0, [x29, 132]
	and	w19, w1, 65535
	ccmp	w20, w0, 4, ne
	bne	.L2468
	cmp	w20, w27
	bne	.L2446
	udiv	w22, w21, w1
	and	w0, w24, 65535
	msub	w1, w22, w1, w21
	and	w22, w1, 65535
	sub	w19, w19, w22
	and	w19, w19, 65535
	cmp	w24, w19
	csel	w19, w0, w19, cc
.L2445:
	adrp	x0, .LANCHOR43
	add	x1, x0, :lo12:.LANCHOR43
	add	x1, x1, 2
	mov	w0, 0
.L2449:
	ldr	w2, [x1, 34]
	cmp	w20, w2
	bne	.L2447
	ldrb	w2, [x1]
	tbz	x2, 3, .L2447
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
.L2448:
	add	w20, w20, 1
	sub	w26, w26, #1
	b	.L2444
.L2446:
	ldr	w0, [x29, 136]
	msub	w19, w1, w20, w0
	and	w19, w19, 255
.L2468:
	mov	w22, 0
	b	.L2445
.L2447:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L2449
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 156]
	cmn	w0, #1
	bne	.L2450
	mov	w2, 0
	add	x1, x29, 156
	mov	w0, w20
	bl	pm_log2phys
.L2450:
	ldr	w0, [x29, 156]
	cmn	w0, #1
	bne	.L2451
	add	x22, x25, :lo12:.LANCHOR52
	mov	w19, 0
.L2452:
	ldrb	w0, [x22]
	cmp	w19, w0
	bcs	.L2448
	madd	w0, w20, w0, w19
	cmp	w21, w0
	bhi	.L2453
	ldr	w1, [x29, 136]
	cmp	w1, w0
	bls	.L2453
	mov	x0, x23
	add	x23, x23, 512
	mov	w2, 512
	mov	w1, 0
	bl	ftl_memset
.L2453:
	add	w19, w19, 1
	b	.L2452
.L2451:
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L2455
	bl	ftl_read_ahead
	b	.L2444
.L2455:
	ldr	x0, [x29, 120]
	ldr	x1, [x0, #:lo12:.LANCHOR53]
	ldr	w0, [x1, 40]
	add	w0, w0, 1
	str	w0, [x1, 40]
	ldr	w0, [x29, 156]
	stp	w0, w0, [x28, 40]
	ldrb	w0, [x25, #:lo12:.LANCHOR52]
	cmp	w0, w19
	bne	.L2457
	str	x23, [x28, 16]
.L2457:
	mov	w1, 1
	mov	x0, x28
	bl	sblk_read_page
	ldr	w10, [x28, 52]
	cmn	w10, #1
	bne	.L2458
	adrp	x0, .LANCHOR5
	str	w10, [x29, 140]
	ldr	x1, [x0, #:lo12:.LANCHOR5]
	ldr	w0, [x1, 552]
	add	w0, w0, 1
	str	w0, [x1, 552]
.L2459:
	ldr	x0, [x28, 24]
	ldr	w5, [x0, 4]
	cmp	w20, w5
	beq	.L2460
	ldr	w4, [x0]
	mov	w2, w20
	ldp	w6, w7, [x0, 8]
	str	w10, [x29, 128]
	ldrb	w1, [x28, 1]
	ldr	w3, [x29, 156]
	ldr	x0, [x29, 112]
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
.L2460:
	ldr	x0, [x28, 24]
	ldr	w0, [x0, 4]
	cmp	w20, w0
	bne	.L2461
	cmn	w10, #1
	bne	.L2462
.L2461:
	adrp	x1, .LANCHOR185
	adrp	x0, .LC0
	mov	w2, 976
	add	x1, x1, :lo12:.LANCHOR185
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2463:
	b	.L2463
.L2458:
	cmp	w10, 256
	bne	.L2459
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
	adrp	x0, .LC127
	add	x0, x0, :lo12:.LC127
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
	b	.L2459
.L2462:
	ldr	x0, [x28, 16]
	cbnz	x0, .L2464
	ldr	x1, [x28, 8]
	ubfiz	x22, x22, 9, 16
	lsl	w2, w19, 9
	mov	x0, x23
	add	x1, x1, x22
	bl	ftl_memcpy
.L2464:
	ubfiz	x19, x19, 9, 16
	mov	x0, x28
	add	x23, x23, x19
	bl	buf_free
	b	.L2448
.L2467:
	mov	w0, -1
	b	.L2439
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
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR5
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR54
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR4
	stp	x25, x26, [sp, 64]
	adrp	x22, .LANCHOR2
	stp	x27, x28, [sp, 80]
	bl	dump_ftl_info
	ldr	x0, [x20, #:lo12:.LANCHOR5]
	add	x21, x21, :lo12:.LANCHOR54
	add	x23, x22, :lo12:.LANCHOR2
	mov	w25, 0
	adrp	x19, check_vpc_tbl
	ldrh	w3, [x0, 80]
	ldrh	w2, [x0, 48]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC128
	add	x0, x0, :lo12:.LC128
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR5]
	ldr	x3, [x24, #:lo12:.LANCHOR4]
	ldrh	w1, [x0, 16]
	ldrh	w2, [x0, 22]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x3, x0]
	adrp	x0, .LC129
	add	x0, x0, :lo12:.LC129
	sub	w4, w3, w2
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR5]
	ldr	x3, [x24, #:lo12:.LANCHOR4]
	ldrh	w1, [x0, 48]
	ldrh	w2, [x0, 54]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x3, x0]
	adrp	x0, .LC130
	add	x0, x0, :lo12:.LC130
	sub	w4, w3, w2
	bl	printf
	mov	w2, 4608
	mov	w1, 0
	add	x0, x19, :lo12:check_vpc_tbl
	bl	ftl_memset
.L2484:
	ldr	w0, [x21]
	cmp	w25, w0
	bcc	.L2492
	adrp	x0, .LANCHOR2
	adrp	x23, .LC133
	add	x28, x0, :lo12:.LANCHOR2
	mov	x5, x0
	add	x23, x23, :lo12:.LC133
	mov	w22, 0
	mov	w21, 0
.L2493:
	ldrh	w0, [x28]
	cmp	w0, w21
	bhi	.L2495
	adrp	x20, .LC134
	add	x26, x5, :lo12:.LANCHOR2
	add	x19, x19, :lo12:check_vpc_tbl
	add	x20, x20, :lo12:.LC134
	mov	w28, 0
	adrp	x27, .LANCHOR3
.L2496:
	ldrh	w1, [x26]
	cmp	w1, w28
	bhi	.L2501
	mov	w2, w22
	adrp	x1, .LANCHOR186
	adrp	x0, .LC135
	add	x1, x1, :lo12:.LANCHOR186
	add	x0, x0, :lo12:.LC135
	bl	printf
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2492:
	mov	w0, w25
	bl	lpa_hash_get_ppa
	str	w0, [x29, 124]
	cmn	w0, #1
	bne	.L2485
	mov	w2, 0
	add	x1, x29, 124
	mov	w0, w25
	bl	pm_log2phys
.L2486:
	ldr	w2, [x29, 124]
	cmn	w2, #1
	beq	.L2488
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
	ldrh	w0, [x22, #:lo12:.LANCHOR2]
	and	w26, w3, 65535
	and	w3, w3, 65535
	cmp	w0, w26
	bls	.L2489
	add	x0, x19, :lo12:check_vpc_tbl
	sxtw	x3, w3
	ldrh	w1, [x0, x3, lsl 1]
	add	w1, w1, 1
	strh	w1, [x0, x3, lsl 1]
.L2490:
	ldrh	w0, [x23]
	cmp	w0, w26
	bhi	.L2488
	adrp	x1, .LANCHOR186
	adrp	x0, .LC0
	mov	w2, 1206
	add	x1, x1, :lo12:.LANCHOR186
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2491:
	b	.L2491
.L2485:
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
	ldrh	w1, [x22, #:lo12:.LANCHOR2]
	cmp	w1, w0, uxth
	bhi	.L2486
	adrp	x1, .LANCHOR186
	adrp	x0, .LC0
	mov	w2, 1196
	add	x1, x1, :lo12:.LANCHOR186
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2487:
	b	.L2487
.L2489:
	mov	w1, w25
	adrp	x0, .LC131
	add	x0, x0, :lo12:.LC131
	bl	printf
	adrp	x0, .LANCHOR52
	mov	w2, 4
	ldrb	w3, [x0, #:lo12:.LANCHOR52]
	adrp	x0, .LANCHOR117+8
	ldr	x1, [x0, #:lo12:.LANCHOR117+8]
	adrp	x0, .LC132
	lsl	w3, w3, 7
	add	x0, x0, :lo12:.LC132
	bl	rknand_print_hex
	b	.L2490
.L2488:
	add	w25, w25, 1
	b	.L2484
.L2495:
	uxtw	x0, w21
	ldr	x1, [x24, #:lo12:.LANCHOR4]
	lsl	x27, x0, 1
	add	x25, x19, :lo12:check_vpc_tbl
	sxtw	x26, w21
	ldrh	w3, [x1, x27]
	ldrh	w2, [x25, x26, lsl 1]
	cmp	w3, w2
	beq	.L2494
	adrp	x1, .LANCHOR3
	str	x5, [x29, 104]
	ldr	x1, [x1, #:lo12:.LANCHOR3]
	add	x0, x1, x0, lsl 2
	mov	w1, w21
	ldrb	w4, [x0, 2]
	mov	x0, x23
	ubfx	x4, x4, 5, 3
	bl	printf
	ldr	x0, [x24, #:lo12:.LANCHOR4]
	mov	w1, 65535
	ldr	x5, [x29, 104]
	ldrh	w0, [x0, x27]
	cmp	w0, w1
	beq	.L2494
	ldrh	w1, [x25, x26, lsl 1]
	cmp	w1, w0
	bls	.L2494
	ldr	x0, [x20, #:lo12:.LANCHOR5]
	ldrh	w1, [x0, 16]
	cmp	w1, w21
	beq	.L2494
	ldrh	w1, [x0, 80]
	cmp	w1, w21
	beq	.L2494
	ldrh	w0, [x0, 48]
	cmp	w0, w21
	csinc	w22, w22, wzr, eq
.L2494:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L2493
.L2501:
	ldr	x0, [x27, #:lo12:.LANCHOR3]
	uxtw	x21, w28
	add	x0, x0, x21, lsl 2
	ldrb	w1, [x0, 2]
	tst	w1, 224
	bne	.L2497
	sxtw	x23, w28
	ldrh	w1, [x19, x23, lsl 1]
	cbnz	w1, .L2498
	ldr	x1, [x24, #:lo12:.LANCHOR4]
	lsl	x25, x21, 1
	ldrh	w1, [x1, x25]
	cbz	w1, .L2499
	mov	w1, w28
	mov	x0, x20
	bl	printf
.L2499:
	ldr	x1, [x24, #:lo12:.LANCHOR4]
	strh	wzr, [x1, x25]
.L2498:
	ldr	x1, [x24, #:lo12:.LANCHOR4]
	ldrh	w1, [x1, x21, lsl 1]
	cbz	w1, .L2497
	ldrh	w1, [x19, x23, lsl 1]
	cbz	w1, .L2497
	adrp	x1, .LANCHOR186
	adrp	x0, .LC0
	mov	w2, 1238
	add	x1, x1, :lo12:.LANCHOR186
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2500:
	b	.L2500
.L2497:
	add	w1, w28, 1
	and	w28, w1, 65535
	b	.L2496
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
	bne	.L2516
	adrp	x1, .LANCHOR187
	adrp	x0, .LC0
	mov	w2, 897
	add	x1, x1, :lo12:.LANCHOR187
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2517:
	b	.L2517
.L2516:
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L2518
	adrp	x2, .LANCHOR4
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR4]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC136
	add	x0, x0, :lo12:.LC136
	bl	printf
.L2518:
	ldrh	w0, [x19, #:lo12:.LANCHOR63]
	add	x13, x19, :lo12:.LANCHOR63
	add	x1, x13, 40
	bl	ftl_get_blk_list_in_sblk
	and	w1, w0, 255
	strb	w1, [x13, 5]
	cbnz	w1, .L2519
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR63]
.L2555:
	mov	w0, 0
.L2515:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2519:
	adrp	x1, .LANCHOR3
	ldrh	w3, [x19, #:lo12:.LANCHOR63]
	ldr	x1, [x1, #:lo12:.LANCHOR3]
	mov	x2, x3
	add	x1, x1, x3, lsl 2
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 32
	beq	.L2521
	cmp	w1, 224
	beq	.L2521
	cbz	w1, .L2522
	adrp	x3, .LANCHOR5
	ldr	x3, [x3, #:lo12:.LANCHOR5]
	ldrh	w4, [x3, 16]
	cmp	w4, w2
	beq	.L2521
	ldrh	w4, [x3, 48]
	cmp	w4, w2
	beq	.L2521
	ldrh	w3, [x3, 80]
	cmp	w3, w2
	bne	.L2553
.L2521:
	add	x0, x19, :lo12:.LANCHOR63
	mov	w1, -1
	strh	w1, [x19, #:lo12:.LANCHOR63]
	strh	wzr, [x0, 24]
	b	.L2555
.L2522:
	adrp	x0, .LANCHOR4
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	ldrh	w0, [x0, x3, lsl 1]
	cbz	w0, .L2521
	adrp	x1, .LANCHOR187
	adrp	x0, .LC0
	mov	w2, 917
	add	x1, x1, :lo12:.LANCHOR187
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2524:
	b	.L2524
.L2553:
	and	w0, w0, 255
	sub	w0, w0, #1
	add	x0, x13, x0, sxtw 1
	ldrh	w3, [x0, 40]
	mov	w0, 65535
	cmp	w3, w0
	bne	.L2525
	adrp	x1, .LANCHOR187
	adrp	x0, .LC0
	mov	w2, 925
	add	x1, x1, :lo12:.LANCHOR187
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2526:
	b	.L2526
.L2525:
	adrp	x4, .LANCHOR99
	adrp	x2, .LANCHOR80
	cmp	w1, 160
	mov	x24, x2
	ldrh	w20, [x4, #:lo12:.LANCHOR99]
	adrp	x21, .LANCHOR71
	ldrh	w0, [x2, #:lo12:.LANCHOR80]
	sub	w0, w0, #1
	and	w0, w0, 65535
	mul	w20, w20, w3
	bne	.L2540
	adrp	x1, .LANCHOR67
	ldrb	w1, [x1, #:lo12:.LANCHOR67]
	and	w22, w1, 65535
	cmp	w1, 2
	orr	w20, w20, w1, lsl 24
	bne	.L2527
	ldrh	w0, [x21, #:lo12:.LANCHOR71]
	mov	w22, 2
	sub	w0, w0, #1
	and	w0, w0, 65535
.L2527:
	add	x23, x19, :lo12:.LANCHOR63
	orr	w20, w0, w20
	mov	w0, 1
	strb	w22, [x23, 6]
	strh	wzr, [x23, 2]
	strb	wzr, [x23, 4]
	strh	wzr, [x23, 26]
	bl	buf_alloc
	str	w20, [x0, 40]
	adrp	x20, .LANCHOR72
	mov	x25, x0
	mov	w1, 1
	bl	sblk_read_page
	ldrh	w2, [x21, #:lo12:.LANCHOR71]
	adrp	x21, .LANCHOR64
	ldrb	w0, [x20, #:lo12:.LANCHOR72]
	mov	w1, 255
	mul	w2, w2, w0
	ldr	x0, [x21, #:lo12:.LANCHOR64]
	lsl	w2, w2, 2
	bl	ftl_memset
	strh	wzr, [x23, 24]
	ldr	w0, [x25, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L2528
.L2530:
	mov	x0, x25
	bl	buf_free
	mov	w0, -1
	b	.L2515
.L2540:
	mov	w22, 1
	b	.L2527
.L2528:
	ldr	x0, [x25, 24]
	mov	w23, 15555
	movk	w23, 0xf55f, lsl 16
	ldr	w0, [x0]
	cmp	w0, w23
	beq	.L2529
	ldrh	w0, [x19, #:lo12:.LANCHOR63]
	mov	x1, 0
	bl	ftl_sblk_dump
	ldr	x0, [x25, 24]
	ldr	w0, [x0]
	cmp	w0, w23
	beq	.L2530
	adrp	x1, .LANCHOR187
	adrp	x0, .LC0
	mov	w2, 955
	add	x1, x1, :lo12:.LANCHOR187
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2531:
	b	.L2531
.L2529:
	ldrh	w0, [x24, #:lo12:.LANCHOR80]
	adrp	x23, .LANCHOR95
	ldrb	w20, [x20, #:lo12:.LANCHOR72]
	add	x23, x23, :lo12:.LANCHOR95
	ldr	x24, [x25, 8]
	mov	x26, 0
	mul	w20, w20, w0
	mul	w20, w22, w20
	adrp	x22, .LANCHOR96
	add	x22, x22, :lo12:.LANCHOR96
	and	w20, w20, 65535
.L2532:
	cmp	w20, w26
	bgt	.L2537
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
	beq	.L2538
	adrp	x0, .LC137
	add	x0, x0, :lo12:.LC137
	bl	printf
.L2538:
	ldrh	w2, [x19, #:lo12:.LANCHOR63]
	add	x0, x19, :lo12:.LANCHOR63
	ldr	x1, [x20, #:lo12:.LANCHOR4]
	ldrh	w0, [x0, 24]
	ldrh	w1, [x1, x2, lsl 1]
	cmp	w1, w0
	bcs	.L2539
	bl	vpn_check
.L2539:
	add	x0, x19, :lo12:.LANCHOR63
	ldrh	w2, [x19, #:lo12:.LANCHOR63]
	ldr	x1, [x20, #:lo12:.LANCHOR4]
	ldrh	w3, [x0, 24]
	strh	w3, [x1, x2, lsl 1]
	strh	wzr, [x0, 28]
	ldrh	w0, [x0, 24]
	b	.L2515
.L2537:
	ldr	w0, [x24, x26, lsl 2]
	cmn	w0, #1
	beq	.L2534
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L2535
	ldr	w0, [x24, x26, lsl 2]
	mov	w2, 0
	add	x1, x29, 92
	bl	pm_log2phys
.L2535:
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
	bne	.L2534
	ldrh	w0, [x1, 24]
	ldr	x4, [x21, #:lo12:.LANCHOR64]
	ubfiz	x2, x0, 2, 16
	add	w0, w0, 1
	str	w3, [x4, x2]
	strh	w0, [x1, 24]
.L2534:
	add	x26, x26, 1
	b	.L2532
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
	adrp	x24, .LC140
	stp	x25, x26, [sp, 80]
	bl	buf_alloc
	mov	w1, 0
	mov	x19, x0
	adrp	x0, .LC138
	add	x0, x0, :lo12:.LC138
	bl	printf
	add	x0, x24, :lo12:.LC140
	str	x0, [x29, 120]
.L2557:
	ldr	w0, [x23, #:lo12:.LANCHOR54]
	cmp	w20, w0
	bcc	.L2570
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
.L2570:
	mov	w0, -1
	str	w0, [x19, 36]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 140]
	cmn	w0, #1
	bne	.L2558
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w20
	bl	pm_log2phys
.L2558:
	tst	x20, 4095
	bne	.L2559
	ldr	w2, [x29, 140]
	adrp	x0, .LC139
	mov	w1, w20
	add	x0, x0, :lo12:.LC139
	bl	printf
.L2559:
	ldr	w0, [x29, 140]
	stp	w0, w0, [x19, 40]
	cmn	w0, #1
	bne	.L2560
.L2562:
	add	w20, w20, 1
	b	.L2557
.L2560:
	mov	w1, 1
	mov	x0, x19
	bl	sblk_read_page
	ldr	w3, [x19, 52]
	ldr	x0, [x19, 24]
	cmp	w3, 256
	ccmn	w3, #1, 4, ne
	beq	.L2561
	ldr	w1, [x0, 4]
	cmp	w20, w1
	beq	.L2562
.L2561:
	ldr	x1, [x19, 8]
	add	x27, x24, :lo12:.LC140
	adrp	x25, .LANCHOR52
	adrp	x26, .LC141
	adrp	x22, .LANCHOR117
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
	bne	.L2563
.L2565:
	ldrb	w21, [x25, #:lo12:.LANCHOR52]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	add	x22, x22, :lo12:.LANCHOR117
	mov	w4, w0
	add	x0, x26, :lo12:.LC141
	lsl	w27, w21, 7
	ubfiz	w3, w21, 7, 9
	sub	w3, w3, #1
	add	x21, x22, 8
	and	w3, w3, w20
	adrp	x26, .LC143
	sdiv	w27, w20, w27
	and	w3, w3, 65535
	add	x22, x22, 520
	add	x26, x26, :lo12:.LC143
	mov	w1, w20
	and	w25, w27, 65535
	mov	w2, w25
	bl	printf
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w20
	bl	pm_log2phys
.L2564:
	ldr	x1, [x21]
	cbz	x1, .L2569
	ldrh	w0, [x21, -8]
	cmp	w0, w25
	bne	.L2569
	mov	w3, 4096
	mov	w2, 4
	mov	x0, x26
	bl	rknand_print_hex
.L2569:
	add	x21, x21, 16
	cmp	x22, x21
	bne	.L2564
	b	.L2562
.L2563:
	ldr	w21, [x1, 4]
	ldr	w1, [x28]
	cmp	w21, w1
	bcs	.L2565
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
	bne	.L2566
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w21
	bl	pm_log2phys
.L2566:
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
	ldrb	w3, [x25, #:lo12:.LANCHOR52]
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
	add	x0, x26, :lo12:.LC141
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
	add	x0, x22, :lo12:.LANCHOR117
	adrp	x5, .LC142
	add	x21, x0, 8
	add	x4, x0, 520
	add	x5, x5, :lo12:.LC142
.L2568:
	ldr	x1, [x21]
	cbz	x1, .L2567
	ldrh	w0, [x21, -8]
	cmp	w0, w27
	bne	.L2567
	mov	x0, x5
	stp	x4, x5, [x29, 104]
	mov	w3, 4096
	mov	w2, 4
	bl	rknand_print_hex
	ldp	x4, x5, [x29, 104]
.L2567:
	add	x21, x21, 16
	cmp	x4, x21
	bne	.L2568
	b	.L2565
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
	stp	x23, x24, [sp, 48]
	adrp	x0, .LANCHOR80
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR105
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldrh	w23, [x0, #:lo12:.LANCHOR80]
	ldrb	w0, [x22, 9]
	ldrh	w19, [x22, 12]
	str	x24, [x29, 104]
	mul	w23, w23, w0
	ldr	x0, [x24, #:lo12:.LANCHOR105]
	add	x19, x0, x19, lsl 2
	add	x0, x19, x23, sxtw 2
	ldr	w0, [x0, -4]
	cmn	w0, #1
	bne	.L2581
	adrp	x27, .LANCHOR52
	mov	x28, 0
	add	x0, x27, :lo12:.LANCHOR52
	mov	w21, 0
	str	x0, [x29, 96]
.L2582:
	cmp	w28, w23
	blt	.L2590
	adrp	x0, .LANCHOR29
	adrp	x19, .LANCHOR4
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 12, .L2591
	ldrh	w1, [x22]
	ldr	x2, [x19, #:lo12:.LANCHOR4]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC147
	mov	w2, w21
	add	x0, x0, :lo12:.LC147
	bl	printf
.L2591:
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
.L2581:
	adrp	x1, .LANCHOR188
	adrp	x0, .LC0
	mov	w2, 1432
	add	x1, x1, :lo12:.LANCHOR188
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2583:
	b	.L2583
.L2590:
	ldr	w2, [x19, x28, lsl 2]
	cmn	w2, #1
	beq	.L2584
	ldrb	w20, [x27, #:lo12:.LANCHOR52]
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	lsl	w20, w20, 7
	udiv	w20, w2, w20
	and	w20, w20, 65535
	tbz	x0, 12, .L2585
	adrp	x0, .LC144
	mov	w3, w28
	mov	w1, w20
	add	x0, x0, :lo12:.LC144
	bl	printf
.L2585:
	adrp	x25, .LANCHOR99
	adrp	x26, .LC145
	mov	x24, x28
	add	x25, x25, :lo12:.LANCHOR99
	add	x26, x26, :lo12:.LC145
.L2589:
	ldr	w1, [x19, x24, lsl 2]
	cmn	w1, #1
	beq	.L2586
	ldr	x0, [x29, 96]
	ldrb	w2, [x0]
	lsl	w2, w2, 7
	udiv	w1, w1, w2
	cmp	w20, w1, uxth
	bne	.L2586
	ldrb	w0, [x22, 9]
	sdiv	w1, w24, w0
	msub	w0, w1, w0, w24
	add	x0, x22, x0, sxtw 1
	ldrh	w2, [x0, 16]
	ldrh	w0, [x25]
	madd	w2, w2, w0, w1
	mov	x0, x26
	str	w2, [x29, 124]
	ldr	w1, [x19, x24, lsl 2]
	bl	pm_ppa_update_check
	cbz	w0, .L2587
	ldr	x0, [x29, 104]
	mov	w3, w23
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR105]
	adrp	x0, .LC146
	add	x0, x0, :lo12:.LC146
	bl	rknand_print_hex
.L2588:
	b	.L2588
.L2587:
	ldr	w0, [x19, x24, lsl 2]
	add	w21, w21, 1
	mov	w2, 1
	add	x1, x29, 124
	and	w21, w21, 65535
	bl	pm_log2phys
	mov	w0, -1
	str	w0, [x19, x24, lsl 2]
.L2586:
	add	x24, x24, 1
	cmp	w23, w24
	bgt	.L2589
.L2584:
	add	x28, x28, 1
	b	.L2582
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
	beq	.L2607
	bl	zftl_insert_data_list
.L2607:
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
	adrp	x0, .LANCHOR43
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	add	x26, x0, :lo12:.LANCHOR43
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
.L2612:
	adrp	x3, .LANCHOR50
	ldrb	w1, [x3, #:lo12:.LANCHOR50]
	cbz	w1, .L2614
	adrp	x4, .LANCHOR49
	adrp	x2, .LANCHOR43
	add	x2, x2, :lo12:.LANCHOR43
	sub	w1, w1, #1
	ldrb	w0, [x4, #:lo12:.LANCHOR49]
	str	x0, [x29, 104]
	strb	w1, [x3, #:lo12:.LANCHOR50]
	adrp	x1, .LANCHOR54
	ubfiz	x27, x0, 6, 8
	add	x5, x2, x27
	str	x5, [x29, 120]
	lsl	x5, x0, 6
	ldr	w1, [x1, #:lo12:.LANCHOR54]
	add	x0, x2, x5
	ldrb	w5, [x2, x5]
	ldr	w22, [x0, 36]
	strb	w5, [x4, #:lo12:.LANCHOR49]
	cmp	w22, w1
	bcc	.L2616
	ldr	x0, [x29, 120]
	bl	buf_free
	mov	w0, -1
.L2611:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L2616:
	ldrb	w21, [x0, 57]
	ldrb	w20, [x0, 56]
	ldr	x24, [x0, 8]
	ldr	x28, [x0, 24]
	adrp	x0, .LANCHOR112
	str	x0, [x29, 112]
	ldrb	w1, [x0, #:lo12:.LANCHOR112]
	cbz	w1, .L2618
	adrp	x0, .LANCHOR151
	ldrb	w1, [x0, #:lo12:.LANCHOR151]
	add	x1, x2, x1, lsl 6
.L2619:
	ldrb	w0, [x1]
	cmp	w0, 255
	bne	.L2620
	ldr	w0, [x1, 36]
	cmp	w22, w0
	bne	.L2618
	ldr	x0, [x1, 8]
	ubfiz	x21, x21, 9, 8
	lsl	w2, w20, 9
	add	x1, x24, x21
	add	x0, x0, x21
	bl	ftl_memcpy
	ldr	x0, [x29, 120]
	bl	buf_free
	b	.L2612
.L2620:
	ubfiz	x1, x0, 6, 8
	add	x1, x26, x1
	b	.L2619
.L2618:
	mov	w0, w22
	bl	lpa_hash_get_ppa
	str	w0, [x29, 140]
	cmn	w0, #1
	bne	.L2622
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w22
	bl	pm_log2phys
.L2622:
	adrp	x25, .LANCHOR5
	add	x1, x26, 2
	mov	w0, 0
	ldr	x19, [x25, #:lo12:.LANCHOR5]
	add	x19, x19, 16
.L2625:
	ldr	w2, [x1, 34]
	cmp	w22, w2
	bne	.L2623
	ldrb	w2, [x1]
	tbz	x2, 3, .L2623
	ubfiz	x0, x0, 6, 32
	and	w2, w2, -9
	add	x0, x26, x0
	strb	w2, [x0, 2]
	ldr	x23, [x0, 8]
	ldr	w0, [x0, 40]
	str	w0, [x29, 140]
.L2624:
	adrp	x0, .LANCHOR52
	str	x0, [x29, 96]
	ldrb	w1, [x0, #:lo12:.LANCHOR52]
	cmp	w20, w1
	bcs	.L2650
	cbz	x23, .L2627
	cbz	w21, .L2628
	lsl	w2, w21, 9
	mov	x1, x23
	mov	x0, x24
	bl	ftl_memcpy
	ldr	x19, [x25, #:lo12:.LANCHOR5]
	add	x19, x19, 48
.L2628:
	ldr	x0, [x29, 96]
	add	w20, w21, w20
	ldrb	w2, [x0, #:lo12:.LANCHOR52]
	cmp	w20, w2
	bcc	.L2629
	ldr	x19, [x25, #:lo12:.LANCHOR5]
	add	x19, x19, 16
.L2650:
	mov	w23, 0
	b	.L2626
.L2623:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L2625
	mov	x23, 0
	b	.L2624
.L2629:
	ubfiz	x0, x20, 9, 9
	sub	w2, w2, w20
	add	x1, x23, x0
	lsl	w2, w2, 9
	add	x0, x24, x0
	bl	ftl_memcpy
	b	.L2650
.L2627:
	ldr	w0, [x29, 140]
	cmn	w0, #1
	beq	.L2630
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
	bne	.L2631
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L2632
.L2631:
	ldrb	w1, [x27, 1]
	mov	w3, w22
	ldr	w4, [x27, 52]
	adrp	x0, .LC148
	ldr	w2, [x29, 140]
	add	x0, x0, :lo12:.LC148
	bl	printf
	ldr	x1, [x27, 24]
	mov	w3, 4
	adrp	x0, .LC105
	mov	w2, w3
	add	x0, x0, :lo12:.LC105
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
.L2632:
	ldr	x0, [x27, 24]
	ldr	w0, [x0, 4]
	cmp	w22, w0
	bne	.L2633
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L2634
.L2633:
	adrp	x1, .LANCHOR189
	adrp	x0, .LC0
	mov	w2, 497
	add	x1, x1, :lo12:.LANCHOR189
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2635:
	b	.L2635
.L2634:
	cbz	w21, .L2636
	ldr	w0, [x29, 140]
	lsl	w2, w21, 9
	cmn	w0, #1
	beq	.L2637
	ldr	x1, [x27, 8]
	mov	x0, x24
	bl	ftl_memcpy
.L2638:
	ldr	x19, [x25, #:lo12:.LANCHOR5]
	add	x19, x19, 48
.L2636:
	ldr	x0, [x29, 96]
	add	w20, w21, w20
	ldrb	w2, [x0, #:lo12:.LANCHOR52]
	cmp	w20, w2
	bcc	.L2639
	ldr	x19, [x25, #:lo12:.LANCHOR5]
	add	x19, x19, 16
.L2640:
	cbz	x27, .L2626
	ldrb	w0, [x27, 2]
	mov	x1, x27
	and	w0, w0, -9
	strb	w0, [x27, 2]
	adrp	x0, .LANCHOR58
	add	x0, x0, :lo12:.LANCHOR58
	bl	buf_remove_buf
	mov	x0, x27
	bl	buf_free
.L2626:
	ldrh	w0, [x19, 6]
	cbnz	w0, .L2642
	bl	ftl_flush
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L2642:
	mov	x0, x19
	bl	ftl_get_new_free_page
	ldr	x1, [x29, 104]
	adrp	x20, .LANCHOR151
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
	add	x0, x20, :lo12:.LANCHOR151
	bl	buf_add_tail
	ldr	x0, [x29, 112]
	ldrb	w2, [x0, #:lo12:.LANCHOR112]
	add	w2, w2, 1
	and	w2, w2, 255
	strb	w2, [x0, #:lo12:.LANCHOR112]
	adrp	x0, .LANCHOR190
	cmp	w2, 2
	str	wzr, [x0, #:lo12:.LANCHOR190]
	ldrh	w0, [x19, 6]
	bhi	.L2643
	cmp	w0, 1
	bne	.L2615
.L2643:
	ldrb	w1, [x19, 5]
	cmp	w1, 0
	mov	w1, 0
	cset	w4, ne
	cmp	w0, 1
	ldrb	w0, [x20, #:lo12:.LANCHOR151]
	csinc	w4, w2, w4, eq
	mov	w3, w0
.L2647:
	cmp	w1, w4
	bne	.L2648
	strb	w3, [x20, #:lo12:.LANCHOR151]
	and	w1, w1, 255
	ldr	x3, [x29, 112]
	sub	w2, w2, w1
	ubfiz	x0, x0, 6, 8
	add	x0, x26, x0
	strb	w2, [x3, #:lo12:.LANCHOR112]
	bl	sblk_prog_page
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bne	.L2615
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	mov	x0, x19
	bl	ftl_write_last_log_page
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L2615:
	adrp	x0, .LANCHOR50
	ldrb	w0, [x0, #:lo12:.LANCHOR50]
	cbnz	w0, .L2612
.L2614:
	bl	ftl_write_completed
	mov	w0, 0
	b	.L2611
.L2639:
	ldr	w0, [x29, 140]
	sub	w2, w2, w20
	lsl	w2, w2, 9
	ubfiz	x20, x20, 7, 9
	cmn	w0, #1
	beq	.L2641
	ldr	x1, [x27, 8]
	lsl	x20, x20, 2
	add	x0, x24, x20
	add	x1, x1, x20
	bl	ftl_memcpy
	b	.L2640
.L2641:
	mov	w1, 0
	add	x0, x24, x20, lsl 2
	bl	ftl_memset
	b	.L2640
.L2648:
	ubfiz	x3, x3, 6, 8
	add	w1, w1, 1
	ldrb	w3, [x26, x3]
	b	.L2647
.L2649:
	lsl	w2, w21, 9
	mov	x27, 0
	mov	w23, 0
.L2637:
	mov	w1, 0
	mov	x0, x24
	bl	ftl_memset
	b	.L2638
.L2630:
	cbnz	w21, .L2649
	mov	w23, 0
	mov	x27, 0
	b	.L2636
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
	cbnz	w0, .L2673
	bl	buf_alloc
	mov	x19, x0
	cbz	x0, .L2672
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
	bne	.L2675
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
.L2675:
	ldr	w0, [x19, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L2676
	adrp	x1, .LANCHOR191
	adrp	x0, .LC0
	mov	w2, 573
	add	x1, x1, :lo12:.LANCHOR191
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2677:
	b	.L2677
.L2676:
	ldr	x0, [x19, 24]
	ldr	w21, [x0, 4]
	mov	w0, w21
	bl	lpa_hash_get_ppa
	str	w0, [x29, 160]
	cmn	w0, #1
	bne	.L2678
	mov	w2, 0
	add	x1, x29, 160
	mov	w0, w21
	bl	pm_log2phys
.L2678:
	ldr	w23, [x29, 160]
	cmp	w22, w23
	bne	.L2679
	adrp	x0, .LANCHOR43
	add	x0, x0, :lo12:.LANCHOR43
	add	x1, x0, 2
	add	x0, x0, 2050
.L2682:
	ldr	w2, [x1, 34]
	cmp	w21, w2
	bne	.L2680
	ldrb	w2, [x1]
	tbz	x2, 1, .L2680
	mov	x0, x19
	bl	buf_free
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L2672
	add	x20, x20, :lo12:.LANCHOR63
	adrp	x0, .LC149
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC149
	ldrh	w3, [x20, 26]
	bl	printf
.L2672:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 224
	ret
.L2680:
	add	x1, x1, 64
	cmp	x0, x1
	bne	.L2682
	adrp	x0, .LANCHOR52
	mov	w1, 10
	strb	wzr, [x19, 57]
	ldrb	w0, [x0, #:lo12:.LANCHOR52]
	strb	w0, [x19, 56]
	ldrb	w0, [x19, 2]
	str	w21, [x19, 36]
	orr	w0, w0, w1
	strb	w0, [x19, 2]
	ldr	x0, [x19, 24]
	ldr	w0, [x0]
	str	w0, [x19, 32]
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L2683
	mov	w0, w21
	bl	lpa_hash_get_ppa
	add	x1, x20, :lo12:.LANCHOR63
	mov	w3, w0
	mov	w4, w22
	adrp	x0, .LC150
	mov	w2, w23
	add	x0, x0, :lo12:.LC150
	ldrh	w5, [x1, 26]
	mov	w1, w21
	bl	printf
.L2683:
	mov	x0, x19
	bl	ftl_gc_write_buf
	bl	ftl_write_commit
	add	x20, x20, :lo12:.LANCHOR63
	adrp	x0, .LANCHOR53
	ldr	x1, [x0, #:lo12:.LANCHOR53]
	ldr	w0, [x1, 60]
	add	w0, w0, 1
	str	w0, [x1, 60]
	ldrh	w0, [x20, 28]
	add	w0, w0, 1
	strh	w0, [x20, 28]
	b	.L2672
.L2679:
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L2684
	add	x20, x20, :lo12:.LANCHOR63
	mov	w0, w21
	bl	lpa_hash_get_ppa
	mov	w3, w0
	mov	w4, w22
	adrp	x0, .LC150
	ldrh	w5, [x20, 26]
	mov	w2, w23
	mov	w1, w21
	add	x0, x0, :lo12:.LC150
	bl	printf
.L2684:
	mov	x0, x19
	bl	buf_free
	b	.L2672
.L2673:
	adrp	x1, .LANCHOR5
	adrp	x0, .LANCHOR67
	stp	x0, x1, [x29, 128]
	adrp	x24, .LANCHOR63
	ldr	x22, [x1, #:lo12:.LANCHOR5]
	ldrb	w25, [x0, #:lo12:.LANCHOR67]
	add	x22, x22, 80
	cmp	w25, 3
	bne	.L2685
	adrp	x0, .LANCHOR69
	ldrb	w0, [x0, #:lo12:.LANCHOR69]
	cbz	w0, .L2686
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w19, [x22, 9]
	ldrh	w20, [x0, 314]
	add	w21, w19, w19, lsl 1
	sub	w19, w19, w19, lsl 2
	sdiv	w21, w20, w21
	madd	w19, w21, w19, w20
	and	w19, w19, 65535
.L2687:
	adrp	x1, .LANCHOR71
	ldrb	w0, [x22, 9]
	add	x4, x24, :lo12:.LANCHOR63
	mov	w2, 0
	ldrh	w3, [x1, #:lo12:.LANCHOR71]
	mul	w8, w25, w0
	ldrh	w10, [x4, 24]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR132
	ldr	x7, [x0, #:lo12:.LANCHOR132]
	sub	w3, w3, #1
.L2690:
	cmp	w2, w8
	blt	.L2692
.L2720:
	mov	w23, 1
	b	.L2688
.L2686:
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w20, [x22, 9]
	ldrh	w1, [x0, 314]
	adrp	x0, .LANCHOR192
	add	x0, x0, :lo12:.LANCHOR192
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
	beq	.L2687
.L2688:
	adrp	x0, .LANCHOR29
	str	x0, [x29, 112]
	ldr	w1, [x0, #:lo12:.LANCHOR29]
	tbz	x1, 8, .L2693
	adrp	x0, .LANCHOR132
	ubfiz	x1, x20, 2, 16
	mov	w6, w20
	mov	w3, w19
	ldr	x2, [x0, #:lo12:.LANCHOR132]
	add	x0, x24, :lo12:.LANCHOR63
	ldrh	w4, [x0, 314]
	adrp	x0, .LC151
	ldr	w5, [x2, x1]
	add	x0, x0, :lo12:.LC151
	mov	w2, w23
	mov	w1, w21
	bl	printf
.L2693:
	adrp	x0, .LANCHOR43
	str	wzr, [x29, 152]
	add	x0, x0, :lo12:.LANCHOR43
	str	x0, [x29, 120]
.L2694:
	ldrb	w2, [x22, 9]
	ldr	w0, [x29, 152]
	ldrh	w26, [x29, 152]
	and	w0, w0, 65535
	str	w0, [x29, 156]
	mul	w1, w25, w2
	cmp	w0, w1
	blt	.L2707
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	cmp	w0, 3
	add	x0, x29, 160
	beq	.L2708
	sub	w3, w1, #1
	mov	w2, 0
.L2709:
	cmp	w2, w3
	blt	.L2715
	ldr	x0, [x0, w3, sxtw 3]
	mov	w2, -1
	strb	w2, [x0]
	ldr	x0, [x29, 160]
	bl	sblk_prog_page
	b	.L2714
.L2685:
	adrp	x0, .LANCHOR98
	ldrb	w0, [x0, #:lo12:.LANCHOR98]
	cbnz	w0, .L2689
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w19, [x22, 9]
	mov	w25, 1
	ldrh	w20, [x0, 314]
	sdiv	w21, w20, w19
	msub	w19, w21, w19, w20
	and	w19, w19, 65535
	b	.L2687
.L2689:
	add	x0, x24, :lo12:.LANCHOR63
	ldrb	w19, [x22, 9]
	mov	w25, 2
	ldrh	w20, [x0, 314]
	sdiv	w21, w20, w19
	msub	w19, w21, w19, w20
	and	w19, w19, 65535
	b	.L2687
.L2692:
	add	w5, w20, w2
	cmp	w5, w3
	beq	.L2720
	sbfiz	x5, x5, 2, 32
	ldr	w0, [x7, x5]
	cmn	w0, #1
	bne	.L2691
	ldrh	w6, [x4, 26]
	cmp	w6, w10
	bcs	.L2672
	mov	w0, w6
	bl	gc_get_src_ppa_from_index
	add	w6, w6, 1
	strh	w6, [x4, 26]
	str	w0, [x7, x5]
.L2691:
	add	w2, w2, 1
	and	w2, w2, 65535
	b	.L2690
.L2707:
	ldr	w0, [x29, 156]
	add	w0, w20, w0
	str	w0, [x29, 144]
	sxtw	x27, w0
	adrp	x0, .LANCHOR68
	ldr	x0, [x0, #:lo12:.LANCHOR68]
	ldrb	w0, [x0, x27]
	cmp	w0, 255
	bne	.L2695
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L2696
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	bl	gc_write_completed
	bl	gc_free_temp_buf
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbz	x0, .L2672
.L2696:
	adrp	x0, .LANCHOR68
	ldrb	w1, [x28, 1]
	adrp	x5, .LANCHOR71
	adrp	x6, .LANCHOR132
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
	bne	.L2697
	adrp	x0, .LANCHOR131
	adrp	x4, .LANCHOR72
	stp	x6, x5, [x29, 96]
	ldr	x1, [x0, #:lo12:.LANCHOR131]
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
	ldr	x1, [x6, #:lo12:.LANCHOR132]
	lsl	w2, w0, 2
	add	x0, x7, x0, sxtw 2
	bl	ftl_memcpy
	adrp	x0, .LANCHOR52
	mov	w1, 0
	ldrb	w2, [x0, #:lo12:.LANCHOR52]
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
.L2695:
	adrp	x0, .LANCHOR68
	ldr	w5, [x29, 156]
	add	x3, x29, 160
	ldr	x4, [x0, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR43
	add	x2, x0, :lo12:.LANCHOR43
	ldrb	w1, [x4, x27]
	ubfiz	x0, x1, 6, 8
	add	x0, x2, x0
	add	x2, x2, x1, lsl 6
	str	x0, [x3, w5, sxtw 3]
	mov	w0, 2
	adrp	x5, .LANCHOR133
	strh	w0, [x2, 50]
	ldr	x0, [x29, 128]
	strb	w23, [x2, 61]
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	cmp	w0, 3
	bne	.L2702
	udiv	w0, w26, w0
	adrp	x6, .LANCHOR99
	ldrh	w6, [x6, #:lo12:.LANCHOR99]
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
	ldr	x2, [x5, #:lo12:.LANCHOR133]
	orr	w0, w3, w0, lsl 24
	str	w0, [x2, x6, lsl 2]
.L2703:
	ldr	x0, [x29, 112]
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L2706
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
	adrp	x0, .LC152
	add	x0, x0, :lo12:.LC152
	add	w26, w26, w19
	str	w26, [sp]
	ldr	w5, [x1, 40]
	ldr	w1, [x29, 156]
	bl	printf
.L2706:
	ldr	w0, [x29, 152]
	add	w0, w0, 1
	str	w0, [x29, 152]
	b	.L2694
.L2697:
	ldr	x0, [x6, #:lo12:.LANCHOR132]
	lsl	x4, x27, 2
	mov	w1, 1
	str	x4, [x29, 144]
	ldr	w0, [x0, x4]
	str	w0, [x28, 40]
	mov	x0, x28
	bl	sblk_read_page
	ldr	w0, [x28, 52]
	ldr	x4, [x29, 144]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L2699
	adrp	x0, .LANCHOR96
	ldr	w1, [x28, 40]
	ldrh	w5, [x0, #:lo12:.LANCHOR96]
	mov	w0, 21
	sub	w2, w0, w5
	mov	w0, 1
	lsr	w1, w1, w5
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR95
	ldrb	w2, [x1, #:lo12:.LANCHOR95]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
	ldr	w0, [x28, 52]
	ldr	x4, [x29, 144]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L2699
	ldr	x0, [x28, 24]
	mov	w1, -1
	str	w1, [x0, 4]
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmp	w0, w1, 4, ne
	bne	.L2699
	adrp	x1, .LANCHOR191
	adrp	x0, .LC0
	mov	w2, 688
	add	x1, x1, :lo12:.LANCHOR191
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2700:
	b	.L2700
.L2699:
	ldr	x0, [x28, 24]
	adrp	x1, .LANCHOR54
	ldr	w1, [x1, #:lo12:.LANCHOR54]
	ldr	w2, [x0, 4]
	cmp	w2, w1
	bcc	.L2701
	mov	w1, -1
	str	w1, [x0, 4]
.L2701:
	adrp	x1, .LANCHOR131
	ldr	w2, [x0, 4]
	ldr	x1, [x1, #:lo12:.LANCHOR131]
	str	w2, [x1, x4]
	ldr	w1, [x28, 40]
	str	w1, [x0, 8]
	b	.L2695
.L2702:
	cmp	w0, 2
	bne	.L2704
	adrp	x0, .LANCHOR98
	adrp	x3, .LANCHOR99
	ldrb	w0, [x0, #:lo12:.LANCHOR98]
	cbnz	w0, .L2705
	ldr	w0, [x29, 156]
	ldrh	w3, [x3, #:lo12:.LANCHOR99]
	add	w0, w19, w0
	add	x0, x22, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w3, w21
.L2763:
	orr	w0, w0, 33554432
	str	w0, [x2, 40]
.L2704:
	ldr	x0, [x29, 120]
	add	x0, x0, x1, lsl 6
	ldrh	w2, [x0, 48]
	ldr	w3, [x0, 40]
	ldr	x0, [x5, #:lo12:.LANCHOR133]
	str	w3, [x0, x2, lsl 2]
	b	.L2703
.L2705:
	add	w0, w19, w26, lsr 1
	ldrh	w3, [x3, #:lo12:.LANCHOR99]
	add	x0, x22, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w3, w21
	and	w3, w26, 1
	add	w0, w0, w3
	b	.L2763
.L2708:
	adrp	x1, .LANCHOR69
	ldrb	w3, [x1, #:lo12:.LANCHOR69]
	ldr	x1, [x29, 160]
	cbz	w3, .L2710
.L2713:
	strb	wzr, [x1, 60]
	b	.L2711
.L2710:
	cmp	w23, 1
	bne	.L2712
	mov	w3, 9
.L2762:
	strb	w3, [x1, 60]
.L2711:
	add	x1, x0, 24
	bl	sblk_xlc_prog_pages
.L2714:
	adrp	x1, .LANCHOR69
	ldrb	w3, [x22, 9]
	ldrb	w1, [x1, #:lo12:.LANCHOR69]
	and	w0, w3, 65535
	cbz	w1, .L2716
	add	w0, w0, w0, lsl 1
.L2717:
	adrp	x1, .LANCHOR53
	add	x24, x24, :lo12:.LANCHOR63
	ldr	x1, [x1, #:lo12:.LANCHOR53]
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
	blt	.L2718
	ldr	x0, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	strh	wzr, [x0, 86]
.L2718:
	bl	gc_write_completed
	b	.L2672
.L2712:
	cmp	w23, 2
	bne	.L2713
	mov	w3, 13
	b	.L2762
.L2715:
	ldr	x4, [x0, w2, sxtw 3]
	add	w2, w2, 1
	ldr	x5, [x0, w2, sxtw 3]
	and	w2, w2, 65535
	ldrb	w5, [x5, 1]
	strb	w5, [x4]
	b	.L2709
.L2716:
	adrp	x1, .LANCHOR98
	ldrb	w2, [x1, #:lo12:.LANCHOR98]
	mov	w1, w0
	ubfiz	w0, w0, 1, 15
	cmp	w2, 0
	csel	w0, w0, w1, ne
	b	.L2717
	.size	gc_do_copy_back, .-gc_do_copy_back
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
	adrp	x19, .LANCHOR130
	stp	x21, x22, [sp, 48]
	ldrh	w20, [x2, #:lo12:.LANCHOR89]
	stp	x23, x24, [sp, 64]
	adrp	x23, .LANCHOR5
	ldrh	w21, [x1, #:lo12:.LANCHOR93]
	ldrb	w2, [x19, #:lo12:.LANCHOR130]
	stp	x25, x26, [sp, 80]
	add	w20, w21, w20
	ldr	x22, [x23, #:lo12:.LANCHOR5]
	cmp	w2, 6
	bhi	.L2868
	mov	w24, w0
	and	w20, w20, 65535
	adrp	x0, .L2767
	mov	x25, x1
	add	x0, x0, :lo12:.L2767
	ldrh	w0, [x0,w2,uxtw #1]
	adr	x1, .Lrtx2767
	add	x0, x1, w0, sxth #2
	br	x0
.Lrtx2767:
	.section	.rodata.zftl_do_gc,"a",@progbits
	.align	0
	.align	2
.L2767:
	.2byte	(.L2766 - .Lrtx2767) / 4
	.2byte	(.L2768 - .Lrtx2767) / 4
	.2byte	(.L2769 - .Lrtx2767) / 4
	.2byte	(.L2770 - .Lrtx2767) / 4
	.2byte	(.L2771 - .Lrtx2767) / 4
	.2byte	(.L2772 - .Lrtx2767) / 4
	.2byte	(.L2773 - .Lrtx2767) / 4
	.section	.text.zftl_do_gc
.L2772:
	adrp	x21, .LANCHOR63
	add	x25, x21, :lo12:.LANCHOR63
	mov	w22, 0
.L2774:
	bl	gc_check_data_one_wl
	cbz	w0, .L2841
	ldr	x0, [x23, #:lo12:.LANCHOR5]
	add	x21, x21, :lo12:.LANCHOR63
	strh	wzr, [x21, 56]
	ldrh	w0, [x0, 80]
	bl	ftl_free_sblk
	adrp	x2, .LANCHOR53
	ldr	x1, [x23, #:lo12:.LANCHOR5]
	mov	w0, -1
	ldr	x2, [x2, #:lo12:.LANCHOR53]
	strh	w0, [x1, 80]
	strh	w0, [x2, 126]
	strh	w0, [x1, 130]
	ldr	x0, [x21, 8]
	bl	buf_free
	strb	wzr, [x19, #:lo12:.LANCHOR130]
	str	xzr, [x21, 8]
	b	.L2890
.L2766:
	adrp	x0, .LANCHOR91
	mov	w1, 65535
	ldrh	w4, [x0, #:lo12:.LANCHOR91]
	ldrh	w0, [x22, 80]
	add	w21, w21, w4
	and	w21, w21, 65535
	cmp	w0, w1
	beq	.L2775
	adrp	x1, .LANCHOR29
	cmp	w21, 7
	mov	w23, 3
	adrp	x24, .LANCHOR70
	ldr	w1, [x1, #:lo12:.LANCHOR29]
	csinc	w23, w23, wzr, hi
	tbz	x1, 8, .L2777
	ldrh	w7, [x22, 122]
	mov	w4, w21
	ldrh	w6, [x22, 120]
	mov	w3, w20
	ldrh	w5, [x22, 124]
	mov	w1, 1705
	ldrb	w2, [x24, #:lo12:.LANCHOR70]
	str	w0, [sp]
	adrp	x0, .LC153
	add	x0, x0, :lo12:.LC153
	bl	printf
.L2777:
	ldrb	w0, [x24, #:lo12:.LANCHOR70]
	mov	w2, 1
	mov	w1, w23
	bl	gc_search_src_blk
	cmp	w0, 0
	ble	.L2868
.L2778:
	mov	w0, 1
.L2889:
	strb	w0, [x19, #:lo12:.LANCHOR130]
	b	.L2868
.L2775:
	adrp	x0, .LANCHOR84
	cmp	w24, 1
	ldrh	w25, [x0, #:lo12:.LANCHOR84]
	adrp	x0, .LANCHOR82
	ldrh	w26, [x0, #:lo12:.LANCHOR82]
	bne	.L2779
	bl	gc_scan_static_data
	bl	gc_static_wearleveling
.L2780:
	ldr	x2, [x23, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR70
	mov	w0, 1
	mov	x23, x1
	strb	w0, [x1, #:lo12:.LANCHOR70]
	ldrh	w5, [x2, 124]
	cbz	w5, .L2782
	strb	w0, [x19, #:lo12:.LANCHOR130]
	adrp	x0, .LANCHOR29
	strb	wzr, [x1, #:lo12:.LANCHOR70]
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L2868
	ldrh	w7, [x2, 122]
	mov	w4, w21
	ldrh	w6, [x2, 120]
	mov	w3, w20
	mov	w2, 0
	mov	w1, 1762
	adrp	x0, .LC154
	add	x0, x0, :lo12:.LC154
	bl	printf
	b	.L2868
.L2779:
	adrp	x0, .LANCHOR73
	ldrh	w0, [x0, #:lo12:.LANCHOR73]
	cmp	w0, w20
	bcs	.L2780
.L2868:
	mov	w0, 16
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 96
	ret
.L2782:
	adrp	x22, .LANCHOR73
	ldrh	w1, [x22, #:lo12:.LANCHOR73]
	cmp	w20, w1
	bcs	.L2783
	cmp	w21, 1
	bls	.L2784
	cmp	w21, 16
	bls	.L2785
	adrp	x1, .LANCHOR86
	ldrh	w2, [x1, #:lo12:.LANCHOR86]
	adrp	x1, .LANCHOR87
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	cmp	w2, w1
	bcs	.L2785
	mov	w2, 16
	mov	w1, 3
.L2886:
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L2786:
	cbnz	w0, .L2778
	b	.L2868
.L2785:
	mov	w2, 2
	mov	w1, w2
	mov	w0, 1
.L2893:
	bl	gc_search_src_blk
	tst	w0, 65535
	bne	.L2778
	mov	w2, 2
	b	.L2887
.L2784:
	adrp	x0, .LANCHOR29
	strb	wzr, [x23, #:lo12:.LANCHOR70]
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	tbz	x0, 8, .L2788
	ldrh	w7, [x2, 122]
	adrp	x0, .LC154
	ldrh	w6, [x2, 120]
	mov	w5, 0
	mov	w4, w21
	mov	w3, w20
	mov	w2, 0
	mov	w1, 1778
	add	x0, x0, :lo12:.LC154
	bl	printf
.L2788:
	cmp	w20, 16
	bls	.L2789
	mov	w2, 4
.L2887:
	mov	w1, 3
	ldrb	w0, [x23, #:lo12:.LANCHOR70]
	b	.L2886
.L2789:
	mov	w2, 1
	ldrb	w0, [x23, #:lo12:.LANCHOR70]
	mov	w1, w2
	b	.L2893
.L2783:
	cmp	w24, 1
	lsl	w1, w1, 1
	bne	.L2791
	cmp	w20, w1
	bge	.L2791
	add	w0, w25, w26
	and	w0, w0, 65535
	cmp	w0, w21, lsr 1
	bcs	.L2792
	adrp	x1, .LANCHOR86
	ldrh	w2, [x1, #:lo12:.LANCHOR86]
	adrp	x1, .LANCHOR87
	ldrh	w1, [x1, #:lo12:.LANCHOR87]
	cmp	w2, w1
	bcs	.L2792
.L2796:
	adrp	x0, .LANCHOR83
	ldrh	w0, [x0, #:lo12:.LANCHOR83]
	lsr	w0, w0, 1
	strh	w0, [x22, #:lo12:.LANCHOR73]
	b	.L2868
.L2792:
	cmp	w21, 1
	adrp	x24, .LANCHOR83
	bls	.L2793
	cmp	w21, 16
	bls	.L2794
	mov	w2, 8
	mov	w1, 3
	mov	w0, 1
.L2884:
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L2795:
	ldrh	w1, [x24, #:lo12:.LANCHOR83]
	strh	w1, [x22, #:lo12:.LANCHOR73]
	b	.L2786
.L2794:
	mov	w2, 2
	mov	w0, 1
	mov	w1, w2
	bl	gc_search_src_blk
	ands	w0, w0, 65535
	bne	.L2795
	mov	w2, 2
	mov	w1, 3
	ldrb	w0, [x23, #:lo12:.LANCHOR70]
	b	.L2884
.L2793:
	cmp	w20, w0
	bcs	.L2796
	strb	wzr, [x23, #:lo12:.LANCHOR70]
	mov	w2, 8
	mov	w1, 3
	mov	w0, 0
	b	.L2884
.L2791:
	cmp	w20, w1
	bge	.L2796
	b	.L2868
.L2768:
	adrp	x7, .LANCHOR63
	mov	w0, 65535
	ldrh	w1, [x7, #:lo12:.LANCHOR63]
	cmp	w1, w0
	bne	.L2797
	bl	gc_get_src_blk
	strh	w0, [x7, #:lo12:.LANCHOR63]
.L2797:
	ldrh	w3, [x7, #:lo12:.LANCHOR63]
	mov	w0, 65535
	add	x1, x7, :lo12:.LANCHOR63
	cmp	w3, w0
	beq	.L2798
	adrp	x0, .LANCHOR3
	ldrh	w5, [x1, 56]
	uxtw	x4, w3
	ldr	x2, [x0, #:lo12:.LANCHOR3]
	add	x2, x2, x4, lsl 2
	cbz	w5, .L2799
	add	x1, x1, 58
	mov	w0, 0
.L2801:
	ldrh	w6, [x1], 2
	cmp	w6, w3
	bne	.L2800
.L2804:
	adrp	x0, .LANCHOR63
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR63]
	b	.L2868
.L2800:
	add	w0, w0, 1
	and	w0, w0, 65535
	cmp	w5, w0
	bne	.L2801
.L2799:
	ldrb	w0, [x2, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L2802
	tst	w0, 192
	bne	.L2803
.L2802:
	adrp	x0, .LANCHOR4
	ldr	x0, [x0, #:lo12:.LANCHOR4]
	ldrh	w0, [x0, x4, lsl 1]
	cbz	w0, .L2804
	adrp	x1, .LANCHOR193
	adrp	x0, .LC0
	mov	w2, 1972
	add	x1, x1, :lo12:.LANCHOR193
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2805:
	b	.L2805
.L2803:
	mov	w0, 2
	b	.L2889
.L2798:
	strb	wzr, [x19, #:lo12:.LANCHOR130]
	b	.L2868
.L2769:
	bl	gc_scan_src_blk
	cmn	w0, #1
	bne	.L2806
	mov	w0, 3
	b	.L2889
.L2806:
	adrp	x21, .LANCHOR63
	mov	w1, 65535
	add	x20, x21, :lo12:.LANCHOR63
	ldrh	w0, [x21, #:lo12:.LANCHOR63]
	cmp	w0, w1
	beq	.L2778
	ldrh	w1, [x20, 24]
	cbz	w1, .L2807
	mov	w0, 4
	strh	wzr, [x20, 26]
	strb	w0, [x19, #:lo12:.LANCHOR130]
	b	.L2868
.L2807:
	mov	w1, 1
	strb	w1, [x19, #:lo12:.LANCHOR130]
	adrp	x19, .LANCHOR4
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x19, #:lo12:.LANCHOR4]
	ldrh	w1, [x2, x1]
	cbz	w1, .L2808
	adrp	x1, .LANCHOR193
	adrp	x0, .LC0
	mov	w2, 2000
	add	x1, x1, :lo12:.LANCHOR193
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2809:
	b	.L2809
.L2808:
	bl	ftl_free_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR4]
	ldrh	w1, [x21, #:lo12:.LANCHOR63]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x20, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x20, 30]
	cmp	w0, 8
	bls	.L2804
	strh	wzr, [x20, 30]
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	b	.L2804
.L2770:
	adrp	x22, .LANCHOR63
	adrp	x23, .LANCHOR80
	add	x21, x22, :lo12:.LANCHOR63
	add	x23, x23, :lo12:.LANCHOR80
.L2869:
	bl	gc_scan_src_blk_one_page
	ldrh	w1, [x21, 2]
	ldrh	w0, [x23]
	cmp	w1, w0
	bcs	.L2810
	cmp	w20, 7
	bls	.L2869
	b	.L2868
.L2810:
	ldrh	w3, [x21, 24]
	adrp	x0, .LANCHOR29
	cbz	w3, .L2811
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	mov	w1, 4
	strh	wzr, [x21, 26]
	strb	w1, [x19, #:lo12:.LANCHOR130]
	adrp	x19, .LANCHOR4
	tbz	x0, 8, .L2812
	ldrh	w1, [x21]
	ldr	x2, [x19, #:lo12:.LANCHOR4]
	ubfiz	x0, x1, 1, 16
	ldrh	w2, [x2, x0]
	adrp	x0, .LC155
	add	x0, x0, :lo12:.LC155
	bl	printf
.L2812:
	ldrh	w2, [x22, #:lo12:.LANCHOR63]
	add	x0, x22, :lo12:.LANCHOR63
	ldr	x1, [x19, #:lo12:.LANCHOR4]
	ldrh	w0, [x0, 24]
	ldrh	w1, [x1, x2, lsl 1]
	cmp	w1, w0
	beq	.L2868
	adrp	x1, .LANCHOR193
	adrp	x0, .LC0
	mov	w2, 2034
	add	x1, x1, :lo12:.LANCHOR193
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2813:
	b	.L2813
.L2811:
	adrp	x2, .LANCHOR3
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	ldrh	w1, [x21]
	ldr	x20, [x2, #:lo12:.LANCHOR3]
	mov	w2, 1
	strb	w2, [x19, #:lo12:.LANCHOR130]
	add	x20, x20, x1, uxth 2
	tbz	x0, 8, .L2814
	ldrb	w2, [x20, 2]
	adrp	x0, .LC156
	add	x0, x0, :lo12:.LC156
	ubfx	x2, x2, 5, 3
	bl	printf
.L2814:
	ldrb	w0, [x20, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L2815
	tst	w0, 192
	bne	.L2816
.L2815:
	adrp	x1, .LANCHOR193
	adrp	x0, .LC0
	mov	w2, 2044
	add	x1, x1, :lo12:.LANCHOR193
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2817:
	b	.L2817
.L2816:
	ldrh	w0, [x22, #:lo12:.LANCHOR63]
	add	x19, x22, :lo12:.LANCHOR63
	bl	ftl_free_sblk
	mov	w0, -1
	strh	w0, [x22, #:lo12:.LANCHOR63]
	ldrh	w0, [x19, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 30]
	cmp	w0, 8
	bls	.L2868
	strh	wzr, [x19, 30]
.L2890:
	bl	flt_sys_flush
	b	.L2868
.L2771:
	ldrh	w1, [x22, 80]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2818
	adrp	x0, .LANCHOR70
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	cmp	w0, 1
	bne	.L2818
	bl	ftl_flush
	ldrh	w0, [x25, #:lo12:.LANCHOR93]
	cbz	w0, .L2819
.L2888:
	mov	w1, 5
	lsr	w0, w0, 1
	bl	zftl_get_free_sblk
	and	w20, w0, 65535
	mov	w1, 65535
	cmp	w20, w1
	beq	.L2821
	adrp	x1, .LANCHOR3
	ldr	x2, [x1, #:lo12:.LANCHOR3]
	add	x2, x2, x20, uxth 2
	ldrb	w1, [x2, 2]
	tst	w1, 224
	beq	.L2822
	adrp	x1, .LANCHOR193
	adrp	x0, .LC0
	mov	w2, 2069
	add	x1, x1, :lo12:.LANCHOR193
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2823:
	b	.L2823
.L2819:
	adrp	x0, .LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	b	.L2888
.L2822:
	mov	w21, 5
	bfi	w1, w21, 5, 3
	orr	w1, w1, 16
	strb	w1, [x2, 2]
	mov	w1, 1
	bl	ftl_erase_sblk
	strb	w21, [x22, 84]
	add	x1, x22, 96
	mov	w0, w20
	bl	ftl_get_blk_list_in_sblk
	and	w0, w0, 255
	adrp	x1, .LANCHOR80
	strb	w0, [x22, 89]
	adrp	x21, .LANCHOR72
	strh	w20, [x22, 80]
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	strh	wzr, [x22, 82]
	strb	wzr, [x22, 85]
	strh	wzr, [x22, 90]
	mul	w0, w0, w1
	mov	w1, 255
	strh	w0, [x22, 86]
	adrp	x22, .LANCHOR71
	ldrb	w0, [x21, #:lo12:.LANCHOR72]
	ldrh	w2, [x22, #:lo12:.LANCHOR71]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR131
	ldr	x0, [x0, #:lo12:.LANCHOR131]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x21, #:lo12:.LANCHOR72]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR71]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR132
	ldr	x0, [x0, #:lo12:.LANCHOR132]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x21, #:lo12:.LANCHOR72]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR71]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR68
	ldr	x0, [x0, #:lo12:.LANCHOR68]
	bl	ftl_memset
	ldr	x0, [x23, #:lo12:.LANCHOR5]
	mov	w1, -1
	str	w20, [x0, 132]
	strh	w1, [x0, 128]
	strh	w1, [x0, 130]
	bl	pm_flush
	bl	ftl_ext_info_flush
	adrp	x0, .LANCHOR53
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR53]
	strh	w20, [x0, 126]
	adrp	x0, .LANCHOR63
	add	x0, x0, :lo12:.LANCHOR63
	str	w1, [x0, 320]
	strh	wzr, [x0, 314]
	strh	wzr, [x0, 56]
	strh	wzr, [x0, 316]
	strh	wzr, [x0, 318]
	mov	w0, 0
	bl	ftl_info_flush
	b	.L2868
.L2818:
	cmp	w24, 1
	mov	w21, 4
	csinc	w21, w21, wzr, eq
	cmp	w20, 15
	mov	w0, w21
	add	w21, w21, 4
	adrp	x25, .LANCHOR70
	adrp	x24, .LANCHOR63
	csel	w21, w21, w0, ls
	add	x25, x25, :lo12:.LANCHOR70
	add	x20, x24, :lo12:.LANCHOR63
	add	x26, x22, 80
.L2827:
	sub	w21, w21, #1
	and	w21, w21, 255
	cmp	w21, 255
	beq	.L2868
	bl	gc_do_copy_back
	ldrb	w0, [x25]
	cbnz	w0, .L2828
	adrp	x0, .LANCHOR45
	ldrb	w0, [x0, #:lo12:.LANCHOR45]
	cmp	w0, 3
	bhi	.L2829
	bl	ftl_write_commit
.L2829:
	ldrh	w1, [x20, 26]
	ldrh	w0, [x20, 24]
	cmp	w1, w0
	bcc	.L2827
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR130]
	bl	ftl_write_commit
	bl	ftl_flush
	ldrh	w0, [x20]
	adrp	x2, .LANCHOR4
	ldr	x2, [x2, #:lo12:.LANCHOR4]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbz	w1, .L2831
	adrp	x1, .LANCHOR193
	adrp	x0, .LC0
	mov	w2, 2144
	add	x1, x1, :lo12:.LANCHOR193
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2832:
	b	.L2832
.L2831:
	bl	ftl_free_sblk
.L2891:
	mov	w0, -1
	strh	w0, [x20]
	b	.L2868
.L2828:
	ldrh	w0, [x20, 318]
	cbz	w0, .L2833
	ldr	w0, [x20, 320]
	strh	wzr, [x20, 318]
	cmn	w0, #1
	beq	.L2834
	bl	ftl_mask_bad_block
.L2834:
	ldr	x0, [x23, #:lo12:.LANCHOR5]
	add	x20, x24, :lo12:.LANCHOR63
	strh	wzr, [x20, 56]
	ldrh	w0, [x0, 80]
	str	wzr, [x20, 320]
	bl	ftl_free_sblk
	adrp	x2, .LANCHOR53
	ldr	x1, [x23, #:lo12:.LANCHOR5]
	mov	w0, -1
	ldr	x2, [x2, #:lo12:.LANCHOR53]
	strh	w0, [x1, 80]
	strh	w0, [x2, 126]
	strh	w0, [x1, 130]
	ldr	x0, [x20, 8]
	cbz	x0, .L2835
	bl	buf_free
.L2835:
	add	x24, x24, :lo12:.LANCHOR63
	str	xzr, [x24, 8]
	bl	flt_sys_flush
	adrp	x1, .LANCHOR193
	adrp	x0, .LC0
	strb	wzr, [x19, #:lo12:.LANCHOR130]
	mov	w2, 2177
	add	x1, x1, :lo12:.LANCHOR193
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2836:
	b	.L2836
.L2833:
	ldrh	w0, [x26, 6]
	ldrh	w1, [x20, 26]
	cmp	w0, 1
	ldrh	w0, [x20, 24]
	bls	.L2837
	cmp	w1, w0
	bcc	.L2827
	mov	w0, 1
	strb	w0, [x19, #:lo12:.LANCHOR130]
	ldrh	w0, [x20, 56]
	add	w1, w0, 1
	strh	w1, [x20, 56]
	add	x0, x20, x0, sxtw 1
	ldrh	w1, [x20]
	strh	w1, [x0, 58]
	b	.L2891
.L2837:
	mov	w2, 5
	strb	w2, [x19, #:lo12:.LANCHOR130]
	cmp	w1, w0
	bcc	.L2838
	ldrh	w0, [x20, 56]
	add	w1, w0, 1
	strh	w1, [x20, 56]
	add	x0, x20, x0, sxtw 1
	ldrh	w1, [x20]
	strh	w1, [x0, 58]
	mov	w0, -1
	strh	w0, [x20]
.L2838:
	bl	ftl_flush
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	x0, [x23, #:lo12:.LANCHOR5]
	ldrh	w1, [x22, 80]
	strh	w1, [x0, 128]
	bl	pm_flush
	bl	ftl_ext_info_flush
	add	x0, x24, :lo12:.LANCHOR63
	adrp	x1, .LANCHOR80
	adrp	x2, .LANCHOR67
	ldrh	w1, [x1, #:lo12:.LANCHOR80]
	ldrb	w2, [x2, #:lo12:.LANCHOR67]
	strh	wzr, [x0, 16]
	strh	w1, [x0, 18]
	cmp	w2, 2
	strh	w2, [x0, 20]
	bne	.L2839
	ubfiz	w1, w1, 1, 15
	strh	w1, [x0, 18]
	mov	w1, 1
	strh	w1, [x0, 20]
.L2839:
	add	x24, x24, :lo12:.LANCHOR63
	strh	wzr, [x24, 22]
	b	.L2868
.L2841:
	ldrh	w1, [x25, 16]
	ldrh	w0, [x25, 18]
	cmp	w1, w0
	bcc	.L2842
	mov	w0, 6
	strb	w0, [x19, #:lo12:.LANCHOR130]
	ldr	x0, [x25, 8]
	bl	buf_free
	str	xzr, [x25, 8]
	b	.L2868
.L2842:
	cmp	w20, 7
	bls	.L2774
	cmp	w24, 1
	bne	.L2868
	add	w22, w22, 1
	and	w22, w22, 255
	cmp	w22, 4
	bls	.L2774
	b	.L2868
.L2773:
	bl	gc_update_l2p_map_new
	mov	w20, -1
	bl	gc_free_src_blk
	bl	ftl_flush
	bl	pm_flush
	strh	w20, [x22, 80]
	bl	ftl_ext_info_flush
	adrp	x0, .LANCHOR53
	ldr	x0, [x0, #:lo12:.LANCHOR53]
	strh	w20, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
	strb	wzr, [x19, #:lo12:.LANCHOR130]
	bl	print_ftl_debug_info
	b	.L2868
.L2821:
	adrp	x1, .LANCHOR193
	adrp	x0, .LC0
	mov	w2, 2075
	add	x1, x1, :lo12:.LANCHOR193
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2824:
	b	.L2824
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
	adrp	x0, .LANCHOR29
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	mov	w19, w1
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	mov	w20, w2
	stp	x21, x22, [sp, 32]
	mov	x24, x3
	stp	x25, x26, [sp, 64]
	tbz	x0, 12, .L2895
	mov	w3, w2
	adrp	x0, .LC157
	mov	w2, w1
	add	x0, x0, :lo12:.LC157
	mov	w1, w27
	bl	printf
.L2895:
	cbnz	w27, .L2896
	adrp	x0, .LANCHOR59
	mov	w27, 24576
	ldr	w0, [x0, #:lo12:.LANCHOR59]
.L2897:
	add	w1, w19, w20
	cmp	w0, w1
	bcc	.L2911
	adrp	x23, .LANCHOR52
	add	w27, w27, w19
	sub	w19, w20, #1
	adrp	x25, .LANCHOR53
	ldrb	w0, [x23, #:lo12:.LANCHOR52]
	add	w19, w19, w27
	add	x23, x23, :lo12:.LANCHOR52
	udiv	w22, w27, w0
	udiv	w19, w19, w0
	add	w0, w27, w20
	str	w0, [x29, 108]
	mov	w26, w22
	sub	w21, w19, w22
	add	w21, w21, 1
.L2899:
	cbnz	w21, .L2907
	adrp	x20, .LANCHOR89
	adrp	x19, .LANCHOR93
	add	x20, x20, :lo12:.LANCHOR89
	add	x19, x19, :lo12:.LANCHOR93
	bl	ftl_write_commit
	mov	w1, 1
	mov	w0, 0
	bl	zftl_do_gc
.L2908:
	ldrh	w0, [x20]
	ldrh	w1, [x19]
	add	w0, w0, w1
	cmp	w0, 7
	ble	.L2909
	mov	w0, 0
.L2894:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2896:
	cmp	w27, 3
	bhi	.L2911
	lsl	w27, w27, 13
	mov	w0, 8192
	b	.L2897
.L2907:
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L2900
	bl	ftl_write_commit
	b	.L2899
.L2900:
	ldrb	w3, [x23]
	cmp	w26, w22
	strb	wzr, [x0, 57]
	ccmp	w26, w19, 4, ne
	strb	w3, [x0, 56]
	bne	.L2903
	cmp	w26, w22
	bne	.L2904
	udiv	w0, w27, w3
	msub	w0, w0, w3, w27
	and	w0, w0, 255
	strb	w0, [x28, 57]
	sub	w3, w3, w0
	and	w3, w3, 255
	cmp	w20, w3
	csel	w3, w20, w3, cc
.L2916:
	strb	w3, [x28, 56]
.L2903:
	ldr	x3, [x28, 8]
	mov	x1, x24
	ldrb	w0, [x28, 57]
	sub	w21, w21, #1
	ldrb	w2, [x28, 56]
	ubfiz	x0, x0, 9, 8
	lsl	w2, w2, 9
	add	x0, x3, x0
	bl	ftl_memcpy
	ldr	x1, [x25, #:lo12:.LANCHOR53]
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
	b	.L2899
.L2904:
	ldr	w0, [x29, 108]
	msub	w3, w3, w26, w0
	b	.L2916
.L2909:
	mov	w1, 1
	mov	w0, 0
	bl	zftl_do_gc
	b	.L2908
.L2911:
	mov	w0, -1
	b	.L2894
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
	and	w0, w0, 255
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
	bcc	.L2942
	adrp	x25, .LANCHOR52
	adrp	x23, .LANCHOR194
	add	w24, w0, 24576
	adrp	x22, .LANCHOR53
	ldrb	w21, [x25, #:lo12:.LANCHOR52]
	ldr	w0, [x23, #:lo12:.LANCHOR194]
	add	w0, w0, w19
	str	w0, [x23, #:lo12:.LANCHOR194]
	udiv	w20, w24, w21
	ldr	x0, [x22, #:lo12:.LANCHOR53]
	msub	w27, w20, w21, w24
	ldr	w26, [x0, 8]
	add	w1, w26, 1
	str	w1, [x0, 8]
	cbz	w27, .L2924
	sub	w21, w21, w27
	mov	w0, w20
	cmp	w21, w19
	csel	w21, w21, w19, ls
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	bne	.L2925
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
.L2925:
	ldr	w0, [x29, 120]
	and	w28, w21, 65535
	cmn	w0, #1
	beq	.L2927
	mov	w0, 0
	bl	buf_alloc
	mov	x3, x0
	cbz	x0, .L2927
	strb	w27, [x0, 57]
	ubfiz	x27, x27, 9, 25
	strb	w21, [x0, 56]
	mov	w1, 0
	ldr	x0, [x0, 8]
	lsl	w2, w28, 9
	stp	w26, w20, [x3, 32]
	str	x3, [x29, 104]
	add	x0, x0, x27
	bl	ftl_memset
	ldr	x3, [x29, 104]
	mov	x0, x3
	bl	ftl_write_buf
	bl	ftl_write_commit
	ldr	x1, [x22, #:lo12:.LANCHOR53]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L2927:
	add	w20, w20, 1
	sub	w19, w19, w28
.L2924:
	cbz	w19, .L2929
	bl	ftl_flush
.L2929:
	adrp	x27, .LANCHOR96
	add	x21, x25, :lo12:.LANCHOR52
	add	x27, x27, :lo12:.LANCHOR96
	mov	w0, -1
	str	w0, [x29, 124]
.L2930:
	ldrb	w0, [x21]
	cmp	w19, w0
	bcs	.L2935
	cbz	w19, .L2937
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	bne	.L2938
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
.L2938:
	ldr	w0, [x29, 120]
	cmn	w0, #1
	beq	.L2937
	mov	w0, 0
	bl	buf_alloc
	mov	x21, x0
	cbz	x0, .L2937
	strb	wzr, [x0, 57]
	strb	w19, [x0, 56]
	stp	w26, w20, [x21, 32]
	ldrb	w0, [x25, #:lo12:.LANCHOR52]
	cmp	w19, w0
	bcc	.L2940
	adrp	x1, .LANCHOR195
	adrp	x0, .LC0
	mov	w2, 1117
	add	x1, x1, :lo12:.LANCHOR195
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2941:
	b	.L2941
.L2935:
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 120]
	cmn	w0, #1
	beq	.L2931
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbz	x0, .L2933
	ldrb	w2, [x21]
	mov	w1, 0
	strb	w2, [x0, 56]
	strb	wzr, [x0, 57]
	ldr	x0, [x0, 8]
	lsl	w2, w2, 9
	stp	w26, w20, [x28, 32]
	bl	ftl_memset
	mov	x0, x28
	bl	ftl_write_buf
	bl	ftl_write_commit
.L2963:
	ldr	x1, [x22, #:lo12:.LANCHOR53]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L2933:
	ldrb	w0, [x21]
	add	w20, w20, 1
	sub	w19, w19, w0
	b	.L2930
.L2931:
	mov	w2, 0
	add	x1, x29, 120
	mov	w0, w20
	bl	pm_log2phys
	ldr	w0, [x29, 120]
	cmn	w0, #1
	beq	.L2933
	add	x1, x29, 124
	mov	w2, 1
	mov	w0, w20
	bl	pm_log2phys
	ldrh	w3, [x27]
	mov	w1, 21
	ldr	w0, [x29, 120]
	sub	w2, w1, w3
	mov	w1, 1
	lsr	w0, w0, w3
	lsl	w1, w1, w2
	sub	w1, w1, #1
	and	w1, w1, w0
	adrp	x0, .LANCHOR95
	ldrb	w0, [x0, #:lo12:.LANCHOR95]
	udiv	w0, w1, w0
	bl	ftl_vpn_decrement
	b	.L2963
.L2940:
	ldr	x0, [x21, 8]
	lsl	w2, w19, 9
	mov	w1, 0
	bl	ftl_memset
	mov	x0, x21
	bl	ftl_write_buf
	bl	ftl_write_commit
	ldr	x1, [x22, #:lo12:.LANCHOR53]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L2937:
	ldr	w1, [x23, #:lo12:.LANCHOR194]
	cmp	w1, 8192
	bls	.L2943
	mov	w3, w19
	mov	w2, w24
	mov	w4, 0
	adrp	x0, .LC158
	add	x0, x0, :lo12:.LC158
	bl	printf
	str	wzr, [x23, #:lo12:.LANCHOR194]
	bl	flt_sys_flush
	adrp	x0, .LANCHOR196
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR196]
.L2943:
	mov	w0, 0
	b	.L2922
.L2942:
	mov	w0, -1
.L2922:
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
	.global	g_nandc_v6_master_info
	.global	nandc_randomizer_en
	.global	nandc_hw_seed
	.global	fill_spare_size
	.global	g_nandc_ecc_bits
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
	.set	.LANCHOR33,. + 0
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
	.set	.LANCHOR99,. + 0
	.type	_c_ftl_block_align_addr, %object
	.size	_c_ftl_block_align_addr, 2
_c_ftl_block_align_addr:
	.zero	2
	.section	.bss._c_ftl_byte_pre_page,"aw",@nobits
	.align	1
	.set	.LANCHOR173,. + 0
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
	.set	.LANCHOR100,. + 0
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
	.set	.LANCHOR161,. + 0
	.type	_c_ftl_pm_page_num, %object
	.size	_c_ftl_pm_page_num, 2
_c_ftl_pm_page_num:
	.zero	2
	.section	.bss._c_ftl_sec_per_page,"aw",@nobits
	.set	.LANCHOR52,. + 0
	.type	_c_ftl_sec_per_page, %object
	.size	_c_ftl_sec_per_page, 1
_c_ftl_sec_per_page:
	.zero	1
	.section	.bss._c_max_pm_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR127,. + 0
	.type	_c_max_pm_sblk, %object
	.size	_c_max_pm_sblk, 2
_c_max_pm_sblk:
	.zero	2
	.section	.bss._c_mix_max_slc_ec_count,"aw",@nobits
	.align	1
	.set	.LANCHOR180,. + 0
	.type	_c_mix_max_slc_ec_count, %object
	.size	_c_mix_max_slc_ec_count, 2
_c_mix_max_slc_ec_count:
	.zero	2
	.section	.bss._c_mix_max_xlc_ec_count,"aw",@nobits
	.align	1
	.set	.LANCHOR181,. + 0
	.type	_c_mix_max_xlc_ec_count, %object
	.size	_c_mix_max_xlc_ec_count, 2
_c_mix_max_xlc_ec_count:
	.zero	2
	.section	.bss._c_swl_slc_gc_th,"aw",@nobits
	.align	1
	.set	.LANCHOR126,. + 0
	.type	_c_swl_slc_gc_th, %object
	.size	_c_swl_slc_gc_th, 2
_c_swl_slc_gc_th:
	.zero	2
	.section	.bss._c_swl_xlc_gc_th,"aw",@nobits
	.align	1
	.set	.LANCHOR125,. + 0
	.type	_c_swl_xlc_gc_th, %object
	.size	_c_swl_xlc_gc_th, 2
_c_swl_xlc_gc_th:
	.zero	2
	.section	.bss._c_totle_data_density,"aw",@nobits
	.align	2
	.set	.LANCHOR178,. + 0
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
	.set	.LANCHOR177,. + 0
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
	.set	.LANCHOR196,. + 0
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
	.set	.LANCHOR179,. + 0
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
	.set	.LANCHOR194,. + 0
	.type	discard_sector_count, %object
	.size	discard_sector_count, 4
discard_sector_count:
	.zero	4
	.section	.bss.fill_spare_size,"aw",@nobits
	.align	1
	.set	.LANCHOR38,. + 0
	.type	fill_spare_size, %object
	.size	fill_spare_size, 2
fill_spare_size:
	.zero	2
	.section	.bss.flash_read_retry,"aw",@nobits
	.align	3
	.set	.LANCHOR139,. + 0
	.type	flash_read_retry, %object
	.size	flash_read_retry, 8
flash_read_retry:
	.zero	8
	.section	.bss.free_buf_count,"aw",@nobits
	.set	.LANCHOR45,. + 0
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
	.section	.bss.ftl_flush_jiffies,"aw",@nobits
	.align	2
	.set	.LANCHOR190,. + 0
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
	.set	.LANCHOR154,. + 0
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
	.set	.LANCHOR157,. + 0
	.type	ftl_power_lost_flag, %object
	.size	ftl_power_lost_flag, 1
ftl_power_lost_flag:
	.zero	1
	.section	.bss.ftl_sblk_lpa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR105,. + 0
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
	.set	.LANCHOR110,. + 0
	.type	ftl_sblk_vpn_update_id, %object
	.size	ftl_sblk_vpn_update_id, 2
ftl_sblk_vpn_update_id:
	.zero	2
	.section	.bss.ftl_tmp_buffer,"aw",@nobits
	.align	6
	.type	ftl_tmp_buffer, %object
	.size	ftl_tmp_buffer, 16384
ftl_tmp_buffer:
	.zero	16384
	.section	.bss.ftl_tmp_spare,"aw",@nobits
	.align	6
	.set	.LANCHOR145,. + 0
	.type	ftl_tmp_spare, %object
	.size	ftl_tmp_spare, 256
ftl_tmp_spare:
	.zero	256
	.section	.bss.ftl_vpn_update_count,"aw",@nobits
	.align	1
	.set	.LANCHOR109,. + 0
	.type	ftl_vpn_update_count, %object
	.size	ftl_vpn_update_count, 2
ftl_vpn_update_count:
	.zero	2
	.section	.bss.g_block_align_addr,"aw",@nobits
	.align	1
	.set	.LANCHOR20,. + 0
	.type	g_block_align_addr, %object
	.size	g_block_align_addr, 2
g_block_align_addr:
	.zero	2
	.section	.bss.g_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR43,. + 0
	.type	g_buf, %object
	.size	g_buf, 2048
g_buf:
	.zero	2048
	.section	.bss.g_die_addr,"aw",@nobits
	.align	2
	.set	.LANCHOR122,. + 0
	.type	g_die_addr, %object
	.size	g_die_addr, 32
g_die_addr:
	.zero	32
	.section	.bss.g_die_cs_idx,"aw",@nobits
	.align	2
	.set	.LANCHOR17,. + 0
	.type	g_die_cs_idx, %object
	.size	g_die_cs_idx, 8
g_die_cs_idx:
	.zero	8
	.section	.bss.g_flash_3d_mlc_flag,"aw",@nobits
	.set	.LANCHOR98,. + 0
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
	.set	.LANCHOR141,. + 0
	.type	g_flash_blk_info, %object
	.size	g_flash_blk_info, 4
g_flash_blk_info:
	.zero	4
	.section	.bss.g_flash_cur_mode,"aw",@nobits
	.set	.LANCHOR27,. + 0
	.type	g_flash_cur_mode, %object
	.size	g_flash_cur_mode, 1
g_flash_cur_mode:
	.zero	1
	.section	.bss.g_flash_interface_mode,"aw",@nobits
	.set	.LANCHOR32,. + 0
	.type	g_flash_interface_mode, %object
	.size	g_flash_interface_mode, 1
g_flash_interface_mode:
	.zero	1
	.section	.bss.g_flash_multi_page_prog_en,"aw",@nobits
	.set	.LANCHOR30,. + 0
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
	.set	.LANCHOR143,. + 0
	.type	g_flash_page_buffer, %object
	.size	g_flash_page_buffer, 8
g_flash_page_buffer:
	.zero	8
	.section	.bss.g_flash_reversd_blks,"aw",@nobits
	.set	.LANCHOR147,. + 0
	.type	g_flash_reversd_blks, %object
	.size	g_flash_reversd_blks, 1
g_flash_reversd_blks:
	.zero	1
	.section	.bss.g_flash_slc_mode,"aw",@nobits
	.set	.LANCHOR18,. + 0
	.type	g_flash_slc_mode, %object
	.size	g_flash_slc_mode, 1
g_flash_slc_mode:
	.zero	1
	.section	.bss.g_flash_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR142,. + 0
	.type	g_flash_spare_buffer, %object
	.size	g_flash_spare_buffer, 8
g_flash_spare_buffer:
	.zero	8
	.section	.bss.g_flash_sys_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR140,. + 0
	.type	g_flash_sys_spare_buffer, %object
	.size	g_flash_sys_spare_buffer, 8
g_flash_sys_spare_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR135,. + 0
	.type	g_flash_tmp_page_buffer, %object
	.size	g_flash_tmp_page_buffer, 8
g_flash_tmp_page_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR136,. + 0
	.type	g_flash_tmp_spare_buffer, %object
	.size	g_flash_tmp_spare_buffer, 8
g_flash_tmp_spare_buffer:
	.zero	8
	.section	.bss.g_flash_toggle_mode_en,"aw",@nobits
	.set	.LANCHOR42,. + 0
	.type	g_flash_toggle_mode_en, %object
	.size	g_flash_toggle_mode_en, 1
g_flash_toggle_mode_en:
	.zero	1
	.section	.bss.g_ftl_info_blk,"aw",@nobits
	.align	6
	.set	.LANCHOR155,. + 0
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
	.set	.LANCHOR169,. + 0
	.type	g_idb_ecc_bits, %object
	.size	g_idb_ecc_bits, 1
g_idb_ecc_bits:
	.zero	1
	.section	.bss.g_idb_slc_mode_enable,"aw",@nobits
	.set	.LANCHOR170,. + 0
	.type	g_idb_slc_mode_enable, %object
	.size	g_idb_slc_mode_enable, 1
g_idb_slc_mode_enable:
	.zero	1
	.section	.bss.g_lsb_page_tbl,"aw",@nobits
	.align	2
	.set	.LANCHOR21,. + 0
	.type	g_lsb_page_tbl, %object
	.size	g_lsb_page_tbl, 512
g_lsb_page_tbl:
	.zero	512
	.section	.bss.g_maxRegNum,"aw",@nobits
	.set	.LANCHOR11,. + 0
	.type	g_maxRegNum, %object
	.size	g_maxRegNum, 1
g_maxRegNum:
	.zero	1
	.section	.bss.g_maxRetryCount,"aw",@nobits
	.set	.LANCHOR137,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.zero	1
	.section	.bss.g_msb_page_tbl,"aw",@nobits
	.align	2
	.set	.LANCHOR120,. + 0
	.type	g_msb_page_tbl, %object
	.size	g_msb_page_tbl, 1024
g_msb_page_tbl:
	.zero	1024
	.section	.bss.g_nand_max_die,"aw",@nobits
	.set	.LANCHOR15,. + 0
	.type	g_nand_max_die, %object
	.size	g_nand_max_die, 1
g_nand_max_die:
	.zero	1
	.section	.bss.g_nand_opt_para,"aw",@nobits
	.align	3
	.set	.LANCHOR129,. + 0
	.type	g_nand_opt_para, %object
	.size	g_nand_opt_para, 32
g_nand_opt_para:
	.zero	32
	.section	.bss.g_nandc_ecc_bits,"aw",@nobits
	.set	.LANCHOR34,. + 0
	.type	g_nandc_ecc_bits, %object
	.size	g_nandc_ecc_bits, 1
g_nandc_ecc_bits:
	.zero	1
	.section	.bss.g_nandc_v6_master_info,"aw",@nobits
	.align	3
	.set	.LANCHOR37,. + 0
	.type	g_nandc_v6_master_info, %object
	.size	g_nandc_v6_master_info, 40
g_nandc_v6_master_info:
	.zero	40
	.section	.bss.g_nandc_ver,"aw",@nobits
	.set	.LANCHOR14,. + 0
	.type	g_nandc_ver, %object
	.size	g_nandc_ver, 1
g_nandc_ver:
	.zero	1
	.section	.bss.g_pm_spare,"aw",@nobits
	.align	3
	.set	.LANCHOR165,. + 0
	.type	g_pm_spare, %object
	.size	g_pm_spare, 8
g_pm_spare:
	.zero	8
	.section	.bss.g_retryMode,"aw",@nobits
	.set	.LANCHOR9,. + 0
	.type	g_retryMode, %object
	.size	g_retryMode, 1
g_retryMode:
	.zero	1
	.section	.bss.g_slc_mode_addr2,"aw",@nobits
	.set	.LANCHOR19,. + 0
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
	.set	.LANCHOR121,. + 0
	.type	g_slc_page_num, %object
	.size	g_slc_page_num, 2
g_slc_page_num:
	.zero	2
	.section	.bss.g_totle_phy_block,"aw",@nobits
	.align	1
	.set	.LANCHOR123,. + 0
	.type	g_totle_phy_block, %object
	.size	g_totle_phy_block, 2
g_totle_phy_block:
	.zero	2
	.section	.bss.gc_des_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR133,. + 0
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
	.set	.LANCHOR131,. + 0
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
	.set	.LANCHOR132,. + 0
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
	.set	.LANCHOR130,. + 0
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
	.section	.bss.gp_flash_info,"aw",@nobits
	.align	3
	.set	.LANCHOR12,. + 0
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
	.set	.LANCHOR53,. + 0
	.type	gp_ftl_info, %object
	.size	gp_ftl_info, 8
gp_ftl_info:
	.zero	8
	.section	.bss.gp_nand_para_info,"aw",@nobits
	.align	3
	.set	.LANCHOR41,. + 0
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
	.set	.LANCHOR0,. + 0
	.type	gp_sblk_list_tbl, %object
	.size	gp_sblk_list_tbl, 8
gp_sblk_list_tbl:
	.zero	8
	.section	.bss.lpa_hash,"aw",@nobits
	.align	3
	.set	.LANCHOR104,. + 0
	.type	lpa_hash, %object
	.size	lpa_hash, 512
lpa_hash:
	.zero	512
	.section	.bss.lpa_hash_index,"aw",@nobits
	.align	3
	.set	.LANCHOR106,. + 0
	.type	lpa_hash_index, %object
	.size	lpa_hash_index, 8
lpa_hash_index:
	.zero	8
	.section	.bss.nandc_hw_seed,"aw",@nobits
	.set	.LANCHOR35,. + 0
	.type	nandc_hw_seed, %object
	.size	nandc_hw_seed, 1
nandc_hw_seed:
	.zero	1
	.section	.bss.nandc_randomizer_en,"aw",@nobits
	.set	.LANCHOR36,. + 0
	.type	nandc_randomizer_en, %object
	.size	nandc_randomizer_en, 1
nandc_randomizer_en:
	.zero	1
	.section	.bss.p_free_buf_head,"aw",@nobits
	.set	.LANCHOR44,. + 0
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
	.section	.bss.pm_gc_enable,"aw",@nobits
	.align	2
	.set	.LANCHOR115,. + 0
	.type	pm_gc_enable, %object
	.size	pm_gc_enable, 4
pm_gc_enable:
	.zero	4
	.section	.bss.pm_last_load_ram_id,"aw",@nobits
	.set	.LANCHOR175,. + 0
	.type	pm_last_load_ram_id, %object
	.size	pm_last_load_ram_id, 1
pm_last_load_ram_id:
	.zero	1
	.section	.bss.pm_last_update_ram_id,"aw",@nobits
	.set	.LANCHOR118,. + 0
	.type	pm_last_update_ram_id, %object
	.size	pm_last_update_ram_id, 1
pm_last_update_ram_id:
	.zero	1
	.section	.bss.pm_ram_info,"aw",@nobits
	.align	3
	.set	.LANCHOR117,. + 0
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
	.set	.LANCHOR114,. + 0
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
	.set	.LANCHOR111,. + 0
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
	.set	.LANCHOR50,. + 0
	.type	write_buf_count, %object
	.size	write_buf_count, 1
write_buf_count:
	.zero	1
	.section	.bss.write_buf_head,"aw",@nobits
	.set	.LANCHOR49,. + 0
	.type	write_buf_head, %object
	.size	write_buf_head, 1
write_buf_head:
	.zero	1
	.section	.bss.write_commit_count,"aw",@nobits
	.set	.LANCHOR112,. + 0
	.type	write_commit_count, %object
	.size	write_commit_count, 1
write_commit_count:
	.zero	1
	.section	.bss.write_commit_head,"aw",@nobits
	.set	.LANCHOR151,. + 0
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
	.set	.LANCHOR26,. + 0
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
	.set	.LANCHOR134,. + 0
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
	.set	.LANCHOR167,. + 0
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
	.set	.LANCHOR25,. + 0
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
	.set	.LANCHOR24,. + 0
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
	.set	.LANCHOR192,. + 0
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
	.set	.LANCHOR29,. + 0
	.type	zftl_debug, %object
	.size	zftl_debug, 4
zftl_debug:
	.word	17476
	.section	.data.zftl_nand_flash_para_tbl,"aw",@progbits
	.align	3
	.set	.LANCHOR166,. + 0
	.type	zftl_nand_flash_para_tbl, %object
	.size	zftl_nand_flash_para_tbl, 800
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
	.hword	1497
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
	.hword	1497
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
	.byte	6
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
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.section	.rodata.__func__.10029,"a",@progbits
	.align	3
	.set	.LANCHOR1,. + 0
	.type	__func__.10029, %object
	.size	__func__.10029, 18
__func__.10029:
	.string	"_list_remove_node"
	.section	.rodata.__func__.10054,"a",@progbits
	.align	3
	.set	.LANCHOR6,. + 0
	.type	__func__.10054, %object
	.size	__func__.10054, 23
__func__.10054:
	.string	"_list_update_data_list"
	.section	.rodata.__func__.10153,"a",@progbits
	.align	3
	.set	.LANCHOR156,. + 0
	.type	__func__.10153, %object
	.size	__func__.10153, 15
__func__.10153:
	.string	"ftl_info_flush"
	.section	.rodata.__func__.10185,"a",@progbits
	.align	3
	.set	.LANCHOR113,. + 0
	.type	__func__.10185, %object
	.size	__func__.10185, 15
__func__.10185:
	.string	"ftl_alloc_sblk"
	.section	.rodata.__func__.10220,"a",@progbits
	.align	3
	.set	.LANCHOR101,. + 0
	.type	__func__.10220, %object
	.size	__func__.10220, 18
__func__.10220:
	.string	"ftl_alloc_sys_blk"
	.section	.rodata.__func__.10230,"a",@progbits
	.align	3
	.set	.LANCHOR102,. + 0
	.type	__func__.10230, %object
	.size	__func__.10230, 17
__func__.10230:
	.string	"ftl_free_sys_blk"
	.section	.rodata.__func__.10264,"a",@progbits
	.align	3
	.set	.LANCHOR184,. + 0
	.type	__func__.10264, %object
	.size	__func__.10264, 14
__func__.10264:
	.string	"ftl_sblk_dump"
	.section	.rodata.__func__.10288,"a",@progbits
	.align	3
	.set	.LANCHOR171,. + 0
	.type	__func__.10288, %object
	.size	__func__.10288, 16
__func__.10288:
	.string	"ftl_sysblk_dump"
	.section	.rodata.__func__.10307,"a",@progbits
	.align	3
	.set	.LANCHOR163,. + 0
	.type	__func__.10307, %object
	.size	__func__.10307, 23
__func__.10307:
	.string	"ftl_open_sblk_recovery"
	.section	.rodata.__func__.10333,"a",@progbits
	.align	3
	.set	.LANCHOR103,. + 0
	.type	__func__.10333, %object
	.size	__func__.10333, 23
__func__.10333:
	.string	"ftl_get_ppa_from_index"
	.section	.rodata.__func__.10354,"a",@progbits
	.align	3
	.set	.LANCHOR188,. + 0
	.type	__func__.10354, %object
	.size	__func__.10354, 19
__func__.10354:
	.string	"ftl_update_l2p_map"
	.section	.rodata.__func__.10373,"a",@progbits
	.align	3
	.set	.LANCHOR107,. + 0
	.type	__func__.10373, %object
	.size	__func__.10373, 22
__func__.10373:
	.string	"ftl_get_new_free_page"
	.section	.rodata.__func__.10384,"a",@progbits
	.align	3
	.set	.LANCHOR108,. + 0
	.type	__func__.10384, %object
	.size	__func__.10384, 22
__func__.10384:
	.string	"ftl_ext_alloc_new_blk"
	.section	.rodata.__func__.10409,"a",@progbits
	.align	3
	.set	.LANCHOR158,. + 0
	.type	__func__.10409, %object
	.size	__func__.10409, 19
__func__.10409:
	.string	"ftl_ext_info_flush"
	.section	.rodata.__func__.10421,"a",@progbits
	.align	3
	.set	.LANCHOR159,. + 0
	.type	__func__.10421, %object
	.size	__func__.10421, 18
__func__.10421:
	.string	"ftl_ext_info_init"
	.section	.rodata.__func__.10467,"a",@progbits
	.align	3
	.set	.LANCHOR160,. + 0
	.type	__func__.10467, %object
	.size	__func__.10467, 15
__func__.10467:
	.string	"ftl_low_format"
	.section	.rodata.__func__.10511,"a",@progbits
	.align	3
	.set	.LANCHOR162,. + 0
	.type	__func__.10511, %object
	.size	__func__.10511, 23
__func__.10511:
	.string	"ftl_re_low_format_test"
	.section	.rodata.__func__.10521,"a",@progbits
	.align	3
	.set	.LANCHOR153,. + 0
	.type	__func__.10521, %object
	.size	__func__.10521, 14
__func__.10521:
	.string	"ftl_prog_page"
	.section	.rodata.__func__.10696,"a",@progbits
	.align	3
	.set	.LANCHOR150,. + 0
	.type	__func__.10696, %object
	.size	__func__.10696, 15
__func__.10696:
	.string	"sblk_prog_page"
	.section	.rodata.__func__.10755,"a",@progbits
	.align	3
	.set	.LANCHOR172,. + 0
	.type	__func__.10755, %object
	.size	__func__.10755, 16
__func__.10755:
	.string	"load_l2p_region"
	.section	.rodata.__func__.10769,"a",@progbits
	.align	3
	.set	.LANCHOR128,. + 0
	.type	__func__.10769, %object
	.size	__func__.10769, 13
__func__.10769:
	.string	"pm_free_sblk"
	.section	.rodata.__func__.10789,"a",@progbits
	.align	3
	.set	.LANCHOR174,. + 0
	.type	__func__.10789, %object
	.size	__func__.10789, 6
__func__.10789:
	.string	"pm_gc"
	.section	.rodata.__func__.10805,"a",@progbits
	.align	3
	.set	.LANCHOR116,. + 0
	.type	__func__.10805, %object
	.size	__func__.10805, 17
__func__.10805:
	.string	"pm_alloc_new_blk"
	.section	.rodata.__func__.10815,"a",@progbits
	.align	3
	.set	.LANCHOR164,. + 0
	.type	__func__.10815, %object
	.size	__func__.10815, 14
__func__.10815:
	.string	"pm_write_page"
	.section	.rodata.__func__.10833,"a",@progbits
	.align	3
	.set	.LANCHOR119,. + 0
	.type	__func__.10833, %object
	.size	__func__.10833, 21
__func__.10833:
	.string	"pm_select_ram_region"
	.section	.rodata.__func__.8490,"a",@progbits
	.align	3
	.set	.LANCHOR138,. + 0
	.type	__func__.8490, %object
	.size	__func__.8490, 19
__func__.8490:
	.string	"flash_read_page_en"
	.section	.rodata.__func__.8519,"a",@progbits
	.align	3
	.set	.LANCHOR152,. + 0
	.type	__func__.8519, %object
	.size	__func__.8519, 19
__func__.8519:
	.string	"flash_prog_page_en"
	.section	.rodata.__func__.8534,"a",@progbits
	.align	3
	.set	.LANCHOR28,. + 0
	.type	__func__.8534, %object
	.size	__func__.8534, 26
__func__.8534:
	.string	"flash_erase_duplane_block"
	.section	.rodata.__func__.8545,"a",@progbits
	.align	3
	.set	.LANCHOR31,. + 0
	.type	__func__.8545, %object
	.size	__func__.8545, 21
__func__.8545:
	.string	"flash_erase_block_en"
	.section	.rodata.__func__.8559,"a",@progbits
	.align	3
	.set	.LANCHOR16,. + 0
	.type	__func__.8559, %object
	.size	__func__.8559, 28
__func__.8559:
	.string	"flash_wait_device_ready_raw"
	.section	.rodata.__func__.8584,"a",@progbits
	.align	3
	.set	.LANCHOR148,. + 0
	.type	__func__.8584, %object
	.size	__func__.8584, 26
__func__.8584:
	.string	"flash_start_tlc_page_prog"
	.section	.rodata.__func__.8597,"a",@progbits
	.align	3
	.set	.LANCHOR149,. + 0
	.type	__func__.8597, %object
	.size	__func__.8597, 22
__func__.8597:
	.string	"flash_start_page_prog"
	.section	.rodata.__func__.8610,"a",@progbits
	.align	3
	.set	.LANCHOR40,. + 0
	.type	__func__.8610, %object
	.size	__func__.8610, 22
__func__.8610:
	.string	"flash_start_page_read"
	.section	.rodata.__func__.8625,"a",@progbits
	.align	3
	.set	.LANCHOR144,. + 0
	.type	__func__.8625, %object
	.size	__func__.8625, 25
__func__.8625:
	.string	"flash_complete_page_read"
	.section	.rodata.__func__.9169,"a",@progbits
	.align	3
	.set	.LANCHOR46,. + 0
	.type	__func__.9169, %object
	.size	__func__.9169, 13
__func__.9169:
	.string	"buf_add_tail"
	.section	.rodata.__func__.9182,"a",@progbits
	.align	3
	.set	.LANCHOR47,. + 0
	.type	__func__.9182, %object
	.size	__func__.9182, 10
__func__.9182:
	.string	"buf_alloc"
	.section	.rodata.__func__.9196,"a",@progbits
	.align	3
	.set	.LANCHOR48,. + 0
	.type	__func__.9196, %object
	.size	__func__.9196, 16
__func__.9196:
	.string	"buf_remove_free"
	.section	.rodata.__func__.9312,"a",@progbits
	.align	3
	.set	.LANCHOR124,. + 0
	.type	__func__.9312, %object
	.size	__func__.9312, 17
__func__.9312:
	.string	"lpa_rebuild_hash"
	.section	.rodata.__func__.9364,"a",@progbits
	.align	3
	.set	.LANCHOR189,. + 0
	.type	__func__.9364, %object
	.size	__func__.9364, 17
__func__.9364:
	.string	"ftl_write_commit"
	.section	.rodata.__func__.9375,"a",@progbits
	.align	3
	.set	.LANCHOR51,. + 0
	.type	__func__.9375, %object
	.size	__func__.9375, 14
__func__.9375:
	.string	"ftl_write_buf"
	.section	.rodata.__func__.9426,"a",@progbits
	.align	3
	.set	.LANCHOR176,. + 0
	.type	__func__.9426, %object
	.size	__func__.9426, 15
__func__.9426:
	.string	"ftl_read_ahead"
	.section	.rodata.__func__.9434,"a",@progbits
	.align	3
	.set	.LANCHOR55,. + 0
	.type	__func__.9434, %object
	.size	__func__.9434, 13
__func__.9434:
	.string	"ftl_read_buf"
	.section	.rodata.__func__.9472,"a",@progbits
	.align	3
	.set	.LANCHOR185,. + 0
	.type	__func__.9472, %object
	.size	__func__.9472, 10
__func__.9472:
	.string	"zftl_read"
	.section	.rodata.__func__.9498,"a",@progbits
	.align	3
	.set	.LANCHOR195,. + 0
	.type	__func__.9498, %object
	.size	__func__.9498, 13
__func__.9498:
	.string	"_ftl_discard"
	.section	.rodata.__func__.9539,"a",@progbits
	.align	3
	.set	.LANCHOR186,. + 0
	.type	__func__.9539, %object
	.size	__func__.9539, 10
__func__.9539:
	.string	"vpn_check"
	.section	.rodata.__func__.9661,"a",@progbits
	.align	3
	.set	.LANCHOR61,. + 0
	.type	__func__.9661, %object
	.size	__func__.9661, 12
__func__.9661:
	.string	"gc_add_sblk"
	.section	.rodata.__func__.9679,"a",@progbits
	.align	3
	.set	.LANCHOR146,. + 0
	.type	__func__.9679, %object
	.size	__func__.9679, 21
__func__.9679:
	.string	"gc_check_data_one_wl"
	.section	.rodata.__func__.9713,"a",@progbits
	.align	3
	.set	.LANCHOR182,. + 0
	.type	__func__.9713, %object
	.size	__func__.9713, 22
__func__.9713:
	.string	"gc_update_l2p_map_new"
	.section	.rodata.__func__.9726,"a",@progbits
	.align	3
	.set	.LANCHOR66,. + 0
	.type	__func__.9726, %object
	.size	__func__.9726, 19
__func__.9726:
	.string	"gc_write_completed"
	.section	.rodata.__func__.9755,"a",@progbits
	.align	3
	.set	.LANCHOR191,. + 0
	.type	__func__.9755, %object
	.size	__func__.9755, 16
__func__.9755:
	.string	"gc_do_copy_back"
	.section	.rodata.__func__.9777,"a",@progbits
	.align	3
	.set	.LANCHOR97,. + 0
	.type	__func__.9777, %object
	.size	__func__.9777, 16
__func__.9777:
	.string	"gc_free_src_blk"
	.section	.rodata.__func__.9822,"a",@progbits
	.align	3
	.set	.LANCHOR187,. + 0
	.type	__func__.9822, %object
	.size	__func__.9822, 16
__func__.9822:
	.string	"gc_scan_src_blk"
	.section	.rodata.__func__.9881,"a",@progbits
	.align	3
	.set	.LANCHOR183,. + 0
	.type	__func__.9881, %object
	.size	__func__.9881, 20
__func__.9881:
	.string	"gc_scan_static_data"
	.section	.rodata.__func__.9942,"a",@progbits
	.align	3
	.set	.LANCHOR193,. + 0
	.type	__func__.9942, %object
	.size	__func__.9942, 11
__func__.9942:
	.string	"zftl_do_gc"
	.section	.rodata._list_remove_node.str1.1,"aMS",@progbits,1
.LC0:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
	.section	.rodata.dump_ftl_info.str1.1,"aMS",@progbits,1
.LC90:
	.string	"g_ftl_info_blk blk:0x%x, index:0x%x, page:0x%x\n"
.LC91:
	.string	"ftl_ext_info_blk blk:0x%x, page:0x%x\n"
.LC92:
	.string	"ac_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC93:
	.string	"tmp_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC94:
	.string	"gc_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC95:
	.string	"lpa:"
.LC96:
	.string	"vpn:"
.LC97:
	.string	"sblk:"
.LC98:
	.string	"lpa_hash:"
.LC99:
	.string	"lpa_hash_index:"
	.section	.rodata.dump_sblk_queue.str1.1,"aMS",@progbits,1
.LC29:
	.string	"dump_sblk_queue: %d\n"
.LC30:
	.string	"buf id= %d state = %d ppa = %x\n"
	.section	.rodata.flash_complete_page_read.str1.1,"aMS",@progbits,1
.LC63:
	.string	"flash_complete_page_read %x %x error_ecc %d %d\n"
	.section	.rodata.flash_ddr_tunning_read.str1.1,"aMS",@progbits,1
.LC57:
	.string	"%d flash_ddr_tunning_read %x ecc=%d\n"
.LC58:
	.string	"sync para %d\n"
.LC59:
	.string	"DDR mode Read error %x %x\n"
	.section	.rodata.flash_erase_all.str1.1,"aMS",@progbits,1
.LC5:
	.string	"erase done: %x\n"
	.section	.rodata.flash_erase_block_en.str1.1,"aMS",@progbits,1
.LC3:
	.string	"flash_erase_block %x %x\n"
.LC4:
	.string	"flash_erase_block block = %x status = %x\n"
	.section	.rodata.flash_erase_duplane_block.str1.1,"aMS",@progbits,1
.LC1:
	.string	"flash_erase_duplane_block %x %x %x\n"
.LC2:
	.string	"flash_erase_duplane_block pageadd = %x status = %x\n"
	.section	.rodata.flash_info_blk_init.str1.1,"aMS",@progbits,1
.LC62:
	.string	"no sys info %x\n"
	.section	.rodata.flash_info_flush.str1.1,"aMS",@progbits,1
.LC86:
	.string	"finfo:"
.LC87:
	.string	"flash_info_flush id = %x, page = %x\n"
.LC88:
	.string	"sys_info_flush error:%x\n"
	.section	.rodata.flash_mask_bad_block.str1.1,"aMS",@progbits,1
.LC7:
	.string	"flash_mask_bad_block %d %d\n"
	.section	.rodata.flash_prog_page.str1.1,"aMS",@progbits,1
.LC66:
	.string	"flash_prog_page %x %x %x\n"
	.section	.rodata.flash_prog_page_en.str1.1,"aMS",@progbits,1
.LC68:
	.string	"flash_prog_page_en:%x %x\n"
.LC69:
	.string	"spare"
.LC70:
	.string	"data"
.LC71:
	.string	"write error: %x\n"
	.section	.rodata.flash_read_id.str1.1,"aMS",@progbits,1
.LC6:
	.string	"No.%d FLASH ID:%x %x %x %x %x %x\n"
	.section	.rodata.flash_read_page.str1.1,"aMS",@progbits,1
.LC51:
	.string	"flash_read_page %x %x %x\n"
	.section	.rodata.flash_read_page_en.str1.1,"aMS",@progbits,1
.LC60:
	.string	"flash_read_page_en %x %x\n"
.LC61:
	.string	"flash_read_page_en %x %x error_ecc %d %d\n"
	.section	.rodata.ftl_alloc_sblk.str1.1,"aMS",@progbits,1
.LC28:
	.string	"alloc sblk %x %d\n"
	.section	.rodata.ftl_info_blk_init.str1.1,"aMS",@progbits,1
.LC74:
	.string	"%d %x @%d %x\n"
.LC75:
	.string	"ftl_info_blk_init %d %d %x\n"
	.section	.rodata.ftl_info_flush.str1.1,"aMS",@progbits,1
.LC73:
	.string	"g_ftl_info_blk blk = %x, page = %x version = %d\n"
	.section	.rodata.ftl_low_format.str1.1,"aMS",@progbits,1
.LC76:
	.string	"low format %d %d %d %d\n"
	.section	.rodata.ftl_mask_bad_block.str1.1,"aMS",@progbits,1
.LC22:
	.string	"mask bad block:cs %x block: %x\n"
	.section	.rodata.ftl_open_sblk_recovery.str1.1,"aMS",@progbits,1
.LC78:
	.string	"saved_active_page  = %x\n"
.LC79:
	.string	"saved_active_plane = %x\n"
.LC80:
	.string	"sblk = %x\n"
.LC81:
	.string	"phy_blk = %x %x\n"
.LC82:
	.string	"blk= %x, page=%x, ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC83:
	.string	"sblk = %x, vpn0 = %d, vpn1 = %d\n"
.LC84:
	.string	"dump write = %x\n"
	.section	.rodata.ftl_re_low_format_test.str1.1,"aMS",@progbits,1
.LC77:
	.string	"re low format %d\n"
	.section	.rodata.ftl_read_ahead.str1.1,"aMS",@progbits,1
.LC109:
	.string	"ftl_read_ahead refresh =%x, lpa = %x, ppa= %x\n"
.LC110:
	.string	"id=%d, lpa = %x, ppa = %x spare = %x %x %x %x\n"
	.section	.rodata.ftl_sblk_dump.str1.1,"aMS",@progbits,1
.LC122:
	.string	"ftl_sblk_dump = %x %x %x %x\n"
.LC123:
	.string	"page_addr = %x, lpa=%x vpn = %d\n"
.LC124:
	.string	"index= %x, lpa=%x\n"
.LC125:
	.string	"block = %x, vpn=%x check vpn = %d\n"
	.section	.rodata.ftl_scan_all_data.str1.1,"aMS",@progbits,1
.LC138:
	.string	"ftl_scan_all_data = %x\n"
.LC139:
	.string	"scan lpa = %x ppa= %x\n"
.LC140:
	.string	"lba = %x,addr= %x, ststus = %x, spare= %x %x %x %x data=%x %x\n"
.LC141:
	.string	"lba = %x, id= %x, index = %x hash ppa = %x\n"
.LC142:
	.string	"0pm:"
.LC143:
	.string	"1pm:"
	.section	.rodata.ftl_sysblk_dump.str1.1,"aMS",@progbits,1
.LC89:
	.string	"l2p:"
	.section	.rodata.ftl_test_block.str1.1,"aMS",@progbits,1
.LC72:
	.string	"low format %d\n"
	.section	.rodata.ftl_update_l2p_map.str1.1,"aMS",@progbits,1
.LC144:
	.string	"ftl_update_l2p_map: %x %x %x\n"
.LC145:
	.string	"ftl_update_l2p_map"
.LC146:
	.string	"lpa_tbl:"
.LC147:
	.string	"sblk %x vpn: %d %d\n"
	.section	.rodata.ftl_vpn_decrement.str1.1,"aMS",@progbits,1
.LC20:
	.string	"ftl_vpn_decrement %x = %d\n"
	.section	.rodata.ftl_write_commit.str1.1,"aMS",@progbits,1
.LC148:
	.string	"%d read error: ppa:%x, lpa:%x, status:%x\n"
	.section	.rodata.ftl_write_completed.str1.1,"aMS",@progbits,1
.LC21:
	.string	"ftl prog error =%x, lpa = %x, ppa= %x\n"
	.section	.rodata.gc_add_sblk.str1.1,"aMS",@progbits,1
.LC8:
	.string	"gc_add_sblk = %d, %d, %d, %d, %d, %d\n"
	.section	.rodata.gc_check_data_one_wl.str1.1,"aMS",@progbits,1
.LC65:
	.string	"1ppa = %x, status = %x, %x %x spare: %x %x %x %x\n"
	.section	.rodata.gc_do_copy_back.str1.1,"aMS",@progbits,1
.LC149:
	.string	"gc page in buf: lpa %x ppa = %x pageindex= %x\n"
.LC150:
	.string	"gc_do_copy_back: lpa %x des_ppa = %x %x gc_ppa= %x page_index= %d\n"
.LC151:
	.string	"gc_do_copy_back: %x %x %x %x gc_ppa:%x %x\n"
.LC152:
	.string	"%d prog_step: %x %x buf id= %x ppa = %x hash=%x id = %x plane = %x lpa=%x\n"
	.section	.rodata.gc_free_src_blk.str1.1,"aMS",@progbits,1
.LC18:
	.string	"gc_free_src_blk = %x, vpn = %d\n"
.LC19:
	.string	"gc_free_src_blk %x, %d\n"
	.section	.rodata.gc_free_temp_buf.str1.1,"aMS",@progbits,1
.LC11:
	.string	"%d gc_free_temp_buf buf id= %x\n"
	.section	.rodata.gc_recovery.str1.1,"aMS",@progbits,1
.LC111:
	.string	"ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC112:
	.string	"ppa = %x, status = %x, %x %x spare: %x %x %x %x\n"
.LC113:
	.string	"gc_recovery"
.LC114:
	.string	"gc_recovery: %x vpn = %x\n"
	.section	.rodata.gc_scan_src_blk.str1.1,"aMS",@progbits,1
.LC136:
	.string	"gc_scan_src_blk = %x, vpn = %d\n"
.LC137:
	.string	"gc_scan_src_blk = %x, s vpn0 = %d, c vpn1 = %d\n"
	.section	.rodata.gc_search_src_blk.str1.1,"aMS",@progbits,1
.LC13:
	.string	"zftl_get_gc_node cache = %x index = %d vpn = %x\n"
.LC14:
	.string	"gc_search_src_blk mode = %x, src mode = %x, count= %d %d\n"
	.section	.rodata.gc_static_wearleveling.str1.1,"aMS",@progbits,1
.LC34:
	.string	"gc_static_wearleveling: slc blk: %d, tlc blk: %d avg slc ec: %d, avg tlc ec: %d \n"
.LC35:
	.string	"gc_static_wearleveling: min slc ec: %d, min tlc ec: %d max slc ec: %d, max tlc ec: %d; %d %d\n"
.LC36:
	.string	"swl add tlc gc = %d, %d, %d, %d, %d, %d\n"
.LC37:
	.string	"swl add slc gc  = %d, %d, %d, %d, %d, %d\n"
	.section	.rodata.gc_update_l2p_map_new.str1.1,"aMS",@progbits,1
.LC117:
	.string	"gc_update_l2p_map_new sblk %x\n"
.LC118:
	.string	"gc_update_l2p_map_new: %x %x %x\n"
.LC119:
	.string	"0lpa: %x %x %x\n"
.LC120:
	.string	"lpa: %x %x %x\n"
.LC121:
	.string	"gc_update_l2p_map_new: %x vpn = %x vpn1 = %x done\n"
	.section	.rodata.gc_write_completed.str1.1,"aMS",@progbits,1
.LC9:
	.string	"status: %x, ppa: %x\n"
.LC10:
	.string	"gc_write_completed: %x  %x  %x %x\n"
	.section	.rodata.hynix_get_read_retry_default.str1.1,"aMS",@progbits,1
.LC43:
	.string	"otp error! %d"
.LC44:
	.string	"rr"
	.section	.rodata.hynix_read_retrial.str1.1,"aMS",@progbits,1
.LC56:
	.string	"hynix RR %d row=%x, count %d, status=%d\n"
	.section	.rodata.load_l2p_region.str1.1,"aMS",@progbits,1
.LC101:
	.string	"region_id = %d, pm_max_region = %d\n"
.LC102:
	.string	"load_l2p_region = %x,%x,%x, %x\n"
.LC103:
	.string	"pm_ppa:"
.LC104:
	.string	"data:"
.LC105:
	.string	"spare:"
	.section	.rodata.lpa_rebuild_hash.str1.1,"aMS",@progbits,1
.LC33:
	.string	"%s %d %d\n"
	.section	.rodata.micron_read_retrial.str1.1,"aMS",@progbits,1
.LC52:
	.string	"micron RR %d row=%x,count %d,status=%d\n"
	.section	.rodata.nandc_xfer.str1.1,"aMS",@progbits,1
.LC49:
	.string	"dqs data abort %x\n"
.LC50:
	.string	"xfer error %x\n"
	.section	.rodata.nandc_xfer_done.str1.1,"aMS",@progbits,1
.LC45:
	.string	"%d mtrans_cnt = %d page_num = %d\n"
.LC46:
	.string	"nandc:"
.LC47:
	.string	"%d flReg.d32=%x %x\n"
.LC48:
	.string	"nandc_xfer_done read error %x\n"
	.section	.rodata.pm_alloc_new_blk.str1.1,"aMS",@progbits,1
.LC31:
	.string	"blk %x is bad block\n"
.LC32:
	.string	"pm_alloc_new_blk: %x %x %x %x\n"
	.section	.rodata.pm_init.str1.1,"aMS",@progbits,1
.LC106:
	.string	"pm_init posr %x %x %x\n"
.LC107:
	.string	"pm_init recovery %x %x %x\n"
	.section	.rodata.pm_log2phys.str1.1,"aMS",@progbits,1
.LC108:
	.string	"pm_log2phys  lpn = %d, max lpn = %d\n"
	.section	.rodata.pm_ppa_update_check.str1.1,"aMS",@progbits,1
.LC100:
	.string	"%s w error lpn = %x, max ppa = %d\n"
	.section	.rodata.pm_write_page.str1.1,"aMS",@progbits,1
.LC85:
	.string	"pm_write_page write error: %x\n"
	.section	.rodata.print_ftl_debug_info.str1.1,"aMS",@progbits,1
.LC23:
	.string	"free blk: s:%x,t:%x,m:%x, data blk:s:%x,%x,t%x vpn: s:%x t:%x, max_vpn: %x\n"
.LC24:
	.string	"totle w: %d MB,r: %d MB %d dv:0x%X,poc:%d\n"
.LC25:
	.string	"gc xlc page: %d,gc slc page: %d, tmp w: %d MB\n"
.LC26:
	.string	"slc ec: %d,%d,%d,%d,%d,tlc ec: %d,%d,%d,%d,%d\n"
.LC27:
	.string	"gc th: tlc_tlc: %d tlc_slc: %d slc_slc: %d slc_tlc:%d free_th: %d\n"
	.section	.rodata.print_gc_debug_info.str1.1,"aMS",@progbits,1
.LC12:
	.string	"gc: b:%x,p:%x,i:%x; free buf=%d %d free slc th: %d\n"
	.section	.rodata.print_list_info.str1.1,"aMS",@progbits,1
.LC16:
	.string	"list count:%p %d\n"
.LC17:
	.string	"%d: node:%x %x %x %x, %d %d %d %d %d\n"
	.section	.rodata.queue_wait_first_req_completed.str1.1,"aMS",@progbits,1
.LC64:
	.string	"set buf %d,status = %x, ppa = %x lun state = %d\n"
	.section	.rodata.random_seed,"a",@progbits
	.align	3
	.set	.LANCHOR39,. + 0
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
.LC116:
	.string	"zftl_init %x\n"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",@progbits,1
.LC39:
	.string	"%s 0x%x:"
.LC40:
	.string	"%x "
.LC41:
	.string	""
.LC42:
	.string	"%s\n"
	.section	.rodata.sblk_prog_page.str1.1,"aMS",@progbits,1
.LC67:
	.string	"sblk_prog_page ppa = %x, count = %d\n"
	.section	.rodata.toshiba_15ref_value,"a",@progbits
	.align	3
	.set	.LANCHOR7,. + 0
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
	.set	.LANCHOR23,. + 0
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
	.set	.LANCHOR22,. + 0
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
.LC53:
	.string	"toshiba SRR %d row=%x, status=%d\n"
.LC54:
	.string	"toshiba TRR %d row=%x, status=%d\n"
.LC55:
	.string	"toshiba RR %d row=%x,count %d,status=%d\n"
	.section	.rodata.toshiba_A19ref_value,"a",@progbits
	.align	3
	.set	.LANCHOR8,. + 0
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
	.set	.LANCHOR10,. + 0
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
.LC128:
	.string	"acblk = %x, tempblk = %x, gc_des = %x\n"
.LC129:
	.string	"acblk = %x, free page = %x, vpn = %x %x\n"
.LC130:
	.string	"tmp_blk = %x, free page = %x, vpn = %x %x\n"
.LC131:
	.string	"vpn_check lpa = %x, ppa = %x, blk = %x\n"
.LC132:
	.string	"l2p"
.LC133:
	.string	"vpn_check %x = c %x  s %x function: %x\n"
.LC134:
	.string	"vpn_check blk = %x fix vpc\n"
.LC135:
	.string	"...%s exit...%d\n"
	.section	.rodata.zftl_discard.str1.1,"aMS",@progbits,1
.LC158:
	.string	"ftl_discard:(%x, %x, %x, %x)\n"
	.section	.rodata.zftl_do_gc.str1.1,"aMS",@progbits,1
.LC153:
	.string	"gc %d: %d %d %d %d %d %d %d\n"
.LC154:
	.string	"gc %d: %d %d %d %d %d %d\n"
.LC155:
	.string	"GC_STATE_SCAN_ALL_PAGE = %x, vpn0 = %d, vpn1 = %d\n"
.LC156:
	.string	"gc free %x, %d\n"
	.section	.rodata.zftl_get_free_sblk.str1.1,"aMS",@progbits,1
.LC15:
	.string	"zftl_get_free_sblk %x %d, %p %d %d\n"
	.section	.rodata.zftl_init.str1.1,"aMS",@progbits,1
.LC115:
	.string	"FTL version: 6.0.5 20180315"
	.section	.rodata.zftl_read.str1.1,"aMS",@progbits,1
.LC126:
	.string	"ftl_read %x %x %x\n"
.LC127:
	.string	"ftl_read refresh =%x, lpa = %x, ppa= %x\n"
	.section	.rodata.zftl_sblk_list_init.str1.1,"aMS",@progbits,1
.LC38:
	.string	"free blk vpn error: %x %x\n"
	.section	.rodata.zftl_write.str1.1,"aMS",@progbits,1
.LC157:
	.string	"ftlwrite %x %x %x\n"
	.hidden	free
