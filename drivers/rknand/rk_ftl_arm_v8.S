/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2018-09-05
 */
	.arch armv8-a
	.file	"rk_ftl_arm_v8.c"
	.section	.text.ftl_set_blk_mode.part.10,"ax",@progbits
	.align	2
	.type	ftl_set_blk_mode.part.10, %function
ftl_set_blk_mode.part.10:
	and	w0, w0, 65535
	adrp	x2, .LANCHOR0
	ubfx	x1, x0, 5, 11
	ldr	x3, [x2, #:lo12:.LANCHOR0]
	lsl	x1, x1, 2
	and	w0, w0, 31
	mov	w2, 1
	lsl	w2, w2, w0
	ldr	w0, [x3, x1]
	orr	w0, w0, w2
	str	w0, [x3, x1]
	ret
	.size	ftl_set_blk_mode.part.10, .-ftl_set_blk_mode.part.10
	.section	.text.FlashMemCmp8,"ax",@progbits
	.align	2
	.global	FlashMemCmp8
	.type	FlashMemCmp8, %function
FlashMemCmp8:
	adrp	x3, .LANCHOR1
	ldrb	w3, [x3, #:lo12:.LANCHOR1]
	cbz	w3, .L7
	ldrb	w4, [x0, 1]
	ldrb	w3, [x1, 1]
	cmp	w4, w3
	beq	.L8
.L7:
	mov	x3, 0
.L5:
	mov	w4, w3
	cmp	w3, w2
	bcc	.L6
.L8:
	mov	w0, 0
	ret
.L6:
	ldrb	w5, [x0, x3]
	add	x3, x3, 1
	add	x6, x1, x3
	ldrb	w6, [x6, -1]
	cmp	w6, w5
	beq	.L5
	add	w0, w4, 1
	ret
	.size	FlashMemCmp8, .-FlashMemCmp8
	.section	.text.FlashRsvdBlkChk,"ax",@progbits
	.align	2
	.global	FlashRsvdBlkChk
	.type	FlashRsvdBlkChk, %function
FlashRsvdBlkChk:
	adrp	x2, .LANCHOR2
	adrp	x3, .LANCHOR3
	and	w0, w0, 255
	ldrb	w2, [x2, #:lo12:.LANCHOR2]
	ldr	w3, [x3, #:lo12:.LANCHOR3]
	mul	w2, w2, w3
	cmp	w2, w1
	bls	.L12
	cmp	w0, 0
	cset	w0, ne
	ret
.L12:
	mov	w0, 1
	ret
	.size	FlashRsvdBlkChk, .-FlashRsvdBlkChk
	.section	.text.FlashGetRandomizer,"ax",@progbits
	.align	2
	.global	FlashGetRandomizer
	.type	FlashGetRandomizer, %function
FlashGetRandomizer:
	and	x3, x1, 127
	adrp	x2, .LANCHOR4
	add	x2, x2, :lo12:.LANCHOR4
	ldrh	w4, [x2, x3, lsl 1]
	adrp	x2, .LANCHOR5
	ldrb	w2, [x2, #:lo12:.LANCHOR5]
	cbz	w2, .L21
	stp	x29, x30, [sp, -16]!
	and	w0, w0, 255
	add	x29, sp, 0
	bl	FlashRsvdBlkChk
	cmp	w0, 0
	orr	w1, w4, -1073741824
	csel	w4, w1, w4, ne
	mov	w0, w4
	ldp	x29, x30, [sp], 16
	ret
.L21:
	mov	w0, w4
	ret
	.size	FlashGetRandomizer, .-FlashGetRandomizer
	.section	.text.FlashSetRandomizer,"ax",@progbits
	.align	2
	.global	FlashSetRandomizer
	.type	FlashSetRandomizer, %function
FlashSetRandomizer:
	and	w5, w0, 255
	and	x2, x1, 127
	adrp	x0, .LANCHOR4
	add	x0, x0, :lo12:.LANCHOR4
	ldrh	w4, [x0, x2, lsl 1]
	adrp	x0, .LANCHOR5
	ldrb	w0, [x0, #:lo12:.LANCHOR5]
	cbz	w0, .L32
	stp	x29, x30, [sp, -16]!
	mov	w0, w5
	add	x29, sp, 0
	bl	FlashRsvdBlkChk
	cmp	w0, 0
	sbfiz	x5, x5, 4, 32
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	orr	w1, w4, -1073741824
	csel	w4, w1, w4, ne
	ldr	x0, [x0, x5]
	str	w4, [x0, 336]
	ldp	x29, x30, [sp], 16
	ret
.L32:
	sbfiz	x5, x5, 4, 32
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	ldr	x0, [x0, x5]
	str	w4, [x0, 336]
	ret
	.size	FlashSetRandomizer, .-FlashSetRandomizer
	.section	.text.FlashReadCmd,"ax",@progbits
	.align	2
	.global	FlashReadCmd
	.type	FlashReadCmd, %function
FlashReadCmd:
	and	w0, w0, 255
	adrp	x4, .LANCHOR6
	sbfiz	x5, x0, 4, 32
	add	x4, x4, :lo12:.LANCHOR6
	add	x2, x4, x5
	lsr	w3, w1, 16
	ldr	x4, [x4, x5]
	ldrb	w2, [x2, 8]
	add	x2, x4, x2, lsl 8
	and	w4, w1, 255
	str	wzr, [x2, 2056]
	str	wzr, [x2, 2052]
	str	wzr, [x2, 2052]
	str	w4, [x2, 2052]
	lsr	w4, w1, 8
	str	w4, [x2, 2052]
	str	w3, [x2, 2052]
	mov	w3, 48
	str	w3, [x2, 2056]
	b	FlashSetRandomizer
	.size	FlashReadCmd, .-FlashReadCmd
	.section	.text.FlashReadDpDataOutCmd,"ax",@progbits
	.align	2
	.global	FlashReadDpDataOutCmd
	.type	FlashReadDpDataOutCmd, %function
FlashReadDpDataOutCmd:
	and	w0, w0, 255
	adrp	x2, .LANCHOR6
	sbfiz	x3, x0, 4, 32
	add	x2, x2, :lo12:.LANCHOR6
	add	x4, x2, x3
	and	w5, w1, 255
	ldr	x6, [x2, x3]
	adrp	x2, .LANCHOR7+16
	lsr	w3, w1, 16
	ldrb	w2, [x2, #:lo12:.LANCHOR7+16]
	cmp	w2, 1
	ldrb	w2, [x4, 8]
	lsr	w4, w1, 8
	add	x2, x6, x2, lsl 8
	bne	.L37
	mov	w6, 6
	str	w6, [x2, 2056]
	str	wzr, [x2, 2052]
	str	wzr, [x2, 2052]
	str	w5, [x2, 2052]
	str	w4, [x2, 2052]
	str	w3, [x2, 2052]
.L39:
	mov	w3, 224
	str	w3, [x2, 2056]
	b	FlashSetRandomizer
.L37:
	str	wzr, [x2, 2056]
	str	wzr, [x2, 2052]
	str	wzr, [x2, 2052]
	str	w5, [x2, 2052]
	str	w4, [x2, 2052]
	str	w3, [x2, 2052]
	mov	w3, 5
	str	w3, [x2, 2056]
	str	wzr, [x2, 2052]
	str	wzr, [x2, 2052]
	b	.L39
	.size	FlashReadDpDataOutCmd, .-FlashReadDpDataOutCmd
	.section	.text.flash_enter_slc_mode,"ax",@progbits
	.align	2
	.global	flash_enter_slc_mode
	.type	flash_enter_slc_mode, %function
flash_enter_slc_mode:
	adrp	x1, .LANCHOR8
	and	w0, w0, 255
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	cbz	w1, .L40
	sbfiz	x0, x0, 4, 32
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	add	x2, x1, x0
	ldr	x1, [x1, x0]
	ldrb	w0, [x2, 8]
	add	x0, x0, 8
	add	x0, x1, x0, lsl 8
	mov	w1, 218
	str	w1, [x0, 8]
.L40:
	ret
	.size	flash_enter_slc_mode, .-flash_enter_slc_mode
	.section	.text.flash_exit_slc_mode,"ax",@progbits
	.align	2
	.global	flash_exit_slc_mode
	.type	flash_exit_slc_mode, %function
flash_exit_slc_mode:
	adrp	x1, .LANCHOR8
	and	w0, w0, 255
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	cbz	w1, .L45
	sbfiz	x0, x0, 4, 32
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	add	x2, x1, x0
	ldr	x1, [x1, x0]
	ldrb	w0, [x2, 8]
	add	x0, x0, 8
	add	x0, x1, x0, lsl 8
	mov	w1, 223
	str	w1, [x0, 8]
.L45:
	ret
	.size	flash_exit_slc_mode, .-flash_exit_slc_mode
	.section	.text.FlashProgFirstCmd,"ax",@progbits
	.align	2
	.global	FlashProgFirstCmd
	.type	FlashProgFirstCmd, %function
FlashProgFirstCmd:
	and	w0, w0, 255
	adrp	x4, .LANCHOR6
	sbfiz	x5, x0, 4, 32
	add	x4, x4, :lo12:.LANCHOR6
	add	x2, x4, x5
	lsr	w3, w1, 16
	ldr	x4, [x4, x5]
	ldrb	w2, [x2, 8]
	add	x2, x4, x2, lsl 8
	mov	w4, 128
	str	w4, [x2, 2056]
	and	w4, w1, 255
	str	wzr, [x2, 2052]
	str	wzr, [x2, 2052]
	str	w4, [x2, 2052]
	lsr	w4, w1, 8
	str	w4, [x2, 2052]
	str	w3, [x2, 2052]
	b	FlashSetRandomizer
	.size	FlashProgFirstCmd, .-FlashProgFirstCmd
	.section	.text.FlashEraseCmd,"ax",@progbits
	.align	2
	.global	FlashEraseCmd
	.type	FlashEraseCmd, %function
FlashEraseCmd:
	ubfiz	x0, x0, 4, 8
	adrp	x3, .LANCHOR6
	add	x3, x3, :lo12:.LANCHOR6
	add	x4, x3, x0
	ldr	x3, [x3, x0]
	ldrb	w0, [x4, 8]
	cbz	w2, .L52
	add	x2, x3, x0, lsl 8
	mov	w4, 96
	str	w4, [x2, 2056]
	and	w4, w1, 255
	str	w4, [x2, 2052]
	lsr	w4, w1, 8
	str	w4, [x2, 2052]
	lsr	w4, w1, 16
	str	w4, [x2, 2052]
	adrp	x2, .LANCHOR3
	ldr	w2, [x2, #:lo12:.LANCHOR3]
	add	w1, w1, w2
.L52:
	add	x0, x3, x0, lsl 8
	mov	w2, 96
	str	w2, [x0, 2056]
	and	w2, w1, 255
	str	w2, [x0, 2052]
	lsr	w2, w1, 8
	str	w2, [x0, 2052]
	lsr	w1, w1, 16
	str	w1, [x0, 2052]
	mov	w1, 208
	str	w1, [x0, 2056]
	ret
	.size	FlashEraseCmd, .-FlashEraseCmd
	.section	.text.FlashProgDpSecondCmd,"ax",@progbits
	.align	2
	.global	FlashProgDpSecondCmd
	.type	FlashProgDpSecondCmd, %function
FlashProgDpSecondCmd:
	and	w0, w0, 255
	adrp	x2, .LANCHOR7+11
	sbfiz	x5, x0, 4, 32
	adrp	x4, .LANCHOR6
	add	x4, x4, :lo12:.LANCHOR6
	ldrb	w6, [x2, #:lo12:.LANCHOR7+11]
	add	x2, x4, x5
	lsr	w3, w1, 16
	ldr	x4, [x4, x5]
	ldrb	w2, [x2, 8]
	add	x2, x4, x2, lsl 8
	and	w4, w1, 255
	str	w6, [x2, 2056]
	str	wzr, [x2, 2052]
	str	wzr, [x2, 2052]
	str	w4, [x2, 2052]
	lsr	w4, w1, 8
	str	w4, [x2, 2052]
	str	w3, [x2, 2052]
	b	FlashSetRandomizer
	.size	FlashProgDpSecondCmd, .-FlashProgDpSecondCmd
	.section	.text.FlashProgSecondCmd,"ax",@progbits
	.align	2
	.global	FlashProgSecondCmd
	.type	FlashProgSecondCmd, %function
FlashProgSecondCmd:
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	add	x2, x1, x0
	ldr	x1, [x1, x0]
	ldrb	w0, [x2, 8]
	add	x0, x0, 8
	add	x0, x1, x0, lsl 8
	mov	w1, 16
	str	w1, [x0, 8]
	ret
	.size	FlashProgSecondCmd, .-FlashProgSecondCmd
	.section	.text.FlashProgDpFirstCmd,"ax",@progbits
	.align	2
	.global	FlashProgDpFirstCmd
	.type	FlashProgDpFirstCmd, %function
FlashProgDpFirstCmd:
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	add	x3, x1, x0
	ldr	x2, [x1, x0]
	adrp	x0, .LANCHOR7+10
	ldrb	w1, [x0, #:lo12:.LANCHOR7+10]
	ldrb	w0, [x3, 8]
	add	x0, x0, 8
	add	x0, x2, x0, lsl 8
	str	w1, [x0, 8]
	ret
	.size	FlashProgDpFirstCmd, .-FlashProgDpFirstCmd
	.section	.text.FlashReadStatus,"ax",@progbits
	.align	2
	.global	FlashReadStatus
	.type	FlashReadStatus, %function
FlashReadStatus:
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	stp	x29, x30, [sp, -32]!
	add	x2, x1, x0
	add	x29, sp, 0
	ldr	x0, [x1, x0]
	str	x19, [sp, 16]
	ldrb	w19, [x2, 8]
	add	x19, x0, x19, lsl 8
	mov	w0, 112
	str	w0, [x19, 2056]
	mov	x0, 80
	bl	udelay
	ldr	w0, [x19, 2048]
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FlashReadStatus, .-FlashReadStatus
	.section	.text.JSHash,"ax",@progbits
	.align	2
	.global	JSHash
	.type	JSHash, %function
JSHash:
	mov	x4, x0
	mov	w0, 42982
	mov	x3, 0
	movk	w0, 0x47c6, lsl 16
.L62:
	cmp	w1, w3
	bhi	.L63
	ret
.L63:
	lsr	w2, w0, 2
	ldrb	w5, [x4, x3]
	add	w2, w2, w0, lsl 5
	add	x3, x3, 1
	add	w2, w2, w5
	eor	w0, w0, w2
	b	.L62
	.size	JSHash, .-JSHash
	.section	.text.FlashLoadIdbInfo,"ax",@progbits
	.align	2
	.global	FlashLoadIdbInfo
	.type	FlashLoadIdbInfo, %function
FlashLoadIdbInfo:
	mov	w0, 0
	ret
	.size	FlashLoadIdbInfo, .-FlashLoadIdbInfo
	.section	.text.FlashPrintInfo,"ax",@progbits
	.align	2
	.global	FlashPrintInfo
	.type	FlashPrintInfo, %function
FlashPrintInfo:
	ret
	.size	FlashPrintInfo, .-FlashPrintInfo
	.section	.text.ToshibaSetRRPara,"ax",@progbits
	.align	2
	.global	ToshibaSetRRPara
	.type	ToshibaSetRRPara, %function
ToshibaSetRRPara:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	str	x27, [sp, 80]
	and	w27, w1, 255
	add	w2, w27, 1
	stp	x21, x22, [sp, 32]
	mov	x21, x0
	mov	w0, 5
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR9
	umull	x2, w2, w0
	stp	x23, x24, [sp, 48]
	adrp	x0, .LANCHOR10
	add	x20, x20, :lo12:.LANCHOR9
	add	x24, x0, :lo12:.LANCHOR10
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR13
	adrp	x25, .LANCHOR11
	adrp	x26, .LANCHOR12
	add	x23, x23, :lo12:.LANCHOR13
	add	x25, x25, :lo12:.LANCHOR11
	add	x26, x26, :lo12:.LANCHOR12
	add	x20, x20, x2
	add	x24, x24, x2
	mov	x22, x0
	mov	x19, 0
.L67:
	ldrb	w0, [x23]
	cmp	w0, w19
	bhi	.L71
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L71:
	mov	w0, 85
	str	w0, [x21, 8]
	add	x0, x22, :lo12:.LANCHOR10
	ldrsb	w0, [x19, x0]
	str	w0, [x21, 4]
	mov	x0, 200
	bl	udelay
	ldrb	w0, [x25]
	cmp	w0, 34
	bne	.L68
	ldrsb	w0, [x24, x19]
.L73:
	add	x19, x19, 1
	str	w0, [x21]
	b	.L67
.L68:
	cmp	w0, 35
	bne	.L70
	ldrsb	w0, [x20, x19]
	b	.L73
.L70:
	ldrsb	w0, [x26, w27, sxtw]
	b	.L73
	.size	ToshibaSetRRPara, .-ToshibaSetRRPara
	.section	.text.SamsungSetRRPara,"ax",@progbits
	.align	2
	.global	SamsungSetRRPara
	.type	SamsungSetRRPara, %function
SamsungSetRRPara:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	ubfiz	x21, x1, 2, 8
	mov	x22, x0
	add	x21, x21, 4
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	stp	x19, x20, [sp, 16]
	add	x21, x0, x21
	stp	x23, x24, [sp, 48]
	mov	x19, x0
	adrp	x23, .LANCHOR13
	add	x23, x23, :lo12:.LANCHOR13
	mov	x20, 0
	mov	w24, 161
.L75:
	ldrb	w0, [x23]
	cmp	w0, w20
	bhi	.L76
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L76:
	str	w24, [x22, 8]
	str	wzr, [x22]
	ldrsb	w0, [x20, x19]
	str	w0, [x22]
	ldrsb	w0, [x21, x20]
	add	x20, x20, 1
	str	w0, [x22]
	mov	x0, 300
	bl	udelay
	b	.L75
	.size	SamsungSetRRPara, .-SamsungSetRRPara
	.section	.text.LogAddr2PhyAddr,"ax",@progbits
	.align	2
	.global	LogAddr2PhyAddr
	.type	LogAddr2PhyAddr, %function
LogAddr2PhyAddr:
	adrp	x6, .LANCHOR15
	add	x6, x6, :lo12:.LANCHOR15
	and	w4, w4, 255
	ldrh	w8, [x6, 12]
	ldrh	w5, [x6, 14]
	mul	w5, w5, w8
	and	w8, w5, 65535
	adrp	x5, .LANCHOR3
	ldrh	w7, [x5, #:lo12:.LANCHOR3]
	adrp	x5, .LANCHOR1
	ldrb	w6, [x5, #:lo12:.LANCHOR1]
	ubfiz	w5, w7, 1, 15
	cmp	w6, 1
	ldr	w6, [x0, 4]
	csel	w7, w5, w7, eq
	cmp	w1, 1
	ubfx	x11, x6, 10, 16
	and	w6, w6, 1023
	udiv	w5, w11, w8
	and	w10, w5, 65535
	msub	w5, w5, w8, w11
	and	w5, w5, 65535
	bne	.L80
	adrp	x1, .LANCHOR8
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	cbnz	w1, .L80
	adrp	x1, .LANCHOR16
	add	x1, x1, :lo12:.LANCHOR16
	ldrh	w6, [x1, w6, sxtw 1]
.L80:
	uxtw	x8, w10
	adrp	x1, .LANCHOR17
	add	x1, x1, :lo12:.LANCHOR17
	cmp	w4, 1
	ldr	w1, [x1, x8, lsl 2]
	madd	w5, w5, w7, w1
	add	w5, w5, w6
	str	w5, [x2]
	str	w10, [x3]
	bls	.L82
	ldr	w1, [x0, 4]
	ldr	w0, [x0, 60]
	add	w1, w1, 1024
	cmp	w1, w0
	cset	w0, eq
	ret
.L82:
	mov	w0, 0
	ret
	.size	LogAddr2PhyAddr, .-LogAddr2PhyAddr
	.section	.text.FlashReadStatusEN,"ax",@progbits
	.align	2
	.global	FlashReadStatusEN
	.type	FlashReadStatusEN, %function
FlashReadStatusEN:
	stp	x29, x30, [sp, -32]!
	ubfiz	x0, x0, 4, 8
	adrp	x3, .LANCHOR6
	add	x3, x3, :lo12:.LANCHOR6
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	x4, x3, x0
	ldr	x20, [x3, x0]
	adrp	x0, .LANCHOR18
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	ldrb	w19, [x4, 8]
	ldrb	w0, [x0, 8]
	cmp	w0, 2
	bne	.L84
	and	w2, w2, 255
	adrp	x0, .LANCHOR7
	cbnz	w2, .L85
	add	x2, x0, :lo12:.LANCHOR7
	ldrb	w3, [x2, 13]
.L95:
	add	x2, x19, 8
	add	x0, x0, :lo12:.LANCHOR7
	add	x2, x20, x2, lsl 8
	str	w3, [x2, 8]
	ldrb	w4, [x0, 15]
	cbz	w4, .L89
	add	x3, x19, 8
	mov	w2, 0
	add	x3, x20, x3, lsl 8
.L88:
	cmp	w2, w4
	bcc	.L90
.L89:
	add	x19, x19, 8
	mov	x0, 80
	lsl	x19, x19, 8
	bl	udelay
	ldr	w0, [x20, x19]
	ldp	x19, x20, [sp, 16]
	and	w0, w0, 255
	ldp	x29, x30, [sp], 32
	ret
.L85:
	add	x2, x0, :lo12:.LANCHOR7
	ldrb	w3, [x2, 14]
	b	.L95
.L90:
	lsl	w0, w2, 3
	add	w2, w2, 1
	lsr	w0, w1, w0
	and	w0, w0, 255
	str	w0, [x3, 4]
	b	.L88
.L84:
	add	x0, x19, 8
	mov	w1, 112
	add	x0, x20, x0, lsl 8
	str	w1, [x0, 8]
	b	.L89
	.size	FlashReadStatusEN, .-FlashReadStatusEN
	.section	.text.FlashWaitReadyEN,"ax",@progbits
	.align	2
	.global	FlashWaitReadyEN
	.type	FlashWaitReadyEN, %function
FlashWaitReadyEN:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 255
	str	x21, [sp, 32]
	mov	w20, w1
	and	w21, w2, 255
.L100:
	mov	w1, w20
	mov	w2, w21
	mov	w0, w19
	bl	FlashReadStatusEN
	mov	w1, w0
	cmp	w0, 255
	beq	.L100
	tbz	x1, 6, .L100
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
	.size	FlashWaitReadyEN, .-FlashWaitReadyEN
	.section	.text.NandcReadDontCaseBusyEn,"ax",@progbits
	.align	2
	.global	NandcReadDontCaseBusyEn
	.type	NandcReadDontCaseBusyEn, %function
NandcReadDontCaseBusyEn:
	ret
	.size	NandcReadDontCaseBusyEn, .-NandcReadDontCaseBusyEn
	.section	.text.NandcGetChipIf,"ax",@progbits
	.align	2
	.global	NandcGetChipIf
	.type	NandcGetChipIf, %function
NandcGetChipIf:
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	add	x2, x1, x0
	ldr	x0, [x1, x0]
	ldrb	w2, [x2, 8]
	add	x2, x2, 8
	add	x0, x0, x2, lsl 8
	ret
	.size	NandcGetChipIf, .-NandcGetChipIf
	.section	.text.NandcSetDdrPara,"ax",@progbits
	.align	2
	.global	NandcSetDdrPara
	.type	NandcSetDdrPara, %function
NandcSetDdrPara:
	adrp	x1, .LANCHOR19
	and	w0, w0, 255
	lsl	w2, w0, 8
	ldr	x1, [x1, #:lo12:.LANCHOR19]
	orr	w0, w2, w0, lsl 16
	orr	w0, w0, 1
	str	w0, [x1, 304]
	ret
	.size	NandcSetDdrPara, .-NandcSetDdrPara
	.section	.text.NandcSetDdrDiv,"ax",@progbits
	.align	2
	.global	NandcSetDdrDiv
	.type	NandcSetDdrDiv, %function
NandcSetDdrDiv:
	adrp	x1, .LANCHOR19
	and	w0, w0, 255
	mov	w2, 16640
	orr	w0, w0, w2
	ldr	x1, [x1, #:lo12:.LANCHOR19]
	str	w0, [x1, 344]
	ret
	.size	NandcSetDdrDiv, .-NandcSetDdrDiv
	.section	.text.NandcSetDdrMode,"ax",@progbits
	.align	2
	.global	NandcSetDdrMode
	.type	NandcSetDdrMode, %function
NandcSetDdrMode:
	adrp	x1, .LANCHOR19
	cmp	w0, 0
	ldr	x2, [x1, #:lo12:.LANCHOR19]
	ldr	w1, [x2]
	and	w3, w1, -8193
	orr	w1, w1, 253952
	csel	w1, w1, w3, ne
	str	w1, [x2]
	ret
	.size	NandcSetDdrMode, .-NandcSetDdrMode
	.section	.text.NandcSetMode,"ax",@progbits
	.align	2
	.global	NandcSetMode
	.type	NandcSetMode, %function
NandcSetMode:
	adrp	x1, .LANCHOR19
	and	w0, w0, 255
	tst	w0, 6
	ldr	x2, [x1, #:lo12:.LANCHOR19]
	ldr	w1, [x2]
	beq	.L112
	orr	w1, w1, 24576
	tst	x0, 4
	and	w1, w1, -32769
	mov	w0, 16641
	orr	w1, w1, 196608
	str	w0, [x2, 344]
	mov	w0, 6659
	orr	w3, w1, 32768
	movk	w0, 0x1a, lsl 16
	str	w0, [x2, 304]
	csel	w1, w3, w1, ne
	mov	w0, 38
	str	w0, [x2, 308]
	mov	w0, 39
	str	w0, [x2, 308]
.L114:
	mov	w0, 0
	str	w1, [x2]
	ret
.L112:
	and	w1, w1, -8193
	b	.L114
	.size	NandcSetMode, .-NandcSetMode
	.section	.text.NandcFlashCs,"ax",@progbits
	.align	2
	.global	NandcFlashCs
	.type	NandcFlashCs, %function
NandcFlashCs:
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	add	x3, x1, x0
	ldr	x2, [x1, x0]
	mov	w1, 1
	ldrb	w3, [x3, 8]
	ldr	w0, [x2]
	lsl	w1, w1, w3
	bfi	w0, w1, 0, 8
	str	w0, [x2]
	ret
	.size	NandcFlashCs, .-NandcFlashCs
	.section	.text.NandcFlashDeCs,"ax",@progbits
	.align	2
	.global	NandcFlashDeCs
	.type	NandcFlashDeCs, %function
NandcFlashDeCs:
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	ldr	x1, [x1, x0]
	ldr	w0, [x1]
	and	w0, w0, -256
	and	w0, w0, -131073
	str	w0, [x1]
	ret
	.size	NandcFlashDeCs, .-NandcFlashDeCs
	.section	.text.HynixSetRRPara,"ax",@progbits
	.align	2
	.global	HynixSetRRPara
	.type	HynixSetRRPara, %function
HynixSetRRPara:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	adrp	x0, .LANCHOR18
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	mov	x21, x2
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	and	w26, w1, 255
	stp	x23, x24, [sp, 48]
	and	w20, w3, 255
	adrp	x19, .LANCHOR20
	ldrb	w0, [x0, 19]
	cmp	w0, 6
	bne	.L120
	add	x0, x19, :lo12:.LANCHOR20
	ubfiz	x19, x22, 6, 8
	add	x19, x19, 20
	add	x19, x19, x20, uxtw 2
.L126:
	add	x19, x0, x19
.L121:
	sxtw	x25, w22
	adrp	x0, .LANCHOR6
	lsl	x1, x25, 4
	add	x0, x0, :lo12:.LANCHOR6
	add	x2, x0, x1
	and	x26, x26, 255
	mov	x24, 0
	ldr	x23, [x0, x1]
	mov	w0, w22
	ldrb	w5, [x2, 8]
	bl	NandcFlashCs
	ubfiz	x5, x5, 8, 8
	add	x23, x23, x5
	mov	w0, 54
	str	w0, [x23, 2056]
.L123:
	cmp	x24, x26
	bne	.L124
	mov	w0, 22
	str	w0, [x23, 2056]
	mov	w0, w22
	bl	NandcFlashDeCs
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	strb	w20, [x0, x25]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L120:
	cmp	w0, 7
	add	x0, x19, :lo12:.LANCHOR20
	bne	.L122
	mov	w19, 160
	mov	x1, 28
	umaddl	x1, w19, w22, x1
	mov	w19, 10
	umaddl	x19, w20, w19, x1
	b	.L126
.L122:
	and	x19, x20, 255
	add	x19, x19, 2
	add	x19, x19, x22, uxtw 3
	add	x19, x0, x19, lsl 3
	add	x19, x19, 4
	b	.L121
.L124:
	ldrb	w0, [x21, x24]
	str	w0, [x23, 2052]
	mov	x0, 200
	bl	udelay
	ldrsb	w0, [x19, x24]
	add	x24, x24, 1
	str	w0, [x23, 2048]
	b	.L123
	.size	HynixSetRRPara, .-HynixSetRRPara
	.section	.text.FlashSetReadRetryDefault,"ax",@progbits
	.align	2
	.global	FlashSetReadRetryDefault
	.type	FlashSetReadRetryDefault, %function
FlashSetReadRetryDefault:
	adrp	x0, .LANCHOR18
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 19]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 6
	bhi	.L134
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR20
	add	x20, x20, :lo12:.LANCHOR20
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR22
	add	x22, x20, 4
	add	x21, x21, :lo12:.LANCHOR22
	mov	x19, 0
.L130:
	lsl	x1, x19, 3
	and	w0, w19, 255
	ldrb	w1, [x1, x21]
	cmp	w1, 173
	bne	.L129
	ldrb	w1, [x20, 1]
	mov	w3, 0
	mov	x2, x22
	bl	HynixSetRRPara
.L129:
	add	x19, x19, 1
	cmp	x19, 4
	bne	.L130
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L134:
	ret
	.size	FlashSetReadRetryDefault, .-FlashSetReadRetryDefault
	.section	.text.FlashWaitCmdDone,"ax",@progbits
	.align	2
	.global	FlashWaitCmdDone
	.type	FlashWaitCmdDone, %function
FlashWaitCmdDone:
	and	x4, x0, 255
	mov	x0, 24
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR23
	add	x1, x1, :lo12:.LANCHOR23
	mul	x0, x4, x0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	x19, x1, x0
	ldr	x2, [x19, 8]
	cbz	x2, .L139
	ldrb	w20, [x1, x0]
	mov	w0, w20
	bl	NandcFlashCs
	adrp	x0, .LANCHOR17
	add	x0, x0, :lo12:.LANCHOR17
	ldr	w1, [x19, 4]
	ldr	w0, [x0, x4, lsl 2]
	cmp	w0, 0
	mov	w0, w20
	cset	w2, ne
	bl	FlashWaitReadyEN
	mov	w2, w0
	mov	w0, w20
	bl	NandcFlashDeCs
	sbfx	x0, x2, 0, 1
	ldr	x1, [x19, 8]
	str	w0, [x1]
	ldr	x1, [x19, 16]
	str	xzr, [x19, 8]
	cbz	x1, .L139
	str	w0, [x1]
	str	xzr, [x19, 16]
.L139:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FlashWaitCmdDone, .-FlashWaitCmdDone
	.section	.text.NandcDelayns,"ax",@progbits
	.align	2
	.global	NandcDelayns
	.type	NandcDelayns, %function
NandcDelayns:
	stp	x29, x30, [sp, -16]!
	uxtw	x0, w0
	add	x29, sp, 0
	bl	udelay
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	NandcDelayns, .-NandcDelayns
	.section	.text.NandcWaitFlashReady,"ax",@progbits
	.align	2
	.global	NandcWaitFlashReady
	.type	NandcWaitFlashReady, %function
NandcWaitFlashReady:
	stp	x29, x30, [sp, -48]!
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, 34464
	ldr	x20, [x1, x0]
	movk	w19, 0x1, lsl 16
.L149:
	mov	x0, 100
	bl	udelay
	ldr	w0, [x20]
	str	w0, [x29, 40]
	ldr	w0, [x29, 40]
	tbnz	x0, 9, .L150
	subs	w19, w19, #1
	bne	.L149
	mov	w0, -1
.L147:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L150:
	mov	w0, 0
	b	.L147
	.size	NandcWaitFlashReady, .-NandcWaitFlashReady
	.section	.text.FlashReset,"ax",@progbits
	.align	2
	.global	FlashReset
	.type	FlashReset, %function
FlashReset:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	and	w19, w0, 255
	sbfiz	x1, x19, 4, 32
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	add	x2, x0, x1
	ldr	x5, [x0, x1]
	mov	w0, w19
	ldrb	w4, [x2, 8]
	bl	NandcFlashCs
	add	x4, x4, 8
	add	x4, x5, x4, lsl 8
	mov	w0, 255
	str	w0, [x4, 8]
	mov	w0, w19
	bl	NandcWaitFlashReady
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	NandcFlashDeCs
	.size	FlashReset, .-FlashReset
	.section	.text.FlashEraseBlock,"ax",@progbits
	.align	2
	.global	FlashEraseBlock
	.type	FlashEraseBlock, %function
FlashEraseBlock:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 255
	mov	w20, w1
	str	x21, [sp, 32]
	mov	w0, w19
	mov	w21, w2
	bl	NandcWaitFlashReady
	mov	w0, w19
	bl	NandcFlashCs
	mov	w2, w21
	mov	w1, w20
	mov	w0, w19
	bl	FlashEraseCmd
	mov	w0, w19
	bl	NandcWaitFlashReady
	mov	w1, w20
	mov	w0, w19
	bl	FlashReadStatus
	mov	w2, w0
	mov	w0, w19
	bl	NandcFlashDeCs
	ldr	x21, [sp, 32]
	and	w0, w2, 1
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.size	FlashEraseBlock, .-FlashEraseBlock
	.section	.text.FlashSetInterfaceMode,"ax",@progbits
	.align	2
	.global	FlashSetInterfaceMode
	.type	FlashSetInterfaceMode, %function
FlashSetInterfaceMode:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR24
	adrp	x2, .LANCHOR6
	add	x2, x2, :lo12:.LANCHOR6
	add	x29, sp, 0
	ldrb	w1, [x1, #:lo12:.LANCHOR24]
	adrp	x7, .LANCHOR22
	add	x2, x2, 8
	add	x7, x7, :lo12:.LANCHOR22
	and	w12, w1, 4
	and	w6, w1, 1
	mov	x5, 0
	mov	w13, 69
	mov	w8, 239
	mov	w10, 128
	mov	w11, 1
	mov	w14, 35
	mov	w15, 32
	mov	w16, 5
	mov	w17, 44
.L167:
	ldrb	w3, [x5, x7]
	ldrb	w4, [x2]
	cmp	w3, 152
	ccmp	w3, w13, 4, ne
	beq	.L158
	cmp	w3, 173
	ccmp	w3, w17, 4, ne
	bne	.L159
.L158:
	cmp	w0, 1
	ldr	x1, [x2, -8]
	bne	.L160
	cbz	w6, .L159
	ubfiz	x4, x4, 8, 8
	cmp	w3, 173
	add	x1, x1, x4
	str	w8, [x1, 2056]
	bne	.L161
	str	w0, [x1, 2052]
.L179:
	str	wzr, [x1, 2048]
	b	.L165
.L161:
	cmp	w3, 44
	bne	.L163
	str	w0, [x1, 2052]
	str	w16, [x1, 2048]
.L165:
	str	wzr, [x1, 2048]
	str	wzr, [x1, 2048]
	str	wzr, [x1, 2048]
.L159:
	add	x5, x5, 8
	add	x2, x2, 16
	cmp	x5, 32
	bne	.L167
	mov	w0, 0
	bl	NandcWaitFlashReady
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L163:
	str	w10, [x1, 2052]
	str	w0, [x1, 2048]
	b	.L165
.L160:
	cbz	w12, .L159
	ubfiz	x4, x4, 8, 8
	cmp	w3, 173
	add	x1, x1, x4
	str	w8, [x1, 2056]
	bne	.L164
	str	w11, [x1, 2052]
	str	w15, [x1, 2048]
	b	.L165
.L164:
	cmp	w3, 44
	bne	.L166
	str	w11, [x1, 2052]
	str	w14, [x1, 2048]
	b	.L165
.L166:
	str	w10, [x1, 2052]
	b	.L179
	.size	FlashSetInterfaceMode, .-FlashSetInterfaceMode
	.section	.text.SandiskSetRRPara,"ax",@progbits
	.align	2
	.global	SandiskSetRRPara
	.type	SandiskSetRRPara, %function
SandiskSetRRPara:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	mov	w0, 239
	and	w19, w1, 255
	str	w0, [x20, 8]
	mov	w0, 17
	str	w0, [x20, 4]
	mov	x0, 200
	bl	udelay
	adrp	x0, .LANCHOR13
	add	w1, w19, 1
	adrp	x2, .LANCHOR9
	add	x2, x2, :lo12:.LANCHOR9
	ldrb	w3, [x0, #:lo12:.LANCHOR13]
	adrp	x0, .LANCHOR11
	ldrb	w4, [x0, #:lo12:.LANCHOR11]
	mov	w0, 5
	umull	x1, w1, w0
	adrp	x0, .LANCHOR10
	add	x0, x0, :lo12:.LANCHOR10
	add	x2, x2, x1
	add	x1, x0, x1
	mov	x0, 0
.L181:
	cmp	w3, w0
	bhi	.L184
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	b	NandcWaitFlashReady
.L184:
	cmp	w4, 67
	bne	.L182
	ldrsb	w5, [x1, x0]
.L186:
	add	x0, x0, 1
	str	w5, [x20]
	b	.L181
.L182:
	ldrsb	w5, [x2, x0]
	b	.L186
	.size	SandiskSetRRPara, .-SandiskSetRRPara
	.section	.text.micron_auto_read_calibration_config,"ax",@progbits
	.align	2
	.global	micron_auto_read_calibration_config
	.type	micron_auto_read_calibration_config, %function
micron_auto_read_calibration_config:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 255
	mov	w20, w1
	mov	w0, w19
	bl	NandcWaitFlashReady
	sbfiz	x0, x19, 4, 32
	adrp	x2, .LANCHOR6
	add	x2, x2, :lo12:.LANCHOR6
	add	x1, x2, x0
	ldr	x0, [x2, x0]
	ldrb	w19, [x1, 8]
	add	x19, x0, x19, lsl 8
	mov	w0, 239
	str	w0, [x19, 2056]
	mov	w0, 150
	str	w0, [x19, 2052]
	mov	x0, 200
	bl	udelay
	str	w20, [x19, 2048]
	str	wzr, [x19, 2048]
	str	wzr, [x19, 2048]
	str	wzr, [x19, 2048]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	micron_auto_read_calibration_config, .-micron_auto_read_calibration_config
	.section	.text.FlashEraseSLc2KBlocks,"ax",@progbits
	.align	2
	.global	FlashEraseSLc2KBlocks
	.type	FlashEraseSLc2KBlocks, %function
FlashEraseSLc2KBlocks:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	w22, 56
	stp	x23, x24, [sp, 48]
	and	w21, w1, 255
	umaddl	x22, w1, w22, x0
	stp	x19, x20, [sp, 16]
	adrp	x23, .LANCHOR25
	mov	x20, x0
	add	x23, x23, :lo12:.LANCHOR25
	adrp	x24, .LANCHOR26
.L190:
	cmp	x20, x22
	bne	.L195
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L195:
	mov	w1, 0
	mov	w4, w21
	add	x3, x29, 76
	add	x2, x29, 72
	mov	x0, x20
	bl	LogAddr2PhyAddr
	ldrb	w1, [x23]
	ldr	w0, [x29, 76]
	cmp	w1, w0
	bhi	.L191
	mov	w0, -1
	str	w0, [x20]
.L192:
	sub	w21, w21, #1
	add	x20, x20, 56
	and	w21, w21, 255
	b	.L190
.L191:
	uxtw	x0, w0
	add	x1, x24, :lo12:.LANCHOR26
	ldrb	w19, [x1, x0]
	mov	x1, 24
	mul	x0, x0, x1
	adrp	x1, .LANCHOR23
	add	x1, x1, :lo12:.LANCHOR23
	strb	w19, [x1, x0]
	mov	w0, w19
	bl	NandcWaitFlashReady
	mov	w0, w19
	bl	NandcFlashCs
	ldr	w1, [x29, 72]
	mov	w2, 0
	mov	w0, w19
	bl	FlashEraseCmd
	mov	w0, w19
	bl	NandcWaitFlashReady
	ldr	w1, [x29, 72]
	mov	w0, w19
	bl	FlashReadStatus
	sbfx	x0, x0, 0, 1
	str	w0, [x20]
	adrp	x0, .LANCHOR3
	ldr	w1, [x29, 72]
	mov	w2, 0
	ldr	w0, [x0, #:lo12:.LANCHOR3]
	add	w1, w1, w0
	mov	w0, w19
	bl	FlashEraseCmd
	mov	w0, w19
	bl	NandcWaitFlashReady
	ldr	w1, [x29, 72]
	mov	w0, w19
	bl	FlashReadStatus
	tbz	x0, 0, .L193
	mov	w0, -1
	str	w0, [x20]
.L193:
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L194
	ldr	w1, [x29, 72]
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf
.L194:
	mov	w0, w19
	bl	NandcFlashDeCs
	b	.L192
	.size	FlashEraseSLc2KBlocks, .-FlashEraseSLc2KBlocks
	.section	.text.FlashEraseBlocks,"ax",@progbits
	.align	2
	.global	FlashEraseBlocks
	.type	FlashEraseBlocks, %function
FlashEraseBlocks:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	w24, w1
	adrp	x1, .LANCHOR1
	stp	x21, x22, [sp, 32]
	stp	x19, x20, [sp, 16]
	mov	w22, w2
	ldrb	w1, [x1, #:lo12:.LANCHOR1]
	stp	x25, x26, [sp, 64]
	cbnz	w1, .L201
	adrp	x25, .LANCHOR23
	mov	x19, x0
	add	x26, x25, :lo12:.LANCHOR23
	mov	w20, 0
.L202:
	cmp	w20, w22
	adrp	x13, .LANCHOR25
	bcc	.L211
	adrp	x21, .LANCHOR8
	adrp	x23, .LANCHOR23
	add	x25, x13, :lo12:.LANCHOR25
	add	x21, x21, :lo12:.LANCHOR8
	add	x23, x23, :lo12:.LANCHOR23
	mov	x20, 0
.L212:
	ldrb	w0, [x25]
	cmp	w0, w20
	bhi	.L214
	adrp	x0, .LANCHOR28
	ldr	w0, [x0, #:lo12:.LANCHOR28]
	cbnz	w0, .L215
.L216:
	mov	w0, 0
	b	.L200
.L201:
	mov	w1, w2
	bl	FlashEraseSLc2KBlocks
.L200:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L211:
	mov	w12, 56
	mov	w1, 0
	sub	w4, w22, w20
	add	x3, x29, 92
	umull	x12, w20, w12
	add	x2, x29, 88
	add	x21, x19, x12
	mov	x0, x21
	bl	LogAddr2PhyAddr
	mov	w23, w0
	ldrb	w1, [x13, #:lo12:.LANCHOR25]
	ldr	w0, [x29, 92]
	cmp	w1, w0
	bhi	.L204
	mov	w0, -1
	str	w0, [x19, x12]
.L205:
	add	w20, w20, 1
	b	.L202
.L204:
	adrp	x1, .LANCHOR27
	add	x2, x25, :lo12:.LANCHOR23
	mov	x3, 24
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
	cmp	w1, 0
	uxtw	x1, w0
	csel	w23, w23, wzr, ne
	madd	x1, x1, x3, x2
	ldr	x1, [x1, 8]
	cbz	x1, .L207
	bl	FlashWaitCmdDone
.L207:
	ldp	w2, w1, [x29, 88]
	mov	x0, 24
	madd	x0, x1, x0, x26
	str	w2, [x0, 4]
	stp	x21, xzr, [x0, 8]
	cbz	w23, .L208
	add	w2, w20, 1
	mov	w3, 56
	umaddl	x2, w2, w3, x19
	str	x2, [x0, 16]
.L208:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w21, [x0, x1]
	mov	x0, 24
	mul	x1, x1, x0
	mov	w0, w21
	strb	w21, [x26, x1]
	bl	NandcFlashCs
	cmp	w24, 1
	bne	.L209
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L209
	mov	w0, w21
	bl	flash_enter_slc_mode
.L210:
	ldr	w1, [x29, 92]
	adrp	x0, .LANCHOR17
	add	x0, x0, :lo12:.LANCHOR17
	add	w20, w20, w23
	ldr	w0, [x0, x1, lsl 2]
	ldr	w1, [x29, 88]
	cmp	w0, 0
	mov	w0, w21
	cset	w2, ne
	bl	FlashWaitReadyEN
	ldr	w1, [x29, 88]
	mov	w2, w23
	mov	w0, w21
	bl	FlashEraseCmd
	mov	w0, w21
	bl	NandcFlashDeCs
	b	.L205
.L209:
	mov	w0, w21
	bl	flash_exit_slc_mode
	b	.L210
.L214:
	mov	w0, w20
	bl	FlashWaitCmdDone
	cmp	w24, 1
	bne	.L213
	ldrb	w0, [x21]
	cbz	w0, .L213
	mov	x0, 24
	mul	x0, x20, x0
	ldrb	w0, [x0, x23]
	bl	flash_exit_slc_mode
.L213:
	add	x20, x20, 1
	b	.L212
.L215:
	adrp	x0, .LANCHOR22
	ldrb	w0, [x0, #:lo12:.LANCHOR22]
	cmp	w0, 69
	bne	.L216
	mov	w0, 56
	umaddl	x22, w22, w0, x19
.L217:
	cmp	x22, x19
	beq	.L216
	str	wzr, [x19], 56
	b	.L217
	.size	FlashEraseBlocks, .-FlashEraseBlocks
	.section	.text.FlashReadDpCmd,"ax",@progbits
	.align	2
	.global	FlashReadDpCmd
	.type	FlashReadDpCmd, %function
FlashReadDpCmd:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	mov	w21, w1
	adrp	x0, .LANCHOR6
	sbfiz	x1, x22, 4, 32
	add	x0, x0, :lo12:.LANCHOR6
	add	x3, x0, x1
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	and	w4, w21, 255
	ldr	x6, [x0, x1]
	adrp	x0, .LANCHOR7
	ldrb	w19, [x3, 8]
	add	x0, x0, :lo12:.LANCHOR7
	lsr	w3, w21, 8
	and	w24, w2, 255
	lsr	w23, w2, 8
	lsr	w20, w2, 16
	add	x19, x6, x19, lsl 8
	ldrb	w5, [x0, 8]
	ldrb	w1, [x0, 16]
	ldrb	w0, [x0, 9]
	str	w5, [x19, 2056]
	cmp	w1, 1
	lsr	w1, w21, 16
	bne	.L233
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w4, [x19, 2052]
	str	w3, [x19, 2052]
	str	w1, [x19, 2052]
	str	w0, [x19, 2056]
	mov	w0, w22
	bl	NandcWaitFlashReady
	str	wzr, [x19, 2056]
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
.L236:
	str	w24, [x19, 2052]
	mov	w0, 48
	str	w23, [x19, 2052]
	mov	w1, w21
	str	w20, [x19, 2052]
	str	w0, [x19, 2056]
	mov	w0, w22
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	b	FlashSetRandomizer
.L233:
	str	w4, [x19, 2052]
	str	w3, [x19, 2052]
	str	w1, [x19, 2052]
	str	w0, [x19, 2056]
	b	.L236
	.size	FlashReadDpCmd, .-FlashReadDpCmd
	.section	.text.FlashDeInit,"ax",@progbits
	.align	2
	.global	FlashDeInit
	.type	FlashDeInit, %function
FlashDeInit:
	stp	x29, x30, [sp, -32]!
	mov	w0, 0
	add	x29, sp, 0
	str	x19, [sp, 16]
	bl	NandcWaitFlashReady
	bl	FlashSetReadRetryDefault
	adrp	x0, .LANCHOR29
	ldr	w1, [x0, #:lo12:.LANCHOR29]
	mov	w0, 12336
	movk	w0, 0x5638, lsl 16
	cmp	w1, w0
	bne	.L238
	mov	w0, 0
	bl	flash_enter_slc_mode
.L238:
	adrp	x19, .LANCHOR30
	ldrb	w0, [x19, #:lo12:.LANCHOR30]
	cbz	w0, .L239
	adrp	x0, .LANCHOR24
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	tbz	x0, 0, .L239
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
	strb	wzr, [x19, #:lo12:.LANCHOR30]
.L239:
	adrp	x0, .LANCHOR6
	ldr	x0, [x0, #:lo12:.LANCHOR6]
	str	wzr, [x0, 336]
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FlashDeInit, .-FlashDeInit
	.section	.text.NandcRandmzSel,"ax",@progbits
	.align	2
	.global	NandcRandmzSel
	.type	NandcRandmzSel, %function
NandcRandmzSel:
	ubfiz	x0, x0, 4, 8
	adrp	x2, .LANCHOR6
	add	x2, x2, :lo12:.LANCHOR6
	ldr	x0, [x2, x0]
	str	w1, [x0, 336]
	ret
	.size	NandcRandmzSel, .-NandcRandmzSel
	.section	.text.NandcTimeCfg,"ax",@progbits
	.align	2
	.global	NandcTimeCfg
	.type	NandcTimeCfg, %function
NandcTimeCfg:
	cmp	w0, 35
	adrp	x1, .LANCHOR19
	bhi	.L249
	ldr	x0, [x1, #:lo12:.LANCHOR19]
	mov	w1, 4193
.L252:
	str	w1, [x0, 4]
	ret
.L249:
	cmp	w0, 99
	ldr	x0, [x1, #:lo12:.LANCHOR19]
	bls	.L251
	mov	w1, 8322
	b	.L252
.L251:
	mov	w1, 4225
	b	.L252
	.size	NandcTimeCfg, .-NandcTimeCfg
	.section	.text.FlashTimingCfg,"ax",@progbits
	.align	2
	.global	FlashTimingCfg
	.type	FlashTimingCfg, %function
FlashTimingCfg:
	adrp	x0, .LANCHOR31+21
	ldrb	w0, [x0, #:lo12:.LANCHOR31+21]
	b	NandcTimeCfg
	.size	FlashTimingCfg, .-FlashTimingCfg
	.section	.text.NandcBchSel,"ax",@progbits
	.align	2
	.global	NandcBchSel
	.type	NandcBchSel, %function
NandcBchSel:
	adrp	x1, .LANCHOR19
	and	w0, w0, 255
	cmp	w0, 16
	ldr	x2, [x1, #:lo12:.LANCHOR19]
	mov	w1, 1
	str	w1, [x2, 8]
	adrp	x1, .LANCHOR32
	str	w0, [x1, #:lo12:.LANCHOR32]
	mov	w1, 4096
	bne	.L255
.L258:
	and	w1, w1, -17
.L256:
	orr	w1, w1, 1
	str	w1, [x2, 12]
	ret
.L255:
	cmp	w0, 24
	bne	.L257
	orr	w1, w1, 16
	b	.L256
.L257:
	orr	w1, w1, 262144
	cmp	w0, 40
	orr	w1, w1, 16
	bne	.L256
	b	.L258
	.size	NandcBchSel, .-NandcBchSel
	.section	.text.FlashBchSel,"ax",@progbits
	.align	2
	.global	FlashBchSel
	.type	FlashBchSel, %function
FlashBchSel:
	adrp	x1, .LANCHOR33
	and	w0, w0, 255
	strb	w0, [x1, #:lo12:.LANCHOR33]
	b	NandcBchSel
	.size	FlashBchSel, .-FlashBchSel
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
	.section	.text.NandcSendDumpDataStart,"ax",@progbits
	.align	2
	.global	NandcSendDumpDataStart
	.type	NandcSendDumpDataStart, %function
NandcSendDumpDataStart:
	sub	sp, sp, #16
	ldr	w2, [x0, 16]
	mov	w1, 1066
	movk	w1, 0x2020, lsl 16
	str	w2, [sp, 8]
	ldr	w2, [sp, 8]
	and	w2, w2, -5
	str	w2, [sp, 8]
	ldr	w2, [sp, 8]
	str	w2, [x0, 16]
	str	w1, [x0, 8]
	orr	w1, w1, 4
	str	w1, [x0, 8]
	add	sp, sp, 16
	ret
	.size	NandcSendDumpDataStart, .-NandcSendDumpDataStart
	.section	.text.NandcSendDumpDataDone,"ax",@progbits
	.align	2
	.global	NandcSendDumpDataDone
	.type	NandcSendDumpDataDone, %function
NandcSendDumpDataDone:
	sub	sp, sp, #16
.L272:
	ldr	w1, [x0, 8]
	str	w1, [sp, 8]
	ldr	w1, [sp, 8]
	tbz	x1, 20, .L272
	add	sp, sp, 16
	ret
	.size	NandcSendDumpDataDone, .-NandcSendDumpDataDone
	.section	.text.NandcXferStart,"ax",@progbits
	.align	2
	.global	NandcXferStart
	.type	NandcXferStart, %function
NandcXferStart:
	stp	x29, x30, [sp, -96]!
	ubfiz	x0, x0, 4, 8
	ubfx	x3, x3, 1, 7
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w24, w1, 255
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	add	x6, x1, x0
	stp	x21, x22, [sp, 32]
	stp	x19, x20, [sp, 16]
	ubfiz	w19, w24, 1, 1
	ldr	x21, [x1, x0]
	mov	w1, 16
	ldrb	w0, [x6, 8]
	orr	w19, w19, 8
	str	x25, [sp, 64]
	ldr	w22, [x21, 12]
	bfi	w22, w1, 8, 8
	and	w22, w22, -9
	bfi	w22, w0, 5, 3
	mov	w0, 1
	bfi	w19, w0, 5, 2
	adrp	x0, .LANCHOR34
	orr	w19, w19, 536870912
	orr	w19, w19, 1024
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	bfi	w19, w3, 4, 1
	cmp	w0, 3
	bls	.L277
	ldr	w0, [x21, 16]
	cmp	x5, 0
	str	w0, [x29, 88]
	ccmp	x4, 0, 0, eq
	ldr	w0, [x29, 88]
	and	w0, w0, -5
	str	w0, [x29, 88]
	beq	.L278
	and	w2, w2, 255
	adrp	x20, .LANCHOR35
	cbnz	w24, .L279
.L287:
	ldr	x0, [x20, #:lo12:.LANCHOR35]
	add	w2, w2, 1
	cmp	x4, 0
	asr	w2, w2, 1
	csel	x0, x4, x0, ne
	add	x20, x20, :lo12:.LANCHOR35
	bfi	w19, w2, 22, 6
	and	x2, x0, 4294967295
	add	x2, x2, 63
	mov	x25, x4
	and	x2, x2, -64
	ldr	x1, [x20, 8]
	ubfx	x23, x19, 22, 5
	stp	x0, x1, [x20, 16]
	stp	w0, w1, [x20, 32]
	ubfiz	x1, x23, 10, 5
	add	x1, x2, x1
	and	x0, x0, 4294967232
	bl	flush_dcache_range
	ubfiz	x23, x23, 7, 5
	ldr	w0, [x20, 36]
	add	x1, x0, 63
	and	x0, x0, 4294967232
	and	x1, x1, -64
	add	x1, x1, x23
	bl	flush_dcache_range
	mov	w0, 1
	str	w0, [x20, 40]
	ldr	w0, [x20, 32]
	mov	w1, 16
	str	w0, [x21, 20]
	tst	x25, 3
	ldr	w0, [x20, 36]
	str	w0, [x21, 24]
	str	wzr, [x29, 88]
	ldr	w0, [x29, 88]
	bfi	w0, w1, 9, 5
	str	w0, [x29, 88]
	ldr	w0, [x29, 88]
	orr	w0, w0, 448
	str	w0, [x29, 88]
	bne	.L288
	ldr	w0, [x29, 88]
	mov	w1, 2
	bfi	w0, w1, 3, 3
	str	w0, [x29, 88]
.L288:
	ldr	w0, [x29, 88]
	cmp	w24, 0
	cset	w1, eq
	orr	w0, w0, 4
	str	w0, [x29, 88]
	ldr	w0, [x29, 88]
	bfi	w0, w1, 1, 1
	str	w0, [x29, 88]
	ldr	w0, [x29, 88]
	orr	w0, w0, 1
	str	w0, [x29, 88]
.L278:
	ldr	w0, [x29, 88]
	str	w0, [x21, 16]
.L277:
	str	w22, [x21, 12]
	str	w19, [x21, 8]
	orr	w19, w19, 4
	str	w19, [x21, 8]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L279:
	adrp	x0, .LANCHOR32
	mov	w6, 64
	lsr	w11, w2, 1
	mov	x1, x5
	ldr	w0, [x0, #:lo12:.LANCHOR32]
	mov	w7, 0
	mov	w3, 0
	mov	w12, -1
	cmp	w0, 25
	mov	w0, 128
	csel	w6, w6, w0, cc
	add	x0, x20, :lo12:.LANCHOR35
	ldr	x10, [x0, 8]
.L283:
	cmp	w3, w11
	bcs	.L287
	lsr	w0, w7, 2
	lsl	w0, w0, 2
	cbz	x5, .L284
	ldrh	w13, [x1]
	add	x1, x1, 4
	ldrh	w8, [x1, -2]
	orr	x8, x13, x8, lsl 16
	str	w8, [x10, x0]
.L285:
	add	w3, w3, 1
	add	w7, w7, w6
	b	.L283
.L284:
	str	w12, [x10, x0]
	b	.L285
	.size	NandcXferStart, .-NandcXferStart
	.section	.text.NandcXferComp,"ax",@progbits
	.align	2
	.global	NandcXferComp
	.type	NandcXferComp, %function
NandcXferComp:
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	ldr	x3, [x1, x0]
	adrp	x0, .LANCHOR34
	ldr	w2, [x0, #:lo12:.LANCHOR34]
	cmp	w2, 3
	bls	.L316
	ldr	w0, [x3, 16]
	tbz	x0, 2, .L316
	ldr	w0, [x3, 16]
	tbz	x0, 1, .L304
	ldr	w0, [x3, 8]
	str	w0, [x29, 16]
.L299:
	ldr	w1, [x3, 28]
	ldr	w0, [x29, 16]
	ubfx	x1, x1, 16, 5
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L300
	cmp	w2, 5
	bls	.L299
	ldr	w0, [x3]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbz	x0, 13, .L299
	ldr	w0, [x29, 24]
	tbz	x0, 17, .L299
.L300:
	adrp	x0, .LANCHOR35+40
	str	wzr, [x0, #:lo12:.LANCHOR35+40]
.L295:
	ldp	x29, x30, [sp], 32
	ret
.L304:
	ldr	w0, [x3, 8]
	str	w0, [x29, 16]
	ldr	w0, [x29, 16]
	tbz	x0, 20, .L304
	adrp	x0, .LANCHOR36
	mov	x4, x0
	ldr	w1, [x0, #:lo12:.LANCHOR36]
	cbz	w1, .L305
	mov	x0, x3
	bl	NandcSendDumpDataStart
.L305:
	ldr	w0, [x4, #:lo12:.LANCHOR36]
	cbz	w0, .L300
	mov	x0, x3
	bl	NandcSendDumpDataDone
	b	.L300
.L316:
	ldr	w0, [x3, 8]
	str	w0, [x29, 16]
	ldr	w0, [x29, 16]
	tbz	x0, 20, .L316
	b	.L295
	.size	NandcXferComp, .-NandcXferComp
	.section	.text.Ftl_log2,"ax",@progbits
	.align	2
	.global	Ftl_log2
	.type	Ftl_log2, %function
Ftl_log2:
	mov	w2, 1
	mov	w1, 0
.L325:
	cmp	w2, w0
	bls	.L326
	sub	w0, w1, #1
	ret
.L326:
	add	w1, w1, 1
	lsl	w2, w2, 1
	and	w1, w1, 65535
	b	.L325
	.size	Ftl_log2, .-Ftl_log2
	.section	.text.FtlPrintInfo,"ax",@progbits
	.align	2
	.global	FtlPrintInfo
	.type	FtlPrintInfo, %function
FtlPrintInfo:
	ret
	.size	FtlPrintInfo, .-FtlPrintInfo
	.section	.text.FtlSysBlkNumInit,"ax",@progbits
	.align	2
	.global	FtlSysBlkNumInit
	.type	FtlSysBlkNumInit, %function
FtlSysBlkNumInit:
	and	w0, w0, 65535
	mov	w1, 24
	cmp	w0, 24
	adrp	x2, .LANCHOR39
	csel	w0, w0, w1, cs
	adrp	x1, .LANCHOR37
	and	w0, w0, 65535
	str	w0, [x1, #:lo12:.LANCHOR37]
	adrp	x1, .LANCHOR38
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	mul	w1, w1, w0
	str	w1, [x2, #:lo12:.LANCHOR39]
	adrp	x2, .LANCHOR41
	ldrh	w2, [x2, #:lo12:.LANCHOR41]
	sub	w0, w2, w0
	adrp	x2, .LANCHOR40
	strh	w0, [x2, #:lo12:.LANCHOR40]
	adrp	x0, .LANCHOR43
	ldr	w0, [x0, #:lo12:.LANCHOR43]
	sub	w1, w0, w1
	adrp	x0, .LANCHOR42
	str	w1, [x0, #:lo12:.LANCHOR42]
	mov	w0, 0
	ret
	.size	FtlSysBlkNumInit, .-FtlSysBlkNumInit
	.section	.text.FtlConstantsInit,"ax",@progbits
	.align	2
	.global	FtlConstantsInit
	.type	FtlConstantsInit, %function
FtlConstantsInit:
	stp	x29, x30, [sp, -32]!
	mov	x5, x0
	adrp	x1, .LANCHOR46
	adrp	x4, .LANCHOR45
	add	x29, sp, 0
	ldrh	w11, [x0, 8]
	adrp	x0, .LANCHOR44
	adrp	x6, .LANCHOR41
	ldrh	w2, [x5, 10]
	strh	w11, [x0, #:lo12:.LANCHOR44]
	mov	x3, 0
	ldrh	w0, [x5, 12]
	ldrh	w8, [x5, 14]
	strh	w0, [x1, #:lo12:.LANCHOR46]
	adrp	x1, .LANCHOR47
	add	x7, x1, :lo12:.LANCHOR47
	strh	w2, [x4, #:lo12:.LANCHOR45]
	strh	w8, [x6, #:lo12:.LANCHOR41]
	str	x19, [sp, 16]
.L330:
	strb	w3, [x3, x7]
	add	x3, x3, 1
	cmp	x3, 32
	bne	.L330
	ldrh	w7, [x5, 20]
	ldrb	w3, [x5, 15]
	cmp	w7, w3
	bcs	.L331
	and	w13, w0, 255
	mul	w15, w0, w2
	ubfiz	w14, w13, 1, 7
	add	x1, x1, :lo12:.LANCHOR47
	mov	w7, 0
.L332:
	cmp	w7, w0
	bcs	.L334
	and	w3, w7, 255
	mov	w10, w7
	mov	w12, 0
	b	.L335
.L333:
	add	w16, w15, w10
	strb	w3, [x1, w10, uxtw]
	add	w17, w13, w3
	add	w3, w14, w3
	add	w12, w12, 1
	and	w3, w3, 255
	add	w10, w10, w0
	strb	w17, [x1, x16]
.L335:
	cmp	w12, w2
	bcc	.L333
	add	w7, w7, 1
	b	.L332
.L334:
	ubfiz	w2, w2, 1, 15
	lsr	w8, w8, 1
	strh	w2, [x4, #:lo12:.LANCHOR45]
	strh	w8, [x6, #:lo12:.LANCHOR41]
.L331:
	adrp	x1, .LANCHOR48
	adrp	x13, .LANCHOR49
	mov	w2, 5
	cmp	w11, 1
	strh	w2, [x1, #:lo12:.LANCHOR48]
	strh	wzr, [x13, #:lo12:.LANCHOR49]
	bne	.L336
	strh	w11, [x1, #:lo12:.LANCHOR48]
.L336:
	adrp	x8, .LANCHOR50
	mov	w1, 4352
	strh	w1, [x8, #:lo12:.LANCHOR50]
	adrp	x1, .LANCHOR1
	ldrb	w11, [x1, #:lo12:.LANCHOR1]
	cbz	w11, .L337
	mov	w1, 384
	strh	w1, [x8, #:lo12:.LANCHOR50]
.L337:
	ldrh	w4, [x4, #:lo12:.LANCHOR45]
	adrp	x1, .LANCHOR38
	ldrh	w3, [x6, #:lo12:.LANCHOR41]
	mul	w4, w0, w4
	mul	w0, w0, w3
	and	w4, w4, 65535
	strh	w4, [x1, #:lo12:.LANCHOR38]
	adrp	x1, .LANCHOR51
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR51]
	bl	Ftl_log2
	ldrh	w19, [x5, 16]
	adrp	x1, .LANCHOR52
	ldrh	w10, [x5, 20]
	adrp	x7, .LANCHOR53
	strh	w0, [x1, #:lo12:.LANCHOR52]
	adrp	x0, .LANCHOR54
	ldrh	w14, [x5, 18]
	adrp	x15, .LANCHOR56
	mul	w1, w4, w19
	strh	w14, [x0, #:lo12:.LANCHOR54]
	adrp	x0, .LANCHOR55
	strh	w19, [x7, #:lo12:.LANCHOR53]
	strh	w10, [x15, #:lo12:.LANCHOR56]
	strh	w1, [x0, #:lo12:.LANCHOR55]
	mov	w0, w10
	bl	Ftl_log2
	and	w12, w0, 65535
	adrp	x6, .LANCHOR57
	ubfiz	w2, w10, 9, 7
	ldrh	w1, [x5, 26]
	cmp	w3, 1024
	strh	w0, [x6, #:lo12:.LANCHOR57]
	adrp	x0, .LANCHOR58
	strh	w2, [x0, #:lo12:.LANCHOR58]
	adrp	x0, .LANCHOR59
	ubfx	w2, w2, 8, 8
	strh	w2, [x0, #:lo12:.LANCHOR59]
	adrp	x0, .LANCHOR60
	strh	w1, [x0, #:lo12:.LANCHOR60]
	adrp	x0, .LANCHOR43
	mul	w1, w4, w3
	str	w1, [x0, #:lo12:.LANCHOR43]
	bls	.L338
	and	w0, w3, 255
	strh	w0, [x13, #:lo12:.LANCHOR49]
.L338:
	ldrh	w0, [x13, #:lo12:.LANCHOR49]
	adrp	x1, .LANCHOR61
	sub	w0, w3, w0
	mul	w0, w0, w4
	mul	w0, w0, w10
	mul	w0, w0, w19
	asr	w0, w0, 11
	str	w0, [x1, #:lo12:.LANCHOR61]
	ldrh	w0, [x8, #:lo12:.LANCHOR50]
	mul	w1, w14, w10
	adrp	x10, .LANCHOR62
	lsl	w0, w0, 3
	sdiv	w0, w0, w1
	and	w0, w0, 65535
	cmp	w0, 4
	bls	.L339
.L355:
	strh	w0, [x10, #:lo12:.LANCHOR62]
	cbz	w11, .L341
	mov	w0, 640
	strh	w0, [x8, #:lo12:.LANCHOR50]
.L341:
	ldrh	w0, [x8, #:lo12:.LANCHOR50]
	adrp	x1, .LANCHOR63
	lsl	w3, w3, 6
	cmp	w4, 1
	adrp	x8, .LANCHOR37
	asr	w0, w0, w12
	add	w0, w0, 2
	strh	w0, [x1, #:lo12:.LANCHOR63]
	add	w0, w12, 9
	adrp	x1, .LANCHOR65
	asr	w3, w3, w0
	adrp	x0, .LANCHOR64
	strh	w3, [x0, #:lo12:.LANCHOR64]
	and	w3, w3, 65535
	mul	w0, w4, w3
	add	w3, w3, 8
	str	w0, [x1, #:lo12:.LANCHOR65]
	ldrh	w0, [x10, #:lo12:.LANCHOR62]
	udiv	w0, w0, w4
	mov	x4, x1
	add	w3, w0, w3
	beq	.L342
.L356:
	str	w3, [x8, #:lo12:.LANCHOR37]
	ldrh	w0, [x8, #:lo12:.LANCHOR37]
	bl	FtlSysBlkNumInit
	ldr	w1, [x8, #:lo12:.LANCHOR37]
	adrp	x0, .LANCHOR66
	mov	w2, 24
	str	w1, [x0, #:lo12:.LANCHOR66]
	adrp	x0, .LANCHOR42
	ldrh	w1, [x7, #:lo12:.LANCHOR53]
	ldr	w0, [x0, #:lo12:.LANCHOR42]
	lsl	w0, w0, 2
	mul	w0, w0, w1
	ldrh	w1, [x6, #:lo12:.LANCHOR57]
	adrp	x6, .LANCHOR8
	add	w1, w1, 9
	ldrb	w6, [x6, #:lo12:.LANCHOR8]
	lsr	w0, w0, w1
	adrp	x1, .LANCHOR67
	add	w0, w0, 2
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR67]
	adrp	x1, .LANCHOR68
	strh	w2, [x1, #:lo12:.LANCHOR68]
	adrp	x1, .LANCHOR69
	ldrh	w2, [x10, #:lo12:.LANCHOR62]
	str	wzr, [x1, #:lo12:.LANCHOR69]
	add	w1, w2, 3
	strh	w1, [x10, #:lo12:.LANCHOR62]
	ldr	w1, [x4, #:lo12:.LANCHOR65]
	add	w3, w1, 3
	str	w3, [x4, #:lo12:.LANCHOR65]
	cbz	w6, .L344
	add	w1, w1, 5
	add	w2, w2, 4
	strh	w2, [x10, #:lo12:.LANCHOR62]
.L357:
	str	w1, [x4, #:lo12:.LANCHOR65]
.L345:
	adrp	x1, .LANCHOR40
	adrp	x3, .LANCHOR70
	ldrh	w1, [x1, #:lo12:.LANCHOR40]
	strh	wzr, [x3, #:lo12:.LANCHOR70]
	lsl	w2, w1, 1
	lsr	w1, w1, 3
	add	w2, w2, 48
	add	w1, w1, 4
	add	w0, w2, w0, lsl 2
	add	w0, w0, w1
	ldrh	w1, [x15, #:lo12:.LANCHOR56]
	cmp	w0, w1, lsl 9
	bcs	.L346
	mov	w0, 1
	strh	w0, [x3, #:lo12:.LANCHOR70]
.L346:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L339:
	mov	w0, 4
	b	.L355
.L342:
	add	w3, w3, 4
	b	.L356
.L344:
	cmp	w3, 7
	bhi	.L345
	mov	w1, 8
	b	.L357
	.size	FtlConstantsInit, .-FtlConstantsInit
	.section	.text.IsBlkInVendorPart,"ax",@progbits
	.align	2
	.global	IsBlkInVendorPart
	.type	IsBlkInVendorPart, %function
IsBlkInVendorPart:
	adrp	x1, .LANCHOR71
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR71]
	cbz	w1, .L362
	adrp	x1, .LANCHOR62
	ldrh	w2, [x1, #:lo12:.LANCHOR62]
	adrp	x1, .LANCHOR72
	ldr	x3, [x1, #:lo12:.LANCHOR72]
	mov	x1, 0
.L360:
	cmp	w2, w1, uxth
	bhi	.L361
.L362:
	mov	w0, 0
	ret
.L361:
	add	x1, x1, 1
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L360
	mov	w0, 1
	ret
	.size	IsBlkInVendorPart, .-IsBlkInVendorPart
	.section	.text.FtlGetCap,"ax",@progbits
	.align	2
	.global	FtlGetCap
	.type	FtlGetCap, %function
FtlGetCap:
	adrp	x0, .LANCHOR69
	ldr	w0, [x0, #:lo12:.LANCHOR69]
	ret
	.size	FtlGetCap, .-FtlGetCap
	.section	.text.FtlGetCapacity,"ax",@progbits
	.align	2
	.global	FtlGetCapacity
	.type	FtlGetCapacity, %function
FtlGetCapacity:
	adrp	x0, .LANCHOR69
	ldr	w0, [x0, #:lo12:.LANCHOR69]
	ret
	.size	FtlGetCapacity, .-FtlGetCapacity
	.section	.text.ftl_get_density,"ax",@progbits
	.align	2
	.global	ftl_get_density
	.type	ftl_get_density, %function
ftl_get_density:
	adrp	x0, .LANCHOR69
	ldr	w0, [x0, #:lo12:.LANCHOR69]
	ret
	.size	ftl_get_density, .-ftl_get_density
	.section	.text.FtlGetLpn,"ax",@progbits
	.align	2
	.global	FtlGetLpn
	.type	FtlGetLpn, %function
FtlGetLpn:
	adrp	x0, .LANCHOR73
	ldr	w0, [x0, #:lo12:.LANCHOR73]
	ret
	.size	FtlGetLpn, .-FtlGetLpn
	.section	.text.FtlGetCurEraseBlock,"ax",@progbits
	.align	2
	.global	FtlGetCurEraseBlock
	.type	FtlGetCurEraseBlock, %function
FtlGetCurEraseBlock:
	adrp	x0, .LANCHOR38
	ldrh	w1, [x0, #:lo12:.LANCHOR38]
	adrp	x0, .LANCHOR74
	ldr	w0, [x0, #:lo12:.LANCHOR74]
	mul	w0, w1, w0
	ret
	.size	FtlGetCurEraseBlock, .-FtlGetCurEraseBlock
	.section	.text.FtlGetAllBlockNum,"ax",@progbits
	.align	2
	.global	FtlGetAllBlockNum
	.type	FtlGetAllBlockNum, %function
FtlGetAllBlockNum:
	adrp	x0, .LANCHOR41
	ldrh	w1, [x0, #:lo12:.LANCHOR41]
	adrp	x0, .LANCHOR38
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	mul	w0, w1, w0
	ret
	.size	FtlGetAllBlockNum, .-FtlGetAllBlockNum
	.section	.text.FtlBbmMapBadBlock,"ax",@progbits
	.align	2
	.global	FtlBbmMapBadBlock
	.type	FtlBbmMapBadBlock, %function
FtlBbmMapBadBlock:
	stp	x29, x30, [sp, -32]!
	and	w1, w0, 65535
	adrp	x0, .LANCHOR51
	mov	w4, 1
	add	x29, sp, 0
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR75
	add	x19, x19, :lo12:.LANCHOR75
	udiv	w3, w1, w0
	and	w2, w3, 65535
	msub	w3, w3, w0, w1
	add	x0, x19, x2, uxth 3
	and	w3, w3, 65535
	and	w6, w3, 31
	ldr	x0, [x0, 32]
	ubfx	x5, x3, 5, 11
	lsl	x5, x5, 2
	lsl	w4, w4, w6
	ldr	w6, [x0, x5]
	orr	w4, w4, w6
	str	w4, [x0, x5]
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	ldrh	w0, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 6]
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FtlBbmMapBadBlock, .-FtlBbmMapBadBlock
	.section	.text.FtlBbmIsBadBlock,"ax",@progbits
	.align	2
	.global	FtlBbmIsBadBlock
	.type	FtlBbmIsBadBlock, %function
FtlBbmIsBadBlock:
	adrp	x1, .LANCHOR51
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR51]
	udiv	w2, w0, w1
	msub	w0, w2, w1, w0
	adrp	x1, .LANCHOR75
	add	x1, x1, :lo12:.LANCHOR75
	add	x2, x1, x2, uxth 3
	and	w0, w0, 65535
	ubfx	x3, x0, 5, 11
	and	w0, w0, 31
	ldr	x1, [x2, 32]
	ldr	w1, [x1, x3, lsl 2]
	lsr	w0, w1, w0
	and	w0, w0, 1
	ret
	.size	FtlBbmIsBadBlock, .-FtlBbmIsBadBlock
	.section	.text.FtlBbtInfoPrint,"ax",@progbits
	.align	2
	.global	FtlBbtInfoPrint
	.type	FtlBbtInfoPrint, %function
FtlBbtInfoPrint:
	ret
	.size	FtlBbtInfoPrint, .-FtlBbtInfoPrint
	.section	.text.V2P_block,"ax",@progbits
	.align	2
	.global	V2P_block
	.type	V2P_block, %function
V2P_block:
	adrp	x2, .LANCHOR46
	and	w0, w0, 65535
	adrp	x4, .LANCHOR51
	and	w1, w1, 65535
	ldrh	w2, [x2, #:lo12:.LANCHOR46]
	ldrh	w4, [x4, #:lo12:.LANCHOR51]
	udiv	w3, w0, w2
	msub	w0, w3, w2, w0
	madd	w2, w2, w1, w0
	madd	w0, w3, w4, w2
	ret
	.size	V2P_block, .-V2P_block
	.section	.text.P2V_plane,"ax",@progbits
	.align	2
	.global	P2V_plane
	.type	P2V_plane, %function
P2V_plane:
	and	w3, w0, 65535
	adrp	x0, .LANCHOR46
	ldrh	w1, [x0, #:lo12:.LANCHOR46]
	adrp	x0, .LANCHOR51
	ldrh	w2, [x0, #:lo12:.LANCHOR51]
	udiv	w0, w3, w1
	udiv	w2, w3, w2
	msub	w0, w0, w1, w3
	madd	w0, w1, w2, w0
	ret
	.size	P2V_plane, .-P2V_plane
	.section	.text.P2V_block_in_plane,"ax",@progbits
	.align	2
	.global	P2V_block_in_plane
	.type	P2V_block_in_plane, %function
P2V_block_in_plane:
	and	w2, w0, 65535
	adrp	x0, .LANCHOR51
	ldrh	w1, [x0, #:lo12:.LANCHOR51]
	udiv	w0, w2, w1
	msub	w0, w0, w1, w2
	adrp	x1, .LANCHOR46
	ldrh	w1, [x1, #:lo12:.LANCHOR46]
	and	w0, w0, 65535
	udiv	w0, w0, w1
	ret
	.size	P2V_block_in_plane, .-P2V_block_in_plane
	.section	.text.ftl_cmp_data_ver,"ax",@progbits
	.align	2
	.global	ftl_cmp_data_ver
	.type	ftl_cmp_data_ver, %function
ftl_cmp_data_ver:
	cmp	w0, w1
	mov	w2, -2147483648
	bls	.L378
	sub	w1, w0, w1
	cmp	w1, w2
	cset	w0, ls
	ret
.L378:
	sub	w1, w1, w0
	cmp	w1, w2
	cset	w0, hi
	ret
	.size	ftl_cmp_data_ver, .-ftl_cmp_data_ver
	.section	.text.FtlFreeSysBlkQueueEmpty,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueEmpty
	.type	FtlFreeSysBlkQueueEmpty, %function
FtlFreeSysBlkQueueEmpty:
	adrp	x0, .LANCHOR76+6
	ldrh	w0, [x0, #:lo12:.LANCHOR76+6]
	cmp	w0, 0
	cset	w0, eq
	ret
	.size	FtlFreeSysBlkQueueEmpty, .-FtlFreeSysBlkQueueEmpty
	.section	.text.FtlFreeSysBlkQueueFull,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueFull
	.type	FtlFreeSysBlkQueueFull, %function
FtlFreeSysBlkQueueFull:
	adrp	x0, .LANCHOR76+6
	ldrh	w0, [x0, #:lo12:.LANCHOR76+6]
	cmp	w0, 1024
	cset	w0, eq
	ret
	.size	FtlFreeSysBlkQueueFull, .-FtlFreeSysBlkQueueFull
	.section	.text.FtlFreeSysBlkQueueIn,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueIn
	.type	FtlFreeSysBlkQueueIn, %function
FtlFreeSysBlkQueueIn:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 65535
	str	x21, [sp, 32]
	sub	w2, w20, #1
	mov	w0, 65533
	cmp	w0, w2, uxth
	bcc	.L382
	adrp	x0, .LANCHOR76
	add	x2, x0, :lo12:.LANCHOR76
	mov	x19, x0
	ldrh	w2, [x2, 6]
	cmp	w2, 1024
	beq	.L382
	and	w1, w1, 65535
	cbz	w1, .L384
	adrp	x0, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	cbnz	w0, .L384
	mov	w0, w20
	bl	P2V_block_in_plane
	and	w21, w0, 65535
	adrp	x0, .LANCHOR78
	lsl	w1, w20, 10
	mov	w2, 1
	ldr	x0, [x0, #:lo12:.LANCHOR78]
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
	adrp	x1, .LANCHOR79
	ubfiz	x0, x21, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR79]
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	adrp	x1, .LANCHOR80
	ldr	w0, [x1, #:lo12:.LANCHOR80]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR80]
.L384:
	add	x0, x19, :lo12:.LANCHOR76
	ldrh	w1, [x0, 6]
	add	w1, w1, 1
	strh	w1, [x0, 6]
	ldrh	w1, [x0, 4]
	add	x2, x0, x1, sxtw 1
	add	w1, w1, 1
	and	w1, w1, 1023
	strh	w1, [x0, 4]
	strh	w20, [x2, 8]
.L382:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
	.size	FtlFreeSysBlkQueueIn, .-FtlFreeSysBlkQueueIn
	.section	.text.FtlFreeSysBLkSort,"ax",@progbits
	.align	2
	.global	FtlFreeSysBLkSort
	.type	FtlFreeSysBLkSort, %function
FtlFreeSysBLkSort:
	adrp	x0, .LANCHOR76
	add	x1, x0, :lo12:.LANCHOR76
	ldrh	w2, [x1, 6]
	cbz	w2, .L392
	adrp	x2, .LANCHOR81+28
	ldrh	w3, [x1, 2]
	mov	w6, 0
	mov	w4, 0
	ldrh	w5, [x2, #:lo12:.LANCHOR81+28]
	ldrh	w2, [x1, 4]
	and	w5, w5, 31
.L394:
	cmp	w5, w4
	bgt	.L395
	cbz	w6, .L392
	add	x0, x0, :lo12:.LANCHOR76
	strh	w3, [x0, 2]
	strh	w2, [x0, 4]
.L392:
	ret
.L395:
	add	x6, x1, x3, sxtw 1
	add	w4, w4, 1
	add	w3, w3, 1
	and	w4, w4, 65535
	and	w3, w3, 1023
	ldrh	w7, [x6, 8]
	add	x6, x1, x2, sxtw 1
	strh	w7, [x6, 8]
	mov	w6, 1
	add	w2, w2, w6
	and	w2, w2, 1023
	b	.L394
	.size	FtlFreeSysBLkSort, .-FtlFreeSysBLkSort
	.section	.text.FtlFreeSysBlkQueueOut,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueOut
	.type	FtlFreeSysBlkQueueOut, %function
FtlFreeSysBlkQueueOut:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR76
	add	x19, x19, :lo12:.LANCHOR76
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR77
	mov	x23, x19
	add	x22, x22, :lo12:.LANCHOR77
.L402:
	ldrh	w1, [x19, 6]
	cbz	w1, .L403
	ldrh	w0, [x19, 2]
	sub	w1, w1, #1
	strh	w1, [x19, 6]
	add	x2, x19, x0, sxtw 1
	add	w0, w0, 1
	and	w0, w0, 1023
	strh	w0, [x19, 2]
	ldr	w0, [x22]
	ldrh	w20, [x2, 8]
	cbnz	w0, .L404
	mov	w0, w20
	bl	P2V_block_in_plane
	adrp	x1, .LANCHOR78
	and	w21, w0, 65535
	lsl	w2, w20, 10
	mov	x24, x1
	ldr	x0, [x1, #:lo12:.LANCHOR78]
	str	w2, [x0, 4]
	adrp	x2, .LANCHOR8
	ldrb	w2, [x2, #:lo12:.LANCHOR8]
	cbz	w2, .L405
	mov	w2, 1
	mov	w1, 0
	bl	FlashEraseBlocks
.L405:
	ldr	x0, [x24, #:lo12:.LANCHOR78]
	mov	w2, 1
	mov	w1, w2
	bl	FlashEraseBlocks
	adrp	x1, .LANCHOR79
	ubfiz	x0, x21, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR79]
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	adrp	x1, .LANCHOR80
	ldr	w0, [x1, #:lo12:.LANCHOR80]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR80]
.L404:
	sub	w0, w20, #1
	mov	w1, 65533
	cmp	w1, w0, uxth
	bcs	.L407
	ldrh	w2, [x23, 6]
	mov	w1, w20
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	b	.L402
.L403:
	adrp	x0, .LC3
	mov	w1, 0
	add	x0, x0, :lo12:.LC3
	bl	printf
.L406:
	b	.L406
.L407:
	mov	w0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
	.size	FtlFreeSysBlkQueueOut, .-FtlFreeSysBlkQueueOut
	.section	.text.test_node_in_list,"ax",@progbits
	.align	2
	.global	test_node_in_list
	.type	test_node_in_list, %function
test_node_in_list:
	ldr	x2, [x0]
	adrp	x0, .LANCHOR82
	mov	x4, -6148914691236517206
	and	w1, w1, 65535
	ldr	x3, [x0, #:lo12:.LANCHOR82]
	movk	x4, 0xaaab, lsl 0
	mov	w5, 65535
	sub	x0, x2, x3
	asr	x0, x0, 1
	mul	x0, x0, x4
	mov	w4, 6
	and	w0, w0, 65535
.L414:
	cmp	w0, w1
	beq	.L415
	ldrh	w0, [x2]
	cmp	w0, w5
	beq	.L416
	umaddl	x2, w0, w4, x3
	b	.L414
.L415:
	mov	w0, 1
	ret
.L416:
	mov	w0, 0
	ret
	.size	test_node_in_list, .-test_node_in_list
	.section	.text.insert_data_list,"ax",@progbits
	.align	2
	.global	insert_data_list
	.type	insert_data_list, %function
insert_data_list:
	adrp	x1, .LANCHOR40
	and	w0, w0, 65535
	ldrh	w14, [x1, #:lo12:.LANCHOR40]
	cmp	w14, w0
	bls	.L433
	adrp	x1, .LANCHOR82
	mov	w3, 6
	ldr	x6, [x1, #:lo12:.LANCHOR82]
	umull	x13, w0, w3
	mov	w1, -1
	add	x5, x6, x13
	strh	w1, [x5, 2]
	strh	w1, [x6, x13]
	adrp	x1, .LANCHOR83
	mov	x15, x1
	ldr	x12, [x1, #:lo12:.LANCHOR83]
	cbnz	x12, .L420
	str	x5, [x1, #:lo12:.LANCHOR83]
.L433:
	mov	w0, 0
	ret
.L420:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR84
	ubfiz	x2, x0, 1, 16
	mov	x4, -6148914691236517206
	add	x29, sp, 0
	ldr	x16, [x1, #:lo12:.LANCHOR84]
	movk	x4, 0xaaab, lsl 0
	ldrh	w1, [x5, 4]
	mov	w8, -1
	mov	w11, w8
	stp	x19, x20, [sp, 16]
	cmp	w1, 0
	mov	w20, 65535
	ldrh	w7, [x16, x2]
	mul	w7, w7, w1
	sub	x1, x12, x6
	asr	x1, x1, 1
	csel	w7, w7, w8, ne
	mov	w8, w3
	mul	x1, x1, x4
	adrp	x4, .LANCHOR79
	ldr	x17, [x4, #:lo12:.LANCHOR79]
	and	w1, w1, 65535
	mov	x4, x12
	add	x10, x17, x2
	mov	w2, 0
.L428:
	add	w2, w2, 1
	and	w2, w2, 65535
	cmp	w14, w2
	bcc	.L419
	cmp	w1, w0
	beq	.L419
	ubfiz	x30, x1, 1, 16
	ldrh	w19, [x4, 4]
	cmp	w19, 0
	ldrh	w3, [x16, x30]
	mul	w3, w3, w19
	csel	w3, w3, w11, ne
	cmp	w7, w3
	bne	.L424
	ldrh	w19, [x17, x30]
	ldrh	w3, [x10]
	cmp	w19, w3
	bcc	.L426
.L425:
	strh	w1, [x6, x13]
	cmp	x4, x12
	ldrh	w1, [x4, 2]
	strh	w1, [x5, 2]
	bne	.L429
	strh	w0, [x4, 2]
	str	x5, [x15, #:lo12:.LANCHOR83]
	b	.L419
.L424:
	bcc	.L425
.L426:
	ldrh	w3, [x4]
	cmp	w3, w20
	bne	.L427
	strh	w1, [x5, 2]
	strh	w0, [x4]
	adrp	x0, .LANCHOR85
	str	x5, [x0, #:lo12:.LANCHOR85]
.L419:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L427:
	umaddl	x4, w3, w8, x6
	mov	w1, w3
	b	.L428
.L429:
	ldrh	w1, [x4, 2]
	mov	w2, 6
	umull	x1, w1, w2
	strh	w0, [x6, x1]
	strh	w0, [x4, 2]
	b	.L419
	.size	insert_data_list, .-insert_data_list
	.section	.text.INSERT_DATA_LIST,"ax",@progbits
	.align	2
	.global	INSERT_DATA_LIST
	.type	INSERT_DATA_LIST, %function
INSERT_DATA_LIST:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	insert_data_list
	adrp	x1, .LANCHOR86
	ldrh	w0, [x1, #:lo12:.LANCHOR86]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR86]
	adrp	x1, .LANCHOR40
	ldrh	w1, [x1, #:lo12:.LANCHOR40]
	cmp	w1, w0
	bcs	.L435
	mov	w2, 210
	adrp	x1, .LANCHOR87
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR87
	add	x0, x0, :lo12:.LC5
	bl	printf
	ldp	x29, x30, [sp], 16
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	b	printf
.L435:
	ldp	x29, x30, [sp], 16
	ret
	.size	INSERT_DATA_LIST, .-INSERT_DATA_LIST
	.section	.text.insert_free_list,"ax",@progbits
	.align	2
	.global	insert_free_list
	.type	insert_free_list, %function
insert_free_list:
	and	w0, w0, 65535
	mov	w7, 65535
	cmp	w0, w7
	beq	.L439
	adrp	x1, .LANCHOR82
	mov	w6, 6
	ldr	x3, [x1, #:lo12:.LANCHOR82]
	umull	x8, w0, w6
	mov	w1, -1
	add	x4, x3, x8
	strh	w1, [x4, 2]
	strh	w1, [x3, x8]
	adrp	x1, .LANCHOR88
	mov	x12, x1
	ldr	x5, [x1, #:lo12:.LANCHOR88]
	cbnz	x5, .L440
	str	x4, [x1, #:lo12:.LANCHOR88]
.L439:
	mov	w0, 0
	ret
.L440:
	adrp	x1, .LANCHOR79
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	ldr	x11, [x1, #:lo12:.LANCHOR79]
	ubfiz	x1, x0, 1, 16
	ldrh	w13, [x11, x1]
	sub	x1, x5, x3
	asr	x1, x1, 1
	mul	x1, x1, x2
	mov	x2, x5
	and	w1, w1, 65535
.L443:
	ubfiz	x10, x1, 1, 16
	ldrh	w10, [x11, x10]
	cmp	w10, w13
	bcs	.L441
	ldrh	w10, [x2]
	cmp	w10, w7
	bne	.L442
	strh	w1, [x4, 2]
	strh	w0, [x2]
	b	.L439
.L442:
	umaddl	x2, w10, w6, x3
	mov	w1, w10
	b	.L443
.L441:
	ldrh	w6, [x2, 2]
	cmp	x2, x5
	strh	w6, [x4, 2]
	strh	w1, [x3, x8]
	bne	.L444
	strh	w0, [x2, 2]
	str	x4, [x12, #:lo12:.LANCHOR88]
	b	.L439
.L444:
	ldrh	w1, [x2, 2]
	mov	w4, 6
	umull	x1, w1, w4
	strh	w0, [x3, x1]
	strh	w0, [x2, 2]
	b	.L439
	.size	insert_free_list, .-insert_free_list
	.section	.text.INSERT_FREE_LIST,"ax",@progbits
	.align	2
	.global	INSERT_FREE_LIST
	.type	INSERT_FREE_LIST, %function
INSERT_FREE_LIST:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	insert_free_list
	adrp	x1, .LANCHOR89
	ldrh	w0, [x1, #:lo12:.LANCHOR89]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR89]
	adrp	x1, .LANCHOR40
	ldrh	w1, [x1, #:lo12:.LANCHOR40]
	cmp	w1, w0
	bcs	.L445
	mov	w2, 203
	adrp	x1, .LANCHOR90
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LC5
	bl	printf
	ldp	x29, x30, [sp], 16
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	b	printf
.L445:
	ldp	x29, x30, [sp], 16
	ret
	.size	INSERT_FREE_LIST, .-INSERT_FREE_LIST
	.section	.text.List_remove_node,"ax",@progbits
	.align	2
	.global	List_remove_node
	.type	List_remove_node, %function
List_remove_node:
	stp	x29, x30, [sp, -64]!
	and	w1, w1, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR82
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	mov	w0, 6
	str	x23, [sp, 48]
	ldr	x23, [x20, #:lo12:.LANCHOR82]
	umull	x21, w1, w0
	mov	w0, 65535
	add	x19, x23, x21
	ldrh	w1, [x19, 2]
	cmp	w1, w0
	bne	.L449
	ldr	x0, [x22]
	cmp	x19, x0
	beq	.L449
	mov	w2, 386
	adrp	x1, .LANCHOR91
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR91
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L449:
	ldr	x0, [x22]
	mov	w1, 65535
	cmp	x19, x0
	ldrh	w0, [x23, x21]
	bne	.L450
	cmp	w0, w1
	bne	.L451
	str	xzr, [x22]
.L452:
	mov	w0, -1
	strh	w0, [x23, x21]
	strh	w0, [x19, 2]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L451:
	ldr	x1, [x20, #:lo12:.LANCHOR82]
	mov	w2, 6
	umaddl	x0, w0, w2, x1
	mov	w1, -1
	str	x0, [x22]
	strh	w1, [x0, 2]
	b	.L452
.L450:
	cmp	w0, w1
	ldrh	w1, [x19, 2]
	bne	.L453
	cmp	w1, w0
	beq	.L452
	mov	w0, 6
	mov	w2, -1
	umull	x1, w1, w0
	ldr	x0, [x20, #:lo12:.LANCHOR82]
	strh	w2, [x0, x1]
	b	.L452
.L453:
	ldr	x2, [x20, #:lo12:.LANCHOR82]
	mov	w3, 6
	umaddl	x4, w0, w3, x2
	strh	w1, [x4, 2]
	ldrh	w1, [x19, 2]
	umull	x1, w1, w3
	strh	w0, [x2, x1]
	b	.L452
	.size	List_remove_node, .-List_remove_node
	.section	.text.List_pop_index_node,"ax",@progbits
	.align	2
	.global	List_pop_index_node
	.type	List_pop_index_node, %function
List_pop_index_node:
	ldr	x2, [x0]
	cbz	x2, .L461
	stp	x29, x30, [sp, -32]!
	adrp	x3, .LANCHOR82
	and	w1, w1, 65535
	mov	w4, 65535
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	w5, 6
	ldr	x19, [x3, #:lo12:.LANCHOR82]
.L457:
	cbnz	w1, .L458
.L460:
	sub	x19, x2, x19
	mov	x2, -6148914691236517206
	asr	x19, x19, 1
	movk	x2, 0xaaab, lsl 0
	mul	x19, x19, x2
	and	w19, w19, 65535
	mov	w1, w19
	bl	List_remove_node
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L458:
	ldrh	w3, [x2]
	cmp	w3, w4
	beq	.L460
	sub	w1, w1, #1
	umaddl	x2, w3, w5, x19
	and	w1, w1, 65535
	b	.L457
.L461:
	mov	w0, 65535
	ret
	.size	List_pop_index_node, .-List_pop_index_node
	.section	.text.List_get_gc_head_node,"ax",@progbits
	.align	2
	.global	List_get_gc_head_node
	.type	List_get_gc_head_node, %function
List_get_gc_head_node:
	and	w2, w0, 65535
	adrp	x0, .LANCHOR83
	ldr	x1, [x0, #:lo12:.LANCHOR83]
	cbz	x1, .L471
	adrp	x0, .LANCHOR82
	mov	w4, 6
	ldr	x3, [x0, #:lo12:.LANCHOR82]
	mov	w0, 65535
.L468:
	cbz	w2, .L469
	ldrh	w1, [x1]
	cmp	w1, w0
	bne	.L470
	ret
.L470:
	sub	w2, w2, #1
	umaddl	x1, w1, w4, x3
	and	w2, w2, 65535
	b	.L468
.L471:
	mov	w0, 65535
	ret
.L469:
	sub	x0, x1, x3
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	and	w0, w0, 65535
	ret
	.size	List_get_gc_head_node, .-List_get_gc_head_node
	.section	.text.List_update_data_list,"ax",@progbits
	.align	2
	.global	List_update_data_list
	.type	List_update_data_list, %function
List_update_data_list:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	adrp	x0, .LANCHOR92
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	stp	x25, x26, [sp, 64]
	cmp	w0, w19
	beq	.L474
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w0, w19
	beq	.L474
	adrp	x0, .LANCHOR94
	ldrh	w0, [x0, #:lo12:.LANCHOR94]
	cmp	w0, w19
	beq	.L474
	adrp	x0, .LANCHOR82
	mov	w21, 6
	adrp	x24, .LANCHOR83
	mov	x26, x0
	umull	x21, w19, w21
	ldr	x23, [x0, #:lo12:.LANCHOR82]
	ldr	x1, [x24, #:lo12:.LANCHOR83]
	add	x22, x23, x21
	cmp	x22, x1
	beq	.L474
	adrp	x1, .LANCHOR84
	ubfiz	x0, x19, 1, 16
	mov	x25, x1
	ldr	x2, [x1, #:lo12:.LANCHOR84]
	mov	w1, 65535
	ldrh	w20, [x2, x0]
	ldrh	w0, [x22, 4]
	cmp	w0, 0
	mul	w20, w20, w0
	ldrh	w0, [x22, 2]
	csinv	w20, w20, wzr, ne
	cmp	w0, w1
	bne	.L477
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	bne	.L477
	mov	w2, 504
	adrp	x1, .LANCHOR95
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR95
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L477:
	ldrh	w0, [x22, 2]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L478
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	beq	.L474
.L478:
	mov	w1, 6
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	umull	x0, w0, w1
	asr	x1, x0, 1
	mul	x1, x1, x2
	ldr	x2, [x25, #:lo12:.LANCHOR84]
	ldrh	w1, [x2, x1, lsl 1]
	ldr	x2, [x26, #:lo12:.LANCHOR82]
	add	x0, x2, x0
	ldrh	w2, [x0, 4]
	cmp	w2, 0
	mul	w0, w1, w2
	csinv	w0, w0, wzr, ne
	cmp	w20, w0
	bcs	.L474
	adrp	x20, .LANCHOR86
	mov	w1, w19
	add	x0, x24, :lo12:.LANCHOR83
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR86]
	cbnz	w0, .L480
	mov	w2, 515
	adrp	x1, .LANCHOR95
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR95
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L480:
	ldrh	w0, [x20, #:lo12:.LANCHOR86]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR86]
	mov	w0, w19
	bl	INSERT_DATA_LIST
.L474:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
	.size	List_update_data_list, .-List_update_data_list
	.section	.text.ftl_map_blk_alloc_new_blk,"ax",@progbits
	.align	2
	.global	ftl_map_blk_alloc_new_blk
	.type	ftl_map_blk_alloc_new_blk, %function
ftl_map_blk_alloc_new_blk:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w1, [x0, 10]
	mov	w20, 0
	ldr	x0, [x0, 16]
	str	x21, [sp, 32]
.L485:
	cmp	w20, w1
	beq	.L489
	mov	x21, x0
	ldrh	w2, [x0], 2
	cbnz	w2, .L486
	bl	FtlFreeSysBlkQueueOut
	and	w1, w0, 65535
	strh	w0, [x21]
	sub	w2, w1, #1
	mov	w0, 65533
	cmp	w0, w2, uxth
	bcs	.L487
	adrp	x0, .LANCHOR76+6
	ldrh	w2, [x0, #:lo12:.LANCHOR76+6]
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
.L488:
	b	.L488
.L487:
	ldr	w0, [x19, 48]
	strh	wzr, [x19, 2]
	add	w0, w0, 1
	str	w0, [x19, 48]
	ldrh	w0, [x19, 8]
	strh	w20, [x19]
	add	w0, w0, 1
	strh	w0, [x19, 8]
.L489:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L491
	mov	w2, 629
	adrp	x1, .LANCHOR96
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR96
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L491:
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L486:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L485
	.size	ftl_map_blk_alloc_new_blk, .-ftl_map_blk_alloc_new_blk
	.section	.text.select_l2p_ram_region,"ax",@progbits
	.align	2
	.global	select_l2p_ram_region
	.type	select_l2p_ram_region, %function
select_l2p_ram_region:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR68
	mov	x1, 0
	mov	w3, 65535
	add	x29, sp, 0
	ldrh	w2, [x0, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR97
	str	x19, [sp, 16]
	ldr	x0, [x0, #:lo12:.LANCHOR97]
.L494:
	and	w19, w1, 65535
	cmp	w19, w2
	bcc	.L496
	add	x3, x0, 4
	mov	w19, w2
	mov	w5, -2147483648
	mov	w1, 0
.L497:
	cmp	w1, w2
	bne	.L499
	cmp	w19, w2
	bcc	.L495
	adrp	x1, .LANCHOR98
	mov	w19, w2
	mov	w3, -1
	ldrh	w4, [x1, #:lo12:.LANCHOR98]
	mov	w1, 0
.L500:
	cmp	w1, w2
	bne	.L502
	cmp	w19, w1
	bcc	.L495
	mov	w2, 855
	adrp	x1, .LANCHOR99
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR99
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
	b	.L495
.L496:
	add	x1, x1, 1
	add	x4, x0, x1, lsl 4
	ldrh	w4, [x4, -16]
	cmp	w4, w3
	bne	.L494
.L495:
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L499:
	ldr	w4, [x3]
	tbnz	w4, #31, .L498
	cmp	w5, w4
	bls	.L498
	mov	w5, w4
	mov	w19, w1
.L498:
	add	w1, w1, 1
	add	x3, x3, 16
	and	w1, w1, 65535
	b	.L497
.L502:
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bls	.L501
	ldrh	w5, [x0]
	cmp	w5, w4
	csel	w3, w3, w6, eq
	csel	w19, w19, w1, eq
.L501:
	add	w1, w1, 1
	add	x0, x0, 16
	and	w1, w1, 65535
	b	.L500
	.size	select_l2p_ram_region, .-select_l2p_ram_region
	.section	.text.FtlUpdateVaildLpn,"ax",@progbits
	.align	2
	.global	FtlUpdateVaildLpn
	.type	FtlUpdateVaildLpn, %function
FtlUpdateVaildLpn:
	adrp	x2, .LANCHOR100
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR100]
	cmp	w1, 4
	bhi	.L505
	cbnz	w0, .L505
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR100]
	ret
.L505:
	adrp	x1, .LANCHOR40
	adrp	x0, .LANCHOR101
	strh	wzr, [x3, #:lo12:.LANCHOR100]
	mov	w2, 0
	ldrh	w5, [x1, #:lo12:.LANCHOR40]
	adrp	x1, .LANCHOR84
	str	wzr, [x0, #:lo12:.LANCHOR101]
	mov	w3, 0
	ldr	x6, [x1, #:lo12:.LANCHOR84]
	mov	w7, 65535
	mov	x1, 0
.L506:
	cmp	w5, w1, uxth
	bhi	.L508
	cbz	w3, .L504
	str	w2, [x0, #:lo12:.LANCHOR101]
.L504:
	ret
.L508:
	ldrh	w4, [x6, x1, lsl 1]
	cmp	w4, w7
	beq	.L507
	add	w2, w2, w4
	mov	w3, 1
.L507:
	add	x1, x1, 1
	b	.L506
	.size	FtlUpdateVaildLpn, .-FtlUpdateVaildLpn
	.section	.text.ftl_set_blk_mode,"ax",@progbits
	.align	2
	.global	ftl_set_blk_mode
	.type	ftl_set_blk_mode, %function
ftl_set_blk_mode:
	and	w0, w0, 65535
	cbz	w1, .L515
	b	ftl_set_blk_mode.part.10
.L515:
	adrp	x1, .LANCHOR0
	ubfx	x2, x0, 5, 11
	lsl	x2, x2, 2
	ldr	x3, [x1, #:lo12:.LANCHOR0]
	and	w1, w0, 31
	mov	w0, 1
	lsl	w0, w0, w1
	ldr	w1, [x3, x2]
	bic	w0, w1, w0
	str	w0, [x3, x2]
	ret
	.size	ftl_set_blk_mode, .-ftl_set_blk_mode
	.section	.text.ftl_get_blk_mode,"ax",@progbits
	.align	2
	.global	ftl_get_blk_mode
	.type	ftl_get_blk_mode, %function
ftl_get_blk_mode:
	adrp	x1, .LANCHOR0
	and	w0, w0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR0]
	ubfx	x2, x0, 5, 11
	and	w0, w0, 31
	ldr	w1, [x1, x2, lsl 2]
	lsr	w0, w1, w0
	and	w0, w0, 1
	ret
	.size	ftl_get_blk_mode, .-ftl_get_blk_mode
	.section	.text.ftl_sb_update_avl_pages,"ax",@progbits
	.align	2
	.global	ftl_sb_update_avl_pages
	.type	ftl_sb_update_avl_pages, %function
ftl_sb_update_avl_pages:
	and	w2, w2, 65535
	and	w6, w1, 65535
	ubfiz	x4, x2, 1, 16
	adrp	x1, .LANCHOR38
	add	x4, x4, 16
	strh	wzr, [x0, 4]
	add	x4, x0, x4
	ldrh	w3, [x1, #:lo12:.LANCHOR38]
	mov	w1, 65535
.L518:
	cmp	w2, w3
	bcc	.L520
	adrp	x1, .LANCHOR53
	ubfiz	x3, x3, 1, 16
	add	x3, x3, 16
	add	x2, x0, 16
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	add	x3, x0, x3
	mov	w5, 65535
	sub	w1, w1, #1
	and	w1, w1, 65535
	sub	w1, w1, w6
.L521:
	cmp	x2, x3
	bne	.L523
	ret
.L520:
	ldrh	w5, [x4]
	cmp	w5, w1
	beq	.L519
	ldrh	w5, [x0, 4]
	add	w5, w5, 1
	strh	w5, [x0, 4]
.L519:
	add	w2, w2, 1
	add	x4, x4, 2
	and	w2, w2, 65535
	b	.L518
.L523:
	ldrh	w4, [x2]
	cmp	w4, w5
	beq	.L522
	ldrh	w4, [x0, 4]
	add	w4, w1, w4
	strh	w4, [x0, 4]
.L522:
	add	x2, x2, 2
	b	.L521
	.size	ftl_sb_update_avl_pages, .-ftl_sb_update_avl_pages
	.section	.text.make_superblock,"ax",@progbits
	.align	2
	.global	make_superblock
	.type	make_superblock, %function
make_superblock:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	ldrh	w1, [x0]
	str	x19, [sp, 16]
	mov	x19, x0
	adrp	x0, .LANCHOR40
	ldrh	w0, [x0, #:lo12:.LANCHOR40]
	cmp	w1, w0
	bcc	.L525
	mov	w2, 2544
	adrp	x1, .LANCHOR102
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR102
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L525:
	adrp	x0, .LANCHOR38
	adrp	x7, .LANCHOR47
	add	x6, x19, 16
	add	x7, x7, :lo12:.LANCHOR47
	ldrh	w8, [x0, #:lo12:.LANCHOR38]
	mov	x5, 0
	strh	wzr, [x19, 4]
	mov	w10, -1
	strb	wzr, [x19, 7]
.L526:
	cmp	w8, w5, uxth
	bhi	.L528
	adrp	x1, .LANCHOR53
	ldrb	w0, [x19, 7]
	strb	wzr, [x19, 9]
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	mul	w0, w0, w1
	strh	w0, [x19, 4]
	adrp	x0, .LANCHOR28
	ldr	w0, [x0, #:lo12:.LANCHOR28]
	cbz	w0, .L529
	adrp	x0, .LANCHOR79
	ldrh	w1, [x19]
	ldr	x0, [x0, #:lo12:.LANCHOR79]
	ldrh	w0, [x0, x1, lsl 1]
	cmp	w0, 79
	bhi	.L529
	mov	w0, 1
	strb	w0, [x19, 9]
.L529:
	adrp	x0, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR1]
	cbz	w0, .L530
	mov	w0, 1
	strb	w0, [x19, 9]
.L530:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L528:
	ldrh	w1, [x19]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	mov	w4, w0
	strh	w10, [x6]
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L527
	strh	w4, [x6]
	ldrb	w0, [x19, 7]
	add	w0, w0, 1
	strb	w0, [x19, 7]
.L527:
	add	x5, x5, 1
	add	x6, x6, 2
	b	.L526
	.size	make_superblock, .-make_superblock
	.section	.text.update_multiplier_value,"ax",@progbits
	.align	2
	.global	update_multiplier_value
	.type	update_multiplier_value, %function
update_multiplier_value:
	and	w6, w0, 65535
	adrp	x0, .LANCHOR38
	mov	x7, 0
	adrp	x8, .LANCHOR47
	ldrh	w10, [x0, #:lo12:.LANCHOR38]
	adrp	x0, .LANCHOR53
	mov	w5, 0
	add	x8, x8, :lo12:.LANCHOR47
	ldrh	w11, [x0, #:lo12:.LANCHOR53]
	cmp	w10, w7, uxth
	bhi	.L550
	cbz	w5, .L548
	mov	w0, 32768
	sdiv	w5, w0, w5
.L549:
	adrp	x0, .LANCHOR82
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR82]
	umaddl	x6, w6, w1, x0
	mov	w0, 0
	strh	w5, [x6, 4]
	ret
.L543:
	mov	w5, 0
	b	.L542
.L548:
	mov	w5, 0
	b	.L549
.L550:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L541:
	ldrb	w0, [x8, x7]
	mov	w1, w6
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L540
	add	w5, w5, w11
	and	w5, w5, 65535
.L540:
	add	x7, x7, 1
	cmp	w10, w7, uxth
	bhi	.L541
	cbz	w5, .L543
	mov	w0, 32768
	sdiv	w5, w0, w5
.L542:
	adrp	x0, .LANCHOR82
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR82]
	umaddl	x6, w6, w1, x0
	mov	w0, 0
	strh	w5, [x6, 4]
	ldp	x29, x30, [sp], 16
	ret
	.size	update_multiplier_value, .-update_multiplier_value
	.section	.text.GetFreeBlockMinEraseCount,"ax",@progbits
	.align	2
	.global	GetFreeBlockMinEraseCount
	.type	GetFreeBlockMinEraseCount, %function
GetFreeBlockMinEraseCount:
	adrp	x0, .LANCHOR88
	ldr	x0, [x0, #:lo12:.LANCHOR88]
	cbz	x0, .L553
	adrp	x1, .LANCHOR82
	ldr	x1, [x1, #:lo12:.LANCHOR82]
	sub	x0, x0, x1
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	adrp	x1, .LANCHOR79
	ldr	x1, [x1, #:lo12:.LANCHOR79]
	and	x0, x0, 65535
	ldrh	w0, [x1, x0, lsl 1]
	ret
.L553:
	mov	w0, 0
	ret
	.size	GetFreeBlockMinEraseCount, .-GetFreeBlockMinEraseCount
	.section	.text.GetFreeBlockMaxEraseCount,"ax",@progbits
	.align	2
	.global	GetFreeBlockMaxEraseCount
	.type	GetFreeBlockMaxEraseCount, %function
GetFreeBlockMaxEraseCount:
	adrp	x1, .LANCHOR88
	and	w0, w0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR88]
	cbz	x1, .L561
	adrp	x2, .LANCHOR89
	mov	w3, 7
	mov	w5, 6
	mov	w6, 65535
	ldrh	w2, [x2, #:lo12:.LANCHOR89]
	mul	w2, w2, w3
	asr	w2, w2, 3
	cmp	w0, w2
	csel	w0, w2, w0, gt
	adrp	x2, .LANCHOR82
	ldr	x3, [x2, #:lo12:.LANCHOR82]
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	sub	x1, x1, x3
	asr	x1, x1, 1
	mul	x1, x1, x2
	mov	w2, 0
	and	w1, w1, 65535
.L557:
	cmp	w0, w2
	beq	.L560
	umull	x4, w1, w5
	ldrh	w4, [x3, x4]
	cmp	w4, w6
	bne	.L558
.L560:
	adrp	x0, .LANCHOR79
	ubfiz	x1, x1, 1, 16
	ldr	x0, [x0, #:lo12:.LANCHOR79]
	ldrh	w0, [x0, x1]
	ret
.L558:
	add	w2, w2, 1
	mov	w1, w4
	and	w2, w2, 65535
	b	.L557
.L561:
	mov	w0, 0
	ret
	.size	GetFreeBlockMaxEraseCount, .-GetFreeBlockMaxEraseCount
	.section	.text.free_data_superblock,"ax",@progbits
	.align	2
	.global	free_data_superblock
	.type	free_data_superblock, %function
free_data_superblock:
	and	w0, w0, 65535
	mov	w1, 65535
	cmp	w0, w1
	beq	.L565
	stp	x29, x30, [sp, -16]!
	adrp	x2, .LANCHOR84
	ubfiz	x1, x0, 1, 16
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR84]
	strh	wzr, [x2, x1]
	bl	INSERT_FREE_LIST
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L565:
	mov	w0, 0
	ret
	.size	free_data_superblock, .-free_data_superblock
	.section	.text.FtlGcBufInit,"ax",@progbits
	.align	2
	.global	FtlGcBufInit
	.type	FtlGcBufInit, %function
FtlGcBufInit:
	adrp	x1, .LANCHOR104
	adrp	x0, .LANCHOR103
	adrp	x7, .LANCHOR105
	adrp	x6, .LANCHOR106
	ldr	x5, [x1, #:lo12:.LANCHOR104]
	adrp	x1, .LANCHOR58
	str	wzr, [x0, #:lo12:.LANCHOR103]
	adrp	x0, .LANCHOR38
	ldrh	w10, [x1, #:lo12:.LANCHOR58]
	adrp	x1, .LANCHOR59
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	mov	w8, 24
	ldrh	w11, [x1, #:lo12:.LANCHOR59]
	adrp	x1, .LANCHOR107
	ldr	x14, [x7, #:lo12:.LANCHOR105]
	mov	x3, x5
	ldr	x4, [x1, #:lo12:.LANCHOR107]
	mov	w2, 0
	ldr	x15, [x6, #:lo12:.LANCHOR106]
	nop // between mem op and mult-accumulate
	umaddl	x8, w0, w8, x5
	add	x4, x4, 8
	mov	w1, 0
	mov	w16, 1
.L569:
	add	w13, w2, w10
	add	w12, w1, w11
	cmp	x3, x8
	bne	.L570
	adrp	x1, .LANCHOR108
	ldr	x7, [x7, #:lo12:.LANCHOR105]
	ldr	x6, [x6, #:lo12:.LANCHOR106]
	mov	w8, 24
	ldr	w4, [x1, #:lo12:.LANCHOR108]
.L571:
	cmp	w0, w4
	bcc	.L572
	ret
.L570:
	asr	w2, w2, 2
	asr	w1, w1, 2
	add	x2, x14, x2, sxtw 2
	add	x1, x15, x1, sxtw 2
	str	w16, [x3, 16]
	stp	x2, x1, [x3]
	add	x3, x3, 24
	stp	x2, x1, [x4]
	add	x4, x4, 56
	mov	w1, w12
	mov	w2, w13
	b	.L569
.L572:
	umull	x3, w0, w8
	mul	w1, w10, w0
	add	x2, x5, x3
	asr	w1, w1, 2
	add	x1, x7, x1, sxtw 2
	str	wzr, [x2, 16]
	str	x1, [x5, x3]
	mul	w1, w11, w0
	add	w0, w0, 1
	and	w0, w0, 65535
	asr	w1, w1, 2
	add	x1, x6, x1, sxtw 2
	str	x1, [x2, 8]
	b	.L571
	.size	FtlGcBufInit, .-FtlGcBufInit
	.section	.text.FtlGcBufFree,"ax",@progbits
	.align	2
	.global	FtlGcBufFree
	.type	FtlGcBufFree, %function
FtlGcBufFree:
	adrp	x2, .LANCHOR108
	mov	w3, 0
	mov	w7, 56
	mov	w10, 24
	ldr	w8, [x2, #:lo12:.LANCHOR108]
	adrp	x2, .LANCHOR104
	ldr	x4, [x2, #:lo12:.LANCHOR104]
.L574:
	cmp	w3, w1
	bcs	.L573
	umaddl	x6, w3, w7, x0
	mov	w2, 0
	b	.L579
.L575:
	add	w2, w2, 1
	and	w2, w2, 65535
.L579:
	cmp	w2, w8
	bcs	.L576
	umull	x5, w2, w10
	add	x11, x4, x5
	ldr	x12, [x4, x5]
	ldr	x5, [x6, 8]
	cmp	x12, x5
	bne	.L575
	str	wzr, [x11, 16]
.L576:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L574
.L573:
	ret
	.size	FtlGcBufFree, .-FtlGcBufFree
	.section	.text.FtlGcBufAlloc,"ax",@progbits
	.align	2
	.global	FtlGcBufAlloc
	.type	FtlGcBufAlloc, %function
FtlGcBufAlloc:
	adrp	x2, .LANCHOR108
	mov	w3, 0
	mov	w7, 24
	mov	w8, 1
	ldr	w5, [x2, #:lo12:.LANCHOR108]
	adrp	x2, .LANCHOR104
	mov	w10, 56
	ldr	x6, [x2, #:lo12:.LANCHOR104]
.L581:
	cmp	w3, w1
	bcs	.L580
	mov	w2, 0
	b	.L586
.L582:
	add	w2, w2, 1
	and	w2, w2, 65535
.L586:
	cmp	w2, w5
	bcs	.L583
	umaddl	x4, w2, w7, x6
	ldr	w11, [x4, 16]
	cbnz	w11, .L582
	umaddl	x2, w3, w10, x0
	ldr	x11, [x4]
	str	w8, [x4, 16]
	ldr	x4, [x4, 8]
	stp	x11, x4, [x2, 8]
.L583:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L581
.L580:
	ret
	.size	FtlGcBufAlloc, .-FtlGcBufAlloc
	.section	.text.IsBlkInGcList,"ax",@progbits
	.align	2
	.global	IsBlkInGcList
	.type	IsBlkInGcList, %function
IsBlkInGcList:
	adrp	x1, .LANCHOR109
	and	w0, w0, 65535
	ldrh	w2, [x1, #:lo12:.LANCHOR109]
	adrp	x1, .LANCHOR110
	ldr	x3, [x1, #:lo12:.LANCHOR110]
	mov	x1, 0
.L588:
	cmp	w2, w1, uxth
	bhi	.L590
	mov	w0, 0
	ret
.L590:
	add	x1, x1, 1
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L588
	mov	w0, 1
	ret
	.size	IsBlkInGcList, .-IsBlkInGcList
	.section	.text.FtlGcUpdatePage,"ax",@progbits
	.align	2
	.global	FtlGcUpdatePage
	.type	FtlGcUpdatePage, %function
FtlGcUpdatePage:
	mov	w6, w0
	mov	w10, w1
	mov	w8, w2
	stp	x29, x30, [sp, -16]!
	lsr	w0, w0, 10
	add	x29, sp, 0
	bl	P2V_block_in_plane
	and	w7, w0, 65535
	adrp	x4, .LANCHOR109
	adrp	x2, .LANCHOR110
	mov	x3, 0
	ldrh	w1, [x4, #:lo12:.LANCHOR109]
	ldr	x5, [x2, #:lo12:.LANCHOR110]
.L593:
	and	w2, w3, 65535
	cmp	w2, w1
	bcc	.L595
	bne	.L594
	and	x3, x3, 65535
	strh	w0, [x5, x3, lsl 1]
	ldrh	w0, [x4, #:lo12:.LANCHOR109]
	add	w0, w0, 1
	strh	w0, [x4, #:lo12:.LANCHOR109]
	b	.L594
.L595:
	add	x3, x3, 1
	add	x2, x5, x3, lsl 1
	ldrh	w2, [x2, -2]
	cmp	w2, w7
	bne	.L593
.L594:
	adrp	x4, .LANCHOR111
	adrp	x1, .LANCHOR112
	mov	w3, 12
	ldrh	w0, [x4, #:lo12:.LANCHOR111]
	ldr	x5, [x1, #:lo12:.LANCHOR112]
	umull	x3, w0, w3
	add	w0, w0, 1
	add	x7, x5, x3
	stp	w10, w8, [x7, 4]
	str	w6, [x5, x3]
	strh	w0, [x4, #:lo12:.LANCHOR111]
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlGcUpdatePage, .-FtlGcUpdatePage
	.section	.text.FtlGcRefreshOpenBlock,"ax",@progbits
	.align	2
	.global	FtlGcRefreshOpenBlock
	.type	FtlGcRefreshOpenBlock, %function
FtlGcRefreshOpenBlock:
	adrp	x8, .LANCHOR113
	and	w0, w0, 65535
	ldrh	w10, [x8, #:lo12:.LANCHOR113]
	cmp	w10, w0
	beq	.L598
	adrp	x6, .LANCHOR114
	ldrh	w7, [x6, #:lo12:.LANCHOR114]
	cmp	w0, w7
	beq	.L598
	adrp	x4, .LANCHOR115
	ldrh	w5, [x4, #:lo12:.LANCHOR115]
	cmp	w0, w5
	beq	.L598
	adrp	x2, .LANCHOR116
	ldrh	w3, [x2, #:lo12:.LANCHOR116]
	cmp	w0, w3
	beq	.L598
	mov	w1, 65535
	cmp	w10, w1
	bne	.L599
	strh	w0, [x8, #:lo12:.LANCHOR113]
.L598:
	mov	w0, 0
	ret
.L599:
	cmp	w7, w1
	bne	.L600
	strh	w0, [x6, #:lo12:.LANCHOR114]
	b	.L598
.L600:
	cmp	w5, w1
	bne	.L601
	strh	w0, [x4, #:lo12:.LANCHOR115]
	b	.L598
.L601:
	cmp	w3, w1
	bne	.L598
	strh	w0, [x2, #:lo12:.LANCHOR116]
	b	.L598
	.size	FtlGcRefreshOpenBlock, .-FtlGcRefreshOpenBlock
	.section	.text.FtlGcRefreshBlock,"ax",@progbits
	.align	2
	.global	FtlGcRefreshBlock
	.type	FtlGcRefreshBlock, %function
FtlGcRefreshBlock:
	adrp	x8, .LANCHOR113
	and	w0, w0, 65535
	ldrh	w10, [x8, #:lo12:.LANCHOR113]
	cmp	w10, w0
	beq	.L610
	adrp	x6, .LANCHOR114
	ldrh	w7, [x6, #:lo12:.LANCHOR114]
	cmp	w0, w7
	beq	.L610
	adrp	x4, .LANCHOR115
	ldrh	w5, [x4, #:lo12:.LANCHOR115]
	cmp	w0, w5
	beq	.L610
	adrp	x2, .LANCHOR116
	ldrh	w3, [x2, #:lo12:.LANCHOR116]
	cmp	w0, w3
	beq	.L610
	mov	w1, 65535
	cmp	w10, w1
	bne	.L604
	strh	w0, [x8, #:lo12:.LANCHOR113]
.L610:
	mov	w0, 0
	ret
.L604:
	cmp	w7, w1
	bne	.L605
	strh	w0, [x6, #:lo12:.LANCHOR114]
	b	.L610
.L605:
	cmp	w5, w1
	bne	.L606
	strh	w0, [x4, #:lo12:.LANCHOR115]
	b	.L610
.L606:
	cmp	w3, w1
	bne	.L611
	strh	w0, [x2, #:lo12:.LANCHOR116]
	b	.L610
.L611:
	mov	w0, -1
	ret
	.size	FtlGcRefreshBlock, .-FtlGcRefreshBlock
	.section	.text.FtlGcMarkBadPhyBlk,"ax",@progbits
	.align	2
	.global	FtlGcMarkBadPhyBlk
	.type	FtlGcMarkBadPhyBlk, %function
FtlGcMarkBadPhyBlk:
	and	w12, w0, 65535
	stp	x29, x30, [sp, -16]!
	mov	w0, w12
	add	x29, sp, 0
	bl	P2V_block_in_plane
	and	w11, w0, 65535
	bl	FtlGcRefreshBlock
	adrp	x0, .LANCHOR28
	ldr	w0, [x0, #:lo12:.LANCHOR28]
	cbz	w0, .L613
	adrp	x1, .LANCHOR79
	ubfiz	x0, x11, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR79]
	ldrh	w1, [x2, x0]
	cmp	w1, 39
	bls	.L613
	sub	w1, w1, #40
	strh	w1, [x2, x0]
.L613:
	adrp	x1, .LANCHOR117
	adrp	x3, .LANCHOR118
	add	x3, x3, :lo12:.LANCHOR118
	mov	x2, 0
	ldrh	w0, [x1, #:lo12:.LANCHOR117]
.L614:
	cmp	w0, w2, uxth
	bhi	.L616
	cmp	w0, 15
	bhi	.L615
	add	w2, w0, 1
	strh	w2, [x1, #:lo12:.LANCHOR117]
	adrp	x1, .LANCHOR118
	add	x1, x1, :lo12:.LANCHOR118
	strh	w12, [x1, w0, sxtw 1]
	b	.L615
.L616:
	add	x2, x2, 1
	add	x4, x3, x2, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w12
	bne	.L614
.L615:
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlGcMarkBadPhyBlk, .-FtlGcMarkBadPhyBlk
	.section	.text.FtlGcReFreshBadBlk,"ax",@progbits
	.align	2
	.global	FtlGcReFreshBadBlk
	.type	FtlGcReFreshBadBlk, %function
FtlGcReFreshBadBlk:
	adrp	x0, .LANCHOR117
	ldrh	w0, [x0, #:lo12:.LANCHOR117]
	cbz	w0, .L628
	adrp	x1, .LANCHOR113
	ldrh	w2, [x1, #:lo12:.LANCHOR113]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L628
	stp	x29, x30, [sp, -16]!
	adrp	x11, .LANCHOR119
	add	x29, sp, 0
	ldrh	w1, [x11, #:lo12:.LANCHOR119]
	cmp	w1, w0
	bcc	.L623
	strh	wzr, [x11, #:lo12:.LANCHOR119]
.L623:
	ldrh	w1, [x11, #:lo12:.LANCHOR119]
	adrp	x0, .LANCHOR118
	add	x0, x0, :lo12:.LANCHOR118
	ldrh	w0, [x0, x1, lsl 1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	w0, [x11, #:lo12:.LANCHOR119]
	ldp	x29, x30, [sp], 16
	add	w0, w0, 1
	strh	w0, [x11, #:lo12:.LANCHOR119]
	mov	w0, 0
	ret
.L628:
	mov	w0, 0
	ret
	.size	FtlGcReFreshBadBlk, .-FtlGcReFreshBadBlk
	.section	.text.flash_boot_enter_slc_mode,"ax",@progbits
	.align	2
	.global	flash_boot_enter_slc_mode
	.type	flash_boot_enter_slc_mode, %function
flash_boot_enter_slc_mode:
	adrp	x1, .LANCHOR29
	and	w0, w0, 255
	ldr	w2, [x1, #:lo12:.LANCHOR29]
	mov	w1, 12336
	movk	w1, 0x5638, lsl 16
	cmp	w2, w1
	bne	.L631
	b	flash_enter_slc_mode
.L631:
	ret
	.size	flash_boot_enter_slc_mode, .-flash_boot_enter_slc_mode
	.section	.text.flash_boot_exit_slc_mode,"ax",@progbits
	.align	2
	.global	flash_boot_exit_slc_mode
	.type	flash_boot_exit_slc_mode, %function
flash_boot_exit_slc_mode:
	adrp	x1, .LANCHOR29
	and	w0, w0, 255
	ldr	w2, [x1, #:lo12:.LANCHOR29]
	mov	w1, 12336
	movk	w1, 0x5638, lsl 16
	cmp	w2, w1
	bne	.L633
	b	flash_exit_slc_mode
.L633:
	ret
	.size	flash_boot_exit_slc_mode, .-flash_boot_exit_slc_mode
	.section	.text.FW_FlashBlockErase.constprop.41,"ax",@progbits
	.align	2
	.type	FW_FlashBlockErase.constprop.41, %function
FW_FlashBlockErase.constprop.41:
	stp	x29, x30, [sp, -16]!
	mov	w4, w0
	adrp	x0, .LANCHOR18
	add	x29, sp, 0
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	ldrb	w3, [x0, 9]
	mov	w0, 0
	bl	flash_boot_enter_slc_mode
	udiv	w1, w4, w3
	mov	w2, 0
	mov	w0, 0
	bl	FlashEraseBlock
	mov	w3, w0
	mov	w0, 0
	bl	flash_boot_exit_slc_mode
	and	w0, w3, 255
	ldp	x29, x30, [sp], 16
	ret
	.size	FW_FlashBlockErase.constprop.41, .-FW_FlashBlockErase.constprop.41
	.section	.text.ftl_memset,"ax",@progbits
	.align	2
	.global	ftl_memset
	.type	ftl_memset, %function
ftl_memset:
	uxtw	x2, w2
	b	memset
	.size	ftl_memset, .-ftl_memset
	.section	.text.BuildFlashLsbPageTable,"ax",@progbits
	.align	2
	.global	BuildFlashLsbPageTable
	.type	BuildFlashLsbPageTable, %function
BuildFlashLsbPageTable:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	cbnz	w0, .L639
	adrp	x1, .LANCHOR16
	add	x1, x1, :lo12:.LANCHOR16
	mov	x0, 0
.L640:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 256
	bne	.L640
.L646:
	adrp	x19, .LANCHOR120
	add	x19, x19, :lo12:.LANCHOR120
	mov	w1, 255
	mov	w2, 1024
	mov	x0, x19
	bl	ftl_memset
	adrp	x1, .LANCHOR16
	and	w20, w20, 65535
	add	x1, x1, :lo12:.LANCHOR16
	mov	x0, 0
.L641:
	cmp	w20, w0, uxth
	bhi	.L663
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L639:
	cmp	w0, 1
	bne	.L642
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
	mov	x1, 0
.L645:
	and	w0, w1, 65535
	cmp	x1, 3
	bls	.L643
	ubfiz	w3, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 2
	sub	w0, w3, w0
	and	w0, w0, 65535
.L643:
	strh	w0, [x2, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L645
	b	.L646
.L642:
	cmp	w0, 2
	bne	.L647
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
	mov	w1, 65535
	mov	x0, 0
.L649:
	cmp	x0, 2
	and	w3, w0, 65535
	csel	w3, w3, w1, cc
	strh	w3, [x2, x0, lsl 1]
	add	w1, w1, 2
	add	x0, x0, 1
	and	w1, w1, 65535
	cmp	x0, 256
	bne	.L649
	b	.L646
.L647:
	cmp	w0, 3
	bne	.L650
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
	mov	x1, 0
.L653:
	and	w0, w1, 65535
	cmp	x1, 5
	bls	.L651
	ubfiz	w3, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 4
	sub	w0, w3, w0
	and	w0, w0, 65535
.L651:
	strh	w0, [x2, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L653
	b	.L646
.L650:
	cmp	w0, 4
	bne	.L654
	adrp	x2, .LANCHOR16
	add	x1, x2, :lo12:.LANCHOR16
	add	x1, x1, 16
	strh	wzr, [x2, #:lo12:.LANCHOR16]
	mov	w2, 1
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
.L656:
	and	w3, w0, 1
	ubfiz	w2, w0, 1, 15
	add	w3, w3, 6
	add	w0, w0, 1
	sub	w2, w2, w3
	strh	w2, [x1], 2
	and	w0, w0, 65535
	cmp	w0, 256
	bne	.L656
	b	.L646
.L654:
	cmp	w0, 5
	bne	.L657
	adrp	x1, .LANCHOR16
	add	x1, x1, :lo12:.LANCHOR16
	mov	x0, 0
.L658:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 16
	bne	.L658
	add	x1, x1, 32
.L659:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 496
	bne	.L659
	b	.L646
.L657:
	cmp	w0, 6
	bne	.L646
	adrp	x3, .LANCHOR16
	add	x3, x3, :lo12:.LANCHOR16
	mov	w1, 0
	mov	x2, 0
	mov	w4, 12
	mov	w5, 10
.L662:
	and	w0, w2, 65535
	cmp	x2, 5
	bls	.L660
	tst	x0, 1
	csel	w0, w4, w5, ne
	sub	w0, w1, w0
	and	w0, w0, 65535
.L660:
	strh	w0, [x3, x2, lsl 1]
	add	w1, w1, 3
	and	w1, w1, 65535
	add	x2, x2, 1
	cmp	w1, 768
	bne	.L662
	b	.L646
.L663:
	ldrh	w2, [x1, x0, lsl 1]
	add	x0, x0, 1
	strh	w2, [x19, w2, sxtw 1]
	b	.L641
	.size	BuildFlashLsbPageTable, .-BuildFlashLsbPageTable
	.section	.text.FlashDieInfoInit,"ax",@progbits
	.align	2
	.global	FlashDieInfoInit
	.type	FlashDieInfoInit, %function
FlashDieInfoInit:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR31+10
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR25
	adrp	x20, .LANCHOR121
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR31+10]
	adrp	x23, .LANCHOR3
	stp	x21, x22, [sp, 32]
	strb	wzr, [x19, #:lo12:.LANCHOR25]
	cmp	w0, 256
	strb	wzr, [x20, #:lo12:.LANCHOR121]
	str	x25, [sp, 64]
	bls	.L679
	mov	w0, 512
.L696:
	adrp	x25, .LANCHOR26
	add	x22, x25, :lo12:.LANCHOR26
	str	w0, [x23, #:lo12:.LANCHOR3]
	mov	w2, 8
	mov	w1, 0
	mov	x0, x22
	adrp	x24, .LANCHOR17
	bl	ftl_memset
	add	x21, x24, :lo12:.LANCHOR17
	mov	w2, 32
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	mov	w2, 192
	mov	w1, 0
	adrp	x0, .LANCHOR23
	add	x0, x0, :lo12:.LANCHOR23
	bl	ftl_memset
	adrp	x0, .LANCHOR18
	adrp	x12, .LANCHOR22
	add	x14, x19, :lo12:.LANCHOR25
	add	x15, x12, :lo12:.LANCHOR22
	ldr	x7, [x0, #:lo12:.LANCHOR18]
	mov	x8, 0
	add	x10, x7, 1
	ldrb	w11, [x7]
.L683:
	mov	w2, w11
	add	x1, x15, x8, lsl 3
	mov	x0, x10
	bl	FlashMemCmp8
	cbnz	w0, .L682
	ldrb	w1, [x14]
	add	w0, w1, 1
	strb	w0, [x14]
	str	wzr, [x21, x1, lsl 2]
	strb	w8, [x22, x1]
.L682:
	add	x8, x8, 1
	cmp	x8, 4
	bne	.L683
	ldrb	w0, [x19, #:lo12:.LANCHOR25]
	strb	w0, [x20, #:lo12:.LANCHOR121]
	ldrb	w0, [x7, 8]
	cmp	w0, 2
	beq	.L684
.L688:
	ldrb	w0, [x19, #:lo12:.LANCHOR25]
	ldrh	w1, [x7, 14]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	mul	w0, w0, w1
	ldrb	w1, [x7, 13]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	mul	w0, w0, w1
	adrp	x1, .LANCHOR122
	ldp	x29, x30, [sp], 80
	strh	w0, [x1, #:lo12:.LANCHOR122]
	ret
.L679:
	cmp	w0, 128
	bls	.L696
	mov	w0, 256
	b	.L696
.L684:
	ldr	w20, [x23, #:lo12:.LANCHOR3]
	add	x12, x12, :lo12:.LANCHOR22
	add	x14, x19, :lo12:.LANCHOR25
	add	x24, x24, :lo12:.LANCHOR17
	add	x13, x25, :lo12:.LANCHOR26
	mov	x15, 0
.L687:
	mov	w2, w11
	add	x1, x12, x15, lsl 3
	mov	x0, x10
	bl	FlashMemCmp8
	cbnz	w0, .L685
	ldrb	w2, [x7, 13]
	ldrh	w0, [x7, 14]
	ldrb	w1, [x14]
	and	w0, w0, 65280
	mul	w2, w2, w20
	mul	w0, w0, w2
	sxtw	x2, w1
	str	w0, [x24, x2, lsl 2]
	ldrb	w3, [x7, 23]
	cbz	w3, .L686
	lsl	w0, w0, 1
	str	w0, [x24, x2, lsl 2]
.L686:
	add	w1, w1, 1
	strb	w15, [x13, x2]
	strb	w1, [x14]
.L685:
	add	x15, x15, 1
	cmp	x15, 4
	bne	.L687
	b	.L688
	.size	FlashDieInfoInit, .-FlashDieInfoInit
	.section	.text.ReadFlashInfo,"ax",@progbits
	.align	2
	.global	ReadFlashInfo
	.type	ReadFlashInfo, %function
ReadFlashInfo:
	stp	x29, x30, [sp, -32]!
	mov	w2, 11
	mov	w1, 0
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	x19, x0
	bl	ftl_memset
	adrp	x0, .LANCHOR18
	adrp	x3, .LANCHOR69
	mov	w4, 1
	ldr	x1, [x0, #:lo12:.LANCHOR18]
	adrp	x0, .LANCHOR3
	ldr	w0, [x0, #:lo12:.LANCHOR3]
	ldrb	w2, [x1, 9]
	mul	w0, w0, w2
	strb	w0, [x19, 4]
	ubfx	x0, x0, 8, 8
	strb	w0, [x19, 5]
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	strb	w0, [x19, 7]
	add	x0, x3, :lo12:.LANCHOR69
	ldrb	w3, [x3, #:lo12:.LANCHOR69]
	strb	w3, [x19]
	ldrb	w3, [x0, 1]
	strb	w3, [x19, 1]
	ldrb	w3, [x0, 2]
	ldrb	w0, [x0, 3]
	strb	w3, [x19, 2]
	strb	w0, [x19, 3]
	mov	w0, 32
	strb	w2, [x19, 6]
	adrp	x2, .LANCHOR26
	strb	w0, [x19, 8]
	add	x2, x2, :lo12:.LANCHOR26
	ldrb	w0, [x1, 7]
	mov	x1, 0
	strb	w0, [x19, 9]
	adrp	x0, .LANCHOR25
	strb	wzr, [x19, 10]
	ldrb	w3, [x0, #:lo12:.LANCHOR25]
.L698:
	cmp	w3, w1, uxtb
	bhi	.L699
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L699:
	ldrb	w0, [x1, x2]
	add	x1, x1, 1
	ldrb	w5, [x19, 10]
	lsl	w0, w4, w0
	orr	w0, w0, w5
	strb	w0, [x19, 10]
	b	.L698
	.size	ReadFlashInfo, .-ReadFlashInfo
	.section	.text.FtlBbt2Bitmap,"ax",@progbits
	.align	2
	.global	FtlBbt2Bitmap
	.type	FtlBbt2Bitmap, %function
FtlBbt2Bitmap:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	x21, x0
	adrp	x0, .LANCHOR123
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR51
	adrp	x23, .LANCHOR124
	ldrh	w2, [x0, #:lo12:.LANCHOR123]
	add	x22, x22, :lo12:.LANCHOR51
	add	x23, x23, :lo12:.LANCHOR124
	stp	x19, x20, [sp, 16]
	mov	w24, 65535
	mov	x19, 0
	mov	x20, x1
	lsl	w2, w2, 2
	mov	w1, 0
	mov	x0, x20
	bl	ftl_memset
.L704:
	ldrh	w0, [x21, x19]
	cmp	w0, w24
	beq	.L701
	ldrh	w1, [x22]
	cmp	w1, w0
	bhi	.L703
	mov	w2, 79
	mov	x1, x23
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L703:
	ldrh	w1, [x21, x19]
	mov	w2, 1
	add	x19, x19, 2
	cmp	x19, 1024
	ubfx	x0, x1, 5, 11
	and	w1, w1, 31
	lsl	x0, x0, 2
	lsl	w2, w2, w1
	ldr	w1, [x20, x0]
	orr	w1, w1, w2
	str	w1, [x20, x0]
	bne	.L704
.L701:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
	.size	FtlBbt2Bitmap, .-FtlBbt2Bitmap
	.section	.text.FtlBbtMemInit,"ax",@progbits
	.align	2
	.global	FtlBbtMemInit
	.type	FtlBbtMemInit, %function
FtlBbtMemInit:
	adrp	x1, .LANCHOR75
	add	x0, x1, :lo12:.LANCHOR75
	mov	w2, -1
	add	x0, x0, 12
	strh	w2, [x1, #:lo12:.LANCHOR75]
	mov	w2, 16
	strh	wzr, [x0, -6]
	mov	w1, 255
	b	ftl_memset
	.size	FtlBbtMemInit, .-FtlBbtMemInit
	.section	.text.FtlFreeSysBlkQueueInit,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueInit
	.type	FtlFreeSysBlkQueueInit, %function
FtlFreeSysBlkQueueInit:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR76
	add	x3, x1, :lo12:.LANCHOR76
	mov	w2, 2048
	add	x29, sp, 0
	strh	w0, [x1, #:lo12:.LANCHOR76]
	mov	w1, 0
	strh	wzr, [x3, 2]
	add	x0, x3, 8
	strh	wzr, [x3, 4]
	strh	wzr, [x3, 6]
	bl	ftl_memset
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlFreeSysBlkQueueInit, .-FtlFreeSysBlkQueueInit
	.section	.text.ftl_free_no_use_map_blk,"ax",@progbits
	.align	2
	.global	ftl_free_no_use_map_blk
	.type	ftl_free_no_use_map_blk, %function
ftl_free_no_use_map_blk:
	stp	x29, x30, [sp, -80]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w2, [x0, 10]
	stp	x21, x22, [sp, 32]
	ldp	x21, x20, [x0, 32]
	stp	x23, x24, [sp, 48]
	ldr	x22, [x0, 16]
	lsl	w2, w2, 1
	mov	x0, x21
	str	x25, [sp, 64]
	bl	ftl_memset
	mov	w0, 0
.L712:
	ldrh	w1, [x19, 6]
	cmp	w1, w0
	bhi	.L716
	adrp	x0, .LANCHOR54
	mov	w23, 0
	mov	w20, 0
	ldrh	w1, [x0, #:lo12:.LANCHOR54]
	ldrh	w0, [x19]
	strh	w1, [x21, x0, lsl 1]
	ldrh	w24, [x21]
.L717:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L721
	mov	w0, w23
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L716:
	ubfiz	x1, x0, 2, 16
	ldr	w2, [x20, x1]
	mov	w1, 0
	ubfx	x2, x2, 10, 16
.L713:
	ldrh	w3, [x19, 10]
	cmp	w3, w1
	bhi	.L715
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L712
.L715:
	ubfiz	x3, x1, 1, 16
	ldrh	w4, [x22, x3]
	cmp	w4, w2
	bne	.L714
	cbz	w2, .L714
	ldrh	w4, [x21, x3]
	add	w4, w4, 1
	strh	w4, [x21, x3]
.L714:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L713
.L721:
	ubfiz	x0, x20, 1, 16
	ldrh	w1, [x21, x0]
	cmp	w24, w1
	bls	.L718
	add	x25, x22, x0
	ldrh	w0, [x22, x0]
	cbnz	w0, .L719
.L720:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L717
.L718:
	cbnz	w1, .L720
	add	x25, x22, x0
	ldrh	w0, [x22, x0]
	cbz	w0, .L720
.L722:
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
	strh	wzr, [x25]
	ldrh	w0, [x19, 8]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	b	.L720
.L723:
	mov	w24, 0
	b	.L722
.L719:
	mov	w23, w20
	cbz	w1, .L723
	mov	w24, w1
	b	.L720
	.size	ftl_free_no_use_map_blk, .-ftl_free_no_use_map_blk
	.section	.text.FtlL2PDataInit,"ax",@progbits
	.align	2
	.global	FtlL2PDataInit
	.type	FtlL2PDataInit, %function
FtlL2PDataInit:
	stp	x29, x30, [sp, -64]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR125
	adrp	x20, .LANCHOR65
	stp	x21, x22, [sp, 32]
	ldr	x0, [x19, #:lo12:.LANCHOR125]
	adrp	x22, .LANCHOR58
	ldr	w2, [x20, #:lo12:.LANCHOR65]
	adrp	x21, .LANCHOR68
	str	x23, [sp, 48]
	adrp	x23, .LANCHOR126
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w0, [x21, #:lo12:.LANCHOR68]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR58]
	mul	w2, w2, w0
	ldr	x0, [x23, #:lo12:.LANCHOR126]
	bl	ftl_memset
	adrp	x0, .LANCHOR97
	ldrh	w3, [x21, #:lo12:.LANCHOR68]
	ldr	x6, [x23, #:lo12:.LANCHOR126]
	mov	x1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	mov	w2, -1
	ldrh	w5, [x22, #:lo12:.LANCHOR58]
	add	x3, x0, x3, lsl 4
.L733:
	add	x4, x1, x5
	cmp	x0, x3
	bne	.L734
	adrp	x1, .LANCHOR127
	add	x0, x1, :lo12:.LANCHOR127
	ldp	x21, x22, [sp, 32]
	strh	w2, [x1, #:lo12:.LANCHOR127]
	ldr	w1, [x20, #:lo12:.LANCHOR65]
	strh	w1, [x0, 10]
	mov	w1, -3902
	strh	w1, [x0, 4]
	adrp	x1, .LANCHOR128
	ldr	x23, [sp, 48]
	strh	w2, [x0, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR128]
	strh	w1, [x0, 8]
	adrp	x1, .LANCHOR67
	ldrh	w1, [x1, #:lo12:.LANCHOR67]
	strh	w1, [x0, 6]
	adrp	x1, .LANCHOR129
	ldr	x1, [x1, #:lo12:.LANCHOR129]
	str	x1, [x0, 16]
	adrp	x1, .LANCHOR130
	ldr	x1, [x1, #:lo12:.LANCHOR130]
	str	x1, [x0, 24]
	ldr	x1, [x19, #:lo12:.LANCHOR125]
	ldp	x19, x20, [sp, 16]
	str	x1, [x0, 32]
	adrp	x1, .LANCHOR131
	ldr	x1, [x1, #:lo12:.LANCHOR131]
	str	x1, [x0, 40]
	ldp	x29, x30, [sp], 64
	ret
.L734:
	and	x1, x1, -4
	strh	w2, [x0]
	add	x1, x6, x1
	str	wzr, [x0, 4]
	str	x1, [x0, 8]
	add	x0, x0, 16
	mov	x1, x4
	b	.L733
	.size	FtlL2PDataInit, .-FtlL2PDataInit
	.section	.text.FtlVariablesInit,"ax",@progbits
	.align	2
	.global	FtlVariablesInit
	.type	FtlVariablesInit, %function
FtlVariablesInit:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR132
	mov	w1, -1
	add	x29, sp, 0
	str	xzr, [x0, #:lo12:.LANCHOR132]
	adrp	x0, .LANCHOR133
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR41
	strh	w1, [x0, #:lo12:.LANCHOR133]
	adrp	x0, .LANCHOR134
	mov	w1, -1
	str	wzr, [x0, #:lo12:.LANCHOR134]
	adrp	x0, .LANCHOR135
	str	wzr, [x0, #:lo12:.LANCHOR135]
	adrp	x0, .LANCHOR136
	str	w1, [x0, #:lo12:.LANCHOR136]
	adrp	x0, .LANCHOR28
	mov	w1, 0
	str	wzr, [x0, #:lo12:.LANCHOR28]
	adrp	x0, .LANCHOR71
	strh	wzr, [x0, #:lo12:.LANCHOR71]
	adrp	x0, .LANCHOR62
	ldrh	w2, [x0, #:lo12:.LANCHOR62]
	adrp	x0, .LANCHOR72
	ldr	x0, [x0, #:lo12:.LANCHOR72]
	lsl	w2, w2, 1
	bl	ftl_memset
	adrp	x0, .LANCHOR79
	ldrh	w2, [x19, #:lo12:.LANCHOR41]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR79]
	lsl	w2, w2, 1
	bl	ftl_memset
	adrp	x0, .LANCHOR137
	ldrh	w2, [x19, #:lo12:.LANCHOR41]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR137]
	lsl	w2, w2, 1
	bl	ftl_memset
	mov	w2, 48
	mov	w1, 0
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	bl	ftl_memset
	mov	w2, 512
	mov	w1, 0
	adrp	x0, .LANCHOR138
	add	x0, x0, :lo12:.LANCHOR138
	bl	ftl_memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	ldr	x19, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
	.size	FtlVariablesInit, .-FtlVariablesInit
	.section	.text.SupperBlkListInit,"ax",@progbits
	.align	2
	.global	SupperBlkListInit
	.type	SupperBlkListInit, %function
SupperBlkListInit:
	stp	x29, x30, [sp, -96]!
	adrp	x0, .LANCHOR41
	mov	w1, 0
	add	x29, sp, 0
	ldrh	w2, [x0, #:lo12:.LANCHOR41]
	mov	w0, 6
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR82
	stp	x19, x20, [sp, 16]
	adrp	x23, .LANCHOR86
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR89
	mul	w2, w2, w0
	ldr	x0, [x24, #:lo12:.LANCHOR82]
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR40
	str	x27, [sp, 80]
	adrp	x26, .LANCHOR47
	add	x25, x25, :lo12:.LANCHOR40
	add	x26, x26, :lo12:.LANCHOR47
	bl	ftl_memset
	mov	w21, 0
	adrp	x0, .LANCHOR88
	mov	w20, 0
	mov	w19, 0
	strh	wzr, [x23, #:lo12:.LANCHOR86]
	str	xzr, [x0, #:lo12:.LANCHOR88]
	adrp	x0, .LANCHOR83
	strh	wzr, [x22, #:lo12:.LANCHOR89]
	adrp	x27, .LANCHOR38
	str	xzr, [x0, #:lo12:.LANCHOR83]
	adrp	x0, .LANCHOR85
	str	xzr, [x0, #:lo12:.LANCHOR85]
	adrp	x0, .LANCHOR139
	strh	wzr, [x0, #:lo12:.LANCHOR139]
.L739:
	ldrh	w0, [x25]
	cmp	w19, w0
	bge	.L746
	adrp	x0, .LANCHOR53
	ldrh	w8, [x27, #:lo12:.LANCHOR38]
	mov	w5, 0
	mov	w6, 0
	ldrh	w7, [x0, #:lo12:.LANCHOR53]
	b	.L747
.L741:
	ldrb	w0, [x26, w6, sxtw]
	mov	w1, w19
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L740
	add	w5, w7, w5
	sxth	w5, w5
.L740:
	add	w6, w6, 1
	sxth	w6, w6
.L747:
	cmp	w6, w8
	blt	.L741
	cbz	w5, .L742
	mov	w0, 32768
	sdiv	w5, w0, w5
	sxth	w5, w5
.L743:
	ldr	x1, [x24, #:lo12:.LANCHOR82]
	mov	w0, 6
	smaddl	x0, w19, w0, x1
	strh	w5, [x0, 4]
	adrp	x0, .LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w19, w0
	beq	.L744
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w19, w0
	beq	.L744
	adrp	x0, .LANCHOR94
	ldrh	w0, [x0, #:lo12:.LANCHOR94]
	cmp	w19, w0
	beq	.L744
	adrp	x0, .LANCHOR84
	ldr	x0, [x0, #:lo12:.LANCHOR84]
	ldrh	w0, [x0, w19, sxtw 1]
	cbnz	w0, .L745
	add	w21, w21, 1
	mov	w0, w19
	and	w21, w21, 65535
	bl	INSERT_FREE_LIST
.L744:
	add	w19, w19, 1
	sxth	w19, w19
	b	.L739
.L742:
	adrp	x0, .LANCHOR84
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR84]
	strh	w1, [x0, w19, sxtw 1]
	b	.L743
.L745:
	add	w20, w20, 1
	mov	w0, w19
	and	w20, w20, 65535
	bl	INSERT_DATA_LIST
	b	.L744
.L746:
	strh	w20, [x23, #:lo12:.LANCHOR86]
	add	w20, w20, w21
	strh	w21, [x22, #:lo12:.LANCHOR89]
	cmp	w0, w20
	bge	.L748
	mov	w2, 2614
	adrp	x1, .LANCHOR140
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR140
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L748:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
	.size	SupperBlkListInit, .-SupperBlkListInit
	.section	.text.FtlGcPageVarInit,"ax",@progbits
	.align	2
	.global	FtlGcPageVarInit
	.type	FtlGcPageVarInit, %function
FtlGcPageVarInit:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR109
	mov	w1, 255
	add	x29, sp, 0
	strh	wzr, [x0, #:lo12:.LANCHOR109]
	adrp	x0, .LANCHOR111
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR55
	strh	wzr, [x0, #:lo12:.LANCHOR111]
	adrp	x0, .LANCHOR110
	ldrh	w2, [x19, #:lo12:.LANCHOR55]
	ldr	x0, [x0, #:lo12:.LANCHOR110]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w2, [x19, #:lo12:.LANCHOR55]
	mov	w0, 12
	mov	w1, 255
	mul	w2, w2, w0
	adrp	x0, .LANCHOR112
	ldr	x0, [x0, #:lo12:.LANCHOR112]
	bl	ftl_memset
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	FtlGcBufInit
	.size	FtlGcPageVarInit, .-FtlGcPageVarInit
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
	.section	.text.FlashReadIdbData,"ax",@progbits
	.align	2
	.global	FlashReadIdbData
	.type	FlashReadIdbData, %function
FlashReadIdbData:
	stp	x29, x30, [sp, -16]!
	mov	w2, 2048
	adrp	x1, .LANCHOR141
	add	x1, x1, :lo12:.LANCHOR141
	add	x29, sp, 0
	bl	ftl_memcpy
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FlashReadIdbData, .-FlashReadIdbData
	.section	.text.FlashLoadPhyInfoInRam,"ax",@progbits
	.align	2
	.global	FlashLoadPhyInfoInRam
	.type	FlashLoadPhyInfoInRam, %function
FlashLoadPhyInfoInRam:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR142
	add	x8, x0, :lo12:.LANCHOR142
	adrp	x11, .LANCHOR22
	add	x29, sp, 0
	add	x8, x8, 1
	mov	x7, x0
	add	x11, x11, :lo12:.LANCHOR22
	stp	x19, x20, [sp, 16]
	mov	x10, 0
.L760:
	ldrb	w2, [x8, -1]
	mov	w12, w10
	lsl	x20, x10, 5
	mov	x1, x11
	mov	x0, x8
	bl	FlashMemCmp8
	mov	w19, w0
	cbnz	w0, .L758
	add	x0, x7, :lo12:.LANCHOR142
	ubfiz	x12, x12, 5, 32
	add	x20, x0, x20
	add	x0, x0, x12
	adrp	x1, .LANCHOR143
	add	x4, x1, :lo12:.LANCHOR143
	ldrb	w3, [x0, 22]
	mov	x0, 0
.L759:
	lsl	x5, x0, 5
	mov	w2, w0
	ldrb	w5, [x5, x4]
	cmp	w5, w3
	beq	.L762
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L759
	mov	w2, w0
.L762:
	ubfiz	x0, x2, 5, 32
	add	x1, x1, :lo12:.LANCHOR143
	add	x1, x1, x0
	mov	w2, 32
	adrp	x0, .LANCHOR7
	add	x0, x0, :lo12:.LANCHOR7
	bl	ftl_memcpy
	mov	w2, 32
	mov	x1, x20
	adrp	x0, .LANCHOR31
	add	x0, x0, :lo12:.LANCHOR31
	bl	ftl_memcpy
	b	.L757
.L758:
	add	x10, x10, 1
	add	x8, x8, 32
	cmp	x10, 77
	bne	.L760
	mov	w19, -1
.L757:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FlashLoadPhyInfoInRam, .-FlashLoadPhyInfoInRam
	.section	.text.ftl_memcpy32,"ax",@progbits
	.align	2
	.global	ftl_memcpy32
	.type	ftl_memcpy32, %function
ftl_memcpy32:
	mov	x3, 0
.L767:
	cmp	w2, w3
	bhi	.L768
	ret
.L768:
	ldr	w4, [x1, x3, lsl 2]
	str	w4, [x0, x3, lsl 2]
	add	x3, x3, 1
	b	.L767
	.size	ftl_memcpy32, .-ftl_memcpy32
	.section	.text.NandcCopy1KB,"ax",@progbits
	.align	2
	.global	NandcCopy1KB
	.type	NandcCopy1KB, %function
NandcCopy1KB:
	stp	x29, x30, [sp, -48]!
	and	w1, w1, 255
	cmp	w1, 1
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w2, 255
	str	x21, [sp, 32]
	add	x2, x0, 4096
	add	x21, x0, 512
	ubfiz	x0, x19, 9, 8
	mov	x20, x4
	add	x0, x2, x0
	bne	.L770
	cbz	x3, .L771
	tst	x3, 3
	bne	.L772
	mov	w2, 256
	mov	x1, x3
	bl	ftl_memcpy32
.L771:
	cbz	x20, .L769
	ldrb	w0, [x20]
	lsr	w19, w19, 1
	ldrb	w1, [x20, 1]
	orr	x1, x0, x1, lsl 8
	ldrb	w0, [x20, 2]
	orr	x1, x1, x0, lsl 16
	ldrb	w0, [x20, 3]
	orr	x0, x1, x0, lsl 24
	mov	w1, 12
	mul	w19, w19, w1
	str	w0, [x21, w19, sxtw 2]
.L769:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L772:
	mov	w2, 1024
	mov	x1, x3
	bl	ftl_memcpy
	b	.L771
.L770:
	cbz	x3, .L775
	tst	x3, 3
	bne	.L776
	mov	x1, x0
	mov	w2, 256
	mov	x0, x3
	bl	ftl_memcpy32
.L775:
	cbz	x20, .L769
	lsr	w19, w19, 1
	mov	w0, 12
	mul	w19, w19, w0
	ldr	w0, [x21, w19, sxtw 2]
	strb	w0, [x20]
	lsr	w1, w0, 8
	strb	w1, [x20, 1]
	lsr	w1, w0, 16
	lsr	w0, w0, 24
	strb	w1, [x20, 2]
	strb	w0, [x20, 3]
	b	.L769
.L776:
	mov	x1, x0
	mov	w2, 1024
	mov	x0, x3
	bl	ftl_memcpy
	b	.L775
	.size	NandcCopy1KB, .-NandcCopy1KB
	.section	.text.NandcXferData,"ax",@progbits
	.align	2
	.global	NandcXferData
	.type	NandcXferData, %function
NandcXferData:
	stp	x29, x30, [sp, -192]!
	tst	x3, 63
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	and	w25, w0, 255
	stp	x19, x20, [sp, 16]
	adrp	x0, .LANCHOR6
	and	w20, w1, 255
	add	x0, x0, :lo12:.LANCHOR6
	sbfiz	x1, x25, 4, 32
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	mov	x26, x3
	stp	x27, x28, [sp, 80]
	and	w24, w2, 255
	mov	x21, x4
	ldr	x19, [x0, x1]
	bne	.L789
	cbnz	x4, .L790
	add	x21, x29, 128
	mov	w2, 64
	mov	w1, 255
	add	x0, x29, 128
	bl	ftl_memset
.L790:
	mov	x5, x21
	mov	x4, x26
	mov	w2, w24
	mov	w1, w20
	mov	w3, 0
	mov	w0, w25
	bl	NandcXferStart
	mov	w0, w25
	bl	NandcXferComp
	cbnz	w20, .L814
	adrp	x0, .LANCHOR32
	adrp	x4, .LANCHOR35
	mov	x1, x0
	add	x4, x4, :lo12:.LANCHOR35
	ldr	w2, [x0, #:lo12:.LANCHOR32]
	mov	w0, 128
	mov	w3, 64
	cmp	w2, 25
	ubfx	x2, x24, 1, 7
	add	x2, x21, x2, lsl 2
	csel	w3, w3, w0, cc
	mov	w0, 0
.L793:
	add	w5, w3, w0
	cmp	x21, x2
	bne	.L794
	adrp	x0, .LANCHOR34
	ldr	w4, [x1, #:lo12:.LANCHOR32]
	lsr	w24, w24, 2
	mov	w2, 0
	ldr	w3, [x0, #:lo12:.LANCHOR34]
	mov	w22, 0
.L795:
	cmp	w2, w24
	bcs	.L791
	cbnz	w4, .L801
.L791:
	str	wzr, [x19, 16]
.L802:
	adrp	x0, .LANCHOR34
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w0, 5
	bls	.L788
	cbnz	w20, .L788
	ldr	w0, [x19]
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w0, w1
	cmp	w1, 139264
	bne	.L788
	orr	w0, w0, 131072
	mov	w22, -1
	str	w0, [x19]
.L788:
	mov	w0, w22
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L794:
	ldr	x6, [x4, 8]
	and	x0, x0, 4294967292
	add	x21, x21, 4
	ldr	w0, [x6, x0]
	strb	w0, [x21, -4]
	lsr	w6, w0, 8
	strb	w6, [x21, -3]
	lsr	w6, w0, 16
	strb	w6, [x21, -2]
	lsr	w0, w0, 24
	strb	w0, [x21, -1]
	mov	w0, w5
	b	.L793
.L801:
	uxtw	x0, w2
	add	x0, x0, 8
	ldr	w0, [x19, x0, lsl 2]
	str	w0, [x29, 120]
	ldr	w0, [x29, 120]
	tbnz	x0, 2, .L817
	ldr	w0, [x29, 120]
	tbnz	x0, 15, .L817
	cmp	w3, 5
	bls	.L797
	ldr	w1, [x29, 120]
	ubfx	x6, x1, 3, 5
	ldr	w1, [x29, 120]
	ldr	w0, [x29, 120]
	ubfx	x1, x1, 27, 1
	ubfx	x5, x0, 16, 5
	ldr	w0, [x29, 120]
	orr	w1, w6, w1, lsl 5
	ubfx	x0, x0, 29, 1
	orr	w0, w5, w0, lsl 5
	cmp	w1, w0
	ldr	w0, [x29, 120]
	bls	.L798
	ubfx	x1, x0, 3, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 27, 1
.L823:
	orr	w0, w1, w0, lsl 5
.L799:
	cmp	w22, w0
	csel	w22, w22, w0, cs
.L796:
	add	w2, w2, 1
	b	.L795
.L798:
	ubfx	x1, x0, 16, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 29, 1
	b	.L823
.L797:
	cmp	w3, 3
	bls	.L818
	ldr	w1, [x29, 120]
	ubfx	x6, x1, 3, 5
	ldr	w1, [x29, 120]
	ldr	w0, [x29, 120]
	ubfx	x1, x1, 28, 1
	ubfx	x5, x0, 16, 5
	ldr	w0, [x29, 120]
	orr	w1, w6, w1, lsl 5
	ubfx	x0, x0, 30, 1
	orr	w0, w5, w0, lsl 5
	cmp	w1, w0
	ldr	w0, [x29, 120]
	bls	.L800
	ubfx	x1, x0, 3, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 28, 1
	b	.L823
.L800:
	ubfx	x1, x0, 16, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 30, 1
	b	.L823
.L818:
	mov	w0, 0
	b	.L799
.L817:
	mov	w22, -1
	b	.L796
.L814:
	mov	w22, 0
	b	.L791
.L789:
	cmp	w20, 1
	bne	.L803
	cmp	x4, 0
	mov	w23, 2
	csel	w23, w23, wzr, ne
	mov	w27, 0
	lsl	w23, w23, 1
	mov	w22, 0
.L804:
	cmp	w22, w24
	bcc	.L806
	mov	w22, 0
	b	.L802
.L806:
	and	w28, w22, 3
	cbz	x26, .L819
	lsl	w3, w22, 9
	add	x3, x26, x3
.L805:
	add	x4, x21, x27, uxtw
	mov	w2, w28
	mov	w1, 1
	mov	x0, x19
	bl	NandcCopy1KB
	add	w22, w22, 2
	mov	w3, w28
	mov	x5, 0
	mov	x4, 0
	mov	w2, 2
	mov	w1, 1
	mov	w0, w25
	bl	NandcXferStart
	add	w27, w27, w23
	mov	w0, w25
	bl	NandcXferComp
	b	.L804
.L819:
	mov	x3, 0
	b	.L805
.L803:
	mov	w0, w25
	mov	x5, 0
	mov	x4, 0
	mov	w3, 0
	mov	w2, 2
	mov	w1, 0
	bl	NandcXferStart
	mov	w27, 2
	cmp	x21, 0
	mov	w28, 0
	csel	w27, w27, wzr, ne
	mov	w23, 0
	lsl	w0, w27, 1
	mov	w22, 0
	str	w0, [x29, 108]
.L807:
	cmp	w24, w23
	bls	.L802
	mov	w0, w25
	bl	NandcXferComp
	ldr	w0, [x19, 32]
	add	w27, w23, 2
	str	w0, [x29, 120]
	cmp	w24, w27
	bls	.L808
	mov	x5, 0
	mov	x4, 0
	and	w3, w27, 3
	mov	w2, 2
	mov	w1, 0
	mov	w0, w25
	bl	NandcXferStart
.L808:
	ldr	w0, [x29, 120]
	tbnz	x0, 2, .L820
	ldr	w0, [x29, 120]
	ubfx	x1, x0, 3, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 27, 1
	orr	w0, w1, w0, lsl 5
	cmp	w22, w0
	csel	w22, w22, w0, cs
.L809:
	and	w2, w23, 3
	cbz	x26, .L821
	lsl	w3, w23, 9
	add	x3, x26, x3
.L810:
	add	x4, x21, x28, uxtw
	mov	x0, x19
	mov	w1, 0
	bl	NandcCopy1KB
	ldr	w0, [x29, 108]
	mov	w23, w27
	add	w28, w28, w0
	b	.L807
.L820:
	mov	w22, -1
	b	.L809
.L821:
	mov	x3, 0
	b	.L810
	.size	NandcXferData, .-NandcXferData
	.section	.text.FlashReadRawPage,"ax",@progbits
	.align	2
	.global	FlashReadRawPage
	.type	FlashReadRawPage, %function
FlashReadRawPage:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	ands	w19, w0, 255
	stp	x21, x22, [sp, 32]
	mov	w21, w1
	str	x23, [sp, 48]
	adrp	x1, .LANCHOR31+9
	mov	x22, x2
	mov	x23, x3
	ldrb	w20, [x1, #:lo12:.LANCHOR31+9]
	bne	.L825
	adrp	x0, .LANCHOR2
	adrp	x1, .LANCHOR3
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	ldr	w1, [x1, #:lo12:.LANCHOR3]
	mul	w0, w0, w1
	cmp	w0, w21
	mov	w0, 4
	csel	w20, w20, w0, ls
.L825:
	mov	w0, w19
	bl	NandcWaitFlashReady
	mov	w0, w19
	bl	NandcFlashCs
	mov	w1, w21
	mov	w0, w19
	bl	FlashReadCmd
	mov	w0, w19
	bl	NandcWaitFlashReady
	mov	w2, w20
	mov	x4, x23
	mov	x3, x22
	mov	w1, 0
	mov	w0, w19
	bl	NandcXferData
	mov	w2, w0
	mov	w0, w19
	bl	NandcFlashDeCs
	ldr	x23, [sp, 48]
	mov	w0, w2
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
	.size	FlashReadRawPage, .-FlashReadRawPage
	.section	.text.FlashDdrTunningRead,"ax",@progbits
	.align	2
	.global	FlashDdrTunningRead
	.type	FlashDdrTunningRead, %function
FlashDdrTunningRead:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w24, w0, 255
	adrp	x0, .LANCHOR19
	stp	x25, x26, [sp, 64]
	stp	x21, x22, [sp, 32]
	mov	w25, w1
	ldr	x0, [x0, #:lo12:.LANCHOR19]
	mov	w22, 6
	stp	x27, x28, [sp, 80]
	mov	x23, x2
	stp	x19, x20, [sp, 16]
	mov	x28, x3
	mov	w26, w4
	ldr	w0, [x0, 304]
	str	w0, [x29, 108]
	adrp	x0, .LANCHOR34
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w0, 8
	mov	w0, 12
	csel	w22, w22, w0, cc
	cbz	w4, .L841
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
	mov	w0, w24
	adrp	x19, .LANCHOR24
	bl	FlashReset
	mov	x3, x28
	mov	x2, x23
	mov	w1, w25
	mov	w0, w24
	bl	FlashReadRawPage
	mov	w21, w0
	ldrb	w0, [x19, #:lo12:.LANCHOR24]
	bl	FlashSetInterfaceMode
	ldrb	w0, [x19, #:lo12:.LANCHOR24]
	bl	NandcSetMode
	cmn	w21, #1
	bne	.L830
.L839:
	mov	w21, -1
.L827:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L830:
	mov	w1, w25
	mov	w2, w21
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
	adrp	x1, .LANCHOR144
	ldr	w0, [x1, #:lo12:.LANCHOR144]
	add	w0, w0, 1
	cmp	w0, 2047
	bhi	.L832
	str	w0, [x1, #:lo12:.LANCHOR144]
	b	.L827
.L832:
	str	wzr, [x1, #:lo12:.LANCHOR144]
	mov	x28, 0
	mov	x23, 0
.L829:
	mov	w5, 0
	mov	w20, 0
	mov	w6, 0
	mov	w19, 0
	mov	w27, -1
.L837:
	stp	w5, w6, [x29, 100]
	mov	w0, w22
	bl	NandcSetDdrPara
	mov	w1, w25
	mov	x3, x28
	mov	x2, x23
	mov	w0, w24
	bl	FlashReadRawPage
	add	w1, w21, 1
	cmp	w0, w1
	ldp	w5, w6, [x29, 100]
	bhi	.L833
	cmp	w0, 2
	bhi	.L843
	add	w19, w19, 1
	cmp	w19, 9
	bls	.L843
	mov	w1, w20
	mov	w21, w0
	sub	w20, w22, w19
	mov	w27, 0
.L835:
	cmp	w19, w6
	csel	w20, w20, w1, hi
.L836:
	cbz	w20, .L838
	mov	w1, w20
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	printf
	mov	w0, w20
	bl	NandcSetDdrPara
.L838:
	cbz	w27, .L827
	adrp	x0, .LC11
	mov	w2, w25
	mov	w1, w24
	add	x0, x0, :lo12:.LC11
	bl	printf
	cbz	w26, .L839
	ldr	w1, [x29, 108]
	lsr	w0, w1, 8
	bl	NandcSetDdrPara
	b	.L827
.L841:
	mov	w21, 1024
	b	.L829
.L833:
	cmp	w19, w6
	bls	.L844
	sub	w20, w5, w19
	cmp	w19, 7
	bhi	.L836
	mov	w6, w19
.L844:
	mov	w19, 0
	b	.L834
.L843:
	mov	w5, w22
	mov	w21, w0
	mov	w27, 0
	mov	x28, 0
	mov	x23, 0
.L834:
	add	w22, w22, 2
	cmp	w22, 69
	bls	.L837
	mov	w1, w20
	mov	w20, w5
	b	.L835
	.size	FlashDdrTunningRead, .-FlashDdrTunningRead
	.section	.text.FlashReadPage,"ax",@progbits
	.align	2
	.global	FlashReadPage
	.type	FlashReadPage, %function
FlashReadPage:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	stp	x21, x22, [sp, 32]
	mov	w0, w20
	stp	x23, x24, [sp, 48]
	mov	w21, w1
	mov	x22, x2
	mov	x23, x3
	str	x25, [sp, 64]
	bl	FlashReadRawPage
	mov	w19, w0
	cmn	w0, #1
	bne	.L854
	adrp	x24, .LANCHOR5
	ldrb	w25, [x24, #:lo12:.LANCHOR5]
	cbnz	w25, .L855
.L857:
	adrp	x0, .LANCHOR30
	ldrb	w0, [x0, #:lo12:.LANCHOR30]
	cbz	w0, .L854
	adrp	x0, .LANCHOR19
	mov	w4, 1
	mov	x3, x23
	mov	x2, x22
	ldr	x0, [x0, #:lo12:.LANCHOR19]
	mov	w1, w21
	ldr	w24, [x0, 304]
	mov	w0, w20
	bl	FlashDdrTunningRead
	mov	w19, w0
	cmn	w0, #1
	beq	.L858
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	cmp	w19, w0, lsr 1
	bls	.L854
.L858:
	lsr	w0, w24, 8
	bl	NandcSetDdrPara
	b	.L854
.L855:
	strb	wzr, [x24, #:lo12:.LANCHOR5]
	mov	x3, x23
	mov	x2, x22
	mov	w1, w21
	mov	w0, w20
	bl	FlashReadRawPage
	strb	w25, [x24, #:lo12:.LANCHOR5]
	cmn	w0, #1
	beq	.L857
	mov	w19, w0
.L854:
	adrp	x24, .LANCHOR145
	ldr	x4, [x24, #:lo12:.LANCHOR145]
	cbz	x4, .L853
	cmn	w19, #1
	bne	.L853
	mov	x3, x23
	mov	x2, x22
	mov	w1, w21
	mov	w0, w20
	blr	x4
	mov	w19, w0
	mov	w1, w0
	mov	w3, w21
	mov	w2, w20
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	bl	printf
	cmn	w19, #1
	bne	.L853
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L853
	mov	w0, w20
	bl	flash_enter_slc_mode
	ldr	x4, [x24, #:lo12:.LANCHOR145]
	mov	x3, x23
	mov	x2, x22
	mov	w1, w21
	mov	w0, w20
	blr	x4
	mov	w19, w0
	mov	w0, w20
	bl	flash_exit_slc_mode
.L853:
	mov	w0, w19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
	.size	FlashReadPage, .-FlashReadPage
	.section	.text.FlashDdrParaScan,"ax",@progbits
	.align	2
	.global	FlashDdrParaScan
	.type	FlashDdrParaScan, %function
FlashDdrParaScan:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR24
	and	w20, w0, 255
	stp	x21, x22, [sp, 32]
	ldrb	w0, [x19, #:lo12:.LANCHOR24]
	mov	w21, w1
	bl	FlashSetInterfaceMode
	ldrb	w0, [x19, #:lo12:.LANCHOR24]
	bl	NandcSetMode
	mov	w4, 0
	mov	x3, 0
	mov	x2, 0
	mov	w1, w21
	mov	w0, w20
	bl	FlashDdrTunningRead
	mov	x3, 0
	mov	w22, w0
	mov	x2, 0
	mov	w0, w20
	mov	w1, w21
	adrp	x20, .LANCHOR30
	bl	FlashReadRawPage
	cmn	w0, #1
	beq	.L874
	cmn	w22, #1
	bne	.L875
.L874:
	ldrb	w0, [x19, #:lo12:.LANCHOR24]
	tbz	x0, 0, .L875
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
	strb	wzr, [x20, #:lo12:.LANCHOR30]
.L876:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L875:
	mov	w0, 1
	strb	w0, [x20, #:lo12:.LANCHOR30]
	b	.L876
	.size	FlashDdrParaScan, .-FlashDdrParaScan
	.section	.text.FlashLoadPhyInfo,"ax",@progbits
	.align	2
	.global	FlashLoadPhyInfo
	.type	FlashLoadPhyInfo, %function
FlashLoadPhyInfo:
	stp	x29, x30, [sp, -128]!
	mov	w0, 60
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR31
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR147
	strb	w0, [x29, 120]
	mov	w0, 40
	strb	w0, [x29, 121]
	mov	w0, 24
	strb	w0, [x29, 122]
	mov	w0, 16
	strb	w0, [x29, 123]
	add	x0, x20, :lo12:.LANCHOR31
	stp	x23, x24, [sp, 48]
	adrp	x21, .LANCHOR146
	adrp	x24, .LANCHOR148
	stp	x25, x26, [sp, 64]
	ldrh	w0, [x0, 10]
	adrp	x26, .LANCHOR7
	str	w0, [x29, 108]
	mov	w19, 0
	ldr	x0, [x22, #:lo12:.LANCHOR147]
	mov	w25, 4
	str	x0, [x21, #:lo12:.LANCHOR146]
	mov	w23, -1
	stp	x27, x28, [sp, 80]
	add	x26, x26, :lo12:.LANCHOR7
	str	wzr, [x24, #:lo12:.LANCHOR148]
	mov	w0, 0
	bl	flash_enter_slc_mode
.L885:
	add	w28, w19, 1
	mov	x27, 0
.L887:
	add	x0, x29, 120
	ldrb	w0, [x0, x27]
	bl	FlashBchSel
	ldr	x2, [x22, #:lo12:.LANCHOR147]
	mov	x3, 0
	mov	w1, w19
	mov	w0, 0
	bl	FlashReadRawPage
	cmn	w0, #1
	bne	.L886
	ldr	x2, [x22, #:lo12:.LANCHOR147]
	mov	x3, 0
	mov	w1, w28
	mov	w0, 0
	bl	FlashReadRawPage
	cmn	w0, #1
	bne	.L886
	add	x27, x27, 1
	cmp	x27, 4
	bne	.L887
.L888:
	ldr	w0, [x29, 108]
	subs	w25, w25, #1
	add	w19, w19, w0
	bne	.L885
	b	.L893
.L889:
	mov	w1, 2036
	add	x0, x6, 12
	bl	JSHash
	ldr	w1, [x6, 8]
	cmp	w1, w0
	bne	.L895
	add	x23, x20, :lo12:.LANCHOR31
	add	x1, x6, 160
	mov	w2, 32
	mov	x0, x23
	bl	ftl_memcpy
	ldr	x1, [x21, #:lo12:.LANCHOR146]
	mov	w2, 32
	mov	x0, x26
	add	x1, x1, 192
	bl	ftl_memcpy
	ldr	x1, [x21, #:lo12:.LANCHOR146]
	mov	w2, 852
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	add	x1, x1, 224
	bl	ftl_memcpy
	ldr	x1, [x21, #:lo12:.LANCHOR146]
	adrp	x0, .LANCHOR30
	str	w19, [x24, #:lo12:.LANCHOR148]
	ldr	w2, [x1, 1076]
	strb	w2, [x0, #:lo12:.LANCHOR30]
	ldrh	w0, [x23, 10]
	adrp	x2, .LANCHOR149
	udiv	w0, w19, w0
	add	w3, w0, 1
	cbz	w0, .L891
	str	w3, [x2, #:lo12:.LANCHOR149]
.L892:
	adrp	x0, .LANCHOR150
	ldrh	w1, [x1, 14]
	mov	w23, 0
	strb	w1, [x0, #:lo12:.LANCHOR150]
	b	.L888
.L891:
	mov	w0, 2
	str	w0, [x2, #:lo12:.LANCHOR149]
	b	.L892
.L895:
	mov	w23, -1
	b	.L888
.L886:
	ldr	x6, [x21, #:lo12:.LANCHOR146]
	mov	w1, 20036
	movk	w1, 0x4e41, lsl 16
	ldr	w0, [x6]
	cmp	w0, w1
	bne	.L888
	cbnz	w23, .L889
	add	x20, x20, :lo12:.LANCHOR31
	ldrh	w0, [x20, 10]
	udiv	w19, w19, w0
	adrp	x0, .LANCHOR149
	add	w19, w19, 1
	str	w19, [x0, #:lo12:.LANCHOR149]
.L893:
	mov	w0, 0
	bl	flash_exit_slc_mode
	mov	w0, w23
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
	.size	FlashLoadPhyInfo, .-FlashLoadPhyInfo
	.section	.text.ToshibaReadRetrial,"ax",@progbits
	.align	2
	.global	ToshibaReadRetrial
	.type	ToshibaReadRetrial, %function
ToshibaReadRetrial:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w21, w0, 255
	stp	x25, x26, [sp, 64]
	mov	w0, w21
	stp	x19, x20, [sp, 16]
	mov	x25, x2
	stp	x27, x28, [sp, 80]
	mov	x26, x3
	str	w1, [x29, 120]
	stp	x23, x24, [sp, 48]
	bl	NandcWaitFlashReady
	sbfiz	x1, x21, 4, 32
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	add	x2, x0, x1
	ldr	x22, [x0, x1]
	adrp	x1, .LANCHOR11
	ldrb	w27, [x2, 8]
	ldrb	w0, [x1, #:lo12:.LANCHOR11]
	str	x1, [x29, 112]
	add	x19, x27, 8
	sub	w0, w0, #67
	str	w27, [x29, 124]
	and	w0, w0, 255
	add	x19, x22, x19, lsl 8
	cmp	w0, 1
	bls	.L915
	adrp	x0, .LANCHOR30
	ldrb	w0, [x0, #:lo12:.LANCHOR30]
	cbz	w0, .L916
	mov	w23, 1
	mov	w0, 0
	bl	NandcSetDdrMode
.L900:
	add	x0, x22, x27, lsl 8
	mov	w1, 92
	str	w1, [x0, 2056]
	mov	w1, 197
	str	w1, [x0, 2056]
.L899:
	ldrsw	x0, [x29, 124]
	mov	w20, 1
	mov	w24, -1
	add	x0, x0, 8
	add	x0, x22, x0, lsl 8
	str	x0, [x29, 104]
.L901:
	adrp	x0, .LANCHOR151
	ldrb	w0, [x0, #:lo12:.LANCHOR151]
	add	w0, w0, 1
	cmp	w20, w0
	bcc	.L910
	mov	w28, w24
.L909:
	ldr	x0, [x29, 112]
	mov	w1, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x19
	bhi	.L911
	bl	SandiskSetRRPara
.L912:
	ldrsw	x0, [x29, 124]
	add	x0, x0, 8
	add	x22, x22, x0, lsl 8
	mov	w0, 255
	str	w0, [x22, 8]
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L913
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L913:
	mov	w0, w21
	bl	NandcWaitFlashReady
	cbz	w23, .L898
	mov	w0, 4
	bl	NandcSetDdrMode
.L898:
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L916:
	mov	w23, 0
	b	.L900
.L915:
	mov	w23, 0
	b	.L899
.L910:
	ldr	x0, [x29, 112]
	mov	w1, w20
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x19
	bhi	.L902
	bl	SandiskSetRRPara
.L903:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	cmp	w0, 34
	bne	.L904
	adrp	x0, .LANCHOR151
	ldrb	w0, [x0, #:lo12:.LANCHOR151]
	sub	w0, w0, #3
	cmp	w20, w0
	bne	.L904
	ldr	x1, [x29, 104]
	mov	w0, 179
	str	w0, [x1, 8]
.L904:
	add	x0, x22, x27, lsl 8
	mov	w1, 38
	str	w1, [x0, 2056]
	mov	w1, 93
	str	w1, [x0, 2056]
	cbz	w23, .L905
	mov	w0, 4
	bl	NandcSetDdrMode
	ldr	w1, [x29, 120]
	mov	x3, x26
	mov	x2, x25
	mov	w0, w21
	bl	FlashReadRawPage
	mov	w28, w0
	mov	w0, 0
	bl	NandcSetDdrMode
.L906:
	cmn	w28, #1
	beq	.L907
	adrp	x0, .LANCHOR33
	cmn	w24, #1
	csel	w24, w24, w28, ne
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L909
	mov	x26, 0
	mov	x25, 0
.L907:
	add	w20, w20, 1
	b	.L901
.L902:
	bl	ToshibaSetRRPara
	b	.L903
.L905:
	ldr	w1, [x29, 120]
	mov	x3, x26
	mov	x2, x25
	mov	w0, w21
	bl	FlashReadRawPage
	mov	w28, w0
	b	.L906
.L911:
	bl	ToshibaSetRRPara
	b	.L912
	.size	ToshibaReadRetrial, .-ToshibaReadRetrial
	.section	.text.SamsungReadRetrial,"ax",@progbits
	.align	2
	.global	SamsungReadRetrial
	.type	SamsungReadRetrial, %function
SamsungReadRetrial:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	and	w22, w0, 255
	stp	x19, x20, [sp, 16]
	mov	w0, w22
	stp	x23, x24, [sp, 48]
	mov	w23, w1
	stp	x25, x26, [sp, 64]
	mov	x24, x2
	str	x27, [sp, 80]
	mov	x25, x3
	bl	NandcWaitFlashReady
	adrp	x26, .LANCHOR151
	sbfiz	x1, x22, 4, 32
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	adrp	x27, .LANCHOR33
	add	x2, x0, x1
	add	x26, x26, :lo12:.LANCHOR151
	add	x27, x27, :lo12:.LANCHOR33
	mov	w21, 1
	ldr	x0, [x0, x1]
	mov	w19, -1
	ldrb	w20, [x2, 8]
	add	x20, x20, 8
	add	x20, x0, x20, lsl 8
.L927:
	ldrb	w0, [x26]
	add	w0, w0, 1
	cmp	w21, w0
	bcc	.L931
.L930:
	mov	x0, x20
	mov	w1, 0
	bl	SamsungSetRRPara
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L926
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L926:
	mov	w0, w19
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L931:
	mov	w1, w21
	mov	x0, x20
	bl	SamsungSetRRPara
	mov	x3, x25
	mov	x2, x24
	mov	w1, w23
	mov	w0, w22
	bl	FlashReadRawPage
	cmn	w0, #1
	beq	.L928
	ldrb	w1, [x27]
	cmn	w19, #1
	csel	w19, w19, w0, ne
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L933
	mov	x25, 0
	mov	x24, 0
.L928:
	add	w21, w21, 1
	b	.L927
.L933:
	mov	w19, w0
	b	.L930
	.size	SamsungReadRetrial, .-SamsungReadRetrial
	.section	.text.MicronReadRetrial,"ax",@progbits
	.align	2
	.global	MicronReadRetrial
	.type	MicronReadRetrial, %function
MicronReadRetrial:
	stp	x29, x30, [sp, -144]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	adrp	x0, .LANCHOR33
	stp	x23, x24, [sp, 48]
	str	w1, [x29, 140]
	mov	x24, x2
	ldrb	w19, [x0, #:lo12:.LANCHOR33]
	adrp	x0, .LANCHOR8
	stp	x25, x26, [sp, 64]
	mov	x25, x3
	ldrb	w1, [x0, #:lo12:.LANCHOR8]
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	str	x0, [x29, 128]
	cbnz	w1, .L941
	add	w19, w19, w19, lsl 1
	asr	w19, w19, 2
.L942:
	adrp	x21, .LANCHOR6
	add	x21, x21, :lo12:.LANCHOR6
	add	x21, x21, x20, sxtw 4
	mov	w23, 0
	mov	w28, 137
.L952:
	mov	w0, w20
	bl	NandcWaitFlashReady
	ldrb	w4, [x21, 8]
	adrp	x7, .LANCHOR151
	ldr	x8, [x21]
	add	x7, x7, :lo12:.LANCHOR151
	mov	w22, 0
	mov	w26, -1
	add	x27, x8, x4, lsl 8
.L943:
	ldrb	w0, [x7]
	cmp	w22, w0
	bcc	.L947
.L946:
	add	x4, x8, x4, lsl 8
	mov	w0, 239
	str	x4, [x29, 120]
	str	w0, [x4, 2056]
	mov	x0, 200
	str	w28, [x4, 2052]
	bl	udelay
	ldr	x4, [x29, 120]
	cmp	w26, w19
	str	wzr, [x4, 2048]
	str	wzr, [x4, 2048]
	str	wzr, [x4, 2048]
	str	wzr, [x4, 2048]
	bcc	.L948
	cmn	w26, #1
	mov	w0, 256
	csel	w26, w26, w0, eq
.L948:
	cmp	w26, 256
	ccmn	w26, #1, 4, ne
	bne	.L949
	ldr	w2, [x29, 140]
	adrp	x0, .LC13
	mov	w4, w26
	mov	w3, w22
	mov	w1, w22
	add	x0, x0, :lo12:.LC13
	bl	printf
	cbnz	w23, .L950
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L940
	cmn	w26, #1
	bne	.L940
	mov	w1, 3
	mov	w0, w20
	mov	w23, 1
	bl	micron_auto_read_calibration_config
	b	.L952
.L941:
	mov	w0, 3
	sdiv	w19, w19, w0
	b	.L942
.L947:
	mov	w0, 239
	str	w0, [x27, 2056]
	str	w28, [x27, 2052]
	mov	x0, 200
	stp	x4, x7, [x29, 96]
	str	x8, [x29, 112]
	bl	udelay
	add	w10, w22, 1
	str	w10, [x27, 2048]
	str	wzr, [x27, 2048]
	mov	x3, x25
	ldr	w1, [x29, 140]
	mov	x2, x24
	str	wzr, [x27, 2048]
	mov	w0, w20
	str	wzr, [x27, 2048]
	str	w10, [x29, 120]
	bl	FlashReadRawPage
	cmn	w0, #1
	ldr	w10, [x29, 120]
	ldp	x4, x7, [x29, 96]
	ldr	x8, [x29, 112]
	beq	.L944
	cmn	w26, #1
	csel	w26, w26, w0, ne
	cmp	w0, w19
	bcc	.L954
	mov	x25, 0
	mov	x24, 0
.L944:
	mov	w22, w10
	b	.L943
.L954:
	mov	w26, w0
	mov	x25, 0
	mov	x24, 0
	b	.L946
.L950:
	mov	w0, w20
	mov	w1, 0
	bl	micron_auto_read_calibration_config
	cmn	w26, #1
	mov	w0, 256
	csel	w26, w26, w0, eq
.L940:
	mov	w0, w26
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L949:
	cbz	w23, .L940
	mov	w1, 0
	mov	w0, w20
	mov	w26, 256
	bl	micron_auto_read_calibration_config
	b	.L940
	.size	MicronReadRetrial, .-MicronReadRetrial
	.section	.text.HynixReadRetrial,"ax",@progbits
	.align	2
	.global	HynixReadRetrial
	.type	HynixReadRetrial, %function
HynixReadRetrial:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	mov	w25, w1
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR20
	add	x1, x19, :lo12:.LANCHOR20
	stp	x27, x28, [sp, 80]
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR18
	stp	x23, x24, [sp, 48]
	and	x28, x0, 255
	add	x0, x1, x28
	mov	x23, x28
	ldrb	w24, [x1, 2]
	mov	x26, x2
	ldr	x1, [x22, #:lo12:.LANCHOR18]
	mov	x27, x3
	ldrb	w20, [x0, 12]
	ldrb	w1, [x1, 19]
	cmp	w1, 7
	bne	.L966
	ldrb	w20, [x0, 20]
.L966:
	mov	w0, w23
	bl	NandcWaitFlashReady
	add	x6, x19, :lo12:.LANCHOR20
	adrp	x5, .LANCHOR33
	add	x7, x6, 4
	add	x5, x5, :lo12:.LANCHOR33
	mov	w4, 0
	mov	w21, -1
.L967:
	cmp	w4, w24
	bcc	.L972
.L971:
	ldr	x0, [x22, #:lo12:.LANCHOR18]
	add	x19, x19, :lo12:.LANCHOR20
	add	x19, x19, x28
	ldrb	w0, [x0, 19]
	cmp	w0, 7
	bne	.L973
	strb	w20, [x19, 20]
.L974:
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w21, w0, lsr 2
	bcc	.L965
	cmn	w21, #1
	mov	w0, 256
	csel	w21, w21, w0, eq
.L965:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L972:
	add	w20, w20, 1
	ldrb	w1, [x6, 1]
	and	w20, w20, 255
	mov	x2, x7
	cmp	w24, w20
	str	x5, [x29, 96]
	csel	w20, w20, wzr, hi
	str	w4, [x29, 108]
	stp	x7, x6, [x29, 112]
	mov	w3, w20
	mov	w0, w23
	bl	HynixSetRRPara
	mov	x3, x27
	mov	x2, x26
	mov	w1, w25
	mov	w0, w23
	bl	FlashReadRawPage
	cmn	w0, #1
	ldr	w4, [x29, 108]
	ldr	x5, [x29, 96]
	ldp	x7, x6, [x29, 112]
	beq	.L969
	ldrb	w1, [x5]
	cmn	w21, #1
	csel	w21, w21, w0, ne
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L976
	mov	x27, 0
	mov	x26, 0
.L969:
	add	w4, w4, 1
	b	.L967
.L976:
	mov	w21, w0
	b	.L971
.L973:
	strb	w20, [x19, 12]
	b	.L974
	.size	HynixReadRetrial, .-HynixReadRetrial
	.section	.text.FlashProgPage,"ax",@progbits
	.align	2
	.global	FlashProgPage
	.type	FlashProgPage, %function
FlashProgPage:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	stp	x21, x22, [sp, 32]
	adrp	x1, .LANCHOR31+9
	str	x23, [sp, 48]
	mov	x22, x2
	ldrb	w21, [x1, #:lo12:.LANCHOR31+9]
	ands	w19, w0, 255
	mov	x23, x3
	bne	.L984
	adrp	x0, .LANCHOR2
	adrp	x1, .LANCHOR3
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	ldr	w1, [x1, #:lo12:.LANCHOR3]
	mul	w0, w0, w1
	cmp	w0, w20
	bls	.L984
	adrp	x0, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR1]
	cbnz	w0, .L985
	sub	w21, w21, #2
.L984:
	mov	w0, w19
	bl	NandcWaitFlashReady
	mov	w0, w19
	bl	NandcFlashCs
	mov	w1, w20
	mov	w0, w19
	bl	FlashProgFirstCmd
	mov	x4, x23
	mov	x3, x22
	mov	w2, w21
	mov	w1, 1
	mov	w0, w19
	bl	NandcXferData
	mov	w1, w20
	mov	w0, w19
	bl	FlashProgSecondCmd
	mov	w0, w19
	bl	NandcWaitFlashReady
	mov	w1, w20
	mov	w0, w19
	bl	FlashReadStatus
	mov	w2, w0
	mov	w0, w19
	bl	NandcFlashDeCs
	ldr	x23, [sp, 48]
	and	w0, w2, 1
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L985:
	mov	w21, 4
	b	.L984
	.size	FlashProgPage, .-FlashProgPage
	.section	.text.FlashSavePhyInfo,"ax",@progbits
	.align	2
	.global	FlashSavePhyInfo
	.type	FlashSavePhyInfo, %function
FlashSavePhyInfo:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR147
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR146
	ldr	x0, [x22, #:lo12:.LANCHOR147]
	adrp	x21, .LANCHOR3
	str	x0, [x19, #:lo12:.LANCHOR146]
	mov	w20, 0
	adrp	x0, .LANCHOR152
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	mov	w25, 20036
	ldrb	w0, [x0, #:lo12:.LANCHOR152]
	movk	w25, 0x4e41, lsl 16
	adrp	x24, .LANCHOR153
	adrp	x26, .LANCHOR149
	mov	w23, 0
	add	x21, x21, :lo12:.LANCHOR3
	add	x26, x26, :lo12:.LANCHOR149
	bl	FlashBchSel
	ldr	x0, [x22, #:lo12:.LANCHOR147]
	mov	w2, 2048
	mov	w1, 0
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR146]
	adrp	x1, .LANCHOR25
	mov	w2, 32
	add	x0, x0, 16
	str	w25, [x0, -16]
	ldrb	w1, [x1, #:lo12:.LANCHOR25]
	strh	w1, [x0, -4]
	adrp	x1, .LANCHOR2
	ldrb	w1, [x1, #:lo12:.LANCHOR2]
	strh	w1, [x0, -2]
	adrp	x1, .LANCHOR30
	ldrb	w1, [x1, #:lo12:.LANCHOR30]
	str	w1, [x0, 1060]
	adrp	x1, .LANCHOR22
	add	x1, x1, :lo12:.LANCHOR22
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR146]
	mov	w2, 8
	adrp	x1, .LANCHOR26
	add	x1, x1, :lo12:.LANCHOR26
	add	x0, x0, 80
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR146]
	mov	w2, 32
	adrp	x1, .LANCHOR17
	add	x1, x1, :lo12:.LANCHOR17
	add	x0, x0, 96
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR146]
	mov	w2, 32
	adrp	x1, .LANCHOR31
	add	x1, x1, :lo12:.LANCHOR31
	add	x0, x0, 160
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR146]
	mov	w2, 32
	adrp	x1, .LANCHOR7
	add	x1, x1, :lo12:.LANCHOR7
	add	x0, x0, 192
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR146]
	mov	w2, 852
	adrp	x1, .LANCHOR20
	add	x1, x1, :lo12:.LANCHOR20
	add	x0, x0, 224
	bl	ftl_memcpy
	ldr	x6, [x19, #:lo12:.LANCHOR146]
	mov	w1, 2036
	add	x0, x6, 12
	bl	JSHash
	str	w0, [x6, 8]
	mov	w0, 1592
	str	w0, [x6, 4]
	ldr	x0, [x24, #:lo12:.LANCHOR153]
	str	x0, [x19, #:lo12:.LANCHOR146]
	mov	w0, 0
	bl	flash_enter_slc_mode
.L990:
	ldr	w1, [x21]
	mov	w2, 0
	mov	w0, 0
	mul	w1, w20, w1
	bl	FlashEraseBlock
	ldr	w1, [x21]
	mov	x3, 0
	ldr	x2, [x22, #:lo12:.LANCHOR147]
	mov	w0, 0
	mul	w1, w20, w1
	bl	FlashProgPage
	ldr	w1, [x21]
	mov	x3, 0
	ldr	x2, [x22, #:lo12:.LANCHOR147]
	mov	w0, 0
	mul	w1, w20, w1
	add	w1, w1, 1
	bl	FlashProgPage
	ldr	w1, [x21]
	mov	x3, 0
	ldr	x2, [x24, #:lo12:.LANCHOR153]
	mov	w0, 0
	mul	w1, w20, w1
	bl	FlashReadRawPage
	cmn	w0, #1
	add	w7, w20, 1
	beq	.L988
	ldr	x6, [x19, #:lo12:.LANCHOR146]
	ldr	w0, [x6]
	cmp	w0, w25
	bne	.L988
	mov	w1, 2036
	add	x0, x6, 12
	bl	JSHash
	ldr	w1, [x6, 8]
	cmp	w1, w0
	bne	.L988
	ldr	w0, [x21]
	cmp	w23, 1
	str	w7, [x26]
	mul	w20, w0, w20
	adrp	x0, .LANCHOR148
	str	w20, [x0, #:lo12:.LANCHOR148]
	beq	.L991
	mov	w23, 1
.L988:
	mov	w20, w7
	cmp	w7, 4
	bne	.L990
.L989:
	mov	w0, 0
	bl	flash_exit_slc_mode
	cmp	w23, 0
	csetm	w0, eq
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L991:
	mov	w23, 2
	b	.L989
	.size	FlashSavePhyInfo, .-FlashSavePhyInfo
	.section	.text.FlashReadIdbDataRaw,"ax",@progbits
	.align	2
	.global	FlashReadIdbDataRaw
	.type	FlashReadIdbDataRaw, %function
FlashReadIdbDataRaw:
	stp	x29, x30, [sp, -144]!
	mov	w1, 12336
	movk	w1, 0x5638, lsl 16
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	x23, x0
	mov	w0, 60
	stp	x25, x26, [sp, 64]
	strb	w0, [x29, 136]
	mov	w0, 40
	strb	w0, [x29, 137]
	mov	w0, 24
	strb	w0, [x29, 138]
	mov	w0, 16
	strb	w0, [x29, 139]
	adrp	x0, .LANCHOR33
	stp	x19, x20, [sp, 16]
	ldrb	w26, [x0, #:lo12:.LANCHOR33]
	adrp	x0, .LANCHOR29
	stp	x21, x22, [sp, 32]
	ldr	w2, [x0, #:lo12:.LANCHOR29]
	stp	x27, x28, [sp, 80]
	str	x0, [x29, 120]
	cmp	w2, w1
	bne	.L998
	mov	w0, 0
	bl	flash_enter_slc_mode
.L998:
	adrp	x24, .LANCHOR2
	adrp	x22, .LANCHOR3
	add	x27, x29, 136
	add	x22, x22, :lo12:.LANCHOR3
	add	x28, x24, :lo12:.LANCHOR2
	mov	w20, -1
	mov	w19, 2
	mov	w2, 2048
	mov	w1, 0
	mov	x0, x23
	bl	ftl_memset
.L999:
	ldrb	w0, [x24, #:lo12:.LANCHOR2]
	cmp	w19, w0
	bcc	.L1004
.L1003:
	mov	w0, w26
	bl	FlashBchSel
	ldr	x0, [x29, 120]
	ldr	w1, [x0, #:lo12:.LANCHOR29]
	mov	w0, 12336
	movk	w0, 0x5638, lsl 16
	cmp	w1, w0
	bne	.L997
	mov	w0, 0
	bl	flash_exit_slc_mode
.L997:
	mov	w0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1004:
	mov	x4, 0
	adrp	x25, .LANCHOR147
.L1001:
	ldrb	w5, [x4, x27]
	add	x21, x25, :lo12:.LANCHOR147
	str	w5, [x29, 116]
	mov	w0, w5
	str	x4, [x29, 104]
	bl	FlashBchSel
	ldr	w1, [x22]
	mov	x3, 0
	ldr	x2, [x25, #:lo12:.LANCHOR147]
	mov	w0, 0
	mul	w1, w19, w1
	bl	FlashReadRawPage
	cmn	w0, #1
	ldr	w5, [x29, 116]
	bne	.L1000
	ldr	x4, [x29, 104]
	add	x4, x4, 1
	cmp	x4, 4
	bne	.L1001
.L1002:
	add	w19, w19, 1
	b	.L999
.L1007:
	mov	w20, 0
	b	.L1003
.L1000:
	ldr	x0, [x21]
	ldr	w1, [x0]
	mov	w0, 35899
	movk	w0, 0xfcdc, lsl 16
	cmp	w1, w0
	bne	.L1002
	mov	w1, w5
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printf
	ldr	x1, [x21]
	mov	w2, 2048
	mov	x0, x23
	bl	ftl_memcpy
	ldr	x0, [x21]
	ldr	w0, [x0, 512]
	strb	w0, [x28]
	adrp	x0, .LANCHOR149
	ldr	w1, [x0, #:lo12:.LANCHOR149]
	cmp	w19, w1
	bcs	.L1007
	str	w19, [x0, #:lo12:.LANCHOR149]
	mov	w20, 0
	bl	FlashSavePhyInfo
	b	.L1002
	.size	FlashReadIdbDataRaw, .-FlashReadIdbDataRaw
	.section	.text.FlashPageProgMsbFFData,"ax",@progbits
	.align	2
	.global	FlashPageProgMsbFFData
	.type	FlashPageProgMsbFFData, %function
FlashPageProgMsbFFData:
	stp	x29, x30, [sp, -80]!
	adrp	x3, .LANCHOR8
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w2, 65535
	adrp	x2, .LANCHOR18
	stp	x21, x22, [sp, 32]
	ldrb	w3, [x3, #:lo12:.LANCHOR8]
	and	w21, w0, 255
	ldr	x0, [x2, #:lo12:.LANCHOR18]
	mov	x22, x2
	stp	x23, x24, [sp, 48]
	str	x25, [sp, 64]
	ldrb	w0, [x0, 19]
	cbz	w3, .L1011
	adrp	x2, .LANCHOR29
	ldr	w3, [x2, #:lo12:.LANCHOR29]
	mov	w2, 12336
	movk	w2, 0x5638, lsl 16
	cmp	w3, w2
	beq	.L1010
.L1011:
	sub	w0, w0, #5
	and	w0, w0, 255
	cmp	w0, 63
	bhi	.L1010
	mov	x2, 16391
	movk	x2, 0x4000, lsl 16
	movk	x2, 0x8000, lsl 48
	lsr	x0, x2, x0
	tbz	x0, 0, .L1010
	adrp	x20, .LANCHOR120
	mov	w24, w1
	add	x20, x20, :lo12:.LANCHOR120
	mov	w23, 65535
	adrp	x25, .LANCHOR153
.L1013:
	ldr	x0, [x22, #:lo12:.LANCHOR18]
	ldrh	w0, [x0, 10]
	cmp	w0, w19
	bhi	.L1014
.L1010:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1014:
	ldrh	w0, [x20, w19, sxtw 1]
	cmp	w0, w23
	bne	.L1010
	ldr	x0, [x25, #:lo12:.LANCHOR153]
	mov	w2, 32768
	mov	w1, 255
	bl	ftl_memset
	ldr	x2, [x25, #:lo12:.LANCHOR153]
	add	w1, w19, w24
	add	w19, w19, 1
	mov	x3, 0
	mov	w0, w21
	and	w19, w19, 65535
	bl	FlashProgPage
	b	.L1013
	.size	FlashPageProgMsbFFData, .-FlashPageProgMsbFFData
	.section	.text.idb_write_data,"ax",@progbits
	.align	2
	.global	idb_write_data
	.type	idb_write_data, %function
idb_write_data:
	stp	x29, x30, [sp, -240]!
	add	w0, w1, w3
	mov	w4, w1
	cmp	w0, 63
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	bls	.L1020
	cmp	w1, 575
	bhi	.L1021
	adrp	x0, .LANCHOR154
	mov	x1, x2
	mov	w2, 1
	cmp	w4, 64
	str	w2, [x0, #:lo12:.LANCHOR154]
	adrp	x0, idb_buf
	bhi	.L1022
	mov	w2, 64
	sub	w4, w2, w4
	sub	w2, w3, w4
	ubfiz	x4, x4, 9, 25
	lsl	w2, w2, 9
	add	x1, x1, x4
	add	x0, x0, :lo12:idb_buf
.L1072:
	bl	ftl_memcpy
.L1055:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	ret
.L1022:
	mov	w2, 576
	sub	w2, w2, w4
	cmp	w3, w2
	sub	w4, w4, #64
	csel	w2, w3, w2, ls
	ubfiz	x4, x4, 9, 25
	add	x0, x0, :lo12:idb_buf
	lsl	w2, w2, 9
	add	x0, x0, x4
	b	.L1072
.L1020:
	cmp	w1, 575
	bls	.L1055
.L1021:
	adrp	x0, .LANCHOR154
	str	x0, [x29, 112]
	ldr	w1, [x0, #:lo12:.LANCHOR154]
	cbz	w1, .L1055
	adrp	x21, .LANCHOR18
	adrp	x1, idb_buf+262140
	adrp	x25, idb_buf
	add	x1, x1, :lo12:idb_buf+262140
	ldr	x0, [x21, #:lo12:.LANCHOR18]
	add	x5, x25, :lo12:idb_buf
	mov	w2, 65535
	mov	w3, 4097
	ldrb	w20, [x0, 9]
	ldrh	w0, [x0, 10]
	mul	w20, w20, w0
	and	w20, w20, 65535
	add	w0, w20, 511
	udiv	w0, w0, w20
	str	w0, [x29, 172]
	mov	w0, 0
.L1026:
	ldr	w4, [x1]
	cbnz	w4, .L1024
	ldr	w4, [x5, w0, uxtw 2]
	add	w0, w0, 1
	str	w4, [x1], -4
	cmp	w0, w3
	sub	w2, w2, #1
	csel	w0, w0, wzr, cc
	cmp	w2, 4096
	bne	.L1026
.L1024:
	add	x0, x25, :lo12:idb_buf
	mov	w3, 512
	mov	w23, 0
	ldr	w1, [x0, w2, uxtw 2]
	adrp	x0, .LC15
	add	x0, x0, :lo12:.LC15
	bl	printf
	adrp	x0, .LANCHOR149
	ldr	w24, [x0, #:lo12:.LANCHOR149]
	ldr	w0, [x29, 172]
	mul	w19, w20, w24
	mul	w0, w20, w0
	str	w0, [x29, 120]
	adrp	x0, .LANCHOR16
	add	x0, x0, :lo12:.LANCHOR16
	str	x0, [x29, 160]
.L1027:
	cmp	w24, 15
	bls	.L1045
	cbnz	w23, .L1047
	adrp	x0, .LC17
	mov	w1, 0
	add	x0, x0, :lo12:.LC17
	bl	printf
.L1047:
	ldr	x0, [x29, 112]
	str	wzr, [x0, #:lo12:.LANCHOR154]
	b	.L1055
.L1045:
	adrp	x27, gp_flash_check_buf
	mov	x2, 512
	mov	w1, 0
	add	x0, x27, :lo12:gp_flash_check_buf
	bl	memset
	ldr	x0, [x21, #:lo12:.LANCHOR18]
	ldrb	w22, [x0, 9]
	ldrh	w26, [x0, 10]
	mov	w0, w19
	bl	FW_FlashBlockErase.constprop.41
	str	x27, [x29, 136]
	mul	w26, w22, w26
	and	w26, w26, 65535
	cmp	w26, 511
	bhi	.L1028
	add	w0, w26, w19
	bl	FW_FlashBlockErase.constprop.41
.L1028:
	udiv	w4, w19, w26
	adrp	x5, .LANCHOR8
	add	x5, x5, :lo12:.LANCHOR8
	mov	x28, 0
	msub	w4, w4, w26, w19
	sub	w26, w19, w4
.L1029:
	add	x6, x25, :lo12:idb_buf
	cmp	x28, 128
	add	x6, x6, x28, lsl 11
	bne	.L1033
	ldr	x0, [x21, #:lo12:.LANCHOR18]
	mov	w26, 0
	ldr	x1, [x29, 136]
	add	x27, x1, :lo12:gp_flash_check_buf
	adrp	x1, .LANCHOR8
	ldrb	w28, [x0, 9]
	add	x1, x1, :lo12:.LANCHOR8
	ldrh	w22, [x0, 10]
	str	x1, [x29, 104]
	mul	w22, w28, w22
	and	w0, w22, 65535
	udiv	w22, w19, w0
	msub	w22, w22, w0, w19
	sub	w0, w19, w22
	str	w0, [x29, 128]
	mul	w0, w22, w28
	ubfx	x0, x0, 2, 2
.L1034:
	cmp	w26, 511
	bhi	.L1041
	ldr	x3, [x29, 104]
	mov	w1, 4
	sub	w1, w1, w0
	add	w2, w22, w26
	and	w1, w1, 65535
	str	w1, [x29, 144]
	ldr	x1, [x29, 160]
	lsr	w2, w2, 2
	ldrb	w3, [x3]
	ldrh	w1, [x1, w2, sxtw 1]
	cbz	w3, .L1035
	adrp	x3, .LANCHOR29
	mov	w4, 12336
	movk	w4, 0x5638, lsl 16
	ldr	w3, [x3, #:lo12:.LANCHOR29]
	cmp	w3, w4
	csel	w1, w1, w2, ne
.L1035:
	ldr	w2, [x29, 128]
	add	w0, w0, w2
	madd	w3, w28, w1, w0
	adrp	x0, .LANCHOR33
	adrp	x1, .LANCHOR3
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	str	w0, [x29, 124]
	ldr	x0, [x21, #:lo12:.LANCHOR18]
	ldr	w1, [x1, #:lo12:.LANCHOR3]
	ldrb	w4, [x0, 9]
	adrp	x0, .LANCHOR15+26
	ldrh	w0, [x0, #:lo12:.LANCHOR15+26]
	mul	w0, w0, w1
	mul	w0, w0, w4
	cmp	w3, w0
	bcs	.L1036
	adrp	x0, .LANCHOR152
	ldrb	w0, [x0, #:lo12:.LANCHOR152]
	bl	FlashBchSel
.L1036:
	mov	w0, 0
	bl	flash_boot_enter_slc_mode
	udiv	w1, w3, w4
	add	x3, x29, 176
	mov	x2, x27
	mov	w0, 0
	str	w1, [x29, 168]
	bl	FlashReadPage
	mov	w3, w0
	cmn	w0, #1
	bne	.L1037
	adrp	x0, .LANCHOR152
	ldrb	w0, [x0, #:lo12:.LANCHOR152]
	cmp	w0, 40
	beq	.L1037
	mov	w0, 40
	bl	FlashBchSel
	ldr	w1, [x29, 168]
	add	x3, x29, 176
	mov	x2, x27
	mov	w0, 0
	bl	FlashReadPage
	mov	w3, w0
.L1037:
	mov	w0, 0
	bl	flash_boot_exit_slc_mode
	ldrb	w0, [x29, 124]
	bl	FlashBchSel
	cmn	w3, #1
	bne	.L1038
.L1041:
	ldr	x0, [x29, 136]
	add	x1, x25, :lo12:idb_buf
	mov	x22, 0
	add	x26, x0, :lo12:gp_flash_check_buf
.L1039:
	lsl	x0, x22, 2
	mov	w27, w22
	add	x28, x0, x1
	ldr	w2, [x0, x26]
	ldr	w0, [x0, x1]
	cmp	w2, w0
	beq	.L1042
	mov	x2, 512
	mov	w1, 0
	mov	x0, x26
	bl	memset
	ldr	w2, [x26, w27, uxtw 2]
	mov	w4, w22
	ldr	w3, [x28]
	mov	w1, w19
	adrp	x0, .LC16
	add	x0, x0, :lo12:.LC16
	bl	printf
	mov	w0, w19
	bl	FW_FlashBlockErase.constprop.41
	ldr	w0, [x29, 172]
	cmp	w0, 1
	bls	.L1043
	add	w0, w20, w19
	bl	FW_FlashBlockErase.constprop.41
.L1043:
	ldr	w0, [x29, 172]
	add	w24, w24, w0
	ldr	w0, [x29, 120]
	add	w19, w19, w0
	b	.L1027
.L1033:
	add	w1, w4, w28, lsl 2
	lsr	w1, w1, 2
	cbz	w1, .L1030
	ldr	x0, [x29, 160]
	add	w2, w1, 1
	ldrb	w3, [x5]
	ldrh	w0, [x0, w2, sxtw 1]
	cbz	w3, .L1031
	adrp	x3, .LANCHOR29
	mov	w7, 12336
	movk	w7, 0x5638, lsl 16
	ldr	w3, [x3, #:lo12:.LANCHOR29]
	cmp	w3, w7
	csel	w0, w0, w2, ne
.L1031:
	lsl	w0, w0, 2
	sub	w0, w0, #4
	str	w0, [x29, 176]
.L1030:
	mov	w0, 61424
	str	w0, [x29, 180]
	ldr	x0, [x29, 160]
	ldrh	w27, [x0, w1, sxtw 1]
	ldrb	w0, [x5]
	cbz	w0, .L1032
	adrp	x0, .LANCHOR29
	mov	w2, 12336
	movk	w2, 0x5638, lsl 16
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	cmp	w0, w2
	csel	w27, w27, w1, ne
.L1032:
	adrp	x0, .LANCHOR33
	madd	w8, w22, w27, w26
	str	x5, [x29, 128]
	add	x28, x28, 1
	ldrb	w7, [x0, #:lo12:.LANCHOR33]
	adrp	x0, .LANCHOR152
	str	w4, [x29, 168]
	ldrb	w0, [x0, #:lo12:.LANCHOR152]
	str	w7, [x29, 144]
	bl	FlashBchSel
	mov	w0, 0
	bl	flash_boot_enter_slc_mode
	ldr	x0, [x21, #:lo12:.LANCHOR18]
	mov	x2, x6
	add	x3, x29, 176
	ldrb	w1, [x0, 9]
	mov	w0, 0
	udiv	w1, w8, w1
	bl	FlashProgPage
	mov	w0, 0
	bl	flash_boot_exit_slc_mode
	ldr	w7, [x29, 144]
	mov	w0, w7
	bl	FlashBchSel
	udiv	w1, w26, w22
	add	w2, w27, 1
	mov	w0, 0
	bl	FlashPageProgMsbFFData
	ldr	w4, [x29, 168]
	ldr	x5, [x29, 128]
	b	.L1029
.L1038:
	ldr	x0, [x29, 144]
	ubfiz	x0, x0, 9, 16
	add	x27, x27, x0
	ldr	w0, [x29, 144]
	add	w26, w0, w26
	mov	w0, 0
	and	w26, w26, 65535
	b	.L1034
.L1042:
	add	x22, x22, 1
	cmp	x22, 65536
	bne	.L1039
	add	w23, w23, 1
	cmp	w23, 5
	bls	.L1043
	b	.L1047
	.size	idb_write_data, .-idb_write_data
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
	.section	.text.NandcInit,"ax",@progbits
	.align	2
	.global	NandcInit
	.type	NandcInit, %function
NandcInit:
	stp	x29, x30, [sp, -16]!
	adrp	x2, .LANCHOR6
	add	x1, x2, :lo12:.LANCHOR6
	adrp	x4, .LANCHOR29
	add	x29, sp, 0
	str	x0, [x2, #:lo12:.LANCHOR6]
	mov	w2, 1
	str	w2, [x1, 24]
	mov	w2, 2
	str	wzr, [x1, 8]
	str	w2, [x1, 40]
	mov	w2, 3
	str	x0, [x1, 16]
	str	w2, [x1, 56]
	adrp	x2, .LANCHOR155
	str	x0, [x1, 32]
	str	x0, [x1, 48]
	adrp	x1, .LANCHOR19
	str	x0, [x1, #:lo12:.LANCHOR19]
	ldr	w1, [x0]
	ubfx	x3, x1, 13, 1
	str	w3, [x2, #:lo12:.LANCHOR155]
	ldr	w2, [x0, 352]
	adrp	x3, .LANCHOR34
	and	w1, w1, 245760
	orr	w1, w1, 256
	ubfx	x2, x2, 16, 4
	str	w2, [x3, #:lo12:.LANCHOR34]
	ldr	w2, [x0, 352]
	str	w2, [x4, #:lo12:.LANCHOR29]
	cmp	w2, 2049
	bne	.L1077
	mov	w2, 8
	str	w2, [x3, #:lo12:.LANCHOR34]
.L1077:
	str	w1, [x0]
	mov	w1, 4225
	str	wzr, [x0, 336]
	str	w1, [x0, 4]
	mov	w1, 8322
	str	w1, [x0, 344]
	mov	w1, 6657
	movk	w1, 0x1a, lsl 16
	str	w1, [x0, 304]
	mov	w0, 36864
	bl	ftl_malloc
	adrp	x1, .LANCHOR156
	adrp	x2, .LANCHOR35
	str	x0, [x1, #:lo12:.LANCHOR156]
	add	x1, x2, :lo12:.LANCHOR35
	str	x0, [x2, #:lo12:.LANCHOR35]
	add	x0, x0, 32768
	str	wzr, [x1, 40]
	str	x0, [x1, 8]
	adrp	x0, .LANCHOR36
	ldp	x29, x30, [sp], 16
	str	wzr, [x0, #:lo12:.LANCHOR36]
	ret
	.size	NandcInit, .-NandcInit
	.section	.text.FtlMemInit,"ax",@progbits
	.align	2
	.global	FtlMemInit
	.type	FtlMemInit, %function
FtlMemInit:
	stp	x29, x30, [sp, -64]!
	adrp	x0, .LANCHOR139
	mov	w1, 65535
	add	x29, sp, 0
	strh	wzr, [x0, #:lo12:.LANCHOR139]
	adrp	x0, .LANCHOR157
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR55
	str	wzr, [x0, #:lo12:.LANCHOR157]
	adrp	x0, .LANCHOR158
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR38
	str	wzr, [x0, #:lo12:.LANCHOR158]
	adrp	x0, .LANCHOR159
	str	x23, [sp, 48]
	adrp	x21, .LANCHOR58
	str	wzr, [x0, #:lo12:.LANCHOR159]
	adrp	x0, .LANCHOR160
	adrp	x23, .LANCHOR59
	str	wzr, [x0, #:lo12:.LANCHOR160]
	adrp	x0, .LANCHOR161
	str	wzr, [x0, #:lo12:.LANCHOR161]
	adrp	x0, .LANCHOR162
	str	wzr, [x0, #:lo12:.LANCHOR162]
	adrp	x0, .LANCHOR163
	str	wzr, [x0, #:lo12:.LANCHOR163]
	adrp	x0, .LANCHOR164
	str	wzr, [x0, #:lo12:.LANCHOR164]
	adrp	x0, .LANCHOR165
	str	wzr, [x0, #:lo12:.LANCHOR165]
	adrp	x0, .LANCHOR166
	str	wzr, [x0, #:lo12:.LANCHOR166]
	adrp	x0, .LANCHOR167
	str	wzr, [x0, #:lo12:.LANCHOR167]
	adrp	x0, .LANCHOR168
	str	wzr, [x0, #:lo12:.LANCHOR168]
	adrp	x0, .LANCHOR80
	str	wzr, [x0, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR169
	str	wzr, [x0, #:lo12:.LANCHOR169]
	adrp	x0, .LANCHOR170
	str	wzr, [x0, #:lo12:.LANCHOR170]
	adrp	x0, .LANCHOR171
	str	wzr, [x0, #:lo12:.LANCHOR171]
	adrp	x0, .LANCHOR172
	str	wzr, [x0, #:lo12:.LANCHOR172]
	adrp	x0, .LANCHOR173
	str	w1, [x0, #:lo12:.LANCHOR173]
	adrp	x0, .LANCHOR174
	adrp	x1, .LANCHOR113
	str	wzr, [x0, #:lo12:.LANCHOR174]
	adrp	x0, .LANCHOR175
	str	wzr, [x0, #:lo12:.LANCHOR175]
	adrp	x0, .LANCHOR74
	str	wzr, [x0, #:lo12:.LANCHOR74]
	mov	w0, -1
	strh	w0, [x1, #:lo12:.LANCHOR113]
	adrp	x1, .LANCHOR114
	strh	w0, [x1, #:lo12:.LANCHOR114]
	adrp	x1, .LANCHOR115
	strh	w0, [x1, #:lo12:.LANCHOR115]
	adrp	x1, .LANCHOR116
	strh	w0, [x1, #:lo12:.LANCHOR116]
	adrp	x0, .LANCHOR176
	mov	w1, 32
	strh	w1, [x0, #:lo12:.LANCHOR176]
	adrp	x0, .LANCHOR177
	mov	w1, 128
	strh	w1, [x0, #:lo12:.LANCHOR177]
	adrp	x0, .LANCHOR178
	strh	wzr, [x0, #:lo12:.LANCHOR178]
	adrp	x0, .LANCHOR117
	strh	wzr, [x0, #:lo12:.LANCHOR117]
	adrp	x0, .LANCHOR179
	strh	wzr, [x0, #:lo12:.LANCHOR179]
	adrp	x0, .LANCHOR119
	strh	wzr, [x0, #:lo12:.LANCHOR119]
	ldrh	w0, [x19, #:lo12:.LANCHOR55]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR110
	str	x0, [x1, #:lo12:.LANCHOR110]
	mov	w0, 12
	ldrh	w1, [x19, #:lo12:.LANCHOR55]
	mul	w0, w1, w0
	bl	ftl_malloc
	ldrh	w19, [x22, #:lo12:.LANCHOR38]
	adrp	x1, .LANCHOR112
	str	x0, [x1, #:lo12:.LANCHOR112]
	mov	w0, 56
	mul	w19, w19, w0
	lsl	w20, w19, 2
	mov	w0, w20
	bl	ftl_malloc
	adrp	x1, .LANCHOR180
	str	x0, [x1, #:lo12:.LANCHOR180]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR181
	str	x0, [x1, #:lo12:.LANCHOR181]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x20, .LANCHOR108
	adrp	x1, .LANCHOR182
	str	x0, [x1, #:lo12:.LANCHOR182]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR78
	str	x0, [x1, #:lo12:.LANCHOR78]
	mov	w0, w19
	bl	ftl_malloc
	ldrh	w19, [x21, #:lo12:.LANCHOR58]
	adrp	x1, .LANCHOR107
	str	x0, [x1, #:lo12:.LANCHOR107]
	ldrh	w0, [x22, #:lo12:.LANCHOR38]
	lsl	w0, w0, 1
	add	w0, w0, 1
	str	w0, [x20, #:lo12:.LANCHOR108]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR183
	str	x0, [x1, #:lo12:.LANCHOR183]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR184
	str	x0, [x1, #:lo12:.LANCHOR184]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR185
	str	x0, [x1, #:lo12:.LANCHOR185]
	ldr	w0, [x20, #:lo12:.LANCHOR108]
	mul	w0, w19, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR105
	str	x0, [x1, #:lo12:.LANCHOR105]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR186
	str	x0, [x1, #:lo12:.LANCHOR186]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR187
	str	x0, [x1, #:lo12:.LANCHOR187]
	mov	w0, 24
	ldr	w1, [x20, #:lo12:.LANCHOR108]
	mul	w0, w1, w0
	bl	ftl_malloc
	ldrh	w19, [x23, #:lo12:.LANCHOR59]
	adrp	x1, .LANCHOR104
	str	x0, [x1, #:lo12:.LANCHOR104]
	ldrh	w0, [x22, #:lo12:.LANCHOR38]
	adrp	x22, .LANCHOR65
	mul	w19, w19, w0
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR188
	str	x0, [x1, #:lo12:.LANCHOR188]
	lsl	w0, w19, 2
	bl	ftl_malloc
	adrp	x19, .LANCHOR41
	adrp	x1, .LANCHOR189
	str	x0, [x1, #:lo12:.LANCHOR189]
	ldrh	w1, [x23, #:lo12:.LANCHOR59]
	ldr	w0, [x20, #:lo12:.LANCHOR108]
	adrp	x20, .LANCHOR190
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR106
	str	x0, [x1, #:lo12:.LANCHOR106]
	ldrh	w0, [x19, #:lo12:.LANCHOR41]
	ubfiz	w0, w0, 1, 15
	strh	w0, [x20, #:lo12:.LANCHOR190]
	and	w0, w0, 65534
	bl	ftl_malloc
	adrp	x1, .LANCHOR137
	str	x0, [x1, #:lo12:.LANCHOR137]
	ldrh	w0, [x20, #:lo12:.LANCHOR190]
	add	x0, x0, 547
	lsr	x0, x0, 9
	strh	w0, [x20, #:lo12:.LANCHOR190]
	lsl	w0, w0, 9
	bl	ftl_malloc
	adrp	x1, .LANCHOR191
	str	x0, [x1, #:lo12:.LANCHOR191]
	adrp	x1, .LANCHOR79
	add	x0, x0, 32
	str	x0, [x1, #:lo12:.LANCHOR79]
	ldrh	w0, [x19, #:lo12:.LANCHOR41]
	lsl	w0, w0, 1
	bl	ftl_malloc
	ldr	w20, [x22, #:lo12:.LANCHOR65]
	adrp	x1, .LANCHOR84
	str	x0, [x1, #:lo12:.LANCHOR84]
	lsl	w20, w20, 1
	mov	w0, w20
	bl	ftl_malloc
	adrp	x1, .LANCHOR129
	str	x0, [x1, #:lo12:.LANCHOR129]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x20, .LANCHOR62
	adrp	x1, .LANCHOR125
	str	x0, [x1, #:lo12:.LANCHOR125]
	ldrh	w0, [x19, #:lo12:.LANCHOR41]
	lsr	w0, w0, 3
	add	w0, w0, 4
	bl	ftl_malloc
	adrp	x1, .LANCHOR0
	str	x0, [x1, #:lo12:.LANCHOR0]
	ldrh	w0, [x20, #:lo12:.LANCHOR62]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR72
	str	x0, [x1, #:lo12:.LANCHOR72]
	ldrh	w0, [x20, #:lo12:.LANCHOR62]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR192
	str	x0, [x1, #:lo12:.LANCHOR192]
	ldrh	w0, [x20, #:lo12:.LANCHOR62]
	adrp	x20, .LANCHOR63
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR193
	str	x0, [x1, #:lo12:.LANCHOR193]
	ldrh	w0, [x20, #:lo12:.LANCHOR63]
	lsl	w0, w0, 2
	bl	ftl_malloc
	ldrh	w2, [x20, #:lo12:.LANCHOR63]
	adrp	x1, .LANCHOR194
	str	x0, [x1, #:lo12:.LANCHOR194]
	mov	w1, 0
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR67
	ldrh	w20, [x0, #:lo12:.LANCHOR67]
	lsl	w20, w20, 2
	mov	w0, w20
	bl	ftl_malloc
	adrp	x1, .LANCHOR131
	str	x0, [x1, #:lo12:.LANCHOR131]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x20, .LANCHOR68
	adrp	x1, .LANCHOR195
	str	x0, [x1, #:lo12:.LANCHOR195]
	ldr	w0, [x22, #:lo12:.LANCHOR65]
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR130
	str	x0, [x1, #:lo12:.LANCHOR130]
	ldrh	w0, [x20, #:lo12:.LANCHOR68]
	lsl	w0, w0, 4
	bl	ftl_malloc
	adrp	x1, .LANCHOR97
	str	x0, [x1, #:lo12:.LANCHOR97]
	ldrh	w1, [x20, #:lo12:.LANCHOR68]
	adrp	x20, .LANCHOR45
	ldrh	w0, [x21, #:lo12:.LANCHOR58]
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR126
	str	x0, [x1, #:lo12:.LANCHOR126]
	mov	w0, 6
	ldrh	w1, [x19, #:lo12:.LANCHOR41]
	adrp	x19, .LANCHOR123
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR82
	str	x0, [x1, #:lo12:.LANCHOR82]
	adrp	x0, .LANCHOR51
	ldrh	w1, [x20, #:lo12:.LANCHOR45]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	add	w0, w0, 31
	asr	w0, w0, 5
	strh	w0, [x19, #:lo12:.LANCHOR123]
	mul	w0, w1, w0
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR75
	ldrh	w5, [x19, #:lo12:.LANCHOR123]
	add	x2, x1, :lo12:.LANCHOR75
	ldrh	w7, [x20, #:lo12:.LANCHOR45]
	add	x6, x2, 40
	mov	w3, w5
	str	x0, [x2, 32]
	mov	x0, 1
.L1080:
	cmp	w0, w7
	bcc	.L1081
	mov	w2, 8
	sub	w2, w2, w0
	add	x2, x2, 1
	add	x1, x1, :lo12:.LANCHOR75
	mov	x3, 0
.L1082:
	add	x3, x3, 1
	cmp	x2, x3
	bne	.L1083
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1081:
	ldr	x4, [x2, 32]
	add	w0, w0, 1
	add	x4, x4, x3, uxtw 2
	add	w3, w3, w5
	str	x4, [x6], 8
	b	.L1080
.L1083:
	add	x4, x0, x3
	add	x4, x1, x4, lsl 3
	str	xzr, [x4, 24]
	b	.L1082
	.size	FtlMemInit, .-FtlMemInit
	.section	.text.ftl_free,"ax",@progbits
	.align	2
	.global	ftl_free
	.type	ftl_free, %function
ftl_free:
	b	free
	.size	ftl_free, .-ftl_free
	.section	.text.StorageSysDataLoad,"ax",@progbits
	.align	2
	.global	StorageSysDataLoad
	.type	StorageSysDataLoad, %function
StorageSysDataLoad:
	stp	x29, x30, [sp, -32]!
	mov	x2, 512
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x1
	mov	w20, w0
	mov	w1, 0
	mov	x0, x19
	bl	memset
	mov	x3, x19
	add	w1, w20, 256
	ldp	x19, x20, [sp, 16]
	mov	w2, 1
	ldp	x29, x30, [sp], 32
	mov	w0, 16
	b	FtlRead
	.size	StorageSysDataLoad, .-StorageSysDataLoad
	.section	.text.FlashBootVendorRead,"ax",@progbits
	.align	2
	.global	FlashBootVendorRead
	.type	FlashBootVendorRead, %function
FlashBootVendorRead:
	mov	x3, x2
	mov	w1, w0
	mov	w2, 1
	mov	w0, 16
	b	FtlRead
	.size	FlashBootVendorRead, .-FlashBootVendorRead
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
	adrp	x0, .LANCHOR69
	ldr	w0, [x0, #:lo12:.LANCHOR69]
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
	adrp	x21, .LC19
	stp	x23, x24, [sp, 48]
	mov	x22, x1
	stp	x25, x26, [sp, 64]
	adrp	x23, .LC18
	mov	x26, x0
	mov	w24, w2
	uxtw	x25, w3
	add	x23, x23, :lo12:.LC18
	add	x21, x21, :lo12:.LC19
	stp	x19, x20, [sp, 16]
	str	x27, [sp, 80]
	mov	x19, 0
	mov	w20, 0
	adrp	x27, .LC20
.L1093:
	cmp	x25, x19
	bne	.L1099
	ldp	x19, x20, [sp, 16]
	adrp	x1, .LC20
	ldp	x21, x22, [sp, 32]
	add	x1, x1, :lo12:.LC20
	ldp	x23, x24, [sp, 48]
	adrp	x0, .LC7
	ldp	x25, x26, [sp, 64]
	add	x0, x0, :lo12:.LC7
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L1099:
	cbnz	w20, .L1094
	mov	w2, w19
	mov	x1, x26
	mov	x0, x23
	bl	printf
.L1094:
	cmp	w24, 4
	bne	.L1095
	ldr	w1, [x22, x19, lsl 2]
.L1101:
	mov	x0, x21
	add	w20, w20, 1
	bl	printf
	cmp	w20, 15
	bls	.L1098
	mov	w20, 0
	add	x1, x27, :lo12:.LC20
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1098:
	add	x19, x19, 1
	b	.L1093
.L1095:
	cmp	w24, 2
	bne	.L1097
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L1101
.L1097:
	ldrb	w1, [x22, x19]
	b	.L1101
	.size	rknand_print_hex, .-rknand_print_hex
	.section	.text.HynixGetReadRetryDefault,"ax",@progbits
	.align	2
	.global	HynixGetReadRetryDefault
	.type	HynixGetReadRetryDefault, %function
HynixGetReadRetryDefault:
	stp	x29, x30, [sp, -144]!
	mov	w1, -84
	mov	w4, -83
	mov	w3, -82
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR20
	stp	x25, x26, [sp, 64]
	mov	w26, w0
	add	x0, x20, :lo12:.LANCHOR20
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w26, 2
	stp	x27, x28, [sp, 80]
	strb	w1, [x0, 4]
	mov	w1, -81
	strb	w26, [x20, #:lo12:.LANCHOR20]
	strb	w4, [x0, 5]
	strb	w3, [x0, 6]
	strb	w1, [x0, 7]
	bne	.L1103
	mov	w1, -89
	strb	w1, [x0, 4]
	adrp	x0, .LANCHOR196+17
	mov	w1, -9
	strb	w1, [x0, #:lo12:.LANCHOR196+17]
.L1159:
	mov	w27, 7
	b	.L1194
.L1103:
	cmp	w26, 3
	bne	.L1105
	mov	w1, -80
	strb	w1, [x0, 4]
	mov	w1, -79
	strb	w1, [x0, 5]
	mov	w1, -78
	strb	w1, [x0, 6]
	mov	w1, -77
	strb	w1, [x0, 7]
	mov	w1, -76
	strb	w1, [x0, 8]
	mov	w1, -75
	strb	w1, [x0, 9]
	mov	w1, -74
	strb	w1, [x0, 10]
	mov	w1, -73
.L1195:
	mov	w27, 8
	mov	w28, w27
	strb	w1, [x0, 11]
.L1104:
	sub	w0, w26, #1
	cmp	w0, 1
	bhi	.L1109
	adrp	x26, .LANCHOR25
	adrp	x0, .LANCHOR26
	adrp	x25, .LANCHOR6
	add	x26, x26, :lo12:.LANCHOR25
	add	x4, x0, :lo12:.LANCHOR26
	add	x25, x25, :lo12:.LANCHOR6
	mov	w24, 0
.L1110:
	ldrb	w0, [x26]
	cmp	w0, w24
	bhi	.L1116
.L1117:
	add	x20, x20, :lo12:.LANCHOR20
	ldp	x21, x22, [sp, 32]
	strb	w28, [x20, 1]
	strb	w27, [x20, 2]
	ldp	x23, x24, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1105:
	cmp	w26, 4
	bne	.L1106
	mov	w5, -52
	strb	w5, [x0, 4]
	mov	w5, -65
	strb	w5, [x0, 5]
	mov	w5, -86
	strb	w5, [x0, 6]
	mov	w5, -85
	strb	w4, [x0, 9]
	strb	w5, [x0, 7]
	mov	w5, -51
	strb	w3, [x0, 10]
	strb	w5, [x0, 8]
	b	.L1195
.L1106:
	cmp	w26, 5
	bne	.L1107
	mov	w1, 56
	strb	w1, [x0, 4]
	mov	w1, 57
	strb	w1, [x0, 5]
	mov	w1, 58
	mov	w27, 8
	strb	w1, [x0, 6]
	mov	w1, 59
	strb	w1, [x0, 7]
.L1194:
	mov	w28, 4
	b	.L1104
.L1107:
	cmp	w26, 6
	bne	.L1108
	mov	w1, 14
	strb	w1, [x0, 4]
	mov	w1, 15
	strb	w1, [x0, 5]
	mov	w1, 16
	mov	w27, 12
	strb	w1, [x0, 6]
	mov	w1, 17
	strb	w1, [x0, 7]
	b	.L1194
.L1108:
	cmp	w26, 7
	bne	.L1159
	mov	w1, -80
	strb	w1, [x0, 4]
	mov	w1, -79
	strb	w1, [x0, 5]
	mov	w1, -78
	strb	w1, [x0, 6]
	mov	w1, -77
	strb	w1, [x0, 7]
	mov	w1, -76
	strb	w1, [x0, 8]
	mov	w1, -75
	strb	w1, [x0, 9]
	mov	w1, -74
	strb	w1, [x0, 10]
	mov	w1, -73
	strb	w1, [x0, 11]
	mov	w1, -44
	mov	w27, 12
	strb	w1, [x0, 12]
	mov	w28, 10
	mov	w1, -43
	strb	w1, [x0, 13]
	b	.L1104
.L1116:
	ldrb	w1, [x4, w24, sxtw]
	add	x0, x20, :lo12:.LANCHOR20
	mov	x21, x0
	mov	x22, 0
	ubfiz	x19, x1, 6, 8
	sbfiz	x1, x1, 4, 32
	add	x2, x25, x1
	add	x19, x19, 20
	add	x19, x0, x19
	ldr	x1, [x25, x1]
	ldrb	w23, [x2, 8]
	add	x23, x1, x23, lsl 8
	mov	w1, 55
.L1111:
	add	x0, x21, x22
	str	w1, [x23, 2056]
	str	x4, [x29, 128]
	str	w1, [x29, 140]
	ldrb	w0, [x0, 4]
	str	w0, [x23, 2052]
	mov	x0, 80
	bl	udelay
	ldr	w0, [x23, 2048]
	strb	w0, [x19, x22]
	add	x22, x22, 1
	cmp	w28, w22, uxtb
	ldr	w1, [x29, 140]
	ldr	x4, [x29, 128]
	bhi	.L1111
	adrp	x2, .LANCHOR196
	add	x2, x2, :lo12:.LANCHOR196
	mov	x0, 0
.L1114:
	add	x7, x19, x0
	add	x6, x2, x0
	mov	x1, 1
.L1113:
	lsl	x3, x1, 2
	lsl	x8, x1, 3
	ldrb	w10, [x19, x0]
	add	x1, x1, 1
	cmp	x1, 7
	ldrb	w3, [x6, x3]
	add	w3, w3, w10
	strb	w3, [x7, x8]
	bne	.L1113
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L1114
	add	w24, w24, 1
	strb	wzr, [x19, 16]
	strb	wzr, [x19, 24]
	and	w24, w24, 255
	strb	wzr, [x19, 32]
	strb	wzr, [x19, 40]
	strb	wzr, [x19, 48]
	strb	wzr, [x19, 41]
	strb	wzr, [x19, 49]
	b	.L1110
.L1109:
	sub	w0, w26, #3
	cmp	w0, 4
	bhi	.L1117
	mul	w24, w27, w28
	adrp	x25, .LANCHOR25
	sub	w22, w28, #1
	mov	w21, 0
	and	x22, x22, 255
	lsl	w0, w24, 4
	asr	w23, w24, 2
	str	w0, [x29, 128]
	lsl	w0, w23, 1
	sbfiz	x24, x23, 2, 32
	str	w0, [x29, 140]
	add	x0, x25, :lo12:.LANCHOR25
	sub	w25, w26, #5
	str	x0, [x29, 120]
	add	x0, x22, 1
	str	x0, [x29, 112]
.L1118:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, w21
	bls	.L1117
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w22, [x0, w21, sxtw]
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	sbfiz	x1, x22, 4, 32
	add	x3, x0, x1
	ldr	x0, [x0, x1]
	ldrb	w19, [x3, 8]
	add	x19, x0, x19, lsl 8
	mov	w0, 255
	str	w0, [x19, 2056]
	mov	w0, w22
	bl	NandcWaitFlashReady
	add	x1, x20, :lo12:.LANCHOR20
	cmp	w26, 7
	beq	.L1119
	ubfiz	x0, x22, 6, 8
	add	x0, x0, 20
.L1196:
	add	x3, x1, x0
	mov	w0, 54
	str	w0, [x19, 2056]
	cmp	w26, 4
	bne	.L1121
	mov	w0, 255
	str	w0, [x19, 2052]
	mov	w0, 64
	str	w0, [x19, 2048]
	mov	w0, 204
.L1197:
	str	w0, [x19, 2052]
	mov	w0, 77
	b	.L1198
.L1119:
	mov	x3, 28
	mov	w0, 160
	umaddl	x0, w0, w22, x3
	b	.L1196
.L1121:
	cmp	w25, 1
	bhi	.L1123
	add	x0, x20, :lo12:.LANCHOR20
	ldrb	w0, [x0, 4]
	str	w0, [x19, 2052]
	mov	w0, 82
.L1198:
	str	w0, [x19, 2048]
	mov	w0, 22
	str	w0, [x19, 2056]
	mov	w0, 23
	str	w0, [x19, 2056]
	mov	w0, 4
	str	w0, [x19, 2056]
	mov	w0, 25
	str	w0, [x19, 2056]
	cmp	w26, 6
	str	wzr, [x19, 2056]
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	bne	.L1124
	mov	w0, 31
	str	w0, [x19, 2052]
.L1125:
	mov	w7, 2
	str	w7, [x19, 2052]
	str	wzr, [x19, 2052]
	mov	w0, 48
	str	w0, [x19, 2056]
	mov	w0, w22
	str	x3, [x29, 104]
	str	w7, [x29, 136]
	bl	NandcWaitFlashReady
	cmp	w25, 1
	ldr	x3, [x29, 104]
	bls	.L1160
	ldr	w7, [x29, 136]
	cmp	w26, 7
	mov	w1, 32
	csel	w1, w1, w7, eq
.L1126:
	adrp	x8, .LANCHOR147
	mov	x7, 0
	ldr	x0, [x8, #:lo12:.LANCHOR147]
.L1127:
	ldr	w10, [x19, 2048]
	strb	w10, [x0, x7]
	add	x7, x7, 1
	cmp	w1, w7, uxtb
	bhi	.L1127
	cmp	w26, 7
	bne	.L1128
	mov	w1, 0
.L1130:
	ldrb	w7, [x0]
	cmp	w7, 12
	beq	.L1129
	ldrb	w7, [x0, 1]
	cmp	w7, 10
	beq	.L1129
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1130
.L1131:
	adrp	x0, .LC21
	mov	w1, 0
	add	x0, x0, :lo12:.LC21
	bl	printf
.L1133:
	b	.L1133
.L1123:
	mov	w0, 174
	str	w0, [x19, 2052]
	str	wzr, [x19, 2048]
	mov	w0, 176
	b	.L1197
.L1124:
	str	wzr, [x19, 2052]
	b	.L1125
.L1160:
	mov	w1, 16
	b	.L1126
.L1129:
	cmp	w1, 6
	bhi	.L1131
.L1132:
	ldr	x7, [x8, #:lo12:.LANCHOR147]
	mov	x0, 0
.L1137:
	ldr	w1, [x29, 128]
	cmp	w1, w0
	bgt	.L1138
	ldr	x1, [x8, #:lo12:.LANCHOR147]
	mov	w10, 8
	add	x8, x1, x24
.L1140:
	mov	x0, 0
.L1139:
	ldr	w11, [x8, x0, lsl 2]
	mvn	w11, w11
	str	w11, [x8, x0, lsl 2]
	add	x0, x0, 1
	cmp	w23, w0
	bgt	.L1139
	ldr	w0, [x29, 140]
	subs	w10, w10, #1
	add	x8, x8, x0, uxtw 2
	bne	.L1140
	mov	x11, x1
	mov	w12, 0
	mov	w16, 1
.L1146:
	mov	w8, 0
	mov	w0, 0
.L1145:
	mov	x15, x11
	lsl	w10, w16, w0
	mov	w14, 16
	mov	w13, 0
.L1143:
	ldr	w17, [x15]
	add	x15, x15, x24
	bics	wzr, w10, w17
	cinc	w13, w13, eq
	subs	w14, w14, #1
	bne	.L1143
	cmp	w13, 9
	orr	w10, w8, w10
	add	w0, w0, 1
	csel	w8, w10, w8, cs
	cmp	w0, 32
	bne	.L1145
	str	w8, [x11], 4
	add	w12, w12, 1
	cmp	w23, w12
	bgt	.L1146
	mov	x0, 0
	mov	w8, 0
.L1149:
	ldr	w10, [x1, x0]
	add	x0, x0, 4
	cmp	w10, 0
	cinc	w8, w8, eq
	cmp	x0, 32
	bne	.L1149
	cmp	w8, 7
	ble	.L1150
	mov	w3, 1024
	mov	w2, 1
	adrp	x0, .LC22
	add	x0, x0, :lo12:.LC22
	bl	rknand_print_hex
	adrp	x0, .LC21
	mov	w1, 0
	add	x0, x0, :lo12:.LC21
	bl	printf
.L1151:
	b	.L1151
.L1128:
	cmp	w26, 6
	bne	.L1132
	mov	x1, 0
.L1134:
	ldrb	w7, [x0, x1]
	cmp	w7, 12
	beq	.L1132
	add	x7, x0, x1
	ldrb	w7, [x7, 8]
	cmp	w7, 4
	beq	.L1132
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L1134
	adrp	x0, .LC21
	mov	w1, 0
	add	x0, x0, :lo12:.LC21
	bl	printf
.L1136:
	b	.L1136
.L1138:
	ldr	w1, [x19, 2048]
	strb	w1, [x7, x0]
	add	x0, x0, 1
	b	.L1137
.L1150:
	cmp	w26, 6
	beq	.L1162
	cmp	w26, 7
	mov	x1, 8
	mov	x0, 10
	csel	x0, x0, x1, eq
.L1152:
	mov	x1, x3
	mov	w8, 0
.L1153:
	mov	x3, 0
.L1154:
	ldrb	w10, [x7, x3]
	strb	w10, [x1, x3]
	add	x3, x3, 1
	cmp	w28, w3, uxtb
	bhi	.L1154
	ldr	x2, [x29, 112]
	add	w8, w8, 1
	add	x1, x1, x0
	cmp	w27, w8
	add	x7, x7, x2
	bgt	.L1153
	mov	w0, 255
	str	w0, [x19, 2056]
	mov	w0, w22
	bl	NandcWaitFlashReady
	cmp	w25, 1
	bhi	.L1156
	mov	w0, 54
	str	w0, [x19, 2056]
	adrp	x0, .LANCHOR20+4
	mov	w1, -1
	ldrb	w0, [x0, #:lo12:.LANCHOR20+4]
	str	w0, [x19, 2052]
	str	wzr, [x19, 2048]
	mov	w0, 22
	str	w0, [x19, 2056]
	mov	w0, w21
	bl	FlashReadCmd
.L1157:
	add	w21, w21, 1
	mov	w0, w22
	and	w21, w21, 255
	bl	NandcWaitFlashReady
	b	.L1118
.L1162:
	mov	x0, 4
	b	.L1152
.L1156:
	mov	w0, 56
	str	w0, [x19, 2056]
	b	.L1157
	.size	HynixGetReadRetryDefault, .-HynixGetReadRetryDefault
	.section	.text.FlashGetReadRetryDefault,"ax",@progbits
	.align	2
	.global	FlashGetReadRetryDefault
	.type	FlashGetReadRetryDefault, %function
FlashGetReadRetryDefault:
	mov	w1, w0
	cbz	w0, .L1199
	sub	w2, w0, #1
	cmp	w2, 6
	bhi	.L1201
	b	HynixGetReadRetryDefault
.L1201:
	cmp	w0, 49
	bne	.L1202
	adrp	x2, .LANCHOR20
	add	x0, x2, :lo12:.LANCHOR20
	strb	w1, [x2, #:lo12:.LANCHOR20]
	mov	w1, 4
	strb	w1, [x0, 1]
	mov	w1, 15
	strb	w1, [x0, 2]
	adrp	x1, .LANCHOR14
	add	x1, x1, :lo12:.LANCHOR14
	mov	w2, 64
.L1211:
	add	x0, x0, 4
	b	ftl_memcpy
.L1202:
	sub	w0, w0, #65
	cmp	w1, 33
	ccmp	w0, 1, 0, ne
	bhi	.L1203
	adrp	x2, .LANCHOR20
	add	x0, x2, :lo12:.LANCHOR20
	strb	w1, [x2, #:lo12:.LANCHOR20]
	mov	w1, 4
.L1212:
	strb	w1, [x0, 1]
	mov	w1, 7
	mov	w2, 45
	strb	w1, [x0, 2]
	adrp	x1, .LANCHOR10
	add	x1, x1, :lo12:.LANCHOR10
	b	.L1211
.L1203:
	cmp	w1, 34
	mov	w0, 67
	ccmp	w1, w0, 4, ne
	bne	.L1204
	adrp	x2, .LANCHOR20
	add	x0, x2, :lo12:.LANCHOR20
	strb	w1, [x2, #:lo12:.LANCHOR20]
	mov	w1, 5
	b	.L1212
.L1204:
	cmp	w1, 35
	mov	w0, 68
	ccmp	w1, w0, 4, ne
	bne	.L1199
	adrp	x2, .LANCHOR20
	add	x0, x2, :lo12:.LANCHOR20
	strb	w1, [x2, #:lo12:.LANCHOR20]
	mov	w1, 5
	strb	w1, [x0, 1]
	mov	w1, 17
	mov	w2, 95
	strb	w1, [x0, 2]
	adrp	x1, .LANCHOR9
	add	x1, x1, :lo12:.LANCHOR9
	b	.L1211
.L1199:
	ret
	.size	FlashGetReadRetryDefault, .-FlashGetReadRetryDefault
	.section	.text.FlashInit,"ax",@progbits
	.align	2
	.global	FlashInit
	.type	FlashInit, %function
FlashInit:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	mov	w0, 32768
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR2
	stp	x25, x26, [sp, 64]
	adrp	x24, .LANCHOR152
	stp	x27, x28, [sp, 80]
	bl	ftl_malloc
	adrp	x1, .LANCHOR147
	adrp	x21, .LANCHOR30
	adrp	x22, .LANCHOR1
	adrp	x20, .LANCHOR22
	str	x0, [x1, #:lo12:.LANCHOR147]
	mov	w0, 32768
	bl	ftl_malloc
	adrp	x25, .LANCHOR6
	adrp	x1, .LANCHOR153
	add	x25, x25, :lo12:.LANCHOR6
	adrp	x26, .LC23
	mov	w28, 0
	str	x0, [x1, #:lo12:.LANCHOR153]
	mov	w0, 4096
	bl	ftl_malloc
	adrp	x1, .LANCHOR197
	str	x0, [x1, #:lo12:.LANCHOR197]
	mov	w0, 32768
	bl	ftl_malloc
	adrp	x1, .LANCHOR198
	str	x0, [x1, #:lo12:.LANCHOR198]
	mov	w0, 4096
	bl	ftl_malloc
	strb	wzr, [x21, #:lo12:.LANCHOR30]
	adrp	x1, .LANCHOR199
	strb	wzr, [x22, #:lo12:.LANCHOR1]
	str	x0, [x1, #:lo12:.LANCHOR199]
	adrp	x1, .LANCHOR150
	mov	w0, 50
	strb	w0, [x23, #:lo12:.LANCHOR2]
	strb	w0, [x1, #:lo12:.LANCHOR150]
	adrp	x0, .LANCHOR149
	mov	w1, 128
	str	wzr, [x0, #:lo12:.LANCHOR149]
	adrp	x0, .LANCHOR3
	str	w1, [x0, #:lo12:.LANCHOR3]
	adrp	x0, .LANCHOR144
	str	wzr, [x0, #:lo12:.LANCHOR144]
	mov	w0, 60
	strb	w0, [x24, #:lo12:.LANCHOR152]
	mov	x0, x19
	add	x19, x20, :lo12:.LANCHOR22
	bl	NandcInit
	mov	x27, x19
	add	x0, x26, :lo12:.LC23
	str	x0, [x29, 104]
.L1218:
	and	w26, w28, 255
	mov	w0, w26
	bl	FlashReset
	ldrb	w5, [x25, 8]
	mov	w0, w26
	ldr	x4, [x25]
	bl	NandcFlashCs
	ubfiz	x1, x5, 8, 8
	add	x1, x4, x1
	mov	w0, 144
	str	x1, [x29, 96]
	str	w0, [x1, 2056]
	mov	x0, 200
	str	wzr, [x1, 2052]
	bl	udelay
	ldr	x1, [x29, 96]
	ldr	w0, [x1, 2048]
	strb	w0, [x19]
	ldr	w0, [x1, 2048]
	strb	w0, [x19, 1]
	ldr	w0, [x1, 2048]
	strb	w0, [x19, 2]
	ldr	w0, [x1, 2048]
	strb	w0, [x19, 3]
	ldr	w0, [x1, 2048]
	strb	w0, [x19, 4]
	ldr	w0, [x1, 2048]
	strb	w0, [x19, 5]
	mov	w0, w26
	bl	NandcFlashDeCs
	ldrb	w2, [x19]
	sub	w0, w2, #1
	and	w0, w0, 255
	cmp	w0, 253
	bhi	.L1214
	ldrb	w7, [x19, 5]
	add	w1, w28, 1
	ldrb	w6, [x19, 4]
	ldrb	w5, [x19, 3]
	ldrb	w4, [x19, 2]
	ldrb	w3, [x19, 1]
	ldr	x0, [x29, 104]
	bl	printf
.L1214:
	cbnz	w28, .L1215
	ldrb	w0, [x27]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 253
	bhi	.L1256
	ldrb	w0, [x27, 1]
	cmp	w0, 255
	beq	.L1256
.L1215:
	ldrb	w0, [x19]
	cmp	w0, 181
	bne	.L1217
	mov	w0, 44
	strb	w0, [x19]
.L1217:
	add	w28, w28, 1
	add	x25, x25, 16
	add	x19, x19, 8
	cmp	w28, 4
	bne	.L1218
	ldrb	w0, [x20, #:lo12:.LANCHOR22]
	cmp	w0, 173
	beq	.L1219
	adrp	x0, .LANCHOR155
	ldr	w0, [x0, #:lo12:.LANCHOR155]
	bl	NandcSetDdrMode
.L1219:
	mov	w2, 852
	adrp	x26, .LANCHOR20
	mov	w1, 0
	add	x0, x26, :lo12:.LANCHOR20
	adrp	x19, .LANCHOR18
	bl	ftl_memset
	adrp	x28, .LANCHOR31
	add	x0, x28, :lo12:.LANCHOR31
	str	x0, [x19, #:lo12:.LANCHOR18]
	add	x0, x20, :lo12:.LANCHOR22
	adrp	x27, .LANCHOR5
	ldrb	w2, [x0, 1]
	strb	wzr, [x27, #:lo12:.LANCHOR5]
	cmp	w2, 161
	beq	.L1220
	cmp	w2, 218
	beq	.L1220
	and	w1, w2, -33
	cmp	w1, 209
	beq	.L1220
	cmp	w2, 220
	bne	.L1221
	ldrb	w0, [x0, 3]
	cmp	w0, 149
	bne	.L1221
.L1220:
	mov	w0, 1
	adrp	x25, .LANCHOR200
	add	x1, x25, :lo12:.LANCHOR200
	strb	w0, [x22, #:lo12:.LANCHOR1]
	mov	w0, 16
	strb	w0, [x23, #:lo12:.LANCHOR2]
	strb	w0, [x24, #:lo12:.LANCHOR152]
	add	x3, x20, :lo12:.LANCHOR22
	ldrb	w0, [x20, #:lo12:.LANCHOR22]
	strb	w0, [x1, 1]
	strb	w2, [x1, 2]
	cmp	w0, 152
	bne	.L1222
	ldrsb	w0, [x3, 4]
	tbnz	w0, #31, .L1222
	mov	w0, 24
	strb	w0, [x24, #:lo12:.LANCHOR152]
.L1222:
	adrp	x0, .LANCHOR29
	mov	w1, 12336
	movk	w1, 0x5638, lsl 16
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	cmp	w0, 2049
	ccmp	w0, w1, 4, ne
	bne	.L1223
	mov	w0, 16
	strb	w0, [x24, #:lo12:.LANCHOR152]
.L1223:
	cmp	w2, 218
	bne	.L1224
	add	x0, x25, :lo12:.LANCHOR200
	mov	w1, 2048
	strh	w1, [x0, 14]
	mov	w1, -38
.L1294:
	strb	w1, [x0, 2]
.L1225:
	adrp	x1, .LANCHOR143
	add	x1, x1, :lo12:.LANCHOR143
	mov	w2, 32
	add	x1, x1, 32
	adrp	x0, .LANCHOR7
	add	x0, x0, :lo12:.LANCHOR7
	bl	ftl_memcpy
	mov	w2, 32
	add	x1, x25, :lo12:.LANCHOR200
	add	x0, x28, :lo12:.LANCHOR31
	bl	ftl_memcpy
.L1221:
	ldrb	w0, [x22, #:lo12:.LANCHOR1]
	adrp	x25, .LANCHOR8
	cbnz	w0, .L1227
	bl	FlashLoadPhyInfoInRam
	cbnz	w0, .L1229
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	adrp	x24, .LANCHOR24
	ldrb	w1, [x0, 17]
	and	w0, w1, 7
	strb	w0, [x24, #:lo12:.LANCHOR24]
	tbnz	x1, 0, .L1229
	mov	w1, 1
	strb	w1, [x21, #:lo12:.LANCHOR30]
	bl	FlashSetInterfaceMode
	ldrb	w0, [x24, #:lo12:.LANCHOR24]
	bl	NandcSetMode
.L1229:
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 26]
	strb	w0, [x25, #:lo12:.LANCHOR8]
	bl	FlashLoadPhyInfo
	cbz	w0, .L1227
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	ldrh	w1, [x0, 14]
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	bl	printf
	bl	FlashLoadPhyInfoInRam
	cmn	w0, #1
	beq	.L1213
	bl	FlashDieInfoInit
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 19]
	bl	FlashGetReadRetryDefault
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	adrp	x1, .LANCHOR122
	ldrh	w1, [x1, #:lo12:.LANCHOR122]
	ldrb	w2, [x0, 9]
	add	w1, w1, 4095
	cmp	w2, w1, lsr 12
	blt	.L1232
	ldrh	w1, [x0, 14]
	add	w1, w1, 255
	cmp	w2, w1, lsr 8
	bge	.L1233
.L1232:
	ldrh	w1, [x0, 14]
	and	w1, w1, -256
	strh	w1, [x0, 14]
.L1233:
	adrp	x0, .LANCHOR24
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	tst	w0, 6
	beq	.L1234
	bl	FlashSavePhyInfo
	adrp	x0, .LANCHOR148
	ldr	w1, [x0, #:lo12:.LANCHOR148]
	mov	w0, 0
	bl	FlashDdrParaScan
.L1234:
	bl	FlashSavePhyInfo
.L1227:
	ldr	x2, [x19, #:lo12:.LANCHOR18]
	adrp	x24, .LANCHOR24
	ldrb	w0, [x2, 26]
	strb	w0, [x25, #:lo12:.LANCHOR8]
	ldrh	w0, [x2, 16]
	ubfx	x1, x0, 7, 1
	strb	w1, [x27, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR201
	ubfx	x3, x0, 3, 1
	adrp	x27, .LANCHOR145
	strb	w3, [x1, #:lo12:.LANCHOR201]
	adrp	x1, .LANCHOR27
	ubfx	x3, x0, 4, 1
	ubfx	x0, x0, 8, 3
	strb	w3, [x1, #:lo12:.LANCHOR27]
	strb	w0, [x24, #:lo12:.LANCHOR24]
	ldrh	w1, [x2, 10]
	ldrb	w0, [x2, 12]
	str	xzr, [x27, #:lo12:.LANCHOR145]
	sdiv	w1, w1, w0
	ldrb	w0, [x2, 18]
	bl	BuildFlashLsbPageTable
	bl	FlashDieInfoInit
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	ldrh	w1, [x0, 16]
	tbz	x1, 6, .L1236
	adrp	x1, .LANCHOR11
	ldrb	w0, [x0, 19]
	adrp	x3, .LANCHOR13
	strb	w0, [x1, #:lo12:.LANCHOR11]
	add	x1, x26, :lo12:.LANCHOR20
	ldrb	w2, [x1, 1]
	strb	w2, [x3, #:lo12:.LANCHOR13]
	adrp	x2, .LANCHOR151
	ldrb	w4, [x1, 2]
	strb	w4, [x2, #:lo12:.LANCHOR151]
	sub	w4, w0, #1
	and	w4, w4, 255
	cmp	w4, 6
	mov	x4, x3
	bhi	.L1237
	adrp	x2, HynixReadRetrial
	add	x2, x2, :lo12:HynixReadRetrial
	str	x2, [x27, #:lo12:.LANCHOR145]
	sub	w2, w0, #5
	and	w2, w2, 255
	cmp	w2, 1
	bhi	.L1238
	adrp	x2, .LANCHOR36
	add	x1, x1, 20
	mov	w3, 1
	str	w3, [x2, #:lo12:.LANCHOR36]
.L1239:
	mov	x2, 0
	mov	w3, 0
.L1241:
	ldrsb	w4, [x1, x2]
	add	x2, x2, 1
	cmp	w4, 0
	cinc	w3, w3, eq
	cmp	x2, 32
	bne	.L1241
	cmp	w3, 27
	bls	.L1236
	bl	FlashGetReadRetryDefault
	bl	FlashSavePhyInfo
.L1236:
	adrp	x0, .LANCHOR29
	ldr	w1, [x0, #:lo12:.LANCHOR29]
	mov	w0, 12336
	movk	w0, 0x5638, lsl 16
	cmp	w1, w0
	bne	.L1250
	ldrb	w0, [x25, #:lo12:.LANCHOR8]
	cbz	w0, .L1250
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	strb	wzr, [x0, 18]
.L1250:
	ldrb	w0, [x20, #:lo12:.LANCHOR22]
	cmp	w0, 44
	bne	.L1251
	ldrb	w0, [x21, #:lo12:.LANCHOR30]
	cbz	w0, .L1251
	strb	wzr, [x21, #:lo12:.LANCHOR30]
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
.L1251:
	mov	w0, 0
	bl	flash_enter_slc_mode
	ldrb	w0, [x24, #:lo12:.LANCHOR24]
	tst	w0, 6
	beq	.L1252
	ldrb	w1, [x21, #:lo12:.LANCHOR30]
	cbnz	w1, .L1253
	tbnz	x0, 0, .L1252
.L1253:
	adrp	x0, .LANCHOR148
	ldr	w1, [x0, #:lo12:.LANCHOR148]
	mov	w0, 0
	bl	FlashDdrParaScan
.L1252:
	mov	w0, 0
	bl	flash_exit_slc_mode
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 20]
	bl	FlashBchSel
	adrp	x0, .LANCHOR141
	add	x0, x0, :lo12:.LANCHOR141
	bl	FlashReadIdbDataRaw
	ldr	x2, [x19, #:lo12:.LANCHOR18]
	mov	w0, 16
	adrp	x1, .LANCHOR15
	strb	w0, [x23, #:lo12:.LANCHOR2]
	add	x0, x1, :lo12:.LANCHOR15
	ldrb	w3, [x2, 12]
	strh	w3, [x0, 8]
	ldrb	w4, [x2, 7]
	str	w4, [x0, 4]
	ldr	w4, [x20, #:lo12:.LANCHOR22]
	str	w4, [x1, #:lo12:.LANCHOR15]
	adrp	x1, .LANCHOR25
	ldrh	w4, [x2, 14]
	ldrb	w1, [x1, #:lo12:.LANCHOR25]
	strh	w1, [x0, 10]
	ldrb	w1, [x2, 13]
	strh	w1, [x0, 12]
	ldrh	w1, [x2, 10]
	strh	w1, [x0, 16]
	strh	w4, [x0, 14]
	sdiv	w3, w1, w3
	strh	w3, [x0, 18]
	ldrb	w5, [x2, 9]
	strh	w5, [x0, 20]
	mov	w3, w5
	mul	w1, w1, w5
	mov	w5, 512
	strh	w5, [x0, 24]
	mov	w5, 16
	and	w1, w1, 65535
	strh	w5, [x0, 26]
	strh	w1, [x0, 22]
	ldrb	w5, [x22, #:lo12:.LANCHOR1]
	cmp	w5, 1
	bne	.L1254
	ubfiz	w1, w1, 1, 15
	lsr	w4, w4, 1
	ubfiz	w3, w3, 1, 15
	strh	w1, [x0, 22]
	strh	w4, [x0, 14]
	mov	w1, 8
	strh	w3, [x0, 20]
	strh	w1, [x0, 26]
.L1254:
	ldrb	w0, [x2, 20]
	bl	FlashBchSel
	mov	w0, 0
.L1213:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1224:
	cmp	w2, 220
	bne	.L1225
	add	x0, x25, :lo12:.LANCHOR200
	mov	w1, 4096
	strh	w1, [x0, 14]
	mov	w1, -36
	b	.L1294
.L1238:
	add	x2, x1, 20
	cmp	w0, 7
	add	x1, x1, 28
	csel	x1, x1, x2, eq
	b	.L1239
.L1237:
	sub	w1, w0, #17
	and	w1, w1, 255
	cmp	w1, 2
	bhi	.L1243
	adrp	x1, MicronReadRetrial
	add	x1, x1, :lo12:MicronReadRetrial
	str	x1, [x27, #:lo12:.LANCHOR145]
	cmp	w0, 19
	beq	.L1244
.L1298:
	mov	w0, 7
	b	.L1296
.L1244:
	mov	w0, 15
.L1296:
	strb	w0, [x2, #:lo12:.LANCHOR151]
	b	.L1236
.L1243:
	sub	w1, w0, #65
	cmp	w0, 33
	and	w1, w1, 255
	ccmp	w1, 1, 0, ne
	bhi	.L1245
	adrp	x0, ToshibaReadRetrial
	add	x0, x0, :lo12:ToshibaReadRetrial
	str	x0, [x27, #:lo12:.LANCHOR145]
	mov	w0, 4
	strb	w0, [x3, #:lo12:.LANCHOR13]
	b	.L1298
.L1245:
	sub	w3, w0, #34
	sub	w1, w0, #67
	and	w3, w3, 255
	and	w1, w1, 255
	cmp	w3, 1
	ccmp	w1, 1, 0, hi
	bhi	.L1246
	adrp	x3, ToshibaReadRetrial
	add	x3, x3, :lo12:ToshibaReadRetrial
	str	x3, [x27, #:lo12:.LANCHOR145]
	cmp	w0, 35
	mov	w3, 68
	ccmp	w0, w3, 4, ne
	beq	.L1247
	mov	w0, 7
.L1295:
	strb	w0, [x2, #:lo12:.LANCHOR151]
	cmp	w1, 1
	bhi	.L1249
	mov	w0, 4
.L1297:
	strb	w0, [x4, #:lo12:.LANCHOR13]
	b	.L1236
.L1247:
	mov	w0, 17
	b	.L1295
.L1249:
	mov	w0, 5
	b	.L1297
.L1246:
	cmp	w0, 49
	bne	.L1236
	adrp	x0, SamsungReadRetrial
	add	x0, x0, :lo12:SamsungReadRetrial
	str	x0, [x27, #:lo12:.LANCHOR145]
	b	.L1236
.L1256:
	mov	w0, -2
	b	.L1213
	.size	FlashInit, .-FlashInit
	.section	.text.FlashReadSlc2KPages,"ax",@progbits
	.align	2
	.global	FlashReadSlc2KPages
	.type	FlashReadSlc2KPages, %function
FlashReadSlc2KPages:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	w22, 56
	stp	x25, x26, [sp, 64]
	mov	w25, w2
	adrp	x2, .LANCHOR31+9
	stp	x23, x24, [sp, 48]
	nop // between mem op and mult-accumulate
	umaddl	x22, w1, w22, x0
	stp	x19, x20, [sp, 16]
	ldrb	w24, [x2, #:lo12:.LANCHOR31+9]
	adrp	x23, .LANCHOR25
	mov	x19, x0
	and	w21, w1, 255
	add	x23, x23, :lo12:.LANCHOR25
	adrp	x26, .LANCHOR26
	str	x27, [sp, 80]
.L1300:
	cmp	x22, x19
	bne	.L1312
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1312:
	mov	w1, w25
	mov	w4, w21
	add	x3, x29, 104
	add	x2, x29, 108
	mov	x0, x19
	bl	LogAddr2PhyAddr
	ldrb	w1, [x23]
	ldr	w0, [x29, 104]
	cmp	w1, w0
	bhi	.L1301
	mov	w0, -1
	str	w0, [x19]
.L1302:
	sub	w21, w21, #1
	add	x19, x19, 56
	and	w21, w21, 255
	b	.L1300
.L1301:
	add	x1, x26, :lo12:.LANCHOR26
	ldrb	w27, [x1, w0, uxtw]
	mov	w0, w27
	bl	NandcWaitFlashReady
	mov	w0, w27
	bl	NandcFlashCs
	ldr	w1, [x29, 108]
	mov	w0, w27
	bl	FlashReadCmd
	mov	w0, w27
	bl	NandcWaitFlashReady
	ldp	x3, x4, [x19, 8]
	mov	w2, w24
	mov	w1, 0
	mov	w0, w27
	bl	NandcXferData
	mov	w20, w0
	adrp	x0, .LANCHOR3
	ldr	w1, [x29, 108]
	ldr	w0, [x0, #:lo12:.LANCHOR3]
	add	w1, w1, w0
	mov	w0, w27
	bl	FlashReadCmd
	ldr	x0, [x19, 8]
	mov	w2, w24
	mov	w1, 0
	cmp	x0, 0
	add	x3, x0, 2048
	ldr	x0, [x19, 16]
	csel	x3, x3, xzr, ne
	cmp	x0, 0
	add	x4, x0, 8
	csel	x4, x4, xzr, ne
	mov	w0, w27
	bl	NandcXferData
	mov	w2, w0
	mov	w0, w27
	bl	NandcFlashDeCs
	cmp	w20, w2
	adrp	x1, .LANCHOR33
	csel	w0, w20, w2, cs
	ldrb	w2, [x1, #:lo12:.LANCHOR33]
	add	w1, w2, w2, lsl 1
	cmp	w0, w1, lsr 2
	bls	.L1305
	cmn	w0, #1
	mov	w1, 256
	csel	w0, w0, w1, eq
.L1305:
	cmp	w0, 256
	ccmn	w0, #1, 4, ne
	csel	w0, w0, wzr, eq
	str	w0, [x19]
	ldr	x0, [x19, 16]
	cbz	x0, .L1308
	ldr	w1, [x0, 12]
	cmn	w1, #1
	bne	.L1308
	ldr	w1, [x0, 8]
	cmn	w1, #1
	bne	.L1308
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L1308
	str	w1, [x19]
.L1308:
	ldr	w3, [x19]
	cmn	w3, #1
	bne	.L1302
	ldr	w1, [x19, 4]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	bl	printf
	ldr	x1, [x19, 8]
	cbz	x1, .L1310
	adrp	x0, .LC26
	mov	w3, 8
	mov	w2, 4
	add	x0, x0, :lo12:.LC26
	bl	rknand_print_hex
.L1310:
	ldr	x1, [x19, 16]
	cbz	x1, .L1302
	mov	w3, 4
	adrp	x0, .LC27
	mov	w2, w3
	add	x0, x0, :lo12:.LC27
	bl	rknand_print_hex
	b	.L1302
	.size	FlashReadSlc2KPages, .-FlashReadSlc2KPages
	.section	.text.FlashReadPages,"ax",@progbits
	.align	2
	.global	FlashReadPages
	.type	FlashReadPages, %function
FlashReadPages:
	stp	x29, x30, [sp, -176]!
	adrp	x3, .LANCHOR1
	add	x29, sp, 0
	ldrb	w3, [x3, #:lo12:.LANCHOR1]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	stp	w2, w1, [x29, 148]
	cbnz	w3, .L1331
	mov	x25, x0
	adrp	x0, .LANCHOR31+9
	adrp	x27, .LANCHOR20
	mov	w23, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR31+9]
	mov	w22, 0
	str	w0, [x29, 156]
	adrp	x0, .LANCHOR5
	str	x0, [x29, 128]
	ldrb	w1, [x0, #:lo12:.LANCHOR5]
	add	x0, x27, :lo12:.LANCHOR20
	str	w1, [x29, 144]
	str	x0, [x29, 104]
	add	x0, x0, 4
	str	x0, [x29, 96]
.L1332:
	ldr	w0, [x29, 152]
	cmp	w22, w0
	bcc	.L1366
	mov	w0, 0
	b	.L1330
.L1331:
	bl	FlashReadSlc2KPages
.L1330:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1366:
	mov	w26, 56
	add	x3, x29, 168
	ldp	w1, w0, [x29, 148]
	umull	x26, w22, w26
	add	x2, x29, 172
	add	x21, x25, x26
	sub	w4, w0, w22
	mov	x0, x21
	ldr	w24, [x21, 4]
	bl	LogAddr2PhyAddr
	mov	w20, w0
	adrp	x0, .LANCHOR25
	ldr	w1, [x29, 168]
	ldrb	w0, [x0, #:lo12:.LANCHOR25]
	cmp	w0, w1
	bhi	.L1334
	mov	w0, -1
	str	w0, [x25, x26]
.L1335:
	add	w22, w22, 1
	b	.L1332
.L1334:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w19, [x0, w1, uxtw]
	adrp	x0, .LANCHOR201
	ldrb	w0, [x0, #:lo12:.LANCHOR201]
	cmp	w0, 0
	mov	w0, w19
	csel	w20, w20, wzr, ne
	bl	NandcWaitFlashReady
	adrp	x1, .LANCHOR18
	str	x1, [x29, 120]
	ldr	x0, [x1, #:lo12:.LANCHOR18]
	ldrb	w2, [x0, 19]
	sub	w0, w2, #1
	and	w0, w0, 255
	cmp	w0, 6
	bhi	.L1337
	add	x0, x27, :lo12:.LANCHOR20
	sxtw	x1, w19
	add	x0, x0, x1
	cmp	w2, 7
	ldrb	w3, [x0, 12]
	bne	.L1338
	ldrb	w3, [x0, 20]
.L1338:
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	ldrb	w0, [x0, x1]
	cmp	w0, w3
	beq	.L1337
	ldp	x2, x0, [x29, 96]
	ldrb	w1, [x0, 1]
	mov	w0, w19
	bl	HynixSetRRPara
.L1337:
	mov	w0, w19
	bl	NandcFlashCs
	ldr	w0, [x29, 148]
	cmp	w0, 1
	cset	w0, eq
	orr	w24, w0, w24, lsr 31
	cbz	w24, .L1339
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L1339
	mov	w0, w19
	bl	flash_enter_slc_mode
.L1340:
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	str	x0, [x29, 112]
	ldr	x0, [x29, 128]
	add	x0, x0, :lo12:.LANCHOR5
	str	x0, [x29, 136]
.L1346:
	ldr	w1, [x29, 172]
	cmn	w1, #1
	bne	.L1341
	cmp	w19, 255
	beq	.L1368
.L1341:
	cbz	w20, .L1343
	ldr	x0, [x29, 112]
	ldr	w2, [x0]
	mov	w0, w19
	add	w2, w1, w2
	bl	FlashReadDpCmd
.L1344:
	mov	w0, w19
	bl	NandcWaitFlashReady
	cbz	w20, .L1342
	ldr	w1, [x29, 172]
	mov	w0, w19
	bl	FlashReadDpDataOutCmd
.L1342:
	ldrb	w2, [x29, 156]
	mov	w1, 0
	ldp	x3, x4, [x21, 8]
	mov	w0, w19
	bl	NandcXferData
	mov	w28, w0
	ldr	x0, [x29, 136]
	ldrb	w0, [x0]
	cbz	w0, .L1345
	cmn	w28, #1
	bne	.L1345
	ldr	x0, [x29, 136]
	mov	w20, 0
	strb	wzr, [x0]
	b	.L1346
.L1339:
	mov	w0, w19
	bl	flash_exit_slc_mode
	b	.L1340
.L1343:
	mov	w0, w19
	bl	FlashReadCmd
	b	.L1344
.L1368:
	mov	w20, 0
	b	.L1342
.L1345:
	cbz	w20, .L1347
	adrp	x0, .LANCHOR3
	ldr	w1, [x29, 172]
	ldr	w0, [x0, #:lo12:.LANCHOR3]
	add	w1, w1, w0
	mov	w0, w19
	bl	FlashReadDpDataOutCmd
	add	w0, w22, 1
	mov	w1, 56
	ldrb	w2, [x29, 156]
	nop // between mem op and mult-accumulate
	umaddl	x0, w0, w1, x25
	mov	w1, 0
	ldp	x3, x4, [x0, 8]
	mov	w0, w19
	bl	NandcXferData
	cmn	w0, #1
	mov	w23, w0
	csel	w20, w20, wzr, ne
.L1347:
	mov	w0, w19
	bl	NandcFlashDeCs
	ldr	x0, [x29, 128]
	cmn	w28, #1
	ldrb	w1, [x29, 144]
	strb	w1, [x0, #:lo12:.LANCHOR5]
	bne	.L1348
	adrp	x0, .LANCHOR30
	ldrb	w0, [x0, #:lo12:.LANCHOR30]
	cbnz	w0, .L1349
.L1353:
	adrp	x20, .LANCHOR145
	ldr	x4, [x20, #:lo12:.LANCHOR145]
	cbnz	x4, .L1350
	ldr	w1, [x29, 172]
	mov	w0, w19
	ldp	x2, x3, [x21, 8]
	bl	FlashReadRawPage
	b	.L1405
.L1349:
	adrp	x0, .LANCHOR19
	ldr	w1, [x29, 172]
	ldp	x2, x3, [x21, 8]
	mov	w4, 1
	ldr	x0, [x0, #:lo12:.LANCHOR19]
	ldr	w20, [x0, 304]
	mov	w0, w19
	bl	FlashDdrTunningRead
	mov	w28, w0
	cmn	w0, #1
	beq	.L1352
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	cmp	w28, w0, lsr 1
	bls	.L1369
.L1352:
	lsr	w0, w20, 8
	bl	NandcSetDdrPara
	cmn	w28, #1
	beq	.L1353
.L1369:
	mov	w20, 0
.L1348:
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bls	.L1354
	adrp	x0, .LANCHOR145
	ldr	x0, [x0, #:lo12:.LANCHOR145]
	cmp	x0, 0
	mov	w0, 256
	csel	w28, w28, w0, ne
.L1354:
	cmp	w28, 256
	ccmn	w28, #1, 4, ne
	csel	w3, w28, wzr, eq
	str	w3, [x25, x26]
	cmn	w3, #1
	bne	.L1361
	adrp	x0, .LANCHOR33
	ldr	w1, [x21, 4]
	ldrb	w2, [x0, #:lo12:.LANCHOR33]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	bl	printf
	ldr	x1, [x21, 16]
	cbz	x1, .L1361
	mov	w3, 4
	adrp	x0, .LC27
	mov	w2, w3
	add	x0, x0, :lo12:.LC27
	bl	rknand_print_hex
.L1361:
	cbz	w20, .L1363
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w23, w0, lsr 2
	bls	.L1364
	adrp	x0, .LANCHOR145
	ldr	x0, [x0, #:lo12:.LANCHOR145]
	cmp	x0, 0
	mov	w0, 256
	csel	w23, w23, w0, ne
.L1364:
	add	w0, w22, 1
	mov	w1, 56
	cmp	w23, 256
	ccmn	w23, #1, 4, ne
	umull	x0, w0, w1
	csel	w1, w23, wzr, eq
	str	w1, [x25, x0]
.L1363:
	add	w22, w22, w20
	cbz	w24, .L1335
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L1335
	mov	w0, w19
	bl	flash_exit_slc_mode
	b	.L1335
.L1350:
	ldr	w1, [x29, 172]
	mov	w0, w19
	ldp	x2, x3, [x21, 8]
	blr	x4
	mov	w28, w0
	cmn	w0, #1
	bne	.L1372
	ldr	x0, [x29, 120]
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 19]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 6
	bhi	.L1355
	add	x0, x27, :lo12:.LANCHOR20
	mov	w3, 0
	add	x2, x0, 4
	ldrb	w1, [x0, 1]
	mov	w0, w19
	bl	HynixSetRRPara
.L1355:
	ldp	x2, x3, [x21, 8]
	mov	w0, w19
	ldr	w1, [x29, 172]
	bl	FlashReadRawPage
	mov	w28, w0
	mov	w3, w0
	adrp	x0, .LANCHOR33
	ldr	w1, [x21, 4]
	ldrb	w2, [x0, #:lo12:.LANCHOR33]
	adrp	x0, .LC28
	add	x0, x0, :lo12:.LC28
	bl	printf
	cmn	w28, #1
	bne	.L1372
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L1372
	mov	w0, w19
	cbz	w24, .L1356
	bl	flash_enter_slc_mode
.L1357:
	ldr	x4, [x20, #:lo12:.LANCHOR145]
	mov	w0, w19
	ldr	w1, [x29, 172]
	ldp	x2, x3, [x21, 8]
	blr	x4
.L1405:
	mov	w28, w0
.L1372:
	mov	w20, 0
	b	.L1354
.L1356:
	bl	flash_exit_slc_mode
	b	.L1357
	.size	FlashReadPages, .-FlashReadPages
	.section	.text.FlashProgSlc2KPages,"ax",@progbits
	.align	2
	.global	FlashProgSlc2KPages
	.type	FlashProgSlc2KPages, %function
FlashProgSlc2KPages:
	stp	x29, x30, [sp, -176]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	w24, w2
	mov	w23, 56
	adrp	x2, .LANCHOR31+9
	stp	x21, x22, [sp, 32]
	and	w21, w1, 255
	stp	x25, x26, [sp, 64]
	nop // between mem op and mult-accumulate
	umaddl	x23, w1, w23, x0
	ldrb	w25, [x2, #:lo12:.LANCHOR31+9]
	adrp	x26, .LANCHOR3
	stp	x27, x28, [sp, 80]
	mov	w22, w21
	stp	x19, x20, [sp, 16]
	mov	x27, x0
	mov	x20, x0
	add	x28, x26, :lo12:.LANCHOR3
	str	w3, [x29, 108]
.L1407:
	cmp	x20, x23
	bne	.L1413
	ldr	w0, [x29, 108]
	cbnz	w0, .L1414
.L1433:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1413:
	mov	w1, w24
	mov	w4, w22
	add	x3, x29, 116
	add	x2, x29, 112
	mov	x0, x20
	bl	LogAddr2PhyAddr
	adrp	x0, .LANCHOR25
	ldr	w1, [x29, 116]
	ldrb	w0, [x0, #:lo12:.LANCHOR25]
	cmp	w0, w1
	bhi	.L1408
	mov	w0, -1
	str	w0, [x20]
.L1409:
	sub	w22, w22, #1
	add	x20, x20, 56
	and	w22, w22, 255
	b	.L1407
.L1408:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w19, [x0, w1, uxtw]
	mov	w0, w19
	bl	NandcWaitFlashReady
	mov	w0, w19
	bl	NandcFlashCs
	ldr	w1, [x29, 112]
	mov	w0, w19
	bl	FlashProgFirstCmd
	ldp	x3, x4, [x20, 8]
	mov	w2, w25
	mov	w1, 1
	mov	w0, w19
	bl	NandcXferData
	ldr	w1, [x29, 112]
	mov	w0, w19
	bl	FlashProgSecondCmd
	mov	w0, w19
	bl	NandcWaitFlashReady
	ldr	w1, [x29, 112]
	mov	w0, w19
	bl	FlashReadStatus
	sbfx	x0, x0, 0, 1
	str	w0, [x20]
	ldr	w1, [x29, 112]
	ldr	w0, [x26, #:lo12:.LANCHOR3]
	add	w1, w1, w0
	mov	w0, w19
	bl	FlashProgFirstCmd
	ldr	x0, [x20, 8]
	mov	w2, w25
	mov	w1, 1
	cmp	x0, 0
	add	x3, x0, 2048
	ldr	x0, [x20, 16]
	csel	x3, x3, xzr, ne
	cmp	x0, 0
	add	x4, x0, 8
	csel	x4, x4, xzr, ne
	mov	w0, w19
	bl	NandcXferData
	ldr	w0, [x28]
	ldr	w1, [x29, 112]
	add	w1, w1, w0
	mov	w0, w19
	bl	FlashProgSecondCmd
	mov	w0, w19
	bl	NandcWaitFlashReady
	ldr	w1, [x29, 112]
	mov	w0, w19
	bl	FlashReadStatus
	tbz	x0, 0, .L1412
	mov	w0, -1
	str	w0, [x20]
.L1412:
	mov	w0, w19
	bl	NandcFlashDeCs
	b	.L1409
.L1420:
	ldr	w0, [x27]
	cmn	w0, #1
	bne	.L1415
	ldr	w1, [x27, 4]
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	bl	printf
.L1416:
	sub	w21, w21, #1
	add	x27, x27, 56
	and	w21, w21, 255
.L1434:
	cmp	x27, x20
	bne	.L1420
	b	.L1433
.L1415:
	adrp	x19, .LANCHOR199
	mov	w4, w21
	add	x3, x29, 116
	add	x2, x29, 112
	mov	w1, w24
	mov	x0, x27
	bl	LogAddr2PhyAddr
	ldr	x26, [x22, #:lo12:.LANCHOR198]
	ldr	x25, [x19, #:lo12:.LANCHOR199]
	mov	x2, 56
	mov	x1, x27
	add	x0, x29, 120
	str	wzr, [x26]
	str	wzr, [x25]
	bl	memcpy
	stp	x26, x25, [x29, 128]
	mov	w2, w24
	mov	w1, 1
	add	x0, x29, 120
	bl	FlashReadPages
	ldr	w25, [x29, 120]
	cmn	w25, #1
	bne	.L1417
	ldr	w1, [x27, 4]
	adrp	x0, .LC30
	add	x0, x0, :lo12:.LC30
	bl	printf
	str	w25, [x27]
.L1417:
	ldr	x0, [x27, 16]
	cbz	x0, .L1418
	ldr	w2, [x0]
	ldr	x0, [x19, #:lo12:.LANCHOR199]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1418
	ldr	w1, [x27, 4]
	adrp	x0, .LC31
	add	x0, x0, :lo12:.LC31
	bl	printf
	mov	w0, -1
	str	w0, [x27]
.L1418:
	ldr	x0, [x27, 8]
	cbz	x0, .L1416
	ldr	w2, [x0]
	ldr	x0, [x23, #:lo12:.LANCHOR198]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1416
	ldr	w1, [x27, 4]
	adrp	x0, .LC32
	add	x0, x0, :lo12:.LC32
	bl	printf
	mov	w0, -1
	str	w0, [x27]
	b	.L1416
.L1414:
	adrp	x22, .LANCHOR198
	mov	x23, x22
	b	.L1434
	.size	FlashProgSlc2KPages, .-FlashProgSlc2KPages
	.section	.text.FlashProgPages,"ax",@progbits
	.align	2
	.global	FlashProgPages
	.type	FlashProgPages, %function
FlashProgPages:
	stp	x29, x30, [sp, -176]!
	adrp	x4, .LANCHOR18
	add	x29, sp, 0
	ldr	x4, [x4, #:lo12:.LANCHOR18]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldrb	w4, [x4, 19]
	stp	w3, w4, [x29, 100]
	adrp	x4, .LANCHOR1
	ldrb	w4, [x4, #:lo12:.LANCHOR1]
	cbnz	w4, .L1437
	mov	x19, x0
	adrp	x0, .LANCHOR31+9
	adrp	x27, .LANCHOR23
	mov	w24, w1
	ldrb	w0, [x0, #:lo12:.LANCHOR31+9]
	mov	w22, w2
	add	x28, x27, :lo12:.LANCHOR23
	mov	w21, 0
	str	w0, [x29, 108]
.L1438:
	cmp	w21, w24
	adrp	x26, .LANCHOR25
	bcc	.L1451
	adrp	x21, .LANCHOR8
	adrp	x23, .LANCHOR23
	add	x25, x26, :lo12:.LANCHOR25
	add	x21, x21, :lo12:.LANCHOR8
	add	x23, x23, :lo12:.LANCHOR23
	mov	x20, 0
.L1452:
	ldrb	w0, [x25]
	cmp	w0, w20
	bhi	.L1454
	ldr	w0, [x29, 100]
	cbnz	w0, .L1455
.L1463:
	mov	w0, 0
	b	.L1436
.L1437:
	bl	FlashProgSlc2KPages
.L1436:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1451:
	mov	w12, 56
	mov	w1, w22
	sub	w4, w24, w21
	add	x3, x29, 116
	umull	x12, w21, w12
	add	x2, x29, 112
	add	x25, x19, x12
	mov	x0, x25
	bl	LogAddr2PhyAddr
	mov	w23, w0
	ldrb	w1, [x26, #:lo12:.LANCHOR25]
	ldr	w0, [x29, 116]
	cmp	w1, w0
	bhi	.L1440
	mov	w0, -1
	str	w0, [x19, x12]
.L1441:
	add	w21, w21, 1
	b	.L1438
.L1440:
	adrp	x1, .LANCHOR27
	add	x2, x27, :lo12:.LANCHOR23
	mov	x3, 24
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
	cmp	w1, 0
	uxtw	x1, w0
	csel	w23, w23, wzr, ne
	madd	x1, x1, x3, x2
	ldr	x1, [x1, 8]
	cbz	x1, .L1443
	bl	FlashWaitCmdDone
.L1443:
	ldp	w2, w1, [x29, 112]
	mov	x0, 24
	madd	x0, x1, x0, x28
	str	w2, [x0, 4]
	stp	x25, xzr, [x0, 8]
	cbz	w23, .L1444
	add	w2, w21, 1
	mov	w3, 56
	umaddl	x2, w2, w3, x19
	str	x2, [x0, 16]
.L1444:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w20, [x0, x1]
	mov	x0, 24
	mul	x1, x1, x0
	ldrb	w0, [x26, #:lo12:.LANCHOR25]
	cmp	w0, 1
	mov	w0, w20
	strb	w20, [x28, x1]
	bne	.L1445
	bl	NandcWaitFlashReady
.L1446:
	ldr	w0, [x29, 104]
	sub	w0, w0, #1
	cmp	w0, 6
	bhi	.L1447
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	ldrb	w0, [x0, w20, sxtw]
	cbz	w0, .L1447
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	add	x2, x0, 4
	mov	w3, 0
	ldrb	w1, [x0, 1]
	mov	w0, w20
	bl	HynixSetRRPara
.L1447:
	mov	w0, w20
	bl	NandcFlashCs
	cmp	w22, 1
	bne	.L1448
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L1448
	mov	w0, w20
	bl	flash_enter_slc_mode
.L1449:
	ldr	w1, [x29, 112]
	mov	w0, w20
	bl	FlashProgFirstCmd
	ldrb	w2, [x29, 108]
	mov	w1, 1
	ldp	x3, x4, [x25, 8]
	mov	w0, w20
	bl	NandcXferData
	cbz	w23, .L1450
	ldr	w1, [x29, 112]
	mov	w0, w20
	bl	FlashProgDpFirstCmd
	ldr	w1, [x29, 116]
	adrp	x0, .LANCHOR17
	add	x0, x0, :lo12:.LANCHOR17
	ldr	w0, [x0, x1, lsl 2]
	ldr	w1, [x29, 112]
	cmp	w0, 0
	mov	w0, w20
	cset	w2, ne
	bl	FlashWaitReadyEN
	adrp	x0, .LANCHOR3
	ldr	w1, [x29, 112]
	ldr	w0, [x0, #:lo12:.LANCHOR3]
	add	w1, w1, w0
	mov	w0, w20
	bl	FlashProgDpSecondCmd
	add	w0, w21, 1
	mov	w1, 56
	ldrb	w2, [x29, 108]
	nop // between mem op and mult-accumulate
	umaddl	x0, w0, w1, x19
	mov	w1, 1
	ldp	x3, x4, [x0, 8]
	mov	w0, w20
	bl	NandcXferData
.L1450:
	ldr	w1, [x29, 112]
	mov	w0, w20
	add	w21, w21, w23
	bl	FlashProgSecondCmd
	mov	w0, w20
	bl	NandcFlashDeCs
	b	.L1441
.L1445:
	bl	NandcFlashCs
	ldr	w1, [x29, 116]
	adrp	x0, .LANCHOR17
	add	x0, x0, :lo12:.LANCHOR17
	ldr	w0, [x0, x1, lsl 2]
	ldr	w1, [x29, 112]
	cmp	w0, 0
	mov	w0, w20
	cset	w2, ne
	bl	FlashWaitReadyEN
	mov	w0, w20
	bl	NandcFlashDeCs
	b	.L1446
.L1448:
	mov	w0, w20
	bl	flash_exit_slc_mode
	b	.L1449
.L1454:
	mov	w0, w20
	bl	FlashWaitCmdDone
	cmp	w22, 1
	bne	.L1453
	ldrb	w0, [x21]
	cbz	w0, .L1453
	mov	x0, 24
	mul	x0, x20, x0
	ldrb	w0, [x0, x23]
	bl	flash_exit_slc_mode
.L1453:
	add	x20, x20, 1
	b	.L1452
.L1455:
	mov	w0, 56
	and	w20, w24, 255
	adrp	x23, .LANCHOR198
	mov	x25, x23
	umaddl	x24, w24, w0, x19
.L1456:
	cmp	x24, x19
	beq	.L1463
	ldr	w0, [x19]
	cmn	w0, #1
	bne	.L1457
	ldr	w1, [x19, 4]
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	bl	printf
.L1458:
	sub	w20, w20, #1
	add	x19, x19, 56
	and	w20, w20, 255
	b	.L1456
.L1457:
	adrp	x21, .LANCHOR199
	mov	w4, w20
	add	x3, x29, 116
	add	x2, x29, 112
	mov	w1, w22
	mov	x0, x19
	bl	LogAddr2PhyAddr
	ldr	x27, [x23, #:lo12:.LANCHOR198]
	ldr	x26, [x21, #:lo12:.LANCHOR199]
	mov	x2, 56
	mov	x1, x19
	add	x0, x29, 120
	str	wzr, [x27]
	str	wzr, [x26]
	bl	memcpy
	stp	x27, x26, [x29, 128]
	mov	w2, w22
	mov	w1, 1
	add	x0, x29, 120
	bl	FlashReadPages
	ldr	w26, [x29, 120]
	cmn	w26, #1
	bne	.L1459
	ldr	w1, [x19, 4]
	adrp	x0, .LC30
	add	x0, x0, :lo12:.LC30
	bl	printf
	str	w26, [x19]
.L1459:
	ldr	x0, [x19, 16]
	cbz	x0, .L1460
	ldr	w2, [x0]
	ldr	x0, [x21, #:lo12:.LANCHOR199]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1460
	ldr	w1, [x19, 4]
	adrp	x0, .LC31
	add	x0, x0, :lo12:.LC31
	bl	printf
	mov	w0, -1
	str	w0, [x19]
.L1460:
	ldr	x0, [x19, 8]
	cbz	x0, .L1458
	ldr	w2, [x0]
	ldr	x0, [x25, #:lo12:.LANCHOR198]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1458
	ldr	w1, [x19, 4]
	adrp	x0, .LC32
	add	x0, x0, :lo12:.LC32
	bl	printf
	mov	w0, -1
	str	w0, [x19]
	b	.L1458
	.size	FlashProgPages, .-FlashProgPages
	.section	.text.FlashTestBlk,"ax",@progbits
	.align	2
	.global	FlashTestBlk
	.type	FlashTestBlk, %function
FlashTestBlk:
	stp	x29, x30, [sp, -160]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	adrp	x0, .LANCHOR149
	ldr	w0, [x0, #:lo12:.LANCHOR149]
	cmp	w19, w0
	bcc	.L1491
	adrp	x20, .LANCHOR153
	mov	w2, 32
	mov	w1, 165
	lsl	w19, w19, 10
	ldr	x0, [x20, #:lo12:.LANCHOR153]
	str	x0, [x29, 48]
	add	x0, x29, 96
	str	x0, [x29, 56]
	bl	ftl_memset
	ldr	x0, [x20, #:lo12:.LANCHOR153]
	mov	w2, 8
	mov	w1, 90
	bl	ftl_memset
	str	w19, [x29, 44]
	mov	w2, 1
	add	x0, x29, 40
	mov	w1, w2
	bl	FlashEraseBlocks
	mov	w3, 1
	add	x0, x29, 40
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
	ldr	w0, [x29, 40]
	mov	w2, 1
	mov	w1, 0
	cmp	w0, 0
	add	x0, x29, 40
	csetm	w19, ne
	bl	FlashEraseBlocks
.L1489:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 160
	ret
.L1491:
	mov	w19, 0
	b	.L1489
	.size	FlashTestBlk, .-FlashTestBlk
	.section	.text.FtlLowFormatEraseBlock,"ax",@progbits
	.align	2
	.global	FtlLowFormatEraseBlock
	.type	FtlLowFormatEraseBlock, %function
FtlLowFormatEraseBlock:
	stp	x29, x30, [sp, -144]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	and	w26, w0, 65535
	adrp	x0, .LANCHOR77
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	cbnz	w0, .L1516
	adrp	x23, .LANCHOR27
	and	w25, w1, 255
	adrp	x20, .LANCHOR8
	adrp	x1, .LANCHOR38
	ldrb	w0, [x23, #:lo12:.LANCHOR27]
	adrp	x21, .LANCHOR78
	str	w0, [x29, 136]
	mov	x8, 56
	adrp	x0, .LANCHOR74
	ldrb	w10, [x20, #:lo12:.LANCHOR8]
	ldrh	w11, [x1, #:lo12:.LANCHOR38]
	adrp	x7, .LANCHOR47
	str	w26, [x0, #:lo12:.LANCHOR74]
	adrp	x0, .LANCHOR189
	ldr	x6, [x21, #:lo12:.LANCHOR78]
	add	x7, x7, :lo12:.LANCHOR47
	ldr	x12, [x0, #:lo12:.LANCHOR189]
	adrp	x0, .LANCHOR59
	mov	w14, w8
	mov	x5, 0
	ldrh	w13, [x0, #:lo12:.LANCHOR59]
	mov	w24, 0
	mov	w19, 0
	str	x1, [x29, 128]
	str	x0, [x29, 120]
.L1495:
	cmp	w11, w5, uxth
	bhi	.L1499
	cbz	w24, .L1493
	cmp	w10, 0
	mov	w2, w24
	cset	w22, ne
	strb	wzr, [x23, #:lo12:.LANCHOR27]
	mov	w1, w22
	mov	x0, x6
	bl	FlashEraseBlocks
	mov	x27, 0
	ldrb	w0, [x29, 136]
	strb	w0, [x23, #:lo12:.LANCHOR27]
	mov	w0, 56
	umull	x24, w24, w0
.L1502:
	ldr	x0, [x21, #:lo12:.LANCHOR78]
	add	x1, x0, x27
	ldr	w0, [x0, x27]
	cmn	w0, #1
	bne	.L1501
	ldr	w0, [x1, 4]
	add	w19, w19, 1
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.L1501:
	add	x27, x27, 56
	cmp	x27, x24
	bne	.L1502
	cbnz	w25, .L1503
	and	w22, w22, 65535
	mov	w28, 6
	mov	w27, 1
.L1504:
	adrp	x0, .LANCHOR47
	mov	w24, 0
	add	x0, x0, :lo12:.LANCHOR47
	str	x0, [x29, 112]
.L1512:
	ldr	x0, [x29, 128]
	mov	x5, 0
	ldr	x6, [x21, #:lo12:.LANCHOR78]
	mov	w20, 0
	mov	w12, 56
	ldrh	w7, [x0, #:lo12:.LANCHOR38]
	adrp	x0, .LANCHOR186
	ldr	x8, [x0, #:lo12:.LANCHOR186]
	adrp	x0, .LANCHOR187
	ldr	x10, [x0, #:lo12:.LANCHOR187]
	ldr	x0, [x29, 120]
	ldrh	w11, [x0, #:lo12:.LANCHOR59]
.L1505:
	cmp	w7, w5, uxth
	bhi	.L1508
	cbz	w20, .L1493
	mov	w2, w22
	mov	w1, w20
	strb	wzr, [x23, #:lo12:.LANCHOR27]
	mov	w3, 1
	mov	x0, x6
	bl	FlashProgPages
	mov	w1, 56
	ldrb	w0, [x29, 136]
	strb	w0, [x23, #:lo12:.LANCHOR27]
	mov	x2, 0
	umull	x1, w20, w1
.L1511:
	ldr	x0, [x21, #:lo12:.LANCHOR78]
	add	x3, x0, x2
	ldr	w0, [x0, x2]
	cbz	w0, .L1510
	ldr	w0, [x3, 4]
	add	w19, w19, 1
	stp	x2, x1, [x29, 96]
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	ldp	x2, x1, [x29, 96]
.L1510:
	add	x2, x2, 56
	cmp	x1, x2
	bne	.L1511
	add	w24, w24, w28
	and	w24, w24, 65535
	cmp	w27, w24
	bhi	.L1512
	mov	x23, 0
.L1514:
	cbz	w25, .L1513
	ldr	x0, [x21, #:lo12:.LANCHOR78]
	add	x1, x0, x23
	ldr	w0, [x0, x23]
	cbnz	w0, .L1513
	ldr	w0, [x1, 4]
	mov	w1, 1
	str	x2, [x29, 136]
	lsr	w0, w0, 10
	bl	FtlFreeSysBlkQueueIn
	ldr	x2, [x29, 136]
.L1513:
	add	x23, x23, 56
	cmp	x23, x2
	bne	.L1514
	cmp	w26, 63
	ccmp	w25, 0, 0, hi
	beq	.L1493
	ldr	x0, [x21, #:lo12:.LANCHOR78]
	mov	w2, w20
	mov	w1, w22
	bl	FlashEraseBlocks
.L1493:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1499:
	mul	x0, x5, x8
	mov	w1, w26
	str	wzr, [x6, x0]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	and	w15, w0, 65535
	mov	w22, w15
	cbz	w25, .L1496
	bl	IsBlkInVendorPart
	cbnz	w0, .L1497
.L1496:
	mov	w0, w22
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L1498
	umaddl	x1, w24, w14, x6
	lsl	w15, w15, 10
	mul	w0, w24, w13
	add	w24, w24, 1
	and	w24, w24, 65535
	asr	w0, w0, 2
	str	w15, [x1, 4]
	add	x0, x12, x0, sxtw 2
	stp	xzr, x0, [x1, 8]
.L1497:
	add	x5, x5, 1
	b	.L1495
.L1498:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1497
.L1503:
	adrp	x0, .LANCHOR54
	ldrh	w27, [x0, #:lo12:.LANCHOR54]
	ldrb	w0, [x20, #:lo12:.LANCHOR8]
	cbnz	w0, .L1517
	lsr	w28, w27, 2
	mov	w22, 1
	b	.L1504
.L1517:
	mov	w22, 1
	mov	w28, w22
	b	.L1504
.L1508:
	mov	x0, 56
	mov	w1, w26
	mul	x0, x5, x0
	str	wzr, [x6, x0]
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, x5]
	bl	V2P_block
	and	w13, w0, 65535
	mov	w14, w13
	cbz	w25, .L1506
	bl	IsBlkInVendorPart
	cbnz	w0, .L1507
.L1506:
	mov	w0, w14
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L1507
	umaddl	x1, w20, w12, x6
	add	w13, w24, w13, lsl 10
	mul	w0, w20, w11
	add	w20, w20, 1
	and	w20, w20, 65535
	asr	w0, w0, 2
	str	w13, [x1, 4]
	add	x0, x10, x0, sxtw 2
	stp	x8, x0, [x1, 8]
.L1507:
	add	x5, x5, 1
	b	.L1505
.L1516:
	mov	w19, 0
	b	.L1493
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
	.section	.text.FtlBbmTblFlush,"ax",@progbits
	.align	2
	.global	FtlBbmTblFlush
	.type	FtlBbmTblFlush, %function
FtlBbmTblFlush:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR77
	stp	x19, x20, [sp, 16]
	ldr	w0, [x22, #:lo12:.LANCHOR77]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w0, .L1540
	adrp	x24, .LANCHOR188
	adrp	x23, .LANCHOR183
	adrp	x20, .LANCHOR202
	add	x19, x20, :lo12:.LANCHOR202
	ldr	x1, [x24, #:lo12:.LANCHOR188]
	adrp	x21, .LANCHOR75
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	add	x26, x21, :lo12:.LANCHOR75
	stp	x0, x1, [x19, 8]
	adrp	x1, .LANCHOR58
	adrp	x27, .LANCHOR45
	adrp	x28, .LANCHOR123
	ldrh	w2, [x1, #:lo12:.LANCHOR58]
	add	x26, x26, 32
	mov	w25, 0
	add	x27, x27, :lo12:.LANCHOR45
	add	x28, x28, :lo12:.LANCHOR123
	mov	w1, 0
	bl	ftl_memset
.L1541:
	ldrh	w0, [x27]
	cmp	w25, w0
	blt	.L1542
	add	x20, x20, :lo12:.LANCHOR202
	add	x19, x21, :lo12:.LANCHOR75
	mov	w2, 16
	mov	w1, 255
	adrp	x25, .LC33
	adrp	x27, .LANCHOR54
	ldr	x28, [x20, 16]
	add	x25, x25, :lo12:.LC33
	add	x27, x27, :lo12:.LANCHOR54
	mov	w26, 0
	mov	x0, x28
	bl	ftl_memset
	mov	w0, -3887
	strh	w0, [x28]
	ldr	w0, [x19, 8]
	str	w0, [x28, 4]
	ldrh	w0, [x21, #:lo12:.LANCHOR75]
	mov	w21, 0
	strh	w0, [x28, 2]
	ldrh	w0, [x19, 4]
	strh	w0, [x28, 8]
	ldrh	w0, [x19, 6]
	strh	w0, [x28, 10]
	adrp	x0, .LANCHOR37
	ldr	w0, [x0, #:lo12:.LANCHOR37]
	strh	w0, [x28, 12]
.L1543:
	ldrh	w1, [x19]
	ldrh	w4, [x28, 10]
	ldrh	w2, [x19, 2]
	ldrh	w3, [x19, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	str	x0, [x20, 8]
	ldr	x0, [x24, #:lo12:.LANCHOR188]
	str	x0, [x20, 16]
	orr	w0, w2, w1, lsl 10
	str	wzr, [x20]
	str	w0, [x20, 4]
	mov	x0, x25
	bl	printf
	ldrh	w0, [x27]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L1544
	ldr	w0, [x19, 8]
	mov	w2, 1
	ldrh	w1, [x19, 4]
	add	w0, w0, 1
	str	w0, [x19, 8]
	str	w0, [x28, 4]
	ldrh	w0, [x19]
	strh	w0, [x28, 8]
	strh	w0, [x19, 4]
	adrp	x0, .LANCHOR78
	strh	w1, [x19]
	lsl	w1, w1, 10
	ldr	x0, [x0, #:lo12:.LANCHOR78]
	str	w1, [x20, 4]
	strh	wzr, [x19, 2]
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
.L1544:
	mov	w3, 1
	mov	x0, x20
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L1545
	ldr	w1, [x20, 4]
	add	w21, w21, 1
	adrp	x0, .LC34
	and	w21, w21, 65535
	add	x0, x0, :lo12:.LC34
	bl	printf
	cmp	w21, 3
	bls	.L1543
	ldr	w1, [x20, 4]
	mov	w2, w21
	adrp	x0, .LC35
	add	x0, x0, :lo12:.LC35
	bl	printf
	mov	w0, 1
	str	w0, [x22, #:lo12:.LANCHOR77]
.L1540:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1542:
	ldrh	w2, [x28]
	ldr	x1, [x26], 8
	ldr	x0, [x19, 8]
	mul	w3, w2, w25
	lsl	w2, w2, 2
	add	w25, w25, 1
	add	x0, x0, x3, sxtw 2
	bl	ftl_memcpy
	b	.L1541
.L1545:
	cbnz	w26, .L1540
	mov	w26, 1
	b	.L1543
	.size	FtlBbmTblFlush, .-FtlBbmTblFlush
	.section	.text.allocate_data_superblock,"ax",@progbits
	.align	2
	.global	allocate_data_superblock
	.type	allocate_data_superblock, %function
allocate_data_superblock:
	adrp	x1, .LANCHOR77
	ldr	w1, [x1, #:lo12:.LANCHOR77]
	cbnz	w1, .L1614
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x27, x28, [sp, 80]
	adrp	x27, .LANCHOR86
	add	x0, x27, :lo12:.LANCHOR86
	stp	x23, x24, [sp, 48]
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR89
	add	x23, x0, :lo12:.LANCHOR89
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
.L1605:
	ldr	x1, [x29, 120]
	adrp	x0, .LANCHOR89
	adrp	x24, .LANCHOR40
	ldrh	w0, [x0, #:lo12:.LANCHOR89]
	ldrh	w1, [x1]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR40]
	cmp	w0, w1
	ble	.L1553
	mov	w2, 3108
	adrp	x1, .LANCHOR203
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR203
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1553:
	adrp	x0, .LANCHOR94
	add	x0, x0, :lo12:.LANCHOR94
	cmp	x19, x0
	bne	.L1554
	adrp	x1, .LANCHOR172
	ldrh	w2, [x23]
	ldr	w3, [x1, #:lo12:.LANCHOR172]
	lsr	w0, w2, 1
	add	w4, w0, 1
	mul	w1, w2, w3
	add	w1, w4, w1, lsr 2
	adrp	x4, .LANCHOR28
	and	w1, w1, 65535
	ldr	w4, [x4, #:lo12:.LANCHOR28]
	cbz	w4, .L1555
	adrp	x4, .LANCHOR170
	ldr	w4, [x4, #:lo12:.LANCHOR170]
	cmp	w4, 39
	bhi	.L1555
	cmp	w4, 2
	bls	.L1589
	tbz	x2, 0, .L1585
	cbz	w3, .L1589
.L1585:
	mov	w1, w0
	b	.L1555
.L1554:
	ldrb	w0, [x19, 8]
	cmp	w0, 1
	bne	.L1589
	adrp	x0, .LANCHOR44
	ldrh	w0, [x0, #:lo12:.LANCHOR44]
	cmp	w0, 1
	beq	.L1589
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbnz	w0, .L1589
	adrp	x2, .LANCHOR28
	ldrh	w0, [x23]
	ldr	w2, [x2, #:lo12:.LANCHOR28]
	lsr	w1, w0, 3
	cbz	w2, .L1555
	adrp	x2, .LANCHOR170
	ldr	w2, [x2, #:lo12:.LANCHOR170]
	cmp	w2, 1
	bhi	.L1555
	mov	w1, 7
	mul	w1, w0, w1
	lsr	w1, w1, 3
.L1555:
	cbz	w1, .L1556
	sub	w1, w1, #1
	and	w1, w1, 65535
.L1556:
	ldrb	w2, [x19, 8]
	adrp	x0, .LANCHOR88
	add	x0, x0, :lo12:.LANCHOR88
	bl	List_pop_index_node
	and	w22, w0, 65535
	ldrh	w0, [x23]
	cbnz	w0, .L1557
	mov	w2, 3128
	adrp	x1, .LANCHOR203
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR203
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1557:
	ldrh	w0, [x23]
	sub	w0, w0, #1
	strh	w0, [x23]
	ldrh	w0, [x24, #:lo12:.LANCHOR40]
	cmp	w0, w22
	bls	.L1605
	adrp	x25, .LANCHOR84
	ubfiz	x21, x22, 1, 16
	ldr	x0, [x25, #:lo12:.LANCHOR84]
	ldrh	w20, [x0, x21]
	cbnz	w20, .L1605
	strh	w22, [x19]
	mov	x0, x19
	bl	make_superblock
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1559
	ldr	x0, [x25, #:lo12:.LANCHOR84]
	mov	w1, -1
	strh	w1, [x0, x21]
	ldrh	w1, [x27, #:lo12:.LANCHOR86]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR40]
	cmp	w0, w1
	ble	.L1605
	mov	w2, 3144
	adrp	x1, .LANCHOR203
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR203
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
	b	.L1605
.L1589:
	mov	w1, 0
	b	.L1556
.L1559:
	ldrh	w1, [x27, #:lo12:.LANCHOR86]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR40]
	cmp	w0, w1
	ble	.L1561
	mov	w2, 3147
	adrp	x1, .LANCHOR203
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR203
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1561:
	adrp	x1, .LANCHOR38
	adrp	x25, .LANCHOR78
	mov	w2, 56
	mov	x3, 8
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	add	x26, x19, 16
	ldr	x4, [x25, #:lo12:.LANCHOR78]
	mov	x5, x26
	mov	w6, 65535
	add	x0, x4, 8
	umaddl	x1, w2, w1, x3
	add	x1, x4, x1
.L1562:
	cmp	x1, x0
	bne	.L1564
	cbnz	w20, .L1565
	mov	w2, 3159
	adrp	x1, .LANCHOR203
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR203
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1565:
	adrp	x0, .LANCHOR28
	adrp	x28, .LANCHOR79
	ldr	w0, [x0, #:lo12:.LANCHOR28]
	cbz	w0, .L1566
	adrp	x0, .LANCHOR92
	add	x0, x0, :lo12:.LANCHOR92
	cmp	x19, x0
	bne	.L1566
	ldr	x0, [x28, #:lo12:.LANCHOR79]
	ldrh	w0, [x0, x21]
	cmp	w0, 40
	bls	.L1566
	strb	wzr, [x19, 8]
.L1566:
	adrp	x0, .LANCHOR204
	ldrh	w0, [x0, #:lo12:.LANCHOR204]
	cmp	w0, w22
	bne	.L1567
	mov	w2, 3166
	adrp	x1, .LANCHOR203
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR203
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1567:
	ldrb	w0, [x19, 8]
	adrp	x6, .LANCHOR48
	adrp	x5, .LANCHOR167
	adrp	x4, .LANCHOR168
	ldr	x1, [x28, #:lo12:.LANCHOR79]
	cbnz	w0, .L1568
	ldrh	w0, [x1, x21]
	cbz	w0, .L1569
	ldrh	w2, [x6, #:lo12:.LANCHOR48]
	add	w0, w0, w2
.L1617:
	strh	w0, [x1, x21]
	mov	w1, 0
	ldr	w0, [x5, #:lo12:.LANCHOR167]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR167]
	mov	w0, w22
	bl	ftl_set_blk_mode
.L1571:
	ldr	x0, [x28, #:lo12:.LANCHOR79]
	ldrh	w1, [x0, x21]
	adrp	x0, .LANCHOR169
	ldr	w2, [x0, #:lo12:.LANCHOR169]
	cmp	w1, w2
	bls	.L1572
	str	w1, [x0, #:lo12:.LANCHOR169]
.L1572:
	ldr	w2, [x5, #:lo12:.LANCHOR167]
	mov	x3, 4
	ldr	w1, [x4, #:lo12:.LANCHOR168]
	ldrh	w0, [x6, #:lo12:.LANCHOR48]
	madd	w0, w0, w2, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR40]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR205
	str	w0, [x1, #:lo12:.LANCHOR205]
	adrp	x0, .LANCHOR191
	ldr	x1, [x0, #:lo12:.LANCHOR191]
	ldr	w0, [x1, 16]
	add	w0, w0, 1
	str	w0, [x1, 16]
	mov	w1, 56
	ldr	x0, [x25, #:lo12:.LANCHOR78]
	nop // between mem op and mult-accumulate
	umaddl	x1, w1, w20, x3
	add	x2, x0, 4
	add	x1, x0, x1
.L1573:
	cmp	x1, x2
	bne	.L1574
	adrp	x1, .LANCHOR8
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	cbz	w1, .L1575
	ldrb	w1, [x19, 8]
	mov	w2, w20
	cmp	w1, 1
	bne	.L1576
	mov	w1, 0
.L1618:
	bl	FlashEraseBlocks
.L1575:
	ldrb	w1, [x19, 8]
	mov	w2, w20
	ldr	x0, [x25, #:lo12:.LANCHOR78]
	mov	x24, 0
	bl	FlashEraseBlocks
	mov	w1, 0
	mov	x3, 56
.L1577:
	cmp	w20, w24, uxth
	bhi	.L1579
	cbz	w1, .L1580
	mov	w0, w22
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1580:
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1581
	adrp	x0, .LANCHOR84
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR84]
	strh	w1, [x0, x21]
	b	.L1605
.L1564:
	ldrh	w3, [x5]
	stp	xzr, xzr, [x0]
	cmp	w3, w6
	beq	.L1563
	umaddl	x7, w20, w2, x4
	add	w20, w20, 1
	and	w20, w20, 65535
	lsl	w3, w3, 10
	str	w3, [x7, 4]
.L1563:
	add	x0, x0, 56
	add	x5, x5, 2
	b	.L1562
.L1569:
	mov	w0, 2
	b	.L1617
.L1568:
	ldrh	w0, [x1, x21]
	add	w0, w0, 1
	strh	w0, [x1, x21]
	ldr	w0, [x4, #:lo12:.LANCHOR168]
	add	w0, w0, 1
	str	w0, [x4, #:lo12:.LANCHOR168]
	mov	w0, w22
	bl	ftl_set_blk_mode.part.10
	b	.L1571
.L1574:
	ldr	w3, [x2]
	and	w3, w3, -1024
	str	w3, [x2], 56
	b	.L1573
.L1576:
	mov	w1, 1
	b	.L1618
.L1579:
	mul	x0, x24, x3
	ldr	x2, [x25, #:lo12:.LANCHOR78]
	add	x4, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L1578
	add	w1, w1, 1
	ldr	w0, [x4, 4]
	str	x3, [x29, 104]
	stp	w2, w1, [x29, 112]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	ldp	w2, w1, [x29, 112]
	strh	w2, [x26]
	ldr	x3, [x29, 104]
	ldrb	w0, [x19, 7]
	sub	w0, w0, #1
	strb	w0, [x19, 7]
.L1578:
	add	x24, x24, 1
	add	x26, x26, 2
	b	.L1577
.L1581:
	adrp	x1, .LANCHOR53
	adrp	x2, .LANCHOR159
	strh	wzr, [x19, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	strh	w22, [x19]
	strb	wzr, [x19, 6]
	mul	w0, w0, w1
	ldr	w1, [x2, #:lo12:.LANCHOR159]
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x2, #:lo12:.LANCHOR159]
	adrp	x1, .LANCHOR84
	and	w0, w0, 65535
	strh	w0, [x19, 4]
	ldr	x1, [x1, #:lo12:.LANCHOR84]
	strh	w0, [x1, x21]
	ldrh	w0, [x19, 4]
	cbz	w0, .L1582
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1552
.L1582:
	mov	w2, 3225
	adrp	x1, .LANCHOR203
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR203
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1552:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1614:
	mov	w0, 0
	ret
	.size	allocate_data_superblock, .-allocate_data_superblock
	.section	.text.FtlGcFreeBadSuperBlk,"ax",@progbits
	.align	2
	.global	FtlGcFreeBadSuperBlk
	.type	FtlGcFreeBadSuperBlk, %function
FtlGcFreeBadSuperBlk:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR117
	stp	x25, x26, [sp, 64]
	and	w25, w0, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR117]
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	str	x27, [sp, 80]
	cbz	w0, .L1620
	adrp	x23, .LANCHOR118
	add	x24, x23, :lo12:.LANCHOR118
	mov	w19, 0
.L1621:
	adrp	x0, .LANCHOR38
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w0, w19
	bhi	.L1627
	bl	FtlGcReFreshBadBlk
.L1620:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1627:
	adrp	x0, .LANCHOR47
	add	x0, x0, :lo12:.LANCHOR47
	mov	w1, w25
	add	x22, x21, :lo12:.LANCHOR117
	mov	w20, 0
	ldrb	w0, [x0, w19, sxtw]
	bl	V2P_block
	and	w26, w0, 65535
.L1622:
	ldrh	w0, [x22]
	cmp	w0, w20
	bhi	.L1626
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1621
.L1626:
	add	x0, x23, :lo12:.LANCHOR118
	add	w27, w20, 1
	ldrh	w0, [x0, w20, sxtw 1]
	cmp	w0, w26
	bne	.L1623
	mov	w0, w26
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	w1, [x22]
	sxtw	x3, w27
	and	x4, x20, 65535
	mov	x0, 0
.L1624:
	add	w2, w20, w0
	cmp	w1, w2, uxth
	bhi	.L1625
	sub	w1, w1, #1
	strh	w1, [x22]
.L1623:
	and	w20, w27, 65535
	b	.L1622
.L1625:
	add	x2, x3, x0
	ldrh	w5, [x24, x2, lsl 1]
	add	x2, x4, x0
	add	x0, x0, 1
	strh	w5, [x24, x2, lsl 1]
	b	.L1624
	.size	FtlGcFreeBadSuperBlk, .-FtlGcFreeBadSuperBlk
	.section	.text.update_vpc_list,"ax",@progbits
	.align	2
	.global	update_vpc_list
	.type	update_vpc_list, %function
update_vpc_list:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR84
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR84]
	ubfiz	x0, x19, 1, 16
	ldrh	w0, [x1, x0]
	cbnz	w0, .L1633
	adrp	x0, .LANCHOR204
	ldrh	w1, [x0, #:lo12:.LANCHOR204]
	cmp	w1, w19
	bne	.L1634
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR204]
.L1635:
	adrp	x20, .LANCHOR86
	mov	w1, w19
	adrp	x0, .LANCHOR83
	add	x0, x0, :lo12:.LANCHOR83
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR86]
	cbnz	w0, .L1637
	mov	w2, 3336
	adrp	x1, .LANCHOR206
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR206
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1637:
	ldrh	w0, [x20, #:lo12:.LANCHOR86]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR86]
	mov	w0, w19
	bl	free_data_superblock
	mov	w0, w19
	bl	FtlGcFreeBadSuperBlk
	adrp	x0, .LANCHOR89
	ldrh	w1, [x20, #:lo12:.LANCHOR86]
	ldrh	w0, [x0, #:lo12:.LANCHOR89]
	add	w0, w0, w1
	adrp	x1, .LANCHOR40
	ldrh	w1, [x1, #:lo12:.LANCHOR40]
	cmp	w0, w1
	ble	.L1641
	mov	w2, 3339
	adrp	x1, .LANCHOR206
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR206
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1641:
	mov	w0, 1
	b	.L1632
.L1634:
	adrp	x0, .LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w0, w19
	beq	.L1640
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w0, w19
	beq	.L1640
	adrp	x0, .LANCHOR94
	ldrh	w0, [x0, #:lo12:.LANCHOR94]
	cmp	w0, w19
	bne	.L1635
.L1640:
	mov	w0, 0
.L1632:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1633:
	mov	w0, w19
	bl	List_update_data_list
	b	.L1640
	.size	update_vpc_list, .-update_vpc_list
	.section	.text.decrement_vpc_count,"ax",@progbits
	.align	2
	.global	decrement_vpc_count
	.type	decrement_vpc_count, %function
decrement_vpc_count:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	stp	x21, x22, [sp, 32]
	mov	w0, 65535
	cmp	w19, w0
	beq	.L1644
	adrp	x20, .LANCHOR84
	ubfiz	x21, x19, 1, 16
	ldr	x1, [x20, #:lo12:.LANCHOR84]
	ldrh	w0, [x1, x21]
	cbnz	w0, .L1645
	mov	w2, 0
	mov	w1, w19
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR84]
	ldrh	w0, [x0, x21]
	cbnz	w0, .L1646
	mov	w2, 3354
	adrp	x1, .LANCHOR207
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR207
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1646:
	ldr	x0, [x20, #:lo12:.LANCHOR84]
	adrp	x6, .LANCHOR88
	add	x6, x6, :lo12:.LANCHOR88
	mov	w1, 32
	strh	w1, [x0, x21]
	mov	w1, w19
	mov	x0, x6
	bl	test_node_in_list
	cbz	w0, .L1647
	adrp	x22, .LANCHOR89
	mov	w1, w19
	mov	x0, x6
	bl	List_remove_node
	ldrh	w0, [x22, #:lo12:.LANCHOR89]
	cbnz	w0, .L1648
	mov	w2, 3358
	adrp	x1, .LANCHOR207
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR207
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1648:
	ldrh	w0, [x22, #:lo12:.LANCHOR89]
	sub	w0, w0, #1
	strh	w0, [x22, #:lo12:.LANCHOR89]
	mov	w0, w19
	bl	INSERT_DATA_LIST
	ldr	x0, [x20, #:lo12:.LANCHOR84]
	mov	w1, w19
	ldrh	w2, [x0, x21]
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	bl	printf
.L1647:
	mov	w0, w19
	bl	FtlGcRefreshBlock
.L1651:
	mov	w20, 0
	b	.L1643
.L1645:
	sub	w0, w0, #1
	strh	w0, [x1, x21]
.L1644:
	adrp	x21, .LANCHOR133
	mov	w1, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR133]
	cmp	w0, w1
	bne	.L1650
	strh	w19, [x21, #:lo12:.LANCHOR133]
	b	.L1651
.L1650:
	cmp	w19, w0
	beq	.L1651
	bl	update_vpc_list
	cmp	w0, 0
	adrp	x1, .LANCHOR82
	adrp	x0, .LANCHOR83
	strh	w19, [x21, #:lo12:.LANCHOR133]
	cset	w20, ne
	ldr	x1, [x1, #:lo12:.LANCHOR82]
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	sub	x0, x0, x1
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	adrp	x1, .LANCHOR84
	ldr	x1, [x1, #:lo12:.LANCHOR84]
	and	x2, x0, 65535
	ldrh	w1, [x1, x2, lsl 1]
	cbnz	w1, .L1643
	cmp	w19, w0, uxth
	beq	.L1643
	mov	w2, 3379
	adrp	x1, .LANCHOR207
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR207
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1643:
	mov	w0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
	.size	decrement_vpc_count, .-decrement_vpc_count
	.section	.text.FtlSlcSuperblockCheck,"ax",@progbits
	.align	2
	.global	FtlSlcSuperblockCheck
	.type	FtlSlcSuperblockCheck, %function
FtlSlcSuperblockCheck:
	ldrh	w1, [x0, 4]
	cbz	w1, .L1668
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, 65535
	ldrh	w1, [x0]
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	cmp	w1, w20
	beq	.L1656
	mov	x19, x0
	ldrb	w0, [x0, 6]
	adrp	x22, .LANCHOR8
	adrp	x21, .LANCHOR120
	add	x0, x0, 8
	add	x23, x22, :lo12:.LANCHOR8
	add	x21, x21, :lo12:.LANCHOR120
	ldrh	w0, [x19, x0, lsl 1]
.L1660:
	cmp	w0, w20
	beq	.L1662
	ldrb	w0, [x19, 8]
	cmp	w0, 1
	bne	.L1663
	ldrb	w1, [x23]
	cbnz	w1, .L1663
	ldrh	w1, [x19, 2]
	ldrh	w1, [x21, x1, lsl 1]
	cmp	w1, w20
	bne	.L1663
	ldrh	w0, [x19, 4]
	sub	w0, w0, #1
	strh	w0, [x19, 4]
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1662
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
.L1671:
	strh	w0, [x19, 2]
	strb	wzr, [x19, 6]
.L1656:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1662:
	ldrb	w0, [x19, 6]
	adrp	x1, .LANCHOR38
	add	w0, w0, 1
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	and	w0, w0, 255
	strb	w0, [x19, 6]
	cmp	w1, w0
	bne	.L1661
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L1661:
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w0, [x19, x0, lsl 1]
	b	.L1660
.L1663:
	ldrb	w1, [x22, #:lo12:.LANCHOR8]
	cbz	w1, .L1656
	cmp	w0, 1
	bne	.L1656
	adrp	x0, .LANCHOR54
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR54]
	cmp	w1, w0
	bcc	.L1656
	ldrh	w0, [x19]
	adrp	x1, .LANCHOR84
	ldrh	w3, [x19, 4]
	ldr	x2, [x1, #:lo12:.LANCHOR84]
	lsl	x0, x0, 1
	ldrh	w1, [x2, x0]
	sub	w1, w1, w3
	strh	w1, [x2, x0]
	adrp	x0, .LANCHOR53
	strh	wzr, [x19, 4]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	b	.L1671
.L1668:
	ret
	.size	FtlSlcSuperblockCheck, .-FtlSlcSuperblockCheck
	.section	.text.get_new_active_ppa,"ax",@progbits
	.align	2
	.global	get_new_active_ppa
	.type	get_new_active_ppa, %function
get_new_active_ppa:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w1, [x0]
	mov	w0, 65535
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	cmp	w1, w0
	str	x25, [sp, 64]
	bne	.L1673
	mov	w2, 3276
	adrp	x1, .LANCHOR208
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1673:
	adrp	x20, .LANCHOR53
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1674
	mov	w2, 3277
	adrp	x1, .LANCHOR208
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1674:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1675
	mov	w2, 3278
	adrp	x1, .LANCHOR208
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1675:
	ldrb	w0, [x19, 6]
	adrp	x21, .LANCHOR38
	strb	wzr, [x19, 10]
	adrp	x23, .LANCHOR8
	add	x0, x0, 8
	adrp	x24, .LANCHOR120
	add	x23, x23, :lo12:.LANCHOR8
	add	x24, x24, :lo12:.LANCHOR120
	add	x25, x21, :lo12:.LANCHOR38
	ldrh	w22, [x19, x0, lsl 1]
.L1676:
	mov	w2, 65535
	cmp	w22, w2
	beq	.L1677
	ldrb	w0, [x19, 8]
	ldrh	w1, [x19, 4]
	cmp	w0, 1
	ldrh	w0, [x19, 2]
	bne	.L1679
	ldrb	w3, [x23]
	cbnz	w3, .L1679
	ldrh	w3, [x24, w0, sxtw 1]
	cmp	w3, w2
	bne	.L1679
	ldrh	w0, [x19]
	sub	w1, w1, #1
	strh	w1, [x19, 4]
	bl	decrement_vpc_count
.L1677:
	ldrb	w0, [x19, 6]
	ldrh	w1, [x25]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x19, 6]
	cmp	w1, w0
	bne	.L1678
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L1678:
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w22, [x19, x0, lsl 1]
	b	.L1676
.L1679:
	adrp	x23, .LANCHOR8
	adrp	x24, .LANCHOR120
	orr	w22, w0, w22, lsl 10
	add	x23, x23, :lo12:.LANCHOR8
	add	x24, x24, :lo12:.LANCHOR120
	sub	w1, w1, #1
	strh	w1, [x19, 4]
.L1680:
	ldrb	w0, [x19, 6]
	mov	w1, 65535
	ldrh	w3, [x21, #:lo12:.LANCHOR38]
.L1682:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, w3
	bne	.L1681
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	w0, 0
.L1681:
	add	x2, x19, x0, sxtw 1
	ldrh	w2, [x2, 16]
	cmp	w2, w1
	beq	.L1682
	strb	w0, [x19, 6]
	ldrb	w0, [x19, 8]
	cmp	w0, 1
	bne	.L1683
	ldrb	w2, [x23]
	ldrh	w0, [x19, 2]
	cbnz	w2, .L1684
	ldrh	w0, [x24, w0, sxtw 1]
	cmp	w0, w1
	bne	.L1683
	ldrh	w0, [x19, 4]
	cbz	w0, .L1683
	sub	w0, w0, #1
	strh	w0, [x19, 4]
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	b	.L1680
.L1684:
	adrp	x1, .LANCHOR54
	ldrh	w1, [x1, #:lo12:.LANCHOR54]
	cmp	w0, w1
	bcc	.L1683
	ldrh	w0, [x19]
	adrp	x1, .LANCHOR84
	ldrh	w3, [x19, 4]
	ldr	x2, [x1, #:lo12:.LANCHOR84]
	lsl	x0, x0, 1
	ldrh	w1, [x2, x0]
	sub	w1, w1, w3
	strh	w1, [x2, x0]
	strh	wzr, [x19, 4]
	ldrh	w0, [x20, #:lo12:.LANCHOR53]
	strh	w0, [x19, 2]
	strb	wzr, [x19, 6]
.L1683:
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L1672
	ldrh	w0, [x19, 4]
	cbz	w0, .L1672
	mov	w2, 3322
	adrp	x1, .LANCHOR208
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1672:
	mov	w0, w22
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
	.size	get_new_active_ppa, .-get_new_active_ppa
	.section	.text.FtlVpcTblFlush,"ax",@progbits
	.align	2
	.global	FtlVpcTblFlush
	.type	FtlVpcTblFlush, %function
FtlVpcTblFlush:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR77
	stp	x19, x20, [sp, 16]
	ldr	w0, [x24, #:lo12:.LANCHOR77]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	str	x24, [x29, 104]
	cbnz	w0, .L1697
	adrp	x26, .LANCHOR188
	adrp	x28, .LANCHOR202
	adrp	x23, .LANCHOR209
	add	x21, x28, :lo12:.LANCHOR202
	ldr	x20, [x26, #:lo12:.LANCHOR188]
	adrp	x25, .LANCHOR183
	ldrh	w2, [x23, #:lo12:.LANCHOR209]
	add	x1, x23, :lo12:.LANCHOR209
	ldr	x0, [x25, #:lo12:.LANCHOR183]
	mov	w3, 19539
	stp	x0, x20, [x21, 8]
	movk	w3, 0x4654, lsl 16
	strh	w2, [x20, 2]
	mov	w2, -3932
	strh	w2, [x20]
	adrp	x22, .LANCHOR159
	ldr	w2, [x1, 8]
	adrp	x27, .LANCHOR40
	ldrh	w1, [x1, 6]
	stp	w2, wzr, [x20, 4]
	adrp	x2, .LANCHOR81
	add	x19, x2, :lo12:.LANCHOR81
	str	wzr, [x20, 12]
	str	w3, [x2, #:lo12:.LANCHOR81]
	mov	w2, 80
	movk	w2, 0x5000, lsl 16
	strh	w1, [x19, 8]
	adrp	x1, .LANCHOR45
	str	w2, [x19, 4]
	adrp	x2, .LANCHOR92
	ldrh	w1, [x1, #:lo12:.LANCHOR45]
	strb	w1, [x19, 10]
	add	x1, x2, :lo12:.LANCHOR92
	ldrh	w2, [x2, #:lo12:.LANCHOR92]
	strh	w2, [x19, 14]
	ldrb	w3, [x1, 6]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x19, 11]
	orr	w2, w3, w2, lsl 6
	strh	w2, [x19, 16]
	adrp	x2, .LANCHOR93
	add	x1, x2, :lo12:.LANCHOR93
	ldrh	w2, [x2, #:lo12:.LANCHOR93]
	ldrb	w3, [x1, 6]
	strh	w2, [x19, 18]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x19, 12]
	orr	w2, w3, w2, lsl 6
	strh	w2, [x19, 20]
	adrp	x2, .LANCHOR94
	add	x1, x2, :lo12:.LANCHOR94
	ldrh	w2, [x2, #:lo12:.LANCHOR94]
	strh	w2, [x19, 22]
	ldrb	w3, [x1, 6]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x19, 13]
	adrp	x1, .LANCHOR167
	orr	w2, w3, w2, lsl 6
	strh	w2, [x19, 24]
	ldr	w1, [x1, #:lo12:.LANCHOR167]
	str	w1, [x19, 32]
	ldr	w1, [x22, #:lo12:.LANCHOR159]
	str	w1, [x19, 40]
	adrp	x1, .LANCHOR160
	ldr	w1, [x1, #:lo12:.LANCHOR160]
	str	w1, [x19, 36]
	adrp	x1, .LANCHOR113
	ldrh	w1, [x1, #:lo12:.LANCHOR113]
	strh	w1, [x19, 44]
	adrp	x1, .LANCHOR114
	ldrh	w1, [x1, #:lo12:.LANCHOR114]
	strh	w1, [x19, 46]
	adrp	x1, .LANCHOR58
	ldrh	w2, [x1, #:lo12:.LANCHOR58]
	mov	w1, 255
	bl	ftl_memset
	ldr	x0, [x21, 8]
	mov	x1, x19
	mov	w2, 48
	mov	x19, x28
	bl	ftl_memcpy
	adrp	x1, .LANCHOR84
	ldrh	w2, [x27, #:lo12:.LANCHOR40]
	ldr	x0, [x21, 8]
	ldr	x1, [x1, #:lo12:.LANCHOR84]
	lsl	w2, w2, 1
	add	x0, x0, 48
	bl	ftl_memcpy
	ldrh	w0, [x27, #:lo12:.LANCHOR40]
	adrp	x1, .LANCHOR0
	ldr	x3, [x21, 8]
	ldr	x1, [x1, #:lo12:.LANCHOR0]
	lsr	w2, w0, 3
	ubfiz	x0, x0, 1, 16
	add	x0, x0, 48
	add	w2, w2, 4
	and	x0, x0, -4
	add	x0, x3, x0
	bl	ftl_memcpy
	adrp	x0, .LANCHOR70
	ldrh	w0, [x0, #:lo12:.LANCHOR70]
	cbz	w0, .L1698
	ldrh	w0, [x27, #:lo12:.LANCHOR40]
	adrp	x1, .LANCHOR67
	ldr	x3, [x21, 8]
	ldrh	w2, [x1, #:lo12:.LANCHOR67]
	lsr	w1, w0, 3
	add	w0, w1, w0, lsl 1
	adrp	x1, .LANCHOR131
	add	w0, w0, 52
	lsl	w2, w2, 2
	ldr	x1, [x1, #:lo12:.LANCHOR131]
	and	x0, x0, 65532
	add	x0, x3, x0
	bl	ftl_memcpy
.L1698:
	add	x28, x19, :lo12:.LANCHOR202
	mov	w0, 0
	add	x24, x23, :lo12:.LANCHOR209
	bl	FtlUpdateVaildLpn
	adrp	x23, .LANCHOR54
	mov	w21, 0
	add	x23, x23, :lo12:.LANCHOR54
	mov	w27, 65535
	str	x23, [x29, 96]
.L1699:
	ldrh	w2, [x24, 2]
	ldrh	w1, [x24]
	ldr	x0, [x25, #:lo12:.LANCHOR183]
	str	x0, [x28, 8]
	ldr	x0, [x26, #:lo12:.LANCHOR188]
	str	x0, [x28, 16]
	orr	w0, w2, w1, lsl 10
	str	w0, [x28, 4]
	ldrh	w0, [x23]
	sub	w0, w0, #1
	cmp	w2, w0
	blt	.L1700
	ldrh	w27, [x24, 4]
	strh	wzr, [x24, 2]
	strh	w1, [x24, 4]
	bl	FtlFreeSysBlkQueueOut
	ldr	w1, [x22, #:lo12:.LANCHOR159]
	str	w1, [x24, 8]
	add	w2, w1, 1
	str	w2, [x22, #:lo12:.LANCHOR159]
	ubfiz	w2, w0, 10, 16
	str	w2, [x28, 4]
	strh	w0, [x24]
	strh	w0, [x20, 2]
	str	w1, [x20, 4]
.L1700:
	mov	w3, 1
	mov	x0, x28
	mov	w1, w3
	mov	w2, w3
	bl	FlashProgPages
	ldrh	w0, [x24, 2]
	ldr	w1, [x28]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x24, 2]
	cmn	w1, #1
	bne	.L1701
	cmp	w0, 1
	bne	.L1702
	mov	w2, 1209
	adrp	x1, .LANCHOR210
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR210
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1702:
	ldrh	w0, [x24, 2]
	cmp	w0, 1
	bne	.L1703
	ldr	x0, [x29, 96]
	ldrh	w0, [x0]
	sub	w0, w0, #1
	strh	w0, [x24, 2]
.L1703:
	add	w21, w21, 1
	and	w21, w21, 65535
	cmp	w21, 3
	bls	.L1699
	add	x19, x19, :lo12:.LANCHOR202
	mov	w2, w21
	adrp	x0, .LC38
	add	x0, x0, :lo12:.LC38
	ldr	w1, [x19, 4]
	bl	printf
	ldr	x1, [x29, 104]
	mov	w0, 1
	str	w0, [x1, #:lo12:.LANCHOR77]
.L1697:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1701:
	cmp	w0, 1
	beq	.L1699
	cmp	w1, 256
	beq	.L1699
	mov	w0, 65535
	cmp	w27, w0
	beq	.L1697
	mov	w1, 1
	mov	w0, w27
	bl	FtlFreeSysBlkQueueIn
	b	.L1697
	.size	FtlVpcTblFlush, .-FtlVpcTblFlush
	.section	.text.FtlSuperblockPowerLostFix,"ax",@progbits
	.align	2
	.global	FtlSuperblockPowerLostFix
	.type	FtlSuperblockPowerLostFix, %function
FtlSuperblockPowerLostFix:
	stp	x29, x30, [sp, -128]!
	adrp	x1, .LANCHOR77
	add	x29, sp, 0
	str	x23, [sp, 48]
	ldr	w23, [x1, #:lo12:.LANCHOR77]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	cbnz	w23, .L1716
	adrp	x1, .LANCHOR8
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	cbz	w1, .L1727
	ldrb	w1, [x0, 8]
	cmp	w1, 1
	bne	.L1727
	ldrh	w21, [x0, 4]
	mov	w23, w1
.L1718:
	adrp	x1, .LANCHOR188
	mov	x19, x0
	mov	w0, -1
	str	w0, [x29, 96]
	ldr	x20, [x1, #:lo12:.LANCHOR188]
	adrp	x0, .LANCHOR183
	str	x20, [x29, 88]
	mov	w1, -3
	ldr	x0, [x0, #:lo12:.LANCHOR183]
	adrp	x22, .LANCHOR160
	str	x0, [x29, 80]
	add	x22, x22, :lo12:.LANCHOR160
	str	w1, [x20, 8]
	mov	w1, -2
	str	w1, [x20, 12]
	ldrh	w1, [x19]
	strh	w1, [x20, 2]
	strh	wzr, [x20]
	mov	w1, 61589
	str	w1, [x0]
	mov	w1, 22136
	movk	w1, 0x1234, lsl 16
	str	w1, [x0, 4]
.L1719:
	sub	w21, w21, #1
	cmn	w21, #1
	beq	.L1722
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1720
.L1722:
	ldrh	w0, [x19]
	adrp	x1, .LANCHOR84
	ldrh	w3, [x19, 4]
	ldr	x2, [x1, #:lo12:.LANCHOR84]
	lsl	x0, x0, 1
	ldrh	w1, [x2, x0]
	sub	w1, w1, w3
	strh	w1, [x2, x0]
	adrp	x0, .LANCHOR53
	strb	wzr, [x19, 6]
	strh	wzr, [x19, 4]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	strh	w0, [x19, 2]
.L1716:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 128
	ret
.L1727:
	mov	w21, 12
	b	.L1718
.L1720:
	mov	x0, x19
	bl	get_new_active_ppa
	str	w0, [x29, 76]
	cmn	w0, #1
	beq	.L1722
	ldr	w0, [x22]
	mov	w3, 0
	str	w0, [x20, 4]
	mov	w2, w23
	add	w0, w0, 1
	mov	w1, 1
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x22]
	add	x0, x29, 72
	bl	FlashProgPages
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	b	.L1719
	.size	FtlSuperblockPowerLostFix, .-FtlSuperblockPowerLostFix
	.section	.text.FtlLoadFactoryBbt,"ax",@progbits
	.align	2
	.global	FtlLoadFactoryBbt
	.type	FtlLoadFactoryBbt, %function
FtlLoadFactoryBbt:
	stp	x29, x30, [sp, -112]!
	adrp	x2, .LANCHOR183
	adrp	x0, .LANCHOR202
	add	x1, x0, :lo12:.LANCHOR202
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR183]
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR51
	stp	x27, x28, [sp, 80]
	add	x28, x26, :lo12:.LANCHOR51
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR75
	stp	x23, x24, [sp, 48]
	add	x20, x20, :lo12:.LANCHOR75
	str	x2, [x1, 8]
	adrp	x2, .LANCHOR188
	adrp	x23, .LANCHOR45
	add	x20, x20, 12
	ldr	x25, [x2, #:lo12:.LANCHOR188]
	add	x23, x23, :lo12:.LANCHOR45
	mov	w21, 0
	mov	w27, -1
	str	x25, [x1, 16]
.L1733:
	ldrh	w0, [x23]
	cmp	w21, w0
	bcc	.L1738
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1738:
	ldrh	w19, [x26, #:lo12:.LANCHOR51]
	add	x24, x22, :lo12:.LANCHOR202
	strh	w27, [x20]
	mov	w3, 61664
	sub	w19, w19, #1
	and	w19, w19, 65535
.L1734:
	ldrh	w0, [x28]
	sub	w1, w0, #15
	cmp	w1, w19
	bgt	.L1736
	madd	w0, w0, w21, w19
	mov	w2, 1
	str	w3, [x29, 108]
	mov	w1, w2
	lsl	w0, w0, 10
	str	w0, [x24, 4]
	mov	x0, x24
	bl	FlashReadPages
	ldr	w0, [x24]
	ldr	w3, [x29, 108]
	cmn	w0, #1
	beq	.L1735
	ldrh	w0, [x25]
	cmp	w0, w3
	bne	.L1735
	strh	w19, [x20]
.L1736:
	add	w21, w21, 1
	add	x20, x20, 2
	b	.L1733
.L1735:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1734
	.size	FtlLoadFactoryBbt, .-FtlLoadFactoryBbt
	.section	.text.FtlGetLastWrittenPage,"ax",@progbits
	.align	2
	.global	FtlGetLastWrittenPage
	.type	FtlGetLastWrittenPage, %function
FtlGetLastWrittenPage:
	stp	x29, x30, [sp, -192]!
	cmp	w1, 1
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	w23, w1
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	bne	.L1744
	adrp	x1, .LANCHOR54
	ldrh	w19, [x1, #:lo12:.LANCHOR54]
.L1745:
	sub	w19, w19, #1
	lsl	w21, w0, 10
	sxth	w19, w19
	add	x1, x29, 128
	orr	w0, w19, w21
	stp	xzr, x1, [x29, 80]
	str	w0, [x29, 76]
	mov	w2, w23
	mov	w1, 1
	add	x0, x29, 72
	bl	FlashReadPages
	ldr	w0, [x29, 128]
	cmn	w0, #1
	bne	.L1746
	mov	w22, 0
	mov	w24, 2
.L1747:
	cmp	w22, w19
	ble	.L1750
.L1746:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 192
	ret
.L1744:
	adrp	x1, .LANCHOR53
	ldrh	w19, [x1, #:lo12:.LANCHOR53]
	b	.L1745
.L1750:
	add	w20, w22, w19
	mov	w2, w23
	mov	w1, 1
	sdiv	w20, w20, w24
	sxth	w0, w20
	orr	w0, w0, w21
	str	w0, [x29, 76]
	add	x0, x29, 72
	bl	FlashReadPages
	ldr	w0, [x29, 128]
	cmn	w0, #1
	bne	.L1748
	ldr	w0, [x29, 132]
	cmn	w0, #1
	bne	.L1748
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L1748
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L1747
.L1748:
	add	w20, w20, 1
	sxth	w22, w20
	b	.L1747
	.size	FtlGetLastWrittenPage, .-FtlGetLastWrittenPage
	.section	.text.FtlLoadBbt,"ax",@progbits
	.align	2
	.global	FtlLoadBbt
	.type	FtlLoadBbt, %function
FtlLoadBbt:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR183
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR51
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR202
	add	x20, x22, :lo12:.LANCHOR202
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	str	x25, [sp, 64]
	mov	w25, 61649
	str	x0, [x20, 8]
	adrp	x0, .LANCHOR188
	ldr	x21, [x0, #:lo12:.LANCHOR188]
	str	x21, [x20, 16]
	bl	FtlBbtMemInit
	ldrh	w19, [x24, #:lo12:.LANCHOR51]
	add	x24, x24, :lo12:.LANCHOR51
	sub	w19, w19, #1
	and	w19, w19, 65535
.L1756:
	ldrh	w0, [x24]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L1759
	lsl	w0, w19, 10
	mov	w2, 1
	str	w0, [x20, 4]
	mov	w1, w2
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L1757
	ldr	w0, [x20, 4]
	mov	w2, 1
	mov	w1, w2
	add	w0, w0, 1
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
.L1757:
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L1758
	ldrh	w0, [x21]
	cmp	w0, w25
	bne	.L1758
	adrp	x1, .LANCHOR75
	add	x0, x1, :lo12:.LANCHOR75
	strh	w19, [x1, #:lo12:.LANCHOR75]
	ldr	w1, [x21, 4]
	str	w1, [x0, 8]
	ldrh	w1, [x21, 8]
	strh	w1, [x0, 4]
.L1759:
	adrp	x19, .LANCHOR75
	mov	w0, 65535
	add	x20, x19, :lo12:.LANCHOR75
	ldrh	w1, [x19, #:lo12:.LANCHOR75]
	cmp	w1, w0
	beq	.L1773
	ldrh	w1, [x20, 4]
	cmp	w1, w0
	beq	.L1763
	add	x0, x22, :lo12:.LANCHOR202
	lsl	w1, w1, 10
	mov	w2, 1
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashReadPages
	ldr	w0, [x22, #:lo12:.LANCHOR202]
	cmn	w0, #1
	beq	.L1763
	ldrh	w1, [x21]
	mov	w0, 61649
	cmp	w1, w0
	bne	.L1763
	ldr	w1, [x20, 8]
	ldr	w0, [x21, 4]
	cmp	w0, w1
	bls	.L1763
	ldrh	w1, [x20, 4]
	str	w0, [x20, 8]
	ldrh	w0, [x21, 8]
	strh	w1, [x19, #:lo12:.LANCHOR75]
	strh	w0, [x20, 4]
.L1763:
	ldrh	w0, [x19, #:lo12:.LANCHOR75]
	add	x24, x19, :lo12:.LANCHOR75
	mov	w1, 1
	mov	w25, 61649
	bl	FtlGetLastWrittenPage
	sxth	w20, w0
	add	w0, w0, 1
	strh	w0, [x24, 2]
	add	x24, x22, :lo12:.LANCHOR202
.L1765:
	tbz	w20, #31, .L1768
	mov	w2, 335
	adrp	x1, .LANCHOR211
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR211
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1767:
	add	x0, x19, :lo12:.LANCHOR75
	ldrh	w1, [x21, 10]
	strh	w1, [x0, 6]
	mov	w1, 65535
	ldrh	w0, [x21, 12]
	cmp	w0, w1
	beq	.L1770
	adrp	x1, .LANCHOR37
	ldr	w2, [x1, #:lo12:.LANCHOR37]
	cmp	w0, w2
	beq	.L1770
	adrp	x1, .LANCHOR41
	ldrh	w1, [x1, #:lo12:.LANCHOR41]
	lsr	w1, w1, 2
	cmp	w2, w1
	bcs	.L1770
	cmp	w0, w1
	bcs	.L1770
	bl	FtlSysBlkNumInit
.L1770:
	add	x19, x19, :lo12:.LANCHOR75
	adrp	x21, .LANCHOR45
	adrp	x23, .LANCHOR123
	add	x19, x19, 32
	add	x21, x21, :lo12:.LANCHOR45
	add	x23, x23, :lo12:.LANCHOR123
	add	x22, x22, :lo12:.LANCHOR202
	mov	w20, 0
.L1771:
	ldrh	w0, [x21]
	cmp	w20, w0
	bcc	.L1772
	mov	w0, 0
.L1755:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1758:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1756
.L1768:
	ldrh	w0, [x19, #:lo12:.LANCHOR75]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w20, w0, lsl 10
	str	w0, [x24, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	str	x0, [x24, 8]
	mov	x0, x24
	bl	FlashReadPages
	ldr	w0, [x24]
	cmn	w0, #1
	beq	.L1766
	ldrh	w0, [x21]
	cmp	w0, w25
	beq	.L1767
.L1766:
	sub	w20, w20, #1
	sxth	w20, w20
	b	.L1765
.L1772:
	ldrh	w2, [x23]
	ldr	x0, [x22, 8]
	mul	w1, w2, w20
	lsl	w2, w2, 2
	add	w20, w20, 1
	add	x1, x0, x1, lsl 2
	ldr	x0, [x19], 8
	bl	ftl_memcpy
	b	.L1771
.L1773:
	mov	w0, -1
	b	.L1755
	.size	FtlLoadBbt, .-FtlLoadBbt
	.section	.text.ftl_map_blk_gc,"ax",@progbits
	.align	2
	.global	ftl_map_blk_gc
	.type	ftl_map_blk_gc, %function
ftl_map_blk_gc:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR54
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	ldr	x20, [x0, 16]
	ldr	x26, [x0, 40]
	bl	ftl_free_no_use_map_blk
	ldrh	w1, [x19, 10]
	ldrh	w2, [x19, 8]
	sub	w1, w1, #4
	cmp	w2, w1
	blt	.L1786
	ubfiz	x0, x0, 1, 16
	ldrh	w21, [x20, x0]
	cbz	w21, .L1786
	ldr	w1, [x19, 52]
	cbnz	w1, .L1786
	mov	w1, 1
	str	w1, [x19, 52]
	strh	wzr, [x20, x0]
	ldrh	w0, [x19, 8]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	ldrh	w0, [x25, #:lo12:.LANCHOR54]
	cmp	w1, w0
	bcc	.L1787
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L1787:
	adrp	x22, .LANCHOR202
	adrp	x24, .LANCHOR212
	mov	x23, x22
	add	x27, x22, :lo12:.LANCHOR202
	add	x24, x24, :lo12:.LANCHOR212
	mov	w20, 0
.L1788:
	ldrh	w0, [x19, 6]
	cmp	w0, w20
	bhi	.L1794
	mov	w1, 1
	mov	w0, w21
	bl	FtlFreeSysBlkQueueIn
	str	wzr, [x19, 52]
.L1786:
	ldrh	w1, [x19, 2]
	ldrh	w0, [x25, #:lo12:.LANCHOR54]
	cmp	w1, w0
	bcc	.L1792
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
	b	.L1792
.L1794:
	ubfiz	x0, x20, 2, 16
	add	x1, x26, x0
	str	x1, [x29, 104]
	ldr	w1, [x26, x0]
	cmp	w21, w1, lsr 10
	bne	.L1789
	adrp	x2, .LANCHOR184
	add	x0, x22, :lo12:.LANCHOR202
	ldr	x2, [x2, #:lo12:.LANCHOR184]
	str	x2, [x0, 8]
	adrp	x2, .LANCHOR188
	str	w1, [x0, 4]
	ldr	x28, [x2, #:lo12:.LANCHOR188]
	mov	w2, 1
	str	x28, [x0, 16]
	mov	w1, w2
	bl	FlashReadPages
	ldrh	w0, [x28, 8]
	cmp	w0, w20
	beq	.L1790
	mov	w2, 661
	mov	x1, x24
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1790:
	ldr	w0, [x27]
	ldrh	w2, [x28, 8]
	cmn	w0, #1
	bne	.L1791
.L1793:
	ldr	x0, [x29, 104]
	add	x23, x23, :lo12:.LANCHOR202
	str	wzr, [x0]
	adrp	x0, .LC39
	add	x0, x0, :lo12:.LC39
	ldr	w1, [x23, 4]
	bl	printf
	adrp	x0, .LANCHOR77
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR77]
.L1792:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1791:
	cmp	w2, w20
	bne	.L1793
	ldrh	w1, [x28]
	ldrh	w0, [x19, 4]
	cmp	w1, w0
	bne	.L1793
	ldr	x2, [x27, 8]
	mov	w1, w20
	mov	x0, x19
	bl	FtlMapWritePage
.L1789:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1788
	.size	ftl_map_blk_gc, .-ftl_map_blk_gc
	.section	.text.Ftl_write_map_blk_to_last_page,"ax",@progbits
	.align	2
	.global	Ftl_write_map_blk_to_last_page
	.type	Ftl_write_map_blk_to_last_page, %function
Ftl_write_map_blk_to_last_page:
	adrp	x1, .LANCHOR77
	ldr	w1, [x1, #:lo12:.LANCHOR77]
	cbnz	w1, .L1810
	stp	x29, x30, [sp, -64]!
	mov	w1, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	ldrh	w0, [x0]
	ldr	x20, [x19, 16]
	str	x23, [sp, 48]
	cmp	w0, w1
	bne	.L1801
	ldrh	w0, [x19, 8]
	cbz	w0, .L1802
	mov	w2, 697
	adrp	x1, .LANCHOR213
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR213
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1802:
	ldrh	w0, [x19, 8]
	add	w0, w0, 1
	strh	w0, [x19, 8]
	bl	FtlFreeSysBlkQueueOut
	strh	w0, [x20]
	ldr	w0, [x19, 48]
	strh	wzr, [x19, 2]
	add	w0, w0, 1
	strh	wzr, [x19]
	str	w0, [x19, 48]
.L1800:
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1801:
	ubfiz	x0, x0, 1, 16
	adrp	x1, .LANCHOR188
	adrp	x23, .LANCHOR183
	ldr	x22, [x19, 40]
	ldr	x1, [x1, #:lo12:.LANCHOR188]
	ldrh	w21, [x20, x0]
	adrp	x20, .LANCHOR202
	ldrh	w0, [x19, 2]
	add	x2, x20, :lo12:.LANCHOR202
	orr	w0, w0, w21, lsl 10
	str	w0, [x2, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	str	x1, [x2, 16]
	str	x0, [x2, 8]
	ldr	w2, [x19, 48]
	str	w2, [x1, 4]
	mov	w2, -1291
	strh	w2, [x1, 8]
	ldrh	w2, [x19, 4]
	strh	w2, [x1]
	strh	w21, [x1, 2]
	adrp	x1, .LANCHOR54
	ldrh	w2, [x1, #:lo12:.LANCHOR54]
	mov	w1, 255
	lsl	w2, w2, 3
	bl	ftl_memset
	ldrh	w4, [x19, 6]
	mov	x1, 0
	ldr	x3, [x23, #:lo12:.LANCHOR183]
	mov	w2, 0
.L1803:
	cmp	w4, w1, uxth
	bhi	.L1805
	mov	w2, 1
	mov	w3, 0
	mov	w1, w2
	add	x0, x20, :lo12:.LANCHOR202
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	x0, x19
	bl	ftl_map_blk_gc
	b	.L1800
.L1805:
	ldr	w0, [x22, x1, lsl 2]
	cmp	w21, w0, lsr 10
	bne	.L1804
	add	w2, w2, 1
	and	w2, w2, 65535
	ubfiz	x0, x2, 1, 16
	str	w1, [x3, x0, lsl 2]
	add	x0, x0, 1
	ldr	w5, [x22, x1, lsl 2]
	str	w5, [x3, x0, lsl 2]
.L1804:
	add	x1, x1, 1
	b	.L1803
.L1810:
	mov	w0, 0
	ret
	.size	Ftl_write_map_blk_to_last_page, .-Ftl_write_map_blk_to_last_page
	.section	.text.FtlMapWritePage,"ax",@progbits
	.align	2
	.global	FtlMapWritePage
	.type	FtlMapWritePage, %function
FtlMapWritePage:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR165
	stp	x23, x24, [sp, 48]
	add	x22, x22, :lo12:.LANCHOR165
	stp	x25, x26, [sp, 64]
	mov	w23, w1
	stp	x27, x28, [sp, 80]
	adrp	x25, .LANCHOR77
	add	x27, x25, :lo12:.LANCHOR77
	stp	x19, x20, [sp, 16]
	adrp	x24, .LANCHOR54
	mov	x19, x0
	mov	w21, 0
	add	x0, x24, :lo12:.LANCHOR54
	stp	x0, x2, [x29, 96]
.L1814:
	ldr	w0, [x22]
	ldrh	w1, [x19, 2]
	add	w0, w0, 1
	str	w0, [x22]
	ldrh	w0, [x24, #:lo12:.LANCHOR54]
	sub	w0, w0, #1
	cmp	w1, w0
	bge	.L1815
	ldrh	w1, [x19]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1816
.L1815:
	mov	x0, x19
	bl	Ftl_write_map_blk_to_last_page
.L1816:
	ldr	w0, [x27]
	cbnz	w0, .L1829
	ldrh	w1, [x19]
	ldr	x0, [x19, 16]
	ldrh	w0, [x0, x1, lsl 1]
	cbnz	w0, .L1818
	mov	w2, 757
	adrp	x1, .LANCHOR214
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR214
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1818:
	ldrh	w1, [x19]
	ldrh	w0, [x19, 10]
	cmp	w1, w0
	bcc	.L1819
	mov	w2, 758
	adrp	x1, .LANCHOR214
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR214
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1819:
	ldrh	w1, [x19]
	adrp	x20, .LANCHOR202
	ldr	x0, [x19, 16]
	add	x28, x20, :lo12:.LANCHOR202
	mov	w2, 16
	ldrh	w26, [x0, x1, lsl 1]
	mov	w1, 0
	ldrh	w0, [x19, 2]
	orr	w0, w0, w26, lsl 10
	str	w0, [x28, 4]
	ldr	x0, [x29, 104]
	str	x0, [x28, 8]
	adrp	x0, .LANCHOR188
	ldr	x0, [x0, #:lo12:.LANCHOR188]
	str	x0, [x28, 16]
	bl	ftl_memset
	ldr	x0, [x28, 16]
	mov	w3, 1
	ldr	w1, [x19, 48]
	mov	w2, w3
	str	w1, [x0, 4]
	ldrh	w1, [x19, 4]
	strh	w1, [x0]
	mov	w1, w3
	strh	w23, [x0, 8]
	strh	w26, [x0, 2]
	mov	x0, x28
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	ldr	w1, [x20, #:lo12:.LANCHOR202]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 2]
	cmn	w1, #1
	bne	.L1820
	ldr	w1, [x28, 4]
	adrp	x0, .LC40
	add	x0, x0, :lo12:.LC40
	add	w21, w21, 1
	and	w21, w21, 65535
	bl	printf
	ldrh	w0, [x19, 2]
	cmp	w0, 2
	bhi	.L1821
	ldr	x0, [x29, 96]
	ldrh	w0, [x0]
	sub	w0, w0, #1
	strh	w0, [x19, 2]
.L1821:
	cmp	w21, 3
	bls	.L1814
	add	x20, x20, :lo12:.LANCHOR202
	mov	w2, w21
	adrp	x0, .LC41
	add	x0, x0, :lo12:.LC41
	ldr	w1, [x20, 4]
	bl	printf
	mov	w0, 1
	str	w0, [x25, #:lo12:.LANCHOR77]
.L1829:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1820:
	cbz	w1, .L1823
	strh	w26, [x19, 60]
	cmp	w0, 1
	bne	.L1824
.L1825:
	str	wzr, [x19, 56]
	b	.L1814
.L1824:
	cmp	w1, 256
.L1835:
	beq	.L1825
	ldr	w0, [x19, 56]
	cbnz	w0, .L1825
	add	x20, x20, :lo12:.LANCHOR202
	ldr	x0, [x19, 40]
	ldr	w1, [x20, 4]
	str	w1, [x0, w23, uxtw 2]
	b	.L1829
.L1823:
	cmp	w0, 1
	b	.L1835
	.size	FtlMapWritePage, .-FtlMapWritePage
	.section	.text.flush_l2p_region,"ax",@progbits
	.align	2
	.global	flush_l2p_region
	.type	flush_l2p_region, %function
flush_l2p_region:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR97
	ubfiz	x19, x0, 4, 16
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	add	x1, x0, x19
	ldr	x2, [x1, 8]
	ldrh	w1, [x0, x19]
	adrp	x0, .LANCHOR127
	add	x0, x0, :lo12:.LANCHOR127
	bl	FtlMapWritePage
	ldr	x0, [x20, #:lo12:.LANCHOR97]
	add	x0, x0, x19
	ldp	x19, x20, [sp, 16]
	ldr	w1, [x0, 4]
	and	w1, w1, 2147483647
	str	w1, [x0, 4]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
	.size	flush_l2p_region, .-flush_l2p_region
	.section	.text.l2p_flush,"ax",@progbits
	.align	2
	.global	l2p_flush
	.type	l2p_flush, %function
l2p_flush:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR68
	add	x20, x20, :lo12:.LANCHOR68
	str	x21, [sp, 32]
	mov	w19, 0
	adrp	x21, .LANCHOR97
.L1839:
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L1841
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1841:
	ldr	x1, [x21, #:lo12:.LANCHOR97]
	ubfiz	x0, x19, 4, 16
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	tbz	w0, #31, .L1840
	mov	w0, w19
	bl	flush_l2p_region
.L1840:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1839
	.size	l2p_flush, .-l2p_flush
	.section	.text.FtlVendorPartWrite,"ax",@progbits
	.align	2
	.global	FtlVendorPartWrite
	.type	FtlVendorPartWrite, %function
FtlVendorPartWrite:
	stp	x29, x30, [sp, -176]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	stp	x21, x22, [sp, 32]
	add	w1, w0, w1
	mov	w22, w0
	adrp	x0, .LANCHOR50
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR50]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cmp	w1, w0
	bhi	.L1851
	adrp	x0, .LANCHOR57
	adrp	x26, .LANCHOR56
	adrp	x27, .LANCHOR58
	mov	x25, x2
	ldrh	w21, [x0, #:lo12:.LANCHOR57]
	add	x26, x26, :lo12:.LANCHOR56
	add	x27, x27, :lo12:.LANCHOR58
	mov	w24, 0
	lsr	w21, w22, w21
.L1845:
	cbnz	w20, .L1850
.L1843:
	mov	w0, w24
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1850:
	ldrh	w1, [x26]
	adrp	x0, .LANCHOR194
	adrp	x28, .LANCHOR185
	ldr	x0, [x0, #:lo12:.LANCHOR194]
	udiv	w23, w22, w1
	ldr	w2, [x0, w21, uxtw 2]
	and	w0, w20, 65535
	msub	w23, w23, w1, w22
	sub	w19, w1, w23
	and	w19, w19, 65535
	cmp	w20, w19
	csel	w19, w0, w19, cc
	cbz	w2, .L1847
	cmp	w19, w1
	beq	.L1847
	ldr	x0, [x28, #:lo12:.LANCHOR185]
	str	w2, [x29, 124]
	mov	w2, 1
	stp	x0, xzr, [x29, 128]
	mov	w1, w2
	add	x0, x29, 120
	bl	FlashReadPages
.L1848:
	lsl	w3, w19, 9
	ldr	x0, [x28, #:lo12:.LANCHOR185]
	lsl	w23, w23, 7
	mov	w2, w3
	mov	x1, x25
	str	w3, [x29, 108]
	add	x0, x0, x23, sxtw 2
	bl	ftl_memcpy
	ldr	x2, [x28, #:lo12:.LANCHOR185]
	mov	w1, w21
	adrp	x0, .LANCHOR215
	add	x0, x0, :lo12:.LANCHOR215
	sub	w20, w20, w19
	add	w22, w22, w19
	add	w21, w21, 1
	bl	FtlMapWritePage
	cmn	w0, #1
	ldr	w3, [x29, 108]
	csinv	w24, w24, wzr, ne
	add	x25, x25, x3, sxtw
	b	.L1845
.L1847:
	ldrh	w2, [x27]
	mov	w1, 0
	ldr	x0, [x28, #:lo12:.LANCHOR185]
	bl	ftl_memset
	b	.L1848
.L1851:
	mov	w24, -1
	b	.L1843
	.size	FtlVendorPartWrite, .-FtlVendorPartWrite
	.section	.text.Ftl_save_ext_data,"ax",@progbits
	.align	2
	.global	Ftl_save_ext_data
	.type	Ftl_save_ext_data, %function
Ftl_save_ext_data:
	adrp	x0, .LANCHOR138
	add	x2, x0, :lo12:.LANCHOR138
	ldr	w1, [x0, #:lo12:.LANCHOR138]
	mov	w0, 19539
	movk	w0, 0x4654, lsl 16
	cmp	w1, w0
	bne	.L1856
	mov	w0, 80
	mov	w1, 1
	movk	w0, 0x5000, lsl 16
	str	w0, [x2, 4]
	adrp	x0, .LANCHOR216
	ldr	w0, [x0, #:lo12:.LANCHOR216]
	str	w0, [x2, 88]
	adrp	x0, .LANCHOR217
	ldr	w0, [x0, #:lo12:.LANCHOR217]
	str	w0, [x2, 92]
	adrp	x0, .LANCHOR161
	ldr	w0, [x0, #:lo12:.LANCHOR161]
	str	w0, [x2, 8]
	adrp	x0, .LANCHOR162
	ldr	w0, [x0, #:lo12:.LANCHOR162]
	str	w0, [x2, 12]
	adrp	x0, .LANCHOR166
	ldr	w0, [x0, #:lo12:.LANCHOR166]
	str	w0, [x2, 16]
	adrp	x0, .LANCHOR165
	ldr	w0, [x0, #:lo12:.LANCHOR165]
	str	w0, [x2, 20]
	adrp	x0, .LANCHOR168
	ldr	w0, [x0, #:lo12:.LANCHOR168]
	str	w0, [x2, 28]
	adrp	x0, .LANCHOR80
	ldr	w0, [x0, #:lo12:.LANCHOR80]
	str	w0, [x2, 32]
	adrp	x0, .LANCHOR163
	ldr	w0, [x0, #:lo12:.LANCHOR163]
	str	w0, [x2, 36]
	adrp	x0, .LANCHOR164
	ldr	w0, [x0, #:lo12:.LANCHOR164]
	str	w0, [x2, 40]
	adrp	x0, .LANCHOR169
	ldr	w0, [x0, #:lo12:.LANCHOR169]
	str	w0, [x2, 44]
	adrp	x0, .LANCHOR170
	ldr	w0, [x0, #:lo12:.LANCHOR170]
	str	w0, [x2, 48]
	adrp	x0, .LANCHOR158
	ldr	w0, [x0, #:lo12:.LANCHOR158]
	str	w0, [x2, 60]
	adrp	x0, .LANCHOR157
	ldr	w0, [x0, #:lo12:.LANCHOR157]
	str	w0, [x2, 64]
	mov	w0, 0
	b	FtlVendorPartWrite
.L1856:
	ret
	.size	Ftl_save_ext_data, .-Ftl_save_ext_data
	.section	.text.FtlEctTblFlush,"ax",@progbits
	.align	2
	.global	FtlEctTblFlush
	.type	FtlEctTblFlush, %function
FtlEctTblFlush:
	adrp	x1, .LANCHOR28
	ldr	w1, [x1, #:lo12:.LANCHOR28]
	cbz	w1, .L1863
	adrp	x1, .LANCHOR170
	mov	w2, 4
	ldr	w1, [x1, #:lo12:.LANCHOR170]
	cmp	w1, 39
	mov	w1, 32
	csel	w1, w1, w2, hi
.L1859:
	adrp	x3, .LANCHOR218
	ldrh	w2, [x3, #:lo12:.LANCHOR218]
	cmp	w2, 31
	bhi	.L1860
	add	w2, w2, 1
	mov	w1, 1
	strh	w2, [x3, #:lo12:.LANCHOR218]
.L1860:
	adrp	x2, .LANCHOR191
	cbnz	w0, .L1861
	ldr	x0, [x2, #:lo12:.LANCHOR191]
	ldr	w3, [x0, 20]
	ldr	w0, [x0, 16]
	add	w1, w1, w3
	cmp	w0, w1
	bcc	.L1866
.L1861:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR191]
	ldr	w0, [x2, 16]
	str	w0, [x2, 20]
	mov	w0, 17221
	str	wzr, [x2, 4]
	movk	w0, 0x4254, lsl 16
	str	w0, [x2]
	adrp	x0, .LANCHOR190
	ldrh	w1, [x0, #:lo12:.LANCHOR190]
	lsl	w0, w1, 9
	str	w0, [x2, 12]
	ldr	w0, [x2, 8]
	add	w0, w0, 1
	str	w0, [x2, 8]
	mov	w0, 64
	bl	FtlVendorPartWrite
	bl	Ftl_save_ext_data
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L1863:
	mov	w1, 32
	b	.L1859
.L1866:
	mov	w0, 0
	ret
	.size	FtlEctTblFlush, .-FtlEctTblFlush
	.section	.text.allocate_new_data_superblock,"ax",@progbits
	.align	2
	.global	allocate_new_data_superblock
	.type	allocate_new_data_superblock, %function
allocate_new_data_superblock:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w20, [x0]
	adrp	x0, .LANCHOR40
	str	x21, [sp, 32]
	ldrh	w0, [x0, #:lo12:.LANCHOR40]
	cmp	w0, w20
	bcs	.L1869
	mov	w2, 3233
	adrp	x1, .LANCHOR219
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR219
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1869:
	adrp	x0, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	cbnz	w0, .L1870
	mov	w0, 65535
	cmp	w20, w0
	beq	.L1871
	adrp	x1, .LANCHOR84
	ubfiz	x0, x20, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR84]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1872
	mov	w0, w20
	bl	INSERT_DATA_LIST
.L1871:
	strb	wzr, [x19, 8]
	adrp	x0, .LANCHOR93
	add	x0, x0, :lo12:.LANCHOR93
	cmp	x19, x0
	beq	.L1873
	adrp	x0, .LANCHOR44
	ldrh	w1, [x0, #:lo12:.LANCHOR44]
	cmp	w1, 1
	beq	.L1873
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L1874
.L1873:
	mov	w0, 1
	strb	w0, [x19, 8]
.L1875:
	adrp	x1, .LANCHOR133
	mov	w2, 65535
	mov	x21, x1
	ldrh	w0, [x1, #:lo12:.LANCHOR133]
	cmp	w0, w2
	beq	.L1880
	cmp	w20, w0
	bne	.L1881
	adrp	x2, .LANCHOR84
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR84]
	ldrh	w1, [x2, x1]
	cbz	w1, .L1882
.L1881:
	bl	update_vpc_list
.L1882:
	mov	w0, -1
	strh	w0, [x21, #:lo12:.LANCHOR133]
.L1880:
	mov	x0, x19
	bl	allocate_data_superblock
	bl	l2p_flush
	mov	w0, 0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1870:
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1872:
	mov	w0, w20
	bl	INSERT_FREE_LIST
	b	.L1871
.L1874:
	adrp	x0, .LANCHOR92
	add	x2, x0, :lo12:.LANCHOR92
	cmp	x19, x2
	bne	.L1875
	cmp	w1, 3
	beq	.L1877
	adrp	x1, .LANCHOR158
	ldr	w1, [x1, #:lo12:.LANCHOR158]
	cmp	w1, 1
	bne	.L1878
.L1877:
	add	x1, x0, :lo12:.LANCHOR92
	mov	w2, 1
	strb	w2, [x1, 8]
.L1878:
	adrp	x1, .LANCHOR28
	ldr	w1, [x1, #:lo12:.LANCHOR28]
	cbz	w1, .L1875
	adrp	x1, .LANCHOR170
	ldr	w1, [x1, #:lo12:.LANCHOR170]
	cmp	w1, 39
	bhi	.L1875
	add	x0, x0, :lo12:.LANCHOR92
	mov	w1, 1
	strb	w1, [x0, 8]
	b	.L1875
	.size	allocate_new_data_superblock, .-allocate_new_data_superblock
	.section	.text.FtlVendorPartRead,"ax",@progbits
	.align	2
	.global	FtlVendorPartRead
	.type	FtlVendorPartRead, %function
FtlVendorPartRead:
	stp	x29, x30, [sp, -176]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	w22, w0
	mov	w21, w1
	add	w1, w0, w1
	adrp	x0, .LANCHOR50
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR50]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cmp	w1, w0
	bhi	.L1905
	adrp	x0, .LANCHOR57
	adrp	x26, .LANCHOR185
	mov	x25, x2
	mov	x28, x26
	ldrh	w20, [x0, #:lo12:.LANCHOR57]
	mov	w24, 0
	adrp	x0, .LANCHOR56
	add	x0, x0, :lo12:.LANCHOR56
	str	x0, [x29, 104]
	lsr	w20, w22, w20
.L1898:
	cbnz	w21, .L1904
.L1896:
	mov	w0, w24
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1904:
	adrp	x0, .LANCHOR194
	ldr	x0, [x0, #:lo12:.LANCHOR194]
	ldr	w3, [x0, w20, uxtw 2]
	ldr	x0, [x29, 104]
	ldrh	w19, [x0]
	and	w0, w21, 65535
	udiv	w23, w22, w19
	msub	w23, w23, w19, w22
	sub	w19, w19, w23
	and	w19, w19, 65535
	cmp	w21, w19
	csel	w19, w0, w19, cc
	lsl	w27, w19, 9
	cbz	w3, .L1900
	ldr	x0, [x26, #:lo12:.LANCHOR185]
	mov	w2, 1
	str	w3, [x29, 100]
	mov	w1, w2
	str	w3, [x29, 124]
	stp	x0, xzr, [x29, 128]
	add	x0, x29, 120
	bl	FlashReadPages
	ldr	w0, [x29, 120]
	ldr	w3, [x29, 100]
	cmn	w0, #1
	adrp	x0, .LANCHOR202
	csinv	w24, w24, wzr, ne
	ldr	w0, [x0, #:lo12:.LANCHOR202]
	cmp	w0, 256
	bne	.L1902
	mov	w2, w3
	mov	w1, w20
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	printf
	ldr	x2, [x26, #:lo12:.LANCHOR185]
	adrp	x0, .LANCHOR215
	mov	w1, w20
	add	x0, x0, :lo12:.LANCHOR215
	bl	FtlMapWritePage
.L1902:
	ldr	x1, [x28, #:lo12:.LANCHOR185]
	lsl	w23, w23, 7
	mov	w2, w27
	mov	x0, x25
	add	x1, x1, x23, sxtw 2
	bl	ftl_memcpy
.L1903:
	add	w20, w20, 1
	sub	w21, w21, w19
	add	w22, w22, w19
	add	x25, x25, x27, sxtw
	b	.L1898
.L1900:
	mov	w2, w27
	mov	w1, 0
	mov	x0, x25
	bl	ftl_memset
	b	.L1903
.L1905:
	mov	w24, -1
	b	.L1896
	.size	FtlVendorPartRead, .-FtlVendorPartRead
	.section	.text.FtlLoadEctTbl,"ax",@progbits
	.align	2
	.global	FtlLoadEctTbl
	.type	FtlLoadEctTbl, %function
FtlLoadEctTbl:
	stp	x29, x30, [sp, -32]!
	mov	w0, 64
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR191
	adrp	x20, .LANCHOR190
	ldr	x2, [x19, #:lo12:.LANCHOR191]
	ldrh	w1, [x20, #:lo12:.LANCHOR190]
	bl	FtlVendorPartRead
	ldr	x0, [x19, #:lo12:.LANCHOR191]
	ldr	w1, [x0]
	mov	w0, 17221
	movk	w0, 0x4254, lsl 16
	cmp	w1, w0
	beq	.L1908
	adrp	x1, .LC43
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC43
	add	x0, x0, :lo12:.LC7
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR191]
	mov	w1, 0
	ldrh	w2, [x20, #:lo12:.LANCHOR190]
	lsl	w2, w2, 9
	bl	ftl_memset
.L1908:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FtlLoadEctTbl, .-FtlLoadEctTbl
	.section	.text.Ftl_load_ext_data,"ax",@progbits
	.align	2
	.global	Ftl_load_ext_data
	.type	Ftl_load_ext_data, %function
Ftl_load_ext_data:
	stp	x29, x30, [sp, -48]!
	mov	w1, 1
	mov	w0, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR138
	str	x21, [sp, 32]
	add	x21, x19, :lo12:.LANCHOR138
	mov	x2, x21
	bl	FtlVendorPartRead
	ldr	w0, [x19, #:lo12:.LANCHOR138]
	mov	w20, 19539
	movk	w20, 0x4654, lsl 16
	cmp	w0, w20
	beq	.L1911
	mov	w2, 512
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	str	w20, [x19, #:lo12:.LANCHOR138]
.L1911:
	ldr	w1, [x19, #:lo12:.LANCHOR138]
	add	x0, x19, :lo12:.LANCHOR138
	cmp	w1, w20
	adrp	x20, .LANCHOR168
	bne	.L1912
	adrp	x1, .LANCHOR216
	ldr	w2, [x0, 88]
	str	w2, [x1, #:lo12:.LANCHOR216]
	adrp	x1, .LANCHOR217
	ldr	w2, [x0, 92]
	str	w2, [x1, #:lo12:.LANCHOR217]
	adrp	x1, .LANCHOR161
	ldr	w2, [x0, 8]
	str	w2, [x1, #:lo12:.LANCHOR161]
	adrp	x1, .LANCHOR162
	ldr	w2, [x0, 12]
	str	w2, [x1, #:lo12:.LANCHOR162]
	adrp	x1, .LANCHOR166
	ldr	w2, [x0, 16]
	str	w2, [x1, #:lo12:.LANCHOR166]
	adrp	x1, .LANCHOR165
	ldr	w2, [x0, 20]
	str	w2, [x1, #:lo12:.LANCHOR165]
	ldp	w1, w2, [x0, 28]
	str	w1, [x20, #:lo12:.LANCHOR168]
	adrp	x1, .LANCHOR80
	str	w2, [x1, #:lo12:.LANCHOR80]
	adrp	x1, .LANCHOR163
	ldr	w2, [x0, 36]
	str	w2, [x1, #:lo12:.LANCHOR163]
	adrp	x1, .LANCHOR164
	ldr	w2, [x0, 40]
	str	w2, [x1, #:lo12:.LANCHOR164]
	adrp	x1, .LANCHOR169
	ldr	w2, [x0, 44]
	str	w2, [x1, #:lo12:.LANCHOR169]
	adrp	x1, .LANCHOR170
	ldr	w2, [x0, 48]
	str	w2, [x1, #:lo12:.LANCHOR170]
	ldr	w1, [x0, 60]
	adrp	x0, .LANCHOR158
	str	w1, [x0, #:lo12:.LANCHOR158]
.L1912:
	add	x19, x19, :lo12:.LANCHOR138
	adrp	x0, .LANCHOR157
	str	wzr, [x0, #:lo12:.LANCHOR157]
	mov	w0, 34661
	ldr	w1, [x19, 68]
	movk	w0, 0x1234, lsl 16
	cmp	w1, w0
	bne	.L1913
	adrp	x0, .LANCHOR28
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR28]
	adrp	x1, .LC44
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC44
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1913:
	adrp	x1, .LANCHOR167
	adrp	x0, .LANCHOR48
	ldr	x21, [sp, 32]
	ldr	w2, [x1, #:lo12:.LANCHOR167]
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	ldr	w1, [x20, #:lo12:.LANCHOR168]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	madd	w0, w0, w2, w1
	adrp	x1, .LANCHOR40
	ldrh	w1, [x1, #:lo12:.LANCHOR40]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR205
	str	w0, [x1, #:lo12:.LANCHOR205]
	ret
	.size	Ftl_load_ext_data, .-Ftl_load_ext_data
	.section	.text.ftl_vendor_read,"ax",@progbits
	.align	2
	.global	ftl_vendor_read
	.type	ftl_vendor_read, %function
ftl_vendor_read:
	add	w0, w0, 256
	b	FtlVendorPartRead
	.size	ftl_vendor_read, .-ftl_vendor_read
	.section	.text.ftl_sys_read,"ax",@progbits
	.align	2
	.global	ftl_sys_read
	.type	ftl_sys_read, %function
ftl_sys_read:
	add	w0, w0, 512
	b	FtlVendorPartRead
	.size	ftl_sys_read, .-ftl_sys_read
	.section	.text.FtlMapBlkWriteDumpData,"ax",@progbits
	.align	2
	.global	FtlMapBlkWriteDumpData
	.type	FtlMapBlkWriteDumpData, %function
FtlMapBlkWriteDumpData:
	ldr	w1, [x0, 56]
	cbz	w1, .L1931
	stp	x29, x30, [sp, -80]!
	adrp	x1, .LANCHOR77
	add	x29, sp, 0
	ldr	w1, [x1, #:lo12:.LANCHOR77]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldrh	w20, [x0, 6]
	str	x25, [sp, 64]
	str	wzr, [x0, 56]
	ldr	x25, [x0, 40]
	cbnz	w1, .L1917
	mov	x19, x0
	adrp	x0, .LANCHOR184
	adrp	x23, .LANCHOR202
	add	x21, x23, :lo12:.LANCHOR202
	ldr	x0, [x0, #:lo12:.LANCHOR184]
	mov	x22, x23
	str	x0, [x21, 8]
	adrp	x0, .LANCHOR188
	ldr	x24, [x0, #:lo12:.LANCHOR188]
	ldrh	w0, [x19, 2]
	str	x24, [x21, 16]
	cbz	w0, .L1921
	adrp	x1, .LANCHOR54
	ldrh	w1, [x1, #:lo12:.LANCHOR54]
	sub	w1, w1, #1
	cmp	w0, w1
	bge	.L1921
	ldrh	w1, [x19]
	mov	w2, 65535
	cmp	w1, w2
	beq	.L1921
	ldr	x2, [x19, 16]
	ubfiz	x1, x1, 1, 16
	sub	w0, w0, #1
	ldrh	w1, [x2, x1]
	mov	w2, 1
	orr	w0, w0, w1, lsl 10
	mov	w1, w2
	str	w0, [x21, 4]
	mov	x0, x21
	bl	FlashReadPages
	ldr	w0, [x23, #:lo12:.LANCHOR202]
	cmn	w0, #1
	beq	.L1921
	ldrh	w1, [x24, 8]
	ldr	x2, [x19, 40]
	ubfiz	x0, x1, 2, 16
	ldr	w2, [x2, x0]
	ldr	w0, [x21, 4]
	cmp	w2, w0
	bne	.L1921
	ldr	x2, [x21, 8]
.L1934:
	mov	x0, x19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	b	FtlMapWritePage
.L1921:
	sub	w20, w20, #1
	and	w20, w20, 65535
	ubfiz	x0, x20, 2, 16
	ldr	w1, [x25, x0]
	add	x0, x22, :lo12:.LANCHOR202
	str	w1, [x0, 4]
	cbz	w1, .L1922
	mov	w2, 1
	mov	w1, w2
	bl	FlashReadPages
.L1923:
	add	x22, x22, :lo12:.LANCHOR202
	mov	w1, w20
	ldr	x2, [x22, 8]
	b	.L1934
.L1922:
	adrp	x1, .LANCHOR58
	ldr	x0, [x0, 8]
	ldrh	w2, [x1, #:lo12:.LANCHOR58]
	mov	w1, 255
	bl	ftl_memset
	b	.L1923
.L1917:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1931:
	ret
	.size	FtlMapBlkWriteDumpData, .-FtlMapBlkWriteDumpData
	.section	.text.FtlScanSysBlk,"ax",@progbits
	.align	2
	.global	FtlScanSysBlk
	.type	FtlScanSysBlk, %function
FtlScanSysBlk:
	stp	x29, x30, [sp, -176]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR130
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR65
	ldr	x0, [x25, #:lo12:.LANCHOR130]
	adrp	x22, .LANCHOR193
	ldr	w2, [x21, #:lo12:.LANCHOR65]
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR128
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR71
	stp	x27, x28, [sp, 80]
	adrp	x27, .LANCHOR129
	lsl	w2, w2, 2
	strh	wzr, [x20, #:lo12:.LANCHOR128]
	strh	wzr, [x23, #:lo12:.LANCHOR71]
	bl	ftl_memset
	ldr	x0, [x27, #:lo12:.LANCHOR129]
	mov	w1, 0
	ldr	w2, [x21, #:lo12:.LANCHOR65]
	adrp	x19, .LANCHOR62
	adrp	x28, .LANCHOR72
	adrp	x24, .LANCHOR209
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR193]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR62]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldr	x0, [x28, #:lo12:.LANCHOR72]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR62]
	lsl	w2, w2, 1
	bl	ftl_memset
	mov	w2, 12
	mov	w1, 255
	add	x0, x24, :lo12:.LANCHOR209
	bl	ftl_memset
	adrp	x0, .LANCHOR40
	stp	x22, x25, [x29, 144]
	str	x27, [x29, 160]
	ldrh	w0, [x0, #:lo12:.LANCHOR40]
	str	w0, [x29, 172]
	adrp	x0, .LANCHOR41
	add	x0, x0, :lo12:.LANCHOR41
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR159
	add	x0, x0, :lo12:.LANCHOR159
	str	x0, [x29, 112]
.L1936:
	ldr	x0, [x29, 120]
	ldr	w1, [x29, 172]
	ldrh	w0, [x0]
	cmp	w0, w1
	bls	.L1977
	adrp	x0, .LANCHOR38
	adrp	x25, .LANCHOR180
	adrp	x6, .LANCHOR47
	mov	x5, 0
	ldrh	w13, [x0, #:lo12:.LANCHOR38]
	adrp	x0, .LANCHOR105
	ldr	x7, [x25, #:lo12:.LANCHOR180]
	mov	w22, 0
	ldr	x12, [x0, #:lo12:.LANCHOR105]
	adrp	x0, .LANCHOR106
	add	x6, x6, :lo12:.LANCHOR47
	mov	w8, 56
	ldr	x11, [x0, #:lo12:.LANCHOR106]
	adrp	x0, .LANCHOR59
	ldrh	w10, [x0, #:lo12:.LANCHOR59]
	b	.L1978
.L1938:
	ldrh	w1, [x29, 172]
	ldrb	w0, [x6, x5]
	bl	V2P_block
	and	w4, w0, 65535
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L1937
	umaddl	x1, w22, w8, x7
	lsl	w4, w4, 10
	mul	w0, w22, w10
	add	w22, w22, 1
	and	w22, w22, 65535
	asr	w0, w0, 2
	str	w4, [x1, 4]
	add	x0, x11, x0, sxtw 2
	stp	x12, x0, [x1, 8]
.L1937:
	add	x5, x5, 1
.L1978:
	cmp	w13, w5, uxth
	bhi	.L1938
	cbnz	w22, .L1939
.L1976:
	ldr	w0, [x29, 172]
	add	w26, w0, 1
	and	w0, w26, 65535
	str	w0, [x29, 172]
	b	.L1936
.L1939:
	mov	w1, w22
	mov	w2, 1
	mov	x0, x7
	bl	FlashReadPages
	mov	w0, 56
	umull	x0, w22, w0
	mov	x22, 0
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR220
	add	x0, x0, :lo12:.LANCHOR220
	str	x0, [x29, 136]
.L1975:
	ldr	x0, [x25, #:lo12:.LANCHOR180]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	ldr	w3, [x1, 4]
	cmn	w0, #1
	ldr	x27, [x1, 16]
	ubfx	x26, x3, 10, 16
	bne	.L1942
	mov	w5, 16
	mov	w7, 65535
.L1944:
	ldr	x0, [x25, #:lo12:.LANCHOR180]
	add	x6, x25, :lo12:.LANCHOR180
	mov	w2, 1
	str	w7, [x29, 100]
	add	x0, x0, x22
	str	x6, [x29, 104]
	str	w5, [x29, 168]
	ldr	w1, [x0, 4]
	add	w1, w1, 1
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashReadPages
	ldrh	w0, [x27]
	ldr	w7, [x29, 100]
	ldr	w5, [x29, 168]
	cmp	w0, w7
	ldr	x6, [x29, 104]
	bne	.L1941
	ldr	x0, [x6]
	mov	w1, -1
	str	w1, [x0, x22]
	ldr	x0, [x6]
	ldr	w0, [x0, x22]
	cmp	w0, w1
	beq	.L2014
.L1942:
	adrp	x0, .LANCHOR159
	ldr	w1, [x0, #:lo12:.LANCHOR159]
	ldr	w0, [x27, 4]
	cmn	w1, #1
	beq	.L1945
	cmp	w1, w0
	bhi	.L1946
.L1945:
	cmn	w0, #1
	beq	.L1946
	ldr	x2, [x29, 112]
	add	w1, w0, 1
	str	w1, [x2]
.L1946:
	ldrh	w1, [x27]
	mov	w2, 61604
	cmp	w1, w2
	beq	.L1948
	bhi	.L1949
	mov	w0, 61574
	cmp	w1, w0
	beq	.L1950
.L1947:
	ldr	x0, [x29, 128]
	add	x22, x22, 56
	cmp	x0, x22
	bne	.L1975
	b	.L1976
.L1941:
	ldr	x0, [x25, #:lo12:.LANCHOR180]
	ldr	w0, [x0, x22]
	cmn	w0, #1
	bne	.L1942
	sub	w5, w5, #1
	ands	w5, w5, 65535
	bne	.L1944
.L2014:
	mov	w1, 0
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
	b	.L1947
.L1949:
	mov	w0, 61634
	cmp	w1, w0
	beq	.L1951
	mov	w0, 65535
	cmp	w1, w0
	beq	.L2014
	b	.L1947
.L1951:
	ldrh	w1, [x20, #:lo12:.LANCHOR128]
	ldr	w0, [x21, #:lo12:.LANCHOR65]
	cmp	w1, w0
	bls	.L1953
	ldr	x1, [x29, 136]
	mov	w2, 1297
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1953:
	ldr	w6, [x21, #:lo12:.LANCHOR65]
	ldr	x3, [x29, 152]
	ldrh	w1, [x20, #:lo12:.LANCHOR128]
	and	w2, w6, 65535
	sub	w0, w2, #1
	sub	w2, w2, w1
	sxth	x0, w0
	sub	w2, w2, #1
	ldr	x5, [x3, #:lo12:.LANCHOR130]
	sxth	w2, w2
.L1954:
	cmp	w0, w2
	bgt	.L1960
	tbz	w0, #31, .L1995
	b	.L1947
.L1960:
	sxtw	x8, w0
	ldr	w11, [x27, 4]
	lsl	x7, x8, 2
	add	x10, x5, x7
	ldr	w7, [x5, x7]
	cmp	w11, w7
	bls	.L1955
	ldr	w2, [x5]
	cbnz	w2, .L1956
	cmp	w6, w1
	beq	.L1956
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR128]
.L1956:
	ldr	x1, [x29, 160]
	ldr	x6, [x1, #:lo12:.LANCHOR129]
	mov	w1, 0
.L1957:
	cmp	w1, w0
	bne	.L1958
	ldr	w1, [x27, 4]
	str	w1, [x10]
	strh	w26, [x6, x8, lsl 1]
	tbnz	w0, #31, .L1947
	ldrh	w1, [x20, #:lo12:.LANCHOR128]
	ldr	w2, [x21, #:lo12:.LANCHOR65]
	sub	w2, w2, w1
	sub	w2, w2, #1
	cmp	w0, w2, sxth
	bgt	.L1947
.L1995:
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR128]
	ldr	w1, [x27, 4]
	str	w1, [x5, x0, lsl 2]
	ldr	x1, [x29, 160]
	ldr	x1, [x1, #:lo12:.LANCHOR129]
.L2013:
	strh	w26, [x1, x0, lsl 1]
	b	.L1947
.L1958:
	sxtw	x2, w1
	add	w1, w1, 1
	lsl	x7, x2, 2
	lsl	x2, x2, 1
	add	x11, x5, x7
	sxth	w1, w1
	ldr	w11, [x11, 4]
	str	w11, [x5, x7]
	add	x7, x6, x2
	ldrh	w7, [x7, 2]
	strh	w7, [x6, x2]
	b	.L1957
.L1955:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L1954
.L1950:
	ldrh	w1, [x23, #:lo12:.LANCHOR71]
	ldrh	w0, [x19, #:lo12:.LANCHOR62]
	cmp	w1, w0
	bls	.L1963
	ldr	x1, [x29, 136]
	mov	w2, 1344
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1963:
	ldrh	w6, [x19, #:lo12:.LANCHOR62]
	ldrh	w2, [x23, #:lo12:.LANCHOR71]
	sub	w1, w6, #1
	sxth	x0, w1
	sub	w5, w1, w2
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR193]
.L1964:
	cmp	w0, w5
	ble	.L1969
	sxtw	x7, w0
	ldr	w11, [x27, 4]
	lsl	x8, x7, 2
	add	x10, x1, x8
	ldr	w8, [x1, x8]
	cmp	w11, w8
	bls	.L1965
	ldr	w5, [x1]
	cbnz	w5, .L1966
	cmp	w6, w2
	beq	.L1966
	add	w2, w2, 1
	strh	w2, [x23, #:lo12:.LANCHOR71]
.L1966:
	ldr	x6, [x28, #:lo12:.LANCHOR72]
	mov	w2, 0
.L1967:
	cmp	w2, w0
	bne	.L1968
	ldr	w2, [x27, 4]
	str	w2, [x10]
	strh	w26, [x6, x7, lsl 1]
.L1969:
	tbnz	w0, #31, .L1947
	ldrh	w2, [x19, #:lo12:.LANCHOR62]
	ldrh	w5, [x23, #:lo12:.LANCHOR71]
	sub	w2, w2, #1
	sub	w2, w2, w5
	cmp	w0, w2, sxth
	bgt	.L1947
	add	w5, w5, 1
	ldr	w2, [x27, 4]
	strh	w5, [x23, #:lo12:.LANCHOR71]
	str	w2, [x1, x0, lsl 2]
	ldr	x1, [x28, #:lo12:.LANCHOR72]
	b	.L2013
.L1968:
	sxtw	x5, w2
	add	w2, w2, 1
	lsl	x8, x5, 2
	lsl	x5, x5, 1
	add	x11, x1, x8
	sxth	w2, w2
	ldr	w11, [x11, 4]
	str	w11, [x1, x8]
	add	x8, x6, x5
	ldrh	w8, [x8, 2]
	strh	w8, [x6, x5]
	b	.L1967
.L1965:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L1964
.L1948:
	ldrh	w5, [x24, #:lo12:.LANCHOR209]
	mov	w1, 65535
	add	x2, x24, :lo12:.LANCHOR209
	cmp	w5, w1
	bne	.L1971
	strh	w26, [x24, #:lo12:.LANCHOR209]
	str	w0, [x2, 8]
	b	.L1947
.L1971:
	ldrh	w0, [x2, 4]
	cmp	w0, w1
	beq	.L1972
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
.L1972:
	add	x0, x24, :lo12:.LANCHOR209
	ldr	w1, [x27, 4]
	ldr	w2, [x0, 8]
	cmp	w2, w1
	bcs	.L1973
	ldrh	w2, [x24, #:lo12:.LANCHOR209]
	strh	w2, [x0, 4]
	strh	w26, [x24, #:lo12:.LANCHOR209]
	str	w1, [x0, 8]
	b	.L1947
.L1973:
	strh	w26, [x0, 4]
	b	.L1947
.L1977:
	ldr	x0, [x29, 160]
	ldr	x2, [x0, #:lo12:.LANCHOR129]
	ldrh	w0, [x2]
	cbz	w0, .L1979
.L1982:
	ldr	x1, [x28, #:lo12:.LANCHOR72]
	ldrh	w0, [x1]
	cbz	w0, .L1980
.L1981:
	ldrh	w1, [x20, #:lo12:.LANCHOR128]
	ldr	w0, [x21, #:lo12:.LANCHOR65]
	cmp	w1, w0
	bls	.L2011
	mov	w2, 1478
	adrp	x1, .LANCHOR220
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR220
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2011:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1979:
	ldrh	w0, [x20, #:lo12:.LANCHOR128]
	cbz	w0, .L1982
	ldr	w1, [x21, #:lo12:.LANCHOR65]
	mov	w0, 0
.L1983:
	cmp	w0, w1
	bcs	.L1982
	ldrh	w3, [x2, w0, sxtw 1]
	cbz	w3, .L1984
	ldr	x1, [x29, 152]
	add	x7, x21, :lo12:.LANCHOR65
	ldr	x4, [x1, #:lo12:.LANCHOR130]
	mov	w1, w0
.L1985:
	ldr	w3, [x7]
	cmp	w1, w3
	bcs	.L1982
	sxtw	x6, w1
	sub	w3, w1, w0
	lsl	x5, x6, 1
	sxtw	x3, w3
	add	w1, w1, 1
	ldr	w6, [x4, x6, lsl 2]
	sxth	w1, w1
	ldrh	w8, [x2, x5]
	strh	w8, [x2, x3, lsl 1]
	str	w6, [x4, x3, lsl 2]
	strh	wzr, [x2, x5]
	b	.L1985
.L1984:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L1983
.L1980:
	ldrh	w0, [x23, #:lo12:.LANCHOR71]
	cbz	w0, .L1981
	ldrh	w2, [x19, #:lo12:.LANCHOR62]
	mov	w0, 0
.L1990:
	mov	w6, w0
	cmp	w0, w2
	bge	.L1981
	ldrh	w3, [x1, w0, sxtw 1]
	cbz	w3, .L1991
	ldr	x2, [x29, 144]
	add	x19, x19, :lo12:.LANCHOR62
	ldr	x3, [x2, #:lo12:.LANCHOR193]
.L1992:
	ldrh	w2, [x19]
	cmp	w0, w2
	bge	.L1981
	sxtw	x5, w0
	sub	w2, w0, w6
	lsl	x4, x5, 1
	sxtw	x2, w2
	add	w0, w0, 1
	ldr	w5, [x3, x5, lsl 2]
	sxth	w0, w0
	ldrh	w7, [x1, x4]
	strh	w7, [x1, x2, lsl 1]
	str	w5, [x3, x2, lsl 2]
	strh	wzr, [x1, x4]
	b	.L1992
.L1991:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L1990
	.size	FtlScanSysBlk, .-FtlScanSysBlk
	.section	.text.FtlLoadSysInfo,"ax",@progbits
	.align	2
	.global	FtlLoadSysInfo
	.type	FtlLoadSysInfo, %function
FtlLoadSysInfo:
	stp	x29, x30, [sp, -96]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR202
	stp	x23, x24, [sp, 48]
	add	x20, x19, :lo12:.LANCHOR202
	adrp	x24, .LANCHOR183
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR188
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	adrp	x25, .LANCHOR84
	ldr	x0, [x24, #:lo12:.LANCHOR183]
	adrp	x22, .LANCHOR40
	str	x0, [x20, 8]
	adrp	x21, .LANCHOR209
	ldr	x0, [x26, #:lo12:.LANCHOR188]
	str	x0, [x20, 16]
	ldr	x0, [x25, #:lo12:.LANCHOR84]
	ldrh	w2, [x22, #:lo12:.LANCHOR40]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w0, [x21, #:lo12:.LANCHOR209]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L2016
.L2025:
	mov	w0, -1
.L2015:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2016:
	add	x27, x21, :lo12:.LANCHOR209
	mov	w1, 1
	bl	FtlGetLastWrittenPage
	sxth	w23, w0
	add	w0, w0, 1
	mov	w28, 61604
	strh	w0, [x27, 2]
	mov	w27, 19539
	movk	w27, 0x4654, lsl 16
.L2018:
	tbz	w23, #31, .L2021
	mov	w2, 1538
	adrp	x1, .LANCHOR221
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR221
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2020:
	adrp	x1, .LANCHOR58
	ldrh	w0, [x22, #:lo12:.LANCHOR40]
	ldrh	w1, [x1, #:lo12:.LANCHOR58]
	add	x0, x0, 24
	cmp	x1, x0, lsl 1
	bcs	.L2023
	mov	w2, 1540
	adrp	x1, .LANCHOR221
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR221
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2023:
	add	x19, x19, :lo12:.LANCHOR202
	mov	w2, 48
	adrp	x20, .LANCHOR81
	add	x0, x20, :lo12:.LANCHOR81
	ldr	x1, [x19, 8]
	bl	ftl_memcpy
	ldr	x0, [x25, #:lo12:.LANCHOR84]
	ldrh	w2, [x22, #:lo12:.LANCHOR40]
	ldr	x1, [x19, 8]
	lsl	w2, w2, 1
	add	x1, x1, 48
	bl	ftl_memcpy
	ldrh	w1, [x22, #:lo12:.LANCHOR40]
	ldr	x0, [x19, 8]
	lsr	w2, w1, 3
	ubfiz	x1, x1, 1, 16
	add	x1, x1, 48
	add	w2, w2, 4
	and	x1, x1, -4
	add	x1, x0, x1
	adrp	x0, .LANCHOR0
	ldr	x0, [x0, #:lo12:.LANCHOR0]
	bl	ftl_memcpy
	adrp	x0, .LANCHOR70
	ldrh	w0, [x0, #:lo12:.LANCHOR70]
	cbz	w0, .L2024
	ldrh	w1, [x22, #:lo12:.LANCHOR40]
	adrp	x0, .LANCHOR67
	ldrh	w2, [x0, #:lo12:.LANCHOR67]
	lsr	w0, w1, 3
	add	w1, w0, w1, lsl 1
	ldr	x0, [x19, 8]
	add	w1, w1, 52
	lsl	w2, w2, 2
	and	x1, x1, 65532
	add	x1, x0, x1
	adrp	x0, .LANCHOR195
	ldr	x0, [x0, #:lo12:.LANCHOR195]
	bl	ftl_memcpy
.L2024:
	ldr	w2, [x20, #:lo12:.LANCHOR81]
	mov	w1, 19539
	movk	w1, 0x4654, lsl 16
	add	x0, x20, :lo12:.LANCHOR81
	cmp	w2, w1
	bne	.L2025
	add	x21, x21, :lo12:.LANCHOR209
	ldrh	w1, [x0, 8]
	ldrb	w2, [x0, 10]
	adrp	x0, .LANCHOR45
	strh	w1, [x21, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR45]
	cmp	w2, w0
	bne	.L2025
	adrp	x0, .LANCHOR222
	adrp	x2, .LANCHOR73
	adrp	x3, .LANCHOR38
	str	w1, [x0, #:lo12:.LANCHOR222]
	adrp	x0, .LANCHOR53
	ldrh	w3, [x3, #:lo12:.LANCHOR38]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	mul	w0, w0, w1
	str	w0, [x2, #:lo12:.LANCHOR73]
	adrp	x2, .LANCHOR56
	ldrh	w2, [x2, #:lo12:.LANCHOR56]
	mul	w0, w2, w0
	adrp	x2, .LANCHOR69
	str	w0, [x2, #:lo12:.LANCHOR69]
	adrp	x0, .LANCHOR42
	ldr	w2, [x0, #:lo12:.LANCHOR42]
	adrp	x0, .LANCHOR75+6
	ldrh	w0, [x0, #:lo12:.LANCHOR75+6]
	cmp	w1, w2
	sub	w0, w2, w0
	sub	w0, w0, w1
	udiv	w0, w0, w3
	adrp	x3, .LANCHOR223
	strh	w0, [x3, #:lo12:.LANCHOR223]
	bls	.L2026
	mov	w2, 1567
	adrp	x1, .LANCHOR221
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR221
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2026:
	add	x1, x20, :lo12:.LANCHOR81
	adrp	x0, .LANCHOR92
	add	x3, x0, :lo12:.LANCHOR92
	adrp	x19, .LANCHOR204
	ldrh	w2, [x1, 16]
	ldrh	w6, [x1, 14]
	strh	w6, [x0, #:lo12:.LANCHOR92]
	lsr	w4, w2, 6
	and	w2, w2, 63
	strb	w2, [x3, 6]
	ldrb	w2, [x1, 11]
	strb	w2, [x3, 8]
	add	x2, x19, :lo12:.LANCHOR204
	strh	w4, [x3, 2]
	mov	w3, -1
	strh	w3, [x19, #:lo12:.LANCHOR204]
	strh	wzr, [x2, 2]
	strb	wzr, [x2, 6]
	strb	wzr, [x2, 8]
	adrp	x2, .LANCHOR93
	ldrh	w3, [x1, 18]
	add	x4, x2, :lo12:.LANCHOR93
	strh	w3, [x2, #:lo12:.LANCHOR93]
	mov	x21, x2
	ldrh	w3, [x1, 20]
	lsr	w5, w3, 6
	and	w3, w3, 63
	strb	w3, [x4, 6]
	ldrb	w3, [x1, 12]
	strh	w5, [x4, 2]
	strb	w3, [x4, 8]
	adrp	x4, .LANCHOR94
	ldrh	w3, [x1, 22]
	add	x5, x4, :lo12:.LANCHOR94
	strh	w3, [x4, #:lo12:.LANCHOR94]
	mov	x22, x4
	ldrh	w3, [x1, 24]
	lsr	w7, w3, 6
	and	w3, w3, 63
	strb	w3, [x5, 6]
	ldrb	w3, [x1, 13]
	strb	w3, [x5, 8]
	adrp	x3, .LANCHOR161
	strh	w7, [x5, 2]
	ldr	w5, [x1, 32]
	str	wzr, [x3, #:lo12:.LANCHOR161]
	adrp	x3, .LANCHOR162
	str	wzr, [x3, #:lo12:.LANCHOR162]
	adrp	x3, .LANCHOR166
	str	wzr, [x3, #:lo12:.LANCHOR166]
	adrp	x3, .LANCHOR165
	str	wzr, [x3, #:lo12:.LANCHOR165]
	adrp	x3, .LANCHOR167
	str	w5, [x3, #:lo12:.LANCHOR167]
	adrp	x3, .LANCHOR168
	str	wzr, [x3, #:lo12:.LANCHOR168]
	adrp	x3, .LANCHOR169
	str	wzr, [x3, #:lo12:.LANCHOR169]
	adrp	x3, .LANCHOR164
	str	wzr, [x3, #:lo12:.LANCHOR164]
	ldr	w3, [x1, 40]
	adrp	x1, .LANCHOR159
	ldr	w5, [x1, #:lo12:.LANCHOR159]
	cmp	w3, w5
	bls	.L2027
	str	w3, [x1, #:lo12:.LANCHOR159]
.L2027:
	add	x20, x20, :lo12:.LANCHOR81
	adrp	x1, .LANCHOR160
	ldr	w3, [x1, #:lo12:.LANCHOR160]
	ldr	w2, [x20, 36]
	cmp	w2, w3
	bls	.L2028
	str	w2, [x1, #:lo12:.LANCHOR160]
.L2028:
	mov	w1, 65535
	cmp	w6, w1
	beq	.L2029
	add	x0, x0, :lo12:.LANCHOR92
	bl	make_superblock
.L2029:
	ldrh	w2, [x21, #:lo12:.LANCHOR93]
	mov	w1, 65535
	add	x0, x21, :lo12:.LANCHOR93
	cmp	w2, w1
	beq	.L2030
	bl	make_superblock
.L2030:
	ldrh	w2, [x22, #:lo12:.LANCHOR94]
	mov	w1, 65535
	add	x0, x22, :lo12:.LANCHOR94
	cmp	w2, w1
	beq	.L2031
	bl	make_superblock
.L2031:
	ldrh	w2, [x19, #:lo12:.LANCHOR204]
	mov	w1, 65535
	add	x0, x19, :lo12:.LANCHOR204
	cmp	w2, w1
	beq	.L2032
	bl	make_superblock
.L2032:
	mov	w0, 0
	b	.L2015
.L2021:
	ldrh	w0, [x21, #:lo12:.LANCHOR209]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w23, w0, lsl 10
	str	w0, [x20, 4]
	ldr	x0, [x24, #:lo12:.LANCHOR183]
	str	x0, [x20, 8]
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L2019
	ldr	x0, [x24, #:lo12:.LANCHOR183]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L2019
	ldr	x0, [x26, #:lo12:.LANCHOR188]
	ldrh	w0, [x0]
	cmp	w0, w28
	beq	.L2020
.L2019:
	sub	w23, w23, #1
	sxth	w23, w23
	b	.L2018
	.size	FtlLoadSysInfo, .-FtlLoadSysInfo
	.section	.text.FtlDumpBlockInfo,"ax",@progbits
	.align	2
	.global	FtlDumpBlockInfo
	.type	FtlDumpBlockInfo, %function
FtlDumpBlockInfo:
	sub	sp, sp, #160
	lsr	w0, w0, 10
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x19, .LANCHOR53
	stp	x21, x22, [sp, 48]
	and	w22, w1, 255
	stp	x23, x24, [sp, 64]
	add	x23, x29, 144
	stp	x25, x26, [sp, 80]
	str	x27, [sp, 96]
	bl	P2V_block_in_plane
	ldrh	w25, [x19, #:lo12:.LANCHOR53]
	and	w21, w0, 65535
	adrp	x1, .LANCHOR224
	adrp	x0, .LC45
	add	x1, x1, :lo12:.LANCHOR224
	add	x0, x0, :lo12:.LC45
	bl	printf
	adrp	x1, .LANCHOR84
	ubfiz	x0, x21, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR84]
	ldrh	w2, [x1, x0]
	mov	w1, w21
	adrp	x0, .LC46
	add	x0, x0, :lo12:.LC46
	bl	printf
	strh	w21, [x23, -48]!
	mov	x0, x23
	bl	make_superblock
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L2051
	cbnz	w22, .L2051
	mov	w0, w21
	bl	ftl_get_blk_mode
	mov	w21, w0
	cmp	w0, 1
	bne	.L2042
	adrp	x0, .LANCHOR54
	ldrh	w25, [x0, #:lo12:.LANCHOR54]
.L2042:
	ldrh	w3, [x19, #:lo12:.LANCHOR53]
	adrp	x26, .LC48
	add	x26, x26, :lo12:.LC48
	mov	w20, 0
	mov	w27, 56
	mov	w2, w25
	mov	w1, w21
	adrp	x0, .LC47
	add	x0, x0, :lo12:.LC47
	bl	printf
.L2043:
	adrp	x1, .LANCHOR105
	adrp	x0, .LANCHOR38
	adrp	x24, .LANCHOR180
	add	x3, x23, 16
	ldr	x6, [x1, #:lo12:.LANCHOR105]
	adrp	x1, .LANCHOR58
	ldrh	w5, [x0, #:lo12:.LANCHOR38]
	mov	w19, 0
	ldrh	w7, [x1, #:lo12:.LANCHOR58]
	adrp	x1, .LANCHOR106
	ldr	x0, [x24, #:lo12:.LANCHOR180]
	mov	w11, 65535
	ldr	x8, [x1, #:lo12:.LANCHOR106]
	adrp	x1, .LANCHOR59
	ldrh	w10, [x1, #:lo12:.LANCHOR59]
	mov	w1, 0
.L2044:
	cmp	w1, w5
	bne	.L2046
	mov	w1, w19
	umull	x19, w19, w27
	mov	x22, 0
	mov	w2, w21
	bl	FlashReadPages
.L2047:
	cmp	x22, x19
	bne	.L2048
	add	w20, w20, 1
	and	w20, w20, 65535
	cmp	w25, w20
	bne	.L2043
.L2049:
	ldp	x19, x20, [sp, 32]
	mov	w0, 0
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	ldr	x27, [sp, 96]
	add	sp, sp, 160
	ret
.L2051:
	mov	w21, 0
	b	.L2042
.L2046:
	ldrh	w2, [x3]
	cmp	w2, w11
	beq	.L2045
	umaddl	x4, w19, w27, x0
	orr	w2, w20, w2, lsl 10
	str	w2, [x4, 4]
	mul	w2, w19, w7
	asr	w2, w2, 2
	add	x2, x6, x2, sxtw 2
	str	x2, [x4, 8]
	mul	w2, w19, w10
	add	w19, w19, 1
	and	w19, w19, 65535
	asr	w2, w2, 2
	add	x2, x8, x2, sxtw 2
	str	x2, [x4, 16]
.L2045:
	add	w1, w1, 1
	add	x3, x3, 2
	and	w1, w1, 65535
	b	.L2044
.L2048:
	ldr	x8, [x24, #:lo12:.LANCHOR180]
	ldrh	w1, [x29, 96]
	add	x2, x8, x22
	ldp	x3, x0, [x2, 8]
	ldr	w4, [x3, 4]
	str	w4, [sp, 8]
	ldr	w3, [x3]
	str	w3, [sp]
	ldp	w4, w5, [x0]
	ldp	w6, w7, [x0, 8]
	mov	x0, x26
	ldr	w3, [x2, 4]
	ldr	w2, [x8, x22]
	add	x22, x22, 56
	bl	printf
	b	.L2047
	.size	FtlDumpBlockInfo, .-FtlDumpBlockInfo
	.section	.text.FtlScanAllBlock,"ax",@progbits
	.align	2
	.global	FtlScanAllBlock
	.type	FtlScanAllBlock, %function
FtlScanAllBlock:
	sub	sp, sp, #144
	adrp	x1, .LANCHOR225
	adrp	x0, .LC45
	add	x1, x1, :lo12:.LANCHOR225
	add	x0, x0, :lo12:.LC45
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x23, x24, [sp, 64]
	adrp	x23, .LANCHOR41
	stp	x19, x20, [sp, 32]
	adrp	x24, .LC50
	stp	x21, x22, [sp, 48]
	mov	w20, 0
	add	x23, x23, :lo12:.LANCHOR41
	add	x24, x24, :lo12:.LC50
	str	x25, [sp, 80]
	bl	printf
.L2055:
	ldrh	w0, [x23]
	cmp	w0, w20
	bhi	.L2063
	ldp	x19, x20, [sp, 32]
	mov	w0, 0
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x29, x30, [sp, 16]
	ldr	x25, [sp, 80]
	add	sp, sp, 144
	ret
.L2063:
	strh	w20, [x29, 80]
	mov	w0, w20
	bl	ftl_get_blk_mode
	mov	w3, w0
	adrp	x2, .LANCHOR84
	ubfiz	x1, x20, 1, 16
	adrp	x0, .LC49
	add	x0, x0, :lo12:.LC49
	ldr	x2, [x2, #:lo12:.LANCHOR84]
	adrp	x22, .LANCHOR180
	mov	w19, 0
	ldrh	w2, [x2, x1]
	mov	w1, w20
	bl	printf
	add	x0, x29, 80
	bl	make_superblock
	adrp	x1, .LANCHOR105
	adrp	x0, .LANCHOR38
	add	x3, x29, 96
	mov	w11, 65535
	ldr	x6, [x1, #:lo12:.LANCHOR105]
	adrp	x1, .LANCHOR58
	ldrh	w5, [x0, #:lo12:.LANCHOR38]
	mov	w12, 56
	ldrh	w7, [x1, #:lo12:.LANCHOR58]
	adrp	x1, .LANCHOR106
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	ldr	x8, [x1, #:lo12:.LANCHOR106]
	adrp	x1, .LANCHOR59
	ldrh	w10, [x1, #:lo12:.LANCHOR59]
	mov	w1, 0
.L2056:
	cmp	w1, w5
	bne	.L2058
	mov	w25, 56
	mov	x21, 0
	mov	w2, 0
	mov	w1, w19
	umull	x25, w19, w25
	bl	FlashReadPages
.L2059:
	cmp	x21, x25
	bne	.L2060
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	adrp	x25, .LC51
	add	x25, x25, :lo12:.LC51
	mov	w1, w19
	mov	x19, 0
	mov	w2, 1
	bl	FlashReadPages
.L2061:
	cmp	x21, x19
	bne	.L2062
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2055
.L2058:
	ldrh	w2, [x3]
	cmp	w2, w11
	beq	.L2057
	umaddl	x4, w19, w12, x0
	lsl	w2, w2, 10
	str	w2, [x4, 4]
	mul	w2, w19, w7
	asr	w2, w2, 2
	add	x2, x6, x2, sxtw 2
	str	x2, [x4, 8]
	mul	w2, w19, w10
	add	w19, w19, 1
	and	w19, w19, 65535
	asr	w2, w2, 2
	add	x2, x8, x2, sxtw 2
	str	x2, [x4, 16]
.L2057:
	add	w1, w1, 1
	add	x3, x3, 2
	and	w1, w1, 65535
	b	.L2056
.L2060:
	ldr	x8, [x22, #:lo12:.LANCHOR180]
	ldrh	w1, [x29, 80]
	add	x2, x8, x21
	ldp	x3, x0, [x2, 8]
	ldr	w4, [x3, 4]
	str	w4, [sp, 8]
	ldr	w3, [x3]
	str	w3, [sp]
	ldp	w4, w5, [x0]
	ldp	w6, w7, [x0, 8]
	mov	x0, x24
	ldr	w3, [x2, 4]
	ldr	w2, [x8, x21]
	add	x21, x21, 56
	bl	printf
	b	.L2059
.L2062:
	ldr	x8, [x22, #:lo12:.LANCHOR180]
	ldrh	w1, [x29, 80]
	add	x2, x8, x19
	ldp	x3, x0, [x2, 8]
	ldr	w4, [x3, 4]
	str	w4, [sp, 8]
	ldr	w3, [x3]
	str	w3, [sp]
	ldp	w4, w5, [x0]
	ldp	w6, w7, [x0, 8]
	mov	x0, x25
	ldr	w3, [x2, 4]
	ldr	w2, [x8, x19]
	add	x19, x19, 56
	bl	printf
	b	.L2061
	.size	FtlScanAllBlock, .-FtlScanAllBlock
	.section	.text.FtlMapTblRecovery,"ax",@progbits
	.align	2
	.global	FtlMapTblRecovery
	.type	FtlMapTblRecovery, %function
FtlMapTblRecovery:
	stp	x29, x30, [sp, -144]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	adrp	x20, .LANCHOR202
	ldrh	w23, [x0, 6]
	adrp	x24, .LANCHOR54
	stp	x21, x22, [sp, 32]
	ldr	x21, [x0, 40]
	ldr	x22, [x0, 16]
	lsl	w2, w23, 2
	ldr	x0, [x0, 24]
	str	x0, [x29, 128]
	ldrh	w0, [x19, 8]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	mov	w27, 0
	str	w0, [x29, 140]
	mov	x0, x21
	bl	ftl_memset
	str	x20, [x29, 120]
	adrp	x7, .LANCHOR183
	add	x3, x20, :lo12:.LANCHOR202
	mov	x26, x7
	mov	x20, x3
	ldr	x0, [x7, #:lo12:.LANCHOR183]
	str	x0, [x3, 8]
	adrp	x0, .LANCHOR188
	stp	wzr, wzr, [x19, 48]
	ldr	x25, [x0, #:lo12:.LANCHOR188]
	mov	w0, -1
	str	x25, [x3, 16]
	strh	w0, [x19]
	strh	w0, [x19, 2]
	mov	w0, 1
	str	w0, [x19, 56]
	ldr	w0, [x29, 140]
	sub	w0, w0, #1
	str	w0, [x29, 136]
	add	x0, x24, :lo12:.LANCHOR54
	str	x0, [x29, 112]
.L2066:
	ldr	w0, [x29, 140]
	cmp	w27, w0
	bge	.L2083
	ldr	w0, [x29, 136]
	sxtw	x28, w27
	cmp	w27, w0
	bne	.L2067
	lsl	x0, x28, 1
	mov	w1, 1
	add	x24, x22, x0
	ldrh	w0, [x22, x0]
	mov	w22, 0
	bl	FtlGetLastWrittenPage
	sxth	w26, w0
	add	w0, w0, 1
	strh	w0, [x19, 2]
	ldr	x0, [x29, 128]
	strh	w27, [x19]
	ldr	w0, [x0, x28, lsl 2]
	str	w0, [x19, 48]
	ldr	x0, [x29, 120]
	add	x20, x0, :lo12:.LANCHOR202
.L2068:
	cmp	w22, w26
	ble	.L2070
.L2083:
	mov	x0, x19
	bl	ftl_free_no_use_map_blk
	adrp	x0, .LANCHOR54
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR54]
	cmp	w1, w0
	bne	.L2072
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L2072:
	mov	x0, x19
	bl	ftl_map_blk_gc
	mov	x0, x19
	bl	ftl_map_blk_gc
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L2070:
	ldrh	w0, [x24]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w22, w0, lsl 10
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L2069
	ldrh	w0, [x25, 8]
	cmp	w23, w0
	bls	.L2069
	ldrh	w2, [x25]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L2069
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x20, 4]
	str	w1, [x21, x0]
.L2069:
	add	w22, w22, 1
	sxth	w22, w22
	b	.L2068
.L2067:
	ldr	x0, [x26, #:lo12:.LANCHOR183]
	mov	w2, 1
	str	x0, [x20, 8]
	lsl	x0, x28, 1
	ldrh	w1, [x24, #:lo12:.LANCHOR54]
	add	x28, x22, x0
	ldrh	w0, [x22, x0]
	sub	w1, w1, #1
	orr	w0, w1, w0, lsl 10
	mov	w1, w2
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L2085
	ldrh	w1, [x25]
	ldrh	w0, [x19, 4]
	cmp	w1, w0
	bne	.L2085
	ldrh	w1, [x25, 8]
	mov	w0, 64245
	cmp	w1, w0
	beq	.L2074
.L2085:
	mov	w5, 0
.L2075:
	ldr	x0, [x29, 112]
	ldrh	w0, [x0]
	cmp	w5, w0
	bge	.L2081
	ldrh	w0, [x28]
	mov	w2, 1
	str	w5, [x29, 108]
	mov	w1, w2
	orr	w0, w5, w0, lsl 10
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	ldr	w5, [x29, 108]
	cmn	w0, #1
	beq	.L2079
	ldrh	w0, [x25, 8]
	cmp	w23, w0
	bls	.L2079
	ldrh	w2, [x25]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L2079
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x20, 4]
	str	w1, [x21, x0]
.L2079:
	add	w5, w5, 1
	sxth	w5, w5
	b	.L2075
.L2074:
	ldrh	w5, [x24, #:lo12:.LANCHOR54]
	mov	w0, 0
	ldr	x10, [x26, #:lo12:.LANCHOR183]
	sub	w5, w5, #1
.L2076:
	cmp	w0, w5
	blt	.L2078
.L2081:
	add	w4, w27, 1
	sxth	w27, w4
	b	.L2066
.L2078:
	lsl	w2, w0, 1
	sxtw	x2, w2
	lsl	x1, x2, 2
	ldrh	w1, [x10, x1]
	cmp	w23, w1
	bls	.L2077
	add	x2, x2, 1
	ubfiz	x1, x1, 2, 16
	ldr	w2, [x10, x2, lsl 2]
	str	w2, [x21, x1]
.L2077:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L2076
	.size	FtlMapTblRecovery, .-FtlMapTblRecovery
	.section	.text.FtlLoadVonderInfo,"ax",@progbits
	.align	2
	.global	FtlLoadVonderInfo
	.type	FtlLoadVonderInfo, %function
FtlLoadVonderInfo:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR62
	adrp	x0, .LANCHOR215
	add	x0, x0, :lo12:.LANCHOR215
	add	x29, sp, 0
	ldrh	w1, [x1, #:lo12:.LANCHOR62]
	strh	w1, [x0, 10]
	mov	w1, -3962
	strh	w1, [x0, 4]
	adrp	x1, .LANCHOR71
	ldrh	w1, [x1, #:lo12:.LANCHOR71]
	strh	w1, [x0, 8]
	adrp	x1, .LANCHOR63
	ldrh	w1, [x1, #:lo12:.LANCHOR63]
	strh	w1, [x0, 6]
	adrp	x1, .LANCHOR72
	ldr	x1, [x1, #:lo12:.LANCHOR72]
	str	x1, [x0, 16]
	adrp	x1, .LANCHOR193
	ldr	x1, [x1, #:lo12:.LANCHOR193]
	str	x1, [x0, 24]
	adrp	x1, .LANCHOR192
	ldr	x1, [x1, #:lo12:.LANCHOR192]
	str	x1, [x0, 32]
	adrp	x1, .LANCHOR194
	ldr	x1, [x1, #:lo12:.LANCHOR194]
	str	x1, [x0, 40]
	bl	FtlMapTblRecovery
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlLoadVonderInfo, .-FtlLoadVonderInfo
	.section	.text.FtlLoadMapInfo,"ax",@progbits
	.align	2
	.global	FtlLoadMapInfo
	.type	FtlLoadMapInfo, %function
FtlLoadMapInfo:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	FtlL2PDataInit
	adrp	x0, .LANCHOR127
	add	x0, x0, :lo12:.LANCHOR127
	bl	FtlMapTblRecovery
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
	.section	.text.FtlGcScanTempBlk,"ax",@progbits
	.align	2
	.global	FtlGcScanTempBlk
	.type	FtlGcScanTempBlk, %function
FtlGcScanTempBlk:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR226
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	ldrh	w19, [x23, #:lo12:.LANCHOR226]
	mov	w0, 65535
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	cmp	w19, w0
	stp	x27, x28, [sp, 80]
	beq	.L2115
	cbnz	w19, .L2098
.L2099:
	bl	FtlGcPageVarInit
	b	.L2100
.L2115:
	mov	w19, 0
.L2098:
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w1
	beq	.L2099
.L2100:
	adrp	x25, .LANCHOR59
	add	x25, x25, :lo12:.LANCHOR59
	mov	w26, -1
	mov	w24, 65535
.L2112:
	ldrh	w0, [x20]
	strb	wzr, [x20, 8]
	cmp	w0, w24
	beq	.L2116
	mov	w27, 56
.L2114:
	adrp	x1, .LANCHOR106
	adrp	x22, .LANCHOR180
	ldrh	w6, [x25]
	add	x3, x20, 16
	ldr	x5, [x1, #:lo12:.LANCHOR106]
	adrp	x1, .LANCHOR38
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	mov	w21, 0
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	add	x1, x1, 8
	add	x1, x20, x1, lsl 1
.L2102:
	cmp	x3, x1
	bne	.L2104
	mov	w1, w21
	umull	x21, w21, w27
	mov	x28, 0
	mov	w2, 0
	bl	FlashReadPages
.L2105:
	cmp	x28, x21
	bne	.L2113
	adrp	x0, .LANCHOR53
	add	w19, w19, 1
	and	w19, w19, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w19
	bhi	.L2114
.L2116:
	mov	w2, 0
	b	.L2101
.L2104:
	ldrh	w2, [x3]
	cmp	w2, w24
	beq	.L2103
	umaddl	x4, w21, w27, x0
	orr	w2, w19, w2, lsl 10
	str	w2, [x4, 4]
	mul	w2, w21, w6
	add	w21, w21, 1
	str	xzr, [x4, 8]
	and	w21, w21, 65535
	asr	w2, w2, 2
	add	x2, x5, x2, sxtw 2
	str	x2, [x4, 16]
.L2103:
	add	x3, x3, 2
	b	.L2102
.L2113:
	ldr	x6, [x22, #:lo12:.LANCHOR180]
	add	x5, x6, x28
	ldr	w4, [x5, 4]
	lsr	w0, w4, 10
	bl	P2V_plane
	and	w2, w0, 65535
	ldr	w0, [x6, x28]
	cbnz	w0, .L2106
	ldr	x0, [x5, 16]
	add	x28, x28, 56
	ldrh	w1, [x0]
	cmp	w1, w24
	bne	.L2107
	adrp	x0, .LANCHOR135
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR135]
.L2101:
	strb	w2, [x20, 6]
	mov	w0, -1
	strh	w19, [x20, 2]
	mov	w1, w19
	strh	w0, [x23, #:lo12:.LANCHOR226]
	mov	x0, x20
	bl	ftl_sb_update_avl_pages
	mov	w0, w26
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2107:
	ldp	w2, w0, [x0, 8]
	mov	w1, w4
	bl	FtlGcUpdatePage
	b	.L2105
.L2106:
	ldrh	w1, [x20]
	mov	w2, w4
	adrp	x0, .LC52
	add	x0, x0, :lo12:.LC52
	bl	printf
	adrp	x0, .LANCHOR28
	ldr	w1, [x0, #:lo12:.LANCHOR28]
	ldrh	w0, [x20]
	cbnz	w1, .L2108
	adrp	x1, .LANCHOR8
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	cbz	w1, .L2109
.L2108:
	adrp	x2, .LANCHOR79
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR79]
	ldrh	w1, [x2, x1]
	cmp	w1, 159
	bls	.L2110
.L2109:
	ldr	x1, [x22, #:lo12:.LANCHOR180]
	ldr	w1, [x1, x28]
	cmn	w1, #1
	bne	.L2111
.L2110:
	ldr	x1, [x22, #:lo12:.LANCHOR180]
	add	x28, x1, x28
	ldr	w26, [x28, 4]
.L2111:
	adrp	x1, .LANCHOR84
	ubfiz	x0, x0, 1, 16
	mov	w19, 0
	ldr	x1, [x1, #:lo12:.LANCHOR84]
	strh	wzr, [x1, x0]
	ldrh	w0, [x20]
	bl	INSERT_FREE_LIST
	mov	w0, -1
	strh	w0, [x20]
	bl	FtlGcPageVarInit
	b	.L2112
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
	.section	.text.FlashReadFacBbtData,"ax",@progbits
	.align	2
	.global	FlashReadFacBbtData
	.type	FlashReadFacBbtData, %function
FlashReadFacBbtData:
	stp	x29, x30, [sp, -160]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	mov	w25, w1
	adrp	x1, .LANCHOR15
	add	x1, x1, :lo12:.LANCHOR15
	stp	x23, x24, [sp, 48]
	mov	x23, x0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR147
	ldrh	w0, [x1, 14]
	mov	w24, w2
	ldrh	w1, [x1, 12]
	stp	x19, x20, [sp, 16]
	str	x27, [sp, 80]
	mov	w27, 61664
	mul	w0, w0, w1
	ldr	x1, [x21, #:lo12:.LANCHOR147]
	str	x1, [x29, 112]
	and	w0, w0, 65535
	adrp	x1, .LANCHOR197
	sub	w20, w0, #1
	sub	w19, w0, #15
	ldr	x2, [x1, #:lo12:.LANCHOR197]
	and	w20, w20, 65535
	mul	w26, w0, w25
	mov	x22, x1
	str	x2, [x29, 120]
.L2126:
	cmp	w19, w20
	ble	.L2133
	mov	w0, -1
.L2125:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L2133:
	add	w0, w20, w26
	mov	w2, 1
	lsl	w0, w0, 10
	mov	w1, w2
	str	w0, [x29, 108]
	add	x0, x29, 104
	bl	FlashReadPages
	ldr	w0, [x29, 104]
	cmn	w0, #1
	beq	.L2127
	ldr	x0, [x22, #:lo12:.LANCHOR197]
	ldrh	w0, [x0]
	cmp	w0, w27
	bne	.L2127
	cbz	x23, .L2134
	cbz	w25, .L2129
.L2132:
	ldr	x1, [x21, #:lo12:.LANCHOR147]
	mov	w2, w24
	mov	x0, x23
	bl	ftl_memcpy
	mov	w3, 4
	adrp	x0, .LC53
	mov	w2, w3
	mov	x1, x23
	add	x0, x0, :lo12:.LC53
	bl	rknand_print_hex
.L2134:
	mov	w0, 0
	b	.L2125
.L2129:
	ldr	x5, [x21, #:lo12:.LANCHOR147]
	adrp	x2, .LANCHOR149
	add	x2, x2, :lo12:.LANCHOR149
	mov	w0, 0
	mov	w6, 1
.L2130:
	ldr	w1, [x2]
	cmp	w0, w1
	bcs	.L2132
	ubfx	x1, x0, 5, 11
	and	w3, w0, 31
	lsl	x1, x1, 2
	add	w0, w0, 1
	lsl	w4, w6, w3
	and	w0, w0, 65535
	ldr	w3, [x5, x1]
	orr	w3, w3, w4
	str	w3, [x5, x1]
	b	.L2130
.L2127:
	sub	w20, w20, #1
	and	w20, w20, 65535
	b	.L2126
	.size	FlashReadFacBbtData, .-FlashReadFacBbtData
	.section	.text.FlashGetBadBlockList,"ax",@progbits
	.align	2
	.global	FlashGetBadBlockList
	.type	FlashGetBadBlockList, %function
FlashGetBadBlockList:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	adrp	x0, .LANCHOR18
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	ldrh	w19, [x0, 14]
	str	x21, [sp, 32]
	adrp	x21, .LANCHOR153
	ldrb	w2, [x0, 13]
	ldr	x0, [x21, #:lo12:.LANCHOR153]
	mul	w19, w19, w2
	and	w19, w19, 65535
	add	w2, w19, 7
	lsr	w2, w2, 3
	bl	FlashReadFacBbtData
	cmn	w0, #1
	bne	.L2140
.L2144:
	mov	w0, 0
.L2141:
	ubfiz	x0, x0, 1, 16
	mov	w1, -1
	ldr	x21, [sp, 32]
	strh	w1, [x20, x0]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L2140:
	ldr	x4, [x21, #:lo12:.LANCHOR153]
	lsr	w5, w19, 4
	sub	w19, w19, #1
	mov	w1, 0
	mov	w0, 0
	mov	w6, 1
.L2142:
	cmp	w1, w19
	bge	.L2141
	ubfx	x3, x1, 5, 11
	and	w2, w1, 31
	lsl	w2, w6, w2
	ldr	w3, [x4, x3, lsl 2]
	tst	w2, w3
	beq	.L2143
	add	w2, w0, 1
	ubfiz	x0, x0, 1, 16
	strh	w1, [x20, x0]
	and	w0, w2, 65535
.L2143:
	cmp	w0, w5
	bcs	.L2144
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L2142
	.size	FlashGetBadBlockList, .-FlashGetBadBlockList
	.section	.text.FtlMakeBbt,"ax",@progbits
	.align	2
	.global	FtlMakeBbt
	.type	FtlMakeBbt, %function
FtlMakeBbt:
	stp	x29, x30, [sp, -128]!
	adrp	x0, .LANCHOR77
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	ldr	w21, [x0, #:lo12:.LANCHOR77]
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w21, .L2151
	bl	FtlBbtMemInit
	adrp	x20, .LANCHOR75
	add	x22, x20, :lo12:.LANCHOR75
	bl	FtlLoadFactoryBbt
	add	x24, x22, 32
	adrp	x28, .LANCHOR202
	add	x22, x22, 12
	add	x25, x28, :lo12:.LANCHOR202
	adrp	x0, .LANCHOR45
	add	x0, x0, :lo12:.LANCHOR45
	str	x0, [x29, 120]
.L2152:
	ldr	x0, [x29, 120]
	ldrh	w0, [x0]
	cmp	w21, w0
	bcc	.L2158
	adrp	x21, .LANCHOR60
	add	x21, x21, :lo12:.LANCHOR60
	mov	w19, 0
.L2159:
	ldrh	w0, [x21]
	cmp	w0, w19
	bhi	.L2160
	add	x21, x20, :lo12:.LANCHOR75
	mov	w22, 65535
	ldrh	w19, [x21, 12]
	sub	w19, w19, #1
	and	w19, w19, 65535
.L2161:
	ldrh	w0, [x21, 12]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L2165
	mov	w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L2162
	mov	w0, w19
	bl	FlashTestBlk
	cbz	w0, .L2163
	mov	w0, w19
	bl	FtlBbmMapBadBlock
.L2162:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L2161
.L2158:
	adrp	x2, .LANCHOR188
	adrp	x0, .LANCHOR183
	add	x19, x28, :lo12:.LANCHOR202
	ldrh	w1, [x22]
	ldr	x0, [x0, #:lo12:.LANCHOR183]
	mov	w3, 65535
	ldr	x26, [x2, #:lo12:.LANCHOR188]
	cmp	w1, w3
	stp	x0, x26, [x19, 8]
	adrp	x23, .LANCHOR51
	str	x2, [x29, 112]
	beq	.L2153
	ldrh	w4, [x23, #:lo12:.LANCHOR51]
	mov	w2, 1
	madd	w27, w4, w21, w1
	mov	w1, w2
	lsl	w0, w27, 10
	str	w0, [x19, 4]
	mov	x0, x19
	bl	FlashReadPages
	ldr	x1, [x19, 8]
	ldr	x0, [x24]
	ldrh	w2, [x23, #:lo12:.LANCHOR51]
	add	w2, w2, 7
	lsr	w2, w2, 3
	bl	ftl_memcpy
.L2154:
	mov	w0, w27
	add	w21, w21, 1
	bl	FtlBbmMapBadBlock
	add	x24, x24, 8
	add	x22, x22, 2
	b	.L2152
.L2153:
	mov	w1, w21
	bl	FlashGetBadBlockList
	ldr	x0, [x19, 8]
	adrp	x27, .LANCHOR123
	ldr	x1, [x24]
	bl	FtlBbt2Bitmap
	ldrh	w19, [x23, #:lo12:.LANCHOR51]
	add	x23, x23, :lo12:.LANCHOR51
	add	x0, x27, :lo12:.LANCHOR123
	sub	w19, w19, #1
	str	x0, [x29, 104]
	and	w19, w19, 65535
.L2155:
	ldrh	w0, [x23]
	madd	w0, w21, w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L2156
	ldr	x0, [x29, 112]
	mov	w2, 16
	strh	w19, [x22]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR188]
	bl	ftl_memset
	mov	w0, -3872
	strh	w0, [x26]
	ldrh	w4, [x23]
	ldrh	w0, [x22]
	strh	w0, [x26, 2]
	ldr	x1, [x24]
	str	wzr, [x26, 4]
	madd	w27, w4, w21, w0
	lsl	w0, w27, 10
	str	w0, [x25, 4]
	ldr	x0, [x29, 104]
	ldrh	w2, [x0]
	ldr	x0, [x25, 8]
	lsl	w2, w2, 2
	bl	ftl_memcpy
	mov	w2, 1
	mov	x0, x25
	mov	w1, w2
	bl	FlashEraseBlocks
	mov	w3, 1
	mov	x0, x25
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
	ldr	w0, [x25]
	cmn	w0, #1
	bne	.L2154
	mov	w0, w27
	bl	FtlBbmMapBadBlock
	b	.L2155
.L2156:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L2155
.L2160:
	mov	w0, w19
	add	w19, w19, 1
	bl	FtlBbmMapBadBlock
	and	w19, w19, 65535
	b	.L2159
.L2163:
	ldrh	w0, [x21]
	cmp	w0, w22
	bne	.L2164
	strh	w19, [x21]
	b	.L2162
.L2164:
	strh	w19, [x21, 4]
.L2165:
	adrp	x0, .LANCHOR78
	add	x19, x20, :lo12:.LANCHOR75
	ldrh	w1, [x20, #:lo12:.LANCHOR75]
	mov	w2, 2
	ldr	x0, [x0, #:lo12:.LANCHOR78]
	str	wzr, [x19, 8]
	lsl	w1, w1, 10
	strh	wzr, [x19, 2]
	str	w1, [x0, 4]
	ldrh	w1, [x19, 4]
	lsl	w1, w1, 10
	str	w1, [x0, 60]
	mov	w1, 1
	bl	FlashEraseBlocks
	ldrh	w0, [x20, #:lo12:.LANCHOR75]
	bl	FtlBbmMapBadBlock
	ldrh	w0, [x19, 4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	strh	wzr, [x19, 2]
	ldr	w0, [x19, 8]
	ldrh	w1, [x19, 4]
	add	w0, w0, 1
	str	w0, [x19, 8]
	ldrh	w0, [x20, #:lo12:.LANCHOR75]
	strh	w0, [x19, 4]
	strh	w1, [x20, #:lo12:.LANCHOR75]
	bl	FtlBbmTblFlush
.L2151:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
	.size	FtlMakeBbt, .-FtlMakeBbt
	.section	.text.log2phys,"ax",@progbits
	.align	2
	.global	log2phys
	.type	log2phys, %function
log2phys:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	x23, x1
	adrp	x1, .LANCHOR57
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	ldrh	w20, [x1, #:lo12:.LANCHOR57]
	stp	x25, x26, [sp, 64]
	add	w1, w20, 7
	mov	x20, 1
	stp	x27, x28, [sp, 80]
	lsl	x20, x20, x1
	sub	w20, w20, #1
	and	w20, w20, w0
	lsr	w22, w0, w1
	and	w1, w20, 65535
	stp	w2, w1, [x29, 120]
	adrp	x1, .LANCHOR73
	and	w21, w22, 65535
	ldr	w1, [x1, #:lo12:.LANCHOR73]
	cmp	w0, w1
	bcc	.L2172
	mov	w2, 880
	adrp	x1, .LANCHOR227
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR227
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2172:
	adrp	x19, .LANCHOR97
	adrp	x0, .LANCHOR68
	ldr	x2, [x19, #:lo12:.LANCHOR97]
	ldrh	w1, [x0, #:lo12:.LANCHOR68]
	mov	x0, 0
.L2173:
	and	x25, x0, 65535
	cmp	w25, w1
	bcc	.L2178
	bl	select_l2p_ram_region
	and	x25, x0, 65535
	ldr	x1, [x19, #:lo12:.LANCHOR97]
	ubfiz	x26, x25, 4, 16
	add	x2, x1, x26
	ldrh	w3, [x1, x26]
	mov	w1, 65535
	cmp	w3, w1
	beq	.L2179
	ldr	w1, [x2, 4]
	tbz	w1, #31, .L2179
	bl	flush_l2p_region
.L2179:
	adrp	x28, .LANCHOR67
	ldrh	w0, [x28, #:lo12:.LANCHOR67]
	cmp	w0, w21
	bcs	.L2180
	mov	w2, 526
	adrp	x1, .LANCHOR228
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2180:
	adrp	x24, .LANCHOR131
	ubfiz	x0, x21, 2, 16
	ldr	x1, [x24, #:lo12:.LANCHOR131]
	ldr	w3, [x1, x0]
	cbnz	w3, .L2181
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	adrp	x1, .LANCHOR58
	add	x0, x0, x26
	ldrh	w2, [x1, #:lo12:.LANCHOR58]
	mov	w1, 255
	ldr	x0, [x0, 8]
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	add	x1, x0, x26
	strh	w21, [x0, x26]
	str	wzr, [x1, 4]
	b	.L2174
.L2178:
	add	x0, x0, 1
	add	x3, x2, x0, lsl 4
	ldrh	w3, [x3, -16]
	cmp	w3, w21
	bne	.L2173
.L2174:
	ldp	w0, w20, [x29, 120]
	cbnz	w0, .L2175
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	add	x0, x0, x25, lsl 4
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x20, lsl 2]
	str	w0, [x23]
.L2176:
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	add	x25, x0, x25, lsl 4
	ldr	w0, [x25, 4]
	cmn	w0, #1
	beq	.L2186
	add	w0, w0, 1
	str	w0, [x25, 4]
.L2186:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2175:
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	ldr	w2, [x23]
	add	x0, x0, x25, lsl 4
	ldr	x1, [x0, 8]
	str	w2, [x1, x20, lsl 2]
	ldr	w1, [x0, 4]
	orr	w1, w1, -2147483648
	str	w1, [x0, 4]
	adrp	x0, .LANCHOR98
	strh	w21, [x0, #:lo12:.LANCHOR98]
	b	.L2176
.L2181:
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	adrp	x5, .LANCHOR202
	add	x20, x5, :lo12:.LANCHOR202
	mov	w2, 1
	add	x0, x0, x26
	str	x5, [x29, 104]
	str	w3, [x29, 116]
	mov	w1, w2
	str	w3, [x20, 4]
	ldr	x0, [x0, 8]
	str	x0, [x20, 8]
	adrp	x0, .LANCHOR188
	ldr	x0, [x0, #:lo12:.LANCHOR188]
	str	x0, [x20, 16]
	mov	x0, x20
	bl	FlashReadPages
	ldr	x27, [x20, 16]
	ldr	w3, [x29, 116]
	ldr	x5, [x29, 104]
	ldrh	w0, [x27, 8]
	cmp	w0, w21
	beq	.L2182
	mov	w2, w3
	and	w1, w22, 65535
	adrp	x0, .LC54
	add	x0, x0, :lo12:.LC54
	bl	printf
	ldr	x1, [x20, 16]
	mov	w3, 4
	adrp	x0, .LC27
	mov	w2, w3
	add	x0, x0, :lo12:.LC27
	bl	rknand_print_hex
	ldr	x1, [x24, #:lo12:.LANCHOR131]
	mov	w2, 4
	ldrh	w3, [x28, #:lo12:.LANCHOR67]
	adrp	x0, .LC55
	add	x0, x0, :lo12:.LC55
	bl	rknand_print_hex
	adrp	x0, .LANCHOR77
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR77]
.L2183:
	ldrh	w0, [x27, 8]
	cmp	w0, w21
	beq	.L2184
	mov	w2, 552
	adrp	x1, .LANCHOR228
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2184:
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	add	x1, x0, x26
	str	wzr, [x1, 4]
	strh	w21, [x0, x26]
	b	.L2174
.L2182:
	ldr	w0, [x5, #:lo12:.LANCHOR202]
	cmp	w0, 256
	bne	.L2183
	and	w22, w22, 65535
	mov	w2, w3
	mov	w1, w22
	adrp	x0, .LC56
	add	x0, x0, :lo12:.LC56
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR97]
	mov	w1, w22
	add	x0, x0, x26
	ldr	x2, [x0, 8]
	adrp	x0, .LANCHOR127
	add	x0, x0, :lo12:.LANCHOR127
	bl	FtlMapWritePage
	b	.L2183
	.size	log2phys, .-log2phys
	.section	.text.FtlProgPages,"ax",@progbits
	.align	2
	.global	FtlProgPages
	.type	FtlProgPages, %function
FtlProgPages:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR77
	stp	x19, x20, [sp, 16]
	ldr	w2, [x23, #:lo12:.LANCHOR77]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	cbnz	w2, .L2191
	adrp	x2, .LANCHOR8
	ldrb	w2, [x2, #:lo12:.LANCHOR8]
	cbz	w2, .L2206
	ldrb	w2, [x3, 8]
	cmp	w2, 1
	cset	w22, eq
.L2193:
	mov	x20, x3
	ldrb	w3, [x3, 9]
	mov	w21, w1
	mov	x19, x0
	mov	w2, w22
	adrp	x25, .LANCHOR53
	adrp	x24, .LANCHOR138
	add	x25, x25, :lo12:.LANCHOR53
	bl	FlashProgPages
	add	x24, x24, :lo12:.LANCHOR138
	mov	w1, 56
	umaddl	x21, w21, w1, x19
.L2194:
	cmp	x19, x21
	beq	.L2203
	adrp	x26, .LANCHOR84
	b	.L2204
.L2206:
	mov	w22, 0
	b	.L2193
.L2197:
	ldr	w0, [x19, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	ldrh	w1, [x20]
	cmp	w1, w0, uxth
	bne	.L2195
	ldr	x2, [x26, #:lo12:.LANCHOR84]
	ubfiz	x1, x1, 1, 16
	ldrh	w3, [x20, 4]
	ldrh	w0, [x2, x1]
	sub	w0, w0, w3
	strh	w0, [x2, x1]
	strb	wzr, [x20, 6]
	ldrh	w0, [x25]
	strh	w0, [x20, 2]
	strh	wzr, [x20, 4]
.L2195:
	ldrh	w0, [x20, 4]
	cbnz	w0, .L2196
	mov	x0, x20
	bl	allocate_new_data_superblock
.L2196:
	ldr	w0, [x24, 96]
	add	w0, w0, 1
	str	w0, [x24, 96]
	ldr	w0, [x19, 4]
	lsr	w0, w0, 10
	bl	FtlGcMarkBadPhyBlk
	mov	x0, x20
	bl	get_new_active_ppa
	str	w0, [x19, 4]
	mov	w2, w22
	str	w0, [x29, 92]
	mov	w1, 1
	ldrb	w3, [x20, 9]
	mov	x0, x19
	bl	FlashProgPages
	ldr	w0, [x23, #:lo12:.LANCHOR77]
	cbnz	w0, .L2191
.L2204:
	ldr	w0, [x19]
	cmn	w0, #1
	beq	.L2197
	adrp	x0, .LANCHOR38
	ldrb	w1, [x20, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcc	.L2198
	mov	w2, 1583
	adrp	x1, .LANCHOR229
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR229
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2198:
	ldr	w0, [x19, 4]
	cbnz	w22, .L2199
.L2211:
	str	w0, [x29, 92]
	add	x1, x29, 92
	ldr	w0, [x19, 24]
	mov	w2, 1
	bl	log2phys
	ldr	x0, [x19, 16]
	ldr	w3, [x0, 12]
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	and	w1, w0, 65535
	mov	w26, w1
	cmn	w3, #1
	beq	.L2201
	adrp	x2, .LANCHOR84
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR84]
	ldrh	w0, [x2, x0]
	cbnz	w0, .L2202
	adrp	x0, .LC57
	mov	w2, 0
	add	x0, x0, :lo12:.LC57
	bl	printf
.L2202:
	mov	w0, w26
	bl	decrement_vpc_count
.L2201:
	add	x19, x19, 56
	b	.L2194
.L2199:
	orr	w0, w0, -2147483648
	b	.L2211
.L2203:
	adrp	x0, .LANCHOR38
	ldrb	w1, [x20, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcc	.L2191
	mov	w2, 1600
	adrp	x1, .LANCHOR229
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR229
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2191:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
	.size	FtlProgPages, .-FtlProgPages
	.section	.text.FtlCacheWriteBack,"ax",@progbits
	.align	2
	.global	FtlCacheWriteBack
	.type	FtlCacheWriteBack, %function
FtlCacheWriteBack:
	adrp	x0, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	cbnz	w0, .L2218
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR132
	ldr	x0, [x19, #:lo12:.LANCHOR132]
	cbz	x0, .L2213
	adrp	x1, .LANCHOR230
	mov	w2, 0
	ldr	x3, [x1, #:lo12:.LANCHOR230]
	mov	w1, 1
	bl	FtlProgPages
	str	xzr, [x19, #:lo12:.LANCHOR132]
.L2213:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2218:
	mov	w0, 0
	ret
	.size	FtlCacheWriteBack, .-FtlCacheWriteBack
	.section	.text.FtlSysFlush,"ax",@progbits
	.align	2
	.global	FtlSysFlush
	.type	FtlSysFlush, %function
FtlSysFlush:
	adrp	x0, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	cbnz	w0, .L2224
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	FtlCacheWriteBack
	bl	l2p_flush
	mov	w0, 1
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L2224:
	mov	w0, 0
	ret
	.size	FtlSysFlush, .-FtlSysFlush
	.section	.text.FtlDeInit,"ax",@progbits
	.align	2
	.global	FtlDeInit
	.type	FtlDeInit, %function
FtlDeInit:
	adrp	x0, .LANCHOR231
	ldr	w0, [x0, #:lo12:.LANCHOR231]
	cmp	w0, 1
	bne	.L2230
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	FtlSysFlush
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L2230:
	mov	w0, 0
	ret
	.size	FtlDeInit, .-FtlDeInit
	.section	.text.rk_ftl_de_init,"ax",@progbits
	.align	2
	.global	rk_ftl_de_init
	.type	rk_ftl_de_init, %function
rk_ftl_de_init:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	FlashDeInit
	bl	FtlDeInit
	ldp	x29, x30, [sp], 16
	b	FlashDeInit
	.size	rk_ftl_de_init, .-rk_ftl_de_init
	.section	.text.ftl_discard,"ax",@progbits
	.align	2
	.global	ftl_discard
	.type	ftl_discard, %function
ftl_discard:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR69
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	ldr	w0, [x0, #:lo12:.LANCHOR69]
	add	w1, w1, w2
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	cmp	w1, w0
	bhi	.L2243
	mov	w19, w2
	cmp	w2, 31
	bhi	.L2237
.L2251:
	mov	w0, 0
.L2235:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2237:
	adrp	x0, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	cbnz	w0, .L2251
	adrp	x22, .LANCHOR56
	bl	FtlCacheWriteBack
	ldrh	w0, [x22, #:lo12:.LANCHOR56]
	udiv	w21, w20, w0
	msub	w20, w0, w21, w20
	ands	w20, w20, 65535
	beq	.L2239
	sub	w0, w0, w20
	add	w21, w21, 1
	cmp	w0, w19
	csel	w0, w0, w19, ls
	sub	w19, w19, w0, uxth
.L2239:
	adrp	x20, .LANCHOR232
	adrp	x23, .LANCHOR163
	add	x20, x20, :lo12:.LANCHOR232
	add	x23, x23, :lo12:.LANCHOR163
	mov	w0, -1
	str	w0, [x29, 76]
.L2240:
	ldrh	w0, [x22, #:lo12:.LANCHOR56]
	cmp	w19, w0
	bcs	.L2242
	adrp	x0, .LANCHOR232
	ldr	w1, [x0, #:lo12:.LANCHOR232]
	cmp	w1, 32
	bls	.L2251
	str	wzr, [x0, #:lo12:.LANCHOR232]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L2251
.L2242:
	mov	w2, 0
	add	x1, x29, 72
	mov	w0, w21
	bl	log2phys
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L2241
	ldr	w0, [x20]
	mov	w2, 1
	add	x1, x29, 76
	add	w0, w0, 1
	str	w0, [x20]
	ldr	w0, [x23]
	add	w0, w0, 1
	str	w0, [x23]
	mov	w0, w21
	bl	log2phys
	ldr	w0, [x29, 72]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	bl	decrement_vpc_count
.L2241:
	ldrh	w0, [x22, #:lo12:.LANCHOR56]
	add	w21, w21, 1
	sub	w19, w19, w0
	b	.L2240
.L2243:
	mov	w0, -1
	b	.L2235
	.size	ftl_discard, .-ftl_discard
	.section	.text.Ftlscanalldata,"ax",@progbits
	.align	2
	.global	Ftlscanalldata
	.type	Ftlscanalldata, %function
Ftlscanalldata:
	sub	sp, sp, #96
	adrp	x0, .LC58
	mov	w1, 0
	add	x0, x0, :lo12:.LC58
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x20, .LANCHOR202
	stp	x21, x22, [sp, 48]
	mov	w19, 0
	adrp	x21, .LANCHOR73
	add	x22, x20, :lo12:.LANCHOR202
	add	x21, x21, :lo12:.LANCHOR73
	str	x23, [sp, 64]
	bl	printf
.L2253:
	ldr	w0, [x21]
	cmp	w19, w0
	bcc	.L2259
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x29, x30, [sp, 16]
	ldr	x23, [sp, 64]
	add	sp, sp, 96
	ret
.L2259:
	mov	w2, 0
	add	x1, x29, 76
	mov	w0, w19
	bl	log2phys
	tst	x19, 2047
	bne	.L2254
	ldr	w2, [x29, 76]
	adrp	x0, .LC59
	mov	w1, w19
	add	x0, x0, :lo12:.LC59
	bl	printf
.L2254:
	ldr	w1, [x29, 76]
	cmn	w1, #1
	beq	.L2256
	add	x0, x20, :lo12:.LANCHOR202
	str	wzr, [x20, #:lo12:.LANCHOR202]
	mov	w2, 0
	str	w1, [x0, 4]
	adrp	x1, .LANCHOR183
	str	w19, [x0, 24]
	ldr	x1, [x1, #:lo12:.LANCHOR183]
	str	x1, [x0, 8]
	adrp	x1, .LANCHOR188
	ldr	x23, [x1, #:lo12:.LANCHOR188]
	mov	w1, 1
	str	x23, [x0, 16]
	bl	FlashReadPages
	ldr	w0, [x20, #:lo12:.LANCHOR202]
	cmp	w0, 256
	ccmn	w0, #1, 4, ne
	beq	.L2257
	ldr	w0, [x23, 8]
	cmp	w19, w0
	beq	.L2256
.L2257:
	ldp	x1, x0, [x22, 8]
	ldr	w2, [x1, 4]
	str	w2, [sp]
	ldr	w2, [x22, 4]
	ldp	w3, w4, [x0]
	ldp	w5, w6, [x0, 8]
	adrp	x0, .LC60
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC60
	mov	w1, w19
	bl	printf
.L2256:
	add	w19, w19, 1
	b	.L2253
	.size	Ftlscanalldata, .-Ftlscanalldata
	.section	.text.FtlReUsePrevPpa,"ax",@progbits
	.align	2
	.global	FtlReUsePrevPpa
	.type	FtlReUsePrevPpa, %function
FtlReUsePrevPpa:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR84
	stp	x19, x20, [sp, 16]
	mov	w21, w0
	str	w1, [x29, 76]
	lsr	w0, w1, 10
	str	x23, [sp, 48]
	bl	P2V_block_in_plane
	ldr	x2, [x22, #:lo12:.LANCHOR84]
	and	w3, w0, 65535
	ubfiz	x20, x3, 1, 16
	ldrh	w1, [x2, x20]
	cbnz	w1, .L2262
	adrp	x0, .LANCHOR88
	ldr	x19, [x0, #:lo12:.LANCHOR88]
	cbz	x19, .L2263
	adrp	x2, .LANCHOR82
	mov	x5, -6148914691236517206
	movk	x5, 0xaaab, lsl 0
	adrp	x23, .LANCHOR89
	ldr	x2, [x2, #:lo12:.LANCHOR82]
	mov	w6, 65535
	ldrh	w4, [x23, #:lo12:.LANCHOR89]
	sub	x19, x19, x2
	asr	x19, x19, 1
	mul	x19, x19, x5
	mov	w5, 6
	and	w19, w19, 65535
.L2264:
	cmp	w1, w4
	beq	.L2263
	cmp	w19, w3
	bne	.L2265
	mov	w1, w19
	add	x0, x0, :lo12:.LANCHOR88
	bl	List_remove_node
	ldrh	w0, [x23, #:lo12:.LANCHOR89]
	cbnz	w0, .L2266
	mov	w2, 2070
	adrp	x1, .LANCHOR233
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR233
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2266:
	ldrh	w0, [x23, #:lo12:.LANCHOR89]
	sub	w0, w0, #1
	strh	w0, [x23, #:lo12:.LANCHOR89]
	mov	w0, w19
	bl	INSERT_DATA_LIST
	ldr	x1, [x22, #:lo12:.LANCHOR84]
	ldrh	w0, [x1, x20]
	add	w0, w0, 1
	strh	w0, [x1, x20]
.L2263:
	add	x1, x29, 76
	mov	w2, 1
	mov	w0, w21
	bl	log2phys
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2265:
	umull	x19, w19, w5
	ldrh	w19, [x2, x19]
	cmp	w19, w6
	beq	.L2263
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L2264
.L2262:
	add	w1, w1, 1
	strh	w1, [x2, x20]
	b	.L2263
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
	.section	.text.FtlRecoverySuperblock,"ax",@progbits
	.align	2
	.global	FtlRecoverySuperblock
	.type	FtlRecoverySuperblock, %function
FtlRecoverySuperblock:
	stp	x29, x30, [sp, -208]!
	mov	w1, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	ldrh	w0, [x0]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w0, w1
	stp	x27, x28, [sp, 80]
	beq	.L2430
	ldrb	w0, [x19, 6]
	str	w0, [x29, 180]
	adrp	x0, .LANCHOR53
	ldrh	w26, [x19, 2]
	str	x0, [x29, 144]
	ldrh	w2, [x0, #:lo12:.LANCHOR53]
	cmp	w2, w26
	bne	.L2275
	strh	wzr, [x19, 4]
.L2437:
	strb	wzr, [x19, 6]
.L2430:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	ret
.L2275:
	ldrh	w0, [x19, 16]
	mov	w21, 0
.L2276:
	cmp	w0, w1
	beq	.L2277
	ldrb	w1, [x19, 8]
	cmp	w1, 1
	bne	.L2278
	bl	FtlGetLastWrittenPage
	mov	w20, w0
	cmn	w0, #1
	beq	.L2279
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbnz	w0, .L2355
	adrp	x0, .LANCHOR16
	add	x0, x0, :lo12:.LANCHOR16
	ldrh	w23, [x0, w20, sxtw 1]
.L2280:
	adrp	x1, .LANCHOR106
	adrp	x2, .LANCHOR38
	adrp	x22, .LANCHOR180
	add	x4, x19, 16
	ldr	x6, [x1, #:lo12:.LANCHOR106]
	adrp	x1, .LANCHOR59
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	mov	w27, 0
	ldrh	w7, [x1, #:lo12:.LANCHOR59]
	add	x1, x19, 16
	str	x1, [x29, 184]
	mov	w8, 65535
	ldrh	w1, [x2, #:lo12:.LANCHOR38]
	mov	w10, 56
	str	x2, [x29, 160]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L2281:
	cmp	x1, x4
	bne	.L2285
	ldrb	w1, [x19, 8]
	cmp	w1, 1
	bne	.L2356
	adrp	x1, .LANCHOR8
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	cmp	w1, 0
	cset	w1, ne
	str	w1, [x29, 176]
.L2286:
	ldr	w2, [x29, 176]
	mov	w1, w27
	adrp	x24, .LC61
	adrp	x25, .LANCHOR235
	add	x24, x24, :lo12:.LC61
	add	x25, x25, :lo12:.LANCHOR235
	mov	x28, 0
	bl	FlashReadPages
	adrp	x0, .LANCHOR160
	mov	w5, 65535
	str	x0, [x29, 168]
	ldr	w21, [x0, #:lo12:.LANCHOR160]
	sub	w21, w21, #1
.L2287:
	and	w0, w28, 65535
	cmp	w27, w0
	bhi	.L2292
	bne	.L2290
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	add	w20, w20, 1
	and	w20, w20, 65535
	ldr	w0, [x0, 4]
.L2432:
	lsr	w0, w0, 10
	bl	P2V_plane
	ldrb	w1, [x19, 8]
	and	w27, w0, 65535
	cmp	w1, 1
	bne	.L2294
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbnz	w0, .L2294
	adrp	x0, .LANCHOR16
	add	x0, x0, :lo12:.LANCHOR16
	ldrh	w20, [x0, w20, sxtw 1]
.L2294:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w20
	bne	.L2295
	strh	w20, [x19, 2]
	strb	wzr, [x19, 6]
	strh	wzr, [x19, 4]
.L2295:
	ldr	w0, [x29, 180]
	cmp	w20, w26
	cset	w2, eq
	cmp	w27, w0
	cset	w0, eq
	tst	w2, w0
	beq	.L2296
.L2438:
	mov	w2, w27
	mov	w1, w20
	mov	x0, x19
	bl	ftl_sb_update_avl_pages
	b	.L2430
.L2277:
	add	w21, w21, 1
	and	w21, w21, 65535
	add	x0, x19, x21, sxtw 1
	ldrh	w0, [x0, 16]
	b	.L2276
.L2278:
	mov	w1, 0
	bl	FtlGetLastWrittenPage
	mov	w20, w0
	cmn	w0, #1
	beq	.L2279
.L2355:
	mov	w23, w20
	b	.L2280
.L2279:
	cbz	w26, .L2282
	mov	w2, 2141
	adrp	x1, .LANCHOR234
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR234
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2282:
	ldr	w0, [x29, 180]
	cmp	w0, 0
	ccmp	w21, w0, 4, ne
	beq	.L2283
	mov	w2, 2142
	adrp	x1, .LANCHOR234
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR234
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2283:
	strh	wzr, [x19, 2]
	b	.L2437
.L2285:
	ldrh	w2, [x4]
	cmp	w2, w8
	beq	.L2284
	umaddl	x5, w27, w10, x0
	orr	w2, w23, w2, lsl 10
	add	w3, w27, 1
	str	w2, [x5, 4]
	mul	w2, w27, w7
	and	w27, w3, 65535
	str	xzr, [x5, 8]
	asr	w2, w2, 2
	add	x2, x6, x2, sxtw 2
	str	x2, [x5, 16]
.L2284:
	add	x4, x4, 2
	b	.L2281
.L2356:
	str	wzr, [x29, 176]
	b	.L2286
.L2292:
	mov	x0, 56
	ldr	x2, [x22, #:lo12:.LANCHOR180]
	mul	x0, x28, x0
	add	x1, x2, x0
	ldr	w0, [x2, x0]
	cbnz	w0, .L2288
	ldr	x6, [x1, 16]
	ldr	w4, [x6, 4]
	cmn	w4, #1
	beq	.L2289
	ldr	x0, [x29, 168]
	ldr	w1, [x0, #:lo12:.LANCHOR160]
	mov	w0, w4
	bl	ftl_cmp_data_ver
	cbz	w0, .L2289
	ldr	x0, [x29, 168]
	add	w4, w4, 1
	str	w4, [x0, #:lo12:.LANCHOR160]
.L2289:
	ldr	w0, [x6]
	cmn	w0, #1
	bne	.L2291
.L2290:
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	and	x28, x28, 65535
	mov	x1, 56
	and	w20, w20, 65535
	madd	x28, x28, x1, x0
	ldr	w0, [x28, 4]
	b	.L2432
.L2288:
	ldr	w1, [x1, 4]
	mov	x0, x24
	bl	printf
	ldrh	w0, [x19]
	and	w5, w23, 65535
	strh	w0, [x25]
.L2291:
	add	x28, x28, 1
	b	.L2287
.L2296:
	mov	w0, 65535
	cmp	w5, w0
	bne	.L2297
	cbnz	w1, .L2298
.L2297:
	adrp	x24, .LANCHOR136
	and	w6, w23, 65535
	ldr	w0, [x24, #:lo12:.LANCHOR136]
	cmn	w0, #1
	bne	.L2299
	str	w21, [x24, #:lo12:.LANCHOR136]
.L2299:
	add	w0, w26, 7
	ldr	w7, [x24, #:lo12:.LANCHOR136]
	cmp	w0, w23, uxth
	bge	.L2357
	sub	w23, w6, #7
	and	w23, w23, 65535
.L2300:
	mov	w3, -1
	adrp	x5, .LANCHOR120
	mov	w28, w3
	add	x5, x5, :lo12:.LANCHOR120
	mov	w4, 65535
.L2301:
	cmp	w23, w6
	bhi	.L2316
	ldr	x1, [x29, 160]
	mov	w25, 0
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	mov	w10, 56
	ldr	x2, [x29, 184]
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
	b	.L2317
.L2357:
	mov	w23, w26
	b	.L2300
.L2303:
	ldrh	w8, [x2]
	cmp	w8, w4
	beq	.L2302
	umaddl	x11, w25, w10, x0
	add	w25, w25, 1
	and	w25, w25, 65535
	orr	w8, w23, w8, lsl 10
	str	w8, [x11, 4]
.L2302:
	add	x2, x2, 2
.L2317:
	cmp	x2, x1
	bne	.L2303
	ldr	w2, [x29, 176]
	mov	w1, w25
	str	x5, [x29, 112]
	str	w4, [x29, 120]
	str	w7, [x29, 128]
	str	w6, [x29, 136]
	str	w3, [x29, 152]
	bl	FlashReadPages
	adrp	x1, .LANCHOR8
	mov	w2, 56
	ldr	w0, [x24, #:lo12:.LANCHOR136]
	sxtw	x12, w23
	ldrb	w10, [x1, #:lo12:.LANCHOR8]
	mov	w11, 1
	ldr	x1, [x22, #:lo12:.LANCHOR180]
	ldr	w4, [x29, 120]
	ldr	w7, [x29, 128]
	ldr	w6, [x29, 136]
	ldr	w3, [x29, 152]
	nop // between mem op and mult-accumulate
	umaddl	x25, w25, w2, x1
	ldr	x5, [x29, 112]
	mov	w2, 0
.L2304:
	cmp	x25, x1
	bne	.L2314
	cbz	w2, .L2315
	str	w0, [x24, #:lo12:.LANCHOR136]
.L2315:
	add	w23, w23, 1
	and	w23, w23, 65535
	b	.L2301
.L2314:
	ldr	w8, [x1]
	cbnz	w8, .L2305
	ldr	x8, [x1, 16]
	ldrh	w13, [x8]
	cmp	w13, w4
	beq	.L2359
	ldr	w8, [x8, 4]
	cmn	w8, #1
	beq	.L2359
	cmn	w3, #1
	bne	.L2361
	ldrh	w2, [x5, x12, lsl 1]
	cmp	w2, w4
	bne	.L2307
	cbz	w10, .L2361
.L2307:
	cmp	w21, w0
	mov	w2, w11
	csel	w3, w3, w0, eq
.L2306:
	mov	w28, w0
	add	x1, x1, 56
	mov	w0, w8
	b	.L2304
.L2305:
	cbz	w2, .L2308
	str	w0, [x24, #:lo12:.LANCHOR136]
.L2308:
	adrp	x0, .LANCHOR235
	ldrh	w1, [x19]
	strh	w1, [x0, #:lo12:.LANCHOR235]
	ldrb	w0, [x19, 8]
	cbnz	w0, .L2298
	adrp	x0, .LANCHOR120
	add	x0, x0, :lo12:.LANCHOR120
	ldrh	w1, [x0, w23, sxtw 1]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2310
	cmn	w3, #1
	beq	.L2311
	str	w3, [x24, #:lo12:.LANCHOR136]
.L2298:
	adrp	x0, .LANCHOR236
	mov	w23, w26
	mov	w1, 1
	adrp	x28, .LANCHOR136
	strh	w1, [x0, #:lo12:.LANCHOR236]
	add	x0, x28, :lo12:.LANCHOR136
	str	x0, [x29, 112]
.L2318:
	ldr	x2, [x29, 160]
	adrp	x1, .LANCHOR8
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	mov	w24, 0
	ldrb	w5, [x1, #:lo12:.LANCHOR8]
	mov	w6, 65535
	ldr	x3, [x29, 184]
	ldrh	w2, [x2, #:lo12:.LANCHOR38]
	str	x1, [x29, 128]
	add	x2, x2, 8
	add	x2, x19, x2, lsl 1
.L2319:
	cmp	x2, x3
	bne	.L2322
	ldr	w2, [x29, 176]
	mov	w1, w24
	mov	x25, 0
	bl	FlashReadPages
	mov	w0, 56
	umull	x0, w24, w0
	str	x0, [x29, 136]
	adrp	x0, .LANCHOR235
	add	x0, x0, :lo12:.LANCHOR235
	str	x0, [x29, 120]
.L2323:
	ldr	x0, [x29, 136]
	cmp	x25, x0
	bne	.L2348
	ldrb	w0, [x19, 8]
	add	w23, w23, 1
	and	w23, w23, 65535
	cmp	w0, 1
	bne	.L2349
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L2349
	adrp	x0, .LANCHOR54
	ldrh	w0, [x0, #:lo12:.LANCHOR54]
	cmp	w0, w23
	bne	.L2349
	cmp	w20, w23
	beq	.L2325
.L2349:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w23
	bne	.L2318
	ldr	x0, [x29, 160]
	mov	w2, 65535
	strh	w23, [x19, 2]
	strh	wzr, [x19, 4]
	ldrh	w1, [x0, #:lo12:.LANCHOR38]
	mov	w0, 0
.L2350:
	cmp	w0, w1
	beq	.L2430
	ldr	x4, [x29, 184]
	ldrh	w3, [x4], 2
	str	x4, [x29, 184]
	cmp	w3, w2
	beq	.L2351
	strb	w0, [x19, 6]
	b	.L2430
.L2311:
	cmp	w21, w7
	beq	.L2312
	str	w7, [x24, #:lo12:.LANCHOR136]
	b	.L2298
.L2312:
	ldr	w0, [x24, #:lo12:.LANCHOR136]
.L2439:
	sub	w0, w0, #1
.L2433:
	str	w0, [x24, #:lo12:.LANCHOR136]
	b	.L2298
.L2310:
	cmp	w28, w21
	beq	.L2313
	cmn	w28, #1
	beq	.L2298
	str	w28, [x24, #:lo12:.LANCHOR136]
	b	.L2298
.L2313:
	ldr	w0, [x24, #:lo12:.LANCHOR136]
	cmp	w21, w0
	bne	.L2439
	b	.L2298
.L2359:
	mov	w8, w0
	mov	w0, w28
	b	.L2306
.L2361:
	mov	w2, 1
	b	.L2306
.L2316:
	mov	w0, -1
	b	.L2433
.L2322:
	ldrh	w1, [x3]
	cmp	w1, w6
	beq	.L2320
	mov	w4, 56
	orr	w1, w23, w1, lsl 10
	umaddl	x4, w24, w4, x0
	str	w1, [x4, 4]
	ldrb	w7, [x19, 8]
	cmp	w7, 1
	bne	.L2321
	cbz	w5, .L2321
	orr	w1, w1, -2147483648
	str	w1, [x4, 4]
.L2321:
	add	w24, w24, 1
	and	w24, w24, 65535
.L2320:
	add	x3, x3, 2
	b	.L2319
.L2348:
	ldr	x4, [x22, #:lo12:.LANCHOR180]
	add	x4, x4, x25
	ldr	w5, [x4, 4]
	str	w5, [x29, 204]
	lsr	w0, w5, 10
	bl	P2V_plane
	and	w0, w0, 65535
	cmp	w23, w26
	bcc	.L2324
	ldr	w1, [x29, 180]
	ccmp	w1, w0, 0, eq
	bhi	.L2324
	cmp	w23, w20
	ccmp	w27, w0, 0, eq
	beq	.L2325
	ldr	w0, [x4]
	cmn	w0, #1
	beq	.L2326
	ldr	x3, [x4, 16]
	mov	w0, 61589
	ldrh	w1, [x3]
	cmp	w1, w0
	beq	.L2327
	ldrh	w0, [x19]
.L2435:
	bl	decrement_vpc_count
	b	.L2324
.L2327:
	ldr	w21, [x3, 4]
	cmn	w21, #1
	beq	.L2328
	ldr	x0, [x29, 168]
	ldr	w1, [x0, #:lo12:.LANCHOR160]
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L2328
	ldr	x1, [x29, 168]
	add	w0, w21, 1
	str	w0, [x1, #:lo12:.LANCHOR160]
.L2328:
	ldp	w24, w0, [x3, 8]
	add	x1, x29, 200
	str	w0, [x29, 196]
	mov	w2, 0
	mov	w0, w24
	bl	log2phys
	ldr	w1, [x28, #:lo12:.LANCHOR136]
	cmn	w1, #1
	beq	.L2329
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L2329
	ldr	w1, [x29, 196]
	cmn	w1, #1
	beq	.L2330
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	mov	w2, 0
	add	x0, x0, x25
	ldr	x3, [x0, 16]
	str	w1, [x0, 4]
	mov	w1, 1
	str	x3, [x29, 152]
	bl	FlashReadPages
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	ldr	x3, [x29, 152]
	add	x4, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L2331
.L2332:
	mov	w0, -1
	str	w0, [x29, 196]
.L2339:
	ldr	w3, [x29, 196]
	cmn	w3, #1
	beq	.L2324
.L2354:
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	and	w24, w0, 65535
	adrp	x0, .LANCHOR40
	mov	w3, w24
	ldrh	w0, [x0, #:lo12:.LANCHOR40]
	cmp	w0, w24
	bhi	.L2344
	mov	w2, 2425
	adrp	x1, .LANCHOR234
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR234
	add	x0, x0, :lo12:.LC5
	str	w24, [x29, 152]
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
	ldr	w3, [x29, 152]
.L2344:
	adrp	x1, .LANCHOR84
	ubfiz	x0, x24, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR84]
	ldrh	w0, [x1, x0]
	cbz	w0, .L2345
	mov	w0, w3
	b	.L2435
.L2330:
	ldp	w1, w0, [x29, 200]
	cmp	w1, w0
	bne	.L2324
	mov	w2, 1
	add	x1, x29, 196
	mov	w0, w24
	bl	log2phys
.L2324:
	add	x25, x25, 56
	b	.L2323
.L2331:
	ldr	w0, [x3, 8]
	cmp	w24, w0
	bne	.L2332
	ldr	w0, [x3, 4]
	str	w0, [x29, 152]
	str	x3, [x29, 104]
	uxtw	x1, w0
	ldr	w0, [x28, #:lo12:.LANCHOR136]
	bl	ftl_cmp_data_ver
	cbz	w0, .L2332
	ldp	w0, w1, [x29, 200]
	ldr	x3, [x29, 104]
	cmp	w0, w1
	ldr	w1, [x29, 196]
	bne	.L2334
.L2434:
	mov	w0, w24
	bl	FtlReUsePrevPpa
	b	.L2332
.L2334:
	cmp	w0, w1
	beq	.L2332
	cmn	w0, #1
	beq	.L2335
	ldr	x3, [x4, 16]
	mov	w2, 0
	str	w0, [x4, 4]
	mov	w1, 1
	str	x3, [x29, 104]
	mov	x0, x4
	bl	FlashReadPages
	ldr	x3, [x29, 104]
.L2336:
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	ldr	w0, [x0, x25]
	cmn	w0, #1
	beq	.L2337
	ldr	x0, [x29, 112]
	ldr	w3, [x3, 4]
	mov	w1, w3
	ldr	w0, [x0]
	bl	ftl_cmp_data_ver
	cbz	w0, .L2337
	ldr	w0, [x29, 152]
	mov	w1, w3
	bl	ftl_cmp_data_ver
	cbz	w0, .L2332
.L2337:
	ldr	w1, [x29, 196]
	b	.L2434
.L2335:
	str	w0, [x4]
	b	.L2336
.L2329:
	ldp	w1, w0, [x29, 200]
	cmp	w1, w0
	beq	.L2339
	mov	w2, 1
	add	x1, x29, 204
	mov	w0, w24
	bl	log2phys
	ldr	w3, [x29, 200]
	cmn	w3, #1
	beq	.L2339
	ldr	w0, [x29, 196]
	cmp	w3, w0
	beq	.L2354
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	adrp	x1, .LANCHOR92
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR92]
	cmp	w1, w0
	beq	.L2343
	adrp	x1, .LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	cmp	w1, w0
	beq	.L2343
	adrp	x1, .LANCHOR94
	ldrh	w1, [x1, #:lo12:.LANCHOR94]
	cmp	w1, w0
	bne	.L2339
.L2343:
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	mov	w2, 0
	mov	w1, 1
	ldr	x4, [x0, 16]
	str	w3, [x0, 4]
	str	x4, [x29, 152]
	bl	FlashReadPages
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L2339
	ldr	x4, [x29, 152]
	mov	w0, w21
	ldr	w1, [x4, 4]
	bl	ftl_cmp_data_ver
	cbnz	w0, .L2339
	mov	w2, 1
	add	x1, x29, 200
	mov	w0, w24
	bl	log2phys
	b	.L2339
.L2345:
	mov	w1, w24
	adrp	x0, .LC62
	add	x0, x0, :lo12:.LC62
	bl	printf
	b	.L2324
.L2326:
	ldr	x1, [x29, 120]
	mov	w2, w21
	ldrh	w0, [x19]
	strh	w0, [x1]
	mov	w1, w5
	adrp	x0, .LC63
	add	x0, x0, :lo12:.LC63
	bl	printf
	adrp	x2, .LANCHOR237
	ldr	w0, [x2, #:lo12:.LANCHOR237]
	cmp	w0, 31
	bhi	.L2346
	adrp	x1, .LANCHOR238
	add	x1, x1, :lo12:.LANCHOR238
	ldr	w3, [x29, 204]
	str	w3, [x1, w0, uxtw 2]
	add	w0, w0, 1
	str	w0, [x2, #:lo12:.LANCHOR237]
.L2346:
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	ldr	w0, [x28, #:lo12:.LANCHOR136]
	cmn	w0, #1
	bne	.L2347
.L2436:
	str	w21, [x28, #:lo12:.LANCHOR136]
	b	.L2324
.L2347:
	cmp	w21, w0
	bcs	.L2324
	b	.L2436
.L2351:
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L2350
.L2325:
	strb	w27, [x19, 6]
	strh	w20, [x19, 2]
	b	.L2438
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
	.section	.text.FtlGcFreeTempBlock,"ax",@progbits
	.align	2
	.global	FtlGcFreeTempBlock
	.type	FtlGcFreeTempBlock, %function
FtlGcFreeTempBlock:
	adrp	x0, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	cbz	w0, .L2441
	mov	w0, 0
	ret
.L2441:
	stp	x29, x30, [sp, -112]!
	mov	w1, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR94
	stp	x21, x22, [sp, 32]
	add	x0, x19, :lo12:.LANCHOR94
	ldrh	w20, [x19, #:lo12:.LANCHOR94]
	adrp	x21, .LANCHOR135
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w20, w1
	str	x27, [sp, 80]
	beq	.L2443
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	bl	FtlGcScanTempBlk
	str	w0, [x29, 108]
	cmn	w0, #1
	beq	.L2443
	adrp	x0, .LANCHOR79
	ubfiz	x20, x20, 1, 16
	ldr	x1, [x0, #:lo12:.LANCHOR79]
	ldrh	w0, [x1, x20]
	cmp	w0, 4
	bls	.L2444
	sub	w0, w0, #5
	strh	w0, [x1, x20]
	mov	w0, 1
	bl	FtlEctTblFlush
.L2444:
	ldr	w0, [x21, #:lo12:.LANCHOR135]
	cbnz	w0, .L2445
	adrp	x0, .LANCHOR138
	add	x0, x0, :lo12:.LANCHOR138
	ldr	w1, [x0, 96]
	add	w1, w1, 1
	str	w1, [x0, 96]
	ldr	w0, [x29, 108]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L2445:
	str	wzr, [x21, #:lo12:.LANCHOR135]
	mov	w0, 1
.L2440:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2443:
	str	wzr, [x21, #:lo12:.LANCHOR135]
	mov	w0, 65535
	ldrh	w1, [x19, #:lo12:.LANCHOR94]
	add	x21, x19, :lo12:.LANCHOR94
	cmp	w1, w0
	beq	.L2466
	bl	FtlCacheWriteBack
	adrp	x20, .LANCHOR111
	adrp	x0, .LANCHOR53
	ldrb	w1, [x21, 7]
	ldrh	w2, [x20, #:lo12:.LANCHOR111]
	mov	x21, x0
	ldrh	w3, [x0, #:lo12:.LANCHOR53]
	mul	w1, w1, w3
	cmp	w2, w1
	beq	.L2447
	mov	w2, 163
	adrp	x1, .LANCHOR239
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR239
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2447:
	add	x0, x19, :lo12:.LANCHOR94
	adrp	x23, .LANCHOR84
	ldrh	w3, [x21, #:lo12:.LANCHOR53]
	adrp	x25, .LANCHOR73
	ldrh	w2, [x19, #:lo12:.LANCHOR94]
	adrp	x26, .LANCHOR239
	ldrb	w0, [x0, 7]
	add	x25, x25, :lo12:.LANCHOR73
	ldr	x1, [x23, #:lo12:.LANCHOR84]
	add	x26, x26, :lo12:.LANCHOR239
	mov	w21, 0
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	adrp	x1, .LANCHOR161
	ldrh	w0, [x20, #:lo12:.LANCHOR111]
	ldr	w2, [x1, #:lo12:.LANCHOR161]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR161]
.L2448:
	ldrh	w0, [x20, #:lo12:.LANCHOR111]
	cmp	w0, w21
	bhi	.L2452
	mov	w0, -1
	bl	decrement_vpc_count
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L2453
	ldrh	w1, [x19, #:lo12:.LANCHOR94]
	adrp	x0, .LC64
	add	x0, x0, :lo12:.LC64
	bl	printf
.L2453:
	ldrh	w0, [x19, #:lo12:.LANCHOR94]
	ldr	x2, [x23, #:lo12:.LANCHOR84]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbz	w1, .L2454
	bl	INSERT_DATA_LIST
.L2455:
	adrp	x0, .LANCHOR109
	mov	w21, -1
	strh	wzr, [x20, #:lo12:.LANCHOR111]
	strh	w21, [x19, #:lo12:.LANCHOR94]
	strh	wzr, [x0, #:lo12:.LANCHOR109]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	adrp	x0, .LANCHOR204
	strh	w21, [x0, #:lo12:.LANCHOR204]
	adrp	x0, .LANCHOR89
	ldrh	w1, [x0, #:lo12:.LANCHOR89]
	adrp	x0, .LANCHOR223
	ldrh	w0, [x0, #:lo12:.LANCHOR223]
	add	w0, w0, w0, lsl 1
	cmp	w1, w0, lsr 2
	ble	.L2466
	adrp	x0, .LANCHOR176
	mov	w1, 20
	strh	w1, [x0, #:lo12:.LANCHOR176]
.L2466:
	mov	w0, 0
	b	.L2440
.L2452:
	adrp	x0, .LANCHOR112
	mov	w24, 12
	ldr	x27, [x0, #:lo12:.LANCHOR112]
	umull	x24, w21, w24
	ldr	w0, [x25]
	add	x22, x27, x24
	ldr	w1, [x22, 8]
	cmp	w1, w0
	bcc	.L2449
	mov	w2, 168
	mov	x1, x26
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2449:
	ldr	w0, [x22, 8]
	add	x1, x29, 108
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x27, x24]
	ldr	w1, [x29, 108]
	cmp	w0, w1
	bne	.L2450
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	mov	w24, w0
	ldr	w0, [x22, 8]
	mov	w2, 1
	add	x1, x22, 4
	bl	log2phys
	mov	w0, w24
.L2465:
	bl	decrement_vpc_count
.L2451:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L2448
.L2450:
	ldr	w0, [x22, 4]
	cmp	w1, w0
	beq	.L2451
	ldrh	w0, [x19, #:lo12:.LANCHOR94]
	b	.L2465
.L2454:
	bl	INSERT_FREE_LIST
	b	.L2455
	.size	FtlGcFreeTempBlock, .-FtlGcFreeTempBlock
	.section	.text.FtlGcPageRecovery,"ax",@progbits
	.align	2
	.global	FtlGcPageRecovery
	.type	FtlGcPageRecovery, %function
FtlGcPageRecovery:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR53
	adrp	x19, .LANCHOR94
	add	x19, x19, :lo12:.LANCHOR94
	ldrh	w1, [x20, #:lo12:.LANCHOR53]
	mov	x0, x19
	bl	FtlGcScanTempBlk
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bcc	.L2467
	adrp	x0, .LANCHOR127
	add	x0, x0, :lo12:.LANCHOR127
	bl	FtlMapBlkWriteDumpData
	mov	w0, 0
	bl	FtlGcFreeTempBlock
	adrp	x0, .LANCHOR135
	str	wzr, [x0, #:lo12:.LANCHOR135]
.L2467:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FtlGcPageRecovery, .-FtlGcPageRecovery
	.section	.text.FtlPowerLostRecovery,"ax",@progbits
	.align	2
	.global	FtlPowerLostRecovery
	.type	FtlPowerLostRecovery, %function
FtlPowerLostRecovery:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR237
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR92
	add	x19, x19, :lo12:.LANCHOR92
	str	wzr, [x0, #:lo12:.LANCHOR237]
	mov	x0, x19
	bl	FtlRecoverySuperblock
	mov	x0, x19
	adrp	x19, .LANCHOR93
	bl	FtlSlcSuperblockCheck
	add	x19, x19, :lo12:.LANCHOR93
	mov	x0, x19
	bl	FtlRecoverySuperblock
	mov	x0, x19
	bl	FtlSlcSuperblockCheck
	bl	FtlGcPageRecovery
	mov	w0, -1
	bl	decrement_vpc_count
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FtlPowerLostRecovery, .-FtlPowerLostRecovery
	.section	.text.FtlSysBlkInit,"ax",@progbits
	.align	2
	.global	FtlSysBlkInit
	.type	FtlSysBlkInit, %function
FtlSysBlkInit:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR235
	mov	w1, -1
	add	x29, sp, 0
	strh	w1, [x0, #:lo12:.LANCHOR235]
	adrp	x0, .LANCHOR39
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR236
	ldrh	w0, [x0, #:lo12:.LANCHOR39]
	strh	wzr, [x20, #:lo12:.LANCHOR236]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	adrp	x0, .LANCHOR209
	ldrh	w1, [x0, #:lo12:.LANCHOR209]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2473
.L2475:
	mov	w19, -1
.L2472:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2473:
	bl	FtlLoadSysInfo
	mov	w19, w0
	cbnz	w0, .L2475
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	mov	w0, 1
	bl	FtlUpdateVaildLpn
	adrp	x2, .LANCHOR68
	adrp	x0, .LANCHOR97
	mov	x3, 4
	ldrh	w2, [x2, #:lo12:.LANCHOR68]
	ldr	x0, [x0, #:lo12:.LANCHOR97]
	add	x2, x3, x2, uxtw 4
	add	x1, x0, 4
	add	x0, x0, x2
.L2476:
	cmp	x1, x0
	bne	.L2478
	ldrh	w0, [x20, #:lo12:.LANCHOR236]
	cbnz	w0, .L2477
	bl	l2p_flush
	b	.L2481
.L2478:
	ldr	w2, [x1], 16
	tbz	w2, #31, .L2476
.L2477:
	adrp	x0, .LANCHOR84
	adrp	x1, .LANCHOR92
	ldr	x2, [x0, #:lo12:.LANCHOR84]
	add	x0, x1, :lo12:.LANCHOR92
	ldrh	w1, [x1, #:lo12:.LANCHOR92]
	ldrh	w4, [x0, 4]
	lsl	x1, x1, 1
	ldrh	w3, [x2, x1]
	sub	w3, w3, w4
	adrp	x4, .LANCHOR53
	strh	w3, [x2, x1]
	strh	wzr, [x0, 4]
	ldrh	w1, [x4, #:lo12:.LANCHOR53]
	strh	w1, [x0, 2]
	adrp	x1, .LANCHOR93
	strb	wzr, [x0, 6]
	add	x0, x1, :lo12:.LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	ldrh	w5, [x0, 4]
	lsl	x1, x1, 1
	ldrh	w3, [x2, x1]
	sub	w3, w3, w5
	strh	w3, [x2, x1]
	strb	wzr, [x0, 6]
	ldrh	w1, [x4, #:lo12:.LANCHOR53]
	strh	w1, [x0, 2]
	strh	wzr, [x0, 4]
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	ldrh	w1, [x0, 30]
	add	w1, w1, 1
	strh	w1, [x0, 30]
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2481:
	bl	FtlVpcTblFlush
	b	.L2472
	.size	FtlSysBlkInit, .-FtlSysBlkInit
	.section	.text.FtlLowFormat,"ax",@progbits
	.align	2
	.global	FtlLowFormat
	.type	FtlLowFormat, %function
FtlLowFormat:
	adrp	x0, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	cbnz	w0, .L2514
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR195
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR67
	ldr	x0, [x0, #:lo12:.LANCHOR195]
	adrp	x20, .LANCHOR159
	ldrh	w2, [x19, #:lo12:.LANCHOR67]
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR39
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR131
	ldrh	w2, [x19, #:lo12:.LANCHOR67]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR131]
	lsl	w2, w2, 2
	bl	ftl_memset
	str	wzr, [x20, #:lo12:.LANCHOR159]
	adrp	x0, .LANCHOR160
	str	wzr, [x0, #:lo12:.LANCHOR160]
	ldrh	w0, [x25, #:lo12:.LANCHOR39]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	w0, .L2485
	bl	FtlMakeBbt
.L2485:
	adrp	x22, .LANCHOR56
	adrp	x0, .LANCHOR186
	mov	w6, 23752
	ldrh	w1, [x22, #:lo12:.LANCHOR56]
	movk	w6, 0xa0f, lsl 16
	ldr	x4, [x0, #:lo12:.LANCHOR186]
	adrp	x0, .LANCHOR187
	lsl	w1, w1, 7
	ldr	x5, [x0, #:lo12:.LANCHOR187]
	mov	w0, 0
.L2486:
	cmp	w0, w1
	blt	.L2487
	adrp	x21, .LANCHOR40
	adrp	x19, .LANCHOR41
	add	x26, x19, :lo12:.LANCHOR41
	mov	w23, 0
	ldrh	w24, [x21, #:lo12:.LANCHOR40]
.L2488:
	ldrh	w0, [x26]
	cmp	w0, w24
	bhi	.L2489
	adrp	x24, .LANCHOR38
	sub	w1, w23, #2
	ldrh	w0, [x24, #:lo12:.LANCHOR38]
	cmp	w1, w0, lsl 1
	bgt	.L2490
.L2494:
	add	x26, x21, :lo12:.LANCHOR40
	mov	w23, 0
	mov	w25, 0
.L2491:
	ldrh	w0, [x26]
	cmp	w0, w25
	bhi	.L2495
	adrp	x0, .LANCHOR74
	ldrh	w1, [x19, #:lo12:.LANCHOR41]
	ldrh	w3, [x24, #:lo12:.LANCHOR38]
	str	w1, [x0, #:lo12:.LANCHOR74]
	adrp	x0, .LANCHOR42
	adrp	x1, .LANCHOR223
	ldr	w2, [x0, #:lo12:.LANCHOR42]
	adrp	x0, .LANCHOR73
	udiv	w6, w2, w3
	ubfx	x5, x6, 5, 16
	str	w6, [x0, #:lo12:.LANCHOR73]
	add	w4, w5, 36
	strh	w4, [x1, #:lo12:.LANCHOR223]
	mov	w4, 24
	mul	w4, w3, w4
	cmp	w23, w4
	ble	.L2496
	sub	w2, w2, w23
	udiv	w2, w2, w3
	str	w2, [x0, #:lo12:.LANCHOR73]
	lsr	w2, w2, 5
	add	w2, w2, 24
	strh	w2, [x1, #:lo12:.LANCHOR223]
.L2496:
	adrp	x2, .LANCHOR28
	ldr	w2, [x2, #:lo12:.LANCHOR28]
	cmp	w2, 1
	bne	.L2497
	udiv	w4, w23, w3
	ldrh	w2, [x1, #:lo12:.LANCHOR223]
	add	w4, w4, w2
	add	w4, w2, w4, asr 2
	strh	w4, [x1, #:lo12:.LANCHOR223]
.L2497:
	adrp	x2, .LANCHOR8
	ldrb	w2, [x2, #:lo12:.LANCHOR8]
	cbz	w2, .L2498
	udiv	w4, w23, w3
	ldrh	w2, [x1, #:lo12:.LANCHOR223]
	add	w4, w4, w2
	add	w4, w2, w4, asr 2
	strh	w4, [x1, #:lo12:.LANCHOR223]
.L2498:
	adrp	x2, .LANCHOR49
	ldrh	w2, [x2, #:lo12:.LANCHOR49]
	cbz	w2, .L2500
	ldrh	w4, [x1, #:lo12:.LANCHOR223]
	add	w4, w4, w2, lsr 1
	strh	w4, [x1, #:lo12:.LANCHOR223]
	mul	w4, w2, w3
	cmp	w23, w4
	bge	.L2500
	add	w2, w2, 32
	str	w6, [x0, #:lo12:.LANCHOR73]
	add	w2, w5, w2
	strh	w2, [x1, #:lo12:.LANCHOR223]
.L2500:
	ldrh	w2, [x1, #:lo12:.LANCHOR223]
	adrp	x25, .LANCHOR222
	ldr	w1, [x0, #:lo12:.LANCHOR73]
	adrp	x24, .LANCHOR84
	mov	w23, -1
	sub	w1, w1, w2
	mul	w3, w1, w3
	adrp	x1, .LANCHOR53
	str	w3, [x25, #:lo12:.LANCHOR222]
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	mul	w3, w1, w3
	str	w3, [x0, #:lo12:.LANCHOR73]
	ldrh	w0, [x22, #:lo12:.LANCHOR56]
	mul	w3, w0, w3
	adrp	x0, .LANCHOR69
	str	w3, [x0, #:lo12:.LANCHOR69]
	bl	FtlBbmTblFlush
	ldr	x0, [x24, #:lo12:.LANCHOR84]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR41]
	lsl	w2, w2, 1
	bl	ftl_memset
	adrp	x0, .LANCHOR101
	adrp	x1, .LANCHOR204
	ldrh	w2, [x21, #:lo12:.LANCHOR40]
	str	wzr, [x0, #:lo12:.LANCHOR101]
	add	x0, x1, :lo12:.LANCHOR204
	strh	w23, [x1, #:lo12:.LANCHOR204]
	mov	w1, 255
	lsr	w2, w2, 3
	strh	wzr, [x0, 2]
	strb	wzr, [x0, 6]
	strb	wzr, [x0, 8]
	adrp	x0, .LANCHOR92
	add	x19, x0, :lo12:.LANCHOR92
	strh	wzr, [x0, #:lo12:.LANCHOR92]
	mov	w0, 1
	strb	w0, [x19, 8]
	adrp	x0, .LANCHOR0
	strh	wzr, [x19, 2]
	ldr	x0, [x0, #:lo12:.LANCHOR0]
	strb	wzr, [x19, 6]
	bl	ftl_memset
.L2502:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L2503
	ldr	x1, [x24, #:lo12:.LANCHOR84]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L2502
.L2487:
	ubfiz	x3, x0, 2, 16
	mvn	w2, w0
	orr	w2, w0, w2, lsl 16
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w2, [x4, x3]
	str	w6, [x5, x3]
	b	.L2486
.L2489:
	mov	w0, w24
	mov	w1, 1
	add	w24, w24, 1
	bl	FtlLowFormatEraseBlock
	add	w23, w23, w0
	and	w24, w24, 65535
	and	w23, w23, 65535
	b	.L2488
.L2490:
	udiv	w0, w23, w0
	adrp	x1, .LANCHOR66
	ldr	w23, [x1, #:lo12:.LANCHOR66]
	add	w0, w0, w23
	bl	FtlSysBlkNumInit
	ldrh	w0, [x25, #:lo12:.LANCHOR39]
	add	x25, x19, :lo12:.LANCHOR41
	bl	FtlFreeSysBlkQueueInit
	ldrh	w23, [x21, #:lo12:.LANCHOR40]
.L2492:
	ldrh	w0, [x25]
	cmp	w0, w23
	bls	.L2494
	mov	w0, w23
	add	w23, w23, 1
	mov	w1, 1
	and	w23, w23, 65535
	bl	FtlLowFormatEraseBlock
	b	.L2492
.L2495:
	mov	w0, w25
	mov	w1, 0
	add	w25, w25, 1
	bl	FtlLowFormatEraseBlock
	add	w23, w23, w0
	and	w25, w25, 65535
	and	w23, w23, 65535
	b	.L2491
.L2503:
	ldr	w1, [x20, #:lo12:.LANCHOR159]
	ubfiz	x0, x0, 1, 16
	str	w1, [x19, 12]
	mov	w23, -1
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR159]
	ldr	x1, [x24, #:lo12:.LANCHOR84]
	ldrh	w2, [x19, 4]
	strh	w2, [x1, x0]
	adrp	x2, .LANCHOR93
	add	x0, x2, :lo12:.LANCHOR93
	ldrh	w1, [x19]
	mov	x19, x0
	add	w1, w1, 1
	strh	wzr, [x0, 2]
	strh	w1, [x2, #:lo12:.LANCHOR93]
	mov	w1, 1
	strb	wzr, [x0, 6]
	strb	w1, [x0, 8]
.L2504:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L2505
	ldr	x1, [x24, #:lo12:.LANCHOR84]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L2504
.L2505:
	ldr	w1, [x20, #:lo12:.LANCHOR159]
	ubfiz	x0, x0, 1, 16
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR159]
	ldr	x1, [x24, #:lo12:.LANCHOR84]
	ldrh	w2, [x19, 4]
	mov	w19, -1
	strh	w2, [x1, x0]
	adrp	x0, .LANCHOR94
	strh	w19, [x0, #:lo12:.LANCHOR94]
	bl	FtlFreeSysBlkQueueOut
	adrp	x2, .LANCHOR209
	add	x1, x2, :lo12:.LANCHOR209
	strh	w0, [x2, #:lo12:.LANCHOR209]
	ldr	w0, [x25, #:lo12:.LANCHOR222]
	strh	w0, [x1, 6]
	ldr	w0, [x20, #:lo12:.LANCHOR159]
	str	w0, [x1, 8]
	add	w0, w0, 1
	strh	wzr, [x1, 2]
	strh	w19, [x1, 4]
	str	w0, [x20, #:lo12:.LANCHOR159]
	bl	FtlVpcTblFlush
	bl	FtlSysBlkInit
	cbnz	w0, .L2484
	adrp	x0, .LANCHOR231
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR231]
.L2484:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2514:
	mov	w0, 0
	ret
	.size	FtlLowFormat, .-FtlLowFormat
	.section	.text.Ftl_get_new_temp_ppa,"ax",@progbits
	.align	2
	.global	Ftl_get_new_temp_ppa
	.type	Ftl_get_new_temp_ppa, %function
Ftl_get_new_temp_ppa:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR94
	mov	w2, 65535
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	x19, x0
	ldrh	w3, [x0, #:lo12:.LANCHOR94]
	cmp	w3, w2
	beq	.L2518
	add	x1, x0, :lo12:.LANCHOR94
	ldrh	w0, [x1, 4]
	cbnz	w0, .L2519
.L2518:
	bl	FtlCacheWriteBack
	mov	w0, 0
	bl	FtlGcFreeTempBlock
	add	x0, x19, :lo12:.LANCHOR94
	strb	wzr, [x0, 8]
	bl	allocate_data_superblock
	adrp	x0, .LANCHOR109
	strh	wzr, [x0, #:lo12:.LANCHOR109]
	adrp	x0, .LANCHOR111
	strh	wzr, [x0, #:lo12:.LANCHOR111]
	bl	l2p_flush
	mov	w0, 0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2519:
	add	x0, x19, :lo12:.LANCHOR94
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	get_new_active_ppa
	.size	Ftl_get_new_temp_ppa, .-Ftl_get_new_temp_ppa
	.section	.text.Ftl_gc_temp_data_write_back,"ax",@progbits
	.align	2
	.global	Ftl_gc_temp_data_write_back
	.type	Ftl_gc_temp_data_write_back, %function
Ftl_gc_temp_data_write_back:
	adrp	x0, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR77]
	cbz	w0, .L2522
	mov	w0, 0
	ret
.L2525:
	mov	w0, 0
.L2521:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2522:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR8
	add	x29, sp, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR103
	cbz	w0, .L2524
	ldr	w0, [x19, #:lo12:.LANCHOR103]
	tbz	x0, 0, .L2524
	adrp	x0, .LANCHOR94+4
	ldrh	w0, [x0, #:lo12:.LANCHOR94+4]
	cbnz	w0, .L2525
.L2524:
	adrp	x20, .LANCHOR181
	ldr	w1, [x19, #:lo12:.LANCHOR103]
	mov	w3, 0
	mov	w2, 0
	ldr	x0, [x20, #:lo12:.LANCHOR181]
	add	x19, x19, :lo12:.LANCHOR103
	bl	FlashProgPages
	mov	w11, 0
	mov	w12, 56
.L2526:
	ldr	w1, [x19]
	cmp	w11, w1
	bcc	.L2528
	ldr	x0, [x20, #:lo12:.LANCHOR181]
	bl	FtlGcBufFree
	str	wzr, [x19]
	adrp	x0, .LANCHOR94+4
	ldrh	w0, [x0, #:lo12:.LANCHOR94+4]
	cbnz	w0, .L2525
	mov	w0, 1
	bl	FtlGcFreeTempBlock
	b	.L2538
.L2528:
	umull	x0, w11, w12
	ldr	x2, [x20, #:lo12:.LANCHOR181]
	add	x1, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L2527
	adrp	x0, .LANCHOR94
	adrp	x3, .LANCHOR84
	ldrh	w4, [x0, #:lo12:.LANCHOR94]
	ldr	x3, [x3, #:lo12:.LANCHOR84]
	strh	wzr, [x3, x4, lsl 1]
	strh	w2, [x0, #:lo12:.LANCHOR94]
	adrp	x0, .LANCHOR138
	add	x0, x0, :lo12:.LANCHOR138
	ldr	w2, [x0, 96]
	add	w2, w2, 1
	str	w2, [x0, 96]
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
.L2538:
	mov	w0, 1
	b	.L2521
.L2527:
	ldr	x0, [x1, 16]
	ldr	w1, [x1, 4]
	ldp	w2, w0, [x0, 8]
	bl	FtlGcUpdatePage
	add	w11, w11, 1
	and	w11, w11, 65535
	b	.L2526
	.size	Ftl_gc_temp_data_write_back, .-Ftl_gc_temp_data_write_back
	.section	.text.rk_ftl_garbage_collect,"ax",@progbits
	.align	2
	.global	rk_ftl_garbage_collect
	.type	rk_ftl_garbage_collect, %function
rk_ftl_garbage_collect:
	adrp	x1, .LANCHOR77
	ldr	w1, [x1, #:lo12:.LANCHOR77]
	cbnz	w1, .L2591
	stp	x29, x30, [sp, -192]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR171
	stp	x19, x20, [sp, 16]
	ldr	w1, [x21, #:lo12:.LANCHOR171]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w1, .L2593
	adrp	x1, .LANCHOR86
	ldrh	w1, [x1, #:lo12:.LANCHOR86]
	cmp	w1, 47
	bls	.L2593
	adrp	x5, .LANCHOR114
	mov	w2, 65535
	ldrh	w8, [x5, #:lo12:.LANCHOR114]
	cmp	w8, w2
	beq	.L2541
	adrp	x7, .LANCHOR113
	ldrh	w1, [x7, #:lo12:.LANCHOR113]
	cmp	w1, w2
	bne	.L2541
	adrp	x3, .LANCHOR115
	ldrh	w6, [x3, #:lo12:.LANCHOR115]
	cmp	w6, w1
	beq	.L2541
	adrp	x2, .LANCHOR116
	ldrh	w4, [x2, #:lo12:.LANCHOR116]
	cmp	w4, w1
	beq	.L2541
	mov	w1, -1
	strh	w8, [x7, #:lo12:.LANCHOR113]
	strh	w6, [x5, #:lo12:.LANCHOR114]
	strh	w4, [x3, #:lo12:.LANCHOR115]
	strh	w1, [x2, #:lo12:.LANCHOR116]
.L2541:
	cbnz	w0, .L2594
	adrp	x0, .LANCHOR89
	ldrh	w0, [x0, #:lo12:.LANCHOR89]
	cmp	w0, 24
	bhi	.L2595
	adrp	x1, .LANCHOR53
	cmp	w0, 16
	ldrh	w20, [x1, #:lo12:.LANCHOR53]
	bls	.L2544
	lsr	w20, w20, 5
.L2543:
	adrp	x2, .LANCHOR176
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR176]
	cmp	w1, w0
	bcs	.L2547
	adrp	x0, .LANCHOR94
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR94]
	cmp	w0, w1
	bne	.L2548
	adrp	x1, .LANCHOR113
	ldrh	w1, [x1, #:lo12:.LANCHOR113]
	cmp	w1, w0
	bne	.L2548
	adrp	x0, .LANCHOR240
	ldrh	w0, [x0, #:lo12:.LANCHOR240]
	cbnz	w0, .L2549
	adrp	x1, .LANCHOR73
	adrp	x4, .LANCHOR101
	ldr	w1, [x1, #:lo12:.LANCHOR73]
	ldr	w4, [x4, #:lo12:.LANCHOR101]
	add	w1, w1, w1, lsl 1
	cmp	w4, w1, lsr 2
	bcs	.L2550
.L2549:
	adrp	x1, .LANCHOR223
	ldrh	w1, [x1, #:lo12:.LANCHOR223]
	add	w1, w1, w1, lsl 1
	asr	w1, w1, 2
	strh	w1, [x3, #:lo12:.LANCHOR176]
.L2551:
	adrp	x1, .LANCHOR172
	str	wzr, [x1, #:lo12:.LANCHOR172]
.L2539:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L2544:
	cmp	w0, 12
	bls	.L2545
	lsr	w20, w20, 4
	b	.L2543
.L2545:
	cmp	w0, 8
	bls	.L2543
	lsr	w20, w20, 2
	b	.L2543
.L2595:
	mov	w20, 1
	b	.L2543
.L2550:
	mov	w1, 18
	strh	w1, [x2, #:lo12:.LANCHOR176]
	b	.L2551
.L2548:
	adrp	x0, .LANCHOR223
	ldrh	w0, [x0, #:lo12:.LANCHOR223]
	add	w0, w0, w0, lsl 1
	asr	w0, w0, 2
	strh	w0, [x3, #:lo12:.LANCHOR176]
.L2547:
	adrp	x0, .LANCHOR117
	ldrh	w0, [x0, #:lo12:.LANCHOR117]
	cbz	w0, .L2542
	add	w20, w20, 32
	and	w20, w20, 65535
.L2542:
	adrp	x19, .LANCHOR204
	mov	w0, 65535
	ldrh	w2, [x19, #:lo12:.LANCHOR204]
	cmp	w2, w0
	bne	.L2554
	adrp	x0, .LANCHOR113
	ldrh	w1, [x0, #:lo12:.LANCHOR113]
	cmp	w1, w2
	beq	.L2555
	adrp	x2, .LANCHOR84
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR84]
	ldrh	w1, [x2, x1]
	cbnz	w1, .L2556
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR113]
.L2556:
	ldrh	w1, [x0, #:lo12:.LANCHOR113]
	strh	w1, [x19, #:lo12:.LANCHOR204]
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR113]
.L2555:
	add	x0, x19, :lo12:.LANCHOR204
	mov	w1, 65535
	strb	wzr, [x0, 8]
	ldrh	w0, [x19, #:lo12:.LANCHOR204]
	cmp	w0, w1
	beq	.L2554
	bl	IsBlkInGcList
	cbz	w0, .L2558
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR204]
.L2558:
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L2559
	ldrh	w0, [x19, #:lo12:.LANCHOR204]
	add	x3, x19, :lo12:.LANCHOR204
	bl	ftl_get_blk_mode
	strb	w0, [x3, 8]
.L2559:
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	mov	w0, 65535
	add	x22, x19, :lo12:.LANCHOR204
	cmp	w1, w0
	beq	.L2554
	mov	x0, x22
	bl	make_superblock
	adrp	x0, .LANCHOR241
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	strh	wzr, [x22, 2]
	strh	wzr, [x0, #:lo12:.LANCHOR241]
	adrp	x0, .LANCHOR84
	strb	wzr, [x22, 6]
	ldr	x0, [x0, #:lo12:.LANCHOR84]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR242
	strh	w1, [x0, #:lo12:.LANCHOR242]
.L2554:
	adrp	x0, .LANCHOR92
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	str	x0, [x29, 144]
	ldrh	w2, [x0, #:lo12:.LANCHOR92]
	cmp	w2, w1
	beq	.L2560
	adrp	x0, .LANCHOR93
	str	x0, [x29, 136]
	ldrh	w2, [x0, #:lo12:.LANCHOR93]
	cmp	w2, w1
	beq	.L2560
	adrp	x23, .LANCHOR178
	add	x0, x23, :lo12:.LANCHOR178
	str	x0, [x29, 168]
.L2561:
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2562
	adrp	x0, .LANCHOR172
	adrp	x22, .LANCHOR53
	add	x22, x22, :lo12:.LANCHOR53
	str	wzr, [x0, #:lo12:.LANCHOR172]
.L2563:
	ldrh	w5, [x23, #:lo12:.LANCHOR178]
	add	x7, x23, :lo12:.LANCHOR178
	mov	w0, w5
	bl	List_get_gc_head_node
	and	w6, w0, 65535
	strh	w6, [x19, #:lo12:.LANCHOR204]
	mov	w0, 65535
	cmp	w6, w0
	bne	.L2564
	strh	wzr, [x7]
	mov	w0, 8
	b	.L2539
.L2594:
	mov	w20, 1
	b	.L2542
.L2560:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR204]
.L2630:
	adrp	x0, .LANCHOR240
	ldrh	w0, [x0, #:lo12:.LANCHOR240]
	b	.L2539
.L2564:
	mov	w0, w6
	bl	IsBlkInGcList
	add	w5, w5, 1
	cbz	w0, .L2565
	strh	w5, [x23, #:lo12:.LANCHOR178]
	b	.L2563
.L2565:
	adrp	x24, .LANCHOR84
	adrp	x4, .LANCHOR38
	ldrh	w0, [x22]
	ubfiz	x1, x6, 1, 16
	ldr	x2, [x24, #:lo12:.LANCHOR84]
	and	w5, w5, 65535
	ldrh	w4, [x4, #:lo12:.LANCHOR38]
	strh	w5, [x23, #:lo12:.LANCHOR178]
	ldrh	w3, [x2, x1]
	mul	w0, w0, w4
	cmp	w3, w0, asr 1
	bgt	.L2567
	cmp	w5, 48
	bls	.L2568
	cmp	w3, 8
	bls	.L2568
	adrp	x3, .LANCHOR109
	ldrh	w3, [x3, #:lo12:.LANCHOR109]
	cmp	w3, 35
	bhi	.L2568
.L2567:
	ldr	x3, [x29, 168]
	strh	wzr, [x3]
.L2568:
	ldrh	w1, [x2, x1]
	cmp	w0, w1
	bgt	.L2569
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR204]
	adrp	x0, .LANCHOR178
	strh	wzr, [x0, #:lo12:.LANCHOR178]
	b	.L2630
.L2569:
	cbnz	w1, .L2570
	mov	w0, -1
	bl	decrement_vpc_count
	ldr	x0, [x29, 168]
	ldr	x1, [x29, 168]
	ldrh	w0, [x0]
	add	w0, w0, 1
	strh	w0, [x1]
	b	.L2563
.L2570:
	adrp	x0, .LANCHOR8
	add	x3, x19, :lo12:.LANCHOR204
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	strb	wzr, [x3, 8]
	cbz	w0, .L2571
	mov	w0, w6
	bl	ftl_get_blk_mode
	strb	w0, [x3, 8]
.L2571:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w0, w6
	bne	.L2572
	mov	w2, 857
	adrp	x1, .LANCHOR243
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR243
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2572:
	ldr	x0, [x29, 136]
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w1, w0
	bne	.L2573
	mov	w2, 858
	adrp	x1, .LANCHOR243
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR243
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2573:
	adrp	x0, .LANCHOR94
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	ldrh	w0, [x0, #:lo12:.LANCHOR94]
	cmp	w1, w0
	bne	.L2574
	mov	w2, 859
	adrp	x1, .LANCHOR243
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR243
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2574:
	add	x22, x19, :lo12:.LANCHOR204
	mov	x0, x22
	bl	make_superblock
	adrp	x0, .LANCHOR241
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	strh	wzr, [x0, #:lo12:.LANCHOR241]
	ldr	x0, [x24, #:lo12:.LANCHOR84]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR242
	strh	wzr, [x22, 2]
	strh	w1, [x0, #:lo12:.LANCHOR242]
	strb	wzr, [x22, 6]
.L2562:
	mov	w0, 1
	str	w0, [x21, #:lo12:.LANCHOR171]
	adrp	x0, .LANCHOR8
	adrp	x1, .LANCHOR53
	stp	x0, x1, [x29, 120]
	ldrb	w2, [x0, #:lo12:.LANCHOR8]
	ldrh	w26, [x1, #:lo12:.LANCHOR53]
	cbz	w2, .L2575
	add	x0, x19, :lo12:.LANCHOR204
	ldrb	w0, [x0, 8]
	cmp	w0, 1
	bne	.L2575
	adrp	x0, .LANCHOR54
	ldrh	w26, [x0, #:lo12:.LANCHOR54]
.L2575:
	add	x0, x19, :lo12:.LANCHOR204
	ldrh	w0, [x0, 2]
	add	w1, w0, w20
	cmp	w1, w26
	ble	.L2576
	sub	w20, w26, w0
	and	w20, w20, 65535
.L2576:
	adrp	x0, .LANCHOR241
	mov	w27, 0
	add	x0, x0, :lo12:.LANCHOR241
	str	x0, [x29, 160]
.L2577:
	cmp	w20, w27, uxth
	bls	.L2585
	add	x1, x19, :lo12:.LANCHOR204
	adrp	x0, .LANCHOR38
	adrp	x24, .LANCHOR107
	add	x1, x1, 16
	ldrh	w7, [x0, #:lo12:.LANCHOR38]
	mov	w22, 0
	ldrh	w4, [x1, -14]
	mov	w2, 0
	ldr	x0, [x24, #:lo12:.LANCHOR107]
	mov	w6, 65535
	add	w4, w4, w27
	mov	w5, 56
	b	.L2586
.L2579:
	ldrh	w3, [x1]
	cmp	w3, w6
	beq	.L2578
	umaddl	x8, w22, w5, x0
	add	w22, w22, 1
	and	w22, w22, 65535
	orr	w3, w4, w3, lsl 10
	str	w3, [x8, 4]
.L2578:
	add	w2, w2, 1
	add	x1, x1, 2
	and	w2, w2, 65535
.L2586:
	cmp	w2, w7
	bne	.L2579
	add	x1, x19, :lo12:.LANCHOR204
	adrp	x25, .LANCHOR103
	add	x25, x25, :lo12:.LANCHOR103
	ldrb	w2, [x1, 8]
	mov	w1, w22
	bl	FlashReadPages
	mov	w0, 56
	umull	x0, w22, w0
	mov	x22, 0
	str	x0, [x29, 152]
.L2580:
	ldr	x0, [x29, 152]
	cmp	x22, x0
	bne	.L2584
	add	w27, w27, 1
	b	.L2577
.L2584:
	ldr	x0, [x24, #:lo12:.LANCHOR107]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	cmn	w0, #1
	beq	.L2581
	ldr	x28, [x1, 16]
	mov	w0, 61589
	ldrh	w1, [x28]
	cmp	w1, w0
	bne	.L2581
	ldr	w4, [x28, 8]
	cmn	w4, #1
	bne	.L2582
	mov	w2, 898
	str	w4, [x29, 112]
	adrp	x1, .LANCHOR243
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR243
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
	ldr	w4, [x29, 112]
.L2582:
	mov	w2, 0
	add	x1, x29, 188
	mov	w0, w4
	bl	log2phys
	ldr	x0, [x24, #:lo12:.LANCHOR107]
	ldr	w1, [x29, 188]
	add	x0, x0, x22
	and	w1, w1, 2147483647
	ldr	w2, [x0, 4]
	cmp	w1, w2
	bne	.L2581
	ldr	x1, [x29, 160]
	adrp	x4, .LANCHOR181
	ldr	x2, [x29, 160]
	ldr	x5, [x4, #:lo12:.LANCHOR181]
	ldr	w0, [x0, 24]
	ldrh	w1, [x1]
	str	x4, [x29, 96]
	add	w1, w1, 1
	strh	w1, [x2]
	ldr	w2, [x25]
	mov	w1, 56
	str	w1, [x29, 108]
	nop // between mem op and mult-accumulate
	umaddl	x2, w2, w1, x5
	str	x2, [x29, 112]
	str	w0, [x2, 24]
	bl	Ftl_get_new_temp_ppa
	ldr	x4, [x29, 96]
	ldr	x2, [x29, 112]
	ldr	w1, [x29, 108]
	str	w0, [x2, 4]
	ldr	x0, [x4, #:lo12:.LANCHOR181]
	ldr	w2, [x25]
	umaddl	x1, w2, w1, x0
	ldr	x0, [x24, #:lo12:.LANCHOR107]
	add	w2, w2, 1
	add	x0, x0, x22
	ldr	x4, [x0, 8]
	str	x4, [x1, 8]
	ldr	x4, [x0, 16]
	str	x4, [x1, 16]
	ldr	w1, [x29, 188]
	str	w1, [x28, 12]
	adrp	x1, .LANCHOR94
	add	x12, x1, :lo12:.LANCHOR94
	ldrh	w1, [x1, #:lo12:.LANCHOR94]
	strh	w1, [x28, 2]
	adrp	x1, .LANCHOR160
	str	w2, [x25]
	ldr	w1, [x1, #:lo12:.LANCHOR160]
	str	w1, [x28, 4]
	mov	w1, 1
	bl	FtlGcBufAlloc
	ldr	x0, [x29, 120]
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbnz	w0, .L2583
	ldrb	w1, [x12, 7]
	ldr	w0, [x25]
	cmp	w1, w0
	beq	.L2583
	ldrh	w0, [x12, 4]
	cbnz	w0, .L2581
.L2583:
	bl	Ftl_gc_temp_data_write_back
	cbz	w0, .L2581
.L2631:
	str	wzr, [x21, #:lo12:.LANCHOR171]
	b	.L2630
.L2581:
	add	x22, x22, 56
	b	.L2580
.L2585:
	add	x1, x19, :lo12:.LANCHOR204
	ldrh	w0, [x1, 2]
	add	w20, w20, w0
	and	w20, w20, 65535
	strh	w20, [x1, 2]
	cmp	w26, w20
	bhi	.L2587
	adrp	x0, .LANCHOR103
	ldr	w0, [x0, #:lo12:.LANCHOR103]
	cbz	w0, .L2588
	bl	Ftl_gc_temp_data_write_back
	cbnz	w0, .L2631
.L2588:
	adrp	x0, .LANCHOR241
	ldrh	w0, [x0, #:lo12:.LANCHOR241]
	cbnz	w0, .L2589
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	adrp	x20, .LANCHOR84
	add	x0, x19, :lo12:.LANCHOR204
	ldr	x3, [x20, #:lo12:.LANCHOR84]
	ubfiz	x2, x1, 1, 16
	ldrh	w4, [x3, x2]
	cbz	w4, .L2589
	adrp	x2, .LANCHOR242
	mov	w3, 0
	ldrh	w5, [x2, #:lo12:.LANCHOR242]
	ldrh	w2, [x0, 2]
	adrp	x0, .LC65
	add	x0, x0, :lo12:.LC65
	bl	printf
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	ldr	x0, [x20, #:lo12:.LANCHOR84]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x19, #:lo12:.LANCHOR204]
	bl	update_vpc_list
	bl	FtlCacheWriteBack
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2589:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR204]
.L2587:
	adrp	x0, .LANCHOR89
	ldrh	w0, [x0, #:lo12:.LANCHOR89]
	cmp	w0, 2
	bhi	.L2590
	ldr	x0, [x29, 128]
	ldrh	w20, [x0, #:lo12:.LANCHOR53]
	b	.L2561
.L2590:
	str	wzr, [x21, #:lo12:.LANCHOR171]
	add	w0, w0, 1
	b	.L2539
.L2591:
	mov	w0, 0
	ret
.L2593:
	mov	w0, 0
	b	.L2539
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
	.section	.text.FtlInit,"ax",@progbits
	.align	2
	.global	FtlInit
	.type	FtlInit, %function
FtlInit:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LC66
	add	x1, x1, :lo12:.LC66
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR231
	mov	x20, x0
	mov	w0, -1
	str	w0, [x19, #:lo12:.LANCHOR231]
	adrp	x0, .LANCHOR244
	str	wzr, [x0, #:lo12:.LANCHOR244]
	adrp	x0, .LANCHOR77
	str	wzr, [x0, #:lo12:.LANCHOR77]
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
	mov	x0, x20
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	adrp	x0, .LANCHOR39
	ldrh	w0, [x0, #:lo12:.LANCHOR39]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	w0, .L2633
	adrp	x1, .LANCHOR245
	adrp	x0, .LC67
	add	x1, x1, :lo12:.LANCHOR245
	add	x0, x0, :lo12:.LC67
.L2641:
	bl	printf
.L2634:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2633:
	bl	FtlSysBlkInit
	cbz	w0, .L2635
	adrp	x1, .LANCHOR245
	adrp	x0, .LC68
	add	x1, x1, :lo12:.LANCHOR245
	add	x0, x0, :lo12:.LC68
	b	.L2641
.L2635:
	mov	w1, 1
	str	w1, [x19, #:lo12:.LANCHOR231]
	bl	rk_ftl_garbage_collect
	adrp	x0, .LANCHOR89
	ldrh	w0, [x0, #:lo12:.LANCHOR89]
	cmp	w0, 15
	bhi	.L2634
	mov	w19, 1024
.L2637:
	mov	w1, 1
	mov	w0, w1
	bl	rk_ftl_garbage_collect
	subs	w19, w19, #1
	bne	.L2637
	b	.L2634
	.size	FtlInit, .-FtlInit
	.section	.text.rk_ftl_init,"ax",@progbits
	.align	2
	.global	rk_ftl_init
	.type	rk_ftl_init, %function
rk_ftl_init:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	bl	FlashInit
	mov	w19, w0
	cbnz	w0, .L2643
	adrp	x0, .LANCHOR15
	add	x0, x0, :lo12:.LANCHOR15
	bl	FtlInit
.L2643:
	bl	idb_init
	mov	w1, w19
	adrp	x0, .LC69
	add	x0, x0, :lo12:.LC69
	bl	printf
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	rk_ftl_init, .-rk_ftl_init
	.section	.text.ftl_fix_nand_power_lost_error,"ax",@progbits
	.align	2
	.global	ftl_fix_nand_power_lost_error
	.type	ftl_fix_nand_power_lost_error, %function
ftl_fix_nand_power_lost_error:
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L2660
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	str	x25, [sp, 64]
	adrp	x25, .LANCHOR235
	stp	x23, x24, [sp, 48]
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR84
	ldrh	w23, [x25, #:lo12:.LANCHOR235]
	ldr	x0, [x21, #:lo12:.LANCHOR84]
	mov	w1, w23
	stp	x19, x20, [sp, 16]
	ubfiz	x24, x23, 1, 16
	adrp	x19, .LC70
	ldrh	w2, [x0, x24]
	add	x0, x19, :lo12:.LC70
	bl	printf
	adrp	x0, .LANCHOR92
	add	x11, x0, :lo12:.LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	bl	FtlGcRefreshOpenBlock
	adrp	x0, .LANCHOR93
	add	x20, x0, :lo12:.LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	bl	FtlGcRefreshOpenBlock
	mov	x0, x11
	bl	allocate_new_data_superblock
	mov	x0, x20
	mov	w20, 4097
	bl	allocate_new_data_superblock
.L2647:
	subs	w20, w20, #1
	beq	.L2651
	mov	w1, 1
	mov	w0, w1
	bl	rk_ftl_garbage_collect
	ldr	x0, [x21, #:lo12:.LANCHOR84]
	ldrh	w0, [x0, x24]
	cbnz	w0, .L2647
.L2651:
	ldr	x0, [x21, #:lo12:.LANCHOR84]
	mov	w1, w23
	ldrh	w2, [x0, x24]
	add	x0, x19, :lo12:.LC70
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR84]
	ldrh	w19, [x0, x24]
	cbnz	w19, .L2649
	add	x20, x29, 128
	adrp	x22, .LANCHOR78
	strh	w23, [x20, -48]!
	mov	x0, x20
	bl	make_superblock
	adrp	x0, .LANCHOR38
	ldr	x4, [x22, #:lo12:.LANCHOR78]
	add	x20, x20, 16
	mov	w5, 65535
	ldrh	w3, [x0, #:lo12:.LANCHOR38]
	mov	w6, 56
	mov	w0, 0
.L2652:
	cmp	w0, w3
	bne	.L2654
	ldr	x0, [x21, #:lo12:.LANCHOR84]
	mov	w1, w23
	ldrh	w2, [x0, x24]
	adrp	x0, .LC71
	add	x0, x0, :lo12:.LC71
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR78]
	mov	w2, w19
	mov	w1, 0
	bl	FlashEraseBlocks
	ldr	x0, [x22, #:lo12:.LANCHOR78]
	mov	w2, w19
	mov	w1, 1
	bl	FlashEraseBlocks
.L2649:
	mov	w0, -1
	strh	w0, [x25, #:lo12:.LANCHOR235]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 128
	ret
.L2654:
	ldrh	w1, [x20]
	cmp	w1, w5
	beq	.L2653
	umaddl	x2, w19, w6, x4
	add	w19, w19, 1
	and	w19, w19, 65535
	lsl	w1, w1, 10
	stp	xzr, xzr, [x2, 8]
	str	w1, [x2, 4]
.L2653:
	add	w0, w0, 1
	add	x20, x20, 2
	and	w0, w0, 65535
	b	.L2652
.L2660:
	ret
	.size	ftl_fix_nand_power_lost_error, .-ftl_fix_nand_power_lost_error
	.section	.text.ftl_read,"ax",@progbits
	.align	2
	.global	ftl_read
	.type	ftl_read, %function
ftl_read:
	sub	sp, sp, #208
	and	w0, w0, 255
	cmp	w0, 16
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	mov	w19, w1
	stp	x23, x24, [sp, 64]
	mov	x23, x3
	stp	x27, x28, [sp, 96]
	mov	w27, w2
	stp	x21, x22, [sp, 48]
	stp	x25, x26, [sp, 80]
	bne	.L2664
	mov	x2, x3
	mov	w1, w27
	add	w0, w19, 256
	bl	FtlVendorPartRead
	mov	w21, w0
.L2663:
	mov	w0, w21
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 208
	ret
.L2664:
	add	w0, w1, w2
	str	w0, [x29, 148]
	adrp	x0, .LANCHOR69
	add	w1, w1, w2
	ldr	w0, [x0, #:lo12:.LANCHOR69]
	cmp	w1, w0
	bhi	.L2687
	adrp	x0, .LANCHOR231
	ldr	w21, [x0, #:lo12:.LANCHOR231]
	cmn	w21, #1
	beq	.L2663
	adrp	x22, .LANCHOR56
	bl	FtlCacheWriteBack
	adrp	x25, .LANCHOR138
	add	x25, x25, :lo12:.LANCHOR138
	ldrh	w0, [x22, #:lo12:.LANCHOR56]
	mov	w24, 0
	mov	w21, 0
	adrp	x26, .LANCHOR180
	stp	wzr, wzr, [x29, 156]
	udiv	w1, w19, w0
	str	w1, [x29, 168]
	add	w1, w19, w27
	sub	w1, w1, #1
	ldr	w20, [x29, 168]
	udiv	w0, w1, w0
	ldr	w1, [x29, 168]
	str	w0, [x29, 164]
	sub	w0, w0, w1
	add	w0, w0, 1
	adrp	x1, .LANCHOR166
	str	w0, [x29, 172]
	ldr	w0, [x1, #:lo12:.LANCHOR166]
	ldr	w2, [x29, 172]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR166]
.L2666:
	ldr	w0, [x29, 172]
	cbnz	w0, .L2686
	adrp	x0, .LANCHOR117
	ldrh	w0, [x0, #:lo12:.LANCHOR117]
	cbz	w0, .L2663
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	b	.L2663
.L2686:
	add	x1, x29, 188
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
	ldr	w1, [x29, 188]
	cmn	w1, #1
	bne	.L2667
	add	x3, x22, :lo12:.LANCHOR56
	mov	w28, 0
.L2668:
	ldrh	w0, [x3]
	cmp	w28, w0
	bcc	.L2670
.L2671:
	ldr	w0, [x29, 172]
	add	w20, w20, 1
	subs	w0, w0, #1
	str	w0, [x29, 172]
	beq	.L2675
	adrp	x0, .LANCHOR38
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w24, w0, lsl 2
	bne	.L2666
.L2675:
	cbz	w24, .L2666
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	mov	w1, w24
	mov	w2, 0
	adrp	x28, .LANCHOR187
	bl	FlashReadPages
	ldr	w0, [x29, 156]
	lsl	w0, w0, 9
	str	w0, [x29, 132]
	ldr	w0, [x29, 152]
	lsl	w0, w0, 9
	str	x0, [x29, 136]
	ldr	w0, [x29, 160]
	lsl	w0, w0, 9
	str	w0, [x29, 144]
	mov	w0, 56
	umull	x0, w24, w0
	mov	x24, 0
	str	x0, [x29, 120]
	adrp	x0, .LC60
	add	x0, x0, :lo12:.LC60
	str	x0, [x29, 112]
.L2685:
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	ldr	w2, [x29, 168]
	add	x0, x0, x24
	ldr	w1, [x0, 24]
	cmp	w2, w1
	bne	.L2677
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR186
	ldr	x0, [x0, #:lo12:.LANCHOR186]
	cmp	x1, x0
	bne	.L2678
	ldr	x0, [x29, 136]
	ldr	w2, [x29, 144]
	add	x1, x1, x0
	mov	x0, x23
.L2702:
	bl	ftl_memcpy
.L2678:
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	add	x0, x0, x24
	ldr	x2, [x0, 16]
	ldr	w1, [x0, 24]
	ldr	w3, [x2, 8]
	cmp	w1, w3
	beq	.L2679
	ldr	w3, [x25, 72]
	add	w3, w3, 1
	str	w3, [x25, 72]
	ldr	x3, [x0, 8]
	ldr	w4, [x3, 4]
	str	w4, [sp]
	ldp	w4, w5, [x2, 4]
	ldr	w6, [x2, 12]
	ldr	w7, [x3]
	ldr	w3, [x2]
	ldr	w2, [x0, 4]
	ldr	x0, [x29, 112]
	bl	printf
.L2679:
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	add	x1, x0, x24
	ldr	w0, [x0, x24]
	cmn	w0, #1
	bne	.L2680
	ldr	w1, [x25, 72]
	mov	w21, w0
	add	w1, w1, 1
	str	w1, [x25, 72]
.L2681:
	ldr	x0, [x29, 120]
	add	x24, x24, 56
	cmp	x0, x24
	bne	.L2685
	mov	w24, 0
	b	.L2666
.L2670:
	madd	w0, w20, w0, w28
	cmp	w19, w0
	bhi	.L2669
	ldr	w1, [x29, 148]
	cmp	w1, w0
	bls	.L2669
	sub	w0, w0, w19
	str	x3, [x29, 136]
	lsl	w0, w0, 9
	mov	w2, 512
	mov	w1, 0
	add	x0, x23, x0
	bl	ftl_memset
	ldr	x3, [x29, 136]
.L2669:
	add	w28, w28, 1
	b	.L2668
.L2667:
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	mov	w2, 56
	umaddl	x0, w24, w2, x0
	str	w1, [x0, 4]
	ldr	w1, [x29, 168]
	cmp	w20, w1
	bne	.L2672
	adrp	x1, .LANCHOR186
	ldr	x1, [x1, #:lo12:.LANCHOR186]
	str	x1, [x0, 8]
	ldrh	w1, [x22, #:lo12:.LANCHOR56]
	udiv	w2, w19, w1
	msub	w2, w2, w1, w19
	str	w2, [x29, 152]
	sub	w2, w1, w2
	cmp	w27, w2
	csel	w2, w27, w2, ls
	str	w2, [x29, 160]
	cmp	w1, w2
	bne	.L2673
	str	x23, [x0, 8]
.L2673:
	adrp	x1, .LANCHOR59
	adrp	x2, .LANCHOR189
	str	w20, [x0, 24]
	ldrh	w1, [x1, #:lo12:.LANCHOR59]
	ldr	x2, [x2, #:lo12:.LANCHOR189]
	mul	w1, w1, w24
	add	w24, w24, 1
	and	x1, x1, 4294967292
	add	x1, x2, x1
	str	x1, [x0, 16]
	b	.L2671
.L2672:
	ldr	w1, [x29, 164]
	cmp	w20, w1
	bne	.L2674
	ldrh	w2, [x22, #:lo12:.LANCHOR56]
	adrp	x1, .LANCHOR187
	ldr	w3, [x29, 148]
	ldr	x1, [x1, #:lo12:.LANCHOR187]
	str	x1, [x0, 8]
	mul	w1, w20, w2
	sub	w3, w3, w1
	str	w3, [x29, 156]
	cmp	w2, w3
	bne	.L2673
.L2701:
	sub	w1, w1, w19
	lsl	w1, w1, 9
	add	x1, x23, x1
	str	x1, [x0, 8]
	b	.L2673
.L2674:
	ldrh	w1, [x22, #:lo12:.LANCHOR56]
	mul	w1, w1, w20
	b	.L2701
.L2677:
	ldr	w2, [x29, 164]
	cmp	w2, w1
	bne	.L2678
	ldr	x1, [x0, 8]
	ldr	x0, [x28, #:lo12:.LANCHOR187]
	cmp	x1, x0
	bne	.L2678
	ldrh	w0, [x22, #:lo12:.LANCHOR56]
	mul	w0, w0, w2
	ldr	w2, [x29, 132]
	sub	w0, w0, w19
	lsl	w0, w0, 9
	add	x0, x23, x0
	b	.L2702
.L2680:
	cmp	w0, 256
	bne	.L2681
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	and	w1, w0, 65535
	str	w1, [x29, 128]
	bl	FtlGcRefreshBlock
	mov	w2, 2049
	adrp	x3, .LANCHOR204
.L2683:
	subs	w2, w2, #1
	bne	.L2682
.L2684:
	bl	FtlSysFlush
	b	.L2681
.L2682:
	mov	w1, 1
	str	x3, [x29, 96]
	mov	w0, w1
	str	w2, [x29, 108]
	bl	rk_ftl_garbage_collect
	ldr	x3, [x29, 96]
	ldr	w1, [x29, 128]
	ldr	w2, [x29, 108]
	ldrh	w0, [x3, #:lo12:.LANCHOR204]
	cmp	w0, w1
	beq	.L2683
	b	.L2684
.L2687:
	mov	w21, -1
	b	.L2663
	.size	ftl_read, .-ftl_read
	.section	.text.FtlWrite,"ax",@progbits
	.align	2
	.global	FtlWrite
	.type	FtlWrite, %function
FtlWrite:
	stp	x29, x30, [sp, -240]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	w21, w1
	adrp	x1, .LANCHOR77
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	ldr	w1, [x1, #:lo12:.LANCHOR77]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w1, .L2735
	and	w0, w0, 255
	mov	w23, w2
	mov	x24, x3
	cmp	w0, 16
	bne	.L2705
	mov	x2, x3
	mov	w1, w23
	add	w0, w21, 256
	bl	FtlVendorPartWrite
.L2703:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	ret
.L2705:
	adrp	x0, .LANCHOR69
	add	w2, w21, w2
	ldr	w0, [x0, #:lo12:.LANCHOR69]
	cmp	w2, w0
	bhi	.L2736
	adrp	x0, .LANCHOR231
	ldr	w0, [x0, #:lo12:.LANCHOR231]
	cmn	w0, #1
	beq	.L2703
	adrp	x0, .LANCHOR246
	adrp	x26, .LANCHOR56
	mov	w1, 2048
	sub	w2, w2, #1
	str	w1, [x0, #:lo12:.LANCHOR246]
	ldrh	w1, [x26, #:lo12:.LANCHOR56]
	str	x26, [x29, 160]
	udiv	w0, w2, w1
	adrp	x2, .LANCHOR162
	udiv	w20, w21, w1
	str	w0, [x29, 152]
	sub	w27, w0, w20
	ldr	w0, [x2, #:lo12:.LANCHOR162]
	add	w25, w27, 1
	add	w0, w0, w25
	str	w0, [x2, #:lo12:.LANCHOR162]
	adrp	x0, .LANCHOR132
	ldr	x2, [x0, #:lo12:.LANCHOR132]
	cbz	x2, .L2707
	ldr	w0, [x2, 24]
	cmp	w20, w0
	beq	.L2708
	bl	FtlCacheWriteBack
.L2707:
	adrp	x0, .LANCHOR92
	mov	w19, w20
	add	x22, x0, :lo12:.LANCHOR92
.L2709:
	cbnz	w25, .L2734
	ldr	w0, [x29, 152]
	sub	w1, w0, w20
	mov	w0, 0
	bl	rk_ftl_garbage_collect
.L2735:
	mov	w0, 0
	b	.L2703
.L2708:
	adrp	x3, .LANCHOR164
	ldr	w0, [x3, #:lo12:.LANCHOR164]
	add	w0, w0, 1
	str	w0, [x3, #:lo12:.LANCHOR164]
	msub	w0, w20, w1, w21
	ldr	x3, [x2, 8]
	sub	w1, w1, w0
	cmp	w23, w1
	lsl	w0, w0, 9
	csel	w19, w23, w1, ls
	add	x0, x3, x0
	lsl	w22, w19, 9
	mov	x1, x24
	mov	w2, w22
	bl	ftl_memcpy
	cbz	w27, .L2735
	sub	w23, w23, w19
	add	w21, w21, w19
	add	x24, x24, x22
	add	w20, w20, 1
	bl	FtlCacheWriteBack
	mov	w25, w27
	b	.L2707
.L2734:
	adrp	x0, .LANCHOR92
	add	x0, x0, :lo12:.LANCHOR92
	adrp	x1, .LANCHOR38
	str	x1, [x29, 120]
	ldrb	w2, [x0, 6]
	ldrh	w0, [x1, #:lo12:.LANCHOR38]
	cmp	w2, w0
	bcc	.L2710
	mov	w2, 1668
	adrp	x1, .LANCHOR247
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR247
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2710:
	ldrh	w0, [x22, 4]
	cbnz	w0, .L2711
	bl	FtlCacheWriteBack
	mov	x0, x22
	bl	allocate_new_data_superblock
.L2711:
	ldrb	w0, [x22, 7]
	ldrh	w1, [x22, 4]
	lsl	w0, w0, 2
	cmp	w0, w1
	csel	w0, w0, w1, ls
	ldrb	w1, [x22, 6]
	cmp	w0, w25
	csel	w0, w0, w25, ls
	str	w0, [x29, 144]
	ldr	x0, [x29, 120]
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcc	.L2712
	mov	w2, 1701
	adrp	x1, .LANCHOR247
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR247
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2712:
	adrp	x0, .LANCHOR59
	add	x0, x0, :lo12:.LANCHOR59
	str	xzr, [x29, 168]
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR58
	add	x0, x0, :lo12:.LANCHOR58
	str	x0, [x29, 104]
.L2713:
	ldr	w1, [x29, 144]
	adrp	x28, .LANCHOR182
	ldr	w27, [x29, 168]
	cmp	w27, w1
	bcc	.L2732
	mov	x27, x1
.L2714:
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	mov	x3, x22
	mov	w2, 0
	mov	w1, w27
	bl	FtlProgPages
	cmp	w25, w27
	bcs	.L2733
	mov	w2, 1790
	adrp	x1, .LANCHOR247
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR247
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2733:
	sub	w25, w25, w27
	b	.L2709
.L2732:
	ldrh	w0, [x22, 4]
	cbz	w0, .L2714
	add	x1, x29, 180
	mov	w2, 0
	mov	w0, w19
	bl	log2phys
	mov	x0, x22
	bl	get_new_active_ppa
	ldr	x1, [x29, 168]
	mov	x3, 56
	mul	x26, x1, x3
	ldr	x1, [x28, #:lo12:.LANCHOR182]
	add	x1, x1, x26
	str	w0, [x1, 4]
	ldr	x0, [x29, 112]
	str	w19, [x1, 24]
	ldrh	w2, [x0]
	mul	w27, w27, w2
	and	x0, x27, 4294967292
	str	x0, [x29, 136]
	adrp	x0, .LANCHOR189
	ldr	x3, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR189]
	str	x0, [x29, 128]
	add	x27, x0, x3
	str	x27, [x1, 16]
	mov	x0, x27
	mov	w1, 0
	bl	ftl_memset
	ldr	w0, [x29, 152]
	cmp	w19, w20
	ccmp	w0, w19, 4, ne
	bne	.L2715
	cmp	w19, w20
	bne	.L2716
	ldr	x0, [x29, 160]
	ldrh	w2, [x0, #:lo12:.LANCHOR56]
	udiv	w0, w21, w2
	msub	w0, w0, w2, w21
	str	w0, [x29, 148]
	sub	w2, w2, w0
	cmp	w2, w23
	csel	w0, w2, w23, ls
	str	w0, [x29, 156]
.L2717:
	ldr	x0, [x29, 160]
	ldr	w1, [x29, 156]
	ldrh	w0, [x0, #:lo12:.LANCHOR56]
	cmp	w0, w1
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	bne	.L2718
	add	x3, x0, x26
	cmp	w19, w20
	bne	.L2719
	str	x24, [x3, 8]
.L2720:
	ldr	x0, [x29, 120]
	ldrb	w1, [x22, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcc	.L2729
	mov	w2, 1775
	adrp	x1, .LANCHOR247
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR247
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2729:
	ldp	x1, x2, [x29, 128]
	mov	w0, -3947
	strh	w0, [x1, x2]
	adrp	x1, .LANCHOR160
	ldr	w0, [x1, #:lo12:.LANCHOR160]
	stp	w0, w19, [x27, 4]
	add	w19, w19, 1
	add	w0, w0, 1
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x1, #:lo12:.LANCHOR160]
	ldr	w0, [x29, 180]
	str	w0, [x27, 12]
	ldrh	w0, [x22]
	strh	w0, [x27, 2]
	ldr	x0, [x29, 168]
	add	x0, x0, 1
	str	x0, [x29, 168]
	b	.L2713
.L2716:
	ldr	x0, [x29, 160]
	add	w2, w21, w23
	str	wzr, [x29, 148]
	ldrh	w0, [x0, #:lo12:.LANCHOR56]
	msub	w2, w19, w0, w2
	and	w0, w2, 65535
	str	w0, [x29, 156]
	b	.L2717
.L2719:
	ldr	w0, [x29, 156]
.L2747:
	mul	w0, w0, w19
	sub	w0, w0, w21
	lsl	w0, w0, 9
	add	x0, x24, x0
	str	x0, [x3, 8]
	b	.L2720
.L2718:
	add	x0, x0, x26
	cmp	w19, w20
	bne	.L2721
	adrp	x1, .LANCHOR186
	ldr	x1, [x1, #:lo12:.LANCHOR186]
.L2746:
	str	x1, [x0, 8]
	ldr	w0, [x29, 180]
	cmn	w0, #1
	beq	.L2723
	str	w0, [x29, 188]
	mov	w2, 0
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	str	w19, [x29, 208]
	add	x0, x0, x26
	ldp	x1, x0, [x0, 8]
	stp	x1, x0, [x29, 192]
	mov	w1, 1
	add	x0, x29, 184
	bl	FlashReadPages
	ldr	w0, [x29, 184]
	cmn	w0, #1
	bne	.L2724
	adrp	x0, .LANCHOR138
	add	x0, x0, :lo12:.LANCHOR138
	ldr	w1, [x0, 72]
	add	w1, w1, 1
	str	w1, [x0, 72]
.L2727:
	ldr	w0, [x29, 156]
	cmp	w19, w20
	lsl	w2, w0, 9
	bne	.L2728
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	mov	x1, x24
	add	x3, x0, x26
	ldr	w0, [x29, 148]
	ldr	x3, [x3, 8]
	lsl	w0, w0, 9
	add	x0, x3, x0
.L2748:
	bl	ftl_memcpy
	b	.L2720
.L2721:
	adrp	x1, .LANCHOR187
	ldr	x1, [x1, #:lo12:.LANCHOR187]
	b	.L2746
.L2724:
	ldr	w1, [x27, 8]
	cmp	w19, w1
	beq	.L2726
	adrp	x0, .LANCHOR138
	add	x0, x0, :lo12:.LANCHOR138
	ldr	w2, [x0, 72]
	add	w2, w2, 1
	str	w2, [x0, 72]
	adrp	x0, .LC72
	mov	w2, w19
	add	x0, x0, :lo12:.LC72
	bl	printf
.L2726:
	ldr	w0, [x27, 8]
	cmp	w19, w0
	beq	.L2727
	mov	w2, 1754
	adrp	x1, .LANCHOR247
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR247
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
	b	.L2727
.L2723:
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	ldr	x1, [x29, 104]
	add	x0, x0, x26
	ldrh	w2, [x1]
	mov	w1, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	b	.L2727
.L2728:
	ldr	x0, [x29, 160]
	ldrh	w1, [x0, #:lo12:.LANCHOR56]
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	add	x3, x0, x26
	mul	w1, w1, w19
	sub	w1, w1, w21
	ldr	x0, [x3, 8]
	lsl	w1, w1, 9
	add	x1, x24, x1
	b	.L2748
.L2715:
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	add	x3, x0, x26
	ldr	x0, [x29, 160]
	ldrh	w0, [x0, #:lo12:.LANCHOR56]
	b	.L2747
.L2736:
	mov	w0, -1
	b	.L2703
	.size	FtlWrite, .-FtlWrite
	.section	.text.ftl_vendor_write,"ax",@progbits
	.align	2
	.global	ftl_vendor_write
	.type	ftl_vendor_write, %function
ftl_vendor_write:
	mov	x3, x2
	mov	w2, w1
	mov	w1, w0
	mov	w0, 16
	b	FtlWrite
	.size	ftl_vendor_write, .-ftl_vendor_write
	.section	.text.ftl_sys_write,"ax",@progbits
	.align	2
	.global	ftl_sys_write
	.type	ftl_sys_write, %function
ftl_sys_write:
	mov	x3, x2
	mov	w2, w1
	add	w1, w0, 256
	mov	w0, 16
	b	FtlWrite
	.size	ftl_sys_write, .-ftl_sys_write
	.section	.text.StorageSysDataStore,"ax",@progbits
	.align	2
	.global	StorageSysDataStore
	.type	StorageSysDataStore, %function
StorageSysDataStore:
	mov	x3, x1
	mov	w2, 1
	add	w1, w0, 256
	mov	w0, 16
	b	FtlWrite
	.size	StorageSysDataStore, .-StorageSysDataStore
	.section	.text.FlashBootVendorWrite,"ax",@progbits
	.align	2
	.global	FlashBootVendorWrite
	.type	FlashBootVendorWrite, %function
FlashBootVendorWrite:
	mov	x3, x2
	mov	w1, w0
	mov	w2, 1
	mov	w0, 16
	b	FtlWrite
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
	bne	.L2754
	mov	w3, w2
	mov	w0, 0
	mov	x2, x20
	bl	idb_write_data
.L2754:
	mov	x3, x20
	mov	w2, w19
	mov	w1, w22
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	b	FtlWrite
	.size	ftl_write, .-ftl_write
	.section	.text.FtlCheckVpc,"ax",@progbits
	.align	2
	.global	FtlCheckVpc
	.type	FtlCheckVpc, %function
FtlCheckVpc:
	stp	x29, x30, [sp, -128]!
	adrp	x0, .LC45
	add	x0, x0, :lo12:.LC45
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR73
	add	x23, x23, :lo12:.LANCHOR73
	stp	x21, x22, [sp, 32]
	mov	w21, 0
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	adrp	x22, .LANCHOR248
	stp	x27, x28, [sp, 80]
	add	x1, x22, :lo12:.LANCHOR248
	adrp	x20, check_valid_page_count_table
	bl	printf
	add	x19, x20, :lo12:check_valid_page_count_table
	mov	x2, 8192
	mov	w1, 0
	mov	x0, x19
	bl	memset
.L2757:
	ldr	w0, [x23]
	cmp	w21, w0
	bcc	.L2759
	adrp	x24, .LANCHOR40
	adrp	x23, .LANCHOR84
	mov	w2, 2
	adrp	x0, .LC73
	ldrh	w3, [x24, #:lo12:.LANCHOR40]
	add	x0, x0, :lo12:.LC73
	ldr	x1, [x23, #:lo12:.LANCHOR84]
	add	x21, x20, :lo12:check_valid_page_count_table
	adrp	x26, .LC75
	add	x26, x26, :lo12:.LC75
	mov	w25, 0
	mov	w19, 0
	bl	rknand_print_hex
	ldrh	w3, [x24, #:lo12:.LANCHOR40]
	mov	w2, 2
	mov	x1, x21
	adrp	x0, .LC74
	add	x24, x24, :lo12:.LANCHOR40
	add	x0, x0, :lo12:.LC74
	bl	rknand_print_hex
	mov	w4, 65535
.L2760:
	ldrh	w0, [x24]
	cmp	w0, w19
	bhi	.L2762
	adrp	x0, .LANCHOR88
	ldr	x19, [x0, #:lo12:.LANCHOR88]
	cbz	x19, .L2763
	adrp	x0, .LANCHOR89
	adrp	x26, .LC76
	add	x20, x20, :lo12:check_valid_page_count_table
	add	x26, x26, :lo12:.LC76
	ldrh	w27, [x0, #:lo12:.LANCHOR89]
	adrp	x0, .LANCHOR82
	mov	x24, x0
	mov	w21, 0
	ldr	x1, [x0, #:lo12:.LANCHOR82]
	mov	w28, 6
	mov	w4, 65535
	sub	x19, x19, x1
	mov	x1, -6148914691236517206
	asr	x19, x19, 1
	movk	x1, 0xaaab, lsl 0
	mul	x19, x19, x1
	and	w19, w19, 65535
.L2764:
	cmp	w21, w27
	bne	.L2766
.L2763:
	cbz	w25, .L2756
	mov	w2, 1669
	add	x1, x22, :lo12:.LANCHOR248
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2756:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2759:
	mov	w2, 0
	add	x1, x29, 124
	mov	w0, w21
	bl	log2phys
	ldr	w0, [x29, 124]
	cmn	w0, #1
	beq	.L2758
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	and	x0, x0, 65535
	ldrh	w1, [x19, x0, lsl 1]
	add	w1, w1, 1
	strh	w1, [x19, x0, lsl 1]
.L2758:
	add	w21, w21, 1
	b	.L2757
.L2762:
	ldr	x0, [x23, #:lo12:.LANCHOR84]
	ubfiz	x28, x19, 1, 16
	sxtw	x27, w19
	ldrh	w2, [x0, x28]
	ldrh	w3, [x21, x27, lsl 1]
	cmp	w2, w3
	beq	.L2761
	str	w4, [x29, 108]
	mov	w1, w19
	mov	x0, x26
	bl	printf
	ldr	x0, [x23, #:lo12:.LANCHOR84]
	ldr	w4, [x29, 108]
	ldrh	w0, [x0, x28]
	cmp	w0, w4
	beq	.L2761
	ldrh	w1, [x21, x27, lsl 1]
	cmp	w1, w0
	csinc	w25, w25, wzr, ls
.L2761:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2760
.L2766:
	ldr	x1, [x23, #:lo12:.LANCHOR84]
	ubfiz	x0, x19, 1, 16
	ldrh	w2, [x1, x0]
	cbz	w2, .L2765
	ldrh	w3, [x20, w19, sxtw 1]
	mov	w1, w19
	str	w4, [x29, 108]
	mov	x0, x26
	mov	w25, 1
	bl	printf
	ldr	w4, [x29, 108]
.L2765:
	umull	x19, w19, w28
	ldr	x0, [x24, #:lo12:.LANCHOR82]
	ldrh	w19, [x0, x19]
	cmp	w19, w4
	beq	.L2763
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L2764
	.size	FtlCheckVpc, .-FtlCheckVpc
	.section	.text.FtlDumpSysBlock,"ax",@progbits
	.align	2
	.global	FtlDumpSysBlock
	.type	FtlDumpSysBlock, %function
FtlDumpSysBlock:
	sub	sp, sp, #112
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x25, x26, [sp, 80]
	and	w25, w0, 65535
	adrp	x0, .LANCHOR183
	stp	x21, x22, [sp, 48]
	adrp	x21, .LANCHOR202
	add	x1, x21, :lo12:.LANCHOR202
	ldr	x2, [x0, #:lo12:.LANCHOR183]
	adrp	x22, .LANCHOR54
	stp	x23, x24, [sp, 64]
	lsl	w26, w25, 10
	stp	x19, x20, [sp, 32]
	adrp	x23, .LC77
	str	x27, [sp, 96]
	adrp	x24, .LC78
	str	x2, [x1, 8]
	adrp	x2, .LANCHOR188
	add	x22, x22, :lo12:.LANCHOR54
	add	x23, x23, :lo12:.LC77
	ldr	x2, [x2, #:lo12:.LANCHOR188]
	add	x24, x24, :lo12:.LC78
	mov	x27, x0
	mov	w19, 0
	str	x2, [x1, 16]
.L2782:
	ldrh	w0, [x22]
	cmp	w19, w0
	blt	.L2784
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	ldr	x27, [sp, 96]
	add	sp, sp, 112
	ret
.L2784:
	add	x20, x21, :lo12:.LANCHOR202
	orr	w0, w19, w26
	mov	w2, 1
	mov	w1, w2
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
	ldp	x1, x0, [x20, 8]
	ldr	w2, [x21, #:lo12:.LANCHOR202]
	ldr	w3, [x20, 4]
	ldr	w1, [x1]
	str	w1, [sp]
	mov	w1, w25
	ldp	w4, w5, [x0]
	ldp	w6, w7, [x0, 8]
	mov	x0, x23
	bl	printf
	ldr	x0, [x20, 16]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L2783
	ldr	x1, [x27, #:lo12:.LANCHOR183]
	mov	w3, 768
	mov	w2, 4
	mov	x0, x24
	bl	rknand_print_hex
.L2783:
	add	w19, w19, 1
	sxth	w19, w19
	b	.L2782
	.size	FtlDumpSysBlock, .-FtlDumpSysBlock
	.section	.text.dump_map_info,"ax",@progbits
	.align	2
	.global	dump_map_info
	.type	dump_map_info, %function
dump_map_info:
	sub	sp, sp, #96
	adrp	x0, .LANCHOR40
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	ldrh	w20, [x0, #:lo12:.LANCHOR40]
	stp	x23, x24, [sp, 64]
	adrp	x23, .LANCHOR47
	stp	x21, x22, [sp, 48]
	add	x23, x23, :lo12:.LANCHOR47
	adrp	x22, .LANCHOR41
	add	x22, x22, :lo12:.LANCHOR41
	stp	x25, x26, [sp, 80]
	adrp	x24, .LANCHOR38
.L2790:
	ldrh	w0, [x22]
	cmp	w0, w20
	bhi	.L2796
	adrp	x25, .LANCHOR128
	adrp	x19, .LANCHOR202
	add	x25, x25, :lo12:.LANCHOR128
	add	x19, x19, :lo12:.LANCHOR202
	mov	w26, 0
.L2797:
	ldrh	w0, [x25]
	cmp	w26, w0
	bge	.L2800
	adrp	x21, .LANCHOR54
	adrp	x0, .LC48
	sbfiz	x23, x26, 1, 32
	mov	w20, 0
	add	x21, x21, :lo12:.LANCHOR54
	add	x24, x0, :lo12:.LC48
	b	.L2801
.L2792:
	ldrb	w0, [x23, x5]
	mov	w1, w20
	bl	V2P_block
	and	w4, w0, 65535
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L2791
	umaddl	x1, w19, w7, x6
	lsl	w4, w4, 10
	mul	w0, w19, w8
	add	w19, w19, 1
	and	w19, w19, 65535
	asr	w0, w0, 2
	str	w4, [x1, 4]
	add	x0, x10, x0, sxtw 2
	stp	x11, x0, [x1, 8]
.L2791:
	add	x5, x5, 1
.L2798:
	cmp	w12, w5, uxth
	bhi	.L2792
	cbnz	w19, .L2793
.L2795:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2790
.L2793:
	mov	w1, w19
	mov	w2, 1
	mov	x0, x6
	bl	FlashReadPages
	mov	w0, 56
	adrp	x26, .LC79
	add	x26, x26, :lo12:.LC79
	mov	x25, 0
	umull	x19, w19, w0
.L2794:
	ldr	x0, [x21, #:lo12:.LANCHOR180]
	add	x0, x0, x25
	add	x25, x25, 56
	ldr	x1, [x0, 16]
	ldr	w2, [x0, 4]
	ldr	x0, [x0, 8]
	ldr	w3, [x0, 4]
	str	w3, [sp]
	ldr	w7, [x0]
	mov	x0, x26
	ldp	w3, w4, [x1]
	ldp	w5, w6, [x1, 8]
	ubfx	x1, x2, 10, 16
	bl	printf
	cmp	x25, x19
	bne	.L2794
	b	.L2795
.L2796:
	adrp	x0, .LANCHOR105
	adrp	x21, .LANCHOR180
	ldrh	w12, [x24, #:lo12:.LANCHOR38]
	mov	x5, 0
	ldr	x11, [x0, #:lo12:.LANCHOR105]
	adrp	x0, .LANCHOR106
	ldr	x6, [x21, #:lo12:.LANCHOR180]
	mov	w19, 0
	ldr	x10, [x0, #:lo12:.LANCHOR106]
	adrp	x0, .LANCHOR59
	mov	w7, 56
	ldrh	w8, [x0, #:lo12:.LANCHOR59]
	b	.L2798
.L2799:
	adrp	x22, .LANCHOR129
	mov	w2, 1
	mov	w1, w2
	ldr	x0, [x22, #:lo12:.LANCHOR129]
	ldrh	w0, [x0, x23]
	orr	w0, w20, w0, lsl 10
	str	w0, [x19, 4]
	mov	x0, x19
	bl	FlashReadPages
	ldp	x2, x0, [x19, 8]
	add	w20, w20, 1
	ldr	x1, [x22, #:lo12:.LANCHOR129]
	sxth	w20, w20
	ldr	w3, [x2, 4]
	ldrh	w1, [x1, x23]
	str	w3, [sp, 8]
	ldr	w2, [x2]
	str	w2, [sp]
	ldp	w4, w5, [x0]
	ldp	w6, w7, [x0, 8]
	mov	x0, x24
	ldp	w2, w3, [x19]
	bl	printf
.L2801:
	ldrh	w0, [x21]
	cmp	w20, w0
	blt	.L2799
	add	w0, w26, 1
	sxth	w26, w0
	b	.L2797
.L2800:
	adrp	x0, .LANCHOR65
	mov	w2, 2
	adrp	x19, .LANCHOR67
	ldr	w3, [x0, #:lo12:.LANCHOR65]
	adrp	x0, .LANCHOR129
	ldr	x1, [x0, #:lo12:.LANCHOR129]
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	bl	rknand_print_hex
	adrp	x0, .LANCHOR131
	ldrh	w3, [x19, #:lo12:.LANCHOR67]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR131]
	adrp	x0, .LC81
	add	x0, x0, :lo12:.LC81
	bl	rknand_print_hex
	adrp	x0, .LANCHOR195
	ldrh	w3, [x19, #:lo12:.LANCHOR67]
	ldp	x21, x22, [sp, 48]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR195]
	adrp	x0, .LC82
	ldp	x19, x20, [sp, 32]
	add	x0, x0, :lo12:.LC82
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 96
	b	rknand_print_hex
	.size	dump_map_info, .-dump_map_info
	.global	FtlMallocOffset
	.global	FtlMallocBuffer
	.global	LastWritenPbaAddr
	.global	gc_ink_free_return_value
	.global	check_valid_page_count_table
	.global	FtlUpdateVaildLpnCount
	.global	g_ect_tbl_power_up_flush
	.global	power_up_flag
	.global	g_LowFormat
	.global	gFtlInitStatus
	.global	DeviceCapacity
	.global	ToshibaRefValue
	.global	Toshiba15RefValue
	.global	ToshibaA19RefValue
	.global	SamsungRefValue
	.global	refValueDefault
	.global	random_seed
	.global	gSlcNandParaInfo
	.global	gNandParaInfo
	.global	g_page_map_check_enable
	.global	g_power_lost_ecc_error_blk
	.global	g_power_lost_recovery_flag
	.global	c_mlc_erase_count_value
	.global	g_recovery_ppa_tbl
	.global	g_recovery_page_min_ver
	.global	g_recovery_page_num
	.global	g_cur_erase_blk
	.global	g_gc_skip_write_count
	.global	g_gc_head_data_block_count
	.global	g_gc_head_data_block
	.global	g_ftl_nand_free_count
	.global	g_in_swl_replace
	.global	g_in_gc_progress
	.global	g_all_blk_used_slc_mode
	.global	g_max_erase_count
	.global	g_totle_sys_slc_erase_count
	.global	g_totle_slc_erase_count
	.global	g_min_erase_count
	.global	g_totle_avg_erase_count
	.global	g_totle_mlc_erase_count
	.global	g_totle_l2p_write_count
	.global	g_totle_cache_write_count
	.global	g_tmp_data_superblock_id
	.global	g_totle_read_page_count
	.global	g_totle_discard_page_count
	.global	g_totle_read_sector
	.global	g_totle_write_sector
	.global	g_totle_write_page_count
	.global	g_totle_gc_page_count
	.global	g_gc_blk_index
	.global	g_gc_merge_free_blk_threshold
	.global	g_gc_free_blk_threshold
	.global	g_gc_refresh_block_temp_tbl
	.global	g_free_slc_blk_num
	.global	g_gc_refresh_block_temp_num
	.global	g_gc_bad_block_temp_tbl
	.global	g_gc_bad_block_gc_index
	.global	g_gc_bad_block_temp_num
	.global	g_gc_next_blk_3
	.global	g_gc_next_blk_2
	.global	g_gc_next_blk_1
	.global	g_gc_next_blk
	.global	g_gc_cur_blk_max_valid_pages
	.global	g_gc_cur_blk_valid_pages
	.global	g_gc_page_offset
	.global	g_gc_blk_num
	.global	p_gc_blk_tbl
	.global	p_gc_page_info
	.global	g_sys_ext_data
	.global	g_sys_save_data
	.global	gp_last_act_superblock
	.global	g_gc_superblock
	.global	g_gc_temp_superblock
	.global	g_buffer_superblock
	.global	g_active_superblock
	.global	g_num_data_superblocks
	.global	g_num_free_superblocks
	.global	p_data_block_list_tail
	.global	p_data_block_list_head
	.global	p_free_data_block_list_head
	.global	p_data_block_list_table
	.global	g_l2p_last_update_region_id
	.global	p_l2p_map_buf
	.global	p_l2p_ram_map
	.global	g_totle_vendor_block
	.global	p_vendor_region_ppn_table
	.global	p_vendor_block_ver_table
	.global	p_vendor_block_valid_page_count
	.global	p_vendor_block_table
	.global	g_totle_map_block
	.global	p_map_region_ppn_check_table
	.global	p_map_region_ppn_table
	.global	p_map_block_ver_table
	.global	p_map_block_valid_page_count
	.global	p_map_block_table
	.global	p_blk_mode_table
	.global	p_valid_page_count_check_table
	.global	p_valid_page_count_table
	.global	g_totle_swl_count
	.global	p_swl_mul_table
	.global	p_erase_count_table
	.global	g_ect_tbl_info_size
	.global	gp_ect_tbl_info
	.global	g_gc_num_req
	.global	c_gc_page_buf_num
	.global	gp_gc_page_buf_info
	.global	p_gc_data_buf
	.global	p_gc_spare_buf
	.global	p_io_spare_buf
	.global	p_io_data_buf_1
	.global	p_io_data_buf_0
	.global	p_sys_spare_buf
	.global	p_vendor_data_buf
	.global	p_sys_data_buf_1
	.global	p_sys_data_buf
	.global	p_plane_order_table
	.global	g_req_cache
	.global	req_gc_dst
	.global	req_gc
	.global	req_erase
	.global	req_prgm
	.global	req_read
	.global	req_sys
	.global	gVendorBlkInfo
	.global	gL2pMapInfo
	.global	gSysFreeQueue
	.global	gSysInfo
	.global	gBbtInfo
	.global	g_flash_read_only_en
	.global	g_inkDie_check_enable
	.global	g_SlcPartLbaEndSector
	.global	g_MaxLbn
	.global	g_VaildLpn
	.global	g_MaxLpn
	.global	g_MaxLbaSector
	.global	g_GlobalDataVersion
	.global	g_GlobalSysVersion
	.global	ftl_gc_temp_power_lost_recovery_flag
	.global	c_ftl_nand_max_data_blks
	.global	c_ftl_nand_data_op_blks_per_plane
	.global	c_ftl_nand_data_blks_per_plane
	.global	c_ftl_nand_max_sys_blks
	.global	c_ftl_nand_init_sys_blks_per_plane
	.global	c_ftl_nand_sys_blks_per_plane
	.global	c_ftl_vendor_part_size
	.global	c_ftl_nand_max_vendor_blks
	.global	c_ftl_nand_max_map_blks
	.global	c_ftl_nand_map_blks_per_plane
	.global	c_ftl_nand_vendor_region_num
	.global	c_ftl_nand_l2pmap_ram_region_num
	.global	c_ftl_nand_map_region_num
	.global	c_ftl_nand_totle_phy_blks
	.global	c_ftl_nand_reserved_blks
	.global	c_ftl_nand_byte_pre_oob
	.global	c_ftl_nand_byte_pre_page
	.global	c_ftl_nand_sec_pre_page_shift
	.global	c_ftl_nand_sec_pre_page
	.global	c_ftl_nand_page_pre_super_blk
	.global	c_ftl_nand_page_pre_slc_blk
	.global	c_ftl_nand_page_pre_blk
	.global	c_ftl_nand_bbm_buf_size
	.global	c_ftl_nand_ext_blk_pre_plane
	.global	c_ftl_nand_blk_pre_plane
	.global	c_ftl_nand_planes_num
	.global	c_ftl_nand_blks_per_die_shift
	.global	c_ftl_nand_blks_per_die
	.global	c_ftl_nand_planes_per_die
	.global	c_ftl_nand_die_num
	.global	c_ftl_nand_type
	.global	gMasterTempBuf
	.global	gMasterInfo
	.global	gNandcDumpWriteEn
	.global	gToggleModeClkDiv
	.global	gBootDdrMode
	.global	gNandcEccBits
	.global	gpNandc1
	.global	gpNandc
	.global	g_nandc_version_data
	.global	gNandcVer
	.global	gNandChipMap
	.global	gNandIDataBuf
	.global	FlashDdrTunningReadCount
	.global	FlashWaitBusyScheduleEn
	.global	gNandPhyInfo
	.global	gFlashProgCheckSpareBuffer
	.global	gFlashProgCheckBuffer
	.global	gFlashSpareBuffer
	.global	gFlashPageBuffer1
	.global	gFlashPageBuffer0
	.global	gpFlashSaveInfo
	.global	gReadRetryInfo
	.global	gpNandParaInfo
	.global	gNandOptPara
	.global	g_slc2KBNand
	.global	g_maxRetryCount
	.global	g_maxRegNum
	.global	g_retryMode
	.global	gNandIDBResBlkNumSaveInFlash
	.global	gNandIDBResBlkNum
	.global	gNandFlashResEndPageAddr
	.global	gNandFlashInfoBlockAddr
	.global	gNandFlashIdbBlockAddr
	.global	gNandFlashInfoBlockEcc
	.global	gNandFlashIDBEccBits
	.global	gNandFlashEccBits
	.global	gNandRandomizer
	.global	gBlockPageAlignSize
	.global	gTotleBlock
	.global	gNandMaxChip
	.global	gNandMaxDie
	.global	gFlashInterfaceMode
	.global	gFlashSlcMode
	.global	gFlashOnfiModeEn
	.global	gFlashToggleModeEn
	.global	gFlashSdrModeEn
	.global	gMultiPageProgEn
	.global	gMultiPageReadEn
	.global	gpReadRetrial
	.global	mlcPageToSlcPageTbl
	.global	slcPageToMlcPageTbl
	.global	DieAddrs
	.global	gDieOp
	.global	DieCsIndex
	.global	IDByte
	.global	read_retry_cur_offset
	.section	.bss.DeviceCapacity,"aw",@nobits
	.align	2
	.set	.LANCHOR61,. + 0
	.type	DeviceCapacity, %object
	.size	DeviceCapacity, 4
DeviceCapacity:
	.zero	4
	.section	.bss.DieAddrs,"aw",@nobits
	.align	2
	.set	.LANCHOR17,. + 0
	.type	DieAddrs, %object
	.size	DieAddrs, 32
DieAddrs:
	.zero	32
	.section	.bss.DieCsIndex,"aw",@nobits
	.align	2
	.set	.LANCHOR26,. + 0
	.type	DieCsIndex, %object
	.size	DieCsIndex, 8
DieCsIndex:
	.zero	8
	.section	.bss.FlashDdrTunningReadCount,"aw",@nobits
	.align	2
	.set	.LANCHOR144,. + 0
	.type	FlashDdrTunningReadCount, %object
	.size	FlashDdrTunningReadCount, 4
FlashDdrTunningReadCount:
	.zero	4
	.section	.bss.FlashWaitBusyScheduleEn,"aw",@nobits
	.align	2
	.type	FlashWaitBusyScheduleEn, %object
	.size	FlashWaitBusyScheduleEn, 4
FlashWaitBusyScheduleEn:
	.zero	4
	.section	.bss.FtlMallocBuffer,"aw",@nobits
	.align	6
	.type	FtlMallocBuffer, %object
	.size	FtlMallocBuffer, 1310720
FtlMallocBuffer:
	.zero	1310720
	.section	.bss.FtlUpdateVaildLpnCount,"aw",@nobits
	.align	1
	.set	.LANCHOR100,. + 0
	.type	FtlUpdateVaildLpnCount, %object
	.size	FtlUpdateVaildLpnCount, 2
FtlUpdateVaildLpnCount:
	.zero	2
	.section	.bss.IDByte,"aw",@nobits
	.align	2
	.set	.LANCHOR22,. + 0
	.type	IDByte, %object
	.size	IDByte, 32
IDByte:
	.zero	32
	.section	.bss.c_ftl_nand_bbm_buf_size,"aw",@nobits
	.align	1
	.set	.LANCHOR123,. + 0
	.type	c_ftl_nand_bbm_buf_size, %object
	.size	c_ftl_nand_bbm_buf_size, 2
c_ftl_nand_bbm_buf_size:
	.zero	2
	.section	.bss.c_ftl_nand_blk_pre_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR41,. + 0
	.type	c_ftl_nand_blk_pre_plane, %object
	.size	c_ftl_nand_blk_pre_plane, 2
c_ftl_nand_blk_pre_plane:
	.zero	2
	.section	.bss.c_ftl_nand_blks_per_die,"aw",@nobits
	.align	1
	.set	.LANCHOR51,. + 0
	.type	c_ftl_nand_blks_per_die, %object
	.size	c_ftl_nand_blks_per_die, 2
c_ftl_nand_blks_per_die:
	.zero	2
	.section	.bss.c_ftl_nand_blks_per_die_shift,"aw",@nobits
	.align	1
	.set	.LANCHOR52,. + 0
	.type	c_ftl_nand_blks_per_die_shift, %object
	.size	c_ftl_nand_blks_per_die_shift, 2
c_ftl_nand_blks_per_die_shift:
	.zero	2
	.section	.bss.c_ftl_nand_byte_pre_oob,"aw",@nobits
	.align	1
	.set	.LANCHOR59,. + 0
	.type	c_ftl_nand_byte_pre_oob, %object
	.size	c_ftl_nand_byte_pre_oob, 2
c_ftl_nand_byte_pre_oob:
	.zero	2
	.section	.bss.c_ftl_nand_byte_pre_page,"aw",@nobits
	.align	1
	.set	.LANCHOR58,. + 0
	.type	c_ftl_nand_byte_pre_page, %object
	.size	c_ftl_nand_byte_pre_page, 2
c_ftl_nand_byte_pre_page:
	.zero	2
	.section	.bss.c_ftl_nand_data_blks_per_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR40,. + 0
	.type	c_ftl_nand_data_blks_per_plane, %object
	.size	c_ftl_nand_data_blks_per_plane, 2
c_ftl_nand_data_blks_per_plane:
	.zero	2
	.section	.bss.c_ftl_nand_data_op_blks_per_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR223,. + 0
	.type	c_ftl_nand_data_op_blks_per_plane, %object
	.size	c_ftl_nand_data_op_blks_per_plane, 2
c_ftl_nand_data_op_blks_per_plane:
	.zero	2
	.section	.bss.c_ftl_nand_die_num,"aw",@nobits
	.align	1
	.set	.LANCHOR45,. + 0
	.type	c_ftl_nand_die_num, %object
	.size	c_ftl_nand_die_num, 2
c_ftl_nand_die_num:
	.zero	2
	.section	.bss.c_ftl_nand_ext_blk_pre_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR49,. + 0
	.type	c_ftl_nand_ext_blk_pre_plane, %object
	.size	c_ftl_nand_ext_blk_pre_plane, 2
c_ftl_nand_ext_blk_pre_plane:
	.zero	2
	.section	.bss.c_ftl_nand_init_sys_blks_per_plane,"aw",@nobits
	.align	2
	.set	.LANCHOR66,. + 0
	.type	c_ftl_nand_init_sys_blks_per_plane, %object
	.size	c_ftl_nand_init_sys_blks_per_plane, 4
c_ftl_nand_init_sys_blks_per_plane:
	.zero	4
	.section	.bss.c_ftl_nand_l2pmap_ram_region_num,"aw",@nobits
	.align	1
	.set	.LANCHOR68,. + 0
	.type	c_ftl_nand_l2pmap_ram_region_num, %object
	.size	c_ftl_nand_l2pmap_ram_region_num, 2
c_ftl_nand_l2pmap_ram_region_num:
	.zero	2
	.section	.bss.c_ftl_nand_map_blks_per_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR64,. + 0
	.type	c_ftl_nand_map_blks_per_plane, %object
	.size	c_ftl_nand_map_blks_per_plane, 2
c_ftl_nand_map_blks_per_plane:
	.zero	2
	.section	.bss.c_ftl_nand_map_region_num,"aw",@nobits
	.align	1
	.set	.LANCHOR67,. + 0
	.type	c_ftl_nand_map_region_num, %object
	.size	c_ftl_nand_map_region_num, 2
c_ftl_nand_map_region_num:
	.zero	2
	.section	.bss.c_ftl_nand_max_data_blks,"aw",@nobits
	.align	2
	.set	.LANCHOR42,. + 0
	.type	c_ftl_nand_max_data_blks, %object
	.size	c_ftl_nand_max_data_blks, 4
c_ftl_nand_max_data_blks:
	.zero	4
	.section	.bss.c_ftl_nand_max_map_blks,"aw",@nobits
	.align	2
	.set	.LANCHOR65,. + 0
	.type	c_ftl_nand_max_map_blks, %object
	.size	c_ftl_nand_max_map_blks, 4
c_ftl_nand_max_map_blks:
	.zero	4
	.section	.bss.c_ftl_nand_max_sys_blks,"aw",@nobits
	.align	2
	.set	.LANCHOR39,. + 0
	.type	c_ftl_nand_max_sys_blks, %object
	.size	c_ftl_nand_max_sys_blks, 4
c_ftl_nand_max_sys_blks:
	.zero	4
	.section	.bss.c_ftl_nand_max_vendor_blks,"aw",@nobits
	.align	1
	.set	.LANCHOR62,. + 0
	.type	c_ftl_nand_max_vendor_blks, %object
	.size	c_ftl_nand_max_vendor_blks, 2
c_ftl_nand_max_vendor_blks:
	.zero	2
	.section	.bss.c_ftl_nand_page_pre_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR53,. + 0
	.type	c_ftl_nand_page_pre_blk, %object
	.size	c_ftl_nand_page_pre_blk, 2
c_ftl_nand_page_pre_blk:
	.zero	2
	.section	.bss.c_ftl_nand_page_pre_slc_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR54,. + 0
	.type	c_ftl_nand_page_pre_slc_blk, %object
	.size	c_ftl_nand_page_pre_slc_blk, 2
c_ftl_nand_page_pre_slc_blk:
	.zero	2
	.section	.bss.c_ftl_nand_page_pre_super_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR55,. + 0
	.type	c_ftl_nand_page_pre_super_blk, %object
	.size	c_ftl_nand_page_pre_super_blk, 2
c_ftl_nand_page_pre_super_blk:
	.zero	2
	.section	.bss.c_ftl_nand_planes_num,"aw",@nobits
	.align	1
	.set	.LANCHOR38,. + 0
	.type	c_ftl_nand_planes_num, %object
	.size	c_ftl_nand_planes_num, 2
c_ftl_nand_planes_num:
	.zero	2
	.section	.bss.c_ftl_nand_planes_per_die,"aw",@nobits
	.align	1
	.set	.LANCHOR46,. + 0
	.type	c_ftl_nand_planes_per_die, %object
	.size	c_ftl_nand_planes_per_die, 2
c_ftl_nand_planes_per_die:
	.zero	2
	.section	.bss.c_ftl_nand_reserved_blks,"aw",@nobits
	.align	1
	.set	.LANCHOR60,. + 0
	.type	c_ftl_nand_reserved_blks, %object
	.size	c_ftl_nand_reserved_blks, 2
c_ftl_nand_reserved_blks:
	.zero	2
	.section	.bss.c_ftl_nand_sec_pre_page,"aw",@nobits
	.align	1
	.set	.LANCHOR56,. + 0
	.type	c_ftl_nand_sec_pre_page, %object
	.size	c_ftl_nand_sec_pre_page, 2
c_ftl_nand_sec_pre_page:
	.zero	2
	.section	.bss.c_ftl_nand_sec_pre_page_shift,"aw",@nobits
	.align	1
	.set	.LANCHOR57,. + 0
	.type	c_ftl_nand_sec_pre_page_shift, %object
	.size	c_ftl_nand_sec_pre_page_shift, 2
c_ftl_nand_sec_pre_page_shift:
	.zero	2
	.section	.bss.c_ftl_nand_sys_blks_per_plane,"aw",@nobits
	.align	2
	.set	.LANCHOR37,. + 0
	.type	c_ftl_nand_sys_blks_per_plane, %object
	.size	c_ftl_nand_sys_blks_per_plane, 4
c_ftl_nand_sys_blks_per_plane:
	.zero	4
	.section	.bss.c_ftl_nand_totle_phy_blks,"aw",@nobits
	.align	2
	.set	.LANCHOR43,. + 0
	.type	c_ftl_nand_totle_phy_blks, %object
	.size	c_ftl_nand_totle_phy_blks, 4
c_ftl_nand_totle_phy_blks:
	.zero	4
	.section	.bss.c_ftl_nand_type,"aw",@nobits
	.align	1
	.set	.LANCHOR44,. + 0
	.type	c_ftl_nand_type, %object
	.size	c_ftl_nand_type, 2
c_ftl_nand_type:
	.zero	2
	.section	.bss.c_ftl_nand_vendor_region_num,"aw",@nobits
	.align	1
	.set	.LANCHOR63,. + 0
	.type	c_ftl_nand_vendor_region_num, %object
	.size	c_ftl_nand_vendor_region_num, 2
c_ftl_nand_vendor_region_num:
	.zero	2
	.section	.bss.c_ftl_vendor_part_size,"aw",@nobits
	.align	1
	.set	.LANCHOR50,. + 0
	.type	c_ftl_vendor_part_size, %object
	.size	c_ftl_vendor_part_size, 2
c_ftl_vendor_part_size:
	.zero	2
	.section	.bss.c_gc_page_buf_num,"aw",@nobits
	.align	2
	.set	.LANCHOR108,. + 0
	.type	c_gc_page_buf_num, %object
	.size	c_gc_page_buf_num, 4
c_gc_page_buf_num:
	.zero	4
	.section	.bss.c_mlc_erase_count_value,"aw",@nobits
	.align	1
	.set	.LANCHOR48,. + 0
	.type	c_mlc_erase_count_value, %object
	.size	c_mlc_erase_count_value, 2
c_mlc_erase_count_value:
	.zero	2
	.section	.bss.check_valid_page_count_table,"aw",@nobits
	.align	3
	.type	check_valid_page_count_table, %object
	.size	check_valid_page_count_table, 8192
check_valid_page_count_table:
	.zero	8192
	.section	.bss.ftl_gc_temp_power_lost_recovery_flag,"aw",@nobits
	.align	2
	.set	.LANCHOR135,. + 0
	.type	ftl_gc_temp_power_lost_recovery_flag, %object
	.size	ftl_gc_temp_power_lost_recovery_flag, 4
ftl_gc_temp_power_lost_recovery_flag:
	.zero	4
	.section	.bss.gBbtInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR75,. + 0
	.type	gBbtInfo, %object
	.size	gBbtInfo, 96
gBbtInfo:
	.zero	96
	.section	.bss.gBlockPageAlignSize,"aw",@nobits
	.align	2
	.set	.LANCHOR3,. + 0
	.type	gBlockPageAlignSize, %object
	.size	gBlockPageAlignSize, 4
gBlockPageAlignSize:
	.zero	4
	.section	.bss.gBootDdrMode,"aw",@nobits
	.align	2
	.set	.LANCHOR155,. + 0
	.type	gBootDdrMode, %object
	.size	gBootDdrMode, 4
gBootDdrMode:
	.zero	4
	.section	.bss.gDieOp,"aw",@nobits
	.align	2
	.set	.LANCHOR23,. + 0
	.type	gDieOp, %object
	.size	gDieOp, 192
gDieOp:
	.zero	192
	.section	.bss.gFlashInterfaceMode,"aw",@nobits
	.set	.LANCHOR24,. + 0
	.type	gFlashInterfaceMode, %object
	.size	gFlashInterfaceMode, 1
gFlashInterfaceMode:
	.zero	1
	.section	.bss.gFlashOnfiModeEn,"aw",@nobits
	.type	gFlashOnfiModeEn, %object
	.size	gFlashOnfiModeEn, 1
gFlashOnfiModeEn:
	.zero	1
	.section	.bss.gFlashPageBuffer0,"aw",@nobits
	.align	3
	.set	.LANCHOR147,. + 0
	.type	gFlashPageBuffer0, %object
	.size	gFlashPageBuffer0, 8
gFlashPageBuffer0:
	.zero	8
	.section	.bss.gFlashPageBuffer1,"aw",@nobits
	.align	3
	.set	.LANCHOR153,. + 0
	.type	gFlashPageBuffer1, %object
	.size	gFlashPageBuffer1, 8
gFlashPageBuffer1:
	.zero	8
	.section	.bss.gFlashProgCheckBuffer,"aw",@nobits
	.align	3
	.set	.LANCHOR198,. + 0
	.type	gFlashProgCheckBuffer, %object
	.size	gFlashProgCheckBuffer, 8
gFlashProgCheckBuffer:
	.zero	8
	.section	.bss.gFlashProgCheckSpareBuffer,"aw",@nobits
	.align	3
	.set	.LANCHOR199,. + 0
	.type	gFlashProgCheckSpareBuffer, %object
	.size	gFlashProgCheckSpareBuffer, 8
gFlashProgCheckSpareBuffer:
	.zero	8
	.section	.bss.gFlashSdrModeEn,"aw",@nobits
	.type	gFlashSdrModeEn, %object
	.size	gFlashSdrModeEn, 1
gFlashSdrModeEn:
	.zero	1
	.section	.bss.gFlashSlcMode,"aw",@nobits
	.set	.LANCHOR8,. + 0
	.type	gFlashSlcMode, %object
	.size	gFlashSlcMode, 1
gFlashSlcMode:
	.zero	1
	.section	.bss.gFlashSpareBuffer,"aw",@nobits
	.align	3
	.set	.LANCHOR197,. + 0
	.type	gFlashSpareBuffer, %object
	.size	gFlashSpareBuffer, 8
gFlashSpareBuffer:
	.zero	8
	.section	.bss.gFlashToggleModeEn,"aw",@nobits
	.set	.LANCHOR30,. + 0
	.type	gFlashToggleModeEn, %object
	.size	gFlashToggleModeEn, 1
gFlashToggleModeEn:
	.zero	1
	.section	.bss.gL2pMapInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR127,. + 0
	.type	gL2pMapInfo, %object
	.size	gL2pMapInfo, 64
gL2pMapInfo:
	.zero	64
	.section	.bss.gMasterInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR35,. + 0
	.type	gMasterInfo, %object
	.size	gMasterInfo, 48
gMasterInfo:
	.zero	48
	.section	.bss.gMasterTempBuf,"aw",@nobits
	.align	3
	.set	.LANCHOR156,. + 0
	.type	gMasterTempBuf, %object
	.size	gMasterTempBuf, 8
gMasterTempBuf:
	.zero	8
	.section	.bss.gMultiPageProgEn,"aw",@nobits
	.set	.LANCHOR27,. + 0
	.type	gMultiPageProgEn, %object
	.size	gMultiPageProgEn, 1
gMultiPageProgEn:
	.zero	1
	.section	.bss.gMultiPageReadEn,"aw",@nobits
	.set	.LANCHOR201,. + 0
	.type	gMultiPageReadEn, %object
	.size	gMultiPageReadEn, 1
gMultiPageReadEn:
	.zero	1
	.section	.bss.gNandChipMap,"aw",@nobits
	.align	3
	.set	.LANCHOR6,. + 0
	.type	gNandChipMap, %object
	.size	gNandChipMap, 64
gNandChipMap:
	.zero	64
	.section	.bss.gNandFlashEccBits,"aw",@nobits
	.set	.LANCHOR33,. + 0
	.type	gNandFlashEccBits, %object
	.size	gNandFlashEccBits, 1
gNandFlashEccBits:
	.zero	1
	.section	.bss.gNandFlashIDBEccBits,"aw",@nobits
	.set	.LANCHOR152,. + 0
	.type	gNandFlashIDBEccBits, %object
	.size	gNandFlashIDBEccBits, 1
gNandFlashIDBEccBits:
	.zero	1
	.section	.bss.gNandFlashIdbBlockAddr,"aw",@nobits
	.align	2
	.set	.LANCHOR149,. + 0
	.type	gNandFlashIdbBlockAddr, %object
	.size	gNandFlashIdbBlockAddr, 4
gNandFlashIdbBlockAddr:
	.zero	4
	.section	.bss.gNandFlashInfoBlockAddr,"aw",@nobits
	.align	2
	.set	.LANCHOR148,. + 0
	.type	gNandFlashInfoBlockAddr, %object
	.size	gNandFlashInfoBlockAddr, 4
gNandFlashInfoBlockAddr:
	.zero	4
	.section	.bss.gNandFlashInfoBlockEcc,"aw",@nobits
	.type	gNandFlashInfoBlockEcc, %object
	.size	gNandFlashInfoBlockEcc, 1
gNandFlashInfoBlockEcc:
	.zero	1
	.section	.bss.gNandFlashResEndPageAddr,"aw",@nobits
	.align	2
	.type	gNandFlashResEndPageAddr, %object
	.size	gNandFlashResEndPageAddr, 4
gNandFlashResEndPageAddr:
	.zero	4
	.section	.bss.gNandIDBResBlkNum,"aw",@nobits
	.set	.LANCHOR2,. + 0
	.type	gNandIDBResBlkNum, %object
	.size	gNandIDBResBlkNum, 1
gNandIDBResBlkNum:
	.zero	1
	.section	.bss.gNandIDBResBlkNumSaveInFlash,"aw",@nobits
	.set	.LANCHOR150,. + 0
	.type	gNandIDBResBlkNumSaveInFlash, %object
	.size	gNandIDBResBlkNumSaveInFlash, 1
gNandIDBResBlkNumSaveInFlash:
	.zero	1
	.section	.bss.gNandIDataBuf,"aw",@nobits
	.align	3
	.set	.LANCHOR141,. + 0
	.type	gNandIDataBuf, %object
	.size	gNandIDataBuf, 2048
gNandIDataBuf:
	.zero	2048
	.section	.bss.gNandMaxChip,"aw",@nobits
	.set	.LANCHOR121,. + 0
	.type	gNandMaxChip, %object
	.size	gNandMaxChip, 1
gNandMaxChip:
	.zero	1
	.section	.bss.gNandMaxDie,"aw",@nobits
	.set	.LANCHOR25,. + 0
	.type	gNandMaxDie, %object
	.size	gNandMaxDie, 1
gNandMaxDie:
	.zero	1
	.section	.bss.gNandOptPara,"aw",@nobits
	.align	3
	.set	.LANCHOR7,. + 0
	.type	gNandOptPara, %object
	.size	gNandOptPara, 32
gNandOptPara:
	.zero	32
	.section	.bss.gNandPhyInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR15,. + 0
	.type	gNandPhyInfo, %object
	.size	gNandPhyInfo, 28
gNandPhyInfo:
	.zero	28
	.section	.bss.gNandRandomizer,"aw",@nobits
	.set	.LANCHOR5,. + 0
	.type	gNandRandomizer, %object
	.size	gNandRandomizer, 1
gNandRandomizer:
	.zero	1
	.section	.bss.gNandcDumpWriteEn,"aw",@nobits
	.align	2
	.set	.LANCHOR36,. + 0
	.type	gNandcDumpWriteEn, %object
	.size	gNandcDumpWriteEn, 4
gNandcDumpWriteEn:
	.zero	4
	.section	.bss.gNandcEccBits,"aw",@nobits
	.align	2
	.set	.LANCHOR32,. + 0
	.type	gNandcEccBits, %object
	.size	gNandcEccBits, 4
gNandcEccBits:
	.zero	4
	.section	.bss.gNandcVer,"aw",@nobits
	.align	2
	.set	.LANCHOR34,. + 0
	.type	gNandcVer, %object
	.size	gNandcVer, 4
gNandcVer:
	.zero	4
	.section	.bss.gReadRetryInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR20,. + 0
	.type	gReadRetryInfo, %object
	.size	gReadRetryInfo, 852
gReadRetryInfo:
	.zero	852
	.section	.bss.gSysFreeQueue,"aw",@nobits
	.align	3
	.set	.LANCHOR76,. + 0
	.type	gSysFreeQueue, %object
	.size	gSysFreeQueue, 2056
gSysFreeQueue:
	.zero	2056
	.section	.bss.gSysInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR209,. + 0
	.type	gSysInfo, %object
	.size	gSysInfo, 12
gSysInfo:
	.zero	12
	.section	.bss.gToggleModeClkDiv,"aw",@nobits
	.align	2
	.type	gToggleModeClkDiv, %object
	.size	gToggleModeClkDiv, 4
gToggleModeClkDiv:
	.zero	4
	.section	.bss.gTotleBlock,"aw",@nobits
	.align	1
	.set	.LANCHOR122,. + 0
	.type	gTotleBlock, %object
	.size	gTotleBlock, 2
gTotleBlock:
	.zero	2
	.section	.bss.gVendorBlkInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR215,. + 0
	.type	gVendorBlkInfo, %object
	.size	gVendorBlkInfo, 64
gVendorBlkInfo:
	.zero	64
	.section	.bss.g_GlobalDataVersion,"aw",@nobits
	.align	2
	.set	.LANCHOR160,. + 0
	.type	g_GlobalDataVersion, %object
	.size	g_GlobalDataVersion, 4
g_GlobalDataVersion:
	.zero	4
	.section	.bss.g_GlobalSysVersion,"aw",@nobits
	.align	2
	.set	.LANCHOR159,. + 0
	.type	g_GlobalSysVersion, %object
	.size	g_GlobalSysVersion, 4
g_GlobalSysVersion:
	.zero	4
	.section	.bss.g_LowFormat,"aw",@nobits
	.align	2
	.set	.LANCHOR244,. + 0
	.type	g_LowFormat, %object
	.size	g_LowFormat, 4
g_LowFormat:
	.zero	4
	.section	.bss.g_MaxLbaSector,"aw",@nobits
	.align	2
	.set	.LANCHOR69,. + 0
	.type	g_MaxLbaSector, %object
	.size	g_MaxLbaSector, 4
g_MaxLbaSector:
	.zero	4
	.section	.bss.g_MaxLbn,"aw",@nobits
	.align	2
	.set	.LANCHOR222,. + 0
	.type	g_MaxLbn, %object
	.size	g_MaxLbn, 4
g_MaxLbn:
	.zero	4
	.section	.bss.g_MaxLpn,"aw",@nobits
	.align	2
	.set	.LANCHOR73,. + 0
	.type	g_MaxLpn, %object
	.size	g_MaxLpn, 4
g_MaxLpn:
	.zero	4
	.section	.bss.g_SlcPartLbaEndSector,"aw",@nobits
	.align	2
	.set	.LANCHOR157,. + 0
	.type	g_SlcPartLbaEndSector, %object
	.size	g_SlcPartLbaEndSector, 4
g_SlcPartLbaEndSector:
	.zero	4
	.section	.bss.g_VaildLpn,"aw",@nobits
	.align	2
	.set	.LANCHOR101,. + 0
	.type	g_VaildLpn, %object
	.size	g_VaildLpn, 4
g_VaildLpn:
	.zero	4
	.section	.bss.g_active_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR92,. + 0
	.type	g_active_superblock, %object
	.size	g_active_superblock, 48
g_active_superblock:
	.zero	48
	.section	.bss.g_all_blk_used_slc_mode,"aw",@nobits
	.align	2
	.set	.LANCHOR158,. + 0
	.type	g_all_blk_used_slc_mode, %object
	.size	g_all_blk_used_slc_mode, 4
g_all_blk_used_slc_mode:
	.zero	4
	.section	.bss.g_buffer_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR93,. + 0
	.type	g_buffer_superblock, %object
	.size	g_buffer_superblock, 48
g_buffer_superblock:
	.zero	48
	.section	.bss.g_cur_erase_blk,"aw",@nobits
	.align	2
	.set	.LANCHOR74,. + 0
	.type	g_cur_erase_blk, %object
	.size	g_cur_erase_blk, 4
g_cur_erase_blk:
	.zero	4
	.section	.bss.g_ect_tbl_info_size,"aw",@nobits
	.align	1
	.set	.LANCHOR190,. + 0
	.type	g_ect_tbl_info_size, %object
	.size	g_ect_tbl_info_size, 2
g_ect_tbl_info_size:
	.zero	2
	.section	.bss.g_ect_tbl_power_up_flush,"aw",@nobits
	.align	1
	.set	.LANCHOR218,. + 0
	.type	g_ect_tbl_power_up_flush, %object
	.size	g_ect_tbl_power_up_flush, 2
g_ect_tbl_power_up_flush:
	.zero	2
	.section	.bss.g_flash_read_only_en,"aw",@nobits
	.align	2
	.set	.LANCHOR77,. + 0
	.type	g_flash_read_only_en, %object
	.size	g_flash_read_only_en, 4
g_flash_read_only_en:
	.zero	4
	.section	.bss.g_free_slc_blk_num,"aw",@nobits
	.align	1
	.set	.LANCHOR139,. + 0
	.type	g_free_slc_blk_num, %object
	.size	g_free_slc_blk_num, 2
g_free_slc_blk_num:
	.zero	2
	.section	.bss.g_ftl_nand_free_count,"aw",@nobits
	.align	2
	.set	.LANCHOR246,. + 0
	.type	g_ftl_nand_free_count, %object
	.size	g_ftl_nand_free_count, 4
g_ftl_nand_free_count:
	.zero	4
	.section	.bss.g_gc_bad_block_gc_index,"aw",@nobits
	.align	1
	.set	.LANCHOR119,. + 0
	.type	g_gc_bad_block_gc_index, %object
	.size	g_gc_bad_block_gc_index, 2
g_gc_bad_block_gc_index:
	.zero	2
	.section	.bss.g_gc_bad_block_temp_num,"aw",@nobits
	.align	1
	.set	.LANCHOR117,. + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.zero	2
	.section	.bss.g_gc_bad_block_temp_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR118,. + 0
	.type	g_gc_bad_block_temp_tbl, %object
	.size	g_gc_bad_block_temp_tbl, 34
g_gc_bad_block_temp_tbl:
	.zero	34
	.section	.bss.g_gc_blk_index,"aw",@nobits
	.align	1
	.set	.LANCHOR178,. + 0
	.type	g_gc_blk_index, %object
	.size	g_gc_blk_index, 2
g_gc_blk_index:
	.zero	2
	.section	.bss.g_gc_blk_num,"aw",@nobits
	.align	1
	.set	.LANCHOR109,. + 0
	.type	g_gc_blk_num, %object
	.size	g_gc_blk_num, 2
g_gc_blk_num:
	.zero	2
	.section	.bss.g_gc_cur_blk_max_valid_pages,"aw",@nobits
	.align	1
	.set	.LANCHOR242,. + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.zero	2
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",@nobits
	.align	1
	.set	.LANCHOR241,. + 0
	.type	g_gc_cur_blk_valid_pages, %object
	.size	g_gc_cur_blk_valid_pages, 2
g_gc_cur_blk_valid_pages:
	.zero	2
	.section	.bss.g_gc_free_blk_threshold,"aw",@nobits
	.align	1
	.set	.LANCHOR176,. + 0
	.type	g_gc_free_blk_threshold, %object
	.size	g_gc_free_blk_threshold, 2
g_gc_free_blk_threshold:
	.zero	2
	.section	.bss.g_gc_head_data_block,"aw",@nobits
	.align	2
	.set	.LANCHOR173,. + 0
	.type	g_gc_head_data_block, %object
	.size	g_gc_head_data_block, 4
g_gc_head_data_block:
	.zero	4
	.section	.bss.g_gc_head_data_block_count,"aw",@nobits
	.align	2
	.set	.LANCHOR174,. + 0
	.type	g_gc_head_data_block_count, %object
	.size	g_gc_head_data_block_count, 4
g_gc_head_data_block_count:
	.zero	4
	.section	.bss.g_gc_merge_free_blk_threshold,"aw",@nobits
	.align	1
	.set	.LANCHOR177,. + 0
	.type	g_gc_merge_free_blk_threshold, %object
	.size	g_gc_merge_free_blk_threshold, 2
g_gc_merge_free_blk_threshold:
	.zero	2
	.section	.bss.g_gc_next_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR113,. + 0
	.type	g_gc_next_blk, %object
	.size	g_gc_next_blk, 2
g_gc_next_blk:
	.zero	2
	.section	.bss.g_gc_next_blk_1,"aw",@nobits
	.align	1
	.set	.LANCHOR114,. + 0
	.type	g_gc_next_blk_1, %object
	.size	g_gc_next_blk_1, 2
g_gc_next_blk_1:
	.zero	2
	.section	.bss.g_gc_next_blk_2,"aw",@nobits
	.align	1
	.set	.LANCHOR115,. + 0
	.type	g_gc_next_blk_2, %object
	.size	g_gc_next_blk_2, 2
g_gc_next_blk_2:
	.zero	2
	.section	.bss.g_gc_next_blk_3,"aw",@nobits
	.align	1
	.set	.LANCHOR116,. + 0
	.type	g_gc_next_blk_3, %object
	.size	g_gc_next_blk_3, 2
g_gc_next_blk_3:
	.zero	2
	.section	.bss.g_gc_num_req,"aw",@nobits
	.align	2
	.set	.LANCHOR103,. + 0
	.type	g_gc_num_req, %object
	.size	g_gc_num_req, 4
g_gc_num_req:
	.zero	4
	.section	.bss.g_gc_page_offset,"aw",@nobits
	.align	1
	.set	.LANCHOR111,. + 0
	.type	g_gc_page_offset, %object
	.size	g_gc_page_offset, 2
g_gc_page_offset:
	.zero	2
	.section	.bss.g_gc_refresh_block_temp_num,"aw",@nobits
	.align	1
	.set	.LANCHOR179,. + 0
	.type	g_gc_refresh_block_temp_num, %object
	.size	g_gc_refresh_block_temp_num, 2
g_gc_refresh_block_temp_num:
	.zero	2
	.section	.bss.g_gc_refresh_block_temp_tbl,"aw",@nobits
	.align	3
	.type	g_gc_refresh_block_temp_tbl, %object
	.size	g_gc_refresh_block_temp_tbl, 34
g_gc_refresh_block_temp_tbl:
	.zero	34
	.section	.bss.g_gc_skip_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR175,. + 0
	.type	g_gc_skip_write_count, %object
	.size	g_gc_skip_write_count, 4
g_gc_skip_write_count:
	.zero	4
	.section	.bss.g_gc_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR204,. + 0
	.type	g_gc_superblock, %object
	.size	g_gc_superblock, 48
g_gc_superblock:
	.zero	48
	.section	.bss.g_gc_temp_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR94,. + 0
	.type	g_gc_temp_superblock, %object
	.size	g_gc_temp_superblock, 48
g_gc_temp_superblock:
	.zero	48
	.section	.bss.g_in_gc_progress,"aw",@nobits
	.align	2
	.set	.LANCHOR171,. + 0
	.type	g_in_gc_progress, %object
	.size	g_in_gc_progress, 4
g_in_gc_progress:
	.zero	4
	.section	.bss.g_in_swl_replace,"aw",@nobits
	.align	2
	.set	.LANCHOR172,. + 0
	.type	g_in_swl_replace, %object
	.size	g_in_swl_replace, 4
g_in_swl_replace:
	.zero	4
	.section	.bss.g_inkDie_check_enable,"aw",@nobits
	.align	2
	.set	.LANCHOR28,. + 0
	.type	g_inkDie_check_enable, %object
	.size	g_inkDie_check_enable, 4
g_inkDie_check_enable:
	.zero	4
	.section	.bss.g_l2p_last_update_region_id,"aw",@nobits
	.align	1
	.set	.LANCHOR98,. + 0
	.type	g_l2p_last_update_region_id, %object
	.size	g_l2p_last_update_region_id, 2
g_l2p_last_update_region_id:
	.zero	2
	.section	.bss.g_maxRegNum,"aw",@nobits
	.set	.LANCHOR13,. + 0
	.type	g_maxRegNum, %object
	.size	g_maxRegNum, 1
g_maxRegNum:
	.zero	1
	.section	.bss.g_maxRetryCount,"aw",@nobits
	.set	.LANCHOR151,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.zero	1
	.section	.bss.g_max_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR169,. + 0
	.type	g_max_erase_count, %object
	.size	g_max_erase_count, 4
g_max_erase_count:
	.zero	4
	.section	.bss.g_min_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR170,. + 0
	.type	g_min_erase_count, %object
	.size	g_min_erase_count, 4
g_min_erase_count:
	.zero	4
	.section	.bss.g_nandc_version_data,"aw",@nobits
	.align	2
	.set	.LANCHOR29,. + 0
	.type	g_nandc_version_data, %object
	.size	g_nandc_version_data, 4
g_nandc_version_data:
	.zero	4
	.section	.bss.g_num_data_superblocks,"aw",@nobits
	.align	1
	.set	.LANCHOR86,. + 0
	.type	g_num_data_superblocks, %object
	.size	g_num_data_superblocks, 2
g_num_data_superblocks:
	.zero	2
	.section	.bss.g_num_free_superblocks,"aw",@nobits
	.align	1
	.set	.LANCHOR89,. + 0
	.type	g_num_free_superblocks, %object
	.size	g_num_free_superblocks, 2
g_num_free_superblocks:
	.zero	2
	.section	.bss.g_page_map_check_enable,"aw",@nobits
	.align	1
	.set	.LANCHOR70,. + 0
	.type	g_page_map_check_enable, %object
	.size	g_page_map_check_enable, 2
g_page_map_check_enable:
	.zero	2
	.section	.bss.g_power_lost_ecc_error_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR235,. + 0
	.type	g_power_lost_ecc_error_blk, %object
	.size	g_power_lost_ecc_error_blk, 2
g_power_lost_ecc_error_blk:
	.zero	2
	.section	.bss.g_power_lost_recovery_flag,"aw",@nobits
	.align	1
	.set	.LANCHOR236,. + 0
	.type	g_power_lost_recovery_flag, %object
	.size	g_power_lost_recovery_flag, 2
g_power_lost_recovery_flag:
	.zero	2
	.section	.bss.g_recovery_page_min_ver,"aw",@nobits
	.align	2
	.set	.LANCHOR136,. + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.zero	4
	.section	.bss.g_recovery_page_num,"aw",@nobits
	.align	2
	.set	.LANCHOR237,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.zero	4
	.section	.bss.g_recovery_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR238,. + 0
	.type	g_recovery_ppa_tbl, %object
	.size	g_recovery_ppa_tbl, 128
g_recovery_ppa_tbl:
	.zero	128
	.section	.bss.g_req_cache,"aw",@nobits
	.align	3
	.set	.LANCHOR132,. + 0
	.type	g_req_cache, %object
	.size	g_req_cache, 8
g_req_cache:
	.zero	8
	.section	.bss.g_retryMode,"aw",@nobits
	.set	.LANCHOR11,. + 0
	.type	g_retryMode, %object
	.size	g_retryMode, 1
g_retryMode:
	.zero	1
	.section	.bss.g_slc2KBNand,"aw",@nobits
	.set	.LANCHOR1,. + 0
	.type	g_slc2KBNand, %object
	.size	g_slc2KBNand, 1
g_slc2KBNand:
	.zero	1
	.section	.bss.g_sys_ext_data,"aw",@nobits
	.align	3
	.set	.LANCHOR138,. + 0
	.type	g_sys_ext_data, %object
	.size	g_sys_ext_data, 512
g_sys_ext_data:
	.zero	512
	.section	.bss.g_sys_save_data,"aw",@nobits
	.align	3
	.set	.LANCHOR81,. + 0
	.type	g_sys_save_data, %object
	.size	g_sys_save_data, 48
g_sys_save_data:
	.zero	48
	.section	.bss.g_tmp_data_superblock_id,"aw",@nobits
	.align	1
	.set	.LANCHOR133,. + 0
	.type	g_tmp_data_superblock_id, %object
	.size	g_tmp_data_superblock_id, 2
g_tmp_data_superblock_id:
	.zero	2
	.section	.bss.g_totle_avg_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR205,. + 0
	.type	g_totle_avg_erase_count, %object
	.size	g_totle_avg_erase_count, 4
g_totle_avg_erase_count:
	.zero	4
	.section	.bss.g_totle_cache_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR164,. + 0
	.type	g_totle_cache_write_count, %object
	.size	g_totle_cache_write_count, 4
g_totle_cache_write_count:
	.zero	4
	.section	.bss.g_totle_discard_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR163,. + 0
	.type	g_totle_discard_page_count, %object
	.size	g_totle_discard_page_count, 4
g_totle_discard_page_count:
	.zero	4
	.section	.bss.g_totle_gc_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR161,. + 0
	.type	g_totle_gc_page_count, %object
	.size	g_totle_gc_page_count, 4
g_totle_gc_page_count:
	.zero	4
	.section	.bss.g_totle_l2p_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR165,. + 0
	.type	g_totle_l2p_write_count, %object
	.size	g_totle_l2p_write_count, 4
g_totle_l2p_write_count:
	.zero	4
	.section	.bss.g_totle_map_block,"aw",@nobits
	.align	1
	.set	.LANCHOR128,. + 0
	.type	g_totle_map_block, %object
	.size	g_totle_map_block, 2
g_totle_map_block:
	.zero	2
	.section	.bss.g_totle_mlc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR167,. + 0
	.type	g_totle_mlc_erase_count, %object
	.size	g_totle_mlc_erase_count, 4
g_totle_mlc_erase_count:
	.zero	4
	.section	.bss.g_totle_read_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR166,. + 0
	.type	g_totle_read_page_count, %object
	.size	g_totle_read_page_count, 4
g_totle_read_page_count:
	.zero	4
	.section	.bss.g_totle_read_sector,"aw",@nobits
	.align	2
	.set	.LANCHOR217,. + 0
	.type	g_totle_read_sector, %object
	.size	g_totle_read_sector, 4
g_totle_read_sector:
	.zero	4
	.section	.bss.g_totle_slc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR168,. + 0
	.type	g_totle_slc_erase_count, %object
	.size	g_totle_slc_erase_count, 4
g_totle_slc_erase_count:
	.zero	4
	.section	.bss.g_totle_swl_count,"aw",@nobits
	.align	2
	.set	.LANCHOR134,. + 0
	.type	g_totle_swl_count, %object
	.size	g_totle_swl_count, 4
g_totle_swl_count:
	.zero	4
	.section	.bss.g_totle_sys_slc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR80,. + 0
	.type	g_totle_sys_slc_erase_count, %object
	.size	g_totle_sys_slc_erase_count, 4
g_totle_sys_slc_erase_count:
	.zero	4
	.section	.bss.g_totle_vendor_block,"aw",@nobits
	.align	1
	.set	.LANCHOR71,. + 0
	.type	g_totle_vendor_block, %object
	.size	g_totle_vendor_block, 2
g_totle_vendor_block:
	.zero	2
	.section	.bss.g_totle_write_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR162,. + 0
	.type	g_totle_write_page_count, %object
	.size	g_totle_write_page_count, 4
g_totle_write_page_count:
	.zero	4
	.section	.bss.g_totle_write_sector,"aw",@nobits
	.align	2
	.set	.LANCHOR216,. + 0
	.type	g_totle_write_sector, %object
	.size	g_totle_write_sector, 4
g_totle_write_sector:
	.zero	4
	.section	.bss.gc_discard_updated,"aw",@nobits
	.align	2
	.set	.LANCHOR232,. + 0
	.type	gc_discard_updated, %object
	.size	gc_discard_updated, 4
gc_discard_updated:
	.zero	4
	.section	.bss.gc_ink_free_return_value,"aw",@nobits
	.align	1
	.set	.LANCHOR240,. + 0
	.type	gc_ink_free_return_value, %object
	.size	gc_ink_free_return_value, 2
gc_ink_free_return_value:
	.zero	2
	.section	.bss.gpFlashSaveInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR146,. + 0
	.type	gpFlashSaveInfo, %object
	.size	gpFlashSaveInfo, 8
gpFlashSaveInfo:
	.zero	8
	.section	.bss.gpNandParaInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR18,. + 0
	.type	gpNandParaInfo, %object
	.size	gpNandParaInfo, 8
gpNandParaInfo:
	.zero	8
	.section	.bss.gpNandc,"aw",@nobits
	.align	3
	.set	.LANCHOR19,. + 0
	.type	gpNandc, %object
	.size	gpNandc, 8
gpNandc:
	.zero	8
	.section	.bss.gpNandc1,"aw",@nobits
	.align	3
	.type	gpNandc1, %object
	.size	gpNandc1, 8
gpNandc1:
	.zero	8
	.section	.bss.gpReadRetrial,"aw",@nobits
	.align	3
	.set	.LANCHOR145,. + 0
	.type	gpReadRetrial, %object
	.size	gpReadRetrial, 8
gpReadRetrial:
	.zero	8
	.section	.bss.gp_ect_tbl_info,"aw",@nobits
	.align	3
	.set	.LANCHOR191,. + 0
	.type	gp_ect_tbl_info, %object
	.size	gp_ect_tbl_info, 8
gp_ect_tbl_info:
	.zero	8
	.section	.bss.gp_flash_check_buf,"aw",@nobits
	.align	3
	.type	gp_flash_check_buf, %object
	.size	gp_flash_check_buf, 262144
gp_flash_check_buf:
	.zero	262144
	.section	.bss.gp_gc_page_buf_info,"aw",@nobits
	.align	3
	.set	.LANCHOR104,. + 0
	.type	gp_gc_page_buf_info, %object
	.size	gp_gc_page_buf_info, 8
gp_gc_page_buf_info:
	.zero	8
	.section	.bss.gp_last_act_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR230,. + 0
	.type	gp_last_act_superblock, %object
	.size	gp_last_act_superblock, 8
gp_last_act_superblock:
	.zero	8
	.section	.bss.idb_buf,"aw",@nobits
	.align	3
	.type	idb_buf, %object
	.size	idb_buf, 262144
idb_buf:
	.zero	262144
	.section	.bss.idb_need_write_back,"aw",@nobits
	.align	2
	.set	.LANCHOR154,. + 0
	.type	idb_need_write_back, %object
	.size	idb_need_write_back, 4
idb_need_write_back:
	.zero	4
	.section	.bss.mlcPageToSlcPageTbl,"aw",@nobits
	.align	2
	.set	.LANCHOR120,. + 0
	.type	mlcPageToSlcPageTbl, %object
	.size	mlcPageToSlcPageTbl, 1024
mlcPageToSlcPageTbl:
	.zero	1024
	.section	.bss.p_blk_mode_table,"aw",@nobits
	.align	3
	.set	.LANCHOR0,. + 0
	.type	p_blk_mode_table, %object
	.size	p_blk_mode_table, 8
p_blk_mode_table:
	.zero	8
	.section	.bss.p_data_block_list_head,"aw",@nobits
	.align	3
	.set	.LANCHOR83,. + 0
	.type	p_data_block_list_head, %object
	.size	p_data_block_list_head, 8
p_data_block_list_head:
	.zero	8
	.section	.bss.p_data_block_list_table,"aw",@nobits
	.align	3
	.set	.LANCHOR82,. + 0
	.type	p_data_block_list_table, %object
	.size	p_data_block_list_table, 8
p_data_block_list_table:
	.zero	8
	.section	.bss.p_data_block_list_tail,"aw",@nobits
	.align	3
	.set	.LANCHOR85,. + 0
	.type	p_data_block_list_tail, %object
	.size	p_data_block_list_tail, 8
p_data_block_list_tail:
	.zero	8
	.section	.bss.p_erase_count_table,"aw",@nobits
	.align	3
	.set	.LANCHOR79,. + 0
	.type	p_erase_count_table, %object
	.size	p_erase_count_table, 8
p_erase_count_table:
	.zero	8
	.section	.bss.p_free_data_block_list_head,"aw",@nobits
	.align	3
	.set	.LANCHOR88,. + 0
	.type	p_free_data_block_list_head, %object
	.size	p_free_data_block_list_head, 8
p_free_data_block_list_head:
	.zero	8
	.section	.bss.p_gc_blk_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR110,. + 0
	.type	p_gc_blk_tbl, %object
	.size	p_gc_blk_tbl, 8
p_gc_blk_tbl:
	.zero	8
	.section	.bss.p_gc_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR105,. + 0
	.type	p_gc_data_buf, %object
	.size	p_gc_data_buf, 8
p_gc_data_buf:
	.zero	8
	.section	.bss.p_gc_page_info,"aw",@nobits
	.align	3
	.set	.LANCHOR112,. + 0
	.type	p_gc_page_info, %object
	.size	p_gc_page_info, 8
p_gc_page_info:
	.zero	8
	.section	.bss.p_gc_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR106,. + 0
	.type	p_gc_spare_buf, %object
	.size	p_gc_spare_buf, 8
p_gc_spare_buf:
	.zero	8
	.section	.bss.p_io_data_buf_0,"aw",@nobits
	.align	3
	.set	.LANCHOR186,. + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 8
p_io_data_buf_0:
	.zero	8
	.section	.bss.p_io_data_buf_1,"aw",@nobits
	.align	3
	.set	.LANCHOR187,. + 0
	.type	p_io_data_buf_1, %object
	.size	p_io_data_buf_1, 8
p_io_data_buf_1:
	.zero	8
	.section	.bss.p_io_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR189,. + 0
	.type	p_io_spare_buf, %object
	.size	p_io_spare_buf, 8
p_io_spare_buf:
	.zero	8
	.section	.bss.p_l2p_map_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR126,. + 0
	.type	p_l2p_map_buf, %object
	.size	p_l2p_map_buf, 8
p_l2p_map_buf:
	.zero	8
	.section	.bss.p_l2p_ram_map,"aw",@nobits
	.align	3
	.set	.LANCHOR97,. + 0
	.type	p_l2p_ram_map, %object
	.size	p_l2p_ram_map, 8
p_l2p_ram_map:
	.zero	8
	.section	.bss.p_map_block_table,"aw",@nobits
	.align	3
	.set	.LANCHOR129,. + 0
	.type	p_map_block_table, %object
	.size	p_map_block_table, 8
p_map_block_table:
	.zero	8
	.section	.bss.p_map_block_valid_page_count,"aw",@nobits
	.align	3
	.set	.LANCHOR125,. + 0
	.type	p_map_block_valid_page_count, %object
	.size	p_map_block_valid_page_count, 8
p_map_block_valid_page_count:
	.zero	8
	.section	.bss.p_map_block_ver_table,"aw",@nobits
	.align	3
	.set	.LANCHOR130,. + 0
	.type	p_map_block_ver_table, %object
	.size	p_map_block_ver_table, 8
p_map_block_ver_table:
	.zero	8
	.section	.bss.p_map_region_ppn_check_table,"aw",@nobits
	.align	3
	.set	.LANCHOR195,. + 0
	.type	p_map_region_ppn_check_table, %object
	.size	p_map_region_ppn_check_table, 8
p_map_region_ppn_check_table:
	.zero	8
	.section	.bss.p_map_region_ppn_table,"aw",@nobits
	.align	3
	.set	.LANCHOR131,. + 0
	.type	p_map_region_ppn_table, %object
	.size	p_map_region_ppn_table, 8
p_map_region_ppn_table:
	.zero	8
	.section	.bss.p_plane_order_table,"aw",@nobits
	.align	3
	.set	.LANCHOR47,. + 0
	.type	p_plane_order_table, %object
	.size	p_plane_order_table, 32
p_plane_order_table:
	.zero	32
	.section	.bss.p_swl_mul_table,"aw",@nobits
	.align	3
	.set	.LANCHOR137,. + 0
	.type	p_swl_mul_table, %object
	.size	p_swl_mul_table, 8
p_swl_mul_table:
	.zero	8
	.section	.bss.p_sys_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR183,. + 0
	.type	p_sys_data_buf, %object
	.size	p_sys_data_buf, 8
p_sys_data_buf:
	.zero	8
	.section	.bss.p_sys_data_buf_1,"aw",@nobits
	.align	3
	.set	.LANCHOR184,. + 0
	.type	p_sys_data_buf_1, %object
	.size	p_sys_data_buf_1, 8
p_sys_data_buf_1:
	.zero	8
	.section	.bss.p_sys_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR188,. + 0
	.type	p_sys_spare_buf, %object
	.size	p_sys_spare_buf, 8
p_sys_spare_buf:
	.zero	8
	.section	.bss.p_valid_page_count_check_table,"aw",@nobits
	.align	3
	.type	p_valid_page_count_check_table, %object
	.size	p_valid_page_count_check_table, 8
p_valid_page_count_check_table:
	.zero	8
	.section	.bss.p_valid_page_count_table,"aw",@nobits
	.align	3
	.set	.LANCHOR84,. + 0
	.type	p_valid_page_count_table, %object
	.size	p_valid_page_count_table, 8
p_valid_page_count_table:
	.zero	8
	.section	.bss.p_vendor_block_table,"aw",@nobits
	.align	3
	.set	.LANCHOR72,. + 0
	.type	p_vendor_block_table, %object
	.size	p_vendor_block_table, 8
p_vendor_block_table:
	.zero	8
	.section	.bss.p_vendor_block_valid_page_count,"aw",@nobits
	.align	3
	.set	.LANCHOR192,. + 0
	.type	p_vendor_block_valid_page_count, %object
	.size	p_vendor_block_valid_page_count, 8
p_vendor_block_valid_page_count:
	.zero	8
	.section	.bss.p_vendor_block_ver_table,"aw",@nobits
	.align	3
	.set	.LANCHOR193,. + 0
	.type	p_vendor_block_ver_table, %object
	.size	p_vendor_block_ver_table, 8
p_vendor_block_ver_table:
	.zero	8
	.section	.bss.p_vendor_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR185,. + 0
	.type	p_vendor_data_buf, %object
	.size	p_vendor_data_buf, 8
p_vendor_data_buf:
	.zero	8
	.section	.bss.p_vendor_region_ppn_table,"aw",@nobits
	.align	3
	.set	.LANCHOR194,. + 0
	.type	p_vendor_region_ppn_table, %object
	.size	p_vendor_region_ppn_table, 8
p_vendor_region_ppn_table:
	.zero	8
	.section	.bss.read_retry_cur_offset,"aw",@nobits
	.align	3
	.set	.LANCHOR21,. + 0
	.type	read_retry_cur_offset, %object
	.size	read_retry_cur_offset, 4
read_retry_cur_offset:
	.zero	4
	.section	.bss.req_erase,"aw",@nobits
	.align	3
	.set	.LANCHOR78,. + 0
	.type	req_erase, %object
	.size	req_erase, 8
req_erase:
	.zero	8
	.section	.bss.req_gc,"aw",@nobits
	.align	3
	.set	.LANCHOR107,. + 0
	.type	req_gc, %object
	.size	req_gc, 8
req_gc:
	.zero	8
	.section	.bss.req_gc_dst,"aw",@nobits
	.align	3
	.set	.LANCHOR181,. + 0
	.type	req_gc_dst, %object
	.size	req_gc_dst, 8
req_gc_dst:
	.zero	8
	.section	.bss.req_prgm,"aw",@nobits
	.align	3
	.set	.LANCHOR182,. + 0
	.type	req_prgm, %object
	.size	req_prgm, 8
req_prgm:
	.zero	8
	.section	.bss.req_read,"aw",@nobits
	.align	3
	.set	.LANCHOR180,. + 0
	.type	req_read, %object
	.size	req_read, 8
req_read:
	.zero	8
	.section	.bss.req_sys,"aw",@nobits
	.align	3
	.set	.LANCHOR202,. + 0
	.type	req_sys, %object
	.size	req_sys, 56
req_sys:
	.zero	56
	.section	.bss.slcPageToMlcPageTbl,"aw",@nobits
	.align	2
	.set	.LANCHOR16,. + 0
	.type	slcPageToMlcPageTbl, %object
	.size	slcPageToMlcPageTbl, 512
slcPageToMlcPageTbl:
	.zero	512
	.section	.data.FtlMallocOffset,"aw",@progbits
	.align	2
	.type	FtlMallocOffset, %object
	.size	FtlMallocOffset, 4
FtlMallocOffset:
	.word	64
	.section	.data.LastWritenPbaAddr,"aw",@progbits
	.align	2
	.type	LastWritenPbaAddr, %object
	.size	LastWritenPbaAddr, 4
LastWritenPbaAddr:
	.word	-1
	.section	.data.NandFlashParaTbl,"aw",@progbits
	.align	3
	.set	.LANCHOR142,. + 0
	.type	NandFlashParaTbl, %object
	.size	NandFlashParaTbl, 2464
NandFlashParaTbl:
	.byte	6
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
	.byte	2
	.hword	2048
	.hword	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	44
	.byte	104
	.byte	4
	.byte	74
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	8
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	5
	.byte	44
	.byte	-120
	.byte	4
	.byte	75
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	44
	.byte	-88
	.byte	5
	.byte	-53
	.byte	-87
	.byte	0
	.byte	4
	.byte	2
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	44
	.byte	104
	.byte	4
	.byte	70
	.byte	-119
	.byte	0
	.byte	4
	.byte	1
	.byte	8
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	44
	.byte	72
	.byte	4
	.byte	74
	.byte	-91
	.byte	0
	.byte	4
	.byte	1
	.byte	8
	.hword	256
	.byte	2
	.byte	2
	.hword	1024
	.hword	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
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
	.byte	0
	.byte	0
	.zero	4
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
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	44
	.byte	-41
	.byte	-108
	.byte	62
	.byte	-124
	.byte	0
	.byte	4
	.byte	1
	.byte	8
	.hword	128
	.byte	2
	.byte	2
	.hword	4096
	.hword	279
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	44
	.byte	72
	.byte	4
	.byte	70
	.byte	-123
	.byte	0
	.byte	4
	.byte	1
	.byte	8
	.hword	256
	.byte	2
	.byte	2
	.hword	1024
	.hword	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	44
	.byte	-120
	.byte	5
	.byte	-58
	.byte	-119
	.byte	0
	.byte	4
	.byte	2
	.byte	8
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	5
	.byte	44
	.byte	-120
	.byte	36
	.byte	75
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	287
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	44
	.byte	104
	.byte	0
	.byte	39
	.byte	-87
	.byte	0
	.byte	4
	.byte	1
	.byte	16
	.hword	128
	.byte	1
	.byte	2
	.hword	2048
	.hword	287
	.byte	0
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	44
	.byte	-124
	.byte	-59
	.byte	75
	.byte	-87
	.byte	0
	.byte	4
	.byte	2
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	44
	.byte	-43
	.byte	-47
	.byte	-90
	.byte	104
	.byte	0
	.byte	4
	.byte	2
	.byte	8
	.hword	64
	.byte	1
	.byte	2
	.hword	2048
	.hword	279
	.byte	0
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	44
	.byte	-36
	.byte	-112
	.byte	-90
	.byte	84
	.byte	0
	.byte	4
	.byte	1
	.byte	8
	.hword	64
	.byte	1
	.byte	2
	.hword	1024
	.hword	279
	.byte	0
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.byte	0
	.byte	0
	.zero	4
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
	.hword	1479
	.byte	5
	.byte	19
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.zero	4
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
	.hword	1479
	.byte	5
	.byte	19
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.zero	4
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
	.hword	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.hword	1479
	.byte	5
	.byte	19
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.zero	4
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
	.hword	1479
	.byte	5
	.byte	19
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.zero	4
	.byte	6
	.byte	-83
	.byte	-34
	.byte	-108
	.byte	-46
	.byte	4
	.byte	67
	.byte	2
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	473
	.byte	1
	.byte	1
	.byte	24
	.byte	32
	.byte	4
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-83
	.byte	-41
	.byte	-108
	.byte	-38
	.byte	116
	.byte	-61
	.byte	2
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	1024
	.hword	473
	.byte	1
	.byte	2
	.byte	40
	.byte	32
	.byte	4
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-83
	.byte	-34
	.byte	-108
	.byte	-38
	.byte	116
	.byte	-60
	.byte	2
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	2090
	.hword	473
	.byte	1
	.byte	4
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-83
	.byte	-43
	.byte	-108
	.byte	-38
	.byte	116
	.byte	-60
	.byte	2
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	530
	.hword	473
	.byte	1
	.byte	3
	.byte	40
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-83
	.byte	-41
	.byte	-108
	.byte	-102
	.byte	116
	.byte	66
	.byte	2
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	1024
	.hword	281
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	4
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.byte	0
	.byte	0
	.zero	4
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
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-83
	.byte	-34
	.byte	-108
	.byte	-89
	.byte	66
	.byte	72
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
	.byte	0
	.byte	0
	.zero	4
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
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-83
	.byte	-43
	.byte	-108
	.byte	-102
	.byte	116
	.byte	66
	.byte	2
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	1
	.hword	1024
	.hword	273
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	4
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.byte	2
	.hword	2048
	.hword	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.byte	2
	.hword	2048
	.hword	479
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-119
	.byte	-120
	.byte	36
	.byte	75
	.byte	-87
	.byte	0
	.byte	7
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	279
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-119
	.byte	104
	.byte	36
	.byte	74
	.byte	-87
	.byte	0
	.byte	7
	.byte	1
	.byte	8
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	279
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-119
	.byte	104
	.byte	4
	.byte	74
	.byte	-87
	.byte	0
	.byte	7
	.byte	1
	.byte	8
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	279
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-119
	.byte	-41
	.byte	-108
	.byte	62
	.byte	-124
	.byte	0
	.byte	7
	.byte	1
	.byte	8
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	279
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-119
	.byte	104
	.byte	4
	.byte	70
	.byte	-87
	.byte	0
	.byte	7
	.byte	1
	.byte	8
	.hword	256
	.byte	2
	.byte	2
	.hword	2048
	.hword	279
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.byte	3
	.byte	17
	.byte	40
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.hword	1473
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.hword	1473
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-104
	.byte	58
	.byte	-123
	.byte	-109
	.byte	118
	.byte	87
	.byte	1
	.byte	2
	.byte	32
	.hword	256
	.byte	2
	.byte	1
	.hword	2092
	.hword	1505
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-104
	.byte	-43
	.byte	-124
	.byte	50
	.byte	114
	.byte	86
	.byte	1
	.byte	1
	.byte	16
	.hword	128
	.byte	2
	.byte	1
	.hword	2056
	.hword	1473
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-104
	.byte	-41
	.byte	-108
	.byte	50
	.byte	118
	.byte	86
	.byte	1
	.byte	1
	.byte	16
	.hword	128
	.byte	2
	.byte	2
	.hword	2058
	.hword	1489
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-104
	.byte	-34
	.byte	-108
	.byte	-126
	.byte	118
	.byte	86
	.byte	1
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	2062
	.hword	1489
	.byte	1
	.byte	33
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.hword	1497
	.byte	2
	.byte	34
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-104
	.byte	58
	.byte	-107
	.byte	-109
	.byte	122
	.byte	80
	.byte	1
	.byte	2
	.byte	32
	.hword	256
	.byte	2
	.byte	2
	.hword	1066
	.hword	1497
	.byte	2
	.byte	34
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-104
	.byte	-41
	.byte	-108
	.byte	50
	.byte	118
	.byte	85
	.byte	1
	.byte	1
	.byte	16
	.hword	128
	.byte	2
	.byte	2
	.hword	2050
	.hword	401
	.byte	2
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.hword	1497
	.byte	2
	.byte	33
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.hword	1473
	.byte	2
	.byte	34
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.hword	1497
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.hword	1497
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.hword	1497
	.byte	2
	.byte	35
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.hword	1473
	.byte	2
	.byte	66
	.byte	40
	.byte	32
	.byte	2
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	69
	.byte	-34
	.byte	-92
	.byte	-126
	.byte	118
	.byte	86
	.byte	8
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	2082
	.hword	473
	.byte	1
	.byte	65
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	69
	.byte	-41
	.byte	-124
	.byte	-109
	.byte	114
	.byte	80
	.byte	8
	.byte	1
	.byte	32
	.hword	256
	.byte	2
	.byte	1
	.hword	1060
	.hword	1473
	.byte	2
	.byte	67
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	69
	.byte	-34
	.byte	-92
	.byte	-126
	.byte	118
	.byte	-41
	.byte	8
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	2090
	.hword	1241
	.byte	1
	.byte	66
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	69
	.byte	-34
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
	.hword	2092
	.hword	1473
	.byte	2
	.byte	66
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.hword	473
	.byte	2
	.byte	68
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.hword	473
	.byte	2
	.byte	68
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	4
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	69
	.byte	58
	.byte	-92
	.byte	-109
	.byte	122
	.byte	80
	.byte	8
	.byte	1
	.byte	32
	.hword	256
	.byte	2
	.byte	2
	.hword	2138
	.hword	1497
	.byte	2
	.byte	0
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	69
	.byte	-34
	.byte	-108
	.byte	-126
	.byte	118
	.byte	86
	.byte	8
	.byte	1
	.byte	16
	.hword	256
	.byte	2
	.byte	2
	.hword	2062
	.hword	473
	.byte	1
	.byte	0
	.byte	40
	.byte	32
	.byte	3
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	69
	.byte	-34
	.byte	-108
	.byte	-109
	.byte	118
	.byte	-41
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
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-20
	.byte	-41
	.byte	-108
	.byte	126
	.byte	100
	.byte	68
	.byte	0
	.byte	1
	.byte	16
	.hword	128
	.byte	2
	.byte	2
	.hword	2048
	.hword	473
	.byte	2
	.byte	49
	.byte	60
	.byte	36
	.byte	3
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-20
	.byte	-34
	.byte	-43
	.byte	126
	.byte	104
	.byte	68
	.byte	0
	.byte	2
	.byte	16
	.hword	128
	.byte	2
	.byte	2
	.hword	2048
	.hword	505
	.byte	2
	.byte	49
	.byte	60
	.byte	36
	.byte	3
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-20
	.byte	-41
	.byte	-108
	.byte	122
	.byte	84
	.byte	67
	.byte	0
	.byte	1
	.byte	16
	.hword	128
	.byte	2
	.byte	2
	.hword	2076
	.hword	409
	.byte	2
	.byte	0
	.byte	40
	.byte	36
	.byte	3
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-20
	.byte	-34
	.byte	-43
	.byte	122
	.byte	88
	.byte	67
	.byte	0
	.byte	2
	.byte	16
	.hword	128
	.byte	2
	.byte	2
	.hword	2076
	.hword	441
	.byte	2
	.byte	0
	.byte	40
	.byte	36
	.byte	3
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-20
	.byte	-43
	.byte	-108
	.byte	118
	.byte	84
	.byte	67
	.byte	0
	.byte	1
	.byte	16
	.hword	128
	.byte	2
	.byte	2
	.hword	1038
	.hword	281
	.byte	2
	.byte	0
	.byte	24
	.byte	36
	.byte	3
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.byte	6
	.byte	-20
	.byte	-41
	.byte	20
	.byte	118
	.byte	84
	.byte	-62
	.byte	0
	.byte	1
	.byte	16
	.hword	128
	.byte	2
	.byte	2
	.hword	2076
	.hword	1169
	.byte	2
	.byte	0
	.byte	24
	.byte	40
	.byte	3
	.byte	1
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.zero	4
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
	.section	.data.SamsungRefValue,"aw",@progbits
	.align	3
	.set	.LANCHOR14,. + 0
	.type	SamsungRefValue, %object
	.size	SamsungRefValue, 64
SamsungRefValue:
	.byte	-89
	.byte	-92
	.byte	-91
	.byte	-90
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	5
	.byte	10
	.byte	0
	.byte	0
	.byte	40
	.byte	0
	.byte	-20
	.byte	-40
	.byte	-19
	.byte	-11
	.byte	-19
	.byte	-26
	.byte	10
	.byte	15
	.byte	5
	.byte	0
	.byte	15
	.byte	10
	.byte	-5
	.byte	-20
	.byte	-24
	.byte	-17
	.byte	-24
	.byte	-36
	.byte	-15
	.byte	-5
	.byte	-2
	.byte	-16
	.byte	10
	.byte	0
	.byte	-5
	.byte	-20
	.byte	-48
	.byte	-30
	.byte	-48
	.byte	-62
	.byte	20
	.byte	15
	.byte	-5
	.byte	-20
	.byte	-24
	.byte	-5
	.byte	-24
	.byte	-36
	.byte	30
	.byte	20
	.byte	-5
	.byte	-20
	.byte	-5
	.byte	-1
	.byte	-5
	.byte	-8
	.byte	7
	.byte	12
	.byte	2
	.byte	0
	.section	.data.Toshiba15RefValue,"aw",@progbits
	.align	3
	.set	.LANCHOR9,. + 0
	.type	Toshiba15RefValue, %object
	.size	Toshiba15RefValue, 95
Toshiba15RefValue:
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
	.section	.data.ToshibaA19RefValue,"aw",@progbits
	.align	3
	.set	.LANCHOR10,. + 0
	.type	ToshibaA19RefValue, %object
	.size	ToshibaA19RefValue, 45
ToshibaA19RefValue:
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
	.section	.data.ToshibaRefValue,"aw",@progbits
	.align	3
	.set	.LANCHOR12,. + 0
	.type	ToshibaRefValue, %object
	.size	ToshibaRefValue, 8
ToshibaRefValue:
	.byte	0
	.byte	4
	.byte	124
	.byte	120
	.byte	116
	.byte	8
	.byte	12
	.byte	112
	.section	.data.ftl_gc_temp_block_bops_scan_page_addr,"aw",@progbits
	.align	1
	.set	.LANCHOR226,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.hword	-1
	.section	.data.gFtlInitStatus,"aw",@progbits
	.align	2
	.set	.LANCHOR231,. + 0
	.type	gFtlInitStatus, %object
	.size	gFtlInitStatus, 4
gFtlInitStatus:
	.word	-1
	.section	.data.gNandParaInfo,"aw",@progbits
	.align	3
	.set	.LANCHOR31,. + 0
	.type	gNandParaInfo, %object
	.size	gNandParaInfo, 32
gNandParaInfo:
	.byte	0
	.byte	0
	.zero	5
	.byte	0
	.byte	1
	.byte	8
	.hword	128
	.byte	2
	.byte	1
	.hword	2048
	.hword	0
	.byte	1
	.byte	0
	.byte	24
	.byte	32
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.section	.data.gSlcNandParaInfo,"aw",@progbits
	.align	3
	.set	.LANCHOR200,. + 0
	.type	gSlcNandParaInfo, %object
	.size	gSlcNandParaInfo, 32
gSlcNandParaInfo:
	.byte	2
	.byte	-104
	.byte	-15
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	4
	.hword	64
	.byte	1
	.byte	1
	.hword	1024
	.hword	256
	.byte	0
	.byte	0
	.byte	16
	.byte	40
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.zero	4
	.section	.data.power_up_flag,"aw",@progbits
	.align	2
	.type	power_up_flag, %object
	.size	power_up_flag, 4
power_up_flag:
	.word	1
	.section	.data.random_seed,"aw",@progbits
	.align	3
	.set	.LANCHOR4,. + 0
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
	.section	.data.refValueDefault,"aw",@progbits
	.align	3
	.set	.LANCHOR196,. + 0
	.type	refValueDefault, %object
	.size	refValueDefault, 28
refValueDefault:
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
	.section	.rodata.FlashDdrTunningRead.str1.1,"aMS",@progbits,1
.LC9:
	.string	"sdr read ok %x ecc=%d\n"
.LC10:
	.string	"sync para %d\n"
.LC11:
	.string	"TOG mode Read error %x %x\n"
	.section	.rodata.FlashEraseSLc2KBlocks.str1.1,"aMS",@progbits,1
.LC1:
	.string	"FlashEraseBlocks pageAddr error %x\n"
	.section	.rodata.FlashInit.str1.1,"aMS",@progbits,1
.LC23:
	.string	"No.%d FLASH ID:%x %x %x %x %x %x\n"
.LC24:
	.string	"FlashLoadPhyInfo fail %x!!\n"
	.section	.rodata.FlashProgSlc2KPages.str1.1,"aMS",@progbits,1
.LC29:
	.string	"prog error: = %x\n"
.LC30:
	.string	"prog read error: = %x\n"
.LC31:
	.string	"prog read s error: = %x %x %x\n"
.LC32:
	.string	"prog read d error: = %x %x %x\n"
	.section	.rodata.FlashReadFacBbtData.str1.1,"aMS",@progbits,1
.LC53:
	.string	"BBT:"
	.section	.rodata.FlashReadIdbDataRaw.str1.1,"aMS",@progbits,1
.LC14:
	.string	"ECC:%d\n"
	.section	.rodata.FlashReadPage.str1.1,"aMS",@progbits,1
.LC12:
	.string	"read retry status %x %x %x\n"
	.section	.rodata.FlashReadPages.str1.1,"aMS",@progbits,1
.LC28:
	.string	"ReadRetry pageadd=%x ecc=%x err=%x\n"
	.section	.rodata.FlashReadSlc2KPages.str1.1,"aMS",@progbits,1
.LC25:
	.string	"Read pageadd=%x  ecc=%x err=%x\n"
.LC26:
	.string	"data:"
.LC27:
	.string	"spare:"
	.section	.rodata.FtlBbmMapBadBlock.str1.1,"aMS",@progbits,1
.LC2:
	.string	"phyBlk = 0x%x die = %d block_in_die = 0x%x 0x%8x\n"
	.section	.rodata.FtlBbmTblFlush.str1.1,"aMS",@progbits,1
.LC33:
	.string	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\n"
.LC34:
	.string	"FtlBbmTblFlush error:%x\n"
.LC35:
	.string	"FtlBbmTblFlush error = %x error count = %d\n"
	.section	.rodata.FtlCheckVpc.str1.1,"aMS",@progbits,1
.LC73:
	.string	"vpc1"
.LC74:
	.string	"vpc2"
.LC75:
	.string	"FtlCheckVpc2 %x = %x  %x\n"
.LC76:
	.string	"free blk vpc error %x = %x  %x\n"
	.section	.rodata.FtlDumpBlockInfo.str1.1,"aMS",@progbits,1
.LC45:
	.string	"...%s enter...\n"
.LC46:
	.string	"superBlkID = %x vpc=%x\n"
.LC47:
	.string	"flashmode = %x pagenum = %x %x\n"
.LC48:
	.string	"id = %x,%x addr= %x,spare= %x %x %x %x data=%x %x\n"
	.section	.rodata.FtlDumpSysBlock.str1.1,"aMS",@progbits,1
.LC77:
	.string	"id = %x,%x addr= %x,spare= %x %x %x %x data = %x\n"
.LC78:
	.string	":"
	.section	.rodata.FtlFreeSysBlkQueueOut.str1.1,"aMS",@progbits,1
.LC3:
	.string	"FtlFreeSysBlkQueueOut free count = %d\n"
.LC4:
	.string	"FtlFreeSysBlkQueueOut = %x, free count = %d, error\n"
	.section	.rodata.FtlGcFreeTempBlock.str1.1,"aMS",@progbits,1
.LC64:
	.string	"GC des block %x done\n"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",@progbits,1
.LC52:
	.string	"FtlGcScanTempBlkError ID %x %x!!!!!!!\n"
	.section	.rodata.FtlInit.str1.1,"aMS",@progbits,1
.LC66:
	.string	"FTL version: 5.0.50 20180905"
.LC67:
	.string	"...%s: no bad block mapping table, format device\n"
.LC68:
	.string	"...%s FtlSysBlkInit error ,format device!\n"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",@progbits,1
.LC43:
	.string	"no ect"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",@progbits,1
.LC40:
	.string	"FtlMapWritePage error = %x\n"
.LC41:
	.string	"FtlMapWritePage error = %x error count = %d\n"
	.section	.rodata.FtlProgPages.str1.1,"aMS",@progbits,1
.LC57:
	.string	"Ftlwrite decrement_vpc_count %x = %d\n"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",@progbits,1
.LC61:
	.string	"RSB refresh addr %x\n"
.LC62:
	.string	"spuer block %x vpn is 0\n "
.LC63:
	.string	"g_recovery_ppa %x ver %x\n "
	.section	.rodata.FtlScanAllBlock.str1.1,"aMS",@progbits,1
.LC49:
	.string	"blk = %x vpc=%x mode = %x\n"
.LC50:
	.string	"mlc id = %x,%x addr= %x,spare= %x %x %x %x data=%x %x\n"
.LC51:
	.string	"slc id = %x,%x addr= %x,spare= %x %x %x %x data=%x %x\n"
	.section	.rodata.FtlVendorPartRead.str1.1,"aMS",@progbits,1
.LC42:
	.string	"FtlVendorPartRead refresh = %x phyAddr = %x\n"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",@progbits,1
.LC38:
	.string	"FtlVpcTblFlush error = %x error count = %d\n"
	.section	.rodata.FtlWrite.str1.1,"aMS",@progbits,1
.LC72:
	.string	"FtlWrite: lpa error:%x %x\n"
	.section	.rodata.Ftl_load_ext_data.str1.1,"aMS",@progbits,1
.LC44:
	.string	"slc mode"
	.section	.rodata.Ftlscanalldata.str1.1,"aMS",@progbits,1
.LC58:
	.string	"Ftlscanalldata = %x\n"
.LC59:
	.string	"scan lpa = %x ppa= %x\n"
.LC60:
	.string	"lba = %x,addr= %x,spare= %x %x %x %x data=%x %x\n"
	.section	.rodata.HynixGetReadRetryDefault.str1.1,"aMS",@progbits,1
.LC21:
	.string	"otp error! %d"
.LC22:
	.string	"rr"
	.section	.rodata.INSERT_DATA_LIST.str1.1,"aMS",@progbits,1
.LC5:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
.LC6:
	.string	"!!!!! FTL sys Error !!!!!"
.LC7:
	.string	"%s\n"
	.section	.rodata.MicronReadRetrial.str1.1,"aMS",@progbits,1
.LC13:
	.string	"micron RR %d row=%x,count %d,status=%d\n"
	.section	.rodata.__func__.10011,"a",@progbits
	.align	3
	.set	.LANCHOR225,. + 0
	.type	__func__.10011, %object
	.size	__func__.10011, 16
__func__.10011:
	.string	"FtlScanAllBlock"
	.section	.rodata.__func__.10116,"a",@progbits
	.align	3
	.set	.LANCHOR233,. + 0
	.type	__func__.10116, %object
	.size	__func__.10116, 16
__func__.10116:
	.string	"FtlReUsePrevPpa"
	.section	.rodata.__func__.10149,"a",@progbits
	.align	3
	.set	.LANCHOR234,. + 0
	.type	__func__.10149, %object
	.size	__func__.10149, 22
__func__.10149:
	.string	"FtlRecoverySuperblock"
	.section	.rodata.__func__.10203,"a",@progbits
	.align	3
	.set	.LANCHOR102,. + 0
	.type	__func__.10203, %object
	.size	__func__.10203, 16
__func__.10203:
	.string	"make_superblock"
	.section	.rodata.__func__.10223,"a",@progbits
	.align	3
	.set	.LANCHOR140,. + 0
	.type	__func__.10223, %object
	.size	__func__.10223, 18
__func__.10223:
	.string	"SupperBlkListInit"
	.section	.rodata.__func__.10300,"a",@progbits
	.align	3
	.set	.LANCHOR203,. + 0
	.type	__func__.10300, %object
	.size	__func__.10300, 25
__func__.10300:
	.string	"allocate_data_superblock"
	.section	.rodata.__func__.10314,"a",@progbits
	.align	3
	.set	.LANCHOR219,. + 0
	.type	__func__.10314, %object
	.size	__func__.10314, 29
__func__.10314:
	.string	"allocate_new_data_superblock"
	.section	.rodata.__func__.10320,"a",@progbits
	.align	3
	.set	.LANCHOR208,. + 0
	.type	__func__.10320, %object
	.size	__func__.10320, 19
__func__.10320:
	.string	"get_new_active_ppa"
	.section	.rodata.__func__.10331,"a",@progbits
	.align	3
	.set	.LANCHOR206,. + 0
	.type	__func__.10331, %object
	.size	__func__.10331, 16
__func__.10331:
	.string	"update_vpc_list"
	.section	.rodata.__func__.10336,"a",@progbits
	.align	3
	.set	.LANCHOR207,. + 0
	.type	__func__.10336, %object
	.size	__func__.10336, 20
__func__.10336:
	.string	"decrement_vpc_count"
	.section	.rodata.__func__.10404,"a",@progbits
	.align	3
	.set	.LANCHOR239,. + 0
	.type	__func__.10404, %object
	.size	__func__.10404, 19
__func__.10404:
	.string	"FtlGcFreeTempBlock"
	.section	.rodata.__func__.10498,"a",@progbits
	.align	3
	.set	.LANCHOR243,. + 0
	.type	__func__.10498, %object
	.size	__func__.10498, 23
__func__.10498:
	.string	"rk_ftl_garbage_collect"
	.section	.rodata.__func__.9325,"a",@progbits
	.align	3
	.set	.LANCHOR245,. + 0
	.type	__func__.9325, %object
	.size	__func__.9325, 8
__func__.9325:
	.string	"FtlInit"
	.section	.rodata.__func__.9385,"a",@progbits
	.align	3
	.set	.LANCHOR229,. + 0
	.type	__func__.9385, %object
	.size	__func__.9385, 13
__func__.9385:
	.string	"FtlProgPages"
	.section	.rodata.__func__.9411,"a",@progbits
	.align	3
	.set	.LANCHOR247,. + 0
	.type	__func__.9411, %object
	.size	__func__.9411, 9
__func__.9411:
	.string	"FtlWrite"
	.section	.rodata.__func__.9494,"a",@progbits
	.align	3
	.set	.LANCHOR124,. + 0
	.type	__func__.9494, %object
	.size	__func__.9494, 14
__func__.9494:
	.string	"FtlBbt2Bitmap"
	.section	.rodata.__func__.9540,"a",@progbits
	.align	3
	.set	.LANCHOR211,. + 0
	.type	__func__.9540, %object
	.size	__func__.9540, 11
__func__.9540:
	.string	"FtlLoadBbt"
	.section	.rodata.__func__.9633,"a",@progbits
	.align	3
	.set	.LANCHOR90,. + 0
	.type	__func__.9633, %object
	.size	__func__.9633, 17
__func__.9633:
	.string	"INSERT_FREE_LIST"
	.section	.rodata.__func__.9637,"a",@progbits
	.align	3
	.set	.LANCHOR87,. + 0
	.type	__func__.9637, %object
	.size	__func__.9637, 17
__func__.9637:
	.string	"INSERT_DATA_LIST"
	.section	.rodata.__func__.9674,"a",@progbits
	.align	3
	.set	.LANCHOR91,. + 0
	.type	__func__.9674, %object
	.size	__func__.9674, 17
__func__.9674:
	.string	"List_remove_node"
	.section	.rodata.__func__.9704,"a",@progbits
	.align	3
	.set	.LANCHOR95,. + 0
	.type	__func__.9704, %object
	.size	__func__.9704, 22
__func__.9704:
	.string	"List_update_data_list"
	.section	.rodata.__func__.9711,"a",@progbits
	.align	3
	.set	.LANCHOR228,. + 0
	.type	__func__.9711, %object
	.size	__func__.9711, 20
__func__.9711:
	.string	"ftl_load_l2p_region"
	.section	.rodata.__func__.9742,"a",@progbits
	.align	3
	.set	.LANCHOR96,. + 0
	.type	__func__.9742, %object
	.size	__func__.9742, 26
__func__.9742:
	.string	"ftl_map_blk_alloc_new_blk"
	.section	.rodata.__func__.9752,"a",@progbits
	.align	3
	.set	.LANCHOR212,. + 0
	.type	__func__.9752, %object
	.size	__func__.9752, 15
__func__.9752:
	.string	"ftl_map_blk_gc"
	.section	.rodata.__func__.9765,"a",@progbits
	.align	3
	.set	.LANCHOR213,. + 0
	.type	__func__.9765, %object
	.size	__func__.9765, 31
__func__.9765:
	.string	"Ftl_write_map_blk_to_last_page"
	.section	.rodata.__func__.9778,"a",@progbits
	.align	3
	.set	.LANCHOR214,. + 0
	.type	__func__.9778, %object
	.size	__func__.9778, 16
__func__.9778:
	.string	"FtlMapWritePage"
	.section	.rodata.__func__.9798,"a",@progbits
	.align	3
	.set	.LANCHOR99,. + 0
	.type	__func__.9798, %object
	.size	__func__.9798, 22
__func__.9798:
	.string	"select_l2p_ram_region"
	.section	.rodata.__func__.9814,"a",@progbits
	.align	3
	.set	.LANCHOR227,. + 0
	.type	__func__.9814, %object
	.size	__func__.9814, 9
__func__.9814:
	.string	"log2phys"
	.section	.rodata.__func__.9876,"a",@progbits
	.align	3
	.set	.LANCHOR210,. + 0
	.type	__func__.9876, %object
	.size	__func__.9876, 15
__func__.9876:
	.string	"FtlVpcTblFlush"
	.section	.rodata.__func__.9895,"a",@progbits
	.align	3
	.set	.LANCHOR220,. + 0
	.type	__func__.9895, %object
	.size	__func__.9895, 14
__func__.9895:
	.string	"FtlScanSysBlk"
	.section	.rodata.__func__.9949,"a",@progbits
	.align	3
	.set	.LANCHOR221,. + 0
	.type	__func__.9949, %object
	.size	__func__.9949, 15
__func__.9949:
	.string	"FtlLoadSysInfo"
	.section	.rodata.__func__.9960,"a",@progbits
	.align	3
	.set	.LANCHOR248,. + 0
	.type	__func__.9960, %object
	.size	__func__.9960, 12
__func__.9960:
	.string	"FtlCheckVpc"
	.section	.rodata.__func__.9992,"a",@progbits
	.align	3
	.set	.LANCHOR224,. + 0
	.type	__func__.9992, %object
	.size	__func__.9992, 17
__func__.9992:
	.string	"FtlDumpBlockInfo"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",@progbits,1
.LC36:
	.string	"decrement_vpc_count %x = %d\n"
.LC37:
	.string	"decrement_vpc_count %x = %d in free list\n"
	.section	.rodata.dump_map_info.str1.1,"aMS",@progbits,1
.LC79:
	.string	"phyBlk = %x,addr= %x,spare= %x %x %x %x data=%x %x\n"
.LC80:
	.string	"Mblk:"
.LC81:
	.string	"L2P:"
.LC82:
	.string	"L2PC:"
	.section	.rodata.ftl_fix_nand_power_lost_error.str1.1,"aMS",@progbits,1
.LC70:
	.string	"fix power lost blk = %x vpc=%x\n"
.LC71:
	.string	"erase power lost blk = %x vpc=%x\n"
	.section	.rodata.ftl_map_blk_alloc_new_blk.str1.1,"aMS",@progbits,1
.LC8:
	.string	"FtlFreeSysBlkQueueOut = %x, free count = %d\n"
	.section	.rodata.ftl_map_blk_gc.str1.1,"aMS",@progbits,1
.LC39:
	.string	"page map lost: %x %x\n"
	.section	.rodata.idb_write_data.str1.1,"aMS",@progbits,1
.LC15:
	.string	"1 write_idblock fix data %x %x %x\n"
.LC16:
	.string	"write_idblock fail! %x %x %x %x\n"
.LC17:
	.string	"write_idblock fail! %x\n"
	.section	.rodata.log2phys.str1.1,"aMS",@progbits,1
.LC54:
	.string	"region_id = %x phyAddr = %x\n"
.LC55:
	.string	"map_ppn:"
.LC56:
	.string	"load_l2p_region refresh = %x phyAddr = %x\n"
	.section	.rodata.rk_ftl_garbage_collect.str1.1,"aMS",@progbits,1
.LC65:
	.string	"g_gc_superblock_free %x %x %x %x %x\n"
	.section	.rodata.rk_ftl_init.str1.1,"aMS",@progbits,1
.LC69:
	.string	"FtlInit %x\n"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",@progbits,1
.LC18:
	.string	"%s 0x%x:"
.LC19:
	.string	"%x "
.LC20:
	.string	""
	.hidden	free
