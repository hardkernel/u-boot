/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2019-01-07
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
	.section	.text.FlashBlockAlignInit,"ax",@progbits
	.align	2
	.global	FlashBlockAlignInit
	.type	FlashBlockAlignInit, %function
FlashBlockAlignInit:
	and	w0, w0, 65535
	adrp	x1, .LANCHOR3
	cmp	w0, 256
	bls	.L36
	mov	w0, 512
.L39:
	str	w0, [x1, #:lo12:.LANCHOR3]
	ret
.L36:
	cmp	w0, 128
	bls	.L39
	mov	w0, 256
	b	.L39
	.size	FlashBlockAlignInit, .-FlashBlockAlignInit
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
	bne	.L42
	mov	w6, 6
	str	w6, [x2, 2056]
	str	wzr, [x2, 2052]
	str	wzr, [x2, 2052]
	str	w5, [x2, 2052]
	str	w4, [x2, 2052]
	str	w3, [x2, 2052]
.L44:
	mov	w3, 224
	str	w3, [x2, 2056]
	b	FlashSetRandomizer
.L42:
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
	b	.L44
	.size	FlashReadDpDataOutCmd, .-FlashReadDpDataOutCmd
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
	cbz	w2, .L47
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
.L47:
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
	.section	.text.js_hash,"ax",@progbits
	.align	2
	.global	js_hash
	.type	js_hash, %function
js_hash:
	mov	x4, x0
	mov	w0, 42982
	mov	x3, 0
	movk	w0, 0x47c6, lsl 16
.L57:
	cmp	w1, w3
	bhi	.L58
	ret
.L58:
	lsr	w2, w0, 2
	ldrb	w5, [x4, x3]
	add	w2, w2, w0, lsl 5
	add	x3, x3, 1
	add	w2, w2, w5
	eor	w0, w0, w2
	b	.L57
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
.L62:
	ldrb	w0, [x23]
	cmp	w0, w19
	bhi	.L66
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L66:
	mov	w0, 85
	str	w0, [x21, 8]
	add	x0, x22, :lo12:.LANCHOR9
	ldrsb	w0, [x19, x0]
	str	w0, [x21, 4]
	mov	x0, 200
	bl	udelay
	ldrb	w0, [x25]
	cmp	w0, 34
	bne	.L63
	ldrsb	w0, [x24, x19]
.L68:
	add	x19, x19, 1
	str	w0, [x21]
	b	.L62
.L63:
	cmp	w0, 35
	bne	.L65
	ldrsb	w0, [x20, x19]
	b	.L68
.L65:
	ldrsb	w0, [x26, w27, sxtw]
	b	.L68
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
.L70:
	ldrb	w0, [x23]
	cmp	w0, w20
	bhi	.L71
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L71:
	str	w24, [x22, 8]
	str	wzr, [x22]
	ldrsb	w0, [x20, x19]
	str	w0, [x22]
	ldrsb	w0, [x21, x20]
	add	x20, x20, 1
	str	w0, [x22]
	mov	x0, 300
	bl	udelay
	b	.L70
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
	bne	.L75
	adrp	x1, .LANCHOR15
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	cbnz	w1, .L75
	adrp	x1, .LANCHOR16
	add	x1, x1, :lo12:.LANCHOR16
	ldrh	w6, [x1, w6, sxtw 1]
.L75:
	uxtw	x8, w10
	adrp	x1, .LANCHOR17
	add	x1, x1, :lo12:.LANCHOR17
	cmp	w4, 1
	ldr	w1, [x1, x8, lsl 2]
	madd	w5, w5, w7, w1
	add	w5, w5, w6
	str	w5, [x2]
	str	w10, [x3]
	bls	.L77
	ldr	w1, [x0, 4]
	ldr	w0, [x0, 60]
	add	w1, w1, 1024
	cmp	w1, w0
	cset	w0, eq
	ret
.L77:
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
	bne	.L79
	and	w2, w2, 255
	adrp	x0, .LANCHOR7
	cbnz	w2, .L80
	add	x2, x0, :lo12:.LANCHOR7
	ldrb	w3, [x2, 13]
.L90:
	add	x2, x19, 8
	add	x0, x0, :lo12:.LANCHOR7
	add	x2, x20, x2, lsl 8
	str	w3, [x2, 8]
	ldrb	w4, [x0, 15]
	cbz	w4, .L84
	add	x3, x19, 8
	mov	w2, 0
	add	x3, x20, x3, lsl 8
.L83:
	cmp	w2, w4
	bcc	.L85
.L84:
	add	x19, x19, 8
	mov	x0, 80
	lsl	x19, x19, 8
	bl	udelay
	ldr	w0, [x20, x19]
	ldp	x19, x20, [sp, 16]
	and	w0, w0, 255
	ldp	x29, x30, [sp], 32
	ret
.L80:
	add	x2, x0, :lo12:.LANCHOR7
	ldrb	w3, [x2, 14]
	b	.L90
.L85:
	lsl	w0, w2, 3
	add	w2, w2, 1
	lsr	w0, w1, w0
	and	w0, w0, 255
	str	w0, [x3, 4]
	b	.L83
.L79:
	add	x0, x19, 8
	mov	w1, 112
	add	x0, x20, x0, lsl 8
	str	w1, [x0, 8]
	b	.L84
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
.L95:
	mov	w1, w20
	mov	w2, w21
	mov	w0, w19
	bl	FlashReadStatusEN
	mov	w1, w0
	cmp	w0, 255
	beq	.L95
	tbz	x1, 6, .L95
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
	beq	.L107
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
.L109:
	mov	w0, 0
	str	w1, [x2]
	ret
.L107:
	and	w1, w1, -8193
	b	.L109
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
	mov	x20, x2
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	and	w26, w1, 255
	stp	x23, x24, [sp, 48]
	and	w21, w3, 255
	adrp	x19, .LANCHOR20
	ldrb	w0, [x0, 19]
	cmp	w0, 6
	bne	.L115
	add	x0, x19, :lo12:.LANCHOR20
	ubfiz	x19, x22, 6, 8
	add	x19, x19, 20
	add	x19, x19, x21, uxtw 2
.L122:
	add	x19, x0, x19
.L116:
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
.L119:
	cmp	x24, x26
	bne	.L120
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
.L115:
	cmp	w0, 7
	bne	.L117
	add	x0, x19, :lo12:.LANCHOR20
	mov	x1, 28
	mov	w19, 160
	umaddl	x1, w19, w22, x1
	mov	w19, 10
	umaddl	x19, w21, w19, x1
	b	.L122
.L117:
	cmp	w0, 8
	bne	.L118
	add	x19, x19, :lo12:.LANCHOR20
	add	x0, x19, 28
	add	w19, w21, w21, lsl 2
	add	x19, x0, x19, sxtw
	b	.L116
.L118:
	add	x0, x19, :lo12:.LANCHOR20
	and	x19, x21, 255
	add	x19, x19, 2
	add	x19, x19, x22, uxtw 3
	add	x19, x0, x19, lsl 3
	add	x19, x19, 4
	b	.L116
.L120:
	ldrb	w0, [x20, x24]
	str	w0, [x23, 2052]
	mov	x0, 200
	bl	udelay
	ldrsb	w0, [x19, x24]
	add	x24, x24, 1
	str	w0, [x23, 2048]
	b	.L119
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
	bhi	.L130
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
.L126:
	lsl	x1, x19, 3
	and	w0, w19, 255
	ldrb	w1, [x1, x21]
	cmp	w1, 173
	bne	.L125
	ldrb	w1, [x20, 1]
	mov	w3, 0
	mov	x2, x22
	bl	HynixSetRRPara
.L125:
	add	x19, x19, 1
	cmp	x19, 4
	bne	.L126
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L130:
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
	cbz	x2, .L135
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
	cbz	x1, .L135
	str	w0, [x1]
	str	xzr, [x19, 16]
.L135:
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
	adrp	x1, .LANCHOR6
	add	x1, x1, :lo12:.LANCHOR6
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w19, 34464
	ldr	x20, [x1, x0]
	movk	w19, 0x1, lsl 16
.L145:
	ldr	w0, [x20]
	str	w0, [x29, 40]
	ldr	w0, [x29, 40]
	tbnz	x0, 9, .L146
	mov	x0, 10
	bl	udelay
	subs	w19, w19, #1
	bne	.L145
	mov	w0, -1
.L143:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L146:
	mov	w0, 0
	b	.L143
	.size	NandcWaitFlashReadyNoDelay, .-NandcWaitFlashReadyNoDelay
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
	movk	w19, 0x1, lsl 16
	ldr	x20, [x1, x0]
	mov	x0, 150
	bl	udelay
.L151:
	ldr	w0, [x20]
	str	w0, [x29, 40]
	ldr	w0, [x29, 40]
	tbnz	x0, 9, .L152
	mov	x0, 10
	bl	udelay
	subs	w19, w19, #1
	bne	.L151
	mov	w0, -1
.L149:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L152:
	mov	w0, 0
	b	.L149
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
	cbz	w0, .L157
	mov	w0, w20
	bl	NandcFlashCs
	sbfiz	x1, x20, 4, 32
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
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
.L157:
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
	cbz	w0, .L160
	mov	w0, w20
	bl	NandcFlashCs
	sbfiz	x1, x20, 4, 32
	adrp	x0, .LANCHOR6
	add	x0, x0, :lo12:.LANCHOR6
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
.L160:
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
.L175:
	ldrb	w3, [x5, x7]
	ldrb	w4, [x2]
	cmp	w3, 152
	ccmp	w3, w13, 4, ne
	beq	.L166
	cmp	w3, 173
	ccmp	w3, w17, 4, ne
	bne	.L167
.L166:
	cmp	w0, 1
	ldr	x1, [x2, -8]
	bne	.L168
	cbz	w6, .L167
	ubfiz	x4, x4, 8, 8
	cmp	w3, 173
	add	x1, x1, x4
	str	w8, [x1, 2056]
	bne	.L169
	str	w0, [x1, 2052]
.L187:
	str	wzr, [x1, 2048]
	b	.L173
.L169:
	cmp	w3, 44
	bne	.L171
	str	w0, [x1, 2052]
	str	w16, [x1, 2048]
.L173:
	str	wzr, [x1, 2048]
	str	wzr, [x1, 2048]
	str	wzr, [x1, 2048]
.L167:
	add	x5, x5, 8
	add	x2, x2, 16
	cmp	x5, 32
	bne	.L175
	mov	w0, 0
	bl	NandcWaitFlashReady
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L171:
	str	w10, [x1, 2052]
	str	w0, [x1, 2048]
	b	.L173
.L168:
	cbz	w12, .L167
	ubfiz	x4, x4, 8, 8
	cmp	w3, 173
	add	x1, x1, x4
	str	w8, [x1, 2056]
	bne	.L172
	str	w11, [x1, 2052]
	str	w15, [x1, 2048]
	b	.L173
.L172:
	cmp	w3, 44
	bne	.L174
	str	w11, [x1, 2052]
	str	w14, [x1, 2048]
	b	.L173
.L174:
	str	w10, [x1, 2052]
	b	.L187
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
.L189:
	cmp	w3, w0
	bhi	.L192
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	b	NandcWaitFlashReady
.L192:
	cmp	w4, 67
	bne	.L190
	ldrsb	w5, [x1, x0]
.L194:
	add	x0, x0, 1
	str	w5, [x20]
	b	.L189
.L190:
	ldrsb	w5, [x2, x0]
	b	.L194
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
.L198:
	cmp	x20, x22
	bne	.L203
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L203:
	mov	w1, 0
	mov	w4, w21
	add	x3, x29, 76
	add	x2, x29, 72
	mov	x0, x20
	bl	LogAddr2PhyAddr
	ldrb	w1, [x23]
	ldr	w0, [x29, 76]
	cmp	w1, w0
	bhi	.L199
	mov	w0, -1
	str	w0, [x20]
.L200:
	sub	w21, w21, #1
	add	x20, x20, 56
	and	w21, w21, 255
	b	.L198
.L199:
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
	tbz	x0, 0, .L201
	mov	w0, -1
	str	w0, [x20]
.L201:
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L202
	ldr	w1, [x29, 72]
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf
.L202:
	mov	w0, w19
	bl	NandcFlashDeCs
	b	.L200
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
	cbnz	w1, .L209
	adrp	x25, .LANCHOR23
	mov	x19, x0
	add	x26, x25, :lo12:.LANCHOR23
	mov	w20, 0
.L210:
	cmp	w20, w22
	adrp	x13, .LANCHOR25
	bcc	.L219
	adrp	x21, .LANCHOR15
	adrp	x23, .LANCHOR23
	add	x25, x13, :lo12:.LANCHOR25
	add	x21, x21, :lo12:.LANCHOR15
	add	x23, x23, :lo12:.LANCHOR23
	mov	x20, 0
.L220:
	ldrb	w0, [x25]
	cmp	w0, w20
	bhi	.L222
	adrp	x0, .LANCHOR28
	ldr	w0, [x0, #:lo12:.LANCHOR28]
	cbnz	w0, .L223
.L224:
	mov	w0, 0
	b	.L208
.L209:
	mov	w1, w2
	bl	FlashEraseSLc2KBlocks
.L208:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L219:
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
	bhi	.L212
	mov	w0, -1
	str	w0, [x19, x12]
.L213:
	add	w20, w20, 1
	b	.L210
.L212:
	adrp	x1, .LANCHOR27
	add	x2, x25, :lo12:.LANCHOR23
	mov	x3, 24
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
	cmp	w1, 0
	uxtw	x1, w0
	csel	w23, w23, wzr, ne
	madd	x1, x1, x3, x2
	ldr	x1, [x1, 8]
	cbz	x1, .L215
	bl	FlashWaitCmdDone
.L215:
	ldp	w2, w1, [x29, 88]
	mov	x0, 24
	madd	x0, x1, x0, x26
	str	w2, [x0, 4]
	stp	x21, xzr, [x0, 8]
	cbz	w23, .L216
	add	w2, w20, 1
	mov	w3, 56
	umaddl	x2, w2, w3, x19
	str	x2, [x0, 16]
.L216:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w21, [x0, x1]
	mov	x0, 24
	mul	x1, x1, x0
	mov	w0, w21
	strb	w21, [x26, x1]
	bl	NandcFlashCs
	cmp	w24, 1
	bne	.L217
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L217
	mov	w0, w21
	bl	flash_enter_slc_mode
.L218:
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
	b	.L213
.L217:
	mov	w0, w21
	bl	flash_exit_slc_mode
	b	.L218
.L222:
	mov	w0, w20
	bl	FlashWaitCmdDone
	cmp	w24, 1
	bne	.L221
	ldrb	w0, [x21]
	cbz	w0, .L221
	mov	x0, 24
	mul	x0, x20, x0
	ldrb	w0, [x0, x23]
	bl	flash_exit_slc_mode
.L221:
	add	x20, x20, 1
	b	.L220
.L223:
	adrp	x0, .LANCHOR22
	ldrb	w0, [x0, #:lo12:.LANCHOR22]
	cmp	w0, 69
	bne	.L224
	mov	w0, 56
	umaddl	x22, w22, w0, x19
.L225:
	cmp	x22, x19
	beq	.L224
	str	wzr, [x19], 56
	b	.L225
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
	bne	.L241
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
.L244:
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
.L241:
	str	w4, [x19, 2052]
	str	w3, [x19, 2052]
	str	w1, [x19, 2052]
	str	w0, [x19, 2056]
	b	.L244
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
	cbz	w0, .L246
	mov	w0, 0
	bl	flash_enter_slc_mode
.L247:
	adrp	x19, .LANCHOR30
	ldrb	w0, [x19, #:lo12:.LANCHOR30]
	cbz	w0, .L248
	adrp	x0, .LANCHOR24
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	tbz	x0, 0, .L248
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
	strb	wzr, [x19, #:lo12:.LANCHOR30]
.L248:
	adrp	x0, .LANCHOR6
	ldr	x0, [x0, #:lo12:.LANCHOR6]
	str	wzr, [x0, 336]
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L246:
	mov	w0, 0
	bl	flash_exit_slc_mode
	b	.L247
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
	bhi	.L258
	ldr	x0, [x1, #:lo12:.LANCHOR19]
	mov	w1, 4193
.L261:
	str	w1, [x0, 4]
	ret
.L258:
	cmp	w0, 99
	ldr	x0, [x1, #:lo12:.LANCHOR19]
	bls	.L260
	mov	w1, 8322
	b	.L261
.L260:
	mov	w1, 4225
	b	.L261
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
	bne	.L264
.L267:
	and	w1, w1, -17
.L265:
	orr	w1, w1, 1
	str	w1, [x2, 12]
	ret
.L264:
	cmp	w0, 24
	bne	.L266
	orr	w1, w1, 16
	b	.L265
.L266:
	orr	w1, w1, 262144
	cmp	w0, 40
	orr	w1, w1, 16
	bne	.L265
	b	.L267
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
.L281:
	ldr	w1, [x0, 8]
	str	w1, [sp, 8]
	ldr	w1, [sp, 8]
	tbz	x1, 20, .L281
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
	bls	.L286
	ldr	w0, [x21, 16]
	cmp	x5, 0
	str	w0, [x29, 88]
	ccmp	x4, 0, 0, eq
	ldr	w0, [x29, 88]
	and	w0, w0, -5
	str	w0, [x29, 88]
	beq	.L287
	and	w2, w2, 255
	adrp	x20, .LANCHOR35
	cbnz	w24, .L288
.L296:
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
	bne	.L297
	ldr	w0, [x29, 88]
	mov	w1, 2
	bfi	w0, w1, 3, 3
	str	w0, [x29, 88]
.L297:
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
.L287:
	ldr	w0, [x29, 88]
	str	w0, [x21, 16]
.L286:
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
.L288:
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
.L292:
	cmp	w3, w11
	bcs	.L296
	lsr	w0, w7, 2
	lsl	w0, w0, 2
	cbz	x5, .L293
	ldrh	w13, [x1]
	add	x1, x1, 4
	ldrh	w8, [x1, -2]
	orr	x8, x13, x8, lsl 16
	str	w8, [x10, x0]
.L294:
	add	w3, w3, 1
	add	w7, w7, w6
	b	.L292
.L293:
	str	w12, [x10, x0]
	b	.L294
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
	bls	.L325
	ldr	w0, [x3, 16]
	tbz	x0, 2, .L325
	ldr	w0, [x3, 16]
	tbz	x0, 1, .L313
	ldr	w0, [x3, 8]
	str	w0, [x29, 16]
.L308:
	ldr	w1, [x3, 28]
	ldr	w0, [x29, 16]
	ubfx	x1, x1, 16, 5
	ubfx	x0, x0, 22, 6
	cmp	w1, w0
	bge	.L309
	cmp	w2, 5
	bls	.L308
	ldr	w0, [x3]
	str	w0, [x29, 24]
	ldr	w0, [x29, 24]
	tbz	x0, 13, .L308
	ldr	w0, [x29, 24]
	tbz	x0, 17, .L308
.L309:
	adrp	x0, .LANCHOR35+40
	str	wzr, [x0, #:lo12:.LANCHOR35+40]
.L304:
	ldp	x29, x30, [sp], 32
	ret
.L313:
	ldr	w0, [x3, 8]
	str	w0, [x29, 16]
	ldr	w0, [x29, 16]
	tbz	x0, 20, .L313
	adrp	x0, .LANCHOR36
	mov	x4, x0
	ldr	w1, [x0, #:lo12:.LANCHOR36]
	cbz	w1, .L314
	mov	x0, x3
	bl	NandcSendDumpDataStart
.L314:
	ldr	w0, [x4, #:lo12:.LANCHOR36]
	cbz	w0, .L309
	mov	x0, x3
	bl	NandcSendDumpDataDone
	b	.L309
.L325:
	ldr	w0, [x3, 8]
	str	w0, [x29, 16]
	ldr	w0, [x29, 16]
	tbz	x0, 20, .L325
	b	.L304
	.size	NandcXferComp, .-NandcXferComp
	.section	.text.Ftl_log2,"ax",@progbits
	.align	2
	.global	Ftl_log2
	.type	Ftl_log2, %function
Ftl_log2:
	mov	w2, 1
	mov	w1, 0
.L334:
	cmp	w2, w0
	bls	.L335
	sub	w0, w1, #1
	ret
.L335:
	add	w1, w1, 1
	lsl	w2, w2, 1
	and	w1, w1, 65535
	b	.L334
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
.L339:
	strb	w3, [x3, x7]
	add	x3, x3, 1
	cmp	x3, 32
	bne	.L339
	ldrh	w7, [x5, 20]
	ldrb	w3, [x5, 15]
	cmp	w7, w3
	bcs	.L340
	and	w13, w0, 255
	mul	w15, w0, w2
	ubfiz	w14, w13, 1, 7
	add	x1, x1, :lo12:.LANCHOR47
	mov	w7, 0
.L341:
	cmp	w7, w0
	bcs	.L343
	and	w3, w7, 255
	mov	w10, w7
	mov	w12, 0
	b	.L344
.L342:
	add	w16, w15, w10
	strb	w3, [x1, w10, uxtw]
	add	w17, w13, w3
	add	w3, w14, w3
	add	w12, w12, 1
	and	w3, w3, 255
	add	w10, w10, w0
	strb	w17, [x1, x16]
.L344:
	cmp	w12, w2
	bcc	.L342
	add	w7, w7, 1
	b	.L341
.L343:
	ubfiz	w2, w2, 1, 15
	lsr	w8, w8, 1
	strh	w2, [x4, #:lo12:.LANCHOR45]
	strh	w8, [x6, #:lo12:.LANCHOR41]
.L340:
	adrp	x1, .LANCHOR48
	adrp	x13, .LANCHOR49
	mov	w2, 5
	cmp	w11, 1
	strh	w2, [x1, #:lo12:.LANCHOR48]
	strh	wzr, [x13, #:lo12:.LANCHOR49]
	bne	.L345
	strh	w11, [x1, #:lo12:.LANCHOR48]
.L345:
	adrp	x8, .LANCHOR50
	mov	w1, 4352
	strh	w1, [x8, #:lo12:.LANCHOR50]
	adrp	x1, .LANCHOR1
	ldrb	w11, [x1, #:lo12:.LANCHOR1]
	cbz	w11, .L346
	mov	w1, 384
	strh	w1, [x8, #:lo12:.LANCHOR50]
.L346:
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
	bls	.L347
	and	w0, w3, 255
	strh	w0, [x13, #:lo12:.LANCHOR49]
.L347:
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
	bls	.L348
.L364:
	strh	w0, [x10, #:lo12:.LANCHOR61]
	cbz	w11, .L350
	mov	w0, 640
	strh	w0, [x8, #:lo12:.LANCHOR50]
.L350:
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
	beq	.L351
.L365:
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
	cbz	w6, .L353
	add	w1, w1, 5
	add	w2, w2, 4
	strh	w2, [x10, #:lo12:.LANCHOR61]
.L366:
	str	w1, [x4, #:lo12:.LANCHOR64]
.L354:
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
	bcs	.L355
	mov	w0, 1
	strh	w0, [x3, #:lo12:.LANCHOR69]
.L355:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L348:
	mov	w0, 4
	b	.L364
.L351:
	add	w3, w3, 4
	b	.L365
.L353:
	cmp	w3, 7
	bhi	.L354
	mov	w1, 8
	b	.L366
	.size	FtlConstantsInit, .-FtlConstantsInit
	.section	.text.IsBlkInVendorPart,"ax",@progbits
	.align	2
	.global	IsBlkInVendorPart
	.type	IsBlkInVendorPart, %function
IsBlkInVendorPart:
	adrp	x1, .LANCHOR70
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR70]
	cbz	w1, .L371
	adrp	x1, .LANCHOR61
	ldrh	w2, [x1, #:lo12:.LANCHOR61]
	adrp	x1, .LANCHOR71
	ldr	x3, [x1, #:lo12:.LANCHOR71]
	mov	x1, 0
.L369:
	cmp	w2, w1, uxth
	bhi	.L370
.L371:
	mov	w0, 0
	ret
.L370:
	add	x1, x1, 1
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L369
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
	bls	.L387
	sub	w1, w0, w1
	cmp	w1, w2
	cset	w0, ls
	ret
.L387:
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
	bcc	.L391
	adrp	x0, .LANCHOR75
	add	x2, x0, :lo12:.LANCHOR75
	mov	x19, x0
	ldrh	w2, [x2, 6]
	cmp	w2, 1024
	beq	.L391
	and	w1, w1, 65535
	cbz	w1, .L393
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbnz	w0, .L393
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
.L393:
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
.L391:
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
	cbz	w2, .L401
	adrp	x2, .LANCHOR80+28
	ldrh	w3, [x1, 2]
	mov	w6, 0
	mov	w4, 0
	ldrh	w5, [x2, #:lo12:.LANCHOR80+28]
	ldrh	w2, [x1, 4]
	and	w5, w5, 31
.L403:
	cmp	w5, w4
	bgt	.L404
	cbz	w6, .L401
	add	x0, x0, :lo12:.LANCHOR75
	strh	w3, [x0, 2]
	strh	w2, [x0, 4]
.L401:
	ret
.L404:
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
	b	.L403
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
.L411:
	ldrh	w1, [x19, 6]
	cbz	w1, .L412
	ldrh	w0, [x19, 2]
	sub	w1, w1, #1
	strh	w1, [x19, 6]
	add	x2, x19, x0, sxtw 1
	add	w0, w0, 1
	and	w0, w0, 1023
	strh	w0, [x19, 2]
	ldr	w0, [x22]
	ldrh	w20, [x2, 8]
	cbnz	w0, .L413
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
	cbz	w2, .L414
	mov	w2, 1
	mov	w1, 0
	bl	FlashEraseBlocks
.L414:
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
.L413:
	sub	w0, w20, #1
	mov	w1, 65533
	cmp	w1, w0, uxth
	bcs	.L416
	ldrh	w2, [x23, 6]
	mov	w1, w20
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	b	.L411
.L412:
	adrp	x0, .LC3
	mov	w1, 0
	add	x0, x0, :lo12:.LC3
	bl	printf
.L415:
	b	.L415
.L416:
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
.L423:
	cmp	w0, w1
	beq	.L424
	ldrh	w0, [x2]
	cmp	w0, w5
	beq	.L425
	umaddl	x2, w0, w4, x3
	b	.L423
.L424:
	mov	w0, 1
	ret
.L425:
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
	bls	.L442
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
	cbnz	x12, .L429
	str	x5, [x1, #:lo12:.LANCHOR82]
.L442:
	mov	w0, 0
	ret
.L429:
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
.L437:
	add	w2, w2, 1
	and	w2, w2, 65535
	cmp	w14, w2
	bcc	.L428
	cmp	w1, w0
	beq	.L428
	ubfiz	x30, x1, 1, 16
	ldrh	w19, [x4, 4]
	cmp	w19, 0
	ldrh	w3, [x16, x30]
	mul	w3, w3, w19
	csel	w3, w3, w11, ne
	cmp	w7, w3
	bne	.L433
	ldrh	w19, [x17, x30]
	ldrh	w3, [x10]
	cmp	w19, w3
	bcc	.L435
.L434:
	strh	w1, [x6, x13]
	cmp	x4, x12
	ldrh	w1, [x4, 2]
	strh	w1, [x5, 2]
	bne	.L438
	strh	w0, [x4, 2]
	str	x5, [x15, #:lo12:.LANCHOR82]
	b	.L428
.L433:
	bcc	.L434
.L435:
	ldrh	w3, [x4]
	cmp	w3, w20
	bne	.L436
	strh	w1, [x5, 2]
	strh	w0, [x4]
	adrp	x0, .LANCHOR84
	str	x5, [x0, #:lo12:.LANCHOR84]
.L428:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L436:
	umaddl	x4, w3, w8, x6
	mov	w1, w3
	b	.L437
.L438:
	ldrh	w1, [x4, 2]
	mov	w2, 6
	umull	x1, w1, w2
	strh	w0, [x6, x1]
	strh	w0, [x4, 2]
	b	.L428
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
	bcs	.L444
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
.L444:
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
	beq	.L448
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
	cbnz	x5, .L449
	str	x4, [x1, #:lo12:.LANCHOR87]
.L448:
	mov	w0, 0
	ret
.L449:
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
.L452:
	ubfiz	x10, x1, 1, 16
	ldrh	w10, [x11, x10]
	cmp	w10, w13
	bcs	.L450
	ldrh	w10, [x2]
	cmp	w10, w7
	bne	.L451
	strh	w1, [x4, 2]
	strh	w0, [x2]
	b	.L448
.L451:
	umaddl	x2, w10, w6, x3
	mov	w1, w10
	b	.L452
.L450:
	ldrh	w6, [x2, 2]
	cmp	x2, x5
	strh	w6, [x4, 2]
	strh	w1, [x3, x8]
	bne	.L453
	strh	w0, [x2, 2]
	str	x4, [x12, #:lo12:.LANCHOR87]
	b	.L448
.L453:
	ldrh	w1, [x2, 2]
	mov	w4, 6
	umull	x1, w1, w4
	strh	w0, [x3, x1]
	strh	w0, [x2, 2]
	b	.L448
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
	bcs	.L454
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
.L454:
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
	bne	.L458
	ldr	x0, [x22]
	cmp	x19, x0
	beq	.L458
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
.L458:
	ldr	x0, [x22]
	mov	w1, 65535
	cmp	x19, x0
	ldrh	w0, [x23, x21]
	bne	.L459
	cmp	w0, w1
	bne	.L460
	str	xzr, [x22]
.L461:
	mov	w0, -1
	strh	w0, [x23, x21]
	strh	w0, [x19, 2]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L460:
	ldr	x1, [x20, #:lo12:.LANCHOR81]
	mov	w2, 6
	umaddl	x0, w0, w2, x1
	mov	w1, -1
	str	x0, [x22]
	strh	w1, [x0, 2]
	b	.L461
.L459:
	cmp	w0, w1
	ldrh	w1, [x19, 2]
	bne	.L462
	cmp	w1, w0
	beq	.L461
	mov	w0, 6
	mov	w2, -1
	umull	x1, w1, w0
	ldr	x0, [x20, #:lo12:.LANCHOR81]
	strh	w2, [x0, x1]
	b	.L461
.L462:
	ldr	x2, [x20, #:lo12:.LANCHOR81]
	mov	w3, 6
	umaddl	x4, w0, w3, x2
	strh	w1, [x4, 2]
	ldrh	w1, [x19, 2]
	umull	x1, w1, w3
	strh	w0, [x2, x1]
	b	.L461
	.size	List_remove_node, .-List_remove_node
	.section	.text.List_pop_index_node,"ax",@progbits
	.align	2
	.global	List_pop_index_node
	.type	List_pop_index_node, %function
List_pop_index_node:
	ldr	x2, [x0]
	cbz	x2, .L470
	stp	x29, x30, [sp, -32]!
	adrp	x3, .LANCHOR81
	and	w1, w1, 65535
	mov	w4, 65535
	add	x29, sp, 0
	str	x19, [sp, 16]
	mov	w5, 6
	ldr	x19, [x3, #:lo12:.LANCHOR81]
.L466:
	cbnz	w1, .L467
.L469:
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
.L467:
	ldrh	w3, [x2]
	cmp	w3, w4
	beq	.L469
	sub	w1, w1, #1
	umaddl	x2, w3, w5, x19
	and	w1, w1, 65535
	b	.L466
.L470:
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
	cbz	x1, .L480
	adrp	x0, .LANCHOR81
	mov	w4, 6
	ldr	x3, [x0, #:lo12:.LANCHOR81]
	mov	w0, 65535
.L477:
	cbz	w2, .L478
	ldrh	w1, [x1]
	cmp	w1, w0
	bne	.L479
	ret
.L479:
	sub	w2, w2, #1
	umaddl	x1, w1, w4, x3
	and	w2, w2, 65535
	b	.L477
.L480:
	mov	w0, 65535
	ret
.L478:
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
	beq	.L483
	adrp	x0, .LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w0, w19
	beq	.L483
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w0, w19
	beq	.L483
	adrp	x0, .LANCHOR81
	mov	w21, 6
	adrp	x24, .LANCHOR82
	mov	x26, x0
	umull	x21, w19, w21
	ldr	x23, [x0, #:lo12:.LANCHOR81]
	ldr	x1, [x24, #:lo12:.LANCHOR82]
	add	x22, x23, x21
	cmp	x22, x1
	beq	.L483
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
	bne	.L486
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	bne	.L486
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
.L486:
	ldrh	w0, [x22, 2]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L487
	ldrh	w1, [x23, x21]
	cmp	w1, w0
	beq	.L483
.L487:
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
	bcs	.L483
	adrp	x20, .LANCHOR85
	mov	w1, w19
	add	x0, x24, :lo12:.LANCHOR82
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR85]
	cbnz	w0, .L489
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
.L489:
	ldrh	w0, [x20, #:lo12:.LANCHOR85]
	sub	w0, w0, #1
	strh	w0, [x20, #:lo12:.LANCHOR85]
	mov	w0, w19
	bl	INSERT_DATA_LIST
.L483:
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
.L494:
	cmp	w20, w1
	beq	.L498
	mov	x21, x0
	ldrh	w2, [x0], 2
	cbnz	w2, .L495
	bl	FtlFreeSysBlkQueueOut
	and	w1, w0, 65535
	strh	w0, [x21]
	sub	w2, w1, #1
	mov	w0, 65533
	cmp	w0, w2, uxth
	bcs	.L496
	adrp	x0, .LANCHOR75+6
	ldrh	w2, [x0, #:lo12:.LANCHOR75+6]
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
.L497:
	b	.L497
.L496:
	ldr	w0, [x19, 48]
	strh	wzr, [x19, 2]
	add	w0, w0, 1
	str	w0, [x19, 48]
	ldrh	w0, [x19, 8]
	strh	w20, [x19]
	add	w0, w0, 1
	strh	w0, [x19, 8]
.L498:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L500
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
.L500:
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L495:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L494
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
.L503:
	and	w19, w1, 65535
	cmp	w19, w2
	bcc	.L505
	add	x3, x0, 4
	mov	w19, w2
	mov	w5, -2147483648
	mov	w1, 0
.L506:
	cmp	w1, w2
	bne	.L508
	cmp	w19, w2
	bcc	.L504
	adrp	x1, .LANCHOR97
	mov	w19, w2
	mov	w3, -1
	ldrh	w4, [x1, #:lo12:.LANCHOR97]
	mov	w1, 0
.L509:
	cmp	w1, w2
	bne	.L511
	cmp	w19, w1
	bcc	.L504
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
	b	.L504
.L505:
	add	x1, x1, 1
	add	x4, x0, x1, lsl 4
	ldrh	w4, [x4, -16]
	cmp	w4, w3
	bne	.L503
.L504:
	mov	w0, w19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L508:
	ldr	w4, [x3]
	tbnz	w4, #31, .L507
	cmp	w5, w4
	bls	.L507
	mov	w5, w4
	mov	w19, w1
.L507:
	add	w1, w1, 1
	add	x3, x3, 16
	and	w1, w1, 65535
	b	.L506
.L511:
	ldr	w6, [x0, 4]
	cmp	w3, w6
	bls	.L510
	ldrh	w5, [x0]
	cmp	w5, w4
	csel	w3, w3, w6, eq
	csel	w19, w19, w1, eq
.L510:
	add	w1, w1, 1
	add	x0, x0, 16
	and	w1, w1, 65535
	b	.L509
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
	bhi	.L514
	cbnz	w0, .L514
	add	w1, w1, 1
	strh	w1, [x2, #:lo12:.LANCHOR99]
	ret
.L514:
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
.L515:
	cmp	w5, w1, uxth
	bhi	.L517
	cbz	w3, .L513
	str	w2, [x0, #:lo12:.LANCHOR100]
.L513:
	ret
.L517:
	ldrh	w4, [x6, x1, lsl 1]
	cmp	w4, w7
	beq	.L516
	add	w2, w2, w4
	mov	w3, 1
.L516:
	add	x1, x1, 1
	b	.L515
	.size	FtlUpdateVaildLpn, .-FtlUpdateVaildLpn
	.section	.text.ftl_set_blk_mode,"ax",@progbits
	.align	2
	.global	ftl_set_blk_mode
	.type	ftl_set_blk_mode, %function
ftl_set_blk_mode:
	and	w0, w0, 65535
	cbz	w1, .L524
	b	ftl_set_blk_mode.part.10
.L524:
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
.L527:
	cmp	w2, w3
	bcc	.L529
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
.L530:
	cmp	x2, x3
	bne	.L532
	ret
.L529:
	ldrh	w5, [x4]
	cmp	w5, w1
	beq	.L528
	ldrh	w5, [x0, 4]
	add	w5, w5, 1
	strh	w5, [x0, 4]
.L528:
	add	w2, w2, 1
	add	x4, x4, 2
	and	w2, w2, 65535
	b	.L527
.L532:
	ldrh	w4, [x2]
	cmp	w4, w5
	beq	.L531
	ldrh	w4, [x0, 4]
	add	w4, w1, w4
	strh	w4, [x0, 4]
.L531:
	add	x2, x2, 2
	b	.L530
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
	bcc	.L534
	mov	w2, 2575
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
.L534:
	adrp	x0, .LANCHOR38
	adrp	x7, .LANCHOR47
	add	x6, x19, 16
	add	x7, x7, :lo12:.LANCHOR47
	ldrh	w8, [x0, #:lo12:.LANCHOR38]
	mov	x5, 0
	strh	wzr, [x19, 4]
	mov	w10, -1
	strb	wzr, [x19, 7]
.L535:
	cmp	w8, w5, uxth
	bhi	.L537
	adrp	x1, .LANCHOR52
	ldrb	w0, [x19, 7]
	strb	wzr, [x19, 9]
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	mul	w0, w0, w1
	strh	w0, [x19, 4]
	adrp	x0, .LANCHOR28
	ldr	w0, [x0, #:lo12:.LANCHOR28]
	cbz	w0, .L538
	adrp	x0, .LANCHOR78
	ldrh	w1, [x19]
	ldr	x0, [x0, #:lo12:.LANCHOR78]
	ldrh	w0, [x0, x1, lsl 1]
	cmp	w0, 79
	bhi	.L538
	mov	w0, 1
	strb	w0, [x19, 9]
.L538:
	adrp	x0, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR1]
	cbz	w0, .L539
	mov	w0, 1
	strb	w0, [x19, 9]
.L539:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L537:
	ldrh	w1, [x19]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	mov	w4, w0
	strh	w10, [x6]
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L536
	strh	w4, [x6]
	ldrb	w0, [x19, 7]
	add	w0, w0, 1
	strb	w0, [x19, 7]
.L536:
	add	x5, x5, 1
	add	x6, x6, 2
	b	.L535
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
	bhi	.L559
	cbz	w5, .L557
	mov	w0, 32768
	sdiv	w5, w0, w5
.L558:
	adrp	x0, .LANCHOR81
	mov	w1, 6
	ldr	x0, [x0, #:lo12:.LANCHOR81]
	umaddl	x6, w6, w1, x0
	mov	w0, 0
	strh	w5, [x6, 4]
	ret
.L552:
	mov	w5, 0
	b	.L551
.L557:
	mov	w5, 0
	b	.L558
.L559:
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
.L550:
	ldrb	w0, [x8, x7]
	mov	w1, w6
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L549
	add	w5, w5, w11
	and	w5, w5, 65535
.L549:
	add	x7, x7, 1
	cmp	w10, w7, uxth
	bhi	.L550
	cbz	w5, .L552
	mov	w0, 32768
	sdiv	w5, w0, w5
.L551:
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
	cbz	x0, .L562
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
.L562:
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
	cbz	x1, .L570
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
.L566:
	cmp	w0, w2
	beq	.L569
	umull	x4, w1, w5
	ldrh	w4, [x3, x4]
	cmp	w4, w6
	bne	.L567
.L569:
	adrp	x0, .LANCHOR78
	ubfiz	x1, x1, 1, 16
	ldr	x0, [x0, #:lo12:.LANCHOR78]
	ldrh	w0, [x0, x1]
	ret
.L567:
	add	w2, w2, 1
	mov	w1, w4
	and	w2, w2, 65535
	b	.L566
.L570:
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
	beq	.L574
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
.L574:
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
.L578:
	add	w13, w2, w10
	add	w12, w1, w11
	cmp	x3, x8
	bne	.L579
	adrp	x1, .LANCHOR107
	ldr	x7, [x7, #:lo12:.LANCHOR104]
	ldr	x6, [x6, #:lo12:.LANCHOR105]
	mov	w8, 24
	ldr	w4, [x1, #:lo12:.LANCHOR107]
.L580:
	cmp	w0, w4
	bcc	.L581
	ret
.L579:
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
	b	.L578
.L581:
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
	b	.L580
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
.L583:
	cmp	w3, w1
	bcs	.L582
	umaddl	x6, w3, w7, x0
	mov	w2, 0
	b	.L588
.L584:
	add	w2, w2, 1
	and	w2, w2, 65535
.L588:
	cmp	w2, w8
	bcs	.L585
	umull	x5, w2, w10
	add	x11, x4, x5
	ldr	x12, [x4, x5]
	ldr	x5, [x6, 8]
	cmp	x12, x5
	bne	.L584
	str	wzr, [x11, 16]
.L585:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L583
.L582:
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
.L590:
	cmp	w3, w1
	bcs	.L589
	mov	w2, 0
	b	.L595
.L591:
	add	w2, w2, 1
	and	w2, w2, 65535
.L595:
	cmp	w2, w5
	bcs	.L592
	umaddl	x4, w2, w7, x6
	ldr	w11, [x4, 16]
	cbnz	w11, .L591
	umaddl	x2, w3, w10, x0
	ldr	x11, [x4]
	str	w8, [x4, 16]
	ldr	x4, [x4, 8]
	stp	x11, x4, [x2, 8]
.L592:
	add	w3, w3, 1
	and	w3, w3, 65535
	b	.L590
.L589:
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
.L597:
	cmp	w2, w1, uxth
	bhi	.L599
	mov	w0, 0
	ret
.L599:
	add	x1, x1, 1
	add	x4, x3, x1, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w0
	bne	.L597
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
.L602:
	and	w2, w3, 65535
	cmp	w2, w1
	bcc	.L604
	bne	.L603
	and	x3, x3, 65535
	strh	w0, [x5, x3, lsl 1]
	ldrh	w0, [x4, #:lo12:.LANCHOR108]
	add	w0, w0, 1
	strh	w0, [x4, #:lo12:.LANCHOR108]
	b	.L603
.L604:
	add	x3, x3, 1
	add	x2, x5, x3, lsl 1
	ldrh	w2, [x2, -2]
	cmp	w2, w7
	bne	.L602
.L603:
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
	beq	.L607
	adrp	x6, .LANCHOR113
	ldrh	w7, [x6, #:lo12:.LANCHOR113]
	cmp	w0, w7
	beq	.L607
	adrp	x4, .LANCHOR114
	ldrh	w5, [x4, #:lo12:.LANCHOR114]
	cmp	w0, w5
	beq	.L607
	adrp	x2, .LANCHOR115
	ldrh	w3, [x2, #:lo12:.LANCHOR115]
	cmp	w0, w3
	beq	.L607
	mov	w1, 65535
	cmp	w10, w1
	bne	.L608
	strh	w0, [x8, #:lo12:.LANCHOR112]
.L607:
	mov	w0, 0
	ret
.L608:
	cmp	w7, w1
	bne	.L609
	strh	w0, [x6, #:lo12:.LANCHOR113]
	b	.L607
.L609:
	cmp	w5, w1
	bne	.L610
	strh	w0, [x4, #:lo12:.LANCHOR114]
	b	.L607
.L610:
	cmp	w3, w1
	bne	.L607
	strh	w0, [x2, #:lo12:.LANCHOR115]
	b	.L607
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
	beq	.L619
	adrp	x6, .LANCHOR113
	ldrh	w7, [x6, #:lo12:.LANCHOR113]
	cmp	w0, w7
	beq	.L619
	adrp	x4, .LANCHOR114
	ldrh	w5, [x4, #:lo12:.LANCHOR114]
	cmp	w0, w5
	beq	.L619
	adrp	x2, .LANCHOR115
	ldrh	w3, [x2, #:lo12:.LANCHOR115]
	cmp	w0, w3
	beq	.L619
	mov	w1, 65535
	cmp	w10, w1
	bne	.L613
	strh	w0, [x8, #:lo12:.LANCHOR112]
.L619:
	mov	w0, 0
	ret
.L613:
	cmp	w7, w1
	bne	.L614
	strh	w0, [x6, #:lo12:.LANCHOR113]
	b	.L619
.L614:
	cmp	w5, w1
	bne	.L615
	strh	w0, [x4, #:lo12:.LANCHOR114]
	b	.L619
.L615:
	cmp	w3, w1
	bne	.L620
	strh	w0, [x2, #:lo12:.LANCHOR115]
	b	.L619
.L620:
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
	cbz	w0, .L622
	adrp	x1, .LANCHOR78
	ubfiz	x0, x11, 1, 16
	ldr	x2, [x1, #:lo12:.LANCHOR78]
	ldrh	w1, [x2, x0]
	cmp	w1, 39
	bls	.L622
	sub	w1, w1, #40
	strh	w1, [x2, x0]
.L622:
	adrp	x1, .LANCHOR116
	adrp	x3, .LANCHOR117
	add	x3, x3, :lo12:.LANCHOR117
	mov	x2, 0
	ldrh	w0, [x1, #:lo12:.LANCHOR116]
.L623:
	cmp	w0, w2, uxth
	bhi	.L625
	cmp	w0, 15
	bhi	.L624
	add	w2, w0, 1
	strh	w2, [x1, #:lo12:.LANCHOR116]
	adrp	x1, .LANCHOR117
	add	x1, x1, :lo12:.LANCHOR117
	strh	w12, [x1, w0, sxtw 1]
	b	.L624
.L625:
	add	x2, x2, 1
	add	x4, x3, x2, lsl 1
	ldrh	w4, [x4, -2]
	cmp	w4, w12
	bne	.L623
.L624:
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
	cbz	w0, .L637
	adrp	x1, .LANCHOR112
	ldrh	w2, [x1, #:lo12:.LANCHOR112]
	mov	w1, 65535
	cmp	w2, w1
	bne	.L637
	stp	x29, x30, [sp, -16]!
	adrp	x11, .LANCHOR118
	add	x29, sp, 0
	ldrh	w1, [x11, #:lo12:.LANCHOR118]
	cmp	w1, w0
	bcc	.L632
	strh	wzr, [x11, #:lo12:.LANCHOR118]
.L632:
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
.L637:
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
	bne	.L640
	b	flash_enter_slc_mode
.L640:
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
	bne	.L642
	b	flash_exit_slc_mode
.L642:
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
	cbnz	w0, .L648
	adrp	x1, .LANCHOR16
	add	x1, x1, :lo12:.LANCHOR16
	mov	x0, 0
.L649:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 256
	bne	.L649
.L655:
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
.L650:
	cmp	w20, w0, uxth
	bhi	.L674
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L648:
	cmp	w0, 1
	bne	.L651
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
	mov	x1, 0
.L654:
	and	w0, w1, 65535
	cmp	x1, 3
	bls	.L652
	ubfiz	w3, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 2
	sub	w0, w3, w0
	and	w0, w0, 65535
.L652:
	strh	w0, [x2, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L654
	b	.L655
.L651:
	cmp	w0, 2
	bne	.L656
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
	mov	w1, 65535
	mov	x0, 0
.L658:
	cmp	x0, 2
	and	w3, w0, 65535
	csel	w3, w3, w1, cc
	strh	w3, [x2, x0, lsl 1]
	add	w1, w1, 2
	add	x0, x0, 1
	and	w1, w1, 65535
	cmp	x0, 256
	bne	.L658
	b	.L655
.L656:
	cmp	w0, 3
	bne	.L659
	adrp	x2, .LANCHOR16
	add	x2, x2, :lo12:.LANCHOR16
	mov	x1, 0
.L662:
	and	w0, w1, 65535
	cmp	x1, 5
	bls	.L660
	ubfiz	w3, w0, 1, 15
	and	w0, w0, 1
	add	w0, w0, 4
	sub	w0, w3, w0
	and	w0, w0, 65535
.L660:
	strh	w0, [x2, x1, lsl 1]
	add	x1, x1, 1
	cmp	x1, 256
	bne	.L662
	b	.L655
.L659:
	cmp	w0, 4
	bne	.L663
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
.L665:
	and	w3, w0, 1
	ubfiz	w2, w0, 1, 15
	add	w3, w3, 6
	add	w0, w0, 1
	sub	w2, w2, w3
	strh	w2, [x1], 2
	and	w0, w0, 65535
	cmp	w0, 256
	bne	.L665
	b	.L655
.L663:
	cmp	w0, 5
	bne	.L666
	adrp	x1, .LANCHOR16
	add	x1, x1, :lo12:.LANCHOR16
	mov	x0, 0
.L667:
	strh	w0, [x1, x0, lsl 1]
	add	x0, x0, 1
	cmp	x0, 16
	bne	.L667
	add	x1, x1, 32
.L668:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 496
	bne	.L668
	b	.L655
.L666:
	cmp	w0, 6
	bne	.L669
	adrp	x3, .LANCHOR16
	add	x3, x3, :lo12:.LANCHOR16
	mov	w1, 0
	mov	x2, 0
	mov	w4, 12
	mov	w5, 10
.L672:
	and	w0, w2, 65535
	cmp	x2, 5
	bls	.L670
	tst	x0, 1
	csel	w0, w4, w5, ne
	sub	w0, w1, w0
	and	w0, w0, 65535
.L670:
	strh	w0, [x3, x2, lsl 1]
	add	w1, w1, 3
	and	w1, w1, 65535
	add	x2, x2, 1
	cmp	w1, 768
	bne	.L672
	b	.L655
.L669:
	cmp	w0, 9
	bne	.L655
	adrp	x1, .LANCHOR16
	add	x0, x1, :lo12:.LANCHOR16
	strh	wzr, [x1, #:lo12:.LANCHOR16]
	mov	w1, 1
	strh	w1, [x0, 2]
	mov	w1, 2
	strh	w1, [x0, 4]
	add	x1, x0, 6
	mov	w0, 3
.L673:
	strh	w0, [x1], 2
	add	w0, w0, 2
	and	w0, w0, 65535
	cmp	w0, 509
	bne	.L673
	b	.L655
.L674:
	ldrh	w2, [x1, x0, lsl 1]
	add	x0, x0, 1
	strh	w2, [x19, w2, sxtw 1]
	b	.L650
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
.L692:
	mov	w2, w12
	add	x1, x10, x22, lsl 3
	mov	x0, x11
	bl	FlashMemCmp8
	cbnz	w0, .L691
	ldrb	w1, [x15]
	add	w0, w1, 1
	strb	w0, [x15]
	str	wzr, [x20, x1, lsl 2]
	strb	w22, [x21, x1]
.L691:
	add	x22, x22, 1
	cmp	x22, 4
	bne	.L692
	ldrb	w0, [x25, #:lo12:.LANCHOR25]
	strb	w0, [x19, #:lo12:.LANCHOR121]
	ldrb	w0, [x7, 8]
	cmp	w0, 2
	beq	.L693
.L697:
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
.L693:
	adrp	x0, .LANCHOR3
	add	x13, x13, :lo12:.LANCHOR22
	add	x15, x25, :lo12:.LANCHOR25
	add	x23, x23, :lo12:.LANCHOR17
	ldr	w20, [x0, #:lo12:.LANCHOR3]
	add	x14, x24, :lo12:.LANCHOR26
	mov	x19, 0
.L696:
	mov	w2, w12
	add	x1, x13, x19, lsl 3
	mov	x0, x11
	bl	FlashMemCmp8
	cbnz	w0, .L694
	ldrb	w2, [x7, 13]
	ldrh	w0, [x7, 14]
	ldrb	w1, [x15]
	and	w0, w0, 65280
	mul	w2, w2, w20
	mul	w0, w0, w2
	sxtw	x2, w1
	str	w0, [x23, x2, lsl 2]
	ldrb	w3, [x7, 23]
	cbz	w3, .L695
	lsl	w0, w0, 1
	str	w0, [x23, x2, lsl 2]
.L695:
	add	w1, w1, 1
	strb	w19, [x14, x2]
	strb	w1, [x15]
.L694:
	add	x19, x19, 1
	cmp	x19, 4
	bne	.L696
	b	.L697
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
.L706:
	cmp	w3, w1, uxtb
	bhi	.L707
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L707:
	ldrb	w0, [x1, x2]
	add	x1, x1, 1
	ldrb	w5, [x19, 10]
	lsl	w0, w4, w0
	orr	w0, w0, w5
	strb	w0, [x19, 10]
	b	.L706
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
.L712:
	ldrh	w0, [x21, x19]
	cmp	w0, w24
	beq	.L709
	ldrh	w1, [x22]
	cmp	w1, w0
	bhi	.L711
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
.L711:
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
	bne	.L712
.L709:
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
.L720:
	ldrh	w1, [x19, 6]
	cmp	w1, w0
	bhi	.L724
	adrp	x0, .LANCHOR53
	mov	w23, 0
	mov	w20, 0
	ldrh	w1, [x0, #:lo12:.LANCHOR53]
	ldrh	w0, [x19]
	strh	w1, [x21, x0, lsl 1]
	ldrh	w24, [x21]
.L725:
	ldrh	w0, [x19, 10]
	cmp	w0, w20
	bhi	.L729
	mov	w0, w23
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L724:
	ubfiz	x1, x0, 2, 16
	ldr	w2, [x20, x1]
	mov	w1, 0
	ubfx	x2, x2, 10, 16
.L721:
	ldrh	w3, [x19, 10]
	cmp	w3, w1
	bhi	.L723
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L720
.L723:
	ubfiz	x3, x1, 1, 16
	ldrh	w4, [x22, x3]
	cmp	w4, w2
	bne	.L722
	cbz	w2, .L722
	ldrh	w4, [x21, x3]
	add	w4, w4, 1
	strh	w4, [x21, x3]
.L722:
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L721
.L729:
	ubfiz	x0, x20, 1, 16
	ldrh	w1, [x21, x0]
	cmp	w24, w1
	bls	.L726
	add	x25, x22, x0
	ldrh	w0, [x22, x0]
	cbnz	w0, .L727
.L728:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L725
.L726:
	cbnz	w1, .L728
	add	x25, x22, x0
	ldrh	w0, [x22, x0]
	cbz	w0, .L728
.L730:
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
	strh	wzr, [x25]
	ldrh	w0, [x19, 8]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	b	.L728
.L731:
	mov	w24, 0
	b	.L730
.L727:
	mov	w23, w20
	cbz	w1, .L731
	mov	w24, w1
	b	.L728
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
.L741:
	add	x4, x1, x5
	cmp	x0, x3
	bne	.L742
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
.L742:
	and	x1, x1, -4
	strh	w2, [x0]
	add	x1, x6, x1
	str	wzr, [x0, 4]
	str	x1, [x0, 8]
	add	x0, x0, 16
	mov	x1, x4
	b	.L741
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
.L747:
	ldrh	w0, [x25]
	cmp	w19, w0
	bge	.L754
	adrp	x0, .LANCHOR52
	ldrh	w8, [x27, #:lo12:.LANCHOR38]
	mov	w5, 0
	mov	w6, 0
	ldrh	w7, [x0, #:lo12:.LANCHOR52]
	b	.L755
.L749:
	ldrb	w0, [x26, w6, sxtw]
	mov	w1, w19
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L748
	add	w5, w7, w5
	sxth	w5, w5
.L748:
	add	w6, w6, 1
	sxth	w6, w6
.L755:
	cmp	w6, w8
	blt	.L749
	cbz	w5, .L750
	mov	w0, 32768
	sdiv	w5, w0, w5
	sxth	w5, w5
.L751:
	ldr	x1, [x24, #:lo12:.LANCHOR81]
	mov	w0, 6
	smaddl	x0, w19, w0, x1
	strh	w5, [x0, 4]
	adrp	x0, .LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w19, w0
	beq	.L752
	adrp	x0, .LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w19, w0
	beq	.L752
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w19, w0
	beq	.L752
	adrp	x0, .LANCHOR83
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	ldrh	w0, [x0, w19, sxtw 1]
	cbnz	w0, .L753
	add	w21, w21, 1
	mov	w0, w19
	and	w21, w21, 65535
	bl	INSERT_FREE_LIST
.L752:
	add	w19, w19, 1
	sxth	w19, w19
	b	.L747
.L750:
	adrp	x0, .LANCHOR83
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	strh	w1, [x0, w19, sxtw 1]
	b	.L751
.L753:
	add	w20, w20, 1
	mov	w0, w19
	and	w20, w20, 65535
	bl	INSERT_DATA_LIST
	b	.L752
.L754:
	strh	w20, [x23, #:lo12:.LANCHOR85]
	add	w20, w20, w21
	strh	w21, [x22, #:lo12:.LANCHOR88]
	cmp	w0, w20
	bge	.L756
	mov	w2, 2645
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
.L756:
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
.L768:
	ldrb	w2, [x8, -1]
	mov	w12, w10
	lsl	x21, x10, 5
	mov	x1, x11
	mov	x0, x8
	bl	FlashMemCmp8
	mov	w20, w0
	cbnz	w0, .L766
	add	x0, x7, :lo12:.LANCHOR142
	ubfiz	x12, x12, 5, 32
	add	x21, x0, x21
	add	x0, x0, x12
	adrp	x1, .LANCHOR143
	add	x4, x1, :lo12:.LANCHOR143
	ldrb	w3, [x0, 22]
	mov	x0, 0
.L767:
	lsl	x5, x0, 5
	mov	w2, w0
	ldrb	w5, [x5, x4]
	cmp	w5, w3
	beq	.L770
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L767
	mov	w2, w0
.L770:
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
	b	.L765
.L766:
	add	x10, x10, 1
	add	x8, x8, 32
	cmp	x10, 81
	bne	.L768
	mov	w20, -1
.L765:
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
.L775:
	cmp	w2, w3
	bhi	.L776
	ret
.L776:
	ldr	w4, [x1, x3, lsl 2]
	str	w4, [x0, x3, lsl 2]
	add	x3, x3, 1
	b	.L775
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
	bne	.L778
	cbz	x3, .L779
	tst	x3, 3
	bne	.L780
	mov	w2, 256
	mov	x1, x3
	bl	ftl_memcpy32
.L779:
	cbz	x20, .L777
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
.L777:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L780:
	mov	w2, 1024
	mov	x1, x3
	bl	ftl_memcpy
	b	.L779
.L778:
	cbz	x3, .L783
	tst	x3, 3
	bne	.L784
	mov	x1, x0
	mov	w2, 256
	mov	x0, x3
	bl	ftl_memcpy32
.L783:
	cbz	x20, .L777
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
	b	.L777
.L784:
	mov	x1, x0
	mov	w2, 1024
	mov	x0, x3
	bl	ftl_memcpy
	b	.L783
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
	bne	.L797
	cbnz	x4, .L798
	add	x21, x29, 128
	mov	w2, 64
	mov	w1, 255
	add	x0, x29, 128
	bl	ftl_memset
.L798:
	mov	x5, x21
	mov	x4, x26
	mov	w2, w24
	mov	w1, w20
	mov	w3, 0
	mov	w0, w25
	bl	NandcXferStart
	mov	w0, w25
	bl	NandcXferComp
	cbnz	w20, .L822
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
.L801:
	add	w5, w3, w0
	cmp	x21, x2
	bne	.L802
	adrp	x0, .LANCHOR34
	ldr	w4, [x1, #:lo12:.LANCHOR32]
	lsr	w24, w24, 2
	mov	w2, 0
	ldr	w3, [x0, #:lo12:.LANCHOR34]
	mov	w22, 0
.L803:
	cmp	w2, w24
	bcs	.L799
	cbnz	w4, .L809
.L799:
	str	wzr, [x19, 16]
.L810:
	adrp	x0, .LANCHOR34
	ldr	w0, [x0, #:lo12:.LANCHOR34]
	cmp	w0, 5
	bls	.L796
	cbnz	w20, .L796
	ldr	w0, [x19]
	mov	w1, 8192
	movk	w1, 0x2, lsl 16
	and	w1, w0, w1
	cmp	w1, 139264
	bne	.L796
	orr	w0, w0, 131072
	mov	w22, -1
	str	w0, [x19]
.L796:
	mov	w0, w22
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L802:
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
	b	.L801
.L809:
	uxtw	x0, w2
	add	x0, x0, 8
	ldr	w0, [x19, x0, lsl 2]
	str	w0, [x29, 120]
	ldr	w0, [x29, 120]
	tbnz	x0, 2, .L825
	ldr	w0, [x29, 120]
	tbnz	x0, 15, .L825
	cmp	w3, 5
	bls	.L805
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
	bls	.L806
	ubfx	x1, x0, 3, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 27, 1
.L831:
	orr	w0, w1, w0, lsl 5
.L807:
	cmp	w22, w0
	csel	w22, w22, w0, cs
.L804:
	add	w2, w2, 1
	b	.L803
.L806:
	ubfx	x1, x0, 16, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 29, 1
	b	.L831
.L805:
	cmp	w3, 3
	bls	.L826
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
	bls	.L808
	ubfx	x1, x0, 3, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 28, 1
	b	.L831
.L808:
	ubfx	x1, x0, 16, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 30, 1
	b	.L831
.L826:
	mov	w0, 0
	b	.L807
.L825:
	mov	w22, -1
	b	.L804
.L822:
	mov	w22, 0
	b	.L799
.L797:
	cmp	w20, 1
	bne	.L811
	cmp	x4, 0
	mov	w23, 2
	csel	w23, w23, wzr, ne
	mov	w27, 0
	lsl	w23, w23, 1
	mov	w22, 0
.L812:
	cmp	w22, w24
	bcc	.L814
	mov	w22, 0
	b	.L810
.L814:
	and	w28, w22, 3
	cbz	x26, .L827
	lsl	w3, w22, 9
	add	x3, x26, x3
.L813:
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
	b	.L812
.L827:
	mov	x3, 0
	b	.L813
.L811:
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
.L815:
	cmp	w24, w23
	bls	.L810
	mov	w0, w25
	bl	NandcXferComp
	ldr	w0, [x19, 32]
	add	w27, w23, 2
	str	w0, [x29, 120]
	cmp	w24, w27
	bls	.L816
	mov	x5, 0
	mov	x4, 0
	and	w3, w27, 3
	mov	w2, 2
	mov	w1, 0
	mov	w0, w25
	bl	NandcXferStart
.L816:
	ldr	w0, [x29, 120]
	tbnz	x0, 2, .L828
	ldr	w0, [x29, 120]
	ubfx	x1, x0, 3, 5
	ldr	w0, [x29, 120]
	ubfx	x0, x0, 27, 1
	orr	w0, w1, w0, lsl 5
	cmp	w22, w0
	csel	w22, w22, w0, cs
.L817:
	and	w2, w23, 3
	cbz	x26, .L829
	lsl	w3, w23, 9
	add	x3, x26, x3
.L818:
	add	x4, x21, x28, uxtw
	mov	x0, x19
	mov	w1, 0
	bl	NandcCopy1KB
	ldr	w0, [x29, 108]
	mov	w23, w27
	add	w28, w28, w0
	b	.L815
.L828:
	mov	w22, -1
	b	.L817
.L829:
	mov	x3, 0
	b	.L818
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
	bne	.L833
	adrp	x0, .LANCHOR2
	adrp	x1, .LANCHOR3
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	ldr	w1, [x1, #:lo12:.LANCHOR3]
	mul	w0, w0, w1
	cmp	w0, w21
	mov	w0, 4
	csel	w20, w20, w0, ls
.L833:
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
	cbz	w4, .L849
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
	bne	.L838
.L847:
	mov	w21, -1
.L835:
	mov	w0, w21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L838:
	mov	w1, w25
	mov	w2, w21
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
	adrp	x1, .LANCHOR144
	ldr	w0, [x1, #:lo12:.LANCHOR144]
	add	w0, w0, 1
	cmp	w0, 2047
	bhi	.L840
	str	w0, [x1, #:lo12:.LANCHOR144]
	b	.L835
.L840:
	str	wzr, [x1, #:lo12:.LANCHOR144]
	mov	x28, 0
	mov	x23, 0
.L837:
	mov	w5, 0
	mov	w20, 0
	mov	w6, 0
	mov	w19, 0
	mov	w27, -1
.L845:
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
	bhi	.L841
	cmp	w0, 2
	bhi	.L851
	add	w19, w19, 1
	cmp	w19, 9
	bls	.L851
	mov	w1, w20
	mov	w21, w0
	sub	w20, w22, w19
	mov	w27, 0
.L843:
	cmp	w19, w6
	csel	w20, w20, w1, hi
.L844:
	cbz	w20, .L846
	mov	w1, w20
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	printf
	mov	w0, w20
	bl	NandcSetDdrPara
.L846:
	cbz	w27, .L835
	adrp	x0, .LC11
	mov	w2, w25
	mov	w1, w24
	add	x0, x0, :lo12:.LC11
	bl	printf
	cbz	w26, .L847
	ldr	w1, [x29, 108]
	lsr	w0, w1, 8
	bl	NandcSetDdrPara
	b	.L835
.L849:
	mov	w21, 1024
	b	.L837
.L841:
	cmp	w19, w6
	bls	.L852
	sub	w20, w5, w19
	cmp	w19, 7
	bhi	.L844
	mov	w6, w19
.L852:
	mov	w19, 0
	b	.L842
.L851:
	mov	w5, w22
	mov	w21, w0
	mov	w27, 0
	mov	x28, 0
	mov	x23, 0
.L842:
	add	w22, w22, 2
	cmp	w22, 69
	bls	.L845
	mov	w1, w20
	mov	w20, w5
	b	.L843
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
	bne	.L862
	adrp	x24, .LANCHOR5
	ldrb	w25, [x24, #:lo12:.LANCHOR5]
	cbnz	w25, .L863
.L865:
	adrp	x0, .LANCHOR30
	ldrb	w0, [x0, #:lo12:.LANCHOR30]
	cbz	w0, .L862
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
	beq	.L866
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	cmp	w19, w0, lsr 1
	bls	.L862
.L866:
	lsr	w0, w24, 8
	bl	NandcSetDdrPara
	b	.L862
.L863:
	strb	wzr, [x24, #:lo12:.LANCHOR5]
	mov	x3, x23
	mov	x2, x22
	mov	w1, w21
	mov	w0, w20
	bl	FlashReadRawPage
	strb	w25, [x24, #:lo12:.LANCHOR5]
	cmn	w0, #1
	beq	.L865
	mov	w19, w0
.L862:
	adrp	x24, .LANCHOR145
	ldr	x4, [x24, #:lo12:.LANCHOR145]
	cbz	x4, .L861
	cmn	w19, #1
	bne	.L861
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
	bne	.L861
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L861
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
.L861:
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
	beq	.L882
	cmn	w22, #1
	bne	.L883
.L882:
	ldrb	w0, [x19, #:lo12:.LANCHOR24]
	tbz	x0, 0, .L883
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
	strb	wzr, [x20, #:lo12:.LANCHOR30]
.L884:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L883:
	mov	w0, 1
	strb	w0, [x20, #:lo12:.LANCHOR30]
	b	.L884
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
	adrp	x21, .LANCHOR3
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
	ldr	w0, [x21, #:lo12:.LANCHOR3]
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
.L893:
	add	w28, w19, 1
	mov	x27, 0
.L895:
	add	x0, x29, 120
	ldrb	w0, [x0, x27]
	bl	FlashBchSel
	ldr	x2, [x22, #:lo12:.LANCHOR147]
	mov	x3, 0
	mov	w1, w19
	mov	w0, 0
	bl	FlashReadRawPage
	cmn	w0, #1
	bne	.L894
	ldr	x2, [x22, #:lo12:.LANCHOR147]
	mov	x3, 0
	mov	w1, w28
	mov	w0, 0
	bl	FlashReadRawPage
	cmn	w0, #1
	bne	.L894
	add	x27, x27, 1
	cmp	x27, 4
	bne	.L895
.L896:
	ldr	w0, [x29, 108]
	subs	w26, w26, #1
	add	w19, w19, w0
	bne	.L893
	b	.L901
.L897:
	mov	w1, 2036
	add	x0, x6, 12
	bl	js_hash
	ldr	w1, [x6, 8]
	cmp	w1, w0
	bne	.L903
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
	ldr	w0, [x21, #:lo12:.LANCHOR3]
	adrp	x2, .LANCHOR149
	udiv	w0, w19, w0
	add	w0, w0, 1
	cmp	w0, 1
	bls	.L899
.L906:
	str	w0, [x2, #:lo12:.LANCHOR149]
	adrp	x0, .LANCHOR150
	ldrh	w1, [x1, 14]
	mov	w23, 0
	strb	w1, [x0, #:lo12:.LANCHOR150]
	b	.L896
.L899:
	mov	w0, 2
	b	.L906
.L903:
	mov	w23, -1
	b	.L896
.L894:
	ldr	x6, [x20, #:lo12:.LANCHOR146]
	mov	w1, 20036
	movk	w1, 0x4e41, lsl 16
	ldr	w0, [x6]
	cmp	w0, w1
	bne	.L896
	cbnz	w23, .L897
	ldr	w0, [x21, #:lo12:.LANCHOR3]
	udiv	w19, w19, w0
	adrp	x0, .LANCHOR149
	add	w19, w19, 1
	str	w19, [x0, #:lo12:.LANCHOR149]
.L901:
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
	bls	.L924
	adrp	x0, .LANCHOR30
	ldrb	w0, [x0, #:lo12:.LANCHOR30]
	cbz	w0, .L925
	mov	w23, 1
	mov	w0, 0
	bl	NandcSetDdrMode
.L909:
	add	x0, x22, x27, lsl 8
	mov	w1, 92
	str	w1, [x0, 2056]
	mov	w1, 197
	str	w1, [x0, 2056]
.L908:
	ldrsw	x0, [x29, 124]
	mov	w20, 1
	mov	w24, -1
	add	x0, x0, 8
	add	x0, x22, x0, lsl 8
	str	x0, [x29, 104]
.L910:
	adrp	x0, .LANCHOR151
	ldrb	w0, [x0, #:lo12:.LANCHOR151]
	add	w0, w0, 1
	cmp	w20, w0
	bcc	.L919
	mov	w28, w24
.L918:
	ldr	x0, [x29, 112]
	mov	w1, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR10]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x19
	bhi	.L920
	bl	SandiskSetRRPara
.L921:
	ldrsw	x0, [x29, 124]
	add	x0, x0, 8
	add	x22, x22, x0, lsl 8
	mov	w0, 255
	str	w0, [x22, 8]
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L922
	cmn	w28, #1
	mov	w0, 256
	csel	w28, w28, w0, eq
.L922:
	mov	w0, w21
	bl	NandcWaitFlashReady
	cbz	w23, .L907
	mov	w0, 4
	bl	NandcSetDdrMode
.L907:
	mov	w0, w28
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L925:
	mov	w23, 0
	b	.L909
.L924:
	mov	w23, 0
	b	.L908
.L919:
	ldr	x0, [x29, 112]
	mov	w1, w20
	ldrb	w0, [x0, #:lo12:.LANCHOR10]
	sub	w0, w0, #67
	and	w0, w0, 255
	cmp	w0, 1
	mov	x0, x19
	bhi	.L911
	bl	SandiskSetRRPara
.L912:
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, #:lo12:.LANCHOR10]
	cmp	w0, 34
	bne	.L913
	adrp	x0, .LANCHOR151
	ldrb	w0, [x0, #:lo12:.LANCHOR151]
	sub	w0, w0, #3
	cmp	w20, w0
	bne	.L913
	ldr	x1, [x29, 104]
	mov	w0, 179
	str	w0, [x1, 8]
.L913:
	add	x0, x22, x27, lsl 8
	mov	w1, 38
	str	w1, [x0, 2056]
	mov	w1, 93
	str	w1, [x0, 2056]
	cbz	w23, .L914
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
.L915:
	cmn	w28, #1
	beq	.L916
	adrp	x0, .LANCHOR33
	cmn	w24, #1
	csel	w24, w24, w28, ne
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bcc	.L918
	mov	x26, 0
	mov	x25, 0
.L916:
	add	w20, w20, 1
	b	.L910
.L911:
	bl	ToshibaSetRRPara
	b	.L912
.L914:
	ldr	w1, [x29, 120]
	mov	x3, x26
	mov	x2, x25
	mov	w0, w21
	bl	FlashReadRawPage
	mov	w28, w0
	b	.L915
.L920:
	bl	ToshibaSetRRPara
	b	.L921
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
.L936:
	ldrb	w0, [x26]
	add	w0, w0, 1
	cmp	w21, w0
	bcc	.L940
.L939:
	mov	x0, x20
	mov	w1, 0
	bl	SamsungSetRRPara
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w19, w0, lsr 2
	bcc	.L935
	cmn	w19, #1
	mov	w0, 256
	csel	w19, w19, w0, eq
.L935:
	mov	w0, w19
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L940:
	mov	w1, w21
	mov	x0, x20
	bl	SamsungSetRRPara
	mov	x3, x25
	mov	x2, x24
	mov	w1, w23
	mov	w0, w22
	bl	FlashReadRawPage
	cmn	w0, #1
	beq	.L937
	ldrb	w1, [x27]
	cmn	w19, #1
	csel	w19, w19, w0, ne
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L942
	mov	x25, 0
	mov	x24, 0
.L937:
	add	w21, w21, 1
	b	.L936
.L942:
	mov	w19, w0
	b	.L939
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
	cbnz	w1, .L950
	add	w19, w19, w19, lsl 1
	asr	w19, w19, 2
.L951:
	adrp	x21, .LANCHOR6
	add	x21, x21, :lo12:.LANCHOR6
	add	x21, x21, x20, sxtw 4
	mov	w23, 0
	mov	w28, 137
.L961:
	mov	w0, w20
	bl	NandcWaitFlashReady
	ldrb	w4, [x21, 8]
	adrp	x7, .LANCHOR151
	ldr	x8, [x21]
	add	x7, x7, :lo12:.LANCHOR151
	mov	w22, 0
	mov	w26, -1
	add	x27, x8, x4, lsl 8
.L952:
	ldrb	w0, [x7]
	cmp	w22, w0
	bcc	.L956
.L955:
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
	bcc	.L957
	cmn	w26, #1
	mov	w0, 256
	csel	w26, w26, w0, eq
.L957:
	cmp	w26, 256
	ccmn	w26, #1, 4, ne
	bne	.L958
	ldr	w2, [x29, 140]
	adrp	x0, .LC13
	mov	w4, w26
	mov	w3, w22
	mov	w1, w22
	add	x0, x0, :lo12:.LC13
	bl	printf
	cbnz	w23, .L959
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L949
	cmn	w26, #1
	bne	.L949
	mov	w1, 3
	mov	w0, w20
	mov	w23, 1
	bl	micron_auto_read_calibration_config
	b	.L961
.L950:
	mov	w0, 3
	sdiv	w19, w19, w0
	b	.L951
.L956:
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
	beq	.L953
	cmn	w26, #1
	csel	w26, w26, w0, ne
	cmp	w0, w19
	bcc	.L963
	mov	x25, 0
	mov	x24, 0
.L953:
	mov	w22, w10
	b	.L952
.L963:
	mov	w26, w0
	mov	x25, 0
	mov	x24, 0
	b	.L955
.L959:
	mov	w0, w20
	mov	w1, 0
	bl	micron_auto_read_calibration_config
	cmn	w26, #1
	mov	w0, 256
	csel	w26, w26, w0, eq
.L949:
	mov	w0, w26
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L958:
	cbz	w23, .L949
	mov	w1, 0
	mov	w0, w20
	mov	w26, 256
	bl	micron_auto_read_calibration_config
	b	.L949
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
	bhi	.L975
	ldrb	w26, [x1, 20]
.L975:
	mov	w0, w20
	bl	NandcWaitFlashReady
	add	x6, x19, :lo12:.LANCHOR20
	adrp	x5, .LANCHOR33
	add	x7, x6, 4
	add	x5, x5, :lo12:.LANCHOR33
	mov	w4, 0
	mov	w27, -1
.L976:
	cmp	w4, w21
	bcc	.L981
.L980:
	ldr	x0, [x25, #:lo12:.LANCHOR18]
	add	x19, x19, :lo12:.LANCHOR20
	add	x19, x19, x28
	ldrb	w0, [x0, 19]
	sub	w0, w0, #7
	and	w0, w0, 255
	cmp	w0, 1
	bhi	.L982
	strb	w26, [x19, 20]
.L983:
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w27, w0, lsr 2
	bcc	.L974
	cmn	w27, #1
	mov	w0, 256
	csel	w27, w27, w0, eq
.L974:
	mov	w0, w27
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L981:
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
	beq	.L978
	ldrb	w1, [x5]
	cmn	w27, #1
	csel	w27, w27, w0, ne
	add	w1, w1, w1, lsl 1
	cmp	w0, w1, lsr 2
	bcc	.L985
	mov	x24, 0
	mov	x23, 0
.L978:
	add	w4, w4, 1
	b	.L976
.L985:
	mov	w27, w0
	b	.L980
.L982:
	strb	w26, [x19, 12]
	b	.L983
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
	bne	.L993
	adrp	x0, .LANCHOR2
	adrp	x1, .LANCHOR3
	ldrb	w0, [x0, #:lo12:.LANCHOR2]
	ldr	w1, [x1, #:lo12:.LANCHOR3]
	mul	w0, w0, w1
	cmp	w0, w20
	bls	.L993
	adrp	x0, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR1]
	cbnz	w0, .L994
	sub	w21, w21, #2
.L993:
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
.L994:
	mov	w21, 4
	b	.L993
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
	bl	js_hash
	str	w0, [x6, 8]
	mov	w0, 1592
	str	w0, [x6, 4]
	ldr	x0, [x24, #:lo12:.LANCHOR153]
	str	x0, [x19, #:lo12:.LANCHOR146]
	mov	w0, 0
	bl	flash_enter_slc_mode
.L999:
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
	beq	.L997
	ldr	x6, [x19, #:lo12:.LANCHOR146]
	ldr	w0, [x6]
	cmp	w0, w25
	bne	.L997
	mov	w1, 2036
	add	x0, x6, 12
	bl	js_hash
	ldr	w1, [x6, 8]
	cmp	w1, w0
	bne	.L997
	ldr	w0, [x21]
	cmp	w23, 1
	str	w7, [x26]
	mul	w20, w0, w20
	adrp	x0, .LANCHOR148
	str	w20, [x0, #:lo12:.LANCHOR148]
	beq	.L1000
	mov	w23, 1
.L997:
	mov	w20, w7
	cmp	w7, 4
	bne	.L999
.L998:
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
.L1000:
	mov	w23, 2
	b	.L998
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
	cbz	w1, .L1007
	mov	w0, 0
	bl	flash_enter_slc_mode
.L1007:
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
.L1008:
	ldrb	w0, [x24, #:lo12:.LANCHOR2]
	cmp	w19, w0
	bcc	.L1013
.L1012:
	mov	w0, w26
	bl	FlashBchSel
	ldr	x0, [x29, 120]
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	cbz	w0, .L1006
	mov	w0, 0
	bl	flash_exit_slc_mode
.L1006:
	mov	w0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1013:
	mov	x4, 0
	adrp	x25, .LANCHOR147
.L1010:
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
	bne	.L1009
	ldr	x4, [x29, 104]
	add	x4, x4, 1
	cmp	x4, 4
	bne	.L1010
.L1011:
	add	w19, w19, 1
	b	.L1008
.L1016:
	mov	w20, 0
	b	.L1012
.L1009:
	ldr	x0, [x21]
	ldr	w1, [x0]
	mov	w0, 35899
	movk	w0, 0xfcdc, lsl 16
	cmp	w1, w0
	bne	.L1011
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
	bcs	.L1016
	str	w19, [x0, #:lo12:.LANCHOR149]
	mov	w20, 0
	bl	FlashSavePhyInfo
	b	.L1011
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
	cbz	w0, .L1026
	adrp	x0, .LANCHOR29
	ldr	w0, [x0, #:lo12:.LANCHOR29]
	cbnz	w0, .L1025
.L1026:
	adrp	x2, .LANCHOR18
	mov	x25, x2
	ldr	x0, [x2, #:lo12:.LANCHOR18]
	ldrb	w23, [x0, 19]
	sub	w0, w23, #5
	and	w3, w0, 255
	cmp	w3, 63
	bhi	.L1025
	mov	x2, 16399
	movk	x2, 0x4000, lsl 16
	movk	x2, 0x8000, lsl 48
	lsr	x0, x2, x3
	tbz	x0, 0, .L1025
	adrp	x20, .LANCHOR120
	mov	w22, w1
	add	x20, x20, :lo12:.LANCHOR120
	mov	w26, 65535
	adrp	x21, .LANCHOR153
.L1028:
	ldr	x0, [x25, #:lo12:.LANCHOR18]
	ldrh	w0, [x0, 10]
	cmp	w0, w19
	bhi	.L1031
.L1025:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1031:
	ldrh	w0, [x20, w19, sxtw 1]
	cmp	w0, w26
	bne	.L1025
	mov	w2, 32768
	cmp	w23, 8
	bne	.L1029
	mov	w1, 0
.L1036:
	ldr	x0, [x21, #:lo12:.LANCHOR153]
	bl	ftl_memset
	ldr	x3, [x21, #:lo12:.LANCHOR153]
	add	w1, w19, w22
	add	w19, w19, 1
	mov	w0, w24
	mov	x2, x3
	and	w19, w19, 65535
	bl	FlashProgPage
	b	.L1028
.L1029:
	mov	w1, 255
	b	.L1036
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
	bls	.L1038
	cmp	w1, 575
	bhi	.L1039
	adrp	x0, .LANCHOR154
	mov	x1, x2
	mov	w2, 1
	cmp	w4, 64
	str	w2, [x0, #:lo12:.LANCHOR154]
	adrp	x0, idb_buf
	bhi	.L1040
	mov	w2, 64
	sub	w4, w2, w4
	sub	w2, w3, w4
	ubfiz	x4, x4, 9, 25
	lsl	w2, w2, 9
	add	x1, x1, x4
	add	x0, x0, :lo12:idb_buf
.L1090:
	bl	ftl_memcpy
.L1073:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	ret
.L1040:
	mov	w2, 576
	sub	w2, w2, w4
	cmp	w3, w2
	sub	w4, w4, #64
	csel	w2, w3, w2, ls
	ubfiz	x4, x4, 9, 25
	add	x0, x0, :lo12:idb_buf
	lsl	w2, w2, 9
	add	x0, x0, x4
	b	.L1090
.L1038:
	cmp	w1, 575
	bls	.L1073
.L1039:
	adrp	x0, .LANCHOR154
	str	x0, [x29, 104]
	ldr	w1, [x0, #:lo12:.LANCHOR154]
	cbz	w1, .L1073
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
.L1044:
	ldr	w4, [x1]
	cbnz	w4, .L1042
	ldr	w4, [x5, w0, uxtw 2]
	add	w0, w0, 1
	str	w4, [x1], -4
	cmp	w0, w3
	sub	w2, w2, #1
	csel	w0, w0, wzr, cc
	cmp	w2, 4096
	bne	.L1044
.L1042:
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
.L1045:
	cmp	w24, 15
	bls	.L1063
	cbnz	w23, .L1065
	adrp	x0, .LC17
	mov	w1, 0
	add	x0, x0, :lo12:.LC17
	bl	printf
.L1065:
	ldr	x0, [x29, 104]
	str	wzr, [x0, #:lo12:.LANCHOR154]
	b	.L1073
.L1063:
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
	bhi	.L1046
	add	w0, w26, w19
	bl	FW_FlashBlockErase.constprop.41
.L1046:
	udiv	w4, w19, w26
	adrp	x5, .LANCHOR15
	add	x5, x5, :lo12:.LANCHOR15
	mov	x28, 0
	msub	w4, w4, w26, w19
	sub	w26, w19, w4
.L1047:
	add	x2, x25, :lo12:idb_buf
	cmp	x28, 128
	add	x2, x2, x28, lsl 11
	bne	.L1051
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
.L1052:
	cmp	w26, 511
	bhi	.L1059
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
	cbz	w3, .L1053
	adrp	x3, .LANCHOR119
	mov	w4, 12336
	movk	w4, 0x5638, lsl 16
	ldr	w3, [x3, #:lo12:.LANCHOR119]
	cmp	w3, w4
	csel	w2, w2, w1, ne
.L1053:
	ldr	w1, [x29, 120]
	add	w0, w0, w1
	adrp	x1, .LANCHOR3
	ldr	w1, [x1, #:lo12:.LANCHOR3]
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
	bcs	.L1054
	adrp	x0, .LANCHOR152
	ldrb	w0, [x0, #:lo12:.LANCHOR152]
	bl	FlashBchSel
.L1054:
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
	bne	.L1055
	adrp	x0, .LANCHOR152
	ldrb	w0, [x0, #:lo12:.LANCHOR152]
	cmp	w0, 40
	beq	.L1055
	mov	w0, 40
	bl	FlashBchSel
	ldr	w1, [x29, 168]
	add	x3, x29, 176
	mov	x2, x27
	mov	w0, 0
	bl	FlashReadPage
	mov	w1, w0
.L1055:
	str	w1, [x29, 168]
	mov	w0, 0
	bl	flash_boot_exit_slc_mode
	ldrb	w0, [x29, 112]
	bl	FlashBchSel
	ldr	w1, [x29, 168]
	cmn	w1, #1
	bne	.L1056
.L1059:
	ldr	x0, [x29, 128]
	add	x1, x25, :lo12:idb_buf
	mov	x22, 0
	add	x26, x0, :lo12:gp_flash_check_buf
.L1057:
	lsl	x0, x22, 2
	mov	w27, w22
	add	x28, x0, x1
	ldr	w2, [x0, x26]
	ldr	w0, [x0, x1]
	cmp	w2, w0
	beq	.L1060
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
	bls	.L1061
	add	w0, w20, w19
	bl	FW_FlashBlockErase.constprop.41
.L1061:
	ldr	w0, [x29, 172]
	add	w24, w24, w0
	ldr	w0, [x29, 136]
	add	w19, w19, w0
	b	.L1045
.L1051:
	add	w1, w4, w28, lsl 2
	lsr	w1, w1, 2
	cbz	w1, .L1048
	ldr	x0, [x29, 160]
	add	w3, w1, 1
	ldrb	w6, [x5]
	ldrh	w0, [x0, w3, sxtw 1]
	cbz	w6, .L1049
	adrp	x6, .LANCHOR119
	mov	w7, 12336
	movk	w7, 0x5638, lsl 16
	ldr	w6, [x6, #:lo12:.LANCHOR119]
	cmp	w6, w7
	csel	w0, w0, w3, ne
.L1049:
	lsl	w0, w0, 2
	sub	w0, w0, #4
	str	w0, [x29, 176]
.L1048:
	mov	w0, 61424
	str	w0, [x29, 180]
	ldr	x0, [x29, 160]
	ldrh	w27, [x0, w1, sxtw 1]
	ldrb	w0, [x5]
	cbz	w0, .L1050
	adrp	x0, .LANCHOR119
	mov	w3, 12336
	movk	w3, 0x5638, lsl 16
	ldr	w0, [x0, #:lo12:.LANCHOR119]
	cmp	w0, w3
	csel	w27, w27, w1, ne
.L1050:
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
	b	.L1047
.L1056:
	ldr	x0, [x29, 144]
	ubfiz	x0, x0, 9, 16
	add	x27, x27, x0
	ldr	w0, [x29, 144]
	add	w26, w0, w26
	mov	w0, 0
	and	w26, w26, 65535
	b	.L1052
.L1060:
	add	x22, x22, 1
	cmp	x22, 65536
	bne	.L1057
	add	w23, w23, 1
	cmp	w23, 5
	bls	.L1061
	b	.L1065
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
	adrp	x4, .LANCHOR119
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
	str	w2, [x4, #:lo12:.LANCHOR119]
	cmp	w2, 2049
	bne	.L1095
	mov	w2, 8
	str	w2, [x3, #:lo12:.LANCHOR34]
.L1095:
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
	adrp	x1, .LANCHOR0
	str	x0, [x1, #:lo12:.LANCHOR0]
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
.L1098:
	cmp	w0, w7
	bcc	.L1099
	mov	w2, 8
	sub	w2, w2, w0
	add	x2, x2, 1
	add	x1, x1, :lo12:.LANCHOR74
	mov	x3, 0
.L1100:
	add	x3, x3, 1
	cmp	x2, x3
	bne	.L1101
	mov	w0, 0
	ldr	x23, [sp, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
.L1099:
	ldr	x4, [x2, 32]
	add	w0, w0, 1
	add	x4, x4, x3, uxtw 2
	add	w3, w3, w5
	str	x4, [x6], 8
	b	.L1098
.L1101:
	add	x4, x0, x3
	add	x4, x1, x4, lsl 3
	str	xzr, [x4, 24]
	b	.L1100
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
.L1111:
	cmp	x25, x19
	bne	.L1117
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
.L1117:
	cbnz	w20, .L1112
	mov	w2, w19
	mov	x1, x26
	mov	x0, x23
	bl	printf
.L1112:
	cmp	w24, 4
	bne	.L1113
	ldr	w1, [x22, x19, lsl 2]
.L1119:
	mov	x0, x21
	add	w20, w20, 1
	bl	printf
	cmp	w20, 15
	bls	.L1116
	mov	w20, 0
	add	x1, x27, :lo12:.LC20
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1116:
	add	x19, x19, 1
	b	.L1111
.L1113:
	cmp	w24, 2
	bne	.L1115
	ldrsh	w1, [x22, x19, lsl 1]
	b	.L1119
.L1115:
	ldrb	w1, [x22, x19]
	b	.L1119
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
	bne	.L1121
	mov	w1, -89
	strb	w1, [x0, 4]
	adrp	x0, .LANCHOR196+17
	mov	w1, -9
	strb	w1, [x0, #:lo12:.LANCHOR196+17]
.L1186:
	mov	w27, 7
	b	.L1230
.L1121:
	cmp	w26, 3
	bne	.L1123
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
.L1229:
	mov	w27, 8
	mov	w28, w27
	strb	w1, [x0, 11]
.L1122:
	sub	w0, w26, #1
	cmp	w0, 1
	bhi	.L1128
	adrp	x26, .LANCHOR25
	adrp	x0, .LANCHOR26
	adrp	x25, .LANCHOR6
	add	x26, x26, :lo12:.LANCHOR25
	add	x4, x0, :lo12:.LANCHOR26
	add	x25, x25, :lo12:.LANCHOR6
	mov	w24, 0
.L1129:
	ldrb	w0, [x26]
	cmp	w0, w24
	bhi	.L1135
.L1136:
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
.L1123:
	cmp	w26, 4
	bne	.L1124
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
	b	.L1229
.L1124:
	cmp	w26, 5
	bne	.L1125
	mov	w1, 56
	strb	w1, [x0, 4]
	mov	w1, 57
	strb	w1, [x0, 5]
	mov	w1, 58
	mov	w27, 8
	strb	w1, [x0, 6]
	mov	w1, 59
	strb	w1, [x0, 7]
.L1230:
	mov	w28, 4
	b	.L1122
.L1125:
	cmp	w26, 6
	bne	.L1126
	mov	w1, 14
	strb	w1, [x0, 4]
	mov	w1, 15
	strb	w1, [x0, 5]
	mov	w1, 16
	mov	w27, 12
	strb	w1, [x0, 6]
	mov	w1, 17
	strb	w1, [x0, 7]
	b	.L1230
.L1126:
	cmp	w26, 7
	bne	.L1127
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
	b	.L1122
.L1127:
	cmp	w26, 8
	bne	.L1186
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
	b	.L1122
.L1135:
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
.L1130:
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
	bhi	.L1130
	adrp	x2, .LANCHOR196
	add	x2, x2, :lo12:.LANCHOR196
	mov	x0, 0
.L1133:
	add	x7, x19, x0
	add	x6, x2, x0
	mov	x1, 1
.L1132:
	lsl	x3, x1, 2
	lsl	x8, x1, 3
	ldrb	w10, [x19, x0]
	add	x1, x1, 1
	cmp	x1, 7
	ldrb	w3, [x6, x3]
	add	w3, w3, w10
	strb	w3, [x7, x8]
	bne	.L1132
	add	x0, x0, 1
	cmp	x0, 4
	bne	.L1133
	add	w24, w24, 1
	strb	wzr, [x19, 16]
	strb	wzr, [x19, 24]
	and	w24, w24, 255
	strb	wzr, [x19, 32]
	strb	wzr, [x19, 40]
	strb	wzr, [x19, 48]
	strb	wzr, [x19, 41]
	strb	wzr, [x19, 49]
	b	.L1129
.L1128:
	sub	w0, w26, #3
	cmp	w0, 5
	bhi	.L1136
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
.L1137:
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	cmp	w0, w21
	bls	.L1136
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
	cmp	w26, 7
	bne	.L1138
	mov	x1, 28
	mov	w0, 160
	add	x3, x20, :lo12:.LANCHOR20
	umaddl	x0, w0, w22, x1
.L1231:
	add	x3, x3, x0
	mov	w0, 54
	str	w0, [x19, 2056]
	cmp	w26, 4
	bne	.L1141
	mov	w0, 255
	str	w0, [x19, 2052]
	mov	w0, 64
	str	w0, [x19, 2048]
	mov	w0, 204
.L1232:
	str	w0, [x19, 2052]
	mov	w0, 77
	b	.L1233
.L1138:
	cmp	w26, 8
	beq	.L1140
	ubfiz	x0, x22, 6, 8
	add	x3, x20, :lo12:.LANCHOR20
	add	x0, x0, 20
	b	.L1231
.L1141:
	cmp	w25, 1
	bhi	.L1143
	add	x0, x20, :lo12:.LANCHOR20
	ldrb	w0, [x0, 4]
	str	w0, [x19, 2052]
	mov	w0, 82
.L1233:
	str	w0, [x19, 2048]
.L1142:
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
	bne	.L1144
	mov	w0, 31
	str	w0, [x19, 2052]
.L1145:
	mov	w0, 2
	str	w0, [x19, 2052]
	str	wzr, [x19, 2052]
.L1185:
	mov	w0, 48
	str	w0, [x19, 2056]
	str	x3, [x29, 104]
	mov	w0, w22
	bl	NandcWaitFlashReady
	cmp	w25, 1
	ldr	x3, [x29, 104]
	ccmp	w26, 8, 4, hi
	beq	.L1187
	cmp	w26, 7
	mov	w0, 2
	mov	w1, 32
	csel	w1, w1, w0, eq
.L1146:
	adrp	x8, .LANCHOR147
	mov	x7, 0
	ldr	x0, [x8, #:lo12:.LANCHOR147]
.L1147:
	ldr	w10, [x19, 2048]
	strb	w10, [x0, x7]
	add	x7, x7, 1
	cmp	w1, w7, uxtb
	bhi	.L1147
	cmp	w26, 8
	bne	.L1148
	mov	w1, 0
.L1150:
	ldrb	w7, [x0]
	cmp	w7, 50
	beq	.L1149
	ldrb	w7, [x0, 1]
	cmp	w7, 5
	beq	.L1149
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1150
.L1151:
	adrp	x0, .LC21
	mov	w1, 0
	add	x0, x0, :lo12:.LC21
	bl	printf
.L1153:
	b	.L1153
.L1143:
	cmp	w26, 7
	bne	.L1142
	mov	w0, 174
	str	w0, [x19, 2052]
	str	wzr, [x19, 2048]
	mov	w0, 176
	b	.L1232
.L1144:
	str	wzr, [x19, 2052]
	b	.L1145
.L1187:
	mov	w1, 16
	b	.L1146
.L1149:
	cmp	w1, 6
	bhi	.L1151
.L1152:
	ldr	x7, [x8, #:lo12:.LANCHOR147]
	mov	x0, 0
.L1162:
	ldr	w1, [x29, 128]
	cmp	w1, w0
	bgt	.L1163
	ldr	x1, [x8, #:lo12:.LANCHOR147]
	mov	w10, 8
	add	x8, x1, x24
.L1165:
	mov	x0, 0
.L1164:
	ldrh	w11, [x8, x0, lsl 1]
	mvn	w11, w11
	strh	w11, [x8, x0, lsl 1]
	add	x0, x0, 1
	cmp	w23, w0
	bgt	.L1164
	ldr	w0, [x29, 140]
	subs	w10, w10, #1
	add	x8, x8, x0, uxtw 1
	bne	.L1165
	mov	x10, x1
	mov	w11, 0
	mov	w16, 1
.L1171:
	mov	w0, 0
	mov	w8, 0
.L1170:
	mov	x14, x10
	lsl	w15, w16, w8
	mov	w13, 16
	mov	w12, 0
.L1168:
	ldrh	w17, [x14]
	add	x14, x14, x24
	bics	wzr, w15, w17
	cinc	w12, w12, eq
	subs	w13, w13, #1
	bne	.L1168
	cmp	w12, 8
	bls	.L1169
	orr	w0, w0, w15
	and	w0, w0, 65535
.L1169:
	add	w8, w8, 1
	cmp	w8, 16
	bne	.L1170
	strh	w0, [x10], 2
	add	w11, w11, 1
	cmp	w23, w11
	bgt	.L1171
	mov	x0, 0
	mov	w8, 0
.L1174:
	ldr	w10, [x1, x0]
	add	x0, x0, 4
	cmp	w10, 0
	cinc	w8, w8, eq
	cmp	x0, 32
	bne	.L1174
	cmp	w8, 7
	ble	.L1175
	mov	w3, 1024
	mov	w2, 1
	adrp	x0, .LC22
	add	x0, x0, :lo12:.LC22
	bl	rknand_print_hex
	adrp	x0, .LC21
	mov	w1, 0
	add	x0, x0, :lo12:.LC21
	bl	printf
.L1176:
	b	.L1176
.L1148:
	cmp	w26, 7
	bne	.L1154
	mov	w1, 0
.L1156:
	ldrb	w7, [x0]
	cmp	w7, 12
	beq	.L1155
	ldrb	w7, [x0, 1]
	cmp	w7, 10
	beq	.L1155
	add	w1, w1, 1
	add	x0, x0, 4
	and	w1, w1, 255
	cmp	w1, 8
	bne	.L1156
.L1157:
	adrp	x0, .LC21
	mov	w1, 0
	add	x0, x0, :lo12:.LC21
	bl	printf
.L1158:
	b	.L1158
.L1155:
	cmp	w1, 6
	bls	.L1152
	b	.L1157
.L1154:
	cmp	w26, 6
	bne	.L1152
	mov	x1, 0
.L1159:
	ldrb	w7, [x0, x1]
	cmp	w7, 12
	beq	.L1152
	add	x7, x0, x1
	ldrb	w7, [x7, 8]
	cmp	w7, 4
	beq	.L1152
	add	x1, x1, 1
	cmp	x1, 8
	bne	.L1159
	adrp	x0, .LC21
	mov	w1, 0
	add	x0, x0, :lo12:.LC21
	bl	printf
.L1161:
	b	.L1161
.L1163:
	ldr	w1, [x19, 2048]
	strb	w1, [x7, x0]
	add	x0, x0, 1
	b	.L1162
.L1175:
	cmp	w26, 6
	beq	.L1189
	cmp	w26, 7
	beq	.L1190
	cmp	w26, 8
	mov	x1, 8
	mov	x0, 5
	csel	x0, x0, x1, eq
.L1177:
	mov	w8, 0
.L1178:
	mov	x1, 0
.L1179:
	ldrb	w10, [x7, x1]
	strb	w10, [x3, x1]
	add	x1, x1, 1
	cmp	w28, w1, uxtb
	bhi	.L1179
	ldr	x1, [x29, 112]
	add	w8, w8, 1
	add	x3, x3, x0
	cmp	w27, w8
	add	x7, x7, x1
	bgt	.L1178
	mov	w0, 255
	str	w0, [x19, 2056]
	mov	w0, w22
	bl	NandcWaitFlashReady
	cmp	w25, 1
	bhi	.L1181
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
.L1182:
	add	w21, w21, 1
	mov	w0, w22
	and	w21, w21, 255
	bl	NandcWaitFlashReady
	b	.L1137
.L1189:
	mov	x0, 4
	b	.L1177
.L1190:
	mov	x0, 10
	b	.L1177
.L1181:
	cmp	w26, 8
	bne	.L1183
	mov	w0, 190
.L1234:
	str	w0, [x19, 2056]
	b	.L1182
.L1183:
	mov	w0, 56
	b	.L1234
.L1140:
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
	b	.L1185
	.size	HynixGetReadRetryDefault, .-HynixGetReadRetryDefault
	.section	.text.FlashGetReadRetryDefault,"ax",@progbits
	.align	2
	.global	FlashGetReadRetryDefault
	.type	FlashGetReadRetryDefault, %function
FlashGetReadRetryDefault:
	mov	w1, w0
	cbz	w0, .L1235
	sub	w2, w0, #1
	cmp	w2, 7
	bhi	.L1237
	b	HynixGetReadRetryDefault
.L1237:
	cmp	w0, 49
	bne	.L1238
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
.L1247:
	add	x0, x0, 4
	b	ftl_memcpy
.L1238:
	sub	w0, w0, #65
	cmp	w1, 33
	ccmp	w0, 1, 0, ne
	bhi	.L1239
	adrp	x2, .LANCHOR20
	add	x0, x2, :lo12:.LANCHOR20
	strb	w1, [x2, #:lo12:.LANCHOR20]
	mov	w1, 4
.L1248:
	strb	w1, [x0, 1]
	mov	w1, 7
	mov	w2, 45
	strb	w1, [x0, 2]
	adrp	x1, .LANCHOR9
	add	x1, x1, :lo12:.LANCHOR9
	b	.L1247
.L1239:
	cmp	w1, 34
	mov	w0, 67
	ccmp	w1, w0, 4, ne
	bne	.L1240
	adrp	x2, .LANCHOR20
	add	x0, x2, :lo12:.LANCHOR20
	strb	w1, [x2, #:lo12:.LANCHOR20]
	mov	w1, 5
	b	.L1248
.L1240:
	cmp	w1, 35
	mov	w0, 68
	ccmp	w1, w0, 4, ne
	bne	.L1235
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
	b	.L1247
.L1235:
	ret
	.size	FlashGetReadRetryDefault, .-FlashGetReadRetryDefault
	.section	.text.FlashInit,"ax",@progbits
	.align	2
	.global	FlashInit
	.type	FlashInit, %function
FlashInit:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR30
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR2
	stp	x25, x26, [sp, 64]
	adrp	x23, .LANCHOR1
	stp	x27, x28, [sp, 80]
	adrp	x25, .LANCHOR152
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	mov	w0, 32768
	bl	ftl_malloc
	adrp	x1, .LANCHOR147
	adrp	x21, .LANCHOR22
	adrp	x26, .LC23
	mov	w28, 0
	str	x0, [x1, #:lo12:.LANCHOR147]
	mov	w0, 32768
	bl	ftl_malloc
	adrp	x1, .LANCHOR153
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
	strb	wzr, [x22, #:lo12:.LANCHOR30]
	adrp	x1, .LANCHOR199
	strb	wzr, [x23, #:lo12:.LANCHOR1]
	str	x0, [x1, #:lo12:.LANCHOR199]
	adrp	x1, .LANCHOR150
	mov	w0, 50
	strb	w0, [x24, #:lo12:.LANCHOR2]
	strb	w0, [x1, #:lo12:.LANCHOR150]
	adrp	x0, .LANCHOR149
	mov	w1, 128
	str	wzr, [x0, #:lo12:.LANCHOR149]
	adrp	x0, .LANCHOR3
	str	w1, [x0, #:lo12:.LANCHOR3]
	adrp	x0, .LANCHOR144
	str	wzr, [x0, #:lo12:.LANCHOR144]
	mov	w0, 60
	strb	w0, [x25, #:lo12:.LANCHOR152]
	mov	x0, x19
	bl	NandcInit
	add	x19, x21, :lo12:.LANCHOR22
	adrp	x10, .LANCHOR6
	add	x27, x10, :lo12:.LANCHOR6
	add	x0, x26, :lo12:.LC23
	stp	x0, x19, [x29, 112]
.L1254:
	ldrb	w2, [x27, 8]
	and	w1, w28, 255
	mov	w26, w1
	mov	w0, w1
	str	w2, [x29, 108]
	ldr	x20, [x27]
	bl	FlashReset
	mov	w0, w26
	bl	NandcFlashCs
	ldr	w2, [x29, 108]
	mov	w0, 144
	ubfiz	x2, x2, 8, 8
	add	x20, x20, x2
	str	w0, [x20, 2056]
	mov	x0, 200
	str	wzr, [x20, 2052]
	bl	udelay
	ldr	w0, [x20, 2048]
	strb	w0, [x19]
	ldr	w0, [x20, 2048]
	strb	w0, [x19, 1]
	ldr	w0, [x20, 2048]
	strb	w0, [x19, 2]
	ldr	w0, [x20, 2048]
	strb	w0, [x19, 3]
	ldr	w0, [x20, 2048]
	strb	w0, [x19, 4]
	ldr	w0, [x20, 2048]
	strb	w0, [x19, 5]
	mov	w0, w26
	bl	NandcFlashDeCs
	ldrb	w2, [x19]
	sub	w0, w2, #1
	and	w0, w0, 255
	cmp	w0, 253
	bhi	.L1250
	ldrb	w7, [x19, 5]
	add	w1, w28, 1
	ldrb	w6, [x19, 4]
	ldrb	w5, [x19, 3]
	ldrb	w4, [x19, 2]
	ldrb	w3, [x19, 1]
	ldr	x0, [x29, 112]
	bl	printf
.L1250:
	cbnz	w28, .L1251
	ldr	x0, [x29, 120]
	ldrb	w0, [x0]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 253
	bhi	.L1295
	ldr	x0, [x29, 120]
	ldrb	w0, [x0, 1]
	cmp	w0, 255
	beq	.L1295
.L1251:
	ldrb	w0, [x19]
	cmp	w0, 181
	bne	.L1253
	mov	w0, 44
	strb	w0, [x19]
.L1253:
	add	w28, w28, 1
	add	x27, x27, 16
	add	x19, x19, 8
	cmp	w28, 4
	bne	.L1254
	ldrb	w0, [x21, #:lo12:.LANCHOR22]
	cmp	w0, 173
	beq	.L1255
	adrp	x0, .LANCHOR155
	ldr	w0, [x0, #:lo12:.LANCHOR155]
	bl	NandcSetDdrMode
.L1255:
	adrp	x20, .LANCHOR18
	adrp	x28, .LANCHOR5
	adrp	x26, .LANCHOR119
	adrp	x19, .LANCHOR20
	mov	w2, 852
	mov	w1, 0
	add	x0, x19, :lo12:.LANCHOR20
	bl	ftl_memset
	adrp	x3, .LANCHOR31
	ldr	w4, [x26, #:lo12:.LANCHOR119]
	add	x0, x3, :lo12:.LANCHOR31
	strb	wzr, [x28, #:lo12:.LANCHOR5]
	str	x0, [x20, #:lo12:.LANCHOR18]
	mov	w0, 12336
	movk	w0, 0x5638, lsl 16
	cmp	w4, w0
	bne	.L1256
	adrp	x0, .LANCHOR29
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR29]
.L1256:
	add	x0, x21, :lo12:.LANCHOR22
	ldrb	w1, [x0, 1]
	add	w0, w1, 95
	and	w2, w0, 255
	mov	x0, 1
	cmp	w2, 57
	bhi	.L1257
	movk	x0, 0x205, lsl 48
	lsr	x0, x0, x2
	mvn	x0, x0
.L1257:
	cmp	w1, 241
	and	w0, w0, 1
	cset	w2, eq
	eor	w0, w0, 1
	orr	w0, w2, w0
	cbnz	w0, .L1258
	cmp	w1, 220
	bne	.L1259
	add	x0, x21, :lo12:.LANCHOR22
	ldrb	w0, [x0, 3]
	cmp	w0, 149
	bne	.L1259
.L1258:
	mov	w0, 1
	adrp	x27, .LANCHOR200
	add	x2, x27, :lo12:.LANCHOR200
	strb	w0, [x23, #:lo12:.LANCHOR1]
	mov	w0, 16
	strb	w0, [x24, #:lo12:.LANCHOR2]
	strb	w0, [x25, #:lo12:.LANCHOR152]
	add	x5, x21, :lo12:.LANCHOR22
	ldrb	w0, [x21, #:lo12:.LANCHOR22]
	strb	w0, [x2, 1]
	strb	w1, [x2, 2]
	cmp	w0, 152
	bne	.L1260
	ldrsb	w0, [x5, 4]
	tbnz	w0, #31, .L1260
	mov	w0, 24
	strb	w0, [x25, #:lo12:.LANCHOR152]
.L1260:
	cmp	w4, 2049
	mov	w0, 12336
	movk	w0, 0x5638, lsl 16
	ccmp	w4, w0, 4, ne
	bne	.L1261
	mov	w0, 16
	strb	w0, [x25, #:lo12:.LANCHOR152]
.L1261:
	cmp	w1, 218
	bne	.L1262
	add	x0, x27, :lo12:.LANCHOR200
	mov	w1, 2048
	strh	w1, [x0, 14]
	mov	w1, -38
.L1329:
	strb	w1, [x0, 2]
.L1263:
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
	add	x1, x27, :lo12:.LANCHOR200
	add	x0, x3, :lo12:.LANCHOR31
	bl	ftl_memcpy
.L1259:
	ldrb	w0, [x23, #:lo12:.LANCHOR1]
	adrp	x27, .LANCHOR15
	cbnz	w0, .L1266
	bl	FlashLoadPhyInfoInRam
	cbnz	w0, .L1268
	ldr	x0, [x20, #:lo12:.LANCHOR18]
	adrp	x25, .LANCHOR24
	ldrb	w1, [x0, 17]
	and	w0, w1, 7
	strb	w0, [x25, #:lo12:.LANCHOR24]
	tbnz	x1, 0, .L1268
	mov	w1, 1
	strb	w1, [x22, #:lo12:.LANCHOR30]
	bl	FlashSetInterfaceMode
	ldrb	w0, [x25, #:lo12:.LANCHOR24]
	bl	NandcSetMode
.L1268:
	ldr	x0, [x20, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 26]
	strb	w0, [x27, #:lo12:.LANCHOR15]
	bl	FlashLoadPhyInfo
	cbz	w0, .L1266
	ldr	x0, [x20, #:lo12:.LANCHOR18]
	ldrh	w1, [x0, 14]
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	bl	printf
	bl	FlashLoadPhyInfoInRam
	cmn	w0, #1
	beq	.L1249
	bl	FlashDieInfoInit
	ldr	x0, [x20, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 19]
	bl	FlashGetReadRetryDefault
	ldr	x0, [x20, #:lo12:.LANCHOR18]
	adrp	x1, .LANCHOR122
	ldrh	w1, [x1, #:lo12:.LANCHOR122]
	ldrb	w2, [x0, 9]
	add	w1, w1, 4095
	cmp	w2, w1, lsr 12
	blt	.L1271
	ldrh	w1, [x0, 14]
	add	w1, w1, 255
	cmp	w2, w1, lsr 8
	bge	.L1272
.L1271:
	ldrh	w1, [x0, 14]
	and	w1, w1, -256
	strh	w1, [x0, 14]
.L1272:
	adrp	x0, .LANCHOR24
	ldrb	w0, [x0, #:lo12:.LANCHOR24]
	tst	w0, 6
	beq	.L1273
	bl	FlashSavePhyInfo
	adrp	x0, .LANCHOR148
	ldr	w1, [x0, #:lo12:.LANCHOR148]
	mov	w0, 0
	bl	FlashDdrParaScan
.L1273:
	bl	FlashSavePhyInfo
.L1266:
	ldr	x2, [x20, #:lo12:.LANCHOR18]
	adrp	x25, .LANCHOR24
	ldrb	w0, [x2, 26]
	strb	w0, [x27, #:lo12:.LANCHOR15]
	ldrh	w0, [x2, 16]
	ubfx	x1, x0, 7, 1
	strb	w1, [x28, #:lo12:.LANCHOR5]
	adrp	x1, .LANCHOR201
	ubfx	x3, x0, 3, 1
	adrp	x28, .LANCHOR145
	strb	w3, [x1, #:lo12:.LANCHOR201]
	adrp	x1, .LANCHOR27
	ubfx	x3, x0, 4, 1
	ubfx	x0, x0, 8, 3
	strb	w3, [x1, #:lo12:.LANCHOR27]
	strb	w0, [x25, #:lo12:.LANCHOR24]
	ldrh	w1, [x2, 10]
	ldrb	w0, [x2, 12]
	str	xzr, [x28, #:lo12:.LANCHOR145]
	sdiv	w1, w1, w0
	ldrb	w0, [x2, 18]
	bl	BuildFlashLsbPageTable
	bl	FlashDieInfoInit
	ldr	x0, [x20, #:lo12:.LANCHOR18]
	ldrh	w1, [x0, 16]
	tbz	x1, 6, .L1275
	add	x3, x19, :lo12:.LANCHOR20
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
	bhi	.L1276
	adrp	x1, HynixReadRetrial
	add	x1, x1, :lo12:HynixReadRetrial
	str	x1, [x28, #:lo12:.LANCHOR145]
	sub	w1, w0, #5
	and	w1, w1, 255
	cmp	w1, 1
	ccmp	w0, 8, 4, hi
	bne	.L1277
	adrp	x1, .LANCHOR36
	mov	w2, 1
	str	w2, [x1, #:lo12:.LANCHOR36]
.L1277:
	add	x19, x19, :lo12:.LANCHOR20
	cmp	w0, 7
	beq	.L1330
	cmp	w0, 8
	bne	.L1298
.L1330:
	add	x19, x19, 28
.L1278:
	mov	x1, 0
	mov	w2, 0
.L1280:
	ldrsb	w3, [x19, x1]
	add	x1, x1, 1
	cmp	w3, 0
	cinc	w2, w2, eq
	cmp	x1, 32
	bne	.L1280
	cmp	w2, 27
	bls	.L1275
	bl	FlashGetReadRetryDefault
	bl	FlashSavePhyInfo
.L1275:
	ldr	w1, [x26, #:lo12:.LANCHOR119]
	mov	w0, 12336
	movk	w0, 0x5638, lsl 16
	cmp	w1, w0
	bne	.L1289
	ldrb	w0, [x27, #:lo12:.LANCHOR15]
	cbz	w0, .L1289
	ldr	x0, [x20, #:lo12:.LANCHOR18]
	strb	wzr, [x0, 18]
.L1289:
	ldrb	w0, [x21, #:lo12:.LANCHOR22]
	cmp	w0, 44
	bne	.L1290
	ldrb	w0, [x22, #:lo12:.LANCHOR30]
	cbz	w0, .L1290
	strb	wzr, [x22, #:lo12:.LANCHOR30]
	mov	w0, 1
	bl	FlashSetInterfaceMode
	mov	w0, 1
	bl	NandcSetMode
.L1290:
	ldrb	w0, [x25, #:lo12:.LANCHOR24]
	tst	w0, 6
	beq	.L1291
	ldrb	w1, [x22, #:lo12:.LANCHOR30]
	cbnz	w1, .L1292
	tbnz	x0, 0, .L1291
.L1292:
	mov	w0, 0
	bl	flash_enter_slc_mode
	adrp	x0, .LANCHOR148
	ldr	w1, [x0, #:lo12:.LANCHOR148]
	mov	w0, 0
	bl	FlashDdrParaScan
	mov	w0, 0
	bl	flash_exit_slc_mode
.L1291:
	ldr	x0, [x20, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 20]
	bl	FlashBchSel
	adrp	x0, .LANCHOR141
	add	x0, x0, :lo12:.LANCHOR141
	bl	FlashReadIdbDataRaw
	ldr	x2, [x20, #:lo12:.LANCHOR18]
	mov	w0, 16
	adrp	x1, .LANCHOR14
	strb	w0, [x24, #:lo12:.LANCHOR2]
	add	x0, x1, :lo12:.LANCHOR14
	ldrb	w3, [x2, 12]
	strh	w3, [x0, 8]
	ldrb	w4, [x2, 7]
	str	w4, [x0, 4]
	ldr	w4, [x21, #:lo12:.LANCHOR22]
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
	ldrb	w5, [x23, #:lo12:.LANCHOR1]
	cmp	w5, 1
	bne	.L1293
	ubfiz	w1, w1, 1, 15
	lsr	w4, w4, 1
	ubfiz	w3, w3, 1, 15
	strh	w1, [x0, 22]
	strh	w4, [x0, 14]
	mov	w1, 8
	strh	w3, [x0, 20]
	strh	w1, [x0, 26]
.L1293:
	ldrb	w0, [x2, 20]
	bl	FlashBchSel
	mov	w0, 0
.L1249:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1262:
	cmp	w1, 220
	bne	.L1264
	add	x0, x27, :lo12:.LANCHOR200
	mov	w1, 4096
	strh	w1, [x0, 14]
	mov	w1, -36
	b	.L1329
.L1264:
	cmp	w1, 211
	bne	.L1263
	add	x0, x27, :lo12:.LANCHOR200
	mov	w1, 4096
	strh	w1, [x0, 14]
	mov	w1, 2
	strb	w1, [x0, 13]
	b	.L1263
.L1298:
	add	x19, x19, 20
	b	.L1278
.L1276:
	sub	w3, w0, #17
	and	w3, w3, 255
	cmp	w3, 2
	bhi	.L1282
	adrp	x2, MicronReadRetrial
	add	x2, x2, :lo12:MicronReadRetrial
	str	x2, [x28, #:lo12:.LANCHOR145]
	cmp	w0, 19
	beq	.L1283
.L1334:
	mov	w0, 7
	b	.L1332
.L1283:
	mov	w0, 15
.L1332:
	strb	w0, [x1, #:lo12:.LANCHOR151]
	b	.L1275
.L1282:
	sub	w3, w0, #65
	cmp	w0, 33
	and	w3, w3, 255
	ccmp	w3, 1, 0, ne
	bhi	.L1284
	adrp	x0, ToshibaReadRetrial
	add	x0, x0, :lo12:ToshibaReadRetrial
	str	x0, [x28, #:lo12:.LANCHOR145]
	mov	w0, 4
	strb	w0, [x2, #:lo12:.LANCHOR12]
	b	.L1334
.L1284:
	sub	w3, w0, #34
	sub	w2, w0, #67
	and	w3, w3, 255
	and	w2, w2, 255
	cmp	w3, 1
	ccmp	w2, 1, 0, hi
	bhi	.L1285
	adrp	x3, ToshibaReadRetrial
	add	x3, x3, :lo12:ToshibaReadRetrial
	str	x3, [x28, #:lo12:.LANCHOR145]
	cmp	w0, 35
	mov	w3, 68
	ccmp	w0, w3, 4, ne
	beq	.L1286
	mov	w0, 7
.L1331:
	strb	w0, [x1, #:lo12:.LANCHOR151]
	cmp	w2, 1
	bhi	.L1288
	mov	w0, 4
.L1333:
	strb	w0, [x4, #:lo12:.LANCHOR12]
	b	.L1275
.L1286:
	mov	w0, 17
	b	.L1331
.L1288:
	mov	w0, 5
	b	.L1333
.L1285:
	cmp	w0, 49
	bne	.L1275
	adrp	x0, SamsungReadRetrial
	add	x0, x0, :lo12:SamsungReadRetrial
	str	x0, [x28, #:lo12:.LANCHOR145]
	b	.L1275
.L1295:
	mov	w0, -2
	b	.L1249
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
.L1336:
	cmp	x22, x19
	bne	.L1348
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1348:
	mov	w1, w25
	mov	w4, w21
	add	x3, x29, 104
	add	x2, x29, 108
	mov	x0, x19
	bl	LogAddr2PhyAddr
	ldrb	w1, [x23]
	ldr	w0, [x29, 104]
	cmp	w1, w0
	bhi	.L1337
	mov	w0, -1
	str	w0, [x19]
.L1338:
	sub	w21, w21, #1
	add	x19, x19, 56
	and	w21, w21, 255
	b	.L1336
.L1337:
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
	bls	.L1341
	cmn	w0, #1
	mov	w1, 256
	csel	w0, w0, w1, eq
.L1341:
	cmp	w0, 256
	ccmn	w0, #1, 4, ne
	csel	w0, w0, wzr, eq
	str	w0, [x19]
	ldr	x0, [x19, 16]
	cbz	x0, .L1344
	ldr	w1, [x0, 12]
	cmn	w1, #1
	bne	.L1344
	ldr	w1, [x0, 8]
	cmn	w1, #1
	bne	.L1344
	ldr	w0, [x0]
	cmn	w0, #1
	beq	.L1344
	str	w1, [x19]
.L1344:
	ldr	w3, [x19]
	cmn	w3, #1
	bne	.L1338
	ldr	w1, [x19, 4]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	bl	printf
	ldr	x1, [x19, 8]
	cbz	x1, .L1346
	adrp	x0, .LC26
	mov	w3, 8
	mov	w2, 4
	add	x0, x0, :lo12:.LC26
	bl	rknand_print_hex
.L1346:
	ldr	x1, [x19, 16]
	cbz	x1, .L1338
	mov	w3, 4
	adrp	x0, .LC27
	mov	w2, w3
	add	x0, x0, :lo12:.LC27
	bl	rknand_print_hex
	b	.L1338
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
	cbnz	w3, .L1367
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
.L1368:
	ldr	w0, [x29, 152]
	cmp	w22, w0
	bcc	.L1402
	mov	w0, 0
	b	.L1366
.L1367:
	bl	FlashReadSlc2KPages
.L1366:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1402:
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
	bhi	.L1370
	mov	w0, -1
	str	w0, [x25, x26]
.L1371:
	add	w22, w22, 1
	b	.L1368
.L1370:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w19, [x0, w1, uxtw]
	adrp	x0, .LANCHOR201
	ldrb	w0, [x0, #:lo12:.LANCHOR201]
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
	bhi	.L1373
	add	x0, x27, :lo12:.LANCHOR20
	sxtw	x2, w19
	add	x0, x0, x2
	sub	w1, w1, #7
	and	w1, w1, 255
	cmp	w1, 1
	ldrb	w3, [x0, 12]
	bhi	.L1374
	ldrb	w3, [x0, 20]
.L1374:
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	ldrb	w0, [x0, x2]
	cmp	w0, w3
	beq	.L1373
	ldp	x2, x0, [x29, 96]
	ldrb	w1, [x0, 1]
	mov	w0, w19
	bl	HynixSetRRPara
.L1373:
	mov	w0, w19
	bl	NandcFlashCs
	ldr	w0, [x29, 148]
	cmp	w0, 1
	cset	w0, eq
	orr	w24, w0, w24, lsr 31
	cbz	w24, .L1375
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L1375
	mov	w0, w19
	bl	flash_enter_slc_mode
.L1376:
	adrp	x0, .LANCHOR3
	add	x0, x0, :lo12:.LANCHOR3
	str	x0, [x29, 112]
	ldr	x0, [x29, 128]
	add	x0, x0, :lo12:.LANCHOR5
	str	x0, [x29, 136]
.L1382:
	ldr	w1, [x29, 172]
	cmn	w1, #1
	bne	.L1377
	cmp	w19, 255
	beq	.L1404
.L1377:
	cbz	w20, .L1379
	ldr	x0, [x29, 112]
	ldr	w2, [x0]
	mov	w0, w19
	add	w2, w1, w2
	bl	FlashReadDpCmd
.L1380:
	mov	w0, w19
	bl	NandcWaitFlashReady
	cbz	w20, .L1378
	ldr	w1, [x29, 172]
	mov	w0, w19
	bl	FlashReadDpDataOutCmd
.L1378:
	ldrb	w2, [x29, 156]
	mov	w1, 0
	ldp	x3, x4, [x21, 8]
	mov	w0, w19
	bl	NandcXferData
	mov	w28, w0
	ldr	x0, [x29, 136]
	ldrb	w0, [x0]
	cbz	w0, .L1381
	cmn	w28, #1
	bne	.L1381
	ldr	x0, [x29, 136]
	mov	w20, 0
	strb	wzr, [x0]
	b	.L1382
.L1375:
	mov	w0, w19
	bl	flash_exit_slc_mode
	b	.L1376
.L1379:
	mov	w0, w19
	bl	FlashReadCmd
	b	.L1380
.L1404:
	mov	w20, 0
	b	.L1378
.L1381:
	cbz	w20, .L1383
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
.L1383:
	mov	w0, w19
	bl	NandcFlashDeCs
	ldr	x0, [x29, 128]
	cmn	w28, #1
	ldrb	w1, [x29, 144]
	strb	w1, [x0, #:lo12:.LANCHOR5]
	bne	.L1384
	adrp	x0, .LANCHOR30
	ldrb	w0, [x0, #:lo12:.LANCHOR30]
	cbnz	w0, .L1385
.L1389:
	adrp	x20, .LANCHOR145
	ldr	x4, [x20, #:lo12:.LANCHOR145]
	cbnz	x4, .L1386
	ldr	w1, [x29, 172]
	mov	w0, w19
	ldp	x2, x3, [x21, 8]
	bl	FlashReadRawPage
	b	.L1441
.L1385:
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
	beq	.L1388
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	cmp	w28, w0, lsr 1
	bls	.L1405
.L1388:
	lsr	w0, w20, 8
	bl	NandcSetDdrPara
	cmn	w28, #1
	beq	.L1389
.L1405:
	mov	w20, 0
.L1384:
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w28, w0, lsr 2
	bls	.L1390
	adrp	x0, .LANCHOR145
	ldr	x0, [x0, #:lo12:.LANCHOR145]
	cmp	x0, 0
	mov	w0, 256
	csel	w28, w28, w0, ne
.L1390:
	cmp	w28, 256
	ccmn	w28, #1, 4, ne
	csel	w3, w28, wzr, eq
	str	w3, [x25, x26]
	cmn	w3, #1
	bne	.L1397
	adrp	x0, .LANCHOR33
	ldr	w1, [x21, 4]
	ldrb	w2, [x0, #:lo12:.LANCHOR33]
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	bl	printf
	ldr	x1, [x21, 16]
	cbz	x1, .L1397
	mov	w3, 4
	adrp	x0, .LC27
	mov	w2, w3
	add	x0, x0, :lo12:.LC27
	bl	rknand_print_hex
.L1397:
	cbz	w20, .L1399
	adrp	x0, .LANCHOR33
	ldrb	w0, [x0, #:lo12:.LANCHOR33]
	add	w0, w0, w0, lsl 1
	cmp	w23, w0, lsr 2
	bls	.L1400
	adrp	x0, .LANCHOR145
	ldr	x0, [x0, #:lo12:.LANCHOR145]
	cmp	x0, 0
	mov	w0, 256
	csel	w23, w23, w0, ne
.L1400:
	add	w0, w22, 1
	mov	w1, 56
	cmp	w23, 256
	ccmn	w23, #1, 4, ne
	umull	x0, w0, w1
	csel	w1, w23, wzr, eq
	str	w1, [x25, x0]
.L1399:
	add	w22, w22, w20
	cbz	w24, .L1371
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L1371
	mov	w0, w19
	bl	flash_exit_slc_mode
	b	.L1371
.L1386:
	ldr	w1, [x29, 172]
	mov	w0, w19
	ldp	x2, x3, [x21, 8]
	blr	x4
	mov	w28, w0
	cmn	w0, #1
	bne	.L1408
	ldr	x0, [x29, 120]
	ldr	x0, [x0, #:lo12:.LANCHOR18]
	ldrb	w0, [x0, 19]
	sub	w0, w0, #1
	and	w0, w0, 255
	cmp	w0, 7
	bhi	.L1391
	add	x0, x27, :lo12:.LANCHOR20
	mov	w3, 0
	add	x2, x0, 4
	ldrb	w1, [x0, 1]
	mov	w0, w19
	bl	HynixSetRRPara
.L1391:
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
	bne	.L1408
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L1408
	mov	w0, w19
	cbz	w24, .L1392
	bl	flash_enter_slc_mode
.L1393:
	ldr	x4, [x20, #:lo12:.LANCHOR145]
	mov	w0, w19
	ldr	w1, [x29, 172]
	ldp	x2, x3, [x21, 8]
	blr	x4
.L1441:
	mov	w28, w0
.L1408:
	mov	w20, 0
	b	.L1390
.L1392:
	bl	flash_exit_slc_mode
	b	.L1393
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
.L1443:
	cmp	x20, x23
	bne	.L1449
	ldr	w0, [x29, 108]
	cbnz	w0, .L1450
.L1469:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1449:
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
	bhi	.L1444
	mov	w0, -1
	str	w0, [x20]
.L1445:
	sub	w22, w22, #1
	add	x20, x20, 56
	and	w22, w22, 255
	b	.L1443
.L1444:
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
	tbz	x0, 0, .L1448
	mov	w0, -1
	str	w0, [x20]
.L1448:
	mov	w0, w19
	bl	NandcFlashDeCs
	b	.L1445
.L1456:
	ldr	w0, [x27]
	cmn	w0, #1
	bne	.L1451
	ldr	w1, [x27, 4]
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	bl	printf
.L1452:
	sub	w21, w21, #1
	add	x27, x27, 56
	and	w21, w21, 255
.L1470:
	cmp	x27, x20
	bne	.L1456
	b	.L1469
.L1451:
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
	bne	.L1453
	ldr	w1, [x27, 4]
	adrp	x0, .LC30
	add	x0, x0, :lo12:.LC30
	bl	printf
	str	w25, [x27]
.L1453:
	ldr	x0, [x27, 16]
	cbz	x0, .L1454
	ldr	w2, [x0]
	ldr	x0, [x19, #:lo12:.LANCHOR199]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1454
	ldr	w1, [x27, 4]
	adrp	x0, .LC31
	add	x0, x0, :lo12:.LC31
	bl	printf
	mov	w0, -1
	str	w0, [x27]
.L1454:
	ldr	x0, [x27, 8]
	cbz	x0, .L1452
	ldr	w2, [x0]
	ldr	x0, [x23, #:lo12:.LANCHOR198]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1452
	ldr	w1, [x27, 4]
	adrp	x0, .LC32
	add	x0, x0, :lo12:.LC32
	bl	printf
	mov	w0, -1
	str	w0, [x27]
	b	.L1452
.L1450:
	adrp	x22, .LANCHOR198
	mov	x23, x22
	b	.L1470
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
	cbnz	w4, .L1473
	mov	x19, x0
	adrp	x0, .LANCHOR31+9
	adrp	x27, .LANCHOR23
	mov	w24, w1
	ldrb	w0, [x0, #:lo12:.LANCHOR31+9]
	mov	w22, w2
	add	x28, x27, :lo12:.LANCHOR23
	mov	w21, 0
	str	w0, [x29, 108]
.L1474:
	cmp	w21, w24
	adrp	x26, .LANCHOR25
	bcc	.L1487
	adrp	x21, .LANCHOR15
	adrp	x23, .LANCHOR23
	add	x25, x26, :lo12:.LANCHOR25
	add	x21, x21, :lo12:.LANCHOR15
	add	x23, x23, :lo12:.LANCHOR23
	mov	x20, 0
.L1488:
	ldrb	w0, [x25]
	cmp	w0, w20
	bhi	.L1490
	ldr	w0, [x29, 100]
	cbnz	w0, .L1491
.L1499:
	mov	w0, 0
	b	.L1472
.L1473:
	bl	FlashProgSlc2KPages
.L1472:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1487:
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
	bhi	.L1476
	mov	w0, -1
	str	w0, [x19, x12]
.L1477:
	add	w21, w21, 1
	b	.L1474
.L1476:
	adrp	x1, .LANCHOR27
	add	x2, x27, :lo12:.LANCHOR23
	mov	x3, 24
	ldrb	w1, [x1, #:lo12:.LANCHOR27]
	cmp	w1, 0
	uxtw	x1, w0
	csel	w23, w23, wzr, ne
	madd	x1, x1, x3, x2
	ldr	x1, [x1, 8]
	cbz	x1, .L1479
	bl	FlashWaitCmdDone
.L1479:
	ldp	w2, w1, [x29, 112]
	mov	x0, 24
	madd	x0, x1, x0, x28
	str	w2, [x0, 4]
	stp	x25, xzr, [x0, 8]
	cbz	w23, .L1480
	add	w2, w21, 1
	mov	w3, 56
	umaddl	x2, w2, w3, x19
	str	x2, [x0, 16]
.L1480:
	adrp	x0, .LANCHOR26
	add	x0, x0, :lo12:.LANCHOR26
	ldrb	w20, [x0, x1]
	mov	x0, 24
	mul	x1, x1, x0
	ldrb	w0, [x26, #:lo12:.LANCHOR25]
	cmp	w0, 1
	mov	w0, w20
	strb	w20, [x28, x1]
	bne	.L1481
	bl	NandcWaitFlashReady
.L1482:
	ldr	w0, [x29, 104]
	sub	w0, w0, #1
	cmp	w0, 7
	bhi	.L1483
	adrp	x0, .LANCHOR21
	add	x0, x0, :lo12:.LANCHOR21
	ldrb	w0, [x0, w20, sxtw]
	cbz	w0, .L1483
	adrp	x0, .LANCHOR20
	add	x0, x0, :lo12:.LANCHOR20
	add	x2, x0, 4
	mov	w3, 0
	ldrb	w1, [x0, 1]
	mov	w0, w20
	bl	HynixSetRRPara
.L1483:
	mov	w0, w20
	bl	NandcFlashCs
	cmp	w22, 1
	bne	.L1484
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L1484
	mov	w0, w20
	bl	flash_enter_slc_mode
.L1485:
	ldr	w1, [x29, 112]
	mov	w0, w20
	bl	FlashProgFirstCmd
	ldrb	w2, [x29, 108]
	mov	w1, 1
	ldp	x3, x4, [x25, 8]
	mov	w0, w20
	bl	NandcXferData
	cbz	w23, .L1486
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
.L1486:
	ldr	w1, [x29, 112]
	mov	w0, w20
	add	w21, w21, w23
	bl	FlashProgSecondCmd
	mov	w0, w20
	bl	NandcFlashDeCs
	b	.L1477
.L1481:
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
	b	.L1482
.L1484:
	mov	w0, w20
	bl	flash_exit_slc_mode
	b	.L1485
.L1490:
	mov	w0, w20
	bl	FlashWaitCmdDone
	cmp	w22, 1
	bne	.L1489
	ldrb	w0, [x21]
	cbz	w0, .L1489
	mov	x0, 24
	mul	x0, x20, x0
	ldrb	w0, [x0, x23]
	bl	flash_exit_slc_mode
.L1489:
	add	x20, x20, 1
	b	.L1488
.L1491:
	mov	w0, 56
	and	w20, w24, 255
	adrp	x23, .LANCHOR198
	mov	x25, x23
	umaddl	x24, w24, w0, x19
.L1492:
	cmp	x24, x19
	beq	.L1499
	ldr	w0, [x19]
	cmn	w0, #1
	bne	.L1493
	ldr	w1, [x19, 4]
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	bl	printf
.L1494:
	sub	w20, w20, #1
	add	x19, x19, 56
	and	w20, w20, 255
	b	.L1492
.L1493:
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
	bne	.L1495
	ldr	w1, [x19, 4]
	adrp	x0, .LC30
	add	x0, x0, :lo12:.LC30
	bl	printf
	str	w26, [x19]
.L1495:
	ldr	x0, [x19, 16]
	cbz	x0, .L1496
	ldr	w2, [x0]
	ldr	x0, [x21, #:lo12:.LANCHOR199]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1496
	ldr	w1, [x19, 4]
	adrp	x0, .LC31
	add	x0, x0, :lo12:.LC31
	bl	printf
	mov	w0, -1
	str	w0, [x19]
.L1496:
	ldr	x0, [x19, 8]
	cbz	x0, .L1494
	ldr	w2, [x0]
	ldr	x0, [x25, #:lo12:.LANCHOR198]
	ldr	w3, [x0]
	cmp	w2, w3
	beq	.L1494
	ldr	w1, [x19, 4]
	adrp	x0, .LC32
	add	x0, x0, :lo12:.LC32
	bl	printf
	mov	w0, -1
	str	w0, [x19]
	b	.L1494
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
	bcc	.L1527
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
.L1525:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 160
	ret
.L1527:
	mov	w19, 0
	b	.L1525
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
	cbnz	w0, .L1552
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
.L1531:
	cmp	w11, w5, uxth
	bhi	.L1535
	cbz	w24, .L1529
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
.L1538:
	ldr	x0, [x21, #:lo12:.LANCHOR77]
	add	x1, x0, x27
	ldr	w0, [x0, x27]
	cmn	w0, #1
	bne	.L1537
	ldr	w0, [x1, 4]
	add	w19, w19, 1
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
.L1537:
	add	x27, x27, 56
	cmp	x27, x24
	bne	.L1538
	cbnz	w25, .L1539
	and	w22, w22, 65535
	mov	w28, 6
	mov	w27, 1
.L1540:
	adrp	x0, .LANCHOR47
	mov	w24, 0
	add	x0, x0, :lo12:.LANCHOR47
	str	x0, [x29, 112]
.L1548:
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
.L1541:
	cmp	w7, w5, uxth
	bhi	.L1544
	cbz	w20, .L1529
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
.L1547:
	ldr	x0, [x21, #:lo12:.LANCHOR77]
	add	x3, x0, x2
	ldr	w0, [x0, x2]
	cbz	w0, .L1546
	ldr	w0, [x3, 4]
	add	w19, w19, 1
	stp	x2, x1, [x29, 96]
	and	w19, w19, 65535
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	ldp	x2, x1, [x29, 96]
.L1546:
	add	x2, x2, 56
	cmp	x1, x2
	bne	.L1547
	add	w24, w24, w28
	and	w24, w24, 65535
	cmp	w27, w24
	bhi	.L1548
	mov	x23, 0
.L1550:
	cbz	w25, .L1549
	ldr	x0, [x21, #:lo12:.LANCHOR77]
	add	x1, x0, x23
	ldr	w0, [x0, x23]
	cbnz	w0, .L1549
	ldr	w0, [x1, 4]
	mov	w1, 1
	str	x2, [x29, 136]
	lsr	w0, w0, 10
	bl	FtlFreeSysBlkQueueIn
	ldr	x2, [x29, 136]
.L1549:
	add	x23, x23, 56
	cmp	x23, x2
	bne	.L1550
	cmp	w26, 63
	ccmp	w25, 0, 0, hi
	beq	.L1529
	ldr	x0, [x21, #:lo12:.LANCHOR77]
	mov	w2, w20
	mov	w1, w22
	bl	FlashEraseBlocks
.L1529:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 144
	ret
.L1535:
	mul	x0, x5, x8
	mov	w1, w26
	str	wzr, [x6, x0]
	ldrb	w0, [x7, x5]
	bl	V2P_block
	and	w15, w0, 65535
	mov	w22, w15
	cbz	w25, .L1532
	bl	IsBlkInVendorPart
	cbnz	w0, .L1533
.L1532:
	mov	w0, w22
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L1534
	umaddl	x1, w24, w14, x6
	lsl	w15, w15, 10
	mul	w0, w24, w13
	add	w24, w24, 1
	and	w24, w24, 65535
	asr	w0, w0, 2
	str	w15, [x1, 4]
	add	x0, x12, x0, sxtw 2
	stp	xzr, x0, [x1, 8]
.L1533:
	add	x5, x5, 1
	b	.L1531
.L1534:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1533
.L1539:
	adrp	x0, .LANCHOR53
	ldrh	w27, [x0, #:lo12:.LANCHOR53]
	ldrb	w0, [x20, #:lo12:.LANCHOR15]
	cbnz	w0, .L1553
	lsr	w28, w27, 2
	mov	w22, 1
	b	.L1540
.L1553:
	mov	w22, 1
	mov	w28, w22
	b	.L1540
.L1544:
	mov	x0, 56
	mov	w1, w26
	mul	x0, x5, x0
	str	wzr, [x6, x0]
	ldr	x0, [x29, 112]
	ldrb	w0, [x0, x5]
	bl	V2P_block
	and	w13, w0, 65535
	mov	w14, w13
	cbz	w25, .L1542
	bl	IsBlkInVendorPart
	cbnz	w0, .L1543
.L1542:
	mov	w0, w14
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L1543
	umaddl	x1, w20, w12, x6
	add	w13, w24, w13, lsl 10
	mul	w0, w20, w11
	add	w20, w20, 1
	and	w20, w20, 65535
	asr	w0, w0, 2
	str	w13, [x1, 4]
	add	x0, x10, x0, sxtw 2
	stp	x8, x0, [x1, 8]
.L1543:
	add	x5, x5, 1
	b	.L1541
.L1552:
	mov	w19, 0
	b	.L1529
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
	cbnz	w0, .L1576
	adrp	x24, .LANCHOR188
	adrp	x23, .LANCHOR183
	adrp	x20, .LANCHOR202
	add	x19, x20, :lo12:.LANCHOR202
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
.L1577:
	ldrh	w0, [x27]
	cmp	w25, w0
	blt	.L1578
	add	x20, x20, :lo12:.LANCHOR202
	add	x19, x21, :lo12:.LANCHOR74
	mov	w2, 16
	mov	w1, 255
	adrp	x25, .LC33
	adrp	x27, .LANCHOR53
	ldr	x28, [x20, 16]
	add	x25, x25, :lo12:.LC33
	add	x27, x27, :lo12:.LANCHOR53
	mov	w26, 0
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
.L1579:
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
	blt	.L1580
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
.L1580:
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
	bne	.L1581
	ldr	w1, [x20, 4]
	add	w21, w21, 1
	adrp	x0, .LC34
	and	w21, w21, 65535
	add	x0, x0, :lo12:.LC34
	bl	printf
	cmp	w21, 3
	bls	.L1579
	ldr	w1, [x20, 4]
	mov	w2, w21
	adrp	x0, .LC35
	add	x0, x0, :lo12:.LC35
	bl	printf
	mov	w0, 1
	str	w0, [x22, #:lo12:.LANCHOR76]
.L1576:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
.L1578:
	ldrh	w2, [x28]
	ldr	x1, [x26], 8
	ldr	x0, [x19, 8]
	mul	w3, w2, w25
	lsl	w2, w2, 2
	add	w25, w25, 1
	add	x0, x0, x3, sxtw 2
	bl	ftl_memcpy
	b	.L1577
.L1581:
	cbnz	w26, .L1576
	mov	w26, 1
	b	.L1579
	.size	FtlBbmTblFlush, .-FtlBbmTblFlush
	.section	.text.allocate_data_superblock,"ax",@progbits
	.align	2
	.global	allocate_data_superblock
	.type	allocate_data_superblock, %function
allocate_data_superblock:
	adrp	x1, .LANCHOR76
	ldr	w1, [x1, #:lo12:.LANCHOR76]
	cbnz	w1, .L1650
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
.L1641:
	ldr	x1, [x29, 120]
	adrp	x0, .LANCHOR88
	adrp	x24, .LANCHOR40
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	ldrh	w1, [x1]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR40]
	cmp	w0, w1
	ble	.L1589
	mov	w2, 3139
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
.L1589:
	adrp	x0, .LANCHOR93
	add	x0, x0, :lo12:.LANCHOR93
	cmp	x19, x0
	bne	.L1590
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
	cbz	w4, .L1591
	adrp	x4, .LANCHOR170
	ldr	w4, [x4, #:lo12:.LANCHOR170]
	cmp	w4, 39
	bhi	.L1591
	cmp	w4, 2
	bls	.L1625
	tbz	x2, 0, .L1621
	cbz	w3, .L1625
.L1621:
	mov	w1, w0
	b	.L1591
.L1590:
	ldrb	w0, [x19, 8]
	cmp	w0, 1
	bne	.L1625
	adrp	x0, .LANCHOR44
	ldrh	w0, [x0, #:lo12:.LANCHOR44]
	cmp	w0, 1
	beq	.L1625
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbnz	w0, .L1625
	adrp	x2, .LANCHOR28
	ldrh	w0, [x23]
	ldr	w2, [x2, #:lo12:.LANCHOR28]
	lsr	w1, w0, 3
	cbz	w2, .L1591
	adrp	x2, .LANCHOR170
	ldr	w2, [x2, #:lo12:.LANCHOR170]
	cmp	w2, 1
	bhi	.L1591
	mov	w1, 7
	mul	w1, w0, w1
	lsr	w1, w1, 3
.L1591:
	cbz	w1, .L1592
	sub	w1, w1, #1
	and	w1, w1, 65535
.L1592:
	ldrb	w2, [x19, 8]
	adrp	x0, .LANCHOR87
	add	x0, x0, :lo12:.LANCHOR87
	bl	List_pop_index_node
	and	w22, w0, 65535
	ldrh	w0, [x23]
	cbnz	w0, .L1593
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
.L1593:
	ldrh	w0, [x23]
	sub	w0, w0, #1
	strh	w0, [x23]
	ldrh	w0, [x24, #:lo12:.LANCHOR40]
	cmp	w0, w22
	bls	.L1641
	adrp	x25, .LANCHOR83
	ubfiz	x21, x22, 1, 16
	ldr	x0, [x25, #:lo12:.LANCHOR83]
	ldrh	w20, [x0, x21]
	cbnz	w20, .L1641
	strh	w22, [x19]
	mov	x0, x19
	bl	make_superblock
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1595
	ldr	x0, [x25, #:lo12:.LANCHOR83]
	mov	w1, -1
	strh	w1, [x0, x21]
	ldrh	w1, [x27, #:lo12:.LANCHOR85]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR40]
	cmp	w0, w1
	ble	.L1641
	mov	w2, 3175
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
	b	.L1641
.L1625:
	mov	w1, 0
	b	.L1592
.L1595:
	ldrh	w1, [x27, #:lo12:.LANCHOR85]
	ldrh	w0, [x23]
	add	w0, w0, w1
	ldrh	w1, [x24, #:lo12:.LANCHOR40]
	cmp	w0, w1
	ble	.L1597
	mov	w2, 3178
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
.L1597:
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
.L1598:
	cmp	x1, x0
	bne	.L1600
	cbnz	w20, .L1601
	mov	w2, 3190
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
.L1601:
	adrp	x0, .LANCHOR28
	adrp	x28, .LANCHOR78
	ldr	w0, [x0, #:lo12:.LANCHOR28]
	cbz	w0, .L1602
	adrp	x0, .LANCHOR91
	add	x0, x0, :lo12:.LANCHOR91
	cmp	x19, x0
	bne	.L1602
	ldr	x0, [x28, #:lo12:.LANCHOR78]
	ldrh	w0, [x0, x21]
	cmp	w0, 40
	bls	.L1602
	strb	wzr, [x19, 8]
.L1602:
	adrp	x0, .LANCHOR204
	ldrh	w0, [x0, #:lo12:.LANCHOR204]
	cmp	w0, w22
	bne	.L1603
	mov	w2, 3197
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
.L1603:
	ldrb	w0, [x19, 8]
	adrp	x6, .LANCHOR48
	adrp	x5, .LANCHOR167
	adrp	x4, .LANCHOR168
	ldr	x1, [x28, #:lo12:.LANCHOR78]
	cbnz	w0, .L1604
	ldrh	w0, [x1, x21]
	cbz	w0, .L1605
	ldrh	w2, [x6, #:lo12:.LANCHOR48]
	add	w0, w0, w2
.L1653:
	strh	w0, [x1, x21]
	mov	w1, 0
	ldr	w0, [x5, #:lo12:.LANCHOR167]
	add	w0, w0, 1
	str	w0, [x5, #:lo12:.LANCHOR167]
	mov	w0, w22
	bl	ftl_set_blk_mode
.L1607:
	ldr	x0, [x28, #:lo12:.LANCHOR78]
	ldrh	w1, [x0, x21]
	adrp	x0, .LANCHOR169
	ldr	w2, [x0, #:lo12:.LANCHOR169]
	cmp	w1, w2
	bls	.L1608
	str	w1, [x0, #:lo12:.LANCHOR169]
.L1608:
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
	ldr	x0, [x25, #:lo12:.LANCHOR77]
	nop // between mem op and mult-accumulate
	umaddl	x1, w1, w20, x3
	add	x2, x0, 4
	add	x1, x0, x1
.L1609:
	cmp	x1, x2
	bne	.L1610
	adrp	x1, .LANCHOR15
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	cbz	w1, .L1611
	ldrb	w1, [x19, 8]
	mov	w2, w20
	cmp	w1, 1
	bne	.L1612
	mov	w1, 0
.L1654:
	bl	FlashEraseBlocks
.L1611:
	ldrb	w1, [x19, 8]
	mov	w2, w20
	ldr	x0, [x25, #:lo12:.LANCHOR77]
	mov	x24, 0
	bl	FlashEraseBlocks
	mov	w1, 0
	mov	x3, 56
.L1613:
	cmp	w20, w24, uxth
	bhi	.L1615
	cbz	w1, .L1616
	mov	w0, w22
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1616:
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1617
	adrp	x0, .LANCHOR83
	mov	w1, -1
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	strh	w1, [x0, x21]
	b	.L1641
.L1600:
	ldrh	w3, [x5]
	stp	xzr, xzr, [x0]
	cmp	w3, w6
	beq	.L1599
	umaddl	x7, w20, w2, x4
	add	w20, w20, 1
	and	w20, w20, 65535
	lsl	w3, w3, 10
	str	w3, [x7, 4]
.L1599:
	add	x0, x0, 56
	add	x5, x5, 2
	b	.L1598
.L1605:
	mov	w0, 2
	b	.L1653
.L1604:
	ldrh	w0, [x1, x21]
	add	w0, w0, 1
	strh	w0, [x1, x21]
	ldr	w0, [x4, #:lo12:.LANCHOR168]
	add	w0, w0, 1
	str	w0, [x4, #:lo12:.LANCHOR168]
	mov	w0, w22
	bl	ftl_set_blk_mode.part.10
	b	.L1607
.L1610:
	ldr	w3, [x2]
	and	w3, w3, -1024
	str	w3, [x2], 56
	b	.L1609
.L1612:
	mov	w1, 1
	b	.L1654
.L1615:
	mul	x0, x24, x3
	ldr	x2, [x25, #:lo12:.LANCHOR77]
	add	x4, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L1614
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
.L1614:
	add	x24, x24, 1
	add	x26, x26, 2
	b	.L1613
.L1617:
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
	cbz	w0, .L1618
	ldrb	w0, [x19, 7]
	cbnz	w0, .L1588
.L1618:
	mov	w2, 3256
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
.L1588:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L1650:
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
	cbz	w0, .L1656
	adrp	x23, .LANCHOR117
	add	x24, x23, :lo12:.LANCHOR117
	mov	w19, 0
.L1657:
	adrp	x0, .LANCHOR38
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w0, w19
	bhi	.L1663
	bl	FtlGcReFreshBadBlk
.L1656:
	mov	w0, 0
	ldr	x27, [sp, 80]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	ret
.L1663:
	adrp	x0, .LANCHOR47
	add	x0, x0, :lo12:.LANCHOR47
	mov	w1, w25
	add	x22, x21, :lo12:.LANCHOR116
	mov	w20, 0
	ldrb	w0, [x0, w19, sxtw]
	bl	V2P_block
	and	w26, w0, 65535
.L1658:
	ldrh	w0, [x22]
	cmp	w0, w20
	bhi	.L1662
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1657
.L1662:
	add	x0, x23, :lo12:.LANCHOR117
	add	w27, w20, 1
	ldrh	w0, [x0, w20, sxtw 1]
	cmp	w0, w26
	bne	.L1659
	mov	w0, w26
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	w1, [x22]
	sxtw	x3, w27
	and	x4, x20, 65535
	mov	x0, 0
.L1660:
	add	w2, w20, w0
	cmp	w1, w2, uxth
	bhi	.L1661
	sub	w1, w1, #1
	strh	w1, [x22]
.L1659:
	and	w20, w27, 65535
	b	.L1658
.L1661:
	add	x2, x3, x0
	ldrh	w5, [x24, x2, lsl 1]
	add	x2, x4, x0
	add	x0, x0, 1
	strh	w5, [x24, x2, lsl 1]
	b	.L1660
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
	cbnz	w0, .L1669
	adrp	x0, .LANCHOR204
	ldrh	w1, [x0, #:lo12:.LANCHOR204]
	cmp	w1, w19
	bne	.L1670
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR204]
.L1671:
	adrp	x20, .LANCHOR85
	mov	w1, w19
	adrp	x0, .LANCHOR82
	add	x0, x0, :lo12:.LANCHOR82
	bl	List_remove_node
	ldrh	w0, [x20, #:lo12:.LANCHOR85]
	cbnz	w0, .L1673
	mov	w2, 3367
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
.L1673:
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
	ble	.L1677
	mov	w2, 3370
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
.L1677:
	mov	w0, 1
	b	.L1668
.L1670:
	adrp	x0, .LANCHOR91
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w0, w19
	beq	.L1676
	adrp	x0, .LANCHOR92
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w0, w19
	beq	.L1676
	adrp	x0, .LANCHOR93
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w0, w19
	bne	.L1671
.L1676:
	mov	w0, 0
.L1668:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L1669:
	mov	w0, w19
	bl	List_update_data_list
	b	.L1676
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
	beq	.L1680
	adrp	x20, .LANCHOR83
	ubfiz	x21, x19, 1, 16
	ldr	x1, [x20, #:lo12:.LANCHOR83]
	ldrh	w0, [x1, x21]
	cbnz	w0, .L1681
	mov	w2, 0
	mov	w1, w19
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	bl	printf
	ldr	x0, [x20, #:lo12:.LANCHOR83]
	ldrh	w0, [x0, x21]
	cbnz	w0, .L1682
	mov	w2, 3385
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
.L1682:
	ldr	x0, [x20, #:lo12:.LANCHOR83]
	adrp	x6, .LANCHOR87
	add	x6, x6, :lo12:.LANCHOR87
	mov	w1, 32
	strh	w1, [x0, x21]
	mov	w1, w19
	mov	x0, x6
	bl	test_node_in_list
	cbz	w0, .L1683
	adrp	x22, .LANCHOR88
	mov	w1, w19
	mov	x0, x6
	bl	List_remove_node
	ldrh	w0, [x22, #:lo12:.LANCHOR88]
	cbnz	w0, .L1684
	mov	w2, 3389
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
.L1684:
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
.L1683:
	mov	w0, w19
	bl	FtlGcRefreshBlock
.L1687:
	mov	w20, 0
	b	.L1679
.L1681:
	sub	w0, w0, #1
	strh	w0, [x1, x21]
.L1680:
	adrp	x21, .LANCHOR133
	mov	w1, 65535
	ldrh	w0, [x21, #:lo12:.LANCHOR133]
	cmp	w0, w1
	bne	.L1686
	strh	w19, [x21, #:lo12:.LANCHOR133]
	b	.L1687
.L1686:
	cmp	w19, w0
	beq	.L1687
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
	cbnz	w1, .L1679
	cmp	w19, w0, uxth
	beq	.L1679
	mov	w2, 3410
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
.L1679:
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
	cbz	w1, .L1704
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	mov	w20, 65535
	ldrh	w1, [x0]
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
	cmp	w1, w20
	beq	.L1692
	mov	x19, x0
	ldrb	w0, [x0, 6]
	adrp	x22, .LANCHOR15
	adrp	x21, .LANCHOR120
	add	x0, x0, 8
	add	x23, x22, :lo12:.LANCHOR15
	add	x21, x21, :lo12:.LANCHOR120
	ldrh	w0, [x19, x0, lsl 1]
.L1696:
	cmp	w0, w20
	beq	.L1698
	ldrb	w0, [x19, 8]
	cmp	w0, 1
	bne	.L1699
	ldrb	w1, [x23]
	cbnz	w1, .L1699
	ldrh	w1, [x19, 2]
	ldrh	w1, [x21, x1, lsl 1]
	cmp	w1, w20
	bne	.L1699
	ldrh	w0, [x19, 4]
	sub	w0, w0, #1
	strh	w0, [x19, 4]
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1698
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
.L1707:
	strh	w0, [x19, 2]
	strb	wzr, [x19, 6]
.L1692:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1698:
	ldrb	w0, [x19, 6]
	adrp	x1, .LANCHOR38
	add	w0, w0, 1
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	and	w0, w0, 255
	strb	w0, [x19, 6]
	cmp	w1, w0
	bne	.L1697
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L1697:
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w0, [x19, x0, lsl 1]
	b	.L1696
.L1699:
	ldrb	w1, [x22, #:lo12:.LANCHOR15]
	cbz	w1, .L1692
	cmp	w0, 1
	bne	.L1692
	adrp	x0, .LANCHOR53
	ldrh	w1, [x19, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bcc	.L1692
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
	b	.L1707
.L1704:
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
	bne	.L1709
	mov	w2, 3307
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
.L1709:
	adrp	x20, .LANCHOR52
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bne	.L1710
	mov	w2, 3308
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
.L1710:
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1711
	mov	w2, 3309
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
.L1712:
	mov	w2, 65535
	cmp	w22, w2
	beq	.L1713
	ldrb	w0, [x19, 8]
	ldrh	w1, [x19, 4]
	cmp	w0, 1
	ldrh	w0, [x19, 2]
	bne	.L1715
	ldrb	w3, [x23]
	cbnz	w3, .L1715
	ldrh	w3, [x24, w0, sxtw 1]
	cmp	w3, w2
	bne	.L1715
	ldrh	w0, [x19]
	sub	w1, w1, #1
	strh	w1, [x19, 4]
	bl	decrement_vpc_count
.L1713:
	ldrb	w0, [x19, 6]
	ldrh	w1, [x25]
	add	w0, w0, 1
	and	w0, w0, 255
	strb	w0, [x19, 6]
	cmp	w1, w0
	bne	.L1714
	ldrh	w0, [x19, 2]
	strb	wzr, [x19, 6]
	add	w0, w0, 1
	strh	w0, [x19, 2]
.L1714:
	ldrb	w0, [x19, 6]
	add	x0, x0, 8
	ldrh	w22, [x19, x0, lsl 1]
	b	.L1712
.L1715:
	adrp	x23, .LANCHOR15
	adrp	x24, .LANCHOR120
	orr	w22, w0, w22, lsl 10
	add	x23, x23, :lo12:.LANCHOR15
	add	x24, x24, :lo12:.LANCHOR120
	sub	w1, w1, #1
	strh	w1, [x19, 4]
.L1716:
	ldrb	w0, [x19, 6]
	mov	w1, 65535
	ldrh	w3, [x21, #:lo12:.LANCHOR38]
.L1718:
	add	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, w3
	bne	.L1717
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	w0, 0
.L1717:
	add	x2, x19, x0, sxtw 1
	ldrh	w2, [x2, 16]
	cmp	w2, w1
	beq	.L1718
	strb	w0, [x19, 6]
	ldrb	w0, [x19, 8]
	cmp	w0, 1
	bne	.L1719
	ldrb	w2, [x23]
	ldrh	w0, [x19, 2]
	cbnz	w2, .L1720
	ldrh	w0, [x24, w0, sxtw 1]
	cmp	w0, w1
	bne	.L1719
	ldrh	w0, [x19, 4]
	cbz	w0, .L1719
	sub	w0, w0, #1
	strh	w0, [x19, 4]
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	b	.L1716
.L1720:
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	cmp	w0, w1
	bcc	.L1719
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
.L1719:
	ldrh	w1, [x19, 2]
	ldrh	w0, [x20, #:lo12:.LANCHOR52]
	cmp	w1, w0
	bne	.L1708
	ldrh	w0, [x19, 4]
	cbz	w0, .L1708
	mov	w2, 3353
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
	adrp	x24, .LANCHOR76
	stp	x19, x20, [sp, 16]
	ldr	w0, [x24, #:lo12:.LANCHOR76]
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	str	x24, [x29, 104]
	cbnz	w0, .L1733
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
	adrp	x2, .LANCHOR80
	add	x19, x2, :lo12:.LANCHOR80
	str	wzr, [x20, 12]
	str	w3, [x2, #:lo12:.LANCHOR80]
	mov	w2, 83
	movk	w2, 0x5000, lsl 16
	strh	w1, [x19, 8]
	adrp	x1, .LANCHOR45
	str	w2, [x19, 4]
	adrp	x2, .LANCHOR91
	ldrh	w1, [x1, #:lo12:.LANCHOR45]
	strb	w1, [x19, 10]
	add	x1, x2, :lo12:.LANCHOR91
	ldrh	w2, [x2, #:lo12:.LANCHOR91]
	strh	w2, [x19, 14]
	ldrb	w3, [x1, 6]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x19, 11]
	orr	w2, w3, w2, lsl 6
	strh	w2, [x19, 16]
	adrp	x2, .LANCHOR92
	add	x1, x2, :lo12:.LANCHOR92
	ldrh	w2, [x2, #:lo12:.LANCHOR92]
	ldrb	w3, [x1, 6]
	strh	w2, [x19, 18]
	ldrh	w2, [x1, 2]
	ldrb	w1, [x1, 8]
	strb	w1, [x19, 12]
	orr	w2, w3, w2, lsl 6
	strh	w2, [x19, 20]
	adrp	x2, .LANCHOR93
	add	x1, x2, :lo12:.LANCHOR93
	ldrh	w2, [x2, #:lo12:.LANCHOR93]
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
	adrp	x1, .LANCHOR112
	ldrh	w1, [x1, #:lo12:.LANCHOR112]
	strh	w1, [x19, 44]
	adrp	x1, .LANCHOR113
	ldrh	w1, [x1, #:lo12:.LANCHOR113]
	strh	w1, [x19, 46]
	adrp	x1, .LANCHOR57
	ldrh	w2, [x1, #:lo12:.LANCHOR57]
	mov	w1, 255
	bl	ftl_memset
	ldr	x0, [x21, 8]
	mov	x1, x19
	mov	w2, 48
	mov	x19, x28
	bl	ftl_memcpy
	adrp	x1, .LANCHOR83
	ldrh	w2, [x27, #:lo12:.LANCHOR40]
	ldr	x0, [x21, 8]
	ldr	x1, [x1, #:lo12:.LANCHOR83]
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
	adrp	x0, .LANCHOR69
	ldrh	w0, [x0, #:lo12:.LANCHOR69]
	cbz	w0, .L1734
	ldrh	w0, [x27, #:lo12:.LANCHOR40]
	adrp	x1, .LANCHOR66
	ldr	x3, [x21, 8]
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
.L1734:
	add	x28, x19, :lo12:.LANCHOR202
	mov	w0, 0
	add	x24, x23, :lo12:.LANCHOR209
	bl	FtlUpdateVaildLpn
	adrp	x23, .LANCHOR53
	mov	w21, 0
	add	x23, x23, :lo12:.LANCHOR53
	mov	w27, 65535
	str	x23, [x29, 96]
.L1735:
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
	blt	.L1736
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
.L1736:
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
	bne	.L1737
	cmp	w0, 1
	bne	.L1738
	mov	w2, 1217
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
.L1738:
	ldrh	w0, [x24, 2]
	cmp	w0, 1
	bne	.L1739
	ldr	x0, [x29, 96]
	ldrh	w0, [x0]
	sub	w0, w0, #1
	strh	w0, [x24, 2]
.L1739:
	add	w21, w21, 1
	and	w21, w21, 65535
	cmp	w21, 3
	bls	.L1735
	add	x19, x19, :lo12:.LANCHOR202
	mov	w2, w21
	adrp	x0, .LC38
	add	x0, x0, :lo12:.LC38
	ldr	w1, [x19, 4]
	bl	printf
	ldr	x1, [x29, 104]
	mov	w0, 1
	str	w0, [x1, #:lo12:.LANCHOR76]
.L1733:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1737:
	cmp	w0, 1
	beq	.L1735
	cmp	w1, 256
	beq	.L1735
	mov	w0, 65535
	cmp	w27, w0
	beq	.L1733
	mov	w1, 1
	mov	w0, w27
	bl	FtlFreeSysBlkQueueIn
	b	.L1733
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
	cbnz	w23, .L1752
	adrp	x1, .LANCHOR15
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	cbz	w1, .L1763
	ldrb	w1, [x0, 8]
	cmp	w1, 1
	bne	.L1763
	ldrh	w21, [x0, 4]
	mov	w23, w1
.L1754:
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
.L1755:
	sub	w21, w21, #1
	cmn	w21, #1
	beq	.L1758
	ldrh	w0, [x19, 4]
	cbnz	w0, .L1756
.L1758:
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
.L1752:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 128
	ret
.L1763:
	mov	w21, 12
	b	.L1754
.L1756:
	mov	x0, x19
	bl	get_new_active_ppa
	str	w0, [x29, 76]
	cmn	w0, #1
	beq	.L1758
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
	b	.L1755
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
.L1769:
	ldrh	w0, [x23]
	cmp	w21, w0
	bcc	.L1774
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1774:
	ldrh	w19, [x26, #:lo12:.LANCHOR51]
	add	x24, x22, :lo12:.LANCHOR202
	strh	w27, [x20]
	mov	w3, 61664
	sub	w19, w19, #1
	and	w19, w19, 65535
.L1770:
	ldrh	w0, [x28]
	sub	w1, w0, #15
	cmp	w1, w19
	bgt	.L1772
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
	beq	.L1771
	ldrh	w0, [x25]
	cmp	w0, w3
	bne	.L1771
	strh	w19, [x20]
.L1772:
	add	w21, w21, 1
	add	x20, x20, 2
	b	.L1769
.L1771:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1770
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
	bne	.L1780
	adrp	x1, .LANCHOR53
	ldrh	w19, [x1, #:lo12:.LANCHOR53]
.L1781:
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
	bne	.L1782
	mov	w22, 0
	mov	w24, 2
.L1783:
	cmp	w22, w19
	ble	.L1786
.L1782:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 192
	ret
.L1780:
	adrp	x1, .LANCHOR52
	ldrh	w19, [x1, #:lo12:.LANCHOR52]
	b	.L1781
.L1786:
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
	bne	.L1784
	ldr	w0, [x29, 132]
	cmn	w0, #1
	bne	.L1784
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L1784
	sub	w19, w20, #1
	sxth	w19, w19
	b	.L1783
.L1784:
	add	w20, w20, 1
	sxth	w22, w20
	b	.L1783
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
.L1792:
	ldrh	w0, [x24]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L1795
	lsl	w0, w19, 10
	mov	w2, 1
	str	w0, [x20, 4]
	mov	w1, w2
	mov	x0, x20
	bl	FlashReadPages
	ldr	w0, [x20]
	cmn	w0, #1
	bne	.L1793
	ldr	w0, [x20, 4]
	mov	w2, 1
	mov	w1, w2
	add	w0, w0, 1
	str	w0, [x20, 4]
	mov	x0, x20
	bl	FlashReadPages
.L1793:
	ldr	w0, [x20]
	cmn	w0, #1
	beq	.L1794
	ldrh	w0, [x21]
	cmp	w0, w25
	bne	.L1794
	adrp	x1, .LANCHOR74
	add	x0, x1, :lo12:.LANCHOR74
	strh	w19, [x1, #:lo12:.LANCHOR74]
	ldr	w1, [x21, 4]
	str	w1, [x0, 8]
	ldrh	w1, [x21, 8]
	strh	w1, [x0, 4]
.L1795:
	adrp	x19, .LANCHOR74
	mov	w0, 65535
	add	x20, x19, :lo12:.LANCHOR74
	ldrh	w1, [x19, #:lo12:.LANCHOR74]
	cmp	w1, w0
	beq	.L1809
	ldrh	w1, [x20, 4]
	cmp	w1, w0
	beq	.L1799
	add	x0, x22, :lo12:.LANCHOR202
	lsl	w1, w1, 10
	mov	w2, 1
	str	w1, [x0, 4]
	mov	w1, w2
	bl	FlashReadPages
	ldr	w0, [x22, #:lo12:.LANCHOR202]
	cmn	w0, #1
	beq	.L1799
	ldrh	w1, [x21]
	mov	w0, 61649
	cmp	w1, w0
	bne	.L1799
	ldr	w1, [x20, 8]
	ldr	w0, [x21, 4]
	cmp	w0, w1
	bls	.L1799
	ldrh	w1, [x20, 4]
	str	w0, [x20, 8]
	ldrh	w0, [x21, 8]
	strh	w1, [x19, #:lo12:.LANCHOR74]
	strh	w0, [x20, 4]
.L1799:
	ldrh	w0, [x19, #:lo12:.LANCHOR74]
	add	x24, x19, :lo12:.LANCHOR74
	mov	w1, 1
	mov	w25, 61649
	bl	FtlGetLastWrittenPage
	sxth	w20, w0
	add	w0, w0, 1
	strh	w0, [x24, 2]
	add	x24, x22, :lo12:.LANCHOR202
.L1801:
	tbz	w20, #31, .L1804
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
.L1803:
	add	x0, x19, :lo12:.LANCHOR74
	ldrh	w1, [x21, 10]
	strh	w1, [x0, 6]
	mov	w1, 65535
	ldrh	w0, [x21, 12]
	cmp	w0, w1
	beq	.L1806
	adrp	x1, .LANCHOR37
	ldr	w2, [x1, #:lo12:.LANCHOR37]
	cmp	w0, w2
	beq	.L1806
	adrp	x1, .LANCHOR41
	ldrh	w1, [x1, #:lo12:.LANCHOR41]
	lsr	w1, w1, 2
	cmp	w2, w1
	bcs	.L1806
	cmp	w0, w1
	bcs	.L1806
	bl	FtlSysBlkNumInit
.L1806:
	add	x19, x19, :lo12:.LANCHOR74
	adrp	x21, .LANCHOR45
	adrp	x23, .LANCHOR123
	add	x19, x19, 32
	add	x21, x21, :lo12:.LANCHOR45
	add	x23, x23, :lo12:.LANCHOR123
	add	x22, x22, :lo12:.LANCHOR202
	mov	w20, 0
.L1807:
	ldrh	w0, [x21]
	cmp	w20, w0
	bcc	.L1808
	mov	w0, 0
.L1791:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1794:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L1792
.L1804:
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
	beq	.L1802
	ldrh	w0, [x21]
	cmp	w0, w25
	beq	.L1803
.L1802:
	sub	w20, w20, #1
	sxth	w20, w20
	b	.L1801
.L1808:
	ldrh	w2, [x23]
	ldr	x0, [x22, 8]
	mul	w1, w2, w20
	lsl	w2, w2, 2
	add	w20, w20, 1
	add	x1, x0, x1, lsl 2
	ldr	x0, [x19], 8
	bl	ftl_memcpy
	b	.L1807
.L1809:
	mov	w0, -1
	b	.L1791
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
	blt	.L1822
	ubfiz	x0, x0, 1, 16
	ldrh	w21, [x20, x0]
	cbz	w21, .L1822
	ldr	w1, [x19, 52]
	cbnz	w1, .L1822
	mov	w1, 1
	str	w1, [x19, 52]
	strh	wzr, [x20, x0]
	ldrh	w0, [x19, 8]
	ldrh	w1, [x19, 2]
	sub	w0, w0, #1
	strh	w0, [x19, 8]
	ldrh	w0, [x25, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bcc	.L1823
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
.L1823:
	adrp	x22, .LANCHOR202
	adrp	x24, .LANCHOR212
	mov	x23, x22
	add	x27, x22, :lo12:.LANCHOR202
	add	x24, x24, :lo12:.LANCHOR212
	mov	w20, 0
.L1824:
	ldrh	w0, [x19, 6]
	cmp	w0, w20
	bhi	.L1830
	mov	w1, 1
	mov	w0, w21
	bl	FtlFreeSysBlkQueueIn
	str	wzr, [x19, 52]
.L1822:
	ldrh	w1, [x19, 2]
	ldrh	w0, [x25, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bcc	.L1828
	mov	x0, x19
	bl	ftl_map_blk_alloc_new_blk
	b	.L1828
.L1830:
	ubfiz	x0, x20, 2, 16
	add	x1, x26, x0
	str	x1, [x29, 104]
	ldr	w1, [x26, x0]
	cmp	w21, w1, lsr 10
	bne	.L1825
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
	beq	.L1826
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
.L1826:
	ldr	w0, [x27]
	ldrh	w2, [x28, 8]
	cmn	w0, #1
	bne	.L1827
.L1829:
	ldr	x0, [x29, 104]
	add	x23, x23, :lo12:.LANCHOR202
	str	wzr, [x0]
	adrp	x0, .LC39
	add	x0, x0, :lo12:.LC39
	ldr	w1, [x23, 4]
	bl	printf
	adrp	x0, .LANCHOR76
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR76]
.L1828:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1827:
	cmp	w2, w20
	bne	.L1829
	ldrh	w1, [x28]
	ldrh	w0, [x19, 4]
	cmp	w1, w0
	bne	.L1829
	ldr	x2, [x27, 8]
	mov	w1, w20
	mov	x0, x19
	bl	FtlMapWritePage
.L1825:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L1824
	.size	ftl_map_blk_gc, .-ftl_map_blk_gc
	.section	.text.Ftl_write_map_blk_to_last_page,"ax",@progbits
	.align	2
	.global	Ftl_write_map_blk_to_last_page
	.type	Ftl_write_map_blk_to_last_page, %function
Ftl_write_map_blk_to_last_page:
	adrp	x1, .LANCHOR76
	ldr	w1, [x1, #:lo12:.LANCHOR76]
	cbnz	w1, .L1850
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
	bne	.L1837
	ldrh	w0, [x19, 8]
	cbz	w0, .L1838
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
.L1838:
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
.L1836:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
.L1837:
	ubfiz	x0, x0, 1, 16
	adrp	x2, .LANCHOR188
	adrp	x21, .LANCHOR202
	add	x1, x21, :lo12:.LANCHOR202
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
.L1839:
	cmp	w4, w1, uxth
	bhi	.L1841
	adrp	x0, .LANCHOR1
	ldrb	w0, [x0, #:lo12:.LANCHOR1]
	cbz	w0, .L1842
	add	x0, x21, :lo12:.LANCHOR202
	adrp	x1, .LANCHOR57
	ldrh	w1, [x1, #:lo12:.LANCHOR57]
	ldr	x0, [x0, 8]
	bl	js_hash
	str	w0, [x20, 12]
.L1842:
	mov	w2, 1
	mov	w3, 0
	mov	w1, w2
	add	x0, x21, :lo12:.LANCHOR202
	bl	FlashProgPages
	ldrh	w0, [x19, 2]
	add	w0, w0, 1
	strh	w0, [x19, 2]
	mov	x0, x19
	bl	ftl_map_blk_gc
	b	.L1836
.L1841:
	ldr	w2, [x23, x1, lsl 2]
	cmp	w22, w2, lsr 10
	bne	.L1840
	add	w0, w0, 1
	and	w0, w0, 65535
	ubfiz	x2, x0, 1, 16
	str	w1, [x3, x2, lsl 2]
	add	x2, x2, 1
	ldr	w5, [x23, x1, lsl 2]
	str	w5, [x3, x2, lsl 2]
.L1840:
	add	x1, x1, 1
	b	.L1839
.L1850:
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
	adrp	x22, .LANCHOR202
	stp	x23, x24, [sp, 48]
	mov	x20, x22
	add	x23, x22, :lo12:.LANCHOR202
	add	x28, x26, :lo12:.LANCHOR53
	str	x2, [x29, 104]
.L1854:
	adrp	x1, .LANCHOR165
	ldr	w0, [x1, #:lo12:.LANCHOR165]
	add	w0, w0, 1
	str	w0, [x1, #:lo12:.LANCHOR165]
	ldrh	w0, [x26, #:lo12:.LANCHOR53]
	ldrh	w1, [x27, 2]
	sub	w0, w0, #1
	cmp	w1, w0
	bge	.L1855
	ldrh	w1, [x27]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L1856
.L1855:
	mov	x0, x27
	bl	Ftl_write_map_blk_to_last_page
.L1856:
	adrp	x21, .LANCHOR76
	ldr	w0, [x21, #:lo12:.LANCHOR76]
	cbnz	w0, .L1871
	ldrh	w1, [x27]
	ldr	x0, [x27, 16]
	ldrh	w0, [x0, x1, lsl 1]
	cbnz	w0, .L1858
	mov	w2, 759
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
.L1858:
	ldrh	w1, [x27]
	ldrh	w0, [x27, 10]
	cmp	w1, w0
	bcc	.L1859
	mov	w2, 760
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
.L1859:
	ldrh	w1, [x27]
	add	x3, x22, :lo12:.LANCHOR202
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
	adrp	x0, .LANCHOR1
	strh	w25, [x6, 8]
	strh	w24, [x6, 2]
	ldrb	w0, [x0, #:lo12:.LANCHOR1]
	cbz	w0, .L1860
	adrp	x0, .LANCHOR57
	ldrh	w1, [x0, #:lo12:.LANCHOR57]
	ldr	x0, [x3, 8]
	bl	js_hash
	str	w0, [x6, 12]
.L1860:
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
	bne	.L1861
	ldr	w1, [x23, 4]
	adrp	x0, .LC40
	add	x0, x0, :lo12:.LC40
	add	w19, w19, 1
	and	w19, w19, 65535
	bl	printf
	ldrh	w0, [x27, 2]
	cmp	w0, 2
	bhi	.L1862
	ldrh	w0, [x28]
	sub	w0, w0, #1
	strh	w0, [x27, 2]
.L1862:
	cmp	w19, 3
	bls	.L1854
	add	x20, x20, :lo12:.LANCHOR202
	mov	w2, w19
	adrp	x0, .LC41
	add	x0, x0, :lo12:.LC41
	ldr	w1, [x20, 4]
	bl	printf
	mov	w0, 1
	str	w0, [x21, #:lo12:.LANCHOR76]
.L1871:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L1861:
	cbz	w1, .L1864
	strh	w24, [x27, 60]
	cmp	w0, 1
	bne	.L1865
.L1866:
	str	wzr, [x27, 56]
	b	.L1854
.L1865:
	cmp	w1, 256
.L1879:
	beq	.L1866
	ldr	w0, [x27, 56]
	cbnz	w0, .L1866
	add	x20, x20, :lo12:.LANCHOR202
	ldr	x0, [x27, 40]
	ldr	w1, [x20, 4]
	str	w1, [x0, w25, uxtw 2]
	b	.L1871
.L1864:
	cmp	w0, 1
	b	.L1879
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
.L1883:
	ldrh	w0, [x20]
	cmp	w0, w19
	bhi	.L1885
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1885:
	ldr	x1, [x21, #:lo12:.LANCHOR96]
	ubfiz	x0, x19, 4, 16
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	tbz	w0, #31, .L1884
	mov	w0, w19
	bl	flush_l2p_region
.L1884:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L1883
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
	bhi	.L1895
	adrp	x0, .LANCHOR56
	adrp	x26, .LANCHOR55
	adrp	x27, .LANCHOR57
	mov	x25, x2
	ldrh	w21, [x0, #:lo12:.LANCHOR56]
	add	x26, x26, :lo12:.LANCHOR55
	add	x27, x27, :lo12:.LANCHOR57
	mov	w24, 0
	lsr	w21, w22, w21
.L1889:
	cbnz	w20, .L1894
.L1887:
	mov	w0, w24
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1894:
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
	cbz	w2, .L1891
	cmp	w19, w1
	beq	.L1891
	ldr	x0, [x28, #:lo12:.LANCHOR185]
	str	w2, [x29, 124]
	mov	w2, 1
	stp	x0, xzr, [x29, 128]
	mov	w1, w2
	add	x0, x29, 120
	bl	FlashReadPages
.L1892:
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
	b	.L1889
.L1891:
	ldrh	w2, [x27]
	mov	w1, 0
	ldr	x0, [x28, #:lo12:.LANCHOR185]
	bl	ftl_memset
	b	.L1892
.L1895:
	mov	w24, -1
	b	.L1887
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
	bne	.L1900
	mov	w0, 83
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
.L1900:
	ret
	.size	Ftl_save_ext_data, .-Ftl_save_ext_data
	.section	.text.FtlEctTblFlush,"ax",@progbits
	.align	2
	.global	FtlEctTblFlush
	.type	FtlEctTblFlush, %function
FtlEctTblFlush:
	adrp	x1, .LANCHOR28
	ldr	w1, [x1, #:lo12:.LANCHOR28]
	cbz	w1, .L1907
	adrp	x1, .LANCHOR170
	mov	w2, 4
	ldr	w1, [x1, #:lo12:.LANCHOR170]
	cmp	w1, 39
	mov	w1, 32
	csel	w1, w1, w2, hi
.L1903:
	adrp	x3, .LANCHOR218
	ldrh	w2, [x3, #:lo12:.LANCHOR218]
	cmp	w2, 31
	bhi	.L1904
	add	w2, w2, 1
	mov	w1, 1
	strh	w2, [x3, #:lo12:.LANCHOR218]
.L1904:
	adrp	x2, .LANCHOR191
	cbnz	w0, .L1905
	ldr	x0, [x2, #:lo12:.LANCHOR191]
	ldr	w3, [x0, 20]
	ldr	w0, [x0, 16]
	add	w1, w1, w3
	cmp	w0, w1
	bcc	.L1910
.L1905:
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
.L1907:
	mov	w1, 32
	b	.L1903
.L1910:
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
	bcs	.L1913
	mov	w2, 3264
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
.L1913:
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbnz	w0, .L1914
	mov	w0, 65535
	cmp	w20, w0
	beq	.L1915
	adrp	x1, .LANCHOR83
	ubfiz	x0, x20, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR83]
	ldrh	w0, [x1, x0]
	cbz	w0, .L1916
	mov	w0, w20
	bl	INSERT_DATA_LIST
.L1915:
	strb	wzr, [x19, 8]
	adrp	x0, .LANCHOR92
	add	x0, x0, :lo12:.LANCHOR92
	cmp	x19, x0
	beq	.L1917
	adrp	x0, .LANCHOR44
	ldrh	w1, [x0, #:lo12:.LANCHOR44]
	cmp	w1, 1
	beq	.L1917
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L1918
.L1917:
	mov	w0, 1
	strb	w0, [x19, 8]
.L1919:
	adrp	x1, .LANCHOR133
	mov	w2, 65535
	mov	x21, x1
	ldrh	w0, [x1, #:lo12:.LANCHOR133]
	cmp	w0, w2
	beq	.L1924
	cmp	w20, w0
	bne	.L1925
	adrp	x2, .LANCHOR83
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR83]
	ldrh	w1, [x2, x1]
	cbz	w1, .L1926
.L1925:
	bl	update_vpc_list
.L1926:
	mov	w0, -1
	strh	w0, [x21, #:lo12:.LANCHOR133]
.L1924:
	mov	x0, x19
	bl	allocate_data_superblock
	bl	l2p_flush
	mov	w0, 0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1914:
	mov	w0, 0
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L1916:
	mov	w0, w20
	bl	INSERT_FREE_LIST
	b	.L1915
.L1918:
	adrp	x0, .LANCHOR91
	add	x2, x0, :lo12:.LANCHOR91
	cmp	x19, x2
	bne	.L1919
	cmp	w1, 3
	beq	.L1921
	adrp	x1, .LANCHOR158
	ldr	w1, [x1, #:lo12:.LANCHOR158]
	cmp	w1, 1
	bne	.L1922
.L1921:
	add	x1, x0, :lo12:.LANCHOR91
	mov	w2, 1
	strb	w2, [x1, 8]
.L1922:
	adrp	x1, .LANCHOR28
	ldr	w1, [x1, #:lo12:.LANCHOR28]
	cbz	w1, .L1919
	adrp	x1, .LANCHOR170
	ldr	w1, [x1, #:lo12:.LANCHOR170]
	cmp	w1, 39
	bhi	.L1919
	add	x0, x0, :lo12:.LANCHOR91
	mov	w1, 1
	strb	w1, [x0, 8]
	b	.L1919
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
	bhi	.L1949
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
.L1942:
	cbnz	w21, .L1948
.L1940:
	mov	w0, w24
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L1948:
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
	cbz	w3, .L1944
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
	bne	.L1946
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
.L1946:
	ldr	x1, [x28, #:lo12:.LANCHOR185]
	lsl	w23, w23, 7
	mov	w2, w27
	mov	x0, x25
	add	x1, x1, x23, sxtw 2
	bl	ftl_memcpy
.L1947:
	add	w20, w20, 1
	sub	w21, w21, w19
	add	w22, w22, w19
	add	x25, x25, x27, sxtw
	b	.L1942
.L1944:
	mov	w2, w27
	mov	w1, 0
	mov	x0, x25
	bl	ftl_memset
	b	.L1947
.L1949:
	mov	w24, -1
	b	.L1940
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
	beq	.L1952
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
.L1952:
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
	beq	.L1955
	mov	w2, 512
	mov	w1, 0
	mov	x0, x21
	bl	ftl_memset
	str	w20, [x19, #:lo12:.LANCHOR138]
.L1955:
	ldr	w1, [x19, #:lo12:.LANCHOR138]
	add	x0, x19, :lo12:.LANCHOR138
	cmp	w1, w20
	adrp	x20, .LANCHOR168
	bne	.L1956
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
.L1956:
	add	x19, x19, :lo12:.LANCHOR138
	adrp	x0, .LANCHOR157
	str	wzr, [x0, #:lo12:.LANCHOR157]
	mov	w0, 34661
	ldr	w1, [x19, 68]
	movk	w0, 0x1234, lsl 16
	cmp	w1, w0
	bne	.L1957
	adrp	x0, .LANCHOR28
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR28]
	adrp	x1, .LC44
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC44
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1957:
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
	cbz	w1, .L1975
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
	cbnz	w1, .L1961
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
	cbz	w0, .L1965
	adrp	x1, .LANCHOR53
	ldrh	w1, [x1, #:lo12:.LANCHOR53]
	sub	w1, w1, #1
	cmp	w0, w1
	bge	.L1965
	ldrh	w1, [x19]
	mov	w2, 65535
	cmp	w1, w2
	beq	.L1965
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
	beq	.L1965
	ldrh	w1, [x24, 8]
	ldr	x2, [x19, 40]
	ubfiz	x0, x1, 2, 16
	ldr	w2, [x2, x0]
	ldr	w0, [x21, 4]
	cmp	w2, w0
	bne	.L1965
	ldr	x2, [x21, 8]
.L1978:
	mov	x0, x19
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	b	FtlMapWritePage
.L1965:
	sub	w20, w20, #1
	and	w20, w20, 65535
	ubfiz	x0, x20, 2, 16
	ldr	w1, [x25, x0]
	add	x0, x22, :lo12:.LANCHOR202
	str	w1, [x0, 4]
	cbz	w1, .L1966
	mov	w2, 1
	mov	w1, w2
	bl	FlashReadPages
.L1967:
	add	x22, x22, :lo12:.LANCHOR202
	mov	w1, w20
	ldr	x2, [x22, 8]
	b	.L1978
.L1966:
	adrp	x1, .LANCHOR57
	ldr	x0, [x0, 8]
	ldrh	w2, [x1, #:lo12:.LANCHOR57]
	mov	w1, 255
	bl	ftl_memset
	b	.L1967
.L1961:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L1975:
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
	adrp	x24, .LANCHOR209
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
.L1980:
	ldr	x0, [x29, 120]
	ldr	w1, [x29, 172]
	ldrh	w0, [x0]
	cmp	w0, w1
	bls	.L2021
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
	b	.L2022
.L1982:
	ldrh	w1, [x29, 172]
	ldrb	w0, [x6, x5]
	bl	V2P_block
	and	w4, w0, 65535
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L1981
	umaddl	x1, w22, w8, x7
	lsl	w4, w4, 10
	mul	w0, w22, w10
	add	w22, w22, 1
	and	w22, w22, 65535
	asr	w0, w0, 2
	str	w4, [x1, 4]
	add	x0, x11, x0, sxtw 2
	stp	x12, x0, [x1, 8]
.L1981:
	add	x5, x5, 1
.L2022:
	cmp	w13, w5, uxth
	bhi	.L1982
	cbnz	w22, .L1983
.L2020:
	ldr	w0, [x29, 172]
	add	w26, w0, 1
	and	w0, w26, 65535
	str	w0, [x29, 172]
	b	.L1980
.L1983:
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
.L2019:
	ldr	x0, [x25, #:lo12:.LANCHOR180]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	ldr	w3, [x1, 4]
	cmn	w0, #1
	ldr	x27, [x1, 16]
	ubfx	x26, x3, 10, 16
	bne	.L1986
	mov	w5, 16
	mov	w7, 65535
.L1988:
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
	bne	.L1985
	ldr	x0, [x6]
	mov	w1, -1
	str	w1, [x0, x22]
	ldr	x0, [x6]
	ldr	w0, [x0, x22]
	cmp	w0, w1
	beq	.L2058
.L1986:
	adrp	x0, .LANCHOR159
	ldr	w1, [x0, #:lo12:.LANCHOR159]
	ldr	w0, [x27, 4]
	cmn	w1, #1
	beq	.L1989
	cmp	w1, w0
	bhi	.L1990
.L1989:
	cmn	w0, #1
	beq	.L1990
	ldr	x2, [x29, 112]
	add	w1, w0, 1
	str	w1, [x2]
.L1990:
	ldrh	w1, [x27]
	mov	w2, 61604
	cmp	w1, w2
	beq	.L1992
	bhi	.L1993
	mov	w0, 61574
	cmp	w1, w0
	beq	.L1994
.L1991:
	ldr	x0, [x29, 128]
	add	x22, x22, 56
	cmp	x0, x22
	bne	.L2019
	b	.L2020
.L1985:
	ldr	x0, [x25, #:lo12:.LANCHOR180]
	ldr	w0, [x0, x22]
	cmn	w0, #1
	bne	.L1986
	sub	w5, w5, #1
	ands	w5, w5, 65535
	bne	.L1988
.L2058:
	mov	w1, 0
	mov	w0, w26
	bl	FtlFreeSysBlkQueueIn
	b	.L1991
.L1993:
	mov	w0, 61634
	cmp	w1, w0
	beq	.L1995
	mov	w0, 65535
	cmp	w1, w0
	beq	.L2058
	b	.L1991
.L1995:
	ldrh	w1, [x20, #:lo12:.LANCHOR128]
	ldr	w0, [x21, #:lo12:.LANCHOR64]
	cmp	w1, w0
	bls	.L1997
	ldr	x1, [x29, 136]
	mov	w2, 1305
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L1997:
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
.L1998:
	cmp	w0, w2
	bgt	.L2004
	tbz	w0, #31, .L2039
	b	.L1991
.L2004:
	sxtw	x8, w0
	ldr	w11, [x27, 4]
	lsl	x7, x8, 2
	add	x10, x5, x7
	ldr	w7, [x5, x7]
	cmp	w11, w7
	bls	.L1999
	ldr	w2, [x5]
	cbnz	w2, .L2000
	cmp	w6, w1
	beq	.L2000
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR128]
.L2000:
	ldr	x1, [x29, 160]
	ldr	x6, [x1, #:lo12:.LANCHOR129]
	mov	w1, 0
.L2001:
	cmp	w1, w0
	bne	.L2002
	ldr	w1, [x27, 4]
	str	w1, [x10]
	strh	w26, [x6, x8, lsl 1]
	tbnz	w0, #31, .L1991
	ldrh	w1, [x20, #:lo12:.LANCHOR128]
	ldr	w2, [x21, #:lo12:.LANCHOR64]
	sub	w2, w2, w1
	sub	w2, w2, #1
	cmp	w0, w2, sxth
	bgt	.L1991
.L2039:
	add	w1, w1, 1
	strh	w1, [x20, #:lo12:.LANCHOR128]
	ldr	w1, [x27, 4]
	str	w1, [x5, x0, lsl 2]
	ldr	x1, [x29, 160]
	ldr	x1, [x1, #:lo12:.LANCHOR129]
.L2057:
	strh	w26, [x1, x0, lsl 1]
	b	.L1991
.L2002:
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
	b	.L2001
.L1999:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L1998
.L1994:
	ldrh	w1, [x23, #:lo12:.LANCHOR70]
	ldrh	w0, [x19, #:lo12:.LANCHOR61]
	cmp	w1, w0
	bls	.L2007
	ldr	x1, [x29, 136]
	mov	w2, 1352
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2007:
	ldrh	w6, [x19, #:lo12:.LANCHOR61]
	ldrh	w2, [x23, #:lo12:.LANCHOR70]
	sub	w1, w6, #1
	sxth	x0, w1
	sub	w5, w1, w2
	ldr	x1, [x29, 144]
	ldr	x1, [x1, #:lo12:.LANCHOR193]
.L2008:
	cmp	w0, w5
	ble	.L2013
	sxtw	x7, w0
	ldr	w11, [x27, 4]
	lsl	x8, x7, 2
	add	x10, x1, x8
	ldr	w8, [x1, x8]
	cmp	w11, w8
	bls	.L2009
	ldr	w5, [x1]
	cbnz	w5, .L2010
	cmp	w6, w2
	beq	.L2010
	add	w2, w2, 1
	strh	w2, [x23, #:lo12:.LANCHOR70]
.L2010:
	ldr	x6, [x28, #:lo12:.LANCHOR71]
	mov	w2, 0
.L2011:
	cmp	w2, w0
	bne	.L2012
	ldr	w2, [x27, 4]
	str	w2, [x10]
	strh	w26, [x6, x7, lsl 1]
.L2013:
	tbnz	w0, #31, .L1991
	ldrh	w2, [x19, #:lo12:.LANCHOR61]
	ldrh	w5, [x23, #:lo12:.LANCHOR70]
	sub	w2, w2, #1
	sub	w2, w2, w5
	cmp	w0, w2, sxth
	bgt	.L1991
	add	w5, w5, 1
	ldr	w2, [x27, 4]
	strh	w5, [x23, #:lo12:.LANCHOR70]
	str	w2, [x1, x0, lsl 2]
	ldr	x1, [x28, #:lo12:.LANCHOR71]
	b	.L2057
.L2012:
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
	b	.L2011
.L2009:
	sub	w0, w0, #1
	sxth	x0, w0
	b	.L2008
.L1992:
	ldrh	w5, [x24, #:lo12:.LANCHOR209]
	mov	w1, 65535
	add	x2, x24, :lo12:.LANCHOR209
	cmp	w5, w1
	bne	.L2015
	strh	w26, [x24, #:lo12:.LANCHOR209]
	str	w0, [x2, 8]
	b	.L1991
.L2015:
	ldrh	w0, [x2, 4]
	cmp	w0, w1
	beq	.L2016
	mov	w1, 1
	bl	FtlFreeSysBlkQueueIn
.L2016:
	add	x0, x24, :lo12:.LANCHOR209
	ldr	w1, [x27, 4]
	ldr	w2, [x0, 8]
	cmp	w2, w1
	bcs	.L2017
	ldrh	w2, [x24, #:lo12:.LANCHOR209]
	strh	w2, [x0, 4]
	strh	w26, [x24, #:lo12:.LANCHOR209]
	str	w1, [x0, 8]
	b	.L1991
.L2017:
	strh	w26, [x0, 4]
	b	.L1991
.L2021:
	ldr	x0, [x29, 160]
	ldr	x2, [x0, #:lo12:.LANCHOR129]
	ldrh	w0, [x2]
	cbz	w0, .L2023
.L2026:
	ldr	x1, [x28, #:lo12:.LANCHOR71]
	ldrh	w0, [x1]
	cbz	w0, .L2024
.L2025:
	ldrh	w1, [x20, #:lo12:.LANCHOR128]
	ldr	w0, [x21, #:lo12:.LANCHOR64]
	cmp	w1, w0
	bls	.L2055
	mov	w2, 1486
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
.L2055:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 176
	ret
.L2023:
	ldrh	w0, [x20, #:lo12:.LANCHOR128]
	cbz	w0, .L2026
	ldr	w1, [x21, #:lo12:.LANCHOR64]
	mov	w0, 0
.L2027:
	cmp	w0, w1
	bcs	.L2026
	ldrh	w3, [x2, w0, sxtw 1]
	cbz	w3, .L2028
	ldr	x1, [x29, 152]
	add	x7, x21, :lo12:.LANCHOR64
	ldr	x4, [x1, #:lo12:.LANCHOR130]
	mov	w1, w0
.L2029:
	ldr	w3, [x7]
	cmp	w1, w3
	bcs	.L2026
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
	b	.L2029
.L2028:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L2027
.L2024:
	ldrh	w0, [x23, #:lo12:.LANCHOR70]
	cbz	w0, .L2025
	ldrh	w2, [x19, #:lo12:.LANCHOR61]
	mov	w0, 0
.L2034:
	mov	w6, w0
	cmp	w0, w2
	bge	.L2025
	ldrh	w3, [x1, w0, sxtw 1]
	cbz	w3, .L2035
	ldr	x2, [x29, 144]
	add	x19, x19, :lo12:.LANCHOR61
	ldr	x3, [x2, #:lo12:.LANCHOR193]
.L2036:
	ldrh	w2, [x19]
	cmp	w0, w2
	bge	.L2025
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
	b	.L2036
.L2035:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L2034
	.size	FtlScanSysBlk, .-FtlScanSysBlk
	.section	.text.FtlLoadSysInfo,"ax",@progbits
	.align	2
	.global	FtlLoadSysInfo
	.type	FtlLoadSysInfo, %function
FtlLoadSysInfo:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR183
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR202
	add	x0, x19, :lo12:.LANCHOR202
	stp	x25, x26, [sp, 64]
	adrp	x25, .LANCHOR188
	stp	x21, x22, [sp, 32]
	stp	x27, x28, [sp, 80]
	adrp	x24, .LANCHOR83
	ldr	x1, [x23, #:lo12:.LANCHOR183]
	adrp	x22, .LANCHOR40
	str	x1, [x0, 8]
	adrp	x21, .LANCHOR209
	ldr	x1, [x25, #:lo12:.LANCHOR188]
	str	x1, [x0, 16]
	ldr	x0, [x24, #:lo12:.LANCHOR83]
	mov	w1, 0
	ldrh	w2, [x22, #:lo12:.LANCHOR40]
	lsl	w2, w2, 1
	bl	ftl_memset
	ldrh	w0, [x21, #:lo12:.LANCHOR209]
	mov	w1, 65535
	cmp	w0, w1
	bne	.L2060
.L2072:
	mov	w0, -1
.L2059:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2060:
	add	x26, x21, :lo12:.LANCHOR209
	mov	w1, 1
	bl	FtlGetLastWrittenPage
	ldrsh	w28, [x21, #:lo12:.LANCHOR209]
	sxth	w20, w0
	adrp	x27, .LANCHOR57
	add	w0, w0, 1
	add	x27, x27, :lo12:.LANCHOR57
	strh	w0, [x26, 2]
	adrp	x26, .LANCHOR1
	add	x26, x26, :lo12:.LANCHOR1
.L2062:
	tbz	w20, #31, .L2068
	mov	w2, 1555
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
	b	.L2067
.L2068:
	add	x3, x19, :lo12:.LANCHOR202
	orr	w0, w20, w28, lsl 10
	mov	w2, 1
	str	x3, [x29, 104]
	mov	w1, w2
	str	w0, [x3, 4]
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	str	x0, [x3, 8]
	mov	x0, x3
	bl	FlashReadPages
	ldrb	w0, [x26]
	cbz	w0, .L2063
	ldr	x3, [x29, 104]
	ldr	x0, [x3, 16]
	ldr	w6, [x0, 12]
	cbz	w6, .L2063
	ldrh	w1, [x27]
	ldr	x0, [x3, 8]
	bl	js_hash
	cmp	w6, w0
	beq	.L2063
	cbnz	w20, .L2064
	add	x0, x21, :lo12:.LANCHOR209
	ldrh	w0, [x0, 4]
	cmp	w28, w0
	beq	.L2064
	sxth	w28, w0
	adrp	x0, .LANCHOR53
	ldrh	w20, [x0, #:lo12:.LANCHOR53]
.L2066:
	sub	w20, w20, #1
	sxth	w20, w20
	b	.L2062
.L2064:
	mov	w0, -1
	str	w0, [x19, #:lo12:.LANCHOR202]
.L2063:
	ldr	w0, [x19, #:lo12:.LANCHOR202]
	cmn	w0, #1
	beq	.L2066
	ldr	x0, [x23, #:lo12:.LANCHOR183]
	mov	w1, 19539
	movk	w1, 0x4654, lsl 16
	ldr	w0, [x0]
	cmp	w0, w1
	bne	.L2066
	ldr	x0, [x25, #:lo12:.LANCHOR188]
	ldrh	w1, [x0]
	mov	w0, 61604
	cmp	w1, w0
	bne	.L2066
.L2067:
	adrp	x1, .LANCHOR57
	ldrh	w0, [x22, #:lo12:.LANCHOR40]
	ldrh	w1, [x1, #:lo12:.LANCHOR57]
	add	x0, x0, 24
	cmp	x1, x0, lsl 1
	bcs	.L2070
	mov	w2, 1557
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
.L2070:
	add	x19, x19, :lo12:.LANCHOR202
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
	adrp	x0, .LANCHOR0
	ldr	x0, [x0, #:lo12:.LANCHOR0]
	bl	ftl_memcpy
	adrp	x0, .LANCHOR69
	ldrh	w0, [x0, #:lo12:.LANCHOR69]
	cbz	w0, .L2071
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
.L2071:
	ldr	w2, [x20, #:lo12:.LANCHOR80]
	mov	w1, 19539
	movk	w1, 0x4654, lsl 16
	add	x0, x20, :lo12:.LANCHOR80
	cmp	w2, w1
	bne	.L2072
	add	x21, x21, :lo12:.LANCHOR209
	ldrh	w1, [x0, 8]
	ldrb	w2, [x0, 10]
	adrp	x0, .LANCHOR45
	strh	w1, [x21, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR45]
	cmp	w2, w0
	bne	.L2072
	adrp	x0, .LANCHOR222
	adrp	x2, .LANCHOR72
	adrp	x3, .LANCHOR38
	str	w1, [x0, #:lo12:.LANCHOR222]
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
	adrp	x3, .LANCHOR223
	strh	w0, [x3, #:lo12:.LANCHOR223]
	bls	.L2073
	mov	w2, 1584
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
.L2073:
	add	x4, x20, :lo12:.LANCHOR80
	adrp	x0, .LANCHOR91
	add	x2, x0, :lo12:.LANCHOR91
	adrp	x5, .LANCHOR204
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
	add	x1, x5, :lo12:.LANCHOR204
	strh	w3, [x2, 2]
	mov	w2, -1
	strh	w2, [x5, #:lo12:.LANCHOR204]
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
	bls	.L2074
	str	w3, [x1, #:lo12:.LANCHOR159]
.L2074:
	add	x20, x20, :lo12:.LANCHOR80
	adrp	x1, .LANCHOR160
	ldr	w3, [x1, #:lo12:.LANCHOR160]
	ldr	w2, [x20, 36]
	cmp	w2, w3
	bls	.L2075
	str	w2, [x1, #:lo12:.LANCHOR160]
.L2075:
	mov	w1, 65535
	cmp	w6, w1
	beq	.L2076
	add	x0, x0, :lo12:.LANCHOR91
	bl	make_superblock
.L2076:
	ldrh	w2, [x19, #:lo12:.LANCHOR92]
	mov	w1, 65535
	add	x0, x19, :lo12:.LANCHOR92
	cmp	w2, w1
	beq	.L2077
	bl	make_superblock
.L2077:
	ldrh	w2, [x21, #:lo12:.LANCHOR93]
	mov	w1, 65535
	add	x0, x21, :lo12:.LANCHOR93
	cmp	w2, w1
	beq	.L2078
	bl	make_superblock
.L2078:
	ldrh	w2, [x22, #:lo12:.LANCHOR204]
	mov	w1, 65535
	add	x0, x22, :lo12:.LANCHOR204
	cmp	w2, w1
	beq	.L2079
	bl	make_superblock
.L2079:
	mov	w0, 0
	b	.L2059
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
	adrp	x1, .LANCHOR224
	adrp	x0, .LC45
	add	x1, x1, :lo12:.LANCHOR224
	add	x0, x0, :lo12:.LC45
	bl	printf
	adrp	x1, .LANCHOR83
	ubfiz	x0, x21, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR83]
	ldrh	w2, [x1, x0]
	mov	w1, w21
	adrp	x0, .LC46
	add	x0, x0, :lo12:.LC46
	bl	printf
	strh	w21, [x23, -48]!
	mov	x0, x23
	bl	make_superblock
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L2104
	cbnz	w22, .L2104
	mov	w0, w21
	bl	ftl_get_blk_mode
	mov	w21, w0
	cmp	w0, 1
	bne	.L2095
	adrp	x0, .LANCHOR53
	ldrh	w25, [x0, #:lo12:.LANCHOR53]
.L2095:
	ldrh	w3, [x19, #:lo12:.LANCHOR52]
	adrp	x26, .LC48
	add	x26, x26, :lo12:.LC48
	mov	w20, 0
	mov	w27, 56
	mov	w2, w25
	mov	w1, w21
	adrp	x0, .LC47
	add	x0, x0, :lo12:.LC47
	bl	printf
.L2096:
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
.L2097:
	cmp	w1, w5
	bne	.L2099
	mov	w1, w19
	umull	x19, w19, w27
	mov	x22, 0
	mov	w2, w21
	bl	FlashReadPages
.L2100:
	cmp	x22, x19
	bne	.L2101
	add	w20, w20, 1
	and	w20, w20, 65535
	cmp	w25, w20
	bne	.L2096
.L2102:
	ldp	x19, x20, [sp, 32]
	mov	w0, 0
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	ldr	x27, [sp, 96]
	add	sp, sp, 160
	ret
.L2104:
	mov	w21, 0
	b	.L2095
.L2099:
	ldrh	w2, [x3]
	cmp	w2, w11
	beq	.L2098
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
.L2098:
	add	w1, w1, 1
	add	x3, x3, 2
	and	w1, w1, 65535
	b	.L2097
.L2101:
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
	b	.L2100
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
.L2108:
	ldrh	w0, [x23]
	cmp	w0, w20
	bhi	.L2116
	ldp	x19, x20, [sp, 32]
	mov	w0, 0
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x29, x30, [sp, 16]
	ldr	x25, [sp, 80]
	add	sp, sp, 144
	ret
.L2116:
	strh	w20, [x29, 80]
	mov	w0, w20
	bl	ftl_get_blk_mode
	mov	w3, w0
	adrp	x2, .LANCHOR83
	ubfiz	x1, x20, 1, 16
	adrp	x0, .LC49
	add	x0, x0, :lo12:.LC49
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
.L2109:
	cmp	w1, w5
	bne	.L2111
	mov	w25, 56
	mov	x21, 0
	mov	w2, 0
	mov	w1, w19
	umull	x25, w19, w25
	bl	FlashReadPages
.L2112:
	cmp	x21, x25
	bne	.L2113
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	adrp	x25, .LC51
	add	x25, x25, :lo12:.LC51
	mov	w1, w19
	mov	x19, 0
	mov	w2, 1
	bl	FlashReadPages
.L2114:
	cmp	x21, x19
	bne	.L2115
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2108
.L2111:
	ldrh	w2, [x3]
	cmp	w2, w11
	beq	.L2110
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
.L2110:
	add	w1, w1, 1
	add	x3, x3, 2
	and	w1, w1, 65535
	b	.L2109
.L2113:
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
	b	.L2112
.L2115:
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
	b	.L2114
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
	adrp	x0, .LANCHOR202
	add	x4, x0, :lo12:.LANCHOR202
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
.L2119:
	ldr	w0, [x29, 156]
	cmp	w19, w0
	bge	.L2138
	ldr	w0, [x29, 116]
	sxtw	x26, w19
	cmp	w19, w0
	bne	.L2120
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
	adrp	x26, .LANCHOR1
	str	w0, [x28, 48]
	add	x26, x26, :lo12:.LANCHOR1
	ldr	x0, [x29, 128]
	add	x19, x0, :lo12:.LANCHOR202
.L2121:
	cmp	w25, w23
	ble	.L2124
.L2138:
	mov	x0, x28
	bl	ftl_free_no_use_map_blk
	adrp	x0, .LANCHOR53
	ldrh	w1, [x28, 2]
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w1, w0
	bne	.L2126
	mov	x0, x28
	bl	ftl_map_blk_alloc_new_blk
.L2126:
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
.L2124:
	ldrh	w0, [x21]
	mov	w2, 1
	mov	w1, w2
	orr	w0, w25, w0, lsl 10
	str	w0, [x19, 4]
	mov	x0, x19
	bl	FlashReadPages
	ldrb	w0, [x26]
	cbz	w0, .L2122
	ldr	x0, [x19, 16]
	ldr	w0, [x0, 12]
	str	w0, [x29, 156]
	uxtw	x0, w0
	cbz	w0, .L2122
	ldrh	w1, [x27]
	ldr	x0, [x19, 8]
	bl	js_hash
	ldr	w1, [x29, 156]
	cmp	w1, w0
	beq	.L2122
	mov	w0, -1
	str	w0, [x19]
.L2122:
	ldr	w0, [x19]
	cmn	w0, #1
	beq	.L2123
	ldrh	w0, [x20, 8]
	cmp	w24, w0
	bls	.L2123
	ldrh	w2, [x20]
	ldrh	w1, [x28, 4]
	cmp	w2, w1
	bne	.L2123
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x19, 4]
	str	w1, [x22, x0]
.L2123:
	add	w25, w25, 1
	sxth	w25, w25
	b	.L2121
.L2120:
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
	beq	.L2140
	ldrh	w1, [x20]
	ldrh	w0, [x28, 4]
	cmp	w1, w0
	bne	.L2140
	ldrh	w1, [x20, 8]
	mov	w0, 64245
	cmp	w1, w0
	beq	.L2128
.L2140:
	adrp	x26, .LANCHOR57
	add	x26, x26, :lo12:.LANCHOR57
	adrp	x0, .LANCHOR1
	mov	w5, 0
	add	x0, x0, :lo12:.LANCHOR1
	str	x0, [x29, 120]
.L2129:
	ldr	x0, [x29, 104]
	ldrh	w0, [x0]
	cmp	w5, w0
	bge	.L2136
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
	cbz	w0, .L2133
	ldr	x0, [x27, 16]
	ldr	w0, [x0, 12]
	str	w0, [x29, 152]
	uxtw	x0, w0
	cbz	w0, .L2133
	ldrh	w1, [x26]
	ldr	x0, [x27, 8]
	str	w5, [x29, 112]
	bl	js_hash
	ldr	w1, [x29, 152]
	ldr	w5, [x29, 112]
	cmp	w1, w0
	beq	.L2133
	mov	w0, -1
	str	w0, [x27]
.L2133:
	ldr	w0, [x27]
	cmn	w0, #1
	beq	.L2134
	ldrh	w0, [x20, 8]
	cmp	w24, w0
	bls	.L2134
	ldrh	w2, [x20]
	ldrh	w1, [x28, 4]
	cmp	w2, w1
	bne	.L2134
	ubfiz	x0, x0, 2, 16
	ldr	w1, [x27, 4]
	str	w1, [x22, x0]
.L2134:
	add	w5, w5, 1
	sxth	w5, w5
	b	.L2129
.L2128:
	ldrh	w5, [x25, #:lo12:.LANCHOR53]
	mov	w0, 0
	ldr	x6, [x21, #:lo12:.LANCHOR183]
	sub	w5, w5, #1
.L2130:
	cmp	w0, w5
	blt	.L2132
.L2136:
	add	w19, w19, 1
	sxth	w19, w19
	b	.L2119
.L2132:
	lsl	w2, w0, 1
	sxtw	x2, w2
	lsl	x1, x2, 2
	ldrh	w1, [x6, x1]
	cmp	w24, w1
	bls	.L2131
	add	x2, x2, 1
	ubfiz	x1, x1, 2, 16
	ldr	w2, [x6, x2, lsl 2]
	str	w2, [x22, x1]
.L2131:
	add	w0, w0, 1
	sxth	w0, w0
	b	.L2130
	.size	FtlMapTblRecovery, .-FtlMapTblRecovery
	.section	.text.FtlLoadVonderInfo,"ax",@progbits
	.align	2
	.global	FtlLoadVonderInfo
	.type	FtlLoadVonderInfo, %function
FtlLoadVonderInfo:
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR61
	adrp	x0, .LANCHOR215
	add	x0, x0, :lo12:.LANCHOR215
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
.L2165:
	cmp	w19, w20
	ble	.L2172
	mov	w0, -1
.L2164:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 160
	ret
.L2172:
	add	w0, w20, w26
	mov	w2, 1
	lsl	w0, w0, 10
	mov	w1, w2
	str	w0, [x29, 108]
	add	x0, x29, 104
	bl	FlashReadPages
	ldr	w0, [x29, 104]
	cmn	w0, #1
	beq	.L2166
	ldr	x0, [x22, #:lo12:.LANCHOR197]
	ldrh	w0, [x0]
	cmp	w0, w27
	bne	.L2166
	cbz	x23, .L2173
	cbz	w25, .L2168
.L2171:
	ldr	x1, [x21, #:lo12:.LANCHOR147]
	mov	w2, w24
	mov	x0, x23
	bl	ftl_memcpy
	mov	w3, 4
	adrp	x0, .LC52
	mov	w2, w3
	mov	x1, x23
	add	x0, x0, :lo12:.LC52
	bl	rknand_print_hex
.L2173:
	mov	w0, 0
	b	.L2164
.L2168:
	ldr	x5, [x21, #:lo12:.LANCHOR147]
	adrp	x2, .LANCHOR149
	add	x2, x2, :lo12:.LANCHOR149
	mov	w0, 0
	mov	w6, 1
.L2169:
	ldr	w1, [x2]
	cmp	w0, w1
	bcs	.L2171
	ubfx	x1, x0, 5, 11
	and	w3, w0, 31
	lsl	x1, x1, 2
	add	w0, w0, 1
	lsl	w4, w6, w3
	and	w0, w0, 65535
	ldr	w3, [x5, x1]
	orr	w3, w3, w4
	str	w3, [x5, x1]
	b	.L2169
.L2166:
	sub	w20, w20, #1
	and	w20, w20, 65535
	b	.L2165
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
	bne	.L2179
.L2183:
	mov	w0, 0
.L2180:
	ubfiz	x0, x0, 1, 16
	mov	w1, -1
	ldr	x21, [sp, 32]
	strh	w1, [x20, x0]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L2179:
	ldr	x4, [x21, #:lo12:.LANCHOR153]
	lsr	w5, w19, 4
	sub	w19, w19, #1
	mov	w1, 0
	mov	w0, 0
	mov	w6, 1
.L2181:
	cmp	w1, w19
	bge	.L2180
	ubfx	x3, x1, 5, 11
	and	w2, w1, 31
	lsl	w2, w6, w2
	ldr	w3, [x4, x3, lsl 2]
	tst	w2, w3
	beq	.L2182
	add	w2, w0, 1
	ubfiz	x0, x0, 1, 16
	strh	w1, [x20, x0]
	and	w0, w2, 65535
.L2182:
	cmp	w0, w5
	bcs	.L2183
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L2181
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
	cbnz	w21, .L2190
	bl	FtlBbtMemInit
	adrp	x20, .LANCHOR74
	add	x22, x20, :lo12:.LANCHOR74
	bl	FtlLoadFactoryBbt
	add	x24, x22, 32
	adrp	x28, .LANCHOR202
	add	x22, x22, 12
	add	x25, x28, :lo12:.LANCHOR202
	adrp	x0, .LANCHOR45
	add	x0, x0, :lo12:.LANCHOR45
	str	x0, [x29, 120]
.L2191:
	ldr	x0, [x29, 120]
	ldrh	w0, [x0]
	cmp	w21, w0
	bcc	.L2197
	adrp	x21, .LANCHOR59
	add	x21, x21, :lo12:.LANCHOR59
	mov	w19, 0
.L2198:
	ldrh	w0, [x21]
	cmp	w0, w19
	bhi	.L2199
	add	x21, x20, :lo12:.LANCHOR74
	mov	w22, 65535
	ldrh	w19, [x21, 12]
	sub	w19, w19, #1
	and	w19, w19, 65535
.L2200:
	ldrh	w0, [x21, 12]
	sub	w0, w0, #47
	cmp	w0, w19
	bgt	.L2204
	mov	w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L2201
	mov	w0, w19
	bl	FlashTestBlk
	cbz	w0, .L2202
	mov	w0, w19
	bl	FtlBbmMapBadBlock
.L2201:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L2200
.L2197:
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
	beq	.L2192
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
.L2193:
	mov	w0, w27
	add	w21, w21, 1
	bl	FtlBbmMapBadBlock
	add	x24, x24, 8
	add	x22, x22, 2
	b	.L2191
.L2192:
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
.L2194:
	ldrh	w0, [x23]
	madd	w0, w21, w0, w19
	bl	FtlBbmIsBadBlock
	cmp	w0, 1
	beq	.L2195
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
	bne	.L2193
	mov	w0, w27
	bl	FtlBbmMapBadBlock
	b	.L2194
.L2195:
	sub	w19, w19, #1
	and	w19, w19, 65535
	b	.L2194
.L2199:
	mov	w0, w19
	add	w19, w19, 1
	bl	FtlBbmMapBadBlock
	and	w19, w19, 65535
	b	.L2198
.L2202:
	ldrh	w0, [x21]
	cmp	w0, w22
	bne	.L2203
	strh	w19, [x21]
	b	.L2201
.L2203:
	strh	w19, [x21, 4]
.L2204:
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
.L2190:
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
	bcc	.L2211
	mov	w2, 884
	adrp	x1, .LANCHOR226
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR226
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2211:
	ldr	w0, [x19, #:lo12:.LANCHOR72]
	cmp	w25, w0
	bcs	.L2212
	adrp	x19, .LANCHOR96
	add	w24, w24, 7
	adrp	x0, .LANCHOR67
	ldr	x2, [x19, #:lo12:.LANCHOR96]
	lsr	w23, w25, w24
	and	w22, w23, 65535
	ldrh	w1, [x0, #:lo12:.LANCHOR67]
	mov	x0, 0
.L2213:
	and	x20, x0, 65535
	cmp	w20, w1
	bcc	.L2218
	bl	select_l2p_ram_region
	and	x20, x0, 65535
	ldr	x1, [x19, #:lo12:.LANCHOR96]
	ubfiz	x21, x20, 4, 16
	add	x2, x1, x21
	ldrh	w3, [x1, x21]
	mov	w1, 65535
	cmp	w3, w1
	beq	.L2219
	ldr	w1, [x2, 4]
	tbz	w1, #31, .L2219
	bl	flush_l2p_region
.L2219:
	adrp	x0, .LANCHOR66
	str	x0, [x29, 104]
	ldrh	w1, [x0, #:lo12:.LANCHOR66]
	cmp	w1, w22
	bcs	.L2220
	mov	w2, 526
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
.L2220:
	adrp	x27, .LANCHOR131
	ubfiz	x0, x22, 2, 16
	ldr	x1, [x27, #:lo12:.LANCHOR131]
	ldr	w3, [x1, x0]
	cbnz	w3, .L2221
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
	b	.L2215
.L2212:
	ldr	w1, [x29, 116]
	mov	w0, -1
	cbnz	w1, .L2210
	str	w0, [x26]
.L2210:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2218:
	add	x0, x0, 1
	add	x3, x2, x0, lsl 4
	ldrh	w3, [x3, -16]
	cmp	w3, w22
	bne	.L2213
.L2215:
	mov	x0, 1
	lsl	x24, x0, x24
	ldr	w0, [x29, 116]
	sub	w24, w24, #1
	and	w25, w24, w25
	and	x25, x25, 65535
	cbnz	w0, .L2216
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	add	x0, x0, x20, lsl 4
	ldr	x0, [x0, 8]
	ldr	w0, [x0, x25, lsl 2]
	str	w0, [x26]
.L2217:
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	add	x20, x0, x20, lsl 4
	ldr	w0, [x20, 4]
	cmn	w0, #1
	beq	.L2226
	add	w0, w0, 1
	str	w0, [x20, 4]
.L2226:
	mov	w0, 0
	b	.L2210
.L2216:
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
	b	.L2217
.L2221:
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	adrp	x5, .LANCHOR202
	add	x28, x5, :lo12:.LANCHOR202
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
	beq	.L2222
	mov	w2, w3
	and	w1, w23, 65535
	adrp	x0, .LC53
	add	x0, x0, :lo12:.LC53
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
	adrp	x0, .LC54
	add	x0, x0, :lo12:.LC54
	bl	rknand_print_hex
	adrp	x0, .LANCHOR76
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR76]
.L2223:
	ldr	x0, [x29, 120]
	ldrh	w0, [x0, 8]
	cmp	w0, w22
	beq	.L2224
	mov	w2, 552
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
.L2224:
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	add	x1, x0, x21
	str	wzr, [x1, 4]
	strh	w22, [x0, x21]
	b	.L2215
.L2222:
	ldr	w0, [x5, #:lo12:.LANCHOR202]
	cmp	w0, 256
	bne	.L2223
	and	w23, w23, 65535
	mov	w2, w3
	mov	w1, w23
	adrp	x0, .LC55
	add	x0, x0, :lo12:.LC55
	bl	printf
	ldr	x0, [x19, #:lo12:.LANCHOR96]
	mov	w1, w23
	add	x0, x0, x21
	ldr	x2, [x0, 8]
	adrp	x0, .LANCHOR127
	add	x0, x0, :lo12:.LANCHOR127
	bl	FtlMapWritePage
	b	.L2223
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
	cbnz	w2, .L2229
	adrp	x2, .LANCHOR15
	ldrb	w2, [x2, #:lo12:.LANCHOR15]
	cbz	w2, .L2244
	ldrb	w2, [x3, 8]
	cmp	w2, 1
	cset	w22, eq
.L2231:
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
.L2232:
	cmp	x19, x21
	beq	.L2241
	adrp	x26, .LANCHOR83
	b	.L2242
.L2244:
	mov	w22, 0
	b	.L2231
.L2235:
	ldr	w0, [x19, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	ldrh	w1, [x20]
	cmp	w1, w0, uxth
	bne	.L2233
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
.L2233:
	ldrh	w0, [x20, 4]
	cbnz	w0, .L2234
	mov	x0, x20
	bl	allocate_new_data_superblock
.L2234:
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
	cbnz	w0, .L2229
.L2242:
	ldr	w0, [x19]
	cmn	w0, #1
	beq	.L2235
	adrp	x0, .LANCHOR38
	ldrb	w1, [x20, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcc	.L2236
	mov	w2, 1583
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
.L2236:
	ldr	w0, [x19, 4]
	cbnz	w22, .L2237
.L2249:
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
	beq	.L2239
	adrp	x2, .LANCHOR83
	ubfiz	x0, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR83]
	ldrh	w0, [x2, x0]
	cbnz	w0, .L2240
	adrp	x0, .LC56
	mov	w2, 0
	add	x0, x0, :lo12:.LC56
	bl	printf
.L2240:
	mov	w0, w26
	bl	decrement_vpc_count
.L2239:
	add	x19, x19, 56
	b	.L2232
.L2237:
	orr	w0, w0, -2147483648
	b	.L2249
.L2241:
	adrp	x0, .LANCHOR38
	ldrb	w1, [x20, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcc	.L2229
	mov	w2, 1600
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
.L2229:
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
	cbnz	w0, .L2256
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR132
	ldr	x0, [x19, #:lo12:.LANCHOR132]
	cbz	x0, .L2251
	adrp	x1, .LANCHOR229
	mov	w2, 0
	ldr	x3, [x1, #:lo12:.LANCHOR229]
	mov	w1, 1
	bl	FtlProgPages
	str	xzr, [x19, #:lo12:.LANCHOR132]
.L2251:
	mov	w0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2256:
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
	cbnz	w0, .L2262
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
.L2262:
	mov	w0, 0
	ret
	.size	FtlSysFlush, .-FtlSysFlush
	.section	.text.FtlDeInit,"ax",@progbits
	.align	2
	.global	FtlDeInit
	.type	FtlDeInit, %function
FtlDeInit:
	adrp	x0, .LANCHOR230
	ldr	w0, [x0, #:lo12:.LANCHOR230]
	cmp	w0, 1
	bne	.L2268
	stp	x29, x30, [sp, -16]!
	add	x29, sp, 0
	bl	FtlSysFlush
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
.L2268:
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
	bhi	.L2281
	mov	w19, w2
	cmp	w2, 31
	bhi	.L2275
.L2289:
	mov	w0, 0
.L2273:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2275:
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbnz	w0, .L2289
	adrp	x22, .LANCHOR55
	bl	FtlCacheWriteBack
	ldrh	w0, [x22, #:lo12:.LANCHOR55]
	udiv	w21, w20, w0
	msub	w20, w0, w21, w20
	ands	w20, w20, 65535
	beq	.L2277
	sub	w0, w0, w20
	add	w21, w21, 1
	cmp	w0, w19
	csel	w0, w0, w19, ls
	sub	w19, w19, w0, uxth
.L2277:
	adrp	x20, .LANCHOR231
	adrp	x23, .LANCHOR163
	add	x20, x20, :lo12:.LANCHOR231
	add	x23, x23, :lo12:.LANCHOR163
	mov	w0, -1
	str	w0, [x29, 76]
.L2278:
	ldrh	w0, [x22, #:lo12:.LANCHOR55]
	cmp	w19, w0
	bcs	.L2280
	adrp	x0, .LANCHOR231
	ldr	w1, [x0, #:lo12:.LANCHOR231]
	cmp	w1, 32
	bls	.L2289
	str	wzr, [x0, #:lo12:.LANCHOR231]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L2289
.L2280:
	mov	w2, 0
	add	x1, x29, 72
	mov	w0, w21
	bl	log2phys
	ldr	w0, [x29, 72]
	cmn	w0, #1
	beq	.L2279
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
.L2279:
	ldrh	w0, [x22, #:lo12:.LANCHOR55]
	add	w21, w21, 1
	sub	w19, w19, w0
	b	.L2278
.L2281:
	mov	w0, -1
	b	.L2273
	.size	ftl_discard, .-ftl_discard
	.section	.text.Ftlscanalldata,"ax",@progbits
	.align	2
	.global	Ftlscanalldata
	.type	Ftlscanalldata, %function
Ftlscanalldata:
	sub	sp, sp, #96
	adrp	x0, .LC57
	mov	w1, 0
	add	x0, x0, :lo12:.LC57
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	adrp	x20, .LANCHOR202
	stp	x21, x22, [sp, 48]
	mov	w19, 0
	adrp	x21, .LANCHOR72
	add	x22, x20, :lo12:.LANCHOR202
	add	x21, x21, :lo12:.LANCHOR72
	str	x23, [sp, 64]
	bl	printf
.L2291:
	ldr	w0, [x21]
	cmp	w19, w0
	bcc	.L2297
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x29, x30, [sp, 16]
	ldr	x23, [sp, 64]
	add	sp, sp, 96
	ret
.L2297:
	mov	w2, 0
	add	x1, x29, 76
	mov	w0, w19
	bl	log2phys
	tst	x19, 2047
	bne	.L2292
	ldr	w2, [x29, 76]
	adrp	x0, .LC58
	mov	w1, w19
	add	x0, x0, :lo12:.LC58
	bl	printf
.L2292:
	ldr	w1, [x29, 76]
	cmn	w1, #1
	beq	.L2294
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
	beq	.L2295
	ldr	w0, [x23, 8]
	cmp	w19, w0
	beq	.L2294
.L2295:
	ldp	x1, x0, [x22, 8]
	ldr	w2, [x1, 4]
	str	w2, [sp]
	ldr	w2, [x22, 4]
	ldp	w3, w4, [x0]
	ldp	w5, w6, [x0, 8]
	adrp	x0, .LC59
	ldr	w7, [x1]
	add	x0, x0, :lo12:.LC59
	mov	w1, w19
	bl	printf
.L2294:
	add	w19, w19, 1
	b	.L2291
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
	cbnz	w1, .L2300
	adrp	x0, .LANCHOR87
	ldr	x19, [x0, #:lo12:.LANCHOR87]
	cbz	x19, .L2301
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
.L2302:
	cmp	w1, w4
	beq	.L2301
	cmp	w19, w3
	bne	.L2303
	mov	w1, w19
	add	x0, x0, :lo12:.LANCHOR87
	bl	List_remove_node
	ldrh	w0, [x23, #:lo12:.LANCHOR88]
	cbnz	w0, .L2304
	mov	w2, 2097
	adrp	x1, .LANCHOR232
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR232
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2304:
	ldrh	w0, [x23, #:lo12:.LANCHOR88]
	sub	w0, w0, #1
	strh	w0, [x23, #:lo12:.LANCHOR88]
	mov	w0, w19
	bl	INSERT_DATA_LIST
	ldr	x1, [x22, #:lo12:.LANCHOR83]
	ldrh	w0, [x1, x20]
	add	w0, w0, 1
	strh	w0, [x1, x20]
.L2301:
	add	x1, x29, 76
	mov	w2, 1
	mov	w0, w21
	bl	log2phys
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L2303:
	umull	x19, w19, w5
	ldrh	w19, [x2, x19]
	cmp	w19, w6
	beq	.L2301
	add	w1, w1, 1
	and	w1, w1, 65535
	b	.L2302
.L2300:
	add	w1, w1, 1
	strh	w1, [x2, x20]
	b	.L2301
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
	beq	.L2469
	ldrb	w0, [x19, 6]
	str	w0, [x29, 180]
	adrp	x0, .LANCHOR52
	ldrh	w26, [x19, 2]
	str	x0, [x29, 144]
	ldrh	w2, [x0, #:lo12:.LANCHOR52]
	cmp	w2, w26
	bne	.L2313
	strh	wzr, [x19, 4]
.L2476:
	strb	wzr, [x19, 6]
.L2469:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	ret
.L2313:
	ldrh	w0, [x19, 16]
	mov	w21, 0
.L2314:
	cmp	w0, w1
	beq	.L2315
	ldrb	w1, [x19, 8]
	cmp	w1, 1
	bne	.L2316
	bl	FtlGetLastWrittenPage
	mov	w20, w0
	cmn	w0, #1
	beq	.L2317
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbnz	w0, .L2394
	adrp	x0, .LANCHOR16
	add	x0, x0, :lo12:.LANCHOR16
	ldrh	w23, [x0, w20, sxtw 1]
.L2318:
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
.L2319:
	cmp	x1, x4
	bne	.L2323
	ldrb	w1, [x19, 8]
	cmp	w1, 1
	bne	.L2395
	adrp	x1, .LANCHOR15
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	cmp	w1, 0
	cset	w1, ne
	str	w1, [x29, 176]
.L2324:
	ldr	w2, [x29, 176]
	mov	w1, w27
	adrp	x24, .LC60
	adrp	x25, .LANCHOR234
	add	x24, x24, :lo12:.LC60
	add	x25, x25, :lo12:.LANCHOR234
	mov	x28, 0
	bl	FlashReadPages
	adrp	x0, .LANCHOR160
	mov	w5, 65535
	str	x0, [x29, 168]
	ldr	w21, [x0, #:lo12:.LANCHOR160]
	sub	w21, w21, #1
.L2325:
	and	w0, w28, 65535
	cmp	w27, w0
	bhi	.L2330
	bne	.L2328
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	add	w20, w20, 1
	and	w20, w20, 65535
	ldr	w0, [x0, 4]
.L2471:
	lsr	w0, w0, 10
	bl	P2V_plane
	ldrb	w1, [x19, 8]
	and	w27, w0, 65535
	cmp	w1, 1
	bne	.L2332
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbnz	w0, .L2332
	adrp	x0, .LANCHOR16
	add	x0, x0, :lo12:.LANCHOR16
	ldrh	w20, [x0, w20, sxtw 1]
.L2332:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w20
	bne	.L2333
	strh	w20, [x19, 2]
	strb	wzr, [x19, 6]
	strh	wzr, [x19, 4]
.L2333:
	ldr	w0, [x29, 180]
	cmp	w20, w26
	cset	w2, eq
	cmp	w27, w0
	cset	w0, eq
	tst	w2, w0
	beq	.L2334
.L2477:
	mov	w2, w27
	mov	w1, w20
	mov	x0, x19
	bl	ftl_sb_update_avl_pages
	b	.L2469
.L2315:
	add	w21, w21, 1
	and	w21, w21, 65535
	add	x0, x19, x21, sxtw 1
	ldrh	w0, [x0, 16]
	b	.L2314
.L2316:
	mov	w1, 0
	bl	FtlGetLastWrittenPage
	mov	w20, w0
	cmn	w0, #1
	beq	.L2317
.L2394:
	mov	w23, w20
	b	.L2318
.L2317:
	cbz	w26, .L2320
	mov	w2, 2168
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
.L2320:
	ldr	w0, [x29, 180]
	cmp	w0, 0
	ccmp	w21, w0, 4, ne
	beq	.L2321
	mov	w2, 2169
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
.L2321:
	strh	wzr, [x19, 2]
	b	.L2476
.L2323:
	ldrh	w2, [x4]
	cmp	w2, w8
	beq	.L2322
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
.L2322:
	add	x4, x4, 2
	b	.L2319
.L2395:
	str	wzr, [x29, 176]
	b	.L2324
.L2330:
	mov	x0, 56
	ldr	x2, [x22, #:lo12:.LANCHOR180]
	mul	x0, x28, x0
	add	x1, x2, x0
	ldr	w0, [x2, x0]
	cbnz	w0, .L2326
	ldr	x6, [x1, 16]
	ldr	w4, [x6, 4]
	cmn	w4, #1
	beq	.L2327
	ldr	x0, [x29, 168]
	ldr	w1, [x0, #:lo12:.LANCHOR160]
	mov	w0, w4
	bl	ftl_cmp_data_ver
	cbz	w0, .L2327
	ldr	x0, [x29, 168]
	add	w4, w4, 1
	str	w4, [x0, #:lo12:.LANCHOR160]
.L2327:
	ldr	w0, [x6]
	cmn	w0, #1
	bne	.L2329
.L2328:
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	and	x28, x28, 65535
	mov	x1, 56
	and	w20, w20, 65535
	madd	x28, x28, x1, x0
	ldr	w0, [x28, 4]
	b	.L2471
.L2326:
	ldr	w1, [x1, 4]
	mov	x0, x24
	bl	printf
	ldrh	w0, [x19]
	and	w5, w23, 65535
	strh	w0, [x25]
.L2329:
	add	x28, x28, 1
	b	.L2325
.L2334:
	mov	w0, 65535
	cmp	w5, w0
	bne	.L2335
	cbnz	w1, .L2336
.L2335:
	adrp	x24, .LANCHOR136
	and	w6, w23, 65535
	ldr	w0, [x24, #:lo12:.LANCHOR136]
	cmn	w0, #1
	bne	.L2337
	str	w21, [x24, #:lo12:.LANCHOR136]
.L2337:
	add	w0, w26, 7
	ldr	w7, [x24, #:lo12:.LANCHOR136]
	cmp	w0, w23, uxth
	bge	.L2396
	sub	w23, w6, #7
	and	w23, w23, 65535
.L2338:
	mov	w3, -1
	adrp	x5, .LANCHOR120
	mov	w28, w3
	add	x5, x5, :lo12:.LANCHOR120
	mov	w4, 65535
.L2339:
	cmp	w23, w6
	bhi	.L2354
	ldr	x1, [x29, 160]
	mov	w25, 0
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	mov	w10, 56
	ldr	x2, [x29, 184]
	ldrh	w1, [x1, #:lo12:.LANCHOR38]
	add	x1, x1, 8
	add	x1, x19, x1, lsl 1
	b	.L2355
.L2396:
	mov	w23, w26
	b	.L2338
.L2341:
	ldrh	w8, [x2]
	cmp	w8, w4
	beq	.L2340
	umaddl	x11, w25, w10, x0
	add	w25, w25, 1
	and	w25, w25, 65535
	orr	w8, w23, w8, lsl 10
	str	w8, [x11, 4]
.L2340:
	add	x2, x2, 2
.L2355:
	cmp	x2, x1
	bne	.L2341
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
.L2342:
	cmp	x25, x1
	bne	.L2352
	cbz	w2, .L2353
	str	w0, [x24, #:lo12:.LANCHOR136]
.L2353:
	add	w23, w23, 1
	and	w23, w23, 65535
	b	.L2339
.L2352:
	ldr	w8, [x1]
	cbnz	w8, .L2343
	ldr	x8, [x1, 16]
	ldrh	w13, [x8]
	cmp	w13, w4
	beq	.L2398
	ldr	w8, [x8, 4]
	cmn	w8, #1
	beq	.L2398
	cmn	w3, #1
	bne	.L2400
	ldrh	w2, [x5, x12, lsl 1]
	cmp	w2, w4
	bne	.L2345
	cbz	w10, .L2400
.L2345:
	cmp	w21, w0
	mov	w2, w11
	csel	w3, w3, w0, eq
.L2344:
	mov	w28, w0
	add	x1, x1, 56
	mov	w0, w8
	b	.L2342
.L2343:
	cbz	w2, .L2346
	str	w0, [x24, #:lo12:.LANCHOR136]
.L2346:
	adrp	x0, .LANCHOR234
	ldrh	w1, [x19]
	strh	w1, [x0, #:lo12:.LANCHOR234]
	ldrb	w0, [x19, 8]
	cbnz	w0, .L2336
	adrp	x0, .LANCHOR120
	add	x0, x0, :lo12:.LANCHOR120
	ldrh	w1, [x0, w23, sxtw 1]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2348
	cmn	w3, #1
	beq	.L2349
	str	w3, [x24, #:lo12:.LANCHOR136]
.L2336:
	adrp	x0, .LANCHOR235
	mov	w23, w26
	mov	w1, 1
	adrp	x28, .LANCHOR136
	strh	w1, [x0, #:lo12:.LANCHOR235]
	add	x0, x28, :lo12:.LANCHOR136
	str	x0, [x29, 112]
.L2356:
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
.L2357:
	cmp	x2, x3
	bne	.L2360
	ldr	w2, [x29, 176]
	mov	w1, w24
	mov	x25, 0
	bl	FlashReadPages
	mov	w0, 56
	umull	x0, w24, w0
	str	x0, [x29, 136]
	adrp	x0, .LANCHOR234
	add	x0, x0, :lo12:.LANCHOR234
	str	x0, [x29, 120]
.L2361:
	ldr	x0, [x29, 136]
	cmp	x25, x0
	bne	.L2387
	ldrb	w0, [x19, 8]
	add	w23, w23, 1
	and	w23, w23, 65535
	cmp	w0, 1
	bne	.L2388
	ldr	x0, [x29, 128]
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L2388
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	cmp	w0, w23
	bne	.L2388
	cmp	w20, w23
	beq	.L2363
.L2388:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w23
	bne	.L2356
	ldr	x0, [x29, 160]
	mov	w2, 65535
	strh	w23, [x19, 2]
	strh	wzr, [x19, 4]
	ldrh	w1, [x0, #:lo12:.LANCHOR38]
	mov	w0, 0
.L2389:
	cmp	w0, w1
	beq	.L2469
	ldr	x4, [x29, 184]
	ldrh	w3, [x4], 2
	str	x4, [x29, 184]
	cmp	w3, w2
	beq	.L2390
	strb	w0, [x19, 6]
	b	.L2469
.L2349:
	cmp	w21, w7
	beq	.L2350
	str	w7, [x24, #:lo12:.LANCHOR136]
	b	.L2336
.L2350:
	ldr	w0, [x24, #:lo12:.LANCHOR136]
.L2478:
	sub	w0, w0, #1
.L2472:
	str	w0, [x24, #:lo12:.LANCHOR136]
	b	.L2336
.L2348:
	cmp	w28, w21
	beq	.L2351
	cmn	w28, #1
	beq	.L2336
	str	w28, [x24, #:lo12:.LANCHOR136]
	b	.L2336
.L2351:
	ldr	w0, [x24, #:lo12:.LANCHOR136]
	cmp	w21, w0
	bne	.L2478
	b	.L2336
.L2398:
	mov	w8, w0
	mov	w0, w28
	b	.L2344
.L2400:
	mov	w2, 1
	b	.L2344
.L2354:
	mov	w0, -1
	b	.L2472
.L2360:
	ldrh	w1, [x3]
	cmp	w1, w6
	beq	.L2358
	mov	w4, 56
	orr	w1, w23, w1, lsl 10
	umaddl	x4, w24, w4, x0
	str	w1, [x4, 4]
	ldrb	w7, [x19, 8]
	cmp	w7, 1
	bne	.L2359
	cbz	w5, .L2359
	orr	w1, w1, -2147483648
	str	w1, [x4, 4]
.L2359:
	add	w24, w24, 1
	and	w24, w24, 65535
.L2358:
	add	x3, x3, 2
	b	.L2357
.L2387:
	ldr	x4, [x22, #:lo12:.LANCHOR180]
	add	x4, x4, x25
	ldr	w5, [x4, 4]
	str	w5, [x29, 204]
	lsr	w0, w5, 10
	bl	P2V_plane
	and	w0, w0, 65535
	cmp	w23, w26
	bcc	.L2362
	ldr	w1, [x29, 180]
	ccmp	w1, w0, 0, eq
	bhi	.L2362
	cmp	w23, w20
	ccmp	w27, w0, 0, eq
	beq	.L2363
	ldr	w0, [x4]
	cmn	w0, #1
	beq	.L2364
	ldr	x3, [x4, 16]
	mov	w0, 61589
	ldrh	w1, [x3]
	cmp	w1, w0
	beq	.L2365
	ldrh	w0, [x19]
.L2474:
	bl	decrement_vpc_count
	b	.L2362
.L2365:
	ldr	w21, [x3, 4]
	cmn	w21, #1
	beq	.L2366
	ldr	x0, [x29, 168]
	ldr	w1, [x0, #:lo12:.LANCHOR160]
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L2366
	ldr	x1, [x29, 168]
	add	w0, w21, 1
	str	w0, [x1, #:lo12:.LANCHOR160]
.L2366:
	ldp	w24, w0, [x3, 8]
	add	x1, x29, 200
	str	w0, [x29, 196]
	mov	w2, 0
	mov	w0, w24
	bl	log2phys
	ldr	w1, [x28, #:lo12:.LANCHOR136]
	ldr	w3, [x29, 196]
	cmn	w1, #1
	beq	.L2367
	mov	w0, w21
	bl	ftl_cmp_data_ver
	cbz	w0, .L2367
	cmn	w3, #1
	beq	.L2368
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
	bne	.L2369
.L2370:
	mov	w0, -1
	str	w0, [x29, 196]
.L2377:
	ldr	w3, [x29, 196]
	cmn	w3, #1
	beq	.L2362
.L2393:
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	and	w24, w0, 65535
	adrp	x0, .LANCHOR40
	mov	w3, w24
	ldrh	w0, [x0, #:lo12:.LANCHOR40]
	cmp	w0, w24
	bhi	.L2383
	mov	w2, 2456
	adrp	x1, .LANCHOR233
	adrp	x0, .LC5
	add	x1, x1, :lo12:.LANCHOR233
	add	x0, x0, :lo12:.LC5
	str	w24, [x29, 152]
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
	ldr	w3, [x29, 152]
.L2383:
	adrp	x1, .LANCHOR83
	ubfiz	x0, x24, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR83]
	ldrh	w0, [x1, x0]
	cbz	w0, .L2384
	mov	w0, w3
	b	.L2474
.L2368:
	ldp	w1, w0, [x29, 200]
	cmp	w1, w0
	bne	.L2362
	mov	w2, 1
	add	x1, x29, 196
	mov	w0, w24
	bl	log2phys
.L2362:
	add	x25, x25, 56
	b	.L2361
.L2369:
	ldr	w0, [x4, 8]
	cmp	w24, w0
	bne	.L2370
	ldr	w0, [x4, 4]
	str	w0, [x29, 152]
	str	x4, [x29, 104]
	uxtw	x1, w0
	ldr	w0, [x28, #:lo12:.LANCHOR136]
	bl	ftl_cmp_data_ver
	cbz	w0, .L2370
	ldp	w0, w1, [x29, 200]
	ldr	x4, [x29, 104]
	cmp	w0, w1
	ldr	w1, [x29, 196]
	bne	.L2372
.L2473:
	mov	w0, w24
	bl	FtlReUsePrevPpa
	b	.L2370
.L2372:
	cmp	w0, w1
	beq	.L2370
	cmn	w0, #1
	beq	.L2373
	ldr	x4, [x3, 16]
	mov	w2, 0
	str	w0, [x3, 4]
	mov	w1, 1
	str	x4, [x29, 104]
	mov	x0, x3
	bl	FlashReadPages
	ldr	x4, [x29, 104]
.L2374:
	ldr	x0, [x22, #:lo12:.LANCHOR180]
	ldr	w0, [x0, x25]
	cmn	w0, #1
	beq	.L2375
	ldr	x0, [x29, 112]
	ldr	w3, [x4, 4]
	mov	w1, w3
	ldr	w0, [x0]
	bl	ftl_cmp_data_ver
	cbz	w0, .L2375
	ldr	w0, [x29, 152]
	mov	w1, w3
	bl	ftl_cmp_data_ver
	cbz	w0, .L2370
.L2375:
	ldr	w1, [x29, 196]
	b	.L2473
.L2373:
	str	w0, [x3]
	b	.L2374
.L2367:
	ldp	w1, w0, [x29, 200]
	cmp	w1, w0
	beq	.L2377
	adrp	x0, .LANCHOR43
	ldr	w0, [x0, #:lo12:.LANCHOR43]
	cmp	w0, w3, lsr 10
	bhi	.L2379
	cmn	w3, #1
	bne	.L2362
.L2379:
	mov	w2, 1
	add	x1, x29, 204
	mov	w0, w24
	bl	log2phys
	ldr	w3, [x29, 200]
	cmn	w3, #1
	beq	.L2377
	ldr	w0, [x29, 196]
	cmp	w3, w0
	beq	.L2393
	lsr	w0, w3, 10
	bl	P2V_block_in_plane
	adrp	x1, .LANCHOR91
	and	w0, w0, 65535
	ldrh	w1, [x1, #:lo12:.LANCHOR91]
	cmp	w1, w0
	beq	.L2382
	adrp	x1, .LANCHOR92
	ldrh	w1, [x1, #:lo12:.LANCHOR92]
	cmp	w1, w0
	beq	.L2382
	adrp	x1, .LANCHOR93
	ldrh	w1, [x1, #:lo12:.LANCHOR93]
	cmp	w1, w0
	bne	.L2377
.L2382:
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
	beq	.L2377
	ldr	x4, [x29, 152]
	mov	w0, w21
	ldr	w1, [x4, 4]
	bl	ftl_cmp_data_ver
	cbnz	w0, .L2377
	mov	w2, 1
	add	x1, x29, 200
	mov	w0, w24
	bl	log2phys
	b	.L2377
.L2384:
	mov	w1, w24
	adrp	x0, .LC61
	add	x0, x0, :lo12:.LC61
	bl	printf
	b	.L2362
.L2364:
	ldr	x1, [x29, 120]
	mov	w2, w21
	ldrh	w0, [x19]
	strh	w0, [x1]
	mov	w1, w5
	adrp	x0, .LC62
	add	x0, x0, :lo12:.LC62
	bl	printf
	adrp	x2, .LANCHOR236
	ldr	w0, [x2, #:lo12:.LANCHOR236]
	cmp	w0, 31
	bhi	.L2385
	adrp	x1, .LANCHOR237
	add	x1, x1, :lo12:.LANCHOR237
	ldr	w3, [x29, 204]
	str	w3, [x1, w0, uxtw 2]
	add	w0, w0, 1
	str	w0, [x2, #:lo12:.LANCHOR236]
.L2385:
	ldrh	w0, [x19]
	bl	decrement_vpc_count
	ldr	w0, [x28, #:lo12:.LANCHOR136]
	cmn	w0, #1
	bne	.L2386
.L2475:
	str	w21, [x28, #:lo12:.LANCHOR136]
	b	.L2362
.L2386:
	cmp	w21, w0
	bcs	.L2362
	b	.L2475
.L2390:
	add	w0, w0, 1
	and	w0, w0, 65535
	b	.L2389
.L2363:
	strb	w27, [x19, 6]
	strh	w20, [x19, 2]
	b	.L2477
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
	.section	.text.FtlGcScanTempBlk,"ax",@progbits
	.align	2
	.global	FtlGcScanTempBlk
	.type	FtlGcScanTempBlk, %function
FtlGcScanTempBlk:
	stp	x29, x30, [sp, -176]!
	add	x29, sp, 0
	stp	x23, x24, [sp, 48]
	adrp	x23, .LANCHOR238
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldrh	w20, [x23, #:lo12:.LANCHOR238]
	mov	w0, 65535
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	cmp	w20, w0
	stp	x27, x28, [sp, 80]
	beq	.L2504
	cbnz	w20, .L2480
.L2481:
	bl	FtlGcPageVarInit
	b	.L2482
.L2504:
	mov	w20, 0
.L2480:
	adrp	x0, .LANCHOR52
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w1
	beq	.L2481
.L2482:
	adrp	x24, .LANCHOR72
	add	x24, x24, :lo12:.LANCHOR72
	mov	w26, -1
.L2483:
	ldrh	w1, [x19]
	mov	w0, 65535
	strb	wzr, [x19, 8]
	cmp	w1, w0
	beq	.L2484
	mov	w27, 56
.L2503:
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
.L2485:
	cmp	x3, x1
	bne	.L2487
	mov	w1, w21
	mov	w2, 0
	bl	FlashReadPages
	adrp	x25, .LANCHOR1
	umull	x0, w21, w27
	mov	x21, 0
	str	x0, [x29, 104]
	add	x0, x25, :lo12:.LANCHOR1
	str	x0, [x29, 96]
.L2488:
	ldr	x0, [x29, 104]
	cmp	x0, x21
	bne	.L2502
	adrp	x0, .LANCHOR52
	add	w20, w20, 1
	and	w20, w20, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR52]
	cmp	w0, w20
	bhi	.L2503
.L2484:
	strh	w20, [x19, 2]
	mov	w0, -1
	strb	wzr, [x19, 6]
	mov	w1, w20
	strh	w0, [x23, #:lo12:.LANCHOR238]
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
.L2487:
	ldrh	w2, [x3]
	cmp	w2, w10
	beq	.L2486
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
.L2486:
	add	x3, x3, 2
	b	.L2485
.L2502:
	ldr	x1, [x22, #:lo12:.LANCHOR180]
	add	x0, x1, x21
	ldr	w1, [x1, x21]
	ldr	w28, [x0, 4]
	cbnz	w1, .L2489
	ldr	x25, [x0, 16]
	mov	w0, 65535
	ldrh	w1, [x25]
	cmp	w1, w0
	beq	.L2518
	ldr	w1, [x24]
	ldr	w0, [x25, 8]
	cmp	w0, w1
	bls	.L2491
.L2518:
	adrp	x0, .LANCHOR83
	ldrh	w1, [x19]
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	strh	wzr, [x0, x1, lsl 1]
.L2517:
	ldrh	w0, [x19]
	mov	w20, 0
	bl	INSERT_FREE_LIST
	mov	w0, -1
	strh	w0, [x19]
	bl	FtlGcPageVarInit
	b	.L2483
.L2491:
	ldr	x1, [x29, 96]
	ldrb	w1, [x1]
	cbnz	w1, .L2493
.L2494:
	ldp	w2, w0, [x25, 8]
	mov	w1, w28
	add	x21, x21, 56
	bl	FtlGcUpdatePage
	b	.L2488
.L2493:
	add	x1, x29, 116
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x25, 12]
	ldr	w1, [x29, 116]
	cmp	w0, w1
	bne	.L2494
	cmn	w0, #1
	beq	.L2494
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
.L2495:
	cmp	x0, x1
	beq	.L2494
	ldr	x6, [x2, 8]
	ldr	w7, [x6, x0]
	add	x0, x0, 4
	add	x6, x5, x0
	ldr	w6, [x6, -4]
	cmp	w7, w6
	beq	.L2495
	ldrh	w1, [x19]
	adrp	x0, .LC63
	ldr	w2, [x29, 124]
	add	x0, x0, :lo12:.LC63
	bl	printf
	b	.L2518
.L2489:
	ldrh	w1, [x19]
	mov	w2, w28
	adrp	x0, .LC64
	add	x0, x0, :lo12:.LC64
	bl	printf
	adrp	x0, .LANCHOR28
	ldr	w1, [x0, #:lo12:.LANCHOR28]
	ldrh	w0, [x19]
	cbnz	w1, .L2498
	adrp	x1, .LANCHOR15
	ldrb	w1, [x1, #:lo12:.LANCHOR15]
	cbz	w1, .L2499
.L2498:
	adrp	x2, .LANCHOR78
	ubfiz	x1, x0, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR78]
	ldrh	w1, [x2, x1]
	cmp	w1, 159
	bls	.L2500
.L2499:
	ldr	x1, [x22, #:lo12:.LANCHOR180]
	ldr	w1, [x1, x21]
	cmn	w1, #1
	bne	.L2501
.L2500:
	ldr	x1, [x22, #:lo12:.LANCHOR180]
	add	x3, x1, x21
	ldr	w26, [x3, 4]
.L2501:
	adrp	x1, .LANCHOR83
	ubfiz	x0, x0, 1, 16
	ldr	x1, [x1, #:lo12:.LANCHOR83]
	strh	wzr, [x1, x0]
	b	.L2517
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
	.section	.text.FtlGcFreeTempBlock,"ax",@progbits
	.align	2
	.global	FtlGcFreeTempBlock
	.type	FtlGcFreeTempBlock, %function
FtlGcFreeTempBlock:
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbz	w0, .L2520
	mov	w0, 0
	ret
.L2520:
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
	str	x27, [sp, 80]
	beq	.L2522
	adrp	x1, .LANCHOR52
	ldrh	w1, [x1, #:lo12:.LANCHOR52]
	bl	FtlGcScanTempBlk
	str	w0, [x29, 108]
	cmn	w0, #1
	beq	.L2522
	adrp	x0, .LANCHOR78
	ubfiz	x20, x20, 1, 16
	ldr	x1, [x0, #:lo12:.LANCHOR78]
	ldrh	w0, [x1, x20]
	cmp	w0, 4
	bls	.L2523
	sub	w0, w0, #5
	strh	w0, [x1, x20]
	mov	w0, 1
	bl	FtlEctTblFlush
.L2523:
	ldr	w0, [x21, #:lo12:.LANCHOR135]
	cbnz	w0, .L2524
	adrp	x0, .LANCHOR138
	add	x0, x0, :lo12:.LANCHOR138
	ldr	w1, [x0, 96]
	add	w1, w1, 1
	str	w1, [x0, 96]
	ldr	w0, [x29, 108]
	lsr	w0, w0, 10
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L2524:
	str	wzr, [x21, #:lo12:.LANCHOR135]
	mov	w0, 1
.L2519:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
.L2522:
	str	wzr, [x21, #:lo12:.LANCHOR135]
	mov	w0, 65535
	ldrh	w1, [x19, #:lo12:.LANCHOR93]
	add	x21, x19, :lo12:.LANCHOR93
	cmp	w1, w0
	beq	.L2545
	bl	FtlCacheWriteBack
	adrp	x20, .LANCHOR110
	adrp	x0, .LANCHOR52
	ldrb	w1, [x21, 7]
	ldrh	w2, [x20, #:lo12:.LANCHOR110]
	mov	x21, x0
	ldrh	w3, [x0, #:lo12:.LANCHOR52]
	mul	w1, w1, w3
	cmp	w2, w1
	beq	.L2526
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
.L2526:
	add	x0, x19, :lo12:.LANCHOR93
	adrp	x23, .LANCHOR83
	ldrh	w3, [x21, #:lo12:.LANCHOR52]
	adrp	x25, .LANCHOR72
	ldrh	w2, [x19, #:lo12:.LANCHOR93]
	adrp	x26, .LANCHOR239
	ldrb	w0, [x0, 7]
	add	x25, x25, :lo12:.LANCHOR72
	ldr	x1, [x23, #:lo12:.LANCHOR83]
	add	x26, x26, :lo12:.LANCHOR239
	mov	w21, 0
	mul	w0, w0, w3
	strh	w0, [x1, x2, lsl 1]
	adrp	x1, .LANCHOR161
	ldrh	w0, [x20, #:lo12:.LANCHOR110]
	ldr	w2, [x1, #:lo12:.LANCHOR161]
	add	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR161]
.L2527:
	ldrh	w0, [x20, #:lo12:.LANCHOR110]
	cmp	w0, w21
	bhi	.L2531
	mov	w0, -1
	bl	decrement_vpc_count
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L2532
	ldrh	w1, [x19, #:lo12:.LANCHOR93]
	adrp	x0, .LC65
	add	x0, x0, :lo12:.LC65
	bl	printf
.L2532:
	ldrh	w0, [x19, #:lo12:.LANCHOR93]
	ldr	x2, [x23, #:lo12:.LANCHOR83]
	ubfiz	x1, x0, 1, 16
	ldrh	w1, [x2, x1]
	cbz	w1, .L2533
	bl	INSERT_DATA_LIST
.L2534:
	adrp	x0, .LANCHOR108
	mov	w21, -1
	strh	wzr, [x20, #:lo12:.LANCHOR110]
	strh	w21, [x19, #:lo12:.LANCHOR93]
	strh	wzr, [x0, #:lo12:.LANCHOR108]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	adrp	x0, .LANCHOR204
	strh	w21, [x0, #:lo12:.LANCHOR204]
	adrp	x0, .LANCHOR88
	ldrh	w1, [x0, #:lo12:.LANCHOR88]
	adrp	x0, .LANCHOR223
	ldrh	w0, [x0, #:lo12:.LANCHOR223]
	add	w0, w0, w0, lsl 1
	cmp	w1, w0, lsr 2
	ble	.L2545
	adrp	x0, .LANCHOR176
	mov	w1, 20
	strh	w1, [x0, #:lo12:.LANCHOR176]
.L2545:
	mov	w0, 0
	b	.L2519
.L2531:
	adrp	x0, .LANCHOR111
	mov	w24, 12
	ldr	x27, [x0, #:lo12:.LANCHOR111]
	umull	x24, w21, w24
	ldr	w0, [x25]
	add	x22, x27, x24
	ldr	w1, [x22, 8]
	cmp	w1, w0
	bcc	.L2528
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
.L2528:
	ldr	w0, [x22, 8]
	add	x1, x29, 108
	mov	w2, 0
	bl	log2phys
	ldr	w0, [x27, x24]
	ldr	w1, [x29, 108]
	cmp	w0, w1
	bne	.L2529
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	mov	w24, w0
	ldr	w0, [x22, 8]
	mov	w2, 1
	add	x1, x22, 4
	bl	log2phys
	mov	w0, w24
.L2544:
	bl	decrement_vpc_count
.L2530:
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L2527
.L2529:
	ldr	w0, [x22, 4]
	cmp	w1, w0
	beq	.L2530
	ldrh	w0, [x19, #:lo12:.LANCHOR93]
	b	.L2544
.L2533:
	bl	INSERT_FREE_LIST
	b	.L2534
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
	beq	.L2547
	add	x1, x0, :lo12:.LANCHOR93
	ldrh	w0, [x1, 4]
	cbnz	w0, .L2548
.L2547:
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
.L2548:
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
	cbz	w0, .L2551
	mov	w0, 0
	ret
.L2554:
	mov	w0, 0
.L2550:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2551:
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR15
	add	x29, sp, 0
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR102
	cbz	w0, .L2553
	ldr	w0, [x19, #:lo12:.LANCHOR102]
	tbz	x0, 0, .L2553
	adrp	x0, .LANCHOR93+4
	ldrh	w0, [x0, #:lo12:.LANCHOR93+4]
	cbnz	w0, .L2554
.L2553:
	adrp	x20, .LANCHOR181
	ldr	w1, [x19, #:lo12:.LANCHOR102]
	mov	w3, 0
	mov	w2, 0
	ldr	x0, [x20, #:lo12:.LANCHOR181]
	add	x19, x19, :lo12:.LANCHOR102
	bl	FlashProgPages
	mov	w11, 0
	mov	w12, 56
.L2555:
	ldr	w1, [x19]
	cmp	w11, w1
	bcc	.L2557
	ldr	x0, [x20, #:lo12:.LANCHOR181]
	bl	FtlGcBufFree
	str	wzr, [x19]
	adrp	x0, .LANCHOR93+4
	ldrh	w0, [x0, #:lo12:.LANCHOR93+4]
	cbnz	w0, .L2554
	mov	w0, 1
	bl	FtlGcFreeTempBlock
	b	.L2567
.L2557:
	umull	x0, w11, w12
	ldr	x2, [x20, #:lo12:.LANCHOR181]
	add	x1, x2, x0
	ldr	w2, [x2, x0]
	cmn	w2, #1
	bne	.L2556
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
.L2567:
	mov	w0, 1
	b	.L2550
.L2556:
	ldr	x0, [x1, 16]
	ldr	w1, [x1, 4]
	ldp	w2, w0, [x0, 8]
	bl	FtlGcUpdatePage
	add	w11, w11, 1
	and	w11, w11, 65535
	b	.L2555
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
	bcc	.L2568
	adrp	x0, .LANCHOR127
	add	x0, x0, :lo12:.LANCHOR127
	bl	FtlMapBlkWriteDumpData
	mov	w0, 0
	bl	FtlGcFreeTempBlock
	adrp	x0, .LANCHOR135
	str	wzr, [x0, #:lo12:.LANCHOR135]
.L2568:
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
	adrp	x0, .LANCHOR236
	add	x29, sp, 0
	str	x19, [sp, 16]
	adrp	x19, .LANCHOR91
	add	x19, x19, :lo12:.LANCHOR91
	str	wzr, [x0, #:lo12:.LANCHOR236]
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
	adrp	x0, .LANCHOR234
	mov	w1, -1
	add	x29, sp, 0
	strh	w1, [x0, #:lo12:.LANCHOR234]
	adrp	x0, .LANCHOR39
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR235
	ldrh	w0, [x0, #:lo12:.LANCHOR39]
	strh	wzr, [x20, #:lo12:.LANCHOR235]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	adrp	x0, .LANCHOR209
	ldrh	w1, [x0, #:lo12:.LANCHOR209]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2574
.L2576:
	mov	w19, -1
.L2573:
	mov	w0, w19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2574:
	bl	FtlLoadSysInfo
	mov	w19, w0
	cbnz	w0, .L2576
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	mov	w0, 1
	bl	FtlUpdateVaildLpn
	adrp	x2, .LANCHOR67
	adrp	x0, .LANCHOR96
	mov	x3, 4
	ldrh	w2, [x2, #:lo12:.LANCHOR67]
	ldr	x0, [x0, #:lo12:.LANCHOR96]
	add	x2, x3, x2, uxtw 4
	add	x1, x0, 4
	add	x0, x0, x2
.L2577:
	cmp	x1, x0
	bne	.L2579
	ldrh	w0, [x20, #:lo12:.LANCHOR235]
	cbnz	w0, .L2578
	bl	l2p_flush
	b	.L2582
.L2579:
	ldr	w2, [x1], 16
	tbz	w2, #31, .L2577
.L2578:
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
.L2582:
	bl	FtlVpcTblFlush
	b	.L2573
	.size	FtlSysBlkInit, .-FtlSysBlkInit
	.section	.text.FtlLowFormat,"ax",@progbits
	.align	2
	.global	FtlLowFormat
	.type	FtlLowFormat, %function
FtlLowFormat:
	adrp	x0, .LANCHOR76
	ldr	w0, [x0, #:lo12:.LANCHOR76]
	cbnz	w0, .L2615
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
	cbz	w0, .L2586
	bl	FtlMakeBbt
.L2586:
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
.L2587:
	cmp	w0, w1
	blt	.L2588
	adrp	x21, .LANCHOR40
	adrp	x19, .LANCHOR41
	add	x26, x19, :lo12:.LANCHOR41
	mov	w23, 0
	ldrh	w24, [x21, #:lo12:.LANCHOR40]
.L2589:
	ldrh	w0, [x26]
	cmp	w0, w24
	bhi	.L2590
	adrp	x24, .LANCHOR38
	sub	w1, w23, #2
	ldrh	w0, [x24, #:lo12:.LANCHOR38]
	cmp	w1, w0, lsl 1
	bgt	.L2591
.L2595:
	add	x26, x21, :lo12:.LANCHOR40
	mov	w23, 0
	mov	w25, 0
.L2592:
	ldrh	w0, [x26]
	cmp	w0, w25
	bhi	.L2596
	adrp	x0, .LANCHOR73
	ldrh	w1, [x19, #:lo12:.LANCHOR41]
	ldrh	w3, [x24, #:lo12:.LANCHOR38]
	str	w1, [x0, #:lo12:.LANCHOR73]
	adrp	x0, .LANCHOR42
	adrp	x1, .LANCHOR223
	ldr	w2, [x0, #:lo12:.LANCHOR42]
	adrp	x0, .LANCHOR72
	udiv	w6, w2, w3
	ubfx	x5, x6, 5, 16
	str	w6, [x0, #:lo12:.LANCHOR72]
	add	w4, w5, 36
	strh	w4, [x1, #:lo12:.LANCHOR223]
	mov	w4, 24
	mul	w4, w3, w4
	cmp	w23, w4
	ble	.L2597
	sub	w2, w2, w23
	udiv	w2, w2, w3
	str	w2, [x0, #:lo12:.LANCHOR72]
	lsr	w2, w2, 5
	add	w2, w2, 24
	strh	w2, [x1, #:lo12:.LANCHOR223]
.L2597:
	adrp	x2, .LANCHOR28
	ldr	w2, [x2, #:lo12:.LANCHOR28]
	cmp	w2, 1
	bne	.L2598
	udiv	w4, w23, w3
	ldrh	w2, [x1, #:lo12:.LANCHOR223]
	add	w4, w4, w2
	add	w4, w2, w4, asr 2
	strh	w4, [x1, #:lo12:.LANCHOR223]
.L2598:
	adrp	x2, .LANCHOR15
	ldrb	w2, [x2, #:lo12:.LANCHOR15]
	cbz	w2, .L2599
	udiv	w4, w23, w3
	ldrh	w2, [x1, #:lo12:.LANCHOR223]
	add	w4, w4, w2
	add	w4, w2, w4, asr 2
	strh	w4, [x1, #:lo12:.LANCHOR223]
.L2599:
	adrp	x2, .LANCHOR49
	ldrh	w2, [x2, #:lo12:.LANCHOR49]
	cbz	w2, .L2601
	ldrh	w4, [x1, #:lo12:.LANCHOR223]
	add	w4, w4, w2, lsr 1
	strh	w4, [x1, #:lo12:.LANCHOR223]
	mul	w4, w2, w3
	cmp	w23, w4
	bge	.L2601
	add	w2, w2, 32
	str	w6, [x0, #:lo12:.LANCHOR72]
	add	w2, w5, w2
	strh	w2, [x1, #:lo12:.LANCHOR223]
.L2601:
	ldrh	w2, [x1, #:lo12:.LANCHOR223]
	adrp	x25, .LANCHOR222
	ldr	w1, [x0, #:lo12:.LANCHOR72]
	adrp	x24, .LANCHOR83
	mov	w23, -1
	sub	w1, w1, w2
	mul	w3, w1, w3
	adrp	x1, .LANCHOR52
	str	w3, [x25, #:lo12:.LANCHOR222]
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
	adrp	x1, .LANCHOR204
	ldrh	w2, [x21, #:lo12:.LANCHOR40]
	str	wzr, [x0, #:lo12:.LANCHOR100]
	add	x0, x1, :lo12:.LANCHOR204
	strh	w23, [x1, #:lo12:.LANCHOR204]
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
	adrp	x0, .LANCHOR0
	strh	wzr, [x19, 2]
	ldr	x0, [x0, #:lo12:.LANCHOR0]
	strb	wzr, [x19, 6]
	bl	ftl_memset
.L2603:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L2604
	ldr	x1, [x24, #:lo12:.LANCHOR83]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L2603
.L2588:
	ubfiz	x3, x0, 2, 16
	mvn	w2, w0
	orr	w2, w0, w2, lsl 16
	add	w0, w0, 1
	and	w0, w0, 65535
	str	w2, [x4, x3]
	str	w6, [x5, x3]
	b	.L2587
.L2590:
	mov	w0, w24
	mov	w1, 1
	add	w24, w24, 1
	bl	FtlLowFormatEraseBlock
	add	w23, w23, w0
	and	w24, w24, 65535
	and	w23, w23, 65535
	b	.L2589
.L2591:
	udiv	w0, w23, w0
	adrp	x1, .LANCHOR65
	ldr	w23, [x1, #:lo12:.LANCHOR65]
	add	w0, w0, w23
	bl	FtlSysBlkNumInit
	ldrh	w0, [x25, #:lo12:.LANCHOR39]
	add	x25, x19, :lo12:.LANCHOR41
	bl	FtlFreeSysBlkQueueInit
	ldrh	w23, [x21, #:lo12:.LANCHOR40]
.L2593:
	ldrh	w0, [x25]
	cmp	w0, w23
	bls	.L2595
	mov	w0, w23
	add	w23, w23, 1
	mov	w1, 1
	and	w23, w23, 65535
	bl	FtlLowFormatEraseBlock
	b	.L2593
.L2596:
	mov	w0, w25
	mov	w1, 0
	add	w25, w25, 1
	bl	FtlLowFormatEraseBlock
	add	w23, w23, w0
	and	w25, w25, 65535
	and	w23, w23, 65535
	b	.L2592
.L2604:
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
.L2605:
	mov	x0, x19
	bl	make_superblock
	ldrb	w1, [x19, 7]
	ldrh	w0, [x19]
	cbnz	w1, .L2606
	ldr	x1, [x24, #:lo12:.LANCHOR83]
	ubfiz	x0, x0, 1, 16
	strh	w23, [x1, x0]
	ldrh	w0, [x19]
	add	w0, w0, 1
	strh	w0, [x19]
	b	.L2605
.L2606:
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
	cbnz	w0, .L2585
	adrp	x0, .LANCHOR230
	mov	w1, 1
	str	w1, [x0, #:lo12:.LANCHOR230]
.L2585:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 80
	ret
.L2615:
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
	cbnz	w1, .L2670
	stp	x29, x30, [sp, -192]!
	add	x29, sp, 0
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR171
	stp	x19, x20, [sp, 16]
	ldr	w1, [x21, #:lo12:.LANCHOR171]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	cbnz	w1, .L2672
	adrp	x1, .LANCHOR85
	ldrh	w1, [x1, #:lo12:.LANCHOR85]
	cmp	w1, 47
	bls	.L2672
	adrp	x5, .LANCHOR113
	mov	w2, 65535
	ldrh	w8, [x5, #:lo12:.LANCHOR113]
	cmp	w8, w2
	beq	.L2620
	adrp	x7, .LANCHOR112
	ldrh	w1, [x7, #:lo12:.LANCHOR112]
	cmp	w1, w2
	bne	.L2620
	adrp	x3, .LANCHOR114
	ldrh	w6, [x3, #:lo12:.LANCHOR114]
	cmp	w6, w1
	beq	.L2620
	adrp	x2, .LANCHOR115
	ldrh	w4, [x2, #:lo12:.LANCHOR115]
	cmp	w4, w1
	beq	.L2620
	mov	w1, -1
	strh	w8, [x7, #:lo12:.LANCHOR112]
	strh	w6, [x5, #:lo12:.LANCHOR113]
	strh	w4, [x3, #:lo12:.LANCHOR114]
	strh	w1, [x2, #:lo12:.LANCHOR115]
.L2620:
	cbnz	w0, .L2673
	adrp	x0, .LANCHOR88
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w0, 24
	bhi	.L2674
	adrp	x1, .LANCHOR52
	cmp	w0, 16
	ldrh	w20, [x1, #:lo12:.LANCHOR52]
	bls	.L2623
	lsr	w20, w20, 5
.L2622:
	adrp	x2, .LANCHOR176
	mov	x3, x2
	ldrh	w1, [x2, #:lo12:.LANCHOR176]
	cmp	w1, w0
	bcs	.L2626
	adrp	x0, .LANCHOR93
	mov	w1, 65535
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w0, w1
	bne	.L2627
	adrp	x1, .LANCHOR112
	ldrh	w1, [x1, #:lo12:.LANCHOR112]
	cmp	w1, w0
	bne	.L2627
	adrp	x0, .LANCHOR240
	ldrh	w0, [x0, #:lo12:.LANCHOR240]
	cbnz	w0, .L2628
	adrp	x1, .LANCHOR72
	adrp	x4, .LANCHOR100
	ldr	w1, [x1, #:lo12:.LANCHOR72]
	ldr	w4, [x4, #:lo12:.LANCHOR100]
	add	w1, w1, w1, lsl 1
	cmp	w4, w1, lsr 2
	bcs	.L2629
.L2628:
	adrp	x1, .LANCHOR223
	ldrh	w1, [x1, #:lo12:.LANCHOR223]
	add	w1, w1, w1, lsl 1
	asr	w1, w1, 2
	strh	w1, [x3, #:lo12:.LANCHOR176]
.L2630:
	adrp	x1, .LANCHOR172
	str	wzr, [x1, #:lo12:.LANCHOR172]
.L2618:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
.L2623:
	cmp	w0, 12
	bls	.L2624
	lsr	w20, w20, 4
	b	.L2622
.L2624:
	cmp	w0, 8
	bls	.L2622
	lsr	w20, w20, 2
	b	.L2622
.L2674:
	mov	w20, 1
	b	.L2622
.L2629:
	mov	w1, 18
	strh	w1, [x2, #:lo12:.LANCHOR176]
	b	.L2630
.L2627:
	adrp	x0, .LANCHOR223
	ldrh	w0, [x0, #:lo12:.LANCHOR223]
	add	w0, w0, w0, lsl 1
	asr	w0, w0, 2
	strh	w0, [x3, #:lo12:.LANCHOR176]
.L2626:
	adrp	x0, .LANCHOR116
	ldrh	w0, [x0, #:lo12:.LANCHOR116]
	cbz	w0, .L2621
	add	w20, w20, 32
	and	w20, w20, 65535
.L2621:
	adrp	x19, .LANCHOR204
	mov	w0, 65535
	ldrh	w2, [x19, #:lo12:.LANCHOR204]
	cmp	w2, w0
	bne	.L2633
	adrp	x0, .LANCHOR112
	ldrh	w1, [x0, #:lo12:.LANCHOR112]
	cmp	w1, w2
	beq	.L2634
	adrp	x2, .LANCHOR83
	ubfiz	x1, x1, 1, 16
	ldr	x2, [x2, #:lo12:.LANCHOR83]
	ldrh	w1, [x2, x1]
	cbnz	w1, .L2635
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR112]
.L2635:
	ldrh	w1, [x0, #:lo12:.LANCHOR112]
	strh	w1, [x19, #:lo12:.LANCHOR204]
	mov	w1, -1
	strh	w1, [x0, #:lo12:.LANCHOR112]
.L2634:
	add	x0, x19, :lo12:.LANCHOR204
	mov	w1, 65535
	strb	wzr, [x0, 8]
	ldrh	w0, [x19, #:lo12:.LANCHOR204]
	cmp	w0, w1
	beq	.L2633
	bl	IsBlkInGcList
	cbz	w0, .L2637
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR204]
.L2637:
	adrp	x0, .LANCHOR15
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbz	w0, .L2638
	ldrh	w0, [x19, #:lo12:.LANCHOR204]
	add	x3, x19, :lo12:.LANCHOR204
	bl	ftl_get_blk_mode
	strb	w0, [x3, 8]
.L2638:
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	mov	w0, 65535
	add	x22, x19, :lo12:.LANCHOR204
	cmp	w1, w0
	beq	.L2633
	mov	x0, x22
	bl	make_superblock
	adrp	x0, .LANCHOR241
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	strh	wzr, [x22, 2]
	strh	wzr, [x0, #:lo12:.LANCHOR241]
	adrp	x0, .LANCHOR83
	strb	wzr, [x22, 6]
	ldr	x0, [x0, #:lo12:.LANCHOR83]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR242
	strh	w1, [x0, #:lo12:.LANCHOR242]
.L2633:
	adrp	x0, .LANCHOR91
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	str	x0, [x29, 144]
	ldrh	w2, [x0, #:lo12:.LANCHOR91]
	cmp	w2, w1
	beq	.L2639
	adrp	x0, .LANCHOR92
	str	x0, [x29, 136]
	ldrh	w2, [x0, #:lo12:.LANCHOR92]
	cmp	w2, w1
	beq	.L2639
	adrp	x25, .LANCHOR178
	add	x26, x25, :lo12:.LANCHOR178
.L2640:
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	mov	w0, 65535
	cmp	w1, w0
	bne	.L2641
	adrp	x0, .LANCHOR172
	adrp	x22, .LANCHOR52
	add	x22, x22, :lo12:.LANCHOR52
	str	wzr, [x0, #:lo12:.LANCHOR172]
.L2642:
	ldrh	w5, [x25, #:lo12:.LANCHOR178]
	add	x7, x25, :lo12:.LANCHOR178
	mov	w0, w5
	bl	List_get_gc_head_node
	and	w6, w0, 65535
	strh	w6, [x19, #:lo12:.LANCHOR204]
	mov	w0, 65535
	cmp	w6, w0
	bne	.L2643
	strh	wzr, [x7]
	mov	w0, 8
	b	.L2618
.L2673:
	mov	w20, 1
	b	.L2621
.L2639:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR204]
.L2709:
	adrp	x0, .LANCHOR240
	ldrh	w0, [x0, #:lo12:.LANCHOR240]
	b	.L2618
.L2643:
	mov	w0, w6
	bl	IsBlkInGcList
	add	w5, w5, 1
	cbz	w0, .L2644
	strh	w5, [x25, #:lo12:.LANCHOR178]
	b	.L2642
.L2644:
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
	bgt	.L2646
	cmp	w5, 48
	bls	.L2647
	cmp	w3, 8
	bls	.L2647
	adrp	x3, .LANCHOR108
	ldrh	w3, [x3, #:lo12:.LANCHOR108]
	cmp	w3, 35
	bhi	.L2647
.L2646:
	strh	wzr, [x26]
.L2647:
	ldrh	w1, [x2, x1]
	cmp	w0, w1
	bgt	.L2648
	ldrh	w0, [x26]
	cmp	w0, 3
	bhi	.L2648
	mov	w0, -1
	strh	wzr, [x26]
	strh	w0, [x19, #:lo12:.LANCHOR204]
	b	.L2709
.L2648:
	cbnz	w1, .L2649
	mov	w0, -1
	bl	decrement_vpc_count
	ldrh	w0, [x26]
	add	w0, w0, 1
	strh	w0, [x26]
	b	.L2642
.L2649:
	adrp	x0, .LANCHOR15
	add	x3, x19, :lo12:.LANCHOR204
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	strb	wzr, [x3, 8]
	cbz	w0, .L2650
	mov	w0, w6
	bl	ftl_get_blk_mode
	strb	w0, [x3, 8]
.L2650:
	ldr	x0, [x29, 144]
	ldrh	w0, [x0, #:lo12:.LANCHOR91]
	cmp	w0, w6
	bne	.L2651
	mov	w2, 893
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
.L2651:
	ldr	x0, [x29, 136]
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	ldrh	w0, [x0, #:lo12:.LANCHOR92]
	cmp	w1, w0
	bne	.L2652
	mov	w2, 894
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
.L2652:
	adrp	x0, .LANCHOR93
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	ldrh	w0, [x0, #:lo12:.LANCHOR93]
	cmp	w1, w0
	bne	.L2653
	mov	w2, 895
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
.L2653:
	add	x22, x19, :lo12:.LANCHOR204
	mov	x0, x22
	bl	make_superblock
	adrp	x0, .LANCHOR241
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	strh	wzr, [x0, #:lo12:.LANCHOR241]
	ldr	x0, [x23, #:lo12:.LANCHOR83]
	ldrh	w1, [x0, x1, lsl 1]
	adrp	x0, .LANCHOR242
	strh	wzr, [x22, 2]
	strh	w1, [x0, #:lo12:.LANCHOR242]
	strb	wzr, [x22, 6]
.L2641:
	adrp	x1, .LANCHOR52
	mov	w0, 1
	str	w0, [x21, #:lo12:.LANCHOR171]
	ldrh	w0, [x1, #:lo12:.LANCHOR52]
	str	w0, [x29, 172]
	adrp	x0, .LANCHOR15
	str	x1, [x29, 128]
	str	x0, [x29, 120]
	ldrb	w2, [x0, #:lo12:.LANCHOR15]
	cbz	w2, .L2654
	add	x0, x19, :lo12:.LANCHOR204
	ldrb	w0, [x0, 8]
	cmp	w0, 1
	bne	.L2654
	adrp	x0, .LANCHOR53
	ldrh	w0, [x0, #:lo12:.LANCHOR53]
	str	w0, [x29, 172]
.L2654:
	add	x0, x19, :lo12:.LANCHOR204
	ldr	w2, [x29, 172]
	ldrh	w0, [x0, 2]
	add	w1, w0, w20
	cmp	w1, w2
	ble	.L2655
	sub	w20, w2, w0
	and	w20, w20, 65535
.L2655:
	adrp	x0, .LANCHOR241
	mov	w28, 0
	add	x0, x0, :lo12:.LANCHOR241
	str	x0, [x29, 160]
.L2656:
	cmp	w20, w28, uxth
	bls	.L2664
	add	x1, x19, :lo12:.LANCHOR204
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
	b	.L2665
.L2658:
	ldrh	w3, [x1]
	cmp	w3, w6
	beq	.L2657
	umaddl	x8, w22, w5, x0
	add	w22, w22, 1
	and	w22, w22, 65535
	orr	w3, w4, w3, lsl 10
	str	w3, [x8, 4]
.L2657:
	add	w2, w2, 1
	add	x1, x1, 2
	and	w2, w2, 65535
.L2665:
	cmp	w2, w7
	bne	.L2658
	add	x1, x19, :lo12:.LANCHOR204
	adrp	x24, .LANCHOR102
	add	x24, x24, :lo12:.LANCHOR102
	ldrb	w2, [x1, 8]
	mov	w1, w22
	bl	FlashReadPages
	mov	w0, 56
	umull	x0, w22, w0
	mov	x22, 0
	str	x0, [x29, 152]
.L2659:
	ldr	x0, [x29, 152]
	cmp	x22, x0
	bne	.L2663
	add	w28, w28, 1
	b	.L2656
.L2663:
	ldr	x0, [x23, #:lo12:.LANCHOR106]
	add	x1, x0, x22
	ldr	w0, [x0, x22]
	cmn	w0, #1
	beq	.L2660
	ldr	x27, [x1, 16]
	mov	w0, 61589
	ldrh	w1, [x27]
	cmp	w1, w0
	bne	.L2660
	ldr	w4, [x27, 8]
	cmn	w4, #1
	bne	.L2661
	mov	w2, 934
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
.L2661:
	mov	w2, 0
	add	x1, x29, 188
	mov	w0, w4
	bl	log2phys
	ldr	x0, [x23, #:lo12:.LANCHOR106]
	ldr	w1, [x29, 188]
	add	x0, x0, x22
	and	w1, w1, 2147483647
	ldr	w2, [x0, 4]
	cmp	w1, w2
	bne	.L2660
	ldr	x1, [x29, 160]
	adrp	x4, .LANCHOR181
	ldr	x2, [x29, 160]
	ldr	x5, [x4, #:lo12:.LANCHOR181]
	ldr	w0, [x0, 24]
	ldrh	w1, [x1]
	add	w1, w1, 1
	strh	w1, [x2]
	ldr	w2, [x24]
	mov	w1, 56
	str	w1, [x29, 168]
	nop // between mem op and mult-accumulate
	umaddl	x2, w2, w1, x5
	stp	x4, x2, [x29, 104]
	str	w0, [x2, 24]
	bl	Ftl_get_new_temp_ppa
	ldp	x4, x2, [x29, 104]
	ldr	w1, [x29, 168]
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
	ldr	w1, [x29, 188]
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
	ldr	x0, [x29, 120]
	ldrb	w0, [x0, #:lo12:.LANCHOR15]
	cbnz	w0, .L2662
	ldrb	w1, [x12, 7]
	ldr	w0, [x24]
	cmp	w1, w0
	beq	.L2662
	ldrh	w0, [x12, 4]
	cbnz	w0, .L2660
.L2662:
	bl	Ftl_gc_temp_data_write_back
	cbz	w0, .L2660
.L2710:
	str	wzr, [x21, #:lo12:.LANCHOR171]
	b	.L2709
.L2660:
	add	x22, x22, 56
	b	.L2659
.L2664:
	add	x1, x19, :lo12:.LANCHOR204
	ldrh	w0, [x1, 2]
	add	w20, w20, w0
	ldr	w0, [x29, 172]
	and	w20, w20, 65535
	strh	w20, [x1, 2]
	cmp	w0, w20
	bhi	.L2666
	adrp	x0, .LANCHOR102
	ldr	w0, [x0, #:lo12:.LANCHOR102]
	cbz	w0, .L2667
	bl	Ftl_gc_temp_data_write_back
	cbnz	w0, .L2710
.L2667:
	adrp	x0, .LANCHOR241
	ldrh	w0, [x0, #:lo12:.LANCHOR241]
	cbnz	w0, .L2668
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	adrp	x20, .LANCHOR83
	add	x0, x19, :lo12:.LANCHOR204
	ldr	x3, [x20, #:lo12:.LANCHOR83]
	ubfiz	x2, x1, 1, 16
	ldrh	w4, [x3, x2]
	cbz	w4, .L2668
	adrp	x2, .LANCHOR242
	mov	w3, 0
	ldrh	w5, [x2, #:lo12:.LANCHOR242]
	ldrh	w2, [x0, 2]
	adrp	x0, .LC66
	add	x0, x0, :lo12:.LC66
	bl	printf
	ldrh	w1, [x19, #:lo12:.LANCHOR204]
	ldr	x0, [x20, #:lo12:.LANCHOR83]
	strh	wzr, [x0, x1, lsl 1]
	ldrh	w0, [x19, #:lo12:.LANCHOR204]
	bl	update_vpc_list
	bl	FtlCacheWriteBack
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2668:
	mov	w0, -1
	strh	w0, [x19, #:lo12:.LANCHOR204]
.L2666:
	adrp	x0, .LANCHOR88
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w0, 2
	bhi	.L2669
	ldr	x0, [x29, 128]
	ldrh	w20, [x0, #:lo12:.LANCHOR52]
	b	.L2640
.L2669:
	str	wzr, [x21, #:lo12:.LANCHOR171]
	add	w0, w0, 1
	b	.L2618
.L2670:
	mov	w0, 0
	ret
.L2672:
	mov	w0, 0
	b	.L2618
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
	.section	.text.FtlInit,"ax",@progbits
	.align	2
	.global	FtlInit
	.type	FtlInit, %function
FtlInit:
	stp	x29, x30, [sp, -32]!
	adrp	x1, .LC67
	add	x1, x1, :lo12:.LC67
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	adrp	x19, .LANCHOR230
	mov	x20, x0
	mov	w0, -1
	str	w0, [x19, #:lo12:.LANCHOR230]
	adrp	x0, .LANCHOR244
	str	wzr, [x0, #:lo12:.LANCHOR244]
	adrp	x0, .LANCHOR76
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
	cbz	w0, .L2712
	adrp	x1, .LANCHOR245
	adrp	x0, .LC68
	add	x1, x1, :lo12:.LANCHOR245
	add	x0, x0, :lo12:.LC68
.L2720:
	bl	printf
.L2713:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L2712:
	bl	FtlSysBlkInit
	cbz	w0, .L2714
	adrp	x1, .LANCHOR245
	adrp	x0, .LC69
	add	x1, x1, :lo12:.LANCHOR245
	add	x0, x0, :lo12:.LC69
	b	.L2720
.L2714:
	mov	w1, 1
	str	w1, [x19, #:lo12:.LANCHOR230]
	bl	rk_ftl_garbage_collect
	adrp	x0, .LANCHOR88
	ldrh	w0, [x0, #:lo12:.LANCHOR88]
	cmp	w0, 15
	bhi	.L2713
	mov	w19, 1024
.L2716:
	mov	w1, 1
	mov	w0, w1
	bl	rk_ftl_garbage_collect
	subs	w19, w19, #1
	bne	.L2716
	b	.L2713
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
	cbnz	w0, .L2722
	adrp	x0, .LANCHOR14
	add	x0, x0, :lo12:.LANCHOR14
	bl	FtlInit
.L2722:
	bl	idb_init
	mov	w1, w19
	adrp	x0, .LC70
	add	x0, x0, :lo12:.LC70
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
	cbz	w0, .L2739
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	str	x25, [sp, 64]
	adrp	x25, .LANCHOR234
	stp	x23, x24, [sp, 48]
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR83
	ldrh	w23, [x25, #:lo12:.LANCHOR234]
	ldr	x0, [x21, #:lo12:.LANCHOR83]
	mov	w1, w23
	stp	x19, x20, [sp, 16]
	ubfiz	x24, x23, 1, 16
	adrp	x19, .LC71
	ldrh	w2, [x0, x24]
	add	x0, x19, :lo12:.LC71
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
.L2726:
	subs	w20, w20, #1
	beq	.L2730
	mov	w1, 1
	mov	w0, w1
	bl	rk_ftl_garbage_collect
	ldr	x0, [x21, #:lo12:.LANCHOR83]
	ldrh	w0, [x0, x24]
	cbnz	w0, .L2726
.L2730:
	ldr	x0, [x21, #:lo12:.LANCHOR83]
	mov	w1, w23
	ldrh	w2, [x0, x24]
	add	x0, x19, :lo12:.LC71
	bl	printf
	ldr	x0, [x21, #:lo12:.LANCHOR83]
	ldrh	w19, [x0, x24]
	cbnz	w19, .L2728
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
.L2731:
	cmp	w0, w3
	bne	.L2733
	ldr	x0, [x21, #:lo12:.LANCHOR83]
	mov	w1, w23
	ldrh	w2, [x0, x24]
	adrp	x0, .LC72
	add	x0, x0, :lo12:.LC72
	bl	printf
	ldr	x0, [x22, #:lo12:.LANCHOR77]
	mov	w2, w19
	mov	w1, 0
	bl	FlashEraseBlocks
	ldr	x0, [x22, #:lo12:.LANCHOR77]
	mov	w2, w19
	mov	w1, 1
	bl	FlashEraseBlocks
.L2728:
	mov	w0, -1
	strh	w0, [x25, #:lo12:.LANCHOR234]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 128
	ret
.L2733:
	ldrh	w1, [x20]
	cmp	w1, w5
	beq	.L2732
	umaddl	x2, w19, w6, x4
	add	w19, w19, 1
	and	w19, w19, 65535
	lsl	w1, w1, 10
	stp	xzr, xzr, [x2, 8]
	str	w1, [x2, 4]
.L2732:
	add	w0, w0, 1
	add	x20, x20, 2
	and	w0, w0, 65535
	b	.L2731
.L2739:
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
	bne	.L2743
	mov	x2, x3
	mov	w1, w27
	add	w0, w19, 256
	bl	FtlVendorPartRead
	mov	w21, w0
.L2742:
	mov	w0, w21
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x27, x28, [sp, 96]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 208
	ret
.L2743:
	add	w0, w1, w2
	str	w0, [x29, 148]
	adrp	x0, .LANCHOR68
	add	w1, w1, w2
	ldr	w0, [x0, #:lo12:.LANCHOR68]
	cmp	w1, w0
	bhi	.L2766
	adrp	x0, .LANCHOR230
	ldr	w21, [x0, #:lo12:.LANCHOR230]
	cmn	w21, #1
	beq	.L2742
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
.L2745:
	ldr	w0, [x29, 172]
	cbnz	w0, .L2765
	adrp	x0, .LANCHOR116
	ldrh	w0, [x0, #:lo12:.LANCHOR116]
	cbz	w0, .L2742
	mov	w1, 1
	mov	w0, 0
	bl	rk_ftl_garbage_collect
	b	.L2742
.L2765:
	add	x1, x29, 188
	mov	w2, 0
	mov	w0, w20
	bl	log2phys
	ldr	w1, [x29, 188]
	cmn	w1, #1
	bne	.L2746
	add	x3, x22, :lo12:.LANCHOR55
	mov	w28, 0
.L2747:
	ldrh	w0, [x3]
	cmp	w28, w0
	bcc	.L2749
.L2750:
	ldr	w0, [x29, 172]
	add	w20, w20, 1
	subs	w0, w0, #1
	str	w0, [x29, 172]
	beq	.L2754
	adrp	x0, .LANCHOR38
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w24, w0, lsl 2
	bne	.L2745
.L2754:
	cbz	w24, .L2745
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
	adrp	x0, .LC59
	add	x0, x0, :lo12:.LC59
	str	x0, [x29, 112]
.L2764:
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	ldr	w2, [x29, 168]
	add	x0, x0, x24
	ldr	w1, [x0, 24]
	cmp	w2, w1
	bne	.L2756
	ldr	x1, [x0, 8]
	adrp	x0, .LANCHOR186
	ldr	x0, [x0, #:lo12:.LANCHOR186]
	cmp	x1, x0
	bne	.L2757
	ldr	x0, [x29, 136]
	ldr	w2, [x29, 144]
	add	x1, x1, x0
	mov	x0, x23
.L2781:
	bl	ftl_memcpy
.L2757:
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	add	x0, x0, x24
	ldr	x2, [x0, 16]
	ldr	w1, [x0, 24]
	ldr	w3, [x2, 8]
	cmp	w1, w3
	beq	.L2758
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
.L2758:
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	add	x1, x0, x24
	ldr	w0, [x0, x24]
	cmn	w0, #1
	bne	.L2759
	ldr	w1, [x25, 72]
	mov	w21, w0
	add	w1, w1, 1
	str	w1, [x25, 72]
.L2760:
	ldr	x0, [x29, 120]
	add	x24, x24, 56
	cmp	x0, x24
	bne	.L2764
	mov	w24, 0
	b	.L2745
.L2749:
	madd	w0, w20, w0, w28
	cmp	w19, w0
	bhi	.L2748
	ldr	w1, [x29, 148]
	cmp	w1, w0
	bls	.L2748
	sub	w0, w0, w19
	str	x3, [x29, 136]
	lsl	w0, w0, 9
	mov	w2, 512
	mov	w1, 0
	add	x0, x23, x0
	bl	ftl_memset
	ldr	x3, [x29, 136]
.L2748:
	add	w28, w28, 1
	b	.L2747
.L2746:
	ldr	x0, [x26, #:lo12:.LANCHOR180]
	mov	w2, 56
	umaddl	x0, w24, w2, x0
	str	w1, [x0, 4]
	ldr	w1, [x29, 168]
	cmp	w20, w1
	bne	.L2751
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
	bne	.L2752
	str	x23, [x0, 8]
.L2752:
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
	b	.L2750
.L2751:
	ldr	w1, [x29, 164]
	cmp	w20, w1
	bne	.L2753
	ldrh	w2, [x22, #:lo12:.LANCHOR55]
	adrp	x1, .LANCHOR187
	ldr	w3, [x29, 148]
	ldr	x1, [x1, #:lo12:.LANCHOR187]
	str	x1, [x0, 8]
	mul	w1, w20, w2
	sub	w3, w3, w1
	str	w3, [x29, 156]
	cmp	w2, w3
	bne	.L2752
.L2780:
	sub	w1, w1, w19
	lsl	w1, w1, 9
	add	x1, x23, x1
	str	x1, [x0, 8]
	b	.L2752
.L2753:
	ldrh	w1, [x22, #:lo12:.LANCHOR55]
	mul	w1, w1, w20
	b	.L2780
.L2756:
	ldr	w2, [x29, 164]
	cmp	w2, w1
	bne	.L2757
	ldr	x1, [x0, 8]
	ldr	x0, [x28, #:lo12:.LANCHOR187]
	cmp	x1, x0
	bne	.L2757
	ldrh	w0, [x22, #:lo12:.LANCHOR55]
	mul	w0, w0, w2
	ldr	w2, [x29, 132]
	sub	w0, w0, w19
	lsl	w0, w0, 9
	add	x0, x23, x0
	b	.L2781
.L2759:
	cmp	w0, 256
	bne	.L2760
	ldr	w0, [x1, 4]
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	and	w1, w0, 65535
	str	w1, [x29, 128]
	bl	FtlGcRefreshBlock
	mov	w2, 2049
	adrp	x3, .LANCHOR204
.L2762:
	subs	w2, w2, #1
	bne	.L2761
.L2763:
	bl	FtlSysFlush
	b	.L2760
.L2761:
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
	beq	.L2762
	b	.L2763
.L2766:
	mov	w21, -1
	b	.L2742
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
	cbnz	w1, .L2814
	and	w0, w0, 255
	mov	w23, w2
	mov	x24, x3
	cmp	w0, 16
	bne	.L2784
	mov	x2, x3
	mov	w1, w23
	add	w0, w21, 256
	bl	FtlVendorPartWrite
.L2782:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	ret
.L2784:
	adrp	x0, .LANCHOR68
	add	w2, w21, w2
	ldr	w0, [x0, #:lo12:.LANCHOR68]
	cmp	w2, w0
	bhi	.L2815
	adrp	x0, .LANCHOR230
	ldr	w0, [x0, #:lo12:.LANCHOR230]
	cmn	w0, #1
	beq	.L2782
	adrp	x0, .LANCHOR246
	adrp	x26, .LANCHOR55
	mov	w1, 2048
	sub	w2, w2, #1
	str	w1, [x0, #:lo12:.LANCHOR246]
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
	cbz	x2, .L2786
	ldr	w0, [x2, 24]
	cmp	w20, w0
	beq	.L2787
	bl	FtlCacheWriteBack
.L2786:
	adrp	x0, .LANCHOR91
	mov	w19, w20
	add	x22, x0, :lo12:.LANCHOR91
.L2788:
	cbnz	w25, .L2813
	ldr	w0, [x29, 152]
	sub	w1, w0, w20
	mov	w0, 0
	bl	rk_ftl_garbage_collect
.L2814:
	mov	w0, 0
	b	.L2782
.L2787:
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
	cbz	w27, .L2814
	sub	w23, w23, w19
	add	w21, w21, w19
	add	x24, x24, x22
	add	w20, w20, 1
	bl	FtlCacheWriteBack
	mov	w25, w27
	b	.L2786
.L2813:
	adrp	x0, .LANCHOR91
	add	x0, x0, :lo12:.LANCHOR91
	adrp	x1, .LANCHOR38
	str	x1, [x29, 120]
	ldrb	w2, [x0, 6]
	ldrh	w0, [x1, #:lo12:.LANCHOR38]
	cmp	w2, w0
	bcc	.L2789
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
.L2789:
	ldrh	w0, [x22, 4]
	cbnz	w0, .L2790
	bl	FtlCacheWriteBack
	mov	x0, x22
	bl	allocate_new_data_superblock
.L2790:
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
	bcc	.L2791
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
.L2791:
	adrp	x0, .LANCHOR58
	add	x0, x0, :lo12:.LANCHOR58
	str	xzr, [x29, 168]
	str	x0, [x29, 112]
	adrp	x0, .LANCHOR57
	add	x0, x0, :lo12:.LANCHOR57
	str	x0, [x29, 104]
.L2792:
	ldr	w1, [x29, 144]
	adrp	x28, .LANCHOR182
	ldr	w27, [x29, 168]
	cmp	w27, w1
	bcc	.L2811
	mov	x27, x1
.L2793:
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	mov	x3, x22
	mov	w2, 0
	mov	w1, w27
	bl	FtlProgPages
	cmp	w25, w27
	bcs	.L2812
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
.L2812:
	sub	w25, w25, w27
	b	.L2788
.L2811:
	ldrh	w0, [x22, 4]
	cbz	w0, .L2793
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
	bne	.L2794
	cmp	w19, w20
	bne	.L2795
	ldr	x0, [x29, 160]
	ldrh	w2, [x0, #:lo12:.LANCHOR55]
	udiv	w0, w21, w2
	msub	w0, w0, w2, w21
	str	w0, [x29, 148]
	sub	w2, w2, w0
	cmp	w2, w23
	csel	w0, w2, w23, ls
	str	w0, [x29, 156]
.L2796:
	ldr	x0, [x29, 160]
	ldr	w1, [x29, 156]
	ldrh	w0, [x0, #:lo12:.LANCHOR55]
	cmp	w0, w1
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	bne	.L2797
	add	x3, x0, x26
	cmp	w19, w20
	bne	.L2798
	str	x24, [x3, 8]
.L2799:
	ldr	x0, [x29, 120]
	ldrb	w1, [x22, 6]
	ldrh	w0, [x0, #:lo12:.LANCHOR38]
	cmp	w1, w0
	bcc	.L2808
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
.L2808:
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
	b	.L2792
.L2795:
	ldr	x0, [x29, 160]
	add	w2, w21, w23
	str	wzr, [x29, 148]
	ldrh	w0, [x0, #:lo12:.LANCHOR55]
	msub	w2, w19, w0, w2
	and	w0, w2, 65535
	str	w0, [x29, 156]
	b	.L2796
.L2798:
	ldr	w0, [x29, 156]
.L2826:
	mul	w0, w0, w19
	sub	w0, w0, w21
	lsl	w0, w0, 9
	add	x0, x24, x0
	str	x0, [x3, 8]
	b	.L2799
.L2797:
	add	x0, x0, x26
	cmp	w19, w20
	bne	.L2800
	adrp	x1, .LANCHOR186
	ldr	x1, [x1, #:lo12:.LANCHOR186]
.L2825:
	str	x1, [x0, 8]
	ldr	w0, [x29, 180]
	cmn	w0, #1
	beq	.L2802
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
	bne	.L2803
	adrp	x0, .LANCHOR138
	add	x0, x0, :lo12:.LANCHOR138
	ldr	w1, [x0, 72]
	add	w1, w1, 1
	str	w1, [x0, 72]
.L2806:
	ldr	w0, [x29, 156]
	cmp	w19, w20
	lsl	w2, w0, 9
	bne	.L2807
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	mov	x1, x24
	add	x3, x0, x26
	ldr	w0, [x29, 148]
	ldr	x3, [x3, 8]
	lsl	w0, w0, 9
	add	x0, x3, x0
.L2827:
	bl	ftl_memcpy
	b	.L2799
.L2800:
	adrp	x1, .LANCHOR187
	ldr	x1, [x1, #:lo12:.LANCHOR187]
	b	.L2825
.L2803:
	ldr	w1, [x27, 8]
	cmp	w19, w1
	beq	.L2805
	adrp	x0, .LANCHOR138
	add	x0, x0, :lo12:.LANCHOR138
	ldr	w2, [x0, 72]
	add	w2, w2, 1
	str	w2, [x0, 72]
	adrp	x0, .LC73
	mov	w2, w19
	add	x0, x0, :lo12:.LC73
	bl	printf
.L2805:
	ldr	w0, [x27, 8]
	cmp	w19, w0
	beq	.L2806
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
	b	.L2806
.L2802:
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	ldr	x1, [x29, 104]
	add	x0, x0, x26
	ldrh	w2, [x1]
	mov	w1, 0
	ldr	x0, [x0, 8]
	bl	ftl_memset
	b	.L2806
.L2807:
	ldr	x0, [x29, 160]
	ldrh	w1, [x0, #:lo12:.LANCHOR55]
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	add	x3, x0, x26
	mul	w1, w1, w19
	sub	w1, w1, w21
	ldr	x0, [x3, 8]
	lsl	w1, w1, 9
	add	x1, x24, x1
	b	.L2827
.L2794:
	ldr	x0, [x28, #:lo12:.LANCHOR182]
	add	x3, x0, x26
	ldr	x0, [x29, 160]
	ldrh	w0, [x0, #:lo12:.LANCHOR55]
	b	.L2826
.L2815:
	mov	w0, -1
	b	.L2782
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
	bne	.L2833
	mov	w3, w2
	mov	w0, 0
	mov	x2, x20
	bl	idb_write_data
.L2833:
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
	adrp	x23, .LANCHOR72
	add	x23, x23, :lo12:.LANCHOR72
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
.L2836:
	ldr	w0, [x23]
	cmp	w21, w0
	bcc	.L2838
	adrp	x24, .LANCHOR40
	adrp	x23, .LANCHOR83
	mov	w2, 2
	adrp	x0, .LC74
	ldrh	w3, [x24, #:lo12:.LANCHOR40]
	add	x0, x0, :lo12:.LC74
	ldr	x1, [x23, #:lo12:.LANCHOR83]
	add	x21, x20, :lo12:check_valid_page_count_table
	adrp	x26, .LC76
	add	x26, x26, :lo12:.LC76
	mov	w25, 0
	mov	w19, 0
	bl	rknand_print_hex
	ldrh	w3, [x24, #:lo12:.LANCHOR40]
	mov	w2, 2
	mov	x1, x21
	adrp	x0, .LC75
	add	x24, x24, :lo12:.LANCHOR40
	add	x0, x0, :lo12:.LC75
	bl	rknand_print_hex
	mov	w4, 65535
.L2839:
	ldrh	w0, [x24]
	cmp	w0, w19
	bhi	.L2841
	adrp	x0, .LANCHOR87
	ldr	x19, [x0, #:lo12:.LANCHOR87]
	cbz	x19, .L2842
	adrp	x0, .LANCHOR88
	adrp	x26, .LC77
	add	x20, x20, :lo12:check_valid_page_count_table
	add	x26, x26, :lo12:.LC77
	ldrh	w27, [x0, #:lo12:.LANCHOR88]
	adrp	x0, .LANCHOR81
	mov	x24, x0
	mov	w21, 0
	ldr	x1, [x0, #:lo12:.LANCHOR81]
	mov	w28, 6
	mov	w4, 65535
	sub	x19, x19, x1
	mov	x1, -6148914691236517206
	asr	x19, x19, 1
	movk	x1, 0xaaab, lsl 0
	mul	x19, x19, x1
	and	w19, w19, 65535
.L2843:
	cmp	w21, w27
	bne	.L2845
.L2842:
	cbz	w25, .L2835
	mov	w2, 1686
	add	x1, x22, :lo12:.LANCHOR248
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	adrp	x1, .LC6
	adrp	x0, .LC7
	add	x1, x1, :lo12:.LC6
	add	x0, x0, :lo12:.LC7
	bl	printf
.L2835:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L2838:
	mov	w2, 0
	add	x1, x29, 124
	mov	w0, w21
	bl	log2phys
	ldr	w0, [x29, 124]
	cmn	w0, #1
	beq	.L2837
	lsr	w0, w0, 10
	bl	P2V_block_in_plane
	and	x0, x0, 65535
	ldrh	w1, [x19, x0, lsl 1]
	add	w1, w1, 1
	strh	w1, [x19, x0, lsl 1]
.L2837:
	add	w21, w21, 1
	b	.L2836
.L2841:
	ldr	x0, [x23, #:lo12:.LANCHOR83]
	ubfiz	x28, x19, 1, 16
	sxtw	x27, w19
	ldrh	w2, [x0, x28]
	ldrh	w3, [x21, x27, lsl 1]
	cmp	w2, w3
	beq	.L2840
	str	w4, [x29, 108]
	mov	w1, w19
	mov	x0, x26
	bl	printf
	ldr	x0, [x23, #:lo12:.LANCHOR83]
	ldr	w4, [x29, 108]
	ldrh	w0, [x0, x28]
	cmp	w0, w4
	beq	.L2840
	ldrh	w1, [x21, x27, lsl 1]
	cmp	w1, w0
	csinc	w25, w25, wzr, ls
.L2840:
	add	w19, w19, 1
	and	w19, w19, 65535
	b	.L2839
.L2845:
	ldr	x1, [x23, #:lo12:.LANCHOR83]
	ubfiz	x0, x19, 1, 16
	ldrh	w2, [x1, x0]
	cbz	w2, .L2844
	ldrh	w3, [x20, w19, sxtw 1]
	mov	w1, w19
	str	w4, [x29, 108]
	mov	x0, x26
	mov	w25, 1
	bl	printf
	ldr	w4, [x29, 108]
.L2844:
	umull	x19, w19, w28
	ldr	x0, [x24, #:lo12:.LANCHOR81]
	ldrh	w19, [x0, x19]
	cmp	w19, w4
	beq	.L2842
	add	w21, w21, 1
	and	w21, w21, 65535
	b	.L2843
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
	adrp	x22, .LANCHOR53
	stp	x23, x24, [sp, 64]
	lsl	w26, w25, 10
	stp	x19, x20, [sp, 32]
	adrp	x23, .LC78
	str	x27, [sp, 96]
	adrp	x24, .LC79
	str	x2, [x1, 8]
	adrp	x2, .LANCHOR188
	add	x22, x22, :lo12:.LANCHOR53
	add	x23, x23, :lo12:.LC78
	ldr	x2, [x2, #:lo12:.LANCHOR188]
	add	x24, x24, :lo12:.LC79
	mov	x27, x0
	mov	w19, 0
	str	x2, [x1, 16]
.L2861:
	ldrh	w0, [x22]
	cmp	w19, w0
	blt	.L2863
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	x29, x30, [sp, 16]
	ldr	x27, [sp, 96]
	add	sp, sp, 112
	ret
.L2863:
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
	beq	.L2862
	ldr	x1, [x27, #:lo12:.LANCHOR183]
	mov	w3, 768
	mov	w2, 4
	mov	x0, x24
	bl	rknand_print_hex
.L2862:
	add	w19, w19, 1
	sxth	w19, w19
	b	.L2861
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
.L2869:
	ldrh	w0, [x22]
	cmp	w0, w20
	bhi	.L2875
	adrp	x25, .LANCHOR128
	adrp	x19, .LANCHOR202
	add	x25, x25, :lo12:.LANCHOR128
	add	x19, x19, :lo12:.LANCHOR202
	mov	w26, 0
.L2876:
	ldrh	w0, [x25]
	cmp	w26, w0
	bge	.L2879
	adrp	x21, .LANCHOR53
	adrp	x0, .LC48
	sbfiz	x23, x26, 1, 32
	mov	w20, 0
	add	x21, x21, :lo12:.LANCHOR53
	add	x24, x0, :lo12:.LC48
	b	.L2880
.L2871:
	ldrb	w0, [x23, x5]
	mov	w1, w20
	bl	V2P_block
	and	w4, w0, 65535
	bl	FtlBbmIsBadBlock
	cbnz	w0, .L2870
	umaddl	x1, w19, w7, x6
	lsl	w4, w4, 10
	mul	w0, w19, w8
	add	w19, w19, 1
	and	w19, w19, 65535
	asr	w0, w0, 2
	str	w4, [x1, 4]
	add	x0, x10, x0, sxtw 2
	stp	x11, x0, [x1, 8]
.L2870:
	add	x5, x5, 1
.L2877:
	cmp	w12, w5, uxth
	bhi	.L2871
	cbnz	w19, .L2872
.L2874:
	add	w20, w20, 1
	and	w20, w20, 65535
	b	.L2869
.L2872:
	mov	w1, w19
	mov	w2, 1
	mov	x0, x6
	bl	FlashReadPages
	mov	w0, 56
	adrp	x26, .LC80
	add	x26, x26, :lo12:.LC80
	mov	x25, 0
	umull	x19, w19, w0
.L2873:
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
	bne	.L2873
	b	.L2874
.L2875:
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
	b	.L2877
.L2878:
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
.L2880:
	ldrh	w0, [x21]
	cmp	w20, w0
	blt	.L2878
	add	w0, w26, 1
	sxth	w26, w0
	b	.L2876
.L2879:
	adrp	x0, .LANCHOR64
	mov	w2, 2
	adrp	x19, .LANCHOR66
	ldr	w3, [x0, #:lo12:.LANCHOR64]
	adrp	x0, .LANCHOR129
	ldr	x1, [x0, #:lo12:.LANCHOR129]
	adrp	x0, .LC81
	add	x0, x0, :lo12:.LC81
	bl	rknand_print_hex
	adrp	x0, .LANCHOR131
	ldrh	w3, [x19, #:lo12:.LANCHOR66]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR131]
	adrp	x0, .LC82
	add	x0, x0, :lo12:.LC82
	bl	rknand_print_hex
	adrp	x0, .LANCHOR195
	ldrh	w3, [x19, #:lo12:.LANCHOR66]
	ldp	x21, x22, [sp, 48]
	mov	w2, 4
	ldr	x1, [x0, #:lo12:.LANCHOR195]
	adrp	x0, .LC83
	ldp	x19, x20, [sp, 32]
	add	x0, x0, :lo12:.LC83
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
	.set	.LANCHOR14,. + 0
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
	.set	.LANCHOR75,. + 0
	.type	gSysFreeQueue, %object
	.size	gSysFreeQueue, 2056
gSysFreeQueue:
	.zero	2056
	.section	.bss.gSysInfo,"aw",@nobits
	.align	3
	.set	.LANCHOR209,. + 0
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
	.set	.LANCHOR68,. + 0
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
	.set	.LANCHOR218,. + 0
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
	.set	.LANCHOR246,. + 0
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
	.set	.LANCHOR204,. + 0
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
	.set	.LANCHOR234,. + 0
	.type	g_power_lost_ecc_error_blk, %object
	.size	g_power_lost_ecc_error_blk, 2
g_power_lost_ecc_error_blk:
	.zero	2
	.section	.bss.g_power_lost_recovery_flag,"aw",@nobits
	.align	1
	.set	.LANCHOR235,. + 0
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
	.set	.LANCHOR236,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.zero	4
	.section	.bss.g_recovery_ppa_tbl,"aw",@nobits
	.align	3
	.set	.LANCHOR237,. + 0
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
	.set	.LANCHOR216,. + 0
	.type	g_totle_write_sector, %object
	.size	g_totle_write_sector, 4
g_totle_write_sector:
	.zero	4
	.section	.bss.gc_discard_updated,"aw",@nobits
	.align	2
	.set	.LANCHOR231,. + 0
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
	.set	.LANCHOR103,. + 0
	.type	gp_gc_page_buf_info, %object
	.size	gp_gc_page_buf_info, 8
gp_gc_page_buf_info:
	.zero	8
	.section	.bss.gp_last_act_superblock,"aw",@nobits
	.align	3
	.set	.LANCHOR229,. + 0
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
	.set	.LANCHOR0,. + 0
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
	.set	.LANCHOR238,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.hword	-1
	.section	.data.gFtlInitStatus,"aw",@progbits
	.align	2
	.set	.LANCHOR230,. + 0
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
.LC52:
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
.LC74:
	.string	"vpc1"
.LC75:
	.string	"vpc2"
.LC76:
	.string	"FtlCheckVpc2 %x = %x  %x\n"
.LC77:
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
.LC78:
	.string	"id = %x,%x addr= %x,spare= %x %x %x %x data = %x\n"
.LC79:
	.string	":"
	.section	.rodata.FtlFreeSysBlkQueueOut.str1.1,"aMS",@progbits,1
.LC3:
	.string	"FtlFreeSysBlkQueueOut free count = %d\n"
.LC4:
	.string	"FtlFreeSysBlkQueueOut = %x, free count = %d, error\n"
	.section	.rodata.FtlGcFreeTempBlock.str1.1,"aMS",@progbits,1
.LC65:
	.string	"GC des block %x done\n"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",@progbits,1
.LC63:
	.string	"FtlGcScanTempBlk Error ID %x %x!!!!!!! \n"
.LC64:
	.string	"FtlGcScanTempBlkError ID %x %x!!!!!!!\n"
	.section	.rodata.FtlInit.str1.1,"aMS",@progbits,1
.LC67:
	.string	"FTL version: 5.0.53 20190107"
.LC68:
	.string	"...%s: no bad block mapping table, format device\n"
.LC69:
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
.LC56:
	.string	"Ftlwrite decrement_vpc_count %x = %d\n"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",@progbits,1
.LC60:
	.string	"RSB refresh addr %x\n"
.LC61:
	.string	"spuer block %x vpn is 0\n "
.LC62:
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
.LC73:
	.string	"FtlWrite: lpa error:%x %x\n"
	.section	.rodata.Ftl_load_ext_data.str1.1,"aMS",@progbits,1
.LC44:
	.string	"slc mode"
	.section	.rodata.Ftlscanalldata.str1.1,"aMS",@progbits,1
.LC57:
	.string	"Ftlscanalldata = %x\n"
.LC58:
	.string	"scan lpa = %x ppa= %x\n"
.LC59:
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
	.section	.rodata.__func__.10005,"a",@progbits
	.align	3
	.set	.LANCHOR220,. + 0
	.type	__func__.10005, %object
	.size	__func__.10005, 14
__func__.10005:
	.string	"FtlScanSysBlk"
	.section	.rodata.__func__.10060,"a",@progbits
	.align	3
	.set	.LANCHOR221,. + 0
	.type	__func__.10060, %object
	.size	__func__.10060, 15
__func__.10060:
	.string	"FtlLoadSysInfo"
	.section	.rodata.__func__.10071,"a",@progbits
	.align	3
	.set	.LANCHOR248,. + 0
	.type	__func__.10071, %object
	.size	__func__.10071, 12
__func__.10071:
	.string	"FtlCheckVpc"
	.section	.rodata.__func__.10103,"a",@progbits
	.align	3
	.set	.LANCHOR224,. + 0
	.type	__func__.10103, %object
	.size	__func__.10103, 17
__func__.10103:
	.string	"FtlDumpBlockInfo"
	.section	.rodata.__func__.10122,"a",@progbits
	.align	3
	.set	.LANCHOR225,. + 0
	.type	__func__.10122, %object
	.size	__func__.10122, 16
__func__.10122:
	.string	"FtlScanAllBlock"
	.section	.rodata.__func__.10227,"a",@progbits
	.align	3
	.set	.LANCHOR232,. + 0
	.type	__func__.10227, %object
	.size	__func__.10227, 16
__func__.10227:
	.string	"FtlReUsePrevPpa"
	.section	.rodata.__func__.10260,"a",@progbits
	.align	3
	.set	.LANCHOR233,. + 0
	.type	__func__.10260, %object
	.size	__func__.10260, 22
__func__.10260:
	.string	"FtlRecoverySuperblock"
	.section	.rodata.__func__.10314,"a",@progbits
	.align	3
	.set	.LANCHOR101,. + 0
	.type	__func__.10314, %object
	.size	__func__.10314, 16
__func__.10314:
	.string	"make_superblock"
	.section	.rodata.__func__.10334,"a",@progbits
	.align	3
	.set	.LANCHOR140,. + 0
	.type	__func__.10334, %object
	.size	__func__.10334, 18
__func__.10334:
	.string	"SupperBlkListInit"
	.section	.rodata.__func__.10411,"a",@progbits
	.align	3
	.set	.LANCHOR203,. + 0
	.type	__func__.10411, %object
	.size	__func__.10411, 25
__func__.10411:
	.string	"allocate_data_superblock"
	.section	.rodata.__func__.10425,"a",@progbits
	.align	3
	.set	.LANCHOR219,. + 0
	.type	__func__.10425, %object
	.size	__func__.10425, 29
__func__.10425:
	.string	"allocate_new_data_superblock"
	.section	.rodata.__func__.10431,"a",@progbits
	.align	3
	.set	.LANCHOR208,. + 0
	.type	__func__.10431, %object
	.size	__func__.10431, 19
__func__.10431:
	.string	"get_new_active_ppa"
	.section	.rodata.__func__.10442,"a",@progbits
	.align	3
	.set	.LANCHOR206,. + 0
	.type	__func__.10442, %object
	.size	__func__.10442, 16
__func__.10442:
	.string	"update_vpc_list"
	.section	.rodata.__func__.10447,"a",@progbits
	.align	3
	.set	.LANCHOR207,. + 0
	.type	__func__.10447, %object
	.size	__func__.10447, 20
__func__.10447:
	.string	"decrement_vpc_count"
	.section	.rodata.__func__.10515,"a",@progbits
	.align	3
	.set	.LANCHOR239,. + 0
	.type	__func__.10515, %object
	.size	__func__.10515, 19
__func__.10515:
	.string	"FtlGcFreeTempBlock"
	.section	.rodata.__func__.10614,"a",@progbits
	.align	3
	.set	.LANCHOR243,. + 0
	.type	__func__.10614, %object
	.size	__func__.10614, 23
__func__.10614:
	.string	"rk_ftl_garbage_collect"
	.section	.rodata.__func__.9435,"a",@progbits
	.align	3
	.set	.LANCHOR245,. + 0
	.type	__func__.9435, %object
	.size	__func__.9435, 8
__func__.9435:
	.string	"FtlInit"
	.section	.rodata.__func__.9495,"a",@progbits
	.align	3
	.set	.LANCHOR228,. + 0
	.type	__func__.9495, %object
	.size	__func__.9495, 13
__func__.9495:
	.string	"FtlProgPages"
	.section	.rodata.__func__.9521,"a",@progbits
	.align	3
	.set	.LANCHOR247,. + 0
	.type	__func__.9521, %object
	.size	__func__.9521, 9
__func__.9521:
	.string	"FtlWrite"
	.section	.rodata.__func__.9604,"a",@progbits
	.align	3
	.set	.LANCHOR124,. + 0
	.type	__func__.9604, %object
	.size	__func__.9604, 14
__func__.9604:
	.string	"FtlBbt2Bitmap"
	.section	.rodata.__func__.9650,"a",@progbits
	.align	3
	.set	.LANCHOR211,. + 0
	.type	__func__.9650, %object
	.size	__func__.9650, 11
__func__.9650:
	.string	"FtlLoadBbt"
	.section	.rodata.__func__.9743,"a",@progbits
	.align	3
	.set	.LANCHOR89,. + 0
	.type	__func__.9743, %object
	.size	__func__.9743, 17
__func__.9743:
	.string	"INSERT_FREE_LIST"
	.section	.rodata.__func__.9747,"a",@progbits
	.align	3
	.set	.LANCHOR86,. + 0
	.type	__func__.9747, %object
	.size	__func__.9747, 17
__func__.9747:
	.string	"INSERT_DATA_LIST"
	.section	.rodata.__func__.9784,"a",@progbits
	.align	3
	.set	.LANCHOR90,. + 0
	.type	__func__.9784, %object
	.size	__func__.9784, 17
__func__.9784:
	.string	"List_remove_node"
	.section	.rodata.__func__.9814,"a",@progbits
	.align	3
	.set	.LANCHOR94,. + 0
	.type	__func__.9814, %object
	.size	__func__.9814, 22
__func__.9814:
	.string	"List_update_data_list"
	.section	.rodata.__func__.9821,"a",@progbits
	.align	3
	.set	.LANCHOR227,. + 0
	.type	__func__.9821, %object
	.size	__func__.9821, 20
__func__.9821:
	.string	"ftl_load_l2p_region"
	.section	.rodata.__func__.9852,"a",@progbits
	.align	3
	.set	.LANCHOR95,. + 0
	.type	__func__.9852, %object
	.size	__func__.9852, 26
__func__.9852:
	.string	"ftl_map_blk_alloc_new_blk"
	.section	.rodata.__func__.9862,"a",@progbits
	.align	3
	.set	.LANCHOR212,. + 0
	.type	__func__.9862, %object
	.size	__func__.9862, 15
__func__.9862:
	.string	"ftl_map_blk_gc"
	.section	.rodata.__func__.9875,"a",@progbits
	.align	3
	.set	.LANCHOR213,. + 0
	.type	__func__.9875, %object
	.size	__func__.9875, 31
__func__.9875:
	.string	"Ftl_write_map_blk_to_last_page"
	.section	.rodata.__func__.9888,"a",@progbits
	.align	3
	.set	.LANCHOR214,. + 0
	.type	__func__.9888, %object
	.size	__func__.9888, 16
__func__.9888:
	.string	"FtlMapWritePage"
	.section	.rodata.__func__.9908,"a",@progbits
	.align	3
	.set	.LANCHOR98,. + 0
	.type	__func__.9908, %object
	.size	__func__.9908, 22
__func__.9908:
	.string	"select_l2p_ram_region"
	.section	.rodata.__func__.9924,"a",@progbits
	.align	3
	.set	.LANCHOR226,. + 0
	.type	__func__.9924, %object
	.size	__func__.9924, 9
__func__.9924:
	.string	"log2phys"
	.section	.rodata.__func__.9986,"a",@progbits
	.align	3
	.set	.LANCHOR210,. + 0
	.type	__func__.9986, %object
	.size	__func__.9986, 15
__func__.9986:
	.string	"FtlVpcTblFlush"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",@progbits,1
.LC36:
	.string	"decrement_vpc_count %x = %d\n"
.LC37:
	.string	"decrement_vpc_count %x = %d in free list\n"
	.section	.rodata.dump_map_info.str1.1,"aMS",@progbits,1
.LC80:
	.string	"phyBlk = %x,addr= %x,spare= %x %x %x %x data=%x %x\n"
.LC81:
	.string	"Mblk:"
.LC82:
	.string	"L2P:"
.LC83:
	.string	"L2PC:"
	.section	.rodata.ftl_fix_nand_power_lost_error.str1.1,"aMS",@progbits,1
.LC71:
	.string	"fix power lost blk = %x vpc=%x\n"
.LC72:
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
.LC53:
	.string	"region_id = %x phyAddr = %x\n"
.LC54:
	.string	"map_ppn:"
.LC55:
	.string	"load_l2p_region refresh = %x phyAddr = %x\n"
	.section	.rodata.rk_ftl_garbage_collect.str1.1,"aMS",@progbits,1
.LC66:
	.string	"g_gc_superblock_free %x %x %x %x %x\n"
	.section	.rodata.rk_ftl_init.str1.1,"aMS",@progbits,1
.LC70:
	.string	"FtlInit %x\n"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",@progbits,1
.LC18:
	.string	"%s 0x%x:"
.LC19:
	.string	"%x "
.LC20:
	.string	""
	.hidden	free
