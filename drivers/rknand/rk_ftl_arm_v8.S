/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2019-08-28
 */
	.arch armv8-a
	.file	"rk_ftl_arm_v8.S"
	.section	.text.flash_read_ecc,"ax",@progbits
	.align	2
	.type	flash_read_ecc, %function
flash_read_ecc:
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR0
	add	x1, x1, :lo12:.LANCHOR0
	stp	x29, x30, [sp, -32]!
	add	x2, x1, x0
	add	x29, sp, 0
	ldr	x0, [x1, x0]
	str	x19, [sp, 16]
	ldrb	w19, [x2, 8]
	add	x19, x0, x19, lsl 8
	mov	w0, 122
	str	w0, [x19, 2056]
	mov	x0, 80
	bl	udelay
	ldr	w1, [x19, 2048]
	ldr	w0, [x19, 2048]
	and	w1, w1, 15
	and	w0, w0, 15
	cmp	w1, w0
	csel	w1, w1, w0, cs
	ldr	w0, [x19, 2048]
	ldr	w2, [x19, 2048]
	and	w0, w0, 15
	ldr	x19, [sp, 16]
	and	w2, w2, 15
	cmp	w0, w2
	csel	w0, w0, w2, cs
	cmp	w0, w1
	csel	w0, w0, w1, cs
	ldp	x29, x30, [sp], 32
	ret
	.size	flash_read_ecc, .-flash_read_ecc
	.section	.text.ftl_set_blk_mode.part.10,"ax",@progbits
	.align	2
	.type	ftl_set_blk_mode.part.10, %function
ftl_set_blk_mode.part.10:
	and	w0, w0, 65535
	adrp	x2, .LANCHOR1
	ubfx	x1, x0, 5, 11
	ldr	x3, [x2, #:lo12:.LANCHOR1]
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
	adrp	x3, .LANCHOR2
	ldrb	w3, [x3, #:lo12:.LANCHOR2]
	cbz	w3, .L9
	ldrb	w4, [x0, 1]
	ldrb	w3, [x1, 1]
	cmp	w4, w3
	beq	.L10
.L9:
	mov	x3, 0
.L7:
	mov	w4, w3
	cmp	w3, w2
	bcc	.L8
.L10:
	mov	w0, 0
	ret
.L8:
	ldrb	w5, [x0, x3]
	add	x3, x3, 1
	add	x6, x1, x3
	ldrb	w6, [x6, -1]
	cmp	w6, w5
	beq	.L7
	add	w0, w4, 1
	ret
	.size	FlashMemCmp8, .-FlashMemCmp8
	.section	.text.FlashRsvdBlkChk,"ax",@progbits
	.align	2
	.global	FlashRsvdBlkChk
	.type	FlashRsvdBlkChk, %function
FlashRsvdBlkChk:
	adrp	x2, .LANCHOR3
	adrp	x3, .LANCHOR4
	and	w0, w0, 255
	ldrb	w2, [x2, #:lo12:.LANCHOR3]
	ldr	w3, [x3, #:lo12:.LANCHOR4]
	mul	w2, w2, w3
	cmp	w2, w1
	bls	.L14
	cmp	w0, 0
	cset	w0, ne
	ret
.L14:
	mov	w0, 1
	ret
	.size	FlashRsvdBlkChk, .-FlashRsvdBlkChk
	.section	.text.FlashGetRandomizer,"ax",@progbits
	.align	2
	.global	FlashGetRandomizer
	.type	FlashGetRandomizer, %function
FlashGetRandomizer:
	and	x3, x1, 127
	adrp	x2, .LANCHOR5
	add	x2, x2, :lo12:.LANCHOR5
	ldrh	w4, [x2, x3, lsl 1]
	adrp	x2, .LANCHOR6
	ldrb	w2, [x2, #:lo12:.LANCHOR6]
	cbz	w2, .L23
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
.L23:
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
	adrp	x0, .LANCHOR5
	add	x0, x0, :lo12:.LANCHOR5
	ldrh	w4, [x0, x2, lsl 1]
	adrp	x0, .LANCHOR6
	ldrb	w0, [x0, #:lo12:.LANCHOR6]
	cbz	w0, .L34
	stp	x29, x30, [sp, -16]!
	mov	w0, w5
	add	x29, sp, 0
	bl	FlashRsvdBlkChk
	cmp	w0, 0
	sbfiz	x5, x5, 4, 32
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	orr	w1, w4, -1073741824
	csel	w4, w1, w4, ne
	ldr	x0, [x0, x5]
	str	w4, [x0, 336]
	ldp	x29, x30, [sp], 16
	ret
.L34:
	sbfiz	x5, x5, 4, 32
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	ldr	x0, [x0, x5]
	str	w4, [x0, 336]
	ret
	.size	FlashSetRandomizer, .-FlashSetRandomizer
	.section	.text.FlashBlockAlignInit,"ax",@progbits
	.align	2
	.global	FlashBlockAlignInit
	.type	FlashBlockAlignInit, %function
FlashBlockAlignInit:
	and	w0, w0, 65535
	adrp	x1, .LANCHOR4
	cmp	w0, 256
	bls	.L38
	mov	w0, 512
.L41:
	str	w0, [x1, #:lo12:.LANCHOR4]
	ret
.L38:
	cmp	w0, 128
	bls	.L41
	mov	w0, 256
	b	.L41
	.size	FlashBlockAlignInit, .-FlashBlockAlignInit
	.section	.text.FlashReadCmd,"ax",@progbits
	.align	2
	.global	FlashReadCmd
	.type	FlashReadCmd, %function
FlashReadCmd:
	and	w0, w0, 255
	adrp	x4, .LANCHOR0
	sbfiz	x5, x0, 4, 32
	add	x4, x4, :lo12:.LANCHOR0
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
	adrp	x2, .LANCHOR0
	sbfiz	x3, x0, 4, 32
	add	x2, x2, :lo12:.LANCHOR0
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
	bne	.L44
	mov	w6, 6
	str	w6, [x2, 2056]
	str	wzr, [x2, 2052]
	str	wzr, [x2, 2052]
	str	w5, [x2, 2052]
	str	w4, [x2, 2052]
	str	w3, [x2, 2052]
.L46:
	mov	w3, 224
	str	w3, [x2, 2056]
	b	FlashSetRandomizer
.L44:
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
	b	.L46
	.size	FlashReadDpDataOutCmd, .-FlashReadDpDataOutCmd
	.section	.text.FlashProgFirstCmd,"ax",@progbits
	.align	2
	.global	FlashProgFirstCmd
	.type	FlashProgFirstCmd, %function
FlashProgFirstCmd:
	and	w0, w0, 255
	adrp	x4, .LANCHOR0
	sbfiz	x5, x0, 4, 32
	add	x4, x4, :lo12:.LANCHOR0
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
	adrp	x3, .LANCHOR0
	add	x3, x3, :lo12:.LANCHOR0
	add	x4, x3, x0
	ldr	x3, [x3, x0]
	ldrb	w0, [x4, 8]
	cbz	w2, .L49
	add	x2, x3, x0, lsl 8
	mov	w4, 96
	str	w4, [x2, 2056]
	and	w4, w1, 255
	str	w4, [x2, 2052]
	lsr	w4, w1, 8
	str	w4, [x2, 2052]
	lsr	w4, w1, 16
	str	w4, [x2, 2052]
	adrp	x2, .LANCHOR4
	ldr	w2, [x2, #:lo12:.LANCHOR4]
	add	w1, w1, w2
.L49:
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
	adrp	x4, .LANCHOR0
	add	x4, x4, :lo12:.LANCHOR0
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
	adrp	x1, .LANCHOR0
	add	x1, x1, :lo12:.LANCHOR0
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
	adrp	x1, .LANCHOR0
	add	x1, x1, :lo12:.LANCHOR0
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
	adrp	x1, .LANCHOR0
	add	x1, x1, :lo12:.LANCHOR0
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
	.section	.text.js_hash,"ax",@progbits
	.align	2
	.global	js_hash
	.type	js_hash, %function
js_hash:
	mov	x4, x0
	mov	w0, 42982
	mov	x3, 0
	movk	w0, 0x47c6, lsl 16
.L59:
	cmp	w1, w3
	bhi	.L60
	ret
.L60:
	lsr	w2, w0, 2
	ldrb	w5, [x4, x3]
	add	w2, w2, w0, lsl 5
	add	x3, x3, 1
	add	w2, w2, w5
	eor	w0, w0, w2
	b	.L59
	.size	js_hash, .-js_hash
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
	adrp	x20, .LANCHOR8
	umull	x2, w2, w0
	stp	x23, x24, [sp, 48]
	adrp	x0, .LANCHOR9
	add	x20, x20, :lo12:.LANCHOR8
	add	x24, x0, :lo12:.LANCHOR9
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR12
	adrp	x25, .LANCHOR10
	adrp	x26, .LANCHOR11
	add	x23, x23, :lo12:.LANCHOR12
	add	x25, x25, :lo12:.LANCHOR10
	add	x26, x26, :lo12:.LANCHOR11
	add	x20, x20, x2
	add	x24, x24, x2
	mov	x22, x0
	mov	x19, 0
.L64:
	ldrb	w0, [x23]
	cmp	w0, w19
	bhi	.L68
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L68:
	mov	w0, 85
	str	w0, [x21, 8]
	add	x0, x22, :lo12:.LANCHOR9
	ldrsb	w0, [x19, x0]
	str	w0, [x21, 4]
	mov	x0, 200
	bl	udelay
	ldrb	w0, [x25]
	cmp	w0, 34
	bne	.L65
	ldrsb	w0, [x24, x19]
.L70:
	add	x19, x19, 1
	str	w0, [x21]
	b	.L64
.L65:
	cmp	w0, 35
	bne	.L67
	ldrsb	w0, [x20, x19]
	b	.L70
.L67:
	ldrsb	w0, [x26, w27, sxtw]
	b	.L70
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
	adrp	x0, .LANCHOR13
	add	x0, x0, :lo12:.LANCHOR13
	stp	x19, x20, [sp, 16]
	add	x21, x0, x21
	stp	x23, x24, [sp, 48]
	mov	x19, x0
	adrp	x23, .LANCHOR12
	add	x23, x23, :lo12:.LANCHOR12
	mov	x20, 0
	mov	w24, 161
.L72:
	ldrb	w0, [x23]
	cmp	w0, w20
	bhi	.L73
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L73:
	str	w24, [x22, 8]
	str	wzr, [x22]
	ldrsb	w0, [x20, x19]
	str	w0, [x22]
	ldrsb	w0, [x21, x20]
	add	x20, x20, 1
	str	w0, [x22]
	mov	x0, 300
	bl	udelay
	b	.L72
	.size	SamsungSetRRPara, .-SamsungSetRRPara
	.section	.text.LogAddr2PhyAddr,"ax",@progbits
	.align	2
	.global	LogAddr2PhyAddr
	.type	LogAddr2PhyAddr, %function
LogAddr2PhyAddr:
	adrp	x6, .LANCHOR14
	add	x6, x6, :lo12:.LANCHOR14
	and	w4, w4, 255
	ldrh	w8, [x6, 12]
	ldrh	w5, [x6, 14]
	mul	w5, w5, w8
	and	w8, w5, 65535
	adrp	x5, .LANCHOR4
	ldrh	w7, [x5, #:lo12:.LANCHOR4]
	adrp	x5, .LANCHOR2
	ldrb	w6, [x5, #:lo12:.LANCHOR2]
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
	bne	.L77
	adrp	x1, .LANCHOR15
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	cbnz	w1, .L77
	adrp	x1, .LANCHOR16
	add	x1, x1, :lo12:.LANCHOR16
	ldrh	w6, [x1, w6, sxtw 1]
.L77:
	uxtw	x8, w10
	adrp	x1, .LANCHOR17
	add	x1, x1, :lo12:.LANCHOR17
	cmp	w4, 1
	ldr	w1, [x1, x8, lsl 2]
	madd	w5, w5, w7, w1
	add	w5, w5, w6
	str	w5, [x2]
	str	w10, [x3]
	bls	.L79
	ldr	w1, [x0, 4]
	ldr	w0, [x0, 60]
	add	w1, w1, 1024
	cmp	w1, w0
	cset	w0, eq
	ret
.L79:
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
	adrp	x3, .LANCHOR0
	add	x3, x3, :lo12:.LANCHOR0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	add	x4, x3, x0
	ldr	x20, [x3, x0]
	adrp	x0, .LANCHOR18
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	ldrb	w19, [x4, 8]
	ldrb	w0, [x0, 8]
	cmp	w0, 2
	bne	.L81
	and	w2, w2, 255
	adrp	x0, .LANCHOR7
	cbnz	w2, .L82
	add	x2, x0, :lo12:.LANCHOR7
	ldrb	w3, [x2, 13]
.L92:
	add	x2, x19, 8
	add	x0, x0, :lo12:.LANCHOR7
	add	x2, x20, x2, lsl 8
	str	w3, [x2, 8]
	ldrb	w4, [x0, 15]
	cbz	w4, .L86
	add	x3, x19, 8
	mov	w2, 0
	add	x3, x20, x3, lsl 8
.L85:
	cmp	w2, w4
	bcc	.L87
.L86:
	add	x19, x19, 8
	mov	x0, 80
	lsl	x19, x19, 8
	bl	udelay
	ldr	w0, [x20, x19]
	ldp	x19, x20, [sp, 16]
	and	w0, w0, 255
	ldp	x29, x30, [sp], 32
	ret
.L82:
	add	x2, x0, :lo12:.LANCHOR7
	ldrb	w3, [x2, 14]
	b	.L92
.L87:
	lsl	w0, w2, 3
	add	w2, w2, 1
	lsr	w0, w1, w0
	and	w0, w0, 255
	str	w0, [x3, 4]
	b	.L85
.L81:
	add	x0, x19, 8
	mov	w1, 112
	add	x0, x20, x0, lsl 8
	str	w1, [x0, 8]
	b	.L86
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
.L97:
	mov	w1, w20
	mov	w2, w21
	mov	w0, w19
	bl	FlashReadStatusEN
	mov	w1, w0
	cmp	w0, 255
	beq	.L97
	tbz	x1, 6, .L97
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
	adrp	x1, .LANCHOR0
	add	x1, x1, :lo12:.LANCHOR0
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
	beq	.L109
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
.L111:
	mov	w0, 0
	str	w1, [x2]
	ret
.L109:
	and	w1, w1, -8193
	b	.L111
	.size	NandcSetMode, .-NandcSetMode
	.section	.text.NandcFlashCs,"ax",@progbits
	.align	2
	.global	NandcFlashCs
	.type	NandcFlashCs, %function
NandcFlashCs:
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR0
	add	x1, x1, :lo12:.LANCHOR0
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
	adrp	x1, .LANCHOR0
	add	x1, x1, :lo12:.LANCHOR0
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
	mov	x20, x2
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	and	w26, w1, 255
	stp	x23, x24, [sp, 48]
	and	w21, w3, 255
	adrp	x19, .LANCHOR20
	ldrb	w0, [x0, 19]
	cmp	w0, 6
	bne	.L117
	add	x0, x19, :lo12:.LANCHOR20
	ubfiz	x19, x22, 6, 8
	add	x19, x19, 20
	add	x19, x19, x21, uxtw 2
.L124:
	add	x19, x0, x19
.L118:
	sxtw	x25, w22
	adrp	x0, .LANCHOR0
	lsl	x1, x25, 4
	add	x0, x0, :lo12:.LANCHOR0
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
.L121:
	cmp	x24, x26
	bne	.L122
	mov	w0, 22
	str	w0, [x23, 2056]
	mov	w0, w22
	bl	NandcFlashDeCs
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	strb	w21, [x0, x25]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L117:
	cmp	w0, 7
	bne	.L119
	add	x0, x19, :lo12:.LANCHOR20
	mov	x1, 28
	mov	w19, 160
	umaddl	x1, w19, w22, x1
	mov	w19, 10
	umaddl	x19, w21, w19, x1
	b	.L124
.L119:
	cmp	w0, 8
	bne	.L120
	add	x19, x19, :lo12:.LANCHOR20
	add	x0, x19, 28
	add	w19, w21, w21, lsl 2
	add	x19, x0, x19, sxtw
	b	.L118
.L120:
	add	x0, x19, :lo12:.LANCHOR20
	and	x19, x21, 255
	add	x19, x19, 2
	add	x19, x19, x22, uxtw 3
	add	x19, x0, x19, lsl 3
	add	x19, x19, 4
	b	.L118
.L122:
	ldrb	w0, [x20, x24]
	str	w0, [x23, 2052]
	mov	x0, 200
	bl	udelay
	ldrsb	w0, [x19, x24]
	add	x24, x24, 1
	str	w0, [x23, 2048]
	b	.L121
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
	cmp	w0, 7
	bhi	.L132
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
.L128:
	lsl	x1, x19, 3
	and	w0, w19, 255
	ldrb	w1, [x1, x21]
	cmp	w1, 173
	bne	.L127
	ldrb	w1, [x20, 1]
	mov	w3, 0
	mov	x2, x22
	bl	HynixSetRRPara
.L127:
	add	x19, x19, 1
	cmp	x19, 4
	bne	.L128
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L132:
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
	cbz	x2, .L137
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
	cbz	x1, .L137
	str	w0, [x1]
	str	xzr, [x19, 16]
.L137:
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
	.section	.text.NandcWaitFlashReadyNoDelay,"ax",@progbits
	.align	2
	.global	NandcWaitFlashReadyNoDelay
	.type	NandcWaitFlashReadyNoDelay, %function
NandcWaitFlashReadyNoDelay:
	stp	x29, x30, [sp, -48]!
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR0
	add	x1, x1, :lo12:.LANCHOR0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, 34464
	ldr	x20, [x1, x0]
	movk	w19, 0x1, lsl 16
.L147:
	ldr	w0, [x20]
	str	w0, [x29, 40]
	ldr	w0, [x29, 40]
	tbnz	x0, 9, .L148
	mov	x0, 10
	bl	udelay
	subs	w19, w19, #1
	bne	.L147
	mov	w0, -1
.L145:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L148:
	mov	w0, 0
	b	.L145
	.size	NandcWaitFlashReadyNoDelay, .-NandcWaitFlashReadyNoDelay
	.section	.text.NandcWaitFlashReady,"ax",@progbits
	.align	2
	.global	NandcWaitFlashReady
	.type	NandcWaitFlashReady, %function
NandcWaitFlashReady:
	stp	x29, x30, [sp, -48]!
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR0
	add	x1, x1, :lo12:.LANCHOR0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, 34464
	movk	w19, 0x1, lsl 16
	ldr	x20, [x1, x0]
	mov	x0, 150
	bl	udelay
.L153:
	ldr	w0, [x20]
	str	w0, [x29, 40]
	ldr	w0, [x29, 40]
	tbnz	x0, 9, .L154
	mov	x0, 10
	bl	udelay
	subs	w19, w19, #1
	bne	.L153
	mov	w0, -1
.L151:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L154:
	mov	w0, 0
	b	.L151
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
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
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
	.section	.text.flash_enter_slc_mode,"ax",@progbits
	.align	2
	.global	flash_enter_slc_mode
	.type	flash_enter_slc_mode, %function
flash_enter_slc_mode:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L159
	mov	w0, w20
	bl	NandcFlashCs
	sbfiz	x1, x20, 4, 32
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x2, x0, x1
	ldr	x0, [x0, x1]
	ldrb	w19, [x2, 8]
	add	x19, x0, x19, lsl 8
	mov	w0, 239
	str	w0, [x19, 2056]
	mov	w0, 145
	str	w0, [x19, 2052]
	mov	x0, 100
	bl	udelay
	str	wzr, [x19, 2048]
	mov	w0, 1
	str	w0, [x19, 2048]
	str	wzr, [x19, 2048]
	mov	x0, 100
	str	wzr, [x19, 2048]
	bl	udelay
	mov	w0, w20
	bl	NandcWaitFlashReadyNoDelay
	mov	w0, 218
	str	w0, [x19, 2056]
	mov	w0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	NandcWaitFlashReady
.L159:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	flash_enter_slc_mode, .-flash_enter_slc_mode
	.section	.text.flash_exit_slc_mode,"ax",@progbits
	.align	2
	.global	flash_exit_slc_mode
	.type	flash_exit_slc_mode, %function
flash_exit_slc_mode:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w20, w0, 255
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L162
	mov	w0, w20
	bl	NandcFlashCs
	sbfiz	x1, x20, 4, 32
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x2, x0, x1
	ldr	x0, [x0, x1]
	ldrb	w19, [x2, 8]
	add	x19, x0, x19, lsl 8
	mov	w0, 239
	str	w0, [x19, 2056]
	mov	w0, 145
	str	w0, [x19, 2052]
	mov	x0, 100
	bl	udelay
	mov	w0, 2
	str	w0, [x19, 2048]
	mov	w0, 1
	str	w0, [x19, 2048]
	str	wzr, [x19, 2048]
	mov	x0, 100
	str	wzr, [x19, 2048]
	bl	udelay
	mov	w0, w20
	bl	NandcWaitFlashReadyNoDelay
	mov	w0, 223
	str	w0, [x19, 2056]
	mov	w0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	NandcWaitFlashReady
.L162:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	flash_exit_slc_mode, .-flash_exit_slc_mode
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
	adrp	x2, .LANCHOR0
	add	x2, x2, :lo12:.LANCHOR0
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
.L177:
	ldrb	w3, [x5, x7]
	ldrb	w4, [x2]
	cmp	w3, 152
	ccmp	w3, w13, 4, ne
	beq	.L168
	cmp	w3, 173
	ccmp	w3, w17, 4, ne
	bne	.L169
.L168:
	cmp	w0, 1
	ldr	x1, [x2, -8]
	bne	.L170
	cbz	w6, .L169
	ubfiz	x4, x4, 8, 8
	cmp	w3, 173
	add	x1, x1, x4
	str	w8, [x1, 2056]
	bne	.L171
	str	w0, [x1, 2052]
.L189:
	str	wzr, [x1, 2048]
	b	.L175
.L171:
	cmp	w3, 44
	bne	.L173
	str	w0, [x1, 2052]
	str	w16, [x1, 2048]
.L175:
	str	wzr, [x1, 2048]
	str	wzr, [x1, 2048]
	str	wzr, [x1, 2048]
.L169:
	add	x5, x5, 8
	add	x2, x2, 16
	cmp	x5, 32
	bne	.L177
	mov	w0, 0
	bl	NandcWaitFlashReady
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L173:
	str	w10, [x1, 2052]
	str	w0, [x1, 2048]
	b	.L175
.L170:
	cbz	w12, .L169
	ubfiz	x4, x4, 8, 8
	cmp	w3, 173
	add	x1, x1, x4
	str	w8, [x1, 2056]
	bne	.L174
	str	w11, [x1, 2052]
	str	w15, [x1, 2048]
	b	.L175
.L174:
	cmp	w3, 44
	bne	.L176
	str	w11, [x1, 2052]
	str	w14, [x1, 2048]
	b	.L175
.L176:
	str	w10, [x1, 2052]
	b	.L189
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
	adrp	x0, .LANCHOR12
	add	w1, w19, 1
	adrp	x2, .LANCHOR8
	add	x2, x2, :lo12:.LANCHOR8
	ldrb	w3, [x0, #:lo12:.LANCHOR12]
	adrp	x0, .LANCHOR10
	ldrb	w4, [x0, #:lo12:.LANCHOR10]
	mov	w0, 5
	umull	x1, w1, w0
	adrp	x0, .LANCHOR9
	add	x0, x0, :lo12:.LANCHOR9
	add	x2, x2, x1
	add	x1, x0, x1
	mov	x0, 0
.L191:
	cmp	w3, w0
	bhi	.L194
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	b	NandcWaitFlashReady
.L194:
	cmp	w4, 67
	bne	.L192
	ldrsb	w5, [x1, x0]
.L196:
	add	x0, x0, 1
	str	w5, [x20]
	b	.L191
.L192:
	ldrsb	w5, [x2, x0]
	b	.L196
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
	adrp	x2, .LANCHOR0
	add	x2, x2, :lo12:.LANCHOR0
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
.L200:
	cmp	x20, x22
	bne	.L205
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L205:
	mov	w1, 0
	mov	w4, w21
	add	x3, x29, 76
	add	x2, x29, 72
	mov	x0, x20
	bl	LogAddr2PhyAddr
	ldrb	w1, [x23]
	ldr	w0, [x29, 76]
	cmp	w1, w0
	bhi	.L201
	mov	w0, -1
	str	w0, [x20]
.L202:
	sub	w21, w21, #1
	add	x20, x20, 56
	and	w21, w21, 255
	b	.L200
.L201:
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
	adrp	x0, .LANCHOR4
	ldr	w1, [x29, 72]
	mov	w2, 0
	ldr	w0, [x0, #:lo12:.LANCHOR4]
	add	w1, w1, w0
	mov	w0, w19
	bl	FlashEraseCmd
	mov	w0, w19
	bl	NandcWaitFlashReady
	ldr	w1, [x29, 72]
	mov	w0, w19
	bl	FlashReadStatus
	tbz	x0, 0, .L203
	mov	w0, -1
	str	w0, [x20]
.L203:
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L204
	ldr	w1, [x29, 72]
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf
.L204:
	mov	w0, w19
	bl	NandcFlashDeCs
	b	.L202
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
	adrp	x1, .LANCHOR2
	stp	x21, x22, [sp, 32]
	stp	x19, x20, [sp, 16]
	mov	w22, w2
	ldrb	w1, [x1, #:lo12:.LANCHOR2]
	stp	x25, x26, [sp, 64]
	cbnz	w1, .L211
	adrp	x25, .LANCHOR23
	mov	x19, x0
	add	x26, x25, :lo12:.LANCHOR23
	mov	w20, 0
.L212:
	cmp	w20, w22
	adrp	x13, .LANCHOR25
	bcc	.L221
	adrp	x21, .LANCHOR15
	adrp	x23, .LANCHOR23
	add	x25, x13, :lo12:.LANCHOR25
	add	x21, x21, :lo12:.LANCHOR15
	add	x23, x23, :lo12:.LANCHOR23
	mov	x20, 0
.L222:
	ldrb	w0, [x25]
	cmp	w0, w20
	bhi	.L224
	adrp	x0, .LANCHOR28
	ldr	w0, [x0, #:lo12:.LANCHOR28]
	cbnz	w0, .L225
.L226:
	mov	w0, 0
	b	.L210
.L211:
	mov	w1, w2
	bl	FlashEraseSLc2KBlocks
.L210:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L221:
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
	bhi	.L214
	mov	w0, -1
	str	w0, [x19, x12]
.L215:
	add	w20, w20, 1
	b	.L212
.L214:
	adrp	x1, .LANCHOR27
	add	x2, x25, :lo12:.LANCHOR23
	mov	x3, 24
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
	cmp	w1, 0
	uxtw	x1, w0
	csel	w23, w23, wzr, ne
	madd	x1, x1, x3, x2
	ldr	x1, [x1, 8]
	cbz	x1, .L217
	bl	FlashWaitCmdDone
.L217:
	ldp	w2, w1, [x29, 88]
	mov	x0, 24
	madd	x0, x1, x0, x26
	str	w2, [x0, 4]
	stp	x21, xzr, [x0, 8]
	cbz	w23, .L218
	add	w2, w20, 1
	mov	w3, 56
	umaddl	x2, w2, w3, x19
	str	x2, [x0, 16]
.L218:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w21, [x0, x1]
	mov	x0, 24
	mul	x1, x1, x0
	mov	w0, w21
	strb	w21, [x26, x1]
	bl	NandcFlashCs
	cmp	w24, 1
	bne	.L219
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L219
	mov	w0, w21
	bl	flash_enter_slc_mode
.L220:
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
	b	.L215
.L219:
	mov	w0, w21
	bl	flash_exit_slc_mode
	b	.L220
.L224:
	mov	w0, w20
	bl	FlashWaitCmdDone
	cmp	w24, 1
	bne	.L223
	ldrb	w0, [x21]
	cbz	w0, .L223
	mov	x0, 24
	mul	x0, x20, x0
	ldrb	w0, [x0, x23]
	bl	flash_exit_slc_mode
.L223:
	add	x20, x20, 1
	b	.L222
.L225:
	adrp	x0, .LANCHOR22
	ldrb	w0, [x0, #:lo12:.LANCHOR22]
	cmp	w0, 69
	bne	.L226
	mov	w0, 56
	umaddl	x22, w22, w0, x19
.L227:
	cmp	x22, x19
	beq	.L226
	str	wzr, [x19], 56
	b	.L227
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
	adrp	x0, .LANCHOR0
	sbfiz	x1, x22, 4, 32
	add	x0, x0, :lo12:.LANCHOR0
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
	bne	.L243
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
.L246:
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
.L243:
	str	w4, [x19, 2052]
	str	w3, [x19, 2052]
	str	w1, [x19, 2052]
	str	w0, [x19, 2056]
	b	.L246
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
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	cbz	w0, .L248
	mov	w0, 0
	bl	flash_enter_slc_mode
.L249:
	adrp	x19, .LANCHOR30
	ldrb	w0, [x19, #:lo12:.LANCHOR30]
	cbz	w0, .L250
	adrp	x0, .LANCHOR24
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	tbz	x0, 0, .L250
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
	strb	wzr, [x19, #:lo12:.LANCHOR30]
.L250:
	adrp	x0, .LANCHOR0
	ldr	x0, [x0, #:lo12:.LANCHOR0]
	str	wzr, [x0, 336]
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L248:
	mov	w0, 0
	bl	flash_exit_slc_mode
	b	.L249
	.size	FlashDeInit, .-FlashDeInit
	.section	.text.NandcRandmzSel,"ax",@progbits
	.align	2
	.global	NandcRandmzSel
	.type	NandcRandmzSel, %function
NandcRandmzSel:
	ubfiz	x0, x0, 4, 8
	adrp	x2, .LANCHOR0
	add	x2, x2, :lo12:.LANCHOR0
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
	bhi	.L260
	ldr	x0, [x1, #:lo12:.LANCHOR19]
	mov	w1, 4193
.L263:
	str	w1, [x0, 4]
	ret
.L260:
	cmp	w0, 99
	ldr	x0, [x1, #:lo12:.LANCHOR19]
	bls	.L262
	mov	w1, 8322
	b	.L263
.L262:
	mov	w1, 4225
	b	.L263
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
	bne	.L266
.L269:
	and	w1, w1, -17
.L267:
	orr	w1, w1, 1
	str	w1, [x2, 12]
	ret
.L266:
	cmp	w0, 24
	bne	.L268
	orr	w1, w1, 16
	b	.L267
.L268:
	orr	w1, w1, 262144
	cmp	w0, 40
	orr	w1, w1, 16
	bne	.L267
	b	.L269
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
.L283:
	ldr	w1, [x0, 8]
	str	w1, [sp, 8]
	ldr	w1, [sp, 8]
	tbz	x1, 20, .L283
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
	adrp	x1, .LANCHOR0
	add	x1, x1, :lo12:.LANCHOR0
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
	bls	.L288
	ldr	w0, [x21, 16]
	cmp	x5, 0
	str	w0, [x29, 88]
	ccmp	x4, 0, 0, eq
	ldr	w0, [x29, 88]
	and	w0, w0, -5
	str	w0, [x29, 88]
	beq	.L289
	and	w2, w2, 255
	adrp	x20, .LANCHOR35
	cbnz	w24, .L290
.L298:
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
	bne	.L299
	ldr	w0, [x29, 88]
	mov	w1, 2
	bfi	w0, w1, 3, 3
	str	w0, [x29, 88]
.L299:
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
.L289:
	ldr	w0, [x29, 88]
	str	w0, [x21, 16]
.L288:
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
.L290:
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
.L294:
	cmp	w3, w11
	bcs	.L298
	lsr	w0, w7, 2
	lsl	w0, w0, 2
	cbz	x5, .L295
	ldrh	w13, [x1]
	add	x1, x1, 4
	ldrh	w8, [x1, -2]
	orr	x8, x13, x8, lsl 16
	str	w8, [x10, x0]
.L296:
	add	w3, w3, 1
	add	w7, w7, w6
	b	.L294
.L295:
	str	w12, [x10, x0]
	b	.L296
	.size	NandcXferStart, .-NandcXferStart
	.section	.text.NandcXferComp,"ax",@progbits
	.align	2
	.global	NandcXferComp
	.type	NandcXferComp, %function
NandcXferComp:
	ubfiz	x0, x0, 4, 8
	adrp	x1, .LANCHOR0
	add	x1, x1, :lo12:.LANCHOR0
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	ldr	x3, [x1, x0]
	adrp	x0, .LANCHOR34
	ldr	w2, [x0, #:lo12:.LANCHOR34]
	cmp	w2, 3
	bls	.L327
	ldr	w0, [x3, 16]
	tbz	x0, 2, .L327
	ldr	w0, [x3, 16]
	tbz	x0, 1, .L315
	ldr	w0, [x3, 8]
	str	w0, [x29, 16]
.L310:
	ldr	w1, [x3, 28]
	ldr	w0, [x29, 16]
	ubfx	x1, x1, 16, 5
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L311
	cmp	w2, 5
	bls	.L310
	ldr	w0, [x3]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbz	x0, 13, .L310
	ldr	w0, [x29, 24]
	tbz	x0, 17, .L310
.L311:
	adrp	x0, .LANCHOR35+40
	str	wzr, [x0, #:lo12:.LANCHOR35+40]
.L306:
	ldp	x29, x30, [sp], 32
	ret
.L315:
	ldr	w0, [x3, 8]
	str	w0, [x29, 16]
	ldr	w0, [x29, 16]
	tbz	x0, 20, .L315
	adrp	x0, .LANCHOR36
	mov	x4, x0
	ldr	w1, [x0, #:lo12:.LANCHOR36]
	cbz	w1, .L316
	mov	x0, x3
	bl	NandcSendDumpDataStart
.L316:
	ldr	w0, [x4, #:lo12:.LANCHOR36]
	cbz	w0, .L311
	mov	x0, x3
	bl	NandcSendDumpDataDone
	b	.L311
.L327:
	ldr	w0, [x3, 8]
	str	w0, [x29, 16]
	ldr	w0, [x29, 16]
	tbz	x0, 20, .L327
	b	.L306
	.size	NandcXferComp, .-NandcXferComp
	.section	.text.Ftl_log2,"ax",@progbits
	.align	2
	.global	Ftl_log2
	.type	Ftl_log2, %function
Ftl_log2:
	mov	w2, 1
	mov	w1, 0
.L336:
	cmp	w2, w0
	bls	.L337
	sub	w0, w1, #1
	ret
.L337:
	add	w1, w1, 1
	lsl	w2, w2, 1
	and	w1, w1, 65535
	b	.L336
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
.L341:
	strb	w3, [x3, x7]
	add	x3, x3, 1
	cmp	x3, 32
	bne	.L341
	ldrh	w7, [x5, 20]
	ldrb	w3, [x5, 15]
	cmp	w7, w3
	bcs	.L342
	and	w13, w0, 255
	mul	w15, w0, w2
	ubfiz	w14, w13, 1, 7
	add	x1, x1, :lo12:.LANCHOR47
	mov	w7, 0
.L343:
	cmp	w7, w0
	bcs	.L345
	and	w3, w7, 255
	mov	w10, w7
	mov	w12, 0
	b	.L346
.L344:
	add	w16, w15, w10
	strb	w3, [x1, w10, uxtw]
	add	w17, w13, w3
	add	w3, w14, w3
	add	w12, w12, 1
	and	w3, w3, 255
	add	w10, w10, w0
	strb	w17, [x1, x16]
.L346:
	cmp	w12, w2
	bcc	.L344
	add	w7, w7, 1
	b	.L343
.L345:
	ubfiz	w2, w2, 1, 15
	lsr	w8, w8, 1
	strh	w2, [x4, #:lo12:.LANCHOR45]
	strh	w8, [x6, #:lo12:.LANCHOR41]
.L342:
	adrp	x1, .LANCHOR48
	adrp	x13, .LANCHOR49
	mov	w2, 5
	cmp	w11, 1
	strh	w2, [x1, #:lo12:.LANCHOR48]
	strh	wzr, [x13, #:lo12:.LANCHOR49]
	bne	.L347
	strh	w11, [x1, #:lo12:.LANCHOR48]
.L347:
	adrp	x8, .LANCHOR50
	mov	w1, 4352
	strh	w1, [x8, #:lo12:.LANCHOR50]
	adrp	x1, .LANCHOR2
	ldrb	w11, [x1, #:lo12:.LANCHOR2]
	cbz	w11, .L348
	mov	w1, 384
	strh	w1, [x8, #:lo12:.LANCHOR50]
.L348:
	ldrh	w4, [x4, #:lo12:.LANCHOR45]
	adrp	x1, .LANCHOR38
	ldrh	w3, [x6, #:lo12:.LANCHOR41]
	adrp	x7, .LANCHOR52
	ldrh	w19, [x5, 16]
	adrp	x15, .LANCHOR55
	ldrh	w10, [x5, 20]
	mul	w4, w0, w4
	ldrh	w14, [x5, 18]
	mul	w0, w0, w3
	strh	w19, [x7, #:lo12:.LANCHOR52]
	and	w4, w4, 65535
	strh	w4, [x1, #:lo12:.LANCHOR38]
	adrp	x1, .LANCHOR51
	strh	w10, [x15, #:lo12:.LANCHOR55]
	strh	w0, [x1, #:lo12:.LANCHOR51]
	mul	w1, w4, w19
	adrp	x0, .LANCHOR53
	strh	w14, [x0, #:lo12:.LANCHOR53]
	adrp	x0, .LANCHOR54
	strh	w1, [x0, #:lo12:.LANCHOR54]
	mov	w0, w10
	bl	Ftl_log2
	and	w12, w0, 65535
	adrp	x6, .LANCHOR56
	ubfiz	w2, w10, 9, 7
	ldrh	w1, [x5, 26]
	cmp	w3, 1024
	strh	w0, [x6, #:lo12:.LANCHOR56]
	adrp	x0, .LANCHOR57
	strh	w2, [x0, #:lo12:.LANCHOR57]
	adrp	x0, .LANCHOR58
	ubfx	w2, w2, 8, 8
	strh	w2, [x0, #:lo12:.LANCHOR58]
	adrp	x0, .LANCHOR59
	strh	w1, [x0, #:lo12:.LANCHOR59]
	adrp	x0, .LANCHOR43
	mul	w1, w4, w3
	str	w1, [x0, #:lo12:.LANCHOR43]
	bls	.L349
	and	w0, w3, 255
	strh	w0, [x13, #:lo12:.LANCHOR49]
.L349:
	ldrh	w0, [x13, #:lo12:.LANCHOR49]
	adrp	x1, .LANCHOR60
	sub	w0, w3, w0
	mul	w0, w0, w4
	mul	w0, w0, w10
	mul	w0, w0, w19
	asr	w0, w0, 11
	str	w0, [x1, #:lo12:.LANCHOR60]
	ldrh	w0, [x8, #:lo12:.LANCHOR50]
	mul	w1, w14, w10
	adrp	x10, .LANCHOR61
	lsl	w0, w0, 3
	sdiv	w0, w0, w1
	and	w0, w0, 65535
	cmp	w0, 4
	bls	.L350
.L366:
	strh	w0, [x10, #:lo12:.LANCHOR61]
	cbz	w11, .L352
	mov	w0, 640
	strh	w0, [x8, #:lo12:.LANCHOR50]
.L352:
	ldrh	w0, [x8, #:lo12:.LANCHOR50]
	adrp	x1, .LANCHOR62
	lsl	w3, w3, 6
	cmp	w4, 1
	adrp	x8, .LANCHOR37
	asr	w0, w0, w12
	add	w0, w0, 2
	strh	w0, [x1, #:lo12:.LANCHOR62]
	add	w0, w12, 9
	adrp	x1, .LANCHOR64
	asr	w3, w3, w0
	adrp	x0, .LANCHOR63
	strh	w3, [x0, #:lo12:.LANCHOR63]
	and	w3, w3, 65535
	mul	w0, w4, w3
	add	w3, w3, 8
	str	w0, [x1, #:lo12:.LANCHOR64]
	ldrh	w0, [x10, #:lo12:.LANCHOR61]
	udiv	w0, w0, w4
	mov	x4, x1
	add	w3, w0, w3
	beq	.L353
.L367:
	str	w3, [x8, #:lo12:.LANCHOR37]
	ldrh	w0, [x8, #:lo12:.LANCHOR37]
	bl	FtlSysBlkNumInit
	ldr	w1, [x8, #:lo12:.LANCHOR37]
	adrp	x0, .LANCHOR65
	mov	w2, 24
	str	w1, [x0, #:lo12:.LANCHOR65]
	adrp	x0, .LANCHOR42
	ldrh	w1, [x7, #:lo12:.LANCHOR52]
	ldr	w0, [x0, #:lo12:.LANCHOR42]
	lsl	w0, w0, 2
	mul	w0, w0, w1
	ldrh	w1, [x6, #:lo12:.LANCHOR56]
	adrp	x6, .LANCHOR15
	add	w1, w1, 9
	ldrb	w6, [x6, #:lo12:.LANCHOR15]
	lsr	w0, w0, w1
	adrp	x1, .LANCHOR66
	add	w0, w0, 2
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR66]
	adrp	x1, .LANCHOR67
	strh	w2, [x1, #:lo12:.LANCHOR67]
	adrp	x1, .LANCHOR68
	ldrh	w2, [x10, #:lo12:.LANCHOR61]
	str	wzr, [x1, #:lo12:.LANCHOR68]
	add	w1, w2, 3
	strh	w1, [x10, #:lo12:.LANCHOR61]
	ldr	w1, [x4, #:lo12:.LANCHOR64]
	add	w3, w1, 3
	str	w3, [x4, #:lo12:.LANCHOR64]
	cbz	w6, .L355
	add	w1, w1, 5
	add	w2, w2, 4
	strh	w2, [x10, #:lo12:.LANCHOR61]
.L368:
	str	w1, [x4, #:lo12:.LANCHOR64]
.L356:
	adrp	x1, .LANCHOR40
	adrp	x3, .LANCHOR69
	ldrh	w1, [x1, #:lo12:.LANCHOR40]
	strh	wzr, [x3, #:lo12:.LANCHOR69]
	lsl	w2, w1, 1
	lsr	w1, w1, 3
	add	w2, w2, 48
	add	w1, w1, 4
	add	w0, w2, w0, lsl 2
	add	w0, w0, w1
	ldrh	w1, [x15, #:lo12:.LANCHOR55]
	cmp	w0, w1, lsl 9
	bcs	.L357
	mov	w0, 1
	strh	w0, [x3, #:lo12:.LANCHOR69]
.L357:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L350:
	mov	w0, 4
	b	.L366
.L353:
	add	w3, w3, 4
	b	.L367
.L355:
	cmp	w3, 7
	bhi	.L356
	mov	w1, 8
	b	.L368
	.size	FtlConstantsInit, .-FtlConstantsInit
	.section	.text.IsBlkInVendorPart,"ax",@progbits
	.align	2
	.global	IsBlkInVendorPart
	.type	IsBlkInVendorPart, %function
IsBlkInVendorPart:
	adrp	x1, .LANCHOR70
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR70]
	cbz	w1, .L373
	adrp	x1, .LANCHOR61
	ldrh	w2, [x1, #:lo12:.LANCHOR61]
	adrp	x1, .LANCHOR71
	ldr	x3, [x1, #:lo12:.LANCHOR71]
	mov	x1, 0
.L371:
	cmp	w2, w1, uxth
	bhi	.L372
.L373:
	mov	w0, 0
	ret
.L372:
	add	x1, x1, 1
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L371
	mov	w0, 1
	ret
	.size	IsBlkInVendorPart, .-IsBlkInVendorPart
	.section	.text.FtlGetCap,"ax",@progbits
	.align	2
	.global	FtlGetCap
	.type	FtlGetCap, %function
FtlGetCap:
	adrp	x0, .LANCHOR68
	ldr	w0, [x0, #:lo12:.LANCHOR68]
	ret
	.size	FtlGetCap, .-FtlGetCap
	.section	.text.FtlGetCapacity,"ax",@progbits
	.align	2
	.global	FtlGetCapacity
	.type	FtlGetCapacity, %function
FtlGetCapacity:
	adrp	x0, .LANCHOR68
	ldr	w0, [x0, #:lo12:.LANCHOR68]
	ret
	.size	FtlGetCapacity, .-FtlGetCapacity
	.section	.text.ftl_get_density,"ax",@progbits
	.align	2
	.global	ftl_get_density
	.type	ftl_get_density, %function
ftl_get_density:
	adrp	x0, .LANCHOR68
	ldr	w0, [x0, #:lo12:.LANCHOR68]
	ret
	.size	ftl_get_density, .-ftl_get_density
	.section	.text.FtlGetLpn,"ax",@progbits
	.align	2
	.global	FtlGetLpn
	.type	FtlGetLpn, %function
FtlGetLpn:
	adrp	x0, .LANCHOR72
	ldr	w0, [x0, #:lo12:.LANCHOR72]
	ret
	.size	FtlGetLpn, .-FtlGetLpn
	.section	.text.FtlGetCurEraseBlock,"ax",@progbits
	.align	2
	.global	FtlGetCurEraseBlock
	.type	FtlGetCurEraseBlock, %function
FtlGetCurEraseBlock:
	adrp	x0, .LANCHOR38
	ldrh	w1, [x0, #:lo12:.LANCHOR38]
	adrp	x0, .LANCHOR73
	ldr	w0, [x0, #:lo12:.LANCHOR73]
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
	adrp	x19, .LANCHOR74
	add	x19, x19, :lo12:.LANCHOR74
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
	adrp	x1, .LANCHOR74
	add	x1, x1, :lo12:.LANCHOR74
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
	bls	.L389
	sub	w1, w0, w1
	cmp	w1, w2
	cset	w0, ls
	ret
.L389:
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
	adrp	x0, .LANCHOR75+6
	ldrh	w0, [x0, #:lo12:.LANCHOR75+6]
	cmp	w0, 0
	cset	w0, eq
	ret
	.size	FtlFreeSysBlkQueueEmpty, .-FtlFreeSysBlkQueueEmpty
	.section	.text.FtlFreeSysBlkQueueFull,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueFull
	.type	FtlFreeSysBlkQueueFull, %function
FtlFreeSysBlkQueueFull:
	adrp	x0, .LANCHOR75+6
	ldrh	w0, [x0, #:lo12:.LANCHOR75+6]
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
	bcc	.L393
	adrp	x0, .LANCHOR75
	add	x2, x0, :lo12:.LANCHOR75
	mov	x19, x0
	ldrh	w2, [x2, 6]
	cmp	w2, 1024
	beq	.L393
	and	w1, w1, 65535
	cbz	w1, .L395
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbnz	w0, .L395
	mov	w0, w20
	bl	P2V_block_in_plane
	and	w21, w0, 65535
	adrp	x0, .LANCHOR77
	lsl	w1, w20, 10
	mov	w2, 1
	ldr	x0, [x0, #:lo12:.LANCHOR77]
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
	adrp	x1, .LANCHOR78
	ubfiz	x0, x21, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR78]
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	adrp	x1, .LANCHOR79
	ldr	w0, [x1, #:lo12:.LANCHOR79]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR79]
.L395:
	add	x0, x19, :lo12:.LANCHOR75
	ldrh	w1, [x0, 6]
	add	w1, w1, 1
	strh	w1, [x0, 6]
	ldrh	w1, [x0, 4]
	add	x2, x0, x1, sxtw 1
	add	w1, w1, 1
	and	w1, w1, 1023
	strh	w1, [x0, 4]
	strh	w20, [x2, 8]
.L393:
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
	adrp	x0, .LANCHOR75
	add	x1, x0, :lo12:.LANCHOR75
	ldrh	w2, [x1, 6]
	cbz	w2, .L403
	adrp	x2, .LANCHOR80+28
	ldrh	w3, [x1, 2]
	mov	w6, 0
	mov	w4, 0
	ldrh	w5, [x2, #:lo12:.LANCHOR80+28]
	ldrh	w2, [x1, 4]
	and	w5, w5, 31
.L405:
	cmp	w5, w4
	bgt	.L406
	cbz	w6, .L403
	add	x0, x0, :lo12:.LANCHOR75
	strh	w3, [x0, 2]
	strh	w2, [x0, 4]
.L403:
	ret
.L406:
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
	b	.L405
	.size	FtlFreeSysBLkSort, .-FtlFreeSysBLkSort
	.section	.text.FtlFreeSysBlkQueueOut,"ax",@progbits
	.align	2
	.global	FtlFreeSysBlkQueueOut
	.type	FtlFreeSysBlkQueueOut, %function
FtlFreeSysBlkQueueOut:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR75
	add	x19, x19, :lo12:.LANCHOR75
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	adrp	x22, .LANCHOR76
	mov	x23, x19
	add	x22, x22, :lo12:.LANCHOR76
.L413:
	ldrh	w1, [x19, 6]
	cbz	w1, .L414
	ldrh	w0, [x19, 2]
	sub	w1, w1, #1
	strh	w1, [x19, 6]
	add	x2, x19, x0, sxtw 1
	add	w0, w0, 1
	and	w0, w0, 1023
	strh	w0, [x19, 2]
	ldr	w0, [x22]
	ldrh	w20, [x2, 8]
	cbnz	w0, .L415
	mov	w0, w20
	bl	P2V_block_in_plane
	adrp	x1, .LANCHOR77
	and	w21, w0, 65535
	lsl	w2, w20, 10
	mov	x24, x1
	ldr	x0, [x1, #:lo12:.LANCHOR77]
	str	w2, [x0, 4]
	adrp	x2, .LANCHOR15
	ldrb	w2, [x2, #:lo12:.LANCHOR15]
	cbz	w2, .L416
	mov	w2, 1
	mov	w1, 0
	bl	FlashEraseBlocks
.L416:
	ldr	x0, [x24, #:lo12:.LANCHOR77]
	mov	w2, 1
	mov	w1, w2
	bl	FlashEraseBlocks
	adrp	x1, .LANCHOR78
	ubfiz	x0, x21, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR78]
	ldrh	w1, [x2, x0]
	add	w1, w1, 1
	strh	w1, [x2, x0]
	adrp	x1, .LANCHOR79
	ldr	w0, [x1, #:lo12:.LANCHOR79]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR79]
.L415:
	sub	w0, w20, #1
	mov	w1, 65533
	cmp	w1, w0, uxth
	bcs	.L418
	ldrh	w2, [x23, 6]
	mov	w1, w20
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	b	.L413
.L414:
	adrp	x0, .LC3
	mov	w1, 0
	add	x0, x0, :lo12:.LC3
	bl	printf
.L417:
	b	.L417
.L418:
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
	adrp	x0, .LANCHOR81
	mov	x4, -6148914691236517206
	and	w1, w1, 65535
	ldr	x3, [x0, #:lo12:.LANCHOR81]
	movk	x4, 0xaaab, lsl 0
	mov	w5, 65535
	sub	x0, x2, x3
	asr	x0, x0, 1
	mul	x0, x0, x4
	mov	w4, 6
	and	w0, w0, 65535
.L425:
	cmp	w0, w1
	beq	.L426
	ldrh	w0, [x2]
	cmp	w0, w5
	beq	.L427
	umaddl	x2, w0, w4, x3
	b	.L425
.L426:
	mov	w0, 1
	ret
.L427:
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
	bls	.L444
	adrp	x1, .LANCHOR81
	mov	w3, 6
	ldr	x6, [x1, #:lo12:.LANCHOR81]
	umull	x13, w0, w3
	mov	w1, -1
	add	x5, x6, x13
	strh	w1, [x5, 2]
	strh	w1, [x6, x13]
	adrp	x1, .LANCHOR82
	mov	x15, x1
	ldr	x12, [x1, #:lo12:.LANCHOR82]
	cbnz	x12, .L431
	str	x5, [x1, #:lo12:.LANCHOR82]
.L444:
	mov	w0, 0
	ret
.L431:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR83
	ubfiz	x2, x0, 1, 16
	mov	x4, -6148914691236517206
	add	x29, sp, 0
	ldr	x16, [x1, #:lo12:.LANCHOR83]
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
	adrp	x4, .LANCHOR78
	ldr	x17, [x4, #:lo12:.LANCHOR78]
	and	w1, w1, 65535
	mov	x4, x12
	add	x10, x17, x2
	mov	w2, 0
.L439:
	add	w2, w2, 1
	and	w2, w2, 65535
	cmp	w14, w2
	bcc	.L430
	cmp	w1, w0
	beq	.L430
	ubfiz	x30, x1, 1, 16
	ldrh	w19, [x4, 4]
	cmp	w19, 0
	ldrh	w3, [x16, x30]
	mul	w3, w3, w19
	csel	w3, w3, w11, ne
	cmp	w7, w3
	bne	.L435
	ldrh	w19, [x17, x30]
	ldrh	w3, [x10]
	cmp	w19, w3
	bcc	.L437
.L436:
	strh	w1, [x6, x13]
	cmp	x4, x12
	ldrh	w1, [x4, 2]
	strh	w1, [x5, 2]
	bne	.L440
	strh	w0, [x4, 2]
	str	x5, [x15, #:lo12:.LANCHOR82]
	b	.L430
.L435:
	bcc	.L436
.L437:
	ldrh	w3, [x4]
	cmp	w3, w20
	bne	.L438
	strh	w1, [x5, 2]
	strh	w0, [x4]
	adrp	x0, .LANCHOR84
	str	x5, [x0, #:lo12:.LANCHOR84]
.L430:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L438:
	umaddl	x4, w3, w8, x6
	mov	w1, w3
	b	.L439
.L440:
	ldrh	w1, [x4, 2]
	mov	w2, 6
	umull	x1, w1, w2
	strh	w0, [x6, x1]
	strh	w0, [x4, 2]
	b	.L430
	.size	insert_data_list, .-insert_data_list
	.section	.text.INSERT_DATA_LIST,"ax",@progbits
	.align	2
	.global	INSERT_DATA_LIST
	.type	INSERT_DATA_LIST, %function
INSERT_DATA_LIST:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	insert_data_list
	adrp	x1, .LANCHOR85
	ldrh	w0, [x1, #:lo12:.LANCHOR85]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR85]
	adrp	x1, .LANCHOR40
	ldrh	w1, [x1, #:lo12:.LANCHOR40]
	cmp	w1, w0
	bcs	.L446
	mov	w2, 210
	adrp	x1, .LANCHOR86
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR86
	add	x0, x0, :lo12:.LC5
	bl	printf
	ldp	x29, x30, [sp], 16
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	b	printf
.L446:
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
	beq	.L450
	adrp	x1, .LANCHOR81
	mov	w6, 6
	ldr	x3, [x1, #:lo12:.LANCHOR81]
	umull	x8, w0, w6
	mov	w1, -1
	add	x4, x3, x8
	strh	w1, [x4, 2]
	strh	w1, [x3, x8]
	adrp	x1, .LANCHOR87
	mov	x12, x1
	ldr	x5, [x1, #:lo12:.LANCHOR87]
	cbnz	x5, .L451
	str	x4, [x1, #:lo12:.LANCHOR87]
.L450:
	mov	w0, 0
	ret
.L451:
	adrp	x1, .LANCHOR78
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	ldr	x11, [x1, #:lo12:.LANCHOR78]
	ubfiz	x1, x0, 1, 16
	ldrh	w13, [x11, x1]
	sub	x1, x5, x3
	asr	x1, x1, 1
	mul	x1, x1, x2
	mov	x2, x5
	and	w1, w1, 65535
.L454:
	ubfiz	x10, x1, 1, 16
	ldrh	w10, [x11, x10]
	cmp	w10, w13
	bcs	.L452
	ldrh	w10, [x2]
	cmp	w10, w7
	bne	.L453
	strh	w1, [x4, 2]
	strh	w0, [x2]
	b	.L450
.L453:
	umaddl	x2, w10, w6, x3
	mov	w1, w10
	b	.L454
.L452:
	ldrh	w6, [x2, 2]
	cmp	x2, x5
	strh	w6, [x4, 2]
	strh	w1, [x3, x8]
	bne	.L455
	strh	w0, [x2, 2]
	str	x4, [x12, #:lo12:.LANCHOR87]
	b	.L450
.L455:
	ldrh	w1, [x2, 2]
	mov	w4, 6
	umull	x1, w1, w4
	strh	w0, [x3, x1]
	strh	w0, [x2, 2]
	b	.L450
	.size	insert_free_list, .-insert_free_list
	.section	.text.INSERT_FREE_LIST,"ax",@progbits
	.align	2
	.global	INSERT_FREE_LIST
	.type	INSERT_FREE_LIST, %function
INSERT_FREE_LIST:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	insert_free_list
	adrp	x1, .LANCHOR88
	ldrh	w0, [x1, #:lo12:.LANCHOR88]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x1, #:lo12:.LANCHOR88]
	adrp	x1, .LANCHOR40
	ldrh	w1, [x1, #:lo12:.LANCHOR40]
	cmp	w1, w0
	bcs	.L456
	mov	w2, 203
	adrp	x1, .LANCHOR89
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR89
	add	x0, x0, :lo12:.LC5
	bl	printf
	ldp	x29, x30, [sp], 16
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	b	printf
.L456:
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
	adrp	x20, .LANCHOR81
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	mov	w0, 6
	str	x23, [sp, 48]
	ldr	x23, [x20, #:lo12:.LANCHOR81]
	umull	x21, w1, w0
	mov	w0, 65535
	add	x19, x23, x21
	ldrh	w1, [x19, 2]
	cmp	w1, w0
	bne	.L460
	ldr	x0, [x22]
	cmp	x19, x0
	beq	.L460
	mov	w2, 386
	adrp	x1, .LANCHOR90
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR90
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L460:
	ldr	x0, [x22]
	mov	w1, 65535
	cmp	x19, x0
	ldrh	w0, [x23, x21]
	bne	.L461
	cmp	w0, w1
	bne	.L462
	str	xzr, [x22]
.L463:
	mov	w0, -1
	strh	w0, [x23, x21]
	strh	w0, [x19, 2]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L462:
	ldr	x1, [x20, #:lo12:.LANCHOR81]
	mov	w2, 6
	umaddl	x0, w0, w2, x1
	mov	w1, -1
	str	x0, [x22]
	strh	w1, [x0, 2]
	b	.L463
.L461:
	cmp	w0, w1
	ldrh	w1, [x19, 2]
	bne	.L464
	cmp	w1, w0
	beq	.L463
	mov	w0, 6
	mov	w2, -1
	umull	x1, w1, w0
	ldr	x0, [x20, #:lo12:.LANCHOR81]
	strh	w2, [x0, x1]
	b	.L463
.L464:
	ldr	x2, [x20, #:lo12:.LANCHOR81]
	mov	w3, 6
	umaddl	x4, w0, w3, x2
	strh	w1, [x4, 2]
	ldrh	w1, [x19, 2]
	umull	x1, w1, w3
	strh	w0, [x2, x1]
	b	.L463
	.size	List_remove_node, .-List_remove_node
	.section	.text.List_pop_index_node,"ax",@progbits
	.align	2
	.global	List_pop_index_node
	.type	List_pop_index_node, %function
List_pop_index_node:
	ldr	x2, [x0]
	cbz	x2, .L472
	stp	x29, x30, [sp, -32]!
	adrp	x3, .LANCHOR81
	and	w1, w1, 65535
	mov	w4, 65535
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	w5, 6
	ldr	x19, [x3, #:lo12:.LANCHOR81]
.L468:
	cbnz	w1, .L469
.L471:
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
.L469:
	ldrh	w3, [x2]
	cmp	w3, w4
	beq	.L471
	sub	w1, w1, #1
	umaddl	x2, w3, w5, x19
	and	w1, w1, 65535
	b	.L468
.L472:
	mov	w0, 65535
	ret
	.size	List_pop_index_node, .-List_pop_index_node
	.section	.text.List_get_gc_head_node,"ax",@progbits
	.align	2
	.global	List_get_gc_head_node
	.type	List_get_gc_head_node, %function
List_get_gc_head_node:
	and	w2, w0, 65535
	adrp	x0, .LANCHOR82
	ldr	x1, [x0, #:lo12:.LANCHOR82]
	cbz	x1, .L482
	adrp	x0, .LANCHOR81
	mov	w4, 6
	ldr	x3, [x0, #:lo12:.LANCHOR81]
	mov	w0, 65535
.L479:
	cbz	w2, .L480
	ldrh	w1, [x1]
	cmp	w1, w0
	bne	.L481
	ret
.L481:
	sub	w2, w2, #1
	umaddl	x1, w1, w4, x3
	and	w2, w2, 65535
	b	.L479
.L482:
	mov	w0, 65535
	ret
.L480:
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
	adrp	x0, .LANCHOR91
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	stp	x25, x26, [sp, 64]
	cmp	w0, w19
	beq	.L485
	adrp	x0, .LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w0, w19
	beq	.L485
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w0, w19
	beq	.L485
	adrp	x0, .LANCHOR81
	mov	w21, 6
	adrp	x24, .LANCHOR82
	mov	x26, x0
	umull	x21, w19, w21
	ldr	x23, [x0, #:lo12:.LANCHOR81]
	ldr	x1, [x24, #:lo12:.LANCHOR82]
	add	x22, x23, x21
	cmp	x22, x1
	beq	.L485
	adrp	x1, .LANCHOR83
	ubfiz	x0, x19, 1, 16
	mov	x25, x1
	ldr	x2, [x1, #:lo12:.LANCHOR83]
	mov	w1, 65535
	ldrh	w20, [x2, x0]
	ldrh	w0, [x22, 4]
	cmp	w0, 0
	mul	w20, w20, w0
	ldrh	w0, [x22, 2]
	csinv	w20, w20, wzr, ne
	cmp	w0, w1
	bne	.L488
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	bne	.L488
	mov	w2, 504
	adrp	x1, .LANCHOR94
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L488:
	ldrh	w0, [x22, 2]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L489
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	beq	.L485
.L489:
	mov	w1, 6
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	umull	x0, w0, w1
	asr	x1, x0, 1
	mul	x1, x1, x2
	ldr	x2, [x25, #:lo12:.LANCHOR83]
	ldrh	w1, [x2, x1, lsl 1]
	ldr	x2, [x26, #:lo12:.LANCHOR81]
	add	x0, x2, x0
	ldrh	w2, [x0, 4]
	cmp	w2, 0
	mul	w0, w1, w2
	csinv	w0, w0, wzr, ne
	cmp	w20, w0
	bcs	.L485
	adrp	x20, .LANCHOR85
	mov	w1, w19
	add	x0, x24, :lo12:.LANCHOR82
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR85]
	cbnz	w0, .L491
	mov	w2, 515
	adrp	x1, .LANCHOR94
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR94
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L491:
	ldrh	w0, [x20, #:lo12:.LANCHOR85]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR85]
	mov	w0, w19
	bl	INSERT_DATA_LIST
.L485:
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
.L496:
	cmp	w20, w1
	beq	.L500
	mov	x21, x0
	ldrh	w2, [x0], 2
	cbnz	w2, .L497
	bl	FtlFreeSysBlkQueueOut
	and	w1, w0, 65535
	strh	w0, [x21]
	sub	w2, w1, #1
	mov	w0, 65533
	cmp	w0, w2, uxth
	bcs	.L498
	adrp	x0, .LANCHOR75+6
	ldrh	w2, [x0, #:lo12:.LANCHOR75+6]
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
.L499:
	b	.L499
.L498:
	ldr	w0, [x19, 48]
	strh	wzr, [x19, 2]
	add	w0, w0, 1
	str	w0, [x19, 48]
	ldrh	w0, [x19, 8]
	strh	w20, [x19]
	add	w0, w0, 1
	strh	w0, [x19, 8]
.L500:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L502
	mov	w2, 629
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
.L502:
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L497:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L496
	.size	ftl_map_blk_alloc_new_blk, .-ftl_map_blk_alloc_new_blk
	.section	.text.select_l2p_ram_region,"ax",@progbits
	.align	2
	.global	select_l2p_ram_region
	.type	select_l2p_ram_region, %function
select_l2p_ram_region:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR67
	mov	x1, 0
	mov	w3, 65535
	add	x29, sp, 0
	ldrh	w2, [x0, #:lo12:.LANCHOR67]
	adrp	x0, .LANCHOR96
	str	x19, [sp, 16]
	ldr	x0, [x0, #:lo12:.LANCHOR96]
.L505:
	and	w19, w1, 65535
	cmp	w19, w2
	bcc	.L507
	add	x3, x0, 4
	mov	w19, w2
	mov	w5, -2147483648
	mov	w1, 0
.L508:
	cmp	w1, w2
	bne	.L510
	cmp	w19, w2
	bcc	.L506
	adrp	x1, .LANCHOR97
	mov	w19, w2
	mov	w3, -1
	ldrh	w4, [x1, #:lo12:.LANCHOR97]
	mov	w1, 0
.L511:
	cmp	w1, w2
	bne	.L513
	cmp	w19, w1
	bcc	.L506
	mov	w2, 859
	adrp	x1, .LANCHOR98
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR98
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
	b	.L506
.L507:
	add	x1, x1, 1
	add	x4, x0, x1, lsl 4
	ldrh	w4, [x4, -16]
	cmp	w4, w3
	bne	.L505
.L506:
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L510:
	ldr	w4, [x3]
	tbnz	w4, #31, .L509
	cmp	w5, w4
	bls	.L509
	mov	w5, w4
	mov	w19, w1
.L509:
	add	w1, w1, 1
	add	x3, x3, 16
	and	w1, w1, 65535
	b	.L508
.L513:
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bls	.L512
	ldrh	w5, [x0]
	cmp	w5, w4
	csel	w3, w3, w6, eq
	csel	w19, w19, w1, eq
.L512:
	add	w1, w1, 1
	add	x0, x0, 16
	and	w1, w1, 65535
	b	.L511
	.size	select_l2p_ram_region, .-select_l2p_ram_region
	.section	.text.FtlUpdateVaildLpn,"ax",@progbits
	.align	2
	.global	FtlUpdateVaildLpn
	.type	FtlUpdateVaildLpn, %function
FtlUpdateVaildLpn:
	adrp	x2, .LANCHOR99
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR99]
	cmp	w1, 4
	bhi	.L516
	cbnz	w0, .L516
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR99]
	ret
.L516:
	adrp	x1, .LANCHOR40
	adrp	x0, .LANCHOR100
	strh	wzr, [x3, #:lo12:.LANCHOR99]
	mov	w2, 0
	ldrh	w5, [x1, #:lo12:.LANCHOR40]
	adrp	x1, .LANCHOR83
	str	wzr, [x0, #:lo12:.LANCHOR100]
	mov	w3, 0
	ldr	x6, [x1, #:lo12:.LANCHOR83]
	mov	w7, 65535
	mov	x1, 0
.L517:
	cmp	w5, w1, uxth
	bhi	.L519
	cbz	w3, .L515
	str	w2, [x0, #:lo12:.LANCHOR100]
.L515:
	ret
.L519:
	ldrh	w4, [x6, x1, lsl 1]
	cmp	w4, w7
	beq	.L518
	add	w2, w2, w4
	mov	w3, 1
.L518:
	add	x1, x1, 1
	b	.L517
	.size	FtlUpdateVaildLpn, .-FtlUpdateVaildLpn
	.section	.text.ftl_set_blk_mode,"ax",@progbits
	.align	2
	.global	ftl_set_blk_mode
	.type	ftl_set_blk_mode, %function
ftl_set_blk_mode:
	and	w0, w0, 65535
	cbz	w1, .L526
	b	ftl_set_blk_mode.part.10
.L526:
	adrp	x1, .LANCHOR1
	ubfx	x2, x0, 5, 11
	lsl	x2, x2, 2
	ldr	x3, [x1, #:lo12:.LANCHOR1]
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
	adrp	x1, .LANCHOR1
	and	w0, w0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR1]
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
.L529:
	cmp	w2, w3
	bcc	.L531
	adrp	x1, .LANCHOR52
	ubfiz	x3, x3, 1, 16
	add	x3, x3, 16
	add	x2, x0, 16
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	add	x3, x0, x3
	mov	w5, 65535
	sub	w1, w1, #1
	and	w1, w1, 65535
	sub	w1, w1, w6
.L532:
	cmp	x2, x3
	bne	.L534
	ret
.L531:
	ldrh	w5, [x4]
	cmp	w5, w1
	beq	.L530
	ldrh	w5, [x0, 4]
	add	w5, w5, 1
	strh	w5, [x0, 4]
.L530:
	add	w2, w2, 1
	add	x4, x4, 2
	and	w2, w2, 65535
	b	.L529
.L534:
	ldrh	w4, [x2]
	cmp	w4, w5
	beq	.L533
	ldrh	w4, [x0, 4]
	add	w4, w1, w4
	strh	w4, [x0, 4]
.L533:
	add	x2, x2, 2
	b	.L532
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
	bcc	.L536
	mov	w2, 2576
	adrp	x1, .LANCHOR101
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR101
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L536:
	adrp	x0, .LANCHOR38
	adrp	x7, .LANCHOR47
	add	x6, x19, 16
	add	x7, x7, :lo12:.LANCHOR47
	ldrh	w8, [x0, #:lo12:.LANCHOR38]
	mov	x5, 0
	strh	wzr, [x19, 4]
	mov	w10, -1
	strb	wzr, [x19, 7]
.L537:
	cmp	w8, w5, uxth
	bhi	.L539
	adrp	x1, .LANCHOR52
	ldrb	w0, [x19, 7]
	strb	wzr, [x19, 9]
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	mul	w0, w0, w1
	strh	w0, [x19, 4]
	adrp	x0, .LANCHOR28
	ldr	w0, [x0, #:lo12:.LANCHOR28]
	cbz	w0, .L540
	adrp	x0, .LANCHOR78
	ldrh	w1, [x19]
	ldr	x0, [x0, #:lo12:.LANCHOR78]
	ldrh	w0, [x0, x1, lsl 1]
	cmp	w0, 79
	bhi	.L540
	mov	w0, 1
	strb	w0, [x19, 9]
.L540:
	adrp	x0, .LANCHOR2
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	cbz	w0, .L541
	mov	w0, 1
	strb	w0, [x19, 9]
.L541:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L539:
	ldrh	w1, [x19]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	mov	w4, w0
	strh	w10, [x6]
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L538
	strh	w4, [x6]
	ldrb	w0, [x19, 7]
	add	w0, w0, 1
	strb	w0, [x19, 7]
.L538:
	add	x5, x5, 1
	add	x6, x6, 2
	b	.L537
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
	adrp	x0, .LANCHOR52
	mov	w5, 0
	add	x8, x8, :lo12:.LANCHOR47
	ldrh	w11, [x0, #:lo12:.LANCHOR52]
	cmp	w10, w7, uxth
	bhi	.L561
	cbz	w5, .L559
	mov	w0, 32768
	sdiv	w5, w0, w5
.L560:
	adrp	x0, .LANCHOR81
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR81]
	umaddl	x6, w6, w1, x0
	mov	w0, 0
	strh	w5, [x6, 4]
	ret
.L554:
	mov	w5, 0
	b	.L553
.L559:
	mov	w5, 0
	b	.L560
.L561:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L552:
	ldrb	w0, [x8, x7]
	mov	w1, w6
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L551
	add	w5, w5, w11
	and	w5, w5, 65535
.L551:
	add	x7, x7, 1
	cmp	w10, w7, uxth
	bhi	.L552
	cbz	w5, .L554
	mov	w0, 32768
	sdiv	w5, w0, w5
.L553:
	adrp	x0, .LANCHOR81
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR81]
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
	adrp	x0, .LANCHOR87
	ldr	x0, [x0, #:lo12:.LANCHOR87]
	cbz	x0, .L564
	adrp	x1, .LANCHOR81
	ldr	x1, [x1, #:lo12:.LANCHOR81]
	sub	x0, x0, x1
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	adrp	x1, .LANCHOR78
	ldr	x1, [x1, #:lo12:.LANCHOR78]
	and	x0, x0, 65535
	ldrh	w0, [x1, x0, lsl 1]
	ret
.L564:
	mov	w0, 0
	ret
	.size	GetFreeBlockMinEraseCount, .-GetFreeBlockMinEraseCount
	.section	.text.GetFreeBlockMaxEraseCount,"ax",@progbits
	.align	2
	.global	GetFreeBlockMaxEraseCount
	.type	GetFreeBlockMaxEraseCount, %function
GetFreeBlockMaxEraseCount:
	adrp	x1, .LANCHOR87
	and	w0, w0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR87]
	cbz	x1, .L572
	adrp	x2, .LANCHOR88
	mov	w3, 7
	mov	w5, 6
	mov	w6, 65535
	ldrh	w2, [x2, #:lo12:.LANCHOR88]
	mul	w2, w2, w3
	asr	w2, w2, 3
	cmp	w0, w2
	csel	w0, w2, w0, gt
	adrp	x2, .LANCHOR81
	ldr	x3, [x2, #:lo12:.LANCHOR81]
	mov	x2, -6148914691236517206
	movk	x2, 0xaaab, lsl 0
	sub	x1, x1, x3
	asr	x1, x1, 1
	mul	x1, x1, x2
	mov	w2, 0
	and	w1, w1, 65535
.L568:
	cmp	w0, w2
	beq	.L571
	umull	x4, w1, w5
	ldrh	w4, [x3, x4]
	cmp	w4, w6
	bne	.L569
.L571:
	adrp	x0, .LANCHOR78
	ubfiz	x1, x1, 1, 16
	ldr	x0, [x0, #:lo12:.LANCHOR78]
	ldrh	w0, [x0, x1]
	ret
.L569:
	add	w2, w2, 1
	mov	w1, w4
	and	w2, w2, 65535
	b	.L568
.L572:
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
	beq	.L576
	stp	x29, x30, [sp, -16]!
	adrp	x2, .LANCHOR83
	ubfiz	x1, x0, 1, 16
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR83]
	strh	wzr, [x2, x1]
	bl	INSERT_FREE_LIST
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L576:
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
	adrp	x1, .LANCHOR57
	str	wzr, [x0, #:lo12:.LANCHOR102]
	adrp	x0, .LANCHOR38
	ldrh	w10, [x1, #:lo12:.LANCHOR57]
	adrp	x1, .LANCHOR58
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	mov	w8, 24
	ldrh	w11, [x1, #:lo12:.LANCHOR58]
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
.L580:
	add	w13, w2, w10
	add	w12, w1, w11
	cmp	x3, x8
	bne	.L581
	adrp	x1, .LANCHOR107
	ldr	x7, [x7, #:lo12:.LANCHOR104]
	ldr	x6, [x6, #:lo12:.LANCHOR105]
	mov	w8, 24
	ldr	w4, [x1, #:lo12:.LANCHOR107]
.L582:
	cmp	w0, w4
	bcc	.L583
	ret
.L581:
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
	b	.L580
.L583:
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
	b	.L582
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
.L585:
	cmp	w3, w1
	bcs	.L584
	umaddl	x6, w3, w7, x0
	mov	w2, 0
	b	.L590
.L586:
	add	w2, w2, 1
	and	w2, w2, 65535
.L590:
	cmp	w2, w8
	bcs	.L587
	umull	x5, w2, w10
	add	x11, x4, x5
	ldr	x12, [x4, x5]
	ldr	x5, [x6, 8]
	cmp	x12, x5
	bne	.L586
	str	wzr, [x11, 16]
.L587:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L585
.L584:
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
.L592:
	cmp	w3, w1
	bcs	.L591
	mov	w2, 0
	b	.L597
.L593:
	add	w2, w2, 1
	and	w2, w2, 65535
.L597:
	cmp	w2, w5
	bcs	.L594
	umaddl	x4, w2, w7, x6
	ldr	w11, [x4, 16]
	cbnz	w11, .L593
	umaddl	x2, w3, w10, x0
	ldr	x11, [x4]
	str	w8, [x4, 16]
	ldr	x4, [x4, 8]
	stp	x11, x4, [x2, 8]
.L594:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L592
.L591:
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
.L599:
	cmp	w2, w1, uxth
	bhi	.L601
	mov	w0, 0
	ret
.L601:
	add	x1, x1, 1
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L599
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
.L604:
	and	w2, w3, 65535
	cmp	w2, w1
	bcc	.L606
	bne	.L605
	and	x3, x3, 65535
	strh	w0, [x5, x3, lsl 1]
	ldrh	w0, [x4, #:lo12:.LANCHOR108]
	add	w0, w0, 1
	strh	w0, [x4, #:lo12:.LANCHOR108]
	b	.L605
.L606:
	add	x3, x3, 1
	add	x2, x5, x3, lsl 1
	ldrh	w2, [x2, -2]
	cmp	w2, w7
	bne	.L604
.L605:
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
	.section	.text.FtlGcRefreshOpenBlock,"ax",@progbits
	.align	2
	.global	FtlGcRefreshOpenBlock
	.type	FtlGcRefreshOpenBlock, %function
FtlGcRefreshOpenBlock:
	adrp	x8, .LANCHOR112
	and	w0, w0, 65535
	ldrh	w10, [x8, #:lo12:.LANCHOR112]
	cmp	w10, w0
	beq	.L609
	adrp	x6, .LANCHOR113
	ldrh	w7, [x6, #:lo12:.LANCHOR113]
	cmp	w0, w7
	beq	.L609
	adrp	x4, .LANCHOR114
	ldrh	w5, [x4, #:lo12:.LANCHOR114]
	cmp	w0, w5
	beq	.L609
	adrp	x2, .LANCHOR115
	ldrh	w3, [x2, #:lo12:.LANCHOR115]
	cmp	w0, w3
	beq	.L609
	mov	w1, 65535
	cmp	w10, w1
	bne	.L610
	strh	w0, [x8, #:lo12:.LANCHOR112]
.L609:
	mov	w0, 0
	ret
.L610:
	cmp	w7, w1
	bne	.L611
	strh	w0, [x6, #:lo12:.LANCHOR113]
	b	.L609
.L611:
	cmp	w5, w1
	bne	.L612
	strh	w0, [x4, #:lo12:.LANCHOR114]
	b	.L609
.L612:
	cmp	w3, w1
	bne	.L609
	strh	w0, [x2, #:lo12:.LANCHOR115]
	b	.L609
	.size	FtlGcRefreshOpenBlock, .-FtlGcRefreshOpenBlock
	.section	.text.FtlGcRefreshBlock,"ax",@progbits
	.align	2
	.global	FtlGcRefreshBlock
	.type	FtlGcRefreshBlock, %function
FtlGcRefreshBlock:
	adrp	x8, .LANCHOR112
	and	w0, w0, 65535
	ldrh	w10, [x8, #:lo12:.LANCHOR112]
	cmp	w10, w0
	beq	.L621
	adrp	x6, .LANCHOR113
	ldrh	w7, [x6, #:lo12:.LANCHOR113]
	cmp	w0, w7
	beq	.L621
	adrp	x4, .LANCHOR114
	ldrh	w5, [x4, #:lo12:.LANCHOR114]
	cmp	w0, w5
	beq	.L621
	adrp	x2, .LANCHOR115
	ldrh	w3, [x2, #:lo12:.LANCHOR115]
	cmp	w0, w3
	beq	.L621
	mov	w1, 65535
	cmp	w10, w1
	bne	.L615
	strh	w0, [x8, #:lo12:.LANCHOR112]
.L621:
	mov	w0, 0
	ret
.L615:
	cmp	w7, w1
	bne	.L616
	strh	w0, [x6, #:lo12:.LANCHOR113]
	b	.L621
.L616:
	cmp	w5, w1
	bne	.L617
	strh	w0, [x4, #:lo12:.LANCHOR114]
	b	.L621
.L617:
	cmp	w3, w1
	bne	.L622
	strh	w0, [x2, #:lo12:.LANCHOR115]
	b	.L621
.L622:
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
	cbz	w0, .L624
	adrp	x1, .LANCHOR78
	ubfiz	x0, x11, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR78]
	ldrh	w1, [x2, x0]
	cmp	w1, 39
	bls	.L624
	sub	w1, w1, #40
	strh	w1, [x2, x0]
.L624:
	adrp	x1, .LANCHOR116
	adrp	x3, .LANCHOR117
	add	x3, x3, :lo12:.LANCHOR117
	mov	x2, 0
	ldrh	w0, [x1, #:lo12:.LANCHOR116]
.L625:
	cmp	w0, w2, uxth
	bhi	.L627
	cmp	w0, 15
	bhi	.L626
	add	w2, w0, 1
	strh	w2, [x1, #:lo12:.LANCHOR116]
	adrp	x1, .LANCHOR117
	add	x1, x1, :lo12:.LANCHOR117
	strh	w12, [x1, w0, sxtw 1]
	b	.L626
.L627:
	add	x2, x2, 1
	add	x4, x3, x2, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w12
	bne	.L625
.L626:
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	FtlGcMarkBadPhyBlk, .-FtlGcMarkBadPhyBlk
	.section	.text.FtlGcReFreshBadBlk,"ax",@progbits
	.align	2
	.global	FtlGcReFreshBadBlk
	.type	FtlGcReFreshBadBlk, %function
FtlGcReFreshBadBlk:
	adrp	x0, .LANCHOR116
	ldrh	w0, [x0, #:lo12:.LANCHOR116]
	cbz	w0, .L639
	adrp	x1, .LANCHOR112
	ldrh	w2, [x1, #:lo12:.LANCHOR112]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L639
	stp	x29, x30, [sp, -16]!
	adrp	x11, .LANCHOR118
	add	x29, sp, 0
	ldrh	w1, [x11, #:lo12:.LANCHOR118]
	cmp	w1, w0
	bcc	.L634
	strh	wzr, [x11, #:lo12:.LANCHOR118]
.L634:
	ldrh	w1, [x11, #:lo12:.LANCHOR118]
	adrp	x0, .LANCHOR117
	add	x0, x0, :lo12:.LANCHOR117
	ldrh	w0, [x0, x1, lsl 1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	w0, [x11, #:lo12:.LANCHOR118]
	ldp	x29, x30, [sp], 16
	add	w0, w0, 1
	strh	w0, [x11, #:lo12:.LANCHOR118]
	mov	w0, 0
	ret
.L639:
	mov	w0, 0
	ret
	.size	FtlGcReFreshBadBlk, .-FtlGcReFreshBadBlk
	.section	.text.flash_boot_enter_slc_mode,"ax",@progbits
	.align	2
	.global	flash_boot_enter_slc_mode
	.type	flash_boot_enter_slc_mode, %function
flash_boot_enter_slc_mode:
	adrp	x1, .LANCHOR119
	and	w0, w0, 255
	ldr	w2, [x1, #:lo12:.LANCHOR119]
	mov	w1, 12336
	movk	w1, 0x5638, lsl 16
	cmp	w2, w1
	bne	.L642
	b	flash_enter_slc_mode
.L642:
	ret
	.size	flash_boot_enter_slc_mode, .-flash_boot_enter_slc_mode
	.section	.text.flash_boot_exit_slc_mode,"ax",@progbits
	.align	2
	.global	flash_boot_exit_slc_mode
	.type	flash_boot_exit_slc_mode, %function
flash_boot_exit_slc_mode:
	adrp	x1, .LANCHOR119
	and	w0, w0, 255
	ldr	w2, [x1, #:lo12:.LANCHOR119]
	mov	w1, 12336
	movk	w1, 0x5638, lsl 16
	cmp	w2, w1
	bne	.L644
	b	flash_exit_slc_mode
.L644:
	ret
	.size	flash_boot_exit_slc_mode, .-flash_boot_exit_slc_mode
	.section	.text.FW_FlashBlockErase.constprop.41,"ax",@progbits
	.align	2
	.type	FW_FlashBlockErase.constprop.41, %function
FW_FlashBlockErase.constprop.41:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w0
	adrp	x0, .LANCHOR18
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	ldrb	w19, [x0, 9]
	mov	w0, 0
	bl	flash_boot_enter_slc_mode
	mov	w2, 0
	mov	w0, 0
	udiv	w1, w20, w19
	bl	FlashEraseBlock
	mov	w19, w0
	mov	w0, 0
	bl	flash_boot_exit_slc_mode
	and	w0, w19, 255
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
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
	cbnz	w0, .L650
	adrp	x1, .LANCHOR16
	add	x1, x1, :lo12:.LANCHOR16
	mov	x0, 0
.L651:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 256
	bne	.L651
.L657:
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
.L652:
	cmp	w20, w0, uxth
	bhi	.L676
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L650:
	cmp	w0, 1
	bne	.L653
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
	mov	x1, 0
.L656:
	and	w0, w1, 65535
	cmp	x1, 3
	bls	.L654
	ubfiz	w3, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 2
	sub	w0, w3, w0
	and	w0, w0, 65535
.L654:
	strh	w0, [x2, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L656
	b	.L657
.L653:
	cmp	w0, 2
	bne	.L658
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
	mov	w1, 65535
	mov	x0, 0
.L660:
	cmp	x0, 2
	and	w3, w0, 65535
	csel	w3, w3, w1, cc
	strh	w3, [x2, x0, lsl 1]
	add	w1, w1, 2
	add	x0, x0, 1
	and	w1, w1, 65535
	cmp	x0, 256
	bne	.L660
	b	.L657
.L658:
	cmp	w0, 3
	bne	.L661
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
	mov	x1, 0
.L664:
	and	w0, w1, 65535
	cmp	x1, 5
	bls	.L662
	ubfiz	w3, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 4
	sub	w0, w3, w0
	and	w0, w0, 65535
.L662:
	strh	w0, [x2, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L664
	b	.L657
.L661:
	cmp	w0, 4
	bne	.L665
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
.L667:
	and	w3, w0, 1
	ubfiz	w2, w0, 1, 15
	add	w3, w3, 6
	add	w0, w0, 1
	sub	w2, w2, w3
	strh	w2, [x1], 2
	and	w0, w0, 65535
	cmp	w0, 256
	bne	.L667
	b	.L657
.L665:
	cmp	w0, 5
	bne	.L668
	adrp	x1, .LANCHOR16
	add	x1, x1, :lo12:.LANCHOR16
	mov	x0, 0
.L669:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 16
	bne	.L669
	add	x1, x1, 32
.L670:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 496
	bne	.L670
	b	.L657
.L668:
	cmp	w0, 6
	bne	.L671
	adrp	x3, .LANCHOR16
	add	x3, x3, :lo12:.LANCHOR16
	mov	w1, 0
	mov	x2, 0
	mov	w4, 12
	mov	w5, 10
.L674:
	and	w0, w2, 65535
	cmp	x2, 5
	bls	.L672
	tst	x0, 1
	csel	w0, w4, w5, ne
	sub	w0, w1, w0
	and	w0, w0, 65535
.L672:
	strh	w0, [x3, x2, lsl 1]
	add	w1, w1, 3
	and	w1, w1, 65535
	add	x2, x2, 1
	cmp	w1, 768
	bne	.L674
	b	.L657
.L671:
	cmp	w0, 9
	bne	.L657
	adrp	x1, .LANCHOR16
	add	x0, x1, :lo12:.LANCHOR16
	strh	wzr, [x1, #:lo12:.LANCHOR16]
	mov	w1, 1
	strh	w1, [x0, 2]
	mov	w1, 2
	strh	w1, [x0, 4]
	add	x1, x0, 6
	mov	w0, 3
.L675:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 509
	bne	.L675
	b	.L657
.L676:
	ldrh	w2, [x1, x0, lsl 1]
	add	x0, x0, 1
	strh	w2, [x19, w2, sxtw 1]
	b	.L652
	.size	BuildFlashLsbPageTable, .-BuildFlashLsbPageTable
	.section	.text.FlashDieInfoInit,"ax",@progbits
	.align	2
	.global	FlashDieInfoInit
	.type	FlashDieInfoInit, %function
FlashDieInfoInit:
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR31+10
	add	x29, sp, 0
	ldrh	w0, [x0, #:lo12:.LANCHOR31+10]
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR121
	str	x25, [sp, 64]
	adrp	x25, .LANCHOR25
	stp	x21, x22, [sp, 32]
	mov	x22, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR26
	strb	wzr, [x19, #:lo12:.LANCHOR121]
	add	x21, x24, :lo12:.LANCHOR26
	strb	wzr, [x25, #:lo12:.LANCHOR25]
	bl	FlashBlockAlignInit
	mov	w2, 8
	mov	w1, 0
	adrp	x23, .LANCHOR17
	mov	x0, x21
	add	x20, x23, :lo12:.LANCHOR17
	bl	ftl_memset
	mov	w2, 32
	mov	w1, 0
	mov	x0, x20
	bl	ftl_memset
	mov	w2, 192
	mov	w1, 0
	adrp	x0, .LANCHOR23
	add	x0, x0, :lo12:.LANCHOR23
	bl	ftl_memset
	adrp	x0, .LANCHOR18
	adrp	x13, .LANCHOR22
	add	x15, x25, :lo12:.LANCHOR25
	add	x10, x13, :lo12:.LANCHOR22
	ldr	x7, [x0, #:lo12:.LANCHOR18]
	add	x11, x7, 1
	ldrb	w12, [x7]
.L694:
	mov	w2, w12
	add	x1, x10, x22, lsl 3
	mov	x0, x11
	bl	FlashMemCmp8
	cbnz	w0, .L693
	ldrb	w1, [x15]
	add	w0, w1, 1
	strb	w0, [x15]
	str	wzr, [x20, x1, lsl 2]
	strb	w22, [x21, x1]
.L693:
	add	x22, x22, 1
	cmp	x22, 4
	bne	.L694
	ldrb	w0, [x25, #:lo12:.LANCHOR25]
	strb	w0, [x19, #:lo12:.LANCHOR121]
	ldrb	w0, [x7, 8]
	cmp	w0, 2
	beq	.L695
.L699:
	ldrb	w0, [x25, #:lo12:.LANCHOR25]
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
.L695:
	adrp	x0, .LANCHOR4
	add	x13, x13, :lo12:.LANCHOR22
	add	x15, x25, :lo12:.LANCHOR25
	add	x23, x23, :lo12:.LANCHOR17
	ldr	w20, [x0, #:lo12:.LANCHOR4]
	add	x14, x24, :lo12:.LANCHOR26
	mov	x19, 0
.L698:
	mov	w2, w12
	add	x1, x13, x19, lsl 3
	mov	x0, x11
	bl	FlashMemCmp8
	cbnz	w0, .L696
	ldrb	w2, [x7, 13]
	ldrh	w0, [x7, 14]
	ldrb	w1, [x15]
	and	w0, w0, 65280
	mul	w2, w2, w20
	mul	w0, w0, w2
	sxtw	x2, w1
	str	w0, [x23, x2, lsl 2]
	ldrb	w3, [x7, 23]
	cbz	w3, .L697
	lsl	w0, w0, 1
	str	w0, [x23, x2, lsl 2]
.L697:
	add	w1, w1, 1
	strb	w19, [x14, x2]
	strb	w1, [x15]
.L696:
	add	x19, x19, 1
	cmp	x19, 4
	bne	.L698
	b	.L699
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
	adrp	x3, .LANCHOR68
	mov	w4, 1
	ldr	x1, [x0, #:lo12:.LANCHOR18]
	adrp	x0, .LANCHOR4
	ldr	w0, [x0, #:lo12:.LANCHOR4]
	ldrb	w2, [x1, 9]
	mul	w0, w0, w2
	strb	w0, [x19, 4]
	ubfx	x0, x0, 8, 8
	strb	w0, [x19, 5]
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	strb	w0, [x19, 7]
	add	x0, x3, :lo12:.LANCHOR68
	ldrb	w3, [x3, #:lo12:.LANCHOR68]
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
.L708:
	cmp	w3, w1, uxtb
	bhi	.L709
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L709:
	ldrb	w0, [x1, x2]
	add	x1, x1, 1
	ldrb	w5, [x19, 10]
	lsl	w0, w4, w0
	orr	w0, w0, w5
	strb	w0, [x19, 10]
	b	.L708
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
.L714:
	ldrh	w0, [x21, x19]
	cmp	w0, w24
	beq	.L711
	ldrh	w1, [x22]
	cmp	w1, w0
	bhi	.L713
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
.L713:
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
	bne	.L714
.L711:
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
	adrp	x1, .LANCHOR74
	add	x0, x1, :lo12:.LANCHOR74
	mov	w2, -1
	add	x0, x0, 12
	strh	w2, [x1, #:lo12:.LANCHOR74]
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
	adrp	x1, .LANCHOR75
	add	x3, x1, :lo12:.LANCHOR75
	mov	w2, 2048
	add	x29, sp, 0
	strh	w0, [x1, #:lo12:.LANCHOR75]
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
.L722:
	ldrh	w1, [x19, 6]
	cmp	w1, w0
	bhi	.L726
	adrp	x0, .LANCHOR53
	mov	w23, 0
	mov	w20, 0
	ldrh	w1, [x0, #:lo12:.LANCHOR53]
	ldrh	w0, [x19]
	strh	w1, [x21, x0, lsl 1]
	ldrh	w24, [x21]
.L727:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L731
	mov	w0, w23
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L726:
	ubfiz	x1, x0, 2, 16
	ldr	w2, [x20, x1]
	mov	w1, 0
	ubfx	x2, x2, 10, 16
.L723:
	ldrh	w3, [x19, 10]
	cmp	w3, w1
	bhi	.L725
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L722
.L725:
	ubfiz	x3, x1, 1, 16
	ldrh	w4, [x22, x3]
	cmp	w4, w2
	bne	.L724
	cbz	w2, .L724
	ldrh	w4, [x21, x3]
	add	w4, w4, 1
	strh	w4, [x21, x3]
.L724:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L723
.L731:
	ubfiz	x0, x20, 1, 16
	ldrh	w1, [x21, x0]
	cmp	w24, w1
	bls	.L728
	add	x25, x22, x0
	ldrh	w0, [x22, x0]
	cbnz	w0, .L729
.L730:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L727
.L728:
	cbnz	w1, .L730
	add	x25, x22, x0
	ldrh	w0, [x22, x0]
	cbz	w0, .L730
.L732:
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
	strh	wzr, [x25]
	ldrh	w0, [x19, 8]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	b	.L730
.L733:
	mov	w24, 0
	b	.L732
.L729:
	mov	w23, w20
	cbz	w1, .L733
	mov	w24, w1
	b	.L730
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
	adrp	x20, .LANCHOR64
	stp	x21, x22, [sp, 32]
	ldr	x0, [x19, #:lo12:.LANCHOR125]
	adrp	x22, .LANCHOR57
	ldr	w2, [x20, #:lo12:.LANCHOR64]
	adrp	x21, .LANCHOR67
	str	x23, [sp, 48]
	adrp	x23, .LANCHOR126
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w0, [x21, #:lo12:.LANCHOR67]
	mov	w1, 255
	ldrh	w2, [x22, #:lo12:.LANCHOR57]
	mul	w2, w2, w0
	ldr	x0, [x23, #:lo12:.LANCHOR126]
	bl	ftl_memset
	adrp	x0, .LANCHOR96
	ldrh	w3, [x21, #:lo12:.LANCHOR67]
	ldr	x6, [x23, #:lo12:.LANCHOR126]
	mov	x1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR96]
	mov	w2, -1
	ldrh	w5, [x22, #:lo12:.LANCHOR57]
	add	x3, x0, x3, lsl 4
.L743:
	add	x4, x1, x5
	cmp	x0, x3
	bne	.L744
	adrp	x1, .LANCHOR127
	add	x0, x1, :lo12:.LANCHOR127
	ldp	x21, x22, [sp, 32]
	strh	w2, [x1, #:lo12:.LANCHOR127]
	ldr	w1, [x20, #:lo12:.LANCHOR64]
	strh	w1, [x0, 10]
	mov	w1, -3902
	strh	w1, [x0, 4]
	adrp	x1, .LANCHOR128
	ldr	x23, [sp, 48]
	strh	w2, [x0, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR128]
	strh	w1, [x0, 8]
	adrp	x1, .LANCHOR66
	ldrh	w1, [x1, #:lo12:.LANCHOR66]
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
.L744:
	and	x1, x1, -4
	strh	w2, [x0]
	add	x1, x6, x1
	str	wzr, [x0, 4]
	str	x1, [x0, 8]
	add	x0, x0, 16
	mov	x1, x4
	b	.L743
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
	adrp	x0, .LANCHOR70
	strh	wzr, [x0, #:lo12:.LANCHOR70]
	adrp	x0, .LANCHOR61
	ldrh	w2, [x0, #:lo12:.LANCHOR61]
	adrp	x0, .LANCHOR71
	ldr	x0, [x0, #:lo12:.LANCHOR71]
	lsl	w2, w2, 1
	bl	ftl_memset
	adrp	x0, .LANCHOR78
	ldrh	w2, [x19, #:lo12:.LANCHOR41]
	mov	w1, 0
	ldr	x0, [x0, #:lo12:.LANCHOR78]
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
	adrp	x0, .LANCHOR80
	add	x0, x0, :lo12:.LANCHOR80
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
	adrp	x24, .LANCHOR81
	stp	x19, x20, [sp, 16]
	adrp	x23, .LANCHOR85
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR88
	mul	w2, w2, w0
	ldr	x0, [x24, #:lo12:.LANCHOR81]
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR40
	str	x27, [sp, 80]
	adrp	x26, .LANCHOR47
	add	x25, x25, :lo12:.LANCHOR40
	add	x26, x26, :lo12:.LANCHOR47
	bl	ftl_memset
	mov	w21, 0
	adrp	x0, .LANCHOR87
	mov	w20, 0
	mov	w19, 0
	strh	wzr, [x23, #:lo12:.LANCHOR85]
	str	xzr, [x0, #:lo12:.LANCHOR87]
	adrp	x0, .LANCHOR82
	strh	wzr, [x22, #:lo12:.LANCHOR88]
	adrp	x27, .LANCHOR38
	str	xzr, [x0, #:lo12:.LANCHOR82]
	adrp	x0, .LANCHOR84
	str	xzr, [x0, #:lo12:.LANCHOR84]
	adrp	x0, .LANCHOR139
	strh	wzr, [x0, #:lo12:.LANCHOR139]
.L749:
	ldrh	w0, [x25]
	cmp	w19, w0
	bge	.L756
	adrp	x0, .LANCHOR52
	ldrh	w8, [x27, #:lo12:.LANCHOR38]
	mov	w5, 0
	mov	w6, 0
	ldrh	w7, [x0, #:lo12:.LANCHOR52]
	b	.L757
.L751:
	ldrb	w0, [x26, w6, sxtw]
	mov	w1, w19
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L750
	add	w5, w7, w5
	sxth	w5, w5
.L750:
	add	w6, w6, 1
	sxth	w6, w6
.L757:
	cmp	w6, w8
	blt	.L751
	cbz	w5, .L752
	mov	w0, 32768
	sdiv	w5, w0, w5
	sxth	w5, w5
.L753:
	ldr	x1, [x24, #:lo12:.LANCHOR81]
	mov	w0, 6
	smaddl	x0, w19, w0, x1
	strh	w5, [x0, 4]
	adrp	x0, .LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w19, w0
	beq	.L754
	adrp	x0, .LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w19, w0
	beq	.L754
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w19, w0
	beq	.L754
	adrp	x0, .LANCHOR83
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	ldrh	w0, [x0, w19, sxtw 1]
	cbnz	w0, .L755
	add	w21, w21, 1
	mov	w0, w19
	and	w21, w21, 65535
	bl	INSERT_FREE_LIST
.L754:
	add	w19, w19, 1
	sxth	w19, w19
	b	.L749
.L752:
	adrp	x0, .LANCHOR83
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	strh	w1, [x0, w19, sxtw 1]
	b	.L753
.L755:
	add	w20, w20, 1
	mov	w0, w19
	and	w20, w20, 65535
	bl	INSERT_DATA_LIST
	b	.L754
.L756:
	strh	w20, [x23, #:lo12:.LANCHOR85]
	add	w20, w20, w21
	strh	w21, [x22, #:lo12:.LANCHOR88]
	cmp	w0, w20
	bge	.L758
	mov	w2, 2646
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
.L758:
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
	adrp	x19, .LANCHOR54
	strh	wzr, [x0, #:lo12:.LANCHOR110]
	adrp	x0, .LANCHOR109
	ldrh	w2, [x19, #:lo12:.LANCHOR54]
	ldr	x0, [x0, #:lo12:.LANCHOR109]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w2, [x19, #:lo12:.LANCHOR54]
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
	stp	x29, x30, [sp, -48]!
	adrp	x0, .LANCHOR142
	add	x8, x0, :lo12:.LANCHOR142
	adrp	x11, .LANCHOR22
	add	x29, sp, 0
	add	x8, x8, 1
	mov	x7, x0
	add	x11, x11, :lo12:.LANCHOR22
	stp	x19, x20, [sp, 16]
	mov	x10, 0
	str	x21, [sp, 32]
.L770:
	ldrb	w2, [x8, -1]
	mov	w12, w10
	lsl	x21, x10, 5
	mov	x1, x11
	mov	x0, x8
	bl	FlashMemCmp8
	mov	w20, w0
	cbnz	w0, .L768
	add	x0, x7, :lo12:.LANCHOR142
	ubfiz	x12, x12, 5, 32
	add	x21, x0, x21
	add	x0, x0, x12
	adrp	x1, .LANCHOR143
	add	x4, x1, :lo12:.LANCHOR143
	ldrb	w3, [x0, 22]
	mov	x0, 0
.L769:
	lsl	x5, x0, 5
	mov	w2, w0
	ldrb	w5, [x5, x4]
	cmp	w5, w3
	beq	.L772
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L769
	mov	w2, w0
.L772:
	ubfiz	x0, x2, 5, 32
	add	x1, x1, :lo12:.LANCHOR143
	adrp	x19, .LANCHOR31
	add	x19, x19, :lo12:.LANCHOR31
	add	x1, x1, x0
	mov	w2, 32
	adrp	x0, .LANCHOR7
	add	x0, x0, :lo12:.LANCHOR7
	bl	ftl_memcpy
	mov	w2, 32
	mov	x1, x21
	mov	x0, x19
	bl	ftl_memcpy
	ldrh	w0, [x19, 10]
	bl	FlashBlockAlignInit
	b	.L767
.L768:
	add	x10, x10, 1
	add	x8, x8, 32
	cmp	x10, 81
	bne	.L770
	mov	w20, -1
.L767:
	mov	w0, w20
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.size	FlashLoadPhyInfoInRam, .-FlashLoadPhyInfoInRam
	.section	.text.ftl_memcpy32,"ax",@progbits
	.align	2
	.global	ftl_memcpy32
	.type	ftl_memcpy32, %function
ftl_memcpy32:
	mov	x3, 0
.L777:
	cmp	w2, w3
	bhi	.L778
	ret
.L778:
	ldr	w4, [x1, x3, lsl 2]
	str	w4, [x0, x3, lsl 2]
	add	x3, x3, 1
	b	.L777
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
	bne	.L780
	cbz	x3, .L781
	tst	x3, 3
	bne	.L782
	mov	w2, 256
	mov	x1, x3
	bl	ftl_memcpy32
.L781:
	cbz	x20, .L779
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
.L779:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L782:
	mov	w2, 1024
	mov	x1, x3
	bl	ftl_memcpy
	b	.L781
.L780:
	cbz	x3, .L785
	tst	x3, 3
	bne	.L786
	mov	x1, x0
	mov	w2, 256
	mov	x0, x3
	bl	ftl_memcpy32
.L785:
	cbz	x20, .L779
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
	b	.L779
.L786:
	mov	x1, x0
	mov	w2, 1024
	mov	x0, x3
	bl	ftl_memcpy
	b	.L785
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
	adrp	x0, .LANCHOR0
	and	w20, w1, 255
	add	x0, x0, :lo12:.LANCHOR0
	sbfiz	x1, x25, 4, 32
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	mov	x26, x3
	stp	x27, x28, [sp, 80]
	and	w24, w2, 255
	mov	x21, x4
	ldr	x19, [x0, x1]
	bne	.L799
	cbnz	x4, .L800
	add	x21, x29, 128
	mov	w2, 64
	mov	w1, 255
	add	x0, x29, 128
	bl	ftl_memset
.L800:
	mov	x5, x21
	mov	x4, x26
	mov	w2, w24
	mov	w1, w20
	mov	w3, 0
	mov	w0, w25
	bl	NandcXferStart
	mov	w0, w25
	bl	NandcXferComp
	cbnz	w20, .L824
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
.L803:
	add	w5, w3, w0
	cmp	x21, x2
	bne	.L804
	adrp	x0, .LANCHOR34
	ldr	w4, [x1, #:lo12:.LANCHOR32]
	lsr	w24, w24, 2
	mov	w2, 0
	ldr	w3, [x0, #:lo12:.LANCHOR34]
	mov	w22, 0
.L805:
	cmp	w2, w24
	bcs	.L801
	cbnz	w4, .L811
.L801:
	str	wzr, [x19, 16]
.L812:
	adrp	x0, .LANCHOR34
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w0, 5
	bls	.L798
	cbnz	w20, .L798
	ldr	w0, [x19]
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w0, w1
	cmp	w1, 139264
	bne	.L798
	orr	w0, w0, 131072
	mov	w22, -1
	str	w0, [x19]
.L798:
	mov	w0, w22
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L804:
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
	b	.L803
.L811:
	uxtw	x0, w2
	add	x0, x0, 8
	ldr	w0, [x19, x0, lsl 2]
	str	w0, [x29, 120]
	ldr	w0, [x29, 120]
	tbnz	x0, 2, .L827
	ldr	w0, [x29, 120]
	tbnz	x0, 15, .L827
	cmp	w3, 5
	bls	.L807
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
	bls	.L808
	ubfx	x1, x0, 3, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 27, 1
.L833:
	orr	w0, w1, w0, lsl 5
.L809:
	cmp	w22, w0
	csel	w22, w22, w0, cs
.L806:
	add	w2, w2, 1
	b	.L805
.L808:
	ubfx	x1, x0, 16, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 29, 1
	b	.L833
.L807:
	cmp	w3, 3
	bls	.L828
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
	bls	.L810
	ubfx	x1, x0, 3, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 28, 1
	b	.L833
.L810:
	ubfx	x1, x0, 16, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 30, 1
	b	.L833
.L828:
	mov	w0, 0
	b	.L809
.L827:
	mov	w22, -1
	b	.L806
.L824:
	mov	w22, 0
	b	.L801
.L799:
	cmp	w20, 1
	bne	.L813
	cmp	x4, 0
	mov	w23, 2
	csel	w23, w23, wzr, ne
	mov	w27, 0
	lsl	w23, w23, 1
	mov	w22, 0
.L814:
	cmp	w22, w24
	bcc	.L816
	mov	w22, 0
	b	.L812
.L816:
	and	w28, w22, 3
	cbz	x26, .L829
	lsl	w3, w22, 9
	add	x3, x26, x3
.L815:
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
	b	.L814
.L829:
	mov	x3, 0
	b	.L815
.L813:
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
.L817:
	cmp	w24, w23
	bls	.L812
	mov	w0, w25
	bl	NandcXferComp
	ldr	w0, [x19, 32]
	add	w27, w23, 2
	str	w0, [x29, 120]
	cmp	w24, w27
	bls	.L818
	mov	x5, 0
	mov	x4, 0
	and	w3, w27, 3
	mov	w2, 2
	mov	w1, 0
	mov	w0, w25
	bl	NandcXferStart
.L818:
	ldr	w0, [x29, 120]
	tbnz	x0, 2, .L830
	ldr	w0, [x29, 120]
	ubfx	x1, x0, 3, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 27, 1
	orr	w0, w1, w0, lsl 5
	cmp	w22, w0
	csel	w22, w22, w0, cs
.L819:
	and	w2, w23, 3
	cbz	x26, .L831
	lsl	w3, w23, 9
	add	x3, x26, x3
.L820:
	add	x4, x21, x28, uxtw
	mov	x0, x19
	mov	w1, 0
	bl	NandcCopy1KB
	ldr	w0, [x29, 108]
	mov	w23, w27
	add	w28, w28, w0
	b	.L817
.L830:
	mov	w22, -1
	b	.L819
.L831:
	mov	x3, 0
	b	.L820
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
	bne	.L835
	adrp	x0, .LANCHOR3
	adrp	x1, .LANCHOR4
	ldrb	w0, [x0, #:lo12:.LANCHOR3]
	ldr	w1, [x1, #:lo12:.LANCHOR4]
	mul	w0, w0, w1
	cmp	w0, w21
	mov	w0, 4
	csel	w20, w20, w0, ls
.L835:
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
	cbz	w4, .L851
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
	bne	.L840
.L849:
	mov	w21, -1
.L837:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L840:
	mov	w1, w25
	mov	w2, w21
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
	adrp	x1, .LANCHOR144
	ldr	w0, [x1, #:lo12:.LANCHOR144]
	add	w0, w0, 1
	cmp	w0, 2047
	bhi	.L842
	str	w0, [x1, #:lo12:.LANCHOR144]
	b	.L837
.L842:
	str	wzr, [x1, #:lo12:.LANCHOR144]
	mov	x28, 0
	mov	x23, 0
.L839:
	mov	w5, 0
	mov	w20, 0
	mov	w6, 0
	mov	w19, 0
	mov	w27, -1
.L847:
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
	bhi	.L843
	cmp	w0, 2
	bhi	.L853
	add	w19, w19, 1
	cmp	w19, 9
	bls	.L853
	mov	w1, w20
	mov	w21, w0
	sub	w20, w22, w19
	mov	w27, 0
.L845:
	cmp	w19, w6
	csel	w20, w20, w1, hi
.L846:
	cbz	w20, .L848
	mov	w1, w20
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	printf
	mov	w0, w20
	bl	NandcSetDdrPara
.L848:
	cbz	w27, .L837
	adrp	x0, .LC11
	mov	w2, w25
	mov	w1, w24
	add	x0, x0, :lo12:.LC11
	bl	printf
	cbz	w26, .L849
	ldr	w1, [x29, 108]
	lsr	w0, w1, 8
	bl	NandcSetDdrPara
	b	.L837
.L851:
	mov	w21, 1024
	b	.L839
.L843:
	cmp	w19, w6
	bls	.L854
	sub	w20, w5, w19
	cmp	w19, 7
	bhi	.L846
	mov	w6, w19
.L854:
	mov	w19, 0
	b	.L844
.L853:
	mov	w5, w22
	mov	w21, w0
	mov	w27, 0
	mov	x28, 0
	mov	x23, 0
.L844:
	add	w22, w22, 2
	cmp	w22, 69
	bls	.L847
	mov	w1, w20
	mov	w20, w5
	b	.L845
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
	bne	.L864
	adrp	x24, .LANCHOR6
	ldrb	w25, [x24, #:lo12:.LANCHOR6]
	cbnz	w25, .L865
.L867:
	adrp	x0, .LANCHOR30
	ldrb	w0, [x0, #:lo12:.LANCHOR30]
	cbz	w0, .L864
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
	beq	.L868
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	cmp	w19, w0, lsr 1
	bls	.L864
.L868:
	lsr	w0, w24, 8
	bl	NandcSetDdrPara
	b	.L864
.L865:
	strb	wzr, [x24, #:lo12:.LANCHOR6]
	mov	x3, x23
	mov	x2, x22
	mov	w1, w21
	mov	w0, w20
	bl	FlashReadRawPage
	strb	w25, [x24, #:lo12:.LANCHOR6]
	cmn	w0, #1
	beq	.L867
	mov	w19, w0
.L864:
	adrp	x24, .LANCHOR145
	ldr	x4, [x24, #:lo12:.LANCHOR145]
	cbz	x4, .L863
	cmn	w19, #1
	bne	.L863
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
	bne	.L863
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L863
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
.L863:
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
	beq	.L884
	cmn	w22, #1
	bne	.L885
.L884:
	ldrb	w0, [x19, #:lo12:.LANCHOR24]
	tbz	x0, 0, .L885
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
	strb	wzr, [x20, #:lo12:.LANCHOR30]
.L886:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L885:
	mov	w0, 1
	strb	w0, [x20, #:lo12:.LANCHOR30]
	b	.L886
	.size	FlashDdrParaScan, .-FlashDdrParaScan
	.section	.text.FlashLoadPhyInfo,"ax",@progbits
	.align	2
	.global	FlashLoadPhyInfo
	.type	FlashLoadPhyInfo, %function
FlashLoadPhyInfo:
	stp	x29, x30, [sp, -128]!
	mov	w0, 60
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR4
	adrp	x22, .LANCHOR147
	stp	x19, x20, [sp, 16]
	strb	w0, [x29, 120]
	mov	w0, 40
	strb	w0, [x29, 121]
	mov	w0, 24
	strb	w0, [x29, 122]
	mov	w0, 16
	strb	w0, [x29, 123]
	adrp	x20, .LANCHOR146
	ldr	w0, [x21, #:lo12:.LANCHOR4]
	mov	w19, 0
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR148
	str	w0, [x29, 108]
	mov	w23, -1
	ldr	x0, [x22, #:lo12:.LANCHOR147]
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR31
	str	x0, [x20, #:lo12:.LANCHOR146]
	mov	w26, 4
	stp	x27, x28, [sp, 80]
	add	x25, x25, :lo12:.LANCHOR31
	str	wzr, [x24, #:lo12:.LANCHOR148]
	mov	w0, 0
	bl	flash_enter_slc_mode
.L895:
	add	w28, w19, 1
	mov	x27, 0
.L897:
	add	x0, x29, 120
	ldrb	w0, [x0, x27]
	bl	FlashBchSel
	ldr	x2, [x22, #:lo12:.LANCHOR147]
	mov	x3, 0
	mov	w1, w19
	mov	w0, 0
	bl	FlashReadRawPage
	cmn	w0, #1
	bne	.L896
	ldr	x2, [x22, #:lo12:.LANCHOR147]
	mov	x3, 0
	mov	w1, w28
	mov	w0, 0
	bl	FlashReadRawPage
	cmn	w0, #1
	bne	.L896
	add	x27, x27, 1
	cmp	x27, 4
	bne	.L897
.L898:
	ldr	w0, [x29, 108]
	subs	w26, w26, #1
	add	w19, w19, w0
	bne	.L895
	b	.L903
.L899:
	mov	w1, 2036
	add	x0, x6, 12
	bl	js_hash
	ldr	w1, [x6, 8]
	cmp	w1, w0
	bne	.L905
	add	x1, x6, 160
	mov	w2, 32
	mov	x0, x25
	bl	ftl_memcpy
	ldr	x1, [x20, #:lo12:.LANCHOR146]
	mov	w2, 32
	adrp	x0, .LANCHOR7
	add	x0, x0, :lo12:.LANCHOR7
	add	x1, x1, 192
	bl	ftl_memcpy
	ldr	x1, [x20, #:lo12:.LANCHOR146]
	mov	w2, 852
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	add	x1, x1, 224
	bl	ftl_memcpy
	ldrh	w0, [x25, 10]
	bl	FlashBlockAlignInit
	str	w19, [x24, #:lo12:.LANCHOR148]
	ldr	x1, [x20, #:lo12:.LANCHOR146]
	adrp	x0, .LANCHOR30
	ldr	w2, [x1, 1076]
	strb	w2, [x0, #:lo12:.LANCHOR30]
	ldr	w0, [x21, #:lo12:.LANCHOR4]
	adrp	x2, .LANCHOR149
	udiv	w0, w19, w0
	add	w0, w0, 1
	cmp	w0, 1
	bls	.L901
.L908:
	str	w0, [x2, #:lo12:.LANCHOR149]
	adrp	x0, .LANCHOR150
	ldrh	w1, [x1, 14]
	mov	w23, 0
	strb	w1, [x0, #:lo12:.LANCHOR150]
	b	.L898
.L901:
	mov	w0, 2
	b	.L908
.L905:
	mov	w23, -1
	b	.L898
.L896:
	ldr	x6, [x20, #:lo12:.LANCHOR146]
	mov	w1, 20036
	movk	w1, 0x4e41, lsl 16
	ldr	w0, [x6]
	cmp	w0, w1
	bne	.L898
	cbnz	w23, .L899
	ldr	w0, [x21, #:lo12:.LANCHOR4]
	udiv	w19, w19, w0
	adrp	x0, .LANCHOR149
	add	w19, w19, 1
	str	w19, [x0, #:lo12:.LANCHOR149]
.L903:
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
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x2, x0, x1
	ldr	x22, [x0, x1]
	adrp	x1, .LANCHOR10
	ldrb	w27, [x2, 8]
	ldrb	w0, [x1, #:lo12:.LANCHOR10]
	str	x1, [x29, 112]
	add	x19, x27, 8
	sub	w0, w0, #67
	str	w27, [x29, 124]
	and	w0, w0, 255
	add	x19, x22, x19, lsl 8
	cmp	w0, 1
	bls	.L926
	adrp	x0, .LANCHOR30
	ldrb	w0, [x0, #:lo12:.LANCHOR30]
	cbz	w0, .L927
	mov	w23, 1
	mov	w0, 0
	bl	NandcSetDdrMode
.L911:
	add	x0, x22, x27, lsl 8
	mov	w1, 92
	str	w1, [x0, 2056]
	mov	w1, 197
	str	w1, [x0, 2056]
.L910:
	ldrsw	x0, [x29, 124]
	mov	w20, 1
	mov	w24, -1
	add	x0, x0, 8
	add	x0, x22, x0, lsl 8
	str	x0, [x29, 104]
.L912:
	adrp	x0, .LANCHOR151
	ldrb	w0, [x0, #:lo12:.LANCHOR151]
	add	w0, w0, 1
	cmp	w20, w0
	bcc	.L921
	mov	w28, w24
.L920:
	ldr	x0, [x29, 112]
	mov	w1, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR10]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x19
	bhi	.L922
	bl	SandiskSetRRPara
.L923:
	ldrsw	x0, [x29, 124]
	add	x0, x0, 8
	add	x22, x22, x0, lsl 8
	mov	w0, 255
	str	w0, [x22, 8]
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L924
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L924:
	mov	w0, w21
	bl	NandcWaitFlashReady
	cbz	w23, .L909
	mov	w0, 4
	bl	NandcSetDdrMode
.L909:
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L927:
	mov	w23, 0
	b	.L911
.L926:
	mov	w23, 0
	b	.L910
.L921:
	ldr	x0, [x29, 112]
	mov	w1, w20
	ldrb	w0, [x0, #:lo12:.LANCHOR10]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x19
	bhi	.L913
	bl	SandiskSetRRPara
.L914:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, #:lo12:.LANCHOR10]
	cmp	w0, 34
	bne	.L915
	adrp	x0, .LANCHOR151
	ldrb	w0, [x0, #:lo12:.LANCHOR151]
	sub	w0, w0, #3
	cmp	w20, w0
	bne	.L915
	ldr	x1, [x29, 104]
	mov	w0, 179
	str	w0, [x1, 8]
.L915:
	add	x0, x22, x27, lsl 8
	mov	w1, 38
	str	w1, [x0, 2056]
	mov	w1, 93
	str	w1, [x0, 2056]
	cbz	w23, .L916
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
.L917:
	cmn	w28, #1
	beq	.L918
	adrp	x0, .LANCHOR33
	cmn	w24, #1
	csel	w24, w24, w28, ne
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L920
	mov	x26, 0
	mov	x25, 0
.L918:
	add	w20, w20, 1
	b	.L912
.L913:
	bl	ToshibaSetRRPara
	b	.L914
.L916:
	ldr	w1, [x29, 120]
	mov	x3, x26
	mov	x2, x25
	mov	w0, w21
	bl	FlashReadRawPage
	mov	w28, w0
	b	.L917
.L922:
	bl	ToshibaSetRRPara
	b	.L923
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
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
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
.L938:
	ldrb	w0, [x26]
	add	w0, w0, 1
	cmp	w21, w0
	bcc	.L942
.L941:
	mov	x0, x20
	mov	w1, 0
	bl	SamsungSetRRPara
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L937
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L937:
	mov	w0, w19
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L942:
	mov	w1, w21
	mov	x0, x20
	bl	SamsungSetRRPara
	mov	x3, x25
	mov	x2, x24
	mov	w1, w23
	mov	w0, w22
	bl	FlashReadRawPage
	cmn	w0, #1
	beq	.L939
	ldrb	w1, [x27]
	cmn	w19, #1
	csel	w19, w19, w0, ne
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L944
	mov	x25, 0
	mov	x24, 0
.L939:
	add	w21, w21, 1
	b	.L938
.L944:
	mov	w19, w0
	b	.L941
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
	adrp	x0, .LANCHOR15
	stp	x25, x26, [sp, 64]
	mov	x25, x3
	ldrb	w1, [x0, #:lo12:.LANCHOR15]
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	str	x0, [x29, 128]
	cbnz	w1, .L952
	add	w19, w19, w19, lsl 1
	asr	w19, w19, 2
.L953:
	adrp	x21, .LANCHOR0
	add	x21, x21, :lo12:.LANCHOR0
	add	x21, x21, x20, sxtw 4
	mov	w23, 0
	mov	w28, 137
.L963:
	mov	w0, w20
	bl	NandcWaitFlashReady
	ldrb	w4, [x21, 8]
	adrp	x7, .LANCHOR151
	ldr	x8, [x21]
	add	x7, x7, :lo12:.LANCHOR151
	mov	w22, 0
	mov	w26, -1
	add	x27, x8, x4, lsl 8
.L954:
	ldrb	w0, [x7]
	cmp	w22, w0
	bcc	.L958
.L957:
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
	bcc	.L959
	cmn	w26, #1
	mov	w0, 256
	csel	w26, w26, w0, eq
.L959:
	cmp	w26, 256
	ccmn	w26, #1, 4, ne
	bne	.L960
	ldr	w2, [x29, 140]
	adrp	x0, .LC13
	mov	w4, w26
	mov	w3, w22
	mov	w1, w22
	add	x0, x0, :lo12:.LC13
	bl	printf
	cbnz	w23, .L961
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L951
	cmn	w26, #1
	bne	.L951
	mov	w1, 3
	mov	w0, w20
	mov	w23, 1
	bl	micron_auto_read_calibration_config
	b	.L963
.L952:
	mov	w0, 3
	sdiv	w19, w19, w0
	b	.L953
.L958:
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
	beq	.L955
	cmn	w26, #1
	csel	w26, w26, w0, ne
	cmp	w0, w19
	bcc	.L965
	mov	x25, 0
	mov	x24, 0
.L955:
	mov	w22, w10
	b	.L954
.L965:
	mov	w26, w0
	mov	x25, 0
	mov	x24, 0
	b	.L957
.L961:
	mov	w0, w20
	mov	w1, 0
	bl	micron_auto_read_calibration_config
	cmn	w26, #1
	mov	w0, 256
	csel	w26, w26, w0, eq
.L951:
	mov	w0, w26
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L960:
	cbz	w23, .L951
	mov	w1, 0
	mov	w0, w20
	mov	w26, 256
	bl	micron_auto_read_calibration_config
	b	.L951
	.size	MicronReadRetrial, .-MicronReadRetrial
	.section	.text.HynixReadRetrial,"ax",@progbits
	.align	2
	.global	HynixReadRetrial
	.type	HynixReadRetrial, %function
HynixReadRetrial:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR20
	stp	x27, x28, [sp, 80]
	and	x28, x0, 255
	add	x0, x19, :lo12:.LANCHOR20
	stp	x23, x24, [sp, 48]
	stp	x21, x22, [sp, 32]
	mov	w22, w1
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR18
	add	x1, x0, x28
	mov	x20, x28
	ldrb	w21, [x0, 2]
	mov	x23, x2
	ldr	x0, [x25, #:lo12:.LANCHOR18]
	mov	x24, x3
	ldrb	w26, [x1, 12]
	ldrb	w0, [x0, 19]
	sub	w0, w0, #7
	and	w0, w0, 255
	cmp	w0, 1
	bhi	.L977
	ldrb	w26, [x1, 20]
.L977:
	mov	w0, w20
	bl	NandcWaitFlashReady
	add	x6, x19, :lo12:.LANCHOR20
	adrp	x5, .LANCHOR33
	add	x7, x6, 4
	add	x5, x5, :lo12:.LANCHOR33
	mov	w4, 0
	mov	w27, -1
.L978:
	cmp	w4, w21
	bcc	.L983
.L982:
	ldr	x0, [x25, #:lo12:.LANCHOR18]
	add	x19, x19, :lo12:.LANCHOR20
	add	x19, x19, x28
	ldrb	w0, [x0, 19]
	sub	w0, w0, #7
	and	w0, w0, 255
	cmp	w0, 1
	bhi	.L984
	strb	w26, [x19, 20]
.L985:
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w27, w0, lsr 2
	bcc	.L976
	cmn	w27, #1
	mov	w0, 256
	csel	w27, w27, w0, eq
.L976:
	mov	w0, w27
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L983:
	add	w26, w26, 1
	ldrb	w1, [x6, 1]
	and	w26, w26, 255
	mov	x2, x7
	cmp	w21, w26
	str	x5, [x29, 96]
	csel	w26, w26, wzr, hi
	str	w4, [x29, 108]
	stp	x7, x6, [x29, 112]
	mov	w3, w26
	mov	w0, w20
	bl	HynixSetRRPara
	mov	x3, x24
	mov	x2, x23
	mov	w1, w22
	mov	w0, w20
	bl	FlashReadRawPage
	cmn	w0, #1
	ldr	w4, [x29, 108]
	ldr	x5, [x29, 96]
	ldp	x7, x6, [x29, 112]
	beq	.L980
	ldrb	w1, [x5]
	cmn	w27, #1
	csel	w27, w27, w0, ne
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L987
	mov	x24, 0
	mov	x23, 0
.L980:
	add	w4, w4, 1
	b	.L978
.L987:
	mov	w27, w0
	b	.L982
.L984:
	strb	w26, [x19, 12]
	b	.L985
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
	bne	.L995
	adrp	x0, .LANCHOR3
	adrp	x1, .LANCHOR4
	ldrb	w0, [x0, #:lo12:.LANCHOR3]
	ldr	w1, [x1, #:lo12:.LANCHOR4]
	mul	w0, w0, w1
	cmp	w0, w20
	bls	.L995
	adrp	x0, .LANCHOR2
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	cbnz	w0, .L996
	sub	w21, w21, #2
.L995:
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
.L996:
	mov	w21, 4
	b	.L995
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
	adrp	x21, .LANCHOR4
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
	add	x21, x21, :lo12:.LANCHOR4
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
	adrp	x1, .LANCHOR3
	ldrb	w1, [x1, #:lo12:.LANCHOR3]
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
	bl	js_hash
	str	w0, [x6, 8]
	mov	w0, 1592
	str	w0, [x6, 4]
	ldr	x0, [x24, #:lo12:.LANCHOR153]
	str	x0, [x19, #:lo12:.LANCHOR146]
	mov	w0, 0
	bl	flash_enter_slc_mode
.L1001:
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
	beq	.L999
	ldr	x6, [x19, #:lo12:.LANCHOR146]
	ldr	w0, [x6]
	cmp	w0, w25
	bne	.L999
	mov	w1, 2036
	add	x0, x6, 12
	bl	js_hash
	ldr	w1, [x6, 8]
	cmp	w1, w0
	bne	.L999
	ldr	w0, [x21]
	cmp	w23, 1
	str	w7, [x26]
	mul	w20, w0, w20
	adrp	x0, .LANCHOR148
	str	w20, [x0, #:lo12:.LANCHOR148]
	beq	.L1002
	mov	w23, 1
.L999:
	mov	w20, w7
	cmp	w7, 4
	bne	.L1001
.L1000:
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
.L1002:
	mov	w23, 2
	b	.L1000
	.size	FlashSavePhyInfo, .-FlashSavePhyInfo
	.section	.text.FlashReadIdbDataRaw,"ax",@progbits
	.align	2
	.global	FlashReadIdbDataRaw
	.type	FlashReadIdbDataRaw, %function
FlashReadIdbDataRaw:
	stp	x29, x30, [sp, -144]!
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
	ldr	w1, [x0, #:lo12:.LANCHOR29]
	stp	x27, x28, [sp, 80]
	str	x0, [x29, 120]
	cbz	w1, .L1009
	mov	w0, 0
	bl	flash_enter_slc_mode
.L1009:
	adrp	x24, .LANCHOR3
	adrp	x22, .LANCHOR4
	add	x27, x29, 136
	add	x22, x22, :lo12:.LANCHOR4
	add	x28, x24, :lo12:.LANCHOR3
	mov	w20, -1
	mov	w19, 2
	mov	w2, 2048
	mov	w1, 0
	mov	x0, x23
	bl	ftl_memset
.L1010:
	ldrb	w0, [x24, #:lo12:.LANCHOR3]
	cmp	w19, w0
	bcc	.L1015
.L1014:
	mov	w0, w26
	bl	FlashBchSel
	ldr	x0, [x29, 120]
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	cbz	w0, .L1008
	mov	w0, 0
	bl	flash_exit_slc_mode
.L1008:
	mov	w0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1015:
	mov	x4, 0
	adrp	x25, .LANCHOR147
.L1012:
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
	bne	.L1011
	ldr	x4, [x29, 104]
	add	x4, x4, 1
	cmp	x4, 4
	bne	.L1012
.L1013:
	add	w19, w19, 1
	b	.L1010
.L1018:
	mov	w20, 0
	b	.L1014
.L1011:
	ldr	x0, [x21]
	ldr	w1, [x0]
	mov	w0, 35899
	movk	w0, 0xfcdc, lsl 16
	cmp	w1, w0
	bne	.L1013
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
	bcs	.L1018
	str	w19, [x0, #:lo12:.LANCHOR149]
	mov	w20, 0
	bl	FlashSavePhyInfo
	b	.L1013
	.size	FlashReadIdbDataRaw, .-FlashReadIdbDataRaw
	.section	.text.FlashPageProgMsbFFData,"ax",@progbits
	.align	2
	.global	FlashPageProgMsbFFData
	.type	FlashPageProgMsbFFData, %function
FlashPageProgMsbFFData:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	and	w24, w0, 255
	adrp	x0, .LANCHOR15
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	and	w19, w2, 65535
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	stp	x25, x26, [sp, 64]
	cbz	w0, .L1028
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	cbnz	w0, .L1027
.L1028:
	adrp	x2, .LANCHOR18
	mov	x25, x2
	ldr	x0, [x2, #:lo12:.LANCHOR18]
	ldrb	w23, [x0, 19]
	sub	w0, w23, #5
	and	w3, w0, 255
	cmp	w3, 63
	bhi	.L1027
	mov	x2, 16399
	movk	x2, 0x4000, lsl 16
	movk	x2, 0x8000, lsl 48
	lsr	x0, x2, x3
	tbz	x0, 0, .L1027
	adrp	x20, .LANCHOR120
	mov	w22, w1
	add	x20, x20, :lo12:.LANCHOR120
	mov	w26, 65535
	adrp	x21, .LANCHOR153
.L1030:
	ldr	x0, [x25, #:lo12:.LANCHOR18]
	ldrh	w0, [x0, 10]
	cmp	w0, w19
	bhi	.L1033
.L1027:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1033:
	ldrh	w0, [x20, w19, sxtw 1]
	cmp	w0, w26
	bne	.L1027
	mov	w2, 32768
	cmp	w23, 8
	bne	.L1031
	mov	w1, 0
.L1038:
	ldr	x0, [x21, #:lo12:.LANCHOR153]
	bl	ftl_memset
	ldr	x3, [x21, #:lo12:.LANCHOR153]
	add	w1, w19, w22
	add	w19, w19, 1
	mov	w0, w24
	mov	x2, x3
	and	w19, w19, 65535
	bl	FlashProgPage
	b	.L1030
.L1031:
	mov	w1, 255
	b	.L1038
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
	bls	.L1040
	cmp	w1, 575
	bhi	.L1041
	adrp	x0, .LANCHOR154
	mov	x1, x2
	mov	w2, 1
	cmp	w4, 64
	str	w2, [x0, #:lo12:.LANCHOR154]
	adrp	x0, idb_buf
	bhi	.L1042
	mov	w2, 64
	sub	w4, w2, w4
	sub	w2, w3, w4
	ubfiz	x4, x4, 9, 25
	lsl	w2, w2, 9
	add	x1, x1, x4
	add	x0, x0, :lo12:idb_buf
.L1092:
	bl	ftl_memcpy
.L1075:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	ret
.L1042:
	mov	w2, 576
	sub	w2, w2, w4
	cmp	w3, w2
	sub	w4, w4, #64
	csel	w2, w3, w2, ls
	ubfiz	x4, x4, 9, 25
	add	x0, x0, :lo12:idb_buf
	lsl	w2, w2, 9
	add	x0, x0, x4
	b	.L1092
.L1040:
	cmp	w1, 575
	bls	.L1075
.L1041:
	adrp	x0, .LANCHOR154
	str	x0, [x29, 104]
	ldr	w1, [x0, #:lo12:.LANCHOR154]
	cbz	w1, .L1075
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
.L1046:
	ldr	w4, [x1]
	cbnz	w4, .L1044
	ldr	w4, [x5, w0, uxtw 2]
	add	w0, w0, 1
	str	w4, [x1], -4
	cmp	w0, w3
	sub	w2, w2, #1
	csel	w0, w0, wzr, cc
	cmp	w2, 4096
	bne	.L1046
.L1044:
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
	str	w0, [x29, 136]
	adrp	x0, .LANCHOR16
	add	x0, x0, :lo12:.LANCHOR16
	str	x0, [x29, 160]
.L1047:
	cmp	w24, 15
	bls	.L1065
	cbnz	w23, .L1067
	adrp	x0, .LC17
	mov	w1, 0
	add	x0, x0, :lo12:.LC17
	bl	printf
.L1067:
	ldr	x0, [x29, 104]
	str	wzr, [x0, #:lo12:.LANCHOR154]
	b	.L1075
.L1065:
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
	str	x27, [x29, 128]
	mul	w26, w22, w26
	and	w26, w26, 65535
	cmp	w26, 511
	bhi	.L1048
	add	w0, w26, w19
	bl	FW_FlashBlockErase.constprop.41
.L1048:
	udiv	w4, w19, w26
	adrp	x5, .LANCHOR15
	add	x5, x5, :lo12:.LANCHOR15
	mov	x28, 0
	msub	w4, w4, w26, w19
	sub	w26, w19, w4
.L1049:
	add	x2, x25, :lo12:idb_buf
	cmp	x28, 128
	add	x2, x2, x28, lsl 11
	bne	.L1053
	ldr	x0, [x21, #:lo12:.LANCHOR18]
	mov	w26, 0
	ldr	x1, [x29, 128]
	add	x27, x1, :lo12:gp_flash_check_buf
	adrp	x1, .LANCHOR15
	ldrb	w28, [x0, 9]
	add	x1, x1, :lo12:.LANCHOR15
	ldrh	w22, [x0, 10]
	str	x1, [x29, 96]
	mul	w22, w28, w22
	and	w0, w22, 65535
	udiv	w22, w19, w0
	msub	w22, w22, w0, w19
	sub	w0, w19, w22
	str	w0, [x29, 120]
	mul	w0, w22, w28
	ubfx	x0, x0, 2, 2
.L1054:
	cmp	w26, 511
	bhi	.L1061
	ldr	x3, [x29, 96]
	mov	w1, 4
	sub	w1, w1, w0
	ldr	x2, [x29, 160]
	and	w1, w1, 65535
	str	w1, [x29, 144]
	add	w1, w22, w26
	ldrb	w3, [x3]
	lsr	w1, w1, 2
	ldrh	w2, [x2, w1, sxtw 1]
	cbz	w3, .L1055
	adrp	x3, .LANCHOR119
	mov	w4, 12336
	movk	w4, 0x5638, lsl 16
	ldr	w3, [x3, #:lo12:.LANCHOR119]
	cmp	w3, w4
	csel	w2, w2, w1, ne
.L1055:
	ldr	w1, [x29, 120]
	add	w0, w0, w1
	adrp	x1, .LANCHOR4
	ldr	w1, [x1, #:lo12:.LANCHOR4]
	madd	w0, w28, w2, w0
	str	w0, [x29, 168]
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	str	w0, [x29, 112]
	ldr	x0, [x21, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 9]
	str	w0, [x29, 140]
	adrp	x0, .LANCHOR14+26
	ldrh	w0, [x0, #:lo12:.LANCHOR14+26]
	mul	w0, w0, w1
	ldr	w1, [x29, 140]
	mul	w0, w0, w1
	ldr	w1, [x29, 168]
	cmp	w1, w0
	bcs	.L1056
	adrp	x0, .LANCHOR152
	ldrb	w0, [x0, #:lo12:.LANCHOR152]
	bl	FlashBchSel
.L1056:
	mov	w0, 0
	bl	flash_boot_enter_slc_mode
	ldr	w0, [x29, 168]
	add	x3, x29, 176
	ldr	w1, [x29, 140]
	mov	x2, x27
	udiv	w1, w0, w1
	mov	w0, 0
	str	w1, [x29, 168]
	bl	FlashReadPage
	mov	w1, w0
	cmn	w0, #1
	bne	.L1057
	adrp	x0, .LANCHOR152
	ldrb	w0, [x0, #:lo12:.LANCHOR152]
	cmp	w0, 40
	beq	.L1057
	mov	w0, 40
	bl	FlashBchSel
	ldr	w1, [x29, 168]
	add	x3, x29, 176
	mov	x2, x27
	mov	w0, 0
	bl	FlashReadPage
	mov	w1, w0
.L1057:
	str	w1, [x29, 168]
	mov	w0, 0
	bl	flash_boot_exit_slc_mode
	ldrb	w0, [x29, 112]
	bl	FlashBchSel
	ldr	w1, [x29, 168]
	cmn	w1, #1
	bne	.L1058
.L1061:
	ldr	x0, [x29, 128]
	add	x1, x25, :lo12:idb_buf
	mov	x22, 0
	add	x26, x0, :lo12:gp_flash_check_buf
.L1059:
	lsl	x0, x22, 2
	mov	w27, w22
	add	x28, x0, x1
	ldr	w2, [x0, x26]
	ldr	w0, [x0, x1]
	cmp	w2, w0
	beq	.L1062
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
	bls	.L1063
	add	w0, w20, w19
	bl	FW_FlashBlockErase.constprop.41
.L1063:
	ldr	w0, [x29, 172]
	add	w24, w24, w0
	ldr	w0, [x29, 136]
	add	w19, w19, w0
	b	.L1047
.L1053:
	add	w1, w4, w28, lsl 2
	lsr	w1, w1, 2
	cbz	w1, .L1050
	ldr	x0, [x29, 160]
	add	w3, w1, 1
	ldrb	w6, [x5]
	ldrh	w0, [x0, w3, sxtw 1]
	cbz	w6, .L1051
	adrp	x6, .LANCHOR119
	mov	w7, 12336
	movk	w7, 0x5638, lsl 16
	ldr	w6, [x6, #:lo12:.LANCHOR119]
	cmp	w6, w7
	csel	w0, w0, w3, ne
.L1051:
	lsl	w0, w0, 2
	sub	w0, w0, #4
	str	w0, [x29, 176]
.L1050:
	mov	w0, 61424
	str	w0, [x29, 180]
	ldr	x0, [x29, 160]
	ldrh	w27, [x0, w1, sxtw 1]
	ldrb	w0, [x5]
	cbz	w0, .L1052
	adrp	x0, .LANCHOR119
	mov	w3, 12336
	movk	w3, 0x5638, lsl 16
	ldr	w0, [x0, #:lo12:.LANCHOR119]
	cmp	w0, w3
	csel	w27, w27, w1, ne
.L1052:
	adrp	x0, .LANCHOR33
	madd	w1, w22, w27, w26
	stp	x5, x2, [x29, 112]
	add	x28, x28, 1
	ldrb	w6, [x0, #:lo12:.LANCHOR33]
	adrp	x0, .LANCHOR152
	stp	w4, w6, [x29, 140]
	ldrb	w0, [x0, #:lo12:.LANCHOR152]
	str	w1, [x29, 168]
	bl	FlashBchSel
	mov	w0, 0
	bl	flash_boot_enter_slc_mode
	ldr	x0, [x21, #:lo12:.LANCHOR18]
	add	x3, x29, 176
	ldr	w1, [x29, 168]
	ldr	x2, [x29, 120]
	ldrb	w0, [x0, 9]
	udiv	w1, w1, w0
	mov	w0, 0
	bl	FlashProgPage
	mov	w0, 0
	bl	flash_boot_exit_slc_mode
	ldr	w6, [x29, 144]
	mov	w0, w6
	bl	FlashBchSel
	udiv	w1, w26, w22
	add	w2, w27, 1
	mov	w0, 0
	bl	FlashPageProgMsbFFData
	ldr	w4, [x29, 140]
	ldr	x5, [x29, 112]
	b	.L1049
.L1058:
	ldr	x0, [x29, 144]
	ubfiz	x0, x0, 9, 16
	add	x27, x27, x0
	ldr	w0, [x29, 144]
	add	w26, w0, w26
	mov	w0, 0
	and	w26, w26, 65535
	b	.L1054
.L1062:
	add	x22, x22, 1
	cmp	x22, 65536
	bne	.L1059
	add	w23, w23, 1
	cmp	w23, 5
	bls	.L1063
	b	.L1067
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
	adrp	x2, .LANCHOR0
	add	x1, x2, :lo12:.LANCHOR0
	adrp	x4, .LANCHOR119
	add	x29, sp, 0
	str	x0, [x2, #:lo12:.LANCHOR0]
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
	str	w2, [x4, #:lo12:.LANCHOR119]
	cmp	w2, 2049
	bne	.L1097
	mov	w2, 8
	str	w2, [x3, #:lo12:.LANCHOR34]
.L1097:
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
	adrp	x19, .LANCHOR54
	str	wzr, [x0, #:lo12:.LANCHOR157]
	adrp	x0, .LANCHOR158
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR38
	str	wzr, [x0, #:lo12:.LANCHOR158]
	adrp	x0, .LANCHOR159
	str	x23, [sp, 48]
	adrp	x21, .LANCHOR57
	str	wzr, [x0, #:lo12:.LANCHOR159]
	adrp	x0, .LANCHOR160
	adrp	x23, .LANCHOR58
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
	adrp	x0, .LANCHOR79
	str	wzr, [x0, #:lo12:.LANCHOR79]
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
	adrp	x1, .LANCHOR112
	str	wzr, [x0, #:lo12:.LANCHOR174]
	adrp	x0, .LANCHOR175
	str	wzr, [x0, #:lo12:.LANCHOR175]
	adrp	x0, .LANCHOR73
	str	wzr, [x0, #:lo12:.LANCHOR73]
	mov	w0, -1
	strh	w0, [x1, #:lo12:.LANCHOR112]
	adrp	x1, .LANCHOR113
	strh	w0, [x1, #:lo12:.LANCHOR113]
	adrp	x1, .LANCHOR114
	strh	w0, [x1, #:lo12:.LANCHOR114]
	adrp	x1, .LANCHOR115
	strh	w0, [x1, #:lo12:.LANCHOR115]
	adrp	x0, .LANCHOR176
	mov	w1, 32
	strh	w1, [x0, #:lo12:.LANCHOR176]
	adrp	x0, .LANCHOR177
	mov	w1, 128
	strh	w1, [x0, #:lo12:.LANCHOR177]
	adrp	x0, .LANCHOR178
	strh	wzr, [x0, #:lo12:.LANCHOR178]
	adrp	x0, .LANCHOR116
	strh	wzr, [x0, #:lo12:.LANCHOR116]
	adrp	x0, .LANCHOR179
	strh	wzr, [x0, #:lo12:.LANCHOR179]
	adrp	x0, .LANCHOR118
	strh	wzr, [x0, #:lo12:.LANCHOR118]
	ldrh	w0, [x19, #:lo12:.LANCHOR54]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR109
	str	x0, [x1, #:lo12:.LANCHOR109]
	mov	w0, 12
	ldrh	w1, [x19, #:lo12:.LANCHOR54]
	mul	w0, w1, w0
	bl	ftl_malloc
	ldrh	w19, [x22, #:lo12:.LANCHOR38]
	adrp	x1, .LANCHOR111
	str	x0, [x1, #:lo12:.LANCHOR111]
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
	adrp	x20, .LANCHOR107
	adrp	x1, .LANCHOR182
	str	x0, [x1, #:lo12:.LANCHOR182]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR77
	str	x0, [x1, #:lo12:.LANCHOR77]
	mov	w0, w19
	bl	ftl_malloc
	ldrh	w19, [x21, #:lo12:.LANCHOR57]
	adrp	x1, .LANCHOR106
	str	x0, [x1, #:lo12:.LANCHOR106]
	ldrh	w0, [x22, #:lo12:.LANCHOR38]
	lsl	w0, w0, 1
	add	w0, w0, 1
	str	w0, [x20, #:lo12:.LANCHOR107]
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
	ldr	w0, [x20, #:lo12:.LANCHOR107]
	mul	w0, w19, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR104
	str	x0, [x1, #:lo12:.LANCHOR104]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR186
	str	x0, [x1, #:lo12:.LANCHOR186]
	mov	w0, w19
	bl	ftl_malloc
	adrp	x1, .LANCHOR187
	str	x0, [x1, #:lo12:.LANCHOR187]
	mov	w0, 24
	ldr	w1, [x20, #:lo12:.LANCHOR107]
	mul	w0, w1, w0
	bl	ftl_malloc
	ldrh	w19, [x23, #:lo12:.LANCHOR58]
	adrp	x1, .LANCHOR103
	str	x0, [x1, #:lo12:.LANCHOR103]
	ldrh	w0, [x22, #:lo12:.LANCHOR38]
	adrp	x22, .LANCHOR64
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
	ldrh	w1, [x23, #:lo12:.LANCHOR58]
	ldr	w0, [x20, #:lo12:.LANCHOR107]
	adrp	x20, .LANCHOR190
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR105
	str	x0, [x1, #:lo12:.LANCHOR105]
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
	adrp	x1, .LANCHOR78
	add	x0, x0, 32
	str	x0, [x1, #:lo12:.LANCHOR78]
	ldrh	w0, [x19, #:lo12:.LANCHOR41]
	lsl	w0, w0, 1
	bl	ftl_malloc
	ldr	w20, [x22, #:lo12:.LANCHOR64]
	adrp	x1, .LANCHOR83
	str	x0, [x1, #:lo12:.LANCHOR83]
	lsl	w20, w20, 1
	mov	w0, w20
	bl	ftl_malloc
	adrp	x1, .LANCHOR129
	str	x0, [x1, #:lo12:.LANCHOR129]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x20, .LANCHOR61
	adrp	x1, .LANCHOR125
	str	x0, [x1, #:lo12:.LANCHOR125]
	ldrh	w0, [x19, #:lo12:.LANCHOR41]
	lsr	w0, w0, 3
	add	w0, w0, 4
	bl	ftl_malloc
	adrp	x1, .LANCHOR1
	str	x0, [x1, #:lo12:.LANCHOR1]
	ldrh	w0, [x20, #:lo12:.LANCHOR61]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR71
	str	x0, [x1, #:lo12:.LANCHOR71]
	ldrh	w0, [x20, #:lo12:.LANCHOR61]
	lsl	w0, w0, 1
	bl	ftl_malloc
	adrp	x1, .LANCHOR192
	str	x0, [x1, #:lo12:.LANCHOR192]
	ldrh	w0, [x20, #:lo12:.LANCHOR61]
	adrp	x20, .LANCHOR62
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR193
	str	x0, [x1, #:lo12:.LANCHOR193]
	ldrh	w0, [x20, #:lo12:.LANCHOR62]
	lsl	w0, w0, 2
	bl	ftl_malloc
	ldrh	w2, [x20, #:lo12:.LANCHOR62]
	adrp	x1, .LANCHOR194
	str	x0, [x1, #:lo12:.LANCHOR194]
	mov	w1, 0
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR66
	ldrh	w20, [x0, #:lo12:.LANCHOR66]
	lsl	w20, w20, 2
	mov	w0, w20
	bl	ftl_malloc
	adrp	x1, .LANCHOR131
	str	x0, [x1, #:lo12:.LANCHOR131]
	mov	w0, w20
	bl	ftl_malloc
	adrp	x20, .LANCHOR67
	adrp	x1, .LANCHOR195
	str	x0, [x1, #:lo12:.LANCHOR195]
	ldr	w0, [x22, #:lo12:.LANCHOR64]
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR130
	str	x0, [x1, #:lo12:.LANCHOR130]
	ldrh	w0, [x20, #:lo12:.LANCHOR67]
	lsl	w0, w0, 4
	bl	ftl_malloc
	adrp	x1, .LANCHOR96
	str	x0, [x1, #:lo12:.LANCHOR96]
	ldrh	w1, [x20, #:lo12:.LANCHOR67]
	adrp	x20, .LANCHOR45
	ldrh	w0, [x21, #:lo12:.LANCHOR57]
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR126
	str	x0, [x1, #:lo12:.LANCHOR126]
	mov	w0, 6
	ldrh	w1, [x19, #:lo12:.LANCHOR41]
	adrp	x19, .LANCHOR123
	mul	w0, w1, w0
	bl	ftl_malloc
	adrp	x1, .LANCHOR81
	str	x0, [x1, #:lo12:.LANCHOR81]
	adrp	x0, .LANCHOR51
	ldrh	w1, [x20, #:lo12:.LANCHOR45]
	ldrh	w0, [x0, #:lo12:.LANCHOR51]
	add	w0, w0, 31
	asr	w0, w0, 5
	strh	w0, [x19, #:lo12:.LANCHOR123]
	mul	w0, w1, w0
	lsl	w0, w0, 2
	bl	ftl_malloc
	adrp	x1, .LANCHOR74
	ldrh	w5, [x19, #:lo12:.LANCHOR123]
	add	x2, x1, :lo12:.LANCHOR74
	ldrh	w7, [x20, #:lo12:.LANCHOR45]
	add	x6, x2, 40
	mov	w3, w5
	str	x0, [x2, 32]
	mov	x0, 1
.L1100:
	cmp	w0, w7
	bcc	.L1101
	mov	w2, 8
	sub	w2, w2, w0
	add	x2, x2, 1
	add	x1, x1, :lo12:.LANCHOR74
	mov	x3, 0
.L1102:
	add	x3, x3, 1
	cmp	x2, x3
	bne	.L1103
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1101:
	ldr	x4, [x2, 32]
	add	w0, w0, 1
	add	x4, x4, x3, uxtw 2
	add	w3, w3, w5
	str	x4, [x6], 8
	b	.L1100
.L1103:
	add	x4, x0, x3
	add	x4, x1, x4, lsl 3
	str	xzr, [x4, 24]
	b	.L1102
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
	adrp	x0, .LANCHOR68
	ldr	w0, [x0, #:lo12:.LANCHOR68]
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
.L1113:
	cmp	x25, x19
	bne	.L1119
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
.L1119:
	cbnz	w20, .L1114
	mov	w2, w19
	mov	x1, x26
	mov	x0, x23
	bl	printf
.L1114:
	cmp	w24, 4
	bne	.L1115
	ldr	w1, [x22, x19, lsl 2]
.L1121:
	mov	x0, x21
	add	w20, w20, 1
	bl	printf
	cmp	w20, 15
	bls	.L1118
	mov	w20, 0
	add	x1, x27, :lo12:.LC20
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1118:
	add	x19, x19, 1
	b	.L1113
.L1115:
	cmp	w24, 2
	bne	.L1117
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L1121
.L1117:
	ldrb	w1, [x22, x19]
	b	.L1121
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
	bne	.L1123
	mov	w1, -89
	strb	w1, [x0, 4]
	adrp	x0, .LANCHOR196+17
	mov	w1, -9
	strb	w1, [x0, #:lo12:.LANCHOR196+17]
.L1188:
	mov	w27, 7
	b	.L1232
.L1123:
	cmp	w26, 3
	bne	.L1125
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
.L1231:
	mov	w27, 8
	mov	w28, w27
	strb	w1, [x0, 11]
.L1124:
	sub	w0, w26, #1
	cmp	w0, 1
	bhi	.L1130
	adrp	x26, .LANCHOR25
	adrp	x0, .LANCHOR26
	adrp	x25, .LANCHOR0
	add	x26, x26, :lo12:.LANCHOR25
	add	x4, x0, :lo12:.LANCHOR26
	add	x25, x25, :lo12:.LANCHOR0
	mov	w24, 0
.L1131:
	ldrb	w0, [x26]
	cmp	w0, w24
	bhi	.L1137
.L1138:
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
.L1125:
	cmp	w26, 4
	bne	.L1126
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
	b	.L1231
.L1126:
	cmp	w26, 5
	bne	.L1127
	mov	w1, 56
	strb	w1, [x0, 4]
	mov	w1, 57
	strb	w1, [x0, 5]
	mov	w1, 58
	mov	w27, 8
	strb	w1, [x0, 6]
	mov	w1, 59
	strb	w1, [x0, 7]
.L1232:
	mov	w28, 4
	b	.L1124
.L1127:
	cmp	w26, 6
	bne	.L1128
	mov	w1, 14
	strb	w1, [x0, 4]
	mov	w1, 15
	strb	w1, [x0, 5]
	mov	w1, 16
	mov	w27, 12
	strb	w1, [x0, 6]
	mov	w1, 17
	strb	w1, [x0, 7]
	b	.L1232
.L1128:
	cmp	w26, 7
	bne	.L1129
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
	b	.L1124
.L1129:
	cmp	w26, 8
	bne	.L1188
	mov	w1, 6
	strb	w1, [x0, 4]
	mov	w1, 7
	strb	w1, [x0, 5]
	mov	w1, 9
	strb	w26, [x0, 6]
	strb	w1, [x0, 7]
	mov	w27, 50
	mov	w1, 10
	mov	w28, 5
	strb	w1, [x0, 8]
	b	.L1124
.L1137:
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
.L1132:
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
	bhi	.L1132
	adrp	x2, .LANCHOR196
	add	x2, x2, :lo12:.LANCHOR196
	mov	x0, 0
.L1135:
	add	x7, x19, x0
	add	x6, x2, x0
	mov	x1, 1
.L1134:
	lsl	x3, x1, 2
	lsl	x8, x1, 3
	ldrb	w10, [x19, x0]
	add	x1, x1, 1
	cmp	x1, 7
	ldrb	w3, [x6, x3]
	add	w3, w3, w10
	strb	w3, [x7, x8]
	bne	.L1134
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L1135
	add	w24, w24, 1
	strb	wzr, [x19, 16]
	strb	wzr, [x19, 24]
	and	w24, w24, 255
	strb	wzr, [x19, 32]
	strb	wzr, [x19, 40]
	strb	wzr, [x19, 48]
	strb	wzr, [x19, 41]
	strb	wzr, [x19, 49]
	b	.L1131
.L1130:
	sub	w0, w26, #3
	cmp	w0, 5
	bhi	.L1138
	mul	w24, w27, w28
	adrp	x25, .LANCHOR25
	sub	w22, w28, #1
	mov	w21, 0
	and	x22, x22, 255
	lsl	w0, w24, 4
	asr	w23, w24, 1
	str	w0, [x29, 128]
	lsl	w0, w23, 1
	sbfiz	x24, x23, 1, 32
	str	w0, [x29, 140]
	add	x0, x25, :lo12:.LANCHOR25
	sub	w25, w26, #5
	str	x0, [x29, 120]
	add	x0, x22, 1
	str	x0, [x29, 112]
.L1139:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, w21
	bls	.L1138
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w22, [x0, w21, sxtw]
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	sbfiz	x1, x22, 4, 32
	add	x3, x0, x1
	ldr	x0, [x0, x1]
	ldrb	w19, [x3, 8]
	add	x19, x0, x19, lsl 8
	mov	w0, 255
	str	w0, [x19, 2056]
	mov	w0, w22
	bl	NandcWaitFlashReady
	cmp	w26, 7
	bne	.L1140
	mov	x1, 28
	mov	w0, 160
	add	x3, x20, :lo12:.LANCHOR20
	umaddl	x0, w0, w22, x1
.L1233:
	add	x3, x3, x0
	mov	w0, 54
	str	w0, [x19, 2056]
	cmp	w26, 4
	bne	.L1143
	mov	w0, 255
	str	w0, [x19, 2052]
	mov	w0, 64
	str	w0, [x19, 2048]
	mov	w0, 204
.L1234:
	str	w0, [x19, 2052]
	mov	w0, 77
	b	.L1235
.L1140:
	cmp	w26, 8
	beq	.L1142
	ubfiz	x0, x22, 6, 8
	add	x3, x20, :lo12:.LANCHOR20
	add	x0, x0, 20
	b	.L1233
.L1143:
	cmp	w25, 1
	bhi	.L1145
	add	x0, x20, :lo12:.LANCHOR20
	ldrb	w0, [x0, 4]
	str	w0, [x19, 2052]
	mov	w0, 82
.L1235:
	str	w0, [x19, 2048]
.L1144:
	mov	w0, 22
	str	w0, [x19, 2056]
	mov	w0, 23
	str	w0, [x19, 2056]
	mov	w0, 4
	str	w0, [x19, 2056]
	mov	w0, 25
	str	w0, [x19, 2056]
	str	wzr, [x19, 2056]
	cmp	w26, 6
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	bne	.L1146
	mov	w0, 31
	str	w0, [x19, 2052]
.L1147:
	mov	w0, 2
	str	w0, [x19, 2052]
	str	wzr, [x19, 2052]
.L1187:
	mov	w0, 48
	str	w0, [x19, 2056]
	str	x3, [x29, 104]
	mov	w0, w22
	bl	NandcWaitFlashReady
	cmp	w25, 1
	ldr	x3, [x29, 104]
	ccmp	w26, 8, 4, hi
	beq	.L1189
	cmp	w26, 7
	mov	w0, 2
	mov	w1, 32
	csel	w1, w1, w0, eq
.L1148:
	adrp	x8, .LANCHOR147
	mov	x7, 0
	ldr	x0, [x8, #:lo12:.LANCHOR147]
.L1149:
	ldr	w10, [x19, 2048]
	strb	w10, [x0, x7]
	add	x7, x7, 1
	cmp	w1, w7, uxtb
	bhi	.L1149
	cmp	w26, 8
	bne	.L1150
	mov	w1, 0
.L1152:
	ldrb	w7, [x0]
	cmp	w7, 50
	beq	.L1151
	ldrb	w7, [x0, 1]
	cmp	w7, 5
	beq	.L1151
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1152
.L1153:
	adrp	x0, .LC21
	mov	w1, 0
	add	x0, x0, :lo12:.LC21
	bl	printf
.L1155:
	b	.L1155
.L1145:
	cmp	w26, 7
	bne	.L1144
	mov	w0, 174
	str	w0, [x19, 2052]
	str	wzr, [x19, 2048]
	mov	w0, 176
	b	.L1234
.L1146:
	str	wzr, [x19, 2052]
	b	.L1147
.L1189:
	mov	w1, 16
	b	.L1148
.L1151:
	cmp	w1, 6
	bhi	.L1153
.L1154:
	ldr	x7, [x8, #:lo12:.LANCHOR147]
	mov	x0, 0
.L1164:
	ldr	w1, [x29, 128]
	cmp	w1, w0
	bgt	.L1165
	ldr	x1, [x8, #:lo12:.LANCHOR147]
	mov	w10, 8
	add	x8, x1, x24
.L1167:
	mov	x0, 0
.L1166:
	ldrh	w11, [x8, x0, lsl 1]
	mvn	w11, w11
	strh	w11, [x8, x0, lsl 1]
	add	x0, x0, 1
	cmp	w23, w0
	bgt	.L1166
	ldr	w0, [x29, 140]
	subs	w10, w10, #1
	add	x8, x8, x0, uxtw 1
	bne	.L1167
	mov	x10, x1
	mov	w11, 0
	mov	w16, 1
.L1173:
	mov	w0, 0
	mov	w8, 0
.L1172:
	mov	x14, x10
	lsl	w15, w16, w8
	mov	w13, 16
	mov	w12, 0
.L1170:
	ldrh	w17, [x14]
	add	x14, x14, x24
	bics	wzr, w15, w17
	cinc	w12, w12, eq
	subs	w13, w13, #1
	bne	.L1170
	cmp	w12, 8
	bls	.L1171
	orr	w0, w0, w15
	and	w0, w0, 65535
.L1171:
	add	w8, w8, 1
	cmp	w8, 16
	bne	.L1172
	strh	w0, [x10], 2
	add	w11, w11, 1
	cmp	w23, w11
	bgt	.L1173
	mov	x0, 0
	mov	w8, 0
.L1176:
	ldr	w10, [x1, x0]
	add	x0, x0, 4
	cmp	w10, 0
	cinc	w8, w8, eq
	cmp	x0, 32
	bne	.L1176
	cmp	w8, 7
	ble	.L1177
	mov	w3, 1024
	mov	w2, 1
	adrp	x0, .LC22
	add	x0, x0, :lo12:.LC22
	bl	rknand_print_hex
	adrp	x0, .LC21
	mov	w1, 0
	add	x0, x0, :lo12:.LC21
	bl	printf
.L1178:
	b	.L1178
.L1150:
	cmp	w26, 7
	bne	.L1156
	mov	w1, 0
.L1158:
	ldrb	w7, [x0]
	cmp	w7, 12
	beq	.L1157
	ldrb	w7, [x0, 1]
	cmp	w7, 10
	beq	.L1157
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1158
.L1159:
	adrp	x0, .LC21
	mov	w1, 0
	add	x0, x0, :lo12:.LC21
	bl	printf
.L1160:
	b	.L1160
.L1157:
	cmp	w1, 6
	bls	.L1154
	b	.L1159
.L1156:
	cmp	w26, 6
	bne	.L1154
	mov	x1, 0
.L1161:
	ldrb	w7, [x0, x1]
	cmp	w7, 12
	beq	.L1154
	add	x7, x0, x1
	ldrb	w7, [x7, 8]
	cmp	w7, 4
	beq	.L1154
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L1161
	adrp	x0, .LC21
	mov	w1, 0
	add	x0, x0, :lo12:.LC21
	bl	printf
.L1163:
	b	.L1163
.L1165:
	ldr	w1, [x19, 2048]
	strb	w1, [x7, x0]
	add	x0, x0, 1
	b	.L1164
.L1177:
	cmp	w26, 6
	beq	.L1191
	cmp	w26, 7
	beq	.L1192
	cmp	w26, 8
	mov	x1, 8
	mov	x0, 5
	csel	x0, x0, x1, eq
.L1179:
	mov	w8, 0
.L1180:
	mov	x1, 0
.L1181:
	ldrb	w10, [x7, x1]
	strb	w10, [x3, x1]
	add	x1, x1, 1
	cmp	w28, w1, uxtb
	bhi	.L1181
	ldr	x1, [x29, 112]
	add	w8, w8, 1
	add	x3, x3, x0
	cmp	w27, w8
	add	x7, x7, x1
	bgt	.L1180
	mov	w0, 255
	str	w0, [x19, 2056]
	mov	w0, w22
	bl	NandcWaitFlashReady
	cmp	w25, 1
	bhi	.L1183
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
.L1184:
	add	w21, w21, 1
	mov	w0, w22
	and	w21, w21, 255
	bl	NandcWaitFlashReady
	b	.L1139
.L1191:
	mov	x0, 4
	b	.L1179
.L1192:
	mov	x0, 10
	b	.L1179
.L1183:
	cmp	w26, 8
	bne	.L1185
	mov	w0, 190
.L1236:
	str	w0, [x19, 2056]
	b	.L1184
.L1185:
	mov	w0, 56
	b	.L1236
.L1142:
	mov	w0, 120
	str	w0, [x19, 2056]
	str	wzr, [x19, 2052]
	mov	w0, 23
	str	wzr, [x19, 2052]
	mov	w1, 25
	str	wzr, [x19, 2052]
	add	x3, x20, :lo12:.LANCHOR20
	str	w0, [x19, 2056]
	mov	w0, 4
	str	w0, [x19, 2056]
	add	x3, x3, 28
	str	w1, [x19, 2056]
	mov	w1, 218
	str	w1, [x19, 2056]
	mov	w1, 21
	str	wzr, [x19, 2056]
	str	wzr, [x19, 2052]
	str	wzr, [x19, 2052]
	str	w1, [x19, 2052]
	str	w0, [x19, 2052]
	str	wzr, [x19, 2052]
	b	.L1187
	.size	HynixGetReadRetryDefault, .-HynixGetReadRetryDefault
	.section	.text.FlashGetReadRetryDefault,"ax",@progbits
	.align	2
	.global	FlashGetReadRetryDefault
	.type	FlashGetReadRetryDefault, %function
FlashGetReadRetryDefault:
	mov	w1, w0
	cbz	w0, .L1237
	sub	w2, w0, #1
	cmp	w2, 7
	bhi	.L1239
	b	HynixGetReadRetryDefault
.L1239:
	cmp	w0, 49
	bne	.L1240
	adrp	x2, .LANCHOR20
	add	x0, x2, :lo12:.LANCHOR20
	strb	w1, [x2, #:lo12:.LANCHOR20]
	mov	w1, 4
	strb	w1, [x0, 1]
	mov	w1, 15
	strb	w1, [x0, 2]
	adrp	x1, .LANCHOR13
	add	x1, x1, :lo12:.LANCHOR13
	mov	w2, 64
.L1249:
	add	x0, x0, 4
	b	ftl_memcpy
.L1240:
	sub	w0, w0, #65
	cmp	w1, 33
	ccmp	w0, 1, 0, ne
	bhi	.L1241
	adrp	x2, .LANCHOR20
	add	x0, x2, :lo12:.LANCHOR20
	strb	w1, [x2, #:lo12:.LANCHOR20]
	mov	w1, 4
.L1250:
	strb	w1, [x0, 1]
	mov	w1, 7
	mov	w2, 45
	strb	w1, [x0, 2]
	adrp	x1, .LANCHOR9
	add	x1, x1, :lo12:.LANCHOR9
	b	.L1249
.L1241:
	cmp	w1, 34
	mov	w0, 67
	ccmp	w1, w0, 4, ne
	bne	.L1242
	adrp	x2, .LANCHOR20
	add	x0, x2, :lo12:.LANCHOR20
	strb	w1, [x2, #:lo12:.LANCHOR20]
	mov	w1, 5
	b	.L1250
.L1242:
	cmp	w1, 35
	mov	w0, 68
	ccmp	w1, w0, 4, ne
	bne	.L1237
	adrp	x2, .LANCHOR20
	add	x0, x2, :lo12:.LANCHOR20
	strb	w1, [x2, #:lo12:.LANCHOR20]
	mov	w1, 5
	strb	w1, [x0, 1]
	mov	w1, 17
	mov	w2, 95
	strb	w1, [x0, 2]
	adrp	x1, .LANCHOR8
	add	x1, x1, :lo12:.LANCHOR8
	b	.L1249
.L1237:
	ret
	.size	FlashGetReadRetryDefault, .-FlashGetReadRetryDefault
	.section	.text.FlashInit,"ax",@progbits
	.align	2
	.global	FlashInit
	.type	FlashInit, %function
FlashInit:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	mov	w0, 32768
	stp	x23, x24, [sp, 48]
	adrp	x20, .LANCHOR30
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR3
	stp	x27, x28, [sp, 80]
	bl	ftl_malloc
	adrp	x1, .LANCHOR147
	adrp	x26, .LANCHOR200
	adrp	x21, .LANCHOR2
	adrp	x22, .LANCHOR152
	str	x0, [x1, #:lo12:.LANCHOR147]
	mov	w0, 32768
	bl	ftl_malloc
	adrp	x24, .LANCHOR0
	adrp	x1, .LANCHOR153
	add	x24, x24, :lo12:.LANCHOR0
	mov	w23, 0
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
	strb	wzr, [x26, #:lo12:.LANCHOR200]
	adrp	x1, .LANCHOR199
	strb	wzr, [x20, #:lo12:.LANCHOR30]
	strb	wzr, [x21, #:lo12:.LANCHOR2]
	str	x0, [x1, #:lo12:.LANCHOR199]
	adrp	x1, .LANCHOR150
	mov	w0, 50
	strb	w0, [x25, #:lo12:.LANCHOR3]
	strb	w0, [x1, #:lo12:.LANCHOR150]
	adrp	x0, .LANCHOR149
	mov	w1, 128
	str	wzr, [x0, #:lo12:.LANCHOR149]
	adrp	x0, .LANCHOR4
	str	w1, [x0, #:lo12:.LANCHOR4]
	adrp	x0, .LANCHOR144
	str	wzr, [x0, #:lo12:.LANCHOR144]
	mov	w0, 60
	strb	w0, [x22, #:lo12:.LANCHOR152]
	mov	x0, x19
	adrp	x19, .LANCHOR22
	bl	NandcInit
	add	x28, x19, :lo12:.LANCHOR22
	str	x26, [x29, 120]
	adrp	x26, .LC23
	add	x0, x26, :lo12:.LC23
	str	x0, [x29, 112]
.L1257:
	ldrb	w2, [x24, 8]
	and	w27, w23, 255
	str	w2, [x29, 108]
	mov	w0, w27
	ldr	x26, [x24]
	bl	FlashReset
	mov	w0, w27
	bl	NandcFlashCs
	ldr	w2, [x29, 108]
	mov	w0, 144
	ubfiz	x2, x2, 8, 8
	add	x26, x26, x2
	str	w0, [x26, 2056]
	mov	x0, 200
	str	wzr, [x26, 2052]
	bl	udelay
	ldr	w0, [x26, 2048]
	and	w0, w0, 255
	strb	w0, [x28]
	cmp	w0, 44
	ldr	w2, [x26, 2048]
	strb	w2, [x28, 1]
	ldr	w2, [x26, 2048]
	strb	w2, [x28, 2]
	ldr	w2, [x26, 2048]
	strb	w2, [x28, 3]
	ldr	w2, [x26, 2048]
	strb	w2, [x28, 4]
	ldr	w2, [x26, 2048]
	strb	w2, [x28, 5]
	bne	.L1252
	mov	w0, 239
	str	w0, [x26, 2056]
	mov	w0, 1
	str	w0, [x26, 2052]
	mov	x0, 200
	bl	udelay
	mov	w0, 4
	str	w0, [x26, 2048]
	str	wzr, [x26, 2048]
	str	wzr, [x26, 2048]
	str	wzr, [x26, 2048]
.L1252:
	mov	w0, w27
	bl	NandcFlashDeCs
	ldrb	w2, [x28]
	sub	w0, w2, #1
	and	w0, w0, 255
	cmp	w0, 253
	bhi	.L1253
	ldrb	w7, [x28, 5]
	add	w1, w23, 1
	ldrb	w6, [x28, 4]
	ldrb	w5, [x28, 3]
	ldrb	w4, [x28, 2]
	ldrb	w3, [x28, 1]
	ldr	x0, [x29, 112]
	bl	printf
.L1253:
	cbnz	w23, .L1254
	ldrb	w0, [x19, #:lo12:.LANCHOR22]
	add	x1, x19, :lo12:.LANCHOR22
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 253
	bhi	.L1301
	ldrb	w0, [x1, 1]
	cmp	w0, 255
	beq	.L1301
.L1254:
	ldrb	w0, [x28]
	cmp	w0, 181
	bne	.L1256
	mov	w0, 44
	strb	w0, [x28]
.L1256:
	add	w23, w23, 1
	add	x24, x24, 16
	add	x28, x28, 8
	cmp	w23, 4
	bne	.L1257
	ldrb	w0, [x19, #:lo12:.LANCHOR22]
	cmp	w0, 173
	beq	.L1258
	adrp	x0, .LANCHOR155
	ldr	w0, [x0, #:lo12:.LANCHOR155]
	bl	NandcSetDdrMode
.L1258:
	adrp	x24, .LANCHOR18
	adrp	x27, .LANCHOR6
	adrp	x26, .LANCHOR119
	adrp	x23, .LANCHOR20
	mov	w2, 852
	mov	w1, 0
	add	x0, x23, :lo12:.LANCHOR20
	bl	ftl_memset
	adrp	x3, .LANCHOR31
	ldr	w4, [x26, #:lo12:.LANCHOR119]
	add	x0, x3, :lo12:.LANCHOR31
	strb	wzr, [x27, #:lo12:.LANCHOR6]
	str	x0, [x24, #:lo12:.LANCHOR18]
	mov	w0, 12336
	movk	w0, 0x5638, lsl 16
	cmp	w4, w0
	bne	.L1259
	adrp	x0, .LANCHOR29
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR29]
.L1259:
	add	x0, x19, :lo12:.LANCHOR22
	ldrb	w2, [x0, 1]
	add	w0, w2, 95
	and	w1, w0, 255
	mov	x0, 1
	cmp	w1, 57
	bhi	.L1260
	movk	x0, 0x205, lsl 48
	lsr	x0, x0, x1
	mvn	x0, x0
.L1260:
	cmp	w2, 241
	and	w0, w0, 1
	cset	w1, eq
	eor	w0, w0, 1
	orr	w0, w1, w0
	cbnz	w0, .L1261
	cmp	w2, 220
	bne	.L1262
	add	x0, x19, :lo12:.LANCHOR22
	ldrb	w0, [x0, 3]
	cmp	w0, 149
	bne	.L1262
.L1261:
	adrp	x28, .LANCHOR201
	add	x5, x28, :lo12:.LANCHOR201
	mov	w1, 16
	strb	w1, [x25, #:lo12:.LANCHOR3]
	strb	w1, [x22, #:lo12:.LANCHOR152]
	mov	w0, 1
	ldrb	w1, [x19, #:lo12:.LANCHOR22]
	add	x6, x19, :lo12:.LANCHOR22
	strb	w0, [x21, #:lo12:.LANCHOR2]
	strb	w1, [x5, 1]
	cmp	w1, 152
	strb	w2, [x5, 2]
	bne	.L1264
	ldrsb	w1, [x6, 4]
	tbnz	w1, #31, .L1265
	mov	w0, 24
	strb	w0, [x22, #:lo12:.LANCHOR152]
.L1264:
	cmp	w4, 2049
	mov	w0, 12336
	movk	w0, 0x5638, lsl 16
	ccmp	w4, w0, 4, ne
	bne	.L1267
	mov	w0, 16
	strb	w0, [x22, #:lo12:.LANCHOR152]
.L1267:
	cmp	w2, 218
	bne	.L1268
	add	x0, x28, :lo12:.LANCHOR201
	mov	w1, 2048
	strh	w1, [x0, 14]
	mov	w1, -38
.L1335:
	strb	w1, [x0, 2]
.L1269:
	adrp	x1, .LANCHOR143
	add	x1, x1, :lo12:.LANCHOR143
	mov	w2, 32
	add	x1, x1, 32
	str	x3, [x29, 120]
	adrp	x0, .LANCHOR7
	add	x0, x0, :lo12:.LANCHOR7
	bl	ftl_memcpy
	ldr	x3, [x29, 120]
	mov	w2, 32
	add	x1, x28, :lo12:.LANCHOR201
	add	x0, x3, :lo12:.LANCHOR31
	bl	ftl_memcpy
.L1262:
	ldrb	w0, [x21, #:lo12:.LANCHOR2]
	adrp	x22, .LANCHOR15
	cbnz	w0, .L1272
	bl	FlashLoadPhyInfoInRam
	cbnz	w0, .L1274
	ldr	x0, [x24, #:lo12:.LANCHOR18]
	adrp	x28, .LANCHOR24
	ldrb	w1, [x0, 17]
	and	w0, w1, 7
	strb	w0, [x28, #:lo12:.LANCHOR24]
	tbnz	x1, 0, .L1274
	mov	w1, 1
	strb	w1, [x20, #:lo12:.LANCHOR30]
	bl	FlashSetInterfaceMode
	ldrb	w0, [x28, #:lo12:.LANCHOR24]
	bl	NandcSetMode
.L1274:
	ldr	x0, [x24, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 26]
	strb	w0, [x22, #:lo12:.LANCHOR15]
	bl	FlashLoadPhyInfo
	cbz	w0, .L1272
	ldr	x0, [x24, #:lo12:.LANCHOR18]
	ldrh	w1, [x0, 14]
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	bl	printf
	bl	FlashLoadPhyInfoInRam
	cmn	w0, #1
	beq	.L1251
	bl	FlashDieInfoInit
	ldr	x0, [x24, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 19]
	bl	FlashGetReadRetryDefault
	ldr	x0, [x24, #:lo12:.LANCHOR18]
	adrp	x1, .LANCHOR122
	ldrh	w1, [x1, #:lo12:.LANCHOR122]
	ldrb	w2, [x0, 9]
	add	w1, w1, 4095
	cmp	w2, w1, lsr 12
	blt	.L1277
	ldrh	w1, [x0, 14]
	add	w1, w1, 255
	cmp	w2, w1, lsr 8
	bge	.L1278
.L1277:
	ldrh	w1, [x0, 14]
	and	w1, w1, -256
	strh	w1, [x0, 14]
.L1278:
	adrp	x0, .LANCHOR24
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	tst	w0, 6
	beq	.L1279
	bl	FlashSavePhyInfo
	adrp	x0, .LANCHOR148
	ldr	w1, [x0, #:lo12:.LANCHOR148]
	mov	w0, 0
	bl	FlashDdrParaScan
.L1279:
	bl	FlashSavePhyInfo
.L1272:
	ldr	x2, [x24, #:lo12:.LANCHOR18]
	adrp	x28, .LANCHOR145
	str	xzr, [x28, #:lo12:.LANCHOR145]
	ldrb	w0, [x2, 26]
	strb	w0, [x22, #:lo12:.LANCHOR15]
	ldrh	w0, [x2, 16]
	ubfx	x1, x0, 7, 1
	strb	w1, [x27, #:lo12:.LANCHOR6]
	adrp	x1, .LANCHOR202
	ubfx	x3, x0, 3, 1
	adrp	x27, .LANCHOR24
	strb	w3, [x1, #:lo12:.LANCHOR202]
	adrp	x1, .LANCHOR27
	ubfx	x3, x0, 4, 1
	ubfx	x0, x0, 8, 3
	strb	w3, [x1, #:lo12:.LANCHOR27]
	strb	w0, [x27, #:lo12:.LANCHOR24]
	ldrh	w1, [x2, 10]
	ldrb	w0, [x2, 12]
	sdiv	w1, w1, w0
	ldrb	w0, [x2, 18]
	bl	BuildFlashLsbPageTable
	bl	FlashDieInfoInit
	ldr	x0, [x24, #:lo12:.LANCHOR18]
	ldrh	w1, [x0, 16]
	tbz	x1, 6, .L1281
	add	x3, x23, :lo12:.LANCHOR20
	adrp	x1, .LANCHOR10
	ldrb	w0, [x0, 19]
	adrp	x2, .LANCHOR12
	strb	w0, [x1, #:lo12:.LANCHOR10]
	mov	x4, x2
	ldrb	w1, [x3, 1]
	strb	w1, [x2, #:lo12:.LANCHOR12]
	adrp	x1, .LANCHOR151
	ldrb	w3, [x3, 2]
	strb	w3, [x1, #:lo12:.LANCHOR151]
	sub	w3, w0, #1
	and	w3, w3, 255
	cmp	w3, 7
	bhi	.L1282
	adrp	x1, HynixReadRetrial
	add	x1, x1, :lo12:HynixReadRetrial
	str	x1, [x28, #:lo12:.LANCHOR145]
	sub	w1, w0, #5
	and	w1, w1, 255
	cmp	w1, 1
	ccmp	w0, 8, 4, hi
	bne	.L1283
	adrp	x1, .LANCHOR36
	mov	w2, 1
	str	w2, [x1, #:lo12:.LANCHOR36]
.L1283:
	add	x23, x23, :lo12:.LANCHOR20
	cmp	w0, 7
	beq	.L1336
	cmp	w0, 8
	bne	.L1304
.L1336:
	add	x23, x23, 28
.L1284:
	mov	x1, 0
	mov	w2, 0
.L1286:
	ldrsb	w3, [x23, x1]
	add	x1, x1, 1
	cmp	w3, 0
	cinc	w2, w2, eq
	cmp	x1, 32
	bne	.L1286
	cmp	w2, 27
	bls	.L1281
	bl	FlashGetReadRetryDefault
	bl	FlashSavePhyInfo
.L1281:
	ldr	w1, [x26, #:lo12:.LANCHOR119]
	mov	w0, 12336
	movk	w0, 0x5638, lsl 16
	cmp	w1, w0
	bne	.L1295
	ldrb	w0, [x22, #:lo12:.LANCHOR15]
	cbz	w0, .L1295
	ldr	x0, [x24, #:lo12:.LANCHOR18]
	strb	wzr, [x0, 18]
.L1295:
	ldrb	w0, [x19, #:lo12:.LANCHOR22]
	cmp	w0, 44
	bne	.L1296
	ldrb	w0, [x20, #:lo12:.LANCHOR30]
	cbz	w0, .L1296
	strb	wzr, [x20, #:lo12:.LANCHOR30]
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
.L1296:
	ldrb	w0, [x27, #:lo12:.LANCHOR24]
	tst	w0, 6
	beq	.L1297
	ldrb	w1, [x20, #:lo12:.LANCHOR30]
	cbnz	w1, .L1298
	tbnz	x0, 0, .L1297
.L1298:
	mov	w0, 0
	bl	flash_enter_slc_mode
	adrp	x0, .LANCHOR148
	ldr	w1, [x0, #:lo12:.LANCHOR148]
	mov	w0, 0
	bl	FlashDdrParaScan
	mov	w0, 0
	bl	flash_exit_slc_mode
.L1297:
	ldr	x0, [x24, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 20]
	bl	FlashBchSel
	adrp	x0, .LANCHOR141
	add	x0, x0, :lo12:.LANCHOR141
	bl	FlashReadIdbDataRaw
	ldr	x2, [x24, #:lo12:.LANCHOR18]
	mov	w0, 16
	adrp	x1, .LANCHOR14
	strb	w0, [x25, #:lo12:.LANCHOR3]
	add	x0, x1, :lo12:.LANCHOR14
	ldrb	w3, [x2, 12]
	strh	w3, [x0, 8]
	ldrb	w4, [x2, 7]
	str	w4, [x0, 4]
	ldr	w4, [x19, #:lo12:.LANCHOR22]
	str	w4, [x1, #:lo12:.LANCHOR14]
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
	ldrb	w5, [x21, #:lo12:.LANCHOR2]
	cmp	w5, 1
	bne	.L1299
	ubfiz	w1, w1, 1, 15
	lsr	w4, w4, 1
	ubfiz	w3, w3, 1, 15
	strh	w1, [x0, 22]
	strh	w4, [x0, 14]
	mov	w1, 8
	strh	w3, [x0, 20]
	strh	w1, [x0, 26]
.L1299:
	ldrb	w0, [x2, 20]
	bl	FlashBchSel
	mov	w0, 0
.L1251:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1268:
	cmp	w2, 220
	bne	.L1270
	add	x0, x28, :lo12:.LANCHOR201
	mov	w1, 4096
	strh	w1, [x0, 14]
	mov	w1, -36
	b	.L1335
.L1270:
	cmp	w2, 211
	bne	.L1269
	add	x0, x28, :lo12:.LANCHOR201
	mov	w1, 4096
	strh	w1, [x0, 14]
	mov	w1, 2
	strb	w1, [x0, 13]
	b	.L1269
.L1304:
	add	x23, x23, 20
	b	.L1284
.L1282:
	sub	w3, w0, #17
	and	w3, w3, 255
	cmp	w3, 2
	bhi	.L1288
	adrp	x2, MicronReadRetrial
	add	x2, x2, :lo12:MicronReadRetrial
	str	x2, [x28, #:lo12:.LANCHOR145]
	cmp	w0, 19
	beq	.L1289
.L1340:
	mov	w0, 7
	b	.L1338
.L1289:
	mov	w0, 15
.L1338:
	strb	w0, [x1, #:lo12:.LANCHOR151]
	b	.L1281
.L1288:
	sub	w3, w0, #65
	cmp	w0, 33
	and	w3, w3, 255
	ccmp	w3, 1, 0, ne
	bhi	.L1290
	adrp	x0, ToshibaReadRetrial
	add	x0, x0, :lo12:ToshibaReadRetrial
	str	x0, [x28, #:lo12:.LANCHOR145]
	mov	w0, 4
	strb	w0, [x2, #:lo12:.LANCHOR12]
	b	.L1340
.L1290:
	sub	w3, w0, #34
	sub	w2, w0, #67
	and	w3, w3, 255
	and	w2, w2, 255
	cmp	w3, 1
	ccmp	w2, 1, 0, hi
	bhi	.L1291
	adrp	x3, ToshibaReadRetrial
	add	x3, x3, :lo12:ToshibaReadRetrial
	str	x3, [x28, #:lo12:.LANCHOR145]
	cmp	w0, 35
	mov	w3, 68
	ccmp	w0, w3, 4, ne
	beq	.L1292
	mov	w0, 7
.L1337:
	strb	w0, [x1, #:lo12:.LANCHOR151]
	cmp	w2, 1
	bhi	.L1294
	mov	w0, 4
.L1339:
	strb	w0, [x4, #:lo12:.LANCHOR12]
	b	.L1281
.L1292:
	mov	w0, 17
	b	.L1337
.L1294:
	mov	w0, 5
	b	.L1339
.L1291:
	cmp	w0, 49
	bne	.L1281
	adrp	x0, SamsungReadRetrial
	add	x0, x0, :lo12:SamsungReadRetrial
	str	x0, [x28, #:lo12:.LANCHOR145]
	b	.L1281
.L1301:
	mov	w0, -2
	b	.L1251
.L1265:
	ldr	x1, [x29, 120]
	strb	w0, [x1, #:lo12:.LANCHOR200]
	b	.L1264
	.size	FlashInit, .-FlashInit
	.section	.text.FlashReadSlc2KPages,"ax",@progbits
	.align	2
	.global	FlashReadSlc2KPages
	.type	FlashReadSlc2KPages, %function
FlashReadSlc2KPages:
	stp	x29, x30, [sp, -144]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	mov	w22, 56
	stp	x25, x26, [sp, 64]
	and	w21, w1, 255
	str	w2, [x29, 116]
	adrp	x2, .LANCHOR31+9
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrb	w25, [x2, #:lo12:.LANCHOR31+9]
	nop // between mem op and mult-accumulate
	umaddl	x0, w1, w22, x0
	adrp	x26, .LANCHOR200
	str	x0, [x29, 120]
	stp	x23, x24, [sp, 48]
	add	x0, x26, :lo12:.LANCHOR200
	stp	x27, x28, [sp, 80]
	str	x0, [x29, 104]
.L1342:
	ldr	x0, [x29, 120]
	cmp	x19, x0
	bne	.L1362
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1362:
	ldr	w1, [x29, 116]
	mov	w4, w21
	add	x3, x29, 136
	add	x2, x29, 140
	mov	x0, x19
	bl	LogAddr2PhyAddr
	adrp	x0, .LANCHOR25
	ldr	w1, [x29, 136]
	ldrb	w0, [x0, #:lo12:.LANCHOR25]
	cmp	w0, w1
	bhi	.L1343
	mov	w0, -1
	str	w0, [x19]
.L1344:
	sub	w21, w21, #1
	add	x19, x19, 56
	and	w21, w21, 255
	b	.L1342
.L1343:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	add	x23, x26, :lo12:.LANCHOR200
	mov	w22, 0
	mov	w24, 256
	ldrb	w20, [x0, w1, uxtw]
	mov	w0, w20
	bl	NandcWaitFlashReady
	mov	w0, w20
	bl	NandcFlashCs
.L1345:
	ldr	w1, [x29, 140]
	mov	w0, w20
	bl	FlashReadCmd
	mov	w0, w20
	bl	NandcWaitFlashReady
	ldp	x3, x4, [x19, 8]
	mov	w2, w25
	mov	w1, 0
	mov	w0, w20
	bl	NandcXferData
	mov	w28, w0
	ldrb	w0, [x23]
	cbz	w0, .L1346
	mov	w0, w20
	bl	flash_read_ecc
	cmp	w0, 5
	csel	w28, w28, w24, ls
.L1346:
	cmp	w22, 9
	ccmn	w28, #1, 0, ls
	bne	.L1347
	add	w22, w22, 1
	b	.L1345
.L1347:
	cmp	w22, 0
	mov	w23, 256
	adrp	x24, .LANCHOR4
	csel	w28, w28, w23, eq
	add	x24, x24, :lo12:.LANCHOR4
	mov	w22, 0
.L1349:
	ldr	w0, [x24]
	ldr	w1, [x29, 140]
	add	w1, w1, w0
	mov	w0, w20
	bl	FlashReadCmd
	mov	w0, w20
	bl	NandcWaitFlashReady
	ldr	x0, [x19, 8]
	mov	w2, w25
	mov	w1, 0
	cmp	x0, 0
	add	x3, x0, 2048
	ldr	x0, [x19, 16]
	csel	x3, x3, xzr, ne
	cmp	x0, 0
	add	x4, x0, 8
	csel	x4, x4, xzr, ne
	mov	w0, w20
	bl	NandcXferData
	mov	w27, w0
	ldr	x0, [x29, 104]
	ldrb	w0, [x0]
	cbz	w0, .L1352
	mov	w0, w20
	bl	flash_read_ecc
	cmp	w0, 5
	csel	w27, w27, w23, ls
.L1352:
	cmp	w22, 9
	ccmn	w27, #1, 0, ls
	bne	.L1353
	add	w22, w22, 1
	b	.L1349
.L1353:
	cmp	w22, 0
	mov	w3, 256
	mov	w0, w20
	csel	w27, w27, w3, eq
	bl	NandcFlashDeCs
	adrp	x0, .LANCHOR33
	cmp	w28, w27
	csel	w5, w28, w27, cs
	ldrb	w2, [x0, #:lo12:.LANCHOR33]
	add	w0, w2, w2, lsl 1
	cmp	w5, w0, lsr 2
	bls	.L1355
	cmn	w5, #1
	csel	w5, w5, w3, eq
.L1355:
	cmp	w5, 256
	ldr	x0, [x19, 16]
	ccmn	w5, #1, 4, ne
	csel	w5, w5, wzr, eq
	str	w5, [x19]
	cbz	x0, .L1358
	ldr	w1, [x0, 12]
	cmn	w1, #1
	bne	.L1358
	ldr	w1, [x0, 8]
	cmn	w1, #1
	bne	.L1358
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L1358
	str	w1, [x19]
.L1358:
	ldr	w3, [x19]
	cmn	w3, #1
	bne	.L1344
	ldr	w1, [x19, 4]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	bl	printf
	ldr	x1, [x19, 8]
	cbz	x1, .L1360
	adrp	x0, .LC26
	mov	w3, 8
	mov	w2, 4
	add	x0, x0, :lo12:.LC26
	bl	rknand_print_hex
.L1360:
	ldr	x1, [x19, 16]
	cbz	x1, .L1344
	mov	w3, 4
	adrp	x0, .LC27
	mov	w2, w3
	add	x0, x0, :lo12:.LC27
	bl	rknand_print_hex
	b	.L1344
	.size	FlashReadSlc2KPages, .-FlashReadSlc2KPages
	.section	.text.FlashReadPages,"ax",@progbits
	.align	2
	.global	FlashReadPages
	.type	FlashReadPages, %function
FlashReadPages:
	stp	x29, x30, [sp, -176]!
	adrp	x3, .LANCHOR2
	add	x29, sp, 0
	ldrb	w3, [x3, #:lo12:.LANCHOR2]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	stp	w2, w1, [x29, 148]
	cbnz	w3, .L1391
	mov	x25, x0
	adrp	x0, .LANCHOR31+9
	adrp	x27, .LANCHOR20
	mov	w23, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR31+9]
	mov	w22, 0
	str	w0, [x29, 156]
	adrp	x0, .LANCHOR6
	str	x0, [x29, 128]
	ldrb	w1, [x0, #:lo12:.LANCHOR6]
	add	x0, x27, :lo12:.LANCHOR20
	str	w1, [x29, 144]
	str	x0, [x29, 104]
	add	x0, x0, 4
	str	x0, [x29, 96]
.L1392:
	ldr	w0, [x29, 152]
	cmp	w22, w0
	bcc	.L1426
	mov	w0, 0
	b	.L1390
.L1391:
	bl	FlashReadSlc2KPages
.L1390:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1426:
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
	bhi	.L1394
	mov	w0, -1
	str	w0, [x25, x26]
.L1395:
	add	w22, w22, 1
	b	.L1392
.L1394:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w19, [x0, w1, uxtw]
	adrp	x0, .LANCHOR202
	ldrb	w0, [x0, #:lo12:.LANCHOR202]
	cmp	w0, 0
	mov	w0, w19
	csel	w20, w20, wzr, ne
	bl	NandcWaitFlashReady
	adrp	x2, .LANCHOR18
	str	x2, [x29, 120]
	ldr	x0, [x2, #:lo12:.LANCHOR18]
	ldrb	w1, [x0, 19]
	sub	w0, w1, #1
	and	w0, w0, 255
	cmp	w0, 7
	bhi	.L1397
	add	x0, x27, :lo12:.LANCHOR20
	sxtw	x2, w19
	add	x0, x0, x2
	sub	w1, w1, #7
	and	w1, w1, 255
	cmp	w1, 1
	ldrb	w3, [x0, 12]
	bhi	.L1398
	ldrb	w3, [x0, 20]
.L1398:
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	ldrb	w0, [x0, x2]
	cmp	w0, w3
	beq	.L1397
	ldp	x2, x0, [x29, 96]
	ldrb	w1, [x0, 1]
	mov	w0, w19
	bl	HynixSetRRPara
.L1397:
	mov	w0, w19
	bl	NandcFlashCs
	ldr	w0, [x29, 148]
	cmp	w0, 1
	cset	w0, eq
	orr	w24, w0, w24, lsr 31
	cbz	w24, .L1399
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L1399
	mov	w0, w19
	bl	flash_enter_slc_mode
.L1400:
	adrp	x0, .LANCHOR4
	add	x0, x0, :lo12:.LANCHOR4
	str	x0, [x29, 112]
	ldr	x0, [x29, 128]
	add	x0, x0, :lo12:.LANCHOR6
	str	x0, [x29, 136]
.L1406:
	ldr	w1, [x29, 172]
	cmn	w1, #1
	bne	.L1401
	cmp	w19, 255
	beq	.L1428
.L1401:
	cbz	w20, .L1403
	ldr	x0, [x29, 112]
	ldr	w2, [x0]
	mov	w0, w19
	add	w2, w1, w2
	bl	FlashReadDpCmd
.L1404:
	mov	w0, w19
	bl	NandcWaitFlashReady
	cbz	w20, .L1402
	ldr	w1, [x29, 172]
	mov	w0, w19
	bl	FlashReadDpDataOutCmd
.L1402:
	ldrb	w2, [x29, 156]
	mov	w1, 0
	ldp	x3, x4, [x21, 8]
	mov	w0, w19
	bl	NandcXferData
	mov	w28, w0
	ldr	x0, [x29, 136]
	ldrb	w0, [x0]
	cbz	w0, .L1405
	cmn	w28, #1
	bne	.L1405
	ldr	x0, [x29, 136]
	mov	w20, 0
	strb	wzr, [x0]
	b	.L1406
.L1399:
	mov	w0, w19
	bl	flash_exit_slc_mode
	b	.L1400
.L1403:
	mov	w0, w19
	bl	FlashReadCmd
	b	.L1404
.L1428:
	mov	w20, 0
	b	.L1402
.L1405:
	cbz	w20, .L1407
	adrp	x0, .LANCHOR4
	ldr	w1, [x29, 172]
	ldr	w0, [x0, #:lo12:.LANCHOR4]
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
.L1407:
	mov	w0, w19
	bl	NandcFlashDeCs
	ldr	x0, [x29, 128]
	cmn	w28, #1
	ldrb	w1, [x29, 144]
	strb	w1, [x0, #:lo12:.LANCHOR6]
	bne	.L1408
	adrp	x0, .LANCHOR30
	ldrb	w0, [x0, #:lo12:.LANCHOR30]
	cbnz	w0, .L1409
.L1413:
	adrp	x20, .LANCHOR145
	ldr	x4, [x20, #:lo12:.LANCHOR145]
	cbnz	x4, .L1410
	ldr	w1, [x29, 172]
	mov	w0, w19
	ldp	x2, x3, [x21, 8]
	bl	FlashReadRawPage
	b	.L1465
.L1409:
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
	beq	.L1412
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	cmp	w28, w0, lsr 1
	bls	.L1429
.L1412:
	lsr	w0, w20, 8
	bl	NandcSetDdrPara
	cmn	w28, #1
	beq	.L1413
.L1429:
	mov	w20, 0
.L1408:
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bls	.L1414
	adrp	x0, .LANCHOR145
	ldr	x0, [x0, #:lo12:.LANCHOR145]
	cmp	x0, 0
	mov	w0, 256
	csel	w28, w28, w0, ne
.L1414:
	cmp	w28, 256
	ccmn	w28, #1, 4, ne
	csel	w3, w28, wzr, eq
	str	w3, [x25, x26]
	cmn	w3, #1
	bne	.L1421
	adrp	x0, .LANCHOR33
	ldr	w1, [x21, 4]
	ldrb	w2, [x0, #:lo12:.LANCHOR33]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	bl	printf
	ldr	x1, [x21, 16]
	cbz	x1, .L1421
	mov	w3, 4
	adrp	x0, .LC27
	mov	w2, w3
	add	x0, x0, :lo12:.LC27
	bl	rknand_print_hex
.L1421:
	cbz	w20, .L1423
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w23, w0, lsr 2
	bls	.L1424
	adrp	x0, .LANCHOR145
	ldr	x0, [x0, #:lo12:.LANCHOR145]
	cmp	x0, 0
	mov	w0, 256
	csel	w23, w23, w0, ne
.L1424:
	add	w0, w22, 1
	mov	w1, 56
	cmp	w23, 256
	ccmn	w23, #1, 4, ne
	umull	x0, w0, w1
	csel	w1, w23, wzr, eq
	str	w1, [x25, x0]
.L1423:
	add	w22, w22, w20
	cbz	w24, .L1395
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L1395
	mov	w0, w19
	bl	flash_exit_slc_mode
	b	.L1395
.L1410:
	ldr	w1, [x29, 172]
	mov	w0, w19
	ldp	x2, x3, [x21, 8]
	blr	x4
	mov	w28, w0
	cmn	w0, #1
	bne	.L1432
	ldr	x0, [x29, 120]
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 19]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 7
	bhi	.L1415
	add	x0, x27, :lo12:.LANCHOR20
	mov	w3, 0
	add	x2, x0, 4
	ldrb	w1, [x0, 1]
	mov	w0, w19
	bl	HynixSetRRPara
.L1415:
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
	bne	.L1432
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L1432
	mov	w0, w19
	cbz	w24, .L1416
	bl	flash_enter_slc_mode
.L1417:
	ldr	x4, [x20, #:lo12:.LANCHOR145]
	mov	w0, w19
	ldr	w1, [x29, 172]
	ldp	x2, x3, [x21, 8]
	blr	x4
.L1465:
	mov	w28, w0
.L1432:
	mov	w20, 0
	b	.L1414
.L1416:
	bl	flash_exit_slc_mode
	b	.L1417
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
	adrp	x26, .LANCHOR4
	stp	x27, x28, [sp, 80]
	mov	w22, w21
	stp	x19, x20, [sp, 16]
	mov	x27, x0
	mov	x20, x0
	add	x28, x26, :lo12:.LANCHOR4
	str	w3, [x29, 108]
.L1467:
	cmp	x20, x23
	bne	.L1473
	ldr	w0, [x29, 108]
	cbnz	w0, .L1474
.L1493:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1473:
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
	bhi	.L1468
	mov	w0, -1
	str	w0, [x20]
.L1469:
	sub	w22, w22, #1
	add	x20, x20, 56
	and	w22, w22, 255
	b	.L1467
.L1468:
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
	ldr	w0, [x26, #:lo12:.LANCHOR4]
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
	tbz	x0, 0, .L1472
	mov	w0, -1
	str	w0, [x20]
.L1472:
	mov	w0, w19
	bl	NandcFlashDeCs
	b	.L1469
.L1480:
	ldr	w0, [x27]
	cmn	w0, #1
	bne	.L1475
	ldr	w1, [x27, 4]
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	bl	printf
.L1476:
	sub	w21, w21, #1
	add	x27, x27, 56
	and	w21, w21, 255
.L1494:
	cmp	x27, x20
	bne	.L1480
	b	.L1493
.L1475:
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
	bne	.L1477
	ldr	w1, [x27, 4]
	adrp	x0, .LC30
	add	x0, x0, :lo12:.LC30
	bl	printf
	str	w25, [x27]
.L1477:
	ldr	x0, [x27, 16]
	cbz	x0, .L1478
	ldr	w2, [x0]
	ldr	x0, [x19, #:lo12:.LANCHOR199]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1478
	ldr	w1, [x27, 4]
	adrp	x0, .LC31
	add	x0, x0, :lo12:.LC31
	bl	printf
	mov	w0, -1
	str	w0, [x27]
.L1478:
	ldr	x0, [x27, 8]
	cbz	x0, .L1476
	ldr	w2, [x0]
	ldr	x0, [x23, #:lo12:.LANCHOR198]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1476
	ldr	w1, [x27, 4]
	adrp	x0, .LC32
	add	x0, x0, :lo12:.LC32
	bl	printf
	mov	w0, -1
	str	w0, [x27]
	b	.L1476
.L1474:
	adrp	x22, .LANCHOR198
	mov	x23, x22
	b	.L1494
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
	adrp	x4, .LANCHOR2
	ldrb	w4, [x4, #:lo12:.LANCHOR2]
	cbnz	w4, .L1497
	mov	x19, x0
	adrp	x0, .LANCHOR31+9
	adrp	x27, .LANCHOR23
	mov	w24, w1
	ldrb	w0, [x0, #:lo12:.LANCHOR31+9]
	mov	w22, w2
	add	x28, x27, :lo12:.LANCHOR23
	mov	w21, 0
	str	w0, [x29, 108]
.L1498:
	cmp	w21, w24
	adrp	x26, .LANCHOR25
	bcc	.L1511
	adrp	x21, .LANCHOR15
	adrp	x23, .LANCHOR23
	add	x25, x26, :lo12:.LANCHOR25
	add	x21, x21, :lo12:.LANCHOR15
	add	x23, x23, :lo12:.LANCHOR23
	mov	x20, 0
.L1512:
	ldrb	w0, [x25]
	cmp	w0, w20
	bhi	.L1514
	ldr	w0, [x29, 100]
	cbnz	w0, .L1515
.L1523:
	mov	w0, 0
	b	.L1496
.L1497:
	bl	FlashProgSlc2KPages
.L1496:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1511:
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
	bhi	.L1500
	mov	w0, -1
	str	w0, [x19, x12]
.L1501:
	add	w21, w21, 1
	b	.L1498
.L1500:
	adrp	x1, .LANCHOR27
	add	x2, x27, :lo12:.LANCHOR23
	mov	x3, 24
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
	cmp	w1, 0
	uxtw	x1, w0
	csel	w23, w23, wzr, ne
	madd	x1, x1, x3, x2
	ldr	x1, [x1, 8]
	cbz	x1, .L1503
	bl	FlashWaitCmdDone
.L1503:
	ldp	w2, w1, [x29, 112]
	mov	x0, 24
	madd	x0, x1, x0, x28
	str	w2, [x0, 4]
	stp	x25, xzr, [x0, 8]
	cbz	w23, .L1504
	add	w2, w21, 1
	mov	w3, 56
	umaddl	x2, w2, w3, x19
	str	x2, [x0, 16]
.L1504:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w20, [x0, x1]
	mov	x0, 24
	mul	x1, x1, x0
	ldrb	w0, [x26, #:lo12:.LANCHOR25]
	cmp	w0, 1
	mov	w0, w20
	strb	w20, [x28, x1]
	bne	.L1505
	bl	NandcWaitFlashReady
.L1506:
	ldr	w0, [x29, 104]
	sub	w0, w0, #1
	cmp	w0, 7
	bhi	.L1507
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	ldrb	w0, [x0, w20, sxtw]
	cbz	w0, .L1507
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	add	x2, x0, 4
	mov	w3, 0
	ldrb	w1, [x0, 1]
	mov	w0, w20
	bl	HynixSetRRPara
.L1507:
	mov	w0, w20
	bl	NandcFlashCs
	cmp	w22, 1
	bne	.L1508
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L1508
	mov	w0, w20
	bl	flash_enter_slc_mode
.L1509:
	ldr	w1, [x29, 112]
	mov	w0, w20
	bl	FlashProgFirstCmd
	ldrb	w2, [x29, 108]
	mov	w1, 1
	ldp	x3, x4, [x25, 8]
	mov	w0, w20
	bl	NandcXferData
	cbz	w23, .L1510
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
	adrp	x0, .LANCHOR4
	ldr	w1, [x29, 112]
	ldr	w0, [x0, #:lo12:.LANCHOR4]
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
.L1510:
	ldr	w1, [x29, 112]
	mov	w0, w20
	add	w21, w21, w23
	bl	FlashProgSecondCmd
	mov	w0, w20
	bl	NandcFlashDeCs
	b	.L1501
.L1505:
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
	b	.L1506
.L1508:
	mov	w0, w20
	bl	flash_exit_slc_mode
	b	.L1509
.L1514:
	mov	w0, w20
	bl	FlashWaitCmdDone
	cmp	w22, 1
	bne	.L1513
	ldrb	w0, [x21]
	cbz	w0, .L1513
	mov	x0, 24
	mul	x0, x20, x0
	ldrb	w0, [x0, x23]
	bl	flash_exit_slc_mode
.L1513:
	add	x20, x20, 1
	b	.L1512
.L1515:
	mov	w0, 56
	and	w20, w24, 255
	adrp	x23, .LANCHOR198
	mov	x25, x23
	umaddl	x24, w24, w0, x19
.L1516:
	cmp	x24, x19
	beq	.L1523
	ldr	w0, [x19]
	cmn	w0, #1
	bne	.L1517
	ldr	w1, [x19, 4]
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	bl	printf
.L1518:
	sub	w20, w20, #1
	add	x19, x19, 56
	and	w20, w20, 255
	b	.L1516
.L1517:
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
	bne	.L1519
	ldr	w1, [x19, 4]
	adrp	x0, .LC30
	add	x0, x0, :lo12:.LC30
	bl	printf
	str	w26, [x19]
.L1519:
	ldr	x0, [x19, 16]
	cbz	x0, .L1520
	ldr	w2, [x0]
	ldr	x0, [x21, #:lo12:.LANCHOR199]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1520
	ldr	w1, [x19, 4]
	adrp	x0, .LC31
	add	x0, x0, :lo12:.LC31
	bl	printf
	mov	w0, -1
	str	w0, [x19]
.L1520:
	ldr	x0, [x19, 8]
	cbz	x0, .L1518
	ldr	w2, [x0]
	ldr	x0, [x25, #:lo12:.LANCHOR198]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1518
	ldr	w1, [x19, 4]
	adrp	x0, .LC32
	add	x0, x0, :lo12:.LC32
	bl	printf
	mov	w0, -1
	str	w0, [x19]
	b	.L1518
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
	bcc	.L1551
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
.L1549:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 160
	ret
.L1551:
	mov	w19, 0
	b	.L1549
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
	adrp	x0, .LANCHOR76
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	cbnz	w0, .L1576
	adrp	x23, .LANCHOR27
	and	w25, w1, 255
	adrp	x20, .LANCHOR15
	adrp	x1, .LANCHOR38
	ldrb	w0, [x23, #:lo12:.LANCHOR27]
	adrp	x21, .LANCHOR77
	str	w0, [x29, 136]
	mov	x8, 56
	adrp	x0, .LANCHOR73
	ldrb	w10, [x20, #:lo12:.LANCHOR15]
	ldrh	w11, [x1, #:lo12:.LANCHOR38]
	adrp	x7, .LANCHOR47
	str	w26, [x0, #:lo12:.LANCHOR73]
	adrp	x0, .LANCHOR189
	ldr	x6, [x21, #:lo12:.LANCHOR77]
	add	x7, x7, :lo12:.LANCHOR47
	ldr	x12, [x0, #:lo12:.LANCHOR189]
	adrp	x0, .LANCHOR58
	mov	w14, w8
	mov	x5, 0
	ldrh	w13, [x0, #:lo12:.LANCHOR58]
	mov	w24, 0
	mov	w19, 0
	str	x1, [x29, 128]
	str	x0, [x29, 120]
.L1555:
	cmp	w11, w5, uxth
	bhi	.L1559
	cbz	w24, .L1553
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
.L1562:
	ldr	x0, [x21, #:lo12:.LANCHOR77]
	add	x1, x0, x27
	ldr	w0, [x0, x27]
	cmn	w0, #1
	bne	.L1561
	ldr	w0, [x1, 4]
	add	w19, w19, 1
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.L1561:
	add	x27, x27, 56
	cmp	x27, x24
	bne	.L1562
	cbnz	w25, .L1563
	and	w22, w22, 65535
	mov	w28, 6
	mov	w27, 1
.L1564:
	adrp	x0, .LANCHOR47
	mov	w24, 0
	add	x0, x0, :lo12:.LANCHOR47
	str	x0, [x29, 112]
.L1572:
	ldr	x0, [x29, 128]
	mov	x5, 0
	ldr	x6, [x21, #:lo12:.LANCHOR77]
	mov	w20, 0
	mov	w12, 56
	ldrh	w7, [x0, #:lo12:.LANCHOR38]
	adrp	x0, .LANCHOR186
	ldr	x8, [x0, #:lo12:.LANCHOR186]
	adrp	x0, .LANCHOR187
	ldr	x10, [x0, #:lo12:.LANCHOR187]
	ldr	x0, [x29, 120]
	ldrh	w11, [x0, #:lo12:.LANCHOR58]
.L1565:
	cmp	w7, w5, uxth
	bhi	.L1568
	cbz	w20, .L1553
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
.L1571:
	ldr	x0, [x21, #:lo12:.LANCHOR77]
	add	x3, x0, x2
	ldr	w0, [x0, x2]
	cbz	w0, .L1570
	ldr	w0, [x3, 4]
	add	w19, w19, 1
	stp	x2, x1, [x29, 96]
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	ldp	x2, x1, [x29, 96]
.L1570:
	add	x2, x2, 56
	cmp	x1, x2
	bne	.L1571
	add	w24, w24, w28
	and	w24, w24, 65535
	cmp	w27, w24
	bhi	.L1572
	mov	x23, 0
.L1574:
	cbz	w25, .L1573
	ldr	x0, [x21, #:lo12:.LANCHOR77]
	add	x1, x0, x23
	ldr	w0, [x0, x23]
	cbnz	w0, .L1573
	ldr	w0, [x1, 4]
	mov	w1, 1
	str	x2, [x29, 136]
	lsr	w0, w0, 10
	bl	FtlFreeSysBlkQueueIn
	ldr	x2, [x29, 136]
.L1573:
	add	x23, x23, 56
	cmp	x23, x2
	bne	.L1574
	cmp	w26, 63
	ccmp	w25, 0, 0, hi
	beq	.L1553
	ldr	x0, [x21, #:lo12:.LANCHOR77]
	mov	w2, w20
	mov	w1, w22
	bl	FlashEraseBlocks
.L1553:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1559:
	mul	x0, x5, x8
	mov	w1, w26
	str	wzr, [x6, x0]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	and	w15, w0, 65535
	mov	w22, w15
	cbz	w25, .L1556
	bl	IsBlkInVendorPart
	cbnz	w0, .L1557
.L1556:
	mov	w0, w22
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L1558
	umaddl	x1, w24, w14, x6
	lsl	w15, w15, 10
	mul	w0, w24, w13
	add	w24, w24, 1
	and	w24, w24, 65535
	asr	w0, w0, 2
	str	w15, [x1, 4]
	add	x0, x12, x0, sxtw 2
	stp	xzr, x0, [x1, 8]
.L1557:
	add	x5, x5, 1
	b	.L1555
.L1558:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1557
.L1563:
	adrp	x0, .LANCHOR53
	ldrh	w27, [x0, #:lo12:.LANCHOR53]
	ldrb	w0, [x20, #:lo12:.LANCHOR15]
	cbnz	w0, .L1577
	lsr	w28, w27, 2
	mov	w22, 1
	b	.L1564
.L1577:
	mov	w22, 1
	mov	w28, w22
	b	.L1564
.L1568:
	mov	x0, 56
	mov	w1, w26
	mul	x0, x5, x0
	str	wzr, [x6, x0]
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, x5]
	bl	V2P_block
	and	w13, w0, 65535
	mov	w14, w13
	cbz	w25, .L1566
	bl	IsBlkInVendorPart
	cbnz	w0, .L1567
.L1566:
	mov	w0, w14
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L1567
	umaddl	x1, w20, w12, x6
	add	w13, w24, w13, lsl 10
	mul	w0, w20, w11
	add	w20, w20, 1
	and	w20, w20, 65535
	asr	w0, w0, 2
	str	w13, [x1, 4]
	add	x0, x10, x0, sxtw 2
	stp	x8, x0, [x1, 8]
.L1567:
	add	x5, x5, 1
	b	.L1565
.L1576:
	mov	w19, 0
	b	.L1553
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
	.section	.text.FtlBbmTblFlush,"ax",@progbits
	.align	2
	.global	FtlBbmTblFlush
	.type	FtlBbmTblFlush, %function
FtlBbmTblFlush:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR76
	stp	x19, x20, [sp, 16]
	ldr	w0, [x22, #:lo12:.LANCHOR76]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w0, .L1600
	adrp	x24, .LANCHOR188
	adrp	x23, .LANCHOR183
	adrp	x20, .LANCHOR203
	add	x19, x20, :lo12:.LANCHOR203
	ldr	x1, [x24, #:lo12:.LANCHOR188]
	adrp	x21, .LANCHOR74
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	add	x26, x21, :lo12:.LANCHOR74
	stp	x0, x1, [x19, 8]
	adrp	x1, .LANCHOR57
	adrp	x27, .LANCHOR45
	adrp	x28, .LANCHOR123
	ldrh	w2, [x1, #:lo12:.LANCHOR57]
	add	x26, x26, 32
	mov	w25, 0
	add	x27, x27, :lo12:.LANCHOR45
	add	x28, x28, :lo12:.LANCHOR123
	mov	w1, 0
	bl	ftl_memset
.L1601:
	ldrh	w0, [x27]
	cmp	w25, w0
	blt	.L1602
	add	x20, x20, :lo12:.LANCHOR203
	add	x19, x21, :lo12:.LANCHOR74
	mov	w2, 16
	mov	w1, 255
	adrp	x26, .LC33
	adrp	x27, .LANCHOR53
	ldr	x28, [x20, 16]
	add	x26, x26, :lo12:.LC33
	add	x27, x27, :lo12:.LANCHOR53
	mov	w25, 0
	mov	x0, x28
	bl	ftl_memset
	mov	w0, -3887
	strh	w0, [x28]
	ldr	w0, [x19, 8]
	str	w0, [x28, 4]
	ldrh	w0, [x21, #:lo12:.LANCHOR74]
	mov	w21, 0
	strh	w0, [x28, 2]
	ldrh	w0, [x19, 4]
	strh	w0, [x28, 8]
	ldrh	w0, [x19, 6]
	strh	w0, [x28, 10]
	adrp	x0, .LANCHOR37
	ldr	w0, [x0, #:lo12:.LANCHOR37]
	strh	w0, [x28, 12]
.L1603:
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
	mov	x0, x26
	bl	printf
	ldrh	w0, [x27]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	blt	.L1604
	ldr	w0, [x19, 8]
	mov	w2, 1
	ldrh	w1, [x19, 4]
	add	w0, w0, 1
	str	w0, [x19, 8]
	str	w0, [x28, 4]
	ldrh	w0, [x19]
	strh	w0, [x28, 8]
	strh	w0, [x19, 4]
	adrp	x0, .LANCHOR77
	strh	w1, [x19]
	lsl	w1, w1, 10
	ldr	x0, [x0, #:lo12:.LANCHOR77]
	str	w1, [x20, 4]
	strh	wzr, [x19, 2]
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashEraseBlocks
.L1604:
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
	bne	.L1605
	ldr	w1, [x20, 4]
	add	w21, w21, 1
	adrp	x0, .LC34
	and	w21, w21, 65535
	add	x0, x0, :lo12:.LC34
	bl	printf
	cmp	w21, 3
	bls	.L1603
	ldr	w1, [x20, 4]
	mov	w2, w21
	adrp	x0, .LC35
	add	x0, x0, :lo12:.LC35
	bl	printf
	mov	w0, 1
	str	w0, [x22, #:lo12:.LANCHOR76]
.L1600:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1602:
	ldrh	w2, [x28]
	ldr	x1, [x26], 8
	ldr	x0, [x19, 8]
	mul	w3, w2, w25
	lsl	w2, w2, 2
	add	w25, w25, 1
	add	x0, x0, x3, sxtw 2
	bl	ftl_memcpy
	b	.L1601
.L1605:
	add	w25, w25, 1
	cmp	w25, 1
	beq	.L1603
	cmp	w0, 256
	beq	.L1603
	b	.L1600
	.size	FtlBbmTblFlush, .-FtlBbmTblFlush
	.section	.text.allocate_data_superblock,"ax",@progbits
	.align	2
	.global	allocate_data_superblock
	.type	allocate_data_superblock, %function
allocate_data_superblock:
	adrp	x1, .LANCHOR76
	ldr	w1, [x1, #:lo12:.LANCHOR76]
	cbnz	w1, .L1679
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x27, x28, [sp, 80]
	adrp	x27, .LANCHOR85
	add	x0, x27, :lo12:.LANCHOR85
	stp	x23, x24, [sp, 48]
	str	x0, [x29, 120]
	adrp	x0, .LANCHOR88
	add	x23, x0, :lo12:.LANCHOR88
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
.L1670:
	ldr	x1, [x29, 120]
	adrp	x0, .LANCHOR88
	adrp	x24, .LANCHOR40
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	ldrh	w1, [x1]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR40]
	cmp	w0, w1
	ble	.L1618
	mov	w2, 3164
	adrp	x1, .LANCHOR204
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR204
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1618:
	adrp	x0, .LANCHOR93
	add	x0, x0, :lo12:.LANCHOR93
	cmp	x19, x0
	bne	.L1619
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
	cbz	w4, .L1620
	adrp	x4, .LANCHOR170
	ldr	w4, [x4, #:lo12:.LANCHOR170]
	cmp	w4, 39
	bhi	.L1620
	cmp	w4, 2
	bls	.L1654
	tbz	x2, 0, .L1650
	cbz	w3, .L1654
.L1650:
	mov	w1, w0
	b	.L1620
.L1619:
	ldrb	w0, [x19, 8]
	cmp	w0, 1
	bne	.L1654
	adrp	x0, .LANCHOR44
	ldrh	w0, [x0, #:lo12:.LANCHOR44]
	cmp	w0, 1
	beq	.L1654
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbnz	w0, .L1654
	adrp	x2, .LANCHOR28
	ldrh	w0, [x23]
	ldr	w2, [x2, #:lo12:.LANCHOR28]
	lsr	w1, w0, 3
	cbz	w2, .L1620
	adrp	x2, .LANCHOR170
	ldr	w2, [x2, #:lo12:.LANCHOR170]
	cmp	w2, 1
	bhi	.L1620
	mov	w1, 7
	mul	w1, w0, w1
	lsr	w1, w1, 3
.L1620:
	cbz	w1, .L1621
	sub	w1, w1, #1
	and	w1, w1, 65535
.L1621:
	ldrb	w2, [x19, 8]
	adrp	x0, .LANCHOR87
	add	x0, x0, :lo12:.LANCHOR87
	bl	List_pop_index_node
	and	w22, w0, 65535
	ldrh	w0, [x23]
	cbnz	w0, .L1622
	mov	w2, 3184
	adrp	x1, .LANCHOR204
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR204
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1622:
	ldrh	w0, [x23]
	sub	w0, w0, #1
	strh	w0, [x23]
	ldrh	w0, [x24, #:lo12:.LANCHOR40]
	cmp	w0, w22
	bls	.L1670
	adrp	x25, .LANCHOR83
	ubfiz	x21, x22, 1, 16
	ldr	x0, [x25, #:lo12:.LANCHOR83]
	ldrh	w20, [x0, x21]
	cbnz	w20, .L1670
	strh	w22, [x19]
	mov	x0, x19
	bl	make_superblock
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1624
	ldr	x0, [x25, #:lo12:.LANCHOR83]
	mov	w1, -1
	strh	w1, [x0, x21]
	ldrh	w1, [x27, #:lo12:.LANCHOR85]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR40]
	cmp	w0, w1
	ble	.L1670
	mov	w2, 3200
	adrp	x1, .LANCHOR204
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR204
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
	b	.L1670
.L1654:
	mov	w1, 0
	b	.L1621
.L1624:
	ldrh	w1, [x27, #:lo12:.LANCHOR85]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR40]
	cmp	w0, w1
	ble	.L1626
	mov	w2, 3203
	adrp	x1, .LANCHOR204
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR204
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1626:
	adrp	x1, .LANCHOR38
	adrp	x25, .LANCHOR77
	mov	w2, 56
	mov	x3, 8
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	add	x26, x19, 16
	ldr	x4, [x25, #:lo12:.LANCHOR77]
	mov	x5, x26
	mov	w6, 65535
	add	x0, x4, 8
	umaddl	x1, w2, w1, x3
	add	x1, x4, x1
.L1627:
	cmp	x1, x0
	bne	.L1629
	cbnz	w20, .L1630
	mov	w2, 3215
	adrp	x1, .LANCHOR204
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR204
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1630:
	adrp	x0, .LANCHOR28
	adrp	x28, .LANCHOR78
	ldr	w0, [x0, #:lo12:.LANCHOR28]
	cbz	w0, .L1631
	adrp	x0, .LANCHOR91
	add	x0, x0, :lo12:.LANCHOR91
	cmp	x19, x0
	bne	.L1631
	ldr	x0, [x28, #:lo12:.LANCHOR78]
	ldrh	w0, [x0, x21]
	cmp	w0, 40
	bls	.L1631
	strb	wzr, [x19, 8]
.L1631:
	adrp	x0, .LANCHOR205
	ldrh	w0, [x0, #:lo12:.LANCHOR205]
	cmp	w0, w22
	bne	.L1632
	mov	w2, 3222
	adrp	x1, .LANCHOR204
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR204
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1632:
	ldrb	w0, [x19, 8]
	adrp	x6, .LANCHOR48
	adrp	x5, .LANCHOR167
	adrp	x4, .LANCHOR168
	ldr	x1, [x28, #:lo12:.LANCHOR78]
	cbnz	w0, .L1633
	ldrh	w0, [x1, x21]
	cbz	w0, .L1634
	ldrh	w2, [x6, #:lo12:.LANCHOR48]
	add	w0, w0, w2
.L1682:
	strh	w0, [x1, x21]
	mov	w1, 0
	ldr	w0, [x5, #:lo12:.LANCHOR167]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR167]
	mov	w0, w22
	bl	ftl_set_blk_mode
.L1636:
	ldr	x0, [x28, #:lo12:.LANCHOR78]
	ldrh	w1, [x0, x21]
	adrp	x0, .LANCHOR169
	ldr	w2, [x0, #:lo12:.LANCHOR169]
	cmp	w1, w2
	bls	.L1637
	str	w1, [x0, #:lo12:.LANCHOR169]
.L1637:
	ldr	w2, [x5, #:lo12:.LANCHOR167]
	mov	x3, 4
	ldr	w1, [x4, #:lo12:.LANCHOR168]
	ldrh	w0, [x6, #:lo12:.LANCHOR48]
	madd	w0, w0, w2, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR40]
	udiv	w0, w0, w1
	adrp	x1, .LANCHOR206
	str	w0, [x1, #:lo12:.LANCHOR206]
	adrp	x0, .LANCHOR191
	ldr	x1, [x0, #:lo12:.LANCHOR191]
	ldr	w0, [x1, 16]
	add	w0, w0, 1
	str	w0, [x1, 16]
	mov	w1, 56
	ldr	x0, [x25, #:lo12:.LANCHOR77]
	nop // between mem op and mult-accumulate
	umaddl	x1, w1, w20, x3
	add	x2, x0, 4
	add	x1, x0, x1
.L1638:
	cmp	x1, x2
	bne	.L1639
	adrp	x1, .LANCHOR15
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	cbz	w1, .L1640
	ldrb	w1, [x19, 8]
	mov	w2, w20
	cmp	w1, 1
	bne	.L1641
	mov	w1, 0
.L1683:
	bl	FlashEraseBlocks
.L1640:
	ldrb	w1, [x19, 8]
	mov	w2, w20
	ldr	x0, [x25, #:lo12:.LANCHOR77]
	mov	x24, 0
	bl	FlashEraseBlocks
	mov	w1, 0
	mov	x3, 56
.L1642:
	cmp	w20, w24, uxth
	bhi	.L1644
	cbz	w1, .L1645
	mov	w0, w22
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1645:
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1646
	adrp	x0, .LANCHOR83
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	strh	w1, [x0, x21]
	b	.L1670
.L1629:
	ldrh	w3, [x5]
	stp	xzr, xzr, [x0]
	cmp	w3, w6
	beq	.L1628
	umaddl	x7, w20, w2, x4
	add	w20, w20, 1
	and	w20, w20, 65535
	lsl	w3, w3, 10
	str	w3, [x7, 4]
.L1628:
	add	x0, x0, 56
	add	x5, x5, 2
	b	.L1627
.L1634:
	mov	w0, 2
	b	.L1682
.L1633:
	ldrh	w0, [x1, x21]
	add	w0, w0, 1
	strh	w0, [x1, x21]
	ldr	w0, [x4, #:lo12:.LANCHOR168]
	add	w0, w0, 1
	str	w0, [x4, #:lo12:.LANCHOR168]
	mov	w0, w22
	bl	ftl_set_blk_mode.part.10
	b	.L1636
.L1639:
	ldr	w3, [x2]
	and	w3, w3, -1024
	str	w3, [x2], 56
	b	.L1638
.L1641:
	mov	w1, 1
	b	.L1683
.L1644:
	mul	x0, x24, x3
	ldr	x2, [x25, #:lo12:.LANCHOR77]
	add	x4, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L1643
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
.L1643:
	add	x24, x24, 1
	add	x26, x26, 2
	b	.L1642
.L1646:
	adrp	x1, .LANCHOR52
	adrp	x2, .LANCHOR159
	strh	wzr, [x19, 2]
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	strh	w22, [x19]
	strb	wzr, [x19, 6]
	mul	w0, w0, w1
	ldr	w1, [x2, #:lo12:.LANCHOR159]
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x2, #:lo12:.LANCHOR159]
	adrp	x1, .LANCHOR83
	and	w0, w0, 65535
	strh	w0, [x19, 4]
	ldr	x1, [x1, #:lo12:.LANCHOR83]
	strh	w0, [x1, x21]
	ldrh	w0, [x19, 4]
	cbz	w0, .L1647
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1617
.L1647:
	mov	w2, 3281
	adrp	x1, .LANCHOR204
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR204
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1617:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1679:
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
	adrp	x21, .LANCHOR116
	stp	x25, x26, [sp, 64]
	and	w25, w0, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR116]
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	str	x27, [sp, 80]
	cbz	w0, .L1685
	adrp	x23, .LANCHOR117
	add	x24, x23, :lo12:.LANCHOR117
	mov	w19, 0
.L1686:
	adrp	x0, .LANCHOR38
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w0, w19
	bhi	.L1692
	bl	FtlGcReFreshBadBlk
.L1685:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1692:
	adrp	x0, .LANCHOR47
	add	x0, x0, :lo12:.LANCHOR47
	mov	w1, w25
	add	x22, x21, :lo12:.LANCHOR116
	mov	w20, 0
	ldrb	w0, [x0, w19, sxtw]
	bl	V2P_block
	and	w26, w0, 65535
.L1687:
	ldrh	w0, [x22]
	cmp	w0, w20
	bhi	.L1691
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1686
.L1691:
	add	x0, x23, :lo12:.LANCHOR117
	add	w27, w20, 1
	ldrh	w0, [x0, w20, sxtw 1]
	cmp	w0, w26
	bne	.L1688
	mov	w0, w26
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	w1, [x22]
	sxtw	x3, w27
	and	x4, x20, 65535
	mov	x0, 0
.L1689:
	add	w2, w20, w0
	cmp	w1, w2, uxth
	bhi	.L1690
	sub	w1, w1, #1
	strh	w1, [x22]
.L1688:
	and	w20, w27, 65535
	b	.L1687
.L1690:
	add	x2, x3, x0
	ldrh	w5, [x24, x2, lsl 1]
	add	x2, x4, x0
	add	x0, x0, 1
	strh	w5, [x24, x2, lsl 1]
	b	.L1689
	.size	FtlGcFreeBadSuperBlk, .-FtlGcFreeBadSuperBlk
	.section	.text.update_vpc_list,"ax",@progbits
	.align	2
	.global	update_vpc_list
	.type	update_vpc_list, %function
update_vpc_list:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LANCHOR83
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	and	w19, w0, 65535
	ldr	x1, [x1, #:lo12:.LANCHOR83]
	ubfiz	x0, x19, 1, 16
	ldrh	w0, [x1, x0]
	cbnz	w0, .L1698
	adrp	x0, .LANCHOR205
	ldrh	w1, [x0, #:lo12:.LANCHOR205]
	cmp	w1, w19
	bne	.L1699
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR205]
.L1700:
	adrp	x20, .LANCHOR85
	mov	w1, w19
	adrp	x0, .LANCHOR82
	add	x0, x0, :lo12:.LANCHOR82
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR85]
	cbnz	w0, .L1702
	mov	w2, 3392
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
.L1702:
	ldrh	w0, [x20, #:lo12:.LANCHOR85]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR85]
	mov	w0, w19
	bl	free_data_superblock
	mov	w0, w19
	bl	FtlGcFreeBadSuperBlk
	adrp	x0, .LANCHOR88
	ldrh	w1, [x20, #:lo12:.LANCHOR85]
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	add	w0, w0, w1
	adrp	x1, .LANCHOR40
	ldrh	w1, [x1, #:lo12:.LANCHOR40]
	cmp	w0, w1
	ble	.L1706
	mov	w2, 3395
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
.L1706:
	mov	w0, 1
	b	.L1697
.L1699:
	adrp	x0, .LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w0, w19
	beq	.L1705
	adrp	x0, .LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w0, w19
	beq	.L1705
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w0, w19
	bne	.L1700
.L1705:
	mov	w0, 0
.L1697:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1698:
	mov	w0, w19
	bl	List_update_data_list
	b	.L1705
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
	beq	.L1709
	adrp	x20, .LANCHOR83
	ubfiz	x21, x19, 1, 16
	ldr	x1, [x20, #:lo12:.LANCHOR83]
	ldrh	w0, [x1, x21]
	cbnz	w0, .L1710
	mov	w2, 0
	mov	w1, w19
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR83]
	ldrh	w0, [x0, x21]
	cbnz	w0, .L1711
	mov	w2, 3410
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
.L1711:
	ldr	x0, [x20, #:lo12:.LANCHOR83]
	adrp	x6, .LANCHOR87
	add	x6, x6, :lo12:.LANCHOR87
	mov	w1, 32
	strh	w1, [x0, x21]
	mov	w1, w19
	mov	x0, x6
	bl	test_node_in_list
	cbz	w0, .L1712
	adrp	x22, .LANCHOR88
	mov	w1, w19
	mov	x0, x6
	bl	List_remove_node
	ldrh	w0, [x22, #:lo12:.LANCHOR88]
	cbnz	w0, .L1713
	mov	w2, 3414
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
.L1713:
	ldrh	w0, [x22, #:lo12:.LANCHOR88]
	sub	w0, w0, #1
	strh	w0, [x22, #:lo12:.LANCHOR88]
	mov	w0, w19
	bl	INSERT_DATA_LIST
	ldr	x0, [x20, #:lo12:.LANCHOR83]
	mov	w1, w19
	ldrh	w2, [x0, x21]
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	bl	printf
.L1712:
	mov	w0, w19
	bl	FtlGcRefreshBlock
.L1716:
	mov	w20, 0
	b	.L1708
.L1710:
	sub	w0, w0, #1
	strh	w0, [x1, x21]
.L1709:
	adrp	x21, .LANCHOR133
	mov	w1, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR133]
	cmp	w0, w1
	bne	.L1715
	strh	w19, [x21, #:lo12:.LANCHOR133]
	b	.L1716
.L1715:
	cmp	w19, w0
	beq	.L1716
	bl	update_vpc_list
	cmp	w0, 0
	adrp	x1, .LANCHOR81
	adrp	x0, .LANCHOR82
	strh	w19, [x21, #:lo12:.LANCHOR133]
	cset	w20, ne
	ldr	x1, [x1, #:lo12:.LANCHOR81]
	ldr	x0, [x0, #:lo12:.LANCHOR82]
	sub	x0, x0, x1
	mov	x1, -6148914691236517206
	asr	x0, x0, 1
	movk	x1, 0xaaab, lsl 0
	mul	x0, x0, x1
	adrp	x1, .LANCHOR83
	ldr	x1, [x1, #:lo12:.LANCHOR83]
	and	x2, x0, 65535
	ldrh	w1, [x1, x2, lsl 1]
	cbnz	w1, .L1708
	cmp	w19, w0, uxth
	beq	.L1708
	mov	w2, 3435
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
.L1708:
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
	cbz	w1, .L1733
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, 65535
	ldrh	w1, [x0]
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	cmp	w1, w20
	beq	.L1721
	mov	x19, x0
	ldrb	w0, [x0, 6]
	adrp	x22, .LANCHOR15
	adrp	x21, .LANCHOR120
	add	x0, x0, 8
	add	x23, x22, :lo12:.LANCHOR15
	add	x21, x21, :lo12:.LANCHOR120
	ldrh	w0, [x19, x0, lsl 1]
.L1725:
	cmp	w0, w20
	beq	.L1727
	ldrb	w0, [x19, 8]
	cmp	w0, 1
	bne	.L1728
	ldrb	w1, [x23]
	cbnz	w1, .L1728
	ldrh	w1, [x19, 2]
	ldrh	w1, [x21, x1, lsl 1]
	cmp	w1, w20
	bne	.L1728
	ldrh	w0, [x19, 4]
	sub	w0, w0, #1
	strh	w0, [x19, 4]
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1727
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
.L1736:
	strh	w0, [x19, 2]
	strb	wzr, [x19, 6]
.L1721:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1727:
	ldrb	w0, [x19, 6]
	adrp	x1, .LANCHOR38
	add	w0, w0, 1
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	and	w0, w0, 255
	strb	w0, [x19, 6]
	cmp	w1, w0
	bne	.L1726
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L1726:
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w0, [x19, x0, lsl 1]
	b	.L1725
.L1728:
	ldrb	w1, [x22, #:lo12:.LANCHOR15]
	cbz	w1, .L1721
	cmp	w0, 1
	bne	.L1721
	adrp	x0, .LANCHOR53
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bcc	.L1721
	ldrh	w0, [x19]
	adrp	x1, .LANCHOR83
	ldrh	w3, [x19, 4]
	ldr	x2, [x1, #:lo12:.LANCHOR83]
	lsl	x0, x0, 1
	ldrh	w1, [x2, x0]
	sub	w1, w1, w3
	strh	w1, [x2, x0]
	adrp	x0, .LANCHOR52
	strh	wzr, [x19, 4]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	b	.L1736
.L1733:
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
	bne	.L1738
	mov	w2, 3332
	adrp	x1, .LANCHOR209
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR209
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1738:
	adrp	x20, .LANCHOR52
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bne	.L1739
	mov	w2, 3333
	adrp	x1, .LANCHOR209
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR209
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1739:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1740
	mov	w2, 3334
	adrp	x1, .LANCHOR209
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR209
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1740:
	ldrb	w0, [x19, 6]
	adrp	x21, .LANCHOR38
	strb	wzr, [x19, 10]
	adrp	x23, .LANCHOR15
	add	x0, x0, 8
	adrp	x24, .LANCHOR120
	add	x23, x23, :lo12:.LANCHOR15
	add	x24, x24, :lo12:.LANCHOR120
	add	x25, x21, :lo12:.LANCHOR38
	ldrh	w22, [x19, x0, lsl 1]
.L1741:
	mov	w2, 65535
	cmp	w22, w2
	beq	.L1742
	ldrb	w0, [x19, 8]
	ldrh	w1, [x19, 4]
	cmp	w0, 1
	ldrh	w0, [x19, 2]
	bne	.L1744
	ldrb	w3, [x23]
	cbnz	w3, .L1744
	ldrh	w3, [x24, w0, sxtw 1]
	cmp	w3, w2
	bne	.L1744
	ldrh	w0, [x19]
	sub	w1, w1, #1
	strh	w1, [x19, 4]
	bl	decrement_vpc_count
.L1742:
	ldrb	w0, [x19, 6]
	ldrh	w1, [x25]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x19, 6]
	cmp	w1, w0
	bne	.L1743
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L1743:
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w22, [x19, x0, lsl 1]
	b	.L1741
.L1744:
	adrp	x23, .LANCHOR15
	adrp	x24, .LANCHOR120
	orr	w22, w0, w22, lsl 10
	add	x23, x23, :lo12:.LANCHOR15
	add	x24, x24, :lo12:.LANCHOR120
	sub	w1, w1, #1
	strh	w1, [x19, 4]
.L1745:
	ldrb	w0, [x19, 6]
	mov	w1, 65535
	ldrh	w3, [x21, #:lo12:.LANCHOR38]
.L1747:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, w3
	bne	.L1746
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	w0, 0
.L1746:
	add	x2, x19, x0, sxtw 1
	ldrh	w2, [x2, 16]
	cmp	w2, w1
	beq	.L1747
	strb	w0, [x19, 6]
	ldrb	w0, [x19, 8]
	cmp	w0, 1
	bne	.L1748
	ldrb	w2, [x23]
	ldrh	w0, [x19, 2]
	cbnz	w2, .L1749
	ldrh	w0, [x24, w0, sxtw 1]
	cmp	w0, w1
	bne	.L1748
	ldrh	w0, [x19, 4]
	cbz	w0, .L1748
	sub	w0, w0, #1
	strh	w0, [x19, 4]
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	b	.L1745
.L1749:
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w0, w1
	bcc	.L1748
	ldrh	w0, [x19]
	adrp	x1, .LANCHOR83
	ldrh	w3, [x19, 4]
	ldr	x2, [x1, #:lo12:.LANCHOR83]
	lsl	x0, x0, 1
	ldrh	w1, [x2, x0]
	sub	w1, w1, w3
	strh	w1, [x2, x0]
	strh	wzr, [x19, 4]
	ldrh	w0, [x20, #:lo12:.LANCHOR52]
	strh	w0, [x19, 2]
	strb	wzr, [x19, 6]
.L1748:
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bne	.L1737
	ldrh	w0, [x19, 4]
	cbz	w0, .L1737
	mov	w2, 3378
	adrp	x1, .LANCHOR209
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR209
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1737:
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
	stp	x29, x30, [sp, -128]!
	adrp	x0, .LANCHOR76
	add	x29, sp, 0
	ldr	w1, [x0, #:lo12:.LANCHOR76]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	str	x0, [x29, 112]
	cbnz	w1, .L1762
	adrp	x25, .LANCHOR188
	adrp	x27, .LANCHOR210
	adrp	x23, .LANCHOR183
	adrp	x20, .LANCHOR203
	ldr	x19, [x25, #:lo12:.LANCHOR188]
	add	x22, x20, :lo12:.LANCHOR203
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	add	x1, x27, :lo12:.LANCHOR210
	ldrh	w2, [x27, #:lo12:.LANCHOR210]
	mov	w3, 19539
	stp	x0, x19, [x22, 8]
	movk	w3, 0x4654, lsl 16
	strh	w2, [x19, 2]
	mov	w2, -3932
	strh	w2, [x19]
	adrp	x24, .LANCHOR159
	ldr	w2, [x1, 8]
	adrp	x26, .LANCHOR57
	ldrh	w1, [x1, 6]
	stp	w2, wzr, [x19, 4]
	adrp	x2, .LANCHOR80
	add	x21, x2, :lo12:.LANCHOR80
	str	wzr, [x19, 12]
	str	w3, [x2, #:lo12:.LANCHOR80]
	mov	w2, 87
	movk	w2, 0x5000, lsl 16
	strh	w1, [x21, 8]
	adrp	x1, .LANCHOR45
	str	w2, [x21, 4]
	adrp	x2, .LANCHOR91
	ldrh	w1, [x1, #:lo12:.LANCHOR45]
	strb	w1, [x21, 10]
	add	x1, x2, :lo12:.LANCHOR91
	ldrh	w2, [x2, #:lo12:.LANCHOR91]
	strh	w2, [x21, 14]
	ldrb	w3, [x1, 6]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x21, 11]
	orr	w2, w3, w2, lsl 6
	strh	w2, [x21, 16]
	adrp	x2, .LANCHOR92
	add	x1, x2, :lo12:.LANCHOR92
	ldrh	w2, [x2, #:lo12:.LANCHOR92]
	ldrb	w3, [x1, 6]
	strh	w2, [x21, 18]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x21, 12]
	orr	w2, w3, w2, lsl 6
	strh	w2, [x21, 20]
	adrp	x2, .LANCHOR93
	add	x1, x2, :lo12:.LANCHOR93
	ldrh	w2, [x2, #:lo12:.LANCHOR93]
	strh	w2, [x21, 22]
	ldrb	w3, [x1, 6]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x21, 13]
	adrp	x1, .LANCHOR167
	orr	w2, w3, w2, lsl 6
	strh	w2, [x21, 24]
	ldr	w1, [x1, #:lo12:.LANCHOR167]
	str	w1, [x21, 32]
	ldr	w1, [x24, #:lo12:.LANCHOR159]
	str	w1, [x21, 40]
	adrp	x1, .LANCHOR160
	ldrh	w2, [x26, #:lo12:.LANCHOR57]
	ldr	w1, [x1, #:lo12:.LANCHOR160]
	str	w1, [x21, 36]
	adrp	x1, .LANCHOR112
	ldrh	w1, [x1, #:lo12:.LANCHOR112]
	strh	w1, [x21, 44]
	adrp	x1, .LANCHOR113
	ldrh	w1, [x1, #:lo12:.LANCHOR113]
	strh	w1, [x21, 46]
	mov	w1, 255
	bl	ftl_memset
	ldr	x0, [x22, 8]
	mov	x1, x21
	mov	w2, 48
	adrp	x21, .LANCHOR40
	bl	ftl_memcpy
	adrp	x1, .LANCHOR83
	ldrh	w2, [x21, #:lo12:.LANCHOR40]
	ldr	x0, [x22, 8]
	ldr	x1, [x1, #:lo12:.LANCHOR83]
	lsl	w2, w2, 1
	add	x0, x0, 48
	bl	ftl_memcpy
	ldrh	w0, [x21, #:lo12:.LANCHOR40]
	adrp	x1, .LANCHOR1
	ldr	x3, [x22, 8]
	ldr	x1, [x1, #:lo12:.LANCHOR1]
	lsr	w2, w0, 3
	ubfiz	x0, x0, 1, 16
	add	x0, x0, 48
	add	w2, w2, 4
	and	x0, x0, -4
	add	x0, x3, x0
	bl	ftl_memcpy
	adrp	x0, .LANCHOR69
	str	x26, [x29, 104]
	ldrh	w0, [x0, #:lo12:.LANCHOR69]
	cbz	w0, .L1763
	ldrh	w0, [x21, #:lo12:.LANCHOR40]
	adrp	x1, .LANCHOR66
	ldr	x3, [x22, 8]
	ldrh	w2, [x1, #:lo12:.LANCHOR66]
	lsr	w1, w0, 3
	add	w0, w1, w0, lsl 1
	adrp	x1, .LANCHOR131
	add	w0, w0, 52
	lsl	w2, w2, 2
	ldr	x1, [x1, #:lo12:.LANCHOR131]
	and	x0, x0, 65532
	add	x0, x3, x0
	bl	ftl_memcpy
.L1763:
	mov	w0, 0
	bl	FtlUpdateVaildLpn
	adrp	x0, .LANCHOR2
	add	x22, x20, :lo12:.LANCHOR203
	add	x0, x0, :lo12:.LANCHOR2
	add	x28, x27, :lo12:.LANCHOR210
	str	x0, [x29, 120]
	adrp	x27, .LANCHOR53
	mov	w21, 0
	add	x0, x27, :lo12:.LANCHOR53
	mov	w26, 65535
	str	x0, [x29, 96]
.L1764:
	ldrh	w2, [x28, 2]
	ldrh	w1, [x28]
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	str	x0, [x22, 8]
	ldr	x0, [x25, #:lo12:.LANCHOR188]
	str	x0, [x22, 16]
	orr	w0, w2, w1, lsl 10
	str	w0, [x22, 4]
	ldrh	w0, [x27, #:lo12:.LANCHOR53]
	sub	w0, w0, #1
	cmp	w2, w0
	blt	.L1765
	ldrh	w26, [x28, 4]
	strh	wzr, [x28, 2]
	strh	w1, [x28, 4]
	bl	FtlFreeSysBlkQueueOut
	ldr	w1, [x24, #:lo12:.LANCHOR159]
	str	w1, [x28, 8]
	add	w2, w1, 1
	str	w2, [x24, #:lo12:.LANCHOR159]
	ubfiz	w2, w0, 10, 16
	str	w2, [x22, 4]
	strh	w0, [x28]
	strh	w0, [x19, 2]
	str	w1, [x19, 4]
.L1765:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cbz	w0, .L1766
	ldr	x0, [x29, 104]
	ldrh	w1, [x0, #:lo12:.LANCHOR57]
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	bl	js_hash
	str	w0, [x19, 12]
.L1766:
	mov	w3, 1
	mov	x0, x22
	mov	w1, w3
	mov	w2, w3
	bl	FlashProgPages
	ldrh	w0, [x28, 2]
	ldr	w1, [x22]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x28, 2]
	cmn	w1, #1
	bne	.L1767
	cmp	w0, 1
	bne	.L1768
	mov	w2, 1219
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
.L1768:
	ldrh	w0, [x28, 2]
	cmp	w0, 1
	bne	.L1769
	ldr	x0, [x29, 96]
	ldrh	w0, [x0]
	sub	w0, w0, #1
	strh	w0, [x28, 2]
.L1769:
	add	w21, w21, 1
	and	w21, w21, 65535
	cmp	w21, 3
	bls	.L1764
	add	x20, x20, :lo12:.LANCHOR203
	mov	w2, w21
	adrp	x0, .LC38
	add	x0, x0, :lo12:.LC38
	ldr	w1, [x20, 4]
	bl	printf
	ldr	x1, [x29, 112]
	mov	w0, 1
	str	w0, [x1, #:lo12:.LANCHOR76]
.L1762:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1767:
	cmp	w0, 1
	beq	.L1764
	cmp	w1, 256
	beq	.L1764
	mov	w0, 65535
	cmp	w26, w0
	beq	.L1762
	mov	w1, 1
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
	b	.L1762
	.size	FtlVpcTblFlush, .-FtlVpcTblFlush
	.section	.text.FtlSuperblockPowerLostFix,"ax",@progbits
	.align	2
	.global	FtlSuperblockPowerLostFix
	.type	FtlSuperblockPowerLostFix, %function
FtlSuperblockPowerLostFix:
	stp	x29, x30, [sp, -128]!
	adrp	x1, .LANCHOR76
	add	x29, sp, 0
	str	x23, [sp, 48]
	ldr	w23, [x1, #:lo12:.LANCHOR76]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	cbnz	w23, .L1785
	adrp	x1, .LANCHOR15
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	cbz	w1, .L1796
	ldrb	w1, [x0, 8]
	cmp	w1, 1
	bne	.L1796
	ldrh	w21, [x0, 4]
	mov	w23, w1
.L1787:
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
.L1788:
	sub	w21, w21, #1
	cmn	w21, #1
	beq	.L1791
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1789
.L1791:
	ldrh	w0, [x19]
	adrp	x1, .LANCHOR83
	ldrh	w3, [x19, 4]
	ldr	x2, [x1, #:lo12:.LANCHOR83]
	lsl	x0, x0, 1
	ldrh	w1, [x2, x0]
	sub	w1, w1, w3
	strh	w1, [x2, x0]
	adrp	x0, .LANCHOR52
	strb	wzr, [x19, 6]
	strh	wzr, [x19, 4]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	strh	w0, [x19, 2]
.L1785:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 128
	ret
.L1796:
	mov	w21, 12
	b	.L1787
.L1789:
	mov	x0, x19
	bl	get_new_active_ppa
	str	w0, [x29, 76]
	cmn	w0, #1
	beq	.L1791
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
	b	.L1788
	.size	FtlSuperblockPowerLostFix, .-FtlSuperblockPowerLostFix
	.section	.text.FtlLoadFactoryBbt,"ax",@progbits
	.align	2
	.global	FtlLoadFactoryBbt
	.type	FtlLoadFactoryBbt, %function
FtlLoadFactoryBbt:
	stp	x29, x30, [sp, -112]!
	adrp	x2, .LANCHOR183
	adrp	x0, .LANCHOR203
	add	x1, x0, :lo12:.LANCHOR203
	add	x29, sp, 0
	ldr	x2, [x2, #:lo12:.LANCHOR183]
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR51
	stp	x27, x28, [sp, 80]
	add	x28, x26, :lo12:.LANCHOR51
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR74
	stp	x23, x24, [sp, 48]
	add	x20, x20, :lo12:.LANCHOR74
	str	x2, [x1, 8]
	adrp	x2, .LANCHOR188
	adrp	x23, .LANCHOR45
	add	x20, x20, 12
	ldr	x25, [x2, #:lo12:.LANCHOR188]
	add	x23, x23, :lo12:.LANCHOR45
	mov	w21, 0
	mov	w27, -1
	str	x25, [x1, 16]
.L1802:
	ldrh	w0, [x23]
	cmp	w21, w0
	bcc	.L1807
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1807:
	ldrh	w19, [x26, #:lo12:.LANCHOR51]
	add	x24, x22, :lo12:.LANCHOR203
	strh	w27, [x20]
	mov	w3, 61664
	sub	w19, w19, #1
	and	w19, w19, 65535
.L1803:
	ldrh	w0, [x28]
	sub	w1, w0, #15
	cmp	w1, w19
	bgt	.L1805
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
	beq	.L1804
	ldrh	w0, [x25]
	cmp	w0, w3
	bne	.L1804
	strh	w19, [x20]
.L1805:
	add	w21, w21, 1
	add	x20, x20, 2
	b	.L1802
.L1804:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1803
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
	bne	.L1813
	adrp	x1, .LANCHOR53
	ldrh	w19, [x1, #:lo12:.LANCHOR53]
.L1814:
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
	bne	.L1815
	mov	w22, 0
	mov	w24, 2
.L1816:
	cmp	w22, w19
	ble	.L1819
.L1815:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 192
	ret
.L1813:
	adrp	x1, .LANCHOR52
	ldrh	w19, [x1, #:lo12:.LANCHOR52]
	b	.L1814
.L1819:
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
	bne	.L1817
	ldr	w0, [x29, 132]
	cmn	w0, #1
	bne	.L1817
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L1817
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L1816
.L1817:
	add	w20, w20, 1
	sxth	w22, w20
	b	.L1816
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
	adrp	x22, .LANCHOR203
	add	x20, x22, :lo12:.LANCHOR203
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
.L1825:
	ldrh	w0, [x24]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L1828
	lsl	w0, w19, 10
	mov	w2, 1
	str	w0, [x20, 4]
	mov	w1, w2
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L1826
	ldr	w0, [x20, 4]
	mov	w2, 1
	mov	w1, w2
	add	w0, w0, 1
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
.L1826:
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L1827
	ldrh	w0, [x21]
	cmp	w0, w25
	bne	.L1827
	adrp	x1, .LANCHOR74
	add	x0, x1, :lo12:.LANCHOR74
	strh	w19, [x1, #:lo12:.LANCHOR74]
	ldr	w1, [x21, 4]
	str	w1, [x0, 8]
	ldrh	w1, [x21, 8]
	strh	w1, [x0, 4]
.L1828:
	adrp	x19, .LANCHOR74
	mov	w0, 65535
	add	x20, x19, :lo12:.LANCHOR74
	ldrh	w1, [x19, #:lo12:.LANCHOR74]
	cmp	w1, w0
	beq	.L1842
	ldrh	w1, [x20, 4]
	cmp	w1, w0
	beq	.L1832
	add	x0, x22, :lo12:.LANCHOR203
	lsl	w1, w1, 10
	mov	w2, 1
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashReadPages
	ldr	w0, [x22, #:lo12:.LANCHOR203]
	cmn	w0, #1
	beq	.L1832
	ldrh	w1, [x21]
	mov	w0, 61649
	cmp	w1, w0
	bne	.L1832
	ldr	w1, [x20, 8]
	ldr	w0, [x21, 4]
	cmp	w0, w1
	bls	.L1832
	ldrh	w1, [x20, 4]
	str	w0, [x20, 8]
	ldrh	w0, [x21, 8]
	strh	w1, [x19, #:lo12:.LANCHOR74]
	strh	w0, [x20, 4]
.L1832:
	ldrh	w0, [x19, #:lo12:.LANCHOR74]
	add	x24, x19, :lo12:.LANCHOR74
	mov	w1, 1
	mov	w25, 61649
	bl	FtlGetLastWrittenPage
	sxth	w20, w0
	add	w0, w0, 1
	strh	w0, [x24, 2]
	add	x24, x22, :lo12:.LANCHOR203
.L1834:
	tbz	w20, #31, .L1837
	mov	w2, 334
	adrp	x1, .LANCHOR212
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR212
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1836:
	add	x0, x19, :lo12:.LANCHOR74
	ldrh	w1, [x21, 10]
	strh	w1, [x0, 6]
	mov	w1, 65535
	ldrh	w0, [x21, 12]
	cmp	w0, w1
	beq	.L1839
	adrp	x1, .LANCHOR37
	ldr	w2, [x1, #:lo12:.LANCHOR37]
	cmp	w0, w2
	beq	.L1839
	adrp	x1, .LANCHOR41
	ldrh	w1, [x1, #:lo12:.LANCHOR41]
	lsr	w1, w1, 2
	cmp	w2, w1
	bcs	.L1839
	cmp	w0, w1
	bcs	.L1839
	bl	FtlSysBlkNumInit
.L1839:
	add	x19, x19, :lo12:.LANCHOR74
	adrp	x21, .LANCHOR45
	adrp	x23, .LANCHOR123
	add	x19, x19, 32
	add	x21, x21, :lo12:.LANCHOR45
	add	x23, x23, :lo12:.LANCHOR123
	add	x22, x22, :lo12:.LANCHOR203
	mov	w20, 0
.L1840:
	ldrh	w0, [x21]
	cmp	w20, w0
	bcc	.L1841
	mov	w0, 0
.L1824:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1827:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1825
.L1837:
	ldrh	w0, [x19, #:lo12:.LANCHOR74]
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
	beq	.L1835
	ldrh	w0, [x21]
	cmp	w0, w25
	beq	.L1836
.L1835:
	sub	w20, w20, #1
	sxth	w20, w20
	b	.L1834
.L1841:
	ldrh	w2, [x23]
	ldr	x0, [x22, 8]
	mul	w1, w2, w20
	lsl	w2, w2, 2
	add	w20, w20, 1
	add	x1, x0, x1, lsl 2
	ldr	x0, [x19], 8
	bl	ftl_memcpy
	b	.L1840
.L1842:
	mov	w0, -1
	b	.L1824
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
	adrp	x25, .LANCHOR53
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
	blt	.L1855
	ubfiz	x0, x0, 1, 16
	ldrh	w21, [x20, x0]
	cbz	w21, .L1855
	ldr	w1, [x19, 52]
	cbnz	w1, .L1855
	mov	w1, 1
	str	w1, [x19, 52]
	strh	wzr, [x20, x0]
	ldrh	w0, [x19, 8]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	ldrh	w0, [x25, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bcc	.L1856
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L1856:
	adrp	x22, .LANCHOR203
	adrp	x24, .LANCHOR213
	mov	x23, x22
	add	x27, x22, :lo12:.LANCHOR203
	add	x24, x24, :lo12:.LANCHOR213
	mov	w20, 0
.L1857:
	ldrh	w0, [x19, 6]
	cmp	w0, w20
	bhi	.L1863
	mov	w1, 1
	mov	w0, w21
	bl	FtlFreeSysBlkQueueIn
	str	wzr, [x19, 52]
.L1855:
	ldrh	w1, [x19, 2]
	ldrh	w0, [x25, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bcc	.L1861
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
	b	.L1861
.L1863:
	ubfiz	x0, x20, 2, 16
	add	x1, x26, x0
	str	x1, [x29, 104]
	ldr	w1, [x26, x0]
	cmp	w21, w1, lsr 10
	bne	.L1858
	adrp	x2, .LANCHOR184
	add	x0, x22, :lo12:.LANCHOR203
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
	beq	.L1859
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
.L1859:
	ldr	w0, [x27]
	ldrh	w2, [x28, 8]
	cmn	w0, #1
	bne	.L1860
.L1862:
	ldr	x0, [x29, 104]
	add	x23, x23, :lo12:.LANCHOR203
	str	wzr, [x0]
	adrp	x0, .LC39
	add	x0, x0, :lo12:.LC39
	ldr	w1, [x23, 4]
	bl	printf
	adrp	x0, .LANCHOR76
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR76]
.L1861:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1860:
	cmp	w2, w20
	bne	.L1862
	ldrh	w1, [x28]
	ldrh	w0, [x19, 4]
	cmp	w1, w0
	bne	.L1862
	ldr	x2, [x27, 8]
	mov	w1, w20
	mov	x0, x19
	bl	FtlMapWritePage
.L1858:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1857
	.size	ftl_map_blk_gc, .-ftl_map_blk_gc
	.section	.text.Ftl_write_map_blk_to_last_page,"ax",@progbits
	.align	2
	.global	Ftl_write_map_blk_to_last_page
	.type	Ftl_write_map_blk_to_last_page, %function
Ftl_write_map_blk_to_last_page:
	adrp	x1, .LANCHOR76
	ldr	w1, [x1, #:lo12:.LANCHOR76]
	cbnz	w1, .L1883
	stp	x29, x30, [sp, -64]!
	mov	w1, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	ldrh	w0, [x0]
	stp	x23, x24, [sp, 48]
	cmp	w0, w1
	ldr	x20, [x19, 16]
	bne	.L1870
	ldrh	w0, [x19, 8]
	cbz	w0, .L1871
	mov	w2, 697
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
.L1871:
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
.L1869:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1870:
	ubfiz	x0, x0, 1, 16
	adrp	x2, .LANCHOR188
	adrp	x21, .LANCHOR203
	add	x1, x21, :lo12:.LANCHOR203
	adrp	x24, .LANCHOR183
	ldr	x23, [x19, 40]
	ldrh	w22, [x20, x0]
	ldrh	w0, [x19, 2]
	ldr	x20, [x2, #:lo12:.LANCHOR188]
	str	x20, [x1, 16]
	orr	w0, w0, w22, lsl 10
	str	w0, [x1, 4]
	ldr	x0, [x24, #:lo12:.LANCHOR183]
	str	x0, [x1, 8]
	ldr	w1, [x19, 48]
	str	w1, [x20, 4]
	mov	w1, -1291
	strh	w1, [x20, 8]
	ldrh	w1, [x19, 4]
	strh	w1, [x20]
	adrp	x1, .LANCHOR53
	strh	w22, [x20, 2]
	ldrh	w2, [x1, #:lo12:.LANCHOR53]
	mov	w1, 255
	lsl	w2, w2, 3
	bl	ftl_memset
	ldrh	w4, [x19, 6]
	mov	x1, 0
	ldr	x3, [x24, #:lo12:.LANCHOR183]
	mov	w0, 0
.L1872:
	cmp	w4, w1, uxth
	bhi	.L1874
	adrp	x0, .LANCHOR2
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	cbz	w0, .L1875
	add	x0, x21, :lo12:.LANCHOR203
	adrp	x1, .LANCHOR57
	ldrh	w1, [x1, #:lo12:.LANCHOR57]
	ldr	x0, [x0, 8]
	bl	js_hash
	str	w0, [x20, 12]
.L1875:
	mov	w2, 1
	mov	w3, 0
	mov	w1, w2
	add	x0, x21, :lo12:.LANCHOR203
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	x0, x19
	bl	ftl_map_blk_gc
	b	.L1869
.L1874:
	ldr	w2, [x23, x1, lsl 2]
	cmp	w22, w2, lsr 10
	bne	.L1873
	add	w0, w0, 1
	and	w0, w0, 65535
	ubfiz	x2, x0, 1, 16
	str	w1, [x3, x2, lsl 2]
	add	x2, x2, 1
	ldr	w5, [x23, x1, lsl 2]
	str	w5, [x3, x2, lsl 2]
.L1873:
	add	x1, x1, 1
	b	.L1872
.L1883:
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
	stp	x19, x20, [sp, 16]
	mov	w19, 0
	stp	x25, x26, [sp, 64]
	adrp	x26, .LANCHOR53
	stp	x27, x28, [sp, 80]
	mov	w25, w1
	stp	x21, x22, [sp, 32]
	mov	x27, x0
	adrp	x22, .LANCHOR203
	stp	x23, x24, [sp, 48]
	mov	x20, x22
	add	x23, x22, :lo12:.LANCHOR203
	add	x28, x26, :lo12:.LANCHOR53
	str	x2, [x29, 104]
.L1887:
	adrp	x1, .LANCHOR165
	ldr	w0, [x1, #:lo12:.LANCHOR165]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR165]
	ldrh	w0, [x26, #:lo12:.LANCHOR53]
	ldrh	w1, [x27, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	bge	.L1888
	ldrh	w1, [x27]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1889
.L1888:
	mov	x0, x27
	bl	Ftl_write_map_blk_to_last_page
.L1889:
	adrp	x21, .LANCHOR76
	ldr	w0, [x21, #:lo12:.LANCHOR76]
	cbnz	w0, .L1904
	ldrh	w1, [x27]
	ldr	x0, [x27, 16]
	ldrh	w0, [x0, x1, lsl 1]
	cbnz	w0, .L1891
	mov	w2, 759
	adrp	x1, .LANCHOR215
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1891:
	ldrh	w1, [x27]
	ldrh	w0, [x27, 10]
	cmp	w1, w0
	bcc	.L1892
	mov	w2, 760
	adrp	x1, .LANCHOR215
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR215
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1892:
	ldrh	w1, [x27]
	add	x3, x22, :lo12:.LANCHOR203
	ldr	x0, [x27, 16]
	mov	w2, 16
	str	x3, [x29, 96]
	ldrh	w24, [x0, x1, lsl 1]
	mov	w1, 0
	ldrh	w0, [x27, 2]
	orr	w0, w0, w24, lsl 10
	str	w0, [x3, 4]
	ldr	x0, [x29, 104]
	str	x0, [x3, 8]
	adrp	x0, .LANCHOR188
	ldr	x0, [x0, #:lo12:.LANCHOR188]
	str	x0, [x3, 16]
	bl	ftl_memset
	ldr	x3, [x29, 96]
	ldr	w0, [x27, 48]
	ldr	x6, [x3, 16]
	str	w0, [x6, 4]
	ldrh	w0, [x27, 4]
	strh	w0, [x6]
	adrp	x0, .LANCHOR2
	strh	w25, [x6, 8]
	strh	w24, [x6, 2]
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	cbz	w0, .L1893
	adrp	x0, .LANCHOR57
	ldrh	w1, [x0, #:lo12:.LANCHOR57]
	ldr	x0, [x3, 8]
	bl	js_hash
	str	w0, [x6, 12]
.L1893:
	mov	w3, 1
	mov	x0, x23
	mov	w1, w3
	mov	w2, w3
	bl	FlashProgPages
	ldrh	w0, [x27, 2]
	ldr	w1, [x23]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x27, 2]
	cmn	w1, #1
	bne	.L1894
	ldr	w1, [x23, 4]
	adrp	x0, .LC40
	add	x0, x0, :lo12:.LC40
	add	w19, w19, 1
	and	w19, w19, 65535
	bl	printf
	ldrh	w0, [x27, 2]
	cmp	w0, 2
	bhi	.L1895
	ldrh	w0, [x28]
	sub	w0, w0, #1
	strh	w0, [x27, 2]
.L1895:
	cmp	w19, 3
	bls	.L1887
	add	x20, x20, :lo12:.LANCHOR203
	mov	w2, w19
	adrp	x0, .LC41
	add	x0, x0, :lo12:.LC41
	ldr	w1, [x20, 4]
	bl	printf
	mov	w0, 1
	str	w0, [x21, #:lo12:.LANCHOR76]
.L1904:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1894:
	cbz	w1, .L1897
	strh	w24, [x27, 60]
	cmp	w0, 1
	bne	.L1898
.L1899:
	str	wzr, [x27, 56]
	b	.L1887
.L1898:
	cmp	w1, 256
.L1912:
	beq	.L1899
	ldr	w0, [x27, 56]
	cbnz	w0, .L1899
	add	x20, x20, :lo12:.LANCHOR203
	ldr	x0, [x27, 40]
	ldr	w1, [x20, 4]
	str	w1, [x0, w25, uxtw 2]
	b	.L1904
.L1897:
	cmp	w0, 1
	b	.L1912
	.size	FtlMapWritePage, .-FtlMapWritePage
	.section	.text.flush_l2p_region,"ax",@progbits
	.align	2
	.global	flush_l2p_region
	.type	flush_l2p_region, %function
flush_l2p_region:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR96
	ubfiz	x19, x0, 4, 16
	ldr	x0, [x20, #:lo12:.LANCHOR96]
	add	x1, x0, x19
	ldr	x2, [x1, 8]
	ldrh	w1, [x0, x19]
	adrp	x0, .LANCHOR127
	add	x0, x0, :lo12:.LANCHOR127
	bl	FtlMapWritePage
	ldr	x0, [x20, #:lo12:.LANCHOR96]
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
	adrp	x20, .LANCHOR67
	add	x20, x20, :lo12:.LANCHOR67
	str	x21, [sp, 32]
	mov	w19, 0
	adrp	x21, .LANCHOR96
.L1916:
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L1918
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1918:
	ldr	x1, [x21, #:lo12:.LANCHOR96]
	ubfiz	x0, x19, 4, 16
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	tbz	w0, #31, .L1917
	mov	w0, w19
	bl	flush_l2p_region
.L1917:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1916
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
	bhi	.L1928
	adrp	x0, .LANCHOR56
	adrp	x26, .LANCHOR55
	adrp	x27, .LANCHOR57
	mov	x25, x2
	ldrh	w21, [x0, #:lo12:.LANCHOR56]
	add	x26, x26, :lo12:.LANCHOR55
	add	x27, x27, :lo12:.LANCHOR57
	mov	w24, 0
	lsr	w21, w22, w21
.L1922:
	cbnz	w20, .L1927
.L1920:
	mov	w0, w24
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1927:
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
	cbz	w2, .L1924
	cmp	w19, w1
	beq	.L1924
	ldr	x0, [x28, #:lo12:.LANCHOR185]
	str	w2, [x29, 124]
	mov	w2, 1
	stp	x0, xzr, [x29, 128]
	mov	w1, w2
	add	x0, x29, 120
	bl	FlashReadPages
.L1925:
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
	adrp	x0, .LANCHOR216
	add	x0, x0, :lo12:.LANCHOR216
	sub	w20, w20, w19
	add	w22, w22, w19
	add	w21, w21, 1
	bl	FtlMapWritePage
	cmn	w0, #1
	ldr	w3, [x29, 108]
	csinv	w24, w24, wzr, ne
	add	x25, x25, x3, sxtw
	b	.L1922
.L1924:
	ldrh	w2, [x27]
	mov	w1, 0
	ldr	x0, [x28, #:lo12:.LANCHOR185]
	bl	ftl_memset
	b	.L1925
.L1928:
	mov	w24, -1
	b	.L1920
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
	bne	.L1933
	mov	w0, 87
	mov	w1, 1
	movk	w0, 0x5000, lsl 16
	str	w0, [x2, 4]
	adrp	x0, .LANCHOR217
	ldr	w0, [x0, #:lo12:.LANCHOR217]
	str	w0, [x2, 88]
	adrp	x0, .LANCHOR218
	ldr	w0, [x0, #:lo12:.LANCHOR218]
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
	adrp	x0, .LANCHOR79
	ldr	w0, [x0, #:lo12:.LANCHOR79]
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
.L1933:
	ret
	.size	Ftl_save_ext_data, .-Ftl_save_ext_data
	.section	.text.FtlEctTblFlush,"ax",@progbits
	.align	2
	.global	FtlEctTblFlush
	.type	FtlEctTblFlush, %function
FtlEctTblFlush:
	adrp	x1, .LANCHOR28
	ldr	w1, [x1, #:lo12:.LANCHOR28]
	cbz	w1, .L1940
	adrp	x1, .LANCHOR170
	mov	w2, 4
	ldr	w1, [x1, #:lo12:.LANCHOR170]
	cmp	w1, 39
	mov	w1, 32
	csel	w1, w1, w2, hi
.L1936:
	adrp	x3, .LANCHOR219
	ldrh	w2, [x3, #:lo12:.LANCHOR219]
	cmp	w2, 31
	bhi	.L1937
	add	w2, w2, 1
	mov	w1, 1
	strh	w2, [x3, #:lo12:.LANCHOR219]
.L1937:
	adrp	x2, .LANCHOR191
	cbnz	w0, .L1938
	ldr	x0, [x2, #:lo12:.LANCHOR191]
	ldr	w3, [x0, 20]
	ldr	w0, [x0, 16]
	add	w1, w1, w3
	cmp	w0, w1
	bcc	.L1943
.L1938:
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
.L1940:
	mov	w1, 32
	b	.L1936
.L1943:
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
	bcs	.L1946
	mov	w2, 3289
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
.L1946:
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbnz	w0, .L1947
	mov	w0, 65535
	cmp	w20, w0
	beq	.L1948
	adrp	x1, .LANCHOR83
	ubfiz	x0, x20, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR83]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1949
	mov	w0, w20
	bl	INSERT_DATA_LIST
.L1948:
	strb	wzr, [x19, 8]
	adrp	x0, .LANCHOR92
	add	x0, x0, :lo12:.LANCHOR92
	cmp	x19, x0
	beq	.L1950
	adrp	x0, .LANCHOR44
	ldrh	w1, [x0, #:lo12:.LANCHOR44]
	cmp	w1, 1
	beq	.L1950
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L1951
.L1950:
	mov	w0, 1
	strb	w0, [x19, 8]
.L1952:
	adrp	x1, .LANCHOR133
	mov	w2, 65535
	mov	x21, x1
	ldrh	w0, [x1, #:lo12:.LANCHOR133]
	cmp	w0, w2
	beq	.L1957
	cmp	w20, w0
	bne	.L1958
	adrp	x2, .LANCHOR83
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR83]
	ldrh	w1, [x2, x1]
	cbz	w1, .L1959
.L1958:
	bl	update_vpc_list
.L1959:
	mov	w0, -1
	strh	w0, [x21, #:lo12:.LANCHOR133]
.L1957:
	mov	x0, x19
	bl	allocate_data_superblock
	bl	l2p_flush
	mov	w0, 0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1947:
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1949:
	mov	w0, w20
	bl	INSERT_FREE_LIST
	b	.L1948
.L1951:
	adrp	x0, .LANCHOR91
	add	x2, x0, :lo12:.LANCHOR91
	cmp	x19, x2
	bne	.L1952
	cmp	w1, 3
	beq	.L1954
	adrp	x1, .LANCHOR158
	ldr	w1, [x1, #:lo12:.LANCHOR158]
	cmp	w1, 1
	bne	.L1955
.L1954:
	add	x1, x0, :lo12:.LANCHOR91
	mov	w2, 1
	strb	w2, [x1, 8]
.L1955:
	adrp	x1, .LANCHOR28
	ldr	w1, [x1, #:lo12:.LANCHOR28]
	cbz	w1, .L1952
	adrp	x1, .LANCHOR170
	ldr	w1, [x1, #:lo12:.LANCHOR170]
	cmp	w1, 39
	bhi	.L1952
	add	x0, x0, :lo12:.LANCHOR91
	mov	w1, 1
	strb	w1, [x0, 8]
	b	.L1952
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
	bhi	.L1982
	adrp	x0, .LANCHOR56
	adrp	x26, .LANCHOR185
	mov	x25, x2
	mov	x28, x26
	ldrh	w20, [x0, #:lo12:.LANCHOR56]
	mov	w24, 0
	adrp	x0, .LANCHOR55
	add	x0, x0, :lo12:.LANCHOR55
	str	x0, [x29, 104]
	lsr	w20, w22, w20
.L1975:
	cbnz	w21, .L1981
.L1973:
	mov	w0, w24
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1981:
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
	cbz	w3, .L1977
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
	adrp	x0, .LANCHOR203
	csinv	w24, w24, wzr, ne
	ldr	w0, [x0, #:lo12:.LANCHOR203]
	cmp	w0, 256
	bne	.L1979
	mov	w2, w3
	mov	w1, w20
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	printf
	ldr	x2, [x26, #:lo12:.LANCHOR185]
	adrp	x0, .LANCHOR216
	mov	w1, w20
	add	x0, x0, :lo12:.LANCHOR216
	bl	FtlMapWritePage
.L1979:
	ldr	x1, [x28, #:lo12:.LANCHOR185]
	lsl	w23, w23, 7
	mov	w2, w27
	mov	x0, x25
	add	x1, x1, x23, sxtw 2
	bl	ftl_memcpy
.L1980:
	add	w20, w20, 1
	sub	w21, w21, w19
	add	w22, w22, w19
	add	x25, x25, x27, sxtw
	b	.L1975
.L1977:
	mov	w2, w27
	mov	w1, 0
	mov	x0, x25
	bl	ftl_memset
	b	.L1980
.L1982:
	mov	w24, -1
	b	.L1973
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
	beq	.L1985
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
.L1985:
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
	beq	.L1988
	mov	w2, 512
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	str	w20, [x19, #:lo12:.LANCHOR138]
.L1988:
	ldr	w1, [x19, #:lo12:.LANCHOR138]
	add	x0, x19, :lo12:.LANCHOR138
	cmp	w1, w20
	adrp	x20, .LANCHOR168
	bne	.L1989
	adrp	x1, .LANCHOR217
	ldr	w2, [x0, 88]
	str	w2, [x1, #:lo12:.LANCHOR217]
	adrp	x1, .LANCHOR218
	ldr	w2, [x0, 92]
	str	w2, [x1, #:lo12:.LANCHOR218]
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
	adrp	x1, .LANCHOR79
	str	w2, [x1, #:lo12:.LANCHOR79]
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
.L1989:
	add	x19, x19, :lo12:.LANCHOR138
	adrp	x0, .LANCHOR157
	str	wzr, [x0, #:lo12:.LANCHOR157]
	mov	w0, 34661
	ldr	w1, [x19, 68]
	movk	w0, 0x1234, lsl 16
	cmp	w1, w0
	bne	.L1990
	adrp	x0, .LANCHOR28
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR28]
	adrp	x1, .LC44
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC44
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1990:
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
	adrp	x1, .LANCHOR206
	str	w0, [x1, #:lo12:.LANCHOR206]
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
	cbz	w1, .L2008
	stp	x29, x30, [sp, -80]!
	adrp	x1, .LANCHOR76
	add	x29, sp, 0
	ldr	w1, [x1, #:lo12:.LANCHOR76]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldrh	w20, [x0, 6]
	str	x25, [sp, 64]
	str	wzr, [x0, 56]
	ldr	x25, [x0, 40]
	cbnz	w1, .L1994
	mov	x19, x0
	adrp	x0, .LANCHOR184
	adrp	x23, .LANCHOR203
	add	x21, x23, :lo12:.LANCHOR203
	ldr	x0, [x0, #:lo12:.LANCHOR184]
	mov	x22, x23
	str	x0, [x21, 8]
	adrp	x0, .LANCHOR188
	ldr	x24, [x0, #:lo12:.LANCHOR188]
	ldrh	w0, [x19, 2]
	str	x24, [x21, 16]
	cbz	w0, .L1998
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	sub	w1, w1, #1
	cmp	w0, w1
	bge	.L1998
	ldrh	w1, [x19]
	mov	w2, 65535
	cmp	w1, w2
	beq	.L1998
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
	ldr	w0, [x23, #:lo12:.LANCHOR203]
	cmn	w0, #1
	beq	.L1998
	ldrh	w1, [x24, 8]
	ldr	x2, [x19, 40]
	ubfiz	x0, x1, 2, 16
	ldr	w2, [x2, x0]
	ldr	w0, [x21, 4]
	cmp	w2, w0
	bne	.L1998
	ldr	x2, [x21, 8]
.L2011:
	mov	x0, x19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	b	FtlMapWritePage
.L1998:
	sub	w20, w20, #1
	and	w20, w20, 65535
	ubfiz	x0, x20, 2, 16
	ldr	w1, [x25, x0]
	add	x0, x22, :lo12:.LANCHOR203
	str	w1, [x0, 4]
	cbz	w1, .L1999
	mov	w2, 1
	mov	w1, w2
	bl	FlashReadPages
.L2000:
	add	x22, x22, :lo12:.LANCHOR203
	mov	w1, w20
	ldr	x2, [x22, 8]
	b	.L2011
.L1999:
	adrp	x1, .LANCHOR57
	ldr	x0, [x0, 8]
	ldrh	w2, [x1, #:lo12:.LANCHOR57]
	mov	w1, 255
	bl	ftl_memset
	b	.L2000
.L1994:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2008:
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
	adrp	x21, .LANCHOR64
	ldr	x0, [x25, #:lo12:.LANCHOR130]
	adrp	x22, .LANCHOR193
	ldr	w2, [x21, #:lo12:.LANCHOR64]
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR128
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR70
	stp	x27, x28, [sp, 80]
	adrp	x27, .LANCHOR129
	lsl	w2, w2, 2
	strh	wzr, [x20, #:lo12:.LANCHOR128]
	strh	wzr, [x23, #:lo12:.LANCHOR70]
	bl	ftl_memset
	ldr	x0, [x27, #:lo12:.LANCHOR129]
	mov	w1, 0
	ldr	w2, [x21, #:lo12:.LANCHOR64]
	adrp	x19, .LANCHOR61
	adrp	x28, .LANCHOR71
	adrp	x24, .LANCHOR210
	lsl	w2, w2, 1
	bl	ftl_memset
	ldr	x0, [x22, #:lo12:.LANCHOR193]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR61]
	lsl	w2, w2, 2
	bl	ftl_memset
	ldr	x0, [x28, #:lo12:.LANCHOR71]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR61]
	lsl	w2, w2, 1
	bl	ftl_memset
	mov	w2, 16
	mov	w1, 255
	add	x0, x24, :lo12:.LANCHOR210
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
.L2013:
	ldr	x0, [x29, 120]
	ldr	w1, [x29, 172]
	ldrh	w0, [x0]
	cmp	w0, w1
	bls	.L2054
	adrp	x0, .LANCHOR38
	adrp	x25, .LANCHOR180
	adrp	x6, .LANCHOR47
	mov	x5, 0
	ldrh	w13, [x0, #:lo12:.LANCHOR38]
	adrp	x0, .LANCHOR104
	ldr	x7, [x25, #:lo12:.LANCHOR180]
	mov	w22, 0
	ldr	x12, [x0, #:lo12:.LANCHOR104]
	adrp	x0, .LANCHOR105
	add	x6, x6, :lo12:.LANCHOR47
	mov	w8, 56
	ldr	x11, [x0, #:lo12:.LANCHOR105]
	adrp	x0, .LANCHOR58
	ldrh	w10, [x0, #:lo12:.LANCHOR58]
	b	.L2055
.L2015:
	ldrh	w1, [x29, 172]
	ldrb	w0, [x6, x5]
	bl	V2P_block
	and	w4, w0, 65535
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L2014
	umaddl	x1, w22, w8, x7
	lsl	w4, w4, 10
	mul	w0, w22, w10
	add	w22, w22, 1
	and	w22, w22, 65535
	asr	w0, w0, 2
	str	w4, [x1, 4]
	add	x0, x11, x0, sxtw 2
	stp	x12, x0, [x1, 8]
.L2014:
	add	x5, x5, 1
.L2055:
	cmp	w13, w5, uxth
	bhi	.L2015
	cbnz	w22, .L2016
.L2053:
	ldr	w0, [x29, 172]
	add	w26, w0, 1
	and	w0, w26, 65535
	str	w0, [x29, 172]
	b	.L2013
.L2016:
	mov	w1, w22
	mov	w2, 1
	mov	x0, x7
	bl	FlashReadPages
	mov	w0, 56
	umull	x0, w22, w0
	mov	x22, 0
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR221
	add	x0, x0, :lo12:.LANCHOR221
	str	x0, [x29, 136]
.L2052:
	ldr	x0, [x25, #:lo12:.LANCHOR180]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	ldr	w3, [x1, 4]
	cmn	w0, #1
	ldr	x27, [x1, 16]
	ubfx	x26, x3, 10, 16
	bne	.L2019
	mov	w5, 16
	mov	w7, 65535
.L2021:
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
	bne	.L2018
	ldr	x0, [x6]
	mov	w1, -1
	str	w1, [x0, x22]
	ldr	x0, [x6]
	ldr	w0, [x0, x22]
	cmp	w0, w1
	beq	.L2091
.L2019:
	adrp	x0, .LANCHOR159
	ldr	w1, [x0, #:lo12:.LANCHOR159]
	ldr	w0, [x27, 4]
	cmn	w1, #1
	beq	.L2022
	cmp	w1, w0
	bhi	.L2023
.L2022:
	cmn	w0, #1
	beq	.L2023
	ldr	x2, [x29, 112]
	add	w1, w0, 1
	str	w1, [x2]
.L2023:
	ldrh	w1, [x27]
	mov	w2, 61604
	cmp	w1, w2
	beq	.L2025
	bhi	.L2026
	mov	w0, 61574
	cmp	w1, w0
	beq	.L2027
.L2024:
	ldr	x0, [x29, 128]
	add	x22, x22, 56
	cmp	x0, x22
	bne	.L2052
	b	.L2053
.L2018:
	ldr	x0, [x25, #:lo12:.LANCHOR180]
	ldr	w0, [x0, x22]
	cmn	w0, #1
	bne	.L2019
	sub	w5, w5, #1
	ands	w5, w5, 65535
	bne	.L2021
.L2091:
	mov	w1, 0
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
	b	.L2024
.L2026:
	mov	w0, 61634
	cmp	w1, w0
	beq	.L2028
	mov	w0, 65535
	cmp	w1, w0
	beq	.L2091
	b	.L2024
.L2028:
	ldrh	w1, [x20, #:lo12:.LANCHOR128]
	ldr	w0, [x21, #:lo12:.LANCHOR64]
	cmp	w1, w0
	bls	.L2030
	ldr	x1, [x29, 136]
	mov	w2, 1307
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2030:
	ldr	w6, [x21, #:lo12:.LANCHOR64]
	ldr	x3, [x29, 152]
	ldrh	w1, [x20, #:lo12:.LANCHOR128]
	and	w2, w6, 65535
	sub	w0, w2, #1
	sub	w2, w2, w1
	sxth	x0, w0
	sub	w2, w2, #1
	ldr	x5, [x3, #:lo12:.LANCHOR130]
	sxth	w2, w2
.L2031:
	cmp	w0, w2
	bgt	.L2037
	tbz	w0, #31, .L2072
	b	.L2024
.L2037:
	sxtw	x8, w0
	ldr	w11, [x27, 4]
	lsl	x7, x8, 2
	add	x10, x5, x7
	ldr	w7, [x5, x7]
	cmp	w11, w7
	bls	.L2032
	ldr	w2, [x5]
	cbnz	w2, .L2033
	cmp	w6, w1
	beq	.L2033
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR128]
.L2033:
	ldr	x1, [x29, 160]
	ldr	x6, [x1, #:lo12:.LANCHOR129]
	mov	w1, 0
.L2034:
	cmp	w1, w0
	bne	.L2035
	ldr	w1, [x27, 4]
	str	w1, [x10]
	strh	w26, [x6, x8, lsl 1]
	tbnz	w0, #31, .L2024
	ldrh	w1, [x20, #:lo12:.LANCHOR128]
	ldr	w2, [x21, #:lo12:.LANCHOR64]
	sub	w2, w2, w1
	sub	w2, w2, #1
	cmp	w0, w2, sxth
	bgt	.L2024
.L2072:
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR128]
	ldr	w1, [x27, 4]
	str	w1, [x5, x0, lsl 2]
	ldr	x1, [x29, 160]
	ldr	x1, [x1, #:lo12:.LANCHOR129]
.L2090:
	strh	w26, [x1, x0, lsl 1]
	b	.L2024
.L2035:
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
	b	.L2034
.L2032:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L2031
.L2027:
	ldrh	w1, [x23, #:lo12:.LANCHOR70]
	ldrh	w0, [x19, #:lo12:.LANCHOR61]
	cmp	w1, w0
	bls	.L2040
	ldr	x1, [x29, 136]
	mov	w2, 1354
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2040:
	ldrh	w6, [x19, #:lo12:.LANCHOR61]
	ldrh	w2, [x23, #:lo12:.LANCHOR70]
	sub	w1, w6, #1
	sxth	x0, w1
	sub	w5, w1, w2
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR193]
.L2041:
	cmp	w0, w5
	ble	.L2046
	sxtw	x7, w0
	ldr	w11, [x27, 4]
	lsl	x8, x7, 2
	add	x10, x1, x8
	ldr	w8, [x1, x8]
	cmp	w11, w8
	bls	.L2042
	ldr	w5, [x1]
	cbnz	w5, .L2043
	cmp	w6, w2
	beq	.L2043
	add	w2, w2, 1
	strh	w2, [x23, #:lo12:.LANCHOR70]
.L2043:
	ldr	x6, [x28, #:lo12:.LANCHOR71]
	mov	w2, 0
.L2044:
	cmp	w2, w0
	bne	.L2045
	ldr	w2, [x27, 4]
	str	w2, [x10]
	strh	w26, [x6, x7, lsl 1]
.L2046:
	tbnz	w0, #31, .L2024
	ldrh	w2, [x19, #:lo12:.LANCHOR61]
	ldrh	w5, [x23, #:lo12:.LANCHOR70]
	sub	w2, w2, #1
	sub	w2, w2, w5
	cmp	w0, w2, sxth
	bgt	.L2024
	add	w5, w5, 1
	ldr	w2, [x27, 4]
	strh	w5, [x23, #:lo12:.LANCHOR70]
	str	w2, [x1, x0, lsl 2]
	ldr	x1, [x28, #:lo12:.LANCHOR71]
	b	.L2090
.L2045:
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
	b	.L2044
.L2042:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L2041
.L2025:
	ldrh	w5, [x24, #:lo12:.LANCHOR210]
	mov	w1, 65535
	add	x2, x24, :lo12:.LANCHOR210
	cmp	w5, w1
	bne	.L2048
	strh	w26, [x24, #:lo12:.LANCHOR210]
	str	w0, [x2, 8]
	b	.L2024
.L2048:
	ldrh	w0, [x2, 4]
	cmp	w0, w1
	beq	.L2049
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
.L2049:
	add	x0, x24, :lo12:.LANCHOR210
	ldr	w1, [x27, 4]
	ldr	w2, [x0, 8]
	cmp	w2, w1
	bcs	.L2050
	ldrh	w2, [x24, #:lo12:.LANCHOR210]
	strh	w2, [x0, 4]
	strh	w26, [x24, #:lo12:.LANCHOR210]
	str	w1, [x0, 8]
	b	.L2024
.L2050:
	strh	w26, [x0, 4]
	b	.L2024
.L2054:
	ldr	x0, [x29, 160]
	ldr	x2, [x0, #:lo12:.LANCHOR129]
	ldrh	w0, [x2]
	cbz	w0, .L2056
.L2059:
	ldr	x1, [x28, #:lo12:.LANCHOR71]
	ldrh	w0, [x1]
	cbz	w0, .L2057
.L2058:
	ldrh	w1, [x20, #:lo12:.LANCHOR128]
	ldr	w0, [x21, #:lo12:.LANCHOR64]
	cmp	w1, w0
	bls	.L2088
	mov	w2, 1488
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
.L2088:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L2056:
	ldrh	w0, [x20, #:lo12:.LANCHOR128]
	cbz	w0, .L2059
	ldr	w1, [x21, #:lo12:.LANCHOR64]
	mov	w0, 0
.L2060:
	cmp	w0, w1
	bcs	.L2059
	ldrh	w3, [x2, w0, sxtw 1]
	cbz	w3, .L2061
	ldr	x1, [x29, 152]
	add	x7, x21, :lo12:.LANCHOR64
	ldr	x4, [x1, #:lo12:.LANCHOR130]
	mov	w1, w0
.L2062:
	ldr	w3, [x7]
	cmp	w1, w3
	bcs	.L2059
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
	b	.L2062
.L2061:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L2060
.L2057:
	ldrh	w0, [x23, #:lo12:.LANCHOR70]
	cbz	w0, .L2058
	ldrh	w2, [x19, #:lo12:.LANCHOR61]
	mov	w0, 0
.L2067:
	mov	w6, w0
	cmp	w0, w2
	bge	.L2058
	ldrh	w3, [x1, w0, sxtw 1]
	cbz	w3, .L2068
	ldr	x2, [x29, 144]
	add	x19, x19, :lo12:.LANCHOR61
	ldr	x3, [x2, #:lo12:.LANCHOR193]
.L2069:
	ldrh	w2, [x19]
	cmp	w0, w2
	bge	.L2058
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
	b	.L2069
.L2068:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L2067
	.size	FtlScanSysBlk, .-FtlScanSysBlk
	.section	.text.FtlLoadSysInfo,"ax",@progbits
	.align	2
	.global	FtlLoadSysInfo
	.type	FtlLoadSysInfo, %function
FtlLoadSysInfo:
	sub	sp, sp, #128
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x23, x24, [sp, 64]
	adrp	x23, .LANCHOR183
	stp	x19, x20, [sp, 32]
	adrp	x19, .LANCHOR203
	add	x0, x19, :lo12:.LANCHOR203
	stp	x25, x26, [sp, 80]
	adrp	x25, .LANCHOR188
	stp	x21, x22, [sp, 48]
	stp	x27, x28, [sp, 96]
	adrp	x24, .LANCHOR83
	ldr	x1, [x23, #:lo12:.LANCHOR183]
	adrp	x22, .LANCHOR40
	str	x1, [x0, 8]
	adrp	x21, .LANCHOR210
	ldr	x1, [x25, #:lo12:.LANCHOR188]
	str	x1, [x0, 16]
	ldr	x0, [x24, #:lo12:.LANCHOR83]
	mov	w1, 0
	ldrh	w2, [x22, #:lo12:.LANCHOR40]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w0, [x21, #:lo12:.LANCHOR210]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L2093
.L2105:
	mov	w0, -1
.L2092:
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 128
	ret
.L2093:
	add	x26, x21, :lo12:.LANCHOR210
	mov	w1, 1
	bl	FtlGetLastWrittenPage
	ldrsh	w28, [x21, #:lo12:.LANCHOR210]
	sxth	w20, w0
	adrp	x27, .LANCHOR57
	add	w0, w0, 1
	add	x27, x27, :lo12:.LANCHOR57
	strh	w0, [x26, 2]
	adrp	x26, .LANCHOR2
	add	x0, x26, :lo12:.LANCHOR2
	str	x0, [x29, 104]
.L2095:
	tbz	w20, #31, .L2101
	mov	w2, 1557
	adrp	x1, .LANCHOR222
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR222
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
	b	.L2100
.L2101:
	add	x26, x19, :lo12:.LANCHOR203
	orr	w0, w20, w28, lsl 10
	mov	w2, 1
	mov	w1, w2
	str	w0, [x26, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	str	x0, [x26, 8]
	mov	x0, x26
	bl	FlashReadPages
	ldr	x0, [x29, 104]
	ldrb	w0, [x0]
	cbz	w0, .L2096
	ldr	x8, [x26, 16]
	ldr	w7, [x8, 12]
	cbz	w7, .L2096
	ldr	x6, [x26, 8]
	ldrh	w1, [x27]
	mov	x0, x6
	bl	js_hash
	cmp	w7, w0
	beq	.L2096
	cbnz	w20, .L2097
	add	x10, x21, :lo12:.LANCHOR210
	str	x10, [x29, 96]
	ldrh	w0, [x10, 4]
	cmp	w28, w0
	beq	.L2097
	ldr	w0, [x6]
	str	w0, [sp]
	ldrh	w1, [x21, #:lo12:.LANCHOR210]
	adrp	x0, .LC45
	ldr	w2, [x19, #:lo12:.LANCHOR203]
	add	x0, x0, :lo12:.LC45
	ldp	w4, w5, [x8]
	ldr	w6, [x8, 8]
	ldr	w3, [x26, 4]
	bl	printf
	ldr	x10, [x29, 96]
	adrp	x0, .LANCHOR53
	ldrh	w20, [x0, #:lo12:.LANCHOR53]
	ldrsh	w28, [x10, 4]
.L2099:
	sub	w20, w20, #1
	sxth	w20, w20
	b	.L2095
.L2097:
	mov	w0, -1
	str	w0, [x19, #:lo12:.LANCHOR203]
.L2096:
	ldr	w0, [x19, #:lo12:.LANCHOR203]
	cmn	w0, #1
	beq	.L2099
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	mov	w1, 19539
	movk	w1, 0x4654, lsl 16
	ldr	w0, [x0]
	cmp	w0, w1
	bne	.L2099
	ldr	x0, [x25, #:lo12:.LANCHOR188]
	ldrh	w1, [x0]
	mov	w0, 61604
	cmp	w1, w0
	bne	.L2099
.L2100:
	adrp	x1, .LANCHOR57
	ldrh	w0, [x22, #:lo12:.LANCHOR40]
	ldrh	w1, [x1, #:lo12:.LANCHOR57]
	add	x0, x0, 24
	cmp	x1, x0, lsl 1
	bcs	.L2103
	mov	w2, 1559
	adrp	x1, .LANCHOR222
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR222
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2103:
	add	x19, x19, :lo12:.LANCHOR203
	mov	w2, 48
	adrp	x20, .LANCHOR80
	add	x0, x20, :lo12:.LANCHOR80
	ldr	x1, [x19, 8]
	bl	ftl_memcpy
	ldr	x0, [x24, #:lo12:.LANCHOR83]
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
	adrp	x0, .LANCHOR1
	ldr	x0, [x0, #:lo12:.LANCHOR1]
	bl	ftl_memcpy
	adrp	x0, .LANCHOR69
	ldrh	w0, [x0, #:lo12:.LANCHOR69]
	cbz	w0, .L2104
	ldrh	w1, [x22, #:lo12:.LANCHOR40]
	adrp	x0, .LANCHOR66
	ldrh	w2, [x0, #:lo12:.LANCHOR66]
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
.L2104:
	ldr	w2, [x20, #:lo12:.LANCHOR80]
	mov	w1, 19539
	movk	w1, 0x4654, lsl 16
	add	x0, x20, :lo12:.LANCHOR80
	cmp	w2, w1
	bne	.L2105
	add	x21, x21, :lo12:.LANCHOR210
	ldrh	w1, [x0, 8]
	ldrb	w2, [x0, 10]
	adrp	x0, .LANCHOR45
	strh	w1, [x21, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR45]
	cmp	w2, w0
	bne	.L2105
	adrp	x0, .LANCHOR223
	adrp	x2, .LANCHOR72
	adrp	x3, .LANCHOR38
	str	w1, [x0, #:lo12:.LANCHOR223]
	adrp	x0, .LANCHOR52
	ldrh	w3, [x3, #:lo12:.LANCHOR38]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	mul	w0, w0, w1
	str	w0, [x2, #:lo12:.LANCHOR72]
	adrp	x2, .LANCHOR55
	ldrh	w2, [x2, #:lo12:.LANCHOR55]
	mul	w0, w2, w0
	adrp	x2, .LANCHOR68
	str	w0, [x2, #:lo12:.LANCHOR68]
	adrp	x0, .LANCHOR42
	ldr	w2, [x0, #:lo12:.LANCHOR42]
	adrp	x0, .LANCHOR74+6
	ldrh	w0, [x0, #:lo12:.LANCHOR74+6]
	cmp	w1, w2
	sub	w0, w2, w0
	sub	w0, w0, w1
	udiv	w0, w0, w3
	adrp	x3, .LANCHOR224
	strh	w0, [x3, #:lo12:.LANCHOR224]
	bls	.L2106
	mov	w2, 1586
	adrp	x1, .LANCHOR222
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR222
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2106:
	add	x4, x20, :lo12:.LANCHOR80
	adrp	x0, .LANCHOR91
	add	x2, x0, :lo12:.LANCHOR91
	adrp	x5, .LANCHOR205
	adrp	x19, .LANCHOR92
	mov	x22, x5
	ldrh	w1, [x4, 16]
	ldrh	w6, [x4, 14]
	strh	w6, [x0, #:lo12:.LANCHOR91]
	lsr	w3, w1, 6
	and	w1, w1, 63
	strb	w1, [x2, 6]
	ldrb	w1, [x4, 11]
	strb	w1, [x2, 8]
	add	x1, x5, :lo12:.LANCHOR205
	strh	w3, [x2, 2]
	mov	w2, -1
	strh	w2, [x5, #:lo12:.LANCHOR205]
	add	x2, x19, :lo12:.LANCHOR92
	strh	wzr, [x1, 2]
	strb	wzr, [x1, 6]
	strb	wzr, [x1, 8]
	ldrh	w1, [x4, 18]
	strh	w1, [x19, #:lo12:.LANCHOR92]
	ldrh	w1, [x4, 20]
	lsr	w3, w1, 6
	and	w1, w1, 63
	strb	w1, [x2, 6]
	ldrb	w1, [x4, 12]
	strh	w3, [x2, 2]
	strb	w1, [x2, 8]
	adrp	x2, .LANCHOR93
	ldrh	w1, [x4, 22]
	add	x3, x2, :lo12:.LANCHOR93
	strh	w1, [x2, #:lo12:.LANCHOR93]
	mov	x21, x2
	ldrh	w1, [x4, 24]
	lsr	w7, w1, 6
	and	w1, w1, 63
	strb	w1, [x3, 6]
	ldrb	w1, [x4, 13]
	strb	w1, [x3, 8]
	adrp	x1, .LANCHOR161
	strh	w7, [x3, 2]
	ldr	w3, [x4, 32]
	str	wzr, [x1, #:lo12:.LANCHOR161]
	adrp	x1, .LANCHOR162
	str	wzr, [x1, #:lo12:.LANCHOR162]
	adrp	x1, .LANCHOR166
	str	wzr, [x1, #:lo12:.LANCHOR166]
	adrp	x1, .LANCHOR165
	str	wzr, [x1, #:lo12:.LANCHOR165]
	adrp	x1, .LANCHOR167
	str	w3, [x1, #:lo12:.LANCHOR167]
	adrp	x1, .LANCHOR168
	str	wzr, [x1, #:lo12:.LANCHOR168]
	adrp	x1, .LANCHOR169
	str	wzr, [x1, #:lo12:.LANCHOR169]
	adrp	x1, .LANCHOR164
	ldr	w3, [x4, 40]
	str	wzr, [x1, #:lo12:.LANCHOR164]
	adrp	x1, .LANCHOR159
	ldr	w4, [x1, #:lo12:.LANCHOR159]
	cmp	w3, w4
	bls	.L2107
	str	w3, [x1, #:lo12:.LANCHOR159]
.L2107:
	add	x20, x20, :lo12:.LANCHOR80
	adrp	x1, .LANCHOR160
	ldr	w3, [x1, #:lo12:.LANCHOR160]
	ldr	w2, [x20, 36]
	cmp	w2, w3
	bls	.L2108
	str	w2, [x1, #:lo12:.LANCHOR160]
.L2108:
	mov	w1, 65535
	cmp	w6, w1
	beq	.L2109
	add	x0, x0, :lo12:.LANCHOR91
	bl	make_superblock
.L2109:
	ldrh	w2, [x19, #:lo12:.LANCHOR92]
	mov	w1, 65535
	add	x0, x19, :lo12:.LANCHOR92
	cmp	w2, w1
	beq	.L2110
	bl	make_superblock
.L2110:
	ldrh	w2, [x21, #:lo12:.LANCHOR93]
	mov	w1, 65535
	add	x0, x21, :lo12:.LANCHOR93
	cmp	w2, w1
	beq	.L2111
	bl	make_superblock
.L2111:
	ldrh	w2, [x22, #:lo12:.LANCHOR205]
	mov	w1, 65535
	add	x0, x22, :lo12:.LANCHOR205
	cmp	w2, w1
	beq	.L2112
	bl	make_superblock
.L2112:
	mov	w0, 0
	b	.L2092
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
	adrp	x19, .LANCHOR52
	stp	x21, x22, [sp, 48]
	and	w22, w1, 255
	stp	x23, x24, [sp, 64]
	add	x23, x29, 144
	stp	x25, x26, [sp, 80]
	str	x27, [sp, 96]
	bl	P2V_block_in_plane
	ldrh	w25, [x19, #:lo12:.LANCHOR52]
	and	w21, w0, 65535
	adrp	x1, .LANCHOR225
	adrp	x0, .LC46
	add	x1, x1, :lo12:.LANCHOR225
	add	x0, x0, :lo12:.LC46
	bl	printf
	adrp	x1, .LANCHOR83
	ubfiz	x0, x21, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR83]
	ldrh	w2, [x1, x0]
	mov	w1, w21
	adrp	x0, .LC47
	add	x0, x0, :lo12:.LC47
	bl	printf
	strh	w21, [x23, -48]!
	mov	x0, x23
	bl	make_superblock
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L2137
	cbnz	w22, .L2137
	mov	w0, w21
	bl	ftl_get_blk_mode
	mov	w21, w0
	cmp	w0, 1
	bne	.L2128
	adrp	x0, .LANCHOR53
	ldrh	w25, [x0, #:lo12:.LANCHOR53]
.L2128:
	ldrh	w3, [x19, #:lo12:.LANCHOR52]
	adrp	x26, .LC49
	add	x26, x26, :lo12:.LC49
	mov	w20, 0
	mov	w27, 56
	mov	w2, w25
	mov	w1, w21
	adrp	x0, .LC48
	add	x0, x0, :lo12:.LC48
	bl	printf
.L2129:
	adrp	x1, .LANCHOR104
	adrp	x0, .LANCHOR38
	adrp	x24, .LANCHOR180
	add	x3, x23, 16
	ldr	x6, [x1, #:lo12:.LANCHOR104]
	adrp	x1, .LANCHOR57
	ldrh	w5, [x0, #:lo12:.LANCHOR38]
	mov	w19, 0
	ldrh	w7, [x1, #:lo12:.LANCHOR57]
	adrp	x1, .LANCHOR105
	ldr	x0, [x24, #:lo12:.LANCHOR180]
	mov	w11, 65535
	ldr	x8, [x1, #:lo12:.LANCHOR105]
	adrp	x1, .LANCHOR58
	ldrh	w10, [x1, #:lo12:.LANCHOR58]
	mov	w1, 0
.L2130:
	cmp	w1, w5
	bne	.L2132
	mov	w1, w19
	umull	x19, w19, w27
	mov	x22, 0
	mov	w2, w21
	bl	FlashReadPages
.L2133:
	cmp	x22, x19
	bne	.L2134
	add	w20, w20, 1
	and	w20, w20, 65535
	cmp	w25, w20
	bne	.L2129
.L2135:
	ldp	x19, x20, [sp, 32]
	mov	w0, 0
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	ldr	x27, [sp, 96]
	add	sp, sp, 160
	ret
.L2137:
	mov	w21, 0
	b	.L2128
.L2132:
	ldrh	w2, [x3]
	cmp	w2, w11
	beq	.L2131
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
.L2131:
	add	w1, w1, 1
	add	x3, x3, 2
	and	w1, w1, 65535
	b	.L2130
.L2134:
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
	b	.L2133
	.size	FtlDumpBlockInfo, .-FtlDumpBlockInfo
	.section	.text.FtlScanAllBlock,"ax",@progbits
	.align	2
	.global	FtlScanAllBlock
	.type	FtlScanAllBlock, %function
FtlScanAllBlock:
	sub	sp, sp, #144
	adrp	x1, .LANCHOR226
	adrp	x0, .LC46
	add	x1, x1, :lo12:.LANCHOR226
	add	x0, x0, :lo12:.LC46
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x23, x24, [sp, 64]
	adrp	x23, .LANCHOR41
	stp	x19, x20, [sp, 32]
	adrp	x24, .LC51
	stp	x21, x22, [sp, 48]
	mov	w20, 0
	add	x23, x23, :lo12:.LANCHOR41
	add	x24, x24, :lo12:.LC51
	str	x25, [sp, 80]
	bl	printf
.L2141:
	ldrh	w0, [x23]
	cmp	w0, w20
	bhi	.L2149
	ldp	x19, x20, [sp, 32]
	mov	w0, 0
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x29, x30, [sp, 16]
	ldr	x25, [sp, 80]
	add	sp, sp, 144
	ret
.L2149:
	strh	w20, [x29, 80]
	mov	w0, w20
	bl	ftl_get_blk_mode
	mov	w3, w0
	adrp	x2, .LANCHOR83
	ubfiz	x1, x20, 1, 16
	adrp	x0, .LC50
	add	x0, x0, :lo12:.LC50
	ldr	x2, [x2, #:lo12:.LANCHOR83]
	adrp	x22, .LANCHOR180
	mov	w19, 0
	ldrh	w2, [x2, x1]
	mov	w1, w20
	bl	printf
	add	x0, x29, 80
	bl	make_superblock
	adrp	x1, .LANCHOR104
	adrp	x0, .LANCHOR38
	add	x3, x29, 96
	mov	w11, 65535
	ldr	x6, [x1, #:lo12:.LANCHOR104]
	adrp	x1, .LANCHOR57
	ldrh	w5, [x0, #:lo12:.LANCHOR38]
	mov	w12, 56
	ldrh	w7, [x1, #:lo12:.LANCHOR57]
	adrp	x1, .LANCHOR105
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	ldr	x8, [x1, #:lo12:.LANCHOR105]
	adrp	x1, .LANCHOR58
	ldrh	w10, [x1, #:lo12:.LANCHOR58]
	mov	w1, 0
.L2142:
	cmp	w1, w5
	bne	.L2144
	mov	w25, 56
	mov	x21, 0
	mov	w2, 0
	mov	w1, w19
	umull	x25, w19, w25
	bl	FlashReadPages
.L2145:
	cmp	x21, x25
	bne	.L2146
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	adrp	x25, .LC52
	add	x25, x25, :lo12:.LC52
	mov	w1, w19
	mov	x19, 0
	mov	w2, 1
	bl	FlashReadPages
.L2147:
	cmp	x21, x19
	bne	.L2148
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2141
.L2144:
	ldrh	w2, [x3]
	cmp	w2, w11
	beq	.L2143
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
.L2143:
	add	w1, w1, 1
	add	x3, x3, 2
	and	w1, w1, 65535
	b	.L2142
.L2146:
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
	b	.L2145
.L2148:
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
	b	.L2147
	.size	FtlScanAllBlock, .-FtlScanAllBlock
	.section	.text.FtlMapTblRecovery,"ax",@progbits
	.align	2
	.global	FtlMapTblRecovery
	.type	FtlMapTblRecovery, %function
FtlMapTblRecovery:
	stp	x29, x30, [sp, -160]!
	mov	w1, 0
	add	x29, sp, 0
	stp	x27, x28, [sp, 80]
	mov	x28, x0
	stp	x23, x24, [sp, 48]
	ldrh	w24, [x0, 6]
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR183
	ldr	x22, [x0, 40]
	ldr	x23, [x0, 16]
	lsl	w2, w24, 2
	ldr	x0, [x0, 24]
	str	x0, [x29, 144]
	ldrh	w0, [x28, 8]
	stp	x19, x20, [sp, 16]
	mov	w19, 0
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR53
	str	w0, [x29, 156]
	mov	x0, x22
	bl	ftl_memset
	stp	wzr, wzr, [x28, 48]
	adrp	x0, .LANCHOR203
	add	x4, x0, :lo12:.LANCHOR203
	ldr	x1, [x21, #:lo12:.LANCHOR183]
	mov	x27, x4
	str	x0, [x29, 128]
	str	x1, [x4, 8]
	adrp	x1, .LANCHOR188
	ldr	w0, [x29, 156]
	ldr	x20, [x1, #:lo12:.LANCHOR188]
	mov	w1, -1
	str	x20, [x4, 16]
	sub	w0, w0, #1
	strh	w1, [x28]
	strh	w1, [x28, 2]
	mov	w1, 1
	str	w0, [x29, 116]
	add	x0, x25, :lo12:.LANCHOR53
	str	w1, [x28, 56]
	str	x0, [x29, 104]
.L2152:
	ldr	w0, [x29, 156]
	cmp	w19, w0
	bge	.L2171
	ldr	w0, [x29, 116]
	sxtw	x26, w19
	cmp	w19, w0
	bne	.L2153
	lsl	x0, x26, 1
	mov	w1, 1
	add	x21, x23, x0
	adrp	x27, .LANCHOR57
	add	x27, x27, :lo12:.LANCHOR57
	mov	w25, 0
	ldrh	w0, [x23, x0]
	bl	FtlGetLastWrittenPage
	sxth	w23, w0
	add	w0, w0, 1
	strh	w0, [x28, 2]
	ldr	x0, [x29, 144]
	strh	w19, [x28]
	ldr	w0, [x0, x26, lsl 2]
	adrp	x26, .LANCHOR2
	str	w0, [x28, 48]
	add	x26, x26, :lo12:.LANCHOR2
	ldr	x0, [x29, 128]
	add	x19, x0, :lo12:.LANCHOR203
.L2154:
	cmp	w25, w23
	ble	.L2157
.L2171:
	mov	x0, x28
	bl	ftl_free_no_use_map_blk
	adrp	x0, .LANCHOR53
	ldrh	w1, [x28, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L2159
	mov	x0, x28
	bl	ftl_map_blk_alloc_new_blk
.L2159:
	mov	x0, x28
	bl	ftl_map_blk_gc
	mov	x0, x28
	bl	ftl_map_blk_gc
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L2157:
	ldrh	w0, [x21]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w25, w0, lsl 10
	str	w0, [x19, 4]
	mov	x0, x19
	bl	FlashReadPages
	ldrb	w0, [x26]
	cbz	w0, .L2155
	ldr	x0, [x19, 16]
	ldr	w0, [x0, 12]
	str	w0, [x29, 156]
	uxtw	x0, w0
	cbz	w0, .L2155
	ldrh	w1, [x27]
	ldr	x0, [x19, 8]
	bl	js_hash
	ldr	w1, [x29, 156]
	cmp	w1, w0
	beq	.L2155
	mov	w0, -1
	str	w0, [x19]
.L2155:
	ldr	w0, [x19]
	cmn	w0, #1
	beq	.L2156
	ldrh	w0, [x20, 8]
	cmp	w24, w0
	bls	.L2156
	ldrh	w2, [x20]
	ldrh	w1, [x28, 4]
	cmp	w2, w1
	bne	.L2156
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x19, 4]
	str	w1, [x22, x0]
.L2156:
	add	w25, w25, 1
	sxth	w25, w25
	b	.L2154
.L2153:
	lsl	x26, x26, 1
	ldr	x0, [x21, #:lo12:.LANCHOR183]
	str	x0, [x27, 8]
	add	x0, x23, x26
	ldrh	w1, [x25, #:lo12:.LANCHOR53]
	mov	w2, 1
	str	x0, [x29, 136]
	ldrh	w0, [x23, x26]
	sub	w1, w1, #1
	orr	w0, w1, w0, lsl 10
	mov	w1, w2
	str	w0, [x27, 4]
	mov	x0, x27
	bl	FlashReadPages
	ldr	w0, [x27]
	cmn	w0, #1
	beq	.L2173
	ldrh	w1, [x20]
	ldrh	w0, [x28, 4]
	cmp	w1, w0
	bne	.L2173
	ldrh	w1, [x20, 8]
	mov	w0, 64245
	cmp	w1, w0
	beq	.L2161
.L2173:
	adrp	x26, .LANCHOR57
	add	x26, x26, :lo12:.LANCHOR57
	adrp	x0, .LANCHOR2
	mov	w5, 0
	add	x0, x0, :lo12:.LANCHOR2
	str	x0, [x29, 120]
.L2162:
	ldr	x0, [x29, 104]
	ldrh	w0, [x0]
	cmp	w5, w0
	bge	.L2169
	ldr	x0, [x29, 136]
	mov	w2, 1
	str	w5, [x29, 152]
	mov	w1, w2
	ldrh	w0, [x0]
	orr	w0, w5, w0, lsl 10
	str	w0, [x27, 4]
	mov	x0, x27
	bl	FlashReadPages
	ldr	x0, [x29, 120]
	ldr	w5, [x29, 152]
	ldrb	w0, [x0]
	cbz	w0, .L2166
	ldr	x0, [x27, 16]
	ldr	w0, [x0, 12]
	str	w0, [x29, 152]
	uxtw	x0, w0
	cbz	w0, .L2166
	ldrh	w1, [x26]
	ldr	x0, [x27, 8]
	str	w5, [x29, 112]
	bl	js_hash
	ldr	w1, [x29, 152]
	ldr	w5, [x29, 112]
	cmp	w1, w0
	beq	.L2166
	mov	w0, -1
	str	w0, [x27]
.L2166:
	ldr	w0, [x27]
	cmn	w0, #1
	beq	.L2167
	ldrh	w0, [x20, 8]
	cmp	w24, w0
	bls	.L2167
	ldrh	w2, [x20]
	ldrh	w1, [x28, 4]
	cmp	w2, w1
	bne	.L2167
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x27, 4]
	str	w1, [x22, x0]
.L2167:
	add	w5, w5, 1
	sxth	w5, w5
	b	.L2162
.L2161:
	ldrh	w5, [x25, #:lo12:.LANCHOR53]
	mov	w0, 0
	ldr	x6, [x21, #:lo12:.LANCHOR183]
	sub	w5, w5, #1
.L2163:
	cmp	w0, w5
	blt	.L2165
.L2169:
	add	w19, w19, 1
	sxth	w19, w19
	b	.L2152
.L2165:
	lsl	w2, w0, 1
	sxtw	x2, w2
	lsl	x1, x2, 2
	ldrh	w1, [x6, x1]
	cmp	w24, w1
	bls	.L2164
	add	x2, x2, 1
	ubfiz	x1, x1, 2, 16
	ldr	w2, [x6, x2, lsl 2]
	str	w2, [x22, x1]
.L2164:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L2163
	.size	FtlMapTblRecovery, .-FtlMapTblRecovery
	.section	.text.FtlLoadVonderInfo,"ax",@progbits
	.align	2
	.global	FtlLoadVonderInfo
	.type	FtlLoadVonderInfo, %function
FtlLoadVonderInfo:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR61
	adrp	x0, .LANCHOR216
	add	x0, x0, :lo12:.LANCHOR216
	add	x29, sp, 0
	ldrh	w1, [x1, #:lo12:.LANCHOR61]
	strh	w1, [x0, 10]
	mov	w1, -3962
	strh	w1, [x0, 4]
	adrp	x1, .LANCHOR70
	ldrh	w1, [x1, #:lo12:.LANCHOR70]
	strh	w1, [x0, 8]
	adrp	x1, .LANCHOR62
	ldrh	w1, [x1, #:lo12:.LANCHOR62]
	strh	w1, [x0, 6]
	adrp	x1, .LANCHOR71
	ldr	x1, [x1, #:lo12:.LANCHOR71]
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
	.section	.text.ftl_scan_all_ppa,"ax",@progbits
	.align	2
	.global	ftl_scan_all_ppa
	.type	ftl_scan_all_ppa, %function
ftl_scan_all_ppa:
	sub	sp, sp, #96
	adrp	x0, .LC53
	add	x0, x0, :lo12:.LC53
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x21, x22, [sp, 48]
	adrp	x22, .LANCHOR52
	adrp	x21, .LANCHOR51
	stp	x23, x24, [sp, 64]
	ldrh	w2, [x22, #:lo12:.LANCHOR52]
	adrp	x24, .LC54
	ldrh	w1, [x21, #:lo12:.LANCHOR51]
	add	x24, x24, :lo12:.LC54
	stp	x19, x20, [sp, 32]
	adrp	x19, .LANCHOR203
	add	x19, x19, :lo12:.LANCHOR203
	mov	w23, 0
	stp	x25, x26, [sp, 80]
	bl	printf
.L2198:
	ldrh	w0, [x21, #:lo12:.LANCHOR51]
	cmp	w23, w0
	bcs	.L2200
	lsl	w26, w23, 10
	mov	w20, 0
	add	x25, x22, :lo12:.LANCHOR52
	b	.L2201
.L2199:
	add	w0, w20, w26
	stp	wzr, w0, [x19]
	adrp	x0, .LANCHOR183
	mov	w2, 0
	mov	w1, 1
	add	w20, w20, 1
	ldr	x0, [x0, #:lo12:.LANCHOR183]
	str	x0, [x19, 8]
	adrp	x0, .LANCHOR188
	ldr	x0, [x0, #:lo12:.LANCHOR188]
	str	x0, [x19, 16]
	mov	x0, x19
	bl	FlashReadPages
	ldp	x1, x0, [x19, 8]
	ldr	w2, [x1, 4]
	str	w2, [sp]
	ldp	w3, w4, [x0]
	ldp	w5, w6, [x0, 8]
	mov	x0, x24
	ldr	w7, [x1]
	ldp	w2, w1, [x19]
	bl	printf
.L2201:
	ldrh	w0, [x25]
	cmp	w20, w0
	bcc	.L2199
	add	w23, w23, 1
	b	.L2198
.L2200:
	ldp	x19, x20, [sp, 32]
	adrp	x1, .LANCHOR227
	ldp	x21, x22, [sp, 48]
	add	x1, x1, :lo12:.LANCHOR227
	ldp	x23, x24, [sp, 64]
	adrp	x0, .LC55
	ldp	x25, x26, [sp, 80]
	add	x0, x0, :lo12:.LC55
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 96
	b	printf
	.size	ftl_scan_all_ppa, .-ftl_scan_all_ppa
	.section	.text.FlashReadFacBbtData,"ax",@progbits
	.align	2
	.global	FlashReadFacBbtData
	.type	FlashReadFacBbtData, %function
FlashReadFacBbtData:
	stp	x29, x30, [sp, -160]!
	add	x29, sp, 0
	stp	x25, x26, [sp, 64]
	mov	w25, w1
	adrp	x1, .LANCHOR14
	add	x1, x1, :lo12:.LANCHOR14
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
.L2204:
	cmp	w19, w20
	ble	.L2211
	mov	w0, -1
.L2203:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L2211:
	add	w0, w20, w26
	mov	w2, 1
	lsl	w0, w0, 10
	mov	w1, w2
	str	w0, [x29, 108]
	add	x0, x29, 104
	bl	FlashReadPages
	ldr	w0, [x29, 104]
	cmn	w0, #1
	beq	.L2205
	ldr	x0, [x22, #:lo12:.LANCHOR197]
	ldrh	w0, [x0]
	cmp	w0, w27
	bne	.L2205
	cbz	x23, .L2212
	cbz	w25, .L2207
.L2210:
	ldr	x1, [x21, #:lo12:.LANCHOR147]
	mov	w2, w24
	mov	x0, x23
	bl	ftl_memcpy
	mov	w3, 4
	adrp	x0, .LC56
	mov	w2, w3
	mov	x1, x23
	add	x0, x0, :lo12:.LC56
	bl	rknand_print_hex
.L2212:
	mov	w0, 0
	b	.L2203
.L2207:
	ldr	x5, [x21, #:lo12:.LANCHOR147]
	adrp	x2, .LANCHOR149
	add	x2, x2, :lo12:.LANCHOR149
	mov	w0, 0
	mov	w6, 1
.L2208:
	ldr	w1, [x2]
	cmp	w0, w1
	bcs	.L2210
	ubfx	x1, x0, 5, 11
	and	w3, w0, 31
	lsl	x1, x1, 2
	add	w0, w0, 1
	lsl	w4, w6, w3
	and	w0, w0, 65535
	ldr	w3, [x5, x1]
	orr	w3, w3, w4
	str	w3, [x5, x1]
	b	.L2208
.L2205:
	sub	w20, w20, #1
	and	w20, w20, 65535
	b	.L2204
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
	bne	.L2218
.L2222:
	mov	w0, 0
.L2219:
	ubfiz	x0, x0, 1, 16
	mov	w1, -1
	ldr	x21, [sp, 32]
	strh	w1, [x20, x0]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L2218:
	ldr	x4, [x21, #:lo12:.LANCHOR153]
	lsr	w5, w19, 4
	sub	w19, w19, #1
	mov	w1, 0
	mov	w0, 0
	mov	w6, 1
.L2220:
	cmp	w1, w19
	bge	.L2219
	ubfx	x3, x1, 5, 11
	and	w2, w1, 31
	lsl	w2, w6, w2
	ldr	w3, [x4, x3, lsl 2]
	tst	w2, w3
	beq	.L2221
	add	w2, w0, 1
	ubfiz	x0, x0, 1, 16
	strh	w1, [x20, x0]
	and	w0, w2, 65535
.L2221:
	cmp	w0, w5
	bcs	.L2222
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L2220
	.size	FlashGetBadBlockList, .-FlashGetBadBlockList
	.section	.text.FtlMakeBbt,"ax",@progbits
	.align	2
	.global	FtlMakeBbt
	.type	FtlMakeBbt, %function
FtlMakeBbt:
	stp	x29, x30, [sp, -128]!
	adrp	x0, .LANCHOR76
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	ldr	w21, [x0, #:lo12:.LANCHOR76]
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w21, .L2229
	adrp	x20, .LANCHOR74
	add	x22, x20, :lo12:.LANCHOR74
	bl	FtlBbtMemInit
	add	x24, x22, 32
	bl	FtlLoadFactoryBbt
	adrp	x28, .LANCHOR203
	add	x22, x22, 12
	add	x25, x28, :lo12:.LANCHOR203
	adrp	x0, .LANCHOR45
	add	x0, x0, :lo12:.LANCHOR45
	str	x0, [x29, 120]
.L2230:
	ldr	x0, [x29, 120]
	ldrh	w0, [x0]
	cmp	w21, w0
	bcc	.L2236
	adrp	x21, .LANCHOR59
	add	x21, x21, :lo12:.LANCHOR59
	mov	w19, 0
.L2237:
	ldrh	w0, [x21]
	cmp	w0, w19
	bhi	.L2238
	add	x21, x20, :lo12:.LANCHOR74
	mov	w22, 65535
	ldrh	w19, [x21, 12]
	sub	w19, w19, #1
	and	w19, w19, 65535
.L2239:
	ldrh	w0, [x21, 12]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L2243
	mov	w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L2240
	mov	w0, w19
	bl	FlashTestBlk
	cbz	w0, .L2241
	mov	w0, w19
	bl	FtlBbmMapBadBlock
.L2240:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L2239
.L2236:
	adrp	x2, .LANCHOR188
	adrp	x0, .LANCHOR183
	add	x19, x28, :lo12:.LANCHOR203
	ldrh	w1, [x22]
	ldr	x0, [x0, #:lo12:.LANCHOR183]
	mov	w3, 65535
	ldr	x26, [x2, #:lo12:.LANCHOR188]
	cmp	w1, w3
	stp	x0, x26, [x19, 8]
	adrp	x23, .LANCHOR51
	str	x2, [x29, 112]
	beq	.L2231
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
.L2232:
	mov	w0, w27
	add	w21, w21, 1
	bl	FtlBbmMapBadBlock
	add	x24, x24, 8
	add	x22, x22, 2
	b	.L2230
.L2231:
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
.L2233:
	ldrh	w0, [x23]
	madd	w0, w21, w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L2234
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
	bne	.L2232
	mov	w0, w27
	bl	FtlBbmMapBadBlock
	b	.L2233
.L2234:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L2233
.L2238:
	mov	w0, w19
	add	w19, w19, 1
	bl	FtlBbmMapBadBlock
	and	w19, w19, 65535
	b	.L2237
.L2241:
	ldrh	w0, [x21]
	cmp	w0, w22
	bne	.L2242
	strh	w19, [x21]
	b	.L2240
.L2242:
	strh	w19, [x21, 4]
.L2243:
	adrp	x0, .LANCHOR77
	add	x19, x20, :lo12:.LANCHOR74
	ldrh	w1, [x20, #:lo12:.LANCHOR74]
	mov	w2, 2
	ldr	x0, [x0, #:lo12:.LANCHOR77]
	str	wzr, [x19, 8]
	lsl	w1, w1, 10
	strh	wzr, [x19, 2]
	str	w1, [x0, 4]
	ldrh	w1, [x19, 4]
	lsl	w1, w1, 10
	str	w1, [x0, 60]
	mov	w1, 1
	bl	FlashEraseBlocks
	ldrh	w0, [x20, #:lo12:.LANCHOR74]
	bl	FtlBbmMapBadBlock
	ldrh	w0, [x19, 4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	strh	wzr, [x19, 2]
	ldr	w0, [x19, 8]
	ldrh	w1, [x19, 4]
	add	w0, w0, 1
	str	w0, [x19, 8]
	ldrh	w0, [x20, #:lo12:.LANCHOR74]
	strh	w0, [x19, 4]
	strh	w1, [x20, #:lo12:.LANCHOR74]
	bl	FtlBbmTblFlush
.L2229:
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
	stp	x25, x26, [sp, 64]
	mov	w25, w0
	adrp	x0, .LANCHOR56
	stp	x23, x24, [sp, 48]
	stp	x19, x20, [sp, 16]
	mov	x26, x1
	ldrh	w24, [x0, #:lo12:.LANCHOR56]
	adrp	x0, .LANCHOR72
	stp	x21, x22, [sp, 32]
	mov	x19, x0
	ldr	w1, [x0, #:lo12:.LANCHOR72]
	stp	x27, x28, [sp, 80]
	str	w2, [x29, 116]
	cmp	w25, w1
	bcc	.L2250
	mov	w2, 884
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
.L2250:
	ldr	w0, [x19, #:lo12:.LANCHOR72]
	cmp	w25, w0
	bcs	.L2251
	adrp	x19, .LANCHOR96
	add	w24, w24, 7
	adrp	x0, .LANCHOR67
	ldr	x2, [x19, #:lo12:.LANCHOR96]
	lsr	w23, w25, w24
	and	w22, w23, 65535
	ldrh	w1, [x0, #:lo12:.LANCHOR67]
	mov	x0, 0
.L2252:
	and	x20, x0, 65535
	cmp	w20, w1
	bcc	.L2257
	bl	select_l2p_ram_region
	and	x20, x0, 65535
	ldr	x1, [x19, #:lo12:.LANCHOR96]
	ubfiz	x21, x20, 4, 16
	add	x2, x1, x21
	ldrh	w3, [x1, x21]
	mov	w1, 65535
	cmp	w3, w1
	beq	.L2258
	ldr	w1, [x2, 4]
	tbz	w1, #31, .L2258
	bl	flush_l2p_region
.L2258:
	adrp	x0, .LANCHOR66
	str	x0, [x29, 104]
	ldrh	w1, [x0, #:lo12:.LANCHOR66]
	cmp	w1, w22
	bcs	.L2259
	mov	w2, 526
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
.L2259:
	adrp	x27, .LANCHOR131
	ubfiz	x0, x22, 2, 16
	ldr	x1, [x27, #:lo12:.LANCHOR131]
	ldr	w3, [x1, x0]
	cbnz	w3, .L2260
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	adrp	x1, .LANCHOR57
	add	x0, x0, x21
	ldrh	w2, [x1, #:lo12:.LANCHOR57]
	mov	w1, 255
	ldr	x0, [x0, 8]
	bl	ftl_memset
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	add	x1, x0, x21
	strh	w22, [x0, x21]
	str	wzr, [x1, 4]
	b	.L2254
.L2251:
	ldr	w1, [x29, 116]
	mov	w0, -1
	cbnz	w1, .L2249
	str	w0, [x26]
.L2249:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2257:
	add	x0, x0, 1
	add	x3, x2, x0, lsl 4
	ldrh	w3, [x3, -16]
	cmp	w3, w22
	bne	.L2252
.L2254:
	mov	x0, 1
	lsl	x24, x0, x24
	ldr	w0, [x29, 116]
	sub	w24, w24, #1
	and	w25, w24, w25
	and	x25, x25, 65535
	cbnz	w0, .L2255
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	add	x0, x0, x20, lsl 4
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x25, lsl 2]
	str	w0, [x26]
.L2256:
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	add	x20, x0, x20, lsl 4
	ldr	w0, [x20, 4]
	cmn	w0, #1
	beq	.L2265
	add	w0, w0, 1
	str	w0, [x20, 4]
.L2265:
	mov	w0, 0
	b	.L2249
.L2255:
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	ldr	w2, [x26]
	add	x0, x0, x20, lsl 4
	ldr	x1, [x0, 8]
	str	w2, [x1, x25, lsl 2]
	ldr	w1, [x0, 4]
	orr	w1, w1, -2147483648
	str	w1, [x0, 4]
	adrp	x0, .LANCHOR97
	strh	w22, [x0, #:lo12:.LANCHOR97]
	b	.L2256
.L2260:
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	adrp	x5, .LANCHOR203
	add	x28, x5, :lo12:.LANCHOR203
	mov	w2, 1
	add	x0, x0, x21
	str	x5, [x29, 96]
	str	w3, [x29, 112]
	mov	w1, w2
	str	w3, [x28, 4]
	ldr	x0, [x0, 8]
	str	x0, [x28, 8]
	adrp	x0, .LANCHOR188
	ldr	x0, [x0, #:lo12:.LANCHOR188]
	str	x0, [x28, 16]
	mov	x0, x28
	bl	FlashReadPages
	ldr	x0, [x28, 16]
	str	x0, [x29, 120]
	ldr	w3, [x29, 112]
	ldr	x5, [x29, 96]
	ldrh	w0, [x0, 8]
	cmp	w0, w22
	beq	.L2261
	mov	w2, w3
	and	w1, w23, 65535
	adrp	x0, .LC57
	add	x0, x0, :lo12:.LC57
	bl	printf
	ldr	x1, [x28, 16]
	mov	w3, 4
	adrp	x0, .LC27
	mov	w2, w3
	add	x0, x0, :lo12:.LC27
	bl	rknand_print_hex
	ldr	x0, [x29, 104]
	mov	w2, 4
	ldr	x1, [x27, #:lo12:.LANCHOR131]
	ldrh	w3, [x0, #:lo12:.LANCHOR66]
	adrp	x0, .LC58
	add	x0, x0, :lo12:.LC58
	bl	rknand_print_hex
	adrp	x0, .LANCHOR76
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR76]
.L2262:
	ldr	x0, [x29, 120]
	ldrh	w0, [x0, 8]
	cmp	w0, w22
	beq	.L2263
	mov	w2, 552
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
.L2263:
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	add	x1, x0, x21
	str	wzr, [x1, 4]
	strh	w22, [x0, x21]
	b	.L2254
.L2261:
	ldr	w0, [x5, #:lo12:.LANCHOR203]
	cmp	w0, 256
	bne	.L2262
	and	w23, w23, 65535
	mov	w2, w3
	mov	w1, w23
	adrp	x0, .LC59
	add	x0, x0, :lo12:.LC59
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	mov	w1, w23
	add	x0, x0, x21
	ldr	x2, [x0, 8]
	adrp	x0, .LANCHOR127
	add	x0, x0, :lo12:.LANCHOR127
	bl	FtlMapWritePage
	b	.L2262
	.size	log2phys, .-log2phys
	.section	.text.FtlProgPages,"ax",@progbits
	.align	2
	.global	FtlProgPages
	.type	FtlProgPages, %function
FtlProgPages:
	stp	x29, x30, [sp, -96]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR76
	stp	x19, x20, [sp, 16]
	ldr	w2, [x23, #:lo12:.LANCHOR76]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	cbnz	w2, .L2268
	adrp	x2, .LANCHOR15
	ldrb	w2, [x2, #:lo12:.LANCHOR15]
	cbz	w2, .L2283
	ldrb	w2, [x3, 8]
	cmp	w2, 1
	cset	w22, eq
.L2270:
	mov	x20, x3
	ldrb	w3, [x3, 9]
	mov	w21, w1
	mov	x19, x0
	mov	w2, w22
	adrp	x25, .LANCHOR52
	adrp	x24, .LANCHOR138
	add	x25, x25, :lo12:.LANCHOR52
	bl	FlashProgPages
	add	x24, x24, :lo12:.LANCHOR138
	mov	w1, 56
	umaddl	x21, w21, w1, x19
.L2271:
	cmp	x19, x21
	beq	.L2280
	adrp	x26, .LANCHOR83
	b	.L2281
.L2283:
	mov	w22, 0
	b	.L2270
.L2274:
	ldr	w0, [x19, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	ldrh	w1, [x20]
	cmp	w1, w0, uxth
	bne	.L2272
	ldr	x2, [x26, #:lo12:.LANCHOR83]
	ubfiz	x1, x1, 1, 16
	ldrh	w3, [x20, 4]
	ldrh	w0, [x2, x1]
	sub	w0, w0, w3
	strh	w0, [x2, x1]
	strb	wzr, [x20, 6]
	ldrh	w0, [x25]
	strh	w0, [x20, 2]
	strh	wzr, [x20, 4]
.L2272:
	ldrh	w0, [x20, 4]
	cbnz	w0, .L2273
	mov	x0, x20
	bl	allocate_new_data_superblock
.L2273:
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
	ldr	w0, [x23, #:lo12:.LANCHOR76]
	cbnz	w0, .L2268
.L2281:
	ldr	w0, [x19]
	cmn	w0, #1
	beq	.L2274
	adrp	x0, .LANCHOR38
	ldrb	w1, [x20, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcc	.L2275
	mov	w2, 1588
	adrp	x1, .LANCHOR230
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR230
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2275:
	ldr	w0, [x19, 4]
	cbnz	w22, .L2276
.L2288:
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
	beq	.L2278
	adrp	x2, .LANCHOR83
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR83]
	ldrh	w0, [x2, x0]
	cbnz	w0, .L2279
	adrp	x0, .LC60
	mov	w2, 0
	add	x0, x0, :lo12:.LC60
	bl	printf
.L2279:
	mov	w0, w26
	bl	decrement_vpc_count
.L2278:
	add	x19, x19, 56
	b	.L2271
.L2276:
	orr	w0, w0, -2147483648
	b	.L2288
.L2280:
	adrp	x0, .LANCHOR38
	ldrb	w1, [x20, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcc	.L2268
	mov	w2, 1605
	adrp	x1, .LANCHOR230
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR230
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2268:
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
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbnz	w0, .L2295
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR132
	ldr	x0, [x19, #:lo12:.LANCHOR132]
	cbz	x0, .L2290
	adrp	x1, .LANCHOR231
	mov	w2, 0
	ldr	x3, [x1, #:lo12:.LANCHOR231]
	mov	w1, 1
	bl	FtlProgPages
	str	xzr, [x19, #:lo12:.LANCHOR132]
.L2290:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2295:
	mov	w0, 0
	ret
	.size	FtlCacheWriteBack, .-FtlCacheWriteBack
	.section	.text.FtlSysFlush,"ax",@progbits
	.align	2
	.global	FtlSysFlush
	.type	FtlSysFlush, %function
FtlSysFlush:
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbnz	w0, .L2301
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
.L2301:
	mov	w0, 0
	ret
	.size	FtlSysFlush, .-FtlSysFlush
	.section	.text.FtlDeInit,"ax",@progbits
	.align	2
	.global	FtlDeInit
	.type	FtlDeInit, %function
FtlDeInit:
	adrp	x0, .LANCHOR232
	ldr	w0, [x0, #:lo12:.LANCHOR232]
	cmp	w0, 1
	bne	.L2307
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	FtlSysFlush
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L2307:
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
	adrp	x0, .LANCHOR68
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, w1
	ldr	w0, [x0, #:lo12:.LANCHOR68]
	add	w1, w1, w2
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	cmp	w1, w0
	bhi	.L2320
	mov	w19, w2
	cmp	w2, 31
	bhi	.L2314
.L2328:
	mov	w0, 0
.L2312:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2314:
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbnz	w0, .L2328
	adrp	x22, .LANCHOR55
	bl	FtlCacheWriteBack
	ldrh	w0, [x22, #:lo12:.LANCHOR55]
	udiv	w21, w20, w0
	msub	w20, w0, w21, w20
	ands	w20, w20, 65535
	beq	.L2316
	sub	w0, w0, w20
	add	w21, w21, 1
	cmp	w0, w19
	csel	w0, w0, w19, ls
	sub	w19, w19, w0, uxth
.L2316:
	adrp	x20, .LANCHOR233
	adrp	x23, .LANCHOR163
	add	x20, x20, :lo12:.LANCHOR233
	add	x23, x23, :lo12:.LANCHOR163
	mov	w0, -1
	str	w0, [x29, 76]
.L2317:
	ldrh	w0, [x22, #:lo12:.LANCHOR55]
	cmp	w19, w0
	bcs	.L2319
	adrp	x0, .LANCHOR233
	ldr	w1, [x0, #:lo12:.LANCHOR233]
	cmp	w1, 32
	bls	.L2328
	str	wzr, [x0, #:lo12:.LANCHOR233]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L2328
.L2319:
	mov	w2, 0
	add	x1, x29, 72
	mov	w0, w21
	bl	log2phys
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L2318
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
.L2318:
	ldrh	w0, [x22, #:lo12:.LANCHOR55]
	add	w21, w21, 1
	sub	w19, w19, w0
	b	.L2317
.L2320:
	mov	w0, -1
	b	.L2312
	.size	ftl_discard, .-ftl_discard
	.section	.text.FtlCheckVpc,"ax",@progbits
	.align	2
	.global	FtlCheckVpc
	.type	FtlCheckVpc, %function
FtlCheckVpc:
	stp	x29, x30, [sp, -112]!
	adrp	x0, .LC46
	add	x0, x0, :lo12:.LC46
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR72
	add	x23, x23, :lo12:.LANCHOR72
	stp	x21, x22, [sp, 32]
	mov	w22, 0
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	adrp	x21, .LANCHOR234
	stp	x27, x28, [sp, 80]
	add	x1, x21, :lo12:.LANCHOR234
	adrp	x20, check_valid_page_count_table
	bl	printf
	add	x19, x20, :lo12:check_valid_page_count_table
	mov	x2, 8192
	mov	w1, 0
	mov	x0, x19
	bl	memset
.L2330:
	ldr	w0, [x23]
	cmp	w22, w0
	bcc	.L2332
	adrp	x22, .LANCHOR40
	adrp	x24, .LC61
	add	x22, x22, :lo12:.LANCHOR40
	add	x26, x20, :lo12:check_valid_page_count_table
	add	x24, x24, :lo12:.LC61
	mov	w23, 0
	mov	w19, 0
	adrp	x25, .LANCHOR83
.L2333:
	ldrh	w0, [x22]
	cmp	w0, w19
	bhi	.L2335
	adrp	x0, .LANCHOR87
	ldr	x19, [x0, #:lo12:.LANCHOR87]
	cbz	x19, .L2336
	adrp	x0, .LANCHOR88
	adrp	x25, .LC62
	add	x20, x20, :lo12:check_valid_page_count_table
	add	x25, x25, :lo12:.LC62
	ldrh	w26, [x0, #:lo12:.LANCHOR88]
	adrp	x0, .LANCHOR81
	mov	x24, x0
	mov	w22, 0
	ldr	x1, [x0, #:lo12:.LANCHOR81]
	adrp	x27, .LANCHOR83
	mov	w28, 6
	sub	x19, x19, x1
	mov	x1, -6148914691236517206
	asr	x19, x19, 1
	movk	x1, 0xaaab, lsl 0
	mul	x19, x19, x1
	and	w19, w19, 65535
.L2337:
	cmp	w22, w26
	bne	.L2339
.L2336:
	cbz	w23, .L2329
	mov	w2, 1688
	add	x1, x21, :lo12:.LANCHOR234
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2329:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2332:
	mov	w2, 0
	add	x1, x29, 108
	mov	w0, w22
	bl	log2phys
	ldr	w0, [x29, 108]
	cmn	w0, #1
	beq	.L2331
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	and	x0, x0, 65535
	ldrh	w1, [x19, x0, lsl 1]
	add	w1, w1, 1
	strh	w1, [x19, x0, lsl 1]
.L2331:
	add	w22, w22, 1
	b	.L2330
.L2335:
	ldr	x0, [x25, #:lo12:.LANCHOR83]
	ubfiz	x28, x19, 1, 16
	sxtw	x27, w19
	ldrh	w2, [x0, x28]
	ldrh	w3, [x26, x27, lsl 1]
	cmp	w2, w3
	beq	.L2334
	mov	w1, w19
	mov	x0, x24
	bl	printf
	ldr	x0, [x25, #:lo12:.LANCHOR83]
	mov	w1, 65535
	ldrh	w0, [x0, x28]
	cmp	w0, w1
	beq	.L2334
	ldrh	w1, [x26, x27, lsl 1]
	cmp	w1, w0
	csinc	w23, w23, wzr, ls
.L2334:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2333
.L2339:
	ldr	x1, [x27, #:lo12:.LANCHOR83]
	ubfiz	x0, x19, 1, 16
	ldrh	w2, [x1, x0]
	cbz	w2, .L2338
	ldrh	w3, [x20, w19, sxtw 1]
	mov	w23, 1
	mov	w1, w19
	mov	x0, x25
	bl	printf
.L2338:
	ldr	x0, [x24, #:lo12:.LANCHOR81]
	umull	x19, w19, w28
	ldrh	w19, [x0, x19]
	mov	w0, 65535
	cmp	w19, w0
	beq	.L2336
	add	w22, w22, 1
	and	w22, w22, 65535
	b	.L2337
	.size	FtlCheckVpc, .-FtlCheckVpc
	.section	.text.Ftlscanalldata,"ax",@progbits
	.align	2
	.global	Ftlscanalldata
	.type	Ftlscanalldata, %function
Ftlscanalldata:
	sub	sp, sp, #96
	adrp	x0, .LC63
	mov	w1, 0
	add	x0, x0, :lo12:.LC63
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x20, .LANCHOR203
	stp	x21, x22, [sp, 48]
	mov	w19, 0
	adrp	x21, .LANCHOR72
	add	x22, x20, :lo12:.LANCHOR203
	add	x21, x21, :lo12:.LANCHOR72
	str	x23, [sp, 64]
	bl	printf
.L2355:
	ldr	w0, [x21]
	cmp	w19, w0
	bcc	.L2361
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x29, x30, [sp, 16]
	ldr	x23, [sp, 64]
	add	sp, sp, 96
	ret
.L2361:
	mov	w2, 0
	add	x1, x29, 76
	mov	w0, w19
	bl	log2phys
	tst	x19, 2047
	bne	.L2356
	ldr	w2, [x29, 76]
	adrp	x0, .LC64
	mov	w1, w19
	add	x0, x0, :lo12:.LC64
	bl	printf
.L2356:
	ldr	w1, [x29, 76]
	cmn	w1, #1
	beq	.L2358
	add	x0, x20, :lo12:.LANCHOR203
	str	wzr, [x20, #:lo12:.LANCHOR203]
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
	ldr	w0, [x20, #:lo12:.LANCHOR203]
	cmp	w0, 256
	ccmn	w0, #1, 4, ne
	beq	.L2359
	ldr	w0, [x23, 8]
	cmp	w19, w0
	beq	.L2358
.L2359:
	ldp	x1, x0, [x22, 8]
	ldr	w2, [x1, 4]
	str	w2, [sp]
	ldr	w2, [x22, 4]
	ldp	w3, w4, [x0]
	ldp	w5, w6, [x0, 8]
	adrp	x0, .LC65
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC65
	mov	w1, w19
	bl	printf
.L2358:
	add	w19, w19, 1
	b	.L2355
	.size	Ftlscanalldata, .-Ftlscanalldata
	.section	.text.FtlReUsePrevPpa,"ax",@progbits
	.align	2
	.global	FtlReUsePrevPpa
	.type	FtlReUsePrevPpa, %function
FtlReUsePrevPpa:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR83
	stp	x19, x20, [sp, 16]
	mov	w21, w0
	str	w1, [x29, 76]
	lsr	w0, w1, 10
	str	x23, [sp, 48]
	bl	P2V_block_in_plane
	ldr	x2, [x22, #:lo12:.LANCHOR83]
	and	w3, w0, 65535
	ubfiz	x20, x3, 1, 16
	ldrh	w1, [x2, x20]
	cbnz	w1, .L2364
	adrp	x0, .LANCHOR87
	ldr	x19, [x0, #:lo12:.LANCHOR87]
	cbz	x19, .L2365
	adrp	x2, .LANCHOR81
	mov	x5, -6148914691236517206
	movk	x5, 0xaaab, lsl 0
	adrp	x23, .LANCHOR88
	ldr	x2, [x2, #:lo12:.LANCHOR81]
	mov	w6, 65535
	ldrh	w4, [x23, #:lo12:.LANCHOR88]
	sub	x19, x19, x2
	asr	x19, x19, 1
	mul	x19, x19, x5
	mov	w5, 6
	and	w19, w19, 65535
.L2366:
	cmp	w1, w4
	beq	.L2365
	cmp	w19, w3
	bne	.L2367
	mov	w1, w19
	add	x0, x0, :lo12:.LANCHOR87
	bl	List_remove_node
	ldrh	w0, [x23, #:lo12:.LANCHOR88]
	cbnz	w0, .L2368
	mov	w2, 2099
	adrp	x1, .LANCHOR235
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR235
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2368:
	ldrh	w0, [x23, #:lo12:.LANCHOR88]
	sub	w0, w0, #1
	strh	w0, [x23, #:lo12:.LANCHOR88]
	mov	w0, w19
	bl	INSERT_DATA_LIST
	ldr	x1, [x22, #:lo12:.LANCHOR83]
	ldrh	w0, [x1, x20]
	add	w0, w0, 1
	strh	w0, [x1, x20]
.L2365:
	add	x1, x29, 76
	mov	w2, 1
	mov	w0, w21
	bl	log2phys
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2367:
	umull	x19, w19, w5
	ldrh	w19, [x2, x19]
	cmp	w19, w6
	beq	.L2365
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L2366
.L2364:
	add	w1, w1, 1
	strh	w1, [x2, x20]
	b	.L2365
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
	beq	.L2536
	ldrb	w0, [x19, 6]
	str	w0, [x29, 180]
	adrp	x0, .LANCHOR52
	ldrh	w26, [x19, 2]
	str	x0, [x29, 144]
	ldrh	w2, [x0, #:lo12:.LANCHOR52]
	cmp	w2, w26
	bne	.L2377
	strh	wzr, [x19, 4]
.L2543:
	strb	wzr, [x19, 6]
.L2536:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	ret
.L2377:
	ldrh	w0, [x19, 16]
	mov	w21, 0
.L2378:
	cmp	w0, w1
	beq	.L2379
	ldrb	w1, [x19, 8]
	cmp	w1, 1
	bne	.L2380
	bl	FtlGetLastWrittenPage
	mov	w20, w0
	cmn	w0, #1
	beq	.L2381
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbnz	w0, .L2458
	adrp	x0, .LANCHOR16
	add	x0, x0, :lo12:.LANCHOR16
	ldrh	w23, [x0, w20, sxtw 1]
.L2382:
	adrp	x1, .LANCHOR105
	adrp	x2, .LANCHOR38
	adrp	x22, .LANCHOR180
	add	x4, x19, 16
	ldr	x6, [x1, #:lo12:.LANCHOR105]
	adrp	x1, .LANCHOR58
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	mov	w27, 0
	ldrh	w7, [x1, #:lo12:.LANCHOR58]
	add	x1, x19, 16
	str	x1, [x29, 184]
	mov	w8, 65535
	ldrh	w1, [x2, #:lo12:.LANCHOR38]
	mov	w10, 56
	str	x2, [x29, 160]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L2383:
	cmp	x1, x4
	bne	.L2387
	ldrb	w1, [x19, 8]
	cmp	w1, 1
	bne	.L2459
	adrp	x1, .LANCHOR15
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	cmp	w1, 0
	cset	w1, ne
	str	w1, [x29, 176]
.L2388:
	ldr	w2, [x29, 176]
	mov	w1, w27
	adrp	x24, .LC66
	adrp	x25, .LANCHOR237
	add	x24, x24, :lo12:.LC66
	add	x25, x25, :lo12:.LANCHOR237
	mov	x28, 0
	bl	FlashReadPages
	adrp	x0, .LANCHOR160
	mov	w5, 65535
	str	x0, [x29, 168]
	ldr	w21, [x0, #:lo12:.LANCHOR160]
	sub	w21, w21, #1
.L2389:
	and	w0, w28, 65535
	cmp	w27, w0
	bhi	.L2394
	bne	.L2392
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	add	w20, w20, 1
	and	w20, w20, 65535
	ldr	w0, [x0, 4]
.L2538:
	lsr	w0, w0, 10
	bl	P2V_plane
	ldrb	w1, [x19, 8]
	and	w27, w0, 65535
	cmp	w1, 1
	bne	.L2396
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbnz	w0, .L2396
	adrp	x0, .LANCHOR16
	add	x0, x0, :lo12:.LANCHOR16
	ldrh	w20, [x0, w20, sxtw 1]
.L2396:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w20
	bne	.L2397
	strh	w20, [x19, 2]
	strb	wzr, [x19, 6]
	strh	wzr, [x19, 4]
.L2397:
	ldr	w0, [x29, 180]
	cmp	w20, w26
	cset	w2, eq
	cmp	w27, w0
	cset	w0, eq
	tst	w2, w0
	beq	.L2398
.L2544:
	mov	w2, w27
	mov	w1, w20
	mov	x0, x19
	bl	ftl_sb_update_avl_pages
	b	.L2536
.L2379:
	add	w21, w21, 1
	and	w21, w21, 65535
	add	x0, x19, x21, sxtw 1
	ldrh	w0, [x0, 16]
	b	.L2378
.L2380:
	mov	w1, 0
	bl	FtlGetLastWrittenPage
	mov	w20, w0
	cmn	w0, #1
	beq	.L2381
.L2458:
	mov	w23, w20
	b	.L2382
.L2381:
	cbz	w26, .L2384
	mov	w2, 2170
	adrp	x1, .LANCHOR236
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR236
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2384:
	ldr	w0, [x29, 180]
	cmp	w0, 0
	ccmp	w21, w0, 4, ne
	beq	.L2385
	mov	w2, 2171
	adrp	x1, .LANCHOR236
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR236
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2385:
	strh	wzr, [x19, 2]
	b	.L2543
.L2387:
	ldrh	w2, [x4]
	cmp	w2, w8
	beq	.L2386
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
.L2386:
	add	x4, x4, 2
	b	.L2383
.L2459:
	str	wzr, [x29, 176]
	b	.L2388
.L2394:
	mov	x0, 56
	ldr	x2, [x22, #:lo12:.LANCHOR180]
	mul	x0, x28, x0
	add	x1, x2, x0
	ldr	w0, [x2, x0]
	cbnz	w0, .L2390
	ldr	x6, [x1, 16]
	ldr	w4, [x6, 4]
	cmn	w4, #1
	beq	.L2391
	ldr	x0, [x29, 168]
	ldr	w1, [x0, #:lo12:.LANCHOR160]
	mov	w0, w4
	bl	ftl_cmp_data_ver
	cbz	w0, .L2391
	ldr	x0, [x29, 168]
	add	w4, w4, 1
	str	w4, [x0, #:lo12:.LANCHOR160]
.L2391:
	ldr	w0, [x6]
	cmn	w0, #1
	bne	.L2393
.L2392:
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	and	x28, x28, 65535
	mov	x1, 56
	and	w20, w20, 65535
	madd	x28, x28, x1, x0
	ldr	w0, [x28, 4]
	b	.L2538
.L2390:
	ldr	w1, [x1, 4]
	mov	x0, x24
	bl	printf
	ldrh	w0, [x19]
	and	w5, w23, 65535
	strh	w0, [x25]
.L2393:
	add	x28, x28, 1
	b	.L2389
.L2398:
	mov	w0, 65535
	cmp	w5, w0
	bne	.L2399
	cbnz	w1, .L2400
.L2399:
	adrp	x24, .LANCHOR136
	and	w6, w23, 65535
	ldr	w0, [x24, #:lo12:.LANCHOR136]
	cmn	w0, #1
	bne	.L2401
	str	w21, [x24, #:lo12:.LANCHOR136]
.L2401:
	add	w0, w26, 7
	ldr	w7, [x24, #:lo12:.LANCHOR136]
	cmp	w0, w23, uxth
	bge	.L2460
	sub	w23, w6, #7
	and	w23, w23, 65535
.L2402:
	mov	w3, -1
	adrp	x5, .LANCHOR120
	mov	w28, w3
	add	x5, x5, :lo12:.LANCHOR120
	mov	w4, 65535
.L2403:
	cmp	w23, w6
	bhi	.L2418
	ldr	x1, [x29, 160]
	mov	w25, 0
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	mov	w10, 56
	ldr	x2, [x29, 184]
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
	b	.L2419
.L2460:
	mov	w23, w26
	b	.L2402
.L2405:
	ldrh	w8, [x2]
	cmp	w8, w4
	beq	.L2404
	umaddl	x11, w25, w10, x0
	add	w25, w25, 1
	and	w25, w25, 65535
	orr	w8, w23, w8, lsl 10
	str	w8, [x11, 4]
.L2404:
	add	x2, x2, 2
.L2419:
	cmp	x2, x1
	bne	.L2405
	ldr	w2, [x29, 176]
	mov	w1, w25
	str	x5, [x29, 112]
	str	w4, [x29, 120]
	str	w7, [x29, 128]
	str	w6, [x29, 136]
	str	w3, [x29, 152]
	bl	FlashReadPages
	adrp	x1, .LANCHOR15
	mov	w2, 56
	ldr	w0, [x24, #:lo12:.LANCHOR136]
	sxtw	x12, w23
	ldrb	w10, [x1, #:lo12:.LANCHOR15]
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
.L2406:
	cmp	x25, x1
	bne	.L2416
	cbz	w2, .L2417
	str	w0, [x24, #:lo12:.LANCHOR136]
.L2417:
	add	w23, w23, 1
	and	w23, w23, 65535
	b	.L2403
.L2416:
	ldr	w8, [x1]
	cbnz	w8, .L2407
	ldr	x8, [x1, 16]
	ldrh	w13, [x8]
	cmp	w13, w4
	beq	.L2462
	ldr	w8, [x8, 4]
	cmn	w8, #1
	beq	.L2462
	cmn	w3, #1
	bne	.L2464
	ldrh	w2, [x5, x12, lsl 1]
	cmp	w2, w4
	bne	.L2409
	cbz	w10, .L2464
.L2409:
	cmp	w21, w0
	mov	w2, w11
	csel	w3, w3, w0, eq
.L2408:
	mov	w28, w0
	add	x1, x1, 56
	mov	w0, w8
	b	.L2406
.L2407:
	cbz	w2, .L2410
	str	w0, [x24, #:lo12:.LANCHOR136]
.L2410:
	adrp	x0, .LANCHOR237
	ldrh	w1, [x19]
	strh	w1, [x0, #:lo12:.LANCHOR237]
	ldrb	w0, [x19, 8]
	cbnz	w0, .L2400
	adrp	x0, .LANCHOR120
	add	x0, x0, :lo12:.LANCHOR120
	ldrh	w1, [x0, w23, sxtw 1]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2412
	cmn	w3, #1
	beq	.L2413
	str	w3, [x24, #:lo12:.LANCHOR136]
.L2400:
	adrp	x0, .LANCHOR238
	mov	w23, w26
	mov	w1, 1
	adrp	x28, .LANCHOR136
	strh	w1, [x0, #:lo12:.LANCHOR238]
	add	x0, x28, :lo12:.LANCHOR136
	str	x0, [x29, 112]
.L2420:
	ldr	x2, [x29, 160]
	adrp	x1, .LANCHOR15
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	mov	w24, 0
	ldrb	w5, [x1, #:lo12:.LANCHOR15]
	mov	w6, 65535
	ldr	x3, [x29, 184]
	ldrh	w2, [x2, #:lo12:.LANCHOR38]
	str	x1, [x29, 128]
	add	x2, x2, 8
	add	x2, x19, x2, lsl 1
.L2421:
	cmp	x2, x3
	bne	.L2424
	ldr	w2, [x29, 176]
	mov	w1, w24
	mov	x25, 0
	bl	FlashReadPages
	mov	w0, 56
	umull	x0, w24, w0
	str	x0, [x29, 136]
	adrp	x0, .LANCHOR237
	add	x0, x0, :lo12:.LANCHOR237
	str	x0, [x29, 120]
.L2425:
	ldr	x0, [x29, 136]
	cmp	x25, x0
	bne	.L2451
	ldrb	w0, [x19, 8]
	add	w23, w23, 1
	and	w23, w23, 65535
	cmp	w0, 1
	bne	.L2452
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L2452
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w23
	bne	.L2452
	cmp	w20, w23
	beq	.L2427
.L2452:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w23
	bne	.L2420
	ldr	x0, [x29, 160]
	mov	w2, 65535
	strh	w23, [x19, 2]
	strh	wzr, [x19, 4]
	ldrh	w1, [x0, #:lo12:.LANCHOR38]
	mov	w0, 0
.L2453:
	cmp	w0, w1
	beq	.L2536
	ldr	x4, [x29, 184]
	ldrh	w3, [x4], 2
	str	x4, [x29, 184]
	cmp	w3, w2
	beq	.L2454
	strb	w0, [x19, 6]
	b	.L2536
.L2413:
	cmp	w21, w7
	beq	.L2414
	str	w7, [x24, #:lo12:.LANCHOR136]
	b	.L2400
.L2414:
	ldr	w0, [x24, #:lo12:.LANCHOR136]
.L2545:
	sub	w0, w0, #1
.L2539:
	str	w0, [x24, #:lo12:.LANCHOR136]
	b	.L2400
.L2412:
	cmp	w28, w21
	beq	.L2415
	cmn	w28, #1
	beq	.L2400
	str	w28, [x24, #:lo12:.LANCHOR136]
	b	.L2400
.L2415:
	ldr	w0, [x24, #:lo12:.LANCHOR136]
	cmp	w21, w0
	bne	.L2545
	b	.L2400
.L2462:
	mov	w8, w0
	mov	w0, w28
	b	.L2408
.L2464:
	mov	w2, 1
	b	.L2408
.L2418:
	mov	w0, -1
	b	.L2539
.L2424:
	ldrh	w1, [x3]
	cmp	w1, w6
	beq	.L2422
	mov	w4, 56
	orr	w1, w23, w1, lsl 10
	umaddl	x4, w24, w4, x0
	str	w1, [x4, 4]
	ldrb	w7, [x19, 8]
	cmp	w7, 1
	bne	.L2423
	cbz	w5, .L2423
	orr	w1, w1, -2147483648
	str	w1, [x4, 4]
.L2423:
	add	w24, w24, 1
	and	w24, w24, 65535
.L2422:
	add	x3, x3, 2
	b	.L2421
.L2451:
	ldr	x4, [x22, #:lo12:.LANCHOR180]
	add	x4, x4, x25
	ldr	w5, [x4, 4]
	str	w5, [x29, 204]
	lsr	w0, w5, 10
	bl	P2V_plane
	and	w0, w0, 65535
	cmp	w23, w26
	bcc	.L2426
	ldr	w1, [x29, 180]
	ccmp	w1, w0, 0, eq
	bhi	.L2426
	cmp	w23, w20
	ccmp	w27, w0, 0, eq
	beq	.L2427
	ldr	w0, [x4]
	cmn	w0, #1
	beq	.L2428
	ldr	x3, [x4, 16]
	mov	w0, 61589
	ldrh	w1, [x3]
	cmp	w1, w0
	beq	.L2429
	ldrh	w0, [x19]
.L2541:
	bl	decrement_vpc_count
	b	.L2426
.L2429:
	ldr	w21, [x3, 4]
	cmn	w21, #1
	beq	.L2430
	ldr	x0, [x29, 168]
	ldr	w1, [x0, #:lo12:.LANCHOR160]
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L2430
	ldr	x1, [x29, 168]
	add	w0, w21, 1
	str	w0, [x1, #:lo12:.LANCHOR160]
.L2430:
	ldp	w24, w0, [x3, 8]
	add	x1, x29, 200
	str	w0, [x29, 196]
	mov	w2, 0
	mov	w0, w24
	bl	log2phys
	ldr	w1, [x28, #:lo12:.LANCHOR136]
	ldr	w3, [x29, 196]
	cmn	w1, #1
	beq	.L2431
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L2431
	cmn	w3, #1
	beq	.L2432
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	mov	w2, 0
	mov	w1, 1
	add	x0, x0, x25
	ldr	x4, [x0, 16]
	str	w3, [x0, 4]
	str	x4, [x29, 152]
	bl	FlashReadPages
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	ldr	x4, [x29, 152]
	add	x3, x0, x25
	ldr	w0, [x0, x25]
	cmn	w0, #1
	bne	.L2433
.L2434:
	mov	w0, -1
	str	w0, [x29, 196]
.L2441:
	ldr	w3, [x29, 196]
	cmn	w3, #1
	beq	.L2426
.L2457:
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	and	w24, w0, 65535
	adrp	x0, .LANCHOR40
	mov	w3, w24
	ldrh	w0, [x0, #:lo12:.LANCHOR40]
	cmp	w0, w24
	bhi	.L2447
	mov	w2, 2457
	adrp	x1, .LANCHOR236
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR236
	add	x0, x0, :lo12:.LC5
	str	w24, [x29, 152]
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
	ldr	w3, [x29, 152]
.L2447:
	adrp	x1, .LANCHOR83
	ubfiz	x0, x24, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR83]
	ldrh	w0, [x1, x0]
	cbz	w0, .L2448
	mov	w0, w3
	b	.L2541
.L2432:
	ldp	w1, w0, [x29, 200]
	cmp	w1, w0
	bne	.L2426
	mov	w2, 1
	add	x1, x29, 196
	mov	w0, w24
	bl	log2phys
.L2426:
	add	x25, x25, 56
	b	.L2425
.L2433:
	ldr	w0, [x4, 8]
	cmp	w24, w0
	bne	.L2434
	ldr	w0, [x4, 4]
	str	w0, [x29, 152]
	str	x4, [x29, 104]
	uxtw	x1, w0
	ldr	w0, [x28, #:lo12:.LANCHOR136]
	bl	ftl_cmp_data_ver
	cbz	w0, .L2434
	ldp	w0, w1, [x29, 200]
	ldr	x4, [x29, 104]
	cmp	w0, w1
	ldr	w1, [x29, 196]
	bne	.L2436
.L2540:
	mov	w0, w24
	bl	FtlReUsePrevPpa
	b	.L2434
.L2436:
	cmp	w0, w1
	beq	.L2434
	cmn	w0, #1
	beq	.L2437
	ldr	x4, [x3, 16]
	mov	w2, 0
	str	w0, [x3, 4]
	mov	w1, 1
	str	x4, [x29, 104]
	mov	x0, x3
	bl	FlashReadPages
	ldr	x4, [x29, 104]
.L2438:
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	ldr	w0, [x0, x25]
	cmn	w0, #1
	beq	.L2439
	ldr	x0, [x29, 112]
	ldr	w3, [x4, 4]
	mov	w1, w3
	ldr	w0, [x0]
	bl	ftl_cmp_data_ver
	cbz	w0, .L2439
	ldr	w0, [x29, 152]
	mov	w1, w3
	bl	ftl_cmp_data_ver
	cbz	w0, .L2434
.L2439:
	ldr	w1, [x29, 196]
	b	.L2540
.L2437:
	str	w0, [x3]
	b	.L2438
.L2431:
	ldp	w1, w0, [x29, 200]
	cmp	w1, w0
	beq	.L2441
	cmn	w3, #1
	beq	.L2443
	adrp	x0, .LANCHOR43
	ubfx	x3, x3, 10, 21
	ldr	w0, [x0, #:lo12:.LANCHOR43]
	cmp	w3, w0
	bcs	.L2426
.L2443:
	mov	w2, 1
	add	x1, x29, 204
	mov	w0, w24
	bl	log2phys
	ldr	w3, [x29, 200]
	cmn	w3, #1
	beq	.L2441
	ldr	w0, [x29, 196]
	cmp	w3, w0
	beq	.L2457
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	adrp	x1, .LANCHOR91
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR91]
	cmp	w1, w0
	beq	.L2446
	adrp	x1, .LANCHOR92
	ldrh	w1, [x1, #:lo12:.LANCHOR92]
	cmp	w1, w0
	beq	.L2446
	adrp	x1, .LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	cmp	w1, w0
	bne	.L2441
.L2446:
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
	beq	.L2441
	ldr	x4, [x29, 152]
	mov	w0, w21
	ldr	w1, [x4, 4]
	bl	ftl_cmp_data_ver
	cbnz	w0, .L2441
	mov	w2, 1
	add	x1, x29, 200
	mov	w0, w24
	bl	log2phys
	b	.L2441
.L2448:
	mov	w1, w24
	adrp	x0, .LC67
	add	x0, x0, :lo12:.LC67
	bl	printf
	b	.L2426
.L2428:
	ldr	x1, [x29, 120]
	mov	w2, w21
	ldrh	w0, [x19]
	strh	w0, [x1]
	mov	w1, w5
	adrp	x0, .LC68
	add	x0, x0, :lo12:.LC68
	bl	printf
	adrp	x2, .LANCHOR239
	ldr	w0, [x2, #:lo12:.LANCHOR239]
	cmp	w0, 31
	bhi	.L2449
	adrp	x1, .LANCHOR240
	add	x1, x1, :lo12:.LANCHOR240
	ldr	w3, [x29, 204]
	str	w3, [x1, w0, uxtw 2]
	add	w0, w0, 1
	str	w0, [x2, #:lo12:.LANCHOR239]
.L2449:
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	ldr	w0, [x28, #:lo12:.LANCHOR136]
	cmn	w0, #1
	bne	.L2450
.L2542:
	str	w21, [x28, #:lo12:.LANCHOR136]
	b	.L2426
.L2450:
	cmp	w21, w0
	bcs	.L2426
	b	.L2542
.L2454:
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L2453
.L2427:
	strb	w27, [x19, 6]
	strh	w20, [x19, 2]
	b	.L2544
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
	.section	.text.FtlGcScanTempBlk,"ax",@progbits
	.align	2
	.global	FtlGcScanTempBlk
	.type	FtlGcScanTempBlk, %function
FtlGcScanTempBlk:
	stp	x29, x30, [sp, -176]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR241
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w20, [x23, #:lo12:.LANCHOR241]
	mov	w0, 65535
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	cmp	w20, w0
	stp	x27, x28, [sp, 80]
	beq	.L2571
	cbnz	w20, .L2547
.L2548:
	bl	FtlGcPageVarInit
	b	.L2549
.L2571:
	mov	w20, 0
.L2547:
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w1
	beq	.L2548
.L2549:
	adrp	x24, .LANCHOR72
	add	x24, x24, :lo12:.LANCHOR72
	mov	w26, -1
.L2550:
	ldrh	w1, [x19]
	mov	w0, 65535
	strb	wzr, [x19, 8]
	cmp	w1, w0
	beq	.L2551
	mov	w27, 56
.L2570:
	adrp	x1, .LANCHOR104
	adrp	x22, .LANCHOR180
	add	x3, x19, 16
	mov	w21, 0
	ldr	x5, [x1, #:lo12:.LANCHOR104]
	adrp	x1, .LANCHOR57
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	mov	w10, 65535
	ldrh	w6, [x1, #:lo12:.LANCHOR57]
	adrp	x1, .LANCHOR105
	ldr	x7, [x1, #:lo12:.LANCHOR105]
	adrp	x1, .LANCHOR58
	ldrh	w8, [x1, #:lo12:.LANCHOR58]
	adrp	x1, .LANCHOR38
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
.L2552:
	cmp	x3, x1
	bne	.L2554
	mov	w1, w21
	mov	w2, 0
	bl	FlashReadPages
	adrp	x25, .LANCHOR2
	umull	x0, w21, w27
	mov	x21, 0
	str	x0, [x29, 104]
	add	x0, x25, :lo12:.LANCHOR2
	str	x0, [x29, 96]
.L2555:
	ldr	x0, [x29, 104]
	cmp	x0, x21
	bne	.L2569
	adrp	x0, .LANCHOR52
	add	w20, w20, 1
	and	w20, w20, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w20
	bhi	.L2570
.L2551:
	strh	w20, [x19, 2]
	mov	w0, -1
	strb	wzr, [x19, 6]
	mov	w1, w20
	strh	w0, [x23, #:lo12:.LANCHOR241]
	mov	w2, 0
	mov	x0, x19
	bl	ftl_sb_update_avl_pages
	mov	w0, w26
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L2554:
	ldrh	w2, [x3]
	cmp	w2, w10
	beq	.L2553
	umaddl	x4, w21, w27, x0
	orr	w2, w20, w2, lsl 10
	str	w2, [x4, 4]
	mul	w2, w21, w6
	asr	w2, w2, 2
	add	x2, x5, x2, sxtw 2
	str	x2, [x4, 8]
	mul	w2, w21, w8
	add	w21, w21, 1
	and	w21, w21, 65535
	asr	w2, w2, 2
	add	x2, x7, x2, sxtw 2
	str	x2, [x4, 16]
.L2553:
	add	x3, x3, 2
	b	.L2552
.L2569:
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	add	x1, x0, x21
	ldr	w0, [x0, x21]
	ldr	w28, [x1, 4]
	ldr	x25, [x1, 16]
	cbnz	w0, .L2556
	ldrh	w1, [x25]
	mov	w0, 65535
	cmp	w1, w0
	beq	.L2585
	ldr	w1, [x24]
	ldr	w0, [x25, 8]
	cmp	w0, w1
	bls	.L2558
.L2585:
	adrp	x0, .LANCHOR83
	ldrh	w1, [x19]
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x19]
	bl	INSERT_FREE_LIST
	adrp	x1, .LANCHOR205
	mov	w0, -1
	strh	w0, [x19]
	strh	w0, [x1, #:lo12:.LANCHOR205]
.L2584:
	bl	FtlGcPageVarInit
	mov	w20, 0
	b	.L2550
.L2558:
	ldr	x1, [x29, 96]
	ldrb	w1, [x1]
	cbnz	w1, .L2560
.L2561:
	ldp	w2, w0, [x25, 8]
	mov	w1, w28
	add	x21, x21, 56
	bl	FtlGcUpdatePage
	b	.L2555
.L2560:
	add	x1, x29, 116
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x25, 12]
	ldr	w1, [x29, 116]
	cmp	w0, w1
	bne	.L2561
	cmn	w0, #1
	beq	.L2561
	str	w0, [x29, 124]
	adrp	x0, .LANCHOR187
	mov	w2, 0
	mov	w1, 1
	ldr	x0, [x0, #:lo12:.LANCHOR187]
	str	x0, [x29, 128]
	adrp	x0, .LANCHOR189
	ldr	x0, [x0, #:lo12:.LANCHOR189]
	str	x0, [x29, 136]
	add	x0, x29, 120
	bl	FlashReadPages
	adrp	x0, .LANCHOR55
	ldr	x2, [x22, #:lo12:.LANCHOR180]
	ldr	x5, [x29, 128]
	ldrh	w1, [x0, #:lo12:.LANCHOR55]
	add	x2, x2, x21
	mov	x0, 0
	ubfiz	x1, x1, 9, 16
.L2562:
	cmp	x0, x1
	beq	.L2561
	ldr	x6, [x2, 8]
	ldr	w7, [x6, x0]
	add	x0, x0, 4
	add	x6, x5, x0
	ldr	w6, [x6, -4]
	cmp	w7, w6
	beq	.L2562
	ldrh	w1, [x19]
	adrp	x0, .LC69
	ldr	w2, [x29, 124]
	add	x0, x0, :lo12:.LC69
	bl	printf
	b	.L2585
.L2556:
	ldrh	w1, [x19]
	mov	w2, w28
	adrp	x0, .LC70
	add	x0, x0, :lo12:.LC70
	bl	printf
	adrp	x0, .LANCHOR28
	ldr	w1, [x0, #:lo12:.LANCHOR28]
	ldrh	w0, [x19]
	cbnz	w1, .L2565
	adrp	x1, .LANCHOR15
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	cbz	w1, .L2566
.L2565:
	adrp	x2, .LANCHOR78
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR78]
	ldrh	w1, [x2, x1]
	cmp	w1, 159
	bls	.L2567
.L2566:
	ldr	x1, [x22, #:lo12:.LANCHOR180]
	ldr	w1, [x1, x21]
	cmn	w1, #1
	bne	.L2568
.L2567:
	ldr	x1, [x22, #:lo12:.LANCHOR180]
	add	x3, x1, x21
	ldr	w26, [x3, 4]
.L2568:
	adrp	x1, .LANCHOR83
	ubfiz	x0, x0, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR83]
	strh	wzr, [x1, x0]
	ldrh	w0, [x19]
	bl	INSERT_FREE_LIST
	mov	w0, -1
	strh	w0, [x19]
	b	.L2584
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
	.section	.text.FtlGcFreeTempBlock,"ax",@progbits
	.align	2
	.global	FtlGcFreeTempBlock
	.type	FtlGcFreeTempBlock, %function
FtlGcFreeTempBlock:
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbz	w0, .L2587
	mov	w0, 0
	ret
.L2587:
	stp	x29, x30, [sp, -112]!
	mov	w1, 65535
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR93
	stp	x21, x22, [sp, 32]
	add	x0, x19, :lo12:.LANCHOR93
	ldrh	w20, [x19, #:lo12:.LANCHOR93]
	adrp	x21, .LANCHOR135
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	cmp	w20, w1
	stp	x27, x28, [sp, 80]
	beq	.L2589
	adrp	x1, .LANCHOR52
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	bl	FtlGcScanTempBlk
	str	w0, [x29, 108]
	cmn	w0, #1
	beq	.L2589
	adrp	x0, .LANCHOR78
	ubfiz	x20, x20, 1, 16
	ldr	x1, [x0, #:lo12:.LANCHOR78]
	ldrh	w0, [x1, x20]
	cmp	w0, 4
	bls	.L2590
	sub	w0, w0, #5
	strh	w0, [x1, x20]
	mov	w0, 1
	bl	FtlEctTblFlush
.L2590:
	ldr	w0, [x21, #:lo12:.LANCHOR135]
	cbnz	w0, .L2591
	adrp	x0, .LANCHOR138
	add	x0, x0, :lo12:.LANCHOR138
	ldr	w1, [x0, 96]
	add	w1, w1, 1
	str	w1, [x0, 96]
	ldr	w0, [x29, 108]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L2591:
	str	wzr, [x21, #:lo12:.LANCHOR135]
	mov	w0, 1
.L2586:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2589:
	str	wzr, [x21, #:lo12:.LANCHOR135]
	mov	w0, 65535
	ldrh	w1, [x19, #:lo12:.LANCHOR93]
	add	x21, x19, :lo12:.LANCHOR93
	cmp	w1, w0
	beq	.L2613
	bl	FtlCacheWriteBack
	adrp	x20, .LANCHOR110
	adrp	x0, .LANCHOR52
	ldrb	w1, [x21, 7]
	ldrh	w2, [x20, #:lo12:.LANCHOR110]
	mov	x21, x0
	ldrh	w3, [x0, #:lo12:.LANCHOR52]
	mul	w1, w1, w3
	cmp	w2, w1
	beq	.L2593
	mov	w2, 163
	adrp	x1, .LANCHOR242
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR242
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2593:
	add	x0, x19, :lo12:.LANCHOR93
	adrp	x22, .LANCHOR83
	ldrh	w3, [x21, #:lo12:.LANCHOR52]
	adrp	x25, .LANCHOR72
	ldrh	w2, [x19, #:lo12:.LANCHOR93]
	add	x26, x20, :lo12:.LANCHOR110
	ldrb	w0, [x0, 7]
	add	x25, x25, :lo12:.LANCHOR72
	ldr	x1, [x22, #:lo12:.LANCHOR83]
	mov	w21, 0
	adrp	x27, .LANCHOR111
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	adrp	x1, .LANCHOR161
	ldrh	w0, [x20, #:lo12:.LANCHOR110]
	ldr	w2, [x1, #:lo12:.LANCHOR161]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR161]
.L2594:
	ldrh	w0, [x26]
	cmp	w0, w21
	bhi	.L2598
	mov	w0, -1
	bl	decrement_vpc_count
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L2599
	ldrh	w1, [x19, #:lo12:.LANCHOR93]
	adrp	x0, .LC71
	add	x0, x0, :lo12:.LC71
	bl	printf
.L2599:
	ldrh	w0, [x19, #:lo12:.LANCHOR93]
	ldr	x2, [x22, #:lo12:.LANCHOR83]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbz	w1, .L2600
	bl	INSERT_DATA_LIST
.L2601:
	adrp	x0, .LANCHOR108
	mov	w21, -1
	strh	wzr, [x20, #:lo12:.LANCHOR110]
	strh	w21, [x19, #:lo12:.LANCHOR93]
	strh	wzr, [x0, #:lo12:.LANCHOR108]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	adrp	x0, .LANCHOR205
	strh	w21, [x0, #:lo12:.LANCHOR205]
	adrp	x0, .LANCHOR88
	ldrh	w1, [x0, #:lo12:.LANCHOR88]
	adrp	x0, .LANCHOR224
	ldrh	w0, [x0, #:lo12:.LANCHOR224]
	add	w0, w0, w0, lsl 1
	cmp	w1, w0, lsr 2
	ble	.L2613
	adrp	x0, .LANCHOR176
	mov	w1, 20
	strh	w1, [x0, #:lo12:.LANCHOR176]
.L2613:
	mov	w0, 0
	b	.L2586
.L2598:
	mov	w24, 12
	ldr	x28, [x27, #:lo12:.LANCHOR111]
	ldr	w1, [x25]
	umull	x24, w21, w24
	add	x23, x28, x24
	ldr	w0, [x23, 8]
	cmp	w0, w1
	bcc	.L2595
.L2611:
	ldrh	w0, [x19, #:lo12:.LANCHOR93]
	b	.L2612
.L2595:
	add	x1, x29, 108
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x28, x24]
	ldr	w1, [x29, 108]
	cmp	w0, w1
	bne	.L2597
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	mov	w24, w0
	ldr	w0, [x23, 8]
	mov	w2, 1
	add	x1, x23, 4
	bl	log2phys
	mov	w0, w24
.L2612:
	bl	decrement_vpc_count
	b	.L2596
.L2597:
	ldr	w0, [x23, 4]
	cmp	w1, w0
	bne	.L2611
.L2596:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L2594
.L2600:
	bl	INSERT_FREE_LIST
	b	.L2601
	.size	FtlGcFreeTempBlock, .-FtlGcFreeTempBlock
	.section	.text.Ftl_get_new_temp_ppa,"ax",@progbits
	.align	2
	.global	Ftl_get_new_temp_ppa
	.type	Ftl_get_new_temp_ppa, %function
Ftl_get_new_temp_ppa:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR93
	mov	w2, 65535
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	x19, x0
	ldrh	w3, [x0, #:lo12:.LANCHOR93]
	cmp	w3, w2
	beq	.L2615
	add	x1, x0, :lo12:.LANCHOR93
	ldrh	w0, [x1, 4]
	cbnz	w0, .L2616
.L2615:
	bl	FtlCacheWriteBack
	mov	w0, 0
	bl	FtlGcFreeTempBlock
	add	x0, x19, :lo12:.LANCHOR93
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
.L2616:
	add	x0, x19, :lo12:.LANCHOR93
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	b	get_new_active_ppa
	.size	Ftl_get_new_temp_ppa, .-Ftl_get_new_temp_ppa
	.section	.text.Ftl_gc_temp_data_write_back,"ax",@progbits
	.align	2
	.global	Ftl_gc_temp_data_write_back
	.type	Ftl_gc_temp_data_write_back, %function
Ftl_gc_temp_data_write_back:
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbz	w0, .L2619
	mov	w0, 0
	ret
.L2622:
	mov	w0, 0
.L2618:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2619:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR15
	add	x29, sp, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR102
	cbz	w0, .L2621
	ldr	w0, [x19, #:lo12:.LANCHOR102]
	tbz	x0, 0, .L2621
	adrp	x0, .LANCHOR93+4
	ldrh	w0, [x0, #:lo12:.LANCHOR93+4]
	cbnz	w0, .L2622
.L2621:
	adrp	x20, .LANCHOR181
	ldr	w1, [x19, #:lo12:.LANCHOR102]
	mov	w3, 0
	mov	w2, 0
	ldr	x0, [x20, #:lo12:.LANCHOR181]
	add	x19, x19, :lo12:.LANCHOR102
	bl	FlashProgPages
	mov	w11, 0
	mov	w12, 56
.L2623:
	ldr	w1, [x19]
	cmp	w11, w1
	bcc	.L2625
	ldr	x0, [x20, #:lo12:.LANCHOR181]
	bl	FtlGcBufFree
	str	wzr, [x19]
	adrp	x0, .LANCHOR93+4
	ldrh	w0, [x0, #:lo12:.LANCHOR93+4]
	cbnz	w0, .L2622
	mov	w0, 1
	bl	FtlGcFreeTempBlock
	b	.L2635
.L2625:
	umull	x0, w11, w12
	ldr	x2, [x20, #:lo12:.LANCHOR181]
	add	x1, x2, x0
	ldr	w2, [x2, x0]
	ldr	x3, [x1, 16]
	cmn	w2, #1
	bne	.L2624
	adrp	x0, .LANCHOR93
	adrp	x3, .LANCHOR83
	ldrh	w4, [x0, #:lo12:.LANCHOR93]
	ldr	x3, [x3, #:lo12:.LANCHOR83]
	strh	wzr, [x3, x4, lsl 1]
	strh	w2, [x0, #:lo12:.LANCHOR93]
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
.L2635:
	mov	w0, 1
	b	.L2618
.L2624:
	ldr	w1, [x1, 4]
	ldp	w2, w0, [x3, 8]
	bl	FtlGcUpdatePage
	add	w11, w11, 1
	and	w11, w11, 65535
	b	.L2623
	.size	Ftl_gc_temp_data_write_back, .-Ftl_gc_temp_data_write_back
	.section	.text.FtlGcPageRecovery,"ax",@progbits
	.align	2
	.global	FtlGcPageRecovery
	.type	FtlGcPageRecovery, %function
FtlGcPageRecovery:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR52
	adrp	x19, .LANCHOR93
	add	x19, x19, :lo12:.LANCHOR93
	ldrh	w1, [x20, #:lo12:.LANCHOR52]
	mov	x0, x19
	bl	FtlGcScanTempBlk
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bcc	.L2636
	adrp	x0, .LANCHOR127
	add	x0, x0, :lo12:.LANCHOR127
	bl	FtlMapBlkWriteDumpData
	mov	w0, 0
	bl	FtlGcFreeTempBlock
	adrp	x0, .LANCHOR135
	str	wzr, [x0, #:lo12:.LANCHOR135]
.L2636:
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
	adrp	x0, .LANCHOR239
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR91
	add	x19, x19, :lo12:.LANCHOR91
	str	wzr, [x0, #:lo12:.LANCHOR239]
	mov	x0, x19
	bl	FtlRecoverySuperblock
	mov	x0, x19
	adrp	x19, .LANCHOR92
	bl	FtlSlcSuperblockCheck
	add	x19, x19, :lo12:.LANCHOR92
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
	adrp	x0, .LANCHOR237
	mov	w1, -1
	add	x29, sp, 0
	strh	w1, [x0, #:lo12:.LANCHOR237]
	adrp	x0, .LANCHOR39
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR238
	ldrh	w0, [x0, #:lo12:.LANCHOR39]
	strh	wzr, [x20, #:lo12:.LANCHOR238]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	adrp	x0, .LANCHOR210
	ldrh	w1, [x0, #:lo12:.LANCHOR210]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2642
.L2644:
	mov	w19, -1
.L2641:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2642:
	bl	FtlLoadSysInfo
	mov	w19, w0
	cbnz	w0, .L2644
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	mov	w0, 1
	bl	FtlUpdateVaildLpn
	adrp	x0, .LANCHOR67
	ldrh	w2, [x0, #:lo12:.LANCHOR67]
	adrp	x0, .LANCHOR96
	ldr	x1, [x0, #:lo12:.LANCHOR96]
	mov	w0, 0
	add	x1, x1, 4
.L2645:
	cmp	w0, w2
	bge	.L2650
	ldr	w3, [x1], 16
	tbz	w3, #31, .L2646
.L2650:
	adrp	x3, .LANCHOR160
	cmp	w0, w2
	ldr	w1, [x3, #:lo12:.LANCHOR160]
	add	w1, w1, 32
	str	w1, [x3, #:lo12:.LANCHOR160]
	bge	.L2652
.L2647:
	adrp	x0, .LANCHOR83
	adrp	x1, .LANCHOR91
	ldr	x2, [x0, #:lo12:.LANCHOR83]
	add	x0, x1, :lo12:.LANCHOR91
	ldrh	w1, [x1, #:lo12:.LANCHOR91]
	ldrh	w4, [x0, 4]
	lsl	x1, x1, 1
	ldrh	w3, [x2, x1]
	sub	w3, w3, w4
	adrp	x4, .LANCHOR52
	strh	w3, [x2, x1]
	strh	wzr, [x0, 4]
	ldrh	w1, [x4, #:lo12:.LANCHOR52]
	strh	w1, [x0, 2]
	adrp	x1, .LANCHOR92
	strb	wzr, [x0, 6]
	add	x0, x1, :lo12:.LANCHOR92
	ldrh	w1, [x1, #:lo12:.LANCHOR92]
	ldrh	w5, [x0, 4]
	lsl	x1, x1, 1
	ldrh	w3, [x2, x1]
	sub	w3, w3, w5
	strh	w3, [x2, x1]
	strb	wzr, [x0, 6]
	ldrh	w1, [x4, #:lo12:.LANCHOR52]
	strh	w1, [x0, 2]
	strh	wzr, [x0, 4]
	adrp	x0, .LANCHOR80
	add	x0, x0, :lo12:.LANCHOR80
	ldrh	w1, [x0, 30]
	add	w1, w1, 1
	strh	w1, [x0, 30]
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2654:
	bl	FtlVpcTblFlush
	b	.L2641
.L2646:
	add	w0, w0, 1
	b	.L2645
.L2652:
	ldrh	w0, [x20, #:lo12:.LANCHOR238]
	cbnz	w0, .L2647
	bl	l2p_flush
	b	.L2654
	.size	FtlSysBlkInit, .-FtlSysBlkInit
	.section	.text.FtlLowFormat,"ax",@progbits
	.align	2
	.global	FtlLowFormat
	.type	FtlLowFormat, %function
FtlLowFormat:
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbnz	w0, .L2687
	stp	x29, x30, [sp, -80]!
	adrp	x0, .LANCHOR195
	mov	w1, 0
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR66
	ldr	x0, [x0, #:lo12:.LANCHOR195]
	adrp	x20, .LANCHOR159
	ldrh	w2, [x19, #:lo12:.LANCHOR66]
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR39
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	lsl	w2, w2, 2
	bl	ftl_memset
	adrp	x0, .LANCHOR131
	ldrh	w2, [x19, #:lo12:.LANCHOR66]
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
	cbz	w0, .L2658
	bl	FtlMakeBbt
.L2658:
	adrp	x22, .LANCHOR55
	adrp	x0, .LANCHOR186
	mov	w6, 23752
	ldrh	w1, [x22, #:lo12:.LANCHOR55]
	movk	w6, 0xa0f, lsl 16
	ldr	x4, [x0, #:lo12:.LANCHOR186]
	adrp	x0, .LANCHOR187
	lsl	w1, w1, 7
	ldr	x5, [x0, #:lo12:.LANCHOR187]
	mov	w0, 0
.L2659:
	cmp	w0, w1
	blt	.L2660
	adrp	x21, .LANCHOR40
	adrp	x19, .LANCHOR41
	add	x26, x19, :lo12:.LANCHOR41
	mov	w23, 0
	ldrh	w24, [x21, #:lo12:.LANCHOR40]
.L2661:
	ldrh	w0, [x26]
	cmp	w0, w24
	bhi	.L2662
	adrp	x24, .LANCHOR38
	sub	w1, w23, #2
	ldrh	w0, [x24, #:lo12:.LANCHOR38]
	cmp	w1, w0, lsl 1
	bgt	.L2663
.L2667:
	add	x26, x21, :lo12:.LANCHOR40
	mov	w23, 0
	mov	w25, 0
.L2664:
	ldrh	w0, [x26]
	cmp	w0, w25
	bhi	.L2668
	adrp	x0, .LANCHOR73
	ldrh	w1, [x19, #:lo12:.LANCHOR41]
	ldrh	w3, [x24, #:lo12:.LANCHOR38]
	str	w1, [x0, #:lo12:.LANCHOR73]
	adrp	x0, .LANCHOR42
	adrp	x1, .LANCHOR224
	ldr	w2, [x0, #:lo12:.LANCHOR42]
	adrp	x0, .LANCHOR72
	udiv	w6, w2, w3
	ubfx	x5, x6, 5, 16
	str	w6, [x0, #:lo12:.LANCHOR72]
	add	w4, w5, 36
	strh	w4, [x1, #:lo12:.LANCHOR224]
	mov	w4, 24
	mul	w4, w3, w4
	cmp	w23, w4
	ble	.L2669
	sub	w2, w2, w23
	udiv	w2, w2, w3
	str	w2, [x0, #:lo12:.LANCHOR72]
	lsr	w2, w2, 5
	add	w2, w2, 24
	strh	w2, [x1, #:lo12:.LANCHOR224]
.L2669:
	adrp	x2, .LANCHOR28
	ldr	w2, [x2, #:lo12:.LANCHOR28]
	cmp	w2, 1
	bne	.L2670
	udiv	w4, w23, w3
	ldrh	w2, [x1, #:lo12:.LANCHOR224]
	add	w4, w4, w2
	add	w4, w2, w4, asr 2
	strh	w4, [x1, #:lo12:.LANCHOR224]
.L2670:
	adrp	x2, .LANCHOR15
	ldrb	w2, [x2, #:lo12:.LANCHOR15]
	cbz	w2, .L2671
	udiv	w4, w23, w3
	ldrh	w2, [x1, #:lo12:.LANCHOR224]
	add	w4, w4, w2
	add	w4, w2, w4, asr 2
	strh	w4, [x1, #:lo12:.LANCHOR224]
.L2671:
	adrp	x2, .LANCHOR49
	ldrh	w2, [x2, #:lo12:.LANCHOR49]
	cbz	w2, .L2673
	ldrh	w4, [x1, #:lo12:.LANCHOR224]
	add	w4, w4, w2, lsr 1
	strh	w4, [x1, #:lo12:.LANCHOR224]
	mul	w4, w2, w3
	cmp	w23, w4
	bge	.L2673
	add	w2, w2, 32
	str	w6, [x0, #:lo12:.LANCHOR72]
	add	w2, w5, w2
	strh	w2, [x1, #:lo12:.LANCHOR224]
.L2673:
	ldrh	w2, [x1, #:lo12:.LANCHOR224]
	adrp	x25, .LANCHOR223
	ldr	w1, [x0, #:lo12:.LANCHOR72]
	adrp	x24, .LANCHOR83
	mov	w23, -1
	sub	w1, w1, w2
	mul	w3, w1, w3
	adrp	x1, .LANCHOR52
	str	w3, [x25, #:lo12:.LANCHOR223]
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	mul	w3, w1, w3
	str	w3, [x0, #:lo12:.LANCHOR72]
	ldrh	w0, [x22, #:lo12:.LANCHOR55]
	mul	w3, w0, w3
	adrp	x0, .LANCHOR68
	str	w3, [x0, #:lo12:.LANCHOR68]
	bl	FtlBbmTblFlush
	ldr	x0, [x24, #:lo12:.LANCHOR83]
	mov	w1, 0
	ldrh	w2, [x19, #:lo12:.LANCHOR41]
	lsl	w2, w2, 1
	bl	ftl_memset
	adrp	x0, .LANCHOR100
	adrp	x1, .LANCHOR205
	ldrh	w2, [x21, #:lo12:.LANCHOR40]
	str	wzr, [x0, #:lo12:.LANCHOR100]
	add	x0, x1, :lo12:.LANCHOR205
	strh	w23, [x1, #:lo12:.LANCHOR205]
	mov	w1, 255
	lsr	w2, w2, 3
	strh	wzr, [x0, 2]
	strb	wzr, [x0, 6]
	strb	wzr, [x0, 8]
	adrp	x0, .LANCHOR91
	add	x19, x0, :lo12:.LANCHOR91
	strh	wzr, [x0, #:lo12:.LANCHOR91]
	mov	w0, 1
	strb	w0, [x19, 8]
	adrp	x0, .LANCHOR1
	strh	wzr, [x19, 2]
	ldr	x0, [x0, #:lo12:.LANCHOR1]
	strb	wzr, [x19, 6]
	bl	ftl_memset
.L2675:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L2676
	ldr	x1, [x24, #:lo12:.LANCHOR83]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L2675
.L2660:
	ubfiz	x3, x0, 2, 16
	mvn	w2, w0
	orr	w2, w0, w2, lsl 16
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w2, [x4, x3]
	str	w6, [x5, x3]
	b	.L2659
.L2662:
	mov	w0, w24
	mov	w1, 1
	add	w24, w24, 1
	bl	FtlLowFormatEraseBlock
	add	w23, w23, w0
	and	w24, w24, 65535
	and	w23, w23, 65535
	b	.L2661
.L2663:
	udiv	w0, w23, w0
	adrp	x1, .LANCHOR65
	ldr	w23, [x1, #:lo12:.LANCHOR65]
	add	w0, w0, w23
	bl	FtlSysBlkNumInit
	ldrh	w0, [x25, #:lo12:.LANCHOR39]
	add	x25, x19, :lo12:.LANCHOR41
	bl	FtlFreeSysBlkQueueInit
	ldrh	w23, [x21, #:lo12:.LANCHOR40]
.L2665:
	ldrh	w0, [x25]
	cmp	w0, w23
	bls	.L2667
	mov	w0, w23
	add	w23, w23, 1
	mov	w1, 1
	and	w23, w23, 65535
	bl	FtlLowFormatEraseBlock
	b	.L2665
.L2668:
	mov	w0, w25
	mov	w1, 0
	add	w25, w25, 1
	bl	FtlLowFormatEraseBlock
	add	w23, w23, w0
	and	w25, w25, 65535
	and	w23, w23, 65535
	b	.L2664
.L2676:
	ldr	w1, [x20, #:lo12:.LANCHOR159]
	ubfiz	x0, x0, 1, 16
	str	w1, [x19, 12]
	mov	w23, -1
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR159]
	ldr	x1, [x24, #:lo12:.LANCHOR83]
	ldrh	w2, [x19, 4]
	strh	w2, [x1, x0]
	adrp	x2, .LANCHOR92
	add	x0, x2, :lo12:.LANCHOR92
	ldrh	w1, [x19]
	mov	x19, x0
	add	w1, w1, 1
	strh	wzr, [x0, 2]
	strh	w1, [x2, #:lo12:.LANCHOR92]
	mov	w1, 1
	strb	wzr, [x0, 6]
	strb	w1, [x0, 8]
.L2677:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L2678
	ldr	x1, [x24, #:lo12:.LANCHOR83]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L2677
.L2678:
	ldr	w1, [x20, #:lo12:.LANCHOR159]
	ubfiz	x0, x0, 1, 16
	str	w1, [x19, 12]
	add	w1, w1, 1
	str	w1, [x20, #:lo12:.LANCHOR159]
	ldr	x1, [x24, #:lo12:.LANCHOR83]
	ldrh	w2, [x19, 4]
	mov	w19, -1
	strh	w2, [x1, x0]
	adrp	x0, .LANCHOR93
	strh	w19, [x0, #:lo12:.LANCHOR93]
	bl	FtlFreeSysBlkQueueOut
	adrp	x2, .LANCHOR210
	add	x1, x2, :lo12:.LANCHOR210
	strh	w0, [x2, #:lo12:.LANCHOR210]
	ldr	w0, [x25, #:lo12:.LANCHOR223]
	strh	w0, [x1, 6]
	ldr	w0, [x20, #:lo12:.LANCHOR159]
	str	w0, [x1, 8]
	add	w0, w0, 1
	strh	wzr, [x1, 2]
	strh	w19, [x1, 4]
	str	w0, [x20, #:lo12:.LANCHOR159]
	bl	FtlVpcTblFlush
	bl	FtlSysBlkInit
	cbnz	w0, .L2657
	adrp	x0, .LANCHOR232
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR232]
.L2657:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2687:
	mov	w0, 0
	ret
	.size	FtlLowFormat, .-FtlLowFormat
	.section	.text.rk_ftl_garbage_collect,"ax",@progbits
	.align	2
	.global	rk_ftl_garbage_collect
	.type	rk_ftl_garbage_collect, %function
rk_ftl_garbage_collect:
	adrp	x1, .LANCHOR76
	ldr	w1, [x1, #:lo12:.LANCHOR76]
	cbnz	w1, .L2749
	stp	x29, x30, [sp, -176]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR171
	stp	x19, x20, [sp, 16]
	ldr	w1, [x21, #:lo12:.LANCHOR171]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w1, .L2751
	adrp	x1, .LANCHOR85
	ldrh	w1, [x1, #:lo12:.LANCHOR85]
	cmp	w1, 47
	bls	.L2751
	adrp	x5, .LANCHOR113
	mov	w2, 65535
	ldrh	w8, [x5, #:lo12:.LANCHOR113]
	cmp	w8, w2
	beq	.L2692
	adrp	x7, .LANCHOR112
	ldrh	w1, [x7, #:lo12:.LANCHOR112]
	cmp	w1, w2
	bne	.L2692
	adrp	x3, .LANCHOR114
	ldrh	w6, [x3, #:lo12:.LANCHOR114]
	cmp	w6, w1
	beq	.L2692
	adrp	x2, .LANCHOR115
	ldrh	w4, [x2, #:lo12:.LANCHOR115]
	cmp	w4, w1
	beq	.L2692
	mov	w1, -1
	strh	w8, [x7, #:lo12:.LANCHOR112]
	strh	w6, [x5, #:lo12:.LANCHOR113]
	strh	w4, [x3, #:lo12:.LANCHOR114]
	strh	w1, [x2, #:lo12:.LANCHOR115]
.L2692:
	cbnz	w0, .L2752
	adrp	x0, .LANCHOR88
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w0, 24
	bhi	.L2753
	adrp	x1, .LANCHOR52
	cmp	w0, 16
	ldrh	w20, [x1, #:lo12:.LANCHOR52]
	bls	.L2695
	lsr	w20, w20, 5
.L2694:
	adrp	x2, .LANCHOR176
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR176]
	cmp	w1, w0
	bcs	.L2698
	adrp	x0, .LANCHOR93
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w0, w1
	bne	.L2699
	adrp	x1, .LANCHOR112
	ldrh	w1, [x1, #:lo12:.LANCHOR112]
	cmp	w1, w0
	bne	.L2699
	adrp	x0, .LANCHOR243
	ldrh	w0, [x0, #:lo12:.LANCHOR243]
	cbnz	w0, .L2700
	adrp	x1, .LANCHOR72
	adrp	x4, .LANCHOR100
	ldr	w1, [x1, #:lo12:.LANCHOR72]
	ldr	w4, [x4, #:lo12:.LANCHOR100]
	add	w1, w1, w1, lsl 1
	cmp	w4, w1, lsr 2
	bcs	.L2701
.L2700:
	adrp	x1, .LANCHOR224
	ldrh	w1, [x1, #:lo12:.LANCHOR224]
	add	w1, w1, w1, lsl 1
	asr	w1, w1, 2
	strh	w1, [x3, #:lo12:.LANCHOR176]
.L2702:
	adrp	x1, .LANCHOR172
	str	wzr, [x1, #:lo12:.LANCHOR172]
.L2690:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L2695:
	cmp	w0, 12
	bls	.L2696
	lsr	w20, w20, 4
	b	.L2694
.L2696:
	cmp	w0, 8
	bls	.L2694
	lsr	w20, w20, 2
	b	.L2694
.L2753:
	mov	w20, 1
	b	.L2694
.L2701:
	mov	w1, 18
	strh	w1, [x2, #:lo12:.LANCHOR176]
	b	.L2702
.L2699:
	adrp	x0, .LANCHOR224
	ldrh	w0, [x0, #:lo12:.LANCHOR224]
	add	w0, w0, w0, lsl 1
	asr	w0, w0, 2
	strh	w0, [x3, #:lo12:.LANCHOR176]
.L2698:
	adrp	x0, .LANCHOR116
	ldrh	w0, [x0, #:lo12:.LANCHOR116]
	cbz	w0, .L2693
	add	w20, w20, 32
	and	w20, w20, 65535
.L2693:
	adrp	x19, .LANCHOR205
	mov	w0, 65535
	ldrh	w2, [x19, #:lo12:.LANCHOR205]
	cmp	w2, w0
	bne	.L2705
	adrp	x0, .LANCHOR112
	ldrh	w1, [x0, #:lo12:.LANCHOR112]
	cmp	w1, w2
	beq	.L2706
	adrp	x2, .LANCHOR83
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR83]
	ldrh	w1, [x2, x1]
	cbnz	w1, .L2707
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR112]
.L2707:
	ldrh	w1, [x0, #:lo12:.LANCHOR112]
	strh	w1, [x19, #:lo12:.LANCHOR205]
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR112]
.L2706:
	add	x0, x19, :lo12:.LANCHOR205
	mov	w1, 65535
	strb	wzr, [x0, 8]
	ldrh	w0, [x19, #:lo12:.LANCHOR205]
	cmp	w0, w1
	beq	.L2705
	bl	IsBlkInGcList
	cbz	w0, .L2709
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR205]
.L2709:
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L2710
	ldrh	w0, [x19, #:lo12:.LANCHOR205]
	add	x3, x19, :lo12:.LANCHOR205
	bl	ftl_get_blk_mode
	strb	w0, [x3, 8]
.L2710:
	ldrh	w1, [x19, #:lo12:.LANCHOR205]
	mov	w0, 65535
	add	x22, x19, :lo12:.LANCHOR205
	cmp	w1, w0
	beq	.L2705
	mov	x0, x22
	bl	make_superblock
	adrp	x0, .LANCHOR244
	ldrh	w1, [x19, #:lo12:.LANCHOR205]
	strh	wzr, [x22, 2]
	strh	wzr, [x0, #:lo12:.LANCHOR244]
	adrp	x0, .LANCHOR83
	strb	wzr, [x22, 6]
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR245
	strh	w1, [x0, #:lo12:.LANCHOR245]
.L2705:
	adrp	x1, .LANCHOR91
	ldrh	w0, [x19, #:lo12:.LANCHOR205]
	str	x1, [x29, 128]
	ldrh	w2, [x1, #:lo12:.LANCHOR91]
	cmp	w2, w0
	beq	.L2711
	adrp	x1, .LANCHOR92
	ldrh	w1, [x1, #:lo12:.LANCHOR92]
	cmp	w1, w0
	beq	.L2711
	adrp	x1, .LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	cmp	w1, w0
	bne	.L2712
.L2711:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR205]
.L2712:
	adrp	x25, .LANCHOR178
	add	x26, x25, :lo12:.LANCHOR178
.L2748:
	ldrh	w1, [x19, #:lo12:.LANCHOR205]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2713
	adrp	x0, .LANCHOR172
	adrp	x22, .LANCHOR52
	add	x22, x22, :lo12:.LANCHOR52
	str	wzr, [x0, #:lo12:.LANCHOR172]
.L2714:
	ldrh	w5, [x25, #:lo12:.LANCHOR178]
	add	x7, x25, :lo12:.LANCHOR178
	mov	w0, w5
	bl	List_get_gc_head_node
	and	w6, w0, 65535
	strh	w6, [x19, #:lo12:.LANCHOR205]
	mov	w0, 65535
	cmp	w6, w0
	bne	.L2715
	strh	wzr, [x7]
	mov	w0, 8
	b	.L2690
.L2752:
	mov	w20, 1
	b	.L2693
.L2715:
	mov	w0, w6
	bl	IsBlkInGcList
	add	w5, w5, 1
	cbz	w0, .L2716
	strh	w5, [x25, #:lo12:.LANCHOR178]
	b	.L2714
.L2716:
	adrp	x23, .LANCHOR83
	adrp	x4, .LANCHOR38
	ldrh	w0, [x22]
	ubfiz	x1, x6, 1, 16
	ldr	x2, [x23, #:lo12:.LANCHOR83]
	and	w5, w5, 65535
	ldrh	w4, [x4, #:lo12:.LANCHOR38]
	strh	w5, [x25, #:lo12:.LANCHOR178]
	ldrh	w3, [x2, x1]
	mul	w0, w0, w4
	cmp	w3, w0, asr 1
	bgt	.L2718
	cmp	w5, 48
	bls	.L2719
	cmp	w3, 8
	bls	.L2719
	adrp	x3, .LANCHOR108
	ldrh	w3, [x3, #:lo12:.LANCHOR108]
	cmp	w3, 35
	bhi	.L2719
.L2718:
	strh	wzr, [x26]
.L2719:
	ldrh	w1, [x2, x1]
	cmp	w0, w1
	bgt	.L2720
	ldrh	w0, [x26]
	cmp	w0, 3
	bhi	.L2720
	mov	w0, -1
	strh	wzr, [x26]
	strh	w0, [x19, #:lo12:.LANCHOR205]
.L2791:
	adrp	x0, .LANCHOR243
	ldrh	w0, [x0, #:lo12:.LANCHOR243]
	b	.L2690
.L2720:
	cbnz	w1, .L2721
	mov	w0, -1
	bl	decrement_vpc_count
	ldrh	w0, [x26]
	add	w0, w0, 1
	strh	w0, [x26]
	b	.L2714
.L2721:
	adrp	x0, .LANCHOR15
	add	x3, x19, :lo12:.LANCHOR205
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	strb	wzr, [x3, 8]
	cbz	w0, .L2722
	mov	w0, w6
	bl	ftl_get_blk_mode
	strb	w0, [x3, 8]
.L2722:
	ldr	x0, [x29, 128]
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w0, w6
	bne	.L2723
	mov	w2, 902
	adrp	x1, .LANCHOR246
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR246
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2723:
	adrp	x0, .LANCHOR92
	ldrh	w1, [x19, #:lo12:.LANCHOR205]
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w1, w0
	bne	.L2724
	mov	w2, 903
	adrp	x1, .LANCHOR246
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR246
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2724:
	adrp	x0, .LANCHOR93
	ldrh	w1, [x19, #:lo12:.LANCHOR205]
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w1, w0
	bne	.L2725
	mov	w2, 904
	adrp	x1, .LANCHOR246
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR246
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2725:
	add	x22, x19, :lo12:.LANCHOR205
	mov	x0, x22
	bl	make_superblock
	adrp	x0, .LANCHOR244
	ldrh	w1, [x19, #:lo12:.LANCHOR205]
	strh	wzr, [x0, #:lo12:.LANCHOR244]
	ldr	x0, [x23, #:lo12:.LANCHOR83]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR245
	strh	wzr, [x22, 2]
	strh	w1, [x0, #:lo12:.LANCHOR245]
	strb	wzr, [x22, 6]
.L2713:
	adrp	x1, .LANCHOR52
	mov	w0, 1
	str	w0, [x21, #:lo12:.LANCHOR171]
	ldrh	w0, [x1, #:lo12:.LANCHOR52]
	str	w0, [x29, 156]
	adrp	x0, .LANCHOR15
	str	x1, [x29, 120]
	str	x0, [x29, 112]
	ldrb	w2, [x0, #:lo12:.LANCHOR15]
	cbz	w2, .L2726
	add	x0, x19, :lo12:.LANCHOR205
	ldrb	w0, [x0, 8]
	cmp	w0, 1
	bne	.L2726
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	str	w0, [x29, 156]
.L2726:
	add	x0, x19, :lo12:.LANCHOR205
	ldr	w2, [x29, 156]
	ldrh	w0, [x0, 2]
	add	w1, w0, w20
	cmp	w1, w2
	ble	.L2727
	sub	w20, w2, w0
	and	w20, w20, 65535
.L2727:
	adrp	x0, .LANCHOR244
	mov	w28, 0
	add	x0, x0, :lo12:.LANCHOR244
	str	x0, [x29, 144]
.L2728:
	cmp	w20, w28, uxth
	bls	.L2736
	add	x1, x19, :lo12:.LANCHOR205
	adrp	x0, .LANCHOR38
	adrp	x23, .LANCHOR106
	add	x1, x1, 16
	ldrh	w7, [x0, #:lo12:.LANCHOR38]
	mov	w22, 0
	ldrh	w4, [x1, -14]
	mov	w2, 0
	ldr	x0, [x23, #:lo12:.LANCHOR106]
	mov	w6, 65535
	add	w4, w4, w28
	mov	w5, 56
	b	.L2737
.L2730:
	ldrh	w3, [x1]
	cmp	w3, w6
	beq	.L2729
	umaddl	x8, w22, w5, x0
	add	w22, w22, 1
	and	w22, w22, 65535
	orr	w3, w4, w3, lsl 10
	str	w3, [x8, 4]
.L2729:
	add	w2, w2, 1
	add	x1, x1, 2
	and	w2, w2, 65535
.L2737:
	cmp	w2, w7
	bne	.L2730
	add	x1, x19, :lo12:.LANCHOR205
	adrp	x24, .LANCHOR102
	add	x24, x24, :lo12:.LANCHOR102
	ldrb	w2, [x1, 8]
	mov	w1, w22
	bl	FlashReadPages
	mov	w0, 56
	umull	x0, w22, w0
	mov	x22, 0
	str	x0, [x29, 136]
.L2731:
	ldr	x0, [x29, 136]
	cmp	x0, x22
	bne	.L2735
	add	w28, w28, 1
	b	.L2728
.L2735:
	ldr	x0, [x23, #:lo12:.LANCHOR106]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	cmn	w0, #1
	beq	.L2732
	ldr	x27, [x1, 16]
	mov	w0, 61589
	ldrh	w1, [x27]
	cmp	w1, w0
	bne	.L2732
	ldr	w4, [x27, 8]
	cmn	w4, #1
	bne	.L2733
	mov	w2, 943
	str	w4, [x29, 104]
	adrp	x1, .LANCHOR246
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR246
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
	ldr	w4, [x29, 104]
.L2733:
	mov	w2, 0
	add	x1, x29, 168
	mov	w0, w4
	bl	log2phys
	ldr	x0, [x23, #:lo12:.LANCHOR106]
	ldr	w1, [x29, 168]
	add	x0, x0, x22
	and	w1, w1, 2147483647
	ldr	w2, [x0, 4]
	cmp	w1, w2
	bne	.L2732
	ldr	x1, [x29, 144]
	adrp	x4, .LANCHOR181
	ldr	x2, [x29, 144]
	ldr	x5, [x4, #:lo12:.LANCHOR181]
	ldr	w0, [x0, 24]
	ldrh	w1, [x1]
	add	w1, w1, 1
	strh	w1, [x2]
	ldr	w2, [x24]
	mov	w1, 56
	str	w1, [x29, 152]
	nop // between mem op and mult-accumulate
	umaddl	x2, w2, w1, x5
	stp	x4, x2, [x29, 96]
	str	w0, [x2, 24]
	bl	Ftl_get_new_temp_ppa
	ldp	x4, x2, [x29, 96]
	ldr	w1, [x29, 152]
	str	w0, [x2, 4]
	ldr	x0, [x4, #:lo12:.LANCHOR181]
	ldr	w2, [x24]
	umaddl	x1, w2, w1, x0
	ldr	x0, [x23, #:lo12:.LANCHOR106]
	add	w2, w2, 1
	add	x0, x0, x22
	ldr	x4, [x0, 8]
	str	x4, [x1, 8]
	ldr	x4, [x0, 16]
	str	x4, [x1, 16]
	ldr	w1, [x29, 168]
	str	w1, [x27, 12]
	adrp	x1, .LANCHOR93
	add	x12, x1, :lo12:.LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	strh	w1, [x27, 2]
	adrp	x1, .LANCHOR160
	str	w2, [x24]
	ldr	w1, [x1, #:lo12:.LANCHOR160]
	str	w1, [x27, 4]
	mov	w1, 1
	bl	FtlGcBufAlloc
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbnz	w0, .L2734
	ldrb	w1, [x12, 7]
	ldr	w0, [x24]
	cmp	w1, w0
	beq	.L2734
	ldrh	w0, [x12, 4]
	cbnz	w0, .L2732
.L2734:
	bl	Ftl_gc_temp_data_write_back
	cbz	w0, .L2732
	add	x0, x19, :lo12:.LANCHOR205
	mov	w1, -1
	str	wzr, [x21, #:lo12:.LANCHOR171]
	strh	w1, [x19, #:lo12:.LANCHOR205]
	strh	wzr, [x0, 2]
	b	.L2791
.L2732:
	add	x22, x22, 56
	b	.L2731
.L2736:
	add	x1, x19, :lo12:.LANCHOR205
	ldrh	w0, [x1, 2]
	add	w20, w20, w0
	ldr	w0, [x29, 156]
	and	w20, w20, 65535
	strh	w20, [x1, 2]
	cmp	w0, w20
	bhi	.L2738
	adrp	x0, .LANCHOR102
	ldr	w0, [x0, #:lo12:.LANCHOR102]
	cbz	w0, .L2739
	bl	Ftl_gc_temp_data_write_back
	cbz	w0, .L2739
	str	wzr, [x21, #:lo12:.LANCHOR171]
	b	.L2791
.L2739:
	adrp	x0, .LANCHOR244
	ldrh	w0, [x0, #:lo12:.LANCHOR244]
	cbnz	w0, .L2740
	adrp	x22, .LANCHOR83
	ldrh	w1, [x19, #:lo12:.LANCHOR205]
	ldr	x0, [x22, #:lo12:.LANCHOR83]
	ldrh	w0, [x0, x1, lsl 1]
	cbz	w0, .L2740
	adrp	x23, .LANCHOR72
	add	x24, x23, :lo12:.LANCHOR72
	mov	w20, 0
.L2741:
	ldr	w0, [x24]
	cmp	w20, w0
	bcs	.L2746
	mov	w2, 0
	add	x1, x29, 172
	mov	w0, w20
	bl	log2phys
	ldr	w0, [x29, 172]
	cmn	w0, #1
	beq	.L2742
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	ldrh	w1, [x19, #:lo12:.LANCHOR205]
	cmp	w1, w0, uxth
	bne	.L2742
.L2746:
	ldr	w0, [x23, #:lo12:.LANCHOR72]
	cmp	w20, w0
	bcc	.L2740
	ldrh	w1, [x19, #:lo12:.LANCHOR205]
	ldr	x0, [x22, #:lo12:.LANCHOR83]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x19, #:lo12:.LANCHOR205]
	bl	update_vpc_list
	bl	FtlCacheWriteBack
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2740:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR205]
.L2738:
	adrp	x0, .LANCHOR88
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w0, 2
	bhi	.L2747
	ldr	x0, [x29, 120]
	ldrh	w20, [x0, #:lo12:.LANCHOR52]
	b	.L2748
.L2742:
	add	w20, w20, 1
	b	.L2741
.L2747:
	str	wzr, [x21, #:lo12:.LANCHOR171]
	add	w0, w0, 1
	b	.L2690
.L2749:
	mov	w0, 0
	ret
.L2751:
	mov	w0, 0
	b	.L2690
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
	.section	.text.FtlInit,"ax",@progbits
	.align	2
	.global	FtlInit
	.type	FtlInit, %function
FtlInit:
	stp	x29, x30, [sp, -64]!
	adrp	x1, .LC72
	add	x1, x1, :lo12:.LC72
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR232
	mov	x20, x0
	mov	w0, -1
	str	w0, [x19, #:lo12:.LANCHOR232]
	adrp	x0, .LANCHOR247
	stp	x21, x22, [sp, 32]
	str	wzr, [x0, #:lo12:.LANCHOR247]
	adrp	x0, .LANCHOR76
	stp	x23, x24, [sp, 48]
	str	wzr, [x0, #:lo12:.LANCHOR76]
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
	cbz	w0, .L2793
	adrp	x1, .LANCHOR248
	adrp	x0, .LC73
	add	x1, x1, :lo12:.LANCHOR248
	add	x0, x0, :lo12:.LC73
.L2802:
	bl	printf
.L2794:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L2793:
	bl	FtlSysBlkInit
	cbz	w0, .L2795
	adrp	x1, .LANCHOR248
	adrp	x0, .LC74
	add	x1, x1, :lo12:.LANCHOR248
	add	x0, x0, :lo12:.LC74
	b	.L2802
.L2795:
	mov	w1, 1
	str	w1, [x19, #:lo12:.LANCHOR232]
	bl	rk_ftl_garbage_collect
	adrp	x0, .LANCHOR88
	mov	x22, x0
	ldrh	w23, [x0, #:lo12:.LANCHOR88]
	cmp	w23, 15
	bhi	.L2794
	adrp	x20, .LANCHOR112
	add	x20, x20, :lo12:.LANCHOR112
	mov	w19, 0
	adrp	x24, .LANCHOR205
	mov	w21, 65535
.L2799:
	ldrh	w0, [x24, #:lo12:.LANCHOR205]
	cmp	w0, w21
	bne	.L2797
	ldrh	w0, [x20]
	cmp	w0, w21
	bne	.L2797
	and	w0, w19, 7
	bl	List_get_gc_head_node
	bl	FtlGcRefreshBlock
.L2797:
	mov	w1, 1
	mov	w0, w1
	bl	rk_ftl_garbage_collect
	ldrh	w1, [x22, #:lo12:.LANCHOR88]
	add	w0, w23, 2
	cmp	w1, w0
	bhi	.L2794
	add	w19, w19, 1
	cmp	w19, 1024
	bne	.L2799
	b	.L2794
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
	cbnz	w0, .L2804
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	bl	FtlInit
.L2804:
	bl	idb_init
	mov	w1, w19
	adrp	x0, .LC75
	add	x0, x0, :lo12:.LC75
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
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L2821
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	str	x25, [sp, 64]
	adrp	x25, .LANCHOR237
	stp	x23, x24, [sp, 48]
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR83
	ldrh	w23, [x25, #:lo12:.LANCHOR237]
	ldr	x0, [x21, #:lo12:.LANCHOR83]
	mov	w1, w23
	stp	x19, x20, [sp, 16]
	ubfiz	x24, x23, 1, 16
	adrp	x19, .LC76
	ldrh	w2, [x0, x24]
	add	x0, x19, :lo12:.LC76
	bl	printf
	adrp	x0, .LANCHOR91
	add	x11, x0, :lo12:.LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	bl	FtlGcRefreshOpenBlock
	adrp	x0, .LANCHOR92
	add	x20, x0, :lo12:.LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	bl	FtlGcRefreshOpenBlock
	mov	x0, x11
	bl	allocate_new_data_superblock
	mov	x0, x20
	mov	w20, 4097
	bl	allocate_new_data_superblock
.L2808:
	subs	w20, w20, #1
	beq	.L2812
	mov	w1, 1
	mov	w0, w1
	bl	rk_ftl_garbage_collect
	ldr	x0, [x21, #:lo12:.LANCHOR83]
	ldrh	w0, [x0, x24]
	cbnz	w0, .L2808
.L2812:
	ldr	x0, [x21, #:lo12:.LANCHOR83]
	mov	w1, w23
	ldrh	w2, [x0, x24]
	add	x0, x19, :lo12:.LC76
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR83]
	ldrh	w19, [x0, x24]
	cbnz	w19, .L2810
	add	x20, x29, 128
	adrp	x22, .LANCHOR77
	strh	w23, [x20, -48]!
	mov	x0, x20
	bl	make_superblock
	adrp	x0, .LANCHOR38
	ldr	x4, [x22, #:lo12:.LANCHOR77]
	add	x20, x20, 16
	mov	w5, 65535
	ldrh	w3, [x0, #:lo12:.LANCHOR38]
	mov	w6, 56
	mov	w0, 0
.L2813:
	cmp	w0, w3
	bne	.L2815
	ldr	x0, [x21, #:lo12:.LANCHOR83]
	mov	w1, w23
	ldrh	w2, [x0, x24]
	adrp	x0, .LC77
	add	x0, x0, :lo12:.LC77
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR77]
	mov	w2, w19
	mov	w1, 0
	bl	FlashEraseBlocks
	ldr	x0, [x22, #:lo12:.LANCHOR77]
	mov	w2, w19
	mov	w1, 1
	bl	FlashEraseBlocks
.L2810:
	mov	w0, -1
	strh	w0, [x25, #:lo12:.LANCHOR237]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 128
	ret
.L2815:
	ldrh	w1, [x20]
	cmp	w1, w5
	beq	.L2814
	umaddl	x2, w19, w6, x4
	add	w19, w19, 1
	and	w19, w19, 65535
	lsl	w1, w1, 10
	stp	xzr, xzr, [x2, 8]
	str	w1, [x2, 4]
.L2814:
	add	w0, w0, 1
	add	x20, x20, 2
	and	w0, w0, 65535
	b	.L2813
.L2821:
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
	bne	.L2825
	mov	x2, x3
	mov	w1, w27
	add	w0, w19, 256
	bl	FtlVendorPartRead
	mov	w21, w0
.L2824:
	mov	w0, w21
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 208
	ret
.L2825:
	add	w0, w1, w2
	str	w0, [x29, 148]
	adrp	x0, .LANCHOR68
	add	w1, w1, w2
	ldr	w0, [x0, #:lo12:.LANCHOR68]
	cmp	w1, w0
	bhi	.L2848
	adrp	x0, .LANCHOR232
	ldr	w21, [x0, #:lo12:.LANCHOR232]
	cmn	w21, #1
	beq	.L2824
	adrp	x22, .LANCHOR55
	bl	FtlCacheWriteBack
	adrp	x25, .LANCHOR138
	add	x25, x25, :lo12:.LANCHOR138
	ldrh	w0, [x22, #:lo12:.LANCHOR55]
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
.L2827:
	ldr	w0, [x29, 172]
	cbnz	w0, .L2847
	adrp	x0, .LANCHOR116
	ldrh	w0, [x0, #:lo12:.LANCHOR116]
	cbz	w0, .L2824
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	b	.L2824
.L2847:
	add	x1, x29, 188
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
	ldr	w1, [x29, 188]
	cmn	w1, #1
	bne	.L2828
	add	x3, x22, :lo12:.LANCHOR55
	mov	w28, 0
.L2829:
	ldrh	w0, [x3]
	cmp	w28, w0
	bcc	.L2831
.L2832:
	ldr	w0, [x29, 172]
	add	w20, w20, 1
	subs	w0, w0, #1
	str	w0, [x29, 172]
	beq	.L2836
	adrp	x0, .LANCHOR38
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w24, w0, lsl 2
	bne	.L2827
.L2836:
	cbz	w24, .L2827
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
	adrp	x0, .LC65
	add	x0, x0, :lo12:.LC65
	str	x0, [x29, 112]
.L2846:
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	ldr	w2, [x29, 168]
	add	x0, x0, x24
	ldr	w1, [x0, 24]
	cmp	w2, w1
	bne	.L2838
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR186
	ldr	x0, [x0, #:lo12:.LANCHOR186]
	cmp	x1, x0
	bne	.L2839
	ldr	x0, [x29, 136]
	ldr	w2, [x29, 144]
	add	x1, x1, x0
	mov	x0, x23
.L2863:
	bl	ftl_memcpy
.L2839:
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	add	x0, x0, x24
	ldr	x2, [x0, 16]
	ldr	w1, [x0, 24]
	ldr	w3, [x2, 8]
	cmp	w1, w3
	beq	.L2840
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
.L2840:
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	add	x1, x0, x24
	ldr	w0, [x0, x24]
	cmn	w0, #1
	bne	.L2841
	ldr	w1, [x25, 72]
	mov	w21, w0
	add	w1, w1, 1
	str	w1, [x25, 72]
.L2842:
	ldr	x0, [x29, 120]
	add	x24, x24, 56
	cmp	x0, x24
	bne	.L2846
	mov	w24, 0
	b	.L2827
.L2831:
	madd	w0, w20, w0, w28
	cmp	w19, w0
	bhi	.L2830
	ldr	w1, [x29, 148]
	cmp	w1, w0
	bls	.L2830
	sub	w0, w0, w19
	str	x3, [x29, 136]
	lsl	w0, w0, 9
	mov	w2, 512
	mov	w1, 0
	add	x0, x23, x0
	bl	ftl_memset
	ldr	x3, [x29, 136]
.L2830:
	add	w28, w28, 1
	b	.L2829
.L2828:
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	mov	w2, 56
	umaddl	x0, w24, w2, x0
	str	w1, [x0, 4]
	ldr	w1, [x29, 168]
	cmp	w20, w1
	bne	.L2833
	adrp	x1, .LANCHOR186
	ldr	x1, [x1, #:lo12:.LANCHOR186]
	str	x1, [x0, 8]
	ldrh	w1, [x22, #:lo12:.LANCHOR55]
	udiv	w2, w19, w1
	msub	w2, w2, w1, w19
	str	w2, [x29, 152]
	sub	w2, w1, w2
	cmp	w27, w2
	csel	w2, w27, w2, ls
	str	w2, [x29, 160]
	cmp	w1, w2
	bne	.L2834
	str	x23, [x0, 8]
.L2834:
	adrp	x1, .LANCHOR58
	adrp	x2, .LANCHOR189
	str	w20, [x0, 24]
	ldrh	w1, [x1, #:lo12:.LANCHOR58]
	ldr	x2, [x2, #:lo12:.LANCHOR189]
	mul	w1, w1, w24
	add	w24, w24, 1
	and	x1, x1, 4294967292
	add	x1, x2, x1
	str	x1, [x0, 16]
	b	.L2832
.L2833:
	ldr	w1, [x29, 164]
	cmp	w20, w1
	bne	.L2835
	ldrh	w2, [x22, #:lo12:.LANCHOR55]
	adrp	x1, .LANCHOR187
	ldr	w3, [x29, 148]
	ldr	x1, [x1, #:lo12:.LANCHOR187]
	str	x1, [x0, 8]
	mul	w1, w20, w2
	sub	w3, w3, w1
	str	w3, [x29, 156]
	cmp	w2, w3
	bne	.L2834
.L2862:
	sub	w1, w1, w19
	lsl	w1, w1, 9
	add	x1, x23, x1
	str	x1, [x0, 8]
	b	.L2834
.L2835:
	ldrh	w1, [x22, #:lo12:.LANCHOR55]
	mul	w1, w1, w20
	b	.L2862
.L2838:
	ldr	w2, [x29, 164]
	cmp	w2, w1
	bne	.L2839
	ldr	x1, [x0, 8]
	ldr	x0, [x28, #:lo12:.LANCHOR187]
	cmp	x1, x0
	bne	.L2839
	ldrh	w0, [x22, #:lo12:.LANCHOR55]
	mul	w0, w0, w2
	ldr	w2, [x29, 132]
	sub	w0, w0, w19
	lsl	w0, w0, 9
	add	x0, x23, x0
	b	.L2863
.L2841:
	cmp	w0, 256
	bne	.L2842
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	and	w1, w0, 65535
	str	w1, [x29, 128]
	bl	FtlGcRefreshBlock
	mov	w2, 2049
	adrp	x3, .LANCHOR205
.L2844:
	subs	w2, w2, #1
	bne	.L2843
.L2845:
	bl	FtlSysFlush
	b	.L2842
.L2843:
	mov	w1, 1
	str	x3, [x29, 96]
	mov	w0, w1
	str	w2, [x29, 108]
	bl	rk_ftl_garbage_collect
	ldr	x3, [x29, 96]
	ldr	w1, [x29, 128]
	ldr	w2, [x29, 108]
	ldrh	w0, [x3, #:lo12:.LANCHOR205]
	cmp	w0, w1
	beq	.L2844
	b	.L2845
.L2848:
	mov	w21, -1
	b	.L2824
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
	adrp	x1, .LANCHOR76
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	ldr	w1, [x1, #:lo12:.LANCHOR76]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w1, .L2896
	and	w0, w0, 255
	mov	w23, w2
	mov	x24, x3
	cmp	w0, 16
	bne	.L2866
	mov	x2, x3
	mov	w1, w23
	add	w0, w21, 256
	bl	FtlVendorPartWrite
.L2864:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	ret
.L2866:
	adrp	x0, .LANCHOR68
	add	w2, w21, w2
	ldr	w0, [x0, #:lo12:.LANCHOR68]
	cmp	w2, w0
	bhi	.L2897
	adrp	x0, .LANCHOR232
	ldr	w0, [x0, #:lo12:.LANCHOR232]
	cmn	w0, #1
	beq	.L2864
	adrp	x0, .LANCHOR249
	adrp	x26, .LANCHOR55
	mov	w1, 2048
	sub	w2, w2, #1
	str	w1, [x0, #:lo12:.LANCHOR249]
	ldrh	w1, [x26, #:lo12:.LANCHOR55]
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
	cbz	x2, .L2868
	ldr	w0, [x2, 24]
	cmp	w20, w0
	beq	.L2869
	bl	FtlCacheWriteBack
.L2868:
	adrp	x0, .LANCHOR91
	mov	w19, w20
	add	x22, x0, :lo12:.LANCHOR91
.L2870:
	cbnz	w25, .L2895
	ldr	w0, [x29, 152]
	sub	w1, w0, w20
	mov	w0, 0
	bl	rk_ftl_garbage_collect
.L2896:
	mov	w0, 0
	b	.L2864
.L2869:
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
	cbz	w27, .L2896
	sub	w23, w23, w19
	add	w21, w21, w19
	add	x24, x24, x22
	add	w20, w20, 1
	bl	FtlCacheWriteBack
	mov	w25, w27
	b	.L2868
.L2895:
	adrp	x0, .LANCHOR91
	add	x0, x0, :lo12:.LANCHOR91
	adrp	x1, .LANCHOR38
	str	x1, [x29, 120]
	ldrb	w2, [x0, 6]
	ldrh	w0, [x1, #:lo12:.LANCHOR38]
	cmp	w2, w0
	bcc	.L2871
	mov	w2, 1673
	adrp	x1, .LANCHOR250
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR250
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2871:
	ldrh	w0, [x22, 4]
	cbnz	w0, .L2872
	bl	FtlCacheWriteBack
	mov	x0, x22
	bl	allocate_new_data_superblock
.L2872:
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
	bcc	.L2873
	mov	w2, 1706
	adrp	x1, .LANCHOR250
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR250
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2873:
	adrp	x0, .LANCHOR58
	add	x0, x0, :lo12:.LANCHOR58
	str	xzr, [x29, 168]
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR57
	add	x0, x0, :lo12:.LANCHOR57
	str	x0, [x29, 104]
.L2874:
	ldr	w1, [x29, 144]
	adrp	x28, .LANCHOR182
	ldr	w27, [x29, 168]
	cmp	w27, w1
	bcc	.L2893
	mov	x27, x1
.L2875:
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	mov	x3, x22
	mov	w2, 0
	mov	w1, w27
	bl	FtlProgPages
	cmp	w25, w27
	bcs	.L2894
	mov	w2, 1795
	adrp	x1, .LANCHOR250
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR250
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2894:
	sub	w25, w25, w27
	b	.L2870
.L2893:
	ldrh	w0, [x22, 4]
	cbz	w0, .L2875
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
	bne	.L2876
	cmp	w19, w20
	bne	.L2877
	ldr	x0, [x29, 160]
	ldrh	w2, [x0, #:lo12:.LANCHOR55]
	udiv	w0, w21, w2
	msub	w0, w0, w2, w21
	str	w0, [x29, 148]
	sub	w2, w2, w0
	cmp	w2, w23
	csel	w0, w2, w23, ls
	str	w0, [x29, 156]
.L2878:
	ldr	x0, [x29, 160]
	ldr	w1, [x29, 156]
	ldrh	w0, [x0, #:lo12:.LANCHOR55]
	cmp	w0, w1
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	bne	.L2879
	add	x3, x0, x26
	cmp	w19, w20
	bne	.L2880
	str	x24, [x3, 8]
.L2881:
	ldr	x0, [x29, 120]
	ldrb	w1, [x22, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcc	.L2890
	mov	w2, 1780
	adrp	x1, .LANCHOR250
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR250
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2890:
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
	b	.L2874
.L2877:
	ldr	x0, [x29, 160]
	add	w2, w21, w23
	str	wzr, [x29, 148]
	ldrh	w0, [x0, #:lo12:.LANCHOR55]
	msub	w2, w19, w0, w2
	and	w0, w2, 65535
	str	w0, [x29, 156]
	b	.L2878
.L2880:
	ldr	w0, [x29, 156]
.L2908:
	mul	w0, w0, w19
	sub	w0, w0, w21
	lsl	w0, w0, 9
	add	x0, x24, x0
	str	x0, [x3, 8]
	b	.L2881
.L2879:
	add	x0, x0, x26
	cmp	w19, w20
	bne	.L2882
	adrp	x1, .LANCHOR186
	ldr	x1, [x1, #:lo12:.LANCHOR186]
.L2907:
	str	x1, [x0, 8]
	ldr	w0, [x29, 180]
	cmn	w0, #1
	beq	.L2884
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
	bne	.L2885
	adrp	x0, .LANCHOR138
	add	x0, x0, :lo12:.LANCHOR138
	ldr	w1, [x0, 72]
	add	w1, w1, 1
	str	w1, [x0, 72]
.L2888:
	ldr	w0, [x29, 156]
	cmp	w19, w20
	lsl	w2, w0, 9
	bne	.L2889
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	mov	x1, x24
	add	x3, x0, x26
	ldr	w0, [x29, 148]
	ldr	x3, [x3, 8]
	lsl	w0, w0, 9
	add	x0, x3, x0
.L2909:
	bl	ftl_memcpy
	b	.L2881
.L2882:
	adrp	x1, .LANCHOR187
	ldr	x1, [x1, #:lo12:.LANCHOR187]
	b	.L2907
.L2885:
	ldr	w1, [x27, 8]
	cmp	w19, w1
	beq	.L2887
	adrp	x0, .LANCHOR138
	add	x0, x0, :lo12:.LANCHOR138
	ldr	w2, [x0, 72]
	add	w2, w2, 1
	str	w2, [x0, 72]
	adrp	x0, .LC78
	mov	w2, w19
	add	x0, x0, :lo12:.LC78
	bl	printf
.L2887:
	ldr	w0, [x27, 8]
	cmp	w19, w0
	beq	.L2888
	mov	w2, 1759
	adrp	x1, .LANCHOR250
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR250
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
	b	.L2888
.L2884:
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	ldr	x1, [x29, 104]
	add	x0, x0, x26
	ldrh	w2, [x1]
	mov	w1, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	b	.L2888
.L2889:
	ldr	x0, [x29, 160]
	ldrh	w1, [x0, #:lo12:.LANCHOR55]
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	add	x3, x0, x26
	mul	w1, w1, w19
	sub	w1, w1, w21
	ldr	x0, [x3, 8]
	lsl	w1, w1, 9
	add	x1, x24, x1
	b	.L2909
.L2876:
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	add	x3, x0, x26
	ldr	x0, [x29, 160]
	ldrh	w0, [x0, #:lo12:.LANCHOR55]
	b	.L2908
.L2897:
	mov	w0, -1
	b	.L2864
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
	bne	.L2915
	mov	w3, w2
	mov	w0, 0
	mov	x2, x20
	bl	idb_write_data
.L2915:
	mov	x3, x20
	mov	w2, w19
	mov	w1, w22
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	b	FtlWrite
	.size	ftl_write, .-ftl_write
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
	adrp	x21, .LANCHOR203
	add	x1, x21, :lo12:.LANCHOR203
	ldr	x2, [x0, #:lo12:.LANCHOR183]
	adrp	x22, .LANCHOR53
	stp	x23, x24, [sp, 64]
	lsl	w26, w25, 10
	stp	x19, x20, [sp, 32]
	adrp	x23, .LC79
	str	x27, [sp, 96]
	adrp	x24, .LC80
	str	x2, [x1, 8]
	adrp	x2, .LANCHOR188
	add	x22, x22, :lo12:.LANCHOR53
	add	x23, x23, :lo12:.LC79
	ldr	x2, [x2, #:lo12:.LANCHOR188]
	add	x24, x24, :lo12:.LC80
	mov	x27, x0
	mov	w19, 0
	str	x2, [x1, 16]
.L2918:
	ldrh	w0, [x22]
	cmp	w19, w0
	blt	.L2920
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	ldr	x27, [sp, 96]
	add	sp, sp, 112
	ret
.L2920:
	add	x20, x21, :lo12:.LANCHOR203
	orr	w0, w19, w26
	mov	w2, 1
	mov	w1, w2
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
	ldp	x1, x0, [x20, 8]
	ldr	w2, [x21, #:lo12:.LANCHOR203]
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
	beq	.L2919
	ldr	x1, [x27, #:lo12:.LANCHOR183]
	mov	w3, 768
	mov	w2, 4
	mov	x0, x24
	bl	rknand_print_hex
.L2919:
	add	w19, w19, 1
	sxth	w19, w19
	b	.L2918
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
.L2926:
	ldrh	w0, [x22]
	cmp	w0, w20
	bhi	.L2932
	adrp	x25, .LANCHOR128
	adrp	x19, .LANCHOR203
	add	x25, x25, :lo12:.LANCHOR128
	add	x19, x19, :lo12:.LANCHOR203
	mov	w26, 0
.L2933:
	ldrh	w0, [x25]
	cmp	w26, w0
	bge	.L2936
	adrp	x21, .LANCHOR53
	adrp	x0, .LC49
	sbfiz	x23, x26, 1, 32
	mov	w20, 0
	add	x21, x21, :lo12:.LANCHOR53
	add	x24, x0, :lo12:.LC49
	b	.L2937
.L2928:
	ldrb	w0, [x23, x5]
	mov	w1, w20
	bl	V2P_block
	and	w4, w0, 65535
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L2927
	umaddl	x1, w19, w7, x6
	lsl	w4, w4, 10
	mul	w0, w19, w8
	add	w19, w19, 1
	and	w19, w19, 65535
	asr	w0, w0, 2
	str	w4, [x1, 4]
	add	x0, x10, x0, sxtw 2
	stp	x11, x0, [x1, 8]
.L2927:
	add	x5, x5, 1
.L2934:
	cmp	w12, w5, uxth
	bhi	.L2928
	cbnz	w19, .L2929
.L2931:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2926
.L2929:
	mov	w1, w19
	mov	w2, 1
	mov	x0, x6
	bl	FlashReadPages
	mov	w0, 56
	adrp	x26, .LC81
	add	x26, x26, :lo12:.LC81
	mov	x25, 0
	umull	x19, w19, w0
.L2930:
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
	bne	.L2930
	b	.L2931
.L2932:
	adrp	x0, .LANCHOR104
	adrp	x21, .LANCHOR180
	ldrh	w12, [x24, #:lo12:.LANCHOR38]
	mov	x5, 0
	ldr	x11, [x0, #:lo12:.LANCHOR104]
	adrp	x0, .LANCHOR105
	ldr	x6, [x21, #:lo12:.LANCHOR180]
	mov	w19, 0
	ldr	x10, [x0, #:lo12:.LANCHOR105]
	adrp	x0, .LANCHOR58
	mov	w7, 56
	ldrh	w8, [x0, #:lo12:.LANCHOR58]
	b	.L2934
.L2935:
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
.L2937:
	ldrh	w0, [x21]
	cmp	w20, w0
	blt	.L2935
	add	w0, w26, 1
	sxth	w26, w0
	b	.L2933
.L2936:
	adrp	x0, .LANCHOR64
	mov	w2, 2
	adrp	x19, .LANCHOR66
	ldr	w3, [x0, #:lo12:.LANCHOR64]
	adrp	x0, .LANCHOR129
	ldr	x1, [x0, #:lo12:.LANCHOR129]
	adrp	x0, .LC82
	add	x0, x0, :lo12:.LC82
	bl	rknand_print_hex
	adrp	x0, .LANCHOR131
	ldrh	w3, [x19, #:lo12:.LANCHOR66]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR131]
	adrp	x0, .LC83
	add	x0, x0, :lo12:.LC83
	bl	rknand_print_hex
	adrp	x0, .LANCHOR195
	ldrh	w3, [x19, #:lo12:.LANCHOR66]
	ldp	x21, x22, [sp, 48]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR195]
	adrp	x0, .LC84
	ldp	x19, x20, [sp, 32]
	add	x0, x0, :lo12:.LC84
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
	.global	idb_flash_slc_mode
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
	.global	g_nand_ecc_en
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
	.set	.LANCHOR60,. + 0
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
	.set	.LANCHOR99,. + 0
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
	.section	.bss.c_ftl_nand_byte_pre_oob,"aw",@nobits
	.align	1
	.set	.LANCHOR58,. + 0
	.type	c_ftl_nand_byte_pre_oob, %object
	.size	c_ftl_nand_byte_pre_oob, 2
c_ftl_nand_byte_pre_oob:
	.zero	2
	.section	.bss.c_ftl_nand_byte_pre_page,"aw",@nobits
	.align	1
	.set	.LANCHOR57,. + 0
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
	.set	.LANCHOR224,. + 0
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
	.set	.LANCHOR65,. + 0
	.type	c_ftl_nand_init_sys_blks_per_plane, %object
	.size	c_ftl_nand_init_sys_blks_per_plane, 4
c_ftl_nand_init_sys_blks_per_plane:
	.zero	4
	.section	.bss.c_ftl_nand_l2pmap_ram_region_num,"aw",@nobits
	.align	1
	.set	.LANCHOR67,. + 0
	.type	c_ftl_nand_l2pmap_ram_region_num, %object
	.size	c_ftl_nand_l2pmap_ram_region_num, 2
c_ftl_nand_l2pmap_ram_region_num:
	.zero	2
	.section	.bss.c_ftl_nand_map_blks_per_plane,"aw",@nobits
	.align	1
	.set	.LANCHOR63,. + 0
	.type	c_ftl_nand_map_blks_per_plane, %object
	.size	c_ftl_nand_map_blks_per_plane, 2
c_ftl_nand_map_blks_per_plane:
	.zero	2
	.section	.bss.c_ftl_nand_map_region_num,"aw",@nobits
	.align	1
	.set	.LANCHOR66,. + 0
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
	.set	.LANCHOR64,. + 0
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
	.set	.LANCHOR61,. + 0
	.type	c_ftl_nand_max_vendor_blks, %object
	.size	c_ftl_nand_max_vendor_blks, 2
c_ftl_nand_max_vendor_blks:
	.zero	2
	.section	.bss.c_ftl_nand_page_pre_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR52,. + 0
	.type	c_ftl_nand_page_pre_blk, %object
	.size	c_ftl_nand_page_pre_blk, 2
c_ftl_nand_page_pre_blk:
	.zero	2
	.section	.bss.c_ftl_nand_page_pre_slc_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR53,. + 0
	.type	c_ftl_nand_page_pre_slc_blk, %object
	.size	c_ftl_nand_page_pre_slc_blk, 2
c_ftl_nand_page_pre_slc_blk:
	.zero	2
	.section	.bss.c_ftl_nand_page_pre_super_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR54,. + 0
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
	.set	.LANCHOR59,. + 0
	.type	c_ftl_nand_reserved_blks, %object
	.size	c_ftl_nand_reserved_blks, 2
c_ftl_nand_reserved_blks:
	.zero	2
	.section	.bss.c_ftl_nand_sec_pre_page,"aw",@nobits
	.align	1
	.set	.LANCHOR55,. + 0
	.type	c_ftl_nand_sec_pre_page, %object
	.size	c_ftl_nand_sec_pre_page, 2
c_ftl_nand_sec_pre_page:
	.zero	2
	.section	.bss.c_ftl_nand_sec_pre_page_shift,"aw",@nobits
	.align	1
	.set	.LANCHOR56,. + 0
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
	.set	.LANCHOR62,. + 0
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
	.set	.LANCHOR107,. + 0
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
	.set	.LANCHOR74,. + 0
	.type	gBbtInfo, %object
	.size	gBbtInfo, 96
gBbtInfo:
	.zero	96
	.section	.bss.gBlockPageAlignSize,"aw",@nobits
	.align	2
	.set	.LANCHOR4,. + 0
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
	.set	.LANCHOR15,. + 0
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
	.set	.LANCHOR202,. + 0
	.type	gMultiPageReadEn, %object
	.size	gMultiPageReadEn, 1
gMultiPageReadEn:
	.zero	1
	.section	.bss.gNandChipMap,"aw",@nobits
	.align	3
	.set	.LANCHOR0,. + 0
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
	.set	.LANCHOR3,. + 0
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
	.set	.LANCHOR14,. + 0
	.type	gNandPhyInfo, %object
	.size	gNandPhyInfo, 28
gNandPhyInfo:
	.zero	28
	.section	.bss.gNandRandomizer,"aw",@nobits
	.set	.LANCHOR6,. + 0
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
	.set	.LANCHOR75,. + 0
	.type	gSysFreeQueue, %object
	.size	gSysFreeQueue, 2056
gSysFreeQueue:
	.zero	2056
	.section	.bss.gSysInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR210,. + 0
	.type	gSysInfo, %object
	.size	gSysInfo, 16
gSysInfo:
	.zero	16
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
	.set	.LANCHOR216,. + 0
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
	.set	.LANCHOR247,. + 0
	.type	g_LowFormat, %object
	.size	g_LowFormat, 4
g_LowFormat:
	.zero	4
	.section	.bss.g_MaxLbaSector,"aw",@nobits
	.align	2
	.set	.LANCHOR68,. + 0
	.type	g_MaxLbaSector, %object
	.size	g_MaxLbaSector, 4
g_MaxLbaSector:
	.zero	4
	.section	.bss.g_MaxLbn,"aw",@nobits
	.align	2
	.set	.LANCHOR223,. + 0
	.type	g_MaxLbn, %object
	.size	g_MaxLbn, 4
g_MaxLbn:
	.zero	4
	.section	.bss.g_MaxLpn,"aw",@nobits
	.align	2
	.set	.LANCHOR72,. + 0
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
	.set	.LANCHOR100,. + 0
	.type	g_VaildLpn, %object
	.size	g_VaildLpn, 4
g_VaildLpn:
	.zero	4
	.section	.bss.g_active_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR91,. + 0
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
	.set	.LANCHOR92,. + 0
	.type	g_buffer_superblock, %object
	.size	g_buffer_superblock, 48
g_buffer_superblock:
	.zero	48
	.section	.bss.g_cur_erase_blk,"aw",@nobits
	.align	2
	.set	.LANCHOR73,. + 0
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
	.set	.LANCHOR219,. + 0
	.type	g_ect_tbl_power_up_flush, %object
	.size	g_ect_tbl_power_up_flush, 2
g_ect_tbl_power_up_flush:
	.zero	2
	.section	.bss.g_flash_read_only_en,"aw",@nobits
	.align	2
	.set	.LANCHOR76,. + 0
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
	.set	.LANCHOR249,. + 0
	.type	g_ftl_nand_free_count, %object
	.size	g_ftl_nand_free_count, 4
g_ftl_nand_free_count:
	.zero	4
	.section	.bss.g_gc_bad_block_gc_index,"aw",@nobits
	.align	1
	.set	.LANCHOR118,. + 0
	.type	g_gc_bad_block_gc_index, %object
	.size	g_gc_bad_block_gc_index, 2
g_gc_bad_block_gc_index:
	.zero	2
	.section	.bss.g_gc_bad_block_temp_num,"aw",@nobits
	.align	1
	.set	.LANCHOR116,. + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.zero	2
	.section	.bss.g_gc_bad_block_temp_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR117,. + 0
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
	.set	.LANCHOR108,. + 0
	.type	g_gc_blk_num, %object
	.size	g_gc_blk_num, 2
g_gc_blk_num:
	.zero	2
	.section	.bss.g_gc_cur_blk_max_valid_pages,"aw",@nobits
	.align	1
	.set	.LANCHOR245,. + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.zero	2
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",@nobits
	.align	1
	.set	.LANCHOR244,. + 0
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
	.section	.bss.g_gc_next_blk_2,"aw",@nobits
	.align	1
	.set	.LANCHOR114,. + 0
	.type	g_gc_next_blk_2, %object
	.size	g_gc_next_blk_2, 2
g_gc_next_blk_2:
	.zero	2
	.section	.bss.g_gc_next_blk_3,"aw",@nobits
	.align	1
	.set	.LANCHOR115,. + 0
	.type	g_gc_next_blk_3, %object
	.size	g_gc_next_blk_3, 2
g_gc_next_blk_3:
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
	.set	.LANCHOR205,. + 0
	.type	g_gc_superblock, %object
	.size	g_gc_superblock, 48
g_gc_superblock:
	.zero	48
	.section	.bss.g_gc_temp_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR93,. + 0
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
	.set	.LANCHOR97,. + 0
	.type	g_l2p_last_update_region_id, %object
	.size	g_l2p_last_update_region_id, 2
g_l2p_last_update_region_id:
	.zero	2
	.section	.bss.g_maxRegNum,"aw",@nobits
	.set	.LANCHOR12,. + 0
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
	.section	.bss.g_nand_ecc_en,"aw",@nobits
	.set	.LANCHOR200,. + 0
	.type	g_nand_ecc_en, %object
	.size	g_nand_ecc_en, 1
g_nand_ecc_en:
	.zero	1
	.section	.bss.g_nandc_version_data,"aw",@nobits
	.align	2
	.set	.LANCHOR119,. + 0
	.type	g_nandc_version_data, %object
	.size	g_nandc_version_data, 4
g_nandc_version_data:
	.zero	4
	.section	.bss.g_num_data_superblocks,"aw",@nobits
	.align	1
	.set	.LANCHOR85,. + 0
	.type	g_num_data_superblocks, %object
	.size	g_num_data_superblocks, 2
g_num_data_superblocks:
	.zero	2
	.section	.bss.g_num_free_superblocks,"aw",@nobits
	.align	1
	.set	.LANCHOR88,. + 0
	.type	g_num_free_superblocks, %object
	.size	g_num_free_superblocks, 2
g_num_free_superblocks:
	.zero	2
	.section	.bss.g_page_map_check_enable,"aw",@nobits
	.align	1
	.set	.LANCHOR69,. + 0
	.type	g_page_map_check_enable, %object
	.size	g_page_map_check_enable, 2
g_page_map_check_enable:
	.zero	2
	.section	.bss.g_power_lost_ecc_error_blk,"aw",@nobits
	.align	1
	.set	.LANCHOR237,. + 0
	.type	g_power_lost_ecc_error_blk, %object
	.size	g_power_lost_ecc_error_blk, 2
g_power_lost_ecc_error_blk:
	.zero	2
	.section	.bss.g_power_lost_recovery_flag,"aw",@nobits
	.align	1
	.set	.LANCHOR238,. + 0
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
	.set	.LANCHOR239,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.zero	4
	.section	.bss.g_recovery_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR240,. + 0
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
	.set	.LANCHOR10,. + 0
	.type	g_retryMode, %object
	.size	g_retryMode, 1
g_retryMode:
	.zero	1
	.section	.bss.g_slc2KBNand,"aw",@nobits
	.set	.LANCHOR2,. + 0
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
	.set	.LANCHOR80,. + 0
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
	.set	.LANCHOR206,. + 0
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
	.set	.LANCHOR218,. + 0
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
	.set	.LANCHOR79,. + 0
	.type	g_totle_sys_slc_erase_count, %object
	.size	g_totle_sys_slc_erase_count, 4
g_totle_sys_slc_erase_count:
	.zero	4
	.section	.bss.g_totle_vendor_block,"aw",@nobits
	.align	1
	.set	.LANCHOR70,. + 0
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
	.set	.LANCHOR217,. + 0
	.type	g_totle_write_sector, %object
	.size	g_totle_write_sector, 4
g_totle_write_sector:
	.zero	4
	.section	.bss.gc_discard_updated,"aw",@nobits
	.align	2
	.set	.LANCHOR233,. + 0
	.type	gc_discard_updated, %object
	.size	gc_discard_updated, 4
gc_discard_updated:
	.zero	4
	.section	.bss.gc_ink_free_return_value,"aw",@nobits
	.align	1
	.set	.LANCHOR243,. + 0
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
	.set	.LANCHOR103,. + 0
	.type	gp_gc_page_buf_info, %object
	.size	gp_gc_page_buf_info, 8
gp_gc_page_buf_info:
	.zero	8
	.section	.bss.gp_last_act_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR231,. + 0
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
	.section	.bss.idb_flash_slc_mode,"aw",@nobits
	.align	2
	.set	.LANCHOR29,. + 0
	.type	idb_flash_slc_mode, %object
	.size	idb_flash_slc_mode, 4
idb_flash_slc_mode:
	.zero	4
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
	.set	.LANCHOR1,. + 0
	.type	p_blk_mode_table, %object
	.size	p_blk_mode_table, 8
p_blk_mode_table:
	.zero	8
	.section	.bss.p_data_block_list_head,"aw",@nobits
	.align	3
	.set	.LANCHOR82,. + 0
	.type	p_data_block_list_head, %object
	.size	p_data_block_list_head, 8
p_data_block_list_head:
	.zero	8
	.section	.bss.p_data_block_list_table,"aw",@nobits
	.align	3
	.set	.LANCHOR81,. + 0
	.type	p_data_block_list_table, %object
	.size	p_data_block_list_table, 8
p_data_block_list_table:
	.zero	8
	.section	.bss.p_data_block_list_tail,"aw",@nobits
	.align	3
	.set	.LANCHOR84,. + 0
	.type	p_data_block_list_tail, %object
	.size	p_data_block_list_tail, 8
p_data_block_list_tail:
	.zero	8
	.section	.bss.p_erase_count_table,"aw",@nobits
	.align	3
	.set	.LANCHOR78,. + 0
	.type	p_erase_count_table, %object
	.size	p_erase_count_table, 8
p_erase_count_table:
	.zero	8
	.section	.bss.p_free_data_block_list_head,"aw",@nobits
	.align	3
	.set	.LANCHOR87,. + 0
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
	.set	.LANCHOR96,. + 0
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
	.set	.LANCHOR83,. + 0
	.type	p_valid_page_count_table, %object
	.size	p_valid_page_count_table, 8
p_valid_page_count_table:
	.zero	8
	.section	.bss.p_vendor_block_table,"aw",@nobits
	.align	3
	.set	.LANCHOR71,. + 0
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
	.set	.LANCHOR77,. + 0
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
	.set	.LANCHOR203,. + 0
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
	.size	NandFlashParaTbl, 2592
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
	.byte	4
	.byte	0
	.byte	1
	.byte	0
	.zero	4
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
	.hword	1479
	.byte	5
	.byte	19
	.byte	60
	.byte	32
	.byte	1
	.byte	0
	.byte	4
	.byte	0
	.byte	1
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
	.byte	5
	.byte	44
	.byte	-124
	.byte	100
	.byte	60
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
	.byte	4
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
	.set	.LANCHOR13,. + 0
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
	.set	.LANCHOR8,. + 0
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
	.set	.LANCHOR9,. + 0
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
	.set	.LANCHOR11,. + 0
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
	.set	.LANCHOR241,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.hword	-1
	.section	.data.gFtlInitStatus,"aw",@progbits
	.align	2
	.set	.LANCHOR232,. + 0
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
	.set	.LANCHOR201,. + 0
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
	.set	.LANCHOR5,. + 0
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
.LC56:
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
.LC61:
	.string	"FtlCheckVpc2 %x = %x  %x\n"
.LC62:
	.string	"free blk vpc error %x = %x  %x\n"
	.section	.rodata.FtlDumpBlockInfo.str1.1,"aMS",@progbits,1
.LC46:
	.string	"...%s enter...\n"
.LC47:
	.string	"superBlkID = %x vpc=%x\n"
.LC48:
	.string	"flashmode = %x pagenum = %x %x\n"
.LC49:
	.string	"id = %x,%x addr= %x,spare= %x %x %x %x data=%x %x\n"
	.section	.rodata.FtlDumpSysBlock.str1.1,"aMS",@progbits,1
.LC79:
	.string	"id = %x,%x addr= %x,spare= %x %x %x %x data = %x\n"
.LC80:
	.string	":"
	.section	.rodata.FtlFreeSysBlkQueueOut.str1.1,"aMS",@progbits,1
.LC3:
	.string	"FtlFreeSysBlkQueueOut free count = %d\n"
.LC4:
	.string	"FtlFreeSysBlkQueueOut = %x, free count = %d, error\n"
	.section	.rodata.FtlGcFreeTempBlock.str1.1,"aMS",@progbits,1
.LC71:
	.string	"GC des block %x done\n"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",@progbits,1
.LC69:
	.string	"FtlGcScanTempBlk Error ID %x %x!!!!!!! \n"
.LC70:
	.string	"FtlGcScanTempBlkError ID %x %x!!!!!!!\n"
	.section	.rodata.FtlInit.str1.1,"aMS",@progbits,1
.LC72:
	.string	"FTL version: 5.0.57 20190828"
.LC73:
	.string	"...%s: no bad block mapping table, format device\n"
.LC74:
	.string	"...%s FtlSysBlkInit error ,format device!\n"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",@progbits,1
.LC43:
	.string	"no ect"
	.section	.rodata.FtlLoadSysInfo.str1.1,"aMS",@progbits,1
.LC45:
	.string	"id = %x,%x addr= %x,spare= %x %x %x %x data= %x\n"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",@progbits,1
.LC40:
	.string	"FtlMapWritePage error = %x\n"
.LC41:
	.string	"FtlMapWritePage error = %x error count = %d\n"
	.section	.rodata.FtlProgPages.str1.1,"aMS",@progbits,1
.LC60:
	.string	"Ftlwrite decrement_vpc_count %x = %d\n"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",@progbits,1
.LC66:
	.string	"RSB refresh addr %x\n"
.LC67:
	.string	"spuer block %x vpn is 0\n "
.LC68:
	.string	"g_recovery_ppa %x ver %x\n "
	.section	.rodata.FtlScanAllBlock.str1.1,"aMS",@progbits,1
.LC50:
	.string	"blk = %x vpc=%x mode = %x\n"
.LC51:
	.string	"mlc id = %x,%x addr= %x,spare= %x %x %x %x data=%x %x\n"
.LC52:
	.string	"slc id = %x,%x addr= %x,spare= %x %x %x %x data=%x %x\n"
	.section	.rodata.FtlVendorPartRead.str1.1,"aMS",@progbits,1
.LC42:
	.string	"FtlVendorPartRead refresh = %x phyAddr = %x\n"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",@progbits,1
.LC38:
	.string	"FtlVpcTblFlush error = %x error count = %d\n"
	.section	.rodata.FtlWrite.str1.1,"aMS",@progbits,1
.LC78:
	.string	"FtlWrite: lpa error:%x %x\n"
	.section	.rodata.Ftl_load_ext_data.str1.1,"aMS",@progbits,1
.LC44:
	.string	"slc mode"
	.section	.rodata.Ftlscanalldata.str1.1,"aMS",@progbits,1
.LC63:
	.string	"Ftlscanalldata = %x\n"
.LC64:
	.string	"scan lpa = %x ppa= %x\n"
.LC65:
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
	.section	.rodata.__func__.10021,"a",@progbits
	.align	3
	.set	.LANCHOR222,. + 0
	.type	__func__.10021, %object
	.size	__func__.10021, 15
__func__.10021:
	.string	"FtlLoadSysInfo"
	.section	.rodata.__func__.10032,"a",@progbits
	.align	3
	.set	.LANCHOR234,. + 0
	.type	__func__.10032, %object
	.size	__func__.10032, 12
__func__.10032:
	.string	"FtlCheckVpc"
	.section	.rodata.__func__.10064,"a",@progbits
	.align	3
	.set	.LANCHOR225,. + 0
	.type	__func__.10064, %object
	.size	__func__.10064, 17
__func__.10064:
	.string	"FtlDumpBlockInfo"
	.section	.rodata.__func__.10083,"a",@progbits
	.align	3
	.set	.LANCHOR226,. + 0
	.type	__func__.10083, %object
	.size	__func__.10083, 16
__func__.10083:
	.string	"FtlScanAllBlock"
	.section	.rodata.__func__.10188,"a",@progbits
	.align	3
	.set	.LANCHOR235,. + 0
	.type	__func__.10188, %object
	.size	__func__.10188, 16
__func__.10188:
	.string	"FtlReUsePrevPpa"
	.section	.rodata.__func__.10221,"a",@progbits
	.align	3
	.set	.LANCHOR236,. + 0
	.type	__func__.10221, %object
	.size	__func__.10221, 22
__func__.10221:
	.string	"FtlRecoverySuperblock"
	.section	.rodata.__func__.10275,"a",@progbits
	.align	3
	.set	.LANCHOR101,. + 0
	.type	__func__.10275, %object
	.size	__func__.10275, 16
__func__.10275:
	.string	"make_superblock"
	.section	.rodata.__func__.10295,"a",@progbits
	.align	3
	.set	.LANCHOR140,. + 0
	.type	__func__.10295, %object
	.size	__func__.10295, 18
__func__.10295:
	.string	"SupperBlkListInit"
	.section	.rodata.__func__.10339,"a",@progbits
	.align	3
	.set	.LANCHOR227,. + 0
	.type	__func__.10339, %object
	.size	__func__.10339, 17
__func__.10339:
	.string	"ftl_scan_all_ppa"
	.section	.rodata.__func__.10384,"a",@progbits
	.align	3
	.set	.LANCHOR204,. + 0
	.type	__func__.10384, %object
	.size	__func__.10384, 25
__func__.10384:
	.string	"allocate_data_superblock"
	.section	.rodata.__func__.10398,"a",@progbits
	.align	3
	.set	.LANCHOR220,. + 0
	.type	__func__.10398, %object
	.size	__func__.10398, 29
__func__.10398:
	.string	"allocate_new_data_superblock"
	.section	.rodata.__func__.10404,"a",@progbits
	.align	3
	.set	.LANCHOR209,. + 0
	.type	__func__.10404, %object
	.size	__func__.10404, 19
__func__.10404:
	.string	"get_new_active_ppa"
	.section	.rodata.__func__.10415,"a",@progbits
	.align	3
	.set	.LANCHOR207,. + 0
	.type	__func__.10415, %object
	.size	__func__.10415, 16
__func__.10415:
	.string	"update_vpc_list"
	.section	.rodata.__func__.10420,"a",@progbits
	.align	3
	.set	.LANCHOR208,. + 0
	.type	__func__.10420, %object
	.size	__func__.10420, 20
__func__.10420:
	.string	"decrement_vpc_count"
	.section	.rodata.__func__.10488,"a",@progbits
	.align	3
	.set	.LANCHOR242,. + 0
	.type	__func__.10488, %object
	.size	__func__.10488, 19
__func__.10488:
	.string	"FtlGcFreeTempBlock"
	.section	.rodata.__func__.10588,"a",@progbits
	.align	3
	.set	.LANCHOR246,. + 0
	.type	__func__.10588, %object
	.size	__func__.10588, 23
__func__.10588:
	.string	"rk_ftl_garbage_collect"
	.section	.rodata.__func__.9395,"a",@progbits
	.align	3
	.set	.LANCHOR248,. + 0
	.type	__func__.9395, %object
	.size	__func__.9395, 8
__func__.9395:
	.string	"FtlInit"
	.section	.rodata.__func__.9456,"a",@progbits
	.align	3
	.set	.LANCHOR230,. + 0
	.type	__func__.9456, %object
	.size	__func__.9456, 13
__func__.9456:
	.string	"FtlProgPages"
	.section	.rodata.__func__.9482,"a",@progbits
	.align	3
	.set	.LANCHOR250,. + 0
	.type	__func__.9482, %object
	.size	__func__.9482, 9
__func__.9482:
	.string	"FtlWrite"
	.section	.rodata.__func__.9565,"a",@progbits
	.align	3
	.set	.LANCHOR124,. + 0
	.type	__func__.9565, %object
	.size	__func__.9565, 14
__func__.9565:
	.string	"FtlBbt2Bitmap"
	.section	.rodata.__func__.9611,"a",@progbits
	.align	3
	.set	.LANCHOR212,. + 0
	.type	__func__.9611, %object
	.size	__func__.9611, 11
__func__.9611:
	.string	"FtlLoadBbt"
	.section	.rodata.__func__.9704,"a",@progbits
	.align	3
	.set	.LANCHOR89,. + 0
	.type	__func__.9704, %object
	.size	__func__.9704, 17
__func__.9704:
	.string	"INSERT_FREE_LIST"
	.section	.rodata.__func__.9708,"a",@progbits
	.align	3
	.set	.LANCHOR86,. + 0
	.type	__func__.9708, %object
	.size	__func__.9708, 17
__func__.9708:
	.string	"INSERT_DATA_LIST"
	.section	.rodata.__func__.9745,"a",@progbits
	.align	3
	.set	.LANCHOR90,. + 0
	.type	__func__.9745, %object
	.size	__func__.9745, 17
__func__.9745:
	.string	"List_remove_node"
	.section	.rodata.__func__.9775,"a",@progbits
	.align	3
	.set	.LANCHOR94,. + 0
	.type	__func__.9775, %object
	.size	__func__.9775, 22
__func__.9775:
	.string	"List_update_data_list"
	.section	.rodata.__func__.9782,"a",@progbits
	.align	3
	.set	.LANCHOR229,. + 0
	.type	__func__.9782, %object
	.size	__func__.9782, 20
__func__.9782:
	.string	"ftl_load_l2p_region"
	.section	.rodata.__func__.9813,"a",@progbits
	.align	3
	.set	.LANCHOR95,. + 0
	.type	__func__.9813, %object
	.size	__func__.9813, 26
__func__.9813:
	.string	"ftl_map_blk_alloc_new_blk"
	.section	.rodata.__func__.9823,"a",@progbits
	.align	3
	.set	.LANCHOR213,. + 0
	.type	__func__.9823, %object
	.size	__func__.9823, 15
__func__.9823:
	.string	"ftl_map_blk_gc"
	.section	.rodata.__func__.9836,"a",@progbits
	.align	3
	.set	.LANCHOR214,. + 0
	.type	__func__.9836, %object
	.size	__func__.9836, 31
__func__.9836:
	.string	"Ftl_write_map_blk_to_last_page"
	.section	.rodata.__func__.9849,"a",@progbits
	.align	3
	.set	.LANCHOR215,. + 0
	.type	__func__.9849, %object
	.size	__func__.9849, 16
__func__.9849:
	.string	"FtlMapWritePage"
	.section	.rodata.__func__.9869,"a",@progbits
	.align	3
	.set	.LANCHOR98,. + 0
	.type	__func__.9869, %object
	.size	__func__.9869, 22
__func__.9869:
	.string	"select_l2p_ram_region"
	.section	.rodata.__func__.9885,"a",@progbits
	.align	3
	.set	.LANCHOR228,. + 0
	.type	__func__.9885, %object
	.size	__func__.9885, 9
__func__.9885:
	.string	"log2phys"
	.section	.rodata.__func__.9947,"a",@progbits
	.align	3
	.set	.LANCHOR211,. + 0
	.type	__func__.9947, %object
	.size	__func__.9947, 15
__func__.9947:
	.string	"FtlVpcTblFlush"
	.section	.rodata.__func__.9966,"a",@progbits
	.align	3
	.set	.LANCHOR221,. + 0
	.type	__func__.9966, %object
	.size	__func__.9966, 14
__func__.9966:
	.string	"FtlScanSysBlk"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",@progbits,1
.LC36:
	.string	"decrement_vpc_count %x = %d\n"
.LC37:
	.string	"decrement_vpc_count %x = %d in free list\n"
	.section	.rodata.dump_map_info.str1.1,"aMS",@progbits,1
.LC81:
	.string	"phyBlk = %x,addr= %x,spare= %x %x %x %x data=%x %x\n"
.LC82:
	.string	"Mblk:"
.LC83:
	.string	"L2P:"
.LC84:
	.string	"L2PC:"
	.section	.rodata.ftl_fix_nand_power_lost_error.str1.1,"aMS",@progbits,1
.LC76:
	.string	"fix power lost blk = %x vpc=%x\n"
.LC77:
	.string	"erase power lost blk = %x vpc=%x\n"
	.section	.rodata.ftl_map_blk_alloc_new_blk.str1.1,"aMS",@progbits,1
.LC8:
	.string	"FtlFreeSysBlkQueueOut = %x, free count = %d\n"
	.section	.rodata.ftl_map_blk_gc.str1.1,"aMS",@progbits,1
.LC39:
	.string	"page map lost: %x %x\n"
	.section	.rodata.ftl_scan_all_ppa.str1.1,"aMS",@progbits,1
.LC53:
	.string	"ftl_scan_all_ppa blk %x page %x\n"
.LC54:
	.string	"addr= %x, status= %d,spare= %x %x %x %x data=%x %x\n"
.LC55:
	.string	"%s finished\n"
	.section	.rodata.idb_write_data.str1.1,"aMS",@progbits,1
.LC15:
	.string	"1 write_idblock fix data %x %x %x\n"
.LC16:
	.string	"write_idblock fail! %x %x %x %x\n"
.LC17:
	.string	"write_idblock fail! %x\n"
	.section	.rodata.log2phys.str1.1,"aMS",@progbits,1
.LC57:
	.string	"region_id = %x phyAddr = %x\n"
.LC58:
	.string	"map_ppn:"
.LC59:
	.string	"load_l2p_region refresh = %x phyAddr = %x\n"
	.section	.rodata.rk_ftl_init.str1.1,"aMS",@progbits,1
.LC75:
	.string	"FtlInit %x\n"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",@progbits,1
.LC18:
	.string	"%s 0x%x:"
.LC19:
	.string	"%x "
.LC20:
	.string	""
	.hidden	free
