/*
 * Copyright (c) 2016-2018, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2019-05-08
 */
	.arch armv7-a
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 4
	.eabi_attribute 34, 0
	.eabi_attribute 18, 2
	.file	"rk_ftl_arm_v7.S"
	.section	.text.flash_read_ecc,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_read_ecc, %function
flash_read_ecc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2
	push	{r4, lr}
	ldr	r4, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	movs	r0, #80
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r4, r4, r3, lsl #8
	movs	r3, #122
	str	r3, [r4, #2056]
	bl	udelay
	ldr	r3, [r4, #2048]
	ldr	r0, [r4, #2048]
	and	r3, r3, #15
	and	r0, r0, #15
	cmp	r0, r3
	it	cc
	movcc	r0, r3
	ldr	r3, [r4, #2048]
	and	r3, r3, #15
	cmp	r3, r0
	it	cc
	movcc	r3, r0
	ldr	r0, [r4, #2048]
	and	r0, r0, #15
	cmp	r0, r3
	it	cc
	movcc	r0, r3
	pop	{r4, pc}
.L3:
	.align	2
.L2:
	.word	.LANCHOR0
	.size	flash_read_ecc, .-flash_read_ecc
	.section	.text.ftl_set_blk_mode.part.10,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_set_blk_mode.part.10, %function
ftl_set_blk_mode.part.10:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L5
	lsrs	r1, r0, #5
	and	r0, r0, #31
	ldr	r2, [r3]
	movs	r3, #1
	lsl	r0, r3, r0
	ldr	r3, [r2, r1, lsl #2]
	orrs	r3, r3, r0
	str	r3, [r2, r1, lsl #2]
	bx	lr
.L6:
	.align	2
.L5:
	.word	.LANCHOR1
	.size	ftl_set_blk_mode.part.10, .-ftl_set_blk_mode.part.10
	.section	.text.FlashMemCmp8,"ax",%progbits
	.align	1
	.global	FlashMemCmp8
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashMemCmp8, %function
FlashMemCmp8:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L15
	push	{r4, r5, lr}
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L10
	ldrb	r4, [r0, #1]	@ zero_extendqisi2
	ldrb	r3, [r1, #1]	@ zero_extendqisi2
	cmp	r4, r3
	beq	.L14
	movs	r3, #0
.L10:
	cmp	r3, r2
	bne	.L12
.L14:
	movs	r0, #0
	pop	{r4, r5, pc}
.L12:
	ldrb	r5, [r0, r3]	@ zero_extendqisi2
	ldrb	r4, [r1, r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r5, r4
	beq	.L10
	mov	r0, r3
	pop	{r4, r5, pc}
.L16:
	.align	2
.L15:
	.word	.LANCHOR2
	.size	FlashMemCmp8, .-FlashMemCmp8
	.section	.text.FlashRsvdBlkChk,"ax",%progbits
	.align	1
	.global	FlashRsvdBlkChk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashRsvdBlkChk, %function
FlashRsvdBlkChk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L20
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L20+4
	ldr	r3, [r3]
	muls	r3, r2, r3
	cmp	r3, r1
	bls	.L19
	adds	r0, r0, #0
	it	ne
	movne	r0, #1
	bx	lr
.L19:
	movs	r0, #1
	bx	lr
.L21:
	.align	2
.L20:
	.word	.LANCHOR3
	.word	.LANCHOR4
	.size	FlashRsvdBlkChk, .-FlashRsvdBlkChk
	.section	.text.FlashGetRandomizer,"ax",%progbits
	.align	1
	.global	FlashGetRandomizer
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashGetRandomizer, %function
FlashGetRandomizer:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L30
	and	r2, r1, #127
	push	{r4, lr}
	ldrh	r4, [r3, r2, lsl #1]
	ldr	r3, .L30+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L22
	bl	FlashRsvdBlkChk
	cbz	r0, .L22
	orr	r4, r4, #-1073741824
.L22:
	mov	r0, r4
	pop	{r4, pc}
.L31:
	.align	2
.L30:
	.word	.LANCHOR5
	.word	.LANCHOR6
	.size	FlashGetRandomizer, .-FlashGetRandomizer
	.section	.text.FlashSetRandomizer,"ax",%progbits
	.align	1
	.global	FlashSetRandomizer
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashSetRandomizer, %function
FlashSetRandomizer:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	and	r2, r1, #127
	ldr	r3, .L40
	mov	r5, r0
	ldrh	r4, [r3, r2, lsl #1]
	ldr	r3, .L40+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L33
	bl	FlashRsvdBlkChk
	cbz	r0, .L33
	orr	r4, r4, #-1073741824
.L33:
	ldr	r3, .L40+8
	ldr	r3, [r3, r5, lsl #3]
	str	r4, [r3, #336]
	pop	{r3, r4, r5, pc}
.L41:
	.align	2
.L40:
	.word	.LANCHOR5
	.word	.LANCHOR6
	.word	.LANCHOR0
	.size	FlashSetRandomizer, .-FlashSetRandomizer
	.section	.text.FlashBlockAlignInit,"ax",%progbits
	.align	1
	.global	FlashBlockAlignInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashBlockAlignInit, %function
FlashBlockAlignInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	cmp	r0, #256
	ldr	r3, .L47
	bls	.L43
	mov	r2, #512
.L46:
	str	r2, [r3]
	bx	lr
.L43:
	cmp	r0, #128
	bhi	.L45
	str	r0, [r3]
	bx	lr
.L45:
	mov	r2, #256
	b	.L46
.L48:
	.align	2
.L47:
	.word	.LANCHOR4
	.size	FlashBlockAlignInit, .-FlashBlockAlignInit
	.section	.text.FlashReadCmd,"ax",%progbits
	.align	1
	.global	FlashReadCmd
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadCmd, %function
FlashReadCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r4, r5}
	lsrs	r2, r1, #16
	ldr	r4, .L50
	ldr	r3, [r4, r0, lsl #3]
	add	r4, r4, r0, lsl #3
	ldrb	r4, [r4, #4]	@ zero_extendqisi2
	add	r3, r3, r4, lsl #8
	movs	r4, #0
	str	r4, [r3, #2056]
	str	r4, [r3, #2052]
	str	r4, [r3, #2052]
	uxtb	r4, r1
	str	r4, [r3, #2052]
	lsrs	r4, r1, #8
	str	r4, [r3, #2052]
	str	r2, [r3, #2052]
	movs	r2, #48
	str	r2, [r3, #2056]
	pop	{r4, r5}
	b	FlashSetRandomizer
.L51:
	.align	2
.L50:
	.word	.LANCHOR0
	.size	FlashReadCmd, .-FlashReadCmd
	.section	.text.FlashReadDpDataOutCmd,"ax",%progbits
	.align	1
	.global	FlashReadDpDataOutCmd
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadDpDataOutCmd, %function
FlashReadDpDataOutCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L56
	push	{r4, r5, r6}
	uxtb	r6, r1
	ldr	r4, .L56+4
	lsrs	r5, r1, #8
	ldr	r3, [r2, r0, lsl #3]
	add	r2, r2, r0, lsl #3
	ldrb	r4, [r4, #16]	@ zero_extendqisi2
	ldrb	r2, [r2, #4]	@ zero_extendqisi2
	cmp	r4, #1
	lsr	r4, r1, #16
	lsl	r2, r2, #8
	add	r3, r3, r2
	bne	.L53
	movs	r2, #6
	str	r2, [r3, #2056]
	movs	r2, #0
	str	r2, [r3, #2052]
	str	r2, [r3, #2052]
	str	r6, [r3, #2052]
	str	r5, [r3, #2052]
	str	r4, [r3, #2052]
.L55:
	movs	r2, #224
	str	r2, [r3, #2056]
	pop	{r4, r5, r6}
	b	FlashSetRandomizer
.L53:
	movs	r2, #0
	str	r2, [r3, #2056]
	str	r2, [r3, #2052]
	str	r2, [r3, #2052]
	str	r6, [r3, #2052]
	str	r5, [r3, #2052]
	str	r4, [r3, #2052]
	movs	r4, #5
	str	r4, [r3, #2056]
	str	r2, [r3, #2052]
	str	r2, [r3, #2052]
	b	.L55
.L57:
	.align	2
.L56:
	.word	.LANCHOR0
	.word	.LANCHOR7
	.size	FlashReadDpDataOutCmd, .-FlashReadDpDataOutCmd
	.section	.text.FlashProgFirstCmd,"ax",%progbits
	.align	1
	.global	FlashProgFirstCmd
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashProgFirstCmd, %function
FlashProgFirstCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r4, r5}
	lsrs	r2, r1, #16
	ldr	r4, .L59
	ldr	r3, [r4, r0, lsl #3]
	add	r4, r4, r0, lsl #3
	ldrb	r4, [r4, #4]	@ zero_extendqisi2
	add	r3, r3, r4, lsl #8
	movs	r4, #128
	str	r4, [r3, #2056]
	movs	r4, #0
	str	r4, [r3, #2052]
	str	r4, [r3, #2052]
	uxtb	r4, r1
	str	r4, [r3, #2052]
	lsrs	r4, r1, #8
	str	r4, [r3, #2052]
	str	r2, [r3, #2052]
	pop	{r4, r5}
	b	FlashSetRandomizer
.L60:
	.align	2
.L59:
	.word	.LANCHOR0
	.size	FlashProgFirstCmd, .-FlashProgFirstCmd
	.section	.text.FlashEraseCmd,"ax",%progbits
	.align	1
	.global	FlashEraseCmd
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashEraseCmd, %function
FlashEraseCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	r4, .L66
	ldr	r3, [r4, r0, lsl #3]
	add	r4, r4, r0, lsl #3
	ldrb	r0, [r4, #4]	@ zero_extendqisi2
	lsls	r0, r0, #8
	cbz	r2, .L62
	adds	r2, r3, r0
	movs	r4, #96
	str	r4, [r2, #2056]
	uxtb	r4, r1
	str	r4, [r2, #2052]
	lsrs	r4, r1, #8
	str	r4, [r2, #2052]
	lsrs	r4, r1, #16
	str	r4, [r2, #2052]
	ldr	r2, .L66+4
	ldr	r2, [r2]
	add	r1, r1, r2
.L62:
	add	r3, r3, r0
	movs	r2, #96
	str	r2, [r3, #2056]
	uxtb	r2, r1
	str	r2, [r3, #2052]
	lsrs	r2, r1, #8
	lsrs	r1, r1, #16
	str	r2, [r3, #2052]
	movs	r2, #208
	str	r1, [r3, #2052]
	str	r2, [r3, #2056]
	pop	{r4, pc}
.L67:
	.align	2
.L66:
	.word	.LANCHOR0
	.word	.LANCHOR4
	.size	FlashEraseCmd, .-FlashEraseCmd
	.section	.text.FlashProgDpSecondCmd,"ax",%progbits
	.align	1
	.global	FlashProgDpSecondCmd
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashProgDpSecondCmd, %function
FlashProgDpSecondCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r4, r5}
	lsrs	r2, r1, #16
	ldr	r4, .L69
	ldr	r3, [r4, r0, lsl #3]
	add	r4, r4, r0, lsl #3
	ldrb	r5, [r4, #4]	@ zero_extendqisi2
	ldr	r4, .L69+4
	ldrb	r4, [r4, #11]	@ zero_extendqisi2
	add	r3, r3, r5, lsl #8
	str	r4, [r3, #2056]
	movs	r4, #0
	str	r4, [r3, #2052]
	str	r4, [r3, #2052]
	uxtb	r4, r1
	str	r4, [r3, #2052]
	lsrs	r4, r1, #8
	str	r4, [r3, #2052]
	str	r2, [r3, #2052]
	pop	{r4, r5}
	b	FlashSetRandomizer
.L70:
	.align	2
.L69:
	.word	.LANCHOR0
	.word	.LANCHOR7
	.size	FlashProgDpSecondCmd, .-FlashProgDpSecondCmd
	.section	.text.FlashProgSecondCmd,"ax",%progbits
	.align	1
	.global	FlashProgSecondCmd
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashProgSecondCmd, %function
FlashProgSecondCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L72
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r3, r2, r3, lsl #8
	movs	r2, #16
	str	r2, [r3, #2056]
	bx	lr
.L73:
	.align	2
.L72:
	.word	.LANCHOR0
	.size	FlashProgSecondCmd, .-FlashProgSecondCmd
	.section	.text.FlashProgDpFirstCmd,"ax",%progbits
	.align	1
	.global	FlashProgDpFirstCmd
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashProgDpFirstCmd, %function
FlashProgDpFirstCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L75
	ldr	r1, .L75+4
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r1, [r1, #10]	@ zero_extendqisi2
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r3, r2, r3, lsl #8
	str	r1, [r3, #2056]
	bx	lr
.L76:
	.align	2
.L75:
	.word	.LANCHOR0
	.word	.LANCHOR7
	.size	FlashProgDpFirstCmd, .-FlashProgDpFirstCmd
	.section	.text.FlashReadStatus,"ax",%progbits
	.align	1
	.global	FlashReadStatus
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadStatus, %function
FlashReadStatus:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r2, #112
	ldr	r3, .L78
	ldr	r5, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	movs	r0, #80
	ldrb	r4, [r3, #4]	@ zero_extendqisi2
	add	r3, r5, r4, lsl #8
	adds	r4, r4, #8
	lsls	r4, r4, #8
	str	r2, [r3, #2056]
	bl	udelay
	ldr	r0, [r5, r4]
	pop	{r3, r4, r5, pc}
.L79:
	.align	2
.L78:
	.word	.LANCHOR0
	.size	FlashReadStatus, .-FlashReadStatus
	.section	.text.js_hash,"ax",%progbits
	.align	1
	.global	js_hash
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	js_hash, %function
js_hash:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L83
	add	r1, r1, r0
	push	{r4, lr}
.L81:
	cmp	r0, r1
	bne	.L82
	mov	r0, r3
	pop	{r4, pc}
.L82:
	lsrs	r2, r3, #2
	ldrb	r4, [r0], #1	@ zero_extendqisi2
	add	r2, r2, r3, lsl #5
	add	r2, r2, r4
	eors	r3, r3, r2
	b	.L81
.L84:
	.align	2
.L83:
	.word	1204201446
	.size	js_hash, .-js_hash
	.section	.text.FlashLoadIdbInfo,"ax",%progbits
	.align	1
	.global	FlashLoadIdbInfo
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashLoadIdbInfo, %function
FlashLoadIdbInfo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r0, #0
	bx	lr
	.size	FlashLoadIdbInfo, .-FlashLoadIdbInfo
	.section	.text.FlashPrintInfo,"ax",%progbits
	.align	1
	.global	FlashPrintInfo
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashPrintInfo, %function
FlashPrintInfo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	FlashPrintInfo, .-FlashPrintInfo
	.section	.text.ToshibaSetRRPara,"ax",%progbits
	.align	1
	.global	ToshibaSetRRPara
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ToshibaSetRRPara, %function
ToshibaSetRRPara:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	add	r7, r1, r1, lsl #2
	ldr	r10, .L95+12
	mov	r5, r0
	mov	r6, r1
	movs	r4, #0
	ldr	r8, .L95+16
.L88:
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L92
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L92:
	movs	r3, #85
	movs	r0, #200
	str	r3, [r5, #8]
	ldrsb	r3, [r4, r8]
	str	r3, [r5, #4]
	bl	udelay
	ldr	r3, .L95
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L89
	adds	r3, r4, r7
	add	r3, r3, r8
.L94:
	ldrsb	r3, [r3, #5]
.L93:
	str	r3, [r5]
	adds	r4, r4, #1
	b	.L88
.L89:
	cmp	r3, #35
	bne	.L91
	ldr	r3, .L95+4
	adds	r2, r4, r7
	add	r3, r3, r2
	b	.L94
.L91:
	ldr	r3, .L95+8
	ldrsb	r3, [r3, r6]
	b	.L93
.L96:
	.align	2
.L95:
	.word	.LANCHOR9
	.word	.LANCHOR10
	.word	.LANCHOR11
	.word	.LANCHOR12
	.word	.LANCHOR8
	.size	ToshibaSetRRPara, .-ToshibaSetRRPara
	.section	.text.SamsungSetRRPara,"ax",%progbits
	.align	1
	.global	SamsungSetRRPara
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	SamsungSetRRPara, %function
SamsungSetRRPara:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r6, r0
	ldr	r7, .L100
	movs	r4, #0
	mov	r10, #161
	ldr	r8, .L100+4
	add	r1, r7, r1, lsl #2
	adds	r5, r1, #3
.L98:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L99
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L99:
	movs	r3, #0
	str	r10, [r6, #8]
	str	r3, [r6]
	mov	r0, #300
	ldrsb	r3, [r7, r4]
	adds	r4, r4, #1
	str	r3, [r6]
	ldrsb	r3, [r5, #1]!
	str	r3, [r6]
	bl	udelay
	b	.L98
.L101:
	.align	2
.L100:
	.word	.LANCHOR13
	.word	.LANCHOR12
	.size	SamsungSetRRPara, .-SamsungSetRRPara
	.global	__aeabi_uidiv
	.global	__aeabi_uidivmod
	.section	.text.LogAddr2PhyAddr,"ax",%progbits
	.align	1
	.global	LogAddr2PhyAddr
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	LogAddr2PhyAddr, %function
LogAddr2PhyAddr:
	@ args = 4, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r6, r3
	ldr	r3, .L107
	mov	r8, r1
	mov	r7, r2
	mov	r5, r0
	ldrh	r4, [r3, #14]
	ldrh	r3, [r3, #12]
	smulbb	r4, r4, r3
	ldr	r3, .L107+4
	ldrh	fp, [r3]
	uxth	r4, r4
	ldr	r3, .L107+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	ldr	r3, [r0, #4]
	it	eq
	lsleq	r1, fp, #1
	ubfx	r2, r3, #10, #16
	it	eq
	uxtheq	fp, r1
	mov	r0, r2
	str	r3, [sp, #4]
	mov	r1, r4
	str	r2, [sp]
	bl	__aeabi_uidiv
	ldr	r2, [sp]
	uxth	r10, r0
	mov	r1, r4
	mov	r0, r2
	bl	__aeabi_uidivmod
	ldr	r3, [sp, #4]
	cmp	r8, #1
	uxth	r1, r1
	ubfx	r3, r3, #0, #10
	bne	.L104
	ldr	r2, .L107+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L104
	ldr	r2, .L107+16
	ldrh	r3, [r2, r3, lsl #1]
.L104:
	ldr	r2, .L107+20
	ldr	r2, [r2, r10, lsl #2]
	mla	r1, fp, r1, r2
	add	r1, r1, r3
	ldrb	r3, [sp, #40]	@ zero_extendqisi2
	str	r1, [r7]
	str	r10, [r6]
	cmp	r3, #1
	bls	.L106
	ldr	r0, [r5, #4]
	ldr	r3, [r5, #40]
	add	r0, r0, #1024
	subs	r3, r0, r3
	rsbs	r0, r3, #0
	adcs	r0, r0, r3
.L105:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L106:
	movs	r0, #0
	b	.L105
.L108:
	.align	2
.L107:
	.word	.LANCHOR14
	.word	.LANCHOR4
	.word	.LANCHOR2
	.word	.LANCHOR15
	.word	.LANCHOR16
	.word	.LANCHOR17
	.size	LogAddr2PhyAddr, .-LogAddr2PhyAddr
	.section	.text.FlashReadStatusEN,"ax",%progbits
	.align	1
	.global	FlashReadStatusEN
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadStatusEN, %function
FlashReadStatusEN:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L121
	push	{r4, r5, r6, lr}
	ldr	r5, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r4, [r3, #4]	@ zero_extendqisi2
	ldr	r3, .L121+4
	ldr	r3, [r3]
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	cmp	r3, #2
	lsl	r3, r4, #8
	add	r4, r4, #8
	bne	.L110
	ldr	r0, .L121+8
	cbnz	r2, .L111
	ldrb	r2, [r0, #13]	@ zero_extendqisi2
.L120:
	add	r3, r3, r5
	str	r2, [r3, #2056]
	ldrb	r0, [r0, #15]	@ zero_extendqisi2
	cbz	r0, .L115
	add	r6, r5, r4, lsl #8
	movs	r2, #0
.L114:
	cmp	r2, r0
	bcc	.L116
.L115:
	lsls	r4, r4, #8
	movs	r0, #80
	bl	udelay
	ldr	r0, [r5, r4]
	uxtb	r0, r0
	pop	{r4, r5, r6, pc}
.L111:
	ldrb	r2, [r0, #14]	@ zero_extendqisi2
	b	.L120
.L116:
	lsls	r3, r2, #3
	adds	r2, r2, #1
	lsr	r3, r1, r3
	uxtb	r3, r3
	str	r3, [r6, #4]
	b	.L114
.L110:
	add	r3, r3, r5
	movs	r2, #112
	str	r2, [r3, #2056]
	b	.L115
.L122:
	.align	2
.L121:
	.word	.LANCHOR0
	.word	.LANCHOR18
	.word	.LANCHOR7
	.size	FlashReadStatusEN, .-FlashReadStatusEN
	.section	.text.FlashWaitReadyEN,"ax",%progbits
	.align	1
	.global	FlashWaitReadyEN
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashWaitReadyEN, %function
FlashWaitReadyEN:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r4, r0
	mov	r5, r1
	mov	r6, r2
.L127:
	mov	r2, r6
	mov	r1, r5
	mov	r0, r4
	bl	FlashReadStatusEN
	cmp	r0, #255
	mov	r3, r0
	beq	.L127
	lsls	r3, r3, #25
	bpl	.L127
	pop	{r4, r5, r6, pc}
	.size	FlashWaitReadyEN, .-FlashWaitReadyEN
	.section	.text.NandcReadDontCaseBusyEn,"ax",%progbits
	.align	1
	.global	NandcReadDontCaseBusyEn
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcReadDontCaseBusyEn, %function
NandcReadDontCaseBusyEn:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	NandcReadDontCaseBusyEn, .-NandcReadDontCaseBusyEn
	.section	.text.NandcGetChipIf,"ax",%progbits
	.align	1
	.global	NandcGetChipIf
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcGetChipIf, %function
NandcGetChipIf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L132
	add	r3, r2, r0, lsl #3
	ldr	r0, [r2, r0, lsl #3]
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	adds	r3, r3, #8
	add	r0, r0, r3, lsl #8
	bx	lr
.L133:
	.align	2
.L132:
	.word	.LANCHOR0
	.size	NandcGetChipIf, .-NandcGetChipIf
	.section	.text.NandcSetDdrPara,"ax",%progbits
	.align	1
	.global	NandcSetDdrPara
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcSetDdrPara, %function
NandcSetDdrPara:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L135
	ldr	r2, [r3]
	lsls	r3, r0, #8
	orr	r0, r3, r0, lsl #16
	orr	r0, r0, #1
	str	r0, [r2, #304]
	bx	lr
.L136:
	.align	2
.L135:
	.word	.LANCHOR19
	.size	NandcSetDdrPara, .-NandcSetDdrPara
	.section	.text.NandcSetDdrDiv,"ax",%progbits
	.align	1
	.global	NandcSetDdrDiv
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcSetDdrDiv, %function
NandcSetDdrDiv:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L138
	orr	r0, r0, #16640
	ldr	r3, [r3]
	str	r0, [r3, #344]
	bx	lr
.L139:
	.align	2
.L138:
	.word	.LANCHOR19
	.size	NandcSetDdrDiv, .-NandcSetDdrDiv
	.section	.text.NandcSetDdrMode,"ax",%progbits
	.align	1
	.global	NandcSetDdrMode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcSetDdrMode, %function
NandcSetDdrMode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L143
	ldr	r2, [r3]
	ldr	r3, [r2]
	cbnz	r0, .L141
	bfi	r3, r0, #13, #1
.L142:
	str	r3, [r2]
	bx	lr
.L141:
	orr	r3, r3, #253952
	b	.L142
.L144:
	.align	2
.L143:
	.word	.LANCHOR19
	.size	NandcSetDdrMode, .-NandcSetDdrMode
	.section	.text.NandcSetMode,"ax",%progbits
	.align	1
	.global	NandcSetMode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcSetMode, %function
NandcSetMode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L152
	ands	r1, r0, #6
	ldr	r2, [r3]
	ldr	r3, [r2]
	beq	.L146
	lsls	r1, r0, #29
	movw	r1, #16641
	str	r1, [r2, #344]
	orr	r3, r3, #24576
	ldr	r1, .L152+4
	bfc	r3, #15, #1
	orr	r3, r3, #196608
	it	mi
	orrmi	r3, r3, #32768
	str	r1, [r2, #304]
	movs	r1, #38
	str	r1, [r2, #308]
	movs	r1, #39
	str	r1, [r2, #308]
.L148:
	str	r3, [r2]
	movs	r0, #0
	bx	lr
.L146:
	bfi	r3, r1, #13, #1
	b	.L148
.L153:
	.align	2
.L152:
	.word	.LANCHOR19
	.word	1710595
	.size	NandcSetMode, .-NandcSetMode
	.section	.text.NandcFlashCs,"ax",%progbits
	.align	1
	.global	NandcFlashCs
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcFlashCs, %function
NandcFlashCs:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L155
	movs	r2, #1
	ldr	r1, [r3, r0, lsl #3]
	add	r0, r3, r0, lsl #3
	ldrb	r0, [r0, #4]	@ zero_extendqisi2
	ldr	r3, [r1]
	lsls	r2, r2, r0
	bfi	r3, r2, #0, #8
	str	r3, [r1]
	bx	lr
.L156:
	.align	2
.L155:
	.word	.LANCHOR0
	.size	NandcFlashCs, .-NandcFlashCs
	.section	.text.NandcFlashDeCs,"ax",%progbits
	.align	1
	.global	NandcFlashDeCs
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcFlashDeCs, %function
NandcFlashDeCs:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L158
	ldr	r2, [r3, r0, lsl #3]
	ldr	r3, [r2]
	bfc	r3, #0, #8
	bfc	r3, #17, #1
	str	r3, [r2]
	bx	lr
.L159:
	.align	2
.L158:
	.word	.LANCHOR0
	.size	NandcFlashDeCs, .-NandcFlashDeCs
	.section	.text.HynixSetRRPara,"ax",%progbits
	.align	1
	.global	HynixSetRRPara
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	HynixSetRRPara, %function
HynixSetRRPara:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r6, r3
	ldr	r3, .L169
	mov	r5, r0
	mov	r7, r1
	mov	r10, r2
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cmp	r3, #6
	bne	.L161
	movs	r4, #20
	add	r4, r4, r0, lsl #6
	add	r3, r4, r6, lsl #2
.L167:
	ldr	r4, .L169+4
.L168:
	add	r4, r4, r3
.L162:
	ldr	r3, .L169+8
	mov	r0, r5
	subs	r7, r7, #1
	subs	r4, r4, #1
	add	r7, r7, r10
	ldr	r8, [r3, r5, lsl #3]
	add	r3, r3, r5, lsl #3
	ldrb	fp, [r3, #4]	@ zero_extendqisi2
	bl	NandcFlashCs
	movs	r3, #54
	lsl	fp, fp, #8
	add	r0, r8, fp
	str	r3, [r0, #2056]
	add	r3, r10, #-1
	mov	r10, r0
.L165:
	cmp	r3, r7
	bne	.L166
	movs	r3, #22
	add	r8, r8, fp
	str	r3, [r8, #2056]
	mov	r0, r5
	bl	NandcFlashDeCs
	ldr	r3, .L169+12
	strb	r6, [r3, r5]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L161:
	cmp	r3, #7
	bne	.L163
	movs	r4, #28
	movs	r3, #160
	smlabb	r3, r3, r0, r4
	movs	r4, #10
	smlabb	r3, r4, r6, r3
	b	.L167
.L163:
	cmp	r3, #8
	bne	.L164
	add	r4, r6, r6, lsl #2
	ldr	r3, .L169+16
	b	.L168
.L164:
	adds	r4, r6, #2
	add	r3, r4, r0, lsl #3
	ldr	r4, .L169+4
	add	r4, r4, r3, lsl #3
	adds	r4, r4, #4
	b	.L162
.L166:
	ldrb	r2, [r3, #1]!	@ zero_extendqisi2
	movs	r0, #200
	str	r2, [r10, #2052]
	str	r3, [sp, #4]
	bl	udelay
	ldrsb	r2, [r4, #1]!
	ldr	r3, [sp, #4]
	str	r2, [r10, #2048]
	b	.L165
.L170:
	.align	2
.L169:
	.word	.LANCHOR18
	.word	.LANCHOR20
	.word	.LANCHOR0
	.word	.LANCHOR21
	.word	.LANCHOR20+28
	.size	HynixSetRRPara, .-HynixSetRRPara
	.section	.text.FlashSetReadRetryDefault,"ax",%progbits
	.align	1
	.global	FlashSetReadRetryDefault
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashSetReadRetryDefault, %function
FlashSetReadRetryDefault:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L177
	push	{r4, r5, r6, lr}
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #7
	bhi	.L171
	ldr	r5, .L177+4
	movs	r4, #0
	adds	r6, r5, #4
.L174:
	ldr	r3, .L177+8
	uxtb	r0, r4
	ldrb	r3, [r3, r4, lsl #3]	@ zero_extendqisi2
	cmp	r3, #173
	bne	.L173
	movs	r3, #0
	mov	r2, r6
	ldrb	r1, [r5, #1]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L173:
	adds	r4, r4, #1
	cmp	r4, #4
	bne	.L174
.L171:
	pop	{r4, r5, r6, pc}
.L178:
	.align	2
.L177:
	.word	.LANCHOR18
	.word	.LANCHOR20
	.word	.LANCHOR22
	.size	FlashSetReadRetryDefault, .-FlashSetReadRetryDefault
	.section	.text.FlashWaitCmdDone,"ax",%progbits
	.align	1
	.global	FlashWaitCmdDone
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashWaitCmdDone, %function
FlashWaitCmdDone:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L186
	lsls	r3, r0, #4
	push	{r4, r5, r6, lr}
	mov	r6, r0
	adds	r4, r2, r3
	ldr	r1, [r4, #8]
	cbz	r1, .L181
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	mov	r0, r5
	bl	NandcFlashCs
	ldr	r3, .L186+4
	mov	r0, r5
	ldr	r1, [r4, #4]
	ldr	r2, [r3, r6, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	mov	r1, r0
	mov	r0, r5
	bl	NandcFlashDeCs
	ldr	r3, [r4, #8]
	sbfx	r1, r1, #0, #1
	ldr	r2, [r4, #12]
	str	r1, [r3]
	movs	r3, #0
	str	r3, [r4, #8]
	cbz	r2, .L181
	str	r1, [r2]
	str	r3, [r4, #12]
.L181:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L187:
	.align	2
.L186:
	.word	.LANCHOR23
	.word	.LANCHOR17
	.size	FlashWaitCmdDone, .-FlashWaitCmdDone
	.section	.text.NandcDelayns,"ax",%progbits
	.align	1
	.global	NandcDelayns
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcDelayns, %function
NandcDelayns:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	udelay
	movs	r0, #0
	pop	{r3, pc}
	.size	NandcDelayns, .-NandcDelayns
	.section	.text.NandcWaitFlashReadyNoDelay,"ax",%progbits
	.align	1
	.global	NandcWaitFlashReadyNoDelay
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcWaitFlashReadyNoDelay, %function
NandcWaitFlashReadyNoDelay:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L194
	push	{r0, r1, r2, r4, r5, lr}
	ldr	r4, .L194+4
	ldr	r5, [r3, r0, lsl #3]
.L191:
	ldr	r3, [r5]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #22
	bmi	.L192
	movs	r0, #10
	bl	udelay
	subs	r4, r4, #1
	bne	.L191
	mov	r0, #-1
.L189:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, pc}
.L192:
	movs	r0, #0
	b	.L189
.L195:
	.align	2
.L194:
	.word	.LANCHOR0
	.word	100000
	.size	NandcWaitFlashReadyNoDelay, .-NandcWaitFlashReadyNoDelay
	.section	.text.NandcWaitFlashReady,"ax",%progbits
	.align	1
	.global	NandcWaitFlashReady
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcWaitFlashReady, %function
NandcWaitFlashReady:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, lr}
	ldr	r3, .L201
	ldr	r4, .L201+4
	ldr	r5, [r3, r0, lsl #3]
	movs	r0, #150
	bl	udelay
.L198:
	ldr	r3, [r5]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #22
	bmi	.L199
	movs	r0, #10
	bl	udelay
	subs	r4, r4, #1
	bne	.L198
	mov	r0, #-1
.L196:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, pc}
.L199:
	movs	r0, #0
	b	.L196
.L202:
	.align	2
.L201:
	.word	.LANCHOR0
	.word	100000
	.size	NandcWaitFlashReady, .-NandcWaitFlashReady
	.section	.text.FlashReset,"ax",%progbits
	.align	1
	.global	FlashReset
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReset, %function
FlashReset:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L204
	push	{r4, r5, r6, lr}
	mov	r4, r0
	ldr	r5, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r6, [r3, #4]	@ zero_extendqisi2
	bl	NandcFlashCs
	movs	r3, #255
	mov	r0, r4
	add	r5, r5, r6, lsl #8
	str	r3, [r5, #2056]
	bl	NandcWaitFlashReady
	mov	r0, r4
	pop	{r4, r5, r6, lr}
	b	NandcFlashDeCs
.L205:
	.align	2
.L204:
	.word	.LANCHOR0
	.size	FlashReset, .-FlashReset
	.section	.text.flash_enter_slc_mode,"ax",%progbits
	.align	1
	.global	flash_enter_slc_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_enter_slc_mode, %function
flash_enter_slc_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r5, r0
	ldr	r3, .L208
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L206
	bl	NandcFlashCs
	ldr	r3, .L208+4
	movs	r0, #100
	ldr	r4, [r3, r5, lsl #3]
	add	r3, r3, r5, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r4, r4, r3, lsl #8
	movs	r3, #239
	str	r3, [r4, #2056]
	movs	r3, #145
	str	r3, [r4, #2052]
	bl	udelay
	movs	r3, #0
	movs	r2, #1
	str	r3, [r4, #2048]
	movs	r0, #100
	str	r2, [r4, #2048]
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	bl	udelay
	mov	r0, r5
	bl	NandcWaitFlashReadyNoDelay
	movs	r3, #218
	mov	r0, r5
	str	r3, [r4, #2056]
	pop	{r3, r4, r5, lr}
	b	NandcWaitFlashReady
.L206:
	pop	{r3, r4, r5, pc}
.L209:
	.align	2
.L208:
	.word	.LANCHOR15
	.word	.LANCHOR0
	.size	flash_enter_slc_mode, .-flash_enter_slc_mode
	.section	.text.flash_exit_slc_mode,"ax",%progbits
	.align	1
	.global	flash_exit_slc_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_exit_slc_mode, %function
flash_exit_slc_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r5, r0
	ldr	r3, .L212
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L210
	bl	NandcFlashCs
	ldr	r3, .L212+4
	movs	r0, #100
	ldr	r4, [r3, r5, lsl #3]
	add	r3, r3, r5, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r4, r4, r3, lsl #8
	movs	r3, #239
	str	r3, [r4, #2056]
	movs	r3, #145
	str	r3, [r4, #2052]
	bl	udelay
	movs	r3, #2
	movs	r0, #100
	str	r3, [r4, #2048]
	movs	r3, #1
	str	r3, [r4, #2048]
	movs	r3, #0
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	bl	udelay
	mov	r0, r5
	bl	NandcWaitFlashReadyNoDelay
	movs	r3, #223
	mov	r0, r5
	str	r3, [r4, #2056]
	pop	{r3, r4, r5, lr}
	b	NandcWaitFlashReady
.L210:
	pop	{r3, r4, r5, pc}
.L213:
	.align	2
.L212:
	.word	.LANCHOR15
	.word	.LANCHOR0
	.size	flash_exit_slc_mode, .-flash_exit_slc_mode
	.section	.text.FlashEraseBlock,"ax",%progbits
	.align	1
	.global	FlashEraseBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashEraseBlock, %function
FlashEraseBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r4, r0
	mov	r5, r1
	mov	r6, r2
	bl	NandcWaitFlashReady
	mov	r0, r4
	bl	NandcFlashCs
	mov	r2, r6
	mov	r1, r5
	mov	r0, r4
	bl	FlashEraseCmd
	mov	r0, r4
	bl	NandcWaitFlashReady
	mov	r1, r5
	mov	r0, r4
	bl	FlashReadStatus
	mov	r1, r0
	mov	r0, r4
	bl	NandcFlashDeCs
	and	r0, r1, #1
	pop	{r4, r5, r6, pc}
	.size	FlashEraseBlock, .-FlashEraseBlock
	.section	.text.FlashSetInterfaceMode,"ax",%progbits
	.align	1
	.global	FlashSetInterfaceMode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashSetInterfaceMode, %function
FlashSetInterfaceMode:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L243
	mov	ip, #128
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r5, #0
	movs	r7, #239
	mov	lr, #1
	mov	r8, #35
	mov	r10, #32
	ldrb	r3, [r3]	@ zero_extendqisi2
	and	r2, r3, #4
	and	r3, r3, #1
	str	r2, [sp, #4]
	mov	r2, r5
	str	r3, [sp]
.L225:
	ldr	r3, .L243+4
	ldrb	r4, [r5, r3]	@ zero_extendqisi2
	cmp	r4, #152
	beq	.L216
	cmp	r4, #69
	beq	.L216
	cmp	r4, #173
	beq	.L216
	cmp	r4, #44
	bne	.L217
.L216:
	ldr	r3, .L243+8
	cmp	r0, #1
	ldr	r1, [r5, r3]
	add	r3, r3, r5
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	bne	.L218
	ldr	r6, [sp]
	cbz	r6, .L217
	lsls	r3, r3, #8
	cmp	r4, #173
	add	fp, r1, r3
	str	r7, [fp, #2056]
	bne	.L219
	str	r0, [fp, #2052]
.L242:
	str	r2, [fp, #2048]
	b	.L223
.L219:
	cmp	r4, #44
	ittet	eq
	moveq	r4, #5
	streq	r0, [fp, #2052]
	strne	ip, [fp, #2052]
	streq	r4, [fp, #2048]
	it	ne
	strne	r0, [fp, #2048]
.L223:
	add	r3, r3, r1
	str	r2, [r3, #2048]
	str	r2, [r3, #2048]
	str	r2, [r3, #2048]
.L217:
	adds	r5, r5, #8
	cmp	r5, #32
	bne	.L225
	movs	r0, #0
	bl	NandcWaitFlashReady
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L218:
	ldr	r6, [sp, #4]
	cmp	r6, #0
	beq	.L217
	lsls	r3, r3, #8
	cmp	r4, #173
	add	fp, r1, r3
	str	r7, [fp, #2056]
	bne	.L222
	str	lr, [fp, #2052]
	str	r10, [fp, #2048]
	b	.L223
.L222:
	cmp	r4, #44
	bne	.L224
	str	lr, [fp, #2052]
	str	r8, [fp, #2048]
	b	.L223
.L224:
	str	ip, [fp, #2052]
	b	.L242
.L244:
	.align	2
.L243:
	.word	.LANCHOR24
	.word	.LANCHOR22
	.word	.LANCHOR0
	.size	FlashSetInterfaceMode, .-FlashSetInterfaceMode
	.section	.text.SandiskSetRRPara,"ax",%progbits
	.align	1
	.global	SandiskSetRRPara
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	SandiskSetRRPara, %function
SandiskSetRRPara:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r3, #239
	str	r3, [r0, #8]
	movs	r3, #17
	mov	r5, r0
	mov	r4, r1
	str	r3, [r0, #4]
	movs	r0, #200
	bl	udelay
	ldr	r3, .L251
	add	r4, r4, r4, lsl #2
	ldr	r6, .L251+4
	movs	r2, #0
	ldr	r7, .L251+8
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r3, .L251+12
	ldrb	r0, [r3]	@ zero_extendqisi2
.L246:
	cmp	r2, r1
	bcc	.L249
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, lr}
	b	NandcWaitFlashReady
.L249:
	adds	r3, r2, r4
	cmp	r0, #67
	ite	eq
	addeq	r3, r3, r7
	addne	r3, r3, r6
	ldrsb	r3, [r3, #5]
	adds	r2, r2, #1
	str	r3, [r5]
	b	.L246
.L252:
	.align	2
.L251:
	.word	.LANCHOR12
	.word	.LANCHOR10
	.word	.LANCHOR8
	.word	.LANCHOR9
	.size	SandiskSetRRPara, .-SandiskSetRRPara
	.section	.text.micron_auto_read_calibration_config,"ax",%progbits
	.align	1
	.global	micron_auto_read_calibration_config
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	micron_auto_read_calibration_config, %function
micron_auto_read_calibration_config:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r5, r0
	mov	r6, r1
	bl	NandcWaitFlashReady
	ldr	r0, .L254
	ldr	r4, [r0, r5, lsl #3]
	add	r0, r0, r5, lsl #3
	ldrb	r3, [r0, #4]	@ zero_extendqisi2
	movs	r0, #200
	add	r4, r4, r3, lsl #8
	movs	r3, #239
	str	r3, [r4, #2056]
	movs	r3, #150
	str	r3, [r4, #2052]
	bl	udelay
	movs	r3, #0
	str	r6, [r4, #2048]
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	str	r3, [r4, #2048]
	pop	{r4, r5, r6, pc}
.L255:
	.align	2
.L254:
	.word	.LANCHOR0
	.size	micron_auto_read_calibration_config, .-micron_auto_read_calibration_config
	.section	.text.FlashEraseSLc2KBlocks,"ax",%progbits
	.align	1
	.global	FlashEraseSLc2KBlocks
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashEraseSLc2KBlocks, %function
FlashEraseSLc2KBlocks:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	r7, r1
	ldr	r8, .L266+12
	sub	sp, sp, #20
	mov	r5, r0
	movs	r6, #0
	ldr	r10, .L266+16
.L257:
	cmp	r6, r7
	bne	.L262
	movs	r0, #0
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L262:
	subs	r3, r7, r6
	add	r2, sp, #8
	uxtb	r3, r3
	movs	r1, #0
	mov	r0, r5
	str	r3, [sp]
	add	r3, sp, #12
	bl	LogAddr2PhyAddr
	ldr	r3, [sp, #12]
	ldrb	r2, [r8]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L258
	mov	r3, #-1
	str	r3, [r5]
.L259:
	adds	r6, r6, #1
	adds	r5, r5, #36
	b	.L257
.L258:
	ldrb	r4, [r10, r3]	@ zero_extendqisi2
	lsls	r3, r3, #4
	ldr	r2, .L266
	mov	r0, r4
	strb	r4, [r2, r3]
	bl	NandcWaitFlashReady
	mov	r0, r4
	bl	NandcFlashCs
	movs	r2, #0
	ldr	r1, [sp, #8]
	mov	r0, r4
	bl	FlashEraseCmd
	mov	r0, r4
	bl	NandcWaitFlashReady
	ldr	r1, [sp, #8]
	mov	r0, r4
	bl	FlashReadStatus
	ldr	r3, .L266+4
	sbfx	r0, r0, #0, #1
	str	r0, [r5]
	movs	r2, #0
	ldr	r1, [sp, #8]
	mov	r0, r4
	ldr	r3, [r3]
	add	r1, r1, r3
	bl	FlashEraseCmd
	mov	r0, r4
	bl	NandcWaitFlashReady
	ldr	r1, [sp, #8]
	mov	r0, r4
	bl	FlashReadStatus
	lsls	r3, r0, #31
	itt	mi
	movmi	r3, #-1
	strmi	r3, [r5]
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L261
	ldr	r1, [sp, #8]
	ldr	r0, .L266+8
	bl	printf
.L261:
	mov	r0, r4
	bl	NandcFlashDeCs
	b	.L259
.L267:
	.align	2
.L266:
	.word	.LANCHOR23
	.word	.LANCHOR4
	.word	.LC1
	.word	.LANCHOR25
	.word	.LANCHOR26
	.size	FlashEraseSLc2KBlocks, .-FlashEraseSLc2KBlocks
	.section	.text.FlashEraseBlocks,"ax",%progbits
	.align	1
	.global	FlashEraseBlocks
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashEraseBlocks, %function
FlashEraseBlocks:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L299
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r0
	sub	sp, sp, #24
	mov	fp, r1
	mov	r7, r2
	ldrb	r4, [r3]	@ zero_extendqisi2
	cbnz	r4, .L269
	ldr	r10, .L299+8
.L270:
	cmp	r4, r7
	bcc	.L279
	ldr	r5, .L299+4
	movs	r4, #0
	ldr	r6, .L299+8
.L280:
	ldr	r3, .L299+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L282
	ldr	r3, .L299+16
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L283
.L284:
	movs	r0, #0
	b	.L268
.L269:
	mov	r1, r2
	bl	FlashEraseSLc2KBlocks
.L268:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L279:
	movs	r5, #36
	add	r2, sp, #16
	muls	r5, r4, r5
	movs	r1, #0
	add	r3, r8, r5
	str	r3, [sp, #12]
	subs	r3, r7, r4
	uxtb	r3, r3
	ldr	r0, [sp, #12]
	str	r3, [sp]
	add	r3, sp, #20
	bl	LogAddr2PhyAddr
	ldr	r3, .L299+12
	mov	r6, r0
	ldr	r0, [sp, #20]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L272
	mov	r3, #-1
	str	r3, [r8, r5]
.L273:
	adds	r4, r4, #1
	b	.L270
.L272:
	ldr	r3, .L299+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	add	r3, r10, r0, lsl #4
	it	eq
	moveq	r6, #0
	ldr	r3, [r3, #8]
	cbz	r3, .L275
	uxtb	r0, r0
	bl	FlashWaitCmdDone
.L275:
	ldr	r1, [sp, #20]
	ldr	r0, [sp, #12]
	lsls	r2, r1, #4
	add	r3, r10, r2
	str	r0, [r3, #8]
	movs	r0, #0
	str	r0, [r3, #12]
	ldr	r0, [sp, #16]
	str	r0, [r3, #4]
	cbz	r6, .L276
	adds	r5, r5, #36
	add	r5, r5, r8
	str	r5, [r3, #12]
.L276:
	ldr	r3, .L299+24
	ldrb	r5, [r3, r1]	@ zero_extendqisi2
	mov	r0, r5
	strb	r5, [r10, r2]
	bl	NandcFlashCs
	cmp	fp, #1
	mov	r0, r5
	bne	.L277
	ldr	r3, .L299+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L277
	bl	flash_enter_slc_mode
.L278:
	ldr	r3, .L299+28
	mov	r0, r5
	ldr	r2, [sp, #20]
	add	r4, r4, r6
	ldr	r1, [sp, #16]
	ldr	r2, [r3, r2, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	mov	r2, r6
	ldr	r1, [sp, #16]
	mov	r0, r5
	bl	FlashEraseCmd
	mov	r0, r5
	bl	NandcFlashDeCs
	b	.L273
.L277:
	bl	flash_exit_slc_mode
	b	.L278
.L282:
	uxtb	r0, r4
	bl	FlashWaitCmdDone
	cmp	fp, #1
	bne	.L281
	ldrb	r3, [r5]	@ zero_extendqisi2
	cbz	r3, .L281
	lsls	r3, r4, #4
	ldrb	r0, [r6, r3]	@ zero_extendqisi2
	bl	flash_exit_slc_mode
.L281:
	adds	r4, r4, #1
	b	.L280
.L283:
	ldr	r3, .L299+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #69
	bne	.L284
	movs	r3, #0
	movs	r2, #36
	mov	r1, r3
.L285:
	cmp	r3, r7
	beq	.L284
	mul	r0, r2, r3
	adds	r3, r3, #1
	str	r1, [r8, r0]
	b	.L285
.L300:
	.align	2
.L299:
	.word	.LANCHOR2
	.word	.LANCHOR15
	.word	.LANCHOR23
	.word	.LANCHOR25
	.word	.LANCHOR28
	.word	.LANCHOR27
	.word	.LANCHOR26
	.word	.LANCHOR17
	.word	.LANCHOR22
	.size	FlashEraseBlocks, .-FlashEraseBlocks
	.section	.text.FlashReadDpCmd,"ax",%progbits
	.align	1
	.global	FlashReadDpCmd
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadDpCmd, %function
FlashReadDpCmd:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r5, r2
	ldr	r3, .L305
	mov	r6, r1
	uxtb	lr, r1
	mov	r7, r0
	lsrs	r1, r1, #8
	uxtb	r8, r5
	ldr	r10, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r4, [r3, #4]	@ zero_extendqisi2
	ldr	r3, .L305+4
	ldrb	r2, [r3, #16]	@ zero_extendqisi2
	lsls	r4, r4, #8
	ldrb	ip, [r3, #8]	@ zero_extendqisi2
	add	r4, r4, r10
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	cmp	r2, #1
	lsr	r2, r6, #16
	str	ip, [r4, #2056]
	bne	.L302
	mov	r10, #0
	str	r10, [r4, #2052]
	str	r10, [r4, #2052]
	str	lr, [r4, #2052]
	str	r1, [r4, #2052]
	str	r2, [r4, #2052]
	str	r3, [r4, #2056]
	bl	NandcWaitFlashReady
	str	r10, [r4, #2056]
	str	r10, [r4, #2052]
	str	r10, [r4, #2052]
.L304:
	lsrs	r3, r5, #8
	lsrs	r5, r5, #16
	str	r8, [r4, #2052]
	str	r3, [r4, #2052]
	movs	r3, #48
	str	r5, [r4, #2052]
	mov	r1, r6
	str	r3, [r4, #2056]
	mov	r0, r7
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	FlashSetRandomizer
.L302:
	str	lr, [r4, #2052]
	str	r1, [r4, #2052]
	str	r2, [r4, #2052]
	str	r3, [r4, #2056]
	b	.L304
.L306:
	.align	2
.L305:
	.word	.LANCHOR0
	.word	.LANCHOR7
	.size	FlashReadDpCmd, .-FlashReadDpCmd
	.section	.text.FlashDeInit,"ax",%progbits
	.align	1
	.global	FlashDeInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashDeInit, %function
FlashDeInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	movs	r0, #0
	bl	NandcWaitFlashReady
	bl	FlashSetReadRetryDefault
	ldr	r3, .L317
	ldr	r0, [r3]
	cbz	r0, .L308
	movs	r0, #0
	bl	flash_enter_slc_mode
.L309:
	ldr	r4, .L317+4
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L310
	ldr	r3, .L317+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L310
	movs	r0, #1
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	movs	r3, #0
	strb	r3, [r4]
.L310:
	ldr	r3, .L317+12
	movs	r0, #0
	ldr	r3, [r3]
	str	r0, [r3, #336]
	pop	{r4, pc}
.L308:
	bl	flash_exit_slc_mode
	b	.L309
.L318:
	.align	2
.L317:
	.word	.LANCHOR29
	.word	.LANCHOR30
	.word	.LANCHOR24
	.word	.LANCHOR0
	.size	FlashDeInit, .-FlashDeInit
	.section	.text.NandcRandmzSel,"ax",%progbits
	.align	1
	.global	NandcRandmzSel
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcRandmzSel, %function
NandcRandmzSel:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L320
	ldr	r3, [r3, r0, lsl #3]
	str	r1, [r3, #336]
	bx	lr
.L321:
	.align	2
.L320:
	.word	.LANCHOR0
	.size	NandcRandmzSel, .-NandcRandmzSel
	.section	.text.NandcTimeCfg,"ax",%progbits
	.align	1
	.global	NandcTimeCfg
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcTimeCfg, %function
NandcTimeCfg:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L327
	cmp	r0, #35
	ldr	r3, [r3]
	bhi	.L323
	movw	r2, #4193
.L326:
	str	r2, [r3, #4]
	bx	lr
.L323:
	cmp	r0, #99
	ite	hi
	movwhi	r2, #8322
	movwls	r2, #4225
	b	.L326
.L328:
	.align	2
.L327:
	.word	.LANCHOR19
	.size	NandcTimeCfg, .-NandcTimeCfg
	.section	.text.FlashTimingCfg,"ax",%progbits
	.align	1
	.global	FlashTimingCfg
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashTimingCfg, %function
FlashTimingCfg:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L330
	ldrb	r0, [r3, #21]	@ zero_extendqisi2
	b	NandcTimeCfg
.L331:
	.align	2
.L330:
	.word	.LANCHOR31
	.size	FlashTimingCfg, .-FlashTimingCfg
	.section	.text.NandcBchSel,"ax",%progbits
	.align	1
	.global	NandcBchSel
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcBchSel, %function
NandcBchSel:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L340
	movs	r1, #0
	push	{r4, lr}
	movs	r4, #16
	cmp	r0, r4
	ldr	r2, [r3]
	mov	r3, #1
	str	r3, [r2, #8]
	ldr	r3, .L340+4
	str	r0, [r3]
	mov	r3, r1
	bfi	r3, r4, #8, #8
	bfi	r3, r1, #18, #1
	bne	.L333
.L336:
	bfc	r3, #4, #1
.L334:
	orr	r3, r3, #1
	str	r3, [r2, #12]
	pop	{r4, pc}
.L333:
	cmp	r0, #24
	bne	.L335
	orr	r3, r3, #16
	b	.L334
.L335:
	cmp	r0, #40
	orr	r3, r3, #262144
	orr	r3, r3, #16
	bne	.L334
	b	.L336
.L341:
	.align	2
.L340:
	.word	.LANCHOR19
	.word	.LANCHOR32
	.size	NandcBchSel, .-NandcBchSel
	.section	.text.FlashBchSel,"ax",%progbits
	.align	1
	.global	FlashBchSel
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashBchSel, %function
FlashBchSel:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L343
	strb	r0, [r3]
	b	NandcBchSel
.L344:
	.align	2
.L343:
	.word	.LANCHOR33
	.size	FlashBchSel, .-FlashBchSel
	.section	.text.NandCIrqEnable,"ax",%progbits
	.align	1
	.global	NandCIrqEnable
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandCIrqEnable, %function
NandCIrqEnable:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	NandCIrqEnable, .-NandCIrqEnable
	.section	.text.NandCIrqDisable,"ax",%progbits
	.align	1
	.global	NandCIrqDisable
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandCIrqDisable, %function
NandCIrqDisable:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	NandCIrqDisable, .-NandCIrqDisable
	.section	.text.rk_nandc_get_irq_status,"ax",%progbits
	.align	1
	.global	rk_nandc_get_irq_status
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_nandc_get_irq_status, %function
rk_nandc_get_irq_status:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r0, [r0, #372]
	bx	lr
	.size	rk_nandc_get_irq_status, .-rk_nandc_get_irq_status
	.section	.text.rk_nandc_flash_ready,"ax",%progbits
	.align	1
	.global	rk_nandc_flash_ready
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_nandc_flash_ready, %function
rk_nandc_flash_ready:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	rk_nandc_flash_ready, .-rk_nandc_flash_ready
	.section	.text.NandcIqrWaitFlashReady,"ax",%progbits
	.align	1
	.global	NandcIqrWaitFlashReady
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcIqrWaitFlashReady, %function
NandcIqrWaitFlashReady:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	NandcIqrWaitFlashReady, .-NandcIqrWaitFlashReady
	.section	.text.rk_nandc_flash_xfer_completed,"ax",%progbits
	.align	1
	.global	rk_nandc_flash_xfer_completed
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_nandc_flash_xfer_completed, %function
rk_nandc_flash_xfer_completed:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	rk_nandc_flash_xfer_completed, .-rk_nandc_flash_xfer_completed
	.section	.text.NandcSendDumpDataStart,"ax",%progbits
	.align	1
	.global	NandcSendDumpDataStart
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcSendDumpDataStart, %function
NandcSendDumpDataStart:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, [r0, #16]
	sub	sp, sp, #8
	ldr	r3, .L352
	str	r2, [sp, #4]
	ldr	r2, [sp, #4]
	bfc	r2, #2, #1
	str	r2, [sp, #4]
	ldr	r2, [sp, #4]
	str	r2, [r0, #16]
	str	r3, [r0, #8]
	orr	r3, r3, #4
	str	r3, [r0, #8]
	add	sp, sp, #8
	@ sp needed
	bx	lr
.L353:
	.align	2
.L352:
	.word	538969130
	.size	NandcSendDumpDataStart, .-NandcSendDumpDataStart
	.section	.text.NandcSendDumpDataDone,"ax",%progbits
	.align	1
	.global	NandcSendDumpDataDone
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcSendDumpDataDone, %function
NandcSendDumpDataDone:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	sub	sp, sp, #8
.L355:
	ldr	r3, [r0, #8]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #11
	bpl	.L355
	add	sp, sp, #8
	@ sp needed
	bx	lr
	.size	NandcSendDumpDataDone, .-NandcSendDumpDataDone
	.section	.text.NandcXferStart,"ax",%progbits
	.align	1
	.global	NandcXferStart
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcXferStart, %function
NandcXferStart:
	@ args = 8, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	mov	r7, r1
	ldr	r1, [sp, #60]
	str	r2, [sp, #4]
	ldr	fp, [sp, #56]
	cmp	r1, #0
	bne	.L372
	adds	r5, fp, #0
	it	ne
	movne	r5, #1
.L359:
	ldr	r1, .L377
	movs	r4, #0
	ldr	r6, [r1, r0, lsl #3]
	add	r1, r1, r0, lsl #3
	movs	r0, #16
	ldr	r8, [r6, #12]
	ldrb	r1, [r1, #4]	@ zero_extendqisi2
	bfi	r8, r0, #8, #8
	bfi	r8, r4, #3, #1
	bfi	r4, r7, #1, #1
	bfi	r8, r1, #5, #3
	orr	r4, r4, #8
	movs	r1, #1
	bfi	r4, r1, #5, #2
	lsrs	r3, r3, r1
	orr	r4, r4, #536870912
	orr	r4, r4, #1024
	bfi	r4, r3, #4, #1
	ldr	r3, .L377+4
	ldr	r3, [r3]
	cmp	r3, #3
	bls	.L360
	ldr	r3, [r6, #16]
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	bfc	r3, #2, #1
	str	r3, [sp, #20]
	cmp	r5, #0
	beq	.L361
	ldr	r5, .L377+8
	cmp	r7, #0
	bne	.L362
.L370:
	ldr	r2, [sp, #4]
	adds	r2, r2, #1
	asrs	r2, r2, #1
	bfi	r4, r2, #22, #6
	cmp	fp, #0
	beq	.L363
	mov	r0, fp
.L364:
	ldr	r3, [r5, #4]
	add	r1, r0, #63
	ubfx	r10, r4, #22, #5
	bic	r1, r1, #63
	str	r0, [r5, #8]
	add	r1, r1, r10, lsl #10
	str	r0, [r5, #16]
	bic	r0, r0, #63
	str	r3, [r5, #12]
	clz	r7, r7
	str	r3, [r5, #20]
	lsrs	r7, r7, #5
	bl	flush_dcache_range
	ldr	r0, [r5, #20]
	add	r1, r0, #63
	bic	r0, r0, #63
	bic	r1, r1, #63
	add	r1, r1, r10, lsl #7
	bl	flush_dcache_range
	movs	r3, #1
	movs	r2, #16
	str	r3, [r5, #24]
	tst	fp, #3
	ldr	r3, [r5, #16]
	str	r3, [r6, #20]
	ldr	r3, [r5, #20]
	str	r3, [r6, #24]
	mov	r3, #0
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	bfi	r3, r2, #9, #5
	it	eq
	moveq	r2, #2
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	orr	r3, r3, #448
	str	r3, [sp, #20]
	ittt	eq
	ldreq	r3, [sp, #20]
	bfieq	r3, r2, #3, #3
	streq	r3, [sp, #20]
	ldr	r3, [sp, #20]
	orr	r3, r3, #4
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	bfi	r3, r7, #1, #1
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	orr	r3, r3, #1
	str	r3, [sp, #20]
.L361:
	ldr	r3, [sp, #20]
	str	r3, [r6, #16]
.L360:
	str	r8, [r6, #12]
	str	r4, [r6, #8]
	orr	r4, r4, #4
	str	r4, [r6, #8]
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L372:
	movs	r5, #1
	b	.L359
.L362:
	ldr	r3, .L377+12
	movs	r1, #0
	ldr	lr, [r5, #4]
	mov	r0, r1
	ldr	r3, [r3]
	cmp	r3, #25
	ite	cc
	movcc	r3, #64
	movcs	r3, #128
	str	r3, [sp, #8]
	ldr	r3, [sp, #4]
	lsrs	r3, r3, #1
	str	r3, [sp, #12]
	ldr	r3, [sp, #60]
.L366:
	ldr	r2, [sp, #12]
	cmp	r0, r2
	bcs	.L370
	ldr	r2, [sp, #60]
	bic	r10, r1, #3
	cbz	r2, .L367
	ldrh	ip, [r3]
	adds	r3, r3, #4
	ldrh	r2, [r3, #-2]
	orr	ip, ip, r2, lsl #16
	str	ip, [lr, r10]
.L368:
	ldr	r2, [sp, #8]
	adds	r0, r0, #1
	add	r1, r1, r2
	b	.L366
.L367:
	mov	r2, #-1
	str	r2, [lr, r10]
	b	.L368
.L363:
	ldr	r3, .L377+8
	ldr	r0, [r3]
	b	.L364
.L378:
	.align	2
.L377:
	.word	.LANCHOR0
	.word	.LANCHOR34
	.word	.LANCHOR35
	.word	.LANCHOR32
	.size	NandcXferStart, .-NandcXferStart
	.section	.text.NandcXferComp,"ax",%progbits
	.align	1
	.global	NandcXferComp
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcXferComp, %function
NandcXferComp:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L407
	push	{r0, r1, r4, lr}
	ldr	r1, [r3, r0, lsl #3]
	ldr	r3, .L407+4
	ldr	r0, [r3]
	cmp	r0, #3
	bls	.L400
	ldr	r3, [r1, #16]
	lsls	r2, r3, #29
	bpl	.L400
	ldr	r3, [r1, #16]
	tst	r3, #2
	ldr	r3, [r1, #8]
	str	r3, [sp]
	beq	.L387
.L383:
	ldr	r2, [r1, #28]
	ldr	r3, [sp]
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	cmp	r2, r3
	bge	.L384
	cmp	r0, #5
	bls	.L383
	ldr	r3, [r1]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #18
	bpl	.L383
	ldr	r3, [sp, #4]
	lsls	r4, r3, #14
	bpl	.L383
.L384:
	ldr	r3, .L407+8
	movs	r2, #0
	str	r2, [r3, #24]
.L379:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L388:
	ldr	r3, [r1, #8]
	str	r3, [sp]
.L387:
	ldr	r3, [sp]
	lsls	r2, r3, #11
	bpl	.L388
	ldr	r4, .L407+12
	ldr	r2, [r4]
	cbz	r2, .L389
	mov	r0, r1
	bl	NandcSendDumpDataStart
.L389:
	ldr	r3, [r4]
	cmp	r3, #0
	beq	.L384
	mov	r0, r1
	bl	NandcSendDumpDataDone
	b	.L384
.L400:
	ldr	r3, [r1, #8]
	str	r3, [sp]
	ldr	r3, [sp]
	lsls	r3, r3, #11
	bpl	.L400
	b	.L379
.L408:
	.align	2
.L407:
	.word	.LANCHOR0
	.word	.LANCHOR34
	.word	.LANCHOR35
	.word	.LANCHOR36
	.size	NandcXferComp, .-NandcXferComp
	.section	.text.Ftl_log2,"ax",%progbits
	.align	1
	.global	Ftl_log2
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	Ftl_log2, %function
Ftl_log2:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r1, #0
	movs	r2, #1
.L410:
	cmp	r2, r0
	uxth	r3, r1
	add	r1, r1, #1
	bls	.L411
	subs	r0, r3, #1
	uxth	r0, r0
	bx	lr
.L411:
	lsls	r2, r2, #1
	b	.L410
	.size	Ftl_log2, .-Ftl_log2
	.section	.text.FtlPrintInfo,"ax",%progbits
	.align	1
	.global	FtlPrintInfo
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlPrintInfo, %function
FtlPrintInfo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	FtlPrintInfo, .-FtlPrintInfo
	.section	.text.FtlSysBlkNumInit,"ax",%progbits
	.align	1
	.global	FtlSysBlkNumInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlSysBlkNumInit, %function
FtlSysBlkNumInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L414
	cmp	r0, #24
	it	cc
	movcc	r0, #24
	ldr	r2, .L414+4
	str	r0, [r3]
	ldr	r3, .L414+8
	ldrh	r3, [r3]
	muls	r3, r0, r3
	str	r3, [r2]
	ldr	r2, .L414+12
	ldrh	r2, [r2]
	subs	r0, r2, r0
	ldr	r2, .L414+16
	strh	r0, [r2]	@ movhi
	movs	r0, #0
	ldr	r2, .L414+20
	ldr	r2, [r2]
	subs	r3, r2, r3
	ldr	r2, .L414+24
	str	r3, [r2]
	bx	lr
.L415:
	.align	2
.L414:
	.word	.LANCHOR37
	.word	.LANCHOR39
	.word	.LANCHOR38
	.word	.LANCHOR41
	.word	.LANCHOR40
	.word	.LANCHOR43
	.word	.LANCHOR42
	.size	FtlSysBlkNumInit, .-FtlSysBlkNumInit
	.global	__aeabi_idiv
	.section	.text.FtlConstantsInit,"ax",%progbits
	.align	1
	.global	FtlConstantsInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlConstantsInit, %function
FtlConstantsInit:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r0
	ldrh	r7, [r0, #8]
	sub	sp, sp, #24
	ldr	r3, .L443
	ldrh	r2, [r0, #10]
	ldrh	r6, [r0, #14]
	strh	r7, [r3]	@ movhi
	ldrh	r3, [r0, #12]
	ldr	r0, .L443+4
	ldr	r1, .L443+8
	ldr	r4, .L443+12
	strh	r6, [r0]	@ movhi
	str	r0, [sp, #20]
	ldr	r0, .L443+16
	strh	r3, [r1]	@ movhi
	movs	r1, #0
	strh	r2, [r4]	@ movhi
	str	r4, [sp, #8]
.L417:
	strb	r1, [r1, r0]
	adds	r1, r1, #1
	cmp	r1, #32
	bne	.L417
	ldrh	r0, [r10, #14]
	ldrh	r1, [r10, #20]
	cmp	r1, r0, lsr #8
	bcs	.L418
	uxtb	r8, r3
	lsl	r1, r8, #1
	uxtb	r1, r1
	str	r1, [sp, #4]
	subs	r1, r2, #1
	muls	r1, r3, r1
	str	r1, [sp, #12]
	movs	r1, #0
.L419:
	cmp	r1, r3
	bcs	.L421
	ldr	r4, [sp, #12]
	sub	fp, r1, r3
	uxtb	r0, r1
	adds	r5, r1, r4
	ldr	r4, .L443+16
	add	r4, r4, r5
	movs	r5, #0
	mov	lr, r4
	ldr	r4, .L443+16
	mov	ip, r5
	add	fp, fp, r4
	b	.L422
.L420:
	add	r4, r8, r0
	strb	r0, [fp, r5]
	str	r4, [sp, #16]
	add	ip, ip, #1
	ldrb	r4, [sp, #16]	@ zero_extendqisi2
	strb	r4, [lr, r5]
	ldr	r4, [sp, #4]
	add	r0, r0, r4
	uxtb	r0, r0
.L422:
	cmp	ip, r2
	add	r5, r5, r3
	bcc	.L420
	adds	r1, r1, #1
	b	.L419
.L421:
	ldr	r1, [sp, #8]
	lsls	r2, r2, #1
	lsrs	r6, r6, #1
	strh	r2, [r1]	@ movhi
	ldr	r2, .L443+4
	strh	r6, [r2]	@ movhi
.L418:
	ldr	r1, .L443+20
	movs	r2, #5
	cmp	r7, #1
	mov	r0, #0
	strh	r2, [r1]	@ movhi
	ldr	r2, .L443+24
	it	eq
	strheq	r7, [r1]	@ movhi
	ldr	r1, .L443+28
	strh	r0, [r2]	@ movhi
	mov	r0, #4352
	strh	r0, [r1]	@ movhi
	ldr	r0, .L443+32
	ldrb	r0, [r0]	@ zero_extendqisi2
	str	r0, [sp, #4]
	cbz	r0, .L424
	mov	r0, #384
	strh	r0, [r1]	@ movhi
.L424:
	str	r2, [sp, #16]
	ldr	r2, [sp, #8]
	ldr	r1, .L443+36
	ldrh	r6, [r10, #16]
	ldrh	r5, [r2]
	ldr	r2, [sp, #20]
	ldr	fp, .L443+116
	ldr	r8, .L443+120
	smulbb	r5, r5, r3
	ldrh	r4, [r2]
	strh	r6, [fp]	@ movhi
	uxth	r5, r5
	smulbb	r3, r3, r4
	strh	r5, [r1]	@ movhi
	smulbb	r0, r5, r6
	ldr	r1, .L443+40
	strh	r3, [r1]	@ movhi
	ldrh	r1, [r10, #18]
	ldr	r3, .L443+44
	str	r1, [sp, #12]
	strh	r1, [r3]	@ movhi
	ldr	r3, .L443+48
	strh	r0, [r3]	@ movhi
	ldrh	r3, [r10, #20]
	mov	r0, r3
	strh	r3, [r8]	@ movhi
	str	r3, [sp, #8]
	bl	Ftl_log2
	ldr	r3, [sp, #8]
	mov	r7, r0
	ldr	ip, .L443+124
	cmp	r4, #1024
	ldr	lr, .L443+128
	ldr	r2, [sp, #16]
	strh	r0, [ip]	@ movhi
	lsl	r0, r3, #9
	ldr	r1, [sp, #12]
	uxth	r0, r0
	strh	r0, [lr]	@ movhi
	lsr	r0, r0, #8
	ldr	lr, .L443+132
	mul	r1, r3, r1
	strh	r0, [lr]	@ movhi
	ldrh	lr, [r10, #26]
	mov	r10, ip
	ldr	r0, .L443+52
	strh	lr, [r0]	@ movhi
	mul	lr, r4, r5
	ldr	r0, .L443+56
	str	lr, [r0]
	itt	hi
	uxtbhi	r0, r4
	strhhi	r0, [r2]	@ movhi
	ldrh	r2, [r2]
	subs	r2, r4, r2
	muls	r2, r5, r2
	muls	r2, r3, r2
	muls	r6, r2, r6
	ldr	r2, .L443+60
	asrs	r6, r6, #11
	str	r6, [r2]
	ldr	r6, .L443+28
	ldrh	r0, [r6]
	lsls	r0, r0, #3
	bl	__aeabi_idiv
	uxth	r0, r0
	mov	r3, r6
	ldr	r6, .L443+64
	cmp	r0, #4
	itt	ls
	movls	r2, #4
	strhls	r2, [r6]	@ movhi
	ldr	r2, [sp, #4]
	it	hi
	strhhi	r0, [r6]	@ movhi
	cbz	r2, .L428
	mov	r2, #640
	strh	r2, [r3]	@ movhi
.L428:
	ldrh	r3, [r3]
	lsls	r4, r4, #6
	ldr	r2, .L443+68
	mov	r1, r5
	ldrh	r0, [r6]
	asrs	r3, r3, r7
	adds	r7, r7, #9
	asrs	r4, r4, r7
	ldr	r7, .L443+72
	adds	r3, r3, #2
	strh	r3, [r2]	@ movhi
	ldr	r3, .L443+76
	strh	r4, [r3]	@ movhi
	uxth	r4, r4
	mul	r3, r4, r5
	adds	r4, r4, #8
	str	r3, [r7]
	bl	__aeabi_uidiv
	uxtah	r0, r4, r0
	ldr	r4, .L443+80
	cmp	r5, #1
	ldr	r5, .L443+84
	it	eq
	addeq	r0, r0, #4
	str	r0, [r4]
	ldrh	r0, [r4]
	bl	FtlSysBlkNumInit
	ldr	r2, [r4]
	movs	r0, #24
	ldr	r3, .L443+88
	ldrb	r5, [r5]	@ zero_extendqisi2
	str	r2, [r3]
	ldr	r3, .L443+92
	ldr	r2, [r3]
	ldrh	r3, [fp]
	lsls	r2, r2, #2
	muls	r3, r2, r3
	ldrh	r2, [r10]
	adds	r2, r2, #9
	lsrs	r3, r3, r2
	ldr	r2, .L443+96
	adds	r3, r3, #2
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L443+100
	strh	r0, [r2]	@ movhi
	movs	r0, #0
	ldr	r2, .L443+104
	str	r0, [r2]
	ldrh	r0, [r6]
	adds	r2, r0, #3
	strh	r2, [r6]	@ movhi
	ldr	r2, [r7]
	adds	r4, r2, #3
	str	r4, [r7]
	cbz	r5, .L431
	adds	r2, r2, #5
	adds	r0, r0, #4
	strh	r0, [r6]	@ movhi
.L442:
	str	r2, [r7]
.L432:
	ldr	r1, .L443+108
	movs	r2, #0
	strh	r2, [r1]	@ movhi
	ldr	r2, .L443+112
	ldrh	r0, [r2]
	lsrs	r2, r0, #3
	add	r2, r2, r0, lsl #1
	movs	r0, #0
	adds	r2, r2, #52
	add	r3, r2, r3, lsl #2
	ldrh	r2, [r8]
	cmp	r3, r2, lsl #9
	itt	cc
	movcc	r3, #1
	strhcc	r3, [r1]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L431:
	cmp	r4, #7
	bhi	.L432
	movs	r2, #8
	b	.L442
.L444:
	.align	2
.L443:
	.word	.LANCHOR44
	.word	.LANCHOR41
	.word	.LANCHOR46
	.word	.LANCHOR45
	.word	.LANCHOR47
	.word	.LANCHOR48
	.word	.LANCHOR49
	.word	.LANCHOR50
	.word	.LANCHOR2
	.word	.LANCHOR38
	.word	.LANCHOR51
	.word	.LANCHOR53
	.word	.LANCHOR54
	.word	.LANCHOR59
	.word	.LANCHOR43
	.word	.LANCHOR60
	.word	.LANCHOR61
	.word	.LANCHOR62
	.word	.LANCHOR64
	.word	.LANCHOR63
	.word	.LANCHOR37
	.word	.LANCHOR15
	.word	.LANCHOR65
	.word	.LANCHOR42
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LANCHOR40
	.word	.LANCHOR52
	.word	.LANCHOR55
	.word	.LANCHOR56
	.word	.LANCHOR57
	.word	.LANCHOR58
	.size	FtlConstantsInit, .-FtlConstantsInit
	.section	.text.IsBlkInVendorPart,"ax",%progbits
	.align	1
	.global	IsBlkInVendorPart
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	IsBlkInVendorPart, %function
IsBlkInVendorPart:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L452
	ldrh	r3, [r3]
	cbz	r3, .L451
	ldr	r3, .L452+4
	ldr	r2, .L452+8
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L447:
	cmp	r3, r2
	bne	.L448
.L451:
	movs	r0, #0
	bx	lr
.L448:
	ldrh	r1, [r3], #2
	cmp	r0, r1
	bne	.L447
	movs	r0, #1
	bx	lr
.L453:
	.align	2
.L452:
	.word	.LANCHOR70
	.word	.LANCHOR71
	.word	.LANCHOR61
	.size	IsBlkInVendorPart, .-IsBlkInVendorPart
	.section	.text.FtlGetCap,"ax",%progbits
	.align	1
	.global	FtlGetCap
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGetCap, %function
FtlGetCap:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L455
	ldr	r0, [r3]
	bx	lr
.L456:
	.align	2
.L455:
	.word	.LANCHOR68
	.size	FtlGetCap, .-FtlGetCap
	.section	.text.FtlGetCapacity,"ax",%progbits
	.align	1
	.global	FtlGetCapacity
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGetCapacity, %function
FtlGetCapacity:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L458
	ldr	r0, [r3]
	bx	lr
.L459:
	.align	2
.L458:
	.word	.LANCHOR68
	.size	FtlGetCapacity, .-FtlGetCapacity
	.section	.text.ftl_get_density,"ax",%progbits
	.align	1
	.global	ftl_get_density
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_get_density, %function
ftl_get_density:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L461
	ldr	r0, [r3]
	bx	lr
.L462:
	.align	2
.L461:
	.word	.LANCHOR68
	.size	ftl_get_density, .-ftl_get_density
	.section	.text.FtlGetLpn,"ax",%progbits
	.align	1
	.global	FtlGetLpn
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGetLpn, %function
FtlGetLpn:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L464
	ldr	r0, [r3]
	bx	lr
.L465:
	.align	2
.L464:
	.word	.LANCHOR72
	.size	FtlGetLpn, .-FtlGetLpn
	.section	.text.FtlGetCurEraseBlock,"ax",%progbits
	.align	1
	.global	FtlGetCurEraseBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGetCurEraseBlock, %function
FtlGetCurEraseBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L467
	ldr	r3, .L467+4
	ldr	r0, [r2]
	ldrh	r3, [r3]
	muls	r0, r3, r0
	bx	lr
.L468:
	.align	2
.L467:
	.word	.LANCHOR73
	.word	.LANCHOR38
	.size	FtlGetCurEraseBlock, .-FtlGetCurEraseBlock
	.section	.text.FtlGetAllBlockNum,"ax",%progbits
	.align	1
	.global	FtlGetAllBlockNum
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGetAllBlockNum, %function
FtlGetAllBlockNum:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L470
	ldr	r3, .L470+4
	ldrh	r0, [r2]
	ldrh	r3, [r3]
	muls	r0, r3, r0
	bx	lr
.L471:
	.align	2
.L470:
	.word	.LANCHOR38
	.word	.LANCHOR41
	.size	FtlGetAllBlockNum, .-FtlGetAllBlockNum
	.section	.text.FtlBbmMapBadBlock,"ax",%progbits
	.align	1
	.global	FtlBbmMapBadBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlBbmMapBadBlock, %function
FtlBbmMapBadBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L473
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	mov	r1, r4
	ldr	r4, .L473+4
	uxth	r6, r0
	mov	r0, r5
	bl	__aeabi_uidivmod
	add	r2, r4, r6, lsl #2
	uxth	r3, r1
	ldr	r2, [r2, #28]
	lsrs	r1, r3, #5
	and	r7, r3, #31
	movs	r0, #1
	lsls	r0, r0, r7
	ldr	r7, [r2, r1, lsl #2]
	orrs	r0, r0, r7
	str	r0, [r2, r1, lsl #2]
	mov	r2, r6
	str	r0, [sp]
	mov	r1, r5
	ldr	r0, .L473+8
	bl	printf
	ldrh	r3, [r4, #6]
	movs	r0, #0
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L474:
	.align	2
.L473:
	.word	.LANCHOR51
	.word	.LANCHOR74
	.word	.LC2
	.size	FtlBbmMapBadBlock, .-FtlBbmMapBadBlock
	.section	.text.FtlBbmIsBadBlock,"ax",%progbits
	.align	1
	.global	FtlBbmIsBadBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlBbmIsBadBlock, %function
FtlBbmIsBadBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L476
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	mov	r1, r5
	bl	__aeabi_uidivmod
	mov	r0, r6
	uxth	r4, r1
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r3, .L476+4
	uxth	r0, r0
	lsrs	r2, r4, #5
	and	r4, r4, #31
	add	r0, r3, r0, lsl #2
	ldr	r3, [r0, #28]
	ldr	r0, [r3, r2, lsl #2]
	lsrs	r0, r0, r4
	and	r0, r0, #1
	pop	{r4, r5, r6, pc}
.L477:
	.align	2
.L476:
	.word	.LANCHOR51
	.word	.LANCHOR74
	.size	FtlBbmIsBadBlock, .-FtlBbmIsBadBlock
	.section	.text.FtlBbtInfoPrint,"ax",%progbits
	.align	1
	.global	FtlBbtInfoPrint
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlBbtInfoPrint, %function
FtlBbtInfoPrint:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	FtlBbtInfoPrint, .-FtlBbtInfoPrint
	.section	.text.V2P_block,"ax",%progbits
	.align	1
	.global	V2P_block
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	V2P_block, %function
V2P_block:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r5, r1
	ldr	r3, .L480
	mov	r7, r0
	ldrh	r6, [r3]
	mov	r1, r6
	bl	__aeabi_uidiv
	ldr	r3, .L480+4
	smulbb	r5, r6, r5
	mov	r1, r6
	ldrh	r4, [r3]
	smulbb	r4, r4, r0
	mov	r0, r7
	bl	__aeabi_uidivmod
	adds	r0, r5, r1
	add	r0, r0, r4
	uxth	r0, r0
	pop	{r3, r4, r5, r6, r7, pc}
.L481:
	.align	2
.L480:
	.word	.LANCHOR46
	.word	.LANCHOR51
	.size	V2P_block, .-V2P_block
	.section	.text.P2V_plane,"ax",%progbits
	.align	1
	.global	P2V_plane
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	P2V_plane, %function
P2V_plane:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L483
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	ldr	r3, .L483+4
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	smulbb	r4, r0, r5
	mov	r1, r5
	mov	r0, r6
	bl	__aeabi_uidivmod
	add	r1, r1, r4
	uxth	r0, r1
	pop	{r4, r5, r6, pc}
.L484:
	.align	2
.L483:
	.word	.LANCHOR46
	.word	.LANCHOR51
	.size	P2V_plane, .-P2V_plane
	.section	.text.P2V_block_in_plane,"ax",%progbits
	.align	1
	.global	P2V_block_in_plane
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	P2V_block_in_plane, %function
P2V_block_in_plane:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	r3, .L486
	ldrh	r1, [r3]
	bl	__aeabi_uidivmod
	ldr	r3, .L486+4
	uxth	r0, r1
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	uxth	r0, r0
	pop	{r3, pc}
.L487:
	.align	2
.L486:
	.word	.LANCHOR51
	.word	.LANCHOR46
	.size	P2V_block_in_plane, .-P2V_block_in_plane
	.section	.text.ftl_cmp_data_ver,"ax",%progbits
	.align	1
	.global	ftl_cmp_data_ver
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_cmp_data_ver, %function
ftl_cmp_data_ver:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	cmp	r0, r1
	bls	.L489
	subs	r0, r0, r1
	cmp	r0, #-2147483648
	ite	hi
	movhi	r0, #0
	movls	r0, #1
	bx	lr
.L489:
	subs	r0, r1, r0
	cmp	r0, #-2147483648
	ite	ls
	movls	r0, #0
	movhi	r0, #1
	bx	lr
	.size	ftl_cmp_data_ver, .-ftl_cmp_data_ver
	.section	.text.FtlFreeSysBlkQueueEmpty,"ax",%progbits
	.align	1
	.global	FtlFreeSysBlkQueueEmpty
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlFreeSysBlkQueueEmpty, %function
FtlFreeSysBlkQueueEmpty:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L492
	ldrh	r0, [r3, #6]
	clz	r0, r0
	lsrs	r0, r0, #5
	bx	lr
.L493:
	.align	2
.L492:
	.word	.LANCHOR75
	.size	FtlFreeSysBlkQueueEmpty, .-FtlFreeSysBlkQueueEmpty
	.section	.text.FtlFreeSysBlkQueueFull,"ax",%progbits
	.align	1
	.global	FtlFreeSysBlkQueueFull
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlFreeSysBlkQueueFull, %function
FtlFreeSysBlkQueueFull:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L495
	ldrh	r0, [r3, #6]
	sub	r3, r0, #1024
	rsbs	r0, r3, #0
	adcs	r0, r0, r3
	bx	lr
.L496:
	.align	2
.L495:
	.word	.LANCHOR75
	.size	FtlFreeSysBlkQueueFull, .-FtlFreeSysBlkQueueFull
	.section	.text.FtlFreeSysBlkQueueIn,"ax",%progbits
	.align	1
	.global	FtlFreeSysBlkQueueIn
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlFreeSysBlkQueueIn, %function
FtlFreeSysBlkQueueIn:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	subs	r3, r0, #1
	movw	r2, #65533
	uxth	r3, r3
	push	{r4, r5, r6, lr}
	mov	r5, r0
	cmp	r3, r2
	bhi	.L497
	ldr	r4, .L506
	ldrh	r3, [r4, #6]
	cmp	r3, #1024
	beq	.L497
	cbz	r1, .L499
	ldr	r3, .L506+4
	ldr	r3, [r3]
	cbnz	r3, .L499
	bl	P2V_block_in_plane
	ldr	r3, .L506+8
	mov	r6, r0
	movs	r2, #1
	mov	r1, r2
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L506+12
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	ldr	r2, .L506+16
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L499:
	ldrh	r3, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #4]
	adds	r2, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	strh	r5, [r4, r2, lsl #1]	@ movhi
	strh	r3, [r4, #4]	@ movhi
.L497:
	pop	{r4, r5, r6, pc}
.L507:
	.align	2
.L506:
	.word	.LANCHOR75
	.word	.LANCHOR76
	.word	.LANCHOR77
	.word	.LANCHOR78
	.word	.LANCHOR79
	.size	FtlFreeSysBlkQueueIn, .-FtlFreeSysBlkQueueIn
	.section	.text.FtlFreeSysBLkSort,"ax",%progbits
	.align	1
	.global	FtlFreeSysBLkSort
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlFreeSysBLkSort, %function
FtlFreeSysBLkSort:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L517
	push	{r4, r5, r6, lr}
	ldrh	r2, [r3, #6]
	cbz	r2, .L508
	ldr	r2, .L517+4
	movs	r6, #0
	ldrh	r1, [r3, #2]
	mov	r5, r6
	ldrh	r4, [r2, #28]
	ldrh	r2, [r3, #4]
	and	r4, r4, #31
.L510:
	uxth	r0, r6
	adds	r6, r6, #1
	cmp	r4, r0
	bgt	.L511
	cbz	r5, .L508
	strh	r1, [r3, #2]	@ movhi
	strh	r2, [r3, #4]	@ movhi
.L508:
	pop	{r4, r5, r6, pc}
.L511:
	adds	r0, r1, #4
	adds	r1, r1, #1
	ldrh	r5, [r3, r0, lsl #1]
	adds	r0, r2, #4
	ubfx	r1, r1, #0, #10
	strh	r5, [r3, r0, lsl #1]	@ movhi
	movs	r5, #1
	add	r2, r2, r5
	ubfx	r2, r2, #0, #10
	b	.L510
.L518:
	.align	2
.L517:
	.word	.LANCHOR75
	.word	.LANCHOR80
	.size	FtlFreeSysBLkSort, .-FtlFreeSysBLkSort
	.section	.text.FtlFreeSysBlkQueueOut,"ax",%progbits
	.align	1
	.global	FtlFreeSysBlkQueueOut
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlFreeSysBlkQueueOut, %function
FtlFreeSysBlkQueueOut:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	ldr	r4, .L529
	mov	r6, r4
.L520:
	ldrh	r1, [r4, #6]
	cmp	r1, #0
	beq	.L521
	ldrh	r3, [r4, #2]
	subs	r1, r1, #1
	strh	r1, [r4, #6]	@ movhi
	adds	r2, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	ldrh	r5, [r4, r2, lsl #1]
	strh	r3, [r4, #2]	@ movhi
	ldr	r3, .L529+4
	ldr	r10, [r3]
	cmp	r10, #0
	bne	.L522
	ldr	r8, .L529+28
	mov	r0, r5
	bl	P2V_block_in_plane
	mov	r7, r0
	lsls	r3, r5, #10
	ldr	r0, [r8]
	str	r3, [r0, #4]
	ldr	r3, .L529+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L523
	movs	r2, #1
	mov	r1, r10
	bl	FlashEraseBlocks
.L523:
	movs	r2, #1
	ldr	r0, [r8]
	mov	r1, r2
	bl	FlashEraseBlocks
	ldr	r3, .L529+12
	ldr	r2, [r3]
	ldrh	r3, [r2, r7, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	ldr	r2, .L529+16
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L522:
	subs	r3, r5, #1
	movw	r2, #65533
	uxth	r3, r3
	cmp	r3, r2
	bls	.L525
	ldrh	r2, [r6, #6]
	mov	r1, r5
	ldr	r0, .L529+20
	bl	printf
	b	.L520
.L521:
	ldr	r0, .L529+24
	bl	printf
.L524:
	b	.L524
.L525:
	mov	r0, r5
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L530:
	.align	2
.L529:
	.word	.LANCHOR75
	.word	.LANCHOR76
	.word	.LANCHOR15
	.word	.LANCHOR78
	.word	.LANCHOR79
	.word	.LC4
	.word	.LC3
	.word	.LANCHOR77
	.size	FtlFreeSysBlkQueueOut, .-FtlFreeSysBlkQueueOut
	.section	.text.test_node_in_list,"ax",%progbits
	.align	1
	.global	test_node_in_list
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	test_node_in_list, %function
test_node_in_list:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L536
	push	{r4, r5, lr}
	movw	r5, #65535
	ldr	r2, [r0]
	ldr	r4, [r3]
	subs	r3, r2, r4
	asrs	r0, r3, #1
	ldr	r3, .L536+4
	muls	r3, r0, r3
	movs	r0, #6
	uxth	r3, r3
.L533:
	cmp	r3, r1
	beq	.L534
	ldrh	r3, [r2]
	cmp	r3, r5
	beq	.L535
	mla	r2, r0, r3, r4
	b	.L533
.L534:
	movs	r0, #1
	pop	{r4, r5, pc}
.L535:
	movs	r0, #0
	pop	{r4, r5, pc}
.L537:
	.align	2
.L536:
	.word	.LANCHOR81
	.word	-1431655765
	.size	test_node_in_list, .-test_node_in_list
	.section	.text.insert_data_list,"ax",%progbits
	.align	1
	.global	insert_data_list
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	insert_data_list, %function
insert_data_list:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, .L554
	ldrh	lr, [r3]
	cmp	lr, r0
	bls	.L540
	ldr	r3, .L554+4
	movs	r5, #6
	ldr	r4, [r3]
	mul	r3, r5, r0
	str	r3, [sp, #4]
	adds	r1, r4, r3
	ldr	r2, [sp, #4]
	movw	r3, #65535
	strh	r3, [r1, #2]	@ movhi
	strh	r3, [r4, r2]	@ movhi
	ldr	r3, .L554+8
	ldr	ip, [r3]
	cmp	ip, #0
	bne	.L541
.L553:
	str	r1, [r3]
.L540:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L541:
	ldr	r3, .L554+12
	lsls	r2, r0, #1
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldrh	r6, [r3, r0, lsl #1]
	ldrh	r3, [r1, #4]
	cbz	r3, .L551
	mul	fp, r3, r6
.L542:
	sub	r3, ip, r4
	asrs	r6, r3, #1
	ldr	r3, .L554+16
	muls	r3, r6, r3
	ldr	r6, .L554+20
	ldr	r8, [r6]
	movs	r6, #0
	uxth	r3, r3
	add	r2, r8, r2
	str	r2, [sp, #12]
	mov	r2, ip
.L549:
	adds	r6, r6, #1
	uxth	r6, r6
	cmp	lr, r6
	bcc	.L540
	cmp	r3, r0
	beq	.L540
	ldr	r7, [sp, #8]
	lsl	r10, r3, #1
	ldrh	r7, [r7, r3, lsl #1]
	mov	r5, r7
	ldrh	r7, [r2, #4]
	cbz	r7, .L552
	muls	r7, r5, r7
.L544:
	cmp	fp, r7
	bne	.L545
	ldr	r5, [sp, #12]
	ldrh	r10, [r8, r10]
	ldrh	r7, [r5]
	cmp	r10, r7
	bcc	.L547
.L546:
	ldr	r5, [sp, #4]
	cmp	r2, ip
	strh	r3, [r4, r5]	@ movhi
	ldrh	r3, [r2, #2]
	strh	r3, [r1, #2]	@ movhi
	bne	.L550
	strh	r0, [r2, #2]	@ movhi
	ldr	r3, .L554+8
	b	.L553
.L551:
	mov	fp, #-1
	b	.L542
.L552:
	mov	r7, #-1
	b	.L544
.L545:
	bcc	.L546
.L547:
	ldrh	r7, [r2]
	movw	r5, #65535
	cmp	r7, r5
	bne	.L548
	strh	r3, [r1, #2]	@ movhi
	strh	r0, [r2]	@ movhi
	ldr	r3, .L554+24
	b	.L553
.L548:
	movs	r3, #6
	mla	r2, r3, r7, r4
	mov	r3, r7
	b	.L549
.L550:
	ldrh	r1, [r2, #2]
	movs	r3, #6
	muls	r3, r1, r3
	strh	r0, [r4, r3]	@ movhi
	strh	r0, [r2, #2]	@ movhi
	b	.L540
.L555:
	.align	2
.L554:
	.word	.LANCHOR40
	.word	.LANCHOR81
	.word	.LANCHOR82
	.word	.LANCHOR83
	.word	-1431655765
	.word	.LANCHOR78
	.word	.LANCHOR84
	.size	insert_data_list, .-insert_data_list
	.section	.text.INSERT_DATA_LIST,"ax",%progbits
	.align	1
	.global	INSERT_DATA_LIST
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	INSERT_DATA_LIST, %function
INSERT_DATA_LIST:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	insert_data_list
	ldr	r2, .L558
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L558+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L556
	ldr	r1, .L558+8
	movs	r2, #210
	ldr	r0, .L558+12
	bl	printf
	ldr	r1, .L558+16
	ldr	r0, .L558+20
	pop	{r3, lr}
	b	printf
.L556:
	pop	{r3, pc}
.L559:
	.align	2
.L558:
	.word	.LANCHOR85
	.word	.LANCHOR40
	.word	.LANCHOR86
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.size	INSERT_DATA_LIST, .-INSERT_DATA_LIST
	.section	.text.insert_free_list,"ax",%progbits
	.align	1
	.global	insert_free_list
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	insert_free_list, %function
insert_free_list:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movw	r1, #65535
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	cmp	r0, r1
	beq	.L561
	ldr	r3, .L567
	mov	r10, #6
	mul	r7, r10, r0
	ldr	r4, [r3]
	ldr	r3, .L567+4
	adds	r5, r4, r7
	ldr	r6, [r3]
	mov	lr, r3
	strh	r1, [r5, #2]	@ movhi
	strh	r1, [r4, r7]	@ movhi
	cbnz	r6, .L562
	str	r5, [r3]
.L561:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L562:
	ldr	r3, .L567+8
	subs	r2, r6, r4
	mov	fp, r1
	ldr	ip, [r3]
	asrs	r3, r2, #1
	ldr	r2, .L567+12
	ldrh	r8, [ip, r0, lsl #1]
	muls	r2, r3, r2
	mov	r3, r6
	uxth	r2, r2
.L565:
	ldrh	r1, [ip, r2, lsl #1]
	cmp	r1, r8
	bcs	.L563
	ldrh	r1, [r3]
	cmp	r1, fp
	bne	.L564
	strh	r2, [r5, #2]	@ movhi
	strh	r0, [r3]	@ movhi
	b	.L561
.L564:
	mla	r3, r10, r1, r4
	mov	r2, r1
	b	.L565
.L563:
	ldrh	r1, [r3, #2]
	cmp	r3, r6
	strh	r1, [r5, #2]	@ movhi
	it	ne
	ldrhne	r1, [r3, #2]
	strh	r2, [r4, r7]	@ movhi
	iteet	ne
	movne	r2, #6
	strheq	r0, [r3, #2]	@ movhi
	streq	r5, [lr]
	mulne	r2, r2, r1
	itt	ne
	strhne	r0, [r4, r2]	@ movhi
	strhne	r0, [r3, #2]	@ movhi
	b	.L561
.L568:
	.align	2
.L567:
	.word	.LANCHOR81
	.word	.LANCHOR87
	.word	.LANCHOR78
	.word	-1431655765
	.size	insert_free_list, .-insert_free_list
	.section	.text.INSERT_FREE_LIST,"ax",%progbits
	.align	1
	.global	INSERT_FREE_LIST
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	INSERT_FREE_LIST, %function
INSERT_FREE_LIST:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	insert_free_list
	ldr	r2, .L571
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L571+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L569
	ldr	r1, .L571+8
	movs	r2, #203
	ldr	r0, .L571+12
	bl	printf
	ldr	r1, .L571+16
	ldr	r0, .L571+20
	pop	{r3, lr}
	b	printf
.L569:
	pop	{r3, pc}
.L572:
	.align	2
.L571:
	.word	.LANCHOR88
	.word	.LANCHOR40
	.word	.LANCHOR89
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.size	INSERT_FREE_LIST, .-INSERT_FREE_LIST
	.section	.text.List_remove_node,"ax",%progbits
	.align	1
	.global	List_remove_node
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	List_remove_node, %function
List_remove_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	movs	r6, #6
	ldr	r5, .L579
	muls	r6, r1, r6
	movw	r3, #65535
	mov	r8, r0
	ldr	r7, [r5]
	adds	r4, r7, r6
	ldrh	r2, [r4, #2]
	cmp	r2, r3
	bne	.L574
	ldr	r3, [r0]
	cmp	r4, r3
	beq	.L574
	ldr	r1, .L579+4
	mov	r2, #386
	ldr	r0, .L579+8
	bl	printf
	ldr	r1, .L579+12
	ldr	r0, .L579+16
	bl	printf
.L574:
	ldr	r3, [r8]
	movw	r1, #65535
	cmp	r4, r3
	ldrh	r3, [r7, r6]
	bne	.L575
	cmp	r3, r1
	ittee	ne
	ldrne	r0, [r5]
	movne	r2, #6
	moveq	r3, #0
	streq	r3, [r8]
	ittt	ne
	mlane	r3, r2, r3, r0
	strne	r3, [r8]
	strhne	r1, [r3, #2]	@ movhi
.L577:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r7, r6]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	pop	{r4, r5, r6, r7, r8, pc}
.L575:
	cmp	r3, r1
	ldrh	r1, [r4, #2]
	bne	.L578
	cmp	r1, r3
	beq	.L577
	movs	r2, #6
	ldr	r0, [r5]
	muls	r1, r2, r1
	strh	r3, [r0, r1]	@ movhi
	b	.L577
.L578:
	ldr	r0, [r5]
	movs	r2, #6
	mla	r5, r2, r3, r0
	strh	r1, [r5, #2]	@ movhi
	ldrh	r1, [r4, #2]
	muls	r2, r1, r2
	strh	r3, [r0, r2]	@ movhi
	b	.L577
.L580:
	.align	2
.L579:
	.word	.LANCHOR81
	.word	.LANCHOR90
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.size	List_remove_node, .-List_remove_node
	.section	.text.List_pop_index_node,"ax",%progbits
	.align	1
	.global	List_pop_index_node
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	List_pop_index_node, %function
List_pop_index_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, [r0]
	push	{r4, r5, r6, lr}
	cbz	r3, .L587
	ldr	r2, .L588
	movw	r5, #65535
	movs	r6, #6
	ldr	r2, [r2]
.L583:
	cbnz	r1, .L584
.L586:
	ldr	r4, .L588+4
	subs	r3, r3, r2
	asrs	r3, r3, #1
	muls	r4, r3, r4
	uxth	r1, r4
	bl	List_remove_node
	uxth	r0, r4
	pop	{r4, r5, r6, pc}
.L584:
	ldrh	r4, [r3]
	cmp	r4, r5
	beq	.L586
	subs	r1, r1, #1
	mla	r3, r6, r4, r2
	uxth	r1, r1
	b	.L583
.L587:
	movw	r0, #65535
	pop	{r4, r5, r6, pc}
.L589:
	.align	2
.L588:
	.word	.LANCHOR81
	.word	-1431655765
	.size	List_pop_index_node, .-List_pop_index_node
	.section	.text.List_get_gc_head_node,"ax",%progbits
	.align	1
	.global	List_get_gc_head_node
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	List_get_gc_head_node, %function
List_get_gc_head_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L596
	push	{r4, lr}
	ldr	r3, [r3]
	cbz	r3, .L595
	ldr	r2, .L596+4
	movs	r4, #6
	ldr	r1, [r2]
	movw	r2, #65535
.L592:
	cbz	r0, .L593
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L594
.L595:
	movw	r0, #65535
	pop	{r4, pc}
.L594:
	subs	r0, r0, #1
	mla	r3, r4, r3, r1
	uxth	r0, r0
	b	.L592
.L593:
	ldr	r0, .L596+8
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r0, r3
	uxth	r0, r3
	pop	{r4, pc}
.L597:
	.align	2
.L596:
	.word	.LANCHOR82
	.word	.LANCHOR81
	.word	-1431655765
	.size	List_get_gc_head_node, .-List_get_gc_head_node
	.section	.text.List_update_data_list,"ax",%progbits
	.align	1
	.global	List_update_data_list
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	List_update_data_list, %function
List_update_data_list:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L609
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L600
	ldr	r3, .L609+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L600
	ldr	r3, .L609+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L600
	ldr	r7, .L609+12
	movs	r6, #6
	ldr	r3, .L609+16
	muls	r6, r0, r6
	ldr	fp, [r7]
	ldr	r3, [r3]
	add	r10, fp, r6
	cmp	r10, r3
	beq	.L600
	ldr	r3, .L609+20
	ldrh	r5, [r10, #4]
	ldr	r2, [r3]
	mov	r8, r3
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r5, #0
	beq	.L607
	muls	r5, r2, r5
.L602:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L603
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	bne	.L603
	ldr	r1, .L609+24
	mov	r2, #504
	ldr	r0, .L609+28
	bl	printf
	ldr	r1, .L609+32
	ldr	r0, .L609+36
	bl	printf
.L603:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L604
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	beq	.L600
.L604:
	movs	r2, #6
	muls	r2, r3, r2
	ldr	r3, .L609+40
	asrs	r1, r2, #1
	muls	r3, r1, r3
	ldr	r1, [r8]
	ldrh	r0, [r1, r3, lsl #1]
	ldr	r1, [r7]
	add	r2, r2, r1
	ldrh	r3, [r2, #4]
	cbz	r3, .L608
	muls	r3, r0, r3
.L605:
	cmp	r5, r3
	bcs	.L600
	ldr	r5, .L609+44
	mov	r1, r4
	ldr	r0, .L609+16
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L606
	ldr	r1, .L609+24
	movw	r2, #515
	ldr	r0, .L609+28
	bl	printf
	ldr	r1, .L609+32
	ldr	r0, .L609+36
	bl	printf
.L606:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	INSERT_DATA_LIST
.L600:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L607:
	mov	r5, #-1
	b	.L602
.L608:
	mov	r3, #-1
	b	.L605
.L610:
	.align	2
.L609:
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR81
	.word	.LANCHOR82
	.word	.LANCHOR83
	.word	.LANCHOR94
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	-1431655765
	.word	.LANCHOR85
	.size	List_update_data_list, .-List_update_data_list
	.section	.text.ftl_map_blk_alloc_new_blk,"ax",%progbits
	.align	1
	.global	ftl_map_blk_alloc_new_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_map_blk_alloc_new_blk, %function
ftl_map_blk_alloc_new_blk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r1, [r0, #10]
	ldr	r2, [r0, #12]
	push	{r3, r4, r5, r6, r7, lr}
	mov	r4, r0
	movs	r3, #0
.L612:
	uxth	r5, r3
	cmp	r5, r1
	bcs	.L615
	mov	r7, r2
	adds	r3, r3, #1
	ldrh	r6, [r7]
	adds	r2, r2, #2
	cmp	r6, #0
	bne	.L612
	bl	FtlFreeSysBlkQueueOut
	subs	r3, r0, #1
	movw	r2, #65533
	uxth	r3, r3
	mov	r1, r0
	strh	r0, [r7]	@ movhi
	cmp	r3, r2
	bls	.L613
	ldr	r3, .L619
	ldr	r0, .L619+4
	ldrh	r2, [r3, #6]
	bl	printf
.L614:
	b	.L614
.L613:
	ldr	r3, [r4, #28]
	strh	r6, [r4, #2]	@ movhi
	strh	r5, [r4]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #28]
	ldrh	r3, [r4, #8]
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
.L615:
	ldrh	r3, [r4, #10]
	cmp	r3, r5
	bhi	.L617
	ldr	r1, .L619+8
	movw	r2, #629
	ldr	r0, .L619+12
	bl	printf
	ldr	r1, .L619+16
	ldr	r0, .L619+20
	bl	printf
.L617:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L620:
	.align	2
.L619:
	.word	.LANCHOR75
	.word	.LC8
	.word	.LANCHOR95
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.size	ftl_map_blk_alloc_new_blk, .-ftl_map_blk_alloc_new_blk
	.section	.text.select_l2p_ram_region,"ax",%progbits
	.align	1
	.global	select_l2p_ram_region
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	select_l2p_ram_region, %function
select_l2p_ram_region:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r1, #0
	ldr	r3, .L631
	movs	r0, #12
	movw	r5, #65535
	ldrh	r2, [r3]
	ldr	r3, .L631+4
	ldr	r3, [r3]
.L622:
	uxth	r4, r1
	cmp	r4, r2
	bcc	.L624
	mov	r4, r2
	movs	r1, #0
	mov	r6, #-2147483648
	movs	r7, #12
.L625:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L627
	cmp	r4, r2
	bcc	.L623
	ldr	r1, .L631+8
	mov	r4, r2
	mov	r0, #-1
	ldrh	r7, [r1]
	movs	r1, #0
.L628:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L630
	cmp	r4, r2
	bcc	.L623
	movw	r2, #859
	ldr	r1, .L631+12
	ldr	r0, .L631+16
	bl	printf
	ldr	r1, .L631+20
	ldr	r0, .L631+24
	bl	printf
	b	.L623
.L624:
	adds	r1, r1, #1
	mla	r6, r0, r1, r3
	ldrh	r6, [r6, #-12]
	cmp	r6, r5
	bne	.L622
.L623:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L627:
	mla	r0, r7, r1, r3
	ldr	r0, [r0, #4]
	cmp	r0, #0
	blt	.L626
	cmp	r6, r0
	itt	hi
	movhi	r6, r0
	movhi	r4, r5
.L626:
	adds	r1, r1, #1
	b	.L625
.L630:
	ldr	r6, [r3, #4]
	cmp	r0, r6
	bls	.L629
	ldrh	ip, [r3]
	cmp	ip, r7
	itt	ne
	movne	r0, r6
	movne	r4, r5
.L629:
	adds	r1, r1, #1
	adds	r3, r3, #12
	b	.L628
.L632:
	.align	2
.L631:
	.word	.LANCHOR67
	.word	.LANCHOR96
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.size	select_l2p_ram_region, .-select_l2p_ram_region
	.section	.text.FtlUpdateVaildLpn,"ax",%progbits
	.align	1
	.global	FtlUpdateVaildLpn
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlUpdateVaildLpn, %function
FtlUpdateVaildLpn:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L643
	push	{r4, r5, r6, lr}
	mov	r1, r2
	ldrh	r3, [r2]
	cmp	r3, #4
	bhi	.L634
	cbnz	r0, .L634
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	pop	{r4, r5, r6, pc}
.L634:
	movs	r3, #0
	ldr	r0, .L643+4
	strh	r3, [r1]	@ movhi
	movw	r6, #65535
	ldr	r1, .L643+8
	ldrh	r4, [r0]
	mov	r0, r3
	ldr	r2, .L643+12
	ldr	r1, [r1]
	str	r3, [r2]
	add	r4, r1, r4, lsl #1
.L635:
	cmp	r1, r4
	bne	.L637
	cbz	r3, .L633
	str	r0, [r2]
.L633:
	pop	{r4, r5, r6, pc}
.L637:
	ldrh	r5, [r1], #2
	cmp	r5, r6
	itt	ne
	addne	r0, r0, r5
	movne	r3, #1
	b	.L635
.L644:
	.align	2
.L643:
	.word	.LANCHOR99
	.word	.LANCHOR40
	.word	.LANCHOR83
	.word	.LANCHOR100
	.size	FtlUpdateVaildLpn, .-FtlUpdateVaildLpn
	.section	.text.ftl_set_blk_mode,"ax",%progbits
	.align	1
	.global	ftl_set_blk_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_set_blk_mode, %function
ftl_set_blk_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r0
	cbz	r1, .L646
	b	ftl_set_blk_mode.part.10
.L646:
	ldr	r2, .L647
	lsrs	r0, r0, #5
	and	r3, r3, #31
	ldr	r1, [r2]
	movs	r2, #1
	lsl	r3, r2, r3
	ldr	r2, [r1, r0, lsl #2]
	bic	r2, r2, r3
	str	r2, [r1, r0, lsl #2]
	bx	lr
.L648:
	.align	2
.L647:
	.word	.LANCHOR1
	.size	ftl_set_blk_mode, .-ftl_set_blk_mode
	.section	.text.ftl_get_blk_mode,"ax",%progbits
	.align	1
	.global	ftl_get_blk_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_get_blk_mode, %function
ftl_get_blk_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L650
	lsrs	r2, r0, #5
	and	r0, r0, #31
	ldr	r3, [r3]
	ldr	r3, [r3, r2, lsl #2]
	lsr	r0, r3, r0
	and	r0, r0, #1
	bx	lr
.L651:
	.align	2
.L650:
	.word	.LANCHOR1
	.size	ftl_get_blk_mode, .-ftl_get_blk_mode
	.section	.text.ftl_sb_update_avl_pages,"ax",%progbits
	.align	1
	.global	ftl_sb_update_avl_pages
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_sb_update_avl_pages, %function
ftl_sb_update_avl_pages:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #0
	push	{r4, r5, r6, lr}
	strh	r3, [r0, #4]	@ movhi
	movw	r6, #65535
	ldr	r3, .L659
	ldrh	r4, [r3]
	add	r3, r0, r2, lsl #1
	adds	r3, r3, #14
.L653:
	cmp	r2, r4
	bcc	.L655
	ldr	r3, .L659+4
	add	r5, r0, #16
	movw	r6, #65535
	ldrh	r3, [r3]
	subs	r3, r3, #1
	subs	r1, r3, r1
	movs	r3, #0
	uxth	r1, r1
.L656:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L658
	pop	{r4, r5, r6, pc}
.L655:
	ldrh	r5, [r3, #2]!
	adds	r2, r2, #1
	uxth	r2, r2
	cmp	r5, r6
	ittt	ne
	ldrhne	r5, [r0, #4]
	addne	r5, r5, #1
	strhne	r5, [r0, #4]	@ movhi
	b	.L653
.L658:
	ldrh	r2, [r5], #2
	adds	r3, r3, #1
	cmp	r2, r6
	ittt	ne
	ldrhne	r2, [r0, #4]
	addne	r2, r2, r1
	strhne	r2, [r0, #4]	@ movhi
	b	.L656
.L660:
	.align	2
.L659:
	.word	.LANCHOR38
	.word	.LANCHOR52
	.size	ftl_sb_update_avl_pages, .-ftl_sb_update_avl_pages
	.section	.text.make_superblock,"ax",%progbits
	.align	1
	.global	make_superblock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	make_superblock, %function
make_superblock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L674
	ldrh	r2, [r0]
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L662
	ldr	r1, .L674+4
	movw	r2, #2577
	ldr	r0, .L674+8
	bl	printf
	ldr	r1, .L674+12
	ldr	r0, .L674+16
	bl	printf
.L662:
	ldr	r3, .L674+20
	add	r6, r4, #16
	ldr	r10, .L674+40
	movw	r7, #65535
	movs	r5, #0
	ldrh	r8, [r3]
	strh	r5, [r4, #4]	@ movhi
	strb	r5, [r4, #7]
.L663:
	uxth	r3, r5
	cmp	r8, r3
	bhi	.L665
	ldr	r2, .L674+24
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #9]
	ldr	r3, .L674+28
	ldr	r3, [r3]
	cbz	r3, .L666
	ldr	r3, .L674+32
	ldrh	r2, [r4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r3, #79
	itt	ls
	movls	r3, #1
	strbls	r3, [r4, #9]
.L666:
	ldr	r3, .L674+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L667
	movs	r3, #1
	strb	r3, [r4, #9]
.L667:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L665:
	ldrh	r1, [r4]
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	strh	r7, [r6]	@ movhi
	mov	fp, r0
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L664
	strh	fp, [r6]	@ movhi
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r4, #7]
.L664:
	adds	r5, r5, #1
	adds	r6, r6, #2
	b	.L663
.L675:
	.align	2
.L674:
	.word	.LANCHOR40
	.word	.LANCHOR101
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR38
	.word	.LANCHOR52
	.word	.LANCHOR28
	.word	.LANCHOR78
	.word	.LANCHOR2
	.word	.LANCHOR47
	.size	make_superblock, .-make_superblock
	.section	.text.update_multiplier_value,"ax",%progbits
	.align	1
	.global	update_multiplier_value
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	update_multiplier_value, %function
update_multiplier_value:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	movs	r5, #0
	ldr	r3, .L682
	mov	r6, r0
	mov	r4, r5
	ldr	r10, .L682+12
	ldrh	r7, [r3]
	ldr	r3, .L682+4
	ldrh	r8, [r3]
.L677:
	uxth	r3, r5
	cmp	r7, r3
	bhi	.L679
	cbz	r4, .L681
	mov	r1, r4
	mov	r0, #32768
	bl	__aeabi_idiv
.L680:
	ldr	r3, .L682+8
	movs	r2, #6
	ldr	r3, [r3]
	mla	r6, r2, r6, r3
	strh	r0, [r6, #4]	@ movhi
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L679:
	mov	r1, r6
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L678
	add	r4, r4, r8
	uxth	r4, r4
.L678:
	adds	r5, r5, #1
	b	.L677
.L681:
	mov	r0, r4
	b	.L680
.L683:
	.align	2
.L682:
	.word	.LANCHOR38
	.word	.LANCHOR52
	.word	.LANCHOR81
	.word	.LANCHOR47
	.size	update_multiplier_value, .-update_multiplier_value
	.section	.text.GetFreeBlockMinEraseCount,"ax",%progbits
	.align	1
	.global	GetFreeBlockMinEraseCount
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	GetFreeBlockMinEraseCount, %function
GetFreeBlockMinEraseCount:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L687
	ldr	r0, [r3]
	cbz	r0, .L685
	ldr	r3, .L687+4
	ldr	r3, [r3]
	subs	r0, r0, r3
	ldr	r3, .L687+8
	asrs	r0, r0, #1
	muls	r0, r3, r0
	ldr	r3, .L687+12
	ldr	r3, [r3]
	uxth	r0, r0
	ldrh	r0, [r3, r0, lsl #1]
.L685:
	bx	lr
.L688:
	.align	2
.L687:
	.word	.LANCHOR87
	.word	.LANCHOR81
	.word	-1431655765
	.word	.LANCHOR78
	.size	GetFreeBlockMinEraseCount, .-GetFreeBlockMinEraseCount
	.section	.text.GetFreeBlockMaxEraseCount,"ax",%progbits
	.align	1
	.global	GetFreeBlockMaxEraseCount
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	GetFreeBlockMaxEraseCount, %function
GetFreeBlockMaxEraseCount:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L697
	push	{r4, r5, r6, lr}
	ldr	r3, [r3]
	cbz	r3, .L695
	ldr	r2, .L697+4
	movs	r5, #6
	movw	r6, #65535
	ldrh	r2, [r2]
	rsb	r2, r2, r2, lsl #3
	asrs	r2, r2, #3
	cmp	r0, r2
	it	gt
	uxthgt	r0, r2
	ldr	r2, .L697+8
	ldr	r1, [r2]
	ldr	r2, .L697+12
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r2, r3
	movs	r2, #0
	uxth	r3, r3
.L692:
	uxth	r4, r2
	cmp	r0, r4
	bls	.L694
	mul	r4, r5, r3
	adds	r2, r2, #1
	ldrh	r4, [r1, r4]
	cmp	r4, r6
	bne	.L696
.L694:
	ldr	r2, .L697+16
	ldr	r2, [r2]
	ldrh	r0, [r2, r3, lsl #1]
	pop	{r4, r5, r6, pc}
.L696:
	mov	r3, r4
	b	.L692
.L695:
	mov	r0, r3
	pop	{r4, r5, r6, pc}
.L698:
	.align	2
.L697:
	.word	.LANCHOR87
	.word	.LANCHOR88
	.word	.LANCHOR81
	.word	-1431655765
	.word	.LANCHOR78
	.size	GetFreeBlockMaxEraseCount, .-GetFreeBlockMaxEraseCount
	.section	.text.free_data_superblock,"ax",%progbits
	.align	1
	.global	free_data_superblock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	free_data_superblock, %function
free_data_superblock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movw	r2, #65535
	push	{r3, lr}
	cmp	r0, r2
	beq	.L700
	ldr	r2, .L701
	movs	r1, #0
	ldr	r2, [r2]
	strh	r1, [r2, r0, lsl #1]	@ movhi
	bl	INSERT_FREE_LIST
.L700:
	movs	r0, #0
	pop	{r3, pc}
.L702:
	.align	2
.L701:
	.word	.LANCHOR83
	.size	free_data_superblock, .-free_data_superblock
	.section	.text.FtlGcBufInit,"ax",%progbits
	.align	1
	.global	FtlGcBufInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcBufInit, %function
FtlGcBufInit:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r3, #0
	ldr	r1, .L708
	mov	fp, #1
	ldr	r2, .L708+4
	ldr	r5, [r1]
	ldr	r1, .L708+8
	str	r3, [r2]
	ldr	r2, .L708+12
	mov	r0, r5
	ldr	r1, [r1]
	ldrh	r2, [r2]
	str	r1, [sp, #4]
	ldr	r1, .L708+16
	ldrh	r1, [r1]
	str	r1, [sp]
	ldr	r1, .L708+20
	ldr	r10, [r1]
	ldr	r1, .L708+24
	ldrh	r7, [r1]
	ldr	r1, .L708+28
	ldr	r4, [r1]
	movs	r1, #12
	mla	r1, r2, r1, r1
	adds	r4, r4, #8
	add	r8, r5, r1
	mov	r1, r3
.L704:
	adds	r0, r0, #12
	ldr	r6, [sp]
	cmp	r0, r8
	add	ip, r3, r7
	add	r4, r4, #36
	add	lr, r1, r6
	bne	.L705
	ldr	r3, .L708+32
	mov	lr, #12
	mov	r8, #0
	ldr	r0, [r3]
	ldr	r3, .L708+8
	ldr	r4, [r3]
	ldr	r3, .L708+20
	ldr	ip, [r3]
.L706:
	cmp	r2, r0
	bcc	.L707
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L705:
	bic	r1, r1, #3
	bic	r3, r3, #3
	mov	r6, r1
	ldr	r1, [sp, #4]
	add	r3, r3, r10
	str	fp, [r0, #-4]
	str	r3, [r0, #-8]
	add	r6, r6, r1
	mov	r1, lr
	str	r6, [r0, #-12]
	str	r3, [r4, #-32]
	mov	r3, ip
	str	r6, [r4, #-36]
	b	.L704
.L707:
	ldr	r3, [sp]
	mul	r10, lr, r2
	muls	r3, r2, r3
	add	r1, r5, r10
	str	r8, [r1, #8]
	bic	r3, r3, #3
	add	r3, r3, r4
	str	r3, [r5, r10]
	mul	r3, r2, r7
	adds	r2, r2, #1
	uxth	r2, r2
	bic	r3, r3, #3
	add	r3, r3, ip
	str	r3, [r1, #4]
	b	.L706
.L709:
	.align	2
.L708:
	.word	.LANCHOR103
	.word	.LANCHOR102
	.word	.LANCHOR104
	.word	.LANCHOR38
	.word	.LANCHOR57
	.word	.LANCHOR105
	.word	.LANCHOR58
	.word	.LANCHOR106
	.word	.LANCHOR107
	.size	FtlGcBufInit, .-FtlGcBufInit
	.section	.text.FtlGcBufFree,"ax",%progbits
	.align	1
	.global	FtlGcBufFree
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcBufFree, %function
FtlGcBufFree:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L717
	mov	ip, #12
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	mov	fp, #36
	mov	lr, r4
	ldr	r7, [r3]
	ldr	r3, .L717+4
	ldr	r5, [r3]
.L711:
	uxth	r3, r4
	cmp	r1, r3
	bls	.L710
	mla	r8, fp, r3, r0
	movs	r2, #0
.L712:
	uxth	r3, r2
	cmp	r7, r3
	bls	.L713
	mul	r3, ip, r3
	ldr	r6, [r8, #8]
	adds	r2, r2, #1
	add	r10, r5, r3
	ldr	r3, [r5, r3]
	cmp	r3, r6
	bne	.L712
	str	lr, [r10, #8]
.L713:
	adds	r4, r4, #1
	b	.L711
.L710:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L718:
	.align	2
.L717:
	.word	.LANCHOR107
	.word	.LANCHOR103
	.size	FtlGcBufFree, .-FtlGcBufFree
	.section	.text.FtlGcBufAlloc,"ax",%progbits
	.align	1
	.global	FtlGcBufAlloc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcBufAlloc, %function
FtlGcBufAlloc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L726
	movs	r2, #0
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	ip, #12
	movs	r7, #1
	mov	lr, #36
	ldr	r4, [r3]
	ldr	r3, .L726+4
	ldr	r5, [r3]
.L720:
	uxth	r8, r2
	cmp	r1, r8
	bhi	.L724
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L724:
	mov	r10, #0
.L721:
	uxth	r3, r10
	cmp	r4, r3
	bls	.L722
	mla	r3, ip, r3, r5
	add	r10, r10, #1
	ldr	r6, [r3, #8]
	cmp	r6, #0
	bne	.L721
	mla	r8, lr, r8, r0
	str	r7, [r3, #8]
	ldr	r6, [r3]
	ldr	r3, [r3, #4]
	str	r6, [r8, #8]
	str	r3, [r8, #12]
.L722:
	adds	r2, r2, #1
	b	.L720
.L727:
	.align	2
.L726:
	.word	.LANCHOR107
	.word	.LANCHOR103
	.size	FtlGcBufAlloc, .-FtlGcBufAlloc
	.section	.text.IsBlkInGcList,"ax",%progbits
	.align	1
	.global	IsBlkInGcList
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	IsBlkInGcList, %function
IsBlkInGcList:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L733
	ldr	r2, .L733+4
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L729:
	cmp	r3, r2
	bne	.L731
	movs	r0, #0
	bx	lr
.L731:
	ldrh	r1, [r3], #2
	cmp	r1, r0
	bne	.L729
	movs	r0, #1
	bx	lr
.L734:
	.align	2
.L733:
	.word	.LANCHOR108
	.word	.LANCHOR109
	.size	IsBlkInGcList, .-IsBlkInGcList
	.section	.text.FtlGcUpdatePage,"ax",%progbits
	.align	1
	.global	FtlGcUpdatePage
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcUpdatePage, %function
FtlGcUpdatePage:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldr	r4, .L739
	ubfx	r0, r0, #10, #16
	mov	r6, r1
	mov	r7, r2
	bl	P2V_block_in_plane
	ldr	r3, .L739+4
	ldrh	r1, [r4]
	ldr	r2, [r3]
	movs	r3, #0
.L736:
	uxth	ip, r3
	cmp	ip, r1
	bcc	.L738
	bne	.L737
	strh	r0, [r2, ip, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L737
.L738:
	adds	r3, r3, #1
	add	ip, r2, r3, lsl #1
	ldrh	ip, [ip, #-2]
	cmp	ip, r0
	bne	.L736
.L737:
	ldr	r2, .L739+8
	movs	r0, #12
	ldr	r1, .L739+12
	ldrh	r3, [r2]
	ldr	r1, [r1]
	muls	r0, r3, r0
	adds	r3, r3, #1
	adds	r4, r1, r0
	str	r6, [r4, #4]
	str	r7, [r4, #8]
	str	r5, [r1, r0]
	strh	r3, [r2]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L740:
	.align	2
.L739:
	.word	.LANCHOR109
	.word	.LANCHOR108
	.word	.LANCHOR110
	.word	.LANCHOR111
	.size	FtlGcUpdatePage, .-FtlGcUpdatePage
	.section	.text.FtlGcRefreshOpenBlock,"ax",%progbits
	.align	1
	.global	FtlGcRefreshOpenBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcRefreshOpenBlock, %function
FtlGcRefreshOpenBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	ip, .L746+12
	push	{r4, r5, r6, r7, lr}
	ldrh	lr, [ip]
	cmp	lr, r0
	beq	.L742
	ldr	r6, .L746
	ldrh	r7, [r6]
	cmp	r0, r7
	beq	.L742
	ldr	r4, .L746+4
	ldrh	r5, [r4]
	cmp	r0, r5
	beq	.L742
	ldr	r2, .L746+8
	ldrh	r1, [r2]
	cmp	r0, r1
	beq	.L742
	movw	r3, #65535
	cmp	lr, r3
	bne	.L743
	strh	r0, [ip]	@ movhi
.L742:
	movs	r0, #0
	pop	{r4, r5, r6, r7, pc}
.L743:
	cmp	r7, r3
	bne	.L744
	strh	r0, [r6]	@ movhi
	b	.L742
.L744:
	cmp	r5, r3
	bne	.L745
	strh	r0, [r4]	@ movhi
	b	.L742
.L745:
	cmp	r1, r3
	it	eq
	strheq	r0, [r2]	@ movhi
	b	.L742
.L747:
	.align	2
.L746:
	.word	.LANCHOR113
	.word	.LANCHOR114
	.word	.LANCHOR115
	.word	.LANCHOR112
	.size	FtlGcRefreshOpenBlock, .-FtlGcRefreshOpenBlock
	.section	.text.FtlGcRefreshBlock,"ax",%progbits
	.align	1
	.global	FtlGcRefreshBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcRefreshBlock, %function
FtlGcRefreshBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	ip, .L758+12
	push	{r4, r5, r6, r7, lr}
	ldrh	lr, [ip]
	cmp	lr, r0
	beq	.L756
	ldr	r6, .L758
	ldrh	r7, [r6]
	cmp	r0, r7
	beq	.L756
	ldr	r4, .L758+4
	ldrh	r5, [r4]
	cmp	r0, r5
	beq	.L756
	ldr	r2, .L758+8
	ldrh	r1, [r2]
	cmp	r0, r1
	beq	.L756
	movw	r3, #65535
	cmp	lr, r3
	bne	.L750
	strh	r0, [ip]	@ movhi
.L756:
	movs	r0, #0
	pop	{r4, r5, r6, r7, pc}
.L750:
	cmp	r7, r3
	bne	.L751
	strh	r0, [r6]	@ movhi
	b	.L756
.L751:
	cmp	r5, r3
	bne	.L752
	strh	r0, [r4]	@ movhi
	b	.L756
.L752:
	cmp	r1, r3
	bne	.L757
	strh	r0, [r2]	@ movhi
	b	.L756
.L757:
	mov	r0, #-1
	pop	{r4, r5, r6, r7, pc}
.L759:
	.align	2
.L758:
	.word	.LANCHOR113
	.word	.LANCHOR114
	.word	.LANCHOR115
	.word	.LANCHOR112
	.size	FtlGcRefreshBlock, .-FtlGcRefreshBlock
	.section	.text.FtlGcMarkBadPhyBlk,"ax",%progbits
	.align	1
	.global	FtlGcMarkBadPhyBlk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcMarkBadPhyBlk, %function
FtlGcMarkBadPhyBlk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r4, r0
	bl	P2V_block_in_plane
	mov	r5, r0
	bl	FtlGcRefreshBlock
	ldr	r3, .L768
	ldr	r3, [r3]
	cbz	r3, .L761
	ldr	r3, .L768+4
	ldr	r2, [r3]
	ldrh	r3, [r2, r5, lsl #1]
	cmp	r3, #39
	itt	hi
	subhi	r3, r3, #40
	strhhi	r3, [r2, r5, lsl #1]	@ movhi
.L761:
	ldr	r2, .L768+8
	movs	r1, #0
	ldr	r5, .L768+12
	ldrh	r3, [r2]
.L762:
	uxth	r0, r1
	cmp	r3, r0
	bhi	.L764
	cmp	r3, #15
	itttt	ls
	addls	r1, r3, #1
	strhls	r1, [r2]	@ movhi
	ldrls	r2, .L768+12
	strhls	r4, [r2, r3, lsl #1]	@ movhi
	b	.L763
.L764:
	adds	r1, r1, #1
	add	r0, r5, r1, lsl #1
	ldrh	r0, [r0, #-2]
	cmp	r0, r4
	bne	.L762
.L763:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L769:
	.align	2
.L768:
	.word	.LANCHOR28
	.word	.LANCHOR78
	.word	.LANCHOR116
	.word	.LANCHOR117
	.size	FtlGcMarkBadPhyBlk, .-FtlGcMarkBadPhyBlk
	.section	.text.FtlGcReFreshBadBlk,"ax",%progbits
	.align	1
	.global	FtlGcReFreshBadBlk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcReFreshBadBlk, %function
FtlGcReFreshBadBlk:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L776
	push	{r4, lr}
	ldrh	r3, [r3]
	cbz	r3, .L771
	ldr	r2, .L776+4
	ldrh	r1, [r2]
	movw	r2, #65535
	cmp	r1, r2
	bne	.L771
	ldr	r4, .L776+8
	ldrh	r2, [r4]
	cmp	r2, r3
	itt	cs
	movcs	r3, #0
	strhcs	r3, [r4]	@ movhi
	ldr	r3, .L776+12
	ldrh	r2, [r4]
	ldrh	r0, [r3, r2, lsl #1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
.L771:
	movs	r0, #0
	pop	{r4, pc}
.L777:
	.align	2
.L776:
	.word	.LANCHOR116
	.word	.LANCHOR112
	.word	.LANCHOR118
	.word	.LANCHOR117
	.size	FtlGcReFreshBadBlk, .-FtlGcReFreshBadBlk
	.section	.text.flash_boot_enter_slc_mode,"ax",%progbits
	.align	1
	.global	flash_boot_enter_slc_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_boot_enter_slc_mode, %function
flash_boot_enter_slc_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L780
	ldr	r2, [r3]
	ldr	r3, .L780+4
	cmp	r2, r3
	bne	.L778
	b	flash_enter_slc_mode
.L778:
	bx	lr
.L781:
	.align	2
.L780:
	.word	.LANCHOR119
	.word	1446522928
	.size	flash_boot_enter_slc_mode, .-flash_boot_enter_slc_mode
	.section	.text.flash_boot_exit_slc_mode,"ax",%progbits
	.align	1
	.global	flash_boot_exit_slc_mode
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flash_boot_exit_slc_mode, %function
flash_boot_exit_slc_mode:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L784
	ldr	r2, [r3]
	ldr	r3, .L784+4
	cmp	r2, r3
	bne	.L782
	b	flash_exit_slc_mode
.L782:
	bx	lr
.L785:
	.align	2
.L784:
	.word	.LANCHOR119
	.word	1446522928
	.size	flash_boot_exit_slc_mode, .-flash_boot_exit_slc_mode
	.section	.text.FW_FlashBlockErase.constprop.41,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FW_FlashBlockErase.constprop.41, %function
FW_FlashBlockErase.constprop.41:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r4, r0
	ldr	r3, .L787
	movs	r0, #0
	ldr	r3, [r3]
	ldrb	r5, [r3, #9]	@ zero_extendqisi2
	bl	flash_boot_enter_slc_mode
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_uidiv
	movs	r2, #0
	mov	r1, r0
	mov	r0, r2
	bl	FlashEraseBlock
	mov	r4, r0
	movs	r0, #0
	bl	flash_boot_exit_slc_mode
	uxtb	r0, r4
	pop	{r3, r4, r5, pc}
.L788:
	.align	2
.L787:
	.word	.LANCHOR18
	.size	FW_FlashBlockErase.constprop.41, .-FW_FlashBlockErase.constprop.41
	.section	.text.ftl_memset,"ax",%progbits
	.align	1
	.global	ftl_memset
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_memset, %function
ftl_memset:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	memset
	.size	ftl_memset, .-ftl_memset
	.section	.text.BuildFlashLsbPageTable,"ax",%progbits
	.align	1
	.global	BuildFlashLsbPageTable
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	BuildFlashLsbPageTable, %function
BuildFlashLsbPageTable:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r4, r1
	cbnz	r0, .L791
	ldr	r3, .L831
.L792:
	strh	r0, [r3, r0, lsl #1]	@ movhi
	adds	r0, r0, #1
	cmp	r0, #256
	bne	.L792
.L798:
	movs	r1, #255
	mov	r2, #1024
	ldr	r0, .L831+4
	uxth	r4, r4
	bl	ftl_memset
	ldr	r1, .L831
	movs	r3, #0
	ldr	r0, .L831+4
.L793:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L817
	pop	{r4, pc}
.L791:
	cmp	r0, #1
	bne	.L794
	ldr	r1, .L831
	movs	r3, #0
.L797:
	cmp	r3, #3
	uxth	r2, r3
	bls	.L795
	tst	r2, #1
	ite	ne
	movne	r0, #3
	moveq	r0, #2
	rsb	r2, r0, r2, lsl #1
	uxth	r2, r2
.L795:
	strh	r2, [r1, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L797
	b	.L798
.L794:
	cmp	r0, #2
	bne	.L799
	ldr	r1, .L831
	movs	r2, #0
.L801:
	uxth	r3, r2
	cmp	r2, #1
	ittt	hi
	lslhi	r3, r3, #1
	addhi	r3, r3, #-1
	uxthhi	r3, r3
	strh	r3, [r1, r2, lsl #1]	@ movhi
	adds	r2, r2, #1
	cmp	r2, #256
	bne	.L801
	b	.L798
.L799:
	cmp	r0, #3
	bne	.L802
	ldr	r1, .L831
	movs	r3, #0
.L805:
	cmp	r3, #5
	uxth	r2, r3
	bls	.L803
	tst	r2, #1
	ite	ne
	movne	r0, #5
	moveq	r0, #4
	rsb	r2, r0, r2, lsl #1
	uxth	r2, r2
.L803:
	strh	r2, [r1, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L805
	b	.L798
.L802:
	cmp	r0, #4
	mov	r3, #0
	bne	.L806
	ldr	r2, .L831
	strh	r3, [r2]	@ movhi
	movs	r3, #1
	strh	r3, [r2, #2]	@ movhi
	movs	r3, #2
	strh	r3, [r2, #4]	@ movhi
	movs	r3, #3
	strh	r3, [r2, #6]	@ movhi
	movs	r3, #5
	strh	r3, [r2, #10]	@ movhi
	movs	r3, #7
	strh	r3, [r2, #12]	@ movhi
	movs	r3, #8
	strh	r0, [r2, #8]	@ movhi
	strh	r3, [r2, #14]!	@ movhi
.L808:
	tst	r3, #1
	ite	ne
	movne	r1, #7
	moveq	r1, #6
	rsb	r1, r1, r3, lsl #1
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r1, [r2, #2]!	@ movhi
	cmp	r3, #256
	bne	.L808
	b	.L798
.L806:
	cmp	r0, #5
	bne	.L809
	ldr	r2, .L831
.L810:
	strh	r3, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #16
	bne	.L810
	ldr	r2, .L831+8
.L811:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, #496
	bne	.L811
	b	.L798
.L809:
	cmp	r0, #6
	bne	.L812
	ldr	r0, .L831
	mov	r1, r3
.L815:
	cmp	r1, #5
	uxth	r2, r1
	bls	.L813
	tst	r2, #1
	ite	ne
	movne	r2, #12
	moveq	r2, #10
	subs	r2, r3, r2
	uxth	r2, r2
.L813:
	strh	r2, [r0, r1, lsl #1]	@ movhi
	adds	r1, r1, #1
	cmp	r1, #256
	add	r3, r3, #3
	uxth	r3, r3
	bne	.L815
	b	.L798
.L812:
	cmp	r0, #9
	bne	.L798
	ldr	r2, .L831
	movw	r1, #509
	strh	r3, [r2]	@ movhi
	movs	r3, #1
	strh	r3, [r2, #2]	@ movhi
	mov	r3, r2
	movs	r2, #2
	strh	r2, [r3, #4]!	@ movhi
	movs	r2, #3
.L816:
	strh	r2, [r3, #2]!	@ movhi
	adds	r2, r2, #2
	uxth	r2, r2
	cmp	r2, r1
	bne	.L816
	b	.L798
.L817:
	ldrh	r2, [r1, r3, lsl #1]
	adds	r3, r3, #1
	strh	r2, [r0, r2, lsl #1]	@ movhi
	b	.L793
.L832:
	.align	2
.L831:
	.word	.LANCHOR16
	.word	.LANCHOR120
	.word	.LANCHOR16+30
	.size	BuildFlashLsbPageTable, .-BuildFlashLsbPageTable
	.section	.text.FlashDieInfoInit,"ax",%progbits
	.align	1
	.global	FlashDieInfoInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashDieInfoInit, %function
FlashDieInfoInit:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L847
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r5, .L847+4
	ldr	fp, .L847+36
	ldrh	r0, [r3, #10]
	strb	r4, [r5]
	strb	r4, [fp]
	bl	FlashBlockAlignInit
	movs	r2, #8
	mov	r1, r4
	ldr	r0, .L847+8
	bl	ftl_memset
	movs	r2, #32
	mov	r1, r4
	ldr	r0, .L847+12
	bl	ftl_memset
	movs	r2, #128
	mov	r1, r4
	ldr	r0, .L847+16
	bl	ftl_memset
	ldr	r3, .L847+20
	ldr	r10, .L847+32
	ldr	r6, [r3]
	ldr	r3, .L847+8
	ldrb	r8, [r6]	@ zero_extendqisi2
	adds	r7, r6, #1
.L835:
	mov	r2, r8
	add	r1, r10, r4, lsl #3
	mov	r0, r7
	str	r3, [sp, #4]
	bl	FlashMemCmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L834
	ldrb	r2, [r5]	@ zero_extendqisi2
	ldr	r1, .L847+12
	strb	r4, [r3, r2]
	str	r0, [r1, r2, lsl #2]
	adds	r1, r2, #1
	strb	r1, [r5]
.L834:
	adds	r4, r4, #1
	cmp	r4, #4
	bne	.L835
	ldrb	r3, [r5]	@ zero_extendqisi2
	strb	r3, [fp]
	ldrb	r3, [r6, #8]	@ zero_extendqisi2
	cmp	r3, #2
	beq	.L836
.L840:
	ldrh	r2, [r6, #14]
	ldrb	r3, [r5]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldrb	r2, [r6, #13]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldr	r2, .L847+24
	strh	r3, [r2]	@ movhi
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L836:
	ldr	r3, .L847+28
	movs	r4, #0
	ldr	r10, .L847+12
	ldr	fp, [r3]
	ldr	r3, .L847+8
.L839:
	str	r3, [sp, #4]
	mov	r2, r8
	ldr	r3, .L847+32
	mov	r0, r7
	add	r1, r3, r4, lsl #3
	bl	FlashMemCmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L837
	ldrh	r2, [r6, #14]
	ldrb	r1, [r5]	@ zero_extendqisi2
	and	r0, r2, #65280
	ldrb	r2, [r6, #13]	@ zero_extendqisi2
	mul	r2, fp, r2
	muls	r2, r0, r2
	str	r2, [r10, r1, lsl #2]
	ldrb	r0, [r6, #23]	@ zero_extendqisi2
	cbz	r0, .L838
	lsls	r2, r2, #1
	str	r2, [r10, r1, lsl #2]
.L838:
	adds	r2, r1, #1
	strb	r4, [r3, r1]
	strb	r2, [r5]
.L837:
	adds	r4, r4, #1
	cmp	r4, #4
	bne	.L839
	b	.L840
.L848:
	.align	2
.L847:
	.word	.LANCHOR31
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR17
	.word	.LANCHOR23
	.word	.LANCHOR18
	.word	.LANCHOR122
	.word	.LANCHOR4
	.word	.LANCHOR22
	.word	.LANCHOR121
	.size	FlashDieInfoInit, .-FlashDieInfoInit
	.section	.text.ReadFlashInfo,"ax",%progbits
	.align	1
	.global	ReadFlashInfo
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ReadFlashInfo, %function
ReadFlashInfo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	movs	r2, #11
	movs	r1, #0
	mov	r4, r0
	bl	ftl_memset
	ldr	r3, .L852
	movs	r2, #0
	ldr	r1, [r3]
	ldr	r3, .L852+4
	ldrb	r0, [r1, #9]	@ zero_extendqisi2
	ldr	r3, [r3]
	smulbb	r3, r3, r0
	uxth	r3, r3
	strb	r3, [r4, #4]
	lsrs	r3, r3, #8
	strb	r3, [r4, #5]
	ldr	r3, .L852+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r4, #7]
	ldr	r3, .L852+12
	ldrb	r5, [r3]	@ zero_extendqisi2
	strb	r5, [r4]
	ldrb	r5, [r3, #1]	@ zero_extendqisi2
	strb	r5, [r4, #1]
	ldrb	r5, [r3, #2]	@ zero_extendqisi2
	ldrb	r3, [r3, #3]	@ zero_extendqisi2
	strb	r0, [r4, #6]
	strb	r5, [r4, #2]
	movs	r5, #1
	strb	r3, [r4, #3]
	movs	r3, #32
	strb	r3, [r4, #8]
	ldrb	r3, [r1, #7]	@ zero_extendqisi2
	ldr	r0, .L852+16
	strb	r2, [r4, #10]
	strb	r3, [r4, #9]
	ldr	r3, .L852+20
	ldrb	r1, [r3]	@ zero_extendqisi2
	mov	r3, r2
.L850:
	uxtb	r2, r3
	cmp	r1, r2
	bhi	.L851
	pop	{r4, r5, r6, pc}
.L851:
	ldrb	r2, [r3, r0]	@ zero_extendqisi2
	adds	r3, r3, #1
	ldrb	r6, [r4, #10]	@ zero_extendqisi2
	lsl	r2, r5, r2
	orrs	r2, r2, r6
	strb	r2, [r4, #10]
	b	.L850
.L853:
	.align	2
.L852:
	.word	.LANCHOR18
	.word	.LANCHOR4
	.word	.LANCHOR33
	.word	.LANCHOR68
	.word	.LANCHOR26
	.word	.LANCHOR25
	.size	ReadFlashInfo, .-ReadFlashInfo
	.section	.text.FtlBbt2Bitmap,"ax",%progbits
	.align	1
	.global	FtlBbt2Bitmap
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlBbt2Bitmap, %function
FtlBbt2Bitmap:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L860
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, r0
	ldr	r7, .L860+4
	mov	r6, r1
	subs	r4, r5, #2
	addw	r5, r5, #1022
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r8, .L860+20
	mov	r0, r6
	lsls	r2, r2, #2
	bl	ftl_memset
.L857:
	ldrh	r3, [r4, #2]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L854
	ldrh	r2, [r7]
	cmp	r2, r3
	bhi	.L856
	mov	r1, r8
	movs	r2, #79
	ldr	r0, .L860+8
	bl	printf
	ldr	r1, .L860+12
	ldr	r0, .L860+16
	bl	printf
.L856:
	ldrh	r3, [r4, #2]!
	movs	r2, #1
	cmp	r5, r4
	lsr	r1, r3, #5
	and	r3, r3, #31
	lsl	r3, r2, r3
	ldr	r2, [r6, r1, lsl #2]
	orr	r2, r2, r3
	str	r2, [r6, r1, lsl #2]
	bne	.L857
.L854:
	pop	{r4, r5, r6, r7, r8, pc}
.L861:
	.align	2
.L860:
	.word	.LANCHOR123
	.word	.LANCHOR51
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR124
	.size	FtlBbt2Bitmap, .-FtlBbt2Bitmap
	.section	.text.FtlBbtMemInit,"ax",%progbits
	.align	1
	.global	FtlBbtMemInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlBbtMemInit, %function
FtlBbtMemInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r0, .L863
	movw	r3, #65535
	movs	r2, #16
	movs	r1, #255
	strh	r3, [r0]	@ movhi
	movs	r3, #0
	strh	r3, [r0, #6]	@ movhi
	adds	r0, r0, #12
	b	ftl_memset
.L864:
	.align	2
.L863:
	.word	.LANCHOR74
	.size	FtlBbtMemInit, .-FtlBbtMemInit
	.section	.text.FtlFreeSysBlkQueueInit,"ax",%progbits
	.align	1
	.global	FtlFreeSysBlkQueueInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlFreeSysBlkQueueInit, %function
FtlFreeSysBlkQueueInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L866
	mov	r2, #2048
	push	{r4, lr}
	movs	r4, #0
	mov	r1, r4
	strh	r4, [r3, #2]	@ movhi
	strh	r4, [r3, #4]	@ movhi
	strh	r4, [r3, #6]	@ movhi
	strh	r0, [r3], #8	@ movhi
	mov	r0, r3
	bl	ftl_memset
	mov	r0, r4
	pop	{r4, pc}
.L867:
	.align	2
.L866:
	.word	.LANCHOR75
	.size	FtlFreeSysBlkQueueInit, .-FtlFreeSysBlkQueueInit
	.section	.text.ftl_free_no_use_map_blk,"ax",%progbits
	.align	1
	.global	ftl_free_no_use_map_blk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_free_no_use_map_blk, %function
ftl_free_no_use_map_blk:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r2, [r0, #10]
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r5, [r0, #20]
	movs	r1, #0
	ldr	r7, [r0, #12]
	lsls	r2, r2, #1
	ldr	r6, [r0, #24]
	mov	r0, r5
	bl	ftl_memset
	movs	r3, #0
.L869:
	ldrh	r1, [r4, #6]
	uxth	r2, r3
	cmp	r1, r2
	bhi	.L873
	ldr	r3, .L888
	movs	r6, #0
	mov	r10, r6
	ldrh	r2, [r3]
	ldrh	r3, [r4]
	strh	r2, [r5, r3, lsl #1]	@ movhi
	mov	r2, r6
	ldrh	fp, [r5]
.L874:
	ldrh	r3, [r4, #10]
	uxth	ip, r6
	cmp	r3, ip
	bhi	.L878
	mov	r0, r10
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L873:
	uxth	r2, r3
	ldr	r1, [r6, r2, lsl #2]
	movs	r2, #0
	ubfx	r1, r1, #10, #16
.L870:
	ldrh	ip, [r4, #10]
	uxth	r0, r2
	cmp	ip, r0
	bhi	.L872
	adds	r3, r3, #1
	b	.L869
.L872:
	uxth	r0, r2
	ldrh	ip, [r7, r0, lsl #1]
	cmp	ip, r1
	bne	.L871
	cbz	r1, .L871
	ldrh	ip, [r5, r0, lsl #1]
	add	ip, ip, #1
	strh	ip, [r5, r0, lsl #1]	@ movhi
.L871:
	adds	r2, r2, #1
	b	.L870
.L878:
	uxth	r1, r6
	ldrh	r3, [r5, r1, lsl #1]
	lsl	r8, r1, #1
	cmp	fp, r3
	bls	.L875
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cbnz	r0, .L876
.L877:
	adds	r6, r6, #1
	b	.L874
.L875:
	cmp	r3, #0
	bne	.L877
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cmp	r0, #0
	beq	.L877
.L879:
	movs	r1, #1
	str	r2, [sp, #4]
	bl	FtlFreeSysBlkQueueIn
	ldr	r2, [sp, #4]
	strh	r2, [r8]	@ movhi
	ldrh	r3, [r4, #8]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	b	.L877
.L876:
	mov	r10, ip
	mov	fp, r3
	cmp	r3, #0
	beq	.L879
	b	.L877
.L889:
	.align	2
.L888:
	.word	.LANCHOR53
	.size	ftl_free_no_use_map_blk, .-ftl_free_no_use_map_blk
	.section	.text.FtlL2PDataInit,"ax",%progbits
	.align	1
	.global	FtlL2PDataInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlL2PDataInit, %function
FtlL2PDataInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	movs	r1, #0
	ldr	r5, .L893
	ldr	r4, .L893+4
	ldr	r2, [r5]
	ldr	r7, .L893+8
	ldr	r6, .L893+12
	ldr	r0, [r4]
	lsls	r2, r2, #1
	ldr	r8, .L893+44
	bl	ftl_memset
	ldrh	r3, [r7]
	movs	r1, #255
	ldrh	r2, [r6]
	ldr	r0, [r8]
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L893+16
	movw	r0, #65535
	ldrh	r1, [r6]
	ldr	ip, [r8]
	ldr	r2, [r3]
	movs	r3, #12
	ldrh	r7, [r7]
	mla	r3, r1, r3, r3
	adds	r1, r2, r3
	movs	r3, #0
	mov	lr, r3
.L891:
	adds	r2, r2, #12
	adds	r6, r3, r7
	cmp	r2, r1
	bne	.L892
	ldr	r3, .L893+20
	ldr	r2, [r5]
	strh	r0, [r3, #2]	@ movhi
	strh	r2, [r3, #10]	@ movhi
	movw	r2, #61634
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L893+24
	strh	r0, [r3]	@ movhi
	ldrh	r2, [r2]
	strh	r2, [r3, #8]	@ movhi
	ldr	r2, .L893+28
	ldrh	r2, [r2]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, .L893+32
	ldr	r2, [r2]
	str	r2, [r3, #12]
	ldr	r2, .L893+36
	ldr	r2, [r2]
	str	r2, [r3, #16]
	ldr	r2, [r4]
	str	r2, [r3, #20]
	ldr	r2, .L893+40
	ldr	r2, [r2]
	str	r2, [r3, #24]
	pop	{r4, r5, r6, r7, r8, pc}
.L892:
	bic	r3, r3, #3
	str	lr, [r2, #-8]
	add	r3, r3, ip
	strh	r0, [r2, #-12]	@ movhi
	str	r3, [r2, #-4]
	mov	r3, r6
	b	.L891
.L894:
	.align	2
.L893:
	.word	.LANCHOR64
	.word	.LANCHOR125
	.word	.LANCHOR57
	.word	.LANCHOR67
	.word	.LANCHOR96
	.word	.LANCHOR127
	.word	.LANCHOR128
	.word	.LANCHOR66
	.word	.LANCHOR129
	.word	.LANCHOR130
	.word	.LANCHOR131
	.word	.LANCHOR126
	.size	FtlL2PDataInit, .-FtlL2PDataInit
	.section	.text.FtlVariablesInit,"ax",%progbits
	.align	1
	.global	FtlVariablesInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlVariablesInit, %function
FtlVariablesInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r4, #0
	ldr	r3, .L896
	movw	r2, #65535
	mov	r1, r4
	ldr	r5, .L896+4
	str	r4, [r3]
	ldr	r3, .L896+8
	strh	r2, [r3]	@ movhi
	mov	r2, #-1
	ldr	r3, .L896+12
	str	r4, [r3]
	ldr	r3, .L896+16
	str	r4, [r3]
	ldr	r3, .L896+20
	str	r2, [r3]
	ldr	r3, .L896+24
	str	r4, [r3]
	ldr	r3, .L896+28
	strh	r4, [r3]	@ movhi
	ldr	r3, .L896+32
	ldrh	r2, [r3]
	ldr	r3, .L896+36
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L896+40
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L896+44
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	mov	r1, r4
	movs	r2, #48
	ldr	r0, .L896+48
	bl	ftl_memset
	mov	r2, #512
	mov	r1, r4
	ldr	r0, .L896+52
	bl	ftl_memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L897:
	.align	2
.L896:
	.word	.LANCHOR132
	.word	.LANCHOR41
	.word	.LANCHOR133
	.word	.LANCHOR134
	.word	.LANCHOR135
	.word	.LANCHOR136
	.word	.LANCHOR28
	.word	.LANCHOR70
	.word	.LANCHOR61
	.word	.LANCHOR71
	.word	.LANCHOR78
	.word	.LANCHOR137
	.word	.LANCHOR80
	.word	.LANCHOR138
	.size	FtlVariablesInit, .-FtlVariablesInit
	.section	.text.SupperBlkListInit,"ax",%progbits
	.align	1
	.global	SupperBlkListInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	SupperBlkListInit, %function
SupperBlkListInit:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L909
	movs	r2, #6
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r1, #0
	ldr	r6, .L909+4
	sub	sp, sp, #24
	movs	r4, #0
	ldrh	r3, [r3]
	mov	r8, r4
	ldr	r0, [r6]
	mov	r5, r4
	mov	r10, r6
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L909+8
	ldr	r2, .L909+12
	ldr	r1, .L909+16
	str	r4, [r3]
	ldr	r3, .L909+20
	strh	r4, [r2]	@ movhi
	strh	r4, [r1]	@ movhi
	str	r4, [r3]
	ldr	r3, .L909+24
	str	r2, [sp, #8]
	str	r4, [r3]
	ldr	r3, .L909+28
	mov	fp, r3
	strh	r4, [r3]	@ movhi
.L899:
	ldr	r3, .L909+32
	sxth	r7, r4
	ldrh	r3, [r3]
	cmp	r7, r3
	bge	.L906
	ldr	r3, .L909+36
	uxth	r1, r4
	str	r1, [sp, #12]
	ldrh	r2, [r3]
	ldr	r3, .L909+40
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r6, r3
	b	.L907
.L901:
	str	r3, [sp, #20]
	ldr	r3, .L909+44
	ldr	r1, [sp, #12]
	str	r2, [sp, #16]
	ldrb	r0, [r3, r0]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #20]
	cbnz	r0, .L900
	ldr	r1, [sp, #4]
	add	r6, r6, r1
	sxth	r6, r6
.L900:
	adds	r3, r3, #1
.L907:
	sxth	r0, r3
	cmp	r0, r2
	blt	.L901
	lsls	r3, r7, #1
	cbz	r6, .L902
	mov	r1, r6
	str	r3, [sp, #4]
	mov	r0, #32768
	bl	__aeabi_idiv
	ldr	r3, [sp, #4]
	sxth	r6, r0
.L903:
	ldr	r2, [r10]
	add	r3, r3, r7
	add	r2, r2, r3, lsl #1
	ldr	r3, .L909+48
	strh	r6, [r2, #4]	@ movhi
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L904
	ldr	r3, .L909+52
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L904
	ldr	r3, .L909+56
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L904
	ldr	r3, .L909+60
	uxth	r0, r4
	ldr	r3, [r3]
	ldrh	r3, [r3, r7, lsl #1]
	cbnz	r3, .L905
	add	r8, r8, #1
	uxth	r8, r8
	bl	INSERT_FREE_LIST
.L904:
	adds	r4, r4, #1
	b	.L899
.L902:
	ldr	r2, .L909+60
	movw	r1, #65535
	ldr	r2, [r2]
	strh	r1, [r2, r7, lsl #1]	@ movhi
	b	.L903
.L905:
	adds	r5, r5, #1
	uxth	r5, r5
	bl	INSERT_DATA_LIST
	b	.L904
.L906:
	ldr	r2, [sp, #8]
	strh	r8, [fp]	@ movhi
	strh	r5, [r2]	@ movhi
	add	r5, r5, r8
	cmp	r3, r5
	bge	.L908
	ldr	r1, .L909+64
	movw	r2, #2647
	ldr	r0, .L909+68
	bl	printf
	ldr	r1, .L909+72
	ldr	r0, .L909+76
	bl	printf
.L908:
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L910:
	.align	2
.L909:
	.word	.LANCHOR41
	.word	.LANCHOR81
	.word	.LANCHOR87
	.word	.LANCHOR85
	.word	.LANCHOR139
	.word	.LANCHOR82
	.word	.LANCHOR84
	.word	.LANCHOR88
	.word	.LANCHOR40
	.word	.LANCHOR38
	.word	.LANCHOR52
	.word	.LANCHOR47
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR83
	.word	.LANCHOR140
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.size	SupperBlkListInit, .-SupperBlkListInit
	.section	.text.FtlGcPageVarInit,"ax",%progbits
	.align	1
	.global	FtlGcPageVarInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcPageVarInit, %function
FtlGcPageVarInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L912
	movs	r3, #0
	push	{r4, lr}
	movs	r1, #255
	ldr	r4, .L912+4
	strh	r3, [r2]	@ movhi
	ldr	r2, .L912+8
	strh	r3, [r2]	@ movhi
	ldrh	r2, [r4]
	ldr	r3, .L912+12
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r2, #12
	movs	r1, #255
	muls	r2, r3, r2
	ldr	r3, .L912+16
	ldr	r0, [r3]
	bl	ftl_memset
	pop	{r4, lr}
	b	FtlGcBufInit
.L913:
	.align	2
.L912:
	.word	.LANCHOR109
	.word	.LANCHOR54
	.word	.LANCHOR110
	.word	.LANCHOR108
	.word	.LANCHOR111
	.size	FtlGcPageVarInit, .-FtlGcPageVarInit
	.section	.text.idb_init,"ax",%progbits
	.align	1
	.global	idb_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	idb_init, %function
idb_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	mov	r2, #262144
	movs	r1, #0
	ldr	r0, .L915
	bl	ftl_memset
	movs	r0, #0
	pop	{r3, pc}
.L916:
	.align	2
.L915:
	.word	idb_buf
	.size	idb_init, .-idb_init
	.section	.text.ftl_memcpy,"ax",%progbits
	.align	1
	.global	ftl_memcpy
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_memcpy, %function
ftl_memcpy:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	memcpy
	.size	ftl_memcpy, .-ftl_memcpy
	.section	.text.FlashReadIdbData,"ax",%progbits
	.align	1
	.global	FlashReadIdbData
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadIdbData, %function
FlashReadIdbData:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	mov	r2, #2048
	ldr	r1, .L919
	bl	ftl_memcpy
	movs	r0, #0
	pop	{r3, pc}
.L920:
	.align	2
.L919:
	.word	.LANCHOR141
	.size	FlashReadIdbData, .-FlashReadIdbData
	.section	.text.FlashLoadPhyInfoInRam,"ax",%progbits
	.align	1
	.global	FlashLoadPhyInfoInRam
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashLoadPhyInfoInRam, %function
FlashLoadPhyInfoInRam:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	movs	r6, #0
	ldr	r7, .L929
	ldr	r5, .L929+4
.L924:
	ldrb	r2, [r7, #-1]	@ zero_extendqisi2
	mov	r1, r5
	mov	r0, r7
	lsl	r8, r6, #5
	bl	FlashMemCmp8
	mov	r4, r0
	cbnz	r0, .L922
	ldr	r5, .L929+8
	mov	r3, r4
	ldr	r2, .L929+12
	add	r5, r5, r8
	ldrb	r0, [r5, #22]	@ zero_extendqisi2
	mov	r1, r2
.L923:
	lsls	r6, r3, #5
	ldrb	r6, [r6, r2]	@ zero_extendqisi2
	cmp	r6, r0
	beq	.L926
	adds	r3, r3, #1
	cmp	r3, #4
	bne	.L923
.L926:
	ldr	r6, .L929+16
	add	r1, r1, r3, lsl #5
	movs	r2, #32
	ldr	r0, .L929+20
	bl	ftl_memcpy
	movs	r2, #32
	mov	r1, r5
	mov	r0, r6
	bl	ftl_memcpy
	ldrh	r0, [r6, #10]
	bl	FlashBlockAlignInit
	b	.L921
.L922:
	adds	r6, r6, #1
	adds	r7, r7, #32
	cmp	r6, #81
	bne	.L924
	mov	r4, #-1
.L921:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, pc}
.L930:
	.align	2
.L929:
	.word	.LANCHOR142+1
	.word	.LANCHOR22
	.word	.LANCHOR142
	.word	.LANCHOR143
	.word	.LANCHOR31
	.word	.LANCHOR7
	.size	FlashLoadPhyInfoInRam, .-FlashLoadPhyInfoInRam
	.section	.text.ftl_memcpy32,"ax",%progbits
	.align	1
	.global	ftl_memcpy32
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_memcpy32, %function
ftl_memcpy32:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movs	r3, #0
	push	{r4, lr}
.L932:
	cmp	r3, r2
	bne	.L933
	pop	{r4, pc}
.L933:
	ldr	r4, [r1, r3, lsl #2]
	str	r4, [r0, r3, lsl #2]
	adds	r3, r3, #1
	b	.L932
	.size	ftl_memcpy32, .-ftl_memcpy32
	.section	.text.NandcCopy1KB,"ax",%progbits
	.align	1
	.global	NandcCopy1KB
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcCopy1KB, %function
NandcCopy1KB:
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r1, #1
	push	{r4, r5, r6, lr}
	mov	r4, r2
	add	r2, r0, #4096
	add	r6, r0, #512
	add	r0, r2, r4, lsl #9
	ldr	r5, [sp, #16]
	bne	.L935
	cbz	r3, .L936
	lsls	r1, r3, #30
	bne	.L937
	mov	r2, #256
	mov	r1, r3
	bl	ftl_memcpy32
.L936:
	cbz	r5, .L934
	ldrb	r2, [r5, #1]	@ zero_extendqisi2
	lsrs	r4, r4, #1
	ldrb	r3, [r5]	@ zero_extendqisi2
	add	r4, r4, r4, lsl #1
	lsls	r4, r4, #4
	orr	r3, r3, r2, lsl #8
	ldrb	r2, [r5, #2]	@ zero_extendqisi2
	orr	r3, r3, r2, lsl #16
	ldrb	r2, [r5, #3]	@ zero_extendqisi2
	orr	r3, r3, r2, lsl #24
	str	r3, [r6, r4]
	pop	{r4, r5, r6, pc}
.L937:
	mov	r2, #1024
	mov	r1, r3
	bl	ftl_memcpy
	b	.L936
.L935:
	cbz	r3, .L940
	lsls	r2, r3, #30
	bne	.L941
	mov	r1, r0
	mov	r2, #256
	mov	r0, r3
	bl	ftl_memcpy32
.L940:
	cbz	r5, .L934
	lsrs	r4, r4, #1
	add	r4, r4, r4, lsl #1
	lsls	r4, r4, #4
	ldr	r3, [r6, r4]
	strb	r3, [r5]
	lsrs	r2, r3, #8
	strb	r2, [r5, #1]
	lsrs	r2, r3, #16
	lsrs	r3, r3, #24
	strb	r2, [r5, #2]
	strb	r3, [r5, #3]
.L934:
	pop	{r4, r5, r6, pc}
.L941:
	mov	r1, r0
	mov	r2, #1024
	mov	r0, r3
	bl	ftl_memcpy
	b	.L940
	.size	NandcCopy1KB, .-NandcCopy1KB
	.section	.text.NandcXferData,"ax",%progbits
	.align	1
	.global	NandcXferData
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcXferData, %function
NandcXferData:
	@ args = 4, pretend = 0, frame = 88
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r3
	ldr	r3, .L988
	sub	sp, sp, #96
	mov	r6, r0
	mov	r10, r2
	str	r1, [sp, #12]
	ldr	r5, [r3, r0, lsl #3]
	lsls	r3, r7, #26
	ldr	r4, [sp, #128]
	bne	.L953
	cbnz	r4, .L954
	add	r4, sp, #32
	movs	r2, #64
	movs	r1, #255
	add	r0, sp, #32
	bl	ftl_memset
.L954:
	movs	r3, #0
	mov	r2, r10
	ldr	r1, [sp, #12]
	mov	r0, r6
	str	r4, [sp, #4]
	str	r7, [sp]
	bl	NandcXferStart
	mov	r0, r6
	bl	NandcXferComp
	ldr	r3, [sp, #12]
	cmp	r3, #0
	bne	.L978
	ldr	r2, .L988+4
	lsr	r0, r10, #1
	ldr	ip, .L988+12
	ldr	r3, [r2]
	cmp	r3, #25
	ldr	r3, [sp, #12]
	ite	cc
	movcc	r7, #64
	movcs	r7, #128
	mov	r1, r3
.L957:
	cmp	r1, r0
	add	r4, r4, #4
	add	r6, r7, r3
	bcc	.L958
	ldr	r3, .L988+8
	lsr	r4, r10, #2
	ldr	r0, [r2]
	movs	r2, #0
	mov	r8, r2
	ldr	r1, [r3]
.L959:
	cmp	r2, r4
	bcs	.L955
	cbnz	r0, .L965
.L955:
	movs	r3, #0
	str	r3, [r5, #16]
.L966:
	ldr	r3, .L988+8
	ldr	r3, [r3]
	cmp	r3, #5
	bls	.L952
	ldr	r3, [sp, #12]
	cbnz	r3, .L952
	ldr	r3, [r5]
	and	r2, r3, #139264
	cmp	r2, #139264
	ittt	eq
	moveq	r8, #-1
	orreq	r3, r3, #131072
	streq	r3, [r5]
.L952:
	mov	r0, r8
	add	sp, sp, #96
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L958:
	bic	lr, r3, #3
	ldr	r3, [ip, #4]
	adds	r1, r1, #1
	ldr	r3, [r3, lr]
	strb	r3, [r4, #-4]
	lsr	lr, r3, #8
	strb	lr, [r4, #-3]
	lsr	lr, r3, #16
	lsrs	r3, r3, #24
	strb	lr, [r4, #-2]
	strb	r3, [r4, #-1]
	mov	r3, r6
	b	.L957
.L965:
	add	r3, r2, #8
	ldr	r3, [r5, r3, lsl #2]
	str	r3, [sp, #28]
	ldr	r3, [sp, #28]
	lsls	r6, r3, #29
	bmi	.L981
	ldr	r3, [sp, #28]
	ubfx	r3, r3, #15, #1
	cmp	r3, #0
	bne	.L981
	cmp	r1, #5
	bls	.L961
	ldr	r6, [sp, #28]
	ldr	r3, [sp, #28]
	ubfx	r6, r6, #3, #5
	ubfx	ip, r3, #27, #1
	ldr	r3, [sp, #28]
	ldr	r7, [sp, #28]
	orr	r6, r6, ip, lsl #5
	ubfx	r3, r3, #16, #5
	ubfx	r7, r7, #29, #1
	orr	r3, r3, r7, lsl #5
	cmp	r6, r3
	ldr	r3, [sp, #28]
	itete	hi
	ldrhi	r6, [sp, #28]
	ldrls	r6, [sp, #28]
	ubfxhi	r3, r3, #3, #5
	ubfxls	r3, r3, #16, #5
	ite	hi
	ubfxhi	r6, r6, #27, #1
	ubfxls	r6, r6, #29, #1
.L987:
	orr	r3, r3, r6, lsl #5
.L963:
	cmp	r8, r3
	it	cc
	movcc	r8, r3
.L960:
	adds	r2, r2, #1
	b	.L959
.L961:
	cmp	r1, #3
	bls	.L963
	ldr	r6, [sp, #28]
	ldr	r3, [sp, #28]
	ubfx	r6, r6, #3, #5
	ubfx	ip, r3, #28, #1
	ldr	r3, [sp, #28]
	ldr	r7, [sp, #28]
	orr	r6, r6, ip, lsl #5
	ubfx	r3, r3, #16, #5
	ubfx	r7, r7, #30, #1
	orr	r3, r3, r7, lsl #5
	cmp	r6, r3
	ldr	r3, [sp, #28]
	itete	hi
	ldrhi	r6, [sp, #28]
	ldrls	r6, [sp, #28]
	ubfxhi	r3, r3, #3, #5
	ubfxls	r3, r3, #16, #5
	ite	hi
	ubfxhi	r6, r6, #28, #1
	ubfxls	r6, r6, #30, #1
	b	.L987
.L981:
	mov	r8, #-1
	b	.L960
.L978:
	mov	r8, #0
	b	.L955
.L953:
	ldr	r3, [sp, #12]
	cmp	r3, #1
	bne	.L967
	cmp	r4, #0
	mov	r8, #0
	ite	ne
	movne	r3, #4
	moveq	r3, #0
	str	r3, [sp, #16]
.L968:
	cmp	r8, r10
	bcc	.L970
	mov	r8, #0
	b	.L966
.L970:
	and	fp, r8, #3
	cbz	r7, .L983
	add	r3, r7, r8, lsl #9
.L969:
	str	r4, [sp]
	mov	r2, fp
	movs	r1, #1
	mov	r0, r5
	bl	NandcCopy1KB
	movs	r3, #0
	movs	r2, #2
	str	r3, [sp, #4]
	movs	r1, #1
	str	r3, [sp]
	mov	r0, r6
	mov	r3, fp
	add	r8, r8, #2
	bl	NandcXferStart
	mov	r0, r6
	bl	NandcXferComp
	ldr	r3, [sp, #16]
	add	r4, r4, r3
	b	.L968
.L983:
	mov	r3, r7
	b	.L969
.L967:
	mov	r8, #0
	movs	r2, #2
	mov	r3, r8
	str	r8, [sp, #4]
	str	r8, [sp]
	mov	r1, r8
	bl	NandcXferStart
	mov	fp, r7
	cmp	r4, r8
	str	r4, [sp, #16]
	mov	r4, r8
	ite	ne
	movne	r3, #4
	moveq	r3, r8
	str	r3, [sp, #20]
.L971:
	cmp	r4, r10
	bcs	.L966
	mov	r0, r6
	adds	r4, r4, #2
	bl	NandcXferComp
	ldr	r3, [r5, #32]
	cmp	r10, r4
	str	r3, [sp, #28]
	bls	.L972
	movs	r3, #0
	movs	r2, #2
	str	r3, [sp, #4]
	movs	r1, #0
	str	r3, [sp]
	mov	r0, r6
	and	r3, r4, #3
	bl	NandcXferStart
.L972:
	ldr	r3, [sp, #28]
	lsls	r3, r3, #29
	bmi	.L984
	ldr	r3, [sp, #28]
	ldr	r2, [sp, #28]
	ubfx	r3, r3, #3, #5
	ubfx	r2, r2, #27, #1
	orr	r3, r3, r2, lsl #5
	cmp	r8, r3
	it	cc
	movcc	r8, r3
.L973:
	ldr	r3, [sp, #16]
	cmp	r7, #0
	sub	r2, r4, #2
	mov	r1, #0
	and	r2, r2, #3
	mov	r0, r5
	str	r3, [sp]
	ite	ne
	movne	r3, fp
	moveq	r3, #0
	add	fp, fp, #1024
	bl	NandcCopy1KB
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #20]
	add	r3, r3, r2
	str	r3, [sp, #16]
	b	.L971
.L984:
	mov	r8, #-1
	b	.L973
.L989:
	.align	2
.L988:
	.word	.LANCHOR0
	.word	.LANCHOR32
	.word	.LANCHOR34
	.word	.LANCHOR35
	.size	NandcXferData, .-NandcXferData
	.section	.text.FlashReadRawPage,"ax",%progbits
	.align	1
	.global	FlashReadRawPage
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadRawPage, %function
FlashReadRawPage:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r8, r3
	ldr	r3, .L992
	mov	r6, r1
	mov	r7, r2
	mov	r4, r0
	ldrb	r5, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L991
	ldr	r3, .L992+4
	ldr	r2, .L992+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r0, [r2]
	muls	r0, r3, r0
	cmp	r0, r1
	it	hi
	movhi	r5, #4
.L991:
	mov	r0, r4
	bl	NandcWaitFlashReady
	mov	r0, r4
	bl	NandcFlashCs
	mov	r1, r6
	mov	r0, r4
	bl	FlashReadCmd
	mov	r0, r4
	bl	NandcWaitFlashReady
	mov	r3, r7
	mov	r2, r5
	str	r8, [sp]
	movs	r1, #0
	mov	r0, r4
	bl	NandcXferData
	mov	r1, r0
	mov	r0, r4
	bl	NandcFlashDeCs
	mov	r0, r1
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L993:
	.align	2
.L992:
	.word	.LANCHOR31
	.word	.LANCHOR3
	.word	.LANCHOR4
	.size	FlashReadRawPage, .-FlashReadRawPage
	.section	.text.FlashDdrTunningRead,"ax",%progbits
	.align	1
	.global	FlashDdrTunningRead
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashDdrTunningRead, %function
FlashDdrTunningRead:
	@ args = 4, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r3
	ldr	r3, .L1019
	sub	sp, sp, #24
	str	r0, [sp, #8]
	ldr	r3, [r3]
	str	r1, [sp, #12]
	str	r2, [sp, #4]
	ldr	r3, [r3, #304]
	str	r3, [sp, #20]
	ldr	r3, .L1019+4
	ldr	r3, [r3]
	cmp	r3, #8
	ldr	r3, [sp, #56]
	ite	cc
	movcc	fp, #6
	movcs	fp, #12
	cmp	r3, #0
	beq	.L1008
	movs	r0, #1
	ldr	r4, .L1019+8
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	ldr	r0, [sp, #8]
	bl	FlashReset
	mov	r3, r7
	ldr	r2, [sp, #4]
	ldr	r1, [sp, #12]
	ldr	r0, [sp, #8]
	bl	FlashReadRawPage
	mov	r6, r0
	ldrb	r0, [r4]	@ zero_extendqisi2
	bl	FlashSetInterfaceMode
	ldrb	r0, [r4]	@ zero_extendqisi2
	bl	NandcSetMode
	adds	r3, r6, #1
	bne	.L997
.L1006:
	mov	r6, #-1
.L994:
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L997:
	mov	r2, r6
	ldr	r1, [sp, #12]
	ldr	r0, .L1019+12
	bl	printf
	ldr	r2, .L1019+16
	ldr	r3, [r2]
	adds	r3, r3, #1
	cmp	r3, #2048
	bcs	.L999
	str	r3, [r2]
	b	.L994
.L999:
	movs	r7, #0
	str	r7, [r2]
	str	r7, [sp, #4]
.L996:
	mov	r10, #0
	mov	r8, #-1
	mov	r5, r10
	mov	r4, r10
	str	r10, [sp, #16]
.L1004:
	uxtb	r0, fp
	bl	NandcSetDdrPara
	mov	r3, r7
	ldr	r2, [sp, #4]
	ldr	r1, [sp, #12]
	ldr	r0, [sp, #8]
	bl	FlashReadRawPage
	adds	r3, r6, #1
	cmp	r0, r3
	bhi	.L1000
	cmp	r0, #2
	bhi	.L1010
	adds	r4, r4, #1
	cmp	r4, #9
	bls	.L1010
	mov	r3, r5
	mov	r6, r0
	sub	r5, fp, r4
	mov	r8, #0
.L1002:
	ldr	r2, [sp, #16]
	cmp	r4, r2
	it	ls
	movls	r5, r3
.L1003:
	cbz	r5, .L1005
	mov	r1, r5
	ldr	r0, .L1019+20
	bl	printf
	uxtb	r0, r5
	bl	NandcSetDdrPara
.L1005:
	cmp	r8, #0
	beq	.L994
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #8]
	ldr	r0, .L1019+24
	bl	printf
	ldr	r3, [sp, #56]
	cmp	r3, #0
	beq	.L1006
	ldr	r3, [sp, #20]
	ubfx	r0, r3, #8, #8
	bl	NandcSetDdrPara
	b	.L994
.L1008:
	mov	r6, #1024
	b	.L996
.L1000:
	ldr	r3, [sp, #16]
	cmp	r4, r3
	bls	.L1011
	cmp	r4, #7
	sub	r5, r10, r4
	bhi	.L1003
	str	r4, [sp, #16]
.L1011:
	movs	r4, #0
	b	.L1001
.L1010:
	mov	r8, #0
	mov	r10, fp
	mov	r6, r0
	mov	r7, r8
	str	r8, [sp, #4]
.L1001:
	add	fp, fp, #2
	cmp	fp, #69
	bls	.L1004
	mov	r3, r5
	mov	r5, r10
	b	.L1002
.L1020:
	.align	2
.L1019:
	.word	.LANCHOR19
	.word	.LANCHOR34
	.word	.LANCHOR24
	.word	.LC9
	.word	.LANCHOR144
	.word	.LC10
	.word	.LC11
	.size	FlashDdrTunningRead, .-FlashDdrTunningRead
	.section	.text.FlashReadPage,"ax",%progbits
	.align	1
	.global	FlashReadPage
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadPage, %function
FlashReadPage:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r2
	mov	r5, r0
	mov	r6, r1
	mov	r8, r3
	bl	FlashReadRawPage
	adds	r2, r0, #1
	mov	r4, r0
	bne	.L1022
	ldr	r10, .L1040+20
	ldrb	fp, [r10]	@ zero_extendqisi2
	cmp	fp, #0
	bne	.L1023
.L1025:
	ldr	r3, .L1040
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1022
	ldr	r3, .L1040+4
	mov	r1, r6
	mov	r2, r7
	mov	r0, r5
	ldr	r3, [r3]
	ldr	r10, [r3, #304]
	movs	r3, #1
	str	r3, [sp]
	mov	r3, r8
	bl	FlashDdrTunningRead
	adds	r1, r0, #1
	mov	r4, r0
	beq	.L1026
	ldr	r3, .L1040+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3, lsr #1
	bls	.L1022
.L1026:
	ubfx	r0, r10, #8, #8
	bl	NandcSetDdrPara
	b	.L1022
.L1023:
	movs	r3, #0
	mov	r2, r7
	strb	r3, [r10]
	mov	r1, r6
	mov	r3, r8
	mov	r0, r5
	bl	FlashReadRawPage
	adds	r3, r0, #1
	strb	fp, [r10]
	beq	.L1025
	mov	r4, r0
.L1022:
	ldr	r10, .L1040+24
	ldr	fp, [r10]
	cmp	fp, #0
	beq	.L1021
	adds	r2, r4, #1
	bne	.L1021
	mov	r3, r8
	mov	r2, r7
	mov	r1, r6
	mov	r0, r5
	blx	fp
	mov	r3, r6
	mov	r4, r0
	mov	r1, r0
	mov	r2, r5
	ldr	r0, .L1040+12
	bl	printf
	adds	r3, r4, #1
	bne	.L1021
	ldr	r3, .L1040+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1021
	mov	r0, r5
	bl	flash_enter_slc_mode
	ldr	r4, [r10]
	mov	r3, r8
	mov	r2, r7
	mov	r1, r6
	mov	r0, r5
	blx	r4
	mov	r4, r0
	mov	r0, r5
	bl	flash_exit_slc_mode
.L1021:
	mov	r0, r4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1041:
	.align	2
.L1040:
	.word	.LANCHOR30
	.word	.LANCHOR19
	.word	.LANCHOR33
	.word	.LC12
	.word	.LANCHOR15
	.word	.LANCHOR6
	.word	.LANCHOR145
	.size	FlashReadPage, .-FlashReadPage
	.section	.text.FlashDdrParaScan,"ax",%progbits
	.align	1
	.global	FlashDdrParaScan
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashDdrParaScan, %function
FlashDdrParaScan:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r6, r0
	ldr	r4, .L1053
	movs	r5, #0
	mov	r7, r1
	ldrb	r0, [r4]	@ zero_extendqisi2
	bl	FlashSetInterfaceMode
	ldrb	r0, [r4]	@ zero_extendqisi2
	bl	NandcSetMode
	mov	r3, r5
	mov	r2, r5
	str	r5, [sp]
	mov	r1, r7
	mov	r0, r6
	bl	FlashDdrTunningRead
	mov	r3, r5
	mov	r2, r5
	mov	r8, r0
	mov	r1, r7
	mov	r0, r6
	ldr	r5, .L1053+4
	bl	FlashReadRawPage
	adds	r0, r0, #1
	beq	.L1043
	cmp	r8, #-1
	bne	.L1044
.L1043:
	ldrb	r3, [r4]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L1044
	movs	r0, #1
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	movs	r3, #0
.L1052:
	movs	r0, #0
	strb	r3, [r5]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1044:
	movs	r3, #1
	b	.L1052
.L1054:
	.align	2
.L1053:
	.word	.LANCHOR24
	.word	.LANCHOR30
	.size	FlashDdrParaScan, .-FlashDdrParaScan
	.section	.text.FlashLoadPhyInfo,"ax",%progbits
	.align	1
	.global	FlashLoadPhyInfo
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashLoadPhyInfo, %function
FlashLoadPhyInfo:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r3, #60
	sub	sp, sp, #24
	ldr	fp, .L1069+32
	movs	r4, #0
	movs	r7, #4
	strb	r3, [sp, #20]
	movs	r3, #40
	strb	r3, [sp, #21]
	movs	r3, #24
	strb	r3, [sp, #22]
	movs	r3, #16
	strb	r3, [sp, #23]
	mov	r0, r4
	ldr	r3, [fp]
	mov	r6, #-1
	ldr	r8, .L1069+36
	ldr	r10, .L1069+40
	str	r3, [sp, #4]
	ldr	r5, .L1069
	ldr	r3, [r8]
	str	r4, [r10]
	str	r3, [r5]
	bl	flash_enter_slc_mode
	str	r10, [sp, #12]
	mov	r10, r8
.L1056:
	mov	r8, #0
	adds	r3, r4, #1
	str	r3, [sp, #8]
.L1058:
	add	r3, sp, #20
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r3, #0
	ldr	r2, [r10]
	mov	r1, r4
	mov	r0, r3
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L1057
	movs	r3, #0
	ldr	r2, [r10]
	ldr	r1, [sp, #8]
	mov	r0, r3
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L1057
	add	r8, r8, #1
	cmp	r8, #4
	bne	.L1058
.L1059:
	ldr	r3, [sp, #4]
	subs	r7, r7, #1
	add	r4, r4, r3
	bne	.L1056
	mov	r0, r7
	b	.L1068
.L1060:
	movw	r1, #2036
	add	r0, r8, #12
	bl	js_hash
	ldr	r3, [r8, #8]
	cmp	r3, r0
	bne	.L1066
	ldr	r6, .L1069+4
	movs	r2, #32
	add	r1, r8, #160
	mov	r0, r6
	bl	ftl_memcpy
	ldr	r1, [r5]
	movs	r2, #32
	ldr	r0, .L1069+8
	adds	r1, r1, #192
	bl	ftl_memcpy
	ldr	r1, [r5]
	mov	r2, #852
	ldr	r0, .L1069+12
	adds	r1, r1, #224
	bl	ftl_memcpy
	ldrh	r0, [r6, #10]
	bl	FlashBlockAlignInit
	ldr	r6, [r5]
	mov	r0, r4
	ldr	r3, .L1069+16
	ldr	r1, [fp]
	ldr	r2, [r6, #1076]
	strb	r2, [r3]
	ldr	r3, [sp, #12]
	str	r4, [r3]
	bl	__aeabi_uidiv
	ldr	r3, .L1069+20
	adds	r0, r0, #1
	cmp	r0, #1
	itte	ls
	movls	r2, #2
	strls	r2, [r3]
	strhi	r0, [r3]
	ldrh	r2, [r6, #14]
	movs	r6, #0
	ldr	r3, .L1069+24
	strb	r2, [r3]
	b	.L1059
.L1066:
	mov	r6, #-1
	b	.L1059
.L1057:
	ldr	r8, [r5]
	ldr	r2, .L1069+28
	ldr	r3, [r8]
	cmp	r3, r2
	bne	.L1059
	cmp	r6, #0
	bne	.L1060
	ldr	r1, [fp]
	mov	r0, r4
	bl	__aeabi_uidiv
	ldr	r3, .L1069+20
	adds	r0, r0, #1
	str	r0, [r3]
	mov	r0, r6
.L1068:
	bl	flash_exit_slc_mode
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1070:
	.align	2
.L1069:
	.word	.LANCHOR146
	.word	.LANCHOR31
	.word	.LANCHOR7
	.word	.LANCHOR20
	.word	.LANCHOR30
	.word	.LANCHOR149
	.word	.LANCHOR150
	.word	1312902724
	.word	.LANCHOR4
	.word	.LANCHOR147
	.word	.LANCHOR148
	.size	FlashLoadPhyInfo, .-FlashLoadPhyInfo
	.section	.text.ToshibaReadRetrial,"ax",%progbits
	.align	1
	.global	ToshibaReadRetrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ToshibaReadRetrial, %function
ToshibaReadRetrial:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	mov	r6, r0
	str	r2, [sp, #12]
	mov	fp, r3
	str	r1, [sp, #20]
	bl	NandcWaitFlashReady
	ldr	r3, .L1098
	ldr	r2, .L1098+4
	ldr	r4, [r3, r6, lsl #3]
	add	r3, r3, r6, lsl #3
	str	r2, [sp, #16]
	ldrb	r7, [r3, #4]	@ zero_extendqisi2
	ldrb	r3, [r2]	@ zero_extendqisi2
	add	r5, r7, #8
	subs	r3, r3, #67
	add	r5, r4, r5, lsl #8
	cmp	r3, #1
	bls	.L1088
	ldr	r3, .L1098+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1089
	movs	r0, #0
	bl	NandcSetDdrMode
	movs	r3, #1
.L1089:
	str	r3, [sp, #8]
	add	r3, r4, r7, lsl #8
	movs	r2, #92
	str	r2, [r3, #2056]
	movs	r2, #197
	str	r2, [r3, #2056]
.L1072:
	mov	r8, #1
	mov	r3, #-1
	str	r3, [sp, #4]
.L1074:
	ldr	r3, .L1098+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r8, r3
	bcc	.L1083
	ldr	r10, [sp, #4]
.L1082:
	ldr	r3, [sp, #16]
	movs	r1, #0
	mov	r0, r5
	ldrb	r2, [r3]	@ zero_extendqisi2
	subs	r2, r2, #67
	cmp	r2, #1
	bhi	.L1084
	bl	SandiskSetRRPara
.L1085:
	add	r4, r4, r7, lsl #8
	movs	r2, #255
	str	r2, [r4, #2056]
	ldr	r2, .L1098+16
	ldrb	r2, [r2]	@ zero_extendqisi2
	add	r2, r2, r2, lsl #1
	cmp	r10, r2, asr #2
	bcc	.L1086
	cmp	r10, #-1
	it	ne
	movne	r10, #256
.L1086:
	mov	r0, r6
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #8]
	cbz	r3, .L1071
	movs	r0, #4
	bl	NandcSetDdrMode
.L1071:
	mov	r0, r10
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1088:
	movs	r3, #0
	str	r3, [sp, #8]
	b	.L1072
.L1083:
	ldr	r3, [sp, #16]
	mov	r0, r5
	uxtb	r1, r8
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L1075
	bl	SandiskSetRRPara
.L1076:
	ldr	r3, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L1077
	ldr	r3, .L1098+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #3
	cmp	r8, r3
	ittt	eq
	addeq	r3, r4, r7, lsl #8
	moveq	r2, #179
	streq	r2, [r3, #2056]
.L1077:
	add	r3, r4, r7, lsl #8
	movs	r2, #38
	str	r2, [r3, #2056]
	movs	r2, #93
	str	r2, [r3, #2056]
	ldr	r3, [sp, #8]
	cbz	r3, .L1078
	movs	r0, #4
	bl	NandcSetDdrMode
	mov	r3, fp
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #20]
	mov	r0, r6
	bl	FlashReadRawPage
	mov	r10, r0
	movs	r0, #0
	bl	NandcSetDdrMode
.L1079:
	cmp	r10, #-1
	beq	.L1080
	ldr	r2, .L1098+16
	ldr	r3, [sp, #4]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r3, #-1
	it	eq
	moveq	r3, r10
	str	r3, [sp, #4]
	add	r2, r2, r2, lsl #1
	cmp	r10, r2, asr #2
	bcc	.L1082
	mov	fp, #0
	str	fp, [sp, #12]
.L1080:
	add	r8, r8, #1
	b	.L1074
.L1075:
	bl	ToshibaSetRRPara
	b	.L1076
.L1078:
	mov	r3, fp
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #20]
	mov	r0, r6
	bl	FlashReadRawPage
	mov	r10, r0
	b	.L1079
.L1084:
	bl	ToshibaSetRRPara
	b	.L1085
.L1099:
	.align	2
.L1098:
	.word	.LANCHOR0
	.word	.LANCHOR9
	.word	.LANCHOR30
	.word	.LANCHOR151
	.word	.LANCHOR33
	.size	ToshibaReadRetrial, .-ToshibaReadRetrial
	.section	.text.SamsungReadRetrial,"ax",%progbits
	.align	1
	.global	SamsungReadRetrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	SamsungReadRetrial, %function
SamsungReadRetrial:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	mov	r10, r2
	mov	r8, r3
	mov	fp, r1
	movs	r6, #1
	bl	NandcWaitFlashReady
	ldr	r2, .L1113
	mov	r4, #-1
	add	r3, r2, r7, lsl #3
	ldrb	r5, [r3, #4]	@ zero_extendqisi2
	add	r3, r5, #8
	ldr	r5, [r2, r7, lsl #3]
	add	r5, r5, r3, lsl #8
.L1101:
	ldr	r3, .L1113+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r6, r3
	bcc	.L1105
.L1104:
	movs	r1, #0
	mov	r0, r5
	bl	SamsungSetRRPara
	ldr	r3, .L1113+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L1100
	adds	r3, r4, #1
	it	ne
	movne	r4, #256
.L1100:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1105:
	uxtb	r1, r6
	mov	r0, r5
	bl	SamsungSetRRPara
	mov	r2, r10
	mov	r3, r8
	mov	r1, fp
	mov	r0, r7
	bl	FlashReadRawPage
	adds	r2, r0, #1
	beq	.L1102
	ldr	r3, .L1113+8
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1108
	mov	r8, #0
	mov	r10, r8
.L1102:
	adds	r6, r6, #1
	b	.L1101
.L1108:
	mov	r4, r0
	b	.L1104
.L1114:
	.align	2
.L1113:
	.word	.LANCHOR0
	.word	.LANCHOR151
	.word	.LANCHOR33
	.size	SamsungReadRetrial, .-SamsungReadRetrial
	.section	.text.MicronReadRetrial,"ax",%progbits
	.align	1
	.global	MicronReadRetrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	MicronReadRetrial, %function
MicronReadRetrial:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r3
	ldr	r3, .L1140
	sub	sp, sp, #40
	mov	r5, r0
	str	r2, [sp, #16]
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L1140+4
	str	r1, [sp, #28]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1116
	add	r2, r2, r2, lsl #1
	asrs	r3, r2, #2
.L1139:
.L1117:
	mov	r8, #0
	str	r3, [sp, #12]
	mov	r6, r8
.L1127:
	mov	r0, r5
	mov	r10, #0
	bl	NandcWaitFlashReady
	ldr	r3, .L1140+8
	mov	r4, #-1
	ldr	r2, [r3, r5, lsl #3]
	add	r3, r3, r5, lsl #3
	ldrb	fp, [r3, #4]	@ zero_extendqisi2
	str	r2, [sp, #24]
	lsl	r3, fp, #8
	str	r3, [sp, #32]
.L1118:
	ldr	r3, .L1140+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r10, r3
	bcc	.L1122
.L1121:
	ldr	r3, [sp, #24]
	movs	r0, #200
	add	fp, r3, fp, lsl #8
	movs	r3, #239
	str	r3, [fp, #2056]
	movs	r3, #137
	str	r3, [fp, #2052]
	bl	udelay
	ldr	r3, [sp, #12]
	str	r6, [fp, #2048]
	str	r6, [fp, #2048]
	cmp	r4, r3
	str	r6, [fp, #2048]
	str	r6, [fp, #2048]
	bcc	.L1123
	adds	r1, r4, #1
	mov	r3, r10
	it	ne
	movne	r4, #256
	ldr	r2, [sp, #28]
	str	r4, [sp]
	mov	r1, r10
	ldr	r0, .L1140+16
	bl	printf
	cmp	r8, #0
	bne	.L1125
	ldr	r3, .L1140+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1115
	adds	r2, r4, #1
	bne	.L1115
	movs	r1, #3
	mov	r0, r5
	bl	micron_auto_read_calibration_config
	mov	r8, #1
	b	.L1127
.L1116:
	ldr	r3, .L1140+20
	smull	r2, r3, r2, r3
	b	.L1139
.L1122:
	ldr	r2, [sp, #32]
	movs	r0, #200
	ldr	r3, [sp, #24]
	add	r3, r3, r2
	movs	r2, #239
	str	r2, [r3, #2056]
	movs	r2, #137
	str	r2, [r3, #2052]
	str	r3, [sp, #36]
	bl	udelay
	add	r3, r10, #1
	ldr	r1, [sp, #28]
	mov	r2, r3
	str	r3, [sp, #20]
	ldr	r3, [sp, #36]
	mov	r0, r5
	str	r2, [r3, #2048]
	str	r6, [r3, #2048]
	ldr	r2, [sp, #16]
	str	r6, [r3, #2048]
	str	r6, [r3, #2048]
	mov	r3, r7
	bl	FlashReadRawPage
	adds	r3, r0, #1
	beq	.L1119
	ldr	r3, [sp, #12]
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	cmp	r0, r3
	bcc	.L1129
	movs	r7, #0
	str	r7, [sp, #16]
.L1119:
	ldr	r10, [sp, #20]
	b	.L1118
.L1129:
	movs	r7, #0
	mov	r4, r0
	str	r7, [sp, #16]
	b	.L1121
.L1125:
	movs	r1, #0
	mov	r0, r5
	bl	micron_auto_read_calibration_config
	adds	r3, r4, #1
	it	ne
	movne	r4, #256
.L1115:
	mov	r0, r4
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1123:
	cmp	r8, #0
	beq	.L1115
	movs	r1, #0
	mov	r0, r5
	bl	micron_auto_read_calibration_config
	mov	r4, #256
	b	.L1115
.L1141:
	.align	2
.L1140:
	.word	.LANCHOR33
	.word	.LANCHOR15
	.word	.LANCHOR0
	.word	.LANCHOR151
	.word	.LC13
	.word	1431655766
	.size	MicronReadRetrial, .-MicronReadRetrial
	.section	.text.HynixReadRetrial,"ax",%progbits
	.align	1
	.global	HynixReadRetrial
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	HynixReadRetrial, %function
HynixReadRetrial:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r3
	ldr	r4, .L1159
	mov	r8, #0
	mov	r6, #-1
	mov	fp, r2
	mov	r7, r0
	str	r1, [sp, #4]
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	adds	r2, r4, r0
	ldrb	r5, [r2, #12]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L1159+4
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #7
	cmp	r3, #1
	it	ls
	ldrbls	r5, [r2, #20]	@ zero_extendqisi2
	bl	NandcWaitFlashReady
.L1144:
	ldr	r3, [sp]
	cmp	r8, r3
	bcc	.L1149
.L1148:
	ldr	r3, .L1159+4
	add	r4, r4, r7
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #7
	cmp	r3, #1
	ldr	r3, .L1159+8
	ite	ls
	strbls	r5, [r4, #20]
	strbhi	r5, [r4, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r6, r3, asr #2
	bcc	.L1142
	adds	r3, r6, #1
	it	ne
	movne	r6, #256
.L1142:
	mov	r0, r6
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1149:
	ldr	r3, [sp]
	adds	r5, r5, #1
	uxtb	r5, r5
	ldr	r2, .L1159+12
	ldrb	r1, [r4, #1]	@ zero_extendqisi2
	mov	r0, r7
	cmp	r3, r5
	it	ls
	movls	r5, #0
	mov	r3, r5
	bl	HynixSetRRPara
	mov	r2, fp
	mov	r3, r10
	ldr	r1, [sp, #4]
	mov	r0, r7
	bl	FlashReadRawPage
	adds	r2, r0, #1
	beq	.L1146
	ldr	r3, .L1159+8
	cmp	r6, #-1
	it	eq
	moveq	r6, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1153
	mov	r10, #0
	mov	fp, r10
.L1146:
	add	r8, r8, #1
	b	.L1144
.L1153:
	mov	r6, r0
	b	.L1148
.L1160:
	.align	2
.L1159:
	.word	.LANCHOR20
	.word	.LANCHOR18
	.word	.LANCHOR33
	.word	.LANCHOR20+4
	.size	HynixReadRetrial, .-HynixReadRetrial
	.section	.text.FlashProgPage,"ax",%progbits
	.align	1
	.global	FlashProgPage
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashProgPage, %function
FlashProgPage:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r8, r3
	ldr	r3, .L1164
	mov	r5, r1
	mov	r7, r2
	mov	r4, r0
	ldrb	r6, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L1162
	ldr	r3, .L1164+4
	ldr	r2, .L1164+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r1, [r2]
	muls	r1, r3, r1
	cmp	r1, r5
	bls	.L1162
	ldr	r3, .L1164+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1163
	subs	r6, r6, #2
.L1162:
	mov	r0, r4
	bl	NandcWaitFlashReady
	mov	r0, r4
	bl	NandcFlashCs
	mov	r1, r5
	mov	r0, r4
	bl	FlashProgFirstCmd
	mov	r3, r7
	uxtb	r2, r6
	str	r8, [sp]
	movs	r1, #1
	mov	r0, r4
	bl	NandcXferData
	mov	r1, r5
	mov	r0, r4
	bl	FlashProgSecondCmd
	mov	r0, r4
	bl	NandcWaitFlashReady
	mov	r1, r5
	mov	r0, r4
	bl	FlashReadStatus
	mov	r1, r0
	mov	r0, r4
	bl	NandcFlashDeCs
	and	r0, r1, #1
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1163:
	movs	r6, #4
	b	.L1162
.L1165:
	.align	2
.L1164:
	.word	.LANCHOR31
	.word	.LANCHOR3
	.word	.LANCHOR4
	.word	.LANCHOR2
	.size	FlashProgPage, .-FlashProgPage
	.section	.text.FlashSavePhyInfo,"ax",%progbits
	.align	1
	.global	FlashSavePhyInfo
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashSavePhyInfo, %function
FlashSavePhyInfo:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r7, .L1175
	ldr	r4, .L1175+4
	ldr	r3, [r7]
	ldr	r10, .L1175+56
	ldr	fp, .L1175+60
	str	r3, [r4]
	ldr	r3, .L1175+8
	ldr	r8, .L1175+64
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	FlashBchSel
	mov	r2, #2048
	movs	r1, #0
	ldr	r0, [r7]
	bl	ftl_memset
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r3, .L1175+12
	ldr	r1, .L1175+16
	str	r10, [r0]
	adds	r0, r0, #16
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r0, #-4]	@ movhi
	ldr	r3, .L1175+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r0, #-2]	@ movhi
	ldr	r3, .L1175+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r0, #1060]
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #8
	ldr	r1, .L1175+28
	adds	r0, r0, #80
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1175+32
	adds	r0, r0, #96
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1175+36
	adds	r0, r0, #160
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1175+40
	adds	r0, r0, #192
	bl	ftl_memcpy
	ldr	r0, [r4]
	mov	r2, #852
	ldr	r1, .L1175+44
	adds	r0, r0, #224
	bl	ftl_memcpy
	ldr	r5, [r4]
	movw	r1, #2036
	add	r0, r5, #12
	bl	js_hash
	mov	r3, #1592
	str	r0, [r5, #8]
	str	r3, [r5, #4]
	movs	r5, #0
	ldr	r3, [fp]
	mov	r6, r5
	movs	r0, #0
	str	r3, [r4]
	bl	flash_enter_slc_mode
.L1169:
	ldr	r1, [r8]
	movs	r2, #0
	mov	r0, r2
	muls	r1, r6, r1
	bl	FlashEraseBlock
	ldr	r1, [r8]
	movs	r3, #0
	ldr	r2, [r7]
	mov	r0, r3
	muls	r1, r6, r1
	bl	FlashProgPage
	ldr	r1, [r8]
	movs	r3, #0
	ldr	r2, [r7]
	mov	r0, r3
	muls	r1, r6, r1
	adds	r1, r1, #1
	bl	FlashProgPage
	ldr	r1, [r8]
	movs	r3, #0
	ldr	r2, [fp]
	mov	r0, r3
	muls	r1, r6, r1
	bl	FlashReadRawPage
	adds	r0, r0, #1
	add	r2, r6, #1
	beq	.L1167
	ldr	r3, [r4]
	ldr	r1, [r3]
	cmp	r1, r10
	bne	.L1167
	add	r0, r3, #12
	movw	r1, #2036
	str	r2, [sp, #4]
	str	r3, [sp]
	bl	js_hash
	ldr	r3, [sp]
	ldr	r2, [sp, #4]
	ldr	r3, [r3, #8]
	cmp	r3, r0
	bne	.L1167
	ldr	r3, .L1175+48
	cmp	r5, #1
	str	r2, [r3]
	ldr	r3, [r8]
	mul	r6, r6, r3
	ldr	r3, .L1175+52
	str	r6, [r3]
	beq	.L1170
	movs	r5, #1
.L1167:
	cmp	r2, #4
	mov	r6, r2
	bne	.L1169
.L1168:
	movs	r0, #0
	bl	flash_exit_slc_mode
	clz	r0, r5
	lsrs	r0, r0, #5
	negs	r0, r0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1170:
	movs	r5, #2
	b	.L1168
.L1176:
	.align	2
.L1175:
	.word	.LANCHOR147
	.word	.LANCHOR146
	.word	.LANCHOR152
	.word	.LANCHOR25
	.word	.LANCHOR22
	.word	.LANCHOR3
	.word	.LANCHOR30
	.word	.LANCHOR26
	.word	.LANCHOR17
	.word	.LANCHOR31
	.word	.LANCHOR7
	.word	.LANCHOR20
	.word	.LANCHOR149
	.word	.LANCHOR148
	.word	1312902724
	.word	.LANCHOR153
	.word	.LANCHOR4
	.size	FlashSavePhyInfo, .-FlashSavePhyInfo
	.section	.text.FlashReadIdbDataRaw,"ax",%progbits
	.align	1
	.global	FlashReadIdbDataRaw
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadIdbDataRaw, %function
FlashReadIdbDataRaw:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r3, #60
	strb	r3, [sp, #12]
	movs	r3, #40
	mov	r10, r0
	strb	r3, [sp, #13]
	movs	r3, #24
	strb	r3, [sp, #14]
	movs	r3, #16
	strb	r3, [sp, #15]
	ldr	r3, .L1195
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L1195+4
	ldr	r2, [r3]
	str	r3, [sp, #4]
	cbz	r2, .L1178
	movs	r0, #0
	bl	flash_enter_slc_mode
.L1178:
	mov	r7, #-1
	movs	r4, #2
	mov	r2, #2048
	movs	r1, #0
	mov	r0, r10
	bl	ftl_memset
.L1179:
	ldr	r3, .L1195+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L1184
.L1183:
	ldr	r0, [sp]
	bl	FlashBchSel
	ldr	r3, [sp, #4]
	ldr	r3, [r3]
	cbz	r3, .L1177
	movs	r0, #0
	bl	flash_exit_slc_mode
.L1177:
	mov	r0, r7
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1184:
	ldr	r5, .L1195+12
	movs	r6, #0
	ldr	fp, .L1195+28
.L1181:
	add	r3, sp, #12
	ldrb	r8, [r6, r3]	@ zero_extendqisi2
	mov	r0, r8
	bl	FlashBchSel
	ldr	r1, [fp]
	movs	r3, #0
	ldr	r2, [r5]
	mov	r0, r3
	muls	r1, r4, r1
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L1180
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L1181
.L1182:
	adds	r4, r4, #1
	b	.L1179
.L1187:
	movs	r7, #0
	b	.L1183
.L1180:
	ldr	r3, [r5]
	ldr	r2, [r3]
	ldr	r3, .L1195+16
	cmp	r2, r3
	bne	.L1182
	mov	r1, r8
	ldr	r0, .L1195+20
	bl	printf
	mov	r2, #2048
	ldr	r1, [r5]
	mov	r0, r10
	bl	ftl_memcpy
	ldr	r3, [r5]
	ldr	r2, .L1195+8
	ldr	r3, [r3, #512]
	strb	r3, [r2]
	ldr	r3, .L1195+24
	ldr	r2, [r3]
	cmp	r4, r2
	bcs	.L1187
	str	r4, [r3]
	movs	r7, #0
	bl	FlashSavePhyInfo
	b	.L1182
.L1196:
	.align	2
.L1195:
	.word	.LANCHOR33
	.word	.LANCHOR29
	.word	.LANCHOR3
	.word	.LANCHOR147
	.word	-52655045
	.word	.LC14
	.word	.LANCHOR149
	.word	.LANCHOR4
	.size	FlashReadIdbDataRaw, .-FlashReadIdbDataRaw
	.section	.text.FlashPageProgMsbFFData,"ax",%progbits
	.align	1
	.global	FlashPageProgMsbFFData
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashPageProgMsbFFData, %function
FlashPageProgMsbFFData:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1213
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	mov	r8, r1
	mov	r4, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1198
	ldr	r3, .L1213+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L1197
.L1198:
	ldr	r5, .L1213+8
	ldr	r3, [r5]
	ldrb	r6, [r3, #19]	@ zero_extendqisi2
	subs	r3, r6, #5
	uxtb	r3, r3
	cmp	r3, #30
	bhi	.L1199
	ldr	r2, .L1213+12
	lsr	r3, r2, r3
	lsls	r3, r3, #31
	bmi	.L1201
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1204:
	ldrh	r2, [fp, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1197
	cmp	r6, #8
	mov	r2, #32768
	ite	eq
	moveq	r1, #0
	movne	r1, #255
	ldr	r0, [r10]
	bl	ftl_memset
	ldr	r3, [r10]
	add	r1, r4, r8
	adds	r4, r4, #1
	mov	r0, r7
	uxth	r4, r4
	mov	r2, r3
	bl	FlashProgPage
.L1205:
	ldr	r3, [r5]
	ldrh	r3, [r3, #10]
	cmp	r3, r4
	bhi	.L1204
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1199:
	cmp	r6, #68
	bne	.L1197
.L1201:
	ldr	fp, .L1213+16
	ldr	r10, .L1213+20
	b	.L1205
.L1197:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1214:
	.align	2
.L1213:
	.word	.LANCHOR15
	.word	.LANCHOR29
	.word	.LANCHOR18
	.word	1073758223
	.word	.LANCHOR120
	.word	.LANCHOR153
	.size	FlashPageProgMsbFFData, .-FlashPageProgMsbFFData
	.section	.text.idb_write_data,"ax",%progbits
	.align	1
	.global	idb_write_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	idb_write_data, %function
idb_write_data:
	@ args = 0, pretend = 0, frame = 96
	@ frame_needed = 0, uses_anonymous_args = 0
	mov	r0, r1
	mov	r1, r2
	adds	r2, r0, r3
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	cmp	r2, #63
	sub	sp, sp, #104
	bls	.L1216
	cmp	r0, #576
	bcs	.L1217
	ldr	r2, .L1268
	cmp	r0, #64
	mov	r4, #1
	str	r4, [r2]
	bhi	.L1218
	rsb	r0, r0, #64
	subs	r2, r3, r0
	add	r1, r1, r0, lsl #9
	ldr	r0, .L1268+4
	lsls	r2, r2, #9
.L1267:
	bl	ftl_memcpy
.L1256:
	movs	r0, #0
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1218:
	rsb	r2, r0, #576
	subs	r0, r0, #64
	cmp	r2, r3
	it	cs
	movcs	r2, r3
	ldr	r3, .L1268+4
	lsls	r2, r2, #9
	add	r0, r3, r0, lsl #9
	b	.L1267
.L1216:
	cmp	r0, #576
	bcc	.L1256
.L1217:
	ldr	r3, .L1268
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L1256
	ldr	r3, .L1268+8
	ldr	r2, [r3]
	ldrb	r3, [r2, #9]	@ zero_extendqisi2
	ldrh	r2, [r2, #10]
	smulbb	r3, r3, r2
	uxth	r3, r3
	mov	r1, r3
	addw	r0, r3, #511
	str	r3, [sp, #8]
	bl	__aeabi_uidiv
	ldr	r1, .L1268+4
	movs	r3, #0
	str	r0, [sp, #20]
	movw	r2, #65535
	mov	r0, r1
.L1222:
	ldr	r4, [r1, r2, lsl #2]
	cbnz	r4, .L1220
	ldr	r4, [r1, r3, lsl #2]
	adds	r3, r3, #1
	cmp	r3, #4096
	it	hi
	movhi	r3, #0
	str	r4, [r1, r2, lsl #2]
	subs	r2, r2, #1
	cmp	r2, #4096
	bne	.L1222
.L1220:
	ldr	r1, [r0, r2, lsl #2]
	mov	r3, #512
	ldr	r0, .L1268+12
	bl	printf
	ldr	r3, .L1268+16
	ldr	r2, [sp, #8]
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, [sp, #20]
	muls	r3, r2, r3
	str	r3, [sp, #36]
	ldr	r3, [sp, #16]
	mul	r4, r3, r2
	movs	r3, #0
	str	r3, [sp, #12]
.L1223:
	ldr	r3, [sp, #16]
	cmp	r3, #15
	bls	.L1240
	ldr	r3, [sp, #12]
	cbnz	r3, .L1242
	mov	r1, r3
	ldr	r0, .L1268+20
	bl	printf
.L1242:
	ldr	r3, .L1268
	movs	r2, #0
	str	r2, [r3]
	b	.L1256
.L1269:
	.align	2
.L1268:
	.word	.LANCHOR154
	.word	idb_buf
	.word	.LANCHOR18
	.word	.LC15
	.word	.LANCHOR149
	.word	.LC17
.L1240:
	mov	r2, #512
	movs	r1, #0
	ldr	r0, .L1270
	bl	memset
	ldr	r3, .L1270+4
	mov	r0, r4
	ldr	r3, [r3]
	ldrb	fp, [r3, #9]	@ zero_extendqisi2
	ldrh	r5, [r3, #10]
	bl	FW_FlashBlockErase.constprop.41
	smulbb	r5, r5, fp
	uxth	r5, r5
	cmp	r5, #512
	bcs	.L1224
	adds	r0, r5, r4
	bl	FW_FlashBlockErase.constprop.41
.L1224:
	ldr	r7, .L1270+8
	mov	r1, r5
	ldr	r10, .L1270+36
	mov	r0, r4
	bl	__aeabi_uidivmod
	mov	r6, r1
	subs	r3, r4, r1
	str	r3, [sp, #24]
.L1228:
	lsrs	r2, r6, #2
	beq	.L1225
	ldr	r0, .L1270+12
	adds	r1, r2, #1
	ldr	r3, .L1270+16
	ldrb	r0, [r0]	@ zero_extendqisi2
	ldrh	r3, [r3, r1, lsl #1]
	cbz	r0, .L1226
	ldr	r0, [r10]
	ldr	r5, .L1270+20
	cmp	r0, r5
	it	eq
	moveq	r3, r1
.L1226:
	add	r3, r3, #1073741824
	subs	r3, r3, #1
	lsls	r3, r3, #2
	str	r3, [sp, #40]
.L1225:
	movw	r3, #61424
	str	r3, [sp, #44]
	ldr	r3, .L1270+16
	ldrh	r5, [r3, r2, lsl #1]
	ldr	r3, .L1270+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1227
	ldr	r3, [r10]
	ldr	r1, .L1270+20
	cmp	r3, r1
	it	eq
	moveq	r5, r2
.L1227:
	ldr	r3, [sp, #24]
	adds	r6, r6, #4
	ldr	r2, .L1270+24
	ldr	r8, .L1270+4
	mla	r3, r5, fp, r3
	adds	r5, r5, #1
	uxth	r5, r5
	str	r3, [sp, #32]
	ldrb	r3, [r2]	@ zero_extendqisi2
	ldr	r2, .L1270+28
	str	r3, [sp, #28]
	ldrb	r0, [r2]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r0, #0
	bl	flash_boot_enter_slc_mode
	ldr	r2, [r8]
	ldr	r3, [sp, #32]
	ldrb	r1, [r2, #9]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_uidiv
	add	r3, sp, #40
	mov	r2, r7
	mov	r1, r0
	movs	r0, #0
	bl	FlashProgPage
	movs	r0, #0
	add	r7, r7, #2048
	bl	flash_boot_exit_slc_mode
	ldr	r0, [sp, #28]
	bl	FlashBchSel
	mov	r1, fp
	ldr	r0, [sp, #24]
	bl	__aeabi_uidiv
	mov	r2, r5
	mov	r1, r0
	movs	r0, #0
	bl	FlashPageProgMsbFFData
	ldr	r3, .L1270+32
	cmp	r7, r3
	bne	.L1228
	ldr	r3, [r8]
	mov	r0, r4
	ldr	r7, .L1270
	movs	r6, #0
	ldrb	r8, [r3, #9]	@ zero_extendqisi2
	ldrh	r1, [r3, #10]
	smulbb	r1, r1, r8
	uxth	r1, r1
	bl	__aeabi_uidivmod
	mul	r5, r8, r1
	mov	r10, r1
	subs	r3, r4, r1
	str	r3, [sp, #28]
	ubfx	r5, r5, #2, #2
.L1229:
	cmp	r6, #512
	bcs	.L1236
	ldr	r1, .L1270+12
	rsb	r3, r5, #4
	uxth	r3, r3
	ldr	r2, .L1270+16
	ldrb	r1, [r1]	@ zero_extendqisi2
	str	r3, [sp, #24]
	add	r3, r10, r6
	lsrs	r3, r3, #2
	ldrh	r2, [r2, r3, lsl #1]
	cbz	r1, .L1230
	ldr	r1, .L1270+36
	ldr	r0, .L1270+20
	ldr	r1, [r1]
	cmp	r1, r0
	it	eq
	moveq	r2, r3
.L1230:
	ldr	r3, [sp, #28]
	add	r5, r5, r3
	ldr	r3, .L1270+24
	mla	r5, r2, r8, r5
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #32]
	ldr	r3, .L1270+4
	ldr	r3, [r3]
	ldrb	fp, [r3, #9]	@ zero_extendqisi2
	ldr	r3, .L1270+40
	ldrh	r2, [r3, #26]
	ldr	r3, .L1270+44
	ldr	r3, [r3]
	muls	r3, r2, r3
	mul	r3, fp, r3
	cmp	r5, r3
	bcs	.L1231
	ldr	r3, .L1270+28
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	FlashBchSel
.L1231:
	movs	r0, #0
	bl	flash_boot_enter_slc_mode
	mov	r1, fp
	mov	r0, r5
	bl	__aeabi_uidiv
	add	r3, sp, #40
	mov	r1, r0
	mov	fp, r0
	mov	r2, r7
	movs	r0, #0
	bl	FlashReadPage
	adds	r3, r0, #1
	mov	r5, r0
	bne	.L1232
	ldr	r3, .L1270+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #40
	beq	.L1232
	movs	r0, #40
	bl	FlashBchSel
	add	r3, sp, #40
	mov	r2, r7
	mov	r1, fp
	movs	r0, #0
	bl	FlashReadPage
	mov	r5, r0
.L1232:
	movs	r0, #0
	bl	flash_boot_exit_slc_mode
	ldr	r0, [sp, #32]
	bl	FlashBchSel
	adds	r5, r5, #1
	mov	r5, #-1
	it	ne
	movne	r5, #0
	cbz	r5, .L1233
.L1236:
	ldr	r3, .L1270+8
	movs	r5, #0
	ldr	r6, .L1270
.L1234:
	mov	r7, r3
	ldr	r1, [r6, r5, lsl #2]
	ldr	r2, [r7]
	adds	r3, r3, #4
	cmp	r1, r2
	beq	.L1237
	mov	r2, #512
	movs	r1, #0
	ldr	r0, .L1270
	bl	memset
	str	r5, [sp]
	mov	r1, r4
	ldr	r3, [r7]
	ldr	r2, [r6, r5, lsl #2]
	ldr	r0, .L1270+48
	bl	printf
	mov	r0, r4
	bl	FW_FlashBlockErase.constprop.41
	ldr	r3, [sp, #20]
	cmp	r3, #1
	bls	.L1238
	ldr	r3, [sp, #8]
	adds	r0, r3, r4
	bl	FW_FlashBlockErase.constprop.41
.L1238:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #20]
	add	r3, r3, r2
	str	r3, [sp, #16]
	ldr	r3, [sp, #36]
	add	r4, r4, r3
	b	.L1223
.L1233:
	ldr	r3, [sp, #24]
	add	r6, r6, r3
	add	r7, r7, r3, lsl #9
	uxth	r6, r6
	b	.L1229
.L1237:
	adds	r5, r5, #1
	cmp	r5, #65536
	bne	.L1234
	ldr	r3, [sp, #12]
	adds	r3, r3, #1
	cmp	r3, #5
	str	r3, [sp, #12]
	bls	.L1238
	b	.L1242
.L1271:
	.align	2
.L1270:
	.word	gp_flash_check_buf
	.word	.LANCHOR18
	.word	idb_buf
	.word	.LANCHOR15
	.word	.LANCHOR16
	.word	1446522928
	.word	.LANCHOR33
	.word	.LANCHOR152
	.word	idb_buf+262144
	.word	.LANCHOR119
	.word	.LANCHOR14
	.word	.LANCHOR4
	.word	.LC16
	.size	idb_write_data, .-idb_write_data
	.section	.text.ftl_memcmp,"ax",%progbits
	.align	1
	.global	ftl_memcmp
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_memcmp, %function
ftl_memcmp:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	memcmp
	.size	ftl_memcmp, .-ftl_memcmp
	.section	.text.rknand_get_clk_rate,"ax",%progbits
	.align	1
	.global	rknand_get_clk_rate
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rknand_get_clk_rate, %function
rknand_get_clk_rate:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r0, .L1274
	bx	lr
.L1275:
	.align	2
.L1274:
	.word	148000000
	.size	rknand_get_clk_rate, .-rknand_get_clk_rate
	.section	.text.ftl_malloc,"ax",%progbits
	.align	1
	.global	ftl_malloc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_malloc, %function
ftl_malloc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r1, #0
	b	kmalloc
	.size	ftl_malloc, .-ftl_malloc
	.section	.text.NandcInit,"ax",%progbits
	.align	1
	.global	NandcInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	NandcInit, %function
NandcInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r2, #1
	ldr	r3, .L1279
	movs	r4, #0
	ldr	r5, .L1279+4
	str	r2, [r3, #12]
	movs	r2, #2
	str	r2, [r3, #20]
	movs	r2, #3
	stm	r3, {r0, r4}
	str	r0, [r3, #8]
	str	r0, [r3, #16]
	str	r2, [r3, #28]
	str	r0, [r3, #24]
	ldr	r3, .L1279+8
	ldr	r2, .L1279+12
	str	r0, [r3]
	ldr	r3, [r0]
	and	r3, r3, #253952
	ubfx	r1, r3, #13, #1
	bfi	r3, r4, #13, #1
	str	r1, [r2]
	orr	r3, r3, #256
	ldr	r2, [r0, #352]
	ldr	r1, .L1279+16
	ubfx	r2, r2, #16, #4
	str	r2, [r1]
	ldr	r2, [r0, #352]
	str	r2, [r5]
	movw	r5, #2049
	cmp	r2, r5
	itt	eq
	moveq	r2, #8
	streq	r2, [r1]
	str	r3, [r0]
	movw	r3, #4225
	str	r4, [r0, #336]
	str	r3, [r0, #4]
	movw	r3, #8322
	str	r3, [r0, #344]
	ldr	r3, .L1279+20
	str	r3, [r0, #304]
	mov	r0, #36864
	bl	ftl_malloc
	ldr	r3, .L1279+24
	str	r0, [r3]
	ldr	r3, .L1279+28
	str	r0, [r3]
	add	r0, r0, #32768
	str	r0, [r3, #4]
	str	r4, [r3, #24]
	ldr	r3, .L1279+32
	str	r4, [r3]
	pop	{r3, r4, r5, pc}
.L1280:
	.align	2
.L1279:
	.word	.LANCHOR0
	.word	.LANCHOR119
	.word	.LANCHOR19
	.word	.LANCHOR155
	.word	.LANCHOR34
	.word	1710593
	.word	.LANCHOR156
	.word	.LANCHOR35
	.word	.LANCHOR36
	.size	NandcInit, .-NandcInit
	.section	.text.FtlMemInit,"ax",%progbits
	.align	1
	.global	FtlMemInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlMemInit, %function
FtlMemInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1286
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r2, .L1286+4
	movs	r6, #12
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1286+8
	ldr	r5, .L1286+12
	ldr	r10, .L1286+304
	str	r4, [r3]
	ldr	r3, .L1286+16
	ldr	r8, .L1286+308
	ldr	fp, .L1286+312
	str	r4, [r3]
	ldr	r3, .L1286+20
	str	r4, [r3]
	ldr	r3, .L1286+24
	str	r4, [r3]
	ldr	r3, .L1286+28
	str	r4, [r3]
	ldr	r3, .L1286+32
	str	r4, [r3]
	ldr	r3, .L1286+36
	str	r4, [r3]
	ldr	r3, .L1286+40
	str	r4, [r3]
	ldr	r3, .L1286+44
	str	r4, [r3]
	ldr	r3, .L1286+48
	str	r4, [r3]
	ldr	r3, .L1286+52
	str	r4, [r3]
	ldr	r3, .L1286+56
	str	r4, [r3]
	ldr	r3, .L1286+60
	str	r4, [r3]
	ldr	r3, .L1286+64
	str	r4, [r3]
	ldr	r3, .L1286+68
	str	r4, [r3]
	ldr	r3, .L1286+72
	str	r4, [r3]
	ldr	r3, .L1286+76
	str	r4, [r3]
	movw	r3, #65535
	str	r3, [r2]
	ldr	r2, .L1286+80
	str	r4, [r2]
	ldr	r2, .L1286+84
	str	r4, [r2]
	ldr	r2, .L1286+88
	str	r4, [r2]
	ldr	r2, .L1286+92
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1286+96
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1286+100
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1286+104
	strh	r3, [r2]	@ movhi
	movs	r2, #32
	ldr	r3, .L1286+108
	strh	r2, [r3]	@ movhi
	movs	r2, #128
	ldr	r3, .L1286+112
	strh	r2, [r3]	@ movhi
	ldr	r3, .L1286+116
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1286+120
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1286+124
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1286+128
	strh	r4, [r3]	@ movhi
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1286+132
	str	r0, [r3]
	ldrh	r0, [r5]
	movs	r5, #36
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L1286+136
	str	r0, [r3]
	ldrh	r3, [r10]
	muls	r5, r3, r5
	lsls	r7, r5, #2
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L1286+140
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1286+144
	str	r0, [r3]
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L1286+148
	ldr	r7, .L1286+152
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1286+156
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1286+160
	ldrh	r5, [r7]
	str	r0, [r3]
	ldrh	r3, [r10]
	mov	r0, r5
	lsls	r3, r3, #1
	adds	r3, r3, #1
	str	r3, [r8]
	bl	ftl_malloc
	ldr	r3, .L1286+164
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1286+168
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1286+172
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L1286+176
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1286+180
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1286+184
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L1286+188
	ldrh	r5, [r10]
	ldr	r10, .L1286+316
	str	r0, [r3]
	ldrh	r3, [fp]
	muls	r5, r3, r5
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1286+192
	str	r0, [r3]
	lsls	r0, r5, #2
	ldr	r5, .L1286+196
	bl	ftl_malloc
	ldr	r3, .L1286+200
	str	r0, [r3]
	ldrh	r3, [fp]
	ldr	r0, [r8]
	ldr	r8, .L1286+320
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1286+204
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L1286+208
	str	r0, [r3]
	ldrh	r3, [r8]
	ldr	r0, .L1286+212
	addw	r3, r3, #547
	lsrs	r3, r3, #9
	and	r0, r0, r3, lsl #9
	strh	r3, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L1286+216
	str	r0, [r3]
	adds	r0, r0, #32
	ldr	r3, .L1286+220
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1286+224
	str	r0, [r3]
	ldr	r3, [r10]
	lsl	r8, r3, #1
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L1286+228
	str	r0, [r3]
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L1286+232
	ldr	r8, .L1286+324
	str	r0, [r3]
	ldrh	r0, [r5]
	lsrs	r0, r0, #3
	adds	r0, r0, #4
	bl	ftl_malloc
	ldr	r3, .L1286+236
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1286+240
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1286+244
	str	r0, [r3]
	ldrh	r0, [r8]
	ldr	r8, .L1286+328
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1286+248
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldrh	r2, [r8]
	mov	r1, r4
	ldr	r3, .L1286+252
	lsls	r2, r2, #2
	str	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L1286+256
	ldrh	r4, [r3]
	lsls	r4, r4, #2
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L1286+260
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L1286+264
	ldr	r4, .L1286+268
	str	r0, [r3]
	ldr	r0, [r10]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1286+272
	str	r0, [r3]
	ldrh	r0, [r4]
	muls	r0, r6, r0
	ldr	r6, .L1286+276
	bl	ftl_malloc
	ldr	r3, .L1286+280
	str	r0, [r3]
	ldrh	r3, [r4]
	ldrh	r0, [r7]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1286+284
	str	r0, [r3]
	movs	r0, #6
	ldrh	r3, [r5]
	ldr	r5, .L1286+288
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1286+292
	str	r0, [r3]
	ldr	r3, .L1286+296
	ldrh	r0, [r3]
	ldrh	r3, [r6]
	adds	r0, r0, #31
	asrs	r0, r0, #5
	strh	r0, [r5]	@ movhi
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldrh	r1, [r5]
	movs	r2, #1
	ldr	r3, .L1286+300
	ldrh	r6, [r6]
	lsls	r1, r1, #2
	mov	r4, r3
	str	r0, [r4, #28]!
	b	.L1287
.L1288:
	.align	2
.L1286:
	.word	.LANCHOR139
	.word	.LANCHOR173
	.word	.LANCHOR157
	.word	.LANCHOR54
	.word	.LANCHOR158
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR163
	.word	.LANCHOR164
	.word	.LANCHOR165
	.word	.LANCHOR166
	.word	.LANCHOR167
	.word	.LANCHOR168
	.word	.LANCHOR79
	.word	.LANCHOR169
	.word	.LANCHOR170
	.word	.LANCHOR171
	.word	.LANCHOR172
	.word	.LANCHOR174
	.word	.LANCHOR175
	.word	.LANCHOR73
	.word	.LANCHOR112
	.word	.LANCHOR113
	.word	.LANCHOR114
	.word	.LANCHOR115
	.word	.LANCHOR176
	.word	.LANCHOR177
	.word	.LANCHOR178
	.word	.LANCHOR116
	.word	.LANCHOR179
	.word	.LANCHOR118
	.word	.LANCHOR108
	.word	.LANCHOR111
	.word	.LANCHOR180
	.word	.LANCHOR181
	.word	.LANCHOR182
	.word	.LANCHOR57
	.word	.LANCHOR77
	.word	.LANCHOR106
	.word	.LANCHOR183
	.word	.LANCHOR184
	.word	.LANCHOR185
	.word	.LANCHOR104
	.word	.LANCHOR186
	.word	.LANCHOR187
	.word	.LANCHOR103
	.word	.LANCHOR188
	.word	.LANCHOR41
	.word	.LANCHOR189
	.word	.LANCHOR105
	.word	.LANCHOR137
	.word	33553920
	.word	.LANCHOR191
	.word	.LANCHOR78
	.word	.LANCHOR83
	.word	.LANCHOR129
	.word	.LANCHOR125
	.word	.LANCHOR1
	.word	.LANCHOR71
	.word	.LANCHOR192
	.word	.LANCHOR193
	.word	.LANCHOR194
	.word	.LANCHOR66
	.word	.LANCHOR131
	.word	.LANCHOR195
	.word	.LANCHOR67
	.word	.LANCHOR130
	.word	.LANCHOR45
	.word	.LANCHOR96
	.word	.LANCHOR126
	.word	.LANCHOR123
	.word	.LANCHOR81
	.word	.LANCHOR51
	.word	.LANCHOR74
	.word	.LANCHOR38
	.word	.LANCHOR107
	.word	.LANCHOR58
	.word	.LANCHOR64
	.word	.LANCHOR190
	.word	.LANCHOR61
	.word	.LANCHOR62
.L1287:
	mov	r0, r1
.L1282:
	cmp	r2, r6
	bcc	.L1283
	add	r3, r3, r2, lsl #2
	ldr	r2, .L1289
	movs	r1, #0
	adds	r3, r3, #24
.L1284:
	cmp	r3, r2
	bne	.L1285
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1283:
	ldr	r5, [r3, #28]
	adds	r2, r2, #1
	add	r5, r5, r0
	add	r0, r0, r1
	str	r5, [r4, #4]!
	b	.L1282
.L1285:
	str	r1, [r3, #4]!
	b	.L1284
.L1290:
	.align	2
.L1289:
	.word	.LANCHOR74+56
	.size	FtlMemInit, .-FtlMemInit
	.section	.text.ftl_free,"ax",%progbits
	.align	1
	.global	ftl_free
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_free, %function
ftl_free:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	free
	.size	ftl_free, .-ftl_free
	.section	.text.StorageSysDataLoad,"ax",%progbits
	.align	1
	.global	StorageSysDataLoad
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	StorageSysDataLoad, %function
StorageSysDataLoad:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r4, r1
	mov	r5, r0
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	memset
	mov	r3, r4
	add	r1, r5, #256
	movs	r2, #1
	movs	r0, #16
	pop	{r4, r5, r6, lr}
	b	FtlRead
	.size	StorageSysDataLoad, .-StorageSysDataLoad
	.section	.text.FlashBootVendorRead,"ax",%progbits
	.align	1
	.global	FlashBootVendorRead
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashBootVendorRead, %function
FlashBootVendorRead:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r2
	mov	r1, r0
	movs	r2, #1
	movs	r0, #16
	b	FtlRead
	.size	FlashBootVendorRead, .-FlashBootVendorRead
	.section	.text.FlashCs123Init,"ax",%progbits
	.align	1
	.global	FlashCs123Init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashCs123Init, %function
FlashCs123Init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	FlashCs123Init, .-FlashCs123Init
	.section	.text.rk_nand_de_init,"ax",%progbits
	.align	1
	.global	rk_nand_de_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_nand_de_init, %function
rk_nand_de_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	FlashDeInit
	.size	rk_nand_de_init, .-rk_nand_de_init
	.section	.text.rk_ftl_get_capacity,"ax",%progbits
	.align	1
	.global	rk_ftl_get_capacity
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_ftl_get_capacity, %function
rk_ftl_get_capacity:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L1297
	ldr	r0, [r3]
	bx	lr
.L1298:
	.align	2
.L1297:
	.word	.LANCHOR68
	.size	rk_ftl_get_capacity, .-rk_ftl_get_capacity
	.section	.text.rknand_print_hex,"ax",%progbits
	.align	1
	.global	rknand_print_hex
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rknand_print_hex, %function
rknand_print_hex:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r5, #0
	ldr	r7, .L1308
	mov	fp, r0
	mov	r6, r1
	mov	r8, r2
	mov	r10, r3
	mov	r4, r5
.L1300:
	cmp	r4, r10
	bne	.L1306
	ldr	r1, .L1308+4
	ldr	r0, .L1308+8
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L1306:
	cbnz	r5, .L1301
	mov	r2, r4
	mov	r1, fp
	ldr	r0, .L1308+12
	bl	printf
.L1301:
	cmp	r8, #4
	bne	.L1302
	ldr	r1, [r6, r4, lsl #2]
.L1307:
	mov	r0, r7
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L1305
	movs	r5, #0
	ldr	r1, .L1308+4
	ldr	r0, .L1308+8
	bl	printf
.L1305:
	adds	r4, r4, #1
	b	.L1300
.L1302:
	cmp	r8, #2
	ite	eq
	ldrsheq	r1, [r6, r4, lsl #1]
	ldrbne	r1, [r6, r4]	@ zero_extendqisi2
	b	.L1307
.L1309:
	.align	2
.L1308:
	.word	.LC19
	.word	.LC20
	.word	.LC7
	.word	.LC18
	.size	rknand_print_hex, .-rknand_print_hex
	.section	.text.HynixGetReadRetryDefault,"ax",%progbits
	.align	1
	.global	HynixGetReadRetryDefault
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	HynixGetReadRetryDefault, %function
HynixGetReadRetryDefault:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r3, #172
	ldr	r5, .L1428
	cmp	r0, #2
	mov	r1, #173
	mov	r2, #174
	sub	sp, sp, #56
	mov	r4, r0
	strb	r3, [r5, #4]
	mov	r3, #175
	strb	r0, [r5]
	strb	r1, [r5, #5]
	strb	r2, [r5, #6]
	strb	r3, [r5, #7]
	bne	.L1311
	movs	r3, #167
	mov	fp, #7
	strb	r3, [r5, #4]
	movs	r2, #247
	ldr	r3, .L1428+4
	strb	r2, [r3, #17]
.L1421:
	mov	r10, #4
	b	.L1312
.L1311:
	cmp	r0, #3
	bne	.L1313
	movs	r3, #176
	strb	r3, [r5, #4]
	movs	r3, #177
	strb	r3, [r5, #5]
	movs	r3, #178
	strb	r3, [r5, #6]
	movs	r3, #179
	strb	r3, [r5, #7]
	movs	r3, #180
	strb	r3, [r5, #8]
	movs	r3, #181
	strb	r3, [r5, #9]
	movs	r3, #182
	strb	r3, [r5, #10]
	movs	r3, #183
.L1422:
	mov	fp, #8
	strb	r3, [r5, #11]
	mov	r10, fp
.L1312:
	subs	r3, r4, #1
	cmp	r3, #1
	bhi	.L1318
	mov	r8, #0
.L1319:
	ldr	r3, .L1428+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxtb	r3, r8
	cmp	r2, r3
	bhi	.L1325
.L1326:
	ldr	r3, .L1428
	strb	r10, [r3, #1]
	strb	fp, [r3, #2]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1313:
	cmp	r0, #4
	bne	.L1314
	movs	r0, #204
	strb	r1, [r5, #9]
	strb	r0, [r5, #4]
	movs	r0, #191
	strb	r0, [r5, #5]
	movs	r0, #170
	strb	r0, [r5, #6]
	movs	r0, #171
	strb	r0, [r5, #7]
	movs	r0, #205
	strb	r0, [r5, #8]
	strb	r2, [r5, #10]
	b	.L1422
.L1314:
	cmp	r0, #5
	bne	.L1315
	movs	r3, #56
	mov	fp, #8
	strb	r3, [r5, #4]
	movs	r3, #57
	strb	r3, [r5, #5]
	movs	r3, #58
	strb	r3, [r5, #6]
	movs	r3, #59
	strb	r3, [r5, #7]
	b	.L1421
.L1315:
	cmp	r0, #6
	bne	.L1316
	movs	r3, #14
	mov	fp, #12
	strb	r3, [r5, #4]
	movs	r3, #15
	strb	r3, [r5, #5]
	movs	r3, #16
	strb	r3, [r5, #6]
	movs	r3, #17
	strb	r3, [r5, #7]
	b	.L1421
.L1316:
	cmp	r0, #7
	bne	.L1317
	movs	r3, #176
	mov	fp, #12
	strb	r3, [r5, #4]
	movs	r3, #177
	strb	r3, [r5, #5]
	movs	r3, #178
	strb	r3, [r5, #6]
	movs	r3, #179
	strb	r3, [r5, #7]
	movs	r3, #180
	strb	r3, [r5, #8]
	movs	r3, #181
	strb	r3, [r5, #9]
	movs	r3, #182
	strb	r3, [r5, #10]
	movs	r3, #183
	strb	r3, [r5, #11]
	movs	r3, #212
	strb	r3, [r5, #12]
	movs	r3, #213
	strb	r3, [r5, #13]
	mov	r10, #10
	b	.L1312
.L1317:
	cmp	r0, #8
	mov	r3, #7
	bne	.L1376
	strb	r3, [r5, #5]
	movs	r3, #9
	movs	r2, #6
	strb	r3, [r5, #7]
	movs	r3, #10
	strb	r2, [r5, #4]
	strb	r0, [r5, #6]
	mov	fp, #50
	strb	r3, [r5, #8]
	mov	r10, #5
	b	.L1312
.L1376:
	mov	fp, r3
	b	.L1421
.L1325:
	ldr	r2, .L1428+12
	movs	r6, #0
	ldrb	r2, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1428+16
	ldr	r7, [r3, r2, lsl #3]
	add	r4, r5, r2, lsl #6
	add	r3, r3, r2, lsl #3
	movs	r2, #55
	adds	r4, r4, #20
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r7, r7, r3, lsl #8
	addw	r3, r7, #2056
.L1320:
	adds	r1, r5, r6
	str	r2, [r3]
	ldrb	r1, [r1, #4]	@ zero_extendqisi2
	movs	r0, #80
	str	r2, [sp, #4]
	str	r3, [sp]
	str	r1, [r7, #2052]
	bl	udelay
	ldr	r1, [r7, #2048]
	ldr	r3, [sp]
	ldr	r2, [sp, #4]
	strb	r1, [r4, r6]
	adds	r6, r6, #1
	uxtb	r1, r6
	cmp	r10, r1
	bhi	.L1320
	ldr	r7, .L1428+4
	mov	r1, r4
	movs	r2, #0
.L1323:
	movs	r3, #1
	adds	r6, r7, r2
.L1322:
	ldrb	r0, [r6, r3, lsl #2]	@ zero_extendqisi2
	ldrb	ip, [r1]	@ zero_extendqisi2
	add	r0, r0, ip
	strb	r0, [r1, r3, lsl #3]
	adds	r3, r3, #1
	cmp	r3, #7
	bne	.L1322
	adds	r2, r2, #1
	adds	r1, r1, #1
	cmp	r2, #4
	bne	.L1323
	movs	r3, #0
	add	r8, r8, #1
	strb	r3, [r4, #16]
	strb	r3, [r4, #24]
	strb	r3, [r4, #32]
	strb	r3, [r4, #40]
	strb	r3, [r4, #48]
	strb	r3, [r4, #41]
	strb	r3, [r4, #49]
	b	.L1319
.L1318:
	subs	r3, r4, #3
	cmp	r3, #5
	bhi	.L1326
	smulbb	r3, fp, r10
	asrs	r2, r3, #1
	lsls	r3, r3, #4
	str	r3, [sp, #48]
	lsls	r3, r2, #2
	str	r2, [sp, #12]
	str	r3, [sp, #44]
	lsls	r3, r2, #1
	str	r3, [sp, #32]
	movs	r3, #0
.L1427:
	str	r3, [sp, #28]
	ldrb	r3, [sp, #28]	@ zero_extendqisi2
	str	r3, [sp, #16]
	ldr	r3, .L1428+8
	ldr	r2, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L1326
	ldr	r2, [sp, #16]
	ldr	r3, .L1428+12
	ldrb	r8, [r3, r2]	@ zero_extendqisi2
	ldr	r3, .L1428+16
	mov	r0, r8
	ldr	r2, [r3, r8, lsl #3]
	add	r3, r3, r8, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	str	r2, [sp]
	str	r3, [sp, #4]
	mov	r3, r2
	ldr	r2, [sp, #4]
	add	r5, r3, r2, lsl #8
	movs	r3, #255
	str	r3, [r5, #2056]
	bl	NandcWaitFlashReady
	cmp	r4, #7
	bne	.L1328
	ldr	r3, .L1428
	movs	r0, #160
	mla	r0, r0, r8, r3
	add	r3, r0, #28
.L1423:
	ldr	r2, [sp, #4]
	cmp	r4, #4
	str	r3, [sp, #20]
	ldr	r3, [sp]
	add	r3, r3, r2, lsl #8
	mov	r2, #54
	str	r2, [r3, #2056]
	bne	.L1331
	movs	r2, #255
	str	r2, [r3, #2052]
	movs	r2, #64
	str	r2, [r3, #2048]
	movs	r2, #204
.L1424:
	str	r2, [r3, #2052]
	movs	r2, #77
	b	.L1425
.L1328:
	cmp	r4, #8
	beq	.L1330
	ldr	r0, .L1428
	add	r0, r0, r8, lsl #6
	add	r3, r0, #20
	b	.L1423
.L1429:
	.align	2
.L1428:
	.word	.LANCHOR20
	.word	.LANCHOR196
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR0
.L1331:
	subs	r2, r4, #5
	cmp	r2, #1
	bhi	.L1333
	ldr	r2, .L1430
	ldrb	r2, [r2, #4]	@ zero_extendqisi2
	str	r2, [r3, #2052]
	movs	r2, #82
.L1425:
	str	r2, [r3, #2048]
.L1332:
	ldr	r2, [sp, #4]
	cmp	r4, #6
	ldr	r3, [sp]
	add	r3, r3, r2, lsl #8
	mov	r2, #22
	str	r2, [r3, #2056]
	mov	r2, #23
	str	r2, [r3, #2056]
	mov	r2, #4
	str	r2, [r3, #2056]
	mov	r2, #25
	str	r2, [r3, #2056]
	mov	r2, #0
	str	r2, [r3, #2056]
	str	r2, [r3, #2052]
	str	r2, [r3, #2052]
	it	eq
	moveq	r2, #31
	str	r2, [r3, #2052]
	movs	r2, #2
	str	r2, [r3, #2052]
	movs	r2, #0
	str	r2, [r3, #2052]
.L1375:
	ldr	r2, [sp, #4]
	mov	r0, r8
	ldr	r3, [sp]
	add	r3, r3, r2, lsl #8
	movs	r2, #48
	str	r2, [r3, #2056]
	bl	NandcWaitFlashReady
	subs	r3, r4, #5
	cmp	r3, #1
	str	r3, [sp, #36]
	bls	.L1378
	cmp	r4, #8
	beq	.L1378
	cmp	r4, #7
	ite	eq
	moveq	r2, #32
	movne	r2, #2
.L1336:
	ldr	r3, .L1430+4
	subs	r2, r2, #1
	ldm	sp, {r5, r6}
	ldr	r3, [r3]
	add	r5, r5, r6, lsl #8
	subs	r1, r3, #1
	uxtab	r2, r3, r2
	mov	r0, r1
	str	r5, [sp, #8]
.L1337:
	ldr	r5, [sp, #8]
	ldr	r5, [r5, #2048]
	strb	r5, [r0, #1]!
	cmp	r0, r2
	bne	.L1337
	cmp	r4, #8
	bne	.L1338
	movs	r2, #0
.L1340:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #50
	beq	.L1339
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #5
	beq	.L1339
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1340
.L1341:
	movs	r1, #0
	ldr	r0, .L1430+8
	bl	printf
.L1343:
	b	.L1343
.L1333:
	cmp	r4, #7
	bne	.L1332
	movs	r2, #174
	str	r2, [r3, #2052]
	movs	r2, #0
	str	r2, [r3, #2048]
	movs	r2, #176
	b	.L1424
.L1378:
	movs	r2, #16
	b	.L1336
.L1339:
	cmp	r1, #6
	bhi	.L1341
.L1342:
	ldr	r3, .L1430+4
	ldr	r2, [r3]
	mov	r3, r2
.L1352:
	ldr	r0, [sp, #48]
	subs	r1, r3, r2
	cmp	r1, r0
	blt	.L1353
	ldr	r3, .L1430+4
	ldr	r1, [r3]
	ldr	r3, [sp, #32]
	adds	r0, r1, r3
	movs	r3, #8
.L1355:
	mov	r6, r0
	movs	r5, #0
.L1354:
	ldrh	r7, [r6]
	adds	r5, r5, #1
	mvns	r7, r7
	strh	r7, [r6], #2	@ movhi
	ldr	r7, [sp, #12]
	cmp	r7, r5
	bgt	.L1354
	ldr	r5, [sp, #44]
	subs	r3, r3, #1
	add	r0, r0, r5
	bne	.L1355
	mov	r7, r1
	str	r3, [sp, #24]
.L1361:
	movs	r5, #0
	mov	r0, r5
.L1360:
	movs	r3, #1
	mov	ip, #0
	lsl	r6, r3, r0
	movs	r3, #16
	str	r3, [sp, #40]
	mov	lr, r6
	mov	r6, r7
.L1358:
	ldrh	r3, [r6]
	str	r3, [sp, #52]
	ldr	r3, [sp, #52]
	bics	r3, lr, r3
	ldr	r3, [sp, #32]
	it	eq
	addeq	ip, ip, #1
	add	r6, r6, r3
	ldr	r3, [sp, #40]
	subs	r3, r3, #1
	str	r3, [sp, #40]
	bne	.L1358
	cmp	ip, #8
	add	r0, r0, #1
	ittt	hi
	movhi	r3, lr
	orrhi	r5, r5, r3
	uxthhi	r5, r5
	cmp	r0, #16
	bne	.L1360
	ldr	r3, [sp, #24]
	strh	r5, [r7], #2	@ movhi
	adds	r3, r3, #1
	str	r3, [sp, #24]
	ldr	r0, [sp, #24]
	ldr	r3, [sp, #12]
	cmp	r3, r0
	bgt	.L1361
	subs	r0, r1, #4
	add	r5, r1, #28
	movs	r3, #0
.L1364:
	ldr	r6, [r0, #4]!
	cbnz	r6, .L1363
	adds	r3, r3, #1
.L1363:
	cmp	r5, r0
	bne	.L1364
	cmp	r3, #7
	ble	.L1365
	ldr	r0, .L1430+12
	mov	r3, #1024
	movs	r2, #1
	bl	rknand_print_hex
	movs	r1, #0
	ldr	r0, .L1430+8
	bl	printf
.L1366:
	b	.L1366
.L1338:
	cmp	r4, #7
	bne	.L1344
	movs	r2, #0
.L1346:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #12
	beq	.L1345
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #10
	beq	.L1345
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1346
.L1347:
	movs	r1, #0
	ldr	r0, .L1430+8
	bl	printf
.L1348:
	b	.L1348
.L1345:
	cmp	r1, #6
	bls	.L1342
	b	.L1347
.L1344:
	cmp	r4, #6
	bne	.L1342
	adds	r3, r3, #7
.L1349:
	ldrb	r2, [r1, #1]!	@ zero_extendqisi2
	cmp	r2, #12
	beq	.L1342
	ldrb	r2, [r1, #8]	@ zero_extendqisi2
	cmp	r2, #4
	beq	.L1342
	cmp	r1, r3
	bne	.L1349
	movs	r1, #0
	ldr	r0, .L1430+8
	bl	printf
.L1351:
	b	.L1351
.L1353:
	ldr	r1, [sp, #8]
	ldr	r1, [r1, #2048]
	strb	r1, [r3], #1
	b	.L1352
.L1365:
	cmp	r4, #6
	beq	.L1380
	cmp	r4, #7
	beq	.L1381
	cmp	r4, #8
	ite	eq
	moveq	r6, #5
	movne	r6, #8
.L1367:
	add	r3, r10, #-1
	ldr	r0, [sp, #20]
	uxtb	r3, r3
	movs	r5, #0
	adds	r3, r3, #1
.L1368:
	mov	ip, r0
	mov	r1, r2
.L1369:
	ldrb	r7, [r1], #1	@ zero_extendqisi2
	strb	r7, [ip], #1
	subs	r7, r1, r2
	uxtb	r7, r7
	cmp	r10, r7
	bhi	.L1369
	adds	r5, r5, #1
	add	r2, r2, r3
	cmp	fp, r5
	add	r0, r0, r6
	bgt	.L1368
	ldr	r3, [sp]
	mov	r0, r8
	ldr	r2, [sp, #4]
	add	r5, r3, r2, lsl #8
	movs	r3, #255
	str	r3, [r5, #2056]
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #36]
	cmp	r3, #1
	bhi	.L1371
	movs	r3, #54
	ldr	r2, [sp, #8]
	str	r3, [r5, #2056]
	mov	r1, #-1
	ldr	r3, .L1430
	ldr	r0, [sp, #16]
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	str	r3, [r2, #2052]
	movs	r3, #0
	str	r3, [r2, #2048]
	movs	r3, #22
	str	r3, [r5, #2056]
	bl	FlashReadCmd
.L1372:
	mov	r0, r8
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	b	.L1427
.L1380:
	movs	r6, #4
	b	.L1367
.L1381:
	movs	r6, #10
	b	.L1367
.L1371:
	cmp	r4, #8
	ite	eq
	moveq	r3, #190
	movne	r3, #56
	str	r3, [r5, #2056]
	b	.L1372
.L1330:
	movs	r3, #120
	movs	r2, #23
	str	r3, [r5, #2056]
	movs	r3, #0
	str	r3, [r5, #2052]
	movs	r1, #25
	str	r3, [r5, #2052]
	str	r3, [r5, #2052]
	str	r2, [r5, #2056]
	movs	r2, #4
	str	r2, [r5, #2056]
	str	r1, [r5, #2056]
	movs	r1, #218
	str	r1, [r5, #2056]
	movs	r1, #21
	str	r3, [r5, #2056]
	str	r3, [r5, #2052]
	str	r3, [r5, #2052]
	str	r1, [r5, #2052]
	str	r2, [r5, #2052]
	str	r3, [r5, #2052]
	ldr	r3, .L1430+16
	str	r3, [sp, #20]
	b	.L1375
.L1431:
	.align	2
.L1430:
	.word	.LANCHOR20
	.word	.LANCHOR147
	.word	.LC21
	.word	.LC22
	.word	.LANCHOR20+28
	.size	HynixGetReadRetryDefault, .-HynixGetReadRetryDefault
	.section	.text.FlashGetReadRetryDefault,"ax",%progbits
	.align	1
	.global	FlashGetReadRetryDefault
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashGetReadRetryDefault, %function
FlashGetReadRetryDefault:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r0
	cbz	r0, .L1432
	subs	r2, r0, #1
	cmp	r2, #7
	bhi	.L1434
	b	HynixGetReadRetryDefault
.L1434:
	cmp	r0, #49
	bne	.L1435
	ldr	r0, .L1455
	movs	r2, #64
	ldr	r1, .L1455+4
	strb	r3, [r0]
	movs	r3, #4
	strb	r3, [r0, #1]
	movs	r3, #15
	strb	r3, [r0, #2]
.L1453:
	adds	r0, r0, #4
	b	ftl_memcpy
.L1435:
	cmp	r0, #33
	beq	.L1436
	sub	r2, r0, #65
	cmp	r2, #1
	bhi	.L1437
.L1436:
	ldr	r0, .L1455
	strb	r3, [r0]
	movs	r3, #4
.L1454:
	strb	r3, [r0, #1]
	movs	r3, #7
	strb	r3, [r0, #2]
	movs	r2, #45
	ldr	r1, .L1455+8
	b	.L1453
.L1437:
	cmp	r0, #34
	beq	.L1438
	cmp	r0, #67
	bne	.L1439
.L1438:
	ldr	r0, .L1455
	strb	r3, [r0]
	movs	r3, #5
	b	.L1454
.L1439:
	cmp	r0, #35
	beq	.L1440
	cmp	r0, #68
	bne	.L1432
.L1440:
	ldr	r0, .L1455
	movs	r2, #95
	ldr	r1, .L1455+12
	strb	r3, [r0]
	movs	r3, #5
	strb	r3, [r0, #1]
	movs	r3, #17
	strb	r3, [r0, #2]
	b	.L1453
.L1432:
	bx	lr
.L1456:
	.align	2
.L1455:
	.word	.LANCHOR20
	.word	.LANCHOR13
	.word	.LANCHOR8
	.word	.LANCHOR10
	.size	FlashGetReadRetryDefault, .-FlashGetReadRetryDefault
	.section	.text.FlashInit,"ax",%progbits
	.align	1
	.global	FlashInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashInit, %function
FlashInit:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	sub	sp, sp, #40
	mov	r0, #32768
	movs	r5, #0
	bl	ftl_malloc
	ldr	r3, .L1560
	ldr	fp, .L1560+124
	ldr	r10, .L1560+128
	str	r0, [r3]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L1560+4
	ldr	r8, .L1560+132
	ldr	r6, .L1560+8
	str	r0, [r3]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L1560+12
	ldr	r7, .L1560+16
	str	r0, [r3]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L1560+20
	str	r0, [r3]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L1560+24
	ldr	r2, .L1560+28
	strb	r5, [r10]
	str	r0, [r3]
	movs	r3, #50
	strb	r3, [r2]
	movs	r2, #128
	strb	r3, [fp]
	mov	r0, r4
	ldr	r3, .L1560+32
	ldr	r4, .L1560+36
	strb	r5, [r8]
	str	r5, [r3]
	ldr	r3, .L1560+40
	strb	r5, [r7]
	str	r2, [r3]
	ldr	r3, .L1560+44
	str	r5, [r3]
	movs	r3, #60
	strb	r3, [r6]
	bl	NandcInit
	str	r10, [sp, #20]
	ldr	r10, .L1560+136
	str	r8, [sp, #28]
	mov	r8, r6
	mov	r6, r4
	str	fp, [sp, #24]
.L1462:
	add	r1, r10, r5, lsl #3
	uxtb	r2, r5
	ldr	r3, [r10, r5, lsl #3]
	ldrb	r1, [r1, #4]	@ zero_extendqisi2
	mov	fp, r2
	mov	r0, r2
	str	r3, [sp, #36]
	str	r1, [sp, #32]
	bl	FlashReset
	mov	r0, fp
	bl	NandcFlashCs
	ldr	r1, [sp, #32]
	movs	r0, #200
	ldr	r3, [sp, #36]
	add	r3, r3, r1, lsl #8
	movs	r1, #144
	str	r1, [r3, #2056]
	movs	r1, #0
	str	r1, [r3, #2052]
	str	r3, [sp, #32]
	bl	udelay
	ldr	r3, [sp, #32]
	mov	r0, fp
	ldr	r1, [r3, #2048]
	strb	r1, [r4]
	ldr	r1, [r3, #2048]
	strb	r1, [r4, #1]
	ldr	r1, [r3, #2048]
	strb	r1, [r4, #2]
	ldr	r1, [r3, #2048]
	strb	r1, [r4, #3]
	ldr	r1, [r3, #2048]
	strb	r1, [r4, #4]
	ldr	r3, [r3, #2048]
	strb	r3, [r4, #5]
	bl	NandcFlashDeCs
	ldrb	r2, [r4]	@ zero_extendqisi2
	subs	r3, r2, #1
	uxtb	r3, r3
	cmp	r3, #253
	bhi	.L1458
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	ldr	r0, .L1560+48
	str	r1, [sp, #12]
	ldrb	r1, [r4, #4]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r4, #3]	@ zero_extendqisi2
	str	r1, [sp, #4]
	ldrb	r1, [r4, #2]	@ zero_extendqisi2
	str	r1, [sp]
	adds	r1, r5, #1
	bl	printf
.L1458:
	cbnz	r5, .L1459
	ldrb	r3, [r6]	@ zero_extendqisi2
	subs	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #253
	bhi	.L1509
	ldrb	r3, [r6, #1]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L1509
.L1459:
	ldrb	r3, [r4]	@ zero_extendqisi2
	adds	r5, r5, #1
	adds	r4, r4, #8
	cmp	r3, #181
	itt	eq
	moveq	r3, #44
	strbeq	r3, [r4, #-8]
	cmp	r5, #4
	bne	.L1462
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #173
	beq	.L1463
	ldr	r3, .L1560+52
	ldr	r0, [r3]
	bl	NandcSetDdrMode
.L1463:
	mov	r2, #852
	movs	r1, #0
	ldr	r0, .L1560+56
	bl	ftl_memset
	ldr	r4, .L1560+60
	ldr	r3, .L1560+64
	ldr	r5, .L1560+68
	str	r3, [r4]
	movs	r3, #0
	strb	r3, [r5]
	ldr	r3, .L1560+72
	str	r5, [sp, #32]
	ldr	r1, [r3]
	ldr	r3, .L1560+76
	cmp	r1, r3
	mov	r10, r3
	ittt	eq
	ldreq	r3, .L1560+80
	moveq	r2, #1
	streq	r2, [r3]
	ldrb	r3, [r6, #1]	@ zero_extendqisi2
	cmp	r3, #161
	beq	.L1465
	cmp	r3, #241
	beq	.L1465
	cmp	r3, #218
	beq	.L1465
	and	r2, r3, #253
	cmp	r2, #209
	beq	.L1465
	cmp	r3, #220
	bne	.L1466
	ldrb	r2, [r6, #3]	@ zero_extendqisi2
	cmp	r2, #149
	bne	.L1466
.L1465:
	ldr	r2, [sp, #20]
	movs	r0, #1
	ldr	r5, [sp, #24]
	ldrb	ip, [r6]	@ zero_extendqisi2
	strb	r0, [r2]
	movs	r2, #16
	strb	r2, [r5]
	strb	r2, [r8]
	cmp	ip, #152
	ldr	r2, .L1560+84
	strb	ip, [r2, #1]
	strb	r3, [r2, #2]
	bne	.L1468
	ldrsb	ip, [r6, #4]
	cmp	ip, #0
	blt	.L1469
	movs	r0, #24
	strb	r0, [r8]
.L1468:
	cmp	r1, r10
	beq	.L1471
	movw	r0, #2049
	cmp	r1, r0
	bne	.L1472
.L1471:
	movs	r1, #16
	strb	r1, [r8]
.L1472:
	cmp	r3, #218
	bne	.L1473
	mov	r1, #2048
.L1556:
	strh	r1, [r2, #14]	@ movhi
	strb	r3, [r2, #2]
.L1474:
	movs	r2, #32
	ldr	r1, .L1560+88
	ldr	r0, .L1560+92
	bl	ftl_memcpy
	movs	r2, #32
	ldr	r1, .L1560+84
	ldr	r0, .L1560+64
	bl	ftl_memcpy
.L1466:
	ldr	r3, [sp, #20]
	ldr	r8, .L1560+140
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1477
	bl	FlashLoadPhyInfoInRam
	cbnz	r0, .L1479
	ldr	r3, [r4]
	ldr	fp, .L1560+104
	ldrh	r3, [r3, #16]
	lsrs	r3, r3, #8
	lsls	r1, r3, #31
	and	r0, r3, #7
	strb	r0, [fp]
	bmi	.L1479
	movs	r3, #1
	strb	r3, [r7]
	bl	FlashSetInterfaceMode
	ldrb	r0, [fp]	@ zero_extendqisi2
	bl	NandcSetMode
.L1479:
	ldr	r3, [r4]
	ldrb	r3, [r3, #26]	@ zero_extendqisi2
	strb	r3, [r8]
	bl	FlashLoadPhyInfo
	cmp	r0, #0
	beq	.L1477
	ldr	r3, [r4]
	ldr	r0, .L1560+96
	ldrh	r1, [r3, #14]
	bl	printf
	bl	FlashLoadPhyInfoInRam
	adds	r2, r0, #1
	beq	.L1457
	bl	FlashDieInfoInit
	ldr	r3, [r4]
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	bl	FlashGetReadRetryDefault
	ldr	r3, [r4]
	ldr	r2, .L1560+100
	ldrb	r1, [r3, #9]	@ zero_extendqisi2
	ldrh	r2, [r2]
	addw	r2, r2, #4095
	cmp	r1, r2, asr #12
	blt	.L1482
	ldrh	r2, [r3, #14]
	adds	r2, r2, #255
	cmp	r1, r2, asr #8
	bge	.L1483
.L1482:
	ldrh	r2, [r3, #14]
	bic	r2, r2, #255
	strh	r2, [r3, #14]	@ movhi
.L1483:
	ldr	r3, .L1560+104
	ldrb	r3, [r3]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L1484
	bl	FlashSavePhyInfo
	ldr	r3, .L1560+108
	movs	r0, #0
	ldr	r1, [r3]
	bl	FlashDdrParaScan
.L1484:
	bl	FlashSavePhyInfo
.L1477:
	ldr	fp, [r4]
	ldr	r1, [sp, #32]
	ldr	r5, .L1560+112
	ldrh	r2, [fp, #16]
	ldrb	r3, [fp, #26]	@ zero_extendqisi2
	ldrh	r0, [fp, #10]
	strb	r3, [r8]
	ubfx	r3, r2, #7, #1
	strb	r3, [r1]
	ubfx	r1, r2, #3, #1
	ldr	r3, .L1560+116
	strb	r1, [r3]
	ubfx	r1, r2, #4, #1
	ldr	r3, .L1560+120
	ubfx	r2, r2, #8, #3
	strb	r1, [r3]
	ldr	r3, .L1560+104
	ldrb	r1, [fp, #12]	@ zero_extendqisi2
	strb	r2, [r3]
	movs	r2, #0
	str	r2, [r5]
	str	r3, [sp, #28]
	bl	__aeabi_idiv
	mov	r1, r0
	ldrb	r0, [fp, #18]	@ zero_extendqisi2
	bl	BuildFlashLsbPageTable
	b	.L1561
.L1562:
	.align	2
.L1560:
	.word	.LANCHOR147
	.word	.LANCHOR153
	.word	.LANCHOR152
	.word	.LANCHOR197
	.word	.LANCHOR30
	.word	.LANCHOR198
	.word	.LANCHOR199
	.word	.LANCHOR150
	.word	.LANCHOR149
	.word	.LANCHOR22
	.word	.LANCHOR4
	.word	.LANCHOR144
	.word	.LC23
	.word	.LANCHOR155
	.word	.LANCHOR20
	.word	.LANCHOR18
	.word	.LANCHOR31
	.word	.LANCHOR6
	.word	.LANCHOR119
	.word	1446522928
	.word	.LANCHOR29
	.word	.LANCHOR201
	.word	.LANCHOR143+32
	.word	.LANCHOR7
	.word	.LC24
	.word	.LANCHOR122
	.word	.LANCHOR24
	.word	.LANCHOR148
	.word	.LANCHOR145
	.word	.LANCHOR202
	.word	.LANCHOR27
	.word	.LANCHOR3
	.word	.LANCHOR2
	.word	.LANCHOR200
	.word	.LANCHOR0
	.word	.LANCHOR15
.L1561:
	bl	FlashDieInfoInit
	ldr	r2, [r4]
	ldr	r3, [sp, #28]
	ldrh	r1, [r2, #16]
	mov	fp, r3
	tst	r1, #64
	mov	r1, r5
	beq	.L1486
	ldrb	r0, [r2, #19]	@ zero_extendqisi2
	ldr	r3, .L1563
	ldr	ip, .L1563+60
	strb	r0, [r3]
	ldrb	r2, [ip, #1]	@ zero_extendqisi2
	ldr	r3, .L1563+4
	ldrb	ip, [ip, #2]	@ zero_extendqisi2
	strb	r2, [r3]
	ldr	r2, .L1563+8
	strb	ip, [r2]
	add	ip, r0, #-1
	cmp	ip, #7
	mov	ip, r2
	bhi	.L1487
	ldr	r3, .L1563+12
	str	r3, [r5]
	subs	r3, r0, #5
	cmp	r3, #1
	bls	.L1488
	cmp	r0, #8
	bne	.L1489
.L1488:
	ldr	r3, .L1563+16
	movs	r2, #1
	str	r2, [r3]
.L1489:
	cmp	r0, #7
	ldr	r3, .L1563+20
	beq	.L1490
	sub	r2, r3, #8
	cmp	r0, #8
	it	ne
	movne	r3, r2
.L1490:
	subs	r1, r3, #1
	movs	r2, #0
	adds	r3, r3, #31
.L1492:
	ldrsb	r5, [r1, #1]!
	cbnz	r5, .L1491
	adds	r2, r2, #1
.L1491:
	cmp	r3, r1
	bne	.L1492
	cmp	r2, #27
	bls	.L1486
	bl	FlashGetReadRetryDefault
	bl	FlashSavePhyInfo
.L1486:
	ldr	r3, .L1563+24
	ldr	r3, [r3]
	cmp	r3, r10
	bne	.L1503
	ldrb	r3, [r8]	@ zero_extendqisi2
	cbz	r3, .L1503
	ldr	r3, .L1563+28
	movs	r2, #0
	ldr	r3, [r3]
	strb	r2, [r3, #18]
.L1503:
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #44
	bne	.L1504
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbz	r3, .L1504
	movs	r3, #0
	movs	r0, #1
	strb	r3, [r7]
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
.L1504:
	ldrb	r3, [fp]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L1505
	ldrb	r2, [r7]	@ zero_extendqisi2
	cbnz	r2, .L1506
	lsls	r3, r3, #31
	bmi	.L1505
.L1506:
	movs	r0, #0
	bl	flash_enter_slc_mode
	ldr	r3, .L1563+32
	movs	r0, #0
	ldr	r1, [r3]
	bl	FlashDdrParaScan
	movs	r0, #0
	bl	flash_exit_slc_mode
.L1505:
	ldr	r3, [r4]
	movs	r7, #16
	ldrb	r0, [r3, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	ldr	r0, .L1563+36
	bl	FlashReadIdbDataRaw
	ldr	r8, [r4]
	ldr	r3, [sp, #24]
	ldr	r4, .L1563+40
	ldrb	r1, [r8, #12]	@ zero_extendqisi2
	strb	r7, [r3]
	ldrh	r5, [r8, #10]
	strh	r1, [r4, #8]	@ movhi
	ldrb	r3, [r8, #7]	@ zero_extendqisi2
	mov	r0, r5
	str	r3, [r4, #4]
	ldr	r3, [r6]
	ldrh	r6, [r8, #14]
	str	r3, [r4]
	ldr	r3, .L1563+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r4, #10]	@ movhi
	ldrb	r3, [r8, #13]	@ zero_extendqisi2
	strh	r5, [r4, #16]	@ movhi
	strh	r6, [r4, #14]	@ movhi
	strh	r3, [r4, #12]	@ movhi
	bl	__aeabi_idiv
	mov	r2, #512
	strh	r0, [r4, #18]	@ movhi
	ldrb	r3, [r8, #9]	@ zero_extendqisi2
	strh	r2, [r4, #24]	@ movhi
	ldr	r2, [sp, #20]
	strh	r3, [r4, #20]	@ movhi
	smulbb	r5, r5, r3
	strh	r7, [r4, #26]	@ movhi
	ldrb	r2, [r2]	@ zero_extendqisi2
	uxth	r5, r5
	cmp	r2, #1
	strh	r5, [r4, #22]	@ movhi
	bne	.L1507
	lsls	r3, r3, #1
	lsrs	r2, r6, #1
	lsls	r5, r5, #1
	strh	r3, [r4, #20]	@ movhi
	movs	r3, #8
	strh	r2, [r4, #14]	@ movhi
	strh	r5, [r4, #22]	@ movhi
	strh	r3, [r4, #26]	@ movhi
.L1507:
	ldrb	r0, [r8, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r0, #0
.L1457:
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1473:
	cmp	r3, #220
	bne	.L1475
	mov	r1, #4096
	b	.L1556
.L1475:
	cmp	r3, #211
	itttt	eq
	moveq	r3, #4096
	strheq	r3, [r2, #14]	@ movhi
	moveq	r3, #2
	strbeq	r3, [r2, #13]
	b	.L1474
.L1487:
	sub	lr, r0, #17
	cmp	lr, #2
	bhi	.L1494
	ldr	r3, .L1563+48
	cmp	r0, #19
	str	r3, [r5]
	ite	ne
	movne	r3, #7
	moveq	r3, #15
	strb	r3, [r2]
	b	.L1486
.L1494:
	cmp	r0, #33
	beq	.L1496
	sub	r2, r0, #65
	cmp	r2, #1
	bhi	.L1497
.L1496:
	ldr	r2, .L1563+52
	str	r2, [r1]
	movs	r2, #4
	strb	r2, [r3]
	movs	r3, #7
	strb	r3, [ip]
	b	.L1486
.L1497:
	sub	r2, r0, #67
	uxtb	r2, r2
	cmp	r2, #1
	bls	.L1498
	sub	ip, r0, #34
	cmp	ip, #1
	bhi	.L1499
.L1498:
	ldr	r5, .L1563+52
	cmp	r0, #35
	str	r5, [r1]
	ldr	r1, .L1563+8
	beq	.L1500
	cmp	r0, #68
	beq	.L1500
	movs	r0, #7
.L1557:
	cmp	r2, #1
	strb	r0, [r1]
	ite	ls
	movls	r2, #4
	movhi	r2, #5
	strb	r2, [r3]
	b	.L1486
.L1500:
	movs	r0, #17
	b	.L1557
.L1499:
	cmp	r0, #49
	itt	eq
	ldreq	r3, .L1563+56
	streq	r3, [r5]
	b	.L1486
.L1509:
	mvn	r0, #1
	b	.L1457
.L1469:
	ldr	r5, [sp, #28]
	strb	r0, [r5]
	b	.L1468
.L1564:
	.align	2
.L1563:
	.word	.LANCHOR9
	.word	.LANCHOR12
	.word	.LANCHOR151
	.word	HynixReadRetrial
	.word	.LANCHOR36
	.word	.LANCHOR20+28
	.word	.LANCHOR119
	.word	.LANCHOR18
	.word	.LANCHOR148
	.word	.LANCHOR141
	.word	.LANCHOR14
	.word	.LANCHOR25
	.word	MicronReadRetrial
	.word	ToshibaReadRetrial
	.word	SamsungReadRetrial
	.word	.LANCHOR20
	.size	FlashInit, .-FlashInit
	.section	.text.FlashReadSlc2KPages,"ax",%progbits
	.align	1
	.global	FlashReadSlc2KPages
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadSlc2KPages, %function
FlashReadSlc2KPages:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1622
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	movs	r7, #0
	sub	sp, sp, #24
	ldrb	fp, [r3, #9]	@ zero_extendqisi2
	str	r1, [sp, #8]
	str	r2, [sp, #12]
.L1566:
	ldr	r3, [sp, #8]
	cmp	r7, r3
	bne	.L1590
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1590:
	ldr	r3, [sp, #8]
	add	r2, sp, #20
	ldr	r1, [sp, #12]
	mov	r0, r4
	subs	r3, r3, r7
	uxtb	r3, r3
	str	r3, [sp]
	add	r3, sp, #16
	bl	LogAddr2PhyAddr
	ldr	r2, .L1622+4
	ldr	r3, [sp, #16]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1567
	mov	r3, #-1
	str	r3, [r4]
.L1568:
	adds	r7, r7, #1
	adds	r4, r4, #36
	b	.L1566
.L1567:
	ldr	r2, .L1622+8
	mov	r8, #0
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	mov	r0, r5
	bl	NandcWaitFlashReady
	mov	r0, r5
	bl	NandcFlashCs
.L1569:
	ldr	r1, [sp, #20]
	mov	r0, r5
	bl	FlashReadCmd
	mov	r0, r5
	bl	NandcWaitFlashReady
	ldr	r3, [r4, #12]
	mov	r2, fp
	movs	r1, #0
	mov	r0, r5
	str	r3, [sp]
	ldr	r3, [r4, #8]
	bl	NandcXferData
	ldr	r3, .L1622+12
	mov	r6, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1570
.L1573:
	adds	r3, r6, #1
	beq	.L1571
.L1572:
	cmp	r8, #0
	beq	.L1575
.L1574:
	mov	r6, #256
.L1575:
	mov	r8, #0
.L1576:
	ldr	r3, .L1622+16
	mov	r0, r5
	ldr	r1, [sp, #20]
	ldr	r3, [r3]
	add	r1, r1, r3
	bl	FlashReadCmd
	mov	r0, r5
	bl	NandcWaitFlashReady
	ldr	r3, [r4, #8]
	cbz	r3, .L1577
	add	r3, r3, #2048
.L1577:
	ldr	r2, [r4, #12]
	cbz	r2, .L1578
	adds	r2, r2, #8
.L1578:
	str	r2, [sp]
	movs	r1, #0
	mov	r2, fp
	mov	r0, r5
	bl	NandcXferData
	ldr	r3, .L1622+12
	mov	r10, r0
	ldrb	r2, [r3]	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L1579
.L1582:
	cmp	r10, #-1
	beq	.L1580
.L1581:
	cmp	r8, #0
	beq	.L1584
.L1583:
	mov	r10, #256
.L1584:
	mov	r0, r5
	bl	NandcFlashDeCs
	ldr	r2, .L1622+20
	cmp	r6, r10
	it	cc
	movcc	r6, r10
	ldrb	r2, [r2]	@ zero_extendqisi2
	add	r3, r2, r2, lsl #1
	cmp	r6, r3, asr #2
	bhi	.L1585
	movs	r3, #0
.L1621:
	str	r3, [r4]
	ldr	r3, [r4, #12]
	cbz	r3, .L1586
	ldr	r1, [r3, #12]
	adds	r1, r1, #1
	bne	.L1586
	ldr	r1, [r3, #8]
	adds	r0, r1, #1
	bne	.L1586
	ldr	r3, [r3]
	adds	r3, r3, #1
	it	ne
	strne	r1, [r4]
.L1586:
	ldr	r3, [r4]
	adds	r1, r3, #1
	bne	.L1568
	ldr	r1, [r4, #4]
	ldr	r0, .L1622+24
	bl	printf
	ldr	r1, [r4, #8]
	cbz	r1, .L1588
	movs	r3, #8
	movs	r2, #4
	ldr	r0, .L1622+28
	bl	rknand_print_hex
.L1588:
	ldr	r1, [r4, #12]
	cmp	r1, #0
	beq	.L1568
	movs	r3, #4
	ldr	r0, .L1622+32
	mov	r2, r3
	bl	rknand_print_hex
	b	.L1568
.L1570:
	mov	r0, r5
	bl	flash_read_ecc
	cmp	r0, #5
	bls	.L1573
	mov	r6, #256
	b	.L1572
.L1571:
	cmp	r8, #10
	beq	.L1574
	add	r8, r8, #1
	b	.L1569
.L1579:
	mov	r0, r5
	bl	flash_read_ecc
	cmp	r0, #5
	bls	.L1582
	mov	r10, #256
	b	.L1581
.L1580:
	cmp	r8, #10
	beq	.L1583
	add	r8, r8, #1
	b	.L1576
.L1585:
	mov	r3, #256
	b	.L1621
.L1623:
	.align	2
.L1622:
	.word	.LANCHOR31
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR200
	.word	.LANCHOR4
	.word	.LANCHOR33
	.word	.LC25
	.word	.LC26
	.word	.LC27
	.size	FlashReadSlc2KPages, .-FlashReadSlc2KPages
	.section	.text.FlashReadPages,"ax",%progbits
	.align	1
	.global	FlashReadPages
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadPages, %function
FlashReadPages:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1715
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	mov	r10, r0
	str	r1, [sp, #24]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [sp, #12]
	cbnz	r3, .L1625
	ldr	r2, .L1715+4
	mov	r8, r3
	str	r3, [sp, #8]
	ldrb	r2, [r2, #9]	@ zero_extendqisi2
	str	r2, [sp, #20]
	ldr	r2, .L1715+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #28]
.L1626:
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #24]
	cmp	r3, r2
	bcc	.L1664
	movs	r0, #0
	b	.L1624
.L1625:
	bl	FlashReadSlc2KPages
.L1624:
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1664:
	ldr	r2, [sp, #8]
	movs	r3, #36
	ldr	r1, [sp, #12]
	mul	fp, r3, r2
	add	r7, r10, fp
	ldr	r3, [r7, #4]
	mov	r0, r7
	str	r3, [sp, #16]
	ldr	r3, [sp, #24]
	subs	r3, r3, r2
	add	r2, sp, #36
	uxtb	r3, r3
	str	r3, [sp]
	add	r3, sp, #32
	bl	LogAddr2PhyAddr
	ldr	r2, .L1715+12
	mov	r5, r0
	ldr	r3, [sp, #32]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1628
	mov	r3, #-1
	str	r3, [r10, fp]
.L1629:
	ldr	r3, [sp, #8]
	adds	r3, r3, #1
	str	r3, [sp, #8]
	b	.L1626
.L1628:
	ldr	r2, .L1715+16
	ldrb	r4, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1715+20
	mov	r0, r4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	it	eq
	moveq	r5, #0
	bl	NandcWaitFlashReady
	ldr	r3, .L1715+24
	ldr	r3, [r3]
	ldrb	r2, [r3, #19]	@ zero_extendqisi2
	subs	r3, r2, #1
	cmp	r3, #7
	bhi	.L1631
	ldr	r3, .L1715+28
	subs	r2, r2, #7
	cmp	r2, #1
	ldr	r2, .L1715+32
	add	r1, r3, r4
	ldrb	r3, [r1, #12]	@ zero_extendqisi2
	ldrb	r2, [r2, r4]	@ zero_extendqisi2
	it	ls
	ldrbls	r3, [r1, #20]	@ zero_extendqisi2
	cmp	r2, r3
	beq	.L1631
	ldr	r2, .L1715+36
	mov	r0, r4
	ldrb	r1, [r2, #-3]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1631:
	mov	r0, r4
	bl	NandcFlashCs
	ldr	r3, [sp, #12]
	cmp	r3, #1
	beq	.L1633
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1634
.L1633:
	ldr	r3, .L1715+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1634
	mov	r0, r4
	bl	flash_enter_slc_mode
.L1641:
	ldr	r1, [sp, #36]
	adds	r6, r1, #1
	bne	.L1636
	cmp	r4, #255
	beq	.L1666
.L1636:
	cbz	r5, .L1638
	ldr	r3, .L1715+44
	mov	r0, r4
	ldr	r2, [r3]
	add	r2, r2, r1
	bl	FlashReadDpCmd
.L1639:
	mov	r0, r4
	bl	NandcWaitFlashReady
	cbz	r5, .L1637
	ldr	r1, [sp, #36]
	mov	r0, r4
	bl	FlashReadDpDataOutCmd
.L1637:
	ldr	r3, [r7, #12]
	movs	r1, #0
	ldr	r2, [sp, #20]
	mov	r0, r4
	str	r3, [sp]
	ldr	r3, [r7, #8]
	bl	NandcXferData
	ldr	r3, .L1715+8
	mov	r6, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1640
	adds	r0, r0, #1
	bne	.L1640
	ldr	r3, .L1715+8
	movs	r5, #0
	strb	r5, [r3]
	b	.L1641
.L1634:
	mov	r0, r4
	bl	flash_exit_slc_mode
	b	.L1641
.L1638:
	mov	r0, r4
	bl	FlashReadCmd
	b	.L1639
.L1666:
	movs	r5, #0
	b	.L1637
.L1640:
	cbz	r5, .L1642
	ldr	r3, .L1715+44
	mov	r0, r4
	ldr	r1, [sp, #36]
	ldr	r3, [r3]
	add	r1, r1, r3
	bl	FlashReadDpDataOutCmd
	add	r3, fp, #36
	movs	r1, #0
	add	r3, r3, r10
	mov	r0, r4
	ldr	r2, [r3, #12]
	str	r2, [sp]
	ldr	r2, [sp, #20]
	ldr	r3, [r3, #8]
	bl	NandcXferData
	cmp	r0, #-1
	mov	r8, r0
	it	eq
	moveq	r5, #0
.L1642:
	mov	r0, r4
	bl	NandcFlashDeCs
	ldr	r3, .L1715+8
	adds	r1, r6, #1
	ldrb	r2, [sp, #28]	@ zero_extendqisi2
	strb	r2, [r3]
	bne	.L1643
	ldr	r3, .L1715+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1644
.L1648:
	ldr	r3, .L1715+52
	ldr	r5, [r3]
	cmp	r5, #0
	bne	.L1645
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	bl	FlashReadRawPage
	b	.L1714
.L1644:
	ldr	r3, .L1715+56
	mov	r0, r4
	ldr	r1, [sp, #36]
	ldr	r3, [r3]
	ldr	r5, [r3, #304]
	movs	r3, #1
	str	r3, [sp]
	ldr	r2, [r7, #8]
	ldr	r3, [r7, #12]
	bl	FlashDdrTunningRead
	adds	r2, r0, #1
	mov	r6, r0
	beq	.L1647
	ldr	r3, .L1715+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3, lsr #1
	bls	.L1667
.L1647:
	ubfx	r0, r5, #8, #8
	bl	NandcSetDdrPara
	adds	r3, r6, #1
	beq	.L1648
.L1667:
	movs	r5, #0
.L1643:
	ldr	r3, .L1715+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r6, r3, asr #2
	bls	.L1656
	ldr	r3, .L1715+52
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L1656
	mov	r6, #256
	b	.L1651
.L1716:
	.align	2
.L1715:
	.word	.LANCHOR2
	.word	.LANCHOR31
	.word	.LANCHOR6
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR202
	.word	.LANCHOR18
	.word	.LANCHOR20
	.word	.LANCHOR21
	.word	.LANCHOR20+4
	.word	.LANCHOR15
	.word	.LANCHOR4
	.word	.LANCHOR30
	.word	.LANCHOR145
	.word	.LANCHOR19
	.word	.LANCHOR33
.L1645:
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	blx	r5
	adds	r5, r0, #1
	mov	r6, r0
	bne	.L1649
	ldr	r3, .L1717
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #7
	bhi	.L1650
	ldr	r2, .L1717+4
	movs	r3, #0
	mov	r0, r4
	ldrb	r1, [r2, #-3]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1650:
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	bl	FlashReadRawPage
	ldr	r2, .L1717+8
	mov	r6, r0
	mov	r3, r0
	ldr	r1, [r7, #4]
	ldr	r0, .L1717+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	bl	printf
	adds	r0, r6, #1
	bne	.L1649
	ldr	r3, .L1717+16
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L1651
	ldr	r3, [sp, #12]
	mov	r0, r4
	cmp	r3, #1
	beq	.L1652
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1653
.L1652:
	bl	flash_enter_slc_mode
.L1654:
	ldr	r3, .L1717+20
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	ldr	r5, [r3]
	ldr	r3, [r7, #12]
	blx	r5
.L1714:
	adds	r1, r0, #1
	mov	r6, r0
	mov	r5, #0
	bne	.L1656
.L1651:
	str	r6, [r10, fp]
.L1657:
	ldr	r3, [r10, fp]
	adds	r2, r3, #1
	bne	.L1659
	ldr	r2, .L1717+8
	ldr	r1, [r7, #4]
	ldr	r0, .L1717+24
	ldrb	r2, [r2]	@ zero_extendqisi2
	bl	printf
	ldr	r1, [r7, #12]
	cbz	r1, .L1659
	movs	r3, #4
	ldr	r0, .L1717+28
	mov	r2, r3
	bl	rknand_print_hex
.L1659:
	cbz	r5, .L1661
	ldr	r3, .L1717+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r8, r3, asr #2
	bls	.L1662
	ldr	r3, .L1717+20
	ldr	r3, [r3]
	cmp	r3, #0
	it	eq
	moveq	r8, #256
.L1662:
	cmp	r8, #-1
	add	r3, fp, #36
	str	r8, [r10, r3]
	beq	.L1661
	cmp	r8, #256
	itt	ne
	movne	r2, #0
	strne	r2, [r10, r3]
.L1661:
	ldr	r3, [sp, #8]
	add	r3, r3, r5
	str	r3, [sp, #8]
	ldr	r3, [sp, #12]
	cmp	r3, #1
	beq	.L1663
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1629
.L1663:
	ldr	r3, .L1717+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1629
	mov	r0, r4
	bl	flash_exit_slc_mode
	b	.L1629
.L1653:
	bl	flash_exit_slc_mode
	b	.L1654
.L1649:
	movs	r5, #0
.L1656:
	cmp	r6, #256
	beq	.L1651
	movs	r3, #0
	str	r3, [r10, fp]
	b	.L1657
.L1718:
	.align	2
.L1717:
	.word	.LANCHOR18
	.word	.LANCHOR20+4
	.word	.LANCHOR33
	.word	.LC28
	.word	.LANCHOR15
	.word	.LANCHOR145
	.word	.LC25
	.word	.LC27
	.size	FlashReadPages, .-FlashReadPages
	.section	.text.FlashProgSlc2KPages,"ax",%progbits
	.align	1
	.global	FlashProgSlc2KPages
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashProgSlc2KPages, %function
FlashProgSlc2KPages:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #64
	str	r3, [sp, #12]
	mov	r8, r1
	mov	r4, r0
	mov	r6, r0
	ldr	r3, .L1748
	movs	r7, #0
	ldr	fp, .L1748+28
	str	r2, [sp, #8]
	ldrb	r10, [r3, #9]	@ zero_extendqisi2
.L1720:
	cmp	r7, r8
	bne	.L1726
	ldr	r3, [sp, #12]
	cmp	r3, #0
	bne	.L1737
.L1747:
	movs	r0, #0
	add	sp, sp, #64
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1726:
	sub	r3, r8, r7
	add	r2, sp, #20
	uxtb	r3, r3
	ldr	r1, [sp, #8]
	mov	r0, r6
	str	r3, [sp]
	add	r3, sp, #24
	bl	LogAddr2PhyAddr
	ldr	r2, .L1748+4
	ldr	r3, [sp, #24]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1721
	mov	r3, #-1
	str	r3, [r6]
.L1722:
	adds	r7, r7, #1
	adds	r6, r6, #36
	b	.L1720
.L1721:
	ldr	r2, .L1748+8
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	mov	r0, r5
	bl	NandcWaitFlashReady
	mov	r0, r5
	bl	NandcFlashCs
	ldr	r1, [sp, #20]
	mov	r0, r5
	bl	FlashProgFirstCmd
	ldr	r3, [r6, #12]
	mov	r2, r10
	movs	r1, #1
	mov	r0, r5
	str	r3, [sp]
	ldr	r3, [r6, #8]
	bl	NandcXferData
	ldr	r1, [sp, #20]
	mov	r0, r5
	bl	FlashProgSecondCmd
	mov	r0, r5
	bl	NandcWaitFlashReady
	ldr	r1, [sp, #20]
	mov	r0, r5
	bl	FlashReadStatus
	sbfx	r0, r0, #0, #1
	ldr	r1, [sp, #20]
	str	r0, [r6]
	mov	r0, r5
	ldr	r3, [fp]
	add	r1, r1, r3
	bl	FlashProgFirstCmd
	ldr	r3, [r6, #8]
	cbz	r3, .L1723
	add	r3, r3, #2048
.L1723:
	ldr	r2, [r6, #12]
	cbz	r2, .L1724
	adds	r2, r2, #8
.L1724:
	str	r2, [sp]
	movs	r1, #1
	mov	r2, r10
	mov	r0, r5
	bl	NandcXferData
	ldr	r3, [fp]
	mov	r0, r5
	ldr	r1, [sp, #20]
	add	r1, r1, r3
	bl	FlashProgSecondCmd
	mov	r0, r5
	bl	NandcWaitFlashReady
	ldr	r1, [sp, #20]
	mov	r0, r5
	bl	FlashReadStatus
	lsls	r2, r0, #31
	mov	r0, r5
	itt	mi
	movmi	r3, #-1
	strmi	r3, [r6]
	bl	NandcFlashDeCs
	b	.L1722
.L1733:
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1728
	ldr	r1, [r4, #4]
	ldr	r0, .L1748+12
	bl	printf
.L1729:
	add	r8, r8, #1
	adds	r4, r4, #36
.L1727:
	cmp	r7, r8
	bne	.L1733
	b	.L1747
.L1728:
	sub	r3, r7, r8
	ldr	fp, .L1748+32
	uxtb	r3, r3
	add	r2, sp, #20
	ldr	r1, [sp, #8]
	mov	r0, r4
	str	r3, [sp]
	add	r3, sp, #24
	bl	LogAddr2PhyAddr
	ldr	lr, [r10]
	movs	r3, #0
	ldr	ip, [fp]
	mov	r6, r4
	add	r5, sp, #28
	str	r3, [lr]
	str	r3, [ip]
	ldmia	r6!, {r0, r1, r2, r3}
	stmia	r5!, {r0, r1, r2, r3}
	str	lr, [sp, #36]
	ldmia	r6!, {r0, r1, r2, r3}
	str	ip, [sp, #40]
	stmia	r5!, {r0, r1, r2, r3}
	movs	r1, #1
	ldr	r3, [r6]
	add	r0, sp, #28
	ldr	r2, [sp, #8]
	str	r3, [r5]
	bl	FlashReadPages
	ldr	r5, [sp, #28]
	adds	r3, r5, #1
	bne	.L1730
	ldr	r1, [r4, #4]
	ldr	r0, .L1748+16
	bl	printf
	str	r5, [r4]
.L1730:
	ldr	r3, [r4, #12]
	cbz	r3, .L1731
	ldr	r2, [r3]
	ldr	r3, [fp]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1731
	ldr	r1, [r4, #4]
	ldr	r0, .L1748+20
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L1731:
	ldr	r3, [r4, #8]
	cmp	r3, #0
	beq	.L1729
	ldr	r2, [r3]
	ldr	r3, [r10]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1729
	ldr	r1, [r4, #4]
	ldr	r0, .L1748+24
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
	b	.L1729
.L1737:
	mov	r8, #0
	ldr	r10, .L1748+36
	b	.L1727
.L1749:
	.align	2
.L1748:
	.word	.LANCHOR31
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LC29
	.word	.LC30
	.word	.LC31
	.word	.LC32
	.word	.LANCHOR4
	.word	.LANCHOR199
	.word	.LANCHOR198
	.size	FlashProgSlc2KPages, .-FlashProgSlc2KPages
	.section	.text.FlashProgPages,"ax",%progbits
	.align	1
	.global	FlashProgPages
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashProgPages, %function
FlashProgPages:
	@ args = 0, pretend = 0, frame = 64
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #72
	ldr	r5, .L1802
	mov	r4, r0
	mov	r8, r2
	str	r1, [sp, #8]
	ldr	r5, [r5]
	str	r3, [sp, #20]
	ldrb	r5, [r5, #19]	@ zero_extendqisi2
	str	r5, [sp, #16]
	ldr	r5, .L1802+4
	ldrb	r7, [r5]	@ zero_extendqisi2
	cbnz	r7, .L1751
	ldr	r3, .L1802+8
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	str	r3, [sp, #12]
.L1752:
	ldr	r3, [sp, #8]
	cmp	r7, r3
	bcc	.L1765
	ldr	r6, .L1802+12
	movs	r5, #0
	ldr	r7, .L1802+16
.L1766:
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r5, r3
	bcc	.L1768
	ldr	r3, [sp, #20]
	cmp	r3, #0
	bne	.L1769
.L1777:
	movs	r0, #0
	b	.L1750
.L1751:
	bl	FlashProgSlc2KPages
.L1750:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1765:
	ldr	r3, [sp, #8]
	movs	r6, #36
	muls	r6, r7, r6
	add	r2, sp, #28
	mov	r1, r8
	subs	r3, r3, r7
	uxtb	r3, r3
	add	fp, r4, r6
	str	r3, [sp]
	mov	r0, fp
	add	r3, sp, #32
	bl	LogAddr2PhyAddr
	ldr	r3, .L1802+12
	mov	r10, r0
	ldr	r0, [sp, #32]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L1754
	mov	r3, #-1
	str	r3, [r4, r6]
.L1755:
	adds	r7, r7, #1
	b	.L1752
.L1754:
	ldr	r3, .L1802+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	ldr	r3, .L1802+24
	it	eq
	moveq	r10, #0
	add	r3, r3, r0, lsl #4
	ldr	r3, [r3, #8]
	cbz	r3, .L1757
	uxtb	r0, r0
	bl	FlashWaitCmdDone
.L1757:
	ldr	r3, [sp, #32]
	movs	r1, #0
	ldr	r2, .L1802+24
	add	r2, r2, r3, lsl #4
	str	r1, [r2, #12]
	ldr	r1, [sp, #28]
	str	fp, [r2, #8]
	str	r1, [r2, #4]
	cmp	r10, #0
	beq	.L1758
	add	r1, r6, #36
	add	r1, r1, r4
	str	r1, [r2, #12]
.L1758:
	ldr	r2, .L1802+28
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	lsls	r3, r3, #4
	ldr	r2, .L1802+24
	mov	r0, r5
	strb	r5, [r2, r3]
	ldr	r3, .L1802+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1759
	bl	NandcWaitFlashReady
.L1760:
	ldr	r3, [sp, #16]
	subs	r3, r3, #1
	cmp	r3, #7
	bhi	.L1761
	ldr	r3, .L1802+32
	ldrb	r3, [r3, r5]	@ zero_extendqisi2
	cbz	r3, .L1761
	ldr	r1, .L1802+36
	movs	r3, #0
	mov	r0, r5
	adds	r2, r1, #4
	ldrb	r1, [r1, #1]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1761:
	mov	r0, r5
	bl	NandcFlashCs
	cmp	r8, #1
	mov	r0, r5
	bne	.L1762
	ldr	r3, .L1802+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1762
	bl	flash_enter_slc_mode
.L1763:
	ldr	r1, [sp, #28]
	mov	r0, r5
	bl	FlashProgFirstCmd
	ldr	r3, [fp, #12]
	movs	r1, #1
	ldr	r2, [sp, #12]
	mov	r0, r5
	str	r3, [sp]
	ldr	r3, [fp, #8]
	bl	NandcXferData
	cmp	r10, #0
	beq	.L1764
	ldr	r1, [sp, #28]
	mov	r0, r5
	bl	FlashProgDpFirstCmd
	ldr	r3, .L1802+40
	mov	r0, r5
	ldr	r2, [sp, #32]
	adds	r6, r6, #36
	ldr	r1, [sp, #28]
	add	r6, r6, r4
	ldr	r2, [r3, r2, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	ldr	r3, .L1802+44
	mov	r0, r5
	ldr	r1, [sp, #28]
	ldr	r3, [r3]
	add	r1, r1, r3
	bl	FlashProgDpSecondCmd
	ldr	r3, [r6, #12]
	movs	r1, #1
	ldr	r2, [sp, #12]
	mov	r0, r5
	str	r3, [sp]
	ldr	r3, [r6, #8]
	bl	NandcXferData
.L1764:
	ldr	r1, [sp, #28]
	mov	r0, r5
	bl	FlashProgSecondCmd
	mov	r0, r5
	add	r7, r7, r10
	bl	NandcFlashDeCs
	b	.L1755
.L1759:
	bl	NandcFlashCs
	ldr	r2, [sp, #32]
	mov	r0, r5
	ldr	r3, .L1802+40
	ldr	r1, [sp, #28]
	ldr	r2, [r3, r2, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	mov	r0, r5
	bl	NandcFlashDeCs
	b	.L1760
.L1762:
	bl	flash_exit_slc_mode
	b	.L1763
.L1768:
	uxtb	r0, r5
	bl	FlashWaitCmdDone
	cmp	r8, #1
	bne	.L1767
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbz	r3, .L1767
	ldr	r2, .L1802+24
	lsls	r3, r5, #4
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	flash_exit_slc_mode
.L1767:
	adds	r5, r5, #1
	b	.L1766
.L1769:
	ldr	r10, .L1802+64
	movs	r7, #0
.L1770:
	ldr	r3, [sp, #8]
	cmp	r7, r3
	beq	.L1777
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1771
	ldr	r1, [r4, #4]
	ldr	r0, .L1802+48
	bl	printf
.L1772:
	adds	r7, r7, #1
	adds	r4, r4, #36
	b	.L1770
.L1771:
	ldr	r3, [sp, #8]
	add	r2, sp, #28
	ldr	fp, .L1802+68
	mov	r1, r8
	mov	r0, r4
	mov	r6, r4
	subs	r3, r3, r7
	add	r5, sp, #36
	uxtb	r3, r3
	str	r3, [sp]
	add	r3, sp, #32
	bl	LogAddr2PhyAddr
	ldr	lr, [r10]
	movs	r3, #0
	ldr	ip, [fp]
	str	r3, [lr]
	str	r3, [ip]
	ldmia	r6!, {r0, r1, r2, r3}
	stmia	r5!, {r0, r1, r2, r3}
	str	lr, [sp, #44]
	ldmia	r6!, {r0, r1, r2, r3}
	str	ip, [sp, #48]
	stmia	r5!, {r0, r1, r2, r3}
	mov	r2, r8
	ldr	r3, [r6]
	movs	r1, #1
	add	r0, sp, #36
	str	r3, [r5]
	bl	FlashReadPages
	ldr	r5, [sp, #36]
	adds	r3, r5, #1
	bne	.L1773
	ldr	r1, [r4, #4]
	ldr	r0, .L1802+52
	bl	printf
	str	r5, [r4]
.L1773:
	ldr	r3, [r4, #12]
	cbz	r3, .L1774
	ldr	r2, [r3]
	ldr	r3, [fp]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1774
	ldr	r1, [r4, #4]
	ldr	r0, .L1802+56
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L1774:
	ldr	r3, [r4, #8]
	cmp	r3, #0
	beq	.L1772
	ldr	r2, [r3]
	ldr	r3, [r10]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1772
	ldr	r1, [r4, #4]
	ldr	r0, .L1802+60
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
	b	.L1772
.L1803:
	.align	2
.L1802:
	.word	.LANCHOR18
	.word	.LANCHOR2
	.word	.LANCHOR31
	.word	.LANCHOR25
	.word	.LANCHOR15
	.word	.LANCHOR27
	.word	.LANCHOR23
	.word	.LANCHOR26
	.word	.LANCHOR21
	.word	.LANCHOR20
	.word	.LANCHOR17
	.word	.LANCHOR4
	.word	.LC29
	.word	.LC30
	.word	.LC31
	.word	.LC32
	.word	.LANCHOR198
	.word	.LANCHOR199
	.size	FlashProgPages, .-FlashProgPages
	.section	.text.FlashTestBlk,"ax",%progbits
	.align	1
	.global	FlashTestBlk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashTestBlk, %function
FlashTestBlk:
	@ args = 0, pretend = 0, frame = 104
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1807
	push	{r4, r5, lr}
	mov	r4, r0
	sub	sp, sp, #108
	ldr	r3, [r3]
	cmp	r0, r3
	bcc	.L1806
	ldr	r5, .L1807+4
	add	r0, sp, #40
	movs	r2, #32
	movs	r1, #165
	str	r0, [sp, #16]
	lsls	r4, r4, #10
	ldr	r3, [r5]
	str	r3, [sp, #12]
	bl	ftl_memset
	movs	r2, #8
	movs	r1, #90
	ldr	r0, [r5]
	bl	ftl_memset
	movs	r2, #1
	add	r0, sp, #4
	mov	r1, r2
	str	r4, [sp, #8]
	bl	FlashEraseBlocks
	movs	r3, #1
	add	r0, sp, #4
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r4, [sp, #4]
	movs	r2, #1
	movs	r1, #0
	add	r0, sp, #4
	adds	r4, r4, #0
	it	ne
	movne	r4, #1
	negs	r4, r4
	bl	FlashEraseBlocks
.L1804:
	mov	r0, r4
	add	sp, sp, #108
	@ sp needed
	pop	{r4, r5, pc}
.L1806:
	movs	r4, #0
	b	.L1804
.L1808:
	.align	2
.L1807:
	.word	.LANCHOR149
	.word	.LANCHOR153
	.size	FlashTestBlk, .-FlashTestBlk
	.section	.text.FtlLowFormatEraseBlock,"ax",%progbits
	.align	1
	.global	FtlLowFormatEraseBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlLowFormatEraseBlock, %function
FtlLowFormatEraseBlock:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1854
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	str	r0, [sp, #8]
	ldr	r3, [r3]
	str	r1, [sp, #4]
	cmp	r3, #0
	bne	.L1836
	ldr	r2, .L1854+4
	mov	r10, r3
	mov	r5, r3
	mov	r4, r3
	mov	r8, #36
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #20]
	ldr	r2, .L1854+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #12]
	ldr	r2, .L1854+12
	str	r0, [r2]
	ldr	r2, .L1854+16
	ldrh	fp, [r2]
	ldr	r2, .L1854+20
	ldr	r7, [r2]
	ldr	r2, .L1854+24
	ldr	r2, [r2]
	str	r2, [sp, #16]
	ldr	r2, .L1854+28
	ldrh	r2, [r2]
	str	r2, [sp, #24]
.L1811:
	uxth	r2, r10
	cmp	fp, r2
	bhi	.L1815
	cmp	r5, #0
	beq	.L1809
	ldr	r3, [sp, #12]
	mov	r0, r7
	ldr	r10, .L1854+4
	mov	r8, #0
	mov	r2, r5
	ldr	r7, .L1854+20
	adds	r6, r3, #0
	it	ne
	movne	r6, #1
	strb	r8, [r10]
	mov	r1, r6
	bl	FlashEraseBlocks
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	strb	r3, [r10]
	mov	r10, #36
.L1817:
	uxth	r3, r8
	cmp	r5, r3
	bhi	.L1819
	ldr	r3, [sp, #4]
	cmp	r3, #0
	bne	.L1820
	uxth	r6, r6
	movs	r3, #6
	str	r3, [sp, #16]
	movs	r3, #1
	str	r3, [sp, #12]
.L1821:
	mov	r8, #0
.L1830:
	ldr	r3, .L1854+16
	mov	fp, #0
	mov	r5, fp
	ldrh	r3, [r3]
	str	r3, [sp, #24]
	ldr	r3, .L1854+20
	ldr	r10, [r3]
	ldr	r3, .L1854+32
	ldr	r3, [r3]
	str	r3, [sp, #28]
	ldr	r3, .L1854+36
	ldr	r3, [r3]
	str	r3, [sp, #32]
	ldr	r3, .L1854+28
	ldrh	r3, [r3]
	str	r3, [sp, #36]
.L1822:
	ldr	r3, [sp, #24]
	uxth	r2, fp
	cmp	r3, r2
	bhi	.L1825
	cbz	r5, .L1809
	ldr	fp, .L1854+4
	movs	r3, #1
	mov	r0, r10
	movs	r7, #0
	mov	r2, r6
	mov	r1, r5
	strb	r7, [fp]
	bl	FlashProgPages
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	ldr	r10, .L1854+20
	strb	r3, [fp]
	mov	fp, #36
.L1827:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L1829
	ldr	r3, [sp, #16]
	add	r8, r8, r3
	ldr	r3, [sp, #12]
	uxth	r8, r8
	cmp	r3, r8
	bhi	.L1830
	ldr	r8, .L1854+20
	movs	r7, #0
	mov	r10, #36
.L1831:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L1833
	ldr	r3, [sp, #8]
	cmp	r3, #63
	bls	.L1834
	ldr	r3, [sp, #4]
	cbz	r3, .L1809
.L1834:
	ldr	r3, .L1854+20
	mov	r2, r5
	mov	r1, r6
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L1809:
	mov	r0, r4
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1815:
	mul	r2, r8, r10
	movs	r3, #0
	ldr	r1, [sp, #8]
	str	r3, [r7, r2]
	ldr	r3, .L1854+40
	ldrb	r0, [r3, r10]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r3, [sp, #4]
	mov	r6, r0
	cbz	r3, .L1812
	bl	IsBlkInVendorPart
	cbnz	r0, .L1813
.L1812:
	mov	r0, r6
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1814
	ldr	r3, [sp, #24]
	mla	r1, r8, r5, r7
	lsls	r6, r6, #10
	mul	r2, r3, r5
	ldr	r3, [sp, #16]
	adds	r5, r5, #1
	str	r6, [r1, #4]
	uxth	r5, r5
	str	r0, [r1, #8]
	bic	r2, r2, #3
	add	r2, r2, r3
	str	r2, [r1, #12]
.L1813:
	add	r10, r10, #1
	b	.L1811
.L1814:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L1813
.L1819:
	mul	r3, r10, r8
	ldr	r2, [r7]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	adds	r3, r3, #1
	bne	.L1818
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L1818:
	add	r8, r8, #1
	b	.L1817
.L1820:
	ldr	r3, .L1854+44
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1854+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1837
	ldr	r3, [sp, #12]
	movs	r6, #1
	lsrs	r3, r3, #2
	str	r3, [sp, #16]
	b	.L1821
.L1837:
	movs	r6, #1
	str	r6, [sp, #16]
	b	.L1821
.L1825:
	movs	r3, #36
	ldr	r1, [sp, #8]
	mul	r2, r3, fp
	movs	r3, #0
	str	r3, [r10, r2]
	ldr	r3, .L1854+40
	ldrb	r0, [r3, fp]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r3, [sp, #4]
	mov	r7, r0
	cbz	r3, .L1823
	bl	IsBlkInVendorPart
	cbnz	r0, .L1824
.L1823:
	mov	r0, r7
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1824
	movs	r3, #36
	add	r7, r8, r7, lsl #10
	mla	r1, r3, r5, r10
	ldr	r3, [sp, #28]
	str	r3, [r1, #8]
	ldr	r3, [sp, #36]
	str	r7, [r1, #4]
	mul	r2, r3, r5
	ldr	r3, [sp, #32]
	adds	r5, r5, #1
	uxth	r5, r5
	bic	r2, r2, #3
	add	r2, r2, r3
	str	r2, [r1, #12]
.L1824:
	add	fp, fp, #1
	b	.L1822
.L1829:
	mul	r3, fp, r7
	ldr	r2, [r10]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbz	r3, .L1828
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L1828:
	adds	r7, r7, #1
	b	.L1827
.L1833:
	ldr	r3, [sp, #4]
	cbz	r3, .L1832
	mul	r3, r10, r7
	ldr	r2, [r8]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbnz	r3, .L1832
	ldr	r0, [r1, #4]
	movs	r1, #1
	ubfx	r0, r0, #10, #16
	bl	FtlFreeSysBlkQueueIn
.L1832:
	adds	r7, r7, #1
	b	.L1831
.L1836:
	movs	r4, #0
	b	.L1809
.L1855:
	.align	2
.L1854:
	.word	.LANCHOR76
	.word	.LANCHOR27
	.word	.LANCHOR15
	.word	.LANCHOR73
	.word	.LANCHOR38
	.word	.LANCHOR77
	.word	.LANCHOR189
	.word	.LANCHOR58
	.word	.LANCHOR186
	.word	.LANCHOR187
	.word	.LANCHOR47
	.word	.LANCHOR53
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
	.section	.text.FtlBbmTblFlush,"ax",%progbits
	.align	1
	.global	FtlBbmTblFlush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlBbmTblFlush, %function
FtlBbmTblFlush:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, .L1872
	ldr	r4, [r3]
	str	r3, [sp, #12]
	cmp	r4, #0
	bne	.L1858
	ldr	r3, .L1872+4
	mov	r1, r4
	ldr	r7, .L1872+8
	ldr	r5, .L1872+12
	ldr	r3, [r3]
	ldr	r0, [r7]
	mov	fp, r7
	ldr	r6, .L1872+16
	str	r3, [r5, #12]
	ldr	r7, .L1872+20
	ldr	r3, .L1872+24
	ldr	r8, .L1872+56
	str	r0, [r5, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
.L1859:
	ldrh	r3, [r7]
	cmp	r4, r3
	blt	.L1860
	ldr	r6, [r5, #12]
	movs	r2, #16
	ldr	r4, .L1872+28
	movs	r1, #255
	movs	r7, #0
	mov	r0, r6
	mov	r8, r7
	bl	ftl_memset
	movw	r3, #61649
	mov	r10, r4
	strh	r3, [r6]	@ movhi
	ldr	r3, [r4, #8]
	str	r3, [r6, #4]
	ldrh	r3, [r4]
	strh	r3, [r6, #2]	@ movhi
	ldrh	r3, [r4, #4]
	strh	r3, [r6, #8]	@ movhi
	ldrh	r3, [r4, #6]
	strh	r3, [r6, #10]	@ movhi
	ldr	r3, .L1872+32
	ldr	r3, [r3]
	strh	r3, [r6, #12]	@ movhi
.L1861:
	ldr	r3, [fp]
	ldrh	r2, [r4, #2]
	ldrh	r1, [r4]
	str	r3, [r5, #8]
	ldr	r3, .L1872+4
	ldrh	r0, [r6, #10]
	ldr	r3, [r3]
	str	r3, [r5, #12]
	movs	r3, #0
	str	r3, [r5]
	orr	r3, r2, r1, lsl #10
	str	r3, [r5, #4]
	ldrh	r3, [r4, #4]
	str	r0, [sp]
	ldr	r0, .L1872+36
	bl	printf
	ldr	r3, .L1872+40
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1862
	ldr	r3, [r4, #8]
	mov	r1, #0	@ movhi
	ldrh	r2, [r4]
	strh	r1, [r4, #2]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #8]
	str	r3, [r6, #4]
	strh	r2, [r6, #8]	@ movhi
	ldrh	r3, [r4, #4]
	strh	r2, [r4, #4]	@ movhi
	ldr	r2, .L1872+44
	strh	r3, [r4]	@ movhi
	lsls	r3, r3, #10
	ldr	r0, [r2]
	movs	r2, #1
	str	r3, [r5, #4]
	mov	r1, r2
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
.L1862:
	movs	r3, #1
	ldr	r0, .L1872+12
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r10, #2]
	adds	r3, r3, #1
	strh	r3, [r10, #2]	@ movhi
	ldr	r3, [r5]
	adds	r2, r3, #1
	bne	.L1863
	adds	r7, r7, #1
	ldr	r1, [r5, #4]
	uxth	r7, r7
	ldr	r0, .L1872+48
	bl	printf
	cmp	r7, #3
	bls	.L1861
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L1872+52
	bl	printf
	ldr	r2, [sp, #12]
	movs	r3, #1
	str	r3, [r2]
.L1858:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1860:
	ldrh	r2, [r8]
	ldr	r3, [r5, #8]
	ldr	r1, [r6, #4]!
	mul	r0, r4, r2
	lsls	r2, r2, #2
	adds	r4, r4, #1
	add	r0, r3, r0, lsl #2
	bl	ftl_memcpy
	b	.L1859
.L1863:
	add	r8, r8, #1
	cmp	r8, #1
	beq	.L1861
	cmp	r3, #256
	beq	.L1861
	b	.L1858
.L1873:
	.align	2
.L1872:
	.word	.LANCHOR76
	.word	.LANCHOR188
	.word	.LANCHOR183
	.word	.LANCHOR203
	.word	.LANCHOR74+24
	.word	.LANCHOR45
	.word	.LANCHOR57
	.word	.LANCHOR74
	.word	.LANCHOR37
	.word	.LC33
	.word	.LANCHOR53
	.word	.LANCHOR77
	.word	.LC34
	.word	.LC35
	.word	.LANCHOR123
	.size	FtlBbmTblFlush, .-FtlBbmTblFlush
	.section	.text.allocate_data_superblock,"ax",%progbits
	.align	1
	.global	allocate_data_superblock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	allocate_data_superblock, %function
allocate_data_superblock:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1939
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L1876
.L1875:
	ldr	r3, .L1939+4
	ldr	r8, .L1939+60
	ldr	r7, .L1939+8
	ldrh	r3, [r3]
	ldrh	r2, [r8]
	add	r3, r3, r2
	ldrh	r2, [r7]
	cmp	r3, r2
	ble	.L1877
	ldr	r1, .L1939+12
	movw	r2, #3165
	ldr	r0, .L1939+16
	bl	printf
	ldr	r1, .L1939+20
	ldr	r0, .L1939+24
	bl	printf
.L1877:
	ldr	r3, .L1939+28
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	cmp	r4, r3
	bne	.L1878
	ldr	r3, .L1939+4
	ldrh	r5, [r3]
	ldr	r3, .L1939+32
	ldr	r3, [r3]
	lsrs	r0, r5, #1
	adds	r1, r0, #1
	mul	r6, r3, r5
	add	r1, r1, r6, lsr #2
	ldr	r6, .L1939+36
	uxth	r1, r1
	ldr	r6, [r6]
	cbz	r6, .L1879
	ldr	r6, .L1939+40
	ldr	r6, [r6]
	cmp	r6, #39
	bhi	.L1879
	cmp	r6, #2
	bls	.L1913
	lsls	r1, r5, #31
	bpl	.L1909
	cmp	r3, #0
	beq	.L1913
.L1909:
	mov	r1, r0
	b	.L1879
.L1878:
	cmp	r2, #1
	bne	.L1913
	ldr	r3, .L1939+44
	ldrh	r3, [r3]
	cmp	r3, #1
	beq	.L1913
	ldr	r3, .L1939+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1913
	ldr	r3, .L1939+4
	ldr	r0, .L1939+36
	ldrh	r3, [r3]
	ldr	r0, [r0]
	lsrs	r1, r3, #3
	cbz	r0, .L1879
	ldr	r0, .L1939+40
	ldr	r0, [r0]
	cmp	r0, #1
	bhi	.L1879
	rsb	r3, r3, r3, lsl #3
	ubfx	r1, r3, #3, #16
.L1879:
	cbz	r1, .L1880
	subs	r1, r1, #1
	uxth	r1, r1
.L1880:
	ldr	r0, .L1939+52
	bl	List_pop_index_node
	ldr	r3, .L1939+4
	mov	r5, r0
	uxth	r10, r0
	ldrh	r3, [r3]
	cbnz	r3, .L1881
	ldr	r1, .L1939+12
	movw	r2, #3185
	ldr	r0, .L1939+16
	bl	printf
	ldr	r1, .L1939+20
	ldr	r0, .L1939+24
	bl	printf
.L1881:
	ldr	r3, .L1939+4
	ldr	r2, .L1939+4
	ldrh	r3, [r3]
	subs	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldrh	r3, [r7]
	cmp	r3, r10
	bls	.L1875
	uxth	r5, r5
	lsls	r3, r5, #1
	str	r3, [sp]
	ldr	r3, .L1939+56
	ldr	r3, [r3]
	ldrh	r6, [r3, r5, lsl #1]
	cmp	r6, #0
	bne	.L1875
	strh	r10, [r4]	@ movhi
	mov	r0, r4
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1883
	ldr	r3, .L1939+56
	movw	r2, #65535
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldr	r3, .L1939+4
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r7]
	cmp	r3, r2
	ble	.L1875
	movw	r2, #3201
	ldr	r1, .L1939+12
	ldr	r0, .L1939+16
	bl	printf
	ldr	r1, .L1939+20
	ldr	r0, .L1939+24
	bl	printf
	b	.L1875
.L1913:
	movs	r1, #0
	b	.L1880
.L1940:
	.align	2
.L1939:
	.word	.LANCHOR76
	.word	.LANCHOR88
	.word	.LANCHOR40
	.word	.LANCHOR204
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR93
	.word	.LANCHOR172
	.word	.LANCHOR28
	.word	.LANCHOR170
	.word	.LANCHOR44
	.word	.LANCHOR15
	.word	.LANCHOR87
	.word	.LANCHOR83
	.word	.LANCHOR85
.L1883:
	ldr	r3, .L1941
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r7]
	cmp	r3, r2
	ble	.L1885
	ldr	r1, .L1941+4
	movw	r2, #3204
	ldr	r0, .L1941+8
	bl	printf
	ldr	r1, .L1941+12
	ldr	r0, .L1941+16
	bl	printf
.L1885:
	ldr	r3, .L1941+20
	add	lr, r4, #16
	ldr	r2, .L1941+24
	mov	r8, #0
	ldr	ip, [r3]
	ldrh	r0, [r2]
	movs	r2, #36
	mov	r3, ip
	mla	r0, r2, r0, ip
.L1886:
	cmp	r0, r3
	bne	.L1888
	cbnz	r6, .L1889
	ldr	r1, .L1941+4
	mov	r2, #3216
	ldr	r0, .L1941+8
	bl	printf
	ldr	r1, .L1941+12
	ldr	r0, .L1941+16
	bl	printf
.L1889:
	ldr	r3, .L1941+28
	ldr	r8, .L1941+80
	ldr	r3, [r3]
	cbz	r3, .L1890
	ldr	r3, .L1941+32
	cmp	r4, r3
	bne	.L1890
	ldr	r3, [r8]
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, #40
	itt	hi
	movhi	r3, #0
	strbhi	r3, [r4, #8]
.L1890:
	ldr	r3, .L1941+36
	ldrh	r3, [r3]
	cmp	r3, r10
	bne	.L1891
	ldr	r1, .L1941+4
	movw	r2, #3223
	ldr	r0, .L1941+8
	bl	printf
	ldr	r1, .L1941+12
	ldr	r0, .L1941+16
	bl	printf
.L1891:
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	ldr	r3, .L1941+40
	ldr	fp, .L1941+84
	cmp	r2, #0
	bne	.L1892
	ldr	r1, [r8]
	ldrh	r2, [r1, r5, lsl #1]
	cmp	r2, #0
	beq	.L1893
	ldr	r0, .L1941+44
	ldrh	r0, [r0]
	add	r2, r2, r0
.L1936:
	strh	r2, [r1, r5, lsl #1]	@ movhi
	mov	r0, r10
	ldr	r2, [r3]
	movs	r1, #0
	str	r3, [sp, #4]
	adds	r2, r2, #1
	str	r2, [r3]
	bl	ftl_set_blk_mode
.L1937:
	ldr	r2, [r8]
	ldr	r3, [sp, #4]
	ldrh	r0, [r2, r5, lsl #1]
	ldr	r2, .L1941+48
	ldr	r1, [r2]
	cmp	r0, r1
	ldrh	r1, [r7]
	it	hi
	strhi	r0, [r2]
	ldr	r2, .L1941+44
	ldr	r0, [r3]
	ldr	r3, [fp]
	ldrh	r2, [r2]
	ldr	r7, .L1941+52
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L1941+56
	str	r0, [r3]
	ldr	r3, .L1941+60
	ldr	r2, [r3]
	ldr	r3, [r2, #16]
	adds	r3, r3, #1
	str	r3, [r2, #16]
	ldr	r3, .L1941+20
	ldr	r0, [r3]
	movs	r3, #36
	adds	r1, r0, #4
	mla	r3, r3, r6, r0
	adds	r3, r3, #40
.L1897:
	adds	r1, r1, #36
	cmp	r3, r1
	bne	.L1898
	ldr	r3, .L1941+64
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1899
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	mov	r2, r6
	cmp	r3, #1
	ite	eq
	moveq	r1, #0
	movne	r1, #1
	bl	FlashEraseBlocks
.L1899:
	ldr	r3, .L1941+20
	movs	r7, #0
	mov	r8, r7
	mov	fp, #36
	mov	r2, r6
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L1901:
	uxth	r3, r7
	cmp	r6, r3
	bhi	.L1903
	cmp	r8, #0
	beq	.L1904
	mov	r0, r10
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1904:
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L1905
	ldr	r3, .L1941+68
	movw	r2, #65535
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	b	.L1875
.L1888:
	ldrh	r1, [lr], #2
	movw	fp, #65535
	str	r8, [r3, #8]
	str	r8, [r3, #12]
	cmp	r1, fp
	beq	.L1887
	mla	fp, r2, r6, ip
	adds	r6, r6, #1
	lsls	r1, r1, #10
	uxth	r6, r6
	str	r1, [fp, #4]
.L1887:
	adds	r3, r3, #36
	b	.L1886
.L1893:
	movs	r2, #2
	b	.L1936
.L1892:
	ldr	r1, [r8]
	mov	r0, r10
	str	r3, [sp, #4]
	ldrh	r2, [r1, r5, lsl #1]
	adds	r2, r2, #1
	strh	r2, [r1, r5, lsl #1]	@ movhi
	ldr	r2, [fp]
	adds	r2, r2, #1
	str	r2, [fp]
	bl	ftl_set_blk_mode.part.10
	b	.L1937
.L1898:
	ldr	r2, [r1, #-36]
	ands	r2, r2, r7
	str	r2, [r1, #-36]
	b	.L1897
.L1903:
	ldr	r2, .L1941+20
	mul	r3, fp, r7
	ldr	r2, [r2]
	adds	r1, r2, r3
	ldr	r2, [r2, r3]
	adds	r3, r2, #1
	bne	.L1902
	ldr	r0, [r1, #4]
	add	r8, r8, #1
	str	r2, [sp, #4]
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
	ldr	r2, [sp, #4]
	add	r3, r4, r7, lsl #1
	strh	r2, [r3, #16]	@ movhi
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	subs	r3, r3, #1
	strb	r3, [r4, #7]
.L1902:
	adds	r7, r7, #1
	b	.L1901
.L1905:
	ldr	r3, .L1941+72
	ldr	r1, .L1941+76
	ldrh	r3, [r3]
	strh	r10, [r4]	@ movhi
	smulbb	r3, r3, r2
	movs	r2, #0
	strh	r2, [r4, #2]	@ movhi
	strb	r2, [r4, #6]
	ldr	r2, [r1]
	uxth	r3, r3
	strh	r3, [r4, #4]	@ movhi
	str	r2, [r4, #12]
	adds	r2, r2, #1
	str	r2, [r1]
	ldr	r2, .L1941+68
	ldr	r1, [sp]
	ldr	r2, [r2]
	strh	r3, [r2, r1]	@ movhi
	ldrh	r3, [r4, #4]
	cbz	r3, .L1906
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1876
.L1906:
	ldr	r1, .L1941+4
	movw	r2, #3282
	ldr	r0, .L1941+8
	bl	printf
	ldr	r1, .L1941+12
	ldr	r0, .L1941+16
	bl	printf
.L1876:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1942:
	.align	2
.L1941:
	.word	.LANCHOR88
	.word	.LANCHOR204
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR77
	.word	.LANCHOR38
	.word	.LANCHOR28
	.word	.LANCHOR91
	.word	.LANCHOR205
	.word	.LANCHOR167
	.word	.LANCHOR48
	.word	.LANCHOR169
	.word	-1024
	.word	.LANCHOR206
	.word	.LANCHOR191
	.word	.LANCHOR15
	.word	.LANCHOR83
	.word	.LANCHOR52
	.word	.LANCHOR159
	.word	.LANCHOR78
	.word	.LANCHOR168
	.size	allocate_data_superblock, .-allocate_data_superblock
	.section	.text.FtlGcFreeBadSuperBlk,"ax",%progbits
	.align	1
	.global	FtlGcFreeBadSuperBlk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcFreeBadSuperBlk, %function
FtlGcFreeBadSuperBlk:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r0
	ldr	r4, .L1955
	ldrh	r3, [r4]
	cbz	r3, .L1944
	ldr	r8, .L1955+12
	movs	r7, #0
.L1945:
	ldr	r3, .L1955+4
	ldrh	r2, [r3]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L1951
	bl	FtlGcReFreshBadBlk
.L1944:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1951:
	ldr	r2, .L1955+8
	uxth	r3, r7
	mov	r1, r10
	mov	fp, #0
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	mov	r1, r0
.L1946:
	ldrh	r3, [r4]
	uxth	r5, fp
	cmp	r3, r5
	bhi	.L1950
	adds	r7, r7, #1
	b	.L1945
.L1950:
	uxth	r6, fp
	ldrh	r3, [r8, r6, lsl #1]
	cmp	r3, r1
	bne	.L1947
	mov	r0, r1
	str	r1, [sp, #4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	r2, [r4]
	add	r3, r8, r6, lsl #1
	ldr	r1, [sp, #4]
.L1948:
	cmp	r5, r2
	bcc	.L1949
	subs	r2, r2, #1
	strh	r2, [r4]	@ movhi
.L1947:
	add	fp, fp, #1
	b	.L1946
.L1949:
	ldrh	r0, [r3, #2]!
	adds	r5, r5, #1
	uxth	r5, r5
	strh	r0, [r3, #-2]	@ movhi
	b	.L1948
.L1956:
	.align	2
.L1955:
	.word	.LANCHOR116
	.word	.LANCHOR38
	.word	.LANCHOR47
	.word	.LANCHOR117
	.size	FtlGcFreeBadSuperBlk, .-FtlGcFreeBadSuperBlk
	.section	.text.update_vpc_list,"ax",%progbits
	.align	1
	.global	update_vpc_list
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	update_vpc_list, %function
update_vpc_list:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r4, r0
	ldr	r3, .L1967
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	bne	.L1958
	ldr	r2, .L1967+4
	ldrh	r1, [r2]
	cmp	r1, r0
	bne	.L1959
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L1960:
	ldr	r5, .L1967+8
	mov	r1, r4
	ldr	r0, .L1967+12
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L1962
	ldr	r1, .L1967+16
	movw	r2, #3393
	ldr	r0, .L1967+20
	bl	printf
	ldr	r1, .L1967+24
	ldr	r0, .L1967+28
	bl	printf
.L1962:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	free_data_superblock
	mov	r0, r4
	bl	FtlGcFreeBadSuperBlk
	ldr	r3, .L1967+32
	ldrh	r2, [r5]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldr	r2, .L1967+36
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1966
	ldr	r1, .L1967+16
	movw	r2, #3396
	ldr	r0, .L1967+20
	bl	printf
	ldr	r1, .L1967+24
	ldr	r0, .L1967+28
	bl	printf
.L1966:
	movs	r3, #1
	b	.L1957
.L1959:
	ldr	r2, .L1967+40
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1957
	ldr	r2, .L1967+44
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1957
	ldr	r2, .L1967+48
	ldrh	r2, [r2]
	cmp	r2, r0
	bne	.L1960
.L1957:
	mov	r0, r3
	pop	{r3, r4, r5, pc}
.L1958:
	bl	List_update_data_list
	movs	r3, #0
	b	.L1957
.L1968:
	.align	2
.L1967:
	.word	.LANCHOR83
	.word	.LANCHOR205
	.word	.LANCHOR85
	.word	.LANCHOR82
	.word	.LANCHOR207
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR88
	.word	.LANCHOR40
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR93
	.size	update_vpc_list, .-update_vpc_list
	.section	.text.decrement_vpc_count,"ax",%progbits
	.align	1
	.global	decrement_vpc_count
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	decrement_vpc_count, %function
decrement_vpc_count:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	movw	r3, #65535
	push	{r4, r5, r6, lr}
	cmp	r0, r3
	mov	r4, r0
	beq	.L1970
	ldr	r5, .L1981
	ldr	r3, [r5]
	ldrh	r2, [r3, r0, lsl #1]
	cmp	r2, #0
	bne	.L1971
	mov	r1, r0
	ldr	r0, .L1981+4
	bl	printf
	ldr	r3, [r5]
	ldrh	r3, [r3, r4, lsl #1]
	cbnz	r3, .L1972
	ldr	r1, .L1981+8
	movw	r2, #3411
	ldr	r0, .L1981+12
	bl	printf
	ldr	r1, .L1981+16
	ldr	r0, .L1981+20
	bl	printf
.L1972:
	ldr	r3, [r5]
	movs	r2, #32
	mov	r1, r4
	ldr	r0, .L1981+24
	strh	r2, [r3, r4, lsl #1]	@ movhi
	bl	test_node_in_list
	cbz	r0, .L1973
	ldr	r6, .L1981+28
	mov	r1, r4
	ldr	r0, .L1981+24
	bl	List_remove_node
	ldrh	r3, [r6]
	cbnz	r3, .L1974
	ldr	r1, .L1981+8
	movw	r2, #3415
	ldr	r0, .L1981+12
	bl	printf
	ldr	r1, .L1981+16
	ldr	r0, .L1981+20
	bl	printf
.L1974:
	ldrh	r3, [r6]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r6]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r3, [r5]
	mov	r1, r4
	ldr	r0, .L1981+32
	ldrh	r2, [r3, r4, lsl #1]
	bl	printf
.L1973:
	mov	r0, r4
	bl	FtlGcRefreshBlock
.L1977:
	movs	r5, #0
	b	.L1969
.L1971:
	subs	r2, r2, #1
	strh	r2, [r3, r0, lsl #1]	@ movhi
.L1970:
	ldr	r6, .L1981+36
	movw	r3, #65535
	ldrh	r0, [r6]
	cmp	r0, r3
	bne	.L1976
	strh	r4, [r6]	@ movhi
	b	.L1977
.L1976:
	cmp	r4, r0
	beq	.L1977
	bl	update_vpc_list
	ldr	r3, .L1981+40
	adds	r5, r0, #0
	ldr	r2, .L1981+44
	it	ne
	movne	r5, #1
	strh	r4, [r6]	@ movhi
	ldr	r3, [r3]
	ldr	r2, [r2]
	subs	r3, r3, r2
	asrs	r2, r3, #1
	ldr	r3, .L1981+48
	muls	r3, r2, r3
	ldr	r2, .L1981
	ldr	r2, [r2]
	uxth	r1, r3
	ldrh	r2, [r2, r1, lsl #1]
	cbnz	r2, .L1969
	cmp	r4, r1
	beq	.L1969
	ldr	r1, .L1981+8
	movw	r2, #3436
	ldr	r0, .L1981+12
	bl	printf
	ldr	r1, .L1981+16
	ldr	r0, .L1981+20
	bl	printf
.L1969:
	mov	r0, r5
	pop	{r4, r5, r6, pc}
.L1982:
	.align	2
.L1981:
	.word	.LANCHOR83
	.word	.LC36
	.word	.LANCHOR208
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR87
	.word	.LANCHOR88
	.word	.LC37
	.word	.LANCHOR133
	.word	.LANCHOR82
	.word	.LANCHOR81
	.word	-1431655765
	.size	decrement_vpc_count, .-decrement_vpc_count
	.section	.text.FtlSlcSuperblockCheck,"ax",%progbits
	.align	1
	.global	FtlSlcSuperblockCheck
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlSlcSuperblockCheck, %function
FtlSlcSuperblockCheck:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r3, [r0, #4]
	push	{r4, r5, r6, lr}
	mov	r4, r0
	cmp	r3, #0
	beq	.L1983
	ldrh	r2, [r0]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1983
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r5, .L1994
	ldr	r6, .L1994+4
	adds	r3, r3, #8
	ldrh	r3, [r0, r3, lsl #1]
.L1987:
	movw	r2, #65535
	cmp	r3, r2
	beq	.L1989
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1990
	ldrb	r1, [r5]	@ zero_extendqisi2
	cbnz	r1, .L1990
	ldrh	r1, [r4, #2]
	ldrh	r1, [r6, r1, lsl #1]
	cmp	r1, r2
	bne	.L1990
	ldrh	r3, [r4, #4]
	ldrh	r0, [r4]
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	ldrh	r2, [r4, #4]
	cbnz	r2, .L1989
	ldrh	r3, [r4, #2]
	strb	r2, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	pop	{r4, r5, r6, pc}
.L1989:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldr	r2, .L1994+8
	adds	r3, r3, #1
	ldrh	r2, [r2]
	uxtb	r3, r3
	strb	r3, [r4, #6]
	cmp	r2, r3
	bne	.L1988
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
.L1988:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r3, [r4, r3, lsl #1]
	b	.L1987
.L1990:
	ldrb	r2, [r5]	@ zero_extendqisi2
	cbz	r2, .L1983
	cmp	r3, #1
	bne	.L1983
	ldr	r3, .L1994+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1983
	ldr	r3, .L1994+16
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	movs	r3, #0
	ldr	r2, .L1994+20
	strh	r3, [r4, #4]	@ movhi
	strb	r3, [r4, #6]
	ldrh	r2, [r2]
	strh	r2, [r4, #2]	@ movhi
.L1983:
	pop	{r4, r5, r6, pc}
.L1995:
	.align	2
.L1994:
	.word	.LANCHOR15
	.word	.LANCHOR120
	.word	.LANCHOR38
	.word	.LANCHOR53
	.word	.LANCHOR83
	.word	.LANCHOR52
	.size	FtlSlcSuperblockCheck, .-FtlSlcSuperblockCheck
	.section	.text.get_new_active_ppa,"ax",%progbits
	.align	1
	.global	get_new_active_ppa
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	get_new_active_ppa, %function
get_new_active_ppa:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r2, [r0]
	movw	r3, #65535
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	cmp	r2, r3
	bne	.L1997
	ldr	r1, .L2018
	movw	r2, #3333
	ldr	r0, .L2018+4
	bl	printf
	ldr	r1, .L2018+8
	ldr	r0, .L2018+12
	bl	printf
.L1997:
	ldr	r5, .L2018+16
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L1998
	ldr	r1, .L2018
	movw	r2, #3334
	ldr	r0, .L2018+4
	bl	printf
	ldr	r1, .L2018+8
	ldr	r0, .L2018+12
	bl	printf
.L1998:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1999
	ldr	r1, .L2018
	movw	r2, #3335
	ldr	r0, .L2018+4
	bl	printf
	ldr	r1, .L2018+8
	ldr	r0, .L2018+12
	bl	printf
.L1999:
	movs	r3, #0
	ldr	r7, .L2018+20
	strb	r3, [r4, #10]
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldr	r6, .L2018+24
	adds	r3, r3, #8
	ldrh	r2, [r4, r3, lsl #1]
.L2000:
	movw	r0, #65535
	cmp	r2, r0
	beq	.L2001
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	ldrh	r1, [r4, #2]
	cmp	r3, #1
	ldrh	r3, [r4, #4]
	bne	.L2003
	ldrb	ip, [r6]	@ zero_extendqisi2
	cmp	ip, #0
	bne	.L2003
	ldr	ip, .L2018+28
	ldrh	ip, [ip, r1, lsl #1]
	cmp	ip, r0
	bne	.L2003
	subs	r3, r3, #1
	ldrh	r0, [r4]
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
.L2001:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldrh	r2, [r7]
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r2, r3
	strb	r3, [r4, #6]
	bne	.L2002
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
.L2002:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r2, [r4, r3, lsl #1]
	b	.L2000
.L2003:
	ldr	r8, .L2018+24
	orr	r6, r1, r2, lsl #10
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
.L2004:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	movw	r2, #65535
	ldrh	r0, [r7]
.L2006:
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, r0
	itttt	eq
	ldrheq	r3, [r4, #2]
	addeq	r3, r3, #1
	strheq	r3, [r4, #2]	@ movhi
	moveq	r3, #0
	add	r1, r3, #8
	ldrh	r1, [r4, r1, lsl #1]
	cmp	r1, r2
	beq	.L2006
	strb	r3, [r4, #6]
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L2007
	ldrb	r1, [r8]	@ zero_extendqisi2
	ldrh	r3, [r4, #2]
	cbnz	r1, .L2008
	ldr	r1, .L2018+28
	ldrh	r3, [r1, r3, lsl #1]
	cmp	r3, r2
	bne	.L2007
	ldrh	r3, [r4, #4]
	cbz	r3, .L2007
	subs	r3, r3, #1
	ldrh	r0, [r4]
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	b	.L2004
.L2008:
	ldr	r2, .L2018+32
	ldrh	r2, [r2]
	cmp	r3, r2
	bcc	.L2007
	ldr	r3, .L2018+36
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	movs	r3, #0
	ldrh	r2, [r5]
	strh	r3, [r4, #4]	@ movhi
	strb	r3, [r4, #6]
	strh	r2, [r4, #2]	@ movhi
.L2007:
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L1996
	ldrh	r3, [r4, #4]
	cbz	r3, .L1996
	ldr	r1, .L2018
	movw	r2, #3379
	ldr	r0, .L2018+4
	bl	printf
	ldr	r1, .L2018+8
	ldr	r0, .L2018+12
	bl	printf
.L1996:
	mov	r0, r6
	pop	{r4, r5, r6, r7, r8, pc}
.L2019:
	.align	2
.L2018:
	.word	.LANCHOR209
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR52
	.word	.LANCHOR38
	.word	.LANCHOR15
	.word	.LANCHOR120
	.word	.LANCHOR53
	.word	.LANCHOR83
	.size	get_new_active_ppa, .-get_new_active_ppa
	.section	.text.FtlVpcTblFlush,"ax",%progbits
	.align	1
	.global	FtlVpcTblFlush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlVpcTblFlush, %function
FtlVpcTblFlush:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L2044
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, [r2]
	str	r2, [sp, #4]
	cmp	r3, #0
	bne	.L2022
	ldr	r4, .L2044+4
	ldr	r8, .L2044+112
	ldr	fp, .L2044+116
	ldr	r5, .L2044+8
	ldr	r0, [r8]
	ldr	r6, [fp]
	ldrh	r2, [r4]
	str	r0, [r5, #8]
	str	r6, [r5, #12]
	strh	r2, [r6, #2]	@ movhi
	movw	r2, #61604
	ldr	r7, .L2044+12
	strh	r2, [r6]	@ movhi
	str	r3, [r6, #12]
	ldr	ip, .L2044+120
	ldr	r2, [r4, #8]
	str	r3, [r6, #8]
	ldr	r3, .L2044+16
	str	r2, [r6, #4]
	stm	r7, {r3, ip}
	ldrh	r3, [r4, #6]
	strh	r3, [r7, #8]	@ movhi
	ldr	r3, .L2044+20
	ldrh	r3, [r3]
	strb	r3, [r7, #10]
	ldr	r3, .L2044+24
	ldrh	r2, [r3]
	ldrh	r1, [r3, #2]
	strh	r2, [r7, #14]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r7, #11]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L2044+28
	strh	r2, [r7, #16]	@ movhi
	ldrh	r2, [r3]
	ldrh	r1, [r3, #2]
	strh	r2, [r7, #18]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r7, #12]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L2044+32
	strh	r2, [r7, #20]	@ movhi
	ldrh	r2, [r3]
	strh	r2, [r7, #22]	@ movhi
	ldrh	r1, [r3, #2]
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r7, #13]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L2044+36
	movs	r1, #255
	strh	r2, [r7, #24]	@ movhi
	ldr	r3, [r3]
	str	r3, [r7, #32]
	ldr	r3, .L2044+40
	ldr	r3, [r3]
	str	r3, [r7, #40]
	ldr	r3, .L2044+44
	ldr	r3, [r3]
	str	r3, [r7, #36]
	ldr	r3, .L2044+48
	ldrh	r3, [r3]
	strh	r3, [r7, #44]	@ movhi
	ldr	r3, .L2044+52
	ldrh	r3, [r3]
	strh	r3, [r7, #46]	@ movhi
	ldr	r3, .L2044+56
	ldrh	r2, [r3]
	bl	ftl_memset
	mov	r1, r7
	ldr	r7, .L2044+60
	movs	r2, #48
	ldr	r0, [r5, #8]
	bl	ftl_memcpy
	ldrh	r2, [r7]
	ldr	r3, .L2044+64
	ldr	r0, [r5, #8]
	ldr	r1, [r3]
	lsls	r2, r2, #1
	adds	r0, r0, #48
	bl	ftl_memcpy
	ldrh	r0, [r7]
	ldr	r3, [r5, #8]
	ldr	r1, .L2044+68
	lsrs	r2, r0, #3
	adds	r0, r0, #24
	lsls	r0, r0, #1
	ldr	r1, [r1]
	adds	r2, r2, #4
	bic	r0, r0, #3
	add	r0, r0, r3
	bl	ftl_memcpy
	ldr	r3, .L2044+72
	ldrh	r3, [r3]
	cbz	r3, .L2023
	ldrh	r0, [r7]
	ldr	r3, .L2044+76
	ldr	r1, .L2044+80
	ldrh	r2, [r3]
	lsrs	r3, r0, #3
	ldr	r1, [r1]
	add	r3, r3, r0, lsl #1
	ldr	r0, [r5, #8]
	adds	r3, r3, #52
	lsls	r2, r2, #2
	ubfx	r3, r3, #2, #14
	add	r0, r0, r3, lsl #2
	bl	ftl_memcpy
.L2023:
	movs	r7, #0
	movw	r10, #65535
	movs	r0, #0
	bl	FtlUpdateVaildLpn
.L2024:
	ldr	r3, [r8]
	ldrh	r1, [r4, #2]
	ldrh	r2, [r4]
	str	r3, [r5, #8]
	ldr	r3, [fp]
	str	r3, [r5, #12]
	orr	r3, r1, r2, lsl #10
	str	r3, [r5, #4]
	ldr	r3, .L2044+84
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r1, r3
	blt	.L2025
	movs	r3, #0
	ldrh	r10, [r4, #4]
	strh	r3, [r4, #2]	@ movhi
	strh	r2, [r4, #4]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L2044+40
	ldr	r1, .L2044+40
	strh	r0, [r4]	@ movhi
	ldr	r3, [r3]
	adds	r2, r3, #1
	str	r3, [r4, #8]
	str	r2, [r1]
	lsls	r2, r0, #10
	str	r2, [r5, #4]
	str	r3, [r6, #4]
	strh	r0, [r6, #2]	@ movhi
.L2025:
	ldr	r3, .L2044+88
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2026
	ldr	r3, .L2044+56
	ldr	r0, [r8]
	ldrh	r1, [r3]
	bl	js_hash
	str	r0, [r6, #12]
.L2026:
	movs	r3, #1
	ldr	r0, .L2044+8
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	ldr	r2, [r5]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r1, r2, #1
	strh	r3, [r4, #2]	@ movhi
	bne	.L2027
	cmp	r3, #1
	bne	.L2028
	ldr	r1, .L2044+92
	movw	r2, #1219
	ldr	r0, .L2044+96
	bl	printf
	ldr	r1, .L2044+100
	ldr	r0, .L2044+104
	bl	printf
.L2028:
	ldrh	r3, [r4, #2]
	adds	r7, r7, #1
	uxth	r7, r7
	cmp	r3, #1
	itttt	eq
	ldreq	r3, .L2044+84
	ldrheq	r3, [r3]
	addeq	r3, r3, #-1
	strheq	r3, [r4, #2]	@ movhi
	cmp	r7, #3
	bls	.L2024
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L2044+108
	bl	printf
	ldr	r2, [sp, #4]
	movs	r3, #1
	str	r3, [r2]
.L2022:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2027:
	cmp	r3, #1
	beq	.L2024
	cmp	r2, #256
	beq	.L2024
	movw	r3, #65535
	cmp	r10, r3
	beq	.L2022
	movs	r1, #1
	mov	r0, r10
	bl	FtlFreeSysBlkQueueIn
	b	.L2022
.L2045:
	.align	2
.L2044:
	.word	.LANCHOR76
	.word	.LANCHOR210
	.word	.LANCHOR203
	.word	.LANCHOR80
	.word	1179929683
	.word	.LANCHOR45
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR167
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR112
	.word	.LANCHOR113
	.word	.LANCHOR57
	.word	.LANCHOR40
	.word	.LANCHOR83
	.word	.LANCHOR1
	.word	.LANCHOR69
	.word	.LANCHOR66
	.word	.LANCHOR131
	.word	.LANCHOR53
	.word	.LANCHOR2
	.word	.LANCHOR211
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC38
	.word	.LANCHOR183
	.word	.LANCHOR188
	.word	1342177366
	.size	FtlVpcTblFlush, .-FtlVpcTblFlush
	.section	.text.FtlSuperblockPowerLostFix,"ax",%progbits
	.align	1
	.global	FtlSuperblockPowerLostFix
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlSuperblockPowerLostFix, %function
FtlSuperblockPowerLostFix:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2061
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	sub	sp, sp, #44
	ldr	r8, [r3]
	cmp	r8, #0
	bne	.L2046
	ldr	r3, .L2061+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2057
	ldrb	r3, [r0, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L2057
	ldrh	r6, [r0, #4]
	mov	r8, r3
.L2048:
	mov	r3, #-1
	ldr	r2, .L2061+8
	str	r3, [sp, #20]
	movs	r7, #0
	ldr	r3, .L2061+12
	ldr	r5, [r2]
	mvn	r2, #2
	ldr	r10, .L2061+24
	ldr	r3, [r3]
	str	r5, [sp, #16]
	str	r3, [sp, #12]
	str	r2, [r5, #8]
	mvn	r2, #1
	str	r2, [r5, #12]
	ldrh	r2, [r4]
	strh	r7, [r5]	@ movhi
	strh	r2, [r5, #2]	@ movhi
	movw	r2, #61589
	str	r2, [r3]
	add	r2, r2, #304087040
	add	r2, r2, #1269760
	addw	r2, r2, #1507
	str	r2, [r3, #4]
.L2049:
	adds	r6, r6, #-1
	bcc	.L2052
	ldrh	r3, [r4, #4]
	cbnz	r3, .L2050
.L2052:
	ldr	r3, .L2061+16
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldr	r3, .L2061+20
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
.L2046:
	add	sp, sp, #44
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2057:
	movs	r6, #12
	b	.L2048
.L2050:
	mov	r0, r4
	bl	get_new_active_ppa
	str	r0, [sp, #8]
	adds	r0, r0, #1
	beq	.L2052
	ldr	r3, [r10]
	movs	r1, #1
	add	r0, sp, #4
	str	r3, [r5, #4]
	adds	r3, r3, #1
	adds	r2, r3, #1
	mov	r2, r8
	it	eq
	moveq	r3, r7
	str	r3, [r10]
	movs	r3, #0
	bl	FlashProgPages
	ldrh	r0, [r4]
	bl	decrement_vpc_count
	b	.L2049
.L2062:
	.align	2
.L2061:
	.word	.LANCHOR76
	.word	.LANCHOR15
	.word	.LANCHOR188
	.word	.LANCHOR183
	.word	.LANCHOR83
	.word	.LANCHOR52
	.word	.LANCHOR160
	.size	FtlSuperblockPowerLostFix, .-FtlSuperblockPowerLostFix
	.section	.text.FtlLoadFactoryBbt,"ax",%progbits
	.align	1
	.global	FtlLoadFactoryBbt
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlLoadFactoryBbt, %function
FtlLoadFactoryBbt:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2073
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r5, .L2073+4
	ldr	r3, [r3]
	ldr	r7, .L2073+8
	ldr	r10, .L2073+20
	str	r3, [r5, #8]
	ldr	r3, .L2073+12
	ldr	r8, [r3]
	str	r8, [r5, #12]
.L2064:
	ldr	r3, .L2073+16
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L2069
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2069:
	ldrh	r4, [r10]
	movw	r3, #65535
	ldr	fp, .L2073+4
	strh	r3, [r7, #2]!	@ movhi
	subs	r4, r4, #1
	uxth	r4, r4
.L2065:
	ldrh	r3, [r10]
	sub	r2, r3, #15
	cmp	r2, r4
	bgt	.L2067
	mla	r3, r6, r3, r4
	movs	r2, #1
	mov	r1, r2
	mov	r0, fp
	lsls	r3, r3, #10
	str	r3, [r5, #4]
	bl	FlashReadPages
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L2066
	ldrh	r2, [r8]
	movw	r3, #61664
	cmp	r2, r3
	bne	.L2066
	strh	r4, [r7]	@ movhi
.L2067:
	adds	r6, r6, #1
	b	.L2064
.L2066:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L2065
.L2074:
	.align	2
.L2073:
	.word	.LANCHOR183
	.word	.LANCHOR203
	.word	.LANCHOR74+10
	.word	.LANCHOR188
	.word	.LANCHOR45
	.word	.LANCHOR51
	.size	FtlLoadFactoryBbt, .-FtlLoadFactoryBbt
	.section	.text.FtlGetLastWrittenPage,"ax",%progbits
	.align	1
	.global	FtlGetLastWrittenPage
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGetLastWrittenPage, %function
FtlGetLastWrittenPage:
	@ args = 0, pretend = 0, frame = 104
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r1, #1
	push	{r4, r5, r6, r7, r8, lr}
	it	eq
	ldreq	r3, .L2087
	sub	sp, sp, #104
	lsl	r7, r0, #10
	mov	r2, r1
	it	ne
	ldrne	r3, .L2087+4
	mov	r8, r1
	movs	r6, #0
	movs	r1, #1
	add	r0, sp, #4
	ldrh	r5, [r3]
	add	r3, sp, #40
	str	r3, [sp, #16]
	str	r6, [sp, #12]
	subs	r5, r5, #1
	sxth	r5, r5
	orr	r3, r5, r7
	str	r3, [sp, #8]
	bl	FlashReadPages
	ldr	r3, [sp, #40]
	adds	r3, r3, #1
	bne	.L2078
.L2079:
	cmp	r6, r5
	ble	.L2082
.L2078:
	mov	r0, r5
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2082:
	adds	r3, r6, r5
	mov	r2, r8
	add	r3, r3, r3, lsr #31
	movs	r1, #1
	add	r0, sp, #4
	asrs	r4, r3, #1
	sxth	r3, r4
	orrs	r3, r3, r7
	str	r3, [sp, #8]
	bl	FlashReadPages
	ldr	r3, [sp, #40]
	adds	r3, r3, #1
	bne	.L2080
	ldr	r3, [sp, #44]
	adds	r3, r3, #1
	bne	.L2080
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L2080
	subs	r4, r4, #1
	sxth	r5, r4
	b	.L2079
.L2080:
	adds	r4, r4, #1
	sxth	r6, r4
	b	.L2079
.L2088:
	.align	2
.L2087:
	.word	.LANCHOR53
	.word	.LANCHOR52
	.size	FtlGetLastWrittenPage, .-FtlGetLastWrittenPage
	.section	.text.FtlLoadBbt,"ax",%progbits
	.align	1
	.global	FtlLoadBbt
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlLoadBbt, %function
FtlLoadBbt:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	ldr	r8, .L2118+48
	ldr	r4, .L2118
	ldr	r3, [r8]
	ldr	r7, .L2118+4
	mov	r10, r4
	str	r3, [r4, #8]
	ldr	r3, .L2118+8
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FtlBbtMemInit
	ldrh	r5, [r7]
	subs	r5, r5, #1
	uxth	r5, r5
.L2090:
	ldrh	r3, [r7]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L2093
	lsls	r3, r5, #10
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L2091
	ldr	r3, [r4, #4]
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	adds	r3, r3, #1
	str	r3, [r4, #4]
	bl	FlashReadPages
.L2091:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L2092
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L2092
	ldr	r3, .L2118+12
	ldr	r2, [r6, #4]
	strh	r5, [r3]	@ movhi
	str	r2, [r3, #8]
	ldrh	r2, [r6, #8]
	strh	r2, [r3, #4]	@ movhi
.L2093:
	ldr	r5, .L2118+12
	movw	r2, #65535
	ldrh	r3, [r5]
	cmp	r3, r2
	beq	.L2107
	ldrh	r3, [r5, #4]
	cmp	r3, r2
	beq	.L2097
	lsls	r3, r3, #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L2118
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L2097
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L2097
	ldr	r3, [r6, #4]
	ldr	r2, [r5, #8]
	cmp	r3, r2
	bls	.L2097
	ldrh	r2, [r5, #4]
	str	r3, [r5, #8]
	ldrh	r3, [r6, #8]
	strh	r2, [r5]	@ movhi
	strh	r3, [r5, #4]	@ movhi
.L2097:
	ldr	r10, .L2118
	movs	r1, #1
	ldrh	r0, [r5]
	bl	FtlGetLastWrittenPage
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r5, #2]	@ movhi
.L2099:
	cmp	r7, #0
	bge	.L2102
	ldr	r1, .L2118+16
	mov	r2, #334
	ldr	r0, .L2118+20
	bl	printf
	ldr	r1, .L2118+24
	ldr	r0, .L2118+28
	bl	printf
.L2101:
	ldrh	r3, [r6, #10]
	ldrh	r0, [r6, #12]
	strh	r3, [r5, #6]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L2104
	ldr	r3, .L2118+32
	ldr	r2, [r3]
	cmp	r0, r2
	beq	.L2104
	ldr	r3, .L2118+36
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	cmp	r2, r3
	bcs	.L2104
	cmp	r0, r3
	bcs	.L2104
	bl	FtlSysBlkNumInit
.L2104:
	ldr	r6, .L2118+40
	movs	r5, #0
	ldr	r7, .L2118+44
	ldr	r8, .L2118+52
.L2105:
	ldrh	r3, [r7]
	cmp	r5, r3
	bcc	.L2106
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2092:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2090
.L2102:
	ldrh	r3, [r5]
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	orr	r3, r7, r3, lsl #10
	str	r3, [r4, #4]
	ldr	r3, [r8]
	str	r3, [r4, #8]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L2100
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	beq	.L2101
.L2100:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L2099
.L2106:
	ldrh	r2, [r8]
	ldr	r1, [r4, #8]
	ldr	r0, [r6, #4]!
	lsls	r2, r2, #2
	mla	r1, r5, r2, r1
	adds	r5, r5, #1
	bl	ftl_memcpy
	b	.L2105
.L2107:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2119:
	.align	2
.L2118:
	.word	.LANCHOR203
	.word	.LANCHOR51
	.word	.LANCHOR188
	.word	.LANCHOR74
	.word	.LANCHOR212
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR37
	.word	.LANCHOR41
	.word	.LANCHOR74+24
	.word	.LANCHOR45
	.word	.LANCHOR183
	.word	.LANCHOR123
	.size	FtlLoadBbt, .-FtlLoadBbt
	.section	.text.ftl_map_blk_gc,"ax",%progbits
	.align	1
	.global	ftl_map_blk_gc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_map_blk_gc, %function
ftl_map_blk_gc:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, [r0, #24]
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r5, [r0, #12]
	str	r3, [sp]
	bl	ftl_free_no_use_map_blk
	ldrh	r3, [r4, #10]
	ldrh	r2, [r4, #8]
	subs	r3, r3, #4
	cmp	r2, r3
	blt	.L2121
	uxth	r0, r0
	ldrh	r8, [r5, r0, lsl #1]
	cmp	r8, #0
	beq	.L2121
	ldr	r3, [r4, #32]
	cbnz	r3, .L2121
	movs	r2, #1
	str	r2, [r4, #32]
	strh	r3, [r5, r0, lsl #1]	@ movhi
	ldrh	r3, [r4, #8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	ldr	r3, .L2133
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2122
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L2122:
	ldr	r5, .L2133+4
	movs	r6, #0
.L2123:
	ldrh	r3, [r4, #6]
	uxth	r10, r6
	cmp	r3, r10
	bhi	.L2129
	movs	r1, #1
	mov	r0, r8
	bl	FtlFreeSysBlkQueueIn
	movs	r3, #0
	str	r3, [r4, #32]
.L2121:
	ldr	r3, .L2133
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2127
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
	b	.L2127
.L2129:
	ldr	r3, [sp]
	uxth	fp, r6
	add	r3, r3, fp, lsl #2
	str	r3, [sp, #4]
	ldr	r3, [sp]
	ldr	r2, [r3, fp, lsl #2]
	cmp	r8, r2, lsr #10
	bne	.L2124
	ldr	r3, .L2133+8
	str	r2, [r5, #4]
	movs	r2, #1
	ldr	r0, .L2133+4
	ldr	r1, [r3]
	str	r1, [r5, #8]
	ldr	r1, .L2133+12
	ldr	r7, [r1]
	mov	r1, r2
	str	r7, [r5, #12]
	bl	FlashReadPages
	ldrh	r2, [r7, #8]
	cmp	r2, r10
	beq	.L2125
	ldr	r1, .L2133+16
	movw	r2, #661
	ldr	r0, .L2133+20
	bl	printf
	ldr	r1, .L2133+24
	ldr	r0, .L2133+28
	bl	printf
.L2125:
	ldr	r2, [r5]
	adds	r2, r2, #1
	ldrh	r2, [r7, #8]
	bne	.L2126
.L2128:
	ldr	r1, [sp, #4]
	movs	r3, #0
	ldr	r0, .L2133+32
	str	r3, [r1]
	ldr	r1, [r5, #4]
	bl	printf
	ldr	r3, .L2133+36
	movs	r2, #1
	str	r2, [r3]
.L2127:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2126:
	cmp	r2, r10
	bne	.L2128
	ldrh	r0, [r7]
	ldrh	r1, [r4, #4]
	cmp	r0, r1
	bne	.L2128
	ldr	r2, [r5, #8]
	mov	r1, fp
	mov	r0, r4
	bl	FtlMapWritePage
.L2124:
	adds	r6, r6, #1
	b	.L2123
.L2134:
	.align	2
.L2133:
	.word	.LANCHOR53
	.word	.LANCHOR203
	.word	.LANCHOR184
	.word	.LANCHOR188
	.word	.LANCHOR213
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC39
	.word	.LANCHOR76
	.size	ftl_map_blk_gc, .-ftl_map_blk_gc
	.section	.text.Ftl_write_map_blk_to_last_page,"ax",%progbits
	.align	1
	.global	Ftl_write_map_blk_to_last_page
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	Ftl_write_map_blk_to_last_page, %function
Ftl_write_map_blk_to_last_page:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2149
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r5, [r3]
	cbnz	r5, .L2136
	ldrh	r3, [r0]
	movw	r2, #65535
	ldr	r6, [r0, #12]
	cmp	r3, r2
	bne	.L2137
	ldrh	r3, [r0, #8]
	cbz	r3, .L2138
	ldr	r1, .L2149+4
	movw	r2, #697
	ldr	r0, .L2149+8
	bl	printf
	ldr	r1, .L2149+12
	ldr	r0, .L2149+16
	bl	printf
.L2138:
	ldrh	r3, [r4, #8]
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	movs	r3, #0
	strh	r0, [r6]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	strh	r3, [r4]	@ movhi
	ldr	r3, [r4, #28]
	adds	r3, r3, #1
	str	r3, [r4, #28]
.L2136:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2137:
	ldrh	r8, [r6, r3, lsl #1]
	movs	r1, #255
	ldrh	r3, [r0, #2]
	ldr	r7, .L2149+20
	ldr	fp, .L2149+40
	ldr	r10, [r0, #24]
	orr	r3, r3, r8, lsl #10
	ldr	r0, [fp]
	str	r3, [r7, #4]
	ldr	r3, .L2149+24
	str	r0, [r7, #8]
	ldr	r6, [r3]
	ldr	r3, [r4, #28]
	str	r6, [r7, #12]
	str	r3, [r6, #4]
	movw	r3, #64245
	strh	r3, [r6, #8]	@ movhi
	ldrh	r3, [r4, #4]
	strh	r8, [r6, #2]	@ movhi
	strh	r3, [r6]	@ movhi
	ldr	r3, .L2149+28
	ldrh	r2, [r3]
	lsls	r2, r2, #3
	bl	ftl_memset
	ldrh	ip, [r4, #6]
	mov	r3, r5
	ldr	r1, [fp]
	mov	r2, r5
.L2139:
	uxth	r0, r3
	cmp	ip, r0
	bhi	.L2141
	ldr	r3, .L2149+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2142
	ldr	r3, .L2149+36
	ldr	r0, [r7, #8]
	ldrh	r1, [r3]
	bl	js_hash
	str	r0, [r6, #12]
.L2142:
	movs	r2, #1
	movs	r3, #0
	mov	r1, r2
	ldr	r0, .L2149+20
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	mov	r0, r4
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	bl	ftl_map_blk_gc
	b	.L2136
.L2141:
	ldr	r0, [r10, r3, lsl #2]
	cmp	r8, r0, lsr #10
	bne	.L2140
	adds	r2, r2, #1
	uxth	r2, r2
	str	r3, [r1, r2, lsl #3]
	add	r5, r1, r2, lsl #3
	ldr	r0, [r10, r3, lsl #2]
	str	r0, [r5, #4]
.L2140:
	adds	r3, r3, #1
	b	.L2139
.L2150:
	.align	2
.L2149:
	.word	.LANCHOR76
	.word	.LANCHOR214
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR203
	.word	.LANCHOR188
	.word	.LANCHOR53
	.word	.LANCHOR2
	.word	.LANCHOR57
	.word	.LANCHOR183
	.size	Ftl_write_map_blk_to_last_page, .-Ftl_write_map_blk_to_last_page
	.section	.text.FtlMapWritePage,"ax",%progbits
	.align	1
	.global	FtlMapWritePage
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlMapWritePage, %function
FtlMapWritePage:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r10, .L2177+44
	mov	r8, r1
	movs	r6, #0
	str	r2, [sp, #4]
.L2152:
	ldr	r2, .L2177
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	ldrh	r3, [r10]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L2153
	ldrh	r2, [r4]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2154
.L2153:
	mov	r0, r4
	bl	Ftl_write_map_blk_to_last_page
.L2154:
	ldr	r3, .L2177+4
	ldr	r2, [r3]
	str	r3, [sp, #8]
	cmp	r2, #0
	bne	.L2172
	ldrh	r2, [r4]
	ldr	r3, [r4, #12]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L2156
	ldr	r1, .L2177+8
	movw	r2, #759
	ldr	r0, .L2177+12
	bl	printf
	ldr	r1, .L2177+16
	ldr	r0, .L2177+20
	bl	printf
.L2156:
	ldrh	r2, [r4]
	ldrh	r3, [r4, #10]
	cmp	r2, r3
	bcc	.L2157
	ldr	r1, .L2177+8
	mov	r2, #760
	ldr	r0, .L2177+12
	bl	printf
	ldr	r1, .L2177+16
	ldr	r0, .L2177+20
	bl	printf
.L2157:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r4, #12]
	ldr	r5, .L2177+24
	ldrh	r7, [r3, r2, lsl #1]
	movs	r2, #16
	ldrh	r3, [r4, #2]
	mov	fp, r5
	orr	r3, r3, r7, lsl #10
	str	r3, [r5, #4]
	ldr	r3, [sp, #4]
	str	r3, [r5, #8]
	ldr	r3, .L2177+28
	ldr	r0, [r3]
	str	r0, [r5, #12]
	bl	ftl_memset
	ldr	r3, [r5, #12]
	ldr	r2, [r4, #28]
	str	r3, [sp, #12]
	str	r2, [r3, #4]
	ldrh	r2, [r4, #4]
	strh	r8, [r3, #8]	@ movhi
	strh	r7, [r3, #2]	@ movhi
	strh	r2, [r3]	@ movhi
	ldr	r2, .L2177+32
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L2158
	ldr	r2, .L2177+36
	ldr	r0, [r5, #8]
	ldrh	r1, [r2]
	bl	js_hash
	ldr	r3, [sp, #12]
	str	r0, [r3, #12]
.L2158:
	movs	r3, #1
	ldr	r0, .L2177+24
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	ldr	r2, [r5]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r1, r2, #1
	strh	r3, [r4, #2]	@ movhi
	bne	.L2159
	ldr	r1, [r5, #4]
	adds	r6, r6, #1
	ldr	r0, .L2177+40
	uxth	r6, r6
	bl	printf
	ldrh	r3, [r4, #2]
	cmp	r3, #2
	itttt	ls
	ldrls	r3, .L2177+44
	ldrhls	r3, [r3]
	addls	r3, r3, #-1
	strhls	r3, [r4, #2]	@ movhi
	cmp	r6, #3
	bls	.L2152
	mov	r2, r6
	ldr	r1, [fp, #4]
	ldr	r0, .L2177+48
	bl	printf
	ldr	r2, [sp, #8]
	movs	r3, #1
	str	r3, [r2]
.L2172:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2159:
	cbz	r2, .L2162
	cmp	r3, #1
	strh	r7, [r4, #40]	@ movhi
	bne	.L2163
.L2164:
	movs	r3, #0
	str	r3, [r4, #36]
	b	.L2152
.L2163:
	cmp	r2, #256
.L2176:
	beq	.L2164
	ldr	r3, [r4, #36]
	cmp	r3, #0
	bne	.L2164
	ldr	r2, [fp, #4]
	ldr	r3, [r4, #24]
	str	r2, [r3, r8, lsl #2]
	b	.L2172
.L2162:
	cmp	r3, #1
	b	.L2176
.L2178:
	.align	2
.L2177:
	.word	.LANCHOR165
	.word	.LANCHOR76
	.word	.LANCHOR215
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR203
	.word	.LANCHOR188
	.word	.LANCHOR2
	.word	.LANCHOR57
	.word	.LC40
	.word	.LANCHOR53
	.word	.LC41
	.size	FtlMapWritePage, .-FtlMapWritePage
	.section	.text.flush_l2p_region,"ax",%progbits
	.align	1
	.global	flush_l2p_region
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	flush_l2p_region, %function
flush_l2p_region:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r4, #12
	ldr	r5, .L2180
	muls	r4, r0, r4
	ldr	r0, .L2180+4
	ldr	r3, [r5]
	adds	r2, r3, r4
	ldrh	r1, [r3, r4]
	ldr	r2, [r2, #8]
	bl	FtlMapWritePage
	ldr	r3, [r5]
	movs	r0, #0
	add	r4, r4, r3
	ldr	r3, [r4, #4]
	bic	r3, r3, #-2147483648
	str	r3, [r4, #4]
	pop	{r3, r4, r5, pc}
.L2181:
	.align	2
.L2180:
	.word	.LANCHOR96
	.word	.LANCHOR127
	.size	flush_l2p_region, .-flush_l2p_region
	.section	.text.l2p_flush,"ax",%progbits
	.align	1
	.global	l2p_flush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	l2p_flush, %function
l2p_flush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	movs	r4, #0
	ldr	r5, .L2186
	ldr	r6, .L2186+4
.L2183:
	ldrh	r3, [r5]
	uxth	r0, r4
	cmp	r3, r0
	bhi	.L2185
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L2185:
	ldr	r2, [r6]
	uxth	r3, r4
	movs	r1, #12
	mla	r3, r1, r3, r2
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L2184
	bl	flush_l2p_region
.L2184:
	adds	r4, r4, #1
	b	.L2183
.L2187:
	.align	2
.L2186:
	.word	.LANCHOR67
	.word	.LANCHOR96
	.size	l2p_flush, .-l2p_flush
	.section	.text.FtlVendorPartWrite,"ax",%progbits
	.align	1
	.global	FtlVendorPartWrite
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlVendorPartWrite, %function
FtlVendorPartWrite:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2200
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	str	r2, [sp]
	adds	r2, r0, r1
	mov	r7, r0
	mov	r5, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L2196
	ldr	r3, .L2200+4
	mov	r8, #0
	ldrh	r6, [r3]
	lsr	r6, r0, r6
	lsl	fp, r6, #2
.L2190:
	cbnz	r5, .L2195
.L2188:
	mov	r0, r8
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2195:
	ldr	r3, .L2200+8
	mov	r0, r7
	ldr	r10, .L2200+24
	ldr	r3, [r3]
	ldr	r2, [r3, fp]
	ldr	r3, .L2200+12
	str	r2, [sp, #12]
	ldrh	r3, [r3]
	mov	r1, r3
	str	r3, [sp, #8]
	bl	__aeabi_uidivmod
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #12]
	str	r1, [sp, #4]
	subs	r4, r3, r1
	uxth	r4, r4
	cmp	r5, r4
	it	cc
	uxthcc	r4, r5
	cbz	r2, .L2192
	cmp	r4, r3
	beq	.L2192
	ldr	r3, [r10]
	add	r0, sp, #20
	str	r2, [sp, #24]
	movs	r2, #1
	mov	r1, r2
	str	r3, [sp, #28]
	movs	r3, #0
	str	r3, [sp, #32]
	bl	FlashReadPages
.L2193:
	lsls	r3, r4, #9
	ldr	r0, [r10]
	subs	r5, r5, r4
	mov	r2, r3
	str	r3, [sp, #8]
	ldm	sp, {r1, r3}
	add	r7, r7, r4
	add	fp, fp, #4
	add	r0, r0, r3, lsl #9
	bl	ftl_memcpy
	ldr	r2, [r10]
	mov	r1, r6
	ldr	r0, .L2200+16
	adds	r6, r6, #1
	bl	FtlMapWritePage
	ldr	r3, [sp]
	adds	r0, r0, #1
	it	eq
	moveq	r8, #-1
	mov	r2, r3
	ldr	r3, [sp, #8]
	add	r2, r2, r3
	str	r2, [sp]
	b	.L2190
.L2192:
	ldr	r3, .L2200+20
	movs	r1, #0
	ldr	r0, [r10]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L2193
.L2196:
	mov	r8, #-1
	b	.L2188
.L2201:
	.align	2
.L2200:
	.word	.LANCHOR50
	.word	.LANCHOR56
	.word	.LANCHOR194
	.word	.LANCHOR55
	.word	.LANCHOR216
	.word	.LANCHOR57
	.word	.LANCHOR185
	.size	FtlVendorPartWrite, .-FtlVendorPartWrite
	.section	.text.Ftl_save_ext_data,"ax",%progbits
	.align	1
	.global	Ftl_save_ext_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	Ftl_save_ext_data, %function
Ftl_save_ext_data:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r2, .L2204
	ldr	r3, .L2204+4
	ldr	r1, [r2]
	cmp	r1, r3
	bne	.L2202
	ldr	r3, .L2204+8
	movs	r1, #1
	movs	r0, #0
	str	r3, [r2, #4]
	ldr	r3, .L2204+12
	ldr	r3, [r3]
	str	r3, [r2, #88]
	ldr	r3, .L2204+16
	ldr	r3, [r3]
	str	r3, [r2, #92]
	ldr	r3, .L2204+20
	ldr	r3, [r3]
	str	r3, [r2, #8]
	ldr	r3, .L2204+24
	ldr	r3, [r3]
	str	r3, [r2, #12]
	ldr	r3, .L2204+28
	ldr	r3, [r3]
	str	r3, [r2, #16]
	ldr	r3, .L2204+32
	ldr	r3, [r3]
	str	r3, [r2, #20]
	ldr	r3, .L2204+36
	ldr	r3, [r3]
	str	r3, [r2, #28]
	ldr	r3, .L2204+40
	ldr	r3, [r3]
	str	r3, [r2, #32]
	ldr	r3, .L2204+44
	ldr	r3, [r3]
	str	r3, [r2, #36]
	ldr	r3, .L2204+48
	ldr	r3, [r3]
	str	r3, [r2, #40]
	ldr	r3, .L2204+52
	ldr	r3, [r3]
	str	r3, [r2, #44]
	ldr	r3, .L2204+56
	ldr	r3, [r3]
	str	r3, [r2, #48]
	ldr	r3, .L2204+60
	ldr	r3, [r3]
	str	r3, [r2, #60]
	ldr	r3, .L2204+64
	ldr	r3, [r3]
	str	r3, [r2, #64]
	b	FtlVendorPartWrite
.L2202:
	bx	lr
.L2205:
	.align	2
.L2204:
	.word	.LANCHOR138
	.word	1179929683
	.word	1342177366
	.word	.LANCHOR217
	.word	.LANCHOR218
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR166
	.word	.LANCHOR165
	.word	.LANCHOR168
	.word	.LANCHOR79
	.word	.LANCHOR163
	.word	.LANCHOR164
	.word	.LANCHOR169
	.word	.LANCHOR170
	.word	.LANCHOR158
	.word	.LANCHOR157
	.size	Ftl_save_ext_data, .-Ftl_save_ext_data
	.section	.text.FtlEctTblFlush,"ax",%progbits
	.align	1
	.global	FtlEctTblFlush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlEctTblFlush, %function
FtlEctTblFlush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	r3, .L2213
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L2211
	ldr	r3, .L2213+4
	ldr	r3, [r3]
	cmp	r3, #39
	ite	hi
	movhi	r3, #32
	movls	r3, #4
.L2207:
	ldr	r1, .L2213+8
	ldrh	r2, [r1]
	cmp	r2, #31
	ittt	ls
	addls	r2, r2, #1
	movls	r3, #1
	strhls	r2, [r1]	@ movhi
	ldr	r2, .L2213+12
	cbnz	r0, .L2209
	ldr	r1, [r2]
	ldr	r0, [r1, #20]
	ldr	r1, [r1, #16]
	add	r3, r3, r0
	cmp	r1, r3
	bcc	.L2210
.L2209:
	ldr	r2, [r2]
	movs	r0, #64
	ldr	r3, [r2, #16]
	str	r3, [r2, #20]
	ldr	r3, .L2213+16
	str	r3, [r2]
	ldr	r3, .L2213+20
	ldrh	r1, [r3]
	lsls	r3, r1, #9
	str	r3, [r2, #12]
	ldr	r3, [r2, #8]
	adds	r3, r3, #1
	str	r3, [r2, #8]
	movs	r3, #0
	str	r3, [r2, #4]
	bl	FtlVendorPartWrite
	bl	Ftl_save_ext_data
.L2210:
	movs	r0, #0
	pop	{r3, pc}
.L2211:
	movs	r3, #32
	b	.L2207
.L2214:
	.align	2
.L2213:
	.word	.LANCHOR28
	.word	.LANCHOR170
	.word	.LANCHOR219
	.word	.LANCHOR191
	.word	1112818501
	.word	.LANCHOR190
	.size	FtlEctTblFlush, .-FtlEctTblFlush
	.section	.text.allocate_new_data_superblock,"ax",%progbits
	.align	1
	.global	allocate_new_data_superblock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	allocate_new_data_superblock, %function
allocate_new_data_superblock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2242
	push	{r4, r5, r6, lr}
	mov	r4, r0
	ldrh	r5, [r0]
	ldrh	r3, [r3]
	cmp	r3, r5
	bcs	.L2216
	ldr	r1, .L2242+4
	movw	r2, #3290
	ldr	r0, .L2242+8
	bl	printf
	ldr	r1, .L2242+12
	ldr	r0, .L2242+16
	bl	printf
.L2216:
	ldr	r3, .L2242+20
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2217
	movw	r3, #65535
	cmp	r5, r3
	beq	.L2218
	ldr	r3, .L2242+24
	mov	r0, r5
	ldr	r3, [r3]
	ldrh	r3, [r3, r5, lsl #1]
	cbz	r3, .L2219
	bl	INSERT_DATA_LIST
.L2218:
	movs	r3, #0
	strb	r3, [r4, #8]
	ldr	r3, .L2242+28
	cmp	r4, r3
	beq	.L2220
	ldr	r3, .L2242+32
	ldrh	r2, [r3]
	cmp	r2, #1
	beq	.L2220
	ldr	r3, .L2242+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2221
.L2220:
	movs	r3, #1
	strb	r3, [r4, #8]
.L2222:
	ldr	r6, .L2242+40
	movw	r2, #65535
	ldrh	r0, [r6]
	cmp	r0, r2
	beq	.L2227
	cmp	r5, r0
	bne	.L2228
	ldr	r3, .L2242+24
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L2229
.L2228:
	bl	update_vpc_list
.L2229:
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
.L2227:
	mov	r0, r4
	bl	allocate_data_superblock
	bl	l2p_flush
	movs	r0, #0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2217:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L2219:
	bl	INSERT_FREE_LIST
	b	.L2218
.L2221:
	ldr	r3, .L2242+44
	cmp	r4, r3
	bne	.L2222
	cmp	r2, #3
	beq	.L2224
	ldr	r2, .L2242+48
	ldr	r2, [r2]
	cmp	r2, #1
	bne	.L2225
.L2224:
	movs	r2, #1
	strb	r2, [r3, #8]
.L2225:
	ldr	r2, .L2242+52
	ldr	r2, [r2]
	cmp	r2, #0
	beq	.L2222
	ldr	r2, .L2242+56
	ldr	r2, [r2]
	cmp	r2, #39
	itt	ls
	movls	r2, #1
	strbls	r2, [r3, #8]
	b	.L2222
.L2243:
	.align	2
.L2242:
	.word	.LANCHOR40
	.word	.LANCHOR220
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR76
	.word	.LANCHOR83
	.word	.LANCHOR92
	.word	.LANCHOR44
	.word	.LANCHOR15
	.word	.LANCHOR133
	.word	.LANCHOR91
	.word	.LANCHOR158
	.word	.LANCHOR28
	.word	.LANCHOR170
	.size	allocate_new_data_superblock, .-allocate_new_data_superblock
	.section	.text.FtlVendorPartRead,"ax",%progbits
	.align	1
	.global	FtlVendorPartRead
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlVendorPartRead, %function
FtlVendorPartRead:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2254
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r2
	adds	r2, r0, r1
	sub	sp, sp, #56
	mov	r7, r0
	mov	r6, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L2253
	ldr	r3, .L2254+4
	mov	r8, #0
	ldr	fp, .L2254+28
	ldrh	r5, [r3]
	lsr	r5, r0, r5
	lsls	r3, r5, #2
	str	r3, [sp]
.L2246:
	cbnz	r6, .L2252
.L2244:
	mov	r0, r8
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2252:
	ldr	r3, .L2254+8
	mov	r0, r7
	ldr	r2, [sp]
	ldr	r3, [r3]
	ldr	r3, [r3, r2]
	ldr	r2, .L2254+12
	str	r3, [sp, #8]
	ldrh	r4, [r2]
	mov	r1, r4
	bl	__aeabi_uidivmod
	subs	r4, r4, r1
	ldr	r3, [sp, #8]
	uxth	r4, r4
	str	r1, [sp, #4]
	cmp	r6, r4
	it	cc
	uxthcc	r4, r6
	lsls	r2, r4, #9
	str	r2, [sp, #8]
	cmp	r3, #0
	beq	.L2248
	ldr	r2, [fp]
	add	r0, sp, #20
	str	r3, [sp, #24]
	str	r3, [sp, #12]
	str	r2, [sp, #28]
	movs	r2, #0
	str	r2, [sp, #32]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [sp, #20]
	ldr	r3, [sp, #12]
	adds	r2, r2, #1
	ldr	r2, .L2254+16
	it	eq
	moveq	r8, #-1
	ldr	r2, [r2]
	cmp	r2, #256
	bne	.L2250
	mov	r2, r3
	mov	r1, r5
	ldr	r0, .L2254+20
	bl	printf
	ldr	r2, [fp]
	mov	r1, r5
	ldr	r0, .L2254+24
	bl	FtlMapWritePage
.L2250:
	ldr	r1, [fp]
	lsls	r2, r4, #9
	ldr	r3, [sp, #4]
	mov	r0, r10
	add	r1, r1, r3, lsl #9
	bl	ftl_memcpy
.L2251:
	ldr	r3, [sp, #8]
	adds	r5, r5, #1
	subs	r6, r6, r4
	add	r7, r7, r4
	add	r10, r10, r3
	ldr	r3, [sp]
	adds	r3, r3, #4
	str	r3, [sp]
	b	.L2246
.L2248:
	lsls	r2, r4, #9
	mov	r1, r3
	mov	r0, r10
	bl	ftl_memset
	b	.L2251
.L2253:
	mov	r8, #-1
	b	.L2244
.L2255:
	.align	2
.L2254:
	.word	.LANCHOR50
	.word	.LANCHOR56
	.word	.LANCHOR194
	.word	.LANCHOR55
	.word	.LANCHOR203
	.word	.LC42
	.word	.LANCHOR216
	.word	.LANCHOR185
	.size	FtlVendorPartRead, .-FtlVendorPartRead
	.section	.text.FtlLoadEctTbl,"ax",%progbits
	.align	1
	.global	FtlLoadEctTbl
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlLoadEctTbl, %function
FtlLoadEctTbl:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r0, #64
	ldr	r4, .L2258
	ldr	r5, .L2258+4
	ldr	r2, [r4]
	ldrh	r1, [r5]
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	ldr	r2, [r3]
	ldr	r3, .L2258+8
	cmp	r2, r3
	beq	.L2257
	ldr	r1, .L2258+12
	ldr	r0, .L2258+16
	bl	printf
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r0, [r4]
	lsls	r2, r2, #9
	bl	ftl_memset
.L2257:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2259:
	.align	2
.L2258:
	.word	.LANCHOR191
	.word	.LANCHOR190
	.word	1112818501
	.word	.LC43
	.word	.LC7
	.size	FtlLoadEctTbl, .-FtlLoadEctTbl
	.section	.text.Ftl_load_ext_data,"ax",%progbits
	.align	1
	.global	Ftl_load_ext_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	Ftl_load_ext_data, %function
Ftl_load_ext_data:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r1, #1
	ldr	r4, .L2264
	movs	r0, #0
	ldr	r5, .L2264+4
	mov	r2, r4
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	cmp	r3, r5
	beq	.L2261
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	ftl_memset
	str	r5, [r4]
.L2261:
	ldr	r3, [r4]
	cmp	r3, r5
	ldr	r5, .L2264+8
	bne	.L2262
	ldr	r2, [r4, #88]
	ldr	r3, .L2264+12
	str	r2, [r3]
	ldr	r2, [r4, #92]
	ldr	r3, .L2264+16
	str	r2, [r3]
	ldr	r2, [r4, #8]
	ldr	r3, .L2264+20
	str	r2, [r3]
	ldr	r2, [r4, #12]
	ldr	r3, .L2264+24
	str	r2, [r3]
	ldr	r2, [r4, #16]
	ldr	r3, .L2264+28
	str	r2, [r3]
	ldr	r2, [r4, #20]
	ldr	r3, .L2264+32
	str	r2, [r3]
	ldr	r3, [r4, #28]
	ldr	r2, [r4, #32]
	str	r3, [r5]
	ldr	r3, .L2264+36
	str	r2, [r3]
	ldr	r2, [r4, #36]
	ldr	r3, .L2264+40
	str	r2, [r3]
	ldr	r2, [r4, #40]
	ldr	r3, .L2264+44
	str	r2, [r3]
	ldr	r2, [r4, #44]
	ldr	r3, .L2264+48
	str	r2, [r3]
	ldr	r2, [r4, #48]
	ldr	r3, .L2264+52
	str	r2, [r3]
	ldr	r2, [r4, #60]
	ldr	r3, .L2264+56
	str	r2, [r3]
.L2262:
	ldr	r3, .L2264+60
	movs	r2, #0
	str	r2, [r3]
	ldr	r2, [r4, #68]
	ldr	r3, .L2264+64
	cmp	r2, r3
	bne	.L2263
	ldr	r3, .L2264+68
	movs	r2, #1
	ldr	r1, .L2264+72
	ldr	r0, .L2264+76
	str	r2, [r3]
	bl	printf
.L2263:
	ldr	r3, .L2264+80
	ldr	r1, .L2264+84
	ldrh	r2, [r3]
	ldr	r3, .L2264+88
	ldrh	r1, [r1]
	ldr	r0, [r3]
	ldr	r3, [r5]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L2264+92
	str	r0, [r3]
	pop	{r3, r4, r5, pc}
.L2265:
	.align	2
.L2264:
	.word	.LANCHOR138
	.word	1179929683
	.word	.LANCHOR168
	.word	.LANCHOR217
	.word	.LANCHOR218
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR166
	.word	.LANCHOR165
	.word	.LANCHOR79
	.word	.LANCHOR163
	.word	.LANCHOR164
	.word	.LANCHOR169
	.word	.LANCHOR170
	.word	.LANCHOR158
	.word	.LANCHOR157
	.word	305432421
	.word	.LANCHOR28
	.word	.LC44
	.word	.LC7
	.word	.LANCHOR48
	.word	.LANCHOR40
	.word	.LANCHOR167
	.word	.LANCHOR206
	.size	Ftl_load_ext_data, .-Ftl_load_ext_data
	.section	.text.ftl_vendor_read,"ax",%progbits
	.align	1
	.global	ftl_vendor_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_vendor_read, %function
ftl_vendor_read:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	add	r0, r0, #256
	b	FtlVendorPartRead
	.size	ftl_vendor_read, .-ftl_vendor_read
	.section	.text.ftl_sys_read,"ax",%progbits
	.align	1
	.global	ftl_sys_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_sys_read, %function
ftl_sys_read:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	add	r0, r0, #512
	b	FtlVendorPartRead
	.size	ftl_sys_read, .-ftl_sys_read
	.section	.text.FtlMapBlkWriteDumpData,"ax",%progbits
	.align	1
	.global	FtlMapBlkWriteDumpData
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlMapBlkWriteDumpData, %function
FtlMapBlkWriteDumpData:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	ldr	r3, [r0, #36]
	cmp	r3, #0
	beq	.L2268
	movs	r3, #0
	ldrh	r6, [r0, #6]
	str	r3, [r0, #36]
	ldr	r3, .L2282
	ldr	r10, [r0, #24]
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2268
	ldr	r3, .L2282+4
	ldr	r5, .L2282+8
	ldr	r3, [r3]
	mov	r7, r5
	str	r3, [r5, #8]
	ldr	r3, .L2282+12
	ldr	r8, [r3]
	ldrh	r3, [r0, #2]
	str	r8, [r5, #12]
	cbz	r3, .L2272
	ldr	r2, .L2282+16
	ldrh	r2, [r2]
	subs	r2, r2, #1
	cmp	r3, r2
	bge	.L2272
	ldrh	r2, [r0]
	movw	r1, #65535
	cmp	r2, r1
	beq	.L2272
	ldr	r1, [r0, #12]
	subs	r3, r3, #1
	mov	r0, r5
	ldrh	r2, [r1, r2, lsl #1]
	orr	r3, r3, r2, lsl #10
	movs	r2, #1
	mov	r1, r2
	str	r3, [r5, #4]
	bl	FlashReadPages
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L2272
	ldr	r3, [r4, #24]
	ldrh	r1, [r8, #8]
	ldr	r2, [r3, r1, lsl #2]
	ldr	r3, [r5, #4]
	cmp	r2, r3
	bne	.L2272
	ldr	r2, [r5, #8]
.L2281:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	FtlMapWritePage
.L2272:
	subs	r6, r6, #1
	uxth	r6, r6
	ldr	r3, [r10, r6, lsl #2]
	str	r3, [r7, #4]
	cbz	r3, .L2273
	movs	r2, #1
	ldr	r0, .L2282+8
	mov	r1, r2
	bl	FlashReadPages
.L2274:
	ldr	r2, [r7, #8]
	mov	r1, r6
	b	.L2281
.L2273:
	ldr	r3, .L2282+20
	movs	r1, #255
	ldr	r0, [r7, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L2274
.L2268:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2283:
	.align	2
.L2282:
	.word	.LANCHOR76
	.word	.LANCHOR184
	.word	.LANCHOR203
	.word	.LANCHOR188
	.word	.LANCHOR53
	.word	.LANCHOR57
	.size	FtlMapBlkWriteDumpData, .-FtlMapBlkWriteDumpData
	.section	.text.FtlScanSysBlk,"ax",%progbits
	.align	1
	.global	FtlScanSysBlk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlScanSysBlk, %function
FtlScanSysBlk:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r5, .L2366
	sub	sp, sp, #32
	mov	r1, r4
	ldr	r3, .L2366+4
	ldr	r2, [r5]
	ldr	r6, .L2366+8
	strh	r4, [r3]	@ movhi
	ldr	r3, .L2366+12
	lsls	r2, r2, #2
	strh	r4, [r6]	@ movhi
	ldr	r7, .L2366+16
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [r5]
	mov	r1, r4
	ldr	r3, .L2366+20
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L2366+24
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L2366+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	movs	r2, #16
	movs	r1, #255
	ldr	r0, .L2366+32
	bl	ftl_memset
	ldr	r3, .L2366+36
	str	r6, [sp, #12]
	str	r5, [sp, #16]
	ldrh	r3, [r3]
	str	r3, [sp, #4]
.L2285:
	ldr	r3, .L2366+40
	ldr	r2, [sp, #4]
	ldrh	r3, [r3]
	cmp	r3, r2
	bls	.L2327
	ldr	r3, .L2366+44
	movs	r5, #0
	ldr	r1, .L2366+48
	mov	fp, r5
	movs	r7, #36
	ldrh	r8, [r3]
	ldr	r3, .L2366+52
	ldr	r2, [r1]
	ldr	r1, .L2366+56
	ldr	r6, [r3]
	ldr	r3, .L2366+60
	str	r2, [sp, #8]
	ldrh	r10, [r1]
	ldr	r3, [r3]
	ldr	r2, .L2366+64
	b	.L2328
.L2287:
	ldrb	r0, [r2, r5]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #28]
	str	r2, [sp, #24]
	bl	V2P_block
	str	r0, [sp, #20]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #28]
	cbnz	r0, .L2286
	ldr	r1, [sp, #20]
	mla	r0, r7, fp, r6
	ldr	r4, [sp, #8]
	lsls	r1, r1, #10
	str	r3, [r0, #8]
	str	r1, [r0, #4]
	mul	r1, r10, fp
	bic	r1, r1, #3
	add	r1, r1, r4
	str	r1, [r0, #12]
	add	r1, fp, #1
	uxth	fp, r1
.L2286:
	adds	r5, r5, #1
.L2328:
	uxth	r1, r5
	cmp	r8, r1
	bhi	.L2287
	cmp	fp, #0
	bne	.L2288
.L2326:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #4]
	b	.L2285
.L2288:
	movs	r7, #0
	movs	r2, #1
	mov	r1, fp
	mov	r0, r6
	bl	FlashReadPages
.L2289:
	uxth	r3, r7
	cmp	fp, r3
	bls	.L2326
	ldr	r3, .L2366+52
	mov	r8, #36
	mul	r8, r8, r7
	ldr	r3, [r3]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	ldr	r5, [r2, #4]
	ldr	r6, [r2, #12]
	adds	r3, r3, #1
	ubfx	r5, r5, #10, #16
	bne	.L2292
	mov	r10, #16
.L2294:
	ldr	r3, .L2366+52
	movs	r2, #1
	mov	r1, r2
	ldr	r0, [r3]
	add	r0, r0, r8
	ldr	r3, [r0, #4]
	adds	r3, r3, #1
	str	r3, [r0, #4]
	bl	FlashReadPages
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	ldr	r3, .L2366+52
	ldr	r3, [r3]
	bne	.L2291
	mov	r2, #-1
	str	r2, [r3, r8]
	ldr	r3, .L2366+52
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	cmp	r3, r2
	beq	.L2293
.L2292:
	ldr	r3, .L2366+68
	ldr	r2, [r3]
	ldr	r3, [r6, #4]
	adds	r1, r2, #1
	beq	.L2295
	cmp	r2, r3
	bhi	.L2296
.L2295:
	adds	r2, r3, #1
	ittt	ne
	ldrne	r1, .L2366+68
	addne	r2, r3, #1
	strne	r2, [r1]
.L2296:
	ldrh	r2, [r6]
	movw	r1, #61604
	cmp	r2, r1
	beq	.L2298
	bhi	.L2299
	movw	r3, #61574
	cmp	r2, r3
	beq	.L2300
.L2297:
	adds	r7, r7, #1
	b	.L2289
.L2291:
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L2292
	add	r10, r10, #-1
	uxth	r10, r10
	cmp	r10, #0
	bne	.L2294
.L2293:
	ldr	r3, .L2366+72
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbnz	r1, .L2365
.L2324:
	mov	r0, r5
	bl	FtlFreeSysBlkQueueIn
	b	.L2297
.L2299:
	movw	r3, #61634
	cmp	r2, r3
	beq	.L2301
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2297
.L2365:
	movs	r1, #0
	b	.L2324
.L2301:
	ldr	r3, .L2366+8
	ldrh	r2, [r3]
	ldr	r3, .L2366
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L2303
	ldr	r1, .L2366+76
	movw	r2, #1307
	ldr	r0, .L2366+80
	bl	printf
	ldr	r1, .L2366+84
	ldr	r0, .L2366+88
	bl	printf
.L2303:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #12]
	ldr	r1, [r3]
	ldrh	r0, [r2]
	ldr	r2, .L2366+12
	uxth	r10, r1
	ldr	ip, [r2]
	add	r3, r10, #-1
	sub	r10, r10, r0
	add	r10, r10, #-1
	sxth	r3, r3
	sxth	r10, r10
.L2304:
	cmp	r3, r10
	bgt	.L2310
	cmp	r3, #0
	bge	.L2343
	b	.L2297
.L2310:
	ldr	r2, [ip, r3, lsl #2]
	add	r8, ip, r3, lsl #2
	ldr	r4, [r6, #4]
	cmp	r4, r2
	bls	.L2305
	ldr	r2, [ip]
	cbnz	r2, .L2306
	cmp	r1, r0
	ittt	ne
	ldrne	r2, .L2366+8
	addne	r0, r0, #1
	strhne	r0, [r2]	@ movhi
.L2306:
	ldr	r2, .L2366+20
	uxth	r10, r3
	ldr	r0, [r2]
	movs	r2, #0
.L2307:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L2308
	ldr	r2, [r6, #4]
	cmp	r3, #0
	str	r2, [r8]
	strh	r5, [r0, r3, lsl #1]	@ movhi
	blt	.L2297
	ldr	r2, .L2366+8
	ldrh	r0, [r2]
	ldr	r2, .L2366
	ldr	r2, [r2]
	subs	r2, r2, r0
	subs	r2, r2, #1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L2297
.L2343:
	ldr	r2, .L2366+8
	adds	r0, r0, #1
	strh	r0, [r2]	@ movhi
	ldr	r2, [r6, #4]
	str	r2, [ip, r3, lsl #2]
	ldr	r2, .L2366+20
.L2363:
	ldr	r2, [r2]
	strh	r5, [r2, r3, lsl #1]	@ movhi
	b	.L2297
.L2308:
	add	lr, ip, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, r0, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [ip, r1, lsl #2]
	strh	lr, [r0, r1, lsl #1]	@ movhi
	b	.L2307
.L2305:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L2304
.L2367:
	.align	2
.L2366:
	.word	.LANCHOR64
	.word	.LANCHOR70
	.word	.LANCHOR128
	.word	.LANCHOR130
	.word	.LANCHOR61
	.word	.LANCHOR129
	.word	.LANCHOR193
	.word	.LANCHOR71
	.word	.LANCHOR210
	.word	.LANCHOR40
	.word	.LANCHOR41
	.word	.LANCHOR38
	.word	.LANCHOR105
	.word	.LANCHOR180
	.word	.LANCHOR58
	.word	.LANCHOR104
	.word	.LANCHOR47
	.word	.LANCHOR159
	.word	.LANCHOR15
	.word	.LANCHOR221
	.word	.LC5
	.word	.LC6
	.word	.LC7
.L2300:
	ldr	r8, .L2368+20
	ldr	r10, .L2368+28
	ldrh	r2, [r8]
	ldrh	r3, [r10]
	cmp	r2, r3
	bls	.L2313
	ldr	r1, .L2368
	movw	r2, #1354
	ldr	r0, .L2368+4
	bl	printf
	ldr	r1, .L2368+8
	ldr	r0, .L2368+12
	bl	printf
.L2313:
	ldr	r2, .L2368+16
	ldrh	lr, [r10]
	ldrh	ip, [r8]
	ldr	r0, [r2]
	add	r10, lr, #-1
	sxth	r3, r10
	sub	r10, r10, ip
.L2314:
	cmp	r3, r10
	ble	.L2319
	ldr	r1, [r6, #4]
	add	r8, r0, r3, lsl #2
	ldr	r2, [r0, r3, lsl #2]
	cmp	r1, r2
	bls	.L2315
	ldr	r2, [r0]
	cbnz	r2, .L2316
	cmp	lr, ip
	ittt	ne
	ldrne	r2, .L2368+20
	addne	ip, ip, #1
	strhne	ip, [r2]	@ movhi
.L2316:
	ldr	r2, .L2368+24
	uxth	r10, r3
	ldr	ip, [r2]
	movs	r2, #0
.L2317:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L2318
	ldr	r2, [r6, #4]
	str	r2, [r8]
	strh	r5, [ip, r3, lsl #1]	@ movhi
.L2319:
	cmp	r3, #0
	blt	.L2297
	ldr	r2, .L2368+28
	ldr	ip, .L2368+20
	ldrh	r2, [r2]
	ldrh	r1, [ip]
	subs	r2, r2, #1
	subs	r2, r2, r1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L2297
	ldr	r2, [r6, #4]
	adds	r1, r1, #1
	strh	r1, [ip]	@ movhi
	str	r2, [r0, r3, lsl #2]
	ldr	r2, .L2368+24
	b	.L2363
.L2318:
	add	lr, r0, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, ip, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [r0, r1, lsl #2]
	strh	lr, [ip, r1, lsl #1]	@ movhi
	b	.L2317
.L2315:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L2314
.L2298:
	ldr	r8, .L2368+48
	movw	r2, #65535
	ldrh	r1, [r8]
	cmp	r1, r2
	bne	.L2321
.L2364:
	strh	r5, [r8]	@ movhi
	str	r3, [r8, #8]
	b	.L2297
.L2321:
	ldrh	r0, [r8, #4]
	cmp	r0, r2
	beq	.L2322
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L2322:
	ldr	r3, [r6, #4]
	ldr	r2, [r8, #8]
	cmp	r2, r3
	bcs	.L2323
	ldrh	r2, [r8]
	strh	r2, [r8, #4]	@ movhi
	b	.L2364
.L2323:
	strh	r5, [r8, #4]	@ movhi
	b	.L2297
.L2327:
	ldr	r3, .L2368+32
	ldr	r2, [r3]
	ldrh	r3, [r2]
	cbz	r3, .L2329
.L2332:
	ldr	r3, .L2368+24
	ldr	r4, [r3]
	ldrh	r2, [r4]
	cmp	r2, #0
	beq	.L2330
.L2331:
	ldr	r3, .L2368+36
	ldrh	r2, [r3]
	ldr	r3, .L2368+40
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L2362
	ldr	r1, .L2368
	mov	r2, #1488
	ldr	r0, .L2368+4
	bl	printf
	ldr	r1, .L2368+8
	ldr	r0, .L2368+12
	bl	printf
.L2362:
	movs	r0, #0
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2329:
	ldr	r1, .L2368+36
	ldrh	r1, [r1]
	cmp	r1, #0
	beq	.L2332
	ldr	r5, .L2368+40
	ldr	r0, [r5]
.L2333:
	sxth	r1, r3
	cmp	r1, r0
	bcs	.L2332
	ldrh	r4, [r2, r1, lsl #1]
	adds	r3, r3, #1
	cmp	r4, #0
	beq	.L2333
	ldr	r3, .L2368+44
	movs	r6, #0
	ldr	r0, [r3]
	mov	r3, r1
.L2334:
	ldr	r4, [r5]
	cmp	r3, r4
	bcs	.L2332
	ldrh	r7, [r2, r3, lsl #1]
	subs	r4, r3, r1
	strh	r7, [r2, r4, lsl #1]	@ movhi
	ldr	r7, [r0, r3, lsl #2]
	str	r7, [r0, r4, lsl #2]
	strh	r6, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	sxth	r3, r3
	b	.L2334
.L2330:
	ldr	r3, .L2368+20
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L2331
	ldr	r5, .L2368+28
	ldrh	r1, [r5]
.L2339:
	sxth	r3, r2
	cmp	r3, r1
	mov	r6, r3
	bge	.L2331
	ldrh	r0, [r4, r3, lsl #1]
	adds	r2, r2, #1
	cmp	r0, #0
	beq	.L2339
	ldr	r2, .L2368+16
	movs	r0, #0
	ldr	r2, [r2]
.L2340:
	ldrh	r1, [r5]
	cmp	r3, r1
	bge	.L2331
	ldrh	r7, [r4, r3, lsl #1]
	subs	r1, r3, r6
	strh	r7, [r4, r1, lsl #1]	@ movhi
	ldr	r7, [r2, r3, lsl #2]
	str	r7, [r2, r1, lsl #2]
	adds	r1, r3, #1
	strh	r0, [r4, r3, lsl #1]	@ movhi
	sxth	r3, r1
	b	.L2340
.L2369:
	.align	2
.L2368:
	.word	.LANCHOR221
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR193
	.word	.LANCHOR70
	.word	.LANCHOR71
	.word	.LANCHOR61
	.word	.LANCHOR129
	.word	.LANCHOR128
	.word	.LANCHOR64
	.word	.LANCHOR130
	.word	.LANCHOR210
	.size	FtlScanSysBlk, .-FtlScanSysBlk
	.section	.text.FtlLoadSysInfo,"ax",%progbits
	.align	1
	.global	FtlLoadSysInfo
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlLoadSysInfo, %function
FtlLoadSysInfo:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r1, #0
	ldr	r8, .L2404+164
	ldr	r6, .L2404
	ldr	r3, [r8]
	ldr	r4, .L2404+4
	ldr	r10, .L2404+168
	ldrh	r2, [r6]
	ldr	r5, .L2404+8
	str	r3, [r4, #8]
	ldr	r7, .L2404+12
	ldr	r3, [r10]
	lsls	r2, r2, #1
	ldr	r0, [r5]
	str	r3, [r4, #12]
	bl	ftl_memset
	ldrh	r0, [r7]
	movw	r3, #65535
	str	r5, [sp]
	cmp	r0, r3
	bne	.L2371
.L2383:
	mov	r0, #-1
.L2370:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2371:
	movs	r1, #1
	bl	FtlGetLastWrittenPage
	ldrsh	fp, [r7]
	sxth	r5, r0
	adds	r0, r0, #1
	strh	r0, [r7, #2]	@ movhi
.L2373:
	cmp	r5, #0
	bge	.L2379
	movw	r2, #1557
	ldr	r1, .L2404+16
	ldr	r0, .L2404+20
	bl	printf
	ldr	r1, .L2404+24
	ldr	r0, .L2404+28
	bl	printf
	b	.L2378
.L2379:
	orr	r2, r5, fp, lsl #10
	ldr	r0, .L2404+4
	str	r2, [r4, #4]
	ldr	r2, [r8]
	str	r2, [r4, #8]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, .L2404+32
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L2374
	ldr	r2, [r4, #12]
	ldr	r2, [r2, #12]
	str	r2, [sp, #4]
	cbz	r2, .L2374
	ldr	r1, .L2404+36
	ldr	r0, [r4, #8]
	ldrh	r1, [r1]
	bl	js_hash
	ldr	r2, [sp, #4]
	cmp	r2, r0
	beq	.L2374
	cbnz	r5, .L2375
	ldrh	r2, [r7, #4]
	cmp	fp, r2
	beq	.L2375
	sxth	fp, r2
	ldr	r2, .L2404+40
	ldrh	r5, [r2]
.L2377:
	subs	r5, r5, #1
	sxth	r5, r5
	b	.L2373
.L2375:
	mov	r2, #-1
	str	r2, [r4]
.L2374:
	ldr	r2, [r4]
	adds	r2, r2, #1
	beq	.L2377
	ldr	r2, [r8]
	ldr	r3, .L2404+44
	ldr	r2, [r2]
	cmp	r2, r3
	bne	.L2377
	ldr	r2, [r10]
	ldrh	r1, [r2]
	movw	r2, #61604
	cmp	r1, r2
	bne	.L2377
.L2378:
	ldr	r2, .L2404+36
	ldrh	r3, [r6]
	ldrh	r2, [r2]
	adds	r3, r3, #24
	cmp	r2, r3, lsl #1
	bcs	.L2381
	ldr	r1, .L2404+16
	movw	r2, #1559
	ldr	r0, .L2404+20
	bl	printf
	ldr	r1, .L2404+24
	ldr	r0, .L2404+28
	bl	printf
.L2381:
	movs	r2, #48
	ldr	r1, [r4, #8]
	ldr	r0, .L2404+48
	bl	ftl_memcpy
	ldrh	r2, [r6]
	ldr	r3, [sp]
	ldr	r1, [r4, #8]
	lsls	r2, r2, #1
	ldr	r0, [r3]
	adds	r1, r1, #48
	bl	ftl_memcpy
	ldrh	r1, [r6]
	ldr	r3, [r4, #8]
	lsrs	r2, r1, #3
	adds	r1, r1, #24
	lsls	r1, r1, #1
	adds	r2, r2, #4
	bic	r1, r1, #3
	add	r1, r1, r3
	ldr	r3, .L2404+52
	ldr	r0, [r3]
	bl	ftl_memcpy
	ldr	r3, .L2404+56
	ldrh	r3, [r3]
	cbz	r3, .L2382
	ldrh	r1, [r6]
	ldr	r3, .L2404+60
	ldrh	r2, [r3]
	lsrs	r3, r1, #3
	add	r3, r3, r1, lsl #1
	ldr	r1, [r4, #8]
	adds	r3, r3, #52
	lsls	r2, r2, #2
	ubfx	r3, r3, #2, #14
	add	r1, r1, r3, lsl #2
	ldr	r3, .L2404+64
	ldr	r0, [r3]
	bl	ftl_memcpy
.L2382:
	ldr	r4, .L2404+48
	ldr	r3, .L2404+44
	ldr	r2, [r4]
	cmp	r2, r3
	bne	.L2383
	ldr	r3, .L2404+68
	ldrb	r2, [r4, #10]	@ zero_extendqisi2
	ldrh	r5, [r4, #8]
	ldrh	r3, [r3]
	strh	r5, [r7, #6]	@ movhi
	cmp	r2, r3
	bne	.L2383
	ldr	r3, .L2404+72
	ldr	r2, .L2404+76
	str	r5, [r3]
	ldr	r3, .L2404+80
	ldrh	r3, [r3]
	muls	r3, r5, r3
	str	r3, [r2]
	ldr	r2, .L2404+84
	ldrh	r2, [r2]
	muls	r3, r2, r3
	ldr	r2, .L2404+88
	str	r3, [r2]
	ldr	r3, .L2404+92
	ldr	r6, [r3]
	ldr	r3, .L2404+96
	ldrh	r0, [r3, #6]
	ldr	r3, .L2404+100
	subs	r0, r6, r0
	ldrh	r1, [r3]
	subs	r0, r0, r5
	bl	__aeabi_uidiv
	ldr	r3, .L2404+104
	cmp	r5, r6
	strh	r0, [r3]	@ movhi
	bls	.L2384
	ldr	r1, .L2404+16
	movw	r2, #1586
	ldr	r0, .L2404+20
	bl	printf
	ldr	r1, .L2404+24
	ldr	r0, .L2404+28
	bl	printf
.L2384:
	ldrh	r2, [r4, #16]
	ldr	r3, .L2404+108
	ldrh	ip, [r4, #14]
	ldr	r7, .L2404+112
	lsrs	r1, r2, #6
	and	r2, r2, #63
	strb	r2, [r3, #6]
	ldrb	r2, [r4, #11]	@ zero_extendqisi2
	strh	r1, [r3, #2]	@ movhi
	ldr	r1, .L2404+116
	strb	r2, [r3, #8]
	ldrh	r2, [r4, #18]
	strh	ip, [r3]	@ movhi
	movw	r3, #65535
	strh	r3, [r7]	@ movhi
	movs	r3, #0
	strh	r2, [r1]	@ movhi
	ldrh	r2, [r4, #20]
	strh	r3, [r7, #2]	@ movhi
	strb	r3, [r7, #6]
	strb	r3, [r7, #8]
	lsrs	r5, r2, #6
	and	r2, r2, #63
	strb	r2, [r1, #6]
	ldrb	r2, [r4, #12]	@ zero_extendqisi2
	strh	r5, [r1, #2]	@ movhi
	ldrh	r5, [r4, #22]
	strb	r2, [r1, #8]
	ldr	r2, .L2404+120
	strh	r5, [r2]	@ movhi
	ldrh	r5, [r4, #24]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r2, #6]
	ldrb	r5, [r4, #13]	@ zero_extendqisi2
	strh	r6, [r2, #2]	@ movhi
	ldr	r6, [r4, #32]
	strb	r5, [r2, #8]
	ldr	r5, .L2404+124
	str	r3, [r5]
	ldr	r5, .L2404+128
	str	r3, [r5]
	ldr	r5, .L2404+132
	str	r3, [r5]
	ldr	r5, .L2404+136
	str	r3, [r5]
	ldr	r5, .L2404+140
	str	r6, [r5]
	mov	r6, r1
	ldr	r5, .L2404+144
	str	r3, [r5]
	ldr	r5, .L2404+148
	str	r3, [r5]
	ldr	r5, .L2404+152
	ldr	lr, [r4, #40]
	str	r3, [r5]
	ldr	r3, .L2404+156
	ldr	r5, [r3]
	cmp	lr, r5
	mov	r5, r2
	it	hi
	strhi	lr, [r3]
	ldr	r3, .L2404+160
	ldr	r2, [r4, #36]
	ldr	r1, [r3]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3]
	movw	r3, #65535
	cmp	ip, r3
	beq	.L2387
	ldr	r0, .L2404+108
	bl	make_superblock
.L2387:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2388
	ldr	r0, .L2404+116
	bl	make_superblock
.L2388:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2389
	ldr	r0, .L2404+120
	bl	make_superblock
.L2389:
	ldrh	r2, [r7]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2390
	ldr	r0, .L2404+112
	bl	make_superblock
.L2390:
	movs	r0, #0
	b	.L2370
.L2405:
	.align	2
.L2404:
	.word	.LANCHOR40
	.word	.LANCHOR203
	.word	.LANCHOR83
	.word	.LANCHOR210
	.word	.LANCHOR222
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR2
	.word	.LANCHOR57
	.word	.LANCHOR53
	.word	1179929683
	.word	.LANCHOR80
	.word	.LANCHOR1
	.word	.LANCHOR69
	.word	.LANCHOR66
	.word	.LANCHOR195
	.word	.LANCHOR45
	.word	.LANCHOR223
	.word	.LANCHOR72
	.word	.LANCHOR52
	.word	.LANCHOR55
	.word	.LANCHOR68
	.word	.LANCHOR42
	.word	.LANCHOR74
	.word	.LANCHOR38
	.word	.LANCHOR224
	.word	.LANCHOR91
	.word	.LANCHOR205
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR166
	.word	.LANCHOR165
	.word	.LANCHOR167
	.word	.LANCHOR168
	.word	.LANCHOR169
	.word	.LANCHOR164
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR183
	.word	.LANCHOR188
	.size	FtlLoadSysInfo, .-FtlLoadSysInfo
	.section	.text.FtlDumpBlockInfo,"ax",%progbits
	.align	1
	.global	FtlDumpBlockInfo
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlDumpBlockInfo, %function
FtlDumpBlockInfo:
	@ args = 0, pretend = 0, frame = 64
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	ubfx	r0, r0, #10, #16
	ldr	r4, .L2418
	sub	sp, sp, #88
	mov	r8, r1
	ldrh	r3, [r4]
	str	r3, [sp, #24]
	bl	P2V_block_in_plane
	ldr	r1, .L2418+4
	mov	r6, r0
	ldr	r0, .L2418+8
	bl	printf
	ldr	r3, .L2418+12
	mov	r1, r6
	ldr	r0, .L2418+16
	ldr	r3, [r3]
	ldrh	r2, [r3, r6, lsl #1]
	bl	printf
	add	r0, sp, #88
	strh	r6, [r0, #-48]!	@ movhi
	bl	make_superblock
	ldr	r3, .L2418+20
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L2407
	cmp	r8, #0
	bne	.L2416
	mov	r0, r6
	bl	ftl_get_blk_mode
	cmp	r0, #1
	mov	r5, r0
	bne	.L2407
	ldr	r3, .L2418+24
	ldrh	r3, [r3]
	str	r3, [sp, #24]
.L2407:
	movs	r6, #0
	ldrh	r3, [r4]
	ldr	r2, [sp, #24]
	mov	r1, r5
	ldr	r0, .L2418+28
	bl	printf
.L2408:
	ldr	r3, .L2418+32
	movs	r2, #0
	add	ip, sp, #54
	mov	r4, r2
	movw	r10, #65535
	mov	fp, #36
	ldrh	lr, [r3]
	ldr	r3, .L2418+36
	ldr	r0, [r3]
	ldr	r3, .L2418+40
	ldr	r3, [r3]
	str	r3, [sp, #28]
	ldr	r3, .L2418+44
	ldrh	r3, [r3]
	str	r3, [sp, #32]
	ldr	r3, .L2418+48
	ldr	r3, [r3]
	str	r3, [sp, #36]
	ldr	r3, .L2418+52
	ldrh	r8, [r3]
.L2409:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L2411
	ldr	fp, .L2418+56
	mov	r8, #0
	mov	r10, #36
	mov	r2, r5
	mov	r1, r4
	bl	FlashReadPages
.L2412:
	uxth	r3, r8
	cmp	r4, r3
	bhi	.L2413
	adds	r6, r6, #1
	ldr	r3, [sp, #24]
	uxth	r6, r6
	cmp	r3, r6
	bne	.L2408
.L2414:
	movs	r0, #0
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2416:
	movs	r5, #0
	b	.L2407
.L2411:
	ldrh	r3, [ip, #2]!
	cmp	r3, r10
	beq	.L2410
	mla	r1, fp, r4, r0
	ldr	r7, [sp, #28]
	orr	r3, r6, r3, lsl #10
	str	r3, [r1, #4]
	ldr	r3, [sp, #32]
	muls	r3, r4, r3
	bic	r3, r3, #3
	add	r3, r3, r7
	ldr	r7, [sp, #36]
	str	r3, [r1, #8]
	mul	r3, r8, r4
	adds	r4, r4, #1
	uxth	r4, r4
	bic	r3, r3, #3
	add	r3, r3, r7
	str	r3, [r1, #12]
.L2410:
	adds	r2, r2, #1
	b	.L2409
.L2413:
	ldr	r3, .L2418+36
	mul	r0, r10, r8
	ldrh	r1, [sp, #40]
	add	r8, r8, #1
	ldr	ip, [r3]
	add	r2, ip, r0
	ldr	lr, [r2, #8]
	ldr	r3, [r2, #12]
	ldr	r7, [lr, #4]
	str	r7, [sp, #20]
	ldr	r7, [lr]
	str	r7, [sp, #16]
	ldr	r7, [r3, #12]
	str	r7, [sp, #12]
	ldr	r7, [r3, #8]
	str	r7, [sp, #8]
	ldr	r7, [r3, #4]
	str	r7, [sp, #4]
	ldr	r3, [r3]
	str	r3, [sp]
	ldr	r3, [r2, #4]
	ldr	r2, [ip, r0]
	mov	r0, fp
	bl	printf
	b	.L2412
.L2419:
	.align	2
.L2418:
	.word	.LANCHOR52
	.word	.LANCHOR225
	.word	.LC45
	.word	.LANCHOR83
	.word	.LC46
	.word	.LANCHOR15
	.word	.LANCHOR53
	.word	.LC47
	.word	.LANCHOR38
	.word	.LANCHOR180
	.word	.LANCHOR104
	.word	.LANCHOR57
	.word	.LANCHOR105
	.word	.LANCHOR58
	.word	.LC48
	.size	FtlDumpBlockInfo, .-FtlDumpBlockInfo
	.section	.text.FtlScanAllBlock,"ax",%progbits
	.align	1
	.global	FtlScanAllBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlScanAllBlock, %function
FtlScanAllBlock:
	@ args = 0, pretend = 0, frame = 64
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #88
	ldr	r6, .L2430
	ldr	r1, .L2430+4
	ldr	r0, .L2430+8
	bl	printf
	movs	r3, #0
	str	r3, [sp, #28]
.L2421:
	ldr	r3, .L2430+12
	ldrh	r0, [sp, #28]
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2429
	movs	r0, #0
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2429:
	add	r4, sp, #88
	add	r7, sp, #54
	strh	r0, [r4, #-48]!	@ movhi
	movw	r10, #65535
	bl	ftl_get_blk_mode
	ldr	r3, .L2430+16
	mov	fp, #36
	ldrh	r1, [sp, #28]
	ldr	r2, [r3]
	mov	r3, r0
	ldr	r0, .L2430+20
	ldrh	r2, [r2, r1, lsl #1]
	bl	printf
	mov	r0, r4
	bl	make_superblock
	ldr	r3, .L2430+24
	movs	r2, #0
	ldr	r0, [r6]
	mov	r4, r2
	ldrh	lr, [r3]
	ldr	r3, .L2430+28
	ldr	r3, [r3]
	str	r3, [sp, #32]
	ldr	r3, .L2430+32
	ldrh	ip, [r3]
	ldr	r3, .L2430+36
	ldr	r3, [r3]
	str	r3, [sp, #36]
	ldr	r3, .L2430+40
	ldrh	r8, [r3]
.L2422:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L2424
	ldr	r10, .L2430+44
	movs	r7, #0
	mov	r8, #36
	movs	r2, #0
	mov	r1, r4
	bl	FlashReadPages
.L2425:
	uxth	r3, r7
	cmp	r4, r3
	bhi	.L2426
	ldr	r10, .L2430+48
	movs	r7, #0
	mov	r8, #36
	movs	r2, #1
	mov	r1, r4
	ldr	r0, [r6]
	bl	FlashReadPages
.L2427:
	uxth	r3, r7
	cmp	r4, r3
	bhi	.L2428
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	str	r3, [sp, #28]
	b	.L2421
.L2424:
	ldrh	r3, [r7, #2]!
	cmp	r3, r10
	beq	.L2423
	mla	r1, fp, r4, r0
	ldr	r5, [sp, #32]
	lsls	r3, r3, #10
	str	r3, [r1, #4]
	mul	r3, ip, r4
	bic	r3, r3, #3
	add	r3, r3, r5
	ldr	r5, [sp, #36]
	str	r3, [r1, #8]
	mul	r3, r8, r4
	adds	r4, r4, #1
	uxth	r4, r4
	bic	r3, r3, #3
	add	r3, r3, r5
	str	r3, [r1, #12]
.L2423:
	adds	r2, r2, #1
	b	.L2422
.L2426:
	mul	r2, r8, r7
	ldr	r0, [r6]
	ldrh	r1, [sp, #40]
	adds	r7, r7, #1
	add	lr, r0, r2
	ldr	fp, [lr, #8]
	ldr	r3, [lr, #12]
	ldr	r5, [fp, #4]
	str	r5, [sp, #20]
	ldr	r5, [fp]
	str	r5, [sp, #16]
	ldr	r5, [r3, #12]
	str	r5, [sp, #12]
	ldr	r5, [r3, #8]
	str	r5, [sp, #8]
	ldr	r5, [r3, #4]
	str	r5, [sp, #4]
	ldr	r3, [r3]
	str	r3, [sp]
	ldr	r2, [r0, r2]
	mov	r0, r10
	ldr	r3, [lr, #4]
	bl	printf
	b	.L2425
.L2428:
	mul	r2, r8, r7
	ldr	r0, [r6]
	ldrh	r1, [sp, #40]
	adds	r7, r7, #1
	add	lr, r0, r2
	ldr	fp, [lr, #8]
	ldr	r3, [lr, #12]
	ldr	r5, [fp, #4]
	str	r5, [sp, #20]
	ldr	r5, [fp]
	str	r5, [sp, #16]
	ldr	r5, [r3, #12]
	str	r5, [sp, #12]
	ldr	r5, [r3, #8]
	str	r5, [sp, #8]
	ldr	r5, [r3, #4]
	str	r5, [sp, #4]
	ldr	r3, [r3]
	str	r3, [sp]
	ldr	r2, [r0, r2]
	mov	r0, r10
	ldr	r3, [lr, #4]
	bl	printf
	b	.L2427
.L2431:
	.align	2
.L2430:
	.word	.LANCHOR180
	.word	.LANCHOR226
	.word	.LC45
	.word	.LANCHOR41
	.word	.LANCHOR83
	.word	.LC49
	.word	.LANCHOR38
	.word	.LANCHOR104
	.word	.LANCHOR57
	.word	.LANCHOR105
	.word	.LANCHOR58
	.word	.LC50
	.word	.LC51
	.size	FtlScanAllBlock, .-FtlScanAllBlock
	.section	.text.FtlMapTblRecovery,"ax",%progbits
	.align	1
	.global	FtlMapTblRecovery
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlMapTblRecovery, %function
FtlMapTblRecovery:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, [r0, #24]
	movs	r1, #0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldrh	r7, [r0, #6]
	mov	r4, r0
	movs	r6, #0
	str	r3, [sp]
	ldr	r3, [r0, #16]
	ldr	r10, [r0, #12]
	lsls	r2, r7, #2
	str	r3, [sp, #12]
	ldrh	r3, [r0, #8]
	ldr	r0, [sp]
	str	r3, [sp, #4]
	bl	ftl_memset
	ldr	r2, .L2473
	ldr	r3, .L2473+4
	str	r6, [r4, #32]
	ldr	r1, [r2]
	mov	fp, r3
	str	r6, [r4, #28]
	str	r2, [sp, #8]
	str	r1, [r3, #8]
	ldr	r1, .L2473+8
	ldr	r5, [r1]
	movw	r1, #65535
	str	r5, [r3, #12]
	strh	r1, [r4]	@ movhi
	strh	r1, [r4, #2]	@ movhi
	movs	r1, #1
	str	r1, [r4, #36]
.L2433:
	ldr	r2, [sp, #4]
	sxth	r3, r6
	cmp	r3, r2
	bge	.L2452
	ldr	r2, [sp, #4]
	lsl	r8, r3, #1
	subs	r2, r2, #1
	cmp	r3, r2
	bne	.L2434
	ldrh	r0, [r10, r3, lsl #1]
	movs	r1, #1
	str	r3, [sp, #4]
	mov	fp, #0
	bl	FtlGetLastWrittenPage
	ldr	r3, [sp, #12]
	add	r8, r8, r10
	strh	r6, [r4]	@ movhi
	sxth	r10, r0
	ldr	r6, .L2473+4
	adds	r0, r0, #1
	mov	r2, r3
	ldr	r3, [sp, #4]
	strh	r0, [r4, #2]	@ movhi
	ldr	r3, [r2, r3, lsl #2]
	str	r3, [r4, #28]
.L2435:
	sxth	r2, fp
	cmp	r2, r10
	ble	.L2438
.L2452:
	mov	r0, r4
	bl	ftl_free_no_use_map_blk
	ldr	r3, .L2473+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2440
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L2440:
	mov	r0, r4
	bl	ftl_map_blk_gc
	mov	r0, r4
	bl	ftl_map_blk_gc
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2438:
	ldrh	r1, [r8]
	ldr	r0, .L2473+4
	orr	r2, r2, r1, lsl #10
	str	r2, [r6, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r3, .L2473+16
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbz	r2, .L2436
	ldr	r2, [r6, #12]
	ldr	r2, [r2, #12]
	str	r2, [sp, #4]
	cbz	r2, .L2436
	ldr	r1, .L2473+20
	ldr	r0, [r6, #8]
	ldrh	r1, [r1]
	bl	js_hash
	ldr	r2, [sp, #4]
	cmp	r2, r0
	itt	ne
	movne	r2, #-1
	strne	r2, [r6]
.L2436:
	ldr	r2, [r6]
	adds	r2, r2, #1
	beq	.L2437
	ldrh	r2, [r5, #8]
	cmp	r7, r2
	bls	.L2437
	ldrh	r1, [r4, #4]
	ldrh	r0, [r5]
	cmp	r0, r1
	ittt	eq
	ldreq	r1, [r6, #4]
	ldreq	r3, [sp]
	streq	r1, [r3, r2, lsl #2]
.L2437:
	add	fp, fp, #1
	b	.L2435
.L2434:
	ldr	r2, [sp, #8]
	ldr	r0, .L2473+4
	ldr	r2, [r2]
	str	r2, [fp, #8]
	add	r2, r10, r8
	ldr	r8, .L2473+12
	str	r2, [sp, #16]
	ldrh	r2, [r10, r3, lsl #1]
	ldrh	r3, [r8]
	subs	r3, r3, #1
	orr	r3, r3, r2, lsl #10
	movs	r2, #1
	mov	r1, r2
	str	r3, [fp, #4]
	bl	FlashReadPages
	ldr	r3, [fp]
	adds	r3, r3, #1
	beq	.L2454
	ldrh	r2, [r5]
	ldrh	r3, [r4, #4]
	cmp	r2, r3
	bne	.L2454
	ldrh	r2, [r5, #8]
	movw	r3, #64245
	cmp	r2, r3
	beq	.L2442
.L2454:
	mov	r8, #0
.L2443:
	ldr	r2, .L2473+12
	sxth	r3, r8
	ldrh	r2, [r2]
	cmp	r3, r2
	bge	.L2450
	ldr	r2, [sp, #16]
	ldr	r0, .L2473+4
	ldrh	r2, [r2]
	orr	r3, r3, r2, lsl #10
	movs	r2, #1
	mov	r1, r2
	str	r3, [fp, #4]
	bl	FlashReadPages
	ldr	r3, .L2473+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2447
	ldr	r3, [fp, #12]
	ldr	r3, [r3, #12]
	str	r3, [sp, #20]
	cbz	r3, .L2447
	ldr	r2, .L2473+20
	ldr	r0, [fp, #8]
	ldrh	r1, [r2]
	bl	js_hash
	ldr	r3, [sp, #20]
	cmp	r3, r0
	itt	ne
	movne	r3, #-1
	strne	r3, [fp]
.L2447:
	ldr	r3, [fp]
	adds	r3, r3, #1
	beq	.L2448
	ldrh	r3, [r5, #8]
	cmp	r7, r3
	bls	.L2448
	ldrh	r1, [r5]
	ldrh	r2, [r4, #4]
	cmp	r1, r2
	ittt	eq
	ldreq	r2, [fp, #4]
	ldreq	r1, [sp]
	streq	r2, [r1, r3, lsl #2]
.L2448:
	add	r8, r8, #1
	b	.L2443
.L2442:
	ldr	r3, [sp, #8]
	movs	r1, #0
	ldrh	r2, [r8]
	ldr	ip, [r3]
	subs	r2, r2, #1
.L2444:
	sxth	r3, r1
	cmp	r3, r2
	blt	.L2446
.L2450:
	adds	r6, r6, #1
	b	.L2433
.L2446:
	lsls	r0, r3, #3
	ldr	r3, [ip, r3, lsl #3]
	adds	r1, r1, #1
	uxth	lr, r3
	cmp	r7, lr
	itttt	hi
	addhi	r0, r0, ip
	ldrhi	r3, [sp]
	ldrhi	r0, [r0, #4]
	strhi	r0, [r3, lr, lsl #2]
	b	.L2444
.L2474:
	.align	2
.L2473:
	.word	.LANCHOR183
	.word	.LANCHOR203
	.word	.LANCHOR188
	.word	.LANCHOR53
	.word	.LANCHOR2
	.word	.LANCHOR57
	.size	FtlMapTblRecovery, .-FtlMapTblRecovery
	.section	.text.FtlLoadVonderInfo,"ax",%progbits
	.align	1
	.global	FtlLoadVonderInfo
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlLoadVonderInfo, %function
FtlLoadVonderInfo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	r3, .L2476
	ldr	r0, .L2476+4
	ldrh	r3, [r3]
	strh	r3, [r0, #10]	@ movhi
	movw	r3, #61574
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L2476+8
	ldrh	r3, [r3]
	strh	r3, [r0, #8]	@ movhi
	ldr	r3, .L2476+12
	ldrh	r3, [r3]
	strh	r3, [r0, #6]	@ movhi
	ldr	r3, .L2476+16
	ldr	r3, [r3]
	str	r3, [r0, #12]
	ldr	r3, .L2476+20
	ldr	r3, [r3]
	str	r3, [r0, #16]
	ldr	r3, .L2476+24
	ldr	r3, [r3]
	str	r3, [r0, #20]
	ldr	r3, .L2476+28
	ldr	r3, [r3]
	str	r3, [r0, #24]
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L2477:
	.align	2
.L2476:
	.word	.LANCHOR61
	.word	.LANCHOR216
	.word	.LANCHOR70
	.word	.LANCHOR62
	.word	.LANCHOR71
	.word	.LANCHOR193
	.word	.LANCHOR192
	.word	.LANCHOR194
	.size	FtlLoadVonderInfo, .-FtlLoadVonderInfo
	.section	.text.FtlLoadMapInfo,"ax",%progbits
	.align	1
	.global	FtlLoadMapInfo
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlLoadMapInfo, %function
FtlLoadMapInfo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	FtlL2PDataInit
	ldr	r0, .L2479
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L2480:
	.align	2
.L2479:
	.word	.LANCHOR127
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
	.section	.text.ftl_scan_all_ppa,"ax",%progbits
	.align	1
	.global	ftl_scan_all_ppa
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_scan_all_ppa, %function
ftl_scan_all_ppa:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r4, .L2486
	sub	sp, sp, #24
	ldr	r7, .L2486+4
	ldrh	r1, [r4]
	mov	r8, r4
	ldr	r4, .L2486+8
	ldrh	r2, [r7]
	ldr	r0, .L2486+12
	bl	printf
.L2482:
	ldrh	r3, [r8]
	cmp	r6, r3
	bcs	.L2484
	lsl	fp, r6, #10
	movs	r5, #0
	ldr	r10, .L2486+32
	b	.L2485
.L2483:
	add	r3, r5, fp
	movs	r2, #0
	str	r3, [r4, #4]
	movs	r1, #1
	ldr	r3, [r10]
	mov	r0, r4
	str	r2, [r4]
	adds	r5, r5, #1
	str	r3, [r4, #8]
	ldr	r3, .L2486+16
	ldr	r3, [r3]
	str	r3, [r4, #12]
	bl	FlashReadPages
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #12]
	ldr	r0, .L2486+20
	ldr	r1, [r2, #4]
	str	r1, [sp, #16]
	ldr	r2, [r2]
	str	r2, [sp, #12]
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	ldr	r2, [r3, #8]
	str	r2, [sp, #4]
	ldr	r2, [r3, #4]
	str	r2, [sp]
	ldr	r3, [r3]
	ldr	r2, [r4]
	ldr	r1, [r4, #4]
	bl	printf
.L2485:
	ldrh	r3, [r7]
	cmp	r5, r3
	bcc	.L2483
	adds	r6, r6, #1
	b	.L2482
.L2484:
	ldr	r1, .L2486+24
	ldr	r0, .L2486+28
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L2487:
	.align	2
.L2486:
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR203
	.word	.LC52
	.word	.LANCHOR188
	.word	.LC53
	.word	.LANCHOR227
	.word	.LC54
	.word	.LANCHOR183
	.size	ftl_scan_all_ppa, .-ftl_scan_all_ppa
	.section	.text.FlashReadFacBbtData,"ax",%progbits
	.align	1
	.global	FlashReadFacBbtData
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadFacBbtData, %function
FlashReadFacBbtData:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r2
	ldr	r2, .L2501
	sub	sp, sp, #48
	mov	r6, r1
	mov	r4, r0
	ldr	r7, .L2501+4
	ldrh	r3, [r2, #14]
	ldrh	r2, [r2, #12]
	smulbb	r3, r3, r2
	ldr	r2, [r7]
	uxth	r3, r3
	str	r2, [sp, #20]
	ldr	r2, .L2501+8
	subs	r5, r3, #1
	mul	r10, r6, r3
	uxth	r5, r5
	subs	r3, r3, #15
	ldr	r1, [r2]
	mov	r8, r2
	str	r1, [sp, #24]
.L2489:
	cmp	r3, r5
	ble	.L2496
	mov	r0, #-1
	b	.L2488
.L2496:
	add	r2, r5, r10
	add	r0, sp, #12
	lsls	r2, r2, #10
	str	r3, [sp, #4]
	str	r2, [sp, #16]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #4]
	adds	r2, r2, #1
	beq	.L2490
	ldr	r2, [r8]
	ldrh	r1, [r2]
	movw	r2, #61664
	cmp	r1, r2
	bne	.L2490
	cbz	r4, .L2497
	cbz	r6, .L2492
.L2495:
	mov	r2, fp
	ldr	r1, [r7]
	mov	r0, r4
	bl	ftl_memcpy
	movs	r3, #4
	ldr	r0, .L2501+12
	mov	r2, r3
	mov	r1, r4
	bl	rknand_print_hex
	movs	r0, #0
.L2488:
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2492:
	ldr	r1, [r7]
	mov	ip, #1
	ldr	r5, .L2501+16
.L2493:
	ldr	r0, [r5]
	uxth	r3, r6
	adds	r6, r6, #1
	cmp	r3, r0
	bcs	.L2495
	lsrs	r0, r3, #5
	and	r3, r3, #31
	lsl	r3, ip, r3
	ldr	r2, [r1, r0, lsl #2]
	orrs	r3, r3, r2
	str	r3, [r1, r0, lsl #2]
	b	.L2493
.L2490:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2489
.L2497:
	mov	r0, r4
	b	.L2488
.L2502:
	.align	2
.L2501:
	.word	.LANCHOR14
	.word	.LANCHOR147
	.word	.LANCHOR197
	.word	.LC55
	.word	.LANCHOR149
	.size	FlashReadFacBbtData, .-FlashReadFacBbtData
	.section	.text.FlashGetBadBlockList,"ax",%progbits
	.align	1
	.global	FlashGetBadBlockList
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashGetBadBlockList, %function
FlashGetBadBlockList:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldr	r3, .L2513
	ldr	r6, .L2513+4
	ldr	r3, [r3]
	ldr	r0, [r6]
	ldrb	r4, [r3, #13]	@ zero_extendqisi2
	ldrh	r3, [r3, #14]
	smulbb	r4, r4, r3
	uxth	r4, r4
	adds	r2, r4, #7
	asrs	r2, r2, #3
	bl	FlashReadFacBbtData
	adds	r0, r0, #1
	bne	.L2504
.L2508:
	movs	r3, #0
.L2505:
	movw	r2, #65535
	movs	r0, #0
	strh	r2, [r5, r3, lsl #1]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L2504:
	ldr	r7, [r6]
	movs	r2, #0
	lsr	ip, r4, #4
	mov	r3, r2
	subs	r4, r4, #1
	mov	lr, #1
.L2506:
	uxth	r1, r2
	cmp	r1, r4
	bge	.L2505
	lsrs	r6, r1, #5
	and	r0, r1, #31
	lsl	r0, lr, r0
	adds	r2, r2, #1
	ldr	r6, [r7, r6, lsl #2]
	tst	r0, r6
	ittt	ne
	addne	r0, r3, #1
	strhne	r1, [r5, r3, lsl #1]	@ movhi
	uxthne	r3, r0
	cmp	r3, ip
	bcc	.L2506
	b	.L2508
.L2514:
	.align	2
.L2513:
	.word	.LANCHOR18
	.word	.LANCHOR153
	.size	FlashGetBadBlockList, .-FlashGetBadBlockList
	.section	.text.FtlMakeBbt,"ax",%progbits
	.align	1
	.global	FtlMakeBbt
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlMakeBbt, %function
FtlMakeBbt:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2535
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r7, [r3]
	cmp	r7, #0
	bne	.L2516
	ldr	r8, .L2535+40
	ldr	r4, .L2535+4
	bl	FtlBbtMemInit
	sub	r10, r8, #18
	bl	FtlLoadFactoryBbt
.L2517:
	ldr	r3, .L2535+8
	ldrh	r3, [r3]
	cmp	r7, r3
	bcc	.L2523
	ldr	r5, .L2535+12
	movs	r4, #0
.L2524:
	ldrh	r3, [r5]
	uxth	r0, r4
	adds	r4, r4, #1
	cmp	r3, r0
	bhi	.L2525
	ldr	r4, .L2535+16
	movw	r6, #65535
	ldrh	r5, [r4, #12]
	subs	r5, r5, #1
	uxth	r5, r5
.L2526:
	ldrh	r3, [r4, #12]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L2530
	mov	r0, r5
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L2527
	mov	r0, r5
	bl	FlashTestBlk
	cmp	r0, #0
	beq	.L2528
	mov	r0, r5
	bl	FtlBbmMapBadBlock
.L2527:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2526
.L2523:
	ldr	r3, .L2535+20
	movw	r1, #65535
	ldrh	r2, [r10, #2]!
	ldr	r0, [r3]
	ldr	r3, .L2535+24
	cmp	r2, r1
	str	r0, [r4, #8]
	ldr	fp, [r3]
	str	r3, [sp, #4]
	ldr	r3, .L2535+28
	str	fp, [r4, #12]
	beq	.L2518
	ldrh	r6, [r3]
	mov	r0, r4
	str	r3, [sp]
	mla	r6, r7, r6, r2
	lsls	r2, r6, #10
	str	r2, [r4, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r3, [sp]
	ldr	r1, [r4, #8]
	ldr	r0, [r8]
	ldrh	r2, [r3]
	adds	r2, r2, #7
	asrs	r2, r2, #3
	bl	ftl_memcpy
.L2519:
	uxth	r0, r6
	adds	r7, r7, #1
	add	r8, r8, #4
	bl	FtlBbmMapBadBlock
	b	.L2517
.L2518:
	mov	r1, r7
	str	r3, [sp]
	bl	FlashGetBadBlockList
	ldr	r1, [r8]
	ldr	r0, [r4, #8]
	bl	FtlBbt2Bitmap
	ldr	r3, [sp]
	ldrh	r5, [r3]
.L2521:
	subs	r5, r5, #1
	uxth	r5, r5
.L2520:
	ldr	r3, [sp]
	ldrh	r0, [r3]
	smlabb	r0, r0, r7, r5
	uxth	r0, r0
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L2521
	ldr	r3, [sp, #4]
	movs	r2, #16
	movs	r1, #0
	strh	r5, [r10]	@ movhi
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [sp]
	movw	r3, #61664
	strh	r3, [fp]	@ movhi
	movs	r3, #0
	str	r3, [fp, #4]
	ldrh	r6, [r2]
	ldrh	r3, [r10]
	ldr	r1, [r8]
	ldr	r0, [r4, #8]
	strh	r3, [fp, #2]	@ movhi
	mla	r6, r7, r6, r3
	lsls	r3, r6, #10
	str	r3, [r4, #4]
	ldr	r3, .L2535+32
	ldrh	r2, [r3]
	lsls	r2, r2, #2
	bl	ftl_memcpy
	movs	r2, #1
	mov	r0, r4
	mov	r1, r2
	bl	FlashEraseBlocks
	movs	r3, #1
	mov	r0, r4
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L2519
	uxth	r0, r6
	bl	FtlBbmMapBadBlock
	b	.L2520
.L2525:
	bl	FtlBbmMapBadBlock
	b	.L2524
.L2528:
	ldrh	r3, [r4]
	cmp	r3, r6
	bne	.L2529
	strh	r5, [r4]	@ movhi
	b	.L2527
.L2529:
	strh	r5, [r4, #4]	@ movhi
.L2530:
	ldr	r3, .L2535+36
	movs	r5, #0
	str	r5, [r4, #8]
	movs	r2, #2
	movs	r1, #1
	strh	r5, [r4, #2]	@ movhi
	ldr	r0, [r3]
	ldrh	r3, [r4]
	lsls	r3, r3, #10
	str	r3, [r0, #4]
	ldrh	r3, [r4, #4]
	lsls	r3, r3, #10
	str	r3, [r0, #40]
	bl	FlashEraseBlocks
	ldrh	r0, [r4]
	bl	FtlBbmMapBadBlock
	ldrh	r0, [r4, #4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldr	r3, [r4, #8]
	ldrh	r2, [r4, #4]
	strh	r5, [r4, #2]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #8]
	ldrh	r3, [r4]
	strh	r2, [r4]	@ movhi
	strh	r3, [r4, #4]	@ movhi
	bl	FtlBbmTblFlush
.L2516:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2536:
	.align	2
.L2535:
	.word	.LANCHOR76
	.word	.LANCHOR203
	.word	.LANCHOR45
	.word	.LANCHOR59
	.word	.LANCHOR74
	.word	.LANCHOR183
	.word	.LANCHOR188
	.word	.LANCHOR51
	.word	.LANCHOR123
	.word	.LANCHOR77
	.word	.LANCHOR74+28
	.size	FtlMakeBbt, .-FtlMakeBbt
	.section	.text.log2phys,"ax",%progbits
	.align	1
	.global	log2phys
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	log2phys, %function
log2phys:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r4, .L2555
	mov	fp, r0
	str	r2, [sp, #16]
	ldr	r2, [r4]
	ldr	r3, .L2555+4
	str	r1, [sp, #4]
	cmp	r0, r2
	ldrh	r5, [r3]
	bcc	.L2538
	ldr	r1, .L2555+8
	mov	r2, #884
	ldr	r0, .L2555+12
	bl	printf
	ldr	r1, .L2555+16
	ldr	r0, .L2555+20
	bl	printf
.L2538:
	ldr	r3, [r4]
	cmp	fp, r3
	bcs	.L2539
	adds	r3, r5, #7
	ldr	r5, .L2555+24
	lsr	r7, fp, r3
	str	r3, [sp, #8]
	ldr	r3, .L2555+28
	movs	r4, #12
	ldr	r1, [r5]
	uxth	r6, r7
	ldrh	r2, [r3]
	movs	r3, #0
.L2540:
	uxth	r10, r3
	cmp	r10, r2
	bcc	.L2545
	bl	select_l2p_ram_region
	muls	r4, r0, r4
	ldr	r3, [r5]
	mov	r10, r0
	ldrh	r1, [r3, r4]
	adds	r2, r3, r4
	movw	r3, #65535
	cmp	r1, r3
	beq	.L2546
	ldr	r3, [r2, #4]
	cmp	r3, #0
	bge	.L2546
	bl	flush_l2p_region
.L2546:
	ldr	r3, .L2555+32
	ldrh	r3, [r3]
	cmp	r3, r6
	bcs	.L2547
	ldr	r1, .L2555+36
	movw	r2, #526
	ldr	r0, .L2555+12
	bl	printf
	ldr	r1, .L2555+16
	ldr	r0, .L2555+20
	bl	printf
.L2547:
	ldr	r3, .L2555+40
	uxth	r7, r7
	ldr	r3, [r3]
	ldr	r3, [r3, r7, lsl #2]
	cmp	r3, #0
	bne	.L2548
	ldr	r2, [r5]
	movs	r1, #255
	str	r3, [sp, #12]
	adds	r0, r2, r4
	ldr	r2, .L2555+44
	ldr	r0, [r0, #8]
	ldrh	r2, [r2]
	bl	ftl_memset
	ldr	r2, [r5]
	ldr	r3, [sp, #12]
	adds	r1, r2, r4
	strh	r6, [r2, r4]	@ movhi
	str	r3, [r1, #4]
	b	.L2542
.L2539:
	ldr	r3, [sp, #16]
	mov	r0, #-1
	cbnz	r3, .L2537
	ldr	r3, [sp, #4]
	str	r0, [r3]
.L2537:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2545:
	adds	r3, r3, #1
	mla	r0, r4, r3, r1
	ldrh	r0, [r0, #-12]
	cmp	r0, r6
	bne	.L2540
.L2542:
	ldr	r2, [sp, #8]
	movs	r3, #1
	ldr	r0, [sp, #16]
	ldr	r1, .L2555+24
	lsls	r3, r3, r2
	movs	r2, #12
	subs	r3, r3, #1
	and	r3, r3, fp
	uxth	r3, r3
	cbnz	r0, .L2543
	ldr	r0, [r1]
	mla	r2, r2, r10, r0
	ldr	r2, [r2, #8]
	ldr	r3, [r2, r3, lsl #2]
	ldr	r2, [sp, #4]
	str	r3, [r2]
.L2544:
	ldr	r2, [r1]
	movs	r3, #12
	mla	r10, r3, r10, r2
	ldr	r3, [r10, #4]
	adds	r2, r3, #1
	beq	.L2553
	adds	r3, r3, #1
	str	r3, [r10, #4]
.L2553:
	movs	r0, #0
	b	.L2537
.L2543:
	ldr	r0, [r1]
	mla	r2, r2, r10, r0
	ldr	r0, [sp, #4]
	ldr	r4, [r0]
	ldr	r0, [r2, #8]
	str	r4, [r0, r3, lsl #2]
	ldr	r3, [r2, #4]
	orr	r3, r3, #-2147483648
	str	r3, [r2, #4]
	ldr	r3, .L2555+48
	strh	r6, [r3]	@ movhi
	b	.L2544
.L2548:
	ldr	r2, [r5]
	ldr	r8, .L2555+80
	str	r3, [sp, #20]
	add	r2, r2, r4
	ldr	r2, [r2, #8]
	mov	r0, r8
	str	r3, [r8, #4]
	str	r2, [r8, #8]
	ldr	r2, .L2555+52
	ldr	r2, [r2]
	str	r2, [r8, #12]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r3, [r8, #12]
	ldrh	r2, [r3, #8]
	str	r3, [sp, #12]
	ldr	r3, [sp, #20]
	cmp	r2, r6
	beq	.L2549
	mov	r2, r3
	mov	r1, r7
	ldr	r0, .L2555+56
	bl	printf
	movs	r3, #4
	ldr	r1, [r8, #12]
	mov	r2, r3
	ldr	r0, .L2555+60
	bl	rknand_print_hex
	ldr	r3, .L2555+32
	movs	r2, #4
	ldr	r1, .L2555+40
	ldr	r0, .L2555+64
	ldrh	r3, [r3]
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r3, .L2555+68
	movs	r2, #1
	str	r2, [r3]
.L2550:
	ldr	r3, [sp, #12]
	ldrh	r3, [r3, #8]
	cmp	r3, r6
	beq	.L2551
	ldr	r1, .L2555+36
	mov	r2, #552
	ldr	r0, .L2555+12
	bl	printf
	ldr	r1, .L2555+16
	ldr	r0, .L2555+20
	bl	printf
.L2551:
	ldr	r3, .L2555+24
	movs	r1, #0
	ldr	r3, [r3]
	adds	r2, r3, r4
	str	r1, [r2, #4]
	strh	r6, [r3, r4]	@ movhi
	b	.L2542
.L2549:
	ldr	r2, [r8]
	cmp	r2, #256
	bne	.L2550
	mov	r2, r3
	mov	r1, r7
	ldr	r0, .L2555+72
	bl	printf
	ldr	r3, [r5]
	mov	r1, r7
	ldr	r0, .L2555+76
	add	r3, r3, r4
	ldr	r2, [r3, #8]
	bl	FtlMapWritePage
	b	.L2550
.L2556:
	.align	2
.L2555:
	.word	.LANCHOR72
	.word	.LANCHOR56
	.word	.LANCHOR228
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR96
	.word	.LANCHOR67
	.word	.LANCHOR66
	.word	.LANCHOR229
	.word	.LANCHOR131
	.word	.LANCHOR57
	.word	.LANCHOR97
	.word	.LANCHOR188
	.word	.LC56
	.word	.LC27
	.word	.LC57
	.word	.LANCHOR76
	.word	.LC58
	.word	.LANCHOR127
	.word	.LANCHOR203
	.size	log2phys, .-log2phys
	.section	.text.FtlProgPages,"ax",%progbits
	.align	1
	.global	FtlProgPages
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlProgPages, %function
FtlProgPages:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r3
	ldr	r3, .L2577
	mov	r5, r0
	mov	r10, r1
	ldr	r7, [r3]
	mov	r8, r3
	cbnz	r7, .L2557
	ldr	r3, .L2577+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2572
	ldrb	r6, [r4, #8]	@ zero_extendqisi2
	subs	r3, r6, #1
	rsbs	r6, r3, #0
	adcs	r6, r6, r3
.L2559:
	ldr	fp, .L2577+40
	mov	r2, r6
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	mov	r1, r10
	mov	r0, r5
	bl	FlashProgPages
.L2560:
	cmp	r7, r10
	bne	.L2570
	ldr	r3, .L2577+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2557
	ldr	r1, .L2577+12
	movw	r2, #1605
	ldr	r0, .L2577+16
	bl	printf
	ldr	r1, .L2577+20
	ldr	r0, .L2577+24
	bl	printf
.L2557:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2572:
	mov	r6, r7
	b	.L2559
.L2563:
	ldr	r0, [r5, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r4]
	cmp	r3, r0
	bne	.L2561
	ldr	r1, [fp]
	ldrh	r0, [r4, #4]
	ldrh	r2, [r1, r3, lsl #1]
	subs	r2, r2, r0
	strh	r2, [r1, r3, lsl #1]	@ movhi
	ldr	r3, .L2577+28
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
.L2561:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L2562
	mov	r0, r4
	bl	allocate_new_data_superblock
.L2562:
	ldr	r2, .L2577+32
	ldr	r3, [r2, #96]
	adds	r3, r3, #1
	str	r3, [r2, #96]
	ldr	r0, [r5, #4]
	ubfx	r0, r0, #10, #16
	bl	FtlGcMarkBadPhyBlk
	mov	r0, r4
	bl	get_new_active_ppa
	mov	r2, r6
	str	r0, [r5, #4]
	str	r0, [sp, #12]
	movs	r1, #1
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	mov	r0, r5
	bl	FlashProgPages
	ldr	r3, [r8]
	cmp	r3, #0
	bne	.L2557
.L2570:
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L2563
	ldr	r3, .L2577+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2564
	ldr	r1, .L2577+12
	movw	r2, #1588
	ldr	r0, .L2577+16
	bl	printf
	ldr	r1, .L2577+20
	ldr	r0, .L2577+24
	bl	printf
.L2564:
	ldr	r3, [r5, #4]
	cbnz	r6, .L2565
.L2576:
	movs	r2, #1
	add	r1, sp, #12
	ldr	r0, [r5, #16]
	str	r3, [sp, #12]
	bl	log2phys
	ldr	r3, [r5, #12]
	ldr	r2, [r3, #12]
	ubfx	r0, r2, #10, #16
	str	r2, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r2, [sp, #4]
	mov	r3, r0
	adds	r2, r2, #1
	beq	.L2567
	ldr	r2, [fp]
	ldrh	r2, [r2, r0, lsl #1]
	cbnz	r2, .L2568
	mov	r1, r0
	str	r0, [sp, #4]
	ldr	r0, .L2577+36
	bl	printf
	ldr	r3, [sp, #4]
.L2568:
	mov	r0, r3
	bl	decrement_vpc_count
.L2567:
	adds	r7, r7, #1
	adds	r5, r5, #36
	b	.L2560
.L2565:
	orr	r3, r3, #-2147483648
	b	.L2576
.L2578:
	.align	2
.L2577:
	.word	.LANCHOR76
	.word	.LANCHOR15
	.word	.LANCHOR38
	.word	.LANCHOR230
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR52
	.word	.LANCHOR138
	.word	.LC59
	.word	.LANCHOR83
	.size	FtlProgPages, .-FtlProgPages
	.section	.text.FtlCacheWriteBack,"ax",%progbits
	.align	1
	.global	FtlCacheWriteBack
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlCacheWriteBack, %function
FtlCacheWriteBack:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	ldr	r3, .L2584
	ldr	r4, [r3]
	cbnz	r4, .L2580
	ldr	r5, .L2584+4
	ldr	r0, [r5]
	cbz	r0, .L2580
	ldr	r3, .L2584+8
	mov	r2, r4
	movs	r1, #1
	ldr	r3, [r3]
	bl	FtlProgPages
	str	r4, [r5]
.L2580:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2585:
	.align	2
.L2584:
	.word	.LANCHOR76
	.word	.LANCHOR132
	.word	.LANCHOR231
	.size	FtlCacheWriteBack, .-FtlCacheWriteBack
	.section	.text.FtlSysFlush,"ax",%progbits
	.align	1
	.global	FtlSysFlush
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlSysFlush, %function
FtlSysFlush:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	r3, .L2588
	ldr	r3, [r3]
	cbnz	r3, .L2587
	bl	FtlCacheWriteBack
	bl	l2p_flush
	movs	r0, #1
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2587:
	movs	r0, #0
	pop	{r3, pc}
.L2589:
	.align	2
.L2588:
	.word	.LANCHOR76
	.size	FtlSysFlush, .-FtlSysFlush
	.section	.text.FtlDeInit,"ax",%progbits
	.align	1
	.global	FtlDeInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlDeInit, %function
FtlDeInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	r3, .L2592
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L2591
	bl	FtlSysFlush
.L2591:
	movs	r0, #0
	pop	{r3, pc}
.L2593:
	.align	2
.L2592:
	.word	.LANCHOR232
	.size	FtlDeInit, .-FtlDeInit
	.section	.text.rk_ftl_de_init,"ax",%progbits
	.align	1
	.global	rk_ftl_de_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_ftl_de_init, %function
rk_ftl_de_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	bl	FlashDeInit
	bl	FtlDeInit
	pop	{r3, lr}
	b	FlashDeInit
	.size	rk_ftl_de_init, .-rk_ftl_de_init
	.section	.text.ftl_discard,"ax",%progbits
	.align	1
	.global	ftl_discard
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_discard, %function
ftl_discard:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2610
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r5, r2
	adds	r2, r1, r2
	mov	r6, r1
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L2603
	cmp	r5, #31
	bhi	.L2597
.L2598:
	movs	r0, #0
.L2595:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2597:
	ldr	r3, .L2610+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2598
	ldr	r8, .L2610+16
	bl	FtlCacheWriteBack
	mov	r0, r6
	ldrh	r4, [r8]
	mov	r1, r4
	bl	__aeabi_uidiv
	smulbb	r3, r0, r4
	mov	r7, r0
	subs	r6, r6, r3
	uxth	r6, r6
	cbz	r6, .L2599
	subs	r4, r4, r6
	adds	r7, r7, #1
	cmp	r4, r5
	it	cs
	movcs	r4, r5
	uxth	r4, r4
	subs	r5, r5, r4
.L2599:
	ldr	r4, .L2610+8
	mov	r3, #-1
	ldr	r6, .L2610+12
	str	r3, [sp, #4]
.L2600:
	ldrh	r3, [r8]
	cmp	r5, r3
	bcs	.L2602
	ldr	r3, .L2610+8
	ldr	r2, [r3]
	cmp	r2, #32
	bls	.L2598
	movs	r4, #0
	str	r4, [r3]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L2598
.L2602:
	movs	r2, #0
	mov	r1, sp
	mov	r0, r7
	bl	log2phys
	ldr	r3, [sp]
	adds	r3, r3, #1
	beq	.L2601
	ldr	r3, [r4]
	movs	r2, #1
	add	r1, sp, #4
	mov	r0, r7
	adds	r3, r3, #1
	str	r3, [r4]
	ldr	r3, [r6]
	adds	r3, r3, #1
	str	r3, [r6]
	bl	log2phys
	ldr	r0, [sp]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	bl	decrement_vpc_count
.L2601:
	ldrh	r3, [r8]
	adds	r7, r7, #1
	subs	r5, r5, r3
	b	.L2600
.L2603:
	mov	r0, #-1
	b	.L2595
.L2611:
	.align	2
.L2610:
	.word	.LANCHOR68
	.word	.LANCHOR76
	.word	.LANCHOR233
	.word	.LANCHOR163
	.word	.LANCHOR55
	.size	ftl_discard, .-ftl_discard
	.section	.text.FtlCheckVpc,"ax",%progbits
	.align	1
	.global	FtlCheckVpc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlCheckVpc, %function
FtlCheckVpc:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r6, .L2636
	ldr	r5, .L2636+4
	ldr	r1, .L2636+8
	ldr	r0, .L2636+12
	bl	printf
	mov	r2, #8192
	movs	r1, #0
	ldr	r0, .L2636+4
	bl	memset
.L2613:
	ldr	r3, [r6]
	cmp	r4, r3
	bcc	.L2615
	ldr	r10, .L2636+56
	movs	r4, #0
	ldr	r7, .L2636+16
	mov	r6, r4
.L2616:
	ldrh	r2, [r10]
	uxth	r3, r4
	cmp	r2, r3
	bhi	.L2618
	ldr	r3, .L2636+20
	ldr	r4, [r3]
	cbz	r4, .L2619
	ldr	r3, .L2636+24
	mov	r8, #0
	ldr	r5, .L2636+28
	ldr	r10, .L2636+16
	ldrh	r7, [r3]
	ldr	r3, [r5]
	ldr	fp, .L2636+4
	subs	r4, r4, r3
	ldr	r3, .L2636+32
	asrs	r4, r4, #1
	muls	r4, r3, r4
	uxth	r4, r4
.L2620:
	uxth	r3, r8
	cmp	r7, r3
	bls	.L2619
	ldr	r3, [r10]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L2621
	movs	r6, #1
	ldrh	r3, [fp, r4, lsl #1]
	mov	r1, r4
	ldr	r0, .L2636+36
	bl	printf
.L2621:
	movs	r3, #6
	ldr	r2, [r5]
	muls	r4, r3, r4
	movw	r3, #65535
	add	r8, r8, #1
	ldrh	r4, [r2, r4]
	cmp	r4, r3
	bne	.L2620
.L2619:
	cbz	r6, .L2612
	ldr	r1, .L2636+8
	mov	r2, #1688
	ldr	r0, .L2636+40
	bl	printf
	ldr	r1, .L2636+44
	ldr	r0, .L2636+48
	bl	printf
.L2612:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2615:
	movs	r2, #0
	add	r1, sp, #4
	mov	r0, r4
	bl	log2phys
	ldr	r0, [sp, #4]
	adds	r3, r0, #1
	beq	.L2614
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r5, r0, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r5, r0, lsl #1]	@ movhi
.L2614:
	adds	r4, r4, #1
	b	.L2613
.L2618:
	ldr	r3, [r7]
	uxth	r5, r4
	ldr	r8, .L2636+4
	ldrh	r2, [r3, r5, lsl #1]
	ldrh	r3, [r8, r5, lsl #1]
	cmp	r2, r3
	beq	.L2617
	mov	r1, r5
	ldr	r0, .L2636+52
	bl	printf
	ldr	r3, [r7]
	movw	r2, #65535
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, r2
	beq	.L2617
	ldrh	r2, [r8, r5, lsl #1]
	cmp	r2, r3
	it	hi
	movhi	r6, #1
.L2617:
	adds	r4, r4, #1
	b	.L2616
.L2637:
	.align	2
.L2636:
	.word	.LANCHOR72
	.word	check_valid_page_count_table
	.word	.LANCHOR234
	.word	.LC45
	.word	.LANCHOR83
	.word	.LANCHOR87
	.word	.LANCHOR88
	.word	.LANCHOR81
	.word	-1431655765
	.word	.LC61
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC60
	.word	.LANCHOR40
	.size	FtlCheckVpc, .-FtlCheckVpc
	.section	.text.Ftlscanalldata,"ax",%progbits
	.align	1
	.global	Ftlscanalldata
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	Ftlscanalldata, %function
Ftlscanalldata:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	movs	r5, #0
	ldr	r7, .L2652
	sub	sp, sp, #32
	movs	r1, #0
	ldr	r8, .L2652+24
	ldr	r0, .L2652+4
	bl	printf
.L2639:
	ldr	r3, [r7]
	cmp	r5, r3
	bcc	.L2645
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2645:
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r5
	bl	log2phys
	ubfx	r3, r5, #0, #11
	cbnz	r3, .L2640
	ldr	r2, [sp, #28]
	mov	r1, r5
	mov	r0, r8
	bl	printf
.L2640:
	ldr	r3, [sp, #28]
	adds	r2, r3, #1
	beq	.L2642
	ldr	r4, .L2652+8
	movs	r2, #0
	movs	r1, #1
	str	r3, [r4, #4]
	mov	r0, r4
	ldr	r3, .L2652+12
	str	r5, [r4, #16]
	str	r2, [r4]
	ldr	r3, [r3]
	str	r3, [r4, #8]
	ldr	r3, .L2652+16
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FlashReadPages
	ldr	r3, [r4]
	cmp	r3, #256
	beq	.L2643
	adds	r3, r3, #1
	beq	.L2643
	ldr	r3, [r6, #8]
	cmp	r5, r3
	beq	.L2642
.L2643:
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #12]
	ldr	r0, .L2652+20
	ldr	r1, [r2, #4]
	str	r1, [sp, #16]
	mov	r1, r5
	ldr	r2, [r2]
	str	r2, [sp, #12]
	ldr	r2, [r3, #12]
	str	r2, [sp, #8]
	ldr	r2, [r3, #8]
	str	r2, [sp, #4]
	ldr	r2, [r3, #4]
	str	r2, [sp]
	ldr	r2, [r4, #4]
	ldr	r3, [r3]
	bl	printf
.L2642:
	adds	r5, r5, #1
	b	.L2639
.L2653:
	.align	2
.L2652:
	.word	.LANCHOR72
	.word	.LC62
	.word	.LANCHOR203
	.word	.LANCHOR183
	.word	.LANCHOR188
	.word	.LC64
	.word	.LC63
	.size	Ftlscanalldata, .-Ftlscanalldata
	.section	.text.FtlReUsePrevPpa,"ax",%progbits
	.align	1
	.global	FtlReUsePrevPpa
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlReUsePrevPpa, %function
FtlReUsePrevPpa:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r6, r0
	ldr	r5, .L2664
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r2, [r5]
	mov	r7, r0
	ldrh	r3, [r2, r0, lsl #1]
	cmp	r3, #0
	bne	.L2655
	ldr	r2, .L2664+4
	ldr	r4, [r2]
	cmp	r4, #0
	beq	.L2656
	ldr	r2, .L2664+8
	movw	lr, #65535
	ldr	ip, .L2664+32
	ldr	r0, .L2664+12
	ldr	r2, [r2]
	ldrh	r1, [r0]
	mov	r8, r0
	subs	r4, r4, r2
	asrs	r4, r4, #1
	mul	r4, ip, r4
	mov	ip, #6
	uxth	r4, r4
.L2657:
	uxth	r0, r3
	cmp	r1, r0
	bls	.L2656
	cmp	r4, r7
	bne	.L2658
	mov	r1, r4
	ldr	r0, .L2664+4
	bl	List_remove_node
	ldrh	r3, [r8]
	cbnz	r3, .L2659
	ldr	r1, .L2664+16
	movw	r2, #2099
	ldr	r0, .L2664+20
	bl	printf
	ldr	r1, .L2664+24
	ldr	r0, .L2664+28
	bl	printf
.L2659:
	ldrh	r3, [r8]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r8]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r2, [r5]
	ldrh	r3, [r2, r7, lsl #1]
.L2655:
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	b	.L2656
.L2658:
	mul	r4, ip, r4
	adds	r3, r3, #1
	ldrh	r4, [r2, r4]
	cmp	r4, lr
	bne	.L2657
.L2656:
	movs	r2, #1
	add	r1, sp, #4
	mov	r0, r6
	bl	log2phys
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2665:
	.align	2
.L2664:
	.word	.LANCHOR83
	.word	.LANCHOR87
	.word	.LANCHOR81
	.word	.LANCHOR88
	.word	.LANCHOR235
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	-1431655765
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
	.section	.text.FtlRecoverySuperblock,"ax",%progbits
	.align	1
	.global	FtlRecoverySuperblock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlRecoverySuperblock, %function
FtlRecoverySuperblock:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r3, [r0]
	movw	r2, #65535
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r0
	sub	sp, sp, #56
	cmp	r3, r2
	beq	.L2827
	ldrh	r3, [r0, #2]
	str	r3, [sp, #12]
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	str	r3, [sp, #28]
	ldr	r3, .L2836
	ldrh	r3, [r3]
	cmp	r3, r1
	mov	r3, #0
	bne	.L2669
	strh	r3, [r0, #4]	@ movhi
.L2834:
	strb	r3, [r10, #6]
.L2827:
	movs	r0, #0
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2669:
	ldrh	r0, [r0, #16]
.L2670:
	cmp	r0, r2
	uxth	r5, r3
	add	r3, r3, #1
	beq	.L2671
	ldrb	r1, [r10, #8]	@ zero_extendqisi2
	cmp	r1, #1
	bne	.L2672
	bl	FtlGetLastWrittenPage
	adds	r6, r0, #1
	mov	r4, r0
	beq	.L2673
	ldr	r3, .L2836+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2751
	ldr	r3, .L2836+8
	ldrh	r5, [r3, r0, lsl #1]
.L2674:
	ldr	r3, .L2836+12
	movw	r8, #65535
	mov	fp, #36
	ldrh	ip, [r3]
	ldr	r3, .L2836+16
	ldr	r0, [r3]
	ldr	r3, .L2836+20
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L2836+24
	ldrh	lr, [r3]
	add	r3, r10, #16
	str	r3, [sp, #20]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r6, r3
.L2675:
	uxth	r2, r3
	cmp	ip, r2
	bhi	.L2679
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L2752
	ldr	r3, .L2836+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #0
	it	ne
	movne	r3, #1
.L2828:
	str	r3, [sp, #36]
	mov	r1, r6
	ldr	r2, [sp, #36]
	movs	r7, #0
	bl	FlashReadPages
	ldr	r3, .L2836+28
	movw	fp, #65535
	ldr	r8, .L2836+16
	ldr	r3, [r3]
	subs	r3, r3, #1
	str	r3, [sp, #4]
.L2681:
	uxth	r3, r7
	cmp	r6, r3
	bhi	.L2686
	bne	.L2684
	adds	r4, r4, #1
	uxth	r3, r4
	str	r3, [sp, #8]
	ldr	r3, [r8]
	ldr	r0, [r3, #4]
.L2829:
	ubfx	r0, r0, #10, #16
	bl	P2V_plane
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	str	r0, [sp, #16]
	cmp	r3, #1
	bne	.L2688
	ldr	r2, .L2836+4
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L2688
	ldr	r1, [sp, #8]
	ldr	r2, .L2836+8
	ldrh	r2, [r2, r1, lsl #1]
	str	r2, [sp, #8]
.L2688:
	ldr	r2, .L2836
	ldr	r1, [sp, #8]
	ldrh	r2, [r2]
	cmp	r2, r1
	bne	.L2689
	ldrh	r2, [sp, #8]
	strh	r2, [r10, #2]	@ movhi
	movs	r2, #0
	strb	r2, [r10, #6]
	strh	r2, [r10, #4]	@ movhi
.L2689:
	ldr	r2, [sp, #8]
	ldr	r1, [sp, #12]
	cmp	r2, r1
	bne	.L2690
	ldr	r2, [sp, #16]
	ldr	r1, [sp, #28]
	cmp	r2, r1
	bne	.L2690
.L2835:
	ldr	r1, [sp, #8]
	mov	r0, r10
	bl	ftl_sb_update_avl_pages
	b	.L2827
.L2671:
	uxth	r1, r3
	adds	r1, r1, #8
	ldrh	r0, [r10, r1, lsl #1]
	b	.L2670
.L2672:
	movs	r1, #0
	bl	FtlGetLastWrittenPage
	mov	r4, r0
	adds	r0, r0, #1
	beq	.L2673
.L2751:
	mov	r5, r4
	b	.L2674
.L2673:
	ldr	r3, [sp, #12]
	cbz	r3, .L2676
	ldr	r1, .L2836+32
	movw	r2, #2170
	ldr	r0, .L2836+36
	bl	printf
	ldr	r1, .L2836+40
	ldr	r0, .L2836+44
	bl	printf
.L2676:
	ldr	r3, [sp, #28]
	cbz	r3, .L2677
	cmp	r5, r3
	beq	.L2677
	ldr	r1, .L2836+32
	movw	r2, #2171
	ldr	r0, .L2836+36
	bl	printf
	ldr	r1, .L2836+40
	ldr	r0, .L2836+44
	bl	printf
.L2677:
	movs	r3, #0
	strh	r3, [r10, #2]	@ movhi
	b	.L2834
.L2679:
	ldr	r1, [sp, #4]
	ldrh	r2, [r1], #2
	cmp	r2, r8
	str	r1, [sp, #4]
	beq	.L2678
	mla	r1, fp, r6, r0
	orr	r2, r5, r2, lsl #10
	str	r2, [r1, #4]
	movs	r2, #0
	str	r2, [r1, #8]
	mul	r2, lr, r6
	adds	r6, r6, #1
	uxth	r6, r6
	bic	r2, r2, #3
	mov	r7, r2
	ldr	r2, [sp, #8]
	add	r7, r7, r2
	str	r7, [r1, #12]
.L2678:
	adds	r3, r3, #1
	b	.L2675
.L2752:
	movs	r3, #0
	b	.L2828
.L2686:
	movs	r3, #36
	ldr	r1, [r8]
	muls	r3, r7, r3
	adds	r2, r1, r3
	ldr	r3, [r1, r3]
	cbnz	r3, .L2682
	ldr	r2, [r2, #12]
	ldr	r3, [r2, #4]
	adds	r1, r3, #1
	beq	.L2683
	ldr	r1, .L2836+28
	mov	r0, r3
	ldr	r1, [r1]
	bl	ftl_cmp_data_ver
	cbz	r0, .L2683
	ldr	r1, .L2836+28
	adds	r3, r3, #1
	str	r3, [r1]
.L2683:
	ldr	r3, [r2]
	adds	r3, r3, #1
	bne	.L2685
.L2684:
	uxth	r3, r4
	uxth	r7, r7
	str	r3, [sp, #8]
	movs	r2, #36
	ldr	r3, [r8]
	mla	r7, r2, r7, r3
	ldr	r0, [r7, #4]
	b	.L2829
.L2682:
	ldr	r1, [r2, #4]
	uxth	fp, r5
	ldr	r0, .L2836+48
	bl	printf
	ldrh	r2, [r10]
	ldr	r3, .L2836+52
	strh	r2, [r3]	@ movhi
.L2685:
	adds	r7, r7, #1
	b	.L2681
.L2690:
	movw	r2, #65535
	cmp	fp, r2
	bne	.L2691
	cmp	r3, #0
	bne	.L2692
.L2691:
	ldr	r3, .L2836+56
	uxth	fp, r5
	uxth	r5, r5
	mov	r7, #-1
	mov	r6, r7
	ldr	r2, [r3]
	adds	r2, r2, #1
	itt	eq
	ldreq	r2, [sp, #4]
	streq	r2, [r3]
	ldr	r3, [r3]
	str	r3, [sp, #24]
	ldr	r3, [sp, #12]
	adds	r3, r3, #7
	cmp	r5, r3
	itet	gt
	subgt	r4, fp, #7
	ldrle	r4, [sp, #12]
	uxthgt	r4, r4
.L2695:
	cmp	r4, fp
	bhi	.L2710
	ldr	r3, .L2836+12
	movw	lr, #65535
	mov	ip, #36
	ldrh	r8, [r3]
	ldr	r3, .L2836+16
	ldr	r0, [r3]
	ldr	r3, [sp, #20]
	str	r3, [sp, #32]
	movs	r3, #0
	mov	r5, r3
	b	.L2711
.L2697:
	ldr	r1, [sp, #32]
	ldrh	r2, [r1], #2
	cmp	r2, lr
	str	r1, [sp, #32]
	beq	.L2696
	mla	r1, ip, r5, r0
	adds	r5, r5, #1
	orr	r2, r4, r2, lsl #10
	uxth	r5, r5
	str	r2, [r1, #4]
.L2696:
	adds	r3, r3, #1
.L2711:
	uxth	r2, r3
	cmp	r8, r2
	bhi	.L2697
	mov	r1, r5
	ldr	r2, [sp, #36]
	bl	FlashReadPages
	ldr	r2, .L2836+4
	movs	r1, #36
	ldr	r3, .L2836+56
	movs	r0, #0
	movw	ip, #65535
	ldrb	lr, [r2]	@ zero_extendqisi2
	ldr	r2, .L2836+16
	ldr	r3, [r3]
	ldr	r2, [r2]
	mla	r5, r1, r5, r2
.L2698:
	cmp	r5, r2
	bne	.L2708
	cbz	r0, .L2709
	ldr	r2, .L2836+56
	str	r3, [r2]
.L2709:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L2695
.L2837:
	.align	2
.L2836:
	.word	.LANCHOR52
	.word	.LANCHOR15
	.word	.LANCHOR16
	.word	.LANCHOR38
	.word	.LANCHOR180
	.word	.LANCHOR105
	.word	.LANCHOR58
	.word	.LANCHOR160
	.word	.LANCHOR236
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC65
	.word	.LANCHOR237
	.word	.LANCHOR136
.L2708:
	ldr	r1, [r2]
	cbnz	r1, .L2699
	ldr	r1, [r2, #12]
	ldrh	r8, [r1]
	cmp	r8, ip
	beq	.L2755
	ldr	r1, [r1, #4]
	cmp	r1, #-1
	beq	.L2755
	adds	r0, r7, #1
	bne	.L2757
	ldr	r0, .L2838
	ldrh	r0, [r0, r4, lsl #1]
	cmp	r0, ip
	bne	.L2701
	cmp	lr, #0
	beq	.L2757
.L2701:
	ldr	r0, [sp, #4]
	cmp	r0, r3
	it	ne
	movne	r7, r3
.L2757:
	movs	r0, #1
	b	.L2700
.L2699:
	cbz	r0, .L2702
	ldr	r2, .L2838+4
	str	r3, [r2]
.L2702:
	ldr	r3, .L2838+8
	ldrh	r2, [r10]
	strh	r2, [r3]	@ movhi
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	cbnz	r3, .L2692
	ldr	r3, .L2838
	ldrh	r2, [r3, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2704
	adds	r1, r7, #1
	ldr	r3, .L2838+4
	beq	.L2705
	str	r7, [r3]
.L2692:
	ldr	fp, [sp, #12]
	movs	r2, #1
	ldr	r6, .L2838+12
	ldr	r3, .L2838+16
	strh	r2, [r3]	@ movhi
.L2712:
	ldr	r3, .L2838+20
	movw	ip, #65535
	ldr	r0, [r6]
	mov	lr, #36
	ldr	r1, [sp, #20]
	movs	r2, #0
	ldrh	r5, [r3]
	ldr	r3, .L2838+24
	str	r2, [sp, #24]
	ldrb	r7, [r3]	@ zero_extendqisi2
.L2713:
	uxth	r3, r2
	cmp	r3, r5
	bcc	.L2716
	ldr	r2, [sp, #36]
	ldr	r1, [sp, #24]
	bl	FlashReadPages
	movs	r3, #0
.L2833:
	str	r3, [sp, #32]
	ldr	r2, [sp, #24]
	ldrh	r3, [sp, #32]
	cmp	r2, r3
	bhi	.L2745
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	add	fp, fp, #1
	uxth	fp, fp
	cmp	r3, #1
	bne	.L2746
	ldr	r3, .L2838+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2746
	ldr	r3, .L2838+28
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2746
	ldr	r3, [sp, #8]
	cmp	r3, fp
	beq	.L2721
.L2746:
	ldr	r3, .L2838+32
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2712
	ldr	r2, .L2838+20
	movw	r0, #65535
	movs	r3, #0
	strh	fp, [r10, #2]	@ movhi
	strh	r3, [r10, #4]	@ movhi
	ldrh	r2, [r2]
.L2747:
	uxth	r1, r3
	cmp	r1, r2
	bcs	.L2827
	ldr	r1, [sp, #20]
	ldrh	r4, [r1], #2
	cmp	r4, r0
	str	r1, [sp, #20]
	add	r1, r3, #1
	bne	.L2834
	mov	r3, r1
	b	.L2747
.L2705:
	ldr	r2, [sp, #4]
	ldr	r1, [sp, #24]
	cmp	r2, r1
	itet	eq
	ldreq	r2, [r3]
	movne	r2, r1
	addeq	r2, r2, #-1
.L2830:
	str	r2, [r3]
	b	.L2692
.L2704:
	ldr	r3, [sp, #4]
	cmp	r6, r3
	beq	.L2707
	adds	r2, r6, #1
	beq	.L2692
	ldr	r3, .L2838+4
	str	r6, [r3]
	b	.L2692
.L2707:
	ldr	r2, .L2838+4
	ldr	r1, [sp, #4]
	ldr	r3, [r2]
	cmp	r1, r3
	beq	.L2692
	subs	r3, r3, #1
	str	r3, [r2]
	b	.L2692
.L2755:
	mov	r1, r3
	mov	r3, r6
.L2700:
	mov	r6, r3
	adds	r2, r2, #36
	mov	r3, r1
	b	.L2698
.L2710:
	mov	r2, #-1
	ldr	r3, .L2838+4
	b	.L2830
.L2716:
	ldrh	r3, [r1], #2
	cmp	r3, ip
	beq	.L2714
	ldr	r4, [sp, #24]
	orr	r3, fp, r3, lsl #10
	mla	r4, lr, r4, r0
	str	r3, [r4, #4]
	ldrb	r8, [r10, #8]	@ zero_extendqisi2
	cmp	r8, #1
	bne	.L2715
	cbz	r7, .L2715
	orr	r3, r3, #-2147483648
	str	r3, [r4, #4]
.L2715:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #24]
.L2714:
	adds	r2, r2, #1
	b	.L2713
.L2745:
	ldr	r3, [sp, #32]
	movs	r5, #36
	ldr	r8, [r6]
	muls	r5, r3, r5
	add	r7, r8, r5
	ldr	r4, [r7, #4]
	ubfx	r0, r4, #10, #16
	str	r4, [sp, #52]
	bl	P2V_plane
	ldr	r3, [sp, #12]
	cmp	fp, r3
	bcc	.L2718
	bne	.L2719
	ldr	r3, [sp, #28]
	cmp	r3, r0
	bhi	.L2718
.L2719:
	ldr	r3, [sp, #8]
	cmp	fp, r3
	bne	.L2720
	ldr	r3, [sp, #16]
	cmp	r3, r0
	beq	.L2721
.L2720:
	ldr	r3, [r8, r5]
	adds	r3, r3, #1
	beq	.L2722
	ldr	r3, [r7, #12]
	movw	r2, #61589
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L2723
	ldrh	r0, [r10]
.L2831:
	bl	decrement_vpc_count
	b	.L2718
.L2723:
	ldr	r2, [r3, #4]
	str	r2, [sp, #4]
	adds	r2, r2, #1
	beq	.L2724
	ldr	r2, .L2838+36
	ldr	r0, [sp, #4]
	ldr	r1, [r2]
	bl	ftl_cmp_data_ver
	cbz	r0, .L2724
	ldr	r1, [sp, #4]
	adds	r1, r1, #1
	str	r1, [r2]
.L2724:
	ldr	r4, [r3, #8]
	add	r1, sp, #48
	ldr	r3, [r3, #12]
	movs	r2, #0
	mov	r0, r4
	str	r3, [sp, #44]
	bl	log2phys
	ldr	r3, .L2838+4
	ldr	r1, [r3]
	adds	r3, r1, #1
	beq	.L2725
	ldr	r0, [sp, #4]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2725
	ldr	r3, [sp, #44]
	adds	r7, r3, #1
	beq	.L2726
	ldr	r0, [r6]
	movs	r2, #0
	movs	r1, #1
	add	r0, r0, r5
	str	r3, [r0, #4]
	ldr	r7, [r0, #12]
	bl	FlashReadPages
	ldr	r2, [r6]
	ldr	r1, [r2, r5]
	adds	r3, r2, r5
	adds	r1, r1, #1
	bne	.L2727
.L2728:
	mov	r3, #-1
	str	r3, [sp, #44]
.L2735:
	ldr	r7, [sp, #44]
	adds	r0, r7, #1
	beq	.L2718
.L2750:
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L2838+40
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2741
	ldr	r1, .L2838+44
	movw	r2, #2458
	ldr	r0, .L2838+48
	bl	printf
	ldr	r1, .L2838+52
	ldr	r0, .L2838+56
	bl	printf
.L2741:
	ldr	r3, .L2838+60
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, #0
	beq	.L2742
	mov	r0, r4
	b	.L2831
.L2726:
	ldr	r3, [sp, #52]
	ldr	r2, [sp, #48]
	cmp	r2, r3
	bne	.L2718
	movs	r2, #1
	add	r1, sp, #44
	mov	r0, r4
	bl	log2phys
.L2718:
	ldr	r3, [sp, #32]
	adds	r3, r3, #1
	b	.L2833
.L2727:
	ldr	r1, [r7, #8]
	cmp	r4, r1
	bne	.L2728
	ldr	r8, [r7, #4]
	ldr	r0, .L2838+4
	mov	r1, r8
	ldr	r0, [r0]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2728
	ldr	r1, [sp, #48]
	ldr	r0, [sp, #52]
	cmp	r1, r0
	bne	.L2730
.L2733:
	ldr	r1, [sp, #44]
	mov	r0, r4
	bl	FtlReUsePrevPpa
	b	.L2728
.L2839:
	.align	2
.L2838:
	.word	.LANCHOR120
	.word	.LANCHOR136
	.word	.LANCHOR237
	.word	.LANCHOR180
	.word	.LANCHOR238
	.word	.LANCHOR38
	.word	.LANCHOR15
	.word	.LANCHOR53
	.word	.LANCHOR52
	.word	.LANCHOR160
	.word	.LANCHOR40
	.word	.LANCHOR236
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR83
.L2730:
	ldr	r0, [sp, #44]
	cmp	r1, r0
	beq	.L2728
	adds	r0, r1, #1
	beq	.L2731
	str	r1, [r3, #4]
	movs	r2, #0
	movs	r1, #1
	mov	r0, r3
	ldr	r7, [r3, #12]
	bl	FlashReadPages
.L2732:
	ldr	r3, [r6]
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L2733
	ldr	r3, [r7, #4]
	ldr	r2, .L2840
	mov	r1, r3
	ldr	r0, [r2]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2733
	mov	r1, r3
	mov	r0, r8
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2728
	b	.L2733
.L2731:
	str	r1, [r2, r5]
	b	.L2732
.L2725:
	ldr	r3, [sp, #52]
	ldr	r2, [sp, #48]
	cmp	r2, r3
	beq	.L2735
	ldr	r2, .L2840+4
	ldr	r3, [sp, #44]
	ldr	r2, [r2]
	cmp	r2, r3, lsr #10
	bhi	.L2737
	adds	r3, r3, #1
	bne	.L2718
.L2737:
	movs	r2, #1
	add	r1, sp, #52
	mov	r0, r4
	bl	log2phys
	ldr	r7, [sp, #48]
	adds	r5, r7, #1
	beq	.L2735
	ldr	r3, [sp, #44]
	cmp	r7, r3
	beq	.L2750
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L2840+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L2740
	ldr	r3, .L2840+12
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L2740
	ldr	r3, .L2840+16
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L2735
.L2740:
	ldr	r0, [r6]
	movs	r2, #0
	movs	r1, #1
	str	r7, [r0, #4]
	ldr	r5, [r0, #12]
	bl	FlashReadPages
	ldr	r3, [r6]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L2735
	ldr	r1, [r5, #4]
	ldr	r0, [sp, #4]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	bne	.L2735
	movs	r2, #1
	add	r1, sp, #48
	mov	r0, r4
	bl	log2phys
	b	.L2735
.L2742:
	mov	r1, r4
	ldr	r0, .L2840+20
	bl	printf
	b	.L2718
.L2722:
	ldrh	r3, [r10]
	mov	r1, r4
	ldr	r2, .L2840+24
	ldr	r0, .L2840+28
	strh	r3, [r2]	@ movhi
	ldr	r2, [sp, #4]
	bl	printf
	ldr	r2, .L2840+32
	ldr	r3, [r2]
	cmp	r3, #31
	bhi	.L2743
	ldr	r0, [sp, #52]
	ldr	r1, .L2840+36
	str	r0, [r1, r3, lsl #2]
	adds	r3, r3, #1
	str	r3, [r2]
.L2743:
	ldrh	r0, [r10]
	bl	decrement_vpc_count
	ldr	r3, .L2840
	ldr	r2, [r3]
	adds	r1, r2, #1
	bne	.L2744
	ldr	r2, [sp, #4]
.L2832:
	str	r2, [r3]
	b	.L2718
.L2744:
	ldr	r1, [sp, #4]
	cmp	r1, r2
	bcs	.L2718
	mov	r2, r1
	b	.L2832
.L2721:
	ldrb	r3, [sp, #16]	@ zero_extendqisi2
	ldr	r2, [sp, #16]
	strb	r3, [r10, #6]
	ldrh	r3, [sp, #8]
	strh	r3, [r10, #2]	@ movhi
	b	.L2835
.L2841:
	.align	2
.L2840:
	.word	.LANCHOR136
	.word	.LANCHOR43
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LC66
	.word	.LANCHOR237
	.word	.LC67
	.word	.LANCHOR239
	.word	.LANCHOR240
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
	.section	.text.FtlGcScanTempBlk,"ax",%progbits
	.align	1
	.global	FtlGcScanTempBlk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcScanTempBlk, %function
FtlGcScanTempBlk:
	@ args = 0, pretend = 0, frame = 64
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2881
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	sub	sp, sp, #64
	ldrh	r5, [r3]
	movw	r3, #65535
	cmp	r5, r3
	beq	.L2868
	cbnz	r5, .L2843
.L2844:
	bl	FtlGcPageVarInit
	b	.L2845
.L2868:
	movs	r5, #0
.L2843:
	ldr	r3, .L2881+4
	ldrh	r3, [r3]
	cmp	r3, r1
	beq	.L2844
.L2845:
	ldr	r8, .L2881+76
	mov	r3, #-1
	str	r3, [sp, #8]
.L2846:
	ldrh	r2, [r4]
	movs	r3, #0
	strb	r3, [r4, #8]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2847
.L2867:
	ldr	r3, .L2881+8
	movs	r2, #0
	ldr	r0, [r8]
	mov	fp, r2
	movw	ip, #65535
	mov	lr, #36
	ldrh	r10, [r3]
	ldr	r3, .L2881+12
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2881+16
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L2881+20
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L2881+24
	ldrh	r7, [r3]
	add	r3, r4, #16
	str	r3, [sp, #4]
.L2848:
	uxth	r3, r2
	cmp	r10, r3
	bhi	.L2850
	mov	r10, #0
	movs	r2, #0
	mov	r1, fp
	bl	FlashReadPages
.L2851:
	uxth	r3, r10
	cmp	fp, r3
	bhi	.L2866
	ldr	r3, .L2881+4
	adds	r5, r5, #1
	uxth	r5, r5
	ldrh	r3, [r3]
	cmp	r3, r5
	bhi	.L2867
.L2847:
	ldr	r3, .L2881
	movw	r2, #65535
	mov	r0, r4
	strh	r5, [r4, #2]	@ movhi
	mov	r1, r5
	strh	r2, [r3]	@ movhi
	movs	r2, #0
	strb	r2, [r4, #6]
	bl	ftl_sb_update_avl_pages
	ldr	r0, [sp, #8]
	add	sp, sp, #64
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2850:
	ldr	r1, [sp, #4]
	ldrh	r3, [r1], #2
	cmp	r3, ip
	str	r1, [sp, #4]
	beq	.L2849
	mla	r1, lr, fp, r0
	ldr	r6, [sp, #12]
	orr	r3, r5, r3, lsl #10
	str	r3, [r1, #4]
	ldr	r3, [sp, #16]
	mul	r3, r3, fp
	bic	r3, r3, #3
	add	r3, r3, r6
	ldr	r6, [sp, #20]
	str	r3, [r1, #8]
	mul	r3, r7, fp
	bic	r3, r3, #3
	add	r3, r3, r6
	str	r3, [r1, #12]
	add	r3, fp, #1
	uxth	fp, r3
.L2849:
	adds	r2, r2, #1
	b	.L2848
.L2866:
	movs	r7, #36
	ldr	r2, [r8]
	mul	r7, r7, r10
	adds	r3, r2, r7
	ldr	r6, [r2, r7]
	ldr	r1, [r3, #4]
	ldr	r3, [r3, #12]
	str	r1, [sp, #4]
	cmp	r6, #0
	bne	.L2852
	ldrh	r1, [r3]
	movw	r2, #65535
	cmp	r1, r2
	beq	.L2880
	ldr	r2, .L2881+28
	ldr	r0, [r3, #8]
	ldr	r2, [r2]
	cmp	r0, r2
	bls	.L2854
.L2880:
	ldr	r3, .L2881+32
	movs	r1, #0
	ldrh	r2, [r4]
	ldr	r3, [r3]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r4]
	bl	INSERT_FREE_LIST
	ldr	r2, .L2881+36
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
	strh	r3, [r2]	@ movhi
.L2879:
	bl	FtlGcPageVarInit
	movs	r5, #0
	b	.L2846
.L2854:
	ldr	r2, .L2881+40
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L2856
.L2857:
	ldr	r2, [r3, #8]
	add	r10, r10, #1
	ldr	r1, [sp, #4]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L2851
.L2856:
	mov	r2, r6
	add	r1, sp, #24
	str	r3, [sp, #12]
	bl	log2phys
	ldr	r3, [sp, #12]
	ldr	r1, [sp, #24]
	ldr	r2, [r3, #12]
	cmp	r2, r1
	bne	.L2857
	adds	r1, r2, #1
	beq	.L2857
	str	r2, [sp, #32]
	movs	r1, #1
	ldr	r2, .L2881+44
	add	r0, sp, #28
	ldr	r2, [r2]
	str	r2, [sp, #36]
	ldr	r2, .L2881+48
	ldr	r2, [r2]
	str	r2, [sp, #40]
	mov	r2, r6
	bl	FlashReadPages
	ldr	r2, .L2881+52
	ldr	r1, [r8]
	ldr	r0, [sp, #36]
	ldrh	r2, [r2]
	ldr	r3, [sp, #12]
	add	r7, r7, r1
	lsl	ip, r2, #7
.L2858:
	cmp	r6, ip
	beq	.L2857
	ldr	r1, [r7, #8]
	ldr	r2, [r0, r6, lsl #2]
	ldr	r1, [r1, r6, lsl #2]
	cmp	r1, r2
	beq	.L2859
	ldr	r2, [sp, #32]
	ldrh	r1, [r4]
	ldr	r0, .L2881+56
	bl	printf
	b	.L2880
.L2859:
	adds	r6, r6, #1
	b	.L2858
.L2852:
	ldr	r2, [sp, #4]
	ldrh	r1, [r4]
	ldr	r0, .L2881+60
	bl	printf
	ldr	r3, .L2881+64
	ldrh	r2, [r4]
	ldr	r3, [r3]
	cbnz	r3, .L2862
	ldr	r3, .L2881+68
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2863
.L2862:
	ldr	r3, .L2881+72
	ldr	r3, [r3]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r3, #159
	bls	.L2864
.L2863:
	ldr	r3, [r8]
	ldr	r3, [r3, r7]
	adds	r3, r3, #1
	bne	.L2865
.L2864:
	ldr	r3, [r8]
	add	r7, r7, r3
	ldr	r3, [r7, #4]
	str	r3, [sp, #8]
.L2865:
	ldr	r3, .L2881+32
	movs	r1, #0
	ldr	r3, [r3]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r4]
	bl	INSERT_FREE_LIST
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
	b	.L2879
.L2882:
	.align	2
.L2881:
	.word	.LANCHOR241
	.word	.LANCHOR52
	.word	.LANCHOR38
	.word	.LANCHOR104
	.word	.LANCHOR57
	.word	.LANCHOR105
	.word	.LANCHOR58
	.word	.LANCHOR72
	.word	.LANCHOR83
	.word	.LANCHOR205
	.word	.LANCHOR2
	.word	.LANCHOR187
	.word	.LANCHOR189
	.word	.LANCHOR55
	.word	.LC68
	.word	.LC69
	.word	.LANCHOR28
	.word	.LANCHOR15
	.word	.LANCHOR78
	.word	.LANCHOR180
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
	.section	.text.FtlGcFreeTempBlock,"ax",%progbits
	.align	1
	.global	FtlGcFreeTempBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcFreeTempBlock, %function
FtlGcFreeTempBlock:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, .L2907
	ldr	r3, [r3]
	cbz	r3, .L2884
.L2889:
	movs	r0, #0
.L2883:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2884:
	ldr	r0, .L2907+4
	movw	r3, #65535
	ldr	r5, .L2907+8
	ldrh	r6, [r0]
	mov	r4, r0
	cmp	r6, r3
	beq	.L2886
	ldr	r3, .L2907+12
	ldrh	r1, [r3]
	bl	FtlGcScanTempBlk
	str	r0, [sp, #12]
	adds	r0, r0, #1
	beq	.L2886
	ldr	r3, .L2907+16
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	cmp	r3, #4
	bls	.L2887
	subs	r3, r3, #5
	movs	r0, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	bl	FtlEctTblFlush
.L2887:
	ldr	r3, [r5]
	cbnz	r3, .L2888
	ldr	r2, .L2907+20
	ldr	r0, [sp, #12]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L2888:
	movs	r3, #0
	movs	r0, #1
	str	r3, [r5]
	b	.L2883
.L2886:
	ldrh	r2, [r4]
	movs	r3, #0
	str	r3, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2889
	ldr	r6, .L2907+12
	bl	FtlCacheWriteBack
	ldrb	r0, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r6]
	ldr	r5, .L2907+24
	muls	r2, r0, r2
	ldrh	r1, [r5]
	cmp	r1, r2
	beq	.L2890
	ldr	r1, .L2907+28
	movs	r2, #163
	ldr	r0, .L2907+32
	bl	printf
	ldr	r1, .L2907+36
	ldr	r0, .L2907+40
	bl	printf
.L2890:
	ldrh	r6, [r6]
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldr	r2, .L2907+44
	ldrh	r0, [r4]
	ldr	fp, .L2907+84
	smulbb	r3, r3, r6
	ldr	r1, [r2]
	movs	r6, #0
	mov	r10, r2
	strh	r3, [r1, r0, lsl #1]	@ movhi
	ldr	r1, .L2907+48
	ldrh	r3, [r5]
	ldr	r0, [r1]
	add	r3, r3, r0
	str	r3, [r1]
.L2891:
	ldrh	r2, [r5]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L2895
	movw	r0, #65535
	bl	decrement_vpc_count
	ldr	r3, .L2907+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2896
	ldrh	r1, [r4]
	ldr	r0, .L2907+56
	bl	printf
.L2896:
	ldrh	r0, [r4]
	ldr	r3, [r10]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	beq	.L2897
	bl	INSERT_DATA_LIST
.L2898:
	ldr	r3, .L2907+60
	movw	r6, #65535
	strh	r6, [r4]	@ movhi
	movs	r4, #0
	strh	r4, [r5]	@ movhi
	strh	r4, [r3]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	r3, .L2907+64
	strh	r6, [r3]	@ movhi
	ldr	r3, .L2907+68
	ldrh	r2, [r3]
	ldr	r3, .L2907+72
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	cmp	r2, r3, asr #2
	ble	.L2889
	ldr	r3, .L2907+76
	movs	r2, #20
	mov	r0, r4
	strh	r2, [r3]	@ movhi
	b	.L2883
.L2895:
	uxth	r3, r6
	mov	r8, #12
	ldr	r2, [fp]
	mul	r8, r8, r3
	ldr	r3, .L2907+80
	ldr	r3, [r3]
	add	r7, r3, r8
	ldr	r0, [r7, #8]
	cmp	r0, r2
	bcc	.L2892
.L2905:
	ldrh	r0, [r4]
	b	.L2906
.L2892:
	movs	r2, #0
	add	r1, sp, #12
	str	r3, [sp, #4]
	bl	log2phys
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #12]
	ldr	r0, [r3, r8]
	cmp	r0, r2
	bne	.L2894
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	movs	r2, #1
	mov	r8, r0
	adds	r1, r7, #4
	ldr	r0, [r7, #8]
	bl	log2phys
	mov	r0, r8
.L2906:
	bl	decrement_vpc_count
	b	.L2893
.L2894:
	ldr	r3, [r7, #4]
	cmp	r2, r3
	bne	.L2905
.L2893:
	adds	r6, r6, #1
	b	.L2891
.L2897:
	bl	INSERT_FREE_LIST
	b	.L2898
.L2908:
	.align	2
.L2907:
	.word	.LANCHOR76
	.word	.LANCHOR93
	.word	.LANCHOR135
	.word	.LANCHOR52
	.word	.LANCHOR78
	.word	.LANCHOR138
	.word	.LANCHOR110
	.word	.LANCHOR242
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR83
	.word	.LANCHOR161
	.word	.LANCHOR15
	.word	.LC70
	.word	.LANCHOR109
	.word	.LANCHOR205
	.word	.LANCHOR88
	.word	.LANCHOR224
	.word	.LANCHOR176
	.word	.LANCHOR111
	.word	.LANCHOR72
	.size	FtlGcFreeTempBlock, .-FtlGcFreeTempBlock
	.section	.text.Ftl_get_new_temp_ppa,"ax",%progbits
	.align	1
	.global	Ftl_get_new_temp_ppa
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	Ftl_get_new_temp_ppa, %function
Ftl_get_new_temp_ppa:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movw	r3, #65535
	ldr	r4, .L2912
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L2910
	ldrh	r3, [r4, #4]
	cbnz	r3, .L2911
.L2910:
	bl	FtlCacheWriteBack
	movs	r0, #0
	movs	r5, #0
	bl	FtlGcFreeTempBlock
	ldr	r0, .L2912
	strb	r5, [r4, #8]
	bl	allocate_data_superblock
	ldr	r3, .L2912+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L2912+8
	strh	r5, [r3]	@ movhi
	bl	l2p_flush
	mov	r0, r5
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2911:
	ldr	r0, .L2912
	pop	{r3, r4, r5, lr}
	b	get_new_active_ppa
.L2913:
	.align	2
.L2912:
	.word	.LANCHOR93
	.word	.LANCHOR109
	.word	.LANCHOR110
	.size	Ftl_get_new_temp_ppa, .-Ftl_get_new_temp_ppa
	.section	.text.Ftl_gc_temp_data_write_back,"ax",%progbits
	.align	1
	.global	Ftl_gc_temp_data_write_back
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	Ftl_gc_temp_data_write_back, %function
Ftl_gc_temp_data_write_back:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r3, .L2929
	ldr	r3, [r3]
	cbz	r3, .L2915
.L2918:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L2915:
	ldr	r3, .L2929+4
	ldr	r5, .L2929+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2917
	ldr	r3, [r5]
	lsls	r2, r3, #31
	bpl	.L2917
	ldr	r3, .L2929+12
	ldrh	r3, [r3, #4]
	cmp	r3, #0
	bne	.L2918
.L2917:
	ldr	r4, .L2929+16
	movs	r3, #0
	movs	r6, #0
	movs	r7, #36
	mov	r2, r3
	ldr	r1, [r5]
	ldr	r0, [r4]
	bl	FlashProgPages
.L2919:
	ldr	r1, [r5]
	uxth	r3, r6
	cmp	r3, r1
	bcc	.L2921
	ldr	r0, [r4]
	bl	FtlGcBufFree
	movs	r3, #0
	str	r3, [r5]
	ldr	r3, .L2929+12
	ldrh	r3, [r3, #4]
	cmp	r3, #0
	bne	.L2918
	movs	r0, #1
	bl	FtlGcFreeTempBlock
	b	.L2928
.L2921:
	muls	r3, r7, r3
	ldr	r2, [r4]
	adds	r6, r6, #1
	adds	r1, r2, r3
	ldr	r2, [r2, r3]
	ldr	r0, [r1, #12]
	adds	r3, r2, #1
	bne	.L2920
	ldr	r3, .L2929+12
	movs	r5, #0
	ldr	r0, .L2929+20
	ldrh	r4, [r3]
	ldr	r0, [r0]
	strh	r5, [r0, r4, lsl #1]	@ movhi
	strh	r2, [r3]	@ movhi
	ldr	r2, .L2929+24
	ldr	r0, [r1, #4]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
.L2928:
	movs	r0, #1
	pop	{r3, r4, r5, r6, r7, pc}
.L2920:
	ldr	r2, [r0, #8]
	ldr	r1, [r1, #4]
	ldr	r0, [r0, #12]
	bl	FtlGcUpdatePage
	b	.L2919
.L2930:
	.align	2
.L2929:
	.word	.LANCHOR76
	.word	.LANCHOR15
	.word	.LANCHOR102
	.word	.LANCHOR93
	.word	.LANCHOR181
	.word	.LANCHOR83
	.word	.LANCHOR138
	.size	Ftl_gc_temp_data_write_back, .-Ftl_gc_temp_data_write_back
	.section	.text.FtlGcPageRecovery,"ax",%progbits
	.align	1
	.global	FtlGcPageRecovery
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcPageRecovery, %function
FtlGcPageRecovery:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	ldr	r4, .L2933
	ldr	r5, .L2933+4
	ldrh	r1, [r4]
	mov	r0, r5
	bl	FtlGcScanTempBlk
	ldrh	r2, [r5, #2]
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L2931
	ldr	r0, .L2933+8
	bl	FtlMapBlkWriteDumpData
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r3, .L2933+12
	movs	r2, #0
	str	r2, [r3]
.L2931:
	pop	{r3, r4, r5, pc}
.L2934:
	.align	2
.L2933:
	.word	.LANCHOR52
	.word	.LANCHOR93
	.word	.LANCHOR127
	.word	.LANCHOR135
	.size	FtlGcPageRecovery, .-FtlGcPageRecovery
	.section	.text.FtlPowerLostRecovery,"ax",%progbits
	.align	1
	.global	FtlPowerLostRecovery
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlPowerLostRecovery, %function
FtlPowerLostRecovery:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	movs	r4, #0
	ldr	r5, .L2936
	ldr	r3, .L2936+4
	mov	r0, r5
	str	r4, [r3]
	bl	FtlRecoverySuperblock
	mov	r0, r5
	ldr	r5, .L2936+8
	bl	FtlSlcSuperblockCheck
	mov	r0, r5
	bl	FtlRecoverySuperblock
	mov	r0, r5
	bl	FtlSlcSuperblockCheck
	bl	FtlGcPageRecovery
	movw	r0, #65535
	bl	decrement_vpc_count
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L2937:
	.align	2
.L2936:
	.word	.LANCHOR91
	.word	.LANCHOR239
	.word	.LANCHOR92
	.size	FtlPowerLostRecovery, .-FtlPowerLostRecovery
	.section	.text.FtlSysBlkInit,"ax",%progbits
	.align	1
	.global	FtlSysBlkInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlSysBlkInit, %function
FtlSysBlkInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, lr}
	movs	r3, #0
	ldr	r4, .L2951
	movw	r5, #65535
	strh	r3, [r4]	@ movhi
	ldr	r3, .L2951+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L2951+8
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	ldr	r3, .L2951+12
	ldrh	r3, [r3]
	cmp	r3, r5
	mov	r5, r4
	bne	.L2939
.L2941:
	mov	r4, #-1
.L2938:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L2939:
	bl	FtlLoadSysInfo
	mov	r4, r0
	cmp	r0, #0
	bne	.L2941
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	movs	r0, #1
	bl	FtlUpdateVaildLpn
	ldr	r3, .L2951+16
	movs	r0, #12
	ldrh	r1, [r3]
	ldr	r3, .L2951+20
	ldr	r2, [r3]
	mov	r3, r4
.L2942:
	cmp	r3, r1
	bge	.L2947
	mla	r6, r0, r3, r2
	ldr	r6, [r6, #4]
	cmp	r6, #0
	bge	.L2943
.L2947:
	ldr	r0, .L2951+24
	cmp	r3, r1
	ldr	r2, [r0]
	add	r2, r2, #32
	str	r2, [r0]
	bge	.L2949
.L2944:
	ldr	r3, .L2951+28
	ldr	r1, [r3]
	ldr	r3, .L2951+32
	ldrh	r0, [r3]
	ldrh	r5, [r3, #4]
	ldrh	r2, [r1, r0, lsl #1]
	subs	r2, r2, r5
	ldr	r5, .L2951+36
	strh	r2, [r1, r0, lsl #1]	@ movhi
	ldrh	r2, [r5]
	strh	r2, [r3, #2]	@ movhi
	movs	r2, #0
	strh	r2, [r3, #4]	@ movhi
	strb	r2, [r3, #6]
	ldr	r3, .L2951+40
	ldrh	r6, [r3]
	ldrh	r7, [r3, #4]
	ldrh	r0, [r1, r6, lsl #1]
	subs	r0, r0, r7
	strh	r0, [r1, r6, lsl #1]	@ movhi
	strb	r2, [r3, #6]
	ldrh	r1, [r5]
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L2951+44
	strh	r1, [r3, #2]	@ movhi
	ldrh	r3, [r2, #30]
	adds	r3, r3, #1
	strh	r3, [r2, #30]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2950:
	bl	FtlVpcTblFlush
	b	.L2938
.L2943:
	adds	r3, r3, #1
	b	.L2942
.L2949:
	ldrh	r3, [r5]
	cmp	r3, #0
	bne	.L2944
	bl	l2p_flush
	b	.L2950
.L2952:
	.align	2
.L2951:
	.word	.LANCHOR238
	.word	.LANCHOR237
	.word	.LANCHOR39
	.word	.LANCHOR210
	.word	.LANCHOR67
	.word	.LANCHOR96
	.word	.LANCHOR160
	.word	.LANCHOR83
	.word	.LANCHOR91
	.word	.LANCHOR52
	.word	.LANCHOR92
	.word	.LANCHOR80
	.size	FtlSysBlkInit, .-FtlSysBlkInit
	.section	.text.FtlLowFormat,"ax",%progbits
	.align	1
	.global	FtlLowFormat
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlLowFormat, %function
FtlLowFormat:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2984
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r4, [r3]
	cmp	r4, #0
	bne	.L2955
	ldr	r5, .L2984+4
	mov	r1, r4
	ldr	r3, .L2984+8
	ldr	r6, .L2984+12
	ldrh	r2, [r5]
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L2984+16
	ldr	r5, .L2984+20
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L2984+24
	ldrh	r0, [r6]
	str	r4, [r5]
	str	r4, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L2956
	bl	FtlMakeBbt
.L2956:
	ldr	r3, .L2984+28
	ldr	r2, .L2984+32
	ldr	ip, .L2984+112
	ldrh	r1, [r3]
	ldr	r4, [r2]
	ldr	r2, .L2984+36
	str	r3, [sp, #12]
	lsls	r1, r1, #7
	ldr	r7, [r2]
	movs	r2, #0
.L2957:
	uxth	r3, r2
	adds	r2, r2, #1
	cmp	r3, r1
	blt	.L2958
	ldr	r3, .L2984+40
	movs	r7, #0
	ldr	fp, .L2984+116
	ldrh	r4, [r3]
	mov	r8, r3
	mov	r10, fp
.L2959:
	ldrh	r3, [fp]
	cmp	r3, r4
	bhi	.L2960
	ldr	r4, .L2984+44
	subs	r3, r7, #2
	ldrh	r1, [r4]
	cmp	r3, r1, lsl #1
	bgt	.L2961
.L2965:
	movs	r7, #0
	mov	r6, r7
.L2962:
	ldrh	r3, [r8]
	uxth	r0, r7
	adds	r7, r7, #1
	cmp	r3, r0
	bhi	.L2966
	ldrh	r2, [r10]
	ldr	r3, .L2984+48
	ldrh	r4, [r4]
	ldr	r7, .L2984+52
	str	r2, [r3]
	ldr	r3, .L2984+56
	mov	r1, r4
	ldr	r3, [r3]
	mov	r0, r3
	str	r3, [sp, #16]
	bl	__aeabi_uidiv
	ldr	r1, .L2984+60
	ubfx	r3, r0, #5, #16
	add	r2, r3, #36
	mov	fp, r0
	str	r0, [r7]
	strh	r2, [r1]	@ movhi
	movs	r2, #24
	muls	r2, r4, r2
	str	r3, [sp, #4]
	str	r1, [sp, #8]
	cmp	r6, r2
	ble	.L2967
	ldr	r3, [sp, #16]
	mov	r1, r4
	subs	r0, r3, r6
	bl	__aeabi_uidiv
	ldr	r3, [sp, #8]
	str	r0, [r7]
	lsrs	r0, r0, #5
	adds	r0, r0, #24
	strh	r0, [r3]	@ movhi
.L2967:
	ldr	r3, .L2984+64
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L2968
	ldr	r2, .L2984+60
	mov	r1, r4
	mov	r0, r6
	ldrh	r3, [r2]
	str	r2, [sp, #20]
	str	r3, [sp, #16]
	bl	__aeabi_uidiv
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #20]
	uxtah	r0, r3, r0
	add	r3, r3, r0, asr #2
	strh	r3, [r2]	@ movhi
.L2968:
	ldr	r3, .L2984+68
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2969
	ldr	r2, .L2984+60
	mov	r1, r4
	mov	r0, r6
	ldrh	r3, [r2]
	str	r2, [sp, #20]
	str	r3, [sp, #16]
	bl	__aeabi_uidiv
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #20]
	uxtah	r0, r3, r0
	add	r3, r3, r0, asr #2
	strh	r3, [r2]	@ movhi
.L2969:
	ldr	r3, .L2984+72
	ldrh	r3, [r3]
	cbz	r3, .L2971
	ldr	r2, .L2984+60
	ldrh	r1, [r2]
	add	r1, r1, r3, lsr #1
	strh	r1, [r2]	@ movhi
	mul	r1, r4, r3
	cmp	r6, r1
	bge	.L2971
	ldr	r1, [sp, #4]
	adds	r3, r3, #32
	str	fp, [r7]
	add	r1, r1, r3
	strh	r1, [r2]	@ movhi
.L2971:
	ldr	r3, [sp, #8]
	ldr	r6, .L2984+76
	ldrh	r2, [r3]
	ldr	r3, [r7]
	subs	r3, r3, r2
	muls	r4, r3, r4
	ldr	r3, .L2984+80
	ldrh	r3, [r3]
	str	r4, [r6]
	muls	r4, r3, r4
	ldr	r3, [sp, #12]
	ldrh	r3, [r3]
	str	r4, [r7]
	ldr	r7, .L2984+84
	muls	r4, r3, r4
	ldr	r3, .L2984+88
	str	r4, [r3]
	movw	r4, #65535
	bl	FtlBbmTblFlush
	ldrh	r2, [r10]
	movs	r1, #0
	ldr	r10, .L2984+120
	lsls	r2, r2, #1
	ldr	r0, [r10]
	bl	ftl_memset
	ldr	r2, .L2984+92
	movs	r3, #0
	strh	r3, [r7, #2]	@ movhi
	movs	r1, #255
	strb	r3, [r7, #6]
	str	r3, [r2]
	ldr	r2, .L2984+96
	strh	r3, [r7]	@ movhi
	strh	r3, [r2, #2]	@ movhi
	strb	r3, [r2, #6]
	strb	r3, [r2, #8]
	movs	r3, #1
	strh	r4, [r2]	@ movhi
	ldrh	r2, [r8]
	mov	r8, r10
	strb	r3, [r7, #8]
	mov	r10, r7
	ldr	r3, .L2984+100
	lsrs	r2, r2, #3
	ldr	r0, [r3]
	bl	ftl_memset
.L2973:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r7, #7]	@ zero_extendqisi2
	ldrh	r2, [r7]
	cmp	r3, #0
	bne	.L2974
	ldr	r3, [r8]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r7]
	adds	r3, r3, #1
	strh	r3, [r7]	@ movhi
	b	.L2973
.L2958:
	mvns	r0, r3
	orr	r0, r3, r0, lsl #16
	str	r0, [r4, r3, lsl #2]
	str	ip, [r7, r3, lsl #2]
	b	.L2957
.L2960:
	mov	r0, r4
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r4, r4, #1
	add	r7, r7, r0
	uxth	r7, r7
	uxth	r4, r4
	b	.L2959
.L2961:
	mov	r0, r7
	bl	__aeabi_uidiv
	ldr	r3, .L2984+104
	ldr	r3, [r3]
	add	r0, r0, r3
	uxth	r0, r0
	bl	FtlSysBlkNumInit
	ldrh	r0, [r6]
	bl	FtlFreeSysBlkQueueInit
	ldrh	r6, [r8]
.L2963:
	ldrh	r3, [r10]
	cmp	r3, r6
	bls	.L2965
	mov	r0, r6
	movs	r1, #1
	adds	r6, r6, #1
	bl	FtlLowFormatEraseBlock
	uxth	r6, r6
	b	.L2963
.L2966:
	movs	r1, #0
	bl	FtlLowFormatEraseBlock
	add	r6, r6, r0
	uxth	r6, r6
	b	.L2962
.L2974:
	ldr	r3, [r5]
	ldrh	r1, [r7, #4]
	ldr	r4, .L2984+108
	str	r3, [r7, #12]
	adds	r3, r3, #1
	str	r3, [r5]
	ldr	r3, [r8]
	mov	r10, r4
	strh	r1, [r3, r2, lsl #1]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #2]	@ movhi
	strb	r3, [r4, #6]
	ldrh	r3, [r7]
	movw	r7, #65535
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	movs	r3, #1
	strb	r3, [r4, #8]
.L2975:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r4]
	cmp	r3, #0
	bne	.L2976
	ldr	r3, [r8]
	strh	r7, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L2975
.L2985:
	.align	2
.L2984:
	.word	.LANCHOR76
	.word	.LANCHOR66
	.word	.LANCHOR195
	.word	.LANCHOR39
	.word	.LANCHOR131
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR55
	.word	.LANCHOR186
	.word	.LANCHOR187
	.word	.LANCHOR40
	.word	.LANCHOR38
	.word	.LANCHOR73
	.word	.LANCHOR72
	.word	.LANCHOR42
	.word	.LANCHOR224
	.word	.LANCHOR28
	.word	.LANCHOR15
	.word	.LANCHOR49
	.word	.LANCHOR223
	.word	.LANCHOR52
	.word	.LANCHOR91
	.word	.LANCHOR68
	.word	.LANCHOR100
	.word	.LANCHOR205
	.word	.LANCHOR1
	.word	.LANCHOR65
	.word	.LANCHOR92
	.word	168778952
	.word	.LANCHOR41
	.word	.LANCHOR83
.L2976:
	ldr	r3, [r5]
	ldrh	r1, [r4, #4]
	str	r3, [r4, #12]
	adds	r3, r3, #1
	str	r3, [r5]
	movw	r4, #65535
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L2986
	strh	r4, [r3]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L2986+4
	movs	r2, #0
	strh	r2, [r3, #2]	@ movhi
	ldr	r2, [r6]
	strh	r0, [r3]	@ movhi
	strh	r4, [r3, #4]	@ movhi
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, [r5]
	str	r2, [r3, #8]
	adds	r2, r2, #1
	str	r2, [r5]
	bl	FtlVpcTblFlush
	bl	FtlSysBlkInit
	cbnz	r0, .L2955
	ldr	r3, .L2986+8
	movs	r2, #1
	str	r2, [r3]
.L2955:
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2987:
	.align	2
.L2986:
	.word	.LANCHOR93
	.word	.LANCHOR210
	.word	.LANCHOR232
	.size	FtlLowFormat, .-FtlLowFormat
	.section	.text.rk_ftl_garbage_collect,"ax",%progbits
	.align	1
	.global	rk_ftl_garbage_collect
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_ftl_garbage_collect, %function
rk_ftl_garbage_collect:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L3087
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r2, [r3]
	cmp	r2, #0
	bne	.L3047
	ldr	r3, .L3087+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L3047
	ldr	r2, .L3087+8
	ldrh	r2, [r2]
	cmp	r2, #47
	bls	.L3049
	ldr	r5, .L3087+12
	movw	r2, #65535
	ldrh	ip, [r5]
	cmp	ip, r2
	beq	.L2990
	ldr	r7, .L3087+16
	ldrh	r3, [r7]
	cmp	r3, r2
	bne	.L2990
	ldr	r1, .L3087+20
	ldrh	r6, [r1]
	cmp	r6, r3
	beq	.L2990
	ldr	r2, .L3087+24
	ldrh	r4, [r2]
	cmp	r4, r3
	itttt	ne
	strhne	ip, [r7]	@ movhi
	strhne	r6, [r5]	@ movhi
	strhne	r4, [r1]	@ movhi
	strhne	r3, [r2]	@ movhi
.L2990:
	cmp	r0, #0
	bne	.L3050
	ldr	r3, .L3087+28
	ldrh	r3, [r3]
	cmp	r3, #24
	bhi	.L3051
	ldr	r2, .L3087+32
	cmp	r3, #16
	ldrh	r4, [r2]
	bls	.L2993
	lsrs	r4, r4, #5
.L2992:
	ldr	r2, .L3087+36
	ldrh	r1, [r2]
	cmp	r1, r3
	mov	r1, r2
	bcs	.L2996
	ldr	r3, .L3087+40
	movw	r0, #65535
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L2997
	ldr	r0, .L3087+16
	ldrh	r0, [r0]
	cmp	r0, r3
	bne	.L2997
	ldr	r3, .L3087+44
	ldrh	r0, [r3]
	cbnz	r0, .L2998
	ldr	r3, .L3087+48
	ldr	r4, .L3087+52
	ldr	r3, [r3]
	ldr	r4, [r4]
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, lsr #2
	bcs	.L2999
.L2998:
	ldr	r3, .L3087+56
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L3000:
	ldr	r3, .L3087+60
	movs	r2, #0
	str	r2, [r3]
.L2988:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2993:
	cmp	r3, #12
	bls	.L2994
	lsrs	r4, r4, #4
	b	.L2992
.L2994:
	cmp	r3, #8
	bls	.L2992
	lsrs	r4, r4, #2
	b	.L2992
.L3051:
	movs	r4, #1
	b	.L2992
.L2999:
	movs	r3, #18
	strh	r3, [r2]	@ movhi
	b	.L3000
.L2997:
	ldr	r3, .L3087+56
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L2996:
	ldr	r3, .L3087+64
	ldrh	r3, [r3]
	cbz	r3, .L2991
	adds	r4, r4, #32
	uxth	r4, r4
.L2991:
	ldr	r5, .L3087+68
	movw	r3, #65535
	ldrh	r2, [r5]
	cmp	r2, r3
	bne	.L3003
	ldr	r3, .L3087+16
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L3004
	ldr	r0, .L3087+72
	ldr	r0, [r0]
	ldrh	r1, [r0, r1, lsl #1]
	cbnz	r1, .L3005
	strh	r2, [r3]	@ movhi
.L3005:
	ldrh	r2, [r3]
	strh	r2, [r5]	@ movhi
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
.L3004:
	ldrh	r0, [r5]
	movw	r6, #65535
	movs	r3, #0
	strb	r3, [r5, #8]
	cmp	r0, r6
	beq	.L3003
	bl	IsBlkInGcList
	cbz	r0, .L3007
	strh	r6, [r5]	@ movhi
.L3007:
	ldr	r3, .L3087+76
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3008
	ldrh	r0, [r5]
	bl	ftl_get_blk_mode
	strb	r0, [r5, #8]
.L3008:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L3003
	ldr	r0, .L3087+68
	bl	make_superblock
	ldr	r2, .L3087+80
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r3, [r2]	@ movhi
	ldr	r3, .L3087+72
	ldrh	r2, [r5]
	ldr	r3, [r3]
	ldrh	r2, [r3, r2, lsl #1]
	ldr	r3, .L3087+84
	strh	r2, [r3]	@ movhi
.L3003:
	ldr	r2, .L3087+88
	ldrh	r3, [r5]
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L3009
	ldr	r2, .L3087+92
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L3009
	ldr	r2, .L3087+40
	ldrh	r2, [r2]
	cmp	r2, r3
	bne	.L3010
.L3009:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L3010:
	ldr	r5, .L3087+68
	mov	r6, r5
.L3046:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L3011
	ldr	r10, .L3087+100
	movs	r2, #0
	ldr	r3, .L3087+60
	mov	r7, r10
	str	r2, [r3]
.L3012:
	ldrh	r8, [r10]
	mov	r0, r8
	bl	List_get_gc_head_node
	uxth	fp, r0
	movw	r3, #65535
	cmp	fp, r3
	strh	fp, [r6]	@ movhi
	bne	.L3013
	movs	r3, #0
	movs	r0, #8
	strh	r3, [r10]	@ movhi
	b	.L2988
.L3050:
	movs	r4, #1
	b	.L2991
.L3013:
	str	r0, [sp]
	mov	r0, fp
	bl	IsBlkInGcList
	add	r3, r8, #1
	ldr	r2, [sp]
	cbz	r0, .L3014
	strh	r3, [r10]	@ movhi
	b	.L3012
.L3014:
	ldr	r1, .L3087+32
	uxth	r3, r3
	ldr	lr, .L3087+104
	uxth	r2, r2
	ldr	r8, .L3087+72
	ldrh	r1, [r1]
	ldrh	lr, [lr]
	ldr	r0, [r8]
	strh	r3, [r10]	@ movhi
	mul	r1, lr, r1
	ldrh	ip, [r0, r2, lsl #1]
	cmp	ip, r1, asr #1
	bgt	.L3016
	cmp	r3, #48
	bls	.L3017
	cmp	ip, #8
	bls	.L3017
	ldr	r3, .L3087+96
	ldrh	r3, [r3]
	cmp	r3, #35
	bhi	.L3017
.L3016:
	movs	r3, #0
	strh	r3, [r7]	@ movhi
.L3017:
	ldrh	r3, [r0, r2, lsl #1]
	cmp	r1, r3
	bgt	.L3018
	ldrh	r2, [r7]
	cmp	r2, #3
	bhi	.L3018
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
	movs	r3, #0
	strh	r3, [r7]	@ movhi
.L3086:
	ldr	r3, .L3087+44
	ldrh	r0, [r3]
	b	.L2988
.L3018:
	cmp	r3, #0
	bne	.L3019
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r3, [r7]
	adds	r3, r3, #1
	strh	r3, [r7]	@ movhi
	b	.L3012
.L3088:
	.align	2
.L3087:
	.word	.LANCHOR76
	.word	.LANCHOR171
	.word	.LANCHOR85
	.word	.LANCHOR113
	.word	.LANCHOR112
	.word	.LANCHOR114
	.word	.LANCHOR115
	.word	.LANCHOR88
	.word	.LANCHOR52
	.word	.LANCHOR176
	.word	.LANCHOR93
	.word	.LANCHOR243
	.word	.LANCHOR72
	.word	.LANCHOR100
	.word	.LANCHOR224
	.word	.LANCHOR172
	.word	.LANCHOR116
	.word	.LANCHOR205
	.word	.LANCHOR83
	.word	.LANCHOR15
	.word	.LANCHOR244
	.word	.LANCHOR245
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR109
	.word	.LANCHOR178
	.word	.LANCHOR38
.L3019:
	movs	r3, #0
	strb	r3, [r6, #8]
	ldr	r3, .L3089
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3020
	mov	r0, fp
	bl	ftl_get_blk_mode
	strb	r0, [r6, #8]
.L3020:
	ldr	r3, .L3089+4
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L3021
	ldr	r1, .L3089+8
	movw	r2, #902
	ldr	r0, .L3089+12
	bl	printf
	ldr	r1, .L3089+16
	ldr	r0, .L3089+20
	bl	printf
.L3021:
	ldr	r3, .L3089+24
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L3022
	ldr	r1, .L3089+8
	movw	r2, #903
	ldr	r0, .L3089+12
	bl	printf
	ldr	r1, .L3089+16
	ldr	r0, .L3089+20
	bl	printf
.L3022:
	ldr	r3, .L3089+28
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L3023
	ldr	r1, .L3089+8
	mov	r2, #904
	ldr	r0, .L3089+12
	bl	printf
	ldr	r1, .L3089+16
	ldr	r0, .L3089+20
	bl	printf
.L3023:
	mov	r0, r5
	bl	make_superblock
	ldr	r2, .L3089+32
	movs	r3, #0
	ldrh	r1, [r6]
	strh	r3, [r2]	@ movhi
	ldr	r2, [r8]
	ldrh	r1, [r2, r1, lsl #1]
	ldr	r2, .L3089+36
	strh	r3, [r6, #2]	@ movhi
	strb	r3, [r6, #6]
	strh	r1, [r2]	@ movhi
.L3011:
	ldr	r3, .L3089+40
	movs	r2, #1
	str	r2, [r3]
	ldr	r3, .L3089+44
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, .L3089
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L3024
	ldrb	r3, [r6, #8]	@ zero_extendqisi2
	cmp	r3, r2
	ittt	eq
	ldreq	r3, .L3089+48
	ldrheq	r3, [r3]
	streq	r3, [sp, #4]
.L3024:
	ldrh	r3, [r6, #2]
	ldr	r1, [sp, #4]
	ldr	fp, .L3089+76
	adds	r2, r3, r4
	cmp	r2, r1
	itt	gt
	movgt	r2, r1
	subgt	r4, r2, r3
	mov	r3, #0
	it	gt
	uxthgt	r4, r4
	str	r3, [sp, #12]
.L3026:
	ldrh	r3, [sp, #12]
	cmp	r4, r3
	bls	.L3034
	ldr	r3, .L3089+52
	movw	r8, #65535
	ldrh	lr, [r5, #2]
	mov	r10, #36
	ldr	r0, [fp]
	ldrh	r7, [r3]
	ldr	r3, [sp, #12]
	add	lr, lr, r3
	ldr	r3, .L3089+56
	str	r3, [sp, #8]
	movs	r3, #0
	str	r3, [sp]
	b	.L3035
.L3028:
	ldr	r1, [sp, #8]
	ldrh	r2, [r1, #2]!
	cmp	r2, r8
	str	r1, [sp, #8]
	beq	.L3027
	ldr	r1, [sp]
	orr	r2, lr, r2, lsl #10
	mla	ip, r10, r1, r0
	str	r2, [ip, #4]
	mov	r2, r1
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp]
.L3027:
	adds	r3, r3, #1
.L3035:
	uxth	r2, r3
	cmp	r7, r2
	bhi	.L3028
	ldrb	r2, [r5, #8]	@ zero_extendqisi2
	ldr	r1, [sp]
	bl	FlashReadPages
	movs	r3, #0
.L3085:
	str	r3, [sp, #8]
	ldr	r2, [sp]
	ldrh	r3, [sp, #8]
	cmp	r2, r3
	bhi	.L3033
	ldr	r3, [sp, #12]
	adds	r3, r3, #1
	str	r3, [sp, #12]
	b	.L3026
.L3033:
	ldr	r3, [sp, #8]
	movs	r7, #36
	muls	r7, r3, r7
	ldr	r3, [fp]
	adds	r2, r3, r7
	ldr	r3, [r3, r7]
	adds	r3, r3, #1
	beq	.L3030
	ldr	r8, [r2, #12]
	movw	r3, #61589
	ldrh	r2, [r8]
	cmp	r2, r3
	bne	.L3030
	ldr	r10, [r8, #8]
	cmp	r10, #-1
	bne	.L3031
	ldr	r1, .L3089+8
	movw	r2, #943
	ldr	r0, .L3089+12
	bl	printf
	ldr	r1, .L3089+16
	ldr	r0, .L3089+20
	bl	printf
.L3031:
	movs	r2, #0
	add	r1, sp, #24
	mov	r0, r10
	bl	log2phys
	ldr	r0, [fp]
	ldr	r3, [sp, #24]
	add	r0, r0, r7
	ldr	r2, [r0, #4]
	bic	r3, r3, #-2147483648
	cmp	r3, r2
	bne	.L3030
	ldr	r2, .L3089+32
	ldr	r1, .L3089+60
	ldr	r10, .L3089+72
	ldrh	r3, [r2]
	str	r1, [sp, #20]
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldr	r2, [r1]
	movs	r1, #36
	ldr	r3, [r10]
	mla	r3, r1, r3, r2
	ldr	r2, [r0, #16]
	str	r2, [r3, #16]
	str	r3, [sp, #16]
	bl	Ftl_get_new_temp_ppa
	ldr	r3, [sp, #16]
	ldr	r1, [sp, #20]
	str	r0, [r3, #4]
	ldr	r2, [r1]
	movs	r1, #36
	ldr	r3, [r10]
	ldr	r0, [fp]
	mla	r2, r1, r3, r2
	add	r0, r0, r7
	ldr	r7, .L3089+28
	ldr	r1, [r0, #8]
	adds	r3, r3, #1
	str	r1, [r2, #8]
	ldr	r1, [r0, #12]
	str	r1, [r2, #12]
	movs	r1, #1
	ldr	r2, [sp, #24]
	str	r2, [r8, #12]
	ldrh	r2, [r7]
	strh	r2, [r8, #2]	@ movhi
	ldr	r2, .L3089+64
	str	r3, [r10]
	ldr	r2, [r2]
	str	r2, [r8, #4]
	bl	FtlGcBufAlloc
	ldr	r3, .L3089
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L3032
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldr	r3, [r10]
	cmp	r2, r3
	beq	.L3032
	ldrh	r3, [r7, #4]
	cbnz	r3, .L3030
.L3032:
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L3030
	ldr	r3, .L3089+40
	movs	r2, #0
	movw	r1, #65535
	str	r2, [r3]
	ldr	r3, .L3089+68
	strh	r1, [r3]	@ movhi
	strh	r2, [r3, #2]	@ movhi
	b	.L3086
.L3030:
	ldr	r3, [sp, #8]
	adds	r3, r3, #1
	b	.L3085
.L3034:
	ldrh	r3, [r5, #2]
	add	r4, r4, r3
	ldr	r3, [sp, #4]
	uxth	r4, r4
	cmp	r3, r4
	strh	r4, [r5, #2]	@ movhi
	bhi	.L3036
	ldr	r3, .L3089+72
	ldr	r3, [r3]
	cbz	r3, .L3037
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L3037
	ldr	r3, .L3089+40
	movs	r2, #0
	str	r2, [r3]
	b	.L3086
.L3090:
	.align	2
.L3089:
	.word	.LANCHOR15
	.word	.LANCHOR91
	.word	.LANCHOR246
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR244
	.word	.LANCHOR245
	.word	.LANCHOR171
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR38
	.word	.LANCHOR205+14
	.word	.LANCHOR181
	.word	.LANCHOR160
	.word	.LANCHOR205
	.word	.LANCHOR102
	.word	.LANCHOR106
.L3037:
	ldr	r3, .L3091
	ldrh	r7, [r3]
	cbnz	r7, .L3038
	ldr	r8, .L3091+20
	ldrh	r2, [r5]
	ldr	r3, [r8]
	ldrh	r3, [r3, r2, lsl #1]
	cbz	r3, .L3038
	ldr	r4, .L3091+4
.L3039:
	ldr	r3, [r4]
	cmp	r7, r3
	bcs	.L3044
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r7
	bl	log2phys
	ldr	r0, [sp, #28]
	adds	r3, r0, #1
	beq	.L3040
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r5]
	cmp	r3, r0
	bne	.L3040
.L3044:
	ldr	r3, [r4]
	cmp	r7, r3
	bcc	.L3038
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5]
	bl	update_vpc_list
	bl	FtlCacheWriteBack
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L3038:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L3036:
	ldr	r3, .L3091+8
	ldrh	r0, [r3]
	cmp	r0, #2
	bhi	.L3045
	ldr	r3, .L3091+12
	ldrh	r4, [r3]
	b	.L3046
.L3040:
	adds	r7, r7, #1
	b	.L3039
.L3045:
	ldr	r3, .L3091+16
	movs	r2, #0
	adds	r0, r0, #1
	str	r2, [r3]
	b	.L2988
.L3047:
	movs	r0, #0
	b	.L2988
.L3049:
	mov	r0, r3
	b	.L2988
.L3092:
	.align	2
.L3091:
	.word	.LANCHOR244
	.word	.LANCHOR72
	.word	.LANCHOR88
	.word	.LANCHOR52
	.word	.LANCHOR171
	.word	.LANCHOR83
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
	.section	.text.FtlInit,"ax",%progbits
	.align	1
	.global	FtlInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlInit, %function
FtlInit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	mov	r3, #-1
	ldr	r5, .L3103
	mov	r4, r0
	ldr	r2, .L3103+4
	str	r3, [r5]
	movs	r3, #0
	ldr	r1, .L3103+8
	str	r3, [r2]
	ldr	r2, .L3103+12
	ldr	r0, .L3103+16
	str	r3, [r2]
	bl	printf
	mov	r0, r4
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	ldr	r3, .L3103+20
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L3094
	ldr	r1, .L3103+24
	ldr	r0, .L3103+28
.L3102:
	bl	printf
.L3095:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, pc}
.L3094:
	bl	FtlSysBlkInit
	mov	r4, r0
	cbz	r0, .L3096
	ldr	r1, .L3103+24
	ldr	r0, .L3103+32
	b	.L3102
.L3096:
	movs	r1, #1
	str	r1, [r5]
	ldr	r5, .L3103+36
	bl	rk_ftl_garbage_collect
	ldrh	r6, [r5]
	cmp	r6, #15
	bhi	.L3095
	ldr	r7, .L3103+40
	ldr	r8, .L3103+44
.L3100:
	ldrh	r3, [r7]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L3098
	ldrh	r2, [r8]
	cmp	r2, r3
	bne	.L3098
	and	r0, r4, #7
	bl	List_get_gc_head_node
	uxth	r0, r0
	bl	FtlGcRefreshBlock
.L3098:
	movs	r1, #1
	mov	r0, r1
	bl	rk_ftl_garbage_collect
	ldrh	r2, [r5]
	adds	r3, r6, #2
	cmp	r2, r3
	bhi	.L3095
	adds	r4, r4, #1
	cmp	r4, #1024
	bne	.L3100
	b	.L3095
.L3104:
	.align	2
.L3103:
	.word	.LANCHOR232
	.word	.LANCHOR247
	.word	.LC71
	.word	.LANCHOR76
	.word	.LC7
	.word	.LANCHOR39
	.word	.LANCHOR248
	.word	.LC72
	.word	.LC73
	.word	.LANCHOR88
	.word	.LANCHOR205
	.word	.LANCHOR112
	.size	FtlInit, .-FtlInit
	.section	.text.rk_ftl_init,"ax",%progbits
	.align	1
	.global	rk_ftl_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rk_ftl_init, %function
rk_ftl_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	bl	FlashInit
	mov	r4, r0
	cbnz	r0, .L3106
	ldr	r0, .L3107
	bl	FtlInit
.L3106:
	bl	idb_init
	mov	r1, r4
	ldr	r0, .L3107+4
	bl	printf
	mov	r0, r4
	pop	{r4, pc}
.L3108:
	.align	2
.L3107:
	.word	.LANCHOR14
	.word	.LC74
	.size	rk_ftl_init, .-rk_ftl_init
	.section	.text.ftl_fix_nand_power_lost_error,"ax",%progbits
	.align	1
	.global	ftl_fix_nand_power_lost_error
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_fix_nand_power_lost_error, %function
ftl_fix_nand_power_lost_error:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L3123
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3109
	ldr	r7, .L3123+4
	ldr	r6, .L3123+8
	ldr	r10, .L3123+32
	ldrh	r5, [r7]
	ldr	r3, [r6]
	ldr	r4, .L3123+12
	mov	r1, r5
	ldr	r0, .L3123+16
	ldrh	r2, [r3, r5, lsl #1]
	lsl	r8, r5, #1
	bl	printf
	ldrh	r0, [r10]
	bl	FtlGcRefreshOpenBlock
	ldrh	r0, [r4]
	bl	FtlGcRefreshOpenBlock
	mov	r0, r10
	bl	allocate_new_data_superblock
	mov	r0, r4
	movw	r4, #4097
	bl	allocate_new_data_superblock
	str	r7, [sp, #4]
.L3111:
	subs	r4, r4, #1
	beq	.L3115
	movs	r1, #1
	mov	r0, r1
	bl	rk_ftl_garbage_collect
	ldr	r3, [r6]
	ldrh	r3, [r3, r8]
	cmp	r3, #0
	bne	.L3111
.L3115:
	ldr	r3, [r6]
	mov	r1, r5
	ldr	r0, .L3123+16
	ldrh	r2, [r3, r5, lsl #1]
	bl	printf
	ldr	r3, [r6]
	ldrh	r4, [r3, r5, lsl #1]
	cbnz	r4, .L3113
	add	r0, sp, #56
	ldr	r7, .L3123+20
	strh	r5, [r0, #-48]!	@ movhi
	movw	r10, #65535
	bl	make_superblock
	ldr	r3, .L3123+24
	add	r0, sp, #22
	ldr	r8, [r7]
	mov	r2, r4
	mov	fp, #36
	mov	ip, r4
	ldrh	lr, [r3]
.L3116:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L3118
	ldr	r3, [r6]
	mov	r1, r5
	ldr	r0, .L3123+28
	ldrh	r2, [r3, r5, lsl #1]
	bl	printf
	mov	r2, r4
	movs	r1, #0
	ldr	r0, [r7]
	bl	FlashEraseBlocks
	mov	r2, r4
	movs	r1, #1
	ldr	r0, [r7]
	bl	FlashEraseBlocks
.L3113:
	ldr	r2, [sp, #4]
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L3109:
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3118:
	ldrh	r3, [r0, #2]!
	cmp	r3, r10
	beq	.L3117
	mla	r1, fp, r4, r8
	adds	r4, r4, #1
	lsls	r3, r3, #10
	uxth	r4, r4
	str	r3, [r1, #4]
	str	ip, [r1, #8]
	str	ip, [r1, #12]
.L3117:
	adds	r2, r2, #1
	b	.L3116
.L3124:
	.align	2
.L3123:
	.word	.LANCHOR15
	.word	.LANCHOR237
	.word	.LANCHOR83
	.word	.LANCHOR92
	.word	.LC75
	.word	.LANCHOR77
	.word	.LANCHOR38
	.word	.LC76
	.word	.LANCHOR91
	.size	ftl_fix_nand_power_lost_error, .-ftl_fix_nand_power_lost_error
	.section	.text.ftl_read,"ax",%progbits
	.align	1
	.global	ftl_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_read, %function
ftl_read:
	@ args = 0, pretend = 0, frame = 64
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r0, #16
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #88
	mov	r6, r1
	mov	r7, r3
	str	r2, [sp, #52]
	bne	.L3126
	mov	r2, r3
	ldr	r1, [sp, #52]
	add	r0, r6, #256
	bl	FtlVendorPartRead
	str	r0, [sp, #32]
.L3125:
	ldr	r0, [sp, #32]
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3126:
	ldr	r3, [sp, #52]
	adds	r3, r1, r3
	str	r3, [sp, #36]
	ldr	r3, .L3164
	ldr	r2, [sp, #36]
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L3149
	ldr	r3, .L3164+4
	ldr	r3, [r3]
	adds	r4, r3, #1
	beq	.L3150
	bl	FtlCacheWriteBack
	ldr	r3, .L3164+8
	mov	r0, r6
	ldr	r10, .L3164+52
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	ldr	r3, [sp, #36]
	mov	r1, r4
	str	r0, [sp, #40]
	subs	r0, r3, #1
	bl	__aeabi_uidiv
	ldr	r3, [sp, #40]
	ldr	r2, .L3164+12
	ldr	r4, [sp, #40]
	rsb	r3, r3, #1
	str	r0, [sp, #44]
	add	r3, r3, r0
	str	r3, [sp, #28]
	ldr	r1, [sp, #28]
	ldr	r3, [r2]
	add	r3, r3, r1
	str	r3, [r2]
	movs	r3, #0
	mov	r5, r3
	str	r3, [sp, #24]
	str	r3, [sp, #48]
	str	r3, [sp, #32]
.L3128:
	ldr	r3, [sp, #28]
	cbnz	r3, .L3148
	ldr	r3, .L3164+16
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L3125
	movs	r1, #1
	ldr	r0, [sp, #28]
	bl	rk_ftl_garbage_collect
	b	.L3125
.L3148:
	movs	r2, #0
	add	r1, sp, #84
	mov	r0, r4
	bl	log2phys
	ldr	r3, [sp, #84]
	adds	r0, r3, #1
	bne	.L3129
	ldr	fp, .L3164+8
	mov	r8, #0
.L3130:
	ldrh	r0, [fp]
	cmp	r8, r0
	bcc	.L3132
.L3133:
	ldr	r3, [sp, #28]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #28]
	beq	.L3137
	ldr	r3, .L3164+20
	ldrh	r3, [r3]
	cmp	r5, r3, lsl #2
	bne	.L3128
.L3137:
	cmp	r5, #0
	beq	.L3128
	movs	r2, #0
	mov	r1, r5
	ldr	r0, [r10]
	mov	fp, #0
	bl	FlashReadPages
	ldr	r3, [sp, #24]
	lsls	r3, r3, #9
	str	r3, [sp, #68]
	ldr	r3, [sp, #56]
	lsls	r3, r3, #9
	str	r3, [sp, #60]
	ldr	r3, [sp, #48]
	lsls	r3, r3, #9
	str	r3, [sp, #64]
.L3147:
	mov	r8, #36
	ldr	r3, [r10]
	mul	r8, r8, fp
	ldr	r1, [sp, #40]
	add	r3, r3, r8
	ldr	r2, [r3, #16]
	cmp	r1, r2
	bne	.L3139
	ldr	r1, [r3, #8]
	ldr	r3, .L3164+24
	ldr	r3, [r3]
	cmp	r1, r3
	bne	.L3140
	ldr	r3, [sp, #60]
	mov	r0, r7
	ldr	r2, [sp, #64]
	add	r1, r1, r3
.L3163:
	bl	ftl_memcpy
.L3140:
	ldr	r2, [r10]
	add	r2, r2, r8
	ldr	r3, [r2, #12]
	ldr	lr, [r2, #16]
	ldr	r0, [r3, #8]
	cmp	lr, r0
	beq	.L3141
	ldr	ip, .L3164+32
	ldr	r0, [ip, #72]
	adds	r0, r0, #1
	str	r0, [ip, #72]
	ldr	r0, [r2, #8]
	ldr	r1, [r0, #4]
	str	r1, [sp, #16]
	mov	r1, lr
	ldr	r0, [r0]
	str	r0, [sp, #12]
	ldr	r0, [r3, #12]
	str	r0, [sp, #8]
	ldr	r0, [r3, #8]
	str	r0, [sp, #4]
	ldr	r0, [r3, #4]
	str	r0, [sp]
	ldr	r0, .L3164+28
	ldr	r3, [r3]
	ldr	r2, [r2, #4]
	bl	printf
.L3141:
	ldr	r3, [r10]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	adds	r1, r3, #1
	bne	.L3142
	ldr	r1, .L3164+32
	str	r3, [sp, #32]
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L3143:
	add	fp, fp, #1
	cmp	r5, fp
	bne	.L3147
	movs	r5, #0
	b	.L3128
.L3132:
	mla	r0, r0, r4, r8
	cmp	r6, r0
	bhi	.L3131
	ldr	r3, [sp, #36]
	cmp	r3, r0
	bls	.L3131
	subs	r0, r0, r6
	mov	r2, #512
	movs	r1, #0
	add	r0, r7, r0, lsl #9
	bl	ftl_memset
.L3131:
	add	r8, r8, #1
	b	.L3130
.L3129:
	ldr	r2, [r10]
	mov	r8, #36
	mla	r8, r8, r5, r2
	str	r3, [r8, #4]
	ldr	r3, [sp, #40]
	cmp	r4, r3
	ldr	r3, .L3164+8
	bne	.L3134
	ldr	r2, .L3164+24
	mov	r0, r6
	ldrh	fp, [r3]
	ldr	r2, [r2]
	mov	r1, fp
	str	r2, [r8, #8]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #52]
	sub	r3, fp, r1
	str	r1, [sp, #56]
	cmp	r3, r2
	it	cs
	movcs	r3, r2
	cmp	fp, r3
	str	r3, [sp, #48]
	bne	.L3135
	str	r7, [r8, #8]
.L3135:
	ldr	r3, .L3164+36
	ldr	r2, .L3164+40
	str	r4, [r8, #16]
	ldrh	r3, [r3]
	ldr	r2, [r2]
	muls	r3, r5, r3
	adds	r5, r5, #1
	bic	r3, r3, #3
	add	r3, r3, r2
	str	r3, [r8, #12]
	b	.L3133
.L3134:
	ldr	r2, [sp, #44]
	cmp	r4, r2
	bne	.L3136
	ldr	r2, .L3164+44
	ldr	r1, [sp, #36]
	ldr	r2, [r2]
	str	r2, [r8, #8]
	ldrh	r2, [r3]
	mul	r3, r2, r4
	subs	r1, r1, r3
	cmp	r2, r1
	str	r1, [sp, #24]
	bne	.L3135
.L3162:
	subs	r3, r3, r6
	add	r3, r7, r3, lsl #9
	str	r3, [r8, #8]
	b	.L3135
.L3136:
	ldrh	r3, [r3]
	muls	r3, r4, r3
	b	.L3162
.L3139:
	ldr	r1, [sp, #44]
	cmp	r1, r2
	bne	.L3140
	ldr	r1, [r3, #8]
	ldr	r3, .L3164+44
	ldr	r3, [r3]
	cmp	r1, r3
	bne	.L3140
	ldr	r3, .L3164+8
	ldr	r2, [sp, #68]
	ldrh	r0, [r3]
	ldr	r3, [sp, #44]
	muls	r0, r3, r0
	subs	r0, r0, r6
	add	r0, r7, r0, lsl #9
	b	.L3163
.L3142:
	cmp	r3, #256
	bne	.L3143
	ldr	r0, [r2, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	mov	r8, r0
	bl	FtlGcRefreshBlock
	ldr	r2, .L3164+48
	movw	r3, #2049
.L3145:
	subs	r3, r3, #1
	bne	.L3144
.L3146:
	bl	FtlSysFlush
	b	.L3143
.L3144:
	movs	r1, #1
	str	r2, [sp, #76]
	mov	r0, r1
	str	r3, [sp, #72]
	bl	rk_ftl_garbage_collect
	ldr	r2, [sp, #76]
	ldr	r3, [sp, #72]
	ldrh	r1, [r2]
	cmp	r1, r8
	beq	.L3145
	b	.L3146
.L3149:
	mov	r3, #-1
.L3150:
	str	r3, [sp, #32]
	b	.L3125
.L3165:
	.align	2
.L3164:
	.word	.LANCHOR68
	.word	.LANCHOR232
	.word	.LANCHOR55
	.word	.LANCHOR166
	.word	.LANCHOR116
	.word	.LANCHOR38
	.word	.LANCHOR186
	.word	.LC64
	.word	.LANCHOR138
	.word	.LANCHOR58
	.word	.LANCHOR189
	.word	.LANCHOR187
	.word	.LANCHOR205
	.word	.LANCHOR180
	.size	ftl_read, .-ftl_read
	.section	.text.FtlWrite,"ax",%progbits
	.align	1
	.global	FtlWrite
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlWrite, %function
FtlWrite:
	@ args = 0, pretend = 0, frame = 80
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r3
	ldr	r3, .L3214
	sub	sp, sp, #80
	mov	r6, r1
	str	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L3199
	cmp	r0, #16
	bne	.L3168
	mov	r2, r10
	ldr	r1, [sp, #12]
	add	r0, r6, #256
	bl	FtlVendorPartWrite
.L3166:
	add	sp, sp, #80
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3168:
	ldr	r3, [sp, #12]
	adds	r5, r1, r3
	ldr	r3, .L3214+4
	ldr	r3, [r3]
	cmp	r5, r3
	bhi	.L3200
	ldr	r3, .L3214+8
	ldr	r0, [r3]
	adds	r4, r0, #1
	beq	.L3166
	ldr	r3, .L3214+12
	mov	r2, #2048
	mov	r0, r6
	str	r2, [r3]
	ldr	r3, .L3214+16
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	mov	r1, r4
	mov	r8, r0
	subs	r0, r5, #1
	bl	__aeabi_uidiv
	ldr	r2, .L3214+20
	sub	r5, r0, r8
	adds	r3, r5, #1
	adds	r1, r5, #1
	str	r3, [sp, #4]
	ldr	r3, [r2]
	str	r0, [sp, #16]
	add	r3, r3, r1
	str	r3, [r2]
	ldr	r3, .L3214+24
	ldr	fp, [r3]
	cmp	fp, #0
	beq	.L3170
	ldr	r3, [fp, #16]
	cmp	r8, r3
	beq	.L3171
	bl	FtlCacheWriteBack
.L3170:
	ldr	r7, .L3214+28
	mov	r4, r8
.L3172:
	ldr	r3, [sp, #4]
	cbnz	r3, .L3198
	ldr	r3, [sp, #16]
	ldr	r0, [sp, #4]
	sub	r1, r3, r8
	bl	rk_ftl_garbage_collect
.L3199:
	movs	r0, #0
	b	.L3166
.L3171:
	ldr	r2, .L3214+32
	mov	r1, r4
	mov	r0, r6
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #12]
	subs	r4, r4, r1
	ldr	r0, [fp, #8]
	mov	r3, r1
	mov	r1, r10
	cmp	r4, r2
	it	cs
	movcs	r4, r2
	lsls	r7, r4, #9
	add	r0, r0, r3, lsl #9
	mov	r2, r7
	bl	ftl_memcpy
	cmp	r5, #0
	beq	.L3199
	ldr	r3, [sp, #12]
	add	r6, r6, r4
	add	r10, r10, r7
	add	r8, r8, #1
	subs	r3, r3, r4
	str	r3, [sp, #12]
	bl	FtlCacheWriteBack
	str	r5, [sp, #4]
	b	.L3170
.L3198:
	ldr	r5, .L3214+36
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r5]
	cmp	r2, r3
	bcc	.L3173
	ldr	r1, .L3214+40
	movw	r2, #1673
	ldr	r0, .L3214+44
	bl	printf
	ldr	r1, .L3214+48
	ldr	r0, .L3214+52
	bl	printf
.L3173:
	ldrh	r3, [r7, #4]
	cbnz	r3, .L3174
	bl	FtlCacheWriteBack
	mov	r0, r7
	bl	allocate_new_data_superblock
.L3174:
	ldrb	r3, [r7, #7]	@ zero_extendqisi2
	ldrh	r2, [r7, #4]
	lsls	r3, r3, #2
	cmp	r3, r2
	it	cs
	movcs	r3, r2
	ldr	r2, [sp, #4]
	cmp	r3, r2
	it	cs
	movcs	r3, r2
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	str	r3, [sp, #36]
	ldrh	r3, [r5]
	cmp	r2, r3
	bcc	.L3175
	ldr	r1, .L3214+40
	movw	r2, #1706
	ldr	r0, .L3214+44
	bl	printf
	ldr	r1, .L3214+48
	ldr	r0, .L3214+52
	bl	printf
.L3175:
	movs	r3, #0
.L3213:
	str	r3, [sp, #8]
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #36]
	cmp	r3, r2
	bne	.L3196
.L3177:
	ldr	r0, .L3214+56
	mov	r3, r7
	movs	r2, #0
	ldr	r1, [sp, #8]
	ldr	r0, [r0]
	bl	FtlProgPages
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #8]
	cmp	r3, r2
	bcs	.L3197
	ldr	r1, .L3214+40
	movw	r2, #1795
	ldr	r0, .L3214+44
	bl	printf
	ldr	r1, .L3214+48
	ldr	r0, .L3214+52
	bl	printf
.L3197:
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #8]
	subs	r3, r3, r2
	str	r3, [sp, #4]
	b	.L3172
.L3196:
	ldrh	r3, [r7, #4]
	cmp	r3, #0
	beq	.L3177
	movs	r2, #0
	add	r1, sp, #40
	mov	r0, r4
	movs	r5, #36
	bl	log2phys
	mov	r0, r7
	bl	get_new_active_ppa
	ldr	r3, [sp, #8]
	ldr	r2, .L3214+60
	muls	r5, r3, r5
	ldr	r3, .L3214+56
	ldrh	r2, [r2]
	ldr	r1, [r3]
	str	r3, [sp, #20]
	ldr	r3, [sp, #8]
	add	r1, r1, r5
	str	r0, [r1, #4]
	str	r4, [r1, #16]
	mul	r0, r2, r3
	bic	r3, r0, #3
	ldr	r0, .L3214+64
	str	r3, [sp, #28]
	ldr	r3, [r0]
	ldr	r0, [sp, #28]
	str	r3, [sp, #32]
	add	fp, r3, r0
	str	fp, [r1, #12]
	mov	r0, fp
	movs	r1, #0
	bl	ftl_memset
	cmp	r4, r8
	ldr	r1, .L3214+16
	beq	.L3178
	ldr	r3, [sp, #16]
	cmp	r3, r4
	ldr	r3, [sp, #20]
	bne	.L3209
	ldr	r3, [sp, #12]
	adds	r2, r6, r3
	ldrh	r3, [r1]
	ldrh	r1, [sp, #16]
	smulbb	r3, r3, r1
	subs	r2, r2, r3
	uxth	r3, r2
	str	r3, [sp, #20]
	movs	r3, #0
	str	r3, [sp, #24]
	b	.L3181
.L3178:
	ldrh	r2, [r1]
	mov	r0, r6
	mov	r1, r2
	str	r2, [sp, #20]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #20]
	str	r1, [sp, #24]
	subs	r2, r2, r1
	ldr	r1, [sp, #12]
	mov	r3, r2
	cmp	r2, r1
	it	cs
	movcs	r3, r1
	str	r3, [sp, #20]
.L3181:
	ldr	r3, .L3214+16
	ldr	r2, [sp, #20]
	ldrh	r3, [r3]
	cmp	r3, r2
	ldr	r3, .L3214+56
	ldr	r3, [r3]
	bne	.L3182
	cmp	r4, r8
	add	r5, r5, r3
	itett	ne
	ldrne	r2, [sp, #20]
	streq	r10, [r5, #8]
	mulne	r2, r2, r4
	subne	r2, r2, r6
	itt	ne
	addne	r2, r10, r2, lsl #9
	strne	r2, [r5, #8]
.L3184:
	ldr	r3, .L3214+36
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L3193
	ldr	r1, .L3214+40
	movw	r2, #1780
	ldr	r0, .L3214+44
	bl	printf
	ldr	r1, .L3214+48
	ldr	r0, .L3214+52
	bl	printf
.L3193:
	ldr	r2, [sp, #32]
	movw	r3, #61589
	ldr	r1, [sp, #28]
	strh	r3, [r2, r1]	@ movhi
	ldr	r2, .L3214+68
	str	r4, [fp, #8]
	adds	r4, r4, #1
	ldr	r3, [r2]
	str	r3, [fp, #4]
	adds	r3, r3, #1
	adds	r1, r3, #1
	it	eq
	moveq	r3, #0
	str	r3, [r2]
	ldr	r3, [sp, #40]
	str	r3, [fp, #12]
	ldrh	r3, [r7]
	strh	r3, [fp, #2]	@ movhi
	ldr	r3, [sp, #8]
	adds	r3, r3, #1
	b	.L3213
.L3215:
	.align	2
.L3214:
	.word	.LANCHOR76
	.word	.LANCHOR68
	.word	.LANCHOR232
	.word	.LANCHOR249
	.word	.LANCHOR55
	.word	.LANCHOR162
	.word	.LANCHOR132
	.word	.LANCHOR91
	.word	.LANCHOR164
	.word	.LANCHOR38
	.word	.LANCHOR250
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR182
	.word	.LANCHOR58
	.word	.LANCHOR189
	.word	.LANCHOR160
.L3182:
	cmp	r4, r8
	add	r3, r3, r5
	ite	eq
	ldreq	r2, .L3216
	ldrne	r2, .L3216+4
	ldr	r2, [r2]
	str	r2, [r3, #8]
	ldr	r2, [sp, #40]
	ldr	r3, .L3216+8
	adds	r0, r2, #1
	beq	.L3187
	ldr	r3, [r3]
	movs	r1, #1
	str	r2, [sp, #48]
	add	r0, sp, #44
	str	r4, [sp, #60]
	add	r3, r3, r5
	ldr	r2, [r3, #8]
	ldr	r3, [r3, #12]
	str	r2, [sp, #52]
	movs	r2, #0
	str	r3, [sp, #56]
	bl	FlashReadPages
	ldr	r3, [sp, #44]
	adds	r3, r3, #1
	bne	.L3188
	ldr	r2, .L3216+12
	ldr	r3, [r2, #72]
	adds	r3, r3, #1
	str	r3, [r2, #72]
.L3191:
	ldr	r2, [sp, #20]
	cmp	r4, r8
	ldr	r3, .L3216+8
	lsl	r2, r2, #9
	bne	.L3192
	ldr	r3, [r3]
	mov	r1, r10
	add	r5, r5, r3
	ldr	r3, [sp, #24]
	ldr	r0, [r5, #8]
	add	r0, r0, r3, lsl #9
.L3211:
	bl	ftl_memcpy
	b	.L3184
.L3188:
	ldr	r1, [fp, #8]
	cmp	r4, r1
	beq	.L3190
	ldr	r2, .L3216+12
	ldr	r0, .L3216+16
	ldr	r3, [r2, #72]
	adds	r3, r3, #1
	str	r3, [r2, #72]
	mov	r2, r4
	bl	printf
.L3190:
	ldr	r3, [fp, #8]
	cmp	r4, r3
	beq	.L3191
	movw	r2, #1759
	ldr	r1, .L3216+20
	ldr	r0, .L3216+24
	bl	printf
	ldr	r1, .L3216+28
	ldr	r0, .L3216+32
	bl	printf
	b	.L3191
.L3187:
	ldr	r3, [r3]
	movs	r1, #0
	ldr	r2, .L3216+36
	add	r3, r3, r5
	ldrh	r2, [r2]
	ldr	r0, [r3, #8]
	bl	ftl_memset
	b	.L3191
.L3192:
	ldr	r1, .L3216+40
	ldr	r3, [r3]
	ldrh	r1, [r1]
	add	r5, r5, r3
	ldr	r0, [r5, #8]
	muls	r1, r4, r1
	subs	r1, r1, r6
	add	r1, r10, r1, lsl #9
	b	.L3211
.L3209:
	ldr	r3, [r3]
	add	r5, r5, r3
	ldrh	r3, [r1]
	muls	r3, r4, r3
	subs	r3, r3, r6
	add	r3, r10, r3, lsl #9
	str	r3, [r5, #8]
	b	.L3184
.L3200:
	mov	r0, #-1
	b	.L3166
.L3217:
	.align	2
.L3216:
	.word	.LANCHOR186
	.word	.LANCHOR187
	.word	.LANCHOR182
	.word	.LANCHOR138
	.word	.LC77
	.word	.LANCHOR250
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR57
	.word	.LANCHOR55
	.size	FtlWrite, .-FtlWrite
	.section	.text.ftl_vendor_write,"ax",%progbits
	.align	1
	.global	ftl_vendor_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_vendor_write, %function
ftl_vendor_write:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r2
	mov	r2, r1
	mov	r1, r0
	movs	r0, #16
	b	FtlWrite
	.size	ftl_vendor_write, .-ftl_vendor_write
	.section	.text.ftl_sys_write,"ax",%progbits
	.align	1
	.global	ftl_sys_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_sys_write, %function
ftl_sys_write:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r2
	mov	r2, r1
	add	r1, r0, #256
	movs	r0, #16
	b	FtlWrite
	.size	ftl_sys_write, .-ftl_sys_write
	.section	.text.StorageSysDataStore,"ax",%progbits
	.align	1
	.global	StorageSysDataStore
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	StorageSysDataStore, %function
StorageSysDataStore:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r1
	movs	r2, #1
	add	r1, r0, #256
	movs	r0, #16
	b	FtlWrite
	.size	StorageSysDataStore, .-StorageSysDataStore
	.section	.text.FlashBootVendorWrite,"ax",%progbits
	.align	1
	.global	FlashBootVendorWrite
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashBootVendorWrite, %function
FlashBootVendorWrite:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r2
	mov	r1, r0
	movs	r2, #1
	movs	r0, #16
	b	FtlWrite
	.size	FlashBootVendorWrite, .-FlashBootVendorWrite
	.section	.text.ftl_write,"ax",%progbits
	.align	1
	.global	ftl_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_write, %function
ftl_write:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	mov	r7, r1
	mov	r4, r2
	mov	r5, r3
	mov	r6, r0
	cbnz	r0, .L3223
	mov	r3, r2
	mov	r2, r5
	bl	idb_write_data
.L3223:
	mov	r3, r5
	mov	r2, r4
	mov	r1, r7
	mov	r0, r6
	pop	{r4, r5, r6, r7, r8, lr}
	b	FtlWrite
	.size	ftl_write, .-ftl_write
	.section	.text.FtlDumpSysBlock,"ax",%progbits
	.align	1
	.global	FtlDumpSysBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlDumpSysBlock, %function
FtlDumpSysBlock:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	lsl	r10, r0, #10
	ldr	r5, .L3231
	sub	sp, sp, #24
	mov	r7, r0
	movs	r6, #0
	ldr	r4, .L3231+4
	ldr	r3, [r5]
	ldr	r8, .L3231+20
	mov	fp, r4
	str	r3, [r4, #8]
	ldr	r3, .L3231+8
	ldr	r3, [r3]
	str	r3, [r4, #12]
.L3225:
	ldrh	r2, [r8]
	sxth	r3, r6
	cmp	r3, r2
	blt	.L3227
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3227:
	movs	r2, #1
	orr	r3, r3, r10
	mov	r1, r2
	mov	r0, fp
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r2, [r4, #8]
	mov	r1, r7
	ldr	r3, [r4, #12]
	ldr	r0, .L3231+12
	ldr	r2, [r2]
	str	r2, [sp, #16]
	ldr	r2, [r3, #12]
	str	r2, [sp, #12]
	ldr	r2, [r3, #8]
	str	r2, [sp, #8]
	ldr	r2, [r3, #4]
	str	r2, [sp, #4]
	ldr	r3, [r3]
	str	r3, [sp]
	ldm	r4, {r2, r3}
	bl	printf
	ldr	r3, [r4, #12]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L3226
	mov	r3, #768
	movs	r2, #4
	ldr	r1, [r5]
	ldr	r0, .L3231+16
	bl	rknand_print_hex
.L3226:
	adds	r6, r6, #1
	b	.L3225
.L3232:
	.align	2
.L3231:
	.word	.LANCHOR183
	.word	.LANCHOR203
	.word	.LANCHOR188
	.word	.LC78
	.word	.LC79
	.word	.LANCHOR53
	.size	FtlDumpSysBlock, .-FtlDumpSysBlock
	.section	.text.dump_map_info,"ax",%progbits
	.align	1
	.global	dump_map_info
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	dump_map_info, %function
dump_map_info:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L3247
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	ldr	r8, .L3247+72
	ldrh	r5, [r3]
.L3234:
	ldr	r3, .L3247+4
	ldrh	r3, [r3]
	cmp	r3, r5
	bhi	.L3241
	ldr	r4, .L3247+8
	movs	r7, #0
.L3242:
	ldr	r3, .L3247+12
	sxth	r5, r7
	ldrh	r3, [r3]
	cmp	r5, r3
	bge	.L3245
	lsls	r5, r5, #1
	movs	r6, #0
	ldr	r8, .L3247+76
	b	.L3246
.L3236:
	str	r3, [sp, #36]
	mov	r1, r5
	ldr	r3, .L3247+16
	str	r2, [sp, #32]
	ldrb	r0, [r3, r6]	@ zero_extendqisi2
	bl	V2P_block
	str	r0, [sp, #28]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #32]
	ldr	r3, [sp, #36]
	cbnz	r0, .L3235
	ldr	r1, [sp, #28]
	mla	r0, fp, r4, r7
	lsls	r1, r1, #10
	str	r3, [r0, #8]
	str	r1, [r0, #4]
	mul	r1, r10, r4
	adds	r4, r4, #1
	uxth	r4, r4
	bic	ip, r1, #3
	ldr	r1, [sp, #24]
	add	r1, r1, ip
	str	r1, [r0, #12]
.L3235:
	adds	r6, r6, #1
.L3243:
	uxth	r1, r6
	cmp	r2, r1
	bhi	.L3236
	cbnz	r4, .L3237
.L3240:
	adds	r5, r5, #1
	uxth	r5, r5
	b	.L3234
.L3237:
	ldr	r10, .L3247+80
	mov	r0, r7
	movs	r6, #0
	movs	r7, #36
	movs	r2, #1
	mov	r1, r4
	bl	FlashReadPages
.L3238:
	uxth	r3, r6
	cmp	r4, r3
	bls	.L3240
	ldr	r3, [r8]
	mla	r3, r7, r6, r3
	adds	r6, r6, #1
	ldr	r1, [r3, #12]
	ldr	r2, [r3, #4]
	ldr	r3, [r3, #8]
	ldr	r0, [r3, #4]
	str	r0, [sp, #16]
	mov	r0, r10
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, [r1, #12]
	str	r3, [sp, #8]
	ldr	r3, [r1, #8]
	str	r3, [sp, #4]
	ldr	r3, [r1, #4]
	str	r3, [sp]
	ldr	r3, [r1]
	ubfx	r1, r2, #10, #16
	bl	printf
	b	.L3238
.L3241:
	ldr	r1, .L3247+20
	movs	r6, #0
	ldr	r3, .L3247+24
	mov	r4, r6
	ldr	r7, [r8]
	mov	fp, #36
	ldr	r1, [r1]
	ldrh	r2, [r3]
	ldr	r3, .L3247+28
	str	r1, [sp, #24]
	ldr	r1, .L3247+32
	ldr	r3, [r3]
	ldrh	r10, [r1]
	b	.L3243
.L3244:
	ldr	r10, .L3247+44
	mov	r0, r4
	ldr	r2, [r10]
	ldrh	r2, [r2, r5]
	orr	r3, r3, r2, lsl #10
	movs	r2, #1
	mov	r1, r2
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r2, [r4, #8]
	ldr	r1, [r10]
	ldr	r3, [r4, #12]
	ldr	r0, [r2, #4]
	ldrh	r1, [r1, r5]
	str	r0, [sp, #20]
	ldr	r2, [r2]
	ldr	r0, .L3247+36
	str	r2, [sp, #16]
	ldr	r2, [r3, #12]
	str	r2, [sp, #12]
	ldr	r2, [r3, #8]
	str	r2, [sp, #8]
	ldr	r2, [r3, #4]
	str	r2, [sp, #4]
	ldr	r3, [r3]
	str	r3, [sp]
	ldm	r4, {r2, r3}
	bl	printf
.L3246:
	ldrh	r2, [r8]
	sxth	r3, r6
	adds	r6, r6, #1
	cmp	r3, r2
	blt	.L3244
	adds	r7, r7, #1
	b	.L3242
.L3245:
	ldr	r3, .L3247+40
	movs	r2, #2
	ldr	r1, .L3247+44
	ldr	r0, .L3247+48
	ldr	r3, [r3]
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r4, .L3247+52
	movs	r2, #4
	ldr	r1, .L3247+56
	ldr	r0, .L3247+60
	ldrh	r3, [r4]
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r1, .L3247+64
	movs	r2, #4
	ldrh	r3, [r4]
	ldr	r0, .L3247+68
	ldr	r1, [r1]
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	rknand_print_hex
.L3248:
	.align	2
.L3247:
	.word	.LANCHOR40
	.word	.LANCHOR41
	.word	.LANCHOR203
	.word	.LANCHOR128
	.word	.LANCHOR47
	.word	.LANCHOR105
	.word	.LANCHOR38
	.word	.LANCHOR104
	.word	.LANCHOR58
	.word	.LC48
	.word	.LANCHOR64
	.word	.LANCHOR129
	.word	.LC81
	.word	.LANCHOR66
	.word	.LANCHOR131
	.word	.LC82
	.word	.LANCHOR195
	.word	.LC83
	.word	.LANCHOR180
	.word	.LANCHOR53
	.word	.LC80
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
	.section	.bss.DeviceCapacity,"aw",%nobits
	.align	2
	.set	.LANCHOR60,. + 0
	.type	DeviceCapacity, %object
	.size	DeviceCapacity, 4
DeviceCapacity:
	.space	4
	.section	.bss.DieAddrs,"aw",%nobits
	.align	2
	.set	.LANCHOR17,. + 0
	.type	DieAddrs, %object
	.size	DieAddrs, 32
DieAddrs:
	.space	32
	.section	.bss.DieCsIndex,"aw",%nobits
	.align	2
	.set	.LANCHOR26,. + 0
	.type	DieCsIndex, %object
	.size	DieCsIndex, 8
DieCsIndex:
	.space	8
	.section	.bss.FlashDdrTunningReadCount,"aw",%nobits
	.align	2
	.set	.LANCHOR144,. + 0
	.type	FlashDdrTunningReadCount, %object
	.size	FlashDdrTunningReadCount, 4
FlashDdrTunningReadCount:
	.space	4
	.section	.bss.FlashWaitBusyScheduleEn,"aw",%nobits
	.align	2
	.type	FlashWaitBusyScheduleEn, %object
	.size	FlashWaitBusyScheduleEn, 4
FlashWaitBusyScheduleEn:
	.space	4
	.section	.bss.FtlMallocBuffer,"aw",%nobits
	.align	6
	.type	FtlMallocBuffer, %object
	.size	FtlMallocBuffer, 1310720
FtlMallocBuffer:
	.space	1310720
	.section	.bss.FtlUpdateVaildLpnCount,"aw",%nobits
	.align	1
	.set	.LANCHOR99,. + 0
	.type	FtlUpdateVaildLpnCount, %object
	.size	FtlUpdateVaildLpnCount, 2
FtlUpdateVaildLpnCount:
	.space	2
	.section	.bss.IDByte,"aw",%nobits
	.align	2
	.set	.LANCHOR22,. + 0
	.type	IDByte, %object
	.size	IDByte, 32
IDByte:
	.space	32
	.section	.bss.c_ftl_nand_bbm_buf_size,"aw",%nobits
	.align	1
	.set	.LANCHOR123,. + 0
	.type	c_ftl_nand_bbm_buf_size, %object
	.size	c_ftl_nand_bbm_buf_size, 2
c_ftl_nand_bbm_buf_size:
	.space	2
	.section	.bss.c_ftl_nand_blk_pre_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR41,. + 0
	.type	c_ftl_nand_blk_pre_plane, %object
	.size	c_ftl_nand_blk_pre_plane, 2
c_ftl_nand_blk_pre_plane:
	.space	2
	.section	.bss.c_ftl_nand_blks_per_die,"aw",%nobits
	.align	1
	.set	.LANCHOR51,. + 0
	.type	c_ftl_nand_blks_per_die, %object
	.size	c_ftl_nand_blks_per_die, 2
c_ftl_nand_blks_per_die:
	.space	2
	.section	.bss.c_ftl_nand_byte_pre_oob,"aw",%nobits
	.align	1
	.set	.LANCHOR58,. + 0
	.type	c_ftl_nand_byte_pre_oob, %object
	.size	c_ftl_nand_byte_pre_oob, 2
c_ftl_nand_byte_pre_oob:
	.space	2
	.section	.bss.c_ftl_nand_byte_pre_page,"aw",%nobits
	.align	1
	.set	.LANCHOR57,. + 0
	.type	c_ftl_nand_byte_pre_page, %object
	.size	c_ftl_nand_byte_pre_page, 2
c_ftl_nand_byte_pre_page:
	.space	2
	.section	.bss.c_ftl_nand_data_blks_per_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR40,. + 0
	.type	c_ftl_nand_data_blks_per_plane, %object
	.size	c_ftl_nand_data_blks_per_plane, 2
c_ftl_nand_data_blks_per_plane:
	.space	2
	.section	.bss.c_ftl_nand_data_op_blks_per_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR224,. + 0
	.type	c_ftl_nand_data_op_blks_per_plane, %object
	.size	c_ftl_nand_data_op_blks_per_plane, 2
c_ftl_nand_data_op_blks_per_plane:
	.space	2
	.section	.bss.c_ftl_nand_die_num,"aw",%nobits
	.align	1
	.set	.LANCHOR45,. + 0
	.type	c_ftl_nand_die_num, %object
	.size	c_ftl_nand_die_num, 2
c_ftl_nand_die_num:
	.space	2
	.section	.bss.c_ftl_nand_ext_blk_pre_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR49,. + 0
	.type	c_ftl_nand_ext_blk_pre_plane, %object
	.size	c_ftl_nand_ext_blk_pre_plane, 2
c_ftl_nand_ext_blk_pre_plane:
	.space	2
	.section	.bss.c_ftl_nand_init_sys_blks_per_plane,"aw",%nobits
	.align	2
	.set	.LANCHOR65,. + 0
	.type	c_ftl_nand_init_sys_blks_per_plane, %object
	.size	c_ftl_nand_init_sys_blks_per_plane, 4
c_ftl_nand_init_sys_blks_per_plane:
	.space	4
	.section	.bss.c_ftl_nand_l2pmap_ram_region_num,"aw",%nobits
	.align	1
	.set	.LANCHOR67,. + 0
	.type	c_ftl_nand_l2pmap_ram_region_num, %object
	.size	c_ftl_nand_l2pmap_ram_region_num, 2
c_ftl_nand_l2pmap_ram_region_num:
	.space	2
	.section	.bss.c_ftl_nand_map_blks_per_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR63,. + 0
	.type	c_ftl_nand_map_blks_per_plane, %object
	.size	c_ftl_nand_map_blks_per_plane, 2
c_ftl_nand_map_blks_per_plane:
	.space	2
	.section	.bss.c_ftl_nand_map_region_num,"aw",%nobits
	.align	1
	.set	.LANCHOR66,. + 0
	.type	c_ftl_nand_map_region_num, %object
	.size	c_ftl_nand_map_region_num, 2
c_ftl_nand_map_region_num:
	.space	2
	.section	.bss.c_ftl_nand_max_data_blks,"aw",%nobits
	.align	2
	.set	.LANCHOR42,. + 0
	.type	c_ftl_nand_max_data_blks, %object
	.size	c_ftl_nand_max_data_blks, 4
c_ftl_nand_max_data_blks:
	.space	4
	.section	.bss.c_ftl_nand_max_map_blks,"aw",%nobits
	.align	2
	.set	.LANCHOR64,. + 0
	.type	c_ftl_nand_max_map_blks, %object
	.size	c_ftl_nand_max_map_blks, 4
c_ftl_nand_max_map_blks:
	.space	4
	.section	.bss.c_ftl_nand_max_sys_blks,"aw",%nobits
	.align	2
	.set	.LANCHOR39,. + 0
	.type	c_ftl_nand_max_sys_blks, %object
	.size	c_ftl_nand_max_sys_blks, 4
c_ftl_nand_max_sys_blks:
	.space	4
	.section	.bss.c_ftl_nand_max_vendor_blks,"aw",%nobits
	.align	1
	.set	.LANCHOR61,. + 0
	.type	c_ftl_nand_max_vendor_blks, %object
	.size	c_ftl_nand_max_vendor_blks, 2
c_ftl_nand_max_vendor_blks:
	.space	2
	.section	.bss.c_ftl_nand_page_pre_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR52,. + 0
	.type	c_ftl_nand_page_pre_blk, %object
	.size	c_ftl_nand_page_pre_blk, 2
c_ftl_nand_page_pre_blk:
	.space	2
	.section	.bss.c_ftl_nand_page_pre_slc_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR53,. + 0
	.type	c_ftl_nand_page_pre_slc_blk, %object
	.size	c_ftl_nand_page_pre_slc_blk, 2
c_ftl_nand_page_pre_slc_blk:
	.space	2
	.section	.bss.c_ftl_nand_page_pre_super_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR54,. + 0
	.type	c_ftl_nand_page_pre_super_blk, %object
	.size	c_ftl_nand_page_pre_super_blk, 2
c_ftl_nand_page_pre_super_blk:
	.space	2
	.section	.bss.c_ftl_nand_planes_num,"aw",%nobits
	.align	1
	.set	.LANCHOR38,. + 0
	.type	c_ftl_nand_planes_num, %object
	.size	c_ftl_nand_planes_num, 2
c_ftl_nand_planes_num:
	.space	2
	.section	.bss.c_ftl_nand_planes_per_die,"aw",%nobits
	.align	1
	.set	.LANCHOR46,. + 0
	.type	c_ftl_nand_planes_per_die, %object
	.size	c_ftl_nand_planes_per_die, 2
c_ftl_nand_planes_per_die:
	.space	2
	.section	.bss.c_ftl_nand_reserved_blks,"aw",%nobits
	.align	1
	.set	.LANCHOR59,. + 0
	.type	c_ftl_nand_reserved_blks, %object
	.size	c_ftl_nand_reserved_blks, 2
c_ftl_nand_reserved_blks:
	.space	2
	.section	.bss.c_ftl_nand_sec_pre_page,"aw",%nobits
	.align	1
	.set	.LANCHOR55,. + 0
	.type	c_ftl_nand_sec_pre_page, %object
	.size	c_ftl_nand_sec_pre_page, 2
c_ftl_nand_sec_pre_page:
	.space	2
	.section	.bss.c_ftl_nand_sec_pre_page_shift,"aw",%nobits
	.align	1
	.set	.LANCHOR56,. + 0
	.type	c_ftl_nand_sec_pre_page_shift, %object
	.size	c_ftl_nand_sec_pre_page_shift, 2
c_ftl_nand_sec_pre_page_shift:
	.space	2
	.section	.bss.c_ftl_nand_sys_blks_per_plane,"aw",%nobits
	.align	2
	.set	.LANCHOR37,. + 0
	.type	c_ftl_nand_sys_blks_per_plane, %object
	.size	c_ftl_nand_sys_blks_per_plane, 4
c_ftl_nand_sys_blks_per_plane:
	.space	4
	.section	.bss.c_ftl_nand_totle_phy_blks,"aw",%nobits
	.align	2
	.set	.LANCHOR43,. + 0
	.type	c_ftl_nand_totle_phy_blks, %object
	.size	c_ftl_nand_totle_phy_blks, 4
c_ftl_nand_totle_phy_blks:
	.space	4
	.section	.bss.c_ftl_nand_type,"aw",%nobits
	.align	1
	.set	.LANCHOR44,. + 0
	.type	c_ftl_nand_type, %object
	.size	c_ftl_nand_type, 2
c_ftl_nand_type:
	.space	2
	.section	.bss.c_ftl_nand_vendor_region_num,"aw",%nobits
	.align	1
	.set	.LANCHOR62,. + 0
	.type	c_ftl_nand_vendor_region_num, %object
	.size	c_ftl_nand_vendor_region_num, 2
c_ftl_nand_vendor_region_num:
	.space	2
	.section	.bss.c_ftl_vendor_part_size,"aw",%nobits
	.align	1
	.set	.LANCHOR50,. + 0
	.type	c_ftl_vendor_part_size, %object
	.size	c_ftl_vendor_part_size, 2
c_ftl_vendor_part_size:
	.space	2
	.section	.bss.c_gc_page_buf_num,"aw",%nobits
	.align	2
	.set	.LANCHOR107,. + 0
	.type	c_gc_page_buf_num, %object
	.size	c_gc_page_buf_num, 4
c_gc_page_buf_num:
	.space	4
	.section	.bss.c_mlc_erase_count_value,"aw",%nobits
	.align	1
	.set	.LANCHOR48,. + 0
	.type	c_mlc_erase_count_value, %object
	.size	c_mlc_erase_count_value, 2
c_mlc_erase_count_value:
	.space	2
	.section	.bss.check_valid_page_count_table,"aw",%nobits
	.align	1
	.type	check_valid_page_count_table, %object
	.size	check_valid_page_count_table, 8192
check_valid_page_count_table:
	.space	8192
	.section	.bss.ftl_gc_temp_power_lost_recovery_flag,"aw",%nobits
	.align	2
	.set	.LANCHOR135,. + 0
	.type	ftl_gc_temp_power_lost_recovery_flag, %object
	.size	ftl_gc_temp_power_lost_recovery_flag, 4
ftl_gc_temp_power_lost_recovery_flag:
	.space	4
	.section	.bss.gBbtInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR74,. + 0
	.type	gBbtInfo, %object
	.size	gBbtInfo, 60
gBbtInfo:
	.space	60
	.section	.bss.gBlockPageAlignSize,"aw",%nobits
	.align	2
	.set	.LANCHOR4,. + 0
	.type	gBlockPageAlignSize, %object
	.size	gBlockPageAlignSize, 4
gBlockPageAlignSize:
	.space	4
	.section	.bss.gBootDdrMode,"aw",%nobits
	.align	2
	.set	.LANCHOR155,. + 0
	.type	gBootDdrMode, %object
	.size	gBootDdrMode, 4
gBootDdrMode:
	.space	4
	.section	.bss.gDieOp,"aw",%nobits
	.align	2
	.set	.LANCHOR23,. + 0
	.type	gDieOp, %object
	.size	gDieOp, 128
gDieOp:
	.space	128
	.section	.bss.gFlashInterfaceMode,"aw",%nobits
	.set	.LANCHOR24,. + 0
	.type	gFlashInterfaceMode, %object
	.size	gFlashInterfaceMode, 1
gFlashInterfaceMode:
	.space	1
	.section	.bss.gFlashOnfiModeEn,"aw",%nobits
	.type	gFlashOnfiModeEn, %object
	.size	gFlashOnfiModeEn, 1
gFlashOnfiModeEn:
	.space	1
	.section	.bss.gFlashPageBuffer0,"aw",%nobits
	.align	2
	.set	.LANCHOR147,. + 0
	.type	gFlashPageBuffer0, %object
	.size	gFlashPageBuffer0, 4
gFlashPageBuffer0:
	.space	4
	.section	.bss.gFlashPageBuffer1,"aw",%nobits
	.align	2
	.set	.LANCHOR153,. + 0
	.type	gFlashPageBuffer1, %object
	.size	gFlashPageBuffer1, 4
gFlashPageBuffer1:
	.space	4
	.section	.bss.gFlashProgCheckBuffer,"aw",%nobits
	.align	2
	.set	.LANCHOR198,. + 0
	.type	gFlashProgCheckBuffer, %object
	.size	gFlashProgCheckBuffer, 4
gFlashProgCheckBuffer:
	.space	4
	.section	.bss.gFlashProgCheckSpareBuffer,"aw",%nobits
	.align	2
	.set	.LANCHOR199,. + 0
	.type	gFlashProgCheckSpareBuffer, %object
	.size	gFlashProgCheckSpareBuffer, 4
gFlashProgCheckSpareBuffer:
	.space	4
	.section	.bss.gFlashSdrModeEn,"aw",%nobits
	.type	gFlashSdrModeEn, %object
	.size	gFlashSdrModeEn, 1
gFlashSdrModeEn:
	.space	1
	.section	.bss.gFlashSlcMode,"aw",%nobits
	.set	.LANCHOR15,. + 0
	.type	gFlashSlcMode, %object
	.size	gFlashSlcMode, 1
gFlashSlcMode:
	.space	1
	.section	.bss.gFlashSpareBuffer,"aw",%nobits
	.align	2
	.set	.LANCHOR197,. + 0
	.type	gFlashSpareBuffer, %object
	.size	gFlashSpareBuffer, 4
gFlashSpareBuffer:
	.space	4
	.section	.bss.gFlashToggleModeEn,"aw",%nobits
	.set	.LANCHOR30,. + 0
	.type	gFlashToggleModeEn, %object
	.size	gFlashToggleModeEn, 1
gFlashToggleModeEn:
	.space	1
	.section	.bss.gL2pMapInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR127,. + 0
	.type	gL2pMapInfo, %object
	.size	gL2pMapInfo, 44
gL2pMapInfo:
	.space	44
	.section	.bss.gMasterInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR35,. + 0
	.type	gMasterInfo, %object
	.size	gMasterInfo, 32
gMasterInfo:
	.space	32
	.section	.bss.gMasterTempBuf,"aw",%nobits
	.align	2
	.set	.LANCHOR156,. + 0
	.type	gMasterTempBuf, %object
	.size	gMasterTempBuf, 4
gMasterTempBuf:
	.space	4
	.section	.bss.gMultiPageProgEn,"aw",%nobits
	.set	.LANCHOR27,. + 0
	.type	gMultiPageProgEn, %object
	.size	gMultiPageProgEn, 1
gMultiPageProgEn:
	.space	1
	.section	.bss.gMultiPageReadEn,"aw",%nobits
	.set	.LANCHOR202,. + 0
	.type	gMultiPageReadEn, %object
	.size	gMultiPageReadEn, 1
gMultiPageReadEn:
	.space	1
	.section	.bss.gNandChipMap,"aw",%nobits
	.align	2
	.set	.LANCHOR0,. + 0
	.type	gNandChipMap, %object
	.size	gNandChipMap, 32
gNandChipMap:
	.space	32
	.section	.bss.gNandFlashEccBits,"aw",%nobits
	.set	.LANCHOR33,. + 0
	.type	gNandFlashEccBits, %object
	.size	gNandFlashEccBits, 1
gNandFlashEccBits:
	.space	1
	.section	.bss.gNandFlashIDBEccBits,"aw",%nobits
	.set	.LANCHOR152,. + 0
	.type	gNandFlashIDBEccBits, %object
	.size	gNandFlashIDBEccBits, 1
gNandFlashIDBEccBits:
	.space	1
	.section	.bss.gNandFlashIdbBlockAddr,"aw",%nobits
	.align	2
	.set	.LANCHOR149,. + 0
	.type	gNandFlashIdbBlockAddr, %object
	.size	gNandFlashIdbBlockAddr, 4
gNandFlashIdbBlockAddr:
	.space	4
	.section	.bss.gNandFlashInfoBlockAddr,"aw",%nobits
	.align	2
	.set	.LANCHOR148,. + 0
	.type	gNandFlashInfoBlockAddr, %object
	.size	gNandFlashInfoBlockAddr, 4
gNandFlashInfoBlockAddr:
	.space	4
	.section	.bss.gNandFlashInfoBlockEcc,"aw",%nobits
	.type	gNandFlashInfoBlockEcc, %object
	.size	gNandFlashInfoBlockEcc, 1
gNandFlashInfoBlockEcc:
	.space	1
	.section	.bss.gNandFlashResEndPageAddr,"aw",%nobits
	.align	2
	.type	gNandFlashResEndPageAddr, %object
	.size	gNandFlashResEndPageAddr, 4
gNandFlashResEndPageAddr:
	.space	4
	.section	.bss.gNandIDBResBlkNum,"aw",%nobits
	.set	.LANCHOR3,. + 0
	.type	gNandIDBResBlkNum, %object
	.size	gNandIDBResBlkNum, 1
gNandIDBResBlkNum:
	.space	1
	.section	.bss.gNandIDBResBlkNumSaveInFlash,"aw",%nobits
	.set	.LANCHOR150,. + 0
	.type	gNandIDBResBlkNumSaveInFlash, %object
	.size	gNandIDBResBlkNumSaveInFlash, 1
gNandIDBResBlkNumSaveInFlash:
	.space	1
	.section	.bss.gNandIDataBuf,"aw",%nobits
	.align	2
	.set	.LANCHOR141,. + 0
	.type	gNandIDataBuf, %object
	.size	gNandIDataBuf, 2048
gNandIDataBuf:
	.space	2048
	.section	.bss.gNandMaxChip,"aw",%nobits
	.set	.LANCHOR121,. + 0
	.type	gNandMaxChip, %object
	.size	gNandMaxChip, 1
gNandMaxChip:
	.space	1
	.section	.bss.gNandMaxDie,"aw",%nobits
	.set	.LANCHOR25,. + 0
	.type	gNandMaxDie, %object
	.size	gNandMaxDie, 1
gNandMaxDie:
	.space	1
	.section	.bss.gNandOptPara,"aw",%nobits
	.set	.LANCHOR7,. + 0
	.type	gNandOptPara, %object
	.size	gNandOptPara, 32
gNandOptPara:
	.space	32
	.section	.bss.gNandPhyInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR14,. + 0
	.type	gNandPhyInfo, %object
	.size	gNandPhyInfo, 28
gNandPhyInfo:
	.space	28
	.section	.bss.gNandRandomizer,"aw",%nobits
	.set	.LANCHOR6,. + 0
	.type	gNandRandomizer, %object
	.size	gNandRandomizer, 1
gNandRandomizer:
	.space	1
	.section	.bss.gNandcDumpWriteEn,"aw",%nobits
	.align	2
	.set	.LANCHOR36,. + 0
	.type	gNandcDumpWriteEn, %object
	.size	gNandcDumpWriteEn, 4
gNandcDumpWriteEn:
	.space	4
	.section	.bss.gNandcEccBits,"aw",%nobits
	.align	2
	.set	.LANCHOR32,. + 0
	.type	gNandcEccBits, %object
	.size	gNandcEccBits, 4
gNandcEccBits:
	.space	4
	.section	.bss.gNandcVer,"aw",%nobits
	.align	2
	.set	.LANCHOR34,. + 0
	.type	gNandcVer, %object
	.size	gNandcVer, 4
gNandcVer:
	.space	4
	.section	.bss.gReadRetryInfo,"aw",%nobits
	.set	.LANCHOR20,. + 0
	.type	gReadRetryInfo, %object
	.size	gReadRetryInfo, 852
gReadRetryInfo:
	.space	852
	.section	.bss.gSysFreeQueue,"aw",%nobits
	.align	1
	.set	.LANCHOR75,. + 0
	.type	gSysFreeQueue, %object
	.size	gSysFreeQueue, 2056
gSysFreeQueue:
	.space	2056
	.section	.bss.gSysInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR210,. + 0
	.type	gSysInfo, %object
	.size	gSysInfo, 16
gSysInfo:
	.space	16
	.section	.bss.gToggleModeClkDiv,"aw",%nobits
	.align	2
	.type	gToggleModeClkDiv, %object
	.size	gToggleModeClkDiv, 4
gToggleModeClkDiv:
	.space	4
	.section	.bss.gTotleBlock,"aw",%nobits
	.align	1
	.set	.LANCHOR122,. + 0
	.type	gTotleBlock, %object
	.size	gTotleBlock, 2
gTotleBlock:
	.space	2
	.section	.bss.gVendorBlkInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR216,. + 0
	.type	gVendorBlkInfo, %object
	.size	gVendorBlkInfo, 44
gVendorBlkInfo:
	.space	44
	.section	.bss.g_GlobalDataVersion,"aw",%nobits
	.align	2
	.set	.LANCHOR160,. + 0
	.type	g_GlobalDataVersion, %object
	.size	g_GlobalDataVersion, 4
g_GlobalDataVersion:
	.space	4
	.section	.bss.g_GlobalSysVersion,"aw",%nobits
	.align	2
	.set	.LANCHOR159,. + 0
	.type	g_GlobalSysVersion, %object
	.size	g_GlobalSysVersion, 4
g_GlobalSysVersion:
	.space	4
	.section	.bss.g_LowFormat,"aw",%nobits
	.align	2
	.set	.LANCHOR247,. + 0
	.type	g_LowFormat, %object
	.size	g_LowFormat, 4
g_LowFormat:
	.space	4
	.section	.bss.g_MaxLbaSector,"aw",%nobits
	.align	2
	.set	.LANCHOR68,. + 0
	.type	g_MaxLbaSector, %object
	.size	g_MaxLbaSector, 4
g_MaxLbaSector:
	.space	4
	.section	.bss.g_MaxLbn,"aw",%nobits
	.align	2
	.set	.LANCHOR223,. + 0
	.type	g_MaxLbn, %object
	.size	g_MaxLbn, 4
g_MaxLbn:
	.space	4
	.section	.bss.g_MaxLpn,"aw",%nobits
	.align	2
	.set	.LANCHOR72,. + 0
	.type	g_MaxLpn, %object
	.size	g_MaxLpn, 4
g_MaxLpn:
	.space	4
	.section	.bss.g_SlcPartLbaEndSector,"aw",%nobits
	.align	2
	.set	.LANCHOR157,. + 0
	.type	g_SlcPartLbaEndSector, %object
	.size	g_SlcPartLbaEndSector, 4
g_SlcPartLbaEndSector:
	.space	4
	.section	.bss.g_VaildLpn,"aw",%nobits
	.align	2
	.set	.LANCHOR100,. + 0
	.type	g_VaildLpn, %object
	.size	g_VaildLpn, 4
g_VaildLpn:
	.space	4
	.section	.bss.g_active_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR91,. + 0
	.type	g_active_superblock, %object
	.size	g_active_superblock, 48
g_active_superblock:
	.space	48
	.section	.bss.g_all_blk_used_slc_mode,"aw",%nobits
	.align	2
	.set	.LANCHOR158,. + 0
	.type	g_all_blk_used_slc_mode, %object
	.size	g_all_blk_used_slc_mode, 4
g_all_blk_used_slc_mode:
	.space	4
	.section	.bss.g_buffer_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR92,. + 0
	.type	g_buffer_superblock, %object
	.size	g_buffer_superblock, 48
g_buffer_superblock:
	.space	48
	.section	.bss.g_cur_erase_blk,"aw",%nobits
	.align	2
	.set	.LANCHOR73,. + 0
	.type	g_cur_erase_blk, %object
	.size	g_cur_erase_blk, 4
g_cur_erase_blk:
	.space	4
	.section	.bss.g_ect_tbl_info_size,"aw",%nobits
	.align	1
	.set	.LANCHOR190,. + 0
	.type	g_ect_tbl_info_size, %object
	.size	g_ect_tbl_info_size, 2
g_ect_tbl_info_size:
	.space	2
	.section	.bss.g_ect_tbl_power_up_flush,"aw",%nobits
	.align	1
	.set	.LANCHOR219,. + 0
	.type	g_ect_tbl_power_up_flush, %object
	.size	g_ect_tbl_power_up_flush, 2
g_ect_tbl_power_up_flush:
	.space	2
	.section	.bss.g_flash_read_only_en,"aw",%nobits
	.align	2
	.set	.LANCHOR76,. + 0
	.type	g_flash_read_only_en, %object
	.size	g_flash_read_only_en, 4
g_flash_read_only_en:
	.space	4
	.section	.bss.g_free_slc_blk_num,"aw",%nobits
	.align	1
	.set	.LANCHOR139,. + 0
	.type	g_free_slc_blk_num, %object
	.size	g_free_slc_blk_num, 2
g_free_slc_blk_num:
	.space	2
	.section	.bss.g_ftl_nand_free_count,"aw",%nobits
	.align	2
	.set	.LANCHOR249,. + 0
	.type	g_ftl_nand_free_count, %object
	.size	g_ftl_nand_free_count, 4
g_ftl_nand_free_count:
	.space	4
	.section	.bss.g_gc_bad_block_gc_index,"aw",%nobits
	.align	1
	.set	.LANCHOR118,. + 0
	.type	g_gc_bad_block_gc_index, %object
	.size	g_gc_bad_block_gc_index, 2
g_gc_bad_block_gc_index:
	.space	2
	.section	.bss.g_gc_bad_block_temp_num,"aw",%nobits
	.align	1
	.set	.LANCHOR116,. + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.space	2
	.section	.bss.g_gc_bad_block_temp_tbl,"aw",%nobits
	.align	1
	.set	.LANCHOR117,. + 0
	.type	g_gc_bad_block_temp_tbl, %object
	.size	g_gc_bad_block_temp_tbl, 34
g_gc_bad_block_temp_tbl:
	.space	34
	.section	.bss.g_gc_blk_index,"aw",%nobits
	.align	1
	.set	.LANCHOR178,. + 0
	.type	g_gc_blk_index, %object
	.size	g_gc_blk_index, 2
g_gc_blk_index:
	.space	2
	.section	.bss.g_gc_blk_num,"aw",%nobits
	.align	1
	.set	.LANCHOR109,. + 0
	.type	g_gc_blk_num, %object
	.size	g_gc_blk_num, 2
g_gc_blk_num:
	.space	2
	.section	.bss.g_gc_cur_blk_max_valid_pages,"aw",%nobits
	.align	1
	.set	.LANCHOR245,. + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.space	2
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",%nobits
	.align	1
	.set	.LANCHOR244,. + 0
	.type	g_gc_cur_blk_valid_pages, %object
	.size	g_gc_cur_blk_valid_pages, 2
g_gc_cur_blk_valid_pages:
	.space	2
	.section	.bss.g_gc_free_blk_threshold,"aw",%nobits
	.align	1
	.set	.LANCHOR176,. + 0
	.type	g_gc_free_blk_threshold, %object
	.size	g_gc_free_blk_threshold, 2
g_gc_free_blk_threshold:
	.space	2
	.section	.bss.g_gc_head_data_block,"aw",%nobits
	.align	2
	.set	.LANCHOR173,. + 0
	.type	g_gc_head_data_block, %object
	.size	g_gc_head_data_block, 4
g_gc_head_data_block:
	.space	4
	.section	.bss.g_gc_head_data_block_count,"aw",%nobits
	.align	2
	.set	.LANCHOR174,. + 0
	.type	g_gc_head_data_block_count, %object
	.size	g_gc_head_data_block_count, 4
g_gc_head_data_block_count:
	.space	4
	.section	.bss.g_gc_merge_free_blk_threshold,"aw",%nobits
	.align	1
	.set	.LANCHOR177,. + 0
	.type	g_gc_merge_free_blk_threshold, %object
	.size	g_gc_merge_free_blk_threshold, 2
g_gc_merge_free_blk_threshold:
	.space	2
	.section	.bss.g_gc_next_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR112,. + 0
	.type	g_gc_next_blk, %object
	.size	g_gc_next_blk, 2
g_gc_next_blk:
	.space	2
	.section	.bss.g_gc_next_blk_1,"aw",%nobits
	.align	1
	.set	.LANCHOR113,. + 0
	.type	g_gc_next_blk_1, %object
	.size	g_gc_next_blk_1, 2
g_gc_next_blk_1:
	.space	2
	.section	.bss.g_gc_next_blk_2,"aw",%nobits
	.align	1
	.set	.LANCHOR114,. + 0
	.type	g_gc_next_blk_2, %object
	.size	g_gc_next_blk_2, 2
g_gc_next_blk_2:
	.space	2
	.section	.bss.g_gc_next_blk_3,"aw",%nobits
	.align	1
	.set	.LANCHOR115,. + 0
	.type	g_gc_next_blk_3, %object
	.size	g_gc_next_blk_3, 2
g_gc_next_blk_3:
	.space	2
	.section	.bss.g_gc_num_req,"aw",%nobits
	.align	2
	.set	.LANCHOR102,. + 0
	.type	g_gc_num_req, %object
	.size	g_gc_num_req, 4
g_gc_num_req:
	.space	4
	.section	.bss.g_gc_page_offset,"aw",%nobits
	.align	1
	.set	.LANCHOR110,. + 0
	.type	g_gc_page_offset, %object
	.size	g_gc_page_offset, 2
g_gc_page_offset:
	.space	2
	.section	.bss.g_gc_refresh_block_temp_num,"aw",%nobits
	.align	1
	.set	.LANCHOR179,. + 0
	.type	g_gc_refresh_block_temp_num, %object
	.size	g_gc_refresh_block_temp_num, 2
g_gc_refresh_block_temp_num:
	.space	2
	.section	.bss.g_gc_refresh_block_temp_tbl,"aw",%nobits
	.align	1
	.type	g_gc_refresh_block_temp_tbl, %object
	.size	g_gc_refresh_block_temp_tbl, 34
g_gc_refresh_block_temp_tbl:
	.space	34
	.section	.bss.g_gc_skip_write_count,"aw",%nobits
	.align	2
	.set	.LANCHOR175,. + 0
	.type	g_gc_skip_write_count, %object
	.size	g_gc_skip_write_count, 4
g_gc_skip_write_count:
	.space	4
	.section	.bss.g_gc_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR205,. + 0
	.type	g_gc_superblock, %object
	.size	g_gc_superblock, 48
g_gc_superblock:
	.space	48
	.section	.bss.g_gc_temp_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR93,. + 0
	.type	g_gc_temp_superblock, %object
	.size	g_gc_temp_superblock, 48
g_gc_temp_superblock:
	.space	48
	.section	.bss.g_in_gc_progress,"aw",%nobits
	.align	2
	.set	.LANCHOR171,. + 0
	.type	g_in_gc_progress, %object
	.size	g_in_gc_progress, 4
g_in_gc_progress:
	.space	4
	.section	.bss.g_in_swl_replace,"aw",%nobits
	.align	2
	.set	.LANCHOR172,. + 0
	.type	g_in_swl_replace, %object
	.size	g_in_swl_replace, 4
g_in_swl_replace:
	.space	4
	.section	.bss.g_inkDie_check_enable,"aw",%nobits
	.align	2
	.set	.LANCHOR28,. + 0
	.type	g_inkDie_check_enable, %object
	.size	g_inkDie_check_enable, 4
g_inkDie_check_enable:
	.space	4
	.section	.bss.g_l2p_last_update_region_id,"aw",%nobits
	.align	1
	.set	.LANCHOR97,. + 0
	.type	g_l2p_last_update_region_id, %object
	.size	g_l2p_last_update_region_id, 2
g_l2p_last_update_region_id:
	.space	2
	.section	.bss.g_maxRegNum,"aw",%nobits
	.set	.LANCHOR12,. + 0
	.type	g_maxRegNum, %object
	.size	g_maxRegNum, 1
g_maxRegNum:
	.space	1
	.section	.bss.g_maxRetryCount,"aw",%nobits
	.set	.LANCHOR151,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.space	1
	.section	.bss.g_max_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR169,. + 0
	.type	g_max_erase_count, %object
	.size	g_max_erase_count, 4
g_max_erase_count:
	.space	4
	.section	.bss.g_min_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR170,. + 0
	.type	g_min_erase_count, %object
	.size	g_min_erase_count, 4
g_min_erase_count:
	.space	4
	.section	.bss.g_nand_ecc_en,"aw",%nobits
	.set	.LANCHOR200,. + 0
	.type	g_nand_ecc_en, %object
	.size	g_nand_ecc_en, 1
g_nand_ecc_en:
	.space	1
	.section	.bss.g_nandc_version_data,"aw",%nobits
	.align	2
	.set	.LANCHOR119,. + 0
	.type	g_nandc_version_data, %object
	.size	g_nandc_version_data, 4
g_nandc_version_data:
	.space	4
	.section	.bss.g_num_data_superblocks,"aw",%nobits
	.align	1
	.set	.LANCHOR85,. + 0
	.type	g_num_data_superblocks, %object
	.size	g_num_data_superblocks, 2
g_num_data_superblocks:
	.space	2
	.section	.bss.g_num_free_superblocks,"aw",%nobits
	.align	1
	.set	.LANCHOR88,. + 0
	.type	g_num_free_superblocks, %object
	.size	g_num_free_superblocks, 2
g_num_free_superblocks:
	.space	2
	.section	.bss.g_page_map_check_enable,"aw",%nobits
	.align	1
	.set	.LANCHOR69,. + 0
	.type	g_page_map_check_enable, %object
	.size	g_page_map_check_enable, 2
g_page_map_check_enable:
	.space	2
	.section	.bss.g_power_lost_ecc_error_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR237,. + 0
	.type	g_power_lost_ecc_error_blk, %object
	.size	g_power_lost_ecc_error_blk, 2
g_power_lost_ecc_error_blk:
	.space	2
	.section	.bss.g_power_lost_recovery_flag,"aw",%nobits
	.align	1
	.set	.LANCHOR238,. + 0
	.type	g_power_lost_recovery_flag, %object
	.size	g_power_lost_recovery_flag, 2
g_power_lost_recovery_flag:
	.space	2
	.section	.bss.g_recovery_page_min_ver,"aw",%nobits
	.align	2
	.set	.LANCHOR136,. + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.space	4
	.section	.bss.g_recovery_page_num,"aw",%nobits
	.align	2
	.set	.LANCHOR239,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.space	4
	.section	.bss.g_recovery_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR240,. + 0
	.type	g_recovery_ppa_tbl, %object
	.size	g_recovery_ppa_tbl, 128
g_recovery_ppa_tbl:
	.space	128
	.section	.bss.g_req_cache,"aw",%nobits
	.align	2
	.set	.LANCHOR132,. + 0
	.type	g_req_cache, %object
	.size	g_req_cache, 4
g_req_cache:
	.space	4
	.section	.bss.g_retryMode,"aw",%nobits
	.set	.LANCHOR9,. + 0
	.type	g_retryMode, %object
	.size	g_retryMode, 1
g_retryMode:
	.space	1
	.section	.bss.g_slc2KBNand,"aw",%nobits
	.set	.LANCHOR2,. + 0
	.type	g_slc2KBNand, %object
	.size	g_slc2KBNand, 1
g_slc2KBNand:
	.space	1
	.section	.bss.g_sys_ext_data,"aw",%nobits
	.align	2
	.set	.LANCHOR138,. + 0
	.type	g_sys_ext_data, %object
	.size	g_sys_ext_data, 512
g_sys_ext_data:
	.space	512
	.section	.bss.g_sys_save_data,"aw",%nobits
	.align	2
	.set	.LANCHOR80,. + 0
	.type	g_sys_save_data, %object
	.size	g_sys_save_data, 48
g_sys_save_data:
	.space	48
	.section	.bss.g_tmp_data_superblock_id,"aw",%nobits
	.align	1
	.set	.LANCHOR133,. + 0
	.type	g_tmp_data_superblock_id, %object
	.size	g_tmp_data_superblock_id, 2
g_tmp_data_superblock_id:
	.space	2
	.section	.bss.g_totle_avg_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR206,. + 0
	.type	g_totle_avg_erase_count, %object
	.size	g_totle_avg_erase_count, 4
g_totle_avg_erase_count:
	.space	4
	.section	.bss.g_totle_cache_write_count,"aw",%nobits
	.align	2
	.set	.LANCHOR164,. + 0
	.type	g_totle_cache_write_count, %object
	.size	g_totle_cache_write_count, 4
g_totle_cache_write_count:
	.space	4
	.section	.bss.g_totle_discard_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR163,. + 0
	.type	g_totle_discard_page_count, %object
	.size	g_totle_discard_page_count, 4
g_totle_discard_page_count:
	.space	4
	.section	.bss.g_totle_gc_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR161,. + 0
	.type	g_totle_gc_page_count, %object
	.size	g_totle_gc_page_count, 4
g_totle_gc_page_count:
	.space	4
	.section	.bss.g_totle_l2p_write_count,"aw",%nobits
	.align	2
	.set	.LANCHOR165,. + 0
	.type	g_totle_l2p_write_count, %object
	.size	g_totle_l2p_write_count, 4
g_totle_l2p_write_count:
	.space	4
	.section	.bss.g_totle_map_block,"aw",%nobits
	.align	1
	.set	.LANCHOR128,. + 0
	.type	g_totle_map_block, %object
	.size	g_totle_map_block, 2
g_totle_map_block:
	.space	2
	.section	.bss.g_totle_mlc_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR167,. + 0
	.type	g_totle_mlc_erase_count, %object
	.size	g_totle_mlc_erase_count, 4
g_totle_mlc_erase_count:
	.space	4
	.section	.bss.g_totle_read_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR166,. + 0
	.type	g_totle_read_page_count, %object
	.size	g_totle_read_page_count, 4
g_totle_read_page_count:
	.space	4
	.section	.bss.g_totle_read_sector,"aw",%nobits
	.align	2
	.set	.LANCHOR218,. + 0
	.type	g_totle_read_sector, %object
	.size	g_totle_read_sector, 4
g_totle_read_sector:
	.space	4
	.section	.bss.g_totle_slc_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR168,. + 0
	.type	g_totle_slc_erase_count, %object
	.size	g_totle_slc_erase_count, 4
g_totle_slc_erase_count:
	.space	4
	.section	.bss.g_totle_swl_count,"aw",%nobits
	.align	2
	.set	.LANCHOR134,. + 0
	.type	g_totle_swl_count, %object
	.size	g_totle_swl_count, 4
g_totle_swl_count:
	.space	4
	.section	.bss.g_totle_sys_slc_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR79,. + 0
	.type	g_totle_sys_slc_erase_count, %object
	.size	g_totle_sys_slc_erase_count, 4
g_totle_sys_slc_erase_count:
	.space	4
	.section	.bss.g_totle_vendor_block,"aw",%nobits
	.align	1
	.set	.LANCHOR70,. + 0
	.type	g_totle_vendor_block, %object
	.size	g_totle_vendor_block, 2
g_totle_vendor_block:
	.space	2
	.section	.bss.g_totle_write_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR162,. + 0
	.type	g_totle_write_page_count, %object
	.size	g_totle_write_page_count, 4
g_totle_write_page_count:
	.space	4
	.section	.bss.g_totle_write_sector,"aw",%nobits
	.align	2
	.set	.LANCHOR217,. + 0
	.type	g_totle_write_sector, %object
	.size	g_totle_write_sector, 4
g_totle_write_sector:
	.space	4
	.section	.bss.gc_discard_updated,"aw",%nobits
	.align	2
	.set	.LANCHOR233,. + 0
	.type	gc_discard_updated, %object
	.size	gc_discard_updated, 4
gc_discard_updated:
	.space	4
	.section	.bss.gc_ink_free_return_value,"aw",%nobits
	.align	1
	.set	.LANCHOR243,. + 0
	.type	gc_ink_free_return_value, %object
	.size	gc_ink_free_return_value, 2
gc_ink_free_return_value:
	.space	2
	.section	.bss.gpFlashSaveInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR146,. + 0
	.type	gpFlashSaveInfo, %object
	.size	gpFlashSaveInfo, 4
gpFlashSaveInfo:
	.space	4
	.section	.bss.gpNandParaInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR18,. + 0
	.type	gpNandParaInfo, %object
	.size	gpNandParaInfo, 4
gpNandParaInfo:
	.space	4
	.section	.bss.gpNandc,"aw",%nobits
	.align	2
	.set	.LANCHOR19,. + 0
	.type	gpNandc, %object
	.size	gpNandc, 4
gpNandc:
	.space	4
	.section	.bss.gpNandc1,"aw",%nobits
	.align	2
	.type	gpNandc1, %object
	.size	gpNandc1, 4
gpNandc1:
	.space	4
	.section	.bss.gpReadRetrial,"aw",%nobits
	.align	2
	.set	.LANCHOR145,. + 0
	.type	gpReadRetrial, %object
	.size	gpReadRetrial, 4
gpReadRetrial:
	.space	4
	.section	.bss.gp_ect_tbl_info,"aw",%nobits
	.align	2
	.set	.LANCHOR191,. + 0
	.type	gp_ect_tbl_info, %object
	.size	gp_ect_tbl_info, 4
gp_ect_tbl_info:
	.space	4
	.section	.bss.gp_flash_check_buf,"aw",%nobits
	.align	2
	.type	gp_flash_check_buf, %object
	.size	gp_flash_check_buf, 262144
gp_flash_check_buf:
	.space	262144
	.section	.bss.gp_gc_page_buf_info,"aw",%nobits
	.align	2
	.set	.LANCHOR103,. + 0
	.type	gp_gc_page_buf_info, %object
	.size	gp_gc_page_buf_info, 4
gp_gc_page_buf_info:
	.space	4
	.section	.bss.gp_last_act_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR231,. + 0
	.type	gp_last_act_superblock, %object
	.size	gp_last_act_superblock, 4
gp_last_act_superblock:
	.space	4
	.section	.bss.idb_buf,"aw",%nobits
	.align	2
	.type	idb_buf, %object
	.size	idb_buf, 262144
idb_buf:
	.space	262144
	.section	.bss.idb_flash_slc_mode,"aw",%nobits
	.align	2
	.set	.LANCHOR29,. + 0
	.type	idb_flash_slc_mode, %object
	.size	idb_flash_slc_mode, 4
idb_flash_slc_mode:
	.space	4
	.section	.bss.idb_need_write_back,"aw",%nobits
	.align	2
	.set	.LANCHOR154,. + 0
	.type	idb_need_write_back, %object
	.size	idb_need_write_back, 4
idb_need_write_back:
	.space	4
	.section	.bss.mlcPageToSlcPageTbl,"aw",%nobits
	.align	2
	.set	.LANCHOR120,. + 0
	.type	mlcPageToSlcPageTbl, %object
	.size	mlcPageToSlcPageTbl, 1024
mlcPageToSlcPageTbl:
	.space	1024
	.section	.bss.p_blk_mode_table,"aw",%nobits
	.align	2
	.set	.LANCHOR1,. + 0
	.type	p_blk_mode_table, %object
	.size	p_blk_mode_table, 4
p_blk_mode_table:
	.space	4
	.section	.bss.p_data_block_list_head,"aw",%nobits
	.align	2
	.set	.LANCHOR82,. + 0
	.type	p_data_block_list_head, %object
	.size	p_data_block_list_head, 4
p_data_block_list_head:
	.space	4
	.section	.bss.p_data_block_list_table,"aw",%nobits
	.align	2
	.set	.LANCHOR81,. + 0
	.type	p_data_block_list_table, %object
	.size	p_data_block_list_table, 4
p_data_block_list_table:
	.space	4
	.section	.bss.p_data_block_list_tail,"aw",%nobits
	.align	2
	.set	.LANCHOR84,. + 0
	.type	p_data_block_list_tail, %object
	.size	p_data_block_list_tail, 4
p_data_block_list_tail:
	.space	4
	.section	.bss.p_erase_count_table,"aw",%nobits
	.align	2
	.set	.LANCHOR78,. + 0
	.type	p_erase_count_table, %object
	.size	p_erase_count_table, 4
p_erase_count_table:
	.space	4
	.section	.bss.p_free_data_block_list_head,"aw",%nobits
	.align	2
	.set	.LANCHOR87,. + 0
	.type	p_free_data_block_list_head, %object
	.size	p_free_data_block_list_head, 4
p_free_data_block_list_head:
	.space	4
	.section	.bss.p_gc_blk_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR108,. + 0
	.type	p_gc_blk_tbl, %object
	.size	p_gc_blk_tbl, 4
p_gc_blk_tbl:
	.space	4
	.section	.bss.p_gc_data_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR104,. + 0
	.type	p_gc_data_buf, %object
	.size	p_gc_data_buf, 4
p_gc_data_buf:
	.space	4
	.section	.bss.p_gc_page_info,"aw",%nobits
	.align	2
	.set	.LANCHOR111,. + 0
	.type	p_gc_page_info, %object
	.size	p_gc_page_info, 4
p_gc_page_info:
	.space	4
	.section	.bss.p_gc_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR105,. + 0
	.type	p_gc_spare_buf, %object
	.size	p_gc_spare_buf, 4
p_gc_spare_buf:
	.space	4
	.section	.bss.p_io_data_buf_0,"aw",%nobits
	.align	2
	.set	.LANCHOR186,. + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 4
p_io_data_buf_0:
	.space	4
	.section	.bss.p_io_data_buf_1,"aw",%nobits
	.align	2
	.set	.LANCHOR187,. + 0
	.type	p_io_data_buf_1, %object
	.size	p_io_data_buf_1, 4
p_io_data_buf_1:
	.space	4
	.section	.bss.p_io_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR189,. + 0
	.type	p_io_spare_buf, %object
	.size	p_io_spare_buf, 4
p_io_spare_buf:
	.space	4
	.section	.bss.p_l2p_map_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR126,. + 0
	.type	p_l2p_map_buf, %object
	.size	p_l2p_map_buf, 4
p_l2p_map_buf:
	.space	4
	.section	.bss.p_l2p_ram_map,"aw",%nobits
	.align	2
	.set	.LANCHOR96,. + 0
	.type	p_l2p_ram_map, %object
	.size	p_l2p_ram_map, 4
p_l2p_ram_map:
	.space	4
	.section	.bss.p_map_block_table,"aw",%nobits
	.align	2
	.set	.LANCHOR129,. + 0
	.type	p_map_block_table, %object
	.size	p_map_block_table, 4
p_map_block_table:
	.space	4
	.section	.bss.p_map_block_valid_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR125,. + 0
	.type	p_map_block_valid_page_count, %object
	.size	p_map_block_valid_page_count, 4
p_map_block_valid_page_count:
	.space	4
	.section	.bss.p_map_block_ver_table,"aw",%nobits
	.align	2
	.set	.LANCHOR130,. + 0
	.type	p_map_block_ver_table, %object
	.size	p_map_block_ver_table, 4
p_map_block_ver_table:
	.space	4
	.section	.bss.p_map_region_ppn_check_table,"aw",%nobits
	.align	2
	.set	.LANCHOR195,. + 0
	.type	p_map_region_ppn_check_table, %object
	.size	p_map_region_ppn_check_table, 4
p_map_region_ppn_check_table:
	.space	4
	.section	.bss.p_map_region_ppn_table,"aw",%nobits
	.align	2
	.set	.LANCHOR131,. + 0
	.type	p_map_region_ppn_table, %object
	.size	p_map_region_ppn_table, 4
p_map_region_ppn_table:
	.space	4
	.section	.bss.p_plane_order_table,"aw",%nobits
	.set	.LANCHOR47,. + 0
	.type	p_plane_order_table, %object
	.size	p_plane_order_table, 32
p_plane_order_table:
	.space	32
	.section	.bss.p_swl_mul_table,"aw",%nobits
	.align	2
	.set	.LANCHOR137,. + 0
	.type	p_swl_mul_table, %object
	.size	p_swl_mul_table, 4
p_swl_mul_table:
	.space	4
	.section	.bss.p_sys_data_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR183,. + 0
	.type	p_sys_data_buf, %object
	.size	p_sys_data_buf, 4
p_sys_data_buf:
	.space	4
	.section	.bss.p_sys_data_buf_1,"aw",%nobits
	.align	2
	.set	.LANCHOR184,. + 0
	.type	p_sys_data_buf_1, %object
	.size	p_sys_data_buf_1, 4
p_sys_data_buf_1:
	.space	4
	.section	.bss.p_sys_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR188,. + 0
	.type	p_sys_spare_buf, %object
	.size	p_sys_spare_buf, 4
p_sys_spare_buf:
	.space	4
	.section	.bss.p_valid_page_count_check_table,"aw",%nobits
	.align	2
	.type	p_valid_page_count_check_table, %object
	.size	p_valid_page_count_check_table, 4
p_valid_page_count_check_table:
	.space	4
	.section	.bss.p_valid_page_count_table,"aw",%nobits
	.align	2
	.set	.LANCHOR83,. + 0
	.type	p_valid_page_count_table, %object
	.size	p_valid_page_count_table, 4
p_valid_page_count_table:
	.space	4
	.section	.bss.p_vendor_block_table,"aw",%nobits
	.align	2
	.set	.LANCHOR71,. + 0
	.type	p_vendor_block_table, %object
	.size	p_vendor_block_table, 4
p_vendor_block_table:
	.space	4
	.section	.bss.p_vendor_block_valid_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR192,. + 0
	.type	p_vendor_block_valid_page_count, %object
	.size	p_vendor_block_valid_page_count, 4
p_vendor_block_valid_page_count:
	.space	4
	.section	.bss.p_vendor_block_ver_table,"aw",%nobits
	.align	2
	.set	.LANCHOR193,. + 0
	.type	p_vendor_block_ver_table, %object
	.size	p_vendor_block_ver_table, 4
p_vendor_block_ver_table:
	.space	4
	.section	.bss.p_vendor_data_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR185,. + 0
	.type	p_vendor_data_buf, %object
	.size	p_vendor_data_buf, 4
p_vendor_data_buf:
	.space	4
	.section	.bss.p_vendor_region_ppn_table,"aw",%nobits
	.align	2
	.set	.LANCHOR194,. + 0
	.type	p_vendor_region_ppn_table, %object
	.size	p_vendor_region_ppn_table, 4
p_vendor_region_ppn_table:
	.space	4
	.section	.bss.read_retry_cur_offset,"aw",%nobits
	.set	.LANCHOR21,. + 0
	.type	read_retry_cur_offset, %object
	.size	read_retry_cur_offset, 4
read_retry_cur_offset:
	.space	4
	.section	.bss.req_erase,"aw",%nobits
	.align	2
	.set	.LANCHOR77,. + 0
	.type	req_erase, %object
	.size	req_erase, 4
req_erase:
	.space	4
	.section	.bss.req_gc,"aw",%nobits
	.align	2
	.set	.LANCHOR106,. + 0
	.type	req_gc, %object
	.size	req_gc, 4
req_gc:
	.space	4
	.section	.bss.req_gc_dst,"aw",%nobits
	.align	2
	.set	.LANCHOR181,. + 0
	.type	req_gc_dst, %object
	.size	req_gc_dst, 4
req_gc_dst:
	.space	4
	.section	.bss.req_prgm,"aw",%nobits
	.align	2
	.set	.LANCHOR182,. + 0
	.type	req_prgm, %object
	.size	req_prgm, 4
req_prgm:
	.space	4
	.section	.bss.req_read,"aw",%nobits
	.align	2
	.set	.LANCHOR180,. + 0
	.type	req_read, %object
	.size	req_read, 4
req_read:
	.space	4
	.section	.bss.req_sys,"aw",%nobits
	.align	2
	.set	.LANCHOR203,. + 0
	.type	req_sys, %object
	.size	req_sys, 36
req_sys:
	.space	36
	.section	.bss.slcPageToMlcPageTbl,"aw",%nobits
	.align	2
	.set	.LANCHOR16,. + 0
	.type	slcPageToMlcPageTbl, %object
	.size	slcPageToMlcPageTbl, 512
slcPageToMlcPageTbl:
	.space	512
	.section	.data.FtlMallocOffset,"aw",%progbits
	.align	2
	.type	FtlMallocOffset, %object
	.size	FtlMallocOffset, 4
FtlMallocOffset:
	.word	64
	.section	.data.LastWritenPbaAddr,"aw",%progbits
	.align	2
	.type	LastWritenPbaAddr, %object
	.size	LastWritenPbaAddr, 4
LastWritenPbaAddr:
	.word	-1
	.section	.data.NandFlashParaTbl,"aw",%progbits
	.align	1
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	479
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1064
	.short	479
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	287
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	287
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	287
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	287
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1024
	.short	287
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
	.space	4
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
	.short	512
	.byte	2
	.byte	2
	.short	1024
	.short	479
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
	.space	4
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
	.short	512
	.byte	2
	.byte	2
	.short	1024
	.short	479
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
	.space	4
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
	.short	128
	.byte	2
	.byte	2
	.short	4096
	.short	279
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1024
	.short	287
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	287
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	287
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
	.space	4
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
	.short	128
	.byte	1
	.byte	2
	.short	2048
	.short	287
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
	.space	4
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
	.short	512
	.byte	2
	.byte	2
	.short	700
	.short	479
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	479
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
	.space	4
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
	.short	64
	.byte	1
	.byte	2
	.short	2048
	.short	279
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
	.space	4
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
	.short	64
	.byte	1
	.byte	2
	.short	1024
	.short	279
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
	.space	4
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
	.short	512
	.byte	2
	.byte	1
	.short	1024
	.short	479
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
	.space	4
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
	.short	512
	.byte	2
	.byte	1
	.short	2184
	.short	1479
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
	.space	4
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
	.short	512
	.byte	2
	.byte	1
	.short	1048
	.short	1479
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
	.space	4
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
	.short	512
	.byte	2
	.byte	1
	.short	1044
	.short	479
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
	.space	4
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
	.short	512
	.byte	2
	.byte	1
	.short	2184
	.short	1479
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
	.space	4
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
	.short	512
	.byte	2
	.byte	1
	.short	2184
	.short	1479
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
	.space	4
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
	.short	512
	.byte	2
	.byte	1
	.short	2184
	.short	1479
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
	.space	4
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
	.short	512
	.byte	2
	.byte	1
	.short	2184
	.short	1479
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
	.space	4
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
	.short	512
	.byte	2
	.byte	2
	.short	1024
	.short	479
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1024
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1046
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2090
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1066
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	530
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1024
	.short	281
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1060
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1056
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1060
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1056
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2092
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	1
	.short	1024
	.short	273
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
	.space	4
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
	.short	388
	.byte	2
	.byte	2
	.short	1362
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	479
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	479
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	279
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	279
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	279
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	279
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2048
	.short	279
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
	.space	4
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
	.short	512
	.byte	2
	.byte	1
	.short	1024
	.short	455
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
	.space	4
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
	.short	256
	.byte	2
	.byte	1
	.short	1060
	.short	1473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	1
	.short	2092
	.short	1473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	1
	.short	2092
	.short	1505
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
	.space	4
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
	.short	128
	.byte	2
	.byte	1
	.short	2056
	.short	1473
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
	.space	4
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
	.short	128
	.byte	2
	.byte	2
	.short	2058
	.short	1489
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2062
	.short	1489
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1066
	.short	1497
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1066
	.short	1497
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
	.space	4
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
	.short	128
	.byte	2
	.byte	2
	.short	2050
	.short	401
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1058
	.short	1497
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
	.space	4
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
	.short	256
	.byte	2
	.byte	1
	.short	1060
	.short	1473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1074
	.short	1497
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2106
	.short	1497
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
	.space	4
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
	.short	256
	.byte	2
	.byte	1
	.short	1056
	.short	1497
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1058
	.short	1497
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
	.space	4
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
	.short	256
	.byte	2
	.byte	1
	.short	1060
	.short	1473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2082
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1066
	.short	1497
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
	.space	4
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
	.short	256
	.byte	2
	.byte	1
	.short	1060
	.short	1473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2090
	.short	1241
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
	.space	4
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
	.short	256
	.byte	2
	.byte	1
	.short	2092
	.short	1473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2106
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1074
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2138
	.short	1497
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	2062
	.short	473
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
	.space	4
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
	.short	256
	.byte	2
	.byte	2
	.short	1058
	.short	1497
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
	.space	4
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
	.short	128
	.byte	2
	.byte	2
	.short	2048
	.short	473
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
	.space	4
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
	.short	128
	.byte	2
	.byte	2
	.short	2048
	.short	505
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
	.space	4
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
	.short	128
	.byte	2
	.byte	2
	.short	2076
	.short	409
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
	.space	4
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
	.short	128
	.byte	2
	.byte	2
	.short	2076
	.short	441
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
	.space	4
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
	.short	128
	.byte	2
	.byte	2
	.short	1038
	.short	281
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
	.space	4
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
	.short	128
	.byte	2
	.byte	2
	.short	2076
	.short	1169
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
	.space	4
	.section	.data.NandOptPara,"aw",%progbits
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
	.space	14
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
	.space	14
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
	.space	14
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
	.space	14
	.section	.data.SamsungRefValue,"aw",%progbits
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
	.section	.data.Toshiba15RefValue,"aw",%progbits
	.set	.LANCHOR10,. + 0
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
	.section	.data.ToshibaA19RefValue,"aw",%progbits
	.set	.LANCHOR8,. + 0
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
	.section	.data.ToshibaRefValue,"aw",%progbits
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
	.section	.data.ftl_gc_temp_block_bops_scan_page_addr,"aw",%progbits
	.align	1
	.set	.LANCHOR241,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.short	-1
	.section	.data.gFtlInitStatus,"aw",%progbits
	.align	2
	.set	.LANCHOR232,. + 0
	.type	gFtlInitStatus, %object
	.size	gFtlInitStatus, 4
gFtlInitStatus:
	.word	-1
	.section	.data.gNandParaInfo,"aw",%progbits
	.align	1
	.set	.LANCHOR31,. + 0
	.type	gNandParaInfo, %object
	.size	gNandParaInfo, 32
gNandParaInfo:
	.byte	0
	.byte	0
	.space	5
	.byte	0
	.byte	1
	.byte	8
	.short	128
	.byte	2
	.byte	1
	.short	2048
	.short	0
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
	.space	4
	.section	.data.gSlcNandParaInfo,"aw",%progbits
	.align	1
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
	.short	64
	.byte	1
	.byte	1
	.short	1024
	.short	256
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
	.space	4
	.section	.data.power_up_flag,"aw",%progbits
	.align	2
	.type	power_up_flag, %object
	.size	power_up_flag, 4
power_up_flag:
	.word	1
	.section	.data.random_seed,"aw",%progbits
	.align	1
	.set	.LANCHOR5,. + 0
	.type	random_seed, %object
	.size	random_seed, 256
random_seed:
	.short	22378
	.short	1512
	.short	25245
	.short	17827
	.short	25756
	.short	19440
	.short	9026
	.short	10030
	.short	29528
	.short	20467
	.short	29676
	.short	24432
	.short	31328
	.short	6872
	.short	13426
	.short	13842
	.short	8783
	.short	1108
	.short	782
	.short	28837
	.short	30729
	.short	9505
	.short	18676
	.short	23085
	.short	18730
	.short	1085
	.short	32609
	.short	14697
	.short	20858
	.short	15170
	.short	30365
	.short	1607
	.short	32298
	.short	4995
	.short	18905
	.short	1976
	.short	9592
	.short	20204
	.short	17443
	.short	13615
	.short	23330
	.short	29369
	.short	13947
	.short	9398
	.short	32398
	.short	8984
	.short	27600
	.short	21785
	.short	6019
	.short	6311
	.short	31598
	.short	30210
	.short	19327
	.short	13896
	.short	11347
	.short	27545
	.short	3107
	.short	26575
	.short	32270
	.short	19852
	.short	20601
	.short	8349
	.short	9290
	.short	29819
	.short	13579
	.short	3661
	.short	28676
	.short	27331
	.short	32574
	.short	8693
	.short	31253
	.short	9081
	.short	5399
	.short	6842
	.short	20087
	.short	5537
	.short	1274
	.short	11617
	.short	9530
	.short	4866
	.short	8035
	.short	23219
	.short	1178
	.short	23272
	.short	7383
	.short	18944
	.short	12488
	.short	12871
	.short	29340
	.short	20532
	.short	11022
	.short	22514
	.short	228
	.short	22363
	.short	24978
	.short	14584
	.short	12138
	.short	3092
	.short	17916
	.short	16863
	.short	14554
	.short	31457
	.short	29474
	.short	25311
	.short	24121
	.short	3684
	.short	28037
	.short	22865
	.short	22839
	.short	25217
	.short	13217
	.short	27186
	.short	14938
	.short	11180
	.short	29754
	.short	24180
	.short	15150
	.short	32455
	.short	20434
	.short	23848
	.short	29983
	.short	16120
	.short	14769
	.short	20041
	.short	29803
	.short	28406
	.short	17598
	.short	28087
	.section	.data.refValueDefault,"aw",%progbits
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
	.section	.rodata.FlashDdrTunningRead.str1.1,"aMS",%progbits,1
.LC9:
	.ascii	"sdr read ok %x ecc=%d\012\000"
.LC10:
	.ascii	"sync para %d\012\000"
.LC11:
	.ascii	"TOG mode Read error %x %x\012\000"
	.section	.rodata.FlashEraseSLc2KBlocks.str1.1,"aMS",%progbits,1
.LC1:
	.ascii	"FlashEraseBlocks pageAddr error %x\012\000"
	.section	.rodata.FlashInit.str1.1,"aMS",%progbits,1
.LC23:
	.ascii	"No.%d FLASH ID:%x %x %x %x %x %x\012\000"
.LC24:
	.ascii	"FlashLoadPhyInfo fail %x!!\012\000"
	.section	.rodata.FlashProgSlc2KPages.str1.1,"aMS",%progbits,1
.LC29:
	.ascii	"prog error: = %x\012\000"
.LC30:
	.ascii	"prog read error: = %x\012\000"
.LC31:
	.ascii	"prog read s error: = %x %x %x\012\000"
.LC32:
	.ascii	"prog read d error: = %x %x %x\012\000"
	.section	.rodata.FlashReadFacBbtData.str1.1,"aMS",%progbits,1
.LC55:
	.ascii	"BBT:\000"
	.section	.rodata.FlashReadIdbDataRaw.str1.1,"aMS",%progbits,1
.LC14:
	.ascii	"ECC:%d\012\000"
	.section	.rodata.FlashReadPage.str1.1,"aMS",%progbits,1
.LC12:
	.ascii	"read retry status %x %x %x\012\000"
	.section	.rodata.FlashReadPages.str1.1,"aMS",%progbits,1
.LC28:
	.ascii	"ReadRetry pageadd=%x ecc=%x err=%x\012\000"
	.section	.rodata.FlashReadSlc2KPages.str1.1,"aMS",%progbits,1
.LC25:
	.ascii	"Read pageadd=%x  ecc=%x err=%x\012\000"
.LC26:
	.ascii	"data:\000"
.LC27:
	.ascii	"spare:\000"
	.section	.rodata.FtlBbmMapBadBlock.str1.1,"aMS",%progbits,1
.LC2:
	.ascii	"phyBlk = 0x%x die = %d block_in_die = 0x%x 0x%8x\012"
	.ascii	"\000"
	.section	.rodata.FtlBbmTblFlush.str1.1,"aMS",%progbits,1
.LC33:
	.ascii	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\012\000"
.LC34:
	.ascii	"FtlBbmTblFlush error:%x\012\000"
.LC35:
	.ascii	"FtlBbmTblFlush error = %x error count = %d\012\000"
	.section	.rodata.FtlCheckVpc.str1.1,"aMS",%progbits,1
.LC60:
	.ascii	"FtlCheckVpc2 %x = %x  %x\012\000"
.LC61:
	.ascii	"free blk vpc error %x = %x  %x\012\000"
	.section	.rodata.FtlDumpBlockInfo.str1.1,"aMS",%progbits,1
.LC45:
	.ascii	"...%s enter...\012\000"
.LC46:
	.ascii	"superBlkID = %x vpc=%x\012\000"
.LC47:
	.ascii	"flashmode = %x pagenum = %x %x\012\000"
.LC48:
	.ascii	"id = %x,%x addr= %x,spare= %x %x %x %x data=%x %x\012"
	.ascii	"\000"
	.section	.rodata.FtlDumpSysBlock.str1.1,"aMS",%progbits,1
.LC78:
	.ascii	"id = %x,%x addr= %x,spare= %x %x %x %x data = %x\012"
	.ascii	"\000"
.LC79:
	.ascii	":\000"
	.section	.rodata.FtlFreeSysBlkQueueOut.str1.1,"aMS",%progbits,1
.LC3:
	.ascii	"FtlFreeSysBlkQueueOut free count = %d\012\000"
.LC4:
	.ascii	"FtlFreeSysBlkQueueOut = %x, free count = %d, error\012"
	.ascii	"\000"
	.section	.rodata.FtlGcFreeTempBlock.str1.1,"aMS",%progbits,1
.LC70:
	.ascii	"GC des block %x done\012\000"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",%progbits,1
.LC68:
	.ascii	"FtlGcScanTempBlk Error ID %x %x!!!!!!! \012\000"
.LC69:
	.ascii	"FtlGcScanTempBlkError ID %x %x!!!!!!!\012\000"
	.section	.rodata.FtlInit.str1.1,"aMS",%progbits,1
.LC71:
	.ascii	"FTL version: 5.0.56 20190508\000"
.LC72:
	.ascii	"...%s: no bad block mapping table, format device\012"
	.ascii	"\000"
.LC73:
	.ascii	"...%s FtlSysBlkInit error ,format device!\012\000"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",%progbits,1
.LC43:
	.ascii	"no ect\000"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",%progbits,1
.LC40:
	.ascii	"FtlMapWritePage error = %x\012\000"
.LC41:
	.ascii	"FtlMapWritePage error = %x error count = %d\012\000"
	.section	.rodata.FtlProgPages.str1.1,"aMS",%progbits,1
.LC59:
	.ascii	"Ftlwrite decrement_vpc_count %x = %d\012\000"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",%progbits,1
.LC65:
	.ascii	"RSB refresh addr %x\012\000"
.LC66:
	.ascii	"spuer block %x vpn is 0\012 \000"
.LC67:
	.ascii	"g_recovery_ppa %x ver %x\012 \000"
	.section	.rodata.FtlScanAllBlock.str1.1,"aMS",%progbits,1
.LC49:
	.ascii	"blk = %x vpc=%x mode = %x\012\000"
.LC50:
	.ascii	"mlc id = %x,%x addr= %x,spare= %x %x %x %x data=%x "
	.ascii	"%x\012\000"
.LC51:
	.ascii	"slc id = %x,%x addr= %x,spare= %x %x %x %x data=%x "
	.ascii	"%x\012\000"
	.section	.rodata.FtlVendorPartRead.str1.1,"aMS",%progbits,1
.LC42:
	.ascii	"FtlVendorPartRead refresh = %x phyAddr = %x\012\000"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",%progbits,1
.LC38:
	.ascii	"FtlVpcTblFlush error = %x error count = %d\012\000"
	.section	.rodata.FtlWrite.str1.1,"aMS",%progbits,1
.LC77:
	.ascii	"FtlWrite: lpa error:%x %x\012\000"
	.section	.rodata.Ftl_load_ext_data.str1.1,"aMS",%progbits,1
.LC44:
	.ascii	"slc mode\000"
	.section	.rodata.Ftlscanalldata.str1.1,"aMS",%progbits,1
.LC62:
	.ascii	"Ftlscanalldata = %x\012\000"
.LC63:
	.ascii	"scan lpa = %x ppa= %x\012\000"
.LC64:
	.ascii	"lba = %x,addr= %x,spare= %x %x %x %x data=%x %x\012"
	.ascii	"\000"
	.section	.rodata.HynixGetReadRetryDefault.str1.1,"aMS",%progbits,1
.LC21:
	.ascii	"otp error! %d\000"
.LC22:
	.ascii	"rr\000"
	.section	.rodata.INSERT_DATA_LIST.str1.1,"aMS",%progbits,1
.LC5:
	.ascii	"\012!!!!! error @ func:%s - line:%d\012\000"
.LC6:
	.ascii	"!!!!! FTL sys Error !!!!!\000"
.LC7:
	.ascii	"%s\012\000"
	.section	.rodata.MicronReadRetrial.str1.1,"aMS",%progbits,1
.LC13:
	.ascii	"micron RR %d row=%x,count %d,status=%d\012\000"
	.section	.rodata.__func__.10524,"a",%progbits
	.set	.LANCHOR248,. + 0
	.type	__func__.10524, %object
	.size	__func__.10524, 8
__func__.10524:
	.ascii	"FtlInit\000"
	.section	.rodata.__func__.10585,"a",%progbits
	.set	.LANCHOR230,. + 0
	.type	__func__.10585, %object
	.size	__func__.10585, 13
__func__.10585:
	.ascii	"FtlProgPages\000"
	.section	.rodata.__func__.10611,"a",%progbits
	.set	.LANCHOR250,. + 0
	.type	__func__.10611, %object
	.size	__func__.10611, 9
__func__.10611:
	.ascii	"FtlWrite\000"
	.section	.rodata.__func__.10694,"a",%progbits
	.set	.LANCHOR124,. + 0
	.type	__func__.10694, %object
	.size	__func__.10694, 14
__func__.10694:
	.ascii	"FtlBbt2Bitmap\000"
	.section	.rodata.__func__.10740,"a",%progbits
	.set	.LANCHOR212,. + 0
	.type	__func__.10740, %object
	.size	__func__.10740, 11
__func__.10740:
	.ascii	"FtlLoadBbt\000"
	.section	.rodata.__func__.10833,"a",%progbits
	.set	.LANCHOR89,. + 0
	.type	__func__.10833, %object
	.size	__func__.10833, 17
__func__.10833:
	.ascii	"INSERT_FREE_LIST\000"
	.section	.rodata.__func__.10837,"a",%progbits
	.set	.LANCHOR86,. + 0
	.type	__func__.10837, %object
	.size	__func__.10837, 17
__func__.10837:
	.ascii	"INSERT_DATA_LIST\000"
	.section	.rodata.__func__.10874,"a",%progbits
	.set	.LANCHOR90,. + 0
	.type	__func__.10874, %object
	.size	__func__.10874, 17
__func__.10874:
	.ascii	"List_remove_node\000"
	.section	.rodata.__func__.10904,"a",%progbits
	.set	.LANCHOR94,. + 0
	.type	__func__.10904, %object
	.size	__func__.10904, 22
__func__.10904:
	.ascii	"List_update_data_list\000"
	.section	.rodata.__func__.10911,"a",%progbits
	.set	.LANCHOR229,. + 0
	.type	__func__.10911, %object
	.size	__func__.10911, 20
__func__.10911:
	.ascii	"ftl_load_l2p_region\000"
	.section	.rodata.__func__.10942,"a",%progbits
	.set	.LANCHOR95,. + 0
	.type	__func__.10942, %object
	.size	__func__.10942, 26
__func__.10942:
	.ascii	"ftl_map_blk_alloc_new_blk\000"
	.section	.rodata.__func__.10952,"a",%progbits
	.set	.LANCHOR213,. + 0
	.type	__func__.10952, %object
	.size	__func__.10952, 15
__func__.10952:
	.ascii	"ftl_map_blk_gc\000"
	.section	.rodata.__func__.10965,"a",%progbits
	.set	.LANCHOR214,. + 0
	.type	__func__.10965, %object
	.size	__func__.10965, 31
__func__.10965:
	.ascii	"Ftl_write_map_blk_to_last_page\000"
	.section	.rodata.__func__.10978,"a",%progbits
	.set	.LANCHOR215,. + 0
	.type	__func__.10978, %object
	.size	__func__.10978, 16
__func__.10978:
	.ascii	"FtlMapWritePage\000"
	.section	.rodata.__func__.10998,"a",%progbits
	.set	.LANCHOR98,. + 0
	.type	__func__.10998, %object
	.size	__func__.10998, 22
__func__.10998:
	.ascii	"select_l2p_ram_region\000"
	.section	.rodata.__func__.11014,"a",%progbits
	.set	.LANCHOR228,. + 0
	.type	__func__.11014, %object
	.size	__func__.11014, 9
__func__.11014:
	.ascii	"log2phys\000"
	.section	.rodata.__func__.11076,"a",%progbits
	.set	.LANCHOR211,. + 0
	.type	__func__.11076, %object
	.size	__func__.11076, 15
__func__.11076:
	.ascii	"FtlVpcTblFlush\000"
	.section	.rodata.__func__.11095,"a",%progbits
	.set	.LANCHOR221,. + 0
	.type	__func__.11095, %object
	.size	__func__.11095, 14
__func__.11095:
	.ascii	"FtlScanSysBlk\000"
	.section	.rodata.__func__.11150,"a",%progbits
	.set	.LANCHOR222,. + 0
	.type	__func__.11150, %object
	.size	__func__.11150, 15
__func__.11150:
	.ascii	"FtlLoadSysInfo\000"
	.section	.rodata.__func__.11161,"a",%progbits
	.set	.LANCHOR234,. + 0
	.type	__func__.11161, %object
	.size	__func__.11161, 12
__func__.11161:
	.ascii	"FtlCheckVpc\000"
	.section	.rodata.__func__.11193,"a",%progbits
	.set	.LANCHOR225,. + 0
	.type	__func__.11193, %object
	.size	__func__.11193, 17
__func__.11193:
	.ascii	"FtlDumpBlockInfo\000"
	.section	.rodata.__func__.11212,"a",%progbits
	.set	.LANCHOR226,. + 0
	.type	__func__.11212, %object
	.size	__func__.11212, 16
__func__.11212:
	.ascii	"FtlScanAllBlock\000"
	.section	.rodata.__func__.11317,"a",%progbits
	.set	.LANCHOR235,. + 0
	.type	__func__.11317, %object
	.size	__func__.11317, 16
__func__.11317:
	.ascii	"FtlReUsePrevPpa\000"
	.section	.rodata.__func__.11350,"a",%progbits
	.set	.LANCHOR236,. + 0
	.type	__func__.11350, %object
	.size	__func__.11350, 22
__func__.11350:
	.ascii	"FtlRecoverySuperblock\000"
	.section	.rodata.__func__.11404,"a",%progbits
	.set	.LANCHOR101,. + 0
	.type	__func__.11404, %object
	.size	__func__.11404, 16
__func__.11404:
	.ascii	"make_superblock\000"
	.section	.rodata.__func__.11424,"a",%progbits
	.set	.LANCHOR140,. + 0
	.type	__func__.11424, %object
	.size	__func__.11424, 18
__func__.11424:
	.ascii	"SupperBlkListInit\000"
	.section	.rodata.__func__.11468,"a",%progbits
	.set	.LANCHOR227,. + 0
	.type	__func__.11468, %object
	.size	__func__.11468, 17
__func__.11468:
	.ascii	"ftl_scan_all_ppa\000"
	.section	.rodata.__func__.11513,"a",%progbits
	.set	.LANCHOR204,. + 0
	.type	__func__.11513, %object
	.size	__func__.11513, 25
__func__.11513:
	.ascii	"allocate_data_superblock\000"
	.section	.rodata.__func__.11527,"a",%progbits
	.set	.LANCHOR220,. + 0
	.type	__func__.11527, %object
	.size	__func__.11527, 29
__func__.11527:
	.ascii	"allocate_new_data_superblock\000"
	.section	.rodata.__func__.11533,"a",%progbits
	.set	.LANCHOR209,. + 0
	.type	__func__.11533, %object
	.size	__func__.11533, 19
__func__.11533:
	.ascii	"get_new_active_ppa\000"
	.section	.rodata.__func__.11544,"a",%progbits
	.set	.LANCHOR207,. + 0
	.type	__func__.11544, %object
	.size	__func__.11544, 16
__func__.11544:
	.ascii	"update_vpc_list\000"
	.section	.rodata.__func__.11549,"a",%progbits
	.set	.LANCHOR208,. + 0
	.type	__func__.11549, %object
	.size	__func__.11549, 20
__func__.11549:
	.ascii	"decrement_vpc_count\000"
	.section	.rodata.__func__.11617,"a",%progbits
	.set	.LANCHOR242,. + 0
	.type	__func__.11617, %object
	.size	__func__.11617, 19
__func__.11617:
	.ascii	"FtlGcFreeTempBlock\000"
	.section	.rodata.__func__.11717,"a",%progbits
	.set	.LANCHOR246,. + 0
	.type	__func__.11717, %object
	.size	__func__.11717, 23
__func__.11717:
	.ascii	"rk_ftl_garbage_collect\000"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",%progbits,1
.LC36:
	.ascii	"decrement_vpc_count %x = %d\012\000"
.LC37:
	.ascii	"decrement_vpc_count %x = %d in free list\012\000"
	.section	.rodata.dump_map_info.str1.1,"aMS",%progbits,1
.LC80:
	.ascii	"phyBlk = %x,addr= %x,spare= %x %x %x %x data=%x %x\012"
	.ascii	"\000"
.LC81:
	.ascii	"Mblk:\000"
.LC82:
	.ascii	"L2P:\000"
.LC83:
	.ascii	"L2PC:\000"
	.section	.rodata.ftl_fix_nand_power_lost_error.str1.1,"aMS",%progbits,1
.LC75:
	.ascii	"fix power lost blk = %x vpc=%x\012\000"
.LC76:
	.ascii	"erase power lost blk = %x vpc=%x\012\000"
	.section	.rodata.ftl_map_blk_alloc_new_blk.str1.1,"aMS",%progbits,1
.LC8:
	.ascii	"FtlFreeSysBlkQueueOut = %x, free count = %d\012\000"
	.section	.rodata.ftl_map_blk_gc.str1.1,"aMS",%progbits,1
.LC39:
	.ascii	"page map lost: %x %x\012\000"
	.section	.rodata.ftl_scan_all_ppa.str1.1,"aMS",%progbits,1
.LC52:
	.ascii	"ftl_scan_all_ppa blk %x page %x\012\000"
.LC53:
	.ascii	"addr= %x, status= %d,spare= %x %x %x %x data=%x %x\012"
	.ascii	"\000"
.LC54:
	.ascii	"%s finished\012\000"
	.section	.rodata.idb_write_data.str1.1,"aMS",%progbits,1
.LC15:
	.ascii	"1 write_idblock fix data %x %x %x\012\000"
.LC16:
	.ascii	"write_idblock fail! %x %x %x %x\012\000"
.LC17:
	.ascii	"write_idblock fail! %x\012\000"
	.section	.rodata.log2phys.str1.1,"aMS",%progbits,1
.LC56:
	.ascii	"region_id = %x phyAddr = %x\012\000"
.LC57:
	.ascii	"map_ppn:\000"
.LC58:
	.ascii	"load_l2p_region refresh = %x phyAddr = %x\012\000"
	.section	.rodata.rk_ftl_init.str1.1,"aMS",%progbits,1
.LC74:
	.ascii	"FtlInit %x\012\000"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",%progbits,1
.LC18:
	.ascii	"%s 0x%x:\000"
.LC19:
	.ascii	"%x \000"
.LC20:
	.ascii	"\000"
	.hidden	free
