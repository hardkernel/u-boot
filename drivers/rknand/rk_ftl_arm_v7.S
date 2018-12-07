/*
 * Copyright (c) 2016-2018, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2019-01-07
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
	.file	"rk_ftl_arm_v7.c"
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
	ldr	r3, .L2
	lsrs	r1, r0, #5
	and	r0, r0, #31
	ldr	r2, [r3]
	movs	r3, #1
	lsl	r0, r3, r0
	ldr	r3, [r2, r1, lsl #2]
	orrs	r3, r3, r0
	str	r3, [r2, r1, lsl #2]
	bx	lr
.L3:
	.align	2
.L2:
	.word	.LANCHOR0
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
	ldr	r3, .L12
	push	{r4, r5, lr}
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L7
	ldrb	r4, [r0, #1]	@ zero_extendqisi2
	ldrb	r3, [r1, #1]	@ zero_extendqisi2
	cmp	r4, r3
	beq	.L11
	movs	r3, #0
.L7:
	cmp	r3, r2
	bne	.L9
.L11:
	movs	r0, #0
	pop	{r4, r5, pc}
.L9:
	ldrb	r5, [r0, r3]	@ zero_extendqisi2
	ldrb	r4, [r1, r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r5, r4
	beq	.L7
	mov	r0, r3
	pop	{r4, r5, pc}
.L13:
	.align	2
.L12:
	.word	.LANCHOR1
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
	ldr	r3, .L17
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L17+4
	ldr	r3, [r3]
	muls	r3, r2, r3
	cmp	r3, r1
	bls	.L16
	adds	r0, r0, #0
	it	ne
	movne	r0, #1
	bx	lr
.L16:
	movs	r0, #1
	bx	lr
.L18:
	.align	2
.L17:
	.word	.LANCHOR2
	.word	.LANCHOR3
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
	ldr	r3, .L27
	and	r2, r1, #127
	push	{r4, lr}
	ldrh	r4, [r3, r2, lsl #1]
	ldr	r3, .L27+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L19
	bl	FlashRsvdBlkChk
	cbz	r0, .L19
	orr	r4, r4, #-1073741824
.L19:
	mov	r0, r4
	pop	{r4, pc}
.L28:
	.align	2
.L27:
	.word	.LANCHOR4
	.word	.LANCHOR5
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
	ldr	r3, .L37
	mov	r5, r0
	ldrh	r4, [r3, r2, lsl #1]
	ldr	r3, .L37+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L30
	bl	FlashRsvdBlkChk
	cbz	r0, .L30
	orr	r4, r4, #-1073741824
.L30:
	ldr	r3, .L37+8
	ldr	r3, [r3, r5, lsl #3]
	str	r4, [r3, #336]
	pop	{r3, r4, r5, pc}
.L38:
	.align	2
.L37:
	.word	.LANCHOR4
	.word	.LANCHOR5
	.word	.LANCHOR6
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
	ldr	r3, .L44
	bls	.L40
	mov	r2, #512
.L43:
	str	r2, [r3]
	bx	lr
.L40:
	cmp	r0, #128
	bhi	.L42
	str	r0, [r3]
	bx	lr
.L42:
	mov	r2, #256
	b	.L43
.L45:
	.align	2
.L44:
	.word	.LANCHOR3
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
	ldr	r4, .L47
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
.L48:
	.align	2
.L47:
	.word	.LANCHOR6
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
	ldr	r2, .L53
	push	{r4, r5, r6}
	uxtb	r6, r1
	ldr	r4, .L53+4
	lsrs	r5, r1, #8
	ldr	r3, [r2, r0, lsl #3]
	add	r2, r2, r0, lsl #3
	ldrb	r4, [r4, #16]	@ zero_extendqisi2
	ldrb	r2, [r2, #4]	@ zero_extendqisi2
	cmp	r4, #1
	lsr	r4, r1, #16
	lsl	r2, r2, #8
	add	r3, r3, r2
	bne	.L50
	movs	r2, #6
	str	r2, [r3, #2056]
	movs	r2, #0
	str	r2, [r3, #2052]
	str	r2, [r3, #2052]
	str	r6, [r3, #2052]
	str	r5, [r3, #2052]
	str	r4, [r3, #2052]
.L52:
	movs	r2, #224
	str	r2, [r3, #2056]
	pop	{r4, r5, r6}
	b	FlashSetRandomizer
.L50:
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
	b	.L52
.L54:
	.align	2
.L53:
	.word	.LANCHOR6
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
	ldr	r4, .L56
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
.L57:
	.align	2
.L56:
	.word	.LANCHOR6
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
	ldr	r4, .L63
	ldr	r3, [r4, r0, lsl #3]
	add	r4, r4, r0, lsl #3
	ldrb	r0, [r4, #4]	@ zero_extendqisi2
	lsls	r0, r0, #8
	cbz	r2, .L59
	adds	r2, r3, r0
	movs	r4, #96
	str	r4, [r2, #2056]
	uxtb	r4, r1
	str	r4, [r2, #2052]
	lsrs	r4, r1, #8
	str	r4, [r2, #2052]
	lsrs	r4, r1, #16
	str	r4, [r2, #2052]
	ldr	r2, .L63+4
	ldr	r2, [r2]
	add	r1, r1, r2
.L59:
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
.L64:
	.align	2
.L63:
	.word	.LANCHOR6
	.word	.LANCHOR3
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
	ldr	r4, .L66
	ldr	r3, [r4, r0, lsl #3]
	add	r4, r4, r0, lsl #3
	ldrb	r5, [r4, #4]	@ zero_extendqisi2
	ldr	r4, .L66+4
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
.L67:
	.align	2
.L66:
	.word	.LANCHOR6
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
	ldr	r3, .L69
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r3, r2, r3, lsl #8
	movs	r2, #16
	str	r2, [r3, #2056]
	bx	lr
.L70:
	.align	2
.L69:
	.word	.LANCHOR6
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
	ldr	r3, .L72
	ldr	r1, .L72+4
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r1, [r1, #10]	@ zero_extendqisi2
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r3, r2, r3, lsl #8
	str	r1, [r3, #2056]
	bx	lr
.L73:
	.align	2
.L72:
	.word	.LANCHOR6
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
	ldr	r3, .L75
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
.L76:
	.align	2
.L75:
	.word	.LANCHOR6
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
	ldr	r3, .L80
	add	r1, r1, r0
	push	{r4, lr}
.L78:
	cmp	r0, r1
	bne	.L79
	mov	r0, r3
	pop	{r4, pc}
.L79:
	lsrs	r2, r3, #2
	ldrb	r4, [r0], #1	@ zero_extendqisi2
	add	r2, r2, r3, lsl #5
	add	r2, r2, r4
	eors	r3, r3, r2
	b	.L78
.L81:
	.align	2
.L80:
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
	ldr	r10, .L92+12
	mov	r5, r0
	mov	r6, r1
	movs	r4, #0
	ldr	r8, .L92+16
.L85:
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L89
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L89:
	movs	r3, #85
	movs	r0, #200
	str	r3, [r5, #8]
	ldrsb	r3, [r4, r8]
	str	r3, [r5, #4]
	bl	udelay
	ldr	r3, .L92
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L86
	adds	r3, r4, r7
	add	r3, r3, r8
.L91:
	ldrsb	r3, [r3, #5]
.L90:
	str	r3, [r5]
	adds	r4, r4, #1
	b	.L85
.L86:
	cmp	r3, #35
	bne	.L88
	ldr	r3, .L92+4
	adds	r2, r4, r7
	add	r3, r3, r2
	b	.L91
.L88:
	ldr	r3, .L92+8
	ldrsb	r3, [r3, r6]
	b	.L90
.L93:
	.align	2
.L92:
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
	ldr	r7, .L97
	movs	r4, #0
	mov	r10, #161
	ldr	r8, .L97+4
	add	r1, r7, r1, lsl #2
	adds	r5, r1, #3
.L95:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L96
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L96:
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
	b	.L95
.L98:
	.align	2
.L97:
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
	ldr	r3, .L104
	mov	r8, r1
	mov	r7, r2
	mov	r5, r0
	ldrh	r4, [r3, #14]
	ldrh	r3, [r3, #12]
	smulbb	r4, r4, r3
	ldr	r3, .L104+4
	ldrh	fp, [r3]
	uxth	r4, r4
	ldr	r3, .L104+8
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
	bne	.L101
	ldr	r2, .L104+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L101
	ldr	r2, .L104+16
	ldrh	r3, [r2, r3, lsl #1]
.L101:
	ldr	r2, .L104+20
	ldr	r2, [r2, r10, lsl #2]
	mla	r1, fp, r1, r2
	add	r1, r1, r3
	ldrb	r3, [sp, #40]	@ zero_extendqisi2
	str	r1, [r7]
	str	r10, [r6]
	cmp	r3, #1
	bls	.L103
	ldr	r0, [r5, #4]
	ldr	r3, [r5, #40]
	add	r0, r0, #1024
	subs	r3, r0, r3
	rsbs	r0, r3, #0
	adcs	r0, r0, r3
.L102:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L103:
	movs	r0, #0
	b	.L102
.L105:
	.align	2
.L104:
	.word	.LANCHOR14
	.word	.LANCHOR3
	.word	.LANCHOR1
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
	ldr	r3, .L118
	push	{r4, r5, r6, lr}
	ldr	r5, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r4, [r3, #4]	@ zero_extendqisi2
	ldr	r3, .L118+4
	ldr	r3, [r3]
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	cmp	r3, #2
	lsl	r3, r4, #8
	add	r4, r4, #8
	bne	.L107
	ldr	r0, .L118+8
	cbnz	r2, .L108
	ldrb	r2, [r0, #13]	@ zero_extendqisi2
.L117:
	add	r3, r3, r5
	str	r2, [r3, #2056]
	ldrb	r0, [r0, #15]	@ zero_extendqisi2
	cbz	r0, .L112
	add	r6, r5, r4, lsl #8
	movs	r2, #0
.L111:
	cmp	r2, r0
	bcc	.L113
.L112:
	lsls	r4, r4, #8
	movs	r0, #80
	bl	udelay
	ldr	r0, [r5, r4]
	uxtb	r0, r0
	pop	{r4, r5, r6, pc}
.L108:
	ldrb	r2, [r0, #14]	@ zero_extendqisi2
	b	.L117
.L113:
	lsls	r3, r2, #3
	adds	r2, r2, #1
	lsr	r3, r1, r3
	uxtb	r3, r3
	str	r3, [r6, #4]
	b	.L111
.L107:
	add	r3, r3, r5
	movs	r2, #112
	str	r2, [r3, #2056]
	b	.L112
.L119:
	.align	2
.L118:
	.word	.LANCHOR6
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
.L124:
	mov	r2, r6
	mov	r1, r5
	mov	r0, r4
	bl	FlashReadStatusEN
	cmp	r0, #255
	mov	r3, r0
	beq	.L124
	lsls	r3, r3, #25
	bpl	.L124
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
	ldr	r2, .L129
	add	r3, r2, r0, lsl #3
	ldr	r0, [r2, r0, lsl #3]
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	adds	r3, r3, #8
	add	r0, r0, r3, lsl #8
	bx	lr
.L130:
	.align	2
.L129:
	.word	.LANCHOR6
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
	ldr	r3, .L132
	ldr	r2, [r3]
	lsls	r3, r0, #8
	orr	r0, r3, r0, lsl #16
	orr	r0, r0, #1
	str	r0, [r2, #304]
	bx	lr
.L133:
	.align	2
.L132:
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
	ldr	r3, .L135
	orr	r0, r0, #16640
	ldr	r3, [r3]
	str	r0, [r3, #344]
	bx	lr
.L136:
	.align	2
.L135:
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
	ldr	r3, .L140
	ldr	r2, [r3]
	ldr	r3, [r2]
	cbnz	r0, .L138
	bfi	r3, r0, #13, #1
.L139:
	str	r3, [r2]
	bx	lr
.L138:
	orr	r3, r3, #253952
	b	.L139
.L141:
	.align	2
.L140:
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
	ldr	r3, .L149
	ands	r1, r0, #6
	ldr	r2, [r3]
	ldr	r3, [r2]
	beq	.L143
	lsls	r1, r0, #29
	movw	r1, #16641
	str	r1, [r2, #344]
	orr	r3, r3, #24576
	ldr	r1, .L149+4
	bfc	r3, #15, #1
	orr	r3, r3, #196608
	it	mi
	orrmi	r3, r3, #32768
	str	r1, [r2, #304]
	movs	r1, #38
	str	r1, [r2, #308]
	movs	r1, #39
	str	r1, [r2, #308]
.L145:
	str	r3, [r2]
	movs	r0, #0
	bx	lr
.L143:
	bfi	r3, r1, #13, #1
	b	.L145
.L150:
	.align	2
.L149:
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
	ldr	r3, .L152
	movs	r2, #1
	ldr	r1, [r3, r0, lsl #3]
	add	r0, r3, r0, lsl #3
	ldrb	r0, [r0, #4]	@ zero_extendqisi2
	ldr	r3, [r1]
	lsls	r2, r2, r0
	bfi	r3, r2, #0, #8
	str	r3, [r1]
	bx	lr
.L153:
	.align	2
.L152:
	.word	.LANCHOR6
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
	ldr	r3, .L155
	ldr	r2, [r3, r0, lsl #3]
	ldr	r3, [r2]
	bfc	r3, #0, #8
	bfc	r3, #17, #1
	str	r3, [r2]
	bx	lr
.L156:
	.align	2
.L155:
	.word	.LANCHOR6
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
	ldr	r3, .L166
	mov	r5, r0
	mov	r7, r1
	mov	r10, r2
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cmp	r3, #6
	bne	.L158
	movs	r4, #20
	add	r4, r4, r0, lsl #6
	add	r3, r4, r6, lsl #2
.L164:
	ldr	r4, .L166+4
.L165:
	add	r4, r4, r3
.L159:
	ldr	r3, .L166+8
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
.L162:
	cmp	r3, r7
	bne	.L163
	movs	r3, #22
	add	r8, r8, fp
	str	r3, [r8, #2056]
	mov	r0, r5
	bl	NandcFlashDeCs
	ldr	r3, .L166+12
	strb	r6, [r3, r5]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L158:
	cmp	r3, #7
	bne	.L160
	movs	r4, #28
	movs	r3, #160
	smlabb	r3, r3, r0, r4
	movs	r4, #10
	smlabb	r3, r4, r6, r3
	b	.L164
.L160:
	cmp	r3, #8
	bne	.L161
	add	r4, r6, r6, lsl #2
	ldr	r3, .L166+16
	b	.L165
.L161:
	adds	r4, r6, #2
	add	r3, r4, r0, lsl #3
	ldr	r4, .L166+4
	add	r4, r4, r3, lsl #3
	adds	r4, r4, #4
	b	.L159
.L163:
	ldrb	r2, [r3, #1]!	@ zero_extendqisi2
	movs	r0, #200
	str	r2, [r10, #2052]
	str	r3, [sp, #4]
	bl	udelay
	ldrsb	r2, [r4, #1]!
	ldr	r3, [sp, #4]
	str	r2, [r10, #2048]
	b	.L162
.L167:
	.align	2
.L166:
	.word	.LANCHOR18
	.word	.LANCHOR20
	.word	.LANCHOR6
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
	ldr	r3, .L174
	push	{r4, r5, r6, lr}
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #7
	bhi	.L168
	ldr	r5, .L174+4
	movs	r4, #0
	adds	r6, r5, #4
.L171:
	ldr	r3, .L174+8
	uxtb	r0, r4
	ldrb	r3, [r3, r4, lsl #3]	@ zero_extendqisi2
	cmp	r3, #173
	bne	.L170
	movs	r3, #0
	mov	r2, r6
	ldrb	r1, [r5, #1]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L170:
	adds	r4, r4, #1
	cmp	r4, #4
	bne	.L171
.L168:
	pop	{r4, r5, r6, pc}
.L175:
	.align	2
.L174:
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
	ldr	r2, .L183
	lsls	r3, r0, #4
	push	{r4, r5, r6, lr}
	mov	r6, r0
	adds	r4, r2, r3
	ldr	r1, [r4, #8]
	cbz	r1, .L178
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	mov	r0, r5
	bl	NandcFlashCs
	ldr	r3, .L183+4
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
	cbz	r2, .L178
	str	r1, [r2]
	str	r3, [r4, #12]
.L178:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L184:
	.align	2
.L183:
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
	ldr	r3, .L191
	push	{r0, r1, r2, r4, r5, lr}
	ldr	r4, .L191+4
	ldr	r5, [r3, r0, lsl #3]
.L188:
	ldr	r3, [r5]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #22
	bmi	.L189
	movs	r0, #10
	bl	udelay
	subs	r4, r4, #1
	bne	.L188
	mov	r0, #-1
.L186:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, pc}
.L189:
	movs	r0, #0
	b	.L186
.L192:
	.align	2
.L191:
	.word	.LANCHOR6
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
	ldr	r3, .L198
	ldr	r4, .L198+4
	ldr	r5, [r3, r0, lsl #3]
	movs	r0, #150
	bl	udelay
.L195:
	ldr	r3, [r5]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #22
	bmi	.L196
	movs	r0, #10
	bl	udelay
	subs	r4, r4, #1
	bne	.L195
	mov	r0, #-1
.L193:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, pc}
.L196:
	movs	r0, #0
	b	.L193
.L199:
	.align	2
.L198:
	.word	.LANCHOR6
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
	ldr	r3, .L201
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
.L202:
	.align	2
.L201:
	.word	.LANCHOR6
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
	ldr	r3, .L205
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L203
	bl	NandcFlashCs
	ldr	r3, .L205+4
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
.L203:
	pop	{r3, r4, r5, pc}
.L206:
	.align	2
.L205:
	.word	.LANCHOR15
	.word	.LANCHOR6
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
	ldr	r3, .L209
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L207
	bl	NandcFlashCs
	ldr	r3, .L209+4
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
.L207:
	pop	{r3, r4, r5, pc}
.L210:
	.align	2
.L209:
	.word	.LANCHOR15
	.word	.LANCHOR6
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
	ldr	r3, .L240
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
.L222:
	ldr	r3, .L240+4
	ldrb	r4, [r5, r3]	@ zero_extendqisi2
	cmp	r4, #152
	beq	.L213
	cmp	r4, #69
	beq	.L213
	cmp	r4, #173
	beq	.L213
	cmp	r4, #44
	bne	.L214
.L213:
	ldr	r3, .L240+8
	cmp	r0, #1
	ldr	r1, [r5, r3]
	add	r3, r3, r5
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	bne	.L215
	ldr	r6, [sp]
	cbz	r6, .L214
	lsls	r3, r3, #8
	cmp	r4, #173
	add	fp, r1, r3
	str	r7, [fp, #2056]
	bne	.L216
	str	r0, [fp, #2052]
.L239:
	str	r2, [fp, #2048]
	b	.L220
.L216:
	cmp	r4, #44
	ittet	eq
	moveq	r4, #5
	streq	r0, [fp, #2052]
	strne	ip, [fp, #2052]
	streq	r4, [fp, #2048]
	it	ne
	strne	r0, [fp, #2048]
.L220:
	add	r3, r3, r1
	str	r2, [r3, #2048]
	str	r2, [r3, #2048]
	str	r2, [r3, #2048]
.L214:
	adds	r5, r5, #8
	cmp	r5, #32
	bne	.L222
	movs	r0, #0
	bl	NandcWaitFlashReady
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L215:
	ldr	r6, [sp, #4]
	cmp	r6, #0
	beq	.L214
	lsls	r3, r3, #8
	cmp	r4, #173
	add	fp, r1, r3
	str	r7, [fp, #2056]
	bne	.L219
	str	lr, [fp, #2052]
	str	r10, [fp, #2048]
	b	.L220
.L219:
	cmp	r4, #44
	bne	.L221
	str	lr, [fp, #2052]
	str	r8, [fp, #2048]
	b	.L220
.L221:
	str	ip, [fp, #2052]
	b	.L239
.L241:
	.align	2
.L240:
	.word	.LANCHOR24
	.word	.LANCHOR22
	.word	.LANCHOR6
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
	ldr	r3, .L248
	add	r4, r4, r4, lsl #2
	ldr	r6, .L248+4
	movs	r2, #0
	ldr	r7, .L248+8
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r3, .L248+12
	ldrb	r0, [r3]	@ zero_extendqisi2
.L243:
	cmp	r2, r1
	bcc	.L246
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, lr}
	b	NandcWaitFlashReady
.L246:
	adds	r3, r2, r4
	cmp	r0, #67
	ite	eq
	addeq	r3, r3, r7
	addne	r3, r3, r6
	ldrsb	r3, [r3, #5]
	adds	r2, r2, #1
	str	r3, [r5]
	b	.L243
.L249:
	.align	2
.L248:
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
	ldr	r0, .L251
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
.L252:
	.align	2
.L251:
	.word	.LANCHOR6
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
	ldr	r8, .L263+12
	sub	sp, sp, #20
	mov	r5, r0
	movs	r6, #0
	ldr	r10, .L263+16
.L254:
	cmp	r6, r7
	bne	.L259
	movs	r0, #0
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L259:
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
	bhi	.L255
	mov	r3, #-1
	str	r3, [r5]
.L256:
	adds	r6, r6, #1
	adds	r5, r5, #36
	b	.L254
.L255:
	ldrb	r4, [r10, r3]	@ zero_extendqisi2
	lsls	r3, r3, #4
	ldr	r2, .L263
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
	ldr	r3, .L263+4
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
	bne	.L258
	ldr	r1, [sp, #8]
	ldr	r0, .L263+8
	bl	printf
.L258:
	mov	r0, r4
	bl	NandcFlashDeCs
	b	.L256
.L264:
	.align	2
.L263:
	.word	.LANCHOR23
	.word	.LANCHOR3
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
	ldr	r3, .L296
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r0
	sub	sp, sp, #24
	mov	fp, r1
	mov	r7, r2
	ldrb	r4, [r3]	@ zero_extendqisi2
	cbnz	r4, .L266
	ldr	r10, .L296+8
.L267:
	cmp	r4, r7
	bcc	.L276
	ldr	r5, .L296+4
	movs	r4, #0
	ldr	r6, .L296+8
.L277:
	ldr	r3, .L296+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L279
	ldr	r3, .L296+16
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L280
.L281:
	movs	r0, #0
	b	.L265
.L266:
	mov	r1, r2
	bl	FlashEraseSLc2KBlocks
.L265:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L276:
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
	ldr	r3, .L296+12
	mov	r6, r0
	ldr	r0, [sp, #20]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L269
	mov	r3, #-1
	str	r3, [r8, r5]
.L270:
	adds	r4, r4, #1
	b	.L267
.L269:
	ldr	r3, .L296+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	add	r3, r10, r0, lsl #4
	it	eq
	moveq	r6, #0
	ldr	r3, [r3, #8]
	cbz	r3, .L272
	uxtb	r0, r0
	bl	FlashWaitCmdDone
.L272:
	ldr	r1, [sp, #20]
	ldr	r0, [sp, #12]
	lsls	r2, r1, #4
	add	r3, r10, r2
	str	r0, [r3, #8]
	movs	r0, #0
	str	r0, [r3, #12]
	ldr	r0, [sp, #16]
	str	r0, [r3, #4]
	cbz	r6, .L273
	adds	r5, r5, #36
	add	r5, r5, r8
	str	r5, [r3, #12]
.L273:
	ldr	r3, .L296+24
	ldrb	r5, [r3, r1]	@ zero_extendqisi2
	mov	r0, r5
	strb	r5, [r10, r2]
	bl	NandcFlashCs
	cmp	fp, #1
	mov	r0, r5
	bne	.L274
	ldr	r3, .L296+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L274
	bl	flash_enter_slc_mode
.L275:
	ldr	r3, .L296+28
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
	b	.L270
.L274:
	bl	flash_exit_slc_mode
	b	.L275
.L279:
	uxtb	r0, r4
	bl	FlashWaitCmdDone
	cmp	fp, #1
	bne	.L278
	ldrb	r3, [r5]	@ zero_extendqisi2
	cbz	r3, .L278
	lsls	r3, r4, #4
	ldrb	r0, [r6, r3]	@ zero_extendqisi2
	bl	flash_exit_slc_mode
.L278:
	adds	r4, r4, #1
	b	.L277
.L280:
	ldr	r3, .L296+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #69
	bne	.L281
	movs	r3, #0
	movs	r2, #36
	mov	r1, r3
.L282:
	cmp	r3, r7
	beq	.L281
	mul	r0, r2, r3
	adds	r3, r3, #1
	str	r1, [r8, r0]
	b	.L282
.L297:
	.align	2
.L296:
	.word	.LANCHOR1
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
	ldr	r3, .L302
	mov	r6, r1
	uxtb	lr, r1
	mov	r7, r0
	lsrs	r1, r1, #8
	uxtb	r8, r5
	ldr	r10, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r4, [r3, #4]	@ zero_extendqisi2
	ldr	r3, .L302+4
	ldrb	r2, [r3, #16]	@ zero_extendqisi2
	lsls	r4, r4, #8
	ldrb	ip, [r3, #8]	@ zero_extendqisi2
	add	r4, r4, r10
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	cmp	r2, #1
	lsr	r2, r6, #16
	str	ip, [r4, #2056]
	bne	.L299
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
.L301:
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
.L299:
	str	lr, [r4, #2052]
	str	r1, [r4, #2052]
	str	r2, [r4, #2052]
	str	r3, [r4, #2056]
	b	.L301
.L303:
	.align	2
.L302:
	.word	.LANCHOR6
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
	ldr	r3, .L314
	ldr	r0, [r3]
	cbz	r0, .L305
	movs	r0, #0
	bl	flash_enter_slc_mode
.L306:
	ldr	r4, .L314+4
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L307
	ldr	r3, .L314+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L307
	movs	r0, #1
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	movs	r3, #0
	strb	r3, [r4]
.L307:
	ldr	r3, .L314+12
	movs	r0, #0
	ldr	r3, [r3]
	str	r0, [r3, #336]
	pop	{r4, pc}
.L305:
	bl	flash_exit_slc_mode
	b	.L306
.L315:
	.align	2
.L314:
	.word	.LANCHOR29
	.word	.LANCHOR30
	.word	.LANCHOR24
	.word	.LANCHOR6
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
	ldr	r3, .L317
	ldr	r3, [r3, r0, lsl #3]
	str	r1, [r3, #336]
	bx	lr
.L318:
	.align	2
.L317:
	.word	.LANCHOR6
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
	ldr	r3, .L324
	cmp	r0, #35
	ldr	r3, [r3]
	bhi	.L320
	movw	r2, #4193
.L323:
	str	r2, [r3, #4]
	bx	lr
.L320:
	cmp	r0, #99
	ite	hi
	movwhi	r2, #8322
	movwls	r2, #4225
	b	.L323
.L325:
	.align	2
.L324:
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
	ldr	r3, .L327
	ldrb	r0, [r3, #21]	@ zero_extendqisi2
	b	NandcTimeCfg
.L328:
	.align	2
.L327:
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
	ldr	r3, .L337
	movs	r1, #0
	push	{r4, lr}
	movs	r4, #16
	cmp	r0, r4
	ldr	r2, [r3]
	mov	r3, #1
	str	r3, [r2, #8]
	ldr	r3, .L337+4
	str	r0, [r3]
	mov	r3, r1
	bfi	r3, r4, #8, #8
	bfi	r3, r1, #18, #1
	bne	.L330
.L333:
	bfc	r3, #4, #1
.L331:
	orr	r3, r3, #1
	str	r3, [r2, #12]
	pop	{r4, pc}
.L330:
	cmp	r0, #24
	bne	.L332
	orr	r3, r3, #16
	b	.L331
.L332:
	cmp	r0, #40
	orr	r3, r3, #262144
	orr	r3, r3, #16
	bne	.L331
	b	.L333
.L338:
	.align	2
.L337:
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
	ldr	r3, .L340
	strb	r0, [r3]
	b	NandcBchSel
.L341:
	.align	2
.L340:
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
	ldr	r3, .L349
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
.L350:
	.align	2
.L349:
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
.L352:
	ldr	r3, [r0, #8]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #11
	bpl	.L352
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
	bne	.L369
	adds	r5, fp, #0
	it	ne
	movne	r5, #1
.L356:
	ldr	r1, .L374
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
	ldr	r3, .L374+4
	ldr	r3, [r3]
	cmp	r3, #3
	bls	.L357
	ldr	r3, [r6, #16]
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	bfc	r3, #2, #1
	str	r3, [sp, #20]
	cmp	r5, #0
	beq	.L358
	ldr	r5, .L374+8
	cmp	r7, #0
	bne	.L359
.L367:
	ldr	r2, [sp, #4]
	adds	r2, r2, #1
	asrs	r2, r2, #1
	bfi	r4, r2, #22, #6
	cmp	fp, #0
	beq	.L360
	mov	r0, fp
.L361:
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
.L358:
	ldr	r3, [sp, #20]
	str	r3, [r6, #16]
.L357:
	str	r8, [r6, #12]
	str	r4, [r6, #8]
	orr	r4, r4, #4
	str	r4, [r6, #8]
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L369:
	movs	r5, #1
	b	.L356
.L359:
	ldr	r3, .L374+12
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
.L363:
	ldr	r2, [sp, #12]
	cmp	r0, r2
	bcs	.L367
	ldr	r2, [sp, #60]
	bic	r10, r1, #3
	cbz	r2, .L364
	ldrh	ip, [r3]
	adds	r3, r3, #4
	ldrh	r2, [r3, #-2]
	orr	ip, ip, r2, lsl #16
	str	ip, [lr, r10]
.L365:
	ldr	r2, [sp, #8]
	adds	r0, r0, #1
	add	r1, r1, r2
	b	.L363
.L364:
	mov	r2, #-1
	str	r2, [lr, r10]
	b	.L365
.L360:
	ldr	r3, .L374+8
	ldr	r0, [r3]
	b	.L361
.L375:
	.align	2
.L374:
	.word	.LANCHOR6
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
	ldr	r3, .L404
	push	{r0, r1, r4, lr}
	ldr	r1, [r3, r0, lsl #3]
	ldr	r3, .L404+4
	ldr	r0, [r3]
	cmp	r0, #3
	bls	.L397
	ldr	r3, [r1, #16]
	lsls	r2, r3, #29
	bpl	.L397
	ldr	r3, [r1, #16]
	tst	r3, #2
	ldr	r3, [r1, #8]
	str	r3, [sp]
	beq	.L384
.L380:
	ldr	r2, [r1, #28]
	ldr	r3, [sp]
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	cmp	r2, r3
	bge	.L381
	cmp	r0, #5
	bls	.L380
	ldr	r3, [r1]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #18
	bpl	.L380
	ldr	r3, [sp, #4]
	lsls	r4, r3, #14
	bpl	.L380
.L381:
	ldr	r3, .L404+8
	movs	r2, #0
	str	r2, [r3, #24]
.L376:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L385:
	ldr	r3, [r1, #8]
	str	r3, [sp]
.L384:
	ldr	r3, [sp]
	lsls	r2, r3, #11
	bpl	.L385
	ldr	r4, .L404+12
	ldr	r2, [r4]
	cbz	r2, .L386
	mov	r0, r1
	bl	NandcSendDumpDataStart
.L386:
	ldr	r3, [r4]
	cmp	r3, #0
	beq	.L381
	mov	r0, r1
	bl	NandcSendDumpDataDone
	b	.L381
.L397:
	ldr	r3, [r1, #8]
	str	r3, [sp]
	ldr	r3, [sp]
	lsls	r3, r3, #11
	bpl	.L397
	b	.L376
.L405:
	.align	2
.L404:
	.word	.LANCHOR6
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
.L407:
	cmp	r2, r0
	uxth	r3, r1
	add	r1, r1, #1
	bls	.L408
	subs	r0, r3, #1
	uxth	r0, r0
	bx	lr
.L408:
	lsls	r2, r2, #1
	b	.L407
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
	ldr	r3, .L411
	cmp	r0, #24
	it	cc
	movcc	r0, #24
	ldr	r2, .L411+4
	str	r0, [r3]
	ldr	r3, .L411+8
	ldrh	r3, [r3]
	muls	r3, r0, r3
	str	r3, [r2]
	ldr	r2, .L411+12
	ldrh	r2, [r2]
	subs	r0, r2, r0
	ldr	r2, .L411+16
	strh	r0, [r2]	@ movhi
	movs	r0, #0
	ldr	r2, .L411+20
	ldr	r2, [r2]
	subs	r3, r2, r3
	ldr	r2, .L411+24
	str	r3, [r2]
	bx	lr
.L412:
	.align	2
.L411:
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
	ldr	r3, .L440
	ldrh	r2, [r0, #10]
	ldrh	r6, [r0, #14]
	strh	r7, [r3]	@ movhi
	ldrh	r3, [r0, #12]
	ldr	r0, .L440+4
	ldr	r1, .L440+8
	ldr	r4, .L440+12
	strh	r6, [r0]	@ movhi
	str	r0, [sp, #20]
	ldr	r0, .L440+16
	strh	r3, [r1]	@ movhi
	movs	r1, #0
	strh	r2, [r4]	@ movhi
	str	r4, [sp, #8]
.L414:
	strb	r1, [r1, r0]
	adds	r1, r1, #1
	cmp	r1, #32
	bne	.L414
	ldrh	r0, [r10, #14]
	ldrh	r1, [r10, #20]
	cmp	r1, r0, lsr #8
	bcs	.L415
	uxtb	r8, r3
	lsl	r1, r8, #1
	uxtb	r1, r1
	str	r1, [sp, #4]
	subs	r1, r2, #1
	muls	r1, r3, r1
	str	r1, [sp, #12]
	movs	r1, #0
.L416:
	cmp	r1, r3
	bcs	.L418
	ldr	r4, [sp, #12]
	sub	fp, r1, r3
	uxtb	r0, r1
	adds	r5, r1, r4
	ldr	r4, .L440+16
	add	r4, r4, r5
	movs	r5, #0
	mov	lr, r4
	ldr	r4, .L440+16
	mov	ip, r5
	add	fp, fp, r4
	b	.L419
.L417:
	add	r4, r8, r0
	strb	r0, [fp, r5]
	str	r4, [sp, #16]
	add	ip, ip, #1
	ldrb	r4, [sp, #16]	@ zero_extendqisi2
	strb	r4, [lr, r5]
	ldr	r4, [sp, #4]
	add	r0, r0, r4
	uxtb	r0, r0
.L419:
	cmp	ip, r2
	add	r5, r5, r3
	bcc	.L417
	adds	r1, r1, #1
	b	.L416
.L418:
	ldr	r1, [sp, #8]
	lsls	r2, r2, #1
	lsrs	r6, r6, #1
	strh	r2, [r1]	@ movhi
	ldr	r2, .L440+4
	strh	r6, [r2]	@ movhi
.L415:
	ldr	r1, .L440+20
	movs	r2, #5
	cmp	r7, #1
	mov	r0, #0
	strh	r2, [r1]	@ movhi
	ldr	r2, .L440+24
	it	eq
	strheq	r7, [r1]	@ movhi
	ldr	r1, .L440+28
	strh	r0, [r2]	@ movhi
	mov	r0, #4352
	strh	r0, [r1]	@ movhi
	ldr	r0, .L440+32
	ldrb	r0, [r0]	@ zero_extendqisi2
	str	r0, [sp, #4]
	cbz	r0, .L421
	mov	r0, #384
	strh	r0, [r1]	@ movhi
.L421:
	str	r2, [sp, #16]
	ldr	r2, [sp, #8]
	ldr	r1, .L440+36
	ldrh	r6, [r10, #16]
	ldrh	r5, [r2]
	ldr	r2, [sp, #20]
	ldr	fp, .L440+116
	ldr	r8, .L440+120
	smulbb	r5, r5, r3
	ldrh	r4, [r2]
	strh	r6, [fp]	@ movhi
	uxth	r5, r5
	smulbb	r3, r3, r4
	strh	r5, [r1]	@ movhi
	smulbb	r0, r5, r6
	ldr	r1, .L440+40
	strh	r3, [r1]	@ movhi
	ldrh	r1, [r10, #18]
	ldr	r3, .L440+44
	str	r1, [sp, #12]
	strh	r1, [r3]	@ movhi
	ldr	r3, .L440+48
	strh	r0, [r3]	@ movhi
	ldrh	r3, [r10, #20]
	mov	r0, r3
	strh	r3, [r8]	@ movhi
	str	r3, [sp, #8]
	bl	Ftl_log2
	ldr	r3, [sp, #8]
	mov	r7, r0
	ldr	ip, .L440+124
	cmp	r4, #1024
	ldr	lr, .L440+128
	ldr	r2, [sp, #16]
	strh	r0, [ip]	@ movhi
	lsl	r0, r3, #9
	ldr	r1, [sp, #12]
	uxth	r0, r0
	strh	r0, [lr]	@ movhi
	lsr	r0, r0, #8
	ldr	lr, .L440+132
	mul	r1, r3, r1
	strh	r0, [lr]	@ movhi
	ldrh	lr, [r10, #26]
	mov	r10, ip
	ldr	r0, .L440+52
	strh	lr, [r0]	@ movhi
	mul	lr, r4, r5
	ldr	r0, .L440+56
	str	lr, [r0]
	itt	hi
	uxtbhi	r0, r4
	strhhi	r0, [r2]	@ movhi
	ldrh	r2, [r2]
	subs	r2, r4, r2
	muls	r2, r5, r2
	muls	r2, r3, r2
	muls	r6, r2, r6
	ldr	r2, .L440+60
	asrs	r6, r6, #11
	str	r6, [r2]
	ldr	r6, .L440+28
	ldrh	r0, [r6]
	lsls	r0, r0, #3
	bl	__aeabi_idiv
	uxth	r0, r0
	mov	r3, r6
	ldr	r6, .L440+64
	cmp	r0, #4
	itt	ls
	movls	r2, #4
	strhls	r2, [r6]	@ movhi
	ldr	r2, [sp, #4]
	it	hi
	strhhi	r0, [r6]	@ movhi
	cbz	r2, .L425
	mov	r2, #640
	strh	r2, [r3]	@ movhi
.L425:
	ldrh	r3, [r3]
	lsls	r4, r4, #6
	ldr	r2, .L440+68
	mov	r1, r5
	ldrh	r0, [r6]
	asrs	r3, r3, r7
	adds	r7, r7, #9
	asrs	r4, r4, r7
	ldr	r7, .L440+72
	adds	r3, r3, #2
	strh	r3, [r2]	@ movhi
	ldr	r3, .L440+76
	strh	r4, [r3]	@ movhi
	uxth	r4, r4
	mul	r3, r4, r5
	adds	r4, r4, #8
	str	r3, [r7]
	bl	__aeabi_uidiv
	uxtah	r0, r4, r0
	ldr	r4, .L440+80
	cmp	r5, #1
	ldr	r5, .L440+84
	it	eq
	addeq	r0, r0, #4
	str	r0, [r4]
	ldrh	r0, [r4]
	bl	FtlSysBlkNumInit
	ldr	r2, [r4]
	movs	r0, #24
	ldr	r3, .L440+88
	ldrb	r5, [r5]	@ zero_extendqisi2
	str	r2, [r3]
	ldr	r3, .L440+92
	ldr	r2, [r3]
	ldrh	r3, [fp]
	lsls	r2, r2, #2
	muls	r3, r2, r3
	ldrh	r2, [r10]
	adds	r2, r2, #9
	lsrs	r3, r3, r2
	ldr	r2, .L440+96
	adds	r3, r3, #2
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L440+100
	strh	r0, [r2]	@ movhi
	movs	r0, #0
	ldr	r2, .L440+104
	str	r0, [r2]
	ldrh	r0, [r6]
	adds	r2, r0, #3
	strh	r2, [r6]	@ movhi
	ldr	r2, [r7]
	adds	r4, r2, #3
	str	r4, [r7]
	cbz	r5, .L428
	adds	r2, r2, #5
	adds	r0, r0, #4
	strh	r0, [r6]	@ movhi
.L439:
	str	r2, [r7]
.L429:
	ldr	r1, .L440+108
	movs	r2, #0
	strh	r2, [r1]	@ movhi
	ldr	r2, .L440+112
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
.L428:
	cmp	r4, #7
	bhi	.L429
	movs	r2, #8
	b	.L439
.L441:
	.align	2
.L440:
	.word	.LANCHOR44
	.word	.LANCHOR41
	.word	.LANCHOR46
	.word	.LANCHOR45
	.word	.LANCHOR47
	.word	.LANCHOR48
	.word	.LANCHOR49
	.word	.LANCHOR50
	.word	.LANCHOR1
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
	ldr	r3, .L449
	ldrh	r3, [r3]
	cbz	r3, .L448
	ldr	r3, .L449+4
	ldr	r2, .L449+8
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L444:
	cmp	r3, r2
	bne	.L445
.L448:
	movs	r0, #0
	bx	lr
.L445:
	ldrh	r1, [r3], #2
	cmp	r0, r1
	bne	.L444
	movs	r0, #1
	bx	lr
.L450:
	.align	2
.L449:
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
	ldr	r3, .L452
	ldr	r0, [r3]
	bx	lr
.L453:
	.align	2
.L452:
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
	ldr	r3, .L455
	ldr	r0, [r3]
	bx	lr
.L456:
	.align	2
.L455:
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
	ldr	r3, .L458
	ldr	r0, [r3]
	bx	lr
.L459:
	.align	2
.L458:
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
	ldr	r3, .L461
	ldr	r0, [r3]
	bx	lr
.L462:
	.align	2
.L461:
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
	ldr	r2, .L464
	ldr	r3, .L464+4
	ldr	r0, [r2]
	ldrh	r3, [r3]
	muls	r0, r3, r0
	bx	lr
.L465:
	.align	2
.L464:
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
	ldr	r2, .L467
	ldr	r3, .L467+4
	ldrh	r0, [r2]
	ldrh	r3, [r3]
	muls	r0, r3, r0
	bx	lr
.L468:
	.align	2
.L467:
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
	ldr	r3, .L470
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	mov	r1, r4
	ldr	r4, .L470+4
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
	ldr	r0, .L470+8
	bl	printf
	ldrh	r3, [r4, #6]
	movs	r0, #0
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L471:
	.align	2
.L470:
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
	ldr	r3, .L473
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	mov	r1, r5
	bl	__aeabi_uidivmod
	mov	r0, r6
	uxth	r4, r1
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r3, .L473+4
	uxth	r0, r0
	lsrs	r2, r4, #5
	and	r4, r4, #31
	add	r0, r3, r0, lsl #2
	ldr	r3, [r0, #28]
	ldr	r0, [r3, r2, lsl #2]
	lsrs	r0, r0, r4
	and	r0, r0, #1
	pop	{r4, r5, r6, pc}
.L474:
	.align	2
.L473:
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
	ldr	r3, .L477
	mov	r7, r0
	ldrh	r6, [r3]
	mov	r1, r6
	bl	__aeabi_uidiv
	ldr	r3, .L477+4
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
.L478:
	.align	2
.L477:
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
	ldr	r3, .L480
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	ldr	r3, .L480+4
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	smulbb	r4, r0, r5
	mov	r1, r5
	mov	r0, r6
	bl	__aeabi_uidivmod
	add	r1, r1, r4
	uxth	r0, r1
	pop	{r4, r5, r6, pc}
.L481:
	.align	2
.L480:
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
	ldr	r3, .L483
	ldrh	r1, [r3]
	bl	__aeabi_uidivmod
	ldr	r3, .L483+4
	uxth	r0, r1
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	uxth	r0, r0
	pop	{r3, pc}
.L484:
	.align	2
.L483:
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
	bls	.L486
	subs	r0, r0, r1
	cmp	r0, #-2147483648
	ite	hi
	movhi	r0, #0
	movls	r0, #1
	bx	lr
.L486:
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
	ldr	r3, .L489
	ldrh	r0, [r3, #6]
	clz	r0, r0
	lsrs	r0, r0, #5
	bx	lr
.L490:
	.align	2
.L489:
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
	ldr	r3, .L492
	ldrh	r0, [r3, #6]
	sub	r3, r0, #1024
	rsbs	r0, r3, #0
	adcs	r0, r0, r3
	bx	lr
.L493:
	.align	2
.L492:
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
	bhi	.L494
	ldr	r4, .L503
	ldrh	r3, [r4, #6]
	cmp	r3, #1024
	beq	.L494
	cbz	r1, .L496
	ldr	r3, .L503+4
	ldr	r3, [r3]
	cbnz	r3, .L496
	bl	P2V_block_in_plane
	ldr	r3, .L503+8
	mov	r6, r0
	movs	r2, #1
	mov	r1, r2
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L503+12
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	ldr	r2, .L503+16
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L496:
	ldrh	r3, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #4]
	adds	r2, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	strh	r5, [r4, r2, lsl #1]	@ movhi
	strh	r3, [r4, #4]	@ movhi
.L494:
	pop	{r4, r5, r6, pc}
.L504:
	.align	2
.L503:
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
	ldr	r3, .L514
	push	{r4, r5, r6, lr}
	ldrh	r2, [r3, #6]
	cbz	r2, .L505
	ldr	r2, .L514+4
	movs	r6, #0
	ldrh	r1, [r3, #2]
	mov	r5, r6
	ldrh	r4, [r2, #28]
	ldrh	r2, [r3, #4]
	and	r4, r4, #31
.L507:
	uxth	r0, r6
	adds	r6, r6, #1
	cmp	r4, r0
	bgt	.L508
	cbz	r5, .L505
	strh	r1, [r3, #2]	@ movhi
	strh	r2, [r3, #4]	@ movhi
.L505:
	pop	{r4, r5, r6, pc}
.L508:
	adds	r0, r1, #4
	adds	r1, r1, #1
	ldrh	r5, [r3, r0, lsl #1]
	adds	r0, r2, #4
	ubfx	r1, r1, #0, #10
	strh	r5, [r3, r0, lsl #1]	@ movhi
	movs	r5, #1
	add	r2, r2, r5
	ubfx	r2, r2, #0, #10
	b	.L507
.L515:
	.align	2
.L514:
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
	ldr	r4, .L526
	mov	r6, r4
.L517:
	ldrh	r1, [r4, #6]
	cmp	r1, #0
	beq	.L518
	ldrh	r3, [r4, #2]
	subs	r1, r1, #1
	strh	r1, [r4, #6]	@ movhi
	adds	r2, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	ldrh	r5, [r4, r2, lsl #1]
	strh	r3, [r4, #2]	@ movhi
	ldr	r3, .L526+4
	ldr	r10, [r3]
	cmp	r10, #0
	bne	.L519
	ldr	r8, .L526+28
	mov	r0, r5
	bl	P2V_block_in_plane
	mov	r7, r0
	lsls	r3, r5, #10
	ldr	r0, [r8]
	str	r3, [r0, #4]
	ldr	r3, .L526+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L520
	movs	r2, #1
	mov	r1, r10
	bl	FlashEraseBlocks
.L520:
	movs	r2, #1
	ldr	r0, [r8]
	mov	r1, r2
	bl	FlashEraseBlocks
	ldr	r3, .L526+12
	ldr	r2, [r3]
	ldrh	r3, [r2, r7, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	ldr	r2, .L526+16
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L519:
	subs	r3, r5, #1
	movw	r2, #65533
	uxth	r3, r3
	cmp	r3, r2
	bls	.L522
	ldrh	r2, [r6, #6]
	mov	r1, r5
	ldr	r0, .L526+20
	bl	printf
	b	.L517
.L518:
	ldr	r0, .L526+24
	bl	printf
.L521:
	b	.L521
.L522:
	mov	r0, r5
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L527:
	.align	2
.L526:
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
	ldr	r3, .L533
	push	{r4, r5, lr}
	movw	r5, #65535
	ldr	r2, [r0]
	ldr	r4, [r3]
	subs	r3, r2, r4
	asrs	r0, r3, #1
	ldr	r3, .L533+4
	muls	r3, r0, r3
	movs	r0, #6
	uxth	r3, r3
.L530:
	cmp	r3, r1
	beq	.L531
	ldrh	r3, [r2]
	cmp	r3, r5
	beq	.L532
	mla	r2, r0, r3, r4
	b	.L530
.L531:
	movs	r0, #1
	pop	{r4, r5, pc}
.L532:
	movs	r0, #0
	pop	{r4, r5, pc}
.L534:
	.align	2
.L533:
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
	ldr	r3, .L551
	ldrh	lr, [r3]
	cmp	lr, r0
	bls	.L537
	ldr	r3, .L551+4
	movs	r5, #6
	ldr	r4, [r3]
	mul	r3, r5, r0
	str	r3, [sp, #4]
	adds	r1, r4, r3
	ldr	r2, [sp, #4]
	movw	r3, #65535
	strh	r3, [r1, #2]	@ movhi
	strh	r3, [r4, r2]	@ movhi
	ldr	r3, .L551+8
	ldr	ip, [r3]
	cmp	ip, #0
	bne	.L538
.L550:
	str	r1, [r3]
.L537:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L538:
	ldr	r3, .L551+12
	lsls	r2, r0, #1
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldrh	r6, [r3, r0, lsl #1]
	ldrh	r3, [r1, #4]
	cbz	r3, .L548
	mul	fp, r3, r6
.L539:
	sub	r3, ip, r4
	asrs	r6, r3, #1
	ldr	r3, .L551+16
	muls	r3, r6, r3
	ldr	r6, .L551+20
	ldr	r8, [r6]
	movs	r6, #0
	uxth	r3, r3
	add	r2, r8, r2
	str	r2, [sp, #12]
	mov	r2, ip
.L546:
	adds	r6, r6, #1
	uxth	r6, r6
	cmp	lr, r6
	bcc	.L537
	cmp	r3, r0
	beq	.L537
	ldr	r7, [sp, #8]
	lsl	r10, r3, #1
	ldrh	r7, [r7, r3, lsl #1]
	mov	r5, r7
	ldrh	r7, [r2, #4]
	cbz	r7, .L549
	muls	r7, r5, r7
.L541:
	cmp	fp, r7
	bne	.L542
	ldr	r5, [sp, #12]
	ldrh	r10, [r8, r10]
	ldrh	r7, [r5]
	cmp	r10, r7
	bcc	.L544
.L543:
	ldr	r5, [sp, #4]
	cmp	r2, ip
	strh	r3, [r4, r5]	@ movhi
	ldrh	r3, [r2, #2]
	strh	r3, [r1, #2]	@ movhi
	bne	.L547
	strh	r0, [r2, #2]	@ movhi
	ldr	r3, .L551+8
	b	.L550
.L548:
	mov	fp, #-1
	b	.L539
.L549:
	mov	r7, #-1
	b	.L541
.L542:
	bcc	.L543
.L544:
	ldrh	r7, [r2]
	movw	r5, #65535
	cmp	r7, r5
	bne	.L545
	strh	r3, [r1, #2]	@ movhi
	strh	r0, [r2]	@ movhi
	ldr	r3, .L551+24
	b	.L550
.L545:
	movs	r3, #6
	mla	r2, r3, r7, r4
	mov	r3, r7
	b	.L546
.L547:
	ldrh	r1, [r2, #2]
	movs	r3, #6
	muls	r3, r1, r3
	strh	r0, [r4, r3]	@ movhi
	strh	r0, [r2, #2]	@ movhi
	b	.L537
.L552:
	.align	2
.L551:
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
	ldr	r2, .L555
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L555+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L553
	ldr	r1, .L555+8
	movs	r2, #210
	ldr	r0, .L555+12
	bl	printf
	ldr	r1, .L555+16
	ldr	r0, .L555+20
	pop	{r3, lr}
	b	printf
.L553:
	pop	{r3, pc}
.L556:
	.align	2
.L555:
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
	beq	.L558
	ldr	r3, .L564
	mov	r10, #6
	mul	r7, r10, r0
	ldr	r4, [r3]
	ldr	r3, .L564+4
	adds	r5, r4, r7
	ldr	r6, [r3]
	mov	lr, r3
	strh	r1, [r5, #2]	@ movhi
	strh	r1, [r4, r7]	@ movhi
	cbnz	r6, .L559
	str	r5, [r3]
.L558:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L559:
	ldr	r3, .L564+8
	subs	r2, r6, r4
	mov	fp, r1
	ldr	ip, [r3]
	asrs	r3, r2, #1
	ldr	r2, .L564+12
	ldrh	r8, [ip, r0, lsl #1]
	muls	r2, r3, r2
	mov	r3, r6
	uxth	r2, r2
.L562:
	ldrh	r1, [ip, r2, lsl #1]
	cmp	r1, r8
	bcs	.L560
	ldrh	r1, [r3]
	cmp	r1, fp
	bne	.L561
	strh	r2, [r5, #2]	@ movhi
	strh	r0, [r3]	@ movhi
	b	.L558
.L561:
	mla	r3, r10, r1, r4
	mov	r2, r1
	b	.L562
.L560:
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
	b	.L558
.L565:
	.align	2
.L564:
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
	ldr	r2, .L568
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L568+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L566
	ldr	r1, .L568+8
	movs	r2, #203
	ldr	r0, .L568+12
	bl	printf
	ldr	r1, .L568+16
	ldr	r0, .L568+20
	pop	{r3, lr}
	b	printf
.L566:
	pop	{r3, pc}
.L569:
	.align	2
.L568:
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
	ldr	r5, .L576
	muls	r6, r1, r6
	movw	r3, #65535
	mov	r8, r0
	ldr	r7, [r5]
	adds	r4, r7, r6
	ldrh	r2, [r4, #2]
	cmp	r2, r3
	bne	.L571
	ldr	r3, [r0]
	cmp	r4, r3
	beq	.L571
	ldr	r1, .L576+4
	mov	r2, #386
	ldr	r0, .L576+8
	bl	printf
	ldr	r1, .L576+12
	ldr	r0, .L576+16
	bl	printf
.L571:
	ldr	r3, [r8]
	movw	r1, #65535
	cmp	r4, r3
	ldrh	r3, [r7, r6]
	bne	.L572
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
.L574:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r7, r6]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	pop	{r4, r5, r6, r7, r8, pc}
.L572:
	cmp	r3, r1
	ldrh	r1, [r4, #2]
	bne	.L575
	cmp	r1, r3
	beq	.L574
	movs	r2, #6
	ldr	r0, [r5]
	muls	r1, r2, r1
	strh	r3, [r0, r1]	@ movhi
	b	.L574
.L575:
	ldr	r0, [r5]
	movs	r2, #6
	mla	r5, r2, r3, r0
	strh	r1, [r5, #2]	@ movhi
	ldrh	r1, [r4, #2]
	muls	r2, r1, r2
	strh	r3, [r0, r2]	@ movhi
	b	.L574
.L577:
	.align	2
.L576:
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
	cbz	r3, .L584
	ldr	r2, .L585
	movw	r5, #65535
	movs	r6, #6
	ldr	r2, [r2]
.L580:
	cbnz	r1, .L581
.L583:
	ldr	r4, .L585+4
	subs	r3, r3, r2
	asrs	r3, r3, #1
	muls	r4, r3, r4
	uxth	r1, r4
	bl	List_remove_node
	uxth	r0, r4
	pop	{r4, r5, r6, pc}
.L581:
	ldrh	r4, [r3]
	cmp	r4, r5
	beq	.L583
	subs	r1, r1, #1
	mla	r3, r6, r4, r2
	uxth	r1, r1
	b	.L580
.L584:
	movw	r0, #65535
	pop	{r4, r5, r6, pc}
.L586:
	.align	2
.L585:
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
	ldr	r3, .L593
	push	{r4, lr}
	ldr	r3, [r3]
	cbz	r3, .L592
	ldr	r2, .L593+4
	movs	r4, #6
	ldr	r1, [r2]
	movw	r2, #65535
.L589:
	cbz	r0, .L590
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L591
.L592:
	movw	r0, #65535
	pop	{r4, pc}
.L591:
	subs	r0, r0, #1
	mla	r3, r4, r3, r1
	uxth	r0, r0
	b	.L589
.L590:
	ldr	r0, .L593+8
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r0, r3
	uxth	r0, r3
	pop	{r4, pc}
.L594:
	.align	2
.L593:
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
	ldr	r3, .L606
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L597
	ldr	r3, .L606+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L597
	ldr	r3, .L606+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L597
	ldr	r7, .L606+12
	movs	r6, #6
	ldr	r3, .L606+16
	muls	r6, r0, r6
	ldr	fp, [r7]
	ldr	r3, [r3]
	add	r10, fp, r6
	cmp	r10, r3
	beq	.L597
	ldr	r3, .L606+20
	ldrh	r5, [r10, #4]
	ldr	r2, [r3]
	mov	r8, r3
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r5, #0
	beq	.L604
	muls	r5, r2, r5
.L599:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L600
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	bne	.L600
	ldr	r1, .L606+24
	mov	r2, #504
	ldr	r0, .L606+28
	bl	printf
	ldr	r1, .L606+32
	ldr	r0, .L606+36
	bl	printf
.L600:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L601
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	beq	.L597
.L601:
	movs	r2, #6
	muls	r2, r3, r2
	ldr	r3, .L606+40
	asrs	r1, r2, #1
	muls	r3, r1, r3
	ldr	r1, [r8]
	ldrh	r0, [r1, r3, lsl #1]
	ldr	r1, [r7]
	add	r2, r2, r1
	ldrh	r3, [r2, #4]
	cbz	r3, .L605
	muls	r3, r0, r3
.L602:
	cmp	r5, r3
	bcs	.L597
	ldr	r5, .L606+44
	mov	r1, r4
	ldr	r0, .L606+16
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L603
	ldr	r1, .L606+24
	movw	r2, #515
	ldr	r0, .L606+28
	bl	printf
	ldr	r1, .L606+32
	ldr	r0, .L606+36
	bl	printf
.L603:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	INSERT_DATA_LIST
.L597:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L604:
	mov	r5, #-1
	b	.L599
.L605:
	mov	r3, #-1
	b	.L602
.L607:
	.align	2
.L606:
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
.L609:
	uxth	r5, r3
	cmp	r5, r1
	bcs	.L612
	mov	r7, r2
	adds	r3, r3, #1
	ldrh	r6, [r7]
	adds	r2, r2, #2
	cmp	r6, #0
	bne	.L609
	bl	FtlFreeSysBlkQueueOut
	subs	r3, r0, #1
	movw	r2, #65533
	uxth	r3, r3
	mov	r1, r0
	strh	r0, [r7]	@ movhi
	cmp	r3, r2
	bls	.L610
	ldr	r3, .L616
	ldr	r0, .L616+4
	ldrh	r2, [r3, #6]
	bl	printf
.L611:
	b	.L611
.L610:
	ldr	r3, [r4, #28]
	strh	r6, [r4, #2]	@ movhi
	strh	r5, [r4]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #28]
	ldrh	r3, [r4, #8]
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
.L612:
	ldrh	r3, [r4, #10]
	cmp	r3, r5
	bhi	.L614
	ldr	r1, .L616+8
	movw	r2, #629
	ldr	r0, .L616+12
	bl	printf
	ldr	r1, .L616+16
	ldr	r0, .L616+20
	bl	printf
.L614:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L617:
	.align	2
.L616:
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
	ldr	r3, .L628
	movs	r0, #12
	movw	r5, #65535
	ldrh	r2, [r3]
	ldr	r3, .L628+4
	ldr	r3, [r3]
.L619:
	uxth	r4, r1
	cmp	r4, r2
	bcc	.L621
	mov	r4, r2
	movs	r1, #0
	mov	r6, #-2147483648
	movs	r7, #12
.L622:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L624
	cmp	r4, r2
	bcc	.L620
	ldr	r1, .L628+8
	mov	r4, r2
	mov	r0, #-1
	ldrh	r7, [r1]
	movs	r1, #0
.L625:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L627
	cmp	r4, r2
	bcc	.L620
	movw	r2, #859
	ldr	r1, .L628+12
	ldr	r0, .L628+16
	bl	printf
	ldr	r1, .L628+20
	ldr	r0, .L628+24
	bl	printf
	b	.L620
.L621:
	adds	r1, r1, #1
	mla	r6, r0, r1, r3
	ldrh	r6, [r6, #-12]
	cmp	r6, r5
	bne	.L619
.L620:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L624:
	mla	r0, r7, r1, r3
	ldr	r0, [r0, #4]
	cmp	r0, #0
	blt	.L623
	cmp	r6, r0
	itt	hi
	movhi	r6, r0
	movhi	r4, r5
.L623:
	adds	r1, r1, #1
	b	.L622
.L627:
	ldr	r6, [r3, #4]
	cmp	r0, r6
	bls	.L626
	ldrh	ip, [r3]
	cmp	ip, r7
	itt	ne
	movne	r0, r6
	movne	r4, r5
.L626:
	adds	r1, r1, #1
	adds	r3, r3, #12
	b	.L625
.L629:
	.align	2
.L628:
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
	ldr	r2, .L640
	push	{r4, r5, r6, lr}
	mov	r1, r2
	ldrh	r3, [r2]
	cmp	r3, #4
	bhi	.L631
	cbnz	r0, .L631
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	pop	{r4, r5, r6, pc}
.L631:
	movs	r3, #0
	ldr	r0, .L640+4
	strh	r3, [r1]	@ movhi
	movw	r6, #65535
	ldr	r1, .L640+8
	ldrh	r4, [r0]
	mov	r0, r3
	ldr	r2, .L640+12
	ldr	r1, [r1]
	str	r3, [r2]
	add	r4, r1, r4, lsl #1
.L632:
	cmp	r1, r4
	bne	.L634
	cbz	r3, .L630
	str	r0, [r2]
.L630:
	pop	{r4, r5, r6, pc}
.L634:
	ldrh	r5, [r1], #2
	cmp	r5, r6
	itt	ne
	addne	r0, r0, r5
	movne	r3, #1
	b	.L632
.L641:
	.align	2
.L640:
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
	cbz	r1, .L643
	b	ftl_set_blk_mode.part.10
.L643:
	ldr	r2, .L644
	lsrs	r0, r0, #5
	and	r3, r3, #31
	ldr	r1, [r2]
	movs	r2, #1
	lsl	r3, r2, r3
	ldr	r2, [r1, r0, lsl #2]
	bic	r2, r2, r3
	str	r2, [r1, r0, lsl #2]
	bx	lr
.L645:
	.align	2
.L644:
	.word	.LANCHOR0
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
	ldr	r3, .L647
	lsrs	r2, r0, #5
	and	r0, r0, #31
	ldr	r3, [r3]
	ldr	r3, [r3, r2, lsl #2]
	lsr	r0, r3, r0
	and	r0, r0, #1
	bx	lr
.L648:
	.align	2
.L647:
	.word	.LANCHOR0
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
	ldr	r3, .L656
	ldrh	r4, [r3]
	add	r3, r0, r2, lsl #1
	adds	r3, r3, #14
.L650:
	cmp	r2, r4
	bcc	.L652
	ldr	r3, .L656+4
	add	r5, r0, #16
	movw	r6, #65535
	ldrh	r3, [r3]
	subs	r3, r3, #1
	subs	r1, r3, r1
	movs	r3, #0
	uxth	r1, r1
.L653:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L655
	pop	{r4, r5, r6, pc}
.L652:
	ldrh	r5, [r3, #2]!
	adds	r2, r2, #1
	uxth	r2, r2
	cmp	r5, r6
	ittt	ne
	ldrhne	r5, [r0, #4]
	addne	r5, r5, #1
	strhne	r5, [r0, #4]	@ movhi
	b	.L650
.L655:
	ldrh	r2, [r5], #2
	adds	r3, r3, #1
	cmp	r2, r6
	ittt	ne
	ldrhne	r2, [r0, #4]
	addne	r2, r2, r1
	strhne	r2, [r0, #4]	@ movhi
	b	.L653
.L657:
	.align	2
.L656:
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
	ldr	r3, .L671
	ldrh	r2, [r0]
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L659
	ldr	r1, .L671+4
	movw	r2, #2575
	ldr	r0, .L671+8
	bl	printf
	ldr	r1, .L671+12
	ldr	r0, .L671+16
	bl	printf
.L659:
	ldr	r3, .L671+20
	add	r6, r4, #16
	ldr	r10, .L671+40
	movw	r7, #65535
	movs	r5, #0
	ldrh	r8, [r3]
	strh	r5, [r4, #4]	@ movhi
	strb	r5, [r4, #7]
.L660:
	uxth	r3, r5
	cmp	r8, r3
	bhi	.L662
	ldr	r2, .L671+24
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #9]
	ldr	r3, .L671+28
	ldr	r3, [r3]
	cbz	r3, .L663
	ldr	r3, .L671+32
	ldrh	r2, [r4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r3, #79
	itt	ls
	movls	r3, #1
	strbls	r3, [r4, #9]
.L663:
	ldr	r3, .L671+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L664
	movs	r3, #1
	strb	r3, [r4, #9]
.L664:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L662:
	ldrh	r1, [r4]
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	strh	r7, [r6]	@ movhi
	mov	fp, r0
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L661
	strh	fp, [r6]	@ movhi
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r4, #7]
.L661:
	adds	r5, r5, #1
	adds	r6, r6, #2
	b	.L660
.L672:
	.align	2
.L671:
	.word	.LANCHOR40
	.word	.LANCHOR101
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR38
	.word	.LANCHOR52
	.word	.LANCHOR28
	.word	.LANCHOR78
	.word	.LANCHOR1
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
	ldr	r3, .L679
	mov	r6, r0
	mov	r4, r5
	ldr	r10, .L679+12
	ldrh	r7, [r3]
	ldr	r3, .L679+4
	ldrh	r8, [r3]
.L674:
	uxth	r3, r5
	cmp	r7, r3
	bhi	.L676
	cbz	r4, .L678
	mov	r1, r4
	mov	r0, #32768
	bl	__aeabi_idiv
.L677:
	ldr	r3, .L679+8
	movs	r2, #6
	ldr	r3, [r3]
	mla	r6, r2, r6, r3
	strh	r0, [r6, #4]	@ movhi
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L676:
	mov	r1, r6
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L675
	add	r4, r4, r8
	uxth	r4, r4
.L675:
	adds	r5, r5, #1
	b	.L674
.L678:
	mov	r0, r4
	b	.L677
.L680:
	.align	2
.L679:
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
	ldr	r3, .L684
	ldr	r0, [r3]
	cbz	r0, .L682
	ldr	r3, .L684+4
	ldr	r3, [r3]
	subs	r0, r0, r3
	ldr	r3, .L684+8
	asrs	r0, r0, #1
	muls	r0, r3, r0
	ldr	r3, .L684+12
	ldr	r3, [r3]
	uxth	r0, r0
	ldrh	r0, [r3, r0, lsl #1]
.L682:
	bx	lr
.L685:
	.align	2
.L684:
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
	ldr	r3, .L694
	push	{r4, r5, r6, lr}
	ldr	r3, [r3]
	cbz	r3, .L692
	ldr	r2, .L694+4
	movs	r5, #6
	movw	r6, #65535
	ldrh	r2, [r2]
	rsb	r2, r2, r2, lsl #3
	asrs	r2, r2, #3
	cmp	r0, r2
	it	gt
	uxthgt	r0, r2
	ldr	r2, .L694+8
	ldr	r1, [r2]
	ldr	r2, .L694+12
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r2, r3
	movs	r2, #0
	uxth	r3, r3
.L689:
	uxth	r4, r2
	cmp	r0, r4
	bls	.L691
	mul	r4, r5, r3
	adds	r2, r2, #1
	ldrh	r4, [r1, r4]
	cmp	r4, r6
	bne	.L693
.L691:
	ldr	r2, .L694+16
	ldr	r2, [r2]
	ldrh	r0, [r2, r3, lsl #1]
	pop	{r4, r5, r6, pc}
.L693:
	mov	r3, r4
	b	.L689
.L692:
	mov	r0, r3
	pop	{r4, r5, r6, pc}
.L695:
	.align	2
.L694:
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
	beq	.L697
	ldr	r2, .L698
	movs	r1, #0
	ldr	r2, [r2]
	strh	r1, [r2, r0, lsl #1]	@ movhi
	bl	INSERT_FREE_LIST
.L697:
	movs	r0, #0
	pop	{r3, pc}
.L699:
	.align	2
.L698:
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
	ldr	r1, .L705
	mov	fp, #1
	ldr	r2, .L705+4
	ldr	r5, [r1]
	ldr	r1, .L705+8
	str	r3, [r2]
	ldr	r2, .L705+12
	mov	r0, r5
	ldr	r1, [r1]
	ldrh	r2, [r2]
	str	r1, [sp, #4]
	ldr	r1, .L705+16
	ldrh	r1, [r1]
	str	r1, [sp]
	ldr	r1, .L705+20
	ldr	r10, [r1]
	ldr	r1, .L705+24
	ldrh	r7, [r1]
	ldr	r1, .L705+28
	ldr	r4, [r1]
	movs	r1, #12
	mla	r1, r2, r1, r1
	adds	r4, r4, #8
	add	r8, r5, r1
	mov	r1, r3
.L701:
	adds	r0, r0, #12
	ldr	r6, [sp]
	cmp	r0, r8
	add	ip, r3, r7
	add	r4, r4, #36
	add	lr, r1, r6
	bne	.L702
	ldr	r3, .L705+32
	mov	lr, #12
	mov	r8, #0
	ldr	r0, [r3]
	ldr	r3, .L705+8
	ldr	r4, [r3]
	ldr	r3, .L705+20
	ldr	ip, [r3]
.L703:
	cmp	r2, r0
	bcc	.L704
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L702:
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
	b	.L701
.L704:
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
	b	.L703
.L706:
	.align	2
.L705:
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
	ldr	r3, .L714
	mov	ip, #12
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	mov	fp, #36
	mov	lr, r4
	ldr	r7, [r3]
	ldr	r3, .L714+4
	ldr	r5, [r3]
.L708:
	uxth	r3, r4
	cmp	r1, r3
	bls	.L707
	mla	r8, fp, r3, r0
	movs	r2, #0
.L709:
	uxth	r3, r2
	cmp	r7, r3
	bls	.L710
	mul	r3, ip, r3
	ldr	r6, [r8, #8]
	adds	r2, r2, #1
	add	r10, r5, r3
	ldr	r3, [r5, r3]
	cmp	r3, r6
	bne	.L709
	str	lr, [r10, #8]
.L710:
	adds	r4, r4, #1
	b	.L708
.L707:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L715:
	.align	2
.L714:
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
	ldr	r3, .L723
	movs	r2, #0
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	ip, #12
	movs	r7, #1
	mov	lr, #36
	ldr	r4, [r3]
	ldr	r3, .L723+4
	ldr	r5, [r3]
.L717:
	uxth	r8, r2
	cmp	r1, r8
	bhi	.L721
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L721:
	mov	r10, #0
.L718:
	uxth	r3, r10
	cmp	r4, r3
	bls	.L719
	mla	r3, ip, r3, r5
	add	r10, r10, #1
	ldr	r6, [r3, #8]
	cmp	r6, #0
	bne	.L718
	mla	r8, lr, r8, r0
	str	r7, [r3, #8]
	ldr	r6, [r3]
	ldr	r3, [r3, #4]
	str	r6, [r8, #8]
	str	r3, [r8, #12]
.L719:
	adds	r2, r2, #1
	b	.L717
.L724:
	.align	2
.L723:
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
	ldr	r3, .L730
	ldr	r2, .L730+4
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L726:
	cmp	r3, r2
	bne	.L728
	movs	r0, #0
	bx	lr
.L728:
	ldrh	r1, [r3], #2
	cmp	r1, r0
	bne	.L726
	movs	r0, #1
	bx	lr
.L731:
	.align	2
.L730:
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
	ldr	r4, .L736
	ubfx	r0, r0, #10, #16
	mov	r6, r1
	mov	r7, r2
	bl	P2V_block_in_plane
	ldr	r3, .L736+4
	ldrh	r1, [r4]
	ldr	r2, [r3]
	movs	r3, #0
.L733:
	uxth	ip, r3
	cmp	ip, r1
	bcc	.L735
	bne	.L734
	strh	r0, [r2, ip, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L734
.L735:
	adds	r3, r3, #1
	add	ip, r2, r3, lsl #1
	ldrh	ip, [ip, #-2]
	cmp	ip, r0
	bne	.L733
.L734:
	ldr	r2, .L736+8
	movs	r0, #12
	ldr	r1, .L736+12
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
.L737:
	.align	2
.L736:
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
	ldr	ip, .L743+12
	push	{r4, r5, r6, r7, lr}
	ldrh	lr, [ip]
	cmp	lr, r0
	beq	.L739
	ldr	r6, .L743
	ldrh	r7, [r6]
	cmp	r0, r7
	beq	.L739
	ldr	r4, .L743+4
	ldrh	r5, [r4]
	cmp	r0, r5
	beq	.L739
	ldr	r2, .L743+8
	ldrh	r1, [r2]
	cmp	r0, r1
	beq	.L739
	movw	r3, #65535
	cmp	lr, r3
	bne	.L740
	strh	r0, [ip]	@ movhi
.L739:
	movs	r0, #0
	pop	{r4, r5, r6, r7, pc}
.L740:
	cmp	r7, r3
	bne	.L741
	strh	r0, [r6]	@ movhi
	b	.L739
.L741:
	cmp	r5, r3
	bne	.L742
	strh	r0, [r4]	@ movhi
	b	.L739
.L742:
	cmp	r1, r3
	it	eq
	strheq	r0, [r2]	@ movhi
	b	.L739
.L744:
	.align	2
.L743:
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
	ldr	ip, .L755+12
	push	{r4, r5, r6, r7, lr}
	ldrh	lr, [ip]
	cmp	lr, r0
	beq	.L753
	ldr	r6, .L755
	ldrh	r7, [r6]
	cmp	r0, r7
	beq	.L753
	ldr	r4, .L755+4
	ldrh	r5, [r4]
	cmp	r0, r5
	beq	.L753
	ldr	r2, .L755+8
	ldrh	r1, [r2]
	cmp	r0, r1
	beq	.L753
	movw	r3, #65535
	cmp	lr, r3
	bne	.L747
	strh	r0, [ip]	@ movhi
.L753:
	movs	r0, #0
	pop	{r4, r5, r6, r7, pc}
.L747:
	cmp	r7, r3
	bne	.L748
	strh	r0, [r6]	@ movhi
	b	.L753
.L748:
	cmp	r5, r3
	bne	.L749
	strh	r0, [r4]	@ movhi
	b	.L753
.L749:
	cmp	r1, r3
	bne	.L754
	strh	r0, [r2]	@ movhi
	b	.L753
.L754:
	mov	r0, #-1
	pop	{r4, r5, r6, r7, pc}
.L756:
	.align	2
.L755:
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
	ldr	r3, .L765
	ldr	r3, [r3]
	cbz	r3, .L758
	ldr	r3, .L765+4
	ldr	r2, [r3]
	ldrh	r3, [r2, r5, lsl #1]
	cmp	r3, #39
	itt	hi
	subhi	r3, r3, #40
	strhhi	r3, [r2, r5, lsl #1]	@ movhi
.L758:
	ldr	r2, .L765+8
	movs	r1, #0
	ldr	r5, .L765+12
	ldrh	r3, [r2]
.L759:
	uxth	r0, r1
	cmp	r3, r0
	bhi	.L761
	cmp	r3, #15
	itttt	ls
	addls	r1, r3, #1
	strhls	r1, [r2]	@ movhi
	ldrls	r2, .L765+12
	strhls	r4, [r2, r3, lsl #1]	@ movhi
	b	.L760
.L761:
	adds	r1, r1, #1
	add	r0, r5, r1, lsl #1
	ldrh	r0, [r0, #-2]
	cmp	r0, r4
	bne	.L759
.L760:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L766:
	.align	2
.L765:
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
	ldr	r3, .L773
	push	{r4, lr}
	ldrh	r3, [r3]
	cbz	r3, .L768
	ldr	r2, .L773+4
	ldrh	r1, [r2]
	movw	r2, #65535
	cmp	r1, r2
	bne	.L768
	ldr	r4, .L773+8
	ldrh	r2, [r4]
	cmp	r2, r3
	itt	cs
	movcs	r3, #0
	strhcs	r3, [r4]	@ movhi
	ldr	r3, .L773+12
	ldrh	r2, [r4]
	ldrh	r0, [r3, r2, lsl #1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
.L768:
	movs	r0, #0
	pop	{r4, pc}
.L774:
	.align	2
.L773:
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
	ldr	r3, .L777
	ldr	r2, [r3]
	ldr	r3, .L777+4
	cmp	r2, r3
	bne	.L775
	b	flash_enter_slc_mode
.L775:
	bx	lr
.L778:
	.align	2
.L777:
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
	ldr	r3, .L781
	ldr	r2, [r3]
	ldr	r3, .L781+4
	cmp	r2, r3
	bne	.L779
	b	flash_exit_slc_mode
.L779:
	bx	lr
.L782:
	.align	2
.L781:
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
	ldr	r3, .L784
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
.L785:
	.align	2
.L784:
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
	cbnz	r0, .L788
	ldr	r3, .L828
.L789:
	strh	r0, [r3, r0, lsl #1]	@ movhi
	adds	r0, r0, #1
	cmp	r0, #256
	bne	.L789
.L795:
	movs	r1, #255
	mov	r2, #1024
	ldr	r0, .L828+4
	uxth	r4, r4
	bl	ftl_memset
	ldr	r1, .L828
	movs	r3, #0
	ldr	r0, .L828+4
.L790:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L814
	pop	{r4, pc}
.L788:
	cmp	r0, #1
	bne	.L791
	ldr	r1, .L828
	movs	r3, #0
.L794:
	cmp	r3, #3
	uxth	r2, r3
	bls	.L792
	tst	r2, #1
	ite	ne
	movne	r0, #3
	moveq	r0, #2
	rsb	r2, r0, r2, lsl #1
	uxth	r2, r2
.L792:
	strh	r2, [r1, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L794
	b	.L795
.L791:
	cmp	r0, #2
	bne	.L796
	ldr	r1, .L828
	movs	r2, #0
.L798:
	uxth	r3, r2
	cmp	r2, #1
	ittt	hi
	lslhi	r3, r3, #1
	addhi	r3, r3, #-1
	uxthhi	r3, r3
	strh	r3, [r1, r2, lsl #1]	@ movhi
	adds	r2, r2, #1
	cmp	r2, #256
	bne	.L798
	b	.L795
.L796:
	cmp	r0, #3
	bne	.L799
	ldr	r1, .L828
	movs	r3, #0
.L802:
	cmp	r3, #5
	uxth	r2, r3
	bls	.L800
	tst	r2, #1
	ite	ne
	movne	r0, #5
	moveq	r0, #4
	rsb	r2, r0, r2, lsl #1
	uxth	r2, r2
.L800:
	strh	r2, [r1, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L802
	b	.L795
.L799:
	cmp	r0, #4
	mov	r3, #0
	bne	.L803
	ldr	r2, .L828
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
.L805:
	tst	r3, #1
	ite	ne
	movne	r1, #7
	moveq	r1, #6
	rsb	r1, r1, r3, lsl #1
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r1, [r2, #2]!	@ movhi
	cmp	r3, #256
	bne	.L805
	b	.L795
.L803:
	cmp	r0, #5
	bne	.L806
	ldr	r2, .L828
.L807:
	strh	r3, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #16
	bne	.L807
	ldr	r2, .L828+8
.L808:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, #496
	bne	.L808
	b	.L795
.L806:
	cmp	r0, #6
	bne	.L809
	ldr	r0, .L828
	mov	r1, r3
.L812:
	cmp	r1, #5
	uxth	r2, r1
	bls	.L810
	tst	r2, #1
	ite	ne
	movne	r2, #12
	moveq	r2, #10
	subs	r2, r3, r2
	uxth	r2, r2
.L810:
	strh	r2, [r0, r1, lsl #1]	@ movhi
	adds	r1, r1, #1
	cmp	r1, #256
	add	r3, r3, #3
	uxth	r3, r3
	bne	.L812
	b	.L795
.L809:
	cmp	r0, #9
	bne	.L795
	ldr	r2, .L828
	movw	r1, #509
	strh	r3, [r2]	@ movhi
	movs	r3, #1
	strh	r3, [r2, #2]	@ movhi
	mov	r3, r2
	movs	r2, #2
	strh	r2, [r3, #4]!	@ movhi
	movs	r2, #3
.L813:
	strh	r2, [r3, #2]!	@ movhi
	adds	r2, r2, #2
	uxth	r2, r2
	cmp	r2, r1
	bne	.L813
	b	.L795
.L814:
	ldrh	r2, [r1, r3, lsl #1]
	adds	r3, r3, #1
	strh	r2, [r0, r2, lsl #1]	@ movhi
	b	.L790
.L829:
	.align	2
.L828:
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
	ldr	r3, .L844
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r5, .L844+4
	ldr	fp, .L844+36
	ldrh	r0, [r3, #10]
	strb	r4, [r5]
	strb	r4, [fp]
	bl	FlashBlockAlignInit
	movs	r2, #8
	mov	r1, r4
	ldr	r0, .L844+8
	bl	ftl_memset
	movs	r2, #32
	mov	r1, r4
	ldr	r0, .L844+12
	bl	ftl_memset
	movs	r2, #128
	mov	r1, r4
	ldr	r0, .L844+16
	bl	ftl_memset
	ldr	r3, .L844+20
	ldr	r10, .L844+32
	ldr	r6, [r3]
	ldr	r3, .L844+8
	ldrb	r8, [r6]	@ zero_extendqisi2
	adds	r7, r6, #1
.L832:
	mov	r2, r8
	add	r1, r10, r4, lsl #3
	mov	r0, r7
	str	r3, [sp, #4]
	bl	FlashMemCmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L831
	ldrb	r2, [r5]	@ zero_extendqisi2
	ldr	r1, .L844+12
	strb	r4, [r3, r2]
	str	r0, [r1, r2, lsl #2]
	adds	r1, r2, #1
	strb	r1, [r5]
.L831:
	adds	r4, r4, #1
	cmp	r4, #4
	bne	.L832
	ldrb	r3, [r5]	@ zero_extendqisi2
	strb	r3, [fp]
	ldrb	r3, [r6, #8]	@ zero_extendqisi2
	cmp	r3, #2
	beq	.L833
.L837:
	ldrh	r2, [r6, #14]
	ldrb	r3, [r5]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldrb	r2, [r6, #13]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldr	r2, .L844+24
	strh	r3, [r2]	@ movhi
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L833:
	ldr	r3, .L844+28
	movs	r4, #0
	ldr	r10, .L844+12
	ldr	fp, [r3]
	ldr	r3, .L844+8
.L836:
	str	r3, [sp, #4]
	mov	r2, r8
	ldr	r3, .L844+32
	mov	r0, r7
	add	r1, r3, r4, lsl #3
	bl	FlashMemCmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L834
	ldrh	r2, [r6, #14]
	ldrb	r1, [r5]	@ zero_extendqisi2
	and	r0, r2, #65280
	ldrb	r2, [r6, #13]	@ zero_extendqisi2
	mul	r2, fp, r2
	muls	r2, r0, r2
	str	r2, [r10, r1, lsl #2]
	ldrb	r0, [r6, #23]	@ zero_extendqisi2
	cbz	r0, .L835
	lsls	r2, r2, #1
	str	r2, [r10, r1, lsl #2]
.L835:
	adds	r2, r1, #1
	strb	r4, [r3, r1]
	strb	r2, [r5]
.L834:
	adds	r4, r4, #1
	cmp	r4, #4
	bne	.L836
	b	.L837
.L845:
	.align	2
.L844:
	.word	.LANCHOR31
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR17
	.word	.LANCHOR23
	.word	.LANCHOR18
	.word	.LANCHOR122
	.word	.LANCHOR3
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
	ldr	r3, .L849
	movs	r2, #0
	ldr	r1, [r3]
	ldr	r3, .L849+4
	ldrb	r0, [r1, #9]	@ zero_extendqisi2
	ldr	r3, [r3]
	smulbb	r3, r3, r0
	uxth	r3, r3
	strb	r3, [r4, #4]
	lsrs	r3, r3, #8
	strb	r3, [r4, #5]
	ldr	r3, .L849+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r4, #7]
	ldr	r3, .L849+12
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
	ldr	r0, .L849+16
	strb	r2, [r4, #10]
	strb	r3, [r4, #9]
	ldr	r3, .L849+20
	ldrb	r1, [r3]	@ zero_extendqisi2
	mov	r3, r2
.L847:
	uxtb	r2, r3
	cmp	r1, r2
	bhi	.L848
	pop	{r4, r5, r6, pc}
.L848:
	ldrb	r2, [r3, r0]	@ zero_extendqisi2
	adds	r3, r3, #1
	ldrb	r6, [r4, #10]	@ zero_extendqisi2
	lsl	r2, r5, r2
	orrs	r2, r2, r6
	strb	r2, [r4, #10]
	b	.L847
.L850:
	.align	2
.L849:
	.word	.LANCHOR18
	.word	.LANCHOR3
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
	ldr	r3, .L857
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, r0
	ldr	r7, .L857+4
	mov	r6, r1
	subs	r4, r5, #2
	addw	r5, r5, #1022
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r8, .L857+20
	mov	r0, r6
	lsls	r2, r2, #2
	bl	ftl_memset
.L854:
	ldrh	r3, [r4, #2]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L851
	ldrh	r2, [r7]
	cmp	r2, r3
	bhi	.L853
	mov	r1, r8
	movs	r2, #79
	ldr	r0, .L857+8
	bl	printf
	ldr	r1, .L857+12
	ldr	r0, .L857+16
	bl	printf
.L853:
	ldrh	r3, [r4, #2]!
	movs	r2, #1
	cmp	r5, r4
	lsr	r1, r3, #5
	and	r3, r3, #31
	lsl	r3, r2, r3
	ldr	r2, [r6, r1, lsl #2]
	orr	r2, r2, r3
	str	r2, [r6, r1, lsl #2]
	bne	.L854
.L851:
	pop	{r4, r5, r6, r7, r8, pc}
.L858:
	.align	2
.L857:
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
	ldr	r0, .L860
	movw	r3, #65535
	movs	r2, #16
	movs	r1, #255
	strh	r3, [r0]	@ movhi
	movs	r3, #0
	strh	r3, [r0, #6]	@ movhi
	adds	r0, r0, #12
	b	ftl_memset
.L861:
	.align	2
.L860:
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
	ldr	r3, .L863
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
.L864:
	.align	2
.L863:
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
.L866:
	ldrh	r1, [r4, #6]
	uxth	r2, r3
	cmp	r1, r2
	bhi	.L870
	ldr	r3, .L885
	movs	r6, #0
	mov	r10, r6
	ldrh	r2, [r3]
	ldrh	r3, [r4]
	strh	r2, [r5, r3, lsl #1]	@ movhi
	mov	r2, r6
	ldrh	fp, [r5]
.L871:
	ldrh	r3, [r4, #10]
	uxth	ip, r6
	cmp	r3, ip
	bhi	.L875
	mov	r0, r10
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L870:
	uxth	r2, r3
	ldr	r1, [r6, r2, lsl #2]
	movs	r2, #0
	ubfx	r1, r1, #10, #16
.L867:
	ldrh	ip, [r4, #10]
	uxth	r0, r2
	cmp	ip, r0
	bhi	.L869
	adds	r3, r3, #1
	b	.L866
.L869:
	uxth	r0, r2
	ldrh	ip, [r7, r0, lsl #1]
	cmp	ip, r1
	bne	.L868
	cbz	r1, .L868
	ldrh	ip, [r5, r0, lsl #1]
	add	ip, ip, #1
	strh	ip, [r5, r0, lsl #1]	@ movhi
.L868:
	adds	r2, r2, #1
	b	.L867
.L875:
	uxth	r1, r6
	ldrh	r3, [r5, r1, lsl #1]
	lsl	r8, r1, #1
	cmp	fp, r3
	bls	.L872
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cbnz	r0, .L873
.L874:
	adds	r6, r6, #1
	b	.L871
.L872:
	cmp	r3, #0
	bne	.L874
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cmp	r0, #0
	beq	.L874
.L876:
	movs	r1, #1
	str	r2, [sp, #4]
	bl	FtlFreeSysBlkQueueIn
	ldr	r2, [sp, #4]
	strh	r2, [r8]	@ movhi
	ldrh	r3, [r4, #8]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	b	.L874
.L873:
	mov	r10, ip
	mov	fp, r3
	cmp	r3, #0
	beq	.L876
	b	.L874
.L886:
	.align	2
.L885:
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
	ldr	r5, .L890
	ldr	r4, .L890+4
	ldr	r2, [r5]
	ldr	r7, .L890+8
	ldr	r6, .L890+12
	ldr	r0, [r4]
	lsls	r2, r2, #1
	ldr	r8, .L890+44
	bl	ftl_memset
	ldrh	r3, [r7]
	movs	r1, #255
	ldrh	r2, [r6]
	ldr	r0, [r8]
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L890+16
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
.L888:
	adds	r2, r2, #12
	adds	r6, r3, r7
	cmp	r2, r1
	bne	.L889
	ldr	r3, .L890+20
	ldr	r2, [r5]
	strh	r0, [r3, #2]	@ movhi
	strh	r2, [r3, #10]	@ movhi
	movw	r2, #61634
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L890+24
	strh	r0, [r3]	@ movhi
	ldrh	r2, [r2]
	strh	r2, [r3, #8]	@ movhi
	ldr	r2, .L890+28
	ldrh	r2, [r2]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, .L890+32
	ldr	r2, [r2]
	str	r2, [r3, #12]
	ldr	r2, .L890+36
	ldr	r2, [r2]
	str	r2, [r3, #16]
	ldr	r2, [r4]
	str	r2, [r3, #20]
	ldr	r2, .L890+40
	ldr	r2, [r2]
	str	r2, [r3, #24]
	pop	{r4, r5, r6, r7, r8, pc}
.L889:
	bic	r3, r3, #3
	str	lr, [r2, #-8]
	add	r3, r3, ip
	strh	r0, [r2, #-12]	@ movhi
	str	r3, [r2, #-4]
	mov	r3, r6
	b	.L888
.L891:
	.align	2
.L890:
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
	ldr	r3, .L893
	movw	r2, #65535
	mov	r1, r4
	ldr	r5, .L893+4
	str	r4, [r3]
	ldr	r3, .L893+8
	strh	r2, [r3]	@ movhi
	mov	r2, #-1
	ldr	r3, .L893+12
	str	r4, [r3]
	ldr	r3, .L893+16
	str	r4, [r3]
	ldr	r3, .L893+20
	str	r2, [r3]
	ldr	r3, .L893+24
	str	r4, [r3]
	ldr	r3, .L893+28
	strh	r4, [r3]	@ movhi
	ldr	r3, .L893+32
	ldrh	r2, [r3]
	ldr	r3, .L893+36
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L893+40
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L893+44
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	mov	r1, r4
	movs	r2, #48
	ldr	r0, .L893+48
	bl	ftl_memset
	mov	r2, #512
	mov	r1, r4
	ldr	r0, .L893+52
	bl	ftl_memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L894:
	.align	2
.L893:
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
	ldr	r3, .L906
	movs	r2, #6
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r1, #0
	ldr	r6, .L906+4
	sub	sp, sp, #24
	movs	r4, #0
	ldrh	r3, [r3]
	mov	r8, r4
	ldr	r0, [r6]
	mov	r5, r4
	mov	r10, r6
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L906+8
	ldr	r2, .L906+12
	ldr	r1, .L906+16
	str	r4, [r3]
	ldr	r3, .L906+20
	strh	r4, [r2]	@ movhi
	strh	r4, [r1]	@ movhi
	str	r4, [r3]
	ldr	r3, .L906+24
	str	r2, [sp, #8]
	str	r4, [r3]
	ldr	r3, .L906+28
	mov	fp, r3
	strh	r4, [r3]	@ movhi
.L896:
	ldr	r3, .L906+32
	sxth	r7, r4
	ldrh	r3, [r3]
	cmp	r7, r3
	bge	.L903
	ldr	r3, .L906+36
	uxth	r1, r4
	str	r1, [sp, #12]
	ldrh	r2, [r3]
	ldr	r3, .L906+40
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r6, r3
	b	.L904
.L898:
	str	r3, [sp, #20]
	ldr	r3, .L906+44
	ldr	r1, [sp, #12]
	str	r2, [sp, #16]
	ldrb	r0, [r3, r0]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #20]
	cbnz	r0, .L897
	ldr	r1, [sp, #4]
	add	r6, r6, r1
	sxth	r6, r6
.L897:
	adds	r3, r3, #1
.L904:
	sxth	r0, r3
	cmp	r0, r2
	blt	.L898
	lsls	r3, r7, #1
	cbz	r6, .L899
	mov	r1, r6
	str	r3, [sp, #4]
	mov	r0, #32768
	bl	__aeabi_idiv
	ldr	r3, [sp, #4]
	sxth	r6, r0
.L900:
	ldr	r2, [r10]
	add	r3, r3, r7
	add	r2, r2, r3, lsl #1
	ldr	r3, .L906+48
	strh	r6, [r2, #4]	@ movhi
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L901
	ldr	r3, .L906+52
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L901
	ldr	r3, .L906+56
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L901
	ldr	r3, .L906+60
	uxth	r0, r4
	ldr	r3, [r3]
	ldrh	r3, [r3, r7, lsl #1]
	cbnz	r3, .L902
	add	r8, r8, #1
	uxth	r8, r8
	bl	INSERT_FREE_LIST
.L901:
	adds	r4, r4, #1
	b	.L896
.L899:
	ldr	r2, .L906+60
	movw	r1, #65535
	ldr	r2, [r2]
	strh	r1, [r2, r7, lsl #1]	@ movhi
	b	.L900
.L902:
	adds	r5, r5, #1
	uxth	r5, r5
	bl	INSERT_DATA_LIST
	b	.L901
.L903:
	ldr	r2, [sp, #8]
	strh	r8, [fp]	@ movhi
	strh	r5, [r2]	@ movhi
	add	r5, r5, r8
	cmp	r3, r5
	bge	.L905
	ldr	r1, .L906+64
	movw	r2, #2645
	ldr	r0, .L906+68
	bl	printf
	ldr	r1, .L906+72
	ldr	r0, .L906+76
	bl	printf
.L905:
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L907:
	.align	2
.L906:
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
	ldr	r2, .L909
	movs	r3, #0
	push	{r4, lr}
	movs	r1, #255
	ldr	r4, .L909+4
	strh	r3, [r2]	@ movhi
	ldr	r2, .L909+8
	strh	r3, [r2]	@ movhi
	ldrh	r2, [r4]
	ldr	r3, .L909+12
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r2, #12
	movs	r1, #255
	muls	r2, r3, r2
	ldr	r3, .L909+16
	ldr	r0, [r3]
	bl	ftl_memset
	pop	{r4, lr}
	b	FtlGcBufInit
.L910:
	.align	2
.L909:
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
	ldr	r0, .L912
	bl	ftl_memset
	movs	r0, #0
	pop	{r3, pc}
.L913:
	.align	2
.L912:
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
	ldr	r1, .L916
	bl	ftl_memcpy
	movs	r0, #0
	pop	{r3, pc}
.L917:
	.align	2
.L916:
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
	ldr	r7, .L926
	ldr	r5, .L926+4
.L921:
	ldrb	r2, [r7, #-1]	@ zero_extendqisi2
	mov	r1, r5
	mov	r0, r7
	lsl	r8, r6, #5
	bl	FlashMemCmp8
	mov	r4, r0
	cbnz	r0, .L919
	ldr	r5, .L926+8
	mov	r3, r4
	ldr	r2, .L926+12
	add	r5, r5, r8
	ldrb	r0, [r5, #22]	@ zero_extendqisi2
	mov	r1, r2
.L920:
	lsls	r6, r3, #5
	ldrb	r6, [r6, r2]	@ zero_extendqisi2
	cmp	r6, r0
	beq	.L923
	adds	r3, r3, #1
	cmp	r3, #4
	bne	.L920
.L923:
	ldr	r6, .L926+16
	add	r1, r1, r3, lsl #5
	movs	r2, #32
	ldr	r0, .L926+20
	bl	ftl_memcpy
	movs	r2, #32
	mov	r1, r5
	mov	r0, r6
	bl	ftl_memcpy
	ldrh	r0, [r6, #10]
	bl	FlashBlockAlignInit
	b	.L918
.L919:
	adds	r6, r6, #1
	adds	r7, r7, #32
	cmp	r6, #81
	bne	.L921
	mov	r4, #-1
.L918:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, pc}
.L927:
	.align	2
.L926:
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
.L929:
	cmp	r3, r2
	bne	.L930
	pop	{r4, pc}
.L930:
	ldr	r4, [r1, r3, lsl #2]
	str	r4, [r0, r3, lsl #2]
	adds	r3, r3, #1
	b	.L929
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
	bne	.L932
	cbz	r3, .L933
	lsls	r1, r3, #30
	bne	.L934
	mov	r2, #256
	mov	r1, r3
	bl	ftl_memcpy32
.L933:
	cbz	r5, .L931
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
.L934:
	mov	r2, #1024
	mov	r1, r3
	bl	ftl_memcpy
	b	.L933
.L932:
	cbz	r3, .L937
	lsls	r2, r3, #30
	bne	.L938
	mov	r1, r0
	mov	r2, #256
	mov	r0, r3
	bl	ftl_memcpy32
.L937:
	cbz	r5, .L931
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
.L931:
	pop	{r4, r5, r6, pc}
.L938:
	mov	r1, r0
	mov	r2, #1024
	mov	r0, r3
	bl	ftl_memcpy
	b	.L937
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
	ldr	r3, .L985
	sub	sp, sp, #96
	mov	r6, r0
	mov	r10, r2
	str	r1, [sp, #12]
	ldr	r5, [r3, r0, lsl #3]
	lsls	r3, r7, #26
	ldr	r4, [sp, #128]
	bne	.L950
	cbnz	r4, .L951
	add	r4, sp, #32
	movs	r2, #64
	movs	r1, #255
	add	r0, sp, #32
	bl	ftl_memset
.L951:
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
	bne	.L975
	ldr	r2, .L985+4
	lsr	r0, r10, #1
	ldr	ip, .L985+12
	ldr	r3, [r2]
	cmp	r3, #25
	ldr	r3, [sp, #12]
	ite	cc
	movcc	r7, #64
	movcs	r7, #128
	mov	r1, r3
.L954:
	cmp	r1, r0
	add	r4, r4, #4
	add	r6, r7, r3
	bcc	.L955
	ldr	r3, .L985+8
	lsr	r4, r10, #2
	ldr	r0, [r2]
	movs	r2, #0
	mov	r8, r2
	ldr	r1, [r3]
.L956:
	cmp	r2, r4
	bcs	.L952
	cbnz	r0, .L962
.L952:
	movs	r3, #0
	str	r3, [r5, #16]
.L963:
	ldr	r3, .L985+8
	ldr	r3, [r3]
	cmp	r3, #5
	bls	.L949
	ldr	r3, [sp, #12]
	cbnz	r3, .L949
	ldr	r3, [r5]
	and	r2, r3, #139264
	cmp	r2, #139264
	ittt	eq
	moveq	r8, #-1
	orreq	r3, r3, #131072
	streq	r3, [r5]
.L949:
	mov	r0, r8
	add	sp, sp, #96
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L955:
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
	b	.L954
.L962:
	add	r3, r2, #8
	ldr	r3, [r5, r3, lsl #2]
	str	r3, [sp, #28]
	ldr	r3, [sp, #28]
	lsls	r6, r3, #29
	bmi	.L978
	ldr	r3, [sp, #28]
	ubfx	r3, r3, #15, #1
	cmp	r3, #0
	bne	.L978
	cmp	r1, #5
	bls	.L958
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
.L984:
	orr	r3, r3, r6, lsl #5
.L960:
	cmp	r8, r3
	it	cc
	movcc	r8, r3
.L957:
	adds	r2, r2, #1
	b	.L956
.L958:
	cmp	r1, #3
	bls	.L960
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
	b	.L984
.L978:
	mov	r8, #-1
	b	.L957
.L975:
	mov	r8, #0
	b	.L952
.L950:
	ldr	r3, [sp, #12]
	cmp	r3, #1
	bne	.L964
	cmp	r4, #0
	mov	r8, #0
	ite	ne
	movne	r3, #4
	moveq	r3, #0
	str	r3, [sp, #16]
.L965:
	cmp	r8, r10
	bcc	.L967
	mov	r8, #0
	b	.L963
.L967:
	and	fp, r8, #3
	cbz	r7, .L980
	add	r3, r7, r8, lsl #9
.L966:
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
	b	.L965
.L980:
	mov	r3, r7
	b	.L966
.L964:
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
.L968:
	cmp	r4, r10
	bcs	.L963
	mov	r0, r6
	adds	r4, r4, #2
	bl	NandcXferComp
	ldr	r3, [r5, #32]
	cmp	r10, r4
	str	r3, [sp, #28]
	bls	.L969
	movs	r3, #0
	movs	r2, #2
	str	r3, [sp, #4]
	movs	r1, #0
	str	r3, [sp]
	mov	r0, r6
	and	r3, r4, #3
	bl	NandcXferStart
.L969:
	ldr	r3, [sp, #28]
	lsls	r3, r3, #29
	bmi	.L981
	ldr	r3, [sp, #28]
	ldr	r2, [sp, #28]
	ubfx	r3, r3, #3, #5
	ubfx	r2, r2, #27, #1
	orr	r3, r3, r2, lsl #5
	cmp	r8, r3
	it	cc
	movcc	r8, r3
.L970:
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
	b	.L968
.L981:
	mov	r8, #-1
	b	.L970
.L986:
	.align	2
.L985:
	.word	.LANCHOR6
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
	ldr	r3, .L989
	mov	r6, r1
	mov	r7, r2
	mov	r4, r0
	ldrb	r5, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L988
	ldr	r3, .L989+4
	ldr	r2, .L989+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r0, [r2]
	muls	r0, r3, r0
	cmp	r0, r1
	it	hi
	movhi	r5, #4
.L988:
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
.L990:
	.align	2
.L989:
	.word	.LANCHOR31
	.word	.LANCHOR2
	.word	.LANCHOR3
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
	ldr	r3, .L1016
	sub	sp, sp, #24
	str	r0, [sp, #8]
	ldr	r3, [r3]
	str	r1, [sp, #12]
	str	r2, [sp, #4]
	ldr	r3, [r3, #304]
	str	r3, [sp, #20]
	ldr	r3, .L1016+4
	ldr	r3, [r3]
	cmp	r3, #8
	ldr	r3, [sp, #56]
	ite	cc
	movcc	fp, #6
	movcs	fp, #12
	cmp	r3, #0
	beq	.L1005
	movs	r0, #1
	ldr	r4, .L1016+8
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
	bne	.L994
.L1003:
	mov	r6, #-1
.L991:
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L994:
	mov	r2, r6
	ldr	r1, [sp, #12]
	ldr	r0, .L1016+12
	bl	printf
	ldr	r2, .L1016+16
	ldr	r3, [r2]
	adds	r3, r3, #1
	cmp	r3, #2048
	bcs	.L996
	str	r3, [r2]
	b	.L991
.L996:
	movs	r7, #0
	str	r7, [r2]
	str	r7, [sp, #4]
.L993:
	mov	r10, #0
	mov	r8, #-1
	mov	r5, r10
	mov	r4, r10
	str	r10, [sp, #16]
.L1001:
	uxtb	r0, fp
	bl	NandcSetDdrPara
	mov	r3, r7
	ldr	r2, [sp, #4]
	ldr	r1, [sp, #12]
	ldr	r0, [sp, #8]
	bl	FlashReadRawPage
	adds	r3, r6, #1
	cmp	r0, r3
	bhi	.L997
	cmp	r0, #2
	bhi	.L1007
	adds	r4, r4, #1
	cmp	r4, #9
	bls	.L1007
	mov	r3, r5
	mov	r6, r0
	sub	r5, fp, r4
	mov	r8, #0
.L999:
	ldr	r2, [sp, #16]
	cmp	r4, r2
	it	ls
	movls	r5, r3
.L1000:
	cbz	r5, .L1002
	mov	r1, r5
	ldr	r0, .L1016+20
	bl	printf
	uxtb	r0, r5
	bl	NandcSetDdrPara
.L1002:
	cmp	r8, #0
	beq	.L991
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #8]
	ldr	r0, .L1016+24
	bl	printf
	ldr	r3, [sp, #56]
	cmp	r3, #0
	beq	.L1003
	ldr	r3, [sp, #20]
	ubfx	r0, r3, #8, #8
	bl	NandcSetDdrPara
	b	.L991
.L1005:
	mov	r6, #1024
	b	.L993
.L997:
	ldr	r3, [sp, #16]
	cmp	r4, r3
	bls	.L1008
	cmp	r4, #7
	sub	r5, r10, r4
	bhi	.L1000
	str	r4, [sp, #16]
.L1008:
	movs	r4, #0
	b	.L998
.L1007:
	mov	r8, #0
	mov	r10, fp
	mov	r6, r0
	mov	r7, r8
	str	r8, [sp, #4]
.L998:
	add	fp, fp, #2
	cmp	fp, #69
	bls	.L1001
	mov	r3, r5
	mov	r5, r10
	b	.L999
.L1017:
	.align	2
.L1016:
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
	bne	.L1019
	ldr	r10, .L1037+20
	ldrb	fp, [r10]	@ zero_extendqisi2
	cmp	fp, #0
	bne	.L1020
.L1022:
	ldr	r3, .L1037
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1019
	ldr	r3, .L1037+4
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
	beq	.L1023
	ldr	r3, .L1037+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3, lsr #1
	bls	.L1019
.L1023:
	ubfx	r0, r10, #8, #8
	bl	NandcSetDdrPara
	b	.L1019
.L1020:
	movs	r3, #0
	mov	r2, r7
	strb	r3, [r10]
	mov	r1, r6
	mov	r3, r8
	mov	r0, r5
	bl	FlashReadRawPage
	adds	r3, r0, #1
	strb	fp, [r10]
	beq	.L1022
	mov	r4, r0
.L1019:
	ldr	r10, .L1037+24
	ldr	fp, [r10]
	cmp	fp, #0
	beq	.L1018
	adds	r2, r4, #1
	bne	.L1018
	mov	r3, r8
	mov	r2, r7
	mov	r1, r6
	mov	r0, r5
	blx	fp
	mov	r3, r6
	mov	r4, r0
	mov	r1, r0
	mov	r2, r5
	ldr	r0, .L1037+12
	bl	printf
	adds	r3, r4, #1
	bne	.L1018
	ldr	r3, .L1037+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1018
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
.L1018:
	mov	r0, r4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1038:
	.align	2
.L1037:
	.word	.LANCHOR30
	.word	.LANCHOR19
	.word	.LANCHOR33
	.word	.LC12
	.word	.LANCHOR15
	.word	.LANCHOR5
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
	ldr	r4, .L1050
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
	ldr	r5, .L1050+4
	bl	FlashReadRawPage
	adds	r0, r0, #1
	beq	.L1040
	cmp	r8, #-1
	bne	.L1041
.L1040:
	ldrb	r3, [r4]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L1041
	movs	r0, #1
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	movs	r3, #0
.L1049:
	movs	r0, #0
	strb	r3, [r5]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1041:
	movs	r3, #1
	b	.L1049
.L1051:
	.align	2
.L1050:
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
	ldr	fp, .L1066+32
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
	ldr	r8, .L1066+36
	ldr	r10, .L1066+40
	str	r3, [sp, #4]
	ldr	r5, .L1066
	ldr	r3, [r8]
	str	r4, [r10]
	str	r3, [r5]
	bl	flash_enter_slc_mode
	str	r10, [sp, #12]
	mov	r10, r8
.L1053:
	mov	r8, #0
	adds	r3, r4, #1
	str	r3, [sp, #8]
.L1055:
	add	r3, sp, #20
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r3, #0
	ldr	r2, [r10]
	mov	r1, r4
	mov	r0, r3
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L1054
	movs	r3, #0
	ldr	r2, [r10]
	ldr	r1, [sp, #8]
	mov	r0, r3
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L1054
	add	r8, r8, #1
	cmp	r8, #4
	bne	.L1055
.L1056:
	ldr	r3, [sp, #4]
	subs	r7, r7, #1
	add	r4, r4, r3
	bne	.L1053
	mov	r0, r7
	b	.L1065
.L1057:
	movw	r1, #2036
	add	r0, r8, #12
	bl	js_hash
	ldr	r3, [r8, #8]
	cmp	r3, r0
	bne	.L1063
	ldr	r6, .L1066+4
	movs	r2, #32
	add	r1, r8, #160
	mov	r0, r6
	bl	ftl_memcpy
	ldr	r1, [r5]
	movs	r2, #32
	ldr	r0, .L1066+8
	adds	r1, r1, #192
	bl	ftl_memcpy
	ldr	r1, [r5]
	mov	r2, #852
	ldr	r0, .L1066+12
	adds	r1, r1, #224
	bl	ftl_memcpy
	ldrh	r0, [r6, #10]
	bl	FlashBlockAlignInit
	ldr	r6, [r5]
	mov	r0, r4
	ldr	r3, .L1066+16
	ldr	r1, [fp]
	ldr	r2, [r6, #1076]
	strb	r2, [r3]
	ldr	r3, [sp, #12]
	str	r4, [r3]
	bl	__aeabi_uidiv
	ldr	r3, .L1066+20
	adds	r0, r0, #1
	cmp	r0, #1
	itte	ls
	movls	r2, #2
	strls	r2, [r3]
	strhi	r0, [r3]
	ldrh	r2, [r6, #14]
	movs	r6, #0
	ldr	r3, .L1066+24
	strb	r2, [r3]
	b	.L1056
.L1063:
	mov	r6, #-1
	b	.L1056
.L1054:
	ldr	r8, [r5]
	ldr	r2, .L1066+28
	ldr	r3, [r8]
	cmp	r3, r2
	bne	.L1056
	cmp	r6, #0
	bne	.L1057
	ldr	r1, [fp]
	mov	r0, r4
	bl	__aeabi_uidiv
	ldr	r3, .L1066+20
	adds	r0, r0, #1
	str	r0, [r3]
	mov	r0, r6
.L1065:
	bl	flash_exit_slc_mode
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1067:
	.align	2
.L1066:
	.word	.LANCHOR146
	.word	.LANCHOR31
	.word	.LANCHOR7
	.word	.LANCHOR20
	.word	.LANCHOR30
	.word	.LANCHOR149
	.word	.LANCHOR150
	.word	1312902724
	.word	.LANCHOR3
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
	ldr	r3, .L1095
	ldr	r2, .L1095+4
	ldr	r4, [r3, r6, lsl #3]
	add	r3, r3, r6, lsl #3
	str	r2, [sp, #16]
	ldrb	r7, [r3, #4]	@ zero_extendqisi2
	ldrb	r3, [r2]	@ zero_extendqisi2
	add	r5, r7, #8
	subs	r3, r3, #67
	add	r5, r4, r5, lsl #8
	cmp	r3, #1
	bls	.L1085
	ldr	r3, .L1095+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1086
	movs	r0, #0
	bl	NandcSetDdrMode
	movs	r3, #1
.L1086:
	str	r3, [sp, #8]
	add	r3, r4, r7, lsl #8
	movs	r2, #92
	str	r2, [r3, #2056]
	movs	r2, #197
	str	r2, [r3, #2056]
.L1069:
	mov	r8, #1
	mov	r3, #-1
	str	r3, [sp, #4]
.L1071:
	ldr	r3, .L1095+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r8, r3
	bcc	.L1080
	ldr	r10, [sp, #4]
.L1079:
	ldr	r3, [sp, #16]
	movs	r1, #0
	mov	r0, r5
	ldrb	r2, [r3]	@ zero_extendqisi2
	subs	r2, r2, #67
	cmp	r2, #1
	bhi	.L1081
	bl	SandiskSetRRPara
.L1082:
	add	r4, r4, r7, lsl #8
	movs	r2, #255
	str	r2, [r4, #2056]
	ldr	r2, .L1095+16
	ldrb	r2, [r2]	@ zero_extendqisi2
	add	r2, r2, r2, lsl #1
	cmp	r10, r2, asr #2
	bcc	.L1083
	cmp	r10, #-1
	it	ne
	movne	r10, #256
.L1083:
	mov	r0, r6
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #8]
	cbz	r3, .L1068
	movs	r0, #4
	bl	NandcSetDdrMode
.L1068:
	mov	r0, r10
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1085:
	movs	r3, #0
	str	r3, [sp, #8]
	b	.L1069
.L1080:
	ldr	r3, [sp, #16]
	mov	r0, r5
	uxtb	r1, r8
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L1072
	bl	SandiskSetRRPara
.L1073:
	ldr	r3, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L1074
	ldr	r3, .L1095+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #3
	cmp	r8, r3
	ittt	eq
	addeq	r3, r4, r7, lsl #8
	moveq	r2, #179
	streq	r2, [r3, #2056]
.L1074:
	add	r3, r4, r7, lsl #8
	movs	r2, #38
	str	r2, [r3, #2056]
	movs	r2, #93
	str	r2, [r3, #2056]
	ldr	r3, [sp, #8]
	cbz	r3, .L1075
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
.L1076:
	cmp	r10, #-1
	beq	.L1077
	ldr	r2, .L1095+16
	ldr	r3, [sp, #4]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r3, #-1
	it	eq
	moveq	r3, r10
	str	r3, [sp, #4]
	add	r2, r2, r2, lsl #1
	cmp	r10, r2, asr #2
	bcc	.L1079
	mov	fp, #0
	str	fp, [sp, #12]
.L1077:
	add	r8, r8, #1
	b	.L1071
.L1072:
	bl	ToshibaSetRRPara
	b	.L1073
.L1075:
	mov	r3, fp
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #20]
	mov	r0, r6
	bl	FlashReadRawPage
	mov	r10, r0
	b	.L1076
.L1081:
	bl	ToshibaSetRRPara
	b	.L1082
.L1096:
	.align	2
.L1095:
	.word	.LANCHOR6
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
	ldr	r2, .L1110
	mov	r4, #-1
	add	r3, r2, r7, lsl #3
	ldrb	r5, [r3, #4]	@ zero_extendqisi2
	add	r3, r5, #8
	ldr	r5, [r2, r7, lsl #3]
	add	r5, r5, r3, lsl #8
.L1098:
	ldr	r3, .L1110+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r6, r3
	bcc	.L1102
.L1101:
	movs	r1, #0
	mov	r0, r5
	bl	SamsungSetRRPara
	ldr	r3, .L1110+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L1097
	adds	r3, r4, #1
	it	ne
	movne	r4, #256
.L1097:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1102:
	uxtb	r1, r6
	mov	r0, r5
	bl	SamsungSetRRPara
	mov	r2, r10
	mov	r3, r8
	mov	r1, fp
	mov	r0, r7
	bl	FlashReadRawPage
	adds	r2, r0, #1
	beq	.L1099
	ldr	r3, .L1110+8
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1105
	mov	r8, #0
	mov	r10, r8
.L1099:
	adds	r6, r6, #1
	b	.L1098
.L1105:
	mov	r4, r0
	b	.L1101
.L1111:
	.align	2
.L1110:
	.word	.LANCHOR6
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
	ldr	r3, .L1137
	sub	sp, sp, #40
	mov	r5, r0
	str	r2, [sp, #16]
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L1137+4
	str	r1, [sp, #28]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1113
	add	r2, r2, r2, lsl #1
	asrs	r3, r2, #2
.L1136:
.L1114:
	mov	r8, #0
	str	r3, [sp, #12]
	mov	r6, r8
.L1124:
	mov	r0, r5
	mov	r10, #0
	bl	NandcWaitFlashReady
	ldr	r3, .L1137+8
	mov	r4, #-1
	ldr	r2, [r3, r5, lsl #3]
	add	r3, r3, r5, lsl #3
	ldrb	fp, [r3, #4]	@ zero_extendqisi2
	str	r2, [sp, #24]
	lsl	r3, fp, #8
	str	r3, [sp, #32]
.L1115:
	ldr	r3, .L1137+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r10, r3
	bcc	.L1119
.L1118:
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
	bcc	.L1120
	adds	r1, r4, #1
	mov	r3, r10
	it	ne
	movne	r4, #256
	ldr	r2, [sp, #28]
	str	r4, [sp]
	mov	r1, r10
	ldr	r0, .L1137+16
	bl	printf
	cmp	r8, #0
	bne	.L1122
	ldr	r3, .L1137+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1112
	adds	r2, r4, #1
	bne	.L1112
	movs	r1, #3
	mov	r0, r5
	bl	micron_auto_read_calibration_config
	mov	r8, #1
	b	.L1124
.L1113:
	ldr	r3, .L1137+20
	smull	r2, r3, r2, r3
	b	.L1136
.L1119:
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
	beq	.L1116
	ldr	r3, [sp, #12]
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	cmp	r0, r3
	bcc	.L1126
	movs	r7, #0
	str	r7, [sp, #16]
.L1116:
	ldr	r10, [sp, #20]
	b	.L1115
.L1126:
	movs	r7, #0
	mov	r4, r0
	str	r7, [sp, #16]
	b	.L1118
.L1122:
	movs	r1, #0
	mov	r0, r5
	bl	micron_auto_read_calibration_config
	adds	r3, r4, #1
	it	ne
	movne	r4, #256
.L1112:
	mov	r0, r4
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1120:
	cmp	r8, #0
	beq	.L1112
	movs	r1, #0
	mov	r0, r5
	bl	micron_auto_read_calibration_config
	mov	r4, #256
	b	.L1112
.L1138:
	.align	2
.L1137:
	.word	.LANCHOR33
	.word	.LANCHOR15
	.word	.LANCHOR6
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
	ldr	r4, .L1156
	mov	r8, #0
	mov	r6, #-1
	mov	fp, r2
	mov	r7, r0
	str	r1, [sp, #4]
	ldrb	r3, [r4, #2]	@ zero_extendqisi2
	adds	r2, r4, r0
	ldrb	r5, [r2, #12]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L1156+4
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #7
	cmp	r3, #1
	it	ls
	ldrbls	r5, [r2, #20]	@ zero_extendqisi2
	bl	NandcWaitFlashReady
.L1141:
	ldr	r3, [sp]
	cmp	r8, r3
	bcc	.L1146
.L1145:
	ldr	r3, .L1156+4
	add	r4, r4, r7
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #7
	cmp	r3, #1
	ldr	r3, .L1156+8
	ite	ls
	strbls	r5, [r4, #20]
	strbhi	r5, [r4, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r6, r3, asr #2
	bcc	.L1139
	adds	r3, r6, #1
	it	ne
	movne	r6, #256
.L1139:
	mov	r0, r6
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1146:
	ldr	r3, [sp]
	adds	r5, r5, #1
	uxtb	r5, r5
	ldr	r2, .L1156+12
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
	beq	.L1143
	ldr	r3, .L1156+8
	cmp	r6, #-1
	it	eq
	moveq	r6, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1150
	mov	r10, #0
	mov	fp, r10
.L1143:
	add	r8, r8, #1
	b	.L1141
.L1150:
	mov	r6, r0
	b	.L1145
.L1157:
	.align	2
.L1156:
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
	ldr	r3, .L1161
	mov	r5, r1
	mov	r7, r2
	mov	r4, r0
	ldrb	r6, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L1159
	ldr	r3, .L1161+4
	ldr	r2, .L1161+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r1, [r2]
	muls	r1, r3, r1
	cmp	r1, r5
	bls	.L1159
	ldr	r3, .L1161+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1160
	subs	r6, r6, #2
.L1159:
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
.L1160:
	movs	r6, #4
	b	.L1159
.L1162:
	.align	2
.L1161:
	.word	.LANCHOR31
	.word	.LANCHOR2
	.word	.LANCHOR3
	.word	.LANCHOR1
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
	ldr	r7, .L1172
	ldr	r4, .L1172+4
	ldr	r3, [r7]
	ldr	r10, .L1172+56
	ldr	fp, .L1172+60
	str	r3, [r4]
	ldr	r3, .L1172+8
	ldr	r8, .L1172+64
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	FlashBchSel
	mov	r2, #2048
	movs	r1, #0
	ldr	r0, [r7]
	bl	ftl_memset
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r3, .L1172+12
	ldr	r1, .L1172+16
	str	r10, [r0]
	adds	r0, r0, #16
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r0, #-4]	@ movhi
	ldr	r3, .L1172+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r0, #-2]	@ movhi
	ldr	r3, .L1172+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r0, #1060]
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #8
	ldr	r1, .L1172+28
	adds	r0, r0, #80
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1172+32
	adds	r0, r0, #96
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1172+36
	adds	r0, r0, #160
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1172+40
	adds	r0, r0, #192
	bl	ftl_memcpy
	ldr	r0, [r4]
	mov	r2, #852
	ldr	r1, .L1172+44
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
.L1166:
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
	beq	.L1164
	ldr	r3, [r4]
	ldr	r1, [r3]
	cmp	r1, r10
	bne	.L1164
	add	r0, r3, #12
	movw	r1, #2036
	str	r2, [sp, #4]
	str	r3, [sp]
	bl	js_hash
	ldr	r3, [sp]
	ldr	r2, [sp, #4]
	ldr	r3, [r3, #8]
	cmp	r3, r0
	bne	.L1164
	ldr	r3, .L1172+48
	cmp	r5, #1
	str	r2, [r3]
	ldr	r3, [r8]
	mul	r6, r6, r3
	ldr	r3, .L1172+52
	str	r6, [r3]
	beq	.L1167
	movs	r5, #1
.L1164:
	cmp	r2, #4
	mov	r6, r2
	bne	.L1166
.L1165:
	movs	r0, #0
	bl	flash_exit_slc_mode
	clz	r0, r5
	lsrs	r0, r0, #5
	negs	r0, r0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1167:
	movs	r5, #2
	b	.L1165
.L1173:
	.align	2
.L1172:
	.word	.LANCHOR147
	.word	.LANCHOR146
	.word	.LANCHOR152
	.word	.LANCHOR25
	.word	.LANCHOR22
	.word	.LANCHOR2
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
	.word	.LANCHOR3
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
	ldr	r3, .L1192
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	ldr	r3, .L1192+4
	ldr	r2, [r3]
	str	r3, [sp, #4]
	cbz	r2, .L1175
	movs	r0, #0
	bl	flash_enter_slc_mode
.L1175:
	mov	r7, #-1
	movs	r4, #2
	mov	r2, #2048
	movs	r1, #0
	mov	r0, r10
	bl	ftl_memset
.L1176:
	ldr	r3, .L1192+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L1181
.L1180:
	ldr	r0, [sp]
	bl	FlashBchSel
	ldr	r3, [sp, #4]
	ldr	r3, [r3]
	cbz	r3, .L1174
	movs	r0, #0
	bl	flash_exit_slc_mode
.L1174:
	mov	r0, r7
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1181:
	ldr	r5, .L1192+12
	movs	r6, #0
	ldr	fp, .L1192+28
.L1178:
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
	bne	.L1177
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L1178
.L1179:
	adds	r4, r4, #1
	b	.L1176
.L1184:
	movs	r7, #0
	b	.L1180
.L1177:
	ldr	r3, [r5]
	ldr	r2, [r3]
	ldr	r3, .L1192+16
	cmp	r2, r3
	bne	.L1179
	mov	r1, r8
	ldr	r0, .L1192+20
	bl	printf
	mov	r2, #2048
	ldr	r1, [r5]
	mov	r0, r10
	bl	ftl_memcpy
	ldr	r3, [r5]
	ldr	r2, .L1192+8
	ldr	r3, [r3, #512]
	strb	r3, [r2]
	ldr	r3, .L1192+24
	ldr	r2, [r3]
	cmp	r4, r2
	bcs	.L1184
	str	r4, [r3]
	movs	r7, #0
	bl	FlashSavePhyInfo
	b	.L1179
.L1193:
	.align	2
.L1192:
	.word	.LANCHOR33
	.word	.LANCHOR29
	.word	.LANCHOR2
	.word	.LANCHOR147
	.word	-52655045
	.word	.LC14
	.word	.LANCHOR149
	.word	.LANCHOR3
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
	ldr	r3, .L1210
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	mov	r8, r1
	mov	r4, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1195
	ldr	r3, .L1210+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L1194
.L1195:
	ldr	r5, .L1210+8
	ldr	r3, [r5]
	ldrb	r6, [r3, #19]	@ zero_extendqisi2
	subs	r3, r6, #5
	uxtb	r3, r3
	cmp	r3, #30
	bhi	.L1196
	ldr	r2, .L1210+12
	lsr	r3, r2, r3
	lsls	r3, r3, #31
	bmi	.L1198
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1201:
	ldrh	r2, [fp, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1194
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
.L1202:
	ldr	r3, [r5]
	ldrh	r3, [r3, #10]
	cmp	r3, r4
	bhi	.L1201
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1196:
	cmp	r6, #68
	bne	.L1194
.L1198:
	ldr	fp, .L1210+16
	ldr	r10, .L1210+20
	b	.L1202
.L1194:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1211:
	.align	2
.L1210:
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
	bls	.L1213
	cmp	r0, #576
	bcs	.L1214
	ldr	r2, .L1265
	cmp	r0, #64
	mov	r4, #1
	str	r4, [r2]
	bhi	.L1215
	rsb	r0, r0, #64
	subs	r2, r3, r0
	add	r1, r1, r0, lsl #9
	ldr	r0, .L1265+4
	lsls	r2, r2, #9
.L1264:
	bl	ftl_memcpy
.L1253:
	movs	r0, #0
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1215:
	rsb	r2, r0, #576
	subs	r0, r0, #64
	cmp	r2, r3
	it	cs
	movcs	r2, r3
	ldr	r3, .L1265+4
	lsls	r2, r2, #9
	add	r0, r3, r0, lsl #9
	b	.L1264
.L1213:
	cmp	r0, #576
	bcc	.L1253
.L1214:
	ldr	r3, .L1265
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L1253
	ldr	r3, .L1265+8
	ldr	r2, [r3]
	ldrb	r3, [r2, #9]	@ zero_extendqisi2
	ldrh	r2, [r2, #10]
	smulbb	r3, r3, r2
	uxth	r3, r3
	mov	r1, r3
	addw	r0, r3, #511
	str	r3, [sp, #8]
	bl	__aeabi_uidiv
	ldr	r1, .L1265+4
	movs	r3, #0
	str	r0, [sp, #20]
	movw	r2, #65535
	mov	r0, r1
.L1219:
	ldr	r4, [r1, r2, lsl #2]
	cbnz	r4, .L1217
	ldr	r4, [r1, r3, lsl #2]
	adds	r3, r3, #1
	cmp	r3, #4096
	it	hi
	movhi	r3, #0
	str	r4, [r1, r2, lsl #2]
	subs	r2, r2, #1
	cmp	r2, #4096
	bne	.L1219
.L1217:
	ldr	r1, [r0, r2, lsl #2]
	mov	r3, #512
	ldr	r0, .L1265+12
	bl	printf
	ldr	r3, .L1265+16
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
.L1220:
	ldr	r3, [sp, #16]
	cmp	r3, #15
	bls	.L1237
	ldr	r3, [sp, #12]
	cbnz	r3, .L1239
	mov	r1, r3
	ldr	r0, .L1265+20
	bl	printf
.L1239:
	ldr	r3, .L1265
	movs	r2, #0
	str	r2, [r3]
	b	.L1253
.L1266:
	.align	2
.L1265:
	.word	.LANCHOR154
	.word	idb_buf
	.word	.LANCHOR18
	.word	.LC15
	.word	.LANCHOR149
	.word	.LC17
.L1237:
	mov	r2, #512
	movs	r1, #0
	ldr	r0, .L1267
	bl	memset
	ldr	r3, .L1267+4
	mov	r0, r4
	ldr	r3, [r3]
	ldrb	fp, [r3, #9]	@ zero_extendqisi2
	ldrh	r5, [r3, #10]
	bl	FW_FlashBlockErase.constprop.41
	smulbb	r5, r5, fp
	uxth	r5, r5
	cmp	r5, #512
	bcs	.L1221
	adds	r0, r5, r4
	bl	FW_FlashBlockErase.constprop.41
.L1221:
	ldr	r7, .L1267+8
	mov	r1, r5
	ldr	r10, .L1267+36
	mov	r0, r4
	bl	__aeabi_uidivmod
	mov	r6, r1
	subs	r3, r4, r1
	str	r3, [sp, #24]
.L1225:
	lsrs	r2, r6, #2
	beq	.L1222
	ldr	r0, .L1267+12
	adds	r1, r2, #1
	ldr	r3, .L1267+16
	ldrb	r0, [r0]	@ zero_extendqisi2
	ldrh	r3, [r3, r1, lsl #1]
	cbz	r0, .L1223
	ldr	r0, [r10]
	ldr	r5, .L1267+20
	cmp	r0, r5
	it	eq
	moveq	r3, r1
.L1223:
	add	r3, r3, #1073741824
	subs	r3, r3, #1
	lsls	r3, r3, #2
	str	r3, [sp, #40]
.L1222:
	movw	r3, #61424
	str	r3, [sp, #44]
	ldr	r3, .L1267+16
	ldrh	r5, [r3, r2, lsl #1]
	ldr	r3, .L1267+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1224
	ldr	r3, [r10]
	ldr	r1, .L1267+20
	cmp	r3, r1
	it	eq
	moveq	r5, r2
.L1224:
	ldr	r3, [sp, #24]
	adds	r6, r6, #4
	ldr	r2, .L1267+24
	ldr	r8, .L1267+4
	mla	r3, r5, fp, r3
	adds	r5, r5, #1
	uxth	r5, r5
	str	r3, [sp, #32]
	ldrb	r3, [r2]	@ zero_extendqisi2
	ldr	r2, .L1267+28
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
	ldr	r3, .L1267+32
	cmp	r7, r3
	bne	.L1225
	ldr	r3, [r8]
	mov	r0, r4
	ldr	r7, .L1267
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
.L1226:
	cmp	r6, #512
	bcs	.L1233
	ldr	r1, .L1267+12
	rsb	r3, r5, #4
	uxth	r3, r3
	ldr	r2, .L1267+16
	ldrb	r1, [r1]	@ zero_extendqisi2
	str	r3, [sp, #24]
	add	r3, r10, r6
	lsrs	r3, r3, #2
	ldrh	r2, [r2, r3, lsl #1]
	cbz	r1, .L1227
	ldr	r1, .L1267+36
	ldr	r0, .L1267+20
	ldr	r1, [r1]
	cmp	r1, r0
	it	eq
	moveq	r2, r3
.L1227:
	ldr	r3, [sp, #28]
	add	r5, r5, r3
	ldr	r3, .L1267+24
	mla	r5, r2, r8, r5
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #32]
	ldr	r3, .L1267+4
	ldr	r3, [r3]
	ldrb	fp, [r3, #9]	@ zero_extendqisi2
	ldr	r3, .L1267+40
	ldrh	r2, [r3, #26]
	ldr	r3, .L1267+44
	ldr	r3, [r3]
	muls	r3, r2, r3
	mul	r3, fp, r3
	cmp	r5, r3
	bcs	.L1228
	ldr	r3, .L1267+28
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	FlashBchSel
.L1228:
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
	bne	.L1229
	ldr	r3, .L1267+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #40
	beq	.L1229
	movs	r0, #40
	bl	FlashBchSel
	add	r3, sp, #40
	mov	r2, r7
	mov	r1, fp
	movs	r0, #0
	bl	FlashReadPage
	mov	r5, r0
.L1229:
	movs	r0, #0
	bl	flash_boot_exit_slc_mode
	ldr	r0, [sp, #32]
	bl	FlashBchSel
	adds	r5, r5, #1
	mov	r5, #-1
	it	ne
	movne	r5, #0
	cbz	r5, .L1230
.L1233:
	ldr	r3, .L1267+8
	movs	r5, #0
	ldr	r6, .L1267
.L1231:
	mov	r7, r3
	ldr	r1, [r6, r5, lsl #2]
	ldr	r2, [r7]
	adds	r3, r3, #4
	cmp	r1, r2
	beq	.L1234
	mov	r2, #512
	movs	r1, #0
	ldr	r0, .L1267
	bl	memset
	str	r5, [sp]
	mov	r1, r4
	ldr	r3, [r7]
	ldr	r2, [r6, r5, lsl #2]
	ldr	r0, .L1267+48
	bl	printf
	mov	r0, r4
	bl	FW_FlashBlockErase.constprop.41
	ldr	r3, [sp, #20]
	cmp	r3, #1
	bls	.L1235
	ldr	r3, [sp, #8]
	adds	r0, r3, r4
	bl	FW_FlashBlockErase.constprop.41
.L1235:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #20]
	add	r3, r3, r2
	str	r3, [sp, #16]
	ldr	r3, [sp, #36]
	add	r4, r4, r3
	b	.L1220
.L1230:
	ldr	r3, [sp, #24]
	add	r6, r6, r3
	add	r7, r7, r3, lsl #9
	uxth	r6, r6
	b	.L1226
.L1234:
	adds	r5, r5, #1
	cmp	r5, #65536
	bne	.L1231
	ldr	r3, [sp, #12]
	adds	r3, r3, #1
	cmp	r3, #5
	str	r3, [sp, #12]
	bls	.L1235
	b	.L1239
.L1268:
	.align	2
.L1267:
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
	.word	.LANCHOR3
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
	ldr	r0, .L1271
	bx	lr
.L1272:
	.align	2
.L1271:
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
	ldr	r3, .L1276
	movs	r4, #0
	ldr	r5, .L1276+4
	str	r2, [r3, #12]
	movs	r2, #2
	str	r2, [r3, #20]
	movs	r2, #3
	stm	r3, {r0, r4}
	str	r0, [r3, #8]
	str	r0, [r3, #16]
	str	r2, [r3, #28]
	str	r0, [r3, #24]
	ldr	r3, .L1276+8
	ldr	r2, .L1276+12
	str	r0, [r3]
	ldr	r3, [r0]
	and	r3, r3, #253952
	ubfx	r1, r3, #13, #1
	bfi	r3, r4, #13, #1
	str	r1, [r2]
	orr	r3, r3, #256
	ldr	r2, [r0, #352]
	ldr	r1, .L1276+16
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
	ldr	r3, .L1276+20
	str	r3, [r0, #304]
	mov	r0, #36864
	bl	ftl_malloc
	ldr	r3, .L1276+24
	str	r0, [r3]
	ldr	r3, .L1276+28
	str	r0, [r3]
	add	r0, r0, #32768
	str	r0, [r3, #4]
	str	r4, [r3, #24]
	ldr	r3, .L1276+32
	str	r4, [r3]
	pop	{r3, r4, r5, pc}
.L1277:
	.align	2
.L1276:
	.word	.LANCHOR6
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
	ldr	r3, .L1283
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r2, .L1283+4
	movs	r6, #12
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1283+8
	ldr	r5, .L1283+12
	ldr	r10, .L1283+304
	str	r4, [r3]
	ldr	r3, .L1283+16
	ldr	r8, .L1283+308
	ldr	fp, .L1283+312
	str	r4, [r3]
	ldr	r3, .L1283+20
	str	r4, [r3]
	ldr	r3, .L1283+24
	str	r4, [r3]
	ldr	r3, .L1283+28
	str	r4, [r3]
	ldr	r3, .L1283+32
	str	r4, [r3]
	ldr	r3, .L1283+36
	str	r4, [r3]
	ldr	r3, .L1283+40
	str	r4, [r3]
	ldr	r3, .L1283+44
	str	r4, [r3]
	ldr	r3, .L1283+48
	str	r4, [r3]
	ldr	r3, .L1283+52
	str	r4, [r3]
	ldr	r3, .L1283+56
	str	r4, [r3]
	ldr	r3, .L1283+60
	str	r4, [r3]
	ldr	r3, .L1283+64
	str	r4, [r3]
	ldr	r3, .L1283+68
	str	r4, [r3]
	ldr	r3, .L1283+72
	str	r4, [r3]
	ldr	r3, .L1283+76
	str	r4, [r3]
	movw	r3, #65535
	str	r3, [r2]
	ldr	r2, .L1283+80
	str	r4, [r2]
	ldr	r2, .L1283+84
	str	r4, [r2]
	ldr	r2, .L1283+88
	str	r4, [r2]
	ldr	r2, .L1283+92
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1283+96
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1283+100
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1283+104
	strh	r3, [r2]	@ movhi
	movs	r2, #32
	ldr	r3, .L1283+108
	strh	r2, [r3]	@ movhi
	movs	r2, #128
	ldr	r3, .L1283+112
	strh	r2, [r3]	@ movhi
	ldr	r3, .L1283+116
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1283+120
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1283+124
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1283+128
	strh	r4, [r3]	@ movhi
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1283+132
	str	r0, [r3]
	ldrh	r0, [r5]
	movs	r5, #36
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L1283+136
	str	r0, [r3]
	ldrh	r3, [r10]
	muls	r5, r3, r5
	lsls	r7, r5, #2
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L1283+140
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1283+144
	str	r0, [r3]
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L1283+148
	ldr	r7, .L1283+152
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1283+156
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1283+160
	ldrh	r5, [r7]
	str	r0, [r3]
	ldrh	r3, [r10]
	mov	r0, r5
	lsls	r3, r3, #1
	adds	r3, r3, #1
	str	r3, [r8]
	bl	ftl_malloc
	ldr	r3, .L1283+164
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1283+168
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1283+172
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L1283+176
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1283+180
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1283+184
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L1283+188
	ldrh	r5, [r10]
	ldr	r10, .L1283+316
	str	r0, [r3]
	ldrh	r3, [fp]
	muls	r5, r3, r5
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1283+192
	str	r0, [r3]
	lsls	r0, r5, #2
	ldr	r5, .L1283+196
	bl	ftl_malloc
	ldr	r3, .L1283+200
	str	r0, [r3]
	ldrh	r3, [fp]
	ldr	r0, [r8]
	ldr	r8, .L1283+320
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1283+204
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L1283+208
	str	r0, [r3]
	ldrh	r3, [r8]
	ldr	r0, .L1283+212
	addw	r3, r3, #547
	lsrs	r3, r3, #9
	and	r0, r0, r3, lsl #9
	strh	r3, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L1283+216
	str	r0, [r3]
	adds	r0, r0, #32
	ldr	r3, .L1283+220
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1283+224
	str	r0, [r3]
	ldr	r3, [r10]
	lsl	r8, r3, #1
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L1283+228
	str	r0, [r3]
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L1283+232
	ldr	r8, .L1283+324
	str	r0, [r3]
	ldrh	r0, [r5]
	lsrs	r0, r0, #3
	adds	r0, r0, #4
	bl	ftl_malloc
	ldr	r3, .L1283+236
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1283+240
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1283+244
	str	r0, [r3]
	ldrh	r0, [r8]
	ldr	r8, .L1283+328
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1283+248
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldrh	r2, [r8]
	mov	r1, r4
	ldr	r3, .L1283+252
	lsls	r2, r2, #2
	str	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L1283+256
	ldrh	r4, [r3]
	lsls	r4, r4, #2
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L1283+260
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L1283+264
	ldr	r4, .L1283+268
	str	r0, [r3]
	ldr	r0, [r10]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1283+272
	str	r0, [r3]
	ldrh	r0, [r4]
	muls	r0, r6, r0
	ldr	r6, .L1283+276
	bl	ftl_malloc
	ldr	r3, .L1283+280
	str	r0, [r3]
	ldrh	r3, [r4]
	ldrh	r0, [r7]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1283+284
	str	r0, [r3]
	movs	r0, #6
	ldrh	r3, [r5]
	ldr	r5, .L1283+288
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1283+292
	str	r0, [r3]
	ldr	r3, .L1283+296
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
	ldr	r3, .L1283+300
	ldrh	r6, [r6]
	lsls	r1, r1, #2
	mov	r4, r3
	str	r0, [r4, #28]!
	b	.L1284
.L1285:
	.align	2
.L1283:
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
	.word	.LANCHOR0
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
.L1284:
	mov	r0, r1
.L1279:
	cmp	r2, r6
	bcc	.L1280
	add	r3, r3, r2, lsl #2
	ldr	r2, .L1286
	movs	r1, #0
	adds	r3, r3, #24
.L1281:
	cmp	r3, r2
	bne	.L1282
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1280:
	ldr	r5, [r3, #28]
	adds	r2, r2, #1
	add	r5, r5, r0
	add	r0, r0, r1
	str	r5, [r4, #4]!
	b	.L1279
.L1282:
	str	r1, [r3, #4]!
	b	.L1281
.L1287:
	.align	2
.L1286:
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
	ldr	r3, .L1294
	ldr	r0, [r3]
	bx	lr
.L1295:
	.align	2
.L1294:
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
	ldr	r7, .L1305
	mov	fp, r0
	mov	r6, r1
	mov	r8, r2
	mov	r10, r3
	mov	r4, r5
.L1297:
	cmp	r4, r10
	bne	.L1303
	ldr	r1, .L1305+4
	ldr	r0, .L1305+8
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L1303:
	cbnz	r5, .L1298
	mov	r2, r4
	mov	r1, fp
	ldr	r0, .L1305+12
	bl	printf
.L1298:
	cmp	r8, #4
	bne	.L1299
	ldr	r1, [r6, r4, lsl #2]
.L1304:
	mov	r0, r7
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L1302
	movs	r5, #0
	ldr	r1, .L1305+4
	ldr	r0, .L1305+8
	bl	printf
.L1302:
	adds	r4, r4, #1
	b	.L1297
.L1299:
	cmp	r8, #2
	ite	eq
	ldrsheq	r1, [r6, r4, lsl #1]
	ldrbne	r1, [r6, r4]	@ zero_extendqisi2
	b	.L1304
.L1306:
	.align	2
.L1305:
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
	ldr	r5, .L1425
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
	bne	.L1308
	movs	r3, #167
	mov	fp, #7
	strb	r3, [r5, #4]
	movs	r2, #247
	ldr	r3, .L1425+4
	strb	r2, [r3, #17]
.L1418:
	mov	r10, #4
	b	.L1309
.L1308:
	cmp	r0, #3
	bne	.L1310
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
.L1419:
	mov	fp, #8
	strb	r3, [r5, #11]
	mov	r10, fp
.L1309:
	subs	r3, r4, #1
	cmp	r3, #1
	bhi	.L1315
	mov	r8, #0
.L1316:
	ldr	r3, .L1425+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxtb	r3, r8
	cmp	r2, r3
	bhi	.L1322
.L1323:
	ldr	r3, .L1425
	strb	r10, [r3, #1]
	strb	fp, [r3, #2]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1310:
	cmp	r0, #4
	bne	.L1311
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
	b	.L1419
.L1311:
	cmp	r0, #5
	bne	.L1312
	movs	r3, #56
	mov	fp, #8
	strb	r3, [r5, #4]
	movs	r3, #57
	strb	r3, [r5, #5]
	movs	r3, #58
	strb	r3, [r5, #6]
	movs	r3, #59
	strb	r3, [r5, #7]
	b	.L1418
.L1312:
	cmp	r0, #6
	bne	.L1313
	movs	r3, #14
	mov	fp, #12
	strb	r3, [r5, #4]
	movs	r3, #15
	strb	r3, [r5, #5]
	movs	r3, #16
	strb	r3, [r5, #6]
	movs	r3, #17
	strb	r3, [r5, #7]
	b	.L1418
.L1313:
	cmp	r0, #7
	bne	.L1314
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
	b	.L1309
.L1314:
	cmp	r0, #8
	mov	r3, #7
	bne	.L1373
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
	b	.L1309
.L1373:
	mov	fp, r3
	b	.L1418
.L1322:
	ldr	r2, .L1425+12
	movs	r6, #0
	ldrb	r2, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1425+16
	ldr	r7, [r3, r2, lsl #3]
	add	r4, r5, r2, lsl #6
	add	r3, r3, r2, lsl #3
	movs	r2, #55
	adds	r4, r4, #20
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r7, r7, r3, lsl #8
	addw	r3, r7, #2056
.L1317:
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
	bhi	.L1317
	ldr	r7, .L1425+4
	mov	r1, r4
	movs	r2, #0
.L1320:
	movs	r3, #1
	adds	r6, r7, r2
.L1319:
	ldrb	r0, [r6, r3, lsl #2]	@ zero_extendqisi2
	ldrb	ip, [r1]	@ zero_extendqisi2
	add	r0, r0, ip
	strb	r0, [r1, r3, lsl #3]
	adds	r3, r3, #1
	cmp	r3, #7
	bne	.L1319
	adds	r2, r2, #1
	adds	r1, r1, #1
	cmp	r2, #4
	bne	.L1320
	movs	r3, #0
	add	r8, r8, #1
	strb	r3, [r4, #16]
	strb	r3, [r4, #24]
	strb	r3, [r4, #32]
	strb	r3, [r4, #40]
	strb	r3, [r4, #48]
	strb	r3, [r4, #41]
	strb	r3, [r4, #49]
	b	.L1316
.L1315:
	subs	r3, r4, #3
	cmp	r3, #5
	bhi	.L1323
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
.L1424:
	str	r3, [sp, #28]
	ldrb	r3, [sp, #28]	@ zero_extendqisi2
	str	r3, [sp, #16]
	ldr	r3, .L1425+8
	ldr	r2, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L1323
	ldr	r2, [sp, #16]
	ldr	r3, .L1425+12
	ldrb	r8, [r3, r2]	@ zero_extendqisi2
	ldr	r3, .L1425+16
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
	bne	.L1325
	ldr	r3, .L1425
	movs	r0, #160
	mla	r0, r0, r8, r3
	add	r3, r0, #28
.L1420:
	ldr	r2, [sp, #4]
	cmp	r4, #4
	str	r3, [sp, #20]
	ldr	r3, [sp]
	add	r3, r3, r2, lsl #8
	mov	r2, #54
	str	r2, [r3, #2056]
	bne	.L1328
	movs	r2, #255
	str	r2, [r3, #2052]
	movs	r2, #64
	str	r2, [r3, #2048]
	movs	r2, #204
.L1421:
	str	r2, [r3, #2052]
	movs	r2, #77
	b	.L1422
.L1325:
	cmp	r4, #8
	beq	.L1327
	ldr	r0, .L1425
	add	r0, r0, r8, lsl #6
	add	r3, r0, #20
	b	.L1420
.L1426:
	.align	2
.L1425:
	.word	.LANCHOR20
	.word	.LANCHOR196
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR6
.L1328:
	subs	r2, r4, #5
	cmp	r2, #1
	bhi	.L1330
	ldr	r2, .L1427
	ldrb	r2, [r2, #4]	@ zero_extendqisi2
	str	r2, [r3, #2052]
	movs	r2, #82
.L1422:
	str	r2, [r3, #2048]
.L1329:
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
.L1372:
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
	bls	.L1375
	cmp	r4, #8
	beq	.L1375
	cmp	r4, #7
	ite	eq
	moveq	r2, #32
	movne	r2, #2
.L1333:
	ldr	r3, .L1427+4
	subs	r2, r2, #1
	ldm	sp, {r5, r6}
	ldr	r3, [r3]
	add	r5, r5, r6, lsl #8
	subs	r1, r3, #1
	uxtab	r2, r3, r2
	mov	r0, r1
	str	r5, [sp, #8]
.L1334:
	ldr	r5, [sp, #8]
	ldr	r5, [r5, #2048]
	strb	r5, [r0, #1]!
	cmp	r0, r2
	bne	.L1334
	cmp	r4, #8
	bne	.L1335
	movs	r2, #0
.L1337:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #50
	beq	.L1336
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #5
	beq	.L1336
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1337
.L1338:
	movs	r1, #0
	ldr	r0, .L1427+8
	bl	printf
.L1340:
	b	.L1340
.L1330:
	cmp	r4, #7
	bne	.L1329
	movs	r2, #174
	str	r2, [r3, #2052]
	movs	r2, #0
	str	r2, [r3, #2048]
	movs	r2, #176
	b	.L1421
.L1375:
	movs	r2, #16
	b	.L1333
.L1336:
	cmp	r1, #6
	bhi	.L1338
.L1339:
	ldr	r3, .L1427+4
	ldr	r2, [r3]
	mov	r3, r2
.L1349:
	ldr	r0, [sp, #48]
	subs	r1, r3, r2
	cmp	r1, r0
	blt	.L1350
	ldr	r3, .L1427+4
	ldr	r1, [r3]
	ldr	r3, [sp, #32]
	adds	r0, r1, r3
	movs	r3, #8
.L1352:
	mov	r6, r0
	movs	r5, #0
.L1351:
	ldrh	r7, [r6]
	adds	r5, r5, #1
	mvns	r7, r7
	strh	r7, [r6], #2	@ movhi
	ldr	r7, [sp, #12]
	cmp	r7, r5
	bgt	.L1351
	ldr	r5, [sp, #44]
	subs	r3, r3, #1
	add	r0, r0, r5
	bne	.L1352
	mov	r7, r1
	str	r3, [sp, #24]
.L1358:
	movs	r5, #0
	mov	r0, r5
.L1357:
	movs	r3, #1
	mov	ip, #0
	lsl	r6, r3, r0
	movs	r3, #16
	str	r3, [sp, #40]
	mov	lr, r6
	mov	r6, r7
.L1355:
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
	bne	.L1355
	cmp	ip, #8
	add	r0, r0, #1
	ittt	hi
	movhi	r3, lr
	orrhi	r5, r5, r3
	uxthhi	r5, r5
	cmp	r0, #16
	bne	.L1357
	ldr	r3, [sp, #24]
	strh	r5, [r7], #2	@ movhi
	adds	r3, r3, #1
	str	r3, [sp, #24]
	ldr	r0, [sp, #24]
	ldr	r3, [sp, #12]
	cmp	r3, r0
	bgt	.L1358
	subs	r0, r1, #4
	add	r5, r1, #28
	movs	r3, #0
.L1361:
	ldr	r6, [r0, #4]!
	cbnz	r6, .L1360
	adds	r3, r3, #1
.L1360:
	cmp	r5, r0
	bne	.L1361
	cmp	r3, #7
	ble	.L1362
	ldr	r0, .L1427+12
	mov	r3, #1024
	movs	r2, #1
	bl	rknand_print_hex
	movs	r1, #0
	ldr	r0, .L1427+8
	bl	printf
.L1363:
	b	.L1363
.L1335:
	cmp	r4, #7
	bne	.L1341
	movs	r2, #0
.L1343:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #12
	beq	.L1342
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #10
	beq	.L1342
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1343
.L1344:
	movs	r1, #0
	ldr	r0, .L1427+8
	bl	printf
.L1345:
	b	.L1345
.L1342:
	cmp	r1, #6
	bls	.L1339
	b	.L1344
.L1341:
	cmp	r4, #6
	bne	.L1339
	adds	r3, r3, #7
.L1346:
	ldrb	r2, [r1, #1]!	@ zero_extendqisi2
	cmp	r2, #12
	beq	.L1339
	ldrb	r2, [r1, #8]	@ zero_extendqisi2
	cmp	r2, #4
	beq	.L1339
	cmp	r1, r3
	bne	.L1346
	movs	r1, #0
	ldr	r0, .L1427+8
	bl	printf
.L1348:
	b	.L1348
.L1350:
	ldr	r1, [sp, #8]
	ldr	r1, [r1, #2048]
	strb	r1, [r3], #1
	b	.L1349
.L1362:
	cmp	r4, #6
	beq	.L1377
	cmp	r4, #7
	beq	.L1378
	cmp	r4, #8
	ite	eq
	moveq	r6, #5
	movne	r6, #8
.L1364:
	add	r3, r10, #-1
	ldr	r0, [sp, #20]
	uxtb	r3, r3
	movs	r5, #0
	adds	r3, r3, #1
.L1365:
	mov	ip, r0
	mov	r1, r2
.L1366:
	ldrb	r7, [r1], #1	@ zero_extendqisi2
	strb	r7, [ip], #1
	subs	r7, r1, r2
	uxtb	r7, r7
	cmp	r10, r7
	bhi	.L1366
	adds	r5, r5, #1
	add	r2, r2, r3
	cmp	fp, r5
	add	r0, r0, r6
	bgt	.L1365
	ldr	r3, [sp]
	mov	r0, r8
	ldr	r2, [sp, #4]
	add	r5, r3, r2, lsl #8
	movs	r3, #255
	str	r3, [r5, #2056]
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #36]
	cmp	r3, #1
	bhi	.L1368
	movs	r3, #54
	ldr	r2, [sp, #8]
	str	r3, [r5, #2056]
	mov	r1, #-1
	ldr	r3, .L1427
	ldr	r0, [sp, #16]
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	str	r3, [r2, #2052]
	movs	r3, #0
	str	r3, [r2, #2048]
	movs	r3, #22
	str	r3, [r5, #2056]
	bl	FlashReadCmd
.L1369:
	mov	r0, r8
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	b	.L1424
.L1377:
	movs	r6, #4
	b	.L1364
.L1378:
	movs	r6, #10
	b	.L1364
.L1368:
	cmp	r4, #8
	ite	eq
	moveq	r3, #190
	movne	r3, #56
	str	r3, [r5, #2056]
	b	.L1369
.L1327:
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
	ldr	r3, .L1427+16
	str	r3, [sp, #20]
	b	.L1372
.L1428:
	.align	2
.L1427:
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
	cbz	r0, .L1429
	subs	r2, r0, #1
	cmp	r2, #7
	bhi	.L1431
	b	HynixGetReadRetryDefault
.L1431:
	cmp	r0, #49
	bne	.L1432
	ldr	r0, .L1452
	movs	r2, #64
	ldr	r1, .L1452+4
	strb	r3, [r0]
	movs	r3, #4
	strb	r3, [r0, #1]
	movs	r3, #15
	strb	r3, [r0, #2]
.L1450:
	adds	r0, r0, #4
	b	ftl_memcpy
.L1432:
	cmp	r0, #33
	beq	.L1433
	sub	r2, r0, #65
	cmp	r2, #1
	bhi	.L1434
.L1433:
	ldr	r0, .L1452
	strb	r3, [r0]
	movs	r3, #4
.L1451:
	strb	r3, [r0, #1]
	movs	r3, #7
	strb	r3, [r0, #2]
	movs	r2, #45
	ldr	r1, .L1452+8
	b	.L1450
.L1434:
	cmp	r0, #34
	beq	.L1435
	cmp	r0, #67
	bne	.L1436
.L1435:
	ldr	r0, .L1452
	strb	r3, [r0]
	movs	r3, #5
	b	.L1451
.L1436:
	cmp	r0, #35
	beq	.L1437
	cmp	r0, #68
	bne	.L1429
.L1437:
	ldr	r0, .L1452
	movs	r2, #95
	ldr	r1, .L1452+12
	strb	r3, [r0]
	movs	r3, #5
	strb	r3, [r0, #1]
	movs	r3, #17
	strb	r3, [r0, #2]
	b	.L1450
.L1429:
	bx	lr
.L1453:
	.align	2
.L1452:
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
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	sub	sp, sp, #32
	mov	r0, #32768
	movs	r5, #0
	bl	ftl_malloc
	ldr	r3, .L1554
	ldr	r10, .L1554+120
	ldr	r8, .L1554+124
	str	r0, [r3]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L1554+4
	ldr	r6, .L1554+8
	ldr	r7, .L1554+12
	str	r0, [r3]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L1554+16
	str	r0, [r3]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L1554+20
	str	r0, [r3]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L1554+24
	ldr	r2, .L1554+28
	strb	r5, [r8]
	str	r0, [r3]
	movs	r3, #50
	strb	r3, [r10]
	mov	r0, r4
	strb	r3, [r2]
	movs	r2, #128
	ldr	r3, .L1554+32
	ldr	r4, .L1554+36
	strb	r5, [r7]
	str	r5, [r3]
	ldr	r3, .L1554+40
	str	r2, [r3]
	ldr	r3, .L1554+44
	str	r5, [r3]
	movs	r3, #60
	strb	r3, [r6]
	bl	NandcInit
	str	r10, [sp, #20]
	ldr	r10, .L1554+128
	str	r8, [sp, #16]
	mov	r8, r6
	mov	r6, r4
.L1459:
	add	r1, r10, r5, lsl #3
	uxtb	r2, r5
	ldr	r3, [r10, r5, lsl #3]
	ldrb	r1, [r1, #4]	@ zero_extendqisi2
	mov	fp, r2
	mov	r0, r2
	str	r3, [sp, #28]
	str	r1, [sp, #24]
	bl	FlashReset
	mov	r0, fp
	bl	NandcFlashCs
	ldr	r1, [sp, #24]
	movs	r0, #200
	ldr	r3, [sp, #28]
	add	r3, r3, r1, lsl #8
	movs	r1, #144
	str	r1, [r3, #2056]
	movs	r1, #0
	str	r1, [r3, #2052]
	str	r3, [sp, #24]
	bl	udelay
	ldr	r3, [sp, #24]
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
	bhi	.L1455
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	ldr	r0, .L1554+48
	str	r1, [sp, #12]
	ldrb	r1, [r4, #4]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r4, #3]	@ zero_extendqisi2
	str	r1, [sp, #4]
	ldrb	r1, [r4, #2]	@ zero_extendqisi2
	str	r1, [sp]
	adds	r1, r5, #1
	bl	printf
.L1455:
	cbnz	r5, .L1456
	ldrb	r3, [r6]	@ zero_extendqisi2
	subs	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #253
	bhi	.L1503
	ldrb	r3, [r6, #1]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L1503
.L1456:
	ldrb	r3, [r4]	@ zero_extendqisi2
	adds	r5, r5, #1
	adds	r4, r4, #8
	cmp	r3, #181
	itt	eq
	moveq	r3, #44
	strbeq	r3, [r4, #-8]
	cmp	r5, #4
	bne	.L1459
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #173
	beq	.L1460
	ldr	r3, .L1554+52
	ldr	r0, [r3]
	bl	NandcSetDdrMode
.L1460:
	mov	r2, #852
	movs	r1, #0
	ldr	r0, .L1554+56
	bl	ftl_memset
	ldr	r4, .L1554+60
	movs	r2, #0
	ldr	r3, .L1554+64
	ldr	r5, .L1554+68
	str	r3, [r4]
	ldr	r3, .L1554+72
	strb	r2, [r3]
	mov	r10, r3
	ldr	r2, .L1554+76
	ldr	r1, [r2]
	cmp	r1, r5
	ittt	eq
	ldreq	r3, .L1554+80
	moveq	r2, #1
	streq	r2, [r3]
	ldrb	r3, [r6, #1]	@ zero_extendqisi2
	cmp	r3, #161
	beq	.L1462
	cmp	r3, #241
	beq	.L1462
	cmp	r3, #218
	beq	.L1462
	and	r2, r3, #253
	cmp	r2, #209
	beq	.L1462
	cmp	r3, #220
	bne	.L1463
	ldrb	r2, [r6, #3]	@ zero_extendqisi2
	cmp	r2, #149
	bne	.L1463
.L1462:
	ldr	r0, [sp, #16]
	movs	r2, #1
	strb	r2, [r0]
	movs	r2, #16
	ldr	r0, [sp, #20]
	strb	r2, [r8]
	strb	r2, [r0]
	ldrb	r0, [r6]	@ zero_extendqisi2
	ldr	r2, .L1554+84
	cmp	r0, #152
	strb	r0, [r2, #1]
	strb	r3, [r2, #2]
	bne	.L1464
	ldrsb	r0, [r6, #4]
	cmp	r0, #0
	itt	ge
	movge	r0, #24
	strbge	r0, [r8]
.L1464:
	cmp	r1, r5
	beq	.L1465
	movw	r0, #2049
	cmp	r1, r0
	bne	.L1466
.L1465:
	movs	r1, #16
	strb	r1, [r8]
.L1466:
	cmp	r3, #218
	bne	.L1467
	mov	r1, #2048
.L1550:
	strh	r1, [r2, #14]	@ movhi
	strb	r3, [r2, #2]
.L1468:
	movs	r2, #32
	ldr	r1, .L1554+88
	ldr	r0, .L1554+92
	bl	ftl_memcpy
	movs	r2, #32
	ldr	r1, .L1554+84
	ldr	r0, .L1554+64
	bl	ftl_memcpy
.L1463:
	ldr	r3, [sp, #16]
	ldr	r8, .L1554+132
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1471
	bl	FlashLoadPhyInfoInRam
	cbnz	r0, .L1473
	ldr	r3, [r4]
	ldr	fp, .L1554+104
	ldrh	r3, [r3, #16]
	lsrs	r3, r3, #8
	lsls	r1, r3, #31
	and	r0, r3, #7
	strb	r0, [fp]
	bmi	.L1473
	movs	r3, #1
	strb	r3, [r7]
	bl	FlashSetInterfaceMode
	ldrb	r0, [fp]	@ zero_extendqisi2
	bl	NandcSetMode
.L1473:
	ldr	r3, [r4]
	ldrb	r3, [r3, #26]	@ zero_extendqisi2
	strb	r3, [r8]
	bl	FlashLoadPhyInfo
	cmp	r0, #0
	beq	.L1471
	ldr	r3, [r4]
	ldr	r0, .L1554+96
	ldrh	r1, [r3, #14]
	bl	printf
	bl	FlashLoadPhyInfoInRam
	adds	r2, r0, #1
	beq	.L1454
	bl	FlashDieInfoInit
	ldr	r3, [r4]
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	bl	FlashGetReadRetryDefault
	ldr	r3, [r4]
	ldr	r2, .L1554+100
	ldrb	r1, [r3, #9]	@ zero_extendqisi2
	ldrh	r2, [r2]
	addw	r2, r2, #4095
	cmp	r1, r2, asr #12
	blt	.L1476
	ldrh	r2, [r3, #14]
	adds	r2, r2, #255
	cmp	r1, r2, asr #8
	bge	.L1477
.L1476:
	ldrh	r2, [r3, #14]
	bic	r2, r2, #255
	strh	r2, [r3, #14]	@ movhi
.L1477:
	ldr	r3, .L1554+104
	ldrb	r3, [r3]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L1478
	bl	FlashSavePhyInfo
	ldr	r3, .L1554+108
	movs	r0, #0
	ldr	r1, [r3]
	bl	FlashDdrParaScan
.L1478:
	bl	FlashSavePhyInfo
.L1471:
	ldr	fp, [r4]
	ldrh	r2, [fp, #16]
	ldrb	r3, [fp, #26]	@ zero_extendqisi2
	ldrh	r0, [fp, #10]
	ubfx	r1, r2, #3, #1
	strb	r3, [r8]
	ubfx	r3, r2, #7, #1
	strb	r3, [r10]
	ldr	r3, .L1554+112
	ldr	r10, .L1554+136
	strb	r1, [r3]
	ubfx	r1, r2, #4, #1
	ldr	r3, .L1554+116
	ubfx	r2, r2, #8, #3
	strb	r1, [r3]
	ldr	r3, .L1554+104
	ldrb	r1, [fp, #12]	@ zero_extendqisi2
	strb	r2, [r3]
	movs	r2, #0
	str	r2, [r10]
	str	r3, [sp, #24]
	bl	__aeabi_idiv
	mov	r1, r0
	ldrb	r0, [fp, #18]	@ zero_extendqisi2
	bl	BuildFlashLsbPageTable
	bl	FlashDieInfoInit
	ldr	r2, [r4]
	ldr	r3, [sp, #24]
	ldrh	r1, [r2, #16]
	mov	fp, r3
	tst	r1, #64
	mov	r1, r10
	b	.L1555
.L1556:
	.align	2
.L1554:
	.word	.LANCHOR147
	.word	.LANCHOR153
	.word	.LANCHOR152
	.word	.LANCHOR30
	.word	.LANCHOR197
	.word	.LANCHOR198
	.word	.LANCHOR199
	.word	.LANCHOR150
	.word	.LANCHOR149
	.word	.LANCHOR22
	.word	.LANCHOR3
	.word	.LANCHOR144
	.word	.LC23
	.word	.LANCHOR155
	.word	.LANCHOR20
	.word	.LANCHOR18
	.word	.LANCHOR31
	.word	1446522928
	.word	.LANCHOR5
	.word	.LANCHOR119
	.word	.LANCHOR29
	.word	.LANCHOR200
	.word	.LANCHOR143+32
	.word	.LANCHOR7
	.word	.LC24
	.word	.LANCHOR122
	.word	.LANCHOR24
	.word	.LANCHOR148
	.word	.LANCHOR201
	.word	.LANCHOR27
	.word	.LANCHOR2
	.word	.LANCHOR1
	.word	.LANCHOR6
	.word	.LANCHOR15
	.word	.LANCHOR145
.L1555:
	beq	.L1480
	ldrb	r0, [r2, #19]	@ zero_extendqisi2
	ldr	r3, .L1557
	ldr	ip, .L1557+56
	strb	r0, [r3]
	ldrb	r2, [ip, #1]	@ zero_extendqisi2
	ldr	r3, .L1557+4
	ldrb	ip, [ip, #2]	@ zero_extendqisi2
	strb	r2, [r3]
	ldr	r2, .L1557+8
	strb	ip, [r2]
	add	ip, r0, #-1
	cmp	ip, #7
	mov	ip, r2
	bhi	.L1481
	ldr	r3, .L1557+12
	str	r3, [r10]
	subs	r3, r0, #5
	cmp	r3, #1
	bls	.L1482
	cmp	r0, #8
	bne	.L1483
.L1482:
	ldr	r3, .L1557+16
	movs	r2, #1
	str	r2, [r3]
.L1483:
	cmp	r0, #7
	ldr	r3, .L1557+20
	beq	.L1484
	sub	r2, r3, #8
	cmp	r0, #8
	it	ne
	movne	r3, r2
.L1484:
	subs	r1, r3, #1
	movs	r2, #0
	adds	r3, r3, #31
.L1486:
	ldrsb	ip, [r1, #1]!
	cmp	ip, #0
	bne	.L1485
	adds	r2, r2, #1
.L1485:
	cmp	r3, r1
	bne	.L1486
	cmp	r2, #27
	bls	.L1480
	bl	FlashGetReadRetryDefault
	bl	FlashSavePhyInfo
.L1480:
	ldr	r3, .L1557+24
	ldr	r3, [r3]
	cmp	r3, r5
	bne	.L1497
	ldrb	r3, [r8]	@ zero_extendqisi2
	cbz	r3, .L1497
	ldr	r3, [r4]
	movs	r2, #0
	strb	r2, [r3, #18]
.L1497:
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #44
	bne	.L1498
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbz	r3, .L1498
	movs	r3, #0
	movs	r0, #1
	strb	r3, [r7]
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
.L1498:
	ldrb	r3, [fp]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L1499
	ldrb	r2, [r7]	@ zero_extendqisi2
	cbnz	r2, .L1500
	lsls	r3, r3, #31
	bmi	.L1499
.L1500:
	movs	r0, #0
	bl	flash_enter_slc_mode
	ldr	r3, .L1557+28
	movs	r0, #0
	ldr	r1, [r3]
	bl	FlashDdrParaScan
	movs	r0, #0
	bl	flash_exit_slc_mode
.L1499:
	ldr	r3, [r4]
	movs	r7, #16
	ldrb	r0, [r3, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	ldr	r0, .L1557+32
	bl	FlashReadIdbDataRaw
	ldr	r8, [r4]
	ldr	r3, [sp, #20]
	ldr	r4, .L1557+36
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
	ldr	r3, .L1557+40
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
	ldr	r2, [sp, #16]
	strh	r3, [r4, #20]	@ movhi
	smulbb	r5, r5, r3
	strh	r7, [r4, #26]	@ movhi
	ldrb	r2, [r2]	@ zero_extendqisi2
	uxth	r5, r5
	cmp	r2, #1
	strh	r5, [r4, #22]	@ movhi
	bne	.L1501
	lsls	r3, r3, #1
	lsrs	r2, r6, #1
	lsls	r5, r5, #1
	strh	r3, [r4, #20]	@ movhi
	movs	r3, #8
	strh	r2, [r4, #14]	@ movhi
	strh	r5, [r4, #22]	@ movhi
	strh	r3, [r4, #26]	@ movhi
.L1501:
	ldrb	r0, [r8, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r0, #0
.L1454:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1467:
	cmp	r3, #220
	bne	.L1469
	mov	r1, #4096
	b	.L1550
.L1469:
	cmp	r3, #211
	itttt	eq
	moveq	r3, #4096
	strheq	r3, [r2, #14]	@ movhi
	moveq	r3, #2
	strbeq	r3, [r2, #13]
	b	.L1468
.L1481:
	sub	lr, r0, #17
	cmp	lr, #2
	bhi	.L1488
	ldr	r3, .L1557+44
	cmp	r0, #19
	str	r3, [r10]
	ite	ne
	movne	r3, #7
	moveq	r3, #15
	strb	r3, [r2]
	b	.L1480
.L1488:
	cmp	r0, #33
	beq	.L1490
	sub	r2, r0, #65
	cmp	r2, #1
	bhi	.L1491
.L1490:
	ldr	r2, .L1557+48
	str	r2, [r1]
	movs	r2, #4
	strb	r2, [r3]
	movs	r3, #7
	strb	r3, [ip]
	b	.L1480
.L1491:
	sub	r2, r0, #67
	uxtb	r2, r2
	cmp	r2, #1
	bls	.L1492
	sub	ip, r0, #34
	cmp	ip, #1
	bhi	.L1493
.L1492:
	ldr	ip, .L1557+48
	cmp	r0, #35
	str	ip, [r1]
	ldr	r1, .L1557+8
	beq	.L1494
	cmp	r0, #68
	beq	.L1494
	movs	r0, #7
.L1551:
	cmp	r2, #1
	strb	r0, [r1]
	ite	ls
	movls	r2, #4
	movhi	r2, #5
	strb	r2, [r3]
	b	.L1480
.L1494:
	movs	r0, #17
	b	.L1551
.L1493:
	cmp	r0, #49
	itt	eq
	ldreq	r3, .L1557+52
	streq	r3, [r10]
	b	.L1480
.L1503:
	mvn	r0, #1
	b	.L1454
.L1558:
	.align	2
.L1557:
	.word	.LANCHOR9
	.word	.LANCHOR12
	.word	.LANCHOR151
	.word	HynixReadRetrial
	.word	.LANCHOR36
	.word	.LANCHOR20+28
	.word	.LANCHOR119
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r1
	ldr	r3, .L1588
	mov	fp, r2
	mov	r4, r0
	movs	r7, #0
	ldrb	r10, [r3, #9]	@ zero_extendqisi2
.L1560:
	cmp	r7, r8
	bne	.L1573
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1573:
	sub	r3, r8, r7
	add	r2, sp, #12
	uxtb	r3, r3
	mov	r1, fp
	mov	r0, r4
	str	r3, [sp]
	add	r3, sp, #8
	bl	LogAddr2PhyAddr
	ldr	r2, .L1588+4
	ldr	r3, [sp, #8]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1561
	mov	r3, #-1
	str	r3, [r4]
.L1562:
	adds	r7, r7, #1
	adds	r4, r4, #36
	b	.L1560
.L1561:
	ldr	r2, .L1588+8
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	mov	r0, r5
	bl	NandcWaitFlashReady
	mov	r0, r5
	bl	NandcFlashCs
	ldr	r1, [sp, #12]
	mov	r0, r5
	bl	FlashReadCmd
	mov	r0, r5
	bl	NandcWaitFlashReady
	ldr	r3, [r4, #12]
	mov	r2, r10
	movs	r1, #0
	mov	r0, r5
	str	r3, [sp]
	ldr	r3, [r4, #8]
	bl	NandcXferData
	ldr	r3, .L1588+12
	mov	r6, r0
	ldr	r1, [sp, #12]
	mov	r0, r5
	ldr	r3, [r3]
	add	r1, r1, r3
	bl	FlashReadCmd
	ldr	r3, [r4, #8]
	cbz	r3, .L1563
	add	r3, r3, #2048
.L1563:
	ldr	r2, [r4, #12]
	cbz	r2, .L1564
	adds	r2, r2, #8
.L1564:
	str	r2, [sp]
	movs	r1, #0
	mov	r2, r10
	mov	r0, r5
	bl	NandcXferData
	mov	r1, r0
	mov	r0, r5
	bl	NandcFlashDeCs
	ldr	r3, .L1588+16
	cmp	r6, r1
	it	cc
	movcc	r6, r1
	ldrb	r2, [r3]	@ zero_extendqisi2
	add	r3, r2, r2, lsl #1
	cmp	r6, r3, asr #2
	bls	.L1565
	adds	r5, r6, #1
	it	ne
	movne	r6, #256
	str	r6, [r4]
.L1568:
	ldr	r3, [r4, #12]
	cbz	r3, .L1569
	ldr	r1, [r3, #12]
	adds	r1, r1, #1
	bne	.L1569
	ldr	r1, [r3, #8]
	adds	r0, r1, #1
	bne	.L1569
	ldr	r3, [r3]
	adds	r3, r3, #1
	it	ne
	strne	r1, [r4]
.L1569:
	ldr	r3, [r4]
	adds	r1, r3, #1
	bne	.L1562
	ldr	r1, [r4, #4]
	ldr	r0, .L1588+20
	bl	printf
	ldr	r1, [r4, #8]
	cbz	r1, .L1571
	movs	r3, #8
	movs	r2, #4
	ldr	r0, .L1588+24
	bl	rknand_print_hex
.L1571:
	ldr	r1, [r4, #12]
	cmp	r1, #0
	beq	.L1562
	movs	r3, #4
	ldr	r0, .L1588+28
	mov	r2, r3
	bl	rknand_print_hex
	b	.L1562
.L1565:
	movs	r3, #0
	str	r3, [r4]
	b	.L1568
.L1589:
	.align	2
.L1588:
	.word	.LANCHOR31
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR3
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
	ldr	r3, .L1681
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	mov	r10, r0
	str	r1, [sp, #24]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [sp, #12]
	cbnz	r3, .L1591
	ldr	r2, .L1681+4
	mov	r8, r3
	str	r3, [sp, #8]
	ldrb	r2, [r2, #9]	@ zero_extendqisi2
	str	r2, [sp, #20]
	ldr	r2, .L1681+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #28]
.L1592:
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #24]
	cmp	r3, r2
	bcc	.L1630
	movs	r0, #0
	b	.L1590
.L1591:
	bl	FlashReadSlc2KPages
.L1590:
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1630:
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
	ldr	r2, .L1681+12
	mov	r5, r0
	ldr	r3, [sp, #32]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1594
	mov	r3, #-1
	str	r3, [r10, fp]
.L1595:
	ldr	r3, [sp, #8]
	adds	r3, r3, #1
	str	r3, [sp, #8]
	b	.L1592
.L1594:
	ldr	r2, .L1681+16
	ldrb	r4, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1681+20
	mov	r0, r4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	it	eq
	moveq	r5, #0
	bl	NandcWaitFlashReady
	ldr	r3, .L1681+24
	ldr	r3, [r3]
	ldrb	r2, [r3, #19]	@ zero_extendqisi2
	subs	r3, r2, #1
	cmp	r3, #7
	bhi	.L1597
	ldr	r3, .L1681+28
	subs	r2, r2, #7
	cmp	r2, #1
	ldr	r2, .L1681+32
	add	r1, r3, r4
	ldrb	r3, [r1, #12]	@ zero_extendqisi2
	ldrb	r2, [r2, r4]	@ zero_extendqisi2
	it	ls
	ldrbls	r3, [r1, #20]	@ zero_extendqisi2
	cmp	r2, r3
	beq	.L1597
	ldr	r2, .L1681+36
	mov	r0, r4
	ldrb	r1, [r2, #-3]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1597:
	mov	r0, r4
	bl	NandcFlashCs
	ldr	r3, [sp, #12]
	cmp	r3, #1
	beq	.L1599
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1600
.L1599:
	ldr	r3, .L1681+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1600
	mov	r0, r4
	bl	flash_enter_slc_mode
.L1607:
	ldr	r1, [sp, #36]
	adds	r6, r1, #1
	bne	.L1602
	cmp	r4, #255
	beq	.L1632
.L1602:
	cbz	r5, .L1604
	ldr	r3, .L1681+44
	mov	r0, r4
	ldr	r2, [r3]
	add	r2, r2, r1
	bl	FlashReadDpCmd
.L1605:
	mov	r0, r4
	bl	NandcWaitFlashReady
	cbz	r5, .L1603
	ldr	r1, [sp, #36]
	mov	r0, r4
	bl	FlashReadDpDataOutCmd
.L1603:
	ldr	r3, [r7, #12]
	movs	r1, #0
	ldr	r2, [sp, #20]
	mov	r0, r4
	str	r3, [sp]
	ldr	r3, [r7, #8]
	bl	NandcXferData
	ldr	r3, .L1681+8
	mov	r6, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1606
	adds	r0, r0, #1
	bne	.L1606
	ldr	r3, .L1681+8
	movs	r5, #0
	strb	r5, [r3]
	b	.L1607
.L1600:
	mov	r0, r4
	bl	flash_exit_slc_mode
	b	.L1607
.L1604:
	mov	r0, r4
	bl	FlashReadCmd
	b	.L1605
.L1632:
	movs	r5, #0
	b	.L1603
.L1606:
	cbz	r5, .L1608
	ldr	r3, .L1681+44
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
.L1608:
	mov	r0, r4
	bl	NandcFlashDeCs
	ldr	r3, .L1681+8
	adds	r1, r6, #1
	ldrb	r2, [sp, #28]	@ zero_extendqisi2
	strb	r2, [r3]
	bne	.L1609
	ldr	r3, .L1681+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1610
.L1614:
	ldr	r3, .L1681+52
	ldr	r5, [r3]
	cmp	r5, #0
	bne	.L1611
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	bl	FlashReadRawPage
	b	.L1680
.L1610:
	ldr	r3, .L1681+56
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
	beq	.L1613
	ldr	r3, .L1681+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3, lsr #1
	bls	.L1633
.L1613:
	ubfx	r0, r5, #8, #8
	bl	NandcSetDdrPara
	adds	r3, r6, #1
	beq	.L1614
.L1633:
	movs	r5, #0
.L1609:
	ldr	r3, .L1681+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r6, r3, asr #2
	bls	.L1622
	ldr	r3, .L1681+52
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L1622
	mov	r6, #256
	b	.L1617
.L1682:
	.align	2
.L1681:
	.word	.LANCHOR1
	.word	.LANCHOR31
	.word	.LANCHOR5
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR201
	.word	.LANCHOR18
	.word	.LANCHOR20
	.word	.LANCHOR21
	.word	.LANCHOR20+4
	.word	.LANCHOR15
	.word	.LANCHOR3
	.word	.LANCHOR30
	.word	.LANCHOR145
	.word	.LANCHOR19
	.word	.LANCHOR33
.L1611:
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	blx	r5
	adds	r5, r0, #1
	mov	r6, r0
	bne	.L1615
	ldr	r3, .L1683
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #7
	bhi	.L1616
	ldr	r2, .L1683+4
	movs	r3, #0
	mov	r0, r4
	ldrb	r1, [r2, #-3]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1616:
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	bl	FlashReadRawPage
	ldr	r2, .L1683+8
	mov	r6, r0
	mov	r3, r0
	ldr	r1, [r7, #4]
	ldr	r0, .L1683+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	bl	printf
	adds	r0, r6, #1
	bne	.L1615
	ldr	r3, .L1683+16
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L1617
	ldr	r3, [sp, #12]
	mov	r0, r4
	cmp	r3, #1
	beq	.L1618
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1619
.L1618:
	bl	flash_enter_slc_mode
.L1620:
	ldr	r3, .L1683+20
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	ldr	r5, [r3]
	ldr	r3, [r7, #12]
	blx	r5
.L1680:
	adds	r1, r0, #1
	mov	r6, r0
	mov	r5, #0
	bne	.L1622
.L1617:
	str	r6, [r10, fp]
.L1623:
	ldr	r3, [r10, fp]
	adds	r2, r3, #1
	bne	.L1625
	ldr	r2, .L1683+8
	ldr	r1, [r7, #4]
	ldr	r0, .L1683+24
	ldrb	r2, [r2]	@ zero_extendqisi2
	bl	printf
	ldr	r1, [r7, #12]
	cbz	r1, .L1625
	movs	r3, #4
	ldr	r0, .L1683+28
	mov	r2, r3
	bl	rknand_print_hex
.L1625:
	cbz	r5, .L1627
	ldr	r3, .L1683+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r8, r3, asr #2
	bls	.L1628
	ldr	r3, .L1683+20
	ldr	r3, [r3]
	cmp	r3, #0
	it	eq
	moveq	r8, #256
.L1628:
	cmp	r8, #-1
	add	r3, fp, #36
	str	r8, [r10, r3]
	beq	.L1627
	cmp	r8, #256
	itt	ne
	movne	r2, #0
	strne	r2, [r10, r3]
.L1627:
	ldr	r3, [sp, #8]
	add	r3, r3, r5
	str	r3, [sp, #8]
	ldr	r3, [sp, #12]
	cmp	r3, #1
	beq	.L1629
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1595
.L1629:
	ldr	r3, .L1683+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1595
	mov	r0, r4
	bl	flash_exit_slc_mode
	b	.L1595
.L1619:
	bl	flash_exit_slc_mode
	b	.L1620
.L1615:
	movs	r5, #0
.L1622:
	cmp	r6, #256
	beq	.L1617
	movs	r3, #0
	str	r3, [r10, fp]
	b	.L1623
.L1684:
	.align	2
.L1683:
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
	ldr	r3, .L1714
	movs	r7, #0
	ldr	fp, .L1714+28
	str	r2, [sp, #8]
	ldrb	r10, [r3, #9]	@ zero_extendqisi2
.L1686:
	cmp	r7, r8
	bne	.L1692
	ldr	r3, [sp, #12]
	cmp	r3, #0
	bne	.L1703
.L1713:
	movs	r0, #0
	add	sp, sp, #64
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1692:
	sub	r3, r8, r7
	add	r2, sp, #20
	uxtb	r3, r3
	ldr	r1, [sp, #8]
	mov	r0, r6
	str	r3, [sp]
	add	r3, sp, #24
	bl	LogAddr2PhyAddr
	ldr	r2, .L1714+4
	ldr	r3, [sp, #24]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1687
	mov	r3, #-1
	str	r3, [r6]
.L1688:
	adds	r7, r7, #1
	adds	r6, r6, #36
	b	.L1686
.L1687:
	ldr	r2, .L1714+8
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
	cbz	r3, .L1689
	add	r3, r3, #2048
.L1689:
	ldr	r2, [r6, #12]
	cbz	r2, .L1690
	adds	r2, r2, #8
.L1690:
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
	b	.L1688
.L1699:
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1694
	ldr	r1, [r4, #4]
	ldr	r0, .L1714+12
	bl	printf
.L1695:
	add	r8, r8, #1
	adds	r4, r4, #36
.L1693:
	cmp	r7, r8
	bne	.L1699
	b	.L1713
.L1694:
	sub	r3, r7, r8
	ldr	fp, .L1714+32
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
	bne	.L1696
	ldr	r1, [r4, #4]
	ldr	r0, .L1714+16
	bl	printf
	str	r5, [r4]
.L1696:
	ldr	r3, [r4, #12]
	cbz	r3, .L1697
	ldr	r2, [r3]
	ldr	r3, [fp]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1697
	ldr	r1, [r4, #4]
	ldr	r0, .L1714+20
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L1697:
	ldr	r3, [r4, #8]
	cmp	r3, #0
	beq	.L1695
	ldr	r2, [r3]
	ldr	r3, [r10]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1695
	ldr	r1, [r4, #4]
	ldr	r0, .L1714+24
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
	b	.L1695
.L1703:
	mov	r8, #0
	ldr	r10, .L1714+36
	b	.L1693
.L1715:
	.align	2
.L1714:
	.word	.LANCHOR31
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LC29
	.word	.LC30
	.word	.LC31
	.word	.LC32
	.word	.LANCHOR3
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
	ldr	r5, .L1768
	mov	r4, r0
	mov	r8, r2
	str	r1, [sp, #8]
	ldr	r5, [r5]
	str	r3, [sp, #20]
	ldrb	r5, [r5, #19]	@ zero_extendqisi2
	str	r5, [sp, #16]
	ldr	r5, .L1768+4
	ldrb	r7, [r5]	@ zero_extendqisi2
	cbnz	r7, .L1717
	ldr	r3, .L1768+8
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	str	r3, [sp, #12]
.L1718:
	ldr	r3, [sp, #8]
	cmp	r7, r3
	bcc	.L1731
	ldr	r6, .L1768+12
	movs	r5, #0
	ldr	r7, .L1768+16
.L1732:
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r5, r3
	bcc	.L1734
	ldr	r3, [sp, #20]
	cmp	r3, #0
	bne	.L1735
.L1743:
	movs	r0, #0
	b	.L1716
.L1717:
	bl	FlashProgSlc2KPages
.L1716:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1731:
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
	ldr	r3, .L1768+12
	mov	r10, r0
	ldr	r0, [sp, #32]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L1720
	mov	r3, #-1
	str	r3, [r4, r6]
.L1721:
	adds	r7, r7, #1
	b	.L1718
.L1720:
	ldr	r3, .L1768+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	ldr	r3, .L1768+24
	it	eq
	moveq	r10, #0
	add	r3, r3, r0, lsl #4
	ldr	r3, [r3, #8]
	cbz	r3, .L1723
	uxtb	r0, r0
	bl	FlashWaitCmdDone
.L1723:
	ldr	r3, [sp, #32]
	movs	r1, #0
	ldr	r2, .L1768+24
	add	r2, r2, r3, lsl #4
	str	r1, [r2, #12]
	ldr	r1, [sp, #28]
	str	fp, [r2, #8]
	str	r1, [r2, #4]
	cmp	r10, #0
	beq	.L1724
	add	r1, r6, #36
	add	r1, r1, r4
	str	r1, [r2, #12]
.L1724:
	ldr	r2, .L1768+28
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	lsls	r3, r3, #4
	ldr	r2, .L1768+24
	mov	r0, r5
	strb	r5, [r2, r3]
	ldr	r3, .L1768+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1725
	bl	NandcWaitFlashReady
.L1726:
	ldr	r3, [sp, #16]
	subs	r3, r3, #1
	cmp	r3, #7
	bhi	.L1727
	ldr	r3, .L1768+32
	ldrb	r3, [r3, r5]	@ zero_extendqisi2
	cbz	r3, .L1727
	ldr	r1, .L1768+36
	movs	r3, #0
	mov	r0, r5
	adds	r2, r1, #4
	ldrb	r1, [r1, #1]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1727:
	mov	r0, r5
	bl	NandcFlashCs
	cmp	r8, #1
	mov	r0, r5
	bne	.L1728
	ldr	r3, .L1768+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1728
	bl	flash_enter_slc_mode
.L1729:
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
	beq	.L1730
	ldr	r1, [sp, #28]
	mov	r0, r5
	bl	FlashProgDpFirstCmd
	ldr	r3, .L1768+40
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
	ldr	r3, .L1768+44
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
.L1730:
	ldr	r1, [sp, #28]
	mov	r0, r5
	bl	FlashProgSecondCmd
	mov	r0, r5
	add	r7, r7, r10
	bl	NandcFlashDeCs
	b	.L1721
.L1725:
	bl	NandcFlashCs
	ldr	r2, [sp, #32]
	mov	r0, r5
	ldr	r3, .L1768+40
	ldr	r1, [sp, #28]
	ldr	r2, [r3, r2, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	mov	r0, r5
	bl	NandcFlashDeCs
	b	.L1726
.L1728:
	bl	flash_exit_slc_mode
	b	.L1729
.L1734:
	uxtb	r0, r5
	bl	FlashWaitCmdDone
	cmp	r8, #1
	bne	.L1733
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbz	r3, .L1733
	ldr	r2, .L1768+24
	lsls	r3, r5, #4
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	flash_exit_slc_mode
.L1733:
	adds	r5, r5, #1
	b	.L1732
.L1735:
	ldr	r10, .L1768+64
	movs	r7, #0
.L1736:
	ldr	r3, [sp, #8]
	cmp	r7, r3
	beq	.L1743
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1737
	ldr	r1, [r4, #4]
	ldr	r0, .L1768+48
	bl	printf
.L1738:
	adds	r7, r7, #1
	adds	r4, r4, #36
	b	.L1736
.L1737:
	ldr	r3, [sp, #8]
	add	r2, sp, #28
	ldr	fp, .L1768+68
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
	bne	.L1739
	ldr	r1, [r4, #4]
	ldr	r0, .L1768+52
	bl	printf
	str	r5, [r4]
.L1739:
	ldr	r3, [r4, #12]
	cbz	r3, .L1740
	ldr	r2, [r3]
	ldr	r3, [fp]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1740
	ldr	r1, [r4, #4]
	ldr	r0, .L1768+56
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L1740:
	ldr	r3, [r4, #8]
	cmp	r3, #0
	beq	.L1738
	ldr	r2, [r3]
	ldr	r3, [r10]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1738
	ldr	r1, [r4, #4]
	ldr	r0, .L1768+60
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
	b	.L1738
.L1769:
	.align	2
.L1768:
	.word	.LANCHOR18
	.word	.LANCHOR1
	.word	.LANCHOR31
	.word	.LANCHOR25
	.word	.LANCHOR15
	.word	.LANCHOR27
	.word	.LANCHOR23
	.word	.LANCHOR26
	.word	.LANCHOR21
	.word	.LANCHOR20
	.word	.LANCHOR17
	.word	.LANCHOR3
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
	ldr	r3, .L1773
	push	{r4, r5, lr}
	mov	r4, r0
	sub	sp, sp, #108
	ldr	r3, [r3]
	cmp	r0, r3
	bcc	.L1772
	ldr	r5, .L1773+4
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
.L1770:
	mov	r0, r4
	add	sp, sp, #108
	@ sp needed
	pop	{r4, r5, pc}
.L1772:
	movs	r4, #0
	b	.L1770
.L1774:
	.align	2
.L1773:
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
	ldr	r3, .L1820
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	str	r0, [sp, #8]
	ldr	r3, [r3]
	str	r1, [sp, #4]
	cmp	r3, #0
	bne	.L1802
	ldr	r2, .L1820+4
	mov	r10, r3
	mov	r5, r3
	mov	r4, r3
	mov	r8, #36
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #20]
	ldr	r2, .L1820+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #12]
	ldr	r2, .L1820+12
	str	r0, [r2]
	ldr	r2, .L1820+16
	ldrh	fp, [r2]
	ldr	r2, .L1820+20
	ldr	r7, [r2]
	ldr	r2, .L1820+24
	ldr	r2, [r2]
	str	r2, [sp, #16]
	ldr	r2, .L1820+28
	ldrh	r2, [r2]
	str	r2, [sp, #24]
.L1777:
	uxth	r2, r10
	cmp	fp, r2
	bhi	.L1781
	cmp	r5, #0
	beq	.L1775
	ldr	r3, [sp, #12]
	mov	r0, r7
	ldr	r10, .L1820+4
	mov	r8, #0
	mov	r2, r5
	ldr	r7, .L1820+20
	adds	r6, r3, #0
	it	ne
	movne	r6, #1
	strb	r8, [r10]
	mov	r1, r6
	bl	FlashEraseBlocks
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	strb	r3, [r10]
	mov	r10, #36
.L1783:
	uxth	r3, r8
	cmp	r5, r3
	bhi	.L1785
	ldr	r3, [sp, #4]
	cmp	r3, #0
	bne	.L1786
	uxth	r6, r6
	movs	r3, #6
	str	r3, [sp, #16]
	movs	r3, #1
	str	r3, [sp, #12]
.L1787:
	mov	r8, #0
.L1796:
	ldr	r3, .L1820+16
	mov	fp, #0
	mov	r5, fp
	ldrh	r3, [r3]
	str	r3, [sp, #24]
	ldr	r3, .L1820+20
	ldr	r10, [r3]
	ldr	r3, .L1820+32
	ldr	r3, [r3]
	str	r3, [sp, #28]
	ldr	r3, .L1820+36
	ldr	r3, [r3]
	str	r3, [sp, #32]
	ldr	r3, .L1820+28
	ldrh	r3, [r3]
	str	r3, [sp, #36]
.L1788:
	ldr	r3, [sp, #24]
	uxth	r2, fp
	cmp	r3, r2
	bhi	.L1791
	cbz	r5, .L1775
	ldr	fp, .L1820+4
	movs	r3, #1
	mov	r0, r10
	movs	r7, #0
	mov	r2, r6
	mov	r1, r5
	strb	r7, [fp]
	bl	FlashProgPages
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	ldr	r10, .L1820+20
	strb	r3, [fp]
	mov	fp, #36
.L1793:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L1795
	ldr	r3, [sp, #16]
	add	r8, r8, r3
	ldr	r3, [sp, #12]
	uxth	r8, r8
	cmp	r3, r8
	bhi	.L1796
	ldr	r8, .L1820+20
	movs	r7, #0
	mov	r10, #36
.L1797:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L1799
	ldr	r3, [sp, #8]
	cmp	r3, #63
	bls	.L1800
	ldr	r3, [sp, #4]
	cbz	r3, .L1775
.L1800:
	ldr	r3, .L1820+20
	mov	r2, r5
	mov	r1, r6
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L1775:
	mov	r0, r4
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1781:
	mul	r2, r8, r10
	movs	r3, #0
	ldr	r1, [sp, #8]
	str	r3, [r7, r2]
	ldr	r3, .L1820+40
	ldrb	r0, [r3, r10]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r3, [sp, #4]
	mov	r6, r0
	cbz	r3, .L1778
	bl	IsBlkInVendorPart
	cbnz	r0, .L1779
.L1778:
	mov	r0, r6
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1780
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
.L1779:
	add	r10, r10, #1
	b	.L1777
.L1780:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L1779
.L1785:
	mul	r3, r10, r8
	ldr	r2, [r7]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	adds	r3, r3, #1
	bne	.L1784
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L1784:
	add	r8, r8, #1
	b	.L1783
.L1786:
	ldr	r3, .L1820+44
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1820+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1803
	ldr	r3, [sp, #12]
	movs	r6, #1
	lsrs	r3, r3, #2
	str	r3, [sp, #16]
	b	.L1787
.L1803:
	movs	r6, #1
	str	r6, [sp, #16]
	b	.L1787
.L1791:
	movs	r3, #36
	ldr	r1, [sp, #8]
	mul	r2, r3, fp
	movs	r3, #0
	str	r3, [r10, r2]
	ldr	r3, .L1820+40
	ldrb	r0, [r3, fp]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r3, [sp, #4]
	mov	r7, r0
	cbz	r3, .L1789
	bl	IsBlkInVendorPart
	cbnz	r0, .L1790
.L1789:
	mov	r0, r7
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1790
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
.L1790:
	add	fp, fp, #1
	b	.L1788
.L1795:
	mul	r3, fp, r7
	ldr	r2, [r10]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbz	r3, .L1794
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L1794:
	adds	r7, r7, #1
	b	.L1793
.L1799:
	ldr	r3, [sp, #4]
	cbz	r3, .L1798
	mul	r3, r10, r7
	ldr	r2, [r8]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbnz	r3, .L1798
	ldr	r0, [r1, #4]
	movs	r1, #1
	ubfx	r0, r0, #10, #16
	bl	FtlFreeSysBlkQueueIn
.L1798:
	adds	r7, r7, #1
	b	.L1797
.L1802:
	movs	r4, #0
	b	.L1775
.L1821:
	.align	2
.L1820:
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
	ldr	r3, .L1833
	ldr	r4, [r3]
	str	r3, [sp, #12]
	cmp	r4, #0
	bne	.L1824
	ldr	r3, .L1833+4
	mov	r1, r4
	ldr	r7, .L1833+8
	ldr	r5, .L1833+12
	ldr	r3, [r3]
	ldr	r0, [r7]
	mov	r8, r7
	ldr	r6, .L1833+16
	str	r3, [r5, #12]
	ldr	r7, .L1833+20
	ldr	r3, .L1833+24
	ldr	r10, .L1833+56
	str	r0, [r5, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
.L1825:
	ldrh	r3, [r7]
	cmp	r4, r3
	blt	.L1826
	ldr	r6, [r5, #12]
	movs	r2, #16
	ldr	r4, .L1833+28
	movs	r1, #255
	movs	r7, #0
	mov	r0, r6
	bl	ftl_memset
	movw	r3, #61649
	mov	r10, r4
	strh	r3, [r6]	@ movhi
	ldr	r3, [r4, #8]
	str	r7, [sp, #8]
	str	r3, [r6, #4]
	ldrh	r3, [r4]
	strh	r3, [r6, #2]	@ movhi
	ldrh	r3, [r4, #4]
	strh	r3, [r6, #8]	@ movhi
	ldrh	r3, [r4, #6]
	strh	r3, [r6, #10]	@ movhi
	ldr	r3, .L1833+32
	ldr	r3, [r3]
	strh	r3, [r6, #12]	@ movhi
.L1827:
	ldr	r3, [r8]
	mov	fp, #0
	ldrh	r2, [r4, #2]
	ldrh	r1, [r4]
	str	r3, [r5, #8]
	ldr	r3, .L1833+4
	ldrh	r0, [r6, #10]
	str	fp, [r5]
	ldr	r3, [r3]
	str	r3, [r5, #12]
	orr	r3, r2, r1, lsl #10
	str	r3, [r5, #4]
	ldrh	r3, [r4, #4]
	str	r0, [sp]
	ldr	r0, .L1833+36
	bl	printf
	ldr	r3, .L1833+40
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1828
	ldr	r3, [r4, #8]
	ldrh	r2, [r4]
	strh	fp, [r4, #2]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #8]
	str	r3, [r6, #4]
	strh	r2, [r6, #8]	@ movhi
	ldrh	r3, [r4, #4]
	strh	r2, [r4, #4]	@ movhi
	ldr	r2, .L1833+44
	strh	r3, [r4]	@ movhi
	lsls	r3, r3, #10
	ldr	r0, [r2]
	movs	r2, #1
	str	r3, [r5, #4]
	mov	r1, r2
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
.L1828:
	movs	r3, #1
	ldr	r0, .L1833+12
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r10, #2]
	adds	r3, r3, #1
	strh	r3, [r10, #2]	@ movhi
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L1829
	adds	r7, r7, #1
	ldr	r1, [r5, #4]
	uxth	r7, r7
	ldr	r0, .L1833+48
	bl	printf
	cmp	r7, #3
	bls	.L1827
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L1833+52
	bl	printf
	ldr	r2, [sp, #12]
	movs	r3, #1
	str	r3, [r2]
.L1824:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1826:
	ldrh	r2, [r10]
	ldr	r3, [r5, #8]
	ldr	r1, [r6, #4]!
	mul	r0, r4, r2
	lsls	r2, r2, #2
	adds	r4, r4, #1
	add	r0, r3, r0, lsl #2
	bl	ftl_memcpy
	b	.L1825
.L1829:
	ldr	r3, [sp, #8]
	cmp	r3, #0
	bne	.L1824
	movs	r3, #1
	str	r3, [sp, #8]
	b	.L1827
.L1834:
	.align	2
.L1833:
	.word	.LANCHOR76
	.word	.LANCHOR188
	.word	.LANCHOR183
	.word	.LANCHOR202
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
	ldr	r3, .L1900
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L1837
.L1836:
	ldr	r3, .L1900+4
	ldr	r8, .L1900+60
	ldr	r7, .L1900+8
	ldrh	r3, [r3]
	ldrh	r2, [r8]
	add	r3, r3, r2
	ldrh	r2, [r7]
	cmp	r3, r2
	ble	.L1838
	ldr	r1, .L1900+12
	movw	r2, #3139
	ldr	r0, .L1900+16
	bl	printf
	ldr	r1, .L1900+20
	ldr	r0, .L1900+24
	bl	printf
.L1838:
	ldr	r3, .L1900+28
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	cmp	r4, r3
	bne	.L1839
	ldr	r3, .L1900+4
	ldrh	r5, [r3]
	ldr	r3, .L1900+32
	ldr	r3, [r3]
	lsrs	r0, r5, #1
	adds	r1, r0, #1
	mul	r6, r3, r5
	add	r1, r1, r6, lsr #2
	ldr	r6, .L1900+36
	uxth	r1, r1
	ldr	r6, [r6]
	cbz	r6, .L1840
	ldr	r6, .L1900+40
	ldr	r6, [r6]
	cmp	r6, #39
	bhi	.L1840
	cmp	r6, #2
	bls	.L1874
	lsls	r1, r5, #31
	bpl	.L1870
	cmp	r3, #0
	beq	.L1874
.L1870:
	mov	r1, r0
	b	.L1840
.L1839:
	cmp	r2, #1
	bne	.L1874
	ldr	r3, .L1900+44
	ldrh	r3, [r3]
	cmp	r3, #1
	beq	.L1874
	ldr	r3, .L1900+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1874
	ldr	r3, .L1900+4
	ldr	r0, .L1900+36
	ldrh	r3, [r3]
	ldr	r0, [r0]
	lsrs	r1, r3, #3
	cbz	r0, .L1840
	ldr	r0, .L1900+40
	ldr	r0, [r0]
	cmp	r0, #1
	bhi	.L1840
	rsb	r3, r3, r3, lsl #3
	ubfx	r1, r3, #3, #16
.L1840:
	cbz	r1, .L1841
	subs	r1, r1, #1
	uxth	r1, r1
.L1841:
	ldr	r0, .L1900+52
	bl	List_pop_index_node
	ldr	r3, .L1900+4
	mov	r5, r0
	uxth	r10, r0
	ldrh	r3, [r3]
	cbnz	r3, .L1842
	ldr	r1, .L1900+12
	movw	r2, #3159
	ldr	r0, .L1900+16
	bl	printf
	ldr	r1, .L1900+20
	ldr	r0, .L1900+24
	bl	printf
.L1842:
	ldr	r3, .L1900+4
	ldr	r2, .L1900+4
	ldrh	r3, [r3]
	subs	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldrh	r3, [r7]
	cmp	r3, r10
	bls	.L1836
	uxth	r5, r5
	lsls	r3, r5, #1
	str	r3, [sp]
	ldr	r3, .L1900+56
	ldr	r3, [r3]
	ldrh	r6, [r3, r5, lsl #1]
	cmp	r6, #0
	bne	.L1836
	strh	r10, [r4]	@ movhi
	mov	r0, r4
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1844
	ldr	r3, .L1900+56
	movw	r2, #65535
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldr	r3, .L1900+4
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r7]
	cmp	r3, r2
	ble	.L1836
	movw	r2, #3175
	ldr	r1, .L1900+12
	ldr	r0, .L1900+16
	bl	printf
	ldr	r1, .L1900+20
	ldr	r0, .L1900+24
	bl	printf
	b	.L1836
.L1874:
	movs	r1, #0
	b	.L1841
.L1901:
	.align	2
.L1900:
	.word	.LANCHOR76
	.word	.LANCHOR88
	.word	.LANCHOR40
	.word	.LANCHOR203
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
.L1844:
	ldr	r3, .L1902
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r7]
	cmp	r3, r2
	ble	.L1846
	ldr	r1, .L1902+4
	movw	r2, #3178
	ldr	r0, .L1902+8
	bl	printf
	ldr	r1, .L1902+12
	ldr	r0, .L1902+16
	bl	printf
.L1846:
	ldr	r3, .L1902+20
	add	lr, r4, #16
	ldr	r2, .L1902+24
	mov	r8, #0
	ldr	ip, [r3]
	ldrh	r0, [r2]
	movs	r2, #36
	mov	r3, ip
	mla	r0, r2, r0, ip
.L1847:
	cmp	r0, r3
	bne	.L1849
	cbnz	r6, .L1850
	ldr	r1, .L1902+4
	movw	r2, #3190
	ldr	r0, .L1902+8
	bl	printf
	ldr	r1, .L1902+12
	ldr	r0, .L1902+16
	bl	printf
.L1850:
	ldr	r3, .L1902+28
	ldr	r8, .L1902+80
	ldr	r3, [r3]
	cbz	r3, .L1851
	ldr	r3, .L1902+32
	cmp	r4, r3
	bne	.L1851
	ldr	r3, [r8]
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, #40
	itt	hi
	movhi	r3, #0
	strbhi	r3, [r4, #8]
.L1851:
	ldr	r3, .L1902+36
	ldrh	r3, [r3]
	cmp	r3, r10
	bne	.L1852
	ldr	r1, .L1902+4
	movw	r2, #3197
	ldr	r0, .L1902+8
	bl	printf
	ldr	r1, .L1902+12
	ldr	r0, .L1902+16
	bl	printf
.L1852:
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	ldr	r3, .L1902+40
	ldr	fp, .L1902+84
	cmp	r2, #0
	bne	.L1853
	ldr	r1, [r8]
	ldrh	r2, [r1, r5, lsl #1]
	cmp	r2, #0
	beq	.L1854
	ldr	r0, .L1902+44
	ldrh	r0, [r0]
	add	r2, r2, r0
.L1897:
	strh	r2, [r1, r5, lsl #1]	@ movhi
	mov	r0, r10
	ldr	r2, [r3]
	movs	r1, #0
	str	r3, [sp, #4]
	adds	r2, r2, #1
	str	r2, [r3]
	bl	ftl_set_blk_mode
.L1898:
	ldr	r2, [r8]
	ldr	r3, [sp, #4]
	ldrh	r0, [r2, r5, lsl #1]
	ldr	r2, .L1902+48
	ldr	r1, [r2]
	cmp	r0, r1
	ldrh	r1, [r7]
	it	hi
	strhi	r0, [r2]
	ldr	r2, .L1902+44
	ldr	r0, [r3]
	ldr	r3, [fp]
	ldrh	r2, [r2]
	ldr	r7, .L1902+52
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L1902+56
	str	r0, [r3]
	ldr	r3, .L1902+60
	ldr	r2, [r3]
	ldr	r3, [r2, #16]
	adds	r3, r3, #1
	str	r3, [r2, #16]
	ldr	r3, .L1902+20
	ldr	r0, [r3]
	movs	r3, #36
	adds	r1, r0, #4
	mla	r3, r3, r6, r0
	adds	r3, r3, #40
.L1858:
	adds	r1, r1, #36
	cmp	r3, r1
	bne	.L1859
	ldr	r3, .L1902+64
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1860
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	mov	r2, r6
	cmp	r3, #1
	ite	eq
	moveq	r1, #0
	movne	r1, #1
	bl	FlashEraseBlocks
.L1860:
	ldr	r3, .L1902+20
	movs	r7, #0
	mov	r8, r7
	mov	fp, #36
	mov	r2, r6
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L1862:
	uxth	r3, r7
	cmp	r6, r3
	bhi	.L1864
	cmp	r8, #0
	beq	.L1865
	mov	r0, r10
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1865:
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L1866
	ldr	r3, .L1902+68
	movw	r2, #65535
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	b	.L1836
.L1849:
	ldrh	r1, [lr], #2
	movw	fp, #65535
	str	r8, [r3, #8]
	str	r8, [r3, #12]
	cmp	r1, fp
	beq	.L1848
	mla	fp, r2, r6, ip
	adds	r6, r6, #1
	lsls	r1, r1, #10
	uxth	r6, r6
	str	r1, [fp, #4]
.L1848:
	adds	r3, r3, #36
	b	.L1847
.L1854:
	movs	r2, #2
	b	.L1897
.L1853:
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
	b	.L1898
.L1859:
	ldr	r2, [r1, #-36]
	ands	r2, r2, r7
	str	r2, [r1, #-36]
	b	.L1858
.L1864:
	ldr	r2, .L1902+20
	mul	r3, fp, r7
	ldr	r2, [r2]
	adds	r1, r2, r3
	ldr	r2, [r2, r3]
	adds	r3, r2, #1
	bne	.L1863
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
.L1863:
	adds	r7, r7, #1
	b	.L1862
.L1866:
	ldr	r3, .L1902+72
	ldr	r1, .L1902+76
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
	ldr	r2, .L1902+68
	ldr	r1, [sp]
	ldr	r2, [r2]
	strh	r3, [r2, r1]	@ movhi
	ldrh	r3, [r4, #4]
	cbz	r3, .L1867
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1837
.L1867:
	ldr	r1, .L1902+4
	movw	r2, #3256
	ldr	r0, .L1902+8
	bl	printf
	ldr	r1, .L1902+12
	ldr	r0, .L1902+16
	bl	printf
.L1837:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1903:
	.align	2
.L1902:
	.word	.LANCHOR88
	.word	.LANCHOR203
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR77
	.word	.LANCHOR38
	.word	.LANCHOR28
	.word	.LANCHOR91
	.word	.LANCHOR204
	.word	.LANCHOR167
	.word	.LANCHOR48
	.word	.LANCHOR169
	.word	-1024
	.word	.LANCHOR205
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
	ldr	r4, .L1916
	ldrh	r3, [r4]
	cbz	r3, .L1905
	ldr	r8, .L1916+12
	movs	r7, #0
.L1906:
	ldr	r3, .L1916+4
	ldrh	r2, [r3]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L1912
	bl	FtlGcReFreshBadBlk
.L1905:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1912:
	ldr	r2, .L1916+8
	uxth	r3, r7
	mov	r1, r10
	mov	fp, #0
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	mov	r1, r0
.L1907:
	ldrh	r3, [r4]
	uxth	r5, fp
	cmp	r3, r5
	bhi	.L1911
	adds	r7, r7, #1
	b	.L1906
.L1911:
	uxth	r6, fp
	ldrh	r3, [r8, r6, lsl #1]
	cmp	r3, r1
	bne	.L1908
	mov	r0, r1
	str	r1, [sp, #4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	r2, [r4]
	add	r3, r8, r6, lsl #1
	ldr	r1, [sp, #4]
.L1909:
	cmp	r5, r2
	bcc	.L1910
	subs	r2, r2, #1
	strh	r2, [r4]	@ movhi
.L1908:
	add	fp, fp, #1
	b	.L1907
.L1910:
	ldrh	r0, [r3, #2]!
	adds	r5, r5, #1
	uxth	r5, r5
	strh	r0, [r3, #-2]	@ movhi
	b	.L1909
.L1917:
	.align	2
.L1916:
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
	ldr	r3, .L1928
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	bne	.L1919
	ldr	r2, .L1928+4
	ldrh	r1, [r2]
	cmp	r1, r0
	bne	.L1920
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L1921:
	ldr	r5, .L1928+8
	mov	r1, r4
	ldr	r0, .L1928+12
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L1923
	ldr	r1, .L1928+16
	movw	r2, #3367
	ldr	r0, .L1928+20
	bl	printf
	ldr	r1, .L1928+24
	ldr	r0, .L1928+28
	bl	printf
.L1923:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	free_data_superblock
	mov	r0, r4
	bl	FtlGcFreeBadSuperBlk
	ldr	r3, .L1928+32
	ldrh	r2, [r5]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldr	r2, .L1928+36
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1927
	ldr	r1, .L1928+16
	movw	r2, #3370
	ldr	r0, .L1928+20
	bl	printf
	ldr	r1, .L1928+24
	ldr	r0, .L1928+28
	bl	printf
.L1927:
	movs	r3, #1
	b	.L1918
.L1920:
	ldr	r2, .L1928+40
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1918
	ldr	r2, .L1928+44
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1918
	ldr	r2, .L1928+48
	ldrh	r2, [r2]
	cmp	r2, r0
	bne	.L1921
.L1918:
	mov	r0, r3
	pop	{r3, r4, r5, pc}
.L1919:
	bl	List_update_data_list
	movs	r3, #0
	b	.L1918
.L1929:
	.align	2
.L1928:
	.word	.LANCHOR83
	.word	.LANCHOR204
	.word	.LANCHOR85
	.word	.LANCHOR82
	.word	.LANCHOR206
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
	beq	.L1931
	ldr	r5, .L1942
	ldr	r3, [r5]
	ldrh	r2, [r3, r0, lsl #1]
	cmp	r2, #0
	bne	.L1932
	mov	r1, r0
	ldr	r0, .L1942+4
	bl	printf
	ldr	r3, [r5]
	ldrh	r3, [r3, r4, lsl #1]
	cbnz	r3, .L1933
	ldr	r1, .L1942+8
	movw	r2, #3385
	ldr	r0, .L1942+12
	bl	printf
	ldr	r1, .L1942+16
	ldr	r0, .L1942+20
	bl	printf
.L1933:
	ldr	r3, [r5]
	movs	r2, #32
	mov	r1, r4
	ldr	r0, .L1942+24
	strh	r2, [r3, r4, lsl #1]	@ movhi
	bl	test_node_in_list
	cbz	r0, .L1934
	ldr	r6, .L1942+28
	mov	r1, r4
	ldr	r0, .L1942+24
	bl	List_remove_node
	ldrh	r3, [r6]
	cbnz	r3, .L1935
	ldr	r1, .L1942+8
	movw	r2, #3389
	ldr	r0, .L1942+12
	bl	printf
	ldr	r1, .L1942+16
	ldr	r0, .L1942+20
	bl	printf
.L1935:
	ldrh	r3, [r6]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r6]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r3, [r5]
	mov	r1, r4
	ldr	r0, .L1942+32
	ldrh	r2, [r3, r4, lsl #1]
	bl	printf
.L1934:
	mov	r0, r4
	bl	FtlGcRefreshBlock
.L1938:
	movs	r5, #0
	b	.L1930
.L1932:
	subs	r2, r2, #1
	strh	r2, [r3, r0, lsl #1]	@ movhi
.L1931:
	ldr	r6, .L1942+36
	movw	r3, #65535
	ldrh	r0, [r6]
	cmp	r0, r3
	bne	.L1937
	strh	r4, [r6]	@ movhi
	b	.L1938
.L1937:
	cmp	r4, r0
	beq	.L1938
	bl	update_vpc_list
	ldr	r3, .L1942+40
	adds	r5, r0, #0
	ldr	r2, .L1942+44
	it	ne
	movne	r5, #1
	strh	r4, [r6]	@ movhi
	ldr	r3, [r3]
	ldr	r2, [r2]
	subs	r3, r3, r2
	asrs	r2, r3, #1
	ldr	r3, .L1942+48
	muls	r3, r2, r3
	ldr	r2, .L1942
	ldr	r2, [r2]
	uxth	r1, r3
	ldrh	r2, [r2, r1, lsl #1]
	cbnz	r2, .L1930
	cmp	r4, r1
	beq	.L1930
	ldr	r1, .L1942+8
	movw	r2, #3410
	ldr	r0, .L1942+12
	bl	printf
	ldr	r1, .L1942+16
	ldr	r0, .L1942+20
	bl	printf
.L1930:
	mov	r0, r5
	pop	{r4, r5, r6, pc}
.L1943:
	.align	2
.L1942:
	.word	.LANCHOR83
	.word	.LC36
	.word	.LANCHOR207
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
	beq	.L1944
	ldrh	r2, [r0]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1944
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r5, .L1955
	ldr	r6, .L1955+4
	adds	r3, r3, #8
	ldrh	r3, [r0, r3, lsl #1]
.L1948:
	movw	r2, #65535
	cmp	r3, r2
	beq	.L1950
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1951
	ldrb	r1, [r5]	@ zero_extendqisi2
	cbnz	r1, .L1951
	ldrh	r1, [r4, #2]
	ldrh	r1, [r6, r1, lsl #1]
	cmp	r1, r2
	bne	.L1951
	ldrh	r3, [r4, #4]
	ldrh	r0, [r4]
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	ldrh	r2, [r4, #4]
	cbnz	r2, .L1950
	ldrh	r3, [r4, #2]
	strb	r2, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	pop	{r4, r5, r6, pc}
.L1950:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldr	r2, .L1955+8
	adds	r3, r3, #1
	ldrh	r2, [r2]
	uxtb	r3, r3
	strb	r3, [r4, #6]
	cmp	r2, r3
	bne	.L1949
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
.L1949:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r3, [r4, r3, lsl #1]
	b	.L1948
.L1951:
	ldrb	r2, [r5]	@ zero_extendqisi2
	cbz	r2, .L1944
	cmp	r3, #1
	bne	.L1944
	ldr	r3, .L1955+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1944
	ldr	r3, .L1955+16
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	movs	r3, #0
	ldr	r2, .L1955+20
	strh	r3, [r4, #4]	@ movhi
	strb	r3, [r4, #6]
	ldrh	r2, [r2]
	strh	r2, [r4, #2]	@ movhi
.L1944:
	pop	{r4, r5, r6, pc}
.L1956:
	.align	2
.L1955:
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
	bne	.L1958
	ldr	r1, .L1979
	movw	r2, #3307
	ldr	r0, .L1979+4
	bl	printf
	ldr	r1, .L1979+8
	ldr	r0, .L1979+12
	bl	printf
.L1958:
	ldr	r5, .L1979+16
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L1959
	ldr	r1, .L1979
	movw	r2, #3308
	ldr	r0, .L1979+4
	bl	printf
	ldr	r1, .L1979+8
	ldr	r0, .L1979+12
	bl	printf
.L1959:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1960
	ldr	r1, .L1979
	movw	r2, #3309
	ldr	r0, .L1979+4
	bl	printf
	ldr	r1, .L1979+8
	ldr	r0, .L1979+12
	bl	printf
.L1960:
	movs	r3, #0
	ldr	r7, .L1979+20
	strb	r3, [r4, #10]
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldr	r6, .L1979+24
	adds	r3, r3, #8
	ldrh	r2, [r4, r3, lsl #1]
.L1961:
	movw	r0, #65535
	cmp	r2, r0
	beq	.L1962
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	ldrh	r1, [r4, #2]
	cmp	r3, #1
	ldrh	r3, [r4, #4]
	bne	.L1964
	ldrb	ip, [r6]	@ zero_extendqisi2
	cmp	ip, #0
	bne	.L1964
	ldr	ip, .L1979+28
	ldrh	ip, [ip, r1, lsl #1]
	cmp	ip, r0
	bne	.L1964
	subs	r3, r3, #1
	ldrh	r0, [r4]
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
.L1962:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldrh	r2, [r7]
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r2, r3
	strb	r3, [r4, #6]
	bne	.L1963
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
.L1963:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r2, [r4, r3, lsl #1]
	b	.L1961
.L1964:
	ldr	r8, .L1979+24
	orr	r6, r1, r2, lsl #10
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
.L1965:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	movw	r2, #65535
	ldrh	r0, [r7]
.L1967:
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
	beq	.L1967
	strb	r3, [r4, #6]
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1968
	ldrb	r1, [r8]	@ zero_extendqisi2
	ldrh	r3, [r4, #2]
	cbnz	r1, .L1969
	ldr	r1, .L1979+28
	ldrh	r3, [r1, r3, lsl #1]
	cmp	r3, r2
	bne	.L1968
	ldrh	r3, [r4, #4]
	cbz	r3, .L1968
	subs	r3, r3, #1
	ldrh	r0, [r4]
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	b	.L1965
.L1969:
	ldr	r2, .L1979+32
	ldrh	r2, [r2]
	cmp	r3, r2
	bcc	.L1968
	ldr	r3, .L1979+36
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
.L1968:
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L1957
	ldrh	r3, [r4, #4]
	cbz	r3, .L1957
	ldr	r1, .L1979
	movw	r2, #3353
	ldr	r0, .L1979+4
	bl	printf
	ldr	r1, .L1979+8
	ldr	r0, .L1979+12
	bl	printf
.L1957:
	mov	r0, r6
	pop	{r4, r5, r6, r7, r8, pc}
.L1980:
	.align	2
.L1979:
	.word	.LANCHOR208
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
	ldr	r2, .L2001
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, [r2]
	str	r2, [sp, #4]
	cmp	r3, #0
	bne	.L1983
	ldr	r4, .L2001+4
	ldr	fp, .L2001+108
	ldr	r8, .L2001+112
	ldr	r5, .L2001+8
	ldr	r0, [fp]
	ldr	r6, [r8]
	ldrh	r2, [r4]
	str	r0, [r5, #8]
	str	r6, [r5, #12]
	strh	r2, [r6, #2]	@ movhi
	movw	r2, #61604
	ldr	r7, .L2001+12
	strh	r2, [r6]	@ movhi
	str	r3, [r6, #12]
	ldr	ip, .L2001+116
	ldr	r2, [r4, #8]
	str	r3, [r6, #8]
	ldr	r3, .L2001+16
	str	r2, [r6, #4]
	stm	r7, {r3, ip}
	ldrh	r3, [r4, #6]
	strh	r3, [r7, #8]	@ movhi
	ldr	r3, .L2001+20
	ldrh	r3, [r3]
	strb	r3, [r7, #10]
	ldr	r3, .L2001+24
	ldrh	r2, [r3]
	ldrh	r1, [r3, #2]
	strh	r2, [r7, #14]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r7, #11]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L2001+28
	strh	r2, [r7, #16]	@ movhi
	ldrh	r2, [r3]
	ldrh	r1, [r3, #2]
	strh	r2, [r7, #18]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r7, #12]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L2001+32
	strh	r2, [r7, #20]	@ movhi
	ldrh	r2, [r3]
	strh	r2, [r7, #22]	@ movhi
	ldrh	r1, [r3, #2]
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r7, #13]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L2001+36
	movs	r1, #255
	strh	r2, [r7, #24]	@ movhi
	ldr	r3, [r3]
	str	r3, [r7, #32]
	ldr	r3, .L2001+40
	ldr	r3, [r3]
	str	r3, [r7, #40]
	ldr	r3, .L2001+44
	ldr	r3, [r3]
	str	r3, [r7, #36]
	ldr	r3, .L2001+48
	ldrh	r3, [r3]
	strh	r3, [r7, #44]	@ movhi
	ldr	r3, .L2001+52
	ldrh	r3, [r3]
	strh	r3, [r7, #46]	@ movhi
	ldr	r3, .L2001+56
	ldrh	r2, [r3]
	bl	ftl_memset
	mov	r1, r7
	ldr	r7, .L2001+60
	movs	r2, #48
	ldr	r0, [r5, #8]
	bl	ftl_memcpy
	ldrh	r2, [r7]
	ldr	r3, .L2001+64
	ldr	r0, [r5, #8]
	ldr	r1, [r3]
	lsls	r2, r2, #1
	adds	r0, r0, #48
	bl	ftl_memcpy
	ldrh	r0, [r7]
	ldr	r3, [r5, #8]
	ldr	r1, .L2001+68
	lsrs	r2, r0, #3
	adds	r0, r0, #24
	lsls	r0, r0, #1
	ldr	r1, [r1]
	adds	r2, r2, #4
	bic	r0, r0, #3
	add	r0, r0, r3
	bl	ftl_memcpy
	ldr	r3, .L2001+72
	ldrh	r3, [r3]
	cbz	r3, .L1984
	ldrh	r0, [r7]
	ldr	r3, .L2001+76
	ldr	r1, .L2001+80
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
.L1984:
	movs	r7, #0
	movw	r10, #65535
	movs	r0, #0
	bl	FtlUpdateVaildLpn
.L1985:
	ldr	r3, [fp]
	ldrh	r1, [r4, #2]
	ldrh	r2, [r4]
	str	r3, [r5, #8]
	ldr	r3, [r8]
	str	r3, [r5, #12]
	orr	r3, r1, r2, lsl #10
	str	r3, [r5, #4]
	ldr	r3, .L2001+84
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r1, r3
	blt	.L1986
	movs	r3, #0
	ldrh	r10, [r4, #4]
	strh	r3, [r4, #2]	@ movhi
	strh	r2, [r4, #4]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L2001+40
	ldr	r1, .L2001+40
	strh	r0, [r4]	@ movhi
	ldr	r3, [r3]
	adds	r2, r3, #1
	str	r3, [r4, #8]
	str	r2, [r1]
	lsls	r2, r0, #10
	str	r2, [r5, #4]
	str	r3, [r6, #4]
	strh	r0, [r6, #2]	@ movhi
.L1986:
	movs	r3, #1
	ldr	r0, .L2001+8
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	ldr	r2, [r5]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r1, r2, #1
	strh	r3, [r4, #2]	@ movhi
	bne	.L1987
	cmp	r3, #1
	bne	.L1988
	ldr	r1, .L2001+88
	movw	r2, #1217
	ldr	r0, .L2001+92
	bl	printf
	ldr	r1, .L2001+96
	ldr	r0, .L2001+100
	bl	printf
.L1988:
	ldrh	r3, [r4, #2]
	adds	r7, r7, #1
	uxth	r7, r7
	cmp	r3, #1
	itttt	eq
	ldreq	r3, .L2001+84
	ldrheq	r3, [r3]
	addeq	r3, r3, #-1
	strheq	r3, [r4, #2]	@ movhi
	cmp	r7, #3
	bls	.L1985
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L2001+104
	bl	printf
	ldr	r2, [sp, #4]
	movs	r3, #1
	str	r3, [r2]
.L1983:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1987:
	cmp	r3, #1
	beq	.L1985
	cmp	r2, #256
	beq	.L1985
	movw	r3, #65535
	cmp	r10, r3
	beq	.L1983
	movs	r1, #1
	mov	r0, r10
	bl	FtlFreeSysBlkQueueIn
	b	.L1983
.L2002:
	.align	2
.L2001:
	.word	.LANCHOR76
	.word	.LANCHOR209
	.word	.LANCHOR202
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
	.word	.LANCHOR0
	.word	.LANCHOR69
	.word	.LANCHOR66
	.word	.LANCHOR131
	.word	.LANCHOR53
	.word	.LANCHOR210
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC38
	.word	.LANCHOR183
	.word	.LANCHOR188
	.word	1342177363
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
	ldr	r3, .L2018
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	sub	sp, sp, #44
	ldr	r8, [r3]
	cmp	r8, #0
	bne	.L2003
	ldr	r3, .L2018+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2014
	ldrb	r3, [r0, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L2014
	ldrh	r6, [r0, #4]
	mov	r8, r3
.L2005:
	mov	r3, #-1
	ldr	r2, .L2018+8
	str	r3, [sp, #20]
	movs	r7, #0
	ldr	r3, .L2018+12
	ldr	r5, [r2]
	mvn	r2, #2
	ldr	r10, .L2018+24
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
.L2006:
	adds	r6, r6, #-1
	bcc	.L2009
	ldrh	r3, [r4, #4]
	cbnz	r3, .L2007
.L2009:
	ldr	r3, .L2018+16
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldr	r3, .L2018+20
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
.L2003:
	add	sp, sp, #44
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L2014:
	movs	r6, #12
	b	.L2005
.L2007:
	mov	r0, r4
	bl	get_new_active_ppa
	str	r0, [sp, #8]
	adds	r0, r0, #1
	beq	.L2009
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
	b	.L2006
.L2019:
	.align	2
.L2018:
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
	ldr	r3, .L2030
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r5, .L2030+4
	ldr	r3, [r3]
	ldr	r7, .L2030+8
	ldr	r10, .L2030+20
	str	r3, [r5, #8]
	ldr	r3, .L2030+12
	ldr	r8, [r3]
	str	r8, [r5, #12]
.L2021:
	ldr	r3, .L2030+16
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L2026
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2026:
	ldrh	r4, [r10]
	movw	r3, #65535
	ldr	fp, .L2030+4
	strh	r3, [r7, #2]!	@ movhi
	subs	r4, r4, #1
	uxth	r4, r4
.L2022:
	ldrh	r3, [r10]
	sub	r2, r3, #15
	cmp	r2, r4
	bgt	.L2024
	mla	r3, r6, r3, r4
	movs	r2, #1
	mov	r1, r2
	mov	r0, fp
	lsls	r3, r3, #10
	str	r3, [r5, #4]
	bl	FlashReadPages
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L2023
	ldrh	r2, [r8]
	movw	r3, #61664
	cmp	r2, r3
	bne	.L2023
	strh	r4, [r7]	@ movhi
.L2024:
	adds	r6, r6, #1
	b	.L2021
.L2023:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L2022
.L2031:
	.align	2
.L2030:
	.word	.LANCHOR183
	.word	.LANCHOR202
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
	ldreq	r3, .L2044
	sub	sp, sp, #104
	lsl	r7, r0, #10
	mov	r2, r1
	it	ne
	ldrne	r3, .L2044+4
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
	bne	.L2035
.L2036:
	cmp	r6, r5
	ble	.L2039
.L2035:
	mov	r0, r5
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2039:
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
	bne	.L2037
	ldr	r3, [sp, #44]
	adds	r3, r3, #1
	bne	.L2037
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L2037
	subs	r4, r4, #1
	sxth	r5, r4
	b	.L2036
.L2037:
	adds	r4, r4, #1
	sxth	r6, r4
	b	.L2036
.L2045:
	.align	2
.L2044:
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
	ldr	r8, .L2075+48
	ldr	r4, .L2075
	ldr	r3, [r8]
	ldr	r7, .L2075+4
	mov	r10, r4
	str	r3, [r4, #8]
	ldr	r3, .L2075+8
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FtlBbtMemInit
	ldrh	r5, [r7]
	subs	r5, r5, #1
	uxth	r5, r5
.L2047:
	ldrh	r3, [r7]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L2050
	lsls	r3, r5, #10
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L2048
	ldr	r3, [r4, #4]
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	adds	r3, r3, #1
	str	r3, [r4, #4]
	bl	FlashReadPages
.L2048:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L2049
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L2049
	ldr	r3, .L2075+12
	ldr	r2, [r6, #4]
	strh	r5, [r3]	@ movhi
	str	r2, [r3, #8]
	ldrh	r2, [r6, #8]
	strh	r2, [r3, #4]	@ movhi
.L2050:
	ldr	r5, .L2075+12
	movw	r2, #65535
	ldrh	r3, [r5]
	cmp	r3, r2
	beq	.L2064
	ldrh	r3, [r5, #4]
	cmp	r3, r2
	beq	.L2054
	lsls	r3, r3, #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L2075
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L2054
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L2054
	ldr	r3, [r6, #4]
	ldr	r2, [r5, #8]
	cmp	r3, r2
	bls	.L2054
	ldrh	r2, [r5, #4]
	str	r3, [r5, #8]
	ldrh	r3, [r6, #8]
	strh	r2, [r5]	@ movhi
	strh	r3, [r5, #4]	@ movhi
.L2054:
	ldr	r10, .L2075
	movs	r1, #1
	ldrh	r0, [r5]
	bl	FtlGetLastWrittenPage
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r5, #2]	@ movhi
.L2056:
	cmp	r7, #0
	bge	.L2059
	ldr	r1, .L2075+16
	movw	r2, #335
	ldr	r0, .L2075+20
	bl	printf
	ldr	r1, .L2075+24
	ldr	r0, .L2075+28
	bl	printf
.L2058:
	ldrh	r3, [r6, #10]
	ldrh	r0, [r6, #12]
	strh	r3, [r5, #6]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L2061
	ldr	r3, .L2075+32
	ldr	r2, [r3]
	cmp	r0, r2
	beq	.L2061
	ldr	r3, .L2075+36
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	cmp	r2, r3
	bcs	.L2061
	cmp	r0, r3
	bcs	.L2061
	bl	FtlSysBlkNumInit
.L2061:
	ldr	r6, .L2075+40
	movs	r5, #0
	ldr	r7, .L2075+44
	ldr	r8, .L2075+52
.L2062:
	ldrh	r3, [r7]
	cmp	r5, r3
	bcc	.L2063
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2049:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2047
.L2059:
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
	beq	.L2057
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	beq	.L2058
.L2057:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L2056
.L2063:
	ldrh	r2, [r8]
	ldr	r1, [r4, #8]
	ldr	r0, [r6, #4]!
	lsls	r2, r2, #2
	mla	r1, r5, r2, r1
	adds	r5, r5, #1
	bl	ftl_memcpy
	b	.L2062
.L2064:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2076:
	.align	2
.L2075:
	.word	.LANCHOR202
	.word	.LANCHOR51
	.word	.LANCHOR188
	.word	.LANCHOR74
	.word	.LANCHOR211
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
	blt	.L2078
	uxth	r0, r0
	ldrh	r8, [r5, r0, lsl #1]
	cmp	r8, #0
	beq	.L2078
	ldr	r3, [r4, #32]
	cbnz	r3, .L2078
	movs	r2, #1
	str	r2, [r4, #32]
	strh	r3, [r5, r0, lsl #1]	@ movhi
	ldrh	r3, [r4, #8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	ldr	r3, .L2090
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2079
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L2079:
	ldr	r5, .L2090+4
	movs	r6, #0
.L2080:
	ldrh	r3, [r4, #6]
	uxth	r10, r6
	cmp	r3, r10
	bhi	.L2086
	movs	r1, #1
	mov	r0, r8
	bl	FtlFreeSysBlkQueueIn
	movs	r3, #0
	str	r3, [r4, #32]
.L2078:
	ldr	r3, .L2090
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2084
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
	b	.L2084
.L2086:
	ldr	r3, [sp]
	uxth	fp, r6
	add	r3, r3, fp, lsl #2
	str	r3, [sp, #4]
	ldr	r3, [sp]
	ldr	r2, [r3, fp, lsl #2]
	cmp	r8, r2, lsr #10
	bne	.L2081
	ldr	r3, .L2090+8
	str	r2, [r5, #4]
	movs	r2, #1
	ldr	r0, .L2090+4
	ldr	r1, [r3]
	str	r1, [r5, #8]
	ldr	r1, .L2090+12
	ldr	r7, [r1]
	mov	r1, r2
	str	r7, [r5, #12]
	bl	FlashReadPages
	ldrh	r2, [r7, #8]
	cmp	r2, r10
	beq	.L2082
	ldr	r1, .L2090+16
	movw	r2, #661
	ldr	r0, .L2090+20
	bl	printf
	ldr	r1, .L2090+24
	ldr	r0, .L2090+28
	bl	printf
.L2082:
	ldr	r2, [r5]
	adds	r2, r2, #1
	ldrh	r2, [r7, #8]
	bne	.L2083
.L2085:
	ldr	r1, [sp, #4]
	movs	r3, #0
	ldr	r0, .L2090+32
	str	r3, [r1]
	ldr	r1, [r5, #4]
	bl	printf
	ldr	r3, .L2090+36
	movs	r2, #1
	str	r2, [r3]
.L2084:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2083:
	cmp	r2, r10
	bne	.L2085
	ldrh	r0, [r7]
	ldrh	r1, [r4, #4]
	cmp	r0, r1
	bne	.L2085
	ldr	r2, [r5, #8]
	mov	r1, fp
	mov	r0, r4
	bl	FtlMapWritePage
.L2081:
	adds	r6, r6, #1
	b	.L2080
.L2091:
	.align	2
.L2090:
	.word	.LANCHOR53
	.word	.LANCHOR202
	.word	.LANCHOR184
	.word	.LANCHOR188
	.word	.LANCHOR212
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
	ldr	r3, .L2106
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r5, [r3]
	cbnz	r5, .L2093
	ldrh	r3, [r0]
	movw	r2, #65535
	ldr	r6, [r0, #12]
	cmp	r3, r2
	bne	.L2094
	ldrh	r3, [r0, #8]
	cbz	r3, .L2095
	ldr	r1, .L2106+4
	movw	r2, #697
	ldr	r0, .L2106+8
	bl	printf
	ldr	r1, .L2106+12
	ldr	r0, .L2106+16
	bl	printf
.L2095:
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
.L2093:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2094:
	ldrh	r8, [r6, r3, lsl #1]
	movs	r1, #255
	ldrh	r3, [r0, #2]
	ldr	r7, .L2106+20
	ldr	fp, .L2106+40
	ldr	r10, [r0, #24]
	orr	r3, r3, r8, lsl #10
	ldr	r0, [fp]
	str	r3, [r7, #4]
	ldr	r3, .L2106+24
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
	ldr	r3, .L2106+28
	ldrh	r2, [r3]
	lsls	r2, r2, #3
	bl	ftl_memset
	ldrh	ip, [r4, #6]
	mov	r3, r5
	ldr	r1, [fp]
	mov	r2, r5
.L2096:
	uxth	r0, r3
	cmp	ip, r0
	bhi	.L2098
	ldr	r3, .L2106+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2099
	ldr	r3, .L2106+36
	ldr	r0, [r7, #8]
	ldrh	r1, [r3]
	bl	js_hash
	str	r0, [r6, #12]
.L2099:
	movs	r2, #1
	movs	r3, #0
	mov	r1, r2
	ldr	r0, .L2106+20
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	mov	r0, r4
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	bl	ftl_map_blk_gc
	b	.L2093
.L2098:
	ldr	r0, [r10, r3, lsl #2]
	cmp	r8, r0, lsr #10
	bne	.L2097
	adds	r2, r2, #1
	uxth	r2, r2
	str	r3, [r1, r2, lsl #3]
	add	r5, r1, r2, lsl #3
	ldr	r0, [r10, r3, lsl #2]
	str	r0, [r5, #4]
.L2097:
	adds	r3, r3, #1
	b	.L2096
.L2107:
	.align	2
.L2106:
	.word	.LANCHOR76
	.word	.LANCHOR213
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR202
	.word	.LANCHOR188
	.word	.LANCHOR53
	.word	.LANCHOR1
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
	ldr	r10, .L2134+44
	mov	r8, r1
	movs	r6, #0
	str	r2, [sp, #4]
.L2109:
	ldr	r2, .L2134
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	ldrh	r3, [r10]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L2110
	ldrh	r2, [r4]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2111
.L2110:
	mov	r0, r4
	bl	Ftl_write_map_blk_to_last_page
.L2111:
	ldr	r3, .L2134+4
	ldr	r2, [r3]
	str	r3, [sp, #8]
	cmp	r2, #0
	bne	.L2129
	ldrh	r2, [r4]
	ldr	r3, [r4, #12]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L2113
	ldr	r1, .L2134+8
	movw	r2, #759
	ldr	r0, .L2134+12
	bl	printf
	ldr	r1, .L2134+16
	ldr	r0, .L2134+20
	bl	printf
.L2113:
	ldrh	r2, [r4]
	ldrh	r3, [r4, #10]
	cmp	r2, r3
	bcc	.L2114
	ldr	r1, .L2134+8
	mov	r2, #760
	ldr	r0, .L2134+12
	bl	printf
	ldr	r1, .L2134+16
	ldr	r0, .L2134+20
	bl	printf
.L2114:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r4, #12]
	ldr	r5, .L2134+24
	ldrh	r7, [r3, r2, lsl #1]
	movs	r2, #16
	ldrh	r3, [r4, #2]
	mov	fp, r5
	orr	r3, r3, r7, lsl #10
	str	r3, [r5, #4]
	ldr	r3, [sp, #4]
	str	r3, [r5, #8]
	ldr	r3, .L2134+28
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
	ldr	r2, .L2134+32
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L2115
	ldr	r2, .L2134+36
	ldr	r0, [r5, #8]
	ldrh	r1, [r2]
	bl	js_hash
	ldr	r3, [sp, #12]
	str	r0, [r3, #12]
.L2115:
	movs	r3, #1
	ldr	r0, .L2134+24
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	ldr	r2, [r5]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r1, r2, #1
	strh	r3, [r4, #2]	@ movhi
	bne	.L2116
	ldr	r1, [r5, #4]
	adds	r6, r6, #1
	ldr	r0, .L2134+40
	uxth	r6, r6
	bl	printf
	ldrh	r3, [r4, #2]
	cmp	r3, #2
	itttt	ls
	ldrls	r3, .L2134+44
	ldrhls	r3, [r3]
	addls	r3, r3, #-1
	strhls	r3, [r4, #2]	@ movhi
	cmp	r6, #3
	bls	.L2109
	mov	r2, r6
	ldr	r1, [fp, #4]
	ldr	r0, .L2134+48
	bl	printf
	ldr	r2, [sp, #8]
	movs	r3, #1
	str	r3, [r2]
.L2129:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2116:
	cbz	r2, .L2119
	cmp	r3, #1
	strh	r7, [r4, #40]	@ movhi
	bne	.L2120
.L2121:
	movs	r3, #0
	str	r3, [r4, #36]
	b	.L2109
.L2120:
	cmp	r2, #256
.L2133:
	beq	.L2121
	ldr	r3, [r4, #36]
	cmp	r3, #0
	bne	.L2121
	ldr	r2, [fp, #4]
	ldr	r3, [r4, #24]
	str	r2, [r3, r8, lsl #2]
	b	.L2129
.L2119:
	cmp	r3, #1
	b	.L2133
.L2135:
	.align	2
.L2134:
	.word	.LANCHOR165
	.word	.LANCHOR76
	.word	.LANCHOR214
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR202
	.word	.LANCHOR188
	.word	.LANCHOR1
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
	ldr	r5, .L2137
	muls	r4, r0, r4
	ldr	r0, .L2137+4
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
.L2138:
	.align	2
.L2137:
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
	ldr	r5, .L2143
	ldr	r6, .L2143+4
.L2140:
	ldrh	r3, [r5]
	uxth	r0, r4
	cmp	r3, r0
	bhi	.L2142
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L2142:
	ldr	r2, [r6]
	uxth	r3, r4
	movs	r1, #12
	mla	r3, r1, r3, r2
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L2141
	bl	flush_l2p_region
.L2141:
	adds	r4, r4, #1
	b	.L2140
.L2144:
	.align	2
.L2143:
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
	ldr	r3, .L2157
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	str	r2, [sp]
	adds	r2, r0, r1
	mov	r7, r0
	mov	r5, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L2153
	ldr	r3, .L2157+4
	mov	r8, #0
	ldrh	r6, [r3]
	lsr	r6, r0, r6
	lsl	fp, r6, #2
.L2147:
	cbnz	r5, .L2152
.L2145:
	mov	r0, r8
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2152:
	ldr	r3, .L2157+8
	mov	r0, r7
	ldr	r10, .L2157+24
	ldr	r3, [r3]
	ldr	r2, [r3, fp]
	ldr	r3, .L2157+12
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
	cbz	r2, .L2149
	cmp	r4, r3
	beq	.L2149
	ldr	r3, [r10]
	add	r0, sp, #20
	str	r2, [sp, #24]
	movs	r2, #1
	mov	r1, r2
	str	r3, [sp, #28]
	movs	r3, #0
	str	r3, [sp, #32]
	bl	FlashReadPages
.L2150:
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
	ldr	r0, .L2157+16
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
	b	.L2147
.L2149:
	ldr	r3, .L2157+20
	movs	r1, #0
	ldr	r0, [r10]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L2150
.L2153:
	mov	r8, #-1
	b	.L2145
.L2158:
	.align	2
.L2157:
	.word	.LANCHOR50
	.word	.LANCHOR56
	.word	.LANCHOR194
	.word	.LANCHOR55
	.word	.LANCHOR215
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
	ldr	r2, .L2161
	ldr	r3, .L2161+4
	ldr	r1, [r2]
	cmp	r1, r3
	bne	.L2159
	ldr	r3, .L2161+8
	movs	r1, #1
	movs	r0, #0
	str	r3, [r2, #4]
	ldr	r3, .L2161+12
	ldr	r3, [r3]
	str	r3, [r2, #88]
	ldr	r3, .L2161+16
	ldr	r3, [r3]
	str	r3, [r2, #92]
	ldr	r3, .L2161+20
	ldr	r3, [r3]
	str	r3, [r2, #8]
	ldr	r3, .L2161+24
	ldr	r3, [r3]
	str	r3, [r2, #12]
	ldr	r3, .L2161+28
	ldr	r3, [r3]
	str	r3, [r2, #16]
	ldr	r3, .L2161+32
	ldr	r3, [r3]
	str	r3, [r2, #20]
	ldr	r3, .L2161+36
	ldr	r3, [r3]
	str	r3, [r2, #28]
	ldr	r3, .L2161+40
	ldr	r3, [r3]
	str	r3, [r2, #32]
	ldr	r3, .L2161+44
	ldr	r3, [r3]
	str	r3, [r2, #36]
	ldr	r3, .L2161+48
	ldr	r3, [r3]
	str	r3, [r2, #40]
	ldr	r3, .L2161+52
	ldr	r3, [r3]
	str	r3, [r2, #44]
	ldr	r3, .L2161+56
	ldr	r3, [r3]
	str	r3, [r2, #48]
	ldr	r3, .L2161+60
	ldr	r3, [r3]
	str	r3, [r2, #60]
	ldr	r3, .L2161+64
	ldr	r3, [r3]
	str	r3, [r2, #64]
	b	FtlVendorPartWrite
.L2159:
	bx	lr
.L2162:
	.align	2
.L2161:
	.word	.LANCHOR138
	.word	1179929683
	.word	1342177363
	.word	.LANCHOR216
	.word	.LANCHOR217
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
	ldr	r3, .L2170
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L2168
	ldr	r3, .L2170+4
	ldr	r3, [r3]
	cmp	r3, #39
	ite	hi
	movhi	r3, #32
	movls	r3, #4
.L2164:
	ldr	r1, .L2170+8
	ldrh	r2, [r1]
	cmp	r2, #31
	ittt	ls
	addls	r2, r2, #1
	movls	r3, #1
	strhls	r2, [r1]	@ movhi
	ldr	r2, .L2170+12
	cbnz	r0, .L2166
	ldr	r1, [r2]
	ldr	r0, [r1, #20]
	ldr	r1, [r1, #16]
	add	r3, r3, r0
	cmp	r1, r3
	bcc	.L2167
.L2166:
	ldr	r2, [r2]
	movs	r0, #64
	ldr	r3, [r2, #16]
	str	r3, [r2, #20]
	ldr	r3, .L2170+16
	str	r3, [r2]
	ldr	r3, .L2170+20
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
.L2167:
	movs	r0, #0
	pop	{r3, pc}
.L2168:
	movs	r3, #32
	b	.L2164
.L2171:
	.align	2
.L2170:
	.word	.LANCHOR28
	.word	.LANCHOR170
	.word	.LANCHOR218
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
	ldr	r3, .L2199
	push	{r4, r5, r6, lr}
	mov	r4, r0
	ldrh	r5, [r0]
	ldrh	r3, [r3]
	cmp	r3, r5
	bcs	.L2173
	ldr	r1, .L2199+4
	mov	r2, #3264
	ldr	r0, .L2199+8
	bl	printf
	ldr	r1, .L2199+12
	ldr	r0, .L2199+16
	bl	printf
.L2173:
	ldr	r3, .L2199+20
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2174
	movw	r3, #65535
	cmp	r5, r3
	beq	.L2175
	ldr	r3, .L2199+24
	mov	r0, r5
	ldr	r3, [r3]
	ldrh	r3, [r3, r5, lsl #1]
	cbz	r3, .L2176
	bl	INSERT_DATA_LIST
.L2175:
	movs	r3, #0
	strb	r3, [r4, #8]
	ldr	r3, .L2199+28
	cmp	r4, r3
	beq	.L2177
	ldr	r3, .L2199+32
	ldrh	r2, [r3]
	cmp	r2, #1
	beq	.L2177
	ldr	r3, .L2199+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2178
.L2177:
	movs	r3, #1
	strb	r3, [r4, #8]
.L2179:
	ldr	r6, .L2199+40
	movw	r2, #65535
	ldrh	r0, [r6]
	cmp	r0, r2
	beq	.L2184
	cmp	r5, r0
	bne	.L2185
	ldr	r3, .L2199+24
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L2186
.L2185:
	bl	update_vpc_list
.L2186:
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
.L2184:
	mov	r0, r4
	bl	allocate_data_superblock
	bl	l2p_flush
	movs	r0, #0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2174:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L2176:
	bl	INSERT_FREE_LIST
	b	.L2175
.L2178:
	ldr	r3, .L2199+44
	cmp	r4, r3
	bne	.L2179
	cmp	r2, #3
	beq	.L2181
	ldr	r2, .L2199+48
	ldr	r2, [r2]
	cmp	r2, #1
	bne	.L2182
.L2181:
	movs	r2, #1
	strb	r2, [r3, #8]
.L2182:
	ldr	r2, .L2199+52
	ldr	r2, [r2]
	cmp	r2, #0
	beq	.L2179
	ldr	r2, .L2199+56
	ldr	r2, [r2]
	cmp	r2, #39
	itt	ls
	movls	r2, #1
	strbls	r2, [r3, #8]
	b	.L2179
.L2200:
	.align	2
.L2199:
	.word	.LANCHOR40
	.word	.LANCHOR219
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
	ldr	r3, .L2211
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r2
	adds	r2, r0, r1
	sub	sp, sp, #56
	mov	r7, r0
	mov	r6, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L2210
	ldr	r3, .L2211+4
	mov	r8, #0
	ldr	fp, .L2211+28
	ldrh	r5, [r3]
	lsr	r5, r0, r5
	lsls	r3, r5, #2
	str	r3, [sp]
.L2203:
	cbnz	r6, .L2209
.L2201:
	mov	r0, r8
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2209:
	ldr	r3, .L2211+8
	mov	r0, r7
	ldr	r2, [sp]
	ldr	r3, [r3]
	ldr	r3, [r3, r2]
	ldr	r2, .L2211+12
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
	beq	.L2205
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
	ldr	r2, .L2211+16
	it	eq
	moveq	r8, #-1
	ldr	r2, [r2]
	cmp	r2, #256
	bne	.L2207
	mov	r2, r3
	mov	r1, r5
	ldr	r0, .L2211+20
	bl	printf
	ldr	r2, [fp]
	mov	r1, r5
	ldr	r0, .L2211+24
	bl	FtlMapWritePage
.L2207:
	ldr	r1, [fp]
	lsls	r2, r4, #9
	ldr	r3, [sp, #4]
	mov	r0, r10
	add	r1, r1, r3, lsl #9
	bl	ftl_memcpy
.L2208:
	ldr	r3, [sp, #8]
	adds	r5, r5, #1
	subs	r6, r6, r4
	add	r7, r7, r4
	add	r10, r10, r3
	ldr	r3, [sp]
	adds	r3, r3, #4
	str	r3, [sp]
	b	.L2203
.L2205:
	lsls	r2, r4, #9
	mov	r1, r3
	mov	r0, r10
	bl	ftl_memset
	b	.L2208
.L2210:
	mov	r8, #-1
	b	.L2201
.L2212:
	.align	2
.L2211:
	.word	.LANCHOR50
	.word	.LANCHOR56
	.word	.LANCHOR194
	.word	.LANCHOR55
	.word	.LANCHOR202
	.word	.LC42
	.word	.LANCHOR215
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
	ldr	r4, .L2215
	ldr	r5, .L2215+4
	ldr	r2, [r4]
	ldrh	r1, [r5]
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	ldr	r2, [r3]
	ldr	r3, .L2215+8
	cmp	r2, r3
	beq	.L2214
	ldr	r1, .L2215+12
	ldr	r0, .L2215+16
	bl	printf
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r0, [r4]
	lsls	r2, r2, #9
	bl	ftl_memset
.L2214:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2216:
	.align	2
.L2215:
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
	ldr	r4, .L2221
	movs	r0, #0
	ldr	r5, .L2221+4
	mov	r2, r4
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	cmp	r3, r5
	beq	.L2218
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	ftl_memset
	str	r5, [r4]
.L2218:
	ldr	r3, [r4]
	cmp	r3, r5
	ldr	r5, .L2221+8
	bne	.L2219
	ldr	r2, [r4, #88]
	ldr	r3, .L2221+12
	str	r2, [r3]
	ldr	r2, [r4, #92]
	ldr	r3, .L2221+16
	str	r2, [r3]
	ldr	r2, [r4, #8]
	ldr	r3, .L2221+20
	str	r2, [r3]
	ldr	r2, [r4, #12]
	ldr	r3, .L2221+24
	str	r2, [r3]
	ldr	r2, [r4, #16]
	ldr	r3, .L2221+28
	str	r2, [r3]
	ldr	r2, [r4, #20]
	ldr	r3, .L2221+32
	str	r2, [r3]
	ldr	r3, [r4, #28]
	ldr	r2, [r4, #32]
	str	r3, [r5]
	ldr	r3, .L2221+36
	str	r2, [r3]
	ldr	r2, [r4, #36]
	ldr	r3, .L2221+40
	str	r2, [r3]
	ldr	r2, [r4, #40]
	ldr	r3, .L2221+44
	str	r2, [r3]
	ldr	r2, [r4, #44]
	ldr	r3, .L2221+48
	str	r2, [r3]
	ldr	r2, [r4, #48]
	ldr	r3, .L2221+52
	str	r2, [r3]
	ldr	r2, [r4, #60]
	ldr	r3, .L2221+56
	str	r2, [r3]
.L2219:
	ldr	r3, .L2221+60
	movs	r2, #0
	str	r2, [r3]
	ldr	r2, [r4, #68]
	ldr	r3, .L2221+64
	cmp	r2, r3
	bne	.L2220
	ldr	r3, .L2221+68
	movs	r2, #1
	ldr	r1, .L2221+72
	ldr	r0, .L2221+76
	str	r2, [r3]
	bl	printf
.L2220:
	ldr	r3, .L2221+80
	ldr	r1, .L2221+84
	ldrh	r2, [r3]
	ldr	r3, .L2221+88
	ldrh	r1, [r1]
	ldr	r0, [r3]
	ldr	r3, [r5]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L2221+92
	str	r0, [r3]
	pop	{r3, r4, r5, pc}
.L2222:
	.align	2
.L2221:
	.word	.LANCHOR138
	.word	1179929683
	.word	.LANCHOR168
	.word	.LANCHOR216
	.word	.LANCHOR217
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
	.word	.LANCHOR205
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
	beq	.L2225
	movs	r3, #0
	ldrh	r6, [r0, #6]
	str	r3, [r0, #36]
	ldr	r3, .L2239
	ldr	r10, [r0, #24]
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2225
	ldr	r3, .L2239+4
	ldr	r5, .L2239+8
	ldr	r3, [r3]
	mov	r7, r5
	str	r3, [r5, #8]
	ldr	r3, .L2239+12
	ldr	r8, [r3]
	ldrh	r3, [r0, #2]
	str	r8, [r5, #12]
	cbz	r3, .L2229
	ldr	r2, .L2239+16
	ldrh	r2, [r2]
	subs	r2, r2, #1
	cmp	r3, r2
	bge	.L2229
	ldrh	r2, [r0]
	movw	r1, #65535
	cmp	r2, r1
	beq	.L2229
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
	beq	.L2229
	ldr	r3, [r4, #24]
	ldrh	r1, [r8, #8]
	ldr	r2, [r3, r1, lsl #2]
	ldr	r3, [r5, #4]
	cmp	r2, r3
	bne	.L2229
	ldr	r2, [r5, #8]
.L2238:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	FtlMapWritePage
.L2229:
	subs	r6, r6, #1
	uxth	r6, r6
	ldr	r3, [r10, r6, lsl #2]
	str	r3, [r7, #4]
	cbz	r3, .L2230
	movs	r2, #1
	ldr	r0, .L2239+8
	mov	r1, r2
	bl	FlashReadPages
.L2231:
	ldr	r2, [r7, #8]
	mov	r1, r6
	b	.L2238
.L2230:
	ldr	r3, .L2239+20
	movs	r1, #255
	ldr	r0, [r7, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L2231
.L2225:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2240:
	.align	2
.L2239:
	.word	.LANCHOR76
	.word	.LANCHOR184
	.word	.LANCHOR202
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
	ldr	r5, .L2323
	sub	sp, sp, #32
	mov	r1, r4
	ldr	r3, .L2323+4
	ldr	r2, [r5]
	ldr	r6, .L2323+8
	strh	r4, [r3]	@ movhi
	ldr	r3, .L2323+12
	lsls	r2, r2, #2
	strh	r4, [r6]	@ movhi
	ldr	r7, .L2323+16
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [r5]
	mov	r1, r4
	ldr	r3, .L2323+20
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L2323+24
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L2323+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	movs	r2, #16
	movs	r1, #255
	ldr	r0, .L2323+32
	bl	ftl_memset
	ldr	r3, .L2323+36
	str	r6, [sp, #12]
	str	r5, [sp, #16]
	ldrh	r3, [r3]
	str	r3, [sp, #4]
.L2242:
	ldr	r3, .L2323+40
	ldr	r2, [sp, #4]
	ldrh	r3, [r3]
	cmp	r3, r2
	bls	.L2284
	ldr	r3, .L2323+44
	movs	r5, #0
	ldr	r1, .L2323+48
	mov	fp, r5
	movs	r7, #36
	ldrh	r8, [r3]
	ldr	r3, .L2323+52
	ldr	r2, [r1]
	ldr	r1, .L2323+56
	ldr	r6, [r3]
	ldr	r3, .L2323+60
	str	r2, [sp, #8]
	ldrh	r10, [r1]
	ldr	r3, [r3]
	ldr	r2, .L2323+64
	b	.L2285
.L2244:
	ldrb	r0, [r2, r5]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #28]
	str	r2, [sp, #24]
	bl	V2P_block
	str	r0, [sp, #20]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #28]
	cbnz	r0, .L2243
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
.L2243:
	adds	r5, r5, #1
.L2285:
	uxth	r1, r5
	cmp	r8, r1
	bhi	.L2244
	cmp	fp, #0
	bne	.L2245
.L2283:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #4]
	b	.L2242
.L2245:
	movs	r7, #0
	movs	r2, #1
	mov	r1, fp
	mov	r0, r6
	bl	FlashReadPages
.L2246:
	uxth	r3, r7
	cmp	fp, r3
	bls	.L2283
	ldr	r3, .L2323+52
	mov	r8, #36
	mul	r8, r8, r7
	ldr	r3, [r3]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	ldr	r5, [r2, #4]
	ldr	r6, [r2, #12]
	adds	r3, r3, #1
	ubfx	r5, r5, #10, #16
	bne	.L2249
	mov	r10, #16
.L2251:
	ldr	r3, .L2323+52
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
	ldr	r3, .L2323+52
	ldr	r3, [r3]
	bne	.L2248
	mov	r2, #-1
	str	r2, [r3, r8]
	ldr	r3, .L2323+52
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	cmp	r3, r2
	beq	.L2250
.L2249:
	ldr	r3, .L2323+68
	ldr	r2, [r3]
	ldr	r3, [r6, #4]
	adds	r1, r2, #1
	beq	.L2252
	cmp	r2, r3
	bhi	.L2253
.L2252:
	adds	r2, r3, #1
	ittt	ne
	ldrne	r1, .L2323+68
	addne	r2, r3, #1
	strne	r2, [r1]
.L2253:
	ldrh	r2, [r6]
	movw	r1, #61604
	cmp	r2, r1
	beq	.L2255
	bhi	.L2256
	movw	r3, #61574
	cmp	r2, r3
	beq	.L2257
.L2254:
	adds	r7, r7, #1
	b	.L2246
.L2248:
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L2249
	add	r10, r10, #-1
	uxth	r10, r10
	cmp	r10, #0
	bne	.L2251
.L2250:
	ldr	r3, .L2323+72
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbnz	r1, .L2322
.L2281:
	mov	r0, r5
	bl	FtlFreeSysBlkQueueIn
	b	.L2254
.L2256:
	movw	r3, #61634
	cmp	r2, r3
	beq	.L2258
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2254
.L2322:
	movs	r1, #0
	b	.L2281
.L2258:
	ldr	r3, .L2323+8
	ldrh	r2, [r3]
	ldr	r3, .L2323
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L2260
	ldr	r1, .L2323+76
	movw	r2, #1305
	ldr	r0, .L2323+80
	bl	printf
	ldr	r1, .L2323+84
	ldr	r0, .L2323+88
	bl	printf
.L2260:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #12]
	ldr	r1, [r3]
	ldrh	r0, [r2]
	ldr	r2, .L2323+12
	uxth	r10, r1
	ldr	ip, [r2]
	add	r3, r10, #-1
	sub	r10, r10, r0
	add	r10, r10, #-1
	sxth	r3, r3
	sxth	r10, r10
.L2261:
	cmp	r3, r10
	bgt	.L2267
	cmp	r3, #0
	bge	.L2300
	b	.L2254
.L2267:
	ldr	r2, [ip, r3, lsl #2]
	add	r8, ip, r3, lsl #2
	ldr	r4, [r6, #4]
	cmp	r4, r2
	bls	.L2262
	ldr	r2, [ip]
	cbnz	r2, .L2263
	cmp	r1, r0
	ittt	ne
	ldrne	r2, .L2323+8
	addne	r0, r0, #1
	strhne	r0, [r2]	@ movhi
.L2263:
	ldr	r2, .L2323+20
	uxth	r10, r3
	ldr	r0, [r2]
	movs	r2, #0
.L2264:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L2265
	ldr	r2, [r6, #4]
	cmp	r3, #0
	str	r2, [r8]
	strh	r5, [r0, r3, lsl #1]	@ movhi
	blt	.L2254
	ldr	r2, .L2323+8
	ldrh	r0, [r2]
	ldr	r2, .L2323
	ldr	r2, [r2]
	subs	r2, r2, r0
	subs	r2, r2, #1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L2254
.L2300:
	ldr	r2, .L2323+8
	adds	r0, r0, #1
	strh	r0, [r2]	@ movhi
	ldr	r2, [r6, #4]
	str	r2, [ip, r3, lsl #2]
	ldr	r2, .L2323+20
.L2320:
	ldr	r2, [r2]
	strh	r5, [r2, r3, lsl #1]	@ movhi
	b	.L2254
.L2265:
	add	lr, ip, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, r0, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [ip, r1, lsl #2]
	strh	lr, [r0, r1, lsl #1]	@ movhi
	b	.L2264
.L2262:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L2261
.L2324:
	.align	2
.L2323:
	.word	.LANCHOR64
	.word	.LANCHOR70
	.word	.LANCHOR128
	.word	.LANCHOR130
	.word	.LANCHOR61
	.word	.LANCHOR129
	.word	.LANCHOR193
	.word	.LANCHOR71
	.word	.LANCHOR209
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
	.word	.LANCHOR220
	.word	.LC5
	.word	.LC6
	.word	.LC7
.L2257:
	ldr	r8, .L2325+20
	ldr	r10, .L2325+28
	ldrh	r2, [r8]
	ldrh	r3, [r10]
	cmp	r2, r3
	bls	.L2270
	ldr	r1, .L2325
	mov	r2, #1352
	ldr	r0, .L2325+4
	bl	printf
	ldr	r1, .L2325+8
	ldr	r0, .L2325+12
	bl	printf
.L2270:
	ldr	r2, .L2325+16
	ldrh	lr, [r10]
	ldrh	ip, [r8]
	ldr	r0, [r2]
	add	r10, lr, #-1
	sxth	r3, r10
	sub	r10, r10, ip
.L2271:
	cmp	r3, r10
	ble	.L2276
	ldr	r1, [r6, #4]
	add	r8, r0, r3, lsl #2
	ldr	r2, [r0, r3, lsl #2]
	cmp	r1, r2
	bls	.L2272
	ldr	r2, [r0]
	cbnz	r2, .L2273
	cmp	lr, ip
	ittt	ne
	ldrne	r2, .L2325+20
	addne	ip, ip, #1
	strhne	ip, [r2]	@ movhi
.L2273:
	ldr	r2, .L2325+24
	uxth	r10, r3
	ldr	ip, [r2]
	movs	r2, #0
.L2274:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L2275
	ldr	r2, [r6, #4]
	str	r2, [r8]
	strh	r5, [ip, r3, lsl #1]	@ movhi
.L2276:
	cmp	r3, #0
	blt	.L2254
	ldr	r2, .L2325+28
	ldr	ip, .L2325+20
	ldrh	r2, [r2]
	ldrh	r1, [ip]
	subs	r2, r2, #1
	subs	r2, r2, r1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L2254
	ldr	r2, [r6, #4]
	adds	r1, r1, #1
	strh	r1, [ip]	@ movhi
	str	r2, [r0, r3, lsl #2]
	ldr	r2, .L2325+24
	b	.L2320
.L2275:
	add	lr, r0, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, ip, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [r0, r1, lsl #2]
	strh	lr, [ip, r1, lsl #1]	@ movhi
	b	.L2274
.L2272:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L2271
.L2255:
	ldr	r8, .L2325+48
	movw	r2, #65535
	ldrh	r1, [r8]
	cmp	r1, r2
	bne	.L2278
.L2321:
	strh	r5, [r8]	@ movhi
	str	r3, [r8, #8]
	b	.L2254
.L2278:
	ldrh	r0, [r8, #4]
	cmp	r0, r2
	beq	.L2279
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L2279:
	ldr	r3, [r6, #4]
	ldr	r2, [r8, #8]
	cmp	r2, r3
	bcs	.L2280
	ldrh	r2, [r8]
	strh	r2, [r8, #4]	@ movhi
	b	.L2321
.L2280:
	strh	r5, [r8, #4]	@ movhi
	b	.L2254
.L2284:
	ldr	r3, .L2325+32
	ldr	r2, [r3]
	ldrh	r3, [r2]
	cbz	r3, .L2286
.L2289:
	ldr	r3, .L2325+24
	ldr	r4, [r3]
	ldrh	r2, [r4]
	cmp	r2, #0
	beq	.L2287
.L2288:
	ldr	r3, .L2325+36
	ldrh	r2, [r3]
	ldr	r3, .L2325+40
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L2319
	ldr	r1, .L2325
	movw	r2, #1486
	ldr	r0, .L2325+4
	bl	printf
	ldr	r1, .L2325+8
	ldr	r0, .L2325+12
	bl	printf
.L2319:
	movs	r0, #0
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2286:
	ldr	r1, .L2325+36
	ldrh	r1, [r1]
	cmp	r1, #0
	beq	.L2289
	ldr	r5, .L2325+40
	ldr	r0, [r5]
.L2290:
	sxth	r1, r3
	cmp	r1, r0
	bcs	.L2289
	ldrh	r4, [r2, r1, lsl #1]
	adds	r3, r3, #1
	cmp	r4, #0
	beq	.L2290
	ldr	r3, .L2325+44
	movs	r6, #0
	ldr	r0, [r3]
	mov	r3, r1
.L2291:
	ldr	r4, [r5]
	cmp	r3, r4
	bcs	.L2289
	ldrh	r7, [r2, r3, lsl #1]
	subs	r4, r3, r1
	strh	r7, [r2, r4, lsl #1]	@ movhi
	ldr	r7, [r0, r3, lsl #2]
	str	r7, [r0, r4, lsl #2]
	strh	r6, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	sxth	r3, r3
	b	.L2291
.L2287:
	ldr	r3, .L2325+20
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L2288
	ldr	r5, .L2325+28
	ldrh	r1, [r5]
.L2296:
	sxth	r3, r2
	cmp	r3, r1
	mov	r6, r3
	bge	.L2288
	ldrh	r0, [r4, r3, lsl #1]
	adds	r2, r2, #1
	cmp	r0, #0
	beq	.L2296
	ldr	r2, .L2325+16
	movs	r0, #0
	ldr	r2, [r2]
.L2297:
	ldrh	r1, [r5]
	cmp	r3, r1
	bge	.L2288
	ldrh	r7, [r4, r3, lsl #1]
	subs	r1, r3, r6
	strh	r7, [r4, r1, lsl #1]	@ movhi
	ldr	r7, [r2, r3, lsl #2]
	str	r7, [r2, r1, lsl #2]
	adds	r1, r3, #1
	strh	r0, [r4, r3, lsl #1]	@ movhi
	sxth	r3, r1
	b	.L2297
.L2326:
	.align	2
.L2325:
	.word	.LANCHOR220
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
	.word	.LANCHOR209
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
	ldr	r8, .L2361+164
	ldr	r6, .L2361
	ldr	r3, [r8]
	ldr	r4, .L2361+4
	ldr	r10, .L2361+168
	ldrh	r2, [r6]
	ldr	r5, .L2361+8
	str	r3, [r4, #8]
	ldr	r7, .L2361+12
	ldr	r3, [r10]
	lsls	r2, r2, #1
	ldr	r0, [r5]
	str	r3, [r4, #12]
	bl	ftl_memset
	ldrh	r0, [r7]
	movw	r3, #65535
	str	r5, [sp]
	cmp	r0, r3
	bne	.L2328
.L2340:
	mov	r0, #-1
.L2327:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2328:
	movs	r1, #1
	bl	FtlGetLastWrittenPage
	ldrsh	fp, [r7]
	sxth	r5, r0
	adds	r0, r0, #1
	strh	r0, [r7, #2]	@ movhi
.L2330:
	cmp	r5, #0
	bge	.L2336
	movw	r2, #1555
	ldr	r1, .L2361+16
	ldr	r0, .L2361+20
	bl	printf
	ldr	r1, .L2361+24
	ldr	r0, .L2361+28
	bl	printf
	b	.L2335
.L2336:
	orr	r2, r5, fp, lsl #10
	ldr	r0, .L2361+4
	str	r2, [r4, #4]
	ldr	r2, [r8]
	str	r2, [r4, #8]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, .L2361+32
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L2331
	ldr	r2, [r4, #12]
	ldr	r2, [r2, #12]
	str	r2, [sp, #4]
	cbz	r2, .L2331
	ldr	r1, .L2361+36
	ldr	r0, [r4, #8]
	ldrh	r1, [r1]
	bl	js_hash
	ldr	r2, [sp, #4]
	cmp	r2, r0
	beq	.L2331
	cbnz	r5, .L2332
	ldrh	r2, [r7, #4]
	cmp	fp, r2
	beq	.L2332
	sxth	fp, r2
	ldr	r2, .L2361+40
	ldrh	r5, [r2]
.L2334:
	subs	r5, r5, #1
	sxth	r5, r5
	b	.L2330
.L2332:
	mov	r2, #-1
	str	r2, [r4]
.L2331:
	ldr	r2, [r4]
	adds	r2, r2, #1
	beq	.L2334
	ldr	r2, [r8]
	ldr	r3, .L2361+44
	ldr	r2, [r2]
	cmp	r2, r3
	bne	.L2334
	ldr	r2, [r10]
	ldrh	r1, [r2]
	movw	r2, #61604
	cmp	r1, r2
	bne	.L2334
.L2335:
	ldr	r2, .L2361+36
	ldrh	r3, [r6]
	ldrh	r2, [r2]
	adds	r3, r3, #24
	cmp	r2, r3, lsl #1
	bcs	.L2338
	ldr	r1, .L2361+16
	movw	r2, #1557
	ldr	r0, .L2361+20
	bl	printf
	ldr	r1, .L2361+24
	ldr	r0, .L2361+28
	bl	printf
.L2338:
	movs	r2, #48
	ldr	r1, [r4, #8]
	ldr	r0, .L2361+48
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
	ldr	r3, .L2361+52
	ldr	r0, [r3]
	bl	ftl_memcpy
	ldr	r3, .L2361+56
	ldrh	r3, [r3]
	cbz	r3, .L2339
	ldrh	r1, [r6]
	ldr	r3, .L2361+60
	ldrh	r2, [r3]
	lsrs	r3, r1, #3
	add	r3, r3, r1, lsl #1
	ldr	r1, [r4, #8]
	adds	r3, r3, #52
	lsls	r2, r2, #2
	ubfx	r3, r3, #2, #14
	add	r1, r1, r3, lsl #2
	ldr	r3, .L2361+64
	ldr	r0, [r3]
	bl	ftl_memcpy
.L2339:
	ldr	r4, .L2361+48
	ldr	r3, .L2361+44
	ldr	r2, [r4]
	cmp	r2, r3
	bne	.L2340
	ldr	r3, .L2361+68
	ldrb	r2, [r4, #10]	@ zero_extendqisi2
	ldrh	r5, [r4, #8]
	ldrh	r3, [r3]
	strh	r5, [r7, #6]	@ movhi
	cmp	r2, r3
	bne	.L2340
	ldr	r3, .L2361+72
	ldr	r2, .L2361+76
	str	r5, [r3]
	ldr	r3, .L2361+80
	ldrh	r3, [r3]
	muls	r3, r5, r3
	str	r3, [r2]
	ldr	r2, .L2361+84
	ldrh	r2, [r2]
	muls	r3, r2, r3
	ldr	r2, .L2361+88
	str	r3, [r2]
	ldr	r3, .L2361+92
	ldr	r6, [r3]
	ldr	r3, .L2361+96
	ldrh	r0, [r3, #6]
	ldr	r3, .L2361+100
	subs	r0, r6, r0
	ldrh	r1, [r3]
	subs	r0, r0, r5
	bl	__aeabi_uidiv
	ldr	r3, .L2361+104
	cmp	r5, r6
	strh	r0, [r3]	@ movhi
	bls	.L2341
	ldr	r1, .L2361+16
	mov	r2, #1584
	ldr	r0, .L2361+20
	bl	printf
	ldr	r1, .L2361+24
	ldr	r0, .L2361+28
	bl	printf
.L2341:
	ldrh	r2, [r4, #16]
	ldr	r3, .L2361+108
	ldrh	ip, [r4, #14]
	ldr	r7, .L2361+112
	lsrs	r1, r2, #6
	and	r2, r2, #63
	strb	r2, [r3, #6]
	ldrb	r2, [r4, #11]	@ zero_extendqisi2
	strh	r1, [r3, #2]	@ movhi
	ldr	r1, .L2361+116
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
	ldr	r2, .L2361+120
	strh	r5, [r2]	@ movhi
	ldrh	r5, [r4, #24]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r2, #6]
	ldrb	r5, [r4, #13]	@ zero_extendqisi2
	strh	r6, [r2, #2]	@ movhi
	ldr	r6, [r4, #32]
	strb	r5, [r2, #8]
	ldr	r5, .L2361+124
	str	r3, [r5]
	ldr	r5, .L2361+128
	str	r3, [r5]
	ldr	r5, .L2361+132
	str	r3, [r5]
	ldr	r5, .L2361+136
	str	r3, [r5]
	ldr	r5, .L2361+140
	str	r6, [r5]
	mov	r6, r1
	ldr	r5, .L2361+144
	str	r3, [r5]
	ldr	r5, .L2361+148
	str	r3, [r5]
	ldr	r5, .L2361+152
	ldr	lr, [r4, #40]
	str	r3, [r5]
	ldr	r3, .L2361+156
	ldr	r5, [r3]
	cmp	lr, r5
	mov	r5, r2
	it	hi
	strhi	lr, [r3]
	ldr	r3, .L2361+160
	ldr	r2, [r4, #36]
	ldr	r1, [r3]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3]
	movw	r3, #65535
	cmp	ip, r3
	beq	.L2344
	ldr	r0, .L2361+108
	bl	make_superblock
.L2344:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2345
	ldr	r0, .L2361+116
	bl	make_superblock
.L2345:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2346
	ldr	r0, .L2361+120
	bl	make_superblock
.L2346:
	ldrh	r2, [r7]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2347
	ldr	r0, .L2361+112
	bl	make_superblock
.L2347:
	movs	r0, #0
	b	.L2327
.L2362:
	.align	2
.L2361:
	.word	.LANCHOR40
	.word	.LANCHOR202
	.word	.LANCHOR83
	.word	.LANCHOR209
	.word	.LANCHOR221
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR1
	.word	.LANCHOR57
	.word	.LANCHOR53
	.word	1179929683
	.word	.LANCHOR80
	.word	.LANCHOR0
	.word	.LANCHOR69
	.word	.LANCHOR66
	.word	.LANCHOR195
	.word	.LANCHOR45
	.word	.LANCHOR222
	.word	.LANCHOR72
	.word	.LANCHOR52
	.word	.LANCHOR55
	.word	.LANCHOR68
	.word	.LANCHOR42
	.word	.LANCHOR74
	.word	.LANCHOR38
	.word	.LANCHOR223
	.word	.LANCHOR91
	.word	.LANCHOR204
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
	ldr	r4, .L2375
	sub	sp, sp, #88
	mov	r8, r1
	ldrh	r3, [r4]
	str	r3, [sp, #24]
	bl	P2V_block_in_plane
	ldr	r1, .L2375+4
	mov	r6, r0
	ldr	r0, .L2375+8
	bl	printf
	ldr	r3, .L2375+12
	mov	r1, r6
	ldr	r0, .L2375+16
	ldr	r3, [r3]
	ldrh	r2, [r3, r6, lsl #1]
	bl	printf
	add	r0, sp, #88
	strh	r6, [r0, #-48]!	@ movhi
	bl	make_superblock
	ldr	r3, .L2375+20
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L2364
	cmp	r8, #0
	bne	.L2373
	mov	r0, r6
	bl	ftl_get_blk_mode
	cmp	r0, #1
	mov	r5, r0
	bne	.L2364
	ldr	r3, .L2375+24
	ldrh	r3, [r3]
	str	r3, [sp, #24]
.L2364:
	movs	r6, #0
	ldrh	r3, [r4]
	ldr	r2, [sp, #24]
	mov	r1, r5
	ldr	r0, .L2375+28
	bl	printf
.L2365:
	ldr	r3, .L2375+32
	movs	r2, #0
	add	ip, sp, #54
	mov	r4, r2
	movw	r10, #65535
	mov	fp, #36
	ldrh	lr, [r3]
	ldr	r3, .L2375+36
	ldr	r0, [r3]
	ldr	r3, .L2375+40
	ldr	r3, [r3]
	str	r3, [sp, #28]
	ldr	r3, .L2375+44
	ldrh	r3, [r3]
	str	r3, [sp, #32]
	ldr	r3, .L2375+48
	ldr	r3, [r3]
	str	r3, [sp, #36]
	ldr	r3, .L2375+52
	ldrh	r8, [r3]
.L2366:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L2368
	ldr	fp, .L2375+56
	mov	r8, #0
	mov	r10, #36
	mov	r2, r5
	mov	r1, r4
	bl	FlashReadPages
.L2369:
	uxth	r3, r8
	cmp	r4, r3
	bhi	.L2370
	adds	r6, r6, #1
	ldr	r3, [sp, #24]
	uxth	r6, r6
	cmp	r3, r6
	bne	.L2365
.L2371:
	movs	r0, #0
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2373:
	movs	r5, #0
	b	.L2364
.L2368:
	ldrh	r3, [ip, #2]!
	cmp	r3, r10
	beq	.L2367
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
.L2367:
	adds	r2, r2, #1
	b	.L2366
.L2370:
	ldr	r3, .L2375+36
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
	b	.L2369
.L2376:
	.align	2
.L2375:
	.word	.LANCHOR52
	.word	.LANCHOR224
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
	ldr	r6, .L2387
	ldr	r1, .L2387+4
	ldr	r0, .L2387+8
	bl	printf
	movs	r3, #0
	str	r3, [sp, #28]
.L2378:
	ldr	r3, .L2387+12
	ldrh	r0, [sp, #28]
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2386
	movs	r0, #0
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2386:
	add	r4, sp, #88
	add	r7, sp, #54
	strh	r0, [r4, #-48]!	@ movhi
	movw	r10, #65535
	bl	ftl_get_blk_mode
	ldr	r3, .L2387+16
	mov	fp, #36
	ldrh	r1, [sp, #28]
	ldr	r2, [r3]
	mov	r3, r0
	ldr	r0, .L2387+20
	ldrh	r2, [r2, r1, lsl #1]
	bl	printf
	mov	r0, r4
	bl	make_superblock
	ldr	r3, .L2387+24
	movs	r2, #0
	ldr	r0, [r6]
	mov	r4, r2
	ldrh	lr, [r3]
	ldr	r3, .L2387+28
	ldr	r3, [r3]
	str	r3, [sp, #32]
	ldr	r3, .L2387+32
	ldrh	ip, [r3]
	ldr	r3, .L2387+36
	ldr	r3, [r3]
	str	r3, [sp, #36]
	ldr	r3, .L2387+40
	ldrh	r8, [r3]
.L2379:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L2381
	ldr	r10, .L2387+44
	movs	r7, #0
	mov	r8, #36
	movs	r2, #0
	mov	r1, r4
	bl	FlashReadPages
.L2382:
	uxth	r3, r7
	cmp	r4, r3
	bhi	.L2383
	ldr	r10, .L2387+48
	movs	r7, #0
	mov	r8, #36
	movs	r2, #1
	mov	r1, r4
	ldr	r0, [r6]
	bl	FlashReadPages
.L2384:
	uxth	r3, r7
	cmp	r4, r3
	bhi	.L2385
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	str	r3, [sp, #28]
	b	.L2378
.L2381:
	ldrh	r3, [r7, #2]!
	cmp	r3, r10
	beq	.L2380
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
.L2380:
	adds	r2, r2, #1
	b	.L2379
.L2383:
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
	b	.L2382
.L2385:
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
	b	.L2384
.L2388:
	.align	2
.L2387:
	.word	.LANCHOR180
	.word	.LANCHOR225
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
	ldr	r2, .L2430
	ldr	r3, .L2430+4
	str	r6, [r4, #32]
	ldr	r1, [r2]
	mov	fp, r3
	str	r6, [r4, #28]
	str	r2, [sp, #8]
	str	r1, [r3, #8]
	ldr	r1, .L2430+8
	ldr	r5, [r1]
	movw	r1, #65535
	str	r5, [r3, #12]
	strh	r1, [r4]	@ movhi
	strh	r1, [r4, #2]	@ movhi
	movs	r1, #1
	str	r1, [r4, #36]
.L2390:
	ldr	r2, [sp, #4]
	sxth	r3, r6
	cmp	r3, r2
	bge	.L2409
	ldr	r2, [sp, #4]
	lsl	r8, r3, #1
	subs	r2, r2, #1
	cmp	r3, r2
	bne	.L2391
	ldrh	r0, [r10, r3, lsl #1]
	movs	r1, #1
	str	r3, [sp, #4]
	mov	fp, #0
	bl	FtlGetLastWrittenPage
	ldr	r3, [sp, #12]
	add	r8, r8, r10
	strh	r6, [r4]	@ movhi
	sxth	r10, r0
	ldr	r6, .L2430+4
	adds	r0, r0, #1
	mov	r2, r3
	ldr	r3, [sp, #4]
	strh	r0, [r4, #2]	@ movhi
	ldr	r3, [r2, r3, lsl #2]
	str	r3, [r4, #28]
.L2392:
	sxth	r2, fp
	cmp	r2, r10
	ble	.L2395
.L2409:
	mov	r0, r4
	bl	ftl_free_no_use_map_blk
	ldr	r3, .L2430+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2397
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L2397:
	mov	r0, r4
	bl	ftl_map_blk_gc
	mov	r0, r4
	bl	ftl_map_blk_gc
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2395:
	ldrh	r1, [r8]
	ldr	r0, .L2430+4
	orr	r2, r2, r1, lsl #10
	str	r2, [r6, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r3, .L2430+16
	ldrb	r2, [r3]	@ zero_extendqisi2
	cbz	r2, .L2393
	ldr	r2, [r6, #12]
	ldr	r2, [r2, #12]
	str	r2, [sp, #4]
	cbz	r2, .L2393
	ldr	r1, .L2430+20
	ldr	r0, [r6, #8]
	ldrh	r1, [r1]
	bl	js_hash
	ldr	r2, [sp, #4]
	cmp	r2, r0
	itt	ne
	movne	r2, #-1
	strne	r2, [r6]
.L2393:
	ldr	r2, [r6]
	adds	r2, r2, #1
	beq	.L2394
	ldrh	r2, [r5, #8]
	cmp	r7, r2
	bls	.L2394
	ldrh	r1, [r4, #4]
	ldrh	r0, [r5]
	cmp	r0, r1
	ittt	eq
	ldreq	r1, [r6, #4]
	ldreq	r3, [sp]
	streq	r1, [r3, r2, lsl #2]
.L2394:
	add	fp, fp, #1
	b	.L2392
.L2391:
	ldr	r2, [sp, #8]
	ldr	r0, .L2430+4
	ldr	r2, [r2]
	str	r2, [fp, #8]
	add	r2, r10, r8
	ldr	r8, .L2430+12
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
	beq	.L2411
	ldrh	r2, [r5]
	ldrh	r3, [r4, #4]
	cmp	r2, r3
	bne	.L2411
	ldrh	r2, [r5, #8]
	movw	r3, #64245
	cmp	r2, r3
	beq	.L2399
.L2411:
	mov	r8, #0
.L2400:
	ldr	r2, .L2430+12
	sxth	r3, r8
	ldrh	r2, [r2]
	cmp	r3, r2
	bge	.L2407
	ldr	r2, [sp, #16]
	ldr	r0, .L2430+4
	ldrh	r2, [r2]
	orr	r3, r3, r2, lsl #10
	movs	r2, #1
	mov	r1, r2
	str	r3, [fp, #4]
	bl	FlashReadPages
	ldr	r3, .L2430+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2404
	ldr	r3, [fp, #12]
	ldr	r3, [r3, #12]
	str	r3, [sp, #20]
	cbz	r3, .L2404
	ldr	r2, .L2430+20
	ldr	r0, [fp, #8]
	ldrh	r1, [r2]
	bl	js_hash
	ldr	r3, [sp, #20]
	cmp	r3, r0
	itt	ne
	movne	r3, #-1
	strne	r3, [fp]
.L2404:
	ldr	r3, [fp]
	adds	r3, r3, #1
	beq	.L2405
	ldrh	r3, [r5, #8]
	cmp	r7, r3
	bls	.L2405
	ldrh	r1, [r5]
	ldrh	r2, [r4, #4]
	cmp	r1, r2
	ittt	eq
	ldreq	r2, [fp, #4]
	ldreq	r1, [sp]
	streq	r2, [r1, r3, lsl #2]
.L2405:
	add	r8, r8, #1
	b	.L2400
.L2399:
	ldr	r3, [sp, #8]
	movs	r1, #0
	ldrh	r2, [r8]
	ldr	ip, [r3]
	subs	r2, r2, #1
.L2401:
	sxth	r3, r1
	cmp	r3, r2
	blt	.L2403
.L2407:
	adds	r6, r6, #1
	b	.L2390
.L2403:
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
	b	.L2401
.L2431:
	.align	2
.L2430:
	.word	.LANCHOR183
	.word	.LANCHOR202
	.word	.LANCHOR188
	.word	.LANCHOR53
	.word	.LANCHOR1
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
	ldr	r3, .L2433
	ldr	r0, .L2433+4
	ldrh	r3, [r3]
	strh	r3, [r0, #10]	@ movhi
	movw	r3, #61574
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L2433+8
	ldrh	r3, [r3]
	strh	r3, [r0, #8]	@ movhi
	ldr	r3, .L2433+12
	ldrh	r3, [r3]
	strh	r3, [r0, #6]	@ movhi
	ldr	r3, .L2433+16
	ldr	r3, [r3]
	str	r3, [r0, #12]
	ldr	r3, .L2433+20
	ldr	r3, [r3]
	str	r3, [r0, #16]
	ldr	r3, .L2433+24
	ldr	r3, [r3]
	str	r3, [r0, #20]
	ldr	r3, .L2433+28
	ldr	r3, [r3]
	str	r3, [r0, #24]
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L2434:
	.align	2
.L2433:
	.word	.LANCHOR61
	.word	.LANCHOR215
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
	ldr	r0, .L2436
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L2437:
	.align	2
.L2436:
	.word	.LANCHOR127
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
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
	ldr	r2, .L2451
	sub	sp, sp, #48
	mov	r6, r1
	mov	r4, r0
	ldr	r7, .L2451+4
	ldrh	r3, [r2, #14]
	ldrh	r2, [r2, #12]
	smulbb	r3, r3, r2
	ldr	r2, [r7]
	uxth	r3, r3
	str	r2, [sp, #20]
	ldr	r2, .L2451+8
	subs	r5, r3, #1
	mul	r10, r6, r3
	uxth	r5, r5
	subs	r3, r3, #15
	ldr	r1, [r2]
	mov	r8, r2
	str	r1, [sp, #24]
.L2439:
	cmp	r3, r5
	ble	.L2446
	mov	r0, #-1
	b	.L2438
.L2446:
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
	beq	.L2440
	ldr	r2, [r8]
	ldrh	r1, [r2]
	movw	r2, #61664
	cmp	r1, r2
	bne	.L2440
	cbz	r4, .L2447
	cbz	r6, .L2442
.L2445:
	mov	r2, fp
	ldr	r1, [r7]
	mov	r0, r4
	bl	ftl_memcpy
	movs	r3, #4
	ldr	r0, .L2451+12
	mov	r2, r3
	mov	r1, r4
	bl	rknand_print_hex
	movs	r0, #0
.L2438:
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2442:
	ldr	r1, [r7]
	mov	ip, #1
	ldr	r5, .L2451+16
.L2443:
	ldr	r0, [r5]
	uxth	r3, r6
	adds	r6, r6, #1
	cmp	r3, r0
	bcs	.L2445
	lsrs	r0, r3, #5
	and	r3, r3, #31
	lsl	r3, ip, r3
	ldr	r2, [r1, r0, lsl #2]
	orrs	r3, r3, r2
	str	r3, [r1, r0, lsl #2]
	b	.L2443
.L2440:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2439
.L2447:
	mov	r0, r4
	b	.L2438
.L2452:
	.align	2
.L2451:
	.word	.LANCHOR14
	.word	.LANCHOR147
	.word	.LANCHOR197
	.word	.LC52
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
	ldr	r3, .L2463
	ldr	r6, .L2463+4
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
	bne	.L2454
.L2458:
	movs	r3, #0
.L2455:
	movw	r2, #65535
	movs	r0, #0
	strh	r2, [r5, r3, lsl #1]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L2454:
	ldr	r7, [r6]
	movs	r2, #0
	lsr	ip, r4, #4
	mov	r3, r2
	subs	r4, r4, #1
	mov	lr, #1
.L2456:
	uxth	r1, r2
	cmp	r1, r4
	bge	.L2455
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
	bcc	.L2456
	b	.L2458
.L2464:
	.align	2
.L2463:
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
	ldr	r3, .L2485
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r7, [r3]
	cmp	r7, #0
	bne	.L2466
	ldr	r8, .L2485+40
	ldr	r4, .L2485+4
	bl	FtlBbtMemInit
	sub	r10, r8, #18
	bl	FtlLoadFactoryBbt
.L2467:
	ldr	r3, .L2485+8
	ldrh	r3, [r3]
	cmp	r7, r3
	bcc	.L2473
	ldr	r5, .L2485+12
	movs	r4, #0
.L2474:
	ldrh	r3, [r5]
	uxth	r0, r4
	adds	r4, r4, #1
	cmp	r3, r0
	bhi	.L2475
	ldr	r4, .L2485+16
	movw	r6, #65535
	ldrh	r5, [r4, #12]
	subs	r5, r5, #1
	uxth	r5, r5
.L2476:
	ldrh	r3, [r4, #12]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L2480
	mov	r0, r5
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L2477
	mov	r0, r5
	bl	FlashTestBlk
	cmp	r0, #0
	beq	.L2478
	mov	r0, r5
	bl	FtlBbmMapBadBlock
.L2477:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2476
.L2473:
	ldr	r3, .L2485+20
	movw	r1, #65535
	ldrh	r2, [r10, #2]!
	ldr	r0, [r3]
	ldr	r3, .L2485+24
	cmp	r2, r1
	str	r0, [r4, #8]
	ldr	fp, [r3]
	str	r3, [sp, #4]
	ldr	r3, .L2485+28
	str	fp, [r4, #12]
	beq	.L2468
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
.L2469:
	uxth	r0, r6
	adds	r7, r7, #1
	add	r8, r8, #4
	bl	FtlBbmMapBadBlock
	b	.L2467
.L2468:
	mov	r1, r7
	str	r3, [sp]
	bl	FlashGetBadBlockList
	ldr	r1, [r8]
	ldr	r0, [r4, #8]
	bl	FtlBbt2Bitmap
	ldr	r3, [sp]
	ldrh	r5, [r3]
.L2471:
	subs	r5, r5, #1
	uxth	r5, r5
.L2470:
	ldr	r3, [sp]
	ldrh	r0, [r3]
	smlabb	r0, r0, r7, r5
	uxth	r0, r0
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L2471
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
	ldr	r3, .L2485+32
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
	bne	.L2469
	uxth	r0, r6
	bl	FtlBbmMapBadBlock
	b	.L2470
.L2475:
	bl	FtlBbmMapBadBlock
	b	.L2474
.L2478:
	ldrh	r3, [r4]
	cmp	r3, r6
	bne	.L2479
	strh	r5, [r4]	@ movhi
	b	.L2477
.L2479:
	strh	r5, [r4, #4]	@ movhi
.L2480:
	ldr	r3, .L2485+36
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
.L2466:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2486:
	.align	2
.L2485:
	.word	.LANCHOR76
	.word	.LANCHOR202
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
	ldr	r4, .L2505
	mov	fp, r0
	str	r2, [sp, #16]
	ldr	r2, [r4]
	ldr	r3, .L2505+4
	str	r1, [sp, #4]
	cmp	r0, r2
	ldrh	r5, [r3]
	bcc	.L2488
	ldr	r1, .L2505+8
	mov	r2, #884
	ldr	r0, .L2505+12
	bl	printf
	ldr	r1, .L2505+16
	ldr	r0, .L2505+20
	bl	printf
.L2488:
	ldr	r3, [r4]
	cmp	fp, r3
	bcs	.L2489
	adds	r3, r5, #7
	ldr	r5, .L2505+24
	lsr	r7, fp, r3
	str	r3, [sp, #8]
	ldr	r3, .L2505+28
	movs	r4, #12
	ldr	r1, [r5]
	uxth	r6, r7
	ldrh	r2, [r3]
	movs	r3, #0
.L2490:
	uxth	r10, r3
	cmp	r10, r2
	bcc	.L2495
	bl	select_l2p_ram_region
	muls	r4, r0, r4
	ldr	r3, [r5]
	mov	r10, r0
	ldrh	r1, [r3, r4]
	adds	r2, r3, r4
	movw	r3, #65535
	cmp	r1, r3
	beq	.L2496
	ldr	r3, [r2, #4]
	cmp	r3, #0
	bge	.L2496
	bl	flush_l2p_region
.L2496:
	ldr	r3, .L2505+32
	ldrh	r3, [r3]
	cmp	r3, r6
	bcs	.L2497
	ldr	r1, .L2505+36
	movw	r2, #526
	ldr	r0, .L2505+12
	bl	printf
	ldr	r1, .L2505+16
	ldr	r0, .L2505+20
	bl	printf
.L2497:
	ldr	r3, .L2505+40
	uxth	r7, r7
	ldr	r3, [r3]
	ldr	r3, [r3, r7, lsl #2]
	cmp	r3, #0
	bne	.L2498
	ldr	r2, [r5]
	movs	r1, #255
	str	r3, [sp, #12]
	adds	r0, r2, r4
	ldr	r2, .L2505+44
	ldr	r0, [r0, #8]
	ldrh	r2, [r2]
	bl	ftl_memset
	ldr	r2, [r5]
	ldr	r3, [sp, #12]
	adds	r1, r2, r4
	strh	r6, [r2, r4]	@ movhi
	str	r3, [r1, #4]
	b	.L2492
.L2489:
	ldr	r3, [sp, #16]
	mov	r0, #-1
	cbnz	r3, .L2487
	ldr	r3, [sp, #4]
	str	r0, [r3]
.L2487:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2495:
	adds	r3, r3, #1
	mla	r0, r4, r3, r1
	ldrh	r0, [r0, #-12]
	cmp	r0, r6
	bne	.L2490
.L2492:
	ldr	r2, [sp, #8]
	movs	r3, #1
	ldr	r0, [sp, #16]
	ldr	r1, .L2505+24
	lsls	r3, r3, r2
	movs	r2, #12
	subs	r3, r3, #1
	and	r3, r3, fp
	uxth	r3, r3
	cbnz	r0, .L2493
	ldr	r0, [r1]
	mla	r2, r2, r10, r0
	ldr	r2, [r2, #8]
	ldr	r3, [r2, r3, lsl #2]
	ldr	r2, [sp, #4]
	str	r3, [r2]
.L2494:
	ldr	r2, [r1]
	movs	r3, #12
	mla	r10, r3, r10, r2
	ldr	r3, [r10, #4]
	adds	r2, r3, #1
	beq	.L2503
	adds	r3, r3, #1
	str	r3, [r10, #4]
.L2503:
	movs	r0, #0
	b	.L2487
.L2493:
	ldr	r0, [r1]
	mla	r2, r2, r10, r0
	ldr	r0, [sp, #4]
	ldr	r4, [r0]
	ldr	r0, [r2, #8]
	str	r4, [r0, r3, lsl #2]
	ldr	r3, [r2, #4]
	orr	r3, r3, #-2147483648
	str	r3, [r2, #4]
	ldr	r3, .L2505+48
	strh	r6, [r3]	@ movhi
	b	.L2494
.L2498:
	ldr	r2, [r5]
	ldr	r8, .L2505+80
	str	r3, [sp, #20]
	add	r2, r2, r4
	ldr	r2, [r2, #8]
	mov	r0, r8
	str	r3, [r8, #4]
	str	r2, [r8, #8]
	ldr	r2, .L2505+52
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
	beq	.L2499
	mov	r2, r3
	mov	r1, r7
	ldr	r0, .L2505+56
	bl	printf
	movs	r3, #4
	ldr	r1, [r8, #12]
	mov	r2, r3
	ldr	r0, .L2505+60
	bl	rknand_print_hex
	ldr	r3, .L2505+32
	movs	r2, #4
	ldr	r1, .L2505+40
	ldr	r0, .L2505+64
	ldrh	r3, [r3]
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r3, .L2505+68
	movs	r2, #1
	str	r2, [r3]
.L2500:
	ldr	r3, [sp, #12]
	ldrh	r3, [r3, #8]
	cmp	r3, r6
	beq	.L2501
	ldr	r1, .L2505+36
	mov	r2, #552
	ldr	r0, .L2505+12
	bl	printf
	ldr	r1, .L2505+16
	ldr	r0, .L2505+20
	bl	printf
.L2501:
	ldr	r3, .L2505+24
	movs	r1, #0
	ldr	r3, [r3]
	adds	r2, r3, r4
	str	r1, [r2, #4]
	strh	r6, [r3, r4]	@ movhi
	b	.L2492
.L2499:
	ldr	r2, [r8]
	cmp	r2, #256
	bne	.L2500
	mov	r2, r3
	mov	r1, r7
	ldr	r0, .L2505+72
	bl	printf
	ldr	r3, [r5]
	mov	r1, r7
	ldr	r0, .L2505+76
	add	r3, r3, r4
	ldr	r2, [r3, #8]
	bl	FtlMapWritePage
	b	.L2500
.L2506:
	.align	2
.L2505:
	.word	.LANCHOR72
	.word	.LANCHOR56
	.word	.LANCHOR226
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR96
	.word	.LANCHOR67
	.word	.LANCHOR66
	.word	.LANCHOR227
	.word	.LANCHOR131
	.word	.LANCHOR57
	.word	.LANCHOR97
	.word	.LANCHOR188
	.word	.LC53
	.word	.LC27
	.word	.LC54
	.word	.LANCHOR76
	.word	.LC55
	.word	.LANCHOR127
	.word	.LANCHOR202
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
	ldr	r3, .L2527
	mov	r5, r0
	mov	r10, r1
	ldr	r7, [r3]
	mov	r8, r3
	cbnz	r7, .L2507
	ldr	r3, .L2527+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2522
	ldrb	r6, [r4, #8]	@ zero_extendqisi2
	subs	r3, r6, #1
	rsbs	r6, r3, #0
	adcs	r6, r6, r3
.L2509:
	ldr	fp, .L2527+40
	mov	r2, r6
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	mov	r1, r10
	mov	r0, r5
	bl	FlashProgPages
.L2510:
	cmp	r7, r10
	bne	.L2520
	ldr	r3, .L2527+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2507
	ldr	r1, .L2527+12
	mov	r2, #1600
	ldr	r0, .L2527+16
	bl	printf
	ldr	r1, .L2527+20
	ldr	r0, .L2527+24
	bl	printf
.L2507:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2522:
	mov	r6, r7
	b	.L2509
.L2513:
	ldr	r0, [r5, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r4]
	cmp	r3, r0
	bne	.L2511
	ldr	r1, [fp]
	ldrh	r0, [r4, #4]
	ldrh	r2, [r1, r3, lsl #1]
	subs	r2, r2, r0
	strh	r2, [r1, r3, lsl #1]	@ movhi
	ldr	r3, .L2527+28
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
.L2511:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L2512
	mov	r0, r4
	bl	allocate_new_data_superblock
.L2512:
	ldr	r2, .L2527+32
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
	bne	.L2507
.L2520:
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L2513
	ldr	r3, .L2527+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2514
	ldr	r1, .L2527+12
	movw	r2, #1583
	ldr	r0, .L2527+16
	bl	printf
	ldr	r1, .L2527+20
	ldr	r0, .L2527+24
	bl	printf
.L2514:
	ldr	r3, [r5, #4]
	cbnz	r6, .L2515
.L2526:
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
	beq	.L2517
	ldr	r2, [fp]
	ldrh	r2, [r2, r0, lsl #1]
	cbnz	r2, .L2518
	mov	r1, r0
	str	r0, [sp, #4]
	ldr	r0, .L2527+36
	bl	printf
	ldr	r3, [sp, #4]
.L2518:
	mov	r0, r3
	bl	decrement_vpc_count
.L2517:
	adds	r7, r7, #1
	adds	r5, r5, #36
	b	.L2510
.L2515:
	orr	r3, r3, #-2147483648
	b	.L2526
.L2528:
	.align	2
.L2527:
	.word	.LANCHOR76
	.word	.LANCHOR15
	.word	.LANCHOR38
	.word	.LANCHOR228
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR52
	.word	.LANCHOR138
	.word	.LC56
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
	ldr	r3, .L2534
	ldr	r4, [r3]
	cbnz	r4, .L2530
	ldr	r5, .L2534+4
	ldr	r0, [r5]
	cbz	r0, .L2530
	ldr	r3, .L2534+8
	mov	r2, r4
	movs	r1, #1
	ldr	r3, [r3]
	bl	FtlProgPages
	str	r4, [r5]
.L2530:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2535:
	.align	2
.L2534:
	.word	.LANCHOR76
	.word	.LANCHOR132
	.word	.LANCHOR229
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
	ldr	r3, .L2538
	ldr	r3, [r3]
	cbnz	r3, .L2537
	bl	FtlCacheWriteBack
	bl	l2p_flush
	movs	r0, #1
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2537:
	movs	r0, #0
	pop	{r3, pc}
.L2539:
	.align	2
.L2538:
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
	ldr	r3, .L2542
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L2541
	bl	FtlSysFlush
.L2541:
	movs	r0, #0
	pop	{r3, pc}
.L2543:
	.align	2
.L2542:
	.word	.LANCHOR230
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
	ldr	r3, .L2560
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r5, r2
	adds	r2, r1, r2
	mov	r6, r1
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L2553
	cmp	r5, #31
	bhi	.L2547
.L2548:
	movs	r0, #0
.L2545:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2547:
	ldr	r3, .L2560+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2548
	ldr	r8, .L2560+16
	bl	FtlCacheWriteBack
	mov	r0, r6
	ldrh	r4, [r8]
	mov	r1, r4
	bl	__aeabi_uidiv
	smulbb	r3, r0, r4
	mov	r7, r0
	subs	r6, r6, r3
	uxth	r6, r6
	cbz	r6, .L2549
	subs	r4, r4, r6
	adds	r7, r7, #1
	cmp	r4, r5
	it	cs
	movcs	r4, r5
	uxth	r4, r4
	subs	r5, r5, r4
.L2549:
	ldr	r4, .L2560+8
	mov	r3, #-1
	ldr	r6, .L2560+12
	str	r3, [sp, #4]
.L2550:
	ldrh	r3, [r8]
	cmp	r5, r3
	bcs	.L2552
	ldr	r3, .L2560+8
	ldr	r2, [r3]
	cmp	r2, #32
	bls	.L2548
	movs	r4, #0
	str	r4, [r3]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L2548
.L2552:
	movs	r2, #0
	mov	r1, sp
	mov	r0, r7
	bl	log2phys
	ldr	r3, [sp]
	adds	r3, r3, #1
	beq	.L2551
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
.L2551:
	ldrh	r3, [r8]
	adds	r7, r7, #1
	subs	r5, r5, r3
	b	.L2550
.L2553:
	mov	r0, #-1
	b	.L2545
.L2561:
	.align	2
.L2560:
	.word	.LANCHOR68
	.word	.LANCHOR76
	.word	.LANCHOR231
	.word	.LANCHOR163
	.word	.LANCHOR55
	.size	ftl_discard, .-ftl_discard
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
	ldr	r7, .L2576
	sub	sp, sp, #32
	movs	r1, #0
	ldr	r8, .L2576+24
	ldr	r0, .L2576+4
	bl	printf
.L2563:
	ldr	r3, [r7]
	cmp	r5, r3
	bcc	.L2569
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2569:
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r5
	bl	log2phys
	ubfx	r3, r5, #0, #11
	cbnz	r3, .L2564
	ldr	r2, [sp, #28]
	mov	r1, r5
	mov	r0, r8
	bl	printf
.L2564:
	ldr	r3, [sp, #28]
	adds	r2, r3, #1
	beq	.L2566
	ldr	r4, .L2576+8
	movs	r2, #0
	movs	r1, #1
	str	r3, [r4, #4]
	mov	r0, r4
	ldr	r3, .L2576+12
	str	r5, [r4, #16]
	str	r2, [r4]
	ldr	r3, [r3]
	str	r3, [r4, #8]
	ldr	r3, .L2576+16
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FlashReadPages
	ldr	r3, [r4]
	cmp	r3, #256
	beq	.L2567
	adds	r3, r3, #1
	beq	.L2567
	ldr	r3, [r6, #8]
	cmp	r5, r3
	beq	.L2566
.L2567:
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #12]
	ldr	r0, .L2576+20
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
.L2566:
	adds	r5, r5, #1
	b	.L2563
.L2577:
	.align	2
.L2576:
	.word	.LANCHOR72
	.word	.LC57
	.word	.LANCHOR202
	.word	.LANCHOR183
	.word	.LANCHOR188
	.word	.LC59
	.word	.LC58
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
	ldr	r5, .L2588
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r2, [r5]
	mov	r7, r0
	ldrh	r3, [r2, r0, lsl #1]
	cmp	r3, #0
	bne	.L2579
	ldr	r2, .L2588+4
	ldr	r4, [r2]
	cmp	r4, #0
	beq	.L2580
	ldr	r2, .L2588+8
	movw	lr, #65535
	ldr	ip, .L2588+32
	ldr	r0, .L2588+12
	ldr	r2, [r2]
	ldrh	r1, [r0]
	mov	r8, r0
	subs	r4, r4, r2
	asrs	r4, r4, #1
	mul	r4, ip, r4
	mov	ip, #6
	uxth	r4, r4
.L2581:
	uxth	r0, r3
	cmp	r1, r0
	bls	.L2580
	cmp	r4, r7
	bne	.L2582
	mov	r1, r4
	ldr	r0, .L2588+4
	bl	List_remove_node
	ldrh	r3, [r8]
	cbnz	r3, .L2583
	ldr	r1, .L2588+16
	movw	r2, #2097
	ldr	r0, .L2588+20
	bl	printf
	ldr	r1, .L2588+24
	ldr	r0, .L2588+28
	bl	printf
.L2583:
	ldrh	r3, [r8]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r8]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r2, [r5]
	ldrh	r3, [r2, r7, lsl #1]
.L2579:
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	b	.L2580
.L2582:
	mul	r4, ip, r4
	adds	r3, r3, #1
	ldrh	r4, [r2, r4]
	cmp	r4, lr
	bne	.L2581
.L2580:
	movs	r2, #1
	add	r1, sp, #4
	mov	r0, r6
	bl	log2phys
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2589:
	.align	2
.L2588:
	.word	.LANCHOR83
	.word	.LANCHOR87
	.word	.LANCHOR81
	.word	.LANCHOR88
	.word	.LANCHOR232
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
	beq	.L2751
	ldrh	r3, [r0, #2]
	str	r3, [sp, #12]
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	str	r3, [sp, #28]
	ldr	r3, .L2760
	ldrh	r3, [r3]
	cmp	r3, r1
	mov	r3, #0
	bne	.L2593
	strh	r3, [r0, #4]	@ movhi
.L2758:
	strb	r3, [r10, #6]
.L2751:
	movs	r0, #0
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2593:
	ldrh	r0, [r0, #16]
.L2594:
	cmp	r0, r2
	uxth	r5, r3
	add	r3, r3, #1
	beq	.L2595
	ldrb	r1, [r10, #8]	@ zero_extendqisi2
	cmp	r1, #1
	bne	.L2596
	bl	FtlGetLastWrittenPage
	adds	r6, r0, #1
	mov	r4, r0
	beq	.L2597
	ldr	r3, .L2760+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2675
	ldr	r3, .L2760+8
	ldrh	r5, [r3, r0, lsl #1]
.L2598:
	ldr	r3, .L2760+12
	movw	r8, #65535
	mov	fp, #36
	ldrh	ip, [r3]
	ldr	r3, .L2760+16
	ldr	r0, [r3]
	ldr	r3, .L2760+20
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L2760+24
	ldrh	lr, [r3]
	add	r3, r10, #16
	str	r3, [sp, #20]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r6, r3
.L2599:
	uxth	r2, r3
	cmp	ip, r2
	bhi	.L2603
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L2676
	ldr	r3, .L2760+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #0
	it	ne
	movne	r3, #1
.L2752:
	str	r3, [sp, #36]
	mov	r1, r6
	ldr	r2, [sp, #36]
	movs	r7, #0
	bl	FlashReadPages
	ldr	r3, .L2760+28
	movw	fp, #65535
	ldr	r8, .L2760+16
	ldr	r3, [r3]
	subs	r3, r3, #1
	str	r3, [sp, #4]
.L2605:
	uxth	r3, r7
	cmp	r6, r3
	bhi	.L2610
	bne	.L2608
	adds	r4, r4, #1
	uxth	r3, r4
	str	r3, [sp, #8]
	ldr	r3, [r8]
	ldr	r0, [r3, #4]
.L2753:
	ubfx	r0, r0, #10, #16
	bl	P2V_plane
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	str	r0, [sp, #16]
	cmp	r3, #1
	bne	.L2612
	ldr	r2, .L2760+4
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L2612
	ldr	r1, [sp, #8]
	ldr	r2, .L2760+8
	ldrh	r2, [r2, r1, lsl #1]
	str	r2, [sp, #8]
.L2612:
	ldr	r2, .L2760
	ldr	r1, [sp, #8]
	ldrh	r2, [r2]
	cmp	r2, r1
	bne	.L2613
	ldrh	r2, [sp, #8]
	strh	r2, [r10, #2]	@ movhi
	movs	r2, #0
	strb	r2, [r10, #6]
	strh	r2, [r10, #4]	@ movhi
.L2613:
	ldr	r2, [sp, #8]
	ldr	r1, [sp, #12]
	cmp	r2, r1
	bne	.L2614
	ldr	r2, [sp, #16]
	ldr	r1, [sp, #28]
	cmp	r2, r1
	bne	.L2614
.L2759:
	ldr	r1, [sp, #8]
	mov	r0, r10
	bl	ftl_sb_update_avl_pages
	b	.L2751
.L2595:
	uxth	r1, r3
	adds	r1, r1, #8
	ldrh	r0, [r10, r1, lsl #1]
	b	.L2594
.L2596:
	movs	r1, #0
	bl	FtlGetLastWrittenPage
	mov	r4, r0
	adds	r0, r0, #1
	beq	.L2597
.L2675:
	mov	r5, r4
	b	.L2598
.L2597:
	ldr	r3, [sp, #12]
	cbz	r3, .L2600
	ldr	r1, .L2760+32
	movw	r2, #2168
	ldr	r0, .L2760+36
	bl	printf
	ldr	r1, .L2760+40
	ldr	r0, .L2760+44
	bl	printf
.L2600:
	ldr	r3, [sp, #28]
	cbz	r3, .L2601
	cmp	r5, r3
	beq	.L2601
	ldr	r1, .L2760+32
	movw	r2, #2169
	ldr	r0, .L2760+36
	bl	printf
	ldr	r1, .L2760+40
	ldr	r0, .L2760+44
	bl	printf
.L2601:
	movs	r3, #0
	strh	r3, [r10, #2]	@ movhi
	b	.L2758
.L2603:
	ldr	r1, [sp, #4]
	ldrh	r2, [r1], #2
	cmp	r2, r8
	str	r1, [sp, #4]
	beq	.L2602
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
.L2602:
	adds	r3, r3, #1
	b	.L2599
.L2676:
	movs	r3, #0
	b	.L2752
.L2610:
	movs	r3, #36
	ldr	r1, [r8]
	muls	r3, r7, r3
	adds	r2, r1, r3
	ldr	r3, [r1, r3]
	cbnz	r3, .L2606
	ldr	r2, [r2, #12]
	ldr	r3, [r2, #4]
	adds	r1, r3, #1
	beq	.L2607
	ldr	r1, .L2760+28
	mov	r0, r3
	ldr	r1, [r1]
	bl	ftl_cmp_data_ver
	cbz	r0, .L2607
	ldr	r1, .L2760+28
	adds	r3, r3, #1
	str	r3, [r1]
.L2607:
	ldr	r3, [r2]
	adds	r3, r3, #1
	bne	.L2609
.L2608:
	uxth	r3, r4
	uxth	r7, r7
	str	r3, [sp, #8]
	movs	r2, #36
	ldr	r3, [r8]
	mla	r7, r2, r7, r3
	ldr	r0, [r7, #4]
	b	.L2753
.L2606:
	ldr	r1, [r2, #4]
	uxth	fp, r5
	ldr	r0, .L2760+48
	bl	printf
	ldrh	r2, [r10]
	ldr	r3, .L2760+52
	strh	r2, [r3]	@ movhi
.L2609:
	adds	r7, r7, #1
	b	.L2605
.L2614:
	movw	r2, #65535
	cmp	fp, r2
	bne	.L2615
	cmp	r3, #0
	bne	.L2616
.L2615:
	ldr	r3, .L2760+56
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
.L2619:
	cmp	r4, fp
	bhi	.L2634
	ldr	r3, .L2760+12
	movw	lr, #65535
	mov	ip, #36
	ldrh	r8, [r3]
	ldr	r3, .L2760+16
	ldr	r0, [r3]
	ldr	r3, [sp, #20]
	str	r3, [sp, #32]
	movs	r3, #0
	mov	r5, r3
	b	.L2635
.L2621:
	ldr	r1, [sp, #32]
	ldrh	r2, [r1], #2
	cmp	r2, lr
	str	r1, [sp, #32]
	beq	.L2620
	mla	r1, ip, r5, r0
	adds	r5, r5, #1
	orr	r2, r4, r2, lsl #10
	uxth	r5, r5
	str	r2, [r1, #4]
.L2620:
	adds	r3, r3, #1
.L2635:
	uxth	r2, r3
	cmp	r8, r2
	bhi	.L2621
	mov	r1, r5
	ldr	r2, [sp, #36]
	bl	FlashReadPages
	ldr	r2, .L2760+4
	movs	r1, #36
	ldr	r3, .L2760+56
	movs	r0, #0
	movw	ip, #65535
	ldrb	lr, [r2]	@ zero_extendqisi2
	ldr	r2, .L2760+16
	ldr	r3, [r3]
	ldr	r2, [r2]
	mla	r5, r1, r5, r2
.L2622:
	cmp	r5, r2
	bne	.L2632
	cbz	r0, .L2633
	ldr	r2, .L2760+56
	str	r3, [r2]
.L2633:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L2619
.L2761:
	.align	2
.L2760:
	.word	.LANCHOR52
	.word	.LANCHOR15
	.word	.LANCHOR16
	.word	.LANCHOR38
	.word	.LANCHOR180
	.word	.LANCHOR105
	.word	.LANCHOR58
	.word	.LANCHOR160
	.word	.LANCHOR233
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC60
	.word	.LANCHOR234
	.word	.LANCHOR136
.L2632:
	ldr	r1, [r2]
	cbnz	r1, .L2623
	ldr	r1, [r2, #12]
	ldrh	r8, [r1]
	cmp	r8, ip
	beq	.L2679
	ldr	r1, [r1, #4]
	cmp	r1, #-1
	beq	.L2679
	adds	r0, r7, #1
	bne	.L2681
	ldr	r0, .L2762
	ldrh	r0, [r0, r4, lsl #1]
	cmp	r0, ip
	bne	.L2625
	cmp	lr, #0
	beq	.L2681
.L2625:
	ldr	r0, [sp, #4]
	cmp	r0, r3
	it	ne
	movne	r7, r3
.L2681:
	movs	r0, #1
	b	.L2624
.L2623:
	cbz	r0, .L2626
	ldr	r2, .L2762+4
	str	r3, [r2]
.L2626:
	ldr	r3, .L2762+8
	ldrh	r2, [r10]
	strh	r2, [r3]	@ movhi
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	cbnz	r3, .L2616
	ldr	r3, .L2762
	ldrh	r2, [r3, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2628
	adds	r1, r7, #1
	ldr	r3, .L2762+4
	beq	.L2629
	str	r7, [r3]
.L2616:
	ldr	fp, [sp, #12]
	movs	r2, #1
	ldr	r6, .L2762+12
	ldr	r3, .L2762+16
	strh	r2, [r3]	@ movhi
.L2636:
	ldr	r3, .L2762+20
	movw	ip, #65535
	ldr	r0, [r6]
	mov	lr, #36
	ldr	r1, [sp, #20]
	movs	r2, #0
	ldrh	r5, [r3]
	ldr	r3, .L2762+24
	str	r2, [sp, #24]
	ldrb	r7, [r3]	@ zero_extendqisi2
.L2637:
	uxth	r3, r2
	cmp	r3, r5
	bcc	.L2640
	ldr	r2, [sp, #36]
	ldr	r1, [sp, #24]
	bl	FlashReadPages
	movs	r3, #0
.L2757:
	str	r3, [sp, #32]
	ldr	r2, [sp, #24]
	ldrh	r3, [sp, #32]
	cmp	r2, r3
	bhi	.L2669
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	add	fp, fp, #1
	uxth	fp, fp
	cmp	r3, #1
	bne	.L2670
	ldr	r3, .L2762+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2670
	ldr	r3, .L2762+28
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2670
	ldr	r3, [sp, #8]
	cmp	r3, fp
	beq	.L2645
.L2670:
	ldr	r3, .L2762+32
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2636
	ldr	r2, .L2762+20
	movw	r0, #65535
	movs	r3, #0
	strh	fp, [r10, #2]	@ movhi
	strh	r3, [r10, #4]	@ movhi
	ldrh	r2, [r2]
.L2671:
	uxth	r1, r3
	cmp	r1, r2
	bcs	.L2751
	ldr	r1, [sp, #20]
	ldrh	r4, [r1], #2
	cmp	r4, r0
	str	r1, [sp, #20]
	add	r1, r3, #1
	bne	.L2758
	mov	r3, r1
	b	.L2671
.L2629:
	ldr	r2, [sp, #4]
	ldr	r1, [sp, #24]
	cmp	r2, r1
	itet	eq
	ldreq	r2, [r3]
	movne	r2, r1
	addeq	r2, r2, #-1
.L2754:
	str	r2, [r3]
	b	.L2616
.L2628:
	ldr	r3, [sp, #4]
	cmp	r6, r3
	beq	.L2631
	adds	r2, r6, #1
	beq	.L2616
	ldr	r3, .L2762+4
	str	r6, [r3]
	b	.L2616
.L2631:
	ldr	r2, .L2762+4
	ldr	r1, [sp, #4]
	ldr	r3, [r2]
	cmp	r1, r3
	beq	.L2616
	subs	r3, r3, #1
	str	r3, [r2]
	b	.L2616
.L2679:
	mov	r1, r3
	mov	r3, r6
.L2624:
	mov	r6, r3
	adds	r2, r2, #36
	mov	r3, r1
	b	.L2622
.L2634:
	mov	r2, #-1
	ldr	r3, .L2762+4
	b	.L2754
.L2640:
	ldrh	r3, [r1], #2
	cmp	r3, ip
	beq	.L2638
	ldr	r4, [sp, #24]
	orr	r3, fp, r3, lsl #10
	mla	r4, lr, r4, r0
	str	r3, [r4, #4]
	ldrb	r8, [r10, #8]	@ zero_extendqisi2
	cmp	r8, #1
	bne	.L2639
	cbz	r7, .L2639
	orr	r3, r3, #-2147483648
	str	r3, [r4, #4]
.L2639:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #24]
.L2638:
	adds	r2, r2, #1
	b	.L2637
.L2669:
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
	bcc	.L2642
	bne	.L2643
	ldr	r3, [sp, #28]
	cmp	r3, r0
	bhi	.L2642
.L2643:
	ldr	r3, [sp, #8]
	cmp	fp, r3
	bne	.L2644
	ldr	r3, [sp, #16]
	cmp	r3, r0
	beq	.L2645
.L2644:
	ldr	r3, [r8, r5]
	adds	r3, r3, #1
	beq	.L2646
	ldr	r3, [r7, #12]
	movw	r2, #61589
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L2647
	ldrh	r0, [r10]
.L2755:
	bl	decrement_vpc_count
	b	.L2642
.L2647:
	ldr	r2, [r3, #4]
	str	r2, [sp, #4]
	adds	r2, r2, #1
	beq	.L2648
	ldr	r2, .L2762+36
	ldr	r0, [sp, #4]
	ldr	r1, [r2]
	bl	ftl_cmp_data_ver
	cbz	r0, .L2648
	ldr	r1, [sp, #4]
	adds	r1, r1, #1
	str	r1, [r2]
.L2648:
	ldr	r4, [r3, #8]
	add	r1, sp, #48
	ldr	r3, [r3, #12]
	movs	r2, #0
	mov	r0, r4
	str	r3, [sp, #44]
	bl	log2phys
	ldr	r3, .L2762+4
	ldr	r1, [r3]
	adds	r3, r1, #1
	beq	.L2649
	ldr	r0, [sp, #4]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2649
	ldr	r3, [sp, #44]
	adds	r7, r3, #1
	beq	.L2650
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
	bne	.L2651
.L2652:
	mov	r3, #-1
	str	r3, [sp, #44]
.L2659:
	ldr	r7, [sp, #44]
	adds	r0, r7, #1
	beq	.L2642
.L2674:
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L2762+40
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2665
	ldr	r1, .L2762+44
	movw	r2, #2456
	ldr	r0, .L2762+48
	bl	printf
	ldr	r1, .L2762+52
	ldr	r0, .L2762+56
	bl	printf
.L2665:
	ldr	r3, .L2762+60
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, #0
	beq	.L2666
	mov	r0, r4
	b	.L2755
.L2650:
	ldr	r3, [sp, #52]
	ldr	r2, [sp, #48]
	cmp	r2, r3
	bne	.L2642
	movs	r2, #1
	add	r1, sp, #44
	mov	r0, r4
	bl	log2phys
.L2642:
	ldr	r3, [sp, #32]
	adds	r3, r3, #1
	b	.L2757
.L2651:
	ldr	r1, [r7, #8]
	cmp	r4, r1
	bne	.L2652
	ldr	r8, [r7, #4]
	ldr	r0, .L2762+4
	mov	r1, r8
	ldr	r0, [r0]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2652
	ldr	r1, [sp, #48]
	ldr	r0, [sp, #52]
	cmp	r1, r0
	bne	.L2654
.L2657:
	ldr	r1, [sp, #44]
	mov	r0, r4
	bl	FtlReUsePrevPpa
	b	.L2652
.L2763:
	.align	2
.L2762:
	.word	.LANCHOR120
	.word	.LANCHOR136
	.word	.LANCHOR234
	.word	.LANCHOR180
	.word	.LANCHOR235
	.word	.LANCHOR38
	.word	.LANCHOR15
	.word	.LANCHOR53
	.word	.LANCHOR52
	.word	.LANCHOR160
	.word	.LANCHOR40
	.word	.LANCHOR233
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR83
.L2654:
	ldr	r0, [sp, #44]
	cmp	r1, r0
	beq	.L2652
	adds	r0, r1, #1
	beq	.L2655
	str	r1, [r3, #4]
	movs	r2, #0
	movs	r1, #1
	mov	r0, r3
	ldr	r7, [r3, #12]
	bl	FlashReadPages
.L2656:
	ldr	r3, [r6]
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L2657
	ldr	r3, [r7, #4]
	ldr	r2, .L2764
	mov	r1, r3
	ldr	r0, [r2]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2657
	mov	r1, r3
	mov	r0, r8
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2652
	b	.L2657
.L2655:
	str	r1, [r2, r5]
	b	.L2656
.L2649:
	ldr	r3, [sp, #52]
	ldr	r2, [sp, #48]
	cmp	r2, r3
	beq	.L2659
	ldr	r2, .L2764+4
	ldr	r3, [sp, #44]
	ldr	r2, [r2]
	cmp	r2, r3, lsr #10
	bhi	.L2661
	adds	r3, r3, #1
	bne	.L2642
.L2661:
	movs	r2, #1
	add	r1, sp, #52
	mov	r0, r4
	bl	log2phys
	ldr	r7, [sp, #48]
	adds	r5, r7, #1
	beq	.L2659
	ldr	r3, [sp, #44]
	cmp	r7, r3
	beq	.L2674
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L2764+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L2664
	ldr	r3, .L2764+12
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L2664
	ldr	r3, .L2764+16
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L2659
.L2664:
	ldr	r0, [r6]
	movs	r2, #0
	movs	r1, #1
	str	r7, [r0, #4]
	ldr	r5, [r0, #12]
	bl	FlashReadPages
	ldr	r3, [r6]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L2659
	ldr	r1, [r5, #4]
	ldr	r0, [sp, #4]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	bne	.L2659
	movs	r2, #1
	add	r1, sp, #48
	mov	r0, r4
	bl	log2phys
	b	.L2659
.L2666:
	mov	r1, r4
	ldr	r0, .L2764+20
	bl	printf
	b	.L2642
.L2646:
	ldrh	r3, [r10]
	mov	r1, r4
	ldr	r2, .L2764+24
	ldr	r0, .L2764+28
	strh	r3, [r2]	@ movhi
	ldr	r2, [sp, #4]
	bl	printf
	ldr	r2, .L2764+32
	ldr	r3, [r2]
	cmp	r3, #31
	bhi	.L2667
	ldr	r0, [sp, #52]
	ldr	r1, .L2764+36
	str	r0, [r1, r3, lsl #2]
	adds	r3, r3, #1
	str	r3, [r2]
.L2667:
	ldrh	r0, [r10]
	bl	decrement_vpc_count
	ldr	r3, .L2764
	ldr	r2, [r3]
	adds	r1, r2, #1
	bne	.L2668
	ldr	r2, [sp, #4]
.L2756:
	str	r2, [r3]
	b	.L2642
.L2668:
	ldr	r1, [sp, #4]
	cmp	r1, r2
	bcs	.L2642
	mov	r2, r1
	b	.L2756
.L2645:
	ldrb	r3, [sp, #16]	@ zero_extendqisi2
	ldr	r2, [sp, #16]
	strb	r3, [r10, #6]
	ldrh	r3, [sp, #8]
	strh	r3, [r10, #2]	@ movhi
	b	.L2759
.L2765:
	.align	2
.L2764:
	.word	.LANCHOR136
	.word	.LANCHOR43
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LC61
	.word	.LANCHOR234
	.word	.LC62
	.word	.LANCHOR236
	.word	.LANCHOR237
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
	ldr	r3, .L2804
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	sub	sp, sp, #64
	ldrh	r5, [r3]
	movw	r3, #65535
	cmp	r5, r3
	beq	.L2792
	cbnz	r5, .L2767
.L2768:
	bl	FtlGcPageVarInit
	b	.L2769
.L2792:
	movs	r5, #0
.L2767:
	ldr	r3, .L2804+4
	ldrh	r3, [r3]
	cmp	r3, r1
	beq	.L2768
.L2769:
	ldr	r8, .L2804+72
	mov	r3, #-1
	str	r3, [sp, #8]
.L2770:
	ldrh	r2, [r4]
	movs	r3, #0
	strb	r3, [r4, #8]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2771
.L2791:
	ldr	r3, .L2804+8
	movs	r2, #0
	ldr	r0, [r8]
	mov	fp, r2
	movw	ip, #65535
	mov	lr, #36
	ldrh	r10, [r3]
	ldr	r3, .L2804+12
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2804+16
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L2804+20
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L2804+24
	ldrh	r7, [r3]
	add	r3, r4, #16
	str	r3, [sp, #4]
.L2772:
	uxth	r3, r2
	cmp	r10, r3
	bhi	.L2774
	mov	r10, #0
	movs	r2, #0
	mov	r1, fp
	bl	FlashReadPages
.L2775:
	uxth	r3, r10
	cmp	fp, r3
	bhi	.L2790
	ldr	r3, .L2804+4
	adds	r5, r5, #1
	uxth	r5, r5
	ldrh	r3, [r3]
	cmp	r3, r5
	bhi	.L2791
.L2771:
	ldr	r3, .L2804
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
.L2774:
	ldr	r1, [sp, #4]
	ldrh	r3, [r1], #2
	cmp	r3, ip
	str	r1, [sp, #4]
	beq	.L2773
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
.L2773:
	adds	r2, r2, #1
	b	.L2772
.L2790:
	movs	r7, #36
	ldr	r2, [r8]
	mul	r7, r7, r10
	adds	r3, r2, r7
	ldr	r6, [r2, r7]
	ldr	r1, [r3, #4]
	str	r1, [sp, #4]
	cmp	r6, #0
	bne	.L2776
	ldr	r3, [r3, #12]
	movw	r2, #65535
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L2803
	ldr	r2, .L2804+28
	ldr	r0, [r3, #8]
	ldr	r2, [r2]
	cmp	r0, r2
	bls	.L2778
.L2803:
	ldrh	r2, [r4]
.L2789:
	ldr	r3, .L2804+32
	movs	r1, #0
	movs	r5, #0
	ldr	r3, [r3]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r4]
	bl	INSERT_FREE_LIST
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
	bl	FtlGcPageVarInit
	b	.L2770
.L2778:
	ldr	r2, .L2804+36
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L2780
.L2781:
	ldr	r2, [r3, #8]
	add	r10, r10, #1
	ldr	r1, [sp, #4]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L2775
.L2780:
	mov	r2, r6
	add	r1, sp, #24
	str	r3, [sp, #12]
	bl	log2phys
	ldr	r3, [sp, #12]
	ldr	r1, [sp, #24]
	ldr	r2, [r3, #12]
	cmp	r2, r1
	bne	.L2781
	adds	r1, r2, #1
	beq	.L2781
	str	r2, [sp, #32]
	movs	r1, #1
	ldr	r2, .L2804+40
	add	r0, sp, #28
	ldr	r2, [r2]
	str	r2, [sp, #36]
	ldr	r2, .L2804+44
	ldr	r2, [r2]
	str	r2, [sp, #40]
	mov	r2, r6
	bl	FlashReadPages
	ldr	r2, .L2804+48
	ldr	r1, [r8]
	ldr	r0, [sp, #36]
	ldrh	r2, [r2]
	ldr	r3, [sp, #12]
	add	r7, r7, r1
	lsl	ip, r2, #7
.L2782:
	cmp	r6, ip
	beq	.L2781
	ldr	r1, [r7, #8]
	ldr	r2, [r0, r6, lsl #2]
	ldr	r1, [r1, r6, lsl #2]
	cmp	r1, r2
	beq	.L2783
	ldr	r2, [sp, #32]
	ldrh	r1, [r4]
	ldr	r0, .L2804+52
	bl	printf
	b	.L2803
.L2783:
	adds	r6, r6, #1
	b	.L2782
.L2776:
	ldr	r2, [sp, #4]
	ldrh	r1, [r4]
	ldr	r0, .L2804+56
	bl	printf
	ldr	r3, .L2804+60
	ldrh	r2, [r4]
	ldr	r3, [r3]
	cbnz	r3, .L2786
	ldr	r3, .L2804+64
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2787
.L2786:
	ldr	r3, .L2804+68
	ldr	r3, [r3]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r3, #159
	bls	.L2788
.L2787:
	ldr	r3, [r8]
	ldr	r3, [r3, r7]
	adds	r3, r3, #1
	bne	.L2789
.L2788:
	ldr	r3, [r8]
	add	r7, r7, r3
	ldr	r3, [r7, #4]
	str	r3, [sp, #8]
	b	.L2789
.L2805:
	.align	2
.L2804:
	.word	.LANCHOR238
	.word	.LANCHOR52
	.word	.LANCHOR38
	.word	.LANCHOR104
	.word	.LANCHOR57
	.word	.LANCHOR105
	.word	.LANCHOR58
	.word	.LANCHOR72
	.word	.LANCHOR83
	.word	.LANCHOR1
	.word	.LANCHOR187
	.word	.LANCHOR189
	.word	.LANCHOR55
	.word	.LC63
	.word	.LC64
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
	ldr	r3, .L2829
	ldr	r3, [r3]
	cbz	r3, .L2807
.L2812:
	movs	r0, #0
.L2806:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2807:
	ldr	r0, .L2829+4
	movw	r3, #65535
	ldr	r5, .L2829+8
	ldrh	r6, [r0]
	mov	r4, r0
	cmp	r6, r3
	beq	.L2809
	ldr	r3, .L2829+12
	ldrh	r1, [r3]
	bl	FtlGcScanTempBlk
	str	r0, [sp, #12]
	adds	r0, r0, #1
	beq	.L2809
	ldr	r3, .L2829+16
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	cmp	r3, #4
	bls	.L2810
	subs	r3, r3, #5
	movs	r0, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	bl	FtlEctTblFlush
.L2810:
	ldr	r3, [r5]
	cbnz	r3, .L2811
	ldr	r2, .L2829+20
	ldr	r0, [sp, #12]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L2811:
	movs	r3, #0
	movs	r0, #1
	str	r3, [r5]
	b	.L2806
.L2809:
	ldrh	r2, [r4]
	movs	r3, #0
	str	r3, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2812
	ldr	r6, .L2829+12
	bl	FtlCacheWriteBack
	ldrb	r0, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r6]
	ldr	r5, .L2829+24
	muls	r2, r0, r2
	ldrh	r1, [r5]
	cmp	r1, r2
	beq	.L2813
	ldr	r1, .L2829+28
	movs	r2, #163
	ldr	r0, .L2829+32
	bl	printf
	ldr	r1, .L2829+36
	ldr	r0, .L2829+40
	bl	printf
.L2813:
	ldrh	r6, [r6]
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldr	r2, .L2829+44
	ldrh	r0, [r4]
	ldr	fp, .L2829+84
	smulbb	r3, r3, r6
	ldr	r1, [r2]
	movs	r6, #0
	str	r2, [sp, #4]
	strh	r3, [r1, r0, lsl #1]	@ movhi
	ldr	r1, .L2829+48
	ldrh	r3, [r5]
	ldr	r0, [r1]
	add	r3, r3, r0
	str	r3, [r1]
.L2814:
	ldrh	r2, [r5]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L2818
	movw	r0, #65535
	bl	decrement_vpc_count
	ldr	r3, .L2829+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2819
	ldrh	r1, [r4]
	ldr	r0, .L2829+56
	bl	printf
.L2819:
	ldr	r3, [sp, #4]
	ldrh	r0, [r4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	beq	.L2820
	bl	INSERT_DATA_LIST
.L2821:
	ldr	r3, .L2829+60
	movw	r6, #65535
	strh	r6, [r4]	@ movhi
	movs	r4, #0
	strh	r4, [r5]	@ movhi
	strh	r4, [r3]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	r3, .L2829+64
	strh	r6, [r3]	@ movhi
	ldr	r3, .L2829+68
	ldrh	r2, [r3]
	ldr	r3, .L2829+72
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	cmp	r2, r3, asr #2
	ble	.L2812
	ldr	r3, .L2829+76
	movs	r2, #20
	mov	r0, r4
	strh	r2, [r3]	@ movhi
	b	.L2806
.L2818:
	uxth	r3, r6
	movs	r7, #12
	ldr	r2, [fp]
	muls	r7, r3, r7
	ldr	r3, .L2829+80
	ldr	r8, [r3]
	add	r10, r8, r7
	ldr	r1, [r10, #8]
	cmp	r1, r2
	bcc	.L2815
	ldr	r1, .L2829+28
	movs	r2, #168
	ldr	r0, .L2829+32
	bl	printf
	ldr	r1, .L2829+36
	ldr	r0, .L2829+40
	bl	printf
.L2815:
	movs	r2, #0
	add	r1, sp, #12
	ldr	r0, [r10, #8]
	bl	log2phys
	ldr	r2, [sp, #12]
	ldr	r0, [r8, r7]
	cmp	r0, r2
	bne	.L2816
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	movs	r2, #1
	mov	r7, r0
	add	r1, r10, #4
	ldr	r0, [r10, #8]
	bl	log2phys
	mov	r0, r7
.L2828:
	bl	decrement_vpc_count
.L2817:
	adds	r6, r6, #1
	b	.L2814
.L2816:
	ldr	r3, [r10, #4]
	cmp	r2, r3
	beq	.L2817
	ldrh	r0, [r4]
	b	.L2828
.L2820:
	bl	INSERT_FREE_LIST
	b	.L2821
.L2830:
	.align	2
.L2829:
	.word	.LANCHOR76
	.word	.LANCHOR93
	.word	.LANCHOR135
	.word	.LANCHOR52
	.word	.LANCHOR78
	.word	.LANCHOR138
	.word	.LANCHOR110
	.word	.LANCHOR239
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR83
	.word	.LANCHOR161
	.word	.LANCHOR15
	.word	.LC65
	.word	.LANCHOR109
	.word	.LANCHOR204
	.word	.LANCHOR88
	.word	.LANCHOR223
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
	ldr	r4, .L2834
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L2832
	ldrh	r3, [r4, #4]
	cbnz	r3, .L2833
.L2832:
	bl	FtlCacheWriteBack
	movs	r0, #0
	movs	r5, #0
	bl	FtlGcFreeTempBlock
	ldr	r0, .L2834
	strb	r5, [r4, #8]
	bl	allocate_data_superblock
	ldr	r3, .L2834+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L2834+8
	strh	r5, [r3]	@ movhi
	bl	l2p_flush
	mov	r0, r5
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2833:
	ldr	r0, .L2834
	pop	{r3, r4, r5, lr}
	b	get_new_active_ppa
.L2835:
	.align	2
.L2834:
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
	ldr	r3, .L2851
	ldr	r3, [r3]
	cbz	r3, .L2837
.L2840:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L2837:
	ldr	r3, .L2851+4
	ldr	r5, .L2851+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2839
	ldr	r3, [r5]
	lsls	r2, r3, #31
	bpl	.L2839
	ldr	r3, .L2851+12
	ldrh	r3, [r3, #4]
	cmp	r3, #0
	bne	.L2840
.L2839:
	ldr	r4, .L2851+16
	movs	r3, #0
	movs	r6, #0
	movs	r7, #36
	mov	r2, r3
	ldr	r1, [r5]
	ldr	r0, [r4]
	bl	FlashProgPages
.L2841:
	ldr	r1, [r5]
	uxth	r3, r6
	cmp	r3, r1
	bcc	.L2843
	ldr	r0, [r4]
	bl	FtlGcBufFree
	movs	r3, #0
	str	r3, [r5]
	ldr	r3, .L2851+12
	ldrh	r3, [r3, #4]
	cmp	r3, #0
	bne	.L2840
	movs	r0, #1
	bl	FtlGcFreeTempBlock
	b	.L2850
.L2843:
	muls	r3, r7, r3
	ldr	r2, [r4]
	adds	r6, r6, #1
	adds	r1, r2, r3
	ldr	r2, [r2, r3]
	adds	r3, r2, #1
	bne	.L2842
	ldr	r3, .L2851+12
	movs	r5, #0
	ldr	r0, .L2851+20
	ldrh	r4, [r3]
	ldr	r0, [r0]
	strh	r5, [r0, r4, lsl #1]	@ movhi
	strh	r2, [r3]	@ movhi
	ldr	r2, .L2851+24
	ldr	r0, [r1, #4]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
.L2850:
	movs	r0, #1
	pop	{r3, r4, r5, r6, r7, pc}
.L2842:
	ldr	r3, [r1, #12]
	ldr	r1, [r1, #4]
	ldr	r2, [r3, #8]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L2841
.L2852:
	.align	2
.L2851:
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
	ldr	r4, .L2855
	ldr	r5, .L2855+4
	ldrh	r1, [r4]
	mov	r0, r5
	bl	FtlGcScanTempBlk
	ldrh	r2, [r5, #2]
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L2853
	ldr	r0, .L2855+8
	bl	FtlMapBlkWriteDumpData
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r3, .L2855+12
	movs	r2, #0
	str	r2, [r3]
.L2853:
	pop	{r3, r4, r5, pc}
.L2856:
	.align	2
.L2855:
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
	ldr	r5, .L2858
	ldr	r3, .L2858+4
	mov	r0, r5
	str	r4, [r3]
	bl	FtlRecoverySuperblock
	mov	r0, r5
	ldr	r5, .L2858+8
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
.L2859:
	.align	2
.L2858:
	.word	.LANCHOR91
	.word	.LANCHOR236
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
	ldr	r4, .L2869
	movw	r5, #65535
	strh	r3, [r4]	@ movhi
	ldr	r3, .L2869+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L2869+8
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	ldr	r3, .L2869+12
	ldrh	r3, [r3]
	cmp	r3, r5
	mov	r5, r4
	bne	.L2861
.L2863:
	mov	r4, #-1
.L2860:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L2861:
	bl	FtlLoadSysInfo
	mov	r4, r0
	cmp	r0, #0
	bne	.L2863
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	movs	r0, #1
	bl	FtlUpdateVaildLpn
	ldr	r3, .L2869+16
	movs	r0, #12
	ldrh	r2, [r3]
	ldr	r3, .L2869+20
	ldr	r1, [r3]
	mov	r3, r4
.L2864:
	cmp	r3, r2
	blt	.L2866
	ldrh	r3, [r5]
	cmp	r3, #0
	beq	.L2867
.L2865:
	ldr	r3, .L2869+24
	ldr	r1, [r3]
	ldr	r3, .L2869+28
	ldrh	r0, [r3]
	ldrh	r5, [r3, #4]
	ldrh	r2, [r1, r0, lsl #1]
	subs	r2, r2, r5
	ldr	r5, .L2869+32
	strh	r2, [r1, r0, lsl #1]	@ movhi
	ldrh	r2, [r5]
	strh	r2, [r3, #2]	@ movhi
	movs	r2, #0
	strh	r2, [r3, #4]	@ movhi
	strb	r2, [r3, #6]
	ldr	r3, .L2869+36
	ldrh	r6, [r3]
	ldrh	r7, [r3, #4]
	ldrh	r0, [r1, r6, lsl #1]
	subs	r0, r0, r7
	strh	r0, [r1, r6, lsl #1]	@ movhi
	strb	r2, [r3, #6]
	ldrh	r1, [r5]
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L2869+40
	strh	r1, [r3, #2]	@ movhi
	ldrh	r3, [r2, #30]
	adds	r3, r3, #1
	strh	r3, [r2, #30]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2868:
	bl	FtlVpcTblFlush
	b	.L2860
.L2866:
	mla	r6, r0, r3, r1
	ldr	r6, [r6, #4]
	cmp	r6, #0
	blt	.L2865
	adds	r3, r3, #1
	b	.L2864
.L2867:
	bl	l2p_flush
	b	.L2868
.L2870:
	.align	2
.L2869:
	.word	.LANCHOR235
	.word	.LANCHOR234
	.word	.LANCHOR39
	.word	.LANCHOR209
	.word	.LANCHOR67
	.word	.LANCHOR96
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
	ldr	r3, .L2902
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r4, [r3]
	cmp	r4, #0
	bne	.L2873
	ldr	r5, .L2902+4
	mov	r1, r4
	ldr	r3, .L2902+8
	ldr	r6, .L2902+12
	ldrh	r2, [r5]
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L2902+16
	ldr	r5, .L2902+20
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L2902+24
	ldrh	r0, [r6]
	str	r4, [r5]
	str	r4, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L2874
	bl	FtlMakeBbt
.L2874:
	ldr	r3, .L2902+28
	ldr	r2, .L2902+32
	ldr	ip, .L2902+112
	ldrh	r1, [r3]
	ldr	r4, [r2]
	ldr	r2, .L2902+36
	str	r3, [sp, #12]
	lsls	r1, r1, #7
	ldr	r7, [r2]
	movs	r2, #0
.L2875:
	uxth	r3, r2
	adds	r2, r2, #1
	cmp	r3, r1
	blt	.L2876
	ldr	r3, .L2902+40
	movs	r7, #0
	ldr	fp, .L2902+116
	ldrh	r4, [r3]
	mov	r8, r3
	mov	r10, fp
.L2877:
	ldrh	r3, [fp]
	cmp	r3, r4
	bhi	.L2878
	ldr	r4, .L2902+44
	subs	r3, r7, #2
	ldrh	r1, [r4]
	cmp	r3, r1, lsl #1
	bgt	.L2879
.L2883:
	movs	r7, #0
	mov	r6, r7
.L2880:
	ldrh	r3, [r8]
	uxth	r0, r7
	adds	r7, r7, #1
	cmp	r3, r0
	bhi	.L2884
	ldrh	r2, [r10]
	ldr	r3, .L2902+48
	ldrh	r4, [r4]
	ldr	r7, .L2902+52
	str	r2, [r3]
	ldr	r3, .L2902+56
	mov	r1, r4
	ldr	r3, [r3]
	mov	r0, r3
	str	r3, [sp, #16]
	bl	__aeabi_uidiv
	ldr	r1, .L2902+60
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
	ble	.L2885
	ldr	r3, [sp, #16]
	mov	r1, r4
	subs	r0, r3, r6
	bl	__aeabi_uidiv
	ldr	r3, [sp, #8]
	str	r0, [r7]
	lsrs	r0, r0, #5
	adds	r0, r0, #24
	strh	r0, [r3]	@ movhi
.L2885:
	ldr	r3, .L2902+64
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L2886
	ldr	r2, .L2902+60
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
.L2886:
	ldr	r3, .L2902+68
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2887
	ldr	r2, .L2902+60
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
.L2887:
	ldr	r3, .L2902+72
	ldrh	r3, [r3]
	cbz	r3, .L2889
	ldr	r2, .L2902+60
	ldrh	r1, [r2]
	add	r1, r1, r3, lsr #1
	strh	r1, [r2]	@ movhi
	mul	r1, r4, r3
	cmp	r6, r1
	bge	.L2889
	ldr	r1, [sp, #4]
	adds	r3, r3, #32
	str	fp, [r7]
	add	r1, r1, r3
	strh	r1, [r2]	@ movhi
.L2889:
	ldr	r3, [sp, #8]
	ldr	r6, .L2902+76
	ldrh	r2, [r3]
	ldr	r3, [r7]
	subs	r3, r3, r2
	muls	r4, r3, r4
	ldr	r3, .L2902+80
	ldrh	r3, [r3]
	str	r4, [r6]
	muls	r4, r3, r4
	ldr	r3, [sp, #12]
	ldrh	r3, [r3]
	str	r4, [r7]
	ldr	r7, .L2902+84
	muls	r4, r3, r4
	ldr	r3, .L2902+88
	str	r4, [r3]
	movw	r4, #65535
	bl	FtlBbmTblFlush
	ldrh	r2, [r10]
	movs	r1, #0
	ldr	r10, .L2902+120
	lsls	r2, r2, #1
	ldr	r0, [r10]
	bl	ftl_memset
	ldr	r2, .L2902+92
	movs	r3, #0
	strh	r3, [r7, #2]	@ movhi
	movs	r1, #255
	strb	r3, [r7, #6]
	str	r3, [r2]
	ldr	r2, .L2902+96
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
	ldr	r3, .L2902+100
	lsrs	r2, r2, #3
	ldr	r0, [r3]
	bl	ftl_memset
.L2891:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r7, #7]	@ zero_extendqisi2
	ldrh	r2, [r7]
	cmp	r3, #0
	bne	.L2892
	ldr	r3, [r8]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r7]
	adds	r3, r3, #1
	strh	r3, [r7]	@ movhi
	b	.L2891
.L2876:
	mvns	r0, r3
	orr	r0, r3, r0, lsl #16
	str	r0, [r4, r3, lsl #2]
	str	ip, [r7, r3, lsl #2]
	b	.L2875
.L2878:
	mov	r0, r4
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r4, r4, #1
	add	r7, r7, r0
	uxth	r7, r7
	uxth	r4, r4
	b	.L2877
.L2879:
	mov	r0, r7
	bl	__aeabi_uidiv
	ldr	r3, .L2902+104
	ldr	r3, [r3]
	add	r0, r0, r3
	uxth	r0, r0
	bl	FtlSysBlkNumInit
	ldrh	r0, [r6]
	bl	FtlFreeSysBlkQueueInit
	ldrh	r6, [r8]
.L2881:
	ldrh	r3, [r10]
	cmp	r3, r6
	bls	.L2883
	mov	r0, r6
	movs	r1, #1
	adds	r6, r6, #1
	bl	FtlLowFormatEraseBlock
	uxth	r6, r6
	b	.L2881
.L2884:
	movs	r1, #0
	bl	FtlLowFormatEraseBlock
	add	r6, r6, r0
	uxth	r6, r6
	b	.L2880
.L2892:
	ldr	r3, [r5]
	ldrh	r1, [r7, #4]
	ldr	r4, .L2902+108
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
.L2893:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r4]
	cmp	r3, #0
	bne	.L2894
	ldr	r3, [r8]
	strh	r7, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L2893
.L2903:
	.align	2
.L2902:
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
	.word	.LANCHOR223
	.word	.LANCHOR28
	.word	.LANCHOR15
	.word	.LANCHOR49
	.word	.LANCHOR222
	.word	.LANCHOR52
	.word	.LANCHOR91
	.word	.LANCHOR68
	.word	.LANCHOR100
	.word	.LANCHOR204
	.word	.LANCHOR0
	.word	.LANCHOR65
	.word	.LANCHOR92
	.word	168778952
	.word	.LANCHOR41
	.word	.LANCHOR83
.L2894:
	ldr	r3, [r5]
	ldrh	r1, [r4, #4]
	str	r3, [r4, #12]
	adds	r3, r3, #1
	str	r3, [r5]
	movw	r4, #65535
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L2904
	strh	r4, [r3]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L2904+4
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
	cbnz	r0, .L2873
	ldr	r3, .L2904+8
	movs	r2, #1
	str	r2, [r3]
.L2873:
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2905:
	.align	2
.L2904:
	.word	.LANCHOR93
	.word	.LANCHOR209
	.word	.LANCHOR230
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
	ldr	r3, .L2996
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	ldr	r2, [r3]
	cmp	r2, #0
	bne	.L2958
	ldr	r3, .L2996+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2958
	ldr	r2, .L2996+8
	ldrh	r2, [r2]
	cmp	r2, #47
	bls	.L2960
	ldr	r5, .L2996+12
	movw	r2, #65535
	ldrh	ip, [r5]
	cmp	ip, r2
	beq	.L2908
	ldr	r7, .L2996+16
	ldrh	r3, [r7]
	cmp	r3, r2
	bne	.L2908
	ldr	r1, .L2996+20
	ldrh	r6, [r1]
	cmp	r6, r3
	beq	.L2908
	ldr	r2, .L2996+24
	ldrh	r4, [r2]
	cmp	r4, r3
	itttt	ne
	strhne	ip, [r7]	@ movhi
	strhne	r6, [r5]	@ movhi
	strhne	r4, [r1]	@ movhi
	strhne	r3, [r2]	@ movhi
.L2908:
	cmp	r0, #0
	bne	.L2961
	ldr	r3, .L2996+28
	ldrh	r3, [r3]
	cmp	r3, #24
	bhi	.L2962
	ldr	r2, .L2996+32
	cmp	r3, #16
	ldrh	r4, [r2]
	bls	.L2911
	lsrs	r4, r4, #5
.L2910:
	ldr	r2, .L2996+36
	ldrh	r1, [r2]
	cmp	r1, r3
	mov	r1, r2
	bcs	.L2914
	ldr	r3, .L2996+40
	movw	r0, #65535
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L2915
	ldr	r0, .L2996+16
	ldrh	r0, [r0]
	cmp	r0, r3
	bne	.L2915
	ldr	r3, .L2996+44
	ldrh	r0, [r3]
	cbnz	r0, .L2916
	ldr	r3, .L2996+48
	ldr	r4, .L2996+52
	ldr	r3, [r3]
	ldr	r4, [r4]
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, lsr #2
	bcs	.L2917
.L2916:
	ldr	r3, .L2996+56
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L2918:
	ldr	r3, .L2996+60
	movs	r2, #0
	str	r2, [r3]
.L2906:
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2911:
	cmp	r3, #12
	bls	.L2912
	lsrs	r4, r4, #4
	b	.L2910
.L2912:
	cmp	r3, #8
	bls	.L2910
	lsrs	r4, r4, #2
	b	.L2910
.L2962:
	movs	r4, #1
	b	.L2910
.L2917:
	movs	r3, #18
	strh	r3, [r2]	@ movhi
	b	.L2918
.L2915:
	ldr	r3, .L2996+56
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L2914:
	ldr	r3, .L2996+64
	ldrh	r3, [r3]
	cbz	r3, .L2909
	adds	r4, r4, #32
	uxth	r4, r4
.L2909:
	ldr	r5, .L2996+68
	movw	r3, #65535
	ldrh	r2, [r5]
	cmp	r2, r3
	bne	.L2921
	ldr	r3, .L2996+16
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L2922
	ldr	r0, .L2996+72
	ldr	r0, [r0]
	ldrh	r1, [r0, r1, lsl #1]
	cbnz	r1, .L2923
	strh	r2, [r3]	@ movhi
.L2923:
	ldrh	r2, [r3]
	strh	r2, [r5]	@ movhi
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
.L2922:
	ldrh	r0, [r5]
	movw	r6, #65535
	movs	r3, #0
	strb	r3, [r5, #8]
	cmp	r0, r6
	beq	.L2921
	bl	IsBlkInGcList
	cbz	r0, .L2925
	strh	r6, [r5]	@ movhi
.L2925:
	ldr	r3, .L2996+76
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2926
	ldrh	r0, [r5]
	bl	ftl_get_blk_mode
	strb	r0, [r5, #8]
.L2926:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2921
	ldr	r0, .L2996+68
	bl	make_superblock
	ldr	r2, .L2996+80
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r3, [r2]	@ movhi
	ldr	r3, .L2996+72
	ldrh	r2, [r5]
	ldr	r3, [r3]
	ldrh	r2, [r3, r2, lsl #1]
	ldr	r3, .L2996+84
	strh	r2, [r3]	@ movhi
.L2921:
	ldr	r2, .L2996+88
	ldrh	r3, [r5]
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L2927
	ldr	r2, .L2996+92
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L2927
	ldr	r5, .L2996+68
	mov	r6, r5
.L2928:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2929
	ldr	r10, .L2996+100
	movs	r2, #0
	ldr	r3, .L2996+60
	mov	r7, r10
	str	r2, [r3]
.L2930:
	ldrh	r8, [r10]
	mov	r0, r8
	bl	List_get_gc_head_node
	uxth	fp, r0
	movw	r3, #65535
	cmp	fp, r3
	strh	fp, [r6]	@ movhi
	bne	.L2931
	movs	r3, #0
	movs	r0, #8
	strh	r3, [r10]	@ movhi
	b	.L2906
.L2961:
	movs	r4, #1
	b	.L2909
.L2927:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L2994:
	ldr	r3, .L2996+44
	ldrh	r0, [r3]
	b	.L2906
.L2931:
	str	r0, [sp, #8]
	mov	r0, fp
	bl	IsBlkInGcList
	add	r3, r8, #1
	ldr	r2, [sp, #8]
	cbz	r0, .L2932
	strh	r3, [r10]	@ movhi
	b	.L2930
.L2932:
	ldr	r1, .L2996+32
	uxth	r3, r3
	ldr	lr, .L2996+104
	uxth	r2, r2
	ldr	r8, .L2996+72
	ldrh	r1, [r1]
	ldrh	lr, [lr]
	ldr	r0, [r8]
	strh	r3, [r10]	@ movhi
	mul	r1, lr, r1
	ldrh	ip, [r0, r2, lsl #1]
	cmp	ip, r1, asr #1
	bgt	.L2934
	cmp	r3, #48
	bls	.L2935
	cmp	ip, #8
	bls	.L2935
	ldr	r3, .L2996+96
	ldrh	r3, [r3]
	cmp	r3, #35
	bhi	.L2935
.L2934:
	movs	r3, #0
	strh	r3, [r7]	@ movhi
.L2935:
	ldrh	r3, [r0, r2, lsl #1]
	cmp	r1, r3
	bgt	.L2936
	ldrh	r2, [r7]
	cmp	r2, #3
	bhi	.L2936
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
	movs	r3, #0
	strh	r3, [r7]	@ movhi
	b	.L2994
.L2936:
	cmp	r3, #0
	bne	.L2937
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r3, [r7]
	adds	r3, r3, #1
	strh	r3, [r7]	@ movhi
	b	.L2930
.L2997:
	.align	2
.L2996:
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
	.word	.LANCHOR240
	.word	.LANCHOR72
	.word	.LANCHOR100
	.word	.LANCHOR223
	.word	.LANCHOR172
	.word	.LANCHOR116
	.word	.LANCHOR204
	.word	.LANCHOR83
	.word	.LANCHOR15
	.word	.LANCHOR241
	.word	.LANCHOR242
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR109
	.word	.LANCHOR178
	.word	.LANCHOR38
.L2937:
	movs	r3, #0
	strb	r3, [r6, #8]
	ldr	r3, .L2998
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2938
	mov	r0, fp
	bl	ftl_get_blk_mode
	strb	r0, [r6, #8]
.L2938:
	ldr	r3, .L2998+4
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2939
	ldr	r1, .L2998+8
	movw	r2, #893
	ldr	r0, .L2998+12
	bl	printf
	ldr	r1, .L2998+16
	ldr	r0, .L2998+20
	bl	printf
.L2939:
	ldr	r3, .L2998+24
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2940
	ldr	r1, .L2998+8
	movw	r2, #894
	ldr	r0, .L2998+12
	bl	printf
	ldr	r1, .L2998+16
	ldr	r0, .L2998+20
	bl	printf
.L2940:
	ldr	r3, .L2998+28
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2941
	ldr	r1, .L2998+8
	movw	r2, #895
	ldr	r0, .L2998+12
	bl	printf
	ldr	r1, .L2998+16
	ldr	r0, .L2998+20
	bl	printf
.L2941:
	mov	r0, r5
	bl	make_superblock
	ldr	r2, .L2998+32
	movs	r3, #0
	ldrh	r1, [r6]
	strh	r3, [r2]	@ movhi
	ldr	r2, [r8]
	ldrh	r1, [r2, r1, lsl #1]
	ldr	r2, .L2998+36
	strh	r3, [r6, #2]	@ movhi
	strb	r3, [r6, #6]
	strh	r1, [r2]	@ movhi
.L2929:
	ldr	r3, .L2998+40
	movs	r2, #1
	str	r2, [r3]
	ldr	r3, .L2998+44
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2998
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2942
	ldrb	r3, [r6, #8]	@ zero_extendqisi2
	cmp	r3, r2
	ittt	eq
	ldreq	r3, .L2998+48
	ldrheq	r3, [r3]
	streq	r3, [sp, #12]
.L2942:
	ldrh	r3, [r6, #2]
	ldr	r1, [sp, #12]
	ldr	fp, .L2998+84
	adds	r2, r3, r4
	cmp	r2, r1
	itt	gt
	movgt	r2, r1
	subgt	r4, r2, r3
	mov	r3, #0
	it	gt
	uxthgt	r4, r4
	str	r3, [sp, #20]
.L2944:
	ldrh	r3, [sp, #20]
	cmp	r4, r3
	bls	.L2952
	ldr	r3, .L2998+52
	movw	r8, #65535
	ldrh	lr, [r5, #2]
	mov	r10, #36
	ldr	r0, [fp]
	ldrh	r7, [r3]
	ldr	r3, [sp, #20]
	add	lr, lr, r3
	ldr	r3, .L2998+56
	str	r3, [sp, #16]
	movs	r3, #0
	str	r3, [sp, #8]
	b	.L2953
.L2946:
	ldr	r1, [sp, #16]
	ldrh	r2, [r1, #2]!
	cmp	r2, r8
	str	r1, [sp, #16]
	beq	.L2945
	ldr	r1, [sp, #8]
	orr	r2, lr, r2, lsl #10
	mla	ip, r10, r1, r0
	str	r2, [ip, #4]
	mov	r2, r1
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #8]
.L2945:
	adds	r3, r3, #1
.L2953:
	uxth	r2, r3
	cmp	r2, r7
	bcc	.L2946
	ldrb	r2, [r5, #8]	@ zero_extendqisi2
	ldr	r1, [sp, #8]
	bl	FlashReadPages
	movs	r3, #0
.L2993:
	str	r3, [sp, #16]
	ldr	r2, [sp, #8]
	ldrh	r3, [sp, #16]
	cmp	r2, r3
	bhi	.L2951
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	str	r3, [sp, #20]
	b	.L2944
.L2951:
	ldr	r3, [sp, #16]
	movs	r7, #36
	muls	r7, r3, r7
	ldr	r3, [fp]
	adds	r2, r3, r7
	ldr	r3, [r3, r7]
	adds	r3, r3, #1
	beq	.L2948
	ldr	r8, [r2, #12]
	movw	r3, #61589
	ldrh	r2, [r8]
	cmp	r2, r3
	bne	.L2948
	ldr	r10, [r8, #8]
	cmp	r10, #-1
	bne	.L2949
	ldr	r1, .L2998+8
	movw	r2, #934
	ldr	r0, .L2998+12
	bl	printf
	ldr	r1, .L2998+16
	ldr	r0, .L2998+20
	bl	printf
.L2949:
	movs	r2, #0
	add	r1, sp, #36
	mov	r0, r10
	bl	log2phys
	ldr	r0, [fp]
	ldr	r3, [sp, #36]
	add	r0, r0, r7
	ldr	r2, [r0, #4]
	bic	r3, r3, #-2147483648
	cmp	r3, r2
	bne	.L2948
	ldr	r2, .L2998+32
	ldr	r1, .L2998+60
	ldr	r10, .L2998+68
	ldrh	r3, [r2]
	str	r1, [sp, #28]
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldr	r2, [r1]
	movs	r1, #36
	ldr	r3, [r10]
	mla	r3, r1, r3, r2
	ldr	r2, [r0, #16]
	str	r2, [r3, #16]
	str	r3, [sp, #24]
	bl	Ftl_get_new_temp_ppa
	ldr	r3, [sp, #24]
	ldr	r1, [sp, #28]
	str	r0, [r3, #4]
	ldr	r2, [r1]
	movs	r1, #36
	ldr	r3, [r10]
	ldr	r0, [fp]
	mla	r2, r1, r3, r2
	add	r0, r0, r7
	ldr	r7, .L2998+28
	ldr	r1, [r0, #8]
	adds	r3, r3, #1
	str	r1, [r2, #8]
	ldr	r1, [r0, #12]
	str	r1, [r2, #12]
	movs	r1, #1
	ldr	r2, [sp, #36]
	str	r2, [r8, #12]
	ldrh	r2, [r7]
	strh	r2, [r8, #2]	@ movhi
	ldr	r2, .L2998+64
	str	r3, [r10]
	ldr	r2, [r2]
	str	r2, [r8, #4]
	bl	FtlGcBufAlloc
	ldr	r3, .L2998
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2950
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldr	r3, [r10]
	cmp	r2, r3
	beq	.L2950
	ldrh	r3, [r7, #4]
	cbnz	r3, .L2948
.L2950:
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L2948
.L2995:
	ldr	r3, .L2998+40
	movs	r2, #0
	str	r2, [r3]
	b	.L2994
.L2948:
	ldr	r3, [sp, #16]
	adds	r3, r3, #1
	b	.L2993
.L2952:
	ldrh	r3, [r5, #2]
	add	r4, r4, r3
	ldr	r3, [sp, #12]
	uxth	r4, r4
	cmp	r3, r4
	strh	r4, [r5, #2]	@ movhi
	bhi	.L2954
	ldr	r3, .L2998+68
	ldr	r3, [r3]
	cbz	r3, .L2955
	bl	Ftl_gc_temp_data_write_back
	cmp	r0, #0
	bne	.L2995
.L2955:
	ldr	r3, .L2998+32
	ldrh	r4, [r3]
	cbnz	r4, .L2956
	ldr	r7, .L2998+72
	ldrh	r1, [r5]
	ldr	r3, [r7]
	ldrh	r3, [r3, r1, lsl #1]
	cbz	r3, .L2956
	ldr	r0, .L2998+36
	ldrh	r2, [r5, #2]
	ldrh	r0, [r0]
	str	r3, [sp]
	mov	r3, r4
	str	r0, [sp, #4]
	ldr	r0, .L2998+76
	bl	printf
	ldrh	r2, [r5]
	ldr	r3, [r7]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5]
	bl	update_vpc_list
	bl	FtlCacheWriteBack
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2956:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L2954:
	ldr	r3, .L2998+80
	ldrh	r0, [r3]
	cmp	r0, #2
	bhi	.L2957
	ldr	r3, .L2998+44
	ldrh	r4, [r3]
	b	.L2928
.L2957:
	ldr	r3, .L2998+40
	movs	r2, #0
	adds	r0, r0, #1
	str	r2, [r3]
	b	.L2906
.L2999:
	.align	2
.L2998:
	.word	.LANCHOR15
	.word	.LANCHOR91
	.word	.LANCHOR243
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR241
	.word	.LANCHOR242
	.word	.LANCHOR171
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR38
	.word	.LANCHOR204+14
	.word	.LANCHOR181
	.word	.LANCHOR160
	.word	.LANCHOR102
	.word	.LANCHOR83
	.word	.LC66
	.word	.LANCHOR88
	.word	.LANCHOR106
.L2958:
	movs	r0, #0
	b	.L2906
.L2960:
	mov	r0, r3
	b	.L2906
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
	push	{r3, r4, r5, lr}
	mov	r3, #-1
	ldr	r4, .L3009
	mov	r5, r0
	ldr	r2, .L3009+4
	str	r3, [r4]
	movs	r3, #0
	ldr	r1, .L3009+8
	str	r3, [r2]
	ldr	r2, .L3009+12
	ldr	r0, .L3009+16
	str	r3, [r2]
	bl	printf
	mov	r0, r5
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	ldr	r3, .L3009+20
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L3001
	ldr	r1, .L3009+24
	ldr	r0, .L3009+28
.L3008:
	bl	printf
.L3002:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L3001:
	bl	FtlSysBlkInit
	cbz	r0, .L3003
	ldr	r1, .L3009+24
	ldr	r0, .L3009+32
	b	.L3008
.L3003:
	movs	r1, #1
	str	r1, [r4]
	bl	rk_ftl_garbage_collect
	ldr	r3, .L3009+36
	ldrh	r3, [r3]
	cmp	r3, #15
	bhi	.L3002
	mov	r4, #1024
.L3005:
	movs	r1, #1
	mov	r0, r1
	bl	rk_ftl_garbage_collect
	subs	r4, r4, #1
	bne	.L3005
	b	.L3002
.L3010:
	.align	2
.L3009:
	.word	.LANCHOR230
	.word	.LANCHOR244
	.word	.LC67
	.word	.LANCHOR76
	.word	.LC7
	.word	.LANCHOR39
	.word	.LANCHOR245
	.word	.LC68
	.word	.LC69
	.word	.LANCHOR88
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
	cbnz	r0, .L3012
	ldr	r0, .L3013
	bl	FtlInit
.L3012:
	bl	idb_init
	mov	r1, r4
	ldr	r0, .L3013+4
	bl	printf
	mov	r0, r4
	pop	{r4, pc}
.L3014:
	.align	2
.L3013:
	.word	.LANCHOR14
	.word	.LC70
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
	ldr	r3, .L3029
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L3015
	ldr	r7, .L3029+4
	ldr	r6, .L3029+8
	ldr	r10, .L3029+32
	ldrh	r5, [r7]
	ldr	r3, [r6]
	ldr	r4, .L3029+12
	mov	r1, r5
	ldr	r0, .L3029+16
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
.L3017:
	subs	r4, r4, #1
	beq	.L3021
	movs	r1, #1
	mov	r0, r1
	bl	rk_ftl_garbage_collect
	ldr	r3, [r6]
	ldrh	r3, [r3, r8]
	cmp	r3, #0
	bne	.L3017
.L3021:
	ldr	r3, [r6]
	mov	r1, r5
	ldr	r0, .L3029+16
	ldrh	r2, [r3, r5, lsl #1]
	bl	printf
	ldr	r3, [r6]
	ldrh	r4, [r3, r5, lsl #1]
	cbnz	r4, .L3019
	add	r0, sp, #56
	ldr	r7, .L3029+20
	strh	r5, [r0, #-48]!	@ movhi
	movw	r10, #65535
	bl	make_superblock
	ldr	r3, .L3029+24
	add	r0, sp, #22
	ldr	r8, [r7]
	mov	r2, r4
	mov	fp, #36
	mov	ip, r4
	ldrh	lr, [r3]
.L3022:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L3024
	ldr	r3, [r6]
	mov	r1, r5
	ldr	r0, .L3029+28
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
.L3019:
	ldr	r2, [sp, #4]
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L3015:
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3024:
	ldrh	r3, [r0, #2]!
	cmp	r3, r10
	beq	.L3023
	mla	r1, fp, r4, r8
	adds	r4, r4, #1
	lsls	r3, r3, #10
	uxth	r4, r4
	str	r3, [r1, #4]
	str	ip, [r1, #8]
	str	ip, [r1, #12]
.L3023:
	adds	r2, r2, #1
	b	.L3022
.L3030:
	.align	2
.L3029:
	.word	.LANCHOR15
	.word	.LANCHOR234
	.word	.LANCHOR83
	.word	.LANCHOR92
	.word	.LC71
	.word	.LANCHOR77
	.word	.LANCHOR38
	.word	.LC72
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
	bne	.L3032
	mov	r2, r3
	ldr	r1, [sp, #52]
	add	r0, r6, #256
	bl	FtlVendorPartRead
	str	r0, [sp, #32]
.L3031:
	ldr	r0, [sp, #32]
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3032:
	ldr	r3, [sp, #52]
	adds	r3, r1, r3
	str	r3, [sp, #36]
	ldr	r3, .L3070
	ldr	r2, [sp, #36]
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L3055
	ldr	r3, .L3070+4
	ldr	r3, [r3]
	adds	r4, r3, #1
	beq	.L3056
	bl	FtlCacheWriteBack
	ldr	r3, .L3070+8
	mov	r0, r6
	ldr	r10, .L3070+52
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	ldr	r3, [sp, #36]
	mov	r1, r4
	str	r0, [sp, #40]
	subs	r0, r3, #1
	bl	__aeabi_uidiv
	ldr	r3, [sp, #40]
	ldr	r2, .L3070+12
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
.L3034:
	ldr	r3, [sp, #28]
	cbnz	r3, .L3054
	ldr	r3, .L3070+16
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L3031
	movs	r1, #1
	ldr	r0, [sp, #28]
	bl	rk_ftl_garbage_collect
	b	.L3031
.L3054:
	movs	r2, #0
	add	r1, sp, #84
	mov	r0, r4
	bl	log2phys
	ldr	r3, [sp, #84]
	adds	r0, r3, #1
	bne	.L3035
	ldr	fp, .L3070+8
	mov	r8, #0
.L3036:
	ldrh	r0, [fp]
	cmp	r8, r0
	bcc	.L3038
.L3039:
	ldr	r3, [sp, #28]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #28]
	beq	.L3043
	ldr	r3, .L3070+20
	ldrh	r3, [r3]
	cmp	r5, r3, lsl #2
	bne	.L3034
.L3043:
	cmp	r5, #0
	beq	.L3034
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
.L3053:
	mov	r8, #36
	ldr	r3, [r10]
	mul	r8, r8, fp
	ldr	r1, [sp, #40]
	add	r3, r3, r8
	ldr	r2, [r3, #16]
	cmp	r1, r2
	bne	.L3045
	ldr	r1, [r3, #8]
	ldr	r3, .L3070+24
	ldr	r3, [r3]
	cmp	r1, r3
	bne	.L3046
	ldr	r3, [sp, #60]
	mov	r0, r7
	ldr	r2, [sp, #64]
	add	r1, r1, r3
.L3069:
	bl	ftl_memcpy
.L3046:
	ldr	r2, [r10]
	add	r2, r2, r8
	ldr	r3, [r2, #12]
	ldr	lr, [r2, #16]
	ldr	r0, [r3, #8]
	cmp	lr, r0
	beq	.L3047
	ldr	ip, .L3070+32
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
	ldr	r0, .L3070+28
	ldr	r3, [r3]
	ldr	r2, [r2, #4]
	bl	printf
.L3047:
	ldr	r3, [r10]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	adds	r1, r3, #1
	bne	.L3048
	ldr	r1, .L3070+32
	str	r3, [sp, #32]
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L3049:
	add	fp, fp, #1
	cmp	r5, fp
	bne	.L3053
	movs	r5, #0
	b	.L3034
.L3038:
	mla	r0, r0, r4, r8
	cmp	r6, r0
	bhi	.L3037
	ldr	r3, [sp, #36]
	cmp	r3, r0
	bls	.L3037
	subs	r0, r0, r6
	mov	r2, #512
	movs	r1, #0
	add	r0, r7, r0, lsl #9
	bl	ftl_memset
.L3037:
	add	r8, r8, #1
	b	.L3036
.L3035:
	ldr	r2, [r10]
	mov	r8, #36
	mla	r8, r8, r5, r2
	str	r3, [r8, #4]
	ldr	r3, [sp, #40]
	cmp	r4, r3
	ldr	r3, .L3070+8
	bne	.L3040
	ldr	r2, .L3070+24
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
	bne	.L3041
	str	r7, [r8, #8]
.L3041:
	ldr	r3, .L3070+36
	ldr	r2, .L3070+40
	str	r4, [r8, #16]
	ldrh	r3, [r3]
	ldr	r2, [r2]
	muls	r3, r5, r3
	adds	r5, r5, #1
	bic	r3, r3, #3
	add	r3, r3, r2
	str	r3, [r8, #12]
	b	.L3039
.L3040:
	ldr	r2, [sp, #44]
	cmp	r4, r2
	bne	.L3042
	ldr	r2, .L3070+44
	ldr	r1, [sp, #36]
	ldr	r2, [r2]
	str	r2, [r8, #8]
	ldrh	r2, [r3]
	mul	r3, r2, r4
	subs	r1, r1, r3
	cmp	r2, r1
	str	r1, [sp, #24]
	bne	.L3041
.L3068:
	subs	r3, r3, r6
	add	r3, r7, r3, lsl #9
	str	r3, [r8, #8]
	b	.L3041
.L3042:
	ldrh	r3, [r3]
	muls	r3, r4, r3
	b	.L3068
.L3045:
	ldr	r1, [sp, #44]
	cmp	r1, r2
	bne	.L3046
	ldr	r1, [r3, #8]
	ldr	r3, .L3070+44
	ldr	r3, [r3]
	cmp	r1, r3
	bne	.L3046
	ldr	r3, .L3070+8
	ldr	r2, [sp, #68]
	ldrh	r0, [r3]
	ldr	r3, [sp, #44]
	muls	r0, r3, r0
	subs	r0, r0, r6
	add	r0, r7, r0, lsl #9
	b	.L3069
.L3048:
	cmp	r3, #256
	bne	.L3049
	ldr	r0, [r2, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	mov	r8, r0
	bl	FtlGcRefreshBlock
	ldr	r2, .L3070+48
	movw	r3, #2049
.L3051:
	subs	r3, r3, #1
	bne	.L3050
.L3052:
	bl	FtlSysFlush
	b	.L3049
.L3050:
	movs	r1, #1
	str	r2, [sp, #76]
	mov	r0, r1
	str	r3, [sp, #72]
	bl	rk_ftl_garbage_collect
	ldr	r2, [sp, #76]
	ldr	r3, [sp, #72]
	ldrh	r1, [r2]
	cmp	r1, r8
	beq	.L3051
	b	.L3052
.L3055:
	mov	r3, #-1
.L3056:
	str	r3, [sp, #32]
	b	.L3031
.L3071:
	.align	2
.L3070:
	.word	.LANCHOR68
	.word	.LANCHOR230
	.word	.LANCHOR55
	.word	.LANCHOR166
	.word	.LANCHOR116
	.word	.LANCHOR38
	.word	.LANCHOR186
	.word	.LC59
	.word	.LANCHOR138
	.word	.LANCHOR58
	.word	.LANCHOR189
	.word	.LANCHOR187
	.word	.LANCHOR204
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
	ldr	r3, .L3120
	sub	sp, sp, #80
	mov	r6, r1
	str	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L3105
	cmp	r0, #16
	bne	.L3074
	mov	r2, r10
	ldr	r1, [sp, #12]
	add	r0, r6, #256
	bl	FtlVendorPartWrite
.L3072:
	add	sp, sp, #80
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3074:
	ldr	r3, [sp, #12]
	adds	r5, r1, r3
	ldr	r3, .L3120+4
	ldr	r3, [r3]
	cmp	r5, r3
	bhi	.L3106
	ldr	r3, .L3120+8
	ldr	r0, [r3]
	adds	r4, r0, #1
	beq	.L3072
	ldr	r3, .L3120+12
	mov	r2, #2048
	mov	r0, r6
	str	r2, [r3]
	ldr	r3, .L3120+16
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	mov	r1, r4
	mov	r8, r0
	subs	r0, r5, #1
	bl	__aeabi_uidiv
	ldr	r2, .L3120+20
	sub	r5, r0, r8
	adds	r3, r5, #1
	adds	r1, r5, #1
	str	r3, [sp, #4]
	ldr	r3, [r2]
	str	r0, [sp, #16]
	add	r3, r3, r1
	str	r3, [r2]
	ldr	r3, .L3120+24
	ldr	fp, [r3]
	cmp	fp, #0
	beq	.L3076
	ldr	r3, [fp, #16]
	cmp	r8, r3
	beq	.L3077
	bl	FtlCacheWriteBack
.L3076:
	ldr	r7, .L3120+28
	mov	r4, r8
.L3078:
	ldr	r3, [sp, #4]
	cbnz	r3, .L3104
	ldr	r3, [sp, #16]
	ldr	r0, [sp, #4]
	sub	r1, r3, r8
	bl	rk_ftl_garbage_collect
.L3105:
	movs	r0, #0
	b	.L3072
.L3077:
	ldr	r2, .L3120+32
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
	beq	.L3105
	ldr	r3, [sp, #12]
	add	r6, r6, r4
	add	r10, r10, r7
	add	r8, r8, #1
	subs	r3, r3, r4
	str	r3, [sp, #12]
	bl	FtlCacheWriteBack
	str	r5, [sp, #4]
	b	.L3076
.L3104:
	ldr	r5, .L3120+36
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r5]
	cmp	r2, r3
	bcc	.L3079
	ldr	r1, .L3120+40
	movw	r2, #1668
	ldr	r0, .L3120+44
	bl	printf
	ldr	r1, .L3120+48
	ldr	r0, .L3120+52
	bl	printf
.L3079:
	ldrh	r3, [r7, #4]
	cbnz	r3, .L3080
	bl	FtlCacheWriteBack
	mov	r0, r7
	bl	allocate_new_data_superblock
.L3080:
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
	bcc	.L3081
	ldr	r1, .L3120+40
	movw	r2, #1701
	ldr	r0, .L3120+44
	bl	printf
	ldr	r1, .L3120+48
	ldr	r0, .L3120+52
	bl	printf
.L3081:
	movs	r3, #0
.L3119:
	str	r3, [sp, #8]
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #36]
	cmp	r3, r2
	bne	.L3102
.L3083:
	ldr	r0, .L3120+56
	mov	r3, r7
	movs	r2, #0
	ldr	r1, [sp, #8]
	ldr	r0, [r0]
	bl	FtlProgPages
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #8]
	cmp	r3, r2
	bcs	.L3103
	ldr	r1, .L3120+40
	movw	r2, #1790
	ldr	r0, .L3120+44
	bl	printf
	ldr	r1, .L3120+48
	ldr	r0, .L3120+52
	bl	printf
.L3103:
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #8]
	subs	r3, r3, r2
	str	r3, [sp, #4]
	b	.L3078
.L3102:
	ldrh	r3, [r7, #4]
	cmp	r3, #0
	beq	.L3083
	movs	r2, #0
	add	r1, sp, #40
	mov	r0, r4
	movs	r5, #36
	bl	log2phys
	mov	r0, r7
	bl	get_new_active_ppa
	ldr	r3, [sp, #8]
	ldr	r2, .L3120+60
	muls	r5, r3, r5
	ldr	r3, .L3120+56
	ldrh	r2, [r2]
	ldr	r1, [r3]
	str	r3, [sp, #20]
	ldr	r3, [sp, #8]
	add	r1, r1, r5
	str	r0, [r1, #4]
	str	r4, [r1, #16]
	mul	r0, r2, r3
	bic	r3, r0, #3
	ldr	r0, .L3120+64
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
	ldr	r1, .L3120+16
	beq	.L3084
	ldr	r3, [sp, #16]
	cmp	r3, r4
	ldr	r3, [sp, #20]
	bne	.L3115
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
	b	.L3087
.L3084:
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
.L3087:
	ldr	r3, .L3120+16
	ldr	r2, [sp, #20]
	ldrh	r3, [r3]
	cmp	r3, r2
	ldr	r3, .L3120+56
	ldr	r3, [r3]
	bne	.L3088
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
.L3090:
	ldr	r3, .L3120+36
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L3099
	ldr	r1, .L3120+40
	movw	r2, #1775
	ldr	r0, .L3120+44
	bl	printf
	ldr	r1, .L3120+48
	ldr	r0, .L3120+52
	bl	printf
.L3099:
	ldr	r2, [sp, #32]
	movw	r3, #61589
	ldr	r1, [sp, #28]
	strh	r3, [r2, r1]	@ movhi
	ldr	r2, .L3120+68
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
	b	.L3119
.L3121:
	.align	2
.L3120:
	.word	.LANCHOR76
	.word	.LANCHOR68
	.word	.LANCHOR230
	.word	.LANCHOR246
	.word	.LANCHOR55
	.word	.LANCHOR162
	.word	.LANCHOR132
	.word	.LANCHOR91
	.word	.LANCHOR164
	.word	.LANCHOR38
	.word	.LANCHOR247
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR182
	.word	.LANCHOR58
	.word	.LANCHOR189
	.word	.LANCHOR160
.L3088:
	cmp	r4, r8
	add	r3, r3, r5
	ite	eq
	ldreq	r2, .L3122
	ldrne	r2, .L3122+4
	ldr	r2, [r2]
	str	r2, [r3, #8]
	ldr	r2, [sp, #40]
	ldr	r3, .L3122+8
	adds	r0, r2, #1
	beq	.L3093
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
	bne	.L3094
	ldr	r2, .L3122+12
	ldr	r3, [r2, #72]
	adds	r3, r3, #1
	str	r3, [r2, #72]
.L3097:
	ldr	r2, [sp, #20]
	cmp	r4, r8
	ldr	r3, .L3122+8
	lsl	r2, r2, #9
	bne	.L3098
	ldr	r3, [r3]
	mov	r1, r10
	add	r5, r5, r3
	ldr	r3, [sp, #24]
	ldr	r0, [r5, #8]
	add	r0, r0, r3, lsl #9
.L3117:
	bl	ftl_memcpy
	b	.L3090
.L3094:
	ldr	r1, [fp, #8]
	cmp	r4, r1
	beq	.L3096
	ldr	r2, .L3122+12
	ldr	r0, .L3122+16
	ldr	r3, [r2, #72]
	adds	r3, r3, #1
	str	r3, [r2, #72]
	mov	r2, r4
	bl	printf
.L3096:
	ldr	r3, [fp, #8]
	cmp	r4, r3
	beq	.L3097
	movw	r2, #1754
	ldr	r1, .L3122+20
	ldr	r0, .L3122+24
	bl	printf
	ldr	r1, .L3122+28
	ldr	r0, .L3122+32
	bl	printf
	b	.L3097
.L3093:
	ldr	r3, [r3]
	movs	r1, #0
	ldr	r2, .L3122+36
	add	r3, r3, r5
	ldrh	r2, [r2]
	ldr	r0, [r3, #8]
	bl	ftl_memset
	b	.L3097
.L3098:
	ldr	r1, .L3122+40
	ldr	r3, [r3]
	ldrh	r1, [r1]
	add	r5, r5, r3
	ldr	r0, [r5, #8]
	muls	r1, r4, r1
	subs	r1, r1, r6
	add	r1, r10, r1, lsl #9
	b	.L3117
.L3115:
	ldr	r3, [r3]
	add	r5, r5, r3
	ldrh	r3, [r1]
	muls	r3, r4, r3
	subs	r3, r3, r6
	add	r3, r10, r3, lsl #9
	str	r3, [r5, #8]
	b	.L3090
.L3106:
	mov	r0, #-1
	b	.L3072
.L3123:
	.align	2
.L3122:
	.word	.LANCHOR186
	.word	.LANCHOR187
	.word	.LANCHOR182
	.word	.LANCHOR138
	.word	.LC73
	.word	.LANCHOR247
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
	cbnz	r0, .L3129
	mov	r3, r2
	mov	r2, r5
	bl	idb_write_data
.L3129:
	mov	r3, r5
	mov	r2, r4
	mov	r1, r7
	mov	r0, r6
	pop	{r4, r5, r6, r7, r8, lr}
	b	FtlWrite
	.size	ftl_write, .-ftl_write
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
	ldr	r6, .L3154
	ldr	r5, .L3154+4
	ldr	r1, .L3154+8
	ldr	r0, .L3154+12
	bl	printf
	mov	r2, #8192
	movs	r1, #0
	ldr	r0, .L3154+4
	bl	memset
.L3131:
	ldr	r3, [r6]
	cmp	r4, r3
	bcc	.L3133
	ldr	r7, .L3154+16
	movs	r4, #0
	ldr	r5, .L3154+20
	movs	r2, #2
	ldr	r10, .L3154+4
	mov	r6, r4
	ldr	fp, .L3154+60
	mov	r8, r7
	ldrh	r3, [r7]
	ldr	r1, [r5]
	ldr	r0, .L3154+24
	bl	rknand_print_hex
	ldrh	r3, [r7]
	movs	r2, #2
	ldr	r1, .L3154+4
	ldr	r0, .L3154+28
	bl	rknand_print_hex
.L3134:
	ldrh	r2, [r8]
	uxth	r3, r4
	cmp	r2, r3
	bhi	.L3136
	ldr	r3, .L3154+32
	ldr	r4, [r3]
	cbz	r4, .L3137
	ldr	r3, .L3154+36
	mov	r8, #0
	ldr	r7, .L3154+40
	ldr	fp, .L3154+64
	ldrh	r10, [r3]
	ldr	r3, [r7]
	subs	r4, r4, r3
	ldr	r3, .L3154+44
	asrs	r4, r4, #1
	muls	r4, r3, r4
	uxth	r4, r4
.L3138:
	uxth	r3, r8
	cmp	r10, r3
	bls	.L3137
	ldr	r3, [r5]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L3139
	ldr	r3, .L3154+4
	movs	r6, #1
	mov	r1, r4
	mov	r0, fp
	ldrh	r3, [r3, r4, lsl #1]
	bl	printf
.L3139:
	movs	r3, #6
	ldr	r2, [r7]
	muls	r4, r3, r4
	movw	r3, #65535
	add	r8, r8, #1
	ldrh	r4, [r2, r4]
	cmp	r4, r3
	bne	.L3138
.L3137:
	cbz	r6, .L3130
	ldr	r1, .L3154+8
	movw	r2, #1686
	ldr	r0, .L3154+48
	bl	printf
	ldr	r1, .L3154+52
	ldr	r0, .L3154+56
	bl	printf
.L3130:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3133:
	movs	r2, #0
	add	r1, sp, #4
	mov	r0, r4
	bl	log2phys
	ldr	r0, [sp, #4]
	adds	r3, r0, #1
	beq	.L3132
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r5, r0, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r5, r0, lsl #1]	@ movhi
.L3132:
	adds	r4, r4, #1
	b	.L3131
.L3136:
	ldr	r3, [r5]
	uxth	r7, r4
	ldrh	r2, [r3, r7, lsl #1]
	ldrh	r3, [r10, r7, lsl #1]
	cmp	r2, r3
	beq	.L3135
	mov	r1, r7
	mov	r0, fp
	bl	printf
	ldr	r3, [r5]
	movw	r2, #65535
	ldrh	r3, [r3, r7, lsl #1]
	cmp	r3, r2
	beq	.L3135
	ldrh	r2, [r10, r7, lsl #1]
	cmp	r2, r3
	it	hi
	movhi	r6, #1
.L3135:
	adds	r4, r4, #1
	b	.L3134
.L3155:
	.align	2
.L3154:
	.word	.LANCHOR72
	.word	check_valid_page_count_table
	.word	.LANCHOR248
	.word	.LC45
	.word	.LANCHOR40
	.word	.LANCHOR83
	.word	.LC74
	.word	.LC75
	.word	.LANCHOR87
	.word	.LANCHOR88
	.word	.LANCHOR81
	.word	-1431655765
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC76
	.word	.LC77
	.size	FtlCheckVpc, .-FtlCheckVpc
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
	ldr	r5, .L3163
	sub	sp, sp, #24
	mov	r7, r0
	movs	r6, #0
	ldr	r4, .L3163+4
	ldr	r3, [r5]
	ldr	r8, .L3163+20
	mov	fp, r4
	str	r3, [r4, #8]
	ldr	r3, .L3163+8
	ldr	r3, [r3]
	str	r3, [r4, #12]
.L3157:
	ldrh	r2, [r8]
	sxth	r3, r6
	cmp	r3, r2
	blt	.L3159
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3159:
	movs	r2, #1
	orr	r3, r3, r10
	mov	r1, r2
	mov	r0, fp
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r2, [r4, #8]
	mov	r1, r7
	ldr	r3, [r4, #12]
	ldr	r0, .L3163+12
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
	beq	.L3158
	mov	r3, #768
	movs	r2, #4
	ldr	r1, [r5]
	ldr	r0, .L3163+16
	bl	rknand_print_hex
.L3158:
	adds	r6, r6, #1
	b	.L3157
.L3164:
	.align	2
.L3163:
	.word	.LANCHOR183
	.word	.LANCHOR202
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
	ldr	r3, .L3179
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	ldr	r8, .L3179+72
	ldrh	r5, [r3]
.L3166:
	ldr	r3, .L3179+4
	ldrh	r3, [r3]
	cmp	r3, r5
	bhi	.L3173
	ldr	r4, .L3179+8
	movs	r7, #0
.L3174:
	ldr	r3, .L3179+12
	sxth	r5, r7
	ldrh	r3, [r3]
	cmp	r5, r3
	bge	.L3177
	lsls	r5, r5, #1
	movs	r6, #0
	ldr	r8, .L3179+76
	b	.L3178
.L3168:
	str	r3, [sp, #36]
	mov	r1, r5
	ldr	r3, .L3179+16
	str	r2, [sp, #32]
	ldrb	r0, [r3, r6]	@ zero_extendqisi2
	bl	V2P_block
	str	r0, [sp, #28]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #32]
	ldr	r3, [sp, #36]
	cbnz	r0, .L3167
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
.L3167:
	adds	r6, r6, #1
.L3175:
	uxth	r1, r6
	cmp	r2, r1
	bhi	.L3168
	cbnz	r4, .L3169
.L3172:
	adds	r5, r5, #1
	uxth	r5, r5
	b	.L3166
.L3169:
	ldr	r10, .L3179+80
	mov	r0, r7
	movs	r6, #0
	movs	r7, #36
	movs	r2, #1
	mov	r1, r4
	bl	FlashReadPages
.L3170:
	uxth	r3, r6
	cmp	r4, r3
	bls	.L3172
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
	b	.L3170
.L3173:
	ldr	r1, .L3179+20
	movs	r6, #0
	ldr	r3, .L3179+24
	mov	r4, r6
	ldr	r7, [r8]
	mov	fp, #36
	ldr	r1, [r1]
	ldrh	r2, [r3]
	ldr	r3, .L3179+28
	str	r1, [sp, #24]
	ldr	r1, .L3179+32
	ldr	r3, [r3]
	ldrh	r10, [r1]
	b	.L3175
.L3176:
	ldr	r10, .L3179+44
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
	ldr	r0, .L3179+36
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
.L3178:
	ldrh	r2, [r8]
	sxth	r3, r6
	adds	r6, r6, #1
	cmp	r3, r2
	blt	.L3176
	adds	r7, r7, #1
	b	.L3174
.L3177:
	ldr	r3, .L3179+40
	movs	r2, #2
	ldr	r1, .L3179+44
	ldr	r0, .L3179+48
	ldr	r3, [r3]
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r4, .L3179+52
	movs	r2, #4
	ldr	r1, .L3179+56
	ldr	r0, .L3179+60
	ldrh	r3, [r4]
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r1, .L3179+64
	movs	r2, #4
	ldrh	r3, [r4]
	ldr	r0, .L3179+68
	ldr	r1, [r1]
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	rknand_print_hex
.L3180:
	.align	2
.L3179:
	.word	.LANCHOR40
	.word	.LANCHOR41
	.word	.LANCHOR202
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
	.set	.LANCHOR223,. + 0
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
	.set	.LANCHOR3,. + 0
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
	.set	.LANCHOR201,. + 0
	.type	gMultiPageReadEn, %object
	.size	gMultiPageReadEn, 1
gMultiPageReadEn:
	.space	1
	.section	.bss.gNandChipMap,"aw",%nobits
	.align	2
	.set	.LANCHOR6,. + 0
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
	.set	.LANCHOR2,. + 0
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
	.set	.LANCHOR5,. + 0
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
	.set	.LANCHOR209,. + 0
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
	.set	.LANCHOR215,. + 0
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
	.set	.LANCHOR244,. + 0
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
	.set	.LANCHOR222,. + 0
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
	.set	.LANCHOR218,. + 0
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
	.set	.LANCHOR246,. + 0
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
	.set	.LANCHOR242,. + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.space	2
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",%nobits
	.align	1
	.set	.LANCHOR241,. + 0
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
	.set	.LANCHOR204,. + 0
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
	.set	.LANCHOR234,. + 0
	.type	g_power_lost_ecc_error_blk, %object
	.size	g_power_lost_ecc_error_blk, 2
g_power_lost_ecc_error_blk:
	.space	2
	.section	.bss.g_power_lost_recovery_flag,"aw",%nobits
	.align	1
	.set	.LANCHOR235,. + 0
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
	.set	.LANCHOR236,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.space	4
	.section	.bss.g_recovery_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR237,. + 0
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
	.set	.LANCHOR1,. + 0
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
	.set	.LANCHOR205,. + 0
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
	.set	.LANCHOR217,. + 0
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
	.set	.LANCHOR216,. + 0
	.type	g_totle_write_sector, %object
	.size	g_totle_write_sector, 4
g_totle_write_sector:
	.space	4
	.section	.bss.gc_discard_updated,"aw",%nobits
	.align	2
	.set	.LANCHOR231,. + 0
	.type	gc_discard_updated, %object
	.size	gc_discard_updated, 4
gc_discard_updated:
	.space	4
	.section	.bss.gc_ink_free_return_value,"aw",%nobits
	.align	1
	.set	.LANCHOR240,. + 0
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
	.set	.LANCHOR229,. + 0
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
	.set	.LANCHOR0,. + 0
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
	.set	.LANCHOR202,. + 0
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
	.set	.LANCHOR238,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.short	-1
	.section	.data.gFtlInitStatus,"aw",%progbits
	.align	2
	.set	.LANCHOR230,. + 0
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
	.set	.LANCHOR4,. + 0
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
.LC52:
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
.LC74:
	.ascii	"vpc1\000"
.LC75:
	.ascii	"vpc2\000"
.LC76:
	.ascii	"FtlCheckVpc2 %x = %x  %x\012\000"
.LC77:
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
.LC65:
	.ascii	"GC des block %x done\012\000"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",%progbits,1
.LC63:
	.ascii	"FtlGcScanTempBlk Error ID %x %x!!!!!!! \012\000"
.LC64:
	.ascii	"FtlGcScanTempBlkError ID %x %x!!!!!!!\012\000"
	.section	.rodata.FtlInit.str1.1,"aMS",%progbits,1
.LC67:
	.ascii	"FTL version: 5.0.53 20190107\000"
.LC68:
	.ascii	"...%s: no bad block mapping table, format device\012"
	.ascii	"\000"
.LC69:
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
.LC56:
	.ascii	"Ftlwrite decrement_vpc_count %x = %d\012\000"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",%progbits,1
.LC60:
	.ascii	"RSB refresh addr %x\012\000"
.LC61:
	.ascii	"spuer block %x vpn is 0\012 \000"
.LC62:
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
.LC73:
	.ascii	"FtlWrite: lpa error:%x %x\012\000"
	.section	.rodata.Ftl_load_ext_data.str1.1,"aMS",%progbits,1
.LC44:
	.ascii	"slc mode\000"
	.section	.rodata.Ftlscanalldata.str1.1,"aMS",%progbits,1
.LC57:
	.ascii	"Ftlscanalldata = %x\012\000"
.LC58:
	.ascii	"scan lpa = %x ppa= %x\012\000"
.LC59:
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
	.section	.rodata.__func__.10518,"a",%progbits
	.set	.LANCHOR245,. + 0
	.type	__func__.10518, %object
	.size	__func__.10518, 8
__func__.10518:
	.ascii	"FtlInit\000"
	.section	.rodata.__func__.10578,"a",%progbits
	.set	.LANCHOR228,. + 0
	.type	__func__.10578, %object
	.size	__func__.10578, 13
__func__.10578:
	.ascii	"FtlProgPages\000"
	.section	.rodata.__func__.10604,"a",%progbits
	.set	.LANCHOR247,. + 0
	.type	__func__.10604, %object
	.size	__func__.10604, 9
__func__.10604:
	.ascii	"FtlWrite\000"
	.section	.rodata.__func__.10687,"a",%progbits
	.set	.LANCHOR124,. + 0
	.type	__func__.10687, %object
	.size	__func__.10687, 14
__func__.10687:
	.ascii	"FtlBbt2Bitmap\000"
	.section	.rodata.__func__.10733,"a",%progbits
	.set	.LANCHOR211,. + 0
	.type	__func__.10733, %object
	.size	__func__.10733, 11
__func__.10733:
	.ascii	"FtlLoadBbt\000"
	.section	.rodata.__func__.10826,"a",%progbits
	.set	.LANCHOR89,. + 0
	.type	__func__.10826, %object
	.size	__func__.10826, 17
__func__.10826:
	.ascii	"INSERT_FREE_LIST\000"
	.section	.rodata.__func__.10830,"a",%progbits
	.set	.LANCHOR86,. + 0
	.type	__func__.10830, %object
	.size	__func__.10830, 17
__func__.10830:
	.ascii	"INSERT_DATA_LIST\000"
	.section	.rodata.__func__.10867,"a",%progbits
	.set	.LANCHOR90,. + 0
	.type	__func__.10867, %object
	.size	__func__.10867, 17
__func__.10867:
	.ascii	"List_remove_node\000"
	.section	.rodata.__func__.10897,"a",%progbits
	.set	.LANCHOR94,. + 0
	.type	__func__.10897, %object
	.size	__func__.10897, 22
__func__.10897:
	.ascii	"List_update_data_list\000"
	.section	.rodata.__func__.10904,"a",%progbits
	.set	.LANCHOR227,. + 0
	.type	__func__.10904, %object
	.size	__func__.10904, 20
__func__.10904:
	.ascii	"ftl_load_l2p_region\000"
	.section	.rodata.__func__.10935,"a",%progbits
	.set	.LANCHOR95,. + 0
	.type	__func__.10935, %object
	.size	__func__.10935, 26
__func__.10935:
	.ascii	"ftl_map_blk_alloc_new_blk\000"
	.section	.rodata.__func__.10945,"a",%progbits
	.set	.LANCHOR212,. + 0
	.type	__func__.10945, %object
	.size	__func__.10945, 15
__func__.10945:
	.ascii	"ftl_map_blk_gc\000"
	.section	.rodata.__func__.10958,"a",%progbits
	.set	.LANCHOR213,. + 0
	.type	__func__.10958, %object
	.size	__func__.10958, 31
__func__.10958:
	.ascii	"Ftl_write_map_blk_to_last_page\000"
	.section	.rodata.__func__.10971,"a",%progbits
	.set	.LANCHOR214,. + 0
	.type	__func__.10971, %object
	.size	__func__.10971, 16
__func__.10971:
	.ascii	"FtlMapWritePage\000"
	.section	.rodata.__func__.10991,"a",%progbits
	.set	.LANCHOR98,. + 0
	.type	__func__.10991, %object
	.size	__func__.10991, 22
__func__.10991:
	.ascii	"select_l2p_ram_region\000"
	.section	.rodata.__func__.11007,"a",%progbits
	.set	.LANCHOR226,. + 0
	.type	__func__.11007, %object
	.size	__func__.11007, 9
__func__.11007:
	.ascii	"log2phys\000"
	.section	.rodata.__func__.11069,"a",%progbits
	.set	.LANCHOR210,. + 0
	.type	__func__.11069, %object
	.size	__func__.11069, 15
__func__.11069:
	.ascii	"FtlVpcTblFlush\000"
	.section	.rodata.__func__.11088,"a",%progbits
	.set	.LANCHOR220,. + 0
	.type	__func__.11088, %object
	.size	__func__.11088, 14
__func__.11088:
	.ascii	"FtlScanSysBlk\000"
	.section	.rodata.__func__.11143,"a",%progbits
	.set	.LANCHOR221,. + 0
	.type	__func__.11143, %object
	.size	__func__.11143, 15
__func__.11143:
	.ascii	"FtlLoadSysInfo\000"
	.section	.rodata.__func__.11154,"a",%progbits
	.set	.LANCHOR248,. + 0
	.type	__func__.11154, %object
	.size	__func__.11154, 12
__func__.11154:
	.ascii	"FtlCheckVpc\000"
	.section	.rodata.__func__.11186,"a",%progbits
	.set	.LANCHOR224,. + 0
	.type	__func__.11186, %object
	.size	__func__.11186, 17
__func__.11186:
	.ascii	"FtlDumpBlockInfo\000"
	.section	.rodata.__func__.11205,"a",%progbits
	.set	.LANCHOR225,. + 0
	.type	__func__.11205, %object
	.size	__func__.11205, 16
__func__.11205:
	.ascii	"FtlScanAllBlock\000"
	.section	.rodata.__func__.11310,"a",%progbits
	.set	.LANCHOR232,. + 0
	.type	__func__.11310, %object
	.size	__func__.11310, 16
__func__.11310:
	.ascii	"FtlReUsePrevPpa\000"
	.section	.rodata.__func__.11343,"a",%progbits
	.set	.LANCHOR233,. + 0
	.type	__func__.11343, %object
	.size	__func__.11343, 22
__func__.11343:
	.ascii	"FtlRecoverySuperblock\000"
	.section	.rodata.__func__.11397,"a",%progbits
	.set	.LANCHOR101,. + 0
	.type	__func__.11397, %object
	.size	__func__.11397, 16
__func__.11397:
	.ascii	"make_superblock\000"
	.section	.rodata.__func__.11417,"a",%progbits
	.set	.LANCHOR140,. + 0
	.type	__func__.11417, %object
	.size	__func__.11417, 18
__func__.11417:
	.ascii	"SupperBlkListInit\000"
	.section	.rodata.__func__.11494,"a",%progbits
	.set	.LANCHOR203,. + 0
	.type	__func__.11494, %object
	.size	__func__.11494, 25
__func__.11494:
	.ascii	"allocate_data_superblock\000"
	.section	.rodata.__func__.11508,"a",%progbits
	.set	.LANCHOR219,. + 0
	.type	__func__.11508, %object
	.size	__func__.11508, 29
__func__.11508:
	.ascii	"allocate_new_data_superblock\000"
	.section	.rodata.__func__.11514,"a",%progbits
	.set	.LANCHOR208,. + 0
	.type	__func__.11514, %object
	.size	__func__.11514, 19
__func__.11514:
	.ascii	"get_new_active_ppa\000"
	.section	.rodata.__func__.11525,"a",%progbits
	.set	.LANCHOR206,. + 0
	.type	__func__.11525, %object
	.size	__func__.11525, 16
__func__.11525:
	.ascii	"update_vpc_list\000"
	.section	.rodata.__func__.11530,"a",%progbits
	.set	.LANCHOR207,. + 0
	.type	__func__.11530, %object
	.size	__func__.11530, 20
__func__.11530:
	.ascii	"decrement_vpc_count\000"
	.section	.rodata.__func__.11598,"a",%progbits
	.set	.LANCHOR239,. + 0
	.type	__func__.11598, %object
	.size	__func__.11598, 19
__func__.11598:
	.ascii	"FtlGcFreeTempBlock\000"
	.section	.rodata.__func__.11697,"a",%progbits
	.set	.LANCHOR243,. + 0
	.type	__func__.11697, %object
	.size	__func__.11697, 23
__func__.11697:
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
.LC71:
	.ascii	"fix power lost blk = %x vpc=%x\012\000"
.LC72:
	.ascii	"erase power lost blk = %x vpc=%x\012\000"
	.section	.rodata.ftl_map_blk_alloc_new_blk.str1.1,"aMS",%progbits,1
.LC8:
	.ascii	"FtlFreeSysBlkQueueOut = %x, free count = %d\012\000"
	.section	.rodata.ftl_map_blk_gc.str1.1,"aMS",%progbits,1
.LC39:
	.ascii	"page map lost: %x %x\012\000"
	.section	.rodata.idb_write_data.str1.1,"aMS",%progbits,1
.LC15:
	.ascii	"1 write_idblock fix data %x %x %x\012\000"
.LC16:
	.ascii	"write_idblock fail! %x %x %x %x\012\000"
.LC17:
	.ascii	"write_idblock fail! %x\012\000"
	.section	.rodata.log2phys.str1.1,"aMS",%progbits,1
.LC53:
	.ascii	"region_id = %x phyAddr = %x\012\000"
.LC54:
	.ascii	"map_ppn:\000"
.LC55:
	.ascii	"load_l2p_region refresh = %x phyAddr = %x\012\000"
	.section	.rodata.rk_ftl_garbage_collect.str1.1,"aMS",%progbits,1
.LC66:
	.ascii	"g_gc_superblock_free %x %x %x %x %x\012\000"
	.section	.rodata.rk_ftl_init.str1.1,"aMS",%progbits,1
.LC70:
	.ascii	"FtlInit %x\012\000"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",%progbits,1
.LC18:
	.ascii	"%s 0x%x:\000"
.LC19:
	.ascii	"%x \000"
.LC20:
	.ascii	"\000"
	.hidden	free
