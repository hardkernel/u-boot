/*
 * Copyright (c) 2016-2018, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2018-09-5
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
	ldr	r4, .L40
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
.L41:
	.align	2
.L40:
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
	ldr	r2, .L46
	push	{r4, r5, r6}
	uxtb	r6, r1
	ldr	r4, .L46+4
	lsrs	r5, r1, #8
	ldr	r3, [r2, r0, lsl #3]
	add	r2, r2, r0, lsl #3
	ldrb	r4, [r4, #16]	@ zero_extendqisi2
	ldrb	r2, [r2, #4]	@ zero_extendqisi2
	cmp	r4, #1
	lsr	r4, r1, #16
	lsl	r2, r2, #8
	add	r3, r3, r2
	bne	.L43
	movs	r2, #6
	str	r2, [r3, #2056]
	movs	r2, #0
	str	r2, [r3, #2052]
	str	r2, [r3, #2052]
	str	r6, [r3, #2052]
	str	r5, [r3, #2052]
	str	r4, [r3, #2052]
.L45:
	movs	r2, #224
	str	r2, [r3, #2056]
	pop	{r4, r5, r6}
	b	FlashSetRandomizer
.L43:
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
	b	.L45
.L47:
	.align	2
.L46:
	.word	.LANCHOR6
	.word	.LANCHOR7
	.size	FlashReadDpDataOutCmd, .-FlashReadDpDataOutCmd
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
	@ link register save eliminated.
	ldr	r3, .L53
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L48
	ldr	r3, .L53+4
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r3, r2, r3, lsl #8
	movs	r2, #218
	str	r2, [r3, #2056]
.L48:
	bx	lr
.L54:
	.align	2
.L53:
	.word	.LANCHOR8
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
	@ link register save eliminated.
	ldr	r3, .L60
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L55
	ldr	r3, .L60+4
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r3, r2, r3, lsl #8
	movs	r2, #223
	str	r2, [r3, #2056]
.L55:
	bx	lr
.L61:
	.align	2
.L60:
	.word	.LANCHOR8
	.word	.LANCHOR6
	.size	flash_exit_slc_mode, .-flash_exit_slc_mode
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
	ldr	r4, .L63
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
.L64:
	.align	2
.L63:
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
	ldr	r4, .L70
	ldr	r3, [r4, r0, lsl #3]
	add	r4, r4, r0, lsl #3
	ldrb	r0, [r4, #4]	@ zero_extendqisi2
	lsls	r0, r0, #8
	cbz	r2, .L66
	adds	r2, r3, r0
	movs	r4, #96
	str	r4, [r2, #2056]
	uxtb	r4, r1
	str	r4, [r2, #2052]
	lsrs	r4, r1, #8
	str	r4, [r2, #2052]
	lsrs	r4, r1, #16
	str	r4, [r2, #2052]
	ldr	r2, .L70+4
	ldr	r2, [r2]
	add	r1, r1, r2
.L66:
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
.L71:
	.align	2
.L70:
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
	ldr	r4, .L73
	ldr	r3, [r4, r0, lsl #3]
	add	r4, r4, r0, lsl #3
	ldrb	r5, [r4, #4]	@ zero_extendqisi2
	ldr	r4, .L73+4
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
.L74:
	.align	2
.L73:
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
	ldr	r3, .L76
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r3, r2, r3, lsl #8
	movs	r2, #16
	str	r2, [r3, #2056]
	bx	lr
.L77:
	.align	2
.L76:
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
	ldr	r3, .L79
	ldr	r1, .L79+4
	ldr	r2, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r1, [r1, #10]	@ zero_extendqisi2
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r3, r2, r3, lsl #8
	str	r1, [r3, #2056]
	bx	lr
.L80:
	.align	2
.L79:
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
	ldr	r3, .L82
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
.L83:
	.align	2
.L82:
	.word	.LANCHOR6
	.size	FlashReadStatus, .-FlashReadStatus
	.section	.text.JSHash,"ax",%progbits
	.align	1
	.global	JSHash
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	JSHash, %function
JSHash:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L87
	add	r1, r1, r0
	push	{r4, lr}
.L85:
	cmp	r0, r1
	bne	.L86
	mov	r0, r3
	pop	{r4, pc}
.L86:
	lsrs	r2, r3, #2
	ldrb	r4, [r0], #1	@ zero_extendqisi2
	add	r2, r2, r3, lsl #5
	add	r2, r2, r4
	eors	r3, r3, r2
	b	.L85
.L88:
	.align	2
.L87:
	.word	1204201446
	.size	JSHash, .-JSHash
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
	ldr	r10, .L99+12
	mov	r5, r0
	mov	r6, r1
	movs	r4, #0
	ldr	r8, .L99+16
.L92:
	ldrb	r3, [r10]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L96
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L96:
	movs	r3, #85
	movs	r0, #200
	str	r3, [r5, #8]
	ldrsb	r3, [r4, r8]
	str	r3, [r5, #4]
	bl	udelay
	ldr	r3, .L99
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L93
	adds	r3, r4, r7
	add	r3, r3, r8
.L98:
	ldrsb	r3, [r3, #5]
.L97:
	str	r3, [r5]
	adds	r4, r4, #1
	b	.L92
.L93:
	cmp	r3, #35
	bne	.L95
	ldr	r3, .L99+4
	adds	r2, r4, r7
	add	r3, r3, r2
	b	.L98
.L95:
	ldr	r3, .L99+8
	ldrsb	r3, [r3, r6]
	b	.L97
.L100:
	.align	2
.L99:
	.word	.LANCHOR10
	.word	.LANCHOR11
	.word	.LANCHOR12
	.word	.LANCHOR13
	.word	.LANCHOR9
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
	ldr	r7, .L104
	movs	r4, #0
	mov	r10, #161
	ldr	r8, .L104+4
	add	r1, r7, r1, lsl #2
	adds	r5, r1, #3
.L102:
	ldrb	r3, [r8]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L103
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L103:
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
	b	.L102
.L105:
	.align	2
.L104:
	.word	.LANCHOR14
	.word	.LANCHOR13
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
	ldr	r3, .L111
	mov	r8, r1
	mov	r7, r2
	mov	r5, r0
	ldrh	r4, [r3, #14]
	ldrh	r3, [r3, #12]
	smulbb	r4, r4, r3
	ldr	r3, .L111+4
	ldrh	fp, [r3]
	uxth	r4, r4
	ldr	r3, .L111+8
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
	bne	.L108
	ldr	r2, .L111+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L108
	ldr	r2, .L111+16
	ldrh	r3, [r2, r3, lsl #1]
.L108:
	ldr	r2, .L111+20
	ldr	r2, [r2, r10, lsl #2]
	mla	r1, fp, r1, r2
	add	r1, r1, r3
	ldrb	r3, [sp, #40]	@ zero_extendqisi2
	str	r1, [r7]
	str	r10, [r6]
	cmp	r3, #1
	bls	.L110
	ldr	r0, [r5, #4]
	ldr	r3, [r5, #40]
	add	r0, r0, #1024
	subs	r3, r0, r3
	rsbs	r0, r3, #0
	adcs	r0, r0, r3
.L109:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L110:
	movs	r0, #0
	b	.L109
.L112:
	.align	2
.L111:
	.word	.LANCHOR15
	.word	.LANCHOR3
	.word	.LANCHOR1
	.word	.LANCHOR8
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
	ldr	r3, .L125
	push	{r4, r5, r6, lr}
	ldr	r5, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r4, [r3, #4]	@ zero_extendqisi2
	ldr	r3, .L125+4
	ldr	r3, [r3]
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	cmp	r3, #2
	lsl	r3, r4, #8
	add	r4, r4, #8
	bne	.L114
	ldr	r0, .L125+8
	cbnz	r2, .L115
	ldrb	r2, [r0, #13]	@ zero_extendqisi2
.L124:
	add	r3, r3, r5
	str	r2, [r3, #2056]
	ldrb	r0, [r0, #15]	@ zero_extendqisi2
	cbz	r0, .L119
	add	r6, r5, r4, lsl #8
	movs	r2, #0
.L118:
	cmp	r2, r0
	bcc	.L120
.L119:
	lsls	r4, r4, #8
	movs	r0, #80
	bl	udelay
	ldr	r0, [r5, r4]
	uxtb	r0, r0
	pop	{r4, r5, r6, pc}
.L115:
	ldrb	r2, [r0, #14]	@ zero_extendqisi2
	b	.L124
.L120:
	lsls	r3, r2, #3
	adds	r2, r2, #1
	lsr	r3, r1, r3
	uxtb	r3, r3
	str	r3, [r6, #4]
	b	.L118
.L114:
	add	r3, r3, r5
	movs	r2, #112
	str	r2, [r3, #2056]
	b	.L119
.L126:
	.align	2
.L125:
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
.L131:
	mov	r2, r6
	mov	r1, r5
	mov	r0, r4
	bl	FlashReadStatusEN
	cmp	r0, #255
	mov	r3, r0
	beq	.L131
	lsls	r3, r3, #25
	bpl	.L131
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
	ldr	r2, .L136
	add	r3, r2, r0, lsl #3
	ldr	r0, [r2, r0, lsl #3]
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	adds	r3, r3, #8
	add	r0, r0, r3, lsl #8
	bx	lr
.L137:
	.align	2
.L136:
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
	ldr	r3, .L139
	ldr	r2, [r3]
	lsls	r3, r0, #8
	orr	r0, r3, r0, lsl #16
	orr	r0, r0, #1
	str	r0, [r2, #304]
	bx	lr
.L140:
	.align	2
.L139:
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
	ldr	r3, .L142
	orr	r0, r0, #16640
	ldr	r3, [r3]
	str	r0, [r3, #344]
	bx	lr
.L143:
	.align	2
.L142:
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
	ldr	r3, .L147
	ldr	r2, [r3]
	ldr	r3, [r2]
	cbnz	r0, .L145
	bfi	r3, r0, #13, #1
.L146:
	str	r3, [r2]
	bx	lr
.L145:
	orr	r3, r3, #253952
	b	.L146
.L148:
	.align	2
.L147:
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
	ldr	r3, .L156
	ands	r1, r0, #6
	ldr	r2, [r3]
	ldr	r3, [r2]
	beq	.L150
	lsls	r1, r0, #29
	movw	r1, #16641
	str	r1, [r2, #344]
	orr	r3, r3, #24576
	ldr	r1, .L156+4
	bfc	r3, #15, #1
	orr	r3, r3, #196608
	it	mi
	orrmi	r3, r3, #32768
	str	r1, [r2, #304]
	movs	r1, #38
	str	r1, [r2, #308]
	movs	r1, #39
	str	r1, [r2, #308]
.L152:
	str	r3, [r2]
	movs	r0, #0
	bx	lr
.L150:
	bfi	r3, r1, #13, #1
	b	.L152
.L157:
	.align	2
.L156:
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
	ldr	r3, .L159
	movs	r2, #1
	ldr	r1, [r3, r0, lsl #3]
	add	r0, r3, r0, lsl #3
	ldrb	r0, [r0, #4]	@ zero_extendqisi2
	ldr	r3, [r1]
	lsls	r2, r2, r0
	bfi	r3, r2, #0, #8
	str	r3, [r1]
	bx	lr
.L160:
	.align	2
.L159:
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
	ldr	r3, .L162
	ldr	r2, [r3, r0, lsl #3]
	ldr	r3, [r2]
	bfc	r3, #0, #8
	bfc	r3, #17, #1
	str	r3, [r2]
	bx	lr
.L163:
	.align	2
.L162:
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
	mov	r7, r3
	ldr	r3, .L171
	mov	r5, r0
	mov	r6, r1
	mov	r10, r2
	ldr	r4, .L171+4
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cmp	r3, #6
	bne	.L165
	movs	r3, #20
	add	r3, r3, r0, lsl #6
	add	r3, r3, r7, lsl #2
.L170:
	add	r4, r4, r3
.L166:
	ldr	r3, .L171+8
	mov	r0, r5
	subs	r6, r6, #1
	subs	r4, r4, #1
	add	r6, r6, r10
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
.L168:
	cmp	r3, r6
	bne	.L169
	movs	r3, #22
	add	r8, r8, fp
	str	r3, [r8, #2056]
	mov	r0, r5
	bl	NandcFlashDeCs
	ldr	r3, .L171+12
	strb	r7, [r3, r5]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L165:
	cmp	r3, #7
	bne	.L167
	movs	r3, #160
	movs	r2, #28
	smlabb	r2, r3, r0, r2
	movs	r3, #10
	smlabb	r3, r3, r7, r2
	b	.L170
.L167:
	adds	r3, r7, #2
	add	r3, r3, r0, lsl #3
	add	r4, r4, r3, lsl #3
	adds	r4, r4, #4
	b	.L166
.L169:
	ldrb	r2, [r3, #1]!	@ zero_extendqisi2
	movs	r0, #200
	str	r2, [r10, #2052]
	str	r3, [sp, #4]
	bl	udelay
	ldrsb	r2, [r4, #1]!
	ldr	r3, [sp, #4]
	str	r2, [r10, #2048]
	b	.L168
.L172:
	.align	2
.L171:
	.word	.LANCHOR18
	.word	.LANCHOR20
	.word	.LANCHOR6
	.word	.LANCHOR21
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
	ldr	r3, .L179
	push	{r4, r5, r6, lr}
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #6
	bhi	.L173
	ldr	r5, .L179+4
	movs	r4, #0
	adds	r6, r5, #4
.L176:
	ldr	r3, .L179+8
	uxtb	r0, r4
	ldrb	r3, [r3, r4, lsl #3]	@ zero_extendqisi2
	cmp	r3, #173
	bne	.L175
	movs	r3, #0
	mov	r2, r6
	ldrb	r1, [r5, #1]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L175:
	adds	r4, r4, #1
	cmp	r4, #4
	bne	.L176
.L173:
	pop	{r4, r5, r6, pc}
.L180:
	.align	2
.L179:
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
	ldr	r2, .L188
	lsls	r3, r0, #4
	push	{r4, r5, r6, lr}
	mov	r6, r0
	adds	r4, r2, r3
	ldr	r1, [r4, #8]
	cbz	r1, .L183
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	mov	r0, r5
	bl	NandcFlashCs
	ldr	r3, .L188+4
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
	cbz	r2, .L183
	str	r1, [r2]
	str	r3, [r4, #12]
.L183:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L189:
	.align	2
.L188:
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
	ldr	r3, .L196
	push	{r0, r1, r2, r4, r5, lr}
	ldr	r4, .L196+4
	ldr	r5, [r3, r0, lsl #3]
.L193:
	movs	r0, #100
	bl	udelay
	ldr	r3, [r5]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #22
	bmi	.L194
	subs	r4, r4, #1
	bne	.L193
	mov	r0, #-1
.L191:
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, pc}
.L194:
	movs	r0, #0
	b	.L191
.L197:
	.align	2
.L196:
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
	ldr	r3, .L199
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
.L200:
	.align	2
.L199:
	.word	.LANCHOR6
	.size	FlashReset, .-FlashReset
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
	ldr	r3, .L230
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
	str	r2, [sp]
	mov	r2, r5
	str	r3, [sp, #4]
.L212:
	ldr	r3, .L230+4
	ldrb	r4, [r5, r3]	@ zero_extendqisi2
	cmp	r4, #152
	beq	.L203
	cmp	r4, #69
	beq	.L203
	cmp	r4, #173
	beq	.L203
	cmp	r4, #44
	bne	.L204
.L203:
	ldr	r3, .L230+8
	cmp	r0, #1
	ldr	r1, [r5, r3]
	add	r3, r3, r5
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	bne	.L205
	ldr	r6, [sp, #4]
	cbz	r6, .L204
	lsls	r3, r3, #8
	cmp	r4, #173
	add	fp, r1, r3
	str	r7, [fp, #2056]
	bne	.L206
	str	r0, [fp, #2052]
.L229:
	str	r2, [fp, #2048]
	b	.L210
.L206:
	cmp	r4, #44
	ittet	eq
	moveq	r4, #5
	streq	r0, [fp, #2052]
	strne	ip, [fp, #2052]
	streq	r4, [fp, #2048]
	it	ne
	strne	r0, [fp, #2048]
.L210:
	add	r3, r3, r1
	str	r2, [r3, #2048]
	str	r2, [r3, #2048]
	str	r2, [r3, #2048]
.L204:
	adds	r5, r5, #8
	cmp	r5, #32
	bne	.L212
	movs	r0, #0
	bl	NandcWaitFlashReady
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L205:
	ldr	r6, [sp]
	cmp	r6, #0
	beq	.L204
	lsls	r3, r3, #8
	cmp	r4, #173
	add	fp, r1, r3
	str	r7, [fp, #2056]
	bne	.L209
	str	lr, [fp, #2052]
	str	r10, [fp, #2048]
	b	.L210
.L209:
	cmp	r4, #44
	bne	.L211
	str	lr, [fp, #2052]
	str	r8, [fp, #2048]
	b	.L210
.L211:
	str	ip, [fp, #2052]
	b	.L229
.L231:
	.align	2
.L230:
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
	ldr	r3, .L238
	add	r4, r4, r4, lsl #2
	ldr	r6, .L238+4
	movs	r2, #0
	ldr	r7, .L238+8
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r3, .L238+12
	ldrb	r0, [r3]	@ zero_extendqisi2
.L233:
	cmp	r2, r1
	bcc	.L236
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, lr}
	b	NandcWaitFlashReady
.L236:
	adds	r3, r2, r4
	cmp	r0, #67
	ite	eq
	addeq	r3, r3, r7
	addne	r3, r3, r6
	ldrsb	r3, [r3, #5]
	adds	r2, r2, #1
	str	r3, [r5]
	b	.L233
.L239:
	.align	2
.L238:
	.word	.LANCHOR13
	.word	.LANCHOR11
	.word	.LANCHOR9
	.word	.LANCHOR10
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
	ldr	r0, .L241
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
.L242:
	.align	2
.L241:
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
	ldr	r8, .L253+12
	sub	sp, sp, #20
	mov	r5, r0
	movs	r6, #0
	ldr	r10, .L253+16
.L244:
	cmp	r6, r7
	bne	.L249
	movs	r0, #0
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L249:
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
	bhi	.L245
	mov	r3, #-1
	str	r3, [r5]
.L246:
	adds	r6, r6, #1
	adds	r5, r5, #36
	b	.L244
.L245:
	ldrb	r4, [r10, r3]	@ zero_extendqisi2
	lsls	r3, r3, #4
	ldr	r2, .L253
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
	ldr	r3, .L253+4
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
	bne	.L248
	ldr	r1, [sp, #8]
	ldr	r0, .L253+8
	bl	printf
.L248:
	mov	r0, r4
	bl	NandcFlashDeCs
	b	.L246
.L254:
	.align	2
.L253:
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
	ldr	r3, .L286
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r0
	sub	sp, sp, #24
	mov	fp, r1
	mov	r7, r2
	ldrb	r4, [r3]	@ zero_extendqisi2
	cbnz	r4, .L256
	ldr	r10, .L286+8
.L257:
	cmp	r4, r7
	bcc	.L266
	ldr	r5, .L286+4
	movs	r4, #0
	ldr	r6, .L286+8
.L267:
	ldr	r3, .L286+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L269
	ldr	r3, .L286+16
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L270
.L271:
	movs	r0, #0
	b	.L255
.L256:
	mov	r1, r2
	bl	FlashEraseSLc2KBlocks
.L255:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L266:
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
	ldr	r3, .L286+12
	mov	r6, r0
	ldr	r0, [sp, #20]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L259
	mov	r3, #-1
	str	r3, [r8, r5]
.L260:
	adds	r4, r4, #1
	b	.L257
.L259:
	ldr	r3, .L286+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	add	r3, r10, r0, lsl #4
	it	eq
	moveq	r6, #0
	ldr	r3, [r3, #8]
	cbz	r3, .L262
	uxtb	r0, r0
	bl	FlashWaitCmdDone
.L262:
	ldr	r1, [sp, #20]
	ldr	r0, [sp, #12]
	lsls	r2, r1, #4
	add	r3, r10, r2
	str	r0, [r3, #8]
	movs	r0, #0
	str	r0, [r3, #12]
	ldr	r0, [sp, #16]
	str	r0, [r3, #4]
	cbz	r6, .L263
	adds	r5, r5, #36
	add	r5, r5, r8
	str	r5, [r3, #12]
.L263:
	ldr	r3, .L286+24
	ldrb	r5, [r3, r1]	@ zero_extendqisi2
	mov	r0, r5
	strb	r5, [r10, r2]
	bl	NandcFlashCs
	cmp	fp, #1
	mov	r0, r5
	bne	.L264
	ldr	r3, .L286+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L264
	bl	flash_enter_slc_mode
.L265:
	ldr	r3, .L286+28
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
	b	.L260
.L264:
	bl	flash_exit_slc_mode
	b	.L265
.L269:
	uxtb	r0, r4
	bl	FlashWaitCmdDone
	cmp	fp, #1
	bne	.L268
	ldrb	r3, [r5]	@ zero_extendqisi2
	cbz	r3, .L268
	lsls	r3, r4, #4
	ldrb	r0, [r6, r3]	@ zero_extendqisi2
	bl	flash_exit_slc_mode
.L268:
	adds	r4, r4, #1
	b	.L267
.L270:
	ldr	r3, .L286+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #69
	bne	.L271
	movs	r3, #0
	movs	r2, #36
	mov	r1, r3
.L272:
	cmp	r3, r7
	beq	.L271
	mul	r0, r2, r3
	adds	r3, r3, #1
	str	r1, [r8, r0]
	b	.L272
.L287:
	.align	2
.L286:
	.word	.LANCHOR1
	.word	.LANCHOR8
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
	ldr	r3, .L292
	mov	r6, r1
	uxtb	lr, r1
	mov	r7, r0
	lsrs	r1, r1, #8
	uxtb	r8, r5
	ldr	r10, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r4, [r3, #4]	@ zero_extendqisi2
	ldr	r3, .L292+4
	ldrb	r2, [r3, #16]	@ zero_extendqisi2
	lsls	r4, r4, #8
	ldrb	ip, [r3, #8]	@ zero_extendqisi2
	add	r4, r4, r10
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	cmp	r2, #1
	lsr	r2, r6, #16
	str	ip, [r4, #2056]
	bne	.L289
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
.L291:
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
.L289:
	str	lr, [r4, #2052]
	str	r1, [r4, #2052]
	str	r2, [r4, #2052]
	str	r3, [r4, #2056]
	b	.L291
.L293:
	.align	2
.L292:
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
	ldr	r3, .L303
	ldr	r2, [r3]
	ldr	r3, .L303+4
	cmp	r2, r3
	bne	.L295
	movs	r0, #0
	bl	flash_enter_slc_mode
.L295:
	ldr	r4, .L303+8
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L296
	ldr	r3, .L303+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L296
	movs	r0, #1
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	movs	r3, #0
	strb	r3, [r4]
.L296:
	ldr	r3, .L303+16
	movs	r0, #0
	ldr	r3, [r3]
	str	r0, [r3, #336]
	pop	{r4, pc}
.L304:
	.align	2
.L303:
	.word	.LANCHOR29
	.word	1446522928
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
	ldr	r3, .L306
	ldr	r3, [r3, r0, lsl #3]
	str	r1, [r3, #336]
	bx	lr
.L307:
	.align	2
.L306:
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
	ldr	r3, .L313
	cmp	r0, #35
	ldr	r3, [r3]
	bhi	.L309
	movw	r2, #4193
.L312:
	str	r2, [r3, #4]
	bx	lr
.L309:
	cmp	r0, #99
	ite	hi
	movwhi	r2, #8322
	movwls	r2, #4225
	b	.L312
.L314:
	.align	2
.L313:
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
	ldr	r3, .L316
	ldrb	r0, [r3, #21]	@ zero_extendqisi2
	b	NandcTimeCfg
.L317:
	.align	2
.L316:
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
	ldr	r3, .L326
	movs	r1, #0
	push	{r4, lr}
	movs	r4, #16
	cmp	r0, r4
	ldr	r2, [r3]
	mov	r3, #1
	str	r3, [r2, #8]
	ldr	r3, .L326+4
	str	r0, [r3]
	mov	r3, r1
	bfi	r3, r4, #8, #8
	bfi	r3, r1, #18, #1
	bne	.L319
.L322:
	bfc	r3, #4, #1
.L320:
	orr	r3, r3, #1
	str	r3, [r2, #12]
	pop	{r4, pc}
.L319:
	cmp	r0, #24
	bne	.L321
	orr	r3, r3, #16
	b	.L320
.L321:
	cmp	r0, #40
	orr	r3, r3, #262144
	orr	r3, r3, #16
	bne	.L320
	b	.L322
.L327:
	.align	2
.L326:
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
	ldr	r3, .L329
	strb	r0, [r3]
	b	NandcBchSel
.L330:
	.align	2
.L329:
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
	ldr	r3, .L338
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
.L339:
	.align	2
.L338:
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
.L341:
	ldr	r3, [r0, #8]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #11
	bpl	.L341
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
	bne	.L358
	adds	r5, fp, #0
	it	ne
	movne	r5, #1
.L345:
	ldr	r1, .L363
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
	ldr	r3, .L363+4
	ldr	r3, [r3]
	cmp	r3, #3
	bls	.L346
	ldr	r3, [r6, #16]
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	bfc	r3, #2, #1
	str	r3, [sp, #20]
	cmp	r5, #0
	beq	.L347
	ldr	r5, .L363+8
	cmp	r7, #0
	bne	.L348
.L356:
	ldr	r2, [sp, #4]
	adds	r2, r2, #1
	asrs	r2, r2, #1
	bfi	r4, r2, #22, #6
	cmp	fp, #0
	beq	.L349
	mov	r0, fp
.L350:
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
.L347:
	ldr	r3, [sp, #20]
	str	r3, [r6, #16]
.L346:
	str	r8, [r6, #12]
	str	r4, [r6, #8]
	orr	r4, r4, #4
	str	r4, [r6, #8]
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L358:
	movs	r5, #1
	b	.L345
.L348:
	ldr	r3, .L363+12
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
.L352:
	ldr	r2, [sp, #12]
	cmp	r0, r2
	bcs	.L356
	ldr	r2, [sp, #60]
	bic	r10, r1, #3
	cbz	r2, .L353
	ldrh	ip, [r3]
	adds	r3, r3, #4
	ldrh	r2, [r3, #-2]
	orr	ip, ip, r2, lsl #16
	str	ip, [lr, r10]
.L354:
	ldr	r2, [sp, #8]
	adds	r0, r0, #1
	add	r1, r1, r2
	b	.L352
.L353:
	mov	r2, #-1
	str	r2, [lr, r10]
	b	.L354
.L349:
	ldr	r3, .L363+8
	ldr	r0, [r3]
	b	.L350
.L364:
	.align	2
.L363:
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
	ldr	r3, .L393
	push	{r0, r1, r4, lr}
	ldr	r1, [r3, r0, lsl #3]
	ldr	r3, .L393+4
	ldr	r0, [r3]
	cmp	r0, #3
	bls	.L386
	ldr	r3, [r1, #16]
	lsls	r2, r3, #29
	bpl	.L386
	ldr	r3, [r1, #16]
	tst	r3, #2
	ldr	r3, [r1, #8]
	str	r3, [sp]
	beq	.L373
.L369:
	ldr	r2, [r1, #28]
	ldr	r3, [sp]
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	cmp	r2, r3
	bge	.L370
	cmp	r0, #5
	bls	.L369
	ldr	r3, [r1]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #18
	bpl	.L369
	ldr	r3, [sp, #4]
	lsls	r4, r3, #14
	bpl	.L369
.L370:
	ldr	r3, .L393+8
	movs	r2, #0
	str	r2, [r3, #24]
.L365:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L374:
	ldr	r3, [r1, #8]
	str	r3, [sp]
.L373:
	ldr	r3, [sp]
	lsls	r2, r3, #11
	bpl	.L374
	ldr	r4, .L393+12
	ldr	r2, [r4]
	cbz	r2, .L375
	mov	r0, r1
	bl	NandcSendDumpDataStart
.L375:
	ldr	r3, [r4]
	cmp	r3, #0
	beq	.L370
	mov	r0, r1
	bl	NandcSendDumpDataDone
	b	.L370
.L386:
	ldr	r3, [r1, #8]
	str	r3, [sp]
	ldr	r3, [sp]
	lsls	r3, r3, #11
	bpl	.L386
	b	.L365
.L394:
	.align	2
.L393:
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
.L396:
	cmp	r2, r0
	uxth	r3, r1
	add	r1, r1, #1
	bls	.L397
	subs	r0, r3, #1
	uxth	r0, r0
	bx	lr
.L397:
	lsls	r2, r2, #1
	b	.L396
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
	ldr	r3, .L400
	cmp	r0, #24
	it	cc
	movcc	r0, #24
	ldr	r2, .L400+4
	str	r0, [r3]
	ldr	r3, .L400+8
	ldrh	r3, [r3]
	muls	r3, r0, r3
	str	r3, [r2]
	ldr	r2, .L400+12
	ldrh	r2, [r2]
	subs	r0, r2, r0
	ldr	r2, .L400+16
	strh	r0, [r2]	@ movhi
	movs	r0, #0
	ldr	r2, .L400+20
	ldr	r2, [r2]
	subs	r3, r2, r3
	ldr	r2, .L400+24
	str	r3, [r2]
	bx	lr
.L401:
	.align	2
.L400:
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
	ldr	r3, .L429
	ldr	r1, .L429+4
	ldrh	r6, [r10, #14]
	ldr	r2, .L429+8
	strh	r7, [r3]	@ movhi
	ldrh	r3, [r0, #10]
	ldrh	r0, [r0, #12]
	strh	r6, [r1]	@ movhi
	str	r1, [sp, #20]
	ldr	r1, .L429+12
	ldr	r4, .L429+16
	strh	r0, [r2]	@ movhi
	movs	r2, #0
	strh	r3, [r4]	@ movhi
	str	r4, [sp, #8]
.L403:
	strb	r2, [r2, r1]
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L403
	ldrh	r1, [r10, #14]
	ldrh	r2, [r10, #20]
	cmp	r2, r1, lsr #8
	bcs	.L404
	uxtb	r8, r0
	lsl	r2, r8, #1
	uxtb	r2, r2
	str	r2, [sp, #4]
	subs	r2, r3, #1
	muls	r2, r0, r2
	str	r2, [sp, #12]
	movs	r2, #0
.L405:
	cmp	r2, r0
	bcs	.L407
	ldr	r4, [sp, #12]
	sub	fp, r2, r0
	uxtb	r1, r2
	adds	r5, r2, r4
	ldr	r4, .L429+12
	add	r4, r4, r5
	movs	r5, #0
	mov	lr, r4
	ldr	r4, .L429+12
	mov	ip, r5
	add	fp, fp, r4
	b	.L408
.L406:
	add	r4, r8, r1
	strb	r1, [fp, r5]
	str	r4, [sp, #16]
	add	ip, ip, #1
	ldrb	r4, [sp, #16]	@ zero_extendqisi2
	strb	r4, [lr, r5]
	ldr	r4, [sp, #4]
	add	r1, r1, r4
	uxtb	r1, r1
.L408:
	cmp	ip, r3
	add	r5, r5, r0
	bcc	.L406
	adds	r2, r2, #1
	b	.L405
.L407:
	ldr	r2, [sp, #8]
	lsls	r3, r3, #1
	lsrs	r6, r6, #1
	strh	r3, [r2]	@ movhi
	ldr	r3, .L429+4
	strh	r6, [r3]	@ movhi
.L404:
	ldr	r3, .L429+20
	movs	r2, #5
	cmp	r7, #1
	mov	r1, #0
	strh	r2, [r3]	@ movhi
	ldr	r2, .L429+24
	it	eq
	strheq	r7, [r3]	@ movhi
	ldr	r3, .L429+28
	strh	r1, [r2]	@ movhi
	mov	r1, #4352
	strh	r1, [r3]	@ movhi
	ldr	r1, .L429+32
	ldrb	r1, [r1]	@ zero_extendqisi2
	str	r1, [sp, #4]
	cbz	r1, .L410
	mov	r1, #384
	strh	r1, [r3]	@ movhi
.L410:
	ldr	r3, [sp, #8]
	str	r2, [sp, #16]
	ldr	fp, .L429+120
	ldrh	r5, [r3]
	ldr	r3, .L429+36
	ldr	r8, .L429+124
	smulbb	r5, r5, r0
	uxth	r5, r5
	strh	r5, [r3]	@ movhi
	ldr	r3, [sp, #20]
	ldrh	r4, [r3]
	ldr	r3, .L429+40
	smulbb	r0, r0, r4
	uxth	r0, r0
	strh	r0, [r3]	@ movhi
	bl	Ftl_log2
	ldr	r3, .L429+44
	ldrh	r6, [r10, #16]
	ldrh	r1, [r10, #18]
	strh	r0, [r3]	@ movhi
	ldr	r3, .L429+48
	smulbb	r0, r5, r6
	strh	r6, [fp]	@ movhi
	str	r1, [sp, #12]
	strh	r1, [r3]	@ movhi
	ldr	r3, .L429+52
	strh	r0, [r3]	@ movhi
	ldrh	r3, [r10, #20]
	mov	r0, r3
	strh	r3, [r8]	@ movhi
	str	r3, [sp, #8]
	bl	Ftl_log2
	ldr	r3, [sp, #8]
	mov	r7, r0
	ldr	ip, .L429+128
	cmp	r4, #1024
	ldr	lr, .L429+132
	ldr	r2, [sp, #16]
	strh	r0, [ip]	@ movhi
	lsl	r0, r3, #9
	ldr	r1, [sp, #12]
	uxth	r0, r0
	strh	r0, [lr]	@ movhi
	lsr	r0, r0, #8
	ldr	lr, .L429+136
	mul	r1, r3, r1
	strh	r0, [lr]	@ movhi
	ldrh	lr, [r10, #26]
	mov	r10, ip
	ldr	r0, .L429+56
	strh	lr, [r0]	@ movhi
	mul	lr, r4, r5
	ldr	r0, .L429+60
	str	lr, [r0]
	itt	hi
	uxtbhi	r0, r4
	strhhi	r0, [r2]	@ movhi
	ldrh	r2, [r2]
	subs	r2, r4, r2
	muls	r2, r5, r2
	muls	r2, r3, r2
	muls	r6, r2, r6
	ldr	r2, .L429+64
	asrs	r6, r6, #11
	str	r6, [r2]
	ldr	r6, .L429+28
	ldrh	r0, [r6]
	lsls	r0, r0, #3
	bl	__aeabi_idiv
	uxth	r0, r0
	mov	r3, r6
	ldr	r6, .L429+68
	cmp	r0, #4
	itt	ls
	movls	r2, #4
	strhls	r2, [r6]	@ movhi
	ldr	r2, [sp, #4]
	it	hi
	strhhi	r0, [r6]	@ movhi
	cbz	r2, .L414
	mov	r2, #640
	strh	r2, [r3]	@ movhi
.L414:
	ldrh	r3, [r3]
	lsls	r4, r4, #6
	ldr	r2, .L429+72
	mov	r1, r5
	ldrh	r0, [r6]
	asrs	r3, r3, r7
	adds	r7, r7, #9
	asrs	r4, r4, r7
	ldr	r7, .L429+76
	adds	r3, r3, #2
	strh	r3, [r2]	@ movhi
	ldr	r3, .L429+80
	strh	r4, [r3]	@ movhi
	uxth	r4, r4
	mul	r3, r4, r5
	adds	r4, r4, #8
	str	r3, [r7]
	bl	__aeabi_uidiv
	uxtah	r0, r4, r0
	ldr	r4, .L429+84
	cmp	r5, #1
	ldr	r5, .L429+88
	it	eq
	addeq	r0, r0, #4
	str	r0, [r4]
	ldrh	r0, [r4]
	bl	FtlSysBlkNumInit
	ldr	r2, [r4]
	movs	r0, #24
	ldr	r3, .L429+92
	ldrb	r5, [r5]	@ zero_extendqisi2
	str	r2, [r3]
	ldr	r3, .L429+96
	ldr	r2, [r3]
	ldrh	r3, [fp]
	lsls	r2, r2, #2
	muls	r3, r2, r3
	ldrh	r2, [r10]
	adds	r2, r2, #9
	lsrs	r3, r3, r2
	ldr	r2, .L429+100
	adds	r3, r3, #2
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L429+104
	strh	r0, [r2]	@ movhi
	movs	r0, #0
	ldr	r2, .L429+108
	str	r0, [r2]
	ldrh	r0, [r6]
	adds	r2, r0, #3
	strh	r2, [r6]	@ movhi
	ldr	r2, [r7]
	adds	r4, r2, #3
	str	r4, [r7]
	cbz	r5, .L417
	adds	r2, r2, #5
	adds	r0, r0, #4
	strh	r0, [r6]	@ movhi
.L428:
	str	r2, [r7]
.L418:
	ldr	r1, .L429+112
	movs	r2, #0
	strh	r2, [r1]	@ movhi
	ldr	r2, .L429+116
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
.L417:
	cmp	r4, #7
	bhi	.L418
	movs	r2, #8
	b	.L428
.L430:
	.align	2
.L429:
	.word	.LANCHOR44
	.word	.LANCHOR41
	.word	.LANCHOR46
	.word	.LANCHOR47
	.word	.LANCHOR45
	.word	.LANCHOR48
	.word	.LANCHOR49
	.word	.LANCHOR50
	.word	.LANCHOR1
	.word	.LANCHOR38
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR54
	.word	.LANCHOR55
	.word	.LANCHOR60
	.word	.LANCHOR43
	.word	.LANCHOR61
	.word	.LANCHOR62
	.word	.LANCHOR63
	.word	.LANCHOR65
	.word	.LANCHOR64
	.word	.LANCHOR37
	.word	.LANCHOR8
	.word	.LANCHOR66
	.word	.LANCHOR42
	.word	.LANCHOR67
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LANCHOR70
	.word	.LANCHOR40
	.word	.LANCHOR53
	.word	.LANCHOR56
	.word	.LANCHOR57
	.word	.LANCHOR58
	.word	.LANCHOR59
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
	ldr	r3, .L438
	ldrh	r3, [r3]
	cbz	r3, .L437
	ldr	r3, .L438+4
	ldr	r2, .L438+8
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L433:
	cmp	r3, r2
	bne	.L434
.L437:
	movs	r0, #0
	bx	lr
.L434:
	ldrh	r1, [r3], #2
	cmp	r0, r1
	bne	.L433
	movs	r0, #1
	bx	lr
.L439:
	.align	2
.L438:
	.word	.LANCHOR71
	.word	.LANCHOR72
	.word	.LANCHOR62
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
	ldr	r3, .L441
	ldr	r0, [r3]
	bx	lr
.L442:
	.align	2
.L441:
	.word	.LANCHOR69
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
	ldr	r3, .L444
	ldr	r0, [r3]
	bx	lr
.L445:
	.align	2
.L444:
	.word	.LANCHOR69
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
	ldr	r3, .L447
	ldr	r0, [r3]
	bx	lr
.L448:
	.align	2
.L447:
	.word	.LANCHOR69
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
	ldr	r3, .L450
	ldr	r0, [r3]
	bx	lr
.L451:
	.align	2
.L450:
	.word	.LANCHOR73
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
	ldr	r2, .L453
	ldr	r3, .L453+4
	ldr	r0, [r2]
	ldrh	r3, [r3]
	muls	r0, r3, r0
	bx	lr
.L454:
	.align	2
.L453:
	.word	.LANCHOR74
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
	ldr	r2, .L456
	ldr	r3, .L456+4
	ldrh	r0, [r2]
	ldrh	r3, [r3]
	muls	r0, r3, r0
	bx	lr
.L457:
	.align	2
.L456:
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
	ldr	r3, .L459
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	mov	r1, r4
	ldr	r4, .L459+4
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
	ldr	r0, .L459+8
	bl	printf
	ldrh	r3, [r4, #6]
	movs	r0, #0
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L460:
	.align	2
.L459:
	.word	.LANCHOR51
	.word	.LANCHOR75
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
	ldr	r3, .L462
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	mov	r1, r5
	bl	__aeabi_uidivmod
	mov	r0, r6
	uxth	r4, r1
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r3, .L462+4
	uxth	r0, r0
	lsrs	r2, r4, #5
	and	r4, r4, #31
	add	r0, r3, r0, lsl #2
	ldr	r3, [r0, #28]
	ldr	r0, [r3, r2, lsl #2]
	lsrs	r0, r0, r4
	and	r0, r0, #1
	pop	{r4, r5, r6, pc}
.L463:
	.align	2
.L462:
	.word	.LANCHOR51
	.word	.LANCHOR75
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
	ldr	r3, .L466
	mov	r7, r0
	ldrh	r6, [r3]
	mov	r1, r6
	bl	__aeabi_uidiv
	ldr	r3, .L466+4
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
.L467:
	.align	2
.L466:
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
	ldr	r3, .L469
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	ldr	r3, .L469+4
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	smulbb	r4, r0, r5
	mov	r1, r5
	mov	r0, r6
	bl	__aeabi_uidivmod
	add	r1, r1, r4
	uxth	r0, r1
	pop	{r4, r5, r6, pc}
.L470:
	.align	2
.L469:
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
	ldr	r3, .L472
	ldrh	r1, [r3]
	bl	__aeabi_uidivmod
	ldr	r3, .L472+4
	uxth	r0, r1
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	uxth	r0, r0
	pop	{r3, pc}
.L473:
	.align	2
.L472:
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
	bls	.L475
	subs	r0, r0, r1
	cmp	r0, #-2147483648
	ite	hi
	movhi	r0, #0
	movls	r0, #1
	bx	lr
.L475:
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
	ldr	r3, .L478
	ldrh	r0, [r3, #6]
	clz	r0, r0
	lsrs	r0, r0, #5
	bx	lr
.L479:
	.align	2
.L478:
	.word	.LANCHOR76
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
	ldr	r3, .L481
	ldrh	r0, [r3, #6]
	sub	r3, r0, #1024
	rsbs	r0, r3, #0
	adcs	r0, r0, r3
	bx	lr
.L482:
	.align	2
.L481:
	.word	.LANCHOR76
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
	bhi	.L483
	ldr	r4, .L492
	ldrh	r3, [r4, #6]
	cmp	r3, #1024
	beq	.L483
	cbz	r1, .L485
	ldr	r3, .L492+4
	ldr	r3, [r3]
	cbnz	r3, .L485
	bl	P2V_block_in_plane
	ldr	r3, .L492+8
	mov	r6, r0
	movs	r2, #1
	mov	r1, r2
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L492+12
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	ldr	r2, .L492+16
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L485:
	ldrh	r3, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #4]
	adds	r2, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	strh	r5, [r4, r2, lsl #1]	@ movhi
	strh	r3, [r4, #4]	@ movhi
.L483:
	pop	{r4, r5, r6, pc}
.L493:
	.align	2
.L492:
	.word	.LANCHOR76
	.word	.LANCHOR77
	.word	.LANCHOR78
	.word	.LANCHOR79
	.word	.LANCHOR80
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
	ldr	r3, .L503
	push	{r4, r5, r6, lr}
	ldrh	r2, [r3, #6]
	cbz	r2, .L494
	ldr	r2, .L503+4
	movs	r6, #0
	ldrh	r1, [r3, #2]
	mov	r5, r6
	ldrh	r4, [r2, #28]
	ldrh	r2, [r3, #4]
	and	r4, r4, #31
.L496:
	uxth	r0, r6
	adds	r6, r6, #1
	cmp	r4, r0
	bgt	.L497
	cbz	r5, .L494
	strh	r1, [r3, #2]	@ movhi
	strh	r2, [r3, #4]	@ movhi
.L494:
	pop	{r4, r5, r6, pc}
.L497:
	adds	r0, r1, #4
	adds	r1, r1, #1
	ldrh	r5, [r3, r0, lsl #1]
	adds	r0, r2, #4
	ubfx	r1, r1, #0, #10
	strh	r5, [r3, r0, lsl #1]	@ movhi
	movs	r5, #1
	add	r2, r2, r5
	ubfx	r2, r2, #0, #10
	b	.L496
.L504:
	.align	2
.L503:
	.word	.LANCHOR76
	.word	.LANCHOR81
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
	ldr	r4, .L515
	mov	r6, r4
.L506:
	ldrh	r1, [r4, #6]
	cmp	r1, #0
	beq	.L507
	ldrh	r3, [r4, #2]
	subs	r1, r1, #1
	strh	r1, [r4, #6]	@ movhi
	adds	r2, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	ldrh	r5, [r4, r2, lsl #1]
	strh	r3, [r4, #2]	@ movhi
	ldr	r3, .L515+4
	ldr	r10, [r3]
	cmp	r10, #0
	bne	.L508
	ldr	r8, .L515+28
	mov	r0, r5
	bl	P2V_block_in_plane
	mov	r7, r0
	lsls	r3, r5, #10
	ldr	r0, [r8]
	str	r3, [r0, #4]
	ldr	r3, .L515+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L509
	movs	r2, #1
	mov	r1, r10
	bl	FlashEraseBlocks
.L509:
	movs	r2, #1
	ldr	r0, [r8]
	mov	r1, r2
	bl	FlashEraseBlocks
	ldr	r3, .L515+12
	ldr	r2, [r3]
	ldrh	r3, [r2, r7, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	ldr	r2, .L515+16
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L508:
	subs	r3, r5, #1
	movw	r2, #65533
	uxth	r3, r3
	cmp	r3, r2
	bls	.L511
	ldrh	r2, [r6, #6]
	mov	r1, r5
	ldr	r0, .L515+20
	bl	printf
	b	.L506
.L507:
	ldr	r0, .L515+24
	bl	printf
.L510:
	b	.L510
.L511:
	mov	r0, r5
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L516:
	.align	2
.L515:
	.word	.LANCHOR76
	.word	.LANCHOR77
	.word	.LANCHOR8
	.word	.LANCHOR79
	.word	.LANCHOR80
	.word	.LC4
	.word	.LC3
	.word	.LANCHOR78
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
	ldr	r3, .L522
	push	{r4, r5, lr}
	movw	r5, #65535
	ldr	r2, [r0]
	ldr	r4, [r3]
	subs	r3, r2, r4
	asrs	r0, r3, #1
	ldr	r3, .L522+4
	muls	r3, r0, r3
	movs	r0, #6
	uxth	r3, r3
.L519:
	cmp	r3, r1
	beq	.L520
	ldrh	r3, [r2]
	cmp	r3, r5
	beq	.L521
	mla	r2, r0, r3, r4
	b	.L519
.L520:
	movs	r0, #1
	pop	{r4, r5, pc}
.L521:
	movs	r0, #0
	pop	{r4, r5, pc}
.L523:
	.align	2
.L522:
	.word	.LANCHOR82
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
	ldr	r3, .L540
	ldrh	lr, [r3]
	cmp	lr, r0
	bls	.L526
	ldr	r3, .L540+4
	movs	r5, #6
	ldr	r4, [r3]
	mul	r3, r5, r0
	str	r3, [sp, #4]
	adds	r1, r4, r3
	ldr	r2, [sp, #4]
	movw	r3, #65535
	strh	r3, [r1, #2]	@ movhi
	strh	r3, [r4, r2]	@ movhi
	ldr	r3, .L540+8
	ldr	ip, [r3]
	cmp	ip, #0
	bne	.L527
.L539:
	str	r1, [r3]
.L526:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L527:
	ldr	r3, .L540+12
	lsls	r2, r0, #1
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldrh	r6, [r3, r0, lsl #1]
	ldrh	r3, [r1, #4]
	cbz	r3, .L537
	mul	fp, r3, r6
.L528:
	sub	r3, ip, r4
	asrs	r6, r3, #1
	ldr	r3, .L540+16
	muls	r3, r6, r3
	ldr	r6, .L540+20
	ldr	r8, [r6]
	movs	r6, #0
	uxth	r3, r3
	add	r2, r8, r2
	str	r2, [sp, #12]
	mov	r2, ip
.L535:
	adds	r6, r6, #1
	uxth	r6, r6
	cmp	lr, r6
	bcc	.L526
	cmp	r3, r0
	beq	.L526
	ldr	r7, [sp, #8]
	lsl	r10, r3, #1
	ldrh	r7, [r7, r3, lsl #1]
	mov	r5, r7
	ldrh	r7, [r2, #4]
	cbz	r7, .L538
	muls	r7, r5, r7
.L530:
	cmp	fp, r7
	bne	.L531
	ldr	r5, [sp, #12]
	ldrh	r10, [r8, r10]
	ldrh	r7, [r5]
	cmp	r10, r7
	bcc	.L533
.L532:
	ldr	r5, [sp, #4]
	cmp	r2, ip
	strh	r3, [r4, r5]	@ movhi
	ldrh	r3, [r2, #2]
	strh	r3, [r1, #2]	@ movhi
	bne	.L536
	strh	r0, [r2, #2]	@ movhi
	ldr	r3, .L540+8
	b	.L539
.L537:
	mov	fp, #-1
	b	.L528
.L538:
	mov	r7, #-1
	b	.L530
.L531:
	bcc	.L532
.L533:
	ldrh	r7, [r2]
	movw	r5, #65535
	cmp	r7, r5
	bne	.L534
	strh	r3, [r1, #2]	@ movhi
	strh	r0, [r2]	@ movhi
	ldr	r3, .L540+24
	b	.L539
.L534:
	movs	r3, #6
	mla	r2, r3, r7, r4
	mov	r3, r7
	b	.L535
.L536:
	ldrh	r1, [r2, #2]
	movs	r3, #6
	muls	r3, r1, r3
	strh	r0, [r4, r3]	@ movhi
	strh	r0, [r2, #2]	@ movhi
	b	.L526
.L541:
	.align	2
.L540:
	.word	.LANCHOR40
	.word	.LANCHOR82
	.word	.LANCHOR83
	.word	.LANCHOR84
	.word	-1431655765
	.word	.LANCHOR79
	.word	.LANCHOR85
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
	ldr	r2, .L544
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L544+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L542
	ldr	r1, .L544+8
	movs	r2, #210
	ldr	r0, .L544+12
	bl	printf
	ldr	r1, .L544+16
	ldr	r0, .L544+20
	pop	{r3, lr}
	b	printf
.L542:
	pop	{r3, pc}
.L545:
	.align	2
.L544:
	.word	.LANCHOR86
	.word	.LANCHOR40
	.word	.LANCHOR87
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
	beq	.L547
	ldr	r3, .L553
	mov	r10, #6
	mul	r7, r10, r0
	ldr	r4, [r3]
	ldr	r3, .L553+4
	adds	r5, r4, r7
	ldr	r6, [r3]
	mov	lr, r3
	strh	r1, [r5, #2]	@ movhi
	strh	r1, [r4, r7]	@ movhi
	cbnz	r6, .L548
	str	r5, [r3]
.L547:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L548:
	ldr	r3, .L553+8
	subs	r2, r6, r4
	mov	fp, r1
	ldr	ip, [r3]
	asrs	r3, r2, #1
	ldr	r2, .L553+12
	ldrh	r8, [ip, r0, lsl #1]
	muls	r2, r3, r2
	mov	r3, r6
	uxth	r2, r2
.L551:
	ldrh	r1, [ip, r2, lsl #1]
	cmp	r1, r8
	bcs	.L549
	ldrh	r1, [r3]
	cmp	r1, fp
	bne	.L550
	strh	r2, [r5, #2]	@ movhi
	strh	r0, [r3]	@ movhi
	b	.L547
.L550:
	mla	r3, r10, r1, r4
	mov	r2, r1
	b	.L551
.L549:
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
	b	.L547
.L554:
	.align	2
.L553:
	.word	.LANCHOR82
	.word	.LANCHOR88
	.word	.LANCHOR79
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
	ldr	r2, .L557
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L557+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L555
	ldr	r1, .L557+8
	movs	r2, #203
	ldr	r0, .L557+12
	bl	printf
	ldr	r1, .L557+16
	ldr	r0, .L557+20
	pop	{r3, lr}
	b	printf
.L555:
	pop	{r3, pc}
.L558:
	.align	2
.L557:
	.word	.LANCHOR89
	.word	.LANCHOR40
	.word	.LANCHOR90
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
	ldr	r5, .L565
	muls	r6, r1, r6
	movw	r3, #65535
	mov	r8, r0
	ldr	r7, [r5]
	adds	r4, r7, r6
	ldrh	r2, [r4, #2]
	cmp	r2, r3
	bne	.L560
	ldr	r3, [r0]
	cmp	r4, r3
	beq	.L560
	ldr	r1, .L565+4
	mov	r2, #386
	ldr	r0, .L565+8
	bl	printf
	ldr	r1, .L565+12
	ldr	r0, .L565+16
	bl	printf
.L560:
	ldr	r3, [r8]
	movw	r1, #65535
	cmp	r4, r3
	ldrh	r3, [r7, r6]
	bne	.L561
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
.L563:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r7, r6]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	pop	{r4, r5, r6, r7, r8, pc}
.L561:
	cmp	r3, r1
	ldrh	r1, [r4, #2]
	bne	.L564
	cmp	r1, r3
	beq	.L563
	movs	r2, #6
	ldr	r0, [r5]
	muls	r1, r2, r1
	strh	r3, [r0, r1]	@ movhi
	b	.L563
.L564:
	ldr	r0, [r5]
	movs	r2, #6
	mla	r5, r2, r3, r0
	strh	r1, [r5, #2]	@ movhi
	ldrh	r1, [r4, #2]
	muls	r2, r1, r2
	strh	r3, [r0, r2]	@ movhi
	b	.L563
.L566:
	.align	2
.L565:
	.word	.LANCHOR82
	.word	.LANCHOR91
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
	cbz	r3, .L573
	ldr	r2, .L574
	movw	r5, #65535
	movs	r6, #6
	ldr	r2, [r2]
.L569:
	cbnz	r1, .L570
.L572:
	ldr	r4, .L574+4
	subs	r3, r3, r2
	asrs	r3, r3, #1
	muls	r4, r3, r4
	uxth	r1, r4
	bl	List_remove_node
	uxth	r0, r4
	pop	{r4, r5, r6, pc}
.L570:
	ldrh	r4, [r3]
	cmp	r4, r5
	beq	.L572
	subs	r1, r1, #1
	mla	r3, r6, r4, r2
	uxth	r1, r1
	b	.L569
.L573:
	movw	r0, #65535
	pop	{r4, r5, r6, pc}
.L575:
	.align	2
.L574:
	.word	.LANCHOR82
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
	ldr	r3, .L582
	push	{r4, lr}
	ldr	r3, [r3]
	cbz	r3, .L581
	ldr	r2, .L582+4
	movs	r4, #6
	ldr	r1, [r2]
	movw	r2, #65535
.L578:
	cbz	r0, .L579
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L580
.L581:
	movw	r0, #65535
	pop	{r4, pc}
.L580:
	subs	r0, r0, #1
	mla	r3, r4, r3, r1
	uxth	r0, r0
	b	.L578
.L579:
	ldr	r0, .L582+8
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r0, r3
	uxth	r0, r3
	pop	{r4, pc}
.L583:
	.align	2
.L582:
	.word	.LANCHOR83
	.word	.LANCHOR82
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
	ldr	r3, .L595
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L586
	ldr	r3, .L595+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L586
	ldr	r3, .L595+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L586
	ldr	r7, .L595+12
	movs	r6, #6
	ldr	r3, .L595+16
	muls	r6, r0, r6
	ldr	fp, [r7]
	ldr	r3, [r3]
	add	r10, fp, r6
	cmp	r10, r3
	beq	.L586
	ldr	r3, .L595+20
	ldrh	r5, [r10, #4]
	ldr	r2, [r3]
	mov	r8, r3
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r5, #0
	beq	.L593
	muls	r5, r2, r5
.L588:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L589
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	bne	.L589
	ldr	r1, .L595+24
	mov	r2, #504
	ldr	r0, .L595+28
	bl	printf
	ldr	r1, .L595+32
	ldr	r0, .L595+36
	bl	printf
.L589:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L590
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	beq	.L586
.L590:
	movs	r2, #6
	muls	r2, r3, r2
	ldr	r3, .L595+40
	asrs	r1, r2, #1
	muls	r3, r1, r3
	ldr	r1, [r8]
	ldrh	r0, [r1, r3, lsl #1]
	ldr	r1, [r7]
	add	r2, r2, r1
	ldrh	r3, [r2, #4]
	cbz	r3, .L594
	muls	r3, r0, r3
.L591:
	cmp	r5, r3
	bcs	.L586
	ldr	r5, .L595+44
	mov	r1, r4
	ldr	r0, .L595+16
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L592
	ldr	r1, .L595+24
	movw	r2, #515
	ldr	r0, .L595+28
	bl	printf
	ldr	r1, .L595+32
	ldr	r0, .L595+36
	bl	printf
.L592:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	INSERT_DATA_LIST
.L586:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L593:
	mov	r5, #-1
	b	.L588
.L594:
	mov	r3, #-1
	b	.L591
.L596:
	.align	2
.L595:
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR82
	.word	.LANCHOR83
	.word	.LANCHOR84
	.word	.LANCHOR95
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	-1431655765
	.word	.LANCHOR86
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
.L598:
	uxth	r5, r3
	cmp	r5, r1
	bcs	.L601
	mov	r7, r2
	adds	r3, r3, #1
	ldrh	r6, [r7]
	adds	r2, r2, #2
	cmp	r6, #0
	bne	.L598
	bl	FtlFreeSysBlkQueueOut
	subs	r3, r0, #1
	movw	r2, #65533
	uxth	r3, r3
	mov	r1, r0
	strh	r0, [r7]	@ movhi
	cmp	r3, r2
	bls	.L599
	ldr	r3, .L605
	ldr	r0, .L605+4
	ldrh	r2, [r3, #6]
	bl	printf
.L600:
	b	.L600
.L599:
	ldr	r3, [r4, #28]
	strh	r6, [r4, #2]	@ movhi
	strh	r5, [r4]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #28]
	ldrh	r3, [r4, #8]
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
.L601:
	ldrh	r3, [r4, #10]
	cmp	r3, r5
	bhi	.L603
	ldr	r1, .L605+8
	movw	r2, #629
	ldr	r0, .L605+12
	bl	printf
	ldr	r1, .L605+16
	ldr	r0, .L605+20
	bl	printf
.L603:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L606:
	.align	2
.L605:
	.word	.LANCHOR76
	.word	.LC8
	.word	.LANCHOR96
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
	ldr	r3, .L617
	movs	r0, #12
	movw	r5, #65535
	ldrh	r2, [r3]
	ldr	r3, .L617+4
	ldr	r3, [r3]
.L608:
	uxth	r4, r1
	cmp	r4, r2
	bcc	.L610
	mov	r4, r2
	movs	r1, #0
	mov	r6, #-2147483648
	movs	r7, #12
.L611:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L613
	cmp	r4, r2
	bcc	.L609
	ldr	r1, .L617+8
	mov	r4, r2
	mov	r0, #-1
	ldrh	r7, [r1]
	movs	r1, #0
.L614:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L616
	cmp	r4, r2
	bcc	.L609
	movw	r2, #855
	ldr	r1, .L617+12
	ldr	r0, .L617+16
	bl	printf
	ldr	r1, .L617+20
	ldr	r0, .L617+24
	bl	printf
	b	.L609
.L610:
	adds	r1, r1, #1
	mla	r6, r0, r1, r3
	ldrh	r6, [r6, #-12]
	cmp	r6, r5
	bne	.L608
.L609:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L613:
	mla	r0, r7, r1, r3
	ldr	r0, [r0, #4]
	cmp	r0, #0
	blt	.L612
	cmp	r6, r0
	itt	hi
	movhi	r6, r0
	movhi	r4, r5
.L612:
	adds	r1, r1, #1
	b	.L611
.L616:
	ldr	r6, [r3, #4]
	cmp	r0, r6
	bls	.L615
	ldrh	ip, [r3]
	cmp	ip, r7
	itt	ne
	movne	r0, r6
	movne	r4, r5
.L615:
	adds	r1, r1, #1
	adds	r3, r3, #12
	b	.L614
.L618:
	.align	2
.L617:
	.word	.LANCHOR68
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LANCHOR99
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
	ldr	r2, .L629
	push	{r4, r5, r6, lr}
	mov	r1, r2
	ldrh	r3, [r2]
	cmp	r3, #4
	bhi	.L620
	cbnz	r0, .L620
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	pop	{r4, r5, r6, pc}
.L620:
	movs	r3, #0
	ldr	r0, .L629+4
	strh	r3, [r1]	@ movhi
	movw	r6, #65535
	ldr	r1, .L629+8
	ldrh	r4, [r0]
	mov	r0, r3
	ldr	r2, .L629+12
	ldr	r1, [r1]
	str	r3, [r2]
	add	r4, r1, r4, lsl #1
.L621:
	cmp	r1, r4
	bne	.L623
	cbz	r3, .L619
	str	r0, [r2]
.L619:
	pop	{r4, r5, r6, pc}
.L623:
	ldrh	r5, [r1], #2
	cmp	r5, r6
	itt	ne
	addne	r0, r0, r5
	movne	r3, #1
	b	.L621
.L630:
	.align	2
.L629:
	.word	.LANCHOR100
	.word	.LANCHOR40
	.word	.LANCHOR84
	.word	.LANCHOR101
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
	cbz	r1, .L632
	b	ftl_set_blk_mode.part.10
.L632:
	ldr	r2, .L633
	lsrs	r0, r0, #5
	and	r3, r3, #31
	ldr	r1, [r2]
	movs	r2, #1
	lsl	r3, r2, r3
	ldr	r2, [r1, r0, lsl #2]
	bic	r2, r2, r3
	str	r2, [r1, r0, lsl #2]
	bx	lr
.L634:
	.align	2
.L633:
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
	ldr	r3, .L636
	lsrs	r2, r0, #5
	and	r0, r0, #31
	ldr	r3, [r3]
	ldr	r3, [r3, r2, lsl #2]
	lsr	r0, r3, r0
	and	r0, r0, #1
	bx	lr
.L637:
	.align	2
.L636:
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
	ldr	r3, .L645
	ldrh	r4, [r3]
	add	r3, r0, r2, lsl #1
	adds	r3, r3, #14
.L639:
	cmp	r2, r4
	bcc	.L641
	ldr	r3, .L645+4
	add	r5, r0, #16
	movw	r6, #65535
	ldrh	r3, [r3]
	subs	r3, r3, #1
	subs	r1, r3, r1
	movs	r3, #0
	uxth	r1, r1
.L642:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L644
	pop	{r4, r5, r6, pc}
.L641:
	ldrh	r5, [r3, #2]!
	adds	r2, r2, #1
	uxth	r2, r2
	cmp	r5, r6
	ittt	ne
	ldrhne	r5, [r0, #4]
	addne	r5, r5, #1
	strhne	r5, [r0, #4]	@ movhi
	b	.L639
.L644:
	ldrh	r2, [r5], #2
	adds	r3, r3, #1
	cmp	r2, r6
	ittt	ne
	ldrhne	r2, [r0, #4]
	addne	r2, r2, r1
	strhne	r2, [r0, #4]	@ movhi
	b	.L642
.L646:
	.align	2
.L645:
	.word	.LANCHOR38
	.word	.LANCHOR53
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
	ldr	r3, .L660
	ldrh	r2, [r0]
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L648
	ldr	r1, .L660+4
	mov	r2, #2544
	ldr	r0, .L660+8
	bl	printf
	ldr	r1, .L660+12
	ldr	r0, .L660+16
	bl	printf
.L648:
	ldr	r3, .L660+20
	add	r6, r4, #16
	ldr	r10, .L660+40
	movw	r7, #65535
	movs	r5, #0
	ldrh	r8, [r3]
	strh	r5, [r4, #4]	@ movhi
	strb	r5, [r4, #7]
.L649:
	uxth	r3, r5
	cmp	r8, r3
	bhi	.L651
	ldr	r2, .L660+24
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #9]
	ldr	r3, .L660+28
	ldr	r3, [r3]
	cbz	r3, .L652
	ldr	r3, .L660+32
	ldrh	r2, [r4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r3, #79
	itt	ls
	movls	r3, #1
	strbls	r3, [r4, #9]
.L652:
	ldr	r3, .L660+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L653
	movs	r3, #1
	strb	r3, [r4, #9]
.L653:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L651:
	ldrh	r1, [r4]
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	strh	r7, [r6]	@ movhi
	mov	fp, r0
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L650
	strh	fp, [r6]	@ movhi
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r4, #7]
.L650:
	adds	r5, r5, #1
	adds	r6, r6, #2
	b	.L649
.L661:
	.align	2
.L660:
	.word	.LANCHOR40
	.word	.LANCHOR102
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR38
	.word	.LANCHOR53
	.word	.LANCHOR28
	.word	.LANCHOR79
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
	ldr	r3, .L668
	mov	r6, r0
	mov	r4, r5
	ldr	r10, .L668+12
	ldrh	r7, [r3]
	ldr	r3, .L668+4
	ldrh	r8, [r3]
.L663:
	uxth	r3, r5
	cmp	r7, r3
	bhi	.L665
	cbz	r4, .L667
	mov	r1, r4
	mov	r0, #32768
	bl	__aeabi_idiv
.L666:
	ldr	r3, .L668+8
	movs	r2, #6
	ldr	r3, [r3]
	mla	r6, r2, r6, r3
	strh	r0, [r6, #4]	@ movhi
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L665:
	mov	r1, r6
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L664
	add	r4, r4, r8
	uxth	r4, r4
.L664:
	adds	r5, r5, #1
	b	.L663
.L667:
	mov	r0, r4
	b	.L666
.L669:
	.align	2
.L668:
	.word	.LANCHOR38
	.word	.LANCHOR53
	.word	.LANCHOR82
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
	ldr	r3, .L673
	ldr	r0, [r3]
	cbz	r0, .L671
	ldr	r3, .L673+4
	ldr	r3, [r3]
	subs	r0, r0, r3
	ldr	r3, .L673+8
	asrs	r0, r0, #1
	muls	r0, r3, r0
	ldr	r3, .L673+12
	ldr	r3, [r3]
	uxth	r0, r0
	ldrh	r0, [r3, r0, lsl #1]
.L671:
	bx	lr
.L674:
	.align	2
.L673:
	.word	.LANCHOR88
	.word	.LANCHOR82
	.word	-1431655765
	.word	.LANCHOR79
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
	ldr	r3, .L683
	push	{r4, r5, r6, lr}
	ldr	r3, [r3]
	cbz	r3, .L681
	ldr	r2, .L683+4
	movs	r5, #6
	movw	r6, #65535
	ldrh	r2, [r2]
	rsb	r2, r2, r2, lsl #3
	asrs	r2, r2, #3
	cmp	r0, r2
	it	gt
	uxthgt	r0, r2
	ldr	r2, .L683+8
	ldr	r1, [r2]
	ldr	r2, .L683+12
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r2, r3
	movs	r2, #0
	uxth	r3, r3
.L678:
	uxth	r4, r2
	cmp	r0, r4
	bls	.L680
	mul	r4, r5, r3
	adds	r2, r2, #1
	ldrh	r4, [r1, r4]
	cmp	r4, r6
	bne	.L682
.L680:
	ldr	r2, .L683+16
	ldr	r2, [r2]
	ldrh	r0, [r2, r3, lsl #1]
	pop	{r4, r5, r6, pc}
.L682:
	mov	r3, r4
	b	.L678
.L681:
	mov	r0, r3
	pop	{r4, r5, r6, pc}
.L684:
	.align	2
.L683:
	.word	.LANCHOR88
	.word	.LANCHOR89
	.word	.LANCHOR82
	.word	-1431655765
	.word	.LANCHOR79
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
	beq	.L686
	ldr	r2, .L687
	movs	r1, #0
	ldr	r2, [r2]
	strh	r1, [r2, r0, lsl #1]	@ movhi
	bl	INSERT_FREE_LIST
.L686:
	movs	r0, #0
	pop	{r3, pc}
.L688:
	.align	2
.L687:
	.word	.LANCHOR84
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
	ldr	r1, .L694
	mov	fp, #1
	ldr	r2, .L694+4
	ldr	r5, [r1]
	ldr	r1, .L694+8
	str	r3, [r2]
	ldr	r2, .L694+12
	mov	r0, r5
	ldr	r1, [r1]
	ldrh	r2, [r2]
	str	r1, [sp, #4]
	ldr	r1, .L694+16
	ldrh	r1, [r1]
	str	r1, [sp]
	ldr	r1, .L694+20
	ldr	r10, [r1]
	ldr	r1, .L694+24
	ldrh	r7, [r1]
	ldr	r1, .L694+28
	ldr	r4, [r1]
	movs	r1, #12
	mla	r1, r2, r1, r1
	adds	r4, r4, #8
	add	r8, r5, r1
	mov	r1, r3
.L690:
	adds	r0, r0, #12
	ldr	r6, [sp]
	cmp	r0, r8
	add	ip, r3, r7
	add	r4, r4, #36
	add	lr, r1, r6
	bne	.L691
	ldr	r3, .L694+32
	mov	lr, #12
	mov	r8, #0
	ldr	r0, [r3]
	ldr	r3, .L694+8
	ldr	r4, [r3]
	ldr	r3, .L694+20
	ldr	ip, [r3]
.L692:
	cmp	r2, r0
	bcc	.L693
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L691:
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
	b	.L690
.L693:
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
	b	.L692
.L695:
	.align	2
.L694:
	.word	.LANCHOR104
	.word	.LANCHOR103
	.word	.LANCHOR105
	.word	.LANCHOR38
	.word	.LANCHOR58
	.word	.LANCHOR106
	.word	.LANCHOR59
	.word	.LANCHOR107
	.word	.LANCHOR108
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
	ldr	r3, .L703
	mov	ip, #12
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	mov	fp, #36
	mov	lr, r4
	ldr	r7, [r3]
	ldr	r3, .L703+4
	ldr	r5, [r3]
.L697:
	uxth	r3, r4
	cmp	r1, r3
	bls	.L696
	mla	r8, fp, r3, r0
	movs	r2, #0
.L698:
	uxth	r3, r2
	cmp	r7, r3
	bls	.L699
	mul	r3, ip, r3
	ldr	r6, [r8, #8]
	adds	r2, r2, #1
	add	r10, r5, r3
	ldr	r3, [r5, r3]
	cmp	r3, r6
	bne	.L698
	str	lr, [r10, #8]
.L699:
	adds	r4, r4, #1
	b	.L697
.L696:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L704:
	.align	2
.L703:
	.word	.LANCHOR108
	.word	.LANCHOR104
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
	ldr	r3, .L712
	movs	r2, #0
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	ip, #12
	movs	r7, #1
	mov	lr, #36
	ldr	r4, [r3]
	ldr	r3, .L712+4
	ldr	r5, [r3]
.L706:
	uxth	r8, r2
	cmp	r1, r8
	bhi	.L710
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L710:
	mov	r10, #0
.L707:
	uxth	r3, r10
	cmp	r4, r3
	bls	.L708
	mla	r3, ip, r3, r5
	add	r10, r10, #1
	ldr	r6, [r3, #8]
	cmp	r6, #0
	bne	.L707
	mla	r8, lr, r8, r0
	str	r7, [r3, #8]
	ldr	r6, [r3]
	ldr	r3, [r3, #4]
	str	r6, [r8, #8]
	str	r3, [r8, #12]
.L708:
	adds	r2, r2, #1
	b	.L706
.L713:
	.align	2
.L712:
	.word	.LANCHOR108
	.word	.LANCHOR104
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
	ldr	r3, .L719
	ldr	r2, .L719+4
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L715:
	cmp	r3, r2
	bne	.L717
	movs	r0, #0
	bx	lr
.L717:
	ldrh	r1, [r3], #2
	cmp	r1, r0
	bne	.L715
	movs	r0, #1
	bx	lr
.L720:
	.align	2
.L719:
	.word	.LANCHOR109
	.word	.LANCHOR110
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
	ldr	r4, .L725
	ubfx	r0, r0, #10, #16
	mov	r6, r1
	mov	r7, r2
	bl	P2V_block_in_plane
	ldr	r3, .L725+4
	ldrh	r1, [r4]
	ldr	r2, [r3]
	movs	r3, #0
.L722:
	uxth	ip, r3
	cmp	ip, r1
	bcc	.L724
	bne	.L723
	strh	r0, [r2, ip, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L723
.L724:
	adds	r3, r3, #1
	add	ip, r2, r3, lsl #1
	ldrh	ip, [ip, #-2]
	cmp	ip, r0
	bne	.L722
.L723:
	ldr	r2, .L725+8
	movs	r0, #12
	ldr	r1, .L725+12
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
.L726:
	.align	2
.L725:
	.word	.LANCHOR110
	.word	.LANCHOR109
	.word	.LANCHOR111
	.word	.LANCHOR112
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
	ldr	ip, .L732+12
	push	{r4, r5, r6, r7, lr}
	ldrh	lr, [ip]
	cmp	lr, r0
	beq	.L728
	ldr	r6, .L732
	ldrh	r7, [r6]
	cmp	r0, r7
	beq	.L728
	ldr	r4, .L732+4
	ldrh	r5, [r4]
	cmp	r0, r5
	beq	.L728
	ldr	r2, .L732+8
	ldrh	r1, [r2]
	cmp	r0, r1
	beq	.L728
	movw	r3, #65535
	cmp	lr, r3
	bne	.L729
	strh	r0, [ip]	@ movhi
.L728:
	movs	r0, #0
	pop	{r4, r5, r6, r7, pc}
.L729:
	cmp	r7, r3
	bne	.L730
	strh	r0, [r6]	@ movhi
	b	.L728
.L730:
	cmp	r5, r3
	bne	.L731
	strh	r0, [r4]	@ movhi
	b	.L728
.L731:
	cmp	r1, r3
	it	eq
	strheq	r0, [r2]	@ movhi
	b	.L728
.L733:
	.align	2
.L732:
	.word	.LANCHOR114
	.word	.LANCHOR115
	.word	.LANCHOR116
	.word	.LANCHOR113
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
	ldr	ip, .L744+12
	push	{r4, r5, r6, r7, lr}
	ldrh	lr, [ip]
	cmp	lr, r0
	beq	.L742
	ldr	r6, .L744
	ldrh	r7, [r6]
	cmp	r0, r7
	beq	.L742
	ldr	r4, .L744+4
	ldrh	r5, [r4]
	cmp	r0, r5
	beq	.L742
	ldr	r2, .L744+8
	ldrh	r1, [r2]
	cmp	r0, r1
	beq	.L742
	movw	r3, #65535
	cmp	lr, r3
	bne	.L736
	strh	r0, [ip]	@ movhi
.L742:
	movs	r0, #0
	pop	{r4, r5, r6, r7, pc}
.L736:
	cmp	r7, r3
	bne	.L737
	strh	r0, [r6]	@ movhi
	b	.L742
.L737:
	cmp	r5, r3
	bne	.L738
	strh	r0, [r4]	@ movhi
	b	.L742
.L738:
	cmp	r1, r3
	bne	.L743
	strh	r0, [r2]	@ movhi
	b	.L742
.L743:
	mov	r0, #-1
	pop	{r4, r5, r6, r7, pc}
.L745:
	.align	2
.L744:
	.word	.LANCHOR114
	.word	.LANCHOR115
	.word	.LANCHOR116
	.word	.LANCHOR113
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
	ldr	r3, .L754
	ldr	r3, [r3]
	cbz	r3, .L747
	ldr	r3, .L754+4
	ldr	r2, [r3]
	ldrh	r3, [r2, r5, lsl #1]
	cmp	r3, #39
	itt	hi
	subhi	r3, r3, #40
	strhhi	r3, [r2, r5, lsl #1]	@ movhi
.L747:
	ldr	r2, .L754+8
	movs	r1, #0
	ldr	r5, .L754+12
	ldrh	r3, [r2]
.L748:
	uxth	r0, r1
	cmp	r3, r0
	bhi	.L750
	cmp	r3, #15
	itttt	ls
	addls	r1, r3, #1
	strhls	r1, [r2]	@ movhi
	ldrls	r2, .L754+12
	strhls	r4, [r2, r3, lsl #1]	@ movhi
	b	.L749
.L750:
	adds	r1, r1, #1
	add	r0, r5, r1, lsl #1
	ldrh	r0, [r0, #-2]
	cmp	r0, r4
	bne	.L748
.L749:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L755:
	.align	2
.L754:
	.word	.LANCHOR28
	.word	.LANCHOR79
	.word	.LANCHOR117
	.word	.LANCHOR118
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
	ldr	r3, .L762
	push	{r4, lr}
	ldrh	r3, [r3]
	cbz	r3, .L757
	ldr	r2, .L762+4
	ldrh	r1, [r2]
	movw	r2, #65535
	cmp	r1, r2
	bne	.L757
	ldr	r4, .L762+8
	ldrh	r2, [r4]
	cmp	r2, r3
	itt	cs
	movcs	r3, #0
	strhcs	r3, [r4]	@ movhi
	ldr	r3, .L762+12
	ldrh	r2, [r4]
	ldrh	r0, [r3, r2, lsl #1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
.L757:
	movs	r0, #0
	pop	{r4, pc}
.L763:
	.align	2
.L762:
	.word	.LANCHOR117
	.word	.LANCHOR113
	.word	.LANCHOR119
	.word	.LANCHOR118
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
	ldr	r3, .L766
	ldr	r2, [r3]
	ldr	r3, .L766+4
	cmp	r2, r3
	bne	.L764
	b	flash_enter_slc_mode
.L764:
	bx	lr
.L767:
	.align	2
.L766:
	.word	.LANCHOR29
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
	ldr	r3, .L770
	ldr	r2, [r3]
	ldr	r3, .L770+4
	cmp	r2, r3
	bne	.L768
	b	flash_exit_slc_mode
.L768:
	bx	lr
.L771:
	.align	2
.L770:
	.word	.LANCHOR29
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
	ldr	r3, .L773
	push	{r4, lr}
	mov	r4, r0
	movs	r0, #0
	ldr	r3, [r3]
	ldrb	r1, [r3, #9]	@ zero_extendqisi2
	bl	flash_boot_enter_slc_mode
	mov	r0, r4
	bl	__aeabi_uidiv
	movs	r2, #0
	mov	r1, r0
	mov	r0, r2
	bl	FlashEraseBlock
	mov	r1, r0
	movs	r0, #0
	bl	flash_boot_exit_slc_mode
	uxtb	r0, r1
	pop	{r4, pc}
.L774:
	.align	2
.L773:
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
	cbnz	r0, .L777
	ldr	r3, .L814
.L778:
	strh	r0, [r3, r0, lsl #1]	@ movhi
	adds	r0, r0, #1
	cmp	r0, #256
	bne	.L778
.L784:
	movs	r1, #255
	mov	r2, #1024
	ldr	r0, .L814+4
	uxth	r4, r4
	bl	ftl_memset
	ldr	r1, .L814
	movs	r3, #0
	ldr	r0, .L814+4
.L779:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L801
	pop	{r4, pc}
.L777:
	cmp	r0, #1
	bne	.L780
	ldr	r1, .L814
	movs	r3, #0
.L783:
	cmp	r3, #3
	uxth	r2, r3
	bls	.L781
	tst	r2, #1
	ite	ne
	movne	r0, #3
	moveq	r0, #2
	rsb	r2, r0, r2, lsl #1
	uxth	r2, r2
.L781:
	strh	r2, [r1, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L783
	b	.L784
.L780:
	cmp	r0, #2
	bne	.L785
	ldr	r1, .L814
	movs	r2, #0
.L787:
	uxth	r3, r2
	cmp	r2, #1
	ittt	hi
	lslhi	r3, r3, #1
	addhi	r3, r3, #-1
	uxthhi	r3, r3
	strh	r3, [r1, r2, lsl #1]	@ movhi
	adds	r2, r2, #1
	cmp	r2, #256
	bne	.L787
	b	.L784
.L785:
	cmp	r0, #3
	bne	.L788
	ldr	r1, .L814
	movs	r3, #0
.L791:
	cmp	r3, #5
	uxth	r2, r3
	bls	.L789
	tst	r2, #1
	ite	ne
	movne	r0, #5
	moveq	r0, #4
	rsb	r2, r0, r2, lsl #1
	uxth	r2, r2
.L789:
	strh	r2, [r1, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L791
	b	.L784
.L788:
	cmp	r0, #4
	mov	r3, #0
	bne	.L792
	ldr	r2, .L814
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
.L794:
	tst	r3, #1
	ite	ne
	movne	r1, #7
	moveq	r1, #6
	rsb	r1, r1, r3, lsl #1
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r1, [r2, #2]!	@ movhi
	cmp	r3, #256
	bne	.L794
	b	.L784
.L792:
	cmp	r0, #5
	bne	.L795
	ldr	r2, .L814
.L796:
	strh	r3, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #16
	bne	.L796
	ldr	r2, .L814+8
.L797:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, #496
	bne	.L797
	b	.L784
.L795:
	cmp	r0, #6
	bne	.L784
	ldr	r0, .L814
	mov	r1, r3
.L800:
	cmp	r1, #5
	uxth	r2, r1
	bls	.L798
	tst	r2, #1
	ite	ne
	movne	r2, #12
	moveq	r2, #10
	subs	r2, r3, r2
	uxth	r2, r2
.L798:
	strh	r2, [r0, r1, lsl #1]	@ movhi
	adds	r1, r1, #1
	cmp	r1, #256
	add	r3, r3, #3
	uxth	r3, r3
	bne	.L800
	b	.L784
.L801:
	ldrh	r2, [r1, r3, lsl #1]
	adds	r3, r3, #1
	strh	r2, [r0, r2, lsl #1]	@ movhi
	b	.L779
.L815:
	.align	2
.L814:
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
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r3, #0
	ldr	r2, .L834
	ldr	r4, .L834+4
	strb	r3, [r2]
	str	r2, [sp]
	strb	r3, [r4]
	ldr	r3, .L834+8
	ldr	r7, .L834+12
	ldrh	r3, [r3, #10]
	cmp	r3, #256
	bls	.L817
	mov	r3, #512
.L833:
	movs	r2, #8
	movs	r1, #0
	ldr	r0, .L834+16
	movs	r6, #0
	str	r3, [r7]
	bl	ftl_memset
	movs	r2, #32
	movs	r1, #0
	ldr	r0, .L834+20
	bl	ftl_memset
	movs	r2, #128
	movs	r1, #0
	ldr	r0, .L834+24
	bl	ftl_memset
	ldr	r3, .L834+28
	ldr	fp, .L834+36
	ldr	r5, [r3]
	ldr	r3, .L834+16
	ldrb	r10, [r5]	@ zero_extendqisi2
	add	r8, r5, #1
.L821:
	mov	r2, r10
	add	r1, fp, r6, lsl #3
	mov	r0, r8
	str	r3, [sp, #4]
	bl	FlashMemCmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L820
	ldrb	r2, [r4]	@ zero_extendqisi2
	ldr	r1, .L834+20
	strb	r6, [r3, r2]
	str	r0, [r1, r2, lsl #2]
	adds	r1, r2, #1
	strb	r1, [r4]
.L820:
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L821
	ldrb	r3, [r4]	@ zero_extendqisi2
	ldr	r2, [sp]
	strb	r3, [r2]
	ldrb	r3, [r5, #8]	@ zero_extendqisi2
	cmp	r3, #2
	beq	.L822
.L826:
	ldrh	r2, [r5, #14]
	ldrb	r3, [r4]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldrb	r2, [r5, #13]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldr	r2, .L834+32
	strh	r3, [r2]	@ movhi
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L817:
	cmp	r3, #128
	it	hi
	movhi	r3, #256
	b	.L833
.L822:
	ldr	fp, [r7]
	movs	r6, #0
	ldr	r7, .L834+20
	ldr	r3, .L834+16
.L825:
	str	r3, [sp]
	mov	r2, r10
	ldr	r3, .L834+36
	mov	r0, r8
	add	r1, r3, r6, lsl #3
	bl	FlashMemCmp8
	ldr	r3, [sp]
	cbnz	r0, .L823
	ldrh	r2, [r5, #14]
	ldrb	r1, [r4]	@ zero_extendqisi2
	and	r0, r2, #65280
	ldrb	r2, [r5, #13]	@ zero_extendqisi2
	mul	r2, fp, r2
	muls	r2, r0, r2
	str	r2, [r7, r1, lsl #2]
	ldrb	r0, [r5, #23]	@ zero_extendqisi2
	cbz	r0, .L824
	lsls	r2, r2, #1
	str	r2, [r7, r1, lsl #2]
.L824:
	adds	r2, r1, #1
	strb	r6, [r3, r1]
	strb	r2, [r4]
.L823:
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L825
	b	.L826
.L835:
	.align	2
.L834:
	.word	.LANCHOR121
	.word	.LANCHOR25
	.word	.LANCHOR31
	.word	.LANCHOR3
	.word	.LANCHOR26
	.word	.LANCHOR17
	.word	.LANCHOR23
	.word	.LANCHOR18
	.word	.LANCHOR122
	.word	.LANCHOR22
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
	ldr	r3, .L839
	movs	r2, #0
	ldr	r1, [r3]
	ldr	r3, .L839+4
	ldrb	r0, [r1, #9]	@ zero_extendqisi2
	ldr	r3, [r3]
	smulbb	r3, r3, r0
	uxth	r3, r3
	strb	r3, [r4, #4]
	lsrs	r3, r3, #8
	strb	r3, [r4, #5]
	ldr	r3, .L839+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r4, #7]
	ldr	r3, .L839+12
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
	ldr	r0, .L839+16
	strb	r2, [r4, #10]
	strb	r3, [r4, #9]
	ldr	r3, .L839+20
	ldrb	r1, [r3]	@ zero_extendqisi2
	mov	r3, r2
.L837:
	uxtb	r2, r3
	cmp	r1, r2
	bhi	.L838
	pop	{r4, r5, r6, pc}
.L838:
	ldrb	r2, [r3, r0]	@ zero_extendqisi2
	adds	r3, r3, #1
	ldrb	r6, [r4, #10]	@ zero_extendqisi2
	lsl	r2, r5, r2
	orrs	r2, r2, r6
	strb	r2, [r4, #10]
	b	.L837
.L840:
	.align	2
.L839:
	.word	.LANCHOR18
	.word	.LANCHOR3
	.word	.LANCHOR33
	.word	.LANCHOR69
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
	ldr	r3, .L847
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, r0
	ldr	r7, .L847+4
	mov	r6, r1
	subs	r4, r5, #2
	addw	r5, r5, #1022
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r8, .L847+20
	mov	r0, r6
	lsls	r2, r2, #2
	bl	ftl_memset
.L844:
	ldrh	r3, [r4, #2]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L841
	ldrh	r2, [r7]
	cmp	r2, r3
	bhi	.L843
	mov	r1, r8
	movs	r2, #79
	ldr	r0, .L847+8
	bl	printf
	ldr	r1, .L847+12
	ldr	r0, .L847+16
	bl	printf
.L843:
	ldrh	r3, [r4, #2]!
	movs	r2, #1
	cmp	r5, r4
	lsr	r1, r3, #5
	and	r3, r3, #31
	lsl	r3, r2, r3
	ldr	r2, [r6, r1, lsl #2]
	orr	r2, r2, r3
	str	r2, [r6, r1, lsl #2]
	bne	.L844
.L841:
	pop	{r4, r5, r6, r7, r8, pc}
.L848:
	.align	2
.L847:
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
	ldr	r0, .L850
	movw	r3, #65535
	movs	r2, #16
	movs	r1, #255
	strh	r3, [r0]	@ movhi
	movs	r3, #0
	strh	r3, [r0, #6]	@ movhi
	adds	r0, r0, #12
	b	ftl_memset
.L851:
	.align	2
.L850:
	.word	.LANCHOR75
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
	ldr	r3, .L853
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
.L854:
	.align	2
.L853:
	.word	.LANCHOR76
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
.L856:
	ldrh	r1, [r4, #6]
	uxth	r2, r3
	cmp	r1, r2
	bhi	.L860
	ldr	r3, .L875
	movs	r6, #0
	mov	r10, r6
	ldrh	r2, [r3]
	ldrh	r3, [r4]
	strh	r2, [r5, r3, lsl #1]	@ movhi
	mov	r2, r6
	ldrh	fp, [r5]
.L861:
	ldrh	r3, [r4, #10]
	uxth	ip, r6
	cmp	r3, ip
	bhi	.L865
	mov	r0, r10
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L860:
	uxth	r2, r3
	ldr	r1, [r6, r2, lsl #2]
	movs	r2, #0
	ubfx	r1, r1, #10, #16
.L857:
	ldrh	ip, [r4, #10]
	uxth	r0, r2
	cmp	ip, r0
	bhi	.L859
	adds	r3, r3, #1
	b	.L856
.L859:
	uxth	r0, r2
	ldrh	ip, [r7, r0, lsl #1]
	cmp	ip, r1
	bne	.L858
	cbz	r1, .L858
	ldrh	ip, [r5, r0, lsl #1]
	add	ip, ip, #1
	strh	ip, [r5, r0, lsl #1]	@ movhi
.L858:
	adds	r2, r2, #1
	b	.L857
.L865:
	uxth	r1, r6
	ldrh	r3, [r5, r1, lsl #1]
	lsl	r8, r1, #1
	cmp	fp, r3
	bls	.L862
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cbnz	r0, .L863
.L864:
	adds	r6, r6, #1
	b	.L861
.L862:
	cmp	r3, #0
	bne	.L864
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cmp	r0, #0
	beq	.L864
.L866:
	movs	r1, #1
	str	r2, [sp, #4]
	bl	FtlFreeSysBlkQueueIn
	ldr	r2, [sp, #4]
	strh	r2, [r8]	@ movhi
	ldrh	r3, [r4, #8]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	b	.L864
.L863:
	mov	r10, ip
	mov	fp, r3
	cmp	r3, #0
	beq	.L866
	b	.L864
.L876:
	.align	2
.L875:
	.word	.LANCHOR54
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
	ldr	r5, .L880
	ldr	r4, .L880+4
	ldr	r2, [r5]
	ldr	r7, .L880+8
	ldr	r6, .L880+12
	ldr	r0, [r4]
	lsls	r2, r2, #1
	ldr	r8, .L880+44
	bl	ftl_memset
	ldrh	r3, [r7]
	movs	r1, #255
	ldrh	r2, [r6]
	ldr	r0, [r8]
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L880+16
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
.L878:
	adds	r2, r2, #12
	adds	r6, r3, r7
	cmp	r2, r1
	bne	.L879
	ldr	r3, .L880+20
	ldr	r2, [r5]
	strh	r0, [r3, #2]	@ movhi
	strh	r2, [r3, #10]	@ movhi
	movw	r2, #61634
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L880+24
	strh	r0, [r3]	@ movhi
	ldrh	r2, [r2]
	strh	r2, [r3, #8]	@ movhi
	ldr	r2, .L880+28
	ldrh	r2, [r2]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, .L880+32
	ldr	r2, [r2]
	str	r2, [r3, #12]
	ldr	r2, .L880+36
	ldr	r2, [r2]
	str	r2, [r3, #16]
	ldr	r2, [r4]
	str	r2, [r3, #20]
	ldr	r2, .L880+40
	ldr	r2, [r2]
	str	r2, [r3, #24]
	pop	{r4, r5, r6, r7, r8, pc}
.L879:
	bic	r3, r3, #3
	str	lr, [r2, #-8]
	add	r3, r3, ip
	strh	r0, [r2, #-12]	@ movhi
	str	r3, [r2, #-4]
	mov	r3, r6
	b	.L878
.L881:
	.align	2
.L880:
	.word	.LANCHOR65
	.word	.LANCHOR125
	.word	.LANCHOR58
	.word	.LANCHOR68
	.word	.LANCHOR97
	.word	.LANCHOR127
	.word	.LANCHOR128
	.word	.LANCHOR67
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
	ldr	r3, .L883
	movw	r2, #65535
	mov	r1, r4
	ldr	r5, .L883+4
	str	r4, [r3]
	ldr	r3, .L883+8
	strh	r2, [r3]	@ movhi
	mov	r2, #-1
	ldr	r3, .L883+12
	str	r4, [r3]
	ldr	r3, .L883+16
	str	r4, [r3]
	ldr	r3, .L883+20
	str	r2, [r3]
	ldr	r3, .L883+24
	str	r4, [r3]
	ldr	r3, .L883+28
	strh	r4, [r3]	@ movhi
	ldr	r3, .L883+32
	ldrh	r2, [r3]
	ldr	r3, .L883+36
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L883+40
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L883+44
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	mov	r1, r4
	movs	r2, #48
	ldr	r0, .L883+48
	bl	ftl_memset
	mov	r2, #512
	mov	r1, r4
	ldr	r0, .L883+52
	bl	ftl_memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L884:
	.align	2
.L883:
	.word	.LANCHOR132
	.word	.LANCHOR41
	.word	.LANCHOR133
	.word	.LANCHOR134
	.word	.LANCHOR135
	.word	.LANCHOR136
	.word	.LANCHOR28
	.word	.LANCHOR71
	.word	.LANCHOR62
	.word	.LANCHOR72
	.word	.LANCHOR79
	.word	.LANCHOR137
	.word	.LANCHOR81
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
	ldr	r3, .L896
	movs	r2, #6
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r1, #0
	ldr	r6, .L896+4
	sub	sp, sp, #24
	movs	r4, #0
	ldrh	r3, [r3]
	mov	r8, r4
	ldr	r0, [r6]
	mov	r5, r4
	mov	r10, r6
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L896+8
	ldr	r2, .L896+12
	ldr	r1, .L896+16
	str	r4, [r3]
	ldr	r3, .L896+20
	strh	r4, [r2]	@ movhi
	strh	r4, [r1]	@ movhi
	str	r4, [r3]
	ldr	r3, .L896+24
	str	r2, [sp, #8]
	str	r4, [r3]
	ldr	r3, .L896+28
	mov	fp, r3
	strh	r4, [r3]	@ movhi
.L886:
	ldr	r3, .L896+32
	sxth	r7, r4
	ldrh	r3, [r3]
	cmp	r7, r3
	bge	.L893
	ldr	r3, .L896+36
	uxth	r1, r4
	str	r1, [sp, #12]
	ldrh	r2, [r3]
	ldr	r3, .L896+40
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r6, r3
	b	.L894
.L888:
	str	r3, [sp, #20]
	ldr	r3, .L896+44
	ldr	r1, [sp, #12]
	str	r2, [sp, #16]
	ldrb	r0, [r3, r0]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #20]
	cbnz	r0, .L887
	ldr	r1, [sp, #4]
	add	r6, r6, r1
	sxth	r6, r6
.L887:
	adds	r3, r3, #1
.L894:
	sxth	r0, r3
	cmp	r0, r2
	blt	.L888
	lsls	r3, r7, #1
	cbz	r6, .L889
	mov	r1, r6
	str	r3, [sp, #4]
	mov	r0, #32768
	bl	__aeabi_idiv
	ldr	r3, [sp, #4]
	sxth	r6, r0
.L890:
	ldr	r2, [r10]
	add	r3, r3, r7
	add	r2, r2, r3, lsl #1
	ldr	r3, .L896+48
	strh	r6, [r2, #4]	@ movhi
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L891
	ldr	r3, .L896+52
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L891
	ldr	r3, .L896+56
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L891
	ldr	r3, .L896+60
	uxth	r0, r4
	ldr	r3, [r3]
	ldrh	r3, [r3, r7, lsl #1]
	cbnz	r3, .L892
	add	r8, r8, #1
	uxth	r8, r8
	bl	INSERT_FREE_LIST
.L891:
	adds	r4, r4, #1
	b	.L886
.L889:
	ldr	r2, .L896+60
	movw	r1, #65535
	ldr	r2, [r2]
	strh	r1, [r2, r7, lsl #1]	@ movhi
	b	.L890
.L892:
	adds	r5, r5, #1
	uxth	r5, r5
	bl	INSERT_DATA_LIST
	b	.L891
.L893:
	ldr	r2, [sp, #8]
	strh	r8, [fp]	@ movhi
	strh	r5, [r2]	@ movhi
	add	r5, r5, r8
	cmp	r3, r5
	bge	.L895
	ldr	r1, .L896+64
	movw	r2, #2614
	ldr	r0, .L896+68
	bl	printf
	ldr	r1, .L896+72
	ldr	r0, .L896+76
	bl	printf
.L895:
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L897:
	.align	2
.L896:
	.word	.LANCHOR41
	.word	.LANCHOR82
	.word	.LANCHOR88
	.word	.LANCHOR86
	.word	.LANCHOR139
	.word	.LANCHOR83
	.word	.LANCHOR85
	.word	.LANCHOR89
	.word	.LANCHOR40
	.word	.LANCHOR38
	.word	.LANCHOR53
	.word	.LANCHOR47
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR84
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
	ldr	r2, .L899
	movs	r3, #0
	push	{r4, lr}
	movs	r1, #255
	ldr	r4, .L899+4
	strh	r3, [r2]	@ movhi
	ldr	r2, .L899+8
	strh	r3, [r2]	@ movhi
	ldrh	r2, [r4]
	ldr	r3, .L899+12
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r2, #12
	movs	r1, #255
	muls	r2, r3, r2
	ldr	r3, .L899+16
	ldr	r0, [r3]
	bl	ftl_memset
	pop	{r4, lr}
	b	FtlGcBufInit
.L900:
	.align	2
.L899:
	.word	.LANCHOR110
	.word	.LANCHOR55
	.word	.LANCHOR111
	.word	.LANCHOR109
	.word	.LANCHOR112
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
	ldr	r0, .L902
	bl	ftl_memset
	movs	r0, #0
	pop	{r3, pc}
.L903:
	.align	2
.L902:
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
	ldr	r1, .L906
	bl	ftl_memcpy
	movs	r0, #0
	pop	{r3, pc}
.L907:
	.align	2
.L906:
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
	ldr	r7, .L916
	ldr	r5, .L916+4
.L911:
	ldrb	r2, [r7, #-1]	@ zero_extendqisi2
	mov	r1, r5
	mov	r0, r7
	lsl	r8, r6, #5
	bl	FlashMemCmp8
	mov	r4, r0
	cbnz	r0, .L909
	ldr	r5, .L916+8
	mov	r3, r4
	ldr	r2, .L916+12
	add	r5, r5, r8
	ldrb	r0, [r5, #22]	@ zero_extendqisi2
	mov	r1, r2
.L910:
	lsls	r6, r3, #5
	ldrb	r6, [r6, r2]	@ zero_extendqisi2
	cmp	r6, r0
	beq	.L913
	adds	r3, r3, #1
	cmp	r3, #4
	bne	.L910
.L913:
	add	r1, r1, r3, lsl #5
	movs	r2, #32
	ldr	r0, .L916+16
	bl	ftl_memcpy
	movs	r2, #32
	mov	r1, r5
	ldr	r0, .L916+20
	bl	ftl_memcpy
	b	.L908
.L909:
	adds	r6, r6, #1
	adds	r7, r7, #32
	cmp	r6, #77
	bne	.L911
	mov	r4, #-1
.L908:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, pc}
.L917:
	.align	2
.L916:
	.word	.LANCHOR142+1
	.word	.LANCHOR22
	.word	.LANCHOR142
	.word	.LANCHOR143
	.word	.LANCHOR7
	.word	.LANCHOR31
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
.L919:
	cmp	r3, r2
	bne	.L920
	pop	{r4, pc}
.L920:
	ldr	r4, [r1, r3, lsl #2]
	str	r4, [r0, r3, lsl #2]
	adds	r3, r3, #1
	b	.L919
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
	bne	.L922
	cbz	r3, .L923
	lsls	r1, r3, #30
	bne	.L924
	mov	r2, #256
	mov	r1, r3
	bl	ftl_memcpy32
.L923:
	cbz	r5, .L921
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
.L924:
	mov	r2, #1024
	mov	r1, r3
	bl	ftl_memcpy
	b	.L923
.L922:
	cbz	r3, .L927
	lsls	r2, r3, #30
	bne	.L928
	mov	r1, r0
	mov	r2, #256
	mov	r0, r3
	bl	ftl_memcpy32
.L927:
	cbz	r5, .L921
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
.L921:
	pop	{r4, r5, r6, pc}
.L928:
	mov	r1, r0
	mov	r2, #1024
	mov	r0, r3
	bl	ftl_memcpy
	b	.L927
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
	ldr	r3, .L975
	sub	sp, sp, #96
	mov	r6, r0
	mov	r10, r2
	str	r1, [sp, #12]
	ldr	r5, [r3, r0, lsl #3]
	lsls	r3, r7, #26
	ldr	r4, [sp, #128]
	bne	.L940
	cbnz	r4, .L941
	add	r4, sp, #32
	movs	r2, #64
	movs	r1, #255
	add	r0, sp, #32
	bl	ftl_memset
.L941:
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
	bne	.L965
	ldr	r2, .L975+4
	lsr	r0, r10, #1
	ldr	ip, .L975+12
	ldr	r3, [r2]
	cmp	r3, #25
	ldr	r3, [sp, #12]
	ite	cc
	movcc	r7, #64
	movcs	r7, #128
	mov	r1, r3
.L944:
	cmp	r1, r0
	add	r4, r4, #4
	add	r6, r7, r3
	bcc	.L945
	ldr	r3, .L975+8
	lsr	r4, r10, #2
	ldr	r0, [r2]
	movs	r2, #0
	mov	r8, r2
	ldr	r1, [r3]
.L946:
	cmp	r2, r4
	bcs	.L942
	cbnz	r0, .L952
.L942:
	movs	r3, #0
	str	r3, [r5, #16]
.L953:
	ldr	r3, .L975+8
	ldr	r3, [r3]
	cmp	r3, #5
	bls	.L939
	ldr	r3, [sp, #12]
	cbnz	r3, .L939
	ldr	r3, [r5]
	and	r2, r3, #139264
	cmp	r2, #139264
	ittt	eq
	moveq	r8, #-1
	orreq	r3, r3, #131072
	streq	r3, [r5]
.L939:
	mov	r0, r8
	add	sp, sp, #96
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L945:
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
	b	.L944
.L952:
	add	r3, r2, #8
	ldr	r3, [r5, r3, lsl #2]
	str	r3, [sp, #28]
	ldr	r3, [sp, #28]
	lsls	r6, r3, #29
	bmi	.L968
	ldr	r3, [sp, #28]
	ubfx	r3, r3, #15, #1
	cmp	r3, #0
	bne	.L968
	cmp	r1, #5
	bls	.L948
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
.L974:
	orr	r3, r3, r6, lsl #5
.L950:
	cmp	r8, r3
	it	cc
	movcc	r8, r3
.L947:
	adds	r2, r2, #1
	b	.L946
.L948:
	cmp	r1, #3
	bls	.L950
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
	b	.L974
.L968:
	mov	r8, #-1
	b	.L947
.L965:
	mov	r8, #0
	b	.L942
.L940:
	ldr	r3, [sp, #12]
	cmp	r3, #1
	bne	.L954
	cmp	r4, #0
	mov	r8, #0
	ite	ne
	movne	r3, #4
	moveq	r3, #0
	str	r3, [sp, #16]
.L955:
	cmp	r8, r10
	bcc	.L957
	mov	r8, #0
	b	.L953
.L957:
	and	fp, r8, #3
	cbz	r7, .L970
	add	r3, r7, r8, lsl #9
.L956:
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
	b	.L955
.L970:
	mov	r3, r7
	b	.L956
.L954:
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
.L958:
	cmp	r4, r10
	bcs	.L953
	mov	r0, r6
	adds	r4, r4, #2
	bl	NandcXferComp
	ldr	r3, [r5, #32]
	cmp	r10, r4
	str	r3, [sp, #28]
	bls	.L959
	movs	r3, #0
	movs	r2, #2
	str	r3, [sp, #4]
	movs	r1, #0
	str	r3, [sp]
	mov	r0, r6
	and	r3, r4, #3
	bl	NandcXferStart
.L959:
	ldr	r3, [sp, #28]
	lsls	r3, r3, #29
	bmi	.L971
	ldr	r3, [sp, #28]
	ldr	r2, [sp, #28]
	ubfx	r3, r3, #3, #5
	ubfx	r2, r2, #27, #1
	orr	r3, r3, r2, lsl #5
	cmp	r8, r3
	it	cc
	movcc	r8, r3
.L960:
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
	b	.L958
.L971:
	mov	r8, #-1
	b	.L960
.L976:
	.align	2
.L975:
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
	ldr	r3, .L979
	mov	r6, r1
	mov	r7, r2
	mov	r4, r0
	ldrb	r5, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L978
	ldr	r3, .L979+4
	ldr	r2, .L979+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r0, [r2]
	muls	r0, r3, r0
	cmp	r0, r1
	it	hi
	movhi	r5, #4
.L978:
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
.L980:
	.align	2
.L979:
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
	ldr	r3, .L1006
	sub	sp, sp, #24
	str	r0, [sp, #8]
	ldr	r3, [r3]
	str	r1, [sp, #12]
	str	r2, [sp, #4]
	ldr	r3, [r3, #304]
	str	r3, [sp, #20]
	ldr	r3, .L1006+4
	ldr	r3, [r3]
	cmp	r3, #8
	ldr	r3, [sp, #56]
	ite	cc
	movcc	fp, #6
	movcs	fp, #12
	cmp	r3, #0
	beq	.L995
	movs	r0, #1
	ldr	r4, .L1006+8
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
	bne	.L984
.L993:
	mov	r6, #-1
.L981:
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L984:
	mov	r2, r6
	ldr	r1, [sp, #12]
	ldr	r0, .L1006+12
	bl	printf
	ldr	r2, .L1006+16
	ldr	r3, [r2]
	adds	r3, r3, #1
	cmp	r3, #2048
	bcs	.L986
	str	r3, [r2]
	b	.L981
.L986:
	movs	r7, #0
	str	r7, [r2]
	str	r7, [sp, #4]
.L983:
	mov	r10, #0
	mov	r8, #-1
	mov	r5, r10
	mov	r4, r10
	str	r10, [sp, #16]
.L991:
	uxtb	r0, fp
	bl	NandcSetDdrPara
	mov	r3, r7
	ldr	r2, [sp, #4]
	ldr	r1, [sp, #12]
	ldr	r0, [sp, #8]
	bl	FlashReadRawPage
	adds	r3, r6, #1
	cmp	r0, r3
	bhi	.L987
	cmp	r0, #2
	bhi	.L997
	adds	r4, r4, #1
	cmp	r4, #9
	bls	.L997
	mov	r3, r5
	mov	r6, r0
	sub	r5, fp, r4
	mov	r8, #0
.L989:
	ldr	r2, [sp, #16]
	cmp	r4, r2
	it	ls
	movls	r5, r3
.L990:
	cbz	r5, .L992
	mov	r1, r5
	ldr	r0, .L1006+20
	bl	printf
	uxtb	r0, r5
	bl	NandcSetDdrPara
.L992:
	cmp	r8, #0
	beq	.L981
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #8]
	ldr	r0, .L1006+24
	bl	printf
	ldr	r3, [sp, #56]
	cmp	r3, #0
	beq	.L993
	ldr	r3, [sp, #20]
	ubfx	r0, r3, #8, #8
	bl	NandcSetDdrPara
	b	.L981
.L995:
	mov	r6, #1024
	b	.L983
.L987:
	ldr	r3, [sp, #16]
	cmp	r4, r3
	bls	.L998
	cmp	r4, #7
	sub	r5, r10, r4
	bhi	.L990
	str	r4, [sp, #16]
.L998:
	movs	r4, #0
	b	.L988
.L997:
	mov	r8, #0
	mov	r10, fp
	mov	r6, r0
	mov	r7, r8
	str	r8, [sp, #4]
.L988:
	add	fp, fp, #2
	cmp	fp, #69
	bls	.L991
	mov	r3, r5
	mov	r5, r10
	b	.L989
.L1007:
	.align	2
.L1006:
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
	bne	.L1009
	ldr	r10, .L1027+20
	ldrb	fp, [r10]	@ zero_extendqisi2
	cmp	fp, #0
	bne	.L1010
.L1012:
	ldr	r3, .L1027
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1009
	ldr	r3, .L1027+4
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
	beq	.L1013
	ldr	r3, .L1027+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3, lsr #1
	bls	.L1009
.L1013:
	ubfx	r0, r10, #8, #8
	bl	NandcSetDdrPara
	b	.L1009
.L1010:
	movs	r3, #0
	mov	r2, r7
	strb	r3, [r10]
	mov	r1, r6
	mov	r3, r8
	mov	r0, r5
	bl	FlashReadRawPage
	adds	r3, r0, #1
	strb	fp, [r10]
	beq	.L1012
	mov	r4, r0
.L1009:
	ldr	r10, .L1027+24
	ldr	fp, [r10]
	cmp	fp, #0
	beq	.L1008
	adds	r2, r4, #1
	bne	.L1008
	mov	r3, r8
	mov	r2, r7
	mov	r1, r6
	mov	r0, r5
	blx	fp
	mov	r3, r6
	mov	r4, r0
	mov	r1, r0
	mov	r2, r5
	ldr	r0, .L1027+12
	bl	printf
	adds	r3, r4, #1
	bne	.L1008
	ldr	r3, .L1027+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1008
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
.L1008:
	mov	r0, r4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1028:
	.align	2
.L1027:
	.word	.LANCHOR30
	.word	.LANCHOR19
	.word	.LANCHOR33
	.word	.LC12
	.word	.LANCHOR8
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
	ldr	r4, .L1040
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
	ldr	r5, .L1040+4
	bl	FlashReadRawPage
	adds	r0, r0, #1
	beq	.L1030
	cmp	r8, #-1
	bne	.L1031
.L1030:
	ldrb	r3, [r4]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L1031
	movs	r0, #1
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	movs	r3, #0
.L1039:
	movs	r0, #0
	strb	r3, [r5]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1031:
	movs	r3, #1
	b	.L1039
.L1041:
	.align	2
.L1040:
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
	ldr	fp, .L1057+8
	movs	r4, #0
	movs	r7, #4
	strb	r3, [sp, #20]
	movs	r3, #40
	strb	r3, [sp, #21]
	movs	r3, #24
	strb	r3, [sp, #22]
	movs	r3, #16
	ldr	r1, .L1057
	mov	r0, r4
	strb	r3, [sp, #23]
	mov	r6, #-1
	ldrh	r3, [fp, #10]
	ldr	r8, .L1057+36
	ldr	r5, .L1057+4
	str	r3, [sp, #4]
	ldr	r3, [r1]
	str	r4, [r8]
	str	r3, [r5]
	bl	flash_enter_slc_mode
	mov	r10, r1
	str	r8, [sp, #12]
.L1043:
	mov	r8, #0
	adds	r3, r4, #1
	str	r3, [sp, #8]
.L1045:
	add	r3, sp, #20
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r3, #0
	ldr	r2, [r10]
	mov	r1, r4
	mov	r0, r3
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L1044
	movs	r3, #0
	ldr	r2, [r10]
	ldr	r1, [sp, #8]
	mov	r0, r3
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L1044
	add	r8, r8, #1
	cmp	r8, #4
	bne	.L1045
.L1046:
	ldr	r3, [sp, #4]
	subs	r7, r7, #1
	add	r4, r4, r3
	bne	.L1043
	mov	r0, r7
	b	.L1056
.L1047:
	movw	r1, #2036
	add	r0, r8, #12
	bl	JSHash
	ldr	r3, [r8, #8]
	cmp	r3, r0
	bne	.L1053
	movs	r2, #32
	add	r1, r8, #160
	ldr	r0, .L1057+8
	bl	ftl_memcpy
	ldr	r1, [r5]
	movs	r2, #32
	ldr	r0, .L1057+12
	adds	r1, r1, #192
	bl	ftl_memcpy
	ldr	r1, [r5]
	mov	r2, #852
	ldr	r0, .L1057+16
	adds	r1, r1, #224
	bl	ftl_memcpy
	ldr	r6, [r5]
	mov	r0, r4
	ldr	r3, .L1057+20
	ldrh	r1, [fp, #10]
	ldr	r2, [r6, #1076]
	strb	r2, [r3]
	ldr	r3, [sp, #12]
	str	r4, [r3]
	bl	__aeabi_uidiv
	ldr	r3, .L1057+24
	adds	r2, r0, #1
	cbz	r0, .L1049
.L1055:
	str	r2, [r3]
	ldrh	r2, [r6, #14]
	movs	r6, #0
	ldr	r3, .L1057+28
	strb	r2, [r3]
	b	.L1046
.L1049:
	movs	r2, #2
	b	.L1055
.L1053:
	mov	r6, #-1
	b	.L1046
.L1044:
	ldr	r8, [r5]
	ldr	r2, .L1057+32
	ldr	r3, [r8]
	cmp	r3, r2
	bne	.L1046
	cmp	r6, #0
	bne	.L1047
	ldrh	r1, [fp, #10]
	mov	r0, r4
	bl	__aeabi_uidiv
	ldr	r3, .L1057+24
	adds	r0, r0, #1
	str	r0, [r3]
	mov	r0, r6
.L1056:
	bl	flash_exit_slc_mode
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1058:
	.align	2
.L1057:
	.word	.LANCHOR147
	.word	.LANCHOR146
	.word	.LANCHOR31
	.word	.LANCHOR7
	.word	.LANCHOR20
	.word	.LANCHOR30
	.word	.LANCHOR149
	.word	.LANCHOR150
	.word	1312902724
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
	ldr	r3, .L1086
	ldr	r2, .L1086+4
	ldr	r4, [r3, r6, lsl #3]
	add	r3, r3, r6, lsl #3
	str	r2, [sp, #16]
	ldrb	r7, [r3, #4]	@ zero_extendqisi2
	ldrb	r3, [r2]	@ zero_extendqisi2
	add	r5, r7, #8
	subs	r3, r3, #67
	add	r5, r4, r5, lsl #8
	cmp	r3, #1
	bls	.L1076
	ldr	r3, .L1086+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1077
	movs	r0, #0
	bl	NandcSetDdrMode
	movs	r3, #1
.L1077:
	str	r3, [sp, #8]
	add	r3, r4, r7, lsl #8
	movs	r2, #92
	str	r2, [r3, #2056]
	movs	r2, #197
	str	r2, [r3, #2056]
.L1060:
	mov	r8, #1
	mov	r3, #-1
	str	r3, [sp, #4]
.L1062:
	ldr	r3, .L1086+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r8, r3
	bcc	.L1071
	ldr	r10, [sp, #4]
.L1070:
	ldr	r3, [sp, #16]
	movs	r1, #0
	mov	r0, r5
	ldrb	r2, [r3]	@ zero_extendqisi2
	subs	r2, r2, #67
	cmp	r2, #1
	bhi	.L1072
	bl	SandiskSetRRPara
.L1073:
	add	r4, r4, r7, lsl #8
	movs	r2, #255
	str	r2, [r4, #2056]
	ldr	r2, .L1086+16
	ldrb	r2, [r2]	@ zero_extendqisi2
	add	r2, r2, r2, lsl #1
	cmp	r10, r2, asr #2
	bcc	.L1074
	cmp	r10, #-1
	it	ne
	movne	r10, #256
.L1074:
	mov	r0, r6
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #8]
	cbz	r3, .L1059
	movs	r0, #4
	bl	NandcSetDdrMode
.L1059:
	mov	r0, r10
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1076:
	movs	r3, #0
	str	r3, [sp, #8]
	b	.L1060
.L1071:
	ldr	r3, [sp, #16]
	mov	r0, r5
	uxtb	r1, r8
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L1063
	bl	SandiskSetRRPara
.L1064:
	ldr	r3, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L1065
	ldr	r3, .L1086+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #3
	cmp	r8, r3
	ittt	eq
	addeq	r3, r4, r7, lsl #8
	moveq	r2, #179
	streq	r2, [r3, #2056]
.L1065:
	add	r3, r4, r7, lsl #8
	movs	r2, #38
	str	r2, [r3, #2056]
	movs	r2, #93
	str	r2, [r3, #2056]
	ldr	r3, [sp, #8]
	cbz	r3, .L1066
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
.L1067:
	cmp	r10, #-1
	beq	.L1068
	ldr	r2, .L1086+16
	ldr	r3, [sp, #4]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r3, #-1
	it	eq
	moveq	r3, r10
	str	r3, [sp, #4]
	add	r2, r2, r2, lsl #1
	cmp	r10, r2, asr #2
	bcc	.L1070
	mov	fp, #0
	str	fp, [sp, #12]
.L1068:
	add	r8, r8, #1
	b	.L1062
.L1063:
	bl	ToshibaSetRRPara
	b	.L1064
.L1066:
	mov	r3, fp
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #20]
	mov	r0, r6
	bl	FlashReadRawPage
	mov	r10, r0
	b	.L1067
.L1072:
	bl	ToshibaSetRRPara
	b	.L1073
.L1087:
	.align	2
.L1086:
	.word	.LANCHOR6
	.word	.LANCHOR10
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
	ldr	r2, .L1101
	mov	r4, #-1
	add	r3, r2, r7, lsl #3
	ldrb	r5, [r3, #4]	@ zero_extendqisi2
	add	r3, r5, #8
	ldr	r5, [r2, r7, lsl #3]
	add	r5, r5, r3, lsl #8
.L1089:
	ldr	r3, .L1101+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r6, r3
	bcc	.L1093
.L1092:
	movs	r1, #0
	mov	r0, r5
	bl	SamsungSetRRPara
	ldr	r3, .L1101+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L1088
	adds	r3, r4, #1
	it	ne
	movne	r4, #256
.L1088:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1093:
	uxtb	r1, r6
	mov	r0, r5
	bl	SamsungSetRRPara
	mov	r2, r10
	mov	r3, r8
	mov	r1, fp
	mov	r0, r7
	bl	FlashReadRawPage
	adds	r2, r0, #1
	beq	.L1090
	ldr	r3, .L1101+8
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1096
	mov	r8, #0
	mov	r10, r8
.L1090:
	adds	r6, r6, #1
	b	.L1089
.L1096:
	mov	r4, r0
	b	.L1092
.L1102:
	.align	2
.L1101:
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
	ldr	r3, .L1128
	sub	sp, sp, #40
	mov	r5, r0
	str	r2, [sp, #16]
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L1128+4
	str	r1, [sp, #28]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1104
	add	r2, r2, r2, lsl #1
	asrs	r3, r2, #2
.L1127:
.L1105:
	mov	r8, #0
	str	r3, [sp, #12]
	mov	r6, r8
.L1115:
	mov	r0, r5
	mov	r10, #0
	bl	NandcWaitFlashReady
	ldr	r3, .L1128+8
	mov	r4, #-1
	ldr	r2, [r3, r5, lsl #3]
	add	r3, r3, r5, lsl #3
	ldrb	fp, [r3, #4]	@ zero_extendqisi2
	str	r2, [sp, #24]
	lsl	r3, fp, #8
	str	r3, [sp, #32]
.L1106:
	ldr	r3, .L1128+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r10, r3
	bcc	.L1110
.L1109:
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
	bcc	.L1111
	adds	r1, r4, #1
	mov	r3, r10
	it	ne
	movne	r4, #256
	ldr	r2, [sp, #28]
	str	r4, [sp]
	mov	r1, r10
	ldr	r0, .L1128+16
	bl	printf
	cmp	r8, #0
	bne	.L1113
	ldr	r3, .L1128+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1103
	adds	r2, r4, #1
	bne	.L1103
	movs	r1, #3
	mov	r0, r5
	bl	micron_auto_read_calibration_config
	mov	r8, #1
	b	.L1115
.L1104:
	ldr	r3, .L1128+20
	smull	r2, r3, r2, r3
	b	.L1127
.L1110:
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
	beq	.L1107
	ldr	r3, [sp, #12]
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	cmp	r0, r3
	bcc	.L1117
	movs	r7, #0
	str	r7, [sp, #16]
.L1107:
	ldr	r10, [sp, #20]
	b	.L1106
.L1117:
	movs	r7, #0
	mov	r4, r0
	str	r7, [sp, #16]
	b	.L1109
.L1113:
	movs	r1, #0
	mov	r0, r5
	bl	micron_auto_read_calibration_config
	adds	r3, r4, #1
	it	ne
	movne	r4, #256
.L1103:
	mov	r0, r4
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1111:
	cmp	r8, #0
	beq	.L1103
	movs	r1, #0
	mov	r0, r5
	bl	micron_auto_read_calibration_config
	mov	r4, #256
	b	.L1103
.L1129:
	.align	2
.L1128:
	.word	.LANCHOR33
	.word	.LANCHOR8
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
	mov	fp, r2
	ldr	r4, .L1147
	mov	r8, #0
	mov	r6, #-1
	mov	r10, r3
	mov	r7, r0
	str	r1, [sp, #4]
	ldrb	r2, [r4, #2]	@ zero_extendqisi2
	adds	r3, r4, r0
	ldrb	r5, [r3, #12]	@ zero_extendqisi2
	str	r2, [sp]
	ldr	r2, .L1147+4
	ldr	r2, [r2]
	ldrb	r2, [r2, #19]	@ zero_extendqisi2
	cmp	r2, #7
	it	eq
	ldrbeq	r5, [r3, #20]	@ zero_extendqisi2
	bl	NandcWaitFlashReady
.L1132:
	ldr	r3, [sp]
	cmp	r8, r3
	bcc	.L1137
.L1136:
	ldr	r3, .L1147+4
	add	r4, r4, r7
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cmp	r3, #7
	ldr	r3, .L1147+8
	ite	eq
	strbeq	r5, [r4, #20]
	strbne	r5, [r4, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r6, r3, asr #2
	bcc	.L1130
	adds	r3, r6, #1
	it	ne
	movne	r6, #256
.L1130:
	mov	r0, r6
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1137:
	ldr	r3, [sp]
	adds	r5, r5, #1
	uxtb	r5, r5
	ldr	r2, .L1147+12
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
	beq	.L1134
	ldr	r3, .L1147+8
	cmp	r6, #-1
	it	eq
	moveq	r6, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1141
	mov	r10, #0
	mov	fp, r10
.L1134:
	add	r8, r8, #1
	b	.L1132
.L1141:
	mov	r6, r0
	b	.L1136
.L1148:
	.align	2
.L1147:
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
	ldr	r3, .L1152
	mov	r5, r1
	mov	r7, r2
	mov	r4, r0
	ldrb	r6, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L1150
	ldr	r3, .L1152+4
	ldr	r2, .L1152+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r1, [r2]
	muls	r1, r3, r1
	cmp	r1, r5
	bls	.L1150
	ldr	r3, .L1152+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1151
	subs	r6, r6, #2
.L1150:
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
.L1151:
	movs	r6, #4
	b	.L1150
.L1153:
	.align	2
.L1152:
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
	ldr	r7, .L1163
	ldr	r4, .L1163+4
	ldr	r3, [r7]
	ldr	r10, .L1163+60
	ldr	r8, .L1163+64
	str	r3, [r4]
	ldr	r3, .L1163+8
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	FlashBchSel
	mov	r2, #2048
	movs	r1, #0
	ldr	r0, [r7]
	bl	ftl_memset
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r3, .L1163+12
	ldr	r1, .L1163+16
	str	r10, [r0]
	adds	r0, r0, #16
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r0, #-4]	@ movhi
	ldr	r3, .L1163+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r0, #-2]	@ movhi
	ldr	r3, .L1163+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r0, #1060]
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #8
	ldr	r1, .L1163+28
	adds	r0, r0, #80
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1163+32
	adds	r0, r0, #96
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1163+36
	adds	r0, r0, #160
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1163+40
	adds	r0, r0, #192
	bl	ftl_memcpy
	ldr	r0, [r4]
	mov	r2, #852
	ldr	r1, .L1163+44
	adds	r0, r0, #224
	bl	ftl_memcpy
	ldr	r5, [r4]
	movw	r1, #2036
	add	r0, r5, #12
	bl	JSHash
	ldr	r1, .L1163+48
	mov	r3, #1592
	str	r3, [r5, #4]
	str	r0, [r5, #8]
	movs	r0, #0
	ldr	r3, [r1]
	movs	r5, #0
	mov	r6, r5
	str	r3, [r4]
	bl	flash_enter_slc_mode
	mov	fp, r1
.L1157:
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
	beq	.L1155
	ldr	r3, [r4]
	ldr	r1, [r3]
	cmp	r1, r10
	bne	.L1155
	add	r0, r3, #12
	movw	r1, #2036
	str	r2, [sp, #4]
	str	r3, [sp]
	bl	JSHash
	ldr	r3, [sp]
	ldr	r2, [sp, #4]
	ldr	r3, [r3, #8]
	cmp	r3, r0
	bne	.L1155
	ldr	r3, .L1163+52
	cmp	r5, #1
	str	r2, [r3]
	ldr	r3, [r8]
	mul	r6, r6, r3
	ldr	r3, .L1163+56
	str	r6, [r3]
	beq	.L1158
	movs	r5, #1
.L1155:
	cmp	r2, #4
	mov	r6, r2
	bne	.L1157
.L1156:
	movs	r0, #0
	bl	flash_exit_slc_mode
	clz	r0, r5
	lsrs	r0, r0, #5
	negs	r0, r0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1158:
	movs	r5, #2
	b	.L1156
.L1164:
	.align	2
.L1163:
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
	.word	.LANCHOR153
	.word	.LANCHOR149
	.word	.LANCHOR148
	.word	1312902724
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
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r3, #60
	sub	sp, sp, #24
	ldr	r2, .L1177
	mov	r10, r0
	strb	r3, [sp, #20]
	movs	r3, #40
	strb	r3, [sp, #21]
	movs	r3, #24
	strb	r3, [sp, #22]
	movs	r3, #16
	strb	r3, [sp, #23]
	ldr	r3, .L1177+4
	ldr	r1, [r2]
	str	r2, [sp, #8]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #4]
	ldr	r3, .L1177+8
	cmp	r1, r3
	str	r3, [sp, #12]
	bne	.L1166
	movs	r0, #0
	bl	flash_enter_slc_mode
.L1166:
	mov	r7, #-1
	movs	r4, #2
	mov	r2, #2048
	movs	r1, #0
	mov	r0, r10
	bl	ftl_memset
.L1167:
	ldr	r3, .L1177+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L1172
.L1171:
	ldr	r0, [sp, #4]
	bl	FlashBchSel
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L1165
	movs	r0, #0
	bl	flash_exit_slc_mode
.L1165:
	mov	r0, r7
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1172:
	ldr	r5, .L1177+16
	movs	r6, #0
	ldr	fp, .L1177+32
.L1169:
	add	r3, sp, #20
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
	bne	.L1168
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L1169
.L1170:
	adds	r4, r4, #1
	b	.L1167
.L1175:
	movs	r7, #0
	b	.L1171
.L1168:
	ldr	r3, [r5]
	ldr	r2, [r3]
	ldr	r3, .L1177+20
	cmp	r2, r3
	bne	.L1170
	mov	r1, r8
	ldr	r0, .L1177+24
	bl	printf
	mov	r2, #2048
	ldr	r1, [r5]
	mov	r0, r10
	bl	ftl_memcpy
	ldr	r3, [r5]
	ldr	r2, .L1177+12
	ldr	r3, [r3, #512]
	strb	r3, [r2]
	ldr	r3, .L1177+28
	ldr	r2, [r3]
	cmp	r4, r2
	bcs	.L1175
	str	r4, [r3]
	movs	r7, #0
	bl	FlashSavePhyInfo
	b	.L1170
.L1178:
	.align	2
.L1177:
	.word	.LANCHOR29
	.word	.LANCHOR33
	.word	1446522928
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
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r2
	ldr	r5, .L1189
	mov	r6, r0
	mov	r7, r1
	ldr	r3, [r5]
	ldrb	r2, [r3, #19]	@ zero_extendqisi2
	ldr	r3, .L1189+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1180
	ldr	r3, .L1189+8
	ldr	r1, [r3]
	ldr	r3, .L1189+12
	cmp	r1, r3
	beq	.L1179
.L1180:
	subs	r3, r2, #5
	uxtb	r3, r3
	cmp	r3, #30
	bhi	.L1181
	ldr	r2, .L1189+16
	lsr	r3, r2, r3
	lsls	r3, r3, #31
	bmi	.L1183
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1184:
	ldrh	r2, [r10, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1179
	mov	r2, #32768
	movs	r1, #255
	ldr	r0, [r8]
	bl	ftl_memset
	adds	r1, r4, r7
	adds	r4, r4, #1
	uxth	r4, r4
	movs	r3, #0
	ldr	r2, [r8]
	mov	r0, r6
	bl	FlashProgPage
.L1185:
	ldr	r3, [r5]
	ldrh	r3, [r3, #10]
	cmp	r3, r4
	bhi	.L1184
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1181:
	cmp	r2, #68
	bne	.L1179
.L1183:
	ldr	r10, .L1189+20
	ldr	r8, .L1189+24
	b	.L1185
.L1179:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1190:
	.align	2
.L1189:
	.word	.LANCHOR18
	.word	.LANCHOR8
	.word	.LANCHOR29
	.word	1446522928
	.word	1073758215
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
	bls	.L1192
	cmp	r0, #576
	bcs	.L1193
	ldr	r2, .L1244
	cmp	r0, #64
	mov	r4, #1
	str	r4, [r2]
	bhi	.L1194
	rsb	r0, r0, #64
	subs	r2, r3, r0
	add	r1, r1, r0, lsl #9
	ldr	r0, .L1244+4
	lsls	r2, r2, #9
.L1243:
	bl	ftl_memcpy
.L1232:
	movs	r0, #0
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1194:
	rsb	r2, r0, #576
	subs	r0, r0, #64
	cmp	r2, r3
	it	cs
	movcs	r2, r3
	ldr	r3, .L1244+4
	lsls	r2, r2, #9
	add	r0, r3, r0, lsl #9
	b	.L1243
.L1192:
	cmp	r0, #576
	bcc	.L1232
.L1193:
	ldr	r3, .L1244
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L1232
	ldr	r3, .L1244+8
	ldr	r2, [r3]
	ldrb	r3, [r2, #9]	@ zero_extendqisi2
	ldrh	r2, [r2, #10]
	smulbb	r3, r3, r2
	uxth	r3, r3
	mov	r1, r3
	addw	r0, r3, #511
	str	r3, [sp, #8]
	bl	__aeabi_uidiv
	ldr	r1, .L1244+4
	movs	r3, #0
	str	r0, [sp, #20]
	movw	r2, #65535
	mov	r0, r1
.L1198:
	ldr	r4, [r1, r2, lsl #2]
	cbnz	r4, .L1196
	ldr	r4, [r1, r3, lsl #2]
	adds	r3, r3, #1
	cmp	r3, #4096
	it	hi
	movhi	r3, #0
	str	r4, [r1, r2, lsl #2]
	subs	r2, r2, #1
	cmp	r2, #4096
	bne	.L1198
.L1196:
	ldr	r1, [r0, r2, lsl #2]
	mov	r3, #512
	ldr	r0, .L1244+12
	bl	printf
	ldr	r3, .L1244+16
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
.L1199:
	ldr	r3, [sp, #16]
	cmp	r3, #15
	bls	.L1216
	ldr	r3, [sp, #12]
	cbnz	r3, .L1218
	mov	r1, r3
	ldr	r0, .L1244+20
	bl	printf
.L1218:
	ldr	r3, .L1244
	movs	r2, #0
	str	r2, [r3]
	b	.L1232
.L1245:
	.align	2
.L1244:
	.word	.LANCHOR154
	.word	idb_buf
	.word	.LANCHOR18
	.word	.LC15
	.word	.LANCHOR149
	.word	.LC17
.L1216:
	mov	r2, #512
	movs	r1, #0
	ldr	r0, .L1246
	bl	memset
	ldr	r3, .L1246+4
	mov	r0, r4
	ldr	r3, [r3]
	ldrb	fp, [r3, #9]	@ zero_extendqisi2
	ldrh	r5, [r3, #10]
	bl	FW_FlashBlockErase.constprop.41
	smulbb	r5, r5, fp
	uxth	r5, r5
	cmp	r5, #512
	bcs	.L1200
	adds	r0, r5, r4
	bl	FW_FlashBlockErase.constprop.41
.L1200:
	ldr	r7, .L1246+8
	mov	r1, r5
	ldr	r10, .L1246+36
	mov	r0, r4
	bl	__aeabi_uidivmod
	mov	r6, r1
	subs	r3, r4, r1
	str	r3, [sp, #24]
.L1204:
	lsrs	r2, r6, #2
	beq	.L1201
	ldr	r0, .L1246+12
	adds	r1, r2, #1
	ldr	r3, .L1246+16
	ldrb	r0, [r0]	@ zero_extendqisi2
	ldrh	r3, [r3, r1, lsl #1]
	cbz	r0, .L1202
	ldr	r0, [r10]
	ldr	r5, .L1246+20
	cmp	r0, r5
	it	eq
	moveq	r3, r1
.L1202:
	add	r3, r3, #1073741824
	subs	r3, r3, #1
	lsls	r3, r3, #2
	str	r3, [sp, #40]
.L1201:
	movw	r3, #61424
	str	r3, [sp, #44]
	ldr	r3, .L1246+16
	ldrh	r5, [r3, r2, lsl #1]
	ldr	r3, .L1246+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1203
	ldr	r3, [r10]
	ldr	r1, .L1246+20
	cmp	r3, r1
	it	eq
	moveq	r5, r2
.L1203:
	ldr	r3, [sp, #24]
	adds	r6, r6, #4
	ldr	r2, .L1246+24
	ldr	r8, .L1246+4
	mla	r3, r5, fp, r3
	adds	r5, r5, #1
	uxth	r5, r5
	str	r3, [sp, #32]
	ldrb	r3, [r2]	@ zero_extendqisi2
	ldr	r2, .L1246+28
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
	ldr	r3, .L1246+32
	cmp	r7, r3
	bne	.L1204
	ldr	r3, [r8]
	mov	r0, r4
	ldr	r7, .L1246
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
.L1205:
	cmp	r6, #512
	bcs	.L1212
	ldr	r1, .L1246+12
	rsb	r3, r5, #4
	uxth	r3, r3
	ldr	r2, .L1246+16
	ldrb	r1, [r1]	@ zero_extendqisi2
	str	r3, [sp, #24]
	add	r3, r10, r6
	lsrs	r3, r3, #2
	ldrh	r2, [r2, r3, lsl #1]
	cbz	r1, .L1206
	ldr	r1, .L1246+36
	ldr	r0, .L1246+20
	ldr	r1, [r1]
	cmp	r1, r0
	it	eq
	moveq	r2, r3
.L1206:
	ldr	r3, [sp, #28]
	add	r5, r5, r3
	ldr	r3, .L1246+24
	mla	r5, r2, r8, r5
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #32]
	ldr	r3, .L1246+4
	ldr	r3, [r3]
	ldrb	fp, [r3, #9]	@ zero_extendqisi2
	ldr	r3, .L1246+40
	ldrh	r2, [r3, #26]
	ldr	r3, .L1246+44
	ldr	r3, [r3]
	muls	r3, r2, r3
	mul	r3, fp, r3
	cmp	r5, r3
	bcs	.L1207
	ldr	r3, .L1246+28
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	FlashBchSel
.L1207:
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
	bne	.L1208
	ldr	r3, .L1246+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #40
	beq	.L1208
	movs	r0, #40
	bl	FlashBchSel
	add	r3, sp, #40
	mov	r2, r7
	mov	r1, fp
	movs	r0, #0
	bl	FlashReadPage
	mov	r5, r0
.L1208:
	movs	r0, #0
	bl	flash_boot_exit_slc_mode
	ldr	r0, [sp, #32]
	bl	FlashBchSel
	adds	r5, r5, #1
	mov	r5, #-1
	it	ne
	movne	r5, #0
	cbz	r5, .L1209
.L1212:
	ldr	r3, .L1246+8
	movs	r5, #0
	ldr	r6, .L1246
.L1210:
	mov	r7, r3
	ldr	r1, [r6, r5, lsl #2]
	ldr	r2, [r7]
	adds	r3, r3, #4
	cmp	r1, r2
	beq	.L1213
	mov	r2, #512
	movs	r1, #0
	ldr	r0, .L1246
	bl	memset
	str	r5, [sp]
	mov	r1, r4
	ldr	r3, [r7]
	ldr	r2, [r6, r5, lsl #2]
	ldr	r0, .L1246+48
	bl	printf
	mov	r0, r4
	bl	FW_FlashBlockErase.constprop.41
	ldr	r3, [sp, #20]
	cmp	r3, #1
	bls	.L1214
	ldr	r3, [sp, #8]
	adds	r0, r3, r4
	bl	FW_FlashBlockErase.constprop.41
.L1214:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #20]
	add	r3, r3, r2
	str	r3, [sp, #16]
	ldr	r3, [sp, #36]
	add	r4, r4, r3
	b	.L1199
.L1209:
	ldr	r3, [sp, #24]
	add	r6, r6, r3
	add	r7, r7, r3, lsl #9
	uxth	r6, r6
	b	.L1205
.L1213:
	adds	r5, r5, #1
	cmp	r5, #65536
	bne	.L1210
	ldr	r3, [sp, #12]
	adds	r3, r3, #1
	cmp	r3, #5
	str	r3, [sp, #12]
	bls	.L1214
	b	.L1218
.L1247:
	.align	2
.L1246:
	.word	gp_flash_check_buf
	.word	.LANCHOR18
	.word	idb_buf
	.word	.LANCHOR8
	.word	.LANCHOR16
	.word	1446522928
	.word	.LANCHOR33
	.word	.LANCHOR152
	.word	idb_buf+262144
	.word	.LANCHOR29
	.word	.LANCHOR15
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
	ldr	r0, .L1250
	bx	lr
.L1251:
	.align	2
.L1250:
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
	ldr	r3, .L1255
	movs	r4, #0
	ldr	r5, .L1255+4
	str	r2, [r3, #12]
	movs	r2, #2
	str	r2, [r3, #20]
	movs	r2, #3
	stm	r3, {r0, r4}
	str	r0, [r3, #8]
	str	r0, [r3, #16]
	str	r2, [r3, #28]
	str	r0, [r3, #24]
	ldr	r3, .L1255+8
	ldr	r2, .L1255+12
	str	r0, [r3]
	ldr	r3, [r0]
	and	r3, r3, #253952
	ubfx	r1, r3, #13, #1
	bfi	r3, r4, #13, #1
	str	r1, [r2]
	orr	r3, r3, #256
	ldr	r2, [r0, #352]
	ldr	r1, .L1255+16
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
	ldr	r3, .L1255+20
	str	r3, [r0, #304]
	mov	r0, #36864
	bl	ftl_malloc
	ldr	r3, .L1255+24
	str	r0, [r3]
	ldr	r3, .L1255+28
	str	r0, [r3]
	add	r0, r0, #32768
	str	r0, [r3, #4]
	str	r4, [r3, #24]
	ldr	r3, .L1255+32
	str	r4, [r3]
	pop	{r3, r4, r5, pc}
.L1256:
	.align	2
.L1255:
	.word	.LANCHOR6
	.word	.LANCHOR29
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
	ldr	r3, .L1262
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r2, .L1262+4
	movs	r6, #12
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1262+8
	ldr	r5, .L1262+12
	ldr	r10, .L1262+304
	str	r4, [r3]
	ldr	r3, .L1262+16
	ldr	r8, .L1262+308
	ldr	fp, .L1262+312
	str	r4, [r3]
	ldr	r3, .L1262+20
	str	r4, [r3]
	ldr	r3, .L1262+24
	str	r4, [r3]
	ldr	r3, .L1262+28
	str	r4, [r3]
	ldr	r3, .L1262+32
	str	r4, [r3]
	ldr	r3, .L1262+36
	str	r4, [r3]
	ldr	r3, .L1262+40
	str	r4, [r3]
	ldr	r3, .L1262+44
	str	r4, [r3]
	ldr	r3, .L1262+48
	str	r4, [r3]
	ldr	r3, .L1262+52
	str	r4, [r3]
	ldr	r3, .L1262+56
	str	r4, [r3]
	ldr	r3, .L1262+60
	str	r4, [r3]
	ldr	r3, .L1262+64
	str	r4, [r3]
	ldr	r3, .L1262+68
	str	r4, [r3]
	ldr	r3, .L1262+72
	str	r4, [r3]
	ldr	r3, .L1262+76
	str	r4, [r3]
	movw	r3, #65535
	str	r3, [r2]
	ldr	r2, .L1262+80
	str	r4, [r2]
	ldr	r2, .L1262+84
	str	r4, [r2]
	ldr	r2, .L1262+88
	str	r4, [r2]
	ldr	r2, .L1262+92
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1262+96
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1262+100
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1262+104
	strh	r3, [r2]	@ movhi
	movs	r2, #32
	ldr	r3, .L1262+108
	strh	r2, [r3]	@ movhi
	movs	r2, #128
	ldr	r3, .L1262+112
	strh	r2, [r3]	@ movhi
	ldr	r3, .L1262+116
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1262+120
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1262+124
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1262+128
	strh	r4, [r3]	@ movhi
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1262+132
	str	r0, [r3]
	ldrh	r0, [r5]
	movs	r5, #36
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L1262+136
	str	r0, [r3]
	ldrh	r3, [r10]
	muls	r5, r3, r5
	lsls	r7, r5, #2
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L1262+140
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1262+144
	str	r0, [r3]
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L1262+148
	ldr	r7, .L1262+152
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1262+156
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1262+160
	ldrh	r5, [r7]
	str	r0, [r3]
	ldrh	r3, [r10]
	mov	r0, r5
	lsls	r3, r3, #1
	adds	r3, r3, #1
	str	r3, [r8]
	bl	ftl_malloc
	ldr	r3, .L1262+164
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1262+168
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1262+172
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L1262+176
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1262+180
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1262+184
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L1262+188
	ldrh	r5, [r10]
	ldr	r10, .L1262+316
	str	r0, [r3]
	ldrh	r3, [fp]
	muls	r5, r3, r5
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1262+192
	str	r0, [r3]
	lsls	r0, r5, #2
	ldr	r5, .L1262+196
	bl	ftl_malloc
	ldr	r3, .L1262+200
	str	r0, [r3]
	ldrh	r3, [fp]
	ldr	r0, [r8]
	ldr	r8, .L1262+320
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1262+204
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L1262+208
	str	r0, [r3]
	ldrh	r3, [r8]
	ldr	r0, .L1262+212
	addw	r3, r3, #547
	lsrs	r3, r3, #9
	and	r0, r0, r3, lsl #9
	strh	r3, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L1262+216
	str	r0, [r3]
	adds	r0, r0, #32
	ldr	r3, .L1262+220
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1262+224
	str	r0, [r3]
	ldr	r3, [r10]
	lsl	r8, r3, #1
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L1262+228
	str	r0, [r3]
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L1262+232
	ldr	r8, .L1262+324
	str	r0, [r3]
	ldrh	r0, [r5]
	lsrs	r0, r0, #3
	adds	r0, r0, #4
	bl	ftl_malloc
	ldr	r3, .L1262+236
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1262+240
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1262+244
	str	r0, [r3]
	ldrh	r0, [r8]
	ldr	r8, .L1262+328
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1262+248
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldrh	r2, [r8]
	mov	r1, r4
	ldr	r3, .L1262+252
	lsls	r2, r2, #2
	str	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L1262+256
	ldrh	r4, [r3]
	lsls	r4, r4, #2
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L1262+260
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L1262+264
	ldr	r4, .L1262+268
	str	r0, [r3]
	ldr	r0, [r10]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1262+272
	str	r0, [r3]
	ldrh	r0, [r4]
	muls	r0, r6, r0
	ldr	r6, .L1262+276
	bl	ftl_malloc
	ldr	r3, .L1262+280
	str	r0, [r3]
	ldrh	r3, [r4]
	ldrh	r0, [r7]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1262+284
	str	r0, [r3]
	movs	r0, #6
	ldrh	r3, [r5]
	ldr	r5, .L1262+288
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1262+292
	str	r0, [r3]
	ldr	r3, .L1262+296
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
	ldr	r3, .L1262+300
	ldrh	r6, [r6]
	lsls	r1, r1, #2
	mov	r4, r3
	str	r0, [r4, #28]!
	b	.L1263
.L1264:
	.align	2
.L1262:
	.word	.LANCHOR139
	.word	.LANCHOR173
	.word	.LANCHOR157
	.word	.LANCHOR55
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
	.word	.LANCHOR80
	.word	.LANCHOR169
	.word	.LANCHOR170
	.word	.LANCHOR171
	.word	.LANCHOR172
	.word	.LANCHOR174
	.word	.LANCHOR175
	.word	.LANCHOR74
	.word	.LANCHOR113
	.word	.LANCHOR114
	.word	.LANCHOR115
	.word	.LANCHOR116
	.word	.LANCHOR176
	.word	.LANCHOR177
	.word	.LANCHOR178
	.word	.LANCHOR117
	.word	.LANCHOR179
	.word	.LANCHOR119
	.word	.LANCHOR109
	.word	.LANCHOR112
	.word	.LANCHOR180
	.word	.LANCHOR181
	.word	.LANCHOR182
	.word	.LANCHOR58
	.word	.LANCHOR78
	.word	.LANCHOR107
	.word	.LANCHOR183
	.word	.LANCHOR184
	.word	.LANCHOR185
	.word	.LANCHOR105
	.word	.LANCHOR186
	.word	.LANCHOR187
	.word	.LANCHOR104
	.word	.LANCHOR188
	.word	.LANCHOR41
	.word	.LANCHOR189
	.word	.LANCHOR106
	.word	.LANCHOR137
	.word	33553920
	.word	.LANCHOR191
	.word	.LANCHOR79
	.word	.LANCHOR84
	.word	.LANCHOR129
	.word	.LANCHOR125
	.word	.LANCHOR0
	.word	.LANCHOR72
	.word	.LANCHOR192
	.word	.LANCHOR193
	.word	.LANCHOR194
	.word	.LANCHOR67
	.word	.LANCHOR131
	.word	.LANCHOR195
	.word	.LANCHOR68
	.word	.LANCHOR130
	.word	.LANCHOR45
	.word	.LANCHOR97
	.word	.LANCHOR126
	.word	.LANCHOR123
	.word	.LANCHOR82
	.word	.LANCHOR51
	.word	.LANCHOR75
	.word	.LANCHOR38
	.word	.LANCHOR108
	.word	.LANCHOR59
	.word	.LANCHOR65
	.word	.LANCHOR190
	.word	.LANCHOR62
	.word	.LANCHOR63
.L1263:
	mov	r0, r1
.L1258:
	cmp	r2, r6
	bcc	.L1259
	add	r3, r3, r2, lsl #2
	ldr	r2, .L1265
	movs	r1, #0
	adds	r3, r3, #24
.L1260:
	cmp	r3, r2
	bne	.L1261
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1259:
	ldr	r5, [r3, #28]
	adds	r2, r2, #1
	add	r5, r5, r0
	add	r0, r0, r1
	str	r5, [r4, #4]!
	b	.L1258
.L1261:
	str	r1, [r3, #4]!
	b	.L1260
.L1266:
	.align	2
.L1265:
	.word	.LANCHOR75+56
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
	ldr	r3, .L1273
	ldr	r0, [r3]
	bx	lr
.L1274:
	.align	2
.L1273:
	.word	.LANCHOR69
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
	ldr	r7, .L1284
	mov	fp, r0
	mov	r6, r1
	mov	r8, r2
	mov	r10, r3
	mov	r4, r5
.L1276:
	cmp	r4, r10
	bne	.L1282
	ldr	r1, .L1284+4
	ldr	r0, .L1284+8
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L1282:
	cbnz	r5, .L1277
	mov	r2, r4
	mov	r1, fp
	ldr	r0, .L1284+12
	bl	printf
.L1277:
	cmp	r8, #4
	bne	.L1278
	ldr	r1, [r6, r4, lsl #2]
.L1283:
	mov	r0, r7
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L1281
	movs	r5, #0
	ldr	r1, .L1284+4
	ldr	r0, .L1284+8
	bl	printf
.L1281:
	adds	r4, r4, #1
	b	.L1276
.L1278:
	cmp	r8, #2
	ite	eq
	ldrsheq	r1, [r6, r4, lsl #1]
	ldrbne	r1, [r6, r4]	@ zero_extendqisi2
	b	.L1283
.L1285:
	.align	2
.L1284:
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
	ldr	r5, .L1385
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
	bne	.L1287
	movs	r3, #167
	movs	r2, #247
	strb	r3, [r5, #4]
	ldr	r3, .L1385+4
	strb	r2, [r3, #17]
.L1343:
	mov	r10, #7
	b	.L1379
.L1287:
	cmp	r0, #3
	bne	.L1289
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
.L1380:
	mov	r10, #8
	strb	r3, [r5, #11]
	mov	fp, r10
.L1288:
	subs	r3, r4, #1
	cmp	r3, #1
	bhi	.L1293
	mov	r8, #0
.L1294:
	ldr	r3, .L1385+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxtb	r3, r8
	cmp	r2, r3
	bhi	.L1300
.L1301:
	ldr	r3, .L1385
	strb	fp, [r3, #1]
	strb	r10, [r3, #2]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1289:
	cmp	r0, #4
	bne	.L1290
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
	b	.L1380
.L1290:
	cmp	r0, #5
	bne	.L1291
	movs	r3, #56
	mov	r10, #8
	strb	r3, [r5, #4]
	movs	r3, #57
	strb	r3, [r5, #5]
	movs	r3, #58
	strb	r3, [r5, #6]
	movs	r3, #59
	strb	r3, [r5, #7]
.L1379:
	mov	fp, #4
	b	.L1288
.L1291:
	cmp	r0, #6
	bne	.L1292
	movs	r3, #14
	mov	r10, #12
	strb	r3, [r5, #4]
	movs	r3, #15
	strb	r3, [r5, #5]
	movs	r3, #16
	strb	r3, [r5, #6]
	movs	r3, #17
	strb	r3, [r5, #7]
	b	.L1379
.L1292:
	cmp	r0, #7
	bne	.L1343
	movs	r3, #176
	mov	r10, #12
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
	mov	fp, #10
	b	.L1288
.L1300:
	ldr	r2, .L1385+12
	movs	r6, #0
	ldrb	r2, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1385+16
	ldr	r7, [r3, r2, lsl #3]
	add	r4, r5, r2, lsl #6
	add	r3, r3, r2, lsl #3
	movs	r2, #55
	adds	r4, r4, #20
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r7, r7, r3, lsl #8
	addw	r3, r7, #2056
.L1295:
	adds	r1, r5, r6
	str	r2, [r3]
	ldrb	r1, [r1, #4]	@ zero_extendqisi2
	movs	r0, #80
	str	r2, [sp, #8]
	str	r3, [sp, #4]
	str	r1, [r7, #2052]
	bl	udelay
	ldr	r1, [r7, #2048]
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #8]
	strb	r1, [r4, r6]
	adds	r6, r6, #1
	uxtb	r1, r6
	cmp	fp, r1
	bhi	.L1295
	ldr	r7, .L1385+4
	mov	r1, r4
	movs	r2, #0
.L1298:
	movs	r3, #1
	adds	r6, r7, r2
.L1297:
	ldrb	r0, [r6, r3, lsl #2]	@ zero_extendqisi2
	ldrb	ip, [r1]	@ zero_extendqisi2
	add	r0, r0, ip
	strb	r0, [r1, r3, lsl #3]
	adds	r3, r3, #1
	cmp	r3, #7
	bne	.L1297
	adds	r2, r2, #1
	adds	r1, r1, #1
	cmp	r2, #4
	bne	.L1298
	movs	r3, #0
	add	r8, r8, #1
	strb	r3, [r4, #16]
	strb	r3, [r4, #24]
	strb	r3, [r4, #32]
	strb	r3, [r4, #40]
	strb	r3, [r4, #48]
	strb	r3, [r4, #41]
	strb	r3, [r4, #49]
	b	.L1294
.L1293:
	subs	r3, r4, #3
	cmp	r3, #4
	bhi	.L1301
	smulbb	r3, r10, fp
	asrs	r2, r3, #2
	lsls	r3, r3, #4
	str	r3, [sp, #52]
	lsls	r3, r2, #3
	str	r2, [sp, #12]
	str	r3, [sp, #48]
	lsls	r3, r2, #2
	str	r3, [sp, #32]
	movs	r3, #0
.L1384:
	str	r3, [sp, #28]
	ldrb	r3, [sp, #28]	@ zero_extendqisi2
	str	r3, [sp, #16]
	ldr	r3, .L1385+8
	ldr	r2, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L1301
	ldr	r2, [sp, #16]
	ldr	r3, .L1385+12
	ldrb	r8, [r3, r2]	@ zero_extendqisi2
	ldr	r3, .L1385+16
	mov	r0, r8
	ldr	r2, [r3, r8, lsl #3]
	add	r3, r3, r8, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	str	r2, [sp, #4]
	str	r3, [sp, #8]
	mov	r3, r2
	ldr	r2, [sp, #8]
	add	r3, r3, r2, lsl #8
	movs	r2, #255
	str	r2, [r3, #2056]
	bl	NandcWaitFlashReady
	ldr	r1, .L1385
	cmp	r4, #7
	it	eq
	moveq	r3, #160
	ldr	r2, [sp, #8]
	itete	eq
	mlaeq	r1, r3, r8, r1
	addne	r1, r1, r8, lsl #6
	addeq	r3, r1, #28
	addne	r3, r1, #20
	str	r3, [sp, #36]
	cmp	r4, #4
	ldr	r3, [sp, #4]
	add	r3, r3, r2, lsl #8
	mov	r2, #54
	str	r2, [r3, #2056]
	bne	.L1305
	movs	r2, #255
	str	r2, [r3, #2052]
	movs	r2, #64
	str	r2, [r3, #2048]
	movs	r2, #204
.L1382:
	str	r2, [r3, #2052]
	movs	r2, #77
	b	.L1383
.L1305:
	subs	r2, r4, #5
	cmp	r2, #1
	bhi	.L1307
	ldr	r2, .L1385
	ldrb	r2, [r2, #4]	@ zero_extendqisi2
	str	r2, [r3, #2052]
	movs	r2, #82
.L1383:
	str	r2, [r3, #2048]
	cmp	r4, #6
	ldr	r3, [sp, #4]
	mov	r0, r8
	ldr	r2, [sp, #8]
	add	r5, r3, r2, lsl #8
	mov	r3, #22
	ldr	r2, [sp, #8]
	str	r3, [r5, #2056]
	mov	r3, #23
	str	r3, [r5, #2056]
	mov	r3, #4
	str	r3, [r5, #2056]
	mov	r3, #25
	str	r3, [r5, #2056]
	mov	r3, #0
	str	r3, [r5, #2056]
	str	r3, [r5, #2052]
	str	r3, [r5, #2052]
	it	eq
	moveq	r3, #31
	str	r3, [r5, #2052]
	movs	r3, #2
	str	r3, [r5, #2052]
	movs	r3, #0
	str	r3, [r5, #2052]
	ldr	r3, [sp, #4]
	add	r3, r3, r2, lsl #8
	movs	r2, #48
	str	r2, [r3, #2056]
	bl	NandcWaitFlashReady
	subs	r3, r4, #5
	cmp	r3, #1
	str	r3, [sp, #40]
	bls	.L1344
	cmp	r4, #7
	ite	eq
	moveq	r2, #32
	movne	r2, #2
.L1310:
	ldr	r3, .L1385+20
	subs	r2, r2, #1
	ldr	r3, [r3]
	subs	r1, r3, #1
	uxtab	r2, r3, r2
	mov	r0, r1
.L1311:
	ldr	r6, [r5, #2048]
	strb	r6, [r0, #1]!
	cmp	r2, r0
	bne	.L1311
	cmp	r4, #7
	bne	.L1312
	movs	r2, #0
.L1314:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #12
	beq	.L1313
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #10
	beq	.L1313
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1314
.L1315:
	movs	r1, #0
	ldr	r0, .L1385+24
	bl	printf
.L1317:
	b	.L1317
.L1307:
	movs	r2, #174
	str	r2, [r3, #2052]
	movs	r2, #0
	str	r2, [r3, #2048]
	movs	r2, #176
	b	.L1382
.L1344:
	movs	r2, #16
	b	.L1310
.L1386:
	.align	2
.L1385:
	.word	.LANCHOR20
	.word	.LANCHOR196
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR6
	.word	.LANCHOR147
	.word	.LC21
.L1313:
	cmp	r1, #6
	bhi	.L1315
.L1316:
	ldr	r3, .L1387
	ldr	lr, [r3]
	mov	r3, lr
.L1321:
	ldr	r1, [sp, #52]
	sub	r2, r3, lr
	cmp	r1, r2
	bgt	.L1322
	ldr	r3, .L1387
	ldr	r1, [r3]
	ldr	r3, [sp, #32]
	adds	r0, r1, r3
	movs	r3, #8
.L1324:
	mov	r7, r0
	movs	r6, #0
.L1323:
	ldr	r2, [r7]
	adds	r6, r6, #1
	mvns	r2, r2
	str	r2, [r7], #4
	ldr	r2, [sp, #12]
	cmp	r2, r6
	bgt	.L1323
	ldr	r2, [sp, #48]
	subs	r3, r3, #1
	add	r0, r0, r2
	bne	.L1324
	str	r1, [sp, #20]
	str	r3, [sp, #24]
.L1330:
	movs	r0, #0
	mov	r2, r0
.L1329:
	movs	r3, #1
	mov	ip, #0
	lsl	r7, r3, r2
	movs	r3, #16
	str	r3, [sp, #44]
	mov	r6, r7
	ldr	r7, [sp, #20]
.L1327:
	ldr	r3, [r7]
	bics	r3, r6, r3
	ldr	r3, [sp, #32]
	it	eq
	addeq	ip, ip, #1
	add	r7, r7, r3
	ldr	r3, [sp, #44]
	subs	r3, r3, #1
	str	r3, [sp, #44]
	bne	.L1327
	cmp	ip, #8
	add	r2, r2, #1
	itt	hi
	movhi	r3, r6
	orrhi	r0, r0, r3
	cmp	r2, #32
	bne	.L1329
	ldr	r3, [sp, #20]
	str	r0, [r3], #4
	str	r3, [sp, #20]
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	str	r3, [sp, #24]
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #12]
	cmp	r3, r2
	bgt	.L1330
	subs	r2, r1, #4
	add	r0, r1, #28
	movs	r3, #0
.L1333:
	ldr	r6, [r2, #4]!
	cbnz	r6, .L1332
	adds	r3, r3, #1
.L1332:
	cmp	r0, r2
	bne	.L1333
	cmp	r3, #7
	ble	.L1334
	ldr	r0, .L1387+4
	mov	r3, #1024
	movs	r2, #1
	bl	rknand_print_hex
	movs	r1, #0
	ldr	r0, .L1387+8
	bl	printf
.L1335:
	b	.L1335
.L1312:
	cmp	r4, #6
	bne	.L1316
	adds	r3, r3, #7
.L1318:
	ldrb	r2, [r1, #1]!	@ zero_extendqisi2
	cmp	r2, #12
	beq	.L1316
	ldrb	r2, [r1, #8]	@ zero_extendqisi2
	cmp	r2, #4
	beq	.L1316
	cmp	r3, r1
	bne	.L1318
	movs	r1, #0
	ldr	r0, .L1387+8
	bl	printf
.L1320:
	b	.L1320
.L1322:
	ldr	r2, [r5, #2048]
	strb	r2, [r3], #1
	b	.L1321
.L1334:
	cmp	r4, #6
	beq	.L1346
	cmp	r4, #7
	ite	eq
	moveq	ip, #10
	movne	ip, #8
.L1336:
	add	r3, fp, #-1
	ldr	r1, [sp, #36]
	uxtb	r3, r3
	movs	r0, #0
	adds	r3, r3, #1
.L1337:
	mov	r7, r1
	mov	r2, lr
.L1338:
	ldrb	r6, [r2], #1	@ zero_extendqisi2
	strb	r6, [r7], #1
	sub	r6, r2, lr
	uxtb	r6, r6
	cmp	fp, r6
	bhi	.L1338
	adds	r0, r0, #1
	add	lr, lr, r3
	cmp	r10, r0
	add	r1, r1, ip
	bgt	.L1337
	ldr	r3, [sp, #4]
	mov	r0, r8
	ldr	r2, [sp, #8]
	add	r6, r3, r2, lsl #8
	movs	r3, #255
	str	r3, [r6, #2056]
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #40]
	cmp	r3, #1
	bhi	.L1340
	movs	r3, #54
	mov	r1, #-1
	str	r3, [r6, #2056]
	ldr	r3, .L1387+12
	ldr	r0, [sp, #16]
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	str	r3, [r5, #2052]
	movs	r3, #0
	str	r3, [r5, #2048]
	movs	r3, #22
	str	r3, [r6, #2056]
	bl	FlashReadCmd
.L1341:
	mov	r0, r8
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	b	.L1384
.L1346:
	mov	ip, #4
	b	.L1336
.L1340:
	movs	r3, #56
	str	r3, [r6, #2056]
	b	.L1341
.L1388:
	.align	2
.L1387:
	.word	.LANCHOR147
	.word	.LC22
	.word	.LC21
	.word	.LANCHOR20
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
	cbz	r0, .L1389
	subs	r2, r0, #1
	cmp	r2, #6
	bhi	.L1391
	b	HynixGetReadRetryDefault
.L1391:
	cmp	r0, #49
	bne	.L1392
	ldr	r0, .L1412
	movs	r2, #64
	ldr	r1, .L1412+4
	strb	r3, [r0]
	movs	r3, #4
	strb	r3, [r0, #1]
	movs	r3, #15
	strb	r3, [r0, #2]
.L1410:
	adds	r0, r0, #4
	b	ftl_memcpy
.L1392:
	cmp	r0, #33
	beq	.L1393
	sub	r2, r0, #65
	cmp	r2, #1
	bhi	.L1394
.L1393:
	ldr	r0, .L1412
	strb	r3, [r0]
	movs	r3, #4
.L1411:
	strb	r3, [r0, #1]
	movs	r3, #7
	strb	r3, [r0, #2]
	movs	r2, #45
	ldr	r1, .L1412+8
	b	.L1410
.L1394:
	cmp	r0, #34
	beq	.L1395
	cmp	r0, #67
	bne	.L1396
.L1395:
	ldr	r0, .L1412
	strb	r3, [r0]
	movs	r3, #5
	b	.L1411
.L1396:
	cmp	r0, #35
	beq	.L1397
	cmp	r0, #68
	bne	.L1389
.L1397:
	ldr	r0, .L1412
	movs	r2, #95
	ldr	r1, .L1412+12
	strb	r3, [r0]
	movs	r3, #5
	strb	r3, [r0, #1]
	movs	r3, #17
	strb	r3, [r0, #2]
	b	.L1410
.L1389:
	bx	lr
.L1413:
	.align	2
.L1412:
	.word	.LANCHOR20
	.word	.LANCHOR14
	.word	.LANCHOR9
	.word	.LANCHOR11
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
	ldr	r3, .L1507
	ldr	r10, .L1507+132
	ldr	r8, .L1507+136
	str	r0, [r3]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L1507+4
	ldr	r6, .L1507+8
	ldr	r7, .L1507+12
	str	r0, [r3]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L1507+16
	str	r0, [r3]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L1507+20
	str	r0, [r3]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L1507+24
	ldr	r2, .L1507+28
	strb	r5, [r8]
	str	r0, [r3]
	movs	r3, #50
	strb	r3, [r10]
	mov	r0, r4
	strb	r3, [r2]
	movs	r2, #128
	ldr	r3, .L1507+32
	ldr	r4, .L1507+36
	strb	r5, [r7]
	str	r5, [r3]
	ldr	r3, .L1507+40
	str	r2, [r3]
	ldr	r3, .L1507+44
	str	r5, [r3]
	movs	r3, #60
	strb	r3, [r6]
	bl	NandcInit
	str	r10, [sp, #20]
	ldr	r10, .L1507+140
	str	r8, [sp, #16]
	mov	r8, r6
	mov	r6, r4
.L1419:
	uxtb	fp, r5
	mov	r0, fp
	bl	FlashReset
	add	r1, r10, r5, lsl #3
	ldr	r3, [r10, r5, lsl #3]
	mov	r0, fp
	ldrb	r1, [r1, #4]	@ zero_extendqisi2
	str	r3, [sp, #28]
	str	r1, [sp, #24]
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
	bhi	.L1415
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	ldr	r0, .L1507+48
	str	r1, [sp, #12]
	ldrb	r1, [r4, #4]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r4, #3]	@ zero_extendqisi2
	str	r1, [sp, #4]
	ldrb	r1, [r4, #2]	@ zero_extendqisi2
	str	r1, [sp]
	adds	r1, r5, #1
	bl	printf
.L1415:
	cbnz	r5, .L1416
	ldrb	r3, [r6]	@ zero_extendqisi2
	subs	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #253
	bhi	.L1460
	ldrb	r3, [r6, #1]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L1460
.L1416:
	ldrb	r3, [r4]	@ zero_extendqisi2
	adds	r5, r5, #1
	adds	r4, r4, #8
	cmp	r3, #181
	itt	eq
	moveq	r3, #44
	strbeq	r3, [r4, #-8]
	cmp	r5, #4
	bne	.L1419
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #173
	beq	.L1420
	ldr	r3, .L1507+52
	ldr	r0, [r3]
	bl	NandcSetDdrMode
.L1420:
	mov	r2, #852
	movs	r1, #0
	ldr	r0, .L1507+56
	bl	ftl_memset
	ldr	r4, .L1507+60
	ldr	r3, .L1507+64
	ldr	r5, .L1507+68
	str	r3, [r4]
	movs	r3, #0
	strb	r3, [r5]
	ldrb	r3, [r6, #1]	@ zero_extendqisi2
	cmp	r3, #161
	beq	.L1421
	cmp	r3, #218
	beq	.L1421
	and	r2, r3, #223
	cmp	r2, #209
	beq	.L1421
	cmp	r3, #220
	bne	.L1422
	ldrb	r2, [r6, #3]	@ zero_extendqisi2
	cmp	r2, #149
	bne	.L1422
.L1421:
	ldr	r1, [sp, #16]
	movs	r2, #1
	strb	r2, [r1]
	movs	r2, #16
	ldr	r1, [sp, #20]
	strb	r2, [r8]
	strb	r2, [r1]
	ldrb	r1, [r6]	@ zero_extendqisi2
	ldr	r2, .L1507+72
	cmp	r1, #152
	strb	r1, [r2, #1]
	strb	r3, [r2, #2]
	bne	.L1423
	ldrsb	r1, [r6, #4]
	cmp	r1, #0
	itt	ge
	movge	r1, #24
	strbge	r1, [r8]
.L1423:
	ldr	r1, .L1507+76
	ldr	r0, .L1507+80
	ldr	r1, [r1]
	cmp	r1, r0
	beq	.L1424
	movw	r0, #2049
	cmp	r1, r0
	bne	.L1425
.L1424:
	movs	r1, #16
	strb	r1, [r8]
.L1425:
	cmp	r3, #218
	bne	.L1426
	mov	r1, #2048
.L1503:
	strh	r1, [r2, #14]	@ movhi
	strb	r3, [r2, #2]
.L1427:
	movs	r2, #32
	ldr	r1, .L1507+84
	ldr	r0, .L1507+88
	bl	ftl_memcpy
	movs	r2, #32
	ldr	r1, .L1507+72
	ldr	r0, .L1507+64
	bl	ftl_memcpy
.L1422:
	ldr	r3, [sp, #16]
	ldr	r8, .L1507+144
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1429
	bl	FlashLoadPhyInfoInRam
	cbnz	r0, .L1431
	ldr	r3, [r4]
	ldr	r10, .L1507+100
	ldrh	r3, [r3, #16]
	lsrs	r3, r3, #8
	lsls	r1, r3, #31
	and	r0, r3, #7
	strb	r0, [r10]
	bmi	.L1431
	movs	r3, #1
	strb	r3, [r7]
	bl	FlashSetInterfaceMode
	ldrb	r0, [r10]	@ zero_extendqisi2
	bl	NandcSetMode
.L1431:
	ldr	r3, [r4]
	ldrb	r3, [r3, #26]	@ zero_extendqisi2
	strb	r3, [r8]
	bl	FlashLoadPhyInfo
	cmp	r0, #0
	beq	.L1429
	ldr	r3, [r4]
	ldr	r0, .L1507+92
	ldrh	r1, [r3, #14]
	bl	printf
	bl	FlashLoadPhyInfoInRam
	adds	r2, r0, #1
	beq	.L1414
	bl	FlashDieInfoInit
	ldr	r3, [r4]
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	bl	FlashGetReadRetryDefault
	ldr	r3, [r4]
	ldr	r2, .L1507+96
	ldrb	r1, [r3, #9]	@ zero_extendqisi2
	ldrh	r2, [r2]
	addw	r2, r2, #4095
	cmp	r1, r2, asr #12
	blt	.L1434
	ldrh	r2, [r3, #14]
	adds	r2, r2, #255
	cmp	r1, r2, asr #8
	bge	.L1435
.L1434:
	ldrh	r2, [r3, #14]
	bic	r2, r2, #255
	strh	r2, [r3, #14]	@ movhi
.L1435:
	ldr	r3, .L1507+100
	ldrb	r3, [r3]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L1436
	bl	FlashSavePhyInfo
	ldr	r3, .L1507+104
	movs	r0, #0
	ldr	r1, [r3]
	bl	FlashDdrParaScan
.L1436:
	bl	FlashSavePhyInfo
.L1429:
	ldr	fp, [r4]
	ldr	r10, .L1507+100
	ldrb	r3, [fp, #26]	@ zero_extendqisi2
	ldrh	r0, [fp, #10]
	strb	r3, [r8]
	ldrh	r3, [fp, #16]
	ubfx	r2, r3, #7, #1
	ubfx	r1, r3, #3, #1
	strb	r2, [r5]
	ldr	r2, .L1507+108
	ldr	r5, .L1507+112
	strb	r1, [r2]
	ubfx	r1, r3, #4, #1
	ldr	r2, .L1507+116
	ubfx	r3, r3, #8, #3
	strb	r3, [r10]
	movs	r3, #0
	str	r3, [r5]
	strb	r1, [r2]
	ldrb	r1, [fp, #12]	@ zero_extendqisi2
	bl	__aeabi_idiv
	mov	r1, r0
	ldrb	r0, [fp, #18]	@ zero_extendqisi2
	bl	BuildFlashLsbPageTable
	bl	FlashDieInfoInit
	ldr	r3, [r4]
	mov	ip, r5
	ldrh	r2, [r3, #16]
	tst	r2, #64
	beq	.L1438
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	ldr	r3, .L1507+120
	ldr	r2, .L1507+124
	strb	r0, [r3]
	ldr	r3, .L1507+56
	ldrb	r1, [r3, #1]	@ zero_extendqisi2
	ldrb	lr, [r3, #2]	@ zero_extendqisi2
	strb	r1, [r2]
	ldr	r1, .L1507+128
	strb	lr, [r1]
	b	.L1508
.L1509:
	.align	2
.L1507:
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
	.word	.LANCHOR5
	.word	.LANCHOR200
	.word	.LANCHOR29
	.word	1446522928
	.word	.LANCHOR143+32
	.word	.LANCHOR7
	.word	.LC24
	.word	.LANCHOR122
	.word	.LANCHOR24
	.word	.LANCHOR148
	.word	.LANCHOR201
	.word	.LANCHOR145
	.word	.LANCHOR27
	.word	.LANCHOR10
	.word	.LANCHOR13
	.word	.LANCHOR151
	.word	.LANCHOR2
	.word	.LANCHOR1
	.word	.LANCHOR6
	.word	.LANCHOR8
.L1508:
	add	lr, r0, #-1
	cmp	lr, #6
	mov	lr, r1
	bhi	.L1439
	ldr	r2, .L1510
	str	r2, [r5]
	subs	r2, r0, #5
	cmp	r2, #1
	bhi	.L1440
	ldr	r2, .L1510+4
	adds	r3, r3, #20
	movs	r1, #1
	str	r1, [r2]
.L1441:
	subs	r1, r3, #1
	movs	r2, #0
	adds	r3, r3, #31
.L1443:
	ldrsb	r5, [r1, #1]!
	cbnz	r5, .L1442
	adds	r2, r2, #1
.L1442:
	cmp	r3, r1
	bne	.L1443
	cmp	r2, #27
	bls	.L1438
	bl	FlashGetReadRetryDefault
	bl	FlashSavePhyInfo
.L1438:
	ldr	r3, .L1510+8
	ldr	r2, [r3]
	ldr	r3, .L1510+12
	cmp	r2, r3
	bne	.L1454
	ldrb	r3, [r8]	@ zero_extendqisi2
	cbz	r3, .L1454
	ldr	r3, [r4]
	movs	r2, #0
	strb	r2, [r3, #18]
.L1454:
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #44
	bne	.L1455
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbz	r3, .L1455
	movs	r3, #0
	movs	r0, #1
	strb	r3, [r7]
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
.L1455:
	movs	r0, #0
	bl	flash_enter_slc_mode
	ldrb	r3, [r10]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L1456
	ldrb	r2, [r7]	@ zero_extendqisi2
	cbnz	r2, .L1457
	lsls	r3, r3, #31
	bmi	.L1456
.L1457:
	ldr	r3, .L1510+16
	movs	r0, #0
	ldr	r1, [r3]
	bl	FlashDdrParaScan
.L1456:
	movs	r0, #0
	movs	r7, #16
	bl	flash_exit_slc_mode
	ldr	r3, [r4]
	ldrb	r0, [r3, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	ldr	r0, .L1510+20
	bl	FlashReadIdbDataRaw
	ldr	r8, [r4]
	ldr	r3, [sp, #20]
	ldr	r4, .L1510+24
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
	ldr	r3, .L1510+28
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
	bne	.L1458
	lsls	r3, r3, #1
	lsrs	r2, r6, #1
	lsls	r5, r5, #1
	strh	r3, [r4, #20]	@ movhi
	movs	r3, #8
	strh	r2, [r4, #14]	@ movhi
	strh	r5, [r4, #22]	@ movhi
	strh	r3, [r4, #26]	@ movhi
.L1458:
	ldrb	r0, [r8, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r0, #0
.L1414:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1426:
	cmp	r3, #220
	bne	.L1427
	mov	r1, #4096
	b	.L1503
.L1440:
	add	r2, r3, #28
	adds	r3, r3, #20
	cmp	r0, #7
	it	eq
	moveq	r3, r2
	b	.L1441
.L1439:
	sub	r3, r0, #17
	cmp	r3, #2
	bhi	.L1445
	ldr	r3, .L1510+32
	cmp	r0, #19
	str	r3, [r5]
	ite	ne
	movne	r3, #7
	moveq	r3, #15
	strb	r3, [r1]
	b	.L1438
.L1445:
	cmp	r0, #33
	beq	.L1447
	sub	r3, r0, #65
	cmp	r3, #1
	bhi	.L1448
.L1447:
	ldr	r3, .L1510+36
	str	r3, [ip]
	movs	r3, #4
	strb	r3, [r2]
	movs	r3, #7
	strb	r3, [lr]
	b	.L1438
.L1448:
	sub	r3, r0, #67
	uxtb	r3, r3
	cmp	r3, #1
	bls	.L1449
	sub	r1, r0, #34
	cmp	r1, #1
	bhi	.L1450
.L1449:
	ldr	r1, .L1510+36
	cmp	r0, #35
	str	r1, [ip]
	ldr	r1, .L1510+40
	beq	.L1451
	cmp	r0, #68
	beq	.L1451
	movs	r0, #7
.L1504:
	cmp	r3, #1
	strb	r0, [r1]
	ite	ls
	movls	r3, #4
	movhi	r3, #5
	strb	r3, [r2]
	b	.L1438
.L1451:
	movs	r0, #17
	b	.L1504
.L1450:
	cmp	r0, #49
	itt	eq
	ldreq	r3, .L1510+44
	streq	r3, [r5]
	b	.L1438
.L1460:
	mvn	r0, #1
	b	.L1414
.L1511:
	.align	2
.L1510:
	.word	HynixReadRetrial
	.word	.LANCHOR36
	.word	.LANCHOR29
	.word	1446522928
	.word	.LANCHOR148
	.word	.LANCHOR141
	.word	.LANCHOR15
	.word	.LANCHOR25
	.word	MicronReadRetrial
	.word	ToshibaReadRetrial
	.word	.LANCHOR151
	.word	SamsungReadRetrial
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
	ldr	r3, .L1541
	mov	fp, r2
	mov	r4, r0
	movs	r7, #0
	ldrb	r10, [r3, #9]	@ zero_extendqisi2
.L1513:
	cmp	r7, r8
	bne	.L1526
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1526:
	sub	r3, r8, r7
	add	r2, sp, #12
	uxtb	r3, r3
	mov	r1, fp
	mov	r0, r4
	str	r3, [sp]
	add	r3, sp, #8
	bl	LogAddr2PhyAddr
	ldr	r2, .L1541+4
	ldr	r3, [sp, #8]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1514
	mov	r3, #-1
	str	r3, [r4]
.L1515:
	adds	r7, r7, #1
	adds	r4, r4, #36
	b	.L1513
.L1514:
	ldr	r2, .L1541+8
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
	ldr	r3, .L1541+12
	mov	r6, r0
	ldr	r1, [sp, #12]
	mov	r0, r5
	ldr	r3, [r3]
	add	r1, r1, r3
	bl	FlashReadCmd
	ldr	r3, [r4, #8]
	cbz	r3, .L1516
	add	r3, r3, #2048
.L1516:
	ldr	r2, [r4, #12]
	cbz	r2, .L1517
	adds	r2, r2, #8
.L1517:
	str	r2, [sp]
	movs	r1, #0
	mov	r2, r10
	mov	r0, r5
	bl	NandcXferData
	mov	r1, r0
	mov	r0, r5
	bl	NandcFlashDeCs
	ldr	r3, .L1541+16
	cmp	r6, r1
	it	cc
	movcc	r6, r1
	ldrb	r2, [r3]	@ zero_extendqisi2
	add	r3, r2, r2, lsl #1
	cmp	r6, r3, asr #2
	bls	.L1518
	adds	r5, r6, #1
	it	ne
	movne	r6, #256
	str	r6, [r4]
.L1521:
	ldr	r3, [r4, #12]
	cbz	r3, .L1522
	ldr	r1, [r3, #12]
	adds	r1, r1, #1
	bne	.L1522
	ldr	r1, [r3, #8]
	adds	r0, r1, #1
	bne	.L1522
	ldr	r3, [r3]
	adds	r3, r3, #1
	it	ne
	strne	r1, [r4]
.L1522:
	ldr	r3, [r4]
	adds	r1, r3, #1
	bne	.L1515
	ldr	r1, [r4, #4]
	ldr	r0, .L1541+20
	bl	printf
	ldr	r1, [r4, #8]
	cbz	r1, .L1524
	movs	r3, #8
	movs	r2, #4
	ldr	r0, .L1541+24
	bl	rknand_print_hex
.L1524:
	ldr	r1, [r4, #12]
	cmp	r1, #0
	beq	.L1515
	movs	r3, #4
	ldr	r0, .L1541+28
	mov	r2, r3
	bl	rknand_print_hex
	b	.L1515
.L1518:
	movs	r3, #0
	str	r3, [r4]
	b	.L1521
.L1542:
	.align	2
.L1541:
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
	ldr	r3, .L1634
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	mov	r10, r0
	str	r1, [sp, #24]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [sp, #12]
	cbnz	r3, .L1544
	ldr	r2, .L1634+4
	mov	r8, r3
	str	r3, [sp, #8]
	ldrb	r2, [r2, #9]	@ zero_extendqisi2
	str	r2, [sp, #20]
	ldr	r2, .L1634+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #28]
.L1545:
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #24]
	cmp	r3, r2
	bcc	.L1583
	movs	r0, #0
	b	.L1543
.L1544:
	bl	FlashReadSlc2KPages
.L1543:
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1583:
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
	ldr	r2, .L1634+12
	mov	r5, r0
	ldr	r3, [sp, #32]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1547
	mov	r3, #-1
	str	r3, [r10, fp]
.L1548:
	ldr	r3, [sp, #8]
	adds	r3, r3, #1
	str	r3, [sp, #8]
	b	.L1545
.L1547:
	ldr	r2, .L1634+16
	ldrb	r4, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1634+20
	mov	r0, r4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	it	eq
	moveq	r5, #0
	bl	NandcWaitFlashReady
	ldr	r3, .L1634+24
	ldr	r3, [r3]
	ldrb	r1, [r3, #19]	@ zero_extendqisi2
	subs	r3, r1, #1
	cmp	r3, #6
	bhi	.L1550
	ldr	r3, .L1634+28
	cmp	r1, #7
	add	r2, r3, r4
	ldrb	r3, [r2, #12]	@ zero_extendqisi2
	it	eq
	ldrbeq	r3, [r2, #20]	@ zero_extendqisi2
	ldr	r2, .L1634+32
	ldrb	r2, [r2, r4]	@ zero_extendqisi2
	cmp	r2, r3
	beq	.L1550
	ldr	r2, .L1634+36
	mov	r0, r4
	ldrb	r1, [r2, #-3]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1550:
	mov	r0, r4
	bl	NandcFlashCs
	ldr	r3, [sp, #12]
	cmp	r3, #1
	beq	.L1552
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1553
.L1552:
	ldr	r3, .L1634+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1553
	mov	r0, r4
	bl	flash_enter_slc_mode
.L1560:
	ldr	r1, [sp, #36]
	adds	r6, r1, #1
	bne	.L1555
	cmp	r4, #255
	beq	.L1585
.L1555:
	cbz	r5, .L1557
	ldr	r3, .L1634+44
	mov	r0, r4
	ldr	r2, [r3]
	add	r2, r2, r1
	bl	FlashReadDpCmd
.L1558:
	mov	r0, r4
	bl	NandcWaitFlashReady
	cbz	r5, .L1556
	ldr	r1, [sp, #36]
	mov	r0, r4
	bl	FlashReadDpDataOutCmd
.L1556:
	ldr	r3, [r7, #12]
	movs	r1, #0
	ldr	r2, [sp, #20]
	mov	r0, r4
	str	r3, [sp]
	ldr	r3, [r7, #8]
	bl	NandcXferData
	ldr	r3, .L1634+8
	mov	r6, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1559
	adds	r0, r0, #1
	bne	.L1559
	ldr	r3, .L1634+8
	movs	r5, #0
	strb	r5, [r3]
	b	.L1560
.L1553:
	mov	r0, r4
	bl	flash_exit_slc_mode
	b	.L1560
.L1557:
	mov	r0, r4
	bl	FlashReadCmd
	b	.L1558
.L1585:
	movs	r5, #0
	b	.L1556
.L1559:
	cbz	r5, .L1561
	ldr	r3, .L1634+44
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
.L1561:
	mov	r0, r4
	bl	NandcFlashDeCs
	ldr	r3, .L1634+8
	adds	r1, r6, #1
	ldrb	r2, [sp, #28]	@ zero_extendqisi2
	strb	r2, [r3]
	bne	.L1562
	ldr	r3, .L1634+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1563
.L1567:
	ldr	r3, .L1634+52
	ldr	r5, [r3]
	cmp	r5, #0
	bne	.L1564
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	bl	FlashReadRawPage
	b	.L1633
.L1563:
	ldr	r3, .L1634+56
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
	beq	.L1566
	ldr	r3, .L1634+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3, lsr #1
	bls	.L1586
.L1566:
	ubfx	r0, r5, #8, #8
	bl	NandcSetDdrPara
	adds	r3, r6, #1
	beq	.L1567
.L1586:
	movs	r5, #0
.L1562:
	ldr	r3, .L1634+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r6, r3, asr #2
	bls	.L1575
	ldr	r3, .L1634+52
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L1575
	mov	r6, #256
	b	.L1570
.L1635:
	.align	2
.L1634:
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
	.word	.LANCHOR8
	.word	.LANCHOR3
	.word	.LANCHOR30
	.word	.LANCHOR145
	.word	.LANCHOR19
	.word	.LANCHOR33
.L1564:
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	blx	r5
	adds	r5, r0, #1
	mov	r6, r0
	bne	.L1568
	ldr	r3, .L1636
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #6
	bhi	.L1569
	ldr	r2, .L1636+4
	movs	r3, #0
	mov	r0, r4
	ldrb	r1, [r2, #-3]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1569:
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	bl	FlashReadRawPage
	ldr	r2, .L1636+8
	mov	r6, r0
	mov	r3, r0
	ldr	r1, [r7, #4]
	ldr	r0, .L1636+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	bl	printf
	adds	r0, r6, #1
	bne	.L1568
	ldr	r3, .L1636+16
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L1570
	ldr	r3, [sp, #12]
	mov	r0, r4
	cmp	r3, #1
	beq	.L1571
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1572
.L1571:
	bl	flash_enter_slc_mode
.L1573:
	ldr	r3, .L1636+20
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	ldr	r5, [r3]
	ldr	r3, [r7, #12]
	blx	r5
.L1633:
	adds	r1, r0, #1
	mov	r6, r0
	mov	r5, #0
	bne	.L1575
.L1570:
	str	r6, [r10, fp]
.L1576:
	ldr	r3, [r10, fp]
	adds	r2, r3, #1
	bne	.L1578
	ldr	r2, .L1636+8
	ldr	r1, [r7, #4]
	ldr	r0, .L1636+24
	ldrb	r2, [r2]	@ zero_extendqisi2
	bl	printf
	ldr	r1, [r7, #12]
	cbz	r1, .L1578
	movs	r3, #4
	ldr	r0, .L1636+28
	mov	r2, r3
	bl	rknand_print_hex
.L1578:
	cbz	r5, .L1580
	ldr	r3, .L1636+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r8, r3, asr #2
	bls	.L1581
	ldr	r3, .L1636+20
	ldr	r3, [r3]
	cmp	r3, #0
	it	eq
	moveq	r8, #256
.L1581:
	cmp	r8, #-1
	add	r3, fp, #36
	str	r8, [r10, r3]
	beq	.L1580
	cmp	r8, #256
	itt	ne
	movne	r2, #0
	strne	r2, [r10, r3]
.L1580:
	ldr	r3, [sp, #8]
	add	r3, r3, r5
	str	r3, [sp, #8]
	ldr	r3, [sp, #12]
	cmp	r3, #1
	beq	.L1582
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1548
.L1582:
	ldr	r3, .L1636+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1548
	mov	r0, r4
	bl	flash_exit_slc_mode
	b	.L1548
.L1572:
	bl	flash_exit_slc_mode
	b	.L1573
.L1568:
	movs	r5, #0
.L1575:
	cmp	r6, #256
	beq	.L1570
	movs	r3, #0
	str	r3, [r10, fp]
	b	.L1576
.L1637:
	.align	2
.L1636:
	.word	.LANCHOR18
	.word	.LANCHOR20+4
	.word	.LANCHOR33
	.word	.LC28
	.word	.LANCHOR8
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
	ldr	r3, .L1667
	movs	r7, #0
	ldr	fp, .L1667+28
	str	r2, [sp, #8]
	ldrb	r10, [r3, #9]	@ zero_extendqisi2
.L1639:
	cmp	r7, r8
	bne	.L1645
	ldr	r3, [sp, #12]
	cmp	r3, #0
	bne	.L1656
.L1666:
	movs	r0, #0
	add	sp, sp, #64
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1645:
	sub	r3, r8, r7
	add	r2, sp, #20
	uxtb	r3, r3
	ldr	r1, [sp, #8]
	mov	r0, r6
	str	r3, [sp]
	add	r3, sp, #24
	bl	LogAddr2PhyAddr
	ldr	r2, .L1667+4
	ldr	r3, [sp, #24]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1640
	mov	r3, #-1
	str	r3, [r6]
.L1641:
	adds	r7, r7, #1
	adds	r6, r6, #36
	b	.L1639
.L1640:
	ldr	r2, .L1667+8
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
	cbz	r3, .L1642
	add	r3, r3, #2048
.L1642:
	ldr	r2, [r6, #12]
	cbz	r2, .L1643
	adds	r2, r2, #8
.L1643:
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
	b	.L1641
.L1652:
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1647
	ldr	r1, [r4, #4]
	ldr	r0, .L1667+12
	bl	printf
.L1648:
	add	r8, r8, #1
	adds	r4, r4, #36
.L1646:
	cmp	r7, r8
	bne	.L1652
	b	.L1666
.L1647:
	sub	r3, r7, r8
	ldr	fp, .L1667+32
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
	bne	.L1649
	ldr	r1, [r4, #4]
	ldr	r0, .L1667+16
	bl	printf
	str	r5, [r4]
.L1649:
	ldr	r3, [r4, #12]
	cbz	r3, .L1650
	ldr	r2, [r3]
	ldr	r3, [fp]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1650
	ldr	r1, [r4, #4]
	ldr	r0, .L1667+20
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L1650:
	ldr	r3, [r4, #8]
	cmp	r3, #0
	beq	.L1648
	ldr	r2, [r3]
	ldr	r3, [r10]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1648
	ldr	r1, [r4, #4]
	ldr	r0, .L1667+24
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
	b	.L1648
.L1656:
	mov	r8, #0
	ldr	r10, .L1667+36
	b	.L1646
.L1668:
	.align	2
.L1667:
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
	ldr	r5, .L1721
	mov	r4, r0
	mov	r8, r2
	str	r1, [sp, #8]
	ldr	r5, [r5]
	str	r3, [sp, #20]
	ldrb	r5, [r5, #19]	@ zero_extendqisi2
	str	r5, [sp, #16]
	ldr	r5, .L1721+4
	ldrb	r7, [r5]	@ zero_extendqisi2
	cbnz	r7, .L1670
	ldr	r3, .L1721+8
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	str	r3, [sp, #12]
.L1671:
	ldr	r3, [sp, #8]
	cmp	r7, r3
	bcc	.L1684
	ldr	r6, .L1721+12
	movs	r5, #0
	ldr	r7, .L1721+16
.L1685:
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r5, r3
	bcc	.L1687
	ldr	r3, [sp, #20]
	cmp	r3, #0
	bne	.L1688
.L1696:
	movs	r0, #0
	b	.L1669
.L1670:
	bl	FlashProgSlc2KPages
.L1669:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1684:
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
	ldr	r3, .L1721+12
	mov	r10, r0
	ldr	r0, [sp, #32]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L1673
	mov	r3, #-1
	str	r3, [r4, r6]
.L1674:
	adds	r7, r7, #1
	b	.L1671
.L1673:
	ldr	r3, .L1721+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	ldr	r3, .L1721+24
	it	eq
	moveq	r10, #0
	add	r3, r3, r0, lsl #4
	ldr	r3, [r3, #8]
	cbz	r3, .L1676
	uxtb	r0, r0
	bl	FlashWaitCmdDone
.L1676:
	ldr	r3, [sp, #32]
	movs	r1, #0
	ldr	r2, .L1721+24
	add	r2, r2, r3, lsl #4
	str	r1, [r2, #12]
	ldr	r1, [sp, #28]
	str	fp, [r2, #8]
	str	r1, [r2, #4]
	cmp	r10, #0
	beq	.L1677
	add	r1, r6, #36
	add	r1, r1, r4
	str	r1, [r2, #12]
.L1677:
	ldr	r2, .L1721+28
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	lsls	r3, r3, #4
	ldr	r2, .L1721+24
	mov	r0, r5
	strb	r5, [r2, r3]
	ldr	r3, .L1721+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1678
	bl	NandcWaitFlashReady
.L1679:
	ldr	r3, [sp, #16]
	subs	r3, r3, #1
	cmp	r3, #6
	bhi	.L1680
	ldr	r3, .L1721+32
	ldrb	r3, [r3, r5]	@ zero_extendqisi2
	cbz	r3, .L1680
	ldr	r1, .L1721+36
	movs	r3, #0
	mov	r0, r5
	adds	r2, r1, #4
	ldrb	r1, [r1, #1]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1680:
	mov	r0, r5
	bl	NandcFlashCs
	cmp	r8, #1
	mov	r0, r5
	bne	.L1681
	ldr	r3, .L1721+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1681
	bl	flash_enter_slc_mode
.L1682:
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
	beq	.L1683
	ldr	r1, [sp, #28]
	mov	r0, r5
	bl	FlashProgDpFirstCmd
	ldr	r3, .L1721+40
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
	ldr	r3, .L1721+44
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
.L1683:
	ldr	r1, [sp, #28]
	mov	r0, r5
	bl	FlashProgSecondCmd
	mov	r0, r5
	add	r7, r7, r10
	bl	NandcFlashDeCs
	b	.L1674
.L1678:
	bl	NandcFlashCs
	ldr	r2, [sp, #32]
	mov	r0, r5
	ldr	r3, .L1721+40
	ldr	r1, [sp, #28]
	ldr	r2, [r3, r2, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	mov	r0, r5
	bl	NandcFlashDeCs
	b	.L1679
.L1681:
	bl	flash_exit_slc_mode
	b	.L1682
.L1687:
	uxtb	r0, r5
	bl	FlashWaitCmdDone
	cmp	r8, #1
	bne	.L1686
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbz	r3, .L1686
	ldr	r2, .L1721+24
	lsls	r3, r5, #4
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	flash_exit_slc_mode
.L1686:
	adds	r5, r5, #1
	b	.L1685
.L1688:
	ldr	r10, .L1721+64
	movs	r7, #0
.L1689:
	ldr	r3, [sp, #8]
	cmp	r7, r3
	beq	.L1696
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1690
	ldr	r1, [r4, #4]
	ldr	r0, .L1721+48
	bl	printf
.L1691:
	adds	r7, r7, #1
	adds	r4, r4, #36
	b	.L1689
.L1690:
	ldr	r3, [sp, #8]
	add	r2, sp, #28
	ldr	fp, .L1721+68
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
	bne	.L1692
	ldr	r1, [r4, #4]
	ldr	r0, .L1721+52
	bl	printf
	str	r5, [r4]
.L1692:
	ldr	r3, [r4, #12]
	cbz	r3, .L1693
	ldr	r2, [r3]
	ldr	r3, [fp]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1693
	ldr	r1, [r4, #4]
	ldr	r0, .L1721+56
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L1693:
	ldr	r3, [r4, #8]
	cmp	r3, #0
	beq	.L1691
	ldr	r2, [r3]
	ldr	r3, [r10]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1691
	ldr	r1, [r4, #4]
	ldr	r0, .L1721+60
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
	b	.L1691
.L1722:
	.align	2
.L1721:
	.word	.LANCHOR18
	.word	.LANCHOR1
	.word	.LANCHOR31
	.word	.LANCHOR25
	.word	.LANCHOR8
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
	ldr	r3, .L1726
	push	{r4, r5, lr}
	mov	r4, r0
	sub	sp, sp, #108
	ldr	r3, [r3]
	cmp	r0, r3
	bcc	.L1725
	ldr	r5, .L1726+4
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
.L1723:
	mov	r0, r4
	add	sp, sp, #108
	@ sp needed
	pop	{r4, r5, pc}
.L1725:
	movs	r4, #0
	b	.L1723
.L1727:
	.align	2
.L1726:
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
	ldr	r3, .L1773
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	str	r0, [sp, #8]
	ldr	r3, [r3]
	str	r1, [sp, #4]
	cmp	r3, #0
	bne	.L1755
	ldr	r2, .L1773+4
	mov	r10, r3
	mov	r5, r3
	mov	r4, r3
	mov	r8, #36
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #20]
	ldr	r2, .L1773+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #12]
	ldr	r2, .L1773+12
	str	r0, [r2]
	ldr	r2, .L1773+16
	ldrh	fp, [r2]
	ldr	r2, .L1773+20
	ldr	r7, [r2]
	ldr	r2, .L1773+24
	ldr	r2, [r2]
	str	r2, [sp, #16]
	ldr	r2, .L1773+28
	ldrh	r2, [r2]
	str	r2, [sp, #24]
.L1730:
	uxth	r2, r10
	cmp	fp, r2
	bhi	.L1734
	cmp	r5, #0
	beq	.L1728
	ldr	r3, [sp, #12]
	mov	r0, r7
	ldr	r10, .L1773+4
	mov	r8, #0
	mov	r2, r5
	ldr	r7, .L1773+20
	adds	r6, r3, #0
	it	ne
	movne	r6, #1
	strb	r8, [r10]
	mov	r1, r6
	bl	FlashEraseBlocks
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	strb	r3, [r10]
	mov	r10, #36
.L1736:
	uxth	r3, r8
	cmp	r5, r3
	bhi	.L1738
	ldr	r3, [sp, #4]
	cmp	r3, #0
	bne	.L1739
	uxth	r6, r6
	movs	r3, #6
	str	r3, [sp, #16]
	movs	r3, #1
	str	r3, [sp, #12]
.L1740:
	mov	r8, #0
.L1749:
	ldr	r3, .L1773+16
	mov	fp, #0
	mov	r5, fp
	ldrh	r3, [r3]
	str	r3, [sp, #24]
	ldr	r3, .L1773+20
	ldr	r10, [r3]
	ldr	r3, .L1773+32
	ldr	r3, [r3]
	str	r3, [sp, #28]
	ldr	r3, .L1773+36
	ldr	r3, [r3]
	str	r3, [sp, #32]
	ldr	r3, .L1773+28
	ldrh	r3, [r3]
	str	r3, [sp, #36]
.L1741:
	ldr	r3, [sp, #24]
	uxth	r2, fp
	cmp	r3, r2
	bhi	.L1744
	cbz	r5, .L1728
	ldr	fp, .L1773+4
	movs	r3, #1
	mov	r0, r10
	movs	r7, #0
	mov	r2, r6
	mov	r1, r5
	strb	r7, [fp]
	bl	FlashProgPages
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	ldr	r10, .L1773+20
	strb	r3, [fp]
	mov	fp, #36
.L1746:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L1748
	ldr	r3, [sp, #16]
	add	r8, r8, r3
	ldr	r3, [sp, #12]
	uxth	r8, r8
	cmp	r3, r8
	bhi	.L1749
	ldr	r8, .L1773+20
	movs	r7, #0
	mov	r10, #36
.L1750:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L1752
	ldr	r3, [sp, #8]
	cmp	r3, #63
	bls	.L1753
	ldr	r3, [sp, #4]
	cbz	r3, .L1728
.L1753:
	ldr	r3, .L1773+20
	mov	r2, r5
	mov	r1, r6
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L1728:
	mov	r0, r4
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1734:
	mul	r2, r8, r10
	movs	r3, #0
	ldr	r1, [sp, #8]
	str	r3, [r7, r2]
	ldr	r3, .L1773+40
	ldrb	r0, [r3, r10]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r3, [sp, #4]
	mov	r6, r0
	cbz	r3, .L1731
	bl	IsBlkInVendorPart
	cbnz	r0, .L1732
.L1731:
	mov	r0, r6
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1733
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
.L1732:
	add	r10, r10, #1
	b	.L1730
.L1733:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L1732
.L1738:
	mul	r3, r10, r8
	ldr	r2, [r7]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	adds	r3, r3, #1
	bne	.L1737
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L1737:
	add	r8, r8, #1
	b	.L1736
.L1739:
	ldr	r3, .L1773+44
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1773+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1756
	ldr	r3, [sp, #12]
	movs	r6, #1
	lsrs	r3, r3, #2
	str	r3, [sp, #16]
	b	.L1740
.L1756:
	movs	r6, #1
	str	r6, [sp, #16]
	b	.L1740
.L1744:
	movs	r3, #36
	ldr	r1, [sp, #8]
	mul	r2, r3, fp
	movs	r3, #0
	str	r3, [r10, r2]
	ldr	r3, .L1773+40
	ldrb	r0, [r3, fp]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r3, [sp, #4]
	mov	r7, r0
	cbz	r3, .L1742
	bl	IsBlkInVendorPart
	cbnz	r0, .L1743
.L1742:
	mov	r0, r7
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1743
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
.L1743:
	add	fp, fp, #1
	b	.L1741
.L1748:
	mul	r3, fp, r7
	ldr	r2, [r10]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbz	r3, .L1747
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L1747:
	adds	r7, r7, #1
	b	.L1746
.L1752:
	ldr	r3, [sp, #4]
	cbz	r3, .L1751
	mul	r3, r10, r7
	ldr	r2, [r8]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbnz	r3, .L1751
	ldr	r0, [r1, #4]
	movs	r1, #1
	ubfx	r0, r0, #10, #16
	bl	FtlFreeSysBlkQueueIn
.L1751:
	adds	r7, r7, #1
	b	.L1750
.L1755:
	movs	r4, #0
	b	.L1728
.L1774:
	.align	2
.L1773:
	.word	.LANCHOR77
	.word	.LANCHOR27
	.word	.LANCHOR8
	.word	.LANCHOR74
	.word	.LANCHOR38
	.word	.LANCHOR78
	.word	.LANCHOR189
	.word	.LANCHOR59
	.word	.LANCHOR186
	.word	.LANCHOR187
	.word	.LANCHOR47
	.word	.LANCHOR54
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
	ldr	r3, .L1786
	ldr	r4, [r3]
	str	r3, [sp, #12]
	cmp	r4, #0
	bne	.L1777
	ldr	r3, .L1786+4
	mov	r1, r4
	ldr	r7, .L1786+8
	ldr	r5, .L1786+12
	ldr	r3, [r3]
	ldr	r0, [r7]
	mov	r8, r7
	ldr	r6, .L1786+16
	str	r3, [r5, #12]
	ldr	r7, .L1786+20
	ldr	r3, .L1786+24
	ldr	r10, .L1786+56
	str	r0, [r5, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
.L1778:
	ldrh	r3, [r7]
	cmp	r4, r3
	blt	.L1779
	ldr	r6, [r5, #12]
	movs	r2, #16
	ldr	r4, .L1786+28
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
	ldr	r3, .L1786+32
	ldr	r3, [r3]
	strh	r3, [r6, #12]	@ movhi
.L1780:
	ldr	r3, [r8]
	mov	fp, #0
	ldrh	r2, [r4, #2]
	ldrh	r1, [r4]
	str	r3, [r5, #8]
	ldr	r3, .L1786+4
	ldrh	r0, [r6, #10]
	str	fp, [r5]
	ldr	r3, [r3]
	str	r3, [r5, #12]
	orr	r3, r2, r1, lsl #10
	str	r3, [r5, #4]
	ldrh	r3, [r4, #4]
	str	r0, [sp]
	ldr	r0, .L1786+36
	bl	printf
	ldr	r3, .L1786+40
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1781
	ldr	r3, [r4, #8]
	ldrh	r2, [r4]
	strh	fp, [r4, #2]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #8]
	str	r3, [r6, #4]
	strh	r2, [r6, #8]	@ movhi
	ldrh	r3, [r4, #4]
	strh	r2, [r4, #4]	@ movhi
	ldr	r2, .L1786+44
	strh	r3, [r4]	@ movhi
	lsls	r3, r3, #10
	ldr	r0, [r2]
	movs	r2, #1
	str	r3, [r5, #4]
	mov	r1, r2
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
.L1781:
	movs	r3, #1
	ldr	r0, .L1786+12
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r10, #2]
	adds	r3, r3, #1
	strh	r3, [r10, #2]	@ movhi
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L1782
	adds	r7, r7, #1
	ldr	r1, [r5, #4]
	uxth	r7, r7
	ldr	r0, .L1786+48
	bl	printf
	cmp	r7, #3
	bls	.L1780
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L1786+52
	bl	printf
	ldr	r2, [sp, #12]
	movs	r3, #1
	str	r3, [r2]
.L1777:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1779:
	ldrh	r2, [r10]
	ldr	r3, [r5, #8]
	ldr	r1, [r6, #4]!
	mul	r0, r4, r2
	lsls	r2, r2, #2
	adds	r4, r4, #1
	add	r0, r3, r0, lsl #2
	bl	ftl_memcpy
	b	.L1778
.L1782:
	ldr	r3, [sp, #8]
	cmp	r3, #0
	bne	.L1777
	movs	r3, #1
	str	r3, [sp, #8]
	b	.L1780
.L1787:
	.align	2
.L1786:
	.word	.LANCHOR77
	.word	.LANCHOR188
	.word	.LANCHOR183
	.word	.LANCHOR202
	.word	.LANCHOR75+24
	.word	.LANCHOR45
	.word	.LANCHOR58
	.word	.LANCHOR75
	.word	.LANCHOR37
	.word	.LC33
	.word	.LANCHOR54
	.word	.LANCHOR78
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
	ldr	r3, .L1853
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L1790
.L1789:
	ldr	r3, .L1853+4
	ldr	r8, .L1853+60
	ldr	r7, .L1853+8
	ldrh	r3, [r3]
	ldrh	r2, [r8]
	add	r3, r3, r2
	ldrh	r2, [r7]
	cmp	r3, r2
	ble	.L1791
	ldr	r1, .L1853+12
	movw	r2, #3108
	ldr	r0, .L1853+16
	bl	printf
	ldr	r1, .L1853+20
	ldr	r0, .L1853+24
	bl	printf
.L1791:
	ldr	r3, .L1853+28
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	cmp	r4, r3
	bne	.L1792
	ldr	r3, .L1853+4
	ldrh	r5, [r3]
	ldr	r3, .L1853+32
	ldr	r3, [r3]
	lsrs	r0, r5, #1
	adds	r1, r0, #1
	mul	r6, r3, r5
	add	r1, r1, r6, lsr #2
	ldr	r6, .L1853+36
	uxth	r1, r1
	ldr	r6, [r6]
	cbz	r6, .L1793
	ldr	r6, .L1853+40
	ldr	r6, [r6]
	cmp	r6, #39
	bhi	.L1793
	cmp	r6, #2
	bls	.L1827
	lsls	r1, r5, #31
	bpl	.L1823
	cmp	r3, #0
	beq	.L1827
.L1823:
	mov	r1, r0
	b	.L1793
.L1792:
	cmp	r2, #1
	bne	.L1827
	ldr	r3, .L1853+44
	ldrh	r3, [r3]
	cmp	r3, #1
	beq	.L1827
	ldr	r3, .L1853+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1827
	ldr	r3, .L1853+4
	ldr	r0, .L1853+36
	ldrh	r3, [r3]
	ldr	r0, [r0]
	lsrs	r1, r3, #3
	cbz	r0, .L1793
	ldr	r0, .L1853+40
	ldr	r0, [r0]
	cmp	r0, #1
	bhi	.L1793
	rsb	r3, r3, r3, lsl #3
	ubfx	r1, r3, #3, #16
.L1793:
	cbz	r1, .L1794
	subs	r1, r1, #1
	uxth	r1, r1
.L1794:
	ldr	r0, .L1853+52
	bl	List_pop_index_node
	ldr	r3, .L1853+4
	mov	r5, r0
	uxth	r10, r0
	ldrh	r3, [r3]
	cbnz	r3, .L1795
	ldr	r1, .L1853+12
	movw	r2, #3128
	ldr	r0, .L1853+16
	bl	printf
	ldr	r1, .L1853+20
	ldr	r0, .L1853+24
	bl	printf
.L1795:
	ldr	r3, .L1853+4
	ldr	r2, .L1853+4
	ldrh	r3, [r3]
	subs	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldrh	r3, [r7]
	cmp	r3, r10
	bls	.L1789
	uxth	r5, r5
	lsls	r3, r5, #1
	str	r3, [sp]
	ldr	r3, .L1853+56
	ldr	r3, [r3]
	ldrh	r6, [r3, r5, lsl #1]
	cmp	r6, #0
	bne	.L1789
	strh	r10, [r4]	@ movhi
	mov	r0, r4
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1797
	ldr	r3, .L1853+56
	movw	r2, #65535
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldr	r3, .L1853+4
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r7]
	cmp	r3, r2
	ble	.L1789
	movw	r2, #3144
	ldr	r1, .L1853+12
	ldr	r0, .L1853+16
	bl	printf
	ldr	r1, .L1853+20
	ldr	r0, .L1853+24
	bl	printf
	b	.L1789
.L1827:
	movs	r1, #0
	b	.L1794
.L1854:
	.align	2
.L1853:
	.word	.LANCHOR77
	.word	.LANCHOR89
	.word	.LANCHOR40
	.word	.LANCHOR203
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR94
	.word	.LANCHOR172
	.word	.LANCHOR28
	.word	.LANCHOR170
	.word	.LANCHOR44
	.word	.LANCHOR8
	.word	.LANCHOR88
	.word	.LANCHOR84
	.word	.LANCHOR86
.L1797:
	ldr	r3, .L1855
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r7]
	cmp	r3, r2
	ble	.L1799
	ldr	r1, .L1855+4
	movw	r2, #3147
	ldr	r0, .L1855+8
	bl	printf
	ldr	r1, .L1855+12
	ldr	r0, .L1855+16
	bl	printf
.L1799:
	ldr	r3, .L1855+20
	add	lr, r4, #16
	ldr	r2, .L1855+24
	mov	r8, #0
	ldr	ip, [r3]
	ldrh	r0, [r2]
	movs	r2, #36
	mov	r3, ip
	mla	r0, r2, r0, ip
.L1800:
	cmp	r0, r3
	bne	.L1802
	cbnz	r6, .L1803
	ldr	r1, .L1855+4
	movw	r2, #3159
	ldr	r0, .L1855+8
	bl	printf
	ldr	r1, .L1855+12
	ldr	r0, .L1855+16
	bl	printf
.L1803:
	ldr	r3, .L1855+28
	ldr	r8, .L1855+80
	ldr	r3, [r3]
	cbz	r3, .L1804
	ldr	r3, .L1855+32
	cmp	r4, r3
	bne	.L1804
	ldr	r3, [r8]
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, #40
	itt	hi
	movhi	r3, #0
	strbhi	r3, [r4, #8]
.L1804:
	ldr	r3, .L1855+36
	ldrh	r3, [r3]
	cmp	r3, r10
	bne	.L1805
	ldr	r1, .L1855+4
	movw	r2, #3166
	ldr	r0, .L1855+8
	bl	printf
	ldr	r1, .L1855+12
	ldr	r0, .L1855+16
	bl	printf
.L1805:
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	ldr	r3, .L1855+40
	ldr	fp, .L1855+84
	cmp	r2, #0
	bne	.L1806
	ldr	r1, [r8]
	ldrh	r2, [r1, r5, lsl #1]
	cmp	r2, #0
	beq	.L1807
	ldr	r0, .L1855+44
	ldrh	r0, [r0]
	add	r2, r2, r0
.L1850:
	strh	r2, [r1, r5, lsl #1]	@ movhi
	mov	r0, r10
	ldr	r2, [r3]
	movs	r1, #0
	str	r3, [sp, #4]
	adds	r2, r2, #1
	str	r2, [r3]
	bl	ftl_set_blk_mode
.L1851:
	ldr	r2, [r8]
	ldr	r3, [sp, #4]
	ldrh	r0, [r2, r5, lsl #1]
	ldr	r2, .L1855+48
	ldr	r1, [r2]
	cmp	r0, r1
	ldrh	r1, [r7]
	it	hi
	strhi	r0, [r2]
	ldr	r2, .L1855+44
	ldr	r0, [r3]
	ldr	r3, [fp]
	ldrh	r2, [r2]
	ldr	r7, .L1855+52
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L1855+56
	str	r0, [r3]
	ldr	r3, .L1855+60
	ldr	r2, [r3]
	ldr	r3, [r2, #16]
	adds	r3, r3, #1
	str	r3, [r2, #16]
	ldr	r3, .L1855+20
	ldr	r0, [r3]
	movs	r3, #36
	adds	r1, r0, #4
	mla	r3, r3, r6, r0
	adds	r3, r3, #40
.L1811:
	adds	r1, r1, #36
	cmp	r3, r1
	bne	.L1812
	ldr	r3, .L1855+64
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1813
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	mov	r2, r6
	cmp	r3, #1
	ite	eq
	moveq	r1, #0
	movne	r1, #1
	bl	FlashEraseBlocks
.L1813:
	ldr	r3, .L1855+20
	movs	r7, #0
	mov	r8, r7
	mov	fp, #36
	mov	r2, r6
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L1815:
	uxth	r3, r7
	cmp	r6, r3
	bhi	.L1817
	cmp	r8, #0
	beq	.L1818
	mov	r0, r10
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1818:
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L1819
	ldr	r3, .L1855+68
	movw	r2, #65535
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	b	.L1789
.L1802:
	ldrh	r1, [lr], #2
	movw	fp, #65535
	str	r8, [r3, #8]
	str	r8, [r3, #12]
	cmp	r1, fp
	beq	.L1801
	mla	fp, r2, r6, ip
	adds	r6, r6, #1
	lsls	r1, r1, #10
	uxth	r6, r6
	str	r1, [fp, #4]
.L1801:
	adds	r3, r3, #36
	b	.L1800
.L1807:
	movs	r2, #2
	b	.L1850
.L1806:
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
	b	.L1851
.L1812:
	ldr	r2, [r1, #-36]
	ands	r2, r2, r7
	str	r2, [r1, #-36]
	b	.L1811
.L1817:
	ldr	r2, .L1855+20
	mul	r3, fp, r7
	ldr	r2, [r2]
	adds	r1, r2, r3
	ldr	r2, [r2, r3]
	adds	r3, r2, #1
	bne	.L1816
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
.L1816:
	adds	r7, r7, #1
	b	.L1815
.L1819:
	ldr	r3, .L1855+72
	ldr	r1, .L1855+76
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
	ldr	r2, .L1855+68
	ldr	r1, [sp]
	ldr	r2, [r2]
	strh	r3, [r2, r1]	@ movhi
	ldrh	r3, [r4, #4]
	cbz	r3, .L1820
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1790
.L1820:
	ldr	r1, .L1855+4
	movw	r2, #3225
	ldr	r0, .L1855+8
	bl	printf
	ldr	r1, .L1855+12
	ldr	r0, .L1855+16
	bl	printf
.L1790:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1856:
	.align	2
.L1855:
	.word	.LANCHOR89
	.word	.LANCHOR203
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR78
	.word	.LANCHOR38
	.word	.LANCHOR28
	.word	.LANCHOR92
	.word	.LANCHOR204
	.word	.LANCHOR167
	.word	.LANCHOR48
	.word	.LANCHOR169
	.word	-1024
	.word	.LANCHOR205
	.word	.LANCHOR191
	.word	.LANCHOR8
	.word	.LANCHOR84
	.word	.LANCHOR53
	.word	.LANCHOR159
	.word	.LANCHOR79
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
	ldr	r4, .L1869
	ldrh	r3, [r4]
	cbz	r3, .L1858
	ldr	r8, .L1869+12
	movs	r7, #0
.L1859:
	ldr	r3, .L1869+4
	ldrh	r2, [r3]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L1865
	bl	FtlGcReFreshBadBlk
.L1858:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1865:
	ldr	r2, .L1869+8
	uxth	r3, r7
	mov	r1, r10
	mov	fp, #0
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	mov	r1, r0
.L1860:
	ldrh	r3, [r4]
	uxth	r5, fp
	cmp	r3, r5
	bhi	.L1864
	adds	r7, r7, #1
	b	.L1859
.L1864:
	uxth	r6, fp
	ldrh	r3, [r8, r6, lsl #1]
	cmp	r3, r1
	bne	.L1861
	mov	r0, r1
	str	r1, [sp, #4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	r2, [r4]
	add	r3, r8, r6, lsl #1
	ldr	r1, [sp, #4]
.L1862:
	cmp	r5, r2
	bcc	.L1863
	subs	r2, r2, #1
	strh	r2, [r4]	@ movhi
.L1861:
	add	fp, fp, #1
	b	.L1860
.L1863:
	ldrh	r0, [r3, #2]!
	adds	r5, r5, #1
	uxth	r5, r5
	strh	r0, [r3, #-2]	@ movhi
	b	.L1862
.L1870:
	.align	2
.L1869:
	.word	.LANCHOR117
	.word	.LANCHOR38
	.word	.LANCHOR47
	.word	.LANCHOR118
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
	ldr	r3, .L1881
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	bne	.L1872
	ldr	r2, .L1881+4
	ldrh	r1, [r2]
	cmp	r1, r0
	bne	.L1873
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L1874:
	ldr	r5, .L1881+8
	mov	r1, r4
	ldr	r0, .L1881+12
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L1876
	ldr	r1, .L1881+16
	movw	r2, #3336
	ldr	r0, .L1881+20
	bl	printf
	ldr	r1, .L1881+24
	ldr	r0, .L1881+28
	bl	printf
.L1876:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	free_data_superblock
	mov	r0, r4
	bl	FtlGcFreeBadSuperBlk
	ldr	r3, .L1881+32
	ldrh	r2, [r5]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldr	r2, .L1881+36
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1880
	ldr	r1, .L1881+16
	movw	r2, #3339
	ldr	r0, .L1881+20
	bl	printf
	ldr	r1, .L1881+24
	ldr	r0, .L1881+28
	bl	printf
.L1880:
	movs	r3, #1
	b	.L1871
.L1873:
	ldr	r2, .L1881+40
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1871
	ldr	r2, .L1881+44
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1871
	ldr	r2, .L1881+48
	ldrh	r2, [r2]
	cmp	r2, r0
	bne	.L1874
.L1871:
	mov	r0, r3
	pop	{r3, r4, r5, pc}
.L1872:
	bl	List_update_data_list
	movs	r3, #0
	b	.L1871
.L1882:
	.align	2
.L1881:
	.word	.LANCHOR84
	.word	.LANCHOR204
	.word	.LANCHOR86
	.word	.LANCHOR83
	.word	.LANCHOR206
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR89
	.word	.LANCHOR40
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR94
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
	beq	.L1884
	ldr	r5, .L1895
	ldr	r3, [r5]
	ldrh	r2, [r3, r0, lsl #1]
	cmp	r2, #0
	bne	.L1885
	mov	r1, r0
	ldr	r0, .L1895+4
	bl	printf
	ldr	r3, [r5]
	ldrh	r3, [r3, r4, lsl #1]
	cbnz	r3, .L1886
	ldr	r1, .L1895+8
	movw	r2, #3354
	ldr	r0, .L1895+12
	bl	printf
	ldr	r1, .L1895+16
	ldr	r0, .L1895+20
	bl	printf
.L1886:
	ldr	r3, [r5]
	movs	r2, #32
	mov	r1, r4
	ldr	r0, .L1895+24
	strh	r2, [r3, r4, lsl #1]	@ movhi
	bl	test_node_in_list
	cbz	r0, .L1887
	ldr	r6, .L1895+28
	mov	r1, r4
	ldr	r0, .L1895+24
	bl	List_remove_node
	ldrh	r3, [r6]
	cbnz	r3, .L1888
	ldr	r1, .L1895+8
	movw	r2, #3358
	ldr	r0, .L1895+12
	bl	printf
	ldr	r1, .L1895+16
	ldr	r0, .L1895+20
	bl	printf
.L1888:
	ldrh	r3, [r6]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r6]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r3, [r5]
	mov	r1, r4
	ldr	r0, .L1895+32
	ldrh	r2, [r3, r4, lsl #1]
	bl	printf
.L1887:
	mov	r0, r4
	bl	FtlGcRefreshBlock
.L1891:
	movs	r5, #0
	b	.L1883
.L1885:
	subs	r2, r2, #1
	strh	r2, [r3, r0, lsl #1]	@ movhi
.L1884:
	ldr	r6, .L1895+36
	movw	r3, #65535
	ldrh	r0, [r6]
	cmp	r0, r3
	bne	.L1890
	strh	r4, [r6]	@ movhi
	b	.L1891
.L1890:
	cmp	r4, r0
	beq	.L1891
	bl	update_vpc_list
	ldr	r3, .L1895+40
	adds	r5, r0, #0
	ldr	r2, .L1895+44
	it	ne
	movne	r5, #1
	strh	r4, [r6]	@ movhi
	ldr	r3, [r3]
	ldr	r2, [r2]
	subs	r3, r3, r2
	asrs	r2, r3, #1
	ldr	r3, .L1895+48
	muls	r3, r2, r3
	ldr	r2, .L1895
	ldr	r2, [r2]
	uxth	r1, r3
	ldrh	r2, [r2, r1, lsl #1]
	cbnz	r2, .L1883
	cmp	r4, r1
	beq	.L1883
	ldr	r1, .L1895+8
	movw	r2, #3379
	ldr	r0, .L1895+12
	bl	printf
	ldr	r1, .L1895+16
	ldr	r0, .L1895+20
	bl	printf
.L1883:
	mov	r0, r5
	pop	{r4, r5, r6, pc}
.L1896:
	.align	2
.L1895:
	.word	.LANCHOR84
	.word	.LC36
	.word	.LANCHOR207
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR88
	.word	.LANCHOR89
	.word	.LC37
	.word	.LANCHOR133
	.word	.LANCHOR83
	.word	.LANCHOR82
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
	beq	.L1897
	ldrh	r2, [r0]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1897
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r5, .L1908
	ldr	r6, .L1908+4
	adds	r3, r3, #8
	ldrh	r3, [r0, r3, lsl #1]
.L1901:
	movw	r2, #65535
	cmp	r3, r2
	beq	.L1903
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1904
	ldrb	r1, [r5]	@ zero_extendqisi2
	cbnz	r1, .L1904
	ldrh	r1, [r4, #2]
	ldrh	r1, [r6, r1, lsl #1]
	cmp	r1, r2
	bne	.L1904
	ldrh	r3, [r4, #4]
	ldrh	r0, [r4]
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	ldrh	r2, [r4, #4]
	cbnz	r2, .L1903
	ldrh	r3, [r4, #2]
	strb	r2, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	pop	{r4, r5, r6, pc}
.L1903:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldr	r2, .L1908+8
	adds	r3, r3, #1
	ldrh	r2, [r2]
	uxtb	r3, r3
	strb	r3, [r4, #6]
	cmp	r2, r3
	bne	.L1902
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
.L1902:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r3, [r4, r3, lsl #1]
	b	.L1901
.L1904:
	ldrb	r2, [r5]	@ zero_extendqisi2
	cbz	r2, .L1897
	cmp	r3, #1
	bne	.L1897
	ldr	r3, .L1908+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1897
	ldr	r3, .L1908+16
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	movs	r3, #0
	ldr	r2, .L1908+20
	strh	r3, [r4, #4]	@ movhi
	strb	r3, [r4, #6]
	ldrh	r2, [r2]
	strh	r2, [r4, #2]	@ movhi
.L1897:
	pop	{r4, r5, r6, pc}
.L1909:
	.align	2
.L1908:
	.word	.LANCHOR8
	.word	.LANCHOR120
	.word	.LANCHOR38
	.word	.LANCHOR54
	.word	.LANCHOR84
	.word	.LANCHOR53
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
	bne	.L1911
	ldr	r1, .L1932
	movw	r2, #3276
	ldr	r0, .L1932+4
	bl	printf
	ldr	r1, .L1932+8
	ldr	r0, .L1932+12
	bl	printf
.L1911:
	ldr	r5, .L1932+16
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L1912
	ldr	r1, .L1932
	movw	r2, #3277
	ldr	r0, .L1932+4
	bl	printf
	ldr	r1, .L1932+8
	ldr	r0, .L1932+12
	bl	printf
.L1912:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1913
	ldr	r1, .L1932
	movw	r2, #3278
	ldr	r0, .L1932+4
	bl	printf
	ldr	r1, .L1932+8
	ldr	r0, .L1932+12
	bl	printf
.L1913:
	movs	r3, #0
	ldr	r7, .L1932+20
	strb	r3, [r4, #10]
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldr	r6, .L1932+24
	adds	r3, r3, #8
	ldrh	r2, [r4, r3, lsl #1]
.L1914:
	movw	r0, #65535
	cmp	r2, r0
	beq	.L1915
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	ldrh	r1, [r4, #2]
	cmp	r3, #1
	ldrh	r3, [r4, #4]
	bne	.L1917
	ldrb	ip, [r6]	@ zero_extendqisi2
	cmp	ip, #0
	bne	.L1917
	ldr	ip, .L1932+28
	ldrh	ip, [ip, r1, lsl #1]
	cmp	ip, r0
	bne	.L1917
	subs	r3, r3, #1
	ldrh	r0, [r4]
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
.L1915:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldrh	r2, [r7]
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r2, r3
	strb	r3, [r4, #6]
	bne	.L1916
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
.L1916:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r2, [r4, r3, lsl #1]
	b	.L1914
.L1917:
	ldr	r8, .L1932+24
	orr	r6, r1, r2, lsl #10
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
.L1918:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	movw	r2, #65535
	ldrh	r0, [r7]
.L1920:
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
	beq	.L1920
	strb	r3, [r4, #6]
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1921
	ldrb	r1, [r8]	@ zero_extendqisi2
	ldrh	r3, [r4, #2]
	cbnz	r1, .L1922
	ldr	r1, .L1932+28
	ldrh	r3, [r1, r3, lsl #1]
	cmp	r3, r2
	bne	.L1921
	ldrh	r3, [r4, #4]
	cbz	r3, .L1921
	subs	r3, r3, #1
	ldrh	r0, [r4]
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	b	.L1918
.L1922:
	ldr	r2, .L1932+32
	ldrh	r2, [r2]
	cmp	r3, r2
	bcc	.L1921
	ldr	r3, .L1932+36
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
.L1921:
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L1910
	ldrh	r3, [r4, #4]
	cbz	r3, .L1910
	ldr	r1, .L1932
	movw	r2, #3322
	ldr	r0, .L1932+4
	bl	printf
	ldr	r1, .L1932+8
	ldr	r0, .L1932+12
	bl	printf
.L1910:
	mov	r0, r6
	pop	{r4, r5, r6, r7, r8, pc}
.L1933:
	.align	2
.L1932:
	.word	.LANCHOR208
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR53
	.word	.LANCHOR38
	.word	.LANCHOR8
	.word	.LANCHOR120
	.word	.LANCHOR54
	.word	.LANCHOR84
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
	ldr	r2, .L1954
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, [r2]
	str	r2, [sp, #4]
	cmp	r3, #0
	bne	.L1936
	ldr	r4, .L1954+4
	ldr	fp, .L1954+108
	ldr	r8, .L1954+112
	ldr	r5, .L1954+8
	ldr	r0, [fp]
	ldr	r6, [r8]
	ldrh	r2, [r4]
	str	r0, [r5, #8]
	str	r6, [r5, #12]
	strh	r2, [r6, #2]	@ movhi
	movw	r2, #61604
	ldr	r7, .L1954+12
	strh	r2, [r6]	@ movhi
	str	r3, [r6, #12]
	ldr	ip, .L1954+116
	ldr	r2, [r4, #8]
	str	r3, [r6, #8]
	ldr	r3, .L1954+16
	str	r2, [r6, #4]
	stm	r7, {r3, ip}
	ldrh	r3, [r4, #6]
	strh	r3, [r7, #8]	@ movhi
	ldr	r3, .L1954+20
	ldrh	r3, [r3]
	strb	r3, [r7, #10]
	ldr	r3, .L1954+24
	ldrh	r2, [r3]
	ldrh	r1, [r3, #2]
	strh	r2, [r7, #14]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r7, #11]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L1954+28
	strh	r2, [r7, #16]	@ movhi
	ldrh	r2, [r3]
	ldrh	r1, [r3, #2]
	strh	r2, [r7, #18]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r7, #12]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L1954+32
	strh	r2, [r7, #20]	@ movhi
	ldrh	r2, [r3]
	strh	r2, [r7, #22]	@ movhi
	ldrh	r1, [r3, #2]
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r7, #13]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L1954+36
	movs	r1, #255
	strh	r2, [r7, #24]	@ movhi
	ldr	r3, [r3]
	str	r3, [r7, #32]
	ldr	r3, .L1954+40
	ldr	r3, [r3]
	str	r3, [r7, #40]
	ldr	r3, .L1954+44
	ldr	r3, [r3]
	str	r3, [r7, #36]
	ldr	r3, .L1954+48
	ldrh	r3, [r3]
	strh	r3, [r7, #44]	@ movhi
	ldr	r3, .L1954+52
	ldrh	r3, [r3]
	strh	r3, [r7, #46]	@ movhi
	ldr	r3, .L1954+56
	ldrh	r2, [r3]
	bl	ftl_memset
	mov	r1, r7
	ldr	r7, .L1954+60
	movs	r2, #48
	ldr	r0, [r5, #8]
	bl	ftl_memcpy
	ldrh	r2, [r7]
	ldr	r3, .L1954+64
	ldr	r0, [r5, #8]
	ldr	r1, [r3]
	lsls	r2, r2, #1
	adds	r0, r0, #48
	bl	ftl_memcpy
	ldrh	r0, [r7]
	ldr	r3, [r5, #8]
	ldr	r1, .L1954+68
	lsrs	r2, r0, #3
	adds	r0, r0, #24
	lsls	r0, r0, #1
	ldr	r1, [r1]
	adds	r2, r2, #4
	bic	r0, r0, #3
	add	r0, r0, r3
	bl	ftl_memcpy
	ldr	r3, .L1954+72
	ldrh	r3, [r3]
	cbz	r3, .L1937
	ldrh	r0, [r7]
	ldr	r3, .L1954+76
	ldr	r1, .L1954+80
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
.L1937:
	movs	r7, #0
	movw	r10, #65535
	movs	r0, #0
	bl	FtlUpdateVaildLpn
.L1938:
	ldr	r3, [fp]
	ldrh	r1, [r4, #2]
	ldrh	r2, [r4]
	str	r3, [r5, #8]
	ldr	r3, [r8]
	str	r3, [r5, #12]
	orr	r3, r1, r2, lsl #10
	str	r3, [r5, #4]
	ldr	r3, .L1954+84
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r1, r3
	blt	.L1939
	movs	r3, #0
	ldrh	r10, [r4, #4]
	strh	r3, [r4, #2]	@ movhi
	strh	r2, [r4, #4]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L1954+40
	ldr	r1, .L1954+40
	strh	r0, [r4]	@ movhi
	ldr	r3, [r3]
	adds	r2, r3, #1
	str	r3, [r4, #8]
	str	r2, [r1]
	lsls	r2, r0, #10
	str	r2, [r5, #4]
	str	r3, [r6, #4]
	strh	r0, [r6, #2]	@ movhi
.L1939:
	movs	r3, #1
	ldr	r0, .L1954+8
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	ldr	r2, [r5]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r1, r2, #1
	strh	r3, [r4, #2]	@ movhi
	bne	.L1940
	cmp	r3, #1
	bne	.L1941
	ldr	r1, .L1954+88
	movw	r2, #1209
	ldr	r0, .L1954+92
	bl	printf
	ldr	r1, .L1954+96
	ldr	r0, .L1954+100
	bl	printf
.L1941:
	ldrh	r3, [r4, #2]
	adds	r7, r7, #1
	uxth	r7, r7
	cmp	r3, #1
	itttt	eq
	ldreq	r3, .L1954+84
	ldrheq	r3, [r3]
	addeq	r3, r3, #-1
	strheq	r3, [r4, #2]	@ movhi
	cmp	r7, #3
	bls	.L1938
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L1954+104
	bl	printf
	ldr	r2, [sp, #4]
	movs	r3, #1
	str	r3, [r2]
.L1936:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1940:
	cmp	r3, #1
	beq	.L1938
	cmp	r2, #256
	beq	.L1938
	movw	r3, #65535
	cmp	r10, r3
	beq	.L1936
	movs	r1, #1
	mov	r0, r10
	bl	FtlFreeSysBlkQueueIn
	b	.L1936
.L1955:
	.align	2
.L1954:
	.word	.LANCHOR77
	.word	.LANCHOR209
	.word	.LANCHOR202
	.word	.LANCHOR81
	.word	1179929683
	.word	.LANCHOR45
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR167
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR113
	.word	.LANCHOR114
	.word	.LANCHOR58
	.word	.LANCHOR40
	.word	.LANCHOR84
	.word	.LANCHOR0
	.word	.LANCHOR70
	.word	.LANCHOR67
	.word	.LANCHOR131
	.word	.LANCHOR54
	.word	.LANCHOR210
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC38
	.word	.LANCHOR183
	.word	.LANCHOR188
	.word	1342177360
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
	ldr	r3, .L1971
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	sub	sp, sp, #44
	ldr	r8, [r3]
	cmp	r8, #0
	bne	.L1956
	ldr	r3, .L1971+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1967
	ldrb	r3, [r0, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1967
	ldrh	r6, [r0, #4]
	mov	r8, r3
.L1958:
	mov	r3, #-1
	ldr	r2, .L1971+8
	str	r3, [sp, #20]
	movs	r7, #0
	ldr	r3, .L1971+12
	ldr	r5, [r2]
	mvn	r2, #2
	ldr	r10, .L1971+24
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
.L1959:
	adds	r6, r6, #-1
	bcc	.L1962
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1960
.L1962:
	ldr	r3, .L1971+16
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldr	r3, .L1971+20
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
.L1956:
	add	sp, sp, #44
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L1967:
	movs	r6, #12
	b	.L1958
.L1960:
	mov	r0, r4
	bl	get_new_active_ppa
	str	r0, [sp, #8]
	adds	r0, r0, #1
	beq	.L1962
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
	b	.L1959
.L1972:
	.align	2
.L1971:
	.word	.LANCHOR77
	.word	.LANCHOR8
	.word	.LANCHOR188
	.word	.LANCHOR183
	.word	.LANCHOR84
	.word	.LANCHOR53
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
	ldr	r3, .L1983
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r5, .L1983+4
	ldr	r3, [r3]
	ldr	r7, .L1983+8
	ldr	r10, .L1983+20
	str	r3, [r5, #8]
	ldr	r3, .L1983+12
	ldr	r8, [r3]
	str	r8, [r5, #12]
.L1974:
	ldr	r3, .L1983+16
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L1979
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1979:
	ldrh	r4, [r10]
	movw	r3, #65535
	ldr	fp, .L1983+4
	strh	r3, [r7, #2]!	@ movhi
	subs	r4, r4, #1
	uxth	r4, r4
.L1975:
	ldrh	r3, [r10]
	sub	r2, r3, #15
	cmp	r2, r4
	bgt	.L1977
	mla	r3, r6, r3, r4
	movs	r2, #1
	mov	r1, r2
	mov	r0, fp
	lsls	r3, r3, #10
	str	r3, [r5, #4]
	bl	FlashReadPages
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L1976
	ldrh	r2, [r8]
	movw	r3, #61664
	cmp	r2, r3
	bne	.L1976
	strh	r4, [r7]	@ movhi
.L1977:
	adds	r6, r6, #1
	b	.L1974
.L1976:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L1975
.L1984:
	.align	2
.L1983:
	.word	.LANCHOR183
	.word	.LANCHOR202
	.word	.LANCHOR75+10
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
	ldreq	r3, .L1997
	sub	sp, sp, #104
	lsl	r7, r0, #10
	mov	r2, r1
	it	ne
	ldrne	r3, .L1997+4
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
	bne	.L1988
.L1989:
	cmp	r6, r5
	ble	.L1992
.L1988:
	mov	r0, r5
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1992:
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
	bne	.L1990
	ldr	r3, [sp, #44]
	adds	r3, r3, #1
	bne	.L1990
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L1990
	subs	r4, r4, #1
	sxth	r5, r4
	b	.L1989
.L1990:
	adds	r4, r4, #1
	sxth	r6, r4
	b	.L1989
.L1998:
	.align	2
.L1997:
	.word	.LANCHOR54
	.word	.LANCHOR53
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
	ldr	r8, .L2028+48
	ldr	r4, .L2028
	ldr	r3, [r8]
	ldr	r7, .L2028+4
	mov	r10, r4
	str	r3, [r4, #8]
	ldr	r3, .L2028+8
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FtlBbtMemInit
	ldrh	r5, [r7]
	subs	r5, r5, #1
	uxth	r5, r5
.L2000:
	ldrh	r3, [r7]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L2003
	lsls	r3, r5, #10
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L2001
	ldr	r3, [r4, #4]
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	adds	r3, r3, #1
	str	r3, [r4, #4]
	bl	FlashReadPages
.L2001:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L2002
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L2002
	ldr	r3, .L2028+12
	ldr	r2, [r6, #4]
	strh	r5, [r3]	@ movhi
	str	r2, [r3, #8]
	ldrh	r2, [r6, #8]
	strh	r2, [r3, #4]	@ movhi
.L2003:
	ldr	r5, .L2028+12
	movw	r2, #65535
	ldrh	r3, [r5]
	cmp	r3, r2
	beq	.L2017
	ldrh	r3, [r5, #4]
	cmp	r3, r2
	beq	.L2007
	lsls	r3, r3, #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L2028
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L2007
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L2007
	ldr	r3, [r6, #4]
	ldr	r2, [r5, #8]
	cmp	r3, r2
	bls	.L2007
	ldrh	r2, [r5, #4]
	str	r3, [r5, #8]
	ldrh	r3, [r6, #8]
	strh	r2, [r5]	@ movhi
	strh	r3, [r5, #4]	@ movhi
.L2007:
	ldr	r10, .L2028
	movs	r1, #1
	ldrh	r0, [r5]
	bl	FtlGetLastWrittenPage
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r5, #2]	@ movhi
.L2009:
	cmp	r7, #0
	bge	.L2012
	ldr	r1, .L2028+16
	movw	r2, #335
	ldr	r0, .L2028+20
	bl	printf
	ldr	r1, .L2028+24
	ldr	r0, .L2028+28
	bl	printf
.L2011:
	ldrh	r3, [r6, #10]
	ldrh	r0, [r6, #12]
	strh	r3, [r5, #6]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L2014
	ldr	r3, .L2028+32
	ldr	r2, [r3]
	cmp	r0, r2
	beq	.L2014
	ldr	r3, .L2028+36
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	cmp	r2, r3
	bcs	.L2014
	cmp	r0, r3
	bcs	.L2014
	bl	FtlSysBlkNumInit
.L2014:
	ldr	r6, .L2028+40
	movs	r5, #0
	ldr	r7, .L2028+44
	ldr	r8, .L2028+52
.L2015:
	ldrh	r3, [r7]
	cmp	r5, r3
	bcc	.L2016
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2002:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2000
.L2012:
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
	beq	.L2010
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	beq	.L2011
.L2010:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L2009
.L2016:
	ldrh	r2, [r8]
	ldr	r1, [r4, #8]
	ldr	r0, [r6, #4]!
	lsls	r2, r2, #2
	mla	r1, r5, r2, r1
	adds	r5, r5, #1
	bl	ftl_memcpy
	b	.L2015
.L2017:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2029:
	.align	2
.L2028:
	.word	.LANCHOR202
	.word	.LANCHOR51
	.word	.LANCHOR188
	.word	.LANCHOR75
	.word	.LANCHOR211
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR37
	.word	.LANCHOR41
	.word	.LANCHOR75+24
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
	blt	.L2031
	uxth	r0, r0
	ldrh	r8, [r5, r0, lsl #1]
	cmp	r8, #0
	beq	.L2031
	ldr	r3, [r4, #32]
	cbnz	r3, .L2031
	movs	r2, #1
	str	r2, [r4, #32]
	strh	r3, [r5, r0, lsl #1]	@ movhi
	ldrh	r3, [r4, #8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	ldr	r3, .L2043
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2032
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L2032:
	ldr	r5, .L2043+4
	movs	r6, #0
.L2033:
	ldrh	r3, [r4, #6]
	uxth	r10, r6
	cmp	r3, r10
	bhi	.L2039
	movs	r1, #1
	mov	r0, r8
	bl	FtlFreeSysBlkQueueIn
	movs	r3, #0
	str	r3, [r4, #32]
.L2031:
	ldr	r3, .L2043
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2037
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
	b	.L2037
.L2039:
	ldr	r3, [sp]
	uxth	fp, r6
	add	r3, r3, fp, lsl #2
	str	r3, [sp, #4]
	ldr	r3, [sp]
	ldr	r2, [r3, fp, lsl #2]
	cmp	r8, r2, lsr #10
	bne	.L2034
	ldr	r3, .L2043+8
	str	r2, [r5, #4]
	movs	r2, #1
	ldr	r0, .L2043+4
	ldr	r1, [r3]
	str	r1, [r5, #8]
	ldr	r1, .L2043+12
	ldr	r7, [r1]
	mov	r1, r2
	str	r7, [r5, #12]
	bl	FlashReadPages
	ldrh	r2, [r7, #8]
	cmp	r2, r10
	beq	.L2035
	ldr	r1, .L2043+16
	movw	r2, #661
	ldr	r0, .L2043+20
	bl	printf
	ldr	r1, .L2043+24
	ldr	r0, .L2043+28
	bl	printf
.L2035:
	ldr	r2, [r5]
	adds	r2, r2, #1
	ldrh	r2, [r7, #8]
	bne	.L2036
.L2038:
	ldr	r1, [sp, #4]
	movs	r3, #0
	ldr	r0, .L2043+32
	str	r3, [r1]
	ldr	r1, [r5, #4]
	bl	printf
	ldr	r3, .L2043+36
	movs	r2, #1
	str	r2, [r3]
.L2037:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2036:
	cmp	r2, r10
	bne	.L2038
	ldrh	r0, [r7]
	ldrh	r1, [r4, #4]
	cmp	r0, r1
	bne	.L2038
	ldr	r2, [r5, #8]
	mov	r1, fp
	mov	r0, r4
	bl	FtlMapWritePage
.L2034:
	adds	r6, r6, #1
	b	.L2033
.L2044:
	.align	2
.L2043:
	.word	.LANCHOR54
	.word	.LANCHOR202
	.word	.LANCHOR184
	.word	.LANCHOR188
	.word	.LANCHOR212
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC39
	.word	.LANCHOR77
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
	ldr	r3, .L2055
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	ldr	r5, [r3]
	cbnz	r5, .L2046
	ldrh	r3, [r0]
	movw	r2, #65535
	ldr	r6, [r0, #12]
	cmp	r3, r2
	bne	.L2047
	ldrh	r3, [r0, #8]
	cbz	r3, .L2048
	ldr	r1, .L2055+4
	movw	r2, #697
	ldr	r0, .L2055+8
	bl	printf
	ldr	r1, .L2055+12
	ldr	r0, .L2055+16
	bl	printf
.L2048:
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
.L2046:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, pc}
.L2047:
	ldrh	r6, [r6, r3, lsl #1]
	movs	r1, #255
	ldrh	r3, [r0, #2]
	ldr	r2, .L2055+20
	ldr	r8, .L2055+32
	ldr	r7, [r0, #24]
	orr	r3, r3, r6, lsl #10
	ldr	r0, [r8]
	str	r3, [r2, #4]
	ldr	r3, .L2055+24
	str	r0, [r2, #8]
	ldr	r3, [r3]
	str	r3, [r2, #12]
	ldr	r2, [r4, #28]
	str	r2, [r3, #4]
	movw	r2, #64245
	strh	r2, [r3, #8]	@ movhi
	ldrh	r2, [r4, #4]
	strh	r6, [r3, #2]	@ movhi
	strh	r2, [r3]	@ movhi
	ldr	r3, .L2055+28
	ldrh	r2, [r3]
	lsls	r2, r2, #3
	bl	ftl_memset
	ldrh	ip, [r4, #6]
	mov	r3, r5
	ldr	r1, [r8]
	mov	r2, r5
.L2049:
	uxth	r0, r3
	cmp	ip, r0
	bhi	.L2051
	movs	r2, #1
	movs	r3, #0
	mov	r1, r2
	ldr	r0, .L2055+20
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	mov	r0, r4
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	bl	ftl_map_blk_gc
	b	.L2046
.L2051:
	ldr	r0, [r7, r3, lsl #2]
	cmp	r6, r0, lsr #10
	bne	.L2050
	adds	r2, r2, #1
	uxth	r2, r2
	str	r3, [r1, r2, lsl #3]
	add	r5, r1, r2, lsl #3
	ldr	r0, [r7, r3, lsl #2]
	str	r0, [r5, #4]
.L2050:
	adds	r3, r3, #1
	b	.L2049
.L2056:
	.align	2
.L2055:
	.word	.LANCHOR77
	.word	.LANCHOR213
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR202
	.word	.LANCHOR188
	.word	.LANCHOR54
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
	ldr	r10, .L2079+40
	mov	r8, r1
	movs	r6, #0
	str	r2, [sp, #4]
	mov	fp, r10
.L2058:
	ldr	r2, .L2079
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	ldrh	r3, [r10]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L2059
	ldrh	r2, [r4]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2060
.L2059:
	mov	r0, r4
	bl	Ftl_write_map_blk_to_last_page
.L2060:
	ldr	r3, .L2079+4
	ldr	r2, [r3]
	str	r3, [sp, #8]
	cmp	r2, #0
	bne	.L2075
	ldrh	r2, [r4]
	ldr	r3, [r4, #12]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L2062
	ldr	r1, .L2079+8
	movw	r2, #757
	ldr	r0, .L2079+12
	bl	printf
	ldr	r1, .L2079+16
	ldr	r0, .L2079+20
	bl	printf
.L2062:
	ldrh	r2, [r4]
	ldrh	r3, [r4, #10]
	cmp	r2, r3
	bcc	.L2063
	ldr	r1, .L2079+8
	movw	r2, #758
	ldr	r0, .L2079+12
	bl	printf
	ldr	r1, .L2079+16
	ldr	r0, .L2079+20
	bl	printf
.L2063:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r4, #12]
	ldr	r5, .L2079+24
	ldrh	r7, [r3, r2, lsl #1]
	movs	r2, #16
	ldrh	r3, [r4, #2]
	orr	r3, r3, r7, lsl #10
	str	r3, [r5, #4]
	ldr	r3, [sp, #4]
	str	r3, [r5, #8]
	ldr	r3, .L2079+28
	ldr	r0, [r3]
	str	r0, [r5, #12]
	bl	ftl_memset
	ldr	r3, [r5, #12]
	mov	r0, r5
	ldr	r2, [r4, #28]
	strh	r8, [r3, #8]	@ movhi
	str	r2, [r3, #4]
	ldrh	r2, [r4, #4]
	strh	r7, [r3, #2]	@ movhi
	strh	r2, [r3]	@ movhi
	movs	r3, #1
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r2, [r4, #2]
	ldr	r1, [r5]
	adds	r2, r2, #1
	uxth	r2, r2
	adds	r3, r1, #1
	mov	r3, r5
	strh	r2, [r4, #2]	@ movhi
	bne	.L2064
	ldr	r1, [r5, #4]
	adds	r6, r6, #1
	ldr	r0, .L2079+32
	uxth	r6, r6
	str	r5, [sp, #12]
	bl	printf
	ldrh	r2, [r4, #2]
	ldr	r3, [sp, #12]
	cmp	r2, #2
	ittt	ls
	ldrhls	r2, [fp]
	addls	r2, r2, #-1
	strhls	r2, [r4, #2]	@ movhi
	cmp	r6, #3
	bls	.L2058
	mov	r2, r6
	ldr	r1, [r3, #4]
	ldr	r0, .L2079+36
	bl	printf
	ldr	r2, [sp, #8]
	movs	r3, #1
	str	r3, [r2]
.L2075:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2064:
	cbz	r1, .L2067
	cmp	r2, #1
	strh	r7, [r4, #40]	@ movhi
	bne	.L2068
.L2069:
	movs	r3, #0
	str	r3, [r4, #36]
	b	.L2058
.L2068:
	cmp	r1, #256
.L2078:
	beq	.L2069
	ldr	r2, [r4, #36]
	cmp	r2, #0
	bne	.L2069
	ldr	r2, [r3, #4]
	ldr	r3, [r4, #24]
	str	r2, [r3, r8, lsl #2]
	b	.L2075
.L2067:
	cmp	r2, #1
	b	.L2078
.L2080:
	.align	2
.L2079:
	.word	.LANCHOR165
	.word	.LANCHOR77
	.word	.LANCHOR214
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR202
	.word	.LANCHOR188
	.word	.LC40
	.word	.LC41
	.word	.LANCHOR54
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
	ldr	r5, .L2082
	muls	r4, r0, r4
	ldr	r0, .L2082+4
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
.L2083:
	.align	2
.L2082:
	.word	.LANCHOR97
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
	ldr	r5, .L2088
	ldr	r6, .L2088+4
.L2085:
	ldrh	r3, [r5]
	uxth	r0, r4
	cmp	r3, r0
	bhi	.L2087
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L2087:
	ldr	r2, [r6]
	uxth	r3, r4
	movs	r1, #12
	mla	r3, r1, r3, r2
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L2086
	bl	flush_l2p_region
.L2086:
	adds	r4, r4, #1
	b	.L2085
.L2089:
	.align	2
.L2088:
	.word	.LANCHOR68
	.word	.LANCHOR97
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
	ldr	r3, .L2102
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	str	r2, [sp]
	adds	r2, r0, r1
	mov	r7, r0
	mov	r5, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L2098
	ldr	r3, .L2102+4
	mov	r8, #0
	ldrh	r6, [r3]
	lsr	r6, r0, r6
	lsl	fp, r6, #2
.L2092:
	cbnz	r5, .L2097
.L2090:
	mov	r0, r8
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2097:
	ldr	r3, .L2102+8
	mov	r0, r7
	ldr	r10, .L2102+24
	ldr	r3, [r3]
	ldr	r2, [r3, fp]
	ldr	r3, .L2102+12
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
	cbz	r2, .L2094
	cmp	r4, r3
	beq	.L2094
	ldr	r3, [r10]
	add	r0, sp, #20
	str	r2, [sp, #24]
	movs	r2, #1
	mov	r1, r2
	str	r3, [sp, #28]
	movs	r3, #0
	str	r3, [sp, #32]
	bl	FlashReadPages
.L2095:
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
	ldr	r0, .L2102+16
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
	b	.L2092
.L2094:
	ldr	r3, .L2102+20
	movs	r1, #0
	ldr	r0, [r10]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L2095
.L2098:
	mov	r8, #-1
	b	.L2090
.L2103:
	.align	2
.L2102:
	.word	.LANCHOR50
	.word	.LANCHOR57
	.word	.LANCHOR194
	.word	.LANCHOR56
	.word	.LANCHOR215
	.word	.LANCHOR58
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
	ldr	r2, .L2106
	ldr	r3, .L2106+4
	ldr	r1, [r2]
	cmp	r1, r3
	bne	.L2104
	ldr	r3, .L2106+8
	movs	r1, #1
	movs	r0, #0
	str	r3, [r2, #4]
	ldr	r3, .L2106+12
	ldr	r3, [r3]
	str	r3, [r2, #88]
	ldr	r3, .L2106+16
	ldr	r3, [r3]
	str	r3, [r2, #92]
	ldr	r3, .L2106+20
	ldr	r3, [r3]
	str	r3, [r2, #8]
	ldr	r3, .L2106+24
	ldr	r3, [r3]
	str	r3, [r2, #12]
	ldr	r3, .L2106+28
	ldr	r3, [r3]
	str	r3, [r2, #16]
	ldr	r3, .L2106+32
	ldr	r3, [r3]
	str	r3, [r2, #20]
	ldr	r3, .L2106+36
	ldr	r3, [r3]
	str	r3, [r2, #28]
	ldr	r3, .L2106+40
	ldr	r3, [r3]
	str	r3, [r2, #32]
	ldr	r3, .L2106+44
	ldr	r3, [r3]
	str	r3, [r2, #36]
	ldr	r3, .L2106+48
	ldr	r3, [r3]
	str	r3, [r2, #40]
	ldr	r3, .L2106+52
	ldr	r3, [r3]
	str	r3, [r2, #44]
	ldr	r3, .L2106+56
	ldr	r3, [r3]
	str	r3, [r2, #48]
	ldr	r3, .L2106+60
	ldr	r3, [r3]
	str	r3, [r2, #60]
	ldr	r3, .L2106+64
	ldr	r3, [r3]
	str	r3, [r2, #64]
	b	FtlVendorPartWrite
.L2104:
	bx	lr
.L2107:
	.align	2
.L2106:
	.word	.LANCHOR138
	.word	1179929683
	.word	1342177360
	.word	.LANCHOR216
	.word	.LANCHOR217
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR166
	.word	.LANCHOR165
	.word	.LANCHOR168
	.word	.LANCHOR80
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
	ldr	r3, .L2115
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L2113
	ldr	r3, .L2115+4
	ldr	r3, [r3]
	cmp	r3, #39
	ite	hi
	movhi	r3, #32
	movls	r3, #4
.L2109:
	ldr	r1, .L2115+8
	ldrh	r2, [r1]
	cmp	r2, #31
	ittt	ls
	addls	r2, r2, #1
	movls	r3, #1
	strhls	r2, [r1]	@ movhi
	ldr	r2, .L2115+12
	cbnz	r0, .L2111
	ldr	r1, [r2]
	ldr	r0, [r1, #20]
	ldr	r1, [r1, #16]
	add	r3, r3, r0
	cmp	r1, r3
	bcc	.L2112
.L2111:
	ldr	r2, [r2]
	movs	r0, #64
	ldr	r3, [r2, #16]
	str	r3, [r2, #20]
	ldr	r3, .L2115+16
	str	r3, [r2]
	ldr	r3, .L2115+20
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
.L2112:
	movs	r0, #0
	pop	{r3, pc}
.L2113:
	movs	r3, #32
	b	.L2109
.L2116:
	.align	2
.L2115:
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
	ldr	r3, .L2144
	push	{r4, r5, r6, lr}
	mov	r4, r0
	ldrh	r5, [r0]
	ldrh	r3, [r3]
	cmp	r3, r5
	bcs	.L2118
	ldr	r1, .L2144+4
	movw	r2, #3233
	ldr	r0, .L2144+8
	bl	printf
	ldr	r1, .L2144+12
	ldr	r0, .L2144+16
	bl	printf
.L2118:
	ldr	r3, .L2144+20
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2119
	movw	r3, #65535
	cmp	r5, r3
	beq	.L2120
	ldr	r3, .L2144+24
	mov	r0, r5
	ldr	r3, [r3]
	ldrh	r3, [r3, r5, lsl #1]
	cbz	r3, .L2121
	bl	INSERT_DATA_LIST
.L2120:
	movs	r3, #0
	strb	r3, [r4, #8]
	ldr	r3, .L2144+28
	cmp	r4, r3
	beq	.L2122
	ldr	r3, .L2144+32
	ldrh	r2, [r3]
	cmp	r2, #1
	beq	.L2122
	ldr	r3, .L2144+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2123
.L2122:
	movs	r3, #1
	strb	r3, [r4, #8]
.L2124:
	ldr	r6, .L2144+40
	movw	r2, #65535
	ldrh	r0, [r6]
	cmp	r0, r2
	beq	.L2129
	cmp	r5, r0
	bne	.L2130
	ldr	r3, .L2144+24
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L2131
.L2130:
	bl	update_vpc_list
.L2131:
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
.L2129:
	mov	r0, r4
	bl	allocate_data_superblock
	bl	l2p_flush
	movs	r0, #0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2119:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L2121:
	bl	INSERT_FREE_LIST
	b	.L2120
.L2123:
	ldr	r3, .L2144+44
	cmp	r4, r3
	bne	.L2124
	cmp	r2, #3
	beq	.L2126
	ldr	r2, .L2144+48
	ldr	r2, [r2]
	cmp	r2, #1
	bne	.L2127
.L2126:
	movs	r2, #1
	strb	r2, [r3, #8]
.L2127:
	ldr	r2, .L2144+52
	ldr	r2, [r2]
	cmp	r2, #0
	beq	.L2124
	ldr	r2, .L2144+56
	ldr	r2, [r2]
	cmp	r2, #39
	itt	ls
	movls	r2, #1
	strbls	r2, [r3, #8]
	b	.L2124
.L2145:
	.align	2
.L2144:
	.word	.LANCHOR40
	.word	.LANCHOR219
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR77
	.word	.LANCHOR84
	.word	.LANCHOR93
	.word	.LANCHOR44
	.word	.LANCHOR8
	.word	.LANCHOR133
	.word	.LANCHOR92
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
	ldr	r3, .L2156
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r2
	adds	r2, r0, r1
	sub	sp, sp, #56
	mov	r7, r0
	mov	r6, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L2155
	ldr	r3, .L2156+4
	mov	r8, #0
	ldr	fp, .L2156+28
	ldrh	r5, [r3]
	lsr	r5, r0, r5
	lsls	r3, r5, #2
	str	r3, [sp]
.L2148:
	cbnz	r6, .L2154
.L2146:
	mov	r0, r8
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2154:
	ldr	r3, .L2156+8
	mov	r0, r7
	ldr	r2, [sp]
	ldr	r3, [r3]
	ldr	r3, [r3, r2]
	ldr	r2, .L2156+12
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
	beq	.L2150
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
	ldr	r2, .L2156+16
	it	eq
	moveq	r8, #-1
	ldr	r2, [r2]
	cmp	r2, #256
	bne	.L2152
	mov	r2, r3
	mov	r1, r5
	ldr	r0, .L2156+20
	bl	printf
	ldr	r2, [fp]
	mov	r1, r5
	ldr	r0, .L2156+24
	bl	FtlMapWritePage
.L2152:
	ldr	r1, [fp]
	lsls	r2, r4, #9
	ldr	r3, [sp, #4]
	mov	r0, r10
	add	r1, r1, r3, lsl #9
	bl	ftl_memcpy
.L2153:
	ldr	r3, [sp, #8]
	adds	r5, r5, #1
	subs	r6, r6, r4
	add	r7, r7, r4
	add	r10, r10, r3
	ldr	r3, [sp]
	adds	r3, r3, #4
	str	r3, [sp]
	b	.L2148
.L2150:
	lsls	r2, r4, #9
	mov	r1, r3
	mov	r0, r10
	bl	ftl_memset
	b	.L2153
.L2155:
	mov	r8, #-1
	b	.L2146
.L2157:
	.align	2
.L2156:
	.word	.LANCHOR50
	.word	.LANCHOR57
	.word	.LANCHOR194
	.word	.LANCHOR56
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
	ldr	r4, .L2160
	ldr	r5, .L2160+4
	ldr	r2, [r4]
	ldrh	r1, [r5]
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	ldr	r2, [r3]
	ldr	r3, .L2160+8
	cmp	r2, r3
	beq	.L2159
	ldr	r1, .L2160+12
	ldr	r0, .L2160+16
	bl	printf
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r0, [r4]
	lsls	r2, r2, #9
	bl	ftl_memset
.L2159:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2161:
	.align	2
.L2160:
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
	ldr	r4, .L2166
	movs	r0, #0
	ldr	r5, .L2166+4
	mov	r2, r4
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	cmp	r3, r5
	beq	.L2163
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	ftl_memset
	str	r5, [r4]
.L2163:
	ldr	r3, [r4]
	cmp	r3, r5
	ldr	r5, .L2166+8
	bne	.L2164
	ldr	r2, [r4, #88]
	ldr	r3, .L2166+12
	str	r2, [r3]
	ldr	r2, [r4, #92]
	ldr	r3, .L2166+16
	str	r2, [r3]
	ldr	r2, [r4, #8]
	ldr	r3, .L2166+20
	str	r2, [r3]
	ldr	r2, [r4, #12]
	ldr	r3, .L2166+24
	str	r2, [r3]
	ldr	r2, [r4, #16]
	ldr	r3, .L2166+28
	str	r2, [r3]
	ldr	r2, [r4, #20]
	ldr	r3, .L2166+32
	str	r2, [r3]
	ldr	r3, [r4, #28]
	ldr	r2, [r4, #32]
	str	r3, [r5]
	ldr	r3, .L2166+36
	str	r2, [r3]
	ldr	r2, [r4, #36]
	ldr	r3, .L2166+40
	str	r2, [r3]
	ldr	r2, [r4, #40]
	ldr	r3, .L2166+44
	str	r2, [r3]
	ldr	r2, [r4, #44]
	ldr	r3, .L2166+48
	str	r2, [r3]
	ldr	r2, [r4, #48]
	ldr	r3, .L2166+52
	str	r2, [r3]
	ldr	r2, [r4, #60]
	ldr	r3, .L2166+56
	str	r2, [r3]
.L2164:
	ldr	r3, .L2166+60
	movs	r2, #0
	str	r2, [r3]
	ldr	r2, [r4, #68]
	ldr	r3, .L2166+64
	cmp	r2, r3
	bne	.L2165
	ldr	r3, .L2166+68
	movs	r2, #1
	ldr	r1, .L2166+72
	ldr	r0, .L2166+76
	str	r2, [r3]
	bl	printf
.L2165:
	ldr	r3, .L2166+80
	ldr	r1, .L2166+84
	ldrh	r2, [r3]
	ldr	r3, .L2166+88
	ldrh	r1, [r1]
	ldr	r0, [r3]
	ldr	r3, [r5]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L2166+92
	str	r0, [r3]
	pop	{r3, r4, r5, pc}
.L2167:
	.align	2
.L2166:
	.word	.LANCHOR138
	.word	1179929683
	.word	.LANCHOR168
	.word	.LANCHOR216
	.word	.LANCHOR217
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR166
	.word	.LANCHOR165
	.word	.LANCHOR80
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
	beq	.L2170
	movs	r3, #0
	ldrh	r6, [r0, #6]
	str	r3, [r0, #36]
	ldr	r3, .L2184
	ldr	r10, [r0, #24]
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2170
	ldr	r3, .L2184+4
	ldr	r5, .L2184+8
	ldr	r3, [r3]
	mov	r7, r5
	str	r3, [r5, #8]
	ldr	r3, .L2184+12
	ldr	r8, [r3]
	ldrh	r3, [r0, #2]
	str	r8, [r5, #12]
	cbz	r3, .L2174
	ldr	r2, .L2184+16
	ldrh	r2, [r2]
	subs	r2, r2, #1
	cmp	r3, r2
	bge	.L2174
	ldrh	r2, [r0]
	movw	r1, #65535
	cmp	r2, r1
	beq	.L2174
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
	beq	.L2174
	ldr	r3, [r4, #24]
	ldrh	r1, [r8, #8]
	ldr	r2, [r3, r1, lsl #2]
	ldr	r3, [r5, #4]
	cmp	r2, r3
	bne	.L2174
	ldr	r2, [r5, #8]
.L2183:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	FtlMapWritePage
.L2174:
	subs	r6, r6, #1
	uxth	r6, r6
	ldr	r3, [r10, r6, lsl #2]
	str	r3, [r7, #4]
	cbz	r3, .L2175
	movs	r2, #1
	ldr	r0, .L2184+8
	mov	r1, r2
	bl	FlashReadPages
.L2176:
	ldr	r2, [r7, #8]
	mov	r1, r6
	b	.L2183
.L2175:
	ldr	r3, .L2184+20
	movs	r1, #255
	ldr	r0, [r7, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L2176
.L2170:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2185:
	.align	2
.L2184:
	.word	.LANCHOR77
	.word	.LANCHOR184
	.word	.LANCHOR202
	.word	.LANCHOR188
	.word	.LANCHOR54
	.word	.LANCHOR58
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
	ldr	r5, .L2268
	sub	sp, sp, #32
	mov	r1, r4
	ldr	r3, .L2268+4
	ldr	r2, [r5]
	ldr	r6, .L2268+8
	strh	r4, [r3]	@ movhi
	ldr	r3, .L2268+12
	lsls	r2, r2, #2
	strh	r4, [r6]	@ movhi
	ldr	r7, .L2268+16
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [r5]
	mov	r1, r4
	ldr	r3, .L2268+20
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L2268+24
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L2268+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	movs	r2, #12
	movs	r1, #255
	ldr	r0, .L2268+32
	bl	ftl_memset
	ldr	r3, .L2268+36
	str	r6, [sp, #12]
	str	r5, [sp, #16]
	ldrh	r3, [r3]
	str	r3, [sp, #4]
.L2187:
	ldr	r3, .L2268+40
	ldr	r2, [sp, #4]
	ldrh	r3, [r3]
	cmp	r3, r2
	bls	.L2229
	ldr	r3, .L2268+44
	movs	r5, #0
	ldr	r1, .L2268+48
	mov	fp, r5
	movs	r7, #36
	ldrh	r8, [r3]
	ldr	r3, .L2268+52
	ldr	r2, [r1]
	ldr	r1, .L2268+56
	ldr	r6, [r3]
	ldr	r3, .L2268+60
	str	r2, [sp, #8]
	ldrh	r10, [r1]
	ldr	r3, [r3]
	ldr	r2, .L2268+64
	b	.L2230
.L2189:
	ldrb	r0, [r2, r5]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #28]
	str	r2, [sp, #24]
	bl	V2P_block
	str	r0, [sp, #20]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #28]
	cbnz	r0, .L2188
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
.L2188:
	adds	r5, r5, #1
.L2230:
	uxth	r1, r5
	cmp	r8, r1
	bhi	.L2189
	cmp	fp, #0
	bne	.L2190
.L2228:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #4]
	b	.L2187
.L2190:
	movs	r7, #0
	movs	r2, #1
	mov	r1, fp
	mov	r0, r6
	bl	FlashReadPages
.L2191:
	uxth	r3, r7
	cmp	fp, r3
	bls	.L2228
	ldr	r3, .L2268+52
	mov	r8, #36
	mul	r8, r8, r7
	ldr	r3, [r3]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	ldr	r5, [r2, #4]
	ldr	r6, [r2, #12]
	adds	r3, r3, #1
	ubfx	r5, r5, #10, #16
	bne	.L2194
	mov	r10, #16
.L2196:
	ldr	r3, .L2268+52
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
	ldr	r3, .L2268+52
	ldr	r3, [r3]
	bne	.L2193
	mov	r2, #-1
	str	r2, [r3, r8]
	ldr	r3, .L2268+52
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	cmp	r3, r2
	beq	.L2195
.L2194:
	ldr	r3, .L2268+68
	ldr	r2, [r3]
	ldr	r3, [r6, #4]
	adds	r1, r2, #1
	beq	.L2197
	cmp	r2, r3
	bhi	.L2198
.L2197:
	adds	r2, r3, #1
	ittt	ne
	ldrne	r1, .L2268+68
	addne	r2, r3, #1
	strne	r2, [r1]
.L2198:
	ldrh	r2, [r6]
	movw	r1, #61604
	cmp	r2, r1
	beq	.L2200
	bhi	.L2201
	movw	r3, #61574
	cmp	r2, r3
	beq	.L2202
.L2199:
	adds	r7, r7, #1
	b	.L2191
.L2193:
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L2194
	add	r10, r10, #-1
	uxth	r10, r10
	cmp	r10, #0
	bne	.L2196
.L2195:
	ldr	r3, .L2268+72
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbnz	r1, .L2267
.L2226:
	mov	r0, r5
	bl	FtlFreeSysBlkQueueIn
	b	.L2199
.L2201:
	movw	r3, #61634
	cmp	r2, r3
	beq	.L2203
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2199
.L2267:
	movs	r1, #0
	b	.L2226
.L2203:
	ldr	r3, .L2268+8
	ldrh	r2, [r3]
	ldr	r3, .L2268
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L2205
	ldr	r1, .L2268+76
	movw	r2, #1297
	ldr	r0, .L2268+80
	bl	printf
	ldr	r1, .L2268+84
	ldr	r0, .L2268+88
	bl	printf
.L2205:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #12]
	ldr	r1, [r3]
	ldrh	r0, [r2]
	ldr	r2, .L2268+12
	uxth	r10, r1
	ldr	ip, [r2]
	add	r3, r10, #-1
	sub	r10, r10, r0
	add	r10, r10, #-1
	sxth	r3, r3
	sxth	r10, r10
.L2206:
	cmp	r3, r10
	bgt	.L2212
	cmp	r3, #0
	bge	.L2245
	b	.L2199
.L2212:
	ldr	r2, [ip, r3, lsl #2]
	add	r8, ip, r3, lsl #2
	ldr	r4, [r6, #4]
	cmp	r4, r2
	bls	.L2207
	ldr	r2, [ip]
	cbnz	r2, .L2208
	cmp	r1, r0
	ittt	ne
	ldrne	r2, .L2268+8
	addne	r0, r0, #1
	strhne	r0, [r2]	@ movhi
.L2208:
	ldr	r2, .L2268+20
	uxth	r10, r3
	ldr	r0, [r2]
	movs	r2, #0
.L2209:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L2210
	ldr	r2, [r6, #4]
	cmp	r3, #0
	str	r2, [r8]
	strh	r5, [r0, r3, lsl #1]	@ movhi
	blt	.L2199
	ldr	r2, .L2268+8
	ldrh	r0, [r2]
	ldr	r2, .L2268
	ldr	r2, [r2]
	subs	r2, r2, r0
	subs	r2, r2, #1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L2199
.L2245:
	ldr	r2, .L2268+8
	adds	r0, r0, #1
	strh	r0, [r2]	@ movhi
	ldr	r2, [r6, #4]
	str	r2, [ip, r3, lsl #2]
	ldr	r2, .L2268+20
.L2265:
	ldr	r2, [r2]
	strh	r5, [r2, r3, lsl #1]	@ movhi
	b	.L2199
.L2210:
	add	lr, ip, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, r0, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [ip, r1, lsl #2]
	strh	lr, [r0, r1, lsl #1]	@ movhi
	b	.L2209
.L2207:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L2206
.L2269:
	.align	2
.L2268:
	.word	.LANCHOR65
	.word	.LANCHOR71
	.word	.LANCHOR128
	.word	.LANCHOR130
	.word	.LANCHOR62
	.word	.LANCHOR129
	.word	.LANCHOR193
	.word	.LANCHOR72
	.word	.LANCHOR209
	.word	.LANCHOR40
	.word	.LANCHOR41
	.word	.LANCHOR38
	.word	.LANCHOR106
	.word	.LANCHOR180
	.word	.LANCHOR59
	.word	.LANCHOR105
	.word	.LANCHOR47
	.word	.LANCHOR159
	.word	.LANCHOR8
	.word	.LANCHOR220
	.word	.LC5
	.word	.LC6
	.word	.LC7
.L2202:
	ldr	r8, .L2270+20
	ldr	r10, .L2270+28
	ldrh	r2, [r8]
	ldrh	r3, [r10]
	cmp	r2, r3
	bls	.L2215
	ldr	r1, .L2270
	mov	r2, #1344
	ldr	r0, .L2270+4
	bl	printf
	ldr	r1, .L2270+8
	ldr	r0, .L2270+12
	bl	printf
.L2215:
	ldr	r2, .L2270+16
	ldrh	lr, [r10]
	ldrh	ip, [r8]
	ldr	r0, [r2]
	add	r10, lr, #-1
	sxth	r3, r10
	sub	r10, r10, ip
.L2216:
	cmp	r3, r10
	ble	.L2221
	ldr	r1, [r6, #4]
	add	r8, r0, r3, lsl #2
	ldr	r2, [r0, r3, lsl #2]
	cmp	r1, r2
	bls	.L2217
	ldr	r2, [r0]
	cbnz	r2, .L2218
	cmp	lr, ip
	ittt	ne
	ldrne	r2, .L2270+20
	addne	ip, ip, #1
	strhne	ip, [r2]	@ movhi
.L2218:
	ldr	r2, .L2270+24
	uxth	r10, r3
	ldr	ip, [r2]
	movs	r2, #0
.L2219:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L2220
	ldr	r2, [r6, #4]
	str	r2, [r8]
	strh	r5, [ip, r3, lsl #1]	@ movhi
.L2221:
	cmp	r3, #0
	blt	.L2199
	ldr	r2, .L2270+28
	ldr	ip, .L2270+20
	ldrh	r2, [r2]
	ldrh	r1, [ip]
	subs	r2, r2, #1
	subs	r2, r2, r1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L2199
	ldr	r2, [r6, #4]
	adds	r1, r1, #1
	strh	r1, [ip]	@ movhi
	str	r2, [r0, r3, lsl #2]
	ldr	r2, .L2270+24
	b	.L2265
.L2220:
	add	lr, r0, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, ip, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [r0, r1, lsl #2]
	strh	lr, [ip, r1, lsl #1]	@ movhi
	b	.L2219
.L2217:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L2216
.L2200:
	ldr	r8, .L2270+48
	movw	r2, #65535
	ldrh	r1, [r8]
	cmp	r1, r2
	bne	.L2223
.L2266:
	strh	r5, [r8]	@ movhi
	str	r3, [r8, #8]
	b	.L2199
.L2223:
	ldrh	r0, [r8, #4]
	cmp	r0, r2
	beq	.L2224
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L2224:
	ldr	r3, [r6, #4]
	ldr	r2, [r8, #8]
	cmp	r2, r3
	bcs	.L2225
	ldrh	r2, [r8]
	strh	r2, [r8, #4]	@ movhi
	b	.L2266
.L2225:
	strh	r5, [r8, #4]	@ movhi
	b	.L2199
.L2229:
	ldr	r3, .L2270+32
	ldr	r2, [r3]
	ldrh	r3, [r2]
	cbz	r3, .L2231
.L2234:
	ldr	r3, .L2270+24
	ldr	r4, [r3]
	ldrh	r2, [r4]
	cmp	r2, #0
	beq	.L2232
.L2233:
	ldr	r3, .L2270+36
	ldrh	r2, [r3]
	ldr	r3, .L2270+40
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L2264
	ldr	r1, .L2270
	movw	r2, #1478
	ldr	r0, .L2270+4
	bl	printf
	ldr	r1, .L2270+8
	ldr	r0, .L2270+12
	bl	printf
.L2264:
	movs	r0, #0
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2231:
	ldr	r1, .L2270+36
	ldrh	r1, [r1]
	cmp	r1, #0
	beq	.L2234
	ldr	r5, .L2270+40
	ldr	r0, [r5]
.L2235:
	sxth	r1, r3
	cmp	r1, r0
	bcs	.L2234
	ldrh	r4, [r2, r1, lsl #1]
	adds	r3, r3, #1
	cmp	r4, #0
	beq	.L2235
	ldr	r3, .L2270+44
	movs	r6, #0
	ldr	r0, [r3]
	mov	r3, r1
.L2236:
	ldr	r4, [r5]
	cmp	r3, r4
	bcs	.L2234
	ldrh	r7, [r2, r3, lsl #1]
	subs	r4, r3, r1
	strh	r7, [r2, r4, lsl #1]	@ movhi
	ldr	r7, [r0, r3, lsl #2]
	str	r7, [r0, r4, lsl #2]
	strh	r6, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	sxth	r3, r3
	b	.L2236
.L2232:
	ldr	r3, .L2270+20
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L2233
	ldr	r5, .L2270+28
	ldrh	r1, [r5]
.L2241:
	sxth	r3, r2
	cmp	r3, r1
	mov	r6, r3
	bge	.L2233
	ldrh	r0, [r4, r3, lsl #1]
	adds	r2, r2, #1
	cmp	r0, #0
	beq	.L2241
	ldr	r2, .L2270+16
	movs	r0, #0
	ldr	r2, [r2]
.L2242:
	ldrh	r1, [r5]
	cmp	r3, r1
	bge	.L2233
	ldrh	r7, [r4, r3, lsl #1]
	subs	r1, r3, r6
	strh	r7, [r4, r1, lsl #1]	@ movhi
	ldr	r7, [r2, r3, lsl #2]
	str	r7, [r2, r1, lsl #2]
	adds	r1, r3, #1
	strh	r0, [r4, r3, lsl #1]	@ movhi
	sxth	r3, r1
	b	.L2242
.L2271:
	.align	2
.L2270:
	.word	.LANCHOR220
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR193
	.word	.LANCHOR71
	.word	.LANCHOR72
	.word	.LANCHOR62
	.word	.LANCHOR129
	.word	.LANCHOR128
	.word	.LANCHOR65
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
	ldr	r8, .L2297+156
	ldr	r5, .L2297
	ldr	r3, [r8]
	ldr	r4, .L2297+4
	ldr	r10, .L2297+160
	ldrh	r2, [r5]
	ldr	r7, .L2297+8
	str	r3, [r4, #8]
	ldr	r6, .L2297+12
	ldr	r3, [r10]
	lsls	r2, r2, #1
	ldr	r0, [r7]
	str	r3, [r4, #12]
	bl	ftl_memset
	ldrh	r0, [r6]
	movw	r3, #65535
	str	r7, [sp]
	cmp	r0, r3
	bne	.L2273
.L2282:
	mov	r0, #-1
.L2272:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2273:
	movs	r1, #1
	mov	fp, r4
	bl	FtlGetLastWrittenPage
	ldr	r3, .L2297+16
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r6, #2]	@ movhi
.L2275:
	cmp	r7, #0
	bge	.L2278
	ldr	r1, .L2297+20
	movw	r2, #1538
	ldr	r0, .L2297+24
	bl	printf
	ldr	r1, .L2297+28
	ldr	r0, .L2297+32
	bl	printf
.L2277:
	ldr	r2, .L2297+36
	ldrh	r3, [r5]
	ldrh	r2, [r2]
	adds	r3, r3, #24
	cmp	r2, r3, lsl #1
	bcs	.L2280
	ldr	r1, .L2297+20
	movw	r2, #1540
	ldr	r0, .L2297+24
	bl	printf
	ldr	r1, .L2297+28
	ldr	r0, .L2297+32
	bl	printf
.L2280:
	movs	r2, #48
	ldr	r1, [r4, #8]
	ldr	r0, .L2297+40
	bl	ftl_memcpy
	ldrh	r2, [r5]
	ldr	r3, [sp]
	ldr	r1, [r4, #8]
	lsls	r2, r2, #1
	ldr	r0, [r3]
	adds	r1, r1, #48
	bl	ftl_memcpy
	ldrh	r1, [r5]
	ldr	r3, [r4, #8]
	lsrs	r2, r1, #3
	adds	r1, r1, #24
	lsls	r1, r1, #1
	adds	r2, r2, #4
	bic	r1, r1, #3
	add	r1, r1, r3
	ldr	r3, .L2297+44
	ldr	r0, [r3]
	bl	ftl_memcpy
	ldr	r3, .L2297+48
	ldrh	r3, [r3]
	cbz	r3, .L2281
	ldrh	r1, [r5]
	ldr	r3, .L2297+52
	ldrh	r2, [r3]
	lsrs	r3, r1, #3
	add	r3, r3, r1, lsl #1
	ldr	r1, [r4, #8]
	adds	r3, r3, #52
	lsls	r2, r2, #2
	ubfx	r3, r3, #2, #14
	add	r1, r1, r3, lsl #2
	ldr	r3, .L2297+56
	ldr	r0, [r3]
	bl	ftl_memcpy
.L2281:
	ldr	r4, .L2297+40
	ldr	r3, .L2297+16
	ldr	r2, [r4]
	cmp	r2, r3
	bne	.L2282
	ldr	r3, .L2297+60
	ldrb	r2, [r4, #10]	@ zero_extendqisi2
	ldrh	r5, [r4, #8]
	ldrh	r3, [r3]
	strh	r5, [r6, #6]	@ movhi
	cmp	r2, r3
	bne	.L2282
	ldr	r3, .L2297+64
	ldr	r2, .L2297+68
	str	r5, [r3]
	ldr	r3, .L2297+72
	ldrh	r3, [r3]
	muls	r3, r5, r3
	str	r3, [r2]
	ldr	r2, .L2297+76
	ldrh	r2, [r2]
	muls	r3, r2, r3
	ldr	r2, .L2297+80
	str	r3, [r2]
	ldr	r3, .L2297+84
	ldr	r6, [r3]
	ldr	r3, .L2297+88
	ldrh	r0, [r3, #6]
	ldr	r3, .L2297+92
	subs	r0, r6, r0
	ldrh	r1, [r3]
	subs	r0, r0, r5
	bl	__aeabi_uidiv
	ldr	r3, .L2297+96
	cmp	r5, r6
	strh	r0, [r3]	@ movhi
	bls	.L2283
	ldr	r1, .L2297+20
	movw	r2, #1567
	ldr	r0, .L2297+24
	bl	printf
	ldr	r1, .L2297+28
	ldr	r0, .L2297+32
	bl	printf
.L2283:
	ldrh	r2, [r4, #16]
	ldr	r3, .L2297+100
	ldrh	ip, [r4, #14]
	ldr	r7, .L2297+104
	lsrs	r1, r2, #6
	and	r2, r2, #63
	strb	r2, [r3, #6]
	ldrb	r2, [r4, #11]	@ zero_extendqisi2
	strh	r1, [r3, #2]	@ movhi
	ldr	r1, .L2297+108
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
	ldr	r2, .L2297+112
	strh	r5, [r2]	@ movhi
	ldrh	r5, [r4, #24]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r2, #6]
	ldrb	r5, [r4, #13]	@ zero_extendqisi2
	strh	r6, [r2, #2]	@ movhi
	ldr	r6, [r4, #32]
	strb	r5, [r2, #8]
	ldr	r5, .L2297+116
	str	r3, [r5]
	ldr	r5, .L2297+120
	str	r3, [r5]
	ldr	r5, .L2297+124
	str	r3, [r5]
	ldr	r5, .L2297+128
	str	r3, [r5]
	ldr	r5, .L2297+132
	str	r6, [r5]
	mov	r6, r1
	ldr	r5, .L2297+136
	str	r3, [r5]
	ldr	r5, .L2297+140
	str	r3, [r5]
	ldr	r5, .L2297+144
	ldr	lr, [r4, #40]
	str	r3, [r5]
	ldr	r3, .L2297+148
	ldr	r5, [r3]
	cmp	lr, r5
	mov	r5, r2
	it	hi
	strhi	lr, [r3]
	ldr	r3, .L2297+152
	ldr	r2, [r4, #36]
	ldr	r1, [r3]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3]
	movw	r3, #65535
	cmp	ip, r3
	beq	.L2286
	ldr	r0, .L2297+100
	bl	make_superblock
.L2286:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2287
	ldr	r0, .L2297+108
	bl	make_superblock
.L2287:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2288
	ldr	r0, .L2297+112
	bl	make_superblock
.L2288:
	ldrh	r2, [r7]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2289
	ldr	r0, .L2297+104
	bl	make_superblock
.L2289:
	movs	r0, #0
	b	.L2272
.L2278:
	ldrh	r2, [r6]
	mov	r0, fp
	str	r3, [sp, #4]
	orr	r2, r7, r2, lsl #10
	str	r2, [r4, #4]
	ldr	r2, [r8]
	str	r2, [r4, #8]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [r4]
	ldr	r3, [sp, #4]
	adds	r2, r2, #1
	beq	.L2276
	ldr	r2, [r8]
	ldr	r2, [r2]
	cmp	r2, r3
	bne	.L2276
	ldr	r2, [r10]
	ldrh	r1, [r2]
	movw	r2, #61604
	cmp	r1, r2
	beq	.L2277
.L2276:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L2275
.L2298:
	.align	2
.L2297:
	.word	.LANCHOR40
	.word	.LANCHOR202
	.word	.LANCHOR84
	.word	.LANCHOR209
	.word	1179929683
	.word	.LANCHOR221
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR58
	.word	.LANCHOR81
	.word	.LANCHOR0
	.word	.LANCHOR70
	.word	.LANCHOR67
	.word	.LANCHOR195
	.word	.LANCHOR45
	.word	.LANCHOR222
	.word	.LANCHOR73
	.word	.LANCHOR53
	.word	.LANCHOR56
	.word	.LANCHOR69
	.word	.LANCHOR42
	.word	.LANCHOR75
	.word	.LANCHOR38
	.word	.LANCHOR223
	.word	.LANCHOR92
	.word	.LANCHOR204
	.word	.LANCHOR93
	.word	.LANCHOR94
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
	ldr	r4, .L2311
	sub	sp, sp, #88
	mov	r8, r1
	ldrh	r3, [r4]
	str	r3, [sp, #24]
	bl	P2V_block_in_plane
	ldr	r1, .L2311+4
	mov	r6, r0
	ldr	r0, .L2311+8
	bl	printf
	ldr	r3, .L2311+12
	mov	r1, r6
	ldr	r0, .L2311+16
	ldr	r3, [r3]
	ldrh	r2, [r3, r6, lsl #1]
	bl	printf
	add	r0, sp, #88
	strh	r6, [r0, #-48]!	@ movhi
	bl	make_superblock
	ldr	r3, .L2311+20
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L2300
	cmp	r8, #0
	bne	.L2309
	mov	r0, r6
	bl	ftl_get_blk_mode
	cmp	r0, #1
	mov	r5, r0
	bne	.L2300
	ldr	r3, .L2311+24
	ldrh	r3, [r3]
	str	r3, [sp, #24]
.L2300:
	movs	r6, #0
	ldrh	r3, [r4]
	ldr	r2, [sp, #24]
	mov	r1, r5
	ldr	r0, .L2311+28
	bl	printf
.L2301:
	ldr	r3, .L2311+32
	movs	r2, #0
	add	ip, sp, #54
	mov	r4, r2
	movw	r10, #65535
	mov	fp, #36
	ldrh	lr, [r3]
	ldr	r3, .L2311+36
	ldr	r0, [r3]
	ldr	r3, .L2311+40
	ldr	r3, [r3]
	str	r3, [sp, #28]
	ldr	r3, .L2311+44
	ldrh	r3, [r3]
	str	r3, [sp, #32]
	ldr	r3, .L2311+48
	ldr	r3, [r3]
	str	r3, [sp, #36]
	ldr	r3, .L2311+52
	ldrh	r8, [r3]
.L2302:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L2304
	ldr	fp, .L2311+56
	mov	r8, #0
	mov	r10, #36
	mov	r2, r5
	mov	r1, r4
	bl	FlashReadPages
.L2305:
	uxth	r3, r8
	cmp	r4, r3
	bhi	.L2306
	adds	r6, r6, #1
	ldr	r3, [sp, #24]
	uxth	r6, r6
	cmp	r3, r6
	bne	.L2301
.L2307:
	movs	r0, #0
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2309:
	movs	r5, #0
	b	.L2300
.L2304:
	ldrh	r3, [ip, #2]!
	cmp	r3, r10
	beq	.L2303
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
.L2303:
	adds	r2, r2, #1
	b	.L2302
.L2306:
	ldr	r3, .L2311+36
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
	b	.L2305
.L2312:
	.align	2
.L2311:
	.word	.LANCHOR53
	.word	.LANCHOR224
	.word	.LC45
	.word	.LANCHOR84
	.word	.LC46
	.word	.LANCHOR8
	.word	.LANCHOR54
	.word	.LC47
	.word	.LANCHOR38
	.word	.LANCHOR180
	.word	.LANCHOR105
	.word	.LANCHOR58
	.word	.LANCHOR106
	.word	.LANCHOR59
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
	ldr	r6, .L2323
	ldr	r1, .L2323+4
	ldr	r0, .L2323+8
	bl	printf
	movs	r3, #0
	str	r3, [sp, #28]
.L2314:
	ldr	r3, .L2323+12
	ldrh	r0, [sp, #28]
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2322
	movs	r0, #0
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2322:
	add	r4, sp, #88
	add	r7, sp, #54
	strh	r0, [r4, #-48]!	@ movhi
	movw	r10, #65535
	bl	ftl_get_blk_mode
	ldr	r3, .L2323+16
	mov	fp, #36
	ldrh	r1, [sp, #28]
	ldr	r2, [r3]
	mov	r3, r0
	ldr	r0, .L2323+20
	ldrh	r2, [r2, r1, lsl #1]
	bl	printf
	mov	r0, r4
	bl	make_superblock
	ldr	r3, .L2323+24
	movs	r2, #0
	ldr	r0, [r6]
	mov	r4, r2
	ldrh	lr, [r3]
	ldr	r3, .L2323+28
	ldr	r3, [r3]
	str	r3, [sp, #32]
	ldr	r3, .L2323+32
	ldrh	ip, [r3]
	ldr	r3, .L2323+36
	ldr	r3, [r3]
	str	r3, [sp, #36]
	ldr	r3, .L2323+40
	ldrh	r8, [r3]
.L2315:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L2317
	ldr	r10, .L2323+44
	movs	r7, #0
	mov	r8, #36
	movs	r2, #0
	mov	r1, r4
	bl	FlashReadPages
.L2318:
	uxth	r3, r7
	cmp	r4, r3
	bhi	.L2319
	ldr	r10, .L2323+48
	movs	r7, #0
	mov	r8, #36
	movs	r2, #1
	mov	r1, r4
	ldr	r0, [r6]
	bl	FlashReadPages
.L2320:
	uxth	r3, r7
	cmp	r4, r3
	bhi	.L2321
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	str	r3, [sp, #28]
	b	.L2314
.L2317:
	ldrh	r3, [r7, #2]!
	cmp	r3, r10
	beq	.L2316
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
.L2316:
	adds	r2, r2, #1
	b	.L2315
.L2319:
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
	b	.L2318
.L2321:
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
	b	.L2320
.L2324:
	.align	2
.L2323:
	.word	.LANCHOR180
	.word	.LANCHOR225
	.word	.LC45
	.word	.LANCHOR41
	.word	.LANCHOR84
	.word	.LC49
	.word	.LANCHOR38
	.word	.LANCHOR105
	.word	.LANCHOR58
	.word	.LANCHOR106
	.word	.LANCHOR59
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
	ldr	r3, [r0, #16]
	movs	r1, #0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldrh	fp, [r0, #6]
	mov	r4, r0
	movs	r6, #0
	ldr	r8, [r0, #24]
	str	r3, [sp, #12]
	ldrh	r3, [r0, #8]
	lsl	r2, fp, #2
	ldr	r10, [r0, #12]
	mov	r0, r8
	ldr	r5, .L2352
	str	r3, [sp, #4]
	bl	ftl_memset
	ldr	r3, .L2352+4
	str	r6, [r4, #32]
	str	r6, [r4, #28]
	ldr	r2, [r3]
	str	r3, [sp, #8]
	str	r2, [r5, #8]
	ldr	r2, .L2352+8
	ldr	r7, [r2]
	movw	r2, #65535
	str	r7, [r5, #12]
	strh	r2, [r4]	@ movhi
	strh	r2, [r4, #2]	@ movhi
	movs	r2, #1
	str	r2, [r4, #36]
.L2326:
	ldr	r2, [sp, #4]
	sxth	r3, r6
	cmp	r3, r2
	bge	.L2343
	ldr	r2, [sp, #4]
	subs	r2, r2, #1
	cmp	r3, r2
	lsl	r2, r3, #1
	bne	.L2327
	ldrh	r0, [r10, r3, lsl #1]
	movs	r1, #1
	add	r5, r10, r2
	str	r3, [sp, #4]
	bl	FtlGetLastWrittenPage
	ldr	r3, [sp, #12]
	sxth	r10, r0
	strh	r6, [r4]	@ movhi
	movs	r6, #0
	adds	r0, r0, #1
	mov	r2, r3
	ldr	r3, [sp, #4]
	strh	r0, [r4, #2]	@ movhi
	ldr	r3, [r2, r3, lsl #2]
	str	r3, [r4, #28]
	ldr	r3, .L2352
.L2328:
	sxth	r2, r6
	cmp	r2, r10
	ble	.L2330
.L2343:
	mov	r0, r4
	bl	ftl_free_no_use_map_blk
	ldr	r3, .L2352+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2332
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L2332:
	mov	r0, r4
	bl	ftl_map_blk_gc
	mov	r0, r4
	bl	ftl_map_blk_gc
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2330:
	ldrh	r1, [r5]
	ldr	r0, .L2352
	str	r3, [sp, #4]
	orr	r2, r2, r1, lsl #10
	str	r2, [r3, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r3, [sp, #4]
	ldr	r2, [r3]
	adds	r2, r2, #1
	beq	.L2329
	ldrh	r2, [r7, #8]
	cmp	fp, r2
	bls	.L2329
	ldrh	r1, [r4, #4]
	ldrh	r0, [r7]
	cmp	r0, r1
	itt	eq
	ldreq	r1, [r3, #4]
	streq	r1, [r8, r2, lsl #2]
.L2329:
	adds	r6, r6, #1
	b	.L2328
.L2327:
	ldr	r1, [sp, #8]
	add	r2, r10, r2
	str	r2, [sp, #16]
	ldr	r0, .L2352
	ldr	r1, [r1]
	str	r1, [r5, #8]
	ldrh	r1, [r10, r3, lsl #1]
	ldr	r3, .L2352+12
	ldrh	r2, [r3]
	str	r3, [sp, #20]
	subs	r2, r2, #1
	orr	r2, r2, r1, lsl #10
	str	r2, [r5, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [r5]
	adds	r2, r2, #1
	beq	.L2345
	ldrh	r1, [r7]
	ldrh	r2, [r4, #4]
	ldr	r3, [sp, #20]
	cmp	r1, r2
	bne	.L2345
	ldrh	r1, [r7, #8]
	movw	r2, #64245
	cmp	r1, r2
	beq	.L2334
.L2345:
	movs	r3, #0
.L2335:
	ldr	r1, .L2352+12
	sxth	r2, r3
	ldrh	r1, [r1]
	cmp	r2, r1
	bge	.L2341
	str	r3, [sp, #20]
	ldr	r3, [sp, #16]
	ldr	r0, .L2352
	ldrh	r1, [r3]
	orr	r2, r2, r1, lsl #10
	str	r2, [r5, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [r5]
	ldr	r3, [sp, #20]
	adds	r2, r2, #1
	beq	.L2339
	ldrh	r2, [r7, #8]
	cmp	fp, r2
	bls	.L2339
	ldrh	r1, [r4, #4]
	ldrh	r0, [r7]
	cmp	r0, r1
	itt	eq
	ldreq	r1, [r5, #4]
	streq	r1, [r8, r2, lsl #2]
.L2339:
	adds	r3, r3, #1
	b	.L2335
.L2334:
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r3, [sp, #8]
	subs	r2, r2, #1
	ldr	ip, [r3]
.L2336:
	sxth	r3, r1
	cmp	r3, r2
	blt	.L2338
.L2341:
	adds	r6, r6, #1
	b	.L2326
.L2338:
	lsls	r0, r3, #3
	ldr	r3, [ip, r3, lsl #3]
	adds	r1, r1, #1
	uxth	lr, r3
	cmp	fp, lr
	itttt	hi
	addhi	r0, r0, ip
	movhi	r3, lr
	ldrhi	r0, [r0, #4]
	strhi	r0, [r8, r3, lsl #2]
	b	.L2336
.L2353:
	.align	2
.L2352:
	.word	.LANCHOR202
	.word	.LANCHOR183
	.word	.LANCHOR188
	.word	.LANCHOR54
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
	ldr	r3, .L2355
	ldr	r0, .L2355+4
	ldrh	r3, [r3]
	strh	r3, [r0, #10]	@ movhi
	movw	r3, #61574
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L2355+8
	ldrh	r3, [r3]
	strh	r3, [r0, #8]	@ movhi
	ldr	r3, .L2355+12
	ldrh	r3, [r3]
	strh	r3, [r0, #6]	@ movhi
	ldr	r3, .L2355+16
	ldr	r3, [r3]
	str	r3, [r0, #12]
	ldr	r3, .L2355+20
	ldr	r3, [r3]
	str	r3, [r0, #16]
	ldr	r3, .L2355+24
	ldr	r3, [r3]
	str	r3, [r0, #20]
	ldr	r3, .L2355+28
	ldr	r3, [r3]
	str	r3, [r0, #24]
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L2356:
	.align	2
.L2355:
	.word	.LANCHOR62
	.word	.LANCHOR215
	.word	.LANCHOR71
	.word	.LANCHOR63
	.word	.LANCHOR72
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
	ldr	r0, .L2358
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L2359:
	.align	2
.L2358:
	.word	.LANCHOR127
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
	.section	.text.FtlGcScanTempBlk,"ax",%progbits
	.align	1
	.global	FtlGcScanTempBlk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcScanTempBlk, %function
FtlGcScanTempBlk:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2387
	movw	r2, #65535
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	mov	r5, r0
	ldrh	r4, [r3]
	str	r3, [sp, #16]
	cmp	r4, r2
	beq	.L2378
	cbnz	r4, .L2361
.L2362:
	bl	FtlGcPageVarInit
	b	.L2363
.L2378:
	movs	r4, #0
.L2361:
	ldr	r3, .L2387+4
	ldrh	r3, [r3]
	cmp	r3, r1
	beq	.L2362
.L2363:
	ldr	fp, .L2387+44
	mov	r3, #-1
	str	r3, [sp, #8]
.L2375:
	ldrh	r2, [r5]
	movw	r3, #65535
	movs	r0, #0
	strb	r0, [r5, #8]
	cmp	r2, r3
	beq	.L2364
.L2377:
	ldr	r3, .L2387+8
	movw	ip, #65535
	ldr	r0, [fp]
	mov	lr, #36
	ldrh	r8, [r3]
	ldr	r3, .L2387+12
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2387+16
	ldrh	r10, [r3]
	add	r3, r5, #16
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r6, r3
.L2365:
	uxth	r2, r3
	cmp	r8, r2
	bhi	.L2367
	movs	r7, #0
	mov	r10, #36
	movs	r2, #0
	mov	r1, r6
	bl	FlashReadPages
.L2368:
	uxth	r3, r7
	cmp	r6, r3
	bhi	.L2376
	ldr	r3, .L2387+4
	adds	r4, r4, #1
	uxth	r4, r4
	ldrh	r3, [r3]
	cmp	r3, r4
	bhi	.L2377
	movs	r0, #0
	b	.L2364
.L2367:
	ldr	r1, [sp, #4]
	ldrh	r2, [r1], #2
	cmp	r2, ip
	str	r1, [sp, #4]
	beq	.L2366
	mla	r1, lr, r6, r0
	orr	r2, r4, r2, lsl #10
	str	r2, [r1, #4]
	movs	r2, #0
	str	r2, [r1, #8]
	mul	r2, r10, r6
	adds	r6, r6, #1
	uxth	r6, r6
	bic	r2, r2, #3
	mov	r7, r2
	ldr	r2, [sp, #12]
	add	r7, r7, r2
	str	r7, [r1, #12]
.L2366:
	adds	r3, r3, #1
	b	.L2365
.L2376:
	mul	r8, r10, r7
	ldr	r2, [fp]
	str	r2, [sp, #20]
	add	r3, r2, r8
	ldr	r1, [r3, #4]
	str	r3, [sp, #12]
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_plane
	ldr	r2, [sp, #20]
	ldr	r1, [sp, #4]
	ldr	r2, [r2, r8]
	cbnz	r2, .L2369
	ldr	r3, [sp, #12]
	movw	ip, #65535
	adds	r7, r7, #1
	ldr	r3, [r3, #12]
	ldrh	r2, [r3]
	cmp	r2, ip
	bne	.L2370
	ldr	r3, .L2387+20
	movs	r2, #1
	str	r2, [r3]
.L2364:
	ldr	r2, [sp, #16]
	movw	r3, #65535
	strb	r0, [r5, #6]
	mov	r1, r4
	strh	r4, [r5, #2]	@ movhi
	strh	r3, [r2]	@ movhi
	mov	r2, r0
	mov	r0, r5
	bl	ftl_sb_update_avl_pages
	ldr	r0, [sp, #8]
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2370:
	ldr	r2, [r3, #8]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L2368
.L2369:
	mov	r2, r1
	ldr	r0, .L2387+24
	ldrh	r1, [r5]
	bl	printf
	ldr	r3, .L2387+28
	ldrh	r2, [r5]
	ldr	r3, [r3]
	cbnz	r3, .L2371
	ldr	r3, .L2387+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2372
.L2371:
	ldr	r3, .L2387+36
	ldr	r3, [r3]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r3, #159
	bls	.L2373
.L2372:
	ldr	r3, [fp]
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L2374
.L2373:
	ldr	r3, [fp]
	add	r3, r3, r8
	ldr	r3, [r3, #4]
	str	r3, [sp, #8]
.L2374:
	ldr	r3, .L2387+40
	movs	r4, #0
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5]
	bl	INSERT_FREE_LIST
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
	bl	FtlGcPageVarInit
	b	.L2375
.L2388:
	.align	2
.L2387:
	.word	.LANCHOR226
	.word	.LANCHOR53
	.word	.LANCHOR38
	.word	.LANCHOR106
	.word	.LANCHOR59
	.word	.LANCHOR135
	.word	.LC52
	.word	.LANCHOR28
	.word	.LANCHOR8
	.word	.LANCHOR79
	.word	.LANCHOR84
	.word	.LANCHOR180
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
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
	ldr	r2, .L2402
	sub	sp, sp, #48
	mov	r6, r1
	mov	r4, r0
	ldr	r7, .L2402+4
	ldrh	r3, [r2, #14]
	ldrh	r2, [r2, #12]
	smulbb	r3, r3, r2
	ldr	r2, [r7]
	uxth	r3, r3
	str	r2, [sp, #20]
	ldr	r2, .L2402+8
	subs	r5, r3, #1
	mul	r10, r6, r3
	uxth	r5, r5
	subs	r3, r3, #15
	ldr	r1, [r2]
	mov	r8, r2
	str	r1, [sp, #24]
.L2390:
	cmp	r3, r5
	ble	.L2397
	mov	r0, #-1
	b	.L2389
.L2397:
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
	beq	.L2391
	ldr	r2, [r8]
	ldrh	r1, [r2]
	movw	r2, #61664
	cmp	r1, r2
	bne	.L2391
	cbz	r4, .L2398
	cbz	r6, .L2393
.L2396:
	mov	r2, fp
	ldr	r1, [r7]
	mov	r0, r4
	bl	ftl_memcpy
	movs	r3, #4
	ldr	r0, .L2402+12
	mov	r2, r3
	mov	r1, r4
	bl	rknand_print_hex
	movs	r0, #0
.L2389:
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2393:
	ldr	r1, [r7]
	mov	ip, #1
	ldr	r5, .L2402+16
.L2394:
	ldr	r0, [r5]
	uxth	r3, r6
	adds	r6, r6, #1
	cmp	r3, r0
	bcs	.L2396
	lsrs	r0, r3, #5
	and	r3, r3, #31
	lsl	r3, ip, r3
	ldr	r2, [r1, r0, lsl #2]
	orrs	r3, r3, r2
	str	r3, [r1, r0, lsl #2]
	b	.L2394
.L2391:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2390
.L2398:
	mov	r0, r4
	b	.L2389
.L2403:
	.align	2
.L2402:
	.word	.LANCHOR15
	.word	.LANCHOR147
	.word	.LANCHOR197
	.word	.LC53
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
	ldr	r3, .L2414
	ldr	r6, .L2414+4
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
	bne	.L2405
.L2409:
	movs	r3, #0
.L2406:
	movw	r2, #65535
	movs	r0, #0
	strh	r2, [r5, r3, lsl #1]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L2405:
	ldr	r7, [r6]
	movs	r2, #0
	lsr	ip, r4, #4
	mov	r3, r2
	subs	r4, r4, #1
	mov	lr, #1
.L2407:
	uxth	r1, r2
	cmp	r1, r4
	bge	.L2406
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
	bcc	.L2407
	b	.L2409
.L2415:
	.align	2
.L2414:
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
	ldr	r3, .L2436
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r7, [r3]
	cmp	r7, #0
	bne	.L2417
	ldr	r8, .L2436+40
	ldr	r4, .L2436+4
	bl	FtlBbtMemInit
	sub	r10, r8, #18
	bl	FtlLoadFactoryBbt
.L2418:
	ldr	r3, .L2436+8
	ldrh	r3, [r3]
	cmp	r7, r3
	bcc	.L2424
	ldr	r5, .L2436+12
	movs	r4, #0
.L2425:
	ldrh	r3, [r5]
	uxth	r0, r4
	adds	r4, r4, #1
	cmp	r3, r0
	bhi	.L2426
	ldr	r4, .L2436+16
	movw	r6, #65535
	ldrh	r5, [r4, #12]
	subs	r5, r5, #1
	uxth	r5, r5
.L2427:
	ldrh	r3, [r4, #12]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L2431
	mov	r0, r5
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L2428
	mov	r0, r5
	bl	FlashTestBlk
	cmp	r0, #0
	beq	.L2429
	mov	r0, r5
	bl	FtlBbmMapBadBlock
.L2428:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2427
.L2424:
	ldr	r3, .L2436+20
	movw	r1, #65535
	ldrh	r2, [r10, #2]!
	ldr	r0, [r3]
	ldr	r3, .L2436+24
	cmp	r2, r1
	str	r0, [r4, #8]
	ldr	fp, [r3]
	str	r3, [sp, #4]
	ldr	r3, .L2436+28
	str	fp, [r4, #12]
	beq	.L2419
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
.L2420:
	uxth	r0, r6
	adds	r7, r7, #1
	add	r8, r8, #4
	bl	FtlBbmMapBadBlock
	b	.L2418
.L2419:
	mov	r1, r7
	str	r3, [sp]
	bl	FlashGetBadBlockList
	ldr	r1, [r8]
	ldr	r0, [r4, #8]
	bl	FtlBbt2Bitmap
	ldr	r3, [sp]
	ldrh	r5, [r3]
.L2422:
	subs	r5, r5, #1
	uxth	r5, r5
.L2421:
	ldr	r3, [sp]
	ldrh	r0, [r3]
	smlabb	r0, r0, r7, r5
	uxth	r0, r0
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L2422
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
	ldr	r3, .L2436+32
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
	bne	.L2420
	uxth	r0, r6
	bl	FtlBbmMapBadBlock
	b	.L2421
.L2426:
	bl	FtlBbmMapBadBlock
	b	.L2425
.L2429:
	ldrh	r3, [r4]
	cmp	r3, r6
	bne	.L2430
	strh	r5, [r4]	@ movhi
	b	.L2428
.L2430:
	strh	r5, [r4, #4]	@ movhi
.L2431:
	ldr	r3, .L2436+36
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
.L2417:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2437:
	.align	2
.L2436:
	.word	.LANCHOR77
	.word	.LANCHOR202
	.word	.LANCHOR45
	.word	.LANCHOR60
	.word	.LANCHOR75
	.word	.LANCHOR183
	.word	.LANCHOR188
	.word	.LANCHOR51
	.word	.LANCHOR123
	.word	.LANCHOR78
	.word	.LANCHOR75+28
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
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r3, .L2457
	str	r2, [sp, #8]
	ldrh	r3, [r3]
	str	r1, [sp, #4]
	adds	r2, r3, #7
	movs	r3, #1
	lsls	r3, r3, r2
	lsr	r7, r0, r2
	subs	r3, r3, #1
	uxth	r6, r7
	ands	r3, r3, r0
	uxth	fp, r3
	ldr	r3, .L2457+4
	ldr	r3, [r3]
	cmp	r0, r3
	bcc	.L2439
	ldr	r1, .L2457+8
	mov	r2, #880
	ldr	r0, .L2457+12
	bl	printf
	ldr	r1, .L2457+16
	ldr	r0, .L2457+20
	bl	printf
.L2439:
	ldr	r5, .L2457+24
	movs	r4, #12
	ldr	r3, .L2457+28
	ldr	r1, [r5]
	ldrh	r2, [r3]
	movs	r3, #0
.L2440:
	uxth	r10, r3
	cmp	r10, r2
	bcc	.L2445
	bl	select_l2p_ram_region
	muls	r4, r0, r4
	ldr	r3, [r5]
	mov	r10, r0
	ldrh	r1, [r3, r4]
	adds	r2, r3, r4
	movw	r3, #65535
	cmp	r1, r3
	beq	.L2446
	ldr	r3, [r2, #4]
	cmp	r3, #0
	bge	.L2446
	bl	flush_l2p_region
.L2446:
	ldr	r3, .L2457+32
	ldrh	r3, [r3]
	cmp	r3, r6
	bcs	.L2447
	ldr	r1, .L2457+36
	movw	r2, #526
	ldr	r0, .L2457+12
	bl	printf
	ldr	r1, .L2457+16
	ldr	r0, .L2457+20
	bl	printf
.L2447:
	ldr	r3, .L2457+40
	uxth	r7, r7
	ldr	r3, [r3]
	ldr	r3, [r3, r7, lsl #2]
	cmp	r3, #0
	bne	.L2448
	ldr	r2, [r5]
	movs	r1, #255
	str	r3, [sp]
	adds	r0, r2, r4
	ldr	r2, .L2457+44
	ldr	r0, [r0, #8]
	ldrh	r2, [r2]
	bl	ftl_memset
	ldr	r2, [r5]
	ldr	r3, [sp]
	adds	r1, r2, r4
	strh	r6, [r2, r4]	@ movhi
	str	r3, [r1, #4]
	b	.L2441
.L2445:
	adds	r3, r3, #1
	mla	r0, r4, r3, r1
	ldrh	r0, [r0, #-12]
	cmp	r0, r6
	bne	.L2440
.L2441:
	ldr	r2, [sp, #8]
	movs	r3, #12
	ldr	r1, .L2457+24
	cbnz	r2, .L2442
	ldr	r2, [r1]
	mla	r3, r3, r10, r2
	ldr	r2, [sp, #4]
	ldr	r3, [r3, #8]
	ldr	r3, [r3, fp, lsl #2]
	str	r3, [r2]
.L2443:
	ldr	r2, [r1]
	movs	r3, #12
	mla	r10, r3, r10, r2
	ldr	r3, [r10, #4]
	adds	r2, r3, #1
	beq	.L2454
	adds	r3, r3, #1
	str	r3, [r10, #4]
.L2454:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2442:
	ldr	r2, [r5]
	mla	r3, r3, r10, r2
	ldr	r2, [sp, #4]
	ldr	r0, [r2]
	ldr	r2, [r3, #8]
	str	r0, [r2, fp, lsl #2]
	ldr	r2, [r3, #4]
	orr	r2, r2, #-2147483648
	str	r2, [r3, #4]
	ldr	r3, .L2457+48
	strh	r6, [r3]	@ movhi
	b	.L2443
.L2448:
	ldr	r2, [r5]
	ldr	r8, .L2457+80
	str	r3, [sp, #12]
	add	r2, r2, r4
	ldr	r2, [r2, #8]
	mov	r0, r8
	str	r3, [r8, #4]
	str	r2, [r8, #8]
	ldr	r2, .L2457+52
	ldr	r2, [r2]
	str	r2, [r8, #12]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r3, [r8, #12]
	ldrh	r2, [r3, #8]
	str	r3, [sp]
	ldr	r3, [sp, #12]
	cmp	r2, r6
	beq	.L2449
	mov	r2, r3
	mov	r1, r7
	ldr	r0, .L2457+56
	bl	printf
	movs	r3, #4
	ldr	r1, [r8, #12]
	mov	r2, r3
	ldr	r0, .L2457+60
	bl	rknand_print_hex
	ldr	r3, .L2457+32
	movs	r2, #4
	ldr	r1, .L2457+40
	ldr	r0, .L2457+64
	ldrh	r3, [r3]
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r3, .L2457+68
	movs	r2, #1
	str	r2, [r3]
.L2450:
	ldr	r3, [sp]
	ldrh	r3, [r3, #8]
	cmp	r3, r6
	beq	.L2451
	ldr	r1, .L2457+36
	mov	r2, #552
	ldr	r0, .L2457+12
	bl	printf
	ldr	r1, .L2457+16
	ldr	r0, .L2457+20
	bl	printf
.L2451:
	ldr	r3, .L2457+24
	movs	r1, #0
	ldr	r3, [r3]
	adds	r2, r3, r4
	str	r1, [r2, #4]
	strh	r6, [r3, r4]	@ movhi
	b	.L2441
.L2449:
	ldr	r2, [r8]
	cmp	r2, #256
	bne	.L2450
	mov	r2, r3
	mov	r1, r7
	ldr	r0, .L2457+72
	bl	printf
	ldr	r3, [r5]
	mov	r1, r7
	ldr	r0, .L2457+76
	add	r3, r3, r4
	ldr	r2, [r3, #8]
	bl	FtlMapWritePage
	b	.L2450
.L2458:
	.align	2
.L2457:
	.word	.LANCHOR57
	.word	.LANCHOR73
	.word	.LANCHOR227
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR97
	.word	.LANCHOR68
	.word	.LANCHOR67
	.word	.LANCHOR228
	.word	.LANCHOR131
	.word	.LANCHOR58
	.word	.LANCHOR98
	.word	.LANCHOR188
	.word	.LC54
	.word	.LC27
	.word	.LC55
	.word	.LANCHOR77
	.word	.LC56
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
	ldr	r3, .L2479
	mov	r5, r0
	mov	r10, r1
	ldr	r7, [r3]
	mov	r8, r3
	cbnz	r7, .L2459
	ldr	r3, .L2479+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2474
	ldrb	r6, [r4, #8]	@ zero_extendqisi2
	subs	r3, r6, #1
	rsbs	r6, r3, #0
	adcs	r6, r6, r3
.L2461:
	ldr	fp, .L2479+40
	mov	r2, r6
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	mov	r1, r10
	mov	r0, r5
	bl	FlashProgPages
.L2462:
	cmp	r7, r10
	bne	.L2472
	ldr	r3, .L2479+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2459
	ldr	r1, .L2479+12
	mov	r2, #1600
	ldr	r0, .L2479+16
	bl	printf
	ldr	r1, .L2479+20
	ldr	r0, .L2479+24
	bl	printf
.L2459:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2474:
	mov	r6, r7
	b	.L2461
.L2465:
	ldr	r0, [r5, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r4]
	cmp	r3, r0
	bne	.L2463
	ldr	r1, [fp]
	ldrh	r0, [r4, #4]
	ldrh	r2, [r1, r3, lsl #1]
	subs	r2, r2, r0
	strh	r2, [r1, r3, lsl #1]	@ movhi
	ldr	r3, .L2479+28
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
.L2463:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L2464
	mov	r0, r4
	bl	allocate_new_data_superblock
.L2464:
	ldr	r2, .L2479+32
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
	bne	.L2459
.L2472:
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L2465
	ldr	r3, .L2479+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2466
	ldr	r1, .L2479+12
	movw	r2, #1583
	ldr	r0, .L2479+16
	bl	printf
	ldr	r1, .L2479+20
	ldr	r0, .L2479+24
	bl	printf
.L2466:
	ldr	r3, [r5, #4]
	cbnz	r6, .L2467
.L2478:
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
	beq	.L2469
	ldr	r2, [fp]
	ldrh	r2, [r2, r0, lsl #1]
	cbnz	r2, .L2470
	mov	r1, r0
	str	r0, [sp, #4]
	ldr	r0, .L2479+36
	bl	printf
	ldr	r3, [sp, #4]
.L2470:
	mov	r0, r3
	bl	decrement_vpc_count
.L2469:
	adds	r7, r7, #1
	adds	r5, r5, #36
	b	.L2462
.L2467:
	orr	r3, r3, #-2147483648
	b	.L2478
.L2480:
	.align	2
.L2479:
	.word	.LANCHOR77
	.word	.LANCHOR8
	.word	.LANCHOR38
	.word	.LANCHOR229
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR53
	.word	.LANCHOR138
	.word	.LC57
	.word	.LANCHOR84
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
	ldr	r3, .L2486
	ldr	r4, [r3]
	cbnz	r4, .L2482
	ldr	r5, .L2486+4
	ldr	r0, [r5]
	cbz	r0, .L2482
	ldr	r3, .L2486+8
	mov	r2, r4
	movs	r1, #1
	ldr	r3, [r3]
	bl	FtlProgPages
	str	r4, [r5]
.L2482:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2487:
	.align	2
.L2486:
	.word	.LANCHOR77
	.word	.LANCHOR132
	.word	.LANCHOR230
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
	ldr	r3, .L2490
	ldr	r3, [r3]
	cbnz	r3, .L2489
	bl	FtlCacheWriteBack
	bl	l2p_flush
	movs	r0, #1
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2489:
	movs	r0, #0
	pop	{r3, pc}
.L2491:
	.align	2
.L2490:
	.word	.LANCHOR77
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
	ldr	r3, .L2494
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L2493
	bl	FtlSysFlush
.L2493:
	movs	r0, #0
	pop	{r3, pc}
.L2495:
	.align	2
.L2494:
	.word	.LANCHOR231
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
	ldr	r3, .L2512
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r5, r2
	adds	r2, r1, r2
	mov	r6, r1
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L2505
	cmp	r5, #31
	bhi	.L2499
.L2500:
	movs	r0, #0
.L2497:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2499:
	ldr	r3, .L2512+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2500
	ldr	r8, .L2512+16
	bl	FtlCacheWriteBack
	mov	r0, r6
	ldrh	r4, [r8]
	mov	r1, r4
	bl	__aeabi_uidiv
	smulbb	r3, r0, r4
	mov	r7, r0
	subs	r6, r6, r3
	uxth	r6, r6
	cbz	r6, .L2501
	subs	r4, r4, r6
	adds	r7, r7, #1
	cmp	r4, r5
	it	cs
	movcs	r4, r5
	uxth	r4, r4
	subs	r5, r5, r4
.L2501:
	ldr	r4, .L2512+8
	mov	r3, #-1
	ldr	r6, .L2512+12
	str	r3, [sp, #4]
.L2502:
	ldrh	r3, [r8]
	cmp	r5, r3
	bcs	.L2504
	ldr	r3, .L2512+8
	ldr	r2, [r3]
	cmp	r2, #32
	bls	.L2500
	movs	r4, #0
	str	r4, [r3]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L2500
.L2504:
	movs	r2, #0
	mov	r1, sp
	mov	r0, r7
	bl	log2phys
	ldr	r3, [sp]
	adds	r3, r3, #1
	beq	.L2503
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
.L2503:
	ldrh	r3, [r8]
	adds	r7, r7, #1
	subs	r5, r5, r3
	b	.L2502
.L2505:
	mov	r0, #-1
	b	.L2497
.L2513:
	.align	2
.L2512:
	.word	.LANCHOR69
	.word	.LANCHOR77
	.word	.LANCHOR232
	.word	.LANCHOR163
	.word	.LANCHOR56
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
	ldr	r7, .L2528
	sub	sp, sp, #32
	movs	r1, #0
	ldr	r8, .L2528+24
	ldr	r0, .L2528+4
	bl	printf
.L2515:
	ldr	r3, [r7]
	cmp	r5, r3
	bcc	.L2521
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2521:
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r5
	bl	log2phys
	ubfx	r3, r5, #0, #11
	cbnz	r3, .L2516
	ldr	r2, [sp, #28]
	mov	r1, r5
	mov	r0, r8
	bl	printf
.L2516:
	ldr	r3, [sp, #28]
	adds	r2, r3, #1
	beq	.L2518
	ldr	r4, .L2528+8
	movs	r2, #0
	movs	r1, #1
	str	r3, [r4, #4]
	mov	r0, r4
	ldr	r3, .L2528+12
	str	r5, [r4, #16]
	str	r2, [r4]
	ldr	r3, [r3]
	str	r3, [r4, #8]
	ldr	r3, .L2528+16
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FlashReadPages
	ldr	r3, [r4]
	cmp	r3, #256
	beq	.L2519
	adds	r3, r3, #1
	beq	.L2519
	ldr	r3, [r6, #8]
	cmp	r5, r3
	beq	.L2518
.L2519:
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #12]
	ldr	r0, .L2528+20
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
.L2518:
	adds	r5, r5, #1
	b	.L2515
.L2529:
	.align	2
.L2528:
	.word	.LANCHOR73
	.word	.LC58
	.word	.LANCHOR202
	.word	.LANCHOR183
	.word	.LANCHOR188
	.word	.LC60
	.word	.LC59
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
	ldr	r5, .L2540
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r2, [r5]
	mov	r7, r0
	ldrh	r3, [r2, r0, lsl #1]
	cmp	r3, #0
	bne	.L2531
	ldr	r2, .L2540+4
	ldr	r4, [r2]
	cmp	r4, #0
	beq	.L2532
	ldr	r2, .L2540+8
	movw	lr, #65535
	ldr	ip, .L2540+32
	ldr	r0, .L2540+12
	ldr	r2, [r2]
	ldrh	r1, [r0]
	mov	r8, r0
	subs	r4, r4, r2
	asrs	r4, r4, #1
	mul	r4, ip, r4
	mov	ip, #6
	uxth	r4, r4
.L2533:
	uxth	r0, r3
	cmp	r1, r0
	bls	.L2532
	cmp	r4, r7
	bne	.L2534
	mov	r1, r4
	ldr	r0, .L2540+4
	bl	List_remove_node
	ldrh	r3, [r8]
	cbnz	r3, .L2535
	ldr	r1, .L2540+16
	movw	r2, #2070
	ldr	r0, .L2540+20
	bl	printf
	ldr	r1, .L2540+24
	ldr	r0, .L2540+28
	bl	printf
.L2535:
	ldrh	r3, [r8]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r8]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r2, [r5]
	ldrh	r3, [r2, r7, lsl #1]
.L2531:
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	b	.L2532
.L2534:
	mul	r4, ip, r4
	adds	r3, r3, #1
	ldrh	r4, [r2, r4]
	cmp	r4, lr
	bne	.L2533
.L2532:
	movs	r2, #1
	add	r1, sp, #4
	mov	r0, r6
	bl	log2phys
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2541:
	.align	2
.L2540:
	.word	.LANCHOR84
	.word	.LANCHOR88
	.word	.LANCHOR82
	.word	.LANCHOR89
	.word	.LANCHOR233
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
	beq	.L2702
	ldrh	r3, [r0, #2]
	str	r3, [sp, #12]
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	str	r3, [sp, #28]
	ldr	r3, .L2711
	ldrh	r3, [r3]
	cmp	r3, r1
	mov	r3, #0
	bne	.L2545
	strh	r3, [r0, #4]	@ movhi
.L2709:
	strb	r3, [r10, #6]
.L2702:
	movs	r0, #0
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2545:
	ldrh	r0, [r0, #16]
.L2546:
	cmp	r0, r2
	uxth	r5, r3
	add	r3, r3, #1
	beq	.L2547
	ldrb	r1, [r10, #8]	@ zero_extendqisi2
	cmp	r1, #1
	bne	.L2548
	bl	FtlGetLastWrittenPage
	adds	r6, r0, #1
	mov	r4, r0
	beq	.L2549
	ldr	r3, .L2711+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2626
	ldr	r3, .L2711+8
	ldrh	r5, [r3, r0, lsl #1]
.L2550:
	ldr	r3, .L2711+12
	movw	r8, #65535
	mov	fp, #36
	ldrh	ip, [r3]
	ldr	r3, .L2711+16
	ldr	r0, [r3]
	ldr	r3, .L2711+20
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L2711+24
	ldrh	lr, [r3]
	add	r3, r10, #16
	str	r3, [sp, #20]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r6, r3
.L2551:
	uxth	r2, r3
	cmp	ip, r2
	bhi	.L2555
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L2627
	ldr	r3, .L2711+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #0
	it	ne
	movne	r3, #1
.L2703:
	str	r3, [sp, #36]
	mov	r1, r6
	ldr	r2, [sp, #36]
	movs	r7, #0
	bl	FlashReadPages
	ldr	r3, .L2711+28
	movw	fp, #65535
	ldr	r8, .L2711+16
	ldr	r3, [r3]
	subs	r3, r3, #1
	str	r3, [sp, #4]
.L2557:
	uxth	r3, r7
	cmp	r6, r3
	bhi	.L2562
	bne	.L2560
	adds	r4, r4, #1
	uxth	r3, r4
	str	r3, [sp, #8]
	ldr	r3, [r8]
	ldr	r0, [r3, #4]
.L2704:
	ubfx	r0, r0, #10, #16
	bl	P2V_plane
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	str	r0, [sp, #16]
	cmp	r3, #1
	bne	.L2564
	ldr	r2, .L2711+4
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L2564
	ldr	r1, [sp, #8]
	ldr	r2, .L2711+8
	ldrh	r2, [r2, r1, lsl #1]
	str	r2, [sp, #8]
.L2564:
	ldr	r2, .L2711
	ldr	r1, [sp, #8]
	ldrh	r2, [r2]
	cmp	r2, r1
	bne	.L2565
	ldrh	r2, [sp, #8]
	strh	r2, [r10, #2]	@ movhi
	movs	r2, #0
	strb	r2, [r10, #6]
	strh	r2, [r10, #4]	@ movhi
.L2565:
	ldr	r2, [sp, #8]
	ldr	r1, [sp, #12]
	cmp	r2, r1
	bne	.L2566
	ldr	r2, [sp, #16]
	ldr	r1, [sp, #28]
	cmp	r2, r1
	bne	.L2566
.L2710:
	ldr	r1, [sp, #8]
	mov	r0, r10
	bl	ftl_sb_update_avl_pages
	b	.L2702
.L2547:
	uxth	r1, r3
	adds	r1, r1, #8
	ldrh	r0, [r10, r1, lsl #1]
	b	.L2546
.L2548:
	movs	r1, #0
	bl	FtlGetLastWrittenPage
	mov	r4, r0
	adds	r0, r0, #1
	beq	.L2549
.L2626:
	mov	r5, r4
	b	.L2550
.L2549:
	ldr	r3, [sp, #12]
	cbz	r3, .L2552
	ldr	r1, .L2711+32
	movw	r2, #2141
	ldr	r0, .L2711+36
	bl	printf
	ldr	r1, .L2711+40
	ldr	r0, .L2711+44
	bl	printf
.L2552:
	ldr	r3, [sp, #28]
	cbz	r3, .L2553
	cmp	r5, r3
	beq	.L2553
	ldr	r1, .L2711+32
	movw	r2, #2142
	ldr	r0, .L2711+36
	bl	printf
	ldr	r1, .L2711+40
	ldr	r0, .L2711+44
	bl	printf
.L2553:
	movs	r3, #0
	strh	r3, [r10, #2]	@ movhi
	b	.L2709
.L2555:
	ldr	r1, [sp, #4]
	ldrh	r2, [r1], #2
	cmp	r2, r8
	str	r1, [sp, #4]
	beq	.L2554
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
.L2554:
	adds	r3, r3, #1
	b	.L2551
.L2627:
	movs	r3, #0
	b	.L2703
.L2562:
	movs	r3, #36
	ldr	r1, [r8]
	muls	r3, r7, r3
	adds	r2, r1, r3
	ldr	r3, [r1, r3]
	cbnz	r3, .L2558
	ldr	r2, [r2, #12]
	ldr	r3, [r2, #4]
	adds	r1, r3, #1
	beq	.L2559
	ldr	r1, .L2711+28
	mov	r0, r3
	ldr	r1, [r1]
	bl	ftl_cmp_data_ver
	cbz	r0, .L2559
	ldr	r1, .L2711+28
	adds	r3, r3, #1
	str	r3, [r1]
.L2559:
	ldr	r3, [r2]
	adds	r3, r3, #1
	bne	.L2561
.L2560:
	uxth	r3, r4
	uxth	r7, r7
	str	r3, [sp, #8]
	movs	r2, #36
	ldr	r3, [r8]
	mla	r7, r2, r7, r3
	ldr	r0, [r7, #4]
	b	.L2704
.L2558:
	ldr	r1, [r2, #4]
	uxth	fp, r5
	ldr	r0, .L2711+48
	bl	printf
	ldrh	r2, [r10]
	ldr	r3, .L2711+52
	strh	r2, [r3]	@ movhi
.L2561:
	adds	r7, r7, #1
	b	.L2557
.L2566:
	movw	r2, #65535
	cmp	fp, r2
	bne	.L2567
	cmp	r3, #0
	bne	.L2568
.L2567:
	ldr	r3, .L2711+56
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
.L2571:
	cmp	r4, fp
	bhi	.L2586
	ldr	r3, .L2711+12
	movw	lr, #65535
	mov	ip, #36
	ldrh	r8, [r3]
	ldr	r3, .L2711+16
	ldr	r0, [r3]
	ldr	r3, [sp, #20]
	str	r3, [sp, #32]
	movs	r3, #0
	mov	r5, r3
	b	.L2587
.L2573:
	ldr	r1, [sp, #32]
	ldrh	r2, [r1], #2
	cmp	r2, lr
	str	r1, [sp, #32]
	beq	.L2572
	mla	r1, ip, r5, r0
	adds	r5, r5, #1
	orr	r2, r4, r2, lsl #10
	uxth	r5, r5
	str	r2, [r1, #4]
.L2572:
	adds	r3, r3, #1
.L2587:
	uxth	r2, r3
	cmp	r8, r2
	bhi	.L2573
	mov	r1, r5
	ldr	r2, [sp, #36]
	bl	FlashReadPages
	ldr	r2, .L2711+4
	movs	r1, #36
	ldr	r3, .L2711+56
	movs	r0, #0
	movw	ip, #65535
	ldrb	lr, [r2]	@ zero_extendqisi2
	ldr	r2, .L2711+16
	ldr	r3, [r3]
	ldr	r2, [r2]
	mla	r5, r1, r5, r2
.L2574:
	cmp	r5, r2
	bne	.L2584
	cbz	r0, .L2585
	ldr	r2, .L2711+56
	str	r3, [r2]
.L2585:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L2571
.L2712:
	.align	2
.L2711:
	.word	.LANCHOR53
	.word	.LANCHOR8
	.word	.LANCHOR16
	.word	.LANCHOR38
	.word	.LANCHOR180
	.word	.LANCHOR106
	.word	.LANCHOR59
	.word	.LANCHOR160
	.word	.LANCHOR234
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC61
	.word	.LANCHOR235
	.word	.LANCHOR136
.L2584:
	ldr	r1, [r2]
	cbnz	r1, .L2575
	ldr	r1, [r2, #12]
	ldrh	r8, [r1]
	cmp	r8, ip
	beq	.L2630
	ldr	r1, [r1, #4]
	cmp	r1, #-1
	beq	.L2630
	adds	r0, r7, #1
	bne	.L2632
	ldr	r0, .L2713
	ldrh	r0, [r0, r4, lsl #1]
	cmp	r0, ip
	bne	.L2577
	cmp	lr, #0
	beq	.L2632
.L2577:
	ldr	r0, [sp, #4]
	cmp	r0, r3
	it	ne
	movne	r7, r3
.L2632:
	movs	r0, #1
	b	.L2576
.L2575:
	cbz	r0, .L2578
	ldr	r2, .L2713+4
	str	r3, [r2]
.L2578:
	ldr	r3, .L2713+8
	ldrh	r2, [r10]
	strh	r2, [r3]	@ movhi
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	cbnz	r3, .L2568
	ldr	r3, .L2713
	ldrh	r2, [r3, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2580
	adds	r1, r7, #1
	ldr	r3, .L2713+4
	beq	.L2581
	str	r7, [r3]
.L2568:
	ldr	fp, [sp, #12]
	movs	r2, #1
	ldr	r6, .L2713+12
	ldr	r3, .L2713+16
	strh	r2, [r3]	@ movhi
.L2588:
	ldr	r3, .L2713+20
	movw	ip, #65535
	ldr	r0, [r6]
	mov	lr, #36
	ldr	r1, [sp, #20]
	movs	r2, #0
	ldrh	r5, [r3]
	ldr	r3, .L2713+24
	str	r2, [sp, #24]
	ldrb	r7, [r3]	@ zero_extendqisi2
.L2589:
	uxth	r3, r2
	cmp	r3, r5
	bcc	.L2592
	ldr	r2, [sp, #36]
	ldr	r1, [sp, #24]
	bl	FlashReadPages
	movs	r3, #0
.L2708:
	str	r3, [sp, #32]
	ldr	r2, [sp, #24]
	ldrh	r3, [sp, #32]
	cmp	r2, r3
	bhi	.L2620
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	add	fp, fp, #1
	uxth	fp, fp
	cmp	r3, #1
	bne	.L2621
	ldr	r3, .L2713+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2621
	ldr	r3, .L2713+28
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2621
	ldr	r3, [sp, #8]
	cmp	r3, fp
	beq	.L2597
.L2621:
	ldr	r3, .L2713+32
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2588
	ldr	r2, .L2713+20
	movw	r0, #65535
	movs	r3, #0
	strh	fp, [r10, #2]	@ movhi
	strh	r3, [r10, #4]	@ movhi
	ldrh	r2, [r2]
.L2622:
	uxth	r1, r3
	cmp	r1, r2
	bcs	.L2702
	ldr	r1, [sp, #20]
	ldrh	r4, [r1], #2
	cmp	r4, r0
	str	r1, [sp, #20]
	add	r1, r3, #1
	bne	.L2709
	mov	r3, r1
	b	.L2622
.L2581:
	ldr	r2, [sp, #4]
	ldr	r1, [sp, #24]
	cmp	r2, r1
	itet	eq
	ldreq	r2, [r3]
	movne	r2, r1
	addeq	r2, r2, #-1
.L2705:
	str	r2, [r3]
	b	.L2568
.L2580:
	ldr	r3, [sp, #4]
	cmp	r6, r3
	beq	.L2583
	adds	r2, r6, #1
	beq	.L2568
	ldr	r3, .L2713+4
	str	r6, [r3]
	b	.L2568
.L2583:
	ldr	r2, .L2713+4
	ldr	r1, [sp, #4]
	ldr	r3, [r2]
	cmp	r1, r3
	beq	.L2568
	subs	r3, r3, #1
	str	r3, [r2]
	b	.L2568
.L2630:
	mov	r1, r3
	mov	r3, r6
.L2576:
	mov	r6, r3
	adds	r2, r2, #36
	mov	r3, r1
	b	.L2574
.L2586:
	mov	r2, #-1
	ldr	r3, .L2713+4
	b	.L2705
.L2592:
	ldrh	r3, [r1], #2
	cmp	r3, ip
	beq	.L2590
	ldr	r4, [sp, #24]
	orr	r3, fp, r3, lsl #10
	mla	r4, lr, r4, r0
	str	r3, [r4, #4]
	ldrb	r8, [r10, #8]	@ zero_extendqisi2
	cmp	r8, #1
	bne	.L2591
	cbz	r7, .L2591
	orr	r3, r3, #-2147483648
	str	r3, [r4, #4]
.L2591:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #24]
.L2590:
	adds	r2, r2, #1
	b	.L2589
.L2620:
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
	bcc	.L2594
	bne	.L2595
	ldr	r3, [sp, #28]
	cmp	r3, r0
	bhi	.L2594
.L2595:
	ldr	r3, [sp, #8]
	cmp	fp, r3
	bne	.L2596
	ldr	r3, [sp, #16]
	cmp	r3, r0
	beq	.L2597
.L2596:
	ldr	r3, [r8, r5]
	adds	r3, r3, #1
	beq	.L2598
	ldr	r3, [r7, #12]
	movw	r2, #61589
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L2599
	ldrh	r0, [r10]
.L2706:
	bl	decrement_vpc_count
	b	.L2594
.L2599:
	ldr	r2, [r3, #4]
	str	r2, [sp, #4]
	adds	r2, r2, #1
	beq	.L2600
	ldr	r2, .L2713+36
	ldr	r0, [sp, #4]
	ldr	r1, [r2]
	bl	ftl_cmp_data_ver
	cbz	r0, .L2600
	ldr	r1, [sp, #4]
	adds	r1, r1, #1
	str	r1, [r2]
.L2600:
	ldr	r4, [r3, #8]
	add	r1, sp, #48
	ldr	r3, [r3, #12]
	movs	r2, #0
	mov	r0, r4
	str	r3, [sp, #44]
	bl	log2phys
	ldr	r3, .L2713+4
	ldr	r1, [r3]
	adds	r3, r1, #1
	beq	.L2601
	ldr	r0, [sp, #4]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2601
	ldr	r3, [sp, #44]
	adds	r7, r3, #1
	beq	.L2602
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
	bne	.L2603
.L2604:
	mov	r3, #-1
	str	r3, [sp, #44]
.L2611:
	ldr	r7, [sp, #44]
	adds	r0, r7, #1
	beq	.L2594
.L2625:
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L2713+40
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2616
	ldr	r1, .L2713+44
	movw	r2, #2425
	ldr	r0, .L2713+48
	bl	printf
	ldr	r1, .L2713+52
	ldr	r0, .L2713+56
	bl	printf
.L2616:
	ldr	r3, .L2713+60
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, #0
	beq	.L2617
	mov	r0, r4
	b	.L2706
.L2602:
	ldr	r3, [sp, #52]
	ldr	r2, [sp, #48]
	cmp	r2, r3
	bne	.L2594
	movs	r2, #1
	add	r1, sp, #44
	mov	r0, r4
	bl	log2phys
.L2594:
	ldr	r3, [sp, #32]
	adds	r3, r3, #1
	b	.L2708
.L2603:
	ldr	r1, [r7, #8]
	cmp	r4, r1
	bne	.L2604
	ldr	r8, [r7, #4]
	ldr	r0, .L2713+4
	mov	r1, r8
	ldr	r0, [r0]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2604
	ldr	r1, [sp, #48]
	ldr	r0, [sp, #52]
	cmp	r1, r0
	bne	.L2606
.L2609:
	ldr	r1, [sp, #44]
	mov	r0, r4
	bl	FtlReUsePrevPpa
	b	.L2604
.L2714:
	.align	2
.L2713:
	.word	.LANCHOR120
	.word	.LANCHOR136
	.word	.LANCHOR235
	.word	.LANCHOR180
	.word	.LANCHOR236
	.word	.LANCHOR38
	.word	.LANCHOR8
	.word	.LANCHOR54
	.word	.LANCHOR53
	.word	.LANCHOR160
	.word	.LANCHOR40
	.word	.LANCHOR234
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR84
.L2606:
	ldr	r0, [sp, #44]
	cmp	r1, r0
	beq	.L2604
	adds	r0, r1, #1
	beq	.L2607
	str	r1, [r3, #4]
	movs	r2, #0
	movs	r1, #1
	mov	r0, r3
	ldr	r7, [r3, #12]
	bl	FlashReadPages
.L2608:
	ldr	r3, [r6]
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L2609
	ldr	r3, [r7, #4]
	ldr	r2, .L2715
	mov	r1, r3
	ldr	r0, [r2]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2609
	mov	r1, r3
	mov	r0, r8
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2604
	b	.L2609
.L2607:
	str	r1, [r2, r5]
	b	.L2608
.L2601:
	ldr	r3, [sp, #52]
	ldr	r2, [sp, #48]
	cmp	r2, r3
	beq	.L2611
	movs	r2, #1
	add	r1, sp, #52
	mov	r0, r4
	bl	log2phys
	ldr	r7, [sp, #48]
	adds	r5, r7, #1
	beq	.L2611
	ldr	r3, [sp, #44]
	cmp	r7, r3
	beq	.L2625
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L2715+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L2615
	ldr	r3, .L2715+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L2615
	ldr	r3, .L2715+12
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L2611
.L2615:
	ldr	r0, [r6]
	movs	r2, #0
	movs	r1, #1
	str	r7, [r0, #4]
	ldr	r5, [r0, #12]
	bl	FlashReadPages
	ldr	r3, [r6]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L2611
	ldr	r1, [r5, #4]
	ldr	r0, [sp, #4]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	bne	.L2611
	movs	r2, #1
	add	r1, sp, #48
	mov	r0, r4
	bl	log2phys
	b	.L2611
.L2617:
	mov	r1, r4
	ldr	r0, .L2715+16
	bl	printf
	b	.L2594
.L2598:
	ldrh	r3, [r10]
	mov	r1, r4
	ldr	r2, .L2715+20
	ldr	r0, .L2715+24
	strh	r3, [r2]	@ movhi
	ldr	r2, [sp, #4]
	bl	printf
	ldr	r2, .L2715+28
	ldr	r3, [r2]
	cmp	r3, #31
	bhi	.L2618
	ldr	r0, [sp, #52]
	ldr	r1, .L2715+32
	str	r0, [r1, r3, lsl #2]
	adds	r3, r3, #1
	str	r3, [r2]
.L2618:
	ldrh	r0, [r10]
	bl	decrement_vpc_count
	ldr	r3, .L2715
	ldr	r2, [r3]
	adds	r1, r2, #1
	bne	.L2619
	ldr	r2, [sp, #4]
.L2707:
	str	r2, [r3]
	b	.L2594
.L2619:
	ldr	r1, [sp, #4]
	cmp	r1, r2
	bcs	.L2594
	mov	r2, r1
	b	.L2707
.L2597:
	ldrb	r3, [sp, #16]	@ zero_extendqisi2
	ldr	r2, [sp, #16]
	strb	r3, [r10, #6]
	ldrh	r3, [sp, #8]
	strh	r3, [r10, #2]	@ movhi
	b	.L2710
.L2716:
	.align	2
.L2715:
	.word	.LANCHOR136
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LC62
	.word	.LANCHOR235
	.word	.LC63
	.word	.LANCHOR237
	.word	.LANCHOR238
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
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
	ldr	r3, .L2740
	ldr	r3, [r3]
	cbz	r3, .L2718
.L2723:
	movs	r0, #0
.L2717:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2718:
	ldr	r0, .L2740+4
	movw	r3, #65535
	ldr	r5, .L2740+8
	ldrh	r6, [r0]
	mov	r4, r0
	cmp	r6, r3
	beq	.L2720
	ldr	r3, .L2740+12
	ldrh	r1, [r3]
	bl	FtlGcScanTempBlk
	str	r0, [sp, #12]
	adds	r0, r0, #1
	beq	.L2720
	ldr	r3, .L2740+16
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	cmp	r3, #4
	bls	.L2721
	subs	r3, r3, #5
	movs	r0, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	bl	FtlEctTblFlush
.L2721:
	ldr	r3, [r5]
	cbnz	r3, .L2722
	ldr	r2, .L2740+20
	ldr	r0, [sp, #12]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L2722:
	movs	r3, #0
	movs	r0, #1
	str	r3, [r5]
	b	.L2717
.L2720:
	ldrh	r2, [r4]
	movs	r3, #0
	str	r3, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2723
	ldr	r6, .L2740+12
	bl	FtlCacheWriteBack
	ldrb	r0, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r6]
	ldr	r5, .L2740+24
	muls	r2, r0, r2
	ldrh	r1, [r5]
	cmp	r1, r2
	beq	.L2724
	ldr	r1, .L2740+28
	movs	r2, #163
	ldr	r0, .L2740+32
	bl	printf
	ldr	r1, .L2740+36
	ldr	r0, .L2740+40
	bl	printf
.L2724:
	ldrh	r6, [r6]
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldr	r2, .L2740+44
	ldrh	r0, [r4]
	ldr	fp, .L2740+84
	smulbb	r3, r3, r6
	ldr	r1, [r2]
	movs	r6, #0
	str	r2, [sp, #4]
	strh	r3, [r1, r0, lsl #1]	@ movhi
	ldr	r1, .L2740+48
	ldrh	r3, [r5]
	ldr	r0, [r1]
	add	r3, r3, r0
	str	r3, [r1]
.L2725:
	ldrh	r2, [r5]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L2729
	movw	r0, #65535
	bl	decrement_vpc_count
	ldr	r3, .L2740+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2730
	ldrh	r1, [r4]
	ldr	r0, .L2740+56
	bl	printf
.L2730:
	ldr	r3, [sp, #4]
	ldrh	r0, [r4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	beq	.L2731
	bl	INSERT_DATA_LIST
.L2732:
	ldr	r3, .L2740+60
	movw	r6, #65535
	strh	r6, [r4]	@ movhi
	movs	r4, #0
	strh	r4, [r5]	@ movhi
	strh	r4, [r3]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	r3, .L2740+64
	strh	r6, [r3]	@ movhi
	ldr	r3, .L2740+68
	ldrh	r2, [r3]
	ldr	r3, .L2740+72
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	cmp	r2, r3, asr #2
	ble	.L2723
	ldr	r3, .L2740+76
	movs	r2, #20
	mov	r0, r4
	strh	r2, [r3]	@ movhi
	b	.L2717
.L2729:
	uxth	r3, r6
	movs	r7, #12
	ldr	r2, [fp]
	muls	r7, r3, r7
	ldr	r3, .L2740+80
	ldr	r8, [r3]
	add	r10, r8, r7
	ldr	r1, [r10, #8]
	cmp	r1, r2
	bcc	.L2726
	ldr	r1, .L2740+28
	movs	r2, #168
	ldr	r0, .L2740+32
	bl	printf
	ldr	r1, .L2740+36
	ldr	r0, .L2740+40
	bl	printf
.L2726:
	movs	r2, #0
	add	r1, sp, #12
	ldr	r0, [r10, #8]
	bl	log2phys
	ldr	r2, [sp, #12]
	ldr	r0, [r8, r7]
	cmp	r0, r2
	bne	.L2727
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	movs	r2, #1
	mov	r7, r0
	add	r1, r10, #4
	ldr	r0, [r10, #8]
	bl	log2phys
	mov	r0, r7
.L2739:
	bl	decrement_vpc_count
.L2728:
	adds	r6, r6, #1
	b	.L2725
.L2727:
	ldr	r3, [r10, #4]
	cmp	r2, r3
	beq	.L2728
	ldrh	r0, [r4]
	b	.L2739
.L2731:
	bl	INSERT_FREE_LIST
	b	.L2732
.L2741:
	.align	2
.L2740:
	.word	.LANCHOR77
	.word	.LANCHOR94
	.word	.LANCHOR135
	.word	.LANCHOR53
	.word	.LANCHOR79
	.word	.LANCHOR138
	.word	.LANCHOR111
	.word	.LANCHOR239
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR84
	.word	.LANCHOR161
	.word	.LANCHOR8
	.word	.LC64
	.word	.LANCHOR110
	.word	.LANCHOR204
	.word	.LANCHOR89
	.word	.LANCHOR223
	.word	.LANCHOR176
	.word	.LANCHOR112
	.word	.LANCHOR73
	.size	FtlGcFreeTempBlock, .-FtlGcFreeTempBlock
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
	ldr	r4, .L2744
	ldr	r5, .L2744+4
	ldrh	r1, [r4]
	mov	r0, r5
	bl	FtlGcScanTempBlk
	ldrh	r2, [r5, #2]
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L2742
	ldr	r0, .L2744+8
	bl	FtlMapBlkWriteDumpData
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r3, .L2744+12
	movs	r2, #0
	str	r2, [r3]
.L2742:
	pop	{r3, r4, r5, pc}
.L2745:
	.align	2
.L2744:
	.word	.LANCHOR53
	.word	.LANCHOR94
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
	ldr	r5, .L2747
	ldr	r3, .L2747+4
	mov	r0, r5
	str	r4, [r3]
	bl	FtlRecoverySuperblock
	mov	r0, r5
	ldr	r5, .L2747+8
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
.L2748:
	.align	2
.L2747:
	.word	.LANCHOR92
	.word	.LANCHOR237
	.word	.LANCHOR93
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
	ldr	r4, .L2758
	movw	r5, #65535
	strh	r3, [r4]	@ movhi
	ldr	r3, .L2758+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L2758+8
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	ldr	r3, .L2758+12
	ldrh	r3, [r3]
	cmp	r3, r5
	mov	r5, r4
	bne	.L2750
.L2752:
	mov	r4, #-1
.L2749:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L2750:
	bl	FtlLoadSysInfo
	mov	r4, r0
	cmp	r0, #0
	bne	.L2752
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	movs	r0, #1
	bl	FtlUpdateVaildLpn
	ldr	r3, .L2758+16
	movs	r0, #12
	ldrh	r2, [r3]
	ldr	r3, .L2758+20
	ldr	r1, [r3]
	mov	r3, r4
.L2753:
	cmp	r3, r2
	blt	.L2755
	ldrh	r3, [r5]
	cmp	r3, #0
	beq	.L2756
.L2754:
	ldr	r3, .L2758+24
	ldr	r1, [r3]
	ldr	r3, .L2758+28
	ldrh	r0, [r3]
	ldrh	r5, [r3, #4]
	ldrh	r2, [r1, r0, lsl #1]
	subs	r2, r2, r5
	ldr	r5, .L2758+32
	strh	r2, [r1, r0, lsl #1]	@ movhi
	ldrh	r2, [r5]
	strh	r2, [r3, #2]	@ movhi
	movs	r2, #0
	strh	r2, [r3, #4]	@ movhi
	strb	r2, [r3, #6]
	ldr	r3, .L2758+36
	ldrh	r6, [r3]
	ldrh	r7, [r3, #4]
	ldrh	r0, [r1, r6, lsl #1]
	subs	r0, r0, r7
	strh	r0, [r1, r6, lsl #1]	@ movhi
	strb	r2, [r3, #6]
	ldrh	r1, [r5]
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L2758+40
	strh	r1, [r3, #2]	@ movhi
	ldrh	r3, [r2, #30]
	adds	r3, r3, #1
	strh	r3, [r2, #30]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2757:
	bl	FtlVpcTblFlush
	b	.L2749
.L2755:
	mla	r6, r0, r3, r1
	ldr	r6, [r6, #4]
	cmp	r6, #0
	blt	.L2754
	adds	r3, r3, #1
	b	.L2753
.L2756:
	bl	l2p_flush
	b	.L2757
.L2759:
	.align	2
.L2758:
	.word	.LANCHOR236
	.word	.LANCHOR235
	.word	.LANCHOR39
	.word	.LANCHOR209
	.word	.LANCHOR68
	.word	.LANCHOR97
	.word	.LANCHOR84
	.word	.LANCHOR92
	.word	.LANCHOR53
	.word	.LANCHOR93
	.word	.LANCHOR81
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
	ldr	r3, .L2791
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r4, [r3]
	cmp	r4, #0
	bne	.L2762
	ldr	r5, .L2791+4
	mov	r1, r4
	ldr	r3, .L2791+8
	ldr	r6, .L2791+12
	ldrh	r2, [r5]
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L2791+16
	ldr	r5, .L2791+20
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L2791+24
	ldrh	r0, [r6]
	str	r4, [r5]
	str	r4, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L2763
	bl	FtlMakeBbt
.L2763:
	ldr	r3, .L2791+28
	ldr	r2, .L2791+32
	ldr	ip, .L2791+112
	ldrh	r1, [r3]
	ldr	r4, [r2]
	ldr	r2, .L2791+36
	str	r3, [sp, #12]
	lsls	r1, r1, #7
	ldr	r7, [r2]
	movs	r2, #0
.L2764:
	uxth	r3, r2
	adds	r2, r2, #1
	cmp	r3, r1
	blt	.L2765
	ldr	r3, .L2791+40
	movs	r7, #0
	ldr	fp, .L2791+116
	ldrh	r4, [r3]
	mov	r8, r3
	mov	r10, fp
.L2766:
	ldrh	r3, [fp]
	cmp	r3, r4
	bhi	.L2767
	ldr	r4, .L2791+44
	subs	r3, r7, #2
	ldrh	r1, [r4]
	cmp	r3, r1, lsl #1
	bgt	.L2768
.L2772:
	movs	r7, #0
	mov	r6, r7
.L2769:
	ldrh	r3, [r8]
	uxth	r0, r7
	adds	r7, r7, #1
	cmp	r3, r0
	bhi	.L2773
	ldrh	r2, [r10]
	ldr	r3, .L2791+48
	ldrh	r4, [r4]
	ldr	r7, .L2791+52
	str	r2, [r3]
	ldr	r3, .L2791+56
	mov	r1, r4
	ldr	r3, [r3]
	mov	r0, r3
	str	r3, [sp, #16]
	bl	__aeabi_uidiv
	ldr	r1, .L2791+60
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
	ble	.L2774
	ldr	r3, [sp, #16]
	mov	r1, r4
	subs	r0, r3, r6
	bl	__aeabi_uidiv
	ldr	r3, [sp, #8]
	str	r0, [r7]
	lsrs	r0, r0, #5
	adds	r0, r0, #24
	strh	r0, [r3]	@ movhi
.L2774:
	ldr	r3, .L2791+64
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L2775
	ldr	r2, .L2791+60
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
.L2775:
	ldr	r3, .L2791+68
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2776
	ldr	r2, .L2791+60
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
.L2776:
	ldr	r3, .L2791+72
	ldrh	r3, [r3]
	cbz	r3, .L2778
	ldr	r2, .L2791+60
	ldrh	r1, [r2]
	add	r1, r1, r3, lsr #1
	strh	r1, [r2]	@ movhi
	mul	r1, r4, r3
	cmp	r6, r1
	bge	.L2778
	ldr	r1, [sp, #4]
	adds	r3, r3, #32
	str	fp, [r7]
	add	r1, r1, r3
	strh	r1, [r2]	@ movhi
.L2778:
	ldr	r3, [sp, #8]
	ldr	r6, .L2791+76
	ldrh	r2, [r3]
	ldr	r3, [r7]
	subs	r3, r3, r2
	muls	r4, r3, r4
	ldr	r3, .L2791+80
	ldrh	r3, [r3]
	str	r4, [r6]
	muls	r4, r3, r4
	ldr	r3, [sp, #12]
	ldrh	r3, [r3]
	str	r4, [r7]
	ldr	r7, .L2791+84
	muls	r4, r3, r4
	ldr	r3, .L2791+88
	str	r4, [r3]
	movw	r4, #65535
	bl	FtlBbmTblFlush
	ldrh	r2, [r10]
	movs	r1, #0
	ldr	r10, .L2791+120
	lsls	r2, r2, #1
	ldr	r0, [r10]
	bl	ftl_memset
	ldr	r2, .L2791+92
	movs	r3, #0
	strh	r3, [r7, #2]	@ movhi
	movs	r1, #255
	strb	r3, [r7, #6]
	str	r3, [r2]
	ldr	r2, .L2791+96
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
	ldr	r3, .L2791+100
	lsrs	r2, r2, #3
	ldr	r0, [r3]
	bl	ftl_memset
.L2780:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r7, #7]	@ zero_extendqisi2
	ldrh	r2, [r7]
	cmp	r3, #0
	bne	.L2781
	ldr	r3, [r8]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r7]
	adds	r3, r3, #1
	strh	r3, [r7]	@ movhi
	b	.L2780
.L2765:
	mvns	r0, r3
	orr	r0, r3, r0, lsl #16
	str	r0, [r4, r3, lsl #2]
	str	ip, [r7, r3, lsl #2]
	b	.L2764
.L2767:
	mov	r0, r4
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r4, r4, #1
	add	r7, r7, r0
	uxth	r7, r7
	uxth	r4, r4
	b	.L2766
.L2768:
	mov	r0, r7
	bl	__aeabi_uidiv
	ldr	r3, .L2791+104
	ldr	r3, [r3]
	add	r0, r0, r3
	uxth	r0, r0
	bl	FtlSysBlkNumInit
	ldrh	r0, [r6]
	bl	FtlFreeSysBlkQueueInit
	ldrh	r6, [r8]
.L2770:
	ldrh	r3, [r10]
	cmp	r3, r6
	bls	.L2772
	mov	r0, r6
	movs	r1, #1
	adds	r6, r6, #1
	bl	FtlLowFormatEraseBlock
	uxth	r6, r6
	b	.L2770
.L2773:
	movs	r1, #0
	bl	FtlLowFormatEraseBlock
	add	r6, r6, r0
	uxth	r6, r6
	b	.L2769
.L2781:
	ldr	r3, [r5]
	ldrh	r1, [r7, #4]
	ldr	r4, .L2791+108
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
.L2782:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r4]
	cmp	r3, #0
	bne	.L2783
	ldr	r3, [r8]
	strh	r7, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L2782
.L2792:
	.align	2
.L2791:
	.word	.LANCHOR77
	.word	.LANCHOR67
	.word	.LANCHOR195
	.word	.LANCHOR39
	.word	.LANCHOR131
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR56
	.word	.LANCHOR186
	.word	.LANCHOR187
	.word	.LANCHOR40
	.word	.LANCHOR38
	.word	.LANCHOR74
	.word	.LANCHOR73
	.word	.LANCHOR42
	.word	.LANCHOR223
	.word	.LANCHOR28
	.word	.LANCHOR8
	.word	.LANCHOR49
	.word	.LANCHOR222
	.word	.LANCHOR53
	.word	.LANCHOR92
	.word	.LANCHOR69
	.word	.LANCHOR101
	.word	.LANCHOR204
	.word	.LANCHOR0
	.word	.LANCHOR66
	.word	.LANCHOR93
	.word	168778952
	.word	.LANCHOR41
	.word	.LANCHOR84
.L2783:
	ldr	r3, [r5]
	ldrh	r1, [r4, #4]
	str	r3, [r4, #12]
	adds	r3, r3, #1
	str	r3, [r5]
	movw	r4, #65535
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L2793
	strh	r4, [r3]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L2793+4
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
	cbnz	r0, .L2762
	ldr	r3, .L2793+8
	movs	r2, #1
	str	r2, [r3]
.L2762:
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2794:
	.align	2
.L2793:
	.word	.LANCHOR94
	.word	.LANCHOR209
	.word	.LANCHOR231
	.size	FtlLowFormat, .-FtlLowFormat
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
	ldr	r4, .L2798
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L2796
	ldrh	r3, [r4, #4]
	cbnz	r3, .L2797
.L2796:
	bl	FtlCacheWriteBack
	movs	r0, #0
	movs	r5, #0
	bl	FtlGcFreeTempBlock
	ldr	r0, .L2798
	strb	r5, [r4, #8]
	bl	allocate_data_superblock
	ldr	r3, .L2798+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L2798+8
	strh	r5, [r3]	@ movhi
	bl	l2p_flush
	mov	r0, r5
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2797:
	ldr	r0, .L2798
	pop	{r3, r4, r5, lr}
	b	get_new_active_ppa
.L2799:
	.align	2
.L2798:
	.word	.LANCHOR94
	.word	.LANCHOR110
	.word	.LANCHOR111
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
	ldr	r3, .L2815
	ldr	r3, [r3]
	cbz	r3, .L2801
.L2804:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L2801:
	ldr	r3, .L2815+4
	ldr	r5, .L2815+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2803
	ldr	r3, [r5]
	lsls	r2, r3, #31
	bpl	.L2803
	ldr	r3, .L2815+12
	ldrh	r3, [r3, #4]
	cmp	r3, #0
	bne	.L2804
.L2803:
	ldr	r4, .L2815+16
	movs	r3, #0
	movs	r6, #0
	movs	r7, #36
	mov	r2, r3
	ldr	r1, [r5]
	ldr	r0, [r4]
	bl	FlashProgPages
.L2805:
	ldr	r1, [r5]
	uxth	r3, r6
	cmp	r3, r1
	bcc	.L2807
	ldr	r0, [r4]
	bl	FtlGcBufFree
	movs	r3, #0
	str	r3, [r5]
	ldr	r3, .L2815+12
	ldrh	r3, [r3, #4]
	cmp	r3, #0
	bne	.L2804
	movs	r0, #1
	bl	FtlGcFreeTempBlock
	b	.L2814
.L2807:
	muls	r3, r7, r3
	ldr	r2, [r4]
	adds	r6, r6, #1
	adds	r1, r2, r3
	ldr	r2, [r2, r3]
	adds	r3, r2, #1
	bne	.L2806
	ldr	r3, .L2815+12
	movs	r5, #0
	ldr	r0, .L2815+20
	ldrh	r4, [r3]
	ldr	r0, [r0]
	strh	r5, [r0, r4, lsl #1]	@ movhi
	strh	r2, [r3]	@ movhi
	ldr	r2, .L2815+24
	ldr	r0, [r1, #4]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
.L2814:
	movs	r0, #1
	pop	{r3, r4, r5, r6, r7, pc}
.L2806:
	ldr	r3, [r1, #12]
	ldr	r1, [r1, #4]
	ldr	r2, [r3, #8]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L2805
.L2816:
	.align	2
.L2815:
	.word	.LANCHOR77
	.word	.LANCHOR8
	.word	.LANCHOR103
	.word	.LANCHOR94
	.word	.LANCHOR181
	.word	.LANCHOR84
	.word	.LANCHOR138
	.size	Ftl_gc_temp_data_write_back, .-Ftl_gc_temp_data_write_back
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
	ldr	r3, .L2907
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	ldr	r2, [r3]
	cmp	r2, #0
	bne	.L2869
	ldr	r3, .L2907+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2869
	ldr	r2, .L2907+8
	ldrh	r2, [r2]
	cmp	r2, #47
	bls	.L2871
	ldr	r5, .L2907+12
	movw	r2, #65535
	ldrh	ip, [r5]
	cmp	ip, r2
	beq	.L2819
	ldr	r7, .L2907+16
	ldrh	r3, [r7]
	cmp	r3, r2
	bne	.L2819
	ldr	r1, .L2907+20
	ldrh	r6, [r1]
	cmp	r6, r3
	beq	.L2819
	ldr	r2, .L2907+24
	ldrh	r4, [r2]
	cmp	r4, r3
	itttt	ne
	strhne	ip, [r7]	@ movhi
	strhne	r6, [r5]	@ movhi
	strhne	r4, [r1]	@ movhi
	strhne	r3, [r2]	@ movhi
.L2819:
	cmp	r0, #0
	bne	.L2872
	ldr	r3, .L2907+28
	ldrh	r3, [r3]
	cmp	r3, #24
	bhi	.L2873
	ldr	r2, .L2907+32
	cmp	r3, #16
	ldrh	r4, [r2]
	bls	.L2822
	lsrs	r4, r4, #5
.L2821:
	ldr	r2, .L2907+36
	ldrh	r1, [r2]
	cmp	r1, r3
	mov	r1, r2
	bcs	.L2825
	ldr	r3, .L2907+40
	movw	r0, #65535
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L2826
	ldr	r0, .L2907+16
	ldrh	r0, [r0]
	cmp	r0, r3
	bne	.L2826
	ldr	r3, .L2907+44
	ldrh	r0, [r3]
	cbnz	r0, .L2827
	ldr	r3, .L2907+48
	ldr	r4, .L2907+52
	ldr	r3, [r3]
	ldr	r4, [r4]
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, lsr #2
	bcs	.L2828
.L2827:
	ldr	r3, .L2907+56
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L2829:
	ldr	r3, .L2907+60
	movs	r2, #0
	str	r2, [r3]
.L2817:
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2822:
	cmp	r3, #12
	bls	.L2823
	lsrs	r4, r4, #4
	b	.L2821
.L2823:
	cmp	r3, #8
	bls	.L2821
	lsrs	r4, r4, #2
	b	.L2821
.L2873:
	movs	r4, #1
	b	.L2821
.L2828:
	movs	r3, #18
	strh	r3, [r2]	@ movhi
	b	.L2829
.L2826:
	ldr	r3, .L2907+56
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L2825:
	ldr	r3, .L2907+64
	ldrh	r3, [r3]
	cbz	r3, .L2820
	adds	r4, r4, #32
	uxth	r4, r4
.L2820:
	ldr	r5, .L2907+68
	movw	r3, #65535
	ldrh	r2, [r5]
	cmp	r2, r3
	bne	.L2832
	ldr	r3, .L2907+16
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L2833
	ldr	r0, .L2907+72
	ldr	r0, [r0]
	ldrh	r1, [r0, r1, lsl #1]
	cbnz	r1, .L2834
	strh	r2, [r3]	@ movhi
.L2834:
	ldrh	r2, [r3]
	strh	r2, [r5]	@ movhi
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
.L2833:
	ldrh	r0, [r5]
	movw	r6, #65535
	movs	r3, #0
	strb	r3, [r5, #8]
	cmp	r0, r6
	beq	.L2832
	bl	IsBlkInGcList
	cbz	r0, .L2836
	strh	r6, [r5]	@ movhi
.L2836:
	ldr	r3, .L2907+76
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2837
	ldrh	r0, [r5]
	bl	ftl_get_blk_mode
	strb	r0, [r5, #8]
.L2837:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2832
	ldr	r0, .L2907+68
	bl	make_superblock
	ldr	r2, .L2907+80
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r3, [r2]	@ movhi
	ldr	r3, .L2907+72
	ldrh	r2, [r5]
	ldr	r3, [r3]
	ldrh	r2, [r3, r2, lsl #1]
	ldr	r3, .L2907+84
	strh	r2, [r3]	@ movhi
.L2832:
	ldr	r2, .L2907+88
	ldrh	r3, [r5]
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L2838
	ldr	r2, .L2907+92
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L2838
	ldr	r5, .L2907+68
	mov	r6, r5
.L2839:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2840
	ldr	r10, .L2907+100
	movs	r2, #0
	ldr	r3, .L2907+60
	mov	r7, r10
	str	r2, [r3]
.L2841:
	ldrh	r8, [r10]
	mov	r0, r8
	bl	List_get_gc_head_node
	uxth	fp, r0
	movw	r3, #65535
	cmp	fp, r3
	strh	fp, [r6]	@ movhi
	bne	.L2842
	movs	r3, #0
	movs	r0, #8
	strh	r3, [r10]	@ movhi
	b	.L2817
.L2872:
	movs	r4, #1
	b	.L2820
.L2838:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L2905:
	ldr	r3, .L2907+44
	ldrh	r0, [r3]
	b	.L2817
.L2842:
	str	r0, [sp, #8]
	mov	r0, fp
	bl	IsBlkInGcList
	add	r3, r8, #1
	ldr	r2, [sp, #8]
	cbz	r0, .L2843
	strh	r3, [r10]	@ movhi
	b	.L2841
.L2843:
	ldr	r1, .L2907+32
	uxth	r3, r3
	ldr	lr, .L2907+104
	uxth	r2, r2
	ldr	r8, .L2907+72
	ldrh	r1, [r1]
	ldrh	lr, [lr]
	ldr	r0, [r8]
	strh	r3, [r10]	@ movhi
	mul	r1, lr, r1
	ldrh	ip, [r0, r2, lsl #1]
	cmp	ip, r1, asr #1
	bgt	.L2845
	cmp	r3, #48
	bls	.L2846
	cmp	ip, #8
	bls	.L2846
	ldr	r3, .L2907+96
	ldrh	r3, [r3]
	cmp	r3, #35
	bhi	.L2846
.L2845:
	movs	r3, #0
	strh	r3, [r7]	@ movhi
.L2846:
	ldrh	r3, [r0, r2, lsl #1]
	cmp	r1, r3
	bgt	.L2847
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
	movs	r3, #0
	strh	r3, [r7]	@ movhi
	b	.L2905
.L2847:
	cmp	r3, #0
	bne	.L2848
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r3, [r7]
	adds	r3, r3, #1
	strh	r3, [r7]	@ movhi
	b	.L2841
.L2908:
	.align	2
.L2907:
	.word	.LANCHOR77
	.word	.LANCHOR171
	.word	.LANCHOR86
	.word	.LANCHOR114
	.word	.LANCHOR113
	.word	.LANCHOR115
	.word	.LANCHOR116
	.word	.LANCHOR89
	.word	.LANCHOR53
	.word	.LANCHOR176
	.word	.LANCHOR94
	.word	.LANCHOR240
	.word	.LANCHOR73
	.word	.LANCHOR101
	.word	.LANCHOR223
	.word	.LANCHOR172
	.word	.LANCHOR117
	.word	.LANCHOR204
	.word	.LANCHOR84
	.word	.LANCHOR8
	.word	.LANCHOR241
	.word	.LANCHOR242
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR110
	.word	.LANCHOR178
	.word	.LANCHOR38
.L2848:
	movs	r3, #0
	strb	r3, [r6, #8]
	ldr	r3, .L2909
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2849
	mov	r0, fp
	bl	ftl_get_blk_mode
	strb	r0, [r6, #8]
.L2849:
	ldr	r3, .L2909+4
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2850
	ldr	r1, .L2909+8
	movw	r2, #857
	ldr	r0, .L2909+12
	bl	printf
	ldr	r1, .L2909+16
	ldr	r0, .L2909+20
	bl	printf
.L2850:
	ldr	r3, .L2909+24
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2851
	ldr	r1, .L2909+8
	movw	r2, #858
	ldr	r0, .L2909+12
	bl	printf
	ldr	r1, .L2909+16
	ldr	r0, .L2909+20
	bl	printf
.L2851:
	ldr	r3, .L2909+28
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2852
	ldr	r1, .L2909+8
	movw	r2, #859
	ldr	r0, .L2909+12
	bl	printf
	ldr	r1, .L2909+16
	ldr	r0, .L2909+20
	bl	printf
.L2852:
	mov	r0, r5
	bl	make_superblock
	ldr	r2, .L2909+32
	movs	r3, #0
	ldrh	r1, [r6]
	strh	r3, [r2]	@ movhi
	ldr	r2, [r8]
	ldrh	r1, [r2, r1, lsl #1]
	ldr	r2, .L2909+36
	strh	r3, [r6, #2]	@ movhi
	strb	r3, [r6, #6]
	strh	r1, [r2]	@ movhi
.L2840:
	ldr	r3, .L2909+40
	movs	r2, #1
	str	r2, [r3]
	ldr	r3, .L2909+44
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2909
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2853
	ldrb	r3, [r6, #8]	@ zero_extendqisi2
	cmp	r3, r2
	ittt	eq
	ldreq	r3, .L2909+48
	ldrheq	r3, [r3]
	streq	r3, [sp, #12]
.L2853:
	ldrh	r3, [r6, #2]
	ldr	r1, [sp, #12]
	ldr	fp, .L2909+84
	adds	r2, r3, r4
	cmp	r2, r1
	itt	gt
	movgt	r2, r1
	subgt	r4, r2, r3
	mov	r3, #0
	it	gt
	uxthgt	r4, r4
	str	r3, [sp, #20]
.L2855:
	ldrh	r3, [sp, #20]
	cmp	r4, r3
	bls	.L2863
	ldr	r3, .L2909+52
	movw	r8, #65535
	ldrh	lr, [r5, #2]
	mov	r10, #36
	ldr	r0, [fp]
	ldrh	r7, [r3]
	ldr	r3, [sp, #20]
	add	lr, lr, r3
	ldr	r3, .L2909+56
	str	r3, [sp, #16]
	movs	r3, #0
	str	r3, [sp, #8]
	b	.L2864
.L2857:
	ldr	r1, [sp, #16]
	ldrh	r2, [r1, #2]!
	cmp	r2, r8
	str	r1, [sp, #16]
	beq	.L2856
	ldr	r1, [sp, #8]
	orr	r2, lr, r2, lsl #10
	mla	ip, r10, r1, r0
	str	r2, [ip, #4]
	mov	r2, r1
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #8]
.L2856:
	adds	r3, r3, #1
.L2864:
	uxth	r2, r3
	cmp	r2, r7
	bcc	.L2857
	ldrb	r2, [r5, #8]	@ zero_extendqisi2
	ldr	r1, [sp, #8]
	bl	FlashReadPages
	movs	r3, #0
.L2904:
	str	r3, [sp, #16]
	ldr	r2, [sp, #8]
	ldrh	r3, [sp, #16]
	cmp	r2, r3
	bhi	.L2862
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	str	r3, [sp, #20]
	b	.L2855
.L2862:
	ldr	r3, [sp, #16]
	movs	r7, #36
	muls	r7, r3, r7
	ldr	r3, [fp]
	adds	r2, r3, r7
	ldr	r3, [r3, r7]
	adds	r3, r3, #1
	beq	.L2859
	ldr	r8, [r2, #12]
	movw	r3, #61589
	ldrh	r2, [r8]
	cmp	r2, r3
	bne	.L2859
	ldr	r10, [r8, #8]
	cmp	r10, #-1
	bne	.L2860
	ldr	r1, .L2909+8
	movw	r2, #898
	ldr	r0, .L2909+12
	bl	printf
	ldr	r1, .L2909+16
	ldr	r0, .L2909+20
	bl	printf
.L2860:
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
	bne	.L2859
	ldr	r2, .L2909+32
	ldr	r1, .L2909+60
	ldr	r10, .L2909+68
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
	ldr	r7, .L2909+28
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
	ldr	r2, .L2909+64
	str	r3, [r10]
	ldr	r2, [r2]
	str	r2, [r8, #4]
	bl	FtlGcBufAlloc
	ldr	r3, .L2909
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2861
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldr	r3, [r10]
	cmp	r2, r3
	beq	.L2861
	ldrh	r3, [r7, #4]
	cbnz	r3, .L2859
.L2861:
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L2859
.L2906:
	ldr	r3, .L2909+40
	movs	r2, #0
	str	r2, [r3]
	b	.L2905
.L2859:
	ldr	r3, [sp, #16]
	adds	r3, r3, #1
	b	.L2904
.L2863:
	ldrh	r3, [r5, #2]
	add	r4, r4, r3
	ldr	r3, [sp, #12]
	uxth	r4, r4
	cmp	r3, r4
	strh	r4, [r5, #2]	@ movhi
	bhi	.L2865
	ldr	r3, .L2909+68
	ldr	r3, [r3]
	cbz	r3, .L2866
	bl	Ftl_gc_temp_data_write_back
	cmp	r0, #0
	bne	.L2906
.L2866:
	ldr	r3, .L2909+32
	ldrh	r4, [r3]
	cbnz	r4, .L2867
	ldr	r7, .L2909+72
	ldrh	r1, [r5]
	ldr	r3, [r7]
	ldrh	r3, [r3, r1, lsl #1]
	cbz	r3, .L2867
	ldr	r0, .L2909+36
	ldrh	r2, [r5, #2]
	ldrh	r0, [r0]
	str	r3, [sp]
	mov	r3, r4
	str	r0, [sp, #4]
	ldr	r0, .L2909+76
	bl	printf
	ldrh	r2, [r5]
	ldr	r3, [r7]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5]
	bl	update_vpc_list
	bl	FtlCacheWriteBack
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2867:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L2865:
	ldr	r3, .L2909+80
	ldrh	r0, [r3]
	cmp	r0, #2
	bhi	.L2868
	ldr	r3, .L2909+44
	ldrh	r4, [r3]
	b	.L2839
.L2868:
	ldr	r3, .L2909+40
	movs	r2, #0
	adds	r0, r0, #1
	str	r2, [r3]
	b	.L2817
.L2910:
	.align	2
.L2909:
	.word	.LANCHOR8
	.word	.LANCHOR92
	.word	.LANCHOR243
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR241
	.word	.LANCHOR242
	.word	.LANCHOR171
	.word	.LANCHOR53
	.word	.LANCHOR54
	.word	.LANCHOR38
	.word	.LANCHOR204+14
	.word	.LANCHOR181
	.word	.LANCHOR160
	.word	.LANCHOR103
	.word	.LANCHOR84
	.word	.LC65
	.word	.LANCHOR89
	.word	.LANCHOR107
.L2869:
	movs	r0, #0
	b	.L2817
.L2871:
	mov	r0, r3
	b	.L2817
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
	ldr	r4, .L2920
	mov	r5, r0
	ldr	r2, .L2920+4
	str	r3, [r4]
	movs	r3, #0
	ldr	r1, .L2920+8
	str	r3, [r2]
	ldr	r2, .L2920+12
	ldr	r0, .L2920+16
	str	r3, [r2]
	bl	printf
	mov	r0, r5
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	ldr	r3, .L2920+20
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L2912
	ldr	r1, .L2920+24
	ldr	r0, .L2920+28
.L2919:
	bl	printf
.L2913:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2912:
	bl	FtlSysBlkInit
	cbz	r0, .L2914
	ldr	r1, .L2920+24
	ldr	r0, .L2920+32
	b	.L2919
.L2914:
	movs	r1, #1
	str	r1, [r4]
	bl	rk_ftl_garbage_collect
	ldr	r3, .L2920+36
	ldrh	r3, [r3]
	cmp	r3, #15
	bhi	.L2913
	mov	r4, #1024
.L2916:
	movs	r1, #1
	mov	r0, r1
	bl	rk_ftl_garbage_collect
	subs	r4, r4, #1
	bne	.L2916
	b	.L2913
.L2921:
	.align	2
.L2920:
	.word	.LANCHOR231
	.word	.LANCHOR244
	.word	.LC66
	.word	.LANCHOR77
	.word	.LC7
	.word	.LANCHOR39
	.word	.LANCHOR245
	.word	.LC67
	.word	.LC68
	.word	.LANCHOR89
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
	cbnz	r0, .L2923
	ldr	r0, .L2924
	bl	FtlInit
.L2923:
	bl	idb_init
	mov	r1, r4
	ldr	r0, .L2924+4
	bl	printf
	mov	r0, r4
	pop	{r4, pc}
.L2925:
	.align	2
.L2924:
	.word	.LANCHOR15
	.word	.LC69
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
	ldr	r3, .L2940
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2926
	ldr	r7, .L2940+4
	ldr	r6, .L2940+8
	ldr	r10, .L2940+32
	ldrh	r5, [r7]
	ldr	r3, [r6]
	ldr	r4, .L2940+12
	mov	r1, r5
	ldr	r0, .L2940+16
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
.L2928:
	subs	r4, r4, #1
	beq	.L2932
	movs	r1, #1
	mov	r0, r1
	bl	rk_ftl_garbage_collect
	ldr	r3, [r6]
	ldrh	r3, [r3, r8]
	cmp	r3, #0
	bne	.L2928
.L2932:
	ldr	r3, [r6]
	mov	r1, r5
	ldr	r0, .L2940+16
	ldrh	r2, [r3, r5, lsl #1]
	bl	printf
	ldr	r3, [r6]
	ldrh	r4, [r3, r5, lsl #1]
	cbnz	r4, .L2930
	add	r0, sp, #56
	ldr	r7, .L2940+20
	strh	r5, [r0, #-48]!	@ movhi
	movw	r10, #65535
	bl	make_superblock
	ldr	r3, .L2940+24
	add	r0, sp, #22
	ldr	r8, [r7]
	mov	r2, r4
	mov	fp, #36
	mov	ip, r4
	ldrh	lr, [r3]
.L2933:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L2935
	ldr	r3, [r6]
	mov	r1, r5
	ldr	r0, .L2940+28
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
.L2930:
	ldr	r2, [sp, #4]
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L2926:
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2935:
	ldrh	r3, [r0, #2]!
	cmp	r3, r10
	beq	.L2934
	mla	r1, fp, r4, r8
	adds	r4, r4, #1
	lsls	r3, r3, #10
	uxth	r4, r4
	str	r3, [r1, #4]
	str	ip, [r1, #8]
	str	ip, [r1, #12]
.L2934:
	adds	r2, r2, #1
	b	.L2933
.L2941:
	.align	2
.L2940:
	.word	.LANCHOR8
	.word	.LANCHOR235
	.word	.LANCHOR84
	.word	.LANCHOR93
	.word	.LC70
	.word	.LANCHOR78
	.word	.LANCHOR38
	.word	.LC71
	.word	.LANCHOR92
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
	bne	.L2943
	mov	r2, r3
	ldr	r1, [sp, #52]
	add	r0, r6, #256
	bl	FtlVendorPartRead
	str	r0, [sp, #32]
.L2942:
	ldr	r0, [sp, #32]
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2943:
	ldr	r3, [sp, #52]
	adds	r3, r1, r3
	str	r3, [sp, #36]
	ldr	r3, .L2981
	ldr	r2, [sp, #36]
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L2966
	ldr	r3, .L2981+4
	ldr	r3, [r3]
	adds	r4, r3, #1
	beq	.L2967
	bl	FtlCacheWriteBack
	ldr	r3, .L2981+8
	mov	r0, r6
	ldr	r10, .L2981+52
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	ldr	r3, [sp, #36]
	mov	r1, r4
	str	r0, [sp, #40]
	subs	r0, r3, #1
	bl	__aeabi_uidiv
	ldr	r3, [sp, #40]
	ldr	r2, .L2981+12
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
.L2945:
	ldr	r3, [sp, #28]
	cbnz	r3, .L2965
	ldr	r3, .L2981+16
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L2942
	movs	r1, #1
	ldr	r0, [sp, #28]
	bl	rk_ftl_garbage_collect
	b	.L2942
.L2965:
	movs	r2, #0
	add	r1, sp, #84
	mov	r0, r4
	bl	log2phys
	ldr	r3, [sp, #84]
	adds	r0, r3, #1
	bne	.L2946
	ldr	fp, .L2981+8
	mov	r8, #0
.L2947:
	ldrh	r0, [fp]
	cmp	r8, r0
	bcc	.L2949
.L2950:
	ldr	r3, [sp, #28]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #28]
	beq	.L2954
	ldr	r3, .L2981+20
	ldrh	r3, [r3]
	cmp	r5, r3, lsl #2
	bne	.L2945
.L2954:
	cmp	r5, #0
	beq	.L2945
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
.L2964:
	mov	r8, #36
	ldr	r3, [r10]
	mul	r8, r8, fp
	ldr	r1, [sp, #40]
	add	r3, r3, r8
	ldr	r2, [r3, #16]
	cmp	r1, r2
	bne	.L2956
	ldr	r1, [r3, #8]
	ldr	r3, .L2981+24
	ldr	r3, [r3]
	cmp	r1, r3
	bne	.L2957
	ldr	r3, [sp, #60]
	mov	r0, r7
	ldr	r2, [sp, #64]
	add	r1, r1, r3
.L2980:
	bl	ftl_memcpy
.L2957:
	ldr	r2, [r10]
	add	r2, r2, r8
	ldr	r3, [r2, #12]
	ldr	lr, [r2, #16]
	ldr	r0, [r3, #8]
	cmp	lr, r0
	beq	.L2958
	ldr	ip, .L2981+32
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
	ldr	r0, .L2981+28
	ldr	r3, [r3]
	ldr	r2, [r2, #4]
	bl	printf
.L2958:
	ldr	r3, [r10]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	adds	r1, r3, #1
	bne	.L2959
	ldr	r1, .L2981+32
	str	r3, [sp, #32]
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L2960:
	add	fp, fp, #1
	cmp	r5, fp
	bne	.L2964
	movs	r5, #0
	b	.L2945
.L2949:
	mla	r0, r0, r4, r8
	cmp	r6, r0
	bhi	.L2948
	ldr	r3, [sp, #36]
	cmp	r3, r0
	bls	.L2948
	subs	r0, r0, r6
	mov	r2, #512
	movs	r1, #0
	add	r0, r7, r0, lsl #9
	bl	ftl_memset
.L2948:
	add	r8, r8, #1
	b	.L2947
.L2946:
	ldr	r2, [r10]
	mov	r8, #36
	mla	r8, r8, r5, r2
	str	r3, [r8, #4]
	ldr	r3, [sp, #40]
	cmp	r4, r3
	ldr	r3, .L2981+8
	bne	.L2951
	ldr	r2, .L2981+24
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
	bne	.L2952
	str	r7, [r8, #8]
.L2952:
	ldr	r3, .L2981+36
	ldr	r2, .L2981+40
	str	r4, [r8, #16]
	ldrh	r3, [r3]
	ldr	r2, [r2]
	muls	r3, r5, r3
	adds	r5, r5, #1
	bic	r3, r3, #3
	add	r3, r3, r2
	str	r3, [r8, #12]
	b	.L2950
.L2951:
	ldr	r2, [sp, #44]
	cmp	r4, r2
	bne	.L2953
	ldr	r2, .L2981+44
	ldr	r1, [sp, #36]
	ldr	r2, [r2]
	str	r2, [r8, #8]
	ldrh	r2, [r3]
	mul	r3, r2, r4
	subs	r1, r1, r3
	cmp	r2, r1
	str	r1, [sp, #24]
	bne	.L2952
.L2979:
	subs	r3, r3, r6
	add	r3, r7, r3, lsl #9
	str	r3, [r8, #8]
	b	.L2952
.L2953:
	ldrh	r3, [r3]
	muls	r3, r4, r3
	b	.L2979
.L2956:
	ldr	r1, [sp, #44]
	cmp	r1, r2
	bne	.L2957
	ldr	r1, [r3, #8]
	ldr	r3, .L2981+44
	ldr	r3, [r3]
	cmp	r1, r3
	bne	.L2957
	ldr	r3, .L2981+8
	ldr	r2, [sp, #68]
	ldrh	r0, [r3]
	ldr	r3, [sp, #44]
	muls	r0, r3, r0
	subs	r0, r0, r6
	add	r0, r7, r0, lsl #9
	b	.L2980
.L2959:
	cmp	r3, #256
	bne	.L2960
	ldr	r0, [r2, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	mov	r8, r0
	bl	FtlGcRefreshBlock
	ldr	r2, .L2981+48
	movw	r3, #2049
.L2962:
	subs	r3, r3, #1
	bne	.L2961
.L2963:
	bl	FtlSysFlush
	b	.L2960
.L2961:
	movs	r1, #1
	str	r2, [sp, #76]
	mov	r0, r1
	str	r3, [sp, #72]
	bl	rk_ftl_garbage_collect
	ldr	r2, [sp, #76]
	ldr	r3, [sp, #72]
	ldrh	r1, [r2]
	cmp	r1, r8
	beq	.L2962
	b	.L2963
.L2966:
	mov	r3, #-1
.L2967:
	str	r3, [sp, #32]
	b	.L2942
.L2982:
	.align	2
.L2981:
	.word	.LANCHOR69
	.word	.LANCHOR231
	.word	.LANCHOR56
	.word	.LANCHOR166
	.word	.LANCHOR117
	.word	.LANCHOR38
	.word	.LANCHOR186
	.word	.LC60
	.word	.LANCHOR138
	.word	.LANCHOR59
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
	ldr	r3, .L3031
	sub	sp, sp, #80
	mov	r6, r1
	str	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L3016
	cmp	r0, #16
	bne	.L2985
	mov	r2, r10
	ldr	r1, [sp, #12]
	add	r0, r6, #256
	bl	FtlVendorPartWrite
.L2983:
	add	sp, sp, #80
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2985:
	ldr	r3, [sp, #12]
	adds	r5, r1, r3
	ldr	r3, .L3031+4
	ldr	r3, [r3]
	cmp	r5, r3
	bhi	.L3017
	ldr	r3, .L3031+8
	ldr	r0, [r3]
	adds	r4, r0, #1
	beq	.L2983
	ldr	r3, .L3031+12
	mov	r2, #2048
	mov	r0, r6
	str	r2, [r3]
	ldr	r3, .L3031+16
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	mov	r1, r4
	mov	r8, r0
	subs	r0, r5, #1
	bl	__aeabi_uidiv
	ldr	r2, .L3031+20
	sub	r5, r0, r8
	adds	r3, r5, #1
	adds	r1, r5, #1
	str	r3, [sp, #4]
	ldr	r3, [r2]
	str	r0, [sp, #16]
	add	r3, r3, r1
	str	r3, [r2]
	ldr	r3, .L3031+24
	ldr	fp, [r3]
	cmp	fp, #0
	beq	.L2987
	ldr	r3, [fp, #16]
	cmp	r8, r3
	beq	.L2988
	bl	FtlCacheWriteBack
.L2987:
	ldr	r7, .L3031+28
	mov	r4, r8
.L2989:
	ldr	r3, [sp, #4]
	cbnz	r3, .L3015
	ldr	r3, [sp, #16]
	ldr	r0, [sp, #4]
	sub	r1, r3, r8
	bl	rk_ftl_garbage_collect
.L3016:
	movs	r0, #0
	b	.L2983
.L2988:
	ldr	r2, .L3031+32
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
	beq	.L3016
	ldr	r3, [sp, #12]
	add	r6, r6, r4
	add	r10, r10, r7
	add	r8, r8, #1
	subs	r3, r3, r4
	str	r3, [sp, #12]
	bl	FtlCacheWriteBack
	str	r5, [sp, #4]
	b	.L2987
.L3015:
	ldr	r5, .L3031+36
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r5]
	cmp	r2, r3
	bcc	.L2990
	ldr	r1, .L3031+40
	movw	r2, #1668
	ldr	r0, .L3031+44
	bl	printf
	ldr	r1, .L3031+48
	ldr	r0, .L3031+52
	bl	printf
.L2990:
	ldrh	r3, [r7, #4]
	cbnz	r3, .L2991
	bl	FtlCacheWriteBack
	mov	r0, r7
	bl	allocate_new_data_superblock
.L2991:
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
	bcc	.L2992
	ldr	r1, .L3031+40
	movw	r2, #1701
	ldr	r0, .L3031+44
	bl	printf
	ldr	r1, .L3031+48
	ldr	r0, .L3031+52
	bl	printf
.L2992:
	movs	r3, #0
.L3030:
	str	r3, [sp, #8]
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #36]
	cmp	r3, r2
	bne	.L3013
.L2994:
	ldr	r0, .L3031+56
	mov	r3, r7
	movs	r2, #0
	ldr	r1, [sp, #8]
	ldr	r0, [r0]
	bl	FtlProgPages
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #8]
	cmp	r3, r2
	bcs	.L3014
	ldr	r1, .L3031+40
	movw	r2, #1790
	ldr	r0, .L3031+44
	bl	printf
	ldr	r1, .L3031+48
	ldr	r0, .L3031+52
	bl	printf
.L3014:
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #8]
	subs	r3, r3, r2
	str	r3, [sp, #4]
	b	.L2989
.L3013:
	ldrh	r3, [r7, #4]
	cmp	r3, #0
	beq	.L2994
	movs	r2, #0
	add	r1, sp, #40
	mov	r0, r4
	movs	r5, #36
	bl	log2phys
	mov	r0, r7
	bl	get_new_active_ppa
	ldr	r3, [sp, #8]
	ldr	r2, .L3031+60
	muls	r5, r3, r5
	ldr	r3, .L3031+56
	ldrh	r2, [r2]
	ldr	r1, [r3]
	str	r3, [sp, #20]
	ldr	r3, [sp, #8]
	add	r1, r1, r5
	str	r0, [r1, #4]
	str	r4, [r1, #16]
	mul	r0, r2, r3
	bic	r3, r0, #3
	ldr	r0, .L3031+64
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
	ldr	r1, .L3031+16
	beq	.L2995
	ldr	r3, [sp, #16]
	cmp	r3, r4
	ldr	r3, [sp, #20]
	bne	.L3026
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
	b	.L2998
.L2995:
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
.L2998:
	ldr	r3, .L3031+16
	ldr	r2, [sp, #20]
	ldrh	r3, [r3]
	cmp	r3, r2
	ldr	r3, .L3031+56
	ldr	r3, [r3]
	bne	.L2999
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
.L3001:
	ldr	r3, .L3031+36
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L3010
	ldr	r1, .L3031+40
	movw	r2, #1775
	ldr	r0, .L3031+44
	bl	printf
	ldr	r1, .L3031+48
	ldr	r0, .L3031+52
	bl	printf
.L3010:
	ldr	r2, [sp, #32]
	movw	r3, #61589
	ldr	r1, [sp, #28]
	strh	r3, [r2, r1]	@ movhi
	ldr	r2, .L3031+68
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
	b	.L3030
.L3032:
	.align	2
.L3031:
	.word	.LANCHOR77
	.word	.LANCHOR69
	.word	.LANCHOR231
	.word	.LANCHOR246
	.word	.LANCHOR56
	.word	.LANCHOR162
	.word	.LANCHOR132
	.word	.LANCHOR92
	.word	.LANCHOR164
	.word	.LANCHOR38
	.word	.LANCHOR247
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR182
	.word	.LANCHOR59
	.word	.LANCHOR189
	.word	.LANCHOR160
.L2999:
	cmp	r4, r8
	add	r3, r3, r5
	ite	eq
	ldreq	r2, .L3033
	ldrne	r2, .L3033+4
	ldr	r2, [r2]
	str	r2, [r3, #8]
	ldr	r2, [sp, #40]
	ldr	r3, .L3033+8
	adds	r0, r2, #1
	beq	.L3004
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
	bne	.L3005
	ldr	r2, .L3033+12
	ldr	r3, [r2, #72]
	adds	r3, r3, #1
	str	r3, [r2, #72]
.L3008:
	ldr	r2, [sp, #20]
	cmp	r4, r8
	ldr	r3, .L3033+8
	lsl	r2, r2, #9
	bne	.L3009
	ldr	r3, [r3]
	mov	r1, r10
	add	r5, r5, r3
	ldr	r3, [sp, #24]
	ldr	r0, [r5, #8]
	add	r0, r0, r3, lsl #9
.L3028:
	bl	ftl_memcpy
	b	.L3001
.L3005:
	ldr	r1, [fp, #8]
	cmp	r4, r1
	beq	.L3007
	ldr	r2, .L3033+12
	ldr	r0, .L3033+16
	ldr	r3, [r2, #72]
	adds	r3, r3, #1
	str	r3, [r2, #72]
	mov	r2, r4
	bl	printf
.L3007:
	ldr	r3, [fp, #8]
	cmp	r4, r3
	beq	.L3008
	movw	r2, #1754
	ldr	r1, .L3033+20
	ldr	r0, .L3033+24
	bl	printf
	ldr	r1, .L3033+28
	ldr	r0, .L3033+32
	bl	printf
	b	.L3008
.L3004:
	ldr	r3, [r3]
	movs	r1, #0
	ldr	r2, .L3033+36
	add	r3, r3, r5
	ldrh	r2, [r2]
	ldr	r0, [r3, #8]
	bl	ftl_memset
	b	.L3008
.L3009:
	ldr	r1, .L3033+40
	ldr	r3, [r3]
	ldrh	r1, [r1]
	add	r5, r5, r3
	ldr	r0, [r5, #8]
	muls	r1, r4, r1
	subs	r1, r1, r6
	add	r1, r10, r1, lsl #9
	b	.L3028
.L3026:
	ldr	r3, [r3]
	add	r5, r5, r3
	ldrh	r3, [r1]
	muls	r3, r4, r3
	subs	r3, r3, r6
	add	r3, r10, r3, lsl #9
	str	r3, [r5, #8]
	b	.L3001
.L3017:
	mov	r0, #-1
	b	.L2983
.L3034:
	.align	2
.L3033:
	.word	.LANCHOR186
	.word	.LANCHOR187
	.word	.LANCHOR182
	.word	.LANCHOR138
	.word	.LC72
	.word	.LANCHOR247
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR58
	.word	.LANCHOR56
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
	cbnz	r0, .L3040
	mov	r3, r2
	mov	r2, r5
	bl	idb_write_data
.L3040:
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
	ldr	r6, .L3065
	ldr	r5, .L3065+4
	ldr	r1, .L3065+8
	ldr	r0, .L3065+12
	bl	printf
	mov	r2, #8192
	movs	r1, #0
	ldr	r0, .L3065+4
	bl	memset
.L3042:
	ldr	r3, [r6]
	cmp	r4, r3
	bcc	.L3044
	ldr	r7, .L3065+16
	movs	r4, #0
	ldr	r5, .L3065+20
	movs	r2, #2
	ldr	r10, .L3065+4
	mov	r6, r4
	ldr	fp, .L3065+60
	mov	r8, r7
	ldrh	r3, [r7]
	ldr	r1, [r5]
	ldr	r0, .L3065+24
	bl	rknand_print_hex
	ldrh	r3, [r7]
	movs	r2, #2
	ldr	r1, .L3065+4
	ldr	r0, .L3065+28
	bl	rknand_print_hex
.L3045:
	ldrh	r2, [r8]
	uxth	r3, r4
	cmp	r2, r3
	bhi	.L3047
	ldr	r3, .L3065+32
	ldr	r4, [r3]
	cbz	r4, .L3048
	ldr	r3, .L3065+36
	mov	r8, #0
	ldr	r7, .L3065+40
	ldr	fp, .L3065+64
	ldrh	r10, [r3]
	ldr	r3, [r7]
	subs	r4, r4, r3
	ldr	r3, .L3065+44
	asrs	r4, r4, #1
	muls	r4, r3, r4
	uxth	r4, r4
.L3049:
	uxth	r3, r8
	cmp	r10, r3
	bls	.L3048
	ldr	r3, [r5]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L3050
	ldr	r3, .L3065+4
	movs	r6, #1
	mov	r1, r4
	mov	r0, fp
	ldrh	r3, [r3, r4, lsl #1]
	bl	printf
.L3050:
	movs	r3, #6
	ldr	r2, [r7]
	muls	r4, r3, r4
	movw	r3, #65535
	add	r8, r8, #1
	ldrh	r4, [r2, r4]
	cmp	r4, r3
	bne	.L3049
.L3048:
	cbz	r6, .L3041
	ldr	r1, .L3065+8
	movw	r2, #1669
	ldr	r0, .L3065+48
	bl	printf
	ldr	r1, .L3065+52
	ldr	r0, .L3065+56
	bl	printf
.L3041:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3044:
	movs	r2, #0
	add	r1, sp, #4
	mov	r0, r4
	bl	log2phys
	ldr	r0, [sp, #4]
	adds	r3, r0, #1
	beq	.L3043
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r5, r0, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r5, r0, lsl #1]	@ movhi
.L3043:
	adds	r4, r4, #1
	b	.L3042
.L3047:
	ldr	r3, [r5]
	uxth	r7, r4
	ldrh	r2, [r3, r7, lsl #1]
	ldrh	r3, [r10, r7, lsl #1]
	cmp	r2, r3
	beq	.L3046
	mov	r1, r7
	mov	r0, fp
	bl	printf
	ldr	r3, [r5]
	movw	r2, #65535
	ldrh	r3, [r3, r7, lsl #1]
	cmp	r3, r2
	beq	.L3046
	ldrh	r2, [r10, r7, lsl #1]
	cmp	r2, r3
	it	hi
	movhi	r6, #1
.L3046:
	adds	r4, r4, #1
	b	.L3045
.L3066:
	.align	2
.L3065:
	.word	.LANCHOR73
	.word	check_valid_page_count_table
	.word	.LANCHOR248
	.word	.LC45
	.word	.LANCHOR40
	.word	.LANCHOR84
	.word	.LC73
	.word	.LC74
	.word	.LANCHOR88
	.word	.LANCHOR89
	.word	.LANCHOR82
	.word	-1431655765
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC75
	.word	.LC76
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
	ldr	r5, .L3074
	sub	sp, sp, #24
	mov	r7, r0
	movs	r6, #0
	ldr	r4, .L3074+4
	ldr	r3, [r5]
	ldr	r8, .L3074+20
	mov	fp, r4
	str	r3, [r4, #8]
	ldr	r3, .L3074+8
	ldr	r3, [r3]
	str	r3, [r4, #12]
.L3068:
	ldrh	r2, [r8]
	sxth	r3, r6
	cmp	r3, r2
	blt	.L3070
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3070:
	movs	r2, #1
	orr	r3, r3, r10
	mov	r1, r2
	mov	r0, fp
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r2, [r4, #8]
	mov	r1, r7
	ldr	r3, [r4, #12]
	ldr	r0, .L3074+12
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
	beq	.L3069
	mov	r3, #768
	movs	r2, #4
	ldr	r1, [r5]
	ldr	r0, .L3074+16
	bl	rknand_print_hex
.L3069:
	adds	r6, r6, #1
	b	.L3068
.L3075:
	.align	2
.L3074:
	.word	.LANCHOR183
	.word	.LANCHOR202
	.word	.LANCHOR188
	.word	.LC77
	.word	.LC78
	.word	.LANCHOR54
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
	ldr	r3, .L3090
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	ldr	r8, .L3090+72
	ldrh	r5, [r3]
.L3077:
	ldr	r3, .L3090+4
	ldrh	r3, [r3]
	cmp	r3, r5
	bhi	.L3084
	ldr	r4, .L3090+8
	movs	r7, #0
.L3085:
	ldr	r3, .L3090+12
	sxth	r5, r7
	ldrh	r3, [r3]
	cmp	r5, r3
	bge	.L3088
	lsls	r5, r5, #1
	movs	r6, #0
	ldr	r8, .L3090+76
	b	.L3089
.L3079:
	str	r3, [sp, #36]
	mov	r1, r5
	ldr	r3, .L3090+16
	str	r2, [sp, #32]
	ldrb	r0, [r3, r6]	@ zero_extendqisi2
	bl	V2P_block
	str	r0, [sp, #28]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #32]
	ldr	r3, [sp, #36]
	cbnz	r0, .L3078
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
.L3078:
	adds	r6, r6, #1
.L3086:
	uxth	r1, r6
	cmp	r2, r1
	bhi	.L3079
	cbnz	r4, .L3080
.L3083:
	adds	r5, r5, #1
	uxth	r5, r5
	b	.L3077
.L3080:
	ldr	r10, .L3090+80
	mov	r0, r7
	movs	r6, #0
	movs	r7, #36
	movs	r2, #1
	mov	r1, r4
	bl	FlashReadPages
.L3081:
	uxth	r3, r6
	cmp	r4, r3
	bls	.L3083
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
	b	.L3081
.L3084:
	ldr	r1, .L3090+20
	movs	r6, #0
	ldr	r3, .L3090+24
	mov	r4, r6
	ldr	r7, [r8]
	mov	fp, #36
	ldr	r1, [r1]
	ldrh	r2, [r3]
	ldr	r3, .L3090+28
	str	r1, [sp, #24]
	ldr	r1, .L3090+32
	ldr	r3, [r3]
	ldrh	r10, [r1]
	b	.L3086
.L3087:
	ldr	r10, .L3090+44
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
	ldr	r0, .L3090+36
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
.L3089:
	ldrh	r2, [r8]
	sxth	r3, r6
	adds	r6, r6, #1
	cmp	r3, r2
	blt	.L3087
	adds	r7, r7, #1
	b	.L3085
.L3088:
	ldr	r3, .L3090+40
	movs	r2, #2
	ldr	r1, .L3090+44
	ldr	r0, .L3090+48
	ldr	r3, [r3]
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r4, .L3090+52
	movs	r2, #4
	ldr	r1, .L3090+56
	ldr	r0, .L3090+60
	ldrh	r3, [r4]
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r1, .L3090+64
	movs	r2, #4
	ldrh	r3, [r4]
	ldr	r0, .L3090+68
	ldr	r1, [r1]
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	rknand_print_hex
.L3091:
	.align	2
.L3090:
	.word	.LANCHOR40
	.word	.LANCHOR41
	.word	.LANCHOR202
	.word	.LANCHOR128
	.word	.LANCHOR47
	.word	.LANCHOR106
	.word	.LANCHOR38
	.word	.LANCHOR105
	.word	.LANCHOR59
	.word	.LC48
	.word	.LANCHOR65
	.word	.LANCHOR129
	.word	.LC80
	.word	.LANCHOR67
	.word	.LANCHOR131
	.word	.LC81
	.word	.LANCHOR195
	.word	.LC82
	.word	.LANCHOR180
	.word	.LANCHOR54
	.word	.LC79
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
	.section	.bss.DeviceCapacity,"aw",%nobits
	.align	2
	.set	.LANCHOR61,. + 0
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
	.set	.LANCHOR100,. + 0
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
	.section	.bss.c_ftl_nand_blks_per_die_shift,"aw",%nobits
	.align	1
	.set	.LANCHOR52,. + 0
	.type	c_ftl_nand_blks_per_die_shift, %object
	.size	c_ftl_nand_blks_per_die_shift, 2
c_ftl_nand_blks_per_die_shift:
	.space	2
	.section	.bss.c_ftl_nand_byte_pre_oob,"aw",%nobits
	.align	1
	.set	.LANCHOR59,. + 0
	.type	c_ftl_nand_byte_pre_oob, %object
	.size	c_ftl_nand_byte_pre_oob, 2
c_ftl_nand_byte_pre_oob:
	.space	2
	.section	.bss.c_ftl_nand_byte_pre_page,"aw",%nobits
	.align	1
	.set	.LANCHOR58,. + 0
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
	.set	.LANCHOR66,. + 0
	.type	c_ftl_nand_init_sys_blks_per_plane, %object
	.size	c_ftl_nand_init_sys_blks_per_plane, 4
c_ftl_nand_init_sys_blks_per_plane:
	.space	4
	.section	.bss.c_ftl_nand_l2pmap_ram_region_num,"aw",%nobits
	.align	1
	.set	.LANCHOR68,. + 0
	.type	c_ftl_nand_l2pmap_ram_region_num, %object
	.size	c_ftl_nand_l2pmap_ram_region_num, 2
c_ftl_nand_l2pmap_ram_region_num:
	.space	2
	.section	.bss.c_ftl_nand_map_blks_per_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR64,. + 0
	.type	c_ftl_nand_map_blks_per_plane, %object
	.size	c_ftl_nand_map_blks_per_plane, 2
c_ftl_nand_map_blks_per_plane:
	.space	2
	.section	.bss.c_ftl_nand_map_region_num,"aw",%nobits
	.align	1
	.set	.LANCHOR67,. + 0
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
	.set	.LANCHOR65,. + 0
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
	.set	.LANCHOR62,. + 0
	.type	c_ftl_nand_max_vendor_blks, %object
	.size	c_ftl_nand_max_vendor_blks, 2
c_ftl_nand_max_vendor_blks:
	.space	2
	.section	.bss.c_ftl_nand_page_pre_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR53,. + 0
	.type	c_ftl_nand_page_pre_blk, %object
	.size	c_ftl_nand_page_pre_blk, 2
c_ftl_nand_page_pre_blk:
	.space	2
	.section	.bss.c_ftl_nand_page_pre_slc_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR54,. + 0
	.type	c_ftl_nand_page_pre_slc_blk, %object
	.size	c_ftl_nand_page_pre_slc_blk, 2
c_ftl_nand_page_pre_slc_blk:
	.space	2
	.section	.bss.c_ftl_nand_page_pre_super_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR55,. + 0
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
	.set	.LANCHOR60,. + 0
	.type	c_ftl_nand_reserved_blks, %object
	.size	c_ftl_nand_reserved_blks, 2
c_ftl_nand_reserved_blks:
	.space	2
	.section	.bss.c_ftl_nand_sec_pre_page,"aw",%nobits
	.align	1
	.set	.LANCHOR56,. + 0
	.type	c_ftl_nand_sec_pre_page, %object
	.size	c_ftl_nand_sec_pre_page, 2
c_ftl_nand_sec_pre_page:
	.space	2
	.section	.bss.c_ftl_nand_sec_pre_page_shift,"aw",%nobits
	.align	1
	.set	.LANCHOR57,. + 0
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
	.set	.LANCHOR63,. + 0
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
	.set	.LANCHOR108,. + 0
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
	.set	.LANCHOR75,. + 0
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
	.set	.LANCHOR8,. + 0
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
	.set	.LANCHOR15,. + 0
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
	.set	.LANCHOR76,. + 0
	.type	gSysFreeQueue, %object
	.size	gSysFreeQueue, 2056
gSysFreeQueue:
	.space	2056
	.section	.bss.gSysInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR209,. + 0
	.type	gSysInfo, %object
	.size	gSysInfo, 12
gSysInfo:
	.space	12
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
	.set	.LANCHOR69,. + 0
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
	.set	.LANCHOR73,. + 0
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
	.set	.LANCHOR101,. + 0
	.type	g_VaildLpn, %object
	.size	g_VaildLpn, 4
g_VaildLpn:
	.space	4
	.section	.bss.g_active_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR92,. + 0
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
	.set	.LANCHOR93,. + 0
	.type	g_buffer_superblock, %object
	.size	g_buffer_superblock, 48
g_buffer_superblock:
	.space	48
	.section	.bss.g_cur_erase_blk,"aw",%nobits
	.align	2
	.set	.LANCHOR74,. + 0
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
	.set	.LANCHOR77,. + 0
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
	.set	.LANCHOR119,. + 0
	.type	g_gc_bad_block_gc_index, %object
	.size	g_gc_bad_block_gc_index, 2
g_gc_bad_block_gc_index:
	.space	2
	.section	.bss.g_gc_bad_block_temp_num,"aw",%nobits
	.align	1
	.set	.LANCHOR117,. + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.space	2
	.section	.bss.g_gc_bad_block_temp_tbl,"aw",%nobits
	.align	1
	.set	.LANCHOR118,. + 0
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
	.set	.LANCHOR110,. + 0
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
	.set	.LANCHOR113,. + 0
	.type	g_gc_next_blk, %object
	.size	g_gc_next_blk, 2
g_gc_next_blk:
	.space	2
	.section	.bss.g_gc_next_blk_1,"aw",%nobits
	.align	1
	.set	.LANCHOR114,. + 0
	.type	g_gc_next_blk_1, %object
	.size	g_gc_next_blk_1, 2
g_gc_next_blk_1:
	.space	2
	.section	.bss.g_gc_next_blk_2,"aw",%nobits
	.align	1
	.set	.LANCHOR115,. + 0
	.type	g_gc_next_blk_2, %object
	.size	g_gc_next_blk_2, 2
g_gc_next_blk_2:
	.space	2
	.section	.bss.g_gc_next_blk_3,"aw",%nobits
	.align	1
	.set	.LANCHOR116,. + 0
	.type	g_gc_next_blk_3, %object
	.size	g_gc_next_blk_3, 2
g_gc_next_blk_3:
	.space	2
	.section	.bss.g_gc_num_req,"aw",%nobits
	.align	2
	.set	.LANCHOR103,. + 0
	.type	g_gc_num_req, %object
	.size	g_gc_num_req, 4
g_gc_num_req:
	.space	4
	.section	.bss.g_gc_page_offset,"aw",%nobits
	.align	1
	.set	.LANCHOR111,. + 0
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
	.set	.LANCHOR94,. + 0
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
	.set	.LANCHOR98,. + 0
	.type	g_l2p_last_update_region_id, %object
	.size	g_l2p_last_update_region_id, 2
g_l2p_last_update_region_id:
	.space	2
	.section	.bss.g_maxRegNum,"aw",%nobits
	.set	.LANCHOR13,. + 0
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
	.set	.LANCHOR29,. + 0
	.type	g_nandc_version_data, %object
	.size	g_nandc_version_data, 4
g_nandc_version_data:
	.space	4
	.section	.bss.g_num_data_superblocks,"aw",%nobits
	.align	1
	.set	.LANCHOR86,. + 0
	.type	g_num_data_superblocks, %object
	.size	g_num_data_superblocks, 2
g_num_data_superblocks:
	.space	2
	.section	.bss.g_num_free_superblocks,"aw",%nobits
	.align	1
	.set	.LANCHOR89,. + 0
	.type	g_num_free_superblocks, %object
	.size	g_num_free_superblocks, 2
g_num_free_superblocks:
	.space	2
	.section	.bss.g_page_map_check_enable,"aw",%nobits
	.align	1
	.set	.LANCHOR70,. + 0
	.type	g_page_map_check_enable, %object
	.size	g_page_map_check_enable, 2
g_page_map_check_enable:
	.space	2
	.section	.bss.g_power_lost_ecc_error_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR235,. + 0
	.type	g_power_lost_ecc_error_blk, %object
	.size	g_power_lost_ecc_error_blk, 2
g_power_lost_ecc_error_blk:
	.space	2
	.section	.bss.g_power_lost_recovery_flag,"aw",%nobits
	.align	1
	.set	.LANCHOR236,. + 0
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
	.set	.LANCHOR237,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.space	4
	.section	.bss.g_recovery_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR238,. + 0
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
	.set	.LANCHOR10,. + 0
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
	.set	.LANCHOR81,. + 0
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
	.set	.LANCHOR80,. + 0
	.type	g_totle_sys_slc_erase_count, %object
	.size	g_totle_sys_slc_erase_count, 4
g_totle_sys_slc_erase_count:
	.space	4
	.section	.bss.g_totle_vendor_block,"aw",%nobits
	.align	1
	.set	.LANCHOR71,. + 0
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
	.set	.LANCHOR232,. + 0
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
	.set	.LANCHOR104,. + 0
	.type	gp_gc_page_buf_info, %object
	.size	gp_gc_page_buf_info, 4
gp_gc_page_buf_info:
	.space	4
	.section	.bss.gp_last_act_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR230,. + 0
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
	.set	.LANCHOR83,. + 0
	.type	p_data_block_list_head, %object
	.size	p_data_block_list_head, 4
p_data_block_list_head:
	.space	4
	.section	.bss.p_data_block_list_table,"aw",%nobits
	.align	2
	.set	.LANCHOR82,. + 0
	.type	p_data_block_list_table, %object
	.size	p_data_block_list_table, 4
p_data_block_list_table:
	.space	4
	.section	.bss.p_data_block_list_tail,"aw",%nobits
	.align	2
	.set	.LANCHOR85,. + 0
	.type	p_data_block_list_tail, %object
	.size	p_data_block_list_tail, 4
p_data_block_list_tail:
	.space	4
	.section	.bss.p_erase_count_table,"aw",%nobits
	.align	2
	.set	.LANCHOR79,. + 0
	.type	p_erase_count_table, %object
	.size	p_erase_count_table, 4
p_erase_count_table:
	.space	4
	.section	.bss.p_free_data_block_list_head,"aw",%nobits
	.align	2
	.set	.LANCHOR88,. + 0
	.type	p_free_data_block_list_head, %object
	.size	p_free_data_block_list_head, 4
p_free_data_block_list_head:
	.space	4
	.section	.bss.p_gc_blk_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR109,. + 0
	.type	p_gc_blk_tbl, %object
	.size	p_gc_blk_tbl, 4
p_gc_blk_tbl:
	.space	4
	.section	.bss.p_gc_data_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR105,. + 0
	.type	p_gc_data_buf, %object
	.size	p_gc_data_buf, 4
p_gc_data_buf:
	.space	4
	.section	.bss.p_gc_page_info,"aw",%nobits
	.align	2
	.set	.LANCHOR112,. + 0
	.type	p_gc_page_info, %object
	.size	p_gc_page_info, 4
p_gc_page_info:
	.space	4
	.section	.bss.p_gc_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR106,. + 0
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
	.set	.LANCHOR97,. + 0
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
	.set	.LANCHOR84,. + 0
	.type	p_valid_page_count_table, %object
	.size	p_valid_page_count_table, 4
p_valid_page_count_table:
	.space	4
	.section	.bss.p_vendor_block_table,"aw",%nobits
	.align	2
	.set	.LANCHOR72,. + 0
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
	.set	.LANCHOR78,. + 0
	.type	req_erase, %object
	.size	req_erase, 4
req_erase:
	.space	4
	.section	.bss.req_gc,"aw",%nobits
	.align	2
	.set	.LANCHOR107,. + 0
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
	.section	.data.Toshiba15RefValue,"aw",%progbits
	.set	.LANCHOR11,. + 0
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
	.section	.data.ToshibaRefValue,"aw",%progbits
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
	.section	.data.ftl_gc_temp_block_bops_scan_page_addr,"aw",%progbits
	.align	1
	.set	.LANCHOR226,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.short	-1
	.section	.data.gFtlInitStatus,"aw",%progbits
	.align	2
	.set	.LANCHOR231,. + 0
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
.LC53:
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
.LC73:
	.ascii	"vpc1\000"
.LC74:
	.ascii	"vpc2\000"
.LC75:
	.ascii	"FtlCheckVpc2 %x = %x  %x\012\000"
.LC76:
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
.LC77:
	.ascii	"id = %x,%x addr= %x,spare= %x %x %x %x data = %x\012"
	.ascii	"\000"
.LC78:
	.ascii	":\000"
	.section	.rodata.FtlFreeSysBlkQueueOut.str1.1,"aMS",%progbits,1
.LC3:
	.ascii	"FtlFreeSysBlkQueueOut free count = %d\012\000"
.LC4:
	.ascii	"FtlFreeSysBlkQueueOut = %x, free count = %d, error\012"
	.ascii	"\000"
	.section	.rodata.FtlGcFreeTempBlock.str1.1,"aMS",%progbits,1
.LC64:
	.ascii	"GC des block %x done\012\000"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",%progbits,1
.LC52:
	.ascii	"FtlGcScanTempBlkError ID %x %x!!!!!!!\012\000"
	.section	.rodata.FtlInit.str1.1,"aMS",%progbits,1
.LC66:
	.ascii	"FTL version: 5.0.50 20180905\000"
.LC67:
	.ascii	"...%s: no bad block mapping table, format device\012"
	.ascii	"\000"
.LC68:
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
.LC57:
	.ascii	"Ftlwrite decrement_vpc_count %x = %d\012\000"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",%progbits,1
.LC61:
	.ascii	"RSB refresh addr %x\012\000"
.LC62:
	.ascii	"spuer block %x vpn is 0\012 \000"
.LC63:
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
.LC72:
	.ascii	"FtlWrite: lpa error:%x %x\012\000"
	.section	.rodata.Ftl_load_ext_data.str1.1,"aMS",%progbits,1
.LC44:
	.ascii	"slc mode\000"
	.section	.rodata.Ftlscanalldata.str1.1,"aMS",%progbits,1
.LC58:
	.ascii	"Ftlscanalldata = %x\012\000"
.LC59:
	.ascii	"scan lpa = %x ppa= %x\012\000"
.LC60:
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
	.section	.rodata.__func__.10408,"a",%progbits
	.set	.LANCHOR245,. + 0
	.type	__func__.10408, %object
	.size	__func__.10408, 8
__func__.10408:
	.ascii	"FtlInit\000"
	.section	.rodata.__func__.10468,"a",%progbits
	.set	.LANCHOR229,. + 0
	.type	__func__.10468, %object
	.size	__func__.10468, 13
__func__.10468:
	.ascii	"FtlProgPages\000"
	.section	.rodata.__func__.10494,"a",%progbits
	.set	.LANCHOR247,. + 0
	.type	__func__.10494, %object
	.size	__func__.10494, 9
__func__.10494:
	.ascii	"FtlWrite\000"
	.section	.rodata.__func__.10577,"a",%progbits
	.set	.LANCHOR124,. + 0
	.type	__func__.10577, %object
	.size	__func__.10577, 14
__func__.10577:
	.ascii	"FtlBbt2Bitmap\000"
	.section	.rodata.__func__.10623,"a",%progbits
	.set	.LANCHOR211,. + 0
	.type	__func__.10623, %object
	.size	__func__.10623, 11
__func__.10623:
	.ascii	"FtlLoadBbt\000"
	.section	.rodata.__func__.10716,"a",%progbits
	.set	.LANCHOR90,. + 0
	.type	__func__.10716, %object
	.size	__func__.10716, 17
__func__.10716:
	.ascii	"INSERT_FREE_LIST\000"
	.section	.rodata.__func__.10720,"a",%progbits
	.set	.LANCHOR87,. + 0
	.type	__func__.10720, %object
	.size	__func__.10720, 17
__func__.10720:
	.ascii	"INSERT_DATA_LIST\000"
	.section	.rodata.__func__.10757,"a",%progbits
	.set	.LANCHOR91,. + 0
	.type	__func__.10757, %object
	.size	__func__.10757, 17
__func__.10757:
	.ascii	"List_remove_node\000"
	.section	.rodata.__func__.10787,"a",%progbits
	.set	.LANCHOR95,. + 0
	.type	__func__.10787, %object
	.size	__func__.10787, 22
__func__.10787:
	.ascii	"List_update_data_list\000"
	.section	.rodata.__func__.10794,"a",%progbits
	.set	.LANCHOR228,. + 0
	.type	__func__.10794, %object
	.size	__func__.10794, 20
__func__.10794:
	.ascii	"ftl_load_l2p_region\000"
	.section	.rodata.__func__.10825,"a",%progbits
	.set	.LANCHOR96,. + 0
	.type	__func__.10825, %object
	.size	__func__.10825, 26
__func__.10825:
	.ascii	"ftl_map_blk_alloc_new_blk\000"
	.section	.rodata.__func__.10835,"a",%progbits
	.set	.LANCHOR212,. + 0
	.type	__func__.10835, %object
	.size	__func__.10835, 15
__func__.10835:
	.ascii	"ftl_map_blk_gc\000"
	.section	.rodata.__func__.10848,"a",%progbits
	.set	.LANCHOR213,. + 0
	.type	__func__.10848, %object
	.size	__func__.10848, 31
__func__.10848:
	.ascii	"Ftl_write_map_blk_to_last_page\000"
	.section	.rodata.__func__.10861,"a",%progbits
	.set	.LANCHOR214,. + 0
	.type	__func__.10861, %object
	.size	__func__.10861, 16
__func__.10861:
	.ascii	"FtlMapWritePage\000"
	.section	.rodata.__func__.10881,"a",%progbits
	.set	.LANCHOR99,. + 0
	.type	__func__.10881, %object
	.size	__func__.10881, 22
__func__.10881:
	.ascii	"select_l2p_ram_region\000"
	.section	.rodata.__func__.10897,"a",%progbits
	.set	.LANCHOR227,. + 0
	.type	__func__.10897, %object
	.size	__func__.10897, 9
__func__.10897:
	.ascii	"log2phys\000"
	.section	.rodata.__func__.10959,"a",%progbits
	.set	.LANCHOR210,. + 0
	.type	__func__.10959, %object
	.size	__func__.10959, 15
__func__.10959:
	.ascii	"FtlVpcTblFlush\000"
	.section	.rodata.__func__.10978,"a",%progbits
	.set	.LANCHOR220,. + 0
	.type	__func__.10978, %object
	.size	__func__.10978, 14
__func__.10978:
	.ascii	"FtlScanSysBlk\000"
	.section	.rodata.__func__.11032,"a",%progbits
	.set	.LANCHOR221,. + 0
	.type	__func__.11032, %object
	.size	__func__.11032, 15
__func__.11032:
	.ascii	"FtlLoadSysInfo\000"
	.section	.rodata.__func__.11043,"a",%progbits
	.set	.LANCHOR248,. + 0
	.type	__func__.11043, %object
	.size	__func__.11043, 12
__func__.11043:
	.ascii	"FtlCheckVpc\000"
	.section	.rodata.__func__.11075,"a",%progbits
	.set	.LANCHOR224,. + 0
	.type	__func__.11075, %object
	.size	__func__.11075, 17
__func__.11075:
	.ascii	"FtlDumpBlockInfo\000"
	.section	.rodata.__func__.11094,"a",%progbits
	.set	.LANCHOR225,. + 0
	.type	__func__.11094, %object
	.size	__func__.11094, 16
__func__.11094:
	.ascii	"FtlScanAllBlock\000"
	.section	.rodata.__func__.11199,"a",%progbits
	.set	.LANCHOR233,. + 0
	.type	__func__.11199, %object
	.size	__func__.11199, 16
__func__.11199:
	.ascii	"FtlReUsePrevPpa\000"
	.section	.rodata.__func__.11232,"a",%progbits
	.set	.LANCHOR234,. + 0
	.type	__func__.11232, %object
	.size	__func__.11232, 22
__func__.11232:
	.ascii	"FtlRecoverySuperblock\000"
	.section	.rodata.__func__.11286,"a",%progbits
	.set	.LANCHOR102,. + 0
	.type	__func__.11286, %object
	.size	__func__.11286, 16
__func__.11286:
	.ascii	"make_superblock\000"
	.section	.rodata.__func__.11306,"a",%progbits
	.set	.LANCHOR140,. + 0
	.type	__func__.11306, %object
	.size	__func__.11306, 18
__func__.11306:
	.ascii	"SupperBlkListInit\000"
	.section	.rodata.__func__.11383,"a",%progbits
	.set	.LANCHOR203,. + 0
	.type	__func__.11383, %object
	.size	__func__.11383, 25
__func__.11383:
	.ascii	"allocate_data_superblock\000"
	.section	.rodata.__func__.11397,"a",%progbits
	.set	.LANCHOR219,. + 0
	.type	__func__.11397, %object
	.size	__func__.11397, 29
__func__.11397:
	.ascii	"allocate_new_data_superblock\000"
	.section	.rodata.__func__.11403,"a",%progbits
	.set	.LANCHOR208,. + 0
	.type	__func__.11403, %object
	.size	__func__.11403, 19
__func__.11403:
	.ascii	"get_new_active_ppa\000"
	.section	.rodata.__func__.11414,"a",%progbits
	.set	.LANCHOR206,. + 0
	.type	__func__.11414, %object
	.size	__func__.11414, 16
__func__.11414:
	.ascii	"update_vpc_list\000"
	.section	.rodata.__func__.11419,"a",%progbits
	.set	.LANCHOR207,. + 0
	.type	__func__.11419, %object
	.size	__func__.11419, 20
__func__.11419:
	.ascii	"decrement_vpc_count\000"
	.section	.rodata.__func__.11487,"a",%progbits
	.set	.LANCHOR239,. + 0
	.type	__func__.11487, %object
	.size	__func__.11487, 19
__func__.11487:
	.ascii	"FtlGcFreeTempBlock\000"
	.section	.rodata.__func__.11581,"a",%progbits
	.set	.LANCHOR243,. + 0
	.type	__func__.11581, %object
	.size	__func__.11581, 23
__func__.11581:
	.ascii	"rk_ftl_garbage_collect\000"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",%progbits,1
.LC36:
	.ascii	"decrement_vpc_count %x = %d\012\000"
.LC37:
	.ascii	"decrement_vpc_count %x = %d in free list\012\000"
	.section	.rodata.dump_map_info.str1.1,"aMS",%progbits,1
.LC79:
	.ascii	"phyBlk = %x,addr= %x,spare= %x %x %x %x data=%x %x\012"
	.ascii	"\000"
.LC80:
	.ascii	"Mblk:\000"
.LC81:
	.ascii	"L2P:\000"
.LC82:
	.ascii	"L2PC:\000"
	.section	.rodata.ftl_fix_nand_power_lost_error.str1.1,"aMS",%progbits,1
.LC70:
	.ascii	"fix power lost blk = %x vpc=%x\012\000"
.LC71:
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
.LC54:
	.ascii	"region_id = %x phyAddr = %x\012\000"
.LC55:
	.ascii	"map_ppn:\000"
.LC56:
	.ascii	"load_l2p_region refresh = %x phyAddr = %x\012\000"
	.section	.rodata.rk_ftl_garbage_collect.str1.1,"aMS",%progbits,1
.LC65:
	.ascii	"g_gc_superblock_free %x %x %x %x %x\012\000"
	.section	.rodata.rk_ftl_init.str1.1,"aMS",%progbits,1
.LC69:
	.ascii	"FtlInit %x\012\000"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",%progbits,1
.LC18:
	.ascii	"%s 0x%x:\000"
.LC19:
	.ascii	"%x \000"
.LC20:
	.ascii	"\000"
	.hidden	free
