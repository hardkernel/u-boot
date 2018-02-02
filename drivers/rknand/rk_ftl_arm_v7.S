/*
 * Copyright (c) 2016-2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * date: 2018-02-01
 */
	.syntax unified
	.arch armv7-a
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 4
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"rk_ftl_arm_v7.S"
	.section	.text.ftl_set_blk_mode.part.9,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_set_blk_mode.part.9, %function
ftl_set_blk_mode.part.9:
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
	.size	ftl_set_blk_mode.part.9, .-ftl_set_blk_mode.part.9
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
	ldr	r8, .L250+12
	sub	sp, sp, #20
	mov	r5, r0
	movs	r6, #0
	ldr	r10, .L250+16
.L241:
	cmp	r6, r7
	bne	.L246
	movs	r0, #0
	add	sp, sp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L246:
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
	bhi	.L242
	mov	r3, #-1
	str	r3, [r5]
.L243:
	adds	r6, r6, #1
	adds	r5, r5, #36
	b	.L241
.L242:
	ldrb	r4, [r10, r3]	@ zero_extendqisi2
	lsls	r3, r3, #4
	ldr	r2, .L250
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
	ldr	r3, .L250+4
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
	bne	.L245
	ldr	r1, [sp, #8]
	ldr	r0, .L250+8
	bl	printf
.L245:
	mov	r0, r4
	bl	NandcFlashDeCs
	b	.L243
.L251:
	.align	2
.L250:
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
	ldr	r3, .L279
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r0
	sub	sp, sp, #24
	mov	fp, r1
	mov	r7, r2
	ldrb	r4, [r3]	@ zero_extendqisi2
	cbnz	r4, .L253
	ldr	r10, .L279+8
.L254:
	cmp	r4, r7
	bcc	.L263
	ldr	r5, .L279+4
	movs	r4, #0
	ldr	r6, .L279+8
.L264:
	ldr	r3, .L279+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L266
	movs	r0, #0
	b	.L252
.L253:
	mov	r1, r2
	bl	FlashEraseSLc2KBlocks
.L252:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L263:
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
	ldr	r3, .L279+12
	mov	r6, r0
	ldr	r0, [sp, #20]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L256
	mov	r3, #-1
	str	r3, [r8, r5]
.L257:
	adds	r4, r4, #1
	b	.L254
.L256:
	ldr	r3, .L279+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	add	r3, r10, r0, lsl #4
	it	eq
	moveq	r6, #0
	ldr	r3, [r3, #8]
	cbz	r3, .L259
	uxtb	r0, r0
	bl	FlashWaitCmdDone
.L259:
	ldr	r1, [sp, #20]
	ldr	r0, [sp, #12]
	lsls	r2, r1, #4
	add	r3, r10, r2
	str	r0, [r3, #8]
	movs	r0, #0
	str	r0, [r3, #12]
	ldr	r0, [sp, #16]
	str	r0, [r3, #4]
	cbz	r6, .L260
	adds	r5, r5, #36
	add	r5, r5, r8
	str	r5, [r3, #12]
.L260:
	ldr	r3, .L279+20
	ldrb	r5, [r3, r1]	@ zero_extendqisi2
	mov	r0, r5
	strb	r5, [r10, r2]
	bl	NandcFlashCs
	cmp	fp, #1
	mov	r0, r5
	bne	.L261
	ldr	r3, .L279+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L261
	bl	flash_enter_slc_mode
.L262:
	ldr	r3, .L279+24
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
	b	.L257
.L261:
	bl	flash_exit_slc_mode
	b	.L262
.L266:
	uxtb	r0, r4
	bl	FlashWaitCmdDone
	cmp	fp, #1
	bne	.L265
	ldrb	r3, [r5]	@ zero_extendqisi2
	cbz	r3, .L265
	lsls	r3, r4, #4
	ldrb	r0, [r6, r3]	@ zero_extendqisi2
	bl	flash_exit_slc_mode
.L265:
	adds	r4, r4, #1
	b	.L264
.L280:
	.align	2
.L279:
	.word	.LANCHOR1
	.word	.LANCHOR8
	.word	.LANCHOR23
	.word	.LANCHOR25
	.word	.LANCHOR27
	.word	.LANCHOR26
	.word	.LANCHOR17
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
	ldr	r3, .L285
	mov	r6, r1
	uxtb	lr, r1
	mov	r7, r0
	lsrs	r1, r1, #8
	uxtb	r8, r5
	ldr	r10, [r3, r0, lsl #3]
	add	r3, r3, r0, lsl #3
	ldrb	r4, [r3, #4]	@ zero_extendqisi2
	ldr	r3, .L285+4
	ldrb	r2, [r3, #16]	@ zero_extendqisi2
	lsls	r4, r4, #8
	ldrb	ip, [r3, #8]	@ zero_extendqisi2
	add	r4, r4, r10
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	cmp	r2, #1
	lsr	r2, r6, #16
	str	ip, [r4, #2056]
	bne	.L282
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
.L284:
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
.L282:
	str	lr, [r4, #2052]
	str	r1, [r4, #2052]
	str	r2, [r4, #2052]
	str	r3, [r4, #2056]
	b	.L284
.L286:
	.align	2
.L285:
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
	ldr	r4, .L295
	bl	NandcWaitFlashReady
	bl	FlashSetReadRetryDefault
	ldrb	r3, [r4]	@ zero_extendqisi2
	cbz	r3, .L288
	ldr	r3, .L295+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L288
	movs	r0, #1
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	movs	r3, #0
	strb	r3, [r4]
.L288:
	ldr	r3, .L295+8
	movs	r0, #0
	ldr	r3, [r3]
	str	r0, [r3, #336]
	pop	{r4, pc}
.L296:
	.align	2
.L295:
	.word	.LANCHOR28
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
	ldr	r3, .L298
	ldr	r3, [r3, r0, lsl #3]
	str	r1, [r3, #336]
	bx	lr
.L299:
	.align	2
.L298:
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
	ldr	r3, .L305
	cmp	r0, #35
	ldr	r3, [r3]
	bhi	.L301
	movw	r2, #4193
.L304:
	str	r2, [r3, #4]
	bx	lr
.L301:
	cmp	r0, #99
	ite	hi
	movwhi	r2, #8322
	movwls	r2, #4225
	b	.L304
.L306:
	.align	2
.L305:
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
	ldr	r3, .L308
	ldrb	r0, [r3, #21]	@ zero_extendqisi2
	b	NandcTimeCfg
.L309:
	.align	2
.L308:
	.word	.LANCHOR29
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
	ldr	r3, .L318
	movs	r1, #0
	push	{r4, lr}
	movs	r4, #16
	cmp	r0, r4
	ldr	r2, [r3]
	mov	r3, #1
	str	r3, [r2, #8]
	ldr	r3, .L318+4
	str	r0, [r3]
	mov	r3, r1
	bfi	r3, r4, #8, #8
	bfi	r3, r1, #18, #1
	bne	.L311
.L314:
	bfc	r3, #4, #1
.L312:
	orr	r3, r3, #1
	str	r3, [r2, #12]
	pop	{r4, pc}
.L311:
	cmp	r0, #24
	bne	.L313
	orr	r3, r3, #16
	b	.L312
.L313:
	cmp	r0, #40
	orr	r3, r3, #262144
	orr	r3, r3, #16
	bne	.L312
	b	.L314
.L319:
	.align	2
.L318:
	.word	.LANCHOR19
	.word	.LANCHOR30
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
	ldr	r3, .L321
	strb	r0, [r3]
	b	NandcBchSel
.L322:
	.align	2
.L321:
	.word	.LANCHOR31
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
	ldr	r3, .L330
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
.L331:
	.align	2
.L330:
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
.L333:
	ldr	r3, [r0, #8]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #11
	bpl	.L333
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
	bne	.L350
	adds	r5, fp, #0
	it	ne
	movne	r5, #1
.L337:
	ldr	r1, .L355
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
	ldr	r3, .L355+4
	ldr	r3, [r3]
	cmp	r3, #3
	bls	.L338
	ldr	r3, [r6, #16]
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	bfc	r3, #2, #1
	str	r3, [sp, #20]
	cmp	r5, #0
	beq	.L339
	ldr	r5, .L355+8
	cmp	r7, #0
	bne	.L340
.L348:
	ldr	r2, [sp, #4]
	adds	r2, r2, #1
	asrs	r2, r2, #1
	bfi	r4, r2, #22, #6
	cmp	fp, #0
	beq	.L341
	mov	r0, fp
.L342:
	ldr	r3, [r5, #4]
	ubfx	r10, r4, #22, #5
	add	r1, r0, r10, lsl #10
	str	r0, [r5, #8]
	str	r0, [r5, #16]
	clz	r7, r7
	str	r3, [r5, #12]
	lsrs	r7, r7, #5
	str	r3, [r5, #20]
	bl	flush_dcache_range
	ldr	r0, [r5, #12]
	add	r1, r0, r10, lsl #7
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
.L339:
	ldr	r3, [sp, #20]
	str	r3, [r6, #16]
.L338:
	str	r8, [r6, #12]
	str	r4, [r6, #8]
	orr	r4, r4, #4
	str	r4, [r6, #8]
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L350:
	movs	r5, #1
	b	.L337
.L340:
	ldr	r3, .L355+12
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
.L344:
	ldr	r2, [sp, #12]
	cmp	r0, r2
	bcs	.L348
	ldr	r2, [sp, #60]
	bic	r10, r1, #3
	cbz	r2, .L345
	ldrh	ip, [r3]
	adds	r3, r3, #4
	ldrh	r2, [r3, #-2]
	orr	ip, ip, r2, lsl #16
	str	ip, [lr, r10]
.L346:
	ldr	r2, [sp, #8]
	adds	r0, r0, #1
	add	r1, r1, r2
	b	.L344
.L345:
	mov	r2, #-1
	str	r2, [lr, r10]
	b	.L346
.L341:
	ldr	r3, .L355+8
	ldr	r0, [r3]
	b	.L342
.L356:
	.align	2
.L355:
	.word	.LANCHOR6
	.word	.LANCHOR32
	.word	.LANCHOR33
	.word	.LANCHOR30
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
	ldr	r3, .L387
	push	{r0, r1, r4, lr}
	ldr	r1, [r3, r0, lsl #3]
	ldr	r3, .L387+4
	ldr	r0, [r3]
	cmp	r0, #3
	bls	.L380
	ldr	r3, [r1, #16]
	lsls	r2, r3, #29
	bpl	.L380
	ldr	r3, [r1, #16]
	tst	r3, #2
	ldr	r3, [r1, #8]
	str	r3, [sp]
	beq	.L367
.L361:
	ldr	r2, [r1, #28]
	ldr	r3, [sp]
	ubfx	r2, r2, #16, #5
	ubfx	r3, r3, #22, #6
	cmp	r2, r3
	bge	.L365
	cmp	r0, #5
	bls	.L361
	ldr	r3, [r1]
	str	r3, [sp, #4]
	ldr	r3, [sp, #4]
	lsls	r3, r3, #18
	bpl	.L361
	ldr	r3, [sp, #4]
	lsls	r4, r3, #14
	bpl	.L361
.L365:
	ldr	r4, .L387+8
	ldr	r3, [r4, #24]
	cbz	r3, .L366
	ldr	r0, [r4, #16]
	ldr	r1, [sp]
	ubfx	r1, r1, #22, #5
	add	r1, r0, r1, lsl #10
	bl	invalidate_dcache_range
	ldr	r0, [r4, #20]
	ldr	r1, [sp]
	ubfx	r1, r1, #22, #5
	add	r1, r0, r1, lsl #7
	bl	invalidate_dcache_range
.L366:
	ldr	r3, .L387+8
	movs	r2, #0
	str	r2, [r3, #24]
.L357:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, pc}
.L368:
	ldr	r3, [r1, #8]
	str	r3, [sp]
.L367:
	ldr	r3, [sp]
	lsls	r2, r3, #11
	bpl	.L368
	ldr	r4, .L387+12
	ldr	r2, [r4]
	cbz	r2, .L369
	mov	r0, r1
	bl	NandcSendDumpDataStart
.L369:
	ldr	r3, [r4]
	cmp	r3, #0
	beq	.L366
	mov	r0, r1
	bl	NandcSendDumpDataDone
	b	.L366
.L380:
	ldr	r3, [r1, #8]
	str	r3, [sp]
	ldr	r3, [sp]
	lsls	r3, r3, #11
	bpl	.L380
	b	.L357
.L388:
	.align	2
.L387:
	.word	.LANCHOR6
	.word	.LANCHOR32
	.word	.LANCHOR33
	.word	.LANCHOR34
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
.L390:
	cmp	r2, r0
	uxth	r3, r1
	add	r1, r1, #1
	bls	.L391
	subs	r0, r3, #1
	uxth	r0, r0
	bx	lr
.L391:
	lsls	r2, r2, #1
	b	.L390
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
	ldr	r3, .L394
	cmp	r0, #24
	it	cc
	movcc	r0, #24
	ldr	r2, .L394+4
	str	r0, [r3]
	ldr	r3, .L394+8
	ldrh	r3, [r3]
	muls	r3, r0, r3
	str	r3, [r2]
	ldr	r2, .L394+12
	ldrh	r2, [r2]
	subs	r0, r2, r0
	ldr	r2, .L394+16
	strh	r0, [r2]	@ movhi
	movs	r0, #0
	ldr	r2, .L394+20
	ldr	r2, [r2]
	subs	r3, r2, r3
	ldr	r2, .L394+24
	str	r3, [r2]
	bx	lr
.L395:
	.align	2
.L394:
	.word	.LANCHOR35
	.word	.LANCHOR37
	.word	.LANCHOR36
	.word	.LANCHOR39
	.word	.LANCHOR38
	.word	.LANCHOR41
	.word	.LANCHOR40
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
	ldr	r3, .L424
	ldr	r1, .L424+4
	ldrh	r6, [r10, #14]
	ldr	r2, .L424+8
	strh	r7, [r3]	@ movhi
	ldrh	r3, [r0, #10]
	ldrh	r0, [r0, #12]
	strh	r6, [r1]	@ movhi
	str	r1, [sp, #20]
	ldr	r1, .L424+12
	ldr	r4, .L424+16
	strh	r0, [r2]	@ movhi
	movs	r2, #0
	strh	r3, [r4]	@ movhi
	str	r4, [sp, #8]
.L397:
	strb	r2, [r2, r1]
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L397
	ldrh	r1, [r10, #14]
	ldrh	r2, [r10, #20]
	cmp	r2, r1, lsr #8
	bcs	.L398
	uxtb	r8, r0
	lsl	r2, r8, #1
	uxtb	r2, r2
	str	r2, [sp, #4]
	subs	r2, r3, #1
	muls	r2, r0, r2
	str	r2, [sp, #12]
	movs	r2, #0
.L399:
	cmp	r2, r0
	bcs	.L401
	ldr	r4, [sp, #12]
	sub	fp, r2, r0
	uxtb	r1, r2
	adds	r5, r2, r4
	ldr	r4, .L424+12
	add	r4, r4, r5
	movs	r5, #0
	mov	lr, r4
	ldr	r4, .L424+12
	mov	ip, r5
	add	fp, fp, r4
	b	.L402
.L400:
	add	r4, r8, r1
	strb	r1, [fp, r5]
	str	r4, [sp, #16]
	add	ip, ip, #1
	ldrb	r4, [sp, #16]	@ zero_extendqisi2
	strb	r4, [lr, r5]
	ldr	r4, [sp, #4]
	add	r1, r1, r4
	uxtb	r1, r1
.L402:
	cmp	ip, r3
	add	r5, r5, r0
	bcc	.L400
	adds	r2, r2, #1
	b	.L399
.L401:
	ldr	r2, [sp, #8]
	lsls	r3, r3, #1
	lsrs	r6, r6, #1
	strh	r3, [r2]	@ movhi
	ldr	r3, .L424+4
	strh	r6, [r3]	@ movhi
.L398:
	ldr	r3, .L424+20
	movs	r2, #5
	cmp	r7, #1
	mov	r1, #0
	strh	r2, [r3]	@ movhi
	ldr	r2, .L424+24
	it	eq
	strheq	r7, [r3]	@ movhi
	ldr	r3, .L424+28
	strh	r1, [r2]	@ movhi
	mov	r1, #4352
	strh	r1, [r3]	@ movhi
	ldr	r1, .L424+32
	ldrb	r1, [r1]	@ zero_extendqisi2
	str	r1, [sp, #4]
	cbz	r1, .L404
	mov	r1, #384
	strh	r1, [r3]	@ movhi
.L404:
	ldr	r3, [sp, #8]
	str	r2, [sp, #16]
	ldr	fp, .L424+120
	ldrh	r5, [r3]
	ldr	r3, .L424+36
	ldr	r8, .L424+124
	smulbb	r5, r5, r0
	uxth	r5, r5
	strh	r5, [r3]	@ movhi
	ldr	r3, [sp, #20]
	ldrh	r4, [r3]
	ldr	r3, .L424+40
	smulbb	r0, r0, r4
	uxth	r0, r0
	strh	r0, [r3]	@ movhi
	bl	Ftl_log2
	ldr	r3, .L424+44
	ldrh	r6, [r10, #16]
	ldrh	r1, [r10, #18]
	strh	r0, [r3]	@ movhi
	ldr	r3, .L424+48
	smulbb	r0, r5, r6
	strh	r6, [fp]	@ movhi
	str	r1, [sp, #12]
	strh	r1, [r3]	@ movhi
	ldr	r3, .L424+52
	strh	r0, [r3]	@ movhi
	ldrh	r3, [r10, #20]
	mov	r0, r3
	strh	r3, [r8]	@ movhi
	str	r3, [sp, #8]
	bl	Ftl_log2
	ldr	r3, [sp, #8]
	mov	r7, r0
	ldr	ip, .L424+128
	cmp	r4, #1024
	ldr	lr, .L424+132
	ldr	r2, [sp, #16]
	strh	r0, [ip]	@ movhi
	lsl	r0, r3, #9
	ldr	r1, [sp, #12]
	uxth	r0, r0
	strh	r0, [lr]	@ movhi
	lsr	r0, r0, #8
	ldr	lr, .L424+136
	mul	r1, r3, r1
	strh	r0, [lr]	@ movhi
	ldrh	lr, [r10, #26]
	mov	r10, ip
	ldr	r0, .L424+56
	strh	lr, [r0]	@ movhi
	mul	lr, r4, r5
	ldr	r0, .L424+60
	str	lr, [r0]
	itt	hi
	uxtbhi	r0, r4
	strhhi	r0, [r2]	@ movhi
	ldrh	r2, [r2]
	subs	r2, r4, r2
	muls	r2, r5, r2
	muls	r2, r3, r2
	muls	r6, r2, r6
	ldr	r2, .L424+64
	asrs	r6, r6, #11
	str	r6, [r2]
	ldr	r6, .L424+28
	ldrh	r0, [r6]
	lsls	r0, r0, #3
	bl	__aeabi_idiv
	uxth	r0, r0
	mov	r3, r6
	ldr	r6, .L424+68
	cmp	r0, #4
	itt	ls
	movls	r2, #4
	strhls	r2, [r6]	@ movhi
	ldr	r2, [sp, #4]
	it	hi
	strhhi	r0, [r6]	@ movhi
	cbz	r2, .L408
	mov	r2, #640
	strh	r2, [r3]	@ movhi
.L408:
	ldrh	r3, [r3]
	lsls	r4, r4, #6
	ldr	r2, .L424+72
	mov	r1, r5
	ldrh	r0, [r6]
	asrs	r3, r3, r7
	adds	r7, r7, #9
	asrs	r4, r4, r7
	ldr	r7, .L424+76
	adds	r3, r3, #2
	strh	r3, [r2]	@ movhi
	ldr	r3, .L424+80
	strh	r4, [r3]	@ movhi
	uxth	r4, r4
	mul	r3, r4, r5
	adds	r4, r4, #8
	str	r3, [r7]
	bl	__aeabi_uidiv
	uxtah	r0, r4, r0
	ldr	r4, .L424+84
	cmp	r5, #1
	it	eq
	addeq	r0, r0, #4
	str	r0, [r4]
	ldrh	r0, [r4]
	bl	FtlSysBlkNumInit
	ldr	r2, [r4]
	movs	r0, #24
	ldr	r3, .L424+88
	str	r2, [r3]
	ldr	r3, .L424+92
	ldr	r2, [r3]
	ldrh	r3, [fp]
	lsls	r2, r2, #2
	muls	r3, r2, r3
	ldrh	r2, [r10]
	adds	r2, r2, #9
	lsrs	r3, r3, r2
	ldr	r2, .L424+96
	adds	r3, r3, #2
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L424+100
	strh	r0, [r2]	@ movhi
	movs	r0, #0
	ldr	r2, .L424+104
	str	r0, [r2]
	ldrh	r0, [r6]
	adds	r2, r0, #3
	strh	r2, [r6]	@ movhi
	ldr	r2, [r7]
	adds	r4, r2, #3
	str	r4, [r7]
	ldr	r4, .L424+108
	ldrb	r4, [r4]	@ zero_extendqisi2
	cbz	r4, .L411
	adds	r0, r0, #4
	adds	r2, r2, #5
	strh	r0, [r6]	@ movhi
	str	r2, [r7]
.L411:
	ldr	r1, .L424+112
	movs	r2, #0
	strh	r2, [r1]	@ movhi
	ldr	r2, .L424+116
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
.L425:
	.align	2
.L424:
	.word	.LANCHOR42
	.word	.LANCHOR39
	.word	.LANCHOR44
	.word	.LANCHOR45
	.word	.LANCHOR43
	.word	.LANCHOR46
	.word	.LANCHOR47
	.word	.LANCHOR48
	.word	.LANCHOR1
	.word	.LANCHOR36
	.word	.LANCHOR49
	.word	.LANCHOR50
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR58
	.word	.LANCHOR41
	.word	.LANCHOR59
	.word	.LANCHOR60
	.word	.LANCHOR61
	.word	.LANCHOR63
	.word	.LANCHOR62
	.word	.LANCHOR35
	.word	.LANCHOR64
	.word	.LANCHOR40
	.word	.LANCHOR65
	.word	.LANCHOR66
	.word	.LANCHOR67
	.word	.LANCHOR8
	.word	.LANCHOR68
	.word	.LANCHOR38
	.word	.LANCHOR51
	.word	.LANCHOR54
	.word	.LANCHOR55
	.word	.LANCHOR56
	.word	.LANCHOR57
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
	ldr	r3, .L433
	ldrh	r3, [r3]
	cbz	r3, .L432
	ldr	r3, .L433+4
	ldr	r2, .L433+8
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L428:
	cmp	r3, r2
	bne	.L429
.L432:
	movs	r0, #0
	bx	lr
.L429:
	ldrh	r1, [r3], #2
	cmp	r0, r1
	bne	.L428
	movs	r0, #1
	bx	lr
.L434:
	.align	2
.L433:
	.word	.LANCHOR69
	.word	.LANCHOR70
	.word	.LANCHOR60
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
	ldr	r3, .L436
	ldr	r0, [r3]
	bx	lr
.L437:
	.align	2
.L436:
	.word	.LANCHOR67
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
	ldr	r3, .L439
	ldr	r0, [r3]
	bx	lr
.L440:
	.align	2
.L439:
	.word	.LANCHOR67
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
	ldr	r3, .L442
	ldr	r0, [r3]
	bx	lr
.L443:
	.align	2
.L442:
	.word	.LANCHOR67
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
	ldr	r3, .L445
	ldr	r0, [r3]
	bx	lr
.L446:
	.align	2
.L445:
	.word	.LANCHOR71
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
	ldr	r2, .L448
	ldr	r3, .L448+4
	ldr	r0, [r2]
	ldrh	r3, [r3]
	muls	r0, r3, r0
	bx	lr
.L449:
	.align	2
.L448:
	.word	.LANCHOR72
	.word	.LANCHOR36
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
	ldr	r2, .L451
	ldr	r3, .L451+4
	ldrh	r0, [r2]
	ldrh	r3, [r3]
	muls	r0, r3, r0
	bx	lr
.L452:
	.align	2
.L451:
	.word	.LANCHOR36
	.word	.LANCHOR39
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
	ldr	r3, .L454
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	mov	r1, r4
	ldr	r4, .L454+4
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
	ldr	r0, .L454+8
	bl	printf
	ldrh	r3, [r4, #6]
	movs	r0, #0
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L455:
	.align	2
.L454:
	.word	.LANCHOR49
	.word	.LANCHOR73
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
	ldr	r3, .L457
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	mov	r1, r5
	bl	__aeabi_uidivmod
	mov	r0, r6
	uxth	r4, r1
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r3, .L457+4
	uxth	r0, r0
	lsrs	r2, r4, #5
	and	r4, r4, #31
	add	r0, r3, r0, lsl #2
	ldr	r3, [r0, #28]
	ldr	r0, [r3, r2, lsl #2]
	lsrs	r0, r0, r4
	and	r0, r0, #1
	pop	{r4, r5, r6, pc}
.L458:
	.align	2
.L457:
	.word	.LANCHOR49
	.word	.LANCHOR73
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
	ldr	r3, .L461
	mov	r7, r0
	ldrh	r6, [r3]
	mov	r1, r6
	bl	__aeabi_uidiv
	ldr	r3, .L461+4
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
.L462:
	.align	2
.L461:
	.word	.LANCHOR44
	.word	.LANCHOR49
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
	ldr	r3, .L464
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	ldr	r3, .L464+4
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	smulbb	r4, r0, r5
	mov	r1, r5
	mov	r0, r6
	bl	__aeabi_uidivmod
	add	r1, r1, r4
	uxth	r0, r1
	pop	{r4, r5, r6, pc}
.L465:
	.align	2
.L464:
	.word	.LANCHOR44
	.word	.LANCHOR49
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
	ldr	r3, .L467
	ldrh	r1, [r3]
	bl	__aeabi_uidivmod
	ldr	r3, .L467+4
	uxth	r0, r1
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	uxth	r0, r0
	pop	{r3, pc}
.L468:
	.align	2
.L467:
	.word	.LANCHOR49
	.word	.LANCHOR44
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
	bls	.L470
	subs	r0, r0, r1
	cmp	r0, #-2147483648
	ite	hi
	movhi	r0, #0
	movls	r0, #1
	bx	lr
.L470:
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
	ldr	r3, .L473
	ldrh	r0, [r3, #6]
	clz	r0, r0
	lsrs	r0, r0, #5
	bx	lr
.L474:
	.align	2
.L473:
	.word	.LANCHOR74
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
	ldr	r3, .L476
	ldrh	r0, [r3, #6]
	sub	r3, r0, #1024
	rsbs	r0, r3, #0
	adcs	r0, r0, r3
	bx	lr
.L477:
	.align	2
.L476:
	.word	.LANCHOR74
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
	push	{r4, r5, r6, lr}
	mov	r5, r0
	ldr	r4, .L487
	ldrh	r3, [r4, #6]
	cmp	r3, #1024
	beq	.L478
	cbz	r1, .L480
	ldr	r3, .L487+4
	ldr	r3, [r3]
	cbnz	r3, .L480
	bl	P2V_block_in_plane
	ldr	r3, .L487+8
	mov	r6, r0
	movs	r2, #1
	mov	r1, r2
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L487+12
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	ldr	r2, .L487+16
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L480:
	ldrh	r3, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #4]
	adds	r2, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	strh	r5, [r4, r2, lsl #1]	@ movhi
	strh	r3, [r4, #4]	@ movhi
.L478:
	pop	{r4, r5, r6, pc}
.L488:
	.align	2
.L487:
	.word	.LANCHOR74
	.word	.LANCHOR75
	.word	.LANCHOR76
	.word	.LANCHOR77
	.word	.LANCHOR78
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r4, .L498
	ldr	r3, .L498+4
	ldrh	r7, [r4, #2]
	ldrh	r6, [r4, #6]
	ldr	r5, [r3]
	ldr	r3, .L498+8
	add	r8, r4, r7, lsl #1
	mov	r10, r5
	ldr	r3, [r3]
	add	fp, r5, r6, lsl #2
	add	r8, r8, #6
.L490:
	cmp	r10, fp
	bne	.L491
	movs	r3, #0
	add	lr, r6, #-1
.L492:
	cmp	r3, lr
	blt	.L497
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L491:
	ldrh	r0, [r8, #2]!
	str	r3, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r3, [sp, #4]
	ldrh	r2, [r3, r0, lsl #1]
	str	r2, [r10], #4
	b	.L490
.L497:
	add	ip, r3, #1
	mov	r2, r3
	uxth	ip, ip
	mov	r8, ip
.L493:
	cmp	r8, r6
	bcc	.L495
	cmp	r3, r2
	beq	.L496
	ldr	r0, [r5, r2, lsl #2]
	ldr	r1, [r5, r3, lsl #2]
	str	r1, [r5, r2, lsl #2]
	add	r2, r2, r7
	str	r0, [r5, r3, lsl #2]
	add	r3, r3, r7
	adds	r2, r2, #4
	adds	r3, r3, #4
	ldrh	r1, [r4, r2, lsl #1]
	ldrh	r0, [r4, r3, lsl #1]
	strh	r0, [r4, r2, lsl #1]	@ movhi
	strh	r1, [r4, r3, lsl #1]	@ movhi
.L496:
	mov	r3, ip
	b	.L492
.L495:
	ldr	r1, [r5, r8, lsl #2]
	ldr	r0, [r5, r2, lsl #2]
	cmp	r0, r1
	it	hi
	movhi	r2, r8
	add	r8, r8, #1
	uxth	r8, r8
	b	.L493
.L499:
	.align	2
.L498:
	.word	.LANCHOR74
	.word	.LANCHOR79
	.word	.LANCHOR77
	.size	FtlFreeSysBLkSort, .-FtlFreeSysBLkSort
	.section	.text.remove_from_free_sys_Queue,"ax",%progbits
	.align	1
	.global	remove_from_free_sys_Queue
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	remove_from_free_sys_Queue, %function
remove_from_free_sys_Queue:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, lr}
	mov	r1, r0
	ldr	r5, .L507
	ldrh	r3, [r5, #6]
	cbz	r3, .L506
	ldrh	r0, [r5, #2]
	movs	r4, #0
.L502:
	cmp	r4, r3
	bcc	.L504
.L506:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L504:
	adds	r2, r4, r0
	ubfx	r2, r2, #0, #10
	adds	r2, r2, #4
	ldrh	r2, [r5, r2, lsl #1]
	cmp	r2, r1
	bne	.L503
	ldr	r0, .L507+4
	bl	printf
	ldrh	r3, [r5, #2]
	movs	r0, #1
	adds	r2, r3, #4
	add	r4, r4, r3
	adds	r3, r3, #1
	ldrh	r2, [r5, r2, lsl #1]
	ubfx	r3, r3, #0, #10
	ubfx	r4, r4, #0, #10
	strh	r3, [r5, #2]	@ movhi
	adds	r4, r4, #4
	ldrh	r3, [r5, #6]
	strh	r2, [r5, r4, lsl #1]	@ movhi
	subs	r3, r3, #1
	strh	r3, [r5, #6]	@ movhi
	pop	{r3, r4, r5, pc}
.L503:
	adds	r4, r4, #1
	b	.L502
.L508:
	.align	2
.L507:
	.word	.LANCHOR74
	.word	.LC3
	.size	remove_from_free_sys_Queue, .-remove_from_free_sys_Queue
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
	ldr	r2, .L516
	push	{r3, r4, r5, r6, r7, lr}
	ldrh	r1, [r2, #6]
	cbz	r1, .L512
	ldrh	r3, [r2, #2]
	subs	r1, r1, #1
	strh	r1, [r2, #6]	@ movhi
	adds	r0, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	ldrh	r4, [r2, r0, lsl #1]
	strh	r3, [r2, #2]	@ movhi
	ldr	r3, .L516+4
	ldr	r7, [r3]
	cbnz	r7, .L510
	ldr	r5, .L516+8
	mov	r0, r4
	bl	P2V_block_in_plane
	mov	r6, r0
	lsls	r2, r4, #10
	ldr	r0, [r5]
	str	r2, [r0, #4]
	ldr	r2, .L516+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbz	r2, .L511
	movs	r2, #1
	mov	r1, r7
	bl	FlashEraseBlocks
.L511:
	movs	r2, #1
	ldr	r0, [r5]
	mov	r1, r2
	bl	FlashEraseBlocks
	ldr	r3, .L516+16
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	ldr	r2, .L516+20
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L510:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L512:
	movw	r4, #65535
	b	.L510
.L517:
	.align	2
.L516:
	.word	.LANCHOR74
	.word	.LANCHOR75
	.word	.LANCHOR76
	.word	.LANCHOR8
	.word	.LANCHOR77
	.word	.LANCHOR78
	.size	FtlFreeSysBlkQueueOut, .-FtlFreeSysBlkQueueOut
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
	ldr	r3, .L534
	ldrh	lr, [r3]
	cmp	lr, r0
	bls	.L520
	ldr	r3, .L534+4
	movs	r5, #6
	ldr	r4, [r3]
	mul	r3, r5, r0
	str	r3, [sp, #4]
	adds	r1, r4, r3
	ldr	r2, [sp, #4]
	movw	r3, #65535
	strh	r3, [r1, #2]	@ movhi
	strh	r3, [r4, r2]	@ movhi
	ldr	r3, .L534+8
	ldr	ip, [r3]
	cmp	ip, #0
	bne	.L521
.L533:
	str	r1, [r3]
.L520:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L521:
	ldr	r3, .L534+12
	lsls	r2, r0, #1
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldrh	r6, [r3, r0, lsl #1]
	ldrh	r3, [r1, #4]
	cbz	r3, .L531
	mul	fp, r3, r6
.L522:
	sub	r3, ip, r4
	asrs	r6, r3, #1
	ldr	r3, .L534+16
	muls	r3, r6, r3
	ldr	r6, .L534+20
	ldr	r8, [r6]
	movs	r6, #0
	uxth	r3, r3
	add	r2, r8, r2
	str	r2, [sp, #12]
	mov	r2, ip
.L529:
	adds	r6, r6, #1
	uxth	r6, r6
	cmp	lr, r6
	bcc	.L520
	cmp	r3, r0
	beq	.L520
	ldr	r7, [sp, #8]
	lsl	r10, r3, #1
	ldrh	r7, [r7, r3, lsl #1]
	mov	r5, r7
	ldrh	r7, [r2, #4]
	cbz	r7, .L532
	muls	r7, r5, r7
.L524:
	cmp	fp, r7
	bne	.L525
	ldr	r5, [sp, #12]
	ldrh	r10, [r8, r10]
	ldrh	r7, [r5]
	cmp	r10, r7
	bcc	.L527
.L526:
	ldr	r5, [sp, #4]
	cmp	r2, ip
	strh	r3, [r4, r5]	@ movhi
	ldrh	r3, [r2, #2]
	strh	r3, [r1, #2]	@ movhi
	bne	.L530
	strh	r0, [r2, #2]	@ movhi
	ldr	r3, .L534+8
	b	.L533
.L531:
	mov	fp, #-1
	b	.L522
.L532:
	mov	r7, #-1
	b	.L524
.L525:
	bcc	.L526
.L527:
	ldrh	r7, [r2]
	movw	r5, #65535
	cmp	r7, r5
	bne	.L528
	strh	r3, [r1, #2]	@ movhi
	strh	r0, [r2]	@ movhi
	ldr	r3, .L534+24
	b	.L533
.L528:
	movs	r3, #6
	mla	r2, r3, r7, r4
	mov	r3, r7
	b	.L529
.L530:
	ldrh	r1, [r2, #2]
	movs	r3, #6
	muls	r3, r1, r3
	strh	r0, [r4, r3]	@ movhi
	strh	r0, [r2, #2]	@ movhi
	b	.L520
.L535:
	.align	2
.L534:
	.word	.LANCHOR38
	.word	.LANCHOR80
	.word	.LANCHOR81
	.word	.LANCHOR82
	.word	-1431655765
	.word	.LANCHOR77
	.word	.LANCHOR83
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
	ldr	r2, .L538
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L538+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L536
	ldr	r1, .L538+8
	movs	r2, #205
	ldr	r0, .L538+12
	bl	printf
	ldr	r1, .L538+16
	ldr	r0, .L538+20
	pop	{r3, lr}
	b	printf
.L536:
	pop	{r3, pc}
.L539:
	.align	2
.L538:
	.word	.LANCHOR84
	.word	.LANCHOR38
	.word	.LANCHOR85
	.word	.LC4
	.word	.LC5
	.word	.LC6
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
	beq	.L541
	ldr	r3, .L547
	mov	r10, #6
	mul	r7, r10, r0
	ldr	r4, [r3]
	ldr	r3, .L547+4
	adds	r5, r4, r7
	ldr	r6, [r3]
	mov	lr, r3
	strh	r1, [r5, #2]	@ movhi
	strh	r1, [r4, r7]	@ movhi
	cbnz	r6, .L542
	str	r5, [r3]
.L541:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L542:
	ldr	r3, .L547+8
	subs	r2, r6, r4
	mov	fp, r1
	ldr	ip, [r3]
	asrs	r3, r2, #1
	ldr	r2, .L547+12
	ldrh	r8, [ip, r0, lsl #1]
	muls	r2, r3, r2
	mov	r3, r6
	uxth	r2, r2
.L545:
	ldrh	r1, [ip, r2, lsl #1]
	cmp	r1, r8
	bcs	.L543
	ldrh	r1, [r3]
	cmp	r1, fp
	bne	.L544
	strh	r2, [r5, #2]	@ movhi
	strh	r0, [r3]	@ movhi
	b	.L541
.L544:
	mla	r3, r10, r1, r4
	mov	r2, r1
	b	.L545
.L543:
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
	b	.L541
.L548:
	.align	2
.L547:
	.word	.LANCHOR80
	.word	.LANCHOR86
	.word	.LANCHOR77
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
	ldr	r2, .L551
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L551+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L549
	ldr	r1, .L551+8
	movs	r2, #198
	ldr	r0, .L551+12
	bl	printf
	ldr	r1, .L551+16
	ldr	r0, .L551+20
	pop	{r3, lr}
	b	printf
.L549:
	pop	{r3, pc}
.L552:
	.align	2
.L551:
	.word	.LANCHOR87
	.word	.LANCHOR38
	.word	.LANCHOR88
	.word	.LC4
	.word	.LC5
	.word	.LC6
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
	ldr	r5, .L559
	muls	r6, r1, r6
	movw	r3, #65535
	mov	r8, r0
	ldr	r7, [r5]
	adds	r4, r7, r6
	ldrh	r2, [r4, #2]
	cmp	r2, r3
	bne	.L554
	ldr	r3, [r0]
	cmp	r4, r3
	beq	.L554
	ldr	r1, .L559+4
	movw	r2, #363
	ldr	r0, .L559+8
	bl	printf
	ldr	r1, .L559+12
	ldr	r0, .L559+16
	bl	printf
.L554:
	ldr	r3, [r8]
	movw	r1, #65535
	cmp	r4, r3
	ldrh	r3, [r7, r6]
	bne	.L555
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
.L557:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r7, r6]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	pop	{r4, r5, r6, r7, r8, pc}
.L555:
	cmp	r3, r1
	ldrh	r1, [r4, #2]
	bne	.L558
	cmp	r1, r3
	beq	.L557
	movs	r2, #6
	ldr	r0, [r5]
	muls	r1, r2, r1
	strh	r3, [r0, r1]	@ movhi
	b	.L557
.L558:
	ldr	r0, [r5]
	movs	r2, #6
	mla	r5, r2, r3, r0
	strh	r1, [r5, #2]	@ movhi
	ldrh	r1, [r4, #2]
	muls	r2, r1, r2
	strh	r3, [r0, r2]	@ movhi
	b	.L557
.L560:
	.align	2
.L559:
	.word	.LANCHOR80
	.word	.LANCHOR89
	.word	.LC4
	.word	.LC5
	.word	.LC6
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
	cbz	r3, .L567
	ldr	r2, .L568
	movw	r5, #65535
	movs	r6, #6
	ldr	r2, [r2]
.L563:
	cbnz	r1, .L564
.L566:
	ldr	r4, .L568+4
	subs	r3, r3, r2
	asrs	r3, r3, #1
	muls	r4, r3, r4
	uxth	r1, r4
	bl	List_remove_node
	uxth	r0, r4
	pop	{r4, r5, r6, pc}
.L564:
	ldrh	r4, [r3]
	cmp	r4, r5
	beq	.L566
	subs	r1, r1, #1
	mla	r3, r6, r4, r2
	uxth	r1, r1
	b	.L563
.L567:
	movw	r0, #65535
	pop	{r4, r5, r6, pc}
.L569:
	.align	2
.L568:
	.word	.LANCHOR80
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
	ldr	r3, .L576
	push	{r4, lr}
	ldr	r3, [r3]
	cbz	r3, .L575
	ldr	r2, .L576+4
	movs	r4, #6
	ldr	r1, [r2]
	movw	r2, #65535
.L572:
	cbz	r0, .L573
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L574
.L575:
	movw	r0, #65535
	pop	{r4, pc}
.L574:
	subs	r0, r0, #1
	mla	r3, r4, r3, r1
	uxth	r0, r0
	b	.L572
.L573:
	ldr	r0, .L576+8
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r0, r3
	uxth	r0, r3
	pop	{r4, pc}
.L577:
	.align	2
.L576:
	.word	.LANCHOR81
	.word	.LANCHOR80
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
	ldr	r3, .L587
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L580
	ldr	r3, .L587+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L580
	ldr	r3, .L587+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L580
	ldr	r7, .L587+12
	movs	r6, #6
	ldr	r3, .L587+16
	muls	r6, r0, r6
	ldr	fp, [r7]
	ldr	r3, [r3]
	add	r10, fp, r6
	cmp	r10, r3
	beq	.L580
	ldr	r2, .L587+20
	ldrh	r5, [r10, #4]
	ldr	r3, [r2]
	mov	r8, r2
	movw	r2, #65535
	ldrh	r3, [r3, r0, lsl #1]
	muls	r5, r3, r5
	ldrh	r3, [r10, #2]
	it	eq
	moveq	r5, #-1
	cmp	r3, r2
	bne	.L583
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	bne	.L583
	ldr	r1, .L587+24
	movw	r2, #481
	ldr	r0, .L587+28
	bl	printf
	ldr	r1, .L587+32
	ldr	r0, .L587+36
	bl	printf
.L583:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L584
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	beq	.L580
.L584:
	movs	r2, #6
	muls	r2, r3, r2
	ldr	r3, .L587+40
	asrs	r1, r2, #1
	muls	r3, r1, r3
	ldr	r1, [r8]
	ldrh	r0, [r1, r3, lsl #1]
	ldr	r1, [r7]
	add	r2, r2, r1
	ldrh	r3, [r2, #4]
	muls	r3, r0, r3
	it	eq
	moveq	r3, #-1
	cmp	r5, r3
	bcs	.L580
	ldr	r5, .L587+44
	mov	r1, r4
	ldr	r0, .L587+16
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L586
	ldr	r1, .L587+24
	mov	r2, #492
	ldr	r0, .L587+28
	bl	printf
	ldr	r1, .L587+32
	ldr	r0, .L587+36
	bl	printf
.L586:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	INSERT_DATA_LIST
.L580:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L588:
	.align	2
.L587:
	.word	.LANCHOR90
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR80
	.word	.LANCHOR81
	.word	.LANCHOR82
	.word	.LANCHOR93
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	-1431655765
	.word	.LANCHOR84
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
.L590:
	uxth	r5, r3
	cmp	r5, r1
	bcc	.L592
.L593:
	movw	r2, #594
	ldr	r1, .L599
	ldr	r0, .L599+4
	bl	printf
	ldr	r1, .L599+8
	ldr	r0, .L599+12
	bl	printf
	b	.L594
.L592:
	mov	r7, r2
	adds	r3, r3, #1
	ldrh	r6, [r7]
	adds	r2, r2, #2
	cmp	r6, #0
	bne	.L590
	bl	FtlFreeSysBlkQueueOut
	strh	r0, [r7]	@ movhi
	cbz	r0, .L591
	ldr	r3, [r4, #28]
	strh	r6, [r4, #2]	@ movhi
	strh	r5, [r4]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #28]
	ldrh	r3, [r4, #8]
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
.L591:
	ldrh	r3, [r4, #10]
	cmp	r3, r5
	bls	.L593
.L594:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L600:
	.align	2
.L599:
	.word	.LANCHOR94
	.word	.LC4
	.word	.LC5
	.word	.LC6
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
	ldr	r3, .L611
	movs	r0, #12
	movw	r5, #65535
	ldrh	r2, [r3]
	ldr	r3, .L611+4
	ldr	r3, [r3]
.L602:
	uxth	r4, r1
	cmp	r4, r2
	bcc	.L604
	mov	r4, r2
	movs	r1, #0
	mov	r6, #-2147483648
	movs	r7, #12
.L605:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L607
	cmp	r4, r2
	bcc	.L603
	ldr	r1, .L611+8
	mov	r4, r2
	mov	r0, #-1
	ldrh	r7, [r1]
	movs	r1, #0
.L608:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L610
	cmp	r4, r2
	bcc	.L603
	movw	r2, #826
	ldr	r1, .L611+12
	ldr	r0, .L611+16
	bl	printf
	ldr	r1, .L611+20
	ldr	r0, .L611+24
	bl	printf
	b	.L603
.L604:
	adds	r1, r1, #1
	mla	r6, r0, r1, r3
	ldrh	r6, [r6, #-12]
	cmp	r6, r5
	bne	.L602
.L603:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L607:
	mla	r0, r7, r1, r3
	ldr	r0, [r0, #4]
	cmp	r0, #0
	blt	.L606
	cmp	r6, r0
	itt	hi
	movhi	r6, r0
	movhi	r4, r5
.L606:
	adds	r1, r1, #1
	b	.L605
.L610:
	ldr	r6, [r3, #4]
	cmp	r0, r6
	bls	.L609
	ldrh	ip, [r3]
	cmp	ip, r7
	itt	ne
	movne	r0, r6
	movne	r4, r5
.L609:
	adds	r1, r1, #1
	adds	r3, r3, #12
	b	.L608
.L612:
	.align	2
.L611:
	.word	.LANCHOR66
	.word	.LANCHOR95
	.word	.LANCHOR96
	.word	.LANCHOR97
	.word	.LC4
	.word	.LC5
	.word	.LC6
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
	ldr	r2, .L623
	push	{r4, r5, r6, lr}
	mov	r1, r2
	ldrh	r3, [r2]
	cmp	r3, #4
	bhi	.L614
	cbnz	r0, .L614
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	pop	{r4, r5, r6, pc}
.L614:
	movs	r3, #0
	ldr	r0, .L623+4
	strh	r3, [r1]	@ movhi
	movw	r6, #65535
	ldr	r1, .L623+8
	ldrh	r4, [r0]
	mov	r0, r3
	ldr	r2, .L623+12
	ldr	r1, [r1]
	str	r3, [r2]
	add	r4, r1, r4, lsl #1
.L615:
	cmp	r1, r4
	bne	.L617
	cbz	r3, .L613
	str	r0, [r2]
.L613:
	pop	{r4, r5, r6, pc}
.L617:
	ldrh	r5, [r1], #2
	cmp	r5, r6
	itt	ne
	addne	r0, r0, r5
	movne	r3, #1
	b	.L615
.L624:
	.align	2
.L623:
	.word	.LANCHOR98
	.word	.LANCHOR38
	.word	.LANCHOR82
	.word	.LANCHOR99
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
	cbz	r1, .L626
	b	ftl_set_blk_mode.part.9
.L626:
	ldr	r2, .L627
	lsrs	r0, r0, #5
	and	r3, r3, #31
	ldr	r1, [r2]
	movs	r2, #1
	lsl	r3, r2, r3
	ldr	r2, [r1, r0, lsl #2]
	bic	r2, r2, r3
	str	r2, [r1, r0, lsl #2]
	bx	lr
.L628:
	.align	2
.L627:
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
	ldr	r3, .L630
	lsrs	r2, r0, #5
	and	r0, r0, #31
	ldr	r3, [r3]
	ldr	r3, [r3, r2, lsl #2]
	lsr	r0, r3, r0
	and	r0, r0, #1
	bx	lr
.L631:
	.align	2
.L630:
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
	ldr	r3, .L639
	ldrh	r4, [r3]
	add	r3, r0, r2, lsl #1
	adds	r3, r3, #14
.L633:
	cmp	r2, r4
	bcc	.L635
	ldr	r3, .L639+4
	add	r5, r0, #16
	movw	r6, #65535
	ldrh	r3, [r3]
	subs	r3, r3, #1
	subs	r1, r3, r1
	movs	r3, #0
	uxth	r1, r1
.L636:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L638
	pop	{r4, r5, r6, pc}
.L635:
	ldrh	r5, [r3, #2]!
	adds	r2, r2, #1
	uxth	r2, r2
	cmp	r5, r6
	ittt	ne
	ldrhne	r5, [r0, #4]
	addne	r5, r5, #1
	strhne	r5, [r0, #4]	@ movhi
	b	.L633
.L638:
	ldrh	r2, [r5], #2
	adds	r3, r3, #1
	cmp	r2, r6
	ittt	ne
	ldrhne	r2, [r0, #4]
	addne	r2, r2, r1
	strhne	r2, [r0, #4]	@ movhi
	b	.L636
.L640:
	.align	2
.L639:
	.word	.LANCHOR36
	.word	.LANCHOR51
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
	ldr	r3, .L654
	ldrh	r2, [r0]
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L642
	ldr	r1, .L654+4
	movw	r2, #2296
	ldr	r0, .L654+8
	bl	printf
	ldr	r1, .L654+12
	ldr	r0, .L654+16
	bl	printf
.L642:
	ldr	r3, .L654+20
	add	r6, r4, #16
	ldr	r10, .L654+40
	movw	r7, #65535
	movs	r5, #0
	ldrh	r8, [r3]
	strh	r5, [r4, #4]	@ movhi
	strb	r5, [r4, #7]
.L643:
	uxth	r3, r5
	cmp	r8, r3
	bhi	.L645
	ldr	r2, .L654+24
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #9]
	ldr	r3, .L654+28
	ldr	r3, [r3]
	cbz	r3, .L646
	ldr	r3, .L654+32
	ldrh	r2, [r4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r3, #59
	itt	ls
	movls	r3, #1
	strbls	r3, [r4, #9]
.L646:
	ldr	r3, .L654+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L647
	movs	r3, #1
	strb	r3, [r4, #9]
.L647:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L645:
	ldrh	r1, [r4]
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	strh	r7, [r6]	@ movhi
	mov	fp, r0
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L644
	strh	fp, [r6]	@ movhi
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r4, #7]
.L644:
	adds	r5, r5, #1
	adds	r6, r6, #2
	b	.L643
.L655:
	.align	2
.L654:
	.word	.LANCHOR38
	.word	.LANCHOR100
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR36
	.word	.LANCHOR51
	.word	.LANCHOR101
	.word	.LANCHOR77
	.word	.LANCHOR1
	.word	.LANCHOR45
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
	ldr	r3, .L662
	mov	r6, r0
	mov	r4, r5
	ldr	r10, .L662+12
	ldrh	r7, [r3]
	ldr	r3, .L662+4
	ldrh	r8, [r3]
.L657:
	uxth	r3, r5
	cmp	r7, r3
	bhi	.L659
	cbz	r4, .L661
	mov	r1, r4
	mov	r0, #32768
	bl	__aeabi_idiv
.L660:
	ldr	r3, .L662+8
	movs	r2, #6
	ldr	r3, [r3]
	mla	r6, r2, r6, r3
	strh	r0, [r6, #4]	@ movhi
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L659:
	mov	r1, r6
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L658
	add	r4, r4, r8
	uxth	r4, r4
.L658:
	adds	r5, r5, #1
	b	.L657
.L661:
	mov	r0, r4
	b	.L660
.L663:
	.align	2
.L662:
	.word	.LANCHOR36
	.word	.LANCHOR51
	.word	.LANCHOR80
	.word	.LANCHOR45
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
	ldr	r3, .L667
	ldr	r0, [r3]
	cbz	r0, .L665
	ldr	r3, .L667+4
	ldr	r3, [r3]
	subs	r0, r0, r3
	ldr	r3, .L667+8
	asrs	r0, r0, #1
	muls	r0, r3, r0
	ldr	r3, .L667+12
	ldr	r3, [r3]
	uxth	r0, r0
	ldrh	r0, [r3, r0, lsl #1]
.L665:
	bx	lr
.L668:
	.align	2
.L667:
	.word	.LANCHOR86
	.word	.LANCHOR80
	.word	-1431655765
	.word	.LANCHOR77
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
	ldr	r3, .L677
	push	{r4, r5, r6, lr}
	ldr	r3, [r3]
	cbz	r3, .L675
	ldr	r2, .L677+4
	movs	r5, #6
	movw	r6, #65535
	ldrh	r2, [r2]
	rsb	r2, r2, r2, lsl #3
	asrs	r2, r2, #3
	cmp	r0, r2
	it	gt
	uxthgt	r0, r2
	ldr	r2, .L677+8
	ldr	r1, [r2]
	ldr	r2, .L677+12
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r2, r3
	movs	r2, #0
	uxth	r3, r3
.L672:
	uxth	r4, r2
	cmp	r0, r4
	bls	.L674
	mul	r4, r5, r3
	adds	r2, r2, #1
	ldrh	r4, [r1, r4]
	cmp	r4, r6
	bne	.L676
.L674:
	ldr	r2, .L677+16
	ldr	r2, [r2]
	ldrh	r0, [r2, r3, lsl #1]
	pop	{r4, r5, r6, pc}
.L676:
	mov	r3, r4
	b	.L672
.L675:
	mov	r0, r3
	pop	{r4, r5, r6, pc}
.L678:
	.align	2
.L677:
	.word	.LANCHOR86
	.word	.LANCHOR87
	.word	.LANCHOR80
	.word	-1431655765
	.word	.LANCHOR77
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
	beq	.L680
	ldr	r2, .L681
	movs	r1, #0
	ldr	r2, [r2]
	strh	r1, [r2, r0, lsl #1]	@ movhi
	bl	INSERT_FREE_LIST
.L680:
	movs	r0, #0
	pop	{r3, pc}
.L682:
	.align	2
.L681:
	.word	.LANCHOR82
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
	ldr	r1, .L688
	mov	fp, #1
	ldr	r2, .L688+4
	ldr	r5, [r1]
	ldr	r1, .L688+8
	str	r3, [r2]
	ldr	r2, .L688+12
	mov	r0, r5
	ldr	r1, [r1]
	ldrh	r2, [r2]
	str	r1, [sp, #4]
	ldr	r1, .L688+16
	ldrh	r1, [r1]
	str	r1, [sp]
	ldr	r1, .L688+20
	ldr	r10, [r1]
	ldr	r1, .L688+24
	ldrh	r7, [r1]
	ldr	r1, .L688+28
	ldr	r4, [r1]
	movs	r1, #12
	mla	r1, r2, r1, r1
	adds	r4, r4, #8
	add	r8, r5, r1
	mov	r1, r3
.L684:
	adds	r0, r0, #12
	ldr	r6, [sp]
	cmp	r0, r8
	add	ip, r3, r7
	add	r4, r4, #36
	add	lr, r1, r6
	bne	.L685
	ldr	r3, .L688+32
	mov	lr, #12
	mov	r8, #0
	ldr	r0, [r3]
	ldr	r3, .L688+8
	ldr	r4, [r3]
	ldr	r3, .L688+20
	ldr	ip, [r3]
.L686:
	cmp	r2, r0
	bcc	.L687
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L685:
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
	b	.L684
.L687:
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
	b	.L686
.L689:
	.align	2
.L688:
	.word	.LANCHOR103
	.word	.LANCHOR102
	.word	.LANCHOR104
	.word	.LANCHOR36
	.word	.LANCHOR56
	.word	.LANCHOR105
	.word	.LANCHOR57
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
	ldr	r3, .L697
	mov	ip, #12
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	mov	fp, #36
	mov	lr, r4
	ldr	r7, [r3]
	ldr	r3, .L697+4
	ldr	r5, [r3]
.L691:
	uxth	r3, r4
	cmp	r1, r3
	bls	.L690
	mla	r8, fp, r3, r0
	movs	r2, #0
.L692:
	uxth	r3, r2
	cmp	r7, r3
	bls	.L693
	mul	r3, ip, r3
	ldr	r6, [r8, #8]
	adds	r2, r2, #1
	add	r10, r5, r3
	ldr	r3, [r5, r3]
	cmp	r3, r6
	bne	.L692
	str	lr, [r10, #8]
.L693:
	adds	r4, r4, #1
	b	.L691
.L690:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L698:
	.align	2
.L697:
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
	ldr	r3, .L706
	movs	r2, #0
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	ip, #12
	movs	r7, #1
	mov	lr, #36
	ldr	r4, [r3]
	ldr	r3, .L706+4
	ldr	r5, [r3]
.L700:
	uxth	r8, r2
	cmp	r1, r8
	bhi	.L704
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L704:
	mov	r10, #0
.L701:
	uxth	r3, r10
	cmp	r4, r3
	bls	.L702
	mla	r3, ip, r3, r5
	add	r10, r10, #1
	ldr	r6, [r3, #8]
	cmp	r6, #0
	bne	.L701
	mla	r8, lr, r8, r0
	str	r7, [r3, #8]
	ldr	r6, [r3]
	ldr	r3, [r3, #4]
	str	r6, [r8, #8]
	str	r3, [r8, #12]
.L702:
	adds	r2, r2, #1
	b	.L700
.L707:
	.align	2
.L706:
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
	ldr	r3, .L713
	ldr	r2, .L713+4
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L709:
	cmp	r3, r2
	bne	.L711
	movs	r0, #0
	bx	lr
.L711:
	ldrh	r1, [r3], #2
	cmp	r1, r0
	bne	.L709
	movs	r0, #1
	bx	lr
.L714:
	.align	2
.L713:
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
	ldr	r4, .L719
	ubfx	r0, r0, #10, #16
	mov	r6, r1
	mov	r7, r2
	bl	P2V_block_in_plane
	ldr	r3, .L719+4
	ldrh	r1, [r4]
	ldr	r2, [r3]
	movs	r3, #0
.L716:
	uxth	ip, r3
	cmp	ip, r1
	bcc	.L718
	bne	.L717
	strh	r0, [r2, ip, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L717
.L718:
	adds	r3, r3, #1
	add	ip, r2, r3, lsl #1
	ldrh	ip, [ip, #-2]
	cmp	ip, r0
	bne	.L716
.L717:
	ldr	r2, .L719+8
	movs	r0, #12
	ldr	r1, .L719+12
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
.L720:
	.align	2
.L719:
	.word	.LANCHOR109
	.word	.LANCHOR108
	.word	.LANCHOR110
	.word	.LANCHOR111
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
	push	{r4, r5, lr}
	ldr	r4, .L724
	ldrh	r5, [r4]
	cmp	r5, r0
	beq	.L722
	ldr	r3, .L724+4
	ldrh	r1, [r3]
	cmp	r0, r1
	beq	.L722
	movw	r2, #65535
	cmp	r5, r2
	bne	.L723
	strh	r0, [r4]	@ movhi
.L722:
	movs	r0, #0
	pop	{r4, r5, pc}
.L723:
	cmp	r1, r2
	it	eq
	strheq	r0, [r3]	@ movhi
	b	.L722
.L725:
	.align	2
.L724:
	.word	.LANCHOR112
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
	ldr	r3, .L735
	ldr	r3, [r3]
	cbz	r3, .L728
	ldr	r3, .L735+4
	ldr	r2, [r3]
	ldrh	r3, [r2, r5, lsl #1]
	cmp	r3, #29
	itt	hi
	subhi	r3, r3, #30
	strhhi	r3, [r2, r5, lsl #1]	@ movhi
.L728:
	ldr	r2, .L735+8
	movs	r1, #0
	ldr	r5, .L735+12
	ldrh	r3, [r2]
.L729:
	uxth	r0, r1
	cmp	r3, r0
	bhi	.L731
	cmp	r3, #15
	itttt	ls
	addls	r1, r3, #1
	strhls	r1, [r2]	@ movhi
	ldrls	r2, .L735+12
	strhls	r4, [r2, r3, lsl #1]	@ movhi
	b	.L730
.L731:
	adds	r1, r1, #1
	add	r0, r5, r1, lsl #1
	ldrh	r0, [r0, #-2]
	cmp	r0, r4
	bne	.L729
.L730:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L736:
	.align	2
.L735:
	.word	.LANCHOR101
	.word	.LANCHOR77
	.word	.LANCHOR114
	.word	.LANCHOR115
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
	ldr	r3, .L743
	push	{r4, lr}
	ldrh	r3, [r3]
	cbz	r3, .L738
	ldr	r2, .L743+4
	ldrh	r1, [r2]
	movw	r2, #65535
	cmp	r1, r2
	bne	.L738
	ldr	r4, .L743+8
	ldrh	r2, [r4]
	cmp	r2, r3
	itt	cs
	movcs	r3, #0
	strhcs	r3, [r4]	@ movhi
	ldr	r3, .L743+12
	ldrh	r2, [r4]
	ldrh	r0, [r3, r2, lsl #1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
.L738:
	movs	r0, #0
	pop	{r4, pc}
.L744:
	.align	2
.L743:
	.word	.LANCHOR114
	.word	.LANCHOR112
	.word	.LANCHOR116
	.word	.LANCHOR115
	.size	FtlGcReFreshBadBlk, .-FtlGcReFreshBadBlk
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
	cbnz	r0, .L747
	ldr	r3, .L784
.L748:
	strh	r0, [r3, r0, lsl #1]	@ movhi
	adds	r0, r0, #1
	cmp	r0, #256
	bne	.L748
.L754:
	movs	r1, #255
	mov	r2, #1024
	ldr	r0, .L784+4
	uxth	r4, r4
	bl	ftl_memset
	ldr	r1, .L784
	movs	r3, #0
	ldr	r0, .L784+4
.L749:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L771
	pop	{r4, pc}
.L747:
	cmp	r0, #1
	bne	.L750
	ldr	r1, .L784
	movs	r3, #0
.L753:
	cmp	r3, #3
	uxth	r2, r3
	bls	.L751
	tst	r2, #1
	ite	ne
	movne	r0, #3
	moveq	r0, #2
	rsb	r2, r0, r2, lsl #1
	uxth	r2, r2
.L751:
	strh	r2, [r1, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L753
	b	.L754
.L750:
	cmp	r0, #2
	bne	.L755
	ldr	r1, .L784
	movs	r2, #0
.L757:
	uxth	r3, r2
	cmp	r2, #1
	ittt	hi
	lslhi	r3, r3, #1
	addhi	r3, r3, #-1
	uxthhi	r3, r3
	strh	r3, [r1, r2, lsl #1]	@ movhi
	adds	r2, r2, #1
	cmp	r2, #256
	bne	.L757
	b	.L754
.L755:
	cmp	r0, #3
	bne	.L758
	ldr	r1, .L784
	movs	r3, #0
.L761:
	cmp	r3, #5
	uxth	r2, r3
	bls	.L759
	tst	r2, #1
	ite	ne
	movne	r0, #5
	moveq	r0, #4
	rsb	r2, r0, r2, lsl #1
	uxth	r2, r2
.L759:
	strh	r2, [r1, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #256
	bne	.L761
	b	.L754
.L758:
	cmp	r0, #4
	mov	r3, #0
	bne	.L762
	ldr	r2, .L784
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
.L764:
	tst	r3, #1
	ite	ne
	movne	r1, #7
	moveq	r1, #6
	rsb	r1, r1, r3, lsl #1
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r1, [r2, #2]!	@ movhi
	cmp	r3, #256
	bne	.L764
	b	.L754
.L762:
	cmp	r0, #5
	bne	.L765
	ldr	r2, .L784
.L766:
	strh	r3, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	cmp	r3, #16
	bne	.L766
	ldr	r2, .L784+8
.L767:
	strh	r3, [r2, #2]!	@ movhi
	adds	r3, r3, #2
	uxth	r3, r3
	cmp	r3, #496
	bne	.L767
	b	.L754
.L765:
	cmp	r0, #6
	bne	.L754
	ldr	r0, .L784
	mov	r1, r3
.L770:
	cmp	r1, #5
	uxth	r2, r1
	bls	.L768
	tst	r2, #1
	ite	ne
	movne	r2, #12
	moveq	r2, #10
	subs	r2, r3, r2
	uxth	r2, r2
.L768:
	strh	r2, [r0, r1, lsl #1]	@ movhi
	adds	r1, r1, #1
	cmp	r1, #256
	add	r3, r3, #3
	uxth	r3, r3
	bne	.L770
	b	.L754
.L771:
	ldrh	r2, [r1, r3, lsl #1]
	adds	r3, r3, #1
	strh	r2, [r0, r2, lsl #1]	@ movhi
	b	.L749
.L785:
	.align	2
.L784:
	.word	.LANCHOR16
	.word	.LANCHOR117
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
	ldr	r2, .L804
	ldr	r4, .L804+4
	strb	r3, [r2]
	str	r2, [sp]
	strb	r3, [r4]
	ldr	r3, .L804+8
	ldr	r7, .L804+12
	ldrh	r3, [r3, #10]
	cmp	r3, #256
	bls	.L787
	mov	r3, #512
.L803:
	movs	r2, #8
	movs	r1, #0
	ldr	r0, .L804+16
	movs	r6, #0
	str	r3, [r7]
	bl	ftl_memset
	movs	r2, #32
	movs	r1, #0
	ldr	r0, .L804+20
	bl	ftl_memset
	movs	r2, #128
	movs	r1, #0
	ldr	r0, .L804+24
	bl	ftl_memset
	ldr	r3, .L804+28
	ldr	fp, .L804+36
	ldr	r5, [r3]
	ldr	r3, .L804+16
	ldrb	r10, [r5]	@ zero_extendqisi2
	add	r8, r5, #1
.L791:
	mov	r2, r10
	add	r1, fp, r6, lsl #3
	mov	r0, r8
	str	r3, [sp, #4]
	bl	FlashMemCmp8
	ldr	r3, [sp, #4]
	cbnz	r0, .L790
	ldrb	r2, [r4]	@ zero_extendqisi2
	ldr	r1, .L804+20
	strb	r6, [r3, r2]
	str	r0, [r1, r2, lsl #2]
	adds	r1, r2, #1
	strb	r1, [r4]
.L790:
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L791
	ldrb	r3, [r4]	@ zero_extendqisi2
	ldr	r2, [sp]
	strb	r3, [r2]
	ldrb	r3, [r5, #8]	@ zero_extendqisi2
	cmp	r3, #2
	beq	.L792
.L796:
	ldrh	r2, [r5, #14]
	ldrb	r3, [r4]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldrb	r2, [r5, #13]	@ zero_extendqisi2
	smulbb	r3, r3, r2
	ldr	r2, .L804+32
	strh	r3, [r2]	@ movhi
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L787:
	cmp	r3, #128
	it	hi
	movhi	r3, #256
	b	.L803
.L792:
	ldr	fp, [r7]
	movs	r6, #0
	ldr	r7, .L804+20
	ldr	r3, .L804+16
.L795:
	str	r3, [sp]
	mov	r2, r10
	ldr	r3, .L804+36
	mov	r0, r8
	add	r1, r3, r6, lsl #3
	bl	FlashMemCmp8
	ldr	r3, [sp]
	cbnz	r0, .L793
	ldrh	r2, [r5, #14]
	ldrb	r1, [r4]	@ zero_extendqisi2
	and	r0, r2, #65280
	ldrb	r2, [r5, #13]	@ zero_extendqisi2
	mul	r2, fp, r2
	muls	r2, r0, r2
	str	r2, [r7, r1, lsl #2]
	ldrb	r0, [r5, #23]	@ zero_extendqisi2
	cbz	r0, .L794
	lsls	r2, r2, #1
	str	r2, [r7, r1, lsl #2]
.L794:
	adds	r2, r1, #1
	strb	r6, [r3, r1]
	strb	r2, [r4]
.L793:
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L795
	b	.L796
.L805:
	.align	2
.L804:
	.word	.LANCHOR118
	.word	.LANCHOR25
	.word	.LANCHOR29
	.word	.LANCHOR3
	.word	.LANCHOR26
	.word	.LANCHOR17
	.word	.LANCHOR23
	.word	.LANCHOR18
	.word	.LANCHOR119
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
	movs	r1, #0
	ldr	r6, .L809
	movs	r2, #11
	mov	r4, r0
	movs	r5, #0
	bl	ftl_memset
	ldr	r3, [r6]
	mov	r0, r5
	ldr	r2, .L809+4
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	ldr	r2, [r2]
	smulbb	r3, r3, r2
	uxth	r3, r3
	strb	r3, [r4, #4]
	lsrs	r3, r3, #8
	strb	r3, [r4, #5]
	ldr	r3, .L809+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r4, #7]
	bl	FlashBootGetCapacity
	ubfx	r3, r0, #8, #8
	strb	r0, [r4]
	strb	r3, [r4, #1]
	ubfx	r3, r0, #16, #8
	strb	r3, [r4, #2]
	lsrs	r0, r0, #24
	ldr	r3, [r6]
	strb	r0, [r4, #3]
	mov	r0, r5
	ldr	r1, .L809+12
	ldrb	r2, [r3, #9]	@ zero_extendqisi2
	strb	r2, [r4, #6]
	movs	r2, #32
	strb	r2, [r4, #8]
	ldrb	r3, [r3, #7]	@ zero_extendqisi2
	strb	r5, [r4, #10]
	movs	r5, #1
	strb	r3, [r4, #9]
	ldr	r3, .L809+16
	ldrb	r2, [r3]	@ zero_extendqisi2
.L807:
	uxtb	r3, r0
	cmp	r2, r3
	bhi	.L808
	pop	{r4, r5, r6, pc}
.L808:
	ldrb	r3, [r0, r1]	@ zero_extendqisi2
	adds	r0, r0, #1
	ldrb	r6, [r4, #10]	@ zero_extendqisi2
	lsl	r3, r5, r3
	orrs	r3, r3, r6
	strb	r3, [r4, #10]
	b	.L807
.L810:
	.align	2
.L809:
	.word	.LANCHOR18
	.word	.LANCHOR3
	.word	.LANCHOR31
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
	ldr	r3, .L817
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, r0
	ldr	r7, .L817+4
	mov	r6, r1
	subs	r4, r5, #2
	addw	r5, r5, #1022
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r8, .L817+20
	mov	r0, r6
	lsls	r2, r2, #2
	bl	ftl_memset
.L814:
	ldrh	r3, [r4, #2]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L811
	ldrh	r2, [r7]
	cmp	r2, r3
	bhi	.L813
	mov	r1, r8
	movs	r2, #79
	ldr	r0, .L817+8
	bl	printf
	ldr	r1, .L817+12
	ldr	r0, .L817+16
	bl	printf
.L813:
	ldrh	r3, [r4, #2]!
	movs	r2, #1
	cmp	r5, r4
	lsr	r1, r3, #5
	and	r3, r3, #31
	lsl	r3, r2, r3
	ldr	r2, [r6, r1, lsl #2]
	orr	r2, r2, r3
	str	r2, [r6, r1, lsl #2]
	bne	.L814
.L811:
	pop	{r4, r5, r6, r7, r8, pc}
.L818:
	.align	2
.L817:
	.word	.LANCHOR120
	.word	.LANCHOR49
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR121
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
	ldr	r0, .L820
	movw	r3, #65535
	movs	r2, #16
	movs	r1, #255
	strh	r3, [r0]	@ movhi
	movs	r3, #0
	strh	r3, [r0, #6]	@ movhi
	adds	r0, r0, #12
	b	ftl_memset
.L821:
	.align	2
.L820:
	.word	.LANCHOR73
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
	ldr	r3, .L823
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
.L824:
	.align	2
.L823:
	.word	.LANCHOR74
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
.L826:
	ldrh	r1, [r4, #6]
	uxth	r2, r3
	cmp	r1, r2
	bhi	.L830
	ldrh	r3, [r5]
	movs	r6, #0
	ldr	r2, .L839
	mov	fp, r6
.L831:
	ldrh	r0, [r4, #10]
	uxth	r1, r6
	cmp	r0, r1
	bhi	.L835
	mov	r0, fp
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L830:
	uxth	r2, r3
	ldr	r1, [r6, r2, lsl #2]
	movs	r2, #0
	ubfx	r1, r1, #10, #16
.L827:
	ldrh	r7, [r4, #10]
	uxth	r0, r2
	cmp	r7, r0
	bhi	.L829
	adds	r3, r3, #1
	b	.L826
.L829:
	uxth	r0, r2
	adds	r2, r2, #1
	ldrh	r7, [r10, r0, lsl #1]
	cmp	r7, r1
	ittt	eq
	ldrheq	r7, [r5, r0, lsl #1]
	addeq	r7, r7, #1
	strheq	r7, [r5, r0, lsl #1]	@ movhi
	b	.L827
.L835:
	ldrh	r0, [r4]
	uxth	r7, r6
	cmp	r0, r1
	bne	.L832
	ldrh	r0, [r2]
	ldrh	ip, [r4, #2]
	cmp	ip, r0
	it	cc
	strhcc	r0, [r5, r7, lsl #1]	@ movhi
.L832:
	ldrh	r8, [r5, r7, lsl #1]
	cmp	r3, r8
	itt	hi
	movhi	fp, r1
	movhi	r3, r8
	cmp	r8, #0
	bne	.L834
	ldrh	r0, [r10, r7, lsl #1]
	cbz	r0, .L834
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
.L834:
	adds	r6, r6, #1
	b	.L831
.L840:
	.align	2
.L839:
	.word	.LANCHOR52
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
	ldr	r5, .L844
	ldr	r4, .L844+4
	ldr	r2, [r5]
	ldr	r7, .L844+8
	ldr	r6, .L844+12
	ldr	r0, [r4]
	lsls	r2, r2, #1
	ldr	r8, .L844+44
	bl	ftl_memset
	ldrh	r3, [r7]
	movs	r1, #255
	ldrh	r2, [r6]
	ldr	r0, [r8]
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L844+16
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
.L842:
	adds	r2, r2, #12
	adds	r6, r3, r7
	cmp	r2, r1
	bne	.L843
	ldr	r3, .L844+20
	ldr	r2, [r5]
	strh	r0, [r3, #2]	@ movhi
	strh	r2, [r3, #10]	@ movhi
	movw	r2, #61634
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L844+24
	strh	r0, [r3]	@ movhi
	strh	r0, [r3, #40]	@ movhi
	ldrh	r2, [r2]
	strh	r2, [r3, #8]	@ movhi
	ldr	r2, .L844+28
	ldrh	r2, [r2]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, .L844+32
	ldr	r2, [r2]
	str	r2, [r3, #12]
	ldr	r2, .L844+36
	ldr	r2, [r2]
	str	r2, [r3, #16]
	ldr	r2, [r4]
	str	r2, [r3, #20]
	ldr	r2, .L844+40
	ldr	r2, [r2]
	str	r2, [r3, #24]
	pop	{r4, r5, r6, r7, r8, pc}
.L843:
	bic	r3, r3, #3
	str	lr, [r2, #-8]
	add	r3, r3, ip
	strh	r0, [r2, #-12]	@ movhi
	str	r3, [r2, #-4]
	mov	r3, r6
	b	.L842
.L845:
	.align	2
.L844:
	.word	.LANCHOR63
	.word	.LANCHOR122
	.word	.LANCHOR56
	.word	.LANCHOR66
	.word	.LANCHOR95
	.word	.LANCHOR124
	.word	.LANCHOR125
	.word	.LANCHOR65
	.word	.LANCHOR126
	.word	.LANCHOR127
	.word	.LANCHOR128
	.word	.LANCHOR123
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
	ldr	r3, .L847
	movw	r2, #65535
	mov	r1, r4
	ldr	r5, .L847+4
	str	r4, [r3]
	ldr	r3, .L847+8
	strh	r2, [r3]	@ movhi
	mov	r2, #-1
	ldr	r3, .L847+12
	str	r4, [r3]
	ldr	r3, .L847+16
	str	r4, [r3]
	ldr	r3, .L847+20
	str	r2, [r3]
	ldr	r3, .L847+24
	str	r4, [r3]
	ldr	r3, .L847+28
	strh	r4, [r3]	@ movhi
	ldr	r3, .L847+32
	ldrh	r2, [r3]
	ldr	r3, .L847+36
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L847+40
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L847+44
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	mov	r1, r4
	movs	r2, #48
	ldr	r0, .L847+48
	bl	ftl_memset
	mov	r2, #512
	mov	r1, r4
	ldr	r0, .L847+52
	bl	ftl_memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L848:
	.align	2
.L847:
	.word	.LANCHOR129
	.word	.LANCHOR39
	.word	.LANCHOR130
	.word	.LANCHOR131
	.word	.LANCHOR132
	.word	.LANCHOR133
	.word	.LANCHOR101
	.word	.LANCHOR69
	.word	.LANCHOR60
	.word	.LANCHOR70
	.word	.LANCHOR77
	.word	.LANCHOR134
	.word	.LANCHOR135
	.word	.LANCHOR136
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
	ldr	r3, .L860
	movs	r2, #6
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r1, #0
	ldr	r6, .L860+4
	sub	sp, sp, #24
	movs	r4, #0
	ldrh	r3, [r3]
	mov	r8, r4
	ldr	r0, [r6]
	mov	r5, r4
	mov	r10, r6
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L860+8
	ldr	r2, .L860+12
	ldr	r1, .L860+16
	str	r4, [r3]
	ldr	r3, .L860+20
	strh	r4, [r2]	@ movhi
	strh	r4, [r1]	@ movhi
	str	r4, [r3]
	ldr	r3, .L860+24
	str	r2, [sp, #8]
	str	r4, [r3]
	ldr	r3, .L860+28
	mov	fp, r3
	strh	r4, [r3]	@ movhi
.L850:
	ldr	r3, .L860+32
	sxth	r7, r4
	ldrh	r3, [r3]
	cmp	r7, r3
	bge	.L857
	ldr	r3, .L860+36
	uxth	r1, r4
	str	r1, [sp, #12]
	ldrh	r2, [r3]
	ldr	r3, .L860+40
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r6, r3
	b	.L858
.L852:
	str	r3, [sp, #20]
	ldr	r3, .L860+44
	ldr	r1, [sp, #12]
	str	r2, [sp, #16]
	ldrb	r0, [r3, r0]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #20]
	cbnz	r0, .L851
	ldr	r1, [sp, #4]
	add	r6, r6, r1
	sxth	r6, r6
.L851:
	adds	r3, r3, #1
.L858:
	sxth	r0, r3
	cmp	r0, r2
	blt	.L852
	lsls	r3, r7, #1
	cbz	r6, .L853
	mov	r1, r6
	str	r3, [sp, #4]
	mov	r0, #32768
	bl	__aeabi_idiv
	ldr	r3, [sp, #4]
	sxth	r6, r0
.L854:
	ldr	r2, [r10]
	add	r3, r3, r7
	add	r2, r2, r3, lsl #1
	ldr	r3, .L860+48
	strh	r6, [r2, #4]	@ movhi
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L855
	ldr	r3, .L860+52
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L855
	ldr	r3, .L860+56
	ldrh	r3, [r3]
	cmp	r7, r3
	beq	.L855
	ldr	r3, .L860+60
	uxth	r0, r4
	ldr	r3, [r3]
	ldrh	r3, [r3, r7, lsl #1]
	cbnz	r3, .L856
	add	r8, r8, #1
	uxth	r8, r8
	bl	INSERT_FREE_LIST
.L855:
	adds	r4, r4, #1
	b	.L850
.L853:
	ldr	r2, .L860+60
	movw	r1, #65535
	ldr	r2, [r2]
	strh	r1, [r2, r7, lsl #1]	@ movhi
	b	.L854
.L856:
	adds	r5, r5, #1
	uxth	r5, r5
	bl	INSERT_DATA_LIST
	b	.L855
.L857:
	ldr	r2, [sp, #8]
	strh	r8, [fp]	@ movhi
	strh	r5, [r2]	@ movhi
	add	r5, r5, r8
	cmp	r3, r5
	bge	.L859
	ldr	r1, .L860+64
	movw	r2, #2366
	ldr	r0, .L860+68
	bl	printf
	ldr	r1, .L860+72
	ldr	r0, .L860+76
	bl	printf
.L859:
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L861:
	.align	2
.L860:
	.word	.LANCHOR39
	.word	.LANCHOR80
	.word	.LANCHOR86
	.word	.LANCHOR84
	.word	.LANCHOR137
	.word	.LANCHOR81
	.word	.LANCHOR83
	.word	.LANCHOR87
	.word	.LANCHOR38
	.word	.LANCHOR36
	.word	.LANCHOR51
	.word	.LANCHOR45
	.word	.LANCHOR90
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR82
	.word	.LANCHOR138
	.word	.LC4
	.word	.LC5
	.word	.LC6
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
	ldr	r2, .L863
	movs	r3, #0
	push	{r4, lr}
	movs	r1, #255
	ldr	r4, .L863+4
	strh	r3, [r2]	@ movhi
	ldr	r2, .L863+8
	strh	r3, [r2]	@ movhi
	ldrh	r2, [r4]
	ldr	r3, .L863+12
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r2, #12
	movs	r1, #255
	muls	r2, r3, r2
	ldr	r3, .L863+16
	ldr	r0, [r3]
	bl	ftl_memset
	pop	{r4, lr}
	b	FtlGcBufInit
.L864:
	.align	2
.L863:
	.word	.LANCHOR109
	.word	.LANCHOR53
	.word	.LANCHOR110
	.word	.LANCHOR108
	.word	.LANCHOR111
	.size	FtlGcPageVarInit, .-FtlGcPageVarInit
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
	ldr	r1, .L867
	bl	ftl_memcpy
	movs	r0, #0
	pop	{r3, pc}
.L868:
	.align	2
.L867:
	.word	.LANCHOR139
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
	ldr	r7, .L877
	ldr	r5, .L877+4
.L872:
	ldrb	r2, [r7, #-1]	@ zero_extendqisi2
	mov	r1, r5
	mov	r0, r7
	lsl	r8, r6, #5
	bl	FlashMemCmp8
	mov	r4, r0
	cbnz	r0, .L870
	ldr	r5, .L877+8
	mov	r3, r4
	ldr	r2, .L877+12
	add	r5, r5, r8
	ldrb	r0, [r5, #22]	@ zero_extendqisi2
	mov	r1, r2
.L871:
	lsls	r6, r3, #5
	ldrb	r6, [r6, r2]	@ zero_extendqisi2
	cmp	r6, r0
	beq	.L874
	adds	r3, r3, #1
	cmp	r3, #4
	bne	.L871
.L874:
	add	r1, r1, r3, lsl #5
	movs	r2, #32
	ldr	r0, .L877+16
	bl	ftl_memcpy
	movs	r2, #32
	mov	r1, r5
	ldr	r0, .L877+20
	bl	ftl_memcpy
	b	.L869
.L870:
	adds	r6, r6, #1
	adds	r7, r7, #32
	cmp	r6, #73
	bne	.L872
	mov	r4, #-1
.L869:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, pc}
.L878:
	.align	2
.L877:
	.word	.LANCHOR140+1
	.word	.LANCHOR22
	.word	.LANCHOR140
	.word	.LANCHOR141
	.word	.LANCHOR7
	.word	.LANCHOR29
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
.L880:
	cmp	r3, r2
	bne	.L881
	pop	{r4, pc}
.L881:
	ldr	r4, [r1, r3, lsl #2]
	str	r4, [r0, r3, lsl #2]
	adds	r3, r3, #1
	b	.L880
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
	bne	.L883
	cbz	r3, .L884
	lsls	r1, r3, #30
	bne	.L885
	mov	r2, #256
	mov	r1, r3
	bl	ftl_memcpy32
.L884:
	cbz	r5, .L882
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
.L885:
	mov	r2, #1024
	mov	r1, r3
	bl	ftl_memcpy
	b	.L884
.L883:
	cbz	r3, .L888
	lsls	r2, r3, #30
	bne	.L889
	mov	r1, r0
	mov	r2, #256
	mov	r0, r3
	bl	ftl_memcpy32
.L888:
	cbz	r5, .L882
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
.L882:
	pop	{r4, r5, r6, pc}
.L889:
	mov	r1, r0
	mov	r2, #1024
	mov	r0, r3
	bl	ftl_memcpy
	b	.L888
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
	ldr	r3, .L936
	sub	sp, sp, #96
	mov	r6, r0
	mov	r10, r2
	str	r1, [sp, #12]
	ldr	r5, [r3, r0, lsl #3]
	lsls	r3, r7, #26
	ldr	r4, [sp, #128]
	bne	.L901
	cbnz	r4, .L902
	add	r4, sp, #32
	movs	r2, #64
	movs	r1, #255
	add	r0, sp, #32
	bl	ftl_memset
.L902:
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
	bne	.L926
	ldr	r2, .L936+4
	lsr	r0, r10, #1
	ldr	ip, .L936+12
	ldr	r3, [r2]
	cmp	r3, #25
	ldr	r3, [sp, #12]
	ite	cc
	movcc	r7, #64
	movcs	r7, #128
	mov	r1, r3
.L905:
	cmp	r1, r0
	add	r4, r4, #4
	add	r6, r7, r3
	bcc	.L906
	ldr	r3, .L936+8
	lsr	r4, r10, #2
	ldr	r0, [r2]
	movs	r2, #0
	mov	r8, r2
	ldr	r1, [r3]
.L907:
	cmp	r2, r4
	bcs	.L903
	cbnz	r0, .L913
.L903:
	movs	r3, #0
	str	r3, [r5, #16]
.L914:
	ldr	r3, .L936+8
	ldr	r3, [r3]
	cmp	r3, #5
	bls	.L900
	ldr	r3, [sp, #12]
	cbnz	r3, .L900
	ldr	r3, [r5]
	and	r2, r3, #139264
	cmp	r2, #139264
	ittt	eq
	moveq	r8, #-1
	orreq	r3, r3, #131072
	streq	r3, [r5]
.L900:
	mov	r0, r8
	add	sp, sp, #96
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L906:
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
	b	.L905
.L913:
	add	r3, r2, #8
	ldr	r3, [r5, r3, lsl #2]
	str	r3, [sp, #28]
	ldr	r3, [sp, #28]
	lsls	r6, r3, #29
	bmi	.L929
	ldr	r3, [sp, #28]
	ubfx	r3, r3, #15, #1
	cmp	r3, #0
	bne	.L929
	cmp	r1, #5
	bls	.L909
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
.L935:
	orr	r3, r3, r6, lsl #5
.L911:
	cmp	r8, r3
	it	cc
	movcc	r8, r3
.L908:
	adds	r2, r2, #1
	b	.L907
.L909:
	cmp	r1, #3
	bls	.L911
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
	b	.L935
.L929:
	mov	r8, #-1
	b	.L908
.L926:
	mov	r8, #0
	b	.L903
.L901:
	ldr	r3, [sp, #12]
	cmp	r3, #1
	bne	.L915
	cmp	r4, #0
	mov	r8, #0
	ite	ne
	movne	r3, #4
	moveq	r3, #0
	str	r3, [sp, #16]
.L916:
	cmp	r8, r10
	bcc	.L918
	mov	r8, #0
	b	.L914
.L918:
	and	fp, r8, #3
	cbz	r7, .L931
	add	r3, r7, r8, lsl #9
.L917:
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
	b	.L916
.L931:
	mov	r3, r7
	b	.L917
.L915:
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
.L919:
	cmp	r4, r10
	bcs	.L914
	mov	r0, r6
	adds	r4, r4, #2
	bl	NandcXferComp
	ldr	r3, [r5, #32]
	cmp	r10, r4
	str	r3, [sp, #28]
	bls	.L920
	movs	r3, #0
	movs	r2, #2
	str	r3, [sp, #4]
	movs	r1, #0
	str	r3, [sp]
	mov	r0, r6
	and	r3, r4, #3
	bl	NandcXferStart
.L920:
	ldr	r3, [sp, #28]
	lsls	r3, r3, #29
	bmi	.L932
	ldr	r3, [sp, #28]
	ldr	r2, [sp, #28]
	ubfx	r3, r3, #3, #5
	ubfx	r2, r2, #27, #1
	orr	r3, r3, r2, lsl #5
	cmp	r8, r3
	it	cc
	movcc	r8, r3
.L921:
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
	b	.L919
.L932:
	mov	r8, #-1
	b	.L921
.L937:
	.align	2
.L936:
	.word	.LANCHOR6
	.word	.LANCHOR30
	.word	.LANCHOR32
	.word	.LANCHOR33
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
	ldr	r3, .L940
	mov	r6, r1
	mov	r7, r2
	mov	r4, r0
	ldrb	r5, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L939
	ldr	r3, .L940+4
	ldr	r2, .L940+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r0, [r2]
	muls	r0, r3, r0
	cmp	r0, r1
	it	hi
	movhi	r5, #4
.L939:
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
.L941:
	.align	2
.L940:
	.word	.LANCHOR29
	.word	.LANCHOR2
	.word	.LANCHOR3
	.size	FlashReadRawPage, .-FlashReadRawPage
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
	ldr	fp, .L957+8
	movs	r4, #0
	movs	r7, #4
	strb	r3, [sp, #20]
	movs	r3, #40
	strb	r3, [sp, #21]
	movs	r3, #24
	strb	r3, [sp, #22]
	movs	r3, #16
	ldr	r1, .L957
	mov	r0, r4
	strb	r3, [sp, #23]
	mov	r6, #-1
	ldrh	r3, [fp, #10]
	ldr	r8, .L957+36
	ldr	r5, .L957+4
	str	r3, [sp, #4]
	ldr	r3, [r1]
	str	r4, [r8]
	str	r3, [r5]
	bl	flash_enter_slc_mode
	mov	r10, r1
	str	r8, [sp, #12]
.L943:
	mov	r8, #0
	adds	r3, r4, #1
	str	r3, [sp, #8]
.L945:
	add	r3, sp, #20
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r3, #0
	ldr	r2, [r10]
	mov	r1, r4
	mov	r0, r3
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L944
	movs	r3, #0
	ldr	r2, [r10]
	ldr	r1, [sp, #8]
	mov	r0, r3
	bl	FlashReadRawPage
	adds	r0, r0, #1
	bne	.L944
	add	r8, r8, #1
	cmp	r8, #4
	bne	.L945
.L946:
	ldr	r3, [sp, #4]
	subs	r7, r7, #1
	add	r4, r4, r3
	bne	.L943
	mov	r0, r7
	b	.L956
.L947:
	movw	r1, #2036
	add	r0, r8, #12
	bl	JSHash
	ldr	r3, [r8, #8]
	cmp	r3, r0
	bne	.L953
	movs	r2, #32
	add	r1, r8, #160
	ldr	r0, .L957+8
	bl	ftl_memcpy
	ldr	r1, [r5]
	movs	r2, #32
	ldr	r0, .L957+12
	adds	r1, r1, #192
	bl	ftl_memcpy
	ldr	r1, [r5]
	mov	r2, #852
	ldr	r0, .L957+16
	adds	r1, r1, #224
	bl	ftl_memcpy
	ldr	r6, [r5]
	mov	r0, r4
	ldr	r3, .L957+20
	ldrh	r1, [fp, #10]
	ldr	r2, [r6, #1076]
	strb	r2, [r3]
	ldr	r3, [sp, #12]
	str	r4, [r3]
	bl	__aeabi_uidiv
	ldr	r3, .L957+24
	adds	r2, r0, #1
	cbz	r0, .L949
.L955:
	str	r2, [r3]
	ldrh	r2, [r6, #14]
	movs	r6, #0
	ldr	r3, .L957+28
	strb	r2, [r3]
	b	.L946
.L949:
	movs	r2, #2
	b	.L955
.L953:
	mov	r6, #-1
	b	.L946
.L944:
	ldr	r8, [r5]
	ldr	r2, .L957+32
	ldr	r3, [r8]
	cmp	r3, r2
	bne	.L946
	cmp	r6, #0
	bne	.L947
	ldrh	r1, [fp, #10]
	mov	r0, r4
	bl	__aeabi_uidiv
	ldr	r3, .L957+24
	adds	r0, r0, #1
	str	r0, [r3]
	mov	r0, r6
.L956:
	bl	flash_exit_slc_mode
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L958:
	.align	2
.L957:
	.word	.LANCHOR143
	.word	.LANCHOR142
	.word	.LANCHOR29
	.word	.LANCHOR7
	.word	.LANCHOR20
	.word	.LANCHOR28
	.word	.LANCHOR145
	.word	.LANCHOR146
	.word	1312902724
	.word	.LANCHOR144
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
	ldr	r3, .L986
	ldr	r2, .L986+4
	ldr	r4, [r3, r6, lsl #3]
	add	r3, r3, r6, lsl #3
	str	r2, [sp, #16]
	ldrb	r7, [r3, #4]	@ zero_extendqisi2
	ldrb	r3, [r2]	@ zero_extendqisi2
	add	r5, r7, #8
	subs	r3, r3, #67
	add	r5, r4, r5, lsl #8
	cmp	r3, #1
	bls	.L976
	ldr	r3, .L986+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L977
	movs	r0, #0
	bl	NandcSetDdrMode
	movs	r3, #1
.L977:
	str	r3, [sp, #8]
	add	r3, r4, r7, lsl #8
	movs	r2, #92
	str	r2, [r3, #2056]
	movs	r2, #197
	str	r2, [r3, #2056]
.L960:
	mov	r8, #1
	mov	r3, #-1
	str	r3, [sp, #4]
.L962:
	ldr	r3, .L986+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r8, r3
	bcc	.L971
	ldr	r10, [sp, #4]
.L970:
	ldr	r3, [sp, #16]
	movs	r1, #0
	mov	r0, r5
	ldrb	r2, [r3]	@ zero_extendqisi2
	subs	r2, r2, #67
	cmp	r2, #1
	bhi	.L972
	bl	SandiskSetRRPara
.L973:
	add	r4, r4, r7, lsl #8
	movs	r2, #255
	str	r2, [r4, #2056]
	ldr	r2, .L986+16
	ldrb	r2, [r2]	@ zero_extendqisi2
	add	r2, r2, r2, lsl #1
	cmp	r10, r2, asr #2
	bcc	.L974
	cmp	r10, #-1
	it	ne
	movne	r10, #256
.L974:
	mov	r0, r6
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #8]
	cbz	r3, .L959
	movs	r0, #4
	bl	NandcSetDdrMode
.L959:
	mov	r0, r10
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L976:
	movs	r3, #0
	str	r3, [sp, #8]
	b	.L960
.L971:
	ldr	r3, [sp, #16]
	mov	r0, r5
	uxtb	r1, r8
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #67
	cmp	r3, #1
	bhi	.L963
	bl	SandiskSetRRPara
.L964:
	ldr	r3, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #34
	bne	.L965
	ldr	r3, .L986+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	subs	r3, r3, #3
	cmp	r8, r3
	ittt	eq
	addeq	r3, r4, r7, lsl #8
	moveq	r2, #179
	streq	r2, [r3, #2056]
.L965:
	add	r3, r4, r7, lsl #8
	movs	r2, #38
	str	r2, [r3, #2056]
	movs	r2, #93
	str	r2, [r3, #2056]
	ldr	r3, [sp, #8]
	cbz	r3, .L966
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
.L967:
	cmp	r10, #-1
	beq	.L968
	ldr	r2, .L986+16
	ldr	r3, [sp, #4]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r3, #-1
	it	eq
	moveq	r3, r10
	str	r3, [sp, #4]
	add	r2, r2, r2, lsl #1
	cmp	r10, r2, asr #2
	bcc	.L970
	mov	fp, #0
	str	fp, [sp, #12]
.L968:
	add	r8, r8, #1
	b	.L962
.L963:
	bl	ToshibaSetRRPara
	b	.L964
.L966:
	mov	r3, fp
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #20]
	mov	r0, r6
	bl	FlashReadRawPage
	mov	r10, r0
	b	.L967
.L972:
	bl	ToshibaSetRRPara
	b	.L973
.L987:
	.align	2
.L986:
	.word	.LANCHOR6
	.word	.LANCHOR10
	.word	.LANCHOR28
	.word	.LANCHOR147
	.word	.LANCHOR31
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
	ldr	r2, .L1001
	mov	r4, #-1
	add	r3, r2, r7, lsl #3
	ldrb	r5, [r3, #4]	@ zero_extendqisi2
	add	r3, r5, #8
	ldr	r5, [r2, r7, lsl #3]
	add	r5, r5, r3, lsl #8
.L989:
	ldr	r3, .L1001+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #1
	cmp	r6, r3
	bcc	.L993
.L992:
	movs	r1, #0
	mov	r0, r5
	bl	SamsungSetRRPara
	ldr	r3, .L1001+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, asr #2
	bcc	.L988
	adds	r3, r4, #1
	it	ne
	movne	r4, #256
.L988:
	mov	r0, r4
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L993:
	uxtb	r1, r6
	mov	r0, r5
	bl	SamsungSetRRPara
	mov	r2, r10
	mov	r3, r8
	mov	r1, fp
	mov	r0, r7
	bl	FlashReadRawPage
	adds	r2, r0, #1
	beq	.L990
	ldr	r3, .L1001+8
	cmp	r4, #-1
	it	eq
	moveq	r4, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L996
	mov	r8, #0
	mov	r10, r8
.L990:
	adds	r6, r6, #1
	b	.L989
.L996:
	mov	r4, r0
	b	.L992
.L1002:
	.align	2
.L1001:
	.word	.LANCHOR6
	.word	.LANCHOR147
	.word	.LANCHOR31
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
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r3
	ldr	r3, .L1018
	sub	sp, sp, #32
	mov	r7, r0
	mov	fp, r2
	str	r1, [sp, #16]
	ldrb	r4, [r3]	@ zero_extendqisi2
	ldr	r3, .L1018+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1004
	add	r4, r4, r4, lsl #1
	asrs	r4, r4, #2
.L1005:
	mov	r0, r7
	bl	NandcWaitFlashReady
	ldr	r3, .L1018+8
	movs	r6, #0
	mov	r5, #-1
	ldr	r2, [r3, r7, lsl #3]
	add	r3, r3, r7, lsl #3
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	str	r2, [sp, #8]
	str	r3, [sp, #12]
	lsls	r3, r3, #8
	str	r3, [sp, #24]
.L1006:
	ldr	r3, .L1018+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r6, r3
	bcc	.L1010
.L1009:
	ldr	r3, [sp, #8]
	movs	r0, #200
	ldr	r2, [sp, #12]
	add	r7, r3, r2, lsl #8
	movs	r3, #239
	str	r3, [r7, #2056]
	movs	r3, #137
	str	r3, [r7, #2052]
	bl	udelay
	cmp	r5, r4
	mov	r3, #0
	str	r3, [r7, #2048]
	str	r3, [r7, #2048]
	str	r3, [r7, #2048]
	str	r3, [r7, #2048]
	bcc	.L1003
	adds	r3, r5, #1
	ldr	r2, [sp, #16]
	it	ne
	movne	r5, #256
	mov	r3, r6
	str	r5, [sp]
	mov	r1, r6
	ldr	r0, .L1018+16
	bl	printf
.L1003:
	mov	r0, r5
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1004:
	ldr	r3, .L1018+20
	smull	r4, r5, r4, r3
	mov	r4, r5
	b	.L1005
.L1010:
	ldr	r2, [sp, #24]
	movs	r0, #200
	ldr	r3, [sp, #8]
	mov	r8, #0
	add	r3, r3, r2
	movs	r2, #239
	str	r2, [r3, #2056]
	movs	r2, #137
	str	r2, [r3, #2052]
	str	r3, [sp, #28]
	bl	udelay
	adds	r3, r6, #1
	ldr	r1, [sp, #16]
	mov	r2, r3
	str	r3, [sp, #20]
	ldr	r3, [sp, #28]
	mov	r0, r7
	str	r2, [r3, #2048]
	mov	r2, fp
	str	r8, [r3, #2048]
	str	r8, [r3, #2048]
	str	r8, [r3, #2048]
	mov	r3, r10
	bl	FlashReadRawPage
	adds	r2, r0, #1
	beq	.L1007
	cmp	r5, #-1
	it	eq
	moveq	r5, r0
	cmp	r0, r4
	bcc	.L1013
	mov	r10, r8
	mov	fp, r8
.L1007:
	ldr	r6, [sp, #20]
	b	.L1006
.L1013:
	mov	r5, r0
	b	.L1009
.L1019:
	.align	2
.L1018:
	.word	.LANCHOR31
	.word	.LANCHOR8
	.word	.LANCHOR6
	.word	.LANCHOR147
	.word	.LC7
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
	ldr	r4, .L1037
	mov	r8, #0
	mov	r6, #-1
	mov	r10, r3
	mov	r7, r0
	str	r1, [sp, #4]
	ldrb	r2, [r4, #2]	@ zero_extendqisi2
	adds	r3, r4, r0
	ldrb	r5, [r3, #12]	@ zero_extendqisi2
	str	r2, [sp]
	ldr	r2, .L1037+4
	ldr	r2, [r2]
	ldrb	r2, [r2, #19]	@ zero_extendqisi2
	cmp	r2, #7
	it	eq
	ldrbeq	r5, [r3, #20]	@ zero_extendqisi2
	bl	NandcWaitFlashReady
.L1022:
	ldr	r3, [sp]
	cmp	r8, r3
	bcc	.L1027
.L1026:
	ldr	r3, .L1037+4
	add	r4, r4, r7
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	cmp	r3, #7
	ldr	r3, .L1037+8
	ite	eq
	strbeq	r5, [r4, #20]
	strbne	r5, [r4, #12]
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r6, r3, asr #2
	bcc	.L1020
	adds	r3, r6, #1
	it	ne
	movne	r6, #256
.L1020:
	mov	r0, r6
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1027:
	ldr	r3, [sp]
	adds	r5, r5, #1
	uxtb	r5, r5
	ldr	r2, .L1037+12
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
	beq	.L1024
	ldr	r3, .L1037+8
	cmp	r6, #-1
	it	eq
	moveq	r6, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, asr #2
	bcc	.L1031
	mov	r10, #0
	mov	fp, r10
.L1024:
	add	r8, r8, #1
	b	.L1022
.L1031:
	mov	r6, r0
	b	.L1026
.L1038:
	.align	2
.L1037:
	.word	.LANCHOR20
	.word	.LANCHOR18
	.word	.LANCHOR31
	.word	.LANCHOR20+4
	.size	HynixReadRetrial, .-HynixReadRetrial
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
	ldr	r3, .L1064
	sub	sp, sp, #24
	str	r0, [sp, #8]
	ldr	r3, [r3]
	str	r1, [sp, #12]
	str	r2, [sp, #4]
	ldr	r3, [r3, #304]
	str	r3, [sp, #20]
	ldr	r3, .L1064+4
	ldr	r3, [r3]
	cmp	r3, #8
	ldr	r3, [sp, #56]
	ite	cc
	movcc	fp, #6
	movcs	fp, #12
	cmp	r3, #0
	beq	.L1053
	movs	r0, #1
	ldr	r4, .L1064+8
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
	bne	.L1042
.L1051:
	mov	r6, #-1
.L1039:
	mov	r0, r6
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1042:
	mov	r2, r6
	ldr	r1, [sp, #12]
	ldr	r0, .L1064+12
	bl	printf
	ldr	r2, .L1064+16
	ldr	r3, [r2]
	adds	r3, r3, #1
	cmp	r3, #2048
	bcs	.L1044
	str	r3, [r2]
	b	.L1039
.L1044:
	movs	r7, #0
	str	r7, [r2]
	str	r7, [sp, #4]
.L1041:
	mov	r10, #0
	mov	r8, #-1
	mov	r5, r10
	mov	r4, r10
	str	r10, [sp, #16]
.L1049:
	uxtb	r0, fp
	bl	NandcSetDdrPara
	mov	r3, r7
	ldr	r2, [sp, #4]
	ldr	r1, [sp, #12]
	ldr	r0, [sp, #8]
	bl	FlashReadRawPage
	adds	r3, r6, #1
	cmp	r0, r3
	bhi	.L1045
	cmp	r0, #2
	bhi	.L1055
	adds	r4, r4, #1
	cmp	r4, #9
	bls	.L1055
	mov	r3, r5
	mov	r6, r0
	sub	r5, fp, r4
	mov	r8, #0
.L1047:
	ldr	r2, [sp, #16]
	cmp	r4, r2
	it	ls
	movls	r5, r3
.L1048:
	cbz	r5, .L1050
	mov	r1, r5
	ldr	r0, .L1064+20
	bl	printf
	uxtb	r0, r5
	bl	NandcSetDdrPara
.L1050:
	cmp	r8, #0
	beq	.L1039
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #8]
	ldr	r0, .L1064+24
	bl	printf
	ldr	r3, [sp, #56]
	cmp	r3, #0
	beq	.L1051
	ldr	r3, [sp, #20]
	ubfx	r0, r3, #8, #8
	bl	NandcSetDdrPara
	b	.L1039
.L1053:
	mov	r6, #1024
	b	.L1041
.L1045:
	ldr	r3, [sp, #16]
	cmp	r4, r3
	bls	.L1056
	cmp	r4, #7
	sub	r5, r10, r4
	bhi	.L1048
	str	r4, [sp, #16]
.L1056:
	movs	r4, #0
	b	.L1046
.L1055:
	mov	r8, #0
	mov	r10, fp
	mov	r6, r0
	mov	r7, r8
	str	r8, [sp, #4]
.L1046:
	add	fp, fp, #2
	cmp	fp, #69
	bls	.L1049
	mov	r3, r5
	mov	r5, r10
	b	.L1047
.L1065:
	.align	2
.L1064:
	.word	.LANCHOR19
	.word	.LANCHOR32
	.word	.LANCHOR24
	.word	.LC8
	.word	.LANCHOR148
	.word	.LC9
	.word	.LC10
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
	bne	.L1067
	ldr	r10, .L1085+20
	ldrb	fp, [r10]	@ zero_extendqisi2
	cmp	fp, #0
	bne	.L1068
.L1070:
	ldr	r3, .L1085
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1067
	ldr	r3, .L1085+4
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
	beq	.L1071
	ldr	r3, .L1085+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3, lsr #1
	bls	.L1067
.L1071:
	ubfx	r0, r10, #8, #8
	bl	NandcSetDdrPara
	b	.L1067
.L1068:
	movs	r3, #0
	mov	r2, r7
	strb	r3, [r10]
	mov	r1, r6
	mov	r3, r8
	mov	r0, r5
	bl	FlashReadRawPage
	adds	r3, r0, #1
	strb	fp, [r10]
	beq	.L1070
	mov	r4, r0
.L1067:
	ldr	r10, .L1085+24
	ldr	fp, [r10]
	cmp	fp, #0
	beq	.L1066
	adds	r2, r4, #1
	bne	.L1066
	mov	r3, r8
	mov	r2, r7
	mov	r1, r6
	mov	r0, r5
	blx	fp
	mov	r3, r6
	mov	r4, r0
	mov	r1, r0
	mov	r2, r5
	ldr	r0, .L1085+12
	bl	printf
	adds	r3, r4, #1
	bne	.L1066
	ldr	r3, .L1085+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1066
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
.L1066:
	mov	r0, r4
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1086:
	.align	2
.L1085:
	.word	.LANCHOR28
	.word	.LANCHOR19
	.word	.LANCHOR31
	.word	.LC11
	.word	.LANCHOR8
	.word	.LANCHOR5
	.word	.LANCHOR149
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
	ldr	r4, .L1098
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
	ldr	r5, .L1098+4
	bl	FlashReadRawPage
	adds	r0, r0, #1
	beq	.L1088
	cmp	r8, #-1
	bne	.L1089
.L1088:
	ldrb	r3, [r4]	@ zero_extendqisi2
	lsls	r3, r3, #31
	bpl	.L1089
	movs	r0, #1
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
	movs	r3, #0
.L1097:
	movs	r0, #0
	strb	r3, [r5]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1089:
	movs	r3, #1
	b	.L1097
.L1099:
	.align	2
.L1098:
	.word	.LANCHOR24
	.word	.LANCHOR28
	.size	FlashDdrParaScan, .-FlashDdrParaScan
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
	ldr	r3, .L1103
	mov	r5, r1
	mov	r7, r2
	mov	r4, r0
	ldrb	r6, [r3, #9]	@ zero_extendqisi2
	cbnz	r0, .L1101
	ldr	r3, .L1103+4
	ldr	r2, .L1103+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r1, [r2]
	muls	r1, r3, r1
	cmp	r1, r5
	bls	.L1101
	ldr	r3, .L1103+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1102
	subs	r6, r6, #2
.L1101:
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
.L1102:
	movs	r6, #4
	b	.L1101
.L1104:
	.align	2
.L1103:
	.word	.LANCHOR29
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
	ldr	r7, .L1114
	ldr	r4, .L1114+4
	ldr	r3, [r7]
	ldr	r10, .L1114+60
	ldr	r8, .L1114+64
	str	r3, [r4]
	ldr	r3, .L1114+8
	ldrb	r0, [r3]	@ zero_extendqisi2
	bl	FlashBchSel
	mov	r2, #2048
	movs	r1, #0
	ldr	r0, [r7]
	bl	ftl_memset
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r3, .L1114+12
	ldr	r1, .L1114+16
	str	r10, [r0]
	adds	r0, r0, #16
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r0, #-4]	@ movhi
	ldr	r3, .L1114+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	strh	r3, [r0, #-2]	@ movhi
	ldr	r3, .L1114+24
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r0, #1060]
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #8
	ldr	r1, .L1114+28
	adds	r0, r0, #80
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1114+32
	adds	r0, r0, #96
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1114+36
	adds	r0, r0, #160
	bl	ftl_memcpy
	ldr	r0, [r4]
	movs	r2, #32
	ldr	r1, .L1114+40
	adds	r0, r0, #192
	bl	ftl_memcpy
	ldr	r0, [r4]
	mov	r2, #852
	ldr	r1, .L1114+44
	adds	r0, r0, #224
	bl	ftl_memcpy
	ldr	r5, [r4]
	movw	r1, #2036
	add	r0, r5, #12
	bl	JSHash
	ldr	r1, .L1114+48
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
.L1108:
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
	beq	.L1106
	ldr	r3, [r4]
	ldr	r1, [r3]
	cmp	r1, r10
	bne	.L1106
	add	r0, r3, #12
	movw	r1, #2036
	str	r2, [sp, #4]
	str	r3, [sp]
	bl	JSHash
	ldr	r3, [sp]
	ldr	r2, [sp, #4]
	ldr	r3, [r3, #8]
	cmp	r3, r0
	bne	.L1106
	ldr	r3, .L1114+52
	cmp	r5, #1
	str	r2, [r3]
	ldr	r3, [r8]
	mul	r6, r6, r3
	ldr	r3, .L1114+56
	str	r6, [r3]
	beq	.L1109
	movs	r5, #1
.L1106:
	cmp	r2, #4
	mov	r6, r2
	bne	.L1108
.L1107:
	movs	r0, #0
	bl	flash_exit_slc_mode
	clz	r0, r5
	lsrs	r0, r0, #5
	negs	r0, r0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1109:
	movs	r5, #2
	b	.L1107
.L1115:
	.align	2
.L1114:
	.word	.LANCHOR143
	.word	.LANCHOR142
	.word	.LANCHOR150
	.word	.LANCHOR25
	.word	.LANCHOR22
	.word	.LANCHOR2
	.word	.LANCHOR28
	.word	.LANCHOR26
	.word	.LANCHOR17
	.word	.LANCHOR29
	.word	.LANCHOR7
	.word	.LANCHOR20
	.word	.LANCHOR151
	.word	.LANCHOR145
	.word	.LANCHOR144
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
	ldr	r2, .L1128
	mov	r10, r0
	strb	r3, [sp, #20]
	movs	r3, #40
	strb	r3, [sp, #21]
	movs	r3, #24
	strb	r3, [sp, #22]
	movs	r3, #16
	strb	r3, [sp, #23]
	ldr	r3, .L1128+4
	ldr	r1, [r2]
	str	r2, [sp, #8]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp, #4]
	ldr	r3, .L1128+8
	cmp	r1, r3
	str	r3, [sp, #12]
	bne	.L1117
	movs	r0, #0
	bl	flash_enter_slc_mode
.L1117:
	mov	r7, #-1
	movs	r4, #2
	mov	r2, #2048
	movs	r1, #0
	mov	r0, r10
	bl	ftl_memset
.L1118:
	ldr	r3, .L1128+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r4, r3
	bcc	.L1123
.L1122:
	ldr	r0, [sp, #4]
	bl	FlashBchSel
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L1116
	movs	r0, #0
	bl	flash_exit_slc_mode
.L1116:
	mov	r0, r7
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1123:
	ldr	r5, .L1128+16
	movs	r6, #0
	ldr	fp, .L1128+32
.L1120:
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
	bne	.L1119
	adds	r6, r6, #1
	cmp	r6, #4
	bne	.L1120
.L1121:
	adds	r4, r4, #1
	b	.L1118
.L1126:
	movs	r7, #0
	b	.L1122
.L1119:
	ldr	r3, [r5]
	ldr	r2, [r3]
	ldr	r3, .L1128+20
	cmp	r2, r3
	bne	.L1121
	mov	r1, r8
	ldr	r0, .L1128+24
	bl	printf
	mov	r2, #2048
	ldr	r1, [r5]
	mov	r0, r10
	bl	ftl_memcpy
	ldr	r3, [r5]
	ldr	r2, .L1128+12
	ldr	r3, [r3, #512]
	strb	r3, [r2]
	ldr	r3, .L1128+28
	ldr	r2, [r3]
	cmp	r4, r2
	bcs	.L1126
	str	r4, [r3]
	movs	r7, #0
	bl	FlashSavePhyInfo
	b	.L1121
.L1129:
	.align	2
.L1128:
	.word	.LANCHOR152
	.word	.LANCHOR31
	.word	1446522928
	.word	.LANCHOR2
	.word	.LANCHOR143
	.word	-52655045
	.word	.LC12
	.word	.LANCHOR145
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
	ldr	r5, .L1140
	mov	r6, r0
	mov	r7, r1
	ldr	r3, [r5]
	ldrb	r2, [r3, #19]	@ zero_extendqisi2
	ldr	r3, .L1140+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1131
	ldr	r3, .L1140+8
	ldr	r1, [r3]
	ldr	r3, .L1140+12
	cmp	r1, r3
	beq	.L1130
.L1131:
	subs	r3, r2, #5
	uxtb	r3, r3
	cmp	r3, #30
	bhi	.L1132
	ldr	r2, .L1140+16
	lsr	r3, r2, r3
	lsls	r3, r3, #31
	bmi	.L1134
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1135:
	ldrh	r2, [r10, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1130
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
.L1136:
	ldr	r3, [r5]
	ldrh	r3, [r3, #10]
	cmp	r3, r4
	bhi	.L1135
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1132:
	cmp	r2, #68
	bne	.L1130
.L1134:
	ldr	r10, .L1140+20
	ldr	r8, .L1140+24
	b	.L1136
.L1130:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1141:
	.align	2
.L1140:
	.word	.LANCHOR18
	.word	.LANCHOR8
	.word	.LANCHOR152
	.word	1446522928
	.word	1073758215
	.word	.LANCHOR117
	.word	.LANCHOR151
	.size	FlashPageProgMsbFFData, .-FlashPageProgMsbFFData
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
	ldr	r0, .L1144
	bx	lr
.L1145:
	.align	2
.L1144:
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
	ldr	r3, .L1148
	movs	r2, #1
	push	{r4, lr}
	movs	r4, #0
	str	r2, [r3, #12]
	movs	r2, #2
	str	r2, [r3, #20]
	movs	r2, #3
	stm	r3, {r0, r4}
	str	r0, [r3, #8]
	str	r0, [r3, #16]
	str	r2, [r3, #28]
	str	r0, [r3, #24]
	ldr	r3, .L1148+4
	ldr	r2, .L1148+8
	str	r0, [r3]
	ldr	r3, [r0]
	and	r3, r3, #253952
	ubfx	r1, r3, #13, #1
	and	r3, r3, #245760
	str	r1, [r2]
	orr	r3, r3, #256
	ldr	r2, [r0, #352]
	ldr	r1, .L1148+12
	ubfx	r2, r2, #16, #4
	str	r2, [r1]
	ldr	r1, [r0, #352]
	ldr	r2, .L1148+16
	str	r1, [r2]
	str	r3, [r0]
	movw	r3, #4225
	str	r4, [r0, #336]
	str	r3, [r0, #4]
	movw	r3, #8322
	str	r3, [r0, #344]
	ldr	r3, .L1148+20
	str	r3, [r0, #304]
	mov	r0, #36864
	bl	ftl_malloc
	ldr	r3, .L1148+24
	str	r0, [r3]
	ldr	r3, .L1148+28
	str	r0, [r3]
	add	r0, r0, #32768
	str	r0, [r3, #4]
	str	r4, [r3, #24]
	ldr	r3, .L1148+32
	str	r4, [r3]
	pop	{r4, pc}
.L1149:
	.align	2
.L1148:
	.word	.LANCHOR6
	.word	.LANCHOR19
	.word	.LANCHOR153
	.word	.LANCHOR32
	.word	.LANCHOR152
	.word	1710593
	.word	.LANCHOR154
	.word	.LANCHOR33
	.word	.LANCHOR34
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
	ldr	r3, .L1155
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r2, .L1155+4
	movs	r6, #12
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1155+8
	ldr	r5, .L1155+12
	ldr	r10, .L1155+296
	str	r4, [r3]
	ldr	r3, .L1155+16
	ldrh	r0, [r5]
	ldr	r8, .L1155+300
	str	r4, [r3]
	ldr	r3, .L1155+20
	lsls	r0, r0, #1
	ldr	fp, .L1155+304
	str	r4, [r3]
	ldr	r3, .L1155+24
	str	r4, [r3]
	ldr	r3, .L1155+28
	str	r4, [r3]
	ldr	r3, .L1155+32
	str	r4, [r3]
	ldr	r3, .L1155+36
	str	r4, [r3]
	ldr	r3, .L1155+40
	str	r4, [r3]
	ldr	r3, .L1155+44
	str	r4, [r3]
	ldr	r3, .L1155+48
	str	r4, [r3]
	ldr	r3, .L1155+52
	str	r4, [r3]
	ldr	r3, .L1155+56
	str	r4, [r3]
	ldr	r3, .L1155+60
	str	r4, [r3]
	ldr	r3, .L1155+64
	str	r4, [r3]
	ldr	r3, .L1155+68
	str	r4, [r3]
	ldr	r3, .L1155+72
	str	r4, [r3]
	ldr	r3, .L1155+76
	str	r4, [r3]
	movw	r3, #65535
	str	r3, [r2]
	ldr	r2, .L1155+80
	str	r4, [r2]
	ldr	r2, .L1155+84
	str	r4, [r2]
	ldr	r2, .L1155+88
	str	r4, [r2]
	ldr	r2, .L1155+92
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1155+96
	strh	r3, [r2]	@ movhi
	movs	r2, #32
	ldr	r3, .L1155+100
	strh	r2, [r3]	@ movhi
	movs	r2, #128
	ldr	r3, .L1155+104
	strh	r2, [r3]	@ movhi
	ldr	r3, .L1155+108
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1155+112
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1155+116
	strh	r4, [r3]	@ movhi
	ldr	r3, .L1155+120
	strh	r4, [r3]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L1155+124
	str	r0, [r3]
	ldrh	r0, [r5]
	movs	r5, #36
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L1155+128
	str	r0, [r3]
	ldrh	r3, [r10]
	muls	r5, r3, r5
	lsls	r7, r5, #2
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L1155+132
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1155+136
	str	r0, [r3]
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L1155+140
	ldr	r7, .L1155+144
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1155+148
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1155+152
	ldrh	r5, [r7]
	str	r0, [r3]
	ldrh	r3, [r10]
	mov	r0, r5
	lsls	r3, r3, #1
	adds	r3, r3, #1
	str	r3, [r8]
	bl	ftl_malloc
	ldr	r3, .L1155+156
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1155+160
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1155+164
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L1155+168
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1155+172
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1155+176
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L1155+180
	ldrh	r5, [r10]
	ldr	r10, .L1155+308
	str	r0, [r3]
	ldrh	r3, [fp]
	muls	r5, r3, r5
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L1155+184
	str	r0, [r3]
	lsls	r0, r5, #2
	ldr	r5, .L1155+188
	bl	ftl_malloc
	ldr	r3, .L1155+192
	str	r0, [r3]
	ldrh	r3, [fp]
	ldr	r0, [r8]
	ldr	r8, .L1155+312
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1155+196
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L1155+200
	str	r0, [r3]
	ldrh	r3, [r8]
	ldr	r0, .L1155+204
	addw	r3, r3, #547
	lsrs	r3, r3, #9
	and	r0, r0, r3, lsl #9
	strh	r3, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L1155+208
	str	r0, [r3]
	adds	r0, r0, #32
	ldr	r3, .L1155+212
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1155+216
	str	r0, [r3]
	ldr	r3, [r10]
	lsl	r8, r3, #1
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L1155+220
	str	r0, [r3]
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L1155+224
	ldr	r8, .L1155+316
	str	r0, [r3]
	ldrh	r0, [r5]
	lsrs	r0, r0, #3
	adds	r0, r0, #4
	bl	ftl_malloc
	ldr	r3, .L1155+228
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1155+232
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L1155+236
	str	r0, [r3]
	ldrh	r0, [r8]
	ldr	r8, .L1155+320
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1155+240
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldrh	r2, [r8]
	mov	r1, r4
	ldr	r3, .L1155+244
	lsls	r2, r2, #2
	str	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L1155+248
	ldrh	r4, [r3]
	lsls	r4, r4, #2
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L1155+252
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L1155+256
	ldr	r4, .L1155+260
	str	r0, [r3]
	ldr	r0, [r10]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L1155+264
	str	r0, [r3]
	ldrh	r0, [r4]
	muls	r0, r6, r0
	ldr	r6, .L1155+268
	bl	ftl_malloc
	ldr	r3, .L1155+272
	str	r0, [r3]
	ldrh	r3, [r4]
	ldrh	r0, [r7]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1155+276
	str	r0, [r3]
	movs	r0, #6
	ldrh	r3, [r5]
	ldr	r5, .L1155+280
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L1155+284
	str	r0, [r3]
	ldr	r3, .L1155+288
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
	ldr	r3, .L1155+292
	ldrh	r6, [r6]
	lsls	r1, r1, #2
	mov	r4, r3
	str	r0, [r4, #28]!
	mov	r0, r1
	b	.L1156
.L1157:
	.align	2
.L1155:
	.word	.LANCHOR137
	.word	.LANCHOR171
	.word	.LANCHOR155
	.word	.LANCHOR53
	.word	.LANCHOR156
	.word	.LANCHOR157
	.word	.LANCHOR158
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR163
	.word	.LANCHOR164
	.word	.LANCHOR165
	.word	.LANCHOR166
	.word	.LANCHOR78
	.word	.LANCHOR167
	.word	.LANCHOR168
	.word	.LANCHOR169
	.word	.LANCHOR170
	.word	.LANCHOR172
	.word	.LANCHOR173
	.word	.LANCHOR72
	.word	.LANCHOR112
	.word	.LANCHOR113
	.word	.LANCHOR174
	.word	.LANCHOR175
	.word	.LANCHOR176
	.word	.LANCHOR114
	.word	.LANCHOR177
	.word	.LANCHOR116
	.word	.LANCHOR108
	.word	.LANCHOR111
	.word	.LANCHOR178
	.word	.LANCHOR179
	.word	.LANCHOR180
	.word	.LANCHOR56
	.word	.LANCHOR76
	.word	.LANCHOR106
	.word	.LANCHOR79
	.word	.LANCHOR181
	.word	.LANCHOR182
	.word	.LANCHOR104
	.word	.LANCHOR183
	.word	.LANCHOR184
	.word	.LANCHOR103
	.word	.LANCHOR185
	.word	.LANCHOR39
	.word	.LANCHOR186
	.word	.LANCHOR105
	.word	.LANCHOR134
	.word	33553920
	.word	.LANCHOR188
	.word	.LANCHOR77
	.word	.LANCHOR82
	.word	.LANCHOR126
	.word	.LANCHOR122
	.word	.LANCHOR0
	.word	.LANCHOR70
	.word	.LANCHOR189
	.word	.LANCHOR190
	.word	.LANCHOR191
	.word	.LANCHOR65
	.word	.LANCHOR128
	.word	.LANCHOR192
	.word	.LANCHOR66
	.word	.LANCHOR127
	.word	.LANCHOR43
	.word	.LANCHOR95
	.word	.LANCHOR123
	.word	.LANCHOR120
	.word	.LANCHOR80
	.word	.LANCHOR49
	.word	.LANCHOR73
	.word	.LANCHOR36
	.word	.LANCHOR107
	.word	.LANCHOR57
	.word	.LANCHOR63
	.word	.LANCHOR187
	.word	.LANCHOR60
	.word	.LANCHOR61
.L1156:
.L1151:
	cmp	r2, r6
	bcc	.L1152
	add	r3, r3, r2, lsl #2
	ldr	r2, .L1158
	movs	r1, #0
	adds	r3, r3, #24
.L1153:
	cmp	r3, r2
	bne	.L1154
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1152:
	ldr	r5, [r3, #28]
	adds	r2, r2, #1
	add	r5, r5, r0
	add	r0, r0, r1
	str	r5, [r4, #4]!
	b	.L1151
.L1154:
	str	r1, [r3, #4]!
	b	.L1153
.L1159:
	.align	2
.L1158:
	.word	.LANCHOR73+56
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
	ldr	r3, .L1166
	ldr	r0, [r3]
	bx	lr
.L1167:
	.align	2
.L1166:
	.word	.LANCHOR67
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
	ldr	r7, .L1177
	mov	fp, r0
	mov	r6, r1
	mov	r8, r2
	mov	r10, r3
	mov	r4, r5
.L1169:
	cmp	r4, r10
	bne	.L1175
	ldr	r1, .L1177+4
	ldr	r0, .L1177+8
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L1175:
	cbnz	r5, .L1170
	mov	r2, r4
	mov	r1, fp
	ldr	r0, .L1177+12
	bl	printf
.L1170:
	cmp	r8, #4
	bne	.L1171
	ldr	r1, [r6, r4, lsl #2]
.L1176:
	mov	r0, r7
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L1174
	movs	r5, #0
	ldr	r1, .L1177+4
	ldr	r0, .L1177+8
	bl	printf
.L1174:
	adds	r4, r4, #1
	b	.L1169
.L1171:
	cmp	r8, #2
	ite	eq
	ldrsheq	r1, [r6, r4, lsl #1]
	ldrbne	r1, [r6, r4]	@ zero_extendqisi2
	b	.L1176
.L1178:
	.align	2
.L1177:
	.word	.LC14
	.word	.LC15
	.word	.LC6
	.word	.LC13
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
	ldr	r5, .L1278
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
	bne	.L1180
	movs	r3, #167
	movs	r2, #247
	strb	r3, [r5, #4]
	ldr	r3, .L1278+4
	strb	r2, [r3, #17]
.L1236:
	mov	r10, #7
	b	.L1272
.L1180:
	cmp	r0, #3
	bne	.L1182
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
.L1273:
	mov	r10, #8
	strb	r3, [r5, #11]
	mov	fp, r10
.L1181:
	subs	r3, r4, #1
	cmp	r3, #1
	bhi	.L1186
	mov	r8, #0
.L1187:
	ldr	r3, .L1278+8
	ldrb	r2, [r3]	@ zero_extendqisi2
	uxtb	r3, r8
	cmp	r2, r3
	bhi	.L1193
.L1194:
	ldr	r3, .L1278
	strb	fp, [r3, #1]
	strb	r10, [r3, #2]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1182:
	cmp	r0, #4
	bne	.L1183
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
	b	.L1273
.L1183:
	cmp	r0, #5
	bne	.L1184
	movs	r3, #56
	mov	r10, #8
	strb	r3, [r5, #4]
	movs	r3, #57
	strb	r3, [r5, #5]
	movs	r3, #58
	strb	r3, [r5, #6]
	movs	r3, #59
	strb	r3, [r5, #7]
.L1272:
	mov	fp, #4
	b	.L1181
.L1184:
	cmp	r0, #6
	bne	.L1185
	movs	r3, #14
	mov	r10, #12
	strb	r3, [r5, #4]
	movs	r3, #15
	strb	r3, [r5, #5]
	movs	r3, #16
	strb	r3, [r5, #6]
	movs	r3, #17
	strb	r3, [r5, #7]
	b	.L1272
.L1185:
	cmp	r0, #7
	bne	.L1236
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
	b	.L1181
.L1193:
	ldr	r2, .L1278+12
	movs	r6, #0
	ldrb	r2, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1278+16
	ldr	r7, [r3, r2, lsl #3]
	add	r4, r5, r2, lsl #6
	add	r3, r3, r2, lsl #3
	movs	r2, #55
	adds	r4, r4, #20
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	add	r7, r7, r3, lsl #8
	addw	r3, r7, #2056
.L1188:
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
	bhi	.L1188
	ldr	r7, .L1278+4
	mov	r1, r4
	movs	r2, #0
.L1191:
	movs	r3, #1
	adds	r6, r7, r2
.L1190:
	ldrb	r0, [r6, r3, lsl #2]	@ zero_extendqisi2
	ldrb	ip, [r1]	@ zero_extendqisi2
	add	r0, r0, ip
	strb	r0, [r1, r3, lsl #3]
	adds	r3, r3, #1
	cmp	r3, #7
	bne	.L1190
	adds	r2, r2, #1
	adds	r1, r1, #1
	cmp	r2, #4
	bne	.L1191
	movs	r3, #0
	add	r8, r8, #1
	strb	r3, [r4, #16]
	strb	r3, [r4, #24]
	strb	r3, [r4, #32]
	strb	r3, [r4, #40]
	strb	r3, [r4, #48]
	strb	r3, [r4, #41]
	strb	r3, [r4, #49]
	b	.L1187
.L1186:
	subs	r3, r4, #3
	cmp	r3, #4
	bhi	.L1194
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
.L1277:
	str	r3, [sp, #28]
	ldrb	r3, [sp, #28]	@ zero_extendqisi2
	str	r3, [sp, #16]
	ldr	r3, .L1278+8
	ldr	r2, [sp, #16]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r2
	bls	.L1194
	ldr	r2, [sp, #16]
	ldr	r3, .L1278+12
	ldrb	r8, [r3, r2]	@ zero_extendqisi2
	ldr	r3, .L1278+16
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
	ldr	r1, .L1278
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
	bne	.L1198
	movs	r2, #255
	str	r2, [r3, #2052]
	movs	r2, #64
	str	r2, [r3, #2048]
	movs	r2, #204
.L1275:
	str	r2, [r3, #2052]
	movs	r2, #77
	b	.L1276
.L1198:
	subs	r2, r4, #5
	cmp	r2, #1
	bhi	.L1200
	ldr	r2, .L1278
	ldrb	r2, [r2, #4]	@ zero_extendqisi2
	str	r2, [r3, #2052]
	movs	r2, #82
.L1276:
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
	bls	.L1237
	cmp	r4, #7
	ite	eq
	moveq	r2, #32
	movne	r2, #2
.L1203:
	ldr	r3, .L1278+20
	subs	r2, r2, #1
	ldr	r3, [r3]
	subs	r1, r3, #1
	uxtab	r2, r3, r2
	mov	r0, r1
.L1204:
	ldr	r6, [r5, #2048]
	strb	r6, [r0, #1]!
	cmp	r2, r0
	bne	.L1204
	cmp	r4, #7
	bne	.L1205
	movs	r2, #0
.L1207:
	ldrb	r0, [r3, r2, lsl #2]	@ zero_extendqisi2
	uxtb	r1, r2
	cmp	r0, #12
	beq	.L1206
	add	r0, r3, r2, lsl #2
	ldrb	r0, [r0, #1]	@ zero_extendqisi2
	cmp	r0, #10
	beq	.L1206
	adds	r2, r2, #1
	cmp	r2, #8
	bne	.L1207
.L1208:
	movs	r1, #0
	ldr	r0, .L1278+24
	bl	printf
.L1210:
	b	.L1210
.L1200:
	movs	r2, #174
	str	r2, [r3, #2052]
	movs	r2, #0
	str	r2, [r3, #2048]
	movs	r2, #176
	b	.L1275
.L1237:
	movs	r2, #16
	b	.L1203
.L1279:
	.align	2
.L1278:
	.word	.LANCHOR20
	.word	.LANCHOR193
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR6
	.word	.LANCHOR143
	.word	.LC16
.L1206:
	cmp	r1, #6
	bhi	.L1208
.L1209:
	ldr	r3, .L1280
	ldr	lr, [r3]
	mov	r3, lr
.L1214:
	ldr	r1, [sp, #52]
	sub	r2, r3, lr
	cmp	r1, r2
	bgt	.L1215
	ldr	r3, .L1280
	ldr	r1, [r3]
	ldr	r3, [sp, #32]
	adds	r0, r1, r3
	movs	r3, #8
.L1217:
	mov	r7, r0
	movs	r6, #0
.L1216:
	ldr	r2, [r7]
	adds	r6, r6, #1
	mvns	r2, r2
	str	r2, [r7], #4
	ldr	r2, [sp, #12]
	cmp	r2, r6
	bgt	.L1216
	ldr	r2, [sp, #48]
	subs	r3, r3, #1
	add	r0, r0, r2
	bne	.L1217
	str	r1, [sp, #20]
	str	r3, [sp, #24]
.L1223:
	movs	r0, #0
	mov	r2, r0
.L1222:
	movs	r3, #1
	mov	ip, #0
	lsl	r7, r3, r2
	movs	r3, #16
	str	r3, [sp, #44]
	mov	r6, r7
	ldr	r7, [sp, #20]
.L1220:
	ldr	r3, [r7]
	bics	r3, r6, r3
	ldr	r3, [sp, #32]
	it	eq
	addeq	ip, ip, #1
	add	r7, r7, r3
	ldr	r3, [sp, #44]
	subs	r3, r3, #1
	str	r3, [sp, #44]
	bne	.L1220
	cmp	ip, #8
	add	r2, r2, #1
	itt	hi
	movhi	r3, r6
	orrhi	r0, r0, r3
	cmp	r2, #32
	bne	.L1222
	ldr	r3, [sp, #20]
	str	r0, [r3], #4
	str	r3, [sp, #20]
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	str	r3, [sp, #24]
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #12]
	cmp	r3, r2
	bgt	.L1223
	subs	r2, r1, #4
	add	r0, r1, #28
	movs	r3, #0
.L1226:
	ldr	r6, [r2, #4]!
	cbnz	r6, .L1225
	adds	r3, r3, #1
.L1225:
	cmp	r0, r2
	bne	.L1226
	cmp	r3, #7
	ble	.L1227
	ldr	r0, .L1280+4
	mov	r3, #1024
	movs	r2, #1
	bl	rknand_print_hex
	movs	r1, #0
	ldr	r0, .L1280+8
	bl	printf
.L1228:
	b	.L1228
.L1205:
	cmp	r4, #6
	bne	.L1209
	adds	r3, r3, #7
.L1211:
	ldrb	r2, [r1, #1]!	@ zero_extendqisi2
	cmp	r2, #12
	beq	.L1209
	ldrb	r2, [r1, #8]	@ zero_extendqisi2
	cmp	r2, #4
	beq	.L1209
	cmp	r3, r1
	bne	.L1211
	movs	r1, #0
	ldr	r0, .L1280+8
	bl	printf
.L1213:
	b	.L1213
.L1215:
	ldr	r2, [r5, #2048]
	strb	r2, [r3], #1
	b	.L1214
.L1227:
	cmp	r4, #6
	beq	.L1239
	cmp	r4, #7
	ite	eq
	moveq	ip, #10
	movne	ip, #8
.L1229:
	add	r3, fp, #-1
	ldr	r1, [sp, #36]
	uxtb	r3, r3
	movs	r0, #0
	adds	r3, r3, #1
.L1230:
	mov	r7, r1
	mov	r2, lr
.L1231:
	ldrb	r6, [r2], #1	@ zero_extendqisi2
	strb	r6, [r7], #1
	sub	r6, r2, lr
	uxtb	r6, r6
	cmp	fp, r6
	bhi	.L1231
	adds	r0, r0, #1
	add	lr, lr, r3
	cmp	r10, r0
	add	r1, r1, ip
	bgt	.L1230
	ldr	r3, [sp, #4]
	mov	r0, r8
	ldr	r2, [sp, #8]
	add	r6, r3, r2, lsl #8
	movs	r3, #255
	str	r3, [r6, #2056]
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #40]
	cmp	r3, #1
	bhi	.L1233
	movs	r3, #54
	mov	r1, #-1
	str	r3, [r6, #2056]
	ldr	r3, .L1280+12
	ldr	r0, [sp, #16]
	ldrb	r3, [r3, #4]	@ zero_extendqisi2
	str	r3, [r5, #2052]
	movs	r3, #0
	str	r3, [r5, #2048]
	movs	r3, #22
	str	r3, [r6, #2056]
	bl	FlashReadCmd
.L1234:
	mov	r0, r8
	bl	NandcWaitFlashReady
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	b	.L1277
.L1239:
	mov	ip, #4
	b	.L1229
.L1233:
	movs	r3, #56
	str	r3, [r6, #2056]
	b	.L1234
.L1281:
	.align	2
.L1280:
	.word	.LANCHOR143
	.word	.LC17
	.word	.LC16
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
	cbz	r0, .L1282
	subs	r2, r0, #1
	cmp	r2, #6
	bhi	.L1284
	b	HynixGetReadRetryDefault
.L1284:
	cmp	r0, #49
	bne	.L1285
	ldr	r0, .L1305
	movs	r2, #64
	ldr	r1, .L1305+4
	strb	r3, [r0]
	movs	r3, #4
	strb	r3, [r0, #1]
	movs	r3, #15
	strb	r3, [r0, #2]
.L1303:
	adds	r0, r0, #4
	b	ftl_memcpy
.L1285:
	cmp	r0, #33
	beq	.L1286
	sub	r2, r0, #65
	cmp	r2, #1
	bhi	.L1287
.L1286:
	ldr	r0, .L1305
	strb	r3, [r0]
	movs	r3, #4
.L1304:
	strb	r3, [r0, #1]
	movs	r3, #7
	strb	r3, [r0, #2]
	movs	r2, #45
	ldr	r1, .L1305+8
	b	.L1303
.L1287:
	cmp	r0, #34
	beq	.L1288
	cmp	r0, #67
	bne	.L1289
.L1288:
	ldr	r0, .L1305
	strb	r3, [r0]
	movs	r3, #5
	b	.L1304
.L1289:
	cmp	r0, #35
	beq	.L1290
	cmp	r0, #68
	bne	.L1282
.L1290:
	ldr	r0, .L1305
	movs	r2, #95
	ldr	r1, .L1305+12
	strb	r3, [r0]
	movs	r3, #5
	strb	r3, [r0, #1]
	movs	r3, #17
	strb	r3, [r0, #2]
	b	.L1303
.L1282:
	bx	lr
.L1306:
	.align	2
.L1305:
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
	ldr	r3, .L1399
	ldr	r10, .L1399+132
	ldr	r8, .L1399+136
	str	r0, [r3]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L1399+4
	ldr	r6, .L1399+8
	ldr	r7, .L1399+12
	str	r0, [r3]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L1399+16
	str	r0, [r3]
	mov	r0, #32768
	bl	ftl_malloc
	ldr	r3, .L1399+20
	str	r0, [r3]
	mov	r0, #4096
	bl	ftl_malloc
	ldr	r3, .L1399+24
	ldr	r2, .L1399+28
	strb	r5, [r8]
	str	r0, [r3]
	movs	r3, #50
	strb	r3, [r10]
	mov	r0, r4
	strb	r3, [r2]
	movs	r2, #128
	ldr	r3, .L1399+32
	ldr	r4, .L1399+36
	strb	r5, [r7]
	str	r5, [r3]
	ldr	r3, .L1399+40
	str	r2, [r3]
	ldr	r3, .L1399+44
	str	r5, [r3]
	movs	r3, #60
	strb	r3, [r6]
	bl	NandcInit
	str	r10, [sp, #20]
	ldr	r10, .L1399+140
	str	r8, [sp, #16]
	mov	r8, r6
	mov	r6, r4
.L1312:
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
	bhi	.L1308
	ldrb	r1, [r4, #5]	@ zero_extendqisi2
	ldrb	r3, [r4, #1]	@ zero_extendqisi2
	ldr	r0, .L1399+48
	str	r1, [sp, #12]
	ldrb	r1, [r4, #4]	@ zero_extendqisi2
	str	r1, [sp, #8]
	ldrb	r1, [r4, #3]	@ zero_extendqisi2
	str	r1, [sp, #4]
	ldrb	r1, [r4, #2]	@ zero_extendqisi2
	str	r1, [sp]
	adds	r1, r5, #1
	bl	printf
.L1308:
	cbnz	r5, .L1309
	ldrb	r3, [r6]	@ zero_extendqisi2
	subs	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, #253
	bhi	.L1352
	ldrb	r3, [r6, #1]	@ zero_extendqisi2
	cmp	r3, #255
	beq	.L1352
.L1309:
	ldrb	r3, [r4]	@ zero_extendqisi2
	adds	r5, r5, #1
	adds	r4, r4, #8
	cmp	r3, #181
	itt	eq
	moveq	r3, #44
	strbeq	r3, [r4, #-8]
	cmp	r5, #4
	bne	.L1312
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #173
	beq	.L1313
	ldr	r3, .L1399+52
	ldr	r0, [r3]
	bl	NandcSetDdrMode
.L1313:
	mov	r2, #852
	movs	r1, #0
	ldr	r0, .L1399+56
	bl	ftl_memset
	ldr	r4, .L1399+60
	ldr	r3, .L1399+64
	ldr	r5, .L1399+68
	str	r3, [r4]
	movs	r3, #0
	strb	r3, [r5]
	ldrb	r3, [r6, #1]	@ zero_extendqisi2
	cmp	r3, #161
	beq	.L1314
	cmp	r3, #218
	beq	.L1314
	and	r2, r3, #223
	cmp	r2, #209
	beq	.L1314
	cmp	r3, #220
	bne	.L1315
	ldrb	r2, [r6, #3]	@ zero_extendqisi2
	cmp	r2, #149
	bne	.L1315
.L1314:
	ldr	r1, [sp, #16]
	movs	r2, #1
	strb	r2, [r1]
	movs	r2, #16
	ldr	r1, [sp, #20]
	strb	r2, [r8]
	strb	r2, [r1]
	ldrb	r1, [r6]	@ zero_extendqisi2
	ldr	r2, .L1399+72
	cmp	r1, #152
	strb	r1, [r2, #1]
	strb	r3, [r2, #2]
	bne	.L1316
	ldrsb	r1, [r6, #4]
	cmp	r1, #0
	itt	ge
	movge	r1, #24
	strbge	r1, [r8]
.L1316:
	ldr	r1, .L1399+76
	ldr	r0, [r1]
	ldr	r1, .L1399+80
	cmp	r0, r1
	itt	eq
	moveq	r1, #16
	strbeq	r1, [r8]
	cmp	r3, #218
	bne	.L1318
	mov	r1, #2048
.L1395:
	strh	r1, [r2, #14]	@ movhi
	strb	r3, [r2, #2]
.L1319:
	movs	r2, #32
	ldr	r1, .L1399+84
	ldr	r0, .L1399+88
	bl	ftl_memcpy
	movs	r2, #32
	ldr	r1, .L1399+72
	ldr	r0, .L1399+64
	bl	ftl_memcpy
.L1315:
	ldr	r3, [sp, #16]
	ldr	r8, .L1399+144
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1321
	bl	FlashLoadPhyInfoInRam
	cbnz	r0, .L1323
	ldr	r3, [r4]
	ldr	r10, .L1399+100
	ldrh	r3, [r3, #16]
	lsrs	r3, r3, #8
	lsls	r1, r3, #31
	and	r0, r3, #7
	strb	r0, [r10]
	bmi	.L1323
	movs	r3, #1
	strb	r3, [r7]
	bl	FlashSetInterfaceMode
	ldrb	r0, [r10]	@ zero_extendqisi2
	bl	NandcSetMode
.L1323:
	ldr	r3, [r4]
	ldrb	r3, [r3, #26]	@ zero_extendqisi2
	strb	r3, [r8]
	bl	FlashLoadPhyInfo
	cmp	r0, #0
	beq	.L1321
	ldr	r3, [r4]
	ldr	r0, .L1399+92
	ldrh	r1, [r3, #14]
	bl	printf
	bl	FlashLoadPhyInfoInRam
	adds	r2, r0, #1
	beq	.L1307
	bl	FlashDieInfoInit
	ldr	r3, [r4]
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	bl	FlashGetReadRetryDefault
	ldr	r3, [r4]
	ldr	r2, .L1399+96
	ldrb	r1, [r3, #9]	@ zero_extendqisi2
	ldrh	r2, [r2]
	addw	r2, r2, #4095
	cmp	r1, r2, asr #12
	blt	.L1326
	ldrh	r2, [r3, #14]
	adds	r2, r2, #255
	cmp	r1, r2, asr #8
	bge	.L1327
.L1326:
	ldrh	r2, [r3, #14]
	bic	r2, r2, #255
	strh	r2, [r3, #14]	@ movhi
.L1327:
	ldr	r3, .L1399+100
	ldrb	r3, [r3]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L1328
	bl	FlashSavePhyInfo
	ldr	r3, .L1399+104
	movs	r0, #0
	ldr	r1, [r3]
	bl	FlashDdrParaScan
.L1328:
	bl	FlashSavePhyInfo
.L1321:
	ldr	fp, [r4]
	ldr	r10, .L1399+100
	ldrb	r3, [fp, #26]	@ zero_extendqisi2
	ldrh	r0, [fp, #10]
	strb	r3, [r8]
	ldrh	r3, [fp, #16]
	ubfx	r2, r3, #7, #1
	ubfx	r1, r3, #3, #1
	strb	r2, [r5]
	ldr	r2, .L1399+108
	ldr	r5, .L1399+112
	strb	r1, [r2]
	ubfx	r1, r3, #4, #1
	ldr	r2, .L1399+116
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
	beq	.L1330
	ldrb	r0, [r3, #19]	@ zero_extendqisi2
	ldr	r3, .L1399+120
	ldr	r2, .L1399+124
	strb	r0, [r3]
	ldr	r3, .L1399+56
	ldrb	r1, [r3, #1]	@ zero_extendqisi2
	ldrb	lr, [r3, #2]	@ zero_extendqisi2
	strb	r1, [r2]
	ldr	r1, .L1399+128
	strb	lr, [r1]
	add	lr, r0, #-1
	cmp	lr, #6
	b	.L1400
.L1401:
	.align	2
.L1399:
	.word	.LANCHOR143
	.word	.LANCHOR151
	.word	.LANCHOR150
	.word	.LANCHOR28
	.word	.LANCHOR194
	.word	.LANCHOR195
	.word	.LANCHOR196
	.word	.LANCHOR146
	.word	.LANCHOR145
	.word	.LANCHOR22
	.word	.LANCHOR3
	.word	.LANCHOR148
	.word	.LC18
	.word	.LANCHOR153
	.word	.LANCHOR20
	.word	.LANCHOR18
	.word	.LANCHOR29
	.word	.LANCHOR5
	.word	.LANCHOR197
	.word	.LANCHOR152
	.word	1446522928
	.word	.LANCHOR141+32
	.word	.LANCHOR7
	.word	.LC19
	.word	.LANCHOR119
	.word	.LANCHOR24
	.word	.LANCHOR144
	.word	.LANCHOR198
	.word	.LANCHOR149
	.word	.LANCHOR27
	.word	.LANCHOR10
	.word	.LANCHOR13
	.word	.LANCHOR147
	.word	.LANCHOR2
	.word	.LANCHOR1
	.word	.LANCHOR6
	.word	.LANCHOR8
.L1400:
	mov	lr, r1
	bhi	.L1331
	ldr	r2, .L1402
	str	r2, [r5]
	subs	r2, r0, #5
	cmp	r2, #1
	bhi	.L1332
	ldr	r2, .L1402+4
	adds	r3, r3, #20
	movs	r1, #1
	str	r1, [r2]
.L1333:
	subs	r1, r3, #1
	movs	r2, #0
	adds	r3, r3, #31
.L1335:
	ldrsb	r5, [r1, #1]!
	cbnz	r5, .L1334
	adds	r2, r2, #1
.L1334:
	cmp	r3, r1
	bne	.L1335
	cmp	r2, #27
	bls	.L1330
	bl	FlashGetReadRetryDefault
	bl	FlashSavePhyInfo
.L1330:
	ldr	r3, .L1402+8
	ldr	r2, [r3]
	ldr	r3, .L1402+12
	cmp	r2, r3
	bne	.L1346
	ldrb	r3, [r8]	@ zero_extendqisi2
	cbz	r3, .L1346
	ldr	r3, [r4]
	movs	r2, #0
	strb	r2, [r3, #18]
.L1346:
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r3, #44
	bne	.L1347
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbz	r3, .L1347
	movs	r3, #0
	movs	r0, #1
	strb	r3, [r7]
	bl	FlashSetInterfaceMode
	movs	r0, #1
	bl	NandcSetMode
.L1347:
	movs	r0, #0
	bl	flash_enter_slc_mode
	ldrb	r3, [r10]	@ zero_extendqisi2
	tst	r3, #6
	beq	.L1348
	ldrb	r2, [r7]	@ zero_extendqisi2
	cbnz	r2, .L1349
	lsls	r3, r3, #31
	bmi	.L1348
.L1349:
	ldr	r3, .L1402+16
	movs	r0, #0
	ldr	r1, [r3]
	bl	FlashDdrParaScan
.L1348:
	movs	r0, #0
	movs	r7, #16
	bl	flash_exit_slc_mode
	ldr	r3, [r4]
	ldrb	r0, [r3, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	ldr	r0, .L1402+20
	bl	FlashReadIdbDataRaw
	ldr	r8, [r4]
	ldr	r3, [sp, #20]
	ldr	r4, .L1402+24
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
	ldr	r3, .L1402+28
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
	bne	.L1350
	lsls	r3, r3, #1
	lsrs	r2, r6, #1
	lsls	r5, r5, #1
	strh	r3, [r4, #20]	@ movhi
	movs	r3, #8
	strh	r2, [r4, #14]	@ movhi
	strh	r5, [r4, #22]	@ movhi
	strh	r3, [r4, #26]	@ movhi
.L1350:
	ldrb	r0, [r8, #20]	@ zero_extendqisi2
	bl	FlashBchSel
	movs	r0, #0
.L1307:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1318:
	cmp	r3, #220
	bne	.L1319
	mov	r1, #4096
	b	.L1395
.L1332:
	add	r2, r3, #28
	adds	r3, r3, #20
	cmp	r0, #7
	it	eq
	moveq	r3, r2
	b	.L1333
.L1331:
	sub	r3, r0, #17
	cmp	r3, #2
	bhi	.L1337
	ldr	r3, .L1402+32
	cmp	r0, #19
	str	r3, [r5]
	ite	ne
	movne	r3, #7
	moveq	r3, #15
	strb	r3, [r1]
	b	.L1330
.L1337:
	cmp	r0, #33
	beq	.L1339
	sub	r3, r0, #65
	cmp	r3, #1
	bhi	.L1340
.L1339:
	ldr	r3, .L1402+36
	str	r3, [ip]
	movs	r3, #4
	strb	r3, [r2]
	movs	r3, #7
	strb	r3, [lr]
	b	.L1330
.L1340:
	sub	r3, r0, #67
	uxtb	r3, r3
	cmp	r3, #1
	bls	.L1341
	sub	r1, r0, #34
	cmp	r1, #1
	bhi	.L1342
.L1341:
	ldr	r1, .L1402+36
	cmp	r0, #35
	str	r1, [ip]
	ldr	r1, .L1402+40
	beq	.L1343
	cmp	r0, #68
	beq	.L1343
	movs	r0, #7
.L1396:
	cmp	r3, #1
	strb	r0, [r1]
	ite	ls
	movls	r3, #4
	movhi	r3, #5
	strb	r3, [r2]
	b	.L1330
.L1343:
	movs	r0, #17
	b	.L1396
.L1342:
	cmp	r0, #49
	itt	eq
	ldreq	r3, .L1402+44
	streq	r3, [r5]
	b	.L1330
.L1352:
	mvn	r0, #1
	b	.L1307
.L1403:
	.align	2
.L1402:
	.word	HynixReadRetrial
	.word	.LANCHOR34
	.word	.LANCHOR152
	.word	1446522928
	.word	.LANCHOR144
	.word	.LANCHOR139
	.word	.LANCHOR15
	.word	.LANCHOR25
	.word	MicronReadRetrial
	.word	ToshibaReadRetrial
	.word	.LANCHOR147
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
	ldr	r3, .L1433
	mov	fp, r2
	mov	r4, r0
	movs	r7, #0
	ldrb	r10, [r3, #9]	@ zero_extendqisi2
.L1405:
	cmp	r7, r8
	bne	.L1418
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1418:
	sub	r3, r8, r7
	add	r2, sp, #12
	uxtb	r3, r3
	mov	r1, fp
	mov	r0, r4
	str	r3, [sp]
	add	r3, sp, #8
	bl	LogAddr2PhyAddr
	ldr	r2, .L1433+4
	ldr	r3, [sp, #8]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1406
	mov	r3, #-1
	str	r3, [r4]
.L1407:
	adds	r7, r7, #1
	adds	r4, r4, #36
	b	.L1405
.L1406:
	ldr	r2, .L1433+8
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
	ldr	r3, .L1433+12
	mov	r6, r0
	ldr	r1, [sp, #12]
	mov	r0, r5
	ldr	r3, [r3]
	add	r1, r1, r3
	bl	FlashReadCmd
	ldr	r3, [r4, #8]
	cbz	r3, .L1408
	add	r3, r3, #2048
.L1408:
	ldr	r2, [r4, #12]
	cbz	r2, .L1409
	adds	r2, r2, #8
.L1409:
	str	r2, [sp]
	movs	r1, #0
	mov	r2, r10
	mov	r0, r5
	bl	NandcXferData
	mov	r1, r0
	mov	r0, r5
	bl	NandcFlashDeCs
	ldr	r3, .L1433+16
	cmp	r6, r1
	it	cc
	movcc	r6, r1
	ldrb	r2, [r3]	@ zero_extendqisi2
	add	r3, r2, r2, lsl #1
	cmp	r6, r3, asr #2
	bls	.L1410
	adds	r5, r6, #1
	it	ne
	movne	r6, #256
	str	r6, [r4]
.L1413:
	ldr	r3, [r4, #12]
	cbz	r3, .L1414
	ldr	r1, [r3, #8]
	adds	r0, r1, #1
	bne	.L1414
	ldr	r3, [r3]
	adds	r3, r3, #1
	it	ne
	strne	r1, [r4]
.L1414:
	ldr	r3, [r4]
	adds	r1, r3, #1
	bne	.L1407
	ldr	r1, [r4, #4]
	ldr	r0, .L1433+20
	bl	printf
	ldr	r1, [r4, #8]
	cbz	r1, .L1416
	movs	r3, #8
	movs	r2, #4
	ldr	r0, .L1433+24
	bl	rknand_print_hex
.L1416:
	ldr	r1, [r4, #12]
	cmp	r1, #0
	beq	.L1407
	movs	r3, #4
	ldr	r0, .L1433+28
	mov	r2, r3
	bl	rknand_print_hex
	b	.L1407
.L1410:
	movs	r3, #0
	str	r3, [r4]
	b	.L1413
.L1434:
	.align	2
.L1433:
	.word	.LANCHOR29
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR3
	.word	.LANCHOR31
	.word	.LC20
	.word	.LC21
	.word	.LC22
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
	ldr	r3, .L1526
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	mov	r10, r0
	str	r1, [sp, #24]
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r2, [sp, #12]
	cbnz	r3, .L1436
	ldr	r2, .L1526+4
	mov	r8, r3
	str	r3, [sp, #8]
	ldrb	r2, [r2, #9]	@ zero_extendqisi2
	str	r2, [sp, #20]
	ldr	r2, .L1526+8
	ldrb	r2, [r2]	@ zero_extendqisi2
	str	r2, [sp, #28]
.L1437:
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #24]
	cmp	r3, r2
	bcc	.L1475
	movs	r0, #0
	b	.L1435
.L1436:
	bl	FlashReadSlc2KPages
.L1435:
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1475:
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
	ldr	r2, .L1526+12
	mov	r5, r0
	ldr	r3, [sp, #32]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1439
	mov	r3, #-1
	str	r3, [r10, fp]
.L1440:
	ldr	r3, [sp, #8]
	adds	r3, r3, #1
	str	r3, [sp, #8]
	b	.L1437
.L1439:
	ldr	r2, .L1526+16
	ldrb	r4, [r2, r3]	@ zero_extendqisi2
	ldr	r3, .L1526+20
	mov	r0, r4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	it	eq
	moveq	r5, #0
	bl	NandcWaitFlashReady
	ldr	r3, .L1526+24
	ldr	r3, [r3]
	ldrb	r1, [r3, #19]	@ zero_extendqisi2
	subs	r3, r1, #1
	cmp	r3, #6
	bhi	.L1442
	ldr	r3, .L1526+28
	cmp	r1, #7
	add	r2, r3, r4
	ldrb	r3, [r2, #12]	@ zero_extendqisi2
	it	eq
	ldrbeq	r3, [r2, #20]	@ zero_extendqisi2
	ldr	r2, .L1526+32
	ldrb	r2, [r2, r4]	@ zero_extendqisi2
	cmp	r2, r3
	beq	.L1442
	ldr	r2, .L1526+36
	mov	r0, r4
	ldrb	r1, [r2, #-3]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1442:
	mov	r0, r4
	bl	NandcFlashCs
	ldr	r3, [sp, #12]
	cmp	r3, #1
	beq	.L1444
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1445
.L1444:
	ldr	r3, .L1526+40
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1445
	mov	r0, r4
	bl	flash_enter_slc_mode
.L1452:
	ldr	r1, [sp, #36]
	adds	r6, r1, #1
	bne	.L1447
	cmp	r4, #255
	beq	.L1477
.L1447:
	cbz	r5, .L1449
	ldr	r3, .L1526+44
	mov	r0, r4
	ldr	r2, [r3]
	add	r2, r2, r1
	bl	FlashReadDpCmd
.L1450:
	mov	r0, r4
	bl	NandcWaitFlashReady
	cbz	r5, .L1448
	ldr	r1, [sp, #36]
	mov	r0, r4
	bl	FlashReadDpDataOutCmd
.L1448:
	ldr	r3, [r7, #12]
	movs	r1, #0
	ldr	r2, [sp, #20]
	mov	r0, r4
	str	r3, [sp]
	ldr	r3, [r7, #8]
	bl	NandcXferData
	ldr	r3, .L1526+8
	mov	r6, r0
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1451
	adds	r0, r0, #1
	bne	.L1451
	ldr	r3, .L1526+8
	movs	r5, #0
	strb	r5, [r3]
	b	.L1452
.L1445:
	mov	r0, r4
	bl	flash_exit_slc_mode
	b	.L1452
.L1449:
	mov	r0, r4
	bl	FlashReadCmd
	b	.L1450
.L1477:
	movs	r5, #0
	b	.L1448
.L1451:
	cbz	r5, .L1453
	ldr	r3, .L1526+44
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
.L1453:
	mov	r0, r4
	bl	NandcFlashDeCs
	ldr	r3, .L1526+8
	adds	r1, r6, #1
	ldrb	r2, [sp, #28]	@ zero_extendqisi2
	strb	r2, [r3]
	bne	.L1454
	ldr	r3, .L1526+48
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1455
.L1459:
	ldr	r3, .L1526+52
	ldr	r5, [r3]
	cmp	r5, #0
	bne	.L1456
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	bl	FlashReadRawPage
	b	.L1525
.L1455:
	ldr	r3, .L1526+56
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
	beq	.L1458
	ldr	r3, .L1526+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r0, r3, lsr #1
	bls	.L1478
.L1458:
	ubfx	r0, r5, #8, #8
	bl	NandcSetDdrPara
	adds	r3, r6, #1
	beq	.L1459
.L1478:
	movs	r5, #0
.L1454:
	ldr	r3, .L1526+60
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r6, r3, asr #2
	bls	.L1467
	ldr	r3, .L1526+52
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L1467
	mov	r6, #256
	b	.L1462
.L1527:
	.align	2
.L1526:
	.word	.LANCHOR1
	.word	.LANCHOR29
	.word	.LANCHOR5
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LANCHOR198
	.word	.LANCHOR18
	.word	.LANCHOR20
	.word	.LANCHOR21
	.word	.LANCHOR20+4
	.word	.LANCHOR8
	.word	.LANCHOR3
	.word	.LANCHOR28
	.word	.LANCHOR149
	.word	.LANCHOR19
	.word	.LANCHOR31
.L1456:
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	blx	r5
	adds	r5, r0, #1
	mov	r6, r0
	bne	.L1460
	ldr	r3, .L1528
	ldr	r3, [r3]
	ldrb	r3, [r3, #19]	@ zero_extendqisi2
	subs	r3, r3, #1
	cmp	r3, #6
	bhi	.L1461
	ldr	r2, .L1528+4
	movs	r3, #0
	mov	r0, r4
	ldrb	r1, [r2, #-3]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1461:
	ldr	r3, [r7, #12]
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	bl	FlashReadRawPage
	ldr	r2, .L1528+8
	mov	r6, r0
	mov	r3, r0
	ldr	r1, [r7, #4]
	ldr	r0, .L1528+12
	ldrb	r2, [r2]	@ zero_extendqisi2
	bl	printf
	adds	r0, r6, #1
	bne	.L1460
	ldr	r3, .L1528+16
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L1462
	ldr	r3, [sp, #12]
	mov	r0, r4
	cmp	r3, #1
	beq	.L1463
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1464
.L1463:
	bl	flash_enter_slc_mode
.L1465:
	ldr	r3, .L1528+20
	mov	r0, r4
	ldr	r2, [r7, #8]
	ldr	r1, [sp, #36]
	ldr	r5, [r3]
	ldr	r3, [r7, #12]
	blx	r5
.L1525:
	adds	r1, r0, #1
	mov	r6, r0
	mov	r5, #0
	bne	.L1467
.L1462:
	str	r6, [r10, fp]
.L1468:
	ldr	r3, [r10, fp]
	adds	r2, r3, #1
	bne	.L1470
	ldr	r2, .L1528+8
	ldr	r1, [r7, #4]
	ldr	r0, .L1528+24
	ldrb	r2, [r2]	@ zero_extendqisi2
	bl	printf
	ldr	r1, [r7, #12]
	cbz	r1, .L1470
	movs	r3, #4
	ldr	r0, .L1528+28
	mov	r2, r3
	bl	rknand_print_hex
.L1470:
	cbz	r5, .L1472
	ldr	r3, .L1528+8
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, r3, lsl #1
	cmp	r8, r3, asr #2
	bls	.L1473
	ldr	r3, .L1528+20
	ldr	r3, [r3]
	cmp	r3, #0
	it	eq
	moveq	r8, #256
.L1473:
	cmp	r8, #-1
	add	r3, fp, #36
	str	r8, [r10, r3]
	beq	.L1472
	cmp	r8, #256
	itt	ne
	movne	r2, #0
	strne	r2, [r10, r3]
.L1472:
	ldr	r3, [sp, #8]
	add	r3, r3, r5
	str	r3, [sp, #8]
	ldr	r3, [sp, #12]
	cmp	r3, #1
	beq	.L1474
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bge	.L1440
.L1474:
	ldr	r3, .L1528+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1440
	mov	r0, r4
	bl	flash_exit_slc_mode
	b	.L1440
.L1464:
	bl	flash_exit_slc_mode
	b	.L1465
.L1460:
	movs	r5, #0
.L1467:
	cmp	r6, #256
	beq	.L1462
	movs	r3, #0
	str	r3, [r10, fp]
	b	.L1468
.L1529:
	.align	2
.L1528:
	.word	.LANCHOR18
	.word	.LANCHOR20+4
	.word	.LANCHOR31
	.word	.LC23
	.word	.LANCHOR8
	.word	.LANCHOR149
	.word	.LC20
	.word	.LC22
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
	ldr	r3, .L1559
	movs	r7, #0
	ldr	fp, .L1559+28
	str	r2, [sp, #8]
	ldrb	r10, [r3, #9]	@ zero_extendqisi2
.L1531:
	cmp	r7, r8
	bne	.L1537
	ldr	r3, [sp, #12]
	cmp	r3, #0
	bne	.L1548
.L1558:
	movs	r0, #0
	add	sp, sp, #64
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1537:
	sub	r3, r8, r7
	add	r2, sp, #20
	uxtb	r3, r3
	ldr	r1, [sp, #8]
	mov	r0, r6
	str	r3, [sp]
	add	r3, sp, #24
	bl	LogAddr2PhyAddr
	ldr	r2, .L1559+4
	ldr	r3, [sp, #24]
	ldrb	r2, [r2]	@ zero_extendqisi2
	cmp	r2, r3
	bhi	.L1532
	mov	r3, #-1
	str	r3, [r6]
.L1533:
	adds	r7, r7, #1
	adds	r6, r6, #36
	b	.L1531
.L1532:
	ldr	r2, .L1559+8
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
	cbz	r3, .L1534
	add	r3, r3, #2048
.L1534:
	ldr	r2, [r6, #12]
	cbz	r2, .L1535
	adds	r2, r2, #8
.L1535:
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
	b	.L1533
.L1544:
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1539
	ldr	r1, [r4, #4]
	ldr	r0, .L1559+12
	bl	printf
.L1540:
	add	r8, r8, #1
	adds	r4, r4, #36
.L1538:
	cmp	r7, r8
	bne	.L1544
	b	.L1558
.L1539:
	sub	r3, r7, r8
	ldr	fp, .L1559+32
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
	bne	.L1541
	ldr	r1, [r4, #4]
	ldr	r0, .L1559+16
	bl	printf
	str	r5, [r4]
.L1541:
	ldr	r3, [r4, #12]
	cbz	r3, .L1542
	ldr	r2, [r3]
	ldr	r3, [fp]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1542
	ldr	r1, [r4, #4]
	ldr	r0, .L1559+20
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L1542:
	ldr	r3, [r4, #8]
	cmp	r3, #0
	beq	.L1540
	ldr	r2, [r3]
	ldr	r3, [r10]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1540
	ldr	r1, [r4, #4]
	ldr	r0, .L1559+24
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
	b	.L1540
.L1548:
	mov	r8, #0
	ldr	r10, .L1559+36
	b	.L1538
.L1560:
	.align	2
.L1559:
	.word	.LANCHOR29
	.word	.LANCHOR25
	.word	.LANCHOR26
	.word	.LC24
	.word	.LC25
	.word	.LC26
	.word	.LC27
	.word	.LANCHOR3
	.word	.LANCHOR196
	.word	.LANCHOR195
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
	ldr	r5, .L1613
	mov	r4, r0
	mov	r8, r2
	str	r1, [sp, #8]
	ldr	r5, [r5]
	str	r3, [sp, #20]
	ldrb	r5, [r5, #19]	@ zero_extendqisi2
	str	r5, [sp, #16]
	ldr	r5, .L1613+4
	ldrb	r7, [r5]	@ zero_extendqisi2
	cbnz	r7, .L1562
	ldr	r3, .L1613+8
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	str	r3, [sp, #12]
.L1563:
	ldr	r3, [sp, #8]
	cmp	r7, r3
	bcc	.L1576
	ldr	r6, .L1613+12
	movs	r5, #0
	ldr	r7, .L1613+16
.L1577:
	ldrb	r3, [r6]	@ zero_extendqisi2
	cmp	r5, r3
	bcc	.L1579
	ldr	r3, [sp, #20]
	cmp	r3, #0
	bne	.L1580
.L1588:
	movs	r0, #0
	b	.L1561
.L1562:
	bl	FlashProgSlc2KPages
.L1561:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1576:
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
	ldr	r3, .L1613+12
	mov	r10, r0
	ldr	r0, [sp, #32]
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, r0
	bhi	.L1565
	mov	r3, #-1
	str	r3, [r4, r6]
.L1566:
	adds	r7, r7, #1
	b	.L1563
.L1565:
	ldr	r3, .L1613+20
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	ldr	r3, .L1613+24
	it	eq
	moveq	r10, #0
	add	r3, r3, r0, lsl #4
	ldr	r3, [r3, #8]
	cbz	r3, .L1568
	uxtb	r0, r0
	bl	FlashWaitCmdDone
.L1568:
	ldr	r3, [sp, #32]
	movs	r1, #0
	ldr	r2, .L1613+24
	add	r2, r2, r3, lsl #4
	str	r1, [r2, #12]
	ldr	r1, [sp, #28]
	str	fp, [r2, #8]
	str	r1, [r2, #4]
	cmp	r10, #0
	beq	.L1569
	add	r1, r6, #36
	add	r1, r1, r4
	str	r1, [r2, #12]
.L1569:
	ldr	r2, .L1613+28
	ldrb	r5, [r2, r3]	@ zero_extendqisi2
	lsls	r3, r3, #4
	ldr	r2, .L1613+24
	mov	r0, r5
	strb	r5, [r2, r3]
	ldr	r3, .L1613+12
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1570
	bl	NandcWaitFlashReady
.L1571:
	ldr	r3, [sp, #16]
	subs	r3, r3, #1
	cmp	r3, #6
	bhi	.L1572
	ldr	r3, .L1613+32
	ldrb	r3, [r3, r5]	@ zero_extendqisi2
	cbz	r3, .L1572
	ldr	r1, .L1613+36
	movs	r3, #0
	mov	r0, r5
	adds	r2, r1, #4
	ldrb	r1, [r1, #1]	@ zero_extendqisi2
	bl	HynixSetRRPara
.L1572:
	mov	r0, r5
	bl	NandcFlashCs
	cmp	r8, #1
	mov	r0, r5
	bne	.L1573
	ldr	r3, .L1613+16
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L1573
	bl	flash_enter_slc_mode
.L1574:
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
	beq	.L1575
	ldr	r1, [sp, #28]
	mov	r0, r5
	bl	FlashProgDpFirstCmd
	ldr	r3, .L1613+40
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
	ldr	r3, .L1613+44
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
.L1575:
	ldr	r1, [sp, #28]
	mov	r0, r5
	bl	FlashProgSecondCmd
	mov	r0, r5
	add	r7, r7, r10
	bl	NandcFlashDeCs
	b	.L1566
.L1570:
	bl	NandcFlashCs
	ldr	r2, [sp, #32]
	mov	r0, r5
	ldr	r3, .L1613+40
	ldr	r1, [sp, #28]
	ldr	r2, [r3, r2, lsl #2]
	adds	r2, r2, #0
	it	ne
	movne	r2, #1
	bl	FlashWaitReadyEN
	mov	r0, r5
	bl	NandcFlashDeCs
	b	.L1571
.L1573:
	bl	flash_exit_slc_mode
	b	.L1574
.L1579:
	uxtb	r0, r5
	bl	FlashWaitCmdDone
	cmp	r8, #1
	bne	.L1578
	ldrb	r3, [r7]	@ zero_extendqisi2
	cbz	r3, .L1578
	ldr	r2, .L1613+24
	lsls	r3, r5, #4
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	flash_exit_slc_mode
.L1578:
	adds	r5, r5, #1
	b	.L1577
.L1580:
	ldr	r10, .L1613+64
	movs	r7, #0
.L1581:
	ldr	r3, [sp, #8]
	cmp	r7, r3
	beq	.L1588
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1582
	ldr	r1, [r4, #4]
	ldr	r0, .L1613+48
	bl	printf
.L1583:
	adds	r7, r7, #1
	adds	r4, r4, #36
	b	.L1581
.L1582:
	ldr	r3, [sp, #8]
	add	r2, sp, #28
	ldr	fp, .L1613+68
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
	bne	.L1584
	ldr	r1, [r4, #4]
	ldr	r0, .L1613+52
	bl	printf
	str	r5, [r4]
.L1584:
	ldr	r3, [r4, #12]
	cbz	r3, .L1585
	ldr	r2, [r3]
	ldr	r3, [fp]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1585
	ldr	r1, [r4, #4]
	ldr	r0, .L1613+56
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L1585:
	ldr	r3, [r4, #8]
	cmp	r3, #0
	beq	.L1583
	ldr	r2, [r3]
	ldr	r3, [r10]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L1583
	ldr	r1, [r4, #4]
	ldr	r0, .L1613+60
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
	b	.L1583
.L1614:
	.align	2
.L1613:
	.word	.LANCHOR18
	.word	.LANCHOR1
	.word	.LANCHOR29
	.word	.LANCHOR25
	.word	.LANCHOR8
	.word	.LANCHOR27
	.word	.LANCHOR23
	.word	.LANCHOR26
	.word	.LANCHOR21
	.word	.LANCHOR20
	.word	.LANCHOR17
	.word	.LANCHOR3
	.word	.LC24
	.word	.LC25
	.word	.LC26
	.word	.LC27
	.word	.LANCHOR195
	.word	.LANCHOR196
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
	ldr	r3, .L1618
	push	{r4, r5, lr}
	mov	r4, r0
	sub	sp, sp, #108
	ldr	r3, [r3]
	cmp	r0, r3
	bcc	.L1617
	ldr	r5, .L1618+4
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
.L1615:
	mov	r0, r4
	add	sp, sp, #108
	@ sp needed
	pop	{r4, r5, pc}
.L1617:
	movs	r4, #0
	b	.L1615
.L1619:
	.align	2
.L1618:
	.word	.LANCHOR145
	.word	.LANCHOR151
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
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1665
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	str	r0, [sp, #4]
	ldr	r3, [r3]
	str	r1, [sp]
	cmp	r3, #0
	bne	.L1647
	ldr	r2, .L1665+4
	mov	fp, r3
	ldr	r7, .L1665+8
	mov	r5, r3
	mov	r4, r3
	mov	r10, #36
	ldrb	r2, [r2]	@ zero_extendqisi2
	ldr	r8, [r7]
	str	r2, [sp, #8]
	ldr	r2, .L1665+12
	str	r0, [r2]
	ldr	r2, .L1665+16
	ldrh	r2, [r2]
	str	r2, [sp, #20]
	ldr	r2, .L1665+20
	ldr	r2, [r2]
	str	r2, [sp, #12]
	ldr	r2, .L1665+24
	ldrh	r2, [r2]
	str	r2, [sp, #16]
.L1622:
	ldr	r3, [sp, #20]
	uxth	r2, fp
	cmp	r3, r2
	bhi	.L1626
	cmp	r5, #0
	beq	.L1620
	ldr	r3, [sp, #8]
	mov	r0, r8
	mov	r10, #36
	mov	r8, #0
	mov	r2, r5
	adds	r6, r3, #0
	it	ne
	movne	r6, #1
	mov	r1, r6
	bl	FlashEraseBlocks
.L1628:
	uxth	r3, r8
	cmp	r5, r3
	bhi	.L1630
	ldr	r3, [sp]
	cmp	r3, #0
	bne	.L1631
	uxth	r6, r6
	mov	r10, #6
	movs	r3, #1
	str	r3, [sp, #8]
.L1632:
	movs	r7, #0
.L1641:
	ldr	r3, .L1665+16
	mov	r8, #0
	mov	r5, r8
	ldrh	r3, [r3]
	str	r3, [sp, #28]
	ldr	r3, .L1665+8
	ldr	fp, [r3]
	ldr	r3, .L1665+28
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L1665+32
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L1665+24
	ldrh	r3, [r3]
	str	r3, [sp, #24]
.L1633:
	ldr	r3, [sp, #28]
	uxth	r2, r8
	cmp	r3, r2
	bhi	.L1636
	cbz	r5, .L1620
	mov	r0, fp
	ldr	fp, .L1665+8
	movs	r3, #1
	mov	r2, r6
	mov	r1, r5
	mov	r8, #0
	bl	FlashProgPages
	movs	r3, #36
.L1638:
	uxth	r2, r8
	cmp	r5, r2
	bhi	.L1640
	add	r7, r7, r10
	ldr	r3, [sp, #8]
	uxth	r7, r7
	cmp	r7, r3
	bcc	.L1641
	ldr	r8, .L1665+8
	movs	r7, #0
	mov	r10, #36
.L1642:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L1644
	ldr	r3, [sp, #4]
	cmp	r3, #63
	bls	.L1645
	ldr	r3, [sp]
	cbz	r3, .L1620
.L1645:
	ldr	r3, .L1665+8
	mov	r2, r5
	mov	r1, r6
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L1620:
	mov	r0, r4
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1626:
	mul	r2, r10, fp
	movs	r3, #0
	ldr	r1, [sp, #4]
	str	r3, [r8, r2]
	ldr	r3, .L1665+36
	ldrb	r0, [r3, fp]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r3, [sp]
	mov	r6, r0
	cbz	r3, .L1623
	bl	IsBlkInVendorPart
	cbnz	r0, .L1624
.L1623:
	mov	r0, r6
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1625
	ldr	r3, [sp, #16]
	mla	r1, r10, r5, r8
	lsls	r6, r6, #10
	mul	r2, r3, r5
	ldr	r3, [sp, #12]
	adds	r5, r5, #1
	str	r6, [r1, #4]
	uxth	r5, r5
	str	r0, [r1, #8]
	bic	r2, r2, #3
	add	r2, r2, r3
	str	r2, [r1, #12]
.L1624:
	add	fp, fp, #1
	b	.L1622
.L1625:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L1624
.L1630:
	mul	r3, r10, r8
	ldr	r2, [r7]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	adds	r3, r3, #1
	bne	.L1629
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L1629:
	add	r8, r8, #1
	b	.L1628
.L1631:
	ldr	r3, .L1665+40
	ldrh	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1665+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L1648
	ldr	r3, [sp, #8]
	movs	r6, #1
	lsr	r10, r3, #2
	b	.L1632
.L1648:
	movs	r6, #1
	mov	r10, r6
	b	.L1632
.L1636:
	movs	r3, #36
	ldr	r1, [sp, #4]
	mul	r2, r3, r8
	movs	r3, #0
	str	r3, [fp, r2]
	ldr	r3, .L1665+36
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r3, [sp]
	str	r0, [sp, #12]
	cbz	r3, .L1634
	bl	IsBlkInVendorPart
	cbnz	r0, .L1635
.L1634:
	ldr	r0, [sp, #12]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L1635
	movs	r3, #36
	mla	r1, r3, r5, fp
	ldr	r3, [sp, #12]
	add	r2, r7, r3, lsl #10
	ldr	r3, [sp, #16]
	str	r2, [r1, #4]
	str	r3, [r1, #8]
	ldr	r3, [sp, #24]
	mul	r2, r3, r5
	ldr	r3, [sp, #20]
	adds	r5, r5, #1
	uxth	r5, r5
	bic	r2, r2, #3
	add	r2, r2, r3
	str	r2, [r1, #12]
.L1635:
	add	r8, r8, #1
	b	.L1633
.L1640:
	mul	r2, r3, r8
	ldr	r1, [fp]
	add	ip, r1, r2
	ldr	r2, [r1, r2]
	cbz	r2, .L1639
	ldr	r0, [ip, #4]
	adds	r4, r4, #1
	str	r3, [sp, #12]
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
	ldr	r3, [sp, #12]
.L1639:
	add	r8, r8, #1
	b	.L1638
.L1644:
	ldr	r3, [sp]
	cbz	r3, .L1643
	mul	r3, r10, r7
	ldr	r2, [r8]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbnz	r3, .L1643
	ldr	r0, [r1, #4]
	movs	r1, #1
	ubfx	r0, r0, #10, #16
	bl	FtlFreeSysBlkQueueIn
.L1643:
	adds	r7, r7, #1
	b	.L1642
.L1647:
	movs	r4, #0
	b	.L1620
.L1666:
	.align	2
.L1665:
	.word	.LANCHOR75
	.word	.LANCHOR8
	.word	.LANCHOR76
	.word	.LANCHOR72
	.word	.LANCHOR36
	.word	.LANCHOR186
	.word	.LANCHOR57
	.word	.LANCHOR183
	.word	.LANCHOR184
	.word	.LANCHOR45
	.word	.LANCHOR52
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
	ldr	r3, .L1678
	ldr	r4, [r3]
	str	r3, [sp, #12]
	cmp	r4, #0
	bne	.L1669
	ldr	r3, .L1678+4
	mov	r1, r4
	ldr	r7, .L1678+8
	ldr	r5, .L1678+12
	ldr	r3, [r3]
	ldr	r0, [r7]
	mov	r8, r7
	ldr	r6, .L1678+16
	str	r3, [r5, #12]
	ldr	r7, .L1678+20
	ldr	r3, .L1678+24
	ldr	r10, .L1678+56
	str	r0, [r5, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
.L1670:
	ldrh	r3, [r7]
	cmp	r4, r3
	blt	.L1671
	ldr	r6, [r5, #12]
	movs	r2, #16
	ldr	r4, .L1678+28
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
	ldr	r3, .L1678+32
	ldr	r3, [r3]
	strh	r3, [r6, #12]	@ movhi
.L1672:
	ldr	r3, [r8]
	mov	fp, #0
	ldrh	r1, [r4]
	ldrh	r2, [r4, #2]
	str	r3, [r5, #8]
	ldr	r3, .L1678+4
	ldrh	r0, [r6, #10]
	str	fp, [r5]
	ldr	r3, [r3]
	str	r3, [r5, #12]
	orr	r3, r2, r1, lsl #10
	str	r3, [r5, #4]
	ldrh	r3, [r4, #4]
	str	r0, [sp]
	ldr	r0, .L1678+36
	bl	printf
	movs	r3, #1
	ldr	r0, .L1678+12
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r3, .L1678+40
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1673
	ldr	r3, [r4, #8]
	ldrh	r2, [r4]
	strh	fp, [r4, #2]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #8]
	str	r3, [r6, #4]
	strh	r2, [r6, #8]	@ movhi
	ldrh	r3, [r4, #4]
	strh	r2, [r4, #4]	@ movhi
	ldr	r2, .L1678+44
	strh	r3, [r4]	@ movhi
	lsls	r3, r3, #10
	ldr	r0, [r2]
	movs	r2, #1
	str	r3, [r5, #4]
	mov	r1, r2
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	movs	r3, #1
	ldr	r0, .L1678+12
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
.L1673:
	ldrh	r3, [r10, #2]
	adds	r3, r3, #1
	strh	r3, [r10, #2]	@ movhi
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L1674
	adds	r7, r7, #1
	ldr	r1, [r5, #4]
	uxth	r7, r7
	ldr	r0, .L1678+48
	bl	printf
	cmp	r7, #3
	bls	.L1672
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L1678+52
	bl	printf
	ldr	r2, [sp, #12]
	movs	r3, #1
	str	r3, [r2]
.L1669:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1671:
	ldrh	r2, [r10]
	ldr	r3, [r5, #8]
	ldr	r1, [r6, #4]!
	mul	r0, r4, r2
	lsls	r2, r2, #2
	adds	r4, r4, #1
	add	r0, r3, r0, lsl #2
	bl	ftl_memcpy
	b	.L1670
.L1674:
	ldr	r3, [sp, #8]
	cmp	r3, #0
	bne	.L1669
	movs	r3, #1
	str	r3, [sp, #8]
	b	.L1672
.L1679:
	.align	2
.L1678:
	.word	.LANCHOR75
	.word	.LANCHOR185
	.word	.LANCHOR79
	.word	.LANCHOR199
	.word	.LANCHOR73+24
	.word	.LANCHOR43
	.word	.LANCHOR56
	.word	.LANCHOR73
	.word	.LANCHOR35
	.word	.LC28
	.word	.LANCHOR52
	.word	.LANCHOR76
	.word	.LC29
	.word	.LC30
	.word	.LANCHOR120
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
	ldr	r3, .L1743
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L1682
	ldr	r7, .L1743+4
.L1681:
	ldr	r3, .L1743+4
	ldr	r6, .L1743+8
	ldrh	r3, [r3]
	ldrh	r2, [r6]
	add	r3, r3, r2
	ldr	r2, .L1743+12
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1683
	ldr	r1, .L1743+16
	movw	r2, #2818
	ldr	r0, .L1743+20
	bl	printf
	ldr	r1, .L1743+24
	ldr	r0, .L1743+28
	bl	printf
.L1683:
	ldr	r3, .L1743+32
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	cmp	r4, r3
	bne	.L1684
	ldr	r3, .L1743+36
	ldrh	r5, [r7]
	ldr	r3, [r3]
	lsrs	r0, r5, #1
	mul	ip, r3, r5
	adds	r1, r0, #1
	add	r1, r1, ip, lsr #2
	ldr	ip, .L1743+48
	uxth	r1, r1
	ldr	ip, [ip]
	cmp	ip, #0
	beq	.L1685
	ldr	ip, .L1743+52
	ldr	ip, [ip]
	cmp	ip, #29
	bhi	.L1685
	cmp	ip, #2
	bls	.L1718
	lsls	r5, r5, #31
	bpl	.L1714
	cmp	r3, #0
	beq	.L1718
.L1714:
	mov	r1, r0
	b	.L1685
.L1684:
	cmp	r2, #1
	bne	.L1718
	ldr	r3, .L1743+40
	ldrh	r3, [r3]
	cmp	r3, #1
	beq	.L1718
	ldr	r3, .L1743+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1718
	ldr	r0, .L1743+48
	ldrh	r3, [r7]
	ldr	r0, [r0]
	lsrs	r1, r3, #3
	cbz	r0, .L1685
	ldr	r0, .L1743+52
	ldr	r0, [r0]
	cmp	r0, #1
	bhi	.L1685
	rsb	r3, r3, r3, lsl #3
	ubfx	r1, r3, #3, #16
.L1685:
	cbz	r1, .L1686
	subs	r1, r1, #1
	uxth	r1, r1
.L1686:
	ldr	r0, .L1743+56
	bl	List_pop_index_node
	ldrh	r3, [r7]
	mov	r5, r0
	uxth	r8, r0
	cbnz	r3, .L1687
	ldr	r1, .L1743+16
	movw	r2, #2838
	ldr	r0, .L1743+20
	bl	printf
	ldr	r1, .L1743+24
	ldr	r0, .L1743+28
	bl	printf
.L1687:
	ldrh	r3, [r7]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r7]	@ movhi
	strh	r8, [r4]	@ movhi
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1688
	ldr	r3, .L1743+60
	uxth	r5, r5
	movw	r2, #65535
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	ldrh	r2, [r6]
	ldrh	r3, [r7]
	add	r3, r3, r2
	ldr	r2, .L1743+12
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1681
	movw	r2, #2850
	ldr	r1, .L1743+16
	ldr	r0, .L1743+20
	bl	printf
	ldr	r1, .L1743+24
	ldr	r0, .L1743+28
	bl	printf
	b	.L1681
.L1718:
	movs	r1, #0
	b	.L1686
.L1688:
	ldrh	r2, [r6]
	ldrh	r3, [r7]
	add	r3, r3, r2
	ldr	r2, .L1743+12
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1690
	ldr	r1, .L1743+16
	movw	r2, #2853
	ldr	r0, .L1743+20
	bl	printf
	ldr	r1, .L1743+24
	ldr	r0, .L1743+28
	bl	printf
.L1690:
	ldr	r2, .L1743+64
	movs	r6, #0
	ldr	fp, .L1743+100
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
.L1691:
	ldr	r2, [sp]
	cmp	r2, r3
	bne	.L1693
	cbnz	r6, .L1694
	ldr	r1, .L1743+16
	movw	r2, #2865
	ldr	r0, .L1743+20
	bl	printf
	ldr	r1, .L1743+24
	ldr	r0, .L1743+28
	bl	printf
.L1694:
	ldr	r3, .L1743+48
	uxth	r5, r5
	ldr	r10, .L1743+104
	ldr	r3, [r3]
	cbz	r3, .L1695
	ldr	r3, .L1743+68
	cmp	r4, r3
	bne	.L1695
	ldr	r3, [r10]
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, #30
	itt	hi
	movhi	r3, #0
	strbhi	r3, [r4, #8]
.L1695:
	ldr	r3, .L1743+72
	ldrh	r3, [r3]
	cmp	r3, r8
	bne	.L1696
	ldr	r1, .L1743+16
	movw	r2, #2872
	ldr	r0, .L1743+20
	bl	printf
	ldr	r1, .L1743+24
	ldr	r0, .L1743+28
	bl	printf
.L1696:
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	ldr	r2, .L1743+76
	ldr	r3, .L1743+80
	cmp	r1, #0
	bne	.L1697
	ldr	r0, [r10]
	ldrh	lr, [r0, r5, lsl #1]
	cmp	lr, #0
	beq	.L1698
	ldr	r1, .L1743+84
	ldrh	ip, [r1]
	add	r1, lr, ip
.L1741:
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
.L1700:
	lsls	r1, r5, #1
	ldr	r3, [r3]
	ldr	r2, [r2]
	str	r1, [sp]
	ldr	r1, [r10]
	ldrh	ip, [r1, r5, lsl #1]
	ldr	r1, .L1743+88
	ldr	r0, [r1]
	cmp	ip, r0
	it	hi
	strhi	ip, [r1]
	ldr	r1, .L1743+84
	ldrh	r0, [r1]
	ldr	r1, .L1743+12
	mla	r0, r2, r0, r3
	ldrh	r1, [r1]
	bl	__aeabi_uidiv
	ldr	r3, .L1743+92
	ldr	ip, .L1743+108
	str	r0, [r3]
	ldr	r3, .L1743+96
	ldr	r0, [fp]
	ldr	r2, [r3]
	adds	r1, r0, #4
	ldr	r3, [r2, #16]
	adds	r3, r3, #1
	str	r3, [r2, #16]
	movs	r3, #36
	mla	r3, r3, r6, r0
	adds	r3, r3, #40
.L1702:
	adds	r1, r1, #36
	cmp	r3, r1
	bne	.L1703
	ldr	r3, .L1743+44
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L1704
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	mov	r2, r6
	cmp	r3, #1
	ite	eq
	moveq	r1, #0
	movne	r1, #1
	bl	FlashEraseBlocks
.L1704:
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	mov	r2, r6
	ldr	r0, [fp]
	mov	r10, #0
	bl	FlashEraseBlocks
	mov	r3, r10
	movs	r1, #36
.L1706:
	uxth	r2, r10
	cmp	r6, r2
	bhi	.L1708
	cbz	r3, .L1709
	mov	r0, r8
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1709:
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	ldr	r1, .L1743+60
	cmp	r2, #0
	bne	.L1710
	ldr	r3, [r1]
	movw	r2, #65535
	strh	r2, [r3, r5, lsl #1]	@ movhi
	b	.L1681
.L1744:
	.align	2
.L1743:
	.word	.LANCHOR75
	.word	.LANCHOR87
	.word	.LANCHOR84
	.word	.LANCHOR38
	.word	.LANCHOR200
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR92
	.word	.LANCHOR170
	.word	.LANCHOR42
	.word	.LANCHOR8
	.word	.LANCHOR101
	.word	.LANCHOR168
	.word	.LANCHOR86
	.word	.LANCHOR82
	.word	.LANCHOR36
	.word	.LANCHOR90
	.word	.LANCHOR201
	.word	.LANCHOR165
	.word	.LANCHOR166
	.word	.LANCHOR46
	.word	.LANCHOR167
	.word	.LANCHOR202
	.word	.LANCHOR188
	.word	.LANCHOR76
	.word	.LANCHOR77
	.word	-1024
.L1693:
	ldrh	r1, [ip], #2
	str	lr, [r3, #8]
	str	lr, [r3, #12]
	cmp	r1, r10
	beq	.L1692
	ldr	r2, [sp, #4]
	lsls	r1, r1, #10
	mla	r2, r2, r6, r0
	adds	r6, r6, #1
	uxth	r6, r6
	str	r1, [r2, #4]
.L1692:
	adds	r3, r3, #36
	b	.L1691
.L1698:
	movs	r1, #2
	b	.L1741
.L1697:
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
	bl	ftl_set_blk_mode.part.9
	ldr	r2, [sp, #4]
	ldr	r3, [sp]
	b	.L1700
.L1703:
	ldr	r2, [r1, #-36]
	and	r2, r2, ip
	str	r2, [r1, #-36]
	b	.L1702
.L1708:
	ldr	r0, .L1745
	mul	r2, r1, r10
	ldr	r0, [r0]
	add	ip, r0, r2
	ldr	r2, [r0, r2]
	adds	r0, r2, #1
	bne	.L1707
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
.L1707:
	add	r10, r10, #1
	b	.L1706
.L1710:
	ldr	r3, .L1745+4
	ldr	r0, .L1745+8
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
	cbz	r3, .L1711
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1682
.L1711:
	ldr	r1, .L1745+12
	movw	r2, #2931
	ldr	r0, .L1745+16
	bl	printf
	ldr	r1, .L1745+20
	ldr	r0, .L1745+24
	bl	printf
.L1682:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1746:
	.align	2
.L1745:
	.word	.LANCHOR76
	.word	.LANCHOR51
	.word	.LANCHOR157
	.word	.LANCHOR200
	.word	.LC4
	.word	.LC5
	.word	.LC6
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
	ldr	r4, .L1759
	ldrh	r3, [r4]
	cbz	r3, .L1748
	ldr	r8, .L1759+12
	movs	r7, #0
.L1749:
	ldr	r3, .L1759+4
	ldrh	r2, [r3]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L1755
	bl	FtlGcReFreshBadBlk
.L1748:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1755:
	ldr	r2, .L1759+8
	uxth	r3, r7
	mov	r1, r10
	mov	fp, #0
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	mov	r1, r0
.L1750:
	ldrh	r3, [r4]
	uxth	r5, fp
	cmp	r3, r5
	bhi	.L1754
	adds	r7, r7, #1
	b	.L1749
.L1754:
	uxth	r6, fp
	ldrh	r3, [r8, r6, lsl #1]
	cmp	r3, r1
	bne	.L1751
	mov	r0, r1
	str	r1, [sp, #4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	r2, [r4]
	add	r3, r8, r6, lsl #1
	ldr	r1, [sp, #4]
.L1752:
	cmp	r5, r2
	bcc	.L1753
	subs	r2, r2, #1
	strh	r2, [r4]	@ movhi
.L1751:
	add	fp, fp, #1
	b	.L1750
.L1753:
	ldrh	r0, [r3, #2]!
	adds	r5, r5, #1
	uxth	r5, r5
	strh	r0, [r3, #-2]	@ movhi
	b	.L1752
.L1760:
	.align	2
.L1759:
	.word	.LANCHOR114
	.word	.LANCHOR36
	.word	.LANCHOR45
	.word	.LANCHOR115
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
	ldr	r3, .L1771
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	bne	.L1762
	ldr	r2, .L1771+4
	ldrh	r1, [r2]
	cmp	r1, r0
	bne	.L1763
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L1764:
	ldr	r5, .L1771+8
	mov	r1, r4
	ldr	r0, .L1771+12
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L1766
	ldr	r1, .L1771+16
	movw	r2, #3042
	ldr	r0, .L1771+20
	bl	printf
	ldr	r1, .L1771+24
	ldr	r0, .L1771+28
	bl	printf
.L1766:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	free_data_superblock
	mov	r0, r4
	bl	FtlGcFreeBadSuperBlk
	ldr	r3, .L1771+32
	ldrh	r2, [r5]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldr	r2, .L1771+36
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1770
	ldr	r1, .L1771+16
	movw	r2, #3045
	ldr	r0, .L1771+20
	bl	printf
	ldr	r1, .L1771+24
	ldr	r0, .L1771+28
	bl	printf
.L1770:
	movs	r3, #1
	b	.L1761
.L1763:
	ldr	r2, .L1771+40
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1761
	ldr	r2, .L1771+44
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1761
	ldr	r2, .L1771+48
	ldrh	r2, [r2]
	cmp	r2, r0
	bne	.L1764
.L1761:
	mov	r0, r3
	pop	{r3, r4, r5, pc}
.L1762:
	bl	List_update_data_list
	movs	r3, #0
	b	.L1761
.L1772:
	.align	2
.L1771:
	.word	.LANCHOR82
	.word	.LANCHOR201
	.word	.LANCHOR84
	.word	.LANCHOR81
	.word	.LANCHOR203
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR87
	.word	.LANCHOR38
	.word	.LANCHOR90
	.word	.LANCHOR91
	.word	.LANCHOR92
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
	beq	.L1774
	ldr	r5, .L1782
	ldr	r3, [r5]
	ldrh	r2, [r3, r0, lsl #1]
	cbnz	r2, .L1775
	mov	r1, r0
	ldr	r0, .L1782+4
	bl	printf
	ldr	r3, [r5]
	ldrh	r5, [r3, r4, lsl #1]
	cbz	r5, .L1776
.L1780:
	movs	r5, #0
.L1773:
	mov	r0, r5
	pop	{r4, r5, r6, pc}
.L1776:
	movw	r2, #3060
.L1781:
	ldr	r1, .L1782+8
	ldr	r0, .L1782+12
	bl	printf
	ldr	r1, .L1782+16
	ldr	r0, .L1782+20
	bl	printf
	b	.L1773
.L1775:
	subs	r2, r2, #1
	strh	r2, [r3, r0, lsl #1]	@ movhi
.L1774:
	ldr	r6, .L1782+24
	movw	r3, #65535
	ldrh	r0, [r6]
	cmp	r0, r3
	bne	.L1778
	strh	r4, [r6]	@ movhi
	b	.L1780
.L1778:
	cmp	r4, r0
	beq	.L1780
	bl	update_vpc_list
	ldr	r3, .L1782+28
	adds	r5, r0, #0
	ldr	r2, .L1782+32
	it	ne
	movne	r5, #1
	strh	r4, [r6]	@ movhi
	ldr	r3, [r3]
	ldr	r2, [r2]
	subs	r3, r3, r2
	asrs	r2, r3, #1
	ldr	r3, .L1782+36
	muls	r3, r2, r3
	ldr	r2, .L1782
	ldr	r2, [r2]
	uxth	r1, r3
	ldrh	r2, [r2, r1, lsl #1]
	cmp	r2, #0
	bne	.L1773
	cmp	r4, r1
	beq	.L1773
	movw	r2, #3082
	b	.L1781
.L1783:
	.align	2
.L1782:
	.word	.LANCHOR82
	.word	.LC31
	.word	.LANCHOR204
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR130
	.word	.LANCHOR81
	.word	.LANCHOR80
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
	beq	.L1784
	ldrh	r2, [r0]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1784
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r5, .L1795
	ldr	r6, .L1795+4
	adds	r3, r3, #8
	ldrh	r3, [r0, r3, lsl #1]
.L1788:
	movw	r2, #65535
	cmp	r3, r2
	beq	.L1790
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1791
	ldrb	r1, [r5]	@ zero_extendqisi2
	cbnz	r1, .L1791
	ldrh	r1, [r4, #2]
	ldrh	r1, [r6, r1, lsl #1]
	cmp	r1, r2
	bne	.L1791
	ldrh	r3, [r4, #4]
	ldrh	r0, [r4]
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	ldrh	r2, [r4, #4]
	cbnz	r2, .L1790
	ldrh	r3, [r4, #2]
	strb	r2, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	pop	{r4, r5, r6, pc}
.L1790:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldr	r2, .L1795+8
	adds	r3, r3, #1
	ldrh	r2, [r2]
	uxtb	r3, r3
	strb	r3, [r4, #6]
	cmp	r2, r3
	bne	.L1789
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
.L1789:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r3, [r4, r3, lsl #1]
	b	.L1788
.L1791:
	ldrb	r2, [r5]	@ zero_extendqisi2
	cbz	r2, .L1784
	cmp	r3, #1
	bne	.L1784
	ldr	r3, .L1795+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1784
	ldr	r3, .L1795+16
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	movs	r3, #0
	ldr	r2, .L1795+20
	strh	r3, [r4, #4]	@ movhi
	strb	r3, [r4, #6]
	ldrh	r2, [r2]
	strh	r2, [r4, #2]	@ movhi
.L1784:
	pop	{r4, r5, r6, pc}
.L1796:
	.align	2
.L1795:
	.word	.LANCHOR8
	.word	.LANCHOR117
	.word	.LANCHOR36
	.word	.LANCHOR52
	.word	.LANCHOR82
	.word	.LANCHOR51
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
	bne	.L1798
	ldr	r1, .L1819
	movw	r2, #2982
	ldr	r0, .L1819+4
	bl	printf
	ldr	r1, .L1819+8
	ldr	r0, .L1819+12
	bl	printf
.L1798:
	ldr	r5, .L1819+16
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L1799
	ldr	r1, .L1819
	movw	r2, #2983
	ldr	r0, .L1819+4
	bl	printf
	ldr	r1, .L1819+8
	ldr	r0, .L1819+12
	bl	printf
.L1799:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1800
	ldr	r1, .L1819
	movw	r2, #2984
	ldr	r0, .L1819+4
	bl	printf
	ldr	r1, .L1819+8
	ldr	r0, .L1819+12
	bl	printf
.L1800:
	movs	r3, #0
	ldr	r7, .L1819+20
	strb	r3, [r4, #10]
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldr	r6, .L1819+24
	adds	r3, r3, #8
	ldrh	r2, [r4, r3, lsl #1]
.L1801:
	movw	r0, #65535
	cmp	r2, r0
	beq	.L1802
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	ldrh	r1, [r4, #2]
	cmp	r3, #1
	ldrh	r3, [r4, #4]
	bne	.L1804
	ldrb	ip, [r6]	@ zero_extendqisi2
	cmp	ip, #0
	bne	.L1804
	ldr	ip, .L1819+28
	ldrh	ip, [ip, r1, lsl #1]
	cmp	ip, r0
	bne	.L1804
	subs	r3, r3, #1
	ldrh	r0, [r4]
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
.L1802:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	ldrh	r2, [r7]
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r2, r3
	strb	r3, [r4, #6]
	bne	.L1803
	ldrh	r3, [r4, #2]
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
.L1803:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r2, [r4, r3, lsl #1]
	b	.L1801
.L1804:
	ldr	r8, .L1819+24
	orr	r6, r1, r2, lsl #10
	subs	r3, r3, #1
	strh	r3, [r4, #4]	@ movhi
.L1805:
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	movw	r2, #65535
	ldrh	r0, [r7]
.L1807:
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
	beq	.L1807
	strb	r3, [r4, #6]
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L1808
	ldrb	r1, [r8]	@ zero_extendqisi2
	ldrh	r3, [r4, #2]
	cbnz	r1, .L1809
	ldr	r1, .L1819+28
	ldrh	r3, [r1, r3, lsl #1]
	cmp	r3, r2
	bne	.L1808
	ldrh	r3, [r4, #4]
	cbz	r3, .L1808
	subs	r3, r3, #1
	ldrh	r0, [r4]
	strh	r3, [r4, #4]	@ movhi
	bl	decrement_vpc_count
	b	.L1805
.L1809:
	ldr	r2, .L1819+32
	ldrh	r2, [r2]
	cmp	r3, r2
	bcc	.L1808
	ldr	r3, .L1819+36
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
.L1808:
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L1797
	ldrh	r3, [r4, #4]
	cbz	r3, .L1797
	ldr	r1, .L1819
	movw	r2, #3028
	ldr	r0, .L1819+4
	bl	printf
	ldr	r1, .L1819+8
	ldr	r0, .L1819+12
	bl	printf
.L1797:
	mov	r0, r6
	pop	{r4, r5, r6, r7, r8, pc}
.L1820:
	.align	2
.L1819:
	.word	.LANCHOR205
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR51
	.word	.LANCHOR36
	.word	.LANCHOR8
	.word	.LANCHOR117
	.word	.LANCHOR52
	.word	.LANCHOR82
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
	ldr	r3, .L1841
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r1, [r3]
	str	r3, [sp]
	cmp	r1, #0
	bne	.L1823
	ldr	r3, .L1841+4
	ldr	r7, .L1841+8
	ldr	r8, .L1841+104
	ldr	r4, .L1841+12
	ldr	r6, [r7]
	ldr	r0, [r8]
	ldrh	r2, [r3]
	str	r6, [r4, #12]
	str	r0, [r4, #8]
	strh	r2, [r6, #2]	@ movhi
	movw	r2, #61604
	ldr	r5, .L1841+16
	strh	r2, [r6]	@ movhi
	ldr	r2, [r3, #8]
	ldrh	r3, [r3, #6]
	str	r1, [r6, #8]
	str	r2, [r6, #4]
	strh	r3, [r5, #8]	@ movhi
	ldr	r3, .L1841+20
	ldr	ip, .L1841+108
	ldr	r2, .L1841+24
	ldrh	r3, [r3]
	str	r1, [r6, #12]
	stm	r5, {r2, ip}
	strb	r3, [r5, #10]
	ldr	r3, .L1841+28
	ldrh	r2, [r3]
	ldrh	r1, [r3, #2]
	strh	r2, [r5, #14]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r5, #11]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L1841+32
	strh	r2, [r5, #16]	@ movhi
	ldrh	r2, [r3]
	ldrh	r1, [r3, #2]
	strh	r2, [r5, #18]	@ movhi
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r5, #12]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L1841+36
	strh	r2, [r5, #20]	@ movhi
	ldrh	r2, [r3]
	strh	r2, [r5, #22]	@ movhi
	ldrh	r1, [r3, #2]
	ldrb	r2, [r3, #6]	@ zero_extendqisi2
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	strb	r3, [r5, #13]
	orr	r2, r2, r1, lsl #6
	ldr	r3, .L1841+40
	movs	r1, #255
	strh	r2, [r5, #24]	@ movhi
	ldr	r3, [r3]
	str	r3, [r5, #32]
	ldr	r3, .L1841+44
	ldr	r3, [r3]
	str	r3, [r5, #40]
	ldr	r3, .L1841+48
	ldr	r3, [r3]
	str	r3, [r5, #36]
	ldr	r3, .L1841+52
	ldrh	r2, [r3]
	bl	ftl_memset
	mov	r1, r5
	ldr	r5, .L1841+56
	movs	r2, #48
	ldr	r0, [r4, #8]
	bl	ftl_memcpy
	ldrh	r2, [r5]
	ldr	r3, .L1841+60
	ldr	r0, [r4, #8]
	ldr	r1, [r3]
	lsls	r2, r2, #1
	adds	r0, r0, #48
	bl	ftl_memcpy
	ldrh	r0, [r5]
	ldr	r3, [r4, #8]
	ldr	r1, .L1841+64
	lsrs	r2, r0, #3
	adds	r0, r0, #24
	lsls	r0, r0, #1
	ldr	r1, [r1]
	adds	r2, r2, #4
	bic	r0, r0, #3
	add	r0, r0, r3
	bl	ftl_memcpy
	ldr	r3, .L1841+68
	str	r7, [sp, #4]
	ldrh	r3, [r3]
	cbz	r3, .L1824
	ldrh	r0, [r5]
	ldr	r3, .L1841+72
	ldr	r1, .L1841+76
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
.L1824:
	ldr	r5, .L1841+4
	movs	r7, #0
	movw	fp, #65535
	movs	r0, #0
	bl	FtlUpdateVaildLpn
	mov	r10, r5
.L1825:
	ldr	r3, [r8]
	ldrh	r2, [r5]
	ldr	r0, .L1841+12
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
	ldr	r3, .L1841+80
	ldrh	r2, [r5, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1826
	ldrh	r3, [r5]
	ldrh	fp, [r5, #4]
	strh	r3, [r5, #4]	@ movhi
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r2, .L1841+44
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
	ldr	r0, .L1841+12
	bl	FlashProgPages
.L1826:
	ldrh	r3, [r10, #2]
	ldr	r2, [r4]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r1, r2, #1
	strh	r3, [r10, #2]	@ movhi
	bne	.L1827
	cmp	r3, #1
	bne	.L1828
	ldr	r1, .L1841+84
	movw	r2, #1180
	ldr	r0, .L1841+88
	bl	printf
	ldr	r1, .L1841+92
	ldr	r0, .L1841+96
	bl	printf
.L1828:
	ldrh	r3, [r10, #2]
	adds	r7, r7, #1
	uxth	r7, r7
	cmp	r3, #1
	itttt	eq
	ldreq	r3, .L1841+80
	ldrheq	r3, [r3]
	addeq	r3, r3, #-1
	strheq	r3, [r10, #2]	@ movhi
	cmp	r7, #3
	bls	.L1825
	mov	r2, r7
	ldr	r1, [r4, #4]
	ldr	r0, .L1841+100
	bl	printf
	ldr	r2, [sp]
	movs	r3, #1
	str	r3, [r2]
.L1823:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1827:
	cmp	r3, #1
	beq	.L1825
	cmp	r2, #256
	beq	.L1825
	movw	r3, #65535
	cmp	fp, r3
	beq	.L1823
	movs	r1, #1
	mov	r0, fp
	bl	FtlFreeSysBlkQueueIn
	b	.L1823
.L1842:
	.align	2
.L1841:
	.word	.LANCHOR75
	.word	.LANCHOR206
	.word	.LANCHOR185
	.word	.LANCHOR199
	.word	.LANCHOR135
	.word	.LANCHOR43
	.word	1179929683
	.word	.LANCHOR90
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR165
	.word	.LANCHOR157
	.word	.LANCHOR158
	.word	.LANCHOR56
	.word	.LANCHOR38
	.word	.LANCHOR82
	.word	.LANCHOR0
	.word	.LANCHOR68
	.word	.LANCHOR65
	.word	.LANCHOR128
	.word	.LANCHOR52
	.word	.LANCHOR207
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC32
	.word	.LANCHOR79
	.word	1342177351
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
	ldr	r3, .L1858
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	sub	sp, sp, #40
	ldrb	r5, [r3]	@ zero_extendqisi2
	cbz	r5, .L1857
	ldrb	r5, [r0, #8]	@ zero_extendqisi2
	cmp	r5, #1
	bne	.L1852
	ldrh	r6, [r0, #4]
.L1844:
	ldr	r7, .L1858+4
	ldr	r8, .L1858+20
.L1845:
	adds	r6, r6, #-1
	bcc	.L1847
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1846
.L1847:
	ldr	r3, .L1858+8
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldr	r3, .L1858+12
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1852:
	movs	r5, #0
.L1857:
	movs	r6, #12
	b	.L1844
.L1846:
	mov	r0, r4
	bl	get_new_active_ppa
	str	r0, [sp, #8]
	adds	r0, r0, #1
	beq	.L1847
	ldr	r1, [r8]
	mov	r3, #-1
	ldr	r2, [r7]
	ldr	r0, .L1858+16
	str	r3, [sp, #20]
	str	r1, [sp, #16]
	str	r2, [sp, #12]
	str	r3, [r1, #12]
	ldr	r2, [r0]
	str	r3, [r1, #8]
	ldrh	r3, [r4]
	str	r2, [r1, #4]
	adds	r2, r2, #1
	strh	r3, [r1, #2]	@ movhi
	movs	r3, #0
	strh	r3, [r1]	@ movhi
	adds	r1, r2, #1
	it	eq
	moveq	r2, r3
	movs	r1, #1
	str	r2, [r0]
	mov	r2, r5
	add	r0, sp, #4
	bl	FlashProgPages
	ldrh	r0, [r4]
	bl	decrement_vpc_count
	b	.L1845
.L1859:
	.align	2
.L1858:
	.word	.LANCHOR8
	.word	.LANCHOR79
	.word	.LANCHOR82
	.word	.LANCHOR51
	.word	.LANCHOR158
	.word	.LANCHOR185
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
	ldr	r3, .L1870
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r5, .L1870+4
	ldr	r3, [r3]
	ldr	r7, .L1870+8
	ldr	r10, .L1870+20
	str	r3, [r5, #8]
	ldr	r3, .L1870+12
	ldr	r8, [r3]
	str	r8, [r5, #12]
.L1861:
	ldr	r3, .L1870+16
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L1866
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1866:
	ldrh	r4, [r10]
	movw	r3, #65535
	ldr	fp, .L1870+4
	strh	r3, [r7, #2]!	@ movhi
	subs	r4, r4, #1
	uxth	r4, r4
.L1862:
	ldrh	r3, [r10]
	sub	r2, r3, #15
	cmp	r2, r4
	bgt	.L1864
	mla	r3, r6, r3, r4
	movs	r2, #1
	mov	r1, r2
	mov	r0, fp
	lsls	r3, r3, #10
	str	r3, [r5, #4]
	bl	FlashReadPages
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L1863
	ldrh	r2, [r8]
	movw	r3, #61664
	cmp	r2, r3
	bne	.L1863
	strh	r4, [r7]	@ movhi
.L1864:
	adds	r6, r6, #1
	b	.L1861
.L1863:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L1862
.L1871:
	.align	2
.L1870:
	.word	.LANCHOR79
	.word	.LANCHOR199
	.word	.LANCHOR73+10
	.word	.LANCHOR185
	.word	.LANCHOR43
	.word	.LANCHOR49
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
	ldreq	r3, .L1884
	sub	sp, sp, #104
	lsl	r7, r0, #10
	mov	r2, r1
	it	ne
	ldrne	r3, .L1884+4
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
	bne	.L1875
.L1876:
	cmp	r6, r5
	ble	.L1879
.L1875:
	mov	r0, r5
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1879:
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
	bne	.L1877
	ldr	r3, [sp, #44]
	adds	r3, r3, #1
	bne	.L1877
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L1877
	subs	r4, r4, #1
	sxth	r5, r4
	b	.L1876
.L1877:
	adds	r4, r4, #1
	sxth	r6, r4
	b	.L1876
.L1885:
	.align	2
.L1884:
	.word	.LANCHOR52
	.word	.LANCHOR51
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
	movs	r3, #0
	ldr	r4, .L1915
	ldr	r7, .L1915+4
	str	r3, [r4, #8]
	mov	r8, r4
	ldr	r3, .L1915+8
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FtlBbtMemInit
	ldrh	r5, [r7]
	subs	r5, r5, #1
	uxth	r5, r5
.L1887:
	ldrh	r3, [r7]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L1890
	lsls	r3, r5, #10
	movs	r2, #1
	mov	r1, r2
	mov	r0, r8
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1888
	ldr	r3, [r4, #4]
	movs	r2, #1
	mov	r1, r2
	mov	r0, r8
	adds	r3, r3, #1
	str	r3, [r4, #4]
	bl	FlashReadPages
.L1888:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L1889
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L1889
	ldr	r3, .L1915+12
	ldr	r2, [r6, #4]
	strh	r5, [r3]	@ movhi
	str	r2, [r3, #8]
	ldrh	r2, [r6, #8]
	strh	r2, [r3, #4]	@ movhi
.L1890:
	ldr	r5, .L1915+12
	movw	r2, #65535
	ldrh	r3, [r5]
	cmp	r3, r2
	beq	.L1904
	ldrh	r3, [r5, #4]
	cmp	r3, r2
	beq	.L1894
	lsls	r3, r3, #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L1915
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L1894
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L1894
	ldr	r3, [r6, #4]
	ldr	r2, [r5, #8]
	cmp	r3, r2
	bls	.L1894
	ldrh	r2, [r5, #4]
	str	r3, [r5, #8]
	ldrh	r3, [r6, #8]
	strh	r2, [r5]	@ movhi
	strh	r3, [r5, #4]	@ movhi
.L1894:
	ldr	r8, .L1915+48
	movs	r1, #1
	ldr	r10, .L1915
	ldrh	r0, [r5]
	bl	FtlGetLastWrittenPage
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r5, #2]	@ movhi
.L1896:
	cmp	r7, #0
	bge	.L1899
	ldr	r1, .L1915+16
	mov	r2, #336
	ldr	r0, .L1915+20
	bl	printf
	ldr	r1, .L1915+24
	ldr	r0, .L1915+28
	bl	printf
.L1898:
	ldrh	r3, [r6, #10]
	ldrh	r0, [r6, #12]
	strh	r3, [r5, #6]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L1901
	ldr	r3, .L1915+32
	ldr	r2, [r3]
	cmp	r0, r2
	beq	.L1901
	ldr	r3, .L1915+36
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	cmp	r2, r3
	bcs	.L1901
	cmp	r0, r3
	bcs	.L1901
	bl	FtlSysBlkNumInit
.L1901:
	ldr	r6, .L1915+40
	movs	r5, #0
	ldr	r7, .L1915+44
	ldr	r8, .L1915+52
.L1902:
	ldrh	r3, [r7]
	cmp	r5, r3
	bcc	.L1903
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1889:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L1887
.L1899:
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
	beq	.L1897
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	beq	.L1898
.L1897:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L1896
.L1903:
	ldrh	r2, [r8]
	ldr	r1, [r4, #8]
	ldr	r0, [r6, #4]!
	lsls	r2, r2, #2
	mla	r1, r5, r2, r1
	adds	r5, r5, #1
	bl	ftl_memcpy
	b	.L1902
.L1904:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1916:
	.align	2
.L1915:
	.word	.LANCHOR199
	.word	.LANCHOR49
	.word	.LANCHOR185
	.word	.LANCHOR73
	.word	.LANCHOR208
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR35
	.word	.LANCHOR39
	.word	.LANCHOR73+24
	.word	.LANCHOR43
	.word	.LANCHOR79
	.word	.LANCHOR120
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
	ldrh	ip, [r4, #10]
	ldrh	r2, [r4, #8]
	ldrh	r1, [r4, #40]
	sub	r3, ip, #4
	ldr	r6, .L1937
	cmp	r2, r3
	bge	.L1918
	movw	r3, #65535
	cmp	r1, r3
	beq	.L1920
	ldrh	r2, [r4, #2]
	ldrh	r3, [r6]
	cmp	r2, r3
	bcc	.L1921
.L1918:
	movw	r3, #65535
	uxth	r0, r0
	cmp	r1, r3
	beq	.L1922
	ldrh	r3, [r4, #2]
	ldrh	r2, [r6]
	cmp	r2, r3
	bls	.L1923
.L1922:
	ldrh	r8, [r5, r0, lsl #1]
	lsls	r2, r0, #1
	cmp	r8, #0
	beq	.L1920
	ldr	r3, [r4, #32]
	cbnz	r3, .L1920
	movs	r1, #1
	str	r1, [r4, #32]
	strh	r3, [r5, r2]	@ movhi
	ldrh	r3, [r4, #8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	ldrh	r3, [r6]
	cmp	r2, r3
	bcc	.L1928
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L1928:
	ldr	r5, .L1937+4
	movs	r7, #0
.L1929:
	ldrh	r2, [r4, #6]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L1933
	movs	r1, #1
	mov	r0, r8
	bl	FtlFreeSysBlkQueueIn
	movs	r3, #0
	str	r3, [r4, #32]
.L1920:
	ldrh	r2, [r4, #2]
	ldrh	r3, [r6]
	cmp	r2, r3
	bcc	.L1921
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L1921:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1926:
	ldrh	r8, [r5, r2, lsl #1]
	add	lr, r2, #1
	cmp	r8, r1
	beq	.L1924
	mov	r2, lr
.L1925:
	uxth	r7, r2
	cmp	r7, ip
	bcc	.L1926
	mov	r7, r0
.L1924:
	uxth	r2, r2
	ldr	r0, .L1937+8
	ldrh	r2, [r5, r2, lsl #1]
	bl	printf
	movw	r3, #65535
	mov	r0, r7
	strh	r3, [r4, #40]	@ movhi
	b	.L1922
.L1923:
	movs	r2, #0
	b	.L1925
.L1933:
	ldr	r2, [sp]
	uxth	r10, r7
	ldr	r2, [r2, r10, lsl #2]
	cmp	r8, r2, lsr #10
	bne	.L1930
	str	r3, [sp, #4]
	ldr	r3, .L1937+12
	str	r2, [r5, #4]
	movs	r2, #1
	ldr	r0, .L1937+4
	ldr	r1, [r3]
	str	r1, [r5, #8]
	ldr	r1, .L1937+16
	ldr	fp, [r1]
	mov	r1, r2
	str	fp, [r5, #12]
	bl	FlashReadPages
	ldrh	r2, [fp, #8]
	ldr	r3, [sp, #4]
	cmp	r2, r3
	beq	.L1931
	ldr	r1, .L1937+20
	movw	r2, #638
	ldr	r0, .L1937+24
	bl	printf
	ldr	r1, .L1937+28
	ldr	r0, .L1937+32
	bl	printf
.L1931:
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L1932
	ldr	r2, [sp]
	movs	r3, #0
	ldr	r0, .L1937+36
	str	r3, [r2, r10, lsl #2]
	ldrh	r2, [fp, #8]
	ldr	r1, [r5, #4]
	bl	printf
	ldr	r3, .L1937+40
	movs	r2, #1
	str	r2, [r3]
.L1930:
	adds	r7, r7, #1
	b	.L1929
.L1932:
	ldr	r2, [r5, #8]
	mov	r1, r10
	mov	r0, r4
	bl	FtlMapWritePage
	b	.L1930
.L1938:
	.align	2
.L1937:
	.word	.LANCHOR52
	.word	.LANCHOR199
	.word	.LC33
	.word	.LANCHOR181
	.word	.LANCHOR185
	.word	.LANCHOR209
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC34
	.word	.LANCHOR75
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
	ldr	r3, .L1949
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, r0
	ldr	r5, [r3]
	cbnz	r5, .L1940
	ldrh	r3, [r0]
	movw	r2, #65535
	ldr	r6, [r0, #12]
	cmp	r3, r2
	bne	.L1941
	ldrh	r3, [r0, #8]
	cbz	r3, .L1942
	ldr	r1, .L1949+4
	movw	r2, #670
	ldr	r0, .L1949+8
	bl	printf
	ldr	r1, .L1949+12
	ldr	r0, .L1949+16
	bl	printf
.L1942:
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
.L1940:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, pc}
.L1941:
	ldrh	r6, [r6, r3, lsl #1]
	movs	r1, #255
	ldrh	r3, [r0, #2]
	ldr	r2, .L1949+20
	ldr	r8, .L1949+32
	ldr	r7, [r0, #24]
	orr	r3, r3, r6, lsl #10
	ldr	r0, [r8]
	str	r3, [r2, #4]
	ldr	r3, .L1949+24
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
	ldr	r3, .L1949+28
	ldrh	r2, [r3]
	lsls	r2, r2, #3
	bl	ftl_memset
	ldrh	ip, [r4, #6]
	mov	r3, r5
	ldr	r1, [r8]
	mov	r2, r5
.L1943:
	uxth	r0, r3
	cmp	ip, r0
	bhi	.L1945
	movs	r2, #1
	movs	r3, #0
	mov	r1, r2
	ldr	r0, .L1949+20
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	mov	r0, r4
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	bl	ftl_map_blk_gc
	b	.L1940
.L1945:
	ldr	r0, [r7, r3, lsl #2]
	cmp	r6, r0, lsr #10
	bne	.L1944
	adds	r2, r2, #1
	uxth	r2, r2
	str	r3, [r1, r2, lsl #3]
	add	r5, r1, r2, lsl #3
	ldr	r0, [r7, r3, lsl #2]
	str	r0, [r5, #4]
.L1944:
	adds	r3, r3, #1
	b	.L1943
.L1950:
	.align	2
.L1949:
	.word	.LANCHOR75
	.word	.LANCHOR210
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR199
	.word	.LANCHOR185
	.word	.LANCHOR52
	.word	.LANCHOR79
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
	ldr	r3, .L1974
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	mov	r8, r1
	str	r2, [sp]
	ldr	r5, [r3]
	str	r3, [sp, #4]
	cmp	r5, #0
	bne	.L1969
	ldr	r10, .L1974+36
.L1953:
	ldr	r2, .L1974+4
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	ldrh	r3, [r10]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L1954
	ldrh	r2, [r4]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1955
.L1954:
	mov	r0, r4
	bl	Ftl_write_map_blk_to_last_page
.L1955:
	ldrh	r2, [r4]
	ldr	r3, [r4, #12]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L1956
	ldr	r1, .L1974+8
	movw	r2, #731
	ldr	r0, .L1974+12
	bl	printf
	ldr	r1, .L1974+16
	ldr	r0, .L1974+20
	bl	printf
.L1956:
	ldrh	r2, [r4]
	ldrh	r3, [r4, #10]
	cmp	r2, r3
	bcc	.L1957
	ldr	r1, .L1974+8
	mov	r2, #732
	ldr	r0, .L1974+12
	bl	printf
	ldr	r1, .L1974+16
	ldr	r0, .L1974+20
	bl	printf
.L1957:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r4, #12]
	ldr	r6, .L1974+24
	ldrh	r7, [r3, r2, lsl #1]
	movs	r2, #16
	ldrh	r3, [r4, #2]
	mov	fp, r6
	orr	r3, r3, r7, lsl #10
	str	r3, [r6, #4]
	ldr	r3, [sp]
	str	r3, [r6, #8]
	ldr	r3, .L1974+28
	ldr	r0, [r3]
	str	r0, [r6, #12]
	bl	ftl_memset
	ldr	r3, [r6, #12]
	mov	r0, r6
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
	ldr	r1, [r6]
	adds	r2, r2, #1
	uxth	r2, r2
	adds	r3, r1, #1
	strh	r2, [r4, #2]	@ movhi
	bne	.L1958
	ldr	r1, [r6, #4]
	adds	r5, r5, #1
	ldr	r0, .L1974+32
	uxth	r5, r5
	bl	printf
	ldrh	r2, [r4, #2]
	cmp	r2, #2
	itttt	ls
	ldrls	r3, .L1974+36
	ldrhls	r2, [r3]
	addls	r2, r2, #-1
	strhls	r2, [r4, #2]	@ movhi
	cmp	r5, #3
	bls	.L1953
	mov	r2, r5
	ldr	r1, [r6, #4]
	ldr	r0, .L1974+40
	bl	printf
	ldr	r2, [sp, #4]
	movs	r3, #1
	str	r3, [r2]
.L1969:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1958:
	cbz	r1, .L1961
	cmp	r2, #1
	strh	r7, [r4, #40]	@ movhi
	beq	.L1953
	cmp	r1, #256
.L1973:
	beq	.L1953
	ldr	r2, [fp, #4]
	ldr	r3, [r4, #24]
	str	r2, [r3, r8, lsl #2]
	b	.L1969
.L1961:
	cmp	r2, #1
	b	.L1973
.L1975:
	.align	2
.L1974:
	.word	.LANCHOR75
	.word	.LANCHOR163
	.word	.LANCHOR211
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR199
	.word	.LANCHOR185
	.word	.LC35
	.word	.LANCHOR52
	.word	.LC36
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
	ldr	r5, .L1977
	muls	r4, r0, r4
	ldr	r0, .L1977+4
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
.L1978:
	.align	2
.L1977:
	.word	.LANCHOR95
	.word	.LANCHOR124
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
	ldr	r5, .L1983
	ldr	r6, .L1983+4
.L1980:
	ldrh	r3, [r5]
	uxth	r0, r4
	cmp	r3, r0
	bhi	.L1982
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L1982:
	ldr	r2, [r6]
	uxth	r3, r4
	movs	r1, #12
	mla	r3, r1, r3, r2
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L1981
	bl	flush_l2p_region
.L1981:
	adds	r4, r4, #1
	b	.L1980
.L1984:
	.align	2
.L1983:
	.word	.LANCHOR66
	.word	.LANCHOR95
	.size	l2p_flush, .-l2p_flush
	.section	.text.load_l2p_region,"ax",%progbits
	.align	1
	.global	load_l2p_region
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	load_l2p_region, %function
load_l2p_region:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r7, r0
	ldr	r3, .L1991
	mov	r10, r1
	ldrh	r3, [r3]
	cmp	r3, r0
	bcs	.L1986
	ldr	r1, .L1991+4
	movw	r2, #503
	ldr	r0, .L1991+8
	bl	printf
	ldr	r1, .L1991+12
	ldr	r0, .L1991+16
	bl	printf
.L1986:
	ldr	r3, .L1991+20
	movs	r4, #12
	ldr	r8, .L1991+44
	ldr	r3, [r3]
	ldr	r5, [r3, r7, lsl #2]
	cbnz	r5, .L1987
	mul	r4, r4, r10
	ldr	r3, [r8]
	ldr	r2, .L1991+24
	movs	r1, #255
	add	r3, r3, r4
	ldrh	r2, [r2]
	ldr	r0, [r3, #8]
	bl	ftl_memset
	ldr	r3, [r8]
	adds	r2, r3, r4
	strh	r7, [r3, r4]	@ movhi
	str	r5, [r2, #4]
.L1988:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1987:
	mul	r4, r4, r10
	ldr	r3, [r8]
	ldr	r6, .L1991+28
	movs	r2, #1
	mov	r1, r2
	add	r3, r3, r4
	mov	r0, r6
	ldr	r3, [r3, #8]
	str	r5, [r6, #4]
	str	r3, [r6, #8]
	ldr	r3, .L1991+32
	ldr	r3, [r3]
	str	r3, [r6, #12]
	bl	FlashReadPages
	ldr	r3, [r6]
	ldr	r10, [r6, #12]
	cmp	r3, #256
	bne	.L1989
	mov	r2, r5
	mov	r1, r7
	ldr	r0, .L1991+36
	lsrs	r5, r5, #10
	bl	printf
	ldr	r3, [r8]
	mov	r1, r7
	ldr	r0, .L1991+40
	add	r3, r3, r4
	ldr	r2, [r3, #8]
	strh	r5, [r0, #40]	@ movhi
	bl	FtlMapWritePage
.L1989:
	ldrh	r3, [r10, #8]
	cmp	r3, r7
	beq	.L1990
	ldr	r1, .L1991+4
	movw	r2, #529
	ldr	r0, .L1991+8
	bl	printf
	ldr	r1, .L1991+12
	ldr	r0, .L1991+16
	bl	printf
.L1990:
	ldr	r3, [r8]
	movs	r1, #0
	adds	r2, r3, r4
	str	r1, [r2, #4]
	strh	r7, [r3, r4]	@ movhi
	b	.L1988
.L1992:
	.align	2
.L1991:
	.word	.LANCHOR65
	.word	.LANCHOR212
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR128
	.word	.LANCHOR56
	.word	.LANCHOR199
	.word	.LANCHOR185
	.word	.LC37
	.word	.LANCHOR124
	.word	.LANCHOR95
	.size	load_l2p_region, .-load_l2p_region
	.section	.text.log2phys,"ax",%progbits
	.align	1
	.global	log2phys
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	log2phys, %function
log2phys:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2007
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r1
	mov	r10, r2
	ldrh	r4, [r3]
	adds	r3, r4, #7
	movs	r4, #1
	lsr	r8, r0, r3
	lsls	r4, r4, r3
	ldr	r3, .L2007+4
	subs	r4, r4, #1
	uxth	r8, r8
	ands	r4, r4, r0
	ldr	r3, [r3]
	uxth	r4, r4
	cmp	r0, r3
	bcc	.L1994
	ldr	r1, .L2007+8
	movw	r2, #851
	ldr	r0, .L2007+12
	bl	printf
	ldr	r1, .L2007+16
	ldr	r0, .L2007+20
	bl	printf
.L1994:
	ldr	r6, .L2007+24
	mov	fp, #12
	ldr	r3, .L2007+28
	ldr	r1, [r6]
	ldrh	r2, [r3]
	movs	r3, #0
.L1995:
	uxth	r5, r3
	cmp	r5, r2
	bcc	.L2000
	bl	select_l2p_ram_region
	mul	fp, fp, r0
	ldr	r3, [r6]
	mov	r5, r0
	ldrh	r1, [r3, fp]
	add	r2, r3, fp
	movw	r3, #65535
	cmp	r1, r3
	beq	.L2001
	ldr	r3, [r2, #4]
	cmp	r3, #0
	bge	.L2001
	bl	flush_l2p_region
.L2001:
	mov	r1, r5
	mov	r0, r8
	bl	load_l2p_region
	b	.L1996
.L2000:
	adds	r3, r3, #1
	mla	r0, fp, r3, r1
	ldrh	r0, [r0, #-12]
	cmp	r0, r8
	bne	.L1995
.L1996:
	ldr	r2, [r6]
	movs	r3, #12
	mla	r3, r3, r5, r2
	cmp	r10, #0
	bne	.L1997
	ldr	r3, [r3, #8]
	ldr	r3, [r3, r4, lsl #2]
	str	r3, [r7]
.L1998:
	ldr	r2, [r6]
	movs	r3, #12
	mla	r5, r3, r5, r2
	ldr	r3, [r5, #4]
	adds	r2, r3, #1
	beq	.L2004
	adds	r3, r3, #1
	str	r3, [r5, #4]
.L2004:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1997:
	ldr	r1, [r7]
	ldr	r2, [r3, #8]
	str	r1, [r2, r4, lsl #2]
	ldr	r2, [r3, #4]
	orr	r2, r2, #-2147483648
	str	r2, [r3, #4]
	ldr	r3, .L2007+32
	strh	r8, [r3]	@ movhi
	b	.L1998
.L2008:
	.align	2
.L2007:
	.word	.LANCHOR55
	.word	.LANCHOR71
	.word	.LANCHOR213
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR95
	.word	.LANCHOR66
	.word	.LANCHOR96
	.size	log2phys, .-log2phys
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
	ldr	r5, .L2019
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r2, [r5]
	mov	r7, r0
	ldrh	r3, [r2, r0, lsl #1]
	cmp	r3, #0
	bne	.L2010
	ldr	r2, .L2019+4
	ldr	r4, [r2]
	cmp	r4, #0
	beq	.L2011
	ldr	r2, .L2019+8
	movw	lr, #65535
	ldr	ip, .L2019+32
	ldr	r0, .L2019+12
	ldr	r2, [r2]
	ldrh	r1, [r0]
	mov	r8, r0
	subs	r4, r4, r2
	asrs	r4, r4, #1
	mul	r4, ip, r4
	mov	ip, #6
	uxth	r4, r4
.L2012:
	uxth	r0, r3
	cmp	r1, r0
	bls	.L2011
	cmp	r4, r7
	bne	.L2013
	mov	r1, r4
	ldr	r0, .L2019+4
	bl	List_remove_node
	ldrh	r3, [r8]
	cbnz	r3, .L2014
	ldr	r1, .L2019+16
	movw	r2, #1823
	ldr	r0, .L2019+20
	bl	printf
	ldr	r1, .L2019+24
	ldr	r0, .L2019+28
	bl	printf
.L2014:
	ldrh	r3, [r8]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r8]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r2, [r5]
	ldrh	r3, [r2, r7, lsl #1]
.L2010:
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	b	.L2011
.L2013:
	mul	r4, ip, r4
	adds	r3, r3, #1
	ldrh	r4, [r2, r4]
	cmp	r4, lr
	bne	.L2012
.L2011:
	movs	r2, #1
	add	r1, sp, #4
	mov	r0, r6
	bl	log2phys
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2020:
	.align	2
.L2019:
	.word	.LANCHOR82
	.word	.LANCHOR86
	.word	.LANCHOR80
	.word	.LANCHOR87
	.word	.LANCHOR214
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	-1431655765
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
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
	ldr	r3, .L2033
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	str	r2, [sp]
	adds	r2, r0, r1
	mov	r7, r0
	mov	r5, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L2029
	ldr	r3, .L2033+4
	mov	r8, #0
	ldrh	r6, [r3]
	lsr	r6, r0, r6
	lsl	fp, r6, #2
.L2023:
	cbnz	r5, .L2028
.L2021:
	mov	r0, r8
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2028:
	ldr	r3, .L2033+8
	mov	r0, r7
	ldr	r10, .L2033+24
	ldr	r3, [r3]
	ldr	r2, [r3, fp]
	ldr	r3, .L2033+12
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
	cbz	r2, .L2025
	cmp	r4, r3
	beq	.L2025
	ldr	r3, [r10]
	add	r0, sp, #20
	str	r2, [sp, #24]
	movs	r2, #1
	mov	r1, r2
	str	r3, [sp, #28]
	movs	r3, #0
	str	r3, [sp, #32]
	bl	FlashReadPages
.L2026:
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
	ldr	r0, .L2033+16
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
	b	.L2023
.L2025:
	ldr	r3, .L2033+20
	movs	r1, #0
	ldr	r0, [r10]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L2026
.L2029:
	mov	r8, #-1
	b	.L2021
.L2034:
	.align	2
.L2033:
	.word	.LANCHOR48
	.word	.LANCHOR55
	.word	.LANCHOR191
	.word	.LANCHOR54
	.word	.LANCHOR215
	.word	.LANCHOR56
	.word	.LANCHOR182
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
	ldr	r2, .L2037
	ldr	r3, .L2037+4
	ldr	r1, [r2]
	cmp	r1, r3
	bne	.L2035
	ldr	r3, .L2037+8
	movs	r1, #1
	movs	r0, #0
	str	r3, [r2, #4]
	ldr	r3, .L2037+12
	ldr	r3, [r3]
	str	r3, [r2, #88]
	ldr	r3, .L2037+16
	ldr	r3, [r3]
	str	r3, [r2, #92]
	ldr	r3, .L2037+20
	ldr	r3, [r3]
	str	r3, [r2, #8]
	ldr	r3, .L2037+24
	ldr	r3, [r3]
	str	r3, [r2, #12]
	ldr	r3, .L2037+28
	ldr	r3, [r3]
	str	r3, [r2, #16]
	ldr	r3, .L2037+32
	ldr	r3, [r3]
	str	r3, [r2, #20]
	ldr	r3, .L2037+36
	ldr	r3, [r3]
	str	r3, [r2, #28]
	ldr	r3, .L2037+40
	ldr	r3, [r3]
	str	r3, [r2, #32]
	ldr	r3, .L2037+44
	ldr	r3, [r3]
	str	r3, [r2, #36]
	ldr	r3, .L2037+48
	ldr	r3, [r3]
	str	r3, [r2, #40]
	ldr	r3, .L2037+52
	ldr	r3, [r3]
	str	r3, [r2, #44]
	ldr	r3, .L2037+56
	ldr	r3, [r3]
	str	r3, [r2, #48]
	ldr	r3, .L2037+60
	ldr	r3, [r3]
	str	r3, [r2, #60]
	ldr	r3, .L2037+64
	ldr	r3, [r3]
	str	r3, [r2, #64]
	b	FtlVendorPartWrite
.L2035:
	bx	lr
.L2038:
	.align	2
.L2037:
	.word	.LANCHOR136
	.word	1179929683
	.word	1342177351
	.word	.LANCHOR216
	.word	.LANCHOR217
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR164
	.word	.LANCHOR163
	.word	.LANCHOR166
	.word	.LANCHOR78
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR167
	.word	.LANCHOR168
	.word	.LANCHOR156
	.word	.LANCHOR155
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
	ldr	r3, .L2046
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L2044
	ldr	r3, .L2046+4
	ldr	r3, [r3]
	cmp	r3, #29
	ite	hi
	movhi	r3, #32
	movls	r3, #4
.L2040:
	ldr	r1, .L2046+8
	ldrh	r2, [r1]
	cmp	r2, #31
	ittt	ls
	addls	r2, r2, #1
	movls	r3, #1
	strhls	r2, [r1]	@ movhi
	ldr	r2, .L2046+12
	cbnz	r0, .L2042
	ldr	r1, [r2]
	ldr	r0, [r1, #20]
	ldr	r1, [r1, #16]
	add	r3, r3, r0
	cmp	r1, r3
	bcc	.L2043
.L2042:
	ldr	r2, [r2]
	movs	r0, #64
	ldr	r3, [r2, #16]
	str	r3, [r2, #20]
	ldr	r3, .L2046+16
	str	r3, [r2]
	ldr	r3, .L2046+20
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
.L2043:
	movs	r0, #0
	pop	{r3, pc}
.L2044:
	movs	r3, #32
	b	.L2040
.L2047:
	.align	2
.L2046:
	.word	.LANCHOR101
	.word	.LANCHOR168
	.word	.LANCHOR218
	.word	.LANCHOR188
	.word	1112818501
	.word	.LANCHOR187
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
	ldr	r3, .L2075
	push	{r4, r5, r6, lr}
	mov	r4, r0
	ldrh	r5, [r0]
	ldrh	r3, [r3]
	cmp	r3, r5
	bcs	.L2049
	ldr	r1, .L2075+4
	movw	r2, #2939
	ldr	r0, .L2075+8
	bl	printf
	ldr	r1, .L2075+12
	ldr	r0, .L2075+16
	bl	printf
.L2049:
	ldr	r3, .L2075+20
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2050
	movw	r3, #65535
	cmp	r5, r3
	beq	.L2051
	ldr	r3, .L2075+24
	mov	r0, r5
	ldr	r3, [r3]
	ldrh	r3, [r3, r5, lsl #1]
	cbz	r3, .L2052
	bl	INSERT_DATA_LIST
.L2051:
	movs	r3, #0
	strb	r3, [r4, #8]
	ldr	r3, .L2075+28
	cmp	r4, r3
	beq	.L2053
	ldr	r3, .L2075+32
	ldrh	r2, [r3]
	cmp	r2, #1
	beq	.L2053
	ldr	r3, .L2075+36
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2054
.L2053:
	movs	r3, #1
	strb	r3, [r4, #8]
.L2055:
	ldr	r6, .L2075+40
	movw	r2, #65535
	ldrh	r0, [r6]
	cmp	r0, r2
	beq	.L2060
	cmp	r5, r0
	bne	.L2061
	ldr	r3, .L2075+24
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L2062
.L2061:
	bl	update_vpc_list
.L2062:
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
.L2060:
	mov	r0, r4
	bl	allocate_data_superblock
	bl	l2p_flush
	movs	r0, #0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2050:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L2052:
	bl	INSERT_FREE_LIST
	b	.L2051
.L2054:
	ldr	r3, .L2075+44
	cmp	r4, r3
	bne	.L2055
	cmp	r2, #3
	beq	.L2057
	ldr	r2, .L2075+48
	ldr	r2, [r2]
	cmp	r2, #1
	bne	.L2058
.L2057:
	movs	r2, #1
	strb	r2, [r3, #8]
.L2058:
	ldr	r2, .L2075+52
	ldr	r2, [r2]
	cmp	r2, #0
	beq	.L2055
	ldr	r2, .L2075+56
	ldr	r2, [r2]
	cmp	r2, #29
	itt	ls
	movls	r2, #1
	strbls	r2, [r3, #8]
	b	.L2055
.L2076:
	.align	2
.L2075:
	.word	.LANCHOR38
	.word	.LANCHOR219
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR75
	.word	.LANCHOR82
	.word	.LANCHOR91
	.word	.LANCHOR42
	.word	.LANCHOR8
	.word	.LANCHOR130
	.word	.LANCHOR90
	.word	.LANCHOR156
	.word	.LANCHOR101
	.word	.LANCHOR168
	.size	allocate_new_data_superblock, .-allocate_new_data_superblock
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
	ldr	r3, .L2096
	mov	r5, r0
	mov	r8, r1
	ldrb	r6, [r3]	@ zero_extendqisi2
	cbz	r6, .L2078
	ldrb	r6, [r4, #8]	@ zero_extendqisi2
	subs	r3, r6, #1
	rsbs	r6, r3, #0
	adcs	r6, r6, r3
.L2078:
	ldr	r10, .L2096+32
	movs	r7, #0
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	mov	r2, r6
	mov	r1, r8
	mov	r0, r5
	bl	FlashProgPages
.L2079:
	cmp	r7, r8
	beq	.L2088
	ldr	fp, .L2096+36
	b	.L2089
.L2082:
	ldr	r0, [r5, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r4]
	cmp	r3, r0
	bne	.L2080
	ldr	r1, [r10]
	ldrh	r0, [r4, #4]
	ldrh	r2, [r1, r3, lsl #1]
	subs	r2, r2, r0
	strh	r2, [r1, r3, lsl #1]	@ movhi
	ldrh	r3, [fp]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
.L2080:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L2081
	mov	r0, r4
	bl	allocate_new_data_superblock
.L2081:
	ldr	r2, .L2096+4
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
.L2089:
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L2082
	ldr	r3, .L2096+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2083
	ldr	r1, .L2096+12
	movw	r2, #1550
	ldr	r0, .L2096+16
	bl	printf
	ldr	r1, .L2096+20
	ldr	r0, .L2096+24
	bl	printf
.L2083:
	ldr	r3, [r5, #4]
	cbnz	r6, .L2084
.L2095:
	movs	r2, #1
	add	r1, sp, #12
	ldr	r0, [r5, #16]
	str	r3, [sp, #12]
	bl	log2phys
	ldr	r3, [r5, #12]
	ldr	r3, [r3, #12]
	ubfx	r0, r3, #10, #16
	str	r3, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r3, [sp, #4]
	mov	fp, r0
	adds	r3, r3, #1
	beq	.L2086
	ldr	r3, [r10]
	ldrh	r2, [r3, r0, lsl #1]
	cbnz	r2, .L2087
	mov	r1, r0
	ldr	r0, .L2096+28
	bl	printf
.L2087:
	mov	r0, fp
	bl	decrement_vpc_count
.L2086:
	adds	r7, r7, #1
	adds	r5, r5, #36
	b	.L2079
.L2084:
	orr	r3, r3, #-2147483648
	b	.L2095
.L2088:
	ldr	r3, .L2096+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2077
	ldr	r1, .L2096+12
	movw	r2, #1567
	ldr	r0, .L2096+16
	bl	printf
	ldr	r1, .L2096+20
	ldr	r0, .L2096+24
	bl	printf
.L2077:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2097:
	.align	2
.L2096:
	.word	.LANCHOR8
	.word	.LANCHOR136
	.word	.LANCHOR36
	.word	.LANCHOR220
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC38
	.word	.LANCHOR82
	.word	.LANCHOR51
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
	push	{r4, lr}
	ldr	r4, .L2103
	ldr	r0, [r4]
	cbz	r0, .L2099
	ldr	r3, .L2103+4
	movs	r2, #0
	movs	r1, #1
	ldr	r3, [r3]
	bl	FtlProgPages
	movs	r3, #0
	str	r3, [r4]
.L2099:
	movs	r0, #0
	pop	{r4, pc}
.L2104:
	.align	2
.L2103:
	.word	.LANCHOR129
	.word	.LANCHOR221
	.size	FtlCacheWriteBack, .-FtlCacheWriteBack
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
	ldr	r3, .L2120
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r5, r2
	adds	r2, r1, r2
	mov	r6, r1
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L2113
	cmp	r5, #31
	bhi	.L2107
.L2112:
	movs	r0, #0
.L2105:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L2107:
	ldr	r8, .L2120+12
	bl	FtlCacheWriteBack
	mov	r0, r6
	ldrh	r4, [r8]
	mov	r1, r4
	bl	__aeabi_uidiv
	smulbb	r3, r0, r4
	mov	r7, r0
	subs	r6, r6, r3
	uxth	r6, r6
	cbz	r6, .L2108
	subs	r4, r4, r6
	adds	r7, r7, #1
	cmp	r4, r5
	it	cs
	movcs	r4, r5
	uxth	r4, r4
	subs	r5, r5, r4
.L2108:
	ldr	r4, .L2120+4
	mov	r3, #-1
	ldr	r6, .L2120+8
	str	r3, [sp, #4]
.L2109:
	ldrh	r3, [r8]
	cmp	r5, r3
	bcs	.L2111
	ldr	r3, .L2120+4
	ldr	r2, [r3]
	cmp	r2, #32
	bls	.L2112
	movs	r4, #0
	str	r4, [r3]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L2112
.L2111:
	movs	r2, #0
	mov	r1, sp
	mov	r0, r7
	bl	log2phys
	ldr	r3, [sp]
	adds	r3, r3, #1
	beq	.L2110
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
.L2110:
	ldrh	r3, [r8]
	adds	r7, r7, #1
	subs	r5, r5, r3
	b	.L2109
.L2113:
	mov	r0, #-1
	b	.L2105
.L2121:
	.align	2
.L2120:
	.word	.LANCHOR67
	.word	.LANCHOR222
	.word	.LANCHOR161
	.word	.LANCHOR54
	.size	ftl_discard, .-ftl_discard
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
	ldr	r3, .L2124
	ldr	r3, [r3]
	cbnz	r3, .L2123
	bl	FtlCacheWriteBack
	bl	l2p_flush
	movs	r0, #1
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2123:
	movs	r0, #0
	pop	{r3, pc}
.L2125:
	.align	2
.L2124:
	.word	.LANCHOR75
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
	ldr	r3, .L2128
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L2127
	bl	FtlSysFlush
.L2127:
	movs	r0, #0
	pop	{r3, pc}
.L2129:
	.align	2
.L2128:
	.word	.LANCHOR223
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
	ldr	r3, .L2141
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r2
	adds	r2, r0, r1
	sub	sp, sp, #56
	mov	r7, r0
	mov	r6, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L2140
	ldr	r3, .L2141+4
	mov	r8, #0
	ldr	fp, .L2141+28
	ldrh	r5, [r3]
	lsr	r5, r0, r5
	lsls	r3, r5, #2
	str	r3, [sp]
.L2133:
	cbnz	r6, .L2139
.L2131:
	mov	r0, r8
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2139:
	ldr	r3, .L2141+8
	mov	r0, r7
	ldr	r2, [sp]
	ldr	r3, [r3]
	ldr	r3, [r3, r2]
	ldr	r2, .L2141+12
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
	beq	.L2135
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
	ldr	r2, .L2141+16
	it	eq
	moveq	r8, #-1
	ldr	r2, [r2]
	cmp	r2, #256
	bne	.L2137
	mov	r2, r3
	mov	r1, r5
	ldr	r0, .L2141+20
	bl	printf
	ldr	r2, [fp]
	mov	r1, r5
	ldr	r0, .L2141+24
	bl	FtlMapWritePage
.L2137:
	ldr	r1, [fp]
	lsls	r2, r4, #9
	ldr	r3, [sp, #4]
	mov	r0, r10
	add	r1, r1, r3, lsl #9
	bl	ftl_memcpy
.L2138:
	ldr	r3, [sp, #8]
	adds	r5, r5, #1
	subs	r6, r6, r4
	add	r7, r7, r4
	add	r10, r10, r3
	ldr	r3, [sp]
	adds	r3, r3, #4
	str	r3, [sp]
	b	.L2133
.L2135:
	lsls	r2, r4, #9
	mov	r1, r3
	mov	r0, r10
	bl	ftl_memset
	b	.L2138
.L2140:
	mov	r8, #-1
	b	.L2131
.L2142:
	.align	2
.L2141:
	.word	.LANCHOR48
	.word	.LANCHOR55
	.word	.LANCHOR191
	.word	.LANCHOR54
	.word	.LANCHOR199
	.word	.LC39
	.word	.LANCHOR215
	.word	.LANCHOR182
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
	ldr	r4, .L2145
	ldr	r5, .L2145+4
	ldr	r2, [r4]
	ldrh	r1, [r5]
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	ldr	r2, [r3]
	ldr	r3, .L2145+8
	cmp	r2, r3
	beq	.L2144
	ldr	r1, .L2145+12
	ldr	r0, .L2145+16
	bl	printf
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r0, [r4]
	lsls	r2, r2, #9
	bl	ftl_memset
.L2144:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2146:
	.align	2
.L2145:
	.word	.LANCHOR188
	.word	.LANCHOR187
	.word	1112818501
	.word	.LC40
	.word	.LC6
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
	ldr	r4, .L2151
	movs	r0, #0
	ldr	r5, .L2151+4
	mov	r2, r4
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	cmp	r3, r5
	beq	.L2148
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	ftl_memset
	str	r5, [r4]
.L2148:
	ldr	r3, [r4]
	cmp	r3, r5
	ldr	r5, .L2151+8
	bne	.L2149
	ldr	r2, [r4, #88]
	ldr	r3, .L2151+12
	str	r2, [r3]
	ldr	r2, [r4, #92]
	ldr	r3, .L2151+16
	str	r2, [r3]
	ldr	r2, [r4, #8]
	ldr	r3, .L2151+20
	str	r2, [r3]
	ldr	r2, [r4, #12]
	ldr	r3, .L2151+24
	str	r2, [r3]
	ldr	r2, [r4, #16]
	ldr	r3, .L2151+28
	str	r2, [r3]
	ldr	r2, [r4, #20]
	ldr	r3, .L2151+32
	str	r2, [r3]
	ldr	r3, [r4, #28]
	ldr	r2, [r4, #32]
	str	r3, [r5]
	ldr	r3, .L2151+36
	str	r2, [r3]
	ldr	r2, [r4, #36]
	ldr	r3, .L2151+40
	str	r2, [r3]
	ldr	r2, [r4, #40]
	ldr	r3, .L2151+44
	str	r2, [r3]
	ldr	r2, [r4, #44]
	ldr	r3, .L2151+48
	str	r2, [r3]
	ldr	r2, [r4, #48]
	ldr	r3, .L2151+52
	str	r2, [r3]
	ldr	r2, [r4, #60]
	ldr	r3, .L2151+56
	str	r2, [r3]
.L2149:
	ldr	r3, .L2151+60
	movs	r2, #0
	str	r2, [r3]
	ldr	r2, [r4, #68]
	ldr	r3, .L2151+64
	cmp	r2, r3
	bne	.L2150
	ldr	r3, .L2151+68
	movs	r2, #1
	ldr	r1, .L2151+72
	ldr	r0, .L2151+76
	str	r2, [r3]
	bl	printf
.L2150:
	ldr	r3, .L2151+80
	ldr	r1, .L2151+84
	ldrh	r2, [r3]
	ldr	r3, .L2151+88
	ldrh	r1, [r1]
	ldr	r0, [r3]
	ldr	r3, [r5]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L2151+92
	str	r0, [r3]
	pop	{r3, r4, r5, pc}
.L2152:
	.align	2
.L2151:
	.word	.LANCHOR136
	.word	1179929683
	.word	.LANCHOR166
	.word	.LANCHOR216
	.word	.LANCHOR217
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR164
	.word	.LANCHOR163
	.word	.LANCHOR78
	.word	.LANCHOR161
	.word	.LANCHOR162
	.word	.LANCHOR167
	.word	.LANCHOR168
	.word	.LANCHOR156
	.word	.LANCHOR155
	.word	305432421
	.word	.LANCHOR101
	.word	.LC41
	.word	.LC6
	.word	.LANCHOR46
	.word	.LANCHOR38
	.word	.LANCHOR165
	.word	.LANCHOR202
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
	beq	.L2153
	movs	r3, #0
	ldrh	r6, [r0, #6]
	str	r3, [r0, #36]
	ldr	r3, .L2167
	ldr	r10, [r0, #24]
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2153
	ldr	r3, .L2167+4
	ldr	r5, .L2167+8
	ldr	r3, [r3]
	mov	r7, r5
	str	r3, [r5, #8]
	ldr	r3, .L2167+12
	ldr	r8, [r3]
	ldrh	r3, [r0, #2]
	str	r8, [r5, #12]
	cbz	r3, .L2157
	ldr	r2, .L2167+16
	ldrh	r2, [r2]
	subs	r2, r2, #1
	cmp	r3, r2
	bge	.L2157
	ldrh	r2, [r0]
	movw	r1, #65535
	cmp	r2, r1
	beq	.L2157
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
	beq	.L2157
	ldr	r3, [r4, #24]
	ldrh	r1, [r8, #8]
	ldr	r2, [r3, r1, lsl #2]
	ldr	r3, [r5, #4]
	cmp	r2, r3
	bne	.L2157
	ldr	r2, [r5, #8]
.L2166:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	FtlMapWritePage
.L2157:
	subs	r6, r6, #1
	uxth	r6, r6
	ldr	r3, [r10, r6, lsl #2]
	str	r3, [r7, #4]
	cbz	r3, .L2158
	movs	r2, #1
	ldr	r0, .L2167+8
	mov	r1, r2
	bl	FlashReadPages
.L2159:
	ldr	r2, [r7, #8]
	mov	r1, r6
	b	.L2166
.L2158:
	ldr	r3, .L2167+20
	movs	r1, #255
	ldr	r0, [r7, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L2159
.L2153:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L2168:
	.align	2
.L2167:
	.word	.LANCHOR75
	.word	.LANCHOR181
	.word	.LANCHOR199
	.word	.LANCHOR185
	.word	.LANCHOR52
	.word	.LANCHOR56
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
	ldr	r5, .L2251
	sub	sp, sp, #32
	mov	r1, r4
	ldr	r3, .L2251+4
	ldr	r2, [r5]
	ldr	r6, .L2251+8
	strh	r4, [r3]	@ movhi
	ldr	r3, .L2251+12
	lsls	r2, r2, #2
	strh	r4, [r6]	@ movhi
	ldr	r7, .L2251+16
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [r5]
	mov	r1, r4
	ldr	r3, .L2251+20
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L2251+24
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L2251+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	movs	r2, #12
	movs	r1, #255
	ldr	r0, .L2251+32
	bl	ftl_memset
	ldr	r3, .L2251+36
	str	r6, [sp, #12]
	str	r5, [sp, #16]
	ldrh	r3, [r3]
	str	r3, [sp, #4]
.L2170:
	ldr	r3, .L2251+40
	ldr	r2, [sp, #4]
	ldrh	r3, [r3]
	cmp	r3, r2
	bls	.L2212
	ldr	r3, .L2251+44
	movs	r5, #0
	ldr	r1, .L2251+48
	mov	fp, r5
	movs	r7, #36
	ldrh	r8, [r3]
	ldr	r3, .L2251+52
	ldr	r2, [r1]
	ldr	r1, .L2251+56
	ldr	r6, [r3]
	ldr	r3, .L2251+60
	str	r2, [sp, #8]
	ldrh	r10, [r1]
	ldr	r3, [r3]
	ldr	r2, .L2251+64
	b	.L2213
.L2172:
	ldrb	r0, [r2, r5]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #28]
	str	r2, [sp, #24]
	bl	V2P_block
	str	r0, [sp, #20]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #28]
	cbnz	r0, .L2171
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
.L2171:
	adds	r5, r5, #1
.L2213:
	uxth	r1, r5
	cmp	r8, r1
	bhi	.L2172
	cmp	fp, #0
	bne	.L2173
.L2211:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #4]
	b	.L2170
.L2173:
	movs	r7, #0
	movs	r2, #1
	mov	r1, fp
	mov	r0, r6
	bl	FlashReadPages
.L2174:
	uxth	r3, r7
	cmp	fp, r3
	bls	.L2211
	ldr	r3, .L2251+52
	mov	r8, #36
	mul	r8, r8, r7
	ldr	r3, [r3]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	ldr	r5, [r2, #4]
	ldr	r6, [r2, #12]
	adds	r3, r3, #1
	ubfx	r5, r5, #10, #16
	bne	.L2177
	mov	r10, #16
.L2179:
	ldr	r3, .L2251+52
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
	ldr	r3, .L2251+52
	ldr	r3, [r3]
	bne	.L2176
	mov	r2, #-1
	str	r2, [r3, r8]
	ldr	r3, .L2251+52
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	cmp	r3, r2
	beq	.L2178
.L2177:
	ldr	r3, .L2251+68
	ldr	r2, [r3]
	ldr	r3, [r6, #4]
	adds	r1, r2, #1
	beq	.L2180
	cmp	r2, r3
	bhi	.L2181
.L2180:
	adds	r2, r3, #1
	ittt	ne
	ldrne	r1, .L2251+68
	addne	r2, r3, #1
	strne	r2, [r1]
.L2181:
	ldrh	r2, [r6]
	movw	r1, #61604
	cmp	r2, r1
	beq	.L2183
	bhi	.L2184
	movw	r3, #61574
	cmp	r2, r3
	beq	.L2185
.L2182:
	adds	r7, r7, #1
	b	.L2174
.L2176:
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L2177
	add	r10, r10, #-1
	uxth	r10, r10
	cmp	r10, #0
	bne	.L2179
.L2178:
	ldr	r3, .L2251+72
	ldrb	r1, [r3]	@ zero_extendqisi2
	cbnz	r1, .L2250
.L2209:
	mov	r0, r5
	bl	FtlFreeSysBlkQueueIn
	b	.L2182
.L2184:
	movw	r3, #61634
	cmp	r2, r3
	beq	.L2186
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2182
.L2250:
	movs	r1, #0
	b	.L2209
.L2186:
	ldr	r3, .L2251+8
	ldrh	r2, [r3]
	ldr	r3, .L2251
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L2188
	ldr	r1, .L2251+76
	movw	r2, #1269
	ldr	r0, .L2251+80
	bl	printf
	ldr	r1, .L2251+84
	ldr	r0, .L2251+88
	bl	printf
.L2188:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #12]
	ldr	r1, [r3]
	ldrh	r0, [r2]
	ldr	r2, .L2251+12
	uxth	r10, r1
	ldr	ip, [r2]
	add	r3, r10, #-1
	sub	r10, r10, r0
	add	r10, r10, #-1
	sxth	r3, r3
	sxth	r10, r10
.L2189:
	cmp	r3, r10
	bgt	.L2195
	cmp	r3, #0
	bge	.L2228
	b	.L2182
.L2195:
	ldr	r2, [ip, r3, lsl #2]
	add	r8, ip, r3, lsl #2
	ldr	r4, [r6, #4]
	cmp	r4, r2
	bls	.L2190
	ldr	r2, [ip]
	cbnz	r2, .L2191
	cmp	r1, r0
	ittt	ne
	ldrne	r2, .L2251+8
	addne	r0, r0, #1
	strhne	r0, [r2]	@ movhi
.L2191:
	ldr	r2, .L2251+20
	uxth	r10, r3
	ldr	r0, [r2]
	movs	r2, #0
.L2192:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L2193
	ldr	r2, [r6, #4]
	cmp	r3, #0
	str	r2, [r8]
	strh	r5, [r0, r3, lsl #1]	@ movhi
	blt	.L2182
	ldr	r2, .L2251+8
	ldrh	r0, [r2]
	ldr	r2, .L2251
	ldr	r2, [r2]
	subs	r2, r2, r0
	subs	r2, r2, #1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L2182
.L2228:
	ldr	r2, .L2251+8
	adds	r0, r0, #1
	strh	r0, [r2]	@ movhi
	ldr	r2, [r6, #4]
	str	r2, [ip, r3, lsl #2]
	ldr	r2, .L2251+20
.L2248:
	ldr	r2, [r2]
	strh	r5, [r2, r3, lsl #1]	@ movhi
	b	.L2182
.L2193:
	add	lr, ip, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, r0, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [ip, r1, lsl #2]
	strh	lr, [r0, r1, lsl #1]	@ movhi
	b	.L2192
.L2190:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L2189
.L2252:
	.align	2
.L2251:
	.word	.LANCHOR63
	.word	.LANCHOR69
	.word	.LANCHOR125
	.word	.LANCHOR127
	.word	.LANCHOR60
	.word	.LANCHOR126
	.word	.LANCHOR190
	.word	.LANCHOR70
	.word	.LANCHOR206
	.word	.LANCHOR38
	.word	.LANCHOR39
	.word	.LANCHOR36
	.word	.LANCHOR105
	.word	.LANCHOR178
	.word	.LANCHOR57
	.word	.LANCHOR104
	.word	.LANCHOR45
	.word	.LANCHOR157
	.word	.LANCHOR8
	.word	.LANCHOR224
	.word	.LC4
	.word	.LC5
	.word	.LC6
.L2185:
	ldr	r8, .L2253+20
	ldr	r10, .L2253+28
	ldrh	r2, [r8]
	ldrh	r3, [r10]
	cmp	r2, r3
	bls	.L2198
	ldr	r1, .L2253
	movw	r2, #1316
	ldr	r0, .L2253+4
	bl	printf
	ldr	r1, .L2253+8
	ldr	r0, .L2253+12
	bl	printf
.L2198:
	ldr	r2, .L2253+16
	ldrh	lr, [r10]
	ldrh	ip, [r8]
	ldr	r0, [r2]
	add	r10, lr, #-1
	sxth	r3, r10
	sub	r10, r10, ip
.L2199:
	cmp	r3, r10
	ble	.L2204
	ldr	r1, [r6, #4]
	add	r8, r0, r3, lsl #2
	ldr	r2, [r0, r3, lsl #2]
	cmp	r1, r2
	bls	.L2200
	ldr	r2, [r0]
	cbnz	r2, .L2201
	cmp	lr, ip
	ittt	ne
	ldrne	r2, .L2253+20
	addne	ip, ip, #1
	strhne	ip, [r2]	@ movhi
.L2201:
	ldr	r2, .L2253+24
	uxth	r10, r3
	ldr	ip, [r2]
	movs	r2, #0
.L2202:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L2203
	ldr	r2, [r6, #4]
	str	r2, [r8]
	strh	r5, [ip, r3, lsl #1]	@ movhi
.L2204:
	cmp	r3, #0
	blt	.L2182
	ldr	r2, .L2253+28
	ldr	ip, .L2253+20
	ldrh	r2, [r2]
	ldrh	r1, [ip]
	subs	r2, r2, #1
	subs	r2, r2, r1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L2182
	ldr	r2, [r6, #4]
	adds	r1, r1, #1
	strh	r1, [ip]	@ movhi
	str	r2, [r0, r3, lsl #2]
	ldr	r2, .L2253+24
	b	.L2248
.L2203:
	add	lr, r0, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, ip, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [r0, r1, lsl #2]
	strh	lr, [ip, r1, lsl #1]	@ movhi
	b	.L2202
.L2200:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L2199
.L2183:
	ldr	r8, .L2253+48
	movw	r2, #65535
	ldrh	r1, [r8]
	cmp	r1, r2
	bne	.L2206
.L2249:
	strh	r5, [r8]	@ movhi
	str	r3, [r8, #8]
	b	.L2182
.L2206:
	ldrh	r0, [r8, #4]
	cmp	r0, r2
	beq	.L2207
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L2207:
	ldr	r3, [r6, #4]
	ldr	r2, [r8, #8]
	cmp	r2, r3
	bcs	.L2208
	ldrh	r2, [r8]
	strh	r2, [r8, #4]	@ movhi
	b	.L2249
.L2208:
	strh	r5, [r8, #4]	@ movhi
	b	.L2182
.L2212:
	ldr	r3, .L2253+32
	ldr	r2, [r3]
	ldrh	r3, [r2]
	cbz	r3, .L2214
.L2217:
	ldr	r3, .L2253+24
	ldr	r4, [r3]
	ldrh	r2, [r4]
	cmp	r2, #0
	beq	.L2215
.L2216:
	ldr	r3, .L2253+36
	ldrh	r2, [r3]
	ldr	r3, .L2253+40
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L2247
	ldr	r1, .L2253
	movw	r2, #1450
	ldr	r0, .L2253+4
	bl	printf
	ldr	r1, .L2253+8
	ldr	r0, .L2253+12
	bl	printf
.L2247:
	movs	r0, #0
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2214:
	ldr	r1, .L2253+36
	ldrh	r1, [r1]
	cmp	r1, #0
	beq	.L2217
	ldr	r5, .L2253+40
	ldr	r0, [r5]
.L2218:
	sxth	r1, r3
	cmp	r1, r0
	bcs	.L2217
	ldrh	r4, [r2, r1, lsl #1]
	adds	r3, r3, #1
	cmp	r4, #0
	beq	.L2218
	ldr	r3, .L2253+44
	movs	r6, #0
	ldr	r0, [r3]
	mov	r3, r1
.L2219:
	ldr	r4, [r5]
	cmp	r3, r4
	bcs	.L2217
	ldrh	r7, [r2, r3, lsl #1]
	subs	r4, r3, r1
	strh	r7, [r2, r4, lsl #1]	@ movhi
	ldr	r7, [r0, r3, lsl #2]
	str	r7, [r0, r4, lsl #2]
	strh	r6, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	sxth	r3, r3
	b	.L2219
.L2215:
	ldr	r3, .L2253+20
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L2216
	ldr	r5, .L2253+28
	ldrh	r1, [r5]
.L2224:
	sxth	r3, r2
	cmp	r3, r1
	mov	r6, r3
	bge	.L2216
	ldrh	r0, [r4, r3, lsl #1]
	adds	r2, r2, #1
	cmp	r0, #0
	beq	.L2224
	ldr	r2, .L2253+16
	movs	r0, #0
	ldr	r2, [r2]
.L2225:
	ldrh	r1, [r5]
	cmp	r3, r1
	bge	.L2216
	ldrh	r7, [r4, r3, lsl #1]
	subs	r1, r3, r6
	strh	r7, [r4, r1, lsl #1]	@ movhi
	ldr	r7, [r2, r3, lsl #2]
	str	r7, [r2, r1, lsl #2]
	adds	r1, r3, #1
	strh	r0, [r4, r3, lsl #1]	@ movhi
	sxth	r3, r1
	b	.L2225
.L2254:
	.align	2
.L2253:
	.word	.LANCHOR224
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR190
	.word	.LANCHOR69
	.word	.LANCHOR70
	.word	.LANCHOR60
	.word	.LANCHOR126
	.word	.LANCHOR125
	.word	.LANCHOR63
	.word	.LANCHOR127
	.word	.LANCHOR206
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
	ldr	r6, .L2280
	ldr	r10, .L2280+156
	ldrh	r2, [r6]
	ldr	r7, .L2280+4
	ldr	r3, [r10]
	ldr	r4, .L2280+8
	ldr	r5, .L2280+12
	lsls	r2, r2, #1
	ldr	r0, [r7]
	mov	r8, r7
	str	r3, [r4, #12]
	str	r1, [r4, #8]
	bl	ftl_memset
	ldrh	r0, [r5]
	movw	r3, #65535
	cmp	r0, r3
	bne	.L2256
.L2265:
	mov	r0, #-1
.L2255:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2256:
	movs	r1, #1
	ldr	fp, .L2280+160
	bl	FtlGetLastWrittenPage
	ldr	r3, .L2280+16
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r5, #2]	@ movhi
.L2258:
	cmp	r7, #0
	bge	.L2261
	ldr	r1, .L2280+20
	movw	r2, #1510
	ldr	r0, .L2280+24
	bl	printf
	ldr	r1, .L2280+28
	ldr	r0, .L2280+32
	bl	printf
.L2260:
	ldr	r2, .L2280+36
	ldrh	r3, [r6]
	ldrh	r2, [r2]
	adds	r3, r3, #24
	cmp	r2, r3, lsl #1
	bcs	.L2263
	ldr	r1, .L2280+20
	mov	r2, #1512
	ldr	r0, .L2280+24
	bl	printf
	ldr	r1, .L2280+28
	ldr	r0, .L2280+32
	bl	printf
.L2263:
	movs	r2, #48
	ldr	r1, [r4, #8]
	ldr	r0, .L2280+40
	bl	ftl_memcpy
	ldrh	r2, [r6]
	ldr	r1, [r4, #8]
	ldr	r0, [r8]
	lsls	r2, r2, #1
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
	ldr	r3, .L2280+44
	ldr	r0, [r3]
	bl	ftl_memcpy
	ldr	r3, .L2280+48
	ldrh	r3, [r3]
	cbz	r3, .L2264
	ldrh	r1, [r6]
	ldr	r3, .L2280+52
	ldrh	r2, [r3]
	lsrs	r3, r1, #3
	add	r3, r3, r1, lsl #1
	ldr	r1, [r4, #8]
	adds	r3, r3, #52
	lsls	r2, r2, #2
	ubfx	r3, r3, #2, #14
	add	r1, r1, r3, lsl #2
	ldr	r3, .L2280+56
	ldr	r0, [r3]
	bl	ftl_memcpy
.L2264:
	ldr	r4, .L2280+40
	ldr	r3, .L2280+16
	ldr	r2, [r4]
	cmp	r2, r3
	bne	.L2265
	ldr	r3, .L2280+60
	ldrb	r2, [r4, #10]	@ zero_extendqisi2
	ldrh	r6, [r4, #8]
	ldrh	r3, [r3]
	strh	r6, [r5, #6]	@ movhi
	cmp	r2, r3
	bne	.L2265
	ldr	r3, .L2280+64
	ldr	r2, .L2280+68
	str	r6, [r3]
	ldr	r3, .L2280+72
	ldrh	r3, [r3]
	muls	r3, r6, r3
	str	r3, [r2]
	ldr	r2, .L2280+76
	ldrh	r2, [r2]
	muls	r3, r2, r3
	ldr	r2, .L2280+80
	str	r3, [r2]
	ldr	r3, .L2280+84
	ldr	r5, [r3]
	ldr	r3, .L2280+88
	ldrh	r0, [r3, #6]
	ldr	r3, .L2280+92
	subs	r0, r5, r0
	ldrh	r1, [r3]
	subs	r0, r0, r6
	bl	__aeabi_uidiv
	ldr	r3, .L2280+96
	cmp	r6, r5
	strh	r0, [r3]	@ movhi
	bls	.L2266
	ldr	r1, .L2280+20
	movw	r2, #1539
	ldr	r0, .L2280+24
	bl	printf
	ldr	r1, .L2280+28
	ldr	r0, .L2280+32
	bl	printf
.L2266:
	ldrh	r2, [r4, #16]
	ldr	r3, .L2280+100
	ldrh	ip, [r4, #14]
	ldr	r7, .L2280+104
	lsrs	r1, r2, #6
	and	r2, r2, #63
	strb	r2, [r3, #6]
	ldrb	r2, [r4, #11]	@ zero_extendqisi2
	strh	r1, [r3, #2]	@ movhi
	ldr	r1, .L2280+108
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
	ldr	r2, .L2280+112
	strh	r5, [r2]	@ movhi
	ldrh	r5, [r4, #24]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r2, #6]
	ldrb	r5, [r4, #13]	@ zero_extendqisi2
	strh	r6, [r2, #2]	@ movhi
	ldr	r6, [r4, #32]
	strb	r5, [r2, #8]
	ldr	r5, .L2280+116
	str	r3, [r5]
	ldr	r5, .L2280+120
	str	r3, [r5]
	ldr	r5, .L2280+124
	str	r3, [r5]
	ldr	r5, .L2280+128
	str	r3, [r5]
	ldr	r5, .L2280+132
	str	r6, [r5]
	mov	r6, r1
	ldr	r5, .L2280+136
	str	r3, [r5]
	ldr	r5, .L2280+140
	str	r3, [r5]
	ldr	r5, .L2280+144
	ldr	lr, [r4, #40]
	str	r3, [r5]
	ldr	r3, .L2280+148
	ldr	r5, [r3]
	cmp	lr, r5
	mov	r5, r2
	it	hi
	strhi	lr, [r3]
	ldr	r3, .L2280+152
	ldr	r2, [r4, #36]
	ldr	r1, [r3]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3]
	movw	r3, #65535
	cmp	ip, r3
	beq	.L2269
	ldr	r0, .L2280+100
	bl	make_superblock
.L2269:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2270
	ldr	r0, .L2280+108
	bl	make_superblock
.L2270:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2271
	ldr	r0, .L2280+112
	bl	make_superblock
.L2271:
	ldrh	r2, [r7]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2272
	ldr	r0, .L2280+104
	bl	make_superblock
.L2272:
	movs	r0, #0
	b	.L2255
.L2261:
	ldrh	r2, [r5]
	ldr	r0, .L2280+8
	str	r3, [sp, #4]
	orr	r2, r7, r2, lsl #10
	str	r2, [r4, #4]
	ldr	r2, [fp]
	str	r2, [r4, #8]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [r4]
	ldr	r3, [sp, #4]
	adds	r2, r2, #1
	beq	.L2259
	ldr	r2, [fp]
	ldr	r2, [r2]
	cmp	r2, r3
	bne	.L2259
	ldr	r2, [r10]
	ldrh	r1, [r2]
	movw	r2, #61604
	cmp	r1, r2
	beq	.L2260
.L2259:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L2258
.L2281:
	.align	2
.L2280:
	.word	.LANCHOR38
	.word	.LANCHOR82
	.word	.LANCHOR199
	.word	.LANCHOR206
	.word	1179929683
	.word	.LANCHOR225
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR56
	.word	.LANCHOR135
	.word	.LANCHOR0
	.word	.LANCHOR68
	.word	.LANCHOR65
	.word	.LANCHOR192
	.word	.LANCHOR43
	.word	.LANCHOR226
	.word	.LANCHOR71
	.word	.LANCHOR51
	.word	.LANCHOR54
	.word	.LANCHOR67
	.word	.LANCHOR40
	.word	.LANCHOR73
	.word	.LANCHOR36
	.word	.LANCHOR227
	.word	.LANCHOR90
	.word	.LANCHOR201
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR159
	.word	.LANCHOR160
	.word	.LANCHOR164
	.word	.LANCHOR163
	.word	.LANCHOR165
	.word	.LANCHOR166
	.word	.LANCHOR167
	.word	.LANCHOR162
	.word	.LANCHOR157
	.word	.LANCHOR158
	.word	.LANCHOR185
	.word	.LANCHOR79
	.size	FtlLoadSysInfo, .-FtlLoadSysInfo
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
	sub	sp, sp, #32
	ldrh	fp, [r0, #6]
	mov	r7, r0
	movs	r4, #0
	str	r3, [sp, #12]
	ldr	r3, [r0, #12]
	lsl	r2, fp, #2
	str	r3, [sp, #8]
	ldr	r3, [r0, #16]
	str	r3, [sp, #20]
	ldrh	r3, [r0, #8]
	ldr	r0, [sp, #12]
	str	r3, [sp, #16]
	bl	ftl_memset
	ldr	r2, .L2322
	ldr	r3, .L2322+4
	str	r4, [r7, #32]
	ldr	r1, [r2]
	mov	r10, r2
	mov	r8, r3
	str	r4, [r7, #28]
	str	r1, [r3, #8]
	ldr	r1, .L2322+8
	ldr	r5, [r1]
	movw	r1, #65535
	str	r5, [r3, #12]
	strh	r1, [r7]	@ movhi
	strh	r1, [r7, #2]	@ movhi
	movs	r1, #1
	str	r1, [r7, #36]
.L2283:
	ldr	r2, [sp, #16]
	sxth	r3, r4
	cmp	r3, r2
	bge	.L2301
	ldr	r2, [sp, #16]
	lsls	r6, r3, #1
	subs	r2, r2, #1
	cmp	r3, r2
	bne	.L2284
	ldr	r2, [sp, #8]
	movs	r1, #1
	str	r3, [sp, #16]
	ldr	r10, .L2322+4
	ldrh	r0, [r2, r3, lsl #1]
	add	r6, r6, r2
	bl	FtlGetLastWrittenPage
	ldr	r3, [sp, #20]
	sxth	r8, r0
	strh	r4, [r7]	@ movhi
	movs	r4, #0
	adds	r0, r0, #1
	mov	r2, r3
	ldr	r3, [sp, #16]
	strh	r0, [r7, #2]	@ movhi
	ldr	r3, [r2, r3, lsl #2]
	str	r3, [r7, #28]
.L2285:
	sxth	r3, r4
	cmp	r3, r8
	ble	.L2288
.L2301:
	ldr	r3, .L2322+12
	cmp	r7, r3
	str	r3, [sp, #12]
	bne	.L2290
	ldr	r3, .L2322+16
	ldrh	r3, [r3]
	cbz	r3, .L2290
	ldr	fp, .L2322+40
	movs	r4, #0
.L2304:
	ldr	r3, .L2322+20
	ldrh	r3, [r3]
	cmp	r4, r3
	bcc	.L2311
.L2290:
	mov	r0, r7
	bl	ftl_free_no_use_map_blk
	ldr	r3, .L2322+24
	ldrh	r2, [r7, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2303
	mov	r0, r7
	bl	ftl_map_blk_alloc_new_blk
.L2303:
	mov	r0, r7
	bl	ftl_map_blk_gc
	mov	r0, r7
	bl	ftl_map_blk_gc
	movs	r0, #0
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2288:
	ldrh	r2, [r6]
	ldr	r0, .L2322+4
	orr	r3, r3, r2, lsl #10
	movs	r2, #1
	mov	r1, r2
	str	r3, [r10, #4]
	bl	FlashReadPages
	ldr	r3, [r10]
	adds	r3, r3, #1
	beq	.L2286
	ldrh	r3, [r5, #8]
	cmp	fp, r3
	bls	.L2287
	ldrh	r1, [r5]
	ldrh	r2, [r7, #4]
	cmp	r1, r2
	bne	.L2287
	ldr	r2, [r10, #4]
	ldr	r1, [sp, #12]
	str	r2, [r1, r3, lsl #2]
.L2287:
	adds	r4, r4, #1
	b	.L2285
.L2286:
	ldrh	r3, [r6]
	strh	r3, [r7, #40]	@ movhi
	b	.L2287
.L2284:
	ldr	r2, [r10]
	ldr	r0, .L2322+4
	str	r2, [r8, #8]
	ldr	r2, [sp, #8]
	add	r2, r2, r6
	ldr	r6, .L2322+24
	str	r2, [sp, #24]
	ldr	r2, [sp, #8]
	ldrh	r2, [r2, r3, lsl #1]
	ldrh	r3, [r6]
	subs	r3, r3, #1
	orr	r3, r3, r2, lsl #10
	movs	r2, #1
	mov	r1, r2
	str	r3, [r8, #4]
	bl	FlashReadPages
	ldr	r3, [r8]
	adds	r3, r3, #1
	beq	.L2313
	ldrh	r2, [r5]
	ldrh	r3, [r7, #4]
	cmp	r2, r3
	bne	.L2313
	ldrh	r2, [r5, #8]
	movw	r3, #64245
	cmp	r2, r3
	beq	.L2292
.L2313:
	ldr	r3, .L2322+24
	movs	r6, #0
.L2293:
	ldrh	r1, [r3]
	sxth	r2, r6
	cmp	r2, r1
	bge	.L2299
	str	r3, [sp, #28]
	ldr	r3, [sp, #24]
	ldr	r0, .L2322+4
	ldrh	r1, [r3]
	orr	r2, r2, r1, lsl #10
	str	r2, [r8, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [r8]
	ldr	r3, [sp, #28]
	adds	r2, r2, #1
	beq	.L2297
	ldrh	r2, [r5, #8]
	cmp	fp, r2
	bls	.L2297
	ldrh	r0, [r5]
	ldrh	r1, [r7, #4]
	cmp	r0, r1
	ittt	eq
	ldreq	r1, [r8, #4]
	ldreq	r0, [sp, #12]
	streq	r1, [r0, r2, lsl #2]
.L2297:
	adds	r6, r6, #1
	b	.L2293
.L2292:
	ldrh	r2, [r6]
	movs	r1, #0
	ldr	r6, [r10]
	subs	r2, r2, #1
.L2294:
	sxth	r3, r1
	cmp	r3, r2
	blt	.L2296
.L2299:
	adds	r4, r4, #1
	b	.L2283
.L2296:
	lsls	r0, r3, #3
	ldr	r3, [r6, r3, lsl #3]
	adds	r1, r1, #1
	uxth	ip, r3
	cmp	fp, ip
	itttt	hi
	addhi	r0, r0, r6
	ldrhi	r3, [sp, #12]
	ldrhi	r0, [r0, #4]
	strhi	r0, [r3, ip, lsl #2]
	b	.L2294
.L2311:
	ldr	r3, [fp]
	lsls	r5, r4, #2
	ldr	r2, [r3, r4, lsl #2]
	subs	r3, r2, #1
	adds	r3, r3, #3
	bhi	.L2306
	ldr	r8, .L2322+44
	ldr	r3, [r8]
	ldr	r3, [r3, r4, lsl #2]
	cmp	r2, r3
	beq	.L2306
	ldr	r3, .L2322
	ldr	r6, .L2322+4
	ldr	r3, [r3]
	str	r2, [r6, #4]
	movs	r2, #1
	mov	r1, r2
	mov	r0, r6
	str	r3, [r6, #8]
	ldr	r3, .L2322+8
	ldr	r3, [r3]
	str	r3, [r6, #12]
	str	r3, [sp, #16]
	bl	FlashReadPages
	ldr	r2, [r6]
	ldr	r3, [sp, #16]
	adds	r2, r2, #1
	beq	.L2315
	ldr	r2, [sp, #12]
	ldrh	r1, [r3]
	ldrh	r2, [r2, #4]
	cmp	r1, r2
	bne	.L2315
	ldr	r10, [r3, #4]
.L2308:
	ldr	r2, [r8]
	ldr	r0, .L2322+4
	str	r3, [sp, #16]
	ldr	r2, [r2, r5]
	str	r2, [r6, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r3, [sp, #16]
	ldr	r3, [r3, #4]
	cmp	r10, r3
	bls	.L2306
	ldr	r2, [r8]
	ldr	r1, [fp]
	ldr	r0, .L2322+28
	str	r3, [sp]
	mov	r3, r10
	ldr	r2, [r2, r5]
	ldr	r1, [r1, r5]
	bl	printf
	ldr	r3, [fp]
	ldr	r2, [r8]
	ldr	r1, [r3, r5]
	str	r1, [r2, r5]
	movs	r1, #0
	ldr	r0, [r3, r5]
	ldr	r3, .L2322+32
	ubfx	r0, r0, #10, #16
	ldrh	r2, [r3]
.L2309:
	sxth	r5, r1
	cmp	r5, r2
	blt	.L2310
	ldr	r1, .L2322+36
	ldr	r1, [r1]
	cmp	r2, r1
	bcs	.L2306
	ldr	r1, [sp, #8]
	strh	r0, [r1, r2, lsl #1]	@ movhi
	ldrh	r2, [r3]
	adds	r2, r2, #1
	strh	r2, [r3]	@ movhi
	bl	remove_from_free_sys_Queue
	b	.L2306
.L2315:
	mov	r10, #0
	b	.L2308
.L2310:
	ldr	r6, [sp, #8]
	adds	r1, r1, #1
	ldrh	r5, [r6, r5, lsl #1]
	cmp	r5, r0
	bne	.L2309
.L2306:
	adds	r4, r4, #1
	b	.L2304
.L2323:
	.align	2
.L2322:
	.word	.LANCHOR79
	.word	.LANCHOR199
	.word	.LANCHOR185
	.word	.LANCHOR124
	.word	.LANCHOR68
	.word	.LANCHOR65
	.word	.LANCHOR52
	.word	.LC42
	.word	.LANCHOR125
	.word	.LANCHOR63
	.word	.LANCHOR192
	.word	.LANCHOR128
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
	ldr	r3, .L2325
	ldr	r0, .L2325+4
	ldrh	r3, [r3]
	strh	r3, [r0, #10]	@ movhi
	movw	r3, #61574
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L2325+8
	ldrh	r3, [r3]
	strh	r3, [r0, #8]	@ movhi
	ldr	r3, .L2325+12
	ldrh	r3, [r3]
	strh	r3, [r0, #6]	@ movhi
	ldr	r3, .L2325+16
	ldr	r3, [r3]
	str	r3, [r0, #12]
	ldr	r3, .L2325+20
	ldr	r3, [r3]
	str	r3, [r0, #16]
	ldr	r3, .L2325+24
	ldr	r3, [r3]
	str	r3, [r0, #20]
	ldr	r3, .L2325+28
	ldr	r3, [r3]
	str	r3, [r0, #24]
	movw	r3, #65535
	strh	r3, [r0, #40]	@ movhi
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L2326:
	.align	2
.L2325:
	.word	.LANCHOR60
	.word	.LANCHOR215
	.word	.LANCHOR69
	.word	.LANCHOR61
	.word	.LANCHOR70
	.word	.LANCHOR190
	.word	.LANCHOR189
	.word	.LANCHOR191
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
	ldr	r0, .L2328
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L2329:
	.align	2
.L2328:
	.word	.LANCHOR124
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
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
	beq	.L2491
	ldrh	r3, [r0, #2]
	str	r3, [sp, #12]
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	str	r3, [sp, #28]
	ldr	r3, .L2500
	ldrh	r3, [r3]
	cmp	r3, r1
	mov	r3, #0
	bne	.L2333
	strh	r3, [r0, #4]	@ movhi
.L2498:
	strb	r3, [r10, #6]
.L2491:
	movs	r0, #0
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2333:
	ldrh	r0, [r0, #16]
.L2334:
	cmp	r0, r2
	uxth	r5, r3
	add	r3, r3, #1
	beq	.L2335
	ldrb	r1, [r10, #8]	@ zero_extendqisi2
	cmp	r1, #1
	bne	.L2336
	bl	FtlGetLastWrittenPage
	adds	r6, r0, #1
	mov	r4, r0
	beq	.L2337
	ldr	r3, .L2500+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L2415
	ldr	r3, .L2500+8
	ldrh	r6, [r3, r0, lsl #1]
.L2338:
	ldr	r3, .L2500+12
	movw	lr, #65535
	mov	r8, #36
	ldrh	fp, [r3]
	ldr	r3, .L2500+16
	ldr	r0, [r3]
	ldr	r3, .L2500+20
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L2500+24
	ldrh	ip, [r3]
	add	r3, r10, #16
	str	r3, [sp, #20]
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r7, r3
.L2339:
	uxth	r2, r3
	cmp	fp, r2
	bhi	.L2343
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L2416
	ldr	r3, .L2500+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	adds	r3, r3, #0
	it	ne
	movne	r3, #1
.L2492:
	str	r3, [sp, #36]
	mov	r1, r7
	ldr	r2, [sp, #36]
	movs	r5, #0
	bl	FlashReadPages
	ldr	r3, .L2500+28
	movw	fp, #65535
	ldr	r8, .L2500+16
	ldr	r3, [r3]
	subs	r3, r3, #1
	str	r3, [sp, #4]
.L2345:
	uxth	r3, r5
	cmp	r7, r3
	bhi	.L2350
	bne	.L2348
	adds	r4, r4, #1
	uxth	r3, r4
	str	r3, [sp, #8]
	ldr	r3, [r8]
	ldr	r0, [r3, #4]
.L2493:
	ubfx	r0, r0, #10, #16
	bl	P2V_plane
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	str	r0, [sp, #16]
	cmp	r3, #1
	bne	.L2352
	ldr	r2, .L2500+4
	ldrb	r2, [r2]	@ zero_extendqisi2
	cbnz	r2, .L2352
	ldr	r1, [sp, #8]
	ldr	r2, .L2500+8
	ldrh	r2, [r2, r1, lsl #1]
	str	r2, [sp, #8]
.L2352:
	ldr	r2, .L2500
	ldr	r1, [sp, #8]
	ldrh	r2, [r2]
	cmp	r2, r1
	bne	.L2353
	ldrh	r2, [sp, #8]
	strh	r2, [r10, #2]	@ movhi
	movs	r2, #0
	strb	r2, [r10, #6]
	strh	r2, [r10, #4]	@ movhi
.L2353:
	ldr	r2, [sp, #8]
	ldr	r1, [sp, #12]
	cmp	r2, r1
	bne	.L2354
	ldr	r2, [sp, #16]
	ldr	r1, [sp, #28]
	cmp	r2, r1
	bne	.L2354
.L2499:
	ldr	r1, [sp, #8]
	mov	r0, r10
	bl	ftl_sb_update_avl_pages
	b	.L2491
.L2335:
	uxth	r1, r3
	adds	r1, r1, #8
	ldrh	r0, [r10, r1, lsl #1]
	b	.L2334
.L2336:
	movs	r1, #0
	bl	FtlGetLastWrittenPage
	mov	r4, r0
	adds	r0, r0, #1
	beq	.L2337
.L2415:
	mov	r6, r4
	b	.L2338
.L2337:
	ldr	r3, [sp, #12]
	cbz	r3, .L2340
	ldr	r1, .L2500+32
	movw	r2, #1894
	ldr	r0, .L2500+36
	bl	printf
	ldr	r1, .L2500+40
	ldr	r0, .L2500+44
	bl	printf
.L2340:
	ldr	r3, [sp, #28]
	cbz	r3, .L2341
	cmp	r5, r3
	beq	.L2341
	ldr	r1, .L2500+32
	movw	r2, #1895
	ldr	r0, .L2500+36
	bl	printf
	ldr	r1, .L2500+40
	ldr	r0, .L2500+44
	bl	printf
.L2341:
	movs	r3, #0
	strh	r3, [r10, #2]	@ movhi
	b	.L2498
.L2343:
	ldr	r1, [sp, #4]
	ldrh	r2, [r1], #2
	cmp	r2, lr
	str	r1, [sp, #4]
	beq	.L2342
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
.L2342:
	adds	r3, r3, #1
	b	.L2339
.L2416:
	movs	r3, #0
	b	.L2492
.L2350:
	movs	r3, #36
	ldr	r1, [r8]
	muls	r3, r5, r3
	adds	r2, r1, r3
	ldr	r3, [r1, r3]
	cbnz	r3, .L2346
	ldr	r2, [r2, #12]
	ldr	r3, [r2, #4]
	adds	r1, r3, #1
	beq	.L2347
	ldr	r1, .L2500+28
	mov	r0, r3
	ldr	r1, [r1]
	bl	ftl_cmp_data_ver
	cbz	r0, .L2347
	ldr	r1, .L2500+28
	adds	r3, r3, #1
	str	r3, [r1]
.L2347:
	ldr	r3, [r2]
	adds	r3, r3, #1
	bne	.L2349
.L2348:
	uxth	r3, r4
	uxth	r5, r5
	str	r3, [sp, #8]
	movs	r2, #36
	ldr	r3, [r8]
	mla	r5, r2, r5, r3
	ldr	r0, [r5, #4]
	b	.L2493
.L2346:
	ldr	r1, [r2, #4]
	uxth	fp, r6
	ldr	r0, .L2500+48
	bl	printf
	ldrh	r2, [r10]
	ldr	r3, .L2500+52
	strh	r2, [r3]	@ movhi
.L2349:
	adds	r5, r5, #1
	b	.L2345
.L2354:
	movw	r2, #65535
	cmp	fp, r2
	bne	.L2355
	cmp	r3, #0
	bne	.L2356
.L2355:
	ldr	r3, .L2500+56
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
.L2359:
	cmp	r4, fp
	bhi	.L2374
	ldr	r3, .L2500+12
	movw	lr, #65535
	mov	ip, #36
	ldrh	r8, [r3]
	ldr	r3, .L2500+16
	ldr	r0, [r3]
	ldr	r3, [sp, #20]
	str	r3, [sp, #32]
	movs	r3, #0
	mov	r5, r3
	b	.L2375
.L2361:
	ldr	r1, [sp, #32]
	ldrh	r2, [r1], #2
	cmp	r2, lr
	str	r1, [sp, #32]
	beq	.L2360
	mla	r1, ip, r5, r0
	adds	r5, r5, #1
	orr	r2, r4, r2, lsl #10
	uxth	r5, r5
	str	r2, [r1, #4]
.L2360:
	adds	r3, r3, #1
.L2375:
	uxth	r2, r3
	cmp	r8, r2
	bhi	.L2361
	mov	r1, r5
	ldr	r2, [sp, #36]
	bl	FlashReadPages
	ldr	r2, .L2500+4
	movs	r1, #36
	ldr	r3, .L2500+56
	movs	r0, #0
	movw	ip, #65535
	ldrb	lr, [r2]	@ zero_extendqisi2
	ldr	r2, .L2500+16
	ldr	r3, [r3]
	ldr	r2, [r2]
	mla	r5, r1, r5, r2
.L2362:
	cmp	r2, r5
	bne	.L2372
	cbz	r0, .L2373
	ldr	r2, .L2500+56
	str	r3, [r2]
.L2373:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L2359
.L2501:
	.align	2
.L2500:
	.word	.LANCHOR51
	.word	.LANCHOR8
	.word	.LANCHOR16
	.word	.LANCHOR36
	.word	.LANCHOR178
	.word	.LANCHOR105
	.word	.LANCHOR57
	.word	.LANCHOR158
	.word	.LANCHOR228
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC43
	.word	.LANCHOR229
	.word	.LANCHOR133
.L2372:
	ldr	r1, [r2]
	cbnz	r1, .L2363
	ldr	r1, [r2, #12]
	ldrh	r8, [r1]
	cmp	r8, ip
	beq	.L2419
	ldr	r1, [r1, #4]
	cmp	r1, #-1
	beq	.L2419
	adds	r0, r7, #1
	bne	.L2421
	ldr	r0, .L2502
	ldrh	r0, [r0, r4, lsl #1]
	cmp	r0, ip
	bne	.L2365
	cmp	lr, #0
	beq	.L2421
.L2365:
	ldr	r0, [sp, #4]
	cmp	r0, r3
	it	ne
	movne	r7, r3
.L2421:
	movs	r0, #1
	b	.L2364
.L2363:
	cbz	r0, .L2366
	ldr	r2, .L2502+4
	str	r3, [r2]
.L2366:
	ldr	r3, .L2502+8
	ldrh	r2, [r10]
	strh	r2, [r3]	@ movhi
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	cbnz	r3, .L2356
	ldr	r3, .L2502
	ldrh	r2, [r3, r4, lsl #1]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2368
	adds	r1, r7, #1
	ldr	r3, .L2502+4
	beq	.L2369
	str	r7, [r3]
.L2356:
	ldr	r3, .L2502+12
	movs	r2, #1
	ldr	r0, .L2502+16
	ldr	r6, .L2502+20
	strh	r2, [r3]	@ movhi
	bl	FtlMapBlkWriteDumpData
	ldr	fp, [sp, #12]
.L2376:
	ldr	r3, .L2502+24
	movw	ip, #65535
	ldr	r0, [r6]
	mov	lr, #36
	ldr	r1, [sp, #20]
	movs	r2, #0
	ldrh	r5, [r3]
	ldr	r3, .L2502+28
	str	r2, [sp, #24]
	ldrb	r7, [r3]	@ zero_extendqisi2
.L2377:
	uxth	r3, r2
	cmp	r3, r5
	bcc	.L2380
	ldr	r2, [sp, #36]
	ldr	r1, [sp, #24]
	bl	FlashReadPages
	movs	r3, #0
.L2497:
	str	r3, [sp, #32]
	ldr	r2, [sp, #24]
	ldrh	r3, [sp, #32]
	cmp	r2, r3
	bhi	.L2409
	ldrb	r3, [r10, #8]	@ zero_extendqisi2
	add	fp, fp, #1
	uxth	fp, fp
	cmp	r3, #1
	bne	.L2410
	ldr	r3, .L2502+28
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2410
	ldr	r3, .L2502+32
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2410
	ldr	r3, [sp, #8]
	cmp	r3, fp
	beq	.L2385
.L2410:
	ldr	r3, .L2502+36
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2376
	ldr	r2, .L2502+24
	movw	r0, #65535
	movs	r3, #0
	strh	fp, [r10, #2]	@ movhi
	strh	r3, [r10, #4]	@ movhi
	ldrh	r2, [r2]
.L2411:
	uxth	r1, r3
	cmp	r1, r2
	bcs	.L2491
	ldr	r1, [sp, #20]
	ldrh	r4, [r1], #2
	cmp	r4, r0
	str	r1, [sp, #20]
	add	r1, r3, #1
	bne	.L2498
	mov	r3, r1
	b	.L2411
.L2369:
	ldr	r2, [sp, #4]
	ldr	r1, [sp, #24]
	cmp	r2, r1
	itet	eq
	ldreq	r2, [r3]
	movne	r2, r1
	addeq	r2, r2, #-1
.L2494:
	str	r2, [r3]
	b	.L2356
.L2368:
	ldr	r3, [sp, #4]
	cmp	r6, r3
	beq	.L2371
	adds	r2, r6, #1
	beq	.L2356
	ldr	r3, .L2502+4
	str	r6, [r3]
	b	.L2356
.L2371:
	ldr	r2, .L2502+4
	ldr	r1, [sp, #4]
	ldr	r3, [r2]
	cmp	r1, r3
	beq	.L2356
	subs	r3, r3, #1
	str	r3, [r2]
	b	.L2356
.L2419:
	mov	r1, r3
	mov	r3, r6
.L2364:
	mov	r6, r3
	adds	r2, r2, #36
	mov	r3, r1
	b	.L2362
.L2374:
	mov	r2, #-1
	ldr	r3, .L2502+4
	b	.L2494
.L2380:
	ldrh	r3, [r1], #2
	cmp	r3, ip
	beq	.L2378
	ldr	r4, [sp, #24]
	orr	r3, fp, r3, lsl #10
	mla	r4, lr, r4, r0
	str	r3, [r4, #4]
	ldrb	r8, [r10, #8]	@ zero_extendqisi2
	cmp	r8, #1
	bne	.L2379
	cbz	r7, .L2379
	orr	r3, r3, #-2147483648
	str	r3, [r4, #4]
.L2379:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #24]
.L2378:
	adds	r2, r2, #1
	b	.L2377
.L2409:
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
	bcc	.L2382
	bne	.L2383
	ldr	r3, [sp, #28]
	cmp	r3, r0
	bhi	.L2382
.L2383:
	ldr	r3, [sp, #8]
	cmp	fp, r3
	bne	.L2384
	ldr	r3, [sp, #16]
	cmp	r3, r0
	beq	.L2385
.L2384:
	ldr	r3, [r8, r5]
	adds	r3, r3, #1
	beq	.L2386
	ldr	r3, [r7, #12]
	movw	r2, #61589
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L2387
.L2393:
	ldrh	r0, [r10]
.L2496:
	bl	decrement_vpc_count
.L2382:
	ldr	r3, [sp, #32]
	adds	r3, r3, #1
	b	.L2497
.L2387:
	ldr	r2, [r3, #4]
	str	r2, [sp, #4]
	adds	r2, r2, #1
	beq	.L2388
	ldr	r2, .L2502+40
	ldr	r0, [sp, #4]
	ldr	r1, [r2]
	bl	ftl_cmp_data_ver
	cbz	r0, .L2388
	ldr	r1, [sp, #4]
	adds	r1, r1, #1
	str	r1, [r2]
.L2388:
	ldr	r4, [r3, #8]
	add	r1, sp, #48
	ldr	r3, [r3, #12]
	movs	r2, #0
	mov	r0, r4
	str	r3, [sp, #44]
	bl	log2phys
	ldr	r3, .L2502+4
	ldr	r1, [r3]
	adds	r3, r1, #1
	beq	.L2389
	ldr	r0, [sp, #4]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2389
	ldr	r3, [sp, #44]
	adds	r7, r3, #1
	beq	.L2390
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
	bne	.L2391
.L2392:
	mov	r3, #-1
	ldrh	r0, [r10]
	str	r3, [sp, #44]
	bl	decrement_vpc_count
.L2400:
	ldr	r7, [sp, #44]
	adds	r0, r7, #1
	beq	.L2382
.L2414:
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L2502+44
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L2405
	ldr	r1, .L2502+48
	movw	r2, #2177
	ldr	r0, .L2502+52
	bl	printf
	ldr	r1, .L2502+56
	ldr	r0, .L2502+60
	bl	printf
.L2405:
	ldr	r3, .L2502+64
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, #0
	beq	.L2406
	mov	r0, r4
	b	.L2496
.L2390:
	ldr	r3, [sp, #52]
	ldr	r2, [sp, #48]
	cmp	r2, r3
	bne	.L2393
	movs	r2, #1
	add	r1, sp, #44
	mov	r0, r4
	bl	log2phys
	b	.L2393
.L2503:
	.align	2
.L2502:
	.word	.LANCHOR117
	.word	.LANCHOR133
	.word	.LANCHOR229
	.word	.LANCHOR230
	.word	.LANCHOR124
	.word	.LANCHOR178
	.word	.LANCHOR36
	.word	.LANCHOR8
	.word	.LANCHOR52
	.word	.LANCHOR51
	.word	.LANCHOR158
	.word	.LANCHOR38
	.word	.LANCHOR228
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR82
.L2391:
	ldr	r1, [r7, #8]
	cmp	r4, r1
	bne	.L2392
	ldr	r8, [r7, #4]
	ldr	r0, .L2504
	mov	r1, r8
	ldr	r0, [r0]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2392
	ldr	r1, [sp, #48]
	ldr	r0, [sp, #52]
	cmp	r1, r0
	bne	.L2395
.L2398:
	ldr	r1, [sp, #44]
	mov	r0, r4
	bl	FtlReUsePrevPpa
	b	.L2392
.L2395:
	ldr	r0, [sp, #44]
	cmp	r1, r0
	beq	.L2392
	adds	r0, r1, #1
	beq	.L2396
	str	r1, [r3, #4]
	movs	r2, #0
	movs	r1, #1
	mov	r0, r3
	ldr	r7, [r3, #12]
	bl	FlashReadPages
.L2397:
	ldr	r3, [r6]
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L2398
	ldr	r3, [r7, #4]
	ldr	r2, .L2504
	mov	r1, r3
	ldr	r0, [r2]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2398
	mov	r1, r3
	mov	r0, r8
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L2392
	b	.L2398
.L2396:
	str	r1, [r2, r5]
	b	.L2397
.L2389:
	ldr	r3, [sp, #52]
	ldr	r2, [sp, #48]
	cmp	r2, r3
	beq	.L2400
	movs	r2, #1
	add	r1, sp, #52
	mov	r0, r4
	bl	log2phys
	ldr	r7, [sp, #48]
	adds	r5, r7, #1
	beq	.L2400
	ldr	r3, [sp, #44]
	cmp	r7, r3
	beq	.L2414
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L2504+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L2404
	ldr	r3, .L2504+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L2404
	ldr	r3, .L2504+12
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L2400
.L2404:
	ldr	r0, [r6]
	movs	r2, #0
	movs	r1, #1
	str	r7, [r0, #4]
	ldr	r5, [r0, #12]
	bl	FlashReadPages
	ldr	r3, [r6]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L2400
	ldr	r1, [r5, #4]
	ldr	r0, [sp, #4]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	bne	.L2400
	movs	r2, #1
	add	r1, sp, #48
	mov	r0, r4
	bl	log2phys
	b	.L2400
.L2406:
	mov	r1, r4
	ldr	r0, .L2504+16
	bl	printf
	b	.L2382
.L2386:
	ldrh	r3, [r10]
	mov	r1, r4
	ldr	r2, .L2504+20
	ldr	r0, .L2504+24
	strh	r3, [r2]	@ movhi
	ldr	r2, [sp, #4]
	bl	printf
	ldr	r2, .L2504+28
	ldr	r3, [r2]
	cmp	r3, #31
	bhi	.L2407
	ldr	r0, [sp, #52]
	ldr	r1, .L2504+32
	str	r0, [r1, r3, lsl #2]
	adds	r3, r3, #1
	str	r3, [r2]
.L2407:
	ldrh	r0, [r10]
	bl	decrement_vpc_count
	ldr	r3, .L2504
	ldr	r2, [r3]
	adds	r1, r2, #1
	bne	.L2408
	ldr	r2, [sp, #4]
.L2495:
	str	r2, [r3]
	b	.L2382
.L2408:
	ldr	r1, [sp, #4]
	cmp	r1, r2
	bcs	.L2382
	mov	r2, r1
	b	.L2495
.L2385:
	ldrb	r3, [sp, #16]	@ zero_extendqisi2
	ldr	r2, [sp, #16]
	strb	r3, [r10, #6]
	ldrh	r3, [sp, #8]
	strh	r3, [r10, #2]	@ movhi
	b	.L2499
.L2505:
	.align	2
.L2504:
	.word	.LANCHOR133
	.word	.LANCHOR90
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LC44
	.word	.LANCHOR229
	.word	.LC45
	.word	.LANCHOR231
	.word	.LANCHOR232
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
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L2533
	movw	r2, #65535
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	mov	r5, r0
	ldrh	r4, [r3]
	str	r3, [sp, #16]
	cmp	r4, r2
	beq	.L2524
	cbnz	r4, .L2507
.L2508:
	bl	FtlGcPageVarInit
	b	.L2509
.L2524:
	movs	r4, #0
.L2507:
	ldr	r3, .L2533+4
	ldrh	r3, [r3]
	cmp	r3, r1
	beq	.L2508
.L2509:
	ldr	fp, .L2533+44
	mov	r3, #-1
	str	r3, [sp, #8]
.L2521:
	ldrh	r2, [r5]
	movw	r3, #65535
	movs	r0, #0
	strb	r0, [r5, #8]
	cmp	r2, r3
	beq	.L2510
.L2523:
	ldr	r3, .L2533+8
	movw	ip, #65535
	ldr	r0, [fp]
	mov	lr, #36
	ldrh	r8, [r3]
	ldr	r3, .L2533+12
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L2533+16
	ldrh	r10, [r3]
	add	r3, r5, #16
	str	r3, [sp, #4]
	movs	r3, #0
	mov	r6, r3
.L2511:
	uxth	r2, r3
	cmp	r8, r2
	bhi	.L2513
	movs	r7, #0
	mov	r10, #36
	movs	r2, #0
	mov	r1, r6
	bl	FlashReadPages
.L2514:
	uxth	r3, r7
	cmp	r6, r3
	bhi	.L2522
	ldr	r3, .L2533+4
	adds	r4, r4, #1
	uxth	r4, r4
	ldrh	r3, [r3]
	cmp	r3, r4
	bhi	.L2523
	movs	r0, #0
	b	.L2510
.L2513:
	ldr	r1, [sp, #4]
	ldrh	r2, [r1], #2
	cmp	r2, ip
	str	r1, [sp, #4]
	beq	.L2512
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
.L2512:
	adds	r3, r3, #1
	b	.L2511
.L2522:
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
	cbnz	r2, .L2515
	ldr	r3, [sp, #12]
	movw	ip, #65535
	adds	r7, r7, #1
	ldr	r3, [r3, #12]
	ldrh	r2, [r3]
	cmp	r2, ip
	bne	.L2516
	ldr	r3, .L2533+20
	movs	r2, #1
	str	r2, [r3]
.L2510:
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
.L2516:
	ldr	r2, [r3, #8]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L2514
.L2515:
	mov	r2, r1
	ldr	r0, .L2533+24
	ldrh	r1, [r5]
	bl	printf
	ldr	r3, .L2533+28
	ldrh	r2, [r5]
	ldr	r3, [r3]
	cbnz	r3, .L2517
	ldr	r3, .L2533+32
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2518
.L2517:
	ldr	r3, .L2533+36
	ldr	r3, [r3]
	ldrh	r3, [r3, r2, lsl #1]
	cmp	r3, #119
	bls	.L2519
.L2518:
	ldr	r3, [fp]
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L2520
.L2519:
	ldr	r3, [fp]
	add	r3, r3, r8
	ldr	r3, [r3, #4]
	str	r3, [sp, #8]
.L2520:
	ldr	r3, .L2533+40
	movs	r4, #0
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5]
	bl	INSERT_FREE_LIST
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
	bl	FtlGcPageVarInit
	b	.L2521
.L2534:
	.align	2
.L2533:
	.word	.LANCHOR233
	.word	.LANCHOR51
	.word	.LANCHOR36
	.word	.LANCHOR105
	.word	.LANCHOR57
	.word	.LANCHOR132
	.word	.LC46
	.word	.LANCHOR101
	.word	.LANCHOR8
	.word	.LANCHOR77
	.word	.LANCHOR82
	.word	.LANCHOR178
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
	ldr	r3, .L2558
	ldr	r3, [r3]
	cbz	r3, .L2536
.L2541:
	movs	r0, #0
.L2535:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2536:
	ldr	r0, .L2558+4
	movw	r3, #65535
	ldr	r5, .L2558+8
	ldrh	r6, [r0]
	mov	r4, r0
	cmp	r6, r3
	beq	.L2538
	ldr	r3, .L2558+12
	ldrh	r1, [r3]
	bl	FtlGcScanTempBlk
	str	r0, [sp, #12]
	adds	r0, r0, #1
	beq	.L2538
	ldr	r3, .L2558+16
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	cmp	r3, #4
	bls	.L2539
	subs	r3, r3, #5
	movs	r0, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	bl	FtlEctTblFlush
.L2539:
	ldr	r3, [r5]
	cbnz	r3, .L2540
	ldr	r2, .L2558+20
	ldr	r0, [sp, #12]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L2540:
	movs	r3, #0
	movs	r0, #1
	str	r3, [r5]
	b	.L2535
.L2538:
	ldrh	r2, [r4]
	movs	r3, #0
	str	r3, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2541
	ldr	r6, .L2558+12
	bl	FtlCacheWriteBack
	ldrb	r0, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r6]
	ldr	r5, .L2558+24
	muls	r2, r0, r2
	ldrh	r1, [r5]
	cmp	r1, r2
	beq	.L2542
	ldr	r1, .L2558+28
	movs	r2, #163
	ldr	r0, .L2558+32
	bl	printf
	ldr	r1, .L2558+36
	ldr	r0, .L2558+40
	bl	printf
.L2542:
	ldrh	r6, [r6]
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldr	r2, .L2558+44
	ldrh	r0, [r4]
	ldr	fp, .L2558+84
	smulbb	r3, r3, r6
	ldr	r1, [r2]
	movs	r6, #0
	str	r2, [sp, #4]
	strh	r3, [r1, r0, lsl #1]	@ movhi
	ldr	r1, .L2558+48
	ldrh	r3, [r5]
	ldr	r0, [r1]
	add	r3, r3, r0
	str	r3, [r1]
.L2543:
	ldrh	r2, [r5]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L2547
	movw	r0, #65535
	bl	decrement_vpc_count
	ldr	r3, .L2558+52
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2548
	ldrh	r1, [r4]
	ldr	r0, .L2558+56
	bl	printf
.L2548:
	ldr	r3, [sp, #4]
	ldrh	r0, [r4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	beq	.L2549
	bl	INSERT_DATA_LIST
.L2550:
	ldr	r3, .L2558+60
	movw	r6, #65535
	strh	r6, [r4]	@ movhi
	movs	r4, #0
	strh	r4, [r5]	@ movhi
	strh	r4, [r3]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	r3, .L2558+64
	ldrh	r2, [r3]
	ldr	r3, .L2558+68
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	cmp	r2, r3, asr #2
	ble	.L2541
	ldr	r3, .L2558+72
	movs	r2, #20
	mov	r0, r4
	strh	r6, [r3]	@ movhi
	ldr	r3, .L2558+76
	strh	r2, [r3]	@ movhi
	b	.L2535
.L2547:
	uxth	r3, r6
	movs	r7, #12
	ldr	r2, [fp]
	muls	r7, r3, r7
	ldr	r3, .L2558+80
	ldr	r8, [r3]
	add	r10, r8, r7
	ldr	r1, [r10, #8]
	cmp	r1, r2
	bcc	.L2544
	ldr	r1, .L2558+28
	movs	r2, #168
	ldr	r0, .L2558+32
	bl	printf
	ldr	r1, .L2558+36
	ldr	r0, .L2558+40
	bl	printf
.L2544:
	movs	r2, #0
	add	r1, sp, #12
	ldr	r0, [r10, #8]
	bl	log2phys
	ldr	r2, [sp, #12]
	ldr	r0, [r8, r7]
	cmp	r0, r2
	bne	.L2545
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	movs	r2, #1
	mov	r7, r0
	add	r1, r10, #4
	ldr	r0, [r10, #8]
	bl	log2phys
	mov	r0, r7
.L2557:
	bl	decrement_vpc_count
.L2546:
	adds	r6, r6, #1
	b	.L2543
.L2545:
	ldr	r3, [r10, #4]
	cmp	r2, r3
	beq	.L2546
	ldrh	r0, [r4]
	b	.L2557
.L2549:
	bl	INSERT_FREE_LIST
	b	.L2550
.L2559:
	.align	2
.L2558:
	.word	.LANCHOR75
	.word	.LANCHOR92
	.word	.LANCHOR132
	.word	.LANCHOR51
	.word	.LANCHOR77
	.word	.LANCHOR136
	.word	.LANCHOR110
	.word	.LANCHOR234
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR82
	.word	.LANCHOR159
	.word	.LANCHOR8
	.word	.LC47
	.word	.LANCHOR109
	.word	.LANCHOR87
	.word	.LANCHOR227
	.word	.LANCHOR201
	.word	.LANCHOR174
	.word	.LANCHOR111
	.word	.LANCHOR71
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
	ldr	r4, .L2563
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L2561
	ldrh	r3, [r4, #4]
	cbnz	r3, .L2562
.L2561:
	bl	FtlCacheWriteBack
	movs	r0, #0
	movs	r5, #0
	bl	FtlGcFreeTempBlock
	ldr	r0, .L2563
	strb	r5, [r4, #8]
	bl	allocate_data_superblock
	ldr	r3, .L2563+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L2563+8
	strh	r5, [r3]	@ movhi
	bl	l2p_flush
	mov	r0, r5
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L2562:
	ldr	r0, .L2563
	pop	{r3, r4, r5, lr}
	b	get_new_active_ppa
.L2564:
	.align	2
.L2563:
	.word	.LANCHOR92
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
	ldr	r3, .L2582
	ldr	r5, .L2582+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2566
	ldr	r3, [r5]
	lsls	r2, r3, #31
	bpl	.L2566
	ldr	r3, .L2582+8
	ldrh	r3, [r3, #4]
	cbz	r3, .L2566
.L2571:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L2566:
	ldr	r4, .L2582+12
	movs	r3, #0
	movs	r6, #0
	movs	r7, #36
	mov	r2, r3
	ldr	r1, [r5]
	ldr	r0, [r4]
	bl	FlashProgPages
.L2568:
	ldr	r1, [r5]
	uxth	r3, r6
	cmp	r3, r1
	bcc	.L2570
	ldr	r0, [r4]
	bl	FtlGcBufFree
	movs	r3, #0
	str	r3, [r5]
	ldr	r3, .L2582+8
	ldrh	r3, [r3, #4]
	cmp	r3, #0
	bne	.L2571
	movs	r0, #1
	bl	FtlGcFreeTempBlock
	b	.L2581
.L2570:
	muls	r3, r7, r3
	ldr	r2, [r4]
	adds	r6, r6, #1
	adds	r1, r2, r3
	ldr	r2, [r2, r3]
	adds	r3, r2, #1
	bne	.L2569
	ldr	r3, .L2582+8
	movs	r5, #0
	ldr	r0, .L2582+16
	ldrh	r4, [r3]
	ldr	r0, [r0]
	strh	r5, [r0, r4, lsl #1]	@ movhi
	strh	r2, [r3]	@ movhi
	ldr	r2, .L2582+20
	ldr	r0, [r1, #4]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
.L2581:
	movs	r0, #1
	pop	{r3, r4, r5, r6, r7, pc}
.L2569:
	ldr	r3, [r1, #12]
	ldr	r1, [r1, #4]
	ldr	r2, [r3, #8]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L2568
.L2583:
	.align	2
.L2582:
	.word	.LANCHOR8
	.word	.LANCHOR102
	.word	.LANCHOR92
	.word	.LANCHOR179
	.word	.LANCHOR82
	.word	.LANCHOR136
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
	ldr	r4, .L2586
	ldr	r5, .L2586+4
	ldrh	r1, [r4]
	mov	r0, r5
	bl	FtlGcScanTempBlk
	ldrh	r2, [r5, #2]
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L2584
	ldr	r0, .L2586+8
	bl	FtlMapBlkWriteDumpData
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r3, .L2586+12
	movs	r2, #0
	str	r2, [r3]
.L2584:
	pop	{r3, r4, r5, pc}
.L2587:
	.align	2
.L2586:
	.word	.LANCHOR51
	.word	.LANCHOR92
	.word	.LANCHOR124
	.word	.LANCHOR132
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
	ldr	r5, .L2589
	ldr	r3, .L2589+4
	mov	r0, r5
	str	r4, [r3]
	bl	FtlRecoverySuperblock
	mov	r0, r5
	ldr	r5, .L2589+8
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
.L2590:
	.align	2
.L2589:
	.word	.LANCHOR90
	.word	.LANCHOR231
	.word	.LANCHOR91
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
	ldr	r4, .L2601
	movw	r5, #65535
	strh	r3, [r4]	@ movhi
	ldr	r3, .L2601+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L2601+8
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	ldr	r3, .L2601+12
	ldrh	r3, [r3]
	cmp	r3, r5
	bne	.L2592
.L2594:
	mov	r6, #-1
.L2591:
	mov	r0, r6
	pop	{r3, r4, r5, r6, r7, pc}
.L2592:
	bl	FtlLoadSysInfo
	mov	r6, r0
	cmp	r0, #0
	bne	.L2594
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	movs	r0, #1
	bl	FtlUpdateVaildLpn
	ldr	r3, .L2601+16
	movs	r0, #12
	ldrh	r2, [r3]
	ldr	r3, .L2601+20
	ldr	r1, [r3]
	mov	r3, r6
.L2595:
	cmp	r3, r2
	blt	.L2597
	ldrh	r3, [r4]
	cmp	r3, #0
	beq	.L2591
.L2596:
	ldr	r5, .L2601+24
	ldr	r4, .L2601+28
	mov	r0, r5
	bl	FtlSuperblockPowerLostFix
	mov	r0, r4
	bl	FtlSuperblockPowerLostFix
	ldr	r3, .L2601+32
	ldrh	r1, [r5]
	ldrh	r0, [r5, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	ldr	r0, .L2601+36
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldrh	r7, [r4, #4]
	ldrh	r3, [r0]
	strh	r3, [r5, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r5, #6]
	strh	r3, [r5, #4]	@ movhi
	ldrh	r5, [r4]
	ldrh	r1, [r2, r5, lsl #1]
	subs	r1, r1, r7
	strh	r1, [r2, r5, lsl #1]	@ movhi
	ldrh	r2, [r0]
	ldr	r0, .L2601+40
	strb	r3, [r4, #6]
	strh	r2, [r4, #2]	@ movhi
	strh	r3, [r4, #4]	@ movhi
	bl	FtlMapBlkWriteDumpData
	ldr	r0, .L2601+44
	bl	FtlMapBlkWriteDumpData
	ldr	r2, .L2601+48
	ldrh	r3, [r2, #30]
	adds	r3, r3, #1
	strh	r3, [r2, #30]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	bl	FtlVpcTblFlush
	b	.L2591
.L2597:
	mla	r5, r0, r3, r1
	ldr	r5, [r5, #4]
	cmp	r5, #0
	blt	.L2596
	adds	r3, r3, #1
	b	.L2595
.L2602:
	.align	2
.L2601:
	.word	.LANCHOR230
	.word	.LANCHOR229
	.word	.LANCHOR37
	.word	.LANCHOR206
	.word	.LANCHOR66
	.word	.LANCHOR95
	.word	.LANCHOR90
	.word	.LANCHOR91
	.word	.LANCHOR82
	.word	.LANCHOR51
	.word	.LANCHOR124
	.word	.LANCHOR215
	.word	.LANCHOR135
	.size	FtlSysBlkInit, .-FtlSysBlkInit
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
	ldr	r3, .L2693
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r2, [r3]
	cmp	r2, #0
	bne	.L2655
	ldr	r3, .L2693+4
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2655
	ldr	r2, .L2693+8
	ldrh	r2, [r2]
	cmp	r2, #47
	bls	.L2657
	ldr	r3, .L2693+12
	movw	r5, #65535
	ldrh	r4, [r3]
	cmp	r4, r5
	beq	.L2605
	ldr	r1, .L2693+16
	ldrh	r2, [r1]
	cmp	r2, r5
	itt	eq
	strheq	r4, [r1]	@ movhi
	strheq	r2, [r3]	@ movhi
.L2605:
	cmp	r0, #0
	bne	.L2658
	ldr	r3, .L2693+20
	ldrh	r3, [r3]
	cmp	r3, #24
	bhi	.L2659
	ldr	r2, .L2693+24
	cmp	r3, #16
	ldrh	r4, [r2]
	bls	.L2608
	lsrs	r4, r4, #5
.L2607:
	ldr	r2, .L2693+28
	ldrh	r1, [r2]
	cmp	r1, r3
	mov	r1, r2
	bcs	.L2611
	ldr	r3, .L2693+32
	movw	r0, #65535
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L2612
	ldr	r0, .L2693+16
	ldrh	r0, [r0]
	cmp	r0, r3
	bne	.L2612
	ldr	r3, .L2693+36
	ldrh	r0, [r3]
	cbnz	r0, .L2613
	ldr	r3, .L2693+40
	ldr	r4, .L2693+44
	ldr	r3, [r3]
	ldr	r4, [r4]
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, lsr #2
	bcs	.L2614
.L2613:
	ldr	r3, .L2693+48
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L2615:
	ldr	r3, .L2693+52
	movs	r2, #0
	str	r2, [r3]
.L2603:
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2608:
	cmp	r3, #12
	bls	.L2609
	lsrs	r4, r4, #4
	b	.L2607
.L2609:
	cmp	r3, #8
	bls	.L2607
	lsrs	r4, r4, #2
	b	.L2607
.L2659:
	movs	r4, #1
	b	.L2607
.L2614:
	movs	r3, #18
	strh	r3, [r2]	@ movhi
	b	.L2615
.L2612:
	ldr	r3, .L2693+48
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L2611:
	ldr	r3, .L2693+56
	ldrh	r3, [r3]
	cbz	r3, .L2606
	adds	r4, r4, #32
	uxth	r4, r4
.L2606:
	ldr	r5, .L2693+60
	movw	r3, #65535
	ldrh	r2, [r5]
	cmp	r2, r3
	bne	.L2618
	ldr	r3, .L2693+16
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L2619
	ldr	r0, .L2693+64
	ldr	r0, [r0]
	ldrh	r1, [r0, r1, lsl #1]
	cbnz	r1, .L2620
	strh	r2, [r3]	@ movhi
.L2620:
	ldrh	r2, [r3]
	strh	r2, [r5]	@ movhi
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
.L2619:
	ldrh	r0, [r5]
	movw	r6, #65535
	movs	r3, #0
	strb	r3, [r5, #8]
	cmp	r0, r6
	beq	.L2618
	bl	IsBlkInGcList
	cbz	r0, .L2622
	strh	r6, [r5]	@ movhi
.L2622:
	ldr	r3, .L2693+68
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2623
	ldrh	r0, [r5]
	bl	ftl_get_blk_mode
	strb	r0, [r5, #8]
.L2623:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L2618
	ldr	r0, .L2693+60
	bl	make_superblock
	ldr	r2, .L2693+72
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r3, [r2]	@ movhi
	ldr	r3, .L2693+64
	ldrh	r2, [r5]
	ldr	r3, [r3]
	ldrh	r2, [r3, r2, lsl #1]
	ldr	r3, .L2693+76
	strh	r2, [r3]	@ movhi
.L2618:
	ldr	r2, .L2693+80
	ldrh	r3, [r5]
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L2624
	ldr	r2, .L2693+84
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L2624
	ldr	r6, .L2693+60
	mov	r5, r6
.L2625:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L2626
	ldr	r10, .L2693+92
	movs	r2, #0
	ldr	r3, .L2693+52
	mov	r7, r10
	str	r2, [r3]
.L2627:
	ldrh	r8, [r10]
	mov	r0, r8
	bl	List_get_gc_head_node
	uxth	fp, r0
	movw	r3, #65535
	cmp	fp, r3
	strh	fp, [r5]	@ movhi
	bne	.L2628
	movs	r3, #0
	movs	r0, #8
	strh	r3, [r10]	@ movhi
	b	.L2603
.L2658:
	movs	r4, #1
	b	.L2606
.L2624:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L2691:
	ldr	r3, .L2693+36
	ldrh	r0, [r3]
	b	.L2603
.L2628:
	str	r0, [sp]
	mov	r0, fp
	bl	IsBlkInGcList
	add	r3, r8, #1
	ldr	r2, [sp]
	cbz	r0, .L2629
	strh	r3, [r10]	@ movhi
	b	.L2627
.L2629:
	ldr	r1, .L2693+24
	uxth	r3, r3
	ldr	lr, .L2693+96
	uxth	r2, r2
	ldr	r8, .L2693+64
	ldrh	r1, [r1]
	ldrh	lr, [lr]
	ldr	r0, [r8]
	strh	r3, [r10]	@ movhi
	mul	r1, lr, r1
	ldrh	ip, [r0, r2, lsl #1]
	cmp	ip, r1, asr #1
	bgt	.L2631
	cmp	r3, #48
	bls	.L2632
	cmp	ip, #8
	bls	.L2632
	ldr	r3, .L2693+88
	ldrh	r3, [r3]
	cmp	r3, #35
	bhi	.L2632
.L2631:
	movs	r3, #0
	strh	r3, [r7]	@ movhi
.L2632:
	ldrh	r3, [r0, r2, lsl #1]
	cmp	r1, r3
	bgt	.L2633
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
	movs	r3, #0
	strh	r3, [r7]	@ movhi
	b	.L2691
.L2633:
	cbnz	r3, .L2634
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r3, [r7]
	adds	r3, r3, #1
	strh	r3, [r7]	@ movhi
	b	.L2627
.L2694:
	.align	2
.L2693:
	.word	.LANCHOR75
	.word	.LANCHOR169
	.word	.LANCHOR84
	.word	.LANCHOR113
	.word	.LANCHOR112
	.word	.LANCHOR87
	.word	.LANCHOR51
	.word	.LANCHOR174
	.word	.LANCHOR92
	.word	.LANCHOR235
	.word	.LANCHOR71
	.word	.LANCHOR99
	.word	.LANCHOR227
	.word	.LANCHOR170
	.word	.LANCHOR114
	.word	.LANCHOR201
	.word	.LANCHOR82
	.word	.LANCHOR8
	.word	.LANCHOR236
	.word	.LANCHOR237
	.word	.LANCHOR90
	.word	.LANCHOR91
	.word	.LANCHOR109
	.word	.LANCHOR176
	.word	.LANCHOR36
.L2634:
	movs	r3, #0
	strb	r3, [r5, #8]
	ldr	r3, .L2695
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2635
	mov	r0, fp
	bl	ftl_get_blk_mode
	strb	r0, [r5, #8]
.L2635:
	ldr	r3, .L2695+4
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L2636
	ldr	r1, .L2695+8
	movw	r2, #835
	ldr	r0, .L2695+12
	bl	printf
	ldr	r1, .L2695+16
	ldr	r0, .L2695+20
	bl	printf
.L2636:
	ldr	r3, .L2695+24
	ldrh	r2, [r5]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2637
	ldr	r1, .L2695+8
	mov	r2, #836
	ldr	r0, .L2695+12
	bl	printf
	ldr	r1, .L2695+16
	ldr	r0, .L2695+20
	bl	printf
.L2637:
	ldr	r3, .L2695+28
	ldrh	r2, [r5]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L2638
	ldr	r1, .L2695+8
	movw	r2, #837
	ldr	r0, .L2695+12
	bl	printf
	ldr	r1, .L2695+16
	ldr	r0, .L2695+20
	bl	printf
.L2638:
	mov	r0, r6
	bl	make_superblock
	ldr	r2, .L2695+32
	movs	r3, #0
	ldrh	r1, [r5]
	strh	r3, [r2]	@ movhi
	ldr	r2, [r8]
	ldrh	r1, [r2, r1, lsl #1]
	ldr	r2, .L2695+36
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r1, [r2]	@ movhi
.L2626:
	ldr	r3, .L2695+40
	movs	r2, #1
	str	r2, [r3]
	ldr	r3, .L2695+44
	ldrh	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, .L2695
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2639
	ldrb	r3, [r5, #8]	@ zero_extendqisi2
	cmp	r3, r2
	ittt	eq
	ldreq	r3, .L2695+48
	ldrheq	r3, [r3]
	streq	r3, [sp, #4]
.L2639:
	ldrh	r3, [r5, #2]
	ldr	r1, [sp, #4]
	ldr	fp, .L2695+80
	adds	r2, r3, r4
	cmp	r2, r1
	itt	gt
	movgt	r2, r1
	subgt	r4, r2, r3
	mov	r3, #0
	it	gt
	uxthgt	r4, r4
	str	r3, [sp, #12]
.L2641:
	ldrh	r3, [sp, #12]
	cmp	r4, r3
	bls	.L2649
	ldr	r3, .L2695+52
	movw	r8, #65535
	ldrh	lr, [r6, #2]
	mov	r10, #36
	ldr	r0, [fp]
	ldrh	r7, [r3]
	ldr	r3, [sp, #12]
	add	lr, lr, r3
	ldr	r3, .L2695+56
	str	r3, [sp, #8]
	movs	r3, #0
	str	r3, [sp]
	b	.L2650
.L2643:
	ldr	r1, [sp, #8]
	ldrh	r2, [r1, #2]!
	cmp	r2, r8
	str	r1, [sp, #8]
	beq	.L2642
	ldr	r1, [sp]
	orr	r2, lr, r2, lsl #10
	mla	ip, r10, r1, r0
	str	r2, [ip, #4]
	mov	r2, r1
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp]
.L2642:
	adds	r3, r3, #1
.L2650:
	uxth	r2, r3
	cmp	r2, r7
	bcc	.L2643
	ldrb	r2, [r6, #8]	@ zero_extendqisi2
	ldr	r1, [sp]
	bl	FlashReadPages
	movs	r3, #0
.L2690:
	str	r3, [sp, #8]
	ldr	r2, [sp]
	ldrh	r3, [sp, #8]
	cmp	r2, r3
	bhi	.L2648
	ldr	r3, [sp, #12]
	adds	r3, r3, #1
	str	r3, [sp, #12]
	b	.L2641
.L2648:
	ldr	r3, [sp, #8]
	movs	r7, #36
	muls	r7, r3, r7
	ldr	r3, [fp]
	adds	r2, r3, r7
	ldr	r3, [r3, r7]
	adds	r3, r3, #1
	beq	.L2645
	ldr	r8, [r2, #12]
	movw	r3, #61589
	ldrh	r2, [r8]
	cmp	r2, r3
	bne	.L2645
	ldr	r10, [r8, #8]
	cmp	r10, #-1
	bne	.L2646
	ldr	r1, .L2695+8
	mov	r2, #876
	ldr	r0, .L2695+12
	bl	printf
	ldr	r1, .L2695+16
	ldr	r0, .L2695+20
	bl	printf
.L2646:
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r10
	bl	log2phys
	ldr	r0, [fp]
	ldr	r3, [sp, #28]
	add	r0, r0, r7
	ldr	r2, [r0, #4]
	bic	r3, r3, #-2147483648
	cmp	r3, r2
	bne	.L2645
	ldr	r2, .L2695+32
	ldr	r1, .L2695+60
	ldr	r10, .L2695+68
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
	ldr	r7, .L2695+28
	ldr	r1, [r0, #8]
	adds	r3, r3, #1
	str	r1, [r2, #8]
	ldr	r1, [r0, #12]
	str	r1, [r2, #12]
	movs	r1, #1
	ldr	r2, [sp, #28]
	str	r2, [r8, #12]
	ldrh	r2, [r7]
	strh	r2, [r8, #2]	@ movhi
	ldr	r2, .L2695+64
	str	r3, [r10]
	ldr	r2, [r2]
	str	r2, [r8, #4]
	bl	FtlGcBufAlloc
	ldr	r3, .L2695
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbnz	r3, .L2647
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldr	r3, [r10]
	cmp	r2, r3
	beq	.L2647
	ldrh	r3, [r7, #4]
	cbnz	r3, .L2645
.L2647:
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L2645
.L2692:
	ldr	r3, .L2695+40
	movs	r2, #0
	str	r2, [r3]
	b	.L2691
.L2645:
	ldr	r3, [sp, #8]
	adds	r3, r3, #1
	b	.L2690
.L2649:
	ldrh	r3, [r6, #2]
	add	r4, r4, r3
	ldr	r3, [sp, #4]
	uxth	r4, r4
	cmp	r3, r4
	strh	r4, [r6, #2]	@ movhi
	bhi	.L2651
	ldr	r3, .L2695+68
	ldr	r3, [r3]
	cbz	r3, .L2652
	bl	Ftl_gc_temp_data_write_back
	cmp	r0, #0
	bne	.L2692
.L2652:
	ldr	r3, .L2695+32
	ldrh	r1, [r3]
	cbnz	r1, .L2653
	ldr	r3, .L2695+72
	ldrh	r2, [r6]
	ldr	r3, [r3]
	ldrh	r0, [r3, r2, lsl #1]
	cbz	r0, .L2653
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r6]
	bl	update_vpc_list
	bl	FtlCacheWriteBack
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L2653:
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
.L2651:
	ldr	r3, .L2695+76
	ldrh	r0, [r3]
	cmp	r0, #2
	bhi	.L2654
	ldr	r3, .L2695+44
	ldrh	r4, [r3]
	b	.L2625
.L2654:
	ldr	r3, .L2695+40
	movs	r2, #0
	adds	r0, r0, #1
	str	r2, [r3]
	b	.L2603
.L2655:
	movs	r0, #0
	b	.L2603
.L2657:
	mov	r0, r3
	b	.L2603
.L2696:
	.align	2
.L2695:
	.word	.LANCHOR8
	.word	.LANCHOR90
	.word	.LANCHOR238
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR236
	.word	.LANCHOR237
	.word	.LANCHOR169
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR36
	.word	.LANCHOR201+14
	.word	.LANCHOR179
	.word	.LANCHOR158
	.word	.LANCHOR102
	.word	.LANCHOR82
	.word	.LANCHOR87
	.word	.LANCHOR106
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
	ldr	r4, .L2706
	mov	r5, r0
	ldr	r2, .L2706+4
	str	r3, [r4]
	movs	r3, #0
	ldr	r1, .L2706+8
	str	r3, [r2]
	ldr	r2, .L2706+12
	ldr	r0, .L2706+16
	str	r3, [r2]
	bl	printf
	mov	r0, r5
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	ldr	r3, .L2706+20
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L2698
	ldr	r1, .L2706+24
	ldr	r0, .L2706+28
.L2705:
	bl	printf
.L2699:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L2698:
	bl	FtlSysBlkInit
	cbz	r0, .L2700
	ldr	r1, .L2706+24
	ldr	r0, .L2706+32
	b	.L2705
.L2700:
	movs	r1, #1
	str	r1, [r4]
	bl	rk_ftl_garbage_collect
	ldr	r3, .L2706+36
	ldrh	r3, [r3]
	cmp	r3, #15
	bhi	.L2699
	mov	r4, #1024
.L2702:
	movs	r1, #1
	mov	r0, r1
	bl	rk_ftl_garbage_collect
	subs	r4, r4, #1
	bne	.L2702
	b	.L2699
.L2707:
	.align	2
.L2706:
	.word	.LANCHOR223
	.word	.LANCHOR239
	.word	.LC48
	.word	.LANCHOR75
	.word	.LC6
	.word	.LANCHOR37
	.word	.LANCHOR240
	.word	.LC49
	.word	.LC50
	.word	.LANCHOR87
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
	cbnz	r0, .L2709
	ldr	r0, .L2710
	bl	FtlInit
.L2709:
	mov	r1, r4
	ldr	r0, .L2710+4
	bl	printf
	mov	r0, r4
	pop	{r4, pc}
.L2711:
	.align	2
.L2710:
	.word	.LANCHOR15
	.word	.LC51
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
	ldr	r3, .L2726
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L2712
	ldr	r7, .L2726+4
	ldr	r6, .L2726+8
	ldr	r10, .L2726+32
	ldrh	r5, [r7]
	ldr	r3, [r6]
	ldr	r4, .L2726+12
	mov	r1, r5
	ldr	r0, .L2726+16
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
.L2714:
	subs	r4, r4, #1
	beq	.L2718
	movs	r1, #1
	mov	r0, r1
	bl	rk_ftl_garbage_collect
	ldr	r3, [r6]
	ldrh	r3, [r3, r8]
	cmp	r3, #0
	bne	.L2714
.L2718:
	ldr	r3, [r6]
	mov	r1, r5
	ldr	r0, .L2726+16
	ldrh	r2, [r3, r5, lsl #1]
	bl	printf
	ldr	r3, [r6]
	ldrh	r4, [r3, r5, lsl #1]
	cbnz	r4, .L2716
	add	r0, sp, #56
	ldr	r7, .L2726+20
	strh	r5, [r0, #-48]!	@ movhi
	movw	r10, #65535
	bl	make_superblock
	ldr	r3, .L2726+24
	add	r0, sp, #22
	ldr	r8, [r7]
	mov	r2, r4
	mov	fp, #36
	mov	ip, r4
	ldrh	lr, [r3]
.L2719:
	uxth	r3, r2
	cmp	lr, r3
	bhi	.L2721
	ldr	r3, [r6]
	mov	r1, r5
	ldr	r0, .L2726+28
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
.L2716:
	ldr	r2, [sp, #4]
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L2712:
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2721:
	ldrh	r3, [r0, #2]!
	cmp	r3, r10
	beq	.L2720
	mla	r1, fp, r4, r8
	adds	r4, r4, #1
	lsls	r3, r3, #10
	uxth	r4, r4
	str	r3, [r1, #4]
	str	ip, [r1, #8]
	str	ip, [r1, #12]
.L2720:
	adds	r2, r2, #1
	b	.L2719
.L2727:
	.align	2
.L2726:
	.word	.LANCHOR8
	.word	.LANCHOR229
	.word	.LANCHOR82
	.word	.LANCHOR91
	.word	.LC52
	.word	.LANCHOR76
	.word	.LANCHOR36
	.word	.LC53
	.word	.LANCHOR90
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
	sub	sp, sp, #64
	mov	r6, r1
	mov	r7, r3
	str	r2, [sp, #28]
	bne	.L2729
	mov	r2, r3
	ldr	r1, [sp, #28]
	add	r0, r6, #256
	bl	FtlVendorPartRead
	str	r0, [sp, #8]
.L2728:
	ldr	r0, [sp, #8]
	add	sp, sp, #64
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2729:
	ldr	r3, [sp, #28]
	adds	r3, r1, r3
	str	r3, [sp, #12]
	ldr	r3, .L2766
	ldr	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L2751
	ldr	r3, .L2766+4
	ldr	r3, [r3]
	adds	r4, r3, #1
	beq	.L2752
	bl	FtlCacheWriteBack
	ldr	r3, .L2766+8
	mov	r0, r6
	ldr	r8, .L2766+48
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	ldr	r3, [sp, #12]
	mov	r1, r4
	str	r0, [sp, #16]
	subs	r0, r3, #1
	bl	__aeabi_uidiv
	ldr	r3, [sp, #16]
	ldr	r2, .L2766+12
	ldr	r4, [sp, #16]
	rsb	r3, r3, #1
	str	r0, [sp, #20]
	add	r3, r3, r0
	str	r3, [sp, #4]
	ldr	r1, [sp, #4]
	ldr	r3, [r2]
	add	r3, r3, r1
	str	r3, [r2]
	movs	r3, #0
	mov	r5, r3
	str	r3, [sp]
	str	r3, [sp, #24]
	str	r3, [sp, #8]
.L2731:
	ldr	r3, [sp, #4]
	cbnz	r3, .L2750
	ldr	r3, .L2766+16
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L2728
	movs	r1, #1
	ldr	r0, [sp, #4]
	bl	rk_ftl_garbage_collect
	b	.L2728
.L2750:
	movs	r2, #0
	add	r1, sp, #60
	mov	r0, r4
	bl	log2phys
	ldr	r3, [sp, #60]
	adds	r0, r3, #1
	bne	.L2732
	ldr	fp, .L2766+8
	mov	r10, #0
.L2733:
	ldrh	r0, [fp]
	cmp	r10, r0
	bcc	.L2735
.L2736:
	ldr	r3, [sp, #4]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #4]
	beq	.L2740
	ldr	r3, .L2766+20
	ldrh	r3, [r3]
	cmp	r5, r3, lsl #2
	bne	.L2731
.L2740:
	cmp	r5, #0
	beq	.L2731
	movs	r2, #0
	mov	r1, r5
	ldr	r0, [r8]
	mov	r10, #0
	bl	FlashReadPages
	ldr	r3, [sp]
	lsls	r3, r3, #9
	str	r3, [sp, #44]
	ldr	r3, [sp, #32]
	lsls	r3, r3, #9
	str	r3, [sp, #36]
	ldr	r3, [sp, #24]
	lsls	r3, r3, #9
	str	r3, [sp, #40]
.L2749:
	mov	fp, #36
	ldr	r3, [r8]
	mul	fp, fp, r10
	ldr	r1, [sp, #16]
	add	r3, r3, fp
	ldr	r2, [r3, #16]
	cmp	r1, r2
	bne	.L2742
	ldr	r1, [r3, #8]
	ldr	r3, .L2766+24
	ldr	r3, [r3]
	cmp	r1, r3
	bne	.L2743
	ldr	r3, [sp, #36]
	mov	r0, r7
	ldr	r2, [sp, #40]
	add	r1, r1, r3
.L2765:
	bl	ftl_memcpy
.L2743:
	ldr	r3, [r8]
	add	r2, r3, fp
	ldr	r3, [r3, fp]
	adds	r1, r3, #1
	bne	.L2744
	ldr	r1, .L2766+28
	str	r3, [sp, #8]
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L2745:
	add	r10, r10, #1
	cmp	r5, r10
	bne	.L2749
	movs	r5, #0
	b	.L2731
.L2735:
	mla	r0, r0, r4, r10
	cmp	r6, r0
	bhi	.L2734
	ldr	r3, [sp, #12]
	cmp	r3, r0
	bls	.L2734
	subs	r0, r0, r6
	mov	r2, #512
	movs	r1, #0
	add	r0, r7, r0, lsl #9
	bl	ftl_memset
.L2734:
	add	r10, r10, #1
	b	.L2733
.L2732:
	ldr	r2, [r8]
	mov	r10, #36
	mla	r10, r10, r5, r2
	str	r3, [r10, #4]
	ldr	r3, [sp, #16]
	cmp	r4, r3
	ldr	r3, .L2766+8
	bne	.L2737
	ldr	r2, .L2766+24
	mov	r0, r6
	ldrh	fp, [r3]
	ldr	r2, [r2]
	mov	r1, fp
	str	r2, [r10, #8]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #28]
	sub	r3, fp, r1
	str	r1, [sp, #32]
	cmp	r3, r2
	it	cs
	movcs	r3, r2
	cmp	fp, r3
	str	r3, [sp, #24]
	bne	.L2738
	str	r7, [r10, #8]
.L2738:
	ldr	r3, .L2766+32
	ldr	r2, .L2766+36
	str	r4, [r10, #16]
	ldrh	r3, [r3]
	ldr	r2, [r2]
	muls	r3, r5, r3
	adds	r5, r5, #1
	bic	r3, r3, #3
	add	r3, r3, r2
	str	r3, [r10, #12]
	b	.L2736
.L2737:
	ldr	r2, [sp, #20]
	cmp	r4, r2
	bne	.L2739
	ldr	r2, .L2766+40
	ldr	r1, [sp, #12]
	ldr	r2, [r2]
	str	r2, [r10, #8]
	ldrh	r2, [r3]
	mul	r3, r2, r4
	subs	r1, r1, r3
	cmp	r2, r1
	str	r1, [sp]
	bne	.L2738
.L2764:
	subs	r3, r3, r6
	add	r3, r7, r3, lsl #9
	str	r3, [r10, #8]
	b	.L2738
.L2739:
	ldrh	r3, [r3]
	muls	r3, r4, r3
	b	.L2764
.L2742:
	ldr	r1, [sp, #20]
	cmp	r1, r2
	bne	.L2743
	ldr	r1, [r3, #8]
	ldr	r3, .L2766+40
	ldr	r3, [r3]
	cmp	r1, r3
	bne	.L2743
	ldr	r3, .L2766+8
	ldr	r2, [sp, #44]
	ldrh	r0, [r3]
	ldr	r3, [sp, #20]
	muls	r0, r3, r0
	subs	r0, r0, r6
	add	r0, r7, r0, lsl #9
	b	.L2765
.L2744:
	cmp	r3, #256
	bne	.L2745
	ldr	r0, [r2, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	mov	fp, r0
	bl	FtlGcRefreshBlock
	ldr	r2, .L2766+44
	movw	r3, #2049
.L2747:
	subs	r3, r3, #1
	bne	.L2746
.L2748:
	bl	FtlSysFlush
	b	.L2745
.L2746:
	movs	r1, #1
	str	r2, [sp, #52]
	mov	r0, r1
	str	r3, [sp, #48]
	bl	rk_ftl_garbage_collect
	ldr	r2, [sp, #52]
	ldr	r3, [sp, #48]
	ldrh	r1, [r2]
	cmp	r1, fp
	beq	.L2747
	b	.L2748
.L2751:
	mov	r3, #-1
.L2752:
	str	r3, [sp, #8]
	b	.L2728
.L2767:
	.align	2
.L2766:
	.word	.LANCHOR67
	.word	.LANCHOR223
	.word	.LANCHOR54
	.word	.LANCHOR164
	.word	.LANCHOR114
	.word	.LANCHOR36
	.word	.LANCHOR183
	.word	.LANCHOR136
	.word	.LANCHOR57
	.word	.LANCHOR186
	.word	.LANCHOR184
	.word	.LANCHOR201
	.word	.LANCHOR178
	.size	ftl_read, .-ftl_read
	.section	.text.ftl_write,"ax",%progbits
	.align	1
	.global	ftl_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_write, %function
ftl_write:
	@ args = 0, pretend = 0, frame = 80
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r0, #16
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #80
	mov	r7, r1
	str	r2, [sp, #12]
	str	r3, [sp, #4]
	bne	.L2769
	mov	r2, r3
	ldr	r1, [sp, #12]
	add	r0, r7, #256
	bl	FtlVendorPartWrite
.L2768:
	add	sp, sp, #80
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2769:
	ldr	r3, [sp, #12]
	adds	r5, r1, r3
	ldr	r3, .L2823
	ldr	r3, [r3]
	cmp	r5, r3
	bhi	.L2803
	ldr	r3, .L2823+4
	ldr	r0, [r3]
	adds	r4, r0, #1
	beq	.L2768
	ldr	r3, .L2823+8
	mov	r2, #2048
	mov	r0, r7
	str	r2, [r3]
	ldr	r3, .L2823+12
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	mov	r1, r4
	mov	r10, r0
	subs	r0, r5, #1
	bl	__aeabi_uidiv
	ldr	r2, .L2823+16
	sub	r5, r0, r10
	adds	r3, r5, #1
	adds	r1, r5, #1
	str	r3, [sp, #8]
	ldr	r3, [r2]
	str	r0, [sp, #20]
	add	r3, r3, r1
	str	r3, [r2]
	ldr	r3, .L2823+20
	ldr	r8, [r3]
	cmp	r8, #0
	beq	.L2771
	ldr	r3, [r8, #16]
	cmp	r10, r3
	beq	.L2772
	bl	FtlCacheWriteBack
.L2771:
	ldr	r5, .L2823+24
	mov	r4, r10
.L2773:
	ldr	r3, [sp, #8]
	cmp	r3, #0
	beq	.L2802
	ldr	r6, .L2823+28
	ldrb	r2, [r5, #6]	@ zero_extendqisi2
	ldrh	r3, [r6]
	cmp	r2, r3
	bcc	.L2774
	ldr	r1, .L2823+32
	movw	r2, #1630
	ldr	r0, .L2823+36
	bl	printf
	ldr	r1, .L2823+40
	ldr	r0, .L2823+44
	bl	printf
.L2774:
	ldrh	r3, [r5, #4]
	cbnz	r3, .L2775
	bl	FtlCacheWriteBack
	mov	r0, r5
	bl	allocate_new_data_superblock
.L2775:
	ldrb	r3, [r5, #7]	@ zero_extendqisi2
	ldrh	r2, [r5, #4]
	lsls	r3, r3, #2
	cmp	r3, r2
	it	cs
	movcs	r3, r2
	ldr	r2, [sp, #8]
	cmp	r3, r2
	it	cs
	movcs	r3, r2
	ldrb	r2, [r5, #6]	@ zero_extendqisi2
	str	r3, [sp, #36]
	ldrh	r3, [r6]
	cmp	r2, r3
	bcc	.L2776
	ldr	r1, .L2823+32
	movw	r2, #1663
	ldr	r0, .L2823+36
	bl	printf
	ldr	r1, .L2823+40
	ldr	r0, .L2823+44
	bl	printf
.L2776:
	mov	r8, #0
.L2777:
	ldr	r3, [sp, #36]
	cmp	r8, r3
	bne	.L2798
.L2778:
	ldr	r3, .L2823+20
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L2799
	ldr	r3, [sp, #8]
	subs	r8, r8, #1
	add	r3, r3, #-1
	str	r3, [sp, #8]
	bne	.L2799
.L2802:
	ldr	r3, [sp, #20]
	movs	r0, #0
	sub	r1, r3, r10
	bl	rk_ftl_garbage_collect
	movs	r0, #0
	b	.L2768
.L2772:
	ldr	r2, .L2823+48
	mov	r1, r4
	mov	r0, r7
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #12]
	subs	r4, r4, r1
	ldr	r0, [r8, #8]
	mov	r3, r1
	ldr	r1, [sp, #4]
	cmp	r4, r2
	it	cs
	movcs	r4, r2
	lsls	r6, r4, #9
	add	r0, r0, r3, lsl #9
	mov	r2, r6
	bl	ftl_memcpy
	cmp	r5, #0
	beq	.L2805
	ldr	r3, [sp, #12]
	add	r7, r7, r4
	add	r10, r10, #1
	subs	r3, r3, r4
	str	r3, [sp, #12]
	ldr	r3, [sp, #4]
	add	r3, r3, r6
	str	r3, [sp, #4]
	bl	FtlCacheWriteBack
	str	r5, [sp, #8]
	b	.L2771
.L2798:
	ldrh	r3, [r5, #4]
	cmp	r3, #0
	beq	.L2778
	movs	r2, #0
	add	r1, sp, #40
	mov	r0, r4
	movs	r6, #36
	bl	log2phys
	mov	r0, r5
	mul	r6, r6, r8
	bl	get_new_active_ppa
	ldr	r3, .L2823+52
	ldr	r2, .L2823+56
	ldr	r1, [r3]
	ldrh	r2, [r2]
	str	r3, [sp, #16]
	add	r1, r1, r6
	str	r0, [r1, #4]
	mul	r0, r2, r8
	str	r4, [r1, #16]
	bic	r3, r0, #3
	ldr	r0, .L2823+60
	str	r3, [sp, #28]
	ldr	r3, [r0]
	ldr	r0, [sp, #28]
	str	r3, [sp, #32]
	add	fp, r3, r0
	str	fp, [r1, #12]
	mov	r0, fp
	movs	r1, #0
	bl	ftl_memset
	cmp	r4, r10
	ldr	r1, .L2823+12
	beq	.L2779
	ldr	r3, [sp, #20]
	cmp	r4, r3
	ldr	r3, [sp, #16]
	bne	.L2818
	ldr	r3, [sp, #12]
	adds	r2, r7, r3
	ldrh	r3, [r1]
	smulbb	r3, r3, r4
	subs	r2, r2, r3
	uxth	r3, r2
	str	r3, [sp, #16]
	movs	r3, #0
	str	r3, [sp, #24]
	b	.L2782
.L2779:
	ldrh	r2, [r1]
	mov	r0, r7
	mov	r1, r2
	str	r2, [sp, #16]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #16]
	str	r1, [sp, #24]
	subs	r2, r2, r1
	ldr	r1, [sp, #12]
	mov	r3, r2
	cmp	r2, r1
	it	cs
	movcs	r3, r1
	str	r3, [sp, #16]
.L2782:
	ldr	r3, .L2823+12
	ldr	r2, [sp, #16]
	ldrh	r3, [r3]
	cmp	r2, r3
	ldr	r3, .L2823+52
	ldr	r3, [r3]
	bne	.L2783
	cmp	r4, r10
	add	r6, r6, r3
	bne	.L2784
	ldr	r3, [sp, #4]
.L2821:
	str	r3, [r6, #8]
	b	.L2785
.L2784:
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #4]
	muls	r2, r4, r2
	subs	r2, r2, r7
	add	r2, r3, r2, lsl #9
	str	r2, [r6, #8]
.L2785:
	ldr	r3, .L2823+28
	ldrb	r2, [r5, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L2795
	ldr	r1, .L2823+32
	movw	r2, #1737
	ldr	r0, .L2823+36
	bl	printf
	ldr	r1, .L2823+40
	ldr	r0, .L2823+44
	bl	printf
.L2795:
	ldr	r2, [sp, #32]
	movw	r3, #61589
	ldr	r1, [sp, #28]
	add	r8, r8, #1
	strh	r3, [r2, r1]	@ movhi
	ldr	r2, .L2823+64
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
	ldrh	r3, [r5]
	strh	r3, [fp, #2]	@ movhi
	b	.L2777
.L2824:
	.align	2
.L2823:
	.word	.LANCHOR67
	.word	.LANCHOR223
	.word	.LANCHOR241
	.word	.LANCHOR54
	.word	.LANCHOR160
	.word	.LANCHOR129
	.word	.LANCHOR90
	.word	.LANCHOR36
	.word	.LANCHOR242
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR162
	.word	.LANCHOR180
	.word	.LANCHOR57
	.word	.LANCHOR186
	.word	.LANCHOR158
.L2783:
	cmp	r4, r10
	add	r3, r3, r6
	ite	eq
	ldreq	r2, .L2825
	ldrne	r2, .L2825+4
	ldr	r2, [r2]
	str	r2, [r3, #8]
	ldr	r2, [sp, #40]
	ldr	r3, .L2825+8
	adds	r0, r2, #1
	beq	.L2788
	ldr	r3, [r3]
	movs	r1, #1
	str	r2, [sp, #48]
	add	r0, sp, #44
	str	r4, [sp, #60]
	add	r3, r3, r6
	ldr	r2, [r3, #8]
	ldr	r3, [r3, #12]
	str	r2, [sp, #52]
	movs	r2, #0
	str	r3, [sp, #56]
	bl	FlashReadPages
	ldr	r3, [sp, #44]
	adds	r3, r3, #1
	bne	.L2789
	ldr	r2, .L2825+12
	ldr	r3, [r2, #72]
	adds	r3, r3, #1
	str	r3, [r2, #72]
.L2792:
	ldr	r2, [sp, #16]
	cmp	r4, r10
	ldr	r3, .L2825+8
	lsl	r2, r2, #9
	bne	.L2793
	ldr	r1, [r3]
	str	r3, [sp, #16]
	ldr	r3, [sp, #24]
	add	r1, r1, r6
	ldr	r0, [r1, #8]
	ldr	r1, [sp, #4]
	add	r0, r0, r3, lsl #9
.L2820:
	bl	ftl_memcpy
	ldr	r2, [sp, #20]
	ldr	r3, [sp, #16]
	cmp	r4, r2
	bne	.L2785
	ldrh	r2, [r5, #4]
	cmp	r2, #0
	beq	.L2785
	ldr	r3, [r3]
	add	r6, r6, r3
	ldr	r3, .L2825+16
	str	r6, [r3]
	ldr	r3, .L2825+20
	str	r5, [r3]
	b	.L2785
.L2789:
	ldr	r1, [fp, #8]
	cmp	r4, r1
	beq	.L2791
	ldr	r2, .L2825+12
	ldr	r0, .L2825+24
	ldr	r3, [r2, #72]
	adds	r3, r3, #1
	str	r3, [r2, #72]
	mov	r2, r4
	bl	printf
.L2791:
	ldr	r3, [fp, #8]
	cmp	r4, r3
	beq	.L2792
	movw	r2, #1716
	ldr	r1, .L2825+28
	ldr	r0, .L2825+32
	bl	printf
	ldr	r1, .L2825+36
	ldr	r0, .L2825+40
	bl	printf
	b	.L2792
.L2788:
	ldr	r3, [r3]
	movs	r1, #0
	ldr	r2, .L2825+44
	add	r3, r3, r6
	ldrh	r2, [r2]
	ldr	r0, [r3, #8]
	bl	ftl_memset
	b	.L2792
.L2793:
	ldr	r1, .L2825+48
	ldr	r0, [r3]
	str	r3, [sp, #16]
	ldrh	r1, [r1]
	ldr	r3, [sp, #4]
	add	r0, r0, r6
	ldr	r0, [r0, #8]
	muls	r1, r4, r1
	subs	r1, r1, r7
	add	r1, r3, r1, lsl #9
	b	.L2820
.L2818:
	ldr	r3, [r3]
	ldr	r2, [sp, #4]
	add	r6, r6, r3
	ldrh	r3, [r1]
	muls	r3, r4, r3
	subs	r3, r3, r7
	add	r3, r2, r3, lsl #9
	b	.L2821
.L2799:
	ldr	r0, .L2825+8
	mov	r3, r5
	movs	r2, #0
	mov	r1, r8
	ldr	r0, [r0]
	bl	FtlProgPages
	ldr	r3, [sp, #8]
	cmp	r3, r8
	bcs	.L2800
	ldr	r1, .L2825+28
	mov	r2, #1752
	ldr	r0, .L2825+32
	bl	printf
	ldr	r1, .L2825+36
	ldr	r0, .L2825+40
	bl	printf
.L2800:
	ldr	r3, [sp, #8]
	sub	r3, r3, r8
	str	r3, [sp, #8]
	b	.L2773
.L2803:
	mov	r0, #-1
	b	.L2768
.L2805:
	mov	r0, r5
	b	.L2768
.L2826:
	.align	2
.L2825:
	.word	.LANCHOR183
	.word	.LANCHOR184
	.word	.LANCHOR180
	.word	.LANCHOR136
	.word	.LANCHOR129
	.word	.LANCHOR221
	.word	.LC54
	.word	.LANCHOR242
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LANCHOR56
	.word	.LANCHOR54
	.size	ftl_write, .-ftl_write
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
	ldr	r2, .L2840
	sub	sp, sp, #48
	mov	r6, r1
	mov	r4, r0
	ldr	r7, .L2840+4
	ldrh	r3, [r2, #14]
	ldrh	r2, [r2, #12]
	smulbb	r3, r3, r2
	ldr	r2, [r7]
	uxth	r3, r3
	str	r2, [sp, #20]
	ldr	r2, .L2840+8
	subs	r5, r3, #1
	mul	r10, r6, r3
	uxth	r5, r5
	subs	r3, r3, #15
	ldr	r1, [r2]
	mov	r8, r2
	str	r1, [sp, #24]
.L2828:
	cmp	r3, r5
	ble	.L2835
	mov	r0, #-1
	b	.L2827
.L2835:
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
	beq	.L2829
	ldr	r2, [r8]
	ldrh	r1, [r2]
	movw	r2, #61664
	cmp	r1, r2
	bne	.L2829
	cbz	r4, .L2836
	cbz	r6, .L2831
.L2834:
	mov	r2, fp
	ldr	r1, [r7]
	mov	r0, r4
	bl	ftl_memcpy
	movs	r3, #4
	ldr	r0, .L2840+12
	mov	r2, r3
	mov	r1, r4
	bl	rknand_print_hex
	movs	r0, #0
.L2827:
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2831:
	ldr	r1, [r7]
	mov	ip, #1
	ldr	r5, .L2840+16
.L2832:
	ldr	r0, [r5]
	uxth	r3, r6
	adds	r6, r6, #1
	cmp	r3, r0
	bcs	.L2834
	lsrs	r0, r3, #5
	and	r3, r3, #31
	lsl	r3, ip, r3
	ldr	r2, [r1, r0, lsl #2]
	orrs	r3, r3, r2
	str	r3, [r1, r0, lsl #2]
	b	.L2832
.L2829:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2828
.L2836:
	mov	r0, r4
	b	.L2827
.L2841:
	.align	2
.L2840:
	.word	.LANCHOR15
	.word	.LANCHOR143
	.word	.LANCHOR194
	.word	.LC55
	.word	.LANCHOR145
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
	ldr	r3, .L2852
	ldr	r6, .L2852+4
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
	bne	.L2843
.L2847:
	movs	r3, #0
.L2844:
	movw	r2, #65535
	movs	r0, #0
	strh	r2, [r5, r3, lsl #1]	@ movhi
	pop	{r3, r4, r5, r6, r7, pc}
.L2843:
	ldr	r7, [r6]
	movs	r2, #0
	lsr	ip, r4, #4
	mov	r3, r2
	subs	r4, r4, #1
	mov	lr, #1
.L2845:
	uxth	r1, r2
	cmp	r1, r4
	bge	.L2844
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
	bcc	.L2845
	b	.L2847
.L2853:
	.align	2
.L2852:
	.word	.LANCHOR18
	.word	.LANCHOR151
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
	ldr	r3, .L2874
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	ldr	r7, [r3]
	cmp	r7, #0
	bne	.L2855
	ldr	r8, .L2874+40
	ldr	r4, .L2874+4
	bl	FtlBbtMemInit
	sub	r10, r8, #18
	bl	FtlLoadFactoryBbt
.L2856:
	ldr	r3, .L2874+8
	ldrh	r3, [r3]
	cmp	r7, r3
	bcc	.L2862
	ldr	r5, .L2874+12
	movs	r4, #0
.L2863:
	ldrh	r3, [r5]
	uxth	r0, r4
	adds	r4, r4, #1
	cmp	r3, r0
	bhi	.L2864
	ldr	r4, .L2874+16
	movw	r6, #65535
	ldrh	r5, [r4, #12]
	subs	r5, r5, #1
	uxth	r5, r5
.L2865:
	ldrh	r3, [r4, #12]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L2869
	mov	r0, r5
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L2866
	mov	r0, r5
	bl	FlashTestBlk
	cmp	r0, #0
	beq	.L2867
	mov	r0, r5
	bl	FtlBbmMapBadBlock
.L2866:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L2865
.L2862:
	ldr	r3, .L2874+20
	movw	r1, #65535
	ldrh	r2, [r10, #2]!
	ldr	r0, [r3]
	ldr	r3, .L2874+24
	cmp	r2, r1
	str	r0, [r4, #8]
	ldr	fp, [r3]
	str	r3, [sp, #4]
	ldr	r3, .L2874+28
	str	fp, [r4, #12]
	beq	.L2857
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
.L2858:
	uxth	r0, r6
	adds	r7, r7, #1
	add	r8, r8, #4
	bl	FtlBbmMapBadBlock
	b	.L2856
.L2857:
	mov	r1, r7
	str	r3, [sp]
	bl	FlashGetBadBlockList
	ldr	r1, [r8]
	ldr	r0, [r4, #8]
	bl	FtlBbt2Bitmap
	ldr	r3, [sp]
	ldrh	r5, [r3]
.L2860:
	subs	r5, r5, #1
	uxth	r5, r5
.L2859:
	ldr	r3, [sp]
	ldrh	r0, [r3]
	smlabb	r0, r0, r7, r5
	uxth	r0, r0
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L2860
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
	ldr	r3, .L2874+32
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
	bne	.L2858
	uxth	r0, r6
	bl	FtlBbmMapBadBlock
	b	.L2859
.L2864:
	bl	FtlBbmMapBadBlock
	b	.L2863
.L2867:
	ldrh	r3, [r4]
	cmp	r3, r6
	bne	.L2868
	strh	r5, [r4]	@ movhi
	b	.L2866
.L2868:
	strh	r5, [r4, #4]	@ movhi
.L2869:
	ldr	r3, .L2874+36
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
.L2855:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2875:
	.align	2
.L2874:
	.word	.LANCHOR75
	.word	.LANCHOR199
	.word	.LANCHOR43
	.word	.LANCHOR58
	.word	.LANCHOR73
	.word	.LANCHOR79
	.word	.LANCHOR185
	.word	.LANCHOR49
	.word	.LANCHOR120
	.word	.LANCHOR76
	.word	.LANCHOR73+28
	.size	FtlMakeBbt, .-FtlMakeBbt
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
	ldr	r3, .L2907
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L2878
	ldr	r6, .L2907+4
	ldr	r2, .L2907+8
	ldr	r5, .L2907+12
	ldrh	r0, [r6]
	str	r3, [r2]
	str	r3, [r5]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L2879
	bl	FtlMakeBbt
.L2879:
	ldr	r3, .L2907+16
	ldr	r2, .L2907+20
	ldr	ip, .L2907+112
	ldrh	r1, [r3]
	ldr	r4, [r2]
	ldr	r2, .L2907+24
	str	r3, [sp, #12]
	lsls	r1, r1, #7
	ldr	r7, [r2]
	movs	r2, #0
.L2880:
	uxth	r3, r2
	adds	r2, r2, #1
	cmp	r3, r1
	blt	.L2881
	ldr	r3, .L2907+28
	movs	r7, #0
	ldr	fp, .L2907+116
	ldrh	r4, [r3]
	mov	r8, r3
	mov	r10, fp
.L2882:
	ldrh	r3, [fp]
	cmp	r3, r4
	bhi	.L2883
	ldr	r4, .L2907+32
	subs	r3, r7, #2
	ldrh	r1, [r4]
	cmp	r3, r1, lsl #1
	bgt	.L2884
.L2888:
	movs	r7, #0
	mov	r6, r7
.L2885:
	ldrh	r3, [r8]
	uxth	r0, r7
	adds	r7, r7, #1
	cmp	r3, r0
	bhi	.L2889
	ldrh	r2, [r10]
	ldr	r3, .L2907+36
	ldrh	r4, [r4]
	ldr	r7, .L2907+40
	str	r2, [r3]
	ldr	r3, .L2907+44
	mov	r1, r4
	ldr	r3, [r3]
	mov	r0, r3
	str	r3, [sp, #16]
	bl	__aeabi_uidiv
	ldr	r1, .L2907+48
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
	ble	.L2890
	ldr	r3, [sp, #16]
	mov	r1, r4
	subs	r0, r3, r6
	bl	__aeabi_uidiv
	ldr	r3, [sp, #8]
	str	r0, [r7]
	lsrs	r0, r0, #5
	adds	r0, r0, #24
	strh	r0, [r3]	@ movhi
.L2890:
	ldr	r3, .L2907+52
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L2891
	ldr	r2, .L2907+48
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
.L2891:
	ldr	r3, .L2907+56
	ldrb	r3, [r3]	@ zero_extendqisi2
	cbz	r3, .L2892
	ldr	r2, .L2907+48
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
.L2892:
	ldr	r3, .L2907+60
	ldrh	r3, [r3]
	cbz	r3, .L2894
	ldr	r2, .L2907+48
	ldrh	r1, [r2]
	add	r1, r1, r3, lsr #1
	strh	r1, [r2]	@ movhi
	mul	r1, r4, r3
	cmp	r6, r1
	bge	.L2894
	ldr	r1, [sp, #4]
	adds	r3, r3, #32
	str	fp, [r7]
	add	r1, r1, r3
	strh	r1, [r2]	@ movhi
.L2894:
	ldr	r3, [sp, #8]
	ldr	r6, .L2907+64
	ldrh	r2, [r3]
	ldr	r3, [r7]
	subs	r3, r3, r2
	muls	r4, r3, r4
	ldr	r3, .L2907+68
	ldrh	r3, [r3]
	str	r4, [r6]
	muls	r4, r3, r4
	ldr	r3, [sp, #12]
	ldrh	r3, [r3]
	str	r4, [r7]
	ldr	r7, .L2907+72
	muls	r4, r3, r4
	ldr	r3, .L2907+76
	str	r4, [r3]
	movw	r4, #65535
	bl	FtlBbmTblFlush
	ldrh	r2, [r10]
	movs	r1, #0
	ldr	r10, .L2907+120
	lsls	r2, r2, #1
	ldr	r0, [r10]
	bl	ftl_memset
	ldr	r2, .L2907+80
	movs	r3, #0
	strh	r3, [r7, #2]	@ movhi
	movs	r1, #255
	strb	r3, [r7, #6]
	str	r3, [r2]
	ldr	r2, .L2907+84
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
	ldr	r3, .L2907+88
	lsrs	r2, r2, #3
	ldr	r0, [r3]
	bl	ftl_memset
.L2896:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r7, #7]	@ zero_extendqisi2
	ldrh	r2, [r7]
	cmp	r3, #0
	bne	.L2897
	ldr	r3, [r8]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r7]
	adds	r3, r3, #1
	strh	r3, [r7]	@ movhi
	b	.L2896
.L2881:
	mvns	r0, r3
	orr	r0, r3, r0, lsl #16
	str	r0, [r4, r3, lsl #2]
	str	ip, [r7, r3, lsl #2]
	b	.L2880
.L2883:
	mov	r0, r4
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r4, r4, #1
	add	r7, r7, r0
	uxth	r7, r7
	uxth	r4, r4
	b	.L2882
.L2884:
	mov	r0, r7
	bl	__aeabi_uidiv
	ldr	r3, .L2907+92
	ldr	r3, [r3]
	add	r0, r0, r3
	uxth	r0, r0
	bl	FtlSysBlkNumInit
	ldrh	r0, [r6]
	bl	FtlFreeSysBlkQueueInit
	ldrh	r6, [r8]
.L2886:
	ldrh	r3, [r10]
	cmp	r3, r6
	bls	.L2888
	mov	r0, r6
	movs	r1, #1
	adds	r6, r6, #1
	bl	FtlLowFormatEraseBlock
	uxth	r6, r6
	b	.L2886
.L2889:
	movs	r1, #0
	bl	FtlLowFormatEraseBlock
	add	r6, r6, r0
	uxth	r6, r6
	b	.L2885
.L2897:
	ldr	r3, [r5]
	ldrh	r1, [r7, #4]
	ldr	r4, .L2907+96
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
.L2898:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r4]
	cbnz	r3, .L2899
	ldr	r3, [r8]
	strh	r7, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L2898
.L2899:
	ldr	r3, [r5]
	ldrh	r1, [r4, #4]
	str	r3, [r4, #12]
	adds	r3, r3, #1
	str	r3, [r5]
	movw	r4, #65535
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L2907+100
	strh	r4, [r3]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L2907+104
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
	cbnz	r0, .L2878
	ldr	r3, .L2907+108
	movs	r2, #1
	str	r2, [r3]
.L2878:
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L2908:
	.align	2
.L2907:
	.word	.LANCHOR75
	.word	.LANCHOR37
	.word	.LANCHOR158
	.word	.LANCHOR157
	.word	.LANCHOR54
	.word	.LANCHOR183
	.word	.LANCHOR184
	.word	.LANCHOR38
	.word	.LANCHOR36
	.word	.LANCHOR72
	.word	.LANCHOR71
	.word	.LANCHOR40
	.word	.LANCHOR227
	.word	.LANCHOR101
	.word	.LANCHOR8
	.word	.LANCHOR47
	.word	.LANCHOR226
	.word	.LANCHOR51
	.word	.LANCHOR90
	.word	.LANCHOR67
	.word	.LANCHOR99
	.word	.LANCHOR201
	.word	.LANCHOR0
	.word	.LANCHOR64
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR206
	.word	.LANCHOR223
	.word	168778952
	.word	.LANCHOR39
	.word	.LANCHOR82
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
	.section	.bss.DeviceCapacity,"aw",%nobits
	.align	2
	.set	.LANCHOR59,. + 0
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
	.set	.LANCHOR148,. + 0
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
	.set	.LANCHOR98,. + 0
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
	.set	.LANCHOR120,. + 0
	.type	c_ftl_nand_bbm_buf_size, %object
	.size	c_ftl_nand_bbm_buf_size, 2
c_ftl_nand_bbm_buf_size:
	.space	2
	.section	.bss.c_ftl_nand_blk_pre_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR39,. + 0
	.type	c_ftl_nand_blk_pre_plane, %object
	.size	c_ftl_nand_blk_pre_plane, 2
c_ftl_nand_blk_pre_plane:
	.space	2
	.section	.bss.c_ftl_nand_blks_per_die,"aw",%nobits
	.align	1
	.set	.LANCHOR49,. + 0
	.type	c_ftl_nand_blks_per_die, %object
	.size	c_ftl_nand_blks_per_die, 2
c_ftl_nand_blks_per_die:
	.space	2
	.section	.bss.c_ftl_nand_blks_per_die_shift,"aw",%nobits
	.align	1
	.set	.LANCHOR50,. + 0
	.type	c_ftl_nand_blks_per_die_shift, %object
	.size	c_ftl_nand_blks_per_die_shift, 2
c_ftl_nand_blks_per_die_shift:
	.space	2
	.section	.bss.c_ftl_nand_byte_pre_oob,"aw",%nobits
	.align	1
	.set	.LANCHOR57,. + 0
	.type	c_ftl_nand_byte_pre_oob, %object
	.size	c_ftl_nand_byte_pre_oob, 2
c_ftl_nand_byte_pre_oob:
	.space	2
	.section	.bss.c_ftl_nand_byte_pre_page,"aw",%nobits
	.align	1
	.set	.LANCHOR56,. + 0
	.type	c_ftl_nand_byte_pre_page, %object
	.size	c_ftl_nand_byte_pre_page, 2
c_ftl_nand_byte_pre_page:
	.space	2
	.section	.bss.c_ftl_nand_data_blks_per_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR38,. + 0
	.type	c_ftl_nand_data_blks_per_plane, %object
	.size	c_ftl_nand_data_blks_per_plane, 2
c_ftl_nand_data_blks_per_plane:
	.space	2
	.section	.bss.c_ftl_nand_data_op_blks_per_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR227,. + 0
	.type	c_ftl_nand_data_op_blks_per_plane, %object
	.size	c_ftl_nand_data_op_blks_per_plane, 2
c_ftl_nand_data_op_blks_per_plane:
	.space	2
	.section	.bss.c_ftl_nand_die_num,"aw",%nobits
	.align	1
	.set	.LANCHOR43,. + 0
	.type	c_ftl_nand_die_num, %object
	.size	c_ftl_nand_die_num, 2
c_ftl_nand_die_num:
	.space	2
	.section	.bss.c_ftl_nand_ext_blk_pre_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR47,. + 0
	.type	c_ftl_nand_ext_blk_pre_plane, %object
	.size	c_ftl_nand_ext_blk_pre_plane, 2
c_ftl_nand_ext_blk_pre_plane:
	.space	2
	.section	.bss.c_ftl_nand_init_sys_blks_per_plane,"aw",%nobits
	.align	2
	.set	.LANCHOR64,. + 0
	.type	c_ftl_nand_init_sys_blks_per_plane, %object
	.size	c_ftl_nand_init_sys_blks_per_plane, 4
c_ftl_nand_init_sys_blks_per_plane:
	.space	4
	.section	.bss.c_ftl_nand_l2pmap_ram_region_num,"aw",%nobits
	.align	1
	.set	.LANCHOR66,. + 0
	.type	c_ftl_nand_l2pmap_ram_region_num, %object
	.size	c_ftl_nand_l2pmap_ram_region_num, 2
c_ftl_nand_l2pmap_ram_region_num:
	.space	2
	.section	.bss.c_ftl_nand_map_blks_per_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR62,. + 0
	.type	c_ftl_nand_map_blks_per_plane, %object
	.size	c_ftl_nand_map_blks_per_plane, 2
c_ftl_nand_map_blks_per_plane:
	.space	2
	.section	.bss.c_ftl_nand_map_region_num,"aw",%nobits
	.align	1
	.set	.LANCHOR65,. + 0
	.type	c_ftl_nand_map_region_num, %object
	.size	c_ftl_nand_map_region_num, 2
c_ftl_nand_map_region_num:
	.space	2
	.section	.bss.c_ftl_nand_max_data_blks,"aw",%nobits
	.align	2
	.set	.LANCHOR40,. + 0
	.type	c_ftl_nand_max_data_blks, %object
	.size	c_ftl_nand_max_data_blks, 4
c_ftl_nand_max_data_blks:
	.space	4
	.section	.bss.c_ftl_nand_max_map_blks,"aw",%nobits
	.align	2
	.set	.LANCHOR63,. + 0
	.type	c_ftl_nand_max_map_blks, %object
	.size	c_ftl_nand_max_map_blks, 4
c_ftl_nand_max_map_blks:
	.space	4
	.section	.bss.c_ftl_nand_max_sys_blks,"aw",%nobits
	.align	2
	.set	.LANCHOR37,. + 0
	.type	c_ftl_nand_max_sys_blks, %object
	.size	c_ftl_nand_max_sys_blks, 4
c_ftl_nand_max_sys_blks:
	.space	4
	.section	.bss.c_ftl_nand_max_vendor_blks,"aw",%nobits
	.align	1
	.set	.LANCHOR60,. + 0
	.type	c_ftl_nand_max_vendor_blks, %object
	.size	c_ftl_nand_max_vendor_blks, 2
c_ftl_nand_max_vendor_blks:
	.space	2
	.section	.bss.c_ftl_nand_page_pre_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR51,. + 0
	.type	c_ftl_nand_page_pre_blk, %object
	.size	c_ftl_nand_page_pre_blk, 2
c_ftl_nand_page_pre_blk:
	.space	2
	.section	.bss.c_ftl_nand_page_pre_slc_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR52,. + 0
	.type	c_ftl_nand_page_pre_slc_blk, %object
	.size	c_ftl_nand_page_pre_slc_blk, 2
c_ftl_nand_page_pre_slc_blk:
	.space	2
	.section	.bss.c_ftl_nand_page_pre_super_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR53,. + 0
	.type	c_ftl_nand_page_pre_super_blk, %object
	.size	c_ftl_nand_page_pre_super_blk, 2
c_ftl_nand_page_pre_super_blk:
	.space	2
	.section	.bss.c_ftl_nand_planes_num,"aw",%nobits
	.align	1
	.set	.LANCHOR36,. + 0
	.type	c_ftl_nand_planes_num, %object
	.size	c_ftl_nand_planes_num, 2
c_ftl_nand_planes_num:
	.space	2
	.section	.bss.c_ftl_nand_planes_per_die,"aw",%nobits
	.align	1
	.set	.LANCHOR44,. + 0
	.type	c_ftl_nand_planes_per_die, %object
	.size	c_ftl_nand_planes_per_die, 2
c_ftl_nand_planes_per_die:
	.space	2
	.section	.bss.c_ftl_nand_reserved_blks,"aw",%nobits
	.align	1
	.set	.LANCHOR58,. + 0
	.type	c_ftl_nand_reserved_blks, %object
	.size	c_ftl_nand_reserved_blks, 2
c_ftl_nand_reserved_blks:
	.space	2
	.section	.bss.c_ftl_nand_sec_pre_page,"aw",%nobits
	.align	1
	.set	.LANCHOR54,. + 0
	.type	c_ftl_nand_sec_pre_page, %object
	.size	c_ftl_nand_sec_pre_page, 2
c_ftl_nand_sec_pre_page:
	.space	2
	.section	.bss.c_ftl_nand_sec_pre_page_shift,"aw",%nobits
	.align	1
	.set	.LANCHOR55,. + 0
	.type	c_ftl_nand_sec_pre_page_shift, %object
	.size	c_ftl_nand_sec_pre_page_shift, 2
c_ftl_nand_sec_pre_page_shift:
	.space	2
	.section	.bss.c_ftl_nand_sys_blks_per_plane,"aw",%nobits
	.align	2
	.set	.LANCHOR35,. + 0
	.type	c_ftl_nand_sys_blks_per_plane, %object
	.size	c_ftl_nand_sys_blks_per_plane, 4
c_ftl_nand_sys_blks_per_plane:
	.space	4
	.section	.bss.c_ftl_nand_totle_phy_blks,"aw",%nobits
	.align	2
	.set	.LANCHOR41,. + 0
	.type	c_ftl_nand_totle_phy_blks, %object
	.size	c_ftl_nand_totle_phy_blks, 4
c_ftl_nand_totle_phy_blks:
	.space	4
	.section	.bss.c_ftl_nand_type,"aw",%nobits
	.align	1
	.set	.LANCHOR42,. + 0
	.type	c_ftl_nand_type, %object
	.size	c_ftl_nand_type, 2
c_ftl_nand_type:
	.space	2
	.section	.bss.c_ftl_nand_vendor_region_num,"aw",%nobits
	.align	1
	.set	.LANCHOR61,. + 0
	.type	c_ftl_nand_vendor_region_num, %object
	.size	c_ftl_nand_vendor_region_num, 2
c_ftl_nand_vendor_region_num:
	.space	2
	.section	.bss.c_ftl_vendor_part_size,"aw",%nobits
	.align	1
	.set	.LANCHOR48,. + 0
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
	.set	.LANCHOR46,. + 0
	.type	c_mlc_erase_count_value, %object
	.size	c_mlc_erase_count_value, 2
c_mlc_erase_count_value:
	.space	2
	.section	.bss.ftl_gc_temp_power_lost_recovery_flag,"aw",%nobits
	.align	2
	.set	.LANCHOR132,. + 0
	.type	ftl_gc_temp_power_lost_recovery_flag, %object
	.size	ftl_gc_temp_power_lost_recovery_flag, 4
ftl_gc_temp_power_lost_recovery_flag:
	.space	4
	.section	.bss.gBbtInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR73,. + 0
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
	.set	.LANCHOR153,. + 0
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
	.set	.LANCHOR143,. + 0
	.type	gFlashPageBuffer0, %object
	.size	gFlashPageBuffer0, 4
gFlashPageBuffer0:
	.space	4
	.section	.bss.gFlashPageBuffer1,"aw",%nobits
	.align	2
	.set	.LANCHOR151,. + 0
	.type	gFlashPageBuffer1, %object
	.size	gFlashPageBuffer1, 4
gFlashPageBuffer1:
	.space	4
	.section	.bss.gFlashProgCheckBuffer,"aw",%nobits
	.align	2
	.set	.LANCHOR195,. + 0
	.type	gFlashProgCheckBuffer, %object
	.size	gFlashProgCheckBuffer, 4
gFlashProgCheckBuffer:
	.space	4
	.section	.bss.gFlashProgCheckSpareBuffer,"aw",%nobits
	.align	2
	.set	.LANCHOR196,. + 0
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
	.set	.LANCHOR194,. + 0
	.type	gFlashSpareBuffer, %object
	.size	gFlashSpareBuffer, 4
gFlashSpareBuffer:
	.space	4
	.section	.bss.gFlashToggleModeEn,"aw",%nobits
	.set	.LANCHOR28,. + 0
	.type	gFlashToggleModeEn, %object
	.size	gFlashToggleModeEn, 1
gFlashToggleModeEn:
	.space	1
	.section	.bss.gL2pMapInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR124,. + 0
	.type	gL2pMapInfo, %object
	.size	gL2pMapInfo, 44
gL2pMapInfo:
	.space	44
	.section	.bss.gMasterInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR33,. + 0
	.type	gMasterInfo, %object
	.size	gMasterInfo, 32
gMasterInfo:
	.space	32
	.section	.bss.gMasterTempBuf,"aw",%nobits
	.align	2
	.set	.LANCHOR154,. + 0
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
	.set	.LANCHOR198,. + 0
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
	.set	.LANCHOR31,. + 0
	.type	gNandFlashEccBits, %object
	.size	gNandFlashEccBits, 1
gNandFlashEccBits:
	.space	1
	.section	.bss.gNandFlashIDBEccBits,"aw",%nobits
	.set	.LANCHOR150,. + 0
	.type	gNandFlashIDBEccBits, %object
	.size	gNandFlashIDBEccBits, 1
gNandFlashIDBEccBits:
	.space	1
	.section	.bss.gNandFlashIdbBlockAddr,"aw",%nobits
	.align	2
	.set	.LANCHOR145,. + 0
	.type	gNandFlashIdbBlockAddr, %object
	.size	gNandFlashIdbBlockAddr, 4
gNandFlashIdbBlockAddr:
	.space	4
	.section	.bss.gNandFlashInfoBlockAddr,"aw",%nobits
	.align	2
	.set	.LANCHOR144,. + 0
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
	.set	.LANCHOR146,. + 0
	.type	gNandIDBResBlkNumSaveInFlash, %object
	.size	gNandIDBResBlkNumSaveInFlash, 1
gNandIDBResBlkNumSaveInFlash:
	.space	1
	.section	.bss.gNandIDataBuf,"aw",%nobits
	.align	2
	.set	.LANCHOR139,. + 0
	.type	gNandIDataBuf, %object
	.size	gNandIDataBuf, 2048
gNandIDataBuf:
	.space	2048
	.section	.bss.gNandMaxChip,"aw",%nobits
	.set	.LANCHOR118,. + 0
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
	.set	.LANCHOR34,. + 0
	.type	gNandcDumpWriteEn, %object
	.size	gNandcDumpWriteEn, 4
gNandcDumpWriteEn:
	.space	4
	.section	.bss.gNandcEccBits,"aw",%nobits
	.align	2
	.set	.LANCHOR30,. + 0
	.type	gNandcEccBits, %object
	.size	gNandcEccBits, 4
gNandcEccBits:
	.space	4
	.section	.bss.gNandcVer,"aw",%nobits
	.align	2
	.set	.LANCHOR32,. + 0
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
	.set	.LANCHOR74,. + 0
	.type	gSysFreeQueue, %object
	.size	gSysFreeQueue, 2056
gSysFreeQueue:
	.space	2056
	.section	.bss.gSysInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR206,. + 0
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
	.set	.LANCHOR119,. + 0
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
	.set	.LANCHOR158,. + 0
	.type	g_GlobalDataVersion, %object
	.size	g_GlobalDataVersion, 4
g_GlobalDataVersion:
	.space	4
	.section	.bss.g_GlobalSysVersion,"aw",%nobits
	.align	2
	.set	.LANCHOR157,. + 0
	.type	g_GlobalSysVersion, %object
	.size	g_GlobalSysVersion, 4
g_GlobalSysVersion:
	.space	4
	.section	.bss.g_LowFormat,"aw",%nobits
	.align	2
	.set	.LANCHOR239,. + 0
	.type	g_LowFormat, %object
	.size	g_LowFormat, 4
g_LowFormat:
	.space	4
	.section	.bss.g_MaxLbaSector,"aw",%nobits
	.align	2
	.set	.LANCHOR67,. + 0
	.type	g_MaxLbaSector, %object
	.size	g_MaxLbaSector, 4
g_MaxLbaSector:
	.space	4
	.section	.bss.g_MaxLbn,"aw",%nobits
	.align	2
	.set	.LANCHOR226,. + 0
	.type	g_MaxLbn, %object
	.size	g_MaxLbn, 4
g_MaxLbn:
	.space	4
	.section	.bss.g_MaxLpn,"aw",%nobits
	.align	2
	.set	.LANCHOR71,. + 0
	.type	g_MaxLpn, %object
	.size	g_MaxLpn, 4
g_MaxLpn:
	.space	4
	.section	.bss.g_SlcPartLbaEndSector,"aw",%nobits
	.align	2
	.set	.LANCHOR155,. + 0
	.type	g_SlcPartLbaEndSector, %object
	.size	g_SlcPartLbaEndSector, 4
g_SlcPartLbaEndSector:
	.space	4
	.section	.bss.g_VaildLpn,"aw",%nobits
	.align	2
	.set	.LANCHOR99,. + 0
	.type	g_VaildLpn, %object
	.size	g_VaildLpn, 4
g_VaildLpn:
	.space	4
	.section	.bss.g_active_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR90,. + 0
	.type	g_active_superblock, %object
	.size	g_active_superblock, 48
g_active_superblock:
	.space	48
	.section	.bss.g_all_blk_used_slc_mode,"aw",%nobits
	.align	2
	.set	.LANCHOR156,. + 0
	.type	g_all_blk_used_slc_mode, %object
	.size	g_all_blk_used_slc_mode, 4
g_all_blk_used_slc_mode:
	.space	4
	.section	.bss.g_buffer_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR91,. + 0
	.type	g_buffer_superblock, %object
	.size	g_buffer_superblock, 48
g_buffer_superblock:
	.space	48
	.section	.bss.g_cur_erase_blk,"aw",%nobits
	.align	2
	.set	.LANCHOR72,. + 0
	.type	g_cur_erase_blk, %object
	.size	g_cur_erase_blk, 4
g_cur_erase_blk:
	.space	4
	.section	.bss.g_ect_tbl_info_size,"aw",%nobits
	.align	1
	.set	.LANCHOR187,. + 0
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
	.set	.LANCHOR75,. + 0
	.type	g_flash_read_only_en, %object
	.size	g_flash_read_only_en, 4
g_flash_read_only_en:
	.space	4
	.section	.bss.g_free_slc_blk_num,"aw",%nobits
	.align	1
	.set	.LANCHOR137,. + 0
	.type	g_free_slc_blk_num, %object
	.size	g_free_slc_blk_num, 2
g_free_slc_blk_num:
	.space	2
	.section	.bss.g_ftl_nand_free_count,"aw",%nobits
	.align	2
	.set	.LANCHOR241,. + 0
	.type	g_ftl_nand_free_count, %object
	.size	g_ftl_nand_free_count, 4
g_ftl_nand_free_count:
	.space	4
	.section	.bss.g_gc_bad_block_gc_index,"aw",%nobits
	.align	1
	.set	.LANCHOR116,. + 0
	.type	g_gc_bad_block_gc_index, %object
	.size	g_gc_bad_block_gc_index, 2
g_gc_bad_block_gc_index:
	.space	2
	.section	.bss.g_gc_bad_block_temp_num,"aw",%nobits
	.align	1
	.set	.LANCHOR114,. + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.space	2
	.section	.bss.g_gc_bad_block_temp_tbl,"aw",%nobits
	.align	1
	.set	.LANCHOR115,. + 0
	.type	g_gc_bad_block_temp_tbl, %object
	.size	g_gc_bad_block_temp_tbl, 34
g_gc_bad_block_temp_tbl:
	.space	34
	.section	.bss.g_gc_blk_index,"aw",%nobits
	.align	1
	.set	.LANCHOR176,. + 0
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
	.set	.LANCHOR237,. + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.space	2
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",%nobits
	.align	1
	.set	.LANCHOR236,. + 0
	.type	g_gc_cur_blk_valid_pages, %object
	.size	g_gc_cur_blk_valid_pages, 2
g_gc_cur_blk_valid_pages:
	.space	2
	.section	.bss.g_gc_free_blk_threshold,"aw",%nobits
	.align	1
	.set	.LANCHOR174,. + 0
	.type	g_gc_free_blk_threshold, %object
	.size	g_gc_free_blk_threshold, 2
g_gc_free_blk_threshold:
	.space	2
	.section	.bss.g_gc_head_data_block,"aw",%nobits
	.align	2
	.set	.LANCHOR171,. + 0
	.type	g_gc_head_data_block, %object
	.size	g_gc_head_data_block, 4
g_gc_head_data_block:
	.space	4
	.section	.bss.g_gc_head_data_block_count,"aw",%nobits
	.align	2
	.set	.LANCHOR172,. + 0
	.type	g_gc_head_data_block_count, %object
	.size	g_gc_head_data_block_count, 4
g_gc_head_data_block_count:
	.space	4
	.section	.bss.g_gc_merge_free_blk_threshold,"aw",%nobits
	.align	1
	.set	.LANCHOR175,. + 0
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
	.set	.LANCHOR177,. + 0
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
	.set	.LANCHOR173,. + 0
	.type	g_gc_skip_write_count, %object
	.size	g_gc_skip_write_count, 4
g_gc_skip_write_count:
	.space	4
	.section	.bss.g_gc_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR201,. + 0
	.type	g_gc_superblock, %object
	.size	g_gc_superblock, 48
g_gc_superblock:
	.space	48
	.section	.bss.g_gc_temp_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR92,. + 0
	.type	g_gc_temp_superblock, %object
	.size	g_gc_temp_superblock, 48
g_gc_temp_superblock:
	.space	48
	.section	.bss.g_in_gc_progress,"aw",%nobits
	.align	2
	.set	.LANCHOR169,. + 0
	.type	g_in_gc_progress, %object
	.size	g_in_gc_progress, 4
g_in_gc_progress:
	.space	4
	.section	.bss.g_in_swl_replace,"aw",%nobits
	.align	2
	.set	.LANCHOR170,. + 0
	.type	g_in_swl_replace, %object
	.size	g_in_swl_replace, 4
g_in_swl_replace:
	.space	4
	.section	.bss.g_inkDie_check_enable,"aw",%nobits
	.align	2
	.set	.LANCHOR101,. + 0
	.type	g_inkDie_check_enable, %object
	.size	g_inkDie_check_enable, 4
g_inkDie_check_enable:
	.space	4
	.section	.bss.g_l2p_last_update_region_id,"aw",%nobits
	.align	1
	.set	.LANCHOR96,. + 0
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
	.set	.LANCHOR147,. + 0
	.type	g_maxRetryCount, %object
	.size	g_maxRetryCount, 1
g_maxRetryCount:
	.space	1
	.section	.bss.g_max_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR167,. + 0
	.type	g_max_erase_count, %object
	.size	g_max_erase_count, 4
g_max_erase_count:
	.space	4
	.section	.bss.g_min_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR168,. + 0
	.type	g_min_erase_count, %object
	.size	g_min_erase_count, 4
g_min_erase_count:
	.space	4
	.section	.bss.g_nandc_version_data,"aw",%nobits
	.align	2
	.set	.LANCHOR152,. + 0
	.type	g_nandc_version_data, %object
	.size	g_nandc_version_data, 4
g_nandc_version_data:
	.space	4
	.section	.bss.g_num_data_superblocks,"aw",%nobits
	.align	1
	.set	.LANCHOR84,. + 0
	.type	g_num_data_superblocks, %object
	.size	g_num_data_superblocks, 2
g_num_data_superblocks:
	.space	2
	.section	.bss.g_num_free_superblocks,"aw",%nobits
	.align	1
	.set	.LANCHOR87,. + 0
	.type	g_num_free_superblocks, %object
	.size	g_num_free_superblocks, 2
g_num_free_superblocks:
	.space	2
	.section	.bss.g_page_map_check_enable,"aw",%nobits
	.align	1
	.set	.LANCHOR68,. + 0
	.type	g_page_map_check_enable, %object
	.size	g_page_map_check_enable, 2
g_page_map_check_enable:
	.space	2
	.section	.bss.g_power_lost_ecc_error_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR229,. + 0
	.type	g_power_lost_ecc_error_blk, %object
	.size	g_power_lost_ecc_error_blk, 2
g_power_lost_ecc_error_blk:
	.space	2
	.section	.bss.g_power_lost_recovery_flag,"aw",%nobits
	.align	1
	.set	.LANCHOR230,. + 0
	.type	g_power_lost_recovery_flag, %object
	.size	g_power_lost_recovery_flag, 2
g_power_lost_recovery_flag:
	.space	2
	.section	.bss.g_recovery_page_min_ver,"aw",%nobits
	.align	2
	.set	.LANCHOR133,. + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.space	4
	.section	.bss.g_recovery_page_num,"aw",%nobits
	.align	2
	.set	.LANCHOR231,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.space	4
	.section	.bss.g_recovery_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR232,. + 0
	.type	g_recovery_ppa_tbl, %object
	.size	g_recovery_ppa_tbl, 128
g_recovery_ppa_tbl:
	.space	128
	.section	.bss.g_req_cache,"aw",%nobits
	.align	2
	.set	.LANCHOR129,. + 0
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
	.set	.LANCHOR136,. + 0
	.type	g_sys_ext_data, %object
	.size	g_sys_ext_data, 512
g_sys_ext_data:
	.space	512
	.section	.bss.g_sys_save_data,"aw",%nobits
	.align	2
	.set	.LANCHOR135,. + 0
	.type	g_sys_save_data, %object
	.size	g_sys_save_data, 48
g_sys_save_data:
	.space	48
	.section	.bss.g_tmp_data_superblock_id,"aw",%nobits
	.align	1
	.set	.LANCHOR130,. + 0
	.type	g_tmp_data_superblock_id, %object
	.size	g_tmp_data_superblock_id, 2
g_tmp_data_superblock_id:
	.space	2
	.section	.bss.g_totle_avg_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR202,. + 0
	.type	g_totle_avg_erase_count, %object
	.size	g_totle_avg_erase_count, 4
g_totle_avg_erase_count:
	.space	4
	.section	.bss.g_totle_cache_write_count,"aw",%nobits
	.align	2
	.set	.LANCHOR162,. + 0
	.type	g_totle_cache_write_count, %object
	.size	g_totle_cache_write_count, 4
g_totle_cache_write_count:
	.space	4
	.section	.bss.g_totle_discard_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR161,. + 0
	.type	g_totle_discard_page_count, %object
	.size	g_totle_discard_page_count, 4
g_totle_discard_page_count:
	.space	4
	.section	.bss.g_totle_gc_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR159,. + 0
	.type	g_totle_gc_page_count, %object
	.size	g_totle_gc_page_count, 4
g_totle_gc_page_count:
	.space	4
	.section	.bss.g_totle_l2p_write_count,"aw",%nobits
	.align	2
	.set	.LANCHOR163,. + 0
	.type	g_totle_l2p_write_count, %object
	.size	g_totle_l2p_write_count, 4
g_totle_l2p_write_count:
	.space	4
	.section	.bss.g_totle_map_block,"aw",%nobits
	.align	1
	.set	.LANCHOR125,. + 0
	.type	g_totle_map_block, %object
	.size	g_totle_map_block, 2
g_totle_map_block:
	.space	2
	.section	.bss.g_totle_mlc_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR165,. + 0
	.type	g_totle_mlc_erase_count, %object
	.size	g_totle_mlc_erase_count, 4
g_totle_mlc_erase_count:
	.space	4
	.section	.bss.g_totle_read_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR164,. + 0
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
	.set	.LANCHOR166,. + 0
	.type	g_totle_slc_erase_count, %object
	.size	g_totle_slc_erase_count, 4
g_totle_slc_erase_count:
	.space	4
	.section	.bss.g_totle_swl_count,"aw",%nobits
	.align	2
	.set	.LANCHOR131,. + 0
	.type	g_totle_swl_count, %object
	.size	g_totle_swl_count, 4
g_totle_swl_count:
	.space	4
	.section	.bss.g_totle_sys_slc_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR78,. + 0
	.type	g_totle_sys_slc_erase_count, %object
	.size	g_totle_sys_slc_erase_count, 4
g_totle_sys_slc_erase_count:
	.space	4
	.section	.bss.g_totle_vendor_block,"aw",%nobits
	.align	1
	.set	.LANCHOR69,. + 0
	.type	g_totle_vendor_block, %object
	.size	g_totle_vendor_block, 2
g_totle_vendor_block:
	.space	2
	.section	.bss.g_totle_write_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR160,. + 0
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
	.set	.LANCHOR222,. + 0
	.type	gc_discard_updated, %object
	.size	gc_discard_updated, 4
gc_discard_updated:
	.space	4
	.section	.bss.gc_ink_free_return_value,"aw",%nobits
	.align	1
	.set	.LANCHOR235,. + 0
	.type	gc_ink_free_return_value, %object
	.size	gc_ink_free_return_value, 2
gc_ink_free_return_value:
	.space	2
	.section	.bss.gpFlashSaveInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR142,. + 0
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
	.set	.LANCHOR149,. + 0
	.type	gpReadRetrial, %object
	.size	gpReadRetrial, 4
gpReadRetrial:
	.space	4
	.section	.bss.gp_ect_tbl_info,"aw",%nobits
	.align	2
	.set	.LANCHOR188,. + 0
	.type	gp_ect_tbl_info, %object
	.size	gp_ect_tbl_info, 4
gp_ect_tbl_info:
	.space	4
	.section	.bss.gp_gc_page_buf_info,"aw",%nobits
	.align	2
	.set	.LANCHOR103,. + 0
	.type	gp_gc_page_buf_info, %object
	.size	gp_gc_page_buf_info, 4
gp_gc_page_buf_info:
	.space	4
	.section	.bss.gp_last_act_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR221,. + 0
	.type	gp_last_act_superblock, %object
	.size	gp_last_act_superblock, 4
gp_last_act_superblock:
	.space	4
	.section	.bss.mlcPageToSlcPageTbl,"aw",%nobits
	.align	2
	.set	.LANCHOR117,. + 0
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
	.set	.LANCHOR81,. + 0
	.type	p_data_block_list_head, %object
	.size	p_data_block_list_head, 4
p_data_block_list_head:
	.space	4
	.section	.bss.p_data_block_list_table,"aw",%nobits
	.align	2
	.set	.LANCHOR80,. + 0
	.type	p_data_block_list_table, %object
	.size	p_data_block_list_table, 4
p_data_block_list_table:
	.space	4
	.section	.bss.p_data_block_list_tail,"aw",%nobits
	.align	2
	.set	.LANCHOR83,. + 0
	.type	p_data_block_list_tail, %object
	.size	p_data_block_list_tail, 4
p_data_block_list_tail:
	.space	4
	.section	.bss.p_erase_count_table,"aw",%nobits
	.align	2
	.set	.LANCHOR77,. + 0
	.type	p_erase_count_table, %object
	.size	p_erase_count_table, 4
p_erase_count_table:
	.space	4
	.section	.bss.p_free_data_block_list_head,"aw",%nobits
	.align	2
	.set	.LANCHOR86,. + 0
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
	.set	.LANCHOR183,. + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 4
p_io_data_buf_0:
	.space	4
	.section	.bss.p_io_data_buf_1,"aw",%nobits
	.align	2
	.set	.LANCHOR184,. + 0
	.type	p_io_data_buf_1, %object
	.size	p_io_data_buf_1, 4
p_io_data_buf_1:
	.space	4
	.section	.bss.p_io_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR186,. + 0
	.type	p_io_spare_buf, %object
	.size	p_io_spare_buf, 4
p_io_spare_buf:
	.space	4
	.section	.bss.p_l2p_map_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR123,. + 0
	.type	p_l2p_map_buf, %object
	.size	p_l2p_map_buf, 4
p_l2p_map_buf:
	.space	4
	.section	.bss.p_l2p_ram_map,"aw",%nobits
	.align	2
	.set	.LANCHOR95,. + 0
	.type	p_l2p_ram_map, %object
	.size	p_l2p_ram_map, 4
p_l2p_ram_map:
	.space	4
	.section	.bss.p_map_block_table,"aw",%nobits
	.align	2
	.set	.LANCHOR126,. + 0
	.type	p_map_block_table, %object
	.size	p_map_block_table, 4
p_map_block_table:
	.space	4
	.section	.bss.p_map_block_valid_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR122,. + 0
	.type	p_map_block_valid_page_count, %object
	.size	p_map_block_valid_page_count, 4
p_map_block_valid_page_count:
	.space	4
	.section	.bss.p_map_block_ver_table,"aw",%nobits
	.align	2
	.set	.LANCHOR127,. + 0
	.type	p_map_block_ver_table, %object
	.size	p_map_block_ver_table, 4
p_map_block_ver_table:
	.space	4
	.section	.bss.p_map_region_ppn_check_table,"aw",%nobits
	.align	2
	.set	.LANCHOR192,. + 0
	.type	p_map_region_ppn_check_table, %object
	.size	p_map_region_ppn_check_table, 4
p_map_region_ppn_check_table:
	.space	4
	.section	.bss.p_map_region_ppn_table,"aw",%nobits
	.align	2
	.set	.LANCHOR128,. + 0
	.type	p_map_region_ppn_table, %object
	.size	p_map_region_ppn_table, 4
p_map_region_ppn_table:
	.space	4
	.section	.bss.p_plane_order_table,"aw",%nobits
	.set	.LANCHOR45,. + 0
	.type	p_plane_order_table, %object
	.size	p_plane_order_table, 32
p_plane_order_table:
	.space	32
	.section	.bss.p_swl_mul_table,"aw",%nobits
	.align	2
	.set	.LANCHOR134,. + 0
	.type	p_swl_mul_table, %object
	.size	p_swl_mul_table, 4
p_swl_mul_table:
	.space	4
	.section	.bss.p_sys_data_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR79,. + 0
	.type	p_sys_data_buf, %object
	.size	p_sys_data_buf, 4
p_sys_data_buf:
	.space	4
	.section	.bss.p_sys_data_buf_1,"aw",%nobits
	.align	2
	.set	.LANCHOR181,. + 0
	.type	p_sys_data_buf_1, %object
	.size	p_sys_data_buf_1, 4
p_sys_data_buf_1:
	.space	4
	.section	.bss.p_sys_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR185,. + 0
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
	.set	.LANCHOR82,. + 0
	.type	p_valid_page_count_table, %object
	.size	p_valid_page_count_table, 4
p_valid_page_count_table:
	.space	4
	.section	.bss.p_vendor_block_table,"aw",%nobits
	.align	2
	.set	.LANCHOR70,. + 0
	.type	p_vendor_block_table, %object
	.size	p_vendor_block_table, 4
p_vendor_block_table:
	.space	4
	.section	.bss.p_vendor_block_valid_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR189,. + 0
	.type	p_vendor_block_valid_page_count, %object
	.size	p_vendor_block_valid_page_count, 4
p_vendor_block_valid_page_count:
	.space	4
	.section	.bss.p_vendor_block_ver_table,"aw",%nobits
	.align	2
	.set	.LANCHOR190,. + 0
	.type	p_vendor_block_ver_table, %object
	.size	p_vendor_block_ver_table, 4
p_vendor_block_ver_table:
	.space	4
	.section	.bss.p_vendor_data_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR182,. + 0
	.type	p_vendor_data_buf, %object
	.size	p_vendor_data_buf, 4
p_vendor_data_buf:
	.space	4
	.section	.bss.p_vendor_region_ppn_table,"aw",%nobits
	.align	2
	.set	.LANCHOR191,. + 0
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
	.set	.LANCHOR76,. + 0
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
	.set	.LANCHOR179,. + 0
	.type	req_gc_dst, %object
	.size	req_gc_dst, 4
req_gc_dst:
	.space	4
	.section	.bss.req_prgm,"aw",%nobits
	.align	2
	.set	.LANCHOR180,. + 0
	.type	req_prgm, %object
	.size	req_prgm, 4
req_prgm:
	.space	4
	.section	.bss.req_read,"aw",%nobits
	.align	2
	.set	.LANCHOR178,. + 0
	.type	req_read, %object
	.size	req_read, 4
req_read:
	.space	4
	.section	.bss.req_sys,"aw",%nobits
	.align	2
	.set	.LANCHOR199,. + 0
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
	.section	.data.NandFlashParaTbl,"aw",%progbits
	.align	1
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
	.short	1503
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
	.set	.LANCHOR233,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.short	-1
	.section	.data.gFtlInitStatus,"aw",%progbits
	.align	2
	.set	.LANCHOR223,. + 0
	.type	gFtlInitStatus, %object
	.size	gFtlInitStatus, 4
gFtlInitStatus:
	.word	-1
	.section	.data.gNandParaInfo,"aw",%progbits
	.align	1
	.set	.LANCHOR29,. + 0
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
	.section	.rodata.FlashDdrTunningRead.str1.1,"aMS",%progbits,1
.LC8:
	.ascii	"sdr read ok %x ecc=%d\012\000"
.LC9:
	.ascii	"sync para %d\012\000"
.LC10:
	.ascii	"TOG mode Read error %x %x\012\000"
	.section	.rodata.FlashEraseSLc2KBlocks.str1.1,"aMS",%progbits,1
.LC1:
	.ascii	"FlashEraseBlocks pageAddr error %x\012\000"
	.section	.rodata.FlashInit.str1.1,"aMS",%progbits,1
.LC18:
	.ascii	"No.%d FLASH ID:%x %x %x %x %x %x\012\000"
.LC19:
	.ascii	"FlashLoadPhyInfo fail %x!!\012\000"
	.section	.rodata.FlashProgSlc2KPages.str1.1,"aMS",%progbits,1
.LC24:
	.ascii	"prog error: = %x\012\000"
.LC25:
	.ascii	"prog read error: = %x\012\000"
.LC26:
	.ascii	"prog read s error: = %x %x %x\012\000"
.LC27:
	.ascii	"prog read d error: = %x %x %x\012\000"
	.section	.rodata.FlashReadFacBbtData.str1.1,"aMS",%progbits,1
.LC55:
	.ascii	"BBT:\000"
	.section	.rodata.FlashReadIdbDataRaw.str1.1,"aMS",%progbits,1
.LC12:
	.ascii	"ECC:%d\012\000"
	.section	.rodata.FlashReadPage.str1.1,"aMS",%progbits,1
.LC11:
	.ascii	"read retry status %x %x %x\012\000"
	.section	.rodata.FlashReadPages.str1.1,"aMS",%progbits,1
.LC23:
	.ascii	"ReadRetry pageadd=%x ecc=%x err=%x\012\000"
	.section	.rodata.FlashReadSlc2KPages.str1.1,"aMS",%progbits,1
.LC20:
	.ascii	"Read pageadd=%x  ecc=%x err=%x\012\000"
.LC21:
	.ascii	"data:\000"
.LC22:
	.ascii	"spare:\000"
	.section	.rodata.FtlBbmMapBadBlock.str1.1,"aMS",%progbits,1
.LC2:
	.ascii	"phyBlk = 0x%x die = %d block_in_die = 0x%x 0x%8x\012"
	.ascii	"\000"
	.section	.rodata.FtlBbmTblFlush.str1.1,"aMS",%progbits,1
.LC28:
	.ascii	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\012\000"
.LC29:
	.ascii	"FtlBbmTblFlush error:%x\012\000"
.LC30:
	.ascii	"FtlBbmTblFlush error = %x error count = %d\012\000"
	.section	.rodata.FtlGcFreeTempBlock.str1.1,"aMS",%progbits,1
.LC47:
	.ascii	"GC des block %x done\012\000"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",%progbits,1
.LC46:
	.ascii	"FtlGcScanTempBlkError ID %x %x!!!!!!!\012\000"
	.section	.rodata.FtlInit.str1.1,"aMS",%progbits,1
.LC48:
	.ascii	"FTL version: 5.0.47 20171221\000"
.LC49:
	.ascii	"...%s: no bad block mapping table, format device\012"
	.ascii	"\000"
.LC50:
	.ascii	"...%s FtlSysBlkInit error ,format device!\012\000"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",%progbits,1
.LC40:
	.ascii	"no ect\000"
	.section	.rodata.FtlMapTblRecovery.str1.1,"aMS",%progbits,1
.LC42:
	.ascii	"page map lost %x %x %x %x\012\000"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",%progbits,1
.LC35:
	.ascii	"FtlMapWritePage error = %x\012\000"
.LC36:
	.ascii	"FtlMapWritePage error = %x error count = %d\012\000"
	.section	.rodata.FtlProgPages.str1.1,"aMS",%progbits,1
.LC38:
	.ascii	"Ftlwrite decrement_vpc_count %x = %d\012\000"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",%progbits,1
.LC43:
	.ascii	"RSB refresh addr %x\012\000"
.LC44:
	.ascii	"spuer block %x vpn is 0\012 \000"
.LC45:
	.ascii	"g_recovery_ppa %x ver %x\012 \000"
	.section	.rodata.FtlVendorPartRead.str1.1,"aMS",%progbits,1
.LC39:
	.ascii	"FtlVendorPartRead refresh = %x phyAddr = %x\012\000"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",%progbits,1
.LC32:
	.ascii	"FtlVpcTblFlush error = %x error count = %d\012\000"
	.section	.rodata.Ftl_load_ext_data.str1.1,"aMS",%progbits,1
.LC41:
	.ascii	"slc mode\000"
	.section	.rodata.HynixGetReadRetryDefault.str1.1,"aMS",%progbits,1
.LC16:
	.ascii	"otp error! %d\000"
.LC17:
	.ascii	"rr\000"
	.section	.rodata.INSERT_DATA_LIST.str1.1,"aMS",%progbits,1
.LC4:
	.ascii	"\012!!!!! error @ func:%s - line:%d\012\000"
.LC5:
	.ascii	"!!!!! FTL sys Error !!!!!\000"
.LC6:
	.ascii	"%s\012\000"
	.section	.rodata.MicronReadRetrial.str1.1,"aMS",%progbits,1
.LC7:
	.ascii	"micron RR %d row=%x,count %d,status=%d\012\000"
	.section	.rodata.__func__.10400,"a",%progbits
	.set	.LANCHOR240,. + 0
	.type	__func__.10400, %object
	.size	__func__.10400, 8
__func__.10400:
	.ascii	"FtlInit\000"
	.section	.rodata.__func__.10460,"a",%progbits
	.set	.LANCHOR220,. + 0
	.type	__func__.10460, %object
	.size	__func__.10460, 13
__func__.10460:
	.ascii	"FtlProgPages\000"
	.section	.rodata.__func__.10486,"a",%progbits
	.set	.LANCHOR242,. + 0
	.type	__func__.10486, %object
	.size	__func__.10486, 10
__func__.10486:
	.ascii	"ftl_write\000"
	.section	.rodata.__func__.10549,"a",%progbits
	.set	.LANCHOR121,. + 0
	.type	__func__.10549, %object
	.size	__func__.10549, 14
__func__.10549:
	.ascii	"FtlBbt2Bitmap\000"
	.section	.rodata.__func__.10595,"a",%progbits
	.set	.LANCHOR208,. + 0
	.type	__func__.10595, %object
	.size	__func__.10595, 11
__func__.10595:
	.ascii	"FtlLoadBbt\000"
	.section	.rodata.__func__.10704,"a",%progbits
	.set	.LANCHOR88,. + 0
	.type	__func__.10704, %object
	.size	__func__.10704, 17
__func__.10704:
	.ascii	"INSERT_FREE_LIST\000"
	.section	.rodata.__func__.10708,"a",%progbits
	.set	.LANCHOR85,. + 0
	.type	__func__.10708, %object
	.size	__func__.10708, 17
__func__.10708:
	.ascii	"INSERT_DATA_LIST\000"
	.section	.rodata.__func__.10738,"a",%progbits
	.set	.LANCHOR89,. + 0
	.type	__func__.10738, %object
	.size	__func__.10738, 17
__func__.10738:
	.ascii	"List_remove_node\000"
	.section	.rodata.__func__.10768,"a",%progbits
	.set	.LANCHOR93,. + 0
	.type	__func__.10768, %object
	.size	__func__.10768, 22
__func__.10768:
	.ascii	"List_update_data_list\000"
	.section	.rodata.__func__.10775,"a",%progbits
	.set	.LANCHOR212,. + 0
	.type	__func__.10775, %object
	.size	__func__.10775, 16
__func__.10775:
	.ascii	"load_l2p_region\000"
	.section	.rodata.__func__.10805,"a",%progbits
	.set	.LANCHOR94,. + 0
	.type	__func__.10805, %object
	.size	__func__.10805, 26
__func__.10805:
	.ascii	"ftl_map_blk_alloc_new_blk\000"
	.section	.rodata.__func__.10819,"a",%progbits
	.set	.LANCHOR209,. + 0
	.type	__func__.10819, %object
	.size	__func__.10819, 15
__func__.10819:
	.ascii	"ftl_map_blk_gc\000"
	.section	.rodata.__func__.10832,"a",%progbits
	.set	.LANCHOR210,. + 0
	.type	__func__.10832, %object
	.size	__func__.10832, 31
__func__.10832:
	.ascii	"Ftl_write_map_blk_to_last_page\000"
	.section	.rodata.__func__.10845,"a",%progbits
	.set	.LANCHOR211,. + 0
	.type	__func__.10845, %object
	.size	__func__.10845, 16
__func__.10845:
	.ascii	"FtlMapWritePage\000"
	.section	.rodata.__func__.10865,"a",%progbits
	.set	.LANCHOR97,. + 0
	.type	__func__.10865, %object
	.size	__func__.10865, 22
__func__.10865:
	.ascii	"select_l2p_ram_region\000"
	.section	.rodata.__func__.10881,"a",%progbits
	.set	.LANCHOR213,. + 0
	.type	__func__.10881, %object
	.size	__func__.10881, 9
__func__.10881:
	.ascii	"log2phys\000"
	.section	.rodata.__func__.10943,"a",%progbits
	.set	.LANCHOR207,. + 0
	.type	__func__.10943, %object
	.size	__func__.10943, 15
__func__.10943:
	.ascii	"FtlVpcTblFlush\000"
	.section	.rodata.__func__.10962,"a",%progbits
	.set	.LANCHOR224,. + 0
	.type	__func__.10962, %object
	.size	__func__.10962, 14
__func__.10962:
	.ascii	"FtlScanSysBlk\000"
	.section	.rodata.__func__.11016,"a",%progbits
	.set	.LANCHOR225,. + 0
	.type	__func__.11016, %object
	.size	__func__.11016, 15
__func__.11016:
	.ascii	"FtlLoadSysInfo\000"
	.section	.rodata.__func__.11085,"a",%progbits
	.set	.LANCHOR214,. + 0
	.type	__func__.11085, %object
	.size	__func__.11085, 16
__func__.11085:
	.ascii	"FtlReUsePrevPpa\000"
	.section	.rodata.__func__.11118,"a",%progbits
	.set	.LANCHOR228,. + 0
	.type	__func__.11118, %object
	.size	__func__.11118, 22
__func__.11118:
	.ascii	"FtlRecoverySuperblock\000"
	.section	.rodata.__func__.11172,"a",%progbits
	.set	.LANCHOR100,. + 0
	.type	__func__.11172, %object
	.size	__func__.11172, 16
__func__.11172:
	.ascii	"make_superblock\000"
	.section	.rodata.__func__.11192,"a",%progbits
	.set	.LANCHOR138,. + 0
	.type	__func__.11192, %object
	.size	__func__.11192, 18
__func__.11192:
	.ascii	"SupperBlkListInit\000"
	.section	.rodata.__func__.11269,"a",%progbits
	.set	.LANCHOR200,. + 0
	.type	__func__.11269, %object
	.size	__func__.11269, 25
__func__.11269:
	.ascii	"allocate_data_superblock\000"
	.section	.rodata.__func__.11283,"a",%progbits
	.set	.LANCHOR219,. + 0
	.type	__func__.11283, %object
	.size	__func__.11283, 29
__func__.11283:
	.ascii	"allocate_new_data_superblock\000"
	.section	.rodata.__func__.11289,"a",%progbits
	.set	.LANCHOR205,. + 0
	.type	__func__.11289, %object
	.size	__func__.11289, 19
__func__.11289:
	.ascii	"get_new_active_ppa\000"
	.section	.rodata.__func__.11300,"a",%progbits
	.set	.LANCHOR203,. + 0
	.type	__func__.11300, %object
	.size	__func__.11300, 16
__func__.11300:
	.ascii	"update_vpc_list\000"
	.section	.rodata.__func__.11305,"a",%progbits
	.set	.LANCHOR204,. + 0
	.type	__func__.11305, %object
	.size	__func__.11305, 20
__func__.11305:
	.ascii	"decrement_vpc_count\000"
	.section	.rodata.__func__.11373,"a",%progbits
	.set	.LANCHOR234,. + 0
	.type	__func__.11373, %object
	.size	__func__.11373, 19
__func__.11373:
	.ascii	"FtlGcFreeTempBlock\000"
	.section	.rodata.__func__.11467,"a",%progbits
	.set	.LANCHOR238,. + 0
	.type	__func__.11467, %object
	.size	__func__.11467, 23
__func__.11467:
	.ascii	"rk_ftl_garbage_collect\000"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",%progbits,1
.LC31:
	.ascii	"decrement_vpc_count %x = %d\012\000"
	.section	.rodata.ftl_fix_nand_power_lost_error.str1.1,"aMS",%progbits,1
.LC52:
	.ascii	"fix power lost blk = %x vpc=%x\012\000"
.LC53:
	.ascii	"erase power lost blk = %x vpc=%x\012\000"
	.section	.rodata.ftl_map_blk_gc.str1.1,"aMS",%progbits,1
.LC33:
	.ascii	"ftl_map_blk_gc blk info: %x %x %x\012\000"
.LC34:
	.ascii	"page map lost: %x %x\012\000"
	.section	.rodata.ftl_write.str1.1,"aMS",%progbits,1
.LC54:
	.ascii	"FtlWrite: lpa error:%x %x\012\000"
	.section	.rodata.load_l2p_region.str1.1,"aMS",%progbits,1
.LC37:
	.ascii	"load_l2p_region refresh = %x phyAddr = %x\012\000"
	.section	.rodata.remove_from_free_sys_Queue.str1.1,"aMS",%progbits,1
.LC3:
	.ascii	"remove_from_free_sys_Queue %x\012\000"
	.section	.rodata.rk_ftl_init.str1.1,"aMS",%progbits,1
.LC51:
	.ascii	"FtlInit %x\012\000"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",%progbits,1
.LC13:
	.ascii	"%s 0x%x:\000"
.LC14:
	.ascii	"%x \000"
.LC15:
	.ascii	"\000"
	.hidden	free
