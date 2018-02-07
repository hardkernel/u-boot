/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2018-02-11
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
	.section	.text.nand_flash_print_info,"ax",@progbits
	.align	2
	.global	nand_flash_print_info
	.type	nand_flash_print_info, %function
nand_flash_print_info:
	ret
	.size	nand_flash_print_info, .-nand_flash_print_info
	.section	.text.FlashTimingCfg,"ax",@progbits
	.align	2
	.global	FlashTimingCfg
	.type	FlashTimingCfg, %function
FlashTimingCfg:
	ret
	.size	FlashTimingCfg, .-FlashTimingCfg
	.section	.text.timer_delay_ns,"ax",@progbits
	.align	2
	.global	timer_delay_ns
	.type	timer_delay_ns, %function
timer_delay_ns:
	sub	sp, sp, #16
	lsr	w0, w0, 4
	str	w0, [sp, 12]
.L9:
	ldr	w0, [sp, 12]
	sub	w1, w0, #1
	str	w1, [sp, 12]
	cbnz	w0, .L9
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
	adrp	x6, .LANCHOR4
	add	x6, x6, :lo12:.LANCHOR4
	adrp	x3, .LANCHOR0
	add	x3, x3, :lo12:.LANCHOR0
	umull	x2, w2, w0
	adrp	x0, .LANCHOR1
	add	x7, x0, :lo12:.LANCHOR1
	mov	x5, x0
	ldrb	w0, [x6]
	add	x3, x3, x2
	add	x7, x7, x2
	adrp	x8, .LANCHOR2
	mov	x2, 0
	adrp	x10, .LANCHOR3
	add	x8, x8, :lo12:.LANCHOR2
	add	x10, x10, :lo12:.LANCHOR3
	cmp	w0, w2
	bhi	.L22
	ret
.L16:
	cmp	w0, 35
	bne	.L18
	ldrsb	w0, [x3, x2]
	b	.L23
.L18:
	ldrsb	w0, [x10, w11, sxtw]
	b	.L23
.L22:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L19:
	mov	w0, 85
	str	w0, [x4, 8]
	add	x0, x5, :lo12:.LANCHOR1
	ldrsb	w0, [x2, x0]
	str	w0, [x4, 4]
	mov	w0, 200
	bl	timer_delay_ns
	ldrb	w0, [x8]
	cmp	w0, 34
	bne	.L16
	ldrsb	w0, [x7, x2]
.L23:
	str	w0, [x4]
	add	x2, x2, 1
	ldrb	w0, [x6]
	cmp	w0, w2
	bhi	.L19
	ldp	x29, x30, [sp], 16
	ret
	.size	toshiba_set_rr_para, .-toshiba_set_rr_para
	.section	.text.hynix_set_rr_para,"ax",@progbits
	.align	2
	.type	hynix_set_rr_para, %function
hynix_set_rr_para:
	adrp	x2, .LANCHOR5
	and	w1, w1, 255
	mov	x3, 32
	and	w0, w0, 255
	ldr	x2, [x2, #:lo12:.LANCHOR5]
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
	adrp	x1, .LANCHOR6
	ldr	x3, [x1, #:lo12:.LANCHOR6]
	add	x3, x3, x0
	mov	w0, 54
	str	w0, [x3, 2056]
	bhi	.L30
	mov	w0, 22
	str	w0, [x3, 2056]
	ret
.L30:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L26:
	ldrb	w0, [x6, x4]
	str	w0, [x3, 2052]
	mov	w0, 120
	bl	timer_delay_ns
	ldrsb	w0, [x2, x4]
	str	w0, [x3, 2048]
	add	x4, x4, 1
	cmp	w5, w4, uxtb
	bhi	.L26
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
	adrp	x1, .LANCHOR2
	ldrb	w1, [x1, #:lo12:.LANCHOR2]
	sub	w1, w1, #1
	and	w1, w1, 255
	cmp	w1, 6
	bhi	.L37
	adrp	x8, .LANCHOR5
	and	w0, w0, 255
	sxtw	x7, w0
	ldr	x1, [x8, #:lo12:.LANCHOR5]
	add	x1, x1, x7
	ldrb	w1, [x1, 120]
	cbz	w1, .L37
	stp	x29, x30, [sp, -16]!
	mov	w1, 0
	add	x29, sp, 0
	bl	hynix_set_rr_para
	ldr	x0, [x8, #:lo12:.LANCHOR5]
	add	x0, x0, x7
	strb	wzr, [x0, 120]
	ldp	x29, x30, [sp], 16
	ret
.L37:
	ret
	.size	hynix_reconfig_rr_para, .-hynix_reconfig_rr_para
	.section	.text.nandc_set_ddr_para,"ax",@progbits
	.align	2
	.global	nandc_set_ddr_para
	.type	nandc_set_ddr_para, %function
nandc_set_ddr_para:
	adrp	x1, .LANCHOR7
	and	w0, w0, 255
	adrp	x2, .LANCHOR6
	ldrb	w1, [x1, #:lo12:.LANCHOR7]
	ldr	x2, [x2, #:lo12:.LANCHOR6]
	cmp	w1, 9
	lsl	w1, w0, 16
	lsl	w0, w0, 8
	orr	w1, w1, w0
	orr	w1, w1, 3
	bne	.L41
	str	w1, [x2, 80]
	ret
.L41:
	str	w1, [x2, 304]
	ret
	.size	nandc_set_ddr_para, .-nandc_set_ddr_para
	.section	.text.nandc_get_ddr_para,"ax",@progbits
	.align	2
	.global	nandc_get_ddr_para
	.type	nandc_get_ddr_para, %function
nandc_get_ddr_para:
	adrp	x0, .LANCHOR7
	ldrb	w0, [x0, #:lo12:.LANCHOR7]
	cmp	w0, 9
	adrp	x0, .LANCHOR6
	ldr	x0, [x0, #:lo12:.LANCHOR6]
	bne	.L44
	ldr	w0, [x0, 80]
.L46:
	ubfx	x0, x0, 8, 8
	ret
.L44:
	ldr	w0, [x0, 304]
	b	.L46
	.size	nandc_get_ddr_para, .-nandc_get_ddr_para
	.section	.text.nandc_set_if_mode,"ax",@progbits
	.align	2
	.global	nandc_set_if_mode
	.type	nandc_set_if_mode, %function
nandc_set_if_mode:
	adrp	x1, .LANCHOR6
	and	w0, w0, 255
	tst	w0, 6
	ldr	x2, [x1, #:lo12:.LANCHOR6]
	ldr	w1, [x2]
	beq	.L48
	tst	x0, 4
	orr	w1, w1, 24576
	adrp	x0, .LANCHOR7
	and	w1, w1, -32769
	orr	w1, w1, 196608
	ldrb	w0, [x0, #:lo12:.LANCHOR7]
	orr	w3, w1, 32768
	csel	w1, w3, w1, ne
	cmp	w0, 9
	mov	w0, 4099
	movk	w0, 0x10, lsl 16
	bne	.L50
	mov	w3, 8321
	str	w3, [x2, 8]
	str	w0, [x2, 80]
	mov	w0, 38
	str	w0, [x2, 84]
	mov	w0, 39
	str	w0, [x2, 84]
.L51:
	str	w1, [x2]
	ret
.L50:
	mov	w3, 8322
	str	w3, [x2, 344]
	str	w0, [x2, 304]
	mov	w0, 38
	str	w0, [x2, 308]
	mov	w0, 39
	str	w0, [x2, 308]
	b	.L51
.L48:
	and	w1, w1, -8193
	b	.L51
	.size	nandc_set_if_mode, .-nandc_set_if_mode
	.section	.text.nandc_cs,"ax",@progbits
	.align	2
	.global	nandc_cs
	.type	nandc_cs, %function
nandc_cs:
	adrp	x1, .LANCHOR6
	mov	w2, 1
	lsl	w0, w2, w0
	ldr	x3, [x1, #:lo12:.LANCHOR6]
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
	adrp	x0, .LANCHOR6
	ldr	x1, [x0, #:lo12:.LANCHOR6]
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
	adrp	x1, .LANCHOR8
	and	w0, w0, 255
	add	x29, sp, 0
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	cmp	w1, w0
	bhi	.L57
	adrp	x1, .LANCHOR9
	adrp	x0, .LC0
	mov	w2, 604
	add	x1, x1, :lo12:.LANCHOR9
	add	x0, x0, :lo12:.LC0
	bl	printf
.L58:
	b	.L58
.L57:
	adrp	x1, .LANCHOR10
	add	x1, x1, :lo12:.LANCHOR10
	mov	w7, w2
	ldrb	w6, [x1, w0, sxtw]
	adrp	x0, .LANCHOR6
	ldr	x4, [x0, #:lo12:.LANCHOR6]
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
.L65:
	bl	timer_delay_ns
	ldr	w2, [x3, 2048]
	and	w2, w2, 255
	bics	wzr, w7, w2
	bne	.L60
	cmp	w2, 255
	beq	.L60
	mov	w0, w6
	bl	nandc_de_cs
	ldp	x29, x30, [sp], 16
	mov	w0, w2
	ret
.L60:
	mov	w0, 20
	b	.L65
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
	bne	.L67
	adrp	x0, .LANCHOR11
	adrp	x5, .LANCHOR12
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	cbz	w0, .L68
	ldrb	w0, [x5, #:lo12:.LANCHOR12]
	cbz	w0, .L67
.L68:
	adrp	x0, .LANCHOR13
	ldrh	w3, [x0, #:lo12:.LANCHOR13]
	ldrb	w0, [x5, #:lo12:.LANCHOR12]
	udiv	w4, w1, w3
	mul	w4, w4, w3
	sub	w3, w1, w4
	cbz	w0, .L69
	add	w1, w4, w3, lsl 1
.L67:
	mov	w0, w6
	b	flash_wait_device_ready_raw
.L69:
	adrp	x5, .LANCHOR14
	add	x5, x5, :lo12:.LANCHOR14
	ldrh	w3, [x5, w3, uxtw 1]
	add	w1, w3, w4
	b	.L67
	.size	flash_wait_device_ready, .-flash_wait_device_ready
	.section	.text.nandc_wait_flash_ready,"ax",@progbits
	.align	2
	.global	nandc_wait_flash_ready
	.type	nandc_wait_flash_ready, %function
nandc_wait_flash_ready:
	mov	w2, 34464
	stp	x29, x30, [sp, -32]!
	movk	w2, 0x1, lsl 16
	adrp	x3, .LANCHOR6
	add	x29, sp, 0
.L78:
	mov	w0, 100
	bl	timer_delay_ns
	ldr	x0, [x3, #:lo12:.LANCHOR6]
	ldr	w0, [x0]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbnz	x0, 9, .L79
	subs	w2, w2, #1
	bne	.L78
	mov	w0, -1
.L76:
	ldp	x29, x30, [sp], 32
	ret
.L79:
	mov	w0, 0
	b	.L76
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
	adrp	x0, .LANCHOR4
	adrp	x2, .LANCHOR0
	add	x2, x2, :lo12:.LANCHOR0
	ldrb	w4, [x0, #:lo12:.LANCHOR4]
	adrp	x0, .LANCHOR2
	ldrb	w5, [x0, #:lo12:.LANCHOR2]
	mov	w0, 5
	umull	x1, w1, w0
	adrp	x0, .LANCHOR1
	add	x0, x0, :lo12:.LANCHOR1
	add	x2, x2, x1
	add	x1, x0, x1
	mov	x0, 0
.L83:
	cmp	w4, w0
	bhi	.L86
	ldp	x29, x30, [sp], 16
	b	nandc_wait_flash_ready
.L86:
	cmp	w5, 67
	bne	.L84
	ldrsb	w6, [x1, x0]
.L88:
	add	x0, x0, 1
	str	w6, [x3]
	b	.L83
.L84:
	ldrsb	w6, [x2, x0]
	b	.L88
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
	adrp	x0, .LANCHOR15
	add	x0, x0, :lo12:.LANCHOR15
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
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
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
	cbz	w2, .L93
	stp	x29, x30, [sp, -16]!
	mov	x4, x0
	mov	x2, 7
	mov	w0, 18
	add	x29, sp, 0
	str	w6, [x4, 8]
	mul	x1, x1, x2
	str	w0, [x4, 4]
	adrp	x0, .LANCHOR17
	add	x0, x0, :lo12:.LANCHOR17
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
.L96:
	b	nandc_wait_flash_ready
.L93:
	str	w6, [x0, 8]
	mov	w2, 20
	str	w2, [x0, 4]
	adrp	x2, .LANCHOR18
	add	x2, x2, :lo12:.LANCHOR18
	ldrb	w1, [x2, x1]
	str	w1, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	str	wzr, [x0]
	b	.L96
	.size	toshiba_tlc_set_rr_para, .-toshiba_tlc_set_rr_para
	.section	.text.flash_enter_slc_mode,"ax",@progbits
	.align	2
	.global	flash_enter_slc_mode
	.type	flash_enter_slc_mode, %function
flash_enter_slc_mode:
	adrp	x1, .LANCHOR11
	and	x0, x0, 255
	ldrb	w2, [x1, #:lo12:.LANCHOR11]
	cbz	w2, .L99
	adrp	x1, .LANCHOR6
	cmp	w2, 1
	ldr	x1, [x1, #:lo12:.LANCHOR6]
	bne	.L101
	adrp	x2, .LANCHOR19+29
	ldrb	w2, [x2, #:lo12:.LANCHOR19+29]
	cbz	w2, .L99
	add	x0, x0, 8
	add	x0, x1, x0, lsl 8
	str	w2, [x0, 8]
	ret
.L101:
	cmp	w2, 2
	bne	.L99
	adrp	x2, .LANCHOR20
	ldrb	w3, [x2, #:lo12:.LANCHOR20]
	cbz	w3, .L99
	ubfiz	x0, x0, 8, 8
	strb	wzr, [x2, #:lo12:.LANCHOR20]
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
.L99:
	ret
	.size	flash_enter_slc_mode, .-flash_enter_slc_mode
	.section	.text.flash_exit_slc_mode,"ax",@progbits
	.align	2
	.global	flash_exit_slc_mode
	.type	flash_exit_slc_mode, %function
flash_exit_slc_mode:
	adrp	x1, .LANCHOR11
	and	x0, x0, 255
	ldrb	w2, [x1, #:lo12:.LANCHOR11]
	cbz	w2, .L111
	adrp	x1, .LANCHOR6
	cmp	w2, 1
	ldr	x1, [x1, #:lo12:.LANCHOR6]
	bne	.L113
	adrp	x2, .LANCHOR19+30
	ldrb	w2, [x2, #:lo12:.LANCHOR19+30]
	cbz	w2, .L111
	add	x0, x0, 8
	add	x0, x1, x0, lsl 8
	str	w2, [x0, 8]
	ret
.L113:
	cmp	w2, 2
	bne	.L111
	adrp	x3, .LANCHOR20
	ldrb	w2, [x3, #:lo12:.LANCHOR20]
	cbnz	w2, .L111
	ubfiz	x0, x0, 8, 8
	adrp	x2, .LANCHOR19+12
	add	x0, x1, x0
	mov	w1, 239
	ldrb	w2, [x2, #:lo12:.LANCHOR19+12]
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
	strb	w2, [x3, #:lo12:.LANCHOR20]
	b	nandc_wait_flash_ready
.L111:
	ret
	.size	flash_exit_slc_mode, .-flash_exit_slc_mode
	.section	.text.flash_erase_duplane_block,"ax",@progbits
	.align	2
	.global	flash_erase_duplane_block
	.type	flash_erase_duplane_block, %function
flash_erase_duplane_block:
	stp	x29, x30, [sp, -80]!
	and	w0, w0, 255
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w24, w1, 255
	adrp	x1, .LANCHOR8
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	str	x25, [sp, 64]
	cmp	w1, w0
	bhi	.L124
	adrp	x1, .LANCHOR21
	adrp	x0, .LC0
	mov	w2, 517
	add	x1, x1, :lo12:.LANCHOR21
	add	x0, x0, :lo12:.LC0
	bl	printf
.L125:
	b	.L125
.L124:
	adrp	x1, .LANCHOR10
	add	x1, x1, :lo12:.LANCHOR10
	mov	w22, w2
	mov	w21, w3
	ldrb	w20, [x1, w0, sxtw]
	adrp	x0, .LANCHOR6
	ldr	x25, [x0, #:lo12:.LANCHOR6]
	adrp	x0, .LANCHOR22
	and	x19, x20, 255
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	add	x23, x19, 8
	add	x23, x25, x23, lsl 8
	tbz	x0, 4, .L126
	adrp	x0, .LC1
	mov	w1, w20
	add	x0, x0, :lo12:.LC1
	bl	printf
.L126:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w24, .L127
	bl	flash_enter_slc_mode
.L128:
	add	x25, x25, x19, lsl 8
	mov	w0, 96
	str	w0, [x25, 2056]
	and	w0, w22, 255
	str	w0, [x25, 2052]
	lsr	w0, w22, 8
	str	w0, [x25, 2052]
	lsr	w0, w22, 16
	str	w0, [x25, 2052]
	adrp	x0, .LANCHOR23
	ldrb	w0, [x0, #:lo12:.LANCHOR23]
	cbnz	w0, .L132
	mov	w0, 208
	str	w0, [x25, 2056]
	mov	w19, 5
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	and	w5, w0, w19
.L129:
	mov	w0, 96
	str	w0, [x25, 2056]
	and	w0, w21, 255
	str	w0, [x25, 2052]
	lsr	w0, w21, 8
	str	w0, [x25, 2052]
	lsr	w21, w21, 16
	str	w21, [x25, 2052]
	mov	w0, 208
	str	w0, [x25, 2056]
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	mov	w6, w0
	cbnz	w24, .L130
	mov	w0, w20
	bl	flash_exit_slc_mode
.L130:
	mov	w0, w20
	mov	w19, 5
	bl	nandc_de_cs
	and	w19, w6, w19
	orr	w19, w19, w5
	cbz	w19, .L131
	adrp	x0, .LC2
	mov	w2, w6
	mov	w1, w22
	add	x0, x0, :lo12:.LC2
	bl	printf
.L131:
	mov	w0, w19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L127:
	bl	flash_exit_slc_mode
	b	.L128
.L132:
	mov	w5, 0
	b	.L129
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
	and	w23, w1, 255
	adrp	x1, .LANCHOR8
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	cmp	w1, w0
	bhi	.L141
	adrp	x1, .LANCHOR24
	adrp	x0, .LC0
	mov	w2, 561
	add	x1, x1, :lo12:.LANCHOR24
	add	x0, x0, :lo12:.LC0
	bl	printf
.L142:
	b	.L142
.L141:
	adrp	x1, .LANCHOR10
	add	x1, x1, :lo12:.LANCHOR10
	mov	w21, w2
	ldrb	w20, [x1, w0, sxtw]
	adrp	x0, .LANCHOR6
	ldr	x24, [x0, #:lo12:.LANCHOR6]
	adrp	x0, .LANCHOR22
	and	x19, x20, 255
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	add	x22, x19, 8
	add	x22, x24, x22, lsl 8
	tbz	x0, 4, .L143
	adrp	x0, .LC3
	mov	w1, w20
	add	x0, x0, :lo12:.LC3
	bl	printf
.L143:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w23, .L144
	bl	flash_enter_slc_mode
.L145:
	add	x0, x24, x19, lsl 8
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
	mov	w5, w0
	cbnz	w23, .L146
	mov	w0, w20
	bl	flash_exit_slc_mode
.L146:
	mov	w0, w20
	mov	w19, 5
	bl	nandc_de_cs
	ands	w19, w5, w19
	beq	.L147
	adrp	x0, .LANCHOR13
	mov	w2, w19
	ldrh	w1, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	udiv	w1, w21, w1
	bl	printf
.L147:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L144:
	bl	flash_exit_slc_mode
	b	.L145
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
	adrp	x0, .LANCHOR19
	add	x0, x0, :lo12:.LANCHOR19
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR13
	stp	x21, x22, [sp, 32]
	add	x23, x23, :lo12:.LANCHOR13
	ldrh	w20, [x0, 14]
	adrp	x22, .LANCHOR8
	str	x25, [sp, 64]
	add	x22, x22, :lo12:.LANCHOR8
	adrp	x24, .LANCHOR10
	ldrb	w1, [x0, 13]
	mul	w20, w20, w1
	and	w20, w20, 65535
.L157:
	ldrb	w0, [x22]
	cmp	w0, w19
	bhi	.L160
	ldp	x19, x20, [sp, 16]
	mov	w1, 0
	ldp	x21, x22, [sp, 32]
	adrp	x0, .LC5
	ldp	x23, x24, [sp, 48]
	add	x0, x0, :lo12:.LC5
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	b	printf
.L160:
	add	x0, x24, :lo12:.LANCHOR10
	mov	w21, 0
	ldrb	w25, [x0, w19, sxtw]
.L158:
	cmp	w20, w21, uxth
	bhi	.L159
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L157
.L159:
	ldrh	w1, [x23]
	mov	w0, w25
	mul	w1, w1, w21
	add	w21, w21, 1
	bl	flash_erase_block
	b	.L158
	.size	flash_erase_all, .-flash_erase_all
	.section	.text.flash_set_interface_mode,"ax",@progbits
	.align	2
	.global	flash_set_interface_mode
	.type	flash_set_interface_mode, %function
flash_set_interface_mode:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR6
	adrp	x5, .LANCHOR26
	add	x5, x5, :lo12:.LANCHOR26
	add	x29, sp, 0
	ldr	x6, [x1, #:lo12:.LANCHOR6]
	adrp	x1, .LANCHOR25
	mov	x2, 0
	mov	w11, 69
	ldrb	w1, [x1, #:lo12:.LANCHOR25]
	mov	w7, 239
	mov	w8, 128
	mov	w12, 1
	and	w10, w1, 4
	and	w4, w1, 1
	mov	w13, 35
	mov	w14, 5
.L170:
	lsl	x1, x2, 3
	ldrb	w3, [x1, x5]
	cmp	w3, 152
	ccmp	w3, w11, 4, ne
	beq	.L163
	cmp	w3, 44
	bne	.L164
.L163:
	cmp	w0, 1
	bne	.L165
	cbz	w4, .L164
	add	x1, x6, x2, lsl 8
	cmp	w3, 44
	str	w7, [x1, 2056]
	bne	.L166
	str	w0, [x1, 2052]
	str	w14, [x1, 2048]
.L169:
	str	wzr, [x1, 2048]
	str	wzr, [x1, 2048]
	str	wzr, [x1, 2048]
.L164:
	add	x2, x2, 1
	cmp	x2, 4
	bne	.L170
	bl	nandc_wait_flash_ready
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L166:
	str	w8, [x1, 2052]
	str	w0, [x1, 2048]
	b	.L169
.L165:
	cbz	w10, .L164
	add	x1, x6, x2, lsl 8
	cmp	w3, 44
	str	w7, [x1, 2056]
	bne	.L168
	str	w12, [x1, 2052]
	str	w13, [x1, 2048]
	b	.L169
.L168:
	str	w8, [x1, 2052]
	str	wzr, [x1, 2048]
	b	.L169
	.size	flash_set_interface_mode, .-flash_set_interface_mode
	.section	.text.flash_reset,"ax",@progbits
	.align	2
	.global	flash_reset
	.type	flash_reset, %function
flash_reset:
	adrp	x1, .LANCHOR6
	ubfiz	x0, x0, 8, 8
	add	x0, x0, 2048
	ldr	x1, [x1, #:lo12:.LANCHOR6]
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
	and	w6, w0, 255
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LANCHOR6
	mov	x5, x1
	add	x29, sp, 0
	ldr	x4, [x0, #:lo12:.LANCHOR6]
	mov	w0, w6
	bl	flash_reset
	mov	w0, w6
	bl	nandc_cs
	ubfiz	x2, x6, 8, 8
	add	x2, x4, x2
	mov	w0, 144
	str	w0, [x2, 2056]
	mov	w0, 200
	str	wzr, [x2, 2052]
	bl	timer_delay_ns
	ldr	w0, [x2, 2048]
	ldp	x29, x30, [sp], 16
	strb	w0, [x5]
	ldr	w0, [x2, 2048]
	strb	w0, [x5, 1]
	ldr	w0, [x2, 2048]
	strb	w0, [x5, 2]
	ldr	w0, [x2, 2048]
	strb	w0, [x5, 3]
	ldr	w0, [x2, 2048]
	strb	w0, [x5, 4]
	ldr	w0, [x2, 2048]
	strb	w0, [x5, 5]
	ldr	w0, [x2, 2048]
	strb	w0, [x5, 6]
	ldr	w0, [x2, 2048]
	strb	w0, [x5, 7]
	mov	w0, w6
	b	nandc_de_cs
	.size	flash_read_id, .-flash_read_id
	.section	.text.flash_read_spare,"ax",@progbits
	.align	2
	.global	flash_read_spare
	.type	flash_read_spare, %function
flash_read_spare:
	stp	x29, x30, [sp, -16]!
	mov	x5, x2
	adrp	x2, .LANCHOR19+9
	ubfiz	x0, x0, 8, 8
	add	x29, sp, 0
	ldrb	w3, [x2, #:lo12:.LANCHOR19+9]
	adrp	x2, .LANCHOR6
	ldr	x4, [x2, #:lo12:.LANCHOR6]
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
	adrp	x2, .LANCHOR6
	and	w0, w0, 255
	add	x29, sp, 0
	ldr	x4, [x2, #:lo12:.LANCHOR6]
	adrp	x2, .LANCHOR19
	add	x3, x2, :lo12:.LANCHOR19
	mov	x5, x2
	sxtw	x2, w0
	add	x2, x2, 8
	ldrb	w3, [x3, 29]
	add	x2, x4, x2, lsl 8
	cbz	w3, .L185
.L192:
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
	add	x2, x5, :lo12:.LANCHOR19
	ldr	w0, [x4, 2048]
	mov	w1, 5
	and	w0, w0, w1
	ldrb	w1, [x2, 30]
	cbz	w1, .L184
	str	w1, [x4, 2056]
.L184:
	ldp	x29, x30, [sp], 16
	ret
.L185:
	mov	w3, 162
	b	.L192
	.size	sandisk_prog_test_bad_block, .-sandisk_prog_test_bad_block
	.section	.text.nandc_bch_sel,"ax",@progbits
	.align	2
	.global	nandc_bch_sel
	.type	nandc_bch_sel, %function
nandc_bch_sel:
	adrp	x2, .LANCHOR27
	mov	w1, 1
	strb	w0, [x2, #:lo12:.LANCHOR27]
	adrp	x2, .LANCHOR7
	ldrb	w2, [x2, #:lo12:.LANCHOR7]
	cmp	w2, 9
	adrp	x2, .LANCHOR6
	ldr	x2, [x2, #:lo12:.LANCHOR6]
	bne	.L194
	str	w1, [x2, 16]
	cmp	w0, 70
	beq	.L201
	cmp	w0, 60
	beq	.L202
	cmp	w0, 40
	cset	w1, eq
	add	w1, w1, 1
.L195:
	lsl	w1, w1, 25
	orr	w1, w1, 1
	str	w1, [x2, 32]
	ret
.L201:
	mov	w1, 0
	b	.L195
.L202:
	mov	w1, 3
	b	.L195
.L194:
	str	w1, [x2, 8]
	cmp	w0, 16
	mov	w1, 4096
	bne	.L197
.L200:
	and	w1, w1, -17
.L198:
	orr	w1, w1, 1
	str	w1, [x2, 12]
	ret
.L197:
	cmp	w0, 24
	bne	.L199
	orr	w1, w1, 16
	b	.L198
.L199:
	orr	w1, w1, 262144
	cmp	w0, 40
	orr	w1, w1, 16
	bne	.L198
	b	.L200
	.size	nandc_bch_sel, .-nandc_bch_sel
	.section	.text.NandCIrqEnable,"ax",@progbits
	.align	2
	.global	NandCIrqEnable
	.type	NandCIrqEnable, %function
NandCIrqEnable:
	ret
	.size	NandCIrqEnable, .-NandCIrqEnable
	.section	.text.NandCIrqDisable,"ax",@progbits
	.align	2
	.global	NandCIrqDisable
	.type	NandCIrqDisable, %function
NandCIrqDisable:
	ret
	.size	NandCIrqDisable, .-NandCIrqDisable
	.section	.text.rk_nandc_get_irq_status,"ax",@progbits
	.align	2
	.global	rk_nandc_get_irq_status
	.type	rk_nandc_get_irq_status, %function
rk_nandc_get_irq_status:
	adrp	x1, .LANCHOR7
	ldrb	w1, [x1, #:lo12:.LANCHOR7]
	cmp	w1, 9
	bne	.L210
	ldr	w0, [x0, 296]
	ret
.L210:
	ldr	w0, [x0, 372]
	ret
	.size	rk_nandc_get_irq_status, .-rk_nandc_get_irq_status
	.section	.text.rk_nandc_flash_ready,"ax",@progbits
	.align	2
	.global	rk_nandc_flash_ready
	.type	rk_nandc_flash_ready, %function
rk_nandc_flash_ready:
	ret
	.size	rk_nandc_flash_ready, .-rk_nandc_flash_ready
	.section	.text.NandcIqrWaitFlashReady,"ax",@progbits
	.align	2
	.global	NandcIqrWaitFlashReady
	.type	NandcIqrWaitFlashReady, %function
NandcIqrWaitFlashReady:
	ret
	.size	NandcIqrWaitFlashReady, .-NandcIqrWaitFlashReady
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
	adrp	x4, .LANCHOR30
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w23, w0, 255
	adrp	x0, .LANCHOR7
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	add	w20, w1, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR7]
	adrp	x24, .LANCHOR6
	cmp	w0, 9
	bne	.L216
	ubfiz	w19, w23, 1, 1
	mov	w0, 1
	orr	w19, w19, 8
	asr	w20, w20, 1
	bfi	w19, w0, 5, 2
	adrp	x0, .LANCHOR28
	orr	w19, w19, 536870912
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	orr	w19, w19, 1024
	and	w19, w19, -17
	bfi	w19, w20, 22, 6
	cbz	w0, .L217
	adrp	x0, .LANCHOR29
	ldrb	w1, [x0, #:lo12:.LANCHOR29]
	orr	w0, w19, 512
	cmp	w1, 0
	csel	w19, w0, w19, ne
.L217:
	add	x21, x4, :lo12:.LANCHOR30
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
	ldr	x1, [x24, #:lo12:.LANCHOR6]
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
	adrp	x2, .LANCHOR31
	orr	w0, w0, 1
	ldrh	w2, [x2, #:lo12:.LANCHOR31]
	bfi	w0, w2, 16, 11
	str	w0, [x1, 48]
	str	w19, [x1, 16]
	orr	w19, w19, 4
	str	w19, [x1, 16]
.L215:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L216:
	ldr	x0, [x24, #:lo12:.LANCHOR6]
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
	cbz	w23, .L219
	adrp	x0, .LANCHOR27
	ubfx	x1, x1, 1, 7
	ldr	x8, [x4, #:lo12:.LANCHOR30]
	add	x1, x3, x1, lsl 2
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
	mov	w5, 128
	cmp	w0, 24
	mov	w0, 64
	csel	w5, w5, w0, hi
	mov	w0, 0
.L221:
	add	w7, w5, w0
	cmp	x3, x1
	bne	.L222
.L223:
	add	x21, x4, :lo12:.LANCHOR30
	ldr	x0, [x4, #:lo12:.LANCHOR30]
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
	ldr	x1, [x24, #:lo12:.LANCHOR6]
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
	b	.L215
.L222:
	ldrh	w10, [x3]
	and	x0, x0, 4294967292
	ldrh	w6, [x3, 2]
	add	x3, x3, 4
	orr	x6, x10, x6, lsl 16
	str	w6, [x8, x0]
	mov	w0, w7
	b	.L221
.L219:
	ldr	x1, [x4, #:lo12:.LANCHOR30]
	str	w0, [x1]
	b	.L223
	.size	nandc_xfer_start, .-nandc_xfer_start
	.section	.text.nandc_set_seed,"ax",@progbits
	.align	2
	.global	nandc_set_seed
	.type	nandc_set_seed, %function
nandc_set_seed:
	and	x0, x0, 127
	adrp	x1, .LANCHOR32
	add	x1, x1, :lo12:.LANCHOR32
	ldrh	w0, [x1, x0, lsl 1]
	adrp	x1, .LANCHOR29
	ldrb	w2, [x1, #:lo12:.LANCHOR29]
	orr	w1, w0, -1073741824
	cmp	w2, 0
	csel	w0, w1, w0, ne
	adrp	x1, .LANCHOR7
	ldrb	w1, [x1, #:lo12:.LANCHOR7]
	cmp	w1, 9
	adrp	x1, .LANCHOR6
	ldr	x1, [x1, #:lo12:.LANCHOR6]
	bne	.L233
	str	w0, [x1, 520]
	ret
.L233:
	str	w0, [x1, 336]
	ret
	.size	nandc_set_seed, .-nandc_set_seed
	.section	.text.flash_start_page_read,"ax",@progbits
	.align	2
	.global	flash_start_page_read
	.type	flash_start_page_read, %function
flash_start_page_read:
	stp	x29, x30, [sp, -16]!
	and	w10, w0, 255
	adrp	x0, .LANCHOR8
	ubfx	x2, x1, 21, 3
	add	x29, sp, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cmp	w0, w2
	bhi	.L238
	adrp	x1, .LANCHOR33
	adrp	x0, .LC0
	mov	w2, 738
	add	x1, x1, :lo12:.LANCHOR33
	add	x0, x0, :lo12:.LC0
	bl	printf
.L239:
	b	.L239
.L238:
	adrp	x0, .LANCHOR10
	add	x0, x0, :lo12:.LANCHOR10
	and	w5, w1, 2097151
	ubfx	x8, x1, 24, 2
	ldrb	w7, [x0, w2, sxtw]
	adrp	x0, .LANCHOR6
	ldr	x6, [x0, #:lo12:.LANCHOR6]
	mov	w0, w7
	bl	nandc_cs
	adrp	x11, .LANCHOR34
	cbnz	w8, .L240
	adrp	x0, .LANCHOR11
	ldrb	w1, [x0, #:lo12:.LANCHOR11]
	adrp	x0, .LANCHOR12
	cbz	w1, .L241
	ldrb	w1, [x0, #:lo12:.LANCHOR12]
	cbz	w1, .L242
.L241:
	adrp	x1, .LANCHOR13
	ldrb	w0, [x0, #:lo12:.LANCHOR12]
	ldrh	w1, [x1, #:lo12:.LANCHOR13]
	udiv	w2, w5, w1
	mul	w2, w2, w1
	sub	w5, w5, w2
	cbz	w0, .L243
	add	w5, w2, w5, lsl 1
.L242:
	mov	w0, w7
	bl	flash_enter_slc_mode
	b	.L244
.L243:
	adrp	x3, .LANCHOR14
	add	x3, x3, :lo12:.LANCHOR14
	ldrh	w5, [x3, w5, uxtw 1]
	add	w5, w5, w2
.L244:
	ubfiz	x2, x7, 8, 8
	and	w0, w5, 255
	add	x2, x6, x2
	str	wzr, [x2, 2056]
	str	wzr, [x2, 2052]
	str	wzr, [x2, 2052]
	str	w0, [x2, 2052]
	lsr	w0, w5, 8
	str	w0, [x2, 2052]
	lsr	w0, w5, 16
	str	w0, [x2, 2052]
	ldr	x0, [x11, #:lo12:.LANCHOR34]
	str	w10, [x2, 2056]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L246
	cbz	w8, .L246
	add	w5, w5, w5, lsl 1
	sub	w0, w8, #1
	add	w0, w5, w0
.L255:
	bl	nandc_set_seed
	ldp	x29, x30, [sp], 16
	mov	w0, 0
	b	nandc_de_cs
.L240:
	ldr	x0, [x11, #:lo12:.LANCHOR34]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L245
	sxtw	x0, w7
	add	x0, x0, 8
	add	x0, x6, x0, lsl 8
	str	w8, [x0, 8]
	b	.L244
.L245:
	mov	w0, w7
	bl	flash_exit_slc_mode
	b	.L244
.L246:
	mov	w0, w5
	b	.L255
	.size	flash_start_page_read, .-flash_start_page_read
	.section	.text.FlashDeInit,"ax",@progbits
	.align	2
	.global	FlashDeInit
	.type	FlashDeInit, %function
FlashDeInit:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	nandc_wait_flash_ready
	mov	w0, 0
	bl	hynix_reconfig_rr_para
	adrp	x15, .LANCHOR35
	ldrb	w0, [x15, #:lo12:.LANCHOR35]
	cbz	w0, .L257
	adrp	x0, .LANCHOR25
	ldrb	w0, [x0, #:lo12:.LANCHOR25]
	tbz	x0, 0, .L257
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
	bl	nandc_set_if_mode
	strb	wzr, [x15, #:lo12:.LANCHOR35]
.L257:
	adrp	x3, .LANCHOR29
	ldrb	w0, [x3, #:lo12:.LANCHOR29]
	cbz	w0, .L258
	mov	w0, 0
	strb	wzr, [x3, #:lo12:.LANCHOR29]
	bl	nandc_set_seed
	mov	w0, 1
	strb	w0, [x3, #:lo12:.LANCHOR29]
.L258:
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FlashDeInit, .-FlashDeInit
	.section	.text.nandc_randomizer_enable,"ax",@progbits
	.align	2
	.global	nandc_randomizer_enable
	.type	nandc_randomizer_enable, %function
nandc_randomizer_enable:
	adrp	x1, .LANCHOR29
	strb	w0, [x1, #:lo12:.LANCHOR29]
	ret
	.size	nandc_randomizer_enable, .-nandc_randomizer_enable
	.section	.text.nandc_get_chip_if,"ax",@progbits
	.align	2
	.global	nandc_get_chip_if
	.type	nandc_get_chip_if, %function
nandc_get_chip_if:
	adrp	x1, .LANCHOR6
	ubfiz	x0, x0, 8, 8
	add	x0, x0, 2048
	ldr	x1, [x1, #:lo12:.LANCHOR6]
	add	x0, x1, x0
	ret
	.size	nandc_get_chip_if, .-nandc_get_chip_if
	.section	.text.buf_reinit,"ax",@progbits
	.align	2
	.global	buf_reinit
	.type	buf_reinit, %function
buf_reinit:
	adrp	x0, .LANCHOR36
	add	x1, x0, :lo12:.LANCHOR36
	mov	w2, 0
.L272:
	and	w3, w2, 255
	strb	wzr, [x1, 2]
	add	w4, w3, 1
	strb	w3, [x1, 1]
	strb	w4, [x1]
	add	w2, w2, 1
	str	xzr, [x1, 16]
	cmp	w2, 32
	add	x1, x1, 64
	bne	.L272
	add	x0, x0, :lo12:.LANCHOR36
	mov	w1, -1
	strb	w1, [x0, 1984]
	adrp	x0, .LANCHOR37
	strb	wzr, [x0, #:lo12:.LANCHOR37]
	adrp	x0, .LANCHOR38
	strb	w2, [x0, #:lo12:.LANCHOR38]
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
	bne	.L282
	ldrb	w1, [x1, 1]
	cmp	w1, 255
	bne	.L276
	adrp	x1, .LANCHOR39
	adrp	x0, .LC0
	mov	w2, 74
	add	x1, x1, :lo12:.LANCHOR39
	add	x0, x0, :lo12:.LC0
	bl	printf
.L277:
	b	.L277
.L276:
	strb	w1, [x0]
.L274:
	ldp	x29, x30, [sp], 16
	ret
.L279:
	sbfiz	x0, x0, 6, 32
	strb	w1, [x2, x0]
	b	.L274
.L282:
	adrp	x2, .LANCHOR36
	add	x2, x2, :lo12:.LANCHOR36
.L283:
	mov	w0, w3
	sbfiz	x3, x3, 6, 32
	ldrb	w3, [x2, x3]
	cmp	w3, 255
	bne	.L283
	ldrb	w1, [x1, 1]
	cmp	w1, 255
	bne	.L279
	adrp	x1, .LANCHOR39
	adrp	x0, .LC0
	mov	w2, 81
	add	x1, x1, :lo12:.LANCHOR39
	add	x0, x0, :lo12:.LC0
	bl	printf
.L280:
	b	.L280
	.size	buf_add_tail, .-buf_add_tail
	.section	.text.buf_free,"ax",@progbits
	.align	2
	.global	buf_free
	.type	buf_free, %function
buf_free:
	ldrb	w1, [x0, 2]
	adrp	x2, .LANCHOR37
	and	w1, w1, 8
	strb	w1, [x0, 2]
	cbz	w1, .L286
	stp	x29, x30, [sp, -16]!
	mov	x1, x0
	add	x0, x2, :lo12:.LANCHOR37
	add	x29, sp, 0
	bl	buf_add_tail
	adrp	x1, .LANCHOR38
	ldp	x29, x30, [sp], 16
	ldrb	w0, [x1, #:lo12:.LANCHOR38]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR38]
	ret
.L286:
	ldrb	w1, [x2, #:lo12:.LANCHOR37]
	strb	w1, [x0]
	adrp	x1, .LANCHOR38
	ldrb	w0, [x0, 1]
	strb	w0, [x2, #:lo12:.LANCHOR37]
	ldrb	w0, [x1, #:lo12:.LANCHOR38]
	add	w0, w0, 1
	strb	w0, [x1, #:lo12:.LANCHOR38]
	ret
	.size	buf_free, .-buf_free
	.section	.text.buf_alloc,"ax",@progbits
	.align	2
	.global	buf_alloc
	.type	buf_alloc, %function
buf_alloc:
	adrp	x1, .LANCHOR38
	ldrb	w3, [x1, #:lo12:.LANCHOR38]
	cbnz	w3, .L293
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR40
	adrp	x0, .LC0
	mov	w2, 121
	add	x29, sp, 0
	add	x1, x1, :lo12:.LANCHOR40
	add	x0, x0, :lo12:.LC0
	bl	printf
.L294:
	b	.L294
.L293:
	adrp	x6, .LANCHOR37
	and	w7, w0, 255
	mov	x5, x1
	adrp	x1, .LANCHOR36
	ldrb	w2, [x6, #:lo12:.LANCHOR37]
	add	x4, x1, :lo12:.LANCHOR36
	ubfiz	x0, x2, 6, 8
	add	x0, x4, x0
	cbnz	w7, .L295
	cmp	w3, 1
	beq	.L297
.L295:
	add	x1, x1, :lo12:.LANCHOR36
	sbfiz	x2, x2, 6, 32
	add	x4, x1, x2
	sub	w3, w3, #1
	strb	w3, [x5, #:lo12:.LANCHOR38]
	mov	w3, 1
	ldrb	w7, [x1, x2]
	strb	w3, [x4, 2]
	mov	w3, -1
	strb	w7, [x6, #:lo12:.LANCHOR37]
	strb	w3, [x1, x2]
	mov	w1, -1
	strh	wzr, [x4, 50]
	str	xzr, [x4, 16]
	str	w1, [x4, 36]
.L292:
	ret
.L297:
	mov	x0, 0
	b	.L292
	.size	buf_alloc, .-buf_alloc
	.section	.text.buf_remove_buf,"ax",@progbits
	.align	2
	.global	buf_remove_buf
	.type	buf_remove_buf, %function
buf_remove_buf:
	ldrb	w4, [x1, 1]
	ldrb	w2, [x0]
	cmp	w4, w2
	bne	.L304
	ldrb	w1, [x1]
	strb	w1, [x0]
.L308:
	mov	w0, 1
	ret
.L305:
	mov	w3, w2
	sbfiz	x2, x2, 6, 32
	ldrb	w2, [x0, x2]
	cmp	w4, w2
	bne	.L306
	sbfiz	x3, x3, 6, 32
	ldrb	w2, [x1]
	strb	w2, [x0, x3]
	mov	w0, -1
	strb	w0, [x1]
	b	.L308
.L304:
	adrp	x0, .LANCHOR36
	add	x0, x0, :lo12:.LANCHOR36
.L306:
	cmp	w2, 255
	bne	.L305
	mov	w0, 0
	ret
	.size	buf_remove_buf, .-buf_remove_buf
	.section	.text.buf_remove_free,"ax",@progbits
	.align	2
	.global	buf_remove_free
	.type	buf_remove_free, %function
buf_remove_free:
	stp	x29, x30, [sp, -16]!
	adrp	x6, .LANCHOR38
	mov	x5, x0
	add	x29, sp, 0
	ldrb	w0, [x6, #:lo12:.LANCHOR38]
	cbnz	w0, .L310
	adrp	x1, .LANCHOR41
	adrp	x0, .LC0
	mov	w2, 170
	add	x1, x1, :lo12:.LANCHOR41
	add	x0, x0, :lo12:.LC0
	bl	printf
.L311:
	b	.L311
.L310:
	mov	x1, x5
	adrp	x0, .LANCHOR37
	add	x0, x0, :lo12:.LANCHOR37
	bl	buf_remove_buf
	cmp	w0, 1
	bne	.L309
	ldrb	w0, [x6, #:lo12:.LANCHOR38]
	sub	w0, w0, #1
	strb	w0, [x6, #:lo12:.LANCHOR38]
	ldrb	w0, [x5, 2]
	orr	w0, w0, 1
	strb	w0, [x5, 2]
.L309:
	ldp	x29, x30, [sp], 16
	ret
	.size	buf_remove_free, .-buf_remove_free
	.section	.text.flash_check_bad_block,"ax",@progbits
	.align	2
	.global	flash_check_bad_block
	.type	flash_check_bad_block, %function
flash_check_bad_block:
	adrp	x3, .LANCHOR19
	add	x3, x3, :lo12:.LANCHOR19
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
	adrp	x2, .LANCHOR5
	ldr	x2, [x2, #:lo12:.LANCHOR5]
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
	adrp	x0, .LANCHOR19
	add	x0, x0, :lo12:.LANCHOR19
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	ldrh	w19, [x0, 14]
	ldrb	w1, [x0, 13]
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
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
	adrp	x0, .LANCHOR5
	ldr	x2, [x0, #:lo12:.LANCHOR5]
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
	adrp	x0, .LANCHOR42
	add	x0, x0, :lo12:.LANCHOR42
	bl	buf_add_tail
	adrp	x1, .LANCHOR43
	ldp	x29, x30, [sp], 16
	ldrb	w0, [x1, #:lo12:.LANCHOR43]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x1, #:lo12:.LANCHOR43]
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
	cbnz	x0, .L320
	adrp	x1, .LANCHOR44
	adrp	x0, .LC0
	mov	w2, 539
	add	x1, x1, :lo12:.LANCHOR44
	add	x0, x0, :lo12:.LC0
	bl	printf
.L321:
	b	.L321
.L320:
	adrp	x2, .LANCHOR45
	ldrb	w1, [x0, 56]
	mov	x19, x0
	ldrb	w2, [x2, #:lo12:.LANCHOR45]
	cmp	w2, w1
	bcs	.L322
	adrp	x1, .LANCHOR44
	adrp	x0, .LC0
	mov	w2, 544
	add	x1, x1, :lo12:.LANCHOR44
	add	x0, x0, :lo12:.LC0
	bl	printf
.L323:
	b	.L323
.L322:
	adrp	x20, .LANCHOR43
	cbnz	w1, .L324
	bl	buf_free
	ldrb	w0, [x20, #:lo12:.LANCHOR43]
.L319:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L324:
	mov	x1, x0
	adrp	x0, .LANCHOR42
	add	x0, x0, :lo12:.LANCHOR42
	bl	buf_add_tail
	adrp	x1, .LANCHOR46
	ldrb	w3, [x19, 56]
	ldrb	w0, [x20, #:lo12:.LANCHOR43]
	ldr	x1, [x1, #:lo12:.LANCHOR46]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x20, #:lo12:.LANCHOR43]
	ldr	w2, [x1, 16]
	add	w2, w2, w3
	str	w2, [x1, 16]
	ldr	w2, [x1, 32]
	add	w2, w2, 1
	str	w2, [x1, 32]
	b	.L319
	.size	ftl_write_buf, .-ftl_write_buf
	.section	.text.ftl_cache_flush,"ax",@progbits
	.align	2
	.global	ftl_cache_flush
	.type	ftl_cache_flush, %function
ftl_cache_flush:
	ret
	.size	ftl_cache_flush, .-ftl_cache_flush
	.section	.text.ftl_read_buf,"ax",@progbits
	.align	2
	.global	ftl_read_buf
	.type	ftl_read_buf, %function
ftl_read_buf:
	stp	x29, x30, [sp, -32]!
	adrp	x2, .LANCHOR47
	add	x29, sp, 0
	str	x19, [sp, 16]
	ldr	w2, [x2, #:lo12:.LANCHOR47]
	cmp	w2, w0
	bhi	.L329
	adrp	x1, .LANCHOR48
	adrp	x0, .LC0
	mov	w2, 771
	add	x1, x1, :lo12:.LANCHOR48
	add	x0, x0, :lo12:.LC0
	bl	printf
.L330:
	b	.L330
.L329:
	adrp	x19, .LANCHOR36
	add	x3, x19, :lo12:.LANCHOR36
	add	x3, x3, 2
	mov	w2, 0
.L333:
	ldr	w4, [x3, 34]
	cmp	w0, w4
	bne	.L331
	ldrb	w4, [x3]
	tbz	x4, 3, .L331
	add	x19, x19, :lo12:.LANCHOR36
	ubfiz	x2, x2, 6, 32
	add	x19, x19, x2
	orr	w0, w4, 4
	strb	w0, [x19, 2]
	tbnz	x4, 0, .L328
	mov	x0, x19
	bl	buf_remove_free
.L328:
	mov	x0, x19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L331:
	add	w2, w2, 1
	add	x3, x3, 64
	cmp	w2, 32
	bne	.L333
	adrp	x2, .LANCHOR49
	ldr	w3, [x2, #:lo12:.LANCHOR49]
	cmn	w3, #1
	bne	.L334
	str	w0, [x2, #:lo12:.LANCHOR49]
	adrp	x0, .LANCHOR50
	str	x1, [x0, #:lo12:.LANCHOR50]
.L334:
	mov	x19, 0
	b	.L328
	.size	ftl_read_buf, .-ftl_read_buf
	.section	.text.ftl_read_buf_free,"ax",@progbits
	.align	2
	.global	ftl_read_buf_free
	.type	ftl_read_buf_free, %function
ftl_read_buf_free:
	mov	x5, x0
	stp	x29, x30, [sp, -16]!
	mov	x1, x0
	adrp	x0, .LANCHOR51
	add	x29, sp, 0
	add	x0, x0, :lo12:.LANCHOR51
	bl	buf_remove_buf
	ldrb	w0, [x5, 2]
	tbz	x0, 1, .L341
	and	w0, w0, -5
	strb	w0, [x5, 2]
	ldp	x29, x30, [sp], 16
	ret
.L341:
	ldp	x29, x30, [sp], 16
	mov	x0, x5
	b	buf_free
	.size	ftl_read_buf_free, .-ftl_read_buf_free
	.section	.text.ftl_get_density,"ax",@progbits
	.align	2
	.global	ftl_get_density
	.type	ftl_get_density, %function
ftl_get_density:
	cbnz	w0, .L346
	adrp	x0, .LANCHOR52
	ldr	w0, [x0, #:lo12:.LANCHOR52]
	ret
.L346:
	cmp	w0, 4
	cset	w0, cc
	lsl	w0, w0, 13
	ret
	.size	ftl_get_density, .-ftl_get_density
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
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	ret
	.size	FtlGetCurEraseBlock, .-FtlGetCurEraseBlock
	.section	.text.FtlGetAllBlockNum,"ax",@progbits
	.align	2
	.global	FtlGetAllBlockNum
	.type	FtlGetAllBlockNum, %function
FtlGetAllBlockNum:
	adrp	x0, .LANCHOR54
	ldrh	w0, [x0, #:lo12:.LANCHOR54]
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
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	adrp	x0, .LANCHOR54
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR54]
	cmp	w0, w19
	bhi	.L354
	adrp	x1, .LANCHOR55
	adrp	x0, .LC0
	mov	w2, 240
	add	x1, x1, :lo12:.LANCHOR55
	add	x0, x0, :lo12:.LC0
	bl	printf
.L355:
	b	.L355
.L354:
	adrp	x0, .LANCHOR56
	uxtw	x20, w19
	and	w21, w1, 65535
	and	w22, w2, 65535
	ldr	x0, [x0, #:lo12:.LANCHOR56]
	adrp	x24, .LANCHOR59
	ldrh	w23, [x0, x20, lsl 1]
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L356
	ldr	x0, [x24, #:lo12:.LANCHOR59]
	mov	w4, w23
	mov	w2, w21
	mov	w1, w19
	add	x0, x0, x20, lsl 2
	ldrb	w3, [x0, 2]
	adrp	x0, .LANCHOR57
	ldrh	w6, [x0, #:lo12:.LANCHOR57]
	adrp	x0, .LANCHOR58+56
	ubfx	x3, x3, 5, 3
	ldrh	w5, [x0, #:lo12:.LANCHOR58+56]
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
.L356:
	ldr	x0, [x24, #:lo12:.LANCHOR59]
	add	x20, x0, x20, lsl 2
	ldrb	w0, [x20, 2]
	tst	w0, 224
	bne	.L357
	cbz	w23, .L371
	adrp	x1, .LANCHOR55
	adrp	x0, .LC0
	mov	w2, 245
	add	x1, x1, :lo12:.LANCHOR55
	add	x0, x0, :lo12:.LC0
	bl	printf
.L359:
	b	.L359
.L357:
	adrp	x1, .LANCHOR58
	add	x0, x1, :lo12:.LANCHOR58
	ldrh	w1, [x1, #:lo12:.LANCHOR58]
	cmp	w1, w19
	beq	.L371
	adrp	x1, .LANCHOR60
	ldr	x2, [x1, #:lo12:.LANCHOR60]
	ldrh	w1, [x2, 48]
	cmp	w1, w19
	beq	.L371
	ldrh	w1, [x2, 16]
	cmp	w1, w19
	beq	.L371
	ldrh	w1, [x2, 80]
	cmp	w1, w19
	beq	.L371
	ldrh	w3, [x0, 56]
	add	x0, x0, 58
	mov	w1, 0
.L360:
	cmp	w1, w3
	bcc	.L361
	ubfiz	x1, x22, 7, 16
	add	x0, x2, 392
	add	x1, x1, 136
	cmp	w21, 0
	add	x1, x2, x1
	mov	w3, 65535
	csel	x0, x1, x0, eq
	add	x1, x0, 128
.L365:
	ldrh	w4, [x0]
	cmp	w4, w3
	bne	.L363
	strh	w19, [x0]
	cbz	w21, .L364
	ldrh	w0, [x2, 124]
	add	w0, w0, 1
	strh	w0, [x2, 124]
.L379:
	mov	w0, 1
.L353:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L361:
	ldrh	w4, [x0], 2
	cmp	w4, w19
	beq	.L371
	add	w1, w1, 1
	b	.L360
.L364:
	add	x2, x2, x22, uxth 1
	ldrh	w0, [x2, 120]
	add	w0, w0, 1
	strh	w0, [x2, 120]
	b	.L379
.L363:
	add	x0, x0, 2
	cmp	x1, x0
	bne	.L365
	b	.L379
.L371:
	mov	w0, 0
	b	.L353
	.size	gc_add_sblk, .-gc_add_sblk
	.section	.text.gc_get_src_ppa_from_index,"ax",@progbits
	.align	2
	.global	gc_get_src_ppa_from_index
	.type	gc_get_src_ppa_from_index, %function
gc_get_src_ppa_from_index:
	adrp	x1, .LANCHOR61
	ubfiz	x0, x0, 2, 16
	ldr	x1, [x1, #:lo12:.LANCHOR61]
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
	adrp	x23, .LANCHOR36
	stp	x21, x22, [sp, 32]
	add	x24, x23, :lo12:.LANCHOR36
	adrp	x22, .LANCHOR62
	add	x22, x22, :lo12:.LANCHOR62
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
.L382:
	ldrb	w19, [x22]
	cmp	w19, 255
	bne	.L395
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L395:
	lsl	x1, x19, 6
	add	x0, x23, :lo12:.LANCHOR36
	add	x2, x0, x1
	ldrb	w0, [x0, x1]
	ldr	w1, [x2, 52]
	strb	w0, [x22]
	ldrh	w26, [x2, 48]
	cbz	w1, .L383
	ldr	w2, [x2, 40]
	adrp	x0, .LANCHOR58
	add	x0, x0, :lo12:.LANCHOR58
	mov	w3, 1
	str	w2, [x0, 320]
	strh	w3, [x0, 318]
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
	adrp	x1, .LANCHOR63
	adrp	x0, .LC0
	mov	w2, 502
	add	x1, x1, :lo12:.LANCHOR63
	add	x0, x0, :lo12:.LC0
	bl	printf
.L384:
	b	.L384
.L383:
	adrp	x0, .LANCHOR64
	mov	x28, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR64]
	cmp	w1, 3
	bne	.L396
	adrp	x0, .LANCHOR60
	ldr	x0, [x0, #:lo12:.LANCHOR60]
	ldrb	w20, [x0, 89]
	add	w20, w20, w20, lsl 1
	and	w20, w20, 1023
.L385:
	adrp	x0, .LANCHOR22
	adrp	x27, .LANCHOR65
	and	x21, x26, 65535
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L386
	ldr	x1, [x27, #:lo12:.LANCHOR65]
	add	x0, x24, x19, lsl 6
	mov	w3, w26
	ldrb	w2, [x0, 1]
	adrp	x0, .LC9
	ldrb	w4, [x1, x21]
	add	x0, x0, :lo12:.LC9
	mov	w1, w26
	bl	printf
.L386:
	ldr	x0, [x27, #:lo12:.LANCHOR65]
	add	x19, x24, x19, lsl 6
	mov	x25, x21
	add	x2, x0, x21
	ldrb	w1, [x0, x21]
	ldrb	w0, [x19, 1]
	cmp	w1, w0
	beq	.L387
	adrp	x1, .LANCHOR63
	adrp	x0, .LC0
	mov	w2, 509
	add	x1, x1, :lo12:.LANCHOR63
	add	x0, x0, :lo12:.LC0
	bl	printf
.L388:
	b	.L388
.L396:
	mov	w20, 1
	b	.L385
.L387:
	ldrb	w0, [x19, 61]
	cmp	w0, 3
	beq	.L389
	ldrb	w0, [x28, #:lo12:.LANCHOR64]
	cmp	w0, 3
	bne	.L389
	adrp	x0, .LANCHOR66
	ldrb	w0, [x0, #:lo12:.LANCHOR66]
	cbnz	w0, .L389
	mov	x0, 0
.L390:
	cmp	w20, w0, uxth
	bls	.L382
	ldrb	w1, [x2, x0]
	add	x0, x0, 1
	add	x1, x24, x1, lsl 6
	strb	wzr, [x1, 61]
	b	.L390
.L389:
	adrp	x19, .LANCHOR58
	add	x19, x19, :lo12:.LANCHOR58
	add	x20, x21, x20, uxth
	mov	w21, -1
	strh	w26, [x19, 316]
.L391:
	cmp	x25, x20
	beq	.L382
	ldr	x1, [x27, #:lo12:.LANCHOR65]
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
	b	.L391
	.size	gc_write_completed, .-gc_write_completed
	.section	.text.gc_get_src_blk,"ax",@progbits
	.align	2
	.global	gc_get_src_blk
	.type	gc_get_src_blk, %function
gc_get_src_blk:
	adrp	x0, .LANCHOR60
	ldr	x2, [x0, #:lo12:.LANCHOR60]
	adrp	x0, .LANCHOR67
	ldrb	w3, [x0, #:lo12:.LANCHOR67]
	ldrh	w0, [x2, 124]
	cbz	w0, .L405
	add	x1, x2, 392
	mov	w4, 1
.L406:
	add	x5, x1, 128
	mov	w6, 65535
.L410:
	ldrh	w0, [x1]
	cmp	w0, w6
	beq	.L408
	mov	w5, -1
	strh	w5, [x1]
	cbz	w4, .L409
	ldrh	w1, [x2, 124]
	sub	w1, w1, #1
	strh	w1, [x2, 124]
	ret
.L405:
	add	x0, x2, x3, sxtw 1
	ldrh	w0, [x0, 120]
	cbz	w0, .L411
	ubfiz	x1, x3, 7, 8
	mov	w4, 0
	add	x1, x1, 136
	add	x1, x2, x1
	b	.L406
.L409:
	add	x2, x2, x3, uxtb 1
	ldrh	w1, [x2, 120]
	sub	w1, w1, #1
	strh	w1, [x2, 120]
	ret
.L408:
	add	x1, x1, 2
	cmp	x1, x5
	bne	.L410
	ret
.L411:
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
	adrp	x20, .LANCHOR58
	add	x0, x20, :lo12:.LANCHOR58
	stp	x21, x22, [sp, 32]
	ldrb	w1, [x0, 7]
	cbz	w1, .L420
	adrp	x1, .LANCHOR38
	ldrb	w1, [x1, #:lo12:.LANCHOR38]
	cmp	w1, 1
	bhi	.L420
	ldrh	w19, [x0, 316]
	adrp	x2, .LANCHOR69
	adrp	x0, .LANCHOR68
	adrp	x21, .LANCHOR65
	ldrb	w2, [x2, #:lo12:.LANCHOR69]
	add	w1, w19, 24
	ldrh	w0, [x0, #:lo12:.LANCHOR68]
	ldr	x4, [x21, #:lo12:.LANCHOR65]
	mul	w0, w0, w2
	cmp	w0, w1
	csel	w1, w0, w1, ls
	adrp	x0, .LANCHOR36
	add	x0, x0, :lo12:.LANCHOR36
.L415:
	cmp	w19, w1
	bcc	.L418
.L420:
	mov	w0, 0
	b	.L413
.L418:
	uxtw	x22, w19
	ldrb	w2, [x4, x22]
	cmp	w2, 255
	beq	.L416
	sbfiz	x3, x2, 6, 32
	add	x3, x0, x3
	ldrb	w3, [x3, 61]
	cbnz	w3, .L416
	ubfiz	x2, x2, 6, 8
	add	x0, x0, x2
	bl	buf_free
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L417
	ldr	x0, [x21, #:lo12:.LANCHOR65]
	mov	w1, w19
	ldrb	w2, [x0, x22]
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	printf
.L417:
	ldr	x0, [x21, #:lo12:.LANCHOR65]
	add	x20, x20, :lo12:.LANCHOR58
	mov	w1, -1
	strb	w1, [x0, x22]
	ldrb	w0, [x20, 7]
	sub	w0, w0, #1
	strb	w0, [x20, 7]
	mov	w0, 1
.L413:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L416:
	add	w19, w19, 1
	b	.L415
	.size	gc_free_temp_buf, .-gc_free_temp_buf
	.section	.text.gc_static_wearleveling,"ax",@progbits
	.align	2
	.global	gc_static_wearleveling
	.type	gc_static_wearleveling, %function
gc_static_wearleveling:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR46
	stp	x19, x20, [sp, 16]
	ldr	x5, [x21, #:lo12:.LANCHOR46]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	ldr	w0, [x5, 32]
	cmp	w0, 20480
	bls	.L429
	ldr	w1, [x5, 36]
	add	w1, w1, w0, lsr 10
	and	w0, w0, 1023
	stp	w0, w1, [x5, 32]
.L429:
	adrp	x0, .LANCHOR60
	ldr	w3, [x5, 36]
	ldr	x0, [x0, #:lo12:.LANCHOR60]
	ldr	w1, [x0, 568]
	ldr	w2, [x0, 12]
	add	w1, w1, 12959744
	add	w1, w1, 256
	cmp	w2, w1
	bhi	.L430
	ldr	w1, [x0, 572]
	add	w1, w1, 128
	cmp	w3, w1
	bls	.L428
.L430:
	adrp	x23, .LANCHOR59
	ldrh	w10, [x5, 134]
	adrp	x22, .LANCHOR54
	mov	w20, 65535
	ldr	x8, [x23, #:lo12:.LANCHOR59]
	mov	w19, w20
	ldrh	w11, [x22, #:lo12:.LANCHOR54]
	mov	w12, w20
	str	w2, [x0, 568]
	mov	w4, 0
	add	x8, x8, x10, uxth 2
	str	w3, [x0, 572]
	mov	w1, 0
	mov	w25, 0
	mov	w24, 0
	mov	w3, 0
	mov	w2, 0
.L432:
	cmp	w10, w11
	bcc	.L436
	ldrh	w0, [x5, 96]
	cmp	w0, w25
	bcs	.L437
	strh	w25, [x5, 96]
.L437:
	ldrh	w0, [x5, 98]
	cmp	w0, w24
	bcs	.L438
	strh	w24, [x5, 98]
.L438:
	udiv	w3, w3, w1
	adrp	x0, .LANCHOR22
	mov	x26, x0
	udiv	w4, w4, w2
	strh	w3, [x5, 88]
	strh	w4, [x5, 90]
	ldr	w5, [x0, #:lo12:.LANCHOR22]
	tbz	x5, 8, .L439
	adrp	x0, .LC11
	and	w4, w4, 65535
	and	w3, w3, 65535
	add	x0, x0, :lo12:.LC11
	bl	printf
.L439:
	ldr	w0, [x26, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L440
	adrp	x0, .LC12
	mov	w4, w24
	mov	w3, w25
	mov	w2, w19
	mov	w1, w20
	add	x0, x0, :lo12:.LC12
	bl	printf
.L440:
	sub	w0, w24, w19
	cmp	w0, 64
	bgt	.L441
.L447:
	cbnz	w19, .L442
.L448:
	cbz	w20, .L428
	ldr	x2, [x21, #:lo12:.LANCHOR46]
	ldr	x1, [x23, #:lo12:.LANCHOR59]
	ldrh	w5, [x22, #:lo12:.LANCHOR54]
	ldrh	w0, [x2, 134]
	add	x1, x1, x0, uxth 2
.L453:
	cmp	w0, w5
	bcc	.L455
	ldrh	w0, [x2, 74]
	add	w0, w20, w0
	strh	w0, [x2, 74]
	ldrh	w0, [x2, 96]
	cmp	w20, w0
	bcs	.L428
	sub	w20, w0, w20
	strh	w20, [x2, 96]
.L428:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L436:
	ldrb	w0, [x8, 2]
	tbz	x0, 3, .L433
	ldr	w0, [x8]
	ldrh	w7, [x8]
	ubfx	x0, x0, 11, 8
	and	w6, w7, 2047
.L434:
	cmp	w6, w20
	add	w1, w1, 1
	csel	w20, w6, w20, cc
	cmp	w6, w25
	add	w3, w3, w6
	csel	w6, w6, w25, hi
	and	w1, w1, 65535
	and	w20, w20, 65535
	and	w25, w6, 65535
	cmp	w0, w12
	bne	.L456
	b	.L457
.L433:
	tst	w0, 24
	bne	.L435
	ldrh	w7, [x8]
	mov	w0, 65535
	and	w6, w7, 2047
	b	.L434
.L435:
	ldr	w0, [x8]
	ubfx	x0, x0, 11, 8
.L456:
	cmp	w0, w19
	add	w2, w2, 1
	csel	w19, w0, w19, cc
	cmp	w0, w24
	add	w4, w4, w0
	csel	w0, w0, w24, hi
	and	w2, w2, 65535
	and	w19, w19, 65535
	and	w24, w0, 65535
.L457:
	add	w10, w10, 1
	add	x8, x8, 4
	and	w10, w10, 65535
	b	.L432
.L441:
	ldr	x0, [x21, #:lo12:.LANCHOR46]
	add	x25, x22, :lo12:.LANCHOR54
	ldrh	w24, [x0, 134]
.L444:
	ldrh	w0, [x25]
	cmp	w0, w24
	bls	.L447
	ldr	x2, [x23, #:lo12:.LANCHOR59]
	ubfiz	x1, x24, 2, 16
	add	x0, x2, x1
	ldrb	w0, [x0, 2]
	tst	w0, 192
	beq	.L445
	and	w3, w0, 224
	cmp	w3, 224
	beq	.L445
	tbz	x0, 4, .L445
	ldr	w0, [x2, x1]
	ubfx	x0, x0, 11, 8
	cmp	w0, w19
	bhi	.L445
	mov	w2, 1
	mov	w0, w24
	mov	w1, w2
	bl	gc_add_sblk
.L445:
	add	w24, w24, 1
	and	w24, w24, 65535
	b	.L444
.L442:
	ldr	x2, [x21, #:lo12:.LANCHOR46]
	ldr	x1, [x23, #:lo12:.LANCHOR59]
	ldrh	w5, [x22, #:lo12:.LANCHOR54]
	ldrh	w0, [x2, 134]
	add	x1, x1, x0, uxth 2
.L449:
	cmp	w0, w5
	bcc	.L451
	ldrh	w0, [x2, 72]
	add	w0, w19, w0
	strh	w0, [x2, 72]
	ldrh	w0, [x2, 98]
	cmp	w19, w0
	bcs	.L448
	sub	w19, w0, w19
	strh	w19, [x2, 98]
	b	.L448
.L451:
	ldr	w3, [x1]
	ubfx	x4, x3, 11, 8
	cmp	w19, w4
	bhi	.L450
	sub	w4, w4, w19
	bfi	w3, w4, 11, 8
	str	w3, [x1]
.L450:
	add	w0, w0, 1
	add	x1, x1, 4
	and	w0, w0, 65535
	b	.L449
.L455:
	ldrh	w3, [x1]
	and	w4, w3, 2047
	cmp	w4, w20
	blt	.L454
	sub	w4, w4, w20
	bfi	w3, w4, 0, 11
	strh	w3, [x1]
.L454:
	add	w0, w0, 1
	add	x1, x1, 4
	and	w0, w0, 65535
	b	.L453
	.size	gc_static_wearleveling, .-gc_static_wearleveling
	.section	.text.print_gc_debug_info,"ax",@progbits
	.align	2
	.global	print_gc_debug_info
	.type	print_gc_debug_info, %function
print_gc_debug_info:
	adrp	x1, .LANCHOR58
	add	x0, x1, :lo12:.LANCHOR58
	adrp	x2, .LANCHOR38
	ldrh	w1, [x1, #:lo12:.LANCHOR58]
	ldrb	w5, [x0, 7]
	ldrb	w4, [x2, #:lo12:.LANCHOR38]
	ldrh	w3, [x0, 314]
	ldrh	w2, [x0, 2]
	adrp	x0, .LC13
	add	x0, x0, :lo12:.LC13
	b	printf
	.size	print_gc_debug_info, .-print_gc_debug_info
	.section	.text.ftl_get_blk_list_in_sblk,"ax",@progbits
	.align	2
	.global	ftl_get_blk_list_in_sblk
	.type	ftl_get_blk_list_in_sblk, %function
ftl_get_blk_list_in_sblk:
	adrp	x2, .LANCHOR59
	and	w0, w0, 65535
	adrp	x6, .LANCHOR71
	add	x6, x6, :lo12:.LANCHOR71
	ldr	x2, [x2, #:lo12:.LANCHOR59]
	mov	w3, 0
	mov	w12, 21
	add	x2, x2, x0, uxth 2
	ldrb	w11, [x2, 3]
	adrp	x2, .LANCHOR69
	ldrb	w8, [x2, #:lo12:.LANCHOR69]
	adrp	x2, .LANCHOR70
	ldrb	w5, [x2, #:lo12:.LANCHOR70]
	mul	w0, w0, w5
	and	w4, w0, 65535
	mov	w0, 0
.L479:
	cmp	w3, w8
	blt	.L483
	sxtw	x2, w0
	mov	w3, -1
.L484:
	cmp	w8, w2
	bgt	.L485
	ret
.L483:
	asr	w2, w11, w3
	tbnz	x2, 0, .L480
	sdiv	w2, w3, w5
	ldrh	w7, [x6]
	sbfiz	x10, x0, 1, 32
	cmp	w5, 1
	sub	w7, w12, w7
	lsl	w2, w2, w7
	add	w2, w4, w2
	and	w2, w2, 65535
	bhi	.L481
.L486:
	add	w0, w0, 1
	strh	w2, [x1, x10]
.L480:
	add	w3, w3, 1
	b	.L479
.L481:
	and	w7, w3, 1
	add	w2, w2, w7
	b	.L486
.L485:
	strh	w3, [x1, x2, lsl 1]
	add	x2, x2, 1
	b	.L484
	.size	ftl_get_blk_list_in_sblk, .-ftl_get_blk_list_in_sblk
	.section	.text.ftl_alloc_sblk,"ax",@progbits
	.align	2
	.global	ftl_alloc_sblk
	.type	ftl_alloc_sblk, %function
ftl_alloc_sblk:
.L488:
	stp	x29, x30, [sp, -64]!
	mov	w6, 2
	mov	w7, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w0
	adrp	x0, .LANCHOR54
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR46
	cmp	w20, 5
	ldrh	w11, [x0, #:lo12:.LANCHOR54]
	adrp	x0, .LANCHOR59
	ldr	x1, [x22, #:lo12:.LANCHOR46]
	mov	w19, 65535
	ldr	x12, [x0, #:lo12:.LANCHOR59]
	mov	w14, w11
	str	x23, [sp, 48]
	mov	w5, w19
	csel	w23, wzr, w6, ne
	mov	w13, w19
	csel	w6, w6, wzr, ne
.L503:
	ldrh	w4, [x1, 132]
	mov	w0, w4
	add	x3, x12, x4, uxth 2
.L489:
	cmp	w0, w14
	blt	.L501
	sub	w0, w0, w4
	add	w0, w7, w0
	and	w7, w0, 65535
	ldrh	w0, [x1, 134]
	sub	w2, w11, w0
	cmp	w7, w2
	blt	.L502
	cmp	w19, w13
	beq	.L502
	add	x21, x12, x19, uxth 2
	b	.L493
.L501:
	ldrb	w2, [x3, 2]
	mov	x21, x3
	tst	w2, 224
	bne	.L490
	ubfx	x2, x2, 3, 2
	cmp	w6, w2
	beq	.L490
	cbz	w23, .L491
	ldr	w2, [x3]
	ldrh	w10, [x1, 72]
	ldrh	w8, [x1, 90]
	ubfx	x2, x2, 11, 8
	add	w8, w8, 1
	add	w10, w10, w2
	cmp	w10, w8
	ble	.L492
	and	w2, w2, 65535
	cmp	w5, w2
	bls	.L490
	and	w19, w0, 65535
	mov	w5, w2
.L490:
	add	w0, w0, 1
	add	x3, x3, 4
	b	.L489
.L491:
	ldrh	w2, [x3]
	ldrh	w10, [x1, 74]
	ldrh	w8, [x1, 88]
	and	w2, w2, 2047
	add	w10, w10, w2
	add	w8, w8, 1
	cmp	w10, w8
	ble	.L492
	cmp	w2, w5
	bge	.L490
	mov	w5, w2
	and	w19, w0, 65535
	b	.L490
.L492:
	and	w19, w0, 65535
.L493:
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L494
	ldrb	w4, [x21, 3]
	adrp	x0, .LC14
	ldrb	w3, [x21, 2]
	mov	w2, w20
	mov	w1, w19
	add	x0, x0, :lo12:.LC14
	ubfx	x3, x3, 5, 3
	bl	printf
.L494:
	ldrb	w0, [x21, 2]
	bfi	w0, w20, 5, 3
	ubfx	x1, x0, 3, 2
	orr	w1, w1, w23
	bfi	w0, w1, 3, 2
	strb	w0, [x21, 2]
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	strh	w19, [x0, 132]
	tbz	x1, 0, .L495
	ldrh	w1, [x0, 116]
	sub	w1, w1, #1
	strh	w1, [x0, 116]
.L496:
	cmp	w20, 5
	bne	.L498
	ldrh	w1, [x0, 120]
	add	w1, w1, 1
	strh	w1, [x0, 120]
.L506:
	mov	w0, w19
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L495:
	ldrb	w1, [x21, 2]
	tst	w1, 24
	bne	.L497
	ldrh	w1, [x0, 114]
	sub	w1, w1, #1
	strh	w1, [x0, 114]
	b	.L496
.L497:
	ldrh	w1, [x0, 118]
	sub	w1, w1, #1
	strh	w1, [x0, 118]
	b	.L496
.L498:
	cmp	w20, 2
	bne	.L500
	ldrh	w1, [x0, 122]
	add	w1, w1, 1
	strh	w1, [x0, 122]
	b	.L506
.L500:
	cmp	w20, 3
	bne	.L506
	ldrh	w1, [x0, 124]
	add	w1, w1, 1
	strh	w1, [x0, 124]
	b	.L506
.L502:
	strh	w0, [x1, 132]
	mov	w14, w4
	b	.L503
	.size	ftl_alloc_sblk, .-ftl_alloc_sblk
	.section	.text.ftl_free_sblk,"ax",@progbits
	.align	2
	.global	ftl_free_sblk
	.type	ftl_free_sblk, %function
ftl_free_sblk:
	stp	x29, x30, [sp, -16]!
	and	x0, x0, 65535
	mov	w1, 65535
	cmp	w0, w1
	add	x29, sp, 0
	bne	.L511
	adrp	x1, .LANCHOR72
	adrp	x0, .LC0
	mov	w2, 313
	add	x1, x1, :lo12:.LANCHOR72
	add	x0, x0, :lo12:.LC0
	bl	printf
.L512:
	b	.L512
.L511:
	adrp	x1, .LANCHOR59
	ldr	x3, [x1, #:lo12:.LANCHOR59]
	add	x3, x3, x0, lsl 2
	ldrb	w1, [x3, 2]
	ands	w4, w1, 224
	bne	.L513
	adrp	x1, .LANCHOR72
	adrp	x0, .LC0
	mov	w2, 316
	add	x1, x1, :lo12:.LANCHOR72
	add	x0, x0, :lo12:.LC0
	bl	printf
.L514:
	b	.L514
.L513:
	ubfx	x2, x1, 3, 2
	cmp	w4, 160
	adrp	x1, .LANCHOR46
	bne	.L515
	ldr	x5, [x1, #:lo12:.LANCHOR46]
	ldrh	w4, [x5, 120]
	sub	w4, w4, #1
	strh	w4, [x5, 120]
.L516:
	tbz	x2, 0, .L518
	ldr	x2, [x1, #:lo12:.LANCHOR46]
	ldrh	w1, [x2, 116]
	add	w1, w1, 1
	strh	w1, [x2, 116]
.L519:
	ldrb	w1, [x3, 2]
	and	w1, w1, 31
	strb	w1, [x3, 2]
	adrp	x1, .LANCHOR56
	ldr	x1, [x1, #:lo12:.LANCHOR56]
	strh	wzr, [x1, x0, lsl 1]
	ldp	x29, x30, [sp], 16
	ret
.L515:
	cmp	w4, 64
	bne	.L517
	ldr	x5, [x1, #:lo12:.LANCHOR46]
	ldrh	w4, [x5, 122]
	sub	w4, w4, #1
	strh	w4, [x5, 122]
	b	.L516
.L517:
	cmp	w4, 96
	bne	.L516
	ldr	x5, [x1, #:lo12:.LANCHOR46]
	ldrh	w4, [x5, 124]
	sub	w4, w4, #1
	strh	w4, [x5, 124]
	b	.L516
.L518:
	cbnz	w2, .L520
	ldr	x2, [x1, #:lo12:.LANCHOR46]
	ldrh	w1, [x2, 114]
	add	w1, w1, 1
	strh	w1, [x2, 114]
	b	.L519
.L520:
	ldr	x2, [x1, #:lo12:.LANCHOR46]
	ldrh	w1, [x2, 118]
	add	w1, w1, 1
	strh	w1, [x2, 118]
	b	.L519
	.size	ftl_free_sblk, .-ftl_free_sblk
	.section	.text.gc_free_src_blk,"ax",@progbits
	.align	2
	.global	gc_free_src_blk
	.type	gc_free_src_blk, %function
gc_free_src_blk:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR58
	stp	x23, x24, [sp, 48]
	adrp	x22, .LC15
	adrp	x23, .LANCHOR56
	add	x21, x21, :lo12:.LANCHOR58
	mov	x24, x23
	add	x22, x22, :lo12:.LC15
	stp	x19, x20, [sp, 16]
	mov	w20, 0
	stp	x25, x26, [sp, 64]
.L523:
	ldrh	w0, [x21, 56]
	cmp	w0, w20
	bhi	.L539
	strh	wzr, [x21, 56]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L539:
	add	x0, x21, x20, sxtw 1
	ldrh	w25, [x0, 58]
	ldr	x0, [x23, #:lo12:.LANCHOR56]
	mov	x19, x25
	lsl	x26, x25, 1
	ldrh	w2, [x0, x26]
	cbz	w2, .L524
	mov	w1, w25
	mov	x0, x22
	bl	printf
.L524:
	ldr	x0, [x24, #:lo12:.LANCHOR56]
	ldrh	w0, [x0, x26]
	cbnz	w0, .L525
	adrp	x0, .LANCHOR59
	ldr	x0, [x0, #:lo12:.LANCHOR59]
	add	x25, x0, x25, lsl 2
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L526
	ldrb	w2, [x25, 2]
	adrp	x0, .LC16
	mov	w1, w19
	add	x0, x0, :lo12:.LC16
	ubfx	x2, x2, 5, 3
	bl	printf
.L526:
	ldrb	w0, [x25, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L527
	tst	w0, 192
	bne	.L528
.L527:
	adrp	x1, .LANCHOR73
	adrp	x0, .LC0
	mov	w2, 753
	add	x1, x1, :lo12:.LANCHOR73
	add	x0, x0, :lo12:.LC0
	bl	printf
.L529:
	b	.L529
.L528:
	mov	w0, w19
	bl	ftl_free_sblk
	adrp	x0, .LANCHOR60
	ldr	x0, [x0, #:lo12:.LANCHOR60]
	ldrh	w2, [x0, 124]
	cbz	w2, .L530
	add	x3, x0, 392
	mov	w1, 0
.L532:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L531
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 392]
	strh	w2, [x0, 124]
.L530:
	ldrh	w2, [x0, 120]
	cbz	w2, .L533
	add	x3, x0, 136
	mov	w1, 0
.L535:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L534
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 136]
	strh	w2, [x0, 120]
.L533:
	ldrh	w2, [x0, 122]
	cbz	w2, .L536
	add	x3, x0, 264
	mov	w1, 0
.L538:
	ldrh	w4, [x3]
	cmp	w4, w19
	bne	.L537
	add	x1, x0, x1, sxtw 1
	mov	w3, -1
	sub	w2, w2, #1
	strh	w3, [x1, 264]
	strh	w2, [x0, 122]
.L536:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L523
.L531:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L532
	b	.L530
.L534:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L535
	b	.L533
.L537:
	add	w1, w1, 1
	add	x3, x3, 2
	cmp	w1, 64
	bne	.L538
	b	.L536
.L525:
	mov	w2, 0
	mov	w1, 1
	mov	w0, w19
	bl	gc_add_sblk
	b	.L536
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
	adrp	x1, .LANCHOR71
	stp	x19, x20, [sp, 16]
	mov	w19, 21
	adrp	x22, .LANCHOR75
	ldrh	w1, [x1, #:lo12:.LANCHOR71]
	sub	w1, w19, w1
	mov	w19, 1
	lsl	w19, w19, w1
	sub	w19, w19, #1
	and	w19, w19, w0
	asr	w20, w0, w1
	adrp	x0, .LANCHOR74
	sxth	w19, w19
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L563
	ldrh	w2, [x22, #:lo12:.LANCHOR75]
	cmp	w21, 0
	cset	w1, eq
	mov	w0, w20
	mul	w2, w2, w19
	bl	flash_erase_block_en
.L563:
	ldrh	w2, [x22, #:lo12:.LANCHOR75]
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
	adrp	x21, .LANCHOR59
	stp	x25, x26, [sp, 64]
	and	w25, w0, 65535
	ldr	x0, [x21, #:lo12:.LANCHOR59]
	mov	w22, w1
	stp	x19, x20, [sp, 16]
	ubfiz	x20, x25, 2, 16
	add	x0, x0, x20
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR76
	adrp	x23, .LANCHOR70
	add	x24, x24, :lo12:.LANCHOR76
	add	x23, x23, :lo12:.LANCHOR70
	ldrb	w26, [x0, 3]
	mov	w19, 0
	str	x27, [sp, 80]
	add	x27, x29, 96
.L569:
	ldrb	w0, [x24]
	cmp	w19, w0
	bge	.L576
	ldrb	w3, [x23]
	adrp	x0, .LANCHOR75
	mov	w1, 0
	ldrh	w4, [x0, #:lo12:.LANCHOR75]
	mov	w0, 0
	mul	w6, w19, w3
	mul	w5, w25, w3
	b	.L577
.L571:
	add	w2, w0, w6
	asr	w2, w26, w2
	tbnz	x2, 0, .L570
	and	w2, w0, 1
	add	w2, w2, w5
	mul	w2, w2, w4
	str	w2, [x27, w1, sxtw 2]
	add	w1, w1, 1
.L570:
	add	w0, w0, 1
.L577:
	cmp	w0, w3
	blt	.L571
	cmp	w1, 2
	bne	.L572
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L573
	ldp	w2, w3, [x29, 96]
	cmp	w22, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_duplane_block
.L573:
	ldp	w2, w3, [x29, 96]
	mov	w1, w22
	mov	w0, w19
	bl	flash_erase_duplane_block
.L574:
	add	w19, w19, 1
	b	.L569
.L572:
	cmp	w1, 1
	bne	.L574
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbz	w0, .L575
	ldr	w2, [x29, 96]
	cmp	w22, 0
	cset	w1, eq
	mov	w0, w19
	bl	flash_erase_block_en
.L575:
	ldr	w2, [x29, 96]
	mov	w1, w22
	mov	w0, w19
	bl	flash_erase_block_en
	b	.L574
.L576:
	adrp	x2, .LANCHOR46
	ldr	x3, [x21, #:lo12:.LANCHOR59]
	cbnz	w22, .L578
	ldrh	w1, [x3, x20]
	add	w0, w1, 1
	and	w0, w0, 2047
	bfi	w1, w0, 0, 11
	strh	w1, [x3, x20]
	ldr	x1, [x2, #:lo12:.LANCHOR46]
	ldr	w2, [x1, 84]
	add	w2, w2, 1
	str	w2, [x1, 84]
	ldrh	w2, [x1, 96]
	cmp	w2, w0
	bge	.L580
	strh	w0, [x1, 96]
.L580:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L578:
	ldr	w1, [x3, x20]
	ubfx	x0, x1, 11, 8
	add	w0, w0, 1
	and	w0, w0, 255
	bfi	w1, w0, 11, 8
	str	w1, [x3, x20]
	and	w0, w0, 65535
	ldr	x1, [x2, #:lo12:.LANCHOR46]
	ldr	w2, [x1, 80]
	add	w2, w2, 1
	str	w2, [x1, 80]
	ldrh	w2, [x1, 98]
	cmp	w2, w0
	bcs	.L580
	strh	w0, [x1, 98]
	b	.L580
	.size	ftl_erase_sblk, .-ftl_erase_sblk
	.section	.text.ftl_alloc_sys_blk,"ax",@progbits
	.align	2
	.global	ftl_alloc_sys_blk
	.type	ftl_alloc_sys_blk, %function
ftl_alloc_sys_blk:
	adrp	x0, .LANCHOR46
	ldr	x1, [x0, #:lo12:.LANCHOR46]
	ldrh	w0, [x1, 136]
	cmp	w0, 63
	bls	.L590
	strh	wzr, [x1, 136]
.L590:
	ldrh	w3, [x1, 112]
	cbnz	w3, .L591
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR77
	adrp	x0, .LC0
	mov	w2, 440
	add	x29, sp, 0
	add	x1, x1, :lo12:.LANCHOR77
	add	x0, x0, :lo12:.LC0
	bl	printf
.L592:
	b	.L592
.L591:
	mov	w6, 65535
.L597:
	ldrh	w2, [x1, 136]
.L593:
	mov	w4, w2
	cmp	w2, 63
	ble	.L594
	strh	wzr, [x1, 136]
	b	.L597
.L594:
	add	x5, x2, 1
	add	x0, x1, x5, lsl 1
	ldrh	w0, [x0, 158]
	cmp	w0, w6
	bne	.L598
	mov	x2, x5
	b	.L593
.L598:
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
	adrp	x1, .LANCHOR46
	and	w0, w0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR46]
	ldrh	w2, [x1, 138]
	cmp	w2, 63
	bls	.L603
	strh	wzr, [x1, 138]
.L603:
	ldrh	w3, [x1, 112]
	cmp	w3, 63
	bls	.L604
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR78
	adrp	x0, .LC0
	mov	w2, 464
	add	x29, sp, 0
	add	x1, x1, :lo12:.LANCHOR78
	add	x0, x0, :lo12:.LC0
	bl	printf
.L605:
	b	.L605
.L604:
	mov	w6, 65535
.L610:
	ldrh	w2, [x1, 138]
.L606:
	mov	w4, w2
	cmp	w2, 63
	ble	.L607
	strh	wzr, [x1, 138]
	b	.L610
.L607:
	add	x5, x2, 1
	add	x7, x1, x5, lsl 1
	ldrh	w7, [x7, 158]
	cmp	w7, w6
	bne	.L608
	add	x4, x1, x4, sxtw 1
	add	w3, w3, 1
	strh	w0, [x4, 160]
	strh	w2, [x1, 138]
	strh	w3, [x1, 112]
	ret
.L608:
	mov	x2, x5
	b	.L606
	.size	ftl_free_sys_blk, .-ftl_free_sys_blk
	.section	.text.ftl_info_data_recovery,"ax",@progbits
	.align	2
	.global	ftl_info_data_recovery
	.type	ftl_info_data_recovery, %function
ftl_info_data_recovery:
	ldrh	w1, [x0]
	mov	w2, 65535
	cmp	w1, w2
	beq	.L614
	adrp	x2, .LANCHOR59
	ubfiz	x1, x1, 2, 16
	ldr	x3, [x2, #:lo12:.LANCHOR59]
	add	x4, x3, x1
	ldrb	w2, [x4, 2]
	tst	w2, 224
	bne	.L614
	ldrb	w0, [x0, 4]
	bfi	w2, w0, 5, 3
	adrp	x0, .LANCHOR46
	strb	w2, [x4, 2]
	ldr	x5, [x0, #:lo12:.LANCHOR46]
	tbz	x2, 3, .L618
	ldrh	w2, [x5, 116]
	sub	w2, w2, #1
	strh	w2, [x5, 116]
.L619:
	ldrb	w2, [x4, 2]
	and	w2, w2, 224
	cmp	w2, 160
	bne	.L621
	ldr	w2, [x3, x1]
	ubfx	x4, x2, 11, 8
	add	w4, w4, 1
	bfi	w2, w4, 11, 8
	str	w2, [x3, x1]
	ldr	x1, [x0, #:lo12:.LANCHOR46]
	ldrh	w0, [x1, 120]
	sub	w0, w0, #1
	strh	w0, [x1, 120]
	ret
.L618:
	tst	w2, 24
	bne	.L620
	ldrh	w2, [x5, 114]
	sub	w2, w2, #1
	strh	w2, [x5, 114]
	b	.L619
.L620:
	ldrh	w2, [x5, 118]
	sub	w2, w2, #1
	strh	w2, [x5, 118]
	b	.L619
.L621:
	ldrh	w4, [x3, x1]
	cmp	w2, 64
	add	w5, w4, 1
	bfi	w4, w5, 0, 11
	strh	w4, [x3, x1]
	bne	.L622
	ldr	x1, [x0, #:lo12:.LANCHOR46]
	ldrh	w0, [x1, 122]
	sub	w0, w0, #1
	strh	w0, [x1, 122]
	ret
.L622:
	cmp	w2, 96
	bne	.L614
	ldr	x1, [x0, #:lo12:.LANCHOR46]
	ldrh	w0, [x1, 124]
	sub	w0, w0, #1
	strh	w0, [x1, 124]
.L614:
	ret
	.size	ftl_info_data_recovery, .-ftl_info_data_recovery
	.section	.text.ftl_get_ppa_from_index,"ax",@progbits
	.align	2
	.global	ftl_get_ppa_from_index
	.type	ftl_get_ppa_from_index, %function
ftl_get_ppa_from_index:
	and	w1, w0, 65535
	adrp	x0, .LANCHOR60
	adrp	x2, .LANCHOR69
	ldr	x3, [x0, #:lo12:.LANCHOR60]
	adrp	x0, .LANCHOR79
	ldrb	w2, [x2, #:lo12:.LANCHOR69]
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	mul	w0, w0, w2
	cmp	w1, w0
	bge	.L624
	add	x3, x3, 16
.L625:
	ldrb	w2, [x3, 9]
	sdiv	w4, w1, w2
	msub	w1, w4, w2, w1
	add	x1, x3, x1, uxth 1
	ldrh	w0, [x1, 16]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L626
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR80
	adrp	x0, .LC0
	mov	w2, 837
	add	x29, sp, 0
	add	x1, x1, :lo12:.LANCHOR80
	add	x0, x0, :lo12:.LC0
	bl	printf
.L627:
	b	.L627
.L624:
	sub	w1, w1, w0
	add	x3, x3, 48
	and	w1, w1, 65535
	b	.L625
.L626:
	adrp	x1, .LANCHOR75
	ldrh	w1, [x1, #:lo12:.LANCHOR75]
	madd	w0, w1, w0, w4
	ret
	.size	ftl_get_ppa_from_index, .-ftl_get_ppa_from_index
	.section	.text.lpa_hash_get_ppa,"ax",@progbits
	.align	2
	.global	lpa_hash_get_ppa
	.type	lpa_hash_get_ppa, %function
lpa_hash_get_ppa:
	and	x2, x0, 255
	adrp	x1, .LANCHOR81
	add	x1, x1, :lo12:.LANCHOR81
	mov	w3, 65535
	ldrh	w1, [x1, x2, lsl 1]
	adrp	x2, .LANCHOR82
	ldr	x4, [x2, #:lo12:.LANCHOR82]
	adrp	x2, .LANCHOR83
	ldr	x5, [x2, #:lo12:.LANCHOR83]
.L632:
	cmp	w1, w3
	bne	.L634
	mov	w0, -1
	ret
.L634:
	uxtw	x2, w1
	ldr	w6, [x4, x2, lsl 2]
	cmp	w0, w6
	bne	.L633
	mov	w0, w1
	b	ftl_get_ppa_from_index
.L633:
	ldrh	w1, [x5, x2, lsl 1]
	b	.L632
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
	bne	.L636
	adrp	x1, .LANCHOR84
	adrp	x0, .LC0
	mov	w2, 948
	add	x1, x1, :lo12:.LANCHOR84
	add	x0, x0, :lo12:.LC0
	bl	printf
.L637:
	b	.L637
.L636:
	adrp	x0, .LANCHOR79
	ldrh	w3, [x1, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	cmp	w3, w0
	bne	.L638
	adrp	x1, .LANCHOR84
	adrp	x0, .LC0
	mov	w2, 949
	add	x1, x1, :lo12:.LANCHOR84
	add	x0, x0, :lo12:.LC0
	bl	printf
.L639:
	b	.L639
.L638:
	ldrh	w4, [x1, 6]
	cbnz	w4, .L640
	adrp	x1, .LANCHOR84
	adrp	x0, .LC0
	mov	w2, 950
	add	x1, x1, :lo12:.LANCHOR84
	add	x0, x0, :lo12:.LC0
	bl	printf
.L641:
	b	.L641
.L640:
	ldrb	w0, [x1, 5]
	mov	w3, w2
	add	x0, x0, 8
	ldrh	w5, [x1, x0, lsl 1]
	adrp	x0, .LANCHOR69
	ldrb	w6, [x0, #:lo12:.LANCHOR69]
.L642:
	cmp	w5, w3
	ldrb	w2, [x1, 5]
	beq	.L644
	adrp	x0, .LANCHOR75
	sub	w4, w4, #1
	strh	w4, [x1, 6]
	add	w2, w2, 1
	ldrh	w0, [x0, #:lo12:.LANCHOR75]
	and	w2, w2, 255
	ldrh	w4, [x1, 10]
	cmp	w6, w2
	ldrh	w3, [x1, 2]
	add	w4, w4, 1
	strb	w2, [x1, 5]
	mul	w0, w0, w5
	strh	w4, [x1, 10]
	orr	w0, w0, w3
	bne	.L635
	add	w3, w3, 1
	strb	wzr, [x1, 5]
	strh	w3, [x1, 2]
.L635:
	ldp	x29, x30, [sp], 16
	ret
.L644:
	add	w2, w2, 1
	and	w2, w2, 255
	strb	w2, [x1, 5]
	cmp	w2, w6
	bne	.L643
	ldrh	w0, [x1, 2]
	strb	wzr, [x1, 5]
	add	w0, w0, 1
	strh	w0, [x1, 2]
.L643:
	ldrb	w0, [x1, 5]
	add	x0, x0, 8
	ldrh	w5, [x1, x0, lsl 1]
	b	.L642
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
	bcs	.L648
	adrp	x1, .LANCHOR85
	adrp	x0, .LC0
	mov	w2, 981
	add	x1, x1, :lo12:.LANCHOR85
	add	x0, x0, :lo12:.LC0
	bl	printf
.L649:
	b	.L649
.L648:
	adrp	x20, .LANCHOR46
	mov	w1, 0
	bl	ftl_erase_phy_blk
	ldr	x0, [x20, #:lo12:.LANCHOR46]
	ldrh	w0, [x0, 130]
	bl	ftl_free_sys_blk
	ldr	x0, [x20, #:lo12:.LANCHOR46]
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
	adrp	x2, .LANCHOR86
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR86]
	cmp	w1, 4
	bhi	.L652
	cbnz	w0, .L652
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR86]
	ret
.L652:
	adrp	x0, .LANCHOR54
	strh	wzr, [x3, #:lo12:.LANCHOR86]
	mov	w1, 0
	mov	w2, 0
	ldrh	w5, [x0, #:lo12:.LANCHOR54]
	adrp	x0, .LANCHOR56
	mov	w8, 65535
	ldr	x6, [x0, #:lo12:.LANCHOR56]
	adrp	x0, .LANCHOR59
	ldr	x7, [x0, #:lo12:.LANCHOR59]
	mov	x0, 0
.L654:
	cmp	w5, w0, uxth
	bhi	.L657
	adrp	x0, .LANCHOR60
	ldr	x0, [x0, #:lo12:.LANCHOR60]
	str	w2, [x0, 524]
	str	w1, [x0, 528]
	ret
.L657:
	ldrh	w3, [x6, x0, lsl 1]
	cmp	w3, w8
	beq	.L655
	add	x4, x7, x0, lsl 2
	ldrb	w4, [x4, 2]
	and	w4, w4, 224
	cmp	w4, 160
	bne	.L656
	add	w1, w1, w3
.L655:
	add	x0, x0, 1
	b	.L654
.L656:
	add	w2, w2, w3
	b	.L655
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
	adrp	x1, .LANCHOR56
	ubfiz	x0, x0, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR56]
	ldrh	w0, [x1, x0]
	cmp	w0, 0
	cset	w0, eq
	ret
	.size	ftl_vpn_update, .-ftl_vpn_update
	.section	.text.ftl_vpn_decrement,"ax",@progbits
	.align	2
	.global	ftl_vpn_decrement
	.type	ftl_vpn_decrement, %function
ftl_vpn_decrement:
	stp	x29, x30, [sp, -16]!
	and	w3, w0, 65535
	mov	w0, 65535
	cmp	w3, w0
	add	x29, sp, 0
	beq	.L661
	adrp	x0, .LANCHOR56
	ubfiz	x1, x3, 1, 16
	ldr	x2, [x0, #:lo12:.LANCHOR56]
	ldrh	w0, [x2, x1]
	cbnz	w0, .L662
	adrp	x0, .LC17
	mov	w2, 0
	mov	w1, w3
	add	x0, x0, :lo12:.LC17
	bl	printf
.L665:
	mov	w0, 0
	b	.L660
.L662:
	sub	w0, w0, #1
	strh	w0, [x2, x1]
.L661:
	adrp	x2, .LANCHOR87
	ldrh	w0, [x2, #:lo12:.LANCHOR87]
	cmp	w3, w0
	beq	.L665
	mov	w1, 65535
	cmp	w0, w1
	bne	.L664
	strh	w3, [x2, #:lo12:.LANCHOR87]
	b	.L665
.L664:
	bl	ftl_vpn_update
	cmp	w0, 0
	cset	w0, ne
	strh	w3, [x2, #:lo12:.LANCHOR87]
.L660:
	ldp	x29, x30, [sp], 16
	ret
	.size	ftl_vpn_decrement, .-ftl_vpn_decrement
	.section	.text.lpa_hash_update_ppa,"ax",@progbits
	.align	2
	.global	lpa_hash_update_ppa
	.type	lpa_hash_update_ppa, %function
lpa_hash_update_ppa:
	adrp	x3, .LANCHOR81
	and	x5, x0, 255
	add	x4, x3, :lo12:.LANCHOR81
	mov	w7, 65535
	and	w2, w2, 65535
	mov	w12, w7
	ldrh	w6, [x4, x5, lsl 1]
	adrp	x4, .LANCHOR82
	ldr	x8, [x4, #:lo12:.LANCHOR82]
	adrp	x4, .LANCHOR83
	ldr	x4, [x4, #:lo12:.LANCHOR83]
.L668:
	cmp	w6, w12
	beq	.L672
	uxtw	x11, w6
	lsl	x10, x11, 2
	add	x13, x8, x10
	ldr	w10, [x8, x10]
	cmp	w0, w10
	lsl	x10, x11, 1
	bne	.L669
	mov	w6, -1
	str	w6, [x13]
	cmp	w7, w12
	bne	.L670
	add	x6, x3, :lo12:.LANCHOR81
	ldrh	w7, [x4, x10]
	strh	w7, [x6, x5, lsl 1]
.L671:
	mov	w6, -1
	strh	w6, [x4, x11, lsl 1]
.L672:
	uxtw	x6, w2
	add	x3, x3, :lo12:.LANCHOR81
	cmn	w1, #1
	str	w0, [x8, x6, lsl 2]
	ldrh	w0, [x3, x5, lsl 1]
	strh	w2, [x3, x5, lsl 1]
	strh	w0, [x4, x6, lsl 1]
	beq	.L679
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LANCHOR71
	add	x29, sp, 0
	ldrh	w3, [x0, #:lo12:.LANCHOR71]
	mov	w0, 21
	sub	w2, w0, w3
	mov	w0, 1
	lsr	w1, w1, w3
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w1, w0, w1
	adrp	x0, .LANCHOR70
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	udiv	w0, w1, w0
	bl	ftl_vpn_decrement
	mov	w0, -1
	ldp	x29, x30, [sp], 16
	ret
.L670:
	ldrh	w6, [x4, x10]
	strh	w6, [x4, w7, uxtw 1]
	b	.L671
.L669:
	mov	w7, w6
	ldrh	w6, [x4, x10]
	b	.L668
.L679:
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
	adrp	x20, .LANCHOR88
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR36
	adrp	x22, .LANCHOR71
	add	x20, x20, :lo12:.LANCHOR88
	add	x19, x19, :lo12:.LANCHOR36
	add	x22, x22, :lo12:.LANCHOR71
	stp	x23, x24, [sp, 48]
	str	x25, [sp, 64]
.L683:
	ldrb	w0, [x20]
	cmp	w0, 255
	bne	.L689
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L689:
	ubfiz	x21, x0, 6, 8
	sbfiz	x0, x0, 6, 32
	add	x23, x19, x0
	add	x21, x19, x21
	ldrb	w0, [x19, x0]
	strb	w0, [x20]
	ldr	w0, [x23, 52]
	cmn	w0, #1
	bne	.L684
	ldp	w2, w3, [x23, 36]
	mov	w1, 21
	ldrh	w0, [x22]
	mov	w25, 1
	sub	w1, w1, w0
	lsr	w0, w3, w0
	lsl	w1, w25, w1
	sub	w1, w1, #1
	and	w1, w1, w0
	adrp	x0, .LANCHOR70
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	udiv	w1, w1, w0
	adrp	x0, .LC18
	add	x0, x0, :lo12:.LC18
	and	w24, w1, 65535
	mov	w1, w24
	bl	printf
	mov	w1, w25
	mov	w2, 0
	mov	w0, w24
	bl	gc_add_sblk
	adrp	x0, .LANCHOR60
	ldr	x0, [x0, #:lo12:.LANCHOR60]
	ldrh	w1, [x0, 16]
	cmp	w1, w24
	bne	.L685
	strh	wzr, [x0, 22]
.L686:
	mov	x0, x21
	bl	ftl_write_buf
	b	.L683
.L685:
	ldrh	w1, [x0, 48]
	cmp	w1, w24
	bne	.L686
	strh	wzr, [x0, 54]
	b	.L686
.L684:
	ldrh	w2, [x23, 48]
	ldr	w0, [x23, 36]
	ldr	w1, [x23, 44]
	bl	lpa_hash_update_ppa
	ldrb	w0, [x23, 2]
	tbz	x0, 2, .L688
	and	w0, w0, -3
	strb	w0, [x23, 2]
	b	.L683
.L688:
	mov	x0, x21
	bl	buf_free
	b	.L683
	.size	ftl_write_completed, .-ftl_write_completed
	.section	.text.ftl_mask_bad_block,"ax",@progbits
	.align	2
	.global	ftl_mask_bad_block
	.type	ftl_mask_bad_block, %function
ftl_mask_bad_block:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR71
	mov	w2, 21
	add	x29, sp, 0
	ldrh	w3, [x1, #:lo12:.LANCHOR71]
	stp	x19, x20, [sp, 16]
	ubfx	x20, x0, 21, 3
	sub	w1, w2, w3
	mov	w2, 1
	lsr	w0, w0, w3
	lsl	w2, w2, w1
	sub	w2, w2, #1
	and	w2, w2, w0
	adrp	x0, .LANCHOR70
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	udiv	w2, w2, w0
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	and	w19, w2, 255
	tbz	x0, 14, .L692
	adrp	x0, .LC19
	mov	w2, w19
	mov	w1, w20
	add	x0, x0, :lo12:.LC19
	bl	printf
.L692:
	adrp	x0, .LANCHOR54
	ldrh	w0, [x0, #:lo12:.LANCHOR54]
	cmp	w0, w19
	bls	.L691
	adrp	x0, .LANCHOR59
	mov	w1, 1
	lsl	w1, w1, w20
	ldr	x0, [x0, #:lo12:.LANCHOR59]
	add	x19, x0, x19, uxtb 2
	ldrb	w0, [x19, 3]
	orr	w1, w1, w0
	strb	w1, [x19, 3]
.L691:
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
	adrp	x1, .LANCHOR60
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	ldr	x7, [x1, #:lo12:.LANCHOR60]
	str	x19, [sp, 48]
	adrp	x19, .LANCHOR46
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	ldrh	w6, [x0, 120]
	ldrh	w5, [x0, 124]
	ldrh	w4, [x0, 122]
	ldrh	w3, [x0, 116]
	ldrh	w2, [x0, 118]
	ldrh	w1, [x0, 114]
	ldr	w0, [x7, 528]
	str	w0, [sp]
	adrp	x0, .LC20
	add	x0, x0, :lo12:.LC20
	ldr	w7, [x7, 524]
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	adrp	x1, .LANCHOR89
	ldrb	w3, [x1, #:lo12:.LANCHOR89]
	ldr	w4, [x0, 8]
	ldr	w5, [x0, 64]
	ldr	w1, [x0, 20]
	ldr	w2, [x0, 28]
	adrp	x0, .LC21
	add	x0, x0, :lo12:.LC21
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	ldr	w1, [x0, 52]
	ldr	w2, [x0, 60]
	ldr	w3, [x0, 16]
	adrp	x0, .LC22
	add	x0, x0, :lo12:.LC22
	lsr	w3, w3, 11
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR46]
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
	adrp	x0, .LC23
	add	x0, x0, :lo12:.LC23
	bl	printf
	ldr	x19, [sp, 48]
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 64
	ret
	.size	print_ftl_debug_info, .-print_ftl_debug_info
	.section	.text.sblk_init,"ax",@progbits
	.align	2
	.global	sblk_init
	.type	sblk_init, %function
sblk_init:
	adrp	x1, .LANCHOR90
	mov	w0, -1
	strb	w0, [x1, #:lo12:.LANCHOR90]
	adrp	x1, .LANCHOR88
	strb	w0, [x1, #:lo12:.LANCHOR88]
	adrp	x1, .LANCHOR51
	strb	w0, [x1, #:lo12:.LANCHOR51]
	adrp	x1, .LANCHOR62
	strb	w0, [x1, #:lo12:.LANCHOR62]
	mov	w0, 0
	ret
	.size	sblk_init, .-sblk_init
	.section	.text.dump_sblk_queue,"ax",@progbits
	.align	2
	.global	dump_sblk_queue
	.type	dump_sblk_queue, %function
dump_sblk_queue:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR90
	str	x21, [sp, 32]
	ldrb	w1, [x19, #:lo12:.LANCHOR90]
	bl	printf
	ldrb	w19, [x19, #:lo12:.LANCHOR90]
	cmp	w19, 255
	beq	.L701
	adrp	x1, .LANCHOR36
	ubfiz	x19, x19, 6, 8
	add	x1, x1, :lo12:.LANCHOR36
	adrp	x21, .LC25
	add	x19, x1, x19
	add	x21, x21, :lo12:.LC25
	mov	x20, x1
.L703:
	ldrb	w2, [x19, 58]
	mov	x0, x21
	ldrb	w1, [x19, 1]
	ldr	w3, [x19, 40]
	bl	printf
	ldrb	w19, [x19]
	cmp	w19, 255
	beq	.L701
	ubfiz	x19, x19, 6, 8
	add	x19, x20, x19
	b	.L703
.L701:
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
	adrp	x2, .LANCHOR90
	ldrb	w2, [x2, #:lo12:.LANCHOR90]
	cmp	w2, 255
	beq	.L720
	adrp	x3, .LANCHOR71
	adrp	x7, .LANCHOR36
	add	x7, x7, :lo12:.LANCHOR36
	adrp	x10, .L716
	ldrh	w8, [x3, #:lo12:.LANCHOR71]
	mov	w3, 21
	ubfx	x11, x0, 21, 3
	add	x10, x10, :lo12:.L716
	sub	w4, w3, w8
	mov	w3, 1
	mov	x12, x7
	lsl	w3, w3, w4
	adrp	x4, .LANCHOR70
	sub	w3, w3, #1
	ldrb	w6, [x4, #:lo12:.LANCHOR70]
	and	w3, w3, 65535
	asr	w4, w0, w8
	sub	w6, w6, #1
	and	w6, w6, 65535
	and	w4, w4, w6
	and	w4, w4, w3
.L719:
	add	x0, x7, x2, lsl 6
	ldr	w5, [x0, 40]
	ubfx	x13, x5, 21, 3
	cmp	w11, w13
	bne	.L713
	lsr	w5, w5, w8
	and	w5, w6, w5
	and	w5, w3, w5
	ldrb	w0, [x0, 58]
	cmp	w4, w5
	bne	.L714
	cmp	w1, 1
	bne	.L711
	cmp	w0, 6
	ccmp	w0, 8, 4, ne
	beq	.L713
	ret
.L714:
	cmp	w1, 3
	bhi	.L713
	ldrb	w5, [x10,w1,uxtw]
	adr	x13, .Lrtx716
	add	x5, x13, w5, sxtb #2
	br	x5
.Lrtx716:
	.section	.rodata.queue_lun_state,"a",@progbits
	.align	0
	.align	2
.L716:
	.byte	(.L715 - .Lrtx716) / 4
	.byte	(.L717 - .Lrtx716) / 4
	.byte	(.L718 - .Lrtx716) / 4
	.byte	(.L711 - .Lrtx716) / 4
	.section	.text.queue_lun_state
.L715:
	cmp	w0, 2
	beq	.L713
	ret
.L717:
	cmp	w0, 6
	ccmp	w0, 8, 4, ne
	beq	.L713
	ret
.L718:
	cmp	w0, 10
	bne	.L711
.L713:
	lsl	x2, x2, 6
	ldrb	w2, [x12, x2]
	cmp	w2, 255
	bne	.L719
.L720:
	mov	w0, 0
.L711:
	ret
	.size	queue_lun_state, .-queue_lun_state
	.section	.text.queue_remove_completed_req,"ax",@progbits
	.align	2
	.global	queue_remove_completed_req
	.type	queue_remove_completed_req, %function
queue_remove_completed_req:
	adrp	x6, .LANCHOR90
	ldrb	w2, [x6, #:lo12:.LANCHOR90]
	cmp	w2, 255
	beq	.L722
	adrp	x0, .LANCHOR36
	lsl	x4, x2, 6
	add	x5, x0, :lo12:.LANCHOR36
	add	x3, x5, x4
	ldrb	w1, [x3, 58]
	sub	w1, w1, #11
	and	w1, w1, 255
	cmp	w1, 1
	mov	x1, x0
	bhi	.L722
	ldrb	w0, [x5, x4]
	strb	w0, [x6, #:lo12:.LANCHOR90]
	mov	w0, -1
	strb	w0, [x5, x4]
	ldrb	w0, [x3, 59]
	cmp	w0, 1
	bne	.L724
	ldrh	w0, [x3, 50]
	cbnz	w0, .L725
	adrp	x0, .LANCHOR88
	ldrb	w3, [x0, #:lo12:.LANCHOR88]
	add	x0, x0, :lo12:.LANCHOR88
.L726:
	cmp	w3, 255
	bne	.L730
	add	x1, x1, :lo12:.LANCHOR36
	add	x1, x1, x2, lsl 6
	ldrb	w1, [x1, 1]
	strb	w1, [x0]
	ret
.L725:
	adrp	x0, .LANCHOR62
	ldrb	w3, [x0, #:lo12:.LANCHOR62]
	add	x0, x0, :lo12:.LANCHOR62
	b	.L726
.L724:
	cbnz	w0, .L722
	ldr	w0, [x3, 36]
	cmn	w0, #1
	beq	.L722
	adrp	x0, .LANCHOR51
	ldrb	w3, [x0, #:lo12:.LANCHOR51]
	add	x0, x0, :lo12:.LANCHOR51
	b	.L726
.L730:
	add	x0, x1, :lo12:.LANCHOR36
.L737:
	mov	w1, w3
	sbfiz	x3, x3, 6, 32
	ldrb	w3, [x0, x3]
	cmp	w3, 255
	bne	.L737
	add	x2, x0, x2, lsl 6
	sbfiz	x1, x1, 6, 32
	ldrb	w2, [x2, 1]
	strb	w2, [x0, x1]
	ret
.L722:
	ret
	.size	queue_remove_completed_req, .-queue_remove_completed_req
	.section	.text.pm_alloc_new_blk,"ax",@progbits
	.align	2
	.global	pm_alloc_new_blk
	.type	pm_alloc_new_blk, %function
pm_alloc_new_blk:
	stp	x29, x30, [sp, -64]!
	adrp	x2, .LANCHOR69
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR46
	stp	x21, x22, [sp, 32]
	ldr	x1, [x20, #:lo12:.LANCHOR46]
	ldrb	w2, [x2, #:lo12:.LANCHOR69]
	ldrh	w0, [x1, 690]
	str	x23, [sp, 48]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, 690]
	cmp	w2, w0
	bls	.L739
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x0, 672]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L740
.L739:
	adrp	x21, .LC26
	add	x21, x21, :lo12:.LC26
	adrp	x23, .LANCHOR59
.L754:
	mov	w0, 1
	bl	ftl_alloc_sblk
	mov	w1, 0
	and	w19, w0, 65535
	bl	ftl_erase_sblk
	add	x13, x20, :lo12:.LANCHOR46
	ldr	x1, [x20, #:lo12:.LANCHOR46]
	mov	w0, w19
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	tst	w0, 65535
	bne	.L741
	mov	w1, w19
	mov	x0, x21
	bl	printf
	ldr	x0, [x23, #:lo12:.LANCHOR59]
	add	x19, x0, x19, uxth 2
	ldrb	w0, [x19, 2]
	orr	w0, w0, -32
	strb	w0, [x19, 2]
	b	.L754
.L741:
	ldr	x1, [x13]
	adrp	x0, .LANCHOR91
	mov	w2, 1
	mov	w3, 65535
	str	w2, [x0, #:lo12:.LANCHOR91]
	add	x2, x1, 416
	mov	w0, 0
	strh	wzr, [x1, 690]
.L743:
	ldrh	w4, [x2]
	cmp	w4, w3
	beq	.L742
	add	w0, w0, 1
	add	x2, x2, 2
	cmp	w0, 128
	bne	.L743
	adrp	x1, .LANCHOR92
	adrp	x0, .LC0
	mov	w2, 188
	add	x1, x1, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LC0
	bl	printf
.L745:
	b	.L745
.L746:
	adrp	x1, .LANCHOR71
	mov	w2, 21
	strh	wzr, [x0, 696]
	ldrh	w1, [x1, #:lo12:.LANCHOR71]
	strh	w3, [x0, 692]
	sub	w2, w2, w1
	asr	w4, w3, w2
	strh	w4, [x0, 694]
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L750
	mov	w0, 1
	and	w4, w4, 65535
	lsl	w2, w0, w2
	mov	w1, w3
	adrp	x0, .LC27
	sub	w2, w2, #1
	add	x0, x0, :lo12:.LC27
	bl	printf
.L750:
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L742:
	add	x0, x1, x0, sxtw 1
	strh	w19, [x0, 416]
	ldrh	w0, [x1, 688]
	add	w0, w0, 1
	strh	w0, [x1, 688]
.L740:
	ldr	x0, [x20, #:lo12:.LANCHOR46]
	ldrh	w1, [x0, 690]
	add	x1, x1, 336
	ldrh	w3, [x0, x1, lsl 1]
	mov	w1, 65533
	sub	w2, w3, #1
	cmp	w1, w2, uxth
	bcs	.L746
	adrp	x1, .LANCHOR92
	adrp	x0, .LC0
	mov	w2, 193
	add	x1, x1, :lo12:.LANCHOR92
	add	x0, x0, :lo12:.LC0
	bl	printf
.L747:
	b	.L747
	.size	pm_alloc_new_blk, .-pm_alloc_new_blk
	.section	.text.pm_select_ram_region,"ax",@progbits
	.align	2
	.global	pm_select_ram_region
	.type	pm_select_ram_region, %function
pm_select_ram_region:
	adrp	x1, .LANCHOR93
	add	x1, x1, :lo12:.LANCHOR93
	mov	x2, 0
	mov	w3, 65535
.L759:
	lsl	x4, x2, 4
	and	w0, w2, 65535
	ldrh	w4, [x4, x1]
	cmp	w4, w3
	beq	.L758
	add	x2, x2, 1
	cmp	x2, 32
	bne	.L759
	add	x1, x1, 2
	mov	w0, w2
	mov	x3, x1
	mov	w5, 32768
	mov	w2, 0
.L761:
	ldrh	w4, [x3]
	tbnz	x4, 15, .L760
	cmp	w4, w5
	bcs	.L760
	mov	w5, w4
	mov	w0, w2
.L760:
	add	w2, w2, 1
	add	x3, x3, 16
	and	w2, w2, 65535
	cmp	w2, 32
	bne	.L761
	cmp	w0, 32
	bne	.L758
	adrp	x2, .LANCHOR94
	mov	w3, -1
	ldrb	w4, [x2, #:lo12:.LANCHOR94]
	mov	w2, 0
.L763:
	ldrh	w6, [x1]
	cmp	w6, w3
	bcs	.L762
	ldrh	w5, [x1, -2]
	cmp	w5, w4
	csel	w3, w3, w6, eq
	csel	w0, w0, w2, eq
.L762:
	add	w2, w2, 1
	add	x1, x1, 16
	and	w2, w2, 65535
	cmp	w2, 32
	bne	.L763
	cmp	w0, 32
	bne	.L758
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR95
	adrp	x0, .LC0
	mov	w2, 289
	add	x29, sp, 0
	add	x1, x1, :lo12:.LANCHOR95
	add	x0, x0, :lo12:.LC0
	bl	printf
.L764:
	b	.L764
.L758:
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
	adrp	x19, .LANCHOR14
	cbnz	w0, .L773
	add	x1, x19, :lo12:.LANCHOR14
	mov	x0, 0
.L774:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 256
	bne	.L774
.L780:
	adrp	x20, .LANCHOR96
	add	x20, x20, :lo12:.LANCHOR96
	mov	w2, 1024
	mov	w1, 255
	mov	x0, x20
	add	x19, x19, :lo12:.LANCHOR14
	bl	ftl_memset
	mov	x0, 0
.L775:
	ldrh	w1, [x0, x19]
	add	x0, x0, 2
	cmp	x0, 512
	strh	w1, [x20, w1, sxtw 1]
	bne	.L775
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L773:
	cmp	w0, 1
	bne	.L776
	add	x3, x19, :lo12:.LANCHOR14
	mov	x1, 0
.L779:
	and	w0, w1, 65535
	cmp	x1, 3
	bls	.L777
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 2
	sub	w0, w2, w0
	and	w0, w0, 65535
.L777:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L779
	b	.L780
.L776:
	cmp	w0, 2
	bne	.L781
	add	x3, x19, :lo12:.LANCHOR14
	mov	w1, 65535
	mov	x0, 0
.L783:
	cmp	x0, 2
	and	w2, w0, 65535
	csel	w2, w2, w1, cc
	strh	w2, [x3, x0, lsl 1]
	add	w1, w1, 2
	add	x0, x0, 1
	and	w1, w1, 65535
	cmp	x0, 256
	bne	.L783
	b	.L780
.L781:
	cmp	w0, 3
	bne	.L784
	add	x3, x19, :lo12:.LANCHOR14
	mov	x1, 0
.L787:
	and	w0, w1, 65535
	cmp	x1, 5
	bls	.L785
	ubfiz	w2, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 4
	sub	w0, w2, w0
	and	w0, w0, 65535
.L785:
	strh	w0, [x3, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L787
	b	.L780
.L784:
	cmp	w0, 4
	bne	.L788
	add	x1, x19, :lo12:.LANCHOR14
	mov	w2, 1
	add	x1, x1, 16
	strh	wzr, [x19, #:lo12:.LANCHOR14]
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
.L790:
	and	w3, w0, 1
	ubfiz	w2, w0, 1, 15
	add	w3, w3, 6
	add	w0, w0, 1
	sub	w2, w2, w3
	strh	w2, [x1], 2
	and	w0, w0, 65535
	cmp	w0, 256
	bne	.L790
	b	.L780
.L788:
	cmp	w0, 5
	bne	.L791
	add	x1, x19, :lo12:.LANCHOR14
	mov	x0, 0
.L792:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 16
	bne	.L792
	add	x1, x1, 32
.L793:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 496
	bne	.L793
	b	.L780
.L791:
	cmp	w0, 8
	bne	.L780
	add	x1, x19, :lo12:.LANCHOR14
	mov	x0, 0
.L794:
	strh	w0, [x0, x1]
	add	x0, x0, 2
	cmp	x0, 512
	bne	.L794
	b	.L780
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
	adrp	x23, .LANCHOR19
	add	x19, x23, :lo12:.LANCHOR19
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR13
	adrp	x26, .LANCHOR8
	adrp	x22, .LANCHOR10
	ldrh	w0, [x19, 26]
	add	x21, x22, :lo12:.LANCHOR10
	ldrb	w1, [x19, 12]
	adrp	x24, .LANCHOR98
	strh	w0, [x25, #:lo12:.LANCHOR13]
	add	x20, x24, :lo12:.LANCHOR98
	ldrh	w0, [x19, 10]
	add	x19, x19, 1
	strb	wzr, [x26, #:lo12:.LANCHOR8]
	sdiv	w0, w0, w1
	adrp	x1, .LANCHOR97
	strh	w0, [x1, #:lo12:.LANCHOR97]
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	mov	w2, 32
	mov	w1, 0
	mov	x0, x20
	bl	ftl_memset
	ldrb	w13, [x23, #:lo12:.LANCHOR19]
	mov	x7, x23
	adrp	x14, .LANCHOR26
	add	x11, x26, :lo12:.LANCHOR8
	add	x23, x14, :lo12:.LANCHOR26
	mov	x8, 0
.L811:
	mov	w2, w13
	add	x1, x23, x8, lsl 3
	mov	x0, x19
	bl	flash_mem_cmp8
	cbnz	w0, .L810
	ldrb	w1, [x11]
	add	w0, w1, 1
	strb	w0, [x11]
	str	wzr, [x20, x1, lsl 2]
	strb	w8, [x21, x1]
.L810:
	add	x8, x8, 1
	cmp	x8, 4
	bne	.L811
	add	x0, x7, :lo12:.LANCHOR19
	ldrb	w1, [x0, 8]
	cmp	w1, 2
	beq	.L812
.L816:
	add	x7, x7, :lo12:.LANCHOR19
	ldrb	w0, [x26, #:lo12:.LANCHOR8]
	ldp	x19, x20, [sp, 16]
	ldrb	w1, [x7, 13]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	mul	w0, w0, w1
	ldrh	w1, [x7, 14]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	mul	w0, w0, w1
	adrp	x1, .LANCHOR99
	strh	w0, [x1, #:lo12:.LANCHOR99]
	ret
.L812:
	ldrh	w1, [x25, #:lo12:.LANCHOR13]
	add	x14, x14, :lo12:.LANCHOR26
	ldrb	w11, [x0, 13]
	add	x8, x0, 1
	ldrb	w20, [x0, 23]
	add	x19, x26, :lo12:.LANCHOR8
	add	x15, x24, :lo12:.LANCHOR98
	add	x22, x22, :lo12:.LANCHOR10
	mov	x12, 0
	mul	w11, w11, w1
	ldrh	w1, [x0, 14]
	and	w1, w1, 65280
	mul	w11, w11, w1
	lsl	w21, w11, 1
.L815:
	mov	w2, w13
	add	x1, x14, x12, lsl 3
	mov	x0, x8
	bl	flash_mem_cmp8
	cbnz	w0, .L813
	ldrb	w1, [x19]
	cmp	w20, 0
	csel	w2, w11, w21, eq
	add	w0, w1, 1
	strb	w0, [x19]
	str	w2, [x15, x1, lsl 2]
	strb	w12, [x22, x1]
.L813:
	add	x12, x12, 1
	cmp	x12, 4
	bne	.L815
	b	.L816
	.size	flash_die_info_init, .-flash_die_info_init
	.section	.text.FlashReadFacBbtData,"ax",@progbits
	.align	2
	.global	FlashReadFacBbtData
	.type	FlashReadFacBbtData, %function
FlashReadFacBbtData:
	stp	x29, x30, [sp, -16]!
	lsr	w2, w2, 3
	mov	w1, 0
	add	x29, sp, 0
	bl	ftl_memset
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FlashReadFacBbtData, .-FlashReadFacBbtData
	.section	.text.lpa_hash_init,"ax",@progbits
	.align	2
	.global	lpa_hash_init
	.type	lpa_hash_init, %function
lpa_hash_init:
	stp	x29, x30, [sp, -16]!
	mov	w2, 512
	mov	w1, 255
	adrp	x0, .LANCHOR81
	add	x29, sp, 0
	add	x0, x0, :lo12:.LANCHOR81
	bl	ftl_memset
	adrp	x0, .LANCHOR79
	mov	w1, 255
	ldp	x29, x30, [sp], 16
	ldrh	w2, [x0, #:lo12:.LANCHOR79]
	adrp	x0, .LANCHOR69
	ldrb	w0, [x0, #:lo12:.LANCHOR69]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR83
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	lsl	w2, w2, 2
	b	ftl_memset
	.size	lpa_hash_init, .-lpa_hash_init
	.section	.text.lpa_rebuild_hash,"ax",@progbits
	.align	2
	.global	lpa_rebuild_hash
	.type	lpa_rebuild_hash, %function
lpa_rebuild_hash:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR22
	add	x29, sp, 0
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	tbz	x0, 12, .L828
	adrp	x1, .LANCHOR100
	adrp	x0, .LC28
	mov	w3, 0
	mov	w2, 190
	add	x1, x1, :lo12:.LANCHOR100
	add	x0, x0, :lo12:.LC28
	bl	printf
.L828:
	adrp	x20, .LANCHOR79
	adrp	x22, .LANCHOR69
	adrp	x19, .LANCHOR81
	add	x19, x19, :lo12:.LANCHOR81
	mov	w2, 512
	mov	w1, 255
	mov	x0, x19
	bl	ftl_memset
	ldrh	w2, [x20, #:lo12:.LANCHOR79]
	adrp	x21, .LANCHOR83
	ldrb	w0, [x22, #:lo12:.LANCHOR69]
	mov	w1, 255
	add	x20, x20, :lo12:.LANCHOR79
	mul	w2, w2, w0
	ldr	x0, [x21, #:lo12:.LANCHOR83]
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR82
	ldrb	w3, [x22, #:lo12:.LANCHOR69]
	ldr	x5, [x21, #:lo12:.LANCHOR83]
	mov	w1, 0
	ldr	x4, [x0, #:lo12:.LANCHOR82]
.L829:
	ldrh	w0, [x20]
	mul	w0, w0, w3
	cmp	w1, w0, lsl 1
	blt	.L831
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L831:
	uxtw	x2, w1
	ldr	w0, [x4, x2, lsl 2]
	cmn	w0, #1
	beq	.L830
	and	x0, x0, 255
	ldrh	w6, [x19, x0, lsl 1]
	strh	w1, [x19, x0, lsl 1]
	strh	w6, [x5, x2, lsl 1]
.L830:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L829
	.size	lpa_rebuild_hash, .-lpa_rebuild_hash
	.section	.text.ftl_open_sblk_init,"ax",@progbits
	.align	2
	.global	ftl_open_sblk_init
	.type	ftl_open_sblk_init, %function
ftl_open_sblk_init:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR69
	stp	x21, x22, [sp, 32]
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	adrp	x21, .LC26
	adrp	x23, .LANCHOR79
	mov	w22, w1
	add	x23, x23, :lo12:.LANCHOR79
	add	x20, x20, :lo12:.LANCHOR69
	add	x21, x21, :lo12:.LC26
	stp	x25, x26, [sp, 64]
.L840:
.L843:
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
	beq	.L844
	ldrb	w0, [x20]
	mul	w0, w1, w0
	and	w0, w0, 65535
.L841:
	ldrb	w2, [x20]
	adrp	x26, .LANCHOR56
	strh	w0, [x19, 12]
	ubfiz	x25, x24, 1, 16
	mul	w2, w2, w1
	adrp	x1, .LANCHOR82
	ldr	x3, [x1, #:lo12:.LANCHOR82]
	mov	w1, 255
	lsl	w2, w2, 2
	add	x0, x3, x0, uxth 2
	bl	ftl_memset
	ldr	x0, [x26, #:lo12:.LANCHOR56]
	ldrh	w1, [x19, 6]
	strh	w1, [x0, x25]
	ldrb	w0, [x19, 9]
	cbnz	w0, .L839
	mov	w1, w24
	mov	x0, x21
	bl	printf
	ldr	x0, [x26, #:lo12:.LANCHOR56]
	mov	w1, -1
	strh	w1, [x0, x25]
	mov	w0, 7
	strb	w0, [x19, 4]
	b	.L843
.L844:
	mov	w0, 0
	b	.L841
.L839:
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
	adrp	x20, .LANCHOR101
	stp	x21, x22, [sp, 32]
	ldrh	w0, [x20, #:lo12:.LANCHOR101]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w0, 128
	stp	x27, x28, [sp, 80]
	bls	.L847
	adrp	x1, .LANCHOR102
	adrp	x0, .LC0
	mov	w2, 74
	add	x1, x1, :lo12:.LANCHOR102
	add	x0, x0, :lo12:.LC0
	bl	printf
.L848:
	b	.L848
.L847:
	add	x23, x29, 112
	mov	w2, 256
	mov	w1, 0
	mov	x0, x23
	bl	ftl_memset
	adrp	x24, .LANCHOR46
	adrp	x0, .LANCHOR71
	mov	w2, 21
	ldr	x5, [x24, #:lo12:.LANCHOR46]
	ldrh	w8, [x0, #:lo12:.LANCHOR71]
	ldrh	w11, [x20, #:lo12:.LANCHOR101]
	add	x4, x5, 704
	sub	w0, w2, w8
	mov	w2, 1
	ldrh	w1, [x5, 698]
	lsl	w2, w2, w0
	adrp	x0, .LANCHOR70
	add	x1, x1, 176
	sub	w2, w2, #1
	ldrb	w10, [x0, #:lo12:.LANCHOR70]
	add	x1, x5, x1, lsl 2
	mov	x27, x0
.L849:
	cmp	x4, x1
	bne	.L853
	adrp	x1, .LANCHOR69
	adrp	x0, .LANCHOR79
	add	x20, x20, :lo12:.LANCHOR101
	add	x27, x27, :lo12:.LANCHOR70
	ldrh	w2, [x0, #:lo12:.LANCHOR79]
	add	x26, x1, :lo12:.LANCHOR69
	ldrb	w21, [x1, #:lo12:.LANCHOR69]
	add	x25, x0, :lo12:.LANCHOR79
	mov	w28, 0
	mov	w19, 0
	mul	w21, w21, w2
	mov	w2, 65535
	and	w21, w21, 65535
.L854:
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L859
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 368
	ret
.L853:
	ldr	w0, [x4]
	add	x6, x5, 416
	mov	x3, 0
	lsr	w0, w0, w8
	and	w0, w0, w2
	udiv	w0, w0, w10
	and	w0, w0, 65535
.L850:
	cmp	w11, w3, uxth
	bhi	.L852
	add	x4, x4, 4
	b	.L849
.L852:
	ldrh	w7, [x6]
	cmp	w7, w0
	bne	.L851
	ldrh	w7, [x23, x3, lsl 1]
	add	w7, w7, 1
	strh	w7, [x23, x3, lsl 1]
.L851:
	add	x3, x3, 1
	add	x6, x6, 2
	b	.L850
.L859:
	ldr	x1, [x24, #:lo12:.LANCHOR46]
	sxtw	x22, w19
	add	x0, x22, 208
	ldrb	w3, [x27]
	ldrh	w0, [x1, x0, lsl 1]
	ldrh	w1, [x1, 692]
	sdiv	w1, w1, w3
	cmp	w1, w0
	bne	.L855
	ldrb	w1, [x26]
	ldrh	w3, [x25]
	mul	w1, w1, w3
	strh	w1, [x23, x22, lsl 1]
.L855:
	ldrh	w1, [x23, x22, lsl 1]
	cmp	w21, w1
	bls	.L856
	cbnz	w1, .L860
.L858:
	cmp	w0, w2
	beq	.L857
	str	w2, [x29, 108]
	bl	ftl_free_sblk
	ldr	x0, [x24, #:lo12:.LANCHOR46]
	add	x22, x22, 208
	mov	w1, -1
	ldr	w2, [x29, 108]
	strh	w1, [x0, x22, lsl 1]
	ldrh	w1, [x0, 688]
	sub	w1, w1, #1
	strh	w1, [x0, 688]
	b	.L857
.L856:
	cbz	w1, .L858
.L857:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L854
.L860:
	mov	w28, w19
	mov	w21, w1
	b	.L857
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
	adrp	x19, .LANCHOR5
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	mov	w1, 21321
	movk	w1, 0x5359, lsl 16
	mov	w2, 32
	add	x0, x0, 80
	str	w1, [x0, -80]
	mov	w1, 2032
	str	w1, [x0, -72]
	mov	w1, 1
	strh	w1, [x0, -64]
	adrp	x1, .LANCHOR103
	add	x1, x1, :lo12:.LANCHOR103
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR5]
	mov	w2, 32
	ldr	x19, [sp, 16]
	adrp	x1, .LANCHOR19
	ldp	x29, x30, [sp], 32
	add	x1, x1, :lo12:.LANCHOR19
	add	x0, x0, 48
	b	ftl_memcpy
	.size	flash_into_data_init, .-flash_into_data_init
	.section	.text.ftl_memcpy32,"ax",@progbits
	.align	2
	.global	ftl_memcpy32
	.type	ftl_memcpy32, %function
ftl_memcpy32:
	mov	x3, 0
.L866:
	cmp	w2, w3
	bhi	.L867
	ret
.L867:
	ldr	w4, [x1, x3, lsl 2]
	str	w4, [x0, x3, lsl 2]
	add	x3, x3, 1
	b	.L866
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
	adrp	x1, .LANCHOR7
	mov	w2, 6
	add	x29, sp, 0
	strb	w2, [x1, #:lo12:.LANCHOR7]
	adrp	x2, .LANCHOR6
	str	wzr, [x29, 24]
	str	x0, [x2, #:lo12:.LANCHOR6]
	mov	w2, 12336
	ldr	w3, [x0, 352]
	movk	w2, 0x5638, lsl 16
	cmp	w3, w2
	bne	.L872
	mov	w2, 8
	strb	w2, [x1, #:lo12:.LANCHOR7]
.L872:
	ldr	w3, [x0, 128]
	mov	w2, 12336
	movk	w2, 0x5639, lsl 16
	cmp	w3, w2
	bne	.L873
	mov	w2, 9
	strb	w2, [x1, #:lo12:.LANCHOR7]
.L873:
	ldrb	w1, [x1, #:lo12:.LANCHOR7]
	cmp	w1, 9
	adrp	x1, .LANCHOR28
	bne	.L874
	mov	w2, 1
	strb	w2, [x1, #:lo12:.LANCHOR28]
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
.L875:
	adrp	x0, .LANCHOR29
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR29]
	adrp	x0, .LANCHOR31
	strh	wzr, [x0, #:lo12:.LANCHOR31]
	adrp	x0, .LANCHOR27
	strb	wzr, [x0, #:lo12:.LANCHOR27]
	ldp	x29, x30, [sp], 32
	ret
.L874:
	strb	wzr, [x1, #:lo12:.LANCHOR28]
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
	adrp	x1, .LANCHOR30
	str	x0, [x1, #:lo12:.LANCHOR30]
	b	.L875
	.size	nandc_init, .-nandc_init
	.section	.text.buf_init,"ax",@progbits
	.align	2
	.global	buf_init
	.type	buf_init, %function
buf_init:
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR36
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	x19, x0, :lo12:.LANCHOR36
	stp	x21, x22, [sp, 32]
	mov	x20, x0
	adrp	x22, .LANCHOR45
	add	x22, x22, :lo12:.LANCHOR45
	mov	w21, 0
.L878:
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
	bne	.L878
	add	x0, x20, :lo12:.LANCHOR36
	mov	w1, -1
	strb	w1, [x0, 1984]
	adrp	x0, .LANCHOR37
	strb	wzr, [x0, #:lo12:.LANCHOR37]
	adrp	x0, .LANCHOR38
	ldp	x19, x20, [sp, 16]
	strb	w21, [x0, #:lo12:.LANCHOR38]
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
	adrp	x0, .LANCHOR67
	mov	w2, 328
	mov	w1, 0
	add	x29, sp, 0
	strb	wzr, [x0, #:lo12:.LANCHOR67]
	adrp	x0, .LANCHOR104
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR58
	add	x19, x20, :lo12:.LANCHOR58
	strb	wzr, [x0, #:lo12:.LANCHOR104]
	mov	x0, x19
	bl	ftl_memset
	mov	w0, -1
	strh	w0, [x20, #:lo12:.LANCHOR58]
	adrp	x0, .LANCHOR79
	str	xzr, [x19, 8]
	adrp	x4, .LANCHOR105
	adrp	x20, .LANCHOR68
	ldrh	w1, [x0, #:lo12:.LANCHOR79]
	lsr	w3, w1, 1
	lsr	w0, w1, 2
	strh	w3, [x19, 38]
	strh	w0, [x19, 36]
	adrp	x19, .LANCHOR69
	ldrb	w2, [x19, #:lo12:.LANCHOR69]
	mul	w1, w1, w2
	sub	w1, w1, #32
	strh	w1, [x4, #:lo12:.LANCHOR105]
	adrp	x1, .LANCHOR106
	strh	w3, [x1, #:lo12:.LANCHOR106]
	adrp	x1, .LANCHOR57
	strh	w0, [x1, #:lo12:.LANCHOR57]
	ldrh	w0, [x20, #:lo12:.LANCHOR68]
	mul	w0, w0, w2
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR107
	str	x0, [x1, #:lo12:.LANCHOR107]
	ldrb	w1, [x19, #:lo12:.LANCHOR69]
	ldrh	w0, [x20, #:lo12:.LANCHOR68]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR108
	str	x0, [x1, #:lo12:.LANCHOR108]
	ldrh	w1, [x20, #:lo12:.LANCHOR68]
	ldrb	w0, [x19, #:lo12:.LANCHOR69]
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR65
	str	x0, [x1, #:lo12:.LANCHOR65]
	ldrb	w1, [x19, #:lo12:.LANCHOR69]
	ldrh	w0, [x20, #:lo12:.LANCHOR68]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR61
	str	x0, [x1, #:lo12:.LANCHOR61]
	ldrb	w1, [x19, #:lo12:.LANCHOR69]
	ldrh	w0, [x20, #:lo12:.LANCHOR68]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR109
	ldp	x19, x20, [sp, 16]
	str	x0, [x1, #:lo12:.LANCHOR109]
	ldp	x29, x30, [sp], 32
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
.L885:
	cmp	w1, w3
	bhi	.L886
	ret
.L886:
	lsr	w2, w0, 2
	ldrb	w5, [x4, x3]
	add	w2, w2, w0, lsl 5
	add	x3, x3, 1
	add	w2, w2, w5
	eor	w0, w0, w2
	b	.L885
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
	b	FlashDeInit
	.size	rk_nand_de_init, .-rk_nand_de_init
	.section	.text.rk_ftl_get_capacity,"ax",@progbits
	.align	2
	.global	rk_ftl_get_capacity
	.type	rk_ftl_get_capacity, %function
rk_ftl_get_capacity:
	adrp	x0, .LANCHOR52
	ldr	w0, [x0, #:lo12:.LANCHOR52]
	ret
	.size	rk_ftl_get_capacity, .-rk_ftl_get_capacity
	.section	.text.rknand_print_hex,"ax",@progbits
	.align	2
	.global	rknand_print_hex
	.type	rknand_print_hex, %function
rknand_print_hex:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LC30
	stp	x23, x24, [sp, 48]
	mov	x22, x1
	stp	x25, x26, [sp, 64]
	adrp	x23, .LC29
	mov	x26, x0
	mov	w24, w2
	uxtw	x25, w3
	add	x23, x23, :lo12:.LC29
	add	x21, x21, :lo12:.LC30
	stp	x19, x20, [sp, 16]
	str	x27, [sp, 80]
	mov	x19, 0
	mov	w20, 0
	adrp	x27, .LC31
.L892:
	cmp	x25, x19
	bne	.L898
	ldp	x19, x20, [sp, 16]
	adrp	x1, .LC31
	ldp	x21, x22, [sp, 32]
	add	x1, x1, :lo12:.LC31
	ldp	x23, x24, [sp, 48]
	adrp	x0, .LC32
	ldp	x25, x26, [sp, 64]
	add	x0, x0, :lo12:.LC32
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L898:
	cbnz	w20, .L893
	mov	w2, w19
	mov	x1, x26
	mov	x0, x23
	bl	printf
.L893:
	cmp	w24, 4
	bne	.L894
	ldr	w1, [x22, x19, lsl 2]
.L900:
	mov	x0, x21
	add	w20, w20, 1
	bl	printf
	cmp	w20, 15
	bls	.L897
	mov	w20, 0
	add	x1, x27, :lo12:.LC31
	adrp	x0, .LC32
	add	x0, x0, :lo12:.LC32
	bl	printf
.L897:
	add	x19, x19, 1
	b	.L892
.L894:
	cmp	w24, 2
	bne	.L896
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L900
.L896:
	ldrb	w1, [x22, x19]
	b	.L900
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
	adrp	x0, .LANCHOR5
	stp	x19, x20, [sp, 16]
	ldr	x28, [x0, #:lo12:.LANCHOR5]
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
	bne	.L902
	mov	w0, -89
	strb	w0, [x28, 128]
	adrp	x0, .LANCHOR110+17
	mov	w1, -9
	strb	w1, [x0, #:lo12:.LANCHOR110+17]
.L957:
	mov	w0, 7
	b	.L992
.L902:
	ldr	w3, [x29, 140]
	cmp	w3, 3
	bne	.L904
	mov	x6, 0
.L905:
	sub	w0, w6, #80
	strb	w0, [x22, x6]
	add	x6, x6, 1
	cmp	x6, 8
	bne	.L905
	stp	w6, w6, [x29, 132]
.L903:
	ldr	w0, [x29, 140]
	sub	w0, w0, #1
	cmp	w0, 1
	bhi	.L910
	adrp	x7, .LANCHOR8
	adrp	x11, .LANCHOR10
	add	x24, x7, :lo12:.LANCHOR8
	add	x25, x11, :lo12:.LANCHOR10
	mov	w20, 0
	mov	w26, 55
.L911:
	ldrb	w0, [x24]
	cmp	w0, w20
	bhi	.L917
.L918:
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
.L904:
	ldr	w3, [x29, 140]
	cmp	w3, 4
	bne	.L906
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
.L993:
	str	w0, [x29, 136]
	b	.L903
.L906:
	ldr	w0, [x29, 140]
	cmp	w0, 5
	bne	.L907
	mov	w0, 56
	strb	w0, [x28, 128]
	mov	w0, 57
	strb	w0, [x28, 129]
	mov	w0, 58
	strb	w0, [x28, 130]
	mov	w0, 59
	strb	w0, [x28, 131]
	mov	w0, 8
.L992:
	str	w0, [x29, 132]
	mov	w0, 4
	b	.L993
.L907:
	ldr	w0, [x29, 140]
	cmp	w0, 6
	bne	.L908
	mov	w0, 14
	strb	w0, [x28, 128]
	mov	w0, 15
	strb	w0, [x28, 129]
	mov	w0, 16
	strb	w0, [x28, 130]
	mov	w0, 17
	strb	w0, [x28, 131]
	mov	w0, 12
	b	.L992
.L908:
	ldr	w0, [x29, 140]
	cmp	w0, 7
	bne	.L957
	mov	x0, 0
.L909:
	sub	w1, w0, #80
	strb	w1, [x22, x0]
	add	x0, x0, 1
	cmp	x0, 8
	bne	.L909
	mov	w0, -44
	strb	w0, [x28, 136]
	mov	w0, -43
	strb	w0, [x28, 137]
	mov	w0, 12
	str	w0, [x29, 132]
	mov	w0, 10
	b	.L993
.L917:
	ldrb	w0, [x25, w20, sxtw]
	mov	x1, 32
	mov	w2, 160
	mov	x21, 0
	umaddl	x2, w2, w0, x1
	ldr	x1, [x29, 112]
	ubfiz	x0, x0, 8, 8
	add	x19, x1, x2
	adrp	x1, .LANCHOR6
	ldr	x4, [x1, #:lo12:.LANCHOR6]
	add	x23, x4, x0
.L912:
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
	bhi	.L912
	adrp	x3, .LANCHOR110
	add	x3, x3, :lo12:.LANCHOR110
	mov	x0, 0
.L915:
	add	x15, x19, x0
	add	x14, x3, x0
	mov	x1, 1
.L914:
	lsl	x4, x1, 2
	lsl	x16, x1, 3
	ldrb	w17, [x19, x0]
	add	x1, x1, 1
	cmp	x1, 7
	ldrb	w4, [x14, x4]
	add	w4, w4, w17
	strb	w4, [x15, x16]
	bne	.L914
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L915
	add	w5, w20, 1
	strb	wzr, [x19, 16]
	strb	wzr, [x19, 24]
	and	w20, w5, 255
	strb	wzr, [x19, 32]
	strb	wzr, [x19, 40]
	strb	wzr, [x19, 48]
	strb	wzr, [x19, 41]
	strb	wzr, [x19, 49]
	b	.L911
.L910:
	ldr	w0, [x29, 140]
	sub	w0, w0, #3
	cmp	w0, 4
	bhi	.L918
	ldp	w0, w1, [x29, 132]
	adrp	x19, .LANCHOR8
	add	x19, x19, :lo12:.LANCHOR8
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
.L919:
	ldrb	w0, [x19]
	ldr	w1, [x29, 128]
	cmp	w0, w1
	bls	.L918
	ldr	w1, [x29, 128]
	adrp	x0, .LANCHOR10
	add	x0, x0, :lo12:.LANCHOR10
	mov	w10, 160
	mov	w23, 255
	ldrb	w4, [x0, w1, sxtw]
	mov	x0, 32
	umaddl	x10, w10, w4, x0
	ldr	x0, [x29, 112]
	ubfiz	x4, x4, 8, 8
	add	x0, x0, x10
	str	x0, [x29, 104]
	adrp	x0, .LANCHOR6
	ldr	x0, [x0, #:lo12:.LANCHOR6]
	add	x27, x0, x4
	str	w23, [x27, 2056]
	bl	nandc_wait_flash_ready
	mov	w0, 54
	str	w0, [x27, 2056]
	ldr	w0, [x29, 140]
	cmp	w0, 4
	bne	.L920
	mov	w0, 64
	str	w23, [x27, 2052]
	str	w0, [x27, 2048]
	mov	w0, 204
.L994:
	str	w0, [x27, 2052]
	mov	w0, 77
	b	.L995
.L920:
	cmp	w20, 1
	bhi	.L922
	ldrb	w0, [x28, 128]
	str	w0, [x27, 2052]
	mov	w0, 82
.L995:
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
	bne	.L923
	mov	w0, 31
	str	w0, [x27, 2052]
.L924:
	mov	w23, 2
	str	w23, [x27, 2052]
	str	wzr, [x27, 2052]
	mov	w0, 48
	str	w0, [x27, 2056]
	bl	nandc_wait_flash_ready
	cmp	w20, 1
	bls	.L958
	ldr	w0, [x29, 140]
	cmp	w0, 7
	mov	w0, 32
	csel	w23, w23, w0, ne
.L925:
	adrp	x3, .LANCHOR111
	mov	x1, 0
	ldr	x0, [x3, #:lo12:.LANCHOR111]
.L926:
	ldr	w2, [x27, 2048]
	strb	w2, [x0, x1]
	add	x1, x1, 1
	cmp	w23, w1, uxtb
	bhi	.L926
	ldr	w1, [x29, 140]
	cmp	w1, 7
	bne	.L927
	mov	w1, 0
.L929:
	ldrb	w2, [x0]
	cmp	w2, 12
	beq	.L928
	ldrb	w2, [x0, 1]
	cmp	w2, 10
	beq	.L928
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L929
.L930:
	adrp	x0, .LC33
	mov	w1, 0
	add	x0, x0, :lo12:.LC33
	bl	printf
.L932:
	b	.L932
.L922:
	mov	w0, 174
	str	w0, [x27, 2052]
	str	wzr, [x27, 2048]
	mov	w0, 176
	b	.L994
.L923:
	str	wzr, [x27, 2052]
	b	.L924
.L958:
	mov	w23, 16
	b	.L925
.L928:
	cmp	w1, 6
	bhi	.L930
.L931:
	ldr	x2, [x3, #:lo12:.LANCHOR111]
	mov	x0, 0
.L936:
	ldr	w1, [x29, 120]
	cmp	w1, w0
	bgt	.L937
	ldr	x1, [x3, #:lo12:.LANCHOR111]
	mov	w16, 8
	add	x3, x1, x21
.L939:
	mov	x0, 0
.L938:
	ldr	w17, [x3, x0, lsl 2]
	ldr	w4, [x29, 124]
	mvn	w17, w17
	str	w17, [x3, x0, lsl 2]
	add	x0, x0, 1
	cmp	w4, w0
	bgt	.L938
	add	x3, x3, x22, uxtw 2
	subs	w16, w16, #1
	bne	.L939
	mov	x17, x1
	mov	w23, 0
	mov	w26, 1
.L940:
	mov	w3, 0
	mov	w0, 0
.L944:
	mov	x25, x17
	lsl	w16, w26, w0
	mov	w24, 16
	mov	w30, 0
.L942:
	ldr	w4, [x25]
	add	x25, x25, x21
	bics	wzr, w16, w4
	cinc	w30, w30, eq
	subs	w24, w24, #1
	bne	.L942
	cmp	w30, 9
	orr	w16, w3, w16
	add	w0, w0, 1
	csel	w3, w16, w3, cs
	cmp	w0, 32
	bne	.L944
	ldr	w0, [x29, 124]
	add	w23, w23, 1
	str	w3, [x17], 4
	cmp	w0, w23
	bgt	.L940
	mov	x0, 0
	mov	w3, 0
.L947:
	ldr	w16, [x1, x0]
	add	x0, x0, 4
	cmp	w16, 0
	cinc	w3, w3, eq
	cmp	x0, 32
	bne	.L947
	cmp	w3, 7
	ble	.L948
	mov	w3, 1024
	mov	w2, 1
	adrp	x0, .LC34
	add	x0, x0, :lo12:.LC34
	bl	rknand_print_hex
	adrp	x0, .LC33
	mov	w1, 0
	add	x0, x0, :lo12:.LC33
	bl	printf
.L949:
	b	.L949
.L927:
	ldr	w1, [x29, 140]
	cmp	w1, 6
	bne	.L931
	mov	x1, 0
.L933:
	ldrb	w2, [x0, x1]
	cmp	w2, 12
	beq	.L931
	add	x2, x0, x1
	ldrb	w2, [x2, 8]
	cmp	w2, 4
	beq	.L931
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L933
	adrp	x0, .LC33
	mov	w1, 0
	add	x0, x0, :lo12:.LC33
	bl	printf
.L935:
	b	.L935
.L937:
	ldr	w1, [x27, 2048]
	strb	w1, [x2, x0]
	add	x0, x0, 1
	b	.L936
.L948:
	ldr	w0, [x29, 140]
	cmp	w0, 6
	beq	.L960
	cmp	w0, 7
	mov	x1, 10
	mov	x0, 8
	csel	x0, x0, x1, ne
.L950:
	ldr	x10, [x29, 104]
	mov	w3, 0
.L951:
	mov	x1, 0
.L952:
	ldrb	w16, [x2, x1]
	ldr	w4, [x29, 136]
	strb	w16, [x10, x1]
	add	x1, x1, 1
	cmp	w4, w1, uxtb
	bhi	.L952
	ldr	x1, [x29, 96]
	add	w3, w3, 1
	add	x10, x10, x0
	add	x2, x2, x1
	ldr	w1, [x29, 132]
	cmp	w1, w3
	bgt	.L951
	mov	w23, 255
	str	w23, [x27, 2056]
	bl	nandc_wait_flash_ready
	cmp	w20, 1
	bhi	.L954
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
.L996:
	str	w0, [x27, 2056]
	bl	nandc_wait_flash_ready
	ldr	w0, [x29, 128]
	add	w11, w0, 1
	and	w0, w11, 255
	str	w0, [x29, 128]
	b	.L919
.L960:
	mov	x0, 4
	b	.L950
.L954:
	mov	w0, 56
	b	.L996
	.size	hynix_get_read_retry_default, .-hynix_get_read_retry_default
	.section	.text.flash_get_read_retry_tbl,"ax",@progbits
	.align	2
	.global	flash_get_read_retry_tbl
	.type	flash_get_read_retry_tbl, %function
flash_get_read_retry_tbl:
	adrp	x0, .LANCHOR19+19
	ldrb	w0, [x0, #:lo12:.LANCHOR19+19]
	sub	w1, w0, #1
	and	w1, w1, 255
	cmp	w1, 6
	bhi	.L997
	b	hynix_get_read_retry_default
.L997:
	ret
	.size	flash_get_read_retry_tbl, .-flash_get_read_retry_tbl
	.section	.text.nandc_xfer_done,"ax",@progbits
	.align	2
	.global	nandc_xfer_done
	.type	nandc_xfer_done, %function
nandc_xfer_done:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR7
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR6
	ldrb	w0, [x0, #:lo12:.LANCHOR7]
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	cmp	w0, 9
	ldr	x20, [x19, #:lo12:.LANCHOR6]
	bne	.L1000
	ldr	w0, [x20, 16]
	mov	w21, 0
	str	w0, [x29, 64]
	ldr	w0, [x20, 48]
	tbnz	x0, 1, .L1001
	adrp	x22, .LC37
	adrp	x23, .LC36
	add	x22, x22, :lo12:.LC37
	add	x23, x23, :lo12:.LC36
.L1002:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1005
	ldr	x0, [x19, #:lo12:.LANCHOR6]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 16]
	str	w0, [x29, 64]
	bne	.L1002
	ldr	w2, [x29, 64]
	mov	w1, w21
	ldr	w3, [x20, 64]
	mov	x0, x22
	ubfx	x3, x3, 16, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR6]
	mov	w3, 256
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1002
.L1001:
	adrp	x22, .LC35
	adrp	x23, .LC36
	add	x22, x22, :lo12:.LC35
	add	x23, x23, :lo12:.LC36
.L1003:
	ldr	w1, [x20, 64]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 6
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	blt	.L1007
.L1005:
	adrp	x0, .LANCHOR30+32
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	str	wzr, [x0, #:lo12:.LANCHOR30+32]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	ret
.L1007:
	ldr	x0, [x19, #:lo12:.LANCHOR6]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1004
	ldr	w0, [x29, 72]
	tbnz	x0, 17, .L1005
.L1004:
	add	w21, w21, 1
	tst	x21, 16777215
	bne	.L1003
	ldr	w2, [x20, 64]
	mov	w1, w21
	ldr	w3, [x29, 64]
	mov	x0, x22
	ubfx	x2, x2, 16, 5
	ubfx	x3, x3, 22, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR6]
	mov	w3, 256
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1003
.L1000:
	ldr	w0, [x20, 8]
	mov	w21, 0
	str	w0, [x29, 64]
	ldr	w0, [x20, 16]
	tbnz	x0, 1, .L1011
	adrp	x22, .LC37
	adrp	x23, .LC36
	add	x22, x22, :lo12:.LC37
	add	x23, x23, :lo12:.LC36
.L1012:
	ldr	w0, [x29, 64]
	tbnz	x0, 20, .L1005
	ldr	x0, [x19, #:lo12:.LANCHOR6]
	add	w21, w21, 1
	tst	x21, 16777215
	ldr	w0, [x0, 8]
	str	w0, [x29, 64]
	bne	.L1012
	ldr	w2, [x29, 64]
	mov	w1, w21
	ldr	w3, [x20, 28]
	mov	x0, x22
	ubfx	x3, x3, 16, 5
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR6]
	mov	w3, 256
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1012
.L1011:
	adrp	x22, .LC35
	adrp	x23, .LC36
	add	x22, x22, :lo12:.LC35
	add	x23, x23, :lo12:.LC36
.L1013:
	ldr	w1, [x20, 28]
	ldr	w0, [x29, 64]
	ubfx	x1, x1, 16, 5
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L1005
	ldr	x0, [x19, #:lo12:.LANCHOR6]
	ldr	w0, [x0]
	str	w0, [x29, 72]
	ldr	w0, [x29, 72]
	tbz	x0, 13, .L1014
	ldr	w0, [x29, 72]
	tbz	x0, 17, .L1014
	ldr	w1, [x29, 72]
	adrp	x0, .LC38
	add	x0, x0, :lo12:.LC38
	bl	printf
	b	.L1005
.L1014:
	add	w21, w21, 1
	tst	x21, 16777215
	bne	.L1013
	ldr	w2, [x20, 28]
	mov	w1, w21
	ldr	w3, [x29, 64]
	mov	x0, x22
	ubfx	x2, x2, 16, 5
	ubfx	x3, x3, 22, 6
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR6]
	mov	w3, 256
	mov	w2, 4
	mov	x0, x23
	bl	rknand_print_hex
	b	.L1013
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
	cbnz	w22, .L1052
	adrp	x0, .LANCHOR7
	ldrb	w0, [x0, #:lo12:.LANCHOR7]
	cmp	w0, 9
	bne	.L1036
	adrp	x1, .LANCHOR6
	lsr	w19, w19, 2
	mov	x20, x1
	mov	w3, 1
	ldr	x5, [x1, #:lo12:.LANCHOR6]
	mov	w2, 0
	mov	w0, 0
.L1037:
	cmp	w2, w19
	bcc	.L1041
	ldr	w19, [x5]
	cmp	w3, 0
	mov	w1, 512
	csel	w0, w0, w1, eq
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1035
	mov	w1, w19
	adrp	x0, .LC39
	add	x0, x0, :lo12:.LC39
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR6]
	orr	w19, w19, 131072
.L1065:
	str	w19, [x0]
	mov	w0, -1
.L1035:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1041:
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
	tbnz	x1, 2, .L1054
	ldr	w1, [x29, 56]
	tbnz	x1, 18, .L1054
	ldr	w4, [x29, 56]
	ldr	w1, [x29, 56]
	ubfx	x4, x4, 3, 7
	ubfx	x1, x1, 19, 7
	cmp	w4, w1
	ldr	w1, [x29, 56]
	ble	.L1039
	ubfx	x1, x1, 3, 7
.L1040:
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1038:
	add	w2, w2, 1
	b	.L1037
.L1039:
	ubfx	x1, x1, 19, 7
	b	.L1040
.L1054:
	mov	w0, -1
	b	.L1038
.L1036:
	adrp	x0, .LANCHOR27
	lsr	w4, w19, 1
	mov	w3, 64
	mov	w1, 1
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
	mov	w2, 0
	adrp	x6, .LANCHOR30
	cmp	w0, 25
	mov	w0, 128
	csel	w3, w3, w0, cc
	mov	w0, 0
.L1044:
	add	w5, w3, w0
	cmp	w2, w4
	bcc	.L1045
	adrp	x22, .LANCHOR6
	lsr	w19, w19, 2
	mov	w3, 0
	mov	w0, 0
	ldr	x4, [x22, #:lo12:.LANCHOR6]
.L1046:
	cmp	w3, w19
	bcc	.L1050
	str	wzr, [x4, 16]
	cmn	w0, #1
	beq	.L1051
	ldr	w1, [x20]
	cmn	w1, #1
	bne	.L1051
	ldr	w1, [x20, 4]
	cmn	w1, #1
	bne	.L1051
	ldr	w1, [x21]
	cmn	w1, #1
	mov	w1, 512
	csel	w0, w0, w1, ne
.L1051:
	ldr	w19, [x4]
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w19, w1
	cmp	w1, 139264
	bne	.L1035
	mov	w1, w19
	adrp	x0, .LC40
	add	x0, x0, :lo12:.LC40
	bl	printf
	orr	w19, w19, 131072
	ldr	x0, [x22, #:lo12:.LANCHOR6]
	b	.L1065
.L1045:
	ldr	x7, [x6, #:lo12:.LANCHOR30]
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
	b	.L1044
.L1050:
	uxtw	x1, w3
	add	x1, x1, 8
	ldr	w1, [x4, x1, lsl 2]
	str	w1, [x29, 56]
	ldr	w1, [x29, 56]
	tbnz	x1, 2, .L1057
	ldr	w1, [x29, 56]
	tbnz	x1, 15, .L1057
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
	bls	.L1048
	ubfx	x2, x1, 3, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 27, 1
.L1064:
	orr	w1, w2, w1, lsl 5
	cmp	w0, w1
	csel	w0, w0, w1, cs
.L1047:
	add	w3, w3, 1
	b	.L1046
.L1048:
	ubfx	x2, x1, 16, 5
	ldr	w1, [x29, 56]
	ubfx	x1, x1, 29, 1
	b	.L1064
.L1057:
	mov	w0, -1
	b	.L1047
.L1052:
	mov	w0, 0
	b	.L1035
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
	adrp	x0, .LANCHOR6
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	mov	w23, w1
	ldr	x19, [x0, #:lo12:.LANCHOR6]
	adrp	x0, .LANCHOR22
	stp	x25, x26, [sp, 64]
	mov	w24, w4
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	mov	x25, x2
	mov	x26, x3
	and	w20, w1, 2097151
	ubfx	x22, x23, 24, 2
	tbz	x0, 4, .L1067
	mov	w3, w1
	adrp	x0, .LC41
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC41
	bl	printf
.L1067:
	bl	nandc_wait_flash_ready
	mov	w0, w21
	bl	nandc_cs
	adrp	x5, .LANCHOR34
	cbnz	w22, .L1068
	mov	w0, w21
	bl	flash_enter_slc_mode
.L1069:
	ubfiz	x4, x21, 8, 8
	lsr	w0, w20, 8
	add	x4, x19, x4
	and	w23, w23, 255
	str	wzr, [x4, 2056]
	str	wzr, [x4, 2052]
	str	wzr, [x4, 2052]
	str	w23, [x4, 2052]
	str	w0, [x4, 2052]
	lsr	w0, w20, 16
	str	w0, [x4, 2052]
	mov	w0, 48
	str	w0, [x4, 2056]
	ldr	x0, [x5, #:lo12:.LANCHOR34]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1071
	cbz	w22, .L1071
	add	w20, w20, w20, lsl 1
	sub	w0, w20, #1
	add	w0, w0, w22
.L1081:
	bl	nandc_set_seed
	bl	nandc_wait_flash_ready
	mov	w0, 5
	str	w0, [x4, 2056]
	str	wzr, [x4, 2052]
	mov	w0, 224
	str	wzr, [x4, 2052]
	mov	x3, x25
	str	w0, [x4, 2056]
	mov	w2, w24
	mov	w1, 0
	mov	x4, x26
	mov	w0, w21
	bl	nandc_xfer
	mov	w5, w0
	cbnz	w22, .L1073
	mov	w0, w21
	bl	flash_exit_slc_mode
.L1073:
	mov	w0, 0
	bl	nandc_de_cs
	ldp	x19, x20, [sp, 16]
	mov	w0, w5
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1068:
	ldr	x0, [x5, #:lo12:.LANCHOR34]
	ldrb	w0, [x0, 12]
	cmp	w0, 3
	bne	.L1070
	sxtw	x0, w21
	add	x0, x0, 8
	add	x0, x19, x0, lsl 8
	str	w22, [x0, 8]
	b	.L1069
.L1070:
	mov	w0, w21
	bl	flash_exit_slc_mode
	b	.L1069
.L1071:
	mov	w0, w20
	b	.L1081
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
	adrp	x0, .LANCHOR27
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	mov	x26, x3
	stp	x23, x24, [sp, 48]
	mov	w23, w2
	stp	x27, x28, [sp, 80]
	mov	x27, x4
	ldrb	w21, [x0, #:lo12:.LANCHOR27]
	and	x20, x25, 255
	str	w5, [x29, 124]
	bl	nandc_wait_flash_ready
	adrp	x0, .LANCHOR6
	adrp	x24, .LC42
	add	w21, w21, w21, lsl 1
	adrp	x7, .LANCHOR113
	ldr	x8, [x0, #:lo12:.LANCHOR6]
	asr	w21, w21, 2
	add	x24, x24, :lo12:.LC42
	add	x7, x7, :lo12:.LANCHOR113
	mov	w22, 0
	mov	w19, -1
	add	x28, x8, x20, lsl 8
.L1083:
	ldrb	w0, [x7]
	cmp	w22, w0
	bcc	.L1087
.L1086:
	add	x8, x8, x20, lsl 8
	mov	w0, 239
	str	w0, [x8, 2056]
	mov	w0, 137
	str	w0, [x8, 2052]
	mov	w0, 200
	bl	timer_delay_ns
	str	wzr, [x8, 2048]
	str	wzr, [x8, 2048]
	cmp	w19, w21
	str	wzr, [x8, 2048]
	str	wzr, [x8, 2048]
	bcc	.L1088
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1088:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1082
	adrp	x0, .LC43
	mov	w4, w19
	mov	w3, w22
	mov	w2, w23
	mov	w1, w22
	add	x0, x0, :lo12:.LC43
	bl	printf
.L1082:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1087:
	mov	w0, 239
	str	w0, [x28, 2056]
	mov	w0, 137
	str	w0, [x28, 2052]
	stp	x7, x8, [x29, 96]
	mov	w0, 200
	bl	timer_delay_ns
	add	w10, w22, 1
	str	w10, [x28, 2048]
	str	wzr, [x28, 2048]
	mov	x3, x27
	ldr	w4, [x29, 124]
	mov	x2, x26
	str	wzr, [x28, 2048]
	mov	w1, w23
	str	wzr, [x28, 2048]
	mov	w0, w25
	str	w10, [x29, 116]
	bl	flash_read_page
	mov	w6, w0
	mov	w4, w19
	str	w6, [x29, 120]
	mov	w3, w22
	mov	w2, w23
	mov	w1, w22
	mov	x0, x24
	bl	printf
	ldp	w10, w6, [x29, 116]
	ldp	x7, x8, [x29, 96]
	cmn	w6, #1
	beq	.L1084
	adrp	x0, .LANCHOR111
	cmn	w19, #1
	csel	w19, w19, w6, ne
	cmp	w6, w21
	ldr	x26, [x0, #:lo12:.LANCHOR111]
	adrp	x0, .LANCHOR112
	ldr	x27, [x0, #:lo12:.LANCHOR112]
	bcc	.L1090
.L1084:
	mov	w22, w10
	b	.L1083
.L1090:
	mov	w19, w6
	b	.L1086
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
	adrp	x22, .LANCHOR2
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
	adrp	x0, .LANCHOR6
	mov	w1, 46
	mov	w2, 56
	ldr	x26, [x0, #:lo12:.LANCHOR6]
	and	x0, x25, 255
	add	x21, x0, 8
	str	x0, [x29, 112]
	ldrb	w0, [x22, #:lo12:.LANCHOR2]
	add	x21, x26, x21, lsl 8
	cmp	w0, 36
	mov	w0, 26
	csel	w1, w2, w1, ne
	str	w1, [x29, 96]
	mov	w1, 10
	csel	w0, w1, w0, ne
	str	w0, [x29, 104]
	cbnz	w6, .L1102
	sxtw	x24, w25
	adrp	x0, .LC44
	add	x24, x24, 8
	add	x0, x0, :lo12:.LC44
	add	x24, x26, x24, lsl 8
	mov	w19, -1
	mov	w20, 1
	str	x0, [x29, 96]
.L1108:
	ldrb	w0, [x22, #:lo12:.LANCHOR2]
	cmp	w0, 36
	bne	.L1103
	mov	x0, x21
	mov	w2, 0
	mov	w1, w20
	bl	toshiba_tlc_set_rr_para
	mov	w0, 93
	str	w0, [x24, 8]
.L1104:
	ldr	w4, [x29, 124]
	mov	x3, x28
	mov	x2, x27
	mov	w1, w23
	mov	w0, w25
	bl	flash_read_page
	mov	w4, w0
	mov	w3, w0
	ldr	x0, [x29, 96]
	str	w4, [x29, 120]
	mov	w2, w23
	mov	w1, w20
	bl	printf
	ldr	w4, [x29, 120]
	cmn	w4, #1
	beq	.L1105
	adrp	x0, .LANCHOR111
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x27, [x0, #:lo12:.LANCHOR111]
	adrp	x0, .LANCHOR112
	ldr	x28, [x0, #:lo12:.LANCHOR112]
	adrp	x0, .LANCHOR27
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1121
.L1105:
	ldr	w0, [x29, 104]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1108
.L1107:
	ldrb	w0, [x22, #:lo12:.LANCHOR2]
	cmp	w0, 36
	bne	.L1109
	mov	w2, 0
.L1135:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_tlc_set_rr_para
	b	.L1110
.L1103:
	mov	w1, w20
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
	b	.L1104
.L1121:
	mov	w19, w4
	b	.L1107
.L1109:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_slc_rr_para
.L1110:
	ldrb	w0, [x22, #:lo12:.LANCHOR2]
	cmp	w0, 36
	bne	.L1118
	ldr	x0, [x29, 112]
	add	x26, x26, x0, lsl 8
	mov	w0, 85
	str	w0, [x26, 2056]
	mov	w0, 255
	str	wzr, [x26, 2052]
	str	wzr, [x26, 2048]
	str	w0, [x26, 2056]
.L1118:
	mov	w4, w19
	mov	w3, w20
	mov	w2, w23
	mov	w1, w20
	adrp	x0, .LC46
	add	x0, x0, :lo12:.LC46
	bl	printf
	adrp	x0, .LANCHOR27
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1119
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1119:
	bl	nandc_wait_flash_ready
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1102:
	sxtw	x24, w25
	orr	w23, w23, w6, lsl 24
	add	x24, x24, 8
	adrp	x0, .LC45
	add	x24, x26, x24, lsl 8
	add	x0, x0, :lo12:.LC45
	mov	w19, -1
	mov	w20, 1
	str	x0, [x29, 104]
.L1116:
	ldrb	w0, [x22, #:lo12:.LANCHOR2]
	cmp	w0, 36
	bne	.L1111
	mov	x0, x21
	mov	w2, 1
	mov	w1, w20
	bl	toshiba_tlc_set_rr_para
	mov	w0, 93
.L1134:
	str	w0, [x24, 8]
	mov	x3, x28
	mov	x2, x27
	mov	w1, w23
	ldr	w4, [x29, 124]
	mov	w0, w25
	bl	flash_read_page
	mov	w4, w0
	mov	w3, w0
	ldr	x0, [x29, 104]
	str	w4, [x29, 120]
	mov	w2, w23
	mov	w1, w20
	bl	printf
	ldr	w4, [x29, 120]
	cmn	w4, #1
	beq	.L1113
	adrp	x0, .LANCHOR111
	cmn	w19, #1
	csel	w19, w19, w4, ne
	ldr	x27, [x0, #:lo12:.LANCHOR111]
	adrp	x0, .LANCHOR112
	ldr	x28, [x0, #:lo12:.LANCHOR112]
	adrp	x0, .LANCHOR27
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
	add	w0, w0, w0, lsl 1
	cmp	w4, w0, lsr 2
	bcc	.L1122
.L1113:
	ldr	w0, [x29, 96]
	add	w20, w20, 1
	cmp	w0, w20
	bne	.L1116
.L1115:
	ldrb	w0, [x22, #:lo12:.LANCHOR2]
	cmp	w0, 36
	bne	.L1117
	mov	w2, 1
	b	.L1135
.L1111:
	mov	x0, x21
	mov	w1, w20
	bl	toshiba_3d_set_tlc_rr_para
	mov	w0, 38
	b	.L1134
.L1122:
	mov	w19, w4
	b	.L1115
.L1117:
	mov	w1, 0
	mov	x0, x21
	bl	toshiba_3d_set_tlc_rr_para
	b	.L1110
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
	adrp	x0, .LANCHOR6
	adrp	x1, .LANCHOR2
	str	x1, [x29, 112]
	add	x21, x26, 8
	ldr	x22, [x0, #:lo12:.LANCHOR6]
	ldrb	w0, [x1, #:lo12:.LANCHOR2]
	sub	w0, w0, #67
	add	x21, x22, x21, lsl 8
	and	w0, w0, 255
	cmp	w0, 1
	bls	.L1154
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L1155
	mov	w23, 1
	mov	w0, 1
	bl	nandc_set_if_mode
.L1138:
	add	x0, x22, x26, lsl 8
	mov	w1, 92
	str	w1, [x0, 2056]
	mov	w1, 197
	str	w1, [x0, 2056]
.L1137:
	sxtw	x0, w19
	mov	w20, 1
	add	x0, x0, 8
	mov	w24, -1
	add	x0, x22, x0, lsl 8
	str	x0, [x29, 104]
.L1139:
	adrp	x0, .LANCHOR113
	ldrb	w0, [x0, #:lo12:.LANCHOR113]
	add	w0, w0, 1
	cmp	w20, w0
	bcc	.L1148
	mov	w25, w24
.L1147:
	ldr	x0, [x29, 112]
	mov	w1, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1149
	bl	sandisk_set_rr_para
.L1150:
	sxtw	x19, w19
	mov	w0, 255
	add	x19, x19, 8
	add	x22, x22, x19, lsl 8
	str	w0, [x22, 8]
	adrp	x0, .LANCHOR27
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
	add	w0, w0, w0, lsl 1
	cmp	w25, w0, lsr 2
	bcc	.L1151
	cmn	w25, #1
	mov	w0, 256
	csel	w25, w25, w0, eq
.L1151:
	cmp	w25, 256
	ccmn	w25, #1, 4, ne
	bne	.L1152
	ldr	w2, [x29, 124]
	adrp	x0, .LC46
	mov	w4, w25
	mov	w3, w20
	mov	w1, w20
	add	x0, x0, :lo12:.LC46
	bl	printf
.L1152:
	bl	nandc_wait_flash_ready
	cbz	w23, .L1136
	mov	w0, 4
	bl	nandc_set_if_mode
.L1136:
	mov	w0, w25
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1155:
	mov	w23, 0
	b	.L1138
.L1154:
	mov	w23, 0
	b	.L1137
.L1148:
	ldr	x0, [x29, 112]
	mov	w1, w20
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x21
	bhi	.L1140
	bl	sandisk_set_rr_para
.L1141:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	cmp	w0, 34
	bne	.L1142
	adrp	x0, .LANCHOR113
	ldrb	w0, [x0, #:lo12:.LANCHOR113]
	sub	w0, w0, #3
	cmp	w20, w0
	bne	.L1142
	ldr	x1, [x29, 104]
	mov	w0, 179
	str	w0, [x1, 8]
.L1142:
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
	beq	.L1145
	cmn	w24, #1
	csel	w24, w24, w0, ne
	adrp	x0, .LANCHOR111
	ldr	x27, [x0, #:lo12:.LANCHOR111]
	adrp	x0, .LANCHOR112
	ldr	x28, [x0, #:lo12:.LANCHOR112]
	adrp	x0, .LANCHOR27
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
	add	w0, w0, w0, lsl 1
	cmp	w25, w0, lsr 2
	bcc	.L1147
.L1145:
	add	w20, w20, 1
	b	.L1139
.L1140:
	bl	toshiba_set_rr_para
	b	.L1141
.L1149:
	bl	toshiba_set_rr_para
	b	.L1150
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
	adrp	x0, .LANCHOR5
	stp	x27, x28, [sp, 80]
	stp	x21, x22, [sp, 32]
	mov	w27, w5
	ldr	x28, [x0, #:lo12:.LANCHOR5]
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
	adrp	x6, .LANCHOR27
	add	x6, x6, :lo12:.LANCHOR27
	mov	w5, 0
	adrp	x7, .LANCHOR111
	adrp	x8, .LANCHOR112
.L1169:
	cmp	w5, w24
	bcc	.L1174
.L1173:
	adrp	x0, .LANCHOR27
	add	x23, x28, x23
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
	strb	w20, [x23, 8]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L1175
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L1175:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L1168
	adrp	x0, .LC47
	mov	w4, w19
	mov	w3, w5
	mov	w2, w22
	mov	w1, w5
	add	x0, x0, :lo12:.LC47
	bl	printf
.L1168:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1174:
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
	beq	.L1171
	ldrb	w1, [x6]
	cmn	w19, #1
	csel	w19, w19, w0, ne
	ldr	x25, [x7, #:lo12:.LANCHOR111]
	ldr	x26, [x8, #:lo12:.LANCHOR112]
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L1177
.L1171:
	add	w5, w5, 1
	b	.L1169
.L1177:
	mov	w19, w0
	b	.L1173
	.size	hynix_read_retrial, .-hynix_read_retrial
	.section	.text.flash_ddr_tunning_read,"ax",@progbits
	.align	2
	.global	flash_ddr_tunning_read
	.type	flash_ddr_tunning_read, %function
flash_ddr_tunning_read:
	stp	x29, x30, [sp, -144]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, 0
	stp	x21, x22, [sp, 32]
	mov	w19, 0
	stp	x23, x24, [sp, 48]
	mov	w23, w1
	stp	x25, x26, [sp, 64]
	adrp	x24, .LC48
	stp	x27, x28, [sp, 80]
	and	w25, w0, 255
	mov	x26, x2
	mov	x27, x3
	str	w4, [x29, 140]
	add	x24, x24, :lo12:.LC48
	bl	nandc_get_ddr_para
	mov	w8, w0
	mov	w28, 1024
	mov	w21, 6
	mov	w22, -1
	mov	w6, 0
	mov	w7, 0
	adrp	x10, .LANCHOR111
	adrp	x11, .LANCHOR112
.L1192:
	stp	x11, x10, [x29, 104]
	mov	w0, w21
	stp	w8, w6, [x29, 124]
	str	w7, [x29, 132]
	bl	nandc_set_ddr_para
	ldr	w4, [x29, 140]
	mov	x3, x27
	mov	x2, x26
	mov	w1, w23
	mov	w0, w25
	bl	flash_read_page
	mov	w4, w0
	mov	w3, w0
	str	w4, [x29, 136]
	mov	w2, w23
	mov	w1, w21
	mov	x0, x24
	bl	printf
	ldp	w7, w4, [x29, 132]
	add	w0, w28, 1
	ldp	w8, w6, [x29, 124]
	cmp	w4, w0
	ldp	x11, x10, [x29, 104]
	bhi	.L1188
	ldr	x26, [x10, #:lo12:.LANCHOR111]
	cmp	w4, 2
	ldr	x27, [x11, #:lo12:.LANCHOR112]
	bhi	.L1197
	add	w19, w19, 1
	cmp	w19, 7
	bls	.L1197
	mov	w0, w20
	mov	w28, w4
	sub	w20, w21, w19
	mov	w22, 0
.L1190:
	cmp	w19, w7
	csel	w20, w20, w0, hi
.L1191:
	cbz	w20, .L1193
	adrp	x0, .LANCHOR27
	mov	w1, 3
	ldrb	w0, [x0, #:lo12:.LANCHOR27]
	udiv	w0, w0, w1
	cmp	w0, w28
	bls	.L1193
	mov	w1, w20
	adrp	x0, .LC49
	add	x0, x0, :lo12:.LC49
	bl	printf
	mov	w0, w20
.L1204:
	bl	nandc_set_ddr_para
	cbz	w22, .L1187
	mov	w28, w22
	mov	w2, w23
	mov	w1, w25
	adrp	x0, .LC50
	add	x0, x0, :lo12:.LC50
	bl	printf
.L1187:
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1188:
	cmp	w19, w7
	bls	.L1198
	sub	w20, w6, w19
	cmp	w19, 7
	bhi	.L1191
	mov	w7, w19
.L1198:
	mov	w19, 0
	b	.L1189
.L1197:
	mov	w6, w21
	mov	w28, w4
	mov	w22, 0
.L1189:
	add	w21, w21, 2
	cmp	w21, 50
	bne	.L1192
	mov	w0, w20
	mov	w20, w6
	b	.L1190
.L1193:
	mov	w0, w8
	b	.L1204
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
	adrp	x1, .LANCHOR8
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	cmp	w1, w0
	bhi	.L1206
	adrp	x1, .LANCHOR114
	adrp	x0, .LC0
	mov	w2, 386
	add	x1, x1, :lo12:.LANCHOR114
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1207:
	b	.L1207
.L1206:
	adrp	x1, .LANCHOR10
	add	x1, x1, :lo12:.LANCHOR10
	mov	x22, x2
	mov	x23, x3
	mov	w24, w4
	ldrb	w20, [x1, w0, sxtw]
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 4, .L1208
	adrp	x0, .LC51
	mov	w2, w19
	mov	w1, w20
	add	x0, x0, :lo12:.LC51
	bl	printf
.L1208:
	tst	x19, 50331648
	bne	.L1209
	adrp	x0, .LANCHOR11
	adrp	x1, .LANCHOR12
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	cbz	w0, .L1210
	ldrb	w0, [x1, #:lo12:.LANCHOR12]
	cbz	w0, .L1209
.L1210:
	adrp	x0, .LANCHOR13
	ldrb	w1, [x1, #:lo12:.LANCHOR12]
	ldrh	w2, [x0, #:lo12:.LANCHOR13]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L1211
	add	w19, w0, w19, lsl 1
.L1209:
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w20
	bl	flash_read_page
	mov	w21, w0
	cmn	w0, #1
	bne	.L1205
	adrp	x25, .LANCHOR29
	mov	x26, x25
	ldrb	w27, [x25, #:lo12:.LANCHOR29]
	cbnz	w27, .L1213
.L1216:
	adrp	x0, .LANCHOR115
	ldr	x6, [x0, #:lo12:.LANCHOR115]
	cbnz	x6, .L1214
.L1215:
	ldrb	w4, [x26, #:lo12:.LANCHOR29]
	mov	w3, -1
	mov	w2, w19
	mov	w1, 0
	adrp	x0, .LC52
	add	x0, x0, :lo12:.LC52
	bl	printf
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L1205
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
.L1211:
	adrp	x1, .LANCHOR14
	add	x1, x1, :lo12:.LANCHOR14
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
	b	.L1209
.L1213:
	strb	wzr, [x25, #:lo12:.LANCHOR29]
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w1, w19
	mov	w0, w20
	bl	flash_read_page
	strb	w27, [x25, #:lo12:.LANCHOR29]
	cmn	w0, #1
	beq	.L1216
.L1234:
	mov	w21, w0
.L1205:
	mov	w0, w21
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1214:
	mov	w5, w24
	mov	x4, x23
	mov	x3, x22
	mov	w2, w19
	mov	w1, 0
	mov	w0, w20
	blr	x6
	cmn	w0, #1
	bne	.L1234
	b	.L1215
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
	adrp	x0, .LANCHOR97
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	mov	x22, x2
	ldrh	w19, [x0, #:lo12:.LANCHOR97]
	adrp	x0, .LANCHOR19+26
	stp	x23, x24, [sp, 48]
	mov	x23, x3
	ldrh	w25, [x0, #:lo12:.LANCHOR19+26]
	sub	w19, w19, #1
	sxth	w19, w19
	mov	w24, w4
	mov	w0, w21
	str	x27, [sp, 80]
	mul	w25, w25, w1
	add	w1, w19, w25
	bl	flash_read_page_en
	cmp	w0, 512
	bne	.L1236
	mov	w26, 0
	mov	w27, 2
.L1237:
	cmp	w26, w19
	ble	.L1240
.L1236:
	mov	w0, w19
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1240:
	add	w20, w26, w19
	mov	w4, w24
	mov	x3, x23
	mov	x2, x22
	mov	w0, w21
	sdiv	w20, w20, w27
	add	w1, w25, w20, sxth
	bl	flash_read_page_en
	cmp	w0, 512
	bne	.L1238
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L1237
.L1238:
	add	w20, w20, 1
	sxth	w26, w20
	b	.L1237
	.size	flash_get_last_written_page, .-flash_get_last_written_page
	.section	.text.flash_get_last_written_page_ext,"ax",@progbits
	.align	2
	.global	flash_get_last_written_page_ext
	.type	flash_get_last_written_page_ext, %function
flash_get_last_written_page_ext:
	adrp	x4, .LANCHOR71
	mov	w6, 21
	and	w0, w0, 65535
	mov	w5, 1
	ldrh	w4, [x4, #:lo12:.LANCHOR71]
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
	adrp	x22, .LANCHOR13
	stp	x23, x24, [sp, 48]
	mov	w24, 21321
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR116
	stp	x27, x28, [sp, 80]
	mov	x21, x26
	add	x27, x22, :lo12:.LANCHOR13
	stp	x19, x20, [sp, 16]
	movk	w24, 0x5359, lsl 16
	mov	w19, 4
.L1246:
	ldrh	w1, [x27]
	adrp	x20, .LANCHOR5
	ldr	x3, [x26, #:lo12:.LANCHOR116]
	mov	w4, 4
	ldr	x2, [x20, #:lo12:.LANCHOR5]
	mov	w0, 0
	add	x28, x26, :lo12:.LANCHOR116
	add	x25, x20, :lo12:.LANCHOR5
	mul	w1, w1, w19
	mov	x23, x20
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1244
	ldr	x2, [x20, #:lo12:.LANCHOR5]
	ldr	w0, [x2]
	cmp	w0, w24
	beq	.L1245
.L1244:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L1246
.L1267:
	mov	w0, -1
.L1243:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1254:
	ldr	x0, [x25]
	ldr	w1, [x0]
	cmp	w1, w24
	bne	.L1255
	ldr	w19, [x0, 4]
.L1248:
	add	x24, x20, :lo12:.LANCHOR117
	ldrh	w0, [x22, #:lo12:.LANCHOR13]
	ldr	x3, [x21, #:lo12:.LANCHOR116]
	mov	w4, 4
	ldr	x2, [x23, #:lo12:.LANCHOR5]
	ldrb	w1, [x24, 1]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1249
	ldr	x0, [x23, #:lo12:.LANCHOR5]
	mov	w1, 21321
	movk	w1, 0x5359, lsl 16
	ldr	w2, [x0]
	cmp	w2, w1
	bne	.L1249
	ldr	w1, [x0, 4]
	cmp	w19, w1
	bcs	.L1249
	ldrb	w1, [x0, 37]
	ldrb	w0, [x0, 36]
	strb	w1, [x20, #:lo12:.LANCHOR117]
	strb	w0, [x24, 1]
.L1249:
	ldrb	w1, [x20, #:lo12:.LANCHOR117]
	add	x24, x20, :lo12:.LANCHOR117
	ldr	x3, [x21, #:lo12:.LANCHOR116]
	mov	w4, 4
	ldr	x2, [x23, #:lo12:.LANCHOR5]
	mov	w0, 0
	bl	flash_get_last_written_page
	sxth	w19, w0
	add	w0, w0, 1
	ldrb	w20, [x20, #:lo12:.LANCHOR117]
	strh	w0, [x24, 2]
	ldrh	w0, [x22, #:lo12:.LANCHOR13]
	mov	w22, 21321
	movk	w22, 0x5359, lsl 16
	madd	w20, w20, w0, w19
.L1250:
	tbz	w19, #31, .L1252
	cmn	w19, #1
	bne	.L1253
	ldr	x0, [x23, #:lo12:.LANCHOR5]
	ldr	w1, [x0]
	adrp	x0, .LC53
	add	x0, x0, :lo12:.LC53
	bl	printf
	b	.L1267
.L1252:
	ldr	x3, [x21, #:lo12:.LANCHOR116]
	mov	w4, 4
	ldr	x2, [x23, #:lo12:.LANCHOR5]
	mov	w1, w20
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	beq	.L1251
	ldr	x0, [x23, #:lo12:.LANCHOR5]
	ldr	w0, [x0]
	cmp	w0, w22
	bne	.L1251
.L1253:
	mov	w0, 0
	b	.L1243
.L1251:
	sub	w19, w19, #1
	sub	w20, w20, #1
	sxth	w19, w19
	b	.L1250
.L1245:
	adrp	x20, .LANCHOR117
	add	x1, x20, :lo12:.LANCHOR117
	ldrb	w3, [x2, 37]
	mov	w4, 4
	ldrb	w0, [x2, 36]
	strb	w3, [x1, 1]
	ldrh	w1, [x27]
	ldr	x3, [x28]
	strb	w0, [x20, #:lo12:.LANCHOR117]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_read_page_en
	cmn	w0, #1
	bne	.L1254
.L1255:
	mov	w19, 0
	b	.L1248
	.size	flash_info_blk_init, .-flash_info_blk_init
	.section	.text.flash_ddr_para_scan,"ax",@progbits
	.align	2
	.global	flash_ddr_para_scan
	.type	flash_ddr_para_scan, %function
flash_ddr_para_scan:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR25
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	ldrb	w0, [x20, #:lo12:.LANCHOR25]
	adrp	x19, .LANCHOR35
	stp	x23, x24, [sp, 48]
	mov	w21, 1
	mov	w23, w1
	str	x25, [sp, 64]
	strb	w21, [x19, #:lo12:.LANCHOR35]
	adrp	x24, .LANCHOR119
	bl	flash_set_interface_mode
	adrp	x25, .LANCHOR118
	ldrb	w0, [x20, #:lo12:.LANCHOR25]
	bl	nandc_set_if_mode
	ldr	x3, [x25, #:lo12:.LANCHOR118]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR119]
	mov	w1, w23
	mov	w0, w22
	bl	flash_ddr_tunning_read
	ldr	x3, [x25, #:lo12:.LANCHOR118]
	mov	w4, 4
	ldr	x2, [x24, #:lo12:.LANCHOR119]
	mov	w1, w23
	mov	w0, w22
	bl	flash_read_page
	cmn	w0, #1
	mov	x0, x19
	bne	.L1269
	ldrb	w1, [x20, #:lo12:.LANCHOR25]
	tbz	x1, 0, .L1269
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, w21
	bl	nandc_set_if_mode
	strb	wzr, [x19, #:lo12:.LANCHOR35]
.L1270:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1269:
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR35]
	b	.L1270
	.size	flash_ddr_para_scan, .-flash_ddr_para_scan
	.section	.text.flash_complete_page_read,"ax",@progbits
	.align	2
	.global	flash_complete_page_read
	.type	flash_complete_page_read, %function
flash_complete_page_read:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	mov	w25, w0
	adrp	x0, .LANCHOR8
	stp	x23, x24, [sp, 48]
	stp	x19, x20, [sp, 16]
	mov	x23, x1
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	ubfx	x1, x25, 21, 3
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	cmp	w0, w1
	bhi	.L1276
	adrp	x1, .LANCHOR120
	adrp	x0, .LC0
	mov	w2, 791
	add	x1, x1, :lo12:.LANCHOR120
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1277:
	b	.L1277
.L1276:
	adrp	x0, .LANCHOR10
	add	x0, x0, :lo12:.LANCHOR10
	ubfx	x22, x25, 24, 2
	mov	x24, x2
	and	w19, w25, 2097151
	ldrb	w21, [x0, w1, sxtw]
	adrp	x0, .LANCHOR6
	ldr	x4, [x0, #:lo12:.LANCHOR6]
	mov	w0, w21
	bl	nandc_cs
	cbnz	w22, .L1278
	adrp	x0, .LANCHOR11
	adrp	x1, .LANCHOR12
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	cbz	w0, .L1279
	ldrb	w0, [x1, #:lo12:.LANCHOR12]
	cbz	w0, .L1278
.L1279:
	adrp	x0, .LANCHOR13
	ldrb	w1, [x1, #:lo12:.LANCHOR12]
	ldrh	w2, [x0, #:lo12:.LANCHOR13]
	udiv	w0, w19, w2
	mul	w0, w0, w2
	sub	w19, w19, w0
	cbz	w1, .L1280
	add	w19, w0, w19, lsl 1
.L1278:
	ubfiz	x0, x21, 8, 8
	mov	w1, 5
	add	x0, x4, x0
	adrp	x20, .LANCHOR19
	add	x6, x20, :lo12:.LANCHOR19
	mov	x4, x24
	str	x6, [x29, 104]
	mov	x3, x23
	str	w1, [x0, 2056]
	and	w1, w19, 255
	str	wzr, [x0, 2052]
	str	wzr, [x0, 2052]
	str	w1, [x0, 2052]
	lsr	w1, w19, 8
	ldrb	w2, [x6, 9]
	str	w1, [x0, 2052]
	lsr	w1, w19, 16
	str	w1, [x0, 2052]
	mov	w1, 224
	str	w1, [x0, 2056]
	mov	w1, 0
	mov	w0, w21
	bl	nandc_xfer
	mov	w26, w0
	cmn	w0, #1
	ldr	x6, [x29, 104]
	bne	.L1275
	adrp	x27, .LANCHOR29
	mov	x28, x27
	ldrb	w5, [x27, #:lo12:.LANCHOR29]
	cbnz	w5, .L1282
.L1285:
	adrp	x0, .LANCHOR115
	ldr	x6, [x0, #:lo12:.LANCHOR115]
	cbnz	x6, .L1283
.L1284:
	ldrb	w4, [x28, #:lo12:.LANCHOR29]
	mov	w3, -1
	mov	w2, w25
	mov	w1, 0
	adrp	x0, .LC54
	add	x0, x0, :lo12:.LC54
	bl	printf
	adrp	x0, .LANCHOR35
	ldrb	w0, [x0, #:lo12:.LANCHOR35]
	cbz	w0, .L1275
	add	x20, x20, :lo12:.LANCHOR19
	orr	w1, w19, w22, lsl 24
	ldp	x25, x26, [sp, 64]
	mov	x3, x24
	ldrb	w4, [x20, 9]
	mov	x2, x23
	ldp	x19, x20, [sp, 16]
	mov	w0, w21
	ldp	x23, x24, [sp, 48]
	ldp	x21, x22, [sp, 32]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	b	flash_ddr_tunning_read
.L1280:
	adrp	x1, .LANCHOR14
	add	x1, x1, :lo12:.LANCHOR14
	ldrh	w19, [x1, w19, uxtw 1]
	add	w19, w19, w0
	b	.L1278
.L1282:
	ldrb	w4, [x6, 9]
	mov	x3, x24
	str	w5, [x29, 104]
	mov	x2, x23
	strb	wzr, [x27, #:lo12:.LANCHOR29]
	orr	w1, w19, w22, lsl 24
	mov	w0, w21
	bl	flash_read_page
	cmn	w0, #1
	ldr	w5, [x29, 104]
	strb	w5, [x27, #:lo12:.LANCHOR29]
	beq	.L1285
.L1300:
	mov	w26, w0
.L1275:
	mov	w0, w26
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1283:
	add	x0, x20, :lo12:.LANCHOR19
	mov	x4, x24
	mov	x3, x23
	mov	w2, w19
	mov	w1, w22
	ldrb	w5, [x0, 9]
	mov	w0, w21
	blr	x6
	cmn	w0, #1
	beq	.L1284
	b	.L1300
	.size	flash_complete_page_read, .-flash_complete_page_read
	.section	.text.queue_wait_first_req_completed,"ax",@progbits
	.align	2
	.type	queue_wait_first_req_completed, %function
queue_wait_first_req_completed:
	stp	x29, x30, [sp, -64]!
	adrp	x0, .LANCHOR90
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldrb	w0, [x0, #:lo12:.LANCHOR90]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w0, 255
	bne	.L1302
.L1320:
	mov	w21, 0
	b	.L1301
.L1302:
	adrp	x19, .LANCHOR36
	sxtw	x22, w0
	add	x1, x19, :lo12:.LANCHOR36
	add	x1, x1, x22, lsl 6
	ldrb	w2, [x1, 58]
	ldr	w21, [x1, 40]
	sub	w3, w2, #1
	cmp	w3, 9
	bhi	.L1320
	adrp	x1, .L1305
	add	x1, x1, :lo12:.L1305
	ldrb	w1, [x1,w3,uxtw]
	adr	x3, .Lrtx1305
	add	x1, x3, w1, sxtb #2
	br	x1
.Lrtx1305:
	.section	.rodata.queue_wait_first_req_completed,"a",@progbits
	.align	0
	.align	2
.L1305:
	.byte	(.L1304 - .Lrtx1305) / 4
	.byte	(.L1304 - .Lrtx1305) / 4
	.byte	(.L1306 - .Lrtx1305) / 4
	.byte	(.L1306 - .Lrtx1305) / 4
	.byte	(.L1306 - .Lrtx1305) / 4
	.byte	(.L1307 - .Lrtx1305) / 4
	.byte	(.L1308 - .Lrtx1305) / 4
	.byte	(.L1309 - .Lrtx1305) / 4
	.byte	(.L1306 - .Lrtx1305) / 4
	.byte	(.L1309 - .Lrtx1305) / 4
	.section	.text.queue_wait_first_req_completed
.L1304:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L1320
	add	x19, x19, :lo12:.LANCHOR36
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
	b	.L1320
.L1306:
	mov	w0, w21
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w21, w0
	tbz	x21, 6, .L1320
	add	x19, x19, :lo12:.LANCHOR36
	mov	w0, 5
	add	x19, x19, x22, lsl 6
	tst	w21, w0
	beq	.L1319
	ldrb	w1, [x19, 1]
	mov	w0, 11
	ldr	w3, [x19, 40]
	mov	w4, 11
	ldr	w2, [x19, 52]
	strb	w0, [x19, 58]
	adrp	x0, .LC55
	add	x0, x0, :lo12:.LC55
	bl	printf
.L1338:
	mov	w0, -1
	str	w0, [x19, 52]
	b	.L1301
.L1309:
	cmp	w2, 10
	add	x20, x19, :lo12:.LANCHOR36
	ubfiz	x0, x0, 6, 8
	mov	w1, 3
	mov	w2, 9
	add	x0, x20, x0
	csel	w2, w2, w1, eq
	ubfx	x3, x21, 21, 3
.L1314:
	ldrb	w1, [x0]
	cmp	w1, 255
	bne	.L1318
	mov	w21, -1
	b	.L1301
.L1318:
	sxtw	x23, w1
	ubfiz	x0, x1, 6, 8
	add	x1, x20, x23, lsl 6
	add	x0, x20, x0
	ldrb	w4, [x1, 58]
	cmp	w4, w2
	bne	.L1314
	ldr	w1, [x1, 40]
	ubfx	x1, x1, 21, 3
	cmp	w3, w1
	bne	.L1314
	mov	w0, w21
	mov	w1, 64
	bl	flash_wait_device_ready
	mov	w24, w0
	and	w21, w0, 64
	tbz	x24, 6, .L1316
	add	x20, x20, x22, lsl 6
	ands	w21, w0, 15
	beq	.L1317
	ldrb	w1, [x20, 1]
	mov	w4, 11
	ldr	w3, [x20, 40]
	adrp	x0, .LC55
	ldr	w2, [x20, 52]
	add	x0, x0, :lo12:.LC55
	mov	w21, w24
	bl	printf
	mov	w0, 11
	strb	w0, [x20, 58]
	mov	w0, -1
	str	w0, [x20, 52]
.L1316:
	add	x1, x19, :lo12:.LANCHOR36
	add	x22, x1, x22, lsl 6
	add	x1, x1, x23, lsl 6
	ldrb	w0, [x22, 58]
	strb	w0, [x1, 58]
	ldr	w0, [x22, 52]
	str	w0, [x1, 52]
.L1301:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1317:
	mov	w0, 12
	str	wzr, [x20, 52]
	strb	w0, [x20, 58]
	b	.L1316
.L1307:
	mov	w0, w21
	mov	w1, 32
	bl	flash_wait_device_ready
	mov	w21, w0
	tbz	x21, 5, .L1320
	add	x19, x19, :lo12:.LANCHOR36
	tst	x21, 15
	add	x19, x19, x22, lsl 6
	beq	.L1319
	mov	w0, 11
	strb	w0, [x19, 58]
	b	.L1338
.L1319:
	mov	w0, 12
	str	wzr, [x19, 52]
	strb	w0, [x19, 58]
	b	.L1320
.L1308:
	mov	w1, 64
	mov	w0, w21
	bl	flash_wait_device_ready
	tbz	x0, 6, .L1320
	add	x19, x19, :lo12:.LANCHOR36
	add	x19, x19, x22, lsl 6
	str	w0, [x19, 52]
	mov	w0, 6
	strb	w0, [x19, 58]
	b	.L1320
	.size	queue_wait_first_req_completed, .-queue_wait_first_req_completed
	.section	.text.sblk_wait_write_queue_completed,"ax",@progbits
	.align	2
	.global	sblk_wait_write_queue_completed
	.type	sblk_wait_write_queue_completed, %function
sblk_wait_write_queue_completed:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR90
	add	x19, x19, :lo12:.LANCHOR90
.L1340:
	ldrb	w0, [x19]
	cmp	w0, 255
	bne	.L1341
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1341:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1340
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
	adrp	x23, .LANCHOR79
	adrp	x24, .LANCHOR45
	add	x23, x23, :lo12:.LANCHOR79
	add	x24, x24, :lo12:.LANCHOR45
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	add	x1, x29, 80
	mov	w20, 0
	bl	ftl_get_blk_list_in_sblk
	strb	w0, [x29, 73]
	strh	w13, [x29, 64]
.L1348:
	ldrh	w0, [x23]
	cmp	w0, w20
	bls	.L1347
	adrp	x22, .LANCHOR69
	adrp	x21, .LANCHOR121
	mov	w19, 0
	add	x22, x22, :lo12:.LANCHOR69
	add	x21, x21, :lo12:.LANCHOR121
	b	.L1350
.L1353:
	add	x0, x29, 64
	mov	w1, 65535
	add	x0, x0, x19, sxtw 1
	ldrh	w0, [x0, 16]
	cmp	w0, w1
	bne	.L1349
.L1352:
	add	w19, w19, 1
	and	w19, w19, 65535
.L1350:
	ldrb	w0, [x22]
	cmp	w0, w19
	bhi	.L1353
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1348
.L1349:
	adrp	x1, .LANCHOR75
	ldrb	w3, [x24]
	mov	x2, x21
	ldrh	w4, [x1, #:lo12:.LANCHOR75]
	adrp	x1, ftl_tmp_buffer
	add	x1, x1, :lo12:ftl_tmp_buffer
	madd	w0, w4, w0, w20
	bl	ftl_read_ppa_page
	cmp	w0, 512
	bne	.L1352
.L1347:
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
	adrp	x23, .LANCHOR90
	adrp	x24, .LANCHOR36
	mov	x19, x0
	add	x23, x23, :lo12:.LANCHOR90
	add	x24, x24, :lo12:.LANCHOR36
	stp	x25, x26, [sp, 64]
.L1359:
	cbnz	w22, .L1363
.L1371:
	adrp	x19, .LANCHOR36
	add	x19, x19, :lo12:.LANCHOR36
.L1364:
	cbnz	w21, .L1367
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1363:
	ldrb	w25, [x19]
	ldr	w26, [x19, 40]
.L1360:
	mov	w1, 0
	mov	w0, w26
	bl	queue_lun_state
	cbnz	w0, .L1361
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
	beq	.L1371
	ubfiz	x19, x25, 6, 8
	add	x19, x24, x19
	b	.L1359
.L1361:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1360
.L1367:
	ldrb	w0, [x20, 58]
	cmp	w0, 12
	bne	.L1365
	ldrb	w20, [x20]
	sub	w21, w21, #1
	add	x20, x19, x20, lsl 6
	b	.L1364
.L1365:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1364
	.size	sblk_read_page, .-sblk_read_page
	.section	.text.gc_check_data_one_wl,"ax",@progbits
	.align	2
	.global	gc_check_data_one_wl
	.type	gc_check_data_one_wl, %function
gc_check_data_one_wl:
	sub	sp, sp, #112
	adrp	x0, .LANCHOR60
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x19, .LANCHOR58
	stp	x21, x22, [sp, 48]
	add	x21, x19, :lo12:.LANCHOR58
	ldr	x20, [x0, #:lo12:.LANCHOR60]
	stp	x23, x24, [sp, 64]
	ldr	x0, [x21, 8]
	stp	x25, x26, [sp, 80]
	str	x27, [sp, 96]
	cbnz	x0, .L1374
	mov	w0, 1
	bl	buf_alloc
	str	x0, [x21, 8]
.L1374:
	add	x0, x19, :lo12:.LANCHOR58
	ldr	x21, [x0, 8]
	cbz	x21, .L1375
	adrp	x26, .LANCHOR75
	adrp	x27, .LANCHOR64
	add	x25, x20, 96
	add	x26, x26, :lo12:.LANCHOR75
	add	x27, x27, :lo12:.LANCHOR64
	mov	w24, 0
.L1376:
	ldrb	w0, [x20, 89]
	cmp	w24, w0
	bge	.L1386
	mov	w23, 1
	add	x22, x19, :lo12:.LANCHOR58
	b	.L1387
.L1375:
	adrp	x1, .LANCHOR122
	adrp	x0, .LC0
	mov	w2, 333
	add	x1, x1, :lo12:.LANCHOR122
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1377:
	b	.L1377
.L1385:
	ldrh	w0, [x25]
	ldrh	w1, [x26]
	ldrb	w2, [x27]
	cmp	w2, 3
	mul	w1, w0, w1
	ldrh	w0, [x22, 16]
	bne	.L1378
	add	w0, w0, w1
	orr	w0, w0, w23, lsl 24
.L1398:
	str	w0, [x21, 40]
	mov	w1, 1
	mov	x0, x21
	bl	sblk_read_page
	ldr	w2, [x21, 52]
	adrp	x1, .LANCHOR107
	cmn	w2, #1
	beq	.L1381
	ldrh	w0, [x22, 22]
	ldr	x4, [x1, #:lo12:.LANCHOR107]
	ldr	x3, [x21, 24]
	lsl	x0, x0, 2
	ldr	w5, [x4, x0]
	ldr	w4, [x3, 4]
	cmp	w5, w4
	bne	.L1381
	adrp	x4, .LANCHOR108
	ldr	x4, [x4, #:lo12:.LANCHOR108]
	ldr	w4, [x4, x0]
	ldr	w0, [x3, 8]
	cmp	w4, w0
	beq	.L1382
.L1381:
	ldrh	w0, [x22, 22]
	ldr	x1, [x1, #:lo12:.LANCHOR107]
	lsl	x0, x0, 2
	ldr	w3, [x1, x0]
	cmn	w3, #1
	beq	.L1382
	adrp	x1, .LANCHOR22
	ldr	w1, [x1, #:lo12:.LANCHOR22]
	tbz	x1, 10, .L1383
	ldr	x1, [x21, 24]
	adrp	x4, .LANCHOR108
	ldr	x4, [x4, #:lo12:.LANCHOR108]
	ldr	w5, [x1, 12]
	str	w5, [sp]
	ldr	w4, [x4, x0]
	adrp	x0, .LC56
	ldp	w5, w6, [x1]
	add	x0, x0, :lo12:.LC56
	ldr	w7, [x1, 8]
	ldr	w1, [x21, 40]
	bl	printf
.L1383:
	adrp	x0, .LANCHOR56
	ldrh	w1, [x20, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR56]
	strh	wzr, [x0, x1, lsl 1]
	mov	w0, -1
.L1373:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	ldr	x27, [sp, 96]
	add	sp, sp, 112
	ret
.L1378:
	cmp	w2, 2
	bne	.L1380
	sub	w0, w0, #1
	add	w1, w23, w1
	add	w0, w0, w1
	orr	w0, w0, 33554432
	b	.L1398
.L1380:
	add	w0, w0, w1
	b	.L1398
.L1382:
	ldrh	w0, [x22, 22]
	add	w23, w23, 1
	add	w0, w0, 1
	strh	w0, [x22, 22]
.L1387:
	ldrh	w0, [x22, 20]
	cmp	w23, w0
	ble	.L1385
	add	w24, w24, 1
	add	x25, x25, 2
	b	.L1376
.L1386:
.L1384:
	add	x19, x19, :lo12:.LANCHOR58
	ldrh	w0, [x19, 16]
	add	w0, w0, 1
	strh	w0, [x19, 16]
	mov	w0, 0
	b	.L1373
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
	adrp	x0, .LANCHOR6
	str	x27, [sp, 80]
	stp	x21, x22, [sp, 32]
	and	x19, x20, 255
	ldr	x27, [x0, #:lo12:.LANCHOR6]
	adrp	x0, .LANCHOR22
	stp	x23, x24, [sp, 48]
	mov	w21, w1
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	add	x23, x19, 8
	stp	x25, x26, [sp, 64]
	and	w24, w1, 2097151
	mov	x25, x2
	mov	x26, x3
	ubfx	x22, x21, 24, 2
	add	x23, x27, x23, lsl 8
	tbz	x0, 4, .L1400
	adrp	x0, .LC57
	mov	w3, w4
	mov	w2, w22
	add	x0, x0, :lo12:.LC57
	bl	printf
.L1400:
	bl	nandc_wait_flash_ready
	mov	w0, w20
	bl	hynix_reconfig_rr_para
	mov	w0, w20
	bl	nandc_cs
	mov	w0, w20
	cbnz	w22, .L1401
	bl	flash_enter_slc_mode
.L1402:
	add	x19, x27, x19, lsl 8
	mov	w0, 128
	and	w21, w21, 255
	str	w0, [x19, 2056]
	lsr	w0, w24, 8
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w21, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w24, 16
	str	w0, [x19, 2052]
	mov	w0, w24
	bl	nandc_set_seed
	adrp	x0, .LANCHOR19+9
	mov	x3, x26
	mov	x2, x25
	ldrb	w1, [x0, #:lo12:.LANCHOR19+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	mov	w0, 16
	str	w0, [x19, 2056]
	bl	nandc_wait_flash_ready
	mov	x0, x23
	bl	flash_read_status
	mov	w5, w0
	cbnz	w22, .L1403
	mov	w0, w20
	bl	flash_exit_slc_mode
.L1403:
	mov	w0, w20
	bl	nandc_de_cs
	ldp	x19, x20, [sp, 16]
	and	w0, w5, 4
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1401:
	bl	flash_exit_slc_mode
	b	.L1402
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
	bne	.L1409
	adrp	x0, .LANCHOR123
	ldrb	w0, [x0, #:lo12:.LANCHOR123]
	cmp	w0, w19
	bhi	.L1413
.L1409:
	adrp	x22, .LANCHOR118
	adrp	x23, .LANCHOR119
	mov	w2, 32
	mov	w1, 165
	ldr	x0, [x22, #:lo12:.LANCHOR118]
	bl	ftl_memset
	ldr	x0, [x23, #:lo12:.LANCHOR119]
	mov	w2, 8
	mov	w1, 90
	bl	ftl_memset
	adrp	x0, .LANCHOR13
	ldrh	w20, [x0, #:lo12:.LANCHOR13]
	mov	w0, w21
	mul	w20, w20, w19
	mov	w1, w20
	bl	flash_erase_block
	cmn	w0, #1
	beq	.L1411
	adrp	x19, .LANCHOR19
	add	x19, x19, :lo12:.LANCHOR19
	ldr	x3, [x22, #:lo12:.LANCHOR118]
	mov	w1, w20
	ldr	x2, [x23, #:lo12:.LANCHOR119]
	mov	w0, w21
	ldrb	w4, [x19, 9]
	bl	flash_prog_page
	cmn	w0, #1
	beq	.L1411
	ldrb	w4, [x19, 9]
	mov	w1, w20
	ldr	x3, [x22, #:lo12:.LANCHOR118]
	mov	w0, w21
	ldr	x2, [x23, #:lo12:.LANCHOR119]
	bl	flash_read_page
	mov	w19, w0
	cmn	w0, #1
	beq	.L1411
	ldr	x0, [x23, #:lo12:.LANCHOR119]
	ldr	w1, [x0]
	mov	w0, 23130
	movk	w0, 0x5a5a, lsl 16
	cmp	w1, w0
	bne	.L1411
	ldr	x0, [x22, #:lo12:.LANCHOR118]
	ldr	w1, [x0]
	mov	w0, 42405
	movk	w0, 0xa5a5, lsl 16
	cmp	w1, w0
	beq	.L1412
.L1411:
	mov	w19, -1
.L1412:
	mov	w1, w20
	mov	w0, w21
	bl	flash_erase_block
	mov	w0, w19
.L1408:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1413:
	mov	w0, 0
	b	.L1408
	.size	flash_test_blk, .-flash_test_blk
	.section	.text.flash_start_tlc_page_prog,"ax",@progbits
	.align	2
	.global	flash_start_tlc_page_prog
	.type	flash_start_tlc_page_prog, %function
flash_start_tlc_page_prog:
	stp	x29, x30, [sp, -48]!
	and	w8, w0, 255
	adrp	x0, .LANCHOR8
	and	w3, w3, 255
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	str	x21, [sp, 32]
	cmp	w0, w3
	bhi	.L1425
	adrp	x1, .LANCHOR124
	adrp	x0, .LC0
	mov	w2, 655
	add	x1, x1, :lo12:.LANCHOR124
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1426:
	b	.L1426
.L1425:
	adrp	x0, .LANCHOR10
	add	x0, x0, :lo12:.LANCHOR10
	and	w7, w1, 255
	and	w21, w2, 255
	ldrb	w20, [x0, w3, sxtw]
	adrp	x0, .LANCHOR6
	ldr	x19, [x0, #:lo12:.LANCHOR6]
	mov	w0, w20
	bl	nandc_cs
	cbz	w8, .L1427
	sxtw	x0, w20
	add	x0, x0, 8
	add	x0, x19, x0, lsl 8
	str	w8, [x0, 8]
.L1427:
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
	adrp	x0, .LANCHOR19+9
	mov	x2, x5
	ldrb	w1, [x0, #:lo12:.LANCHOR19+9]
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
	adrp	x0, .LANCHOR90
	add	x0, x0, :lo12:.LANCHOR90
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
.L1435:
	mov	w1, 1
	mov	w0, w20
	bl	queue_lun_state
	cbnz	w0, .L1436
	mov	x0, x19
	bl	queue_tlc_prog_cmd
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1436:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1435
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
.L1439:
	mov	w1, 1
	mov	w0, w20
	bl	queue_lun_state
	cbnz	w0, .L1440
	cmp	w24, 2
	bne	.L1441
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
	adrp	x0, .LANCHOR90
	add	x0, x0, :lo12:.LANCHOR90
	bl	buf_add_tail
.L1442:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1440:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1439
.L1441:
	mov	x0, x19
	bl	queue_tlc_prog_cmd
	b	.L1442
	.size	sblk_xlc_prog_pages, .-sblk_xlc_prog_pages
	.section	.text.flash_start_page_prog,"ax",@progbits
	.align	2
	.global	flash_start_page_prog
	.type	flash_start_page_prog, %function
flash_start_page_prog:
	stp	x29, x30, [sp, -48]!
	mov	w11, w1
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	adrp	x0, .LANCHOR8
	str	x21, [sp, 32]
	ubfx	x1, x11, 21, 3
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cmp	w0, w1
	bhi	.L1445
	adrp	x1, .LANCHOR125
	adrp	x0, .LC0
	mov	w2, 692
	add	x1, x1, :lo12:.LANCHOR125
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1446:
	b	.L1446
.L1445:
	adrp	x0, .LANCHOR10
	add	x0, x0, :lo12:.LANCHOR10
	mov	x12, x2
	mov	x13, x3
	and	w10, w11, 2097151
	ldrb	w21, [x0, w1, sxtw]
	adrp	x0, .LANCHOR6
	ldr	x19, [x0, #:lo12:.LANCHOR6]
	mov	w0, w21
	bl	hynix_reconfig_rr_para
	mov	w0, w21
	bl	nandc_cs
	tst	x11, 50331648
	bne	.L1447
	adrp	x0, .LANCHOR11
	adrp	x1, .LANCHOR12
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	cbz	w0, .L1448
	ldrb	w0, [x1, #:lo12:.LANCHOR12]
	cbz	w0, .L1449
.L1448:
	adrp	x0, .LANCHOR13
	ldrb	w1, [x1, #:lo12:.LANCHOR12]
	ldrh	w2, [x0, #:lo12:.LANCHOR13]
	udiv	w0, w10, w2
	mul	w0, w0, w2
	sub	w10, w10, w0
	cbz	w1, .L1450
	add	w10, w0, w10, lsl 1
.L1449:
	mov	w0, w21
	bl	flash_enter_slc_mode
	b	.L1451
.L1450:
	adrp	x1, .LANCHOR14
	add	x1, x1, :lo12:.LANCHOR14
	ldrh	w10, [x1, w10, uxtw 1]
	add	w10, w10, w0
.L1451:
	ubfiz	x0, x21, 8, 8
	add	x19, x19, x0
	mov	w0, 128
	str	w0, [x19, 2056]
	and	w0, w10, 255
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w0, [x19, 2052]
	lsr	w0, w10, 8
	str	w0, [x19, 2052]
	lsr	w0, w10, 16
	str	w0, [x19, 2052]
	mov	w0, w10
	bl	nandc_set_seed
	mov	x3, x13
	adrp	x0, .LANCHOR19+9
	mov	x2, x12
	ldrb	w1, [x0, #:lo12:.LANCHOR19+9]
	mov	w0, 1
	bl	nandc_xfer_start
	bl	nandc_xfer_done
	mov	w0, w21
	ldr	x21, [sp, 32]
	str	w20, [x19, 2056]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	b	nandc_de_cs
.L1447:
	mov	w0, w21
	bl	flash_exit_slc_mode
	b	.L1451
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
	adrp	x0, .LANCHOR90
	ldr	w3, [x19, 40]
	ldrb	w1, [x0, #:lo12:.LANCHOR90]
	cmp	w1, 255
	beq	.L1457
	adrp	x2, .LANCHOR36
	add	x2, x2, :lo12:.LANCHOR36
	ubfx	x3, x3, 21, 3
	mov	x6, x2
.L1459:
	add	x4, x2, x1, lsl 6
	ldr	w5, [x4, 40]
	ubfx	x5, x5, 21, 3
	cmp	w3, w5
	bne	.L1458
	ldrb	w5, [x4, 58]
	cmp	w5, 6
	bne	.L1458
	mov	w1, 3
	strb	w1, [x4, 58]
.L1457:
	mov	w1, 3
	strb	w1, [x19, 58]
	mov	w1, 1
	strb	w1, [x19, 59]
	mov	w1, -1
	strb	w1, [x19]
	mov	x1, x19
	add	x0, x0, :lo12:.LANCHOR90
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	buf_add_tail
.L1458:
	lsl	x1, x1, 6
	ldrb	w1, [x6, x1]
	cmp	w1, 255
	bne	.L1459
	b	.L1457
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
	cbz	w0, .L1466
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L1466
	ldr	w1, [x19, 40]
	adrp	x0, .LC58
	mov	w2, w20
	add	x0, x0, :lo12:.LC58
	bl	printf
.L1466:
	adrp	x24, .LANCHOR23
	adrp	x22, .LANCHOR36
	add	x24, x24, :lo12:.LANCHOR23
	add	x22, x22, :lo12:.LANCHOR36
	mov	w21, 0
	mov	w23, 1
.L1467:
	cbnz	w20, .L1478
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1478:
	ldrb	w25, [x19]
	ldr	w26, [x19, 40]
.L1468:
	mov	w1, 1
	mov	w0, w26
	bl	queue_lun_state
	cbnz	w0, .L1469
	cmp	w20, 1
	beq	.L1470
	ldrb	w0, [x24]
	cbnz	w0, .L1471
.L1470:
	mov	x0, x19
	bl	queue_prog_cmd
.L1472:
	ubfiz	x19, x25, 6, 8
	sub	w20, w20, #1
	add	x19, x22, x19
	b	.L1467
.L1469:
	bl	queue_wait_first_req_completed
	bl	queue_remove_completed_req
	b	.L1468
.L1471:
	ldrb	w0, [x19]
	ubfx	x1, x26, 21, 3
	cmp	w0, 255
	bne	.L1473
	adrp	x1, .LANCHOR126
	adrp	x0, .LC0
	mov	w2, 478
	add	x1, x1, :lo12:.LANCHOR126
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1474:
	b	.L1474
.L1473:
	sbfiz	x0, x0, 6, 32
	add	x0, x22, x0
	ldr	w5, [x0, 40]
	ubfx	x0, x5, 21, 3
	cmp	w1, w0
	bne	.L1475
	adrp	x0, .LANCHOR71
	ldrh	w2, [x0, #:lo12:.LANCHOR71]
	adrp	x0, .LANCHOR70
	ldrb	w3, [x0, #:lo12:.LANCHOR70]
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
	bne	.L1475
	cmp	w21, w3
	beq	.L1475
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
	adrp	x0, .LANCHOR90
	add	x0, x0, :lo12:.LANCHOR90
	bl	buf_add_tail
	b	.L1472
.L1475:
	mov	x0, x19
	mov	w21, 0
	bl	queue_prog_cmd
	b	.L1472
	.size	sblk_prog_page, .-sblk_prog_page
	.section	.text.ftl_flush,"ax",@progbits
	.align	2
	.global	ftl_flush
	.type	ftl_flush, %function
ftl_flush:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR89
	add	x29, sp, 0
	ldrb	w1, [x0, #:lo12:.LANCHOR89]
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	adrp	x20, .LANCHOR127
	cbz	w1, .L1490
	ldrb	w2, [x20, #:lo12:.LANCHOR127]
	adrp	x0, .LANCHOR36
	add	x0, x0, :lo12:.LANCHOR36
	add	x0, x0, x2, lsl 6
	bl	sblk_prog_page
.L1490:
	mov	w0, -1
	strb	wzr, [x19, #:lo12:.LANCHOR89]
	strb	w0, [x20, #:lo12:.LANCHOR127]
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
	adrp	x0, .LANCHOR8
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	stp	x25, x26, [sp, 64]
	cmp	w0, w24
	bhi	.L1496
	adrp	x1, .LANCHOR128
	adrp	x0, .LC0
	mov	w2, 480
	add	x1, x1, :lo12:.LANCHOR128
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1497:
	b	.L1497
.L1496:
	adrp	x0, .LANCHOR10
	add	x0, x0, :lo12:.LANCHOR10
	mov	w20, w1
	mov	x23, x2
	mov	x22, x3
	mov	w25, w4
	and	w21, w5, 255
	ldrb	w26, [x0, w24, sxtw]
	tst	x20, 50331648
	bne	.L1508
	adrp	x0, .LANCHOR11
	ldrb	w1, [x0, #:lo12:.LANCHOR11]
	adrp	x0, .LANCHOR12
	cbz	w1, .L1499
	ldrb	w1, [x0, #:lo12:.LANCHOR12]
	cbz	w1, .L1508
.L1499:
	adrp	x1, .LANCHOR13
	ldrb	w0, [x0, #:lo12:.LANCHOR12]
	ldrh	w1, [x1, #:lo12:.LANCHOR13]
	udiv	w19, w20, w1
	mul	w19, w19, w1
	sub	w1, w20, w19
	cbz	w0, .L1500
	add	w19, w19, w1, lsl 1
.L1498:
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 4, .L1501
	adrp	x0, .LC59
	mov	w2, w20
	mov	w1, w26
	add	x0, x0, :lo12:.LC59
	bl	printf
.L1501:
	mov	w0, w26
	mov	w4, w25
	mov	x3, x22
	mov	x2, x23
	mov	w1, w19
	bl	flash_prog_page
	mov	w26, w0
	cbz	w21, .L1502
	adrp	x21, .LANCHOR118
	adrp	x19, .LANCHOR119
	mov	w4, w25
	mov	w1, w20
	ldr	x3, [x21, #:lo12:.LANCHOR118]
	mov	w0, w24
	ldr	x2, [x19, #:lo12:.LANCHOR119]
	bl	flash_read_page_en
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L1503
	ldr	x0, [x19, #:lo12:.LANCHOR119]
	ldr	w1, [x23]
	ldr	w0, [x0]
	cmp	w1, w0
	bne	.L1503
	ldr	x0, [x21, #:lo12:.LANCHOR118]
	ldr	w1, [x22]
	ldr	w0, [x0]
	cmp	w1, w0
	beq	.L1502
.L1503:
	ldr	x1, [x21, #:lo12:.LANCHOR118]
	mov	w3, 4
	adrp	x0, .LC60
	mov	w2, w3
	add	x0, x0, :lo12:.LC60
	bl	rknand_print_hex
	ldr	x1, [x19, #:lo12:.LANCHOR119]
	mov	w3, 4
	adrp	x0, .LC61
	mov	w2, w3
	add	x0, x0, :lo12:.LC61
	bl	rknand_print_hex
.L1504:
	mov	w1, w20
	adrp	x0, .LC62
	add	x0, x0, :lo12:.LC62
	bl	printf
	adrp	x1, .LANCHOR128
	adrp	x0, .LC0
	mov	w2, 506
	add	x1, x1, :lo12:.LANCHOR128
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1506:
	b	.L1506
.L1500:
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	ldrh	w0, [x0, w1, uxtw 1]
	add	w19, w0, w19
	b	.L1498
.L1508:
	mov	w19, w20
	b	.L1498
.L1502:
	cmn	w26, #1
	beq	.L1504
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
	stp	x21, x22, [sp, 32]
	adrp	x21, ftl_tmp_buffer
	adrp	x22, .LANCHOR121
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR76
	add	x24, x24, :lo12:.LANCHOR76
	stp	x25, x26, [sp, 64]
	and	w26, w0, 65535
	stp	x19, x20, [sp, 16]
	adrp	x25, .LANCHOR70
	stp	x27, x28, [sp, 80]
	add	x0, x25, :lo12:.LANCHOR70
	str	wzr, [x21, #:lo12:ftl_tmp_buffer]
	mov	w19, 0
	str	wzr, [x22, #:lo12:.LANCHOR121]
	str	x0, [x29, 112]
.L1520:
	ldrb	w0, [x24]
	cmp	w0, w19
	bls	.L1527
	add	x0, x25, :lo12:.LANCHOR70
	adrp	x23, .LANCHOR22
	mov	w20, 0
	add	x23, x23, :lo12:.LANCHOR22
	str	x0, [x29, 120]
	b	.L1528
.L1526:
	ldr	w0, [x23]
	tbz	x0, 12, .L1521
	adrp	x0, .LC63
	mov	w1, w26
	add	x0, x0, :lo12:.LC63
	bl	printf
.L1521:
	ldr	x0, [x29, 112]
	ldrb	w6, [x0]
	madd	w6, w26, w6, w20
	and	w28, w6, 65535
	cbnz	w19, .L1522
	adrp	x0, .LANCHOR5
	ldr	x0, [x0, #:lo12:.LANCHOR5]
	ldrb	w0, [x0, 47]
	cmp	w0, w28
	bcs	.L1523
.L1522:
	and	w27, w19, 255
	mov	w1, w28
	mov	w0, w27
	bl	flash_check_bad_block
	cbnz	w0, .L1523
	adrp	x0, .LANCHOR75
	ldrh	w8, [x0, #:lo12:.LANCHOR75]
	mov	w0, w27
	mul	w8, w8, w28
	str	w8, [x29, 108]
	mov	w1, w8
	bl	flash_erase_block
	ldr	w8, [x29, 108]
	cbz	w0, .L1525
.L1536:
	mov	w1, w28
	mov	w0, w27
	bl	flash_mask_bad_block
	b	.L1523
.L1525:
	adrp	x0, .LANCHOR45
	mov	w5, 1
	add	x3, x22, :lo12:.LANCHOR121
	add	x2, x21, :lo12:ftl_tmp_buffer
	ldrb	w4, [x0, #:lo12:.LANCHOR45]
	mov	w1, w8
	mov	w0, w27
	bl	flash_prog_page_en
	cbnz	w0, .L1536
.L1523:
	add	w20, w20, 1
	and	w20, w20, 65535
.L1528:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, w20
	bhi	.L1526
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1520
.L1527:
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
	bne	.L1537
	adrp	x1, .LANCHOR129
	adrp	x0, .LC0
	mov	w2, 1414
	add	x1, x1, :lo12:.LANCHOR129
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1539:
	b	.L1539
.L1537:
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
	adrp	x21, .LANCHOR45
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR131
	ldrb	w2, [x21, #:lo12:.LANCHOR45]
	mov	x23, x22
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR75
	stp	x27, x28, [sp, 80]
	mov	w26, 0
	stp	x19, x20, [sp, 16]
	lsl	w2, w2, 1
	adrp	x20, .LANCHOR130
	str	w0, [x29, 108]
	mov	x24, x25
	add	x27, x22, :lo12:.LANCHOR131
	add	x28, x25, :lo12:.LANCHOR75
	add	x0, x20, :lo12:.LANCHOR130
	bl	ftl_memset
.L1542:
	add	x0, x22, :lo12:.LANCHOR131
	ldr	w1, [x29, 108]
	ldrb	w6, [x22, #:lo12:.LANCHOR131]
	ldrh	w19, [x25, #:lo12:.LANCHOR75]
	ldrh	w4, [x0, 2]
	adrp	x0, .LANCHOR46
	ldr	x0, [x0, #:lo12:.LANCHOR46]
	ldr	w3, [x0, 4]
	add	w3, w3, 1
	str	w3, [x0, 4]
	add	x0, x20, :lo12:.LANCHOR130
	str	w1, [x20, #:lo12:.LANCHOR130]
	str	w3, [x0, 4]
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L1543
	mov	w2, w4
	mov	w1, w6
	stp	w4, w6, [x29, 100]
	adrp	x0, .LC64
	add	x0, x0, :lo12:.LC64
	bl	printf
	ldp	w4, w6, [x29, 100]
.L1543:
	adrp	x1, .LANCHOR79
	ldrh	w0, [x27, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR79]
	cmp	w1, w0
	bhi	.L1544
	adrp	x1, .LANCHOR5
	ldrb	w0, [x27, 1]
	ldrb	w2, [x27]
	mov	w4, 0
	ldr	x6, [x1, #:lo12:.LANCHOR5]
.L1551:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 7
	bls	.L1545
	mov	x1, 0
.L1550:
	add	x3, x6, x1
	and	w7, w1, 65535
	ldrb	w8, [x3, 40]
	add	w3, w8, 127
	and	w3, w3, 255
	cmp	w3, 125
	bhi	.L1546
	add	x1, x23, :lo12:.LANCHOR131
	strb	w0, [x1, 1]
	cbz	w4, .L1547
	strb	w2, [x23, #:lo12:.LANCHOR131]
.L1547:
	adrp	x1, .LANCHOR132
	adrp	x0, .LC0
	mov	w2, 156
	add	x1, x1, :lo12:.LANCHOR132
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1548:
	b	.L1548
.L1546:
	cmp	w8, 255
	bne	.L1549
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L1550
	mov	w7, w1
.L1549:
	and	w0, w7, 255
	mov	w26, 1
.L1545:
	add	w1, w0, 8
	mov	w4, 1
	add	x1, x6, x1, sxtw
	ldrb	w2, [x1, 32]
	cmp	w2, 255
	beq	.L1551
	ldrh	w19, [x28]
	strb	w0, [x27, 1]
	mov	w0, 0
	strb	w2, [x27]
	mul	w19, w19, w2
	mov	w1, w19
	bl	flash_erase_block
	ldrb	w4, [x21, #:lo12:.LANCHOR45]
	mov	w1, w19
	add	x3, x20, :lo12:.LANCHOR130
	adrp	x2, ftl_info_data_buffer
	mov	w0, 0
	add	x2, x2, :lo12:ftl_info_data_buffer
	bl	ftl_prog_page
	mov	w0, 1
	add	w19, w19, w0
	strh	w0, [x27, 2]
.L1552:
	ldrb	w4, [x21, #:lo12:.LANCHOR45]
	mov	w1, w19
	add	x3, x20, :lo12:.LANCHOR130
	adrp	x2, ftl_info_data_buffer
	mov	w0, 0
	add	x2, x2, :lo12:ftl_info_data_buffer
	bl	ftl_prog_page
	cmn	w0, #1
	ldrh	w1, [x27, 2]
	add	w1, w1, 1
	strh	w1, [x27, 2]
	beq	.L1542
	cbnz	w26, .L1553
.L1561:
	ldrb	w0, [x23, #:lo12:.LANCHOR131]
	cmp	w0, 255
	bne	.L1577
	adrp	x1, .LANCHOR132
	adrp	x0, .LC0
	mov	w2, 191
	add	x1, x1, :lo12:.LANCHOR132
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1562:
	b	.L1562
.L1544:
	madd	w19, w19, w6, w4
	cbnz	w0, .L1552
	mov	w1, w19
	bl	flash_erase_block
	b	.L1552
.L1553:
	ldrb	w19, [x27, 1]
	add	x24, x24, :lo12:.LANCHOR75
	adrp	x20, .LANCHOR5
	add	w19, w19, 1
.L1556:
	cmp	w19, 7
	bhi	.L1561
	ldr	x1, [x20, #:lo12:.LANCHOR5]
	add	w0, w19, 8
	add	x0, x1, x0, sxtw
	ldrb	w0, [x0, 32]
	add	w1, w0, 127
	and	w1, w1, 255
	cmp	w1, 125
	bhi	.L1557
	adrp	x1, .LANCHOR132
	adrp	x0, .LC0
	mov	w2, 184
	add	x1, x1, :lo12:.LANCHOR132
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1558:
	b	.L1558
.L1557:
	cmp	w0, 255
	beq	.L1559
	ldrh	w1, [x24]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_erase_block
.L1559:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1556
.L1577:
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
	adrp	x0, .LANCHOR133
	adrp	x1, .LANCHOR59
	mov	w2, 16384
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, ftl_info_data_buffer
	strb	wzr, [x0, #:lo12:.LANCHOR133]
	add	x0, x20, :lo12:ftl_info_data_buffer
	str	x0, [x1, #:lo12:.LANCHOR59]
	adrp	x1, .LANCHOR54
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR46
	ldrh	w1, [x1, #:lo12:.LANCHOR54]
	adrp	x21, .LANCHOR131
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR75
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR5
	add	x1, x0, x1, lsl 2
	stp	x27, x28, [sp, 80]
	str	x1, [x22, #:lo12:.LANCHOR46]
	mov	w1, 0
	bl	ftl_memset
	adrp	x25, .LANCHOR45
	mov	w1, 0
	mov	w2, 16384
	adrp	x0, ftl_ext_info_data_buffer
	add	x0, x0, :lo12:ftl_ext_info_data_buffer
	bl	ftl_memset
	mov	w27, 21574
	ldr	x1, [x23, #:lo12:.LANCHOR5]
	add	x0, x21, :lo12:.LANCHOR131
	add	x26, x26, :lo12:.LANCHOR75
	add	x25, x25, :lo12:.LANCHOR45
	mov	x19, 7
	movk	w27, 0x494c, lsl 16
	strb	wzr, [x0, 1]
	ldrb	w1, [x1, 40]
	strb	w1, [x21, #:lo12:.LANCHOR131]
	strh	wzr, [x0, 2]
.L1581:
	ldr	x1, [x23, #:lo12:.LANCHOR5]
	add	w0, w19, 8
	sxth	w24, w19
	mov	w28, w19
	add	x0, x1, x0, sxtw
	ldrb	w0, [x0, 32]
	cmp	w0, 255
	bne	.L1580
.L1585:
	sub	x19, x19, #1
	cmn	x19, #1
	bne	.L1581
	mov	w24, 0
.L1582:
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L1586
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	mov	w2, 4800
	mov	w1, w19
	ldr	w3, [x0]
	adrp	x0, .LC66
	add	x0, x0, :lo12:.LC66
	bl	printf
.L1586:
	cmn	w19, #1
	bne	.L1587
	mov	w1, 0
	mov	w2, 16384
	add	x0, x20, :lo12:ftl_info_data_buffer
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	mov	w1, 21574
	movk	w1, 0x494c, lsl 16
	str	w1, [x0]
	mov	w0, w19
.L1579:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1580:
	ldrh	w6, [x26]
	add	x8, x20, :lo12:ftl_info_data_buffer
	ldrb	w4, [x25]
	adrp	x7, .LANCHOR130
	add	x7, x7, :lo12:.LANCHOR130
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
	bne	.L1583
	ldrb	w4, [x25]
	mov	x3, x7
	mov	x2, x8
	add	w1, w6, 1
	mov	w0, 0
	bl	ftl_read_page
	mov	w5, w0
.L1583:
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L1584
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	mov	w2, w5
	str	w5, [x29, 124]
	mov	w3, 64
	mov	w1, w28
	ldr	w4, [x0]
	adrp	x0, .LC65
	add	x0, x0, :lo12:.LC65
	bl	printf
	ldr	w5, [x29, 124]
.L1584:
	cmn	w5, #1
	beq	.L1585
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L1585
	mov	w19, w24
	b	.L1582
.L1587:
	ldr	x1, [x23, #:lo12:.LANCHOR5]
	add	w0, w24, 8
	add	x20, x20, :lo12:ftl_info_data_buffer
	mov	w4, 4
	mov	x2, x20
	adrp	x26, .LANCHOR45
	add	x0, x1, x0, sxtw
	mov	w27, 21574
	add	x26, x26, :lo12:.LANCHOR45
	movk	w27, 0x494c, lsl 16
	ldrb	w1, [x0, 32]
	add	x0, x21, :lo12:.LANCHOR131
	strb	w1, [x21, #:lo12:.LANCHOR131]
	strb	w24, [x0, 1]
	adrp	x24, .LANCHOR130
	add	x24, x24, :lo12:.LANCHOR130
	mov	w0, 0
	mov	x3, x24
	bl	flash_get_last_written_page
	sxth	w23, w0
	add	w0, w0, 1
	and	w19, w0, 65535
	adrp	x0, .LANCHOR75
	ldrb	w25, [x21, #:lo12:.LANCHOR131]
	ldrh	w0, [x0, #:lo12:.LANCHOR75]
	madd	w25, w25, w0, w23
.L1589:
	tbnz	w23, #31, .L1594
	ldrb	w4, [x26]
	mov	x3, x24
	mov	x2, x20
	mov	w1, w25
	mov	w0, 0
	bl	ftl_read_page
	cmn	w0, #1
	beq	.L1590
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L1590
.L1594:
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	add	x21, x21, :lo12:.LANCHOR131
	strh	w19, [x21, 2]
	ldr	w1, [x0, 16]
	cmp	w1, 2048
	bhi	.L1591
.L1592:
	ldr	w1, [x0, 24]
	cmp	w1, 2048
	bls	.L1595
	ldr	w2, [x0, 28]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 24]
.L1595:
	ldr	w1, [x0, 32]
	cmp	w1, 1024
	bls	.L1596
	ldr	w2, [x0, 36]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 32]
.L1596:
	ldr	w1, [x0, 40]
	cmp	w1, 1024
	bls	.L1597
	ldr	w2, [x0, 44]
	add	w2, w2, w1, lsr 10
	and	w1, w1, 1023
	stp	w1, w2, [x0, 40]
.L1597:
	ldr	w1, [x0, 64]
	add	w1, w1, 1
	str	w1, [x0, 64]
	mov	w0, 0
	bl	ftl_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	mov	w0, 0
	b	.L1579
.L1590:
	sub	w23, w23, #1
	sub	w25, w25, #1
	sxth	w23, w23
	b	.L1589
.L1591:
	ldr	w2, [x0, 20]
	add	w2, w2, w1, lsr 11
	and	w1, w1, 2047
	stp	w1, w2, [x0, 16]
	b	.L1592
	.size	ftl_info_blk_init, .-ftl_info_blk_init
	.section	.text.ftl_ext_info_flush,"ax",@progbits
	.align	2
	.global	ftl_ext_info_flush
	.type	ftl_ext_info_flush, %function
ftl_ext_info_flush:
	stp	x29, x30, [sp, -96]!
	adrp	x0, .LANCHOR60
	add	x29, sp, 0
	ldr	x0, [x0, #:lo12:.LANCHOR60]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldr	w1, [x0, 520]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	cbz	w1, .L1613
	str	wzr, [x0, 520]
.L1613:
	adrp	x24, .LANCHOR46
	adrp	x20, .LANCHOR79
	adrp	x21, .LANCHOR71
	add	x20, x20, :lo12:.LANCHOR79
	mov	x22, x24
	add	x21, x21, :lo12:.LANCHOR71
	mov	w0, 0
	bl	ftl_total_vpn_update
.L1622:
	ldr	x0, [x24, #:lo12:.LANCHOR46]
	ldr	w1, [x0, 56]
	add	w1, w1, 1
	str	w1, [x0, 56]
	ldrh	w1, [x0, 140]
	ldrh	w0, [x20]
	cmp	w1, w0
	bcc	.L1614
	bl	ftl_ext_alloc_new_blk
.L1614:
	ldr	x2, [x22, #:lo12:.LANCHOR46]
	mov	w0, 65535
	ldrh	w1, [x2, 130]
	cmp	w1, w0
	bne	.L1615
	adrp	x1, .LANCHOR134
	adrp	x0, .LC0
	mov	w2, 1048
	add	x1, x1, :lo12:.LANCHOR134
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1616:
	b	.L1616
.L1615:
	ldrh	w0, [x21]
	mov	w19, 21
	adrp	x25, .LANCHOR45
	adrp	x26, .LANCHOR130
	sub	w0, w19, w0
	mov	w19, 1
	add	x23, x26, :lo12:.LANCHOR130
	asr	w27, w1, w0
	lsl	w19, w19, w0
	adrp	x0, .LANCHOR75
	sub	w19, w19, #1
	and	w19, w19, w1
	ldrh	w1, [x0, #:lo12:.LANCHOR75]
	ldrh	w0, [x2, 140]
	ldrb	w2, [x25, #:lo12:.LANCHOR45]
	madd	w19, w19, w1, w0
	lsl	w2, w2, 1
	mov	w1, 0
	mov	x0, x23
	bl	ftl_memset
	and	w19, w19, 65535
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	mov	w1, w19
	ldrb	w4, [x25, #:lo12:.LANCHOR45]
	mov	x3, x23
	str	wzr, [x26, #:lo12:.LANCHOR130]
	adrp	x2, ftl_ext_info_data_buffer
	add	x2, x2, :lo12:ftl_ext_info_data_buffer
	ldr	w0, [x0, 56]
	str	w0, [x23, 4]
	mov	w0, w27
	bl	ftl_prog_page
	ldr	x2, [x22, #:lo12:.LANCHOR46]
	ldrh	w1, [x2, 140]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 140]
	cmp	w1, 1
	beq	.L1622
	cmn	w0, #1
	beq	.L1622
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
	adrp	x0, .LANCHOR86
	mov	w4, 4
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR46
	strh	wzr, [x0, #:lo12:.LANCHOR86]
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	adrp	x25, ftl_ext_info_data_buffer
	stp	x23, x24, [sp, 48]
	add	x2, x25, :lo12:ftl_ext_info_data_buffer
	ldrh	w19, [x0, 130]
	adrp	x0, .LANCHOR71
	stp	x27, x28, [sp, 80]
	adrp	x24, .LANCHOR130
	ldrh	w1, [x0, #:lo12:.LANCHOR71]
	mov	w0, 21
	and	w26, w19, 16383
	add	x3, x24, :lo12:.LANCHOR130
	sub	w0, w0, w1
	mov	w1, w26
	asr	w19, w19, w0
	and	w19, w19, 255
	mov	w0, w19
	bl	flash_get_last_written_page
	sxth	w21, w0
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L1628
	adrp	x1, .LANCHOR135
	adrp	x0, .LC28
	mov	w3, w21
	mov	w2, 1091
	add	x1, x1, :lo12:.LANCHOR135
	add	x0, x0, :lo12:.LC28
	bl	printf
.L1628:
	adrp	x27, .LANCHOR45
	adrp	x28, .LANCHOR75
	mov	w5, 20038
	add	x27, x27, :lo12:.LANCHOR45
	add	x28, x28, :lo12:.LANCHOR75
	mov	w23, 0
	movk	w5, 0x4549, lsl 16
.L1629:
	and	w20, w21, 65535
	sub	w0, w20, w23
	tbnz	x0, 15, .L1634
	ldrh	w0, [x28]
	sub	w1, w21, w23
	ldrb	w4, [x27]
	add	x3, x24, :lo12:.LANCHOR130
	str	w5, [x29, 108]
	add	x2, x25, :lo12:ftl_ext_info_data_buffer
	madd	w1, w0, w26, w1
	mov	w0, w19
	bl	flash_read_page_en
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	ldr	w5, [x29, 108]
	beq	.L1630
	adrp	x0, .LANCHOR60
	ldr	x0, [x0, #:lo12:.LANCHOR60]
	ldr	w0, [x0]
	cmp	w0, w5
	bne	.L1630
.L1634:
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	ldrh	w1, [x0, 140]
	cmp	w1, w21
	bgt	.L1632
	add	w20, w20, 1
	strh	w20, [x0, 140]
	bl	ftl_ext_info_flush
.L1632:
	adrp	x0, .LANCHOR60
	mov	w1, -1
	ldp	x19, x20, [sp, 16]
	ldr	x0, [x0, #:lo12:.LANCHOR60]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	str	wzr, [x0, 520]
	adrp	x0, .LANCHOR87
	strh	w1, [x0, #:lo12:.LANCHOR87]
	mov	w0, 0
	ldp	x29, x30, [sp], 112
	ret
.L1630:
	add	w23, w23, 1
	b	.L1629
	.size	ftl_ext_info_init, .-ftl_ext_info_init
	.section	.text.ftl_low_format,"ax",@progbits
	.align	2
	.global	ftl_low_format
	.type	ftl_low_format, %function
ftl_low_format:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR75
	stp	x21, x22, [sp, 32]
	add	x20, x20, :lo12:.LANCHOR75
	stp	x23, x24, [sp, 48]
	adrp	x21, .LANCHOR5
	mov	x24, x21
	stp	x25, x26, [sp, 64]
	mov	w19, 8
.L1646:
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	add	x0, x0, x19, sxtw
	ldrb	w0, [x0, 32]
	add	w1, w0, 127
	and	w1, w1, 255
	cmp	w1, 125
	bhi	.L1643
	adrp	x1, .LANCHOR136
	adrp	x0, .LC0
	mov	w2, 1228
	add	x1, x1, :lo12:.LANCHOR136
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1644:
	b	.L1644
.L1643:
	cmp	w0, 255
	beq	.L1645
	ldrh	w1, [x20]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_erase_block
.L1645:
	add	w19, w19, 1
	cmp	w19, 16
	bne	.L1646
	bl	sblk_init
	adrp	x19, .LANCHOR46
	bl	ftl_info_blk_init
	adrp	x20, .LANCHOR54
	mov	w1, 0
	mov	w2, 16384
	adrp	x0, ftl_info_data_buffer
	add	x0, x0, :lo12:ftl_info_data_buffer
	bl	ftl_memset
	add	x25, x20, :lo12:.LANCHOR54
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	mov	w1, 21574
	movk	w1, 0x494c, lsl 16
	mov	w21, 0
	mov	w26, 1
	str	w1, [x0]
.L1647:
	ldrh	w0, [x25]
	adrp	x22, .LANCHOR70
	adrp	x23, .LANCHOR59
	cmp	w0, w21
	bhi	.L1655
	adrp	x21, .LANCHOR60
	mov	w1, 0
	mov	w2, 16384
	adrp	x0, ftl_ext_info_data_buffer
	add	x0, x0, :lo12:ftl_ext_info_data_buffer
	bl	ftl_memset
	ldr	x0, [x21, #:lo12:.LANCHOR60]
	mov	w1, 20038
	movk	w1, 0x4549, lsl 16
	mov	w3, 3
	str	w1, [x0]
	ldr	x0, [x24, #:lo12:.LANCHOR5]
	ldrb	w5, [x22, #:lo12:.LANCHOR70]
	ldr	x1, [x23, #:lo12:.LANCHOR59]
	cmp	w5, 1
	ldrb	w0, [x0, 47]
	csinc	w3, w3, wzr, ne
	and	w3, w3, 255
	udiv	w0, w0, w5
	add	w24, w0, 1
	ubfiz	x0, x0, 2, 8
	add	x0, x0, 4
	add	x0, x1, x0
.L1656:
	ldrb	w2, [x1, 2]
	add	x1, x1, 4
	strb	w3, [x1, -1]
	orr	w2, w2, -32
	and	w2, w2, -25
	strb	w2, [x1, -2]
	cmp	x1, x0
	bne	.L1656
	mov	w4, 16
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	sdiv	w4, w4, w5
	add	w4, w24, w4
	and	w4, w4, 65535
	strh	w4, [x0, 134]
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L1657
	adrp	x0, .LC67
	mov	w3, w24
	mov	w2, 128
	mov	w1, 1265
	add	x0, x0, :lo12:.LC67
	bl	printf
.L1657:
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	mov	w2, 128
	mov	w1, 255
	add	x0, x0, 160
	bl	ftl_memset
	ldrb	w11, [x22, #:lo12:.LANCHOR70]
	adrp	x0, .LANCHOR76
	adrp	x22, .LANCHOR71
	ldr	x3, [x19, #:lo12:.LANCHOR46]
	and	w13, w11, 65535
	ldrb	w12, [x0, #:lo12:.LANCHOR76]
	ldrh	w0, [x22, #:lo12:.LANCHOR71]
	mov	w5, 21
	ldr	x2, [x23, #:lo12:.LANCHOR59]
	mov	w4, 0
	sub	w0, w5, w0
	mul	w1, w24, w13
	mov	w5, 1
	ldrh	w7, [x3, 134]
	lsl	w5, w5, w0
	and	w1, w1, 65535
	and	w5, w5, 65535
.L1658:
	cmp	w24, w7
	bcc	.L1664
	ldrh	w5, [x20, #:lo12:.LANCHOR54]
	add	x0, x2, x7, uxth 2
	mov	w1, w7
	mov	w6, 1
.L1665:
	cmp	w1, w5
	bcc	.L1666
	sub	w5, w5, w7
	strh	w4, [x3, 112]
	strh	w5, [x3, 116]
	mov	w0, 1
	strh	wzr, [x3, 114]
	strh	wzr, [x3, 118]
	bl	ftl_alloc_sblk
	mov	w23, w0
	mov	w1, 0
	bl	ftl_erase_sblk
	ldr	x1, [x19, #:lo12:.LANCHOR46]
	mov	w0, w23
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	mov	w1, 65533
	ldrh	w20, [x0, 672]
	strh	wzr, [x0, 690]
	sub	w2, w20, #1
	cmp	w1, w2, uxth
	bcs	.L1667
	adrp	x1, .LANCHOR136
	adrp	x0, .LC0
	mov	w2, 1297
	add	x1, x1, :lo12:.LANCHOR136
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1668:
	b	.L1668
.L1655:
	adrp	x0, .LANCHOR53
	strh	w21, [x0, #:lo12:.LANCHOR53]
	mov	w0, w21
	bl	ftl_test_block
	ldrb	w11, [x22, #:lo12:.LANCHOR70]
	adrp	x0, .LANCHOR76
	ldr	x6, [x23, #:lo12:.LANCHOR59]
	mov	w8, 0
	ldrb	w13, [x0, #:lo12:.LANCHOR76]
	mov	w7, 1
	mov	w10, 0
	mul	w12, w21, w11
	add	x6, x6, x21, uxth 2
	add	w13, w13, 1
.L1648:
	cmp	w7, w13
	beq	.L1652
	add	w15, w11, w8
	sub	w14, w7, #1
	b	.L1653
.L1651:
	add	w1, w8, w12
	mov	w0, w14
	bl	flash_check_bad_block
	cbz	w0, .L1649
	ldrb	w1, [x6, 3]
	lsl	w0, w26, w8
	orr	w0, w0, w1
	strb	w0, [x6, 3]
.L1650:
	add	w8, w8, 1
.L1653:
	cmp	w8, w15
	bne	.L1651
	add	w7, w7, 1
	sub	w12, w12, w11
	and	w7, w7, 65535
	b	.L1648
.L1649:
	add	w10, w10, 1
	and	w10, w10, 65535
	b	.L1650
.L1652:
	cbnz	w10, .L1654
	ldrb	w0, [x6, 2]
	orr	w0, w0, -32
	strb	w0, [x6, 2]
.L1654:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L1647
.L1664:
	add	x14, x2, x24, uxth 2
	mov	w15, 0
	mov	w16, 0
	mov	w6, 0
	ldrb	w0, [x14, 2]
	orr	w0, w0, -32
	and	w0, w0, -25
	strb	w0, [x14, 2]
.L1659:
	cmp	w6, w12
	bcc	.L1670
	add	w24, w24, 1
	add	w1, w13, w1
	and	w24, w24, 65535
	and	w1, w1, 65535
	b	.L1658
.L1662:
	ldrb	w10, [x14, 3]
	add	w17, w16, w8
	asr	w10, w10, w17
	tbnz	x10, 0, .L1660
	cmp	w11, 1
	bls	.L1669
	and	w0, w0, 1
	add	w0, w1, w0
	and	w0, w0, 65535
.L1661:
	add	x10, x3, x4, sxtw 1
	add	w4, w4, 1
	and	w4, w4, 65535
	add	w0, w0, w15
	strh	w0, [x10, 160]
.L1660:
	add	x8, x8, 1
.L1663:
	and	w0, w8, 65535
	cmp	w0, w13
	bcc	.L1662
	add	w6, w6, 1
	add	w0, w5, w15
	and	w6, w6, 65535
	add	w16, w16, w11
	and	w15, w0, 65535
	b	.L1659
.L1669:
	mov	w0, w1
	b	.L1661
.L1670:
	mov	x8, 0
	b	.L1663
.L1666:
	ldrb	w2, [x0, 2]
	add	w1, w1, 1
	and	w1, w1, 65535
	add	x0, x0, 4
	and	w2, w2, 31
	bfi	w2, w6, 3, 2
	strb	w2, [x0, -2]
	b	.L1665
.L1667:
	strh	wzr, [x0, 696]
	mov	w2, 256
	mov	w1, 255
	add	x0, x0, 416
	bl	ftl_memset
	ldrh	w2, [x22, #:lo12:.LANCHOR71]
	mov	w1, 21
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	sub	w1, w1, w2
	asr	w1, w20, w1
	strh	w1, [x0, 694]
	mov	w1, 1
	strh	w1, [x0, 688]
	adrp	x1, .LANCHOR137
	strh	w20, [x0, 692]
	ldrh	w1, [x1, #:lo12:.LANCHOR137]
	strh	w23, [x0, 416]
	strh	w1, [x0, 698]
	bl	ftl_alloc_sys_blk
	mov	w20, w0
	mov	w1, 0
	bl	ftl_erase_phy_blk
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	mov	w1, 2
	strh	w20, [x0, 130]
	ldr	x0, [x21, #:lo12:.LANCHOR60]
	add	x0, x0, 16
	bl	ftl_open_sblk_init
	ldr	x0, [x21, #:lo12:.LANCHOR60]
	mov	w1, 3
	add	x0, x0, 48
	bl	ftl_open_sblk_init
	ldr	x1, [x19, #:lo12:.LANCHOR46]
	ldr	x0, [x21, #:lo12:.LANCHOR60]
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
	ldr	x0, [x21, #:lo12:.LANCHOR60]
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
	stp	x29, x30, [sp, -48]!
	mov	w1, 1
	adrp	x0, .LC68
	add	x0, x0, :lo12:.LC68
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR46
	stp	x21, x22, [sp, 32]
	bl	printf
	bl	sblk_init
	adrp	x21, .LANCHOR54
	bl	ftl_info_blk_init
	bl	ftl_ext_info_init
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	adrp	x2, .LANCHOR59
	ldrh	w7, [x21, #:lo12:.LANCHOR54]
	mov	w3, 0
	ldr	x2, [x2, #:lo12:.LANCHOR59]
	mov	w4, 0
	mov	w5, 0
	ldrh	w1, [x0, 134]
	add	x2, x2, x1, uxth 2
.L1681:
	cmp	w1, w7
	bcc	.L1685
	strh	w5, [x0, 114]
	strh	w4, [x0, 118]
	strh	w3, [x0, 116]
	strh	wzr, [x0, 122]
	strh	wzr, [x0, 120]
	strh	wzr, [x0, 124]
	mov	w0, 1
	bl	ftl_alloc_sblk
	mov	w22, w0
	mov	w1, 0
	bl	ftl_erase_sblk
	ldr	x1, [x19, #:lo12:.LANCHOR46]
	mov	w0, w22
	add	x1, x1, 672
	bl	ftl_get_blk_list_in_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	mov	w1, 65533
	ldrh	w20, [x0, 672]
	strh	wzr, [x0, 690]
	sub	w2, w20, #1
	cmp	w1, w2, uxth
	bcs	.L1686
	adrp	x1, .LANCHOR138
	adrp	x0, .LC0
	mov	w2, 1366
	add	x1, x1, :lo12:.LANCHOR138
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1687:
	b	.L1687
.L1685:
	ldrb	w6, [x2, 2]
	and	w8, w6, 31
	strb	w8, [x2, 2]
	ands	w6, w6, 24
	bne	.L1682
	add	w5, w5, 1
	and	w5, w5, 65535
.L1683:
	add	w1, w1, 1
	add	x2, x2, 4
	and	w1, w1, 65535
	b	.L1681
.L1682:
	cmp	w6, 16
	bne	.L1684
	add	w4, w4, 1
	and	w4, w4, 65535
	b	.L1683
.L1684:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L1683
.L1686:
	strh	wzr, [x0, 696]
	mov	w2, 256
	mov	w1, 255
	add	x0, x0, 416
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	mov	w2, 4096
	mov	w1, 0
	add	x0, x0, 704
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	lsr	w1, w20, 14
	and	w20, w20, 16383
	ldrh	w2, [x21, #:lo12:.LANCHOR54]
	strh	w1, [x0, 694]
	mov	w1, 1
	strh	w1, [x0, 688]
	adrp	x1, .LANCHOR137
	strh	w20, [x0, 692]
	adrp	x20, .LANCHOR60
	ldrh	w1, [x1, #:lo12:.LANCHOR137]
	lsl	w2, w2, 1
	strh	w22, [x0, 416]
	strh	w1, [x0, 698]
	adrp	x0, .LANCHOR56
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR56]
	bl	ftl_memset
	ldr	x0, [x20, #:lo12:.LANCHOR60]
	mov	w1, 2
	add	x0, x0, 16
	bl	ftl_open_sblk_init
	ldr	x0, [x20, #:lo12:.LANCHOR60]
	mov	w1, 3
	add	x0, x0, 48
	bl	ftl_open_sblk_init
	ldr	x1, [x19, #:lo12:.LANCHOR46]
	ldr	x0, [x20, #:lo12:.LANCHOR60]
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
	ldr	x0, [x20, #:lo12:.LANCHOR60]
	mov	w2, 128
	mov	w1, 255
	add	x0, x0, 392
	bl	ftl_memset
	ldr	x0, [x20, #:lo12:.LANCHOR60]
	str	wzr, [x0, 520]
	str	wzr, [x0, 524]
	str	wzr, [x0, 528]
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	ftl_info_blk_init
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
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
	bne	.L1692
	stp	x29, x30, [sp, -48]!
	adrp	x1, .LANCHOR82
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	ldr	x20, [x1, #:lo12:.LANCHOR82]
	ldrh	w22, [x0, 12]
	bl	ftl_get_new_free_page
	mov	w21, w0
	cmn	w0, #1
	beq	.L1693
	ldrh	w0, [x19]
	add	x20, x20, x22, uxth 2
	bl	ftl_vpn_decrement
	adrp	x0, .LANCHOR121
	mov	w1, 15555
	add	x6, x0, :lo12:.LANCHOR121
	movk	w1, 0xf55f, lsl 16
	str	w1, [x0, #:lo12:.LANCHOR121]
	adrp	x0, .LANCHOR79
	ldrh	w1, [x0, #:lo12:.LANCHOR79]
	adrp	x0, .LANCHOR69
	ldrb	w0, [x0, #:lo12:.LANCHOR69]
	mul	w1, w1, w0
	mov	x0, x20
	lsl	w1, w1, 2
	bl	js_hash
	str	w0, [x6, 4]
	adrp	x0, .LANCHOR45
	mov	x2, x6
	mov	x1, x20
	ldrb	w3, [x0, #:lo12:.LANCHOR45]
	mov	w0, w21
	bl	ftl_prog_ppa_page
.L1693:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L1692:
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
	adrp	x22, .LANCHOR22
	stp	x27, x28, [sp, 128]
	mov	x28, x0
	ldr	w0, [x22, #:lo12:.LANCHOR22]
	stp	x25, x26, [sp, 112]
	mov	x25, x1
	stp	x19, x20, [sp, 64]
	stp	x23, x24, [sp, 96]
	tbz	x0, 12, .L1699
	ldrh	w1, [x28, 2]
	adrp	x0, .LC69
	add	x0, x0, :lo12:.LC69
	bl	printf
.L1699:
	ldr	w0, [x22, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L1700
	ldrb	w1, [x28, 5]
	adrp	x0, .LC70
	add	x0, x0, :lo12:.LC70
	bl	printf
.L1700:
	ldr	w0, [x22, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L1701
	ldrh	w1, [x28]
	adrp	x0, .LC71
	add	x0, x0, :lo12:.LC71
	bl	printf
.L1701:
	ldr	w0, [x22, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L1702
	ldrh	w2, [x28, 18]
	adrp	x0, .LC72
	ldrh	w1, [x28, 16]
	add	x0, x0, :lo12:.LC72
	bl	printf
.L1702:
	ldrh	w0, [x28, 10]
	adrp	x26, .LANCHOR45
	strh	w0, [x28, 14]
	mov	w27, 0
	mov	w0, 1
	adrp	x23, .LANCHOR79
	bl	buf_alloc
	ldrb	w20, [x28, 5]
	ldrh	w21, [x28, 2]
	mov	x19, x0
	add	x0, x26, :lo12:.LANCHOR45
	str	x0, [x29, 120]
.L1703:
	ldrh	w0, [x23, #:lo12:.LANCHOR79]
	cmp	w0, w21
	bhi	.L1718
.L1706:
	strh	w21, [x28, 2]
	adrp	x21, .LANCHOR82
	strb	w20, [x28, 5]
	mov	w0, 0
	ldrh	w3, [x28, 10]
	mov	w1, 0
	ldr	x4, [x21, #:lo12:.LANCHOR82]
.L1719:
	cmp	w1, w3
	bcc	.L1721
	ldrb	w20, [x28, 9]
	adrp	x24, .LANCHOR56
	ldrh	w1, [x23, #:lo12:.LANCHOR79]
	madd	w20, w20, w1, w0
	ldr	w0, [x22, #:lo12:.LANCHOR22]
	sub	w20, w20, w3
	and	w20, w20, 65535
	tbz	x0, 12, .L1722
	ldrh	w1, [x28]
	ldr	x2, [x24, #:lo12:.LANCHOR56]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC74
	mov	w2, w20
	add	x0, x0, :lo12:.LC74
	bl	printf
.L1722:
	ldr	x0, [x24, #:lo12:.LANCHOR56]
	adrp	x25, .LANCHOR45
	ldrh	w1, [x28]
	adrp	x24, .LANCHOR69
	adrp	x26, .LC75
	add	x24, x24, :lo12:.LANCHOR69
	add	x25, x25, :lo12:.LANCHOR45
	add	x26, x26, :lo12:.LC75
	strh	w20, [x0, x1, lsl 1]
	mov	w20, 0
	mov	x0, x19
	bl	buf_free
.L1723:
	ldrb	w0, [x24]
	cmp	w20, w0, lsl 1
	bcc	.L1726
	ldrh	w1, [x28, 12]
	ldrh	w0, [x23, #:lo12:.LANCHOR79]
	ldrb	w2, [x28, 9]
	madd	w0, w0, w2, w1
	mov	x1, -4
	add	x0, x1, x0, sxtw 2
	ldr	x1, [x21, #:lo12:.LANCHOR82]
	ldr	w0, [x1, x0]
	cmn	w0, #1
	beq	.L1727
	adrp	x1, .LANCHOR139
	adrp	x0, .LC0
	mov	w2, 811
	add	x1, x1, :lo12:.LANCHOR139
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1728:
	b	.L1728
.L1718:
	ldrb	w20, [x28, 5]
	adrp	x24, .LANCHOR75
	add	x24, x24, :lo12:.LANCHOR75
.L1704:
	ldrb	w0, [x28, 9]
	cmp	w0, w20
	bhi	.L1717
	add	w21, w21, 1
	strb	wzr, [x28, 5]
	and	w21, w21, 65535
	b	.L1703
.L1717:
	add	x0, x28, x20, sxtw 1
	ldrh	w12, [x0, 16]
	mov	w0, 65535
	cmp	w12, w0
	beq	.L1705
	ldrh	w10, [x24]
	ldrb	w3, [x26, #:lo12:.LANCHOR45]
	ldr	x1, [x19, 8]
	ldr	x2, [x19, 24]
	madd	w10, w10, w12, w21
	stp	w12, w10, [x29, 108]
	mov	w0, w10
	bl	ftl_read_ppa_page
	mov	w11, w0
	cmp	w0, 512
	beq	.L1706
	ldr	w0, [x22, #:lo12:.LANCHOR22]
	ldp	w12, w10, [x29, 108]
	tbz	x0, 12, .L1707
	ldr	x1, [x19, 24]
	mov	w4, w11
	ldr	x0, [x19, 8]
	mov	w3, w10
	str	w11, [x29, 112]
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
	adrp	x0, .LC73
	add	x0, x0, :lo12:.LC73
	bl	printf
	ldr	w11, [x29, 112]
.L1707:
	ldrb	w2, [x28, 9]
	adrp	x0, .LANCHOR133
	mov	w1, 1
	strb	w1, [x0, #:lo12:.LANCHOR133]
	ldrh	w0, [x28, 10]
	madd	w1, w21, w2, w20
	cmp	w0, w1
	beq	.L1708
	adrp	x1, .LANCHOR139
	adrp	x0, .LC0
	mov	w2, 707
	add	x1, x1, :lo12:.LANCHOR139
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1709:
	b	.L1709
.L1708:
	ldrh	w1, [x28, 6]
	add	w1, w1, w0
	ldrh	w0, [x23, #:lo12:.LANCHOR79]
	mul	w0, w0, w2
	cmp	w1, w0
	beq	.L1710
	adrp	x1, .LANCHOR139
	adrp	x0, .LC0
	mov	w2, 708
	add	x1, x1, :lo12:.LANCHOR139
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1711:
	b	.L1711
.L1710:
	cmn	w11, #1
	beq	.L1713
	ldr	x5, [x19, 24]
	str	x5, [x29, 112]
	ldr	w0, [x5, 4]
	cmn	w0, #1
	beq	.L1713
	bl	lpa_hash_get_ppa
	cbz	x25, .L1715
	ldr	x5, [x29, 112]
	ldr	w1, [x5, 8]
	cmp	w0, w1
	beq	.L1715
	cmn	w0, #1
	beq	.L1715
	adrp	x3, .LANCHOR71
	mov	w1, 21
	adrp	x27, .LANCHOR70
	ldrh	w6, [x3, #:lo12:.LANCHOR71]
	sub	w4, w1, w6
	mov	w1, 1
	lsr	w2, w0, w6
	lsl	w1, w1, w4
	sub	w1, w1, #1
	and	w1, w1, w2
	ldrb	w2, [x27, #:lo12:.LANCHOR70]
	mov	x4, x3
	udiv	w1, w1, w2
	ldrh	w2, [x25]
	cmp	w2, w1, uxth
	bne	.L1715
	ldr	x1, [x29, 120]
	ldr	w6, [x5]
	adrp	x5, .LANCHOR130
	str	w6, [x29, 108]
	add	x2, x5, :lo12:.LANCHOR130
	str	x5, [x29, 112]
	ldrb	w3, [x1]
	ldr	x1, [x19, 8]
	str	x4, [x29, 96]
	bl	ftl_read_ppa_page
	ldr	x5, [x29, 112]
	ldr	w6, [x29, 108]
	ldr	w0, [x5, #:lo12:.LANCHOR130]
	cmp	w6, w0
	bhi	.L1715
	ldr	x0, [x19, 24]
	ldr	w1, [x0, 8]
	cmn	w1, #1
	beq	.L1713
	ldr	x4, [x29, 96]
	mov	w0, 21
	ldrh	w3, [x4, #:lo12:.LANCHOR71]
	sub	w2, w0, w3
	mov	w0, 1
	lsr	w1, w1, w3
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	ldrb	w1, [x27, #:lo12:.LANCHOR70]
	udiv	w0, w0, w1
	bl	ftl_vpn_decrement
.L1713:
	ldrh	w0, [x28, 6]
	mov	w27, 1
	sub	w0, w0, #1
	strh	w0, [x28, 6]
	ldrh	w0, [x28, 10]
	add	w0, w0, 1
	strh	w0, [x28, 10]
.L1705:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1704
.L1721:
	ldrh	w2, [x28, 12]
	add	w2, w2, w1
	ldr	w2, [x4, x2, lsl 2]
	cmn	w2, #1
	beq	.L1720
	add	w20, w0, 1
	and	w0, w20, 65535
.L1720:
	add	w1, w1, 1
	b	.L1719
.L1726:
	cbz	w27, .L1724
	ldrh	w0, [x28, 6]
	cmp	w0, 1
	bls	.L1724
	mov	x0, x28
	bl	ftl_get_new_free_page
	mov	w4, w0
	ldr	w0, [x22, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L1725
	mov	w1, w4
	str	w4, [x29, 120]
	mov	x0, x26
	bl	printf
	ldr	w4, [x29, 120]
.L1725:
	adrp	x0, .LANCHOR46
	ldr	x2, [x19, 24]
	ldr	x1, [x19, 8]
	ldr	x0, [x0, #:lo12:.LANCHOR46]
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
.L1724:
	add	w20, w20, 1
	b	.L1723
.L1727:
	ldrh	w0, [x28, 6]
	cmp	w0, 1
	bne	.L1698
	ldp	x19, x20, [sp, 64]
	mov	x0, x28
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 176
	b	ftl_write_last_log_page
.L1715:
	ldr	x3, [x19, 24]
	adrp	x0, .LANCHOR47
	ldr	w0, [x0, #:lo12:.LANCHOR47]
	ldr	w1, [x3, 4]
	cmp	w1, w0
	bcs	.L1713
	ldrb	w0, [x28, 9]
	ldrh	w1, [x23, #:lo12:.LANCHOR79]
	ldrh	w2, [x28, 10]
	mul	w0, w0, w1
	sub	w0, w0, #1
	cmp	w2, w0
	bge	.L1713
	adrp	x0, .LANCHOR46
	ldr	w1, [x3]
	ldr	x0, [x0, #:lo12:.LANCHOR46]
	ldr	w4, [x0, 8]
	cmp	w1, w4
	bls	.L1716
	str	w1, [x0, 8]
.L1716:
	ldrh	w0, [x28, 12]
	add	w2, w2, w0
	ldp	w0, w1, [x3, 4]
	bl	lpa_hash_update_ppa
	b	.L1713
.L1698:
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
	adrp	x20, .LANCHOR79
	stp	x21, x22, [sp, 32]
	mov	w19, w0
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR46
	mov	x24, x1
	add	x20, x20, :lo12:.LANCHOR79
	mov	x21, x22
	stp	x25, x26, [sp, 64]
	mov	w23, 65535
	str	x27, [sp, 80]
.L1772:
	adrp	x25, .LANCHOR75
.L1777:
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	ldr	w1, [x0, 48]
	ldrh	w2, [x0, 696]
	add	w1, w1, 1
	str	w1, [x0, 48]
	ldrh	w1, [x20]
	cmp	w2, w1
	bcs	.L1773
	ldrh	w0, [x0, 692]
	cmp	w0, w23
	bne	.L1774
.L1773:
	bl	pm_alloc_new_blk
	mov	w0, 0
	bl	ftl_info_flush
.L1774:
	ldr	x1, [x21, #:lo12:.LANCHOR46]
	ldrh	w0, [x1, 692]
	cmp	w0, w23
	bne	.L1775
	adrp	x1, .LANCHOR140
	adrp	x0, .LC0
	mov	w2, 224
	add	x1, x1, :lo12:.LANCHOR140
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1776:
	b	.L1776
.L1775:
	ldrh	w1, [x1, 696]
	adrp	x27, .LANCHOR141
	ldrh	w26, [x25, #:lo12:.LANCHOR75]
	mov	w2, 64
	madd	w26, w26, w0, w1
	ldr	x0, [x27, #:lo12:.LANCHOR141]
	mov	w1, 0
	bl	ftl_memset
	ldr	x3, [x27, #:lo12:.LANCHOR141]
	mov	x2, x24
	ldr	x0, [x21, #:lo12:.LANCHOR46]
	str	w19, [x3]
	ldr	w1, [x0, 48]
	ldrb	w0, [x0, 694]
	str	w1, [x3, 4]
	adrp	x1, .LANCHOR45
	ldrb	w4, [x1, #:lo12:.LANCHOR45]
	mov	w1, w26
	bl	ftl_prog_page
	ldr	x2, [x21, #:lo12:.LANCHOR46]
	ldrh	w1, [x2, 696]
	add	w1, w1, 1
	and	w1, w1, 65535
	strh	w1, [x2, 696]
	cmp	w1, 1
	beq	.L1777
	cmn	w0, #1
	bne	.L1778
	mov	w1, w26
	adrp	x0, .LC76
	add	x0, x0, :lo12:.LC76
	bl	printf
	b	.L1772
.L1778:
	ldrh	w0, [x2, 698]
	cmp	w19, w0
	bcs	.L1779
	add	x19, x2, x19, uxtw 2
	str	w26, [x19, 704]
.L1779:
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
	adrp	x23, .LANCHOR116
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR5
	ldr	x0, [x23, #:lo12:.LANCHOR116]
	adrp	x24, .LC78
	stp	x21, x22, [sp, 32]
	add	x24, x24, :lo12:.LC78
	stp	x25, x26, [sp, 64]
	adrp	x21, .LANCHOR117
	stp	x27, x28, [sp, 80]
	adrp	x22, .LANCHOR13
	bl	ftl_memset
	adrp	x25, .LANCHOR97
	ldr	x1, [x20, #:lo12:.LANCHOR5]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC77
	add	x0, x0, :lo12:.LC77
	add	x22, x22, :lo12:.LANCHOR13
	add	x25, x25, :lo12:.LANCHOR97
	add	x27, x21, :lo12:.LANCHOR117
	bl	rknand_print_hex
	mov	w26, 0
	ldr	x6, [x20, #:lo12:.LANCHOR5]
	add	x0, x6, 16
	ldr	w1, [x6, 8]
	bl	js_hash
	str	w0, [x6, 12]
.L1784:
	add	x28, x21, :lo12:.LANCHOR117
	ldrb	w4, [x21, #:lo12:.LANCHOR117]
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
	blt	.L1785
	ldr	x6, [x20, #:lo12:.LANCHOR5]
	ldrb	w7, [x28, 1]
	strh	wzr, [x28, 2]
	ldr	w0, [x6, 4]
	ldrh	w1, [x6, 16]
	add	w0, w0, 1
	str	w0, [x6, 4]
	ldrb	w0, [x21, #:lo12:.LANCHOR117]
	add	w1, w1, 1
	strb	w0, [x28, 1]
	mov	x0, x6
	strb	w7, [x21, #:lo12:.LANCHOR117]
	strh	w1, [x0, 16]!
	ldr	w1, [x6, 8]
	bl	js_hash
	ldrh	w19, [x22]
	str	w0, [x6, 12]
	mul	w19, w19, w7
.L1791:
	mov	w1, w19
	mov	w0, 0
	bl	flash_erase_block
	b	.L1786
.L1789:
	mov	w26, 1
	b	.L1784
.L1785:
	madd	w19, w19, w4, w3
	cbz	w1, .L1791
.L1786:
	ldr	x2, [x20, #:lo12:.LANCHOR5]
	mov	w1, w19
	ldr	x3, [x23, #:lo12:.LANCHOR116]
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
	bne	.L1787
	mov	w1, w19
	adrp	x0, .LC79
	add	x0, x0, :lo12:.LC79
	bl	printf
	b	.L1784
.L1787:
	cbz	w26, .L1789
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
	stp	x29, x30, [sp, -64]!
	mov	w2, 2
	adrp	x1, .LANCHOR20
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR26
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR34
	stp	x23, x24, [sp, 48]
	adrp	x19, .LANCHOR19
	strb	w2, [x1, #:lo12:.LANCHOR20]
	bl	nandc_init
	add	x8, x20, :lo12:.LANCHOR26
	add	x0, x19, :lo12:.LANCHOR19
	mov	x10, x8
	str	x0, [x21, #:lo12:.LANCHOR34]
	mov	w7, 0
	mov	w11, 44
.L1798:
	mov	x1, x8
	mov	w0, w7
	bl	flash_read_id
	cbnz	w7, .L1793
	ldrb	w0, [x10]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 253
	bls	.L1794
.L1796:
	mov	w0, -2
.L1792:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1794:
	ldrb	w0, [x10, 1]
	cmp	w0, 255
	beq	.L1796
.L1793:
	ldrb	w0, [x8]
	cmp	w0, 181
	bne	.L1797
	strb	w11, [x8]
.L1797:
	add	w7, w7, 1
	add	x8, x8, 8
	and	w7, w7, 255
	cmp	w7, 4
	bne	.L1798
	adrp	x0, .LANCHOR142
	add	x8, x0, :lo12:.LANCHOR142
	add	x8, x8, 1
	mov	x7, x0
	add	x12, x20, :lo12:.LANCHOR26
	mov	x10, 0
.L1801:
	ldrb	w2, [x8, -1]
	mov	w11, w10
	lsl	x23, x10, 5
	mov	x1, x12
	mov	x0, x8
	bl	flash_mem_cmp8
	cbnz	w0, .L1799
	add	x0, x7, :lo12:.LANCHOR142
	ubfiz	x11, x11, 5, 32
	add	x23, x0, x23
	add	x0, x0, x11
	adrp	x1, .LANCHOR143
	add	x4, x1, :lo12:.LANCHOR143
	ldrb	w3, [x0, 22]
	mov	x0, 0
.L1800:
	lsl	x5, x0, 5
	mov	w2, w0
	ldrb	w5, [x5, x4]
	cmp	w5, w3
	beq	.L1802
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L1800
	mov	w2, w0
.L1802:
	ubfiz	x0, x2, 5, 32
	add	x1, x1, :lo12:.LANCHOR143
	add	x1, x1, x0
	mov	w2, 32
	adrp	x0, .LANCHOR103
	add	x22, x19, :lo12:.LANCHOR19
	add	x0, x0, :lo12:.LANCHOR103
	bl	ftl_memcpy
	mov	x1, x23
	mov	w2, 32
	mov	x0, x22
	bl	ftl_memcpy
	adrp	x1, .LANCHOR7
	mov	x24, x1
	ldrb	w0, [x1, #:lo12:.LANCHOR7]
	cmp	w0, 8
	bhi	.L1803
	ldrb	w1, [x22, 20]
	cmp	w1, 60
	bls	.L1804
	mov	w1, 60
	strb	w1, [x22, 20]
.L1804:
	cmp	w0, 8
	bne	.L1803
	ldrb	w0, [x20, #:lo12:.LANCHOR26]
	cmp	w0, 44
	bne	.L1803
	add	x0, x19, :lo12:.LANCHOR19
	ldrb	w1, [x0, 28]
	cmp	w1, 2
	bne	.L1803
	strb	wzr, [x0, 28]
.L1803:
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR119
	adrp	x23, .LANCHOR5
	add	x20, x19, :lo12:.LANCHOR19
	adrp	x22, .LANCHOR25
	str	x0, [x1, #:lo12:.LANCHOR119]
	mov	w0, 16384
	bl	ftl_malloc
	adrp	x1, .LANCHOR111
	str	x0, [x1, #:lo12:.LANCHOR111]
	mov	w0, 2048
	bl	ftl_malloc
	str	x0, [x23, #:lo12:.LANCHOR5]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR118
	str	x0, [x1, #:lo12:.LANCHOR118]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR112
	str	x0, [x1, #:lo12:.LANCHOR112]
	mov	w0, 64
	bl	ftl_malloc
	adrp	x1, .LANCHOR116
	str	x0, [x1, #:lo12:.LANCHOR116]
	adrp	x0, .LANCHOR123
	strb	wzr, [x0, #:lo12:.LANCHOR123]
	bl	flash_die_info_init
	ldrb	w0, [x20, 18]
	bl	flash_lsb_page_tbl_build
	ldrb	w0, [x20, 20]
	adrp	x20, .LANCHOR115
	bl	nandc_bch_sel
	str	xzr, [x20, #:lo12:.LANCHOR115]
	ldr	x1, [x21, #:lo12:.LANCHOR34]
	mov	x21, x23
	ldrh	w0, [x1, 16]
	lsr	w3, w0, 8
	ubfx	x4, x0, 3, 1
	and	w2, w3, 7
	strb	w2, [x22, #:lo12:.LANCHOR25]
	adrp	x2, .LANCHOR144
	strb	w4, [x2, #:lo12:.LANCHOR144]
	adrp	x2, .LANCHOR23
	ubfx	x4, x0, 4, 1
	strb	w4, [x2, #:lo12:.LANCHOR23]
	adrp	x2, .LANCHOR66
	ubfx	x4, x0, 12, 1
	strb	w4, [x2, #:lo12:.LANCHOR66]
	adrp	x2, .LANCHOR74
	ubfx	x4, x0, 13, 1
	ubfx	x0, x0, 14, 1
	strb	w4, [x2, #:lo12:.LANCHOR74]
	adrp	x2, .LANCHOR12
	strb	w0, [x2, #:lo12:.LANCHOR12]
	mov	w2, 60
	ldrb	w0, [x1, 28]
	adrp	x1, .LANCHOR11
	strb	w0, [x1, #:lo12:.LANCHOR11]
	adrp	x1, .LANCHOR145
	strb	w2, [x1, #:lo12:.LANCHOR145]
	ldrb	w2, [x24, #:lo12:.LANCHOR7]
	cmp	w2, 9
	bne	.L1805
	mov	w2, 70
	strb	w2, [x1, #:lo12:.LANCHOR145]
.L1805:
	add	x19, x19, :lo12:.LANCHOR19
	adrp	x1, .LANCHOR146
	adrp	x23, .LANCHOR2
	strb	w0, [x1, #:lo12:.LANCHOR146]
	ldrh	w1, [x19, 16]
	ldrb	w0, [x19, 19]
	strb	w0, [x23, #:lo12:.LANCHOR2]
	tbz	x1, 6, .L1807
	sub	w1, w0, #17
	and	w1, w1, 255
	cmp	w1, 2
	bhi	.L1808
	adrp	x1, micron_read_retrial
	add	x1, x1, :lo12:micron_read_retrial
	str	x1, [x20, #:lo12:.LANCHOR115]
	cmp	w0, 19
	adrp	x0, .LANCHOR113
	beq	.L1809
	mov	w1, 7
.L1836:
	strb	w1, [x0, #:lo12:.LANCHOR113]
	b	.L1807
.L1799:
	add	x10, x10, 1
	add	x8, x8, 32
	cmp	x10, 24
	bne	.L1801
	b	.L1796
.L1809:
	mov	w1, 15
	b	.L1836
.L1808:
	sub	w1, w0, #65
	cmp	w0, 33
	and	w1, w1, 255
	ccmp	w1, 1, 0, ne
	bhi	.L1811
	adrp	x0, toshiba_read_retrial
	add	x0, x0, :lo12:toshiba_read_retrial
	str	x0, [x20, #:lo12:.LANCHOR115]
	adrp	x0, .LANCHOR4
	mov	w1, 4
	strb	w1, [x0, #:lo12:.LANCHOR4]
.L1838:
	mov	w1, 7
	adrp	x0, .LANCHOR113
	b	.L1836
.L1811:
	sub	w2, w0, #34
	sub	w1, w0, #67
	and	w2, w2, 255
	and	w1, w1, 255
	cmp	w2, 1
	ccmp	w1, 1, 0, hi
	bhi	.L1812
	adrp	x2, toshiba_read_retrial
	add	x2, x2, :lo12:toshiba_read_retrial
	str	x2, [x20, #:lo12:.LANCHOR115]
	cmp	w0, 35
	mov	w2, 68
	ccmp	w0, w2, 4, ne
	adrp	x0, .LANCHOR113
	beq	.L1813
	mov	w2, 7
.L1835:
	strb	w2, [x0, #:lo12:.LANCHOR113]
	cmp	w1, 1
	adrp	x0, .LANCHOR4
	bhi	.L1815
	mov	w1, 4
.L1837:
	strb	w1, [x0, #:lo12:.LANCHOR4]
.L1807:
	adrp	x19, .LANCHOR35
	mov	w0, 4
	strb	wzr, [x19, #:lo12:.LANCHOR35]
	tbz	x3, 0, .L1816
	bl	nandc_set_if_mode
	mov	w0, 1
	bl	flash_set_interface_mode
	mov	w0, 1
.L1816:
	bl	nandc_set_if_mode
	bl	flash_info_blk_init
	cmn	w0, #1
	beq	.L1792
	ldrb	w0, [x23, #:lo12:.LANCHOR2]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 6
	bhi	.L1818
	adrp	x0, hynix_read_retrial
	add	x0, x0, :lo12:hynix_read_retrial
	str	x0, [x20, #:lo12:.LANCHOR115]
.L1818:
	ldrb	w0, [x22, #:lo12:.LANCHOR25]
	tbnz	x0, 2, .L1819
.L1839:
	mov	w0, 0
	b	.L1792
.L1813:
	mov	w2, 17
	b	.L1835
.L1815:
	mov	w1, 5
	b	.L1837
.L1812:
	sub	w0, w0, #36
	and	w0, w0, 255
	cmp	w0, 1
	bhi	.L1807
	adrp	x0, toshiba_3d_read_retrial
	add	x0, x0, :lo12:toshiba_3d_read_retrial
	str	x0, [x20, #:lo12:.LANCHOR115]
	b	.L1838
.L1819:
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	ldrb	w0, [x0, 19]
	cbz	w0, .L1839
	adrp	x0, .LANCHOR117
	ldrb	w1, [x0, #:lo12:.LANCHOR117]
	adrp	x0, .LANCHOR13
	ldrh	w0, [x0, #:lo12:.LANCHOR13]
	mul	w1, w1, w0
	mov	w0, 0
	bl	flash_ddr_para_scan
	ldrb	w0, [x19, #:lo12:.LANCHOR35]
	cbnz	w0, .L1839
	ldr	x0, [x21, #:lo12:.LANCHOR5]
	strb	wzr, [x0, 19]
	bl	flash_info_flush
	b	.L1839
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
	adrp	x26, .LANCHOR79
	stp	x27, x28, [sp, 128]
	add	x26, x26, :lo12:.LANCHOR79
	stp	x19, x20, [sp, 64]
	adrp	x27, .LANCHOR75
	stp	x21, x22, [sp, 80]
	and	w22, w0, 65535
	mov	w0, 1
	bl	buf_alloc
	ldr	x23, [x0, 8]
	adrp	x28, .LANCHOR45
	mov	x24, x0
	add	x27, x27, :lo12:.LANCHOR75
	add	x28, x28, :lo12:.LANCHOR45
	mov	w25, 0
	mov	w19, 0
.L1841:
	ldrh	w0, [x26]
	cmp	w0, w19
	bhi	.L1843
	mov	x0, x24
	bl	buf_free
	cbz	w25, .L1844
	adrp	x1, .LANCHOR147
	adrp	x0, .LC0
	mov	w2, 655
	add	x1, x1, :lo12:.LANCHOR147
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1845:
	b	.L1845
.L1843:
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
	adrp	x0, .LC73
	add	x0, x0, :lo12:.LC73
	bl	printf
	mov	w3, 32
	mov	w2, 4
	add	x1, x23, 704
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	bl	rknand_print_hex
	cmp	w21, 512
	ccmn	w21, #1, 4, ne
	csinc	w25, w25, wzr, ne
	b	.L1841
.L1844:
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
	adrp	x0, .LANCHOR131
	add	x1, x0, :lo12:.LANCHOR131
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR60
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR46
	ldrh	w3, [x1, 2]
	adrp	x20, .LANCHOR79
	ldrb	w2, [x1, 1]
	adrp	x21, .LANCHOR54
	ldrb	w1, [x0, #:lo12:.LANCHOR131]
	adrp	x0, .LC81
	add	x0, x0, :lo12:.LC81
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	ldrh	w2, [x0, 140]
	ldrh	w1, [x0, 130]
	adrp	x0, .LC82
	add	x0, x0, :lo12:.LC82
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR60]
	adrp	x0, .LC83
	add	x0, x0, :lo12:.LC83
	ldrh	w5, [x1, 26]
	ldrh	w4, [x1, 22]
	ldrb	w3, [x1, 21]
	ldrh	w2, [x1, 18]
	ldrh	w1, [x1, 16]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR60]
	adrp	x0, .LC84
	add	x0, x0, :lo12:.LC84
	ldrh	w5, [x1, 58]
	ldrh	w4, [x1, 54]
	ldrb	w3, [x1, 53]
	ldrh	w2, [x1, 50]
	ldrh	w1, [x1, 48]
	bl	printf
	ldr	x1, [x19, #:lo12:.LANCHOR60]
	adrp	x19, .LANCHOR69
	adrp	x0, .LC85
	add	x0, x0, :lo12:.LC85
	ldrh	w5, [x1, 90]
	ldrh	w4, [x1, 86]
	ldrb	w3, [x1, 85]
	ldrh	w2, [x1, 82]
	ldrh	w1, [x1, 80]
	bl	printf
	ldrb	w0, [x19, #:lo12:.LANCHOR69]
	mov	w2, 4
	ldrh	w3, [x20, #:lo12:.LANCHOR79]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR82
	ldr	x1, [x0, #:lo12:.LANCHOR82]
	adrp	x0, .LC86
	lsl	w3, w3, 1
	add	x0, x0, :lo12:.LC86
	bl	rknand_print_hex
	adrp	x0, .LANCHOR56
	ldrh	w3, [x21, #:lo12:.LANCHOR54]
	mov	w2, 2
	ldr	x1, [x0, #:lo12:.LANCHOR56]
	adrp	x0, .LC87
	add	x0, x0, :lo12:.LC87
	bl	rknand_print_hex
	ldr	x1, [x22, #:lo12:.LANCHOR46]
	mov	w3, 32
	mov	w2, 4
	adrp	x0, .LC80
	add	x1, x1, 704
	add	x0, x0, :lo12:.LC80
	bl	rknand_print_hex
	adrp	x0, .LANCHOR59
	ldrh	w3, [x21, #:lo12:.LANCHOR54]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR59]
	adrp	x0, .LC88
	add	x0, x0, :lo12:.LC88
	bl	rknand_print_hex
	mov	w3, 256
	mov	w2, 2
	adrp	x1, .LANCHOR81
	adrp	x0, .LC89
	add	x1, x1, :lo12:.LANCHOR81
	add	x0, x0, :lo12:.LC89
	bl	rknand_print_hex
	ldrb	w0, [x19, #:lo12:.LANCHOR69]
	mov	w2, 2
	ldrh	w3, [x20, #:lo12:.LANCHOR79]
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR83
	ldp	x29, x30, [sp], 48
	lsl	w3, w3, 1
	ldr	x1, [x0, #:lo12:.LANCHOR83]
	adrp	x0, .LC90
	add	x0, x0, :lo12:.LC90
	b	rknand_print_hex
	.size	dump_ftl_info, .-dump_ftl_info
	.section	.text.pm_ppa_update_check,"ax",@progbits
	.align	2
	.global	pm_ppa_update_check
	.type	pm_ppa_update_check, %function
pm_ppa_update_check:
	adrp	x3, .LANCHOR71
	mov	w4, 21
	ldrh	w3, [x3, #:lo12:.LANCHOR71]
	sub	w5, w4, w3
	mov	w4, 1
	lsr	w3, w2, w3
	lsl	w4, w4, w5
	sub	w4, w4, #1
	and	w4, w4, w3
	adrp	x3, .LANCHOR70
	ldrb	w3, [x3, #:lo12:.LANCHOR70]
	udiv	w4, w4, w3
	adrp	x3, .LANCHOR59
	ldr	x3, [x3, #:lo12:.LANCHOR59]
	add	x4, x3, x4, uxth 2
	ldrb	w3, [x4, 2]
	ubfx	x3, x3, 5, 3
	cmp	w3, 1
	ccmp	w3, 7, 4, ne
	bne	.L1853
	stp	x29, x30, [sp, -16]!
	mov	w3, w2
	mov	w2, w1
	mov	x1, x0
	add	x29, sp, 0
	adrp	x0, .LC91
	add	x0, x0, :lo12:.LC91
	bl	printf
	bl	dump_ftl_info
	mov	w0, -1
	ldp	x29, x30, [sp], 16
	ret
.L1853:
	mov	w0, 0
	ret
	.size	pm_ppa_update_check, .-pm_ppa_update_check
	.section	.text.load_l2p_region,"ax",@progbits
	.align	2
	.global	load_l2p_region
	.type	load_l2p_region, %function
load_l2p_region:
	stp	x29, x30, [sp, -64]!
	and	w1, w1, 65535
	cmp	w1, 31
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	bls	.L1859
	adrp	x1, .LANCHOR148
	adrp	x0, .LC0
	mov	w2, 30
	add	x1, x1, :lo12:.LANCHOR148
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1860:
	b	.L1860
.L1859:
	adrp	x23, .LANCHOR46
	and	w19, w0, 65535
	ldr	x0, [x23, #:lo12:.LANCHOR46]
	ldrh	w2, [x0, 698]
	cmp	w2, w19
	bcs	.L1861
	mov	w1, w19
	adrp	x0, .LC92
	add	x0, x0, :lo12:.LC92
	bl	printf
	adrp	x0, .LANCHOR149
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR149]
	mov	x0, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	ldr	x0, [x23, #:lo12:.LANCHOR46]
	ldrh	w0, [x0, 698]
	cmp	w0, w19
	bcs	.L1865
	adrp	x1, .LANCHOR148
	adrp	x0, .LC0
	mov	w2, 34
	add	x1, x1, :lo12:.LANCHOR148
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1863:
	b	.L1863
.L1861:
	add	x0, x0, x19, sxtw 2
	sbfiz	x1, x1, 4, 32
	ldr	w21, [x0, 704]
	adrp	x0, .LANCHOR93
	add	x0, x0, :lo12:.LANCHOR93
	add	x22, x0, x1
	strh	w19, [x0, x1]
	strh	wzr, [x22, 2]
	cbnz	w21, .L1864
	adrp	x0, .LANCHOR149
	mov	w1, 255
	ldrh	w2, [x0, #:lo12:.LANCHOR149]
	ldr	x0, [x22, 8]
	bl	ftl_memset
.L1865:
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1864:
	adrp	x20, .LANCHOR141
	adrp	x0, .LANCHOR45
	ldr	x1, [x22, 8]
	ldrb	w3, [x0, #:lo12:.LANCHOR45]
	mov	w0, w21
	ldr	x2, [x20, #:lo12:.LANCHOR141]
	bl	ftl_read_ppa_page
	ldr	x1, [x20, #:lo12:.LANCHOR141]
	ldr	w2, [x1]
	cmp	w2, w19
	beq	.L1866
	mov	w4, w21
	mov	w3, w0
	mov	w1, w19
	adrp	x0, .LC93
	add	x0, x0, :lo12:.LC93
	bl	printf
	ldr	x1, [x23, #:lo12:.LANCHOR46]
	mov	w2, 4
	adrp	x0, .LC94
	add	x0, x0, :lo12:.LC94
	add	x1, x1, 704
	ldrh	w3, [x1, -6]
	bl	rknand_print_hex
	ldr	x1, [x22, 8]
	mov	w3, 16
	mov	w2, 4
	adrp	x0, .LC95
	add	x0, x0, :lo12:.LC95
	bl	rknand_print_hex
	ldr	x1, [x20, #:lo12:.LANCHOR141]
	mov	w2, 4
	mov	w3, 16
	adrp	x0, .LC96
	add	x0, x0, :lo12:.LC96
	bl	rknand_print_hex
	adrp	x0, .LANCHOR71
	ldrh	w2, [x0, #:lo12:.LANCHOR71]
	mov	w0, 21
	sub	w1, w0, w2
	mov	w0, 1
	lsr	w21, w21, w2
	lsl	w0, w0, w1
	adrp	x1, .LANCHOR70
	sub	w0, w0, #1
	ldrb	w2, [x1, #:lo12:.LANCHOR70]
	and	w0, w0, w21
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
.L1866:
	ldr	x0, [x20, #:lo12:.LANCHOR141]
	ldr	w0, [x0]
	cmp	w19, w0
	beq	.L1865
	adrp	x1, .LANCHOR148
	adrp	x0, .LC0
	mov	w2, 55
	add	x1, x1, :lo12:.LANCHOR148
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1867:
	b	.L1867
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.pm_gc,"ax",@progbits
	.align	2
	.global	pm_gc
	.type	pm_gc, %function
pm_gc:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR46
	adrp	x20, .LANCHOR101
	stp	x21, x22, [sp, 32]
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	stp	x23, x24, [sp, 48]
	ldrh	w1, [x0, 688]
	ldrh	w0, [x20, #:lo12:.LANCHOR101]
	str	x25, [sp, 64]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L1871
	bl	pm_free_sblk
	ldr	x2, [x19, #:lo12:.LANCHOR46]
	ldrh	w1, [x20, #:lo12:.LANCHOR101]
	sub	w1, w1, #1
	ldrh	w3, [x2, 688]
	cmp	w3, w1
	blt	.L1871
	add	x0, x2, x0, uxth 1
	mov	w23, 65535
	ldrh	w20, [x0, 416]
	cmp	w20, w23
	bne	.L1873
	adrp	x1, .LANCHOR150
	adrp	x0, .LC0
	mov	w2, 127
	add	x1, x1, :lo12:.LANCHOR150
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1874:
	b	.L1874
.L1873:
	bl	pm_select_ram_region
	and	x24, x0, 65535
	adrp	x1, .LANCHOR93
	lsl	x0, x24, 4
	add	x2, x1, :lo12:.LANCHOR93
	mov	x22, x19
	add	x19, x2, x0
	mov	x21, x24
	ldrh	w0, [x2, x0]
	cmp	w0, w23
	mov	x23, x1
	beq	.L1875
	ldr	x1, [x19, 8]
	cbz	x1, .L1875
	ldrsh	w2, [x19, 2]
	tbz	w2, #31, .L1875
	bl	pm_write_page
	ldrh	w0, [x19, 2]
	and	w0, w0, 32767
	strh	w0, [x19, 2]
.L1875:
	add	x1, x23, :lo12:.LANCHOR93
	adrp	x25, .LANCHOR71
	add	x24, x1, x24, lsl 4
	add	x25, x25, :lo12:.LANCHOR71
	mov	w19, 0
.L1876:
	ldr	x1, [x22, #:lo12:.LANCHOR46]
	ldrh	w0, [x1, 698]
	cmp	w0, w19
	bhi	.L1878
	bl	pm_free_sblk
.L1871:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1878:
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
	adrp	x1, .LANCHOR70
	ldrb	w1, [x1, #:lo12:.LANCHOR70]
	udiv	w0, w0, w1
	cmp	w20, w0, uxth
	bne	.L1877
	mov	w1, w21
	mov	w0, w19
	bl	load_l2p_region
	ldr	x1, [x24, 8]
	mov	w0, w19
	bl	pm_write_page
.L1877:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1876
	.size	pm_gc, .-pm_gc
	.section	.text.pm_flush_id,"ax",@progbits
	.align	2
	.global	pm_flush_id
	.type	pm_flush_id, %function
pm_flush_id:
	stp	x29, x30, [sp, -32]!
	ubfiz	x0, x0, 4, 16
	adrp	x2, .LANCHOR93
	add	x2, x2, :lo12:.LANCHOR93
	add	x29, sp, 0
	str	x19, [sp, 16]
	add	x19, x2, x0
	ldrh	w0, [x2, x0]
	ldr	x1, [x19, 8]
	bl	pm_write_page
	ldrh	w0, [x19, 2]
	and	w0, w0, 32767
	strh	w0, [x19, 2]
	adrp	x19, .LANCHOR91
	ldr	w0, [x19, #:lo12:.LANCHOR91]
	cbz	w0, .L1884
	bl	pm_gc
	str	wzr, [x19, #:lo12:.LANCHOR91]
.L1884:
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
	adrp	x19, .LANCHOR93
	add	x19, x19, :lo12:.LANCHOR93
	mov	w20, 0
	add	x19, x19, 2
.L1891:
	ldrsh	w0, [x19]
	tbz	w0, #31, .L1890
	mov	w0, w20
	bl	pm_flush_id
.L1890:
	add	w20, w20, 1
	add	x19, x19, 16
	and	w20, w20, 65535
	cmp	w20, 32
	bne	.L1891
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
	bl	FlashDeInit
	bl	flt_sys_flush
	ldp	x29, x30, [sp], 16
	b	FlashDeInit
	.size	rk_ftl_de_init, .-rk_ftl_de_init
	.section	.text.pm_init,"ax",@progbits
	.align	2
	.global	pm_init
	.type	pm_init, %function
pm_init:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	w24, w0
	adrp	x0, .LANCHOR91
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	adrp	x20, .LANCHOR93
	stp	x25, x26, [sp, 64]
	add	x19, x20, :lo12:.LANCHOR93
	str	wzr, [x0, #:lo12:.LANCHOR91]
	mov	w0, 64
	stp	x27, x28, [sp, 80]
	bl	ftl_malloc
	adrp	x1, .LANCHOR141
	adrp	x22, .LANCHOR45
	add	x23, x19, 512
	mov	x21, x1
	add	x22, x22, :lo12:.LANCHOR45
	str	x0, [x1, #:lo12:.LANCHOR141]
	mov	w25, -1
.L1900:
	strh	w25, [x19]
	strh	wzr, [x19, 2]
	cbz	w24, .L1899
	ldrb	w0, [x22]
	lsl	w0, w0, 9
	bl	ftl_malloc
	str	x0, [x19, 8]
.L1899:
	add	x19, x19, 16
	cmp	x19, x23
	bne	.L1900
	add	x0, x20, :lo12:.LANCHOR93
	adrp	x19, .LANCHOR46
	ldr	x24, [x21, #:lo12:.LANCHOR141]
	mov	w4, 4
	ldr	x25, [x0, 8]
	mov	x3, x24
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	mov	x2, x25
	ldrh	w1, [x0, 692]
	ldrb	w0, [x0, 694]
	bl	flash_get_last_written_page
	sxth	w26, w0
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	mov	w23, w26
	ldrh	w2, [x0, 696]
	cmp	w2, w26
	bgt	.L1901
	ldrh	w1, [x0, 692]
	mov	w3, w26
	adrp	x0, .LC97
	add	x0, x0, :lo12:.LC97
	adrp	x27, .LANCHOR75
	adrp	x28, .LANCHOR45
	add	x27, x27, :lo12:.LANCHOR75
	add	x28, x28, :lo12:.LANCHOR45
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	ldrsh	w21, [x0, 696]
.L1902:
	cmp	w21, w26
	ble	.L1904
	adrp	x0, .LANCHOR133
	mov	w1, 1
	add	x20, x20, :lo12:.LANCHOR93
	add	w23, w23, 1
	strb	w1, [x0, #:lo12:.LANCHOR133]
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	strh	w23, [x0, 696]
	bl	pm_free_sblk
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
	ldr	x1, [x20, 8]
	mov	w0, -1
	bl	pm_write_page
.L1901:
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
.L1904:
	ldr	x0, [x19, #:lo12:.LANCHOR46]
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
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	str	w4, [x29, 108]
	mov	w2, w22
	ldr	w1, [x0, 48]
	ldrh	w3, [x0, 694]
	add	w1, w1, 1
	str	w1, [x0, 48]
	adrp	x0, .LC98
	add	x0, x0, :lo12:.LC98
	ldr	w1, [x24]
	bl	printf
	ldr	w4, [x29, 108]
	cmp	w4, 512
	ccmn	w4, #1, 4, ne
	beq	.L1903
	ldr	x1, [x19, #:lo12:.LANCHOR46]
	ldr	w0, [x24]
	ldrh	w2, [x1, 698]
	cmp	w0, w2
	bcs	.L1903
	add	x0, x1, x0, uxtw 2
	str	w22, [x0, 704]
.L1903:
	add	w21, w21, 1
	sxth	w21, w21
	b	.L1902
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
	adrp	x1, .LANCHOR45
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	ldrb	w1, [x1, #:lo12:.LANCHOR45]
	stp	x23, x24, [sp, 48]
	mov	w23, w2
	lsl	w21, w1, 7
	ubfiz	w20, w1, 7, 9
	adrp	x1, .LANCHOR47
	udiv	w21, w0, w21
	ldr	w2, [x1, #:lo12:.LANCHOR47]
	cmp	w0, w2
	and	w25, w21, 65535
	msub	w20, w25, w20, w0
	bcc	.L1914
	mov	w1, w0
	adrp	x0, .LC99
	add	x0, x0, :lo12:.LC99
	bl	printf
	mov	w0, -1
.L1913:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1914:
	adrp	x24, .LANCHOR93
	add	x0, x24, :lo12:.LANCHOR93
	and	x20, x20, 65535
	add	x0, x0, 8
	mov	x19, 0
.L1920:
	ldr	x1, [x0]
	cbz	x1, .L1916
	ldrh	w1, [x0, -8]
	cmp	w1, w25
	bne	.L1916
.L1917:
	cbnz	w23, .L1918
	add	x0, x24, :lo12:.LANCHOR93
	add	x0, x0, x19, lsl 4
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x20, lsl 2]
	str	w0, [x22]
.L1919:
	add	x24, x24, :lo12:.LANCHOR93
	add	x19, x24, x19, lsl 4
	ldrh	w0, [x19, 2]
	mvn	x1, x0
	tst	x1, 32767
	beq	.L1922
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L1922:
	mov	w0, 0
	b	.L1913
.L1918:
	add	x0, x24, :lo12:.LANCHOR93
	ldr	w2, [x22]
	add	x0, x0, x19, lsl 4
	ldr	x1, [x0, 8]
	str	w2, [x1, x20, lsl 2]
	ldrh	w1, [x0, 2]
	orr	w1, w1, -32768
	strh	w1, [x0, 2]
	adrp	x0, .LANCHOR94
	strb	w21, [x0, #:lo12:.LANCHOR94]
	b	.L1919
.L1916:
	add	w19, w19, 1
	add	x0, x0, 16
	and	x19, x19, 65535
	cmp	w19, 32
	bne	.L1920
	bl	pm_select_ram_region
	and	x19, x0, 65535
	sbfiz	x1, x19, 4, 32
	add	x2, x24, :lo12:.LANCHOR93
	add	x3, x2, x1
	mov	w26, w0
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L1921
	ldrsh	w1, [x3, 2]
	tbz	w1, #31, .L1921
	bl	pm_flush_id
.L1921:
	adrp	x0, .LANCHOR151
	mov	w1, w26
	strb	w19, [x0, #:lo12:.LANCHOR151]
	mov	w0, w25
	bl	load_l2p_region
	b	.L1917
	.size	pm_log2phys, .-pm_log2phys
	.section	.text.ftl_read_ahead,"ax",@progbits
	.align	2
	.global	ftl_read_ahead
	.type	ftl_read_ahead, %function
ftl_read_ahead:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR49
	stp	x21, x22, [sp, 32]
	ldr	w0, [x20, #:lo12:.LANCHOR49]
	stp	x23, x24, [sp, 48]
	cmn	w0, #1
	beq	.L1929
	mov	w0, 0
	bl	buf_alloc
	mov	x19, x0
	mov	w0, -1
	cbz	x19, .L1928
	ldr	w21, [x20, #:lo12:.LANCHOR49]
	str	w21, [x19, 36]
	str	w0, [x20, #:lo12:.LANCHOR49]
	mov	w0, w21
	bl	lpa_hash_get_ppa
	str	w0, [x29, 76]
	ldr	x20, [x19, 8]
	cmn	w0, #1
	ldr	x22, [x19, 24]
	bne	.L1931
	mov	w2, 0
	add	x1, x29, 76
	mov	w0, w21
	bl	pm_log2phys
.L1931:
	ldr	w0, [x29, 76]
	stp	w0, w0, [x19, 40]
	cmn	w0, #1
	bne	.L1932
	adrp	x0, .LANCHOR45
	mov	w1, 0
	ldrb	w2, [x0, #:lo12:.LANCHOR45]
	mov	x0, x20
	lsl	w2, w2, 9
	bl	ftl_memset
	ldrb	w0, [x19, 2]
	orr	w0, w0, 8
	strb	w0, [x19, 2]
.L1929:
	mov	w0, 0
.L1928:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1932:
	mov	w1, 1
	mov	x0, x19
	bl	sblk_read_page
	ldr	w23, [x19, 52]
	cmp	w23, 256
	bne	.L1933
	adrp	x0, .LANCHOR71
	mov	w20, 21
	mov	w24, 1
	ldrh	w1, [x0, #:lo12:.LANCHOR71]
	ldr	w0, [x29, 76]
	sub	w20, w20, w1
	ldp	w2, w3, [x19, 36]
	lsr	w0, w0, w1
	lsl	w20, w24, w20
	sub	w20, w20, #1
	and	w20, w20, w0
	adrp	x0, .LANCHOR70
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	udiv	w20, w20, w0
	adrp	x0, .LC100
	add	x0, x0, :lo12:.LC100
	and	w1, w20, 65535
	bl	printf
	mov	w2, 0
	mov	w1, w24
	mov	w0, w20
	bl	gc_add_sblk
.L1933:
	ldr	w5, [x22, 4]
	cmp	w21, w5
	beq	.L1934
	ldrb	w1, [x19, 1]
	adrp	x0, .LC101
	ldr	w4, [x22]
	mov	w2, w21
	ldp	w6, w7, [x22, 8]
	add	x0, x0, :lo12:.LC101
	ldr	w3, [x29, 76]
	bl	printf
.L1934:
	ldr	w0, [x22, 4]
	cmp	w21, w0
	bne	.L1935
	cmn	w23, #1
	bne	.L1929
.L1935:
	adrp	x1, .LANCHOR152
	adrp	x0, .LC0
	mov	w2, 758
	add	x1, x1, :lo12:.LANCHOR152
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1936:
	b	.L1936
	.size	ftl_read_ahead, .-ftl_read_ahead
	.section	.text.gc_update_l2p_map,"ax",@progbits
	.align	2
	.global	gc_update_l2p_map
	.type	gc_update_l2p_map, %function
gc_update_l2p_map:
	stp	x29, x30, [sp, -144]!
	adrp	x0, .LANCHOR60
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	w21, 0
	stp	x23, x24, [sp, 48]
	mov	w24, 0
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR64
	stp	x27, x28, [sp, 80]
	mov	w27, 0
	ldr	x22, [x0, #:lo12:.LANCHOR60]
	add	x0, x26, :lo12:.LANCHOR64
	stp	x19, x20, [sp, 16]
	str	x0, [x29, 104]
.L1943:
	adrp	x0, .LANCHOR79
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	cmp	w27, w0
	bge	.L1953
	lsl	w23, w27, 1
	mov	x19, 0
	sub	w0, w23, #1
	str	w0, [x29, 124]
	b	.L1954
.L1950:
	adrp	x1, .LANCHOR107
	sbfiz	x0, x24, 2, 32
	ldr	x1, [x1, #:lo12:.LANCHOR107]
	ldr	w23, [x1, x0]
	cmn	w23, #1
	beq	.L1944
	adrp	x1, .LANCHOR108
	ldr	x1, [x1, #:lo12:.LANCHOR108]
	ldr	w20, [x1, x0]
	mov	w0, w23
	bl	lpa_hash_get_ppa
	str	w0, [x29, 140]
	cmn	w0, #1
	bne	.L1945
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w23
	bl	pm_log2phys
.L1945:
	ldr	w0, [x29, 140]
	cmp	w20, w0
	bne	.L1946
	ldr	x0, [x29, 112]
	ldrh	w1, [x25]
	ldrh	w0, [x0, 96]
	mul	w0, w0, w1
	ldr	x1, [x29, 104]
	ldrb	w1, [x1]
	cmp	w1, 3
	bne	.L1947
	add	w0, w0, w27
	orr	w0, w0, w28, lsl 24
.L1959:
	mov	w2, 1
	add	x1, x29, 136
	str	w0, [x29, 136]
	mov	w0, w23
	bl	pm_log2phys
	add	w21, w21, 1
	adrp	x0, .LANCHOR71
	ldrh	w2, [x0, #:lo12:.LANCHOR71]
	mov	w0, 21
	sub	w1, w0, w2
	mov	w0, 1
	lsr	w20, w20, w2
	lsl	w0, w0, w1
	sub	w0, w0, #1
	and	w20, w0, w20
	adrp	x0, .LANCHOR70
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	udiv	w0, w20, w0
	bl	ftl_vpn_decrement
.L1946:
	add	w24, w24, 1
.L1944:
	add	w28, w28, 1
.L1952:
	ldrb	w0, [x26, #:lo12:.LANCHOR64]
	cmp	w28, w0
	ble	.L1950
	add	x19, x19, 1
.L1954:
	ldrb	w0, [x22, 89]
	cmp	w0, w19
	ble	.L1951
	add	x0, x22, x19, lsl 1
	adrp	x25, .LANCHOR75
	mov	w28, 1
	add	x25, x25, :lo12:.LANCHOR75
	str	x0, [x29, 112]
	b	.L1952
.L1947:
	cmp	w1, 2
	bne	.L1949
	ldr	w1, [x29, 124]
	add	w0, w0, w1
	add	w0, w0, w28
	orr	w0, w0, 33554432
	b	.L1959
.L1949:
	add	w0, w0, w27
	b	.L1959
.L1951:
	add	w27, w27, 1
	b	.L1943
.L1953:
	adrp	x0, .LANCHOR56
	ldrh	w1, [x22, 80]
	ldp	x19, x20, [sp, 16]
	ldr	x0, [x0, #:lo12:.LANCHOR56]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	strh	w21, [x0, x1, lsl 1]
	ldp	x27, x28, [sp, 80]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 144
	ret
	.size	gc_update_l2p_map, .-gc_update_l2p_map
	.section	.text.gc_update_l2p_map_new,"ax",@progbits
	.align	2
	.global	gc_update_l2p_map_new
	.type	gc_update_l2p_map_new, %function
gc_update_l2p_map_new:
	stp	x29, x30, [sp, -176]!
	adrp	x0, .LANCHOR60
	adrp	x1, .LANCHOR68
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	ldr	x24, [x0, #:lo12:.LANCHOR60]
	stp	x25, x26, [sp, 64]
	ldrh	w25, [x1, #:lo12:.LANCHOR68]
	add	x1, x24, 80
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR22
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	str	x1, [x29, 144]
	ldrb	w1, [x1, 9]
	str	x0, [x29, 128]
	mul	w25, w25, w1
	ldr	w1, [x20, #:lo12:.LANCHOR22]
	tbz	x1, 8, .L1961
	ldrh	w1, [x24, 80]
	adrp	x0, .LC102
	add	x0, x0, :lo12:.LC102
	bl	printf
.L1961:
	adrp	x23, .LANCHOR56
	ldrh	w1, [x24, 80]
	sub	w2, w25, #1
	mov	x21, 0
	ldr	x0, [x23, #:lo12:.LANCHOR56]
	mov	w22, 0
	strh	w2, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR45
	add	x0, x0, :lo12:.LANCHOR45
	str	x0, [x29, 104]
.L1962:
	mov	w27, w21
	cmp	w25, w21
	bhi	.L1972
	ldr	w0, [x20, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L1973
	ldr	x0, [x29, 128]
	mov	w3, w22
	ldr	x1, [x23, #:lo12:.LANCHOR56]
	ldrh	w2, [x24, 80]
	ldr	x0, [x0, #:lo12:.LANCHOR60]
	ldrh	w2, [x1, x2, lsl 1]
	ldrh	w1, [x0, 80]
	adrp	x0, .LC106
	add	x0, x0, :lo12:.LC106
	bl	printf
.L1973:
	ldrh	w0, [x24, 80]
	ldr	x1, [x23, #:lo12:.LANCHOR56]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	cmp	w22, w2
	beq	.L1974
	adrp	x1, .LANCHOR153
	adrp	x0, .LC0
	mov	w2, 448
	add	x1, x1, :lo12:.LANCHOR153
	add	x0, x0, :lo12:.LC0
	bl	printf
.L1975:
	b	.L1975
.L1972:
	adrp	x26, .LANCHOR107
	lsl	x19, x21, 2
	ldr	x0, [x26, #:lo12:.LANCHOR107]
	ldr	w2, [x0, x19]
	cmn	w2, #1
	beq	.L1963
	adrp	x0, .LANCHOR45
	ldrb	w0, [x0, #:lo12:.LANCHOR45]
	lsl	w0, w0, 7
	udiv	w0, w2, w0
	and	w0, w0, 65535
	str	w0, [x29, 156]
	ldr	w0, [x20, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L1964
	ldr	w1, [x29, 156]
	adrp	x0, .LC103
	mov	w3, w21
	add	x0, x0, :lo12:.LC103
	bl	printf
.L1964:
	sub	w27, w25, w27
	add	x27, x27, x21
	lsl	x0, x27, 2
	str	x0, [x29, 136]
	adrp	x0, .LC105
	add	x0, x0, :lo12:.LC105
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR71
	add	x0, x0, :lo12:.LANCHOR71
	str	x0, [x29, 112]
.L1965:
	ldr	x0, [x29, 136]
	cmp	x0, x19
	bne	.L1971
.L1963:
	add	x21, x21, 1
	b	.L1962
.L1971:
	ldr	x0, [x26, #:lo12:.LANCHOR107]
	ldr	w28, [x0, x19]
	cmn	w28, #1
	beq	.L1966
	ldr	x0, [x29, 104]
	ldr	w1, [x29, 156]
	ldrb	w0, [x0]
	lsl	w0, w0, 7
	udiv	w0, w28, w0
	cmp	w1, w0, uxth
	bne	.L1966
	adrp	x0, .LANCHOR108
	ldr	x0, [x0, #:lo12:.LANCHOR108]
	ldr	w27, [x0, x19]
	mov	w0, w28
	bl	lpa_hash_get_ppa
	str	w0, [x29, 172]
	cmn	w0, #1
	bne	.L1967
	mov	w2, 0
	add	x1, x29, 172
	mov	w0, w28
	bl	pm_log2phys
.L1967:
	ldr	w3, [x29, 172]
	cmp	w27, w3
	bne	.L1968
	adrp	x0, .LANCHOR109
	mov	w2, 1
	add	x1, x29, 168
	add	w22, w22, 1
	ldr	x0, [x0, #:lo12:.LANCHOR109]
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
	adrp	x0, .LANCHOR70
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	udiv	w1, w1, w0
	and	w1, w1, 65535
	str	w1, [x29, 152]
	mov	w0, w1
	bl	ftl_vpn_decrement
	ldr	x0, [x29, 144]
	ldr	w1, [x29, 152]
	ldrh	w0, [x0]
	cmp	w0, w1
	bne	.L1969
	ldr	w0, [x20, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L1969
	ldr	w3, [x29, 172]
	adrp	x0, .LC104
	mov	w2, w27
	mov	w1, w28
	add	x0, x0, :lo12:.LC104
	bl	printf
.L1969:
	ldr	x0, [x26, #:lo12:.LANCHOR107]
	mov	w1, -1
	str	w1, [x0, x19]
.L1966:
	add	x19, x19, 4
	b	.L1965
.L1968:
	ldr	w0, [x20, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L1970
	ldr	x0, [x29, 120]
	mov	w2, w27
	mov	w1, w28
	bl	printf
.L1970:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0]
	bl	ftl_vpn_decrement
	b	.L1969
.L1974:
	strh	w22, [x1, x0]
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
	adrp	x19, .LANCHOR58
	add	x1, x19, :lo12:.LANCHOR58
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	str	x25, [sp, 64]
	ldrb	w0, [x1, 4]
	add	x2, x1, x0, sxtw 1
	ldrh	w3, [x2, 40]
	adrp	x2, .LANCHOR69
	ldrb	w4, [x2, #:lo12:.LANCHOR69]
	ldrh	w2, [x1, 2]
.L1999:
	cmp	w3, w7
	beq	.L2001
	cbz	w6, .L2002
	add	x1, x19, :lo12:.LANCHOR58
	strb	w0, [x1, 4]
.L2002:
	cbz	w5, .L2003
	add	x0, x19, :lo12:.LANCHOR58
	strh	w2, [x0, 2]
.L2003:
	adrp	x0, .LANCHOR75
	ldrh	w22, [x0, #:lo12:.LANCHOR75]
	adrp	x0, .LANCHOR64
	mov	x23, x0
	ldrb	w1, [x0, #:lo12:.LANCHOR64]
	mul	w22, w22, w3
	cmp	w1, 2
	bne	.L2004
	add	x0, x19, :lo12:.LANCHOR58
	ldrb	w1, [x0, 6]
	cbnz	w1, .L2004
	ldrh	w0, [x0, 2]
	add	w22, w22, w0, lsl 1
.L2005:
	add	x1, x19, :lo12:.LANCHOR58
	ldrb	w0, [x1, 4]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x1, 4]
	cmp	w4, w0
	bne	.L2006
	ldrh	w0, [x1, 2]
	strb	wzr, [x1, 4]
	add	w0, w0, 1
	strh	w0, [x1, 2]
.L2006:
	mov	w0, 1
	add	x19, x19, :lo12:.LANCHOR58
	bl	buf_alloc
	add	x23, x23, :lo12:.LANCHOR64
	mov	x21, x0
	mov	w20, 0
	adrp	x24, .LANCHOR61
.L2016:
	ldrb	w0, [x19, 6]
	cmp	w0, 3
	bne	.L2007
	cbz	w20, .L2008
.L2007:
	cmp	w0, w20
	bgt	.L2009
.L2017:
	mov	x0, x21
	bl	buf_free
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2001:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, w4
	bne	.L2000
	add	w2, w2, 1
	mov	w5, 1
	and	w2, w2, 65535
	mov	w0, 0
.L2000:
	add	x3, x1, x0, sxtw 1
	mov	w6, 1
	ldrh	w3, [x3, 40]
	b	.L1999
.L2004:
	add	x0, x19, :lo12:.LANCHOR58
	ldrh	w0, [x0, 2]
	add	w22, w0, w22
	b	.L2005
.L2009:
	ldrb	w1, [x23]
	cmp	w1, 2
	bne	.L2010
	cbnz	w0, .L2010
	add	w0, w20, w22
	orr	w0, w0, 33554432
.L2030:
	str	w0, [x21, 40]
	mov	w1, 1
	mov	x0, x21
	bl	sblk_read_page
	ldr	w0, [x21, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2013
	ldr	x0, [x21, 24]
	ldr	w25, [x0, 4]
	mov	w0, w25
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L2014
	mov	w2, 0
	add	x1, x29, 92
	mov	w0, w25
	bl	pm_log2phys
.L2014:
	ldr	w0, [x29, 92]
	cmp	w22, w0
	bne	.L2013
	ldrh	w0, [x19, 24]
	ldr	x2, [x24, #:lo12:.LANCHOR61]
	ubfiz	x1, x0, 2, 16
	add	w0, w0, 1
	str	w22, [x2, x1]
	strh	w0, [x19, 24]
.L2013:
	ldrh	w0, [x19, 26]
	add	w0, w0, 1
	strh	w0, [x19, 26]
.L2008:
	add	w20, w20, 1
	cmp	w20, 4
	bne	.L2016
	b	.L2017
.L2010:
	orr	w0, w22, w20, lsl 24
	b	.L2030
	.size	gc_scan_src_blk_one_page, .-gc_scan_src_blk_one_page
	.section	.text.gc_scan_static_data,"ax",@progbits
	.align	2
	.global	gc_scan_static_data
	.type	gc_scan_static_data, %function
gc_scan_static_data:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR60
	stp	x21, x22, [sp, 32]
	ldr	x0, [x19, #:lo12:.LANCHOR60]
	ldr	w1, [x0, 544]
	str	x23, [sp, 48]
	cmn	w1, #1
	beq	.L2032
	adrp	x21, .LANCHOR71
	adrp	x22, .LANCHOR70
	add	x21, x21, :lo12:.LANCHOR71
	add	x22, x22, :lo12:.LANCHOR70
	mov	w20, 11
.L2041:
	ldr	x0, [x19, #:lo12:.LANCHOR60]
	mov	w2, 0
	add	x1, x29, 76
	ldr	w0, [x0, 544]
	bl	pm_log2phys
	ldr	w0, [x29, 76]
	cmn	w0, #1
	beq	.L2033
	mov	w0, 1
	bl	buf_alloc
	ldr	w1, [x29, 76]
	mov	x23, x0
	str	w1, [x0, 40]
	mov	w1, 1
	bl	sblk_read_page
	ldr	w0, [x23, 52]
	cmp	w0, 256
	bne	.L2034
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
.L2034:
	ldr	x0, [x19, #:lo12:.LANCHOR60]
	ldr	x1, [x23, 24]
	ldr	w0, [x0, 544]
	ldr	w1, [x1, 4]
	cmp	w1, w0
	beq	.L2035
	adrp	x1, .LANCHOR154
	adrp	x0, .LC0
	mov	w2, 1149
	add	x1, x1, :lo12:.LANCHOR154
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2036:
	b	.L2036
.L2035:
	mov	x0, x23
	bl	buf_free
.L2033:
	ldr	x0, [x19, #:lo12:.LANCHOR60]
	adrp	x2, .LANCHOR47
	ldr	w2, [x2, #:lo12:.LANCHOR47]
	ldr	w1, [x0, 544]
	add	w1, w1, 1
	str	w1, [x0, 544]
	cmp	w1, w2
	bcc	.L2037
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
.L2031:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2037:
	ldr	w0, [x29, 76]
	cmn	w0, #1
	bne	.L2031
	sub	w20, w20, #1
	ands	w20, w20, 65535
	bne	.L2041
	b	.L2031
.L2032:
	adrp	x1, .LANCHOR46
	ldr	x1, [x1, #:lo12:.LANCHOR46]
	ldr	w2, [x1, 40]
	cmp	w2, 20480
	bls	.L2043
	ldr	w3, [x1, 44]
	add	w3, w3, w2, lsr 10
	and	w2, w2, 1023
	stp	w2, w3, [x1, 40]
.L2043:
	ldr	w2, [x0, 536]
	ldr	w3, [x0, 12]
	add	w2, w2, 12959744
	add	w2, w2, 256
	cmp	w3, w2
	ldr	w2, [x1, 44]
	bhi	.L2044
	ldr	w1, [x0, 540]
	add	w1, w1, 98304
	add	w1, w1, 1696
	cmp	w2, w1
	bls	.L2031
.L2044:
	str	w3, [x0, 536]
	str	w2, [x0, 540]
	str	wzr, [x0, 544]
	b	.L2031
	.size	gc_scan_static_data, .-gc_scan_static_data
	.section	.text.ftl_sblk_dump,"ax",@progbits
	.align	2
	.global	ftl_sblk_dump
	.type	ftl_sblk_dump, %function
ftl_sblk_dump:
	sub	sp, sp, #256
	stp	x29, x30, [sp, 48]
	add	x29, sp, 48
	stp	x23, x24, [sp, 96]
	and	w23, w0, 65535
	stp	x19, x20, [sp, 64]
	mov	w0, 65535
	stp	x21, x22, [sp, 80]
	cmp	w23, w0
	stp	x25, x26, [sp, 112]
	stp	x27, x28, [sp, 128]
	beq	.L2072
	uxtw	x0, w23
	str	x0, [x29, 128]
	lsl	x14, x0, 2
	adrp	x0, .LANCHOR59
	mov	x13, x0
	ldr	x2, [x0, #:lo12:.LANCHOR59]
	add	x2, x2, x14
	ldrb	w2, [x2, 2]
	and	w2, w2, 224
	cmp	w2, 160
	bne	.L2073
	adrp	x0, .LANCHOR64
	ldrb	w25, [x0, #:lo12:.LANCHOR64]
.L2052:
	add	x28, x29, 208
	str	x1, [x29, 144]
	mov	w0, w23
	adrp	x21, .LANCHOR22
	strh	w23, [x28, -32]!
	add	x1, x28, 16
	bl	ftl_get_blk_list_in_sblk
	adrp	x2, .LANCHOR79
	and	w1, w0, 255
	strb	w1, [x29, 185]
	ldrh	w3, [x2, #:lo12:.LANCHOR79]
	strh	wzr, [x29, 178]
	strb	wzr, [x29, 181]
	strh	wzr, [x29, 186]
	mul	w1, w1, w3
	str	x2, [x29, 120]
	strh	w1, [x29, 182]
	ldr	w1, [x21, #:lo12:.LANCHOR22]
	tbz	x1, 12, .L2053
	ldr	x1, [x13, #:lo12:.LANCHOR59]
	and	w4, w0, 255
	mov	w3, w25
	adrp	x0, .LC107
	add	x1, x1, x14
	add	x0, x0, :lo12:.LC107
	ldrb	w2, [x1, 2]
	mov	w1, w23
	ubfx	x2, x2, 5, 3
	bl	printf
.L2053:
	mov	w0, 1
	bl	buf_alloc
	mov	w27, 0
	mov	x26, x0
	mov	w20, 0
	adrp	x0, .LANCHOR75
	stp	wzr, wzr, [x29, 152]
	add	x0, x0, :lo12:.LANCHOR75
	str	x0, [x29, 96]
.L2054:
	ldr	x0, [x29, 120]
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	cmp	w0, w20
	bls	.L2069
	lsl	w0, w20, 1
	mov	w24, 0
	sub	w0, w0, #1
	str	w0, [x29, 140]
	adrp	x0, .LC109
	add	x0, x0, :lo12:.LC109
	str	x0, [x29, 104]
	b	.L2070
.L2073:
	mov	w25, 1
	b	.L2052
.L2066:
	ldr	x0, [x29, 112]
	ldrh	w10, [x28, x0]
	mov	w0, 65535
	cmp	w10, w0
	beq	.L2055
	ldr	x0, [x29, 96]
	cmp	w25, 3
	ldrh	w19, [x0]
	mul	w19, w19, w10
	bne	.L2056
	add	w19, w20, w19
	orr	w19, w19, w22, lsl 24
.L2057:
	str	w19, [x26, 40]
	mov	w1, 1
	str	w10, [x29, 136]
	mov	x0, x26
	bl	sblk_read_page
	ldr	w0, [x21, #:lo12:.LANCHOR22]
	ldr	w11, [x26, 52]
	ldr	w10, [x29, 136]
	tbz	x0, 12, .L2059
	ldr	x1, [x26, 24]
	mov	w4, w11
	ldr	x0, [x26, 8]
	mov	w3, w19
	str	w11, [x29, 136]
	ldr	w2, [x1, 12]
	str	w2, [sp, 32]
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
	adrp	x0, .LC73
	add	x0, x0, :lo12:.LC73
	bl	printf
	ldr	w11, [x29, 136]
.L2059:
	cmp	w11, 512
	ldr	w0, [x29, 152]
	ccmn	w11, #1, 4, ne
	csinc	w0, w0, wzr, ne
	str	w0, [x29, 152]
	ldr	x0, [x26, 24]
	ldr	w3, [x0, 4]
	str	w3, [x29, 136]
	mov	w0, w3
	bl	lpa_hash_get_ppa
	str	w0, [x29, 172]
	cmn	w0, #1
	ldr	w3, [x29, 136]
	bne	.L2061
	mov	w2, 0
	add	x1, x29, 172
	mov	w0, w3
	bl	pm_log2phys
.L2061:
	ldr	w0, [x29, 172]
	cmp	w19, w0
	bne	.L2062
	ldr	w0, [x29, 156]
	add	w0, w0, 1
	str	w0, [x29, 156]
	ldr	w0, [x21, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L2062
	ldr	x0, [x26, 24]
	mov	w1, w19
	ldr	w3, [x29, 156]
	ldr	w2, [x0, 4]
	adrp	x0, .LC108
	add	x0, x0, :lo12:.LC108
	bl	printf
.L2062:
	ldr	x0, [x29, 144]
	cbz	x0, .L2063
	ubfiz	x19, x27, 2, 32
	ldr	w2, [x0, x19]
	ldr	x0, [x26, 24]
	ldr	w0, [x0, 4]
	cmp	w0, w2
	beq	.L2064
	ldr	w0, [x21, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L2064
	ldr	x0, [x29, 104]
	mov	w1, w27
	bl	printf
.L2064:
	ldr	x1, [x26, 24]
	ldr	x0, [x29, 144]
	ldr	w1, [x1, 4]
	ldr	w0, [x0, x19]
	cmp	w1, w0
	beq	.L2063
	cmn	w0, #1
	beq	.L2063
	adrp	x1, .LANCHOR155
	adrp	x0, .LC0
	mov	w2, 616
	add	x1, x1, :lo12:.LANCHOR155
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2065:
	b	.L2065
.L2056:
	cmp	w25, 2
	bne	.L2058
	ldr	w0, [x29, 140]
	add	w19, w19, w0
	adrp	x0, .LANCHOR64
	add	w19, w19, w22
	ldrb	w0, [x0, #:lo12:.LANCHOR64]
	orr	w19, w19, w0, lsl 24
	b	.L2057
.L2058:
	add	w19, w20, w19
	b	.L2057
.L2063:
	add	w27, w27, 1
.L2055:
	add	w22, w22, 1
	and	w22, w22, 65535
.L2068:
	cmp	w25, w22
	bcs	.L2066
	add	w24, w24, 1
	and	w24, w24, 65535
.L2070:
	ldrb	w0, [x29, 185]
	cmp	w0, w24
	bls	.L2067
	sxtw	x0, w24
	mov	w22, 1
	add	x0, x0, 8
	lsl	x0, x0, 1
	str	x0, [x29, 112]
	b	.L2068
.L2067:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2054
.L2069:
	mov	x0, x26
	bl	buf_free
	ldr	w0, [x21, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L2071
	adrp	x0, .LANCHOR56
	ldr	x1, [x29, 128]
	ldr	w3, [x29, 156]
	ldr	x0, [x0, #:lo12:.LANCHOR56]
	ldrh	w2, [x0, x1, lsl 1]
	adrp	x0, .LC110
	mov	w1, w23
	add	x0, x0, :lo12:.LC110
	bl	printf
.L2071:
	ldr	w0, [x29, 152]
.L2050:
	ldp	x19, x20, [sp, 64]
	ldp	x21, x22, [sp, 80]
	ldp	x23, x24, [sp, 96]
	ldp	x25, x26, [sp, 112]
	ldp	x27, x28, [sp, 128]
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 256
	ret
.L2072:
	mov	w0, 0
	b	.L2050
	.size	ftl_sblk_dump, .-ftl_sblk_dump
	.section	.text.gc_search_src_blk,"ax",@progbits
	.align	2
	.global	gc_search_src_blk
	.type	gc_search_src_blk, %function
gc_search_src_blk:
	stp	x29, x30, [sp, -160]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR60
	and	w23, w0, 255
	and	w0, w1, 255
	str	w0, [x29, 156]
	ldr	x0, [x24, #:lo12:.LANCHOR60]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	add	x0, x0, x23, sxtw 1
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldrh	w19, [x0, 120]
	cbnz	w19, .L2098
	adrp	x26, .LANCHOR46
	and	w27, w2, 255
	ldr	x0, [x26, #:lo12:.LANCHOR46]
	ldrh	w20, [x0, 134]
	adrp	x0, .LANCHOR22
	str	x0, [x29, 144]
	ldr	w1, [x0, #:lo12:.LANCHOR22]
	tbz	x1, 8, .L2101
	ldr	w2, [x29, 156]
	adrp	x0, .LC111
	mov	w3, w27
	mov	w1, w23
	add	x0, x0, :lo12:.LC111
	bl	printf
.L2101:
	ldr	x0, [x29, 144]
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L2102
	ldr	x1, [x24, #:lo12:.LANCHOR60]
	adrp	x2, .LANCHOR57
	ldr	x0, [x26, #:lo12:.LANCHOR46]
	ldrh	w3, [x2, #:lo12:.LANCHOR57]
	ldrh	w2, [x1, 126]
	ldrh	w1, [x0, 134]
	adrp	x0, .LC111
	add	x0, x0, :lo12:.LC111
	bl	printf
.L2102:
	cmp	w27, 64
	bls	.L2103
	adrp	x1, .LANCHOR156
	adrp	x0, .LC0
	mov	w2, 1028
	add	x1, x1, :lo12:.LANCHOR156
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2104:
	b	.L2104
.L2103:
	adrp	x0, .LANCHOR69
	adrp	x22, .LANCHOR79
	ldrb	w21, [x0, #:lo12:.LANCHOR69]
	adrp	x0, .LANCHOR68
	ldrh	w3, [x22, #:lo12:.LANCHOR79]
	ldrh	w1, [x0, #:lo12:.LANCHOR68]
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR54
	str	x0, [x29, 120]
	mul	w3, w21, w3
	mul	w21, w21, w1
	ldr	x1, [x26, #:lo12:.LANCHOR46]
	and	w28, w3, 65535
	and	w21, w21, 65535
	ldrh	w25, [x1, 134]
	add	x1, x0, :lo12:.LANCHOR54
	adrp	x0, .LANCHOR105
	str	x1, [x29, 136]
	add	x0, x0, :lo12:.LANCHOR105
	str	x0, [x29, 112]
.L2105:
	ldr	x0, [x29, 136]
	ldrh	w1, [x0]
	ldr	x0, [x26, #:lo12:.LANCHOR46]
	ldrh	w0, [x0, 134]
	sub	w2, w1, w0
	cmp	w25, w2
	blt	.L2117
.L2114:
	ldr	x0, [x26, #:lo12:.LANCHOR46]
	ldrh	w1, [x0, 134]
	ldr	x0, [x29, 120]
	ldrh	w0, [x0, #:lo12:.LANCHOR54]
	sub	w0, w0, w1
	cmp	w25, w0
	ldr	x0, [x24, #:lo12:.LANCHOR60]
	blt	.L2118
	strh	w1, [x0, 126]
	cbnz	w23, .L2119
	adrp	x0, .LANCHOR57
	ldrh	w1, [x0, #:lo12:.LANCHOR57]
	cmp	w1, w28
	bcs	.L2120
	strh	w28, [x0, #:lo12:.LANCHOR57]
.L2120:
	ldrh	w1, [x22, #:lo12:.LANCHOR79]
	mov	w2, 7
	ldrh	w3, [x0, #:lo12:.LANCHOR57]
	mul	w2, w1, w2
	cmp	w3, w2, lsr 3
	bge	.L2122
	add	w1, w3, w1, lsr 3
	strh	w1, [x0, #:lo12:.LANCHOR57]
.L2122:
	ldr	x0, [x29, 144]
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L2128
	adrp	x0, .LC113
	mov	w1, w19
	add	x0, x0, :lo12:.LC113
	bl	printf
.L2128:
	bl	print_ftl_debug_info
.L2098:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L2117:
	ldr	x2, [x24, #:lo12:.LANCHOR60]
	ldrh	w20, [x2, 126]
	add	w20, w25, w20
	and	w20, w20, 65535
	cmp	w1, w20
	bhi	.L2106
	sub	w0, w0, w1
	add	w20, w20, w0
	and	w20, w20, 65535
	cmp	w1, w20
	bhi	.L2106
	adrp	x1, .LANCHOR156
	adrp	x0, .LC0
	mov	w2, 1038
	add	x1, x1, :lo12:.LANCHOR156
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2107:
	b	.L2107
.L2106:
	adrp	x0, .LANCHOR59
	uxtw	x4, w20
	ldr	x0, [x0, #:lo12:.LANCHOR59]
	add	x0, x0, x4, lsl 2
	ldrb	w1, [x0, 2]
	mov	w0, 224
	and	w1, w1, 224
	cmp	w1, 32
	ccmp	w1, w0, 4, ne
	beq	.L2108
	adrp	x5, .LANCHOR56
	lsl	x4, x4, 1
	ldr	x0, [x5, #:lo12:.LANCHOR56]
	cbnz	w1, .L2109
	ldrh	w1, [x0, x4]
	cbz	w1, .L2110
	mov	w2, w20
	stp	x5, x4, [x29, 96]
	adrp	x0, .LC112
	add	x0, x0, :lo12:.LC112
	bl	printf
	mov	x1, 0
	mov	w0, w20
	bl	ftl_sblk_dump
	ldp	x5, x4, [x29, 96]
.L2110:
	ldr	x0, [x5, #:lo12:.LANCHOR56]
	ldrh	w0, [x0, x4]
	cbz	w0, .L2108
	adrp	x1, .LANCHOR156
	adrp	x0, .LC0
	mov	w2, 1047
	add	x1, x1, :lo12:.LANCHOR156
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2111:
	b	.L2111
.L2109:
	ldrh	w0, [x0, x4]
	mov	w2, 65535
	cmp	w0, w2
	beq	.L2108
	cmp	w1, 160
	ldr	w3, [x29, 156]
	cset	w2, eq
	add	w2, w2, 1
	and	w2, w3, w2
	cbnz	w23, .L2113
	cmp	w0, w28
	csel	w3, w0, w28, cc
	and	w28, w3, 65535
	cbz	w2, .L2108
	adrp	x1, .LANCHOR57
	ldrh	w1, [x1, #:lo12:.LANCHOR57]
	cmp	w1, w0
	bls	.L2108
	mov	w2, 0
	mov	w1, 0
	mov	w0, w20
	bl	gc_add_sblk
	cbz	w0, .L2108
.L2161:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2115
.L2113:
	cbz	w2, .L2115
	bne	.L2116
	adrp	x1, .LANCHOR106
	cmp	w0, w21
	csel	w21, w0, w21, cc
	ldrh	w1, [x1, #:lo12:.LANCHOR106]
	and	w21, w21, 65535
	cmp	w1, w0
	bls	.L2115
.L2163:
	mov	w2, w23
	mov	w1, 0
	mov	w0, w20
	bl	gc_add_sblk
	cbz	w0, .L2115
	b	.L2161
.L2116:
	ldr	x1, [x29, 112]
	cmp	w0, w28
	csel	w3, w0, w28, cc
	and	w28, w3, 65535
	ldrh	w1, [x1]
	cmp	w1, w0
	bls	.L2163
.L2115:
	cmp	w19, w27
	bhi	.L2114
.L2108:
	add	w25, w25, 1
	and	w25, w25, 65535
	b	.L2105
.L2119:
	ldr	x0, [x29, 128]
	adrp	x1, .LANCHOR70
	ldrb	w1, [x1, #:lo12:.LANCHOR70]
	ldrh	w0, [x0, #:lo12:.LANCHOR68]
	mul	w0, w0, w1
	adrp	x1, .LANCHOR106
	cmp	w21, w0
	beq	.L2123
	ldrh	w2, [x1, #:lo12:.LANCHOR106]
	cmp	w2, w21
	bcs	.L2123
	strh	w21, [x1, #:lo12:.LANCHOR106]
.L2123:
	ldrh	w4, [x22, #:lo12:.LANCHOR79]
	ldrh	w2, [x1, #:lo12:.LANCHOR106]
	lsr	w3, w4, 3
	sub	w0, w0, w3
	cmp	w2, w0
	bge	.L2124
	add	w2, w2, w3
	strh	w2, [x1, #:lo12:.LANCHOR106]
.L2124:
	adrp	x1, .LANCHOR105
	ldrh	w0, [x1, #:lo12:.LANCHOR105]
	cmp	w0, w4, lsr 1
	bls	.L2122
	sub	w0, w0, w3
	strh	w0, [x1, #:lo12:.LANCHOR105]
	b	.L2122
.L2118:
	strh	w20, [x0, 126]
	cbnz	w23, .L2126
	adrp	x1, .LANCHOR57
	ldrh	w0, [x22, #:lo12:.LANCHOR79]
	ldrh	w2, [x1, #:lo12:.LANCHOR57]
	cmp	w2, w0, lsr 2
	bls	.L2122
	sub	w0, w2, w0, lsr 3
	strh	w0, [x1, #:lo12:.LANCHOR57]
	b	.L2122
.L2126:
	adrp	x0, .LANCHOR106
	ldrh	w2, [x22, #:lo12:.LANCHOR79]
	ldrh	w1, [x0, #:lo12:.LANCHOR106]
	cmp	w1, w2, lsr 1
	bls	.L2127
	sub	w1, w1, w2, lsr 3
	strh	w1, [x0, #:lo12:.LANCHOR106]
.L2127:
	adrp	x0, .LANCHOR70
	adrp	x3, .LANCHOR105
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	ldrh	w1, [x3, #:lo12:.LANCHOR105]
	mul	w0, w0, w2
	sub	w0, w0, #32
	cmp	w1, w0
	bge	.L2122
	add	w1, w1, 32
	strh	w1, [x3, #:lo12:.LANCHOR105]
	b	.L2122
	.size	gc_search_src_blk, .-gc_search_src_blk
	.section	.text.ftl_read,"ax",@progbits
	.align	2
	.global	ftl_read
	.type	ftl_read, %function
ftl_read:
	stp	x29, x30, [sp, -160]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	x23, x3
	stp	x25, x26, [sp, 64]
	mov	w26, w2
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	cbnz	w0, .L2165
	adrp	x0, .LANCHOR52
	ldr	w2, [x0, #:lo12:.LANCHOR52]
	mov	w0, 24576
.L2166:
	add	w3, w1, w26
	cmp	w2, w3
	bcc	.L2190
	add	w22, w0, w1
	adrp	x1, .LANCHOR46
	adrp	x24, .LANCHOR45
	str	x1, [x29, 120]
	ldr	x2, [x1, #:lo12:.LANCHOR46]
	ldr	w0, [x2, 24]
	add	w0, w0, w26
	str	w0, [x2, 24]
	ldrb	w0, [x24, #:lo12:.LANCHOR45]
	add	w2, w26, w22
	stp	w2, wzr, [x29, 136]
	sub	w2, w2, #1
	udiv	w27, w22, w0
	udiv	w0, w2, w0
	mov	w20, w27
	sub	w25, w0, w27
	str	w0, [x29, 132]
	add	w25, w25, 1
	adrp	x0, .LC101
	add	x0, x0, :lo12:.LC101
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR36
	add	x0, x0, :lo12:.LANCHOR36
	str	x0, [x29, 104]
.L2168:
	cbnz	w25, .L2188
	ldr	w0, [x29, 140]
.L2164:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L2165:
	cmp	w0, 3
	bhi	.L2190
	lsl	w0, w0, 13
	mov	w2, 8192
	b	.L2166
.L2188:
	ldrb	w1, [x24, #:lo12:.LANCHOR45]
	cmp	w20, w27
	ldr	w0, [x29, 132]
	and	w19, w1, 65535
	ccmp	w20, w0, 4, ne
	bne	.L2191
	cmp	w20, w27
	bne	.L2170
	udiv	w21, w22, w1
	and	w0, w26, 65535
	msub	w1, w21, w1, w22
	and	w21, w1, 65535
	sub	w19, w19, w21
	and	w19, w19, 65535
	cmp	w26, w19
	csel	w19, w0, w19, cc
.L2169:
	adrp	x0, .LANCHOR36
	add	x1, x0, :lo12:.LANCHOR36
	add	x1, x1, 2
	mov	w0, 0
.L2173:
	ldr	w2, [x1, 34]
	cmp	w20, w2
	bne	.L2171
	ldrb	w2, [x1]
	tbz	x2, 3, .L2171
	ldr	x1, [x29, 104]
	ubfiz	x0, x0, 6, 32
	lsl	w2, w19, 9
	ubfiz	x19, x19, 9, 16
	add	x0, x1, x0
	ubfiz	x21, x21, 9, 16
	ldr	x1, [x0, 8]
	mov	x0, x23
	add	x23, x23, x19
	add	x1, x1, x21
	bl	ftl_memcpy
.L2172:
	add	w20, w20, 1
	sub	w25, w25, #1
	b	.L2168
.L2170:
	ldr	w0, [x29, 136]
	msub	w19, w1, w20, w0
	and	w19, w19, 255
.L2191:
	mov	w21, 0
	b	.L2169
.L2171:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L2173
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 156]
	cmn	w0, #1
	bne	.L2174
	mov	w2, 0
	add	x1, x29, 156
	mov	w0, w20
	bl	pm_log2phys
.L2174:
	ldr	w0, [x29, 156]
	cmn	w0, #1
	bne	.L2175
	add	x21, x24, :lo12:.LANCHOR45
	mov	w19, 0
.L2176:
	ldrb	w0, [x21]
	cmp	w19, w0
	bcs	.L2172
	madd	w0, w20, w0, w19
	cmp	w22, w0
	bhi	.L2177
	ldr	w1, [x29, 136]
	cmp	w1, w0
	bls	.L2177
	mov	x0, x23
	add	x23, x23, 512
	mov	w2, 512
	mov	w1, 0
	bl	ftl_memset
.L2177:
	add	w19, w19, 1
	b	.L2176
.L2175:
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L2179
	bl	ftl_read_ahead
	b	.L2168
.L2179:
	ldr	x0, [x29, 120]
	ldr	x1, [x0, #:lo12:.LANCHOR46]
	ldr	w0, [x1, 40]
	add	w0, w0, 1
	str	w0, [x1, 40]
	ldr	w0, [x29, 156]
	stp	w0, w0, [x28, 40]
	ldrb	w0, [x24, #:lo12:.LANCHOR45]
	cmp	w0, w19
	bne	.L2181
	str	x23, [x28, 16]
.L2181:
	mov	w1, 1
	mov	x0, x28
	bl	sblk_read_page
	ldr	w10, [x28, 52]
	cmn	w10, #1
	beq	.L2192
	cmp	w10, 256
	bne	.L2182
	adrp	x0, .LANCHOR71
	mov	w4, 21
	mov	w5, 1
	stp	w10, w5, [x29, 96]
	ldrh	w1, [x0, #:lo12:.LANCHOR71]
	ldr	w0, [x29, 156]
	sub	w4, w4, w1
	ldp	w2, w3, [x28, 36]
	lsl	w4, w5, w4
	lsr	w0, w0, w1
	sub	w4, w4, #1
	and	w4, w4, w0
	adrp	x0, .LANCHOR70
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	udiv	w4, w4, w0
	adrp	x0, .LC114
	add	x0, x0, :lo12:.LC114
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
.L2182:
	ldr	x0, [x28, 24]
	ldr	w5, [x0, 4]
	cmp	w20, w5
	beq	.L2183
	ldr	w4, [x0]
	mov	w2, w20
	ldp	w6, w7, [x0, 8]
	str	w10, [x29, 128]
	ldrb	w1, [x28, 1]
	ldr	w3, [x29, 156]
	ldr	x0, [x29, 112]
	bl	printf
	adrp	x0, .LANCHOR71
	ldr	w1, [x29, 156]
	ldrh	w3, [x0, #:lo12:.LANCHOR71]
	mov	w0, 21
	sub	w2, w0, w3
	mov	w0, 1
	lsr	w1, w1, w3
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR70
	ldrb	w2, [x1, #:lo12:.LANCHOR70]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
	ldr	w10, [x29, 128]
.L2183:
	ldr	x0, [x28, 24]
	ldr	w0, [x0, 4]
	cmp	w20, w0
	bne	.L2184
	cmn	w10, #1
	bne	.L2185
.L2184:
	adrp	x1, .LANCHOR157
	adrp	x0, .LC0
	mov	w2, 911
	add	x1, x1, :lo12:.LANCHOR157
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2186:
	b	.L2186
.L2192:
	str	w10, [x29, 140]
	b	.L2182
.L2185:
	ldr	x0, [x28, 16]
	cbnz	x0, .L2187
	ldr	x1, [x28, 8]
	ubfiz	x21, x21, 9, 16
	lsl	w2, w19, 9
	mov	x0, x23
	add	x1, x1, x21
	bl	ftl_memcpy
.L2187:
	ubfiz	x19, x19, 9, 16
	mov	x0, x28
	add	x23, x23, x19
	bl	buf_free
	b	.L2172
.L2190:
	mov	w0, -1
	b	.L2164
	.size	ftl_read, .-ftl_read
	.section	.text.FtlRead,"ax",@progbits
	.align	2
	.global	FtlRead
	.type	FtlRead, %function
FtlRead:
	and	w0, w0, 255
	b	ftl_read
	.size	FtlRead, .-FtlRead
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
	b	ftl_read
	.size	StorageSysDataLoad, .-StorageSysDataLoad
	.section	.text.vpn_check,"ax",@progbits
	.align	2
	.global	vpn_check
	.type	vpn_check, %function
vpn_check:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR60
	stp	x21, x22, [sp, 32]
	adrp	x20, .LANCHOR56
	stp	x23, x24, [sp, 48]
	adrp	x21, .LANCHOR47
	stp	x25, x26, [sp, 64]
	adrp	x22, .LANCHOR54
	str	x27, [sp, 80]
	bl	dump_ftl_info
	ldr	x0, [x19, #:lo12:.LANCHOR60]
	mov	w24, 0
	add	x21, x21, :lo12:.LANCHOR47
	add	x23, x22, :lo12:.LANCHOR54
	ldrh	w3, [x0, 80]
	ldrh	w2, [x0, 48]
	ldrh	w1, [x0, 16]
	adrp	x0, .LC115
	add	x0, x0, :lo12:.LC115
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR60]
	ldr	x3, [x20, #:lo12:.LANCHOR56]
	ldrh	w1, [x0, 16]
	ldrh	w2, [x0, 22]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x3, x0]
	adrp	x0, .LC116
	add	x0, x0, :lo12:.LC116
	sub	w4, w3, w2
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR60]
	adrp	x19, check_vpc_tbl
	ldr	x3, [x20, #:lo12:.LANCHOR56]
	ldrh	w1, [x0, 48]
	ldrh	w2, [x0, 54]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x3, x0]
	adrp	x0, .LC117
	add	x0, x0, :lo12:.LC117
	sub	w4, w3, w2
	bl	printf
	mov	w2, 4352
	mov	w1, 0
	add	x0, x19, :lo12:check_vpc_tbl
	bl	ftl_memset
.L2202:
	ldr	w0, [x21]
	cmp	w24, w0
	bcc	.L2210
	adrp	x0, .LANCHOR54
	adrp	x23, .LC120
	add	x24, x0, :lo12:.LANCHOR54
	mov	x22, x0
	add	x23, x23, :lo12:.LC120
	mov	w21, 0
.L2211:
	ldrh	w0, [x24]
	cmp	w0, w21
	bhi	.L2213
	adrp	x23, .LC121
	add	x22, x22, :lo12:.LANCHOR54
	add	x19, x19, :lo12:check_vpc_tbl
	add	x23, x23, :lo12:.LC121
	mov	w21, 0
	adrp	x27, .LANCHOR59
.L2214:
	ldrh	w0, [x22]
	cmp	w0, w21
	bhi	.L2219
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2210:
	mov	w0, w24
	bl	lpa_hash_get_ppa
	str	w0, [x29, 108]
	cmn	w0, #1
	bne	.L2203
	mov	w2, 0
	add	x1, x29, 108
	mov	w0, w24
	bl	pm_log2phys
.L2204:
	ldr	w2, [x29, 108]
	cmn	w2, #1
	beq	.L2206
	adrp	x0, .LANCHOR71
	mov	w3, 21
	ldrh	w0, [x0, #:lo12:.LANCHOR71]
	sub	w1, w3, w0
	mov	w3, 1
	lsr	w0, w2, w0
	lsl	w3, w3, w1
	sub	w3, w3, #1
	and	w3, w3, w0
	adrp	x0, .LANCHOR70
	ldrb	w0, [x0, #:lo12:.LANCHOR70]
	udiv	w3, w3, w0
	ldrh	w0, [x22, #:lo12:.LANCHOR54]
	and	w25, w3, 65535
	and	w3, w3, 65535
	cmp	w0, w25
	bls	.L2207
	add	x0, x19, :lo12:check_vpc_tbl
	sxtw	x3, w3
	ldrh	w1, [x0, x3, lsl 1]
	add	w1, w1, 1
	strh	w1, [x0, x3, lsl 1]
.L2208:
	ldrh	w0, [x23]
	cmp	w0, w25
	bhi	.L2206
	adrp	x1, .LANCHOR158
	adrp	x0, .LC0
	mov	w2, 1111
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2209:
	b	.L2209
.L2203:
	adrp	x1, .LANCHOR71
	ldrh	w3, [x1, #:lo12:.LANCHOR71]
	mov	w1, 21
	sub	w2, w1, w3
	mov	w1, 1
	lsr	w0, w0, w3
	lsl	w1, w1, w2
	sub	w1, w1, #1
	and	w0, w1, w0
	adrp	x1, .LANCHOR70
	ldrb	w1, [x1, #:lo12:.LANCHOR70]
	udiv	w0, w0, w1
	ldrh	w1, [x22, #:lo12:.LANCHOR54]
	cmp	w1, w0, uxth
	bhi	.L2204
	adrp	x1, .LANCHOR158
	adrp	x0, .LC0
	mov	w2, 1101
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2205:
	b	.L2205
.L2207:
	mov	w1, w24
	adrp	x0, .LC118
	add	x0, x0, :lo12:.LC118
	bl	printf
	adrp	x0, .LANCHOR45
	mov	w2, 4
	ldrb	w3, [x0, #:lo12:.LANCHOR45]
	adrp	x0, .LANCHOR93+8
	ldr	x1, [x0, #:lo12:.LANCHOR93+8]
	adrp	x0, .LC119
	lsl	w3, w3, 7
	add	x0, x0, :lo12:.LC119
	bl	rknand_print_hex
	b	.L2208
.L2206:
	add	w24, w24, 1
	b	.L2202
.L2213:
	ldr	x1, [x20, #:lo12:.LANCHOR56]
	uxtw	x0, w21
	ldrh	w3, [x1, x0, lsl 1]
	add	x1, x19, :lo12:check_vpc_tbl
	ldrh	w2, [x1, w21, sxtw 1]
	cmp	w3, w2
	beq	.L2212
	adrp	x1, .LANCHOR59
	ldr	x1, [x1, #:lo12:.LANCHOR59]
	add	x0, x1, x0, lsl 2
	mov	w1, w21
	ldrb	w4, [x0, 2]
	mov	x0, x23
	ubfx	x4, x4, 5, 3
	bl	printf
.L2212:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L2211
.L2219:
	ldr	x0, [x27, #:lo12:.LANCHOR59]
	uxtw	x24, w21
	add	x0, x0, x24, lsl 2
	ldrb	w0, [x0, 2]
	tst	w0, 224
	bne	.L2215
	sxtw	x25, w21
	ldrh	w0, [x19, x25, lsl 1]
	cbnz	w0, .L2216
	ldr	x0, [x20, #:lo12:.LANCHOR56]
	lsl	x26, x24, 1
	ldrh	w0, [x0, x26]
	cbz	w0, .L2217
	mov	w1, w21
	mov	x0, x23
	bl	printf
.L2217:
	ldr	x0, [x20, #:lo12:.LANCHOR56]
	strh	wzr, [x0, x26]
.L2216:
	ldr	x0, [x20, #:lo12:.LANCHOR56]
	ldrh	w0, [x0, x24, lsl 1]
	cbz	w0, .L2215
	ldrh	w0, [x19, x25, lsl 1]
	cbz	w0, .L2215
	adrp	x1, .LANCHOR158
	adrp	x0, .LC0
	mov	w2, 1143
	add	x1, x1, :lo12:.LANCHOR158
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2218:
	b	.L2218
.L2215:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L2214
	.size	vpn_check, .-vpn_check
	.section	.text.ftl_info_check,"ax",@progbits
	.align	2
	.global	ftl_info_check
	.type	ftl_info_check, %function
ftl_info_check:
	stp	x29, x30, [sp, -128]!
	adrp	x0, .LANCHOR46
	add	x29, sp, 0
	ldr	x1, [x0, #:lo12:.LANCHOR46]
	stp	x27, x28, [sp, 80]
	adrp	x27, .LC122
	stp	x25, x26, [sp, 64]
	add	x27, x27, :lo12:.LC122
	adrp	x26, .LANCHOR54
	stp	x21, x22, [sp, 32]
	ldrh	w28, [x1, 134]
	mov	w25, 0
	stp	x23, x24, [sp, 48]
	mov	w21, 0
	stp	x19, x20, [sp, 16]
	mov	w23, 0
	str	x0, [x29, 112]
	mov	w24, 0
	add	x0, x26, :lo12:.LANCHOR54
	mov	w20, 0
	mov	w22, 0
	adrp	x26, .LANCHOR56
	str	x0, [x29, 120]
.L2234:
	ldr	x0, [x29, 120]
	ldrh	w0, [x0]
	cmp	w0, w28
	bhi	.L2249
	mov	w3, w20
	mov	w2, w21
	mov	w1, w22
	adrp	x0, .LC123
	add	x0, x0, :lo12:.LC123
	bl	printf
	mov	w1, w25
	mov	w3, w23
	mov	w2, w24
	adrp	x0, .LC124
	add	x0, x0, :lo12:.LC124
	bl	printf
	ldr	x0, [x29, 112]
	ldr	x0, [x0, #:lo12:.LANCHOR46]
	ldrh	w1, [x0, 114]
	cmp	w1, w25
	beq	.L2250
	strh	w25, [x0, 114]
.L2250:
	ldrh	w1, [x0, 118]
	cmp	w1, w24
	beq	.L2251
	strh	w24, [x0, 118]
.L2251:
	ldrh	w1, [x0, 116]
	cmp	w1, w23
	beq	.L2252
	strh	w23, [x0, 116]
.L2252:
	ldrh	w1, [x0, 122]
	cmp	w1, w22
	beq	.L2253
	strh	w22, [x0, 122]
.L2253:
	ldrh	w1, [x0, 120]
	cmp	w1, w21
	beq	.L2254
	strh	w21, [x0, 120]
.L2254:
	ldrh	w1, [x0, 124]
	cmp	w1, w20
	beq	.L2233
	strh	w20, [x0, 124]
.L2233:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2249:
	adrp	x0, .LANCHOR59
	uxtw	x19, w28
	ldr	x4, [x0, #:lo12:.LANCHOR59]
	add	x4, x4, x19, lsl 2
	ldrb	w0, [x4, 2]
	and	w1, w0, 224
	cmp	w1, 64
	bne	.L2235
	add	w22, w22, 1
	and	w22, w22, 65535
.L2268:
	ldr	x0, [x26, #:lo12:.LANCHOR56]
	ldrh	w1, [x0, x19, lsl 1]
	cmp	w1, 15
	bls	.L2241
	adrp	x0, .LANCHOR79
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
.L2265:
	adrp	x2, .LANCHOR69
	ldrb	w2, [x2, #:lo12:.LANCHOR69]
	mul	w0, w0, w2
	cmp	w1, w0
	bne	.L2237
.L2241:
	mov	w2, 0
	mov	w1, 1
	mov	w0, w28
	bl	gc_add_sblk
.L2237:
	add	w3, w28, 1
	and	w28, w3, 65535
	b	.L2234
.L2235:
	cmp	w1, 96
	bne	.L2238
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2268
.L2238:
	cmp	w1, 160
	bne	.L2240
	ldr	x0, [x26, #:lo12:.LANCHOR56]
	add	w21, w21, 1
	and	w21, w21, 65535
	ldrh	w1, [x0, x19, lsl 1]
	cmp	w1, 15
	bls	.L2241
	adrp	x0, .LANCHOR68
	ldrh	w0, [x0, #:lo12:.LANCHOR68]
	b	.L2265
.L2240:
	cbnz	w1, .L2237
	ands	w0, w0, 24
	bne	.L2242
	add	w25, w25, 1
	and	w25, w25, 65535
.L2243:
	ldr	x0, [x26, #:lo12:.LANCHOR56]
	lsl	x19, x19, 1
	ldrh	w2, [x0, x19]
	cbz	w2, .L2245
	str	x4, [x29, 104]
	mov	w1, w28
	mov	x0, x27
	bl	printf
	ldr	x4, [x29, 104]
	ldrb	w0, [x4, 2]
	tbz	x0, 4, .L2246
	mov	w1, 5
.L2263:
	bfi	w0, w1, 5, 3
	strb	w0, [x4, 2]
	mov	w2, 0
	mov	w1, 1
	mov	w0, w28
	bl	gc_add_sblk
	bl	vpn_check
.L2245:
	adrp	x0, .LANCHOR56
	ldr	x0, [x0, #:lo12:.LANCHOR56]
	ldrh	w0, [x0, x19]
	cbz	w0, .L2237
	adrp	x1, .LANCHOR159
	adrp	x0, .LC0
	mov	w2, 1202
	add	x1, x1, :lo12:.LANCHOR159
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2248:
	b	.L2248
.L2242:
	cmp	w0, 16
	bne	.L2244
	add	w24, w24, 1
	and	w24, w24, 65535
	b	.L2243
.L2244:
	add	w23, w23, 1
	and	w23, w23, 65535
	b	.L2243
.L2246:
	mov	w1, 2
	b	.L2263
	.size	ftl_info_check, .-ftl_info_check
	.section	.text.gc_scan_src_blk,"ax",@progbits
	.align	2
	.global	gc_scan_src_blk
	.type	gc_scan_src_blk, %function
gc_scan_src_blk:
	stp	x29, x30, [sp, -96]!
	mov	w0, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR58
	stp	x21, x22, [sp, 32]
	ldrh	w1, [x19, #:lo12:.LANCHOR58]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w1, w0
	bne	.L2270
	adrp	x1, .LANCHOR160
	adrp	x0, .LC0
	mov	w2, 880
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2271:
	b	.L2271
.L2270:
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L2272
	adrp	x2, .LANCHOR56
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR56]
	ldrh	w2, [x2, x0]
	adrp	x0, .LC125
	add	x0, x0, :lo12:.LC125
	bl	printf
.L2272:
	ldrh	w0, [x19, #:lo12:.LANCHOR58]
	add	x13, x19, :lo12:.LANCHOR58
	add	x1, x13, 40
	bl	ftl_get_blk_list_in_sblk
	and	w1, w0, 255
	strb	w1, [x13, 5]
	cbnz	w1, .L2273
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR58]
.L2309:
	mov	w0, 0
.L2269:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L2273:
	adrp	x1, .LANCHOR59
	ldrh	w3, [x19, #:lo12:.LANCHOR58]
	ldr	x1, [x1, #:lo12:.LANCHOR59]
	mov	x2, x3
	add	x1, x1, x3, lsl 2
	ldrb	w1, [x1, 2]
	and	w1, w1, 224
	cmp	w1, 32
	beq	.L2275
	cmp	w1, 224
	beq	.L2275
	cbz	w1, .L2276
	adrp	x3, .LANCHOR60
	ldr	x3, [x3, #:lo12:.LANCHOR60]
	ldrh	w4, [x3, 16]
	cmp	w4, w2
	beq	.L2275
	ldrh	w4, [x3, 48]
	cmp	w4, w2
	beq	.L2275
	ldrh	w3, [x3, 80]
	cmp	w3, w2
	bne	.L2307
.L2275:
	add	x0, x19, :lo12:.LANCHOR58
	mov	w1, -1
	strh	w1, [x19, #:lo12:.LANCHOR58]
	strh	wzr, [x0, 24]
	b	.L2309
.L2276:
	adrp	x0, .LANCHOR56
	ldr	x0, [x0, #:lo12:.LANCHOR56]
	ldrh	w0, [x0, x3, lsl 1]
	cbz	w0, .L2275
	adrp	x1, .LANCHOR160
	adrp	x0, .LC0
	mov	w2, 900
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2278:
	b	.L2278
.L2307:
	and	w0, w0, 255
	sub	w0, w0, #1
	add	x0, x13, x0, sxtw 1
	ldrh	w3, [x0, 40]
	mov	w0, 65535
	cmp	w3, w0
	bne	.L2279
	adrp	x1, .LANCHOR160
	adrp	x0, .LC0
	mov	w2, 908
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2280:
	b	.L2280
.L2279:
	adrp	x4, .LANCHOR75
	adrp	x2, .LANCHOR79
	cmp	w1, 160
	mov	x24, x2
	ldrh	w20, [x4, #:lo12:.LANCHOR75]
	adrp	x21, .LANCHOR68
	ldrh	w0, [x2, #:lo12:.LANCHOR79]
	sub	w0, w0, #1
	and	w0, w0, 65535
	mul	w20, w20, w3
	bne	.L2294
	adrp	x1, .LANCHOR64
	ldrb	w1, [x1, #:lo12:.LANCHOR64]
	and	w22, w1, 65535
	cmp	w1, 2
	orr	w20, w20, w1, lsl 24
	bne	.L2281
	ldrh	w0, [x21, #:lo12:.LANCHOR68]
	mov	w22, 2
	sub	w0, w0, #1
	and	w0, w0, 65535
.L2281:
	add	x23, x19, :lo12:.LANCHOR58
	orr	w20, w0, w20
	mov	w0, 1
	strb	w22, [x23, 6]
	strh	wzr, [x23, 2]
	strb	wzr, [x23, 4]
	strh	wzr, [x23, 26]
	bl	buf_alloc
	str	w20, [x0, 40]
	adrp	x20, .LANCHOR69
	mov	x25, x0
	mov	w1, 1
	bl	sblk_read_page
	ldrh	w2, [x21, #:lo12:.LANCHOR68]
	adrp	x21, .LANCHOR61
	ldrb	w0, [x20, #:lo12:.LANCHOR69]
	mov	w1, 255
	mul	w2, w2, w0
	ldr	x0, [x21, #:lo12:.LANCHOR61]
	lsl	w2, w2, 2
	bl	ftl_memset
	strh	wzr, [x23, 24]
	ldr	w0, [x25, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L2282
.L2284:
	mov	w0, -1
	b	.L2269
.L2294:
	mov	w22, 1
	b	.L2281
.L2282:
	ldr	x0, [x25, 24]
	mov	w23, 15555
	movk	w23, 0xf55f, lsl 16
	ldr	w0, [x0]
	cmp	w0, w23
	beq	.L2283
	ldrh	w0, [x19, #:lo12:.LANCHOR58]
	mov	x1, 0
	bl	ftl_sblk_dump
	ldr	x0, [x25, 24]
	ldr	w0, [x0]
	cmp	w0, w23
	beq	.L2284
	adrp	x1, .LANCHOR160
	adrp	x0, .LC0
	mov	w2, 937
	add	x1, x1, :lo12:.LANCHOR160
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2285:
	b	.L2285
.L2283:
	ldrh	w0, [x24, #:lo12:.LANCHOR79]
	adrp	x23, .LANCHOR70
	ldrb	w20, [x20, #:lo12:.LANCHOR69]
	add	x23, x23, :lo12:.LANCHOR70
	ldr	x24, [x25, 8]
	mov	x26, 0
	mul	w20, w20, w0
	mul	w20, w22, w20
	adrp	x22, .LANCHOR71
	add	x22, x22, :lo12:.LANCHOR71
	and	w20, w20, 65535
.L2286:
	cmp	w20, w26
	bgt	.L2291
	mov	x0, x25
	bl	buf_free
	ldrh	w1, [x19, #:lo12:.LANCHOR58]
	adrp	x20, .LANCHOR56
	add	x0, x19, :lo12:.LANCHOR58
	ldr	x3, [x20, #:lo12:.LANCHOR56]
	ubfiz	x2, x1, 1, 16
	ldrh	w2, [x3, x2]
	ldrh	w3, [x0, 24]
	cmp	w2, w3
	beq	.L2292
	adrp	x0, .LC126
	add	x0, x0, :lo12:.LC126
	bl	printf
.L2292:
	ldrh	w2, [x19, #:lo12:.LANCHOR58]
	add	x0, x19, :lo12:.LANCHOR58
	ldr	x1, [x20, #:lo12:.LANCHOR56]
	ldrh	w0, [x0, 24]
	ldrh	w1, [x1, x2, lsl 1]
	cmp	w1, w0
	bcs	.L2293
	bl	vpn_check
.L2293:
	add	x0, x19, :lo12:.LANCHOR58
	ldrh	w2, [x19, #:lo12:.LANCHOR58]
	ldr	x1, [x20, #:lo12:.LANCHOR56]
	ldrh	w3, [x0, 24]
	strh	w3, [x1, x2, lsl 1]
	strh	wzr, [x0, 28]
	ldrh	w0, [x0, 24]
	b	.L2269
.L2291:
	ldr	w0, [x24, x26, lsl 2]
	cmn	w0, #1
	beq	.L2288
	bl	lpa_hash_get_ppa
	str	w0, [x29, 92]
	cmn	w0, #1
	bne	.L2289
	ldr	w0, [x24, x26, lsl 2]
	mov	w2, 0
	add	x1, x29, 92
	bl	pm_log2phys
.L2289:
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
	ldrh	w2, [x19, #:lo12:.LANCHOR58]
	udiv	w0, w0, w1
	add	x1, x19, :lo12:.LANCHOR58
	cmp	w0, w2
	bne	.L2288
	ldrh	w0, [x1, 24]
	ldr	x4, [x21, #:lo12:.LANCHOR61]
	ubfiz	x2, x0, 2, 16
	add	w0, w0, 1
	str	w3, [x4, x2]
	strh	w0, [x1, 24]
.L2288:
	add	x26, x26, 1
	b	.L2286
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
	adrp	x23, .LANCHOR47
	stp	x27, x28, [sp, 96]
	add	x28, x23, :lo12:.LANCHOR47
	stp	x21, x22, [sp, 48]
	adrp	x24, .LC129
	stp	x25, x26, [sp, 80]
	bl	buf_alloc
	mov	w1, 0
	mov	x19, x0
	adrp	x0, .LC127
	add	x0, x0, :lo12:.LC127
	bl	printf
	add	x0, x24, :lo12:.LC129
	str	x0, [x29, 120]
.L2311:
	ldr	w0, [x23, #:lo12:.LANCHOR47]
	cmp	w20, w0
	bcc	.L2324
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
.L2324:
	mov	w0, -1
	str	w0, [x19, 36]
	tst	x20, 4095
	bne	.L2312
	ldr	w2, [x29, 140]
	adrp	x0, .LC128
	mov	w1, w20
	add	x0, x0, :lo12:.LC128
	bl	printf
.L2312:
	mov	w0, w20
	bl	lpa_hash_get_ppa
	str	w0, [x29, 140]
	cmn	w0, #1
	bne	.L2313
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w20
	bl	pm_log2phys
.L2313:
	ldr	w0, [x29, 140]
	stp	w0, w0, [x19, 40]
	cmn	w0, #1
	bne	.L2314
.L2316:
	add	w20, w20, 1
	b	.L2311
.L2314:
	mov	w1, 1
	mov	x0, x19
	bl	sblk_read_page
	ldr	w3, [x19, 52]
	ldr	x0, [x19, 24]
	cmp	w3, 256
	ccmn	w3, #1, 4, ne
	beq	.L2315
	ldr	w1, [x0, 4]
	cmp	w20, w1
	beq	.L2316
.L2315:
	ldr	x1, [x19, 8]
	add	x27, x24, :lo12:.LC129
	adrp	x25, .LANCHOR45
	adrp	x26, .LC130
	adrp	x22, .LANCHOR93
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
	bne	.L2317
.L2319:
	ldrb	w21, [x25, #:lo12:.LANCHOR45]
	mov	w0, w20
	bl	lpa_hash_get_ppa
	add	x22, x22, :lo12:.LANCHOR93
	mov	w4, w0
	add	x0, x26, :lo12:.LC130
	lsl	w27, w21, 7
	ubfiz	w3, w21, 7, 9
	sub	w3, w3, #1
	add	x21, x22, 8
	and	w3, w3, w20
	adrp	x26, .LC132
	sdiv	w27, w20, w27
	and	w3, w3, 65535
	add	x22, x22, 520
	add	x26, x26, :lo12:.LC132
	mov	w1, w20
	and	w25, w27, 65535
	mov	w2, w25
	bl	printf
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w20
	bl	pm_log2phys
.L2318:
	ldr	x1, [x21]
	cbz	x1, .L2323
	ldrh	w0, [x21, -8]
	cmp	w0, w25
	bne	.L2323
	mov	w3, 4096
	mov	w2, 4
	mov	x0, x26
	bl	rknand_print_hex
.L2323:
	add	x21, x21, 16
	cmp	x22, x21
	bne	.L2318
	b	.L2316
.L2317:
	ldr	w21, [x1, 4]
	ldr	w1, [x28]
	cmp	w21, w1
	bcs	.L2319
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
	bne	.L2320
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w21
	bl	pm_log2phys
.L2320:
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
	ldrb	w3, [x25, #:lo12:.LANCHOR45]
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
	add	x0, x26, :lo12:.LC130
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
	add	x0, x22, :lo12:.LANCHOR93
	adrp	x5, .LC131
	add	x21, x0, 8
	add	x4, x0, 520
	add	x5, x5, :lo12:.LC131
.L2322:
	ldr	x1, [x21]
	cbz	x1, .L2321
	ldrh	w0, [x21, -8]
	cmp	w0, w27
	bne	.L2321
	mov	x0, x5
	stp	x4, x5, [x29, 104]
	mov	w3, 4096
	mov	w2, 4
	bl	rknand_print_hex
	ldp	x4, x5, [x29, 104]
.L2321:
	add	x21, x21, 16
	cmp	x4, x21
	bne	.L2322
	b	.L2319
	.size	ftl_scan_all_data, .-ftl_scan_all_data
	.section	.text.gc_recovery,"ax",@progbits
	.align	2
	.global	gc_recovery
	.type	gc_recovery, %function
gc_recovery:
	sub	sp, sp, #240
	adrp	x0, .LANCHOR67
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	stp	x21, x22, [sp, 64]
	adrp	x21, .LANCHOR60
	stp	x19, x20, [sp, 48]
	ldr	x20, [x21, #:lo12:.LANCHOR60]
	strb	wzr, [x0, #:lo12:.LANCHOR67]
	adrp	x0, .LANCHOR104
	stp	x23, x24, [sp, 80]
	strb	wzr, [x0, #:lo12:.LANCHOR104]
	stp	x25, x26, [sp, 96]
	stp	x27, x28, [sp, 112]
	bl	gc_init
	add	x0, x20, 80
	ldrh	w1, [x20, 80]
	str	x0, [x29, 168]
	mov	w0, 65535
	cmp	w1, w0
	ldr	x0, [x21, #:lo12:.LANCHOR60]
	beq	.L2335
	mov	w1, -1
	strh	w1, [x0, 130]
	mov	w0, 1
	bl	buf_alloc
	mov	x27, x0
	ldrb	w0, [x20, 89]
	add	x1, x20, 80
	adrp	x3, .LANCHOR75
	adrp	x2, .LANCHOR64
	sub	w0, w0, #1
	str	x3, [x29, 128]
	add	x0, x1, x0, sxtw 1
	ldrh	w1, [x3, #:lo12:.LANCHOR75]
	str	x2, [x29, 160]
	ldrh	w0, [x0, 16]
	mul	w1, w0, w1
	ldrb	w0, [x2, #:lo12:.LANCHOR64]
	str	w1, [x29, 200]
	cmp	w0, 3
	bne	.L2336
	adrp	x0, .LANCHOR79
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	sub	w0, w0, #1
	add	w0, w0, w1
	orr	w0, w0, 50331648
.L2383:
	str	w0, [x27, 40]
.L2337:
	mov	w1, 1
	mov	x0, x27
	bl	sblk_read_page
	ldr	w0, [x27, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	beq	.L2338
	ldr	x0, [x27, 24]
	ldr	w1, [x0]
	mov	w0, 15555
	movk	w0, 0xf55f, lsl 16
	cmp	w1, w0
	beq	.L2339
.L2338:
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
	adrp	x0, .LC133
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC133
	ldr	w1, [x27, 40]
	ldr	w2, [x27, 52]
	bl	printf
.L2387:
	adrp	x0, .LANCHOR56
	ldrh	w1, [x20, 80]
	mov	w22, 0
	ldr	x0, [x0, #:lo12:.LANCHOR56]
	strh	wzr, [x0, x1, lsl 1]
	ldr	x0, [x21, #:lo12:.LANCHOR60]
	ldrh	w1, [x20, 80]
	strh	w1, [x0, 130]
.L2340:
	ldrh	w1, [x20, 80]
	mov	w2, w22
	adrp	x0, .LC138
	add	x0, x0, :lo12:.LC138
	bl	printf
	mov	w0, -1
	strh	w0, [x20, 80]
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	x0, [x21, #:lo12:.LANCHOR60]
	mov	w1, 65535
	ldrh	w0, [x0, 130]
	cmp	w0, w1
	beq	.L2369
	bl	ftl_free_sblk
.L2369:
	adrp	x0, .LANCHOR46
	ldr	x1, [x0, #:lo12:.LANCHOR46]
	mov	w0, -1
	strh	w0, [x1, 126]
	ldr	x1, [x21, #:lo12:.LANCHOR60]
	strh	w0, [x1, 130]
	mov	w0, 0
	bl	ftl_info_flush
.L2334:
	ldp	x19, x20, [sp, 48]
	ldp	x21, x22, [sp, 64]
	ldp	x23, x24, [sp, 80]
	ldp	x25, x26, [sp, 96]
	ldp	x27, x28, [sp, 112]
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 240
	ret
.L2336:
	cmp	w0, 2
	bne	.L2337
	adrp	x0, .LANCHOR79
	ldrh	w0, [x0, #:lo12:.LANCHOR79]
	add	w0, w1, w0, lsl 1
	sub	w0, w0, #1
	orr	w0, w0, 33554432
	b	.L2383
.L2339:
	adrp	x26, .LANCHOR68
	adrp	x19, .LANCHOR69
	adrp	x23, .LANCHOR107
	ldr	x1, [x27, 8]
	ldrb	w0, [x19, #:lo12:.LANCHOR69]
	adrp	x22, .LANCHOR108
	ldrh	w2, [x26, #:lo12:.LANCHOR68]
	mul	w2, w2, w0
	ldr	x0, [x23, #:lo12:.LANCHOR107]
	lsl	w2, w2, 2
	bl	ftl_memcpy
	ldrb	w1, [x19, #:lo12:.LANCHOR69]
	ldrh	w0, [x26, #:lo12:.LANCHOR68]
	mul	w0, w0, w1
	ldr	x1, [x27, 8]
	lsl	w2, w0, 2
	add	x1, x1, x0, sxtw 2
	ldr	x0, [x22, #:lo12:.LANCHOR108]
	bl	ftl_memcpy
	ldrb	w0, [x19, #:lo12:.LANCHOR69]
	mov	w2, 4
	ldrh	w3, [x26, #:lo12:.LANCHOR68]
	ldr	x1, [x23, #:lo12:.LANCHOR107]
	mul	w3, w3, w0
	adrp	x0, .LC134
	add	x0, x0, :lo12:.LC134
	bl	rknand_print_hex
	ldrb	w0, [x19, #:lo12:.LANCHOR69]
	mov	w2, 4
	ldrh	w3, [x26, #:lo12:.LANCHOR68]
	ldr	x1, [x22, #:lo12:.LANCHOR108]
	mul	w3, w3, w0
	adrp	x0, .LC135
	add	x0, x0, :lo12:.LC135
	bl	rknand_print_hex
	str	x26, [x29, 120]
	adrp	x0, .LANCHOR79
	stp	x22, x23, [x29, 144]
	ldrh	w24, [x0, #:lo12:.LANCHOR79]
	ldr	x0, [x29, 160]
	ldrb	w0, [x0, #:lo12:.LANCHOR64]
	cmp	w0, 2
	beq	.L2341
.L2384:
	str	w0, [x29, 180]
	adrp	x23, .LC136
	ldr	x0, [x29, 128]
	add	x23, x23, :lo12:.LC136
	mov	w26, 0
	mov	w22, 0
	add	x0, x0, :lo12:.LANCHOR75
	str	x0, [x29, 104]
.L2343:
	sub	w0, w26, #1
	str	w0, [x29, 184]
	cmp	w26, w24
	beq	.L2352
	mov	x19, 0
	b	.L2353
.L2341:
	lsl	w24, w24, 1
	mov	w0, 1
	b	.L2384
.L2349:
	ldr	x1, [x29, 104]
	ldr	x0, [x29, 136]
	ldrh	w1, [x1]
	ldrh	w0, [x0, 96]
	mul	w0, w0, w1
	ldr	x1, [x29, 112]
	str	w0, [x29, 200]
	ldrb	w1, [x1]
	cmp	w1, 3
	bne	.L2344
	add	w0, w26, w0
	orr	w0, w0, w25, lsl 24
.L2385:
	str	w0, [x27, 40]
	mov	w1, 1
	mov	x0, x27
	bl	sblk_read_page
	ldr	x0, [x29, 152]
	ldr	x0, [x0, #:lo12:.LANCHOR107]
	ldr	w3, [x0, x28]
	ldr	x0, [x27, 24]
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bne	.L2347
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR108]
	ldr	w2, [x1, x28]
	ldr	w1, [x0, 8]
	cmp	w2, w1
	beq	.L2348
.L2347:
	ldr	x1, [x29, 144]
	ldr	w2, [x0, 12]
	str	w2, [sp]
	ldr	x1, [x1, #:lo12:.LANCHOR108]
	ldr	w5, [x0]
	ldr	w7, [x0, 8]
	mov	x0, x23
	ldr	w2, [x27, 52]
	ldr	w4, [x1, x28]
	ldr	w1, [x27, 40]
	bl	printf
	ldr	x0, [x29, 152]
	ldr	x0, [x0, #:lo12:.LANCHOR107]
	ldr	w0, [x0, x28]
	cmn	w0, #1
	beq	.L2348
	mov	x0, x27
	bl	buf_free
	b	.L2387
.L2344:
	cmp	w1, 2
	bne	.L2346
	ldr	w1, [x29, 184]
	add	w0, w0, w1
	add	w0, w0, w25
	orr	w0, w0, 33554432
	b	.L2385
.L2346:
	add	w0, w26, w0
	b	.L2385
.L2348:
	add	w22, w22, 1
	add	w25, w25, 1
	add	x28, x28, 4
.L2351:
	ldr	w0, [x29, 180]
	cmp	w0, w25
	bcs	.L2349
	add	x19, x19, 1
.L2353:
	ldr	x0, [x29, 168]
	ldrb	w0, [x0, 9]
	cmp	w0, w19
	ble	.L2350
	add	x0, x20, x19, lsl 1
	str	x0, [x29, 136]
	ldr	x0, [x29, 160]
	sbfiz	x28, x22, 2, 32
	mov	w25, 1
	add	x0, x0, :lo12:.LANCHOR64
	str	x0, [x29, 112]
	b	.L2351
.L2350:
	add	w26, w26, 1
	b	.L2343
.L2352:
	mov	x0, x27
	bl	buf_free
	ldr	x3, [x29, 120]
	adrp	x24, .LANCHOR56
	ldr	x0, [x29, 168]
	mov	w22, 0
	ldrh	w2, [x20, 80]
	mov	w23, 0
	ldr	x1, [x24, #:lo12:.LANCHOR56]
	mov	w27, 0
	ldrh	w3, [x3, #:lo12:.LANCHOR68]
	ldrb	w0, [x0, 9]
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	adrp	x0, .LANCHOR71
	add	x0, x0, :lo12:.LANCHOR71
	str	x0, [x29, 96]
.L2354:
	sub	w0, w23, #1
	str	w0, [x29, 120]
	cmp	w26, w23
	beq	.L2367
	str	xzr, [x29, 184]
	b	.L2368
.L2364:
	ldr	x1, [x29, 152]
	sbfiz	x0, x27, 2, 32
	ldr	x1, [x1, #:lo12:.LANCHOR107]
	ldr	w28, [x1, x0]
	cmn	w28, #1
	beq	.L2355
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR108]
	ldr	w0, [x1, x0]
	str	w0, [x29, 136]
	mov	w0, w28
	bl	lpa_hash_get_ppa
	str	w0, [x29, 204]
	cmn	w0, #1
	bne	.L2356
	mov	w2, 0
	add	x1, x29, 204
	mov	w0, w28
	bl	pm_log2phys
.L2356:
	ldr	x0, [x29, 112]
	ldr	x1, [x29, 128]
	ldrh	w0, [x0, 96]
	ldrh	w1, [x1, #:lo12:.LANCHOR75]
	mul	w0, w0, w1
	ldr	x1, [x29, 160]
	ldrb	w1, [x1, #:lo12:.LANCHOR64]
	cmp	w1, 3
	bne	.L2357
	add	w0, w23, w0
	orr	w0, w0, w25, lsl 24
.L2386:
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
	bne	.L2360
	ldr	w2, [x29, 200]
	mov	w1, w28
	str	w4, [x29, 136]
	adrp	x0, .LC137
	add	x0, x0, :lo12:.LC137
	bl	pm_ppa_update_check
	ldr	w4, [x29, 136]
	cbz	w0, .L2361
.L2381:
	b	.L2381
.L2357:
	cmp	w1, 2
	bne	.L2359
	ldr	w1, [x29, 120]
	add	w0, w0, w1
	add	w0, w0, w25
	orr	w0, w0, 33554432
	b	.L2386
.L2359:
	add	w0, w23, w0
	b	.L2386
.L2361:
	mov	w2, w4
	add	x1, x29, 200
	mov	w0, w28
	bl	pm_log2phys
	add	w22, w22, 1
	mov	w0, w19
	bl	ftl_vpn_decrement
.L2363:
	adrp	x0, .LANCHOR59
	add	w27, w27, 1
	ldr	x0, [x0, #:lo12:.LANCHOR59]
	add	x0, x0, x19, lsl 2
	ldrb	w0, [x0, 2]
	tst	w0, 224
	bne	.L2355
	ldr	x0, [x24, #:lo12:.LANCHOR56]
	lsl	x19, x19, 1
	ldrh	w1, [x0, x19]
	cbz	w1, .L2355
	strh	wzr, [x0, x19]
.L2355:
	add	w25, w25, 1
.L2366:
	ldr	w0, [x29, 180]
	cmp	w0, w25
	bcs	.L2364
	ldr	x0, [x29, 184]
	add	x0, x0, 1
	str	x0, [x29, 184]
.L2368:
	ldr	x0, [x29, 168]
	ldr	w1, [x29, 184]
	ldrb	w0, [x0, 9]
	cmp	w0, w1
	ble	.L2365
	ldr	x0, [x29, 184]
	mov	w25, 1
	add	x0, x20, x0, lsl 1
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR70
	add	x0, x0, :lo12:.LANCHOR70
	str	x0, [x29, 104]
	b	.L2366
.L2360:
	ldr	w1, [x29, 200]
	cmp	w0, w1
	cinc	w22, w22, eq
	b	.L2363
.L2365:
	add	w23, w23, 1
	b	.L2354
.L2367:
	ldrh	w1, [x20, 80]
	ldr	x0, [x24, #:lo12:.LANCHOR56]
	strh	w22, [x0, x1, lsl 1]
	b	.L2340
.L2335:
	ldrh	w0, [x0, 130]
	cmp	w0, w1
	beq	.L2334
	adrp	x19, .LANCHOR46
	ldr	x1, [x19, #:lo12:.LANCHOR46]
	ldrh	w1, [x1, 126]
	cmp	w1, w0
	bne	.L2371
	bl	pm_flush
	ldr	x0, [x21, #:lo12:.LANCHOR60]
	ldrh	w0, [x0, 130]
	bl	ftl_free_sblk
	ldr	x0, [x19, #:lo12:.LANCHOR46]
	mov	w1, -1
	strh	w1, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
.L2371:
	ldr	x0, [x21, #:lo12:.LANCHOR60]
	mov	w1, -1
	strh	w1, [x0, 130]
	b	.L2334
	.size	gc_recovery, .-gc_recovery
	.section	.text.ftl_init,"ax",@progbits
	.align	2
	.global	ftl_init
	.type	ftl_init, %function
ftl_init:
	stp	x29, x30, [sp, -64]!
	adrp	x1, .LANCHOR42
	mov	w0, -1
	add	x29, sp, 0
	strb	w0, [x1, #:lo12:.LANCHOR42]
	adrp	x1, .LANCHOR43
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR79
	strb	wzr, [x1, #:lo12:.LANCHOR43]
	adrp	x1, .LANCHOR127
	stp	x21, x22, [sp, 32]
	adrp	x19, .LANCHOR69
	strb	w0, [x1, #:lo12:.LANCHOR127]
	adrp	x0, .LANCHOR89
	mov	w1, -1
	stp	x23, x24, [sp, 48]
	strb	wzr, [x0, #:lo12:.LANCHOR89]
	adrp	x0, .LANCHOR49
	adrp	x22, .LANCHOR54
	adrp	x21, .LANCHOR149
	str	w1, [x0, #:lo12:.LANCHOR49]
	adrp	x1, .LC139
	adrp	x0, .LC32
	add	x1, x1, :lo12:.LC139
	add	x0, x0, :lo12:.LC32
	bl	printf
	adrp	x3, .LANCHOR19
	add	x3, x3, :lo12:.LANCHOR19
	adrp	x0, .LANCHOR64
	adrp	x1, .LANCHOR45
	adrp	x2, .LANCHOR68
	adrp	x5, .LANCHOR70
	ldrb	w7, [x3, 12]
	strb	w7, [x0, #:lo12:.LANCHOR64]
	ldrb	w0, [x3, 9]
	strb	w0, [x1, #:lo12:.LANCHOR45]
	ldrh	w1, [x3, 10]
	strh	w1, [x2, #:lo12:.LANCHOR68]
	adrp	x2, .LANCHOR8
	ubfiz	w8, w0, 9, 7
	strh	w8, [x21, #:lo12:.LANCHOR149]
	ldrb	w4, [x2, #:lo12:.LANCHOR8]
	adrp	x2, .LANCHOR76
	sdiv	w7, w1, w7
	strb	w4, [x2, #:lo12:.LANCHOR76]
	ldrb	w2, [x3, 13]
	strb	w2, [x5, #:lo12:.LANCHOR70]
	ldrh	w5, [x3, 14]
	adrp	x3, .LANCHOR13
	strh	w7, [x20, #:lo12:.LANCHOR79]
	mul	w4, w4, w2
	ldrh	w6, [x3, #:lo12:.LANCHOR13]
	adrp	x3, .LANCHOR75
	strh	w5, [x22, #:lo12:.LANCHOR54]
	and	w2, w4, 255
	mov	w4, 1
	strh	w6, [x3, #:lo12:.LANCHOR75]
	mov	w3, 0
	strb	w2, [x19, #:lo12:.LANCHOR69]
.L2389:
	cmp	w6, w4
	bcs	.L2390
	mul	w6, w0, w1
	adrp	x4, .LANCHOR71
	mov	w1, 57344
	sub	w3, w3, #1
	movk	w1, 0x1c, lsl 16
	strh	w3, [x4, #:lo12:.LANCHOR71]
	adrp	x24, .LANCHOR137
	adrp	x23, .LANCHOR60
	mul	w4, w6, w5
	mul	w1, w2, w1
	lsr	w3, w4, 21
	mul	w4, w4, w2
	mul	w1, w1, w3
	adrp	x3, .LANCHOR52
	str	w1, [x3, #:lo12:.LANCHOR52]
	add	w1, w1, 24576
	adrp	x3, .LANCHOR161
	udiv	w0, w1, w0
	str	w4, [x3, #:lo12:.LANCHOR161]
	adrp	x3, .LANCHOR162
	str	w1, [x3, #:lo12:.LANCHOR162]
	adrp	x3, .LANCHOR47
	str	w0, [x3, #:lo12:.LANCHOR47]
	sub	w3, w8, #1
	add	w0, w3, w0, lsl 2
	mul	w3, w7, w2
	mul	w2, w6, w2
	udiv	w0, w0, w8
	udiv	w1, w1, w2
	strh	w0, [x24, #:lo12:.LANCHOR137]
	ubfiz	w0, w0, 4, 16
	add	w1, w1, 2
	sdiv	w0, w0, w3
	adrp	x3, .LANCHOR101
	strh	w0, [x3, #:lo12:.LANCHOR101]
	adrp	x0, .LANCHOR163
	strh	w1, [x0, #:lo12:.LANCHOR163]
	add	w0, w5, w5, lsl 1
	adrp	x1, .LANCHOR164
	asr	w0, w0, 2
	strh	w0, [x1, #:lo12:.LANCHOR164]
	lsr	w0, w5, 4
	adrp	x1, .LANCHOR165
	strh	w0, [x1, #:lo12:.LANCHOR165]
	bl	buf_init
	ldrb	w1, [x19, #:lo12:.LANCHOR69]
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	mul	w0, w0, w1
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR83
	adrp	x2, ftl_ext_info_data_buffer
	add	x2, x2, :lo12:ftl_ext_info_data_buffer
	str	x0, [x1, #:lo12:.LANCHOR83]
	adrp	x0, .LANCHOR82
	ldrh	w1, [x20, #:lo12:.LANCHOR79]
	str	x2, [x0, #:lo12:.LANCHOR82]
	ldrb	w0, [x19, #:lo12:.LANCHOR69]
	mul	w1, w1, w0
	lsl	w0, w1, 1
	adrp	x1, .LANCHOR56
	add	x3, x2, x0, sxtw 2
	str	x3, [x1, #:lo12:.LANCHOR56]
	ldrh	w1, [x22, #:lo12:.LANCHOR54]
	add	w1, w0, w1, lsr 1
	adrp	x0, .LC140
	add	x1, x2, x1, sxtw 2
	add	x0, x0, :lo12:.LC140
	str	x1, [x23, #:lo12:.LANCHOR60]
	bl	printf
	ldrh	w0, [x20, #:lo12:.LANCHOR79]
	ldrb	w19, [x19, #:lo12:.LANCHOR69]
	ldrh	w1, [x22, #:lo12:.LANCHOR54]
	ldrh	w20, [x24, #:lo12:.LANCHOR137]
	ldrh	w3, [x21, #:lo12:.LANCHOR149]
	mul	w19, w0, w19
	adrp	x0, .LC141
	add	x0, x0, :lo12:.LC141
	add	w19, w1, w19, lsl 2
	lsl	w1, w1, 2
	add	w20, w1, w20, lsl 2
	lsl	w19, w19, 1
	add	w19, w19, 600
	add	w20, w20, 704
	mov	w2, w20
	mov	w1, w19
	bl	printf
	ldrh	w0, [x21, #:lo12:.LANCHOR149]
	cmp	w19, w0
	bhi	.L2391
	cmp	w20, w0
	bls	.L2392
.L2391:
.L2399:
	b	.L2399
.L2390:
	add	w3, w3, 1
	lsl	w4, w4, 1
	and	w3, w3, 65535
	b	.L2389
.L2392:
	bl	sblk_init
	bl	ftl_info_blk_init
	cmn	w0, #1
	beq	.L2388
	bl	ftl_ext_info_init
	adrp	x19, .LANCHOR46
	mov	w0, 1
	bl	pm_init
	bl	lpa_rebuild_hash
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	mov	x1, 0
	add	x0, x0, 16
	bl	ftl_open_sblk_recovery
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	add	x1, x0, 16
	add	x0, x0, 48
	bl	ftl_open_sblk_recovery
	ldr	x1, [x19, #:lo12:.LANCHOR46]
	ldr	w0, [x1, 8]
	add	w0, w0, 16
	str	w0, [x1, 8]
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	add	x0, x0, 16
	bl	ftl_info_data_recovery
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	add	x0, x0, 48
	bl	ftl_info_data_recovery
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	add	x0, x0, 80
	bl	ftl_info_data_recovery
	bl	gc_recovery
	bl	ftl_info_check
	bl	pm_flush
	mov	w0, 1
	bl	ftl_total_vpn_update
	adrp	x0, .LANCHOR133
	ldrb	w0, [x0, #:lo12:.LANCHOR133]
	cbz	w0, .L2394
	ldr	x1, [x19, #:lo12:.LANCHOR46]
	ldr	w0, [x1, 68]
	add	w0, w0, 1
	str	w0, [x1, 68]
.L2394:
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	bl	print_ftl_debug_info
	mov	w0, 0
.L2388:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
	.size	ftl_init, .-ftl_init
	.section	.text.rk_ftl_init,"ax",@progbits
	.align	2
	.global	rk_ftl_init
	.type	rk_ftl_init, %function
rk_ftl_init:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	bl	nand_flash_init
	cbnz	w0, .L2403
	bl	ftl_init
.L2403:
	mov	w19, w0
	mov	w1, w0
	adrp	x0, .LC142
	add	x0, x0, :lo12:.LC142
	bl	printf
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	rk_ftl_init, .-rk_ftl_init
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
	adrp	x0, .LANCHOR79
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR82
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldrh	w23, [x0, #:lo12:.LANCHOR79]
	ldrb	w0, [x22, 9]
	ldrh	w19, [x22, 12]
	str	x24, [x29, 104]
	mul	w23, w23, w0
	ldr	x0, [x24, #:lo12:.LANCHOR82]
	add	x19, x0, x19, lsl 2
	add	x0, x19, x23, sxtw 2
	ldr	w0, [x0, -4]
	cmn	w0, #1
	bne	.L2406
	adrp	x27, .LANCHOR45
	mov	x28, 0
	add	x0, x27, :lo12:.LANCHOR45
	mov	w21, 0
	str	x0, [x29, 96]
.L2407:
	cmp	w28, w23
	blt	.L2415
	adrp	x0, .LANCHOR22
	adrp	x19, .LANCHOR56
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 12, .L2416
	ldrh	w1, [x22]
	ldr	x2, [x19, #:lo12:.LANCHOR56]
	ubfiz	x0, x1, 1, 16
	ldrh	w3, [x2, x0]
	adrp	x0, .LC146
	mov	w2, w21
	add	x0, x0, :lo12:.LC146
	bl	printf
.L2416:
	ldrh	w1, [x22]
	ldr	x0, [x19, #:lo12:.LANCHOR56]
	ldp	x23, x24, [sp, 48]
	ldp	x19, x20, [sp, 16]
	strh	w21, [x0, x1, lsl 1]
	ldp	x25, x26, [sp, 64]
	ldp	x21, x22, [sp, 32]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2406:
	adrp	x1, .LANCHOR166
	adrp	x0, .LC0
	mov	w2, 882
	add	x1, x1, :lo12:.LANCHOR166
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2408:
	b	.L2408
.L2415:
	ldr	w2, [x19, x28, lsl 2]
	cmn	w2, #1
	beq	.L2409
	ldrb	w20, [x27, #:lo12:.LANCHOR45]
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	lsl	w20, w20, 7
	udiv	w20, w2, w20
	and	w20, w20, 65535
	tbz	x0, 12, .L2410
	adrp	x0, .LC143
	mov	w3, w28
	mov	w1, w20
	add	x0, x0, :lo12:.LC143
	bl	printf
.L2410:
	adrp	x25, .LANCHOR75
	adrp	x26, .LC144
	mov	x24, x28
	add	x25, x25, :lo12:.LANCHOR75
	add	x26, x26, :lo12:.LC144
.L2414:
	ldr	w1, [x19, x24, lsl 2]
	cmn	w1, #1
	beq	.L2411
	ldr	x0, [x29, 96]
	ldrb	w2, [x0]
	lsl	w2, w2, 7
	udiv	w1, w1, w2
	cmp	w20, w1, uxth
	bne	.L2411
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
	cbz	w0, .L2412
	ldr	x0, [x29, 104]
	mov	w3, w23
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR82]
	adrp	x0, .LC145
	add	x0, x0, :lo12:.LC145
	bl	rknand_print_hex
.L2413:
	b	.L2413
.L2412:
	ldr	w0, [x19, x24, lsl 2]
	add	w21, w21, 1
	mov	w2, 1
	add	x1, x29, 124
	and	w21, w21, 65535
	bl	pm_log2phys
	mov	w0, -1
	str	w0, [x19, x24, lsl 2]
.L2411:
	add	x24, x24, 1
	cmp	w23, w24
	bgt	.L2414
.L2409:
	add	x28, x28, 1
	b	.L2407
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
	adrp	x0, .LANCHOR60
	ldr	x0, [x0, #:lo12:.LANCHOR60]
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
	adrp	x0, .LANCHOR36
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	add	x25, x0, :lo12:.LANCHOR36
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
.L2436:
	adrp	x3, .LANCHOR43
	ldrb	w1, [x3, #:lo12:.LANCHOR43]
	cbz	w1, .L2438
	adrp	x4, .LANCHOR42
	adrp	x2, .LANCHOR36
	add	x2, x2, :lo12:.LANCHOR36
	sub	w1, w1, #1
	ldrb	w0, [x4, #:lo12:.LANCHOR42]
	strb	w1, [x3, #:lo12:.LANCHOR43]
	adrp	x1, .LANCHOR47
	ubfiz	x27, x0, 6, 8
	ldr	w1, [x1, #:lo12:.LANCHOR47]
	add	x5, x2, x27
	stp	x0, x5, [x29, 112]
	lsl	x5, x0, 6
	add	x0, x2, x5
	ldrb	w5, [x2, x5]
	ldr	w22, [x0, 36]
	strb	w5, [x4, #:lo12:.LANCHOR42]
	cmp	w22, w1
	bcc	.L2440
	ldr	x0, [x29, 120]
	bl	buf_free
	mov	w0, -1
.L2435:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L2440:
	adrp	x26, .LANCHOR89
	ldrb	w21, [x0, 57]
	ldrb	w20, [x0, 56]
	ldr	x24, [x0, 8]
	ldr	x28, [x0, 24]
	ldrb	w0, [x26, #:lo12:.LANCHOR89]
	cbz	w0, .L2442
	adrp	x0, .LANCHOR127
	ldrb	w1, [x0, #:lo12:.LANCHOR127]
	add	x1, x2, x1, lsl 6
.L2443:
	ldrb	w0, [x1]
	cmp	w0, 255
	bne	.L2444
	ldr	w0, [x1, 36]
	cmp	w22, w0
	bne	.L2442
	ldr	x0, [x1, 8]
	ubfiz	x21, x21, 9, 8
	lsl	w2, w20, 9
	add	x1, x24, x21
	add	x0, x0, x21
	bl	ftl_memcpy
	ldr	x0, [x29, 120]
	bl	buf_free
	b	.L2436
.L2444:
	ubfiz	x1, x0, 6, 8
	add	x1, x25, x1
	b	.L2443
.L2442:
	mov	w0, w22
	bl	lpa_hash_get_ppa
	str	w0, [x29, 140]
	cmn	w0, #1
	bne	.L2446
	mov	w2, 0
	add	x1, x29, 140
	mov	w0, w22
	bl	pm_log2phys
.L2446:
	adrp	x19, .LANCHOR60
	add	x1, x25, 2
	mov	w0, 0
	ldr	x3, [x19, #:lo12:.LANCHOR60]
.L2449:
	ldr	w2, [x1, 34]
	cmp	w22, w2
	bne	.L2447
	ldrb	w2, [x1]
	tbz	x2, 3, .L2447
	ubfiz	x0, x0, 6, 32
	and	w2, w2, -9
	add	x0, x25, x0
	strb	w2, [x0, 2]
	ldr	x23, [x0, 8]
	ldr	w0, [x0, 40]
	str	w0, [x29, 140]
.L2448:
	adrp	x0, .LANCHOR45
	str	x0, [x29, 104]
	ldrb	w1, [x0, #:lo12:.LANCHOR45]
	cmp	w20, w1
	bcc	.L2450
	add	x19, x3, 16
.L2495:
	mov	w23, 0
.L2451:
	ldrh	w0, [x19, 6]
	cbnz	w0, .L2466
	bl	ftl_flush
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L2466:
	mov	x0, x19
	bl	ftl_get_new_free_page
	ldr	x1, [x29, 112]
	adrp	x20, .LANCHOR127
	lsl	x2, x1, 6
	add	x1, x25, x2
	ldr	w3, [x1, 32]
	stp	w3, w22, [x28]
	str	w23, [x28, 12]
	ldr	w3, [x29, 140]
	str	w3, [x28, 8]
	stp	w0, w3, [x1, 40]
	mov	w0, -1
	strb	w0, [x25, x2]
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
	add	x0, x20, :lo12:.LANCHOR127
	bl	buf_add_tail
	ldrb	w2, [x26, #:lo12:.LANCHOR89]
	adrp	x0, .LANCHOR168
	add	w2, w2, 1
	str	wzr, [x0, #:lo12:.LANCHOR168]
	and	w2, w2, 255
	strb	w2, [x26, #:lo12:.LANCHOR89]
	cmp	w2, 2
	ldrh	w0, [x19, 6]
	bhi	.L2467
	cmp	w0, 1
	bne	.L2439
.L2467:
	ldrb	w1, [x19, 5]
	cmp	w1, 0
	mov	w1, 0
	cset	w4, ne
	cmp	w0, 1
	ldrb	w0, [x20, #:lo12:.LANCHOR127]
	csinc	w4, w2, w4, eq
	mov	w3, w0
.L2471:
	cmp	w1, w4
	bne	.L2472
	and	w1, w1, 255
	ubfiz	x0, x0, 6, 8
	sub	w2, w2, w1
	strb	w3, [x20, #:lo12:.LANCHOR127]
	strb	w2, [x26, #:lo12:.LANCHOR89]
	add	x0, x25, x0
	bl	sblk_prog_page
	ldrh	w0, [x19, 6]
	cmp	w0, 1
	bne	.L2439
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	mov	x0, x19
	bl	ftl_write_last_log_page
	mov	x0, x19
	bl	ftl_alloc_new_data_sblk
.L2439:
	adrp	x0, .LANCHOR43
	ldrb	w0, [x0, #:lo12:.LANCHOR43]
	cbnz	w0, .L2436
.L2438:
	bl	ftl_write_completed
	mov	w0, 0
	b	.L2435
.L2447:
	add	w0, w0, 1
	add	x1, x1, 64
	cmp	w0, 32
	bne	.L2449
	mov	x23, 0
	b	.L2448
.L2450:
	cbz	x23, .L2452
	cbz	w21, .L2453
	lsl	w2, w21, 9
	mov	x1, x23
	mov	x0, x24
	bl	ftl_memcpy
.L2453:
	ldr	x0, [x29, 104]
	add	w20, w21, w20
	ldr	x19, [x19, #:lo12:.LANCHOR60]
	ldrb	w2, [x0, #:lo12:.LANCHOR45]
	cmp	w20, w2
	bcc	.L2454
	add	x19, x19, 16
	b	.L2495
.L2454:
	ubfiz	x0, x20, 9, 9
	sub	w2, w2, w20
	add	x1, x23, x0
	add	x19, x19, 48
	lsl	w2, w2, 9
	add	x0, x24, x0
	bl	ftl_memcpy
	b	.L2495
.L2452:
	ldr	w0, [x29, 140]
	cmn	w0, #1
	beq	.L2455
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
	bne	.L2456
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L2457
.L2456:
	ldrb	w1, [x27, 1]
	mov	w3, w22
	ldr	w4, [x27, 52]
	adrp	x0, .LC147
	ldr	w2, [x29, 140]
	add	x0, x0, :lo12:.LC147
	bl	printf
	ldr	x1, [x27, 24]
	mov	w3, 4
	adrp	x0, .LC96
	mov	w2, w3
	add	x0, x0, :lo12:.LC96
	bl	rknand_print_hex
	adrp	x0, .LANCHOR71
	ldr	w1, [x29, 140]
	ldrh	w3, [x0, #:lo12:.LANCHOR71]
	mov	w0, 21
	sub	w2, w0, w3
	mov	w0, 1
	lsr	w1, w1, w3
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR70
	ldrb	w2, [x1, #:lo12:.LANCHOR70]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
.L2457:
	ldr	x0, [x27, 24]
	ldr	w0, [x0, 4]
	cmp	w22, w0
	bne	.L2458
	ldr	w0, [x27, 52]
	cmn	w0, #1
	bne	.L2459
.L2458:
	adrp	x1, .LANCHOR167
	adrp	x0, .LC0
	mov	w2, 445
	add	x1, x1, :lo12:.LANCHOR167
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2460:
	b	.L2460
.L2459:
	cbz	w21, .L2461
	ldr	w0, [x29, 140]
	lsl	w2, w21, 9
	cmn	w0, #1
	beq	.L2462
	ldr	x1, [x27, 8]
	mov	x0, x24
	bl	ftl_memcpy
.L2461:
	ldr	x1, [x29, 104]
	add	w20, w21, w20
	ldr	x0, [x19, #:lo12:.LANCHOR60]
	add	x19, x0, 48
	ldrb	w2, [x1, #:lo12:.LANCHOR45]
	cmp	w20, w2
	bcc	.L2463
	add	x19, x0, 16
.L2464:
	cbz	x27, .L2451
	ldrb	w0, [x27, 2]
	mov	x1, x27
	and	w0, w0, -9
	strb	w0, [x27, 2]
	adrp	x0, .LANCHOR51
	add	x0, x0, :lo12:.LANCHOR51
	bl	buf_remove_buf
	mov	x0, x27
	bl	buf_free
	b	.L2451
.L2463:
	ldr	w0, [x29, 140]
	sub	w2, w2, w20
	lsl	w2, w2, 9
	ubfiz	x20, x20, 7, 9
	cmn	w0, #1
	beq	.L2465
	ldr	x1, [x27, 8]
	lsl	x20, x20, 2
	add	x0, x24, x20
	add	x1, x1, x20
	bl	ftl_memcpy
	b	.L2464
.L2465:
	mov	w1, 0
	add	x0, x24, x20, lsl 2
	bl	ftl_memset
	b	.L2464
.L2472:
	ubfiz	x3, x3, 6, 8
	add	w1, w1, 1
	ldrb	w3, [x25, x3]
	b	.L2471
.L2473:
	lsl	w2, w21, 9
	mov	x27, 0
	mov	w23, 0
.L2462:
	mov	w1, 0
	mov	x0, x24
	bl	ftl_memset
	b	.L2461
.L2455:
	cbnz	w21, .L2473
	mov	w23, 0
	mov	x27, 0
	b	.L2461
	.size	ftl_write_commit, .-ftl_write_commit
	.section	.text.ftl_discard,"ax",@progbits
	.align	2
	.global	ftl_discard
	.type	ftl_discard, %function
ftl_discard:
	stp	x29, x30, [sp, -112]!
	ands	w0, w0, 255
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w2
	stp	x25, x26, [sp, 64]
	mov	w26, w3
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	bne	.L2497
	adrp	x2, .LANCHOR52
	mov	w21, 24576
	ldr	w2, [x2, #:lo12:.LANCHOR52]
.L2498:
	add	w3, w1, w20
	cmp	w2, w3
	bcc	.L2519
	add	w21, w21, w1
	adrp	x1, .LANCHOR22
	ldr	w1, [x1, #:lo12:.LANCHOR22]
	tbz	x1, 12, .L2500
	mov	w1, w0
	mov	w4, w26
	adrp	x0, .LC148
	mov	w3, w20
	mov	w2, w21
	add	x0, x0, :lo12:.LC148
	bl	printf
.L2500:
	adrp	x22, .LANCHOR46
	adrp	x23, .LANCHOR45
	cmp	w26, 1
	ldr	x0, [x22, #:lo12:.LANCHOR46]
	cset	w25, ls
	ldr	w24, [x0, 8]
	add	w1, w24, 1
	str	w1, [x0, 8]
	ldrb	w0, [x23, #:lo12:.LANCHOR45]
	udiv	w19, w21, w0
	msub	w21, w19, w0, w21
	cbz	w21, .L2501
	sub	w0, w0, w21
	cmp	w0, w20
	csel	w28, w0, w20, ls
	cmp	w26, 1
	and	w27, w28, 65535
	bhi	.L2503
	mov	w0, w19
	bl	lpa_hash_get_ppa
	str	w0, [x29, 104]
	cmn	w0, #1
	bne	.L2504
	mov	w2, 0
	add	x1, x29, 104
	mov	w0, w19
	bl	pm_log2phys
.L2504:
	ldr	w0, [x29, 104]
	cmn	w0, #1
	beq	.L2503
	mov	w0, 0
	bl	buf_alloc
	mov	x26, x0
	cbz	x0, .L2503
	strb	w21, [x0, 57]
	lsl	w2, w27, 9
	strb	w28, [x0, 56]
	mov	w1, 0
	ldr	x0, [x0, 8]
	ubfiz	x21, x21, 9, 25
	stp	w24, w19, [x26, 32]
	add	x0, x0, x21
	bl	ftl_memset
	mov	x0, x26
	bl	ftl_write_buf
	bl	ftl_write_commit
	ldr	x1, [x22, #:lo12:.LANCHOR46]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L2503:
	add	w19, w19, 1
	sub	w20, w20, w27
.L2501:
	cbz	w20, .L2506
	bl	ftl_flush
.L2506:
	adrp	x21, .LANCHOR71
	add	x26, x23, :lo12:.LANCHOR45
	add	x21, x21, :lo12:.LANCHOR71
	mov	w0, -1
	str	w0, [x29, 108]
.L2507:
	ldrb	w0, [x26]
	cmp	w20, w0
	bcs	.L2512
	cmp	w20, 0
	cset	w0, ne
	tst	w25, w0
	bne	.L2513
.L2546:
	mov	w0, 0
.L2496:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2497:
	cmp	w0, 3
	bhi	.L2519
	lsl	w21, w0, 13
	mov	w2, 8192
	b	.L2498
.L2512:
	mov	w0, w19
	bl	lpa_hash_get_ppa
	str	w0, [x29, 104]
	cmn	w0, #1
	mov	w2, 0
	add	x1, x29, 104
	mov	w0, w19
	beq	.L2508
	bl	pm_log2phys
	ldr	w0, [x29, 104]
	cmn	w0, #1
	beq	.L2510
	mov	w2, 1
	add	x1, x29, 108
	mov	w0, w19
	bl	pm_log2phys
.L2545:
	ldr	x1, [x22, #:lo12:.LANCHOR46]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
.L2510:
	ldrb	w0, [x26]
	add	w19, w19, 1
	sub	w20, w20, w0
	b	.L2507
.L2508:
	bl	pm_log2phys
	ldr	w0, [x29, 104]
	cmn	w0, #1
	beq	.L2510
	add	x1, x29, 108
	mov	w2, 1
	mov	w0, w19
	bl	pm_log2phys
	ldrh	w3, [x21]
	mov	w0, 21
	ldr	w1, [x29, 104]
	sub	w2, w0, w3
	mov	w0, 1
	lsr	w1, w1, w3
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR70
	ldrb	w1, [x1, #:lo12:.LANCHOR70]
	udiv	w0, w0, w1
	bl	ftl_vpn_decrement
	b	.L2545
.L2513:
	mov	w0, w19
	bl	lpa_hash_get_ppa
	str	w0, [x29, 104]
	cmn	w0, #1
	bne	.L2514
	mov	w2, 0
	add	x1, x29, 104
	mov	w0, w19
	bl	pm_log2phys
.L2514:
	ldr	w0, [x29, 104]
	cmn	w0, #1
	beq	.L2546
	mov	w0, 0
	bl	buf_alloc
	mov	x21, x0
	cbz	x0, .L2546
	strb	wzr, [x0, 57]
	strb	w20, [x0, 56]
	stp	w24, w19, [x21, 32]
	ldrb	w0, [x23, #:lo12:.LANCHOR45]
	cmp	w20, w0
	bcc	.L2516
	adrp	x1, .LANCHOR169
	adrp	x0, .LC0
	mov	w2, 1048
	add	x1, x1, :lo12:.LANCHOR169
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2517:
	b	.L2517
.L2516:
	ldr	x0, [x21, 8]
	lsl	w2, w20, 9
	mov	w1, 0
	bl	ftl_memset
	mov	x0, x21
	bl	ftl_write_buf
	bl	ftl_write_commit
	ldr	x1, [x22, #:lo12:.LANCHOR46]
	ldr	w0, [x1, 76]
	add	w0, w0, 1
	str	w0, [x1, 76]
	b	.L2546
.L2519:
	mov	w0, -1
	b	.L2496
	.size	ftl_discard, .-ftl_discard
	.section	.text.FtlDiscard,"ax",@progbits
	.align	2
	.global	FtlDiscard
	.type	FtlDiscard, %function
FtlDiscard:
	mov	w2, w1
	mov	w3, 0
	mov	w1, w0
	mov	w0, 0
	b	ftl_discard
	.size	FtlDiscard, .-FtlDiscard
	.section	.text.gc_do_copy_back,"ax",@progbits
	.align	2
	.global	gc_do_copy_back
	.type	gc_do_copy_back, %function
gc_do_copy_back:
	sub	sp, sp, #224
	adrp	x0, .LANCHOR67
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	ldrb	w0, [x0, #:lo12:.LANCHOR67]
	stp	x19, x20, [sp, 32]
	stp	x21, x22, [sp, 48]
	stp	x23, x24, [sp, 64]
	stp	x25, x26, [sp, 80]
	stp	x27, x28, [sp, 96]
	cbnz	w0, .L2549
	bl	buf_alloc
	mov	x19, x0
	cbz	x0, .L2548
	adrp	x20, .LANCHOR58
	add	x3, x20, :lo12:.LANCHOR58
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
	bne	.L2551
	adrp	x0, .LANCHOR71
	ldrh	w1, [x0, #:lo12:.LANCHOR71]
	mov	w0, 21
	sub	w2, w0, w1
	mov	w0, 1
	lsr	w1, w22, w1
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR70
	ldrb	w2, [x1, #:lo12:.LANCHOR70]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
.L2551:
	ldr	w0, [x19, 52]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L2552
	adrp	x1, .LANCHOR170
	adrp	x0, .LC0
	mov	w2, 556
	add	x1, x1, :lo12:.LANCHOR170
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2553:
	b	.L2553
.L2552:
	ldr	x0, [x19, 24]
	ldr	w21, [x0, 4]
	mov	w0, w21
	bl	lpa_hash_get_ppa
	str	w0, [x29, 160]
	cmn	w0, #1
	bne	.L2554
	mov	w2, 0
	add	x1, x29, 160
	mov	w0, w21
	bl	pm_log2phys
.L2554:
	ldr	w23, [x29, 160]
	cmp	w22, w23
	bne	.L2555
	adrp	x0, .LANCHOR36
	add	x0, x0, :lo12:.LANCHOR36
	add	x1, x0, 2
	add	x0, x0, 2050
.L2558:
	ldr	w2, [x1, 34]
	cmp	w21, w2
	bne	.L2556
	ldrb	w2, [x1]
	tbz	x2, 1, .L2556
	mov	x0, x19
	bl	buf_free
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L2548
	add	x20, x20, :lo12:.LANCHOR58
	adrp	x0, .LC149
	mov	w2, w22
	mov	w1, w21
	add	x0, x0, :lo12:.LC149
	ldrh	w3, [x20, 26]
	bl	printf
.L2548:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 224
	ret
.L2556:
	add	x1, x1, 64
	cmp	x0, x1
	bne	.L2558
	adrp	x0, .LANCHOR45
	mov	w1, 10
	strb	wzr, [x19, 57]
	ldrb	w0, [x0, #:lo12:.LANCHOR45]
	strb	w0, [x19, 56]
	ldrb	w0, [x19, 2]
	str	w21, [x19, 36]
	orr	w0, w0, w1
	strb	w0, [x19, 2]
	ldr	x0, [x19, 24]
	ldr	w0, [x0]
	str	w0, [x19, 32]
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L2559
	mov	w0, w21
	bl	lpa_hash_get_ppa
	add	x1, x20, :lo12:.LANCHOR58
	mov	w3, w0
	mov	w4, w22
	adrp	x0, .LC150
	mov	w2, w23
	add	x0, x0, :lo12:.LC150
	ldrh	w5, [x1, 26]
	mov	w1, w21
	bl	printf
.L2559:
	mov	x0, x19
	bl	ftl_gc_write_buf
	bl	ftl_write_commit
	add	x20, x20, :lo12:.LANCHOR58
	adrp	x0, .LANCHOR46
	ldr	x1, [x0, #:lo12:.LANCHOR46]
	ldr	w0, [x1, 60]
	add	w0, w0, 1
	str	w0, [x1, 60]
	ldrh	w0, [x20, 28]
	add	w0, w0, 1
	strh	w0, [x20, 28]
	b	.L2548
.L2555:
	adrp	x0, .LANCHOR22
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L2560
	add	x20, x20, :lo12:.LANCHOR58
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
.L2560:
	mov	x0, x19
	bl	buf_free
	b	.L2548
.L2549:
	adrp	x1, .LANCHOR60
	adrp	x0, .LANCHOR64
	stp	x0, x1, [x29, 128]
	adrp	x24, .LANCHOR58
	ldr	x22, [x1, #:lo12:.LANCHOR60]
	ldrb	w25, [x0, #:lo12:.LANCHOR64]
	add	x22, x22, 80
	cmp	w25, 3
	bne	.L2561
	adrp	x0, .LANCHOR66
	ldrb	w0, [x0, #:lo12:.LANCHOR66]
	cbz	w0, .L2562
	add	x0, x24, :lo12:.LANCHOR58
	ldrb	w19, [x22, 9]
	ldrh	w20, [x0, 314]
	add	w21, w19, w19, lsl 1
	sub	w19, w19, w19, lsl 2
	sdiv	w21, w20, w21
	madd	w19, w21, w19, w20
	and	w19, w19, 65535
.L2563:
	adrp	x1, .LANCHOR68
	ldrb	w0, [x22, 9]
	add	x4, x24, :lo12:.LANCHOR58
	mov	w2, 0
	ldrh	w3, [x1, #:lo12:.LANCHOR68]
	mul	w8, w25, w0
	ldrh	w10, [x4, 24]
	mul	w3, w3, w0
	adrp	x0, .LANCHOR108
	ldr	x7, [x0, #:lo12:.LANCHOR108]
	sub	w3, w3, #1
.L2566:
	cmp	w2, w8
	blt	.L2568
.L2596:
	mov	w23, 1
	b	.L2564
.L2562:
	add	x0, x24, :lo12:.LANCHOR58
	ldrb	w20, [x22, 9]
	ldrh	w1, [x0, 314]
	adrp	x0, .LANCHOR171
	add	x0, x0, :lo12:.LANCHOR171
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
	beq	.L2563
.L2564:
	adrp	x0, .LANCHOR22
	str	x0, [x29, 112]
	ldr	w1, [x0, #:lo12:.LANCHOR22]
	tbz	x1, 8, .L2569
	adrp	x0, .LANCHOR108
	ubfiz	x1, x20, 2, 16
	mov	w6, w20
	mov	w3, w19
	ldr	x2, [x0, #:lo12:.LANCHOR108]
	add	x0, x24, :lo12:.LANCHOR58
	ldrh	w4, [x0, 314]
	adrp	x0, .LC151
	ldr	w5, [x2, x1]
	add	x0, x0, :lo12:.LC151
	mov	w2, w23
	mov	w1, w21
	bl	printf
.L2569:
	adrp	x0, .LANCHOR36
	str	wzr, [x29, 152]
	add	x0, x0, :lo12:.LANCHOR36
	str	x0, [x29, 120]
.L2570:
	ldrb	w2, [x22, 9]
	ldr	w0, [x29, 152]
	ldrh	w26, [x29, 152]
	and	w0, w0, 65535
	str	w0, [x29, 156]
	mul	w1, w25, w2
	cmp	w0, w1
	blt	.L2583
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR64]
	cmp	w0, 3
	add	x0, x29, 160
	beq	.L2584
	sub	w3, w1, #1
	mov	w2, 0
.L2585:
	cmp	w2, w3
	blt	.L2591
	ldr	x0, [x0, w3, sxtw 3]
	mov	w2, -1
	strb	w2, [x0]
	ldr	x0, [x29, 160]
	bl	sblk_prog_page
	b	.L2590
.L2561:
	adrp	x0, .LANCHOR74
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbnz	w0, .L2565
	add	x0, x24, :lo12:.LANCHOR58
	ldrb	w19, [x22, 9]
	mov	w25, 1
	ldrh	w20, [x0, 314]
	sdiv	w21, w20, w19
	msub	w19, w21, w19, w20
	and	w19, w19, 65535
	b	.L2563
.L2565:
	add	x0, x24, :lo12:.LANCHOR58
	ldrb	w19, [x22, 9]
	mov	w25, 2
	ldrh	w20, [x0, 314]
	sdiv	w21, w20, w19
	msub	w19, w21, w19, w20
	and	w19, w19, 65535
	b	.L2563
.L2568:
	add	w5, w20, w2
	cmp	w5, w3
	beq	.L2596
	sbfiz	x5, x5, 2, 32
	ldr	w0, [x7, x5]
	cmn	w0, #1
	bne	.L2567
	ldrh	w6, [x4, 26]
	cmp	w6, w10
	bcs	.L2548
	mov	w0, w6
	bl	gc_get_src_ppa_from_index
	add	w6, w6, 1
	strh	w6, [x4, 26]
	str	w0, [x7, x5]
.L2567:
	add	w2, w2, 1
	and	w2, w2, 65535
	b	.L2566
.L2583:
	ldr	w0, [x29, 156]
	add	w0, w20, w0
	str	w0, [x29, 144]
	sxtw	x27, w0
	adrp	x0, .LANCHOR65
	ldr	x0, [x0, #:lo12:.LANCHOR65]
	ldrb	w0, [x0, x27]
	cmp	w0, 255
	bne	.L2571
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbnz	x0, .L2572
	bl	sblk_wait_write_queue_completed
	bl	ftl_write_completed
	bl	gc_write_completed
	bl	gc_free_temp_buf
	mov	w0, 0
	bl	buf_alloc
	mov	x28, x0
	cbz	x0, .L2548
.L2572:
	adrp	x0, .LANCHOR65
	ldrb	w1, [x28, 1]
	adrp	x5, .LANCHOR68
	adrp	x6, .LANCHOR108
	ldr	x0, [x0, #:lo12:.LANCHOR65]
	strb	w1, [x0, x27]
	add	x1, x24, :lo12:.LANCHOR58
	strb	w23, [x28, 61]
	ldrh	w7, [x5, #:lo12:.LANCHOR68]
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
	bne	.L2573
	adrp	x0, .LANCHOR107
	adrp	x4, .LANCHOR69
	stp	x6, x5, [x29, 96]
	ldr	x1, [x0, #:lo12:.LANCHOR107]
	mov	w0, -1
	str	x4, [x29, 144]
	str	w0, [x1, x27, lsl 2]
	ldr	x0, [x28, 8]
	ldrb	w2, [x4, #:lo12:.LANCHOR69]
	mul	w2, w2, w7
	lsl	w2, w2, 2
	bl	ftl_memcpy
	ldp	x6, x5, [x29, 96]
	ldr	x4, [x29, 144]
	ldr	x7, [x28, 8]
	ldrh	w0, [x5, #:lo12:.LANCHOR68]
	ldrb	w1, [x4, #:lo12:.LANCHOR69]
	mul	w0, w0, w1
	ldr	x1, [x6, #:lo12:.LANCHOR108]
	lsl	w2, w0, 2
	add	x0, x7, x0, sxtw 2
	bl	ftl_memcpy
	adrp	x0, .LANCHOR45
	mov	w1, 0
	ldrb	w2, [x0, #:lo12:.LANCHOR45]
	ldr	x0, [x28, 24]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x6, [x28, 24]
	mov	w0, 15555
	ldr	x5, [x29, 104]
	movk	w0, 0xf55f, lsl 16
	ldr	x4, [x29, 144]
	ldrh	w1, [x5, #:lo12:.LANCHOR68]
	str	w0, [x6]
	ldrb	w0, [x4, #:lo12:.LANCHOR69]
	mul	w1, w1, w0
	ldr	x0, [x28, 8]
	lsl	w1, w1, 2
	bl	js_hash
	str	w0, [x6, 4]
	ldr	x0, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR60]
	ldr	w0, [x0, 132]
	str	w0, [x6, 8]
.L2571:
	adrp	x0, .LANCHOR65
	ldr	w5, [x29, 156]
	add	x3, x29, 160
	ldr	x4, [x0, #:lo12:.LANCHOR65]
	adrp	x0, .LANCHOR36
	add	x2, x0, :lo12:.LANCHOR36
	ldrb	w1, [x4, x27]
	ubfiz	x0, x1, 6, 8
	add	x0, x2, x0
	add	x2, x2, x1, lsl 6
	str	x0, [x3, w5, sxtw 3]
	mov	w0, 1
	adrp	x5, .LANCHOR109
	strh	w0, [x2, 50]
	ldr	x0, [x29, 128]
	strb	w23, [x2, 61]
	ldrb	w0, [x0, #:lo12:.LANCHOR64]
	cmp	w0, 3
	bne	.L2578
	udiv	w0, w26, w0
	adrp	x6, .LANCHOR75
	ldrh	w6, [x6, #:lo12:.LANCHOR75]
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
	ldr	x2, [x5, #:lo12:.LANCHOR109]
	orr	w0, w3, w0, lsl 24
	str	w0, [x2, x6, lsl 2]
.L2579:
	ldr	x0, [x29, 112]
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L2582
	ldr	x0, [x29, 120]
	mov	w2, w23
	ldrb	w4, [x4, x27]
	add	x1, x0, x1, lsl 6
	add	x0, x24, :lo12:.LANCHOR58
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
.L2582:
	ldr	w0, [x29, 152]
	add	w0, w0, 1
	str	w0, [x29, 152]
	b	.L2570
.L2573:
	ldr	x0, [x6, #:lo12:.LANCHOR108]
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
	bne	.L2575
	adrp	x0, .LANCHOR71
	ldr	w1, [x28, 40]
	ldrh	w5, [x0, #:lo12:.LANCHOR71]
	mov	w0, 21
	sub	w2, w0, w5
	mov	w0, 1
	lsr	w1, w1, w5
	lsl	w0, w0, w2
	sub	w0, w0, #1
	and	w0, w0, w1
	adrp	x1, .LANCHOR70
	ldrb	w2, [x1, #:lo12:.LANCHOR70]
	mov	x1, 0
	udiv	w0, w0, w2
	bl	ftl_sblk_dump
	ldr	w0, [x28, 52]
	ldr	x4, [x29, 144]
	cmp	w0, 512
	ccmn	w0, #1, 4, ne
	bne	.L2575
	ldr	x0, [x28, 24]
	mov	w1, -1
	str	w1, [x0, 4]
	ldr	w0, [x28, 52]
	cmp	w0, 512
	ccmp	w0, w1, 4, ne
	bne	.L2575
	adrp	x1, .LANCHOR170
	adrp	x0, .LC0
	mov	w2, 671
	add	x1, x1, :lo12:.LANCHOR170
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2576:
	b	.L2576
.L2575:
	ldr	x0, [x28, 24]
	adrp	x1, .LANCHOR47
	ldr	w1, [x1, #:lo12:.LANCHOR47]
	ldr	w2, [x0, 4]
	cmp	w2, w1
	bcc	.L2577
	mov	w1, -1
	str	w1, [x0, 4]
.L2577:
	adrp	x1, .LANCHOR107
	ldr	w2, [x0, 4]
	ldr	x1, [x1, #:lo12:.LANCHOR107]
	str	w2, [x1, x4]
	ldr	w1, [x28, 40]
	str	w1, [x0, 8]
	b	.L2571
.L2578:
	cmp	w0, 2
	bne	.L2580
	adrp	x0, .LANCHOR74
	adrp	x3, .LANCHOR75
	ldrb	w0, [x0, #:lo12:.LANCHOR74]
	cbnz	w0, .L2581
	ldr	w0, [x29, 156]
	ldrh	w3, [x3, #:lo12:.LANCHOR75]
	add	w0, w19, w0
	add	x0, x22, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w3, w21
.L2639:
	orr	w0, w0, 33554432
	str	w0, [x2, 40]
.L2580:
	ldr	x0, [x29, 120]
	add	x0, x0, x1, lsl 6
	ldrh	w2, [x0, 48]
	ldr	w3, [x0, 40]
	ldr	x0, [x5, #:lo12:.LANCHOR109]
	str	w3, [x0, x2, lsl 2]
	b	.L2579
.L2581:
	add	w0, w19, w26, lsr 1
	ldrh	w3, [x3, #:lo12:.LANCHOR75]
	add	x0, x22, x0, sxtw 1
	ldrh	w0, [x0, 16]
	madd	w0, w0, w3, w21
	and	w3, w26, 1
	add	w0, w0, w3
	b	.L2639
.L2584:
	adrp	x1, .LANCHOR66
	ldrb	w3, [x1, #:lo12:.LANCHOR66]
	ldr	x1, [x29, 160]
	cbz	w3, .L2586
.L2589:
	strb	wzr, [x1, 60]
	b	.L2587
.L2586:
	cmp	w23, 1
	bne	.L2588
	mov	w3, 9
.L2638:
	strb	w3, [x1, 60]
.L2587:
	add	x1, x0, 24
	bl	sblk_xlc_prog_pages
.L2590:
	adrp	x1, .LANCHOR66
	ldrb	w3, [x22, 9]
	ldrb	w1, [x1, #:lo12:.LANCHOR66]
	and	w0, w3, 65535
	cbz	w1, .L2592
	add	w0, w0, w0, lsl 1
.L2593:
	adrp	x1, .LANCHOR46
	add	x24, x24, :lo12:.LANCHOR58
	ldr	x1, [x1, #:lo12:.LANCHOR46]
	ldr	w2, [x1, 52]
	add	w2, w2, w0
	str	w2, [x1, 52]
	ldrh	w1, [x24, 314]
	add	w0, w0, w1
	adrp	x1, .LANCHOR68
	and	w0, w0, 65535
	strh	w0, [x24, 314]
	ldrh	w1, [x1, #:lo12:.LANCHOR68]
	mul	w1, w1, w3
	cmp	w0, w1
	blt	.L2594
	ldr	x0, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR60]
	strh	wzr, [x0, 86]
.L2594:
	bl	gc_write_completed
	b	.L2548
.L2588:
	cmp	w23, 2
	bne	.L2589
	mov	w3, 13
	b	.L2638
.L2591:
	ldr	x4, [x0, w2, sxtw 3]
	add	w2, w2, 1
	ldr	x5, [x0, w2, sxtw 3]
	and	w2, w2, 65535
	ldrb	w5, [x5, 1]
	strb	w5, [x4]
	b	.L2585
.L2592:
	adrp	x1, .LANCHOR74
	ldrb	w2, [x1, #:lo12:.LANCHOR74]
	mov	w1, w0
	ubfiz	w0, w0, 1, 15
	cmp	w2, 0
	csel	w0, w0, w1, ne
	b	.L2593
	.size	gc_do_copy_back, .-gc_do_copy_back
	.section	.text.do_gc,"ax",@progbits
	.align	2
	.global	do_gc
	.type	do_gc, %function
do_gc:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR46
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR104
	ldr	x1, [x24, #:lo12:.LANCHOR46]
	adrp	x23, .LANCHOR60
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	ldrb	w3, [x20, #:lo12:.LANCHOR104]
	ldrh	w19, [x1, 116]
	ldrh	w21, [x1, 114]
	cmp	w3, 6
	stp	x27, x28, [sp, 80]
	ldr	x25, [x23, #:lo12:.LANCHOR60]
	add	w21, w19, w21
	bhi	.L2640
	adrp	x2, .L2643
	and	w21, w21, 65535
	add	x2, x2, :lo12:.L2643
	ldrh	w2, [x2,w3,uxtw #1]
	adr	x3, .Lrtx2643
	add	x2, x3, w2, sxth #2
	br	x2
.Lrtx2643:
	.section	.rodata.do_gc,"a",@progbits
	.align	0
	.align	2
.L2643:
	.2byte	(.L2642 - .Lrtx2643) / 4
	.2byte	(.L2644 - .Lrtx2643) / 4
	.2byte	(.L2645 - .Lrtx2643) / 4
	.2byte	(.L2646 - .Lrtx2643) / 4
	.2byte	(.L2647 - .Lrtx2643) / 4
	.2byte	(.L2648 - .Lrtx2643) / 4
	.2byte	(.L2649 - .Lrtx2643) / 4
	.section	.text.do_gc
.L2642:
	ldrh	w2, [x1, 118]
	adrp	x22, .LANCHOR67
	ldrh	w3, [x25, 80]
	add	w19, w19, w2
	mov	w2, 65535
	and	w19, w19, 65535
	cmp	w3, w2
	beq	.L2650
	adrp	x0, .LANCHOR22
	cmp	w19, 7
	mov	w23, 3
	csinc	w23, w23, wzr, hi
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	tbz	x0, 8, .L2652
	ldrh	w7, [x25, 122]
	adrp	x0, .LC153
	ldrh	w6, [x25, 120]
	mov	w4, w19
	ldrh	w5, [x25, 124]
	mov	w3, w21
	ldrb	w2, [x22, #:lo12:.LANCHOR67]
	mov	w1, 1348
	add	x0, x0, :lo12:.LC153
	bl	printf
.L2652:
	ldrb	w0, [x22, #:lo12:.LANCHOR67]
	mov	w2, 1
	mov	w1, w23
	bl	gc_search_src_blk
	cmp	w0, 0
	ble	.L2640
.L2653:
	mov	w0, 1
.L2774:
	strb	w0, [x20, #:lo12:.LANCHOR104]
	b	.L2640
.L2650:
	ldrh	w25, [x1, 122]
	cmp	w0, 1
	ldrh	w27, [x1, 124]
	bne	.L2654
	bl	gc_scan_static_data
	bl	gc_static_wearleveling
.L2654:
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	mov	w26, 1
	strb	w26, [x22, #:lo12:.LANCHOR67]
	ldrh	w5, [x0, 124]
	cbz	w5, .L2655
	adrp	x1, .LANCHOR22
	strb	wzr, [x22, #:lo12:.LANCHOR67]
	strb	w26, [x20, #:lo12:.LANCHOR104]
	ldr	w1, [x1, #:lo12:.LANCHOR22]
	tbz	x1, 8, .L2640
	ldrh	w7, [x0, 122]
	mov	w4, w19
	ldrh	w6, [x0, 120]
	mov	w3, w21
	ldp	x19, x20, [sp, 16]
	mov	w2, 0
	ldp	x21, x22, [sp, 32]
	mov	w1, 1373
	ldp	x23, x24, [sp, 48]
	adrp	x0, .LC153
	ldp	x25, x26, [sp, 64]
	add	x0, x0, :lo12:.LC153
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L2655:
	cmp	w21, 47
	bhi	.L2657
	cmp	w19, 1
	bls	.L2658
	cmp	w19, 16
	bhi	.L2659
	ldr	x0, [x24, #:lo12:.LANCHOR46]
	ldrh	w0, [x0, 120]
	cmp	w0, 127
	bhi	.L2660
.L2659:
	mov	w2, 16
	mov	w1, 3
.L2779:
	mov	w0, 1
.L2772:
	bl	gc_search_src_blk
	and	w0, w0, 65535
.L2661:
	cbnz	w0, .L2653
	b	.L2640
.L2660:
	mov	w2, 8
	mov	w1, 2
	b	.L2779
.L2658:
	adrp	x1, .LANCHOR22
	strb	wzr, [x22, #:lo12:.LANCHOR67]
	ldr	w1, [x1, #:lo12:.LANCHOR22]
	tbz	x1, 8, .L2662
	ldrh	w7, [x0, 122]
	mov	w5, 0
	ldrh	w6, [x0, 120]
	mov	w4, w19
	adrp	x0, .LC153
	mov	w3, w21
	mov	w2, 0
	mov	w1, 1386
	add	x0, x0, :lo12:.LC153
	bl	printf
.L2662:
	cmp	w21, 16
	bls	.L2663
	mov	w2, 1
.L2777:
	mov	w1, 2
	b	.L2771
.L2663:
	mov	w2, 16
.L2773:
	mov	w1, 1
.L2771:
	ldrb	w0, [x22, #:lo12:.LANCHOR67]
	b	.L2772
.L2657:
	add	w25, w25, w27
	cmp	w21, 127
	and	w25, w25, 65535
	bhi	.L2664
	sub	w0, w19, #2
	and	w0, w0, 65535
	cmp	w0, 13
	bhi	.L2665
	mov	w2, 8
	mov	w1, 2
	mov	w0, w26
	bl	gc_search_src_blk
	tst	w0, 65535
	bne	.L2653
.L2668:
	adrp	x0, .LANCHOR64
	adrp	x26, .LANCHOR58
	ldrb	w0, [x0, #:lo12:.LANCHOR64]
	cmp	w0, 2
	adrp	x0, .LANCHOR22
	bne	.L2768
	add	x1, x26, :lo12:.LANCHOR58
	cmp	w19, 1
	strh	wzr, [x1, 34]
	bls	.L2669
.L2672:
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	mov	w1, 1
	strb	w1, [x22, #:lo12:.LANCHOR67]
	tbz	x0, 8, .L2671
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	mov	w4, w19
	mov	w3, w21
	mov	w2, 1
	mov	w1, 1411
	ldrh	w7, [x0, 122]
	ldrh	w6, [x0, 120]
	ldrh	w5, [x0, 124]
	adrp	x0, .LC153
	add	x0, x0, :lo12:.LC153
	bl	printf
.L2671:
	add	x26, x26, :lo12:.LANCHOR58
	mov	w2, 16
	mov	w1, 1
	ldrh	w0, [x26, 34]
	strh	wzr, [x26, 32]
	add	w0, w0, 1
	strh	w0, [x26, 34]
	ldrb	w0, [x22, #:lo12:.LANCHOR67]
	bl	gc_search_src_blk
	and	w0, w0, 65535
	cmp	w0, 7
	ccmp	w19, 31, 2, ls
	bls	.L2673
	ldr	x1, [x24, #:lo12:.LANCHOR46]
	ldrh	w2, [x1, 120]
	adrp	x1, .LANCHOR163
	ldrh	w1, [x1, #:lo12:.LANCHOR163]
	cmp	w2, w1
	bls	.L2661
.L2673:
	cmp	w25, 63
	bhi	.L2674
	mov	w2, 8
	b	.L2777
.L2665:
	adrp	x0, .LANCHOR165
	ldrh	w0, [x0, #:lo12:.LANCHOR165]
	cmp	w25, w0, lsr 1
	bcs	.L2668
.L2640:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2768:
	cmp	w19, 1
	bls	.L2669
	add	x1, x26, :lo12:.LANCHOR58
	ldrh	w1, [x1, 34]
	cmp	w1, 3
	bls	.L2672
.L2669:
	add	x26, x26, :lo12:.LANCHOR58
	ldr	w0, [x0, #:lo12:.LANCHOR22]
	strb	wzr, [x22, #:lo12:.LANCHOR67]
	strh	wzr, [x26, 34]
	tbz	x0, 8, .L2675
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	mov	w4, w19
	mov	w3, w21
	mov	w2, 0
	mov	w1, 1426
	ldrh	w7, [x0, 122]
	ldrh	w6, [x0, 120]
	ldrh	w5, [x0, 124]
	adrp	x0, .LC153
	add	x0, x0, :lo12:.LC153
	bl	printf
.L2675:
	adrp	x0, .LANCHOR165
	ldrh	w0, [x0, #:lo12:.LANCHOR165]
	cmp	w25, w0, lsr 1
	bls	.L2640
	mov	w2, 16
	cmp	w19, 31
	bhi	.L2773
	b	.L2778
.L2674:
	mov	w2, 16
.L2778:
	mov	w1, 3
	b	.L2771
.L2664:
	cmp	w21, 255
	bhi	.L2677
	adrp	x0, .LANCHOR165
	ldrh	w0, [x0, #:lo12:.LANCHOR165]
	cmp	w25, w0
	bls	.L2677
	cmp	w25, w0, lsr 1
	bcc	.L2640
	strb	wzr, [x22, #:lo12:.LANCHOR67]
	mov	w2, 16
	mov	w1, w26
	mov	w0, 0
	bl	gc_search_src_blk
	and	w0, w0, 65535
	cmp	w0, 7
	ccmp	w19, 4, 0, ls
	bls	.L2661
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	mov	w1, 255
	mov	w2, 128
	add	x0, x0, 136
	strh	wzr, [x0, -16]
	bl	ftl_memset
	strb	w26, [x22, #:lo12:.LANCHOR67]
	ldr	x0, [x24, #:lo12:.LANCHOR46]
	ldrh	w1, [x0, 120]
	adrp	x0, .LANCHOR163
	ldrh	w0, [x0, #:lo12:.LANCHOR163]
	cmp	w1, w0
	bls	.L2678
	cmp	w19, 16
	bls	.L2679
.L2681:
	mov	w2, 8
	mov	w1, 2
.L2770:
	mov	w0, 1
	bl	gc_search_src_blk
	mov	w1, 1
	and	w0, w0, 65535
	strb	w1, [x20, #:lo12:.LANCHOR104]
	b	.L2661
.L2678:
	cmp	w19, 32
	bls	.L2679
	mov	w2, 16
	mov	w1, w26
	b	.L2770
.L2679:
	cmp	w19, 7
	bls	.L2681
	mov	w2, 16
	mov	w1, 3
	b	.L2770
.L2677:
	sub	w19, w19, #2
	and	w19, w19, 65535
	cmp	w19, 5
	bhi	.L2640
	adrp	x0, .LANCHOR165
	ldrh	w0, [x0, #:lo12:.LANCHOR165]
	cmp	w25, w0, lsr 1
	bls	.L2640
	mov	w2, 16
	mov	w1, 2
	mov	w0, 1
	bl	gc_search_src_blk
	and	w0, w0, 65535
	cmp	w0, 15
	bhi	.L2653
	ldr	x3, [x23, #:lo12:.LANCHOR60]
	mov	w2, 128
	ldrb	w1, [x22, #:lo12:.LANCHOR67]
	ldp	x19, x20, [sp, 16]
	add	x0, x3, x1, sxtw 1
	ubfiz	x1, x1, 7, 8
	ldp	x21, x22, [sp, 32]
	strh	wzr, [x0, 120]
	add	x0, x1, 136
	ldp	x23, x24, [sp, 48]
	mov	w1, 255
	ldp	x25, x26, [sp, 64]
	add	x0, x3, x0
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	ftl_memset
.L2644:
	adrp	x7, .LANCHOR58
	mov	w0, 65535
	ldrh	w1, [x7, #:lo12:.LANCHOR58]
	cmp	w1, w0
	bne	.L2684
	bl	gc_get_src_blk
	strh	w0, [x7, #:lo12:.LANCHOR58]
.L2684:
	ldrh	w0, [x7, #:lo12:.LANCHOR58]
	mov	w1, 65535
	add	x2, x7, :lo12:.LANCHOR58
	cmp	w0, w1
	beq	.L2685
	ldrh	w3, [x2, 56]
	cbz	w3, .L2686
	add	x2, x2, 58
	mov	w1, 0
.L2688:
	ldrh	w4, [x2], 2
	cmp	w4, w0
	bne	.L2687
.L2691:
	adrp	x0, .LANCHOR58
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR58]
	b	.L2640
.L2687:
	add	w1, w1, 1
	and	w1, w1, 65535
	cmp	w3, w1
	bne	.L2688
.L2686:
	adrp	x1, .LANCHOR59
	ldr	x1, [x1, #:lo12:.LANCHOR59]
	add	x1, x1, x0, lsl 2
	ldrb	w1, [x1, 2]
	and	w2, w1, 224
	cmp	w2, 224
	beq	.L2689
	tst	w1, 192
	bne	.L2690
.L2689:
	adrp	x1, .LANCHOR56
	ldr	x1, [x1, #:lo12:.LANCHOR56]
	ldrh	w0, [x1, x0, lsl 1]
	cbz	w0, .L2691
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 1497
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2692:
	b	.L2692
.L2690:
	mov	w0, 2
	b	.L2774
.L2685:
	strb	wzr, [x20, #:lo12:.LANCHOR104]
	b	.L2640
.L2645:
	bl	gc_scan_src_blk
	cmn	w0, #1
	bne	.L2693
	mov	w0, 3
	b	.L2774
.L2693:
	adrp	x21, .LANCHOR58
	mov	w1, 65535
	add	x19, x21, :lo12:.LANCHOR58
	ldrh	w0, [x21, #:lo12:.LANCHOR58]
	cmp	w0, w1
	beq	.L2653
	ldrh	w1, [x19, 24]
	cbz	w1, .L2694
	mov	w0, 4
	strh	wzr, [x19, 26]
	strb	w0, [x20, #:lo12:.LANCHOR104]
	b	.L2640
.L2694:
	mov	w1, 1
	strb	w1, [x20, #:lo12:.LANCHOR104]
	adrp	x20, .LANCHOR56
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x20, #:lo12:.LANCHOR56]
	ldrh	w1, [x2, x1]
	cbz	w1, .L2695
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 1525
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2696:
	b	.L2696
.L2695:
	bl	ftl_free_sblk
	ldr	x0, [x20, #:lo12:.LANCHOR56]
	ldrh	w1, [x21, #:lo12:.LANCHOR58]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x19, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 30]
	cmp	w0, 8
	bls	.L2691
	strh	wzr, [x19, 30]
	bl	ftl_flush
	bl	pm_flush
	bl	ftl_ext_info_flush
	mov	w0, 0
	bl	ftl_info_flush
	b	.L2691
.L2646:
	bl	gc_scan_src_blk_one_page
	adrp	x19, .LANCHOR58
	add	x0, x19, :lo12:.LANCHOR58
	adrp	x1, .LANCHOR79
	ldrh	w1, [x1, #:lo12:.LANCHOR79]
	ldrh	w2, [x0, 2]
	cmp	w2, w1
	bcc	.L2640
	ldrh	w3, [x0, 24]
	adrp	x2, .LANCHOR22
	cbz	w3, .L2697
	strh	wzr, [x0, 26]
	mov	w1, 4
	ldr	w0, [x2, #:lo12:.LANCHOR22]
	strb	w1, [x20, #:lo12:.LANCHOR104]
	adrp	x20, .LANCHOR56
	tbz	x0, 8, .L2698
	ldrh	w1, [x19, #:lo12:.LANCHOR58]
	ldr	x2, [x20, #:lo12:.LANCHOR56]
	ubfiz	x0, x1, 1, 16
	ldrh	w2, [x2, x0]
	adrp	x0, .LC154
	add	x0, x0, :lo12:.LC154
	bl	printf
.L2698:
	ldrh	w2, [x19, #:lo12:.LANCHOR58]
	add	x0, x19, :lo12:.LANCHOR58
	ldr	x1, [x20, #:lo12:.LANCHOR56]
	ldrh	w0, [x0, 24]
	ldrh	w1, [x1, x2, lsl 1]
	cmp	w1, w0
	beq	.L2640
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 1555
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2699:
	b	.L2699
.L2697:
	adrp	x0, .LANCHOR59
	ldrh	w1, [x19, #:lo12:.LANCHOR58]
	ldr	x21, [x0, #:lo12:.LANCHOR59]
	mov	w0, 1
	strb	w0, [x20, #:lo12:.LANCHOR104]
	ldr	w0, [x2, #:lo12:.LANCHOR22]
	add	x21, x21, x1, uxth 2
	tbz	x0, 8, .L2700
	ldrb	w2, [x21, 2]
	adrp	x0, .LC155
	add	x0, x0, :lo12:.LC155
	ubfx	x2, x2, 5, 3
	bl	printf
.L2700:
	ldrb	w0, [x21, 2]
	and	w1, w0, 224
	cmp	w1, 224
	beq	.L2701
	tst	w0, 192
	bne	.L2702
.L2701:
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 1565
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2703:
	b	.L2703
.L2702:
	ldrh	w0, [x19, #:lo12:.LANCHOR58]
	add	x20, x19, :lo12:.LANCHOR58
	bl	ftl_free_sblk
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR58]
	ldrh	w0, [x20, 30]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x20, 30]
	cmp	w0, 8
	bls	.L2640
	strh	wzr, [x20, 30]
.L2776:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	flt_sys_flush
.L2647:
	ldrh	w27, [x25, 80]
	mov	w0, 65535
	add	x26, x25, 80
	cmp	w27, w0
	bne	.L2704
	adrp	x0, .LANCHOR67
	ldrb	w22, [x0, #:lo12:.LANCHOR67]
	cmp	w22, 1
	bne	.L2704
	bl	ftl_flush
	mov	w0, 5
	bl	ftl_alloc_sblk
	and	w28, w0, 65535
	cmp	w28, w27
	bne	.L2705
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 1581
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2706:
	b	.L2706
.L2705:
	mov	w1, w22
	bl	ftl_erase_sblk
	mov	w0, 5
	strb	w0, [x26, 4]
	add	x1, x25, 96
	mov	w0, w28
	bl	ftl_get_blk_list_in_sblk
	and	w0, w0, 255
	adrp	x1, .LANCHOR79
	strb	w0, [x26, 9]
	adrp	x21, .LANCHOR68
	adrp	x20, .LANCHOR69
	ldrh	w1, [x1, #:lo12:.LANCHOR79]
	strh	w28, [x25, 80]
	ldrh	w2, [x21, #:lo12:.LANCHOR68]
	strh	wzr, [x26, 2]
	mul	w0, w0, w1
	strb	wzr, [x26, 5]
	strh	w0, [x26, 6]
	mov	w1, 255
	ldrb	w0, [x20, #:lo12:.LANCHOR69]
	strh	wzr, [x26, 10]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR107
	ldr	x0, [x0, #:lo12:.LANCHOR107]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x20, #:lo12:.LANCHOR69]
	mov	w1, 255
	ldrh	w2, [x21, #:lo12:.LANCHOR68]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR108
	ldr	x0, [x0, #:lo12:.LANCHOR108]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldrb	w0, [x20, #:lo12:.LANCHOR69]
	mov	w1, 255
	ldrh	w2, [x21, #:lo12:.LANCHOR68]
	mul	w2, w2, w0
	adrp	x0, .LANCHOR65
	ldr	x0, [x0, #:lo12:.LANCHOR65]
	bl	ftl_memset
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	mov	w1, -1
	str	w28, [x0, 132]
	strh	w1, [x0, 128]
	strh	w1, [x0, 130]
	bl	pm_flush
	bl	ftl_ext_info_flush
	ldr	x0, [x24, #:lo12:.LANCHOR46]
	mov	w1, -1
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	strh	w28, [x0, 126]
	adrp	x0, .LANCHOR58
	add	x0, x0, :lo12:.LANCHOR58
	ldp	x23, x24, [sp, 48]
	strh	wzr, [x0, 314]
	strh	wzr, [x0, 56]
	strh	wzr, [x0, 316]
	strh	wzr, [x0, 318]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	str	w1, [x0, 320]
	mov	w0, 0
	ldp	x29, x30, [sp], 96
	b	ftl_info_flush
.L2704:
	cmp	w21, 31
	bls	.L2724
	cmp	w21, 63
	bls	.L2725
	cmp	w21, 127
	bls	.L2726
	cmp	w21, 255
	cset	w21, ls
	add	w21, w21, 1
.L2707:
	adrp	x27, .LANCHOR67
	adrp	x22, .LANCHOR58
	add	x27, x27, :lo12:.LANCHOR67
	add	x19, x22, :lo12:.LANCHOR58
	adrp	x28, .LANCHOR38
.L2708:
	sub	w21, w21, #1
	and	w21, w21, 255
	cmp	w21, 255
	beq	.L2640
	bl	gc_do_copy_back
	ldrb	w0, [x27]
	cbnz	w0, .L2709
	ldrb	w0, [x28, #:lo12:.LANCHOR38]
	cmp	w0, 3
	bhi	.L2710
	bl	ftl_write_commit
.L2710:
	ldrh	w1, [x19, 26]
	ldrh	w0, [x19, 24]
	cmp	w1, w0
	bcc	.L2708
	mov	w0, 1
	strb	w0, [x20, #:lo12:.LANCHOR104]
	bl	ftl_write_commit
	bl	ftl_flush
	ldrh	w0, [x19]
	adrp	x2, .LANCHOR56
	ldr	x2, [x2, #:lo12:.LANCHOR56]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbz	w1, .L2712
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	mov	w2, 1638
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2713:
	b	.L2713
.L2724:
	mov	w21, 9
	b	.L2707
.L2725:
	mov	w21, 5
	b	.L2707
.L2726:
	mov	w21, 3
	b	.L2707
.L2712:
	bl	ftl_free_sblk
.L2775:
	mov	w0, -1
	strh	w0, [x19]
	b	.L2640
.L2709:
	ldrh	w0, [x19, 318]
	cbz	w0, .L2714
	ldr	w0, [x19, 320]
	strh	wzr, [x19, 318]
	cmn	w0, #1
	beq	.L2715
	bl	ftl_mask_bad_block
.L2715:
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	add	x19, x22, :lo12:.LANCHOR58
	strh	wzr, [x19, 56]
	ldrh	w0, [x0, 80]
	str	wzr, [x19, 320]
	bl	ftl_free_sblk
	ldr	x1, [x23, #:lo12:.LANCHOR60]
	mov	w0, -1
	ldr	x2, [x24, #:lo12:.LANCHOR46]
	strh	w0, [x1, 80]
	strh	w0, [x2, 126]
	strh	w0, [x1, 130]
	ldr	x0, [x19, 8]
	cbz	x0, .L2716
	bl	buf_free
.L2716:
	add	x22, x22, :lo12:.LANCHOR58
	str	xzr, [x22, 8]
	bl	flt_sys_flush
	adrp	x1, .LANCHOR172
	adrp	x0, .LC0
	strb	wzr, [x20, #:lo12:.LANCHOR104]
	mov	w2, 1671
	add	x1, x1, :lo12:.LANCHOR172
	add	x0, x0, :lo12:.LC0
	bl	printf
.L2717:
	b	.L2717
.L2714:
	ldrh	w0, [x26, 6]
	ldrh	w1, [x19, 26]
	cmp	w0, 1
	ldrh	w0, [x19, 24]
	bls	.L2718
	cmp	w1, w0
	bcc	.L2708
	mov	w0, 1
	strb	w0, [x20, #:lo12:.LANCHOR104]
	ldrh	w0, [x19, 56]
	add	w1, w0, 1
	strh	w1, [x19, 56]
	add	x0, x19, x0, sxtw 1
	ldrh	w1, [x19]
	strh	w1, [x0, 58]
	b	.L2775
.L2718:
	mov	w2, 5
	strb	w2, [x20, #:lo12:.LANCHOR104]
	cmp	w1, w0
	bcc	.L2719
	ldrh	w0, [x19, 56]
	add	w1, w0, 1
	strh	w1, [x19, 56]
	add	x0, x19, x0, sxtw 1
	ldrh	w1, [x19]
	strh	w1, [x0, 58]
	mov	w0, -1
	strh	w0, [x19]
.L2719:
	bl	ftl_flush
	bl	sblk_wait_write_queue_completed
	bl	gc_write_completed
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	ldrh	w1, [x25, 80]
	strh	w1, [x0, 128]
	bl	pm_flush
	bl	ftl_ext_info_flush
	add	x0, x22, :lo12:.LANCHOR58
	adrp	x1, .LANCHOR79
	adrp	x2, .LANCHOR64
	ldrh	w1, [x1, #:lo12:.LANCHOR79]
	ldrb	w2, [x2, #:lo12:.LANCHOR64]
	strh	wzr, [x0, 16]
	strh	w1, [x0, 18]
	cmp	w2, 2
	strh	w2, [x0, 20]
	bne	.L2720
	ubfiz	w1, w1, 1, 15
	strh	w1, [x0, 18]
	mov	w1, 1
	strh	w1, [x0, 20]
.L2720:
	add	x22, x22, :lo12:.LANCHOR58
	strh	wzr, [x22, 22]
	b	.L2640
.L2648:
	adrp	x19, .LANCHOR58
	bl	gc_check_data_one_wl
	add	x19, x19, :lo12:.LANCHOR58
	cbz	w0, .L2722
	ldr	x0, [x23, #:lo12:.LANCHOR60]
	strh	wzr, [x19, 56]
	ldrh	w0, [x0, 80]
	bl	ftl_free_sblk
	ldr	x1, [x23, #:lo12:.LANCHOR60]
	mov	w0, -1
	ldr	x2, [x24, #:lo12:.LANCHOR46]
	strh	w0, [x1, 80]
	strh	w0, [x2, 126]
	strh	w0, [x1, 130]
	ldr	x0, [x19, 8]
	bl	buf_free
	strb	wzr, [x20, #:lo12:.LANCHOR104]
	str	xzr, [x19, 8]
	b	.L2776
.L2722:
	ldrh	w1, [x19, 16]
	ldrh	w0, [x19, 18]
	cmp	w1, w0
	bcc	.L2640
	mov	w0, 6
	strb	w0, [x20, #:lo12:.LANCHOR104]
	ldr	x0, [x19, 8]
	bl	buf_free
	str	xzr, [x19, 8]
	b	.L2640
.L2649:
	bl	gc_update_l2p_map_new
	mov	w19, -1
	bl	gc_free_src_blk
	bl	ftl_flush
	bl	pm_flush
	strh	w19, [x25, 80]
	bl	ftl_ext_info_flush
	ldr	x0, [x24, #:lo12:.LANCHOR46]
	strh	w19, [x0, 126]
	mov	w0, 0
	bl	ftl_info_flush
	strb	wzr, [x20, #:lo12:.LANCHOR104]
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	print_ftl_debug_info
	.size	do_gc, .-do_gc
	.section	.text.ftl_write,"ax",@progbits
	.align	2
	.global	ftl_write
	.type	ftl_write, %function
ftl_write:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	x23, x3
	stp	x25, x26, [sp, 64]
	mov	w25, w2
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	cbnz	w0, .L2781
	adrp	x0, .LANCHOR52
	ldr	w2, [x0, #:lo12:.LANCHOR52]
	mov	w0, 24576
.L2782:
	add	w3, w1, w25
	cmp	w2, w3
	bcc	.L2794
	adrp	x22, .LANCHOR45
	add	w27, w0, w1
	sub	w19, w25, #1
	adrp	x24, .LANCHOR46
	ldrb	w0, [x22, #:lo12:.LANCHOR45]
	add	w19, w19, w27
	add	x22, x22, :lo12:.LANCHOR45
	udiv	w21, w27, w0
	udiv	w19, w19, w0
	add	w0, w27, w25
	str	w0, [x29, 108]
	mov	w28, w21
	sub	w20, w19, w21
	add	w20, w20, 1
.L2784:
	cbnz	w20, .L2792
	bl	ftl_write_commit
	mov	w0, 0
	mov	w1, 1
	bl	do_gc
	mov	w0, 0
.L2780:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2781:
	cmp	w0, 3
	bhi	.L2794
	lsl	w0, w0, 13
	mov	w2, 8192
	b	.L2782
.L2792:
	mov	w0, 0
	bl	buf_alloc
	mov	x26, x0
	cbnz	x0, .L2785
	bl	ftl_write_commit
	b	.L2784
.L2785:
	strb	wzr, [x0, 57]
	cmp	w28, w21
	ldrb	w0, [x22]
	ccmp	w28, w19, 4, ne
	strb	w0, [x26, 56]
	bne	.L2788
	cmp	w28, w21
	bne	.L2789
	udiv	w1, w27, w0
	msub	w1, w1, w0, w27
	and	w1, w1, 255
	strb	w1, [x26, 57]
	sub	w0, w0, w1
	and	w0, w0, 255
	cmp	w25, w0
	csel	w0, w25, w0, cc
.L2796:
	strb	w0, [x26, 56]
.L2788:
	ldr	x3, [x26, 8]
	mov	x1, x23
	ldrb	w0, [x26, 57]
	sub	w20, w20, #1
	ldrb	w2, [x26, 56]
	ubfiz	x0, x0, 9, 8
	lsl	w2, w2, 9
	add	x0, x3, x0
	bl	ftl_memcpy
	ldr	x1, [x24, #:lo12:.LANCHOR46]
	ldr	w0, [x1, 8]
	str	w28, [x26, 36]
	add	w28, w28, 1
	add	w2, w0, 1
	str	w2, [x1, 8]
	str	w0, [x26, 32]
	mov	x0, x26
	bl	ftl_write_buf
	ldrb	w0, [x26, 56]
	ubfiz	x0, x0, 9, 8
	add	x23, x23, x0
	b	.L2784
.L2789:
	ldr	w1, [x29, 108]
	msub	w0, w0, w28, w1
	b	.L2796
.L2794:
	mov	w0, -1
	b	.L2780
	.size	ftl_write, .-ftl_write
	.section	.text.FtlWrite,"ax",@progbits
	.align	2
	.global	FtlWrite
	.type	FtlWrite, %function
FtlWrite:
	and	w0, w0, 255
	b	ftl_write
	.size	FtlWrite, .-FtlWrite
	.section	.text.StorageSysDataStore,"ax",@progbits
	.align	2
	.global	StorageSysDataStore
	.type	StorageSysDataStore, %function
StorageSysDataStore:
	mov	x3, x1
	mov	w2, 1
	mov	w1, w0
	mov	w0, 2
	b	ftl_write
	.size	StorageSysDataStore, .-StorageSysDataStore
	.global	g_pm_spare
	.global	pm_gc_enable
	.global	pm_last_load_ram_id
	.global	pm_last_update_ram_id
	.global	pm_ram_info
	.global	sblk_gc_write_completed_queue_head
	.global	sblk_read_completed_queue_head
	.global	sblk_write_completed_queue_head
	.global	sblk_queue_head
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
	.global	gc_slc_mode_vpn_th
	.global	gc_tlc_mode_tlc_vpn_th
	.global	gc_tlc_mode_slc_vpn_th
	.global	gc_state
	.global	gc_mode
	.global	check_vpc_tbl
	.global	p_read_ahead_ext_buf
	.global	read_ahead_lpa
	.global	write_commit_count
	.global	write_commit_head
	.global	write_buf_count
	.global	write_buf_head
	.global	ftl_flush_jiffies
	.global	lpa_hash
	.global	lpa_hash_index
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
	.global	gNandParaInfo
	.global	NandFlashParaTbl
	.global	gpNandParaInfo
	.global	gNandOptPara
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
	.set	.LANCHOR26,. + 0
	.type	IDByte, %object
	.size	IDByte, 32
IDByte:
	.zero	32
	.section	.bss._c_ftl_blk_pre_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR54,. + 0
	.type	_c_ftl_blk_pre_plane, %object
	.size	_c_ftl_blk_pre_plane, 2
_c_ftl_blk_pre_plane:
	.zero	2
	.section	.bss._c_ftl_block_addr_log2,"aw",@nobits
	.align	1
	.set	.LANCHOR71,. + 0
	.type	_c_ftl_block_addr_log2, %object
	.size	_c_ftl_block_addr_log2, 2
_c_ftl_block_addr_log2:
	.zero	2
	.section	.bss._c_ftl_block_align_addr,"aw",@nobits
	.align	1
	.set	.LANCHOR75,. + 0
	.type	_c_ftl_block_align_addr, %object
	.size	_c_ftl_block_align_addr, 2
_c_ftl_block_align_addr:
	.zero	2
	.section	.bss._c_ftl_byte_pre_page,"aw",@nobits
	.align	1
	.set	.LANCHOR149,. + 0
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
	.set	.LANCHOR76,. + 0
	.type	_c_ftl_nand_die_num, %object
	.size	_c_ftl_nand_die_num, 1
_c_ftl_nand_die_num:
	.zero	1
	.section	.bss._c_ftl_nand_planes_num,"aw",@nobits
	.set	.LANCHOR69,. + 0
	.type	_c_ftl_nand_planes_num, %object
	.size	_c_ftl_nand_planes_num, 1
_c_ftl_nand_planes_num:
	.zero	1
	.section	.bss._c_ftl_nand_type,"aw",@nobits
	.set	.LANCHOR64,. + 0
	.type	_c_ftl_nand_type, %object
	.size	_c_ftl_nand_type, 1
_c_ftl_nand_type:
	.zero	1
	.section	.bss._c_ftl_page_pre_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR68,. + 0
	.type	_c_ftl_page_pre_blk, %object
	.size	_c_ftl_page_pre_blk, 2
_c_ftl_page_pre_blk:
	.zero	2
	.section	.bss._c_ftl_page_pre_slc_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR79,. + 0
	.type	_c_ftl_page_pre_slc_blk, %object
	.size	_c_ftl_page_pre_slc_blk, 2
_c_ftl_page_pre_slc_blk:
	.zero	2
	.section	.bss._c_ftl_planes_per_die,"aw",@nobits
	.set	.LANCHOR70,. + 0
	.type	_c_ftl_planes_per_die, %object
	.size	_c_ftl_planes_per_die, 1
_c_ftl_planes_per_die:
	.zero	1
	.section	.bss._c_ftl_pm_page_num,"aw",@nobits
	.align	1
	.set	.LANCHOR137,. + 0
	.type	_c_ftl_pm_page_num, %object
	.size	_c_ftl_pm_page_num, 2
_c_ftl_pm_page_num:
	.zero	2
	.section	.bss._c_ftl_sec_per_page,"aw",@nobits
	.set	.LANCHOR45,. + 0
	.type	_c_ftl_sec_per_page, %object
	.size	_c_ftl_sec_per_page, 1
_c_ftl_sec_per_page:
	.zero	1
	.section	.bss._c_max_pm_sblk,"aw",@nobits
	.align	1
	.set	.LANCHOR101,. + 0
	.type	_c_max_pm_sblk, %object
	.size	_c_max_pm_sblk, 2
_c_max_pm_sblk:
	.zero	2
	.section	.bss._c_totle_data_density,"aw",@nobits
	.align	2
	.set	.LANCHOR162,. + 0
	.type	_c_totle_data_density, %object
	.size	_c_totle_data_density, 4
_c_totle_data_density:
	.zero	4
	.section	.bss._c_totle_log_page,"aw",@nobits
	.align	2
	.set	.LANCHOR47,. + 0
	.type	_c_totle_log_page, %object
	.size	_c_totle_log_page, 4
_c_totle_log_page:
	.zero	4
	.section	.bss._c_totle_phy_density,"aw",@nobits
	.align	2
	.set	.LANCHOR161,. + 0
	.type	_c_totle_phy_density, %object
	.size	_c_totle_phy_density, 4
_c_totle_phy_density:
	.zero	4
	.section	.bss._c_user_data_density,"aw",@nobits
	.align	2
	.set	.LANCHOR52,. + 0
	.type	_c_user_data_density, %object
	.size	_c_user_data_density, 4
_c_user_data_density:
	.zero	4
	.section	.bss._max_slc_super_block,"aw",@nobits
	.align	1
	.set	.LANCHOR164,. + 0
	.type	_max_slc_super_block, %object
	.size	_max_slc_super_block, 2
_max_slc_super_block:
	.zero	2
	.section	.bss._max_xlc_super_block,"aw",@nobits
	.align	1
	.set	.LANCHOR163,. + 0
	.type	_max_xlc_super_block, %object
	.size	_max_xlc_super_block, 2
_max_xlc_super_block:
	.zero	2
	.section	.bss._min_slc_super_block,"aw",@nobits
	.align	1
	.set	.LANCHOR165,. + 0
	.type	_min_slc_super_block, %object
	.size	_min_slc_super_block, 2
_min_slc_super_block:
	.zero	2
	.section	.bss.check_vpc_tbl,"aw",@nobits
	.align	3
	.type	check_vpc_tbl, %object
	.size	check_vpc_tbl, 4352
check_vpc_tbl:
	.zero	4352
	.section	.bss.fill_spare_size,"aw",@nobits
	.align	1
	.set	.LANCHOR31,. + 0
	.type	fill_spare_size, %object
	.size	fill_spare_size, 2
fill_spare_size:
	.zero	2
	.section	.bss.flash_read_retry,"aw",@nobits
	.align	3
	.set	.LANCHOR115,. + 0
	.type	flash_read_retry, %object
	.size	flash_read_retry, 8
flash_read_retry:
	.zero	8
	.section	.bss.free_buf_count,"aw",@nobits
	.set	.LANCHOR38,. + 0
	.type	free_buf_count, %object
	.size	free_buf_count, 1
free_buf_count:
	.zero	1
	.section	.bss.ftl_ext_info_data_buffer,"aw",@nobits
	.align	6
	.type	ftl_ext_info_data_buffer, %object
	.size	ftl_ext_info_data_buffer, 16384
ftl_ext_info_data_buffer:
	.zero	16384
	.section	.bss.ftl_flush_jiffies,"aw",@nobits
	.align	2
	.set	.LANCHOR168,. + 0
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
	.set	.LANCHOR130,. + 0
	.type	ftl_info_spare, %object
	.size	ftl_info_spare, 256
ftl_info_spare:
	.zero	256
	.section	.bss.ftl_low_format_cur_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR53,. + 0
	.type	ftl_low_format_cur_blk, %object
	.size	ftl_low_format_cur_blk, 2
ftl_low_format_cur_blk:
	.zero	2
	.section	.bss.ftl_power_lost_flag,"aw",@nobits
	.set	.LANCHOR133,. + 0
	.type	ftl_power_lost_flag, %object
	.size	ftl_power_lost_flag, 1
ftl_power_lost_flag:
	.zero	1
	.section	.bss.ftl_sblk_lpa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR82,. + 0
	.type	ftl_sblk_lpa_tbl, %object
	.size	ftl_sblk_lpa_tbl, 8
ftl_sblk_lpa_tbl:
	.zero	8
	.section	.bss.ftl_sblk_vpn,"aw",@nobits
	.align	3
	.set	.LANCHOR56,. + 0
	.type	ftl_sblk_vpn, %object
	.size	ftl_sblk_vpn, 8
ftl_sblk_vpn:
	.zero	8
	.section	.bss.ftl_sblk_vpn_update_id,"aw",@nobits
	.align	1
	.set	.LANCHOR87,. + 0
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
	.set	.LANCHOR121,. + 0
	.type	ftl_tmp_spare, %object
	.size	ftl_tmp_spare, 256
ftl_tmp_spare:
	.zero	256
	.section	.bss.ftl_vpn_update_count,"aw",@nobits
	.align	1
	.set	.LANCHOR86,. + 0
	.type	ftl_vpn_update_count, %object
	.size	ftl_vpn_update_count, 2
ftl_vpn_update_count:
	.zero	2
	.section	.bss.gNandOptPara,"aw",@nobits
	.align	3
	.set	.LANCHOR103,. + 0
	.type	gNandOptPara, %object
	.size	gNandOptPara, 32
gNandOptPara:
	.zero	32
	.section	.bss.g_block_align_addr,"aw",@nobits
	.align	1
	.set	.LANCHOR13,. + 0
	.type	g_block_align_addr, %object
	.size	g_block_align_addr, 2
g_block_align_addr:
	.zero	2
	.section	.bss.g_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR36,. + 0
	.type	g_buf, %object
	.size	g_buf, 2048
g_buf:
	.zero	2048
	.section	.bss.g_die_addr,"aw",@nobits
	.align	2
	.set	.LANCHOR98,. + 0
	.type	g_die_addr, %object
	.size	g_die_addr, 32
g_die_addr:
	.zero	32
	.section	.bss.g_die_cs_idx,"aw",@nobits
	.align	2
	.set	.LANCHOR10,. + 0
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
	.set	.LANCHOR66,. + 0
	.type	g_flash_3d_tlc_flag, %object
	.size	g_flash_3d_tlc_flag, 1
g_flash_3d_tlc_flag:
	.zero	1
	.section	.bss.g_flash_blk_info,"aw",@nobits
	.align	3
	.set	.LANCHOR117,. + 0
	.type	g_flash_blk_info, %object
	.size	g_flash_blk_info, 4
g_flash_blk_info:
	.zero	4
	.section	.bss.g_flash_cur_mode,"aw",@nobits
	.set	.LANCHOR20,. + 0
	.type	g_flash_cur_mode, %object
	.size	g_flash_cur_mode, 1
g_flash_cur_mode:
	.zero	1
	.section	.bss.g_flash_interface_mode,"aw",@nobits
	.set	.LANCHOR25,. + 0
	.type	g_flash_interface_mode, %object
	.size	g_flash_interface_mode, 1
g_flash_interface_mode:
	.zero	1
	.section	.bss.g_flash_multi_page_prog_en,"aw",@nobits
	.set	.LANCHOR23,. + 0
	.type	g_flash_multi_page_prog_en, %object
	.size	g_flash_multi_page_prog_en, 1
g_flash_multi_page_prog_en:
	.zero	1
	.section	.bss.g_flash_multi_page_read_en,"aw",@nobits
	.set	.LANCHOR144,. + 0
	.type	g_flash_multi_page_read_en, %object
	.size	g_flash_multi_page_read_en, 1
g_flash_multi_page_read_en:
	.zero	1
	.section	.bss.g_flash_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR119,. + 0
	.type	g_flash_page_buffer, %object
	.size	g_flash_page_buffer, 8
g_flash_page_buffer:
	.zero	8
	.section	.bss.g_flash_reversd_blks,"aw",@nobits
	.set	.LANCHOR123,. + 0
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
	.set	.LANCHOR118,. + 0
	.type	g_flash_spare_buffer, %object
	.size	g_flash_spare_buffer, 8
g_flash_spare_buffer:
	.zero	8
	.section	.bss.g_flash_sys_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR116,. + 0
	.type	g_flash_sys_spare_buffer, %object
	.size	g_flash_sys_spare_buffer, 8
g_flash_sys_spare_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_page_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR111,. + 0
	.type	g_flash_tmp_page_buffer, %object
	.size	g_flash_tmp_page_buffer, 8
g_flash_tmp_page_buffer:
	.zero	8
	.section	.bss.g_flash_tmp_spare_buffer,"aw",@nobits
	.align	3
	.set	.LANCHOR112,. + 0
	.type	g_flash_tmp_spare_buffer, %object
	.size	g_flash_tmp_spare_buffer, 8
g_flash_tmp_spare_buffer:
	.zero	8
	.section	.bss.g_flash_toggle_mode_en,"aw",@nobits
	.set	.LANCHOR35,. + 0
	.type	g_flash_toggle_mode_en, %object
	.size	g_flash_toggle_mode_en, 1
g_flash_toggle_mode_en:
	.zero	1
	.section	.bss.g_ftl_info_blk,"aw",@nobits
	.align	6
	.set	.LANCHOR131,. + 0
	.type	g_ftl_info_blk, %object
	.size	g_ftl_info_blk, 4
g_ftl_info_blk:
	.zero	4
	.section	.bss.g_gc_info,"aw",@nobits
	.align	3
	.set	.LANCHOR58,. + 0
	.type	g_gc_info, %object
	.size	g_gc_info, 328
g_gc_info:
	.zero	328
	.section	.bss.g_idb_ecc_bits,"aw",@nobits
	.set	.LANCHOR145,. + 0
	.type	g_idb_ecc_bits, %object
	.size	g_idb_ecc_bits, 1
g_idb_ecc_bits:
	.zero	1
	.section	.bss.g_idb_slc_mode_enable,"aw",@nobits
	.set	.LANCHOR146,. + 0
	.type	g_idb_slc_mode_enable, %object
	.size	g_idb_slc_mode_enable, 1
g_idb_slc_mode_enable:
	.zero	1
	.section	.bss.g_lsb_page_tbl,"aw",@nobits
	.align	2
	.set	.LANCHOR14,. + 0
	.type	g_lsb_page_tbl, %object
	.size	g_lsb_page_tbl, 512
g_lsb_page_tbl:
	.zero	512
	.section	.bss.g_maxRegNum,"aw",@nobits
	.set	.LANCHOR4,. + 0
	.type	g_maxRegNum, %object
	.size	g_maxRegNum, 1
g_maxRegNum:
	.zero	1
	.section	.bss.g_maxRetryCount,"aw",@nobits
	.set	.LANCHOR113,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.zero	1
	.section	.bss.g_msb_page_tbl,"aw",@nobits
	.align	2
	.set	.LANCHOR96,. + 0
	.type	g_msb_page_tbl, %object
	.size	g_msb_page_tbl, 1024
g_msb_page_tbl:
	.zero	1024
	.section	.bss.g_nand_max_die,"aw",@nobits
	.set	.LANCHOR8,. + 0
	.type	g_nand_max_die, %object
	.size	g_nand_max_die, 1
g_nand_max_die:
	.zero	1
	.section	.bss.g_nandc_ecc_bits,"aw",@nobits
	.set	.LANCHOR27,. + 0
	.type	g_nandc_ecc_bits, %object
	.size	g_nandc_ecc_bits, 1
g_nandc_ecc_bits:
	.zero	1
	.section	.bss.g_nandc_v6_master_info,"aw",@nobits
	.align	3
	.set	.LANCHOR30,. + 0
	.type	g_nandc_v6_master_info, %object
	.size	g_nandc_v6_master_info, 40
g_nandc_v6_master_info:
	.zero	40
	.section	.bss.g_nandc_ver,"aw",@nobits
	.set	.LANCHOR7,. + 0
	.type	g_nandc_ver, %object
	.size	g_nandc_ver, 1
g_nandc_ver:
	.zero	1
	.section	.bss.g_pm_spare,"aw",@nobits
	.align	3
	.set	.LANCHOR141,. + 0
	.type	g_pm_spare, %object
	.size	g_pm_spare, 8
g_pm_spare:
	.zero	8
	.section	.bss.g_retryMode,"aw",@nobits
	.set	.LANCHOR2,. + 0
	.type	g_retryMode, %object
	.size	g_retryMode, 1
g_retryMode:
	.zero	1
	.section	.bss.g_slc_mode_addr2,"aw",@nobits
	.set	.LANCHOR12,. + 0
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
	.set	.LANCHOR97,. + 0
	.type	g_slc_page_num, %object
	.size	g_slc_page_num, 2
g_slc_page_num:
	.zero	2
	.section	.bss.g_totle_phy_block,"aw",@nobits
	.align	1
	.set	.LANCHOR99,. + 0
	.type	g_totle_phy_block, %object
	.size	g_totle_phy_block, 2
g_totle_phy_block:
	.zero	2
	.section	.bss.gc_des_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR109,. + 0
	.type	gc_des_ppa_tbl, %object
	.size	gc_des_ppa_tbl, 8
gc_des_ppa_tbl:
	.zero	8
	.section	.bss.gc_lpa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR107,. + 0
	.type	gc_lpa_tbl, %object
	.size	gc_lpa_tbl, 8
gc_lpa_tbl:
	.zero	8
	.section	.bss.gc_mode,"aw",@nobits
	.set	.LANCHOR67,. + 0
	.type	gc_mode, %object
	.size	gc_mode, 1
gc_mode:
	.zero	1
	.section	.bss.gc_page_buf_id,"aw",@nobits
	.align	3
	.set	.LANCHOR65,. + 0
	.type	gc_page_buf_id, %object
	.size	gc_page_buf_id, 8
gc_page_buf_id:
	.zero	8
	.section	.bss.gc_pre_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR108,. + 0
	.type	gc_pre_ppa_tbl, %object
	.size	gc_pre_ppa_tbl, 8
gc_pre_ppa_tbl:
	.zero	8
	.section	.bss.gc_slc_mode_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR57,. + 0
	.type	gc_slc_mode_vpn_th, %object
	.size	gc_slc_mode_vpn_th, 2
gc_slc_mode_vpn_th:
	.zero	2
	.section	.bss.gc_state,"aw",@nobits
	.set	.LANCHOR104,. + 0
	.type	gc_state, %object
	.size	gc_state, 1
gc_state:
	.zero	1
	.section	.bss.gc_tlc_mode_slc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR105,. + 0
	.type	gc_tlc_mode_slc_vpn_th, %object
	.size	gc_tlc_mode_slc_vpn_th, 2
gc_tlc_mode_slc_vpn_th:
	.zero	2
	.section	.bss.gc_tlc_mode_tlc_vpn_th,"aw",@nobits
	.align	1
	.set	.LANCHOR106,. + 0
	.type	gc_tlc_mode_tlc_vpn_th, %object
	.size	gc_tlc_mode_tlc_vpn_th, 2
gc_tlc_mode_tlc_vpn_th:
	.zero	2
	.section	.bss.gc_valid_page_ppa,"aw",@nobits
	.align	3
	.set	.LANCHOR61,. + 0
	.type	gc_valid_page_ppa, %object
	.size	gc_valid_page_ppa, 8
gc_valid_page_ppa:
	.zero	8
	.section	.bss.gpNandParaInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR34,. + 0
	.type	gpNandParaInfo, %object
	.size	gpNandParaInfo, 8
gpNandParaInfo:
	.zero	8
	.section	.bss.gp_blk_info,"aw",@nobits
	.align	3
	.set	.LANCHOR59,. + 0
	.type	gp_blk_info, %object
	.size	gp_blk_info, 8
gp_blk_info:
	.zero	8
	.section	.bss.gp_flash_info,"aw",@nobits
	.align	3
	.set	.LANCHOR5,. + 0
	.type	gp_flash_info, %object
	.size	gp_flash_info, 8
gp_flash_info:
	.zero	8
	.section	.bss.gp_ftl_ext_info,"aw",@nobits
	.align	3
	.set	.LANCHOR60,. + 0
	.type	gp_ftl_ext_info, %object
	.size	gp_ftl_ext_info, 8
gp_ftl_ext_info:
	.zero	8
	.section	.bss.gp_ftl_info,"aw",@nobits
	.align	3
	.set	.LANCHOR46,. + 0
	.type	gp_ftl_info, %object
	.size	gp_ftl_info, 8
gp_ftl_info:
	.zero	8
	.section	.bss.gp_nandc,"aw",@nobits
	.align	3
	.set	.LANCHOR6,. + 0
	.type	gp_nandc, %object
	.size	gp_nandc, 8
gp_nandc:
	.zero	8
	.section	.bss.lpa_hash,"aw",@nobits
	.align	3
	.set	.LANCHOR81,. + 0
	.type	lpa_hash, %object
	.size	lpa_hash, 512
lpa_hash:
	.zero	512
	.section	.bss.lpa_hash_index,"aw",@nobits
	.align	3
	.set	.LANCHOR83,. + 0
	.type	lpa_hash_index, %object
	.size	lpa_hash_index, 8
lpa_hash_index:
	.zero	8
	.section	.bss.nandc_hw_seed,"aw",@nobits
	.set	.LANCHOR28,. + 0
	.type	nandc_hw_seed, %object
	.size	nandc_hw_seed, 1
nandc_hw_seed:
	.zero	1
	.section	.bss.nandc_randomizer_en,"aw",@nobits
	.set	.LANCHOR29,. + 0
	.type	nandc_randomizer_en, %object
	.size	nandc_randomizer_en, 1
nandc_randomizer_en:
	.zero	1
	.section	.bss.p_free_buf_head,"aw",@nobits
	.set	.LANCHOR37,. + 0
	.type	p_free_buf_head, %object
	.size	p_free_buf_head, 1
p_free_buf_head:
	.zero	1
	.section	.bss.p_read_ahead_ext_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR50,. + 0
	.type	p_read_ahead_ext_buf, %object
	.size	p_read_ahead_ext_buf, 8
p_read_ahead_ext_buf:
	.zero	8
	.section	.bss.pm_gc_enable,"aw",@nobits
	.align	2
	.set	.LANCHOR91,. + 0
	.type	pm_gc_enable, %object
	.size	pm_gc_enable, 4
pm_gc_enable:
	.zero	4
	.section	.bss.pm_last_load_ram_id,"aw",@nobits
	.set	.LANCHOR151,. + 0
	.type	pm_last_load_ram_id, %object
	.size	pm_last_load_ram_id, 1
pm_last_load_ram_id:
	.zero	1
	.section	.bss.pm_last_update_ram_id,"aw",@nobits
	.set	.LANCHOR94,. + 0
	.type	pm_last_update_ram_id, %object
	.size	pm_last_update_ram_id, 1
pm_last_update_ram_id:
	.zero	1
	.section	.bss.pm_ram_info,"aw",@nobits
	.align	3
	.set	.LANCHOR93,. + 0
	.type	pm_ram_info, %object
	.size	pm_ram_info, 512
pm_ram_info:
	.zero	512
	.section	.bss.read_ahead_lpa,"aw",@nobits
	.align	2
	.set	.LANCHOR49,. + 0
	.type	read_ahead_lpa, %object
	.size	read_ahead_lpa, 4
read_ahead_lpa:
	.zero	4
	.section	.bss.sblk_gc_write_completed_queue_head,"aw",@nobits
	.set	.LANCHOR62,. + 0
	.type	sblk_gc_write_completed_queue_head, %object
	.size	sblk_gc_write_completed_queue_head, 1
sblk_gc_write_completed_queue_head:
	.zero	1
	.section	.bss.sblk_queue_head,"aw",@nobits
	.set	.LANCHOR90,. + 0
	.type	sblk_queue_head, %object
	.size	sblk_queue_head, 1
sblk_queue_head:
	.zero	1
	.section	.bss.sblk_read_completed_queue_head,"aw",@nobits
	.set	.LANCHOR51,. + 0
	.type	sblk_read_completed_queue_head, %object
	.size	sblk_read_completed_queue_head, 1
sblk_read_completed_queue_head:
	.zero	1
	.section	.bss.sblk_write_completed_queue_head,"aw",@nobits
	.set	.LANCHOR88,. + 0
	.type	sblk_write_completed_queue_head, %object
	.size	sblk_write_completed_queue_head, 1
sblk_write_completed_queue_head:
	.zero	1
	.section	.bss.write_buf_count,"aw",@nobits
	.set	.LANCHOR43,. + 0
	.type	write_buf_count, %object
	.size	write_buf_count, 1
write_buf_count:
	.zero	1
	.section	.bss.write_buf_head,"aw",@nobits
	.set	.LANCHOR42,. + 0
	.type	write_buf_head, %object
	.size	write_buf_head, 1
write_buf_head:
	.zero	1
	.section	.bss.write_commit_count,"aw",@nobits
	.set	.LANCHOR89,. + 0
	.type	write_commit_count, %object
	.size	write_commit_count, 1
write_commit_count:
	.zero	1
	.section	.bss.write_commit_head,"aw",@nobits
	.set	.LANCHOR127,. + 0
	.type	write_commit_head, %object
	.size	write_commit_head, 1
write_commit_head:
	.zero	1
	.section	.data.NandFlashParaTbl,"aw",@progbits
	.align	3
	.set	.LANCHOR142,. + 0
	.type	NandFlashParaTbl, %object
	.size	NandFlashParaTbl, 768
NandFlashParaTbl:
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
	.byte	60
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
	.byte	2
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
	.byte	2
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
	.byte	2
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
	.byte	0
	.byte	0
	.byte	0
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
	.byte	0
	.byte	0
	.byte	0
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
	.section	.data.NandOptPara,"aw",@progbits
	.align	3
	.set	.LANCHOR143,. + 0
	.type	NandOptPara, %object
	.size	NandOptPara, 128
NandOptPara:
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
	.section	.data.gNandParaInfo,"aw",@progbits
	.align	3
	.set	.LANCHOR19,. + 0
	.type	gNandParaInfo, %object
	.size	gNandParaInfo, 32
gNandParaInfo:
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
	.set	.LANCHOR110,. + 0
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
	.section	.data.sd15_slc_rr,"aw",@progbits
	.align	3
	.set	.LANCHOR18,. + 0
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
	.set	.LANCHOR17,. + 0
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
	.set	.LANCHOR171,. + 0
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
	.set	.LANCHOR22,. + 0
	.type	zftl_debug, %object
	.size	zftl_debug, 4
zftl_debug:
	.word	17476
	.section	.rodata.__func__.10009,"a",@progbits
	.align	3
	.set	.LANCHOR77,. + 0
	.type	__func__.10009, %object
	.size	__func__.10009, 18
__func__.10009:
	.string	"ftl_alloc_sys_blk"
	.section	.rodata.__func__.10019,"a",@progbits
	.align	3
	.set	.LANCHOR78,. + 0
	.type	__func__.10019, %object
	.size	__func__.10019, 17
__func__.10019:
	.string	"ftl_free_sys_blk"
	.section	.rodata.__func__.10053,"a",@progbits
	.align	3
	.set	.LANCHOR155,. + 0
	.type	__func__.10053, %object
	.size	__func__.10053, 14
__func__.10053:
	.string	"ftl_sblk_dump"
	.section	.rodata.__func__.10077,"a",@progbits
	.align	3
	.set	.LANCHOR147,. + 0
	.type	__func__.10077, %object
	.size	__func__.10077, 16
__func__.10077:
	.string	"ftl_sysblk_dump"
	.section	.rodata.__func__.10096,"a",@progbits
	.align	3
	.set	.LANCHOR139,. + 0
	.type	__func__.10096, %object
	.size	__func__.10096, 23
__func__.10096:
	.string	"ftl_open_sblk_recovery"
	.section	.rodata.__func__.10121,"a",@progbits
	.align	3
	.set	.LANCHOR80,. + 0
	.type	__func__.10121, %object
	.size	__func__.10121, 23
__func__.10121:
	.string	"ftl_get_ppa_from_index"
	.section	.rodata.__func__.10142,"a",@progbits
	.align	3
	.set	.LANCHOR166,. + 0
	.type	__func__.10142, %object
	.size	__func__.10142, 19
__func__.10142:
	.string	"ftl_update_l2p_map"
	.section	.rodata.__func__.10161,"a",@progbits
	.align	3
	.set	.LANCHOR84,. + 0
	.type	__func__.10161, %object
	.size	__func__.10161, 22
__func__.10161:
	.string	"ftl_get_new_free_page"
	.section	.rodata.__func__.10172,"a",@progbits
	.align	3
	.set	.LANCHOR85,. + 0
	.type	__func__.10172, %object
	.size	__func__.10172, 22
__func__.10172:
	.string	"ftl_ext_alloc_new_blk"
	.section	.rodata.__func__.10197,"a",@progbits
	.align	3
	.set	.LANCHOR134,. + 0
	.type	__func__.10197, %object
	.size	__func__.10197, 19
__func__.10197:
	.string	"ftl_ext_info_flush"
	.section	.rodata.__func__.10209,"a",@progbits
	.align	3
	.set	.LANCHOR135,. + 0
	.type	__func__.10209, %object
	.size	__func__.10209, 18
__func__.10209:
	.string	"ftl_ext_info_init"
	.section	.rodata.__func__.10254,"a",@progbits
	.align	3
	.set	.LANCHOR136,. + 0
	.type	__func__.10254, %object
	.size	__func__.10254, 15
__func__.10254:
	.string	"ftl_low_format"
	.section	.rodata.__func__.10298,"a",@progbits
	.align	3
	.set	.LANCHOR138,. + 0
	.type	__func__.10298, %object
	.size	__func__.10298, 23
__func__.10298:
	.string	"ftl_re_low_format_test"
	.section	.rodata.__func__.10308,"a",@progbits
	.align	3
	.set	.LANCHOR129,. + 0
	.type	__func__.10308, %object
	.size	__func__.10308, 14
__func__.10308:
	.string	"ftl_prog_page"
	.section	.rodata.__func__.10483,"a",@progbits
	.align	3
	.set	.LANCHOR126,. + 0
	.type	__func__.10483, %object
	.size	__func__.10483, 15
__func__.10483:
	.string	"sblk_prog_page"
	.section	.rodata.__func__.10542,"a",@progbits
	.align	3
	.set	.LANCHOR148,. + 0
	.type	__func__.10542, %object
	.size	__func__.10542, 16
__func__.10542:
	.string	"load_l2p_region"
	.section	.rodata.__func__.10556,"a",@progbits
	.align	3
	.set	.LANCHOR102,. + 0
	.type	__func__.10556, %object
	.size	__func__.10556, 13
__func__.10556:
	.string	"pm_free_sblk"
	.section	.rodata.__func__.10576,"a",@progbits
	.align	3
	.set	.LANCHOR150,. + 0
	.type	__func__.10576, %object
	.size	__func__.10576, 6
__func__.10576:
	.string	"pm_gc"
	.section	.rodata.__func__.10592,"a",@progbits
	.align	3
	.set	.LANCHOR92,. + 0
	.type	__func__.10592, %object
	.size	__func__.10592, 17
__func__.10592:
	.string	"pm_alloc_new_blk"
	.section	.rodata.__func__.10602,"a",@progbits
	.align	3
	.set	.LANCHOR140,. + 0
	.type	__func__.10602, %object
	.size	__func__.10602, 14
__func__.10602:
	.string	"pm_write_page"
	.section	.rodata.__func__.10620,"a",@progbits
	.align	3
	.set	.LANCHOR95,. + 0
	.type	__func__.10620, %object
	.size	__func__.10620, 21
__func__.10620:
	.string	"pm_select_ram_region"
	.section	.rodata.__func__.8406,"a",@progbits
	.align	3
	.set	.LANCHOR114,. + 0
	.type	__func__.8406, %object
	.size	__func__.8406, 19
__func__.8406:
	.string	"flash_read_page_en"
	.section	.rodata.__func__.8435,"a",@progbits
	.align	3
	.set	.LANCHOR128,. + 0
	.type	__func__.8435, %object
	.size	__func__.8435, 19
__func__.8435:
	.string	"flash_prog_page_en"
	.section	.rodata.__func__.8450,"a",@progbits
	.align	3
	.set	.LANCHOR21,. + 0
	.type	__func__.8450, %object
	.size	__func__.8450, 26
__func__.8450:
	.string	"flash_erase_duplane_block"
	.section	.rodata.__func__.8461,"a",@progbits
	.align	3
	.set	.LANCHOR24,. + 0
	.type	__func__.8461, %object
	.size	__func__.8461, 21
__func__.8461:
	.string	"flash_erase_block_en"
	.section	.rodata.__func__.8475,"a",@progbits
	.align	3
	.set	.LANCHOR9,. + 0
	.type	__func__.8475, %object
	.size	__func__.8475, 28
__func__.8475:
	.string	"flash_wait_device_ready_raw"
	.section	.rodata.__func__.8500,"a",@progbits
	.align	3
	.set	.LANCHOR124,. + 0
	.type	__func__.8500, %object
	.size	__func__.8500, 26
__func__.8500:
	.string	"flash_start_tlc_page_prog"
	.section	.rodata.__func__.8513,"a",@progbits
	.align	3
	.set	.LANCHOR125,. + 0
	.type	__func__.8513, %object
	.size	__func__.8513, 22
__func__.8513:
	.string	"flash_start_page_prog"
	.section	.rodata.__func__.8526,"a",@progbits
	.align	3
	.set	.LANCHOR33,. + 0
	.type	__func__.8526, %object
	.size	__func__.8526, 22
__func__.8526:
	.string	"flash_start_page_read"
	.section	.rodata.__func__.8541,"a",@progbits
	.align	3
	.set	.LANCHOR120,. + 0
	.type	__func__.8541, %object
	.size	__func__.8541, 25
__func__.8541:
	.string	"flash_complete_page_read"
	.section	.rodata.__func__.9099,"a",@progbits
	.align	3
	.set	.LANCHOR39,. + 0
	.type	__func__.9099, %object
	.size	__func__.9099, 13
__func__.9099:
	.string	"buf_add_tail"
	.section	.rodata.__func__.9112,"a",@progbits
	.align	3
	.set	.LANCHOR40,. + 0
	.type	__func__.9112, %object
	.size	__func__.9112, 10
__func__.9112:
	.string	"buf_alloc"
	.section	.rodata.__func__.9126,"a",@progbits
	.align	3
	.set	.LANCHOR41,. + 0
	.type	__func__.9126, %object
	.size	__func__.9126, 16
__func__.9126:
	.string	"buf_remove_free"
	.section	.rodata.__func__.9234,"a",@progbits
	.align	3
	.set	.LANCHOR100,. + 0
	.type	__func__.9234, %object
	.size	__func__.9234, 17
__func__.9234:
	.string	"lpa_rebuild_hash"
	.section	.rodata.__func__.9286,"a",@progbits
	.align	3
	.set	.LANCHOR167,. + 0
	.type	__func__.9286, %object
	.size	__func__.9286, 17
__func__.9286:
	.string	"ftl_write_commit"
	.section	.rodata.__func__.9297,"a",@progbits
	.align	3
	.set	.LANCHOR44,. + 0
	.type	__func__.9297, %object
	.size	__func__.9297, 14
__func__.9297:
	.string	"ftl_write_buf"
	.section	.rodata.__func__.9345,"a",@progbits
	.align	3
	.set	.LANCHOR152,. + 0
	.type	__func__.9345, %object
	.size	__func__.9345, 15
__func__.9345:
	.string	"ftl_read_ahead"
	.section	.rodata.__func__.9353,"a",@progbits
	.align	3
	.set	.LANCHOR48,. + 0
	.type	__func__.9353, %object
	.size	__func__.9353, 13
__func__.9353:
	.string	"ftl_read_buf"
	.section	.rodata.__func__.9391,"a",@progbits
	.align	3
	.set	.LANCHOR157,. + 0
	.type	__func__.9391, %object
	.size	__func__.9391, 9
__func__.9391:
	.string	"ftl_read"
	.section	.rodata.__func__.9417,"a",@progbits
	.align	3
	.set	.LANCHOR169,. + 0
	.type	__func__.9417, %object
	.size	__func__.9417, 12
__func__.9417:
	.string	"ftl_discard"
	.section	.rodata.__func__.9438,"a",@progbits
	.align	3
	.set	.LANCHOR158,. + 0
	.type	__func__.9438, %object
	.size	__func__.9438, 10
__func__.9438:
	.string	"vpn_check"
	.section	.rodata.__func__.9463,"a",@progbits
	.align	3
	.set	.LANCHOR159,. + 0
	.type	__func__.9463, %object
	.size	__func__.9463, 15
__func__.9463:
	.string	"ftl_info_check"
	.section	.rodata.__func__.9572,"a",@progbits
	.align	3
	.set	.LANCHOR55,. + 0
	.type	__func__.9572, %object
	.size	__func__.9572, 12
__func__.9572:
	.string	"gc_add_sblk"
	.section	.rodata.__func__.9615,"a",@progbits
	.align	3
	.set	.LANCHOR122,. + 0
	.type	__func__.9615, %object
	.size	__func__.9615, 21
__func__.9615:
	.string	"gc_check_data_one_wl"
	.section	.rodata.__func__.9649,"a",@progbits
	.align	3
	.set	.LANCHOR153,. + 0
	.type	__func__.9649, %object
	.size	__func__.9649, 22
__func__.9649:
	.string	"gc_update_l2p_map_new"
	.section	.rodata.__func__.9662,"a",@progbits
	.align	3
	.set	.LANCHOR63,. + 0
	.type	__func__.9662, %object
	.size	__func__.9662, 19
__func__.9662:
	.string	"gc_write_completed"
	.section	.rodata.__func__.9691,"a",@progbits
	.align	3
	.set	.LANCHOR170,. + 0
	.type	__func__.9691, %object
	.size	__func__.9691, 16
__func__.9691:
	.string	"gc_do_copy_back"
	.section	.rodata.__func__.9713,"a",@progbits
	.align	3
	.set	.LANCHOR73,. + 0
	.type	__func__.9713, %object
	.size	__func__.9713, 16
__func__.9713:
	.string	"gc_free_src_blk"
	.section	.rodata.__func__.9758,"a",@progbits
	.align	3
	.set	.LANCHOR160,. + 0
	.type	__func__.9758, %object
	.size	__func__.9758, 16
__func__.9758:
	.string	"gc_scan_src_blk"
	.section	.rodata.__func__.9790,"a",@progbits
	.align	3
	.set	.LANCHOR156,. + 0
	.type	__func__.9790, %object
	.size	__func__.9790, 18
__func__.9790:
	.string	"gc_search_src_blk"
	.section	.rodata.__func__.9806,"a",@progbits
	.align	3
	.set	.LANCHOR154,. + 0
	.type	__func__.9806, %object
	.size	__func__.9806, 20
__func__.9806:
	.string	"gc_scan_static_data"
	.section	.rodata.__func__.9867,"a",@progbits
	.align	3
	.set	.LANCHOR172,. + 0
	.type	__func__.9867, %object
	.size	__func__.9867, 6
__func__.9867:
	.string	"do_gc"
	.section	.rodata.__func__.9928,"a",@progbits
	.align	3
	.set	.LANCHOR132,. + 0
	.type	__func__.9928, %object
	.size	__func__.9928, 15
__func__.9928:
	.string	"ftl_info_flush"
	.section	.rodata.__func__.9977,"a",@progbits
	.align	3
	.set	.LANCHOR72,. + 0
	.type	__func__.9977, %object
	.size	__func__.9977, 14
__func__.9977:
	.string	"ftl_free_sblk"
	.section	.rodata.do_gc.str1.1,"aMS",@progbits,1
.LC153:
	.string	"gc %d: %d %d %d %d %d %d\n"
.LC154:
	.string	"GC_STATE_SCAN_ALL_PAGE = %x, vpn0 = %d, vpn1 = %d\n"
.LC155:
	.string	"gc free %x, %d\n"
	.section	.rodata.dump_ftl_info.str1.1,"aMS",@progbits,1
.LC81:
	.string	"g_ftl_info_blk blk:0x%x, index:0x%x, page:0x%x\n"
.LC82:
	.string	"ftl_ext_info_blk blk:0x%x, page:0x%x\n"
.LC83:
	.string	"ac_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC84:
	.string	"tmp_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC85:
	.string	"gc_blk:0x%x, page:0x%x, index:0x%x, free:0x%x, page_index:0x%x\n"
.LC86:
	.string	"lpa:"
.LC87:
	.string	"vpn:"
.LC88:
	.string	"sblk:"
.LC89:
	.string	"lpa_hash:"
.LC90:
	.string	"lpa_hash_index:"
	.section	.rodata.dump_sblk_queue.str1.1,"aMS",@progbits,1
.LC24:
	.string	"dump_sblk_queue: %d\n"
.LC25:
	.string	"buf id= %d state = %d ppa = %x\n"
	.section	.rodata.flash_complete_page_read.str1.1,"aMS",@progbits,1
.LC54:
	.string	"flash_complete_page_read %x %x error_ecc %d %d\n"
	.section	.rodata.flash_ddr_tunning_read.str1.1,"aMS",@progbits,1
.LC48:
	.string	"%d flash_ddr_tunning_read %x ecc=%d\n"
.LC49:
	.string	"sync para %d\n"
.LC50:
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
.LC53:
	.string	"no sys info %x\n"
	.section	.rodata.flash_info_flush.str1.1,"aMS",@progbits,1
.LC77:
	.string	"finfo:"
.LC78:
	.string	"flash_info_flush id = %x, page = %x\n"
.LC79:
	.string	"sys_info_flush error:%x\n"
	.section	.rodata.flash_mask_bad_block.str1.1,"aMS",@progbits,1
.LC6:
	.string	"flash_mask_bad_block %d %d\n"
	.section	.rodata.flash_prog_page.str1.1,"aMS",@progbits,1
.LC57:
	.string	"flash_prog_page %x %x %x\n"
	.section	.rodata.flash_prog_page_en.str1.1,"aMS",@progbits,1
.LC59:
	.string	"flash_prog_page_en:%x %x\n"
.LC60:
	.string	"spare"
.LC61:
	.string	"data"
.LC62:
	.string	"write error: %x\n"
	.section	.rodata.flash_read_page.str1.1,"aMS",@progbits,1
.LC41:
	.string	"flash_read_page %x %x %x\n"
	.section	.rodata.flash_read_page_en.str1.1,"aMS",@progbits,1
.LC51:
	.string	"flash_read_page_en %x %x\n"
.LC52:
	.string	"flash_read_page_en %x %x error_ecc %d %d\n"
	.section	.rodata.flash_wait_device_ready_raw.str1.1,"aMS",@progbits,1
.LC0:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
	.section	.rodata.ftl_alloc_sblk.str1.1,"aMS",@progbits,1
.LC14:
	.string	"ftl_alloc_sblk %x, %d %d %d\n"
	.section	.rodata.ftl_discard.str1.1,"aMS",@progbits,1
.LC148:
	.string	"ftl_discard:(%x, %x, %x, %x)\n"
	.section	.rodata.ftl_info_blk_init.str1.1,"aMS",@progbits,1
.LC65:
	.string	"%d %x @%d %x\n"
.LC66:
	.string	"ftl_info_blk_init %d %d %x\n"
	.section	.rodata.ftl_info_check.str1.1,"aMS",@progbits,1
.LC122:
	.string	"free blk vpn error: %x %x\n"
.LC123:
	.string	"data blk: %d %d %d\n"
.LC124:
	.string	"free blk: %d %d %d\n"
	.section	.rodata.ftl_info_flush.str1.1,"aMS",@progbits,1
.LC64:
	.string	"g_ftl_info_blk blk = %x, page = %x version = %d\n"
	.section	.rodata.ftl_init.str1.1,"aMS",@progbits,1
.LC139:
	.string	"FTL version: 6.0.3 20180211"
.LC140:
	.string	"gp_ftl_ext_info %p %p %p\n"
.LC141:
	.string	"flash info size: %d %d %d\n"
	.section	.rodata.ftl_low_format.str1.1,"aMS",@progbits,1
.LC67:
	.string	"low format %d %d %d %d\n"
	.section	.rodata.ftl_mask_bad_block.str1.1,"aMS",@progbits,1
.LC19:
	.string	"mask bad block:cs %x block: %x\n"
	.section	.rodata.ftl_open_sblk_recovery.str1.1,"aMS",@progbits,1
.LC69:
	.string	"saved_active_page  = %x\n"
.LC70:
	.string	"saved_active_plane = %x\n"
.LC71:
	.string	"sblk = %x\n"
.LC72:
	.string	"phy_blk = %x %x\n"
.LC73:
	.string	"blk= %x, page=%x, ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC74:
	.string	"sblk = %x, vpn0 = %d, vpn1 = %d\n"
.LC75:
	.string	"dump write = %x\n"
	.section	.rodata.ftl_re_low_format_test.str1.1,"aMS",@progbits,1
.LC68:
	.string	"re low formaet %d\n"
	.section	.rodata.ftl_read.str1.1,"aMS",@progbits,1
.LC114:
	.string	"ftl_read refresh =%x, lpa = %x, ppa= %x\n"
	.section	.rodata.ftl_read_ahead.str1.1,"aMS",@progbits,1
.LC100:
	.string	"ftl_read_ahead refresh =%x, lpa = %x, ppa= %x\n"
.LC101:
	.string	"id=%d, lpa = %x, ppa = %x spare = %x %x %x %x\n"
	.section	.rodata.ftl_sblk_dump.str1.1,"aMS",@progbits,1
.LC107:
	.string	"ftl_sblk_dump = %x %x %x %x\n"
.LC108:
	.string	"page_addr = %x, lpa=%x vpn = %d\n"
.LC109:
	.string	"index= %x, lpa=%x\n"
.LC110:
	.string	"block = %x, vpn=%x check vpn = %d\n"
	.section	.rodata.ftl_scan_all_data.str1.1,"aMS",@progbits,1
.LC127:
	.string	"ftl_scan_all_data = %x\n"
.LC128:
	.string	"scan lpa = %x ppa= %x\n"
.LC129:
	.string	"lba = %x,addr= %x, ststus = %x, spare= %x %x %x %x data=%x %x\n"
.LC130:
	.string	"lba = %x, id= %x, index = %x hash ppa = %x\n"
.LC131:
	.string	"0pm:"
.LC132:
	.string	"1pm:"
	.section	.rodata.ftl_sysblk_dump.str1.1,"aMS",@progbits,1
.LC80:
	.string	"l2p:"
	.section	.rodata.ftl_test_block.str1.1,"aMS",@progbits,1
.LC63:
	.string	"low format %d\n"
	.section	.rodata.ftl_update_l2p_map.str1.1,"aMS",@progbits,1
.LC143:
	.string	"ftl_update_l2p_map: %x %x %x\n"
.LC144:
	.string	"ftl_update_l2p_map"
.LC145:
	.string	"lpa_tbl:"
.LC146:
	.string	"sblk %x vpn: %d %d\n"
	.section	.rodata.ftl_vpn_decrement.str1.1,"aMS",@progbits,1
.LC17:
	.string	"ftl_vpn_decrement %x = %d\n"
	.section	.rodata.ftl_write_commit.str1.1,"aMS",@progbits,1
.LC147:
	.string	"%d read error: ppa:%x, lpa:%x, status:%x\n"
	.section	.rodata.ftl_write_completed.str1.1,"aMS",@progbits,1
.LC18:
	.string	"ftl prog error =%x, lpa = %x, ppa= %x\n"
	.section	.rodata.gc_add_sblk.str1.1,"aMS",@progbits,1
.LC7:
	.string	"gc_add_sblk = %d, %d, %d, %d, %d, %d\n"
	.section	.rodata.gc_check_data_one_wl.str1.1,"aMS",@progbits,1
.LC56:
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
.LC15:
	.string	"gc_free_src_blk = %x, vpn = %d\n"
.LC16:
	.string	"gc_free_src_blk %x, %d\n"
	.section	.rodata.gc_free_temp_buf.str1.1,"aMS",@progbits,1
.LC10:
	.string	"%d gc_free_temp_buf buf id= %x\n"
	.section	.rodata.gc_recovery.str1.1,"aMS",@progbits,1
.LC133:
	.string	"ppa = %x, status = %x, data:%x %x %x %x, spare: %x %x %x %x\n"
.LC134:
	.string	"gc_lpa:"
.LC135:
	.string	"gc_ppa:"
.LC136:
	.string	"ppa = %x, status = %x, %x %x spare: %x %x %x %x\n"
.LC137:
	.string	"gc_recovery"
.LC138:
	.string	"gc_recovery: %x vpn = %x\n"
	.section	.rodata.gc_scan_src_blk.str1.1,"aMS",@progbits,1
.LC125:
	.string	"gc_scan_src_blk = %x, vpn = %d\n"
.LC126:
	.string	"gc_scan_src_blk = %x, s vpn0 = %d, c vpn1 = %d\n"
	.section	.rodata.gc_search_src_blk.str1.1,"aMS",@progbits,1
.LC111:
	.string	"gc_search_src_blk = %d, %d, %d\n"
.LC112:
	.string	"vpn gc = %d, id = %d\n"
.LC113:
	.string	"gc_search_src_blk count= %d\n"
	.section	.rodata.gc_static_wearleveling.str1.1,"aMS",@progbits,1
.LC11:
	.string	"gc_static_wearleveling: slc blk: %d, tlc blk: %d avg slc ec: %d, avg tlc ec: %d \n"
.LC12:
	.string	"gc_static_wearleveling: min slc ec: %d, min tlc ec: %d max slc ec: %d, max tlc ec: %d \n"
	.section	.rodata.gc_update_l2p_map_new.str1.1,"aMS",@progbits,1
.LC102:
	.string	"gc_update_l2p_map_new sblk %x\n"
.LC103:
	.string	"gc_update_l2p_map_new: %x %x %x\n"
.LC104:
	.string	"0lpa: %x %x %x\n"
.LC105:
	.string	"lpa: %x %x %x\n"
.LC106:
	.string	"gc_update_l2p_map_new: %x vpn = %x vpn1 = %x done\n"
	.section	.rodata.gc_write_completed.str1.1,"aMS",@progbits,1
.LC8:
	.string	"status: %x, ppa: %x\n"
.LC9:
	.string	"gc_write_completed: %x  %x  %x %x\n"
	.section	.rodata.hynix_get_read_retry_default.str1.1,"aMS",@progbits,1
.LC33:
	.string	"otp error! %d"
.LC34:
	.string	"rr"
	.section	.rodata.hynix_read_retrial.str1.1,"aMS",@progbits,1
.LC47:
	.string	"hynix RR %d row=%x, count %d, status=%d\n"
	.section	.rodata.load_l2p_region.str1.1,"aMS",@progbits,1
.LC92:
	.string	"region_id = %d, pm_max_region = %d\n"
.LC93:
	.string	"load_l2p_region = %x,%x,%x, %x\n"
.LC94:
	.string	"pm_ppa:"
.LC95:
	.string	"data:"
.LC96:
	.string	"spare:"
	.section	.rodata.lpa_rebuild_hash.str1.1,"aMS",@progbits,1
.LC28:
	.string	"%s %d %d\n"
	.section	.rodata.micron_read_retrial.str1.1,"aMS",@progbits,1
.LC42:
	.string	"micron %d row=%x,count %d,status=%d\n"
.LC43:
	.string	"micron RR %d row=%x,count %d,status=%d\n"
	.section	.rodata.nandc_xfer.str1.1,"aMS",@progbits,1
.LC39:
	.string	"dqs data abort %x\n"
.LC40:
	.string	"xfer error %x\n"
	.section	.rodata.nandc_xfer_done.str1.1,"aMS",@progbits,1
.LC35:
	.string	"%d mtrans_cnt = %d page_num = %d\n"
.LC36:
	.string	"nandc:"
.LC37:
	.string	"%d flReg.d32=%x %x\n"
.LC38:
	.string	"nandc_xfer_done read error %x\n"
	.section	.rodata.pm_alloc_new_blk.str1.1,"aMS",@progbits,1
.LC26:
	.string	"blk %x is bad block\n"
.LC27:
	.string	"pm_alloc_new_blk: %x %x %x %x\n"
	.section	.rodata.pm_init.str1.1,"aMS",@progbits,1
.LC97:
	.string	"pm_init posr %x %x %x\n"
.LC98:
	.string	"pm_init recovery %x %x %x\n"
	.section	.rodata.pm_log2phys.str1.1,"aMS",@progbits,1
.LC99:
	.string	"pm_log2phys  lpn = %d, max lpn = %d\n"
	.section	.rodata.pm_ppa_update_check.str1.1,"aMS",@progbits,1
.LC91:
	.string	"%s w error lpn = %x, max ppa = %d\n"
	.section	.rodata.pm_write_page.str1.1,"aMS",@progbits,1
.LC76:
	.string	"pm_write_page write error: %x\n"
	.section	.rodata.print_ftl_debug_info.str1.1,"aMS",@progbits,1
.LC20:
	.string	"free blk: s:%x,t:%x,m:%x, data blk:s:%x,%x,t%x vpn: s:%x t:%x\n"
.LC21:
	.string	"totle w: %d MB,r: %d MB %d dv:0x%X,poc:%d\n"
.LC22:
	.string	"gc xlc page: %d,gc slc page: %d, tmp w: %d MB\n"
.LC23:
	.string	"slc ec: %d,%d,%d,%d,%d,tlc ec: %d,%d,%d,%d,%d\n"
	.section	.rodata.print_gc_debug_info.str1.1,"aMS",@progbits,1
.LC13:
	.string	"gc: b:%x,p:%x,i:%x; free buf=%d %d\n"
	.section	.rodata.queue_wait_first_req_completed.str1.1,"aMS",@progbits,1
.LC55:
	.string	"set buf %d,status = %x, ppa = %x lun state = %d\n"
	.section	.rodata.random_seed,"a",@progbits
	.align	3
	.set	.LANCHOR32,. + 0
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
.LC142:
	.string	"ftl_init %x\n"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",@progbits,1
.LC29:
	.string	"%s 0x%x:"
.LC30:
	.string	"%x "
.LC31:
	.string	""
.LC32:
	.string	"%s\n"
	.section	.rodata.sblk_prog_page.str1.1,"aMS",@progbits,1
.LC58:
	.string	"sblk_prog_page ppa = %x, count = %d\n"
	.section	.rodata.toshiba_15ref_value,"a",@progbits
	.align	3
	.set	.LANCHOR0,. + 0
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
	.set	.LANCHOR16,. + 0
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
	.set	.LANCHOR15,. + 0
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
	.byte	-9
	.byte	-12
	.byte	-9
	.byte	-7
	.byte	-13
	.byte	-12
	.byte	-7
	.byte	5
	.byte	-2
	.byte	-1
	.byte	0
	.byte	-3
	.byte	-2
	.byte	6
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
.LC44:
	.string	"toshiba SRR %d row=%x, status=%d\n"
.LC45:
	.string	"toshiba TRR %d row=%x, status=%d\n"
.LC46:
	.string	"toshiba RR %d row=%x,count %d,status=%d\n"
	.section	.rodata.toshiba_A19ref_value,"a",@progbits
	.align	3
	.set	.LANCHOR1,. + 0
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
	.set	.LANCHOR3,. + 0
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
.LC115:
	.string	"acblk = %x, tempblk = %x, gc_des = %x\n"
.LC116:
	.string	"acblk = %x, free page = %x, vpn = %x %x\n"
.LC117:
	.string	"tmp_blk = %x, free page = %x, vpn = %x %x\n"
.LC118:
	.string	"vpn_check lpa = %x, ppa = %x, blk = %x\n"
.LC119:
	.string	"l2p"
.LC120:
	.string	"vpn_check %x = c %x  s %x function: %x\n"
.LC121:
	.string	"vpn_check blk = %x fix vpc\n"
	.hidden	free
