/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2018-02-08
 */
	.arch armv8-a
	.file	"rk_ftl_arm_v8.S"
	.section	.text.ftl_set_blk_mode.part.9,"ax",@progbits
	.align	2
	.type	ftl_set_blk_mode.part.9, %function
ftl_set_blk_mode.part.9:
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
	.size	ftl_set_blk_mode.part.9, .-ftl_set_blk_mode.part.9
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
.L188:
	cmp	x20, x22
	bne	.L193
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L193:
	mov	w1, 0
	mov	w4, w21
	add	x3, x29, 76
	add	x2, x29, 72
	mov	x0, x20
	bl	LogAddr2PhyAddr
	ldrb	w1, [x23]
	ldr	w0, [x29, 76]
	cmp	w1, w0
	bhi	.L189
	mov	w0, -1
	str	w0, [x20]
.L190:
	sub	w21, w21, #1
	add	x20, x20, 56
	and	w21, w21, 255
	b	.L188
.L189:
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
	tbz	x0, 0, .L191
	mov	w0, -1
	str	w0, [x20]
.L191:
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L192
	ldr	w1, [x29, 72]
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf
.L192:
	mov	w0, w19
	bl	NandcFlashDeCs
	b	.L190
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
	cbnz	w1, .L199
	adrp	x25, .LANCHOR23
	mov	x23, x0
	add	x26, x25, :lo12:.LANCHOR23
	mov	w19, 0
.L200:
	cmp	w19, w22
	adrp	x13, .LANCHOR25
	bcc	.L209
	adrp	x20, .LANCHOR8
	adrp	x21, .LANCHOR23
	add	x22, x13, :lo12:.LANCHOR25
	add	x20, x20, :lo12:.LANCHOR8
	add	x21, x21, :lo12:.LANCHOR23
	mov	x19, 0
.L210:
	ldrb	w0, [x22]
	cmp	w0, w19
	bhi	.L212
	mov	w0, 0
	b	.L198
.L199:
	mov	w1, w2
	bl	FlashEraseSLc2KBlocks
.L198:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L209:
	mov	w12, 56
	mov	w1, 0
	sub	w4, w22, w19
	add	x3, x29, 92
	umull	x12, w19, w12
	add	x2, x29, 88
	add	x20, x23, x12
	mov	x0, x20
	bl	LogAddr2PhyAddr
	mov	w21, w0
	ldrb	w1, [x13, #:lo12:.LANCHOR25]
	ldr	w0, [x29, 92]
	cmp	w1, w0
	bhi	.L202
	mov	w0, -1
	str	w0, [x23, x12]
.L203:
	add	w19, w19, 1
	b	.L200
.L202:
	adrp	x1, .LANCHOR27
	add	x2, x25, :lo12:.LANCHOR23
	mov	x3, 24
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
	cmp	w1, 0
	uxtw	x1, w0
	csel	w21, w21, wzr, ne
	madd	x1, x1, x3, x2
	ldr	x1, [x1, 8]
	cbz	x1, .L205
	bl	FlashWaitCmdDone
.L205:
	ldp	w2, w1, [x29, 88]
	mov	x0, 24
	madd	x0, x1, x0, x26
	str	w2, [x0, 4]
	stp	x20, xzr, [x0, 8]
	cbz	w21, .L206
	add	w2, w19, 1
	mov	w3, 56
	umaddl	x2, w2, w3, x23
	str	x2, [x0, 16]
.L206:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w20, [x0, x1]
	mov	x0, 24
	mul	x1, x1, x0
	mov	w0, w20
	strb	w20, [x26, x1]
	bl	NandcFlashCs
	cmp	w24, 1
	bne	.L207
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L207
	mov	w0, w20
	bl	flash_enter_slc_mode
.L208:
	ldr	w1, [x29, 92]
	adrp	x0, .LANCHOR17
	add	x0, x0, :lo12:.LANCHOR17
	add	w19, w19, w21
	ldr	w0, [x0, x1, lsl 2]
	ldr	w1, [x29, 88]
	cmp	w0, 0
	mov	w0, w20
	cset	w2, ne
	bl	FlashWaitReadyEN
	ldr	w1, [x29, 88]
	mov	w2, w21
	mov	w0, w20
	bl	FlashEraseCmd
	mov	w0, w20
	bl	NandcFlashDeCs
	b	.L203
.L207:
	mov	w0, w20
	bl	flash_exit_slc_mode
	b	.L208
.L212:
	mov	w0, w19
	bl	FlashWaitCmdDone
	cmp	w24, 1
	bne	.L211
	ldrb	w0, [x20]
	cbz	w0, .L211
	mov	x0, 24
	mul	x0, x19, x0
	ldrb	w0, [x0, x21]
	bl	flash_exit_slc_mode
.L211:
	add	x19, x19, 1
	b	.L210
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
	bne	.L227
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
.L230:
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
.L227:
	str	w4, [x19, 2052]
	str	w3, [x19, 2052]
	str	w1, [x19, 2052]
	str	w0, [x19, 2056]
	b	.L230
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
	adrp	x19, .LANCHOR28
	bl	FlashSetReadRetryDefault
	ldrb	w0, [x19, #:lo12:.LANCHOR28]
	cbz	w0, .L232
	adrp	x0, .LANCHOR24
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	tbz	x0, 0, .L232
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
	strb	wzr, [x19, #:lo12:.LANCHOR28]
.L232:
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
	bhi	.L242
	ldr	x0, [x1, #:lo12:.LANCHOR19]
	mov	w1, 4193
.L245:
	str	w1, [x0, 4]
	ret
.L242:
	cmp	w0, 99
	ldr	x0, [x1, #:lo12:.LANCHOR19]
	bls	.L244
	mov	w1, 8322
	b	.L245
.L244:
	mov	w1, 4225
	b	.L245
	.size	NandcTimeCfg, .-NandcTimeCfg
	.section	.text.FlashTimingCfg,"ax",@progbits
	.align	2
	.global	FlashTimingCfg
	.type	FlashTimingCfg, %function
FlashTimingCfg:
	adrp	x0, .LANCHOR29+21
	ldrb	w0, [x0, #:lo12:.LANCHOR29+21]
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
	adrp	x1, .LANCHOR30
	str	w0, [x1, #:lo12:.LANCHOR30]
	mov	w1, 4096
	bne	.L248
.L251:
	and	w1, w1, -17
.L249:
	orr	w1, w1, 1
	str	w1, [x2, 12]
	ret
.L248:
	cmp	w0, 24
	bne	.L250
	orr	w1, w1, 16
	b	.L249
.L250:
	orr	w1, w1, 262144
	cmp	w0, 40
	orr	w1, w1, 16
	bne	.L249
	b	.L251
	.size	NandcBchSel, .-NandcBchSel
	.section	.text.FlashBchSel,"ax",@progbits
	.align	2
	.global	FlashBchSel
	.type	FlashBchSel, %function
FlashBchSel:
	adrp	x1, .LANCHOR31
	and	w0, w0, 255
	strb	w0, [x1, #:lo12:.LANCHOR31]
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
.L265:
	ldr	w1, [x0, 8]
	str	w1, [sp, 8]
	ldr	w1, [sp, 8]
	tbz	x1, 20, .L265
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
	and	w23, w1, 255
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	add	x6, x1, x0
	stp	x21, x22, [sp, 32]
	stp	x19, x20, [sp, 16]
	ubfiz	w19, w23, 1, 1
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
	adrp	x0, .LANCHOR32
	orr	w19, w19, 536870912
	orr	w19, w19, 1024
	ldr	w0, [x0, #:lo12:.LANCHOR32]
	bfi	w19, w3, 4, 1
	cmp	w0, 3
	bls	.L270
	ldr	w0, [x21, 16]
	cmp	x5, 0
	str	w0, [x29, 88]
	ccmp	x4, 0, 0, eq
	ldr	w0, [x29, 88]
	and	w0, w0, -5
	str	w0, [x29, 88]
	beq	.L271
	and	w2, w2, 255
	adrp	x20, .LANCHOR33
	cbnz	w23, .L272
.L280:
	add	w2, w2, 1
	ldr	x0, [x20, #:lo12:.LANCHOR33]
	asr	w2, w2, 1
	add	x20, x20, :lo12:.LANCHOR33
	cmp	x4, 0
	mov	x24, x4
	bfi	w19, w2, 22, 6
	csel	x0, x4, x0, ne
	ldr	x1, [x20, 8]
	ubfx	x25, x19, 22, 5
	stp	x0, x1, [x20, 16]
	stp	w0, w1, [x20, 32]
	add	w1, w0, w25, lsl 10
	uxtw	x0, w0
	bl	flush_dcache_range
	ldr	x0, [x20, 24]
	add	w1, w0, w25, lsl 7
	uxtw	x0, w0
	bl	flush_dcache_range
	mov	w0, 1
	str	w0, [x20, 40]
	ldr	w0, [x20, 32]
	mov	w1, 16
	str	w0, [x21, 20]
	tst	x24, 3
	ldr	w0, [x20, 36]
	str	w0, [x21, 24]
	str	wzr, [x29, 88]
	ldr	w0, [x29, 88]
	bfi	w0, w1, 9, 5
	str	w0, [x29, 88]
	ldr	w0, [x29, 88]
	orr	w0, w0, 448
	str	w0, [x29, 88]
	bne	.L281
	ldr	w0, [x29, 88]
	mov	w1, 2
	bfi	w0, w1, 3, 3
	str	w0, [x29, 88]
.L281:
	ldr	w0, [x29, 88]
	cmp	w23, 0
	cset	w1, eq
	orr	w0, w0, 4
	str	w0, [x29, 88]
	ldr	w0, [x29, 88]
	bfi	w0, w1, 1, 1
	str	w0, [x29, 88]
	ldr	w0, [x29, 88]
	orr	w0, w0, 1
	str	w0, [x29, 88]
.L271:
	ldr	w0, [x29, 88]
	str	w0, [x21, 16]
.L270:
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
.L272:
	adrp	x0, .LANCHOR30
	mov	w6, 64
	lsr	w11, w2, 1
	mov	x1, x5
	ldr	w0, [x0, #:lo12:.LANCHOR30]
	mov	w7, 0
	mov	w3, 0
	mov	w12, -1
	cmp	w0, 25
	mov	w0, 128
	csel	w6, w6, w0, cc
	add	x0, x20, :lo12:.LANCHOR33
	ldr	x10, [x0, 8]
.L276:
	cmp	w3, w11
	bcs	.L280
	lsr	w0, w7, 2
	lsl	w0, w0, 2
	cbz	x5, .L277
	ldrh	w13, [x1]
	add	x1, x1, 4
	ldrh	w8, [x1, -2]
	orr	x8, x13, x8, lsl 16
	str	w8, [x10, x0]
.L278:
	add	w3, w3, 1
	add	w7, w7, w6
	b	.L276
.L277:
	str	w12, [x10, x0]
	b	.L278
	.size	NandcXferStart, .-NandcXferStart
	.section	.text.NandcXferComp,"ax",@progbits
	.align	2
	.global	NandcXferComp
	.type	NandcXferComp, %function
NandcXferComp:
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	ldr	x3, [x1, x0]
	adrp	x0, .LANCHOR32
	str	x19, [sp, 16]
	ldr	w2, [x0, #:lo12:.LANCHOR32]
	cmp	w2, 3
	bls	.L311
	ldr	w0, [x3, 16]
	tbz	x0, 2, .L311
	ldr	w0, [x3, 16]
	tbz	x0, 1, .L299
	ldr	w0, [x3, 8]
	str	w0, [x29, 32]
.L292:
	ldr	w1, [x3, 28]
	ldr	w0, [x29, 32]
	ubfx	x1, x1, 16, 5
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L296
	cmp	w2, 5
	bls	.L292
	ldr	w0, [x3]
	str	w0, [x29, 40]
	ldr	w0, [x29, 40]
	tbz	x0, 13, .L292
	ldr	w0, [x29, 40]
	tbz	x0, 17, .L292
.L296:
	adrp	x19, .LANCHOR33
	add	x19, x19, :lo12:.LANCHOR33
	ldr	w0, [x19, 40]
	cbz	w0, .L297
	ldr	w1, [x29, 32]
	ldr	w0, [x19, 32]
	ubfx	x1, x1, 22, 5
	add	w1, w0, w1, lsl 10
	uxtw	x0, w0
	bl	invalidate_dcache_range
	ldr	w1, [x29, 32]
	ldr	w0, [x19, 36]
	ubfx	x1, x1, 22, 5
	add	w1, w0, w1, lsl 7
	uxtw	x0, w0
	bl	invalidate_dcache_range
.L297:
	adrp	x0, .LANCHOR33+40
	str	wzr, [x0, #:lo12:.LANCHOR33+40]
.L288:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L299:
	ldr	w0, [x3, 8]
	str	w0, [x29, 32]
	ldr	w0, [x29, 32]
	tbz	x0, 20, .L299
	adrp	x0, .LANCHOR34
	mov	x4, x0
	ldr	w1, [x0, #:lo12:.LANCHOR34]
	cbz	w1, .L300
	mov	x0, x3
	bl	NandcSendDumpDataStart
.L300:
	ldr	w0, [x4, #:lo12:.LANCHOR34]
	cbz	w0, .L297
	mov	x0, x3
	bl	NandcSendDumpDataDone
	b	.L297
.L311:
	ldr	w0, [x3, 8]
	str	w0, [x29, 32]
	ldr	w0, [x29, 32]
	tbz	x0, 20, .L311
	b	.L288
	.size	NandcXferComp, .-NandcXferComp
	.section	.text.Ftl_log2,"ax",@progbits
	.align	2
	.global	Ftl_log2
	.type	Ftl_log2, %function
Ftl_log2:
	mov	w2, 1
	mov	w1, 0
.L320:
	cmp	w2, w0
	bls	.L321
	sub	w0, w1, #1
	ret
.L321:
	add	w1, w1, 1
	lsl	w2, w2, 1
	and	w1, w1, 65535
	b	.L320
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
	adrp	x2, .LANCHOR37
	csel	w0, w0, w1, cs
	adrp	x1, .LANCHOR35
	and	w0, w0, 65535
	str	w0, [x1, #:lo12:.LANCHOR35]
	adrp	x1, .LANCHOR36
	ldrh	w1, [x1, #:lo12:.LANCHOR36]
	mul	w1, w1, w0
	str	w1, [x2, #:lo12:.LANCHOR37]
	adrp	x2, .LANCHOR39
	ldrh	w2, [x2, #:lo12:.LANCHOR39]
	sub	w0, w2, w0
	adrp	x2, .LANCHOR38
	strh	w0, [x2, #:lo12:.LANCHOR38]
	adrp	x0, .LANCHOR41
	ldr	w0, [x0, #:lo12:.LANCHOR41]
	sub	w1, w0, w1
	adrp	x0, .LANCHOR40
	str	w1, [x0, #:lo12:.LANCHOR40]
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
	adrp	x1, .LANCHOR44
	adrp	x4, .LANCHOR43
	add	x29, sp, 0
	ldrh	w11, [x0, 8]
	adrp	x0, .LANCHOR42
	adrp	x6, .LANCHOR39
	ldrh	w2, [x5, 10]
	strh	w11, [x0, #:lo12:.LANCHOR42]
	mov	x3, 0
	ldrh	w0, [x5, 12]
	ldrh	w8, [x5, 14]
	strh	w0, [x1, #:lo12:.LANCHOR44]
	adrp	x1, .LANCHOR45
	add	x7, x1, :lo12:.LANCHOR45
	strh	w2, [x4, #:lo12:.LANCHOR43]
	strh	w8, [x6, #:lo12:.LANCHOR39]
	str	x19, [sp, 16]
.L325:
	strb	w3, [x3, x7]
	add	x3, x3, 1
	cmp	x3, 32
	bne	.L325
	ldrh	w7, [x5, 20]
	ldrb	w3, [x5, 15]
	cmp	w7, w3
	bcs	.L326
	and	w13, w0, 255
	mul	w15, w0, w2
	ubfiz	w14, w13, 1, 7
	add	x1, x1, :lo12:.LANCHOR45
	mov	w7, 0
.L327:
	cmp	w7, w0
	bcs	.L329
	and	w3, w7, 255
	mov	w10, w7
	mov	w12, 0
	b	.L330
.L328:
	add	w16, w15, w10
	strb	w3, [x1, w10, uxtw]
	add	w17, w13, w3
	add	w3, w14, w3
	add	w12, w12, 1
	and	w3, w3, 255
	add	w10, w10, w0
	strb	w17, [x1, x16]
.L330:
	cmp	w12, w2
	bcc	.L328
	add	w7, w7, 1
	b	.L327
.L329:
	ubfiz	w2, w2, 1, 15
	lsr	w8, w8, 1
	strh	w2, [x4, #:lo12:.LANCHOR43]
	strh	w8, [x6, #:lo12:.LANCHOR39]
.L326:
	adrp	x1, .LANCHOR46
	adrp	x13, .LANCHOR47
	mov	w2, 5
	cmp	w11, 1
	strh	w2, [x1, #:lo12:.LANCHOR46]
	strh	wzr, [x13, #:lo12:.LANCHOR47]
	bne	.L331
	strh	w11, [x1, #:lo12:.LANCHOR46]
.L331:
	adrp	x8, .LANCHOR48
	mov	w1, 4352
	strh	w1, [x8, #:lo12:.LANCHOR48]
	adrp	x1, .LANCHOR1
	ldrb	w11, [x1, #:lo12:.LANCHOR1]
	cbz	w11, .L332
	mov	w1, 384
	strh	w1, [x8, #:lo12:.LANCHOR48]
.L332:
	ldrh	w4, [x4, #:lo12:.LANCHOR43]
	adrp	x1, .LANCHOR36
	ldrh	w3, [x6, #:lo12:.LANCHOR39]
	mul	w4, w0, w4
	mul	w0, w0, w3
	and	w4, w4, 65535
	strh	w4, [x1, #:lo12:.LANCHOR36]
	adrp	x1, .LANCHOR49
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR49]
	bl	Ftl_log2
	ldrh	w19, [x5, 16]
	adrp	x1, .LANCHOR50
	ldrh	w10, [x5, 20]
	adrp	x7, .LANCHOR51
	strh	w0, [x1, #:lo12:.LANCHOR50]
	adrp	x0, .LANCHOR52
	ldrh	w14, [x5, 18]
	adrp	x15, .LANCHOR54
	mul	w1, w4, w19
	strh	w14, [x0, #:lo12:.LANCHOR52]
	adrp	x0, .LANCHOR53
	strh	w19, [x7, #:lo12:.LANCHOR51]
	strh	w10, [x15, #:lo12:.LANCHOR54]
	strh	w1, [x0, #:lo12:.LANCHOR53]
	mov	w0, w10
	bl	Ftl_log2
	and	w12, w0, 65535
	adrp	x6, .LANCHOR55
	ubfiz	w2, w10, 9, 7
	ldrh	w1, [x5, 26]
	cmp	w3, 1024
	strh	w0, [x6, #:lo12:.LANCHOR55]
	adrp	x0, .LANCHOR56
	strh	w2, [x0, #:lo12:.LANCHOR56]
	adrp	x0, .LANCHOR57
	ubfx	w2, w2, 8, 8
	strh	w2, [x0, #:lo12:.LANCHOR57]
	adrp	x0, .LANCHOR58
	strh	w1, [x0, #:lo12:.LANCHOR58]
	adrp	x0, .LANCHOR41
	mul	w1, w4, w3
	str	w1, [x0, #:lo12:.LANCHOR41]
	bls	.L333
	and	w0, w3, 255
	strh	w0, [x13, #:lo12:.LANCHOR47]
.L333:
	ldrh	w0, [x13, #:lo12:.LANCHOR47]
	adrp	x1, .LANCHOR59
	sub	w0, w3, w0
	mul	w0, w0, w4
	mul	w0, w0, w10
	mul	w0, w0, w19
	asr	w0, w0, 11
	str	w0, [x1, #:lo12:.LANCHOR59]
	ldrh	w0, [x8, #:lo12:.LANCHOR48]
	mul	w1, w14, w10
	adrp	x10, .LANCHOR60
	lsl	w0, w0, 3
	sdiv	w0, w0, w1
	and	w0, w0, 65535
	cmp	w0, 4
	bls	.L334
.L352:
	strh	w0, [x10, #:lo12:.LANCHOR60]
	cbz	w11, .L336
	mov	w0, 640
	strh	w0, [x8, #:lo12:.LANCHOR48]
.L336:
	ldrh	w0, [x8, #:lo12:.LANCHOR48]
	adrp	x1, .LANCHOR61
	lsl	w3, w3, 6
	cmp	w4, 1
	adrp	x8, .LANCHOR35
	asr	w0, w0, w12
	add	w0, w0, 2
	strh	w0, [x1, #:lo12:.LANCHOR61]
	add	w0, w12, 9
	adrp	x1, .LANCHOR63
	asr	w3, w3, w0
	adrp	x0, .LANCHOR62
	strh	w3, [x0, #:lo12:.LANCHOR62]
	and	w3, w3, 65535
	mul	w0, w4, w3
	add	w3, w3, 8
	str	w0, [x1, #:lo12:.LANCHOR63]
	ldrh	w0, [x10, #:lo12:.LANCHOR60]
	udiv	w0, w0, w4
	mov	x4, x1
	add	w3, w0, w3
	beq	.L337
.L353:
	str	w3, [x8, #:lo12:.LANCHOR35]
	ldrh	w0, [x8, #:lo12:.LANCHOR35]
	bl	FtlSysBlkNumInit
	ldr	w1, [x8, #:lo12:.LANCHOR35]
	adrp	x0, .LANCHOR64
	mov	w2, 24
	str	w1, [x0, #:lo12:.LANCHOR64]
	adrp	x0, .LANCHOR40
	ldrh	w1, [x7, #:lo12:.LANCHOR51]
	ldr	w0, [x0, #:lo12:.LANCHOR40]
	lsl	w0, w0, 2
	mul	w0, w0, w1
	ldrh	w1, [x6, #:lo12:.LANCHOR55]
	add	w1, w1, 9
	lsr	w0, w0, w1
	adrp	x1, .LANCHOR65
	add	w0, w0, 2
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR65]
	adrp	x1, .LANCHOR66
	strh	w2, [x1, #:lo12:.LANCHOR66]
	adrp	x1, .LANCHOR67
	ldrh	w2, [x10, #:lo12:.LANCHOR60]
	str	wzr, [x1, #:lo12:.LANCHOR67]
	add	w1, w2, 3
	strh	w1, [x10, #:lo12:.LANCHOR60]
	ldr	w1, [x4, #:lo12:.LANCHOR63]
	add	w3, w1, 3
	str	w3, [x4, #:lo12:.LANCHOR63]
	adrp	x3, .LANCHOR8
	ldrb	w3, [x3, #:lo12:.LANCHOR8]
	cbz	w3, .L339
	add	w2, w2, 4
	add	w1, w1, 5
	strh	w2, [x10, #:lo12:.LANCHOR60]
	str	w1, [x4, #:lo12:.LANCHOR63]
.L339:
	adrp	x1, .LANCHOR38
	adrp	x3, .LANCHOR68
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	strh	wzr, [x3, #:lo12:.LANCHOR68]
	lsl	w2, w1, 1
	lsr	w1, w1, 3
	add	w2, w2, 48
	add	w1, w1, 4
	add	w0, w2, w0, lsl 2
	add	w0, w0, w1
	ldrh	w1, [x15, #:lo12:.LANCHOR54]
	cmp	w0, w1, lsl 9
	bcs	.L340
	mov	w0, 1
	strh	w0, [x3, #:lo12:.LANCHOR68]
.L340:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L334:
	mov	w0, 4
	b	.L352
.L337:
	add	w3, w3, 4
	b	.L353
	.size	FtlConstantsInit, .-FtlConstantsInit
	.section	.text.IsBlkInVendorPart,"ax",@progbits
	.align	2
	.global	IsBlkInVendorPart
	.type	IsBlkInVendorPart, %function
IsBlkInVendorPart:
	adrp	x1, .LANCHOR69
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR69]
	cbz	w1, .L358
	adrp	x1, .LANCHOR60
	ldrh	w2, [x1, #:lo12:.LANCHOR60]
	adrp	x1, .LANCHOR70
	ldr	x3, [x1, #:lo12:.LANCHOR70]
	mov	x1, 0
.L356:
	cmp	w2, w1, uxth
	bhi	.L357
.L358:
	mov	w0, 0
	ret
.L357:
	add	x1, x1, 1
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L356
	mov	w0, 1
	ret
	.size	IsBlkInVendorPart, .-IsBlkInVendorPart
	.section	.text.FtlGetCap,"ax",@progbits
	.align	2
	.global	FtlGetCap
	.type	FtlGetCap, %function
FtlGetCap:
	adrp	x0, .LANCHOR67
	ldr	w0, [x0, #:lo12:.LANCHOR67]
	ret
	.size	FtlGetCap, .-FtlGetCap
	.section	.text.FtlGetCapacity,"ax",@progbits
	.align	2
	.global	FtlGetCapacity
	.type	FtlGetCapacity, %function
FtlGetCapacity:
	adrp	x0, .LANCHOR67
	ldr	w0, [x0, #:lo12:.LANCHOR67]
	ret
	.size	FtlGetCapacity, .-FtlGetCapacity
	.section	.text.ftl_get_density,"ax",@progbits
	.align	2
	.global	ftl_get_density
	.type	ftl_get_density, %function
ftl_get_density:
	adrp	x0, .LANCHOR67
	ldr	w0, [x0, #:lo12:.LANCHOR67]
	ret
	.size	ftl_get_density, .-ftl_get_density
	.section	.text.FtlGetLpn,"ax",@progbits
	.align	2
	.global	FtlGetLpn
	.type	FtlGetLpn, %function
FtlGetLpn:
	adrp	x0, .LANCHOR71
	ldr	w0, [x0, #:lo12:.LANCHOR71]
	ret
	.size	FtlGetLpn, .-FtlGetLpn
	.section	.text.FtlGetCurEraseBlock,"ax",@progbits
	.align	2
	.global	FtlGetCurEraseBlock
	.type	FtlGetCurEraseBlock, %function
FtlGetCurEraseBlock:
	adrp	x0, .LANCHOR36
	ldrh	w1, [x0, #:lo12:.LANCHOR36]
	adrp	x0, .LANCHOR72
	ldr	w0, [x0, #:lo12:.LANCHOR72]
	mul	w0, w1, w0
	ret
	.size	FtlGetCurEraseBlock, .-FtlGetCurEraseBlock
	.section	.text.FtlGetAllBlockNum,"ax",@progbits
	.align	2
	.global	FtlGetAllBlockNum
	.type	FtlGetAllBlockNum, %function
FtlGetAllBlockNum:
	adrp	x0, .LANCHOR39
	ldrh	w1, [x0, #:lo12:.LANCHOR39]
	adrp	x0, .LANCHOR36
	ldrh	w0, [x0, #:lo12:.LANCHOR36]
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
	adrp	x0, .LANCHOR49
	mov	w4, 1
	add	x29, sp, 0
	ldrh	w0, [x0, #:lo12:.LANCHOR49]
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR73
	add	x19, x19, :lo12:.LANCHOR73
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
	adrp	x1, .LANCHOR49
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR49]
	udiv	w2, w0, w1
	msub	w0, w2, w1, w0
	adrp	x1, .LANCHOR73
	add	x1, x1, :lo12:.LANCHOR73
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
	adrp	x2, .LANCHOR44
	and	w0, w0, 65535
	adrp	x4, .LANCHOR49
	and	w1, w1, 65535
	ldrh	w2, [x2, #:lo12:.LANCHOR44]
	ldrh	w4, [x4, #:lo12:.LANCHOR49]
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
	adrp	x0, .LANCHOR44
	ldrh	w1, [x0, #:lo12:.LANCHOR44]
	adrp	x0, .LANCHOR49
	ldrh	w2, [x0, #:lo12:.LANCHOR49]
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
	adrp	x0, .LANCHOR49
	ldrh	w1, [x0, #:lo12:.LANCHOR49]
	udiv	w0, w2, w1
	msub	w0, w0, w1, w2
	adrp	x1, .LANCHOR44
	ldrh	w1, [x1, #:lo12:.LANCHOR44]
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
	bls	.L374
	sub	w1, w0, w1
	cmp	w1, w2
	cset	w0, ls
	ret
.L374:
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
	adrp	x0, .LANCHOR74+6
	ldrh	w0, [x0, #:lo12:.LANCHOR74+6]
	cmp	w0, 0
	cset	w0, eq
	ret
	.size	FtlFreeSysBlkQueueEmpty, .-FtlFreeSysBlkQueueEmpty
	.section	.text.FtlFreeSysBlkQueueFull,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueFull
	.type	FtlFreeSysBlkQueueFull, %function
FtlFreeSysBlkQueueFull:
	adrp	x0, .LANCHOR74+6
	ldrh	w0, [x0, #:lo12:.LANCHOR74+6]
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
	str	x21, [sp, 32]
	and	w21, w0, 65535
	adrp	x0, .LANCHOR74
	add	x2, x0, :lo12:.LANCHOR74
	stp	x19, x20, [sp, 16]
	ldrh	w2, [x2, 6]
	cmp	w2, 1024
	beq	.L378
	and	w1, w1, 65535
	mov	x19, x0
	cbz	w1, .L380
	adrp	x0, .LANCHOR75
	ldr	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L380
	mov	w0, w21
	bl	P2V_block_in_plane
	and	w20, w0, 65535
	adrp	x0, .LANCHOR76
	lsl	w1, w21, 10
	mov	w2, 1
	ldr	x0, [x0, #:lo12:.LANCHOR76]
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
	adrp	x1, .LANCHOR77
	ubfiz	x0, x20, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR77]
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	adrp	x1, .LANCHOR78
	ldr	w0, [x1, #:lo12:.LANCHOR78]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR78]
.L380:
	add	x0, x19, :lo12:.LANCHOR74
	ldrh	w1, [x0, 6]
	add	w1, w1, 1
	strh	w1, [x0, 6]
	ldrh	w1, [x0, 4]
	add	x2, x0, x1, sxtw 1
	add	w1, w1, 1
	and	w1, w1, 1023
	strh	w1, [x0, 4]
	strh	w21, [x2, 8]
.L378:
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
	stp	x29, x30, [sp, -16]!
	adrp	x2, .LANCHOR74
	adrp	x1, .LANCHOR79
	add	x0, x2, :lo12:.LANCHOR74
	add	x29, sp, 0
	ldr	x3, [x1, #:lo12:.LANCHOR79]
	adrp	x1, .LANCHOR77
	ldrh	w8, [x0, 2]
	mov	x4, x2
	ldrh	w7, [x0, 6]
	mov	x6, x0
	ldr	x10, [x1, #:lo12:.LANCHOR77]
	and	x11, x8, 65535
	mov	x5, 0
.L389:
	cmp	w7, w5, uxth
	bhi	.L390
	sub	w10, w7, #1
	add	x2, x4, :lo12:.LANCHOR74
	mov	w0, 0
.L391:
	cmp	w0, w10
	blt	.L396
	ldp	x29, x30, [sp], 16
	ret
.L390:
	add	x0, x11, x5
	add	x0, x6, x0, lsl 1
	ldrh	w0, [x0, 8]
	bl	P2V_block_in_plane
	ubfiz	x0, x0, 1, 16
	ldrh	w0, [x10, x0]
	str	w0, [x3, x5, lsl 2]
	add	x5, x5, 1
	b	.L389
.L396:
	add	w5, w0, 1
	mov	w1, w0
	and	w5, w5, 65535
	mov	w4, w5
.L392:
	cmp	w4, w7
	bcc	.L394
	cmp	w0, w1
	beq	.L395
	ubfiz	x4, x0, 2, 16
	ubfiz	x6, x1, 2, 32
	add	w0, w8, w0
	add	w1, w1, w8
	add	x0, x2, x0, sxtw 1
	add	x1, x2, x1, sxtw 1
	ldr	w12, [x3, x4]
	ldr	w11, [x3, x6]
	str	w12, [x3, x6]
	str	w11, [x3, x4]
	ldrh	w6, [x0, 8]
	ldrh	w4, [x1, 8]
	strh	w6, [x1, 8]
	strh	w4, [x0, 8]
.L395:
	mov	w0, w5
	b	.L391
.L394:
	ubfiz	x6, x4, 2, 16
	ldr	w11, [x3, w1, uxtw 2]
	ldr	w6, [x3, x6]
	cmp	w11, w6
	csel	w1, w1, w4, ls
	add	w4, w4, 1
	and	w4, w4, 65535
	b	.L392
	.size	FtlFreeSysBLkSort, .-FtlFreeSysBLkSort
	.section	.text.remove_from_free_sys_Queue,"ax",@progbits
	.align	2
	.global	remove_from_free_sys_Queue
	.type	remove_from_free_sys_Queue, %function
remove_from_free_sys_Queue:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR74
	add	x19, x19, :lo12:.LANCHOR74
	ldrh	w3, [x19, 6]
	cbz	w3, .L403
	and	w1, w0, 65535
	ldrh	w0, [x19, 2]
	mov	w20, 0
.L400:
	cmp	w20, w3
	bcc	.L402
.L403:
	mov	w0, 0
	b	.L398
.L402:
	add	w2, w20, w0
	ubfiz	x2, x2, 1, 10
	add	x2, x19, x2
	ldrh	w2, [x2, 8]
	cmp	w2, w1
	bne	.L401
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
	ldrh	w0, [x19, 2]
	add	w20, w0, w20
	add	x1, x19, x0, sxtw 1
	add	w0, w0, 1
	and	w0, w0, 1023
	ubfiz	x20, x20, 1, 10
	add	x20, x19, x20
	strh	w0, [x19, 2]
	ldrh	w0, [x19, 6]
	ldrh	w1, [x1, 8]
	sub	w0, w0, #1
	strh	w1, [x20, 8]
	strh	w0, [x19, 6]
	mov	w0, 1
.L398:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L401:
	add	w20, w20, 1
	b	.L400
	.size	remove_from_free_sys_Queue, .-remove_from_free_sys_Queue
	.section	.text.FtlFreeSysBlkQueueOut,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueOut
	.type	FtlFreeSysBlkQueueOut, %function
FtlFreeSysBlkQueueOut:
	adrp	x0, .LANCHOR74
	add	x0, x0, :lo12:.LANCHOR74
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	ldrh	w2, [x0, 6]
	stp	x19, x20, [sp, 16]
	str	x21, [sp, 32]
	cbz	w2, .L408
	ldrh	w1, [x0, 2]
	sub	w2, w2, #1
	strh	w2, [x0, 6]
	add	x3, x0, x1, sxtw 1
	add	w1, w1, 1
	and	w1, w1, 1023
	strh	w1, [x0, 2]
	adrp	x0, .LANCHOR75
	ldrh	w19, [x3, 8]
	ldr	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L406
	mov	w0, w19
	bl	P2V_block_in_plane
	adrp	x1, .LANCHOR76
	and	w20, w0, 65535
	lsl	w2, w19, 10
	mov	x21, x1
	ldr	x0, [x1, #:lo12:.LANCHOR76]
	str	w2, [x0, 4]
	adrp	x2, .LANCHOR8
	ldrb	w2, [x2, #:lo12:.LANCHOR8]
	cbz	w2, .L407
	mov	w2, 1
	mov	w1, 0
	bl	FlashEraseBlocks
.L407:
	ldr	x0, [x21, #:lo12:.LANCHOR76]
	mov	w2, 1
	mov	w1, w2
	bl	FlashEraseBlocks
	adrp	x1, .LANCHOR77
	ubfiz	x0, x20, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR77]
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	adrp	x1, .LANCHOR78
	ldr	w0, [x1, #:lo12:.LANCHOR78]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR78]
.L406:
	mov	w0, w19
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L408:
	mov	w19, 65535
	b	.L406
	.size	FtlFreeSysBlkQueueOut, .-FtlFreeSysBlkQueueOut
	.section	.text.insert_data_list,"ax",@progbits
	.align	2
	.global	insert_data_list
	.type	insert_data_list, %function
insert_data_list:
	adrp	x1, .LANCHOR38
	and	w0, w0, 65535
	ldrh	w14, [x1, #:lo12:.LANCHOR38]
	cmp	w14, w0
	bls	.L429
	adrp	x1, .LANCHOR80
	mov	w3, 6
	ldr	x6, [x1, #:lo12:.LANCHOR80]
	umull	x13, w0, w3
	mov	w1, -1
	add	x5, x6, x13
	strh	w1, [x5, 2]
	strh	w1, [x6, x13]
	adrp	x1, .LANCHOR81
	mov	x15, x1
	ldr	x12, [x1, #:lo12:.LANCHOR81]
	cbnz	x12, .L416
	str	x5, [x1, #:lo12:.LANCHOR81]
.L429:
	mov	w0, 0
	ret
.L416:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR82
	ubfiz	x2, x0, 1, 16
	mov	x4, -6148914691236517206
	add	x29, sp, 0
	ldr	x16, [x1, #:lo12:.LANCHOR82]
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
	adrp	x4, .LANCHOR77
	ldr	x17, [x4, #:lo12:.LANCHOR77]
	and	w1, w1, 65535
	mov	x4, x12
	add	x10, x17, x2
	mov	w2, 0
.L424:
	add	w2, w2, 1
	and	w2, w2, 65535
	cmp	w14, w2
	bcc	.L415
	cmp	w1, w0
	beq	.L415
	ubfiz	x30, x1, 1, 16
	ldrh	w19, [x4, 4]
	cmp	w19, 0
	ldrh	w3, [x16, x30]
	mul	w3, w3, w19
	csel	w3, w3, w11, ne
	cmp	w7, w3
	bne	.L420
	ldrh	w19, [x17, x30]
	ldrh	w3, [x10]
	cmp	w19, w3
	bcc	.L422
.L421:
	strh	w1, [x6, x13]
	cmp	x4, x12
	ldrh	w1, [x4, 2]
	strh	w1, [x5, 2]
	bne	.L425
	strh	w0, [x4, 2]
	str	x5, [x15, #:lo12:.LANCHOR81]
	b	.L415
.L420:
	bcc	.L421
.L422:
	ldrh	w3, [x4]
	cmp	w3, w20
	bne	.L423
	strh	w1, [x5, 2]
	strh	w0, [x4]
	adrp	x0, .LANCHOR83
	str	x5, [x0, #:lo12:.LANCHOR83]
.L415:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L423:
	umaddl	x4, w3, w8, x6
	mov	w1, w3
	b	.L424
.L425:
	ldrh	w1, [x4, 2]
	mov	w2, 6
	umull	x1, w1, w2
	strh	w0, [x6, x1]
	strh	w0, [x4, 2]
	b	.L415
	.size	insert_data_list, .-insert_data_list
	.section	.text.INSERT_DATA_LIST,"ax",@progbits
	.align	2
	.global	INSERT_DATA_LIST
	.type	INSERT_DATA_LIST, %function
INSERT_DATA_LIST:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	insert_data_list
	adrp	x1, .LANCHOR84
	ldrh	w0, [x1, #:lo12:.LANCHOR84]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR84]
	adrp	x1, .LANCHOR38
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcs	.L431
	mov	w2, 205
	adrp	x1, .LANCHOR85
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR85
	add	x0, x0, :lo12:.LC4
	bl	printf
	ldp	x29, x30, [sp], 16
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	b	printf
.L431:
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
	beq	.L435
	adrp	x1, .LANCHOR80
	mov	w6, 6
	ldr	x3, [x1, #:lo12:.LANCHOR80]
	umull	x8, w0, w6
	mov	w1, -1
	add	x4, x3, x8
	strh	w1, [x4, 2]
	strh	w1, [x3, x8]
	adrp	x1, .LANCHOR86
	mov	x12, x1
	ldr	x5, [x1, #:lo12:.LANCHOR86]
	cbnz	x5, .L436
	str	x4, [x1, #:lo12:.LANCHOR86]
.L435:
	mov	w0, 0
	ret
.L436:
	adrp	x1, .LANCHOR77
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	ldr	x11, [x1, #:lo12:.LANCHOR77]
	ubfiz	x1, x0, 1, 16
	ldrh	w13, [x11, x1]
	sub	x1, x5, x3
	asr	x1, x1, 1
	mul	x1, x1, x2
	mov	x2, x5
	and	w1, w1, 65535
.L439:
	ubfiz	x10, x1, 1, 16
	ldrh	w10, [x11, x10]
	cmp	w10, w13
	bcs	.L437
	ldrh	w10, [x2]
	cmp	w10, w7
	bne	.L438
	strh	w1, [x4, 2]
	strh	w0, [x2]
	b	.L435
.L438:
	umaddl	x2, w10, w6, x3
	mov	w1, w10
	b	.L439
.L437:
	ldrh	w6, [x2, 2]
	cmp	x2, x5
	strh	w6, [x4, 2]
	strh	w1, [x3, x8]
	bne	.L440
	strh	w0, [x2, 2]
	str	x4, [x12, #:lo12:.LANCHOR86]
	b	.L435
.L440:
	ldrh	w1, [x2, 2]
	mov	w4, 6
	umull	x1, w1, w4
	strh	w0, [x3, x1]
	strh	w0, [x2, 2]
	b	.L435
	.size	insert_free_list, .-insert_free_list
	.section	.text.INSERT_FREE_LIST,"ax",@progbits
	.align	2
	.global	INSERT_FREE_LIST
	.type	INSERT_FREE_LIST, %function
INSERT_FREE_LIST:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	insert_free_list
	adrp	x1, .LANCHOR87
	ldrh	w0, [x1, #:lo12:.LANCHOR87]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR87]
	adrp	x1, .LANCHOR38
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcs	.L441
	mov	w2, 198
	adrp	x1, .LANCHOR88
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR88
	add	x0, x0, :lo12:.LC4
	bl	printf
	ldp	x29, x30, [sp], 16
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	b	printf
.L441:
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
	adrp	x20, .LANCHOR80
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	mov	w0, 6
	str	x23, [sp, 48]
	ldr	x23, [x20, #:lo12:.LANCHOR80]
	umull	x21, w1, w0
	mov	w0, 65535
	add	x19, x23, x21
	ldrh	w1, [x19, 2]
	cmp	w1, w0
	bne	.L445
	ldr	x0, [x22]
	cmp	x19, x0
	beq	.L445
	mov	w2, 363
	adrp	x1, .LANCHOR89
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR89
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L445:
	ldr	x0, [x22]
	mov	w1, 65535
	cmp	x19, x0
	ldrh	w0, [x23, x21]
	bne	.L446
	cmp	w0, w1
	bne	.L447
	str	xzr, [x22]
.L448:
	mov	w0, -1
	strh	w0, [x23, x21]
	strh	w0, [x19, 2]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L447:
	ldr	x1, [x20, #:lo12:.LANCHOR80]
	mov	w2, 6
	umaddl	x0, w0, w2, x1
	mov	w1, -1
	str	x0, [x22]
	strh	w1, [x0, 2]
	b	.L448
.L446:
	cmp	w0, w1
	ldrh	w1, [x19, 2]
	bne	.L449
	cmp	w1, w0
	beq	.L448
	mov	w0, 6
	mov	w2, -1
	umull	x1, w1, w0
	ldr	x0, [x20, #:lo12:.LANCHOR80]
	strh	w2, [x0, x1]
	b	.L448
.L449:
	ldr	x2, [x20, #:lo12:.LANCHOR80]
	mov	w3, 6
	umaddl	x4, w0, w3, x2
	strh	w1, [x4, 2]
	ldrh	w1, [x19, 2]
	umull	x1, w1, w3
	strh	w0, [x2, x1]
	b	.L448
	.size	List_remove_node, .-List_remove_node
	.section	.text.List_pop_index_node,"ax",@progbits
	.align	2
	.global	List_pop_index_node
	.type	List_pop_index_node, %function
List_pop_index_node:
	ldr	x2, [x0]
	cbz	x2, .L457
	stp	x29, x30, [sp, -32]!
	adrp	x3, .LANCHOR80
	and	w1, w1, 65535
	mov	w4, 65535
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	w5, 6
	ldr	x19, [x3, #:lo12:.LANCHOR80]
.L453:
	cbnz	w1, .L454
.L456:
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
.L454:
	ldrh	w3, [x2]
	cmp	w3, w4
	beq	.L456
	sub	w1, w1, #1
	umaddl	x2, w3, w5, x19
	and	w1, w1, 65535
	b	.L453
.L457:
	mov	w0, 65535
	ret
	.size	List_pop_index_node, .-List_pop_index_node
	.section	.text.List_get_gc_head_node,"ax",@progbits
	.align	2
	.global	List_get_gc_head_node
	.type	List_get_gc_head_node, %function
List_get_gc_head_node:
	and	w2, w0, 65535
	adrp	x0, .LANCHOR81
	ldr	x1, [x0, #:lo12:.LANCHOR81]
	cbz	x1, .L467
	adrp	x0, .LANCHOR80
	mov	w4, 6
	ldr	x3, [x0, #:lo12:.LANCHOR80]
	mov	w0, 65535
.L464:
	cbz	w2, .L465
	ldrh	w1, [x1]
	cmp	w1, w0
	bne	.L466
	ret
.L466:
	sub	w2, w2, #1
	umaddl	x1, w1, w4, x3
	and	w2, w2, 65535
	b	.L464
.L467:
	mov	w0, 65535
	ret
.L465:
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
	adrp	x0, .LANCHOR90
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR90]
	stp	x25, x26, [sp, 64]
	cmp	w0, w19
	beq	.L470
	adrp	x0, .LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w0, w19
	beq	.L470
	adrp	x0, .LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w0, w19
	beq	.L470
	adrp	x1, .LANCHOR80
	mov	w21, 6
	adrp	x0, .LANCHOR81
	mov	x26, x1
	umull	x21, w19, w21
	ldr	x23, [x1, #:lo12:.LANCHOR80]
	ldr	x2, [x0, #:lo12:.LANCHOR81]
	mov	x25, x0
	add	x22, x23, x21
	cmp	x22, x2
	beq	.L470
	adrp	x1, .LANCHOR82
	ubfiz	x0, x19, 1, 16
	mov	x24, x1
	ldr	x2, [x1, #:lo12:.LANCHOR82]
	mov	w1, 65535
	ldrh	w20, [x2, x0]
	ldrh	w0, [x22, 4]
	mul	w20, w20, w0
	ldrh	w0, [x22, 2]
	cmp	w20, 0
	csinv	w20, w20, wzr, ne
	cmp	w0, w1
	bne	.L473
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	bne	.L473
	mov	w2, 481
	adrp	x1, .LANCHOR93
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR93
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L473:
	ldrh	w0, [x22, 2]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L474
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	beq	.L470
.L474:
	mov	w1, 6
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	umull	x1, w0, w1
	asr	x0, x1, 1
	mul	x0, x0, x2
	ldr	x2, [x24, #:lo12:.LANCHOR82]
	ldrh	w0, [x2, x0, lsl 1]
	ldr	x2, [x26, #:lo12:.LANCHOR80]
	add	x1, x2, x1
	ldrh	w1, [x1, 4]
	mul	w0, w0, w1
	cmp	w0, 0
	csinv	w0, w0, wzr, ne
	cmp	w20, w0
	bcs	.L470
	adrp	x20, .LANCHOR84
	mov	w1, w19
	add	x0, x25, :lo12:.LANCHOR81
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR84]
	cbnz	w0, .L476
	mov	w2, 492
	adrp	x1, .LANCHOR93
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR93
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L476:
	ldrh	w0, [x20, #:lo12:.LANCHOR84]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR84]
	mov	w0, w19
	bl	INSERT_DATA_LIST
.L470:
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
.L479:
	cmp	w20, w1
	bne	.L482
.L483:
	mov	w2, 594
	adrp	x1, .LANCHOR94
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
	b	.L484
.L482:
	mov	x21, x0
	ldrh	w2, [x0], 2
	cbnz	w2, .L480
	bl	FtlFreeSysBlkQueueOut
	strh	w0, [x21]
	tst	w0, 65535
	beq	.L481
	ldr	w0, [x19, 48]
	strh	wzr, [x19, 2]
	add	w0, w0, 1
	str	w0, [x19, 48]
	ldrh	w0, [x19, 8]
	strh	w20, [x19]
	add	w0, w0, 1
	strh	w0, [x19, 8]
.L481:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bls	.L483
.L484:
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L480:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L479
	.size	ftl_map_blk_alloc_new_blk, .-ftl_map_blk_alloc_new_blk
	.section	.text.select_l2p_ram_region,"ax",@progbits
	.align	2
	.global	select_l2p_ram_region
	.type	select_l2p_ram_region, %function
select_l2p_ram_region:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR66
	mov	x1, 0
	mov	w3, 65535
	add	x29, sp, 0
	ldrh	w2, [x0, #:lo12:.LANCHOR66]
	adrp	x0, .LANCHOR95
	str	x19, [sp, 16]
	ldr	x0, [x0, #:lo12:.LANCHOR95]
.L490:
	and	w19, w1, 65535
	cmp	w19, w2
	bcc	.L492
	add	x3, x0, 4
	mov	w19, w2
	mov	w5, -2147483648
	mov	w1, 0
.L493:
	cmp	w1, w2
	bne	.L495
	cmp	w19, w2
	bcc	.L491
	adrp	x1, .LANCHOR96
	mov	w19, w2
	mov	w3, -1
	ldrh	w4, [x1, #:lo12:.LANCHOR96]
	mov	w1, 0
.L496:
	cmp	w1, w2
	bne	.L498
	cmp	w19, w1
	bcc	.L491
	mov	w2, 826
	adrp	x1, .LANCHOR97
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR97
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
	b	.L491
.L492:
	add	x1, x1, 1
	add	x4, x0, x1, lsl 4
	ldrh	w4, [x4, -16]
	cmp	w4, w3
	bne	.L490
.L491:
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L495:
	ldr	w4, [x3]
	tbnz	w4, #31, .L494
	cmp	w5, w4
	bls	.L494
	mov	w5, w4
	mov	w19, w1
.L494:
	add	w1, w1, 1
	add	x3, x3, 16
	and	w1, w1, 65535
	b	.L493
.L498:
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bls	.L497
	ldrh	w5, [x0]
	cmp	w5, w4
	csel	w3, w3, w6, eq
	csel	w19, w19, w1, eq
.L497:
	add	w1, w1, 1
	add	x0, x0, 16
	and	w1, w1, 65535
	b	.L496
	.size	select_l2p_ram_region, .-select_l2p_ram_region
	.section	.text.FtlUpdateVaildLpn,"ax",@progbits
	.align	2
	.global	FtlUpdateVaildLpn
	.type	FtlUpdateVaildLpn, %function
FtlUpdateVaildLpn:
	adrp	x2, .LANCHOR98
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR98]
	cmp	w1, 4
	bhi	.L501
	cbnz	w0, .L501
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR98]
	ret
.L501:
	adrp	x1, .LANCHOR38
	adrp	x0, .LANCHOR99
	strh	wzr, [x3, #:lo12:.LANCHOR98]
	mov	w2, 0
	ldrh	w5, [x1, #:lo12:.LANCHOR38]
	adrp	x1, .LANCHOR82
	str	wzr, [x0, #:lo12:.LANCHOR99]
	mov	w3, 0
	ldr	x6, [x1, #:lo12:.LANCHOR82]
	mov	w7, 65535
	mov	x1, 0
.L502:
	cmp	w5, w1, uxth
	bhi	.L504
	cbz	w3, .L500
	str	w2, [x0, #:lo12:.LANCHOR99]
.L500:
	ret
.L504:
	ldrh	w4, [x6, x1, lsl 1]
	cmp	w4, w7
	beq	.L503
	add	w2, w2, w4
	mov	w3, 1
.L503:
	add	x1, x1, 1
	b	.L502
	.size	FtlUpdateVaildLpn, .-FtlUpdateVaildLpn
	.section	.text.ftl_set_blk_mode,"ax",@progbits
	.align	2
	.global	ftl_set_blk_mode
	.type	ftl_set_blk_mode, %function
ftl_set_blk_mode:
	and	w0, w0, 65535
	cbz	w1, .L511
	b	ftl_set_blk_mode.part.9
.L511:
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
	adrp	x1, .LANCHOR36
	add	x4, x4, 16
	strh	wzr, [x0, 4]
	add	x4, x0, x4
	ldrh	w3, [x1, #:lo12:.LANCHOR36]
	mov	w1, 65535
.L514:
	cmp	w2, w3
	bcc	.L516
	adrp	x1, .LANCHOR51
	ubfiz	x3, x3, 1, 16
	add	x3, x3, 16
	add	x2, x0, 16
	ldrh	w1, [x1, #:lo12:.LANCHOR51]
	add	x3, x0, x3
	mov	w5, 65535
	sub	w1, w1, #1
	and	w1, w1, 65535
	sub	w1, w1, w6
.L517:
	cmp	x2, x3
	bne	.L519
	ret
.L516:
	ldrh	w5, [x4]
	cmp	w5, w1
	beq	.L515
	ldrh	w5, [x0, 4]
	add	w5, w5, 1
	strh	w5, [x0, 4]
.L515:
	add	w2, w2, 1
	add	x4, x4, 2
	and	w2, w2, 65535
	b	.L514
.L519:
	ldrh	w4, [x2]
	cmp	w4, w5
	beq	.L518
	ldrh	w4, [x0, 4]
	add	w4, w1, w4
	strh	w4, [x0, 4]
.L518:
	add	x2, x2, 2
	b	.L517
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
	adrp	x0, .LANCHOR38
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcc	.L521
	mov	w2, 2298
	adrp	x1, .LANCHOR100
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR100
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L521:
	adrp	x0, .LANCHOR36
	adrp	x7, .LANCHOR45
	add	x6, x19, 16
	add	x7, x7, :lo12:.LANCHOR45
	ldrh	w8, [x0, #:lo12:.LANCHOR36]
	mov	x5, 0
	strh	wzr, [x19, 4]
	mov	w10, -1
	strb	wzr, [x19, 7]
.L522:
	cmp	w8, w5, uxth
	bhi	.L524
	adrp	x1, .LANCHOR51
	ldrb	w0, [x19, 7]
	strb	wzr, [x19, 9]
	ldrh	w1, [x1, #:lo12:.LANCHOR51]
	mul	w0, w0, w1
	strh	w0, [x19, 4]
	adrp	x0, .LANCHOR101
	ldr	w0, [x0, #:lo12:.LANCHOR101]
	cbz	w0, .L525
	adrp	x0, .LANCHOR77
	ldrh	w1, [x19]
	ldr	x0, [x0, #:lo12:.LANCHOR77]
	ldrh	w0, [x0, x1, lsl 1]
	cmp	w0, 59
	bhi	.L525
	mov	w0, 1
	strb	w0, [x19, 9]
.L525:
	adrp	x0, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR1]
	cbz	w0, .L526
	mov	w0, 1
	strb	w0, [x19, 9]
.L526:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L524:
	ldrh	w1, [x19]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	mov	w4, w0
	strh	w10, [x6]
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L523
	strh	w4, [x6]
	ldrb	w0, [x19, 7]
	add	w0, w0, 1
	strb	w0, [x19, 7]
.L523:
	add	x5, x5, 1
	add	x6, x6, 2
	b	.L522
	.size	make_superblock, .-make_superblock
	.section	.text.update_multiplier_value,"ax",@progbits
	.align	2
	.global	update_multiplier_value
	.type	update_multiplier_value, %function
update_multiplier_value:
	and	w6, w0, 65535
	adrp	x0, .LANCHOR36
	mov	x7, 0
	adrp	x8, .LANCHOR45
	ldrh	w10, [x0, #:lo12:.LANCHOR36]
	adrp	x0, .LANCHOR51
	mov	w5, 0
	add	x8, x8, :lo12:.LANCHOR45
	ldrh	w11, [x0, #:lo12:.LANCHOR51]
	cmp	w10, w7, uxth
	bhi	.L546
	cbz	w5, .L544
	mov	w0, 32768
	sdiv	w5, w0, w5
.L545:
	adrp	x0, .LANCHOR80
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR80]
	umaddl	x6, w6, w1, x0
	mov	w0, 0
	strh	w5, [x6, 4]
	ret
.L539:
	mov	w5, 0
	b	.L538
.L544:
	mov	w5, 0
	b	.L545
.L546:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L537:
	ldrb	w0, [x8, x7]
	mov	w1, w6
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L536
	add	w5, w5, w11
	and	w5, w5, 65535
.L536:
	add	x7, x7, 1
	cmp	w10, w7, uxth
	bhi	.L537
	cbz	w5, .L539
	mov	w0, 32768
	sdiv	w5, w0, w5
.L538:
	adrp	x0, .LANCHOR80
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR80]
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
	adrp	x0, .LANCHOR86
	ldr	x0, [x0, #:lo12:.LANCHOR86]
	cbz	x0, .L549
	adrp	x1, .LANCHOR80
	ldr	x1, [x1, #:lo12:.LANCHOR80]
	sub	x0, x0, x1
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	adrp	x1, .LANCHOR77
	ldr	x1, [x1, #:lo12:.LANCHOR77]
	and	x0, x0, 65535
	ldrh	w0, [x1, x0, lsl 1]
	ret
.L549:
	mov	w0, 0
	ret
	.size	GetFreeBlockMinEraseCount, .-GetFreeBlockMinEraseCount
	.section	.text.GetFreeBlockMaxEraseCount,"ax",@progbits
	.align	2
	.global	GetFreeBlockMaxEraseCount
	.type	GetFreeBlockMaxEraseCount, %function
GetFreeBlockMaxEraseCount:
	adrp	x1, .LANCHOR86
	and	w0, w0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR86]
	cbz	x1, .L557
	adrp	x2, .LANCHOR87
	mov	w3, 7
	mov	w5, 6
	mov	w6, 65535
	ldrh	w2, [x2, #:lo12:.LANCHOR87]
	mul	w2, w2, w3
	asr	w2, w2, 3
	cmp	w0, w2
	csel	w0, w2, w0, gt
	adrp	x2, .LANCHOR80
	ldr	x3, [x2, #:lo12:.LANCHOR80]
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	sub	x1, x1, x3
	asr	x1, x1, 1
	mul	x1, x1, x2
	mov	w2, 0
	and	w1, w1, 65535
.L553:
	cmp	w0, w2
	beq	.L556
	umull	x4, w1, w5
	ldrh	w4, [x3, x4]
	cmp	w4, w6
	bne	.L554
.L556:
	adrp	x0, .LANCHOR77
	ubfiz	x1, x1, 1, 16
	ldr	x0, [x0, #:lo12:.LANCHOR77]
	ldrh	w0, [x0, x1]
	ret
.L554:
	add	w2, w2, 1
	mov	w1, w4
	and	w2, w2, 65535
	b	.L553
.L557:
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
	beq	.L561
	stp	x29, x30, [sp, -16]!
	adrp	x2, .LANCHOR82
	ubfiz	x1, x0, 1, 16
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR82]
	strh	wzr, [x2, x1]
	bl	INSERT_FREE_LIST
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L561:
	mov	w0, 0
	ret
	.size	free_data_superblock, .-free_data_superblock
	.section	.text.FtlGcBufInit,"ax",@progbits
	.align	2
	.global	FtlGcBufInit
	.type	FtlGcBufInit, %function
FtlGcBufInit:
	adrp	x1, .LANCHOR103
	adrp	x0, .LANCHOR102
	adrp	x7, .LANCHOR104
	adrp	x6, .LANCHOR105
	ldr	x5, [x1, #:lo12:.LANCHOR103]
	adrp	x1, .LANCHOR56
	str	wzr, [x0, #:lo12:.LANCHOR102]
	adrp	x0, .LANCHOR36
	ldrh	w10, [x1, #:lo12:.LANCHOR56]
	adrp	x1, .LANCHOR57
	ldrh	w0, [x0, #:lo12:.LANCHOR36]
	mov	w8, 24
	ldrh	w11, [x1, #:lo12:.LANCHOR57]
	adrp	x1, .LANCHOR106
	ldr	x14, [x7, #:lo12:.LANCHOR104]
	mov	x3, x5
	ldr	x4, [x1, #:lo12:.LANCHOR106]
	mov	w2, 0
	ldr	x15, [x6, #:lo12:.LANCHOR105]
	nop // between mem op and mult-accumulate
	umaddl	x8, w0, w8, x5
	add	x4, x4, 8
	mov	w1, 0
	mov	w16, 1
.L565:
	add	w13, w2, w10
	add	w12, w1, w11
	cmp	x3, x8
	bne	.L566
	adrp	x1, .LANCHOR107
	ldr	x7, [x7, #:lo12:.LANCHOR104]
	ldr	x6, [x6, #:lo12:.LANCHOR105]
	mov	w8, 24
	ldr	w4, [x1, #:lo12:.LANCHOR107]
.L567:
	cmp	w0, w4
	bcc	.L568
	ret
.L566:
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
	b	.L565
.L568:
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
	b	.L567
	.size	FtlGcBufInit, .-FtlGcBufInit
	.section	.text.FtlGcBufFree,"ax",@progbits
	.align	2
	.global	FtlGcBufFree
	.type	FtlGcBufFree, %function
FtlGcBufFree:
	adrp	x2, .LANCHOR107
	mov	w3, 0
	mov	w7, 56
	mov	w10, 24
	ldr	w8, [x2, #:lo12:.LANCHOR107]
	adrp	x2, .LANCHOR103
	ldr	x4, [x2, #:lo12:.LANCHOR103]
.L570:
	cmp	w3, w1
	bcs	.L569
	umaddl	x6, w3, w7, x0
	mov	w2, 0
	b	.L575
.L571:
	add	w2, w2, 1
	and	w2, w2, 65535
.L575:
	cmp	w2, w8
	bcs	.L572
	umull	x5, w2, w10
	add	x11, x4, x5
	ldr	x12, [x4, x5]
	ldr	x5, [x6, 8]
	cmp	x12, x5
	bne	.L571
	str	wzr, [x11, 16]
.L572:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L570
.L569:
	ret
	.size	FtlGcBufFree, .-FtlGcBufFree
	.section	.text.FtlGcBufAlloc,"ax",@progbits
	.align	2
	.global	FtlGcBufAlloc
	.type	FtlGcBufAlloc, %function
FtlGcBufAlloc:
	adrp	x2, .LANCHOR107
	mov	w3, 0
	mov	w7, 24
	mov	w8, 1
	ldr	w5, [x2, #:lo12:.LANCHOR107]
	adrp	x2, .LANCHOR103
	mov	w10, 56
	ldr	x6, [x2, #:lo12:.LANCHOR103]
.L577:
	cmp	w3, w1
	bcs	.L576
	mov	w2, 0
	b	.L582
.L578:
	add	w2, w2, 1
	and	w2, w2, 65535
.L582:
	cmp	w2, w5
	bcs	.L579
	umaddl	x4, w2, w7, x6
	ldr	w11, [x4, 16]
	cbnz	w11, .L578
	umaddl	x2, w3, w10, x0
	ldr	x11, [x4]
	str	w8, [x4, 16]
	ldr	x4, [x4, 8]
	stp	x11, x4, [x2, 8]
.L579:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L577
.L576:
	ret
	.size	FtlGcBufAlloc, .-FtlGcBufAlloc
	.section	.text.IsBlkInGcList,"ax",@progbits
	.align	2
	.global	IsBlkInGcList
	.type	IsBlkInGcList, %function
IsBlkInGcList:
	adrp	x1, .LANCHOR108
	and	w0, w0, 65535
	ldrh	w2, [x1, #:lo12:.LANCHOR108]
	adrp	x1, .LANCHOR109
	ldr	x3, [x1, #:lo12:.LANCHOR109]
	mov	x1, 0
.L584:
	cmp	w2, w1, uxth
	bhi	.L586
	mov	w0, 0
	ret
.L586:
	add	x1, x1, 1
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L584
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
	adrp	x4, .LANCHOR108
	adrp	x2, .LANCHOR109
	mov	x3, 0
	ldrh	w1, [x4, #:lo12:.LANCHOR108]
	ldr	x5, [x2, #:lo12:.LANCHOR109]
.L589:
	and	w2, w3, 65535
	cmp	w2, w1
	bcc	.L591
	bne	.L590
	and	x3, x3, 65535
	strh	w0, [x5, x3, lsl 1]
	ldrh	w0, [x4, #:lo12:.LANCHOR108]
	add	w0, w0, 1
	strh	w0, [x4, #:lo12:.LANCHOR108]
	b	.L590
.L591:
	add	x3, x3, 1
	add	x2, x5, x3, lsl 1
	ldrh	w2, [x2, -2]
	cmp	w2, w7
	bne	.L589
.L590:
	adrp	x4, .LANCHOR110
	adrp	x1, .LANCHOR111
	mov	w3, 12
	ldrh	w0, [x4, #:lo12:.LANCHOR110]
	ldr	x5, [x1, #:lo12:.LANCHOR111]
	umull	x3, w0, w3
	add	w0, w0, 1
	add	x7, x5, x3
	stp	w10, w8, [x7, 4]
	str	w6, [x5, x3]
	strh	w0, [x4, #:lo12:.LANCHOR110]
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlGcUpdatePage, .-FtlGcUpdatePage
	.section	.text.FtlGcRefreshBlock,"ax",@progbits
	.align	2
	.global	FtlGcRefreshBlock
	.type	FtlGcRefreshBlock, %function
FtlGcRefreshBlock:
	adrp	x4, .LANCHOR112
	and	w0, w0, 65535
	ldrh	w5, [x4, #:lo12:.LANCHOR112]
	cmp	w5, w0
	beq	.L594
	adrp	x1, .LANCHOR113
	ldrh	w3, [x1, #:lo12:.LANCHOR113]
	cmp	w0, w3
	beq	.L594
	mov	w2, 65535
	cmp	w5, w2
	bne	.L595
	strh	w0, [x4, #:lo12:.LANCHOR112]
.L594:
	mov	w0, 0
	ret
.L595:
	cmp	w3, w2
	bne	.L594
	strh	w0, [x1, #:lo12:.LANCHOR113]
	b	.L594
	.size	FtlGcRefreshBlock, .-FtlGcRefreshBlock
	.section	.text.FtlGcRefreshOpenBlock,"ax",@progbits
	.align	2
	.global	FtlGcRefreshOpenBlock
	.type	FtlGcRefreshOpenBlock, %function
FtlGcRefreshOpenBlock:
	b	FtlGcRefreshBlock
	.size	FtlGcRefreshOpenBlock, .-FtlGcRefreshOpenBlock
	.section	.text.FtlGcMarkBadPhyBlk,"ax",@progbits
	.align	2
	.global	FtlGcMarkBadPhyBlk
	.type	FtlGcMarkBadPhyBlk, %function
FtlGcMarkBadPhyBlk:
	and	w7, w0, 65535
	stp	x29, x30, [sp, -16]!
	mov	w0, w7
	add	x29, sp, 0
	bl	P2V_block_in_plane
	and	w6, w0, 65535
	bl	FtlGcRefreshBlock
	adrp	x0, .LANCHOR101
	ldr	w0, [x0, #:lo12:.LANCHOR101]
	cbz	w0, .L598
	adrp	x1, .LANCHOR77
	ubfiz	x0, x6, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR77]
	ldrh	w1, [x2, x0]
	cmp	w1, 29
	bls	.L598
	sub	w1, w1, #30
	strh	w1, [x2, x0]
.L598:
	adrp	x1, .LANCHOR114
	adrp	x3, .LANCHOR115
	add	x3, x3, :lo12:.LANCHOR115
	mov	x2, 0
	ldrh	w0, [x1, #:lo12:.LANCHOR114]
.L599:
	cmp	w0, w2, uxth
	bhi	.L601
	cmp	w0, 15
	bhi	.L600
	add	w2, w0, 1
	strh	w2, [x1, #:lo12:.LANCHOR114]
	adrp	x1, .LANCHOR115
	add	x1, x1, :lo12:.LANCHOR115
	strh	w7, [x1, w0, sxtw 1]
	b	.L600
.L601:
	add	x2, x2, 1
	add	x4, x3, x2, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w7
	bne	.L599
.L600:
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlGcMarkBadPhyBlk, .-FtlGcMarkBadPhyBlk
	.section	.text.FtlGcReFreshBadBlk,"ax",@progbits
	.align	2
	.global	FtlGcReFreshBadBlk
	.type	FtlGcReFreshBadBlk, %function
FtlGcReFreshBadBlk:
	adrp	x0, .LANCHOR114
	ldrh	w0, [x0, #:lo12:.LANCHOR114]
	cbz	w0, .L613
	adrp	x1, .LANCHOR112
	ldrh	w2, [x1, #:lo12:.LANCHOR112]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L613
	stp	x29, x30, [sp, -16]!
	adrp	x6, .LANCHOR116
	add	x29, sp, 0
	ldrh	w1, [x6, #:lo12:.LANCHOR116]
	cmp	w1, w0
	bcc	.L608
	strh	wzr, [x6, #:lo12:.LANCHOR116]
.L608:
	ldrh	w1, [x6, #:lo12:.LANCHOR116]
	adrp	x0, .LANCHOR115
	add	x0, x0, :lo12:.LANCHOR115
	ldrh	w0, [x0, x1, lsl 1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	w0, [x6, #:lo12:.LANCHOR116]
	ldp	x29, x30, [sp], 16
	add	w0, w0, 1
	strh	w0, [x6, #:lo12:.LANCHOR116]
	mov	w0, 0
	ret
.L613:
	mov	w0, 0
	ret
	.size	FtlGcReFreshBadBlk, .-FtlGcReFreshBadBlk
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
	cbnz	w0, .L618
	adrp	x1, .LANCHOR16
	add	x1, x1, :lo12:.LANCHOR16
	mov	x0, 0
.L619:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 256
	bne	.L619
.L625:
	adrp	x19, .LANCHOR117
	add	x19, x19, :lo12:.LANCHOR117
	mov	w1, 255
	mov	w2, 1024
	mov	x0, x19
	bl	ftl_memset
	adrp	x1, .LANCHOR16
	and	w20, w20, 65535
	add	x1, x1, :lo12:.LANCHOR16
	mov	x0, 0
.L620:
	cmp	w20, w0, uxth
	bhi	.L642
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L618:
	cmp	w0, 1
	bne	.L621
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
	mov	x1, 0
.L624:
	and	w0, w1, 65535
	cmp	x1, 3
	bls	.L622
	ubfiz	w3, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 2
	sub	w0, w3, w0
	and	w0, w0, 65535
.L622:
	strh	w0, [x2, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L624
	b	.L625
.L621:
	cmp	w0, 2
	bne	.L626
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
	mov	w1, 65535
	mov	x0, 0
.L628:
	cmp	x0, 2
	and	w3, w0, 65535
	csel	w3, w3, w1, cc
	strh	w3, [x2, x0, lsl 1]
	add	w1, w1, 2
	add	x0, x0, 1
	and	w1, w1, 65535
	cmp	x0, 256
	bne	.L628
	b	.L625
.L626:
	cmp	w0, 3
	bne	.L629
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
	mov	x1, 0
.L632:
	and	w0, w1, 65535
	cmp	x1, 5
	bls	.L630
	ubfiz	w3, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 4
	sub	w0, w3, w0
	and	w0, w0, 65535
.L630:
	strh	w0, [x2, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L632
	b	.L625
.L629:
	cmp	w0, 4
	bne	.L633
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
.L635:
	and	w3, w0, 1
	ubfiz	w2, w0, 1, 15
	add	w3, w3, 6
	add	w0, w0, 1
	sub	w2, w2, w3
	strh	w2, [x1], 2
	and	w0, w0, 65535
	cmp	w0, 256
	bne	.L635
	b	.L625
.L633:
	cmp	w0, 5
	bne	.L636
	adrp	x1, .LANCHOR16
	add	x1, x1, :lo12:.LANCHOR16
	mov	x0, 0
.L637:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 16
	bne	.L637
	add	x1, x1, 32
.L638:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 496
	bne	.L638
	b	.L625
.L636:
	cmp	w0, 6
	bne	.L625
	adrp	x3, .LANCHOR16
	add	x3, x3, :lo12:.LANCHOR16
	mov	w1, 0
	mov	x2, 0
	mov	w4, 12
	mov	w5, 10
.L641:
	and	w0, w2, 65535
	cmp	x2, 5
	bls	.L639
	tst	x0, 1
	csel	w0, w4, w5, ne
	sub	w0, w1, w0
	and	w0, w0, 65535
.L639:
	strh	w0, [x3, x2, lsl 1]
	add	w1, w1, 3
	and	w1, w1, 65535
	add	x2, x2, 1
	cmp	w1, 768
	bne	.L641
	b	.L625
.L642:
	ldrh	w2, [x1, x0, lsl 1]
	add	x0, x0, 1
	strh	w2, [x19, w2, sxtw 1]
	b	.L620
	.size	BuildFlashLsbPageTable, .-BuildFlashLsbPageTable
	.section	.text.FlashDieInfoInit,"ax",@progbits
	.align	2
	.global	FlashDieInfoInit
	.type	FlashDieInfoInit, %function
FlashDieInfoInit:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR29+10
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR25
	adrp	x20, .LANCHOR118
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR29+10]
	adrp	x23, .LANCHOR3
	stp	x21, x22, [sp, 32]
	strb	wzr, [x19, #:lo12:.LANCHOR25]
	cmp	w0, 256
	strb	wzr, [x20, #:lo12:.LANCHOR118]
	str	x25, [sp, 64]
	bls	.L658
	mov	w0, 512
.L675:
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
.L662:
	mov	w2, w11
	add	x1, x15, x8, lsl 3
	mov	x0, x10
	bl	FlashMemCmp8
	cbnz	w0, .L661
	ldrb	w1, [x14]
	add	w0, w1, 1
	strb	w0, [x14]
	str	wzr, [x21, x1, lsl 2]
	strb	w8, [x22, x1]
.L661:
	add	x8, x8, 1
	cmp	x8, 4
	bne	.L662
	ldrb	w0, [x19, #:lo12:.LANCHOR25]
	strb	w0, [x20, #:lo12:.LANCHOR118]
	ldrb	w0, [x7, 8]
	cmp	w0, 2
	beq	.L663
.L667:
	ldrb	w0, [x19, #:lo12:.LANCHOR25]
	ldrh	w1, [x7, 14]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	mul	w0, w0, w1
	ldrb	w1, [x7, 13]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	mul	w0, w0, w1
	adrp	x1, .LANCHOR119
	ldp	x29, x30, [sp], 80
	strh	w0, [x1, #:lo12:.LANCHOR119]
	ret
.L658:
	cmp	w0, 128
	bls	.L675
	mov	w0, 256
	b	.L675
.L663:
	ldr	w20, [x23, #:lo12:.LANCHOR3]
	add	x12, x12, :lo12:.LANCHOR22
	add	x14, x19, :lo12:.LANCHOR25
	add	x24, x24, :lo12:.LANCHOR17
	add	x13, x25, :lo12:.LANCHOR26
	mov	x15, 0
.L666:
	mov	w2, w11
	add	x1, x12, x15, lsl 3
	mov	x0, x10
	bl	FlashMemCmp8
	cbnz	w0, .L664
	ldrb	w2, [x7, 13]
	ldrh	w0, [x7, 14]
	ldrb	w1, [x14]
	and	w0, w0, 65280
	mul	w2, w2, w20
	mul	w0, w0, w2
	sxtw	x2, w1
	str	w0, [x24, x2, lsl 2]
	ldrb	w3, [x7, 23]
	cbz	w3, .L665
	lsl	w0, w0, 1
	str	w0, [x24, x2, lsl 2]
.L665:
	add	w1, w1, 1
	strb	w15, [x13, x2]
	strb	w1, [x14]
.L664:
	add	x15, x15, 1
	cmp	x15, 4
	bne	.L666
	b	.L667
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
	adrp	x3, .LANCHOR67
	mov	w4, 1
	ldr	x1, [x0, #:lo12:.LANCHOR18]
	adrp	x0, .LANCHOR3
	ldr	w0, [x0, #:lo12:.LANCHOR3]
	ldrb	w2, [x1, 9]
	mul	w0, w0, w2
	strb	w0, [x19, 4]
	ubfx	x0, x0, 8, 8
	strb	w0, [x19, 5]
	adrp	x0, .LANCHOR31
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	strb	w0, [x19, 7]
	add	x0, x3, :lo12:.LANCHOR67
	ldrb	w3, [x3, #:lo12:.LANCHOR67]
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
.L677:
	cmp	w3, w1, uxtb
	bhi	.L678
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L678:
	ldrb	w0, [x1, x2]
	add	x1, x1, 1
	ldrb	w5, [x19, 10]
	lsl	w0, w4, w0
	orr	w0, w0, w5
	strb	w0, [x19, 10]
	b	.L677
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
	adrp	x0, .LANCHOR120
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR49
	adrp	x23, .LANCHOR121
	ldrh	w2, [x0, #:lo12:.LANCHOR120]
	add	x22, x22, :lo12:.LANCHOR49
	add	x23, x23, :lo12:.LANCHOR121
	stp	x19, x20, [sp, 16]
	mov	w24, 65535
	mov	x19, 0
	mov	x20, x1
	lsl	w2, w2, 2
	mov	w1, 0
	mov	x0, x20
	bl	ftl_memset
.L683:
	ldrh	w0, [x21, x19]
	cmp	w0, w24
	beq	.L680
	ldrh	w1, [x22]
	cmp	w1, w0
	bhi	.L682
	mov	w2, 79
	mov	x1, x23
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L682:
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
	bne	.L683
.L680:
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
	adrp	x1, .LANCHOR73
	add	x0, x1, :lo12:.LANCHOR73
	mov	w2, -1
	add	x0, x0, 12
	strh	w2, [x1, #:lo12:.LANCHOR73]
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
	adrp	x1, .LANCHOR74
	add	x3, x1, :lo12:.LANCHOR74
	mov	w2, 2048
	add	x29, sp, 0
	strh	w0, [x1, #:lo12:.LANCHOR74]
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
	stp	x25, x26, [sp, 64]
	lsl	w2, w2, 1
	ldr	x23, [x0, 16]
	mov	x0, x21
	bl	ftl_memset
	mov	w0, 0
.L691:
	ldrh	w1, [x19, 6]
	cmp	w1, w0
	bhi	.L695
	ldrh	w26, [x21]
	adrp	x24, .LANCHOR52
	add	x24, x24, :lo12:.LANCHOR52
	mov	w25, 0
	mov	w20, 0
.L696:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L700
	mov	w0, w25
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L695:
	ubfiz	x1, x0, 2, 16
	ldr	w2, [x20, x1]
	mov	w1, 0
	ubfx	x2, x2, 10, 16
.L692:
	ldrh	w3, [x19, 10]
	cmp	w3, w1
	bhi	.L694
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L691
.L694:
	ubfiz	x3, x1, 1, 16
	ldrh	w4, [x23, x3]
	cmp	w4, w2
	bne	.L693
	ldrh	w4, [x21, x3]
	add	w4, w4, 1
	strh	w4, [x21, x3]
.L693:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L692
.L700:
	ldrh	w0, [x19]
	uxtw	x22, w20
	cmp	w0, w20
	bne	.L697
	ldrh	w0, [x24]
	ldrh	w1, [x19, 2]
	cmp	w1, w0
	bcs	.L697
	strh	w0, [x21, x22, lsl 1]
.L697:
	lsl	x22, x22, 1
	ldrh	w0, [x21, x22]
	cmp	w26, w0
	bls	.L698
	mov	w25, w20
	mov	w26, w0
.L698:
	cbnz	w0, .L699
	ldrh	w0, [x23, x22]
	cbz	w0, .L699
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
	strh	wzr, [x23, x22]
	ldrh	w0, [x19, 8]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
.L699:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L696
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
	adrp	x19, .LANCHOR122
	adrp	x20, .LANCHOR63
	stp	x21, x22, [sp, 32]
	ldr	x0, [x19, #:lo12:.LANCHOR122]
	adrp	x22, .LANCHOR56
	ldr	w2, [x20, #:lo12:.LANCHOR63]
	adrp	x21, .LANCHOR66
	str	x23, [sp, 48]
	adrp	x23, .LANCHOR123
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w0, [x21, #:lo12:.LANCHOR66]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR56]
	mul	w2, w2, w0
	ldr	x0, [x23, #:lo12:.LANCHOR123]
	bl	ftl_memset
	adrp	x0, .LANCHOR95
	ldrh	w3, [x21, #:lo12:.LANCHOR66]
	ldr	x6, [x23, #:lo12:.LANCHOR123]
	mov	x1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR95]
	mov	w2, -1
	ldrh	w5, [x22, #:lo12:.LANCHOR56]
	add	x3, x0, x3, lsl 4
.L706:
	add	x4, x1, x5
	cmp	x0, x3
	bne	.L707
	adrp	x1, .LANCHOR124
	add	x0, x1, :lo12:.LANCHOR124
	ldp	x21, x22, [sp, 32]
	strh	w2, [x1, #:lo12:.LANCHOR124]
	ldr	w1, [x20, #:lo12:.LANCHOR63]
	strh	w1, [x0, 10]
	mov	w1, -3902
	strh	w1, [x0, 4]
	adrp	x1, .LANCHOR125
	ldr	x23, [sp, 48]
	strh	w2, [x0, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR125]
	strh	w1, [x0, 8]
	adrp	x1, .LANCHOR65
	strh	w2, [x0, 60]
	ldrh	w1, [x1, #:lo12:.LANCHOR65]
	strh	w1, [x0, 6]
	adrp	x1, .LANCHOR126
	ldr	x1, [x1, #:lo12:.LANCHOR126]
	str	x1, [x0, 16]
	adrp	x1, .LANCHOR127
	ldr	x1, [x1, #:lo12:.LANCHOR127]
	str	x1, [x0, 24]
	ldr	x1, [x19, #:lo12:.LANCHOR122]
	ldp	x19, x20, [sp, 16]
	str	x1, [x0, 32]
	adrp	x1, .LANCHOR128
	ldr	x1, [x1, #:lo12:.LANCHOR128]
	str	x1, [x0, 40]
	ldp	x29, x30, [sp], 64
	ret
.L707:
	and	x1, x1, -4
	strh	w2, [x0]
	add	x1, x6, x1
	str	wzr, [x0, 4]
	str	x1, [x0, 8]
	add	x0, x0, 16
	mov	x1, x4
	b	.L706
	.size	FtlL2PDataInit, .-FtlL2PDataInit
	.section	.text.FtlVariablesInit,"ax",@progbits
	.align	2
	.global	FtlVariablesInit
	.type	FtlVariablesInit, %function
FtlVariablesInit:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR129
	mov	w1, -1
	add	x29, sp, 0
	str	xzr, [x0, #:lo12:.LANCHOR129]
	adrp	x0, .LANCHOR130
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR39
	strh	w1, [x0, #:lo12:.LANCHOR130]
	adrp	x0, .LANCHOR131
	mov	w1, -1
	str	wzr, [x0, #:lo12:.LANCHOR131]
	adrp	x0, .LANCHOR132
	str	wzr, [x0, #:lo12:.LANCHOR132]
	adrp	x0, .LANCHOR133
	str	w1, [x0, #:lo12:.LANCHOR133]
	adrp	x0, .LANCHOR101
	mov	w1, 0
	str	wzr, [x0, #:lo12:.LANCHOR101]
	adrp	x0, .LANCHOR69
	strh	wzr, [x0, #:lo12:.LANCHOR69]
	adrp	x0, .LANCHOR60
	ldrh	w2, [x0, #:lo12:.LANCHOR60]
	adrp	x0, .LANCHOR70
	ldr	x0, [x0, #:lo12:.LANCHOR70]
	lsl	w2, w2, 1
	bl	ftl_memset
	adrp	x0, .LANCHOR77
	ldrh	w2, [x19, #:lo12:.LANCHOR39]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR77]
	lsl	w2, w2, 1
	bl	ftl_memset
	adrp	x0, .LANCHOR134
	ldrh	w2, [x19, #:lo12:.LANCHOR39]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR134]
	lsl	w2, w2, 1
	bl	ftl_memset
	mov	w2, 48
	mov	w1, 0
	adrp	x0, .LANCHOR135
	add	x0, x0, :lo12:.LANCHOR135
	bl	ftl_memset
	mov	w2, 512
	mov	w1, 0
	adrp	x0, .LANCHOR136
	add	x0, x0, :lo12:.LANCHOR136
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
	adrp	x0, .LANCHOR39
	mov	w1, 0
	add	x29, sp, 0
	ldrh	w2, [x0, #:lo12:.LANCHOR39]
	mov	w0, 6
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR80
	stp	x19, x20, [sp, 16]
	adrp	x23, .LANCHOR84
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR87
	mul	w2, w2, w0
	ldr	x0, [x24, #:lo12:.LANCHOR80]
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR38
	str	x27, [sp, 80]
	adrp	x26, .LANCHOR45
	add	x25, x25, :lo12:.LANCHOR38
	add	x26, x26, :lo12:.LANCHOR45
	bl	ftl_memset
	mov	w21, 0
	adrp	x0, .LANCHOR86
	mov	w20, 0
	mov	w19, 0
	strh	wzr, [x23, #:lo12:.LANCHOR84]
	str	xzr, [x0, #:lo12:.LANCHOR86]
	adrp	x0, .LANCHOR81
	strh	wzr, [x22, #:lo12:.LANCHOR87]
	adrp	x27, .LANCHOR36
	str	xzr, [x0, #:lo12:.LANCHOR81]
	adrp	x0, .LANCHOR83
	str	xzr, [x0, #:lo12:.LANCHOR83]
	adrp	x0, .LANCHOR137
	strh	wzr, [x0, #:lo12:.LANCHOR137]
.L712:
	ldrh	w0, [x25]
	cmp	w19, w0
	bge	.L719
	adrp	x0, .LANCHOR51
	ldrh	w8, [x27, #:lo12:.LANCHOR36]
	mov	w5, 0
	mov	w6, 0
	ldrh	w7, [x0, #:lo12:.LANCHOR51]
	b	.L720
.L714:
	ldrb	w0, [x26, w6, sxtw]
	mov	w1, w19
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L713
	add	w5, w7, w5
	sxth	w5, w5
.L713:
	add	w6, w6, 1
	sxth	w6, w6
.L720:
	cmp	w6, w8
	blt	.L714
	cbz	w5, .L715
	mov	w0, 32768
	sdiv	w5, w0, w5
	sxth	w5, w5
.L716:
	ldr	x1, [x24, #:lo12:.LANCHOR80]
	mov	w0, 6
	smaddl	x0, w19, w0, x1
	strh	w5, [x0, 4]
	adrp	x0, .LANCHOR90
	ldrh	w0, [x0, #:lo12:.LANCHOR90]
	cmp	w19, w0
	beq	.L717
	adrp	x0, .LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w19, w0
	beq	.L717
	adrp	x0, .LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w19, w0
	beq	.L717
	adrp	x0, .LANCHOR82
	ldr	x0, [x0, #:lo12:.LANCHOR82]
	ldrh	w0, [x0, w19, sxtw 1]
	cbnz	w0, .L718
	add	w21, w21, 1
	mov	w0, w19
	and	w21, w21, 65535
	bl	INSERT_FREE_LIST
.L717:
	add	w19, w19, 1
	sxth	w19, w19
	b	.L712
.L715:
	adrp	x0, .LANCHOR82
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR82]
	strh	w1, [x0, w19, sxtw 1]
	b	.L716
.L718:
	add	w20, w20, 1
	mov	w0, w19
	and	w20, w20, 65535
	bl	INSERT_DATA_LIST
	b	.L717
.L719:
	strh	w20, [x23, #:lo12:.LANCHOR84]
	add	w20, w20, w21
	strh	w21, [x22, #:lo12:.LANCHOR87]
	cmp	w0, w20
	bge	.L721
	mov	w2, 2368
	adrp	x1, .LANCHOR138
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR138
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L721:
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
	adrp	x0, .LANCHOR108
	mov	w1, 255
	add	x29, sp, 0
	strh	wzr, [x0, #:lo12:.LANCHOR108]
	adrp	x0, .LANCHOR110
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR53
	strh	wzr, [x0, #:lo12:.LANCHOR110]
	adrp	x0, .LANCHOR109
	ldrh	w2, [x19, #:lo12:.LANCHOR53]
	ldr	x0, [x0, #:lo12:.LANCHOR109]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w2, [x19, #:lo12:.LANCHOR53]
	mov	w0, 12
	mov	w1, 255
	mul	w2, w2, w0
	adrp	x0, .LANCHOR111
	ldr	x0, [x0, #:lo12:.LANCHOR111]
	bl	ftl_memset
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	FtlGcBufInit
	.size	FtlGcPageVarInit, .-FtlGcPageVarInit
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
	adrp	x1, .LANCHOR139
	add	x1, x1, :lo12:.LANCHOR139
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
	adrp	x0, .LANCHOR140
	add	x8, x0, :lo12:.LANCHOR140
	adrp	x11, .LANCHOR22
	add	x29, sp, 0
	add	x8, x8, 1
	mov	x7, x0
	add	x11, x11, :lo12:.LANCHOR22
	stp	x19, x20, [sp, 16]
	mov	x10, 0
.L731:
	ldrb	w2, [x8, -1]
	mov	w12, w10
	lsl	x20, x10, 5
	mov	x1, x11
	mov	x0, x8
	bl	FlashMemCmp8
	mov	w19, w0
	cbnz	w0, .L729
	add	x0, x7, :lo12:.LANCHOR140
	ubfiz	x12, x12, 5, 32
	add	x20, x0, x20
	add	x0, x0, x12
	adrp	x1, .LANCHOR141
	add	x4, x1, :lo12:.LANCHOR141
	ldrb	w3, [x0, 22]
	mov	x0, 0
.L730:
	lsl	x5, x0, 5
	mov	w2, w0
	ldrb	w5, [x5, x4]
	cmp	w5, w3
	beq	.L733
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L730
	mov	w2, w0
.L733:
	ubfiz	x0, x2, 5, 32
	add	x1, x1, :lo12:.LANCHOR141
	add	x1, x1, x0
	mov	w2, 32
	adrp	x0, .LANCHOR7
	add	x0, x0, :lo12:.LANCHOR7
	bl	ftl_memcpy
	mov	w2, 32
	mov	x1, x20
	adrp	x0, .LANCHOR29
	add	x0, x0, :lo12:.LANCHOR29
	bl	ftl_memcpy
	b	.L728
.L729:
	add	x10, x10, 1
	add	x8, x8, 32
	cmp	x10, 73
	bne	.L731
	mov	w19, -1
.L728:
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
.L738:
	cmp	w2, w3
	bhi	.L739
	ret
.L739:
	ldr	w4, [x1, x3, lsl 2]
	str	w4, [x0, x3, lsl 2]
	add	x3, x3, 1
	b	.L738
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
	bne	.L741
	cbz	x3, .L742
	tst	x3, 3
	bne	.L743
	mov	w2, 256
	mov	x1, x3
	bl	ftl_memcpy32
.L742:
	cbz	x20, .L740
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
.L740:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L743:
	mov	w2, 1024
	mov	x1, x3
	bl	ftl_memcpy
	b	.L742
.L741:
	cbz	x3, .L746
	tst	x3, 3
	bne	.L747
	mov	x1, x0
	mov	w2, 256
	mov	x0, x3
	bl	ftl_memcpy32
.L746:
	cbz	x20, .L740
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
	b	.L740
.L747:
	mov	x1, x0
	mov	w2, 1024
	mov	x0, x3
	bl	ftl_memcpy
	b	.L746
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
	bne	.L760
	cbnz	x4, .L761
	add	x21, x29, 128
	mov	w2, 64
	mov	w1, 255
	add	x0, x29, 128
	bl	ftl_memset
.L761:
	mov	x5, x21
	mov	x4, x26
	mov	w2, w24
	mov	w1, w20
	mov	w3, 0
	mov	w0, w25
	bl	NandcXferStart
	mov	w0, w25
	bl	NandcXferComp
	cbnz	w20, .L785
	adrp	x0, .LANCHOR30
	adrp	x4, .LANCHOR33
	mov	x1, x0
	add	x4, x4, :lo12:.LANCHOR33
	ldr	w2, [x0, #:lo12:.LANCHOR30]
	mov	w0, 128
	mov	w3, 64
	cmp	w2, 25
	ubfx	x2, x24, 1, 7
	add	x2, x21, x2, lsl 2
	csel	w3, w3, w0, cc
	mov	w0, 0
.L764:
	add	w5, w3, w0
	cmp	x21, x2
	bne	.L765
	adrp	x0, .LANCHOR32
	ldr	w4, [x1, #:lo12:.LANCHOR30]
	lsr	w24, w24, 2
	mov	w2, 0
	ldr	w3, [x0, #:lo12:.LANCHOR32]
	mov	w22, 0
.L766:
	cmp	w2, w24
	bcs	.L762
	cbnz	w4, .L772
.L762:
	str	wzr, [x19, 16]
.L773:
	adrp	x0, .LANCHOR32
	ldr	w0, [x0, #:lo12:.LANCHOR32]
	cmp	w0, 5
	bls	.L759
	cbnz	w20, .L759
	ldr	w0, [x19]
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w0, w1
	cmp	w1, 139264
	bne	.L759
	orr	w0, w0, 131072
	mov	w22, -1
	str	w0, [x19]
.L759:
	mov	w0, w22
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L765:
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
	b	.L764
.L772:
	uxtw	x0, w2
	add	x0, x0, 8
	ldr	w0, [x19, x0, lsl 2]
	str	w0, [x29, 120]
	ldr	w0, [x29, 120]
	tbnz	x0, 2, .L788
	ldr	w0, [x29, 120]
	tbnz	x0, 15, .L788
	cmp	w3, 5
	bls	.L768
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
	bls	.L769
	ubfx	x1, x0, 3, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 27, 1
.L794:
	orr	w0, w1, w0, lsl 5
.L770:
	cmp	w22, w0
	csel	w22, w22, w0, cs
.L767:
	add	w2, w2, 1
	b	.L766
.L769:
	ubfx	x1, x0, 16, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 29, 1
	b	.L794
.L768:
	cmp	w3, 3
	bls	.L789
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
	bls	.L771
	ubfx	x1, x0, 3, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 28, 1
	b	.L794
.L771:
	ubfx	x1, x0, 16, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 30, 1
	b	.L794
.L789:
	mov	w0, 0
	b	.L770
.L788:
	mov	w22, -1
	b	.L767
.L785:
	mov	w22, 0
	b	.L762
.L760:
	cmp	w20, 1
	bne	.L774
	cmp	x4, 0
	mov	w23, 2
	csel	w23, w23, wzr, ne
	mov	w27, 0
	lsl	w23, w23, 1
	mov	w22, 0
.L775:
	cmp	w22, w24
	bcc	.L777
	mov	w22, 0
	b	.L773
.L777:
	and	w28, w22, 3
	cbz	x26, .L790
	lsl	w3, w22, 9
	add	x3, x26, x3
.L776:
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
	b	.L775
.L790:
	mov	x3, 0
	b	.L776
.L774:
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
.L778:
	cmp	w24, w23
	bls	.L773
	mov	w0, w25
	bl	NandcXferComp
	ldr	w0, [x19, 32]
	add	w27, w23, 2
	str	w0, [x29, 120]
	cmp	w24, w27
	bls	.L779
	mov	x5, 0
	mov	x4, 0
	and	w3, w27, 3
	mov	w2, 2
	mov	w1, 0
	mov	w0, w25
	bl	NandcXferStart
.L779:
	ldr	w0, [x29, 120]
	tbnz	x0, 2, .L791
	ldr	w0, [x29, 120]
	ubfx	x1, x0, 3, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 27, 1
	orr	w0, w1, w0, lsl 5
	cmp	w22, w0
	csel	w22, w22, w0, cs
.L780:
	and	w2, w23, 3
	cbz	x26, .L792
	lsl	w3, w23, 9
	add	x3, x26, x3
.L781:
	add	x4, x21, x28, uxtw
	mov	x0, x19
	mov	w1, 0
	bl	NandcCopy1KB
	ldr	w0, [x29, 108]
	mov	w23, w27
	add	w28, w28, w0
	b	.L778
.L791:
	mov	w22, -1
	b	.L780
.L792:
	mov	x3, 0
	b	.L781
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
	adrp	x1, .LANCHOR29+9
	mov	x22, x2
	mov	x23, x3
	ldrb	w20, [x1, #:lo12:.LANCHOR29+9]
	bne	.L796
	adrp	x0, .LANCHOR2
	adrp	x1, .LANCHOR3
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	ldr	w1, [x1, #:lo12:.LANCHOR3]
	mul	w0, w0, w1
	cmp	w0, w21
	mov	w0, 4
	csel	w20, w20, w0, ls
.L796:
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
	adrp	x0, .LANCHOR32
	ldr	w0, [x0, #:lo12:.LANCHOR32]
	cmp	w0, 8
	mov	w0, 12
	csel	w22, w22, w0, cc
	cbz	w4, .L812
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
	bne	.L801
.L810:
	mov	w21, -1
.L798:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L801:
	mov	w1, w25
	mov	w2, w21
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
	adrp	x1, .LANCHOR142
	ldr	w0, [x1, #:lo12:.LANCHOR142]
	add	w0, w0, 1
	cmp	w0, 2047
	bhi	.L803
	str	w0, [x1, #:lo12:.LANCHOR142]
	b	.L798
.L803:
	str	wzr, [x1, #:lo12:.LANCHOR142]
	mov	x28, 0
	mov	x23, 0
.L800:
	mov	w5, 0
	mov	w20, 0
	mov	w6, 0
	mov	w19, 0
	mov	w27, -1
.L808:
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
	bhi	.L804
	cmp	w0, 2
	bhi	.L814
	add	w19, w19, 1
	cmp	w19, 9
	bls	.L814
	mov	w1, w20
	mov	w21, w0
	sub	w20, w22, w19
	mov	w27, 0
.L806:
	cmp	w19, w6
	csel	w20, w20, w1, hi
.L807:
	cbz	w20, .L809
	mov	w1, w20
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
	mov	w0, w20
	bl	NandcSetDdrPara
.L809:
	cbz	w27, .L798
	adrp	x0, .LC9
	mov	w2, w25
	mov	w1, w24
	add	x0, x0, :lo12:.LC9
	bl	printf
	cbz	w26, .L810
	ldr	w1, [x29, 108]
	lsr	w0, w1, 8
	bl	NandcSetDdrPara
	b	.L798
.L812:
	mov	w21, 1024
	b	.L800
.L804:
	cmp	w19, w6
	bls	.L815
	sub	w20, w5, w19
	cmp	w19, 7
	bhi	.L807
	mov	w6, w19
.L815:
	mov	w19, 0
	b	.L805
.L814:
	mov	w5, w22
	mov	w21, w0
	mov	w27, 0
	mov	x28, 0
	mov	x23, 0
.L805:
	add	w22, w22, 2
	cmp	w22, 69
	bls	.L808
	mov	w1, w20
	mov	w20, w5
	b	.L806
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
	bne	.L825
	adrp	x24, .LANCHOR5
	ldrb	w25, [x24, #:lo12:.LANCHOR5]
	cbnz	w25, .L826
.L828:
	adrp	x0, .LANCHOR28
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cbz	w0, .L825
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
	beq	.L829
	adrp	x0, .LANCHOR31
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	cmp	w19, w0, lsr 1
	bls	.L825
.L829:
	lsr	w0, w24, 8
	bl	NandcSetDdrPara
	b	.L825
.L826:
	strb	wzr, [x24, #:lo12:.LANCHOR5]
	mov	x3, x23
	mov	x2, x22
	mov	w1, w21
	mov	w0, w20
	bl	FlashReadRawPage
	strb	w25, [x24, #:lo12:.LANCHOR5]
	cmn	w0, #1
	beq	.L828
	mov	w19, w0
.L825:
	adrp	x24, .LANCHOR143
	ldr	x4, [x24, #:lo12:.LANCHOR143]
	cbz	x4, .L824
	cmn	w19, #1
	bne	.L824
	mov	x3, x23
	mov	x2, x22
	mov	w1, w21
	mov	w0, w20
	blr	x4
	mov	w19, w0
	mov	w1, w0
	mov	w3, w21
	mov	w2, w20
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	printf
	cmn	w19, #1
	bne	.L824
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L824
	mov	w0, w20
	bl	flash_enter_slc_mode
	ldr	x4, [x24, #:lo12:.LANCHOR143]
	mov	x3, x23
	mov	x2, x22
	mov	w1, w21
	mov	w0, w20
	blr	x4
	mov	w19, w0
	mov	w0, w20
	bl	flash_exit_slc_mode
.L824:
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
	adrp	x20, .LANCHOR28
	bl	FlashReadRawPage
	cmn	w0, #1
	beq	.L845
	cmn	w22, #1
	bne	.L846
.L845:
	ldrb	w0, [x19, #:lo12:.LANCHOR24]
	tbz	x0, 0, .L846
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
	strb	wzr, [x20, #:lo12:.LANCHOR28]
.L847:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L846:
	mov	w0, 1
	strb	w0, [x20, #:lo12:.LANCHOR28]
	b	.L847
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
	adrp	x20, .LANCHOR29
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR145
	strb	w0, [x29, 120]
	mov	w0, 40
	strb	w0, [x29, 121]
	mov	w0, 24
	strb	w0, [x29, 122]
	mov	w0, 16
	strb	w0, [x29, 123]
	add	x0, x20, :lo12:.LANCHOR29
	stp	x23, x24, [sp, 48]
	adrp	x21, .LANCHOR144
	adrp	x24, .LANCHOR146
	stp	x25, x26, [sp, 64]
	ldrh	w0, [x0, 10]
	adrp	x26, .LANCHOR7
	str	w0, [x29, 108]
	mov	w19, 0
	ldr	x0, [x22, #:lo12:.LANCHOR145]
	mov	w25, 4
	str	x0, [x21, #:lo12:.LANCHOR144]
	mov	w23, -1
	stp	x27, x28, [sp, 80]
	add	x26, x26, :lo12:.LANCHOR7
	str	wzr, [x24, #:lo12:.LANCHOR146]
	mov	w0, 0
	bl	flash_enter_slc_mode
.L856:
	add	w28, w19, 1
	mov	x27, 0
.L858:
	add	x0, x29, 120
	ldrb	w0, [x0, x27]
	bl	FlashBchSel
	ldr	x2, [x22, #:lo12:.LANCHOR145]
	mov	x3, 0
	mov	w1, w19
	mov	w0, 0
	bl	FlashReadRawPage
	cmn	w0, #1
	bne	.L857
	ldr	x2, [x22, #:lo12:.LANCHOR145]
	mov	x3, 0
	mov	w1, w28
	mov	w0, 0
	bl	FlashReadRawPage
	cmn	w0, #1
	bne	.L857
	add	x27, x27, 1
	cmp	x27, 4
	bne	.L858
.L859:
	ldr	w0, [x29, 108]
	subs	w25, w25, #1
	add	w19, w19, w0
	bne	.L856
	b	.L864
.L860:
	mov	w1, 2036
	add	x0, x6, 12
	bl	JSHash
	ldr	w1, [x6, 8]
	cmp	w1, w0
	bne	.L866
	add	x23, x20, :lo12:.LANCHOR29
	add	x1, x6, 160
	mov	w2, 32
	mov	x0, x23
	bl	ftl_memcpy
	ldr	x1, [x21, #:lo12:.LANCHOR144]
	mov	w2, 32
	mov	x0, x26
	add	x1, x1, 192
	bl	ftl_memcpy
	ldr	x1, [x21, #:lo12:.LANCHOR144]
	mov	w2, 852
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	add	x1, x1, 224
	bl	ftl_memcpy
	ldr	x1, [x21, #:lo12:.LANCHOR144]
	adrp	x0, .LANCHOR28
	str	w19, [x24, #:lo12:.LANCHOR146]
	ldr	w2, [x1, 1076]
	strb	w2, [x0, #:lo12:.LANCHOR28]
	ldrh	w0, [x23, 10]
	adrp	x2, .LANCHOR147
	udiv	w0, w19, w0
	add	w3, w0, 1
	cbz	w0, .L862
	str	w3, [x2, #:lo12:.LANCHOR147]
.L863:
	adrp	x0, .LANCHOR148
	ldrh	w1, [x1, 14]
	mov	w23, 0
	strb	w1, [x0, #:lo12:.LANCHOR148]
	b	.L859
.L862:
	mov	w0, 2
	str	w0, [x2, #:lo12:.LANCHOR147]
	b	.L863
.L866:
	mov	w23, -1
	b	.L859
.L857:
	ldr	x6, [x21, #:lo12:.LANCHOR144]
	mov	w1, 20036
	movk	w1, 0x4e41, lsl 16
	ldr	w0, [x6]
	cmp	w0, w1
	bne	.L859
	cbnz	w23, .L860
	add	x20, x20, :lo12:.LANCHOR29
	ldrh	w0, [x20, 10]
	udiv	w19, w19, w0
	adrp	x0, .LANCHOR147
	add	w19, w19, 1
	str	w19, [x0, #:lo12:.LANCHOR147]
.L864:
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
	bls	.L886
	adrp	x0, .LANCHOR28
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cbz	w0, .L887
	mov	w23, 1
	mov	w0, 0
	bl	NandcSetDdrMode
.L871:
	add	x0, x22, x27, lsl 8
	mov	w1, 92
	str	w1, [x0, 2056]
	mov	w1, 197
	str	w1, [x0, 2056]
.L870:
	ldrsw	x0, [x29, 124]
	mov	w20, 1
	mov	w24, -1
	add	x0, x0, 8
	add	x0, x22, x0, lsl 8
	str	x0, [x29, 104]
.L872:
	adrp	x0, .LANCHOR149
	ldrb	w0, [x0, #:lo12:.LANCHOR149]
	add	w0, w0, 1
	cmp	w20, w0
	bcc	.L881
	mov	w28, w24
.L880:
	ldr	x0, [x29, 112]
	mov	w1, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x19
	bhi	.L882
	bl	SandiskSetRRPara
.L883:
	ldrsw	x0, [x29, 124]
	add	x0, x0, 8
	add	x22, x22, x0, lsl 8
	mov	w0, 255
	str	w0, [x22, 8]
	adrp	x0, .LANCHOR31
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L884
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L884:
	mov	w0, w21
	bl	NandcWaitFlashReady
	cbz	w23, .L869
	mov	w0, 4
	bl	NandcSetDdrMode
.L869:
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L887:
	mov	w23, 0
	b	.L871
.L886:
	mov	w23, 0
	b	.L870
.L881:
	ldr	x0, [x29, 112]
	mov	w1, w20
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x19
	bhi	.L873
	bl	SandiskSetRRPara
.L874:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, #:lo12:.LANCHOR11]
	cmp	w0, 34
	bne	.L875
	adrp	x0, .LANCHOR149
	ldrb	w0, [x0, #:lo12:.LANCHOR149]
	sub	w0, w0, #3
	cmp	w20, w0
	bne	.L875
	ldr	x1, [x29, 104]
	mov	w0, 179
	str	w0, [x1, 8]
.L875:
	add	x0, x22, x27, lsl 8
	mov	w1, 38
	str	w1, [x0, 2056]
	mov	w1, 93
	str	w1, [x0, 2056]
	cbz	w23, .L876
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
.L877:
	cmn	w28, #1
	beq	.L878
	adrp	x0, .LANCHOR31
	cmn	w24, #1
	csel	w24, w24, w28, ne
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L880
	mov	x26, 0
	mov	x25, 0
.L878:
	add	w20, w20, 1
	b	.L872
.L873:
	bl	ToshibaSetRRPara
	b	.L874
.L876:
	ldr	w1, [x29, 120]
	mov	x3, x26
	mov	x2, x25
	mov	w0, w21
	bl	FlashReadRawPage
	mov	w28, w0
	b	.L877
.L882:
	bl	ToshibaSetRRPara
	b	.L883
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
	adrp	x26, .LANCHOR149
	sbfiz	x1, x22, 4, 32
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	adrp	x27, .LANCHOR31
	add	x2, x0, x1
	add	x26, x26, :lo12:.LANCHOR149
	add	x27, x27, :lo12:.LANCHOR31
	mov	w21, 1
	ldr	x0, [x0, x1]
	mov	w19, -1
	ldrb	w20, [x2, 8]
	add	x20, x20, 8
	add	x20, x0, x20, lsl 8
.L898:
	ldrb	w0, [x26]
	add	w0, w0, 1
	cmp	w21, w0
	bcc	.L902
.L901:
	mov	x0, x20
	mov	w1, 0
	bl	SamsungSetRRPara
	adrp	x0, .LANCHOR31
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L897
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L897:
	mov	w0, w19
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L902:
	mov	w1, w21
	mov	x0, x20
	bl	SamsungSetRRPara
	mov	x3, x25
	mov	x2, x24
	mov	w1, w23
	mov	w0, w22
	bl	FlashReadRawPage
	cmn	w0, #1
	beq	.L899
	ldrb	w1, [x27]
	cmn	w19, #1
	csel	w19, w19, w0, ne
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L904
	mov	x25, 0
	mov	x24, 0
.L899:
	add	w21, w21, 1
	b	.L898
.L904:
	mov	w19, w0
	b	.L901
	.size	SamsungReadRetrial, .-SamsungReadRetrial
	.section	.text.MicronReadRetrial,"ax",@progbits
	.align	2
	.global	MicronReadRetrial
	.type	MicronReadRetrial, %function
MicronReadRetrial:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w23, w0, 255
	adrp	x0, .LANCHOR31
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	mov	w24, w1
	ldrb	w20, [x0, #:lo12:.LANCHOR31]
	adrp	x0, .LANCHOR8
	stp	x21, x22, [sp, 32]
	mov	x25, x2
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	mov	x26, x3
	stp	x27, x28, [sp, 80]
	cbnz	w0, .L912
	add	w20, w20, w20, lsl 1
	asr	w20, w20, 2
.L913:
	mov	w0, w23
	bl	NandcWaitFlashReady
	sbfiz	x1, x23, 4, 32
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
	adrp	x28, .LANCHOR149
	add	x2, x0, x1
	add	x28, x28, :lo12:.LANCHOR149
	mov	w27, 0
	mov	w19, -1
	ldr	x4, [x0, x1]
	mov	w6, 239
	ldrb	w21, [x2, 8]
	mov	w7, 137
	add	x22, x4, x21, lsl 8
.L914:
	ldrb	w0, [x28]
	cmp	w27, w0
	bcc	.L918
.L917:
	add	x21, x4, x21, lsl 8
	mov	w0, 239
	str	w0, [x21, 2056]
	mov	w0, 137
	str	w0, [x21, 2052]
	mov	x0, 200
	bl	udelay
	str	wzr, [x21, 2048]
	str	wzr, [x21, 2048]
	cmp	w19, w20
	str	wzr, [x21, 2048]
	str	wzr, [x21, 2048]
	bcc	.L919
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L919:
	cmp	w19, 256
	ccmn	w19, #1, 4, ne
	bne	.L911
	adrp	x0, .LC11
	mov	w4, w19
	mov	w3, w27
	mov	w2, w24
	mov	w1, w27
	add	x0, x0, :lo12:.LC11
	bl	printf
.L911:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L912:
	mov	w0, 3
	sdiv	w20, w20, w0
	b	.L913
.L918:
	str	w6, [x22, 2056]
	mov	x0, 200
	str	w7, [x22, 2052]
	str	x4, [x29, 104]
	stp	w6, w7, [x29, 116]
	bl	udelay
	add	w5, w27, 1
	str	w5, [x22, 2048]
	str	wzr, [x22, 2048]
	mov	x3, x26
	str	wzr, [x22, 2048]
	mov	x2, x25
	str	wzr, [x22, 2048]
	mov	w1, w24
	str	w5, [x29, 124]
	mov	w0, w23
	bl	FlashReadRawPage
	cmn	w0, #1
	ldp	w6, w7, [x29, 116]
	ldr	w5, [x29, 124]
	ldr	x4, [x29, 104]
	beq	.L915
	cmn	w19, #1
	csel	w19, w19, w0, ne
	cmp	w0, w20
	bcc	.L921
	mov	x26, 0
	mov	x25, 0
.L915:
	mov	w27, w5
	b	.L914
.L921:
	mov	w19, w0
	b	.L917
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
	bne	.L932
	ldrb	w20, [x0, 20]
.L932:
	mov	w0, w23
	bl	NandcWaitFlashReady
	add	x6, x19, :lo12:.LANCHOR20
	adrp	x5, .LANCHOR31
	add	x7, x6, 4
	add	x5, x5, :lo12:.LANCHOR31
	mov	w4, 0
	mov	w21, -1
.L933:
	cmp	w4, w24
	bcc	.L938
.L937:
	ldr	x0, [x22, #:lo12:.LANCHOR18]
	add	x19, x19, :lo12:.LANCHOR20
	add	x19, x19, x28
	ldrb	w0, [x0, 19]
	cmp	w0, 7
	bne	.L939
	strb	w20, [x19, 20]
.L940:
	adrp	x0, .LANCHOR31
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	add	w0, w0, w0, lsl 1
	cmp	w21, w0, lsr 2
	bcc	.L931
	cmn	w21, #1
	mov	w0, 256
	csel	w21, w21, w0, eq
.L931:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L938:
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
	beq	.L935
	ldrb	w1, [x5]
	cmn	w21, #1
	csel	w21, w21, w0, ne
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L942
	mov	x27, 0
	mov	x26, 0
.L935:
	add	w4, w4, 1
	b	.L933
.L942:
	mov	w21, w0
	b	.L937
.L939:
	strb	w20, [x19, 12]
	b	.L940
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
	adrp	x1, .LANCHOR29+9
	str	x23, [sp, 48]
	mov	x22, x2
	ldrb	w21, [x1, #:lo12:.LANCHOR29+9]
	ands	w19, w0, 255
	mov	x23, x3
	bne	.L950
	adrp	x0, .LANCHOR2
	adrp	x1, .LANCHOR3
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	ldr	w1, [x1, #:lo12:.LANCHOR3]
	mul	w0, w0, w1
	cmp	w0, w20
	bls	.L950
	adrp	x0, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR1]
	cbnz	w0, .L951
	sub	w21, w21, #2
.L950:
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
.L951:
	mov	w21, 4
	b	.L950
	.size	FlashProgPage, .-FlashProgPage
	.section	.text.FlashSavePhyInfo,"ax",@progbits
	.align	2
	.global	FlashSavePhyInfo
	.type	FlashSavePhyInfo, %function
FlashSavePhyInfo:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR145
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR144
	ldr	x0, [x22, #:lo12:.LANCHOR145]
	adrp	x21, .LANCHOR3
	str	x0, [x19, #:lo12:.LANCHOR144]
	mov	w20, 0
	adrp	x0, .LANCHOR150
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	mov	w25, 20036
	ldrb	w0, [x0, #:lo12:.LANCHOR150]
	movk	w25, 0x4e41, lsl 16
	adrp	x24, .LANCHOR151
	adrp	x26, .LANCHOR147
	mov	w23, 0
	add	x21, x21, :lo12:.LANCHOR3
	add	x26, x26, :lo12:.LANCHOR147
	bl	FlashBchSel
	ldr	x0, [x22, #:lo12:.LANCHOR145]
	mov	w2, 2048
	mov	w1, 0
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR144]
	adrp	x1, .LANCHOR25
	mov	w2, 32
	add	x0, x0, 16
	str	w25, [x0, -16]
	ldrb	w1, [x1, #:lo12:.LANCHOR25]
	strh	w1, [x0, -4]
	adrp	x1, .LANCHOR2
	ldrb	w1, [x1, #:lo12:.LANCHOR2]
	strh	w1, [x0, -2]
	adrp	x1, .LANCHOR28
	ldrb	w1, [x1, #:lo12:.LANCHOR28]
	str	w1, [x0, 1060]
	adrp	x1, .LANCHOR22
	add	x1, x1, :lo12:.LANCHOR22
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR144]
	mov	w2, 8
	adrp	x1, .LANCHOR26
	add	x1, x1, :lo12:.LANCHOR26
	add	x0, x0, 80
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR144]
	mov	w2, 32
	adrp	x1, .LANCHOR17
	add	x1, x1, :lo12:.LANCHOR17
	add	x0, x0, 96
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR144]
	mov	w2, 32
	adrp	x1, .LANCHOR29
	add	x1, x1, :lo12:.LANCHOR29
	add	x0, x0, 160
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR144]
	mov	w2, 32
	adrp	x1, .LANCHOR7
	add	x1, x1, :lo12:.LANCHOR7
	add	x0, x0, 192
	bl	ftl_memcpy
	ldr	x0, [x19, #:lo12:.LANCHOR144]
	mov	w2, 852
	adrp	x1, .LANCHOR20
	add	x1, x1, :lo12:.LANCHOR20
	add	x0, x0, 224
	bl	ftl_memcpy
	ldr	x6, [x19, #:lo12:.LANCHOR144]
	mov	w1, 2036
	add	x0, x6, 12
	bl	JSHash
	str	w0, [x6, 8]
	mov	w0, 1592
	str	w0, [x6, 4]
	ldr	x0, [x24, #:lo12:.LANCHOR151]
	str	x0, [x19, #:lo12:.LANCHOR144]
	mov	w0, 0
	bl	flash_enter_slc_mode
.L956:
	ldr	w1, [x21]
	mov	w2, 0
	mov	w0, 0
	mul	w1, w20, w1
	bl	FlashEraseBlock
	ldr	w1, [x21]
	mov	x3, 0
	ldr	x2, [x22, #:lo12:.LANCHOR145]
	mov	w0, 0
	mul	w1, w20, w1
	bl	FlashProgPage
	ldr	w1, [x21]
	mov	x3, 0
	ldr	x2, [x22, #:lo12:.LANCHOR145]
	mov	w0, 0
	mul	w1, w20, w1
	add	w1, w1, 1
	bl	FlashProgPage
	ldr	w1, [x21]
	mov	x3, 0
	ldr	x2, [x24, #:lo12:.LANCHOR151]
	mov	w0, 0
	mul	w1, w20, w1
	bl	FlashReadRawPage
	cmn	w0, #1
	add	w7, w20, 1
	beq	.L954
	ldr	x6, [x19, #:lo12:.LANCHOR144]
	ldr	w0, [x6]
	cmp	w0, w25
	bne	.L954
	mov	w1, 2036
	add	x0, x6, 12
	bl	JSHash
	ldr	w1, [x6, 8]
	cmp	w1, w0
	bne	.L954
	ldr	w0, [x21]
	cmp	w23, 1
	str	w7, [x26]
	mul	w20, w0, w20
	adrp	x0, .LANCHOR146
	str	w20, [x0, #:lo12:.LANCHOR146]
	beq	.L957
	mov	w23, 1
.L954:
	mov	w20, w7
	cmp	w7, 4
	bne	.L956
.L955:
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
.L957:
	mov	w23, 2
	b	.L955
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
	adrp	x0, .LANCHOR31
	stp	x19, x20, [sp, 16]
	ldrb	w26, [x0, #:lo12:.LANCHOR31]
	adrp	x0, .LANCHOR152
	stp	x21, x22, [sp, 32]
	ldr	w2, [x0, #:lo12:.LANCHOR152]
	stp	x27, x28, [sp, 80]
	str	x0, [x29, 120]
	cmp	w2, w1
	bne	.L964
	mov	w0, 0
	bl	flash_enter_slc_mode
.L964:
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
.L965:
	ldrb	w0, [x24, #:lo12:.LANCHOR2]
	cmp	w19, w0
	bcc	.L970
.L969:
	mov	w0, w26
	bl	FlashBchSel
	ldr	x0, [x29, 120]
	ldr	w1, [x0, #:lo12:.LANCHOR152]
	mov	w0, 12336
	movk	w0, 0x5638, lsl 16
	cmp	w1, w0
	bne	.L963
	mov	w0, 0
	bl	flash_exit_slc_mode
.L963:
	mov	w0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L970:
	mov	x4, 0
	adrp	x25, .LANCHOR145
.L967:
	ldrb	w5, [x4, x27]
	add	x21, x25, :lo12:.LANCHOR145
	str	w5, [x29, 116]
	mov	w0, w5
	str	x4, [x29, 104]
	bl	FlashBchSel
	ldr	w1, [x22]
	mov	x3, 0
	ldr	x2, [x25, #:lo12:.LANCHOR145]
	mov	w0, 0
	mul	w1, w19, w1
	bl	FlashReadRawPage
	cmn	w0, #1
	ldr	w5, [x29, 116]
	bne	.L966
	ldr	x4, [x29, 104]
	add	x4, x4, 1
	cmp	x4, 4
	bne	.L967
.L968:
	add	w19, w19, 1
	b	.L965
.L973:
	mov	w20, 0
	b	.L969
.L966:
	ldr	x0, [x21]
	ldr	w1, [x0]
	mov	w0, 35899
	movk	w0, 0xfcdc, lsl 16
	cmp	w1, w0
	bne	.L968
	mov	w1, w5
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	bl	printf
	ldr	x1, [x21]
	mov	w2, 2048
	mov	x0, x23
	bl	ftl_memcpy
	ldr	x0, [x21]
	ldr	w0, [x0, 512]
	strb	w0, [x28]
	adrp	x0, .LANCHOR147
	ldr	w1, [x0, #:lo12:.LANCHOR147]
	cmp	w19, w1
	bcs	.L973
	str	w19, [x0, #:lo12:.LANCHOR147]
	mov	w20, 0
	bl	FlashSavePhyInfo
	b	.L968
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
	cbz	w3, .L977
	adrp	x2, .LANCHOR152
	ldr	w3, [x2, #:lo12:.LANCHOR152]
	mov	w2, 12336
	movk	w2, 0x5638, lsl 16
	cmp	w3, w2
	beq	.L976
.L977:
	sub	w0, w0, #5
	and	w0, w0, 255
	cmp	w0, 63
	bhi	.L976
	mov	x2, 16391
	movk	x2, 0x4000, lsl 16
	movk	x2, 0x8000, lsl 48
	lsr	x0, x2, x0
	tbz	x0, 0, .L976
	adrp	x20, .LANCHOR117
	mov	w24, w1
	add	x20, x20, :lo12:.LANCHOR117
	mov	w23, 65535
	adrp	x25, .LANCHOR151
.L979:
	ldr	x0, [x22, #:lo12:.LANCHOR18]
	ldrh	w0, [x0, 10]
	cmp	w0, w19
	bhi	.L980
.L976:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L980:
	ldrh	w0, [x20, w19, sxtw 1]
	cmp	w0, w23
	bne	.L976
	ldr	x0, [x25, #:lo12:.LANCHOR151]
	mov	w2, 32768
	mov	w1, 255
	bl	ftl_memset
	ldr	x2, [x25, #:lo12:.LANCHOR151]
	add	w1, w19, w24
	add	w19, w19, 1
	mov	x3, 0
	mov	w0, w21
	and	w19, w19, 65535
	bl	FlashProgPage
	b	.L979
	.size	FlashPageProgMsbFFData, .-FlashPageProgMsbFFData
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
	add	x29, sp, 0
	str	x0, [x2, #:lo12:.LANCHOR6]
	mov	w2, 1
	str	w2, [x1, 24]
	mov	w2, 2
	str	x0, [x1, 16]
	str	x0, [x1, 32]
	str	x0, [x1, 48]
	str	w2, [x1, 40]
	mov	w2, 3
	str	wzr, [x1, 8]
	str	w2, [x1, 56]
	adrp	x1, .LANCHOR19
	adrp	x2, .LANCHOR153
	str	x0, [x1, #:lo12:.LANCHOR19]
	ldr	w1, [x0]
	ubfx	x3, x1, 13, 1
	str	w3, [x2, #:lo12:.LANCHOR153]
	ldr	w2, [x0, 352]
	adrp	x3, .LANCHOR32
	and	w1, w1, 245760
	orr	w1, w1, 256
	ubfx	x2, x2, 16, 4
	str	w2, [x3, #:lo12:.LANCHOR32]
	adrp	x2, .LANCHOR152
	ldr	w3, [x0, 352]
	str	w3, [x2, #:lo12:.LANCHOR152]
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
	adrp	x1, .LANCHOR154
	adrp	x2, .LANCHOR33
	str	x0, [x1, #:lo12:.LANCHOR154]
	add	x1, x2, :lo12:.LANCHOR33
	str	x0, [x2, #:lo12:.LANCHOR33]
	add	x0, x0, 32768
	str	wzr, [x1, 40]
	str	x0, [x1, 8]
	adrp	x0, .LANCHOR34
	ldp	x29, x30, [sp], 16
	str	wzr, [x0, #:lo12:.LANCHOR34]
	ret
	.size	NandcInit, .-NandcInit
	.section	.text.FtlMemInit,"ax",@progbits
	.align	2
	.global	FtlMemInit
	.type	FtlMemInit, %function
FtlMemInit:
	stp	x29, x30, [sp, -64]!
	adrp	x0, .LANCHOR137
	mov	w1, 65535
	add	x29, sp, 0
	strh	wzr, [x0, #:lo12:.LANCHOR137]
	adrp	x0, .LANCHOR155
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR53
	str	wzr, [x0, #:lo12:.LANCHOR155]
	adrp	x0, .LANCHOR156
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR36
	str	wzr, [x0, #:lo12:.LANCHOR156]
	adrp	x0, .LANCHOR157
	str	x23, [sp, 48]
	adrp	x21, .LANCHOR56
	str	wzr, [x0, #:lo12:.LANCHOR157]
	adrp	x0, .LANCHOR158
	adrp	x23, .LANCHOR57
	str	wzr, [x0, #:lo12:.LANCHOR158]
	adrp	x0, .LANCHOR159
	str	wzr, [x0, #:lo12:.LANCHOR159]
	adrp	x0, .LANCHOR160
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
	adrp	x0, .LANCHOR78
	str	wzr, [x0, #:lo12:.LANCHOR78]
	adrp	x0, .LANCHOR167
	str	wzr, [x0, #:lo12:.LANCHOR167]
	adrp	x0, .LANCHOR168
	str	wzr, [x0, #:lo12:.LANCHOR168]
	adrp	x0, .LANCHOR169
	str	wzr, [x0, #:lo12:.LANCHOR169]
	adrp	x0, .LANCHOR170
	str	wzr, [x0, #:lo12:.LANCHOR170]
	adrp	x0, .LANCHOR171
	str	w1, [x0, #:lo12:.LANCHOR171]
	adrp	x0, .LANCHOR172
	adrp	x1, .LANCHOR112
	str	wzr, [x0, #:lo12:.LANCHOR172]
	adrp	x0, .LANCHOR173
	str	wzr, [x0, #:lo12:.LANCHOR173]
	adrp	x0, .LANCHOR72
	str	wzr, [x0, #:lo12:.LANCHOR72]
	mov	w0, -1
	strh	w0, [x1, #:lo12:.LANCHOR112]
	adrp	x1, .LANCHOR113
	strh	w0, [x1, #:lo12:.LANCHOR113]
	adrp	x0, .LANCHOR174
	mov	w1, 32
	strh	w1, [x0, #:lo12:.LANCHOR174]
	adrp	x0, .LANCHOR175
	mov	w1, 128
	strh	w1, [x0, #:lo12:.LANCHOR175]
	adrp	x0, .LANCHOR176
	strh	wzr, [x0, #:lo12:.LANCHOR176]
	adrp	x0, .LANCHOR114
	strh	wzr, [x0, #:lo12:.LANCHOR114]
	adrp	x0, .LANCHOR177
	strh	wzr, [x0, #:lo12:.LANCHOR177]
	adrp	x0, .LANCHOR116
	strh	wzr, [x0, #:lo12:.LANCHOR116]
	ldrh	w0, [x19, #:lo12:.LANCHOR53]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR109
	str	x0, [x1, #:lo12:.LANCHOR109]
	mov	w0, 12
	ldrh	w1, [x19, #:lo12:.LANCHOR53]
	mul	w0, w1, w0
	bl	ftl_malloc
	ldrh	w19, [x22, #:lo12:.LANCHOR36]
	adrp	x1, .LANCHOR111
	str	x0, [x1, #:lo12:.LANCHOR111]
	mov	w0, 56
	mul	w19, w19, w0
	lsl	w20, w19, 2
	mov	w0, w20
	bl	ftl_malloc
	adrp	x1, .LANCHOR178
	str	x0, [x1, #:lo12:.LANCHOR178]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR179
	str	x0, [x1, #:lo12:.LANCHOR179]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x20, .LANCHOR107
	adrp	x1, .LANCHOR180
	str	x0, [x1, #:lo12:.LANCHOR180]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR76
	str	x0, [x1, #:lo12:.LANCHOR76]
	mov	w0, w19
	bl	ftl_malloc
	ldrh	w19, [x21, #:lo12:.LANCHOR56]
	adrp	x1, .LANCHOR106
	str	x0, [x1, #:lo12:.LANCHOR106]
	ldrh	w0, [x22, #:lo12:.LANCHOR36]
	lsl	w0, w0, 1
	add	w0, w0, 1
	str	w0, [x20, #:lo12:.LANCHOR107]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR79
	str	x0, [x1, #:lo12:.LANCHOR79]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR181
	str	x0, [x1, #:lo12:.LANCHOR181]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR182
	str	x0, [x1, #:lo12:.LANCHOR182]
	ldr	w0, [x20, #:lo12:.LANCHOR107]
	mul	w0, w19, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR104
	str	x0, [x1, #:lo12:.LANCHOR104]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR183
	str	x0, [x1, #:lo12:.LANCHOR183]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR184
	str	x0, [x1, #:lo12:.LANCHOR184]
	mov	w0, 24
	ldr	w1, [x20, #:lo12:.LANCHOR107]
	mul	w0, w1, w0
	bl	ftl_malloc
	ldrh	w19, [x23, #:lo12:.LANCHOR57]
	adrp	x1, .LANCHOR103
	str	x0, [x1, #:lo12:.LANCHOR103]
	ldrh	w0, [x22, #:lo12:.LANCHOR36]
	adrp	x22, .LANCHOR63
	mul	w19, w19, w0
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR185
	str	x0, [x1, #:lo12:.LANCHOR185]
	lsl	w0, w19, 2
	bl	ftl_malloc
	adrp	x19, .LANCHOR39
	adrp	x1, .LANCHOR186
	str	x0, [x1, #:lo12:.LANCHOR186]
	ldrh	w1, [x23, #:lo12:.LANCHOR57]
	ldr	w0, [x20, #:lo12:.LANCHOR107]
	adrp	x20, .LANCHOR187
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR105
	str	x0, [x1, #:lo12:.LANCHOR105]
	ldrh	w0, [x19, #:lo12:.LANCHOR39]
	ubfiz	w0, w0, 1, 15
	strh	w0, [x20, #:lo12:.LANCHOR187]
	and	w0, w0, 65534
	bl	ftl_malloc
	adrp	x1, .LANCHOR134
	str	x0, [x1, #:lo12:.LANCHOR134]
	ldrh	w0, [x20, #:lo12:.LANCHOR187]
	add	x0, x0, 547
	lsr	x0, x0, 9
	strh	w0, [x20, #:lo12:.LANCHOR187]
	lsl	w0, w0, 9
	bl	ftl_malloc
	adrp	x1, .LANCHOR188
	str	x0, [x1, #:lo12:.LANCHOR188]
	adrp	x1, .LANCHOR77
	add	x0, x0, 32
	str	x0, [x1, #:lo12:.LANCHOR77]
	ldrh	w0, [x19, #:lo12:.LANCHOR39]
	lsl	w0, w0, 1
	bl	ftl_malloc
	ldr	w20, [x22, #:lo12:.LANCHOR63]
	adrp	x1, .LANCHOR82
	str	x0, [x1, #:lo12:.LANCHOR82]
	lsl	w20, w20, 1
	mov	w0, w20
	bl	ftl_malloc
	adrp	x1, .LANCHOR126
	str	x0, [x1, #:lo12:.LANCHOR126]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x20, .LANCHOR60
	adrp	x1, .LANCHOR122
	str	x0, [x1, #:lo12:.LANCHOR122]
	ldrh	w0, [x19, #:lo12:.LANCHOR39]
	lsr	w0, w0, 3
	add	w0, w0, 4
	bl	ftl_malloc
	adrp	x1, .LANCHOR0
	str	x0, [x1, #:lo12:.LANCHOR0]
	ldrh	w0, [x20, #:lo12:.LANCHOR60]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR70
	str	x0, [x1, #:lo12:.LANCHOR70]
	ldrh	w0, [x20, #:lo12:.LANCHOR60]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR189
	str	x0, [x1, #:lo12:.LANCHOR189]
	ldrh	w0, [x20, #:lo12:.LANCHOR60]
	adrp	x20, .LANCHOR61
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR190
	str	x0, [x1, #:lo12:.LANCHOR190]
	ldrh	w0, [x20, #:lo12:.LANCHOR61]
	lsl	w0, w0, 2
	bl	ftl_malloc
	ldrh	w2, [x20, #:lo12:.LANCHOR61]
	adrp	x1, .LANCHOR191
	str	x0, [x1, #:lo12:.LANCHOR191]
	mov	w1, 0
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR65
	ldrh	w20, [x0, #:lo12:.LANCHOR65]
	lsl	w20, w20, 2
	mov	w0, w20
	bl	ftl_malloc
	adrp	x1, .LANCHOR128
	str	x0, [x1, #:lo12:.LANCHOR128]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x20, .LANCHOR66
	adrp	x1, .LANCHOR192
	str	x0, [x1, #:lo12:.LANCHOR192]
	ldr	w0, [x22, #:lo12:.LANCHOR63]
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR127
	str	x0, [x1, #:lo12:.LANCHOR127]
	ldrh	w0, [x20, #:lo12:.LANCHOR66]
	lsl	w0, w0, 4
	bl	ftl_malloc
	adrp	x1, .LANCHOR95
	str	x0, [x1, #:lo12:.LANCHOR95]
	ldrh	w1, [x20, #:lo12:.LANCHOR66]
	adrp	x20, .LANCHOR43
	ldrh	w0, [x21, #:lo12:.LANCHOR56]
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR123
	str	x0, [x1, #:lo12:.LANCHOR123]
	mov	w0, 6
	ldrh	w1, [x19, #:lo12:.LANCHOR39]
	adrp	x19, .LANCHOR120
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR80
	str	x0, [x1, #:lo12:.LANCHOR80]
	adrp	x0, .LANCHOR49
	ldrh	w1, [x20, #:lo12:.LANCHOR43]
	ldrh	w0, [x0, #:lo12:.LANCHOR49]
	add	w0, w0, 31
	asr	w0, w0, 5
	strh	w0, [x19, #:lo12:.LANCHOR120]
	mul	w0, w1, w0
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR73
	ldrh	w5, [x19, #:lo12:.LANCHOR120]
	add	x2, x1, :lo12:.LANCHOR73
	ldrh	w7, [x20, #:lo12:.LANCHOR43]
	add	x6, x2, 40
	mov	w3, w5
	str	x0, [x2, 32]
	mov	x0, 1
.L991:
	cmp	w0, w7
	bcc	.L992
	mov	w2, 8
	sub	w2, w2, w0
	add	x2, x2, 1
	add	x1, x1, :lo12:.LANCHOR73
	mov	x3, 0
.L993:
	add	x3, x3, 1
	cmp	x2, x3
	bne	.L994
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L992:
	ldr	x4, [x2, 32]
	add	w0, w0, 1
	add	x4, x4, x3, uxtw 2
	add	w3, w3, w5
	str	x4, [x6], 8
	b	.L991
.L994:
	add	x4, x0, x3
	add	x4, x1, x4, lsl 3
	str	xzr, [x4, 24]
	b	.L993
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
	adrp	x0, .LANCHOR67
	ldr	w0, [x0, #:lo12:.LANCHOR67]
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
	adrp	x21, .LC14
	stp	x23, x24, [sp, 48]
	mov	x22, x1
	stp	x25, x26, [sp, 64]
	adrp	x23, .LC13
	mov	x26, x0
	mov	w24, w2
	uxtw	x25, w3
	add	x23, x23, :lo12:.LC13
	add	x21, x21, :lo12:.LC14
	stp	x19, x20, [sp, 16]
	str	x27, [sp, 80]
	mov	x19, 0
	mov	w20, 0
	adrp	x27, .LC15
.L1004:
	cmp	x25, x19
	bne	.L1010
	ldp	x19, x20, [sp, 16]
	adrp	x1, .LC15
	ldp	x21, x22, [sp, 32]
	add	x1, x1, :lo12:.LC15
	ldp	x23, x24, [sp, 48]
	adrp	x0, .LC6
	ldp	x25, x26, [sp, 64]
	add	x0, x0, :lo12:.LC6
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	b	printf
.L1010:
	cbnz	w20, .L1005
	mov	w2, w19
	mov	x1, x26
	mov	x0, x23
	bl	printf
.L1005:
	cmp	w24, 4
	bne	.L1006
	ldr	w1, [x22, x19, lsl 2]
.L1012:
	mov	x0, x21
	add	w20, w20, 1
	bl	printf
	cmp	w20, 15
	bls	.L1009
	mov	w20, 0
	add	x1, x27, :lo12:.LC15
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1009:
	add	x19, x19, 1
	b	.L1004
.L1006:
	cmp	w24, 2
	bne	.L1008
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L1012
.L1008:
	ldrb	w1, [x22, x19]
	b	.L1012
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
	bne	.L1014
	mov	w1, -89
	strb	w1, [x0, 4]
	adrp	x0, .LANCHOR193+17
	mov	w1, -9
	strb	w1, [x0, #:lo12:.LANCHOR193+17]
.L1070:
	mov	w27, 7
	b	.L1105
.L1014:
	cmp	w26, 3
	bne	.L1016
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
.L1106:
	mov	w27, 8
	mov	w28, w27
	strb	w1, [x0, 11]
.L1015:
	sub	w0, w26, #1
	cmp	w0, 1
	bhi	.L1020
	adrp	x26, .LANCHOR25
	adrp	x0, .LANCHOR26
	adrp	x25, .LANCHOR6
	add	x26, x26, :lo12:.LANCHOR25
	add	x4, x0, :lo12:.LANCHOR26
	add	x25, x25, :lo12:.LANCHOR6
	mov	w24, 0
.L1021:
	ldrb	w0, [x26]
	cmp	w0, w24
	bhi	.L1027
.L1028:
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
.L1016:
	cmp	w26, 4
	bne	.L1017
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
	b	.L1106
.L1017:
	cmp	w26, 5
	bne	.L1018
	mov	w1, 56
	strb	w1, [x0, 4]
	mov	w1, 57
	strb	w1, [x0, 5]
	mov	w1, 58
	mov	w27, 8
	strb	w1, [x0, 6]
	mov	w1, 59
	strb	w1, [x0, 7]
.L1105:
	mov	w28, 4
	b	.L1015
.L1018:
	cmp	w26, 6
	bne	.L1019
	mov	w1, 14
	strb	w1, [x0, 4]
	mov	w1, 15
	strb	w1, [x0, 5]
	mov	w1, 16
	mov	w27, 12
	strb	w1, [x0, 6]
	mov	w1, 17
	strb	w1, [x0, 7]
	b	.L1105
.L1019:
	cmp	w26, 7
	bne	.L1070
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
	b	.L1015
.L1027:
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
.L1022:
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
	bhi	.L1022
	adrp	x2, .LANCHOR193
	add	x2, x2, :lo12:.LANCHOR193
	mov	x0, 0
.L1025:
	add	x7, x19, x0
	add	x6, x2, x0
	mov	x1, 1
.L1024:
	lsl	x3, x1, 2
	lsl	x8, x1, 3
	ldrb	w10, [x19, x0]
	add	x1, x1, 1
	cmp	x1, 7
	ldrb	w3, [x6, x3]
	add	w3, w3, w10
	strb	w3, [x7, x8]
	bne	.L1024
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L1025
	add	w24, w24, 1
	strb	wzr, [x19, 16]
	strb	wzr, [x19, 24]
	and	w24, w24, 255
	strb	wzr, [x19, 32]
	strb	wzr, [x19, 40]
	strb	wzr, [x19, 48]
	strb	wzr, [x19, 41]
	strb	wzr, [x19, 49]
	b	.L1021
.L1020:
	sub	w0, w26, #3
	cmp	w0, 4
	bhi	.L1028
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
.L1029:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, w21
	bls	.L1028
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
	beq	.L1030
	ubfiz	x0, x22, 6, 8
	add	x0, x0, 20
.L1107:
	add	x3, x1, x0
	mov	w0, 54
	str	w0, [x19, 2056]
	cmp	w26, 4
	bne	.L1032
	mov	w0, 255
	str	w0, [x19, 2052]
	mov	w0, 64
	str	w0, [x19, 2048]
	mov	w0, 204
.L1108:
	str	w0, [x19, 2052]
	mov	w0, 77
	b	.L1109
.L1030:
	mov	x3, 28
	mov	w0, 160
	umaddl	x0, w0, w22, x3
	b	.L1107
.L1032:
	cmp	w25, 1
	bhi	.L1034
	add	x0, x20, :lo12:.LANCHOR20
	ldrb	w0, [x0, 4]
	str	w0, [x19, 2052]
	mov	w0, 82
.L1109:
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
	bne	.L1035
	mov	w0, 31
	str	w0, [x19, 2052]
.L1036:
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
	bls	.L1071
	ldr	w7, [x29, 136]
	cmp	w26, 7
	mov	w1, 32
	csel	w1, w1, w7, eq
.L1037:
	adrp	x8, .LANCHOR145
	mov	x7, 0
	ldr	x0, [x8, #:lo12:.LANCHOR145]
.L1038:
	ldr	w10, [x19, 2048]
	strb	w10, [x0, x7]
	add	x7, x7, 1
	cmp	w1, w7, uxtb
	bhi	.L1038
	cmp	w26, 7
	bne	.L1039
	mov	w1, 0
.L1041:
	ldrb	w7, [x0]
	cmp	w7, 12
	beq	.L1040
	ldrb	w7, [x0, 1]
	cmp	w7, 10
	beq	.L1040
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1041
.L1042:
	adrp	x0, .LC16
	mov	w1, 0
	add	x0, x0, :lo12:.LC16
	bl	printf
.L1044:
	b	.L1044
.L1034:
	mov	w0, 174
	str	w0, [x19, 2052]
	str	wzr, [x19, 2048]
	mov	w0, 176
	b	.L1108
.L1035:
	str	wzr, [x19, 2052]
	b	.L1036
.L1071:
	mov	w1, 16
	b	.L1037
.L1040:
	cmp	w1, 6
	bhi	.L1042
.L1043:
	ldr	x7, [x8, #:lo12:.LANCHOR145]
	mov	x0, 0
.L1048:
	ldr	w1, [x29, 128]
	cmp	w1, w0
	bgt	.L1049
	ldr	x1, [x8, #:lo12:.LANCHOR145]
	mov	w10, 8
	add	x8, x1, x24
.L1051:
	mov	x0, 0
.L1050:
	ldr	w11, [x8, x0, lsl 2]
	mvn	w11, w11
	str	w11, [x8, x0, lsl 2]
	add	x0, x0, 1
	cmp	w23, w0
	bgt	.L1050
	ldr	w0, [x29, 140]
	subs	w10, w10, #1
	add	x8, x8, x0, uxtw 2
	bne	.L1051
	mov	x11, x1
	mov	w12, 0
	mov	w16, 1
.L1057:
	mov	w8, 0
	mov	w0, 0
.L1056:
	mov	x15, x11
	lsl	w10, w16, w0
	mov	w14, 16
	mov	w13, 0
.L1054:
	ldr	w17, [x15]
	add	x15, x15, x24
	bics	wzr, w10, w17
	cinc	w13, w13, eq
	subs	w14, w14, #1
	bne	.L1054
	cmp	w13, 9
	orr	w10, w8, w10
	add	w0, w0, 1
	csel	w8, w10, w8, cs
	cmp	w0, 32
	bne	.L1056
	str	w8, [x11], 4
	add	w12, w12, 1
	cmp	w23, w12
	bgt	.L1057
	mov	x0, 0
	mov	w8, 0
.L1060:
	ldr	w10, [x1, x0]
	add	x0, x0, 4
	cmp	w10, 0
	cinc	w8, w8, eq
	cmp	x0, 32
	bne	.L1060
	cmp	w8, 7
	ble	.L1061
	mov	w3, 1024
	mov	w2, 1
	adrp	x0, .LC17
	add	x0, x0, :lo12:.LC17
	bl	rknand_print_hex
	adrp	x0, .LC16
	mov	w1, 0
	add	x0, x0, :lo12:.LC16
	bl	printf
.L1062:
	b	.L1062
.L1039:
	cmp	w26, 6
	bne	.L1043
	mov	x1, 0
.L1045:
	ldrb	w7, [x0, x1]
	cmp	w7, 12
	beq	.L1043
	add	x7, x0, x1
	ldrb	w7, [x7, 8]
	cmp	w7, 4
	beq	.L1043
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L1045
	adrp	x0, .LC16
	mov	w1, 0
	add	x0, x0, :lo12:.LC16
	bl	printf
.L1047:
	b	.L1047
.L1049:
	ldr	w1, [x19, 2048]
	strb	w1, [x7, x0]
	add	x0, x0, 1
	b	.L1048
.L1061:
	cmp	w26, 6
	beq	.L1073
	cmp	w26, 7
	mov	x1, 8
	mov	x0, 10
	csel	x0, x0, x1, eq
.L1063:
	mov	x1, x3
	mov	w8, 0
.L1064:
	mov	x3, 0
.L1065:
	ldrb	w10, [x7, x3]
	strb	w10, [x1, x3]
	add	x3, x3, 1
	cmp	w28, w3, uxtb
	bhi	.L1065
	ldr	x2, [x29, 112]
	add	w8, w8, 1
	add	x1, x1, x0
	cmp	w27, w8
	add	x7, x7, x2
	bgt	.L1064
	mov	w0, 255
	str	w0, [x19, 2056]
	mov	w0, w22
	bl	NandcWaitFlashReady
	cmp	w25, 1
	bhi	.L1067
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
.L1068:
	add	w21, w21, 1
	mov	w0, w22
	and	w21, w21, 255
	bl	NandcWaitFlashReady
	b	.L1029
.L1073:
	mov	x0, 4
	b	.L1063
.L1067:
	mov	w0, 56
	str	w0, [x19, 2056]
	b	.L1068
	.size	HynixGetReadRetryDefault, .-HynixGetReadRetryDefault
	.section	.text.FlashGetReadRetryDefault,"ax",@progbits
	.align	2
	.global	FlashGetReadRetryDefault
	.type	FlashGetReadRetryDefault, %function
FlashGetReadRetryDefault:
	mov	w1, w0
	cbz	w0, .L1110
	sub	w2, w0, #1
	cmp	w2, 6
	bhi	.L1112
	b	HynixGetReadRetryDefault
.L1112:
	cmp	w0, 49
	bne	.L1113
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
.L1122:
	add	x0, x0, 4
	b	ftl_memcpy
.L1113:
	sub	w0, w0, #65
	cmp	w1, 33
	ccmp	w0, 1, 0, ne
	bhi	.L1114
	adrp	x2, .LANCHOR20
	add	x0, x2, :lo12:.LANCHOR20
	strb	w1, [x2, #:lo12:.LANCHOR20]
	mov	w1, 4
.L1123:
	strb	w1, [x0, 1]
	mov	w1, 7
	mov	w2, 45
	strb	w1, [x0, 2]
	adrp	x1, .LANCHOR10
	add	x1, x1, :lo12:.LANCHOR10
	b	.L1122
.L1114:
	cmp	w1, 34
	mov	w0, 67
	ccmp	w1, w0, 4, ne
	bne	.L1115
	adrp	x2, .LANCHOR20
	add	x0, x2, :lo12:.LANCHOR20
	strb	w1, [x2, #:lo12:.LANCHOR20]
	mov	w1, 5
	b	.L1123
.L1115:
	cmp	w1, 35
	mov	w0, 68
	ccmp	w1, w0, 4, ne
	bne	.L1110
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
	b	.L1122
.L1110:
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
	adrp	x24, .LANCHOR150
	stp	x27, x28, [sp, 80]
	bl	ftl_malloc
	adrp	x1, .LANCHOR145
	adrp	x21, .LANCHOR28
	adrp	x22, .LANCHOR1
	adrp	x20, .LANCHOR22
	str	x0, [x1, #:lo12:.LANCHOR145]
	mov	w0, 32768
	bl	ftl_malloc
	adrp	x25, .LANCHOR6
	adrp	x1, .LANCHOR151
	add	x25, x25, :lo12:.LANCHOR6
	adrp	x26, .LC18
	mov	w28, 0
	str	x0, [x1, #:lo12:.LANCHOR151]
	mov	w0, 4096
	bl	ftl_malloc
	adrp	x1, .LANCHOR194
	str	x0, [x1, #:lo12:.LANCHOR194]
	mov	w0, 32768
	bl	ftl_malloc
	adrp	x1, .LANCHOR195
	str	x0, [x1, #:lo12:.LANCHOR195]
	mov	w0, 4096
	bl	ftl_malloc
	strb	wzr, [x21, #:lo12:.LANCHOR28]
	adrp	x1, .LANCHOR196
	strb	wzr, [x22, #:lo12:.LANCHOR1]
	str	x0, [x1, #:lo12:.LANCHOR196]
	adrp	x1, .LANCHOR148
	mov	w0, 50
	strb	w0, [x23, #:lo12:.LANCHOR2]
	strb	w0, [x1, #:lo12:.LANCHOR148]
	adrp	x0, .LANCHOR147
	mov	w1, 128
	str	wzr, [x0, #:lo12:.LANCHOR147]
	adrp	x0, .LANCHOR3
	str	w1, [x0, #:lo12:.LANCHOR3]
	adrp	x0, .LANCHOR142
	str	wzr, [x0, #:lo12:.LANCHOR142]
	mov	w0, 60
	strb	w0, [x24, #:lo12:.LANCHOR150]
	mov	x0, x19
	add	x19, x20, :lo12:.LANCHOR22
	bl	NandcInit
	mov	x27, x19
	add	x0, x26, :lo12:.LC18
	str	x0, [x29, 104]
.L1129:
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
	bhi	.L1125
	ldrb	w7, [x19, 5]
	add	w1, w28, 1
	ldrb	w6, [x19, 4]
	ldrb	w5, [x19, 3]
	ldrb	w4, [x19, 2]
	ldrb	w3, [x19, 1]
	ldr	x0, [x29, 104]
	bl	printf
.L1125:
	cbnz	w28, .L1126
	ldrb	w0, [x27]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 253
	bhi	.L1167
	ldrb	w0, [x27, 1]
	cmp	w0, 255
	beq	.L1167
.L1126:
	ldrb	w0, [x19]
	cmp	w0, 181
	bne	.L1128
	mov	w0, 44
	strb	w0, [x19]
.L1128:
	add	w28, w28, 1
	add	x25, x25, 16
	add	x19, x19, 8
	cmp	w28, 4
	bne	.L1129
	ldrb	w0, [x20, #:lo12:.LANCHOR22]
	cmp	w0, 173
	beq	.L1130
	adrp	x0, .LANCHOR153
	ldr	w0, [x0, #:lo12:.LANCHOR153]
	bl	NandcSetDdrMode
.L1130:
	mov	w2, 852
	adrp	x26, .LANCHOR20
	mov	w1, 0
	add	x0, x26, :lo12:.LANCHOR20
	adrp	x19, .LANCHOR18
	bl	ftl_memset
	adrp	x28, .LANCHOR29
	add	x0, x28, :lo12:.LANCHOR29
	str	x0, [x19, #:lo12:.LANCHOR18]
	add	x0, x20, :lo12:.LANCHOR22
	adrp	x27, .LANCHOR5
	ldrb	w2, [x0, 1]
	strb	wzr, [x27, #:lo12:.LANCHOR5]
	cmp	w2, 161
	beq	.L1131
	cmp	w2, 218
	beq	.L1131
	and	w1, w2, -33
	cmp	w1, 209
	beq	.L1131
	cmp	w2, 220
	bne	.L1132
	ldrb	w0, [x0, 3]
	cmp	w0, 149
	bne	.L1132
.L1131:
	mov	w0, 1
	adrp	x25, .LANCHOR197
	add	x1, x25, :lo12:.LANCHOR197
	strb	w0, [x22, #:lo12:.LANCHOR1]
	mov	w0, 16
	strb	w0, [x23, #:lo12:.LANCHOR2]
	strb	w0, [x24, #:lo12:.LANCHOR150]
	add	x3, x20, :lo12:.LANCHOR22
	ldrb	w0, [x20, #:lo12:.LANCHOR22]
	strb	w0, [x1, 1]
	strb	w2, [x1, 2]
	cmp	w0, 152
	bne	.L1133
	ldrsb	w0, [x3, 4]
	tbnz	w0, #31, .L1133
	mov	w0, 24
	strb	w0, [x24, #:lo12:.LANCHOR150]
.L1133:
	adrp	x0, .LANCHOR152
	ldr	w1, [x0, #:lo12:.LANCHOR152]
	mov	w0, 12336
	movk	w0, 0x5638, lsl 16
	cmp	w1, w0
	bne	.L1134
	mov	w0, 16
	strb	w0, [x24, #:lo12:.LANCHOR150]
.L1134:
	cmp	w2, 218
	bne	.L1135
	add	x0, x25, :lo12:.LANCHOR197
	mov	w1, 2048
	strh	w1, [x0, 14]
	mov	w1, -38
.L1202:
	strb	w1, [x0, 2]
.L1136:
	adrp	x1, .LANCHOR141
	add	x1, x1, :lo12:.LANCHOR141
	mov	w2, 32
	add	x1, x1, 32
	adrp	x0, .LANCHOR7
	add	x0, x0, :lo12:.LANCHOR7
	bl	ftl_memcpy
	mov	w2, 32
	add	x1, x25, :lo12:.LANCHOR197
	add	x0, x28, :lo12:.LANCHOR29
	bl	ftl_memcpy
.L1132:
	ldrb	w0, [x22, #:lo12:.LANCHOR1]
	adrp	x25, .LANCHOR8
	cbnz	w0, .L1138
	bl	FlashLoadPhyInfoInRam
	cbnz	w0, .L1140
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	adrp	x24, .LANCHOR24
	ldrb	w1, [x0, 17]
	and	w0, w1, 7
	strb	w0, [x24, #:lo12:.LANCHOR24]
	tbnz	x1, 0, .L1140
	mov	w1, 1
	strb	w1, [x21, #:lo12:.LANCHOR28]
	bl	FlashSetInterfaceMode
	ldrb	w0, [x24, #:lo12:.LANCHOR24]
	bl	NandcSetMode
.L1140:
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 26]
	strb	w0, [x25, #:lo12:.LANCHOR8]
	bl	FlashLoadPhyInfo
	cbz	w0, .L1138
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	ldrh	w1, [x0, 14]
	adrp	x0, .LC19
	add	x0, x0, :lo12:.LC19
	bl	printf
	bl	FlashLoadPhyInfoInRam
	cmn	w0, #1
	beq	.L1124
	bl	FlashDieInfoInit
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 19]
	bl	FlashGetReadRetryDefault
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	adrp	x1, .LANCHOR119
	ldrh	w1, [x1, #:lo12:.LANCHOR119]
	ldrb	w2, [x0, 9]
	add	w1, w1, 4095
	cmp	w2, w1, lsr 12
	blt	.L1143
	ldrh	w1, [x0, 14]
	add	w1, w1, 255
	cmp	w2, w1, lsr 8
	bge	.L1144
.L1143:
	ldrh	w1, [x0, 14]
	and	w1, w1, -256
	strh	w1, [x0, 14]
.L1144:
	adrp	x0, .LANCHOR24
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	tst	w0, 6
	beq	.L1145
	bl	FlashSavePhyInfo
	adrp	x0, .LANCHOR146
	ldr	w1, [x0, #:lo12:.LANCHOR146]
	mov	w0, 0
	bl	FlashDdrParaScan
.L1145:
	bl	FlashSavePhyInfo
.L1138:
	ldr	x2, [x19, #:lo12:.LANCHOR18]
	adrp	x24, .LANCHOR24
	ldrb	w0, [x2, 26]
	strb	w0, [x25, #:lo12:.LANCHOR8]
	ldrh	w0, [x2, 16]
	ubfx	x1, x0, 7, 1
	strb	w1, [x27, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR198
	ubfx	x3, x0, 3, 1
	adrp	x27, .LANCHOR143
	strb	w3, [x1, #:lo12:.LANCHOR198]
	adrp	x1, .LANCHOR27
	ubfx	x3, x0, 4, 1
	ubfx	x0, x0, 8, 3
	strb	w3, [x1, #:lo12:.LANCHOR27]
	strb	w0, [x24, #:lo12:.LANCHOR24]
	ldrh	w1, [x2, 10]
	ldrb	w0, [x2, 12]
	str	xzr, [x27, #:lo12:.LANCHOR143]
	sdiv	w1, w1, w0
	ldrb	w0, [x2, 18]
	bl	BuildFlashLsbPageTable
	bl	FlashDieInfoInit
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	ldrh	w1, [x0, 16]
	tbz	x1, 6, .L1147
	adrp	x1, .LANCHOR11
	ldrb	w0, [x0, 19]
	adrp	x3, .LANCHOR13
	strb	w0, [x1, #:lo12:.LANCHOR11]
	add	x1, x26, :lo12:.LANCHOR20
	ldrb	w2, [x1, 1]
	strb	w2, [x3, #:lo12:.LANCHOR13]
	adrp	x2, .LANCHOR149
	ldrb	w4, [x1, 2]
	strb	w4, [x2, #:lo12:.LANCHOR149]
	sub	w4, w0, #1
	and	w4, w4, 255
	cmp	w4, 6
	mov	x4, x3
	bhi	.L1148
	adrp	x2, HynixReadRetrial
	add	x2, x2, :lo12:HynixReadRetrial
	str	x2, [x27, #:lo12:.LANCHOR143]
	sub	w2, w0, #5
	and	w2, w2, 255
	cmp	w2, 1
	bhi	.L1149
	adrp	x2, .LANCHOR34
	add	x1, x1, 20
	mov	w3, 1
	str	w3, [x2, #:lo12:.LANCHOR34]
.L1150:
	mov	x2, 0
	mov	w3, 0
.L1152:
	ldrsb	w4, [x1, x2]
	add	x2, x2, 1
	cmp	w4, 0
	cinc	w3, w3, eq
	cmp	x2, 32
	bne	.L1152
	cmp	w3, 27
	bls	.L1147
	bl	FlashGetReadRetryDefault
	bl	FlashSavePhyInfo
.L1147:
	adrp	x0, .LANCHOR152
	ldr	w1, [x0, #:lo12:.LANCHOR152]
	mov	w0, 12336
	movk	w0, 0x5638, lsl 16
	cmp	w1, w0
	bne	.L1161
	ldrb	w0, [x25, #:lo12:.LANCHOR8]
	cbz	w0, .L1161
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	strb	wzr, [x0, 18]
.L1161:
	ldrb	w0, [x20, #:lo12:.LANCHOR22]
	cmp	w0, 44
	bne	.L1162
	ldrb	w0, [x21, #:lo12:.LANCHOR28]
	cbz	w0, .L1162
	strb	wzr, [x21, #:lo12:.LANCHOR28]
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
.L1162:
	mov	w0, 0
	bl	flash_enter_slc_mode
	ldrb	w0, [x24, #:lo12:.LANCHOR24]
	tst	w0, 6
	beq	.L1163
	ldrb	w1, [x21, #:lo12:.LANCHOR28]
	cbnz	w1, .L1164
	tbnz	x0, 0, .L1163
.L1164:
	adrp	x0, .LANCHOR146
	ldr	w1, [x0, #:lo12:.LANCHOR146]
	mov	w0, 0
	bl	FlashDdrParaScan
.L1163:
	mov	w0, 0
	bl	flash_exit_slc_mode
	ldr	x0, [x19, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 20]
	bl	FlashBchSel
	adrp	x0, .LANCHOR139
	add	x0, x0, :lo12:.LANCHOR139
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
	bne	.L1165
	ubfiz	w1, w1, 1, 15
	lsr	w4, w4, 1
	ubfiz	w3, w3, 1, 15
	strh	w1, [x0, 22]
	strh	w4, [x0, 14]
	mov	w1, 8
	strh	w3, [x0, 20]
	strh	w1, [x0, 26]
.L1165:
	ldrb	w0, [x2, 20]
	bl	FlashBchSel
	mov	w0, 0
.L1124:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1135:
	cmp	w2, 220
	bne	.L1136
	add	x0, x25, :lo12:.LANCHOR197
	mov	w1, 4096
	strh	w1, [x0, 14]
	mov	w1, -36
	b	.L1202
.L1149:
	add	x2, x1, 20
	cmp	w0, 7
	add	x1, x1, 28
	csel	x1, x1, x2, eq
	b	.L1150
.L1148:
	sub	w1, w0, #17
	and	w1, w1, 255
	cmp	w1, 2
	bhi	.L1154
	adrp	x1, MicronReadRetrial
	add	x1, x1, :lo12:MicronReadRetrial
	str	x1, [x27, #:lo12:.LANCHOR143]
	cmp	w0, 19
	beq	.L1155
.L1206:
	mov	w0, 7
	b	.L1204
.L1155:
	mov	w0, 15
.L1204:
	strb	w0, [x2, #:lo12:.LANCHOR149]
	b	.L1147
.L1154:
	sub	w1, w0, #65
	cmp	w0, 33
	and	w1, w1, 255
	ccmp	w1, 1, 0, ne
	bhi	.L1156
	adrp	x0, ToshibaReadRetrial
	add	x0, x0, :lo12:ToshibaReadRetrial
	str	x0, [x27, #:lo12:.LANCHOR143]
	mov	w0, 4
	strb	w0, [x3, #:lo12:.LANCHOR13]
	b	.L1206
.L1156:
	sub	w3, w0, #34
	sub	w1, w0, #67
	and	w3, w3, 255
	and	w1, w1, 255
	cmp	w3, 1
	ccmp	w1, 1, 0, hi
	bhi	.L1157
	adrp	x3, ToshibaReadRetrial
	add	x3, x3, :lo12:ToshibaReadRetrial
	str	x3, [x27, #:lo12:.LANCHOR143]
	cmp	w0, 35
	mov	w3, 68
	ccmp	w0, w3, 4, ne
	beq	.L1158
	mov	w0, 7
.L1203:
	strb	w0, [x2, #:lo12:.LANCHOR149]
	cmp	w1, 1
	bhi	.L1160
	mov	w0, 4
.L1205:
	strb	w0, [x4, #:lo12:.LANCHOR13]
	b	.L1147
.L1158:
	mov	w0, 17
	b	.L1203
.L1160:
	mov	w0, 5
	b	.L1205
.L1157:
	cmp	w0, 49
	bne	.L1147
	adrp	x0, SamsungReadRetrial
	add	x0, x0, :lo12:SamsungReadRetrial
	str	x0, [x27, #:lo12:.LANCHOR143]
	b	.L1147
.L1167:
	mov	w0, -2
	b	.L1124
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
	adrp	x2, .LANCHOR29+9
	stp	x23, x24, [sp, 48]
	nop // between mem op and mult-accumulate
	umaddl	x22, w1, w22, x0
	stp	x19, x20, [sp, 16]
	ldrb	w24, [x2, #:lo12:.LANCHOR29+9]
	adrp	x23, .LANCHOR25
	mov	x19, x0
	and	w21, w1, 255
	add	x23, x23, :lo12:.LANCHOR25
	adrp	x26, .LANCHOR26
	str	x27, [sp, 80]
.L1208:
	cmp	x22, x19
	bne	.L1220
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1220:
	mov	w1, w25
	mov	w4, w21
	add	x3, x29, 104
	add	x2, x29, 108
	mov	x0, x19
	bl	LogAddr2PhyAddr
	ldrb	w1, [x23]
	ldr	w0, [x29, 104]
	cmp	w1, w0
	bhi	.L1209
	mov	w0, -1
	str	w0, [x19]
.L1210:
	sub	w21, w21, #1
	add	x19, x19, 56
	and	w21, w21, 255
	b	.L1208
.L1209:
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
	adrp	x1, .LANCHOR31
	csel	w0, w20, w2, cs
	ldrb	w2, [x1, #:lo12:.LANCHOR31]
	add	w1, w2, w2, lsl 1
	cmp	w0, w1, lsr 2
	bls	.L1213
	cmn	w0, #1
	mov	w1, 256
	csel	w0, w0, w1, eq
.L1213:
	cmp	w0, 256
	ccmn	w0, #1, 4, ne
	csel	w0, w0, wzr, eq
	str	w0, [x19]
	ldr	x0, [x19, 16]
	cbz	x0, .L1216
	ldr	w1, [x0, 8]
	cmn	w1, #1
	bne	.L1216
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L1216
	str	w1, [x19]
.L1216:
	ldr	w3, [x19]
	cmn	w3, #1
	bne	.L1210
	ldr	w1, [x19, 4]
	adrp	x0, .LC20
	add	x0, x0, :lo12:.LC20
	bl	printf
	ldr	x1, [x19, 8]
	cbz	x1, .L1218
	adrp	x0, .LC21
	mov	w3, 8
	mov	w2, 4
	add	x0, x0, :lo12:.LC21
	bl	rknand_print_hex
.L1218:
	ldr	x1, [x19, 16]
	cbz	x1, .L1210
	mov	w3, 4
	adrp	x0, .LC22
	mov	w2, w3
	add	x0, x0, :lo12:.LC22
	bl	rknand_print_hex
	b	.L1210
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
	cbnz	w3, .L1239
	mov	x25, x0
	adrp	x0, .LANCHOR29+9
	adrp	x27, .LANCHOR20
	mov	w23, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR29+9]
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
.L1240:
	ldr	w0, [x29, 152]
	cmp	w22, w0
	bcc	.L1274
	mov	w0, 0
	b	.L1238
.L1239:
	bl	FlashReadSlc2KPages
.L1238:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1274:
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
	bhi	.L1242
	mov	w0, -1
	str	w0, [x25, x26]
.L1243:
	add	w22, w22, 1
	b	.L1240
.L1242:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w19, [x0, w1, uxtw]
	adrp	x0, .LANCHOR198
	ldrb	w0, [x0, #:lo12:.LANCHOR198]
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
	bhi	.L1245
	add	x0, x27, :lo12:.LANCHOR20
	sxtw	x1, w19
	add	x0, x0, x1
	cmp	w2, 7
	ldrb	w3, [x0, 12]
	bne	.L1246
	ldrb	w3, [x0, 20]
.L1246:
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	ldrb	w0, [x0, x1]
	cmp	w0, w3
	beq	.L1245
	ldp	x2, x0, [x29, 96]
	ldrb	w1, [x0, 1]
	mov	w0, w19
	bl	HynixSetRRPara
.L1245:
	mov	w0, w19
	bl	NandcFlashCs
	ldr	w0, [x29, 148]
	cmp	w0, 1
	cset	w0, eq
	orr	w24, w0, w24, lsr 31
	cbz	w24, .L1247
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L1247
	mov	w0, w19
	bl	flash_enter_slc_mode
.L1248:
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	str	x0, [x29, 112]
	ldr	x0, [x29, 128]
	add	x0, x0, :lo12:.LANCHOR5
	str	x0, [x29, 136]
.L1254:
	ldr	w1, [x29, 172]
	cmn	w1, #1
	bne	.L1249
	cmp	w19, 255
	beq	.L1276
.L1249:
	cbz	w20, .L1251
	ldr	x0, [x29, 112]
	ldr	w2, [x0]
	mov	w0, w19
	add	w2, w1, w2
	bl	FlashReadDpCmd
.L1252:
	mov	w0, w19
	bl	NandcWaitFlashReady
	cbz	w20, .L1250
	ldr	w1, [x29, 172]
	mov	w0, w19
	bl	FlashReadDpDataOutCmd
.L1250:
	ldrb	w2, [x29, 156]
	mov	w1, 0
	ldp	x3, x4, [x21, 8]
	mov	w0, w19
	bl	NandcXferData
	mov	w28, w0
	ldr	x0, [x29, 136]
	ldrb	w0, [x0]
	cbz	w0, .L1253
	cmn	w28, #1
	bne	.L1253
	ldr	x0, [x29, 136]
	mov	w20, 0
	strb	wzr, [x0]
	b	.L1254
.L1247:
	mov	w0, w19
	bl	flash_exit_slc_mode
	b	.L1248
.L1251:
	mov	w0, w19
	bl	FlashReadCmd
	b	.L1252
.L1276:
	mov	w20, 0
	b	.L1250
.L1253:
	cbz	w20, .L1255
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
.L1255:
	mov	w0, w19
	bl	NandcFlashDeCs
	ldr	x0, [x29, 128]
	cmn	w28, #1
	ldrb	w1, [x29, 144]
	strb	w1, [x0, #:lo12:.LANCHOR5]
	bne	.L1256
	adrp	x0, .LANCHOR28
	ldrb	w0, [x0, #:lo12:.LANCHOR28]
	cbnz	w0, .L1257
.L1261:
	adrp	x20, .LANCHOR143
	ldr	x4, [x20, #:lo12:.LANCHOR143]
	cbnz	x4, .L1258
	ldr	w1, [x29, 172]
	mov	w0, w19
	ldp	x2, x3, [x21, 8]
	bl	FlashReadRawPage
	b	.L1313
.L1257:
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
	beq	.L1260
	adrp	x0, .LANCHOR31
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	cmp	w28, w0, lsr 1
	bls	.L1277
.L1260:
	lsr	w0, w20, 8
	bl	NandcSetDdrPara
	cmn	w28, #1
	beq	.L1261
.L1277:
	mov	w20, 0
.L1256:
	adrp	x0, .LANCHOR31
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bls	.L1262
	adrp	x0, .LANCHOR143
	ldr	x0, [x0, #:lo12:.LANCHOR143]
	cmp	x0, 0
	mov	w0, 256
	csel	w28, w28, w0, ne
.L1262:
	cmp	w28, 256
	ccmn	w28, #1, 4, ne
	csel	w3, w28, wzr, eq
	str	w3, [x25, x26]
	cmn	w3, #1
	bne	.L1269
	adrp	x0, .LANCHOR31
	ldr	w1, [x21, 4]
	ldrb	w2, [x0, #:lo12:.LANCHOR31]
	adrp	x0, .LC20
	add	x0, x0, :lo12:.LC20
	bl	printf
	ldr	x1, [x21, 16]
	cbz	x1, .L1269
	mov	w3, 4
	adrp	x0, .LC22
	mov	w2, w3
	add	x0, x0, :lo12:.LC22
	bl	rknand_print_hex
.L1269:
	cbz	w20, .L1271
	adrp	x0, .LANCHOR31
	ldrb	w0, [x0, #:lo12:.LANCHOR31]
	add	w0, w0, w0, lsl 1
	cmp	w23, w0, lsr 2
	bls	.L1272
	adrp	x0, .LANCHOR143
	ldr	x0, [x0, #:lo12:.LANCHOR143]
	cmp	x0, 0
	mov	w0, 256
	csel	w23, w23, w0, ne
.L1272:
	add	w0, w22, 1
	mov	w1, 56
	cmp	w23, 256
	ccmn	w23, #1, 4, ne
	umull	x0, w0, w1
	csel	w1, w23, wzr, eq
	str	w1, [x25, x0]
.L1271:
	add	w22, w22, w20
	cbz	w24, .L1243
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L1243
	mov	w0, w19
	bl	flash_exit_slc_mode
	b	.L1243
.L1258:
	ldr	w1, [x29, 172]
	mov	w0, w19
	ldp	x2, x3, [x21, 8]
	blr	x4
	mov	w28, w0
	cmn	w0, #1
	bne	.L1280
	ldr	x0, [x29, 120]
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 19]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 6
	bhi	.L1263
	add	x0, x27, :lo12:.LANCHOR20
	mov	w3, 0
	add	x2, x0, 4
	ldrb	w1, [x0, 1]
	mov	w0, w19
	bl	HynixSetRRPara
.L1263:
	ldp	x2, x3, [x21, 8]
	mov	w0, w19
	ldr	w1, [x29, 172]
	bl	FlashReadRawPage
	mov	w28, w0
	mov	w3, w0
	adrp	x0, .LANCHOR31
	ldr	w1, [x21, 4]
	ldrb	w2, [x0, #:lo12:.LANCHOR31]
	adrp	x0, .LC23
	add	x0, x0, :lo12:.LC23
	bl	printf
	cmn	w28, #1
	bne	.L1280
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L1280
	mov	w0, w19
	cbz	w24, .L1264
	bl	flash_enter_slc_mode
.L1265:
	ldr	x4, [x20, #:lo12:.LANCHOR143]
	mov	w0, w19
	ldr	w1, [x29, 172]
	ldp	x2, x3, [x21, 8]
	blr	x4
.L1313:
	mov	w28, w0
.L1280:
	mov	w20, 0
	b	.L1262
.L1264:
	bl	flash_exit_slc_mode
	b	.L1265
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
	adrp	x2, .LANCHOR29+9
	stp	x21, x22, [sp, 32]
	and	w21, w1, 255
	stp	x25, x26, [sp, 64]
	nop // between mem op and mult-accumulate
	umaddl	x23, w1, w23, x0
	ldrb	w25, [x2, #:lo12:.LANCHOR29+9]
	adrp	x26, .LANCHOR3
	stp	x27, x28, [sp, 80]
	mov	w22, w21
	stp	x19, x20, [sp, 16]
	mov	x27, x0
	mov	x20, x0
	add	x28, x26, :lo12:.LANCHOR3
	str	w3, [x29, 108]
.L1315:
	cmp	x20, x23
	bne	.L1321
	ldr	w0, [x29, 108]
	cbnz	w0, .L1322
.L1341:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1321:
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
	bhi	.L1316
	mov	w0, -1
	str	w0, [x20]
.L1317:
	sub	w22, w22, #1
	add	x20, x20, 56
	and	w22, w22, 255
	b	.L1315
.L1316:
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
	tbz	x0, 0, .L1320
	mov	w0, -1
	str	w0, [x20]
.L1320:
	mov	w0, w19
	bl	NandcFlashDeCs
	b	.L1317
.L1328:
	ldr	w0, [x27]
	cmn	w0, #1
	bne	.L1323
	ldr	w1, [x27, 4]
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	bl	printf
.L1324:
	sub	w21, w21, #1
	add	x27, x27, 56
	and	w21, w21, 255
.L1342:
	cmp	x27, x20
	bne	.L1328
	b	.L1341
.L1323:
	adrp	x19, .LANCHOR196
	mov	w4, w21
	add	x3, x29, 116
	add	x2, x29, 112
	mov	w1, w24
	mov	x0, x27
	bl	LogAddr2PhyAddr
	ldr	x26, [x22, #:lo12:.LANCHOR195]
	ldr	x25, [x19, #:lo12:.LANCHOR196]
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
	bne	.L1325
	ldr	w1, [x27, 4]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	bl	printf
	str	w25, [x27]
.L1325:
	ldr	x0, [x27, 16]
	cbz	x0, .L1326
	ldr	w2, [x0]
	ldr	x0, [x19, #:lo12:.LANCHOR196]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1326
	ldr	w1, [x27, 4]
	adrp	x0, .LC26
	add	x0, x0, :lo12:.LC26
	bl	printf
	mov	w0, -1
	str	w0, [x27]
.L1326:
	ldr	x0, [x27, 8]
	cbz	x0, .L1324
	ldr	w2, [x0]
	ldr	x0, [x23, #:lo12:.LANCHOR195]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1324
	ldr	w1, [x27, 4]
	adrp	x0, .LC27
	add	x0, x0, :lo12:.LC27
	bl	printf
	mov	w0, -1
	str	w0, [x27]
	b	.L1324
.L1322:
	adrp	x22, .LANCHOR195
	mov	x23, x22
	b	.L1342
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
	cbnz	w4, .L1345
	mov	x19, x0
	adrp	x0, .LANCHOR29+9
	adrp	x27, .LANCHOR23
	mov	w24, w1
	ldrb	w0, [x0, #:lo12:.LANCHOR29+9]
	mov	w22, w2
	add	x28, x27, :lo12:.LANCHOR23
	mov	w21, 0
	str	w0, [x29, 108]
.L1346:
	cmp	w21, w24
	adrp	x26, .LANCHOR25
	bcc	.L1359
	adrp	x21, .LANCHOR8
	adrp	x23, .LANCHOR23
	add	x25, x26, :lo12:.LANCHOR25
	add	x21, x21, :lo12:.LANCHOR8
	add	x23, x23, :lo12:.LANCHOR23
	mov	x20, 0
.L1360:
	ldrb	w0, [x25]
	cmp	w0, w20
	bhi	.L1362
	ldr	w0, [x29, 100]
	cbnz	w0, .L1363
.L1371:
	mov	w0, 0
	b	.L1344
.L1345:
	bl	FlashProgSlc2KPages
.L1344:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1359:
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
	bhi	.L1348
	mov	w0, -1
	str	w0, [x19, x12]
.L1349:
	add	w21, w21, 1
	b	.L1346
.L1348:
	adrp	x1, .LANCHOR27
	add	x2, x27, :lo12:.LANCHOR23
	mov	x3, 24
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
	cmp	w1, 0
	uxtw	x1, w0
	csel	w23, w23, wzr, ne
	madd	x1, x1, x3, x2
	ldr	x1, [x1, 8]
	cbz	x1, .L1351
	bl	FlashWaitCmdDone
.L1351:
	ldp	w2, w1, [x29, 112]
	mov	x0, 24
	madd	x0, x1, x0, x28
	str	w2, [x0, 4]
	stp	x25, xzr, [x0, 8]
	cbz	w23, .L1352
	add	w2, w21, 1
	mov	w3, 56
	umaddl	x2, w2, w3, x19
	str	x2, [x0, 16]
.L1352:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w20, [x0, x1]
	mov	x0, 24
	mul	x1, x1, x0
	ldrb	w0, [x26, #:lo12:.LANCHOR25]
	cmp	w0, 1
	mov	w0, w20
	strb	w20, [x28, x1]
	bne	.L1353
	bl	NandcWaitFlashReady
.L1354:
	ldr	w0, [x29, 104]
	sub	w0, w0, #1
	cmp	w0, 6
	bhi	.L1355
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	ldrb	w0, [x0, w20, sxtw]
	cbz	w0, .L1355
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	add	x2, x0, 4
	mov	w3, 0
	ldrb	w1, [x0, 1]
	mov	w0, w20
	bl	HynixSetRRPara
.L1355:
	mov	w0, w20
	bl	NandcFlashCs
	cmp	w22, 1
	bne	.L1356
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L1356
	mov	w0, w20
	bl	flash_enter_slc_mode
.L1357:
	ldr	w1, [x29, 112]
	mov	w0, w20
	bl	FlashProgFirstCmd
	ldrb	w2, [x29, 108]
	mov	w1, 1
	ldp	x3, x4, [x25, 8]
	mov	w0, w20
	bl	NandcXferData
	cbz	w23, .L1358
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
.L1358:
	ldr	w1, [x29, 112]
	mov	w0, w20
	add	w21, w21, w23
	bl	FlashProgSecondCmd
	mov	w0, w20
	bl	NandcFlashDeCs
	b	.L1349
.L1353:
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
	b	.L1354
.L1356:
	mov	w0, w20
	bl	flash_exit_slc_mode
	b	.L1357
.L1362:
	mov	w0, w20
	bl	FlashWaitCmdDone
	cmp	w22, 1
	bne	.L1361
	ldrb	w0, [x21]
	cbz	w0, .L1361
	mov	x0, 24
	mul	x0, x20, x0
	ldrb	w0, [x0, x23]
	bl	flash_exit_slc_mode
.L1361:
	add	x20, x20, 1
	b	.L1360
.L1363:
	mov	w0, 56
	and	w20, w24, 255
	adrp	x23, .LANCHOR195
	mov	x25, x23
	umaddl	x24, w24, w0, x19
.L1364:
	cmp	x24, x19
	beq	.L1371
	ldr	w0, [x19]
	cmn	w0, #1
	bne	.L1365
	ldr	w1, [x19, 4]
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	bl	printf
.L1366:
	sub	w20, w20, #1
	add	x19, x19, 56
	and	w20, w20, 255
	b	.L1364
.L1365:
	adrp	x21, .LANCHOR196
	mov	w4, w20
	add	x3, x29, 116
	add	x2, x29, 112
	mov	w1, w22
	mov	x0, x19
	bl	LogAddr2PhyAddr
	ldr	x27, [x23, #:lo12:.LANCHOR195]
	ldr	x26, [x21, #:lo12:.LANCHOR196]
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
	bne	.L1367
	ldr	w1, [x19, 4]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	bl	printf
	str	w26, [x19]
.L1367:
	ldr	x0, [x19, 16]
	cbz	x0, .L1368
	ldr	w2, [x0]
	ldr	x0, [x21, #:lo12:.LANCHOR196]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1368
	ldr	w1, [x19, 4]
	adrp	x0, .LC26
	add	x0, x0, :lo12:.LC26
	bl	printf
	mov	w0, -1
	str	w0, [x19]
.L1368:
	ldr	x0, [x19, 8]
	cbz	x0, .L1366
	ldr	w2, [x0]
	ldr	x0, [x25, #:lo12:.LANCHOR195]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1366
	ldr	w1, [x19, 4]
	adrp	x0, .LC27
	add	x0, x0, :lo12:.LC27
	bl	printf
	mov	w0, -1
	str	w0, [x19]
	b	.L1366
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
	adrp	x0, .LANCHOR147
	ldr	w0, [x0, #:lo12:.LANCHOR147]
	cmp	w19, w0
	bcc	.L1399
	adrp	x20, .LANCHOR151
	mov	w2, 32
	mov	w1, 165
	lsl	w19, w19, 10
	ldr	x0, [x20, #:lo12:.LANCHOR151]
	str	x0, [x29, 48]
	add	x0, x29, 96
	str	x0, [x29, 56]
	bl	ftl_memset
	ldr	x0, [x20, #:lo12:.LANCHOR151]
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
.L1397:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 160
	ret
.L1399:
	mov	w19, 0
	b	.L1397
	.size	FlashTestBlk, .-FlashTestBlk
	.section	.text.FtlLowFormatEraseBlock,"ax",@progbits
	.align	2
	.global	FtlLowFormatEraseBlock
	.type	FtlLowFormatEraseBlock, %function
FtlLowFormatEraseBlock:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	and	w25, w0, 65535
	adrp	x0, .LANCHOR75
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	ldr	w0, [x0, #:lo12:.LANCHOR75]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	cbnz	w0, .L1424
	adrp	x0, .LANCHOR72
	and	w24, w1, 255
	adrp	x23, .LANCHOR8
	adrp	x1, .LANCHOR36
	str	w25, [x0, #:lo12:.LANCHOR72]
	adrp	x0, .LANCHOR186
	adrp	x21, .LANCHOR76
	ldrb	w10, [x23, #:lo12:.LANCHOR8]
	ldr	x12, [x0, #:lo12:.LANCHOR186]
	adrp	x0, .LANCHOR57
	ldrh	w11, [x1, #:lo12:.LANCHOR36]
	mov	x8, 56
	ldr	x6, [x21, #:lo12:.LANCHOR76]
	adrp	x7, .LANCHOR45
	ldrh	w13, [x0, #:lo12:.LANCHOR57]
	add	x7, x7, :lo12:.LANCHOR45
	mov	w14, w8
	mov	x5, 0
	mov	w20, 0
	mov	w19, 0
	stp	x0, x1, [x29, 112]
.L1403:
	cmp	w11, w5, uxth
	bhi	.L1407
	cbz	w20, .L1401
	cmp	w10, 0
	mov	w2, w20
	cset	w22, ne
	mov	x0, x6
	mov	w1, w22
	mov	x26, 0
	bl	FlashEraseBlocks
	mov	w0, 56
	umull	x20, w20, w0
.L1410:
	ldr	x0, [x21, #:lo12:.LANCHOR76]
	add	x1, x0, x26
	ldr	w0, [x0, x26]
	cmn	w0, #1
	bne	.L1409
	ldr	w0, [x1, 4]
	add	w19, w19, 1
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.L1409:
	add	x26, x26, 56
	cmp	x26, x20
	bne	.L1410
	cbnz	w24, .L1411
	and	w22, w22, 65535
	mov	w27, 6
	mov	w26, 1
.L1412:
	adrp	x28, .LANCHOR45
	mov	w23, 0
	add	x0, x28, :lo12:.LANCHOR45
	str	x0, [x29, 104]
.L1420:
	ldr	x0, [x29, 120]
	mov	x5, 0
	ldr	x6, [x21, #:lo12:.LANCHOR76]
	mov	w20, 0
	mov	w12, 56
	ldrh	w7, [x0, #:lo12:.LANCHOR36]
	adrp	x0, .LANCHOR183
	ldr	x8, [x0, #:lo12:.LANCHOR183]
	adrp	x0, .LANCHOR184
	ldr	x10, [x0, #:lo12:.LANCHOR184]
	ldr	x0, [x29, 112]
	ldrh	w11, [x0, #:lo12:.LANCHOR57]
.L1413:
	cmp	w7, w5, uxth
	bhi	.L1416
	cbz	w20, .L1401
	mov	w1, w20
	mov	w3, 1
	mov	w2, w22
	mov	x0, x6
	bl	FlashProgPages
	mov	x28, 0
	mov	w1, 56
	umull	x1, w20, w1
.L1419:
	ldr	x0, [x21, #:lo12:.LANCHOR76]
	add	x3, x0, x28
	ldr	w0, [x0, x28]
	cbz	w0, .L1418
	ldr	w0, [x3, 4]
	add	w19, w19, 1
	str	x1, [x29, 96]
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	ldr	x1, [x29, 96]
.L1418:
	add	x28, x28, 56
	cmp	x1, x28
	bne	.L1419
	add	w23, w23, w27
	and	w23, w23, 65535
	cmp	w23, w26
	bcc	.L1420
	mov	x23, 0
.L1422:
	cbz	w24, .L1421
	ldr	x0, [x21, #:lo12:.LANCHOR76]
	add	x1, x0, x23
	ldr	w0, [x0, x23]
	cbnz	w0, .L1421
	ldr	w0, [x1, 4]
	mov	w1, 1
	lsr	w0, w0, 10
	bl	FtlFreeSysBlkQueueIn
.L1421:
	add	x23, x23, 56
	cmp	x23, x28
	bne	.L1422
	cmp	w25, 63
	ccmp	w24, 0, 0, hi
	beq	.L1401
	ldr	x0, [x21, #:lo12:.LANCHOR76]
	mov	w2, w20
	mov	w1, w22
	bl	FlashEraseBlocks
.L1401:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1407:
	mul	x0, x5, x8
	mov	w1, w25
	str	wzr, [x6, x0]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	and	w15, w0, 65535
	mov	w22, w15
	cbz	w24, .L1404
	bl	IsBlkInVendorPart
	cbnz	w0, .L1405
.L1404:
	mov	w0, w22
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L1406
	umaddl	x1, w20, w14, x6
	lsl	w15, w15, 10
	mul	w0, w20, w13
	add	w20, w20, 1
	and	w20, w20, 65535
	asr	w0, w0, 2
	str	w15, [x1, 4]
	add	x0, x12, x0, sxtw 2
	stp	xzr, x0, [x1, 8]
.L1405:
	add	x5, x5, 1
	b	.L1403
.L1406:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1405
.L1411:
	adrp	x0, .LANCHOR52
	ldrh	w26, [x0, #:lo12:.LANCHOR52]
	ldrb	w0, [x23, #:lo12:.LANCHOR8]
	cbnz	w0, .L1425
	lsr	w27, w26, 2
	mov	w22, 1
	b	.L1412
.L1425:
	mov	w22, 1
	mov	w27, w22
	b	.L1412
.L1416:
	mov	x0, 56
	mov	w1, w25
	mul	x0, x5, x0
	str	wzr, [x6, x0]
	ldr	x0, [x29, 104]
	ldrb	w0, [x0, x5]
	bl	V2P_block
	and	w13, w0, 65535
	mov	w14, w13
	cbz	w24, .L1414
	bl	IsBlkInVendorPart
	cbnz	w0, .L1415
.L1414:
	mov	w0, w14
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L1415
	umaddl	x1, w20, w12, x6
	add	w13, w23, w13, lsl 10
	mul	w0, w20, w11
	add	w20, w20, 1
	and	w20, w20, 65535
	asr	w0, w0, 2
	str	w13, [x1, 4]
	add	x0, x10, x0, sxtw 2
	stp	x8, x0, [x1, 8]
.L1415:
	add	x5, x5, 1
	b	.L1413
.L1424:
	mov	w19, 0
	b	.L1401
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
	.section	.text.FtlBbmTblFlush,"ax",@progbits
	.align	2
	.global	FtlBbmTblFlush
	.type	FtlBbmTblFlush, %function
FtlBbmTblFlush:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR75
	stp	x19, x20, [sp, 16]
	ldr	w0, [x22, #:lo12:.LANCHOR75]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w0, .L1448
	adrp	x24, .LANCHOR185
	adrp	x23, .LANCHOR79
	adrp	x19, .LANCHOR199
	add	x20, x19, :lo12:.LANCHOR199
	ldr	x1, [x24, #:lo12:.LANCHOR185]
	adrp	x21, .LANCHOR73
	ldr	x0, [x23, #:lo12:.LANCHOR79]
	add	x26, x21, :lo12:.LANCHOR73
	stp	x0, x1, [x20, 8]
	adrp	x1, .LANCHOR56
	adrp	x27, .LANCHOR43
	adrp	x28, .LANCHOR120
	ldrh	w2, [x1, #:lo12:.LANCHOR56]
	add	x26, x26, 32
	mov	w25, 0
	add	x27, x27, :lo12:.LANCHOR43
	add	x28, x28, :lo12:.LANCHOR120
	mov	w1, 0
	bl	ftl_memset
.L1449:
	ldrh	w0, [x27]
	cmp	w25, w0
	blt	.L1450
	add	x19, x19, :lo12:.LANCHOR199
	add	x20, x21, :lo12:.LANCHOR73
	mov	w2, 16
	mov	w1, 255
	adrp	x25, .LC28
	adrp	x27, .LANCHOR52
	ldr	x28, [x19, 16]
	add	x25, x25, :lo12:.LC28
	add	x27, x27, :lo12:.LANCHOR52
	mov	w26, 0
	mov	x0, x28
	bl	ftl_memset
	mov	w0, -3887
	strh	w0, [x28]
	ldr	w0, [x20, 8]
	str	w0, [x28, 4]
	ldrh	w0, [x21, #:lo12:.LANCHOR73]
	mov	w21, 0
	strh	w0, [x28, 2]
	ldrh	w0, [x20, 4]
	strh	w0, [x28, 8]
	ldrh	w0, [x20, 6]
	strh	w0, [x28, 10]
	adrp	x0, .LANCHOR35
	ldr	w0, [x0, #:lo12:.LANCHOR35]
	strh	w0, [x28, 12]
.L1451:
	ldrh	w4, [x28, 10]
	ldrh	w1, [x20]
	ldrh	w2, [x20, 2]
	ldrh	w3, [x20, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR79]
	str	x0, [x19, 8]
	ldr	x0, [x24, #:lo12:.LANCHOR185]
	str	x0, [x19, 16]
	orr	w0, w2, w1, lsl 10
	str	wzr, [x19]
	str	w0, [x19, 4]
	mov	x0, x25
	bl	printf
	mov	w3, 1
	mov	x0, x19
	mov	w1, w3
	mov	w2, w3
	bl	FlashProgPages
	ldrh	w0, [x27]
	ldrh	w1, [x20, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L1452
	ldr	w0, [x20, 8]
	mov	w2, 1
	ldrh	w1, [x20, 4]
	add	w0, w0, 1
	str	w0, [x20, 8]
	str	w0, [x28, 4]
	ldrh	w0, [x20]
	strh	w0, [x28, 8]
	strh	w0, [x20, 4]
	adrp	x0, .LANCHOR76
	strh	w1, [x20]
	lsl	w1, w1, 10
	ldr	x0, [x0, #:lo12:.LANCHOR76]
	str	w1, [x19, 4]
	strh	wzr, [x20, 2]
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
	mov	w3, 1
	mov	x0, x19
	mov	w2, w3
	mov	w1, w3
	bl	FlashProgPages
.L1452:
	ldrh	w0, [x20, 2]
	add	w0, w0, 1
	strh	w0, [x20, 2]
	ldr	w0, [x19]
	cmn	w0, #1
	bne	.L1453
	ldr	w1, [x19, 4]
	add	w21, w21, 1
	adrp	x0, .LC29
	and	w21, w21, 65535
	add	x0, x0, :lo12:.LC29
	bl	printf
	cmp	w21, 3
	bls	.L1451
	ldr	w1, [x19, 4]
	mov	w2, w21
	adrp	x0, .LC30
	add	x0, x0, :lo12:.LC30
	bl	printf
	mov	w0, 1
	str	w0, [x22, #:lo12:.LANCHOR75]
.L1448:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1450:
	ldrh	w2, [x28]
	ldr	x1, [x26], 8
	ldr	x0, [x20, 8]
	mul	w3, w2, w25
	lsl	w2, w2, 2
	add	w25, w25, 1
	add	x0, x0, x3, sxtw 2
	bl	ftl_memcpy
	b	.L1449
.L1453:
	cbnz	w26, .L1448
	mov	w26, 1
	b	.L1451
	.size	FtlBbmTblFlush, .-FtlBbmTblFlush
	.section	.text.allocate_data_superblock,"ax",@progbits
	.align	2
	.global	allocate_data_superblock
	.type	allocate_data_superblock, %function
allocate_data_superblock:
	adrp	x1, .LANCHOR75
	ldr	w1, [x1, #:lo12:.LANCHOR75]
	cbnz	w1, .L1521
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x27, x28, [sp, 80]
	adrp	x27, .LANCHOR84
	add	x0, x27, :lo12:.LANCHOR84
	stp	x23, x24, [sp, 48]
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR87
	add	x23, x0, :lo12:.LANCHOR87
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
.L1512:
	ldr	x1, [x29, 120]
	adrp	x0, .LANCHOR87
	adrp	x25, .LANCHOR38
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	ldrh	w1, [x1]
	add	w0, w0, w1
	ldrh	w1, [x25, #:lo12:.LANCHOR38]
	cmp	w0, w1
	ble	.L1461
	mov	w2, 2822
	adrp	x1, .LANCHOR200
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR200
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1461:
	adrp	x0, .LANCHOR92
	add	x0, x0, :lo12:.LANCHOR92
	cmp	x19, x0
	bne	.L1462
	adrp	x1, .LANCHOR170
	ldrh	w2, [x23]
	ldr	w3, [x1, #:lo12:.LANCHOR170]
	lsr	w0, w2, 1
	add	w4, w0, 1
	mul	w1, w2, w3
	add	w1, w4, w1, lsr 2
	adrp	x4, .LANCHOR101
	and	w1, w1, 65535
	ldr	w4, [x4, #:lo12:.LANCHOR101]
	cbz	w4, .L1463
	adrp	x4, .LANCHOR168
	ldr	w4, [x4, #:lo12:.LANCHOR168]
	cmp	w4, 29
	bhi	.L1463
	cmp	w4, 2
	bls	.L1496
	tbz	x2, 0, .L1492
	cbz	w3, .L1496
.L1492:
	mov	w1, w0
	b	.L1463
.L1462:
	ldrb	w0, [x19, 8]
	cmp	w0, 1
	bne	.L1496
	adrp	x0, .LANCHOR42
	ldrh	w0, [x0, #:lo12:.LANCHOR42]
	cmp	w0, 1
	beq	.L1496
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbnz	w0, .L1496
	adrp	x2, .LANCHOR101
	ldrh	w0, [x23]
	ldr	w2, [x2, #:lo12:.LANCHOR101]
	lsr	w1, w0, 3
	cbz	w2, .L1463
	adrp	x2, .LANCHOR168
	ldr	w2, [x2, #:lo12:.LANCHOR168]
	cmp	w2, 1
	bhi	.L1463
	mov	w1, 7
	mul	w1, w0, w1
	lsr	w1, w1, 3
.L1463:
	cbz	w1, .L1464
	sub	w1, w1, #1
	and	w1, w1, 65535
.L1464:
	ldrb	w2, [x19, 8]
	adrp	x0, .LANCHOR86
	add	x0, x0, :lo12:.LANCHOR86
	bl	List_pop_index_node
	and	w21, w0, 65535
	ldrh	w0, [x23]
	cbnz	w0, .L1465
	mov	w2, 2842
	adrp	x1, .LANCHOR200
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR200
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1465:
	ldrh	w0, [x23]
	sub	w0, w0, #1
	strh	w0, [x23]
	strh	w21, [x19]
	mov	x0, x19
	bl	make_superblock
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1466
	adrp	x0, .LANCHOR82
	ubfiz	x21, x21, 1, 16
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR82]
	strh	w1, [x0, x21]
	ldrh	w1, [x27, #:lo12:.LANCHOR84]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x25, #:lo12:.LANCHOR38]
	cmp	w0, w1
	ble	.L1512
	mov	w2, 2854
	adrp	x1, .LANCHOR200
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR200
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
	b	.L1512
.L1496:
	mov	w1, 0
	b	.L1464
.L1466:
	ldrh	w1, [x27, #:lo12:.LANCHOR84]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x25, #:lo12:.LANCHOR38]
	cmp	w0, w1
	ble	.L1468
	mov	w2, 2857
	adrp	x1, .LANCHOR200
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR200
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1468:
	adrp	x1, .LANCHOR36
	adrp	x24, .LANCHOR76
	mov	w2, 56
	mov	x3, 8
	ldrh	w1, [x1, #:lo12:.LANCHOR36]
	add	x26, x19, 16
	ldr	x4, [x24, #:lo12:.LANCHOR76]
	mov	x5, x26
	mov	w20, 0
	mov	w6, 65535
	add	x0, x4, 8
	umaddl	x1, w2, w1, x3
	add	x1, x4, x1
.L1469:
	cmp	x1, x0
	bne	.L1471
	cbnz	w20, .L1472
	mov	w2, 2869
	adrp	x1, .LANCHOR200
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR200
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1472:
	adrp	x0, .LANCHOR101
	uxtw	x22, w21
	adrp	x28, .LANCHOR77
	ldr	w0, [x0, #:lo12:.LANCHOR101]
	cbz	w0, .L1473
	adrp	x0, .LANCHOR90
	add	x0, x0, :lo12:.LANCHOR90
	cmp	x19, x0
	bne	.L1473
	ldr	x0, [x28, #:lo12:.LANCHOR77]
	ldrh	w0, [x0, x22, lsl 1]
	cmp	w0, 30
	bls	.L1473
	strb	wzr, [x19, 8]
.L1473:
	adrp	x0, .LANCHOR201
	ldrh	w0, [x0, #:lo12:.LANCHOR201]
	cmp	w0, w21
	bne	.L1474
	mov	w2, 2876
	adrp	x1, .LANCHOR200
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR200
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1474:
	ldrb	w0, [x19, 8]
	adrp	x6, .LANCHOR46
	adrp	x5, .LANCHOR165
	adrp	x4, .LANCHOR166
	cbnz	w0, .L1475
	ldr	x2, [x28, #:lo12:.LANCHOR77]
	lsl	x1, x22, 1
	ldrh	w0, [x2, x1]
	cbz	w0, .L1476
	ldrh	w7, [x6, #:lo12:.LANCHOR46]
	add	w0, w0, w7
.L1524:
	strh	w0, [x2, x1]
	mov	w1, 0
	ldr	w0, [x5, #:lo12:.LANCHOR165]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR165]
	mov	w0, w21
	bl	ftl_set_blk_mode
.L1478:
	ldr	x0, [x28, #:lo12:.LANCHOR77]
	lsl	x22, x22, 1
	ldrh	w1, [x0, x22]
	adrp	x0, .LANCHOR167
	ldr	w2, [x0, #:lo12:.LANCHOR167]
	cmp	w1, w2
	bls	.L1479
	str	w1, [x0, #:lo12:.LANCHOR167]
.L1479:
	ldr	w2, [x5, #:lo12:.LANCHOR165]
	mov	x3, 4
	ldr	w1, [x4, #:lo12:.LANCHOR166]
	ldrh	w0, [x6, #:lo12:.LANCHOR46]
	madd	w0, w0, w2, w1
	ldrh	w1, [x25, #:lo12:.LANCHOR38]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR202
	str	w0, [x1, #:lo12:.LANCHOR202]
	adrp	x0, .LANCHOR188
	ldr	x1, [x0, #:lo12:.LANCHOR188]
	ldr	w0, [x1, 16]
	add	w0, w0, 1
	str	w0, [x1, 16]
	mov	w1, 56
	ldr	x0, [x24, #:lo12:.LANCHOR76]
	nop // between mem op and mult-accumulate
	umaddl	x1, w1, w20, x3
	add	x2, x0, 4
	add	x1, x0, x1
.L1480:
	cmp	x1, x2
	bne	.L1481
	adrp	x1, .LANCHOR8
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	cbz	w1, .L1482
	ldrb	w1, [x19, 8]
	mov	w2, w20
	cmp	w1, 1
	bne	.L1483
	mov	w1, 0
.L1525:
	bl	FlashEraseBlocks
.L1482:
	ldrb	w1, [x19, 8]
	mov	w2, w20
	ldr	x0, [x24, #:lo12:.LANCHOR76]
	mov	x25, 0
	bl	FlashEraseBlocks
	mov	w1, 0
	mov	x3, 56
.L1484:
	cmp	w20, w25, uxth
	bhi	.L1486
	cbz	w1, .L1487
	mov	w0, w21
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1487:
	ldrb	w0, [x19, 7]
	adrp	x2, .LANCHOR82
	cbnz	w0, .L1488
	ldr	x0, [x2, #:lo12:.LANCHOR82]
	mov	w1, -1
	strh	w1, [x0, x22]
	b	.L1512
.L1471:
	ldrh	w3, [x5]
	stp	xzr, xzr, [x0]
	cmp	w3, w6
	beq	.L1470
	umaddl	x7, w20, w2, x4
	add	w20, w20, 1
	and	w20, w20, 65535
	lsl	w3, w3, 10
	str	w3, [x7, 4]
.L1470:
	add	x0, x0, 56
	add	x5, x5, 2
	b	.L1469
.L1476:
	mov	w0, 2
	b	.L1524
.L1475:
	ldr	x2, [x28, #:lo12:.LANCHOR77]
	lsl	x0, x22, 1
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	ldr	w0, [x4, #:lo12:.LANCHOR166]
	add	w0, w0, 1
	str	w0, [x4, #:lo12:.LANCHOR166]
	mov	w0, w21
	bl	ftl_set_blk_mode.part.9
	b	.L1478
.L1481:
	ldr	w3, [x2]
	and	w3, w3, -1024
	str	w3, [x2], 56
	b	.L1480
.L1483:
	mov	w1, 1
	b	.L1525
.L1486:
	mul	x0, x25, x3
	ldr	x2, [x24, #:lo12:.LANCHOR76]
	add	x4, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L1485
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
.L1485:
	add	x25, x25, 1
	add	x26, x26, 2
	b	.L1484
.L1488:
	adrp	x1, .LANCHOR51
	adrp	x3, .LANCHOR157
	strb	wzr, [x19, 6]
	ldrh	w1, [x1, #:lo12:.LANCHOR51]
	strh	wzr, [x19, 2]
	strh	w21, [x19]
	mul	w0, w0, w1
	ldr	w1, [x3, #:lo12:.LANCHOR157]
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x3, #:lo12:.LANCHOR157]
	ldr	x1, [x2, #:lo12:.LANCHOR82]
	and	w0, w0, 65535
	strh	w0, [x19, 4]
	strh	w0, [x1, x22]
	ldrh	w0, [x19, 4]
	cbz	w0, .L1489
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1460
.L1489:
	mov	w2, 2935
	adrp	x1, .LANCHOR200
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR200
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1460:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1521:
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
	adrp	x21, .LANCHOR114
	stp	x25, x26, [sp, 64]
	and	w25, w0, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR114]
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	str	x27, [sp, 80]
	cbz	w0, .L1527
	adrp	x23, .LANCHOR115
	add	x24, x23, :lo12:.LANCHOR115
	mov	w19, 0
.L1528:
	adrp	x0, .LANCHOR36
	ldrh	w0, [x0, #:lo12:.LANCHOR36]
	cmp	w0, w19
	bhi	.L1534
	bl	FtlGcReFreshBadBlk
.L1527:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1534:
	adrp	x0, .LANCHOR45
	add	x0, x0, :lo12:.LANCHOR45
	mov	w1, w25
	add	x22, x21, :lo12:.LANCHOR114
	mov	w20, 0
	ldrb	w0, [x0, w19, sxtw]
	bl	V2P_block
	and	w26, w0, 65535
.L1529:
	ldrh	w0, [x22]
	cmp	w0, w20
	bhi	.L1533
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1528
.L1533:
	add	x0, x23, :lo12:.LANCHOR115
	add	w27, w20, 1
	ldrh	w0, [x0, w20, sxtw 1]
	cmp	w0, w26
	bne	.L1530
	mov	w0, w26
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	w1, [x22]
	sxtw	x3, w27
	and	x4, x20, 65535
	mov	x0, 0
.L1531:
	add	w2, w20, w0
	cmp	w1, w2, uxth
	bhi	.L1532
	sub	w1, w1, #1
	strh	w1, [x22]
.L1530:
	and	w20, w27, 65535
	b	.L1529
.L1532:
	add	x2, x3, x0
	ldrh	w5, [x24, x2, lsl 1]
	add	x2, x4, x0
	add	x0, x0, 1
	strh	w5, [x24, x2, lsl 1]
	b	.L1531
	.size	FtlGcFreeBadSuperBlk, .-FtlGcFreeBadSuperBlk
	.section	.text.update_vpc_list,"ax",@progbits
	.align	2
	.global	update_vpc_list
	.type	update_vpc_list, %function
update_vpc_list:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR82
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR82]
	ubfiz	x0, x19, 1, 16
	ldrh	w0, [x1, x0]
	cbnz	w0, .L1540
	adrp	x0, .LANCHOR201
	ldrh	w1, [x0, #:lo12:.LANCHOR201]
	cmp	w1, w19
	bne	.L1541
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR201]
.L1542:
	adrp	x20, .LANCHOR84
	mov	w1, w19
	adrp	x0, .LANCHOR81
	add	x0, x0, :lo12:.LANCHOR81
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR84]
	cbnz	w0, .L1544
	mov	w2, 3046
	adrp	x1, .LANCHOR203
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR203
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1544:
	ldrh	w0, [x20, #:lo12:.LANCHOR84]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR84]
	mov	w0, w19
	bl	free_data_superblock
	mov	w0, w19
	bl	FtlGcFreeBadSuperBlk
	adrp	x0, .LANCHOR87
	ldrh	w1, [x20, #:lo12:.LANCHOR84]
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	add	w0, w0, w1
	adrp	x1, .LANCHOR38
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	cmp	w0, w1
	ble	.L1548
	mov	w2, 3049
	adrp	x1, .LANCHOR203
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR203
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1548:
	mov	w0, 1
	b	.L1539
.L1541:
	adrp	x0, .LANCHOR90
	ldrh	w0, [x0, #:lo12:.LANCHOR90]
	cmp	w0, w19
	beq	.L1547
	adrp	x0, .LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w0, w19
	beq	.L1547
	adrp	x0, .LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w0, w19
	bne	.L1542
.L1547:
	mov	w0, 0
.L1539:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1540:
	mov	w0, w19
	bl	List_update_data_list
	b	.L1547
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
	str	x21, [sp, 32]
	mov	w0, 65535
	cmp	w19, w0
	beq	.L1551
	adrp	x21, .LANCHOR82
	ubfiz	x20, x19, 1, 16
	ldr	x1, [x21, #:lo12:.LANCHOR82]
	ldrh	w0, [x1, x20]
	cbnz	w0, .L1552
	mov	w2, 0
	mov	w1, w19
	adrp	x0, .LC31
	add	x0, x0, :lo12:.LC31
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR82]
	ldrh	w0, [x0, x20]
	cbz	w0, .L1553
.L1558:
	mov	w20, 0
.L1550:
	mov	w0, w20
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1553:
	mov	w2, 3064
	adrp	x1, .LANCHOR204
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR204
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
	b	.L1558
.L1552:
	sub	w0, w0, #1
	strh	w0, [x1, x20]
.L1551:
	adrp	x21, .LANCHOR130
	mov	w1, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR130]
	cmp	w0, w1
	bne	.L1555
	strh	w19, [x21, #:lo12:.LANCHOR130]
	b	.L1558
.L1555:
	cmp	w19, w0
	beq	.L1558
	bl	update_vpc_list
	cmp	w0, 0
	adrp	x1, .LANCHOR80
	adrp	x0, .LANCHOR81
	strh	w19, [x21, #:lo12:.LANCHOR130]
	cset	w20, ne
	ldr	x1, [x1, #:lo12:.LANCHOR80]
	ldr	x0, [x0, #:lo12:.LANCHOR81]
	sub	x0, x0, x1
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	adrp	x1, .LANCHOR82
	ldr	x1, [x1, #:lo12:.LANCHOR82]
	and	x2, x0, 65535
	ldrh	w1, [x1, x2, lsl 1]
	cbnz	w1, .L1550
	cmp	w19, w0, uxth
	beq	.L1550
	mov	w2, 3086
	adrp	x1, .LANCHOR204
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR204
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
	b	.L1550
	.size	decrement_vpc_count, .-decrement_vpc_count
	.section	.text.FtlSlcSuperblockCheck,"ax",@progbits
	.align	2
	.global	FtlSlcSuperblockCheck
	.type	FtlSlcSuperblockCheck, %function
FtlSlcSuperblockCheck:
	ldrh	w1, [x0, 4]
	cbz	w1, .L1571
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, 65535
	ldrh	w1, [x0]
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	cmp	w1, w20
	beq	.L1559
	mov	x19, x0
	ldrb	w0, [x0, 6]
	adrp	x22, .LANCHOR8
	adrp	x21, .LANCHOR117
	add	x0, x0, 8
	add	x23, x22, :lo12:.LANCHOR8
	add	x21, x21, :lo12:.LANCHOR117
	ldrh	w0, [x19, x0, lsl 1]
.L1563:
	cmp	w0, w20
	beq	.L1565
	ldrb	w0, [x19, 8]
	cmp	w0, 1
	bne	.L1566
	ldrb	w1, [x23]
	cbnz	w1, .L1566
	ldrh	w1, [x19, 2]
	ldrh	w1, [x21, x1, lsl 1]
	cmp	w1, w20
	bne	.L1566
	ldrh	w0, [x19, 4]
	sub	w0, w0, #1
	strh	w0, [x19, 4]
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1565
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
.L1574:
	strh	w0, [x19, 2]
	strb	wzr, [x19, 6]
.L1559:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1565:
	ldrb	w0, [x19, 6]
	adrp	x1, .LANCHOR36
	add	w0, w0, 1
	ldrh	w1, [x1, #:lo12:.LANCHOR36]
	and	w0, w0, 255
	strb	w0, [x19, 6]
	cmp	w1, w0
	bne	.L1564
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L1564:
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w0, [x19, x0, lsl 1]
	b	.L1563
.L1566:
	ldrb	w1, [x22, #:lo12:.LANCHOR8]
	cbz	w1, .L1559
	cmp	w0, 1
	bne	.L1559
	adrp	x0, .LANCHOR52
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bcc	.L1559
	ldrh	w0, [x19]
	adrp	x1, .LANCHOR82
	ldrh	w3, [x19, 4]
	ldr	x2, [x1, #:lo12:.LANCHOR82]
	lsl	x0, x0, 1
	ldrh	w1, [x2, x0]
	sub	w1, w1, w3
	strh	w1, [x2, x0]
	adrp	x0, .LANCHOR51
	strh	wzr, [x19, 4]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	b	.L1574
.L1571:
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
	bne	.L1576
	mov	w2, 2986
	adrp	x1, .LANCHOR205
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR205
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1576:
	adrp	x20, .LANCHOR51
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR51]
	cmp	w1, w0
	bne	.L1577
	mov	w2, 2987
	adrp	x1, .LANCHOR205
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR205
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1577:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1578
	mov	w2, 2988
	adrp	x1, .LANCHOR205
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR205
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1578:
	ldrb	w0, [x19, 6]
	adrp	x21, .LANCHOR36
	strb	wzr, [x19, 10]
	adrp	x23, .LANCHOR8
	add	x0, x0, 8
	adrp	x24, .LANCHOR117
	add	x23, x23, :lo12:.LANCHOR8
	add	x24, x24, :lo12:.LANCHOR117
	add	x25, x21, :lo12:.LANCHOR36
	ldrh	w22, [x19, x0, lsl 1]
.L1579:
	mov	w2, 65535
	cmp	w22, w2
	beq	.L1580
	ldrb	w0, [x19, 8]
	ldrh	w1, [x19, 4]
	cmp	w0, 1
	ldrh	w0, [x19, 2]
	bne	.L1582
	ldrb	w3, [x23]
	cbnz	w3, .L1582
	ldrh	w3, [x24, w0, sxtw 1]
	cmp	w3, w2
	bne	.L1582
	ldrh	w0, [x19]
	sub	w1, w1, #1
	strh	w1, [x19, 4]
	bl	decrement_vpc_count
.L1580:
	ldrb	w0, [x19, 6]
	ldrh	w1, [x25]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x19, 6]
	cmp	w1, w0
	bne	.L1581
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L1581:
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w22, [x19, x0, lsl 1]
	b	.L1579
.L1582:
	adrp	x23, .LANCHOR8
	adrp	x24, .LANCHOR117
	orr	w22, w0, w22, lsl 10
	add	x23, x23, :lo12:.LANCHOR8
	add	x24, x24, :lo12:.LANCHOR117
	sub	w1, w1, #1
	strh	w1, [x19, 4]
.L1583:
	ldrb	w0, [x19, 6]
	mov	w1, 65535
	ldrh	w3, [x21, #:lo12:.LANCHOR36]
.L1585:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, w3
	bne	.L1584
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	w0, 0
.L1584:
	add	x2, x19, x0, sxtw 1
	ldrh	w2, [x2, 16]
	cmp	w2, w1
	beq	.L1585
	strb	w0, [x19, 6]
	ldrb	w0, [x19, 8]
	cmp	w0, 1
	bne	.L1586
	ldrb	w2, [x23]
	ldrh	w0, [x19, 2]
	cbnz	w2, .L1587
	ldrh	w0, [x24, w0, sxtw 1]
	cmp	w0, w1
	bne	.L1586
	ldrh	w0, [x19, 4]
	cbz	w0, .L1586
	sub	w0, w0, #1
	strh	w0, [x19, 4]
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	b	.L1583
.L1587:
	adrp	x1, .LANCHOR52
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	cmp	w0, w1
	bcc	.L1586
	ldrh	w0, [x19]
	adrp	x1, .LANCHOR82
	ldrh	w3, [x19, 4]
	ldr	x2, [x1, #:lo12:.LANCHOR82]
	lsl	x0, x0, 1
	ldrh	w1, [x2, x0]
	sub	w1, w1, w3
	strh	w1, [x2, x0]
	strh	wzr, [x19, 4]
	ldrh	w0, [x20, #:lo12:.LANCHOR51]
	strh	w0, [x19, 2]
	strb	wzr, [x19, 6]
.L1586:
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR51]
	cmp	w1, w0
	bne	.L1575
	ldrh	w0, [x19, 4]
	cbz	w0, .L1575
	mov	w2, 3032
	adrp	x1, .LANCHOR205
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR205
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1575:
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
	adrp	x23, .LANCHOR75
	stp	x19, x20, [sp, 16]
	ldr	w0, [x23, #:lo12:.LANCHOR75]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	str	x23, [x29, 104]
	cbnz	w0, .L1600
	adrp	x25, .LANCHOR185
	adrp	x28, .LANCHOR199
	adrp	x27, .LANCHOR206
	add	x21, x28, :lo12:.LANCHOR199
	ldr	x20, [x25, #:lo12:.LANCHOR185]
	adrp	x24, .LANCHOR79
	ldrh	w2, [x27, #:lo12:.LANCHOR206]
	add	x1, x27, :lo12:.LANCHOR206
	ldr	x0, [x24, #:lo12:.LANCHOR79]
	mov	w3, 19539
	stp	x0, x20, [x21, 8]
	movk	w3, 0x4654, lsl 16
	strh	w2, [x20, 2]
	mov	w2, -3932
	strh	w2, [x20]
	adrp	x22, .LANCHOR157
	ldr	w2, [x1, 8]
	adrp	x26, .LANCHOR38
	ldrh	w1, [x1, 6]
	stp	w2, wzr, [x20, 4]
	adrp	x2, .LANCHOR135
	add	x19, x2, :lo12:.LANCHOR135
	str	wzr, [x20, 12]
	str	w3, [x2, #:lo12:.LANCHOR135]
	mov	w2, 71
	movk	w2, 0x5000, lsl 16
	strh	w1, [x19, 8]
	adrp	x1, .LANCHOR43
	str	w2, [x19, 4]
	adrp	x2, .LANCHOR90
	ldrh	w1, [x1, #:lo12:.LANCHOR43]
	strb	w1, [x19, 10]
	add	x1, x2, :lo12:.LANCHOR90
	ldrh	w2, [x2, #:lo12:.LANCHOR90]
	strh	w2, [x19, 14]
	ldrb	w3, [x1, 6]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x19, 11]
	orr	w2, w3, w2, lsl 6
	strh	w2, [x19, 16]
	adrp	x2, .LANCHOR91
	add	x1, x2, :lo12:.LANCHOR91
	ldrh	w2, [x2, #:lo12:.LANCHOR91]
	ldrb	w3, [x1, 6]
	strh	w2, [x19, 18]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x19, 12]
	orr	w2, w3, w2, lsl 6
	strh	w2, [x19, 20]
	adrp	x2, .LANCHOR92
	add	x1, x2, :lo12:.LANCHOR92
	ldrh	w2, [x2, #:lo12:.LANCHOR92]
	strh	w2, [x19, 22]
	ldrb	w3, [x1, 6]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x19, 13]
	adrp	x1, .LANCHOR165
	orr	w2, w3, w2, lsl 6
	strh	w2, [x19, 24]
	ldr	w1, [x1, #:lo12:.LANCHOR165]
	str	w1, [x19, 32]
	ldr	w1, [x22, #:lo12:.LANCHOR157]
	str	w1, [x19, 40]
	adrp	x1, .LANCHOR158
	ldr	w1, [x1, #:lo12:.LANCHOR158]
	str	w1, [x19, 36]
	adrp	x1, .LANCHOR56
	ldrh	w2, [x1, #:lo12:.LANCHOR56]
	mov	w1, 255
	bl	ftl_memset
	ldr	x0, [x21, 8]
	mov	x1, x19
	mov	w2, 48
	mov	x19, x28
	bl	ftl_memcpy
	adrp	x1, .LANCHOR82
	ldrh	w2, [x26, #:lo12:.LANCHOR38]
	ldr	x0, [x21, 8]
	ldr	x1, [x1, #:lo12:.LANCHOR82]
	lsl	w2, w2, 1
	add	x0, x0, 48
	bl	ftl_memcpy
	ldrh	w0, [x26, #:lo12:.LANCHOR38]
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
	adrp	x0, .LANCHOR68
	ldrh	w0, [x0, #:lo12:.LANCHOR68]
	cbz	w0, .L1601
	ldrh	w0, [x26, #:lo12:.LANCHOR38]
	adrp	x1, .LANCHOR65
	ldr	x3, [x21, 8]
	ldrh	w2, [x1, #:lo12:.LANCHOR65]
	lsr	w1, w0, 3
	add	w0, w1, w0, lsl 1
	adrp	x1, .LANCHOR128
	add	w0, w0, 52
	lsl	w2, w2, 2
	ldr	x1, [x1, #:lo12:.LANCHOR128]
	and	x0, x0, 65532
	add	x0, x3, x0
	bl	ftl_memcpy
.L1601:
	mov	w0, 0
	add	x28, x19, :lo12:.LANCHOR199
	bl	FtlUpdateVaildLpn
	add	x23, x27, :lo12:.LANCHOR206
	mov	w21, 0
	adrp	x27, .LANCHOR52
	mov	w26, 65535
	add	x0, x27, :lo12:.LANCHOR52
	str	x0, [x29, 96]
.L1602:
	ldr	x0, [x24, #:lo12:.LANCHOR79]
	mov	w3, 1
	str	x0, [x28, 8]
	mov	w2, w3
	ldr	x0, [x25, #:lo12:.LANCHOR185]
	ldrh	w1, [x23, 2]
	str	x0, [x28, 16]
	ldrh	w0, [x23]
	orr	w0, w1, w0, lsl 10
	mov	w1, w3
	str	w0, [x28, 4]
	mov	x0, x28
	bl	FlashProgPages
	ldrh	w0, [x27, #:lo12:.LANCHOR52]
	ldrh	w1, [x23, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L1603
	ldrh	w0, [x23]
	ldrh	w26, [x23, 4]
	strh	wzr, [x23, 2]
	strh	w0, [x23, 4]
	bl	FtlFreeSysBlkQueueOut
	strh	w0, [x23]
	ldr	w1, [x22, #:lo12:.LANCHOR157]
	mov	w3, 1
	str	w1, [x23, 8]
	add	w2, w1, 1
	str	w2, [x22, #:lo12:.LANCHOR157]
	ubfiz	w2, w0, 10, 16
	str	w2, [x28, 4]
	strh	w0, [x20, 2]
	mov	w2, w3
	str	w1, [x20, 4]
	mov	x0, x28
	mov	w1, w3
	bl	FlashProgPages
.L1603:
	ldrh	w0, [x23, 2]
	ldr	w1, [x28]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x23, 2]
	cmn	w1, #1
	bne	.L1604
	cmp	w0, 1
	bne	.L1605
	mov	w2, 1180
	adrp	x1, .LANCHOR207
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR207
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1605:
	ldrh	w0, [x23, 2]
	cmp	w0, 1
	bne	.L1606
	ldr	x0, [x29, 96]
	ldrh	w0, [x0]
	sub	w0, w0, #1
	strh	w0, [x23, 2]
.L1606:
	add	w21, w21, 1
	and	w21, w21, 65535
	cmp	w21, 3
	bls	.L1602
	add	x19, x19, :lo12:.LANCHOR199
	mov	w2, w21
	adrp	x0, .LC32
	add	x0, x0, :lo12:.LC32
	ldr	w1, [x19, 4]
	bl	printf
	ldr	x1, [x29, 104]
	mov	w0, 1
	str	w0, [x1, #:lo12:.LANCHOR75]
.L1600:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1604:
	cmp	w0, 1
	beq	.L1602
	cmp	w1, 256
	beq	.L1602
	mov	w0, 65535
	cmp	w26, w0
	beq	.L1600
	mov	w1, 1
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
	b	.L1600
	.size	FtlVpcTblFlush, .-FtlVpcTblFlush
	.section	.text.FtlSuperblockPowerLostFix,"ax",@progbits
	.align	2
	.global	FtlSuperblockPowerLostFix
	.type	FtlSuperblockPowerLostFix, %function
FtlSuperblockPowerLostFix:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	adrp	x0, .LANCHOR8
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L1628
	ldrb	w20, [x19, 8]
	cmp	w20, 1
	bne	.L1628
	ldrh	w21, [x19, 4]
.L1620:
	adrp	x22, .LANCHOR158
	add	x22, x22, :lo12:.LANCHOR158
	mov	w24, -1
	adrp	x23, .LANCHOR79
.L1621:
	sub	w21, w21, #1
	cmn	w21, #1
	beq	.L1623
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1622
.L1623:
	ldrh	w0, [x19]
	adrp	x1, .LANCHOR82
	ldrh	w3, [x19, 4]
	ldr	x2, [x1, #:lo12:.LANCHOR82]
	lsl	x0, x0, 1
	ldrh	w1, [x2, x0]
	sub	w1, w1, w3
	strh	w1, [x2, x0]
	adrp	x0, .LANCHOR51
	strb	wzr, [x19, 6]
	strh	wzr, [x19, 4]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	strh	w0, [x19, 2]
	ldp	x21, x22, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 128
	ret
.L1628:
	mov	w20, 0
	mov	w21, 12
	b	.L1620
.L1622:
	mov	x0, x19
	bl	get_new_active_ppa
	str	w0, [x29, 76]
	cmn	w0, #1
	beq	.L1623
	ldr	x0, [x23, #:lo12:.LANCHOR79]
	mov	w3, 0
	str	x0, [x29, 80]
	mov	w2, w20
	adrp	x0, .LANCHOR185
	str	w24, [x29, 96]
	ldr	x1, [x0, #:lo12:.LANCHOR185]
	str	x1, [x29, 88]
	ldrh	w0, [x19]
	strh	w0, [x1, 2]
	ldr	w0, [x22]
	stp	w0, w24, [x1, 4]
	add	w0, w0, 1
	strh	wzr, [x1]
	cmn	w0, #1
	str	w24, [x1, 12]
	csel	w0, w0, wzr, ne
	mov	w1, 1
	str	w0, [x22]
	add	x0, x29, 72
	bl	FlashProgPages
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	b	.L1621
	.size	FtlSuperblockPowerLostFix, .-FtlSuperblockPowerLostFix
	.section	.text.FtlLoadFactoryBbt,"ax",@progbits
	.align	2
	.global	FtlLoadFactoryBbt
	.type	FtlLoadFactoryBbt, %function
FtlLoadFactoryBbt:
	stp	x29, x30, [sp, -112]!
	adrp	x2, .LANCHOR79
	adrp	x0, .LANCHOR199
	add	x1, x0, :lo12:.LANCHOR199
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR79]
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR49
	stp	x27, x28, [sp, 80]
	add	x28, x26, :lo12:.LANCHOR49
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR73
	stp	x23, x24, [sp, 48]
	add	x20, x20, :lo12:.LANCHOR73
	str	x2, [x1, 8]
	adrp	x2, .LANCHOR185
	adrp	x23, .LANCHOR43
	add	x20, x20, 12
	ldr	x25, [x2, #:lo12:.LANCHOR185]
	add	x23, x23, :lo12:.LANCHOR43
	mov	w21, 0
	mov	w27, -1
	str	x25, [x1, 16]
.L1635:
	ldrh	w0, [x23]
	cmp	w21, w0
	bcc	.L1640
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1640:
	ldrh	w19, [x26, #:lo12:.LANCHOR49]
	add	x24, x22, :lo12:.LANCHOR199
	strh	w27, [x20]
	mov	w3, 61664
	sub	w19, w19, #1
	and	w19, w19, 65535
.L1636:
	ldrh	w0, [x28]
	sub	w1, w0, #15
	cmp	w1, w19
	bgt	.L1638
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
	beq	.L1637
	ldrh	w0, [x25]
	cmp	w0, w3
	bne	.L1637
	strh	w19, [x20]
.L1638:
	add	w21, w21, 1
	add	x20, x20, 2
	b	.L1635
.L1637:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1636
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
	bne	.L1646
	adrp	x1, .LANCHOR52
	ldrh	w19, [x1, #:lo12:.LANCHOR52]
.L1647:
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
	bne	.L1648
	mov	w22, 0
	mov	w24, 2
.L1649:
	cmp	w22, w19
	ble	.L1652
.L1648:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 192
	ret
.L1646:
	adrp	x1, .LANCHOR51
	ldrh	w19, [x1, #:lo12:.LANCHOR51]
	b	.L1647
.L1652:
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
	bne	.L1650
	ldr	w0, [x29, 132]
	cmn	w0, #1
	bne	.L1650
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L1650
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L1649
.L1650:
	add	w20, w20, 1
	sxth	w22, w20
	b	.L1649
	.size	FtlGetLastWrittenPage, .-FtlGetLastWrittenPage
	.section	.text.FtlLoadBbt,"ax",@progbits
	.align	2
	.global	FtlLoadBbt
	.type	FtlLoadBbt, %function
FtlLoadBbt:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR185
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR199
	add	x20, x22, :lo12:.LANCHOR199
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR49
	ldr	x21, [x0, #:lo12:.LANCHOR185]
	str	x25, [sp, 64]
	mov	w24, 61649
	stp	xzr, x21, [x20, 8]
	bl	FtlBbtMemInit
	ldrh	w19, [x23, #:lo12:.LANCHOR49]
	add	x23, x23, :lo12:.LANCHOR49
	sub	w19, w19, #1
	and	w19, w19, 65535
.L1658:
	ldrh	w0, [x23]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L1661
	lsl	w0, w19, 10
	mov	w2, 1
	str	w0, [x20, 4]
	mov	w1, w2
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L1659
	ldr	w0, [x20, 4]
	mov	w2, 1
	mov	w1, w2
	add	w0, w0, 1
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
.L1659:
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L1660
	ldrh	w0, [x21]
	cmp	w0, w24
	bne	.L1660
	adrp	x1, .LANCHOR73
	add	x0, x1, :lo12:.LANCHOR73
	strh	w19, [x1, #:lo12:.LANCHOR73]
	ldr	w1, [x21, 4]
	str	w1, [x0, 8]
	ldrh	w1, [x21, 8]
	strh	w1, [x0, 4]
.L1661:
	adrp	x19, .LANCHOR73
	mov	w0, 65535
	add	x20, x19, :lo12:.LANCHOR73
	ldrh	w1, [x19, #:lo12:.LANCHOR73]
	cmp	w1, w0
	beq	.L1675
	ldrh	w1, [x20, 4]
	cmp	w1, w0
	beq	.L1665
	add	x0, x22, :lo12:.LANCHOR199
	lsl	w1, w1, 10
	mov	w2, 1
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashReadPages
	ldr	w0, [x22, #:lo12:.LANCHOR199]
	cmn	w0, #1
	beq	.L1665
	ldrh	w1, [x21]
	mov	w0, 61649
	cmp	w1, w0
	bne	.L1665
	ldr	w1, [x20, 8]
	ldr	w0, [x21, 4]
	cmp	w0, w1
	bls	.L1665
	ldrh	w1, [x20, 4]
	str	w0, [x20, 8]
	ldrh	w0, [x21, 8]
	strh	w1, [x19, #:lo12:.LANCHOR73]
	strh	w0, [x20, 4]
.L1665:
	ldrh	w0, [x19, #:lo12:.LANCHOR73]
	add	x23, x19, :lo12:.LANCHOR73
	mov	w1, 1
	adrp	x24, .LANCHOR79
	mov	w25, 61649
	bl	FtlGetLastWrittenPage
	sxth	w20, w0
	add	w0, w0, 1
	strh	w0, [x23, 2]
	add	x23, x22, :lo12:.LANCHOR199
.L1667:
	tbz	w20, #31, .L1670
	mov	w2, 335
	adrp	x1, .LANCHOR208
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR208
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1669:
	add	x0, x19, :lo12:.LANCHOR73
	ldrh	w1, [x21, 10]
	strh	w1, [x0, 6]
	mov	w1, 65535
	ldrh	w0, [x21, 12]
	cmp	w0, w1
	beq	.L1672
	adrp	x1, .LANCHOR35
	ldr	w2, [x1, #:lo12:.LANCHOR35]
	cmp	w0, w2
	beq	.L1672
	adrp	x1, .LANCHOR39
	ldrh	w1, [x1, #:lo12:.LANCHOR39]
	lsr	w1, w1, 2
	cmp	w2, w1
	bcs	.L1672
	cmp	w0, w1
	bcs	.L1672
	bl	FtlSysBlkNumInit
.L1672:
	add	x19, x19, :lo12:.LANCHOR73
	adrp	x21, .LANCHOR43
	adrp	x23, .LANCHOR120
	add	x19, x19, 32
	add	x21, x21, :lo12:.LANCHOR43
	add	x23, x23, :lo12:.LANCHOR120
	add	x22, x22, :lo12:.LANCHOR199
	mov	w20, 0
.L1673:
	ldrh	w0, [x21]
	cmp	w20, w0
	bcc	.L1674
	mov	w0, 0
.L1657:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1660:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1658
.L1670:
	ldrh	w0, [x19, #:lo12:.LANCHOR73]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w20, w0, lsl 10
	str	w0, [x23, 4]
	ldr	x0, [x24, #:lo12:.LANCHOR79]
	str	x0, [x23, 8]
	mov	x0, x23
	bl	FlashReadPages
	ldr	w0, [x23]
	cmn	w0, #1
	beq	.L1668
	ldrh	w0, [x21]
	cmp	w0, w25
	beq	.L1669
.L1668:
	sub	w20, w20, #1
	sxth	w20, w20
	b	.L1667
.L1674:
	ldrh	w2, [x23]
	ldr	x0, [x22, 8]
	mul	w1, w2, w20
	lsl	w2, w2, 2
	add	w20, w20, 1
	add	x1, x0, x1, lsl 2
	ldr	x0, [x19], 8
	bl	ftl_memcpy
	b	.L1673
.L1675:
	mov	w0, -1
	b	.L1657
	.size	FtlLoadBbt, .-FtlLoadBbt
	.section	.text.ftl_map_blk_gc,"ax",@progbits
	.align	2
	.global	ftl_map_blk_gc
	.type	ftl_map_blk_gc, %function
ftl_map_blk_gc:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR52
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldr	x20, [x0, 16]
	ldr	x22, [x0, 40]
	bl	ftl_free_no_use_map_blk
	ldrh	w4, [x19, 10]
	ldrh	w2, [x19, 8]
	sub	w1, w4, #4
	cmp	w2, w1
	ldrh	w1, [x19, 60]
	bge	.L1688
	mov	w2, 65535
	cmp	w1, w2
	beq	.L1690
	ldrh	w3, [x19, 2]
	ldrh	w2, [x21, #:lo12:.LANCHOR52]
	cmp	w3, w2
	bcc	.L1691
.L1688:
	mov	w2, 65535
	and	w0, w0, 65535
	cmp	w1, w2
	beq	.L1692
	ldrh	w3, [x19, 2]
	ldrh	w2, [x21, #:lo12:.LANCHOR52]
	cmp	w2, w3
	bls	.L1693
.L1692:
	ubfiz	x0, x0, 1, 32
	ldrh	w23, [x20, x0]
	cbz	w23, .L1690
	ldr	w1, [x19, 52]
	cbnz	w1, .L1690
	mov	w1, 1
	str	w1, [x19, 52]
	strh	wzr, [x20, x0]
	ldrh	w0, [x19, 8]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	ldrh	w0, [x21, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bcc	.L1698
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L1698:
	adrp	x26, .LANCHOR199
	adrp	x25, .LC34
	add	x24, x26, :lo12:.LANCHOR199
	add	x25, x25, :lo12:.LC34
	mov	w20, 0
.L1699:
	ldrh	w0, [x19, 6]
	cmp	w0, w20
	bhi	.L1703
	mov	w1, 1
	mov	w0, w23
	bl	FtlFreeSysBlkQueueIn
	str	wzr, [x19, 52]
.L1690:
	ldrh	w1, [x19, 2]
	ldrh	w0, [x21, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bcc	.L1691
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L1691:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1696:
	ldrh	w6, [x20, x2, lsl 1]
	add	x5, x2, 1
	cmp	w6, w1
	beq	.L1694
	mov	x2, x5
.L1695:
	and	w23, w2, 65535
	cmp	w23, w4
	bcc	.L1696
	mov	w23, w0
.L1694:
	and	x2, x2, 65535
	adrp	x0, .LC33
	add	x0, x0, :lo12:.LC33
	ldrh	w2, [x20, x2, lsl 1]
	bl	printf
	mov	w0, -1
	strh	w0, [x19, 60]
	mov	w0, w23
	b	.L1692
.L1693:
	mov	x2, 0
	b	.L1695
.L1703:
	ubfiz	x27, x20, 2, 16
	ldr	w1, [x22, x27]
	cmp	w23, w1, lsr 10
	bne	.L1700
	adrp	x2, .LANCHOR181
	add	x0, x26, :lo12:.LANCHOR199
	ldr	x2, [x2, #:lo12:.LANCHOR181]
	str	x2, [x0, 8]
	adrp	x2, .LANCHOR185
	str	w1, [x0, 4]
	ldr	x28, [x2, #:lo12:.LANCHOR185]
	mov	w2, 1
	str	x28, [x0, 16]
	mov	w1, w2
	bl	FlashReadPages
	ldrh	w0, [x28, 8]
	cmp	w0, w20
	beq	.L1701
	mov	w2, 638
	adrp	x1, .LANCHOR209
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR209
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1701:
	ldr	w0, [x24]
	cmn	w0, #1
	bne	.L1702
	str	wzr, [x22, x27]
	mov	x0, x25
	ldrh	w2, [x28, 8]
	ldr	w1, [x24, 4]
	bl	printf
	adrp	x0, .LANCHOR75
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR75]
.L1700:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1699
.L1702:
	ldr	x2, [x24, 8]
	mov	w1, w20
	mov	x0, x19
	bl	FtlMapWritePage
	b	.L1700
	.size	ftl_map_blk_gc, .-ftl_map_blk_gc
	.section	.text.Ftl_write_map_blk_to_last_page,"ax",@progbits
	.align	2
	.global	Ftl_write_map_blk_to_last_page
	.type	Ftl_write_map_blk_to_last_page, %function
Ftl_write_map_blk_to_last_page:
	adrp	x1, .LANCHOR75
	ldr	w1, [x1, #:lo12:.LANCHOR75]
	cbnz	w1, .L1719
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
	bne	.L1710
	ldrh	w0, [x19, 8]
	cbz	w0, .L1711
	mov	w2, 670
	adrp	x1, .LANCHOR210
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR210
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1711:
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
.L1709:
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1710:
	ubfiz	x0, x0, 1, 16
	adrp	x1, .LANCHOR185
	adrp	x23, .LANCHOR79
	ldr	x22, [x19, 40]
	ldr	x1, [x1, #:lo12:.LANCHOR185]
	ldrh	w21, [x20, x0]
	adrp	x20, .LANCHOR199
	ldrh	w0, [x19, 2]
	add	x2, x20, :lo12:.LANCHOR199
	orr	w0, w0, w21, lsl 10
	str	w0, [x2, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR79]
	str	x1, [x2, 16]
	str	x0, [x2, 8]
	ldr	w2, [x19, 48]
	str	w2, [x1, 4]
	mov	w2, -1291
	strh	w2, [x1, 8]
	ldrh	w2, [x19, 4]
	strh	w2, [x1]
	strh	w21, [x1, 2]
	adrp	x1, .LANCHOR52
	ldrh	w2, [x1, #:lo12:.LANCHOR52]
	mov	w1, 255
	lsl	w2, w2, 3
	bl	ftl_memset
	ldrh	w4, [x19, 6]
	mov	x1, 0
	ldr	x3, [x23, #:lo12:.LANCHOR79]
	mov	w2, 0
.L1712:
	cmp	w4, w1, uxth
	bhi	.L1714
	mov	w2, 1
	mov	w3, 0
	mov	w1, w2
	add	x0, x20, :lo12:.LANCHOR199
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	x0, x19
	bl	ftl_map_blk_gc
	b	.L1709
.L1714:
	ldr	w0, [x22, x1, lsl 2]
	cmp	w21, w0, lsr 10
	bne	.L1713
	add	w2, w2, 1
	and	w2, w2, 65535
	ubfiz	x0, x2, 1, 16
	str	w1, [x3, x0, lsl 2]
	add	x0, x0, 1
	ldr	w5, [x22, x1, lsl 2]
	str	w5, [x3, x0, lsl 2]
.L1713:
	add	x1, x1, 1
	b	.L1712
.L1719:
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
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR75
	stp	x19, x20, [sp, 16]
	ldr	w3, [x24, #:lo12:.LANCHOR75]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w3, .L1737
	adrp	x23, .LANCHOR163
	adrp	x25, .LANCHOR211
	mov	w22, w1
	add	x23, x23, :lo12:.LANCHOR163
	add	x25, x25, :lo12:.LANCHOR211
	mov	x19, x0
	adrp	x27, .LANCHOR52
	mov	w21, 0
	add	x0, x27, :lo12:.LANCHOR52
	stp	x2, x0, [x29, 96]
.L1724:
	ldr	w0, [x23]
	ldrh	w1, [x19, 2]
	add	w0, w0, 1
	str	w0, [x23]
	ldrh	w0, [x27, #:lo12:.LANCHOR52]
	sub	w0, w0, #1
	cmp	w1, w0
	bge	.L1725
	ldrh	w1, [x19]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1726
.L1725:
	mov	x0, x19
	bl	Ftl_write_map_blk_to_last_page
.L1726:
	ldrh	w1, [x19]
	ldr	x0, [x19, 16]
	ldrh	w0, [x0, x1, lsl 1]
	cbnz	w0, .L1727
	mov	w2, 731
	mov	x1, x25
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1727:
	ldrh	w1, [x19]
	ldrh	w0, [x19, 10]
	cmp	w1, w0
	bcc	.L1728
	mov	w2, 732
	mov	x1, x25
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1728:
	ldrh	w1, [x19]
	adrp	x20, .LANCHOR199
	ldr	x0, [x19, 16]
	add	x28, x20, :lo12:.LANCHOR199
	mov	w2, 16
	ldrh	w26, [x0, x1, lsl 1]
	mov	w1, 0
	ldrh	w0, [x19, 2]
	orr	w0, w0, w26, lsl 10
	str	w0, [x28, 4]
	ldr	x0, [x29, 96]
	str	x0, [x28, 8]
	adrp	x0, .LANCHOR185
	ldr	x0, [x0, #:lo12:.LANCHOR185]
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
	strh	w22, [x0, 8]
	strh	w26, [x0, 2]
	mov	x0, x28
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	ldr	w1, [x20, #:lo12:.LANCHOR199]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x19, 2]
	cmn	w1, #1
	bne	.L1729
	ldr	w1, [x28, 4]
	adrp	x0, .LC35
	add	x0, x0, :lo12:.LC35
	add	w21, w21, 1
	and	w21, w21, 65535
	bl	printf
	ldrh	w0, [x19, 2]
	cmp	w0, 2
	bhi	.L1730
	ldr	x0, [x29, 104]
	ldrh	w0, [x0]
	sub	w0, w0, #1
	strh	w0, [x19, 2]
.L1730:
	cmp	w21, 3
	bls	.L1724
	add	x20, x20, :lo12:.LANCHOR199
	mov	w2, w21
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	ldr	w1, [x20, 4]
	bl	printf
	mov	w0, 1
	str	w0, [x24, #:lo12:.LANCHOR75]
.L1737:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1729:
	cbz	w1, .L1732
	strh	w26, [x19, 60]
	cmp	w0, 1
	beq	.L1724
	cmp	w1, 256
.L1745:
	beq	.L1724
	add	x20, x20, :lo12:.LANCHOR199
	ldr	x0, [x19, 40]
	ldr	w1, [x20, 4]
	str	w1, [x0, w22, uxtw 2]
	b	.L1737
.L1732:
	cmp	w0, 1
	b	.L1745
	.size	FtlMapWritePage, .-FtlMapWritePage
	.section	.text.flush_l2p_region,"ax",@progbits
	.align	2
	.global	flush_l2p_region
	.type	flush_l2p_region, %function
flush_l2p_region:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR95
	ubfiz	x19, x0, 4, 16
	ldr	x0, [x20, #:lo12:.LANCHOR95]
	add	x1, x0, x19
	ldr	x2, [x1, 8]
	ldrh	w1, [x0, x19]
	adrp	x0, .LANCHOR124
	add	x0, x0, :lo12:.LANCHOR124
	bl	FtlMapWritePage
	ldr	x0, [x20, #:lo12:.LANCHOR95]
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
	adrp	x20, .LANCHOR66
	add	x20, x20, :lo12:.LANCHOR66
	str	x21, [sp, 32]
	mov	w19, 0
	adrp	x21, .LANCHOR95
.L1749:
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L1751
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1751:
	ldr	x1, [x21, #:lo12:.LANCHOR95]
	ubfiz	x0, x19, 4, 16
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	tbz	w0, #31, .L1750
	mov	w0, w19
	bl	flush_l2p_region
.L1750:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1749
	.size	l2p_flush, .-l2p_flush
	.section	.text.load_l2p_region,"ax",@progbits
	.align	2
	.global	load_l2p_region
	.type	load_l2p_region, %function
load_l2p_region:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 65535
	adrp	x0, .LANCHOR65
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	and	x19, x1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR65]
	cmp	w0, w20
	bcs	.L1754
	mov	w2, 503
	adrp	x1, .LANCHOR212
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR212
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1754:
	adrp	x1, .LANCHOR128
	ubfiz	x0, x20, 2, 16
	adrp	x22, .LANCHOR95
	ldr	x1, [x1, #:lo12:.LANCHOR128]
	ldr	w21, [x1, x0]
	cbnz	w21, .L1755
	ldr	x0, [x22, #:lo12:.LANCHOR95]
	lsl	x19, x19, 4
	adrp	x1, .LANCHOR56
	add	x0, x0, x19
	ldrh	w2, [x1, #:lo12:.LANCHOR56]
	mov	w1, 255
	ldr	x0, [x0, 8]
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR95]
	add	x1, x0, x19
	strh	w20, [x0, x19]
	str	wzr, [x1, 4]
.L1756:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1755:
	ldr	x0, [x22, #:lo12:.LANCHOR95]
	lsl	x19, x19, 4
	adrp	x24, .LANCHOR199
	add	x23, x24, :lo12:.LANCHOR199
	add	x0, x0, x19
	mov	w2, 1
	mov	w1, w2
	str	w21, [x23, 4]
	ldr	x0, [x0, 8]
	str	x0, [x23, 8]
	adrp	x0, .LANCHOR185
	ldr	x0, [x0, #:lo12:.LANCHOR185]
	str	x0, [x23, 16]
	mov	x0, x23
	bl	FlashReadPages
	ldr	x23, [x23, 16]
	ldr	w0, [x24, #:lo12:.LANCHOR199]
	cmp	w0, 256
	bne	.L1757
	mov	w2, w21
	mov	w1, w20
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	bl	printf
	lsr	w21, w21, 10
	ldr	x1, [x22, #:lo12:.LANCHOR95]
	adrp	x0, .LANCHOR124
	add	x0, x0, :lo12:.LANCHOR124
	add	x1, x1, x19
	strh	w21, [x0, 60]
	ldr	x2, [x1, 8]
	mov	w1, w20
	bl	FtlMapWritePage
.L1757:
	ldrh	w0, [x23, 8]
	cmp	w0, w20
	beq	.L1758
	mov	w2, 529
	adrp	x1, .LANCHOR212
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR212
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1758:
	ldr	x0, [x22, #:lo12:.LANCHOR95]
	add	x1, x0, x19
	str	wzr, [x1, 4]
	strh	w20, [x0, x19]
	b	.L1756
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.log2phys,"ax",@progbits
	.align	2
	.global	log2phys
	.type	log2phys, %function
log2phys:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	mov	x23, x1
	adrp	x1, .LANCHOR55
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	mov	w24, w2
	ldrh	w19, [x1, #:lo12:.LANCHOR55]
	str	x25, [sp, 64]
	add	w1, w19, 7
	mov	x19, 1
	lsr	w22, w0, w1
	and	w22, w22, 65535
	lsl	x19, x19, x1
	adrp	x1, .LANCHOR71
	sub	w19, w19, #1
	ldr	w1, [x1, #:lo12:.LANCHOR71]
	and	w19, w19, w0
	and	x19, x19, 65535
	cmp	w0, w1
	bcc	.L1761
	mov	w2, 851
	adrp	x1, .LANCHOR213
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR213
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1761:
	adrp	x21, .LANCHOR95
	adrp	x0, .LANCHOR66
	ldr	x2, [x21, #:lo12:.LANCHOR95]
	ldrh	w1, [x0, #:lo12:.LANCHOR66]
	mov	x0, 0
.L1762:
	and	x20, x0, 65535
	cmp	w20, w1
	bcc	.L1767
	bl	select_l2p_ram_region
	and	x20, x0, 65535
	ldr	x2, [x21, #:lo12:.LANCHOR95]
	ubfiz	x1, x20, 4, 16
	mov	w25, w0
	add	x3, x2, x1
	ldrh	w2, [x2, x1]
	mov	w1, 65535
	cmp	w2, w1
	beq	.L1768
	ldr	w1, [x3, 4]
	tbz	w1, #31, .L1768
	bl	flush_l2p_region
.L1768:
	mov	w1, w25
	mov	w0, w22
	bl	load_l2p_region
	b	.L1763
.L1767:
	add	x0, x0, 1
	add	x3, x2, x0, lsl 4
	ldrh	w3, [x3, -16]
	cmp	w3, w22
	bne	.L1762
.L1763:
	ldr	x0, [x21, #:lo12:.LANCHOR95]
	add	x0, x0, x20, lsl 4
	cbnz	w24, .L1764
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x19, lsl 2]
	str	w0, [x23]
.L1765:
	ldr	x0, [x21, #:lo12:.LANCHOR95]
	add	x20, x0, x20, lsl 4
	ldr	w0, [x20, 4]
	cmn	w0, #1
	beq	.L1770
	add	w0, w0, 1
	str	w0, [x20, 4]
.L1770:
	mov	w0, 0
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1764:
	ldr	x1, [x0, 8]
	ldr	w2, [x23]
	str	w2, [x1, x19, lsl 2]
	ldr	w1, [x0, 4]
	orr	w1, w1, -2147483648
	str	w1, [x0, 4]
	adrp	x0, .LANCHOR96
	strh	w22, [x0, #:lo12:.LANCHOR96]
	b	.L1765
	.size	log2phys, .-log2phys
	.section	.text.FtlReUsePrevPpa,"ax",@progbits
	.align	2
	.global	FtlReUsePrevPpa
	.type	FtlReUsePrevPpa, %function
FtlReUsePrevPpa:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR82
	stp	x19, x20, [sp, 16]
	mov	w21, w0
	str	w1, [x29, 76]
	lsr	w0, w1, 10
	str	x23, [sp, 48]
	bl	P2V_block_in_plane
	ldr	x2, [x22, #:lo12:.LANCHOR82]
	and	w3, w0, 65535
	ubfiz	x20, x3, 1, 16
	ldrh	w1, [x2, x20]
	cbnz	w1, .L1776
	adrp	x0, .LANCHOR86
	ldr	x19, [x0, #:lo12:.LANCHOR86]
	cbz	x19, .L1777
	adrp	x2, .LANCHOR80
	mov	x5, -6148914691236517206
	movk	x5, 0xaaab, lsl 0
	adrp	x23, .LANCHOR87
	ldr	x2, [x2, #:lo12:.LANCHOR80]
	mov	w6, 65535
	ldrh	w4, [x23, #:lo12:.LANCHOR87]
	sub	x19, x19, x2
	asr	x19, x19, 1
	mul	x19, x19, x5
	mov	w5, 6
	and	w19, w19, 65535
.L1778:
	cmp	w1, w4
	beq	.L1777
	cmp	w19, w3
	bne	.L1779
	mov	w1, w19
	add	x0, x0, :lo12:.LANCHOR86
	bl	List_remove_node
	ldrh	w0, [x23, #:lo12:.LANCHOR87]
	cbnz	w0, .L1780
	mov	w2, 1825
	adrp	x1, .LANCHOR214
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR214
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1780:
	ldrh	w0, [x23, #:lo12:.LANCHOR87]
	sub	w0, w0, #1
	strh	w0, [x23, #:lo12:.LANCHOR87]
	mov	w0, w19
	bl	INSERT_DATA_LIST
	ldr	x1, [x22, #:lo12:.LANCHOR82]
	ldrh	w0, [x1, x20]
	add	w0, w0, 1
	strh	w0, [x1, x20]
.L1777:
	add	x1, x29, 76
	mov	w2, 1
	mov	w0, w21
	bl	log2phys
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1779:
	umull	x19, w19, w5
	ldrh	w19, [x2, x19]
	cmp	w19, w6
	beq	.L1777
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L1778
.L1776:
	add	w1, w1, 1
	strh	w1, [x2, x20]
	b	.L1777
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
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
	adrp	x0, .LANCHOR48
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cmp	w1, w0
	bhi	.L1794
	adrp	x0, .LANCHOR55
	adrp	x26, .LANCHOR54
	adrp	x27, .LANCHOR56
	mov	x25, x2
	ldrh	w21, [x0, #:lo12:.LANCHOR55]
	add	x26, x26, :lo12:.LANCHOR54
	add	x27, x27, :lo12:.LANCHOR56
	mov	w24, 0
	lsr	w21, w22, w21
.L1788:
	cbnz	w20, .L1793
.L1786:
	mov	w0, w24
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1793:
	ldrh	w1, [x26]
	adrp	x0, .LANCHOR191
	adrp	x28, .LANCHOR182
	ldr	x0, [x0, #:lo12:.LANCHOR191]
	udiv	w23, w22, w1
	ldr	w2, [x0, w21, uxtw 2]
	and	w0, w20, 65535
	msub	w23, w23, w1, w22
	sub	w19, w1, w23
	and	w19, w19, 65535
	cmp	w20, w19
	csel	w19, w0, w19, cc
	cbz	w2, .L1790
	cmp	w19, w1
	beq	.L1790
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	str	w2, [x29, 124]
	mov	w2, 1
	stp	x0, xzr, [x29, 128]
	mov	w1, w2
	add	x0, x29, 120
	bl	FlashReadPages
.L1791:
	lsl	w3, w19, 9
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	lsl	w23, w23, 7
	mov	w2, w3
	mov	x1, x25
	str	w3, [x29, 108]
	add	x0, x0, x23, sxtw 2
	bl	ftl_memcpy
	ldr	x2, [x28, #:lo12:.LANCHOR182]
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
	b	.L1788
.L1790:
	ldrh	w2, [x27]
	mov	w1, 0
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	bl	ftl_memset
	b	.L1791
.L1794:
	mov	w24, -1
	b	.L1786
	.size	FtlVendorPartWrite, .-FtlVendorPartWrite
	.section	.text.Ftl_save_ext_data,"ax",@progbits
	.align	2
	.global	Ftl_save_ext_data
	.type	Ftl_save_ext_data, %function
Ftl_save_ext_data:
	adrp	x0, .LANCHOR136
	add	x2, x0, :lo12:.LANCHOR136
	ldr	w1, [x0, #:lo12:.LANCHOR136]
	mov	w0, 19539
	movk	w0, 0x4654, lsl 16
	cmp	w1, w0
	bne	.L1799
	mov	w0, 71
	mov	w1, 1
	movk	w0, 0x5000, lsl 16
	str	w0, [x2, 4]
	adrp	x0, .LANCHOR216
	ldr	w0, [x0, #:lo12:.LANCHOR216]
	str	w0, [x2, 88]
	adrp	x0, .LANCHOR217
	ldr	w0, [x0, #:lo12:.LANCHOR217]
	str	w0, [x2, 92]
	adrp	x0, .LANCHOR159
	ldr	w0, [x0, #:lo12:.LANCHOR159]
	str	w0, [x2, 8]
	adrp	x0, .LANCHOR160
	ldr	w0, [x0, #:lo12:.LANCHOR160]
	str	w0, [x2, 12]
	adrp	x0, .LANCHOR164
	ldr	w0, [x0, #:lo12:.LANCHOR164]
	str	w0, [x2, 16]
	adrp	x0, .LANCHOR163
	ldr	w0, [x0, #:lo12:.LANCHOR163]
	str	w0, [x2, 20]
	adrp	x0, .LANCHOR166
	ldr	w0, [x0, #:lo12:.LANCHOR166]
	str	w0, [x2, 28]
	adrp	x0, .LANCHOR78
	ldr	w0, [x0, #:lo12:.LANCHOR78]
	str	w0, [x2, 32]
	adrp	x0, .LANCHOR161
	ldr	w0, [x0, #:lo12:.LANCHOR161]
	str	w0, [x2, 36]
	adrp	x0, .LANCHOR162
	ldr	w0, [x0, #:lo12:.LANCHOR162]
	str	w0, [x2, 40]
	adrp	x0, .LANCHOR167
	ldr	w0, [x0, #:lo12:.LANCHOR167]
	str	w0, [x2, 44]
	adrp	x0, .LANCHOR168
	ldr	w0, [x0, #:lo12:.LANCHOR168]
	str	w0, [x2, 48]
	adrp	x0, .LANCHOR156
	ldr	w0, [x0, #:lo12:.LANCHOR156]
	str	w0, [x2, 60]
	adrp	x0, .LANCHOR155
	ldr	w0, [x0, #:lo12:.LANCHOR155]
	str	w0, [x2, 64]
	mov	w0, 0
	b	FtlVendorPartWrite
.L1799:
	ret
	.size	Ftl_save_ext_data, .-Ftl_save_ext_data
	.section	.text.FtlEctTblFlush,"ax",@progbits
	.align	2
	.global	FtlEctTblFlush
	.type	FtlEctTblFlush, %function
FtlEctTblFlush:
	adrp	x1, .LANCHOR101
	ldr	w1, [x1, #:lo12:.LANCHOR101]
	cbz	w1, .L1806
	adrp	x1, .LANCHOR168
	mov	w2, 4
	ldr	w1, [x1, #:lo12:.LANCHOR168]
	cmp	w1, 29
	mov	w1, 32
	csel	w1, w1, w2, hi
.L1802:
	adrp	x3, .LANCHOR218
	ldrh	w2, [x3, #:lo12:.LANCHOR218]
	cmp	w2, 31
	bhi	.L1803
	add	w2, w2, 1
	mov	w1, 1
	strh	w2, [x3, #:lo12:.LANCHOR218]
.L1803:
	adrp	x2, .LANCHOR188
	cbnz	w0, .L1804
	ldr	x0, [x2, #:lo12:.LANCHOR188]
	ldr	w3, [x0, 20]
	ldr	w0, [x0, 16]
	add	w1, w1, w3
	cmp	w0, w1
	bcc	.L1809
.L1804:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR188]
	ldr	w0, [x2, 16]
	str	w0, [x2, 20]
	mov	w0, 17221
	str	wzr, [x2, 4]
	movk	w0, 0x4254, lsl 16
	str	w0, [x2]
	adrp	x0, .LANCHOR187
	ldrh	w1, [x0, #:lo12:.LANCHOR187]
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
.L1806:
	mov	w1, 32
	b	.L1802
.L1809:
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
	adrp	x0, .LANCHOR38
	str	x21, [sp, 32]
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w0, w20
	bcs	.L1812
	mov	w2, 2943
	adrp	x1, .LANCHOR219
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR219
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1812:
	adrp	x0, .LANCHOR75
	ldr	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L1813
	mov	w0, 65535
	cmp	w20, w0
	beq	.L1814
	adrp	x1, .LANCHOR82
	ubfiz	x0, x20, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR82]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1815
	mov	w0, w20
	bl	INSERT_DATA_LIST
.L1814:
	strb	wzr, [x19, 8]
	adrp	x0, .LANCHOR91
	add	x0, x0, :lo12:.LANCHOR91
	cmp	x19, x0
	beq	.L1816
	adrp	x0, .LANCHOR42
	ldrh	w1, [x0, #:lo12:.LANCHOR42]
	cmp	w1, 1
	beq	.L1816
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L1817
.L1816:
	mov	w0, 1
	strb	w0, [x19, 8]
.L1818:
	adrp	x1, .LANCHOR130
	mov	w2, 65535
	mov	x21, x1
	ldrh	w0, [x1, #:lo12:.LANCHOR130]
	cmp	w0, w2
	beq	.L1823
	cmp	w20, w0
	bne	.L1824
	adrp	x2, .LANCHOR82
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR82]
	ldrh	w1, [x2, x1]
	cbz	w1, .L1825
.L1824:
	bl	update_vpc_list
.L1825:
	mov	w0, -1
	strh	w0, [x21, #:lo12:.LANCHOR130]
.L1823:
	mov	x0, x19
	bl	allocate_data_superblock
	bl	l2p_flush
	mov	w0, 0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1813:
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1815:
	mov	w0, w20
	bl	INSERT_FREE_LIST
	b	.L1814
.L1817:
	adrp	x0, .LANCHOR90
	add	x2, x0, :lo12:.LANCHOR90
	cmp	x19, x2
	bne	.L1818
	cmp	w1, 3
	beq	.L1820
	adrp	x1, .LANCHOR156
	ldr	w1, [x1, #:lo12:.LANCHOR156]
	cmp	w1, 1
	bne	.L1821
.L1820:
	add	x1, x0, :lo12:.LANCHOR90
	mov	w2, 1
	strb	w2, [x1, 8]
.L1821:
	adrp	x1, .LANCHOR101
	ldr	w1, [x1, #:lo12:.LANCHOR101]
	cbz	w1, .L1818
	adrp	x1, .LANCHOR168
	ldr	w1, [x1, #:lo12:.LANCHOR168]
	cmp	w1, 29
	bhi	.L1818
	add	x0, x0, :lo12:.LANCHOR90
	mov	w1, 1
	strb	w1, [x0, 8]
	b	.L1818
	.size	allocate_new_data_superblock, .-allocate_new_data_superblock
	.section	.text.FtlProgPages,"ax",@progbits
	.align	2
	.global	FtlProgPages
	.type	FtlProgPages, %function
FtlProgPages:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	adrp	x0, .LANCHOR8
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	mov	w21, w1
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	mov	x20, x3
	str	x25, [sp, 64]
	cbz	w0, .L1853
	ldrb	w0, [x3, 8]
	cmp	w0, 1
	cset	w22, eq
.L1840:
	ldrb	w3, [x20, 9]
	mov	w1, w21
	mov	w2, w22
	mov	x0, x19
	adrp	x24, .LANCHOR51
	adrp	x23, .LANCHOR136
	add	x24, x24, :lo12:.LANCHOR51
	add	x23, x23, :lo12:.LANCHOR136
	bl	FlashProgPages
	mov	w0, 56
	umaddl	x21, w21, w0, x19
.L1841:
	cmp	x21, x19
	beq	.L1850
	adrp	x25, .LANCHOR82
	b	.L1851
.L1853:
	mov	w22, 0
	b	.L1840
.L1844:
	ldr	w0, [x19, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	ldrh	w2, [x20]
	cmp	w2, w0, uxth
	bne	.L1842
	ldr	x1, [x25, #:lo12:.LANCHOR82]
	ubfiz	x2, x2, 1, 16
	ldrh	w3, [x20, 4]
	ldrh	w0, [x1, x2]
	sub	w0, w0, w3
	strh	w0, [x1, x2]
	strb	wzr, [x20, 6]
	ldrh	w0, [x24]
	strh	w0, [x20, 2]
	strh	wzr, [x20, 4]
.L1842:
	ldrh	w0, [x20, 4]
	cbnz	w0, .L1843
	mov	x0, x20
	bl	allocate_new_data_superblock
.L1843:
	ldr	w0, [x23, 96]
	add	w0, w0, 1
	str	w0, [x23, 96]
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
.L1851:
	ldr	w0, [x19]
	cmn	w0, #1
	beq	.L1844
	adrp	x0, .LANCHOR36
	ldrb	w1, [x20, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR36]
	cmp	w1, w0
	bcc	.L1845
	mov	w2, 1552
	adrp	x1, .LANCHOR220
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR220
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1845:
	ldr	w0, [x19, 4]
	cbnz	w22, .L1846
.L1858:
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
	mov	w25, w1
	cmn	w3, #1
	beq	.L1848
	adrp	x2, .LANCHOR82
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR82]
	ldrh	w0, [x2, x0]
	cbnz	w0, .L1849
	adrp	x0, .LC38
	mov	w2, 0
	add	x0, x0, :lo12:.LC38
	bl	printf
.L1849:
	mov	w0, w25
	bl	decrement_vpc_count
.L1848:
	add	x19, x19, 56
	b	.L1841
.L1846:
	orr	w0, w0, -2147483648
	b	.L1858
.L1850:
	adrp	x0, .LANCHOR36
	ldrb	w1, [x20, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR36]
	cmp	w1, w0
	bcc	.L1839
	mov	w2, 1569
	adrp	x1, .LANCHOR220
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR220
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1839:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
	.size	FtlProgPages, .-FtlProgPages
	.section	.text.FtlCacheWriteBack,"ax",@progbits
	.align	2
	.global	FtlCacheWriteBack
	.type	FtlCacheWriteBack, %function
FtlCacheWriteBack:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR129
	ldr	x0, [x19, #:lo12:.LANCHOR129]
	cbz	x0, .L1860
	adrp	x1, .LANCHOR221
	mov	w2, 0
	ldr	x3, [x1, #:lo12:.LANCHOR221]
	mov	w1, 1
	bl	FtlProgPages
	str	xzr, [x19, #:lo12:.LANCHOR129]
.L1860:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	FtlCacheWriteBack, .-FtlCacheWriteBack
	.section	.text.ftl_discard,"ax",@progbits
	.align	2
	.global	ftl_discard
	.type	ftl_discard, %function
ftl_discard:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR67
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	ldr	w0, [x0, #:lo12:.LANCHOR67]
	add	w1, w1, w2
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	cmp	w1, w0
	bhi	.L1873
	mov	w19, w2
	cmp	w2, 31
	bhi	.L1867
.L1881:
	mov	w0, 0
.L1865:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L1867:
	adrp	x22, .LANCHOR54
	bl	FtlCacheWriteBack
	ldrh	w0, [x22, #:lo12:.LANCHOR54]
	udiv	w21, w20, w0
	msub	w20, w0, w21, w20
	ands	w20, w20, 65535
	beq	.L1868
	sub	w0, w0, w20
	add	w21, w21, 1
	cmp	w0, w19
	csel	w0, w0, w19, ls
	sub	w19, w19, w0, uxth
.L1868:
	adrp	x20, .LANCHOR222
	adrp	x23, .LANCHOR161
	add	x20, x20, :lo12:.LANCHOR222
	add	x23, x23, :lo12:.LANCHOR161
	mov	w0, -1
	str	w0, [x29, 76]
.L1869:
	ldrh	w0, [x22, #:lo12:.LANCHOR54]
	cmp	w19, w0
	bcs	.L1871
	adrp	x0, .LANCHOR222
	ldr	w1, [x0, #:lo12:.LANCHOR222]
	cmp	w1, 32
	bls	.L1881
	str	wzr, [x0, #:lo12:.LANCHOR222]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L1881
.L1871:
	mov	w2, 0
	add	x1, x29, 72
	mov	w0, w21
	bl	log2phys
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L1870
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
.L1870:
	ldrh	w0, [x22, #:lo12:.LANCHOR54]
	add	w21, w21, 1
	sub	w19, w19, w0
	b	.L1869
.L1873:
	mov	w0, -1
	b	.L1865
	.size	ftl_discard, .-ftl_discard
	.section	.text.FtlSysFlush,"ax",@progbits
	.align	2
	.global	FtlSysFlush
	.type	FtlSysFlush, %function
FtlSysFlush:
	adrp	x0, .LANCHOR75
	ldr	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L1885
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
.L1885:
	mov	w0, 0
	ret
	.size	FtlSysFlush, .-FtlSysFlush
	.section	.text.FtlDeInit,"ax",@progbits
	.align	2
	.global	FtlDeInit
	.type	FtlDeInit, %function
FtlDeInit:
	adrp	x0, .LANCHOR223
	ldr	w0, [x0, #:lo12:.LANCHOR223]
	cmp	w0, 1
	bne	.L1891
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	FtlSysFlush
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L1891:
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
	adrp	x0, .LANCHOR48
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cmp	w1, w0
	bhi	.L1905
	adrp	x0, .LANCHOR55
	adrp	x26, .LANCHOR182
	mov	x25, x2
	mov	x28, x26
	ldrh	w20, [x0, #:lo12:.LANCHOR55]
	mov	w24, 0
	adrp	x0, .LANCHOR54
	add	x0, x0, :lo12:.LANCHOR54
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
	adrp	x0, .LANCHOR191
	ldr	x0, [x0, #:lo12:.LANCHOR191]
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
	ldr	x0, [x26, #:lo12:.LANCHOR182]
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
	adrp	x0, .LANCHOR199
	csinv	w24, w24, wzr, ne
	ldr	w0, [x0, #:lo12:.LANCHOR199]
	cmp	w0, 256
	bne	.L1902
	mov	w2, w3
	mov	w1, w20
	adrp	x0, .LC39
	add	x0, x0, :lo12:.LC39
	bl	printf
	ldr	x2, [x26, #:lo12:.LANCHOR182]
	adrp	x0, .LANCHOR215
	mov	w1, w20
	add	x0, x0, :lo12:.LANCHOR215
	bl	FtlMapWritePage
.L1902:
	ldr	x1, [x28, #:lo12:.LANCHOR182]
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
	adrp	x19, .LANCHOR188
	adrp	x20, .LANCHOR187
	ldr	x2, [x19, #:lo12:.LANCHOR188]
	ldrh	w1, [x20, #:lo12:.LANCHOR187]
	bl	FtlVendorPartRead
	ldr	x0, [x19, #:lo12:.LANCHOR188]
	ldr	w1, [x0]
	mov	w0, 17221
	movk	w0, 0x4254, lsl 16
	cmp	w1, w0
	beq	.L1908
	adrp	x1, .LC40
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC40
	add	x0, x0, :lo12:.LC6
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR188]
	mov	w1, 0
	ldrh	w2, [x20, #:lo12:.LANCHOR187]
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
	adrp	x19, .LANCHOR136
	str	x21, [sp, 32]
	add	x21, x19, :lo12:.LANCHOR136
	mov	x2, x21
	bl	FtlVendorPartRead
	ldr	w0, [x19, #:lo12:.LANCHOR136]
	mov	w20, 19539
	movk	w20, 0x4654, lsl 16
	cmp	w0, w20
	beq	.L1911
	mov	w2, 512
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	str	w20, [x19, #:lo12:.LANCHOR136]
.L1911:
	ldr	w1, [x19, #:lo12:.LANCHOR136]
	add	x0, x19, :lo12:.LANCHOR136
	cmp	w1, w20
	adrp	x20, .LANCHOR166
	bne	.L1912
	adrp	x1, .LANCHOR216
	ldr	w2, [x0, 88]
	str	w2, [x1, #:lo12:.LANCHOR216]
	adrp	x1, .LANCHOR217
	ldr	w2, [x0, 92]
	str	w2, [x1, #:lo12:.LANCHOR217]
	adrp	x1, .LANCHOR159
	ldr	w2, [x0, 8]
	str	w2, [x1, #:lo12:.LANCHOR159]
	adrp	x1, .LANCHOR160
	ldr	w2, [x0, 12]
	str	w2, [x1, #:lo12:.LANCHOR160]
	adrp	x1, .LANCHOR164
	ldr	w2, [x0, 16]
	str	w2, [x1, #:lo12:.LANCHOR164]
	adrp	x1, .LANCHOR163
	ldr	w2, [x0, 20]
	str	w2, [x1, #:lo12:.LANCHOR163]
	ldp	w1, w2, [x0, 28]
	str	w1, [x20, #:lo12:.LANCHOR166]
	adrp	x1, .LANCHOR78
	str	w2, [x1, #:lo12:.LANCHOR78]
	adrp	x1, .LANCHOR161
	ldr	w2, [x0, 36]
	str	w2, [x1, #:lo12:.LANCHOR161]
	adrp	x1, .LANCHOR162
	ldr	w2, [x0, 40]
	str	w2, [x1, #:lo12:.LANCHOR162]
	adrp	x1, .LANCHOR167
	ldr	w2, [x0, 44]
	str	w2, [x1, #:lo12:.LANCHOR167]
	adrp	x1, .LANCHOR168
	ldr	w2, [x0, 48]
	str	w2, [x1, #:lo12:.LANCHOR168]
	ldr	w1, [x0, 60]
	adrp	x0, .LANCHOR156
	str	w1, [x0, #:lo12:.LANCHOR156]
.L1912:
	add	x19, x19, :lo12:.LANCHOR136
	adrp	x0, .LANCHOR155
	str	wzr, [x0, #:lo12:.LANCHOR155]
	mov	w0, 34661
	ldr	w1, [x19, 68]
	movk	w0, 0x1234, lsl 16
	cmp	w1, w0
	bne	.L1913
	adrp	x0, .LANCHOR101
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR101]
	adrp	x1, .LC41
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC41
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1913:
	adrp	x1, .LANCHOR165
	adrp	x0, .LANCHOR46
	ldr	x21, [sp, 32]
	ldr	w2, [x1, #:lo12:.LANCHOR165]
	ldrh	w0, [x0, #:lo12:.LANCHOR46]
	ldr	w1, [x20, #:lo12:.LANCHOR166]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	madd	w0, w0, w2, w1
	adrp	x1, .LANCHOR38
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR202
	str	w0, [x1, #:lo12:.LANCHOR202]
	ret
	.size	Ftl_load_ext_data, .-Ftl_load_ext_data
	.section	.text.FtlMapBlkWriteDumpData,"ax",@progbits
	.align	2
	.global	FtlMapBlkWriteDumpData
	.type	FtlMapBlkWriteDumpData, %function
FtlMapBlkWriteDumpData:
	ldr	w1, [x0, 56]
	cbz	w1, .L1929
	stp	x29, x30, [sp, -80]!
	adrp	x1, .LANCHOR75
	add	x29, sp, 0
	ldr	w1, [x1, #:lo12:.LANCHOR75]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldrh	w20, [x0, 6]
	str	x25, [sp, 64]
	str	wzr, [x0, 56]
	ldr	x25, [x0, 40]
	cbnz	w1, .L1915
	mov	x19, x0
	adrp	x0, .LANCHOR181
	adrp	x23, .LANCHOR199
	add	x21, x23, :lo12:.LANCHOR199
	ldr	x0, [x0, #:lo12:.LANCHOR181]
	mov	x22, x23
	str	x0, [x21, 8]
	adrp	x0, .LANCHOR185
	ldr	x24, [x0, #:lo12:.LANCHOR185]
	ldrh	w0, [x19, 2]
	str	x24, [x21, 16]
	cbz	w0, .L1919
	adrp	x1, .LANCHOR52
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	sub	w1, w1, #1
	cmp	w0, w1
	bge	.L1919
	ldrh	w1, [x19]
	mov	w2, 65535
	cmp	w1, w2
	beq	.L1919
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
	ldr	w0, [x23, #:lo12:.LANCHOR199]
	cmn	w0, #1
	beq	.L1919
	ldrh	w1, [x24, 8]
	ldr	x2, [x19, 40]
	ubfiz	x0, x1, 2, 16
	ldr	w2, [x2, x0]
	ldr	w0, [x21, 4]
	cmp	w2, w0
	bne	.L1919
	ldr	x2, [x21, 8]
.L1932:
	mov	x0, x19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	b	FtlMapWritePage
.L1919:
	sub	w20, w20, #1
	and	w20, w20, 65535
	ubfiz	x0, x20, 2, 16
	ldr	w1, [x25, x0]
	add	x0, x22, :lo12:.LANCHOR199
	str	w1, [x0, 4]
	cbz	w1, .L1920
	mov	w2, 1
	mov	w1, w2
	bl	FlashReadPages
.L1921:
	add	x22, x22, :lo12:.LANCHOR199
	mov	w1, w20
	ldr	x2, [x22, 8]
	b	.L1932
.L1920:
	adrp	x1, .LANCHOR56
	ldr	x0, [x0, 8]
	ldrh	w2, [x1, #:lo12:.LANCHOR56]
	mov	w1, 255
	bl	ftl_memset
	b	.L1921
.L1915:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1929:
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
	adrp	x25, .LANCHOR127
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR63
	ldr	x0, [x25, #:lo12:.LANCHOR127]
	adrp	x22, .LANCHOR190
	ldr	w2, [x21, #:lo12:.LANCHOR63]
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR125
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR69
	stp	x27, x28, [sp, 80]
	adrp	x27, .LANCHOR126
	lsl	w2, w2, 2
	strh	wzr, [x20, #:lo12:.LANCHOR125]
	strh	wzr, [x23, #:lo12:.LANCHOR69]
	bl	ftl_memset
	ldr	x0, [x27, #:lo12:.LANCHOR126]
	mov	w1, 0
	ldr	w2, [x21, #:lo12:.LANCHOR63]
	adrp	x19, .LANCHOR60
	adrp	x28, .LANCHOR70
	adrp	x24, .LANCHOR206
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR190]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR60]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldr	x0, [x28, #:lo12:.LANCHOR70]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR60]
	lsl	w2, w2, 1
	bl	ftl_memset
	mov	w2, 12
	mov	w1, 255
	add	x0, x24, :lo12:.LANCHOR206
	bl	ftl_memset
	adrp	x0, .LANCHOR38
	stp	x22, x25, [x29, 144]
	str	x27, [x29, 160]
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	str	w0, [x29, 172]
	adrp	x0, .LANCHOR39
	add	x0, x0, :lo12:.LANCHOR39
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR157
	add	x0, x0, :lo12:.LANCHOR157
	str	x0, [x29, 112]
.L1934:
	ldr	x0, [x29, 120]
	ldr	w1, [x29, 172]
	ldrh	w0, [x0]
	cmp	w0, w1
	bls	.L1975
	adrp	x0, .LANCHOR36
	adrp	x25, .LANCHOR178
	adrp	x6, .LANCHOR45
	mov	x5, 0
	ldrh	w13, [x0, #:lo12:.LANCHOR36]
	adrp	x0, .LANCHOR104
	ldr	x7, [x25, #:lo12:.LANCHOR178]
	mov	w22, 0
	ldr	x12, [x0, #:lo12:.LANCHOR104]
	adrp	x0, .LANCHOR105
	add	x6, x6, :lo12:.LANCHOR45
	mov	w8, 56
	ldr	x11, [x0, #:lo12:.LANCHOR105]
	adrp	x0, .LANCHOR57
	ldrh	w10, [x0, #:lo12:.LANCHOR57]
	b	.L1976
.L1936:
	ldrh	w1, [x29, 172]
	ldrb	w0, [x6, x5]
	bl	V2P_block
	and	w4, w0, 65535
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L1935
	umaddl	x1, w22, w8, x7
	lsl	w4, w4, 10
	mul	w0, w22, w10
	add	w22, w22, 1
	and	w22, w22, 65535
	asr	w0, w0, 2
	str	w4, [x1, 4]
	add	x0, x11, x0, sxtw 2
	stp	x12, x0, [x1, 8]
.L1935:
	add	x5, x5, 1
.L1976:
	cmp	w13, w5, uxth
	bhi	.L1936
	cbnz	w22, .L1937
.L1974:
	ldr	w0, [x29, 172]
	add	w26, w0, 1
	and	w0, w26, 65535
	str	w0, [x29, 172]
	b	.L1934
.L1937:
	mov	w1, w22
	mov	w2, 1
	mov	x0, x7
	bl	FlashReadPages
	mov	w0, 56
	umull	x0, w22, w0
	mov	x22, 0
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR224
	add	x0, x0, :lo12:.LANCHOR224
	str	x0, [x29, 136]
.L1973:
	ldr	x0, [x25, #:lo12:.LANCHOR178]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	ldr	w3, [x1, 4]
	cmn	w0, #1
	ldr	x27, [x1, 16]
	ubfx	x26, x3, 10, 16
	bne	.L1940
	mov	w5, 16
	mov	w7, 65535
.L1942:
	ldr	x0, [x25, #:lo12:.LANCHOR178]
	add	x6, x25, :lo12:.LANCHOR178
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
	bne	.L1939
	ldr	x0, [x6]
	mov	w1, -1
	str	w1, [x0, x22]
	ldr	x0, [x6]
	ldr	w0, [x0, x22]
	cmp	w0, w1
	beq	.L2012
.L1940:
	adrp	x0, .LANCHOR157
	ldr	w1, [x0, #:lo12:.LANCHOR157]
	ldr	w0, [x27, 4]
	cmn	w1, #1
	beq	.L1943
	cmp	w1, w0
	bhi	.L1944
.L1943:
	cmn	w0, #1
	beq	.L1944
	ldr	x2, [x29, 112]
	add	w1, w0, 1
	str	w1, [x2]
.L1944:
	ldrh	w1, [x27]
	mov	w2, 61604
	cmp	w1, w2
	beq	.L1946
	bhi	.L1947
	mov	w0, 61574
	cmp	w1, w0
	beq	.L1948
.L1945:
	ldr	x0, [x29, 128]
	add	x22, x22, 56
	cmp	x0, x22
	bne	.L1973
	b	.L1974
.L1939:
	ldr	x0, [x25, #:lo12:.LANCHOR178]
	ldr	w0, [x0, x22]
	cmn	w0, #1
	bne	.L1940
	sub	w5, w5, #1
	ands	w5, w5, 65535
	bne	.L1942
.L2012:
	mov	w1, 0
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
	b	.L1945
.L1947:
	mov	w0, 61634
	cmp	w1, w0
	beq	.L1949
	mov	w0, 65535
	cmp	w1, w0
	beq	.L2012
	b	.L1945
.L1949:
	ldrh	w1, [x20, #:lo12:.LANCHOR125]
	ldr	w0, [x21, #:lo12:.LANCHOR63]
	cmp	w1, w0
	bls	.L1951
	ldr	x1, [x29, 136]
	mov	w2, 1269
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1951:
	ldr	w6, [x21, #:lo12:.LANCHOR63]
	ldr	x3, [x29, 152]
	ldrh	w1, [x20, #:lo12:.LANCHOR125]
	and	w2, w6, 65535
	sub	w0, w2, #1
	sub	w2, w2, w1
	sxth	x0, w0
	sub	w2, w2, #1
	ldr	x5, [x3, #:lo12:.LANCHOR127]
	sxth	w2, w2
.L1952:
	cmp	w0, w2
	bgt	.L1958
	tbz	w0, #31, .L1993
	b	.L1945
.L1958:
	sxtw	x8, w0
	ldr	w11, [x27, 4]
	lsl	x7, x8, 2
	add	x10, x5, x7
	ldr	w7, [x5, x7]
	cmp	w11, w7
	bls	.L1953
	ldr	w2, [x5]
	cbnz	w2, .L1954
	cmp	w6, w1
	beq	.L1954
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR125]
.L1954:
	ldr	x1, [x29, 160]
	ldr	x6, [x1, #:lo12:.LANCHOR126]
	mov	w1, 0
.L1955:
	cmp	w1, w0
	bne	.L1956
	ldr	w1, [x27, 4]
	str	w1, [x10]
	strh	w26, [x6, x8, lsl 1]
	tbnz	w0, #31, .L1945
	ldrh	w1, [x20, #:lo12:.LANCHOR125]
	ldr	w2, [x21, #:lo12:.LANCHOR63]
	sub	w2, w2, w1
	sub	w2, w2, #1
	cmp	w0, w2, sxth
	bgt	.L1945
.L1993:
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR125]
	ldr	w1, [x27, 4]
	str	w1, [x5, x0, lsl 2]
	ldr	x1, [x29, 160]
	ldr	x1, [x1, #:lo12:.LANCHOR126]
.L2011:
	strh	w26, [x1, x0, lsl 1]
	b	.L1945
.L1956:
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
	b	.L1955
.L1953:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L1952
.L1948:
	ldrh	w1, [x23, #:lo12:.LANCHOR69]
	ldrh	w0, [x19, #:lo12:.LANCHOR60]
	cmp	w1, w0
	bls	.L1961
	ldr	x1, [x29, 136]
	mov	w2, 1316
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L1961:
	ldrh	w6, [x19, #:lo12:.LANCHOR60]
	ldrh	w2, [x23, #:lo12:.LANCHOR69]
	sub	w1, w6, #1
	sxth	x0, w1
	sub	w5, w1, w2
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR190]
.L1962:
	cmp	w0, w5
	ble	.L1967
	sxtw	x7, w0
	ldr	w11, [x27, 4]
	lsl	x8, x7, 2
	add	x10, x1, x8
	ldr	w8, [x1, x8]
	cmp	w11, w8
	bls	.L1963
	ldr	w5, [x1]
	cbnz	w5, .L1964
	cmp	w6, w2
	beq	.L1964
	add	w2, w2, 1
	strh	w2, [x23, #:lo12:.LANCHOR69]
.L1964:
	ldr	x6, [x28, #:lo12:.LANCHOR70]
	mov	w2, 0
.L1965:
	cmp	w2, w0
	bne	.L1966
	ldr	w2, [x27, 4]
	str	w2, [x10]
	strh	w26, [x6, x7, lsl 1]
.L1967:
	tbnz	w0, #31, .L1945
	ldrh	w2, [x19, #:lo12:.LANCHOR60]
	ldrh	w5, [x23, #:lo12:.LANCHOR69]
	sub	w2, w2, #1
	sub	w2, w2, w5
	cmp	w0, w2, sxth
	bgt	.L1945
	add	w5, w5, 1
	ldr	w2, [x27, 4]
	strh	w5, [x23, #:lo12:.LANCHOR69]
	str	w2, [x1, x0, lsl 2]
	ldr	x1, [x28, #:lo12:.LANCHOR70]
	b	.L2011
.L1966:
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
	b	.L1965
.L1963:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L1962
.L1946:
	ldrh	w5, [x24, #:lo12:.LANCHOR206]
	mov	w1, 65535
	add	x2, x24, :lo12:.LANCHOR206
	cmp	w5, w1
	bne	.L1969
	strh	w26, [x24, #:lo12:.LANCHOR206]
	str	w0, [x2, 8]
	b	.L1945
.L1969:
	ldrh	w0, [x2, 4]
	cmp	w0, w1
	beq	.L1970
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
.L1970:
	add	x0, x24, :lo12:.LANCHOR206
	ldr	w1, [x27, 4]
	ldr	w2, [x0, 8]
	cmp	w2, w1
	bcs	.L1971
	ldrh	w2, [x24, #:lo12:.LANCHOR206]
	strh	w2, [x0, 4]
	strh	w26, [x24, #:lo12:.LANCHOR206]
	str	w1, [x0, 8]
	b	.L1945
.L1971:
	strh	w26, [x0, 4]
	b	.L1945
.L1975:
	ldr	x0, [x29, 160]
	ldr	x2, [x0, #:lo12:.LANCHOR126]
	ldrh	w0, [x2]
	cbz	w0, .L1977
.L1980:
	ldr	x1, [x28, #:lo12:.LANCHOR70]
	ldrh	w0, [x1]
	cbz	w0, .L1978
.L1979:
	ldrh	w1, [x20, #:lo12:.LANCHOR125]
	ldr	w0, [x21, #:lo12:.LANCHOR63]
	cmp	w1, w0
	bls	.L2009
	mov	w2, 1450
	adrp	x1, .LANCHOR224
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR224
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2009:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1977:
	ldrh	w0, [x20, #:lo12:.LANCHOR125]
	cbz	w0, .L1980
	ldr	w1, [x21, #:lo12:.LANCHOR63]
	mov	w0, 0
.L1981:
	cmp	w0, w1
	bcs	.L1980
	ldrh	w3, [x2, w0, sxtw 1]
	cbz	w3, .L1982
	ldr	x1, [x29, 152]
	add	x7, x21, :lo12:.LANCHOR63
	ldr	x4, [x1, #:lo12:.LANCHOR127]
	mov	w1, w0
.L1983:
	ldr	w3, [x7]
	cmp	w1, w3
	bcs	.L1980
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
	b	.L1983
.L1982:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L1981
.L1978:
	ldrh	w0, [x23, #:lo12:.LANCHOR69]
	cbz	w0, .L1979
	ldrh	w2, [x19, #:lo12:.LANCHOR60]
	mov	w0, 0
.L1988:
	mov	w6, w0
	cmp	w0, w2
	bge	.L1979
	ldrh	w3, [x1, w0, sxtw 1]
	cbz	w3, .L1989
	ldr	x2, [x29, 144]
	add	x19, x19, :lo12:.LANCHOR60
	ldr	x3, [x2, #:lo12:.LANCHOR190]
.L1990:
	ldrh	w2, [x19]
	cmp	w0, w2
	bge	.L1979
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
	b	.L1990
.L1989:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L1988
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
	adrp	x20, .LANCHOR206
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR199
	stp	x25, x26, [sp, 64]
	add	x19, x23, :lo12:.LANCHOR199
	adrp	x25, .LANCHOR185
	adrp	x24, .LANCHOR82
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR38
	ldr	x0, [x25, #:lo12:.LANCHOR185]
	stp	x27, x28, [sp, 80]
	stp	xzr, x0, [x19, 8]
	ldr	x0, [x24, #:lo12:.LANCHOR82]
	ldrh	w2, [x21, #:lo12:.LANCHOR38]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w0, [x20, #:lo12:.LANCHOR206]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L2014
.L2023:
	mov	w0, -1
.L2013:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L2014:
	add	x26, x20, :lo12:.LANCHOR206
	mov	w27, 19539
	mov	w1, 1
	movk	w27, 0x4654, lsl 16
	bl	FtlGetLastWrittenPage
	mov	w28, 61604
	sxth	w22, w0
	add	w0, w0, 1
	strh	w0, [x26, 2]
	adrp	x26, .LANCHOR79
.L2016:
	tbz	w22, #31, .L2019
	mov	w2, 1510
	adrp	x1, .LANCHOR225
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR225
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2018:
	adrp	x1, .LANCHOR56
	ldrh	w0, [x21, #:lo12:.LANCHOR38]
	ldrh	w1, [x1, #:lo12:.LANCHOR56]
	add	x0, x0, 24
	cmp	x1, x0, lsl 1
	bcs	.L2021
	mov	w2, 1512
	adrp	x1, .LANCHOR225
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR225
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2021:
	add	x23, x23, :lo12:.LANCHOR199
	mov	w2, 48
	adrp	x19, .LANCHOR135
	add	x0, x19, :lo12:.LANCHOR135
	ldr	x1, [x23, 8]
	bl	ftl_memcpy
	ldr	x0, [x24, #:lo12:.LANCHOR82]
	ldrh	w2, [x21, #:lo12:.LANCHOR38]
	ldr	x1, [x23, 8]
	lsl	w2, w2, 1
	add	x1, x1, 48
	bl	ftl_memcpy
	ldrh	w1, [x21, #:lo12:.LANCHOR38]
	ldr	x0, [x23, 8]
	lsr	w2, w1, 3
	ubfiz	x1, x1, 1, 16
	add	x1, x1, 48
	add	w2, w2, 4
	and	x1, x1, -4
	add	x1, x0, x1
	adrp	x0, .LANCHOR0
	ldr	x0, [x0, #:lo12:.LANCHOR0]
	bl	ftl_memcpy
	adrp	x0, .LANCHOR68
	ldrh	w0, [x0, #:lo12:.LANCHOR68]
	cbz	w0, .L2022
	ldrh	w1, [x21, #:lo12:.LANCHOR38]
	adrp	x0, .LANCHOR65
	ldrh	w2, [x0, #:lo12:.LANCHOR65]
	lsr	w0, w1, 3
	add	w1, w0, w1, lsl 1
	ldr	x0, [x23, 8]
	add	w1, w1, 52
	lsl	w2, w2, 2
	and	x1, x1, 65532
	add	x1, x0, x1
	adrp	x0, .LANCHOR192
	ldr	x0, [x0, #:lo12:.LANCHOR192]
	bl	ftl_memcpy
.L2022:
	ldr	w2, [x19, #:lo12:.LANCHOR135]
	mov	w1, 19539
	movk	w1, 0x4654, lsl 16
	add	x0, x19, :lo12:.LANCHOR135
	cmp	w2, w1
	bne	.L2023
	add	x20, x20, :lo12:.LANCHOR206
	ldrh	w1, [x0, 8]
	ldrb	w2, [x0, 10]
	adrp	x0, .LANCHOR43
	strh	w1, [x20, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR43]
	cmp	w2, w0
	bne	.L2023
	adrp	x0, .LANCHOR226
	adrp	x2, .LANCHOR71
	adrp	x3, .LANCHOR36
	str	w1, [x0, #:lo12:.LANCHOR226]
	adrp	x0, .LANCHOR51
	ldrh	w3, [x3, #:lo12:.LANCHOR36]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	mul	w0, w0, w1
	str	w0, [x2, #:lo12:.LANCHOR71]
	adrp	x2, .LANCHOR54
	ldrh	w2, [x2, #:lo12:.LANCHOR54]
	mul	w0, w2, w0
	adrp	x2, .LANCHOR67
	str	w0, [x2, #:lo12:.LANCHOR67]
	adrp	x0, .LANCHOR40
	ldr	w2, [x0, #:lo12:.LANCHOR40]
	adrp	x0, .LANCHOR73+6
	ldrh	w0, [x0, #:lo12:.LANCHOR73+6]
	cmp	w1, w2
	sub	w0, w2, w0
	sub	w0, w0, w1
	udiv	w0, w0, w3
	adrp	x3, .LANCHOR227
	strh	w0, [x3, #:lo12:.LANCHOR227]
	bls	.L2024
	mov	w2, 1539
	adrp	x1, .LANCHOR225
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR225
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2024:
	add	x1, x19, :lo12:.LANCHOR135
	adrp	x0, .LANCHOR90
	add	x3, x0, :lo12:.LANCHOR90
	adrp	x5, .LANCHOR201
	mov	x22, x5
	ldrh	w2, [x1, 16]
	ldrh	w7, [x1, 14]
	strh	w7, [x0, #:lo12:.LANCHOR90]
	lsr	w4, w2, 6
	and	w2, w2, 63
	strb	w2, [x3, 6]
	ldrb	w2, [x1, 11]
	strb	w2, [x3, 8]
	add	x2, x5, :lo12:.LANCHOR201
	strh	w4, [x3, 2]
	mov	w3, -1
	strh	w3, [x5, #:lo12:.LANCHOR201]
	strh	wzr, [x2, 2]
	strb	wzr, [x2, 6]
	strb	wzr, [x2, 8]
	adrp	x2, .LANCHOR91
	ldrh	w3, [x1, 18]
	add	x4, x2, :lo12:.LANCHOR91
	strh	w3, [x2, #:lo12:.LANCHOR91]
	mov	x20, x2
	ldrh	w3, [x1, 20]
	lsr	w6, w3, 6
	and	w3, w3, 63
	strb	w3, [x4, 6]
	ldrb	w3, [x1, 12]
	strh	w6, [x4, 2]
	strb	w3, [x4, 8]
	adrp	x4, .LANCHOR92
	ldrh	w3, [x1, 22]
	add	x6, x4, :lo12:.LANCHOR92
	strh	w3, [x4, #:lo12:.LANCHOR92]
	mov	x21, x4
	ldrh	w3, [x1, 24]
	lsr	w8, w3, 6
	and	w3, w3, 63
	strb	w3, [x6, 6]
	ldrb	w3, [x1, 13]
	strb	w3, [x6, 8]
	adrp	x3, .LANCHOR159
	strh	w8, [x6, 2]
	ldr	w6, [x1, 32]
	str	wzr, [x3, #:lo12:.LANCHOR159]
	adrp	x3, .LANCHOR160
	str	wzr, [x3, #:lo12:.LANCHOR160]
	adrp	x3, .LANCHOR164
	str	wzr, [x3, #:lo12:.LANCHOR164]
	adrp	x3, .LANCHOR163
	str	wzr, [x3, #:lo12:.LANCHOR163]
	adrp	x3, .LANCHOR165
	str	w6, [x3, #:lo12:.LANCHOR165]
	adrp	x3, .LANCHOR166
	str	wzr, [x3, #:lo12:.LANCHOR166]
	adrp	x3, .LANCHOR167
	str	wzr, [x3, #:lo12:.LANCHOR167]
	adrp	x3, .LANCHOR162
	str	wzr, [x3, #:lo12:.LANCHOR162]
	ldr	w3, [x1, 40]
	adrp	x1, .LANCHOR157
	ldr	w6, [x1, #:lo12:.LANCHOR157]
	cmp	w3, w6
	bls	.L2025
	str	w3, [x1, #:lo12:.LANCHOR157]
.L2025:
	add	x19, x19, :lo12:.LANCHOR135
	adrp	x1, .LANCHOR158
	ldr	w3, [x1, #:lo12:.LANCHOR158]
	ldr	w2, [x19, 36]
	cmp	w2, w3
	bls	.L2026
	str	w2, [x1, #:lo12:.LANCHOR158]
.L2026:
	mov	w1, 65535
	cmp	w7, w1
	beq	.L2027
	add	x0, x0, :lo12:.LANCHOR90
	bl	make_superblock
.L2027:
	ldrh	w2, [x20, #:lo12:.LANCHOR91]
	mov	w1, 65535
	add	x0, x20, :lo12:.LANCHOR91
	cmp	w2, w1
	beq	.L2028
	bl	make_superblock
.L2028:
	ldrh	w2, [x21, #:lo12:.LANCHOR92]
	mov	w1, 65535
	add	x0, x21, :lo12:.LANCHOR92
	cmp	w2, w1
	beq	.L2029
	bl	make_superblock
.L2029:
	ldrh	w2, [x22, #:lo12:.LANCHOR201]
	mov	w1, 65535
	add	x0, x22, :lo12:.LANCHOR201
	cmp	w2, w1
	beq	.L2030
	bl	make_superblock
.L2030:
	mov	w0, 0
	b	.L2013
.L2019:
	ldrh	w0, [x20, #:lo12:.LANCHOR206]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w22, w0, lsl 10
	str	w0, [x19, 4]
	ldr	x0, [x26, #:lo12:.LANCHOR79]
	str	x0, [x19, 8]
	mov	x0, x19
	bl	FlashReadPages
	ldr	w0, [x19]
	cmn	w0, #1
	beq	.L2017
	ldr	x0, [x26, #:lo12:.LANCHOR79]
	ldr	w0, [x0]
	cmp	w0, w27
	bne	.L2017
	ldr	x0, [x25, #:lo12:.LANCHOR185]
	ldrh	w0, [x0]
	cmp	w0, w28
	beq	.L2018
.L2017:
	sub	w22, w22, #1
	sxth	w22, w22
	b	.L2016
	.size	FtlLoadSysInfo, .-FtlLoadSysInfo
	.section	.text.FtlMapTblRecovery,"ax",@progbits
	.align	2
	.global	FtlMapTblRecovery
	.type	FtlMapTblRecovery, %function
FtlMapTblRecovery:
	stp	x29, x30, [sp, -160]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR79
	stp	x23, x24, [sp, 48]
	adrp	x20, .LANCHOR199
	ldrh	w23, [x0, 6]
	ldr	x22, [x0, 40]
	ldr	x0, [x0, 16]
	str	x0, [x29, 152]
	lsl	w2, w23, 2
	ldr	x0, [x19, 24]
	str	x0, [x29, 136]
	ldrh	w0, [x19, 8]
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR52
	stp	x27, x28, [sp, 80]
	mov	w26, 0
	str	w0, [x29, 144]
	mov	x0, x22
	bl	ftl_memset
	stp	wzr, wzr, [x19, 48]
	add	x3, x20, :lo12:.LANCHOR199
	ldr	x0, [x21, #:lo12:.LANCHOR79]
	mov	w1, -1
	mov	x24, x3
	str	x0, [x3, 8]
	adrp	x0, .LANCHOR185
	str	x0, [x29, 128]
	ldr	x27, [x0, #:lo12:.LANCHOR185]
	ldr	w0, [x29, 144]
	str	x27, [x3, 16]
	sub	w0, w0, #1
	strh	w1, [x19]
	strh	w1, [x19, 2]
	mov	w1, 1
	str	w0, [x29, 120]
	add	x0, x25, :lo12:.LANCHOR52
	str	w1, [x19, 56]
	str	x0, [x29, 112]
.L2040:
	ldr	w0, [x29, 144]
	cmp	w26, w0
	bge	.L2058
	ldr	w0, [x29, 120]
	sxtw	x28, w26
	cmp	w26, w0
	bne	.L2041
	ldr	x2, [x29, 152]
	lsl	x0, x28, 1
	ldr	x1, [x29, 152]
	mov	w25, 0
	add	x24, x1, x0
	mov	w1, 1
	ldrh	w0, [x2, x0]
	bl	FtlGetLastWrittenPage
	sxth	w3, w0
	add	w0, w0, 1
	strh	w0, [x19, 2]
	ldr	x0, [x29, 136]
	strh	w26, [x19]
	add	x26, x20, :lo12:.LANCHOR199
	ldr	w0, [x0, x28, lsl 2]
	str	w0, [x19, 48]
.L2042:
	cmp	w25, w3
	ble	.L2045
.L2058:
	adrp	x23, .LANCHOR124
	str	x23, [x29, 136]
	add	x0, x23, :lo12:.LANCHOR124
	cmp	x19, x0
	bne	.L2047
	adrp	x0, .LANCHOR68
	ldrh	w0, [x0, #:lo12:.LANCHOR68]
	cbz	w0, .L2047
	adrp	x26, .LANCHOR125
	add	x27, x26, :lo12:.LANCHOR125
	adrp	x24, .LANCHOR65
	mov	w22, 0
	add	x0, x24, :lo12:.LANCHOR65
	adrp	x25, .LANCHOR192
	str	x0, [x29, 144]
.L2061:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0]
	cmp	w22, w0
	bcc	.L2067
.L2047:
	mov	x0, x19
	bl	ftl_free_no_use_map_blk
	adrp	x0, .LANCHOR52
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bne	.L2060
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L2060:
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
	ldp	x29, x30, [sp], 160
	ret
.L2045:
	ldrh	w0, [x24]
	mov	w2, 1
	str	w3, [x29, 144]
	mov	w1, w2
	orr	w0, w25, w0, lsl 10
	str	w0, [x26, 4]
	mov	x0, x26
	bl	FlashReadPages
	ldr	w0, [x26]
	ldr	w3, [x29, 144]
	cmn	w0, #1
	beq	.L2043
	ldrh	w0, [x27, 8]
	cmp	w23, w0
	bls	.L2044
	ldrh	w2, [x27]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L2044
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x26, 4]
	str	w1, [x22, x0]
.L2044:
	add	w25, w25, 1
	sxth	w25, w25
	b	.L2042
.L2043:
	ldrh	w0, [x24]
	strh	w0, [x19, 60]
	b	.L2044
.L2041:
	ldr	x1, [x29, 152]
	mov	w2, 1
	ldr	x0, [x21, #:lo12:.LANCHOR79]
	str	x0, [x24, 8]
	lsl	x0, x28, 1
	add	x28, x1, x0
	ldrh	w0, [x1, x0]
	ldrh	w1, [x25, #:lo12:.LANCHOR52]
	sub	w1, w1, #1
	orr	w0, w1, w0, lsl 10
	mov	w1, w2
	str	w0, [x24, 4]
	mov	x0, x24
	bl	FlashReadPages
	ldr	w0, [x24]
	cmn	w0, #1
	beq	.L2069
	ldrh	w1, [x27]
	ldrh	w0, [x19, 4]
	cmp	w1, w0
	bne	.L2069
	ldrh	w1, [x27, 8]
	mov	w0, 64245
	cmp	w1, w0
	beq	.L2049
.L2069:
	mov	w6, 0
.L2050:
	ldr	x0, [x29, 112]
	ldrh	w0, [x0]
	cmp	w6, w0
	bge	.L2056
	ldrh	w0, [x28]
	mov	w2, 1
	str	w6, [x29, 108]
	mov	w1, w2
	orr	w0, w6, w0, lsl 10
	str	w0, [x24, 4]
	mov	x0, x24
	bl	FlashReadPages
	ldr	w0, [x24]
	ldr	w6, [x29, 108]
	cmn	w0, #1
	beq	.L2054
	ldrh	w0, [x27, 8]
	cmp	w23, w0
	bls	.L2054
	ldrh	w2, [x27]
	ldrh	w1, [x19, 4]
	cmp	w2, w1
	bne	.L2054
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x24, 4]
	str	w1, [x22, x0]
.L2054:
	add	w6, w6, 1
	sxth	w6, w6
	b	.L2050
.L2049:
	ldrh	w6, [x25, #:lo12:.LANCHOR52]
	mov	w0, 0
	ldr	x10, [x21, #:lo12:.LANCHOR79]
	sub	w6, w6, #1
.L2051:
	cmp	w0, w6
	blt	.L2053
.L2056:
	add	w4, w26, 1
	sxth	w26, w4
	b	.L2040
.L2053:
	lsl	w2, w0, 1
	sxtw	x2, w2
	lsl	x1, x2, 2
	ldrh	w1, [x10, x1]
	cmp	w23, w1
	bls	.L2052
	add	x2, x2, 1
	ubfiz	x1, x1, 2, 16
	ldr	w2, [x10, x2, lsl 2]
	str	w2, [x22, x1]
.L2052:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L2051
.L2067:
	ldr	x0, [x25, #:lo12:.LANCHOR192]
	ubfiz	x28, x22, 2, 32
	ldr	w0, [x0, x28]
	sub	w1, w0, #1
	cmn	w1, #3
	bhi	.L2063
	adrp	x24, .LANCHOR128
	ldr	x1, [x24, #:lo12:.LANCHOR128]
	ldr	w1, [x1, x28]
	cmp	w0, w1
	beq	.L2063
	add	x4, x20, :lo12:.LANCHOR199
	ldr	x1, [x21, #:lo12:.LANCHOR79]
	mov	w2, 1
	str	x4, [x29, 120]
	str	x1, [x4, 8]
	ldr	x1, [x29, 128]
	str	w0, [x4, 4]
	mov	x0, x4
	ldr	x23, [x1, #:lo12:.LANCHOR185]
	mov	w1, w2
	str	x23, [x4, 16]
	bl	FlashReadPages
	ldr	w0, [x20, #:lo12:.LANCHOR199]
	cmn	w0, #1
	beq	.L2063
	ldr	x0, [x29, 136]
	ldrh	w1, [x23]
	add	x0, x0, :lo12:.LANCHOR124
	ldr	x4, [x29, 120]
	ldrh	w0, [x0, 4]
	cmp	w1, w0
	bne	.L2063
	ldr	x0, [x24, #:lo12:.LANCHOR128]
	mov	w2, 1
	ldr	w3, [x23, 4]
	mov	w1, w2
	str	w3, [x29, 120]
	ldr	w0, [x0, x28]
	str	w0, [x4, 4]
	mov	x0, x4
	bl	FlashReadPages
	ldr	w4, [x23, 4]
	ldr	w3, [x29, 120]
	cmp	w3, w4
	bls	.L2063
	ldr	x1, [x24, #:lo12:.LANCHOR128]
	ldr	x0, [x25, #:lo12:.LANCHOR192]
	ldr	w2, [x1, x28]
	ldr	w1, [x0, x28]
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	printf
	ldr	x0, [x25, #:lo12:.LANCHOR192]
	ldr	x1, [x24, #:lo12:.LANCHOR128]
	ldr	w2, [x0, x28]
	str	w2, [x1, x28]
	mov	w1, 0
	ldrh	w2, [x26, #:lo12:.LANCHOR125]
	ldr	w0, [x0, x28]
	ubfx	x0, x0, 10, 16
.L2065:
	cmp	w1, w2
	blt	.L2066
	adrp	x1, .LANCHOR63
	ldr	w1, [x1, #:lo12:.LANCHOR63]
	cmp	w2, w1
	bcs	.L2063
	ldr	x1, [x29, 152]
	ubfiz	x2, x2, 1, 16
	strh	w0, [x1, x2]
	ldrh	w1, [x27]
	add	w1, w1, 1
	strh	w1, [x27]
	bl	remove_from_free_sys_Queue
.L2063:
	add	w22, w22, 1
	b	.L2061
.L2066:
	ldr	x3, [x29, 152]
	ldrh	w3, [x3, w1, sxtw 1]
	cmp	w3, w0
	beq	.L2063
	add	w1, w1, 1
	sxth	w1, w1
	b	.L2065
	.size	FtlMapTblRecovery, .-FtlMapTblRecovery
	.section	.text.FtlLoadVonderInfo,"ax",@progbits
	.align	2
	.global	FtlLoadVonderInfo
	.type	FtlLoadVonderInfo, %function
FtlLoadVonderInfo:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR60
	adrp	x0, .LANCHOR215
	add	x0, x0, :lo12:.LANCHOR215
	add	x29, sp, 0
	ldrh	w1, [x1, #:lo12:.LANCHOR60]
	strh	w1, [x0, 10]
	mov	w1, -3962
	strh	w1, [x0, 4]
	adrp	x1, .LANCHOR69
	ldrh	w1, [x1, #:lo12:.LANCHOR69]
	strh	w1, [x0, 8]
	adrp	x1, .LANCHOR61
	ldrh	w1, [x1, #:lo12:.LANCHOR61]
	strh	w1, [x0, 6]
	adrp	x1, .LANCHOR70
	ldr	x1, [x1, #:lo12:.LANCHOR70]
	str	x1, [x0, 16]
	adrp	x1, .LANCHOR190
	ldr	x1, [x1, #:lo12:.LANCHOR190]
	str	x1, [x0, 24]
	adrp	x1, .LANCHOR189
	ldr	x1, [x1, #:lo12:.LANCHOR189]
	str	x1, [x0, 32]
	adrp	x1, .LANCHOR191
	ldr	x1, [x1, #:lo12:.LANCHOR191]
	str	x1, [x0, 40]
	mov	w1, -1
	strh	w1, [x0, 60]
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
	adrp	x0, .LANCHOR124
	add	x0, x0, :lo12:.LANCHOR124
	bl	FtlMapTblRecovery
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
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
	beq	.L2243
	ldrb	w0, [x19, 6]
	str	w0, [x29, 180]
	adrp	x0, .LANCHOR51
	ldrh	w26, [x19, 2]
	str	x0, [x29, 144]
	ldrh	w2, [x0, #:lo12:.LANCHOR51]
	cmp	w2, w26
	bne	.L2087
	strh	wzr, [x19, 4]
.L2250:
	strb	wzr, [x19, 6]
.L2243:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	ret
.L2087:
	ldrh	w0, [x19, 16]
	mov	w21, 0
.L2088:
	cmp	w0, w1
	beq	.L2089
	ldrb	w1, [x19, 8]
	cmp	w1, 1
	bne	.L2090
	bl	FtlGetLastWrittenPage
	mov	w20, w0
	cmn	w0, #1
	beq	.L2091
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbnz	w0, .L2168
	adrp	x0, .LANCHOR16
	add	x0, x0, :lo12:.LANCHOR16
	ldrh	w23, [x0, w20, sxtw 1]
.L2092:
	adrp	x1, .LANCHOR105
	adrp	x2, .LANCHOR36
	adrp	x22, .LANCHOR178
	add	x4, x19, 16
	ldr	x6, [x1, #:lo12:.LANCHOR105]
	adrp	x1, .LANCHOR57
	ldr	x0, [x22, #:lo12:.LANCHOR178]
	mov	w27, 0
	ldrh	w7, [x1, #:lo12:.LANCHOR57]
	add	x1, x19, 16
	str	x1, [x29, 184]
	mov	w8, 65535
	ldrh	w1, [x2, #:lo12:.LANCHOR36]
	mov	w10, 56
	str	x2, [x29, 160]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L2093:
	cmp	x1, x4
	bne	.L2097
	ldrb	w1, [x19, 8]
	cmp	w1, 1
	bne	.L2169
	adrp	x1, .LANCHOR8
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	cmp	w1, 0
	cset	w1, ne
	str	w1, [x29, 176]
.L2098:
	ldr	w2, [x29, 176]
	mov	w1, w27
	adrp	x24, .LC43
	adrp	x25, .LANCHOR229
	add	x24, x24, :lo12:.LC43
	add	x25, x25, :lo12:.LANCHOR229
	mov	x28, 0
	bl	FlashReadPages
	adrp	x0, .LANCHOR158
	mov	w5, 65535
	str	x0, [x29, 168]
	ldr	w21, [x0, #:lo12:.LANCHOR158]
	sub	w21, w21, #1
.L2099:
	and	w0, w28, 65535
	cmp	w27, w0
	bhi	.L2104
	bne	.L2102
	ldr	x0, [x22, #:lo12:.LANCHOR178]
	add	w20, w20, 1
	and	w20, w20, 65535
	ldr	w0, [x0, 4]
.L2245:
	lsr	w0, w0, 10
	bl	P2V_plane
	ldrb	w1, [x19, 8]
	and	w27, w0, 65535
	cmp	w1, 1
	bne	.L2106
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbnz	w0, .L2106
	adrp	x0, .LANCHOR16
	add	x0, x0, :lo12:.LANCHOR16
	ldrh	w20, [x0, w20, sxtw 1]
.L2106:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w20
	bne	.L2107
	strh	w20, [x19, 2]
	strb	wzr, [x19, 6]
	strh	wzr, [x19, 4]
.L2107:
	ldr	w0, [x29, 180]
	cmp	w20, w26
	cset	w2, eq
	cmp	w27, w0
	cset	w0, eq
	tst	w2, w0
	beq	.L2108
.L2251:
	mov	w2, w27
	mov	w1, w20
	mov	x0, x19
	bl	ftl_sb_update_avl_pages
	b	.L2243
.L2089:
	add	w21, w21, 1
	and	w21, w21, 65535
	add	x0, x19, x21, sxtw 1
	ldrh	w0, [x0, 16]
	b	.L2088
.L2090:
	mov	w1, 0
	bl	FtlGetLastWrittenPage
	mov	w20, w0
	cmn	w0, #1
	beq	.L2091
.L2168:
	mov	w23, w20
	b	.L2092
.L2091:
	cbz	w26, .L2094
	mov	w2, 1896
	adrp	x1, .LANCHOR228
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2094:
	ldr	w0, [x29, 180]
	cmp	w0, 0
	ccmp	w21, w0, 4, ne
	beq	.L2095
	mov	w2, 1897
	adrp	x1, .LANCHOR228
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2095:
	strh	wzr, [x19, 2]
	b	.L2250
.L2097:
	ldrh	w2, [x4]
	cmp	w2, w8
	beq	.L2096
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
.L2096:
	add	x4, x4, 2
	b	.L2093
.L2169:
	str	wzr, [x29, 176]
	b	.L2098
.L2104:
	mov	x0, 56
	ldr	x2, [x22, #:lo12:.LANCHOR178]
	mul	x0, x28, x0
	add	x1, x2, x0
	ldr	w0, [x2, x0]
	cbnz	w0, .L2100
	ldr	x6, [x1, 16]
	ldr	w4, [x6, 4]
	cmn	w4, #1
	beq	.L2101
	ldr	x0, [x29, 168]
	ldr	w1, [x0, #:lo12:.LANCHOR158]
	mov	w0, w4
	bl	ftl_cmp_data_ver
	cbz	w0, .L2101
	ldr	x0, [x29, 168]
	add	w4, w4, 1
	str	w4, [x0, #:lo12:.LANCHOR158]
.L2101:
	ldr	w0, [x6]
	cmn	w0, #1
	bne	.L2103
.L2102:
	ldr	x0, [x22, #:lo12:.LANCHOR178]
	and	x28, x28, 65535
	mov	x1, 56
	and	w20, w20, 65535
	madd	x28, x28, x1, x0
	ldr	w0, [x28, 4]
	b	.L2245
.L2100:
	ldr	w1, [x1, 4]
	mov	x0, x24
	bl	printf
	ldrh	w0, [x19]
	and	w5, w23, 65535
	strh	w0, [x25]
.L2103:
	add	x28, x28, 1
	b	.L2099
.L2108:
	mov	w0, 65535
	cmp	w5, w0
	bne	.L2109
	cbnz	w1, .L2110
.L2109:
	adrp	x24, .LANCHOR133
	and	w6, w23, 65535
	ldr	w0, [x24, #:lo12:.LANCHOR133]
	cmn	w0, #1
	bne	.L2111
	str	w21, [x24, #:lo12:.LANCHOR133]
.L2111:
	add	w0, w26, 7
	ldr	w7, [x24, #:lo12:.LANCHOR133]
	cmp	w0, w23, uxth
	bge	.L2170
	sub	w23, w6, #7
	and	w23, w23, 65535
.L2112:
	mov	w3, -1
	adrp	x5, .LANCHOR117
	mov	w28, w3
	add	x5, x5, :lo12:.LANCHOR117
	mov	w4, 65535
.L2113:
	cmp	w23, w6
	bhi	.L2128
	ldr	x1, [x29, 160]
	mov	w25, 0
	ldr	x0, [x22, #:lo12:.LANCHOR178]
	mov	w10, 56
	ldr	x2, [x29, 184]
	ldrh	w1, [x1, #:lo12:.LANCHOR36]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
	b	.L2129
.L2170:
	mov	w23, w26
	b	.L2112
.L2115:
	ldrh	w8, [x2]
	cmp	w8, w4
	beq	.L2114
	umaddl	x11, w25, w10, x0
	add	w25, w25, 1
	and	w25, w25, 65535
	orr	w8, w23, w8, lsl 10
	str	w8, [x11, 4]
.L2114:
	add	x2, x2, 2
.L2129:
	cmp	x2, x1
	bne	.L2115
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
	ldr	w0, [x24, #:lo12:.LANCHOR133]
	sxtw	x12, w23
	ldrb	w10, [x1, #:lo12:.LANCHOR8]
	mov	w11, 1
	ldr	x1, [x22, #:lo12:.LANCHOR178]
	ldr	w4, [x29, 120]
	ldr	w7, [x29, 128]
	ldr	w6, [x29, 136]
	ldr	w3, [x29, 152]
	nop // between mem op and mult-accumulate
	umaddl	x25, w25, w2, x1
	ldr	x5, [x29, 112]
	mov	w2, 0
.L2116:
	cmp	x25, x1
	bne	.L2126
	cbz	w2, .L2127
	str	w0, [x24, #:lo12:.LANCHOR133]
.L2127:
	add	w23, w23, 1
	and	w23, w23, 65535
	b	.L2113
.L2126:
	ldr	w8, [x1]
	cbnz	w8, .L2117
	ldr	x8, [x1, 16]
	ldrh	w13, [x8]
	cmp	w13, w4
	beq	.L2172
	ldr	w8, [x8, 4]
	cmn	w8, #1
	beq	.L2172
	cmn	w3, #1
	bne	.L2174
	ldrh	w2, [x5, x12, lsl 1]
	cmp	w2, w4
	bne	.L2119
	cbz	w10, .L2174
.L2119:
	cmp	w21, w0
	mov	w2, w11
	csel	w3, w3, w0, eq
.L2118:
	mov	w28, w0
	add	x1, x1, 56
	mov	w0, w8
	b	.L2116
.L2117:
	cbz	w2, .L2120
	str	w0, [x24, #:lo12:.LANCHOR133]
.L2120:
	adrp	x0, .LANCHOR229
	ldrh	w1, [x19]
	strh	w1, [x0, #:lo12:.LANCHOR229]
	ldrb	w0, [x19, 8]
	cbnz	w0, .L2110
	adrp	x0, .LANCHOR117
	add	x0, x0, :lo12:.LANCHOR117
	ldrh	w1, [x0, w23, sxtw 1]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2122
	cmn	w3, #1
	beq	.L2123
	str	w3, [x24, #:lo12:.LANCHOR133]
.L2110:
	mov	w1, 1
	adrp	x0, .LANCHOR230
	mov	w23, w26
	adrp	x28, .LANCHOR133
	strh	w1, [x0, #:lo12:.LANCHOR230]
	adrp	x0, .LANCHOR124
	add	x0, x0, :lo12:.LANCHOR124
	bl	FtlMapBlkWriteDumpData
	add	x0, x28, :lo12:.LANCHOR133
	str	x0, [x29, 112]
.L2130:
	ldr	x2, [x29, 160]
	adrp	x1, .LANCHOR8
	ldr	x0, [x22, #:lo12:.LANCHOR178]
	mov	w24, 0
	ldrb	w5, [x1, #:lo12:.LANCHOR8]
	mov	w6, 65535
	ldr	x3, [x29, 184]
	ldrh	w2, [x2, #:lo12:.LANCHOR36]
	str	x1, [x29, 128]
	add	x2, x2, 8
	add	x2, x19, x2, lsl 1
.L2131:
	cmp	x2, x3
	bne	.L2134
	ldr	w2, [x29, 176]
	mov	w1, w24
	mov	x25, 0
	bl	FlashReadPages
	mov	w0, 56
	umull	x0, w24, w0
	str	x0, [x29, 136]
	adrp	x0, .LANCHOR229
	add	x0, x0, :lo12:.LANCHOR229
	str	x0, [x29, 120]
.L2135:
	ldr	x0, [x29, 136]
	cmp	x25, x0
	bne	.L2161
	ldrb	w0, [x19, 8]
	add	w23, w23, 1
	and	w23, w23, 65535
	cmp	w0, 1
	bne	.L2162
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L2162
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w23
	bne	.L2162
	cmp	w20, w23
	beq	.L2137
.L2162:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w23
	bne	.L2130
	ldr	x0, [x29, 160]
	mov	w2, 65535
	strh	w23, [x19, 2]
	strh	wzr, [x19, 4]
	ldrh	w1, [x0, #:lo12:.LANCHOR36]
	mov	w0, 0
.L2163:
	cmp	w0, w1
	beq	.L2243
	ldr	x4, [x29, 184]
	ldrh	w3, [x4], 2
	str	x4, [x29, 184]
	cmp	w3, w2
	beq	.L2164
	strb	w0, [x19, 6]
	b	.L2243
.L2123:
	cmp	w21, w7
	beq	.L2124
	str	w7, [x24, #:lo12:.LANCHOR133]
	b	.L2110
.L2124:
	ldr	w0, [x24, #:lo12:.LANCHOR133]
.L2252:
	sub	w0, w0, #1
.L2246:
	str	w0, [x24, #:lo12:.LANCHOR133]
	b	.L2110
.L2122:
	cmp	w28, w21
	beq	.L2125
	cmn	w28, #1
	beq	.L2110
	str	w28, [x24, #:lo12:.LANCHOR133]
	b	.L2110
.L2125:
	ldr	w0, [x24, #:lo12:.LANCHOR133]
	cmp	w21, w0
	bne	.L2252
	b	.L2110
.L2172:
	mov	w8, w0
	mov	w0, w28
	b	.L2118
.L2174:
	mov	w2, 1
	b	.L2118
.L2128:
	mov	w0, -1
	b	.L2246
.L2134:
	ldrh	w1, [x3]
	cmp	w1, w6
	beq	.L2132
	mov	w4, 56
	orr	w1, w23, w1, lsl 10
	umaddl	x4, w24, w4, x0
	str	w1, [x4, 4]
	ldrb	w7, [x19, 8]
	cmp	w7, 1
	bne	.L2133
	cbz	w5, .L2133
	orr	w1, w1, -2147483648
	str	w1, [x4, 4]
.L2133:
	add	w24, w24, 1
	and	w24, w24, 65535
.L2132:
	add	x3, x3, 2
	b	.L2131
.L2161:
	ldr	x4, [x22, #:lo12:.LANCHOR178]
	add	x4, x4, x25
	ldr	w5, [x4, 4]
	str	w5, [x29, 204]
	lsr	w0, w5, 10
	bl	P2V_plane
	and	w0, w0, 65535
	cmp	w23, w26
	bcc	.L2136
	ldr	w1, [x29, 180]
	ccmp	w1, w0, 0, eq
	bhi	.L2136
	cmp	w23, w20
	ccmp	w27, w0, 0, eq
	beq	.L2137
	ldr	w0, [x4]
	cmn	w0, #1
	beq	.L2138
	ldr	x3, [x4, 16]
	mov	w0, 61589
	ldrh	w1, [x3]
	cmp	w1, w0
	beq	.L2139
.L2145:
	ldrh	w0, [x19]
.L2249:
	bl	decrement_vpc_count
.L2136:
	add	x25, x25, 56
	b	.L2135
.L2139:
	ldr	w21, [x3, 4]
	cmn	w21, #1
	beq	.L2140
	ldr	x0, [x29, 168]
	ldr	w1, [x0, #:lo12:.LANCHOR158]
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L2140
	ldr	x1, [x29, 168]
	add	w0, w21, 1
	str	w0, [x1, #:lo12:.LANCHOR158]
.L2140:
	ldp	w24, w0, [x3, 8]
	add	x1, x29, 200
	str	w0, [x29, 196]
	mov	w2, 0
	mov	w0, w24
	bl	log2phys
	ldr	w1, [x28, #:lo12:.LANCHOR133]
	cmn	w1, #1
	beq	.L2141
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L2141
	ldr	w1, [x29, 196]
	cmn	w1, #1
	beq	.L2142
	ldr	x0, [x22, #:lo12:.LANCHOR178]
	mov	w2, 0
	add	x0, x0, x25
	ldr	x3, [x0, 16]
	str	w1, [x0, 4]
	mov	w1, 1
	str	x3, [x29, 152]
	bl	FlashReadPages
	ldr	x0, [x22, #:lo12:.LANCHOR178]
	ldr	x3, [x29, 152]
	add	x4, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L2143
.L2144:
	mov	w0, -1
	str	w0, [x29, 196]
	ldrh	w0, [x19]
	bl	decrement_vpc_count
.L2152:
	ldr	w3, [x29, 196]
	cmn	w3, #1
	beq	.L2136
.L2167:
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	and	w24, w0, 65535
	adrp	x0, .LANCHOR38
	mov	w3, w24
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w0, w24
	bhi	.L2157
	mov	w2, 2179
	adrp	x1, .LANCHOR228
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR228
	add	x0, x0, :lo12:.LC4
	str	w24, [x29, 152]
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
	ldr	w3, [x29, 152]
.L2157:
	adrp	x1, .LANCHOR82
	ubfiz	x0, x24, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR82]
	ldrh	w0, [x1, x0]
	cbz	w0, .L2158
	mov	w0, w3
	b	.L2249
.L2142:
	ldp	w1, w0, [x29, 200]
	cmp	w1, w0
	bne	.L2145
	mov	w2, 1
	add	x1, x29, 196
	mov	w0, w24
	bl	log2phys
	b	.L2145
.L2143:
	ldr	w0, [x3, 8]
	cmp	w24, w0
	bne	.L2144
	ldr	w0, [x3, 4]
	str	w0, [x29, 152]
	str	x3, [x29, 104]
	uxtw	x1, w0
	ldr	w0, [x28, #:lo12:.LANCHOR133]
	bl	ftl_cmp_data_ver
	cbz	w0, .L2144
	ldp	w0, w1, [x29, 200]
	ldr	x3, [x29, 104]
	cmp	w0, w1
	ldr	w1, [x29, 196]
	bne	.L2147
.L2247:
	mov	w0, w24
	bl	FtlReUsePrevPpa
	b	.L2144
.L2147:
	cmp	w0, w1
	beq	.L2144
	cmn	w0, #1
	beq	.L2148
	ldr	x3, [x4, 16]
	mov	w2, 0
	str	w0, [x4, 4]
	mov	w1, 1
	str	x3, [x29, 104]
	mov	x0, x4
	bl	FlashReadPages
	ldr	x3, [x29, 104]
.L2149:
	ldr	x0, [x22, #:lo12:.LANCHOR178]
	ldr	w0, [x0, x25]
	cmn	w0, #1
	beq	.L2150
	ldr	x0, [x29, 112]
	ldr	w3, [x3, 4]
	mov	w1, w3
	ldr	w0, [x0]
	bl	ftl_cmp_data_ver
	cbz	w0, .L2150
	ldr	w0, [x29, 152]
	mov	w1, w3
	bl	ftl_cmp_data_ver
	cbz	w0, .L2144
.L2150:
	ldr	w1, [x29, 196]
	b	.L2247
.L2148:
	str	w0, [x4]
	b	.L2149
.L2141:
	ldp	w1, w0, [x29, 200]
	cmp	w1, w0
	beq	.L2152
	mov	w2, 1
	add	x1, x29, 204
	mov	w0, w24
	bl	log2phys
	ldr	w3, [x29, 200]
	cmn	w3, #1
	beq	.L2152
	ldr	w0, [x29, 196]
	cmp	w3, w0
	beq	.L2167
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	adrp	x1, .LANCHOR90
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR90]
	cmp	w1, w0
	beq	.L2156
	adrp	x1, .LANCHOR91
	ldrh	w1, [x1, #:lo12:.LANCHOR91]
	cmp	w1, w0
	beq	.L2156
	adrp	x1, .LANCHOR92
	ldrh	w1, [x1, #:lo12:.LANCHOR92]
	cmp	w1, w0
	bne	.L2152
.L2156:
	ldr	x0, [x22, #:lo12:.LANCHOR178]
	mov	w2, 0
	mov	w1, 1
	ldr	x4, [x0, 16]
	str	w3, [x0, 4]
	str	x4, [x29, 152]
	bl	FlashReadPages
	ldr	x0, [x22, #:lo12:.LANCHOR178]
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L2152
	ldr	x4, [x29, 152]
	mov	w0, w21
	ldr	w1, [x4, 4]
	bl	ftl_cmp_data_ver
	cbnz	w0, .L2152
	mov	w2, 1
	add	x1, x29, 200
	mov	w0, w24
	bl	log2phys
	b	.L2152
.L2158:
	mov	w1, w24
	adrp	x0, .LC44
	add	x0, x0, :lo12:.LC44
	bl	printf
	b	.L2136
.L2138:
	ldr	x1, [x29, 120]
	mov	w2, w21
	ldrh	w0, [x19]
	strh	w0, [x1]
	mov	w1, w5
	adrp	x0, .LC45
	add	x0, x0, :lo12:.LC45
	bl	printf
	adrp	x2, .LANCHOR231
	ldr	w0, [x2, #:lo12:.LANCHOR231]
	cmp	w0, 31
	bhi	.L2159
	adrp	x1, .LANCHOR232
	add	x1, x1, :lo12:.LANCHOR232
	ldr	w3, [x29, 204]
	str	w3, [x1, w0, uxtw 2]
	add	w0, w0, 1
	str	w0, [x2, #:lo12:.LANCHOR231]
.L2159:
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	ldr	w0, [x28, #:lo12:.LANCHOR133]
	cmn	w0, #1
	bne	.L2160
.L2248:
	str	w21, [x28, #:lo12:.LANCHOR133]
	b	.L2136
.L2160:
	cmp	w21, w0
	bcs	.L2136
	b	.L2248
.L2164:
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L2163
.L2137:
	strb	w27, [x19, 6]
	strh	w20, [x19, 2]
	b	.L2251
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
	.section	.text.FtlGcScanTempBlk,"ax",@progbits
	.align	2
	.global	FtlGcScanTempBlk
	.type	FtlGcScanTempBlk, %function
FtlGcScanTempBlk:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR233
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	ldrh	w19, [x23, #:lo12:.LANCHOR233]
	mov	w0, 65535
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	cmp	w19, w0
	stp	x27, x28, [sp, 80]
	beq	.L2271
	cbnz	w19, .L2254
.L2255:
	bl	FtlGcPageVarInit
	b	.L2256
.L2271:
	mov	w19, 0
.L2254:
	adrp	x0, .LANCHOR51
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w1
	beq	.L2255
.L2256:
	adrp	x25, .LANCHOR57
	add	x25, x25, :lo12:.LANCHOR57
	mov	w26, -1
	mov	w24, 65535
.L2268:
	ldrh	w0, [x20]
	strb	wzr, [x20, 8]
	cmp	w0, w24
	beq	.L2272
	mov	w27, 56
.L2270:
	adrp	x1, .LANCHOR105
	adrp	x22, .LANCHOR178
	ldrh	w6, [x25]
	add	x3, x20, 16
	ldr	x5, [x1, #:lo12:.LANCHOR105]
	adrp	x1, .LANCHOR36
	ldr	x0, [x22, #:lo12:.LANCHOR178]
	mov	w21, 0
	ldrh	w1, [x1, #:lo12:.LANCHOR36]
	add	x1, x1, 8
	add	x1, x20, x1, lsl 1
.L2258:
	cmp	x3, x1
	bne	.L2260
	mov	w1, w21
	umull	x21, w21, w27
	mov	x28, 0
	mov	w2, 0
	bl	FlashReadPages
.L2261:
	cmp	x28, x21
	bne	.L2269
	adrp	x0, .LANCHOR51
	add	w19, w19, 1
	and	w19, w19, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	cmp	w0, w19
	bhi	.L2270
.L2272:
	mov	w2, 0
	b	.L2257
.L2260:
	ldrh	w2, [x3]
	cmp	w2, w24
	beq	.L2259
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
.L2259:
	add	x3, x3, 2
	b	.L2258
.L2269:
	ldr	x6, [x22, #:lo12:.LANCHOR178]
	add	x5, x6, x28
	ldr	w4, [x5, 4]
	lsr	w0, w4, 10
	bl	P2V_plane
	and	w2, w0, 65535
	ldr	w0, [x6, x28]
	cbnz	w0, .L2262
	ldr	x0, [x5, 16]
	add	x28, x28, 56
	ldrh	w1, [x0]
	cmp	w1, w24
	bne	.L2263
	adrp	x0, .LANCHOR132
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR132]
.L2257:
	strb	w2, [x20, 6]
	mov	w0, -1
	strh	w19, [x20, 2]
	mov	w1, w19
	strh	w0, [x23, #:lo12:.LANCHOR233]
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
.L2263:
	ldp	w2, w0, [x0, 8]
	mov	w1, w4
	bl	FtlGcUpdatePage
	b	.L2261
.L2262:
	ldrh	w1, [x20]
	mov	w2, w4
	adrp	x0, .LC46
	add	x0, x0, :lo12:.LC46
	bl	printf
	adrp	x0, .LANCHOR101
	ldr	w1, [x0, #:lo12:.LANCHOR101]
	ldrh	w0, [x20]
	cbnz	w1, .L2264
	adrp	x1, .LANCHOR8
	ldrb	w1, [x1, #:lo12:.LANCHOR8]
	cbz	w1, .L2265
.L2264:
	adrp	x2, .LANCHOR77
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR77]
	ldrh	w1, [x2, x1]
	cmp	w1, 119
	bls	.L2266
.L2265:
	ldr	x1, [x22, #:lo12:.LANCHOR178]
	ldr	w1, [x1, x28]
	cmn	w1, #1
	bne	.L2267
.L2266:
	ldr	x1, [x22, #:lo12:.LANCHOR178]
	add	x28, x1, x28
	ldr	w26, [x28, 4]
.L2267:
	adrp	x1, .LANCHOR82
	ubfiz	x0, x0, 1, 16
	mov	w19, 0
	ldr	x1, [x1, #:lo12:.LANCHOR82]
	strh	wzr, [x1, x0]
	ldrh	w0, [x20]
	bl	INSERT_FREE_LIST
	mov	w0, -1
	strh	w0, [x20]
	bl	FtlGcPageVarInit
	b	.L2268
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
	.section	.text.FtlGcFreeTempBlock,"ax",@progbits
	.align	2
	.global	FtlGcFreeTempBlock
	.type	FtlGcFreeTempBlock, %function
FtlGcFreeTempBlock:
	adrp	x0, .LANCHOR75
	ldr	w0, [x0, #:lo12:.LANCHOR75]
	cbz	w0, .L2282
	mov	w0, 0
	ret
.L2282:
	stp	x29, x30, [sp, -112]!
	mov	w1, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR92
	stp	x21, x22, [sp, 32]
	add	x0, x19, :lo12:.LANCHOR92
	ldrh	w20, [x19, #:lo12:.LANCHOR92]
	adrp	x21, .LANCHOR132
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w20, w1
	str	x27, [sp, 80]
	beq	.L2284
	adrp	x1, .LANCHOR51
	ldrh	w1, [x1, #:lo12:.LANCHOR51]
	bl	FtlGcScanTempBlk
	str	w0, [x29, 108]
	cmn	w0, #1
	beq	.L2284
	adrp	x0, .LANCHOR77
	ubfiz	x20, x20, 1, 16
	ldr	x1, [x0, #:lo12:.LANCHOR77]
	ldrh	w0, [x1, x20]
	cmp	w0, 4
	bls	.L2285
	sub	w0, w0, #5
	strh	w0, [x1, x20]
	mov	w0, 1
	bl	FtlEctTblFlush
.L2285:
	ldr	w0, [x21, #:lo12:.LANCHOR132]
	cbnz	w0, .L2286
	adrp	x0, .LANCHOR136
	add	x0, x0, :lo12:.LANCHOR136
	ldr	w1, [x0, 96]
	add	w1, w1, 1
	str	w1, [x0, 96]
	ldr	w0, [x29, 108]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L2286:
	str	wzr, [x21, #:lo12:.LANCHOR132]
	mov	w0, 1
.L2281:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2284:
	str	wzr, [x21, #:lo12:.LANCHOR132]
	mov	w0, 65535
	ldrh	w1, [x19, #:lo12:.LANCHOR92]
	add	x21, x19, :lo12:.LANCHOR92
	cmp	w1, w0
	beq	.L2307
	bl	FtlCacheWriteBack
	adrp	x20, .LANCHOR110
	adrp	x0, .LANCHOR51
	ldrb	w1, [x21, 7]
	ldrh	w2, [x20, #:lo12:.LANCHOR110]
	mov	x21, x0
	ldrh	w3, [x0, #:lo12:.LANCHOR51]
	mul	w1, w1, w3
	cmp	w2, w1
	beq	.L2288
	mov	w2, 163
	adrp	x1, .LANCHOR234
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR234
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2288:
	add	x0, x19, :lo12:.LANCHOR92
	adrp	x23, .LANCHOR82
	ldrh	w3, [x21, #:lo12:.LANCHOR51]
	adrp	x25, .LANCHOR71
	ldrh	w2, [x19, #:lo12:.LANCHOR92]
	adrp	x26, .LANCHOR234
	ldrb	w0, [x0, 7]
	add	x25, x25, :lo12:.LANCHOR71
	ldr	x1, [x23, #:lo12:.LANCHOR82]
	add	x26, x26, :lo12:.LANCHOR234
	mov	w21, 0
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	adrp	x1, .LANCHOR159
	ldrh	w0, [x20, #:lo12:.LANCHOR110]
	ldr	w2, [x1, #:lo12:.LANCHOR159]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR159]
.L2289:
	ldrh	w0, [x20, #:lo12:.LANCHOR110]
	cmp	w0, w21
	bhi	.L2293
	mov	w0, -1
	bl	decrement_vpc_count
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L2294
	ldrh	w1, [x19, #:lo12:.LANCHOR92]
	adrp	x0, .LC47
	add	x0, x0, :lo12:.LC47
	bl	printf
.L2294:
	ldrh	w0, [x19, #:lo12:.LANCHOR92]
	ldr	x2, [x23, #:lo12:.LANCHOR82]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbz	w1, .L2295
	bl	INSERT_DATA_LIST
.L2296:
	adrp	x0, .LANCHOR108
	mov	w21, -1
	strh	wzr, [x20, #:lo12:.LANCHOR110]
	strh	w21, [x19, #:lo12:.LANCHOR92]
	strh	wzr, [x0, #:lo12:.LANCHOR108]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	adrp	x0, .LANCHOR87
	ldrh	w1, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR227
	ldrh	w0, [x0, #:lo12:.LANCHOR227]
	add	w0, w0, w0, lsl 1
	cmp	w1, w0, lsr 2
	ble	.L2307
	adrp	x0, .LANCHOR201
	mov	w1, 20
	strh	w21, [x0, #:lo12:.LANCHOR201]
	adrp	x0, .LANCHOR174
	strh	w1, [x0, #:lo12:.LANCHOR174]
.L2307:
	mov	w0, 0
	b	.L2281
.L2293:
	adrp	x0, .LANCHOR111
	mov	w24, 12
	ldr	x27, [x0, #:lo12:.LANCHOR111]
	umull	x24, w21, w24
	ldr	w0, [x25]
	add	x22, x27, x24
	ldr	w1, [x22, 8]
	cmp	w1, w0
	bcc	.L2290
	mov	w2, 168
	mov	x1, x26
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2290:
	ldr	w0, [x22, 8]
	add	x1, x29, 108
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x27, x24]
	ldr	w1, [x29, 108]
	cmp	w0, w1
	bne	.L2291
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	mov	w24, w0
	ldr	w0, [x22, 8]
	mov	w2, 1
	add	x1, x22, 4
	bl	log2phys
	mov	w0, w24
.L2306:
	bl	decrement_vpc_count
.L2292:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L2289
.L2291:
	ldr	w0, [x22, 4]
	cmp	w1, w0
	beq	.L2292
	ldrh	w0, [x19, #:lo12:.LANCHOR92]
	b	.L2306
.L2295:
	bl	INSERT_FREE_LIST
	b	.L2296
	.size	FtlGcFreeTempBlock, .-FtlGcFreeTempBlock
	.section	.text.Ftl_get_new_temp_ppa,"ax",@progbits
	.align	2
	.global	Ftl_get_new_temp_ppa
	.type	Ftl_get_new_temp_ppa, %function
Ftl_get_new_temp_ppa:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR92
	mov	w2, 65535
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	x19, x0
	ldrh	w3, [x0, #:lo12:.LANCHOR92]
	cmp	w3, w2
	beq	.L2309
	add	x1, x0, :lo12:.LANCHOR92
	ldrh	w0, [x1, 4]
	cbnz	w0, .L2310
.L2309:
	bl	FtlCacheWriteBack
	mov	w0, 0
	bl	FtlGcFreeTempBlock
	add	x0, x19, :lo12:.LANCHOR92
	strb	wzr, [x0, 8]
	bl	allocate_data_superblock
	adrp	x0, .LANCHOR108
	strh	wzr, [x0, #:lo12:.LANCHOR108]
	adrp	x0, .LANCHOR110
	strh	wzr, [x0, #:lo12:.LANCHOR110]
	bl	l2p_flush
	mov	w0, 0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2310:
	add	x0, x19, :lo12:.LANCHOR92
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	get_new_active_ppa
	.size	Ftl_get_new_temp_ppa, .-Ftl_get_new_temp_ppa
	.section	.text.Ftl_gc_temp_data_write_back,"ax",@progbits
	.align	2
	.global	Ftl_gc_temp_data_write_back
	.type	Ftl_gc_temp_data_write_back, %function
Ftl_gc_temp_data_write_back:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR8
	add	x29, sp, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR102
	cbz	w0, .L2313
	ldr	w0, [x19, #:lo12:.LANCHOR102]
	tbz	x0, 0, .L2313
	adrp	x0, .LANCHOR92+4
	ldrh	w0, [x0, #:lo12:.LANCHOR92+4]
	cbz	w0, .L2313
.L2318:
	mov	w0, 0
.L2312:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2313:
	adrp	x20, .LANCHOR179
	ldr	w1, [x19, #:lo12:.LANCHOR102]
	mov	w3, 0
	mov	w2, 0
	ldr	x0, [x20, #:lo12:.LANCHOR179]
	add	x19, x19, :lo12:.LANCHOR102
	bl	FlashProgPages
	mov	w11, 0
	mov	w12, 56
.L2315:
	ldr	w1, [x19]
	cmp	w11, w1
	bcc	.L2317
	ldr	x0, [x20, #:lo12:.LANCHOR179]
	bl	FtlGcBufFree
	str	wzr, [x19]
	adrp	x0, .LANCHOR92+4
	ldrh	w0, [x0, #:lo12:.LANCHOR92+4]
	cbnz	w0, .L2318
	mov	w0, 1
	bl	FtlGcFreeTempBlock
	b	.L2329
.L2317:
	umull	x0, w11, w12
	ldr	x2, [x20, #:lo12:.LANCHOR179]
	add	x1, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L2316
	adrp	x0, .LANCHOR92
	adrp	x3, .LANCHOR82
	ldrh	w4, [x0, #:lo12:.LANCHOR92]
	ldr	x3, [x3, #:lo12:.LANCHOR82]
	strh	wzr, [x3, x4, lsl 1]
	strh	w2, [x0, #:lo12:.LANCHOR92]
	adrp	x0, .LANCHOR136
	add	x0, x0, :lo12:.LANCHOR136
	ldr	w2, [x0, 96]
	add	w2, w2, 1
	str	w2, [x0, 96]
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
.L2329:
	mov	w0, 1
	b	.L2312
.L2316:
	ldr	x0, [x1, 16]
	ldr	w1, [x1, 4]
	ldp	w2, w0, [x0, 8]
	bl	FtlGcUpdatePage
	add	w11, w11, 1
	and	w11, w11, 65535
	b	.L2315
	.size	Ftl_gc_temp_data_write_back, .-Ftl_gc_temp_data_write_back
	.section	.text.FtlGcPageRecovery,"ax",@progbits
	.align	2
	.global	FtlGcPageRecovery
	.type	FtlGcPageRecovery, %function
FtlGcPageRecovery:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR51
	adrp	x19, .LANCHOR92
	add	x19, x19, :lo12:.LANCHOR92
	ldrh	w1, [x20, #:lo12:.LANCHOR51]
	mov	x0, x19
	bl	FtlGcScanTempBlk
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR51]
	cmp	w1, w0
	bcc	.L2330
	adrp	x0, .LANCHOR124
	add	x0, x0, :lo12:.LANCHOR124
	bl	FtlMapBlkWriteDumpData
	mov	w0, 0
	bl	FtlGcFreeTempBlock
	adrp	x0, .LANCHOR132
	str	wzr, [x0, #:lo12:.LANCHOR132]
.L2330:
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
	adrp	x0, .LANCHOR231
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR90
	add	x19, x19, :lo12:.LANCHOR90
	str	wzr, [x0, #:lo12:.LANCHOR231]
	mov	x0, x19
	bl	FtlRecoverySuperblock
	mov	x0, x19
	adrp	x19, .LANCHOR91
	bl	FtlSlcSuperblockCheck
	add	x19, x19, :lo12:.LANCHOR91
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
	stp	x29, x30, [sp, -64]!
	adrp	x0, .LANCHOR229
	mov	w1, -1
	add	x29, sp, 0
	strh	w1, [x0, #:lo12:.LANCHOR229]
	adrp	x0, .LANCHOR37
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR230
	ldrh	w0, [x0, #:lo12:.LANCHOR37]
	stp	x21, x22, [sp, 32]
	strh	wzr, [x19, #:lo12:.LANCHOR230]
	str	x23, [sp, 48]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	adrp	x0, .LANCHOR206
	ldrh	w1, [x0, #:lo12:.LANCHOR206]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2336
.L2338:
	mov	w23, -1
.L2335:
	mov	w0, w23
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L2336:
	bl	FtlLoadSysInfo
	mov	w23, w0
	cbnz	w0, .L2338
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	mov	w0, 1
	bl	FtlUpdateVaildLpn
	adrp	x2, .LANCHOR66
	adrp	x0, .LANCHOR95
	mov	x3, 4
	ldrh	w2, [x2, #:lo12:.LANCHOR66]
	ldr	x0, [x0, #:lo12:.LANCHOR95]
	add	x2, x3, x2, uxtw 4
	add	x1, x0, 4
	add	x0, x0, x2
.L2339:
	cmp	x1, x0
	bne	.L2341
	ldrh	w0, [x19, #:lo12:.LANCHOR230]
	cbnz	w0, .L2340
	b	.L2335
.L2341:
	ldr	w2, [x1], 16
	tbz	w2, #31, .L2339
.L2340:
	adrp	x22, .LANCHOR90
	add	x20, x22, :lo12:.LANCHOR90
	mov	x0, x20
	adrp	x21, .LANCHOR91
	bl	FtlSuperblockPowerLostFix
	add	x19, x21, :lo12:.LANCHOR91
	mov	x0, x19
	bl	FtlSuperblockPowerLostFix
	adrp	x0, .LANCHOR82
	ldrh	w3, [x20, 4]
	ldr	x1, [x0, #:lo12:.LANCHOR82]
	ldrh	w0, [x22, #:lo12:.LANCHOR90]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	sub	w2, w2, w3
	adrp	x3, .LANCHOR51
	strh	w2, [x1, x0]
	strb	wzr, [x20, 6]
	ldrh	w0, [x3, #:lo12:.LANCHOR51]
	strh	w0, [x20, 2]
	ldrh	w0, [x21, #:lo12:.LANCHOR91]
	strh	wzr, [x20, 4]
	ldrh	w4, [x19, 4]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	sub	w2, w2, w4
	strh	w2, [x1, x0]
	strb	wzr, [x19, 6]
	ldrh	w0, [x3, #:lo12:.LANCHOR51]
	strh	w0, [x19, 2]
	strh	wzr, [x19, 4]
	adrp	x0, .LANCHOR124
	add	x0, x0, :lo12:.LANCHOR124
	bl	FtlMapBlkWriteDumpData
	adrp	x0, .LANCHOR215
	add	x0, x0, :lo12:.LANCHOR215
	bl	FtlMapBlkWriteDumpData
	adrp	x0, .LANCHOR135
	add	x0, x0, :lo12:.LANCHOR135
	ldrh	w1, [x0, 30]
	add	w1, w1, 1
	strh	w1, [x0, 30]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	bl	FtlVpcTblFlush
	b	.L2335
	.size	FtlSysBlkInit, .-FtlSysBlkInit
	.section	.text.rk_ftl_garbage_collect,"ax",@progbits
	.align	2
	.global	rk_ftl_garbage_collect
	.type	rk_ftl_garbage_collect, %function
rk_ftl_garbage_collect:
	adrp	x1, .LANCHOR75
	ldr	w1, [x1, #:lo12:.LANCHOR75]
	cbnz	w1, .L2398
	stp	x29, x30, [sp, -192]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR169
	stp	x19, x20, [sp, 16]
	ldr	w1, [x21, #:lo12:.LANCHOR169]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w1, .L2400
	adrp	x1, .LANCHOR84
	ldrh	w1, [x1, #:lo12:.LANCHOR84]
	cmp	w1, 47
	bls	.L2400
	adrp	x1, .LANCHOR113
	mov	w4, 65535
	ldrh	w3, [x1, #:lo12:.LANCHOR113]
	cmp	w3, w4
	beq	.L2348
	adrp	x2, .LANCHOR112
	ldrh	w5, [x2, #:lo12:.LANCHOR112]
	cmp	w5, w4
	bne	.L2348
	strh	w3, [x2, #:lo12:.LANCHOR112]
	mov	w2, -1
	strh	w2, [x1, #:lo12:.LANCHOR113]
.L2348:
	cbnz	w0, .L2401
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w0, 24
	bhi	.L2402
	adrp	x1, .LANCHOR51
	cmp	w0, 16
	ldrh	w20, [x1, #:lo12:.LANCHOR51]
	bls	.L2351
	lsr	w20, w20, 5
.L2350:
	adrp	x2, .LANCHOR174
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR174]
	cmp	w1, w0
	bcs	.L2354
	adrp	x0, .LANCHOR92
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w0, w1
	bne	.L2355
	adrp	x1, .LANCHOR112
	ldrh	w1, [x1, #:lo12:.LANCHOR112]
	cmp	w1, w0
	bne	.L2355
	adrp	x0, .LANCHOR235
	ldrh	w0, [x0, #:lo12:.LANCHOR235]
	cbnz	w0, .L2356
	adrp	x1, .LANCHOR71
	adrp	x4, .LANCHOR99
	ldr	w1, [x1, #:lo12:.LANCHOR71]
	ldr	w4, [x4, #:lo12:.LANCHOR99]
	add	w1, w1, w1, lsl 1
	cmp	w4, w1, lsr 2
	bcs	.L2357
.L2356:
	adrp	x1, .LANCHOR227
	ldrh	w1, [x1, #:lo12:.LANCHOR227]
	add	w1, w1, w1, lsl 1
	asr	w1, w1, 2
	strh	w1, [x3, #:lo12:.LANCHOR174]
.L2358:
	adrp	x1, .LANCHOR170
	str	wzr, [x1, #:lo12:.LANCHOR170]
.L2346:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L2351:
	cmp	w0, 12
	bls	.L2352
	lsr	w20, w20, 4
	b	.L2350
.L2352:
	cmp	w0, 8
	bls	.L2350
	lsr	w20, w20, 2
	b	.L2350
.L2402:
	mov	w20, 1
	b	.L2350
.L2357:
	mov	w1, 18
	strh	w1, [x2, #:lo12:.LANCHOR174]
	b	.L2358
.L2355:
	adrp	x0, .LANCHOR227
	ldrh	w0, [x0, #:lo12:.LANCHOR227]
	add	w0, w0, w0, lsl 1
	asr	w0, w0, 2
	strh	w0, [x3, #:lo12:.LANCHOR174]
.L2354:
	adrp	x0, .LANCHOR114
	ldrh	w0, [x0, #:lo12:.LANCHOR114]
	cbz	w0, .L2349
	add	w20, w20, 32
	and	w20, w20, 65535
.L2349:
	adrp	x19, .LANCHOR201
	mov	w0, 65535
	ldrh	w2, [x19, #:lo12:.LANCHOR201]
	cmp	w2, w0
	bne	.L2361
	adrp	x0, .LANCHOR112
	ldrh	w1, [x0, #:lo12:.LANCHOR112]
	cmp	w1, w2
	beq	.L2362
	adrp	x2, .LANCHOR82
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR82]
	ldrh	w1, [x2, x1]
	cbnz	w1, .L2363
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR112]
.L2363:
	ldrh	w1, [x0, #:lo12:.LANCHOR112]
	strh	w1, [x19, #:lo12:.LANCHOR201]
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR112]
.L2362:
	add	x0, x19, :lo12:.LANCHOR201
	mov	w1, 65535
	strb	wzr, [x0, 8]
	ldrh	w0, [x19, #:lo12:.LANCHOR201]
	cmp	w0, w1
	beq	.L2361
	bl	IsBlkInGcList
	cbz	w0, .L2365
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR201]
.L2365:
	adrp	x0, .LANCHOR8
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbz	w0, .L2366
	ldrh	w0, [x19, #:lo12:.LANCHOR201]
	add	x3, x19, :lo12:.LANCHOR201
	bl	ftl_get_blk_mode
	strb	w0, [x3, 8]
.L2366:
	ldrh	w1, [x19, #:lo12:.LANCHOR201]
	mov	w0, 65535
	add	x22, x19, :lo12:.LANCHOR201
	cmp	w1, w0
	beq	.L2361
	mov	x0, x22
	bl	make_superblock
	adrp	x0, .LANCHOR236
	ldrh	w1, [x19, #:lo12:.LANCHOR201]
	strh	wzr, [x22, 2]
	strh	wzr, [x0, #:lo12:.LANCHOR236]
	adrp	x0, .LANCHOR82
	strb	wzr, [x22, 6]
	ldr	x0, [x0, #:lo12:.LANCHOR82]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR237
	strh	w1, [x0, #:lo12:.LANCHOR237]
.L2361:
	adrp	x0, .LANCHOR90
	ldrh	w1, [x19, #:lo12:.LANCHOR201]
	str	x0, [x29, 144]
	ldrh	w2, [x0, #:lo12:.LANCHOR90]
	cmp	w2, w1
	beq	.L2367
	adrp	x0, .LANCHOR91
	str	x0, [x29, 136]
	ldrh	w2, [x0, #:lo12:.LANCHOR91]
	cmp	w2, w1
	beq	.L2367
	adrp	x23, .LANCHOR176
	add	x0, x23, :lo12:.LANCHOR176
	str	x0, [x29, 168]
.L2368:
	ldrh	w1, [x19, #:lo12:.LANCHOR201]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2369
	adrp	x0, .LANCHOR170
	adrp	x22, .LANCHOR51
	add	x22, x22, :lo12:.LANCHOR51
	str	wzr, [x0, #:lo12:.LANCHOR170]
.L2370:
	ldrh	w5, [x23, #:lo12:.LANCHOR176]
	add	x7, x23, :lo12:.LANCHOR176
	mov	w0, w5
	bl	List_get_gc_head_node
	and	w6, w0, 65535
	strh	w6, [x19, #:lo12:.LANCHOR201]
	mov	w0, 65535
	cmp	w6, w0
	bne	.L2371
	strh	wzr, [x7]
	mov	w0, 8
	b	.L2346
.L2401:
	mov	w20, 1
	b	.L2349
.L2367:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR201]
.L2437:
	adrp	x0, .LANCHOR235
	ldrh	w0, [x0, #:lo12:.LANCHOR235]
	b	.L2346
.L2371:
	mov	w0, w6
	bl	IsBlkInGcList
	add	w5, w5, 1
	cbz	w0, .L2372
	strh	w5, [x23, #:lo12:.LANCHOR176]
	b	.L2370
.L2372:
	adrp	x24, .LANCHOR82
	adrp	x4, .LANCHOR36
	ldrh	w0, [x22]
	ubfiz	x1, x6, 1, 16
	ldr	x2, [x24, #:lo12:.LANCHOR82]
	and	w5, w5, 65535
	ldrh	w4, [x4, #:lo12:.LANCHOR36]
	strh	w5, [x23, #:lo12:.LANCHOR176]
	ldrh	w3, [x2, x1]
	mul	w0, w0, w4
	cmp	w3, w0, asr 1
	bgt	.L2374
	cmp	w5, 48
	bls	.L2375
	cmp	w3, 8
	bls	.L2375
	adrp	x3, .LANCHOR108
	ldrh	w3, [x3, #:lo12:.LANCHOR108]
	cmp	w3, 35
	bhi	.L2375
.L2374:
	ldr	x3, [x29, 168]
	strh	wzr, [x3]
.L2375:
	ldrh	w1, [x2, x1]
	cmp	w0, w1
	bgt	.L2376
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR201]
	adrp	x0, .LANCHOR176
	strh	wzr, [x0, #:lo12:.LANCHOR176]
	b	.L2437
.L2376:
	cbnz	w1, .L2377
	mov	w0, -1
	bl	decrement_vpc_count
	ldr	x0, [x29, 168]
	ldr	x1, [x29, 168]
	ldrh	w0, [x0]
	add	w0, w0, 1
	strh	w0, [x1]
	b	.L2370
.L2377:
	adrp	x0, .LANCHOR8
	add	x3, x19, :lo12:.LANCHOR201
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	strb	wzr, [x3, 8]
	cbz	w0, .L2378
	mov	w0, w6
	bl	ftl_get_blk_mode
	strb	w0, [x3, 8]
.L2378:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, #:lo12:.LANCHOR90]
	cmp	w0, w6
	bne	.L2379
	mov	w2, 835
	adrp	x1, .LANCHOR238
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR238
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2379:
	ldr	x0, [x29, 136]
	ldrh	w1, [x19, #:lo12:.LANCHOR201]
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w1, w0
	bne	.L2380
	mov	w2, 836
	adrp	x1, .LANCHOR238
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR238
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2380:
	adrp	x0, .LANCHOR92
	ldrh	w1, [x19, #:lo12:.LANCHOR201]
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w1, w0
	bne	.L2381
	mov	w2, 837
	adrp	x1, .LANCHOR238
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR238
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2381:
	add	x22, x19, :lo12:.LANCHOR201
	mov	x0, x22
	bl	make_superblock
	adrp	x0, .LANCHOR236
	ldrh	w1, [x19, #:lo12:.LANCHOR201]
	strh	wzr, [x0, #:lo12:.LANCHOR236]
	ldr	x0, [x24, #:lo12:.LANCHOR82]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR237
	strh	wzr, [x22, 2]
	strh	w1, [x0, #:lo12:.LANCHOR237]
	strb	wzr, [x22, 6]
.L2369:
	mov	w0, 1
	str	w0, [x21, #:lo12:.LANCHOR169]
	adrp	x0, .LANCHOR8
	adrp	x1, .LANCHOR51
	stp	x0, x1, [x29, 120]
	ldrb	w2, [x0, #:lo12:.LANCHOR8]
	ldrh	w26, [x1, #:lo12:.LANCHOR51]
	cbz	w2, .L2382
	add	x0, x19, :lo12:.LANCHOR201
	ldrb	w0, [x0, 8]
	cmp	w0, 1
	bne	.L2382
	adrp	x0, .LANCHOR52
	ldrh	w26, [x0, #:lo12:.LANCHOR52]
.L2382:
	add	x0, x19, :lo12:.LANCHOR201
	ldrh	w0, [x0, 2]
	add	w1, w0, w20
	cmp	w1, w26
	ble	.L2383
	sub	w20, w26, w0
	and	w20, w20, 65535
.L2383:
	adrp	x0, .LANCHOR236
	mov	w27, 0
	add	x0, x0, :lo12:.LANCHOR236
	str	x0, [x29, 160]
.L2384:
	cmp	w20, w27, uxth
	bls	.L2392
	add	x1, x19, :lo12:.LANCHOR201
	adrp	x0, .LANCHOR36
	adrp	x24, .LANCHOR106
	add	x1, x1, 16
	ldrh	w7, [x0, #:lo12:.LANCHOR36]
	mov	w22, 0
	ldrh	w4, [x1, -14]
	mov	w2, 0
	ldr	x0, [x24, #:lo12:.LANCHOR106]
	mov	w6, 65535
	add	w4, w4, w27
	mov	w5, 56
	b	.L2393
.L2386:
	ldrh	w3, [x1]
	cmp	w3, w6
	beq	.L2385
	umaddl	x8, w22, w5, x0
	add	w22, w22, 1
	and	w22, w22, 65535
	orr	w3, w4, w3, lsl 10
	str	w3, [x8, 4]
.L2385:
	add	w2, w2, 1
	add	x1, x1, 2
	and	w2, w2, 65535
.L2393:
	cmp	w2, w7
	bne	.L2386
	add	x1, x19, :lo12:.LANCHOR201
	adrp	x25, .LANCHOR102
	add	x25, x25, :lo12:.LANCHOR102
	ldrb	w2, [x1, 8]
	mov	w1, w22
	bl	FlashReadPages
	mov	w0, 56
	umull	x0, w22, w0
	mov	x22, 0
	str	x0, [x29, 152]
.L2387:
	ldr	x0, [x29, 152]
	cmp	x22, x0
	bne	.L2391
	add	w27, w27, 1
	b	.L2384
.L2391:
	ldr	x0, [x24, #:lo12:.LANCHOR106]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	cmn	w0, #1
	beq	.L2388
	ldr	x28, [x1, 16]
	mov	w0, 61589
	ldrh	w1, [x28]
	cmp	w1, w0
	bne	.L2388
	ldr	w4, [x28, 8]
	cmn	w4, #1
	bne	.L2389
	mov	w2, 876
	str	w4, [x29, 112]
	adrp	x1, .LANCHOR238
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR238
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
	ldr	w4, [x29, 112]
.L2389:
	mov	w2, 0
	add	x1, x29, 188
	mov	w0, w4
	bl	log2phys
	ldr	x0, [x24, #:lo12:.LANCHOR106]
	ldr	w1, [x29, 188]
	add	x0, x0, x22
	and	w1, w1, 2147483647
	ldr	w2, [x0, 4]
	cmp	w1, w2
	bne	.L2388
	ldr	x1, [x29, 160]
	adrp	x4, .LANCHOR179
	ldr	x2, [x29, 160]
	ldr	x5, [x4, #:lo12:.LANCHOR179]
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
	ldr	x0, [x4, #:lo12:.LANCHOR179]
	ldr	w2, [x25]
	umaddl	x1, w2, w1, x0
	ldr	x0, [x24, #:lo12:.LANCHOR106]
	add	w2, w2, 1
	add	x0, x0, x22
	ldr	x4, [x0, 8]
	str	x4, [x1, 8]
	ldr	x4, [x0, 16]
	str	x4, [x1, 16]
	ldr	w1, [x29, 188]
	str	w1, [x28, 12]
	adrp	x1, .LANCHOR92
	add	x12, x1, :lo12:.LANCHOR92
	ldrh	w1, [x1, #:lo12:.LANCHOR92]
	strh	w1, [x28, 2]
	adrp	x1, .LANCHOR158
	str	w2, [x25]
	ldr	w1, [x1, #:lo12:.LANCHOR158]
	str	w1, [x28, 4]
	mov	w1, 1
	bl	FtlGcBufAlloc
	ldr	x0, [x29, 120]
	ldrb	w0, [x0, #:lo12:.LANCHOR8]
	cbnz	w0, .L2390
	ldrb	w1, [x12, 7]
	ldr	w0, [x25]
	cmp	w1, w0
	beq	.L2390
	ldrh	w0, [x12, 4]
	cbnz	w0, .L2388
.L2390:
	bl	Ftl_gc_temp_data_write_back
	cbz	w0, .L2388
.L2438:
	str	wzr, [x21, #:lo12:.LANCHOR169]
	b	.L2437
.L2388:
	add	x22, x22, 56
	b	.L2387
.L2392:
	add	x1, x19, :lo12:.LANCHOR201
	ldrh	w0, [x1, 2]
	add	w20, w20, w0
	and	w20, w20, 65535
	strh	w20, [x1, 2]
	cmp	w26, w20
	bhi	.L2394
	adrp	x0, .LANCHOR102
	ldr	w0, [x0, #:lo12:.LANCHOR102]
	cbz	w0, .L2395
	bl	Ftl_gc_temp_data_write_back
	cbnz	w0, .L2438
.L2395:
	adrp	x0, .LANCHOR236
	ldrh	w0, [x0, #:lo12:.LANCHOR236]
	cbnz	w0, .L2396
	ldrh	w0, [x19, #:lo12:.LANCHOR201]
	adrp	x1, .LANCHOR82
	ldr	x1, [x1, #:lo12:.LANCHOR82]
	lsl	x0, x0, 1
	ldrh	w2, [x1, x0]
	cbz	w2, .L2396
	strh	wzr, [x1, x0]
	ldrh	w0, [x19, #:lo12:.LANCHOR201]
	bl	update_vpc_list
	bl	FtlCacheWriteBack
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2396:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR201]
.L2394:
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w0, 2
	bhi	.L2397
	ldr	x0, [x29, 128]
	ldrh	w20, [x0, #:lo12:.LANCHOR51]
	b	.L2368
.L2397:
	str	wzr, [x21, #:lo12:.LANCHOR169]
	add	w0, w0, 1
	b	.L2346
.L2398:
	mov	w0, 0
	ret
.L2400:
	mov	w0, 0
	b	.L2346
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
	.section	.text.FtlInit,"ax",@progbits
	.align	2
	.global	FtlInit
	.type	FtlInit, %function
FtlInit:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LC48
	add	x1, x1, :lo12:.LC48
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR223
	mov	x20, x0
	mov	w0, -1
	str	w0, [x19, #:lo12:.LANCHOR223]
	adrp	x0, .LANCHOR239
	str	wzr, [x0, #:lo12:.LANCHOR239]
	adrp	x0, .LANCHOR75
	str	wzr, [x0, #:lo12:.LANCHOR75]
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
	mov	x0, x20
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	adrp	x0, .LANCHOR37
	ldrh	w0, [x0, #:lo12:.LANCHOR37]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	w0, .L2440
	adrp	x1, .LANCHOR240
	adrp	x0, .LC49
	add	x1, x1, :lo12:.LANCHOR240
	add	x0, x0, :lo12:.LC49
.L2448:
	bl	printf
.L2441:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2440:
	bl	FtlSysBlkInit
	cbz	w0, .L2442
	adrp	x1, .LANCHOR240
	adrp	x0, .LC50
	add	x1, x1, :lo12:.LANCHOR240
	add	x0, x0, :lo12:.LC50
	b	.L2448
.L2442:
	mov	w1, 1
	str	w1, [x19, #:lo12:.LANCHOR223]
	bl	rk_ftl_garbage_collect
	adrp	x0, .LANCHOR87
	ldrh	w0, [x0, #:lo12:.LANCHOR87]
	cmp	w0, 15
	bhi	.L2441
	mov	w19, 1024
.L2444:
	mov	w1, 1
	mov	w0, w1
	bl	rk_ftl_garbage_collect
	subs	w19, w19, #1
	bne	.L2444
	b	.L2441
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
	cbnz	w0, .L2450
	adrp	x0, .LANCHOR15
	add	x0, x0, :lo12:.LANCHOR15
	bl	FtlInit
.L2450:
	mov	w1, w19
	adrp	x0, .LC51
	add	x0, x0, :lo12:.LC51
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
	cbz	w0, .L2467
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	str	x25, [sp, 64]
	adrp	x25, .LANCHOR229
	stp	x23, x24, [sp, 48]
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR82
	ldrh	w23, [x25, #:lo12:.LANCHOR229]
	ldr	x0, [x21, #:lo12:.LANCHOR82]
	mov	w1, w23
	stp	x19, x20, [sp, 16]
	ubfiz	x24, x23, 1, 16
	adrp	x19, .LC52
	ldrh	w2, [x0, x24]
	add	x0, x19, :lo12:.LC52
	bl	printf
	adrp	x0, .LANCHOR90
	add	x6, x0, :lo12:.LANCHOR90
	ldrh	w0, [x0, #:lo12:.LANCHOR90]
	bl	FtlGcRefreshBlock
	adrp	x0, .LANCHOR91
	add	x20, x0, :lo12:.LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	bl	FtlGcRefreshBlock
	mov	x0, x6
	bl	allocate_new_data_superblock
	mov	x0, x20
	mov	w20, 4097
	bl	allocate_new_data_superblock
.L2454:
	subs	w20, w20, #1
	beq	.L2458
	mov	w1, 1
	mov	w0, w1
	bl	rk_ftl_garbage_collect
	ldr	x0, [x21, #:lo12:.LANCHOR82]
	ldrh	w0, [x0, x24]
	cbnz	w0, .L2454
.L2458:
	ldr	x0, [x21, #:lo12:.LANCHOR82]
	mov	w1, w23
	ldrh	w2, [x0, x24]
	add	x0, x19, :lo12:.LC52
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR82]
	ldrh	w19, [x0, x24]
	cbnz	w19, .L2456
	add	x20, x29, 128
	adrp	x22, .LANCHOR76
	strh	w23, [x20, -48]!
	mov	x0, x20
	bl	make_superblock
	adrp	x0, .LANCHOR36
	ldr	x4, [x22, #:lo12:.LANCHOR76]
	add	x20, x20, 16
	mov	w5, 65535
	ldrh	w3, [x0, #:lo12:.LANCHOR36]
	mov	w6, 56
	mov	w0, 0
.L2459:
	cmp	w0, w3
	bne	.L2461
	ldr	x0, [x21, #:lo12:.LANCHOR82]
	mov	w1, w23
	ldrh	w2, [x0, x24]
	adrp	x0, .LC53
	add	x0, x0, :lo12:.LC53
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR76]
	mov	w2, w19
	mov	w1, 0
	bl	FlashEraseBlocks
	ldr	x0, [x22, #:lo12:.LANCHOR76]
	mov	w2, w19
	mov	w1, 1
	bl	FlashEraseBlocks
.L2456:
	mov	w0, -1
	strh	w0, [x25, #:lo12:.LANCHOR229]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 128
	ret
.L2461:
	ldrh	w1, [x20]
	cmp	w1, w5
	beq	.L2460
	umaddl	x2, w19, w6, x4
	add	w19, w19, 1
	and	w19, w19, 65535
	lsl	w1, w1, 10
	stp	xzr, xzr, [x2, 8]
	str	w1, [x2, 4]
.L2460:
	add	w0, w0, 1
	add	x20, x20, 2
	and	w0, w0, 65535
	b	.L2459
.L2467:
	ret
	.size	ftl_fix_nand_power_lost_error, .-ftl_fix_nand_power_lost_error
	.section	.text.ftl_read,"ax",@progbits
	.align	2
	.global	ftl_read
	.type	ftl_read, %function
ftl_read:
	stp	x29, x30, [sp, -176]!
	and	w0, w0, 255
	cmp	w0, 16
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	stp	x23, x24, [sp, 48]
	mov	x23, x3
	stp	x25, x26, [sp, 64]
	mov	w26, w2
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	bne	.L2471
	mov	x2, x3
	mov	w1, w26
	add	w0, w19, 256
	bl	FtlVendorPartRead
	mov	w21, w0
.L2470:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L2471:
	add	w0, w1, w2
	str	w0, [x29, 136]
	adrp	x0, .LANCHOR67
	add	w1, w1, w2
	ldr	w0, [x0, #:lo12:.LANCHOR67]
	cmp	w1, w0
	bhi	.L2493
	adrp	x0, .LANCHOR223
	ldr	w21, [x0, #:lo12:.LANCHOR223]
	cmn	w21, #1
	beq	.L2470
	adrp	x22, .LANCHOR54
	bl	FtlCacheWriteBack
	mov	w25, 0
	mov	w21, 0
	ldrh	w0, [x22, #:lo12:.LANCHOR54]
	adrp	x27, .LANCHOR178
	stp	wzr, wzr, [x29, 144]
	udiv	w1, w19, w0
	str	w1, [x29, 152]
	add	w1, w19, w26
	sub	w24, w1, #1
	adrp	x1, .LANCHOR164
	ldr	w20, [x29, 152]
	udiv	w24, w24, w0
	ldr	w0, [x29, 152]
	sub	w0, w24, w0
	add	w0, w0, 1
	str	w0, [x29, 156]
	ldr	w0, [x1, #:lo12:.LANCHOR164]
	ldr	w2, [x29, 156]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR164]
.L2473:
	ldr	w0, [x29, 156]
	cbnz	w0, .L2492
	adrp	x0, .LANCHOR114
	ldrh	w0, [x0, #:lo12:.LANCHOR114]
	cbz	w0, .L2470
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	b	.L2470
.L2492:
	add	x1, x29, 172
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
	ldr	w1, [x29, 172]
	cmn	w1, #1
	bne	.L2474
	add	x3, x22, :lo12:.LANCHOR54
	mov	w28, 0
.L2475:
	ldrh	w0, [x3]
	cmp	w28, w0
	bcc	.L2477
.L2478:
	ldr	w0, [x29, 156]
	add	w20, w20, 1
	subs	w0, w0, #1
	str	w0, [x29, 156]
	beq	.L2482
	adrp	x0, .LANCHOR36
	ldrh	w0, [x0, #:lo12:.LANCHOR36]
	cmp	w25, w0, lsl 2
	bne	.L2473
.L2482:
	cbz	w25, .L2473
	ldr	x0, [x27, #:lo12:.LANCHOR178]
	mov	w1, w25
	mov	w2, 0
	bl	FlashReadPages
	ldr	w0, [x29, 144]
	lsl	w0, w0, 9
	str	w0, [x29, 120]
	ldr	w0, [x29, 140]
	lsl	w0, w0, 9
	str	x0, [x29, 128]
	ldr	w0, [x29, 148]
	lsl	w0, w0, 9
	str	w0, [x29, 124]
	mov	w0, 56
	umull	x0, w25, w0
	mov	x25, 0
	str	x0, [x29, 104]
	adrp	x0, .LANCHOR136
	add	x28, x0, :lo12:.LANCHOR136
.L2491:
	ldr	x0, [x27, #:lo12:.LANCHOR178]
	ldr	w2, [x29, 152]
	add	x0, x0, x25
	ldr	w1, [x0, 24]
	cmp	w2, w1
	bne	.L2484
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR183
	ldr	x0, [x0, #:lo12:.LANCHOR183]
	cmp	x1, x0
	bne	.L2485
	ldr	x0, [x29, 128]
	ldr	w2, [x29, 124]
	add	x1, x1, x0
	mov	x0, x23
.L2508:
	bl	ftl_memcpy
.L2485:
	ldr	x0, [x27, #:lo12:.LANCHOR178]
	add	x1, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L2486
	ldr	w1, [x28, 72]
	mov	w21, w0
	add	w1, w1, 1
	str	w1, [x28, 72]
.L2487:
	ldr	x0, [x29, 104]
	add	x25, x25, 56
	cmp	x0, x25
	bne	.L2491
	mov	w25, 0
	b	.L2473
.L2477:
	madd	w0, w20, w0, w28
	cmp	w19, w0
	bhi	.L2476
	ldr	w1, [x29, 136]
	cmp	w1, w0
	bls	.L2476
	sub	w0, w0, w19
	str	x3, [x29, 128]
	lsl	w0, w0, 9
	mov	w2, 512
	mov	w1, 0
	add	x0, x23, x0
	bl	ftl_memset
	ldr	x3, [x29, 128]
.L2476:
	add	w28, w28, 1
	b	.L2475
.L2474:
	ldr	x0, [x27, #:lo12:.LANCHOR178]
	mov	w2, 56
	umaddl	x0, w25, w2, x0
	str	w1, [x0, 4]
	ldr	w1, [x29, 152]
	cmp	w20, w1
	bne	.L2479
	adrp	x1, .LANCHOR183
	ldr	x1, [x1, #:lo12:.LANCHOR183]
	str	x1, [x0, 8]
	ldrh	w1, [x22, #:lo12:.LANCHOR54]
	udiv	w2, w19, w1
	msub	w2, w2, w1, w19
	str	w2, [x29, 140]
	sub	w2, w1, w2
	cmp	w26, w2
	csel	w2, w26, w2, ls
	str	w2, [x29, 148]
	cmp	w1, w2
	bne	.L2480
	str	x23, [x0, 8]
.L2480:
	adrp	x1, .LANCHOR57
	adrp	x2, .LANCHOR186
	str	w20, [x0, 24]
	ldrh	w1, [x1, #:lo12:.LANCHOR57]
	ldr	x2, [x2, #:lo12:.LANCHOR186]
	mul	w1, w1, w25
	add	w25, w25, 1
	and	x1, x1, 4294967292
	add	x1, x2, x1
	str	x1, [x0, 16]
	b	.L2478
.L2479:
	cmp	w20, w24
	bne	.L2481
	ldrh	w2, [x22, #:lo12:.LANCHOR54]
	adrp	x1, .LANCHOR184
	ldr	w3, [x29, 136]
	ldr	x1, [x1, #:lo12:.LANCHOR184]
	str	x1, [x0, 8]
	mul	w1, w20, w2
	sub	w3, w3, w1
	str	w3, [x29, 144]
	cmp	w2, w3
	bne	.L2480
.L2507:
	sub	w1, w1, w19
	lsl	w1, w1, 9
	add	x1, x23, x1
	str	x1, [x0, 8]
	b	.L2480
.L2481:
	ldrh	w1, [x22, #:lo12:.LANCHOR54]
	mul	w1, w1, w20
	b	.L2507
.L2484:
	cmp	w24, w1
	bne	.L2485
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR184
	ldr	x0, [x0, #:lo12:.LANCHOR184]
	cmp	x1, x0
	bne	.L2485
	ldrh	w0, [x22, #:lo12:.LANCHOR54]
	ldr	w2, [x29, 120]
	mul	w0, w0, w24
	sub	w0, w0, w19
	lsl	w0, w0, 9
	add	x0, x23, x0
	b	.L2508
.L2486:
	cmp	w0, 256
	bne	.L2487
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	and	w1, w0, 65535
	str	w1, [x29, 116]
	bl	FtlGcRefreshBlock
	mov	w2, 2049
.L2489:
	subs	w2, w2, #1
	bne	.L2488
.L2490:
	bl	FtlSysFlush
	b	.L2487
.L2488:
	mov	w1, 1
	str	w2, [x29, 112]
	mov	w0, w1
	bl	rk_ftl_garbage_collect
	adrp	x0, .LANCHOR201
	ldp	w2, w1, [x29, 112]
	ldrh	w0, [x0, #:lo12:.LANCHOR201]
	cmp	w0, w1
	beq	.L2489
	b	.L2490
.L2493:
	mov	w21, -1
	b	.L2470
	.size	ftl_read, .-ftl_read
	.section	.text.ftl_write,"ax",@progbits
	.align	2
	.global	ftl_write
	.type	ftl_write, %function
ftl_write:
	stp	x29, x30, [sp, -240]!
	and	w0, w0, 255
	cmp	w0, 16
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	mov	w25, w2
	stp	x21, x22, [sp, 32]
	mov	x26, x3
	stp	x19, x20, [sp, 16]
	mov	w22, w1
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	bne	.L2510
	mov	x2, x3
	mov	w1, w25
	add	w0, w22, 256
	bl	FtlVendorPartWrite
.L2509:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	ret
.L2510:
	adrp	x0, .LANCHOR67
	add	w2, w1, w2
	ldr	w0, [x0, #:lo12:.LANCHOR67]
	cmp	w2, w0
	bhi	.L2544
	adrp	x0, .LANCHOR223
	ldr	w0, [x0, #:lo12:.LANCHOR223]
	cmn	w0, #1
	beq	.L2509
	adrp	x0, .LANCHOR241
	adrp	x3, .LANCHOR54
	mov	w1, 2048
	sub	w2, w2, #1
	str	w1, [x0, #:lo12:.LANCHOR241]
	ldrh	w1, [x3, #:lo12:.LANCHOR54]
	str	x3, [x29, 160]
	udiv	w0, w2, w1
	adrp	x2, .LANCHOR160
	udiv	w21, w22, w1
	str	w0, [x29, 152]
	sub	w23, w0, w21
	ldr	w0, [x2, #:lo12:.LANCHOR160]
	add	w24, w23, 1
	add	w0, w0, w24
	str	w0, [x2, #:lo12:.LANCHOR160]
	adrp	x0, .LANCHOR129
	str	x0, [x29, 120]
	ldr	x2, [x0, #:lo12:.LANCHOR129]
	cbz	x2, .L2512
	ldr	w0, [x2, 24]
	cmp	w21, w0
	beq	.L2513
	bl	FtlCacheWriteBack
.L2512:
	adrp	x0, .LANCHOR90
	mov	w19, w21
	add	x23, x0, :lo12:.LANCHOR90
.L2514:
	cbz	w24, .L2543
	adrp	x0, .LANCHOR90
	add	x0, x0, :lo12:.LANCHOR90
	adrp	x1, .LANCHOR36
	str	x1, [x29, 112]
	ldrb	w2, [x0, 6]
	ldrh	w0, [x1, #:lo12:.LANCHOR36]
	cmp	w2, w0
	bcc	.L2515
	mov	w2, 1632
	adrp	x1, .LANCHOR242
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR242
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2515:
	ldrh	w0, [x23, 4]
	cbnz	w0, .L2516
	bl	FtlCacheWriteBack
	mov	x0, x23
	bl	allocate_new_data_superblock
.L2516:
	ldrb	w0, [x23, 7]
	ldrh	w1, [x23, 4]
	lsl	w0, w0, 2
	cmp	w0, w1
	csel	w0, w0, w1, ls
	ldrb	w1, [x23, 6]
	cmp	w0, w24
	csel	w0, w0, w24, ls
	str	w0, [x29, 144]
	ldr	x0, [x29, 112]
	ldrh	w0, [x0, #:lo12:.LANCHOR36]
	cmp	w1, w0
	bcc	.L2517
	mov	w2, 1665
	adrp	x1, .LANCHOR242
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR242
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2517:
	adrp	x0, .LANCHOR57
	adrp	x28, .LANCHOR180
	add	x0, x0, :lo12:.LANCHOR57
	str	xzr, [x29, 168]
	str	x0, [x29, 104]
.L2518:
	ldr	w1, [x29, 144]
	ldr	w27, [x29, 168]
	cmp	w27, w1
	bcc	.L2539
	mov	x27, x1
.L2519:
	ldr	x0, [x29, 120]
	ldr	x0, [x0, #:lo12:.LANCHOR129]
	cbz	x0, .L2540
	sub	w24, w24, #1
	subs	w27, w27, #1
	bne	.L2540
.L2543:
	ldr	w0, [x29, 152]
	sub	w1, w0, w21
	mov	w0, 0
	bl	rk_ftl_garbage_collect
.L2546:
	mov	w0, 0
	b	.L2509
.L2513:
	adrp	x3, .LANCHOR162
	ldr	w0, [x3, #:lo12:.LANCHOR162]
	add	w0, w0, 1
	str	w0, [x3, #:lo12:.LANCHOR162]
	msub	w0, w21, w1, w22
	ldr	x3, [x2, 8]
	sub	w1, w1, w0
	cmp	w25, w1
	lsl	w0, w0, 9
	csel	w19, w25, w1, ls
	add	x0, x3, x0
	lsl	w20, w19, 9
	mov	x1, x26
	mov	w2, w20
	bl	ftl_memcpy
	cbz	w23, .L2546
	sub	w25, w25, w19
	add	w22, w22, w19
	add	x26, x26, x20
	add	w21, w21, 1
	bl	FtlCacheWriteBack
	mov	w24, w23
	b	.L2512
.L2539:
	ldrh	w0, [x23, 4]
	cbz	w0, .L2519
	add	x1, x29, 180
	mov	w2, 0
	mov	w0, w19
	bl	log2phys
	mov	x0, x23
	mov	x20, 56
	bl	get_new_active_ppa
	ldr	x1, [x29, 168]
	mul	x20, x1, x20
	adrp	x1, .LANCHOR180
	ldr	x1, [x1, #:lo12:.LANCHOR180]
	add	x1, x1, x20
	str	w0, [x1, 4]
	ldr	x0, [x29, 104]
	str	w19, [x1, 24]
	ldrh	w2, [x0]
	mul	w27, w27, w2
	and	x0, x27, 4294967292
	str	x0, [x29, 136]
	adrp	x0, .LANCHOR186
	ldr	x3, [x29, 136]
	ldr	x0, [x0, #:lo12:.LANCHOR186]
	str	x0, [x29, 128]
	add	x27, x0, x3
	str	x27, [x1, 16]
	mov	x0, x27
	mov	w1, 0
	bl	ftl_memset
	ldr	w0, [x29, 152]
	cmp	w19, w21
	ccmp	w19, w0, 4, ne
	bne	.L2520
	cmp	w19, w21
	bne	.L2521
	ldr	x0, [x29, 160]
	ldrh	w2, [x0, #:lo12:.LANCHOR54]
	udiv	w0, w22, w2
	msub	w0, w0, w2, w22
	str	w0, [x29, 148]
	sub	w2, w2, w0
	cmp	w2, w25
	csel	w0, w2, w25, ls
	str	w0, [x29, 156]
.L2522:
	ldr	x0, [x29, 160]
	ldr	w1, [x29, 156]
	ldrh	w0, [x0, #:lo12:.LANCHOR54]
	cmp	w1, w0
	ldr	x0, [x28, #:lo12:.LANCHOR180]
	bne	.L2523
	add	x20, x0, x20
	cmp	w19, w21
	bne	.L2524
	str	x26, [x20, 8]
.L2525:
	ldr	x0, [x29, 112]
	ldrb	w1, [x23, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR36]
	cmp	w1, w0
	bcc	.L2536
	mov	w2, 1739
	adrp	x1, .LANCHOR242
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR242
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2536:
	ldp	x1, x2, [x29, 128]
	mov	w0, -3947
	strh	w0, [x1, x2]
	adrp	x1, .LANCHOR158
	ldr	w0, [x1, #:lo12:.LANCHOR158]
	stp	w0, w19, [x27, 4]
	add	w19, w19, 1
	add	w0, w0, 1
	cmn	w0, #1
	csel	w0, w0, wzr, ne
	str	w0, [x1, #:lo12:.LANCHOR158]
	ldr	w0, [x29, 180]
	str	w0, [x27, 12]
	ldrh	w0, [x23]
	strh	w0, [x27, 2]
	ldr	x0, [x29, 168]
	add	x0, x0, 1
	str	x0, [x29, 168]
	b	.L2518
.L2521:
	ldr	x0, [x29, 160]
	add	w2, w22, w25
	str	wzr, [x29, 148]
	ldrh	w0, [x0, #:lo12:.LANCHOR54]
	msub	w2, w19, w0, w2
	and	w0, w2, 65535
	str	w0, [x29, 156]
	b	.L2522
.L2524:
	ldr	w0, [x29, 156]
.L2561:
	mul	w0, w0, w19
	sub	w0, w0, w22
	lsl	w0, w0, 9
	add	x0, x26, x0
	str	x0, [x20, 8]
	b	.L2525
.L2523:
	add	x0, x0, x20
	cmp	w19, w21
	bne	.L2526
	adrp	x1, .LANCHOR183
	ldr	x1, [x1, #:lo12:.LANCHOR183]
.L2560:
	str	x1, [x0, 8]
	ldr	w0, [x29, 180]
	cmn	w0, #1
	beq	.L2528
	str	w0, [x29, 188]
	mov	w2, 0
	ldr	x0, [x28, #:lo12:.LANCHOR180]
	str	w19, [x29, 208]
	add	x0, x0, x20
	ldp	x1, x0, [x0, 8]
	stp	x1, x0, [x29, 192]
	mov	w1, 1
	add	x0, x29, 184
	bl	FlashReadPages
	ldr	w0, [x29, 184]
	cmn	w0, #1
	bne	.L2529
	adrp	x0, .LANCHOR136
	add	x0, x0, :lo12:.LANCHOR136
	ldr	w1, [x0, 72]
	add	w1, w1, 1
	str	w1, [x0, 72]
.L2532:
	ldr	w0, [x29, 156]
	cmp	w19, w21
	lsl	w2, w0, 9
	bne	.L2533
	ldr	x1, [x28, #:lo12:.LANCHOR180]
	ldr	w0, [x29, 148]
	add	x1, x1, x20
	lsl	w0, w0, 9
	ldr	x4, [x1, 8]
	mov	x1, x26
	add	x0, x4, x0
	bl	ftl_memcpy
	ldr	w0, [x29, 152]
	cmp	w19, w0
	bne	.L2525
.L2534:
	ldrh	w0, [x23, 4]
	cbz	w0, .L2525
	ldr	x0, [x28, #:lo12:.LANCHOR180]
	add	x20, x0, x20
	ldr	x0, [x29, 120]
	str	x20, [x0, #:lo12:.LANCHOR129]
	adrp	x0, .LANCHOR221
	str	x23, [x0, #:lo12:.LANCHOR221]
	b	.L2525
.L2526:
	adrp	x1, .LANCHOR184
	ldr	x1, [x1, #:lo12:.LANCHOR184]
	b	.L2560
.L2529:
	ldr	w1, [x27, 8]
	cmp	w19, w1
	beq	.L2531
	adrp	x0, .LANCHOR136
	add	x0, x0, :lo12:.LANCHOR136
	ldr	w2, [x0, 72]
	add	w2, w2, 1
	str	w2, [x0, 72]
	adrp	x0, .LC54
	mov	w2, w19
	add	x0, x0, :lo12:.LC54
	bl	printf
.L2531:
	ldr	w0, [x27, 8]
	cmp	w19, w0
	beq	.L2532
	mov	w2, 1718
	adrp	x1, .LANCHOR242
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR242
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
	b	.L2532
.L2528:
	ldr	x0, [x28, #:lo12:.LANCHOR180]
	adrp	x1, .LANCHOR56
	add	x0, x0, x20
	ldrh	w2, [x1, #:lo12:.LANCHOR56]
	mov	w1, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	b	.L2532
.L2533:
	ldr	x0, [x29, 160]
	ldrh	w1, [x0, #:lo12:.LANCHOR54]
	ldr	x0, [x28, #:lo12:.LANCHOR180]
	add	x0, x0, x20
	mul	w1, w1, w19
	ldr	x0, [x0, 8]
	sub	w1, w1, w22
	lsl	w1, w1, 9
	add	x1, x26, x1
	bl	ftl_memcpy
	b	.L2534
.L2520:
	adrp	x0, .LANCHOR180
	ldr	x0, [x0, #:lo12:.LANCHOR180]
	add	x20, x0, x20
	ldr	x0, [x29, 160]
	ldrh	w0, [x0, #:lo12:.LANCHOR54]
	b	.L2561
.L2540:
	adrp	x0, .LANCHOR180
	mov	x3, x23
	mov	w2, 0
	mov	w1, w27
	ldr	x0, [x0, #:lo12:.LANCHOR180]
	bl	FtlProgPages
	cmp	w24, w27
	bcs	.L2541
	mov	w2, 1754
	adrp	x1, .LANCHOR242
	adrp	x0, .LC4
	add	x1, x1, :lo12:.LANCHOR242
	add	x0, x0, :lo12:.LC4
	bl	printf
	adrp	x1, .LC5
	adrp	x0, .LC6
	add	x1, x1, :lo12:.LC5
	add	x0, x0, :lo12:.LC6
	bl	printf
.L2541:
	sub	w24, w24, w27
	b	.L2514
.L2544:
	mov	w0, -1
	b	.L2509
	.size	ftl_write, .-ftl_write
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
	adrp	x21, .LANCHOR145
	ldrh	w0, [x1, 14]
	mov	w24, w2
	ldrh	w1, [x1, 12]
	stp	x19, x20, [sp, 16]
	str	x27, [sp, 80]
	mov	w27, 61664
	mul	w0, w0, w1
	ldr	x1, [x21, #:lo12:.LANCHOR145]
	str	x1, [x29, 112]
	and	w0, w0, 65535
	adrp	x1, .LANCHOR194
	sub	w20, w0, #1
	sub	w19, w0, #15
	ldr	x2, [x1, #:lo12:.LANCHOR194]
	and	w20, w20, 65535
	mul	w26, w0, w25
	mov	x22, x1
	str	x2, [x29, 120]
.L2563:
	cmp	w19, w20
	ble	.L2570
	mov	w0, -1
.L2562:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L2570:
	add	w0, w20, w26
	mov	w2, 1
	lsl	w0, w0, 10
	mov	w1, w2
	str	w0, [x29, 108]
	add	x0, x29, 104
	bl	FlashReadPages
	ldr	w0, [x29, 104]
	cmn	w0, #1
	beq	.L2564
	ldr	x0, [x22, #:lo12:.LANCHOR194]
	ldrh	w0, [x0]
	cmp	w0, w27
	bne	.L2564
	cbz	x23, .L2571
	cbz	w25, .L2566
.L2569:
	ldr	x1, [x21, #:lo12:.LANCHOR145]
	mov	w2, w24
	mov	x0, x23
	bl	ftl_memcpy
	mov	w3, 4
	adrp	x0, .LC55
	mov	w2, w3
	mov	x1, x23
	add	x0, x0, :lo12:.LC55
	bl	rknand_print_hex
.L2571:
	mov	w0, 0
	b	.L2562
.L2566:
	ldr	x5, [x21, #:lo12:.LANCHOR145]
	adrp	x2, .LANCHOR147
	add	x2, x2, :lo12:.LANCHOR147
	mov	w0, 0
	mov	w6, 1
.L2567:
	ldr	w1, [x2]
	cmp	w0, w1
	bcs	.L2569
	ubfx	x1, x0, 5, 11
	and	w3, w0, 31
	lsl	x1, x1, 2
	add	w0, w0, 1
	lsl	w4, w6, w3
	and	w0, w0, 65535
	ldr	w3, [x5, x1]
	orr	w3, w3, w4
	str	w3, [x5, x1]
	b	.L2567
.L2564:
	sub	w20, w20, #1
	and	w20, w20, 65535
	b	.L2563
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
	adrp	x21, .LANCHOR151
	ldrb	w2, [x0, 13]
	ldr	x0, [x21, #:lo12:.LANCHOR151]
	mul	w19, w19, w2
	and	w19, w19, 65535
	add	w2, w19, 7
	lsr	w2, w2, 3
	bl	FlashReadFacBbtData
	cmn	w0, #1
	bne	.L2577
.L2581:
	mov	w0, 0
.L2578:
	ubfiz	x0, x0, 1, 16
	mov	w1, -1
	ldr	x21, [sp, 32]
	strh	w1, [x20, x0]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L2577:
	ldr	x4, [x21, #:lo12:.LANCHOR151]
	lsr	w5, w19, 4
	sub	w19, w19, #1
	mov	w1, 0
	mov	w0, 0
	mov	w6, 1
.L2579:
	cmp	w1, w19
	bge	.L2578
	ubfx	x3, x1, 5, 11
	and	w2, w1, 31
	lsl	w2, w6, w2
	ldr	w3, [x4, x3, lsl 2]
	tst	w2, w3
	beq	.L2580
	add	w2, w0, 1
	ubfiz	x0, x0, 1, 16
	strh	w1, [x20, x0]
	and	w0, w2, 65535
.L2580:
	cmp	w0, w5
	bcs	.L2581
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L2579
	.size	FlashGetBadBlockList, .-FlashGetBadBlockList
	.section	.text.FtlMakeBbt,"ax",@progbits
	.align	2
	.global	FtlMakeBbt
	.type	FtlMakeBbt, %function
FtlMakeBbt:
	stp	x29, x30, [sp, -128]!
	adrp	x0, .LANCHOR75
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	ldr	w21, [x0, #:lo12:.LANCHOR75]
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w21, .L2588
	bl	FtlBbtMemInit
	adrp	x20, .LANCHOR73
	add	x22, x20, :lo12:.LANCHOR73
	bl	FtlLoadFactoryBbt
	add	x24, x22, 32
	adrp	x28, .LANCHOR199
	add	x22, x22, 12
	add	x25, x28, :lo12:.LANCHOR199
	adrp	x0, .LANCHOR43
	add	x0, x0, :lo12:.LANCHOR43
	str	x0, [x29, 120]
.L2589:
	ldr	x0, [x29, 120]
	ldrh	w0, [x0]
	cmp	w21, w0
	bcc	.L2595
	adrp	x21, .LANCHOR58
	add	x21, x21, :lo12:.LANCHOR58
	mov	w19, 0
.L2596:
	ldrh	w0, [x21]
	cmp	w0, w19
	bhi	.L2597
	add	x21, x20, :lo12:.LANCHOR73
	mov	w22, 65535
	ldrh	w19, [x21, 12]
	sub	w19, w19, #1
	and	w19, w19, 65535
.L2598:
	ldrh	w0, [x21, 12]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L2602
	mov	w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L2599
	mov	w0, w19
	bl	FlashTestBlk
	cbz	w0, .L2600
	mov	w0, w19
	bl	FtlBbmMapBadBlock
.L2599:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L2598
.L2595:
	adrp	x2, .LANCHOR185
	adrp	x0, .LANCHOR79
	add	x19, x28, :lo12:.LANCHOR199
	ldrh	w1, [x22]
	ldr	x0, [x0, #:lo12:.LANCHOR79]
	mov	w3, 65535
	ldr	x26, [x2, #:lo12:.LANCHOR185]
	cmp	w1, w3
	stp	x0, x26, [x19, 8]
	adrp	x23, .LANCHOR49
	str	x2, [x29, 112]
	beq	.L2590
	ldrh	w4, [x23, #:lo12:.LANCHOR49]
	mov	w2, 1
	madd	w27, w4, w21, w1
	mov	w1, w2
	lsl	w0, w27, 10
	str	w0, [x19, 4]
	mov	x0, x19
	bl	FlashReadPages
	ldr	x1, [x19, 8]
	ldr	x0, [x24]
	ldrh	w2, [x23, #:lo12:.LANCHOR49]
	add	w2, w2, 7
	lsr	w2, w2, 3
	bl	ftl_memcpy
.L2591:
	mov	w0, w27
	add	w21, w21, 1
	bl	FtlBbmMapBadBlock
	add	x24, x24, 8
	add	x22, x22, 2
	b	.L2589
.L2590:
	mov	w1, w21
	bl	FlashGetBadBlockList
	ldr	x0, [x19, 8]
	adrp	x27, .LANCHOR120
	ldr	x1, [x24]
	bl	FtlBbt2Bitmap
	ldrh	w19, [x23, #:lo12:.LANCHOR49]
	add	x23, x23, :lo12:.LANCHOR49
	add	x0, x27, :lo12:.LANCHOR120
	sub	w19, w19, #1
	str	x0, [x29, 104]
	and	w19, w19, 65535
.L2592:
	ldrh	w0, [x23]
	madd	w0, w21, w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L2593
	ldr	x0, [x29, 112]
	mov	w2, 16
	strh	w19, [x22]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR185]
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
	bne	.L2591
	mov	w0, w27
	bl	FtlBbmMapBadBlock
	b	.L2592
.L2593:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L2592
.L2597:
	mov	w0, w19
	add	w19, w19, 1
	bl	FtlBbmMapBadBlock
	and	w19, w19, 65535
	b	.L2596
.L2600:
	ldrh	w0, [x21]
	cmp	w0, w22
	bne	.L2601
	strh	w19, [x21]
	b	.L2599
.L2601:
	strh	w19, [x21, 4]
.L2602:
	adrp	x0, .LANCHOR76
	add	x19, x20, :lo12:.LANCHOR73
	ldrh	w1, [x20, #:lo12:.LANCHOR73]
	mov	w2, 2
	ldr	x0, [x0, #:lo12:.LANCHOR76]
	str	wzr, [x19, 8]
	lsl	w1, w1, 10
	strh	wzr, [x19, 2]
	str	w1, [x0, 4]
	ldrh	w1, [x19, 4]
	lsl	w1, w1, 10
	str	w1, [x0, 60]
	mov	w1, 1
	bl	FlashEraseBlocks
	ldrh	w0, [x20, #:lo12:.LANCHOR73]
	bl	FtlBbmMapBadBlock
	ldrh	w0, [x19, 4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	strh	wzr, [x19, 2]
	ldr	w0, [x19, 8]
	ldrh	w1, [x19, 4]
	add	w0, w0, 1
	str	w0, [x19, 8]
	ldrh	w0, [x20, #:lo12:.LANCHOR73]
	strh	w0, [x19, 4]
	strh	w1, [x20, #:lo12:.LANCHOR73]
	bl	FtlBbmTblFlush
.L2588:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
	.size	FtlMakeBbt, .-FtlMakeBbt
	.section	.text.FtlLowFormat,"ax",@progbits
	.align	2
	.global	FtlLowFormat
	.type	FtlLowFormat, %function
FtlLowFormat:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR65
	mov	w1, 0
	add	x29, sp, 0
	ldrh	w2, [x0, #:lo12:.LANCHOR65]
	adrp	x0, .LANCHOR192
	stp	x19, x20, [sp, 16]
	ldr	x0, [x0, #:lo12:.LANCHOR192]
	stp	x21, x22, [sp, 32]
	lsl	w2, w2, 2
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	bl	ftl_memset
	adrp	x0, .LANCHOR75
	ldr	w0, [x0, #:lo12:.LANCHOR75]
	cbnz	w0, .L2610
	adrp	x0, .LANCHOR158
	adrp	x25, .LANCHOR37
	adrp	x20, .LANCHOR157
	str	wzr, [x0, #:lo12:.LANCHOR158]
	ldrh	w0, [x25, #:lo12:.LANCHOR37]
	str	wzr, [x20, #:lo12:.LANCHOR157]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	w0, .L2611
	bl	FtlMakeBbt
.L2611:
	adrp	x22, .LANCHOR54
	adrp	x0, .LANCHOR183
	mov	w6, 23752
	ldrh	w1, [x22, #:lo12:.LANCHOR54]
	movk	w6, 0xa0f, lsl 16
	ldr	x4, [x0, #:lo12:.LANCHOR183]
	adrp	x0, .LANCHOR184
	lsl	w1, w1, 7
	ldr	x5, [x0, #:lo12:.LANCHOR184]
	mov	w0, 0
.L2612:
	cmp	w0, w1
	blt	.L2613
	adrp	x21, .LANCHOR38
	adrp	x19, .LANCHOR39
	add	x26, x19, :lo12:.LANCHOR39
	mov	w23, 0
	ldrh	w24, [x21, #:lo12:.LANCHOR38]
.L2614:
	ldrh	w0, [x26]
	cmp	w0, w24
	bhi	.L2615
	adrp	x24, .LANCHOR36
	sub	w1, w23, #2
	ldrh	w0, [x24, #:lo12:.LANCHOR36]
	cmp	w1, w0, lsl 1
	bgt	.L2616
.L2620:
	add	x26, x21, :lo12:.LANCHOR38
	mov	w23, 0
	mov	w25, 0
.L2617:
	ldrh	w0, [x26]
	cmp	w0, w25
	bhi	.L2621
	adrp	x0, .LANCHOR72
	ldrh	w1, [x19, #:lo12:.LANCHOR39]
	ldrh	w3, [x24, #:lo12:.LANCHOR36]
	str	w1, [x0, #:lo12:.LANCHOR72]
	adrp	x0, .LANCHOR40
	adrp	x1, .LANCHOR227
	ldr	w2, [x0, #:lo12:.LANCHOR40]
	adrp	x0, .LANCHOR71
	udiv	w6, w2, w3
	ubfx	x5, x6, 5, 16
	str	w6, [x0, #:lo12:.LANCHOR71]
	add	w4, w5, 36
	strh	w4, [x1, #:lo12:.LANCHOR227]
	mov	w4, 24
	mul	w4, w3, w4
	cmp	w23, w4
	ble	.L2622
	sub	w2, w2, w23
	udiv	w2, w2, w3
	str	w2, [x0, #:lo12:.LANCHOR71]
	lsr	w2, w2, 5
	add	w2, w2, 24
	strh	w2, [x1, #:lo12:.LANCHOR227]
.L2622:
	adrp	x2, .LANCHOR101
	ldr	w2, [x2, #:lo12:.LANCHOR101]
	cmp	w2, 1
	bne	.L2623
	udiv	w4, w23, w3
	ldrh	w2, [x1, #:lo12:.LANCHOR227]
	add	w4, w4, w2
	add	w4, w2, w4, asr 2
	strh	w4, [x1, #:lo12:.LANCHOR227]
.L2623:
	adrp	x2, .LANCHOR8
	ldrb	w2, [x2, #:lo12:.LANCHOR8]
	cbz	w2, .L2624
	udiv	w4, w23, w3
	ldrh	w2, [x1, #:lo12:.LANCHOR227]
	add	w4, w4, w2
	add	w4, w2, w4, asr 2
	strh	w4, [x1, #:lo12:.LANCHOR227]
.L2624:
	adrp	x2, .LANCHOR47
	ldrh	w2, [x2, #:lo12:.LANCHOR47]
	cbz	w2, .L2626
	ldrh	w4, [x1, #:lo12:.LANCHOR227]
	add	w4, w4, w2, lsr 1
	strh	w4, [x1, #:lo12:.LANCHOR227]
	mul	w4, w2, w3
	cmp	w23, w4
	bge	.L2626
	add	w2, w2, 32
	str	w6, [x0, #:lo12:.LANCHOR71]
	add	w2, w5, w2
	strh	w2, [x1, #:lo12:.LANCHOR227]
.L2626:
	ldrh	w2, [x1, #:lo12:.LANCHOR227]
	adrp	x25, .LANCHOR226
	ldr	w1, [x0, #:lo12:.LANCHOR71]
	adrp	x24, .LANCHOR82
	mov	w23, -1
	sub	w1, w1, w2
	mul	w3, w1, w3
	adrp	x1, .LANCHOR51
	str	w3, [x25, #:lo12:.LANCHOR226]
	ldrh	w1, [x1, #:lo12:.LANCHOR51]
	mul	w3, w1, w3
	str	w3, [x0, #:lo12:.LANCHOR71]
	ldrh	w0, [x22, #:lo12:.LANCHOR54]
	mul	w3, w0, w3
	adrp	x0, .LANCHOR67
	str	w3, [x0, #:lo12:.LANCHOR67]
	bl	FtlBbmTblFlush
	ldr	x0, [x24, #:lo12:.LANCHOR82]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR39]
	lsl	w2, w2, 1
	bl	ftl_memset
	adrp	x0, .LANCHOR99
	adrp	x1, .LANCHOR201
	ldrh	w2, [x21, #:lo12:.LANCHOR38]
	str	wzr, [x0, #:lo12:.LANCHOR99]
	add	x0, x1, :lo12:.LANCHOR201
	strh	w23, [x1, #:lo12:.LANCHOR201]
	mov	w1, 255
	lsr	w2, w2, 3
	strh	wzr, [x0, 2]
	strb	wzr, [x0, 6]
	strb	wzr, [x0, 8]
	adrp	x0, .LANCHOR90
	add	x19, x0, :lo12:.LANCHOR90
	strh	wzr, [x0, #:lo12:.LANCHOR90]
	mov	w0, 1
	strb	w0, [x19, 8]
	adrp	x0, .LANCHOR0
	strh	wzr, [x19, 2]
	ldr	x0, [x0, #:lo12:.LANCHOR0]
	strb	wzr, [x19, 6]
	bl	ftl_memset
.L2628:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L2629
	ldr	x1, [x24, #:lo12:.LANCHOR82]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L2628
.L2613:
	ubfiz	x3, x0, 2, 16
	mvn	w2, w0
	orr	w2, w0, w2, lsl 16
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w2, [x4, x3]
	str	w6, [x5, x3]
	b	.L2612
.L2615:
	mov	w0, w24
	mov	w1, 1
	add	w24, w24, 1
	bl	FtlLowFormatEraseBlock
	add	w23, w23, w0
	and	w24, w24, 65535
	and	w23, w23, 65535
	b	.L2614
.L2616:
	udiv	w0, w23, w0
	adrp	x1, .LANCHOR64
	ldr	w23, [x1, #:lo12:.LANCHOR64]
	add	w0, w0, w23
	bl	FtlSysBlkNumInit
	ldrh	w0, [x25, #:lo12:.LANCHOR37]
	add	x25, x19, :lo12:.LANCHOR39
	bl	FtlFreeSysBlkQueueInit
	ldrh	w23, [x21, #:lo12:.LANCHOR38]
.L2618:
	ldrh	w0, [x25]
	cmp	w0, w23
	bls	.L2620
	mov	w0, w23
	add	w23, w23, 1
	mov	w1, 1
	and	w23, w23, 65535
	bl	FtlLowFormatEraseBlock
	b	.L2618
.L2621:
	mov	w0, w25
	mov	w1, 0
	add	w25, w25, 1
	bl	FtlLowFormatEraseBlock
	add	w23, w23, w0
	and	w25, w25, 65535
	and	w23, w23, 65535
	b	.L2617
.L2629:
	ldr	w1, [x20, #:lo12:.LANCHOR157]
	ubfiz	x0, x0, 1, 16
	str	w1, [x19, 12]
	mov	w23, -1
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR157]
	ldr	x1, [x24, #:lo12:.LANCHOR82]
	ldrh	w2, [x19, 4]
	strh	w2, [x1, x0]
	adrp	x2, .LANCHOR91
	add	x0, x2, :lo12:.LANCHOR91
	ldrh	w1, [x19]
	mov	x19, x0
	add	w1, w1, 1
	strh	wzr, [x0, 2]
	strh	w1, [x2, #:lo12:.LANCHOR91]
	mov	w1, 1
	strb	wzr, [x0, 6]
	strb	w1, [x0, 8]
.L2630:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L2631
	ldr	x1, [x24, #:lo12:.LANCHOR82]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L2630
.L2631:
	ldr	w1, [x20, #:lo12:.LANCHOR157]
	ubfiz	x0, x0, 1, 16
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR157]
	ldr	x1, [x24, #:lo12:.LANCHOR82]
	ldrh	w2, [x19, 4]
	mov	w19, -1
	strh	w2, [x1, x0]
	adrp	x0, .LANCHOR92
	strh	w19, [x0, #:lo12:.LANCHOR92]
	bl	FtlFreeSysBlkQueueOut
	adrp	x2, .LANCHOR206
	add	x1, x2, :lo12:.LANCHOR206
	strh	w0, [x2, #:lo12:.LANCHOR206]
	ldr	w0, [x25, #:lo12:.LANCHOR226]
	strh	w0, [x1, 6]
	ldr	w0, [x20, #:lo12:.LANCHOR157]
	str	w0, [x1, 8]
	add	w0, w0, 1
	strh	wzr, [x1, 2]
	strh	w19, [x1, 4]
	str	w0, [x20, #:lo12:.LANCHOR157]
	bl	FtlVpcTblFlush
	bl	FtlSysBlkInit
	cbnz	w0, .L2610
	adrp	x0, .LANCHOR223
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR223]
.L2610:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
	.size	FtlLowFormat, .-FtlLowFormat
	.global	FtlMallocOffset
	.global	FtlMallocBuffer
	.global	gc_ink_free_return_value
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
	.global	NandFlashParaTbl
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
	.set	.LANCHOR59,. + 0
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
	.set	.LANCHOR142,. + 0
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
	.set	.LANCHOR98,. + 0
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
	.set	.LANCHOR120,. + 0
	.type	c_ftl_nand_bbm_buf_size, %object
	.size	c_ftl_nand_bbm_buf_size, 2
c_ftl_nand_bbm_buf_size:
	.zero	2
	.section	.bss.c_ftl_nand_blk_pre_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR39,. + 0
	.type	c_ftl_nand_blk_pre_plane, %object
	.size	c_ftl_nand_blk_pre_plane, 2
c_ftl_nand_blk_pre_plane:
	.zero	2
	.section	.bss.c_ftl_nand_blks_per_die,"aw",@nobits
	.align	1
	.set	.LANCHOR49,. + 0
	.type	c_ftl_nand_blks_per_die, %object
	.size	c_ftl_nand_blks_per_die, 2
c_ftl_nand_blks_per_die:
	.zero	2
	.section	.bss.c_ftl_nand_blks_per_die_shift,"aw",@nobits
	.align	1
	.set	.LANCHOR50,. + 0
	.type	c_ftl_nand_blks_per_die_shift, %object
	.size	c_ftl_nand_blks_per_die_shift, 2
c_ftl_nand_blks_per_die_shift:
	.zero	2
	.section	.bss.c_ftl_nand_byte_pre_oob,"aw",@nobits
	.align	1
	.set	.LANCHOR57,. + 0
	.type	c_ftl_nand_byte_pre_oob, %object
	.size	c_ftl_nand_byte_pre_oob, 2
c_ftl_nand_byte_pre_oob:
	.zero	2
	.section	.bss.c_ftl_nand_byte_pre_page,"aw",@nobits
	.align	1
	.set	.LANCHOR56,. + 0
	.type	c_ftl_nand_byte_pre_page, %object
	.size	c_ftl_nand_byte_pre_page, 2
c_ftl_nand_byte_pre_page:
	.zero	2
	.section	.bss.c_ftl_nand_data_blks_per_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR38,. + 0
	.type	c_ftl_nand_data_blks_per_plane, %object
	.size	c_ftl_nand_data_blks_per_plane, 2
c_ftl_nand_data_blks_per_plane:
	.zero	2
	.section	.bss.c_ftl_nand_data_op_blks_per_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR227,. + 0
	.type	c_ftl_nand_data_op_blks_per_plane, %object
	.size	c_ftl_nand_data_op_blks_per_plane, 2
c_ftl_nand_data_op_blks_per_plane:
	.zero	2
	.section	.bss.c_ftl_nand_die_num,"aw",@nobits
	.align	1
	.set	.LANCHOR43,. + 0
	.type	c_ftl_nand_die_num, %object
	.size	c_ftl_nand_die_num, 2
c_ftl_nand_die_num:
	.zero	2
	.section	.bss.c_ftl_nand_ext_blk_pre_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR47,. + 0
	.type	c_ftl_nand_ext_blk_pre_plane, %object
	.size	c_ftl_nand_ext_blk_pre_plane, 2
c_ftl_nand_ext_blk_pre_plane:
	.zero	2
	.section	.bss.c_ftl_nand_init_sys_blks_per_plane,"aw",@nobits
	.align	2
	.set	.LANCHOR64,. + 0
	.type	c_ftl_nand_init_sys_blks_per_plane, %object
	.size	c_ftl_nand_init_sys_blks_per_plane, 4
c_ftl_nand_init_sys_blks_per_plane:
	.zero	4
	.section	.bss.c_ftl_nand_l2pmap_ram_region_num,"aw",@nobits
	.align	1
	.set	.LANCHOR66,. + 0
	.type	c_ftl_nand_l2pmap_ram_region_num, %object
	.size	c_ftl_nand_l2pmap_ram_region_num, 2
c_ftl_nand_l2pmap_ram_region_num:
	.zero	2
	.section	.bss.c_ftl_nand_map_blks_per_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR62,. + 0
	.type	c_ftl_nand_map_blks_per_plane, %object
	.size	c_ftl_nand_map_blks_per_plane, 2
c_ftl_nand_map_blks_per_plane:
	.zero	2
	.section	.bss.c_ftl_nand_map_region_num,"aw",@nobits
	.align	1
	.set	.LANCHOR65,. + 0
	.type	c_ftl_nand_map_region_num, %object
	.size	c_ftl_nand_map_region_num, 2
c_ftl_nand_map_region_num:
	.zero	2
	.section	.bss.c_ftl_nand_max_data_blks,"aw",@nobits
	.align	2
	.set	.LANCHOR40,. + 0
	.type	c_ftl_nand_max_data_blks, %object
	.size	c_ftl_nand_max_data_blks, 4
c_ftl_nand_max_data_blks:
	.zero	4
	.section	.bss.c_ftl_nand_max_map_blks,"aw",@nobits
	.align	2
	.set	.LANCHOR63,. + 0
	.type	c_ftl_nand_max_map_blks, %object
	.size	c_ftl_nand_max_map_blks, 4
c_ftl_nand_max_map_blks:
	.zero	4
	.section	.bss.c_ftl_nand_max_sys_blks,"aw",@nobits
	.align	2
	.set	.LANCHOR37,. + 0
	.type	c_ftl_nand_max_sys_blks, %object
	.size	c_ftl_nand_max_sys_blks, 4
c_ftl_nand_max_sys_blks:
	.zero	4
	.section	.bss.c_ftl_nand_max_vendor_blks,"aw",@nobits
	.align	1
	.set	.LANCHOR60,. + 0
	.type	c_ftl_nand_max_vendor_blks, %object
	.size	c_ftl_nand_max_vendor_blks, 2
c_ftl_nand_max_vendor_blks:
	.zero	2
	.section	.bss.c_ftl_nand_page_pre_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR51,. + 0
	.type	c_ftl_nand_page_pre_blk, %object
	.size	c_ftl_nand_page_pre_blk, 2
c_ftl_nand_page_pre_blk:
	.zero	2
	.section	.bss.c_ftl_nand_page_pre_slc_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR52,. + 0
	.type	c_ftl_nand_page_pre_slc_blk, %object
	.size	c_ftl_nand_page_pre_slc_blk, 2
c_ftl_nand_page_pre_slc_blk:
	.zero	2
	.section	.bss.c_ftl_nand_page_pre_super_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR53,. + 0
	.type	c_ftl_nand_page_pre_super_blk, %object
	.size	c_ftl_nand_page_pre_super_blk, 2
c_ftl_nand_page_pre_super_blk:
	.zero	2
	.section	.bss.c_ftl_nand_planes_num,"aw",@nobits
	.align	1
	.set	.LANCHOR36,. + 0
	.type	c_ftl_nand_planes_num, %object
	.size	c_ftl_nand_planes_num, 2
c_ftl_nand_planes_num:
	.zero	2
	.section	.bss.c_ftl_nand_planes_per_die,"aw",@nobits
	.align	1
	.set	.LANCHOR44,. + 0
	.type	c_ftl_nand_planes_per_die, %object
	.size	c_ftl_nand_planes_per_die, 2
c_ftl_nand_planes_per_die:
	.zero	2
	.section	.bss.c_ftl_nand_reserved_blks,"aw",@nobits
	.align	1
	.set	.LANCHOR58,. + 0
	.type	c_ftl_nand_reserved_blks, %object
	.size	c_ftl_nand_reserved_blks, 2
c_ftl_nand_reserved_blks:
	.zero	2
	.section	.bss.c_ftl_nand_sec_pre_page,"aw",@nobits
	.align	1
	.set	.LANCHOR54,. + 0
	.type	c_ftl_nand_sec_pre_page, %object
	.size	c_ftl_nand_sec_pre_page, 2
c_ftl_nand_sec_pre_page:
	.zero	2
	.section	.bss.c_ftl_nand_sec_pre_page_shift,"aw",@nobits
	.align	1
	.set	.LANCHOR55,. + 0
	.type	c_ftl_nand_sec_pre_page_shift, %object
	.size	c_ftl_nand_sec_pre_page_shift, 2
c_ftl_nand_sec_pre_page_shift:
	.zero	2
	.section	.bss.c_ftl_nand_sys_blks_per_plane,"aw",@nobits
	.align	2
	.set	.LANCHOR35,. + 0
	.type	c_ftl_nand_sys_blks_per_plane, %object
	.size	c_ftl_nand_sys_blks_per_plane, 4
c_ftl_nand_sys_blks_per_plane:
	.zero	4
	.section	.bss.c_ftl_nand_totle_phy_blks,"aw",@nobits
	.align	2
	.set	.LANCHOR41,. + 0
	.type	c_ftl_nand_totle_phy_blks, %object
	.size	c_ftl_nand_totle_phy_blks, 4
c_ftl_nand_totle_phy_blks:
	.zero	4
	.section	.bss.c_ftl_nand_type,"aw",@nobits
	.align	1
	.set	.LANCHOR42,. + 0
	.type	c_ftl_nand_type, %object
	.size	c_ftl_nand_type, 2
c_ftl_nand_type:
	.zero	2
	.section	.bss.c_ftl_nand_vendor_region_num,"aw",@nobits
	.align	1
	.set	.LANCHOR61,. + 0
	.type	c_ftl_nand_vendor_region_num, %object
	.size	c_ftl_nand_vendor_region_num, 2
c_ftl_nand_vendor_region_num:
	.zero	2
	.section	.bss.c_ftl_vendor_part_size,"aw",@nobits
	.align	1
	.set	.LANCHOR48,. + 0
	.type	c_ftl_vendor_part_size, %object
	.size	c_ftl_vendor_part_size, 2
c_ftl_vendor_part_size:
	.zero	2
	.section	.bss.c_gc_page_buf_num,"aw",@nobits
	.align	2
	.set	.LANCHOR107,. + 0
	.type	c_gc_page_buf_num, %object
	.size	c_gc_page_buf_num, 4
c_gc_page_buf_num:
	.zero	4
	.section	.bss.c_mlc_erase_count_value,"aw",@nobits
	.align	1
	.set	.LANCHOR46,. + 0
	.type	c_mlc_erase_count_value, %object
	.size	c_mlc_erase_count_value, 2
c_mlc_erase_count_value:
	.zero	2
	.section	.bss.ftl_gc_temp_power_lost_recovery_flag,"aw",@nobits
	.align	2
	.set	.LANCHOR132,. + 0
	.type	ftl_gc_temp_power_lost_recovery_flag, %object
	.size	ftl_gc_temp_power_lost_recovery_flag, 4
ftl_gc_temp_power_lost_recovery_flag:
	.zero	4
	.section	.bss.gBbtInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR73,. + 0
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
	.set	.LANCHOR153,. + 0
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
	.set	.LANCHOR145,. + 0
	.type	gFlashPageBuffer0, %object
	.size	gFlashPageBuffer0, 8
gFlashPageBuffer0:
	.zero	8
	.section	.bss.gFlashPageBuffer1,"aw",@nobits
	.align	3
	.set	.LANCHOR151,. + 0
	.type	gFlashPageBuffer1, %object
	.size	gFlashPageBuffer1, 8
gFlashPageBuffer1:
	.zero	8
	.section	.bss.gFlashProgCheckBuffer,"aw",@nobits
	.align	3
	.set	.LANCHOR195,. + 0
	.type	gFlashProgCheckBuffer, %object
	.size	gFlashProgCheckBuffer, 8
gFlashProgCheckBuffer:
	.zero	8
	.section	.bss.gFlashProgCheckSpareBuffer,"aw",@nobits
	.align	3
	.set	.LANCHOR196,. + 0
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
	.set	.LANCHOR194,. + 0
	.type	gFlashSpareBuffer, %object
	.size	gFlashSpareBuffer, 8
gFlashSpareBuffer:
	.zero	8
	.section	.bss.gFlashToggleModeEn,"aw",@nobits
	.set	.LANCHOR28,. + 0
	.type	gFlashToggleModeEn, %object
	.size	gFlashToggleModeEn, 1
gFlashToggleModeEn:
	.zero	1
	.section	.bss.gL2pMapInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR124,. + 0
	.type	gL2pMapInfo, %object
	.size	gL2pMapInfo, 64
gL2pMapInfo:
	.zero	64
	.section	.bss.gMasterInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR33,. + 0
	.type	gMasterInfo, %object
	.size	gMasterInfo, 48
gMasterInfo:
	.zero	48
	.section	.bss.gMasterTempBuf,"aw",@nobits
	.align	3
	.set	.LANCHOR154,. + 0
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
	.set	.LANCHOR198,. + 0
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
	.set	.LANCHOR31,. + 0
	.type	gNandFlashEccBits, %object
	.size	gNandFlashEccBits, 1
gNandFlashEccBits:
	.zero	1
	.section	.bss.gNandFlashIDBEccBits,"aw",@nobits
	.set	.LANCHOR150,. + 0
	.type	gNandFlashIDBEccBits, %object
	.size	gNandFlashIDBEccBits, 1
gNandFlashIDBEccBits:
	.zero	1
	.section	.bss.gNandFlashIdbBlockAddr,"aw",@nobits
	.align	2
	.set	.LANCHOR147,. + 0
	.type	gNandFlashIdbBlockAddr, %object
	.size	gNandFlashIdbBlockAddr, 4
gNandFlashIdbBlockAddr:
	.zero	4
	.section	.bss.gNandFlashInfoBlockAddr,"aw",@nobits
	.align	2
	.set	.LANCHOR146,. + 0
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
	.set	.LANCHOR148,. + 0
	.type	gNandIDBResBlkNumSaveInFlash, %object
	.size	gNandIDBResBlkNumSaveInFlash, 1
gNandIDBResBlkNumSaveInFlash:
	.zero	1
	.section	.bss.gNandIDataBuf,"aw",@nobits
	.align	3
	.set	.LANCHOR139,. + 0
	.type	gNandIDataBuf, %object
	.size	gNandIDataBuf, 2048
gNandIDataBuf:
	.zero	2048
	.section	.bss.gNandMaxChip,"aw",@nobits
	.set	.LANCHOR118,. + 0
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
	.set	.LANCHOR34,. + 0
	.type	gNandcDumpWriteEn, %object
	.size	gNandcDumpWriteEn, 4
gNandcDumpWriteEn:
	.zero	4
	.section	.bss.gNandcEccBits,"aw",@nobits
	.align	2
	.set	.LANCHOR30,. + 0
	.type	gNandcEccBits, %object
	.size	gNandcEccBits, 4
gNandcEccBits:
	.zero	4
	.section	.bss.gNandcVer,"aw",@nobits
	.align	2
	.set	.LANCHOR32,. + 0
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
	.set	.LANCHOR74,. + 0
	.type	gSysFreeQueue, %object
	.size	gSysFreeQueue, 2056
gSysFreeQueue:
	.zero	2056
	.section	.bss.gSysInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR206,. + 0
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
	.set	.LANCHOR119,. + 0
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
	.set	.LANCHOR158,. + 0
	.type	g_GlobalDataVersion, %object
	.size	g_GlobalDataVersion, 4
g_GlobalDataVersion:
	.zero	4
	.section	.bss.g_GlobalSysVersion,"aw",@nobits
	.align	2
	.set	.LANCHOR157,. + 0
	.type	g_GlobalSysVersion, %object
	.size	g_GlobalSysVersion, 4
g_GlobalSysVersion:
	.zero	4
	.section	.bss.g_LowFormat,"aw",@nobits
	.align	2
	.set	.LANCHOR239,. + 0
	.type	g_LowFormat, %object
	.size	g_LowFormat, 4
g_LowFormat:
	.zero	4
	.section	.bss.g_MaxLbaSector,"aw",@nobits
	.align	2
	.set	.LANCHOR67,. + 0
	.type	g_MaxLbaSector, %object
	.size	g_MaxLbaSector, 4
g_MaxLbaSector:
	.zero	4
	.section	.bss.g_MaxLbn,"aw",@nobits
	.align	2
	.set	.LANCHOR226,. + 0
	.type	g_MaxLbn, %object
	.size	g_MaxLbn, 4
g_MaxLbn:
	.zero	4
	.section	.bss.g_MaxLpn,"aw",@nobits
	.align	2
	.set	.LANCHOR71,. + 0
	.type	g_MaxLpn, %object
	.size	g_MaxLpn, 4
g_MaxLpn:
	.zero	4
	.section	.bss.g_SlcPartLbaEndSector,"aw",@nobits
	.align	2
	.set	.LANCHOR155,. + 0
	.type	g_SlcPartLbaEndSector, %object
	.size	g_SlcPartLbaEndSector, 4
g_SlcPartLbaEndSector:
	.zero	4
	.section	.bss.g_VaildLpn,"aw",@nobits
	.align	2
	.set	.LANCHOR99,. + 0
	.type	g_VaildLpn, %object
	.size	g_VaildLpn, 4
g_VaildLpn:
	.zero	4
	.section	.bss.g_active_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR90,. + 0
	.type	g_active_superblock, %object
	.size	g_active_superblock, 48
g_active_superblock:
	.zero	48
	.section	.bss.g_all_blk_used_slc_mode,"aw",@nobits
	.align	2
	.set	.LANCHOR156,. + 0
	.type	g_all_blk_used_slc_mode, %object
	.size	g_all_blk_used_slc_mode, 4
g_all_blk_used_slc_mode:
	.zero	4
	.section	.bss.g_buffer_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR91,. + 0
	.type	g_buffer_superblock, %object
	.size	g_buffer_superblock, 48
g_buffer_superblock:
	.zero	48
	.section	.bss.g_cur_erase_blk,"aw",@nobits
	.align	2
	.set	.LANCHOR72,. + 0
	.type	g_cur_erase_blk, %object
	.size	g_cur_erase_blk, 4
g_cur_erase_blk:
	.zero	4
	.section	.bss.g_ect_tbl_info_size,"aw",@nobits
	.align	1
	.set	.LANCHOR187,. + 0
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
	.set	.LANCHOR75,. + 0
	.type	g_flash_read_only_en, %object
	.size	g_flash_read_only_en, 4
g_flash_read_only_en:
	.zero	4
	.section	.bss.g_free_slc_blk_num,"aw",@nobits
	.align	1
	.set	.LANCHOR137,. + 0
	.type	g_free_slc_blk_num, %object
	.size	g_free_slc_blk_num, 2
g_free_slc_blk_num:
	.zero	2
	.section	.bss.g_ftl_nand_free_count,"aw",@nobits
	.align	2
	.set	.LANCHOR241,. + 0
	.type	g_ftl_nand_free_count, %object
	.size	g_ftl_nand_free_count, 4
g_ftl_nand_free_count:
	.zero	4
	.section	.bss.g_gc_bad_block_gc_index,"aw",@nobits
	.align	1
	.set	.LANCHOR116,. + 0
	.type	g_gc_bad_block_gc_index, %object
	.size	g_gc_bad_block_gc_index, 2
g_gc_bad_block_gc_index:
	.zero	2
	.section	.bss.g_gc_bad_block_temp_num,"aw",@nobits
	.align	1
	.set	.LANCHOR114,. + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.zero	2
	.section	.bss.g_gc_bad_block_temp_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR115,. + 0
	.type	g_gc_bad_block_temp_tbl, %object
	.size	g_gc_bad_block_temp_tbl, 34
g_gc_bad_block_temp_tbl:
	.zero	34
	.section	.bss.g_gc_blk_index,"aw",@nobits
	.align	1
	.set	.LANCHOR176,. + 0
	.type	g_gc_blk_index, %object
	.size	g_gc_blk_index, 2
g_gc_blk_index:
	.zero	2
	.section	.bss.g_gc_blk_num,"aw",@nobits
	.align	1
	.set	.LANCHOR108,. + 0
	.type	g_gc_blk_num, %object
	.size	g_gc_blk_num, 2
g_gc_blk_num:
	.zero	2
	.section	.bss.g_gc_cur_blk_max_valid_pages,"aw",@nobits
	.align	1
	.set	.LANCHOR237,. + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.zero	2
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",@nobits
	.align	1
	.set	.LANCHOR236,. + 0
	.type	g_gc_cur_blk_valid_pages, %object
	.size	g_gc_cur_blk_valid_pages, 2
g_gc_cur_blk_valid_pages:
	.zero	2
	.section	.bss.g_gc_free_blk_threshold,"aw",@nobits
	.align	1
	.set	.LANCHOR174,. + 0
	.type	g_gc_free_blk_threshold, %object
	.size	g_gc_free_blk_threshold, 2
g_gc_free_blk_threshold:
	.zero	2
	.section	.bss.g_gc_head_data_block,"aw",@nobits
	.align	2
	.set	.LANCHOR171,. + 0
	.type	g_gc_head_data_block, %object
	.size	g_gc_head_data_block, 4
g_gc_head_data_block:
	.zero	4
	.section	.bss.g_gc_head_data_block_count,"aw",@nobits
	.align	2
	.set	.LANCHOR172,. + 0
	.type	g_gc_head_data_block_count, %object
	.size	g_gc_head_data_block_count, 4
g_gc_head_data_block_count:
	.zero	4
	.section	.bss.g_gc_merge_free_blk_threshold,"aw",@nobits
	.align	1
	.set	.LANCHOR175,. + 0
	.type	g_gc_merge_free_blk_threshold, %object
	.size	g_gc_merge_free_blk_threshold, 2
g_gc_merge_free_blk_threshold:
	.zero	2
	.section	.bss.g_gc_next_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR112,. + 0
	.type	g_gc_next_blk, %object
	.size	g_gc_next_blk, 2
g_gc_next_blk:
	.zero	2
	.section	.bss.g_gc_next_blk_1,"aw",@nobits
	.align	1
	.set	.LANCHOR113,. + 0
	.type	g_gc_next_blk_1, %object
	.size	g_gc_next_blk_1, 2
g_gc_next_blk_1:
	.zero	2
	.section	.bss.g_gc_num_req,"aw",@nobits
	.align	2
	.set	.LANCHOR102,. + 0
	.type	g_gc_num_req, %object
	.size	g_gc_num_req, 4
g_gc_num_req:
	.zero	4
	.section	.bss.g_gc_page_offset,"aw",@nobits
	.align	1
	.set	.LANCHOR110,. + 0
	.type	g_gc_page_offset, %object
	.size	g_gc_page_offset, 2
g_gc_page_offset:
	.zero	2
	.section	.bss.g_gc_refresh_block_temp_num,"aw",@nobits
	.align	1
	.set	.LANCHOR177,. + 0
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
	.set	.LANCHOR173,. + 0
	.type	g_gc_skip_write_count, %object
	.size	g_gc_skip_write_count, 4
g_gc_skip_write_count:
	.zero	4
	.section	.bss.g_gc_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR201,. + 0
	.type	g_gc_superblock, %object
	.size	g_gc_superblock, 48
g_gc_superblock:
	.zero	48
	.section	.bss.g_gc_temp_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR92,. + 0
	.type	g_gc_temp_superblock, %object
	.size	g_gc_temp_superblock, 48
g_gc_temp_superblock:
	.zero	48
	.section	.bss.g_in_gc_progress,"aw",@nobits
	.align	2
	.set	.LANCHOR169,. + 0
	.type	g_in_gc_progress, %object
	.size	g_in_gc_progress, 4
g_in_gc_progress:
	.zero	4
	.section	.bss.g_in_swl_replace,"aw",@nobits
	.align	2
	.set	.LANCHOR170,. + 0
	.type	g_in_swl_replace, %object
	.size	g_in_swl_replace, 4
g_in_swl_replace:
	.zero	4
	.section	.bss.g_inkDie_check_enable,"aw",@nobits
	.align	2
	.set	.LANCHOR101,. + 0
	.type	g_inkDie_check_enable, %object
	.size	g_inkDie_check_enable, 4
g_inkDie_check_enable:
	.zero	4
	.section	.bss.g_l2p_last_update_region_id,"aw",@nobits
	.align	1
	.set	.LANCHOR96,. + 0
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
	.set	.LANCHOR149,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.zero	1
	.section	.bss.g_max_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR167,. + 0
	.type	g_max_erase_count, %object
	.size	g_max_erase_count, 4
g_max_erase_count:
	.zero	4
	.section	.bss.g_min_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR168,. + 0
	.type	g_min_erase_count, %object
	.size	g_min_erase_count, 4
g_min_erase_count:
	.zero	4
	.section	.bss.g_nandc_version_data,"aw",@nobits
	.align	2
	.set	.LANCHOR152,. + 0
	.type	g_nandc_version_data, %object
	.size	g_nandc_version_data, 4
g_nandc_version_data:
	.zero	4
	.section	.bss.g_num_data_superblocks,"aw",@nobits
	.align	1
	.set	.LANCHOR84,. + 0
	.type	g_num_data_superblocks, %object
	.size	g_num_data_superblocks, 2
g_num_data_superblocks:
	.zero	2
	.section	.bss.g_num_free_superblocks,"aw",@nobits
	.align	1
	.set	.LANCHOR87,. + 0
	.type	g_num_free_superblocks, %object
	.size	g_num_free_superblocks, 2
g_num_free_superblocks:
	.zero	2
	.section	.bss.g_page_map_check_enable,"aw",@nobits
	.align	1
	.set	.LANCHOR68,. + 0
	.type	g_page_map_check_enable, %object
	.size	g_page_map_check_enable, 2
g_page_map_check_enable:
	.zero	2
	.section	.bss.g_power_lost_ecc_error_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR229,. + 0
	.type	g_power_lost_ecc_error_blk, %object
	.size	g_power_lost_ecc_error_blk, 2
g_power_lost_ecc_error_blk:
	.zero	2
	.section	.bss.g_power_lost_recovery_flag,"aw",@nobits
	.align	1
	.set	.LANCHOR230,. + 0
	.type	g_power_lost_recovery_flag, %object
	.size	g_power_lost_recovery_flag, 2
g_power_lost_recovery_flag:
	.zero	2
	.section	.bss.g_recovery_page_min_ver,"aw",@nobits
	.align	2
	.set	.LANCHOR133,. + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.zero	4
	.section	.bss.g_recovery_page_num,"aw",@nobits
	.align	2
	.set	.LANCHOR231,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.zero	4
	.section	.bss.g_recovery_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR232,. + 0
	.type	g_recovery_ppa_tbl, %object
	.size	g_recovery_ppa_tbl, 128
g_recovery_ppa_tbl:
	.zero	128
	.section	.bss.g_req_cache,"aw",@nobits
	.align	3
	.set	.LANCHOR129,. + 0
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
	.set	.LANCHOR136,. + 0
	.type	g_sys_ext_data, %object
	.size	g_sys_ext_data, 512
g_sys_ext_data:
	.zero	512
	.section	.bss.g_sys_save_data,"aw",@nobits
	.align	3
	.set	.LANCHOR135,. + 0
	.type	g_sys_save_data, %object
	.size	g_sys_save_data, 48
g_sys_save_data:
	.zero	48
	.section	.bss.g_tmp_data_superblock_id,"aw",@nobits
	.align	1
	.set	.LANCHOR130,. + 0
	.type	g_tmp_data_superblock_id, %object
	.size	g_tmp_data_superblock_id, 2
g_tmp_data_superblock_id:
	.zero	2
	.section	.bss.g_totle_avg_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR202,. + 0
	.type	g_totle_avg_erase_count, %object
	.size	g_totle_avg_erase_count, 4
g_totle_avg_erase_count:
	.zero	4
	.section	.bss.g_totle_cache_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR162,. + 0
	.type	g_totle_cache_write_count, %object
	.size	g_totle_cache_write_count, 4
g_totle_cache_write_count:
	.zero	4
	.section	.bss.g_totle_discard_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR161,. + 0
	.type	g_totle_discard_page_count, %object
	.size	g_totle_discard_page_count, 4
g_totle_discard_page_count:
	.zero	4
	.section	.bss.g_totle_gc_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR159,. + 0
	.type	g_totle_gc_page_count, %object
	.size	g_totle_gc_page_count, 4
g_totle_gc_page_count:
	.zero	4
	.section	.bss.g_totle_l2p_write_count,"aw",@nobits
	.align	2
	.set	.LANCHOR163,. + 0
	.type	g_totle_l2p_write_count, %object
	.size	g_totle_l2p_write_count, 4
g_totle_l2p_write_count:
	.zero	4
	.section	.bss.g_totle_map_block,"aw",@nobits
	.align	1
	.set	.LANCHOR125,. + 0
	.type	g_totle_map_block, %object
	.size	g_totle_map_block, 2
g_totle_map_block:
	.zero	2
	.section	.bss.g_totle_mlc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR165,. + 0
	.type	g_totle_mlc_erase_count, %object
	.size	g_totle_mlc_erase_count, 4
g_totle_mlc_erase_count:
	.zero	4
	.section	.bss.g_totle_read_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR164,. + 0
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
	.set	.LANCHOR166,. + 0
	.type	g_totle_slc_erase_count, %object
	.size	g_totle_slc_erase_count, 4
g_totle_slc_erase_count:
	.zero	4
	.section	.bss.g_totle_swl_count,"aw",@nobits
	.align	2
	.set	.LANCHOR131,. + 0
	.type	g_totle_swl_count, %object
	.size	g_totle_swl_count, 4
g_totle_swl_count:
	.zero	4
	.section	.bss.g_totle_sys_slc_erase_count,"aw",@nobits
	.align	2
	.set	.LANCHOR78,. + 0
	.type	g_totle_sys_slc_erase_count, %object
	.size	g_totle_sys_slc_erase_count, 4
g_totle_sys_slc_erase_count:
	.zero	4
	.section	.bss.g_totle_vendor_block,"aw",@nobits
	.align	1
	.set	.LANCHOR69,. + 0
	.type	g_totle_vendor_block, %object
	.size	g_totle_vendor_block, 2
g_totle_vendor_block:
	.zero	2
	.section	.bss.g_totle_write_page_count,"aw",@nobits
	.align	2
	.set	.LANCHOR160,. + 0
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
	.set	.LANCHOR222,. + 0
	.type	gc_discard_updated, %object
	.size	gc_discard_updated, 4
gc_discard_updated:
	.zero	4
	.section	.bss.gc_ink_free_return_value,"aw",@nobits
	.align	1
	.set	.LANCHOR235,. + 0
	.type	gc_ink_free_return_value, %object
	.size	gc_ink_free_return_value, 2
gc_ink_free_return_value:
	.zero	2
	.section	.bss.gpFlashSaveInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR144,. + 0
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
	.set	.LANCHOR143,. + 0
	.type	gpReadRetrial, %object
	.size	gpReadRetrial, 8
gpReadRetrial:
	.zero	8
	.section	.bss.gp_ect_tbl_info,"aw",@nobits
	.align	3
	.set	.LANCHOR188,. + 0
	.type	gp_ect_tbl_info, %object
	.size	gp_ect_tbl_info, 8
gp_ect_tbl_info:
	.zero	8
	.section	.bss.gp_gc_page_buf_info,"aw",@nobits
	.align	3
	.set	.LANCHOR103,. + 0
	.type	gp_gc_page_buf_info, %object
	.size	gp_gc_page_buf_info, 8
gp_gc_page_buf_info:
	.zero	8
	.section	.bss.gp_last_act_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR221,. + 0
	.type	gp_last_act_superblock, %object
	.size	gp_last_act_superblock, 8
gp_last_act_superblock:
	.zero	8
	.section	.bss.mlcPageToSlcPageTbl,"aw",@nobits
	.align	2
	.set	.LANCHOR117,. + 0
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
	.set	.LANCHOR81,. + 0
	.type	p_data_block_list_head, %object
	.size	p_data_block_list_head, 8
p_data_block_list_head:
	.zero	8
	.section	.bss.p_data_block_list_table,"aw",@nobits
	.align	3
	.set	.LANCHOR80,. + 0
	.type	p_data_block_list_table, %object
	.size	p_data_block_list_table, 8
p_data_block_list_table:
	.zero	8
	.section	.bss.p_data_block_list_tail,"aw",@nobits
	.align	3
	.set	.LANCHOR83,. + 0
	.type	p_data_block_list_tail, %object
	.size	p_data_block_list_tail, 8
p_data_block_list_tail:
	.zero	8
	.section	.bss.p_erase_count_table,"aw",@nobits
	.align	3
	.set	.LANCHOR77,. + 0
	.type	p_erase_count_table, %object
	.size	p_erase_count_table, 8
p_erase_count_table:
	.zero	8
	.section	.bss.p_free_data_block_list_head,"aw",@nobits
	.align	3
	.set	.LANCHOR86,. + 0
	.type	p_free_data_block_list_head, %object
	.size	p_free_data_block_list_head, 8
p_free_data_block_list_head:
	.zero	8
	.section	.bss.p_gc_blk_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR109,. + 0
	.type	p_gc_blk_tbl, %object
	.size	p_gc_blk_tbl, 8
p_gc_blk_tbl:
	.zero	8
	.section	.bss.p_gc_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR104,. + 0
	.type	p_gc_data_buf, %object
	.size	p_gc_data_buf, 8
p_gc_data_buf:
	.zero	8
	.section	.bss.p_gc_page_info,"aw",@nobits
	.align	3
	.set	.LANCHOR111,. + 0
	.type	p_gc_page_info, %object
	.size	p_gc_page_info, 8
p_gc_page_info:
	.zero	8
	.section	.bss.p_gc_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR105,. + 0
	.type	p_gc_spare_buf, %object
	.size	p_gc_spare_buf, 8
p_gc_spare_buf:
	.zero	8
	.section	.bss.p_io_data_buf_0,"aw",@nobits
	.align	3
	.set	.LANCHOR183,. + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 8
p_io_data_buf_0:
	.zero	8
	.section	.bss.p_io_data_buf_1,"aw",@nobits
	.align	3
	.set	.LANCHOR184,. + 0
	.type	p_io_data_buf_1, %object
	.size	p_io_data_buf_1, 8
p_io_data_buf_1:
	.zero	8
	.section	.bss.p_io_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR186,. + 0
	.type	p_io_spare_buf, %object
	.size	p_io_spare_buf, 8
p_io_spare_buf:
	.zero	8
	.section	.bss.p_l2p_map_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR123,. + 0
	.type	p_l2p_map_buf, %object
	.size	p_l2p_map_buf, 8
p_l2p_map_buf:
	.zero	8
	.section	.bss.p_l2p_ram_map,"aw",@nobits
	.align	3
	.set	.LANCHOR95,. + 0
	.type	p_l2p_ram_map, %object
	.size	p_l2p_ram_map, 8
p_l2p_ram_map:
	.zero	8
	.section	.bss.p_map_block_table,"aw",@nobits
	.align	3
	.set	.LANCHOR126,. + 0
	.type	p_map_block_table, %object
	.size	p_map_block_table, 8
p_map_block_table:
	.zero	8
	.section	.bss.p_map_block_valid_page_count,"aw",@nobits
	.align	3
	.set	.LANCHOR122,. + 0
	.type	p_map_block_valid_page_count, %object
	.size	p_map_block_valid_page_count, 8
p_map_block_valid_page_count:
	.zero	8
	.section	.bss.p_map_block_ver_table,"aw",@nobits
	.align	3
	.set	.LANCHOR127,. + 0
	.type	p_map_block_ver_table, %object
	.size	p_map_block_ver_table, 8
p_map_block_ver_table:
	.zero	8
	.section	.bss.p_map_region_ppn_check_table,"aw",@nobits
	.align	3
	.set	.LANCHOR192,. + 0
	.type	p_map_region_ppn_check_table, %object
	.size	p_map_region_ppn_check_table, 8
p_map_region_ppn_check_table:
	.zero	8
	.section	.bss.p_map_region_ppn_table,"aw",@nobits
	.align	3
	.set	.LANCHOR128,. + 0
	.type	p_map_region_ppn_table, %object
	.size	p_map_region_ppn_table, 8
p_map_region_ppn_table:
	.zero	8
	.section	.bss.p_plane_order_table,"aw",@nobits
	.align	3
	.set	.LANCHOR45,. + 0
	.type	p_plane_order_table, %object
	.size	p_plane_order_table, 32
p_plane_order_table:
	.zero	32
	.section	.bss.p_swl_mul_table,"aw",@nobits
	.align	3
	.set	.LANCHOR134,. + 0
	.type	p_swl_mul_table, %object
	.size	p_swl_mul_table, 8
p_swl_mul_table:
	.zero	8
	.section	.bss.p_sys_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR79,. + 0
	.type	p_sys_data_buf, %object
	.size	p_sys_data_buf, 8
p_sys_data_buf:
	.zero	8
	.section	.bss.p_sys_data_buf_1,"aw",@nobits
	.align	3
	.set	.LANCHOR181,. + 0
	.type	p_sys_data_buf_1, %object
	.size	p_sys_data_buf_1, 8
p_sys_data_buf_1:
	.zero	8
	.section	.bss.p_sys_spare_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR185,. + 0
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
	.set	.LANCHOR82,. + 0
	.type	p_valid_page_count_table, %object
	.size	p_valid_page_count_table, 8
p_valid_page_count_table:
	.zero	8
	.section	.bss.p_vendor_block_table,"aw",@nobits
	.align	3
	.set	.LANCHOR70,. + 0
	.type	p_vendor_block_table, %object
	.size	p_vendor_block_table, 8
p_vendor_block_table:
	.zero	8
	.section	.bss.p_vendor_block_valid_page_count,"aw",@nobits
	.align	3
	.set	.LANCHOR189,. + 0
	.type	p_vendor_block_valid_page_count, %object
	.size	p_vendor_block_valid_page_count, 8
p_vendor_block_valid_page_count:
	.zero	8
	.section	.bss.p_vendor_block_ver_table,"aw",@nobits
	.align	3
	.set	.LANCHOR190,. + 0
	.type	p_vendor_block_ver_table, %object
	.size	p_vendor_block_ver_table, 8
p_vendor_block_ver_table:
	.zero	8
	.section	.bss.p_vendor_data_buf,"aw",@nobits
	.align	3
	.set	.LANCHOR182,. + 0
	.type	p_vendor_data_buf, %object
	.size	p_vendor_data_buf, 8
p_vendor_data_buf:
	.zero	8
	.section	.bss.p_vendor_region_ppn_table,"aw",@nobits
	.align	3
	.set	.LANCHOR191,. + 0
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
	.set	.LANCHOR76,. + 0
	.type	req_erase, %object
	.size	req_erase, 8
req_erase:
	.zero	8
	.section	.bss.req_gc,"aw",@nobits
	.align	3
	.set	.LANCHOR106,. + 0
	.type	req_gc, %object
	.size	req_gc, 8
req_gc:
	.zero	8
	.section	.bss.req_gc_dst,"aw",@nobits
	.align	3
	.set	.LANCHOR179,. + 0
	.type	req_gc_dst, %object
	.size	req_gc_dst, 8
req_gc_dst:
	.zero	8
	.section	.bss.req_prgm,"aw",@nobits
	.align	3
	.set	.LANCHOR180,. + 0
	.type	req_prgm, %object
	.size	req_prgm, 8
req_prgm:
	.zero	8
	.section	.bss.req_read,"aw",@nobits
	.align	3
	.set	.LANCHOR178,. + 0
	.type	req_read, %object
	.size	req_read, 8
req_read:
	.zero	8
	.section	.bss.req_sys,"aw",@nobits
	.align	3
	.set	.LANCHOR199,. + 0
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
	.section	.data.NandFlashParaTbl,"aw",@progbits
	.align	3
	.set	.LANCHOR140,. + 0
	.type	NandFlashParaTbl, %object
	.size	NandFlashParaTbl, 2336
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
	.hword	1503
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
	.set	.LANCHOR141,. + 0
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
	.set	.LANCHOR233,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.hword	-1
	.section	.data.gFtlInitStatus,"aw",@progbits
	.align	2
	.set	.LANCHOR223,. + 0
	.type	gFtlInitStatus, %object
	.size	gFtlInitStatus, 4
gFtlInitStatus:
	.word	-1
	.section	.data.gNandParaInfo,"aw",@progbits
	.align	3
	.set	.LANCHOR29,. + 0
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
	.set	.LANCHOR197,. + 0
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
	.set	.LANCHOR193,. + 0
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
.LC7:
	.string	"sdr read ok %x ecc=%d\n"
.LC8:
	.string	"sync para %d\n"
.LC9:
	.string	"TOG mode Read error %x %x\n"
	.section	.rodata.FlashEraseSLc2KBlocks.str1.1,"aMS",@progbits,1
.LC1:
	.string	"FlashEraseBlocks pageAddr error %x\n"
	.section	.rodata.FlashInit.str1.1,"aMS",@progbits,1
.LC18:
	.string	"No.%d FLASH ID:%x %x %x %x %x %x\n"
.LC19:
	.string	"FlashLoadPhyInfo fail %x!!\n"
	.section	.rodata.FlashProgSlc2KPages.str1.1,"aMS",@progbits,1
.LC24:
	.string	"prog error: = %x\n"
.LC25:
	.string	"prog read error: = %x\n"
.LC26:
	.string	"prog read s error: = %x %x %x\n"
.LC27:
	.string	"prog read d error: = %x %x %x\n"
	.section	.rodata.FlashReadFacBbtData.str1.1,"aMS",@progbits,1
.LC55:
	.string	"BBT:"
	.section	.rodata.FlashReadIdbDataRaw.str1.1,"aMS",@progbits,1
.LC12:
	.string	"ECC:%d\n"
	.section	.rodata.FlashReadPage.str1.1,"aMS",@progbits,1
.LC10:
	.string	"read retry status %x %x %x\n"
	.section	.rodata.FlashReadPages.str1.1,"aMS",@progbits,1
.LC23:
	.string	"ReadRetry pageadd=%x ecc=%x err=%x\n"
	.section	.rodata.FlashReadSlc2KPages.str1.1,"aMS",@progbits,1
.LC20:
	.string	"Read pageadd=%x  ecc=%x err=%x\n"
.LC21:
	.string	"data:"
.LC22:
	.string	"spare:"
	.section	.rodata.FtlBbmMapBadBlock.str1.1,"aMS",@progbits,1
.LC2:
	.string	"phyBlk = 0x%x die = %d block_in_die = 0x%x 0x%8x\n"
	.section	.rodata.FtlBbmTblFlush.str1.1,"aMS",@progbits,1
.LC28:
	.string	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\n"
.LC29:
	.string	"FtlBbmTblFlush error:%x\n"
.LC30:
	.string	"FtlBbmTblFlush error = %x error count = %d\n"
	.section	.rodata.FtlGcFreeTempBlock.str1.1,"aMS",@progbits,1
.LC47:
	.string	"GC des block %x done\n"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",@progbits,1
.LC46:
	.string	"FtlGcScanTempBlkError ID %x %x!!!!!!!\n"
	.section	.rodata.FtlInit.str1.1,"aMS",@progbits,1
.LC48:
	.string	"FTL version: 5.0.47 20180208"
.LC49:
	.string	"...%s: no bad block mapping table, format device\n"
.LC50:
	.string	"...%s FtlSysBlkInit error ,format device!\n"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",@progbits,1
.LC40:
	.string	"no ect"
	.section	.rodata.FtlMapTblRecovery.str1.1,"aMS",@progbits,1
.LC42:
	.string	"page map lost %x %x %x %x\n"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",@progbits,1
.LC35:
	.string	"FtlMapWritePage error = %x\n"
.LC36:
	.string	"FtlMapWritePage error = %x error count = %d\n"
	.section	.rodata.FtlProgPages.str1.1,"aMS",@progbits,1
.LC38:
	.string	"Ftlwrite decrement_vpc_count %x = %d\n"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",@progbits,1
.LC43:
	.string	"RSB refresh addr %x\n"
.LC44:
	.string	"spuer block %x vpn is 0\n "
.LC45:
	.string	"g_recovery_ppa %x ver %x\n "
	.section	.rodata.FtlVendorPartRead.str1.1,"aMS",@progbits,1
.LC39:
	.string	"FtlVendorPartRead refresh = %x phyAddr = %x\n"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",@progbits,1
.LC32:
	.string	"FtlVpcTblFlush error = %x error count = %d\n"
	.section	.rodata.Ftl_load_ext_data.str1.1,"aMS",@progbits,1
.LC41:
	.string	"slc mode"
	.section	.rodata.HynixGetReadRetryDefault.str1.1,"aMS",@progbits,1
.LC16:
	.string	"otp error! %d"
.LC17:
	.string	"rr"
	.section	.rodata.INSERT_DATA_LIST.str1.1,"aMS",@progbits,1
.LC4:
	.string	"\n!!!!! error @ func:%s - line:%d\n"
.LC5:
	.string	"!!!!! FTL sys Error !!!!!"
.LC6:
	.string	"%s\n"
	.section	.rodata.MicronReadRetrial.str1.1,"aMS",@progbits,1
.LC11:
	.string	"micron RR %d row=%x,count %d,status=%d\n"
	.section	.rodata.__func__.10004,"a",@progbits
	.align	3
	.set	.LANCHOR214,. + 0
	.type	__func__.10004, %object
	.size	__func__.10004, 16
__func__.10004:
	.string	"FtlReUsePrevPpa"
	.section	.rodata.__func__.10037,"a",@progbits
	.align	3
	.set	.LANCHOR228,. + 0
	.type	__func__.10037, %object
	.size	__func__.10037, 22
__func__.10037:
	.string	"FtlRecoverySuperblock"
	.section	.rodata.__func__.10091,"a",@progbits
	.align	3
	.set	.LANCHOR100,. + 0
	.type	__func__.10091, %object
	.size	__func__.10091, 16
__func__.10091:
	.string	"make_superblock"
	.section	.rodata.__func__.10111,"a",@progbits
	.align	3
	.set	.LANCHOR138,. + 0
	.type	__func__.10111, %object
	.size	__func__.10111, 18
__func__.10111:
	.string	"SupperBlkListInit"
	.section	.rodata.__func__.10188,"a",@progbits
	.align	3
	.set	.LANCHOR200,. + 0
	.type	__func__.10188, %object
	.size	__func__.10188, 25
__func__.10188:
	.string	"allocate_data_superblock"
	.section	.rodata.__func__.10202,"a",@progbits
	.align	3
	.set	.LANCHOR219,. + 0
	.type	__func__.10202, %object
	.size	__func__.10202, 29
__func__.10202:
	.string	"allocate_new_data_superblock"
	.section	.rodata.__func__.10208,"a",@progbits
	.align	3
	.set	.LANCHOR205,. + 0
	.type	__func__.10208, %object
	.size	__func__.10208, 19
__func__.10208:
	.string	"get_new_active_ppa"
	.section	.rodata.__func__.10219,"a",@progbits
	.align	3
	.set	.LANCHOR203,. + 0
	.type	__func__.10219, %object
	.size	__func__.10219, 16
__func__.10219:
	.string	"update_vpc_list"
	.section	.rodata.__func__.10224,"a",@progbits
	.align	3
	.set	.LANCHOR204,. + 0
	.type	__func__.10224, %object
	.size	__func__.10224, 20
__func__.10224:
	.string	"decrement_vpc_count"
	.section	.rodata.__func__.10292,"a",@progbits
	.align	3
	.set	.LANCHOR234,. + 0
	.type	__func__.10292, %object
	.size	__func__.10292, 19
__func__.10292:
	.string	"FtlGcFreeTempBlock"
	.section	.rodata.__func__.10386,"a",@progbits
	.align	3
	.set	.LANCHOR238,. + 0
	.type	__func__.10386, %object
	.size	__func__.10386, 23
__func__.10386:
	.string	"rk_ftl_garbage_collect"
	.section	.rodata.__func__.9318,"a",@progbits
	.align	3
	.set	.LANCHOR240,. + 0
	.type	__func__.9318, %object
	.size	__func__.9318, 8
__func__.9318:
	.string	"FtlInit"
	.section	.rodata.__func__.9378,"a",@progbits
	.align	3
	.set	.LANCHOR220,. + 0
	.type	__func__.9378, %object
	.size	__func__.9378, 13
__func__.9378:
	.string	"FtlProgPages"
	.section	.rodata.__func__.9404,"a",@progbits
	.align	3
	.set	.LANCHOR242,. + 0
	.type	__func__.9404, %object
	.size	__func__.9404, 10
__func__.9404:
	.string	"ftl_write"
	.section	.rodata.__func__.9467,"a",@progbits
	.align	3
	.set	.LANCHOR121,. + 0
	.type	__func__.9467, %object
	.size	__func__.9467, 14
__func__.9467:
	.string	"FtlBbt2Bitmap"
	.section	.rodata.__func__.9513,"a",@progbits
	.align	3
	.set	.LANCHOR208,. + 0
	.type	__func__.9513, %object
	.size	__func__.9513, 11
__func__.9513:
	.string	"FtlLoadBbt"
	.section	.rodata.__func__.9622,"a",@progbits
	.align	3
	.set	.LANCHOR88,. + 0
	.type	__func__.9622, %object
	.size	__func__.9622, 17
__func__.9622:
	.string	"INSERT_FREE_LIST"
	.section	.rodata.__func__.9626,"a",@progbits
	.align	3
	.set	.LANCHOR85,. + 0
	.type	__func__.9626, %object
	.size	__func__.9626, 17
__func__.9626:
	.string	"INSERT_DATA_LIST"
	.section	.rodata.__func__.9656,"a",@progbits
	.align	3
	.set	.LANCHOR89,. + 0
	.type	__func__.9656, %object
	.size	__func__.9656, 17
__func__.9656:
	.string	"List_remove_node"
	.section	.rodata.__func__.9686,"a",@progbits
	.align	3
	.set	.LANCHOR93,. + 0
	.type	__func__.9686, %object
	.size	__func__.9686, 22
__func__.9686:
	.string	"List_update_data_list"
	.section	.rodata.__func__.9693,"a",@progbits
	.align	3
	.set	.LANCHOR212,. + 0
	.type	__func__.9693, %object
	.size	__func__.9693, 16
__func__.9693:
	.string	"load_l2p_region"
	.section	.rodata.__func__.9723,"a",@progbits
	.align	3
	.set	.LANCHOR94,. + 0
	.type	__func__.9723, %object
	.size	__func__.9723, 26
__func__.9723:
	.string	"ftl_map_blk_alloc_new_blk"
	.section	.rodata.__func__.9737,"a",@progbits
	.align	3
	.set	.LANCHOR209,. + 0
	.type	__func__.9737, %object
	.size	__func__.9737, 15
__func__.9737:
	.string	"ftl_map_blk_gc"
	.section	.rodata.__func__.9750,"a",@progbits
	.align	3
	.set	.LANCHOR210,. + 0
	.type	__func__.9750, %object
	.size	__func__.9750, 31
__func__.9750:
	.string	"Ftl_write_map_blk_to_last_page"
	.section	.rodata.__func__.9763,"a",@progbits
	.align	3
	.set	.LANCHOR211,. + 0
	.type	__func__.9763, %object
	.size	__func__.9763, 16
__func__.9763:
	.string	"FtlMapWritePage"
	.section	.rodata.__func__.9783,"a",@progbits
	.align	3
	.set	.LANCHOR97,. + 0
	.type	__func__.9783, %object
	.size	__func__.9783, 22
__func__.9783:
	.string	"select_l2p_ram_region"
	.section	.rodata.__func__.9799,"a",@progbits
	.align	3
	.set	.LANCHOR213,. + 0
	.type	__func__.9799, %object
	.size	__func__.9799, 9
__func__.9799:
	.string	"log2phys"
	.section	.rodata.__func__.9861,"a",@progbits
	.align	3
	.set	.LANCHOR207,. + 0
	.type	__func__.9861, %object
	.size	__func__.9861, 15
__func__.9861:
	.string	"FtlVpcTblFlush"
	.section	.rodata.__func__.9880,"a",@progbits
	.align	3
	.set	.LANCHOR224,. + 0
	.type	__func__.9880, %object
	.size	__func__.9880, 14
__func__.9880:
	.string	"FtlScanSysBlk"
	.section	.rodata.__func__.9934,"a",@progbits
	.align	3
	.set	.LANCHOR225,. + 0
	.type	__func__.9934, %object
	.size	__func__.9934, 15
__func__.9934:
	.string	"FtlLoadSysInfo"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",@progbits,1
.LC31:
	.string	"decrement_vpc_count %x = %d\n"
	.section	.rodata.ftl_fix_nand_power_lost_error.str1.1,"aMS",@progbits,1
.LC52:
	.string	"fix power lost blk = %x vpc=%x\n"
.LC53:
	.string	"erase power lost blk = %x vpc=%x\n"
	.section	.rodata.ftl_map_blk_gc.str1.1,"aMS",@progbits,1
.LC33:
	.string	"ftl_map_blk_gc blk info: %x %x %x\n"
.LC34:
	.string	"page map lost: %x %x\n"
	.section	.rodata.ftl_write.str1.1,"aMS",@progbits,1
.LC54:
	.string	"FtlWrite: lpa error:%x %x\n"
	.section	.rodata.load_l2p_region.str1.1,"aMS",@progbits,1
.LC37:
	.string	"load_l2p_region refresh = %x phyAddr = %x\n"
	.section	.rodata.remove_from_free_sys_Queue.str1.1,"aMS",@progbits,1
.LC3:
	.string	"remove_from_free_sys_Queue %x\n"
	.section	.rodata.rk_ftl_init.str1.1,"aMS",@progbits,1
.LC51:
	.string	"FtlInit %x\n"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",@progbits,1
.LC13:
	.string	"%s 0x%x:"
.LC14:
	.string	"%x "
.LC15:
	.string	""
	.hidden	free
	.ident	"GCC: (Linaro GCC 6.3-2017.05) 6.3.1 20170404"
	.section	.note.GNU-stack,"",@progbits
