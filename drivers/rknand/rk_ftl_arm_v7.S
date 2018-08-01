/*
 * Copyright (c) 2016-2018, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2018-08-10
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
	mov	r2, #628
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
	movw	r2, #863
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
	movw	r2, #2613
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
	.size	FtlGcRefreshBlock, .-FtlGcRefreshBlock
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
	@ link register save eliminated.
	b	FtlGcRefreshBlock
	.size	FtlGcRefreshOpenBlock, .-FtlGcRefreshOpenBlock
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
	ldr	r3, .L743
	ldr	r3, [r3]
	cbz	r3, .L736
	ldr	r3, .L743+4
	ldr	r2, [r3]
	ldrh	r3, [r2, r5, lsl #1]
	cmp	r3, #39
	itt	hi
	subhi	r3, r3, #40
	strhhi	r3, [r2, r5, lsl #1]	@ movhi
.L736:
	ldr	r2, .L743+8
	movs	r1, #0
	ldr	r5, .L743+12
	ldrh	r3, [r2]
.L737:
	uxth	r0, r1
	cmp	r3, r0
	bhi	.L739
	cmp	r3, #15
	itttt	ls
	addls	r1, r3, #1
	strhls	r1, [r2]	@ movhi
	ldrls	r2, .L743+12
	strhls	r4, [r2, r3, lsl #1]	@ movhi
	b	.L738
.L739:
	adds	r1, r1, #1
	add	r0, r5, r1, lsl #1
	ldrh	r0, [r0, #-2]
	cmp	r0, r4
	bne	.L737
.L738:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L744:
	.align	2
.L743:
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
	ldr	r3, .L751
	push	{r4, lr}
	ldrh	r3, [r3]
	cbz	r3, .L746
	ldr	r2, .L751+4
	ldrh	r1, [r2]
	movw	r2, #65535
	cmp	r1, r2
	bne	.L746
	ldr	r4, .L751+8
	ldrh	r2, [r4]
	cmp	r2, r3
	itt	cs
	movcs	r3, #0
	strhcs	r3, [r4]	@ movhi
	ldr	r3, .L751+12
	ldrh	r2, [r4]
	ldrh	r0, [r3, r2, lsl #1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
.L746:
	movs	r0, #0
	pop	{r4, pc}
.L752:
	.align	2
.L751:
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
	ldr	r3, .L755
	ldr	r2, [r3]
	ldr	r3, .L755+4
	cmp	r2, r3
	bne	.L753
	b	flash_enter_slc_mode
.L753:
	bx	lr
.L756:
	.align	2
.L755:
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
	ldr	r3, .L759
	ldr	r2, [r3]
	ldr	r3, .L759+4
	cmp	r2, r3
	bne	.L757
	b	flash_exit_slc_mode
.L757:
	bx	lr
.L760:
	.align	2
.L759:
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
	ldr	r3, .L762
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
.L763:
	.align	2
.L762:
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
	cbnz	r0, .L766
	ldr	r3, .L803
.L767:
	strh	r0, [r3, r0, lsl #1]	@ movhi
	adds	r0, r0, #1
	cmp	r0, #256
	bne	.L767
.L773:
	movs	r1, #255
	mov	r2, #1024
	ldr	r0, .L803+4
	uxth	r4, r4
	bl	ftl_memset
	ldr	r1, .L803
	movs	r3, #0
	ldr	r0, .L803+4
.L768:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L790
	pop	{r4, pc}
.L766:
	cmp	r0, #1
	bne	.L769
	ldr	r1, .L803
	movs	r3, #0
.L772:
	cmp	r3, #3
	uxth	r2, r3
	bls	.L770
	tst	r2, #1
	ite	ne
	movne	r0, #3
	moveq	r0, #2
	rsb	r2, r0, r2, lsl #1
	uxth	r2, r2
.L770:
	strh	r2, [r1, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L772
	b	.L773
.L769:
	cmp	r0, #2
	bne	.L774
	ldr	r1, .L803
	movs	r2, #0
.L776:
	uxth	r3, r2
	cmp	r2, #1
	ittt	hi
	lslhi	r3, r3, #1
	addhi	r3, r3, #-1
	uxthhi	r3, r3
	strh	r3, [r1, r2, lsl #1]	@ movhi
	adds	r2, r2, #1
	cmp	r2, #256
	bne	.L776
	b	.L773
.L774:
	cmp	r0, #3
	bne	.L777
	ldr	r1, .L803
	movs	r3, #0
.L780:
	cmp	r3, #5
	uxth	r2, r3
	bls	.L778
	tst	r2, #1
	ite	ne
	movne	r0, #5
	moveq	r0, #4
	rsb	r2, r0, r2, lsl #1
	uxth	r2, r2
.L778:
	strh	r2, [r1, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L780
	b	.L773
.L777:
	cmp	r0, #4
	mov	r3, #0
	bne	.L781
	ldr	r2, .L803
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
.L783:
	tst	r3, #1
	ite	ne
	movne	r1, #7
	moveq	r1, #6
	rsb	r1, r1, r3, lsl #1
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r1, [r2, #2]!	@ movhi
	cmp	r3, #256
	bne	.L783
	b	.L773
.L781:
	cmp	r0, #5
	bne	.L784
	ldr	r2, .L803
.L785:
	strh	r3, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #16
	bne	.L785
	ldr	r2, .L803+8
.L786:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, #496
	bne	.L786
	b	.L773
.L784:
	cmp	r0, #6
	bne	.L773
	ldr	r0, .L803
	mov	r1, r3
.L789:
	cmp	r1, #5
	uxth	r2, r1
	bls	.L787
	tst	r2, #1
	ite	ne
	movne	r2, #12
	moveq	r2, #10
	subs	r2, r3, r2
	uxth	r2, r2
.L787:
	strh	r2, [r0, r1, lsl #1]	@ movhi
	adds	r1, r1, #1
	cmp	r1, #256
	add	r3, r3, #3
	uxth	r3, r3
	bne	.L789
	b	.L773
.L790:
	ldrh	r2, [r1, r3, lsl #1]
	adds	r3, r3, #1
	strh	r2, [r0, r2, lsl #1]	@ movhi
	b	.L768
.L804:
	.align	2
.L803:
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
	ldr	r2, .L823
	ldr	r4, .L823+4
	strb	r3, [r2]
	str	r2, [sp]
	strb	r3, [r4]
	ldr	r3, .L823+8
	ldr	r7, .L823+12
	ldrh	r3, [r3, #10]
	cmp	r3, #256
	bls	.L806
	mov	r3, #512
.L822:
	movs	r2, #8
	movs	r1, #0
	ldr	r0, .L823+16
	movs	r6, #0
	str	r3, [r7]
	bl	ftl_memset
	movs	r2, #32
	movs	r1, #0
	ldr	r0, .L823+20
	bl	ftl_memset
	movs	r2, #128
	movs	r1, #0
	ldr	r0, .L823+24
	bl	ftl_memset
	ldr	r3, .L823+28
	ldr	fp, .L823+36
	ldr	r5, [r3]
	ldr	r3, .L823+16
	ldrb	r10, [r5]	@ zero_extendqisi2
	add	r8, r5, #1
.L810:
	mov	r2, r10
	add	r1, fp, r6, lsl #3
	mov	r0, r8
	str	r3, [sp, #4]
	bl	FlashMemCmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L809
	ldrb	r2, [r4]	@ zero_extendqisi2
	ldr	r1, .L823+20
	strb	r6, [r3, r2]
	str	r0, [r1, r2, lsl #2]
	adds	r1, r2, #1
	strb	r1, [r4]
.L809:
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L810
	ldrb	r3, [r4]	@ zero_extendqisi2
	ldr	r2, [sp]
	strb	r3, [r2]
	ldrb	r3, [r5, #8]	@ zero_extendqisi2
	cmp	r3, #2
	beq	.L811
.L815:
	ldrh	r2, [r5, #14]
	ldrb	r3, [r4]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldrb	r2, [r5, #13]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldr	r2, .L823+32
	strh	r3, [r2]	@ movhi
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L806:
	cmp	r3, #128
	it	hi
	movhi	r3, #256
	b	.L822
.L811:
	ldr	fp, [r7]
	movs	r6, #0
	ldr	r7, .L823+20
	ldr	r3, .L823+16
.L814:
	str	r3, [sp]
	mov	r2, r10
	ldr	r3, .L823+36
	mov	r0, r8
	add	r1, r3, r6, lsl #3
	bl	FlashMemCmp8
	ldr	r3, [sp]
	cbnz	r0, .L812
	ldrh	r2, [r5, #14]
	ldrb	r1, [r4]	@ zero_extendqisi2
	and	r0, r2, #65280
	ldrb	r2, [r5, #13]	@ zero_extendqisi2
	mul	r2, fp, r2
	muls	r2, r0, r2
	str	r2, [r7, r1, lsl #2]
	ldrb	r0, [r5, #23]	@ zero_extendqisi2
	cbz	r0, .L813
	lsls	r2, r2, #1
	str	r2, [r7, r1, lsl #2]
.L813:
	adds	r2, r1, #1
	strb	r6, [r3, r1]
	strb	r2, [r4]
.L812:
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L814
	b	.L815
.L824:
	.align	2
.L823:
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
	ldr	r3, .L828
	movs	r2, #0
	ldr	r1, [r3]
	ldr	r3, .L828+4
	ldrb	r0, [r1, #9]	@ zero_extendqisi2
	ldr	r3, [r3]
	smulbb	r3, r3, r0
	uxth	r3, r3
	strb	r3, [r4, #4]
	lsrs	r3, r3, #8
	strb	r3, [r4, #5]
	ldr	r3, .L828+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r4, #7]
	ldr	r3, .L828+12
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
	ldr	r0, .L828+16
	strb	r2, [r4, #10]
	strb	r3, [r4, #9]
	ldr	r3, .L828+20
	ldrb	r1, [r3]	@ zero_extendqisi2
	mov	r3, r2
.L826:
	uxtb	r2, r3
	cmp	r1, r2
	bhi	.L827
	pop	{r4, r5, r6, pc}
.L827:
	ldrb	r2, [r3, r0]	@ zero_extendqisi2
	adds	r3, r3, #1
	ldrb	r6, [r4, #10]	@ zero_extendqisi2
	lsl	r2, r5, r2
	orrs	r2, r2, r6
	strb	r2, [r4, #10]
	b	.L826
.L829:
	.align	2
.L828:
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
	ldr	r3, .L836
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, r0
	ldr	r7, .L836+4
	mov	r6, r1
	subs	r4, r5, #2
	addw	r5, r5, #1022
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r8, .L836+20
	mov	r0, r6
	lsls	r2, r2, #2
	bl	ftl_memset
.L833:
	ldrh	r3, [r4, #2]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L830
	ldrh	r2, [r7]
	cmp	r2, r3
	bhi	.L832
	mov	r1, r8
	movs	r2, #79
	ldr	r0, .L836+8
	bl	printf
	ldr	r1, .L836+12
	ldr	r0, .L836+16
	bl	printf
.L832:
	ldrh	r3, [r4, #2]!
	movs	r2, #1
	cmp	r5, r4
	lsr	r1, r3, #5
	and	r3, r3, #31
	lsl	r3, r2, r3
	ldr	r2, [r6, r1, lsl #2]
	orr	r2, r2, r3
	str	r2, [r6, r1, lsl #2]
	bne	.L833
.L830:
	pop	{r4, r5, r6, r7, r8, pc}
.L837:
	.align	2
.L836:
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
	ldr	r0, .L839
	movw	r3, #65535
	movs	r2, #16
	movs	r1, #255
	strh	r3, [r0]	@ movhi
	movs	r3, #0
	strh	r3, [r0, #6]	@ movhi
	adds	r0, r0, #12
	b	ftl_memset
.L840:
	.align	2
.L839:
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
	ldr	r3, .L842
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
.L843:
	.align	2
.L842:
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
	ldr	r10, [r0, #12]
	lsls	r2, r2, #1
	ldr	r6, [r0, #24]
	mov	r0, r5
	bl	ftl_memset
	movs	r3, #0
.L845:
	ldrh	r1, [r4, #6]
	uxth	r2, r3
	cmp	r1, r2
	bhi	.L849
	ldrh	r3, [r5]
	movs	r6, #0
	ldr	r2, .L858
	mov	fp, r6
.L850:
	ldrh	r0, [r4, #10]
	uxth	r1, r6
	cmp	r0, r1
	bhi	.L854
	mov	r0, fp
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L849:
	uxth	r2, r3
	ldr	r1, [r6, r2, lsl #2]
	movs	r2, #0
	ubfx	r1, r1, #10, #16
.L846:
	ldrh	r7, [r4, #10]
	uxth	r0, r2
	cmp	r7, r0
	bhi	.L848
	adds	r3, r3, #1
	b	.L845
.L848:
	uxth	r0, r2
	adds	r2, r2, #1
	ldrh	r7, [r10, r0, lsl #1]
	cmp	r7, r1
	ittt	eq
	ldrheq	r7, [r5, r0, lsl #1]
	addeq	r7, r7, #1
	strheq	r7, [r5, r0, lsl #1]	@ movhi
	b	.L846
.L854:
	ldrh	r0, [r4]
	uxth	r7, r6
	cmp	r0, r1
	bne	.L851
	ldrh	r0, [r2]
	ldrh	ip, [r4, #2]
	cmp	ip, r0
	it	cc
	strhcc	r0, [r5, r7, lsl #1]	@ movhi
.L851:
	ldrh	r8, [r5, r7, lsl #1]
	cmp	r3, r8
	itt	hi
	movhi	fp, r1
	movhi	r3, r8
	cmp	r8, #0
	bne	.L853
	ldrh	r0, [r10, r7, lsl #1]
	cbz	r0, .L853
	movs	r1, #1
	str	r2, [sp, #4]
	str	r3, [sp]
	bl	FtlFreeSysBlkQueueIn
	strh	r8, [r10, r7, lsl #1]	@ movhi
	ldr	r2, [sp, #4]
	ldrh	r1, [r4, #8]
	ldr	r3, [sp]
	subs	r1, r1, #1
	strh	r1, [r4, #8]	@ movhi
.L853:
	adds	r6, r6, #1
	b	.L850
.L859:
	.align	2
.L858:
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
	ldr	r5, .L863
	ldr	r4, .L863+4
	ldr	r2, [r5]
	ldr	r7, .L863+8
	ldr	r6, .L863+12
	ldr	r0, [r4]
	lsls	r2, r2, #1
	ldr	r8, .L863+44
	bl	ftl_memset
	ldrh	r3, [r7]
	movs	r1, #255
	ldrh	r2, [r6]
	ldr	r0, [r8]
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L863+16
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
.L861:
	adds	r2, r2, #12
	adds	r6, r3, r7
	cmp	r2, r1
	bne	.L862
	ldr	r3, .L863+20
	ldr	r2, [r5]
	strh	r0, [r3, #2]	@ movhi
	strh	r2, [r3, #10]	@ movhi
	movw	r2, #61634
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L863+24
	strh	r0, [r3]	@ movhi
	strh	r0, [r3, #40]	@ movhi
	ldrh	r2, [r2]
	strh	r2, [r3, #8]	@ movhi
	ldr	r2, .L863+28
	ldrh	r2, [r2]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, .L863+32
	ldr	r2, [r2]
	str	r2, [r3, #12]
	ldr	r2, .L863+36
	ldr	r2, [r2]
	str	r2, [r3, #16]
	ldr	r2, [r4]
	str	r2, [r3, #20]
	ldr	r2, .L863+40
	ldr	r2, [r2]
	str	r2, [r3, #24]
	pop	{r4, r5, r6, r7, r8, pc}
.L862:
	bic	r3, r3, #3
	str	lr, [r2, #-8]
	add	r3, r3, ip
	strh	r0, [r2, #-12]	@ movhi
	str	r3, [r2, #-4]
	mov	r3, r6
	b	.L861
.L864:
	.align	2
.L863:
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
	ldr	r3, .L866
	movw	r2, #65535
	mov	r1, r4
	ldr	r5, .L866+4
	str	r4, [r3]
	ldr	r3, .L866+8
	strh	r2, [r3]	@ movhi
	mov	r2, #-1
	ldr	r3, .L866+12
	str	r4, [r3]
	ldr	r3, .L866+16
	str	r4, [r3]
	ldr	r3, .L866+20
	str	r2, [r3]
	ldr	r3, .L866+24
	str	r4, [r3]
	ldr	r3, .L866+28
	strh	r4, [r3]	@ movhi
	ldr	r3, .L866+32
	ldrh	r2, [r3]
	ldr	r3, .L866+36
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L866+40
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L866+44
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	mov	r1, r4
	movs	r2, #48
	ldr	r0, .L866+48
	bl	ftl_memset
	mov	r2, #512
	mov	r1, r4
	ldr	r0, .L866+52
	bl	ftl_memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L867:
	.align	2
.L866:
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
	ldr	r3, .L879
	movs	r2, #6
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r1, #0
	ldr	r6, .L879+4
	sub	sp, sp, #24
	movs	r4, #0
	ldrh	r3, [r3]
	mov	r8, r4
	ldr	r0, [r6]
	mov	r5, r4
	mov	r10, r6
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L879+8
	ldr	r2, .L879+12
	ldr	r1, .L879+16
	str	r4, [r3]
	ldr	r3, .L879+20
	strh	r4, [r2]	@ movhi
	strh	r4, [r1]	@ movhi
	str	r4, [r3]
	ldr	r3, .L879+24
	str	r2, [sp, #8]
	str	r4, [r3]
	ldr	r3, .L879+28
	mov	fp, r3
	strh	r4, [r3]	@ movhi
.L869:
	ldr	r3, .L879+32
	sxth	r7, r4
	ldrh	r3, [r3]
	cmp	r7, r3
	bge	.L876
	ldr	r3, .L879+36
	uxth	r1, r4
	str	r1, [sp, #12]
	ldrh	r2, [r3]
	ldr	r3, .L879+40
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r6, r3
	b	.L877
.L871:
	str	r3, [sp, #20]
	ldr	r3, .L879+44
	ldr	r1, [sp, #12]
	str	r2, [sp, #16]
	ldrb	r0, [r3, r0]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #20]
	cbnz	r0, .L870
	ldr	r1, [sp, #4]
	add	r6, r6, r1
	sxth	r6, r6
.L870:
	adds	r3, r3, #1
.L877:
	sxth	r0, r3
	cmp	r0, r2
	blt	.L871
	lsls	r3, r7, #1
	cbz	r6, .L872
	mov	r1, r6
	str	r3, [sp, #4]
	mov	r0, #32768
	bl	__aeabi_idiv
	ldr	r3, [sp, #4]
	sxth	r6, r0
.L873:
	ldr	r2, [r10]
	add	r3, r3, r7
	add	r2, r2, r3, lsl #1
	ldr	r3, .L879+48
	strh	r6, [r2, #4]	@ movhi
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L874
	ldr	r3, .L879+52
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L874
	ldr	r3, .L879+56
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L874
	ldr	r3, .L879+60
	uxth	r0, r4
	ldr	r3, [r3]
	ldrh	r3, [r3, r7, lsl #1]
	cbnz	r3, .L875
	add	r8, r8, #1
	uxth	r8, r8
	bl	INSERT_FREE_LIST
.L874:
	adds	r4, r4, #1
	b	.L869
.L872:
	ldr	r2, .L879+60
	movw	r1, #65535
	ldr	r2, [r2]
	strh	r1, [r2, r7, lsl #1]	@ movhi
	b	.L873
.L875:
	adds	r5, r5, #1
	uxth	r5, r5
	bl	INSERT_DATA_LIST
	b	.L874
.L876:
	ldr	r2, [sp, #8]
	strh	r8, [fp]	@ movhi
	strh	r5, [r2]	@ movhi
	add	r5, r5, r8
	cmp	r3, r5
	bge	.L878
	ldr	r1, .L879+64
	movw	r2, #2683
	ldr	r0, .L879+68
	bl	printf
	ldr	r1, .L879+72
	ldr	r0, .L879+76
	bl	printf
.L878:
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L880:
	.align	2
.L879:
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
	ldr	r2, .L882
	movs	r3, #0
	push	{r4, lr}
	movs	r1, #255
	ldr	r4, .L882+4
	strh	r3, [r2]	@ movhi
	ldr	r2, .L882+8
	strh	r3, [r2]	@ movhi
	ldrh	r2, [r4]
	ldr	r3, .L882+12
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r2, #12
	movs	r1, #255
	muls	r2, r3, r2
	ldr	r3, .L882+16
	ldr	r0, [r3]
	bl	ftl_memset
	pop	{r4, lr}
	b	FtlGcBufInit
.L883:
	.align	2
.L882:
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
	ldr	r0, .L885
	bl	ftl_memset
	movs	r0, #0
	pop	{r3, pc}
.L886:
	.align	2
.L885:
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
	ldr	r1, .L889
	bl	ftl_memcpy
	movs	r0, #0
	pop	{r3, pc}
.L890:
	.align	2
.L889:
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
	ldr	r7, .L899
	ldr	r5, .L899+4
.L894:
	ldrb	r2, [r7, #-1]	@ zero_extendqisi2
	mov	r1, r5
	mov	r0, r7
	lsl	r8, r6, #5
	bl	FlashMemCmp8
	mov	r4, r0
	cbnz	r0, .L892
	ldr	r5, .L899+8
	mov	r3, r4
	ldr	r2, .L899+12
	add	r5, r5, r8
	ldrb	r0, [r5, #22]	@ zero_extendqisi2
	mov	r1, r2
.L893:
	lsls	r6, r3, #5
	ldrb	r6, [r6, r2]	@ zero_extendqisi2
	cmp	r6, r0
	beq	.L896
	adds	r3, r3, #1
	cmp	r3, #4
	bne	.L893
.L896:
	add	r1, r1, r3, lsl #5
	movs	r2, #32
	ldr	r0, .L899+16
	bl	ftl_memcpy
	movs	r2, #32
	mov	r1, r5
	ldr	r0, .L899+20
	bl	ftl_memcpy
	b	.L891
.L892:
	adds	r6, r6, #1
	adds	r7, r7, #32
	cmp	r6, #77
	bne	.L894
	mov	r4, #-1
.L891:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, pc}
.L900:
	.align	2
.L899:
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
.L902:
	cmp	r3, r2
	bne	.L903
	pop	{r4, pc}
.L903:
	ldr	r4, [r1, r3, lsl #2]
	str	r4, [r0, r3, lsl #2]
	adds	r3, r3, #1
	b	.L902
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
	bne	.L905
	cbz	r3, .L906
	lsls	r1, r3, #30
	bne	.L907
	mov	r2, #256
	mov	r1, r3
	bl	ftl_memcpy32
.L906:
	cbz	r5, .L904
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
.L907:
	mov	r2, #1024
	mov	r1, r3
	bl	ftl_memcpy
	b	.L906
.L905:
	cbz	r3, .L910
	lsls	r2, r3, #30
	bne	.L911
	mov	r1, r0
	mov	r2, #256
	mov	r0, r3
	bl	ftl_memcpy32
.L910:
	cbz	r5, .L904
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
.L904:
	pop	{r4, r5, r6, pc}
.L911:
	mov	r1, r0
	mov	r2, #1024
	mov	r0, r3
	bl	ftl_memcpy
	b	.L910
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
	ldr	r3, .L958
	sub	sp, sp, #96
	mov	r6, r0
	mov	r10, r2
	str	r1, [sp, #12]
	ldr	r5, [r3, r0, lsl #3]
	lsls	r3, r7, #26
	ldr	r4, [sp, #128]
	bne	.L923
	cbnz	r4, .L924
	add	r4, sp, #32
	movs	r2, #64
	movs	r1, #255
	add	r0, sp, #32
	bl	ftl_memset
.L924:
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
	bne	.L948
	ldr	r2, .L958+4
	lsr	r0, r10, #1
	ldr	ip, .L958+12
	ldr	r3, [r2]
	cmp	r3, #25
	ldr	r3, [sp, #12]
	ite	cc
	movcc	r7, #64
	movcs	r7, #128
	mov	r1, r3
.L927:
	cmp	r1, r0
	add	r4, r4, #4
	add	r6, r7, r3
	bcc	.L928
	ldr	r3, .L958+8
	lsr	r4, r10, #2
	ldr	r0, [r2]
	movs	r2, #0
	mov	r8, r2
	ldr	r1, [r3]
.L929:
	cmp	r2, r4
	bcs	.L925
	cbnz	r0, .L935
.L925:
	movs	r3, #0
	str	r3, [r5, #16]
.L936:
	ldr	r3, .L958+8
	ldr	r3, [r3]
	cmp	r3, #5
	bls	.L922
	ldr	r3, [sp, #12]
	cbnz	r3, .L922
	ldr	r3, [r5]
	and	r2, r3, #139264
	cmp	r2, #139264
	ittt	eq
	moveq	r8, #-1
	orreq	r3, r3, #131072
	streq	r3, [r5]
.L922:
	mov	r0, r8
	add	sp, sp, #96
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L928:
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
	b	.L927
.L935:
	add	r3, r2, #8
	ldr	r3, [r5, r3, lsl #2]
	str	r3, [sp, #28]
	ldr	r3, [sp, #28]
	lsls	r6, r3, #29
	bmi	.L951
	ldr	r3, [sp, #28]
	ubfx	r3, r3, #15, #1
	cmp	r3, #0
	bne	.L951
	cmp	r1, #5
	bls	.L931
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
.L957:
	orr	r3, r3, r6, lsl #5
.L933:
	cmp	r8, r3
	it	cc
	movcc	r8, r3
.L930:
	adds	r2, r2, #1
	b	.L929
.L931:
	cmp	r1, #3
	bls	.L933
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
	b	.L957
.L951:
	mov	r8, #-1
	b	.L930
.L948:
	mov	r8, #0
	b	.L925
.L923:
	ldr	r3, [sp, #12]
	cmp	r3, #1
	bne	.L937
	cmp	r4, #0
	mov	r8, #0
	ite	ne
	movne	r3, #4
	moveq	r3, #0
	str	r3, [sp, #16]
.L938:
	cmp	r8, r10
	bcc	.L940
	mov	r8, #0
	b	.L936
.L940:
	and	fp, r8, #3
	cbz	r7, .L953
	add	r3, r7, r8, lsl #9
.L939:
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
	b	.L938
.L953:
	mov	r3, r7
	b	.L939
.L937:
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
.L941:
	cmp	r4, r10
	bcs	.L936
	mov	r0, r6
	adds	r4, r4, #2
	bl	NandcXferComp
	ldr	r3, [r5, #32]
	cmp	r10, r4
	str	r3, [sp, #28]
	bls	.L942
	movs	r3, #0
	movs	r2, #2
	str	r3, [sp, #4]
	movs	r1, #0
	str	r3, [sp]
	mov	r0, r6
	and	r3, r4, #3
	bl	NandcXferStart
.L942:
	ldr	r3, [sp, #28]
	lsls	r3, r3, #29
	bmi	.L954
	ldr	r3, [sp, #28]
	ldr	r2, [sp, #28]
	ubfx	r3, r3, #3, #5
	ubfx	r2, r2, #27, #1
	orr	r3, r3, r2, lsl #5
	cmp	r8, r3
	it	cc
	movcc	r8, r3
.L943:
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
	b	.L941
.L954:
	mov	r8, #-1
	b	.L943
.L959:
	.align	2
.L958:
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
	ldr	r3, .L962
	mov	r6, r1
	mov	r7, r2
	mov	r4, r0
	ldrb	r5, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L961
	ldr	r3, .L962+4
	ldr	r2, .L962+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r0, [r2]
	muls	r0, r3, r0
	cmp	r0, r1
	it	hi
	movhi	r5, #4
.L961:
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
.L963:
	.align	2
.L962:
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
	ldr	r3, .L989
	sub	sp, sp, #24
	str	r0, [sp, #8]
	ldr	r3, [r3]
	str	r1, [sp, #12]
	str	r2, [sp, #4]
	ldr	r3, [r3, #304]
	str	r3, [sp, #20]
	ldr	r3, .L989+4
	ldr	r3, [r3]
	cmp	r3, #8
	ldr	r3, [sp, #56]
	ite	cc
	movcc	fp, #6
	movcs	fp, #12
	cmp	r3, #0
	beq	.L978
	movs	r0, #1
	ldr	r4, .L989+8
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
	bne	.L967
.L976:
	mov	r6, #-1
.L964:
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L967:
	mov	r2, r6
	ldr	r1, [sp, #12]
	ldr	r0, .L989+12
	bl	printf
	ldr	r2, .L989+16
	ldr	r3, [r2]
	adds	r3, r3, #1
	cmp	r3, #2048
	bcs	.L969
	str	r3, [r2]
	b	.L964
.L969:
	movs	r7, #0
	str	r7, [r2]
	str	r7, [sp, #4]
.L966:
	mov	r10, #0
	mov	r8, #-1
	mov	r5, r10
	mov	r4, r10
	str	r10, [sp, #16]
.L974:
	uxtb	r0, fp
	bl	NandcSetDdrPara
	mov	r3, r7
	ldr	r2, [sp, #4]
	ldr	r1, [sp, #12]
	ldr	r0, [sp, #8]
	bl	FlashReadRawPage
	adds	r3, r6, #1
	cmp	r0, r3
	bhi	.L970
	cmp	r0, #2
	bhi	.L980
	adds	r4, r4, #1
	cmp	r4, #9
	bls	.L980
	mov	r3, r5
	mov	r6, r0
	sub	r5, fp, r4
	mov	r8, #0
.L972:
	ldr	r2, [sp, #16]
	cmp	r4, r2
	it	ls
	movls	r5, r3
.L973:
	cbz	r5, .L975
	mov	r1, r5
	ldr	r0, .L989+20
	bl	printf
	uxtb	r0, r5
	bl	NandcSetDdrPara
.L975:
	cmp	r8, #0
	beq	.L964
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #8]
	ldr	r0, .L989+24
	bl	printf
	ldr	r3, [sp, #56]
	cmp	r3, #0
	beq	.L976
	ldr	r3, [sp, #20]
	ubfx	r0, r3, #8, #8
	bl	NandcSetDdrPara
	b	.L964
.L978:
	mov	r6, #1024
	b	.L966
.L970:
	ldr	r3, [sp, #16]
	cmp	r4, r3
	bls	.L981
	cmp	r4, #7
	sub	r5, r10, r4
	bhi	.L973
	str	r4, [sp, #16]
.L981:
	movs	r4, #0
	b	.L971
.L980:
	mov	r8, #0
	mov	r10, fp
	mov	r6, r0
	mov	r7, r8
	str	r8, [sp, #4]
.L971:
	add	fp, fp, #2
	cmp	fp, #69
	bls	.L974
	mov	r3, r5
	mov	r5, r10
	b	.L972
.L990:
	.align	2
.L989:
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
	bne	.L992
	ldr	r10, .L1010+20
	ldrb	fp, [r10]	@ zero_extendqisi2
	cmp	fp, #0
	bne	.L993
.L995:
	ldr	r3, .L1010
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L992
	ldr	r3, .L1010+4
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
	beq	.L996
	ldr	r3, .L1010+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3, lsr #1
	bls	.L992
.L996:
	ubfx	r0, r10, #8, #8
	bl	NandcSetDdrPara
	b	.L992
.L993:
	movs	r3, #0
	mov	r2, r7
	strb	r3, [r10]
	mov	r1, r6
	mov	r3, r8
	mov	r0, r5
	bl	FlashReadRawPage
	adds	r3, r0, #1
	strb	fp, [r10]
	beq	.L995
	mov	r4, r0
.L992:
	ldr	r10, .L1010+24
	ldr	fp, [r10]
	cmp	fp, #0
	beq	.L991
	adds	r2, r4, #1
	bne	.L991
	mov	r3, r8
	mov	r2, r7
	mov	r1, r6
	mov	r0, r5
	blx	fp
	mov	r3, r6
	mov	r4, r0
	mov	r1, r0
	mov	r2, r5
	ldr	r0, .L1010+12
	bl	printf
	adds	r3, r4, #1
	bne	.L991
	ldr	r3, .L1010+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L991
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
.L991:
	mov	r0, r4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1011:
	.align	2
.L1010:
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
	ldr	r4, .L1023
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
	ldr	r5, .L1023+4
	bl	FlashReadRawPage
	adds	r0, r0, #1
	beq	.L1013
	cmp	r8, #-1
	bne	.L1014
.L1013:
	ldrb	r3, [r4]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L1014
	movs	r0, #1
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	movs	r3, #0
.L1022:
	movs	r0, #0
	strb	r3, [r5]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1014:
	movs	r3, #1
	b	.L1022
.L1024:
	.align	2
.L1023:
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
	ldr	fp, .L1040+8
	movs	r4, #0
	movs	r7, #4
	strb	r3, [sp, #20]
	movs	r3, #40
	strb	r3, [sp, #21]
	movs	r3, #24
	strb	r3, [sp, #22]
	movs	r3, #16
	ldr	r1, .L1040
	mov	r0, r4
	strb	r3, [sp, #23]
	mov	r6, #-1
	ldrh	r3, [fp, #10]
	ldr	r8, .L1040+36
	ldr	r5, .L1040+4
	str	r3, [sp, #4]
	ldr	r3, [r1]
	str	r4, [r8]
	str	r3, [r5]
	bl	flash_enter_slc_mode
	mov	r10, r1
	str	r8, [sp, #12]
.L1026:
	mov	r8, #0
	adds	r3, r4, #1
	str	r3, [sp, #8]
.L1028:
	add	r3, sp, #20
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r3, #0
	ldr	r2, [r10]
	mov	r1, r4
	mov	r0, r3
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L1027
	movs	r3, #0
	ldr	r2, [r10]
	ldr	r1, [sp, #8]
	mov	r0, r3
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L1027
	add	r8, r8, #1
	cmp	r8, #4
	bne	.L1028
.L1029:
	ldr	r3, [sp, #4]
	subs	r7, r7, #1
	add	r4, r4, r3
	bne	.L1026
	mov	r0, r7
	b	.L1039
.L1030:
	movw	r1, #2036
	add	r0, r8, #12
	bl	JSHash
	ldr	r3, [r8, #8]
	cmp	r3, r0
	bne	.L1036
	movs	r2, #32
	add	r1, r8, #160
	ldr	r0, .L1040+8
	bl	ftl_memcpy
	ldr	r1, [r5]
	movs	r2, #32
	ldr	r0, .L1040+12
	adds	r1, r1, #192
	bl	ftl_memcpy
	ldr	r1, [r5]
	mov	r2, #852
	ldr	r0, .L1040+16
	adds	r1, r1, #224
	bl	ftl_memcpy
	ldr	r6, [r5]
	mov	r0, r4
	ldr	r3, .L1040+20
	ldrh	r1, [fp, #10]
	ldr	r2, [r6, #1076]
	strb	r2, [r3]
	ldr	r3, [sp, #12]
	str	r4, [r3]
	bl	__aeabi_uidiv
	ldr	r3, .L1040+24
	adds	r2, r0, #1
	cbz	r0, .L1032
.L1038:
	str	r2, [r3]
	ldrh	r2, [r6, #14]
	movs	r6, #0
	ldr	r3, .L1040+28
	strb	r2, [r3]
	b	.L1029
.L1032:
	movs	r2, #2
	b	.L1038
.L1036:
	mov	r6, #-1
	b	.L1029
.L1027:
	ldr	r8, [r5]
	ldr	r2, .L1040+32
	ldr	r3, [r8]
	cmp	r3, r2
	bne	.L1029
	cmp	r6, #0
	bne	.L1030
	ldrh	r1, [fp, #10]
	mov	r0, r4
	bl	__aeabi_uidiv
	ldr	r3, .L1040+24
	adds	r0, r0, #1
	str	r0, [r3]
	mov	r0, r6
.L1039:
	bl	flash_exit_slc_mode
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1041:
	.align	2
.L1040:
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
	ldr	r3, .L1069
	ldr	r2, .L1069+4
	ldr	r4, [r3, r6, lsl #3]
	add	r3, r3, r6, lsl #3
	str	r2, [sp, #16]
	ldrb	r7, [r3, #4]	@ zero_extendqisi2
	ldrb	r3, [r2]	@ zero_extendqisi2
	add	r5, r7, #8
	subs	r3, r3, #67
	add	r5, r4, r5, lsl #8
	cmp	r3, #1
	bls	.L1059
	ldr	r3, .L1069+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1060
	movs	r0, #0
	bl	NandcSetDdrMode
	movs	r3, #1
.L1060:
	str	r3, [sp, #8]
	add	r3, r4, r7, lsl #8
	movs	r2, #92
	str	r2, [r3, #2056]
	movs	r2, #197
	str	r2, [r3, #2056]
.L1043:
	mov	r8, #1
	mov	r3, #-1
	str	r3, [sp, #4]
.L1045:
	ldr	r3, .L1069+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r8, r3
	bcc	.L1054
	ldr	r10, [sp, #4]
.L1053:
	ldr	r3, [sp, #16]
	movs	r1, #0
	mov	r0, r5
	ldrb	r2, [r3]	@ zero_extendqisi2
	subs	r2, r2, #67
	cmp	r2, #1
	bhi	.L1055
	bl	SandiskSetRRPara
.L1056:
	add	r4, r4, r7, lsl #8
	movs	r2, #255
	str	r2, [r4, #2056]
	ldr	r2, .L1069+16
	ldrb	r2, [r2]	@ zero_extendqisi2
	add	r2, r2, r2, lsl #1
	cmp	r10, r2, asr #2
	bcc	.L1057
	cmp	r10, #-1
	it	ne
	movne	r10, #256
.L1057:
	mov	r0, r6
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #8]
	cbz	r3, .L1042
	movs	r0, #4
	bl	NandcSetDdrMode
.L1042:
	mov	r0, r10
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1059:
	movs	r3, #0
	str	r3, [sp, #8]
	b	.L1043
.L1054:
	ldr	r3, [sp, #16]
	mov	r0, r5
	uxtb	r1, r8
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L1046
	bl	SandiskSetRRPara
.L1047:
	ldr	r3, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L1048
	ldr	r3, .L1069+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #3
	cmp	r8, r3
	ittt	eq
	addeq	r3, r4, r7, lsl #8
	moveq	r2, #179
	streq	r2, [r3, #2056]
.L1048:
	add	r3, r4, r7, lsl #8
	movs	r2, #38
	str	r2, [r3, #2056]
	movs	r2, #93
	str	r2, [r3, #2056]
	ldr	r3, [sp, #8]
	cbz	r3, .L1049
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
.L1050:
	cmp	r10, #-1
	beq	.L1051
	ldr	r2, .L1069+16
	ldr	r3, [sp, #4]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r3, #-1
	it	eq
	moveq	r3, r10
	str	r3, [sp, #4]
	add	r2, r2, r2, lsl #1
	cmp	r10, r2, asr #2
	bcc	.L1053
	mov	fp, #0
	str	fp, [sp, #12]
.L1051:
	add	r8, r8, #1
	b	.L1045
.L1046:
	bl	ToshibaSetRRPara
	b	.L1047
.L1049:
	mov	r3, fp
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #20]
	mov	r0, r6
	bl	FlashReadRawPage
	mov	r10, r0
	b	.L1050
.L1055:
	bl	ToshibaSetRRPara
	b	.L1056
.L1070:
	.align	2
.L1069:
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
	ldr	r2, .L1084
	mov	r4, #-1
	add	r3, r2, r7, lsl #3
	ldrb	r5, [r3, #4]	@ zero_extendqisi2
	add	r3, r5, #8
	ldr	r5, [r2, r7, lsl #3]
	add	r5, r5, r3, lsl #8
.L1072:
	ldr	r3, .L1084+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r6, r3
	bcc	.L1076
.L1075:
	movs	r1, #0
	mov	r0, r5
	bl	SamsungSetRRPara
	ldr	r3, .L1084+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L1071
	adds	r3, r4, #1
	it	ne
	movne	r4, #256
.L1071:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1076:
	uxtb	r1, r6
	mov	r0, r5
	bl	SamsungSetRRPara
	mov	r2, r10
	mov	r3, r8
	mov	r1, fp
	mov	r0, r7
	bl	FlashReadRawPage
	adds	r2, r0, #1
	beq	.L1073
	ldr	r3, .L1084+8
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1079
	mov	r8, #0
	mov	r10, r8
.L1073:
	adds	r6, r6, #1
	b	.L1072
.L1079:
	mov	r4, r0
	b	.L1075
.L1085:
	.align	2
.L1084:
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
	ldr	r3, .L1111
	sub	sp, sp, #40
	mov	r5, r0
	str	r2, [sp, #16]
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, .L1111+4
	str	r1, [sp, #28]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1087
	add	r2, r2, r2, lsl #1
	asrs	r3, r2, #2
.L1110:
.L1088:
	mov	r8, #0
	str	r3, [sp, #12]
	mov	r6, r8
.L1098:
	mov	r0, r5
	mov	r10, #0
	bl	NandcWaitFlashReady
	ldr	r3, .L1111+8
	mov	r4, #-1
	ldr	r2, [r3, r5, lsl #3]
	add	r3, r3, r5, lsl #3
	ldrb	fp, [r3, #4]	@ zero_extendqisi2
	str	r2, [sp, #24]
	lsl	r3, fp, #8
	str	r3, [sp, #32]
.L1089:
	ldr	r3, .L1111+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r10, r3
	bcc	.L1093
.L1092:
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
	bcc	.L1094
	adds	r1, r4, #1
	mov	r3, r10
	it	ne
	movne	r4, #256
	ldr	r2, [sp, #28]
	str	r4, [sp]
	mov	r1, r10
	ldr	r0, .L1111+16
	bl	printf
	cmp	r8, #0
	bne	.L1096
	ldr	r3, .L1111+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1086
	adds	r2, r4, #1
	bne	.L1086
	movs	r1, #3
	mov	r0, r5
	bl	micron_auto_read_calibration_config
	mov	r8, #1
	b	.L1098
.L1087:
	ldr	r3, .L1111+20
	smull	r2, r3, r2, r3
	b	.L1110
.L1093:
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
	beq	.L1090
	ldr	r3, [sp, #12]
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	cmp	r0, r3
	bcc	.L1100
	movs	r7, #0
	str	r7, [sp, #16]
.L1090:
	ldr	r10, [sp, #20]
	b	.L1089
.L1100:
	movs	r7, #0
	mov	r4, r0
	str	r7, [sp, #16]
	b	.L1092
.L1096:
	movs	r1, #0
	mov	r0, r5
	bl	micron_auto_read_calibration_config
	adds	r3, r4, #1
	it	ne
	movne	r4, #256
.L1086:
	mov	r0, r4
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1094:
	cmp	r8, #0
	beq	.L1086
	movs	r1, #0
	mov	r0, r5
	bl	micron_auto_read_calibration_config
	mov	r4, #256
	b	.L1086
.L1112:
	.align	2
.L1111:
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
	ldr	r4, .L1130
	mov	r8, #0
	mov	r6, #-1
	mov	r10, r3
	mov	r7, r0
	str	r1, [sp, #4]
	ldrb	r2, [r4, #2]	@ zero_extendqisi2
	adds	r3, r4, r0
	ldrb	r5, [r3, #12]	@ zero_extendqisi2
	str	r2, [sp]
	ldr	r2, .L1130+4
	ldr	r2, [r2]
	ldrb	r2, [r2, #19]	@ zero_extendqisi2
	cmp	r2, #7
	it	eq
	ldrbeq	r5, [r3, #20]	@ zero_extendqisi2
	bl	NandcWaitFlashReady
.L1115:
	ldr	r3, [sp]
	cmp	r8, r3
	bcc	.L1120
.L1119:
	ldr	r3, .L1130+4
	add	r4, r4, r7
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cmp	r3, #7
	ldr	r3, .L1130+8
	ite	eq
	strbeq	r5, [r4, #20]
	strbne	r5, [r4, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r6, r3, asr #2
	bcc	.L1113
	adds	r3, r6, #1
	it	ne
	movne	r6, #256
.L1113:
	mov	r0, r6
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1120:
	ldr	r3, [sp]
	adds	r5, r5, #1
	uxtb	r5, r5
	ldr	r2, .L1130+12
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
	beq	.L1117
	ldr	r3, .L1130+8
	cmp	r6, #-1
	it	eq
	moveq	r6, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1124
	mov	r10, #0
	mov	fp, r10
.L1117:
	add	r8, r8, #1
	b	.L1115
.L1124:
	mov	r6, r0
	b	.L1119
.L1131:
	.align	2
.L1130:
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
	ldr	r3, .L1135
	mov	r5, r1
	mov	r7, r2
	mov	r4, r0
	ldrb	r6, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L1133
	ldr	r3, .L1135+4
	ldr	r2, .L1135+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r1, [r2]
	muls	r1, r3, r1
	cmp	r1, r5
	bls	.L1133
	ldr	r3, .L1135+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1134
	subs	r6, r6, #2
.L1133:
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
.L1134:
	movs	r6, #4
	b	.L1133
.L1136:
	.align	2
.L1135:
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
	ldr	r7, .L1146
	ldr	r4, .L1146+4
	ldr	r3, [r7]
	ldr	r10, .L1146+60
	ldr	r8, .L1146+64
	str	r3, [r4]
	ldr	r3, .L1146+8
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	FlashBchSel
	mov	r2, #2048
	movs	r1, #0
	ldr	r0, [r7]
	bl	ftl_memset
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r3, .L1146+12
	ldr	r1, .L1146+16
	str	r10, [r0]
	adds	r0, r0, #16
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r0, #-4]	@ movhi
	ldr	r3, .L1146+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r0, #-2]	@ movhi
	ldr	r3, .L1146+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r0, #1060]
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #8
	ldr	r1, .L1146+28
	adds	r0, r0, #80
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1146+32
	adds	r0, r0, #96
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1146+36
	adds	r0, r0, #160
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1146+40
	adds	r0, r0, #192
	bl	ftl_memcpy
	ldr	r0, [r4]
	mov	r2, #852
	ldr	r1, .L1146+44
	adds	r0, r0, #224
	bl	ftl_memcpy
	ldr	r5, [r4]
	movw	r1, #2036
	add	r0, r5, #12
	bl	JSHash
	ldr	r1, .L1146+48
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
.L1140:
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
	beq	.L1138
	ldr	r3, [r4]
	ldr	r1, [r3]
	cmp	r1, r10
	bne	.L1138
	add	r0, r3, #12
	movw	r1, #2036
	str	r2, [sp, #4]
	str	r3, [sp]
	bl	JSHash
	ldr	r3, [sp]
	ldr	r2, [sp, #4]
	ldr	r3, [r3, #8]
	cmp	r3, r0
	bne	.L1138
	ldr	r3, .L1146+52
	cmp	r5, #1
	str	r2, [r3]
	ldr	r3, [r8]
	mul	r6, r6, r3
	ldr	r3, .L1146+56
	str	r6, [r3]
	beq	.L1141
	movs	r5, #1
.L1138:
	cmp	r2, #4
	mov	r6, r2
	bne	.L1140
.L1139:
	movs	r0, #0
	bl	flash_exit_slc_mode
	clz	r0, r5
	lsrs	r0, r0, #5
	negs	r0, r0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1141:
	movs	r5, #2
	b	.L1139
.L1147:
	.align	2
.L1146:
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
	ldr	r2, .L1160
	mov	r10, r0
	strb	r3, [sp, #20]
	movs	r3, #40
	strb	r3, [sp, #21]
	movs	r3, #24
	strb	r3, [sp, #22]
	movs	r3, #16
	strb	r3, [sp, #23]
	ldr	r3, .L1160+4
	ldr	r1, [r2]
	str	r2, [sp, #8]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #4]
	ldr	r3, .L1160+8
	cmp	r1, r3
	str	r3, [sp, #12]
	bne	.L1149
	movs	r0, #0
	bl	flash_enter_slc_mode
.L1149:
	mov	r7, #-1
	movs	r4, #2
	mov	r2, #2048
	movs	r1, #0
	mov	r0, r10
	bl	ftl_memset
.L1150:
	ldr	r3, .L1160+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L1155
.L1154:
	ldr	r0, [sp, #4]
	bl	FlashBchSel
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L1148
	movs	r0, #0
	bl	flash_exit_slc_mode
.L1148:
	mov	r0, r7
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1155:
	ldr	r5, .L1160+16
	movs	r6, #0
	ldr	fp, .L1160+32
.L1152:
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
	bne	.L1151
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L1152
.L1153:
	adds	r4, r4, #1
	b	.L1150
.L1158:
	movs	r7, #0
	b	.L1154
.L1151:
	ldr	r3, [r5]
	ldr	r2, [r3]
	ldr	r3, .L1160+20
	cmp	r2, r3
	bne	.L1153
	mov	r1, r8
	ldr	r0, .L1160+24
	bl	printf
	mov	r2, #2048
	ldr	r1, [r5]
	mov	r0, r10
	bl	ftl_memcpy
	ldr	r3, [r5]
	ldr	r2, .L1160+12
	ldr	r3, [r3, #512]
	strb	r3, [r2]
	ldr	r3, .L1160+28
	ldr	r2, [r3]
	cmp	r4, r2
	bcs	.L1158
	str	r4, [r3]
	movs	r7, #0
	bl	FlashSavePhyInfo
	b	.L1153
.L1161:
	.align	2
.L1160:
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
	ldr	r5, .L1172
	mov	r6, r0
	mov	r7, r1
	ldr	r3, [r5]
	ldrb	r2, [r3, #19]	@ zero_extendqisi2
	ldr	r3, .L1172+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1163
	ldr	r3, .L1172+8
	ldr	r1, [r3]
	ldr	r3, .L1172+12
	cmp	r1, r3
	beq	.L1162
.L1163:
	subs	r3, r2, #5
	uxtb	r3, r3
	cmp	r3, #30
	bhi	.L1164
	ldr	r2, .L1172+16
	lsr	r3, r2, r3
	lsls	r3, r3, #31
	bmi	.L1166
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1167:
	ldrh	r2, [r10, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1162
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
.L1168:
	ldr	r3, [r5]
	ldrh	r3, [r3, #10]
	cmp	r3, r4
	bhi	.L1167
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1164:
	cmp	r2, #68
	bne	.L1162
.L1166:
	ldr	r10, .L1172+20
	ldr	r8, .L1172+24
	b	.L1168
.L1162:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1173:
	.align	2
.L1172:
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
	bls	.L1175
	cmp	r0, #576
	bcs	.L1176
	ldr	r2, .L1227
	cmp	r0, #64
	mov	r4, #1
	str	r4, [r2]
	bhi	.L1177
	rsb	r0, r0, #64
	subs	r2, r3, r0
	add	r1, r1, r0, lsl #9
	ldr	r0, .L1227+4
	lsls	r2, r2, #9
.L1226:
	bl	ftl_memcpy
.L1215:
	movs	r0, #0
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1177:
	rsb	r2, r0, #576
	subs	r0, r0, #64
	cmp	r2, r3
	it	cs
	movcs	r2, r3
	ldr	r3, .L1227+4
	lsls	r2, r2, #9
	add	r0, r3, r0, lsl #9
	b	.L1226
.L1175:
	cmp	r0, #576
	bcc	.L1215
.L1176:
	ldr	r3, .L1227
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L1215
	ldr	r3, .L1227+8
	ldr	r2, [r3]
	ldrb	r3, [r2, #9]	@ zero_extendqisi2
	ldrh	r2, [r2, #10]
	smulbb	r3, r3, r2
	uxth	r3, r3
	mov	r1, r3
	addw	r0, r3, #511
	str	r3, [sp, #8]
	bl	__aeabi_uidiv
	ldr	r1, .L1227+4
	movs	r3, #0
	str	r0, [sp, #20]
	movw	r2, #65535
	mov	r0, r1
.L1181:
	ldr	r4, [r1, r2, lsl #2]
	cbnz	r4, .L1179
	ldr	r4, [r1, r3, lsl #2]
	adds	r3, r3, #1
	cmp	r3, #4096
	it	hi
	movhi	r3, #0
	str	r4, [r1, r2, lsl #2]
	subs	r2, r2, #1
	cmp	r2, #4096
	bne	.L1181
.L1179:
	ldr	r1, [r0, r2, lsl #2]
	mov	r3, #512
	ldr	r0, .L1227+12
	bl	printf
	ldr	r3, .L1227+16
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
.L1182:
	ldr	r3, [sp, #16]
	cmp	r3, #15
	bls	.L1199
	ldr	r3, [sp, #12]
	cbnz	r3, .L1201
	mov	r1, r3
	ldr	r0, .L1227+20
	bl	printf
.L1201:
	ldr	r3, .L1227
	movs	r2, #0
	str	r2, [r3]
	b	.L1215
.L1228:
	.align	2
.L1227:
	.word	.LANCHOR154
	.word	idb_buf
	.word	.LANCHOR18
	.word	.LC15
	.word	.LANCHOR149
	.word	.LC17
.L1199:
	mov	r2, #512
	movs	r1, #0
	ldr	r0, .L1229
	bl	memset
	ldr	r3, .L1229+4
	mov	r0, r4
	ldr	r3, [r3]
	ldrb	fp, [r3, #9]	@ zero_extendqisi2
	ldrh	r5, [r3, #10]
	bl	FW_FlashBlockErase.constprop.41
	smulbb	r5, r5, fp
	uxth	r5, r5
	cmp	r5, #512
	bcs	.L1183
	adds	r0, r5, r4
	bl	FW_FlashBlockErase.constprop.41
.L1183:
	ldr	r7, .L1229+8
	mov	r1, r5
	ldr	r10, .L1229+36
	mov	r0, r4
	bl	__aeabi_uidivmod
	mov	r6, r1
	subs	r3, r4, r1
	str	r3, [sp, #24]
.L1187:
	lsrs	r2, r6, #2
	beq	.L1184
	ldr	r0, .L1229+12
	adds	r1, r2, #1
	ldr	r3, .L1229+16
	ldrb	r0, [r0]	@ zero_extendqisi2
	ldrh	r3, [r3, r1, lsl #1]
	cbz	r0, .L1185
	ldr	r0, [r10]
	ldr	r5, .L1229+20
	cmp	r0, r5
	it	eq
	moveq	r3, r1
.L1185:
	add	r3, r3, #1073741824
	subs	r3, r3, #1
	lsls	r3, r3, #2
	str	r3, [sp, #40]
.L1184:
	movw	r3, #61424
	str	r3, [sp, #44]
	ldr	r3, .L1229+16
	ldrh	r5, [r3, r2, lsl #1]
	ldr	r3, .L1229+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1186
	ldr	r3, [r10]
	ldr	r1, .L1229+20
	cmp	r3, r1
	it	eq
	moveq	r5, r2
.L1186:
	ldr	r3, [sp, #24]
	adds	r6, r6, #4
	ldr	r2, .L1229+24
	ldr	r8, .L1229+4
	mla	r3, r5, fp, r3
	adds	r5, r5, #1
	uxth	r5, r5
	str	r3, [sp, #32]
	ldrb	r3, [r2]	@ zero_extendqisi2
	ldr	r2, .L1229+28
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
	ldr	r3, .L1229+32
	cmp	r7, r3
	bne	.L1187
	ldr	r3, [r8]
	mov	r0, r4
	ldr	r7, .L1229
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
.L1188:
	cmp	r6, #512
	bcs	.L1195
	ldr	r1, .L1229+12
	rsb	r3, r5, #4
	uxth	r3, r3
	ldr	r2, .L1229+16
	ldrb	r1, [r1]	@ zero_extendqisi2
	str	r3, [sp, #24]
	add	r3, r10, r6
	lsrs	r3, r3, #2
	ldrh	r2, [r2, r3, lsl #1]
	cbz	r1, .L1189
	ldr	r1, .L1229+36
	ldr	r0, .L1229+20
	ldr	r1, [r1]
	cmp	r1, r0
	it	eq
	moveq	r2, r3
.L1189:
	ldr	r3, [sp, #28]
	add	r5, r5, r3
	ldr	r3, .L1229+24
	mla	r5, r2, r8, r5
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #32]
	ldr	r3, .L1229+4
	ldr	r3, [r3]
	ldrb	fp, [r3, #9]	@ zero_extendqisi2
	ldr	r3, .L1229+40
	ldrh	r2, [r3, #26]
	ldr	r3, .L1229+44
	ldr	r3, [r3]
	muls	r3, r2, r3
	mul	r3, fp, r3
	cmp	r5, r3
	bcs	.L1190
	ldr	r3, .L1229+28
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	FlashBchSel
.L1190:
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
	bne	.L1191
	ldr	r3, .L1229+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #40
	beq	.L1191
	movs	r0, #40
	bl	FlashBchSel
	add	r3, sp, #40
	mov	r2, r7
	mov	r1, fp
	movs	r0, #0
	bl	FlashReadPage
	mov	r5, r0
.L1191:
	movs	r0, #0
	bl	flash_boot_exit_slc_mode
	ldr	r0, [sp, #32]
	bl	FlashBchSel
	adds	r5, r5, #1
	mov	r5, #-1
	it	ne
	movne	r5, #0
	cbz	r5, .L1192
.L1195:
	ldr	r3, .L1229+8
	movs	r5, #0
	ldr	r6, .L1229
.L1193:
	mov	r7, r3
	ldr	r1, [r6, r5, lsl #2]
	ldr	r2, [r7]
	adds	r3, r3, #4
	cmp	r1, r2
	beq	.L1196
	mov	r2, #512
	movs	r1, #0
	ldr	r0, .L1229
	bl	memset
	str	r5, [sp]
	mov	r1, r4
	ldr	r3, [r7]
	ldr	r2, [r6, r5, lsl #2]
	ldr	r0, .L1229+48
	bl	printf
	mov	r0, r4
	bl	FW_FlashBlockErase.constprop.41
	ldr	r3, [sp, #20]
	cmp	r3, #1
	bls	.L1197
	ldr	r3, [sp, #8]
	adds	r0, r3, r4
	bl	FW_FlashBlockErase.constprop.41
.L1197:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #20]
	add	r3, r3, r2
	str	r3, [sp, #16]
	ldr	r3, [sp, #36]
	add	r4, r4, r3
	b	.L1182
.L1192:
	ldr	r3, [sp, #24]
	add	r6, r6, r3
	add	r7, r7, r3, lsl #9
	uxth	r6, r6
	b	.L1188
.L1196:
	adds	r5, r5, #1
	cmp	r5, #65536
	bne	.L1193
	ldr	r3, [sp, #12]
	adds	r3, r3, #1
	cmp	r3, #5
	str	r3, [sp, #12]
	bls	.L1197
	b	.L1201
.L1230:
	.align	2
.L1229:
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
	ldr	r0, .L1233
	bx	lr
.L1234:
	.align	2
.L1233:
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
	ldr	r3, .L1238
	movs	r4, #0
	ldr	r5, .L1238+4
	str	r2, [r3, #12]
	movs	r2, #2
	str	r2, [r3, #20]
	movs	r2, #3
	stm	r3, {r0, r4}
	str	r0, [r3, #8]
	str	r0, [r3, #16]
	str	r2, [r3, #28]
	str	r0, [r3, #24]
	ldr	r3, .L1238+8
	ldr	r2, .L1238+12
	str	r0, [r3]
	ldr	r3, [r0]
	and	r3, r3, #253952
	ubfx	r1, r3, #13, #1
	bfi	r3, r4, #13, #1
	str	r1, [r2]
	orr	r3, r3, #256
	ldr	r2, [r0, #352]
	ldr	r1, .L1238+16
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
	ldr	r3, .L1238+20
	str	r3, [r0, #304]
	mov	r0, #36864
	bl	ftl_malloc
	ldr	r3, .L1238+24
	str	r0, [r3]
	ldr	r3, .L1238+28
	str	r0, [r3]
	add	r0, r0, #32768
	str	r0, [r3, #4]
	str	r4, [r3, #24]
	ldr	r3, .L1238+32
	str	r4, [r3]
	pop	{r3, r4, r5, pc}
.L1239:
	.align	2
.L1238:
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
	ldr	r3, .L1245
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r2, .L1245+4
	movs	r6, #12
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1245+8
	ldr	r5, .L1245+12
	ldr	r10, .L1245+304
	str	r4, [r3]
	ldr	r3, .L1245+16
	ldr	r8, .L1245+308
	ldr	fp, .L1245+312
	str	r4, [r3]
	ldr	r3, .L1245+20
	str	r4, [r3]
	ldr	r3, .L1245+24
	str	r4, [r3]
	ldr	r3, .L1245+28
	str	r4, [r3]
	ldr	r3, .L1245+32
	str	r4, [r3]
	ldr	r3, .L1245+36
	str	r4, [r3]
	ldr	r3, .L1245+40
	str	r4, [r3]
	ldr	r3, .L1245+44
	str	r4, [r3]
	ldr	r3, .L1245+48
	str	r4, [r3]
	ldr	r3, .L1245+52
	str	r4, [r3]
	ldr	r3, .L1245+56
	str	r4, [r3]
	ldr	r3, .L1245+60
	str	r4, [r3]
	ldr	r3, .L1245+64
	str	r4, [r3]
	ldr	r3, .L1245+68
	str	r4, [r3]
	ldr	r3, .L1245+72
	str	r4, [r3]
	ldr	r3, .L1245+76
	str	r4, [r3]
	movw	r3, #65535
	str	r3, [r2]
	ldr	r2, .L1245+80
	str	r4, [r2]
	ldr	r2, .L1245+84
	str	r4, [r2]
	ldr	r2, .L1245+88
	str	r4, [r2]
	ldr	r2, .L1245+92
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1245+96
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1245+100
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1245+104
	strh	r3, [r2]	@ movhi
	movs	r2, #32
	ldr	r3, .L1245+108
	strh	r2, [r3]	@ movhi
	movs	r2, #128
	ldr	r3, .L1245+112
	strh	r2, [r3]	@ movhi
	ldr	r3, .L1245+116
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1245+120
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1245+124
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1245+128
	strh	r4, [r3]	@ movhi
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1245+132
	str	r0, [r3]
	ldrh	r0, [r5]
	movs	r5, #36
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L1245+136
	str	r0, [r3]
	ldrh	r3, [r10]
	muls	r5, r3, r5
	lsls	r7, r5, #2
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L1245+140
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1245+144
	str	r0, [r3]
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L1245+148
	ldr	r7, .L1245+152
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1245+156
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1245+160
	ldrh	r5, [r7]
	str	r0, [r3]
	ldrh	r3, [r10]
	mov	r0, r5
	lsls	r3, r3, #1
	adds	r3, r3, #1
	str	r3, [r8]
	bl	ftl_malloc
	ldr	r3, .L1245+164
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1245+168
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1245+172
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L1245+176
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1245+180
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1245+184
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L1245+188
	ldrh	r5, [r10]
	ldr	r10, .L1245+316
	str	r0, [r3]
	ldrh	r3, [fp]
	muls	r5, r3, r5
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1245+192
	str	r0, [r3]
	lsls	r0, r5, #2
	ldr	r5, .L1245+196
	bl	ftl_malloc
	ldr	r3, .L1245+200
	str	r0, [r3]
	ldrh	r3, [fp]
	ldr	r0, [r8]
	ldr	r8, .L1245+320
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1245+204
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L1245+208
	str	r0, [r3]
	ldrh	r3, [r8]
	ldr	r0, .L1245+212
	addw	r3, r3, #547
	lsrs	r3, r3, #9
	and	r0, r0, r3, lsl #9
	strh	r3, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L1245+216
	str	r0, [r3]
	adds	r0, r0, #32
	ldr	r3, .L1245+220
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1245+224
	str	r0, [r3]
	ldr	r3, [r10]
	lsl	r8, r3, #1
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L1245+228
	str	r0, [r3]
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L1245+232
	ldr	r8, .L1245+324
	str	r0, [r3]
	ldrh	r0, [r5]
	lsrs	r0, r0, #3
	adds	r0, r0, #4
	bl	ftl_malloc
	ldr	r3, .L1245+236
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1245+240
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1245+244
	str	r0, [r3]
	ldrh	r0, [r8]
	ldr	r8, .L1245+328
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1245+248
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldrh	r2, [r8]
	mov	r1, r4
	ldr	r3, .L1245+252
	lsls	r2, r2, #2
	str	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L1245+256
	ldrh	r4, [r3]
	lsls	r4, r4, #2
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L1245+260
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L1245+264
	ldr	r4, .L1245+268
	str	r0, [r3]
	ldr	r0, [r10]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1245+272
	str	r0, [r3]
	ldrh	r0, [r4]
	muls	r0, r6, r0
	ldr	r6, .L1245+276
	bl	ftl_malloc
	ldr	r3, .L1245+280
	str	r0, [r3]
	ldrh	r3, [r4]
	ldrh	r0, [r7]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1245+284
	str	r0, [r3]
	movs	r0, #6
	ldrh	r3, [r5]
	ldr	r5, .L1245+288
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1245+292
	str	r0, [r3]
	ldr	r3, .L1245+296
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
	ldr	r3, .L1245+300
	ldrh	r6, [r6]
	lsls	r1, r1, #2
	mov	r4, r3
	str	r0, [r4, #28]!
	b	.L1246
.L1247:
	.align	2
.L1245:
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
.L1246:
	mov	r0, r1
.L1241:
	cmp	r2, r6
	bcc	.L1242
	add	r3, r3, r2, lsl #2
	ldr	r2, .L1248
	movs	r1, #0
	adds	r3, r3, #24
.L1243:
	cmp	r3, r2
	bne	.L1244
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1242:
	ldr	r5, [r3, #28]
	adds	r2, r2, #1
	add	r5, r5, r0
	add	r0, r0, r1
	str	r5, [r4, #4]!
	b	.L1241
.L1244:
	str	r1, [r3, #4]!
	b	.L1243
.L1249:
	.align	2
.L1248:
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
	ldr	r3, .L1256
	ldr	r0, [r3]
	bx	lr
.L1257:
	.align	2
.L1256:
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
	ldr	r7, .L1267
	mov	fp, r0
	mov	r6, r1
	mov	r8, r2
	mov	r10, r3
	mov	r4, r5
.L1259:
	cmp	r4, r10
	bne	.L1265
	ldr	r1, .L1267+4
	ldr	r0, .L1267+8
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L1265:
	cbnz	r5, .L1260
	mov	r2, r4
	mov	r1, fp
	ldr	r0, .L1267+12
	bl	printf
.L1260:
	cmp	r8, #4
	bne	.L1261
	ldr	r1, [r6, r4, lsl #2]
.L1266:
	mov	r0, r7
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L1264
	movs	r5, #0
	ldr	r1, .L1267+4
	ldr	r0, .L1267+8
	bl	printf
.L1264:
	adds	r4, r4, #1
	b	.L1259
.L1261:
	cmp	r8, #2
	ite	eq
	ldrsheq	r1, [r6, r4, lsl #1]
	ldrbne	r1, [r6, r4]	@ zero_extendqisi2
	b	.L1266
.L1268:
	.align	2
.L1267:
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
	ldr	r5, .L1368
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
	bne	.L1270
	movs	r3, #167
	movs	r2, #247
	strb	r3, [r5, #4]
	ldr	r3, .L1368+4
	strb	r2, [r3, #17]
.L1326:
	mov	r10, #7
	b	.L1362
.L1270:
	cmp	r0, #3
	bne	.L1272
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
.L1363:
	mov	r10, #8
	strb	r3, [r5, #11]
	mov	fp, r10
.L1271:
	subs	r3, r4, #1
	cmp	r3, #1
	bhi	.L1276
	mov	r8, #0
.L1277:
	ldr	r3, .L1368+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxtb	r3, r8
	cmp	r2, r3
	bhi	.L1283
.L1284:
	ldr	r3, .L1368
	strb	fp, [r3, #1]
	strb	r10, [r3, #2]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1272:
	cmp	r0, #4
	bne	.L1273
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
	b	.L1363
.L1273:
	cmp	r0, #5
	bne	.L1274
	movs	r3, #56
	mov	r10, #8
	strb	r3, [r5, #4]
	movs	r3, #57
	strb	r3, [r5, #5]
	movs	r3, #58
	strb	r3, [r5, #6]
	movs	r3, #59
	strb	r3, [r5, #7]
.L1362:
	mov	fp, #4
	b	.L1271
.L1274:
	cmp	r0, #6
	bne	.L1275
	movs	r3, #14
	mov	r10, #12
	strb	r3, [r5, #4]
	movs	r3, #15
	strb	r3, [r5, #5]
	movs	r3, #16
	strb	r3, [r5, #6]
	movs	r3, #17
	strb	r3, [r5, #7]
	b	.L1362
.L1275:
	cmp	r0, #7
	bne	.L1326
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
	b	.L1271
.L1283:
	ldr	r2, .L1368+12
	movs	r6, #0
	ldrb	r2, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1368+16
	ldr	r7, [r3, r2, lsl #3]
	add	r4, r5, r2, lsl #6
	add	r3, r3, r2, lsl #3
	movs	r2, #55
	adds	r4, r4, #20
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r7, r7, r3, lsl #8
	addw	r3, r7, #2056
.L1278:
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
	bhi	.L1278
	ldr	r7, .L1368+4
	mov	r1, r4
	movs	r2, #0
.L1281:
	movs	r3, #1
	adds	r6, r7, r2
.L1280:
	ldrb	r0, [r6, r3, lsl #2]	@ zero_extendqisi2
	ldrb	ip, [r1]	@ zero_extendqisi2
	add	r0, r0, ip
	strb	r0, [r1, r3, lsl #3]
	adds	r3, r3, #1
	cmp	r3, #7
	bne	.L1280
	adds	r2, r2, #1
	adds	r1, r1, #1
	cmp	r2, #4
	bne	.L1281
	movs	r3, #0
	add	r8, r8, #1
	strb	r3, [r4, #16]
	strb	r3, [r4, #24]
	strb	r3, [r4, #32]
	strb	r3, [r4, #40]
	strb	r3, [r4, #48]
	strb	r3, [r4, #41]
	strb	r3, [r4, #49]
	b	.L1277
.L1276:
	subs	r3, r4, #3
	cmp	r3, #4
	bhi	.L1284
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
.L1367:
	str	r3, [sp, #28]
	ldrb	r3, [sp, #28]	@ zero_extendqisi2
	str	r3, [sp, #16]
	ldr	r3, .L1368+8
	ldr	r2, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L1284
	ldr	r2, [sp, #16]
	ldr	r3, .L1368+12
	ldrb	r8, [r3, r2]	@ zero_extendqisi2
	ldr	r3, .L1368+16
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
	ldr	r1, .L1368
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
	bne	.L1288
	movs	r2, #255
	str	r2, [r3, #2052]
	movs	r2, #64
	str	r2, [r3, #2048]
	movs	r2, #204
.L1365:
	str	r2, [r3, #2052]
	movs	r2, #77
	b	.L1366
.L1288:
	subs	r2, r4, #5
	cmp	r2, #1
	bhi	.L1290
	ldr	r2, .L1368
	ldrb	r2, [r2, #4]	@ zero_extendqisi2
	str	r2, [r3, #2052]
	movs	r2, #82
.L1366:
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
	bls	.L1327
	cmp	r4, #7
	ite	eq
	moveq	r2, #32
	movne	r2, #2
.L1293:
	ldr	r3, .L1368+20
	subs	r2, r2, #1
	ldr	r3, [r3]
	subs	r1, r3, #1
	uxtab	r2, r3, r2
	mov	r0, r1
.L1294:
	ldr	r6, [r5, #2048]
	strb	r6, [r0, #1]!
	cmp	r2, r0
	bne	.L1294
	cmp	r4, #7
	bne	.L1295
	movs	r2, #0
.L1297:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #12
	beq	.L1296
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #10
	beq	.L1296
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1297
.L1298:
	movs	r1, #0
	ldr	r0, .L1368+24
	bl	printf
.L1300:
	b	.L1300
.L1290:
	movs	r2, #174
	str	r2, [r3, #2052]
	movs	r2, #0
	str	r2, [r3, #2048]
	movs	r2, #176
	b	.L1365
.L1327:
	movs	r2, #16
	b	.L1293
.L1369:
	.align	2
.L1368:
	.word	.LANCHOR20
	.word	.LANCHOR196
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR6
	.word	.LANCHOR147
	.word	.LC21
.L1296:
	cmp	r1, #6
	bhi	.L1298
.L1299:
	ldr	r3, .L1370
	ldr	lr, [r3]
	mov	r3, lr
.L1304:
	ldr	r1, [sp, #52]
	sub	r2, r3, lr
	cmp	r1, r2
	bgt	.L1305
	ldr	r3, .L1370
	ldr	r1, [r3]
	ldr	r3, [sp, #32]
	adds	r0, r1, r3
	movs	r3, #8
.L1307:
	mov	r7, r0
	movs	r6, #0
.L1306:
	ldr	r2, [r7]
	adds	r6, r6, #1
	mvns	r2, r2
	str	r2, [r7], #4
	ldr	r2, [sp, #12]
	cmp	r2, r6
	bgt	.L1306
	ldr	r2, [sp, #48]
	subs	r3, r3, #1
	add	r0, r0, r2
	bne	.L1307
	str	r1, [sp, #20]
	str	r3, [sp, #24]
.L1313:
	movs	r0, #0
	mov	r2, r0
.L1312:
	movs	r3, #1
	mov	ip, #0
	lsl	r7, r3, r2
	movs	r3, #16
	str	r3, [sp, #44]
	mov	r6, r7
	ldr	r7, [sp, #20]
.L1310:
	ldr	r3, [r7]
	bics	r3, r6, r3
	ldr	r3, [sp, #32]
	it	eq
	addeq	ip, ip, #1
	add	r7, r7, r3
	ldr	r3, [sp, #44]
	subs	r3, r3, #1
	str	r3, [sp, #44]
	bne	.L1310
	cmp	ip, #8
	add	r2, r2, #1
	itt	hi
	movhi	r3, r6
	orrhi	r0, r0, r3
	cmp	r2, #32
	bne	.L1312
	ldr	r3, [sp, #20]
	str	r0, [r3], #4
	str	r3, [sp, #20]
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	str	r3, [sp, #24]
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #12]
	cmp	r3, r2
	bgt	.L1313
	subs	r2, r1, #4
	add	r0, r1, #28
	movs	r3, #0
.L1316:
	ldr	r6, [r2, #4]!
	cbnz	r6, .L1315
	adds	r3, r3, #1
.L1315:
	cmp	r0, r2
	bne	.L1316
	cmp	r3, #7
	ble	.L1317
	ldr	r0, .L1370+4
	mov	r3, #1024
	movs	r2, #1
	bl	rknand_print_hex
	movs	r1, #0
	ldr	r0, .L1370+8
	bl	printf
.L1318:
	b	.L1318
.L1295:
	cmp	r4, #6
	bne	.L1299
	adds	r3, r3, #7
.L1301:
	ldrb	r2, [r1, #1]!	@ zero_extendqisi2
	cmp	r2, #12
	beq	.L1299
	ldrb	r2, [r1, #8]	@ zero_extendqisi2
	cmp	r2, #4
	beq	.L1299
	cmp	r3, r1
	bne	.L1301
	movs	r1, #0
	ldr	r0, .L1370+8
	bl	printf
.L1303:
	b	.L1303
.L1305:
	ldr	r2, [r5, #2048]
	strb	r2, [r3], #1
	b	.L1304
.L1317:
	cmp	r4, #6
	beq	.L1329
	cmp	r4, #7
	ite	eq
	moveq	ip, #10
	movne	ip, #8
.L1319:
	add	r3, fp, #-1
	ldr	r1, [sp, #36]
	uxtb	r3, r3
	movs	r0, #0
	adds	r3, r3, #1
.L1320:
	mov	r7, r1
	mov	r2, lr
.L1321:
	ldrb	r6, [r2], #1	@ zero_extendqisi2
	strb	r6, [r7], #1
	sub	r6, r2, lr
	uxtb	r6, r6
	cmp	fp, r6
	bhi	.L1321
	adds	r0, r0, #1
	add	lr, lr, r3
	cmp	r10, r0
	add	r1, r1, ip
	bgt	.L1320
	ldr	r3, [sp, #4]
	mov	r0, r8
	ldr	r2, [sp, #8]
	add	r6, r3, r2, lsl #8
	movs	r3, #255
	str	r3, [r6, #2056]
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #40]
	cmp	r3, #1
	bhi	.L1323
	movs	r3, #54
	mov	r1, #-1
	str	r3, [r6, #2056]
	ldr	r3, .L1370+12
	ldr	r0, [sp, #16]
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	str	r3, [r5, #2052]
	movs	r3, #0
	str	r3, [r5, #2048]
	movs	r3, #22
	str	r3, [r6, #2056]
	bl	FlashReadCmd
.L1324:
	mov	r0, r8
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	b	.L1367
.L1329:
	mov	ip, #4
	b	.L1319
.L1323:
	movs	r3, #56
	str	r3, [r6, #2056]
	b	.L1324
.L1371:
	.align	2
.L1370:
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
	cbz	r0, .L1372
	subs	r2, r0, #1
	cmp	r2, #6
	bhi	.L1374
	b	HynixGetReadRetryDefault
.L1374:
	cmp	r0, #49
	bne	.L1375
	ldr	r0, .L1395
	movs	r2, #64
	ldr	r1, .L1395+4
	strb	r3, [r0]
	movs	r3, #4
	strb	r3, [r0, #1]
	movs	r3, #15
	strb	r3, [r0, #2]
.L1393:
	adds	r0, r0, #4
	b	ftl_memcpy
.L1375:
	cmp	r0, #33
	beq	.L1376
	sub	r2, r0, #65
	cmp	r2, #1
	bhi	.L1377
.L1376:
	ldr	r0, .L1395
	strb	r3, [r0]
	movs	r3, #4
.L1394:
	strb	r3, [r0, #1]
	movs	r3, #7
	strb	r3, [r0, #2]
	movs	r2, #45
	ldr	r1, .L1395+8
	b	.L1393
.L1377:
	cmp	r0, #34
	beq	.L1378
	cmp	r0, #67
	bne	.L1379
.L1378:
	ldr	r0, .L1395
	strb	r3, [r0]
	movs	r3, #5
	b	.L1394
.L1379:
	cmp	r0, #35
	beq	.L1380
	cmp	r0, #68
	bne	.L1372
.L1380:
	ldr	r0, .L1395
	movs	r2, #95
	ldr	r1, .L1395+12
	strb	r3, [r0]
	movs	r3, #5
	strb	r3, [r0, #1]
	movs	r3, #17
	strb	r3, [r0, #2]
	b	.L1393
.L1372:
	bx	lr
.L1396:
	.align	2
.L1395:
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
	ldr	r3, .L1490
	ldr	r10, .L1490+132
	ldr	r8, .L1490+136
	str	r0, [r3]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L1490+4
	ldr	r6, .L1490+8
	ldr	r7, .L1490+12
	str	r0, [r3]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L1490+16
	str	r0, [r3]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L1490+20
	str	r0, [r3]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L1490+24
	ldr	r2, .L1490+28
	strb	r5, [r8]
	str	r0, [r3]
	movs	r3, #50
	strb	r3, [r10]
	mov	r0, r4
	strb	r3, [r2]
	movs	r2, #128
	ldr	r3, .L1490+32
	ldr	r4, .L1490+36
	strb	r5, [r7]
	str	r5, [r3]
	ldr	r3, .L1490+40
	str	r2, [r3]
	ldr	r3, .L1490+44
	str	r5, [r3]
	movs	r3, #60
	strb	r3, [r6]
	bl	NandcInit
	str	r10, [sp, #20]
	ldr	r10, .L1490+140
	str	r8, [sp, #16]
	mov	r8, r6
	mov	r6, r4
.L1402:
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
	bhi	.L1398
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	ldr	r0, .L1490+48
	str	r1, [sp, #12]
	ldrb	r1, [r4, #4]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r4, #3]	@ zero_extendqisi2
	str	r1, [sp, #4]
	ldrb	r1, [r4, #2]	@ zero_extendqisi2
	str	r1, [sp]
	adds	r1, r5, #1
	bl	printf
.L1398:
	cbnz	r5, .L1399
	ldrb	r3, [r6]	@ zero_extendqisi2
	subs	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #253
	bhi	.L1443
	ldrb	r3, [r6, #1]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L1443
.L1399:
	ldrb	r3, [r4]	@ zero_extendqisi2
	adds	r5, r5, #1
	adds	r4, r4, #8
	cmp	r3, #181
	itt	eq
	moveq	r3, #44
	strbeq	r3, [r4, #-8]
	cmp	r5, #4
	bne	.L1402
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #173
	beq	.L1403
	ldr	r3, .L1490+52
	ldr	r0, [r3]
	bl	NandcSetDdrMode
.L1403:
	mov	r2, #852
	movs	r1, #0
	ldr	r0, .L1490+56
	bl	ftl_memset
	ldr	r4, .L1490+60
	ldr	r3, .L1490+64
	ldr	r5, .L1490+68
	str	r3, [r4]
	movs	r3, #0
	strb	r3, [r5]
	ldrb	r3, [r6, #1]	@ zero_extendqisi2
	cmp	r3, #161
	beq	.L1404
	cmp	r3, #218
	beq	.L1404
	and	r2, r3, #223
	cmp	r2, #209
	beq	.L1404
	cmp	r3, #220
	bne	.L1405
	ldrb	r2, [r6, #3]	@ zero_extendqisi2
	cmp	r2, #149
	bne	.L1405
.L1404:
	ldr	r1, [sp, #16]
	movs	r2, #1
	strb	r2, [r1]
	movs	r2, #16
	ldr	r1, [sp, #20]
	strb	r2, [r8]
	strb	r2, [r1]
	ldrb	r1, [r6]	@ zero_extendqisi2
	ldr	r2, .L1490+72
	cmp	r1, #152
	strb	r1, [r2, #1]
	strb	r3, [r2, #2]
	bne	.L1406
	ldrsb	r1, [r6, #4]
	cmp	r1, #0
	itt	ge
	movge	r1, #24
	strbge	r1, [r8]
.L1406:
	ldr	r1, .L1490+76
	ldr	r0, .L1490+80
	ldr	r1, [r1]
	cmp	r1, r0
	beq	.L1407
	movw	r0, #2049
	cmp	r1, r0
	bne	.L1408
.L1407:
	movs	r1, #16
	strb	r1, [r8]
.L1408:
	cmp	r3, #218
	bne	.L1409
	mov	r1, #2048
.L1486:
	strh	r1, [r2, #14]	@ movhi
	strb	r3, [r2, #2]
.L1410:
	movs	r2, #32
	ldr	r1, .L1490+84
	ldr	r0, .L1490+88
	bl	ftl_memcpy
	movs	r2, #32
	ldr	r1, .L1490+72
	ldr	r0, .L1490+64
	bl	ftl_memcpy
.L1405:
	ldr	r3, [sp, #16]
	ldr	r8, .L1490+144
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1412
	bl	FlashLoadPhyInfoInRam
	cbnz	r0, .L1414
	ldr	r3, [r4]
	ldr	r10, .L1490+100
	ldrh	r3, [r3, #16]
	lsrs	r3, r3, #8
	lsls	r1, r3, #31
	and	r0, r3, #7
	strb	r0, [r10]
	bmi	.L1414
	movs	r3, #1
	strb	r3, [r7]
	bl	FlashSetInterfaceMode
	ldrb	r0, [r10]	@ zero_extendqisi2
	bl	NandcSetMode
.L1414:
	ldr	r3, [r4]
	ldrb	r3, [r3, #26]	@ zero_extendqisi2
	strb	r3, [r8]
	bl	FlashLoadPhyInfo
	cmp	r0, #0
	beq	.L1412
	ldr	r3, [r4]
	ldr	r0, .L1490+92
	ldrh	r1, [r3, #14]
	bl	printf
	bl	FlashLoadPhyInfoInRam
	adds	r2, r0, #1
	beq	.L1397
	bl	FlashDieInfoInit
	ldr	r3, [r4]
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	bl	FlashGetReadRetryDefault
	ldr	r3, [r4]
	ldr	r2, .L1490+96
	ldrb	r1, [r3, #9]	@ zero_extendqisi2
	ldrh	r2, [r2]
	addw	r2, r2, #4095
	cmp	r1, r2, asr #12
	blt	.L1417
	ldrh	r2, [r3, #14]
	adds	r2, r2, #255
	cmp	r1, r2, asr #8
	bge	.L1418
.L1417:
	ldrh	r2, [r3, #14]
	bic	r2, r2, #255
	strh	r2, [r3, #14]	@ movhi
.L1418:
	ldr	r3, .L1490+100
	ldrb	r3, [r3]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L1419
	bl	FlashSavePhyInfo
	ldr	r3, .L1490+104
	movs	r0, #0
	ldr	r1, [r3]
	bl	FlashDdrParaScan
.L1419:
	bl	FlashSavePhyInfo
.L1412:
	ldr	fp, [r4]
	ldr	r10, .L1490+100
	ldrb	r3, [fp, #26]	@ zero_extendqisi2
	ldrh	r0, [fp, #10]
	strb	r3, [r8]
	ldrh	r3, [fp, #16]
	ubfx	r2, r3, #7, #1
	ubfx	r1, r3, #3, #1
	strb	r2, [r5]
	ldr	r2, .L1490+108
	ldr	r5, .L1490+112
	strb	r1, [r2]
	ubfx	r1, r3, #4, #1
	ldr	r2, .L1490+116
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
	beq	.L1421
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	ldr	r3, .L1490+120
	ldr	r2, .L1490+124
	strb	r0, [r3]
	ldr	r3, .L1490+56
	ldrb	r1, [r3, #1]	@ zero_extendqisi2
	ldrb	lr, [r3, #2]	@ zero_extendqisi2
	strb	r1, [r2]
	ldr	r1, .L1490+128
	strb	lr, [r1]
	b	.L1491
.L1492:
	.align	2
.L1490:
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
.L1491:
	add	lr, r0, #-1
	cmp	lr, #6
	mov	lr, r1
	bhi	.L1422
	ldr	r2, .L1493
	str	r2, [r5]
	subs	r2, r0, #5
	cmp	r2, #1
	bhi	.L1423
	ldr	r2, .L1493+4
	adds	r3, r3, #20
	movs	r1, #1
	str	r1, [r2]
.L1424:
	subs	r1, r3, #1
	movs	r2, #0
	adds	r3, r3, #31
.L1426:
	ldrsb	r5, [r1, #1]!
	cbnz	r5, .L1425
	adds	r2, r2, #1
.L1425:
	cmp	r3, r1
	bne	.L1426
	cmp	r2, #27
	bls	.L1421
	bl	FlashGetReadRetryDefault
	bl	FlashSavePhyInfo
.L1421:
	ldr	r3, .L1493+8
	ldr	r2, [r3]
	ldr	r3, .L1493+12
	cmp	r2, r3
	bne	.L1437
	ldrb	r3, [r8]	@ zero_extendqisi2
	cbz	r3, .L1437
	ldr	r3, [r4]
	movs	r2, #0
	strb	r2, [r3, #18]
.L1437:
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #44
	bne	.L1438
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbz	r3, .L1438
	movs	r3, #0
	movs	r0, #1
	strb	r3, [r7]
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
.L1438:
	movs	r0, #0
	bl	flash_enter_slc_mode
	ldrb	r3, [r10]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L1439
	ldrb	r2, [r7]	@ zero_extendqisi2
	cbnz	r2, .L1440
	lsls	r3, r3, #31
	bmi	.L1439
.L1440:
	ldr	r3, .L1493+16
	movs	r0, #0
	ldr	r1, [r3]
	bl	FlashDdrParaScan
.L1439:
	movs	r0, #0
	movs	r7, #16
	bl	flash_exit_slc_mode
	ldr	r3, [r4]
	ldrb	r0, [r3, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	ldr	r0, .L1493+20
	bl	FlashReadIdbDataRaw
	ldr	r8, [r4]
	ldr	r3, [sp, #20]
	ldr	r4, .L1493+24
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
	ldr	r3, .L1493+28
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
	bne	.L1441
	lsls	r3, r3, #1
	lsrs	r2, r6, #1
	lsls	r5, r5, #1
	strh	r3, [r4, #20]	@ movhi
	movs	r3, #8
	strh	r2, [r4, #14]	@ movhi
	strh	r5, [r4, #22]	@ movhi
	strh	r3, [r4, #26]	@ movhi
.L1441:
	ldrb	r0, [r8, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r0, #0
.L1397:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1409:
	cmp	r3, #220
	bne	.L1410
	mov	r1, #4096
	b	.L1486
.L1423:
	add	r2, r3, #28
	adds	r3, r3, #20
	cmp	r0, #7
	it	eq
	moveq	r3, r2
	b	.L1424
.L1422:
	sub	r3, r0, #17
	cmp	r3, #2
	bhi	.L1428
	ldr	r3, .L1493+32
	cmp	r0, #19
	str	r3, [r5]
	ite	ne
	movne	r3, #7
	moveq	r3, #15
	strb	r3, [r1]
	b	.L1421
.L1428:
	cmp	r0, #33
	beq	.L1430
	sub	r3, r0, #65
	cmp	r3, #1
	bhi	.L1431
.L1430:
	ldr	r3, .L1493+36
	str	r3, [ip]
	movs	r3, #4
	strb	r3, [r2]
	movs	r3, #7
	strb	r3, [lr]
	b	.L1421
.L1431:
	sub	r3, r0, #67
	uxtb	r3, r3
	cmp	r3, #1
	bls	.L1432
	sub	r1, r0, #34
	cmp	r1, #1
	bhi	.L1433
.L1432:
	ldr	r1, .L1493+36
	cmp	r0, #35
	str	r1, [ip]
	ldr	r1, .L1493+40
	beq	.L1434
	cmp	r0, #68
	beq	.L1434
	movs	r0, #7
.L1487:
	cmp	r3, #1
	strb	r0, [r1]
	ite	ls
	movls	r3, #4
	movhi	r3, #5
	strb	r3, [r2]
	b	.L1421
.L1434:
	movs	r0, #17
	b	.L1487
.L1433:
	cmp	r0, #49
	itt	eq
	ldreq	r3, .L1493+44
	streq	r3, [r5]
	b	.L1421
.L1443:
	mvn	r0, #1
	b	.L1397
.L1494:
	.align	2
.L1493:
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
	ldr	r3, .L1524
	mov	fp, r2
	mov	r4, r0
	movs	r7, #0
	ldrb	r10, [r3, #9]	@ zero_extendqisi2
.L1496:
	cmp	r7, r8
	bne	.L1509
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1509:
	sub	r3, r8, r7
	add	r2, sp, #12
	uxtb	r3, r3
	mov	r1, fp
	mov	r0, r4
	str	r3, [sp]
	add	r3, sp, #8
	bl	LogAddr2PhyAddr
	ldr	r2, .L1524+4
	ldr	r3, [sp, #8]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1497
	mov	r3, #-1
	str	r3, [r4]
.L1498:
	adds	r7, r7, #1
	adds	r4, r4, #36
	b	.L1496
.L1497:
	ldr	r2, .L1524+8
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
	ldr	r3, .L1524+12
	mov	r6, r0
	ldr	r1, [sp, #12]
	mov	r0, r5
	ldr	r3, [r3]
	add	r1, r1, r3
	bl	FlashReadCmd
	ldr	r3, [r4, #8]
	cbz	r3, .L1499
	add	r3, r3, #2048
.L1499:
	ldr	r2, [r4, #12]
	cbz	r2, .L1500
	adds	r2, r2, #8
.L1500:
	str	r2, [sp]
	movs	r1, #0
	mov	r2, r10
	mov	r0, r5
	bl	NandcXferData
	mov	r1, r0
	mov	r0, r5
	bl	NandcFlashDeCs
	ldr	r3, .L1524+16
	cmp	r6, r1
	it	cc
	movcc	r6, r1
	ldrb	r2, [r3]	@ zero_extendqisi2
	add	r3, r2, r2, lsl #1
	cmp	r6, r3, asr #2
	bls	.L1501
	adds	r5, r6, #1
	it	ne
	movne	r6, #256
	str	r6, [r4]
.L1504:
	ldr	r3, [r4, #12]
	cbz	r3, .L1505
	ldr	r1, [r3, #12]
	adds	r1, r1, #1
	bne	.L1505
	ldr	r1, [r3, #8]
	adds	r0, r1, #1
	bne	.L1505
	ldr	r3, [r3]
	adds	r3, r3, #1
	it	ne
	strne	r1, [r4]
.L1505:
	ldr	r3, [r4]
	adds	r1, r3, #1
	bne	.L1498
	ldr	r1, [r4, #4]
	ldr	r0, .L1524+20
	bl	printf
	ldr	r1, [r4, #8]
	cbz	r1, .L1507
	movs	r3, #8
	movs	r2, #4
	ldr	r0, .L1524+24
	bl	rknand_print_hex
.L1507:
	ldr	r1, [r4, #12]
	cmp	r1, #0
	beq	.L1498
	movs	r3, #4
	ldr	r0, .L1524+28
	mov	r2, r3
	bl	rknand_print_hex
	b	.L1498
.L1501:
	movs	r3, #0
	str	r3, [r4]
	b	.L1504
.L1525:
	.align	2
.L1524:
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
	ldr	r3, .L1617
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	mov	r10, r0
	str	r1, [sp, #24]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [sp, #12]
	cbnz	r3, .L1527
	ldr	r2, .L1617+4
	mov	r8, r3
	str	r3, [sp, #8]
	ldrb	r2, [r2, #9]	@ zero_extendqisi2
	str	r2, [sp, #20]
	ldr	r2, .L1617+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #28]
.L1528:
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #24]
	cmp	r3, r2
	bcc	.L1566
	movs	r0, #0
	b	.L1526
.L1527:
	bl	FlashReadSlc2KPages
.L1526:
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1566:
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
	ldr	r2, .L1617+12
	mov	r5, r0
	ldr	r3, [sp, #32]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1530
	mov	r3, #-1
	str	r3, [r10, fp]
.L1531:
	ldr	r3, [sp, #8]
	adds	r3, r3, #1
	str	r3, [sp, #8]
	b	.L1528
.L1530:
	ldr	r2, .L1617+16
	ldrb	r4, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1617+20
	mov	r0, r4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	it	eq
	moveq	r5, #0
	bl	NandcWaitFlashReady
	ldr	r3, .L1617+24
	ldr	r3, [r3]
	ldrb	r1, [r3, #19]	@ zero_extendqisi2
	subs	r3, r1, #1
	cmp	r3, #6
	bhi	.L1533
	ldr	r3, .L1617+28
	cmp	r1, #7
	add	r2, r3, r4
	ldrb	r3, [r2, #12]	@ zero_extendqisi2
	it	eq
	ldrbeq	r3, [r2, #20]	@ zero_extendqisi2
	ldr	r2, .L1617+32
	ldrb	r2, [r2, r4]	@ zero_extendqisi2
	cmp	r2, r3
	beq	.L1533
	ldr	r2, .L1617+36
	mov	r0, r4
	ldrb	r1, [r2, #-3]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1533:
	mov	r0, r4
	bl	NandcFlashCs
	ldr	r3, [sp, #12]
	cmp	r3, #1
	beq	.L1535
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1536
.L1535:
	ldr	r3, .L1617+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1536
	mov	r0, r4
	bl	flash_enter_slc_mode
.L1543:
	ldr	r1, [sp, #36]
	adds	r6, r1, #1
	bne	.L1538
	cmp	r4, #255
	beq	.L1568
.L1538:
	cbz	r5, .L1540
	ldr	r3, .L1617+44
	mov	r0, r4
	ldr	r2, [r3]
	add	r2, r2, r1
	bl	FlashReadDpCmd
.L1541:
	mov	r0, r4
	bl	NandcWaitFlashReady
	cbz	r5, .L1539
	ldr	r1, [sp, #36]
	mov	r0, r4
	bl	FlashReadDpDataOutCmd
.L1539:
	ldr	r3, [r7, #12]
	movs	r1, #0
	ldr	r2, [sp, #20]
	mov	r0, r4
	str	r3, [sp]
	ldr	r3, [r7, #8]
	bl	NandcXferData
	ldr	r3, .L1617+8
	mov	r6, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1542
	adds	r0, r0, #1
	bne	.L1542
	ldr	r3, .L1617+8
	movs	r5, #0
	strb	r5, [r3]
	b	.L1543
.L1536:
	mov	r0, r4
	bl	flash_exit_slc_mode
	b	.L1543
.L1540:
	mov	r0, r4
	bl	FlashReadCmd
	b	.L1541
.L1568:
	movs	r5, #0
	b	.L1539
.L1542:
	cbz	r5, .L1544
	ldr	r3, .L1617+44
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
.L1544:
	mov	r0, r4
	bl	NandcFlashDeCs
	ldr	r3, .L1617+8
	adds	r1, r6, #1
	ldrb	r2, [sp, #28]	@ zero_extendqisi2
	strb	r2, [r3]
	bne	.L1545
	ldr	r3, .L1617+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1546
.L1550:
	ldr	r3, .L1617+52
	ldr	r5, [r3]
	cmp	r5, #0
	bne	.L1547
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	bl	FlashReadRawPage
	b	.L1616
.L1546:
	ldr	r3, .L1617+56
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
	beq	.L1549
	ldr	r3, .L1617+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3, lsr #1
	bls	.L1569
.L1549:
	ubfx	r0, r5, #8, #8
	bl	NandcSetDdrPara
	adds	r3, r6, #1
	beq	.L1550
.L1569:
	movs	r5, #0
.L1545:
	ldr	r3, .L1617+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r6, r3, asr #2
	bls	.L1558
	ldr	r3, .L1617+52
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L1558
	mov	r6, #256
	b	.L1553
.L1618:
	.align	2
.L1617:
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
.L1547:
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	blx	r5
	adds	r5, r0, #1
	mov	r6, r0
	bne	.L1551
	ldr	r3, .L1619
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #6
	bhi	.L1552
	ldr	r2, .L1619+4
	movs	r3, #0
	mov	r0, r4
	ldrb	r1, [r2, #-3]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1552:
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	bl	FlashReadRawPage
	ldr	r2, .L1619+8
	mov	r6, r0
	mov	r3, r0
	ldr	r1, [r7, #4]
	ldr	r0, .L1619+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	bl	printf
	adds	r0, r6, #1
	bne	.L1551
	ldr	r3, .L1619+16
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L1553
	ldr	r3, [sp, #12]
	mov	r0, r4
	cmp	r3, #1
	beq	.L1554
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1555
.L1554:
	bl	flash_enter_slc_mode
.L1556:
	ldr	r3, .L1619+20
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	ldr	r5, [r3]
	ldr	r3, [r7, #12]
	blx	r5
.L1616:
	adds	r1, r0, #1
	mov	r6, r0
	mov	r5, #0
	bne	.L1558
.L1553:
	str	r6, [r10, fp]
.L1559:
	ldr	r3, [r10, fp]
	adds	r2, r3, #1
	bne	.L1561
	ldr	r2, .L1619+8
	ldr	r1, [r7, #4]
	ldr	r0, .L1619+24
	ldrb	r2, [r2]	@ zero_extendqisi2
	bl	printf
	ldr	r1, [r7, #12]
	cbz	r1, .L1561
	movs	r3, #4
	ldr	r0, .L1619+28
	mov	r2, r3
	bl	rknand_print_hex
.L1561:
	cbz	r5, .L1563
	ldr	r3, .L1619+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r8, r3, asr #2
	bls	.L1564
	ldr	r3, .L1619+20
	ldr	r3, [r3]
	cmp	r3, #0
	it	eq
	moveq	r8, #256
.L1564:
	cmp	r8, #-1
	add	r3, fp, #36
	str	r8, [r10, r3]
	beq	.L1563
	cmp	r8, #256
	itt	ne
	movne	r2, #0
	strne	r2, [r10, r3]
.L1563:
	ldr	r3, [sp, #8]
	add	r3, r3, r5
	str	r3, [sp, #8]
	ldr	r3, [sp, #12]
	cmp	r3, #1
	beq	.L1565
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1531
.L1565:
	ldr	r3, .L1619+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1531
	mov	r0, r4
	bl	flash_exit_slc_mode
	b	.L1531
.L1555:
	bl	flash_exit_slc_mode
	b	.L1556
.L1551:
	movs	r5, #0
.L1558:
	cmp	r6, #256
	beq	.L1553
	movs	r3, #0
	str	r3, [r10, fp]
	b	.L1559
.L1620:
	.align	2
.L1619:
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
	ldr	r3, .L1650
	movs	r7, #0
	ldr	fp, .L1650+28
	str	r2, [sp, #8]
	ldrb	r10, [r3, #9]	@ zero_extendqisi2
.L1622:
	cmp	r7, r8
	bne	.L1628
	ldr	r3, [sp, #12]
	cmp	r3, #0
	bne	.L1639
.L1649:
	movs	r0, #0
	add	sp, sp, #64
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1628:
	sub	r3, r8, r7
	add	r2, sp, #20
	uxtb	r3, r3
	ldr	r1, [sp, #8]
	mov	r0, r6
	str	r3, [sp]
	add	r3, sp, #24
	bl	LogAddr2PhyAddr
	ldr	r2, .L1650+4
	ldr	r3, [sp, #24]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1623
	mov	r3, #-1
	str	r3, [r6]
.L1624:
	adds	r7, r7, #1
	adds	r6, r6, #36
	b	.L1622
.L1623:
	ldr	r2, .L1650+8
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
	cbz	r3, .L1625
	add	r3, r3, #2048
.L1625:
	ldr	r2, [r6, #12]
	cbz	r2, .L1626
	adds	r2, r2, #8
.L1626:
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
	b	.L1624
.L1635:
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1630
	ldr	r1, [r4, #4]
	ldr	r0, .L1650+12
	bl	printf
.L1631:
	add	r8, r8, #1
	adds	r4, r4, #36
.L1629:
	cmp	r7, r8
	bne	.L1635
	b	.L1649
.L1630:
	sub	r3, r7, r8
	ldr	fp, .L1650+32
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
	bne	.L1632
	ldr	r1, [r4, #4]
	ldr	r0, .L1650+16
	bl	printf
	str	r5, [r4]
.L1632:
	ldr	r3, [r4, #12]
	cbz	r3, .L1633
	ldr	r2, [r3]
	ldr	r3, [fp]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1633
	ldr	r1, [r4, #4]
	ldr	r0, .L1650+20
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L1633:
	ldr	r3, [r4, #8]
	cmp	r3, #0
	beq	.L1631
	ldr	r2, [r3]
	ldr	r3, [r10]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1631
	ldr	r1, [r4, #4]
	ldr	r0, .L1650+24
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
	b	.L1631
.L1639:
	mov	r8, #0
	ldr	r10, .L1650+36
	b	.L1629
.L1651:
	.align	2
.L1650:
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
	ldr	r5, .L1704
	mov	r4, r0
	mov	r8, r2
	str	r1, [sp, #8]
	ldr	r5, [r5]
	str	r3, [sp, #20]
	ldrb	r5, [r5, #19]	@ zero_extendqisi2
	str	r5, [sp, #16]
	ldr	r5, .L1704+4
	ldrb	r7, [r5]	@ zero_extendqisi2
	cbnz	r7, .L1653
	ldr	r3, .L1704+8
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	str	r3, [sp, #12]
.L1654:
	ldr	r3, [sp, #8]
	cmp	r7, r3
	bcc	.L1667
	ldr	r6, .L1704+12
	movs	r5, #0
	ldr	r7, .L1704+16
.L1668:
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r5, r3
	bcc	.L1670
	ldr	r3, [sp, #20]
	cmp	r3, #0
	bne	.L1671
.L1679:
	movs	r0, #0
	b	.L1652
.L1653:
	bl	FlashProgSlc2KPages
.L1652:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1667:
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
	ldr	r3, .L1704+12
	mov	r10, r0
	ldr	r0, [sp, #32]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L1656
	mov	r3, #-1
	str	r3, [r4, r6]
.L1657:
	adds	r7, r7, #1
	b	.L1654
.L1656:
	ldr	r3, .L1704+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	ldr	r3, .L1704+24
	it	eq
	moveq	r10, #0
	add	r3, r3, r0, lsl #4
	ldr	r3, [r3, #8]
	cbz	r3, .L1659
	uxtb	r0, r0
	bl	FlashWaitCmdDone
.L1659:
	ldr	r3, [sp, #32]
	movs	r1, #0
	ldr	r2, .L1704+24
	add	r2, r2, r3, lsl #4
	str	r1, [r2, #12]
	ldr	r1, [sp, #28]
	str	fp, [r2, #8]
	str	r1, [r2, #4]
	cmp	r10, #0
	beq	.L1660
	add	r1, r6, #36
	add	r1, r1, r4
	str	r1, [r2, #12]
.L1660:
	ldr	r2, .L1704+28
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	lsls	r3, r3, #4
	ldr	r2, .L1704+24
	mov	r0, r5
	strb	r5, [r2, r3]
	ldr	r3, .L1704+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1661
	bl	NandcWaitFlashReady
.L1662:
	ldr	r3, [sp, #16]
	subs	r3, r3, #1
	cmp	r3, #6
	bhi	.L1663
	ldr	r3, .L1704+32
	ldrb	r3, [r3, r5]	@ zero_extendqisi2
	cbz	r3, .L1663
	ldr	r1, .L1704+36
	movs	r3, #0
	mov	r0, r5
	adds	r2, r1, #4
	ldrb	r1, [r1, #1]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1663:
	mov	r0, r5
	bl	NandcFlashCs
	cmp	r8, #1
	mov	r0, r5
	bne	.L1664
	ldr	r3, .L1704+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1664
	bl	flash_enter_slc_mode
.L1665:
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
	beq	.L1666
	ldr	r1, [sp, #28]
	mov	r0, r5
	bl	FlashProgDpFirstCmd
	ldr	r3, .L1704+40
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
	ldr	r3, .L1704+44
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
.L1666:
	ldr	r1, [sp, #28]
	mov	r0, r5
	bl	FlashProgSecondCmd
	mov	r0, r5
	add	r7, r7, r10
	bl	NandcFlashDeCs
	b	.L1657
.L1661:
	bl	NandcFlashCs
	ldr	r2, [sp, #32]
	mov	r0, r5
	ldr	r3, .L1704+40
	ldr	r1, [sp, #28]
	ldr	r2, [r3, r2, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	mov	r0, r5
	bl	NandcFlashDeCs
	b	.L1662
.L1664:
	bl	flash_exit_slc_mode
	b	.L1665
.L1670:
	uxtb	r0, r5
	bl	FlashWaitCmdDone
	cmp	r8, #1
	bne	.L1669
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbz	r3, .L1669
	ldr	r2, .L1704+24
	lsls	r3, r5, #4
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	flash_exit_slc_mode
.L1669:
	adds	r5, r5, #1
	b	.L1668
.L1671:
	ldr	r10, .L1704+64
	movs	r7, #0
.L1672:
	ldr	r3, [sp, #8]
	cmp	r7, r3
	beq	.L1679
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1673
	ldr	r1, [r4, #4]
	ldr	r0, .L1704+48
	bl	printf
.L1674:
	adds	r7, r7, #1
	adds	r4, r4, #36
	b	.L1672
.L1673:
	ldr	r3, [sp, #8]
	add	r2, sp, #28
	ldr	fp, .L1704+68
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
	bne	.L1675
	ldr	r1, [r4, #4]
	ldr	r0, .L1704+52
	bl	printf
	str	r5, [r4]
.L1675:
	ldr	r3, [r4, #12]
	cbz	r3, .L1676
	ldr	r2, [r3]
	ldr	r3, [fp]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1676
	ldr	r1, [r4, #4]
	ldr	r0, .L1704+56
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L1676:
	ldr	r3, [r4, #8]
	cmp	r3, #0
	beq	.L1674
	ldr	r2, [r3]
	ldr	r3, [r10]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1674
	ldr	r1, [r4, #4]
	ldr	r0, .L1704+60
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
	b	.L1674
.L1705:
	.align	2
.L1704:
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
	ldr	r3, .L1709
	push	{r4, r5, lr}
	mov	r4, r0
	sub	sp, sp, #108
	ldr	r3, [r3]
	cmp	r0, r3
	bcc	.L1708
	ldr	r5, .L1709+4
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
.L1706:
	mov	r0, r4
	add	sp, sp, #108
	@ sp needed
	pop	{r4, r5, pc}
.L1708:
	movs	r4, #0
	b	.L1706
.L1710:
	.align	2
.L1709:
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
	ldr	r3, .L1756
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	str	r0, [sp, #8]
	ldr	r3, [r3]
	str	r1, [sp, #4]
	cmp	r3, #0
	bne	.L1738
	ldr	r2, .L1756+4
	mov	r10, r3
	mov	r5, r3
	mov	r4, r3
	mov	r8, #36
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #20]
	ldr	r2, .L1756+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #12]
	ldr	r2, .L1756+12
	str	r0, [r2]
	ldr	r2, .L1756+16
	ldrh	fp, [r2]
	ldr	r2, .L1756+20
	ldr	r7, [r2]
	ldr	r2, .L1756+24
	ldr	r2, [r2]
	str	r2, [sp, #16]
	ldr	r2, .L1756+28
	ldrh	r2, [r2]
	str	r2, [sp, #24]
.L1713:
	uxth	r2, r10
	cmp	fp, r2
	bhi	.L1717
	cmp	r5, #0
	beq	.L1711
	ldr	r3, [sp, #12]
	mov	r0, r7
	ldr	r10, .L1756+4
	mov	r8, #0
	mov	r2, r5
	ldr	r7, .L1756+20
	adds	r6, r3, #0
	it	ne
	movne	r6, #1
	strb	r8, [r10]
	mov	r1, r6
	bl	FlashEraseBlocks
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	strb	r3, [r10]
	mov	r10, #36
.L1719:
	uxth	r3, r8
	cmp	r5, r3
	bhi	.L1721
	ldr	r3, [sp, #4]
	cmp	r3, #0
	bne	.L1722
	uxth	r6, r6
	movs	r3, #6
	str	r3, [sp, #16]
	movs	r3, #1
	str	r3, [sp, #12]
.L1723:
	mov	r8, #0
.L1732:
	ldr	r3, .L1756+16
	mov	fp, #0
	mov	r5, fp
	ldrh	r3, [r3]
	str	r3, [sp, #24]
	ldr	r3, .L1756+20
	ldr	r10, [r3]
	ldr	r3, .L1756+32
	ldr	r3, [r3]
	str	r3, [sp, #28]
	ldr	r3, .L1756+36
	ldr	r3, [r3]
	str	r3, [sp, #32]
	ldr	r3, .L1756+28
	ldrh	r3, [r3]
	str	r3, [sp, #36]
.L1724:
	ldr	r3, [sp, #24]
	uxth	r2, fp
	cmp	r3, r2
	bhi	.L1727
	cbz	r5, .L1711
	ldr	fp, .L1756+4
	movs	r3, #1
	mov	r0, r10
	movs	r7, #0
	mov	r2, r6
	mov	r1, r5
	strb	r7, [fp]
	bl	FlashProgPages
	ldrb	r3, [sp, #20]	@ zero_extendqisi2
	ldr	r10, .L1756+20
	strb	r3, [fp]
	mov	fp, #36
.L1729:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L1731
	ldr	r3, [sp, #16]
	add	r8, r8, r3
	ldr	r3, [sp, #12]
	uxth	r8, r8
	cmp	r3, r8
	bhi	.L1732
	ldr	r8, .L1756+20
	movs	r7, #0
	mov	r10, #36
.L1733:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L1735
	ldr	r3, [sp, #8]
	cmp	r3, #63
	bls	.L1736
	ldr	r3, [sp, #4]
	cbz	r3, .L1711
.L1736:
	ldr	r3, .L1756+20
	mov	r2, r5
	mov	r1, r6
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L1711:
	mov	r0, r4
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1717:
	mul	r2, r8, r10
	movs	r3, #0
	ldr	r1, [sp, #8]
	str	r3, [r7, r2]
	ldr	r3, .L1756+40
	ldrb	r0, [r3, r10]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r3, [sp, #4]
	mov	r6, r0
	cbz	r3, .L1714
	bl	IsBlkInVendorPart
	cbnz	r0, .L1715
.L1714:
	mov	r0, r6
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1716
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
.L1715:
	add	r10, r10, #1
	b	.L1713
.L1716:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L1715
.L1721:
	mul	r3, r10, r8
	ldr	r2, [r7]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	adds	r3, r3, #1
	bne	.L1720
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L1720:
	add	r8, r8, #1
	b	.L1719
.L1722:
	ldr	r3, .L1756+44
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1756+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1739
	ldr	r3, [sp, #12]
	movs	r6, #1
	lsrs	r3, r3, #2
	str	r3, [sp, #16]
	b	.L1723
.L1739:
	movs	r6, #1
	str	r6, [sp, #16]
	b	.L1723
.L1727:
	movs	r3, #36
	ldr	r1, [sp, #8]
	mul	r2, r3, fp
	movs	r3, #0
	str	r3, [r10, r2]
	ldr	r3, .L1756+40
	ldrb	r0, [r3, fp]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r3, [sp, #4]
	mov	r7, r0
	cbz	r3, .L1725
	bl	IsBlkInVendorPart
	cbnz	r0, .L1726
.L1725:
	mov	r0, r7
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1726
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
.L1726:
	add	fp, fp, #1
	b	.L1724
.L1731:
	mul	r3, fp, r7
	ldr	r2, [r10]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbz	r3, .L1730
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L1730:
	adds	r7, r7, #1
	b	.L1729
.L1735:
	ldr	r3, [sp, #4]
	cbz	r3, .L1734
	mul	r3, r10, r7
	ldr	r2, [r8]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbnz	r3, .L1734
	ldr	r0, [r1, #4]
	movs	r1, #1
	ubfx	r0, r0, #10, #16
	bl	FtlFreeSysBlkQueueIn
.L1734:
	adds	r7, r7, #1
	b	.L1733
.L1738:
	movs	r4, #0
	b	.L1711
.L1757:
	.align	2
.L1756:
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
	ldr	r3, .L1769
	ldr	r4, [r3]
	str	r3, [sp, #12]
	cmp	r4, #0
	bne	.L1760
	ldr	r3, .L1769+4
	mov	r1, r4
	ldr	r7, .L1769+8
	ldr	r5, .L1769+12
	ldr	r3, [r3]
	ldr	r0, [r7]
	mov	r8, r7
	ldr	r6, .L1769+16
	str	r3, [r5, #12]
	ldr	r7, .L1769+20
	ldr	r3, .L1769+24
	ldr	r10, .L1769+56
	str	r0, [r5, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
.L1761:
	ldrh	r3, [r7]
	cmp	r4, r3
	blt	.L1762
	ldr	r6, [r5, #12]
	movs	r2, #16
	ldr	r4, .L1769+28
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
	ldr	r3, .L1769+32
	ldr	r3, [r3]
	strh	r3, [r6, #12]	@ movhi
.L1763:
	ldr	r3, [r8]
	mov	fp, #0
	ldrh	r1, [r4]
	ldrh	r2, [r4, #2]
	str	r3, [r5, #8]
	ldr	r3, .L1769+4
	ldrh	r0, [r6, #10]
	str	fp, [r5]
	ldr	r3, [r3]
	str	r3, [r5, #12]
	orr	r3, r2, r1, lsl #10
	str	r3, [r5, #4]
	ldrh	r3, [r4, #4]
	str	r0, [sp]
	ldr	r0, .L1769+36
	bl	printf
	movs	r3, #1
	ldr	r0, .L1769+12
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r3, .L1769+40
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1764
	ldr	r3, [r4, #8]
	ldrh	r2, [r4]
	strh	fp, [r4, #2]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #8]
	str	r3, [r6, #4]
	strh	r2, [r6, #8]	@ movhi
	ldrh	r3, [r4, #4]
	strh	r2, [r4, #4]	@ movhi
	ldr	r2, .L1769+44
	strh	r3, [r4]	@ movhi
	lsls	r3, r3, #10
	ldr	r0, [r2]
	movs	r2, #1
	str	r3, [r5, #4]
	mov	r1, r2
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	movs	r3, #1
	ldr	r0, .L1769+12
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
.L1764:
	ldrh	r3, [r10, #2]
	adds	r3, r3, #1
	strh	r3, [r10, #2]	@ movhi
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L1765
	adds	r7, r7, #1
	ldr	r1, [r5, #4]
	uxth	r7, r7
	ldr	r0, .L1769+48
	bl	printf
	cmp	r7, #3
	bls	.L1763
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L1769+52
	bl	printf
	ldr	r2, [sp, #12]
	movs	r3, #1
	str	r3, [r2]
.L1760:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1762:
	ldrh	r2, [r10]
	ldr	r3, [r5, #8]
	ldr	r1, [r6, #4]!
	mul	r0, r4, r2
	lsls	r2, r2, #2
	adds	r4, r4, #1
	add	r0, r3, r0, lsl #2
	bl	ftl_memcpy
	b	.L1761
.L1765:
	ldr	r3, [sp, #8]
	cmp	r3, #0
	bne	.L1760
	movs	r3, #1
	str	r3, [sp, #8]
	b	.L1763
.L1770:
	.align	2
.L1769:
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
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r3, .L1834
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L1773
	ldr	r7, .L1834+4
.L1772:
	ldr	r3, .L1834+4
	ldr	r6, .L1834+8
	ldrh	r3, [r3]
	ldrh	r2, [r6]
	add	r3, r3, r2
	ldr	r2, .L1834+12
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1774
	ldr	r1, .L1834+16
	mov	r2, #3168
	ldr	r0, .L1834+20
	bl	printf
	ldr	r1, .L1834+24
	ldr	r0, .L1834+28
	bl	printf
.L1774:
	ldr	r3, .L1834+32
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	cmp	r4, r3
	bne	.L1775
	ldr	r3, .L1834+36
	ldrh	r5, [r7]
	ldr	r3, [r3]
	lsrs	r0, r5, #1
	mul	ip, r3, r5
	adds	r1, r0, #1
	add	r1, r1, ip, lsr #2
	ldr	ip, .L1834+48
	uxth	r1, r1
	ldr	ip, [ip]
	cmp	ip, #0
	beq	.L1776
	ldr	ip, .L1834+52
	ldr	ip, [ip]
	cmp	ip, #39
	bhi	.L1776
	cmp	ip, #2
	bls	.L1809
	lsls	r5, r5, #31
	bpl	.L1805
	cmp	r3, #0
	beq	.L1809
.L1805:
	mov	r1, r0
	b	.L1776
.L1775:
	cmp	r2, #1
	bne	.L1809
	ldr	r3, .L1834+40
	ldrh	r3, [r3]
	cmp	r3, #1
	beq	.L1809
	ldr	r3, .L1834+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1809
	ldr	r0, .L1834+48
	ldrh	r3, [r7]
	ldr	r0, [r0]
	lsrs	r1, r3, #3
	cbz	r0, .L1776
	ldr	r0, .L1834+52
	ldr	r0, [r0]
	cmp	r0, #1
	bhi	.L1776
	rsb	r3, r3, r3, lsl #3
	ubfx	r1, r3, #3, #16
.L1776:
	cbz	r1, .L1777
	subs	r1, r1, #1
	uxth	r1, r1
.L1777:
	ldr	r0, .L1834+56
	bl	List_pop_index_node
	ldrh	r3, [r7]
	mov	r5, r0
	uxth	r8, r0
	cbnz	r3, .L1778
	ldr	r1, .L1834+16
	movw	r2, #3188
	ldr	r0, .L1834+20
	bl	printf
	ldr	r1, .L1834+24
	ldr	r0, .L1834+28
	bl	printf
.L1778:
	ldrh	r3, [r7]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r7]	@ movhi
	strh	r8, [r4]	@ movhi
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1779
	ldr	r3, .L1834+60
	uxth	r5, r5
	movw	r2, #65535
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldrh	r2, [r6]
	ldrh	r3, [r7]
	add	r3, r3, r2
	ldr	r2, .L1834+12
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1772
	mov	r2, #3200
	ldr	r1, .L1834+16
	ldr	r0, .L1834+20
	bl	printf
	ldr	r1, .L1834+24
	ldr	r0, .L1834+28
	bl	printf
	b	.L1772
.L1809:
	movs	r1, #0
	b	.L1777
.L1779:
	ldrh	r2, [r6]
	ldrh	r3, [r7]
	add	r3, r3, r2
	ldr	r2, .L1834+12
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1781
	ldr	r1, .L1834+16
	movw	r2, #3203
	ldr	r0, .L1834+20
	bl	printf
	ldr	r1, .L1834+24
	ldr	r0, .L1834+28
	bl	printf
.L1781:
	ldr	r2, .L1834+64
	movs	r6, #0
	ldr	fp, .L1834+100
	add	ip, r4, #16
	mov	lr, r6
	movw	r10, #65535
	ldrh	r1, [r2]
	movs	r2, #36
	ldr	r0, [fp]
	str	r2, [sp, #4]
	mov	r3, r0
	mla	r1, r2, r1, r0
	str	r1, [sp]
.L1782:
	ldr	r2, [sp]
	cmp	r2, r3
	bne	.L1784
	cbnz	r6, .L1785
	ldr	r1, .L1834+16
	movw	r2, #3215
	ldr	r0, .L1834+20
	bl	printf
	ldr	r1, .L1834+24
	ldr	r0, .L1834+28
	bl	printf
.L1785:
	ldr	r3, .L1834+48
	uxth	r5, r5
	ldr	r10, .L1834+104
	ldr	r3, [r3]
	cbz	r3, .L1786
	ldr	r3, .L1834+68
	cmp	r4, r3
	bne	.L1786
	ldr	r3, [r10]
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, #40
	itt	hi
	movhi	r3, #0
	strbhi	r3, [r4, #8]
.L1786:
	ldr	r3, .L1834+72
	ldrh	r3, [r3]
	cmp	r3, r8
	bne	.L1787
	ldr	r1, .L1834+16
	movw	r2, #3222
	ldr	r0, .L1834+20
	bl	printf
	ldr	r1, .L1834+24
	ldr	r0, .L1834+28
	bl	printf
.L1787:
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	ldr	r2, .L1834+76
	ldr	r3, .L1834+80
	cmp	r1, #0
	bne	.L1788
	ldr	r0, [r10]
	ldrh	lr, [r0, r5, lsl #1]
	cmp	lr, #0
	beq	.L1789
	ldr	r1, .L1834+84
	ldrh	ip, [r1]
	add	r1, lr, ip
.L1832:
	strh	r1, [r0, r5, lsl #1]	@ movhi
	mov	r0, r8
	ldr	r1, [r2]
	str	r3, [sp, #4]
	str	r2, [sp]
	adds	r1, r1, #1
	str	r1, [r2]
	movs	r1, #0
	bl	ftl_set_blk_mode
	ldm	sp, {r2, r3}
.L1791:
	lsls	r1, r5, #1
	ldr	r3, [r3]
	ldr	r2, [r2]
	str	r1, [sp]
	ldr	r1, [r10]
	ldrh	ip, [r1, r5, lsl #1]
	ldr	r1, .L1834+88
	ldr	r0, [r1]
	cmp	ip, r0
	it	hi
	strhi	ip, [r1]
	ldr	r1, .L1834+84
	ldrh	r0, [r1]
	ldr	r1, .L1834+12
	mla	r0, r2, r0, r3
	ldrh	r1, [r1]
	bl	__aeabi_uidiv
	ldr	r3, .L1834+92
	ldr	ip, .L1834+108
	str	r0, [r3]
	ldr	r3, .L1834+96
	ldr	r0, [fp]
	ldr	r2, [r3]
	adds	r1, r0, #4
	ldr	r3, [r2, #16]
	adds	r3, r3, #1
	str	r3, [r2, #16]
	movs	r3, #36
	mla	r3, r3, r6, r0
	adds	r3, r3, #40
.L1793:
	adds	r1, r1, #36
	cmp	r3, r1
	bne	.L1794
	ldr	r3, .L1834+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1795
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	mov	r2, r6
	cmp	r3, #1
	ite	eq
	moveq	r1, #0
	movne	r1, #1
	bl	FlashEraseBlocks
.L1795:
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	mov	r2, r6
	ldr	r0, [fp]
	mov	r10, #0
	bl	FlashEraseBlocks
	mov	r3, r10
	movs	r1, #36
.L1797:
	uxth	r2, r10
	cmp	r6, r2
	bhi	.L1799
	cbz	r3, .L1800
	mov	r0, r8
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1800:
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	ldr	r1, .L1834+60
	cmp	r2, #0
	bne	.L1801
	ldr	r3, [r1]
	movw	r2, #65535
	strh	r2, [r3, r5, lsl #1]	@ movhi
	b	.L1772
.L1835:
	.align	2
.L1834:
	.word	.LANCHOR77
	.word	.LANCHOR89
	.word	.LANCHOR86
	.word	.LANCHOR40
	.word	.LANCHOR203
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR94
	.word	.LANCHOR172
	.word	.LANCHOR44
	.word	.LANCHOR8
	.word	.LANCHOR28
	.word	.LANCHOR170
	.word	.LANCHOR88
	.word	.LANCHOR84
	.word	.LANCHOR38
	.word	.LANCHOR92
	.word	.LANCHOR204
	.word	.LANCHOR167
	.word	.LANCHOR168
	.word	.LANCHOR48
	.word	.LANCHOR169
	.word	.LANCHOR205
	.word	.LANCHOR191
	.word	.LANCHOR78
	.word	.LANCHOR79
	.word	-1024
.L1784:
	ldrh	r1, [ip], #2
	str	lr, [r3, #8]
	str	lr, [r3, #12]
	cmp	r1, r10
	beq	.L1783
	ldr	r2, [sp, #4]
	lsls	r1, r1, #10
	mla	r2, r2, r6, r0
	adds	r6, r6, #1
	uxth	r6, r6
	str	r1, [r2, #4]
.L1783:
	adds	r3, r3, #36
	b	.L1782
.L1789:
	movs	r1, #2
	b	.L1832
.L1788:
	ldr	r0, [r10]
	str	r2, [sp, #4]
	str	r3, [sp]
	ldrh	r1, [r0, r5, lsl #1]
	adds	r1, r1, #1
	strh	r1, [r0, r5, lsl #1]	@ movhi
	mov	r0, r8
	ldr	r1, [r3]
	adds	r1, r1, #1
	str	r1, [r3]
	bl	ftl_set_blk_mode.part.10
	ldr	r2, [sp, #4]
	ldr	r3, [sp]
	b	.L1791
.L1794:
	ldr	r2, [r1, #-36]
	and	r2, r2, ip
	str	r2, [r1, #-36]
	b	.L1793
.L1799:
	ldr	r0, .L1836
	mul	r2, r1, r10
	ldr	r0, [r0]
	add	ip, r0, r2
	ldr	r2, [r0, r2]
	adds	r0, r2, #1
	bne	.L1798
	ldr	r0, [ip, #4]
	adds	r3, r3, #1
	str	r1, [sp, #12]
	str	r2, [sp, #8]
	ubfx	r0, r0, #10, #16
	str	r3, [sp, #4]
	bl	FtlBbmMapBadBlock
	ldr	r2, [sp, #8]
	add	r0, r4, r10, lsl #1
	ldr	r1, [sp, #12]
	ldr	r3, [sp, #4]
	strh	r2, [r0, #16]	@ movhi
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	subs	r2, r2, #1
	strb	r2, [r4, #7]
.L1798:
	add	r10, r10, #1
	b	.L1797
.L1801:
	ldr	r3, .L1836+4
	ldr	r0, .L1836+8
	ldrh	r3, [r3]
	strh	r8, [r4]	@ movhi
	smulbb	r3, r3, r2
	movs	r2, #0
	strh	r2, [r4, #2]	@ movhi
	strb	r2, [r4, #6]
	ldr	r2, [r0]
	uxth	r3, r3
	strh	r3, [r4, #4]	@ movhi
	str	r2, [r4, #12]
	adds	r2, r2, #1
	str	r2, [r0]
	ldr	r2, [r1]
	ldr	r1, [sp]
	strh	r3, [r2, r1]	@ movhi
	ldrh	r3, [r4, #4]
	cbz	r3, .L1802
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1773
.L1802:
	ldr	r1, .L1836+12
	movw	r2, #3281
	ldr	r0, .L1836+16
	bl	printf
	ldr	r1, .L1836+20
	ldr	r0, .L1836+24
	bl	printf
.L1773:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1837:
	.align	2
.L1836:
	.word	.LANCHOR78
	.word	.LANCHOR53
	.word	.LANCHOR159
	.word	.LANCHOR203
	.word	.LC5
	.word	.LC6
	.word	.LC7
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
	ldr	r4, .L1850
	ldrh	r3, [r4]
	cbz	r3, .L1839
	ldr	r8, .L1850+12
	movs	r7, #0
.L1840:
	ldr	r3, .L1850+4
	ldrh	r2, [r3]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L1846
	bl	FtlGcReFreshBadBlk
.L1839:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1846:
	ldr	r2, .L1850+8
	uxth	r3, r7
	mov	r1, r10
	mov	fp, #0
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	mov	r1, r0
.L1841:
	ldrh	r3, [r4]
	uxth	r5, fp
	cmp	r3, r5
	bhi	.L1845
	adds	r7, r7, #1
	b	.L1840
.L1845:
	uxth	r6, fp
	ldrh	r3, [r8, r6, lsl #1]
	cmp	r3, r1
	bne	.L1842
	mov	r0, r1
	str	r1, [sp, #4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	r2, [r4]
	add	r3, r8, r6, lsl #1
	ldr	r1, [sp, #4]
.L1843:
	cmp	r5, r2
	bcc	.L1844
	subs	r2, r2, #1
	strh	r2, [r4]	@ movhi
.L1842:
	add	fp, fp, #1
	b	.L1841
.L1844:
	ldrh	r0, [r3, #2]!
	adds	r5, r5, #1
	uxth	r5, r5
	strh	r0, [r3, #-2]	@ movhi
	b	.L1843
.L1851:
	.align	2
.L1850:
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
	ldr	r3, .L1862
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	bne	.L1853
	ldr	r2, .L1862+4
	ldrh	r1, [r2]
	cmp	r1, r0
	bne	.L1854
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L1855:
	ldr	r5, .L1862+8
	mov	r1, r4
	ldr	r0, .L1862+12
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L1857
	ldr	r1, .L1862+16
	mov	r2, #3392
	ldr	r0, .L1862+20
	bl	printf
	ldr	r1, .L1862+24
	ldr	r0, .L1862+28
	bl	printf
.L1857:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	free_data_superblock
	mov	r0, r4
	bl	FtlGcFreeBadSuperBlk
	ldr	r3, .L1862+32
	ldrh	r2, [r5]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldr	r2, .L1862+36
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1861
	ldr	r1, .L1862+16
	movw	r2, #3395
	ldr	r0, .L1862+20
	bl	printf
	ldr	r1, .L1862+24
	ldr	r0, .L1862+28
	bl	printf
.L1861:
	movs	r3, #1
	b	.L1852
.L1854:
	ldr	r2, .L1862+40
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1852
	ldr	r2, .L1862+44
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1852
	ldr	r2, .L1862+48
	ldrh	r2, [r2]
	cmp	r2, r0
	bne	.L1855
.L1852:
	mov	r0, r3
	pop	{r3, r4, r5, pc}
.L1853:
	bl	List_update_data_list
	movs	r3, #0
	b	.L1852
.L1863:
	.align	2
.L1862:
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
	beq	.L1865
	ldr	r5, .L1876
	ldr	r3, [r5]
	ldrh	r2, [r3, r0, lsl #1]
	cmp	r2, #0
	bne	.L1866
	mov	r1, r0
	ldr	r0, .L1876+4
	bl	printf
	ldr	r3, [r5]
	ldrh	r3, [r3, r4, lsl #1]
	cbnz	r3, .L1867
	ldr	r1, .L1876+8
	movw	r2, #3410
	ldr	r0, .L1876+12
	bl	printf
	ldr	r1, .L1876+16
	ldr	r0, .L1876+20
	bl	printf
.L1867:
	ldr	r3, [r5]
	movs	r2, #32
	mov	r1, r4
	ldr	r0, .L1876+24
	strh	r2, [r3, r4, lsl #1]	@ movhi
	bl	test_node_in_list
	cbz	r0, .L1868
	ldr	r6, .L1876+28
	mov	r1, r4
	ldr	r0, .L1876+24
	bl	List_remove_node
	ldrh	r3, [r6]
	cbnz	r3, .L1869
	ldr	r1, .L1876+8
	movw	r2, #3414
	ldr	r0, .L1876+12
	bl	printf
	ldr	r1, .L1876+16
	ldr	r0, .L1876+20
	bl	printf
.L1869:
	ldrh	r3, [r6]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r6]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r3, [r5]
	mov	r1, r4
	ldr	r0, .L1876+32
	ldrh	r2, [r3, r4, lsl #1]
	bl	printf
.L1868:
	mov	r0, r4
	bl	FtlGcRefreshBlock
.L1872:
	movs	r5, #0
	b	.L1864
.L1866:
	subs	r2, r2, #1
	strh	r2, [r3, r0, lsl #1]	@ movhi
.L1865:
	ldr	r6, .L1876+36
	movw	r3, #65535
	ldrh	r0, [r6]
	cmp	r0, r3
	bne	.L1871
	strh	r4, [r6]	@ movhi
	b	.L1872
.L1871:
	cmp	r4, r0
	beq	.L1872
	bl	update_vpc_list
	ldr	r3, .L1876+40
	adds	r5, r0, #0
	ldr	r2, .L1876+44
	it	ne
	movne	r5, #1
	strh	r4, [r6]	@ movhi
	ldr	r3, [r3]
	ldr	r2, [r2]
	subs	r3, r3, r2
	asrs	r2, r3, #1
	ldr	r3, .L1876+48
	muls	r3, r2, r3
	ldr	r2, .L1876
	ldr	r2, [r2]
	uxth	r1, r3
	ldrh	r2, [r2, r1, lsl #1]
	cbnz	r2, .L1864
	cmp	r4, r1
	beq	.L1864
	ldr	r1, .L1876+8
	movw	r2, #3435
	ldr	r0, .L1876+12
	bl	printf
	ldr	r1, .L1876+16
	ldr	r0, .L1876+20
	bl	printf
.L1864:
	mov	r0, r5
	pop	{r4, r5, r6, pc}
.L1877:
	.align	2
.L1876:
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
	beq	.L1878
	ldrh	r2, [r0]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1878
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r5, .L1889
	ldr	r6, .L1889+4
	adds	r3, r3, #8
	ldrh	r3, [r0, r3, lsl #1]
.L1882:
	movw	r2, #65535
	cmp	r3, r2
	beq	.L1884
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1885
	ldrb	r1, [r5]	@ zero_extendqisi2
	cbnz	r1, .L1885
	ldrh	r1, [r4, #2]
	ldrh	r1, [r6, r1, lsl #1]
	cmp	r1, r2
	bne	.L1885
	ldrh	r3, [r4, #4]
	ldrh	r0, [r4]
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	ldrh	r2, [r4, #4]
	cbnz	r2, .L1884
	ldrh	r3, [r4, #2]
	strb	r2, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	pop	{r4, r5, r6, pc}
.L1884:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldr	r2, .L1889+8
	adds	r3, r3, #1
	ldrh	r2, [r2]
	uxtb	r3, r3
	strb	r3, [r4, #6]
	cmp	r2, r3
	bne	.L1883
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
.L1883:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r3, [r4, r3, lsl #1]
	b	.L1882
.L1885:
	ldrb	r2, [r5]	@ zero_extendqisi2
	cbz	r2, .L1878
	cmp	r3, #1
	bne	.L1878
	ldr	r3, .L1889+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1878
	ldr	r3, .L1889+16
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	movs	r3, #0
	ldr	r2, .L1889+20
	strh	r3, [r4, #4]	@ movhi
	strb	r3, [r4, #6]
	ldrh	r2, [r2]
	strh	r2, [r4, #2]	@ movhi
.L1878:
	pop	{r4, r5, r6, pc}
.L1890:
	.align	2
.L1889:
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
	bne	.L1892
	ldr	r1, .L1913
	movw	r2, #3332
	ldr	r0, .L1913+4
	bl	printf
	ldr	r1, .L1913+8
	ldr	r0, .L1913+12
	bl	printf
.L1892:
	ldr	r5, .L1913+16
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L1893
	ldr	r1, .L1913
	movw	r2, #3333
	ldr	r0, .L1913+4
	bl	printf
	ldr	r1, .L1913+8
	ldr	r0, .L1913+12
	bl	printf
.L1893:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1894
	ldr	r1, .L1913
	movw	r2, #3334
	ldr	r0, .L1913+4
	bl	printf
	ldr	r1, .L1913+8
	ldr	r0, .L1913+12
	bl	printf
.L1894:
	movs	r3, #0
	ldr	r7, .L1913+20
	strb	r3, [r4, #10]
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldr	r6, .L1913+24
	adds	r3, r3, #8
	ldrh	r2, [r4, r3, lsl #1]
.L1895:
	movw	r0, #65535
	cmp	r2, r0
	beq	.L1896
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	ldrh	r1, [r4, #2]
	cmp	r3, #1
	ldrh	r3, [r4, #4]
	bne	.L1898
	ldrb	ip, [r6]	@ zero_extendqisi2
	cmp	ip, #0
	bne	.L1898
	ldr	ip, .L1913+28
	ldrh	ip, [ip, r1, lsl #1]
	cmp	ip, r0
	bne	.L1898
	subs	r3, r3, #1
	ldrh	r0, [r4]
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
.L1896:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldrh	r2, [r7]
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r2, r3
	strb	r3, [r4, #6]
	bne	.L1897
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
.L1897:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r2, [r4, r3, lsl #1]
	b	.L1895
.L1898:
	ldr	r8, .L1913+24
	orr	r6, r1, r2, lsl #10
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
.L1899:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	movw	r2, #65535
	ldrh	r0, [r7]
.L1901:
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
	beq	.L1901
	strb	r3, [r4, #6]
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1902
	ldrb	r1, [r8]	@ zero_extendqisi2
	ldrh	r3, [r4, #2]
	cbnz	r1, .L1903
	ldr	r1, .L1913+28
	ldrh	r3, [r1, r3, lsl #1]
	cmp	r3, r2
	bne	.L1902
	ldrh	r3, [r4, #4]
	cbz	r3, .L1902
	subs	r3, r3, #1
	ldrh	r0, [r4]
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	b	.L1899
.L1903:
	ldr	r2, .L1913+32
	ldrh	r2, [r2]
	cmp	r3, r2
	bcc	.L1902
	ldr	r3, .L1913+36
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
.L1902:
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L1891
	ldrh	r3, [r4, #4]
	cbz	r3, .L1891
	ldr	r1, .L1913
	movw	r2, #3378
	ldr	r0, .L1913+4
	bl	printf
	ldr	r1, .L1913+8
	ldr	r0, .L1913+12
	bl	printf
.L1891:
	mov	r0, r6
	pop	{r4, r5, r6, r7, r8, pc}
.L1914:
	.align	2
.L1913:
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
	ldr	r3, .L1935
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r1, [r3]
	str	r3, [sp]
	cmp	r1, #0
	bne	.L1917
	ldr	r3, .L1935+4
	ldr	r7, .L1935+8
	ldr	r8, .L1935+112
	ldr	r4, .L1935+12
	ldr	r6, [r7]
	ldr	r0, [r8]
	ldrh	r2, [r3]
	str	r6, [r4, #12]
	str	r0, [r4, #8]
	strh	r2, [r6, #2]	@ movhi
	movw	r2, #61604
	ldr	r5, .L1935+16
	strh	r2, [r6]	@ movhi
	ldr	r2, [r3, #8]
	ldrh	r3, [r3, #6]
	str	r1, [r6, #8]
	str	r2, [r6, #4]
	strh	r3, [r5, #8]	@ movhi
	ldr	r3, .L1935+20
	ldr	ip, .L1935+116
	ldr	r2, .L1935+24
	ldrh	r3, [r3]
	str	r1, [r6, #12]
	stm	r5, {r2, ip}
	strb	r3, [r5, #10]
	ldr	r3, .L1935+28
	ldrh	r2, [r3]
	ldrh	r1, [r3, #2]
	strh	r2, [r5, #14]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r5, #11]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L1935+32
	strh	r2, [r5, #16]	@ movhi
	ldrh	r2, [r3]
	ldrh	r1, [r3, #2]
	strh	r2, [r5, #18]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r5, #12]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L1935+36
	strh	r2, [r5, #20]	@ movhi
	ldrh	r2, [r3]
	strh	r2, [r5, #22]	@ movhi
	ldrh	r1, [r3, #2]
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r5, #13]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L1935+40
	movs	r1, #255
	strh	r2, [r5, #24]	@ movhi
	ldr	r3, [r3]
	str	r3, [r5, #32]
	ldr	r3, .L1935+44
	ldr	r3, [r3]
	str	r3, [r5, #40]
	ldr	r3, .L1935+48
	ldr	r3, [r3]
	str	r3, [r5, #36]
	ldr	r3, .L1935+52
	ldrh	r3, [r3]
	strh	r3, [r5, #44]	@ movhi
	ldr	r3, .L1935+56
	ldrh	r3, [r3]
	strh	r3, [r5, #46]	@ movhi
	ldr	r3, .L1935+60
	ldrh	r2, [r3]
	bl	ftl_memset
	mov	r1, r5
	ldr	r5, .L1935+64
	movs	r2, #48
	ldr	r0, [r4, #8]
	bl	ftl_memcpy
	ldrh	r2, [r5]
	ldr	r3, .L1935+68
	ldr	r0, [r4, #8]
	ldr	r1, [r3]
	lsls	r2, r2, #1
	adds	r0, r0, #48
	bl	ftl_memcpy
	ldrh	r0, [r5]
	ldr	r3, [r4, #8]
	ldr	r1, .L1935+72
	lsrs	r2, r0, #3
	adds	r0, r0, #24
	lsls	r0, r0, #1
	ldr	r1, [r1]
	adds	r2, r2, #4
	bic	r0, r0, #3
	add	r0, r0, r3
	bl	ftl_memcpy
	ldr	r3, .L1935+76
	str	r7, [sp, #4]
	ldrh	r3, [r3]
	cbz	r3, .L1918
	ldrh	r0, [r5]
	ldr	r3, .L1935+80
	ldr	r1, .L1935+84
	ldrh	r2, [r3]
	lsrs	r3, r0, #3
	ldr	r1, [r1]
	add	r3, r3, r0, lsl #1
	ldr	r0, [r4, #8]
	adds	r3, r3, #52
	lsls	r2, r2, #2
	ubfx	r3, r3, #2, #14
	add	r0, r0, r3, lsl #2
	bl	ftl_memcpy
.L1918:
	ldr	r5, .L1935+4
	movs	r7, #0
	movw	fp, #65535
	movs	r0, #0
	bl	FtlUpdateVaildLpn
	mov	r10, r5
.L1919:
	ldr	r3, [r8]
	ldrh	r2, [r5]
	ldr	r0, .L1935+12
	str	r3, [r4, #8]
	ldr	r3, [sp, #4]
	ldr	r3, [r3]
	str	r3, [r4, #12]
	ldrh	r3, [r5, #2]
	orr	r3, r3, r2, lsl #10
	str	r3, [r4, #4]
	movs	r3, #1
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r3, .L1935+88
	ldrh	r2, [r5, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1920
	ldrh	r3, [r5]
	ldrh	fp, [r5, #4]
	strh	r3, [r5, #4]	@ movhi
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r2, .L1935+44
	strh	r0, [r5]	@ movhi
	ldr	r3, [r2]
	adds	r1, r3, #1
	str	r3, [r5, #8]
	str	r1, [r2]
	lsls	r2, r0, #10
	str	r2, [r4, #4]
	str	r3, [r6, #4]
	movs	r3, #1
	strh	r0, [r6, #2]	@ movhi
	mov	r2, r3
	mov	r1, r3
	ldr	r0, .L1935+12
	bl	FlashProgPages
.L1920:
	ldrh	r3, [r10, #2]
	ldr	r2, [r4]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r1, r2, #1
	strh	r3, [r10, #2]	@ movhi
	bne	.L1921
	cmp	r3, #1
	bne	.L1922
	ldr	r1, .L1935+92
	movw	r2, #1219
	ldr	r0, .L1935+96
	bl	printf
	ldr	r1, .L1935+100
	ldr	r0, .L1935+104
	bl	printf
.L1922:
	ldrh	r3, [r10, #2]
	adds	r7, r7, #1
	uxth	r7, r7
	cmp	r3, #1
	itttt	eq
	ldreq	r3, .L1935+88
	ldrheq	r3, [r3]
	addeq	r3, r3, #-1
	strheq	r3, [r10, #2]	@ movhi
	cmp	r7, #3
	bls	.L1919
	mov	r2, r7
	ldr	r1, [r4, #4]
	ldr	r0, .L1935+108
	bl	printf
	ldr	r2, [sp]
	movs	r3, #1
	str	r3, [r2]
.L1917:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1921:
	cmp	r3, #1
	beq	.L1919
	cmp	r2, #256
	beq	.L1919
	movw	r3, #65535
	cmp	fp, r3
	beq	.L1917
	movs	r1, #1
	mov	r0, fp
	bl	FtlFreeSysBlkQueueIn
	b	.L1917
.L1936:
	.align	2
.L1935:
	.word	.LANCHOR77
	.word	.LANCHOR209
	.word	.LANCHOR188
	.word	.LANCHOR202
	.word	.LANCHOR81
	.word	.LANCHOR45
	.word	1179929683
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
	.word	1342177353
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
	ldr	r3, .L1952
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	sub	sp, sp, #44
	ldr	r8, [r3]
	cmp	r8, #0
	bne	.L1937
	ldr	r3, .L1952+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1948
	ldrb	r3, [r0, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1948
	ldrh	r6, [r0, #4]
	mov	r8, r3
.L1939:
	mov	r3, #-1
	ldr	r2, .L1952+8
	str	r3, [sp, #20]
	movs	r7, #0
	ldr	r3, .L1952+12
	ldr	r5, [r2]
	mvn	r2, #2
	ldr	r10, .L1952+24
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
.L1940:
	adds	r6, r6, #-1
	bcc	.L1943
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1941
.L1943:
	ldr	r3, .L1952+16
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldr	r3, .L1952+20
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
.L1937:
	add	sp, sp, #44
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L1948:
	movs	r6, #12
	b	.L1939
.L1941:
	mov	r0, r4
	bl	get_new_active_ppa
	str	r0, [sp, #8]
	adds	r0, r0, #1
	beq	.L1943
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
	b	.L1940
.L1953:
	.align	2
.L1952:
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
	ldr	r3, .L1964
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r5, .L1964+4
	ldr	r3, [r3]
	ldr	r7, .L1964+8
	ldr	r10, .L1964+20
	str	r3, [r5, #8]
	ldr	r3, .L1964+12
	ldr	r8, [r3]
	str	r8, [r5, #12]
.L1955:
	ldr	r3, .L1964+16
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L1960
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1960:
	ldrh	r4, [r10]
	movw	r3, #65535
	ldr	fp, .L1964+4
	strh	r3, [r7, #2]!	@ movhi
	subs	r4, r4, #1
	uxth	r4, r4
.L1956:
	ldrh	r3, [r10]
	sub	r2, r3, #15
	cmp	r2, r4
	bgt	.L1958
	mla	r3, r6, r3, r4
	movs	r2, #1
	mov	r1, r2
	mov	r0, fp
	lsls	r3, r3, #10
	str	r3, [r5, #4]
	bl	FlashReadPages
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L1957
	ldrh	r2, [r8]
	movw	r3, #61664
	cmp	r2, r3
	bne	.L1957
	strh	r4, [r7]	@ movhi
.L1958:
	adds	r6, r6, #1
	b	.L1955
.L1957:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L1956
.L1965:
	.align	2
.L1964:
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
	ldreq	r3, .L1978
	sub	sp, sp, #104
	lsl	r7, r0, #10
	mov	r2, r1
	it	ne
	ldrne	r3, .L1978+4
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
	bne	.L1969
.L1970:
	cmp	r6, r5
	ble	.L1973
.L1969:
	mov	r0, r5
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1973:
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
	bne	.L1971
	ldr	r3, [sp, #44]
	adds	r3, r3, #1
	bne	.L1971
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L1971
	subs	r4, r4, #1
	sxth	r5, r4
	b	.L1970
.L1971:
	adds	r4, r4, #1
	sxth	r6, r4
	b	.L1970
.L1979:
	.align	2
.L1978:
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
	ldr	r8, .L2009+48
	ldr	r4, .L2009
	ldr	r3, [r8]
	ldr	r7, .L2009+4
	mov	r10, r4
	str	r3, [r4, #8]
	ldr	r3, .L2009+8
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FtlBbtMemInit
	ldrh	r5, [r7]
	subs	r5, r5, #1
	uxth	r5, r5
.L1981:
	ldrh	r3, [r7]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L1984
	lsls	r3, r5, #10
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1982
	ldr	r3, [r4, #4]
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	adds	r3, r3, #1
	str	r3, [r4, #4]
	bl	FlashReadPages
.L1982:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L1983
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L1983
	ldr	r3, .L2009+12
	ldr	r2, [r6, #4]
	strh	r5, [r3]	@ movhi
	str	r2, [r3, #8]
	ldrh	r2, [r6, #8]
	strh	r2, [r3, #4]	@ movhi
.L1984:
	ldr	r5, .L2009+12
	movw	r2, #65535
	ldrh	r3, [r5]
	cmp	r3, r2
	beq	.L1998
	ldrh	r3, [r5, #4]
	cmp	r3, r2
	beq	.L1988
	lsls	r3, r3, #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L2009
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L1988
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L1988
	ldr	r3, [r6, #4]
	ldr	r2, [r5, #8]
	cmp	r3, r2
	bls	.L1988
	ldrh	r2, [r5, #4]
	str	r3, [r5, #8]
	ldrh	r3, [r6, #8]
	strh	r2, [r5]	@ movhi
	strh	r3, [r5, #4]	@ movhi
.L1988:
	ldr	r10, .L2009
	movs	r1, #1
	ldrh	r0, [r5]
	bl	FtlGetLastWrittenPage
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r5, #2]	@ movhi
.L1990:
	cmp	r7, #0
	bge	.L1993
	ldr	r1, .L2009+16
	mov	r2, #336
	ldr	r0, .L2009+20
	bl	printf
	ldr	r1, .L2009+24
	ldr	r0, .L2009+28
	bl	printf
.L1992:
	ldrh	r3, [r6, #10]
	ldrh	r0, [r6, #12]
	strh	r3, [r5, #6]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L1995
	ldr	r3, .L2009+32
	ldr	r2, [r3]
	cmp	r0, r2
	beq	.L1995
	ldr	r3, .L2009+36
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	cmp	r2, r3
	bcs	.L1995
	cmp	r0, r3
	bcs	.L1995
	bl	FtlSysBlkNumInit
.L1995:
	ldr	r6, .L2009+40
	movs	r5, #0
	ldr	r7, .L2009+44
	ldr	r8, .L2009+52
.L1996:
	ldrh	r3, [r7]
	cmp	r5, r3
	bcc	.L1997
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1983:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L1981
.L1993:
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
	beq	.L1991
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	beq	.L1992
.L1991:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L1990
.L1997:
	ldrh	r2, [r8]
	ldr	r1, [r4, #8]
	ldr	r0, [r6, #4]!
	lsls	r2, r2, #2
	mla	r1, r5, r2, r1
	adds	r5, r5, #1
	bl	ftl_memcpy
	b	.L1996
.L1998:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2010:
	.align	2
.L2009:
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
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r3, [r0, #24]
	ldr	r5, [r0, #12]
	str	r3, [sp, #8]
	bl	ftl_free_no_use_map_blk
	ldrh	ip, [r4, #10]
	ldrh	r2, [r4, #8]
	ldrh	r1, [r4, #40]
	sub	r3, ip, #4
	ldr	r6, .L2032
	cmp	r2, r3
	bge	.L2012
	movw	r3, #65535
	cmp	r1, r3
	beq	.L2014
	ldrh	r2, [r4, #2]
	ldrh	r3, [r6]
	cmp	r2, r3
	bcc	.L2015
.L2012:
	movw	r3, #65535
	uxth	r0, r0
	cmp	r1, r3
	beq	.L2016
	ldrh	r3, [r4, #2]
	ldrh	r2, [r6]
	cmp	r2, r3
	bls	.L2017
.L2016:
	ldrh	r3, [r5, r0, lsl #1]
	lsls	r2, r0, #1
	str	r3, [sp, #4]
	cbz	r3, .L2014
	ldr	r3, [r4, #32]
	cbnz	r3, .L2014
	movs	r1, #1
	str	r1, [r4, #32]
	strh	r3, [r5, r2]	@ movhi
	ldrh	r3, [r4, #8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	ldrh	r3, [r6]
	cmp	r2, r3
	bcc	.L2022
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L2022:
	ldr	r5, .L2032+4
	movs	r7, #0
.L2023:
	ldrh	r3, [r4, #6]
	uxth	fp, r7
	cmp	r3, fp
	bhi	.L2028
	movs	r1, #1
	ldr	r0, [sp, #4]
	bl	FtlFreeSysBlkQueueIn
	movs	r3, #0
	str	r3, [r4, #32]
.L2014:
	ldrh	r2, [r4, #2]
	ldrh	r3, [r6]
	cmp	r2, r3
	bcc	.L2015
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
	b	.L2015
.L2020:
	ldrh	r8, [r5, r2, lsl #1]
	add	lr, r2, #1
	cmp	r8, r1
	beq	.L2018
	mov	r2, lr
.L2019:
	uxth	r7, r2
	cmp	r7, ip
	bcc	.L2020
	mov	r7, r0
.L2018:
	uxth	r2, r2
	ldr	r0, .L2032+8
	ldrh	r2, [r5, r2, lsl #1]
	bl	printf
	movw	r3, #65535
	mov	r0, r7
	strh	r3, [r4, #40]	@ movhi
	b	.L2016
.L2017:
	movs	r2, #0
	b	.L2019
.L2028:
	ldr	r3, [sp, #8]
	uxth	r10, r7
	add	r3, r3, r10, lsl #2
	str	r3, [sp, #12]
	ldr	r3, [sp, #8]
	ldr	r2, [r3, r10, lsl #2]
	ldr	r3, [sp, #4]
	cmp	r3, r2, lsr #10
	bne	.L2024
	ldr	r3, .L2032+12
	str	r2, [r5, #4]
	movs	r2, #1
	ldr	r0, .L2032+4
	ldr	r1, [r3]
	str	r1, [r5, #8]
	ldr	r1, .L2032+16
	ldr	r8, [r1]
	mov	r1, r2
	str	r8, [r5, #12]
	bl	FlashReadPages
	ldrh	r2, [r8, #8]
	cmp	r2, fp
	beq	.L2025
	ldr	r1, .L2032+20
	mov	r2, #672
	ldr	r0, .L2032+24
	bl	printf
	ldr	r1, .L2032+28
	ldr	r0, .L2032+32
	bl	printf
.L2025:
	ldr	r2, [r5]
	adds	r2, r2, #1
	ldrh	r2, [r8, #8]
	bne	.L2026
.L2027:
	ldr	r1, [sp, #12]
	movs	r3, #0
	ldr	r0, .L2032+36
	str	r3, [r1]
	ldr	r1, [r5, #4]
	bl	printf
	ldr	r3, .L2032+40
	movs	r2, #1
	str	r2, [r3]
.L2015:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2026:
	cmp	r2, fp
	bne	.L2027
	ldrh	r0, [r8]
	ldrh	r1, [r4, #4]
	cmp	r0, r1
	bne	.L2027
	ldr	r2, [r5, #8]
	mov	r1, r10
	mov	r0, r4
	bl	FtlMapWritePage
.L2024:
	adds	r7, r7, #1
	b	.L2023
.L2033:
	.align	2
.L2032:
	.word	.LANCHOR54
	.word	.LANCHOR202
	.word	.LC39
	.word	.LANCHOR184
	.word	.LANCHOR188
	.word	.LANCHOR212
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC40
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
	ldr	r3, .L2044
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	ldr	r5, [r3]
	cbnz	r5, .L2035
	ldrh	r3, [r0]
	movw	r2, #65535
	ldr	r6, [r0, #12]
	cmp	r3, r2
	bne	.L2036
	ldrh	r3, [r0, #8]
	cbz	r3, .L2037
	ldr	r1, .L2044+4
	mov	r2, #708
	ldr	r0, .L2044+8
	bl	printf
	ldr	r1, .L2044+12
	ldr	r0, .L2044+16
	bl	printf
.L2037:
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
.L2035:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, pc}
.L2036:
	ldrh	r6, [r6, r3, lsl #1]
	movs	r1, #255
	ldrh	r3, [r0, #2]
	ldr	r2, .L2044+20
	ldr	r8, .L2044+32
	ldr	r7, [r0, #24]
	orr	r3, r3, r6, lsl #10
	ldr	r0, [r8]
	str	r3, [r2, #4]
	ldr	r3, .L2044+24
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
	ldr	r3, .L2044+28
	ldrh	r2, [r3]
	lsls	r2, r2, #3
	bl	ftl_memset
	ldrh	ip, [r4, #6]
	mov	r3, r5
	ldr	r1, [r8]
	mov	r2, r5
.L2038:
	uxth	r0, r3
	cmp	ip, r0
	bhi	.L2040
	movs	r2, #1
	movs	r3, #0
	mov	r1, r2
	ldr	r0, .L2044+20
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	mov	r0, r4
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	bl	ftl_map_blk_gc
	b	.L2035
.L2040:
	ldr	r0, [r7, r3, lsl #2]
	cmp	r6, r0, lsr #10
	bne	.L2039
	adds	r2, r2, #1
	uxth	r2, r2
	str	r3, [r1, r2, lsl #3]
	add	r5, r1, r2, lsl #3
	ldr	r0, [r7, r3, lsl #2]
	str	r0, [r5, #4]
.L2039:
	adds	r3, r3, #1
	b	.L2038
.L2045:
	.align	2
.L2044:
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r10, .L2069+36
	mov	r8, r1
	movs	r6, #0
	str	r2, [sp]
.L2047:
	ldr	r2, .L2069
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	ldrh	r3, [r10]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L2048
	ldrh	r2, [r4]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2049
.L2048:
	mov	r0, r4
	bl	Ftl_write_map_blk_to_last_page
.L2049:
	ldr	r3, .L2069+4
	ldr	r2, [r3]
	str	r3, [sp, #4]
	cmp	r2, #0
	bne	.L2064
	ldrh	r2, [r4]
	ldr	r3, [r4, #12]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L2051
	ldr	r1, .L2069+8
	mov	r2, #768
	ldr	r0, .L2069+12
	bl	printf
	ldr	r1, .L2069+16
	ldr	r0, .L2069+20
	bl	printf
.L2051:
	ldrh	r2, [r4]
	ldrh	r3, [r4, #10]
	cmp	r2, r3
	bcc	.L2052
	ldr	r1, .L2069+8
	movw	r2, #769
	ldr	r0, .L2069+12
	bl	printf
	ldr	r1, .L2069+16
	ldr	r0, .L2069+20
	bl	printf
.L2052:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r4, #12]
	ldr	r5, .L2069+24
	ldrh	r7, [r3, r2, lsl #1]
	movs	r2, #16
	ldrh	r3, [r4, #2]
	mov	fp, r5
	orr	r3, r3, r7, lsl #10
	str	r3, [r5, #4]
	ldr	r3, [sp]
	str	r3, [r5, #8]
	ldr	r3, .L2069+28
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
	strh	r2, [r4, #2]	@ movhi
	bne	.L2053
	ldr	r1, [r5, #4]
	adds	r6, r6, #1
	ldr	r0, .L2069+32
	uxth	r6, r6
	bl	printf
	ldrh	r2, [r4, #2]
	cmp	r2, #2
	itttt	ls
	ldrls	r3, .L2069+36
	ldrhls	r2, [r3]
	addls	r2, r2, #-1
	strhls	r2, [r4, #2]	@ movhi
	cmp	r6, #3
	bls	.L2047
	mov	r2, r6
	ldr	r1, [r5, #4]
	ldr	r0, .L2069+40
	bl	printf
	ldr	r2, [sp, #4]
	movs	r3, #1
	str	r3, [r2]
.L2064:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2053:
	cbz	r1, .L2056
	cmp	r2, #1
	strh	r7, [r4, #40]	@ movhi
	beq	.L2047
	cmp	r1, #256
.L2068:
	beq	.L2047
	ldr	r2, [fp, #4]
	ldr	r3, [r4, #24]
	str	r2, [r3, r8, lsl #2]
	b	.L2064
.L2056:
	cmp	r2, #1
	b	.L2068
.L2070:
	.align	2
.L2069:
	.word	.LANCHOR165
	.word	.LANCHOR77
	.word	.LANCHOR214
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR202
	.word	.LANCHOR188
	.word	.LC41
	.word	.LANCHOR54
	.word	.LC42
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
	ldr	r5, .L2072
	muls	r4, r0, r4
	ldr	r0, .L2072+4
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
.L2073:
	.align	2
.L2072:
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
	ldr	r5, .L2078
	ldr	r6, .L2078+4
.L2075:
	ldrh	r3, [r5]
	uxth	r0, r4
	cmp	r3, r0
	bhi	.L2077
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L2077:
	ldr	r2, [r6]
	uxth	r3, r4
	movs	r1, #12
	mla	r3, r1, r3, r2
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L2076
	bl	flush_l2p_region
.L2076:
	adds	r4, r4, #1
	b	.L2075
.L2079:
	.align	2
.L2078:
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
	ldr	r3, .L2092
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	str	r2, [sp]
	adds	r2, r0, r1
	mov	r7, r0
	mov	r5, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L2088
	ldr	r3, .L2092+4
	mov	r8, #0
	ldrh	r6, [r3]
	lsr	r6, r0, r6
	lsl	fp, r6, #2
.L2082:
	cbnz	r5, .L2087
.L2080:
	mov	r0, r8
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2087:
	ldr	r3, .L2092+8
	mov	r0, r7
	ldr	r10, .L2092+24
	ldr	r3, [r3]
	ldr	r2, [r3, fp]
	ldr	r3, .L2092+12
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
	cbz	r2, .L2084
	cmp	r4, r3
	beq	.L2084
	ldr	r3, [r10]
	add	r0, sp, #20
	str	r2, [sp, #24]
	movs	r2, #1
	mov	r1, r2
	str	r3, [sp, #28]
	movs	r3, #0
	str	r3, [sp, #32]
	bl	FlashReadPages
.L2085:
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
	ldr	r0, .L2092+16
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
	b	.L2082
.L2084:
	ldr	r3, .L2092+20
	movs	r1, #0
	ldr	r0, [r10]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L2085
.L2088:
	mov	r8, #-1
	b	.L2080
.L2093:
	.align	2
.L2092:
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
	ldr	r2, .L2096
	ldr	r3, .L2096+4
	ldr	r1, [r2]
	cmp	r1, r3
	bne	.L2094
	ldr	r3, .L2096+8
	movs	r1, #1
	movs	r0, #0
	str	r3, [r2, #4]
	ldr	r3, .L2096+12
	ldr	r3, [r3]
	str	r3, [r2, #88]
	ldr	r3, .L2096+16
	ldr	r3, [r3]
	str	r3, [r2, #92]
	ldr	r3, .L2096+20
	ldr	r3, [r3]
	str	r3, [r2, #8]
	ldr	r3, .L2096+24
	ldr	r3, [r3]
	str	r3, [r2, #12]
	ldr	r3, .L2096+28
	ldr	r3, [r3]
	str	r3, [r2, #16]
	ldr	r3, .L2096+32
	ldr	r3, [r3]
	str	r3, [r2, #20]
	ldr	r3, .L2096+36
	ldr	r3, [r3]
	str	r3, [r2, #28]
	ldr	r3, .L2096+40
	ldr	r3, [r3]
	str	r3, [r2, #32]
	ldr	r3, .L2096+44
	ldr	r3, [r3]
	str	r3, [r2, #36]
	ldr	r3, .L2096+48
	ldr	r3, [r3]
	str	r3, [r2, #40]
	ldr	r3, .L2096+52
	ldr	r3, [r3]
	str	r3, [r2, #44]
	ldr	r3, .L2096+56
	ldr	r3, [r3]
	str	r3, [r2, #48]
	ldr	r3, .L2096+60
	ldr	r3, [r3]
	str	r3, [r2, #60]
	ldr	r3, .L2096+64
	ldr	r3, [r3]
	str	r3, [r2, #64]
	b	FtlVendorPartWrite
.L2094:
	bx	lr
.L2097:
	.align	2
.L2096:
	.word	.LANCHOR138
	.word	1179929683
	.word	1342177353
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
	ldr	r3, .L2105
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L2103
	ldr	r3, .L2105+4
	ldr	r3, [r3]
	cmp	r3, #39
	ite	hi
	movhi	r3, #32
	movls	r3, #4
.L2099:
	ldr	r1, .L2105+8
	ldrh	r2, [r1]
	cmp	r2, #31
	ittt	ls
	addls	r2, r2, #1
	movls	r3, #1
	strhls	r2, [r1]	@ movhi
	ldr	r2, .L2105+12
	cbnz	r0, .L2101
	ldr	r1, [r2]
	ldr	r0, [r1, #20]
	ldr	r1, [r1, #16]
	add	r3, r3, r0
	cmp	r1, r3
	bcc	.L2102
.L2101:
	ldr	r2, [r2]
	movs	r0, #64
	ldr	r3, [r2, #16]
	str	r3, [r2, #20]
	ldr	r3, .L2105+16
	str	r3, [r2]
	ldr	r3, .L2105+20
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
.L2102:
	movs	r0, #0
	pop	{r3, pc}
.L2103:
	movs	r3, #32
	b	.L2099
.L2106:
	.align	2
.L2105:
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
	ldr	r3, .L2134
	push	{r4, r5, r6, lr}
	mov	r4, r0
	ldrh	r5, [r0]
	ldrh	r3, [r3]
	cmp	r3, r5
	bcs	.L2108
	ldr	r1, .L2134+4
	movw	r2, #3289
	ldr	r0, .L2134+8
	bl	printf
	ldr	r1, .L2134+12
	ldr	r0, .L2134+16
	bl	printf
.L2108:
	ldr	r3, .L2134+20
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2109
	movw	r3, #65535
	cmp	r5, r3
	beq	.L2110
	ldr	r3, .L2134+24
	mov	r0, r5
	ldr	r3, [r3]
	ldrh	r3, [r3, r5, lsl #1]
	cbz	r3, .L2111
	bl	INSERT_DATA_LIST
.L2110:
	movs	r3, #0
	strb	r3, [r4, #8]
	ldr	r3, .L2134+28
	cmp	r4, r3
	beq	.L2112
	ldr	r3, .L2134+32
	ldrh	r2, [r3]
	cmp	r2, #1
	beq	.L2112
	ldr	r3, .L2134+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2113
.L2112:
	movs	r3, #1
	strb	r3, [r4, #8]
.L2114:
	ldr	r6, .L2134+40
	movw	r2, #65535
	ldrh	r0, [r6]
	cmp	r0, r2
	beq	.L2119
	cmp	r5, r0
	bne	.L2120
	ldr	r3, .L2134+24
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L2121
.L2120:
	bl	update_vpc_list
.L2121:
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
.L2119:
	mov	r0, r4
	bl	allocate_data_superblock
	bl	l2p_flush
	movs	r0, #0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2109:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L2111:
	bl	INSERT_FREE_LIST
	b	.L2110
.L2113:
	ldr	r3, .L2134+44
	cmp	r4, r3
	bne	.L2114
	cmp	r2, #3
	beq	.L2116
	ldr	r2, .L2134+48
	ldr	r2, [r2]
	cmp	r2, #1
	bne	.L2117
.L2116:
	movs	r2, #1
	strb	r2, [r3, #8]
.L2117:
	ldr	r2, .L2134+52
	ldr	r2, [r2]
	cmp	r2, #0
	beq	.L2114
	ldr	r2, .L2134+56
	ldr	r2, [r2]
	cmp	r2, #39
	itt	ls
	movls	r2, #1
	strbls	r2, [r3, #8]
	b	.L2114
.L2135:
	.align	2
.L2134:
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
	ldr	r3, .L2146
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r2
	adds	r2, r0, r1
	sub	sp, sp, #56
	mov	r7, r0
	mov	r6, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L2145
	ldr	r3, .L2146+4
	mov	r8, #0
	ldr	fp, .L2146+28
	ldrh	r5, [r3]
	lsr	r5, r0, r5
	lsls	r3, r5, #2
	str	r3, [sp]
.L2138:
	cbnz	r6, .L2144
.L2136:
	mov	r0, r8
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2144:
	ldr	r3, .L2146+8
	mov	r0, r7
	ldr	r2, [sp]
	ldr	r3, [r3]
	ldr	r3, [r3, r2]
	ldr	r2, .L2146+12
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
	beq	.L2140
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
	ldr	r2, .L2146+16
	it	eq
	moveq	r8, #-1
	ldr	r2, [r2]
	cmp	r2, #256
	bne	.L2142
	mov	r2, r3
	mov	r1, r5
	ldr	r0, .L2146+20
	bl	printf
	ldr	r2, [fp]
	mov	r1, r5
	ldr	r0, .L2146+24
	bl	FtlMapWritePage
.L2142:
	ldr	r1, [fp]
	lsls	r2, r4, #9
	ldr	r3, [sp, #4]
	mov	r0, r10
	add	r1, r1, r3, lsl #9
	bl	ftl_memcpy
.L2143:
	ldr	r3, [sp, #8]
	adds	r5, r5, #1
	subs	r6, r6, r4
	add	r7, r7, r4
	add	r10, r10, r3
	ldr	r3, [sp]
	adds	r3, r3, #4
	str	r3, [sp]
	b	.L2138
.L2140:
	lsls	r2, r4, #9
	mov	r1, r3
	mov	r0, r10
	bl	ftl_memset
	b	.L2143
.L2145:
	mov	r8, #-1
	b	.L2136
.L2147:
	.align	2
.L2146:
	.word	.LANCHOR50
	.word	.LANCHOR57
	.word	.LANCHOR194
	.word	.LANCHOR56
	.word	.LANCHOR202
	.word	.LC43
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
	ldr	r4, .L2150
	ldr	r5, .L2150+4
	ldr	r2, [r4]
	ldrh	r1, [r5]
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	ldr	r2, [r3]
	ldr	r3, .L2150+8
	cmp	r2, r3
	beq	.L2149
	ldr	r1, .L2150+12
	ldr	r0, .L2150+16
	bl	printf
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r0, [r4]
	lsls	r2, r2, #9
	bl	ftl_memset
.L2149:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2151:
	.align	2
.L2150:
	.word	.LANCHOR191
	.word	.LANCHOR190
	.word	1112818501
	.word	.LC44
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
	ldr	r4, .L2156
	movs	r0, #0
	ldr	r5, .L2156+4
	mov	r2, r4
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	cmp	r3, r5
	beq	.L2153
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	ftl_memset
	str	r5, [r4]
.L2153:
	ldr	r3, [r4]
	cmp	r3, r5
	ldr	r5, .L2156+8
	bne	.L2154
	ldr	r2, [r4, #88]
	ldr	r3, .L2156+12
	str	r2, [r3]
	ldr	r2, [r4, #92]
	ldr	r3, .L2156+16
	str	r2, [r3]
	ldr	r2, [r4, #8]
	ldr	r3, .L2156+20
	str	r2, [r3]
	ldr	r2, [r4, #12]
	ldr	r3, .L2156+24
	str	r2, [r3]
	ldr	r2, [r4, #16]
	ldr	r3, .L2156+28
	str	r2, [r3]
	ldr	r2, [r4, #20]
	ldr	r3, .L2156+32
	str	r2, [r3]
	ldr	r3, [r4, #28]
	ldr	r2, [r4, #32]
	str	r3, [r5]
	ldr	r3, .L2156+36
	str	r2, [r3]
	ldr	r2, [r4, #36]
	ldr	r3, .L2156+40
	str	r2, [r3]
	ldr	r2, [r4, #40]
	ldr	r3, .L2156+44
	str	r2, [r3]
	ldr	r2, [r4, #44]
	ldr	r3, .L2156+48
	str	r2, [r3]
	ldr	r2, [r4, #48]
	ldr	r3, .L2156+52
	str	r2, [r3]
	ldr	r2, [r4, #60]
	ldr	r3, .L2156+56
	str	r2, [r3]
.L2154:
	ldr	r3, .L2156+60
	movs	r2, #0
	str	r2, [r3]
	ldr	r2, [r4, #68]
	ldr	r3, .L2156+64
	cmp	r2, r3
	bne	.L2155
	ldr	r3, .L2156+68
	movs	r2, #1
	ldr	r1, .L2156+72
	ldr	r0, .L2156+76
	str	r2, [r3]
	bl	printf
.L2155:
	ldr	r3, .L2156+80
	ldr	r1, .L2156+84
	ldrh	r2, [r3]
	ldr	r3, .L2156+88
	ldrh	r1, [r1]
	ldr	r0, [r3]
	ldr	r3, [r5]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L2156+92
	str	r0, [r3]
	pop	{r3, r4, r5, pc}
.L2157:
	.align	2
.L2156:
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
	.word	.LC45
	.word	.LC7
	.word	.LANCHOR48
	.word	.LANCHOR40
	.word	.LANCHOR167
	.word	.LANCHOR205
	.size	Ftl_load_ext_data, .-Ftl_load_ext_data
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
	beq	.L2158
	movs	r3, #0
	ldrh	r6, [r0, #6]
	str	r3, [r0, #36]
	ldr	r3, .L2172
	ldr	r10, [r0, #24]
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2158
	ldr	r3, .L2172+4
	ldr	r5, .L2172+8
	ldr	r3, [r3]
	mov	r7, r5
	str	r3, [r5, #8]
	ldr	r3, .L2172+12
	ldr	r8, [r3]
	ldrh	r3, [r0, #2]
	str	r8, [r5, #12]
	cbz	r3, .L2162
	ldr	r2, .L2172+16
	ldrh	r2, [r2]
	subs	r2, r2, #1
	cmp	r3, r2
	bge	.L2162
	ldrh	r2, [r0]
	movw	r1, #65535
	cmp	r2, r1
	beq	.L2162
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
	beq	.L2162
	ldr	r3, [r4, #24]
	ldrh	r1, [r8, #8]
	ldr	r2, [r3, r1, lsl #2]
	ldr	r3, [r5, #4]
	cmp	r2, r3
	bne	.L2162
	ldr	r2, [r5, #8]
.L2171:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	FtlMapWritePage
.L2162:
	subs	r6, r6, #1
	uxth	r6, r6
	ldr	r3, [r10, r6, lsl #2]
	str	r3, [r7, #4]
	cbz	r3, .L2163
	movs	r2, #1
	ldr	r0, .L2172+8
	mov	r1, r2
	bl	FlashReadPages
.L2164:
	ldr	r2, [r7, #8]
	mov	r1, r6
	b	.L2171
.L2163:
	ldr	r3, .L2172+20
	movs	r1, #255
	ldr	r0, [r7, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L2164
.L2158:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2173:
	.align	2
.L2172:
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
	ldr	r5, .L2256
	sub	sp, sp, #32
	mov	r1, r4
	ldr	r3, .L2256+4
	ldr	r2, [r5]
	ldr	r6, .L2256+8
	strh	r4, [r3]	@ movhi
	ldr	r3, .L2256+12
	lsls	r2, r2, #2
	strh	r4, [r6]	@ movhi
	ldr	r7, .L2256+16
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [r5]
	mov	r1, r4
	ldr	r3, .L2256+20
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L2256+24
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L2256+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	movs	r2, #12
	movs	r1, #255
	ldr	r0, .L2256+32
	bl	ftl_memset
	ldr	r3, .L2256+36
	str	r6, [sp, #12]
	str	r5, [sp, #16]
	ldrh	r3, [r3]
	str	r3, [sp, #4]
.L2175:
	ldr	r3, .L2256+40
	ldr	r2, [sp, #4]
	ldrh	r3, [r3]
	cmp	r3, r2
	bls	.L2217
	ldr	r3, .L2256+44
	movs	r5, #0
	ldr	r1, .L2256+48
	mov	fp, r5
	movs	r7, #36
	ldrh	r8, [r3]
	ldr	r3, .L2256+52
	ldr	r2, [r1]
	ldr	r1, .L2256+56
	ldr	r6, [r3]
	ldr	r3, .L2256+60
	str	r2, [sp, #8]
	ldrh	r10, [r1]
	ldr	r3, [r3]
	ldr	r2, .L2256+64
	b	.L2218
.L2177:
	ldrb	r0, [r2, r5]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #28]
	str	r2, [sp, #24]
	bl	V2P_block
	str	r0, [sp, #20]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #28]
	cbnz	r0, .L2176
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
.L2176:
	adds	r5, r5, #1
.L2218:
	uxth	r1, r5
	cmp	r8, r1
	bhi	.L2177
	cmp	fp, #0
	bne	.L2178
.L2216:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #4]
	b	.L2175
.L2178:
	movs	r7, #0
	movs	r2, #1
	mov	r1, fp
	mov	r0, r6
	bl	FlashReadPages
.L2179:
	uxth	r3, r7
	cmp	fp, r3
	bls	.L2216
	ldr	r3, .L2256+52
	mov	r8, #36
	mul	r8, r8, r7
	ldr	r3, [r3]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	ldr	r5, [r2, #4]
	ldr	r6, [r2, #12]
	adds	r3, r3, #1
	ubfx	r5, r5, #10, #16
	bne	.L2182
	mov	r10, #16
.L2184:
	ldr	r3, .L2256+52
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
	ldr	r3, .L2256+52
	ldr	r3, [r3]
	bne	.L2181
	mov	r2, #-1
	str	r2, [r3, r8]
	ldr	r3, .L2256+52
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	cmp	r3, r2
	beq	.L2183
.L2182:
	ldr	r3, .L2256+68
	ldr	r2, [r3]
	ldr	r3, [r6, #4]
	adds	r1, r2, #1
	beq	.L2185
	cmp	r2, r3
	bhi	.L2186
.L2185:
	adds	r2, r3, #1
	ittt	ne
	ldrne	r1, .L2256+68
	addne	r2, r3, #1
	strne	r2, [r1]
.L2186:
	ldrh	r2, [r6]
	movw	r1, #61604
	cmp	r2, r1
	beq	.L2188
	bhi	.L2189
	movw	r3, #61574
	cmp	r2, r3
	beq	.L2190
.L2187:
	adds	r7, r7, #1
	b	.L2179
.L2181:
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L2182
	add	r10, r10, #-1
	uxth	r10, r10
	cmp	r10, #0
	bne	.L2184
.L2183:
	ldr	r3, .L2256+72
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbnz	r1, .L2255
.L2214:
	mov	r0, r5
	bl	FtlFreeSysBlkQueueIn
	b	.L2187
.L2189:
	movw	r3, #61634
	cmp	r2, r3
	beq	.L2191
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2187
.L2255:
	movs	r1, #0
	b	.L2214
.L2191:
	ldr	r3, .L2256+8
	ldrh	r2, [r3]
	ldr	r3, .L2256
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L2193
	ldr	r1, .L2256+76
	movw	r2, #1308
	ldr	r0, .L2256+80
	bl	printf
	ldr	r1, .L2256+84
	ldr	r0, .L2256+88
	bl	printf
.L2193:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #12]
	ldr	r1, [r3]
	ldrh	r0, [r2]
	ldr	r2, .L2256+12
	uxth	r10, r1
	ldr	ip, [r2]
	add	r3, r10, #-1
	sub	r10, r10, r0
	add	r10, r10, #-1
	sxth	r3, r3
	sxth	r10, r10
.L2194:
	cmp	r3, r10
	bgt	.L2200
	cmp	r3, #0
	bge	.L2233
	b	.L2187
.L2200:
	ldr	r2, [ip, r3, lsl #2]
	add	r8, ip, r3, lsl #2
	ldr	r4, [r6, #4]
	cmp	r4, r2
	bls	.L2195
	ldr	r2, [ip]
	cbnz	r2, .L2196
	cmp	r1, r0
	ittt	ne
	ldrne	r2, .L2256+8
	addne	r0, r0, #1
	strhne	r0, [r2]	@ movhi
.L2196:
	ldr	r2, .L2256+20
	uxth	r10, r3
	ldr	r0, [r2]
	movs	r2, #0
.L2197:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L2198
	ldr	r2, [r6, #4]
	cmp	r3, #0
	str	r2, [r8]
	strh	r5, [r0, r3, lsl #1]	@ movhi
	blt	.L2187
	ldr	r2, .L2256+8
	ldrh	r0, [r2]
	ldr	r2, .L2256
	ldr	r2, [r2]
	subs	r2, r2, r0
	subs	r2, r2, #1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L2187
.L2233:
	ldr	r2, .L2256+8
	adds	r0, r0, #1
	strh	r0, [r2]	@ movhi
	ldr	r2, [r6, #4]
	str	r2, [ip, r3, lsl #2]
	ldr	r2, .L2256+20
.L2253:
	ldr	r2, [r2]
	strh	r5, [r2, r3, lsl #1]	@ movhi
	b	.L2187
.L2198:
	add	lr, ip, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, r0, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [ip, r1, lsl #2]
	strh	lr, [r0, r1, lsl #1]	@ movhi
	b	.L2197
.L2195:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L2194
.L2257:
	.align	2
.L2256:
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
.L2190:
	ldr	r8, .L2258+20
	ldr	r10, .L2258+28
	ldrh	r2, [r8]
	ldrh	r3, [r10]
	cmp	r2, r3
	bls	.L2203
	ldr	r1, .L2258
	movw	r2, #1355
	ldr	r0, .L2258+4
	bl	printf
	ldr	r1, .L2258+8
	ldr	r0, .L2258+12
	bl	printf
.L2203:
	ldr	r2, .L2258+16
	ldrh	lr, [r10]
	ldrh	ip, [r8]
	ldr	r0, [r2]
	add	r10, lr, #-1
	sxth	r3, r10
	sub	r10, r10, ip
.L2204:
	cmp	r3, r10
	ble	.L2209
	ldr	r1, [r6, #4]
	add	r8, r0, r3, lsl #2
	ldr	r2, [r0, r3, lsl #2]
	cmp	r1, r2
	bls	.L2205
	ldr	r2, [r0]
	cbnz	r2, .L2206
	cmp	lr, ip
	ittt	ne
	ldrne	r2, .L2258+20
	addne	ip, ip, #1
	strhne	ip, [r2]	@ movhi
.L2206:
	ldr	r2, .L2258+24
	uxth	r10, r3
	ldr	ip, [r2]
	movs	r2, #0
.L2207:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L2208
	ldr	r2, [r6, #4]
	str	r2, [r8]
	strh	r5, [ip, r3, lsl #1]	@ movhi
.L2209:
	cmp	r3, #0
	blt	.L2187
	ldr	r2, .L2258+28
	ldr	ip, .L2258+20
	ldrh	r2, [r2]
	ldrh	r1, [ip]
	subs	r2, r2, #1
	subs	r2, r2, r1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L2187
	ldr	r2, [r6, #4]
	adds	r1, r1, #1
	strh	r1, [ip]	@ movhi
	str	r2, [r0, r3, lsl #2]
	ldr	r2, .L2258+24
	b	.L2253
.L2208:
	add	lr, r0, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, ip, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [r0, r1, lsl #2]
	strh	lr, [ip, r1, lsl #1]	@ movhi
	b	.L2207
.L2205:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L2204
.L2188:
	ldr	r8, .L2258+48
	movw	r2, #65535
	ldrh	r1, [r8]
	cmp	r1, r2
	bne	.L2211
.L2254:
	strh	r5, [r8]	@ movhi
	str	r3, [r8, #8]
	b	.L2187
.L2211:
	ldrh	r0, [r8, #4]
	cmp	r0, r2
	beq	.L2212
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L2212:
	ldr	r3, [r6, #4]
	ldr	r2, [r8, #8]
	cmp	r2, r3
	bcs	.L2213
	ldrh	r2, [r8]
	strh	r2, [r8, #4]	@ movhi
	b	.L2254
.L2213:
	strh	r5, [r8, #4]	@ movhi
	b	.L2187
.L2217:
	ldr	r3, .L2258+32
	ldr	r2, [r3]
	ldrh	r3, [r2]
	cbz	r3, .L2219
.L2222:
	ldr	r3, .L2258+24
	ldr	r4, [r3]
	ldrh	r2, [r4]
	cmp	r2, #0
	beq	.L2220
.L2221:
	ldr	r3, .L2258+36
	ldrh	r2, [r3]
	ldr	r3, .L2258+40
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L2252
	ldr	r1, .L2258
	movw	r2, #1489
	ldr	r0, .L2258+4
	bl	printf
	ldr	r1, .L2258+8
	ldr	r0, .L2258+12
	bl	printf
.L2252:
	movs	r0, #0
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2219:
	ldr	r1, .L2258+36
	ldrh	r1, [r1]
	cmp	r1, #0
	beq	.L2222
	ldr	r5, .L2258+40
	ldr	r0, [r5]
.L2223:
	sxth	r1, r3
	cmp	r1, r0
	bcs	.L2222
	ldrh	r4, [r2, r1, lsl #1]
	adds	r3, r3, #1
	cmp	r4, #0
	beq	.L2223
	ldr	r3, .L2258+44
	movs	r6, #0
	ldr	r0, [r3]
	mov	r3, r1
.L2224:
	ldr	r4, [r5]
	cmp	r3, r4
	bcs	.L2222
	ldrh	r7, [r2, r3, lsl #1]
	subs	r4, r3, r1
	strh	r7, [r2, r4, lsl #1]	@ movhi
	ldr	r7, [r0, r3, lsl #2]
	str	r7, [r0, r4, lsl #2]
	strh	r6, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	sxth	r3, r3
	b	.L2224
.L2220:
	ldr	r3, .L2258+20
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L2221
	ldr	r5, .L2258+28
	ldrh	r1, [r5]
.L2229:
	sxth	r3, r2
	cmp	r3, r1
	mov	r6, r3
	bge	.L2221
	ldrh	r0, [r4, r3, lsl #1]
	adds	r2, r2, #1
	cmp	r0, #0
	beq	.L2229
	ldr	r2, .L2258+16
	movs	r0, #0
	ldr	r2, [r2]
.L2230:
	ldrh	r1, [r5]
	cmp	r3, r1
	bge	.L2221
	ldrh	r7, [r4, r3, lsl #1]
	subs	r1, r3, r6
	strh	r7, [r4, r1, lsl #1]	@ movhi
	ldr	r7, [r2, r3, lsl #2]
	str	r7, [r2, r1, lsl #2]
	adds	r1, r3, #1
	strh	r0, [r4, r3, lsl #1]	@ movhi
	sxth	r3, r1
	b	.L2230
.L2259:
	.align	2
.L2258:
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
	ldr	r8, .L2285+156
	ldr	r5, .L2285
	ldr	r3, [r8]
	ldr	r4, .L2285+4
	ldr	r10, .L2285+160
	ldrh	r2, [r5]
	ldr	r7, .L2285+8
	str	r3, [r4, #8]
	ldr	r6, .L2285+12
	ldr	r3, [r10]
	lsls	r2, r2, #1
	ldr	r0, [r7]
	str	r3, [r4, #12]
	bl	ftl_memset
	ldrh	r0, [r6]
	movw	r3, #65535
	str	r7, [sp]
	cmp	r0, r3
	bne	.L2261
.L2270:
	mov	r0, #-1
.L2260:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2261:
	movs	r1, #1
	mov	fp, r4
	bl	FtlGetLastWrittenPage
	ldr	r3, .L2285+16
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r6, #2]	@ movhi
.L2263:
	cmp	r7, #0
	bge	.L2266
	ldr	r1, .L2285+20
	movw	r2, #1549
	ldr	r0, .L2285+24
	bl	printf
	ldr	r1, .L2285+28
	ldr	r0, .L2285+32
	bl	printf
.L2265:
	ldr	r2, .L2285+36
	ldrh	r3, [r5]
	ldrh	r2, [r2]
	adds	r3, r3, #24
	cmp	r2, r3, lsl #1
	bcs	.L2268
	ldr	r1, .L2285+20
	movw	r2, #1551
	ldr	r0, .L2285+24
	bl	printf
	ldr	r1, .L2285+28
	ldr	r0, .L2285+32
	bl	printf
.L2268:
	movs	r2, #48
	ldr	r1, [r4, #8]
	ldr	r0, .L2285+40
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
	ldr	r3, .L2285+44
	ldr	r0, [r3]
	bl	ftl_memcpy
	ldr	r3, .L2285+48
	ldrh	r3, [r3]
	cbz	r3, .L2269
	ldrh	r1, [r5]
	ldr	r3, .L2285+52
	ldrh	r2, [r3]
	lsrs	r3, r1, #3
	add	r3, r3, r1, lsl #1
	ldr	r1, [r4, #8]
	adds	r3, r3, #52
	lsls	r2, r2, #2
	ubfx	r3, r3, #2, #14
	add	r1, r1, r3, lsl #2
	ldr	r3, .L2285+56
	ldr	r0, [r3]
	bl	ftl_memcpy
.L2269:
	ldr	r4, .L2285+40
	ldr	r3, .L2285+16
	ldr	r2, [r4]
	cmp	r2, r3
	bne	.L2270
	ldr	r3, .L2285+60
	ldrb	r2, [r4, #10]	@ zero_extendqisi2
	ldrh	r5, [r4, #8]
	ldrh	r3, [r3]
	strh	r5, [r6, #6]	@ movhi
	cmp	r2, r3
	bne	.L2270
	ldr	r3, .L2285+64
	ldr	r2, .L2285+68
	str	r5, [r3]
	ldr	r3, .L2285+72
	ldrh	r3, [r3]
	muls	r3, r5, r3
	str	r3, [r2]
	ldr	r2, .L2285+76
	ldrh	r2, [r2]
	muls	r3, r2, r3
	ldr	r2, .L2285+80
	str	r3, [r2]
	ldr	r3, .L2285+84
	ldr	r6, [r3]
	ldr	r3, .L2285+88
	ldrh	r0, [r3, #6]
	ldr	r3, .L2285+92
	subs	r0, r6, r0
	ldrh	r1, [r3]
	subs	r0, r0, r5
	bl	__aeabi_uidiv
	ldr	r3, .L2285+96
	cmp	r5, r6
	strh	r0, [r3]	@ movhi
	bls	.L2271
	ldr	r1, .L2285+20
	movw	r2, #1578
	ldr	r0, .L2285+24
	bl	printf
	ldr	r1, .L2285+28
	ldr	r0, .L2285+32
	bl	printf
.L2271:
	ldrh	r2, [r4, #16]
	ldr	r3, .L2285+100
	ldrh	ip, [r4, #14]
	ldr	r7, .L2285+104
	lsrs	r1, r2, #6
	and	r2, r2, #63
	strb	r2, [r3, #6]
	ldrb	r2, [r4, #11]	@ zero_extendqisi2
	strh	r1, [r3, #2]	@ movhi
	ldr	r1, .L2285+108
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
	ldr	r2, .L2285+112
	strh	r5, [r2]	@ movhi
	ldrh	r5, [r4, #24]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r2, #6]
	ldrb	r5, [r4, #13]	@ zero_extendqisi2
	strh	r6, [r2, #2]	@ movhi
	ldr	r6, [r4, #32]
	strb	r5, [r2, #8]
	ldr	r5, .L2285+116
	str	r3, [r5]
	ldr	r5, .L2285+120
	str	r3, [r5]
	ldr	r5, .L2285+124
	str	r3, [r5]
	ldr	r5, .L2285+128
	str	r3, [r5]
	ldr	r5, .L2285+132
	str	r6, [r5]
	mov	r6, r1
	ldr	r5, .L2285+136
	str	r3, [r5]
	ldr	r5, .L2285+140
	str	r3, [r5]
	ldr	r5, .L2285+144
	ldr	lr, [r4, #40]
	str	r3, [r5]
	ldr	r3, .L2285+148
	ldr	r5, [r3]
	cmp	lr, r5
	mov	r5, r2
	it	hi
	strhi	lr, [r3]
	ldr	r3, .L2285+152
	ldr	r2, [r4, #36]
	ldr	r1, [r3]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3]
	movw	r3, #65535
	cmp	ip, r3
	beq	.L2274
	ldr	r0, .L2285+100
	bl	make_superblock
.L2274:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2275
	ldr	r0, .L2285+108
	bl	make_superblock
.L2275:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2276
	ldr	r0, .L2285+112
	bl	make_superblock
.L2276:
	ldrh	r2, [r7]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2277
	ldr	r0, .L2285+104
	bl	make_superblock
.L2277:
	movs	r0, #0
	b	.L2260
.L2266:
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
	beq	.L2264
	ldr	r2, [r8]
	ldr	r2, [r2]
	cmp	r2, r3
	bne	.L2264
	ldr	r2, [r10]
	ldrh	r1, [r2]
	movw	r2, #61604
	cmp	r1, r2
	beq	.L2265
.L2264:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L2263
.L2286:
	.align	2
.L2285:
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
	ldr	r4, .L2299
	sub	sp, sp, #88
	mov	r8, r1
	ldrh	r3, [r4]
	str	r3, [sp, #24]
	bl	P2V_block_in_plane
	ldr	r1, .L2299+4
	mov	r6, r0
	ldr	r0, .L2299+8
	bl	printf
	ldr	r3, .L2299+12
	mov	r1, r6
	ldr	r0, .L2299+16
	ldr	r3, [r3]
	ldrh	r2, [r3, r6, lsl #1]
	bl	printf
	add	r0, sp, #88
	strh	r6, [r0, #-48]!	@ movhi
	bl	make_superblock
	ldr	r3, .L2299+20
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L2288
	cmp	r8, #0
	bne	.L2297
	mov	r0, r6
	bl	ftl_get_blk_mode
	cmp	r0, #1
	mov	r5, r0
	bne	.L2288
	ldr	r3, .L2299+24
	ldrh	r3, [r3]
	str	r3, [sp, #24]
.L2288:
	movs	r6, #0
	ldrh	r3, [r4]
	ldr	r2, [sp, #24]
	mov	r1, r5
	ldr	r0, .L2299+28
	bl	printf
.L2289:
	ldr	r3, .L2299+32
	movs	r2, #0
	add	ip, sp, #54
	mov	r4, r2
	movw	r10, #65535
	mov	fp, #36
	ldrh	lr, [r3]
	ldr	r3, .L2299+36
	ldr	r0, [r3]
	ldr	r3, .L2299+40
	ldr	r3, [r3]
	str	r3, [sp, #28]
	ldr	r3, .L2299+44
	ldrh	r3, [r3]
	str	r3, [sp, #32]
	ldr	r3, .L2299+48
	ldr	r3, [r3]
	str	r3, [sp, #36]
	ldr	r3, .L2299+52
	ldrh	r8, [r3]
.L2290:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L2292
	ldr	fp, .L2299+56
	mov	r8, #0
	mov	r10, #36
	mov	r2, r5
	mov	r1, r4
	bl	FlashReadPages
.L2293:
	uxth	r3, r8
	cmp	r4, r3
	bhi	.L2294
	adds	r6, r6, #1
	ldr	r3, [sp, #24]
	uxth	r6, r6
	cmp	r3, r6
	bne	.L2289
.L2295:
	movs	r0, #0
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2297:
	movs	r5, #0
	b	.L2288
.L2292:
	ldrh	r3, [ip, #2]!
	cmp	r3, r10
	beq	.L2291
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
.L2291:
	adds	r2, r2, #1
	b	.L2290
.L2294:
	ldr	r3, .L2299+36
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
	b	.L2293
.L2300:
	.align	2
.L2299:
	.word	.LANCHOR53
	.word	.LANCHOR224
	.word	.LC46
	.word	.LANCHOR84
	.word	.LC47
	.word	.LANCHOR8
	.word	.LANCHOR54
	.word	.LC48
	.word	.LANCHOR38
	.word	.LANCHOR180
	.word	.LANCHOR105
	.word	.LANCHOR58
	.word	.LANCHOR106
	.word	.LANCHOR59
	.word	.LC49
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
	ldr	r6, .L2311
	ldr	r1, .L2311+4
	ldr	r0, .L2311+8
	bl	printf
	movs	r3, #0
	str	r3, [sp, #28]
.L2302:
	ldr	r3, .L2311+12
	ldrh	r0, [sp, #28]
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2310
	movs	r0, #0
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2310:
	add	r4, sp, #88
	add	r7, sp, #54
	strh	r0, [r4, #-48]!	@ movhi
	movw	r10, #65535
	bl	ftl_get_blk_mode
	ldr	r3, .L2311+16
	mov	fp, #36
	ldrh	r1, [sp, #28]
	ldr	r2, [r3]
	mov	r3, r0
	ldr	r0, .L2311+20
	ldrh	r2, [r2, r1, lsl #1]
	bl	printf
	mov	r0, r4
	bl	make_superblock
	ldr	r3, .L2311+24
	movs	r2, #0
	ldr	r0, [r6]
	mov	r4, r2
	ldrh	lr, [r3]
	ldr	r3, .L2311+28
	ldr	r3, [r3]
	str	r3, [sp, #32]
	ldr	r3, .L2311+32
	ldrh	ip, [r3]
	ldr	r3, .L2311+36
	ldr	r3, [r3]
	str	r3, [sp, #36]
	ldr	r3, .L2311+40
	ldrh	r8, [r3]
.L2303:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L2305
	ldr	r10, .L2311+44
	movs	r7, #0
	mov	r8, #36
	movs	r2, #0
	mov	r1, r4
	bl	FlashReadPages
.L2306:
	uxth	r3, r7
	cmp	r4, r3
	bhi	.L2307
	ldr	r10, .L2311+48
	movs	r7, #0
	mov	r8, #36
	movs	r2, #1
	mov	r1, r4
	ldr	r0, [r6]
	bl	FlashReadPages
.L2308:
	uxth	r3, r7
	cmp	r4, r3
	bhi	.L2309
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	str	r3, [sp, #28]
	b	.L2302
.L2305:
	ldrh	r3, [r7, #2]!
	cmp	r3, r10
	beq	.L2304
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
.L2304:
	adds	r2, r2, #1
	b	.L2303
.L2307:
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
	b	.L2306
.L2309:
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
	b	.L2308
.L2312:
	.align	2
.L2311:
	.word	.LANCHOR180
	.word	.LANCHOR225
	.word	.LC46
	.word	.LANCHOR41
	.word	.LANCHOR84
	.word	.LC50
	.word	.LANCHOR38
	.word	.LANCHOR105
	.word	.LANCHOR58
	.word	.LANCHOR106
	.word	.LANCHOR59
	.word	.LC51
	.word	.LC52
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
	ldr	r5, .L2338
	str	r3, [sp, #4]
	bl	ftl_memset
	ldr	r3, .L2338+4
	str	r6, [r4, #32]
	str	r6, [r4, #28]
	ldr	r2, [r3]
	str	r3, [sp, #8]
	str	r2, [r5, #8]
	ldr	r2, .L2338+8
	ldr	r7, [r2]
	movw	r2, #65535
	str	r7, [r5, #12]
	strh	r2, [r4]	@ movhi
	strh	r2, [r4, #2]	@ movhi
	movs	r2, #1
	str	r2, [r4, #36]
.L2314:
	ldr	r2, [sp, #4]
	sxth	r3, r6
	cmp	r3, r2
	bge	.L2332
	ldr	r2, [sp, #4]
	subs	r2, r2, #1
	cmp	r3, r2
	lsl	r2, r3, #1
	bne	.L2315
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
	ldr	r3, .L2338
.L2316:
	sxth	r2, r6
	cmp	r2, r10
	ble	.L2319
.L2332:
	mov	r0, r4
	bl	ftl_free_no_use_map_blk
	ldr	r3, .L2338+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2321
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L2321:
	mov	r0, r4
	bl	ftl_map_blk_gc
	mov	r0, r4
	bl	ftl_map_blk_gc
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2319:
	ldrh	r1, [r5]
	ldr	r0, .L2338
	str	r3, [sp, #4]
	orr	r2, r2, r1, lsl #10
	str	r2, [r3, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r3, [sp, #4]
	ldr	r2, [r3]
	adds	r2, r2, #1
	beq	.L2317
	ldrh	r2, [r7, #8]
	cmp	fp, r2
	bls	.L2318
	ldrh	r0, [r7]
	ldrh	r1, [r4, #4]
	cmp	r0, r1
	bne	.L2318
	ldr	r1, [r3, #4]
	str	r1, [r8, r2, lsl #2]
.L2318:
	adds	r6, r6, #1
	b	.L2316
.L2317:
	ldrh	r2, [r5]
	strh	r2, [r4, #40]	@ movhi
	b	.L2318
.L2315:
	ldr	r1, [sp, #8]
	add	r2, r10, r2
	str	r2, [sp, #16]
	ldr	r0, .L2338
	ldr	r1, [r1]
	str	r1, [r5, #8]
	ldrh	r1, [r10, r3, lsl #1]
	ldr	r3, .L2338+12
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
	beq	.L2334
	ldrh	r1, [r7]
	ldrh	r2, [r4, #4]
	ldr	r3, [sp, #20]
	cmp	r1, r2
	bne	.L2334
	ldrh	r1, [r7, #8]
	movw	r2, #64245
	cmp	r1, r2
	beq	.L2323
.L2334:
	movs	r3, #0
.L2324:
	ldr	r1, .L2338+12
	sxth	r2, r3
	ldrh	r1, [r1]
	cmp	r2, r1
	bge	.L2330
	str	r3, [sp, #20]
	ldr	r3, [sp, #16]
	ldr	r0, .L2338
	ldrh	r1, [r3]
	orr	r2, r2, r1, lsl #10
	str	r2, [r5, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [r5]
	ldr	r3, [sp, #20]
	adds	r2, r2, #1
	beq	.L2328
	ldrh	r2, [r7, #8]
	cmp	fp, r2
	bls	.L2328
	ldrh	r1, [r4, #4]
	ldrh	r0, [r7]
	cmp	r0, r1
	itt	eq
	ldreq	r1, [r5, #4]
	streq	r1, [r8, r2, lsl #2]
.L2328:
	adds	r3, r3, #1
	b	.L2324
.L2323:
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r3, [sp, #8]
	subs	r2, r2, #1
	ldr	ip, [r3]
.L2325:
	sxth	r3, r1
	cmp	r3, r2
	blt	.L2327
.L2330:
	adds	r6, r6, #1
	b	.L2314
.L2327:
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
	b	.L2325
.L2339:
	.align	2
.L2338:
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
	ldr	r3, .L2341
	ldr	r0, .L2341+4
	ldrh	r3, [r3]
	strh	r3, [r0, #10]	@ movhi
	movw	r3, #61574
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L2341+8
	ldrh	r3, [r3]
	strh	r3, [r0, #8]	@ movhi
	ldr	r3, .L2341+12
	ldrh	r3, [r3]
	strh	r3, [r0, #6]	@ movhi
	ldr	r3, .L2341+16
	ldr	r3, [r3]
	str	r3, [r0, #12]
	ldr	r3, .L2341+20
	ldr	r3, [r3]
	str	r3, [r0, #16]
	ldr	r3, .L2341+24
	ldr	r3, [r3]
	str	r3, [r0, #20]
	ldr	r3, .L2341+28
	ldr	r3, [r3]
	str	r3, [r0, #24]
	movw	r3, #65535
	strh	r3, [r0, #40]	@ movhi
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L2342:
	.align	2
.L2341:
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
	ldr	r0, .L2344
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L2345:
	.align	2
.L2344:
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
	ldr	r3, .L2373
	movw	r2, #65535
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	mov	r5, r0
	ldrh	r4, [r3]
	str	r3, [sp, #16]
	cmp	r4, r2
	beq	.L2364
	cbnz	r4, .L2347
.L2348:
	bl	FtlGcPageVarInit
	b	.L2349
.L2364:
	movs	r4, #0
.L2347:
	ldr	r3, .L2373+4
	ldrh	r3, [r3]
	cmp	r3, r1
	beq	.L2348
.L2349:
	ldr	fp, .L2373+44
	mov	r3, #-1
	str	r3, [sp, #8]
.L2361:
	ldrh	r2, [r5]
	movw	r3, #65535
	movs	r0, #0
	strb	r0, [r5, #8]
	cmp	r2, r3
	beq	.L2350
.L2363:
	ldr	r3, .L2373+8
	movw	ip, #65535
	ldr	r0, [fp]
	mov	lr, #36
	ldrh	r8, [r3]
	ldr	r3, .L2373+12
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2373+16
	ldrh	r10, [r3]
	add	r3, r5, #16
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r6, r3
.L2351:
	uxth	r2, r3
	cmp	r8, r2
	bhi	.L2353
	movs	r7, #0
	mov	r10, #36
	movs	r2, #0
	mov	r1, r6
	bl	FlashReadPages
.L2354:
	uxth	r3, r7
	cmp	r6, r3
	bhi	.L2362
	ldr	r3, .L2373+4
	adds	r4, r4, #1
	uxth	r4, r4
	ldrh	r3, [r3]
	cmp	r3, r4
	bhi	.L2363
	movs	r0, #0
	b	.L2350
.L2353:
	ldr	r1, [sp, #4]
	ldrh	r2, [r1], #2
	cmp	r2, ip
	str	r1, [sp, #4]
	beq	.L2352
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
.L2352:
	adds	r3, r3, #1
	b	.L2351
.L2362:
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
	cbnz	r2, .L2355
	ldr	r3, [sp, #12]
	movw	ip, #65535
	adds	r7, r7, #1
	ldr	r3, [r3, #12]
	ldrh	r2, [r3]
	cmp	r2, ip
	bne	.L2356
	ldr	r3, .L2373+20
	movs	r2, #1
	str	r2, [r3]
.L2350:
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
.L2356:
	ldr	r2, [r3, #8]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L2354
.L2355:
	mov	r2, r1
	ldr	r0, .L2373+24
	ldrh	r1, [r5]
	bl	printf
	ldr	r3, .L2373+28
	ldrh	r2, [r5]
	ldr	r3, [r3]
	cbnz	r3, .L2357
	ldr	r3, .L2373+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2358
.L2357:
	ldr	r3, .L2373+36
	ldr	r3, [r3]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r3, #159
	bls	.L2359
.L2358:
	ldr	r3, [fp]
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L2360
.L2359:
	ldr	r3, [fp]
	add	r3, r3, r8
	ldr	r3, [r3, #4]
	str	r3, [sp, #8]
.L2360:
	ldr	r3, .L2373+40
	movs	r4, #0
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5]
	bl	INSERT_FREE_LIST
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
	bl	FtlGcPageVarInit
	b	.L2361
.L2374:
	.align	2
.L2373:
	.word	.LANCHOR226
	.word	.LANCHOR53
	.word	.LANCHOR38
	.word	.LANCHOR106
	.word	.LANCHOR59
	.word	.LANCHOR135
	.word	.LC53
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
	ldr	r2, .L2388
	sub	sp, sp, #48
	mov	r6, r1
	mov	r4, r0
	ldr	r7, .L2388+4
	ldrh	r3, [r2, #14]
	ldrh	r2, [r2, #12]
	smulbb	r3, r3, r2
	ldr	r2, [r7]
	uxth	r3, r3
	str	r2, [sp, #20]
	ldr	r2, .L2388+8
	subs	r5, r3, #1
	mul	r10, r6, r3
	uxth	r5, r5
	subs	r3, r3, #15
	ldr	r1, [r2]
	mov	r8, r2
	str	r1, [sp, #24]
.L2376:
	cmp	r3, r5
	ble	.L2383
	mov	r0, #-1
	b	.L2375
.L2383:
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
	beq	.L2377
	ldr	r2, [r8]
	ldrh	r1, [r2]
	movw	r2, #61664
	cmp	r1, r2
	bne	.L2377
	cbz	r4, .L2384
	cbz	r6, .L2379
.L2382:
	mov	r2, fp
	ldr	r1, [r7]
	mov	r0, r4
	bl	ftl_memcpy
	movs	r3, #4
	ldr	r0, .L2388+12
	mov	r2, r3
	mov	r1, r4
	bl	rknand_print_hex
	movs	r0, #0
.L2375:
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2379:
	ldr	r1, [r7]
	mov	ip, #1
	ldr	r5, .L2388+16
.L2380:
	ldr	r0, [r5]
	uxth	r3, r6
	adds	r6, r6, #1
	cmp	r3, r0
	bcs	.L2382
	lsrs	r0, r3, #5
	and	r3, r3, #31
	lsl	r3, ip, r3
	ldr	r2, [r1, r0, lsl #2]
	orrs	r3, r3, r2
	str	r3, [r1, r0, lsl #2]
	b	.L2380
.L2377:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2376
.L2384:
	mov	r0, r4
	b	.L2375
.L2389:
	.align	2
.L2388:
	.word	.LANCHOR15
	.word	.LANCHOR147
	.word	.LANCHOR197
	.word	.LC54
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
	ldr	r3, .L2400
	ldr	r6, .L2400+4
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
	bne	.L2391
.L2395:
	movs	r3, #0
.L2392:
	movw	r2, #65535
	movs	r0, #0
	strh	r2, [r5, r3, lsl #1]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L2391:
	ldr	r7, [r6]
	movs	r2, #0
	lsr	ip, r4, #4
	mov	r3, r2
	subs	r4, r4, #1
	mov	lr, #1
.L2393:
	uxth	r1, r2
	cmp	r1, r4
	bge	.L2392
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
	bcc	.L2393
	b	.L2395
.L2401:
	.align	2
.L2400:
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
	ldr	r3, .L2422
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r7, [r3]
	cmp	r7, #0
	bne	.L2403
	ldr	r8, .L2422+40
	ldr	r4, .L2422+4
	bl	FtlBbtMemInit
	sub	r10, r8, #18
	bl	FtlLoadFactoryBbt
.L2404:
	ldr	r3, .L2422+8
	ldrh	r3, [r3]
	cmp	r7, r3
	bcc	.L2410
	ldr	r5, .L2422+12
	movs	r4, #0
.L2411:
	ldrh	r3, [r5]
	uxth	r0, r4
	adds	r4, r4, #1
	cmp	r3, r0
	bhi	.L2412
	ldr	r4, .L2422+16
	movw	r6, #65535
	ldrh	r5, [r4, #12]
	subs	r5, r5, #1
	uxth	r5, r5
.L2413:
	ldrh	r3, [r4, #12]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L2417
	mov	r0, r5
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L2414
	mov	r0, r5
	bl	FlashTestBlk
	cmp	r0, #0
	beq	.L2415
	mov	r0, r5
	bl	FtlBbmMapBadBlock
.L2414:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2413
.L2410:
	ldr	r3, .L2422+20
	movw	r1, #65535
	ldrh	r2, [r10, #2]!
	ldr	r0, [r3]
	ldr	r3, .L2422+24
	cmp	r2, r1
	str	r0, [r4, #8]
	ldr	fp, [r3]
	str	r3, [sp, #4]
	ldr	r3, .L2422+28
	str	fp, [r4, #12]
	beq	.L2405
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
.L2406:
	uxth	r0, r6
	adds	r7, r7, #1
	add	r8, r8, #4
	bl	FtlBbmMapBadBlock
	b	.L2404
.L2405:
	mov	r1, r7
	str	r3, [sp]
	bl	FlashGetBadBlockList
	ldr	r1, [r8]
	ldr	r0, [r4, #8]
	bl	FtlBbt2Bitmap
	ldr	r3, [sp]
	ldrh	r5, [r3]
.L2408:
	subs	r5, r5, #1
	uxth	r5, r5
.L2407:
	ldr	r3, [sp]
	ldrh	r0, [r3]
	smlabb	r0, r0, r7, r5
	uxth	r0, r0
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L2408
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
	ldr	r3, .L2422+32
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
	bne	.L2406
	uxth	r0, r6
	bl	FtlBbmMapBadBlock
	b	.L2407
.L2412:
	bl	FtlBbmMapBadBlock
	b	.L2411
.L2415:
	ldrh	r3, [r4]
	cmp	r3, r6
	bne	.L2416
	strh	r5, [r4]	@ movhi
	b	.L2414
.L2416:
	strh	r5, [r4, #4]	@ movhi
.L2417:
	ldr	r3, .L2422+36
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
.L2403:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2423:
	.align	2
.L2422:
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
	ldr	r3, .L2443
	str	r1, [sp, #4]
	ldrh	r5, [r3]
	str	r2, [sp, #8]
	adds	r3, r5, #7
	movs	r5, #1
	lsr	r8, r0, r3
	lsls	r5, r5, r3
	ldr	r3, .L2443+4
	subs	r5, r5, #1
	uxth	r7, r8
	ands	r5, r5, r0
	ldr	r3, [r3]
	uxth	r5, r5
	cmp	r0, r3
	bcc	.L2425
	ldr	r1, .L2443+8
	mov	r2, #888
	ldr	r0, .L2443+12
	bl	printf
	ldr	r1, .L2443+16
	ldr	r0, .L2443+20
	bl	printf
.L2425:
	ldr	r6, .L2443+24
	movs	r4, #12
	ldr	r3, .L2443+28
	ldr	r1, [r6]
	ldrh	r2, [r3]
	movs	r3, #0
.L2426:
	uxth	r10, r3
	cmp	r10, r2
	bcc	.L2431
	bl	select_l2p_ram_region
	muls	r4, r0, r4
	ldr	r3, [r6]
	mov	r10, r0
	ldrh	r1, [r3, r4]
	adds	r2, r3, r4
	movw	r3, #65535
	cmp	r1, r3
	beq	.L2432
	ldr	r3, [r2, #4]
	cmp	r3, #0
	bge	.L2432
	bl	flush_l2p_region
.L2432:
	ldr	r3, .L2443+32
	ldrh	r2, [r3]
	str	r3, [sp, #12]
	cmp	r2, r7
	bcs	.L2433
	ldr	r1, .L2443+36
	movw	r2, #526
	ldr	r0, .L2443+12
	bl	printf
	ldr	r1, .L2443+16
	ldr	r0, .L2443+20
	bl	printf
.L2433:
	ldr	r3, .L2443+40
	uxth	r8, r8
	ldr	r3, [r3]
	ldr	fp, [r3, r8, lsl #2]
	cmp	fp, #0
	bne	.L2434
	ldr	r3, [r6]
	movs	r1, #255
	ldr	r2, .L2443+44
	add	r3, r3, r4
	ldrh	r2, [r2]
	ldr	r0, [r3, #8]
	bl	ftl_memset
	ldr	r3, [r6]
	adds	r2, r3, r4
	strh	r7, [r3, r4]	@ movhi
	str	fp, [r2, #4]
	b	.L2427
.L2431:
	adds	r3, r3, #1
	mla	r0, r4, r3, r1
	ldrh	r0, [r0, #-12]
	cmp	r0, r7
	bne	.L2426
.L2427:
	ldr	r2, [sp, #8]
	movs	r3, #12
	ldr	r1, .L2443+24
	cbnz	r2, .L2428
	ldr	r2, [r1]
	mla	r3, r3, r10, r2
	ldr	r2, [sp, #4]
	ldr	r3, [r3, #8]
	ldr	r3, [r3, r5, lsl #2]
	str	r3, [r2]
.L2429:
	ldr	r2, [r1]
	movs	r3, #12
	mla	r10, r3, r10, r2
	ldr	r3, [r10, #4]
	adds	r2, r3, #1
	beq	.L2440
	adds	r3, r3, #1
	str	r3, [r10, #4]
.L2440:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2428:
	ldr	r2, [r6]
	mla	r3, r3, r10, r2
	ldr	r2, [sp, #4]
	ldr	r0, [r2]
	ldr	r2, [r3, #8]
	str	r0, [r2, r5, lsl #2]
	ldr	r2, [r3, #4]
	orr	r2, r2, #-2147483648
	str	r2, [r3, #4]
	ldr	r3, .L2443+48
	strh	r7, [r3]	@ movhi
	b	.L2429
.L2434:
	ldr	r2, [r6]
	ldr	r3, .L2443+52
	add	r2, r2, r4
	ldr	r2, [r2, #8]
	mov	r0, r3
	str	fp, [r3, #4]
	str	r3, [sp]
	str	r2, [r3, #8]
	ldr	r2, .L2443+56
	ldr	r2, [r2]
	str	r2, [r3, #12]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r3, [sp]
	ldr	r2, [r3, #12]
	ldr	r3, [r3]
	str	r2, [sp]
	cmp	r3, #256
	bne	.L2435
	mov	r2, fp
	mov	r1, r8
	ldr	r0, .L2443+60
	bl	printf
	ldr	r0, .L2443+64
	lsr	r3, fp, #10
	mov	r1, r8
	strh	r3, [r0, #40]	@ movhi
	ldr	r3, [r6]
	add	r3, r3, r4
	ldr	r2, [r3, #8]
	bl	FtlMapWritePage
.L2435:
	ldr	r3, [sp]
	ldrh	r3, [r3, #8]
	cmp	r3, r7
	beq	.L2436
	mov	r2, fp
	mov	r1, r8
	ldr	r0, .L2443+68
	bl	printf
	ldr	r1, .L2443+52
	movs	r3, #4
	mov	r2, r3
	ldr	r0, .L2443+72
	ldr	r1, [r1, #12]
	bl	rknand_print_hex
	ldr	r3, [sp, #12]
	movs	r2, #4
	ldr	r1, .L2443+40
	ldr	r0, .L2443+76
	ldrh	r3, [r3]
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r3, .L2443+80
	movs	r2, #1
	str	r2, [r3]
.L2436:
	ldr	r3, [sp]
	ldrh	r3, [r3, #8]
	cmp	r3, r7
	beq	.L2437
	ldr	r1, .L2443+36
	movw	r2, #553
	ldr	r0, .L2443+12
	bl	printf
	ldr	r1, .L2443+16
	ldr	r0, .L2443+20
	bl	printf
.L2437:
	ldr	r3, .L2443+24
	movs	r1, #0
	ldr	r3, [r3]
	adds	r2, r3, r4
	str	r1, [r2, #4]
	strh	r7, [r3, r4]	@ movhi
	b	.L2427
.L2444:
	.align	2
.L2443:
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
	.word	.LANCHOR202
	.word	.LANCHOR188
	.word	.LC55
	.word	.LANCHOR127
	.word	.LC56
	.word	.LC27
	.word	.LC57
	.word	.LANCHOR77
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
	ldr	r3, .L2465
	mov	r5, r0
	mov	r10, r1
	ldr	r7, [r3]
	mov	r8, r3
	cbnz	r7, .L2445
	ldr	r3, .L2465+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2460
	ldrb	r6, [r4, #8]	@ zero_extendqisi2
	subs	r3, r6, #1
	rsbs	r6, r3, #0
	adcs	r6, r6, r3
.L2447:
	ldr	fp, .L2465+40
	mov	r2, r6
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	mov	r1, r10
	mov	r0, r5
	bl	FlashProgPages
.L2448:
	cmp	r7, r10
	bne	.L2458
	ldr	r3, .L2465+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2445
	ldr	r1, .L2465+12
	mov	r2, #1600
	ldr	r0, .L2465+16
	bl	printf
	ldr	r1, .L2465+20
	ldr	r0, .L2465+24
	bl	printf
.L2445:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2460:
	mov	r6, r7
	b	.L2447
.L2451:
	ldr	r0, [r5, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r4]
	cmp	r3, r0
	bne	.L2449
	ldr	r1, [fp]
	ldrh	r0, [r4, #4]
	ldrh	r2, [r1, r3, lsl #1]
	subs	r2, r2, r0
	strh	r2, [r1, r3, lsl #1]	@ movhi
	ldr	r3, .L2465+28
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
.L2449:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L2450
	mov	r0, r4
	bl	allocate_new_data_superblock
.L2450:
	ldr	r2, .L2465+32
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
	bne	.L2445
.L2458:
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L2451
	ldr	r3, .L2465+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2452
	ldr	r1, .L2465+12
	movw	r2, #1583
	ldr	r0, .L2465+16
	bl	printf
	ldr	r1, .L2465+20
	ldr	r0, .L2465+24
	bl	printf
.L2452:
	ldr	r3, [r5, #4]
	cbnz	r6, .L2453
.L2464:
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
	beq	.L2455
	ldr	r2, [fp]
	ldrh	r2, [r2, r0, lsl #1]
	cbnz	r2, .L2456
	mov	r1, r0
	str	r0, [sp, #4]
	ldr	r0, .L2465+36
	bl	printf
	ldr	r3, [sp, #4]
.L2456:
	mov	r0, r3
	bl	decrement_vpc_count
.L2455:
	adds	r7, r7, #1
	adds	r5, r5, #36
	b	.L2448
.L2453:
	orr	r3, r3, #-2147483648
	b	.L2464
.L2466:
	.align	2
.L2465:
	.word	.LANCHOR77
	.word	.LANCHOR8
	.word	.LANCHOR38
	.word	.LANCHOR229
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR53
	.word	.LANCHOR138
	.word	.LC58
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
	ldr	r3, .L2472
	ldr	r4, [r3]
	cbnz	r4, .L2468
	ldr	r5, .L2472+4
	ldr	r0, [r5]
	cbz	r0, .L2468
	ldr	r3, .L2472+8
	mov	r2, r4
	movs	r1, #1
	ldr	r3, [r3]
	bl	FtlProgPages
	str	r4, [r5]
.L2468:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2473:
	.align	2
.L2472:
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
	ldr	r3, .L2476
	ldr	r3, [r3]
	cbnz	r3, .L2475
	bl	FtlCacheWriteBack
	bl	l2p_flush
	movs	r0, #1
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2475:
	movs	r0, #0
	pop	{r3, pc}
.L2477:
	.align	2
.L2476:
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
	ldr	r3, .L2480
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L2479
	bl	FtlSysFlush
.L2479:
	movs	r0, #0
	pop	{r3, pc}
.L2481:
	.align	2
.L2480:
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
	ldr	r3, .L2498
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r5, r2
	adds	r2, r1, r2
	mov	r6, r1
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L2491
	cmp	r5, #31
	bhi	.L2485
.L2486:
	movs	r0, #0
.L2483:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2485:
	ldr	r3, .L2498+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2486
	ldr	r8, .L2498+16
	bl	FtlCacheWriteBack
	mov	r0, r6
	ldrh	r4, [r8]
	mov	r1, r4
	bl	__aeabi_uidiv
	smulbb	r3, r0, r4
	mov	r7, r0
	subs	r6, r6, r3
	uxth	r6, r6
	cbz	r6, .L2487
	subs	r4, r4, r6
	adds	r7, r7, #1
	cmp	r4, r5
	it	cs
	movcs	r4, r5
	uxth	r4, r4
	subs	r5, r5, r4
.L2487:
	ldr	r4, .L2498+8
	mov	r3, #-1
	ldr	r6, .L2498+12
	str	r3, [sp, #4]
.L2488:
	ldrh	r3, [r8]
	cmp	r5, r3
	bcs	.L2490
	ldr	r3, .L2498+8
	ldr	r2, [r3]
	cmp	r2, #32
	bls	.L2486
	movs	r4, #0
	str	r4, [r3]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L2486
.L2490:
	movs	r2, #0
	mov	r1, sp
	mov	r0, r7
	bl	log2phys
	ldr	r3, [sp]
	adds	r3, r3, #1
	beq	.L2489
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
.L2489:
	ldrh	r3, [r8]
	adds	r7, r7, #1
	subs	r5, r5, r3
	b	.L2488
.L2491:
	mov	r0, #-1
	b	.L2483
.L2499:
	.align	2
.L2498:
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
	ldr	r7, .L2514
	sub	sp, sp, #32
	movs	r1, #0
	ldr	r8, .L2514+24
	ldr	r0, .L2514+4
	bl	printf
.L2501:
	ldr	r3, [r7]
	cmp	r5, r3
	bcc	.L2507
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2507:
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r5
	bl	log2phys
	ubfx	r3, r5, #0, #11
	cbnz	r3, .L2502
	ldr	r2, [sp, #28]
	mov	r1, r5
	mov	r0, r8
	bl	printf
.L2502:
	ldr	r3, [sp, #28]
	adds	r2, r3, #1
	beq	.L2504
	ldr	r4, .L2514+8
	movs	r2, #0
	movs	r1, #1
	str	r3, [r4, #4]
	mov	r0, r4
	ldr	r3, .L2514+12
	str	r5, [r4, #16]
	str	r2, [r4]
	ldr	r3, [r3]
	str	r3, [r4, #8]
	ldr	r3, .L2514+16
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FlashReadPages
	ldr	r3, [r4]
	cmp	r3, #256
	beq	.L2505
	adds	r3, r3, #1
	beq	.L2505
	ldr	r3, [r6, #8]
	cmp	r5, r3
	beq	.L2504
.L2505:
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #12]
	ldr	r0, .L2514+20
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
.L2504:
	adds	r5, r5, #1
	b	.L2501
.L2515:
	.align	2
.L2514:
	.word	.LANCHOR73
	.word	.LC59
	.word	.LANCHOR202
	.word	.LANCHOR183
	.word	.LANCHOR188
	.word	.LC61
	.word	.LC60
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
	ldr	r5, .L2526
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r2, [r5]
	mov	r7, r0
	ldrh	r3, [r2, r0, lsl #1]
	cmp	r3, #0
	bne	.L2517
	ldr	r2, .L2526+4
	ldr	r4, [r2]
	cmp	r4, #0
	beq	.L2518
	ldr	r2, .L2526+8
	movw	lr, #65535
	ldr	ip, .L2526+32
	ldr	r0, .L2526+12
	ldr	r2, [r2]
	ldrh	r1, [r0]
	mov	r8, r0
	subs	r4, r4, r2
	asrs	r4, r4, #1
	mul	r4, ip, r4
	mov	ip, #6
	uxth	r4, r4
.L2519:
	uxth	r0, r3
	cmp	r1, r0
	bls	.L2518
	cmp	r4, r7
	bne	.L2520
	mov	r1, r4
	ldr	r0, .L2526+4
	bl	List_remove_node
	ldrh	r3, [r8]
	cbnz	r3, .L2521
	ldr	r1, .L2526+16
	movw	r2, #2140
	ldr	r0, .L2526+20
	bl	printf
	ldr	r1, .L2526+24
	ldr	r0, .L2526+28
	bl	printf
.L2521:
	ldrh	r3, [r8]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r8]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r2, [r5]
	ldrh	r3, [r2, r7, lsl #1]
.L2517:
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	b	.L2518
.L2520:
	mul	r4, ip, r4
	adds	r3, r3, #1
	ldrh	r4, [r2, r4]
	cmp	r4, lr
	bne	.L2519
.L2518:
	movs	r2, #1
	add	r1, sp, #4
	mov	r0, r6
	bl	log2phys
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2527:
	.align	2
.L2526:
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
	beq	.L2689
	ldrh	r3, [r0, #2]
	str	r3, [sp, #12]
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	str	r3, [sp, #28]
	ldr	r3, .L2698
	ldrh	r3, [r3]
	cmp	r3, r1
	mov	r3, #0
	bne	.L2531
	strh	r3, [r0, #4]	@ movhi
.L2696:
	strb	r3, [r10, #6]
.L2689:
	movs	r0, #0
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2531:
	ldrh	r0, [r0, #16]
.L2532:
	cmp	r0, r2
	uxth	r5, r3
	add	r3, r3, #1
	beq	.L2533
	ldrb	r1, [r10, #8]	@ zero_extendqisi2
	cmp	r1, #1
	bne	.L2534
	bl	FtlGetLastWrittenPage
	adds	r6, r0, #1
	mov	r4, r0
	beq	.L2535
	ldr	r3, .L2698+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2613
	ldr	r3, .L2698+8
	ldrh	r6, [r3, r0, lsl #1]
.L2536:
	ldr	r3, .L2698+12
	movw	lr, #65535
	mov	r8, #36
	ldrh	fp, [r3]
	ldr	r3, .L2698+16
	ldr	r0, [r3]
	ldr	r3, .L2698+20
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L2698+24
	ldrh	ip, [r3]
	add	r3, r10, #16
	str	r3, [sp, #20]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r7, r3
.L2537:
	uxth	r2, r3
	cmp	fp, r2
	bhi	.L2541
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L2614
	ldr	r3, .L2698+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #0
	it	ne
	movne	r3, #1
.L2690:
	str	r3, [sp, #36]
	mov	r1, r7
	ldr	r2, [sp, #36]
	movs	r5, #0
	bl	FlashReadPages
	ldr	r3, .L2698+28
	movw	fp, #65535
	ldr	r8, .L2698+16
	ldr	r3, [r3]
	subs	r3, r3, #1
	str	r3, [sp, #4]
.L2543:
	uxth	r3, r5
	cmp	r7, r3
	bhi	.L2548
	bne	.L2546
	adds	r4, r4, #1
	uxth	r3, r4
	str	r3, [sp, #8]
	ldr	r3, [r8]
	ldr	r0, [r3, #4]
.L2691:
	ubfx	r0, r0, #10, #16
	bl	P2V_plane
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	str	r0, [sp, #16]
	cmp	r3, #1
	bne	.L2550
	ldr	r2, .L2698+4
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L2550
	ldr	r1, [sp, #8]
	ldr	r2, .L2698+8
	ldrh	r2, [r2, r1, lsl #1]
	str	r2, [sp, #8]
.L2550:
	ldr	r2, .L2698
	ldr	r1, [sp, #8]
	ldrh	r2, [r2]
	cmp	r2, r1
	bne	.L2551
	ldrh	r2, [sp, #8]
	strh	r2, [r10, #2]	@ movhi
	movs	r2, #0
	strb	r2, [r10, #6]
	strh	r2, [r10, #4]	@ movhi
.L2551:
	ldr	r2, [sp, #8]
	ldr	r1, [sp, #12]
	cmp	r2, r1
	bne	.L2552
	ldr	r2, [sp, #16]
	ldr	r1, [sp, #28]
	cmp	r2, r1
	bne	.L2552
.L2697:
	ldr	r1, [sp, #8]
	mov	r0, r10
	bl	ftl_sb_update_avl_pages
	b	.L2689
.L2533:
	uxth	r1, r3
	adds	r1, r1, #8
	ldrh	r0, [r10, r1, lsl #1]
	b	.L2532
.L2534:
	movs	r1, #0
	bl	FtlGetLastWrittenPage
	mov	r4, r0
	adds	r0, r0, #1
	beq	.L2535
.L2613:
	mov	r6, r4
	b	.L2536
.L2535:
	ldr	r3, [sp, #12]
	cbz	r3, .L2538
	ldr	r1, .L2698+32
	movw	r2, #2211
	ldr	r0, .L2698+36
	bl	printf
	ldr	r1, .L2698+40
	ldr	r0, .L2698+44
	bl	printf
.L2538:
	ldr	r3, [sp, #28]
	cbz	r3, .L2539
	cmp	r5, r3
	beq	.L2539
	ldr	r1, .L2698+32
	movw	r2, #2212
	ldr	r0, .L2698+36
	bl	printf
	ldr	r1, .L2698+40
	ldr	r0, .L2698+44
	bl	printf
.L2539:
	movs	r3, #0
	strh	r3, [r10, #2]	@ movhi
	b	.L2696
.L2541:
	ldr	r1, [sp, #4]
	ldrh	r2, [r1], #2
	cmp	r2, lr
	str	r1, [sp, #4]
	beq	.L2540
	mla	r1, r8, r7, r0
	orr	r2, r6, r2, lsl #10
	str	r2, [r1, #4]
	movs	r2, #0
	str	r2, [r1, #8]
	mul	r2, ip, r7
	adds	r7, r7, #1
	uxth	r7, r7
	bic	r2, r2, #3
	mov	r5, r2
	ldr	r2, [sp, #8]
	add	r5, r5, r2
	str	r5, [r1, #12]
.L2540:
	adds	r3, r3, #1
	b	.L2537
.L2614:
	movs	r3, #0
	b	.L2690
.L2548:
	movs	r3, #36
	ldr	r1, [r8]
	muls	r3, r5, r3
	adds	r2, r1, r3
	ldr	r3, [r1, r3]
	cbnz	r3, .L2544
	ldr	r2, [r2, #12]
	ldr	r3, [r2, #4]
	adds	r1, r3, #1
	beq	.L2545
	ldr	r1, .L2698+28
	mov	r0, r3
	ldr	r1, [r1]
	bl	ftl_cmp_data_ver
	cbz	r0, .L2545
	ldr	r1, .L2698+28
	adds	r3, r3, #1
	str	r3, [r1]
.L2545:
	ldr	r3, [r2]
	adds	r3, r3, #1
	bne	.L2547
.L2546:
	uxth	r3, r4
	uxth	r5, r5
	str	r3, [sp, #8]
	movs	r2, #36
	ldr	r3, [r8]
	mla	r5, r2, r5, r3
	ldr	r0, [r5, #4]
	b	.L2691
.L2544:
	ldr	r1, [r2, #4]
	uxth	fp, r6
	ldr	r0, .L2698+48
	bl	printf
	ldrh	r2, [r10]
	ldr	r3, .L2698+52
	strh	r2, [r3]	@ movhi
.L2547:
	adds	r5, r5, #1
	b	.L2543
.L2552:
	movw	r2, #65535
	cmp	fp, r2
	bne	.L2553
	cmp	r3, #0
	bne	.L2554
.L2553:
	ldr	r3, .L2698+56
	uxth	fp, r6
	uxth	r6, r6
	mov	r7, #-1
	ldr	r2, [r3]
	adds	r2, r2, #1
	itt	eq
	ldreq	r2, [sp, #4]
	streq	r2, [r3]
	ldr	r3, [r3]
	str	r3, [sp, #24]
	ldr	r3, [sp, #12]
	adds	r3, r3, #7
	cmp	r6, r3
	mov	r6, r7
	itet	gt
	subgt	r4, fp, #7
	ldrle	r4, [sp, #12]
	uxthgt	r4, r4
.L2557:
	cmp	r4, fp
	bhi	.L2572
	ldr	r3, .L2698+12
	movw	lr, #65535
	mov	ip, #36
	ldrh	r8, [r3]
	ldr	r3, .L2698+16
	ldr	r0, [r3]
	ldr	r3, [sp, #20]
	str	r3, [sp, #32]
	movs	r3, #0
	mov	r5, r3
	b	.L2573
.L2559:
	ldr	r1, [sp, #32]
	ldrh	r2, [r1], #2
	cmp	r2, lr
	str	r1, [sp, #32]
	beq	.L2558
	mla	r1, ip, r5, r0
	adds	r5, r5, #1
	orr	r2, r4, r2, lsl #10
	uxth	r5, r5
	str	r2, [r1, #4]
.L2558:
	adds	r3, r3, #1
.L2573:
	uxth	r2, r3
	cmp	r8, r2
	bhi	.L2559
	mov	r1, r5
	ldr	r2, [sp, #36]
	bl	FlashReadPages
	ldr	r2, .L2698+4
	movs	r1, #36
	ldr	r3, .L2698+56
	movs	r0, #0
	movw	ip, #65535
	ldrb	lr, [r2]	@ zero_extendqisi2
	ldr	r2, .L2698+16
	ldr	r3, [r3]
	ldr	r2, [r2]
	mla	r5, r1, r5, r2
.L2560:
	cmp	r2, r5
	bne	.L2570
	cbz	r0, .L2571
	ldr	r2, .L2698+56
	str	r3, [r2]
.L2571:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L2557
.L2699:
	.align	2
.L2698:
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
	.word	.LC62
	.word	.LANCHOR235
	.word	.LANCHOR136
.L2570:
	ldr	r1, [r2]
	cbnz	r1, .L2561
	ldr	r1, [r2, #12]
	ldrh	r8, [r1]
	cmp	r8, ip
	beq	.L2617
	ldr	r1, [r1, #4]
	cmp	r1, #-1
	beq	.L2617
	adds	r0, r7, #1
	bne	.L2619
	ldr	r0, .L2700
	ldrh	r0, [r0, r4, lsl #1]
	cmp	r0, ip
	bne	.L2563
	cmp	lr, #0
	beq	.L2619
.L2563:
	ldr	r0, [sp, #4]
	cmp	r0, r3
	it	ne
	movne	r7, r3
.L2619:
	movs	r0, #1
	b	.L2562
.L2561:
	cbz	r0, .L2564
	ldr	r2, .L2700+4
	str	r3, [r2]
.L2564:
	ldr	r3, .L2700+8
	ldrh	r2, [r10]
	strh	r2, [r3]	@ movhi
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	cbnz	r3, .L2554
	ldr	r3, .L2700
	ldrh	r2, [r3, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2566
	adds	r1, r7, #1
	ldr	r3, .L2700+4
	beq	.L2567
	str	r7, [r3]
.L2554:
	ldr	r3, .L2700+12
	movs	r2, #1
	ldr	r0, .L2700+16
	ldr	r6, .L2700+20
	strh	r2, [r3]	@ movhi
	bl	FtlMapBlkWriteDumpData
	ldr	fp, [sp, #12]
.L2574:
	ldr	r3, .L2700+24
	movw	ip, #65535
	ldr	r0, [r6]
	mov	lr, #36
	ldr	r1, [sp, #20]
	movs	r2, #0
	ldrh	r5, [r3]
	ldr	r3, .L2700+28
	str	r2, [sp, #24]
	ldrb	r7, [r3]	@ zero_extendqisi2
.L2575:
	uxth	r3, r2
	cmp	r3, r5
	bcc	.L2578
	ldr	r2, [sp, #36]
	ldr	r1, [sp, #24]
	bl	FlashReadPages
	movs	r3, #0
.L2695:
	str	r3, [sp, #32]
	ldr	r2, [sp, #24]
	ldrh	r3, [sp, #32]
	cmp	r2, r3
	bhi	.L2607
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	add	fp, fp, #1
	uxth	fp, fp
	cmp	r3, #1
	bne	.L2608
	ldr	r3, .L2700+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2608
	ldr	r3, .L2700+32
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2608
	ldr	r3, [sp, #8]
	cmp	r3, fp
	beq	.L2583
.L2608:
	ldr	r3, .L2700+36
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2574
	ldr	r2, .L2700+24
	movw	r0, #65535
	movs	r3, #0
	strh	fp, [r10, #2]	@ movhi
	strh	r3, [r10, #4]	@ movhi
	ldrh	r2, [r2]
.L2609:
	uxth	r1, r3
	cmp	r1, r2
	bcs	.L2689
	ldr	r1, [sp, #20]
	ldrh	r4, [r1], #2
	cmp	r4, r0
	str	r1, [sp, #20]
	add	r1, r3, #1
	bne	.L2696
	mov	r3, r1
	b	.L2609
.L2567:
	ldr	r2, [sp, #4]
	ldr	r1, [sp, #24]
	cmp	r2, r1
	itet	eq
	ldreq	r2, [r3]
	movne	r2, r1
	addeq	r2, r2, #-1
.L2692:
	str	r2, [r3]
	b	.L2554
.L2566:
	ldr	r3, [sp, #4]
	cmp	r6, r3
	beq	.L2569
	adds	r2, r6, #1
	beq	.L2554
	ldr	r3, .L2700+4
	str	r6, [r3]
	b	.L2554
.L2569:
	ldr	r2, .L2700+4
	ldr	r1, [sp, #4]
	ldr	r3, [r2]
	cmp	r1, r3
	beq	.L2554
	subs	r3, r3, #1
	str	r3, [r2]
	b	.L2554
.L2617:
	mov	r1, r3
	mov	r3, r6
.L2562:
	mov	r6, r3
	adds	r2, r2, #36
	mov	r3, r1
	b	.L2560
.L2572:
	mov	r2, #-1
	ldr	r3, .L2700+4
	b	.L2692
.L2578:
	ldrh	r3, [r1], #2
	cmp	r3, ip
	beq	.L2576
	ldr	r4, [sp, #24]
	orr	r3, fp, r3, lsl #10
	mla	r4, lr, r4, r0
	str	r3, [r4, #4]
	ldrb	r8, [r10, #8]	@ zero_extendqisi2
	cmp	r8, #1
	bne	.L2577
	cbz	r7, .L2577
	orr	r3, r3, #-2147483648
	str	r3, [r4, #4]
.L2577:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #24]
.L2576:
	adds	r2, r2, #1
	b	.L2575
.L2607:
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
	bcc	.L2580
	bne	.L2581
	ldr	r3, [sp, #28]
	cmp	r3, r0
	bhi	.L2580
.L2581:
	ldr	r3, [sp, #8]
	cmp	fp, r3
	bne	.L2582
	ldr	r3, [sp, #16]
	cmp	r3, r0
	beq	.L2583
.L2582:
	ldr	r3, [r8, r5]
	adds	r3, r3, #1
	beq	.L2584
	ldr	r3, [r7, #12]
	movw	r2, #61589
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L2585
.L2591:
	ldrh	r0, [r10]
.L2694:
	bl	decrement_vpc_count
.L2580:
	ldr	r3, [sp, #32]
	adds	r3, r3, #1
	b	.L2695
.L2585:
	ldr	r2, [r3, #4]
	str	r2, [sp, #4]
	adds	r2, r2, #1
	beq	.L2586
	ldr	r2, .L2700+40
	ldr	r0, [sp, #4]
	ldr	r1, [r2]
	bl	ftl_cmp_data_ver
	cbz	r0, .L2586
	ldr	r1, [sp, #4]
	adds	r1, r1, #1
	str	r1, [r2]
.L2586:
	ldr	r4, [r3, #8]
	add	r1, sp, #48
	ldr	r3, [r3, #12]
	movs	r2, #0
	mov	r0, r4
	str	r3, [sp, #44]
	bl	log2phys
	ldr	r3, .L2700+4
	ldr	r1, [r3]
	adds	r3, r1, #1
	beq	.L2587
	ldr	r0, [sp, #4]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2587
	ldr	r3, [sp, #44]
	adds	r7, r3, #1
	beq	.L2588
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
	bne	.L2589
.L2590:
	mov	r3, #-1
	ldrh	r0, [r10]
	str	r3, [sp, #44]
	bl	decrement_vpc_count
.L2598:
	ldr	r7, [sp, #44]
	adds	r0, r7, #1
	beq	.L2580
.L2612:
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L2700+44
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2603
	ldr	r1, .L2700+48
	movw	r2, #2494
	ldr	r0, .L2700+52
	bl	printf
	ldr	r1, .L2700+56
	ldr	r0, .L2700+60
	bl	printf
.L2603:
	ldr	r3, .L2700+64
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, #0
	beq	.L2604
	mov	r0, r4
	b	.L2694
.L2588:
	ldr	r3, [sp, #52]
	ldr	r2, [sp, #48]
	cmp	r2, r3
	bne	.L2591
	movs	r2, #1
	add	r1, sp, #44
	mov	r0, r4
	bl	log2phys
	b	.L2591
.L2701:
	.align	2
.L2700:
	.word	.LANCHOR120
	.word	.LANCHOR136
	.word	.LANCHOR235
	.word	.LANCHOR236
	.word	.LANCHOR127
	.word	.LANCHOR180
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
.L2589:
	ldr	r1, [r7, #8]
	cmp	r4, r1
	bne	.L2590
	ldr	r8, [r7, #4]
	ldr	r0, .L2702
	mov	r1, r8
	ldr	r0, [r0]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2590
	ldr	r1, [sp, #48]
	ldr	r0, [sp, #52]
	cmp	r1, r0
	bne	.L2593
.L2596:
	ldr	r1, [sp, #44]
	mov	r0, r4
	bl	FtlReUsePrevPpa
	b	.L2590
.L2593:
	ldr	r0, [sp, #44]
	cmp	r1, r0
	beq	.L2590
	adds	r0, r1, #1
	beq	.L2594
	str	r1, [r3, #4]
	movs	r2, #0
	movs	r1, #1
	mov	r0, r3
	ldr	r7, [r3, #12]
	bl	FlashReadPages
.L2595:
	ldr	r3, [r6]
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L2596
	ldr	r3, [r7, #4]
	ldr	r2, .L2702
	mov	r1, r3
	ldr	r0, [r2]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2596
	mov	r1, r3
	mov	r0, r8
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2590
	b	.L2596
.L2594:
	str	r1, [r2, r5]
	b	.L2595
.L2587:
	ldr	r3, [sp, #52]
	ldr	r2, [sp, #48]
	cmp	r2, r3
	beq	.L2598
	movs	r2, #1
	add	r1, sp, #52
	mov	r0, r4
	bl	log2phys
	ldr	r7, [sp, #48]
	adds	r5, r7, #1
	beq	.L2598
	ldr	r3, [sp, #44]
	cmp	r7, r3
	beq	.L2612
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L2702+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L2602
	ldr	r3, .L2702+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L2602
	ldr	r3, .L2702+12
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L2598
.L2602:
	ldr	r0, [r6]
	movs	r2, #0
	movs	r1, #1
	str	r7, [r0, #4]
	ldr	r5, [r0, #12]
	bl	FlashReadPages
	ldr	r3, [r6]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L2598
	ldr	r1, [r5, #4]
	ldr	r0, [sp, #4]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	bne	.L2598
	movs	r2, #1
	add	r1, sp, #48
	mov	r0, r4
	bl	log2phys
	b	.L2598
.L2604:
	mov	r1, r4
	ldr	r0, .L2702+16
	bl	printf
	b	.L2580
.L2584:
	ldrh	r3, [r10]
	mov	r1, r4
	ldr	r2, .L2702+20
	ldr	r0, .L2702+24
	strh	r3, [r2]	@ movhi
	ldr	r2, [sp, #4]
	bl	printf
	ldr	r2, .L2702+28
	ldr	r3, [r2]
	cmp	r3, #31
	bhi	.L2605
	ldr	r0, [sp, #52]
	ldr	r1, .L2702+32
	str	r0, [r1, r3, lsl #2]
	adds	r3, r3, #1
	str	r3, [r2]
.L2605:
	ldrh	r0, [r10]
	bl	decrement_vpc_count
	ldr	r3, .L2702
	ldr	r2, [r3]
	adds	r1, r2, #1
	bne	.L2606
	ldr	r2, [sp, #4]
.L2693:
	str	r2, [r3]
	b	.L2580
.L2606:
	ldr	r1, [sp, #4]
	cmp	r1, r2
	bcs	.L2580
	mov	r2, r1
	b	.L2693
.L2583:
	ldrb	r3, [sp, #16]	@ zero_extendqisi2
	ldr	r2, [sp, #16]
	strb	r3, [r10, #6]
	ldrh	r3, [sp, #8]
	strh	r3, [r10, #2]	@ movhi
	b	.L2697
.L2703:
	.align	2
.L2702:
	.word	.LANCHOR136
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LC63
	.word	.LANCHOR235
	.word	.LC64
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
	ldr	r3, .L2727
	ldr	r3, [r3]
	cbz	r3, .L2705
.L2710:
	movs	r0, #0
.L2704:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2705:
	ldr	r0, .L2727+4
	movw	r3, #65535
	ldr	r5, .L2727+8
	ldrh	r6, [r0]
	mov	r4, r0
	cmp	r6, r3
	beq	.L2707
	ldr	r3, .L2727+12
	ldrh	r1, [r3]
	bl	FtlGcScanTempBlk
	str	r0, [sp, #12]
	adds	r0, r0, #1
	beq	.L2707
	ldr	r3, .L2727+16
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	cmp	r3, #4
	bls	.L2708
	subs	r3, r3, #5
	movs	r0, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	bl	FtlEctTblFlush
.L2708:
	ldr	r3, [r5]
	cbnz	r3, .L2709
	ldr	r2, .L2727+20
	ldr	r0, [sp, #12]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L2709:
	movs	r3, #0
	movs	r0, #1
	str	r3, [r5]
	b	.L2704
.L2707:
	ldrh	r2, [r4]
	movs	r3, #0
	str	r3, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2710
	ldr	r6, .L2727+12
	bl	FtlCacheWriteBack
	ldrb	r0, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r6]
	ldr	r5, .L2727+24
	muls	r2, r0, r2
	ldrh	r1, [r5]
	cmp	r1, r2
	beq	.L2711
	ldr	r1, .L2727+28
	movs	r2, #163
	ldr	r0, .L2727+32
	bl	printf
	ldr	r1, .L2727+36
	ldr	r0, .L2727+40
	bl	printf
.L2711:
	ldrh	r6, [r6]
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldr	r2, .L2727+44
	ldrh	r0, [r4]
	ldr	fp, .L2727+84
	smulbb	r3, r3, r6
	ldr	r1, [r2]
	movs	r6, #0
	str	r2, [sp, #4]
	strh	r3, [r1, r0, lsl #1]	@ movhi
	ldr	r1, .L2727+48
	ldrh	r3, [r5]
	ldr	r0, [r1]
	add	r3, r3, r0
	str	r3, [r1]
.L2712:
	ldrh	r2, [r5]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L2716
	movw	r0, #65535
	bl	decrement_vpc_count
	ldr	r3, .L2727+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2717
	ldrh	r1, [r4]
	ldr	r0, .L2727+56
	bl	printf
.L2717:
	ldr	r3, [sp, #4]
	ldrh	r0, [r4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	beq	.L2718
	bl	INSERT_DATA_LIST
.L2719:
	ldr	r3, .L2727+60
	movw	r6, #65535
	strh	r6, [r4]	@ movhi
	movs	r4, #0
	strh	r4, [r5]	@ movhi
	strh	r4, [r3]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	r3, .L2727+64
	ldrh	r2, [r3]
	ldr	r3, .L2727+68
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	cmp	r2, r3, asr #2
	ble	.L2710
	ldr	r3, .L2727+72
	movs	r2, #20
	mov	r0, r4
	strh	r6, [r3]	@ movhi
	ldr	r3, .L2727+76
	strh	r2, [r3]	@ movhi
	b	.L2704
.L2716:
	uxth	r3, r6
	movs	r7, #12
	ldr	r2, [fp]
	muls	r7, r3, r7
	ldr	r3, .L2727+80
	ldr	r8, [r3]
	add	r10, r8, r7
	ldr	r1, [r10, #8]
	cmp	r1, r2
	bcc	.L2713
	ldr	r1, .L2727+28
	movs	r2, #168
	ldr	r0, .L2727+32
	bl	printf
	ldr	r1, .L2727+36
	ldr	r0, .L2727+40
	bl	printf
.L2713:
	movs	r2, #0
	add	r1, sp, #12
	ldr	r0, [r10, #8]
	bl	log2phys
	ldr	r2, [sp, #12]
	ldr	r0, [r8, r7]
	cmp	r0, r2
	bne	.L2714
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	movs	r2, #1
	mov	r7, r0
	add	r1, r10, #4
	ldr	r0, [r10, #8]
	bl	log2phys
	mov	r0, r7
.L2726:
	bl	decrement_vpc_count
.L2715:
	adds	r6, r6, #1
	b	.L2712
.L2714:
	ldr	r3, [r10, #4]
	cmp	r2, r3
	beq	.L2715
	ldrh	r0, [r4]
	b	.L2726
.L2718:
	bl	INSERT_FREE_LIST
	b	.L2719
.L2728:
	.align	2
.L2727:
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
	.word	.LC65
	.word	.LANCHOR110
	.word	.LANCHOR89
	.word	.LANCHOR223
	.word	.LANCHOR204
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
	ldr	r4, .L2731
	ldr	r5, .L2731+4
	ldrh	r1, [r4]
	mov	r0, r5
	bl	FtlGcScanTempBlk
	ldrh	r2, [r5, #2]
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L2729
	ldr	r0, .L2731+8
	bl	FtlMapBlkWriteDumpData
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r3, .L2731+12
	movs	r2, #0
	str	r2, [r3]
.L2729:
	pop	{r3, r4, r5, pc}
.L2732:
	.align	2
.L2731:
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
	ldr	r5, .L2734
	ldr	r3, .L2734+4
	mov	r0, r5
	str	r4, [r3]
	bl	FtlRecoverySuperblock
	mov	r0, r5
	ldr	r5, .L2734+8
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
.L2735:
	.align	2
.L2734:
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
	ldr	r4, .L2746
	movw	r5, #65535
	strh	r3, [r4]	@ movhi
	ldr	r3, .L2746+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L2746+8
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	ldr	r3, .L2746+12
	ldrh	r3, [r3]
	cmp	r3, r5
	mov	r5, r4
	bne	.L2737
.L2739:
	mov	r4, #-1
.L2736:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L2737:
	bl	FtlLoadSysInfo
	mov	r4, r0
	cmp	r0, #0
	bne	.L2739
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	movs	r0, #1
	bl	FtlUpdateVaildLpn
	ldr	r3, .L2746+16
	movs	r0, #12
	ldrh	r2, [r3]
	ldr	r3, .L2746+20
	ldr	r1, [r3]
	mov	r3, r4
.L2740:
	cmp	r3, r2
	blt	.L2742
	ldrh	r3, [r5]
	cmp	r3, #0
	beq	.L2736
.L2741:
	ldr	r3, .L2746+24
	ldr	r1, [r3]
	ldr	r3, .L2746+28
	ldrh	r0, [r3]
	ldrh	r5, [r3, #4]
	ldrh	r2, [r1, r0, lsl #1]
	subs	r2, r2, r5
	ldr	r5, .L2746+32
	strh	r2, [r1, r0, lsl #1]	@ movhi
	ldrh	r2, [r5]
	strh	r2, [r3, #2]	@ movhi
	movs	r2, #0
	strh	r2, [r3, #4]	@ movhi
	strb	r2, [r3, #6]
	ldr	r3, .L2746+36
	ldrh	r6, [r3]
	ldrh	r7, [r3, #4]
	ldrh	r0, [r1, r6, lsl #1]
	subs	r0, r0, r7
	strh	r0, [r1, r6, lsl #1]	@ movhi
	ldrh	r1, [r5]
	ldr	r0, .L2746+40
	strb	r2, [r3, #6]
	strh	r1, [r3, #2]	@ movhi
	strh	r2, [r3, #4]	@ movhi
	bl	FtlMapBlkWriteDumpData
	ldr	r0, .L2746+44
	bl	FtlMapBlkWriteDumpData
	ldr	r2, .L2746+48
	ldrh	r3, [r2, #30]
	adds	r3, r3, #1
	strh	r3, [r2, #30]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	bl	FtlVpcTblFlush
	b	.L2736
.L2742:
	mla	r6, r0, r3, r1
	ldr	r6, [r6, #4]
	cmp	r6, #0
	blt	.L2741
	adds	r3, r3, #1
	b	.L2740
.L2747:
	.align	2
.L2746:
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
	.word	.LANCHOR127
	.word	.LANCHOR215
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
	ldr	r3, .L2779
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r4, [r3]
	cmp	r4, #0
	bne	.L2750
	ldr	r5, .L2779+4
	mov	r1, r4
	ldr	r3, .L2779+8
	ldr	r6, .L2779+12
	ldrh	r2, [r5]
	ldr	r0, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L2779+16
	ldr	r5, .L2779+20
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L2779+24
	ldrh	r0, [r6]
	str	r4, [r5]
	str	r4, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L2751
	bl	FtlMakeBbt
.L2751:
	ldr	r3, .L2779+28
	ldr	r2, .L2779+32
	ldr	ip, .L2779+112
	ldrh	r1, [r3]
	ldr	r4, [r2]
	ldr	r2, .L2779+36
	str	r3, [sp, #12]
	lsls	r1, r1, #7
	ldr	r7, [r2]
	movs	r2, #0
.L2752:
	uxth	r3, r2
	adds	r2, r2, #1
	cmp	r3, r1
	blt	.L2753
	ldr	r3, .L2779+40
	movs	r7, #0
	ldr	fp, .L2779+116
	ldrh	r4, [r3]
	mov	r8, r3
	mov	r10, fp
.L2754:
	ldrh	r3, [fp]
	cmp	r3, r4
	bhi	.L2755
	ldr	r4, .L2779+44
	subs	r3, r7, #2
	ldrh	r1, [r4]
	cmp	r3, r1, lsl #1
	bgt	.L2756
.L2760:
	movs	r7, #0
	mov	r6, r7
.L2757:
	ldrh	r3, [r8]
	uxth	r0, r7
	adds	r7, r7, #1
	cmp	r3, r0
	bhi	.L2761
	ldrh	r2, [r10]
	ldr	r3, .L2779+48
	ldrh	r4, [r4]
	ldr	r7, .L2779+52
	str	r2, [r3]
	ldr	r3, .L2779+56
	mov	r1, r4
	ldr	r3, [r3]
	mov	r0, r3
	str	r3, [sp, #16]
	bl	__aeabi_uidiv
	ldr	r1, .L2779+60
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
	ble	.L2762
	ldr	r3, [sp, #16]
	mov	r1, r4
	subs	r0, r3, r6
	bl	__aeabi_uidiv
	ldr	r3, [sp, #8]
	str	r0, [r7]
	lsrs	r0, r0, #5
	adds	r0, r0, #24
	strh	r0, [r3]	@ movhi
.L2762:
	ldr	r3, .L2779+64
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L2763
	ldr	r2, .L2779+60
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
.L2763:
	ldr	r3, .L2779+68
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2764
	ldr	r2, .L2779+60
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
.L2764:
	ldr	r3, .L2779+72
	ldrh	r3, [r3]
	cbz	r3, .L2766
	ldr	r2, .L2779+60
	ldrh	r1, [r2]
	add	r1, r1, r3, lsr #1
	strh	r1, [r2]	@ movhi
	mul	r1, r4, r3
	cmp	r6, r1
	bge	.L2766
	ldr	r1, [sp, #4]
	adds	r3, r3, #32
	str	fp, [r7]
	add	r1, r1, r3
	strh	r1, [r2]	@ movhi
.L2766:
	ldr	r3, [sp, #8]
	ldr	r6, .L2779+76
	ldrh	r2, [r3]
	ldr	r3, [r7]
	subs	r3, r3, r2
	muls	r4, r3, r4
	ldr	r3, .L2779+80
	ldrh	r3, [r3]
	str	r4, [r6]
	muls	r4, r3, r4
	ldr	r3, [sp, #12]
	ldrh	r3, [r3]
	str	r4, [r7]
	ldr	r7, .L2779+84
	muls	r4, r3, r4
	ldr	r3, .L2779+88
	str	r4, [r3]
	movw	r4, #65535
	bl	FtlBbmTblFlush
	ldrh	r2, [r10]
	movs	r1, #0
	ldr	r10, .L2779+120
	lsls	r2, r2, #1
	ldr	r0, [r10]
	bl	ftl_memset
	ldr	r2, .L2779+92
	movs	r3, #0
	strh	r3, [r7, #2]	@ movhi
	movs	r1, #255
	strb	r3, [r7, #6]
	str	r3, [r2]
	ldr	r2, .L2779+96
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
	ldr	r3, .L2779+100
	lsrs	r2, r2, #3
	ldr	r0, [r3]
	bl	ftl_memset
.L2768:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r7, #7]	@ zero_extendqisi2
	ldrh	r2, [r7]
	cmp	r3, #0
	bne	.L2769
	ldr	r3, [r8]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r7]
	adds	r3, r3, #1
	strh	r3, [r7]	@ movhi
	b	.L2768
.L2753:
	mvns	r0, r3
	orr	r0, r3, r0, lsl #16
	str	r0, [r4, r3, lsl #2]
	str	ip, [r7, r3, lsl #2]
	b	.L2752
.L2755:
	mov	r0, r4
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r4, r4, #1
	add	r7, r7, r0
	uxth	r7, r7
	uxth	r4, r4
	b	.L2754
.L2756:
	mov	r0, r7
	bl	__aeabi_uidiv
	ldr	r3, .L2779+104
	ldr	r3, [r3]
	add	r0, r0, r3
	uxth	r0, r0
	bl	FtlSysBlkNumInit
	ldrh	r0, [r6]
	bl	FtlFreeSysBlkQueueInit
	ldrh	r6, [r8]
.L2758:
	ldrh	r3, [r10]
	cmp	r3, r6
	bls	.L2760
	mov	r0, r6
	movs	r1, #1
	adds	r6, r6, #1
	bl	FtlLowFormatEraseBlock
	uxth	r6, r6
	b	.L2758
.L2761:
	movs	r1, #0
	bl	FtlLowFormatEraseBlock
	add	r6, r6, r0
	uxth	r6, r6
	b	.L2757
.L2769:
	ldr	r3, [r5]
	ldrh	r1, [r7, #4]
	ldr	r4, .L2779+108
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
.L2770:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r4]
	cmp	r3, #0
	bne	.L2771
	ldr	r3, [r8]
	strh	r7, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L2770
.L2780:
	.align	2
.L2779:
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
.L2771:
	ldr	r3, [r5]
	ldrh	r1, [r4, #4]
	str	r3, [r4, #12]
	adds	r3, r3, #1
	str	r3, [r5]
	movw	r4, #65535
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L2781
	strh	r4, [r3]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L2781+4
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
	cbnz	r0, .L2750
	ldr	r3, .L2781+8
	movs	r2, #1
	str	r2, [r3]
.L2750:
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2782:
	.align	2
.L2781:
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
	ldr	r4, .L2786
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L2784
	ldrh	r3, [r4, #4]
	cbnz	r3, .L2785
.L2784:
	bl	FtlCacheWriteBack
	movs	r0, #0
	movs	r5, #0
	bl	FtlGcFreeTempBlock
	ldr	r0, .L2786
	strb	r5, [r4, #8]
	bl	allocate_data_superblock
	ldr	r3, .L2786+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L2786+8
	strh	r5, [r3]	@ movhi
	bl	l2p_flush
	mov	r0, r5
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2785:
	ldr	r0, .L2786
	pop	{r3, r4, r5, lr}
	b	get_new_active_ppa
.L2787:
	.align	2
.L2786:
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
	ldr	r3, .L2803
	ldr	r3, [r3]
	cbz	r3, .L2789
.L2792:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L2789:
	ldr	r3, .L2803+4
	ldr	r5, .L2803+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2791
	ldr	r3, [r5]
	lsls	r2, r3, #31
	bpl	.L2791
	ldr	r3, .L2803+12
	ldrh	r3, [r3, #4]
	cmp	r3, #0
	bne	.L2792
.L2791:
	ldr	r4, .L2803+16
	movs	r3, #0
	movs	r6, #0
	movs	r7, #36
	mov	r2, r3
	ldr	r1, [r5]
	ldr	r0, [r4]
	bl	FlashProgPages
.L2793:
	ldr	r1, [r5]
	uxth	r3, r6
	cmp	r3, r1
	bcc	.L2795
	ldr	r0, [r4]
	bl	FtlGcBufFree
	movs	r3, #0
	str	r3, [r5]
	ldr	r3, .L2803+12
	ldrh	r3, [r3, #4]
	cmp	r3, #0
	bne	.L2792
	movs	r0, #1
	bl	FtlGcFreeTempBlock
	b	.L2802
.L2795:
	muls	r3, r7, r3
	ldr	r2, [r4]
	adds	r6, r6, #1
	adds	r1, r2, r3
	ldr	r2, [r2, r3]
	adds	r3, r2, #1
	bne	.L2794
	ldr	r3, .L2803+12
	movs	r5, #0
	ldr	r0, .L2803+20
	ldrh	r4, [r3]
	ldr	r0, [r0]
	strh	r5, [r0, r4, lsl #1]	@ movhi
	strh	r2, [r3]	@ movhi
	ldr	r2, .L2803+24
	ldr	r0, [r1, #4]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
.L2802:
	movs	r0, #1
	pop	{r3, r4, r5, r6, r7, pc}
.L2794:
	ldr	r3, [r1, #12]
	ldr	r1, [r1, #4]
	ldr	r2, [r3, #8]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L2793
.L2804:
	.align	2
.L2803:
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
	ldr	r3, .L2895
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	ldr	r2, [r3]
	cmp	r2, #0
	bne	.L2857
	ldr	r3, .L2895+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2857
	ldr	r2, .L2895+8
	ldrh	r2, [r2]
	cmp	r2, #47
	bls	.L2859
	ldr	r5, .L2895+12
	movw	r2, #65535
	ldrh	ip, [r5]
	cmp	ip, r2
	beq	.L2807
	ldr	r7, .L2895+16
	ldrh	r3, [r7]
	cmp	r3, r2
	bne	.L2807
	ldr	r1, .L2895+20
	ldrh	r6, [r1]
	cmp	r6, r3
	beq	.L2807
	ldr	r2, .L2895+24
	ldrh	r4, [r2]
	cmp	r4, r3
	itttt	ne
	strhne	ip, [r7]	@ movhi
	strhne	r6, [r5]	@ movhi
	strhne	r4, [r1]	@ movhi
	strhne	r3, [r2]	@ movhi
.L2807:
	cmp	r0, #0
	bne	.L2860
	ldr	r3, .L2895+28
	ldrh	r3, [r3]
	cmp	r3, #24
	bhi	.L2861
	ldr	r2, .L2895+32
	cmp	r3, #16
	ldrh	r4, [r2]
	bls	.L2810
	lsrs	r4, r4, #5
.L2809:
	ldr	r2, .L2895+36
	ldrh	r1, [r2]
	cmp	r1, r3
	mov	r1, r2
	bcs	.L2813
	ldr	r3, .L2895+40
	movw	r0, #65535
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L2814
	ldr	r0, .L2895+16
	ldrh	r0, [r0]
	cmp	r0, r3
	bne	.L2814
	ldr	r3, .L2895+44
	ldrh	r0, [r3]
	cbnz	r0, .L2815
	ldr	r3, .L2895+48
	ldr	r4, .L2895+52
	ldr	r3, [r3]
	ldr	r4, [r4]
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, lsr #2
	bcs	.L2816
.L2815:
	ldr	r3, .L2895+56
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L2817:
	ldr	r3, .L2895+60
	movs	r2, #0
	str	r2, [r3]
.L2805:
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2810:
	cmp	r3, #12
	bls	.L2811
	lsrs	r4, r4, #4
	b	.L2809
.L2811:
	cmp	r3, #8
	bls	.L2809
	lsrs	r4, r4, #2
	b	.L2809
.L2861:
	movs	r4, #1
	b	.L2809
.L2816:
	movs	r3, #18
	strh	r3, [r2]	@ movhi
	b	.L2817
.L2814:
	ldr	r3, .L2895+56
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L2813:
	ldr	r3, .L2895+64
	ldrh	r3, [r3]
	cbz	r3, .L2808
	adds	r4, r4, #32
	uxth	r4, r4
.L2808:
	ldr	r5, .L2895+68
	movw	r3, #65535
	ldrh	r2, [r5]
	cmp	r2, r3
	bne	.L2820
	ldr	r3, .L2895+16
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L2821
	ldr	r0, .L2895+72
	ldr	r0, [r0]
	ldrh	r1, [r0, r1, lsl #1]
	cbnz	r1, .L2822
	strh	r2, [r3]	@ movhi
.L2822:
	ldrh	r2, [r3]
	strh	r2, [r5]	@ movhi
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
.L2821:
	ldrh	r0, [r5]
	movw	r6, #65535
	movs	r3, #0
	strb	r3, [r5, #8]
	cmp	r0, r6
	beq	.L2820
	bl	IsBlkInGcList
	cbz	r0, .L2824
	strh	r6, [r5]	@ movhi
.L2824:
	ldr	r3, .L2895+76
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2825
	ldrh	r0, [r5]
	bl	ftl_get_blk_mode
	strb	r0, [r5, #8]
.L2825:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2820
	ldr	r0, .L2895+68
	bl	make_superblock
	ldr	r2, .L2895+80
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r3, [r2]	@ movhi
	ldr	r3, .L2895+72
	ldrh	r2, [r5]
	ldr	r3, [r3]
	ldrh	r2, [r3, r2, lsl #1]
	ldr	r3, .L2895+84
	strh	r2, [r3]	@ movhi
.L2820:
	ldr	r2, .L2895+88
	ldrh	r3, [r5]
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L2826
	ldr	r2, .L2895+92
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L2826
	ldr	r5, .L2895+68
	mov	r6, r5
.L2827:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2828
	ldr	r10, .L2895+100
	movs	r2, #0
	ldr	r3, .L2895+60
	mov	r7, r10
	str	r2, [r3]
.L2829:
	ldrh	r8, [r10]
	mov	r0, r8
	bl	List_get_gc_head_node
	uxth	fp, r0
	movw	r3, #65535
	cmp	fp, r3
	strh	fp, [r6]	@ movhi
	bne	.L2830
	movs	r3, #0
	movs	r0, #8
	strh	r3, [r10]	@ movhi
	b	.L2805
.L2860:
	movs	r4, #1
	b	.L2808
.L2826:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L2893:
	ldr	r3, .L2895+44
	ldrh	r0, [r3]
	b	.L2805
.L2830:
	str	r0, [sp, #8]
	mov	r0, fp
	bl	IsBlkInGcList
	add	r3, r8, #1
	ldr	r2, [sp, #8]
	cbz	r0, .L2831
	strh	r3, [r10]	@ movhi
	b	.L2829
.L2831:
	ldr	r1, .L2895+32
	uxth	r3, r3
	ldr	lr, .L2895+104
	uxth	r2, r2
	ldr	r8, .L2895+72
	ldrh	r1, [r1]
	ldrh	lr, [lr]
	ldr	r0, [r8]
	strh	r3, [r10]	@ movhi
	mul	r1, lr, r1
	ldrh	ip, [r0, r2, lsl #1]
	cmp	ip, r1, asr #1
	bgt	.L2833
	cmp	r3, #48
	bls	.L2834
	cmp	ip, #8
	bls	.L2834
	ldr	r3, .L2895+96
	ldrh	r3, [r3]
	cmp	r3, #35
	bhi	.L2834
.L2833:
	movs	r3, #0
	strh	r3, [r7]	@ movhi
.L2834:
	ldrh	r3, [r0, r2, lsl #1]
	cmp	r1, r3
	bgt	.L2835
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
	movs	r3, #0
	strh	r3, [r7]	@ movhi
	b	.L2893
.L2835:
	cmp	r3, #0
	bne	.L2836
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r3, [r7]
	adds	r3, r3, #1
	strh	r3, [r7]	@ movhi
	b	.L2829
.L2896:
	.align	2
.L2895:
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
.L2836:
	movs	r3, #0
	strb	r3, [r6, #8]
	ldr	r3, .L2897
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2837
	mov	r0, fp
	bl	ftl_get_blk_mode
	strb	r0, [r6, #8]
.L2837:
	ldr	r3, .L2897+4
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2838
	ldr	r1, .L2897+8
	movw	r2, #851
	ldr	r0, .L2897+12
	bl	printf
	ldr	r1, .L2897+16
	ldr	r0, .L2897+20
	bl	printf
.L2838:
	ldr	r3, .L2897+24
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2839
	ldr	r1, .L2897+8
	mov	r2, #852
	ldr	r0, .L2897+12
	bl	printf
	ldr	r1, .L2897+16
	ldr	r0, .L2897+20
	bl	printf
.L2839:
	ldr	r3, .L2897+28
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2840
	ldr	r1, .L2897+8
	movw	r2, #853
	ldr	r0, .L2897+12
	bl	printf
	ldr	r1, .L2897+16
	ldr	r0, .L2897+20
	bl	printf
.L2840:
	mov	r0, r5
	bl	make_superblock
	ldr	r2, .L2897+32
	movs	r3, #0
	ldrh	r1, [r6]
	strh	r3, [r2]	@ movhi
	ldr	r2, [r8]
	ldrh	r1, [r2, r1, lsl #1]
	ldr	r2, .L2897+36
	strh	r3, [r6, #2]	@ movhi
	strb	r3, [r6, #6]
	strh	r1, [r2]	@ movhi
.L2828:
	ldr	r3, .L2897+40
	movs	r2, #1
	str	r2, [r3]
	ldr	r3, .L2897+44
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2897
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2841
	ldrb	r3, [r6, #8]	@ zero_extendqisi2
	cmp	r3, r2
	ittt	eq
	ldreq	r3, .L2897+48
	ldrheq	r3, [r3]
	streq	r3, [sp, #12]
.L2841:
	ldrh	r3, [r6, #2]
	ldr	r1, [sp, #12]
	ldr	fp, .L2897+84
	adds	r2, r3, r4
	cmp	r2, r1
	itt	gt
	movgt	r2, r1
	subgt	r4, r2, r3
	mov	r3, #0
	it	gt
	uxthgt	r4, r4
	str	r3, [sp, #20]
.L2843:
	ldrh	r3, [sp, #20]
	cmp	r4, r3
	bls	.L2851
	ldr	r3, .L2897+52
	movw	r8, #65535
	ldrh	lr, [r5, #2]
	mov	r10, #36
	ldr	r0, [fp]
	ldrh	r7, [r3]
	ldr	r3, [sp, #20]
	add	lr, lr, r3
	ldr	r3, .L2897+56
	str	r3, [sp, #16]
	movs	r3, #0
	str	r3, [sp, #8]
	b	.L2852
.L2845:
	ldr	r1, [sp, #16]
	ldrh	r2, [r1, #2]!
	cmp	r2, r8
	str	r1, [sp, #16]
	beq	.L2844
	ldr	r1, [sp, #8]
	orr	r2, lr, r2, lsl #10
	mla	ip, r10, r1, r0
	str	r2, [ip, #4]
	mov	r2, r1
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #8]
.L2844:
	adds	r3, r3, #1
.L2852:
	uxth	r2, r3
	cmp	r2, r7
	bcc	.L2845
	ldrb	r2, [r5, #8]	@ zero_extendqisi2
	ldr	r1, [sp, #8]
	bl	FlashReadPages
	movs	r3, #0
.L2892:
	str	r3, [sp, #16]
	ldr	r2, [sp, #8]
	ldrh	r3, [sp, #16]
	cmp	r2, r3
	bhi	.L2850
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	str	r3, [sp, #20]
	b	.L2843
.L2850:
	ldr	r3, [sp, #16]
	movs	r7, #36
	muls	r7, r3, r7
	ldr	r3, [fp]
	adds	r2, r3, r7
	ldr	r3, [r3, r7]
	adds	r3, r3, #1
	beq	.L2847
	ldr	r8, [r2, #12]
	movw	r3, #61589
	ldrh	r2, [r8]
	cmp	r2, r3
	bne	.L2847
	ldr	r10, [r8, #8]
	cmp	r10, #-1
	bne	.L2848
	ldr	r1, .L2897+8
	mov	r2, #892
	ldr	r0, .L2897+12
	bl	printf
	ldr	r1, .L2897+16
	ldr	r0, .L2897+20
	bl	printf
.L2848:
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
	bne	.L2847
	ldr	r2, .L2897+32
	ldr	r1, .L2897+60
	ldr	r10, .L2897+68
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
	ldr	r7, .L2897+28
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
	ldr	r2, .L2897+64
	str	r3, [r10]
	ldr	r2, [r2]
	str	r2, [r8, #4]
	bl	FtlGcBufAlloc
	ldr	r3, .L2897
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2849
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldr	r3, [r10]
	cmp	r2, r3
	beq	.L2849
	ldrh	r3, [r7, #4]
	cbnz	r3, .L2847
.L2849:
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L2847
.L2894:
	ldr	r3, .L2897+40
	movs	r2, #0
	str	r2, [r3]
	b	.L2893
.L2847:
	ldr	r3, [sp, #16]
	adds	r3, r3, #1
	b	.L2892
.L2851:
	ldrh	r3, [r5, #2]
	add	r4, r4, r3
	ldr	r3, [sp, #12]
	uxth	r4, r4
	cmp	r3, r4
	strh	r4, [r5, #2]	@ movhi
	bhi	.L2853
	ldr	r3, .L2897+68
	ldr	r3, [r3]
	cbz	r3, .L2854
	bl	Ftl_gc_temp_data_write_back
	cmp	r0, #0
	bne	.L2894
.L2854:
	ldr	r3, .L2897+32
	ldrh	r4, [r3]
	cbnz	r4, .L2855
	ldr	r7, .L2897+72
	ldrh	r1, [r5]
	ldr	r3, [r7]
	ldrh	r3, [r3, r1, lsl #1]
	cbz	r3, .L2855
	ldr	r0, .L2897+36
	ldrh	r2, [r5, #2]
	ldrh	r0, [r0]
	str	r3, [sp]
	mov	r3, r4
	str	r0, [sp, #4]
	ldr	r0, .L2897+76
	bl	printf
	ldrh	r2, [r5]
	ldr	r3, [r7]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5]
	bl	update_vpc_list
	bl	FtlCacheWriteBack
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2855:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L2853:
	ldr	r3, .L2897+80
	ldrh	r0, [r3]
	cmp	r0, #2
	bhi	.L2856
	ldr	r3, .L2897+44
	ldrh	r4, [r3]
	b	.L2827
.L2856:
	ldr	r3, .L2897+40
	movs	r2, #0
	adds	r0, r0, #1
	str	r2, [r3]
	b	.L2805
.L2898:
	.align	2
.L2897:
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
	.word	.LC66
	.word	.LANCHOR89
	.word	.LANCHOR107
.L2857:
	movs	r0, #0
	b	.L2805
.L2859:
	mov	r0, r3
	b	.L2805
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
	ldr	r4, .L2908
	mov	r5, r0
	ldr	r2, .L2908+4
	str	r3, [r4]
	movs	r3, #0
	ldr	r1, .L2908+8
	str	r3, [r2]
	ldr	r2, .L2908+12
	ldr	r0, .L2908+16
	str	r3, [r2]
	bl	printf
	mov	r0, r5
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	ldr	r3, .L2908+20
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L2900
	ldr	r1, .L2908+24
	ldr	r0, .L2908+28
.L2907:
	bl	printf
.L2901:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2900:
	bl	FtlSysBlkInit
	cbz	r0, .L2902
	ldr	r1, .L2908+24
	ldr	r0, .L2908+32
	b	.L2907
.L2902:
	movs	r1, #1
	str	r1, [r4]
	bl	rk_ftl_garbage_collect
	ldr	r3, .L2908+36
	ldrh	r3, [r3]
	cmp	r3, #15
	bhi	.L2901
	mov	r4, #1024
.L2904:
	movs	r1, #1
	mov	r0, r1
	bl	rk_ftl_garbage_collect
	subs	r4, r4, #1
	bne	.L2904
	b	.L2901
.L2909:
	.align	2
.L2908:
	.word	.LANCHOR231
	.word	.LANCHOR244
	.word	.LC67
	.word	.LANCHOR77
	.word	.LC7
	.word	.LANCHOR39
	.word	.LANCHOR245
	.word	.LC68
	.word	.LC69
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
	cbnz	r0, .L2911
	ldr	r0, .L2912
	bl	FtlInit
.L2911:
	bl	idb_init
	mov	r1, r4
	ldr	r0, .L2912+4
	bl	printf
	mov	r0, r4
	pop	{r4, pc}
.L2913:
	.align	2
.L2912:
	.word	.LANCHOR15
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
	ldr	r3, .L2928
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2914
	ldr	r7, .L2928+4
	ldr	r6, .L2928+8
	ldr	r10, .L2928+32
	ldrh	r5, [r7]
	ldr	r3, [r6]
	ldr	r4, .L2928+12
	mov	r1, r5
	ldr	r0, .L2928+16
	ldrh	r2, [r3, r5, lsl #1]
	lsl	r8, r5, #1
	bl	printf
	ldrh	r0, [r10]
	bl	FtlGcRefreshBlock
	ldrh	r0, [r4]
	bl	FtlGcRefreshBlock
	mov	r0, r10
	bl	allocate_new_data_superblock
	mov	r0, r4
	movw	r4, #4097
	bl	allocate_new_data_superblock
	str	r7, [sp, #4]
.L2916:
	subs	r4, r4, #1
	beq	.L2920
	movs	r1, #1
	mov	r0, r1
	bl	rk_ftl_garbage_collect
	ldr	r3, [r6]
	ldrh	r3, [r3, r8]
	cmp	r3, #0
	bne	.L2916
.L2920:
	ldr	r3, [r6]
	mov	r1, r5
	ldr	r0, .L2928+16
	ldrh	r2, [r3, r5, lsl #1]
	bl	printf
	ldr	r3, [r6]
	ldrh	r4, [r3, r5, lsl #1]
	cbnz	r4, .L2918
	add	r0, sp, #56
	ldr	r7, .L2928+20
	strh	r5, [r0, #-48]!	@ movhi
	movw	r10, #65535
	bl	make_superblock
	ldr	r3, .L2928+24
	add	r0, sp, #22
	ldr	r8, [r7]
	mov	r2, r4
	mov	fp, #36
	mov	ip, r4
	ldrh	lr, [r3]
.L2921:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L2923
	ldr	r3, [r6]
	mov	r1, r5
	ldr	r0, .L2928+28
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
.L2918:
	ldr	r2, [sp, #4]
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L2914:
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2923:
	ldrh	r3, [r0, #2]!
	cmp	r3, r10
	beq	.L2922
	mla	r1, fp, r4, r8
	adds	r4, r4, #1
	lsls	r3, r3, #10
	uxth	r4, r4
	str	r3, [r1, #4]
	str	ip, [r1, #8]
	str	ip, [r1, #12]
.L2922:
	adds	r2, r2, #1
	b	.L2921
.L2929:
	.align	2
.L2928:
	.word	.LANCHOR8
	.word	.LANCHOR235
	.word	.LANCHOR84
	.word	.LANCHOR93
	.word	.LC71
	.word	.LANCHOR78
	.word	.LANCHOR38
	.word	.LC72
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
	bne	.L2931
	mov	r2, r3
	ldr	r1, [sp, #52]
	add	r0, r6, #256
	bl	FtlVendorPartRead
	str	r0, [sp, #32]
.L2930:
	ldr	r0, [sp, #32]
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2931:
	ldr	r3, [sp, #52]
	adds	r3, r1, r3
	str	r3, [sp, #36]
	ldr	r3, .L2969
	ldr	r2, [sp, #36]
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L2954
	ldr	r3, .L2969+4
	ldr	r3, [r3]
	adds	r4, r3, #1
	beq	.L2955
	bl	FtlCacheWriteBack
	ldr	r3, .L2969+8
	mov	r0, r6
	ldr	r10, .L2969+52
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	ldr	r3, [sp, #36]
	mov	r1, r4
	str	r0, [sp, #40]
	subs	r0, r3, #1
	bl	__aeabi_uidiv
	ldr	r3, [sp, #40]
	ldr	r2, .L2969+12
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
.L2933:
	ldr	r3, [sp, #28]
	cbnz	r3, .L2953
	ldr	r3, .L2969+16
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L2930
	movs	r1, #1
	ldr	r0, [sp, #28]
	bl	rk_ftl_garbage_collect
	b	.L2930
.L2953:
	movs	r2, #0
	add	r1, sp, #84
	mov	r0, r4
	bl	log2phys
	ldr	r3, [sp, #84]
	adds	r0, r3, #1
	bne	.L2934
	ldr	fp, .L2969+8
	mov	r8, #0
.L2935:
	ldrh	r0, [fp]
	cmp	r8, r0
	bcc	.L2937
.L2938:
	ldr	r3, [sp, #28]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #28]
	beq	.L2942
	ldr	r3, .L2969+20
	ldrh	r3, [r3]
	cmp	r5, r3, lsl #2
	bne	.L2933
.L2942:
	cmp	r5, #0
	beq	.L2933
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
.L2952:
	mov	r8, #36
	ldr	r3, [r10]
	mul	r8, r8, fp
	ldr	r1, [sp, #40]
	add	r3, r3, r8
	ldr	r2, [r3, #16]
	cmp	r1, r2
	bne	.L2944
	ldr	r1, [r3, #8]
	ldr	r3, .L2969+24
	ldr	r3, [r3]
	cmp	r1, r3
	bne	.L2945
	ldr	r3, [sp, #60]
	mov	r0, r7
	ldr	r2, [sp, #64]
	add	r1, r1, r3
.L2968:
	bl	ftl_memcpy
.L2945:
	ldr	r2, [r10]
	add	r2, r2, r8
	ldr	r3, [r2, #12]
	ldr	lr, [r2, #16]
	ldr	r0, [r3, #8]
	cmp	lr, r0
	beq	.L2946
	ldr	ip, .L2969+32
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
	ldr	r0, .L2969+28
	ldr	r3, [r3]
	ldr	r2, [r2, #4]
	bl	printf
.L2946:
	ldr	r3, [r10]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	adds	r1, r3, #1
	bne	.L2947
	ldr	r1, .L2969+32
	str	r3, [sp, #32]
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L2948:
	add	fp, fp, #1
	cmp	r5, fp
	bne	.L2952
	movs	r5, #0
	b	.L2933
.L2937:
	mla	r0, r0, r4, r8
	cmp	r6, r0
	bhi	.L2936
	ldr	r3, [sp, #36]
	cmp	r3, r0
	bls	.L2936
	subs	r0, r0, r6
	mov	r2, #512
	movs	r1, #0
	add	r0, r7, r0, lsl #9
	bl	ftl_memset
.L2936:
	add	r8, r8, #1
	b	.L2935
.L2934:
	ldr	r2, [r10]
	mov	r8, #36
	mla	r8, r8, r5, r2
	str	r3, [r8, #4]
	ldr	r3, [sp, #40]
	cmp	r4, r3
	ldr	r3, .L2969+8
	bne	.L2939
	ldr	r2, .L2969+24
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
	bne	.L2940
	str	r7, [r8, #8]
.L2940:
	ldr	r3, .L2969+36
	ldr	r2, .L2969+40
	str	r4, [r8, #16]
	ldrh	r3, [r3]
	ldr	r2, [r2]
	muls	r3, r5, r3
	adds	r5, r5, #1
	bic	r3, r3, #3
	add	r3, r3, r2
	str	r3, [r8, #12]
	b	.L2938
.L2939:
	ldr	r2, [sp, #44]
	cmp	r4, r2
	bne	.L2941
	ldr	r2, .L2969+44
	ldr	r1, [sp, #36]
	ldr	r2, [r2]
	str	r2, [r8, #8]
	ldrh	r2, [r3]
	mul	r3, r2, r4
	subs	r1, r1, r3
	cmp	r2, r1
	str	r1, [sp, #24]
	bne	.L2940
.L2967:
	subs	r3, r3, r6
	add	r3, r7, r3, lsl #9
	str	r3, [r8, #8]
	b	.L2940
.L2941:
	ldrh	r3, [r3]
	muls	r3, r4, r3
	b	.L2967
.L2944:
	ldr	r1, [sp, #44]
	cmp	r1, r2
	bne	.L2945
	ldr	r1, [r3, #8]
	ldr	r3, .L2969+44
	ldr	r3, [r3]
	cmp	r1, r3
	bne	.L2945
	ldr	r3, .L2969+8
	ldr	r2, [sp, #68]
	ldrh	r0, [r3]
	ldr	r3, [sp, #44]
	muls	r0, r3, r0
	subs	r0, r0, r6
	add	r0, r7, r0, lsl #9
	b	.L2968
.L2947:
	cmp	r3, #256
	bne	.L2948
	ldr	r0, [r2, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	mov	r8, r0
	bl	FtlGcRefreshBlock
	ldr	r2, .L2969+48
	movw	r3, #2049
.L2950:
	subs	r3, r3, #1
	bne	.L2949
.L2951:
	bl	FtlSysFlush
	b	.L2948
.L2949:
	movs	r1, #1
	str	r2, [sp, #76]
	mov	r0, r1
	str	r3, [sp, #72]
	bl	rk_ftl_garbage_collect
	ldr	r2, [sp, #76]
	ldr	r3, [sp, #72]
	ldrh	r1, [r2]
	cmp	r1, r8
	beq	.L2950
	b	.L2951
.L2954:
	mov	r3, #-1
.L2955:
	str	r3, [sp, #32]
	b	.L2930
.L2970:
	.align	2
.L2969:
	.word	.LANCHOR69
	.word	.LANCHOR231
	.word	.LANCHOR56
	.word	.LANCHOR166
	.word	.LANCHOR117
	.word	.LANCHOR38
	.word	.LANCHOR186
	.word	.LC61
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
	ldr	r3, .L3019
	sub	sp, sp, #80
	mov	r6, r1
	str	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L3004
	cmp	r0, #16
	bne	.L2973
	mov	r2, r10
	ldr	r1, [sp, #12]
	add	r0, r6, #256
	bl	FtlVendorPartWrite
.L2971:
	add	sp, sp, #80
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2973:
	ldr	r3, [sp, #12]
	adds	r5, r1, r3
	ldr	r3, .L3019+4
	ldr	r3, [r3]
	cmp	r5, r3
	bhi	.L3005
	ldr	r3, .L3019+8
	ldr	r0, [r3]
	adds	r4, r0, #1
	beq	.L2971
	ldr	r3, .L3019+12
	mov	r2, #2048
	mov	r0, r6
	str	r2, [r3]
	ldr	r3, .L3019+16
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	mov	r1, r4
	mov	r8, r0
	subs	r0, r5, #1
	bl	__aeabi_uidiv
	ldr	r2, .L3019+20
	sub	r5, r0, r8
	adds	r3, r5, #1
	adds	r1, r5, #1
	str	r3, [sp, #4]
	ldr	r3, [r2]
	str	r0, [sp, #16]
	add	r3, r3, r1
	str	r3, [r2]
	ldr	r3, .L3019+24
	ldr	fp, [r3]
	cmp	fp, #0
	beq	.L2975
	ldr	r3, [fp, #16]
	cmp	r8, r3
	beq	.L2976
	bl	FtlCacheWriteBack
.L2975:
	ldr	r7, .L3019+28
	mov	r4, r8
.L2977:
	ldr	r3, [sp, #4]
	cbnz	r3, .L3003
	ldr	r3, [sp, #16]
	ldr	r0, [sp, #4]
	sub	r1, r3, r8
	bl	rk_ftl_garbage_collect
.L3004:
	movs	r0, #0
	b	.L2971
.L2976:
	ldr	r2, .L3019+32
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
	beq	.L3004
	ldr	r3, [sp, #12]
	add	r6, r6, r4
	add	r10, r10, r7
	add	r8, r8, #1
	subs	r3, r3, r4
	str	r3, [sp, #12]
	bl	FtlCacheWriteBack
	str	r5, [sp, #4]
	b	.L2975
.L3003:
	ldr	r5, .L3019+36
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r5]
	cmp	r2, r3
	bcc	.L2978
	ldr	r1, .L3019+40
	movw	r2, #1668
	ldr	r0, .L3019+44
	bl	printf
	ldr	r1, .L3019+48
	ldr	r0, .L3019+52
	bl	printf
.L2978:
	ldrh	r3, [r7, #4]
	cbnz	r3, .L2979
	bl	FtlCacheWriteBack
	mov	r0, r7
	bl	allocate_new_data_superblock
.L2979:
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
	bcc	.L2980
	ldr	r1, .L3019+40
	movw	r2, #1701
	ldr	r0, .L3019+44
	bl	printf
	ldr	r1, .L3019+48
	ldr	r0, .L3019+52
	bl	printf
.L2980:
	movs	r3, #0
.L3018:
	str	r3, [sp, #8]
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #36]
	cmp	r3, r2
	bne	.L3001
.L2982:
	ldr	r0, .L3019+56
	mov	r3, r7
	movs	r2, #0
	ldr	r1, [sp, #8]
	ldr	r0, [r0]
	bl	FtlProgPages
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #8]
	cmp	r3, r2
	bcs	.L3002
	ldr	r1, .L3019+40
	movw	r2, #1790
	ldr	r0, .L3019+44
	bl	printf
	ldr	r1, .L3019+48
	ldr	r0, .L3019+52
	bl	printf
.L3002:
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #8]
	subs	r3, r3, r2
	str	r3, [sp, #4]
	b	.L2977
.L3001:
	ldrh	r3, [r7, #4]
	cmp	r3, #0
	beq	.L2982
	movs	r2, #0
	add	r1, sp, #40
	mov	r0, r4
	movs	r5, #36
	bl	log2phys
	mov	r0, r7
	bl	get_new_active_ppa
	ldr	r3, [sp, #8]
	ldr	r2, .L3019+60
	muls	r5, r3, r5
	ldr	r3, .L3019+56
	ldrh	r2, [r2]
	ldr	r1, [r3]
	str	r3, [sp, #20]
	ldr	r3, [sp, #8]
	add	r1, r1, r5
	str	r0, [r1, #4]
	str	r4, [r1, #16]
	mul	r0, r2, r3
	bic	r3, r0, #3
	ldr	r0, .L3019+64
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
	ldr	r1, .L3019+16
	beq	.L2983
	ldr	r3, [sp, #16]
	cmp	r3, r4
	ldr	r3, [sp, #20]
	bne	.L3014
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
	b	.L2986
.L2983:
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
.L2986:
	ldr	r3, .L3019+16
	ldr	r2, [sp, #20]
	ldrh	r3, [r3]
	cmp	r3, r2
	ldr	r3, .L3019+56
	ldr	r3, [r3]
	bne	.L2987
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
.L2989:
	ldr	r3, .L3019+36
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2998
	ldr	r1, .L3019+40
	movw	r2, #1775
	ldr	r0, .L3019+44
	bl	printf
	ldr	r1, .L3019+48
	ldr	r0, .L3019+52
	bl	printf
.L2998:
	ldr	r2, [sp, #32]
	movw	r3, #61589
	ldr	r1, [sp, #28]
	strh	r3, [r2, r1]	@ movhi
	ldr	r2, .L3019+68
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
	b	.L3018
.L3020:
	.align	2
.L3019:
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
.L2987:
	cmp	r4, r8
	add	r3, r3, r5
	ite	eq
	ldreq	r2, .L3021
	ldrne	r2, .L3021+4
	ldr	r2, [r2]
	str	r2, [r3, #8]
	ldr	r2, [sp, #40]
	ldr	r3, .L3021+8
	adds	r0, r2, #1
	beq	.L2992
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
	bne	.L2993
	ldr	r2, .L3021+12
	ldr	r3, [r2, #72]
	adds	r3, r3, #1
	str	r3, [r2, #72]
.L2996:
	ldr	r2, [sp, #20]
	cmp	r4, r8
	ldr	r3, .L3021+8
	lsl	r2, r2, #9
	bne	.L2997
	ldr	r3, [r3]
	mov	r1, r10
	add	r5, r5, r3
	ldr	r3, [sp, #24]
	ldr	r0, [r5, #8]
	add	r0, r0, r3, lsl #9
.L3016:
	bl	ftl_memcpy
	b	.L2989
.L2993:
	ldr	r1, [fp, #8]
	cmp	r4, r1
	beq	.L2995
	ldr	r2, .L3021+12
	ldr	r0, .L3021+16
	ldr	r3, [r2, #72]
	adds	r3, r3, #1
	str	r3, [r2, #72]
	mov	r2, r4
	bl	printf
.L2995:
	ldr	r3, [fp, #8]
	cmp	r4, r3
	beq	.L2996
	movw	r2, #1754
	ldr	r1, .L3021+20
	ldr	r0, .L3021+24
	bl	printf
	ldr	r1, .L3021+28
	ldr	r0, .L3021+32
	bl	printf
	b	.L2996
.L2992:
	ldr	r3, [r3]
	movs	r1, #0
	ldr	r2, .L3021+36
	add	r3, r3, r5
	ldrh	r2, [r2]
	ldr	r0, [r3, #8]
	bl	ftl_memset
	b	.L2996
.L2997:
	ldr	r1, .L3021+40
	ldr	r3, [r3]
	ldrh	r1, [r1]
	add	r5, r5, r3
	ldr	r0, [r5, #8]
	muls	r1, r4, r1
	subs	r1, r1, r6
	add	r1, r10, r1, lsl #9
	b	.L3016
.L3014:
	ldr	r3, [r3]
	add	r5, r5, r3
	ldrh	r3, [r1]
	muls	r3, r4, r3
	subs	r3, r3, r6
	add	r3, r10, r3, lsl #9
	str	r3, [r5, #8]
	b	.L2989
.L3005:
	mov	r0, #-1
	b	.L2971
.L3022:
	.align	2
.L3021:
	.word	.LANCHOR186
	.word	.LANCHOR187
	.word	.LANCHOR182
	.word	.LANCHOR138
	.word	.LC73
	.word	.LANCHOR247
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LANCHOR58
	.word	.LANCHOR56
	.size	FtlWrite, .-FtlWrite
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
	cbnz	r0, .L3026
	mov	r3, r2
	mov	r2, r5
	bl	idb_write_data
.L3026:
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
	ldr	r6, .L3051
	ldr	r5, .L3051+4
	ldr	r1, .L3051+8
	ldr	r0, .L3051+12
	bl	printf
	mov	r2, #8192
	movs	r1, #0
	ldr	r0, .L3051+4
	bl	memset
.L3028:
	ldr	r3, [r6]
	cmp	r4, r3
	bcc	.L3030
	ldr	r7, .L3051+16
	movs	r4, #0
	ldr	r5, .L3051+20
	movs	r2, #2
	ldr	r10, .L3051+4
	mov	r6, r4
	ldr	fp, .L3051+60
	mov	r8, r7
	ldrh	r3, [r7]
	ldr	r1, [r5]
	ldr	r0, .L3051+24
	bl	rknand_print_hex
	ldrh	r3, [r7]
	movs	r2, #2
	ldr	r1, .L3051+4
	ldr	r0, .L3051+28
	bl	rknand_print_hex
.L3031:
	ldrh	r2, [r8]
	uxth	r3, r4
	cmp	r2, r3
	bhi	.L3033
	ldr	r3, .L3051+32
	ldr	r4, [r3]
	cbz	r4, .L3034
	ldr	r3, .L3051+36
	mov	r8, #0
	ldr	r7, .L3051+40
	ldr	fp, .L3051+64
	ldrh	r10, [r3]
	ldr	r3, [r7]
	subs	r4, r4, r3
	ldr	r3, .L3051+44
	asrs	r4, r4, #1
	muls	r4, r3, r4
	uxth	r4, r4
.L3035:
	uxth	r3, r8
	cmp	r10, r3
	bls	.L3034
	ldr	r3, [r5]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L3036
	ldr	r3, .L3051+4
	movs	r6, #1
	mov	r1, r4
	mov	r0, fp
	ldrh	r3, [r3, r4, lsl #1]
	bl	printf
.L3036:
	movs	r3, #6
	ldr	r2, [r7]
	muls	r4, r3, r4
	movw	r3, #65535
	add	r8, r8, #1
	ldrh	r4, [r2, r4]
	cmp	r4, r3
	bne	.L3035
.L3034:
	cbz	r6, .L3027
	ldr	r1, .L3051+8
	mov	r2, #1680
	ldr	r0, .L3051+48
	bl	printf
	ldr	r1, .L3051+52
	ldr	r0, .L3051+56
	bl	printf
.L3027:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3030:
	movs	r2, #0
	add	r1, sp, #4
	mov	r0, r4
	bl	log2phys
	ldr	r0, [sp, #4]
	adds	r3, r0, #1
	beq	.L3029
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r5, r0, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r5, r0, lsl #1]	@ movhi
.L3029:
	adds	r4, r4, #1
	b	.L3028
.L3033:
	ldr	r3, [r5]
	uxth	r7, r4
	ldrh	r2, [r3, r7, lsl #1]
	ldrh	r3, [r10, r7, lsl #1]
	cmp	r2, r3
	beq	.L3032
	mov	r1, r7
	mov	r0, fp
	bl	printf
	ldr	r3, [r5]
	movw	r2, #65535
	ldrh	r3, [r3, r7, lsl #1]
	cmp	r3, r2
	beq	.L3032
	ldrh	r2, [r10, r7, lsl #1]
	cmp	r2, r3
	it	hi
	movhi	r6, #1
.L3032:
	adds	r4, r4, #1
	b	.L3031
.L3052:
	.align	2
.L3051:
	.word	.LANCHOR73
	.word	check_valid_page_count_table
	.word	.LANCHOR248
	.word	.LC46
	.word	.LANCHOR40
	.word	.LANCHOR84
	.word	.LC74
	.word	.LC75
	.word	.LANCHOR88
	.word	.LANCHOR89
	.word	.LANCHOR82
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
	ldr	r5, .L3060
	sub	sp, sp, #24
	mov	r7, r0
	movs	r6, #0
	ldr	r4, .L3060+4
	ldr	r3, [r5]
	ldr	r8, .L3060+20
	mov	fp, r4
	str	r3, [r4, #8]
	ldr	r3, .L3060+8
	ldr	r3, [r3]
	str	r3, [r4, #12]
.L3054:
	ldrh	r2, [r8]
	sxth	r3, r6
	cmp	r3, r2
	blt	.L3056
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L3056:
	movs	r2, #1
	orr	r3, r3, r10
	mov	r1, r2
	mov	r0, fp
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r2, [r4, #8]
	mov	r1, r7
	ldr	r3, [r4, #12]
	ldr	r0, .L3060+12
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
	beq	.L3055
	mov	r3, #768
	movs	r2, #4
	ldr	r1, [r5]
	ldr	r0, .L3060+16
	bl	rknand_print_hex
.L3055:
	adds	r6, r6, #1
	b	.L3054
.L3061:
	.align	2
.L3060:
	.word	.LANCHOR183
	.word	.LANCHOR202
	.word	.LANCHOR188
	.word	.LC78
	.word	.LC79
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
	ldr	r3, .L3076
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	ldr	r8, .L3076+72
	ldrh	r5, [r3]
.L3063:
	ldr	r3, .L3076+4
	ldrh	r3, [r3]
	cmp	r3, r5
	bhi	.L3070
	ldr	r4, .L3076+8
	movs	r7, #0
.L3071:
	ldr	r3, .L3076+12
	sxth	r5, r7
	ldrh	r3, [r3]
	cmp	r5, r3
	bge	.L3074
	lsls	r5, r5, #1
	movs	r6, #0
	ldr	r8, .L3076+76
	b	.L3075
.L3065:
	str	r3, [sp, #36]
	mov	r1, r5
	ldr	r3, .L3076+16
	str	r2, [sp, #32]
	ldrb	r0, [r3, r6]	@ zero_extendqisi2
	bl	V2P_block
	str	r0, [sp, #28]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #32]
	ldr	r3, [sp, #36]
	cbnz	r0, .L3064
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
.L3064:
	adds	r6, r6, #1
.L3072:
	uxth	r1, r6
	cmp	r2, r1
	bhi	.L3065
	cbnz	r4, .L3066
.L3069:
	adds	r5, r5, #1
	uxth	r5, r5
	b	.L3063
.L3066:
	ldr	r10, .L3076+80
	mov	r0, r7
	movs	r6, #0
	movs	r7, #36
	movs	r2, #1
	mov	r1, r4
	bl	FlashReadPages
.L3067:
	uxth	r3, r6
	cmp	r4, r3
	bls	.L3069
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
	b	.L3067
.L3070:
	ldr	r1, .L3076+20
	movs	r6, #0
	ldr	r3, .L3076+24
	mov	r4, r6
	ldr	r7, [r8]
	mov	fp, #36
	ldr	r1, [r1]
	ldrh	r2, [r3]
	ldr	r3, .L3076+28
	str	r1, [sp, #24]
	ldr	r1, .L3076+32
	ldr	r3, [r3]
	ldrh	r10, [r1]
	b	.L3072
.L3073:
	ldr	r10, .L3076+44
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
	ldr	r0, .L3076+36
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
.L3075:
	ldrh	r2, [r8]
	sxth	r3, r6
	adds	r6, r6, #1
	cmp	r3, r2
	blt	.L3073
	adds	r7, r7, #1
	b	.L3071
.L3074:
	ldr	r3, .L3076+40
	movs	r2, #2
	ldr	r1, .L3076+44
	ldr	r0, .L3076+48
	ldr	r3, [r3]
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r4, .L3076+52
	movs	r2, #4
	ldr	r1, .L3076+56
	ldr	r0, .L3076+60
	ldrh	r3, [r4]
	ldr	r1, [r1]
	bl	rknand_print_hex
	ldr	r1, .L3076+64
	movs	r2, #4
	ldrh	r3, [r4]
	ldr	r0, .L3076+68
	ldr	r1, [r1]
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	rknand_print_hex
.L3077:
	.align	2
.L3076:
	.word	.LANCHOR40
	.word	.LANCHOR41
	.word	.LANCHOR202
	.word	.LANCHOR128
	.word	.LANCHOR47
	.word	.LANCHOR106
	.word	.LANCHOR38
	.word	.LANCHOR105
	.word	.LANCHOR59
	.word	.LC49
	.word	.LANCHOR65
	.word	.LANCHOR129
	.word	.LC81
	.word	.LANCHOR67
	.word	.LANCHOR131
	.word	.LC82
	.word	.LANCHOR195
	.word	.LC83
	.word	.LANCHOR180
	.word	.LANCHOR54
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
.LC54:
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
.LC46:
	.ascii	"...%s enter...\012\000"
.LC47:
	.ascii	"superBlkID = %x vpc=%x\012\000"
.LC48:
	.ascii	"flashmode = %x pagenum = %x %x\012\000"
.LC49:
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
.LC53:
	.ascii	"FtlGcScanTempBlkError ID %x %x!!!!!!!\012\000"
	.section	.rodata.FtlInit.str1.1,"aMS",%progbits,1
.LC67:
	.ascii	"FTL version: 5.0.49 20180810\000"
.LC68:
	.ascii	"...%s: no bad block mapping table, format device\012"
	.ascii	"\000"
.LC69:
	.ascii	"...%s FtlSysBlkInit error ,format device!\012\000"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",%progbits,1
.LC44:
	.ascii	"no ect\000"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",%progbits,1
.LC41:
	.ascii	"FtlMapWritePage error = %x\012\000"
.LC42:
	.ascii	"FtlMapWritePage error = %x error count = %d\012\000"
	.section	.rodata.FtlProgPages.str1.1,"aMS",%progbits,1
.LC58:
	.ascii	"Ftlwrite decrement_vpc_count %x = %d\012\000"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",%progbits,1
.LC62:
	.ascii	"RSB refresh addr %x\012\000"
.LC63:
	.ascii	"spuer block %x vpn is 0\012 \000"
.LC64:
	.ascii	"g_recovery_ppa %x ver %x\012 \000"
	.section	.rodata.FtlScanAllBlock.str1.1,"aMS",%progbits,1
.LC50:
	.ascii	"blk = %x vpc=%x mode = %x\012\000"
.LC51:
	.ascii	"mlc id = %x,%x addr= %x,spare= %x %x %x %x data=%x "
	.ascii	"%x\012\000"
.LC52:
	.ascii	"slc id = %x,%x addr= %x,spare= %x %x %x %x data=%x "
	.ascii	"%x\012\000"
	.section	.rodata.FtlVendorPartRead.str1.1,"aMS",%progbits,1
.LC43:
	.ascii	"FtlVendorPartRead refresh = %x phyAddr = %x\012\000"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",%progbits,1
.LC38:
	.ascii	"FtlVpcTblFlush error = %x error count = %d\012\000"
	.section	.rodata.FtlWrite.str1.1,"aMS",%progbits,1
.LC73:
	.ascii	"FtlWrite: lpa error:%x %x\012\000"
	.section	.rodata.Ftl_load_ext_data.str1.1,"aMS",%progbits,1
.LC45:
	.ascii	"slc mode\000"
	.section	.rodata.Ftlscanalldata.str1.1,"aMS",%progbits,1
.LC59:
	.ascii	"Ftlscanalldata = %x\012\000"
.LC60:
	.ascii	"scan lpa = %x ppa= %x\012\000"
.LC61:
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
	.section	.rodata.__func__.10473,"a",%progbits
	.set	.LANCHOR245,. + 0
	.type	__func__.10473, %object
	.size	__func__.10473, 8
__func__.10473:
	.ascii	"FtlInit\000"
	.section	.rodata.__func__.10533,"a",%progbits
	.set	.LANCHOR229,. + 0
	.type	__func__.10533, %object
	.size	__func__.10533, 13
__func__.10533:
	.ascii	"FtlProgPages\000"
	.section	.rodata.__func__.10559,"a",%progbits
	.set	.LANCHOR247,. + 0
	.type	__func__.10559, %object
	.size	__func__.10559, 9
__func__.10559:
	.ascii	"FtlWrite\000"
	.section	.rodata.__func__.10622,"a",%progbits
	.set	.LANCHOR124,. + 0
	.type	__func__.10622, %object
	.size	__func__.10622, 14
__func__.10622:
	.ascii	"FtlBbt2Bitmap\000"
	.section	.rodata.__func__.10668,"a",%progbits
	.set	.LANCHOR211,. + 0
	.type	__func__.10668, %object
	.size	__func__.10668, 11
__func__.10668:
	.ascii	"FtlLoadBbt\000"
	.section	.rodata.__func__.10761,"a",%progbits
	.set	.LANCHOR90,. + 0
	.type	__func__.10761, %object
	.size	__func__.10761, 17
__func__.10761:
	.ascii	"INSERT_FREE_LIST\000"
	.section	.rodata.__func__.10765,"a",%progbits
	.set	.LANCHOR87,. + 0
	.type	__func__.10765, %object
	.size	__func__.10765, 17
__func__.10765:
	.ascii	"INSERT_DATA_LIST\000"
	.section	.rodata.__func__.10802,"a",%progbits
	.set	.LANCHOR91,. + 0
	.type	__func__.10802, %object
	.size	__func__.10802, 17
__func__.10802:
	.ascii	"List_remove_node\000"
	.section	.rodata.__func__.10832,"a",%progbits
	.set	.LANCHOR95,. + 0
	.type	__func__.10832, %object
	.size	__func__.10832, 22
__func__.10832:
	.ascii	"List_update_data_list\000"
	.section	.rodata.__func__.10839,"a",%progbits
	.set	.LANCHOR228,. + 0
	.type	__func__.10839, %object
	.size	__func__.10839, 20
__func__.10839:
	.ascii	"ftl_load_l2p_region\000"
	.section	.rodata.__func__.10870,"a",%progbits
	.set	.LANCHOR96,. + 0
	.type	__func__.10870, %object
	.size	__func__.10870, 26
__func__.10870:
	.ascii	"ftl_map_blk_alloc_new_blk\000"
	.section	.rodata.__func__.10884,"a",%progbits
	.set	.LANCHOR212,. + 0
	.type	__func__.10884, %object
	.size	__func__.10884, 15
__func__.10884:
	.ascii	"ftl_map_blk_gc\000"
	.section	.rodata.__func__.10897,"a",%progbits
	.set	.LANCHOR213,. + 0
	.type	__func__.10897, %object
	.size	__func__.10897, 31
__func__.10897:
	.ascii	"Ftl_write_map_blk_to_last_page\000"
	.section	.rodata.__func__.10910,"a",%progbits
	.set	.LANCHOR214,. + 0
	.type	__func__.10910, %object
	.size	__func__.10910, 16
__func__.10910:
	.ascii	"FtlMapWritePage\000"
	.section	.rodata.__func__.10930,"a",%progbits
	.set	.LANCHOR99,. + 0
	.type	__func__.10930, %object
	.size	__func__.10930, 22
__func__.10930:
	.ascii	"select_l2p_ram_region\000"
	.section	.rodata.__func__.10946,"a",%progbits
	.set	.LANCHOR227,. + 0
	.type	__func__.10946, %object
	.size	__func__.10946, 9
__func__.10946:
	.ascii	"log2phys\000"
	.section	.rodata.__func__.11008,"a",%progbits
	.set	.LANCHOR210,. + 0
	.type	__func__.11008, %object
	.size	__func__.11008, 15
__func__.11008:
	.ascii	"FtlVpcTblFlush\000"
	.section	.rodata.__func__.11027,"a",%progbits
	.set	.LANCHOR220,. + 0
	.type	__func__.11027, %object
	.size	__func__.11027, 14
__func__.11027:
	.ascii	"FtlScanSysBlk\000"
	.section	.rodata.__func__.11081,"a",%progbits
	.set	.LANCHOR221,. + 0
	.type	__func__.11081, %object
	.size	__func__.11081, 15
__func__.11081:
	.ascii	"FtlLoadSysInfo\000"
	.section	.rodata.__func__.11092,"a",%progbits
	.set	.LANCHOR248,. + 0
	.type	__func__.11092, %object
	.size	__func__.11092, 12
__func__.11092:
	.ascii	"FtlCheckVpc\000"
	.section	.rodata.__func__.11124,"a",%progbits
	.set	.LANCHOR224,. + 0
	.type	__func__.11124, %object
	.size	__func__.11124, 17
__func__.11124:
	.ascii	"FtlDumpBlockInfo\000"
	.section	.rodata.__func__.11143,"a",%progbits
	.set	.LANCHOR225,. + 0
	.type	__func__.11143, %object
	.size	__func__.11143, 16
__func__.11143:
	.ascii	"FtlScanAllBlock\000"
	.section	.rodata.__func__.11248,"a",%progbits
	.set	.LANCHOR233,. + 0
	.type	__func__.11248, %object
	.size	__func__.11248, 16
__func__.11248:
	.ascii	"FtlReUsePrevPpa\000"
	.section	.rodata.__func__.11281,"a",%progbits
	.set	.LANCHOR234,. + 0
	.type	__func__.11281, %object
	.size	__func__.11281, 22
__func__.11281:
	.ascii	"FtlRecoverySuperblock\000"
	.section	.rodata.__func__.11335,"a",%progbits
	.set	.LANCHOR102,. + 0
	.type	__func__.11335, %object
	.size	__func__.11335, 16
__func__.11335:
	.ascii	"make_superblock\000"
	.section	.rodata.__func__.11355,"a",%progbits
	.set	.LANCHOR140,. + 0
	.type	__func__.11355, %object
	.size	__func__.11355, 18
__func__.11355:
	.ascii	"SupperBlkListInit\000"
	.section	.rodata.__func__.11432,"a",%progbits
	.set	.LANCHOR203,. + 0
	.type	__func__.11432, %object
	.size	__func__.11432, 25
__func__.11432:
	.ascii	"allocate_data_superblock\000"
	.section	.rodata.__func__.11446,"a",%progbits
	.set	.LANCHOR219,. + 0
	.type	__func__.11446, %object
	.size	__func__.11446, 29
__func__.11446:
	.ascii	"allocate_new_data_superblock\000"
	.section	.rodata.__func__.11452,"a",%progbits
	.set	.LANCHOR208,. + 0
	.type	__func__.11452, %object
	.size	__func__.11452, 19
__func__.11452:
	.ascii	"get_new_active_ppa\000"
	.section	.rodata.__func__.11463,"a",%progbits
	.set	.LANCHOR206,. + 0
	.type	__func__.11463, %object
	.size	__func__.11463, 16
__func__.11463:
	.ascii	"update_vpc_list\000"
	.section	.rodata.__func__.11468,"a",%progbits
	.set	.LANCHOR207,. + 0
	.type	__func__.11468, %object
	.size	__func__.11468, 20
__func__.11468:
	.ascii	"decrement_vpc_count\000"
	.section	.rodata.__func__.11536,"a",%progbits
	.set	.LANCHOR239,. + 0
	.type	__func__.11536, %object
	.size	__func__.11536, 19
__func__.11536:
	.ascii	"FtlGcFreeTempBlock\000"
	.section	.rodata.__func__.11630,"a",%progbits
	.set	.LANCHOR243,. + 0
	.type	__func__.11630, %object
	.size	__func__.11630, 23
__func__.11630:
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
	.ascii	"ftl_map_blk_gc blk info: %x %x %x\012\000"
.LC40:
	.ascii	"page map lost: %x %x\012\000"
	.section	.rodata.idb_write_data.str1.1,"aMS",%progbits,1
.LC15:
	.ascii	"1 write_idblock fix data %x %x %x\012\000"
.LC16:
	.ascii	"write_idblock fail! %x %x %x %x\012\000"
.LC17:
	.ascii	"write_idblock fail! %x\012\000"
	.section	.rodata.log2phys.str1.1,"aMS",%progbits,1
.LC55:
	.ascii	"load_l2p_region refresh = %x phyAddr = %x\012\000"
.LC56:
	.ascii	"region_id = %x phyAddr = %x\012\000"
.LC57:
	.ascii	"map_ppn:\000"
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
