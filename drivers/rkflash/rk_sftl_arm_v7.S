/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:    GPL-2.0
 * date: 2018-09-29
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
	.file	"rk_sftl.c"
	.global	__aeabi_uidiv
	.section	.text.l2p_addr_tran.isra.0,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	l2p_addr_tran.isra.0, %function
l2p_addr_tran.isra.0:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	lsrs	r7, r0, #10
	ldr	r3, .L3
	mov	r8, r1
	mov	r6, r0
	uxth	r0, r7
	mov	r10, r2
	uxth	r7, r7
	ldrh	r4, [r3, #8]
	ubfx	r6, r6, #0, #10
	ldrh	r5, [r3, #10]
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	itt	eq
	lsreq	r4, r4, #1
	lsleq	r5, r5, #1
	mov	r1, r4
	it	eq
	uxtheq	r5, r5
	bl	__aeabi_uidiv
	uxth	r0, r0
	mls	r4, r0, r4, r7
	mla	r4, r5, r4, r6
	str	r4, [r8]
	str	r0, [r10]
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L4:
	.align	2
.L3:
	.word	.LANCHOR0
	.size	l2p_addr_tran.isra.0, .-l2p_addr_tran.isra.0
	.section	.text.ftl_set_blk_mode.part.6,"ax",%progbits
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_set_blk_mode.part.6, %function
ftl_set_blk_mode.part.6:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L6
	lsrs	r1, r0, #5
	and	r0, r0, #31
	ldr	r2, [r3]
	movs	r3, #1
	lsl	r0, r3, r0
	ldr	r3, [r2, r1, lsl #2]
	orrs	r3, r3, r0
	str	r3, [r2, r1, lsl #2]
	bx	lr
.L7:
	.align	2
.L6:
	.word	.LANCHOR1
	.size	ftl_set_blk_mode.part.6, .-ftl_set_blk_mode.part.6
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
.L9:
	cmp	r2, r0
	uxth	r3, r1
	add	r1, r1, #1
	bls	.L10
	subs	r0, r3, #1
	uxth	r0, r0
	bx	lr
.L10:
	lsls	r2, r2, #1
	b	.L9
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
	ldr	r3, .L13
	cmp	r0, #24
	it	cc
	movcc	r0, #24
	ldr	r2, .L13+4
	str	r0, [r3]
	ldr	r3, .L13+8
	ldrh	r3, [r3]
	muls	r3, r0, r3
	str	r3, [r2]
	ldr	r2, .L13+12
	ldrh	r2, [r2]
	subs	r0, r2, r0
	ldr	r2, .L13+16
	strh	r0, [r2]	@ movhi
	movs	r0, #0
	ldr	r2, .L13+20
	ldr	r2, [r2]
	subs	r3, r2, r3
	ldr	r2, .L13+24
	str	r3, [r2]
	bx	lr
.L14:
	.align	2
.L13:
	.word	.LANCHOR2
	.word	.LANCHOR4
	.word	.LANCHOR3
	.word	.LANCHOR6
	.word	.LANCHOR5
	.word	.LANCHOR8
	.word	.LANCHOR7
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
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r1, [r0]
	ldr	r2, .L25
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	ldrh	r5, [r0, #2]
	strh	r1, [r2]	@ movhi
	ldr	r2, .L25+4
	ldrh	r0, [r0, #4]
	strh	r5, [r2]	@ movhi
	ldr	r2, .L25+8
	strh	r0, [r2]	@ movhi
	ldrh	r2, [r7, #14]
	cmp	r2, #4
	bne	.L16
	ldrh	r2, [r7, #6]
	ldr	r4, .L25+12
	lsrs	r2, r2, #1
	strh	r2, [r4]	@ movhi
	movs	r4, #8
	ldr	r2, .L25+16
	strh	r4, [r2]	@ movhi
.L16:
	ldr	r4, .L25+20
	movs	r2, #0
.L17:
	strb	r2, [r2, r4]
	adds	r2, r2, #1
	cmp	r2, #32
	bne	.L17
	ldr	r2, .L25+24
	cmp	r1, #1
	mov	r4, #5
	smulbb	r5, r5, r0
	mov	r6, #0
	strh	r4, [r2]	@ movhi
	it	eq
	strheq	r1, [r2]	@ movhi
	mov	r1, #640
	ldr	r2, .L25+28
	uxth	r5, r5
	ldr	r4, .L25+32
	strh	r1, [r2]	@ movhi
	ldr	r2, .L25+36
	strh	r6, [r4]	@ movhi
	ldr	r6, .L25+40
	strh	r5, [r2]	@ movhi
	ldr	r2, .L25+12
	ldrh	r4, [r2]
	ldr	r2, .L25+44
	smulbb	r0, r0, r4
	uxth	r0, r0
	strh	r0, [r2]	@ movhi
	bl	Ftl_log2
	ldr	r2, .L25+48
	ldrh	r8, [r7, #12]
	ldr	r3, .L25+52
	strh	r0, [r2]	@ movhi
	ldr	r2, .L25+56
	smulbb	r1, r5, r8
	strh	r8, [r3]	@ movhi
	strh	r8, [r2]	@ movhi
	ldr	r2, .L25+60
	strh	r1, [r2]	@ movhi
	ldr	r2, .L25+16
	ldrh	fp, [r2]
	mov	r0, fp
	bl	Ftl_log2
	lsl	r2, fp, #9
	ldr	r1, .L25+64
	ldr	r3, .L25+68
	mov	r10, r0
	uxth	r2, r2
	strh	r0, [r6]	@ movhi
	mov	r0, #5120
	strh	r2, [r1]	@ movhi
	lsrs	r2, r2, #8
	ldr	r1, .L25+72
	strh	r2, [r1]	@ movhi
	mul	r1, r8, fp
	ldrh	r2, [r7, #20]
	ldr	r7, .L25+52
	strh	r2, [r3]	@ movhi
	mul	r3, r4, r5
	ldr	r2, .L25+76
	lsls	r4, r4, #6
	str	r3, [r2]
	mul	r3, fp, r3
	ldr	r2, .L25+80
	mul	r3, r8, r3
	ldr	r8, .L25+116
	asrs	r3, r3, #11
	str	r3, [r2]
	bl	__aeabi_idiv
	uxth	r0, r0
	ldr	r2, .L25+84
	mov	r1, r5
	cmp	r0, #4
	itet	ls
	movls	r3, #4
	strhhi	r0, [r8]	@ movhi
	strhls	r3, [r8]	@ movhi
	mov	r3, #640
	asr	r3, r3, r10
	add	r10, r10, #9
	asr	r4, r4, r10
	ldr	r10, .L25+120
	adds	r3, r3, #2
	ldrh	r0, [r8]
	strh	r3, [r2]	@ movhi
	ldr	r3, .L25+88
	strh	r4, [r3]	@ movhi
	uxth	r4, r4
	mul	r3, r5, r4
	adds	r4, r4, #8
	str	r3, [r10]
	bl	__aeabi_uidiv
	uxtah	r0, r4, r0
	ldr	r4, .L25+92
	cmp	r5, #1
	it	eq
	addeq	r0, r0, #4
	str	r0, [r4]
	ldrh	r0, [r4]
	bl	FtlSysBlkNumInit
	ldr	r2, [r4]
	movs	r0, #0
	ldr	r3, .L25+96
	str	r2, [r3]
	ldr	r3, .L25+100
	ldr	r2, [r3]
	ldrh	r3, [r7]
	lsls	r2, r2, #2
	muls	r3, r2, r3
	ldrh	r2, [r6]
	adds	r2, r2, #9
	lsrs	r3, r3, r2
	ldr	r2, .L25+104
	adds	r3, r3, #2
	strh	r3, [r2]	@ movhi
	movs	r2, #32
	ldr	r3, .L25+108
	strh	r2, [r3]	@ movhi
	ldr	r3, .L25+112
	str	r0, [r3]
	ldrh	r3, [r8]
	adds	r3, r3, #3
	strh	r3, [r8]	@ movhi
	ldr	r3, [r10]
	adds	r3, r3, #3
	str	r3, [r10]
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L26:
	.align	2
.L25:
	.word	.LANCHOR9
	.word	.LANCHOR10
	.word	.LANCHOR11
	.word	.LANCHOR6
	.word	.LANCHOR12
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LANCHOR16
	.word	.LANCHOR15
	.word	.LANCHOR3
	.word	.LANCHOR22
	.word	.LANCHOR17
	.word	.LANCHOR18
	.word	.LANCHOR19
	.word	.LANCHOR20
	.word	.LANCHOR21
	.word	.LANCHOR23
	.word	.LANCHOR25
	.word	.LANCHOR24
	.word	.LANCHOR8
	.word	.LANCHOR26
	.word	.LANCHOR28
	.word	.LANCHOR29
	.word	.LANCHOR2
	.word	.LANCHOR31
	.word	.LANCHOR7
	.word	.LANCHOR32
	.word	.LANCHOR33
	.word	.LANCHOR34
	.word	.LANCHOR27
	.word	.LANCHOR30
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
	ldr	r3, .L34
	ldrh	r3, [r3]
	cbz	r3, .L33
	ldr	r3, .L34+4
	ldr	r2, .L34+8
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L29:
	cmp	r3, r2
	bne	.L30
.L33:
	movs	r0, #0
	bx	lr
.L30:
	ldrh	r1, [r3], #2
	cmp	r0, r1
	bne	.L29
	movs	r0, #1
	bx	lr
.L35:
	.align	2
.L34:
	.word	.LANCHOR35
	.word	.LANCHOR36
	.word	.LANCHOR27
	.size	IsBlkInVendorPart, .-IsBlkInVendorPart
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
	@ link register save eliminated.
	movs	r0, #0
	bx	lr
	.size	FtlCacheWriteBack, .-FtlCacheWriteBack
	.section	.text.sftl_get_density,"ax",%progbits
	.align	1
	.global	sftl_get_density
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sftl_get_density, %function
sftl_get_density:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L38
	ldr	r0, [r3]
	bx	lr
.L39:
	.align	2
.L38:
	.word	.LANCHOR34
	.size	sftl_get_density, .-sftl_get_density
	.global	__aeabi_uidivmod
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
	ldr	r3, .L41
	push	{r0, r1, r2, r4, r5, r6, r7, lr}
	mov	r5, r0
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	mov	r1, r4
	ldr	r4, .L41+4
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
	ldr	r0, .L41+8
	bl	printf
	ldrh	r3, [r4, #6]
	movs	r0, #0
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L42:
	.align	2
.L41:
	.word	.LANCHOR17
	.word	.LANCHOR37
	.word	.LC0
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
	ldr	r3, .L44
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	mov	r1, r5
	bl	__aeabi_uidivmod
	mov	r0, r6
	uxth	r4, r1
	mov	r1, r5
	bl	__aeabi_uidiv
	ldr	r3, .L44+4
	uxth	r0, r0
	lsrs	r2, r4, #5
	and	r4, r4, #31
	add	r0, r3, r0, lsl #2
	ldr	r3, [r0, #28]
	ldr	r0, [r3, r2, lsl #2]
	lsrs	r0, r0, r4
	and	r0, r0, #1
	pop	{r4, r5, r6, pc}
.L45:
	.align	2
.L44:
	.word	.LANCHOR17
	.word	.LANCHOR37
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
	.section	.text.FtlBbtCalcTotleCnt,"ax",%progbits
	.align	1
	.global	FtlBbtCalcTotleCnt
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlBbtCalcTotleCnt, %function
FtlBbtCalcTotleCnt:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L54
	ldr	r2, .L54+4
	push	{r4, r5, r6, lr}
	movs	r5, #0
	ldrh	r3, [r3]
	mov	r4, r5
	ldrh	r6, [r2]
	muls	r6, r3, r6
.L48:
	uxth	r0, r5
	cmp	r0, r6
	blt	.L50
	mov	r0, r4
	pop	{r4, r5, r6, pc}
.L50:
	bl	FtlBbmIsBadBlock
	cbz	r0, .L49
	adds	r4, r4, #1
	uxth	r4, r4
.L49:
	adds	r5, r5, #1
	b	.L48
.L55:
	.align	2
.L54:
	.word	.LANCHOR17
	.word	.LANCHOR10
	.size	FtlBbtCalcTotleCnt, .-FtlBbtCalcTotleCnt
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
	ldr	r3, .L57
	mov	r7, r0
	ldrh	r6, [r3]
	mov	r1, r6
	bl	__aeabi_uidiv
	ldr	r3, .L57+4
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
.L58:
	.align	2
.L57:
	.word	.LANCHOR11
	.word	.LANCHOR17
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
	ldr	r3, .L60
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	ldr	r3, .L60+4
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	smulbb	r4, r0, r5
	mov	r1, r5
	mov	r0, r6
	bl	__aeabi_uidivmod
	add	r1, r1, r4
	uxth	r0, r1
	pop	{r4, r5, r6, pc}
.L61:
	.align	2
.L60:
	.word	.LANCHOR11
	.word	.LANCHOR17
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
	ldr	r3, .L63
	ldrh	r1, [r3]
	bl	__aeabi_uidivmod
	ldr	r3, .L63+4
	uxth	r0, r1
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	uxth	r0, r0
	pop	{r3, pc}
.L64:
	.align	2
.L63:
	.word	.LANCHOR17
	.word	.LANCHOR11
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
	bls	.L66
	subs	r0, r0, r1
	cmp	r0, #-2147483648
	ite	hi
	movhi	r0, #0
	movls	r0, #1
	bx	lr
.L66:
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
	ldr	r3, .L69
	ldrh	r0, [r3, #6]
	clz	r0, r0
	lsrs	r0, r0, #5
	bx	lr
.L70:
	.align	2
.L69:
	.word	.LANCHOR38
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
	ldr	r3, .L72
	ldrh	r0, [r3, #6]
	sub	r3, r0, #1024
	rsbs	r0, r3, #0
	adcs	r0, r0, r3
	bx	lr
.L73:
	.align	2
.L72:
	.word	.LANCHOR38
	.size	FtlFreeSysBlkQueueFull, .-FtlFreeSysBlkQueueFull
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
	ldr	r3, .L83
	push	{r4, r5, r6, lr}
	ldrh	r2, [r3, #6]
	cbz	r2, .L74
	ldr	r2, .L83+4
	movs	r6, #0
	ldrh	r1, [r3, #2]
	mov	r5, r6
	ldrh	r4, [r2, #28]
	ldrh	r2, [r3, #4]
	and	r4, r4, #31
.L76:
	uxth	r0, r6
	adds	r6, r6, #1
	cmp	r4, r0
	bgt	.L77
	cbz	r5, .L74
	strh	r1, [r3, #2]	@ movhi
	strh	r2, [r3, #4]	@ movhi
.L74:
	pop	{r4, r5, r6, pc}
.L77:
	adds	r0, r1, #4
	adds	r1, r1, #1
	ldrh	r5, [r3, r0, lsl #1]
	adds	r0, r2, #4
	ubfx	r1, r1, #0, #10
	strh	r5, [r3, r0, lsl #1]	@ movhi
	movs	r5, #1
	add	r2, r2, r5
	ubfx	r2, r2, #0, #10
	b	.L76
.L84:
	.align	2
.L83:
	.word	.LANCHOR38
	.word	.LANCHOR39
	.size	FtlFreeSysBLkSort, .-FtlFreeSysBLkSort
	.section	.text.IsInFreeQueue,"ax",%progbits
	.align	1
	.global	IsInFreeQueue
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	IsInFreeQueue, %function
IsInFreeQueue:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L91
	push	{r4, r5, lr}
	ldrh	r4, [r3, #6]
	cmp	r4, #1024
	beq	.L89
	ldrh	r5, [r3, #2]
	movs	r1, #0
.L87:
	cmp	r1, r4
	bcc	.L88
.L89:
	movs	r0, #0
	pop	{r4, r5, pc}
.L88:
	adds	r2, r1, r5
	ubfx	r2, r2, #0, #10
	adds	r2, r2, #4
	ldrh	r2, [r3, r2, lsl #1]
	cmp	r2, r0
	beq	.L90
	adds	r1, r1, #1
	b	.L87
.L90:
	movs	r0, #1
	pop	{r4, r5, pc}
.L92:
	.align	2
.L91:
	.word	.LANCHOR38
	.size	IsInFreeQueue, .-IsInFreeQueue
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
	ldr	r3, .L109
	ldrh	lr, [r3]
	cmp	lr, r0
	bls	.L95
	ldr	r3, .L109+4
	movs	r5, #6
	ldr	r4, [r3]
	mul	r3, r5, r0
	str	r3, [sp, #4]
	adds	r1, r4, r3
	ldr	r2, [sp, #4]
	movw	r3, #65535
	strh	r3, [r1, #2]	@ movhi
	strh	r3, [r4, r2]	@ movhi
	ldr	r3, .L109+8
	ldr	ip, [r3]
	cmp	ip, #0
	bne	.L96
.L108:
	str	r1, [r3]
.L95:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L96:
	ldr	r3, .L109+12
	lsls	r2, r0, #1
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldrh	r6, [r3, r0, lsl #1]
	ldrh	r3, [r1, #4]
	cbz	r3, .L106
	mul	fp, r3, r6
.L97:
	sub	r3, ip, r4
	asrs	r6, r3, #1
	ldr	r3, .L109+16
	muls	r3, r6, r3
	ldr	r6, .L109+20
	ldr	r8, [r6]
	movs	r6, #0
	uxth	r3, r3
	add	r2, r8, r2
	str	r2, [sp, #12]
	mov	r2, ip
.L104:
	adds	r6, r6, #1
	uxth	r6, r6
	cmp	lr, r6
	bcc	.L95
	cmp	r3, r0
	beq	.L95
	ldr	r7, [sp, #8]
	lsl	r10, r3, #1
	ldrh	r7, [r7, r3, lsl #1]
	mov	r5, r7
	ldrh	r7, [r2, #4]
	cbz	r7, .L107
	muls	r7, r5, r7
.L99:
	cmp	fp, r7
	bne	.L100
	ldr	r5, [sp, #12]
	ldrh	r10, [r8, r10]
	ldrh	r7, [r5]
	cmp	r10, r7
	bcc	.L102
.L101:
	ldr	r5, [sp, #4]
	cmp	r2, ip
	strh	r3, [r4, r5]	@ movhi
	ldrh	r3, [r2, #2]
	strh	r3, [r1, #2]	@ movhi
	bne	.L105
	strh	r0, [r2, #2]	@ movhi
	ldr	r3, .L109+8
	b	.L108
.L106:
	mov	fp, #-1
	b	.L97
.L107:
	mov	r7, #-1
	b	.L99
.L100:
	bcc	.L101
.L102:
	ldrh	r7, [r2]
	movw	r5, #65535
	cmp	r7, r5
	bne	.L103
	strh	r3, [r1, #2]	@ movhi
	strh	r0, [r2]	@ movhi
	ldr	r3, .L109+24
	b	.L108
.L103:
	movs	r3, #6
	mla	r2, r3, r7, r4
	mov	r3, r7
	b	.L104
.L105:
	ldrh	r1, [r2, #2]
	movs	r3, #6
	muls	r3, r1, r3
	strh	r0, [r4, r3]	@ movhi
	strh	r0, [r2, #2]	@ movhi
	b	.L95
.L110:
	.align	2
.L109:
	.word	.LANCHOR5
	.word	.LANCHOR40
	.word	.LANCHOR41
	.word	.LANCHOR42
	.word	-1431655765
	.word	.LANCHOR43
	.word	.LANCHOR44
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
	ldr	r2, .L113
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L113+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L111
	movs	r2, #214
	ldr	r1, .L113+8
	ldr	r0, .L113+12
	pop	{r3, lr}
	b	printf
.L111:
	pop	{r3, pc}
.L114:
	.align	2
.L113:
	.word	.LANCHOR45
	.word	.LANCHOR5
	.word	.LANCHOR46
	.word	.LC1
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
	beq	.L116
	ldr	r3, .L122
	mov	r10, #6
	mul	r7, r10, r0
	ldr	r4, [r3]
	ldr	r3, .L122+4
	adds	r5, r4, r7
	ldr	r6, [r3]
	mov	lr, r3
	strh	r1, [r5, #2]	@ movhi
	strh	r1, [r4, r7]	@ movhi
	cbnz	r6, .L117
	str	r5, [r3]
.L116:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L117:
	ldr	r3, .L122+8
	subs	r2, r6, r4
	mov	fp, r1
	ldr	ip, [r3]
	asrs	r3, r2, #1
	ldr	r2, .L122+12
	ldrh	r8, [ip, r0, lsl #1]
	muls	r2, r3, r2
	mov	r3, r6
	uxth	r2, r2
.L120:
	ldrh	r1, [ip, r2, lsl #1]
	cmp	r1, r8
	bcs	.L118
	ldrh	r1, [r3]
	cmp	r1, fp
	bne	.L119
	strh	r2, [r5, #2]	@ movhi
	strh	r0, [r3]	@ movhi
	b	.L116
.L119:
	mla	r3, r10, r1, r4
	mov	r2, r1
	b	.L120
.L118:
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
	b	.L116
.L123:
	.align	2
.L122:
	.word	.LANCHOR40
	.word	.LANCHOR47
	.word	.LANCHOR43
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
	ldr	r2, .L126
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L126+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L124
	movs	r2, #207
	ldr	r1, .L126+8
	ldr	r0, .L126+12
	pop	{r3, lr}
	b	printf
.L124:
	pop	{r3, pc}
.L127:
	.align	2
.L126:
	.word	.LANCHOR48
	.word	.LANCHOR5
	.word	.LANCHOR49
	.word	.LC1
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
	ldr	r5, .L134
	muls	r6, r1, r6
	movw	r3, #65535
	mov	r8, r0
	ldr	r7, [r5]
	adds	r4, r7, r6
	ldrh	r2, [r4, #2]
	cmp	r2, r3
	bne	.L129
	ldr	r3, [r0]
	cmp	r4, r3
	beq	.L129
	mov	r2, #372
	ldr	r1, .L134+4
	ldr	r0, .L134+8
	bl	printf
.L129:
	ldr	r3, [r8]
	movw	r1, #65535
	cmp	r4, r3
	ldrh	r3, [r7, r6]
	bne	.L130
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
.L132:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r7, r6]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	pop	{r4, r5, r6, r7, r8, pc}
.L130:
	cmp	r3, r1
	ldrh	r1, [r4, #2]
	bne	.L133
	cmp	r1, r3
	beq	.L132
	movs	r2, #6
	ldr	r0, [r5]
	muls	r1, r2, r1
	strh	r3, [r0, r1]	@ movhi
	b	.L132
.L133:
	ldr	r0, [r5]
	movs	r2, #6
	mla	r5, r2, r3, r0
	strh	r1, [r5, #2]	@ movhi
	ldrh	r1, [r4, #2]
	muls	r2, r1, r2
	strh	r3, [r0, r2]	@ movhi
	b	.L132
.L135:
	.align	2
.L134:
	.word	.LANCHOR40
	.word	.LANCHOR50
	.word	.LC1
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
	cbz	r3, .L142
	ldr	r2, .L143
	movw	r5, #65535
	movs	r6, #6
	ldr	r2, [r2]
.L138:
	cbnz	r1, .L139
.L141:
	ldr	r4, .L143+4
	subs	r3, r3, r2
	asrs	r3, r3, #1
	muls	r4, r3, r4
	uxth	r1, r4
	bl	List_remove_node
	uxth	r0, r4
	pop	{r4, r5, r6, pc}
.L139:
	ldrh	r4, [r3]
	cmp	r4, r5
	beq	.L141
	subs	r1, r1, #1
	mla	r3, r6, r4, r2
	uxth	r1, r1
	b	.L138
.L142:
	movw	r0, #65535
	pop	{r4, r5, r6, pc}
.L144:
	.align	2
.L143:
	.word	.LANCHOR40
	.word	-1431655765
	.size	List_pop_index_node, .-List_pop_index_node
	.section	.text.List_pop_head_node,"ax",%progbits
	.align	1
	.global	List_pop_head_node
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	List_pop_head_node, %function
List_pop_head_node:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r1, #0
	b	List_pop_index_node
	.size	List_pop_head_node, .-List_pop_head_node
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
	ldr	r3, .L152
	push	{r4, lr}
	ldr	r3, [r3]
	cbz	r3, .L151
	ldr	r2, .L152+4
	movs	r4, #6
	ldr	r1, [r2]
	movw	r2, #65535
.L148:
	cbz	r0, .L149
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L150
.L151:
	movw	r0, #65535
	pop	{r4, pc}
.L150:
	subs	r0, r0, #1
	mla	r3, r4, r3, r1
	uxth	r0, r0
	b	.L148
.L149:
	ldr	r0, .L152+8
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r0, r3
	uxth	r0, r3
	pop	{r4, pc}
.L153:
	.align	2
.L152:
	.word	.LANCHOR41
	.word	.LANCHOR40
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
	ldr	r3, .L165
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L156
	ldr	r3, .L165+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L156
	ldr	r3, .L165+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L156
	ldr	r7, .L165+12
	movs	r6, #6
	ldr	r3, .L165+16
	muls	r6, r0, r6
	ldr	fp, [r7]
	ldr	r3, [r3]
	add	r10, fp, r6
	cmp	r10, r3
	beq	.L156
	ldr	r3, .L165+20
	ldrh	r5, [r10, #4]
	ldr	r2, [r3]
	mov	r8, r3
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r5, #0
	beq	.L163
	muls	r5, r2, r5
.L158:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L159
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	bne	.L159
	movw	r2, #463
	ldr	r1, .L165+24
	ldr	r0, .L165+28
	bl	printf
.L159:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L160
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	beq	.L156
.L160:
	movs	r2, #6
	muls	r2, r3, r2
	ldr	r3, .L165+32
	asrs	r1, r2, #1
	muls	r3, r1, r3
	ldr	r1, [r8]
	ldrh	r0, [r1, r3, lsl #1]
	ldr	r1, [r7]
	add	r2, r2, r1
	ldrh	r3, [r2, #4]
	cbz	r3, .L164
	muls	r3, r0, r3
.L161:
	cmp	r5, r3
	bcs	.L156
	ldr	r5, .L165+36
	mov	r1, r4
	ldr	r0, .L165+16
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L162
	mov	r2, #474
	ldr	r1, .L165+24
	ldr	r0, .L165+28
	bl	printf
.L162:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	INSERT_DATA_LIST
.L156:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L163:
	mov	r5, #-1
	b	.L158
.L164:
	mov	r3, #-1
	b	.L161
.L166:
	.align	2
.L165:
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR40
	.word	.LANCHOR41
	.word	.LANCHOR42
	.word	.LANCHOR54
	.word	.LC1
	.word	-1431655765
	.word	.LANCHOR45
	.size	List_update_data_list, .-List_update_data_list
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
	ldr	r3, .L177
	movs	r0, #12
	movw	r5, #65535
	ldrh	r2, [r3]
	ldr	r3, .L177+4
	ldr	r3, [r3]
.L168:
	uxth	r4, r1
	cmp	r4, r2
	bcc	.L170
	mov	r4, r2
	movs	r1, #0
	mov	r6, #-2147483648
	movs	r7, #12
.L171:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L173
	cmp	r4, r2
	bcc	.L169
	ldr	r1, .L177+8
	mov	r4, r2
	mov	r0, #-1
	ldrh	r7, [r1]
	movs	r1, #0
.L174:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L176
	cmp	r4, r2
	bcc	.L169
	movw	r2, #787
	ldr	r1, .L177+12
	ldr	r0, .L177+16
	bl	printf
	b	.L169
.L170:
	adds	r1, r1, #1
	mla	r6, r0, r1, r3
	ldrh	r6, [r6, #-12]
	cmp	r6, r5
	bne	.L168
.L169:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L173:
	mla	r0, r7, r1, r3
	ldr	r0, [r0, #4]
	cmp	r0, #0
	blt	.L172
	cmp	r6, r0
	itt	hi
	movhi	r6, r0
	movhi	r4, r5
.L172:
	adds	r1, r1, #1
	b	.L171
.L176:
	ldr	r6, [r3, #4]
	cmp	r0, r6
	bls	.L175
	ldrh	ip, [r3]
	cmp	ip, r7
	itt	ne
	movne	r0, r6
	movne	r4, r5
.L175:
	adds	r1, r1, #1
	adds	r3, r3, #12
	b	.L174
.L178:
	.align	2
.L177:
	.word	.LANCHOR33
	.word	.LANCHOR55
	.word	.LANCHOR56
	.word	.LANCHOR57
	.word	.LC1
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
	ldr	r2, .L189
	push	{r4, r5, r6, lr}
	mov	r1, r2
	ldrh	r3, [r2]
	cmp	r3, #4
	bhi	.L180
	cbnz	r0, .L180
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	pop	{r4, r5, r6, pc}
.L180:
	movs	r3, #0
	ldr	r0, .L189+4
	strh	r3, [r1]	@ movhi
	movw	r6, #65535
	ldr	r1, .L189+8
	ldrh	r4, [r0]
	mov	r0, r3
	ldr	r2, .L189+12
	ldr	r1, [r1]
	str	r3, [r2]
	add	r4, r1, r4, lsl #1
.L181:
	cmp	r1, r4
	bne	.L183
	cbz	r3, .L179
	str	r0, [r2]
.L179:
	pop	{r4, r5, r6, pc}
.L183:
	ldrh	r5, [r1], #2
	cmp	r5, r6
	itt	ne
	addne	r0, r0, r5
	movne	r3, #1
	b	.L181
.L190:
	.align	2
.L189:
	.word	.LANCHOR58
	.word	.LANCHOR5
	.word	.LANCHOR42
	.word	.LANCHOR59
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
	cbz	r1, .L192
	b	ftl_set_blk_mode.part.6
.L192:
	ldr	r2, .L193
	lsrs	r0, r0, #5
	and	r3, r3, #31
	ldr	r1, [r2]
	movs	r2, #1
	lsl	r3, r2, r3
	ldr	r2, [r1, r0, lsl #2]
	bic	r2, r2, r3
	str	r2, [r1, r0, lsl #2]
	bx	lr
.L194:
	.align	2
.L193:
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
	ldr	r3, .L196
	lsrs	r2, r0, #5
	and	r0, r0, #31
	ldr	r3, [r3]
	ldr	r3, [r3, r2, lsl #2]
	lsr	r0, r3, r0
	and	r0, r0, #1
	bx	lr
.L197:
	.align	2
.L196:
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
	ldr	r3, .L205
	ldrh	r4, [r3]
	add	r3, r0, r2, lsl #1
	adds	r3, r3, #14
.L199:
	cmp	r2, r4
	bcc	.L201
	ldr	r3, .L205+4
	add	r5, r0, #16
	movw	r6, #65535
	ldrh	r3, [r3]
	subs	r3, r3, #1
	subs	r1, r3, r1
	movs	r3, #0
	uxth	r1, r1
.L202:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L204
	pop	{r4, r5, r6, pc}
.L201:
	ldrh	r5, [r3, #2]!
	adds	r2, r2, #1
	uxth	r2, r2
	cmp	r5, r6
	ittt	ne
	ldrhne	r5, [r0, #4]
	addne	r5, r5, #1
	strhne	r5, [r0, #4]	@ movhi
	b	.L199
.L204:
	ldrh	r2, [r5], #2
	adds	r3, r3, #1
	cmp	r2, r6
	ittt	ne
	ldrhne	r2, [r0, #4]
	addne	r2, r2, r1
	strhne	r2, [r0, #4]	@ movhi
	b	.L202
.L206:
	.align	2
.L205:
	.word	.LANCHOR3
	.word	.LANCHOR19
	.size	ftl_sb_update_avl_pages, .-ftl_sb_update_avl_pages
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
	push	{r4, r5, lr}
	cbz	r3, .L207
	ldrh	r2, [r0]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L207
	ldrb	r2, [r0, #6]	@ zero_extendqisi2
	movs	r5, #0
	adds	r2, r2, #8
	ldrh	r1, [r0, r2, lsl #1]
	ldr	r2, .L213
	ldrh	r4, [r2]
	mov	r2, r3
.L210:
	cmp	r1, r2
	beq	.L212
.L207:
	pop	{r4, r5, pc}
.L212:
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, r4
	strb	r3, [r0, #6]
	itttt	eq
	ldrheq	r3, [r0, #2]
	strbeq	r5, [r0, #6]
	addeq	r3, r3, #1
	strheq	r3, [r0, #2]	@ movhi
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r1, [r0, r3, lsl #1]
	b	.L210
.L214:
	.align	2
.L213:
	.word	.LANCHOR3
	.size	FtlSlcSuperblockCheck, .-FtlSlcSuperblockCheck
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
	ldr	r3, .L220
	ldrh	r2, [r0]
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L216
	movw	r2, #2110
	ldr	r1, .L220+4
	ldr	r0, .L220+8
	bl	printf
.L216:
	ldr	r3, .L220+12
	add	r6, r4, #16
	ldr	r10, .L220+20
	movw	r7, #65535
	movs	r5, #0
	ldrh	r8, [r3]
	strh	r5, [r4, #4]	@ movhi
	strb	r5, [r4, #7]
.L217:
	uxth	r3, r5
	cmp	r8, r3
	bhi	.L219
	ldr	r2, .L220+16
	movs	r0, #0
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	strb	r0, [r4, #9]
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	strh	r3, [r4, #4]	@ movhi
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L219:
	ldrh	r1, [r4]
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	strh	r7, [r6]	@ movhi
	mov	fp, r0
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L218
	strh	fp, [r6]	@ movhi
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r4, #7]
.L218:
	adds	r5, r5, #1
	adds	r6, r6, #2
	b	.L217
.L221:
	.align	2
.L220:
	.word	.LANCHOR5
	.word	.LANCHOR60
	.word	.LC1
	.word	.LANCHOR3
	.word	.LANCHOR19
	.word	.LANCHOR13
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
	ldr	r3, .L228
	mov	r6, r0
	mov	r4, r5
	ldr	r10, .L228+12
	ldrh	r7, [r3]
	ldr	r3, .L228+4
	ldrh	r8, [r3]
.L223:
	uxth	r3, r5
	cmp	r7, r3
	bhi	.L225
	cbz	r4, .L227
	mov	r1, r4
	mov	r0, #32768
	bl	__aeabi_idiv
.L226:
	ldr	r3, .L228+8
	movs	r2, #6
	ldr	r3, [r3]
	mla	r6, r2, r6, r3
	strh	r0, [r6, #4]	@ movhi
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L225:
	mov	r1, r6
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L224
	add	r4, r4, r8
	uxth	r4, r4
.L224:
	adds	r5, r5, #1
	b	.L223
.L227:
	mov	r0, r4
	b	.L226
.L229:
	.align	2
.L228:
	.word	.LANCHOR3
	.word	.LANCHOR19
	.word	.LANCHOR40
	.word	.LANCHOR13
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
	ldr	r3, .L233
	ldr	r0, [r3]
	cbz	r0, .L231
	ldr	r3, .L233+4
	ldr	r3, [r3]
	subs	r0, r0, r3
	ldr	r3, .L233+8
	asrs	r0, r0, #1
	muls	r0, r3, r0
	ldr	r3, .L233+12
	ldr	r3, [r3]
	uxth	r0, r0
	ldrh	r0, [r3, r0, lsl #1]
.L231:
	bx	lr
.L234:
	.align	2
.L233:
	.word	.LANCHOR47
	.word	.LANCHOR40
	.word	-1431655765
	.word	.LANCHOR43
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
	ldr	r3, .L243
	push	{r4, r5, r6, lr}
	ldr	r3, [r3]
	cbz	r3, .L241
	ldr	r2, .L243+4
	movs	r5, #6
	movw	r6, #65535
	ldrh	r2, [r2]
	rsb	r2, r2, r2, lsl #3
	asrs	r2, r2, #3
	cmp	r0, r2
	it	gt
	uxthgt	r0, r2
	ldr	r2, .L243+8
	ldr	r1, [r2]
	ldr	r2, .L243+12
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r2, r3
	movs	r2, #0
	uxth	r3, r3
.L238:
	uxth	r4, r2
	cmp	r0, r4
	bls	.L240
	mul	r4, r5, r3
	adds	r2, r2, #1
	ldrh	r4, [r1, r4]
	cmp	r4, r6
	bne	.L242
.L240:
	ldr	r2, .L243+16
	ldr	r2, [r2]
	ldrh	r0, [r2, r3, lsl #1]
	pop	{r4, r5, r6, pc}
.L242:
	mov	r3, r4
	b	.L238
.L241:
	mov	r0, r3
	pop	{r4, r5, r6, pc}
.L244:
	.align	2
.L243:
	.word	.LANCHOR47
	.word	.LANCHOR48
	.word	.LANCHOR40
	.word	-1431655765
	.word	.LANCHOR43
	.size	GetFreeBlockMaxEraseCount, .-GetFreeBlockMaxEraseCount
	.section	.text.FtlPrintInfo2buf,"ax",%progbits
	.align	1
	.global	FtlPrintInfo2buf
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlPrintInfo2buf, %function
FtlPrintInfo2buf:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r1, #64
	ldr	r2, .L257
	mov	r8, r0
	bl	snprintf
	ldr	r3, .L257+4
	add	r5, r8, r0
	ldr	r2, .L257+8
	movs	r1, #64
	mov	r0, r5
	ldr	r6, .L257+12
	ldr	r3, [r3]
	bl	snprintf
	add	r5, r5, r0
	ldr	r2, .L257+16
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	ldr	r3, .L257+20
	add	r5, r5, r0
	ldr	r2, .L257+24
	movs	r1, #64
	mov	r0, r5
	ldr	r4, .L257+28
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+32
	add	r5, r5, r0
	ldr	r2, .L257+36
	movs	r1, #64
	mov	r0, r5
	ldr	r7, .L257+40
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+44
	add	r5, r5, r0
	ldr	r2, .L257+48
	movs	r1, #64
	mov	r0, r5
	ldr	r10, .L257+328
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+52
	add	r5, r5, r0
	ldr	r2, .L257+56
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+60
	add	r5, r5, r0
	ldr	r2, .L257+64
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+68
	add	r5, r5, r0
	ldr	r2, .L257+72
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+76
	add	r5, r5, r0
	ldr	r2, .L257+80
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+84
	add	r5, r5, r0
	ldr	r2, .L257+88
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+92
	add	r5, r5, r0
	ldr	r2, .L257+96
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	lsrs	r3, r3, #11
	bl	snprintf
	ldr	r3, .L257+100
	add	r5, r5, r0
	ldr	r2, .L257+104
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	lsrs	r3, r3, #11
	bl	snprintf
	ldr	r3, .L257+108
	add	r5, r5, r0
	ldr	r2, .L257+112
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+116
	add	r5, r5, r0
	ldr	r2, .L257+120
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r6, #6]
	ldr	r2, .L257+124
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r4]
	ldr	r2, .L257+128
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	ldr	r3, .L257+132
	add	r5, r5, r0
	ldr	r2, .L257+136
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+140
	add	r5, r5, r0
	ldr	r2, .L257+144
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+148
	add	r5, r5, r0
	ldr	r2, .L257+152
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+156
	add	r5, r5, r0
	ldr	r2, .L257+160
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+164
	add	r5, r5, r0
	ldr	r2, .L257+168
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+172
	add	r5, r5, r0
	ldr	r2, .L257+176
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r7, #30]
	ldr	r2, .L257+180
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r7, #28]
	ldr	r2, .L257+184
	movs	r1, #64
	mov	r0, r5
	ldr	r7, .L257+188
	bl	snprintf
	ldr	r3, .L257+192
	add	r5, r5, r0
	ldr	r2, .L257+196
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+200
	add	r5, r5, r0
	ldr	r2, .L257+204
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+208
	add	r5, r5, r0
	ldr	r2, .L257+212
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+216
	add	r5, r5, r0
	ldr	r2, .L257+220
	movs	r1, #64
	mov	r0, r5
	ldrh	r3, [r3, #6]
	bl	snprintf
	ldr	r3, .L257+224
	add	r5, r5, r0
	ldr	r2, .L257+228
	movs	r1, #64
	mov	r0, r5
	ldrh	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+232
	add	r5, r5, r0
	ldr	r2, .L257+236
	movs	r1, #64
	mov	r0, r5
	ldrh	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+240
	add	r5, r5, r0
	ldr	r2, .L257+244
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L257+248
	add	r5, r5, r0
	ldr	r2, .L257+252
	movs	r1, #64
	mov	r0, r5
	ldrh	r3, [r3]
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r6]
	ldr	r2, .L257+256
	movs	r1, #64
	mov	r0, r5
	ldr	r6, .L257+260
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r7, #2]
	ldr	r2, .L257+264
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrb	r3, [r7, #6]	@ zero_extendqisi2
	ldr	r2, .L257+268
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r7]
	ldr	r2, .L257+272
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrb	r3, [r7, #8]	@ zero_extendqisi2
	ldr	r2, .L257+276
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r7, #4]
	ldr	r2, .L257+280
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	ldrh	r2, [r7]
	add	r5, r5, r0
	ldr	r3, [r6]
	movs	r1, #64
	ldr	r7, .L257+284
	mov	r0, r5
	ldrh	r3, [r3, r2, lsl #1]
	ldr	r2, .L257+288
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r7, #2]
	ldr	r2, .L257+292
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrb	r3, [r7, #6]	@ zero_extendqisi2
	ldr	r2, .L257+296
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r7]
	ldr	r2, .L257+300
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrb	r3, [r7, #8]	@ zero_extendqisi2
	ldr	r2, .L257+304
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r7, #4]
	ldr	r2, .L257+308
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	ldrh	r2, [r7]
	add	r5, r5, r0
	ldr	r3, [r6]
	movs	r1, #64
	ldr	r7, .L257+312
	mov	r0, r5
	ldrh	r3, [r3, r2, lsl #1]
	ldr	r2, .L257+316
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r7, #2]
	ldr	r2, .L257+320
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrb	r3, [r7, #6]	@ zero_extendqisi2
	ldr	r2, .L257+324
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	b	.L258
.L259:
	.align	2
.L257:
	.word	.LC2
	.word	.LANCHOR26
	.word	.LC3
	.word	.LANCHOR37
	.word	.LC4
	.word	.LANCHOR61
	.word	.LC5
	.word	.LANCHOR48
	.word	.LANCHOR59
	.word	.LC6
	.word	.LANCHOR39
	.word	.LANCHOR62
	.word	.LC7
	.word	.LANCHOR63
	.word	.LC8
	.word	.LANCHOR64
	.word	.LC9
	.word	.LANCHOR65
	.word	.LC10
	.word	.LANCHOR66
	.word	.LC11
	.word	.LANCHOR67
	.word	.LC12
	.word	.LANCHOR68
	.word	.LC13
	.word	.LANCHOR69
	.word	.LC14
	.word	.LANCHOR70
	.word	.LC15
	.word	.LANCHOR71
	.word	.LC16
	.word	.LC17
	.word	.LC18
	.word	.LANCHOR72
	.word	.LC19
	.word	.LANCHOR73
	.word	.LC20
	.word	.LANCHOR74
	.word	.LC21
	.word	.LANCHOR75
	.word	.LC22
	.word	.LANCHOR76
	.word	.LC23
	.word	.LANCHOR77
	.word	.LC24
	.word	.LC25
	.word	.LC26
	.word	.LANCHOR51
	.word	.LANCHOR34
	.word	.LC27
	.word	.LANCHOR31
	.word	.LC28
	.word	.LANCHOR2
	.word	.LC29
	.word	.LANCHOR38
	.word	.LC30
	.word	.LANCHOR5
	.word	.LC31
	.word	.LANCHOR78
	.word	.LC32
	.word	.LANCHOR7
	.word	.LC33
	.word	.LANCHOR79
	.word	.LC34
	.word	.LC35
	.word	.LANCHOR42
	.word	.LC36
	.word	.LC37
	.word	.LC38
	.word	.LC39
	.word	.LC40
	.word	.LANCHOR52
	.word	.LC41
	.word	.LC42
	.word	.LC43
	.word	.LC44
	.word	.LC45
	.word	.LC46
	.word	.LANCHOR53
	.word	.LC47
	.word	.LC48
	.word	.LC49
	.word	.LANCHOR81
.L258:
	ldrh	r3, [r7]
	ldr	r2, .L260
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrb	r3, [r7, #8]	@ zero_extendqisi2
	ldr	r2, .L260+4
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	ldrh	r3, [r7, #4]
	add	r5, r5, r0
	ldr	r7, .L260+8
	movs	r1, #64
	ldr	r2, .L260+12
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r7, #2]
	ldr	r2, .L260+16
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrb	r3, [r7, #6]	@ zero_extendqisi2
	ldr	r2, .L260+20
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r7]
	ldr	r2, .L260+24
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrb	r3, [r7, #8]	@ zero_extendqisi2
	ldr	r2, .L260+28
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrh	r3, [r7, #4]
	ldr	r2, .L260+32
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	ldr	r3, [r10, #76]
	add	r5, r5, r0
	ldr	r2, .L260+36
	movs	r1, #64
	mov	r0, r5
	str	r3, [sp, #4]
	ldr	r3, [r10, #84]
	str	r3, [sp]
	ldr	r3, [r10, #80]
	bl	snprintf
	add	r5, r5, r0
	ldr	r3, [r10, #72]
	ldr	r2, .L260+40
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldr	r3, [r10, #96]
	ldr	r2, .L260+44
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	ldr	r3, .L260+48
	add	r5, r5, r0
	ldr	r2, .L260+52
	movs	r1, #64
	mov	r0, r5
	ldrh	r3, [r3]
	bl	snprintf
	ldr	r3, .L260+56
	add	r5, r5, r0
	ldr	r2, .L260+60
	movs	r1, #64
	mov	r0, r5
	ldrh	r3, [r3]
	bl	snprintf
	ldr	r3, .L260+64
	add	r5, r5, r0
	ldr	r2, .L260+68
	movs	r1, #64
	mov	r0, r5
	ldr	r3, [r3]
	bl	snprintf
	ldr	r3, .L260+72
	add	r5, r5, r0
	ldr	r2, .L260+76
	movs	r1, #64
	mov	r0, r5
	ldrh	r3, [r3]
	bl	snprintf
	add	r5, r5, r0
	bl	GetFreeBlockMinEraseCount
	ldr	r2, .L260+80
	mov	r3, r0
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	add	r5, r5, r0
	ldrh	r0, [r4]
	bl	GetFreeBlockMaxEraseCount
	ldr	r2, .L260+84
	mov	r3, r0
	movs	r1, #64
	mov	r0, r5
	bl	snprintf
	ldr	r3, .L260+88
	adds	r4, r5, r0
	ldr	r3, [r3]
	cmp	r3, #1
	beq	.L246
.L251:
	sub	r0, r4, r8
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L246:
	ldrh	r3, [r7]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L248
	ldr	r2, [r6]
	mov	r0, r4
	movs	r1, #64
	ldrh	r3, [r2, r3, lsl #1]
	ldr	r2, .L260+92
	bl	snprintf
	add	r4, r4, r0
.L248:
	movs	r0, #0
	ldr	r5, .L260+96
	ldr	fp, .L260+112
	movs	r7, #0
	bl	List_get_gc_head_node
	uxth	r0, r0
.L250:
	movw	r3, #65535
	cmp	r0, r3
	beq	.L249
	ldr	r3, [fp]
	mov	r10, #6
	mul	r10, r10, r0
	ldr	r2, .L260+100
	movs	r1, #64
	ldrh	r3, [r3, r0, lsl #1]
	str	r3, [sp, #12]
	ldr	r3, [r5]
	add	r3, r3, r10
	ldrh	r3, [r3, #4]
	str	r3, [sp, #8]
	ldr	r3, [r6]
	ldrh	r3, [r3, r0, lsl #1]
	stm	sp, {r0, r3}
	mov	r3, r7
	mov	r0, r4
	adds	r7, r7, #1
	bl	snprintf
	ldr	r3, [r5]
	cmp	r7, #16
	add	r4, r4, r0
	ldrh	r0, [r3, r10]
	bne	.L250
.L249:
	ldr	r3, .L260+104
	movs	r7, #0
	ldr	r2, [r5]
	ldr	r10, .L260+112
	ldr	r3, [r3]
	ldr	fp, .L260+116
	subs	r3, r3, r2
	ldr	r2, .L260+108
	asrs	r3, r3, #1
	muls	r3, r2, r3
	uxth	r3, r3
.L252:
	movw	r2, #65535
	cmp	r3, r2
	beq	.L251
	ldr	r2, [r10]
	movs	r6, #6
	muls	r6, r3, r6
	mov	r0, r4
	movs	r1, #64
	ldrh	r2, [r2, r3, lsl #1]
	str	r2, [sp, #8]
	ldr	r2, [r5]
	add	r2, r2, r6
	ldrh	r2, [r2, #4]
	str	r3, [sp]
	mov	r3, r7
	adds	r7, r7, #1
	str	r2, [sp, #4]
	mov	r2, fp
	bl	snprintf
	cmp	r7, #4
	add	r4, r4, r0
	beq	.L251
	ldr	r3, [r5]
	ldrh	r3, [r3, r6]
	b	.L252
.L261:
	.align	2
.L260:
	.word	.LC50
	.word	.LC51
	.word	.LANCHOR80
	.word	.LC52
	.word	.LC53
	.word	.LC54
	.word	.LC55
	.word	.LC56
	.word	.LC57
	.word	.LC58
	.word	.LC59
	.word	.LC60
	.word	.LANCHOR82
	.word	.LC61
	.word	.LANCHOR83
	.word	.LC62
	.word	.LANCHOR84
	.word	.LC63
	.word	.LANCHOR85
	.word	.LC64
	.word	.LC65
	.word	.LC66
	.word	.LANCHOR86
	.word	.LC67
	.word	.LANCHOR40
	.word	.LC68
	.word	.LANCHOR47
	.word	-1431655765
	.word	.LANCHOR43
	.word	.LC69
	.size	FtlPrintInfo2buf, .-FtlPrintInfo2buf
	.section	.text.rknand_proc_ftlread,"ax",%progbits
	.align	1
	.global	rknand_proc_ftlread
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	rknand_proc_ftlread, %function
rknand_proc_ftlread:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r0, #2048
	push	{r3, r4, r5, lr}
	mov	r5, r1
	blt	.L264
	ldr	r3, .L265
	movs	r1, #64
	ldr	r2, .L265+4
	mov	r0, r5
	bl	snprintf
	adds	r4, r5, r0
	mov	r0, r4
	bl	FtlPrintInfo2buf
	add	r0, r0, r4
	subs	r0, r0, r5
	pop	{r3, r4, r5, pc}
.L264:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L266:
	.align	2
.L265:
	.word	.LC70
	.word	.LC71
	.size	rknand_proc_ftlread, .-rknand_proc_ftlread
	.section	.text.GetSwlReplaceBlock,"ax",%progbits
	.align	1
	.global	GetSwlReplaceBlock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	GetSwlReplaceBlock, %function
GetSwlReplaceBlock:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r3, .L295
	ldr	r6, .L295+4
	ldr	r5, [r3]
	mov	r10, r3
	ldr	r1, [r6]
	cmp	r1, r5
	bcs	.L268
	ldr	r2, .L295+8
	movs	r3, #0
	ldr	r4, .L295+12
	mov	r0, r3
	ldrh	r1, [r2]
	ldr	r2, .L295+16
	str	r3, [r4]
	ldr	r7, [r2]
	mov	r2, r3
.L269:
	cmp	r2, r1
	bcc	.L270
	cbz	r3, .L271
	str	r0, [r4]
.L271:
	ldr	r7, [r4]
	mov	r0, r7
	bl	__aeabi_uidiv
	ldr	r3, .L295+20
	str	r0, [r6]
	ldr	r0, [r3]
	ldr	r3, .L295+24
	subs	r0, r7, r0
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	str	r0, [r4]
.L272:
	ldr	r6, [r6]
	add	r3, r5, #256
	cmp	r3, r6
	bls	.L277
	ldr	r2, .L295+28
	add	r3, r5, #768
	ldr	r2, [r2]
	cmp	r3, r2
	bls	.L277
.L279:
	movw	r4, #65535
.L278:
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L270:
	ldrh	r3, [r7, r2, lsl #1]
	adds	r2, r2, #1
	add	r0, r0, r3
	movs	r3, #1
	b	.L269
.L268:
	ldr	r2, .L295+28
	ldr	r3, [r2]
	cmp	r1, r3
	bls	.L272
	adds	r3, r3, #1
	ldr	r0, .L295+8
	str	r3, [r2]
	movs	r2, #0
	ldr	r3, .L295+16
	ldr	r3, [r3]
	subs	r3, r3, #2
.L274:
	ldrh	r1, [r0]
	cmp	r2, r1
	bcs	.L272
	ldrh	r1, [r3, #2]
	adds	r2, r2, #1
	adds	r1, r1, #1
	strh	r1, [r3, #2]!	@ movhi
	b	.L274
.L277:
	ldr	r3, .L295+32
	ldrh	r0, [r3]
	add	r0, r0, r0, lsl #1
	ubfx	r0, r0, #2, #16
	bl	GetFreeBlockMaxEraseCount
	add	r3, r5, #64
	mov	r2, r0
	cmp	r0, r3
	bcc	.L279
	ldr	r3, .L295+36
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L279
	ldr	r1, .L295+8
	movs	r0, #0
	mov	fp, #6
	ldrh	r1, [r1]
	str	r1, [sp, #20]
	ldr	r1, .L295+40
	ldr	r8, [r1]
	ldr	r1, .L295+16
	ldr	r7, [r1]
	movw	r1, #65535
	mov	ip, r1
.L280:
	ldrh	lr, [r3]
	movw	r4, #65535
	cmp	lr, r4
	bne	.L283
	mov	r4, ip
.L282:
	movw	r3, #65535
	cmp	r4, r3
	beq	.L279
	ldrh	r7, [r7, r4, lsl #1]
	lsl	r8, r4, #1
	cmp	r5, r7
	bcs	.L284
	bl	GetFreeBlockMinEraseCount
	cmp	r5, r0
	it	cc
	strcc	r1, [r10]
.L284:
	cmp	r6, r7
	bls	.L279
	add	r3, r7, #128
	cmp	r2, r3
	ble	.L279
	add	r3, r7, #256
	ldr	r0, .L295+28
	cmp	r6, r3
	bhi	.L285
	ldr	r1, [r0]
	add	r3, r7, #768
	cmp	r3, r1
	bcs	.L279
.L285:
	ldr	r3, .L295+44
	mov	r1, r4
	str	r2, [sp, #8]
	mov	r2, r6
	str	r7, [sp, #4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r8]
	str	r3, [sp]
	ldr	r3, [r0]
	ldr	r0, .L295+48
	bl	printf
	ldr	r3, .L295+52
	movs	r2, #1
	str	r2, [r3]
	b	.L278
.L283:
	adds	r0, r0, #1
	ldr	r4, [sp, #20]
	uxth	r0, r0
	cmp	r0, r4
	bhi	.L279
	ldrh	r4, [r3, #4]
	cbz	r4, .L281
	ldr	r4, .L295+56
	sub	r3, r3, r8
	asrs	r3, r3, #1
	muls	r3, r4, r3
	uxth	r4, r3
	ldrh	r3, [r7, r4, lsl #1]
	cmp	r5, r3
	bcs	.L282
	cmp	r1, r3
	itt	hi
	movhi	r1, r3
	movhi	ip, r4
.L281:
	mla	r3, fp, lr, r8
	b	.L280
.L296:
	.align	2
.L295:
	.word	.LANCHOR77
	.word	.LANCHOR74
	.word	.LANCHOR5
	.word	.LANCHOR72
	.word	.LANCHOR43
	.word	.LANCHOR73
	.word	.LANCHOR14
	.word	.LANCHOR76
	.word	.LANCHOR48
	.word	.LANCHOR41
	.word	.LANCHOR40
	.word	.LANCHOR42
	.word	.LC72
	.word	.LANCHOR87
	.word	-1431655765
	.size	GetSwlReplaceBlock, .-GetSwlReplaceBlock
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
	beq	.L298
	ldr	r2, .L299
	movs	r1, #0
	ldr	r2, [r2]
	strh	r1, [r2, r0, lsl #1]	@ movhi
	bl	INSERT_FREE_LIST
.L298:
	movs	r0, #0
	pop	{r3, pc}
.L300:
	.align	2
.L299:
	.word	.LANCHOR42
	.size	free_data_superblock, .-free_data_superblock
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
	push	{r3, r4, r5, r6, r7, lr}
	movw	r3, #65535
	mov	r4, r0
	cmp	r2, r3
	bne	.L302
	movw	r2, #2740
	ldr	r1, .L315
	ldr	r0, .L315+4
	bl	printf
.L302:
	ldr	r5, .L315+8
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L303
	movw	r2, #2741
	ldr	r1, .L315
	ldr	r0, .L315+4
	bl	printf
.L303:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L304
	movw	r2, #2742
	ldr	r1, .L315
	ldr	r0, .L315+4
	bl	printf
.L304:
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	movs	r3, #0
	strb	r3, [r4, #10]
	movw	r6, #65535
	adds	r2, r2, #8
	ldrh	r0, [r4, r2, lsl #1]
	ldr	r2, .L315+12
	ldrh	r1, [r2]
	mov	r2, r3
.L305:
	cmp	r0, r6
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	beq	.L307
	ldrh	r2, [r4, #4]
	ldrh	r6, [r4, #2]
	subs	r2, r2, #1
	uxth	r2, r2
	orr	r6, r6, r0, lsl #10
	movw	r0, #65535
	strh	r2, [r4, #4]	@ movhi
.L309:
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r1, r3
	itttt	eq
	ldrheq	r3, [r4, #2]
	addeq	r3, r3, #1
	strheq	r3, [r4, #2]	@ movhi
	moveq	r3, #0
	add	r7, r3, #8
	ldrh	r7, [r4, r7, lsl #1]
	cmp	r7, r0
	beq	.L309
	strb	r3, [r4, #6]
	ldrh	r1, [r4, #2]
	ldrh	r3, [r5]
	cmp	r1, r3
	bne	.L301
	cbz	r2, .L301
	movw	r2, #2763
	ldr	r1, .L315
	ldr	r0, .L315+4
	bl	printf
.L301:
	mov	r0, r6
	pop	{r3, r4, r5, r6, r7, pc}
.L307:
	adds	r3, r3, #1
	uxtb	r3, r3
	cmp	r3, r1
	strb	r3, [r4, #6]
	itttt	eq
	ldrheq	r3, [r4, #2]
	strbeq	r2, [r4, #6]
	addeq	r3, r3, #1
	strheq	r3, [r4, #2]	@ movhi
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	adds	r3, r3, #8
	ldrh	r0, [r4, r3, lsl #1]
	b	.L305
.L316:
	.align	2
.L315:
	.word	.LANCHOR88
	.word	.LC1
	.word	.LANCHOR19
	.word	.LANCHOR3
	.size	get_new_active_ppa, .-get_new_active_ppa
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
	ldr	r1, .L322
	mov	fp, #1
	ldr	r2, .L322+4
	ldr	r5, [r1]
	ldr	r1, .L322+8
	str	r3, [r2]
	ldr	r2, .L322+12
	mov	r0, r5
	ldr	r1, [r1]
	ldrh	r2, [r2]
	str	r1, [sp, #4]
	ldr	r1, .L322+16
	ldrh	r1, [r1]
	str	r1, [sp]
	ldr	r1, .L322+20
	ldr	r10, [r1]
	ldr	r1, .L322+24
	ldrh	r7, [r1]
	ldr	r1, .L322+28
	ldr	r4, [r1]
	movs	r1, #12
	mla	r1, r2, r1, r1
	adds	r4, r4, #8
	add	r8, r5, r1
	mov	r1, r3
.L318:
	adds	r0, r0, #12
	ldr	r6, [sp]
	cmp	r0, r8
	add	ip, r3, r7
	add	r4, r4, #20
	add	lr, r1, r6
	bne	.L319
	ldr	r3, .L322+32
	mov	lr, #12
	mov	r8, #0
	ldr	r0, [r3]
	ldr	r3, .L322+8
	ldr	r4, [r3]
	ldr	r3, .L322+20
	ldr	ip, [r3]
.L320:
	cmp	r2, r0
	bcc	.L321
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L319:
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
	str	r3, [r4, #-16]
	mov	r3, ip
	str	r6, [r4, #-20]
	b	.L318
.L321:
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
	b	.L320
.L323:
	.align	2
.L322:
	.word	.LANCHOR90
	.word	.LANCHOR89
	.word	.LANCHOR91
	.word	.LANCHOR3
	.word	.LANCHOR23
	.word	.LANCHOR92
	.word	.LANCHOR24
	.word	.LANCHOR93
	.word	.LANCHOR94
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
	ldr	r3, .L331
	mov	ip, #12
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	mov	fp, #20
	mov	lr, r4
	ldr	r7, [r3]
	ldr	r3, .L331+4
	ldr	r5, [r3]
.L325:
	uxth	r3, r4
	cmp	r1, r3
	bls	.L324
	mla	r8, fp, r3, r0
	movs	r2, #0
.L326:
	uxth	r3, r2
	cmp	r7, r3
	bls	.L327
	mul	r3, ip, r3
	ldr	r6, [r8, #8]
	adds	r2, r2, #1
	add	r10, r5, r3
	ldr	r3, [r5, r3]
	cmp	r3, r6
	bne	.L326
	str	lr, [r10, #8]
.L327:
	adds	r4, r4, #1
	b	.L325
.L324:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L332:
	.align	2
.L331:
	.word	.LANCHOR94
	.word	.LANCHOR90
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
	ldr	r3, .L340
	movs	r2, #0
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	ip, #12
	movs	r7, #1
	mov	lr, #20
	ldr	r4, [r3]
	ldr	r3, .L340+4
	ldr	r5, [r3]
.L334:
	uxth	r8, r2
	cmp	r1, r8
	bhi	.L338
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L338:
	mov	r10, #0
.L335:
	uxth	r3, r10
	cmp	r4, r3
	bls	.L336
	mla	r3, ip, r3, r5
	add	r10, r10, #1
	ldr	r6, [r3, #8]
	cmp	r6, #0
	bne	.L335
	mla	r8, lr, r8, r0
	str	r7, [r3, #8]
	ldr	r6, [r3]
	ldr	r3, [r3, #4]
	str	r6, [r8, #8]
	str	r3, [r8, #12]
.L336:
	adds	r2, r2, #1
	b	.L334
.L341:
	.align	2
.L340:
	.word	.LANCHOR94
	.word	.LANCHOR90
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
	ldr	r3, .L347
	ldr	r2, .L347+4
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L343:
	cmp	r3, r2
	bne	.L345
	movs	r0, #0
	bx	lr
.L345:
	ldrh	r1, [r3], #2
	cmp	r1, r0
	bne	.L343
	movs	r0, #1
	bx	lr
.L348:
	.align	2
.L347:
	.word	.LANCHOR95
	.word	.LANCHOR96
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
	ldr	r4, .L353
	ubfx	r0, r0, #10, #16
	mov	r6, r1
	mov	r7, r2
	bl	P2V_block_in_plane
	ldr	r3, .L353+4
	ldrh	r1, [r4]
	ldr	r2, [r3]
	movs	r3, #0
.L350:
	uxth	ip, r3
	cmp	ip, r1
	bcc	.L352
	bne	.L351
	strh	r0, [r2, ip, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L351
.L352:
	adds	r3, r3, #1
	add	ip, r2, r3, lsl #1
	ldrh	ip, [ip, #-2]
	cmp	ip, r0
	bne	.L350
.L351:
	ldr	r2, .L353+8
	movs	r0, #12
	ldr	r1, .L353+12
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
.L354:
	.align	2
.L353:
	.word	.LANCHOR96
	.word	.LANCHOR95
	.word	.LANCHOR97
	.word	.LANCHOR98
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
	push	{r3, r4, r5, lr}
	mov	r1, r0
	mov	r4, r0
	ldr	r0, .L358
	bl	printf
	ldr	r0, .L358+4
	ldrh	r5, [r0]
	cmp	r4, r5
	beq	.L356
	ldr	r3, .L358+8
	ldrh	r1, [r3]
	cmp	r4, r1
	beq	.L356
	movw	r2, #65535
	cmp	r5, r2
	bne	.L357
	strh	r4, [r0]	@ movhi
.L356:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L357:
	cmp	r1, r2
	it	eq
	strheq	r4, [r3]	@ movhi
	b	.L356
.L359:
	.align	2
.L358:
	.word	.LC73
	.word	.LANCHOR99
	.word	.LANCHOR100
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
	push	{r4, r5, r6, lr}
	mov	r5, r0
	ldr	r4, .L364
	bl	P2V_block_in_plane
	mov	r2, r5
	mov	r6, r0
	ldrh	r1, [r4]
	ldr	r0, .L364+4
	bl	printf
	mov	r0, r6
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4]
	movs	r2, #0
	ldr	r0, .L364+8
.L361:
	uxth	r1, r2
	cmp	r3, r1
	bhi	.L363
	cmp	r3, #15
	itttt	ls
	addls	r2, r3, #1
	strhls	r2, [r4]	@ movhi
	ldrls	r2, .L364+8
	strhls	r5, [r2, r3, lsl #1]	@ movhi
	b	.L362
.L363:
	adds	r2, r2, #1
	add	r1, r0, r2, lsl #1
	ldrh	r1, [r1, #-2]
	cmp	r1, r5
	bne	.L361
.L362:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L365:
	.align	2
.L364:
	.word	.LANCHOR101
	.word	.LC74
	.word	.LANCHOR102
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
	ldr	r3, .L372
	push	{r4, lr}
	ldrh	r3, [r3]
	cbz	r3, .L367
	ldr	r2, .L372+4
	ldrh	r1, [r2]
	movw	r2, #65535
	cmp	r1, r2
	bne	.L367
	ldr	r4, .L372+8
	ldrh	r2, [r4]
	cmp	r2, r3
	itt	cs
	movcs	r3, #0
	strhcs	r3, [r4]	@ movhi
	ldr	r3, .L372+12
	ldrh	r2, [r4]
	ldrh	r0, [r3, r2, lsl #1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
.L367:
	movs	r0, #0
	pop	{r4, pc}
.L373:
	.align	2
.L372:
	.word	.LANCHOR101
	.word	.LANCHOR99
	.word	.LANCHOR103
	.word	.LANCHOR102
	.size	FtlGcReFreshBadBlk, .-FtlGcReFreshBadBlk
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
	movs	r6, #0
	mov	fp, r0
	mov	r7, r1
	mov	r8, r2
	mov	r10, r3
	mov	r5, r6
	mov	r4, r6
.L377:
	cmp	r4, r10
	bcc	.L383
	ldr	r0, .L386
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L383:
	cbnz	r5, .L378
	mov	r2, r6
	mov	r1, fp
	ldr	r0, .L386+4
	bl	printf
.L378:
	cmp	r8, #4
	bne	.L379
	ldr	r1, [r7, r4, lsl #2]
.L385:
	ldr	r0, .L386+8
.L384:
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L382
	movs	r5, #0
	ldr	r0, .L386
	bl	printf
.L382:
	adds	r4, r4, #1
	add	r6, r6, r8
	b	.L377
.L379:
	cmp	r8, #2
	bne	.L381
	ldrh	r1, [r7, r4, lsl #1]
	b	.L385
.L381:
	ldrb	r1, [r7, r4]	@ zero_extendqisi2
	ldr	r0, .L386+12
	b	.L384
.L387:
	.align	2
.L386:
	.word	.LC78
	.word	.LC75
	.word	.LC76
	.word	.LC77
	.size	rknand_print_hex, .-rknand_print_hex
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
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r6, .L404
	add	r8, r0, #4
	movs	r7, #0
	ldr	fp, .L404+20
	ldrh	r10, [r6, #12]
	str	r2, [sp]
	lsl	r3, r10, #3
	str	r3, [sp, #4]
.L389:
	ldr	r3, [sp]
	cmp	r7, r3
	beq	.L403
	add	r2, sp, #8
	add	r1, sp, #12
	ldr	r0, [r8]
	bl	l2p_addr_tran.isra.0
	ldr	r5, [sp, #8]
	cbnz	r5, .L390
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #4]
	cmp	r3, r2
	bls	.L390
	ldr	r6, .L404+4
	ldr	r7, .L404+8
.L391:
	ldr	r3, [sp]
	adds	r4, r4, #20
	cmp	r5, r3
	bne	.L392
.L403:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L392:
	mov	r3, #-1
	ldr	r2, [sp, #12]
	str	r3, [r4, #-20]
	mov	r1, r6
	mov	r0, r7
	adds	r5, r5, #1
	bl	printf
	movs	r3, #16
	movs	r2, #4
	ldr	r1, [r4, #-12]
	ldr	r0, .L404+12
	bl	rknand_print_hex
	movs	r3, #4
	ldr	r1, [r4, #-8]
	mov	r2, r3
	ldr	r0, .L404+16
	bl	rknand_print_hex
	b	.L391
.L390:
	ldr	r2, [fp, #4]
	uxtb	r0, r5
	ldr	r1, [sp, #12]
	blx	r2
	cbnz	r0, .L393
	str	r0, [r8, #-4]
.L394:
	ldrh	r2, [r6, #14]
	cmp	r2, #4
	bne	.L396
	ldr	r1, [sp, #12]
	ldr	r2, [fp, #4]
	ldrb	r0, [sp, #8]	@ zero_extendqisi2
	add	r1, r1, r10
	blx	r2
	cbz	r0, .L396
	mov	r2, #-1
	str	r2, [r8, #-4]
.L396:
	adds	r7, r7, #1
	add	r8, r8, #20
	b	.L389
.L393:
	mov	r2, #-1
	str	r2, [r8, #-4]
	b	.L394
.L405:
	.align	2
.L404:
	.word	.LANCHOR0
	.word	.LANCHOR104
	.word	.LC79
	.word	.LC80
	.word	.LC81
	.word	.LANCHOR105
	.size	FlashEraseBlocks, .-FlashEraseBlocks
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
	bhi	.L406
	ldr	r4, .L415
	ldrh	r3, [r4, #6]
	cmp	r3, #1024
	beq	.L406
	cbz	r1, .L408
	bl	P2V_block_in_plane
	ldr	r3, .L415+4
	mov	r6, r0
	movs	r2, #1
	mov	r1, r2
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L415+8
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	ldr	r2, .L415+12
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L408:
	ldrh	r3, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #4]
	adds	r2, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	strh	r5, [r4, r2, lsl #1]	@ movhi
	strh	r3, [r4, #4]	@ movhi
.L406:
	pop	{r4, r5, r6, pc}
.L416:
	.align	2
.L415:
	.word	.LANCHOR38
	.word	.LANCHOR106
	.word	.LANCHOR43
	.word	.LANCHOR75
	.size	FtlFreeSysBlkQueueIn, .-FtlFreeSysBlkQueueIn
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
	push	{r3, r4, r5, lr}
	ldr	r4, .L422
	ldrh	r2, [r4, #6]
	cbz	r2, .L421
	ldrh	r3, [r4, #2]
	subs	r2, r2, #1
	strh	r2, [r4, #6]	@ movhi
	movs	r2, #1
	adds	r1, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	ldrh	r5, [r4, r1, lsl #1]
	strh	r3, [r4, #2]	@ movhi
	mov	r1, r2
	ldr	r3, .L422+4
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r2, .L422+8
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L418:
	subs	r3, r5, #1
	movw	r2, #65533
	uxth	r3, r3
	cmp	r3, r2
	bls	.L419
	ldrh	r2, [r4, #6]
	mov	r1, r5
	ldr	r0, .L422+12
	bl	printf
.L420:
	b	.L420
.L421:
	movw	r5, #65535
	b	.L418
.L419:
	mov	r0, r5
	pop	{r3, r4, r5, pc}
.L423:
	.align	2
.L422:
	.word	.LANCHOR38
	.word	.LANCHOR106
	.word	.LANCHOR75
	.word	.LC82
	.size	FtlFreeSysBlkQueueOut, .-FtlFreeSysBlkQueueOut
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
.L425:
	uxth	r5, r3
	cmp	r5, r1
	bcs	.L428
	mov	r7, r2
	adds	r3, r3, #1
	ldrh	r6, [r7]
	adds	r2, r2, #2
	cmp	r6, #0
	bne	.L425
	bl	FtlFreeSysBlkQueueOut
	subs	r3, r0, #1
	movw	r2, #65533
	uxth	r3, r3
	mov	r1, r0
	strh	r0, [r7]	@ movhi
	cmp	r3, r2
	bls	.L426
	ldr	r3, .L432
	ldr	r0, .L432+4
	ldrh	r2, [r3, #6]
	bl	printf
.L427:
	b	.L427
.L426:
	ldr	r3, [r4, #28]
	strh	r6, [r4, #2]	@ movhi
	strh	r5, [r4]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #28]
	ldrh	r3, [r4, #8]
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
.L428:
	ldrh	r3, [r4, #10]
	cmp	r3, r5
	bhi	.L430
	movw	r2, #578
	ldr	r1, .L432+8
	ldr	r0, .L432+12
	bl	printf
.L430:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L433:
	.align	2
.L432:
	.word	.LANCHOR38
	.word	.LC83
	.word	.LANCHOR107
	.word	.LC1
	.size	ftl_map_blk_alloc_new_blk, .-ftl_map_blk_alloc_new_blk
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
	.section	.text.FtlMemInit,"ax",%progbits
	.align	1
	.global	FtlMemInit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlMemInit, %function
FtlMemInit:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L536
	movs	r1, #0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r2, .L536+4
	mov	r10, #12
	str	r1, [r3]
	ldr	r3, .L536+8
	ldr	r4, .L536+12
	ldr	r8, .L536+292
	str	r1, [r3]
	ldr	r3, .L536+16
	ldrh	r0, [r4]
	str	r1, [sp, #12]
	str	r1, [r3]
	ldr	r3, .L536+20
	lsls	r0, r0, #1
	ldr	r6, .L536+24
	ldr	fp, .L536+296
	str	r1, [r3]
	ldr	r3, .L536+28
	ldr	r7, .L536+32
	str	r1, [r3]
	ldr	r3, .L536+36
	str	r1, [r3]
	ldr	r3, .L536+40
	str	r1, [r3]
	ldr	r3, .L536+44
	str	r1, [r3]
	ldr	r3, .L536+48
	str	r1, [r3]
	ldr	r3, .L536+52
	str	r1, [r3]
	ldr	r3, .L536+56
	str	r1, [r3]
	ldr	r3, .L536+60
	str	r1, [r3]
	ldr	r3, .L536+64
	str	r1, [r3]
	ldr	r3, .L536+68
	str	r1, [r3]
	ldr	r3, .L536+72
	str	r1, [r3]
	movw	r3, #65535
	str	r3, [r2]
	ldr	r2, .L536+76
	str	r1, [r2]
	ldr	r2, .L536+80
	str	r1, [r2]
	ldr	r2, .L536+84
	str	r1, [r2]
	ldr	r2, .L536+88
	strh	r3, [r2]	@ movhi
	ldr	r2, .L536+92
	strh	r3, [r2]	@ movhi
	movs	r2, #32
	ldr	r3, .L536+96
	strh	r2, [r3]	@ movhi
	movs	r2, #128
	ldr	r3, .L536+100
	strh	r2, [r3]	@ movhi
	ldr	r3, .L536+104
	strh	r1, [r3]	@ movhi
	ldr	r3, .L536+108
	strh	r1, [r3]	@ movhi
	ldr	r3, .L536+112
	strh	r1, [r3]	@ movhi
	bl	ftl_malloc
	str	r0, [r8]
	ldrh	r0, [r4]
	movs	r4, #20
	mul	r0, r10, r0
	bl	ftl_malloc
	ldr	r3, .L536+116
	str	r0, [r3]
	ldrh	r3, [r6]
	muls	r4, r3, r4
	lsls	r5, r4, #2
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L536+120
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L536+124
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	str	r0, [fp]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L536+128
	ldr	r5, .L536+132
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L536+136
	str	r0, [r3]
	ldrh	r0, [r6]
	ldr	r3, .L536+140
	lsls	r0, r0, #1
	ldrh	r4, [r3]
	adds	r0, r0, #1
	str	r0, [r5]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L536+144
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L536+148
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	str	r0, [r7]
	ldr	r0, [r5]
	muls	r0, r4, r0
	bl	ftl_malloc
	ldr	r3, .L536+152
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L536+156
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L536+160
	str	r0, [r3]
	ldr	r0, [r5]
	mul	r0, r10, r0
	bl	ftl_malloc
	ldr	r3, .L536+164
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L536+168
	str	r0, [r3]
	mov	r0, r4
	ldr	r4, .L536+172
	bl	ftl_malloc
	str	r0, [r4]
	ldr	r0, .L536+176
	ldr	r4, .L536+180
	ldrh	r0, [r0]
	lsls	r0, r0, #2
	bl	ftl_malloc
	str	r0, [r4]
	ldr	r4, .L536+184
	ldrh	r2, [r6]
	ldr	r6, .L536+152
	ldrh	r0, [r4]
	muls	r2, r0, r2
	mov	r0, r2
	str	r2, [sp, #4]
	bl	ftl_malloc
	ldr	r2, [sp, #4]
	ldr	r3, .L536+188
	str	r0, [r3]
	lsls	r0, r2, #2
	bl	ftl_malloc
	ldr	r2, .L536+192
	str	r0, [r2]
	ldrh	r2, [r4]
	ldr	r0, [r5]
	ldr	r4, .L536+196
	ldr	r5, .L536+200
	muls	r0, r2, r0
	bl	ftl_malloc
	ldr	r3, .L536+204
	str	r0, [r3]
	ldrh	r0, [r4]
	lsls	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r5]	@ movhi
	bl	ftl_malloc
	ldr	r2, .L536+208
	str	r0, [r2]
	ldrh	r2, [r5]
	ldr	r0, .L536+212
	addw	r2, r2, #547
	lsrs	r2, r2, #9
	and	r0, r0, r2, lsl #9
	strh	r2, [r5]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L536+216
	str	r0, [r3]
	adds	r0, r0, #32
	ldr	r3, .L536+220
	str	r0, [r3]
	ldrh	r3, [r4]
	lsls	r5, r3, #1
	mov	r0, r5
	bl	ftl_malloc
	ldr	r2, .L536+224
	str	r0, [r2]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L536+228
	str	r0, [r3]
	ldr	r3, .L536+232
	ldr	r2, [r3]
	str	r3, [sp, #8]
	lsls	r5, r2, #1
	mov	r0, r5
	bl	ftl_malloc
	ldr	r2, .L536+236
	str	r0, [r2]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r2, .L536+240
	ldr	r5, .L536+244
	str	r0, [r2]
	ldrh	r0, [r4]
	lsrs	r0, r0, #3
	adds	r0, r0, #4
	bl	ftl_malloc
	ldr	r2, .L536+248
	str	r0, [r2]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r2, .L536+252
	str	r0, [r2]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r2, .L536+256
	str	r0, [r2]
	ldrh	r0, [r5]
	ldr	r5, .L536+116
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r2, .L536+260
	str	r0, [r2]
	ldr	r2, .L536+264
	ldrh	r0, [r2]
	str	r2, [sp, #4]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r2, [sp, #4]
	ldr	ip, .L536+300
	ldr	r1, [sp, #12]
	ldrh	r2, [r2]
	str	r0, [ip]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldr	r2, .L536+268
	ldrh	r0, [r2]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r2, .L536+272
	ldr	r3, [sp, #8]
	str	r0, [r2]
	ldr	r0, [r3]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L536+276
	str	r0, [r3]
	ldr	r3, .L536+280
	ldrh	r0, [r3]
	str	r3, [sp, #4]
	mul	r0, r10, r0
	ldr	r10, .L536+304
	bl	ftl_malloc
	ldr	r2, .L536+284
	ldr	r3, [sp, #4]
	str	r0, [r2]
	ldr	r2, .L536+140
	ldrh	r3, [r3]
	ldrh	r0, [r2]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L536+288
	str	r0, [r3]
	movs	r0, #6
	ldrh	r3, [r4]
	b	.L537
.L538:
	.align	2
.L536:
	.word	.LANCHOR70
	.word	.LANCHOR109
	.word	.LANCHOR71
	.word	.LANCHOR21
	.word	.LANCHOR67
	.word	.LANCHOR64
	.word	.LANCHOR3
	.word	.LANCHOR63
	.word	.LANCHOR117
	.word	.LANCHOR65
	.word	.LANCHOR66
	.word	.LANCHOR62
	.word	.LANCHOR72
	.word	.LANCHOR73
	.word	.LANCHOR75
	.word	.LANCHOR76
	.word	.LANCHOR77
	.word	.LANCHOR108
	.word	.LANCHOR87
	.word	.LANCHOR110
	.word	.LANCHOR84
	.word	.LANCHOR111
	.word	.LANCHOR99
	.word	.LANCHOR100
	.word	.LANCHOR82
	.word	.LANCHOR83
	.word	.LANCHOR85
	.word	.LANCHOR101
	.word	.LANCHOR103
	.word	.LANCHOR98
	.word	.LANCHOR112
	.word	.LANCHOR113
	.word	.LANCHOR106
	.word	.LANCHOR94
	.word	.LANCHOR93
	.word	.LANCHOR23
	.word	.LANCHOR115
	.word	.LANCHOR116
	.word	.LANCHOR91
	.word	.LANCHOR118
	.word	.LANCHOR119
	.word	.LANCHOR90
	.word	.LANCHOR120
	.word	.LANCHOR121
	.word	.LANCHOR12
	.word	.LANCHOR122
	.word	.LANCHOR24
	.word	.LANCHOR123
	.word	.LANCHOR124
	.word	.LANCHOR6
	.word	.LANCHOR125
	.word	.LANCHOR92
	.word	.LANCHOR126
	.word	33553920
	.word	.LANCHOR127
	.word	.LANCHOR43
	.word	.LANCHOR128
	.word	.LANCHOR42
	.word	.LANCHOR30
	.word	.LANCHOR129
	.word	.LANCHOR130
	.word	.LANCHOR27
	.word	.LANCHOR1
	.word	.LANCHOR36
	.word	.LANCHOR131
	.word	.LANCHOR132
	.word	.LANCHOR28
	.word	.LANCHOR32
	.word	.LANCHOR134
	.word	.LANCHOR135
	.word	.LANCHOR33
	.word	.LANCHOR55
	.word	.LANCHOR136
	.word	.LANCHOR95
	.word	.LANCHOR114
	.word	.LANCHOR133
	.word	.LANCHOR10
.L537:
	ldr	r4, .L539
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L539+4
	str	r0, [r3]
	ldr	r3, .L539+8
	ldrh	r0, [r3]
	ldrh	r3, [r10]
	adds	r0, r0, #31
	asrs	r0, r0, #5
	strh	r0, [r4]	@ movhi
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r2, .L539+12
	str	r5, [sp, #8]
	ldr	r5, .L539+16
	mov	r1, r2
	ldrh	r3, [r10]
	str	r0, [r1, #28]!
	ldrh	r0, [r4]
	str	r5, [sp, #12]
	ldr	r5, .L539+20
	ldr	r10, .L539+116
	lsls	r0, r0, #2
	ldr	lr, .L539+120
	ldr	ip, .L539+124
	str	r5, [sp, #16]
	mov	r4, r0
	ldr	r5, .L539+24
	str	r3, [sp, #4]
	movs	r3, #1
	str	r5, [sp, #20]
.L436:
	ldr	r5, [sp, #4]
	cmp	r3, r5
	bcc	.L437
	add	r3, r2, r3, lsl #2
	ldr	r1, .L539+28
	movs	r0, #0
	adds	r3, r3, #24
.L438:
	cmp	r1, r3
	bne	.L439
	ldr	r3, .L539+32
	ldr	r3, [r3]
	cbnz	r3, .L440
.L442:
	ldr	r1, .L539+36
	ldr	r0, .L539+40
	bl	printf
	mov	r0, #-1
.L435:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L437:
	ldr	r5, [r2, #28]
	adds	r3, r3, #1
	add	r5, r5, r4
	add	r4, r4, r0
	str	r5, [r1, #4]!
	b	.L436
.L439:
	str	r0, [r3, #4]!
	b	.L438
.L440:
	ldr	r3, .L539+44
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+48
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+52
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+56
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+60
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+4
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, [r2, #28]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+64
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, [r8]
	cmp	r3, #0
	beq	.L442
	ldr	r3, [sp, #8]
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, [sp, #12]
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, [fp]
	cmp	r3, #0
	beq	.L442
	ldr	r3, [r10]
	cmp	r3, #0
	beq	.L442
	ldr	r3, [sp, #20]
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, [sp, #16]
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, [lr]
	cmp	r3, #0
	beq	.L442
	ldr	r3, [ip]
	cmp	r3, #0
	beq	.L442
	ldr	r3, [r7]
	cmp	r3, #0
	beq	.L442
	ldr	r3, [r6]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+68
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+72
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+76
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+80
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+84
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+88
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+92
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+96
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+100
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+104
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+108
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	ldr	r3, .L539+112
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L442
	movs	r0, #0
	b	.L435
.L540:
	.align	2
.L539:
	.word	.LANCHOR137
	.word	.LANCHOR40
	.word	.LANCHOR17
	.word	.LANCHOR37
	.word	.LANCHOR112
	.word	.LANCHOR113
	.word	.LANCHOR93
	.word	.LANCHOR37+56
	.word	.LANCHOR129
	.word	.LANCHOR138
	.word	.LC84
	.word	.LANCHOR130
	.word	.LANCHOR134
	.word	.LANCHOR135
	.word	.LANCHOR55
	.word	.LANCHOR136
	.word	.LANCHOR42
	.word	.LANCHOR118
	.word	.LANCHOR119
	.word	.LANCHOR90
	.word	.LANCHOR123
	.word	.LANCHOR124
	.word	.LANCHOR92
	.word	.LANCHOR43
	.word	.LANCHOR126
	.word	.LANCHOR36
	.word	.LANCHOR131
	.word	.LANCHOR132
	.word	.LANCHOR133
	.word	.LANCHOR106
	.word	.LANCHOR115
	.word	.LANCHOR116
	.size	FtlMemInit, .-FtlMemInit
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
	ldr	r3, .L547
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, r0
	ldr	r7, .L547+4
	mov	r6, r1
	subs	r4, r5, #2
	addw	r5, r5, #1022
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r8, .L547+12
	mov	r0, r6
	lsls	r2, r2, #2
	bl	ftl_memset
.L544:
	ldrh	r3, [r4, #2]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L541
	ldrh	r2, [r7]
	cmp	r2, r3
	bhi	.L543
	movs	r2, #74
	mov	r1, r8
	ldr	r0, .L547+8
	bl	printf
.L543:
	ldrh	r3, [r4, #2]!
	movs	r2, #1
	cmp	r5, r4
	lsr	r1, r3, #5
	and	r3, r3, #31
	lsl	r3, r2, r3
	ldr	r2, [r6, r1, lsl #2]
	orr	r2, r2, r3
	str	r2, [r6, r1, lsl #2]
	bne	.L544
.L541:
	pop	{r4, r5, r6, r7, r8, pc}
.L548:
	.align	2
.L547:
	.word	.LANCHOR137
	.word	.LANCHOR17
	.word	.LC1
	.word	.LANCHOR139
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
	ldr	r0, .L550
	movw	r3, #65535
	movs	r2, #16
	movs	r1, #255
	strh	r3, [r0]	@ movhi
	movs	r3, #0
	strh	r3, [r0, #6]	@ movhi
	adds	r0, r0, #12
	b	ftl_memset
.L551:
	.align	2
.L550:
	.word	.LANCHOR37
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
	ldr	r3, .L553
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
.L554:
	.align	2
.L553:
	.word	.LANCHOR38
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
.L556:
	ldrh	r1, [r4, #6]
	uxth	r2, r3
	cmp	r1, r2
	bhi	.L560
	ldr	r3, .L575
	movs	r6, #0
	mov	r10, r6
	ldrh	r2, [r3]
	ldrh	r3, [r4]
	strh	r2, [r5, r3, lsl #1]	@ movhi
	mov	r2, r6
	ldrh	fp, [r5]
.L561:
	ldrh	r3, [r4, #10]
	uxth	ip, r6
	cmp	r3, ip
	bhi	.L565
	mov	r0, r10
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L560:
	uxth	r2, r3
	ldr	r1, [r6, r2, lsl #2]
	movs	r2, #0
	ubfx	r1, r1, #10, #16
.L557:
	ldrh	ip, [r4, #10]
	uxth	r0, r2
	cmp	ip, r0
	bhi	.L559
	adds	r3, r3, #1
	b	.L556
.L559:
	uxth	r0, r2
	ldrh	ip, [r7, r0, lsl #1]
	cmp	ip, r1
	bne	.L558
	cbz	r1, .L558
	ldrh	ip, [r5, r0, lsl #1]
	add	ip, ip, #1
	strh	ip, [r5, r0, lsl #1]	@ movhi
.L558:
	adds	r2, r2, #1
	b	.L557
.L565:
	uxth	r1, r6
	ldrh	r3, [r5, r1, lsl #1]
	lsl	r8, r1, #1
	cmp	fp, r3
	bls	.L562
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cbnz	r0, .L563
.L564:
	adds	r6, r6, #1
	b	.L561
.L562:
	cmp	r3, #0
	bne	.L564
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cmp	r0, #0
	beq	.L564
.L566:
	movs	r1, #1
	str	r2, [sp, #4]
	bl	FtlFreeSysBlkQueueIn
	ldr	r2, [sp, #4]
	strh	r2, [r8]	@ movhi
	ldrh	r3, [r4, #8]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	b	.L564
.L563:
	mov	r10, ip
	mov	fp, r3
	cmp	r3, #0
	beq	.L566
	b	.L564
.L576:
	.align	2
.L575:
	.word	.LANCHOR20
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
	ldr	r5, .L580
	ldr	r4, .L580+4
	ldr	r2, [r5]
	ldr	r7, .L580+8
	ldr	r6, .L580+12
	ldr	r0, [r4]
	lsls	r2, r2, #1
	ldr	r8, .L580+44
	bl	ftl_memset
	ldrh	r3, [r7]
	movs	r1, #255
	ldrh	r2, [r6]
	ldr	r0, [r8]
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L580+16
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
.L578:
	adds	r2, r2, #12
	adds	r6, r3, r7
	cmp	r2, r1
	bne	.L579
	ldr	r3, .L580+20
	ldr	r2, [r5]
	strh	r0, [r3, #2]	@ movhi
	strh	r2, [r3, #10]	@ movhi
	movw	r2, #61634
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L580+24
	strh	r0, [r3]	@ movhi
	ldrh	r2, [r2]
	strh	r2, [r3, #8]	@ movhi
	ldr	r2, .L580+28
	ldrh	r2, [r2]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, .L580+32
	ldr	r2, [r2]
	str	r2, [r3, #12]
	ldr	r2, .L580+36
	ldr	r2, [r2]
	str	r2, [r3, #16]
	ldr	r2, [r4]
	str	r2, [r3, #20]
	ldr	r2, .L580+40
	ldr	r2, [r2]
	str	r2, [r3, #24]
	pop	{r4, r5, r6, r7, r8, pc}
.L579:
	bic	r3, r3, #3
	str	lr, [r2, #-8]
	add	r3, r3, ip
	strh	r0, [r2, #-12]	@ movhi
	str	r3, [r2, #-4]
	mov	r3, r6
	b	.L578
.L581:
	.align	2
.L580:
	.word	.LANCHOR30
	.word	.LANCHOR130
	.word	.LANCHOR23
	.word	.LANCHOR33
	.word	.LANCHOR55
	.word	.LANCHOR140
	.word	.LANCHOR141
	.word	.LANCHOR32
	.word	.LANCHOR129
	.word	.LANCHOR135
	.word	.LANCHOR134
	.word	.LANCHOR136
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
	movw	r2, #65535
	ldr	r3, .L583
	movs	r4, #0
	mov	r1, r4
	ldr	r5, .L583+4
	strh	r2, [r3]	@ movhi
	mov	r2, #-1
	ldr	r3, .L583+8
	str	r4, [r3]
	ldr	r3, .L583+12
	str	r4, [r3]
	ldr	r3, .L583+16
	str	r2, [r3]
	ldr	r3, .L583+20
	strh	r4, [r3]	@ movhi
	ldr	r3, .L583+24
	ldrh	r2, [r3]
	ldr	r3, .L583+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L583+32
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L583+36
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	mov	r1, r4
	movs	r2, #48
	ldr	r0, .L583+40
	bl	ftl_memset
	mov	r2, #512
	mov	r1, r4
	ldr	r0, .L583+44
	bl	ftl_memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L584:
	.align	2
.L583:
	.word	.LANCHOR142
	.word	.LANCHOR6
	.word	.LANCHOR143
	.word	.LANCHOR144
	.word	.LANCHOR145
	.word	.LANCHOR35
	.word	.LANCHOR27
	.word	.LANCHOR36
	.word	.LANCHOR43
	.word	.LANCHOR126
	.word	.LANCHOR39
	.word	.LANCHOR81
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
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r2, #6
	ldr	r3, .L596
	movs	r1, #0
	movs	r4, #0
	ldr	r6, .L596+4
	mov	r8, r4
	ldrh	r3, [r3]
	mov	r5, r4
	ldr	r0, [r6]
	mov	r10, r6
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L596+8
	ldr	r2, .L596+12
	str	r4, [r3]
	ldr	r3, .L596+16
	strh	r4, [r2]	@ movhi
	str	r2, [sp, #4]
	str	r4, [r3]
	ldr	r3, .L596+20
	str	r4, [r3]
	ldr	r3, .L596+24
	mov	fp, r3
	strh	r4, [r3]	@ movhi
.L586:
	ldr	r3, .L596+28
	uxth	r7, r4
	ldrh	r3, [r3]
	cmp	r7, r3
	bcs	.L593
	ldr	r3, .L596+32
	ldrh	r2, [r3]
	ldr	r3, .L596+36
	ldrh	r3, [r3]
	str	r3, [sp]
	movs	r3, #0
	mov	r6, r3
	b	.L594
.L588:
	str	r2, [sp, #12]
	mov	r1, r7
	ldr	r2, .L596+40
	str	r3, [sp, #8]
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #12]
	cbnz	r0, .L587
	ldr	r1, [sp]
	add	r6, r6, r1
	uxth	r6, r6
.L587:
	adds	r3, r3, #1
.L594:
	uxth	r1, r3
	cmp	r2, r1
	bhi	.L588
	uxth	r3, r4
	cbz	r6, .L589
	mov	r1, r6
	str	r3, [sp]
	mov	r0, #32768
	bl	__aeabi_idiv
	ldr	r3, [sp]
	uxth	r6, r0
.L590:
	ldr	r1, [r10]
	movs	r2, #6
	mla	r2, r2, r3, r1
	strh	r6, [r2, #4]	@ movhi
	ldr	r2, .L596+44
	ldrh	r2, [r2]
	cmp	r2, r7
	beq	.L591
	ldr	r2, .L596+48
	ldrh	r2, [r2]
	cmp	r2, r7
	beq	.L591
	ldr	r2, .L596+52
	ldrh	r2, [r2]
	cmp	r2, r7
	beq	.L591
	ldr	r2, .L596+56
	ldr	r2, [r2]
	ldrh	r3, [r2, r3, lsl #1]
	cbnz	r3, .L592
	add	r8, r8, #1
	mov	r0, r7
	uxth	r8, r8
	bl	INSERT_FREE_LIST
.L591:
	adds	r4, r4, #1
	b	.L586
.L589:
	ldr	r2, .L596+56
	movw	r1, #65535
	ldr	r2, [r2]
	strh	r1, [r2, r3, lsl #1]	@ movhi
	b	.L590
.L592:
	adds	r5, r5, #1
	mov	r0, r7
	uxth	r5, r5
	bl	INSERT_DATA_LIST
	b	.L591
.L593:
	ldr	r2, [sp, #4]
	strh	r8, [fp]	@ movhi
	strh	r5, [r2]	@ movhi
	add	r5, r5, r8
	cmp	r5, r3
	ble	.L595
	movw	r2, #2170
	ldr	r1, .L596+60
	ldr	r0, .L596+64
	bl	printf
.L595:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L597:
	.align	2
.L596:
	.word	.LANCHOR6
	.word	.LANCHOR40
	.word	.LANCHOR47
	.word	.LANCHOR45
	.word	.LANCHOR41
	.word	.LANCHOR44
	.word	.LANCHOR48
	.word	.LANCHOR5
	.word	.LANCHOR3
	.word	.LANCHOR19
	.word	.LANCHOR13
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR42
	.word	.LANCHOR146
	.word	.LC1
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
	ldr	r2, .L599
	movs	r3, #0
	push	{r4, lr}
	movs	r1, #255
	ldr	r4, .L599+4
	strh	r3, [r2]	@ movhi
	ldr	r2, .L599+8
	strh	r3, [r2]	@ movhi
	ldrh	r2, [r4]
	ldr	r3, .L599+12
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r2, #12
	movs	r1, #255
	muls	r2, r3, r2
	ldr	r3, .L599+16
	ldr	r0, [r3]
	bl	ftl_memset
	pop	{r4, lr}
	b	FtlGcBufInit
.L600:
	.align	2
.L599:
	.word	.LANCHOR96
	.word	.LANCHOR21
	.word	.LANCHOR97
	.word	.LANCHOR95
	.word	.LANCHOR98
	.size	FtlGcPageVarInit, .-FtlGcPageVarInit
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
	push	{r3, r4, r5, lr}
	mov	r2, #256
	mov	r5, r1
	movs	r1, #255
	mov	r4, r0
	bl	ftl_memset
	ldr	r3, .L608
	mov	r1, r5
	mov	r0, r4
	ldr	r3, [r3]
	blx	r3
	uxth	r0, r0
	cmp	r0, #50
	bls	.L602
	mov	r2, #256
	movs	r1, #255
	mov	r0, r4
	bl	ftl_memset
	movs	r0, #0
.L602:
	ldr	r3, .L608+4
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	bne	.L607
	add	r1, r4, r0, lsl #1
	mov	r3, r4
.L604:
	cmp	r3, r1
	bne	.L605
.L607:
	pop	{r3, r4, r5, pc}
.L605:
	ldrh	r2, [r3]
	lsrs	r2, r2, #1
	strh	r2, [r3], #2	@ movhi
	b	.L604
.L609:
	.align	2
.L608:
	.word	.LANCHOR105
	.word	.LANCHOR0
	.size	FlashGetBadBlockList, .-FlashGetBadBlockList
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
	.section	.text.FlashReadPages,"ax",%progbits
	.align	1
	.global	FlashReadPages
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashReadPages, %function
FlashReadPages:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, r1
	ldr	r3, .L638
	mov	r4, r0
	mov	r10, #0
	ldrh	r2, [r3, #12]
	str	r3, [sp, #4]
	str	r2, [sp]
.L612:
	cmp	r10, fp
	bne	.L622
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L622:
	ldr	r3, [r4, #8]
	cbz	r3, .L613
	ldr	r3, [r4, #12]
	cbnz	r3, .L614
.L613:
	movs	r2, #90
	ldr	r1, .L638+4
	ldr	r0, .L638+8
	bl	printf
.L614:
	add	r2, sp, #8
	add	r1, sp, #12
	ldr	r0, [r4, #4]
	bl	l2p_addr_tran.isra.0
	ldr	r5, [r4, #8]
	ldr	r8, .L638+20
	ldr	r7, .L638+12
	tst	r5, #63
	ldr	r3, [r4, #12]
	it	ne
	ldrne	r5, [r8]
	ldr	r1, [sp, #12]
	ldrb	r0, [sp, #8]	@ zero_extendqisi2
	mov	r2, r5
	ldr	r6, [r7, #12]
	blx	r6
	ldr	r3, [sp, #4]
	str	r0, [r4]
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	bne	.L617
	ldr	r0, [sp]
	add	r2, r5, #2048
	ldr	r3, [r4, #12]
	ldr	r1, [sp, #12]
	ldr	r7, [r7, #12]
	adds	r3, r3, #8
	add	r1, r1, r0
	ldrb	r0, [sp, #8]	@ zero_extendqisi2
	blx	r7
	adds	r3, r0, #1
	beq	.L618
	ldr	r3, [r4, #12]
	ldr	r2, [r3, #12]
	adds	r2, r2, #1
	bne	.L619
	ldr	r2, [r3, #8]
	adds	r2, r2, #1
	bne	.L619
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L619
.L618:
	mov	r3, #-1
	str	r3, [r4]
.L619:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L617
	cmp	r0, #256
	it	eq
	streq	r0, [r4]
.L617:
	ldr	r3, [r8]
	cmp	r5, r3
	bne	.L621
	ldr	r0, [r4, #8]
	cmp	r5, r0
	beq	.L621
	ldr	r3, .L638+16
	mov	r1, r5
	ldrh	r2, [r3]
	lsls	r2, r2, #9
	bl	ftl_memcpy
.L621:
	add	r10, r10, #1
	adds	r4, r4, #20
	b	.L612
.L639:
	.align	2
.L638:
	.word	.LANCHOR0
	.word	.LANCHOR147
	.word	.LC1
	.word	.LANCHOR105
	.word	.LANCHOR12
	.word	.LANCHOR120
	.size	FlashReadPages, .-FlashReadPages
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
	ldr	r3, .L650
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r5, .L650+4
	ldr	r3, [r3]
	ldr	r7, .L650+8
	ldr	r10, .L650+20
	str	r3, [r5, #8]
	ldr	r3, .L650+12
	ldr	r8, [r3]
	str	r8, [r5, #12]
.L641:
	ldr	r3, .L650+16
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L646
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L646:
	ldrh	r4, [r10]
	movw	r3, #65535
	ldr	fp, .L650+4
	strh	r3, [r7, #2]!	@ movhi
	subs	r4, r4, #1
	uxth	r4, r4
.L642:
	ldrh	r3, [r10]
	sub	r2, r3, #15
	cmp	r2, r4
	bgt	.L644
	mla	r3, r6, r3, r4
	movs	r2, #1
	mov	r1, r2
	mov	r0, fp
	lsls	r3, r3, #10
	str	r3, [r5, #4]
	bl	FlashReadPages
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L643
	ldrh	r2, [r8]
	movw	r3, #61664
	cmp	r2, r3
	bne	.L643
	strh	r4, [r7]	@ movhi
.L644:
	adds	r6, r6, #1
	b	.L641
.L643:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L642
.L651:
	.align	2
.L650:
	.word	.LANCHOR115
	.word	.LANCHOR148
	.word	.LANCHOR37+10
	.word	.LANCHOR123
	.word	.LANCHOR10
	.word	.LANCHOR17
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
	@ args = 0, pretend = 0, frame = 88
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r1, #1
	push	{r4, r5, r6, r7, r8, lr}
	it	eq
	ldreq	r3, .L664
	sub	sp, sp, #88
	lsl	r7, r0, #10
	mov	r2, r1
	it	ne
	ldrne	r3, .L664+4
	mov	r6, r1
	add	r0, sp, #4
	movs	r1, #1
	ldrh	r5, [r3]
	ldr	r3, .L664+8
	subs	r5, r5, #1
	ldr	r3, [r3]
	sxth	r5, r5
	str	r3, [sp, #12]
	add	r3, sp, #24
	str	r3, [sp, #16]
	orr	r3, r5, r7
	str	r3, [sp, #8]
	bl	FlashReadPages
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	bne	.L655
	mov	r8, #0
.L656:
	cmp	r8, r5
	ble	.L659
.L655:
	mov	r0, r5
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L659:
	add	r3, r8, r5
	mov	r2, r6
	add	r3, r3, r3, lsr #31
	movs	r1, #1
	add	r0, sp, #4
	asrs	r4, r3, #1
	sxth	r3, r4
	orrs	r3, r3, r7
	str	r3, [sp, #8]
	bl	FlashReadPages
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	bne	.L657
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	bne	.L657
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L657
	subs	r4, r4, #1
	sxth	r5, r4
	b	.L656
.L657:
	adds	r4, r4, #1
	sxth	r8, r4
	b	.L656
.L665:
	.align	2
.L664:
	.word	.LANCHOR20
	.word	.LANCHOR19
	.word	.LANCHOR121
	.size	FtlGetLastWrittenPage, .-FtlGetLastWrittenPage
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
	ldr	r5, .L747
	sub	sp, sp, #32
	mov	r1, r4
	ldr	r3, .L747+4
	ldr	r2, [r5]
	ldr	r6, .L747+8
	strh	r4, [r3]	@ movhi
	ldr	r3, .L747+12
	lsls	r2, r2, #2
	strh	r4, [r6]	@ movhi
	ldr	r7, .L747+16
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [r5]
	mov	r1, r4
	ldr	r3, .L747+20
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L747+24
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L747+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	movs	r2, #12
	movs	r1, #255
	ldr	r0, .L747+32
	bl	ftl_memset
	ldr	r3, .L747+36
	str	r6, [sp, #12]
	str	r5, [sp, #16]
	ldrh	r3, [r3]
	str	r3, [sp, #4]
.L667:
	ldr	r3, .L747+40
	ldr	r2, [sp, #4]
	ldrh	r3, [r3]
	cmp	r3, r2
	bls	.L708
	ldr	r3, .L747+44
	movs	r5, #0
	ldr	r1, .L747+48
	mov	fp, r5
	movs	r7, #20
	ldrh	r8, [r3]
	ldr	r3, .L747+52
	ldr	r2, [r1]
	ldr	r1, .L747+56
	ldr	r6, [r3]
	ldr	r3, .L747+60
	str	r2, [sp, #8]
	ldrh	r10, [r1]
	ldr	r3, [r3]
	ldr	r2, .L747+64
	b	.L709
.L669:
	ldrb	r0, [r2, r5]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #28]
	str	r2, [sp, #24]
	bl	V2P_block
	str	r0, [sp, #20]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #28]
	cbnz	r0, .L668
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
.L668:
	adds	r5, r5, #1
.L709:
	uxth	r1, r5
	cmp	r8, r1
	bhi	.L669
	cmp	fp, #0
	bne	.L670
.L707:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #4]
	b	.L667
.L670:
	movs	r7, #0
	movs	r2, #1
	mov	r1, fp
	mov	r0, r6
	bl	FlashReadPages
.L671:
	uxth	r3, r7
	cmp	fp, r3
	bls	.L707
	ldr	r3, .L747+52
	mov	r8, #20
	mul	r8, r8, r7
	ldr	r3, [r3]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	ldr	r5, [r2, #4]
	ldr	r6, [r2, #12]
	adds	r3, r3, #1
	ubfx	r5, r5, #10, #16
	bne	.L674
	mov	r10, #16
.L676:
	ldr	r3, .L747+52
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
	ldr	r3, .L747+52
	ldr	r3, [r3]
	bne	.L673
	mov	r2, #-1
	str	r2, [r3, r8]
	ldr	r3, .L747+52
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	cmp	r3, r2
	bne	.L674
.L675:
	movs	r1, #1
	b	.L746
.L673:
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L674
	add	r10, r10, #-1
	uxth	r10, r10
	cmp	r10, #0
	bne	.L676
	b	.L675
.L674:
	ldr	r3, .L747+68
	ldr	r2, [r3]
	ldr	r3, [r6, #4]
	adds	r1, r2, #1
	beq	.L677
	cmp	r2, r3
	bhi	.L678
.L677:
	adds	r2, r3, #1
	ittt	ne
	ldrne	r1, .L747+68
	addne	r2, r3, #1
	strne	r2, [r1]
.L678:
	ldrh	r2, [r6]
	movw	r1, #61604
	cmp	r2, r1
	beq	.L680
	bhi	.L681
	movw	r3, #61574
	cmp	r2, r3
	beq	.L682
.L679:
	adds	r7, r7, #1
	b	.L671
.L681:
	movw	r3, #61634
	cmp	r2, r3
	beq	.L683
	movw	r3, #65535
	cmp	r2, r3
	bne	.L679
	movs	r1, #0
.L746:
	mov	r0, r5
	bl	FtlFreeSysBlkQueueIn
	b	.L679
.L683:
	ldr	r3, .L747+8
	ldrh	r2, [r3]
	ldr	r3, .L747
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L685
	movw	r2, #1222
	ldr	r1, .L747+72
	ldr	r0, .L747+76
	bl	printf
.L685:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #12]
	ldr	r1, [r3]
	ldrh	r0, [r2]
	ldr	r2, .L747+12
	uxth	r10, r1
	ldr	ip, [r2]
	add	r3, r10, #-1
	sub	r10, r10, r0
	add	r10, r10, #-1
	sxth	r3, r3
	sxth	r10, r10
.L686:
	cmp	r3, r10
	bgt	.L692
	cmp	r3, #0
	bge	.L724
	b	.L679
.L692:
	ldr	r2, [ip, r3, lsl #2]
	add	r8, ip, r3, lsl #2
	ldr	r4, [r6, #4]
	cmp	r4, r2
	bls	.L687
	ldr	r2, [ip]
	cbnz	r2, .L688
	cmp	r1, r0
	ittt	ne
	ldrne	r2, .L747+8
	addne	r0, r0, #1
	strhne	r0, [r2]	@ movhi
.L688:
	ldr	r2, .L747+20
	uxth	r10, r3
	ldr	r0, [r2]
	movs	r2, #0
.L689:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L690
	ldr	r2, [r6, #4]
	cmp	r3, #0
	str	r2, [r8]
	strh	r5, [r0, r3, lsl #1]	@ movhi
	blt	.L679
	ldr	r2, .L747+8
	ldrh	r0, [r2]
	ldr	r2, .L747
	ldr	r2, [r2]
	subs	r2, r2, r0
	subs	r2, r2, #1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L679
.L724:
	ldr	r2, .L747+8
	adds	r0, r0, #1
	strh	r0, [r2]	@ movhi
	ldr	r2, [r6, #4]
	str	r2, [ip, r3, lsl #2]
	ldr	r2, .L747+20
.L744:
	ldr	r2, [r2]
	strh	r5, [r2, r3, lsl #1]	@ movhi
	b	.L679
.L690:
	add	lr, ip, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, r0, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [ip, r1, lsl #2]
	strh	lr, [r0, r1, lsl #1]	@ movhi
	b	.L689
.L687:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L686
.L748:
	.align	2
.L747:
	.word	.LANCHOR30
	.word	.LANCHOR35
	.word	.LANCHOR141
	.word	.LANCHOR135
	.word	.LANCHOR27
	.word	.LANCHOR129
	.word	.LANCHOR132
	.word	.LANCHOR36
	.word	.LANCHOR79
	.word	.LANCHOR5
	.word	.LANCHOR6
	.word	.LANCHOR3
	.word	.LANCHOR92
	.word	.LANCHOR112
	.word	.LANCHOR24
	.word	.LANCHOR91
	.word	.LANCHOR13
	.word	.LANCHOR70
	.word	.LANCHOR149
	.word	.LC1
.L682:
	ldr	r8, .L749+12
	ldr	r10, .L749+20
	ldrh	r2, [r8]
	ldrh	r3, [r10]
	cmp	r2, r3
	bls	.L695
	movw	r2, #1263
	ldr	r1, .L749
	ldr	r0, .L749+4
	bl	printf
.L695:
	ldr	r2, .L749+8
	ldrh	lr, [r10]
	ldrh	ip, [r8]
	ldr	r0, [r2]
	add	r10, lr, #-1
	sxth	r3, r10
	sub	r10, r10, ip
.L696:
	cmp	r3, r10
	ble	.L701
	ldr	r1, [r6, #4]
	add	r8, r0, r3, lsl #2
	ldr	r2, [r0, r3, lsl #2]
	cmp	r1, r2
	bls	.L697
	ldr	r2, [r0]
	cbnz	r2, .L698
	cmp	lr, ip
	ittt	ne
	ldrne	r2, .L749+12
	addne	ip, ip, #1
	strhne	ip, [r2]	@ movhi
.L698:
	ldr	r2, .L749+16
	uxth	r10, r3
	ldr	ip, [r2]
	movs	r2, #0
.L699:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L700
	ldr	r2, [r6, #4]
	str	r2, [r8]
	strh	r5, [ip, r3, lsl #1]	@ movhi
.L701:
	cmp	r3, #0
	blt	.L679
	ldr	r2, .L749+20
	ldr	ip, .L749+12
	ldrh	r2, [r2]
	ldrh	r1, [ip]
	subs	r2, r2, #1
	subs	r2, r2, r1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L679
	ldr	r2, [r6, #4]
	adds	r1, r1, #1
	strh	r1, [ip]	@ movhi
	str	r2, [r0, r3, lsl #2]
	ldr	r2, .L749+16
	b	.L744
.L700:
	add	lr, r0, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, ip, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [r0, r1, lsl #2]
	strh	lr, [ip, r1, lsl #1]	@ movhi
	b	.L699
.L697:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L696
.L680:
	ldr	r8, .L749+40
	movw	r2, #65535
	ldrh	r1, [r8]
	cmp	r1, r2
	bne	.L703
.L745:
	strh	r5, [r8]	@ movhi
	str	r3, [r8, #8]
	b	.L679
.L703:
	ldrh	r0, [r8, #4]
	cmp	r0, r2
	beq	.L704
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L704:
	ldr	r3, [r6, #4]
	ldr	r2, [r8, #8]
	cmp	r2, r3
	bcs	.L705
	ldrh	r2, [r8]
	strh	r2, [r8, #4]	@ movhi
	b	.L745
.L705:
	strh	r5, [r8, #4]	@ movhi
	b	.L679
.L708:
	ldr	r3, .L749+24
	ldr	r2, [r3]
	ldrh	r3, [r2]
	cbz	r3, .L710
.L713:
	ldr	r3, .L749+16
	ldr	r4, [r3]
	ldrh	r2, [r4]
	cmp	r2, #0
	beq	.L711
.L712:
	ldr	r3, .L749+28
	ldrh	r2, [r3]
	ldr	r3, .L749+32
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L743
	movw	r2, #1388
	ldr	r1, .L749
	ldr	r0, .L749+4
	bl	printf
.L743:
	movs	r0, #0
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L710:
	ldr	r1, .L749+28
	ldrh	r1, [r1]
	cmp	r1, #0
	beq	.L713
	ldr	r5, .L749+32
	ldr	r0, [r5]
.L714:
	sxth	r1, r3
	cmp	r1, r0
	bcs	.L713
	ldrh	r4, [r2, r1, lsl #1]
	adds	r3, r3, #1
	cmp	r4, #0
	beq	.L714
	ldr	r3, .L749+36
	movs	r6, #0
	ldr	r0, [r3]
	mov	r3, r1
.L715:
	ldr	r4, [r5]
	cmp	r3, r4
	bcs	.L713
	ldrh	r7, [r2, r3, lsl #1]
	subs	r4, r3, r1
	strh	r7, [r2, r4, lsl #1]	@ movhi
	ldr	r7, [r0, r3, lsl #2]
	str	r7, [r0, r4, lsl #2]
	strh	r6, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	sxth	r3, r3
	b	.L715
.L711:
	ldr	r3, .L749+12
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L712
	ldr	r5, .L749+20
	ldrh	r1, [r5]
.L720:
	sxth	r3, r2
	cmp	r3, r1
	mov	r6, r3
	bge	.L712
	ldrh	r0, [r4, r3, lsl #1]
	adds	r2, r2, #1
	cmp	r0, #0
	beq	.L720
	ldr	r2, .L749+8
	movs	r0, #0
	ldr	r2, [r2]
.L721:
	ldrh	r1, [r5]
	cmp	r3, r1
	bge	.L712
	ldrh	r7, [r4, r3, lsl #1]
	subs	r1, r3, r6
	strh	r7, [r4, r1, lsl #1]	@ movhi
	ldr	r7, [r2, r3, lsl #2]
	str	r7, [r2, r1, lsl #2]
	adds	r1, r3, #1
	strh	r0, [r4, r3, lsl #1]	@ movhi
	sxth	r3, r1
	b	.L721
.L750:
	.align	2
.L749:
	.word	.LANCHOR149
	.word	.LC1
	.word	.LANCHOR132
	.word	.LANCHOR35
	.word	.LANCHOR36
	.word	.LANCHOR27
	.word	.LANCHOR129
	.word	.LANCHOR141
	.word	.LANCHOR30
	.word	.LANCHOR135
	.word	.LANCHOR79
	.size	FtlScanSysBlk, .-FtlScanSysBlk
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
	ldr	r8, .L780+40
	ldr	r4, .L780
	ldr	r3, [r8]
	ldr	r7, .L780+4
	mov	r10, r4
	str	r3, [r4, #8]
	ldr	r3, .L780+8
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FtlBbtMemInit
	ldrh	r5, [r7]
	subs	r5, r5, #1
	uxth	r5, r5
.L752:
	ldrh	r3, [r7]
	subs	r3, r3, #15
	cmp	r3, r5
	bgt	.L755
	lsls	r3, r5, #10
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L753
	ldr	r3, [r4, #4]
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	adds	r3, r3, #1
	str	r3, [r4, #4]
	bl	FlashReadPages
.L753:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L754
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L754
	ldr	r3, .L780+12
	ldr	r2, [r6, #4]
	strh	r5, [r3]	@ movhi
	str	r2, [r3, #8]
	ldrh	r2, [r6, #8]
	strh	r2, [r3, #4]	@ movhi
.L755:
	ldr	r5, .L780+12
	movw	r2, #65535
	ldrh	r3, [r5]
	cmp	r3, r2
	beq	.L769
	ldrh	r3, [r5, #4]
	cmp	r3, r2
	beq	.L759
	lsls	r3, r3, #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L780
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L759
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L759
	ldr	r3, [r6, #4]
	ldr	r2, [r5, #8]
	cmp	r3, r2
	bls	.L759
	ldrh	r2, [r5, #4]
	str	r3, [r5, #8]
	ldrh	r3, [r6, #8]
	strh	r2, [r5]	@ movhi
	strh	r3, [r5, #4]	@ movhi
.L759:
	ldr	r10, .L780
	movs	r1, #1
	ldrh	r0, [r5]
	bl	FtlGetLastWrittenPage
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r5, #2]	@ movhi
.L761:
	cmp	r7, #0
	bge	.L764
	movs	r2, #253
	ldr	r1, .L780+16
	ldr	r0, .L780+20
	bl	printf
.L763:
	ldrh	r3, [r6, #10]
	ldrh	r0, [r6, #12]
	strh	r3, [r5, #6]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L766
	ldr	r3, .L780+24
	ldr	r2, [r3]
	cmp	r0, r2
	beq	.L766
	ldr	r3, .L780+28
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	cmp	r2, r3
	bcs	.L766
	cmp	r0, r3
	bcs	.L766
	bl	FtlSysBlkNumInit
.L766:
	ldr	r6, .L780+32
	movs	r5, #0
	ldr	r7, .L780+36
	ldr	r8, .L780+44
.L767:
	ldrh	r3, [r7]
	cmp	r5, r3
	bcc	.L768
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L754:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L752
.L764:
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
	beq	.L762
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	beq	.L763
.L762:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L761
.L768:
	ldrh	r2, [r8]
	ldr	r1, [r4, #8]
	ldr	r0, [r6, #4]!
	lsls	r2, r2, #2
	mla	r1, r5, r2, r1
	adds	r5, r5, #1
	bl	ftl_memcpy
	b	.L767
.L769:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L781:
	.align	2
.L780:
	.word	.LANCHOR148
	.word	.LANCHOR17
	.word	.LANCHOR123
	.word	.LANCHOR37
	.word	.LANCHOR150
	.word	.LC1
	.word	.LANCHOR2
	.word	.LANCHOR6
	.word	.LANCHOR37+24
	.word	.LANCHOR10
	.word	.LANCHOR115
	.word	.LANCHOR137
	.size	FtlLoadBbt, .-FtlLoadBbt
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
	ldr	r8, .L803+136
	ldr	r5, .L803
	ldr	r3, [r8]
	ldr	r4, .L803+4
	ldr	r10, .L803+140
	ldrh	r2, [r5]
	ldr	r7, .L803+8
	str	r3, [r4, #8]
	ldr	r6, .L803+12
	ldr	r3, [r10]
	lsls	r2, r2, #1
	ldr	r0, [r7]
	str	r3, [r4, #12]
	bl	ftl_memset
	ldrh	r0, [r6]
	movw	r3, #65535
	str	r7, [sp]
	cmp	r0, r3
	bne	.L783
.L791:
	mov	r0, #-1
.L782:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L783:
	movs	r1, #1
	mov	fp, r4
	bl	FtlGetLastWrittenPage
	ldr	r3, .L803+16
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r6, #2]	@ movhi
.L785:
	cmp	r7, #0
	bge	.L788
	mov	r2, #1448
	ldr	r1, .L803+20
	ldr	r0, .L803+24
	bl	printf
.L787:
	ldr	r2, .L803+28
	ldrh	r3, [r5]
	ldrh	r2, [r2]
	adds	r3, r3, #24
	cmp	r2, r3, lsl #1
	bcs	.L790
	movw	r2, #1450
	ldr	r1, .L803+20
	ldr	r0, .L803+24
	bl	printf
.L790:
	ldr	r7, .L803+32
	movs	r2, #48
	ldr	r1, [r4, #8]
	mov	r0, r7
	bl	ftl_memcpy
	ldrh	r2, [r5]
	ldr	r1, [r4, #8]
	ldr	r3, [sp]
	lsls	r2, r2, #1
	adds	r1, r1, #48
	ldr	r0, [r3]
	bl	ftl_memcpy
	ldrh	r1, [r5]
	ldr	r3, [r4, #8]
	mov	r4, r7
	lsrs	r2, r1, #3
	adds	r1, r1, #24
	lsls	r1, r1, #1
	adds	r2, r2, #4
	bic	r1, r1, #3
	add	r1, r1, r3
	ldr	r3, .L803+36
	ldr	r0, [r3]
	bl	ftl_memcpy
	ldr	r2, [r7]
	ldr	r3, .L803+16
	cmp	r2, r3
	bne	.L791
	ldr	r3, .L803+40
	ldrb	r2, [r7, #10]	@ zero_extendqisi2
	ldrh	r5, [r7, #8]
	ldrh	r3, [r3]
	strh	r5, [r6, #6]	@ movhi
	cmp	r2, r3
	bne	.L791
	ldr	r3, .L803+44
	ldr	r2, .L803+48
	str	r5, [r3]
	ldr	r3, .L803+52
	ldrh	r3, [r3]
	muls	r3, r5, r3
	str	r3, [r2]
	ldr	r2, .L803+56
	ldrh	r2, [r2]
	muls	r3, r2, r3
	ldr	r2, .L803+60
	str	r3, [r2]
	ldr	r3, .L803+64
	ldr	r6, [r3]
	ldr	r3, .L803+68
	ldrh	r0, [r3, #6]
	ldr	r3, .L803+72
	subs	r0, r6, r0
	ldrh	r1, [r3]
	subs	r0, r0, r5
	bl	__aeabi_uidiv
	ldr	r3, .L803+76
	cmp	r5, r6
	strh	r0, [r3]	@ movhi
	bls	.L792
	mov	r2, #1472
	ldr	r1, .L803+20
	ldr	r0, .L803+24
	bl	printf
.L792:
	ldrh	r2, [r4, #16]
	ldr	r3, .L803+80
	ldrh	ip, [r4, #14]
	ldr	r7, .L803+84
	lsrs	r1, r2, #6
	and	r2, r2, #63
	strb	r2, [r3, #6]
	ldrb	r2, [r4, #11]	@ zero_extendqisi2
	strh	r1, [r3, #2]	@ movhi
	ldr	r1, .L803+88
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
	ldr	r2, .L803+92
	strh	r5, [r2]	@ movhi
	ldrh	r5, [r4, #24]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r2, #6]
	ldrb	r5, [r4, #13]	@ zero_extendqisi2
	strh	r6, [r2, #2]	@ movhi
	ldr	r6, [r4, #32]
	strb	r5, [r2, #8]
	ldr	r5, .L803+96
	str	r3, [r5]
	ldr	r5, .L803+100
	str	r3, [r5]
	ldr	r5, .L803+104
	str	r3, [r5]
	ldr	r5, .L803+108
	str	r3, [r5]
	ldr	r5, .L803+112
	str	r6, [r5]
	mov	r6, r1
	ldr	r5, .L803+116
	str	r3, [r5]
	ldr	r5, .L803+120
	str	r3, [r5]
	ldr	r5, .L803+124
	ldr	lr, [r4, #40]
	str	r3, [r5]
	ldr	r3, .L803+128
	ldr	r5, [r3]
	cmp	lr, r5
	mov	r5, r2
	it	hi
	strhi	lr, [r3]
	ldr	r3, .L803+132
	ldr	r2, [r4, #36]
	ldr	r1, [r3]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3]
	movw	r3, #65535
	cmp	ip, r3
	beq	.L795
	ldr	r0, .L803+80
	bl	make_superblock
.L795:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L796
	ldr	r0, .L803+88
	bl	make_superblock
.L796:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L797
	ldr	r0, .L803+92
	bl	make_superblock
.L797:
	ldrh	r2, [r7]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L798
	ldr	r0, .L803+84
	bl	make_superblock
.L798:
	movs	r0, #0
	b	.L782
.L788:
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
	beq	.L786
	ldr	r2, [r8]
	ldr	r2, [r2]
	cmp	r2, r3
	bne	.L786
	ldr	r2, [r10]
	ldrh	r1, [r2]
	movw	r2, #61604
	cmp	r1, r2
	beq	.L787
.L786:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L785
.L804:
	.align	2
.L803:
	.word	.LANCHOR5
	.word	.LANCHOR148
	.word	.LANCHOR42
	.word	.LANCHOR79
	.word	1179929683
	.word	.LANCHOR151
	.word	.LC1
	.word	.LANCHOR23
	.word	.LANCHOR39
	.word	.LANCHOR1
	.word	.LANCHOR10
	.word	.LANCHOR152
	.word	.LANCHOR61
	.word	.LANCHOR19
	.word	.LANCHOR12
	.word	.LANCHOR34
	.word	.LANCHOR7
	.word	.LANCHOR37
	.word	.LANCHOR3
	.word	.LANCHOR78
	.word	.LANCHOR51
	.word	.LANCHOR80
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR67
	.word	.LANCHOR64
	.word	.LANCHOR62
	.word	.LANCHOR66
	.word	.LANCHOR72
	.word	.LANCHOR73
	.word	.LANCHOR76
	.word	.LANCHOR65
	.word	.LANCHOR70
	.word	.LANCHOR71
	.word	.LANCHOR115
	.word	.LANCHOR123
	.size	FtlLoadSysInfo, .-FtlLoadSysInfo
	.section	.text.FlashProgPages,"ax",%progbits
	.align	1
	.global	FlashProgPages
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashProgPages, %function
FlashProgPages:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #48
	str	r3, [sp, #12]
	mov	r10, r1
	mov	r4, r0
	mov	r5, r0
	ldr	r3, .L843
	mov	r8, #0
	ldr	fp, .L843+48
	str	r2, [sp, #8]
	ldrh	r3, [r3, #12]
	str	r3, [sp]
	lsls	r3, r3, #3
	str	r3, [sp, #4]
.L806:
	cmp	r8, r10
	bne	.L818
	ldr	r3, [sp, #12]
	cmp	r3, #0
	beq	.L836
	ldr	r6, .L843+4
	movs	r5, #0
.L820:
	cmp	r8, r5
	beq	.L836
	ldr	r7, .L843+8
	movs	r1, #0
	ldr	r2, [r6]
	add	r0, sp, #28
	ldr	r3, [r7]
	str	r1, [r2]
	str	r1, [r3]
	ldr	r1, [r4, #4]
	str	r2, [sp, #36]
	ldr	r2, [sp, #8]
	str	r1, [sp, #32]
	movs	r1, #1
	str	r3, [sp, #40]
	bl	FlashReadPages
	ldr	r10, [sp, #28]
	cmp	r10, #-1
	bne	.L821
	ldr	r1, [r4, #4]
	ldr	r0, .L843+12
	bl	printf
	str	r10, [r4]
.L821:
	ldr	r3, [r4, #12]
	cbz	r3, .L822
	ldr	r2, [r3]
	ldr	r3, [r7]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L822
	ldr	r1, [r4, #4]
	ldr	r0, .L843+16
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L822:
	ldr	r3, [r4, #8]
	cbz	r3, .L823
	ldr	r2, [r3]
	ldr	r3, [r6]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L823
	ldr	r1, [r4, #4]
	ldr	r0, .L843+20
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L823:
	adds	r5, r5, #1
	adds	r4, r4, #20
	b	.L820
.L818:
	ldr	r3, [r5, #8]
	cbz	r3, .L807
	ldr	r3, [r5, #12]
	cbnz	r3, .L808
.L807:
	movs	r2, #130
	ldr	r1, .L843+24
	ldr	r0, .L843+28
	bl	printf
.L808:
	add	r2, sp, #20
	add	r1, sp, #24
	ldr	r0, [r5, #4]
	bl	l2p_addr_tran.isra.0
	ldr	r6, [sp, #20]
	cbnz	r6, .L809
	ldr	r3, [sp, #24]
	ldr	r2, [sp, #4]
	cmp	r2, r3
	bls	.L809
	ldr	r5, .L843+24
	ldr	r7, .L843+32
	b	.L842
.L811:
	mov	r3, #-1
	ldr	r2, [r4, #-16]
	str	r3, [r4, #-20]
	mov	r1, r5
	mov	r0, r7
	adds	r6, r6, #1
	bl	printf
	movs	r3, #16
	movs	r2, #4
	ldr	r1, [r4, #-12]
	ldr	r0, .L843+36
	bl	rknand_print_hex
	movs	r3, #4
	ldr	r1, [r4, #-8]
	mov	r2, r3
	ldr	r0, .L843+40
	bl	rknand_print_hex
.L842:
	cmp	r6, r10
	add	r4, r4, #20
	bne	.L811
.L836:
	movs	r0, #0
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L809:
	ldr	r1, [r5, #8]
	lsls	r3, r1, #26
	beq	.L825
	ldr	r3, .L843+4
	ldr	r6, [r3]
	cmp	r1, r6
	beq	.L812
	ldr	r3, .L843+44
	mov	r0, r6
	ldrh	r2, [r3]
	lsls	r2, r2, #9
	bl	ftl_memcpy
.L812:
	ldr	r3, [r5, #12]
	mov	r2, r6
	ldr	r1, [sp, #24]
	ldrb	r0, [sp, #20]	@ zero_extendqisi2
	ldr	r7, [fp, #8]
	blx	r7
	cbnz	r0, .L813
	str	r0, [r5]
.L814:
	ldr	r3, .L843
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	bne	.L816
	ldr	r0, [sp]
	add	r2, r6, #2048
	ldr	r3, [r5, #12]
	ldr	r1, [sp, #24]
	ldr	r6, [fp, #8]
	adds	r3, r3, #8
	add	r1, r1, r0
	ldrb	r0, [sp, #20]	@ zero_extendqisi2
	blx	r6
	cbz	r0, .L816
	mov	r3, #-1
	str	r3, [r5]
.L816:
	add	r8, r8, #1
	adds	r5, r5, #20
	b	.L806
.L825:
	mov	r6, r1
	b	.L812
.L813:
	mov	r3, #-1
	str	r3, [r5]
	b	.L814
.L844:
	.align	2
.L843:
	.word	.LANCHOR0
	.word	.LANCHOR120
	.word	.LANCHOR122
	.word	.LC85
	.word	.LC86
	.word	.LC87
	.word	.LANCHOR153
	.word	.LC1
	.word	.LC79
	.word	.LC80
	.word	.LC81
	.word	.LANCHOR12
	.word	.LANCHOR105
	.size	FlashProgPages, .-FlashProgPages
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
	ldr	r3, .L888
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r7, .L888+4
	mov	r8, #0
	mov	r6, r1
	mov	r5, r8
	str	r0, [r3]
	mov	r4, r8
	ldr	r3, .L888+8
	mov	fp, #20
	ldr	r10, [r7]
	str	r0, [sp, #4]
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L888+12
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L888+16
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L888+20
	ldrh	r3, [r3]
	str	r3, [sp, #24]
.L846:
	ldr	r3, [sp, #12]
	uxth	r2, r8
	cmp	r3, r2
	bhi	.L850
	cmp	r5, #0
	beq	.L845
	mov	r0, r10
	mov	r8, #0
	mov	r10, #20
	mov	r2, r5
	movs	r1, #0
	bl	FlashEraseBlocks
.L853:
	uxth	r3, r8
	cmp	r5, r3
	bhi	.L855
	cmp	r6, #0
	beq	.L871
	ldr	r3, .L888+24
	mov	r10, #1
	ldrh	r3, [r3]
	str	r3, [sp, #8]
.L856:
	movs	r7, #0
.L865:
	ldr	r3, .L888+8
	mov	r8, #0
	mov	r5, r8
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L888+4
	ldr	fp, [r3]
	ldr	r3, .L888+28
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L888+12
	ldr	r3, [r3]
	str	r3, [sp, #24]
	ldr	r3, .L888+20
	ldrh	r3, [r3]
	str	r3, [sp, #28]
.L857:
	ldr	r3, [sp, #16]
	uxth	r2, r8
	cmp	r3, r2
	bhi	.L860
	cbz	r5, .L845
	mov	r0, fp
	ldr	fp, .L888+4
	movs	r3, #1
	mov	r2, r10
	mov	r1, r5
	mov	r8, #0
	bl	FlashProgPages
	movs	r3, #20
.L862:
	uxth	r2, r8
	cmp	r5, r2
	bhi	.L864
	adds	r7, r7, #1
	ldr	r2, [sp, #8]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L865
	ldr	r8, .L888+4
	movs	r7, #0
	mov	fp, #20
.L866:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L868
	ldr	r3, [sp, #4]
	cmp	r3, #63
	bls	.L869
	cbz	r6, .L845
.L869:
	ldr	r3, .L888+4
	mov	r2, r5
	mov	r1, r10
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L845:
	mov	r0, r4
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L850:
	mul	r2, fp, r8
	movs	r3, #0
	ldr	r1, [sp, #4]
	str	r3, [r10, r2]
	ldr	r3, .L888+32
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	V2P_block
	str	r0, [sp, #8]
	cbz	r6, .L847
	bl	IsBlkInVendorPart
	cbnz	r0, .L848
.L847:
	ldr	r0, [sp, #8]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L849
	ldr	r3, [sp, #8]
	mla	r1, fp, r5, r10
	lsls	r2, r3, #10
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
.L848:
	add	r8, r8, #1
	b	.L846
.L849:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L848
.L855:
	mul	r3, r10, r8
	ldr	r2, [r7]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	adds	r3, r3, #1
	bne	.L854
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L854:
	add	r8, r8, #1
	b	.L853
.L871:
	movs	r3, #2
	mov	r10, r6
	str	r3, [sp, #8]
	b	.L856
.L860:
	movs	r3, #20
	ldr	r1, [sp, #4]
	mul	r2, r3, r8
	movs	r3, #0
	str	r3, [fp, r2]
	ldr	r3, .L888+32
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	V2P_block
	str	r0, [sp, #12]
	cbz	r6, .L858
	bl	IsBlkInVendorPart
	cbnz	r0, .L859
.L858:
	ldr	r0, [sp, #12]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L859
	movs	r3, #20
	mla	r1, r3, r5, fp
	ldr	r3, [sp, #12]
	add	r2, r7, r3, lsl #10
	ldr	r3, [sp, #20]
	str	r2, [r1, #4]
	str	r3, [r1, #8]
	ldr	r3, [sp, #28]
	mul	r2, r3, r5
	ldr	r3, [sp, #24]
	adds	r5, r5, #1
	uxth	r5, r5
	bic	r2, r2, #3
	add	r2, r2, r3
	str	r2, [r1, #12]
.L859:
	add	r8, r8, #1
	b	.L857
.L864:
	mul	r2, r3, r8
	ldr	r1, [fp]
	adds	r0, r1, r2
	ldr	r2, [r1, r2]
	cbz	r2, .L863
	ldr	r0, [r0, #4]
	adds	r4, r4, #1
	str	r3, [sp, #12]
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
	ldr	r3, [sp, #12]
.L863:
	add	r8, r8, #1
	b	.L862
.L868:
	cbz	r6, .L867
	mul	r3, fp, r7
	ldr	r2, [r8]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbnz	r3, .L867
	ldr	r0, [r1, #4]
	movs	r1, #1
	ubfx	r0, r0, #10, #16
	bl	FtlFreeSysBlkQueueIn
.L867:
	adds	r7, r7, #1
	b	.L866
.L889:
	.align	2
.L888:
	.word	.LANCHOR111
	.word	.LANCHOR106
	.word	.LANCHOR3
	.word	.LANCHOR119
	.word	.LANCHOR124
	.word	.LANCHOR24
	.word	.LANCHOR20
	.word	.LANCHOR118
	.word	.LANCHOR13
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
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
	push	{r3, r4, r5, r6, r7, lr}
	movw	r2, #65535
	ldrh	r3, [r0]
	mov	r4, r0
	ldr	r5, [r0, #12]
	cmp	r3, r2
	bne	.L891
	ldrh	r3, [r0, #8]
	cbz	r3, .L892
	movw	r2, #641
	ldr	r1, .L900
	ldr	r0, .L900+4
	bl	printf
.L892:
	ldrh	r3, [r4, #8]
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	movs	r3, #0
	strh	r0, [r5]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	strh	r3, [r4]	@ movhi
	ldr	r3, [r4, #28]
	adds	r3, r3, #1
	str	r3, [r4, #28]
.L893:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L891:
	ldrh	r5, [r5, r3, lsl #1]
	movs	r1, #255
	ldrh	r3, [r0, #2]
	ldr	r2, .L900+8
	ldr	r7, .L900+12
	ldr	r6, [r0, #24]
	orr	r3, r3, r5, lsl #10
	ldr	r0, [r7]
	str	r3, [r2, #4]
	ldr	r3, .L900+16
	str	r0, [r2, #8]
	ldr	r3, [r3]
	str	r3, [r2, #12]
	ldr	r2, [r4, #28]
	str	r2, [r3, #4]
	movw	r2, #64245
	strh	r2, [r3, #8]	@ movhi
	ldrh	r2, [r4, #4]
	strh	r5, [r3, #2]	@ movhi
	strh	r2, [r3]	@ movhi
	ldr	r3, .L900+20
	ldrh	r2, [r3]
	lsls	r2, r2, #3
	bl	ftl_memset
	ldrh	ip, [r4, #6]
	movs	r3, #0
	ldr	r1, [r7]
	mov	r2, r3
.L894:
	uxth	r0, r3
	cmp	ip, r0
	bhi	.L896
	movs	r2, #1
	movs	r3, #0
	mov	r1, r2
	ldr	r0, .L900+8
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	mov	r0, r4
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	bl	ftl_map_blk_gc
	b	.L893
.L896:
	ldr	r0, [r6, r3, lsl #2]
	cmp	r5, r0, lsr #10
	bne	.L895
	adds	r2, r2, #1
	uxth	r2, r2
	str	r3, [r1, r2, lsl #3]
	add	r7, r1, r2, lsl #3
	ldr	r0, [r6, r3, lsl #2]
	str	r0, [r7, #4]
.L895:
	adds	r3, r3, #1
	b	.L894
.L901:
	.align	2
.L900:
	.word	.LANCHOR154
	.word	.LC1
	.word	.LANCHOR148
	.word	.LANCHOR115
	.word	.LANCHOR123
	.word	.LANCHOR20
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
	ldr	r8, .L926+28
	mov	r7, r1
	movs	r6, #0
	str	r2, [sp, #4]
	mov	fp, r8
.L903:
	ldr	r2, .L926
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	ldrh	r3, [r8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L904
	ldrh	r2, [r4]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L905
.L904:
	mov	r0, r4
	bl	Ftl_write_map_blk_to_last_page
.L905:
	ldrh	r2, [r4]
	ldr	r3, [r4, #12]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L906
	movw	r2, #699
	ldr	r1, .L926+4
	ldr	r0, .L926+8
	bl	printf
.L906:
	ldrh	r2, [r4]
	ldrh	r3, [r4, #10]
	cmp	r2, r3
	bcc	.L907
	mov	r2, #700
	ldr	r1, .L926+4
	ldr	r0, .L926+8
	bl	printf
.L907:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r4, #12]
	ldr	r5, .L926+12
	ldrh	r10, [r3, r2, lsl #1]
	ldrh	r2, [r4, #2]
	ldr	r3, [sp, #4]
	orr	r2, r2, r10, lsl #10
	str	r3, [r5, #8]
	str	r2, [r5, #4]
	ldr	r2, .L926+16
	ldr	r0, [r2]
	movs	r2, #16
	str	r0, [r5, #12]
	bl	ftl_memset
	ldr	r2, [r5, #12]
	movs	r3, #1
	ldr	r1, [r4, #28]
	mov	r0, r5
	strh	r7, [r2, #8]	@ movhi
	str	r1, [r2, #4]
	ldrh	r1, [r4, #4]
	strh	r10, [r2, #2]	@ movhi
	strh	r1, [r2]	@ movhi
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r2, [r4, #2]
	ldr	r1, [r5]
	adds	r2, r2, #1
	uxth	r2, r2
	adds	r3, r1, #1
	strh	r2, [r4, #2]	@ movhi
	bne	.L908
	ldr	r1, [r5, #4]
	adds	r6, r6, #1
	ldr	r0, .L926+20
	uxth	r6, r6
	bl	printf
	ldrh	r2, [r4, #2]
	cmp	r2, #2
	ittt	ls
	ldrhls	r2, [fp]
	addls	r2, r2, #-1
	strhls	r2, [r4, #2]	@ movhi
	cmp	r6, #3
	bls	.L910
	mov	r2, r6
	ldr	r1, [r5, #4]
	ldr	r0, .L926+24
	bl	printf
.L911:
	b	.L911
.L910:
	ldr	r3, [r4, #32]
	cmp	r3, #0
	beq	.L903
.L925:
	b	.L925
.L908:
	cmp	r2, #1
	beq	.L914
	cmp	r1, #256
	beq	.L914
	ldr	r0, [r4, #36]
	cbz	r0, .L915
.L914:
	movs	r3, #0
	str	r3, [r4, #36]
	b	.L903
.L915:
	ldr	r2, [r5, #4]
	ldr	r3, [r4, #24]
	str	r2, [r3, r7, lsl #2]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L927:
	.align	2
.L926:
	.word	.LANCHOR66
	.word	.LANCHOR155
	.word	.LC1
	.word	.LANCHOR148
	.word	.LANCHOR123
	.word	.LC88
	.word	.LC89
	.word	.LANCHOR20
	.size	FtlMapWritePage, .-FtlMapWritePage
	.section	.text.load_l2p_region,"ax",%progbits
	.align	1
	.global	load_l2p_region
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	load_l2p_region, %function
load_l2p_region:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L935
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	mov	r10, r1
	ldrh	r2, [r3]
	str	r3, [sp, #4]
	cmp	r2, r0
	bcs	.L929
	movw	r2, #485
	ldr	r1, .L935+4
	ldr	r0, .L935+8
	bl	printf
.L929:
	ldr	fp, .L935+48
	movs	r4, #12
	ldr	r7, .L935+12
	ldr	r3, [fp]
	ldr	r8, [r3, r5, lsl #2]
	cmp	r8, #0
	bne	.L930
	mul	r4, r4, r10
	ldr	r2, [r7]
	movs	r1, #255
	adds	r0, r2, r4
	ldr	r2, .L935+16
	ldr	r0, [r0, #8]
	ldrh	r2, [r2]
	bl	ftl_memset
	ldr	r2, [r7]
	adds	r1, r2, r4
	strh	r5, [r2, r4]	@ movhi
	str	r8, [r1, #4]
.L931:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L930:
	mul	r4, r4, r10
	ldr	r2, [r7]
	ldr	r6, .L935+20
	add	r2, r2, r4
	mov	r0, r6
	ldr	r2, [r2, #8]
	str	r8, [r6, #4]
	str	r2, [r6, #8]
	ldr	r2, .L935+24
	ldr	r2, [r2]
	str	r2, [r6, #12]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r10, [r6, #12]
	ldrh	r2, [r10, #8]
	cmp	r2, r5
	beq	.L932
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L935+28
	bl	printf
	movs	r3, #4
	ldr	r1, [r6, #12]
	mov	r2, r3
	ldr	r0, .L935+32
	bl	rknand_print_hex
	ldr	r3, [sp, #4]
	movs	r2, #4
	ldr	r1, [fp]
	ldr	r0, .L935+36
	ldrh	r3, [r3]
	bl	rknand_print_hex
.L933:
	ldrh	r3, [r10, #8]
	cmp	r3, r5
	beq	.L934
	mov	r2, #508
	ldr	r1, .L935+4
	ldr	r0, .L935+8
	bl	printf
.L934:
	ldr	r3, [r7]
	movs	r1, #0
	adds	r2, r3, r4
	str	r1, [r2, #4]
	strh	r5, [r3, r4]	@ movhi
	b	.L931
.L932:
	ldr	r2, [r6]
	cmp	r2, #256
	bne	.L933
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L935+40
	bl	printf
	ldr	r3, [r7]
	mov	r1, r5
	ldr	r0, .L935+44
	add	r3, r3, r4
	ldr	r2, [r3, #8]
	bl	FtlMapWritePage
	b	.L933
.L936:
	.align	2
.L935:
	.word	.LANCHOR32
	.word	.LANCHOR156
	.word	.LC1
	.word	.LANCHOR55
	.word	.LANCHOR23
	.word	.LANCHOR148
	.word	.LANCHOR123
	.word	.LC90
	.word	.LC91
	.word	.LC92
	.word	.LC93
	.word	.LANCHOR140
	.word	.LANCHOR134
	.size	load_l2p_region, .-load_l2p_region
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
	subs	r3, r3, #5
	cmp	r2, r3
	blt	.L938
	uxth	r0, r0
	ldrh	r8, [r5, r0, lsl #1]
	cmp	r8, #0
	beq	.L938
	ldr	r3, [r4, #32]
	cbnz	r3, .L938
	movs	r2, #1
	str	r2, [r4, #32]
	strh	r3, [r5, r0, lsl #1]	@ movhi
	ldrh	r3, [r4, #8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	ldr	r3, .L953
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L939
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L939:
	ldr	r5, .L953+4
	movs	r6, #0
.L940:
	ldrh	r3, [r4, #6]
	uxth	r10, r6
	cmp	r3, r10
	bhi	.L947
	movs	r1, #1
	mov	r0, r8
	bl	FtlFreeSysBlkQueueIn
	movs	r3, #0
	str	r3, [r4, #32]
.L938:
	ldr	r3, .L953
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L948
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L948:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L947:
	ldr	r3, [sp]
	uxth	fp, r6
	add	r3, r3, fp, lsl #2
	str	r3, [sp, #4]
	ldr	r3, [sp]
	ldr	r2, [r3, fp, lsl #2]
	cmp	r8, r2, lsr #10
	bne	.L941
	ldr	r3, .L953+8
	str	r2, [r5, #4]
	movs	r2, #1
	ldr	r0, .L953+4
	ldr	r1, [r3]
	str	r1, [r5, #8]
	ldr	r1, .L953+12
	ldr	r7, [r1]
	mov	r1, r2
	str	r7, [r5, #12]
	bl	FlashReadPages
	ldrh	r2, [r7, #8]
	cmp	r2, r10
	beq	.L942
	movw	r2, #611
	ldr	r1, .L953+16
	ldr	r0, .L953+20
	bl	printf
.L942:
	ldr	r2, [r5]
	adds	r2, r2, #1
	bne	.L943
.L945:
	ldr	r2, [sp, #4]
	movs	r3, #0
	str	r3, [r2]
.L944:
	b	.L944
.L943:
	ldrh	r2, [r7, #8]
	cmp	r2, r10
	bne	.L945
	ldrh	r1, [r7]
	ldrh	r2, [r4, #4]
	cmp	r1, r2
	bne	.L945
	ldr	r2, [r5, #8]
	mov	r1, fp
	mov	r0, r4
	bl	FtlMapWritePage
.L941:
	adds	r6, r6, #1
	b	.L940
.L954:
	.align	2
.L953:
	.word	.LANCHOR20
	.word	.LANCHOR148
	.word	.LANCHOR116
	.word	.LANCHOR123
	.word	.LANCHOR157
	.word	.LC1
	.size	ftl_map_blk_gc, .-ftl_map_blk_gc
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
	ldr	r5, .L982
	str	r3, [sp, #4]
	bl	ftl_memset
	ldr	r3, .L982+4
	str	r6, [r4, #32]
	str	r6, [r4, #28]
	ldr	r2, [r3]
	str	r3, [sp, #8]
	str	r2, [r5, #8]
	ldr	r2, .L982+8
	ldr	r7, [r2]
	movw	r2, #65535
	str	r7, [r5, #12]
	strh	r2, [r4]	@ movhi
	strh	r2, [r4, #2]	@ movhi
	movs	r2, #1
	str	r2, [r4, #36]
.L956:
	ldr	r2, [sp, #4]
	sxth	r3, r6
	cmp	r3, r2
	bge	.L973
	ldr	r2, [sp, #4]
	subs	r2, r2, #1
	cmp	r3, r2
	lsl	r2, r3, #1
	bne	.L957
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
	ldr	r3, .L982
.L958:
	sxth	r2, r6
	cmp	r2, r10
	ble	.L960
.L973:
	mov	r0, r4
	bl	ftl_free_no_use_map_blk
	ldr	r3, .L982+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L962
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L962:
	mov	r0, r4
	bl	ftl_map_blk_gc
	mov	r0, r4
	bl	ftl_map_blk_gc
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L960:
	ldrh	r1, [r5]
	ldr	r0, .L982
	str	r3, [sp, #4]
	orr	r2, r2, r1, lsl #10
	str	r2, [r3, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r3, [sp, #4]
	ldr	r2, [r3]
	adds	r2, r2, #1
	beq	.L959
	ldrh	r2, [r7, #8]
	cmp	fp, r2
	bls	.L959
	ldrh	r1, [r4, #4]
	ldrh	r0, [r7]
	cmp	r0, r1
	itt	eq
	ldreq	r1, [r3, #4]
	streq	r1, [r8, r2, lsl #2]
.L959:
	adds	r6, r6, #1
	b	.L958
.L957:
	ldr	r1, [sp, #8]
	add	r2, r10, r2
	str	r2, [sp, #16]
	ldr	r0, .L982
	ldr	r1, [r1]
	str	r1, [r5, #8]
	ldrh	r1, [r10, r3, lsl #1]
	ldr	r3, .L982+12
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
	beq	.L975
	ldrh	r1, [r7]
	ldrh	r2, [r4, #4]
	ldr	r3, [sp, #20]
	cmp	r1, r2
	bne	.L975
	ldrh	r1, [r7, #8]
	movw	r2, #64245
	cmp	r1, r2
	beq	.L964
.L975:
	movs	r3, #0
.L965:
	ldr	r1, .L982+12
	sxth	r2, r3
	ldrh	r1, [r1]
	cmp	r2, r1
	bge	.L971
	str	r3, [sp, #20]
	ldr	r3, [sp, #16]
	ldr	r0, .L982
	ldrh	r1, [r3]
	orr	r2, r2, r1, lsl #10
	str	r2, [r5, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [r5]
	ldr	r3, [sp, #20]
	adds	r2, r2, #1
	beq	.L969
	ldrh	r2, [r7, #8]
	cmp	fp, r2
	bls	.L969
	ldrh	r1, [r4, #4]
	ldrh	r0, [r7]
	cmp	r0, r1
	itt	eq
	ldreq	r1, [r5, #4]
	streq	r1, [r8, r2, lsl #2]
.L969:
	adds	r3, r3, #1
	b	.L965
.L964:
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r3, [sp, #8]
	subs	r2, r2, #1
	ldr	ip, [r3]
.L966:
	sxth	r3, r1
	cmp	r3, r2
	blt	.L968
.L971:
	adds	r6, r6, #1
	b	.L956
.L968:
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
	b	.L966
.L983:
	.align	2
.L982:
	.word	.LANCHOR148
	.word	.LANCHOR115
	.word	.LANCHOR123
	.word	.LANCHOR20
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
	ldr	r3, .L985
	ldr	r0, .L985+4
	ldrh	r3, [r3]
	strh	r3, [r0, #10]	@ movhi
	movw	r3, #61574
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L985+8
	ldrh	r3, [r3]
	strh	r3, [r0, #8]	@ movhi
	ldr	r3, .L985+12
	ldrh	r3, [r3]
	strh	r3, [r0, #6]	@ movhi
	ldr	r3, .L985+16
	ldr	r3, [r3]
	str	r3, [r0, #12]
	ldr	r3, .L985+20
	ldr	r3, [r3]
	str	r3, [r0, #16]
	ldr	r3, .L985+24
	ldr	r3, [r3]
	str	r3, [r0, #20]
	ldr	r3, .L985+28
	ldr	r3, [r3]
	str	r3, [r0, #24]
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L986:
	.align	2
.L985:
	.word	.LANCHOR27
	.word	.LANCHOR158
	.word	.LANCHOR35
	.word	.LANCHOR28
	.word	.LANCHOR36
	.word	.LANCHOR132
	.word	.LANCHOR131
	.word	.LANCHOR133
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
	ldr	r0, .L988
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L989:
	.align	2
.L988:
	.word	.LANCHOR140
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
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
	ldr	r5, .L991
	muls	r4, r0, r4
	ldr	r0, .L991+4
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
.L992:
	.align	2
.L991:
	.word	.LANCHOR55
	.word	.LANCHOR140
	.size	flush_l2p_region, .-flush_l2p_region
	.section	.text.log2phys,"ax",%progbits
	.align	1
	.global	log2phys
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	log2phys, %function
log2phys:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r2
	ldr	r4, .L1006
	mov	r10, r0
	mov	r5, r1
	ldr	r3, .L1006+4
	ldr	r2, [r4]
	ldrh	fp, [r3]
	cmp	r0, r2
	bcc	.L994
	movw	r2, #811
	ldr	r1, .L1006+8
	ldr	r0, .L1006+12
	bl	printf
.L994:
	ldr	r3, [r4]
	cmp	r10, r3
	bcs	.L995
	ldr	r3, .L1006+16
	add	fp, fp, #7
	lsr	r6, r10, fp
	movs	r2, #0
	ldrh	r1, [r3]
	uxth	r6, r6
	ldr	r3, .L1006+20
	ldr	r0, [r3]
	mov	r8, r3
	movs	r3, #12
.L996:
	uxth	r4, r2
	cmp	r4, r1
	bcc	.L1001
	str	r3, [sp, #4]
	bl	select_l2p_ram_region
	ldr	r3, [sp, #4]
	mov	r4, r0
	ldr	r2, [r8]
	muls	r3, r0, r3
	adds	r1, r2, r3
	ldrh	r2, [r2, r3]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1002
	ldr	r3, [r1, #4]
	cmp	r3, #0
	bge	.L1002
	bl	flush_l2p_region
.L1002:
	mov	r1, r4
	mov	r0, r6
	bl	load_l2p_region
	b	.L998
.L995:
	mov	r0, #-1
	cbnz	r7, .L993
	str	r0, [r5]
.L993:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1001:
	adds	r2, r2, #1
	mla	ip, r3, r2, r0
	ldrh	ip, [ip, #-12]
	cmp	ip, r6
	bne	.L996
.L998:
	movs	r0, #1
	ldr	r2, [r8]
	lsl	r0, r0, fp
	movs	r3, #12
	subs	r0, r0, #1
	and	r0, r0, r10
	uxth	r0, r0
	mla	r3, r3, r4, r2
	cbnz	r7, .L999
	ldr	r3, [r3, #8]
	ldr	r3, [r3, r0, lsl #2]
	str	r3, [r5]
.L1000:
	ldr	r2, [r8]
	movs	r3, #12
	mla	r4, r3, r4, r2
	ldr	r3, [r4, #4]
	adds	r2, r3, #1
	beq	.L1004
	adds	r3, r3, #1
	str	r3, [r4, #4]
.L1004:
	movs	r0, #0
	b	.L993
.L999:
	ldr	r1, [r5]
	ldr	r2, [r3, #8]
	str	r1, [r2, r0, lsl #2]
	ldr	r2, [r3, #4]
	orr	r2, r2, #-2147483648
	str	r2, [r3, #4]
	ldr	r3, .L1006+24
	strh	r6, [r3]	@ movhi
	b	.L1000
.L1007:
	.align	2
.L1006:
	.word	.LANCHOR61
	.word	.LANCHOR22
	.word	.LANCHOR159
	.word	.LC1
	.word	.LANCHOR33
	.word	.LANCHOR55
	.word	.LANCHOR56
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
	ldr	r5, .L1018
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r2, [r5]
	mov	r7, r0
	ldrh	r3, [r2, r0, lsl #1]
	cbnz	r3, .L1009
	ldr	r2, .L1018+4
	ldr	r4, [r2]
	cmp	r4, #0
	beq	.L1010
	ldr	r2, .L1018+8
	movw	lr, #65535
	ldr	ip, .L1018+24
	ldr	r0, .L1018+12
	ldr	r2, [r2]
	ldrh	r1, [r0]
	mov	r8, r0
	subs	r4, r4, r2
	asrs	r4, r4, #1
	mul	r4, ip, r4
	mov	ip, #6
	uxth	r4, r4
.L1011:
	uxth	r0, r3
	cmp	r1, r0
	bls	.L1010
	cmp	r4, r7
	bne	.L1012
	mov	r1, r4
	ldr	r0, .L1018+4
	bl	List_remove_node
	ldrh	r3, [r8]
	cbnz	r3, .L1013
	movw	r2, #1699
	ldr	r1, .L1018+16
	ldr	r0, .L1018+20
	bl	printf
.L1013:
	ldrh	r3, [r8]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r8]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r2, [r5]
	ldrh	r3, [r2, r7, lsl #1]
.L1009:
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	b	.L1010
.L1012:
	mul	r4, ip, r4
	adds	r3, r3, #1
	ldrh	r4, [r2, r4]
	cmp	r4, lr
	bne	.L1011
.L1010:
	movs	r2, #1
	add	r1, sp, #4
	mov	r0, r6
	bl	log2phys
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1019:
	.align	2
.L1018:
	.word	.LANCHOR42
	.word	.LANCHOR47
	.word	.LANCHOR40
	.word	.LANCHOR48
	.word	.LANCHOR160
	.word	.LC1
	.word	-1431655765
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
	.section	.text.ftl_check_vpc,"ax",%progbits
	.align	1
	.global	ftl_check_vpc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_check_vpc, %function
ftl_check_vpc:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r6, .L1044
	ldr	r5, .L1044+4
	ldr	r1, .L1044+8
	ldr	r0, .L1044+12
	bl	printf
	mov	r2, #8192
	movs	r1, #0
	ldr	r0, .L1044+4
	bl	ftl_memset
.L1021:
	ldr	r3, [r6]
	cmp	r4, r3
	bcc	.L1023
	ldr	r10, .L1044+48
	movs	r4, #0
	ldr	r7, .L1044+16
	mov	r6, r4
.L1024:
	ldrh	r2, [r10]
	uxth	r3, r4
	cmp	r2, r3
	bhi	.L1026
	ldr	r3, .L1044+20
	ldr	r4, [r3]
	cbz	r4, .L1027
	ldr	r3, .L1044+24
	mov	r8, #0
	ldr	r5, .L1044+28
	ldr	r10, .L1044+16
	ldrh	r7, [r3]
	ldr	r3, [r5]
	ldr	fp, .L1044+4
	subs	r4, r4, r3
	ldr	r3, .L1044+32
	asrs	r4, r4, #1
	muls	r4, r3, r4
	uxth	r4, r4
.L1028:
	uxth	r3, r8
	cmp	r7, r3
	bls	.L1027
	ldr	r3, [r10]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L1029
	movs	r6, #1
	ldrh	r3, [fp, r4, lsl #1]
	mov	r1, r4
	ldr	r0, .L1044+36
	bl	printf
.L1029:
	movs	r3, #6
	ldr	r2, [r5]
	muls	r4, r3, r4
	movw	r3, #65535
	add	r8, r8, #1
	ldrh	r4, [r2, r4]
	cmp	r4, r3
	bne	.L1028
.L1027:
	cbz	r6, .L1020
	movw	r2, #2343
	ldr	r1, .L1044+8
	ldr	r0, .L1044+40
	bl	printf
.L1020:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1023:
	movs	r2, #0
	add	r1, sp, #4
	mov	r0, r4
	bl	log2phys
	ldr	r0, [sp, #4]
	adds	r3, r0, #1
	beq	.L1022
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r5, r0, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r5, r0, lsl #1]	@ movhi
.L1022:
	adds	r4, r4, #1
	b	.L1021
.L1026:
	ldr	r3, [r7]
	uxth	r5, r4
	ldr	r8, .L1044+4
	ldrh	r2, [r3, r5, lsl #1]
	ldrh	r3, [r8, r5, lsl #1]
	cmp	r2, r3
	beq	.L1025
	mov	r1, r5
	ldr	r0, .L1044+44
	bl	printf
	ldr	r3, [r7]
	movw	r2, #65535
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, r2
	beq	.L1025
	ldrh	r2, [r8, r5, lsl #1]
	cmp	r2, r3
	it	hi
	movhi	r6, #1
.L1025:
	adds	r4, r4, #1
	b	.L1024
.L1045:
	.align	2
.L1044:
	.word	.LANCHOR61
	.word	check_vpc_table
	.word	.LANCHOR161
	.word	.LC94
	.word	.LANCHOR42
	.word	.LANCHOR47
	.word	.LANCHOR48
	.word	.LANCHOR40
	.word	-1431655765
	.word	.LC96
	.word	.LC1
	.word	.LC95
	.word	.LANCHOR5
	.size	ftl_check_vpc, .-ftl_check_vpc
	.section	.text.ftl_scan_all_data,"ax",%progbits
	.align	1
	.global	ftl_scan_all_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_scan_all_data, %function
ftl_scan_all_data:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	movs	r5, #0
	ldr	r7, .L1060
	sub	sp, sp, #32
	movs	r1, #0
	ldr	r8, .L1060+24
	ldr	r0, .L1060+4
	bl	printf
.L1047:
	ldr	r3, [r7]
	cmp	r5, r3
	bcc	.L1053
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1053:
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r5
	bl	log2phys
	ubfx	r3, r5, #0, #11
	cbnz	r3, .L1048
	ldr	r2, [sp, #28]
	mov	r1, r5
	mov	r0, r8
	bl	printf
.L1048:
	ldr	r3, [sp, #28]
	adds	r2, r3, #1
	beq	.L1050
	ldr	r4, .L1060+8
	movs	r2, #0
	movs	r1, #1
	str	r3, [r4, #4]
	mov	r0, r4
	ldr	r3, .L1060+12
	str	r5, [r4, #16]
	str	r2, [r4]
	ldr	r3, [r3]
	str	r3, [r4, #8]
	ldr	r3, .L1060+16
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FlashReadPages
	ldr	r3, [r4]
	cmp	r3, #256
	beq	.L1051
	adds	r3, r3, #1
	beq	.L1051
	ldr	r3, [r6, #8]
	cmp	r5, r3
	beq	.L1050
.L1051:
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #12]
	ldr	r0, .L1060+20
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
.L1050:
	adds	r5, r5, #1
	b	.L1047
.L1061:
	.align	2
.L1060:
	.word	.LANCHOR61
	.word	.LC97
	.word	.LANCHOR148
	.word	.LANCHOR115
	.word	.LANCHOR123
	.word	.LC99
	.word	.LC98
	.size	ftl_scan_all_data, .-ftl_scan_all_data
	.section	.text.FtlGcScanTempBlk,"ax",%progbits
	.align	1
	.global	FtlGcScanTempBlk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlGcScanTempBlk, %function
FtlGcScanTempBlk:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1092
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #48
	mov	r4, r0
	str	r1, [sp, #8]
	ldrh	r5, [r3]
	movw	r3, #65535
	cmp	r5, r3
	beq	.L1086
	cbnz	r5, .L1063
.L1064:
	bl	FtlGcPageVarInit
	b	.L1065
.L1086:
	movs	r5, #0
.L1063:
	ldr	r3, .L1092+4
	ldr	r2, [sp, #8]
	ldrh	r3, [r3]
	cmp	r3, r2
	beq	.L1064
.L1065:
	ldr	fp, .L1092+48
	movs	r3, #0
	str	r3, [sp]
.L1066:
	ldrh	r2, [r4]
	movs	r3, #0
	strb	r3, [r4, #8]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1067
.L1083:
	ldr	r3, .L1092+8
	movs	r2, #0
	ldr	r0, [fp]
	mov	r7, r2
	movw	lr, #65535
	mov	r8, #20
	ldrh	r10, [r3]
	ldr	r3, .L1092+12
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1092+16
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L1092+20
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L1092+24
	ldrh	ip, [r3]
	add	r3, r4, #16
	str	r3, [sp, #4]
.L1068:
	uxth	r3, r2
	cmp	r10, r3
	bhi	.L1070
	mov	r10, #0
	movs	r2, #0
	mov	r1, r7
	bl	FlashReadPages
.L1071:
	uxth	r3, r10
	cmp	r7, r3
	bhi	.L1081
	ldr	r3, [sp]
	adds	r5, r5, #1
	uxth	r5, r5
	adds	r3, r3, #1
	str	r3, [sp]
	ldr	r2, [sp]
	ldr	r3, [sp, #8]
	cmp	r3, r2
	ldr	r2, .L1092+4
	bls	.L1082
.L1084:
	ldrh	r3, [r2]
	cmp	r3, r5
	bhi	.L1083
.L1067:
	ldr	r3, .L1092
	movw	r2, #65535
	strh	r5, [r4, #2]	@ movhi
	mov	r1, r5
	mov	r0, r4
	strh	r2, [r3]	@ movhi
	movs	r2, #0
	strb	r2, [r4, #6]
	bl	ftl_sb_update_avl_pages
	b	.L1085
.L1070:
	ldr	r1, [sp, #4]
	ldrh	r3, [r1], #2
	cmp	r3, lr
	str	r1, [sp, #4]
	beq	.L1069
	mla	r1, r8, r7, r0
	ldr	r6, [sp, #12]
	orr	r3, r5, r3, lsl #10
	str	r3, [r1, #4]
	ldr	r3, [sp, #16]
	muls	r3, r7, r3
	bic	r3, r3, #3
	add	r3, r3, r6
	ldr	r6, [sp, #20]
	str	r3, [r1, #8]
	mul	r3, ip, r7
	adds	r7, r7, #1
	uxth	r7, r7
	bic	r3, r3, #3
	add	r3, r3, r6
	str	r3, [r1, #12]
.L1069:
	adds	r2, r2, #1
	b	.L1068
.L1081:
	movs	r3, #20
	ldr	r1, [fp]
	mul	r3, r3, r10
	adds	r2, r1, r3
	ldr	r6, [r1, r3]
	ldr	r0, [r2, #4]
	str	r0, [sp, #4]
	cmp	r6, #0
	bne	.L1072
	ldr	r8, [r2, #12]
	movw	r1, #65535
	ldrh	r2, [r8]
	cmp	r2, r1
	bne	.L1073
	ldr	r3, .L1092+28
	ldrh	r1, [r4]
	str	r2, [sp, #4]
	ldr	r3, [r3]
	strh	r6, [r3, r1, lsl #1]	@ movhi
	ldrh	r0, [r4]
	bl	INSERT_FREE_LIST
	ldr	r2, [sp, #4]
	strh	r2, [r4]	@ movhi
.L1091:
	bl	FtlGcPageVarInit
	movs	r5, #0
	b	.L1066
.L1073:
	mov	r2, r6
	add	r1, sp, #24
	ldr	r0, [r8, #8]
	str	r3, [sp, #12]
	bl	log2phys
	ldr	r2, [r8, #12]
	ldr	r1, [sp, #24]
	ldr	r3, [sp, #12]
	cmp	r2, r1
	beq	.L1075
.L1079:
	ldr	r2, [r8, #8]
	add	r10, r10, #1
	ldr	r1, [sp, #4]
	ldr	r0, [r8, #12]
	bl	FtlGcUpdatePage
	b	.L1071
.L1075:
	str	r3, [sp, #12]
	movs	r1, #1
	ldr	r3, .L1092+32
	add	r0, sp, #28
	str	r2, [sp, #32]
	ldr	r2, [r3]
	str	r2, [sp, #36]
	ldr	r2, .L1092+36
	ldr	r2, [r2]
	str	r2, [sp, #40]
	mov	r2, r6
	bl	FlashReadPages
	ldr	r2, .L1092+40
	ldr	r1, [fp]
	ldr	r3, [sp, #12]
	ldrh	r2, [r2]
	ldr	r0, [sp, #36]
	add	ip, r3, r1
	lsls	r2, r2, #7
.L1076:
	cmp	r6, r2
	beq	.L1079
	ldr	r1, [ip, #8]
	ldr	r3, [r0, r6, lsl #2]
	ldr	r1, [r1, r6, lsl #2]
	cmp	r1, r3
	beq	.L1077
	ldr	r2, [sp, #32]
	ldrh	r1, [r4]
	ldr	r0, .L1092+44
	bl	printf
.L1072:
	ldr	r3, .L1092+28
	movs	r1, #0
	ldrh	r2, [r4]
	ldr	r3, [r3]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r4]
	bl	INSERT_FREE_LIST
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
	b	.L1091
.L1077:
	adds	r6, r6, #1
	b	.L1076
.L1082:
	ldr	r1, .L1092
	movw	r0, #65535
	ldrh	r3, [r1]
	cmp	r3, r0
	beq	.L1084
	ldr	r0, [sp]
	add	r3, r3, r0
	strh	r3, [r1]	@ movhi
	ldrh	r3, [r2]
	cmp	r3, r5
	bls	.L1084
.L1085:
	mov	r0, #-1
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1093:
	.align	2
.L1092:
	.word	.LANCHOR162
	.word	.LANCHOR19
	.word	.LANCHOR3
	.word	.LANCHOR91
	.word	.LANCHOR23
	.word	.LANCHOR92
	.word	.LANCHOR24
	.word	.LANCHOR42
	.word	.LANCHOR119
	.word	.LANCHOR124
	.word	.LANCHOR12
	.word	.LC100
	.word	.LANCHOR112
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
	.section	.text.FtlReadRefresh,"ax",%progbits
	.align	1
	.global	FtlReadRefresh
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlReadRefresh, %function
FtlReadRefresh:
	@ args = 0, pretend = 0, frame = 88
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1107
	push	{r4, r5, r6, lr}
	sub	sp, sp, #88
	mov	r4, r3
	ldr	r0, [r3, #80]
	cmp	r0, #0
	beq	.L1095
	ldr	r6, .L1107+4
	ldr	r0, [r3, #84]
	ldr	r1, [r6]
	cmp	r0, r1
	bcs	.L1096
	mov	r5, #2048
.L1101:
	ldr	r0, [r4, #84]
	ldr	r3, [r6]
	cmp	r0, r3
	bcs	.L1098
	movs	r2, #0
	mov	r1, sp
	bl	log2phys
	ldr	r2, [sp]
	ldr	r3, [r4, #84]
	adds	r1, r2, #1
	add	r3, r3, #1
	str	r3, [r4, #84]
	beq	.L1099
	str	r3, [sp, #20]
	add	r0, sp, #88
	ldr	r3, .L1107+8
	movs	r1, #1
	str	r2, [sp, #8]
	movs	r2, #0
	str	r2, [r0, #-84]!
	ldr	r3, [r3]
	str	r3, [sp, #12]
	add	r3, sp, #24
	str	r3, [sp, #16]
	bl	FlashReadPages
	ldr	r3, [sp, #4]
	cmp	r3, #256
	bne	.L1098
	ldr	r0, [sp]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
.L1098:
	mov	r0, #-1
.L1094:
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, pc}
.L1099:
	subs	r5, r5, #1
	bne	.L1101
	b	.L1098
.L1096:
	ldr	r2, .L1107+12
	movs	r0, #0
	str	r0, [r3, #80]
	str	r0, [r3, #84]
	ldr	r2, [r2]
	str	r2, [r3, #76]
	b	.L1094
.L1095:
	ldr	r1, [r3, #76]
	ldr	r3, .L1107+12
	ldr	r5, [r3]
	add	r3, r5, #1048576
	cmp	r1, r3
	bhi	.L1104
	ldr	r3, .L1107+16
	ldr	r2, [r3]
	mov	r3, #33554432
	lsrs	r2, r2, #10
	asrs	r3, r3, r2
	add	r3, r3, r1
	cmp	r5, r3
	bhi	.L1104
	ldr	r3, .L1107+20
	ldrb	r3, [r3, #28]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1094
.L1104:
	movs	r3, #1
	movs	r0, #0
	str	r3, [r4, #80]
	str	r0, [r4, #84]
	str	r5, [r4, #76]
	b	.L1094
.L1108:
	.align	2
.L1107:
	.word	.LANCHOR81
	.word	.LANCHOR61
	.word	.LANCHOR121
	.word	.LANCHOR62
	.word	.LANCHOR76
	.word	.LANCHOR39
	.size	FtlReadRefresh, .-FtlReadRefresh
	.section	.text.FtlMapBlkWriteDump_data,"ax",%progbits
	.align	1
	.global	FtlMapBlkWriteDump_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlMapBlkWriteDump_data, %function
FtlMapBlkWriteDump_data:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, [r0, #36]
	push	{r4, r5, r6, lr}
	mov	r6, r0
	cbz	r3, .L1109
	ldrh	r5, [r0, #6]
	movs	r3, #0
	ldr	r2, [r0, #24]
	str	r3, [r0, #36]
	subs	r5, r5, #1
	ldr	r3, .L1113
	ldr	r1, .L1113+4
	uxth	r5, r5
	ldr	r4, .L1113+8
	ldr	r2, [r2, r5, lsl #2]
	ldr	r0, [r3]
	ldr	r1, [r1]
	str	r2, [r4, #4]
	str	r0, [r4, #8]
	str	r1, [r4, #12]
	cbz	r2, .L1111
	movs	r2, #1
	mov	r0, r4
	mov	r1, r2
	bl	FlashReadPages
.L1112:
	ldr	r2, [r4, #8]
	mov	r1, r5
	mov	r0, r6
	pop	{r4, r5, r6, lr}
	b	FtlMapWritePage
.L1111:
	ldr	r3, .L1113+12
	movs	r1, #255
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L1112
.L1109:
	pop	{r4, r5, r6, pc}
.L1114:
	.align	2
.L1113:
	.word	.LANCHOR116
	.word	.LANCHOR123
	.word	.LANCHOR148
	.word	.LANCHOR23
	.size	FtlMapBlkWriteDump_data, .-FtlMapBlkWriteDump_data
	.section	.text.FlashTestBlk,"ax",%progbits
	.align	1
	.global	FlashTestBlk
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashTestBlk, %function
FlashTestBlk:
	@ args = 0, pretend = 0, frame = 88
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r0, #11
	push	{r4, r5, lr}
	mov	r4, r0
	sub	sp, sp, #92
	bls	.L1117
	ldr	r5, .L1118
	add	r0, sp, #24
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
.L1115:
	mov	r0, r4
	add	sp, sp, #92
	@ sp needed
	pop	{r4, r5, pc}
.L1117:
	movs	r4, #0
	b	.L1115
.L1119:
	.align	2
.L1118:
	.word	.LANCHOR121
	.size	FlashTestBlk, .-FlashTestBlk
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
	movs	r4, #0
	ldr	r7, .L1129
	movs	r1, #0
	ldr	r5, .L1129+4
	ldr	r3, [r7]
	mov	fp, r7
	ldr	r8, .L1129+48
	ldr	r6, .L1129+8
	str	r3, [r5, #12]
	ldr	r7, .L1129+12
	ldr	r3, .L1129+16
	ldr	r10, .L1129+52
	ldr	r0, [r8]
	ldrh	r2, [r3]
	str	r0, [r5, #8]
	bl	ftl_memset
.L1121:
	ldrh	r3, [r7]
	cmp	r4, r3
	blt	.L1122
	ldr	r6, [r5, #12]
	movs	r2, #16
	ldr	r4, .L1129+20
	movs	r1, #255
	movs	r7, #0
	mov	r0, r6
	bl	ftl_memset
	movw	r3, #61649
	mov	r10, r4
	strh	r3, [r6]	@ movhi
	ldr	r3, [r4, #8]
	str	r7, [sp, #12]
	str	r3, [r6, #4]
	ldrh	r3, [r4]
	strh	r3, [r6, #2]	@ movhi
	ldrh	r3, [r4, #4]
	strh	r3, [r6, #8]	@ movhi
	ldrh	r3, [r4, #6]
	strh	r3, [r6, #10]	@ movhi
	ldr	r3, .L1129+24
	ldr	r3, [r3]
	strh	r3, [r6, #12]	@ movhi
.L1123:
	ldr	r3, [r8]
	ldrh	r2, [r4, #2]
	ldrh	r1, [r4]
	str	r3, [r5, #8]
	ldr	r3, [fp]
	ldrh	r0, [r6, #10]
	str	r3, [r5, #12]
	movs	r3, #0
	str	r3, [r5]
	orr	r3, r2, r1, lsl #10
	str	r3, [r5, #4]
	ldrh	r3, [r4, #4]
	str	r0, [sp]
	ldr	r0, .L1129+28
	bl	printf
	ldr	r3, .L1129+32
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1124
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
	ldr	r2, .L1129+36
	strh	r3, [r4]	@ movhi
	lsls	r3, r3, #10
	ldr	r0, [r2]
	movs	r2, #1
	str	r3, [r5, #4]
	mov	r1, r2
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
.L1124:
	movs	r3, #1
	ldr	r0, .L1129+4
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r10, #2]
	adds	r3, r3, #1
	strh	r3, [r10, #2]	@ movhi
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L1125
	adds	r7, r7, #1
	ldr	r1, [r5, #4]
	uxth	r7, r7
	ldr	r0, .L1129+40
	bl	printf
	cmp	r7, #3
	bls	.L1123
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L1129+44
	bl	printf
.L1127:
	b	.L1127
.L1122:
	ldrh	r2, [r10]
	ldr	r3, [r5, #8]
	ldr	r1, [r6, #4]!
	mul	r0, r2, r4
	lsls	r2, r2, #2
	adds	r4, r4, #1
	add	r0, r3, r0, lsl #2
	bl	ftl_memcpy
	b	.L1121
.L1128:
	movs	r3, #1
	str	r3, [sp, #12]
	b	.L1123
.L1125:
	ldr	r3, [sp, #12]
	cmp	r3, #0
	beq	.L1128
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1130:
	.align	2
.L1129:
	.word	.LANCHOR123
	.word	.LANCHOR148
	.word	.LANCHOR37+24
	.word	.LANCHOR10
	.word	.LANCHOR23
	.word	.LANCHOR37
	.word	.LANCHOR2
	.word	.LC101
	.word	.LANCHOR20
	.word	.LANCHOR106
	.word	.LC102
	.word	.LC103
	.word	.LANCHOR115
	.word	.LANCHOR137
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
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
.L1132:
	ldr	r3, .L1171
	ldr	r8, .L1171+68
	ldrh	r3, [r3]
	ldr	r10, .L1171+72
	ldrh	r2, [r8]
	add	r3, r3, r2
	ldrh	r2, [r10]
	cmp	r3, r2
	ble	.L1133
	movw	r2, #2615
	ldr	r1, .L1171+4
	ldr	r0, .L1171+8
	bl	printf
.L1133:
	ldr	r3, .L1171+12
	cmp	r4, r3
	bne	.L1159
	ldr	r3, .L1171
	ldr	r2, .L1171+16
	ldrh	r3, [r3]
	ldr	r2, [r2]
	lsrs	r1, r3, #1
	muls	r2, r3, r2
	adds	r1, r1, #1
	add	r1, r1, r2, lsr #2
	uxth	r1, r1
	cbz	r1, .L1134
	subs	r1, r1, #1
	uxth	r1, r1
.L1134:
	ldr	r0, .L1171+20
	bl	List_pop_index_node
	ldr	r3, .L1171
	mov	r5, r0
	uxth	r7, r0
	ldrh	r3, [r3]
	cbnz	r3, .L1135
	mov	r2, #2624
	ldr	r1, .L1171+4
	ldr	r0, .L1171+8
	bl	printf
.L1135:
	ldr	r3, .L1171
	ldr	r2, .L1171
	ldrh	r3, [r3]
	subs	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldrh	r3, [r10]
	cmp	r3, r7
	bls	.L1132
	uxth	r5, r5
	lsls	r3, r5, #1
	str	r3, [sp]
	ldr	r3, .L1171+24
	ldr	r3, [r3]
	ldrh	r6, [r3, r5, lsl #1]
	cmp	r6, #0
	bne	.L1132
	strh	r7, [r4]	@ movhi
	mov	r0, r4
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1137
	ldr	r3, .L1171+24
	movw	r2, #65535
	mov	r0, r7
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r3, .L1171
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r10]
	cmp	r3, r2
	ble	.L1132
	movw	r2, #2638
	ldr	r1, .L1171+4
	ldr	r0, .L1171+8
	bl	printf
	b	.L1132
.L1159:
	movs	r1, #0
	b	.L1134
.L1137:
	ldr	r3, .L1171
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r10]
	cmp	r3, r2
	ble	.L1139
	movw	r2, #2641
	ldr	r1, .L1171+4
	ldr	r0, .L1171+8
	bl	printf
.L1139:
	ldr	r3, .L1171+28
	add	lr, r4, #16
	ldr	r2, .L1171+32
	mov	r8, #0
	ldr	ip, [r3]
	ldrh	r0, [r2]
	movs	r2, #20
	mov	r3, ip
	mla	r0, r2, r0, ip
.L1140:
	cmp	r0, r3
	bne	.L1142
	cbnz	r6, .L1143
	movw	r2, #2652
	ldr	r1, .L1171+4
	ldr	r0, .L1171+8
	bl	printf
.L1143:
	ldr	r3, .L1171+36
	ldrh	r3, [r3]
	cmp	r3, r7
	bne	.L1144
	movw	r2, #2654
	ldr	r1, .L1171+4
	ldr	r0, .L1171+8
	bl	printf
.L1144:
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	ldr	r3, .L1171+40
	ldr	fp, .L1171+76
	ldr	r8, .L1171+80
	ldr	r1, [r3]
	cmp	r2, #0
	bne	.L1145
	ldrh	r2, [r1, r5, lsl #1]
	cmp	r2, #0
	beq	.L1146
	ldr	r0, .L1171+44
	ldrh	r0, [r0]
	add	r2, r2, r0
.L1169:
	strh	r2, [r1, r5, lsl #1]	@ movhi
	mov	r0, r7
	ldr	r2, [fp]
	movs	r1, #0
	str	r3, [sp, #4]
	adds	r2, r2, #1
	str	r2, [fp]
	bl	ftl_set_blk_mode
.L1170:
	ldr	r3, [sp, #4]
	ldr	r0, [fp]
	ldr	r3, [r3]
	ldrh	r1, [r3, r5, lsl #1]
	ldr	r3, .L1171+48
	ldr	r2, [r3]
	cmp	r1, r2
	it	hi
	strhi	r1, [r3]
	ldr	r3, .L1171+44
	ldrh	r1, [r10]
	ldrh	r2, [r3]
	ldr	r3, [r8]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L1171+52
	ldr	ip, .L1171+84
	str	r0, [r3]
	ldr	r3, .L1171+56
	ldr	r2, [r3]
	ldr	r3, [r2, #16]
	adds	r3, r3, #1
	str	r3, [r2, #16]
	movs	r2, #20
	ldr	r3, .L1171+28
	ldr	r0, [r3]
	adds	r3, r0, #4
	mla	r2, r2, r6, r0
	adds	r2, r2, #24
.L1150:
	adds	r3, r3, #20
	cmp	r2, r3
	bne	.L1151
	mov	r2, r6
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	mov	r8, #0
	bl	FlashEraseBlocks
	mov	r10, r8
	movs	r3, #20
.L1152:
	uxth	r2, r8
	cmp	r6, r2
	bhi	.L1154
	cmp	r10, #0
	beq	.L1155
	mov	r0, r7
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1155:
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L1156
	ldr	r3, .L1171+24
	movw	r2, #65535
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	b	.L1132
.L1142:
	ldrh	r1, [lr], #2
	movw	fp, #65535
	str	r8, [r3, #8]
	str	r8, [r3, #12]
	cmp	r1, fp
	beq	.L1141
	mla	fp, r2, r6, ip
	adds	r6, r6, #1
	lsls	r1, r1, #10
	uxth	r6, r6
	str	r1, [fp, #4]
.L1141:
	adds	r3, r3, #20
	b	.L1140
.L1146:
	movs	r2, #2
	b	.L1169
.L1145:
	ldrh	r2, [r1, r5, lsl #1]
	mov	r0, r7
	str	r3, [sp, #4]
	adds	r2, r2, #1
	strh	r2, [r1, r5, lsl #1]	@ movhi
	ldr	r2, [r8]
	adds	r2, r2, #1
	str	r2, [r8]
	bl	ftl_set_blk_mode.part.6
	b	.L1170
.L1151:
	ldr	r1, [r3, #-20]
	and	r1, r1, ip
	str	r1, [r3, #-20]
	b	.L1150
.L1154:
	ldr	r1, .L1171+28
	mul	r2, r3, r8
	ldr	r1, [r1]
	ldr	fp, [r1, r2]
	adds	r0, r1, r2
	cmp	fp, #-1
	bne	.L1153
	ldr	r0, [r0, #4]
	add	r10, r10, #1
	str	r3, [sp, #4]
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
	add	r2, r4, r8, lsl #1
	ldr	r3, [sp, #4]
	strh	fp, [r2, #16]	@ movhi
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	subs	r2, r2, #1
	strb	r2, [r4, #7]
.L1153:
	add	r8, r8, #1
	b	.L1152
.L1156:
	ldr	r3, .L1171+60
	ldr	r1, .L1171+64
	ldrh	r3, [r3]
	strh	r7, [r4]	@ movhi
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
	ldr	r2, .L1171+24
	ldr	r1, [sp]
	ldr	r2, [r2]
	strh	r3, [r2, r1]	@ movhi
	ldrh	r3, [r4, #4]
	cbz	r3, .L1157
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1158
.L1157:
	movw	r2, #2707
	ldr	r1, .L1171+4
	ldr	r0, .L1171+8
	bl	printf
.L1158:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1172:
	.align	2
.L1171:
	.word	.LANCHOR48
	.word	.LANCHOR163
	.word	.LC1
	.word	.LANCHOR53
	.word	.LANCHOR87
	.word	.LANCHOR47
	.word	.LANCHOR42
	.word	.LANCHOR106
	.word	.LANCHOR3
	.word	.LANCHOR80
	.word	.LANCHOR43
	.word	.LANCHOR14
	.word	.LANCHOR76
	.word	.LANCHOR74
	.word	.LANCHOR127
	.word	.LANCHOR19
	.word	.LANCHOR70
	.word	.LANCHOR45
	.word	.LANCHOR5
	.word	.LANCHOR72
	.word	.LANCHOR73
	.word	-1024
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
	ldr	r4, .L1185
	ldrh	r3, [r4]
	cbz	r3, .L1174
	ldr	r8, .L1185+16
	movs	r6, #0
.L1175:
	ldr	r3, .L1185+4
	ldrh	r2, [r3]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L1181
	bl	FtlGcReFreshBadBlk
.L1174:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1181:
	ldr	r2, .L1185+8
	uxth	r3, r6
	mov	r1, r10
	movs	r7, #0
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r2, .L1185+12
	mov	fp, r0
.L1176:
	ldrh	r3, [r4]
	uxth	r5, r7
	cmp	r3, r5
	bhi	.L1180
	adds	r6, r6, #1
	b	.L1175
.L1180:
	uxth	r3, r7
	ldrh	r1, [r8, r3, lsl #1]
	cmp	r1, fp
	bne	.L1177
	mov	r1, fp
	mov	r0, r2
	str	r3, [sp, #4]
	str	r2, [sp]
	bl	printf
	mov	r0, fp
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldr	r3, [sp, #4]
	ldrh	r1, [r4]
	ldr	r2, [sp]
	add	r3, r8, r3, lsl #1
.L1178:
	cmp	r5, r1
	bcc	.L1179
	subs	r1, r1, #1
	strh	r1, [r4]	@ movhi
.L1177:
	adds	r7, r7, #1
	b	.L1176
.L1179:
	ldrh	r0, [r3, #2]!
	adds	r5, r5, #1
	uxth	r5, r5
	strh	r0, [r3, #-2]	@ movhi
	b	.L1178
.L1186:
	.align	2
.L1185:
	.word	.LANCHOR101
	.word	.LANCHOR3
	.word	.LANCHOR13
	.word	.LC104
	.word	.LANCHOR102
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
	ldr	r3, .L1197
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	bne	.L1188
	ldr	r2, .L1197+4
	ldrh	r1, [r2]
	cmp	r1, r0
	bne	.L1189
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L1190:
	ldr	r5, .L1197+8
	mov	r1, r4
	ldr	r0, .L1197+12
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L1192
	movw	r2, #2777
	ldr	r1, .L1197+16
	ldr	r0, .L1197+20
	bl	printf
.L1192:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	free_data_superblock
	mov	r0, r4
	bl	FtlGcFreeBadSuperBlk
	ldr	r3, .L1197+24
	ldrh	r2, [r5]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldr	r2, .L1197+28
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1196
	movw	r2, #2780
	ldr	r1, .L1197+16
	ldr	r0, .L1197+20
	bl	printf
.L1196:
	movs	r3, #1
	b	.L1187
.L1189:
	ldr	r2, .L1197+32
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1187
	ldr	r2, .L1197+36
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1187
	ldr	r2, .L1197+40
	ldrh	r2, [r2]
	cmp	r2, r0
	bne	.L1190
.L1187:
	mov	r0, r3
	pop	{r3, r4, r5, pc}
.L1188:
	bl	List_update_data_list
	movs	r3, #0
	b	.L1187
.L1198:
	.align	2
.L1197:
	.word	.LANCHOR42
	.word	.LANCHOR80
	.word	.LANCHOR45
	.word	.LANCHOR41
	.word	.LANCHOR164
	.word	.LC1
	.word	.LANCHOR48
	.word	.LANCHOR5
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR53
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
	beq	.L1200
	ldr	r5, .L1208
	ldr	r3, [r5]
	ldrh	r2, [r3, r0, lsl #1]
	cbnz	r2, .L1201
	mov	r1, r0
	ldr	r0, .L1208+4
	bl	printf
	ldr	r3, [r5]
	ldrh	r5, [r3, r4, lsl #1]
	cbz	r5, .L1202
.L1206:
	movs	r5, #0
.L1199:
	mov	r0, r5
	pop	{r4, r5, r6, pc}
.L1202:
	movw	r2, #2795
.L1207:
	ldr	r1, .L1208+8
	ldr	r0, .L1208+12
	bl	printf
	b	.L1199
.L1201:
	subs	r2, r2, #1
	strh	r2, [r3, r0, lsl #1]	@ movhi
.L1200:
	ldr	r6, .L1208+16
	movw	r3, #65535
	ldrh	r0, [r6]
	cmp	r0, r3
	bne	.L1204
	strh	r4, [r6]	@ movhi
	b	.L1206
.L1204:
	cmp	r4, r0
	beq	.L1206
	bl	update_vpc_list
	ldr	r3, .L1208+20
	adds	r5, r0, #0
	ldr	r2, .L1208+24
	it	ne
	movne	r5, #1
	strh	r4, [r6]	@ movhi
	ldr	r3, [r3]
	ldr	r2, [r2]
	subs	r3, r3, r2
	asrs	r2, r3, #1
	ldr	r3, .L1208+28
	muls	r3, r2, r3
	ldr	r2, .L1208
	ldr	r2, [r2]
	uxth	r1, r3
	ldrh	r2, [r2, r1, lsl #1]
	cmp	r2, #0
	bne	.L1199
	cmp	r4, r1
	beq	.L1199
	movw	r2, #2811
	b	.L1207
.L1209:
	.align	2
.L1208:
	.word	.LANCHOR42
	.word	.LC105
	.word	.LANCHOR165
	.word	.LC1
	.word	.LANCHOR142
	.word	.LANCHOR41
	.word	.LANCHOR40
	.word	-1431655765
	.size	decrement_vpc_count, .-decrement_vpc_count
	.section	.text.FtlRecoverySuperblock,"ax",%progbits
	.align	1
	.global	FtlRecoverySuperblock
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlRecoverySuperblock, %function
FtlRecoverySuperblock:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r3, [r0]
	movw	r2, #65535
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r0
	sub	sp, sp, #48
	cmp	r3, r2
	beq	.L1338
	ldrh	r3, [r0, #2]
	str	r3, [sp, #4]
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #20]
	ldr	r3, .L1346
	ldrh	r3, [r3]
	cmp	r3, r1
	mov	r3, #0
	bne	.L1213
	strh	r3, [r0, #4]	@ movhi
.L1344:
	strb	r3, [r8, #6]
.L1338:
	movs	r0, #0
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1213:
	ldrh	r0, [r0, #16]
.L1214:
	cmp	r0, r2
	uxth	r5, r3
	add	r3, r3, #1
	beq	.L1215
	movs	r1, #1
	bl	FtlGetLastWrittenPage
	mov	r4, r0
	adds	r0, r0, #1
	beq	.L1216
	ldr	r3, .L1346+4
	movs	r2, #0
	mov	r5, r2
	movw	fp, #65535
	mov	r10, #20
	ldrh	ip, [r3]
	ldr	r3, .L1346+8
	ldr	r0, [r3]
	ldr	r3, .L1346+12
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1346+16
	ldrh	r7, [r3]
	ldr	r3, .L1346+20
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1346+24
	ldrh	lr, [r3]
	add	r3, r8, #16
	str	r3, [sp, #16]
	str	r3, [sp]
.L1217:
	uxth	r3, r2
	cmp	ip, r3
	bhi	.L1221
	movs	r2, #0
	mov	r1, r5
	bl	FlashReadPages
	ldr	r2, .L1346+28
	uxth	r1, r4
	movw	fp, #65535
	str	r1, [sp, #12]
	ldr	r3, [r2]
	subs	r3, r3, #1
	str	r3, [sp]
	ldr	r3, .L1346+8
	ldr	r10, [r3]
	movs	r3, #0
	mov	r7, r10
.L1222:
	uxth	r1, r3
	cmp	r5, r1
	bhi	.L1227
	bne	.L1225
	adds	r3, r4, #1
	uxth	r3, r3
	str	r3, [sp, #8]
.L1339:
	ldr	r0, [r10, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_plane
	ldr	r3, .L1346
	mov	r10, r0
	ldr	r2, [sp, #8]
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L1229
	ldrh	r3, [sp, #8]
	strh	r3, [r8, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r8, #6]
	strh	r3, [r8, #4]	@ movhi
.L1229:
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #4]
	cmp	r3, r2
	bne	.L1230
	ldr	r3, [sp, #20]
	cmp	r10, r3
	bne	.L1230
	ldr	r1, [sp, #8]
	mov	r2, r10
.L1345:
	mov	r0, r8
	bl	ftl_sb_update_avl_pages
	b	.L1338
.L1215:
	uxth	r1, r3
	adds	r1, r1, #8
	ldrh	r0, [r8, r1, lsl #1]
	b	.L1214
.L1216:
	ldr	r3, [sp, #4]
	cbz	r3, .L1218
	movw	r2, #1766
	ldr	r1, .L1346+32
	ldr	r0, .L1346+36
	bl	printf
.L1218:
	ldr	r3, [sp, #20]
	cbz	r3, .L1219
	cmp	r5, r3
	beq	.L1219
	movw	r2, #1767
	ldr	r1, .L1346+32
	ldr	r0, .L1346+36
	bl	printf
.L1219:
	movs	r3, #0
	strh	r3, [r8, #2]	@ movhi
	b	.L1344
.L1221:
	ldr	r1, [sp]
	ldrh	r3, [r1], #2
	cmp	r3, fp
	str	r1, [sp]
	beq	.L1220
	mla	r1, r10, r5, r0
	ldr	r6, [sp, #8]
	orr	r3, r4, r3, lsl #10
	str	r3, [r1, #4]
	mul	r3, r7, r5
	bic	r3, r3, #3
	add	r3, r3, r6
	ldr	r6, [sp, #12]
	str	r3, [r1, #8]
	mul	r3, lr, r5
	adds	r5, r5, #1
	uxth	r5, r5
	bic	r3, r3, #3
	add	r3, r3, r6
	str	r3, [r1, #12]
.L1220:
	adds	r2, r2, #1
	b	.L1217
.L1227:
	ldr	r1, [r7]
	cbnz	r1, .L1223
	ldr	r1, [r7, #12]
	ldr	r6, [r1, #4]
	str	r1, [sp, #8]
	adds	r1, r6, #1
	beq	.L1224
	ldr	r1, [r2]
	mov	r0, r6
	bl	ftl_cmp_data_ver
	cbz	r0, .L1224
	adds	r6, r6, #1
	str	r6, [r2]
.L1224:
	ldr	r1, [sp, #8]
	ldr	r1, [r1]
	adds	r1, r1, #1
	bne	.L1226
.L1225:
	uxth	r2, r4
	uxth	r3, r3
	str	r2, [sp, #8]
	movs	r2, #20
	mla	r10, r2, r3, r10
	b	.L1339
.L1223:
	ldr	fp, [sp, #12]
.L1226:
	adds	r3, r3, #1
	adds	r7, r7, #20
	b	.L1222
.L1230:
	movw	r3, #65535
	cmp	fp, r3
	bne	.L1231
	ldrb	r3, [r8, #8]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1232
.L1231:
	ldr	r3, .L1346+40
	uxth	r6, r4
	uxth	r4, r4
	ldr	r7, .L1346+8
	ldr	r2, [r3]
	adds	r2, r2, #1
	itt	eq
	ldreq	r2, [sp]
	streq	r2, [r3]
	ldr	r3, [sp, #4]
	adds	r3, r3, #7
	cmp	r4, r3
	itet	gt
	subgt	r4, r6, #7
	ldrle	r4, [sp, #4]
	uxthgt	r4, r4
.L1235:
	cmp	r4, r6
	bhi	.L1245
	ldr	r3, .L1346+4
	movw	lr, #65535
	ldr	r0, [r7]
	mov	ip, #20
	ldrh	fp, [r3]
	ldr	r3, [sp, #16]
	str	r3, [sp, #12]
	movs	r3, #0
	mov	r5, r3
	b	.L1246
.L1237:
	ldr	r1, [sp, #12]
	ldrh	r2, [r1], #2
	cmp	r2, lr
	str	r1, [sp, #12]
	beq	.L1236
	mla	r1, ip, r5, r0
	adds	r5, r5, #1
	orr	r2, r4, r2, lsl #10
	uxth	r5, r5
	str	r2, [r1, #4]
.L1236:
	adds	r3, r3, #1
.L1246:
	uxth	r2, r3
	cmp	fp, r2
	bhi	.L1237
	mov	r1, r5
	movs	r2, #0
	bl	FlashReadPages
	ldr	r3, .L1346+40
	movs	r1, #20
	movs	r0, #0
	movw	ip, #65535
	ldr	r2, [r3]
	ldr	r3, [r7]
	mla	r5, r1, r5, r3
.L1238:
	cmp	r5, r3
	bne	.L1243
	cbz	r0, .L1244
	ldr	r3, .L1346+40
	str	r2, [r3]
.L1244:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L1235
.L1347:
	.align	2
.L1346:
	.word	.LANCHOR19
	.word	.LANCHOR3
	.word	.LANCHOR112
	.word	.LANCHOR91
	.word	.LANCHOR23
	.word	.LANCHOR92
	.word	.LANCHOR24
	.word	.LANCHOR71
	.word	.LANCHOR166
	.word	.LC1
	.word	.LANCHOR145
.L1243:
	ldr	r1, [r3]
	cmp	r1, #0
	beq	.L1239
	cbz	r0, .L1232
.L1340:
	ldr	r3, .L1348
	str	r2, [r3]
.L1232:
	ldr	fp, [sp, #4]
	movs	r2, #1
	ldr	r6, .L1348+4
	ldr	r3, .L1348+8
	strh	r2, [r3]	@ movhi
.L1247:
	ldr	r3, .L1348+12
	movw	lr, #65535
	ldr	r0, [r6]
	movs	r7, #20
	ldr	r1, [sp, #16]
	ldrh	r4, [r3]
	movs	r3, #0
	str	r3, [sp, #12]
.L1248:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L1250
	movs	r2, #0
	ldr	r1, [sp, #12]
	bl	FlashReadPages
	movs	r3, #0
.L1343:
	str	r3, [sp, #24]
	ldr	r2, [sp, #12]
	ldrh	r3, [sp, #24]
	cmp	r2, r3
	bhi	.L1278
	ldr	r3, .L1348+16
	add	fp, fp, #1
	uxth	fp, fp
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L1247
	ldr	r2, .L1348+12
	movw	r0, #65535
	movs	r3, #0
	strh	fp, [r8, #2]	@ movhi
	strh	r3, [r8, #4]	@ movhi
	ldrh	r2, [r2]
.L1279:
	uxth	r1, r3
	cmp	r1, r2
	bcs	.L1338
	ldr	r1, [sp, #16]
	ldrh	r4, [r1], #2
	cmp	r4, r0
	str	r1, [sp, #16]
	add	r1, r3, #1
	bne	.L1344
	mov	r3, r1
	b	.L1279
.L1239:
	ldr	r1, [r3, #12]
	ldrh	lr, [r1]
	cmp	lr, ip
	beq	.L1242
	ldr	r1, [r1, #4]
	cmp	r1, #-1
	itt	ne
	movne	r2, r1
	movne	r0, #1
.L1242:
	adds	r3, r3, #20
	b	.L1238
.L1245:
	mov	r2, #-1
	b	.L1340
.L1250:
	ldrh	r2, [r1], #2
	cmp	r2, lr
	beq	.L1249
	ldr	r5, [sp, #12]
	orr	r2, fp, r2, lsl #10
	mla	ip, r7, r5, r0
	str	r2, [ip, #4]
	mov	r2, r5
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #12]
.L1249:
	adds	r3, r3, #1
	b	.L1248
.L1278:
	ldr	r3, [sp, #24]
	movs	r5, #20
	muls	r5, r3, r5
	ldr	r3, [r6]
	str	r3, [sp, #28]
	adds	r7, r3, r5
	ldr	r4, [r7, #4]
	ubfx	r0, r4, #10, #16
	str	r4, [sp, #44]
	bl	P2V_plane
	ldr	r3, [sp, #4]
	cmp	fp, r3
	bcc	.L1252
	ldr	r3, [sp, #28]
	bne	.L1253
	ldr	r2, [sp, #20]
	cmp	r2, r0
	bhi	.L1252
.L1253:
	ldr	r2, [sp, #8]
	cmp	fp, r2
	bne	.L1254
	cmp	r10, r0
	beq	.L1255
.L1254:
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L1256
	ldr	r3, [r7, #12]
	movw	r2, #61589
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L1257
	ldrh	r0, [r8]
.L1341:
	bl	decrement_vpc_count
	b	.L1252
.L1257:
	ldr	r2, [r3, #4]
	str	r2, [sp]
	adds	r2, r2, #1
	beq	.L1258
	ldr	r2, .L1348+20
	ldr	r0, [sp]
	ldr	r1, [r2]
	bl	ftl_cmp_data_ver
	cbz	r0, .L1258
	ldr	r1, [sp]
	adds	r1, r1, #1
	str	r1, [r2]
.L1258:
	ldr	r4, [r3, #8]
	add	r1, sp, #40
	ldr	r3, [r3, #12]
	movs	r2, #0
	mov	r0, r4
	str	r3, [sp, #36]
	bl	log2phys
	ldr	r3, .L1348
	ldr	r1, [r3]
	adds	r3, r1, #1
	beq	.L1259
	ldr	r0, [sp]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1259
	ldr	r3, [sp, #36]
	adds	r7, r3, #1
	beq	.L1260
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
	bne	.L1261
.L1262:
	mov	r3, #-1
	str	r3, [sp, #36]
.L1269:
	ldr	r7, [sp, #36]
	adds	r0, r7, #1
	beq	.L1252
.L1282:
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1348+24
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L1274
	movw	r2, #2019
	ldr	r1, .L1348+28
	ldr	r0, .L1348+32
	bl	printf
.L1274:
	ldr	r3, .L1348+36
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, #0
	beq	.L1275
	mov	r0, r4
	b	.L1341
.L1260:
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #40]
	cmp	r2, r3
	bne	.L1252
	movs	r2, #1
	add	r1, sp, #36
	mov	r0, r4
	bl	log2phys
.L1252:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	b	.L1343
.L1261:
	ldr	r1, [r7, #8]
	cmp	r4, r1
	bne	.L1262
	ldr	r0, .L1348
	ldr	r1, [r7, #4]
	ldr	r0, [r0]
	str	r1, [sp, #28]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1262
	ldr	r1, [sp, #40]
	ldr	r0, [sp, #44]
	cmp	r1, r0
	bne	.L1264
.L1267:
	ldr	r1, [sp, #36]
	mov	r0, r4
	bl	FtlReUsePrevPpa
	b	.L1262
.L1264:
	ldr	r0, [sp, #36]
	cmp	r1, r0
	beq	.L1262
	adds	r0, r1, #1
	beq	.L1265
	str	r1, [r3, #4]
	movs	r2, #0
	movs	r1, #1
	mov	r0, r3
	ldr	r7, [r3, #12]
	bl	FlashReadPages
.L1266:
	ldr	r3, [r6]
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L1267
	ldr	r3, [r7, #4]
	ldr	r2, .L1348
	mov	r1, r3
	ldr	r0, [r2]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1267
	mov	r1, r3
	ldr	r0, [sp, #28]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1262
	b	.L1267
.L1265:
	str	r1, [r2, r5]
	b	.L1266
.L1259:
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #40]
	cmp	r2, r3
	beq	.L1269
	movs	r2, #1
	add	r1, sp, #44
	mov	r0, r4
	bl	log2phys
	ldr	r7, [sp, #40]
	adds	r5, r7, #1
	beq	.L1269
	ldr	r3, [sp, #36]
	cmp	r7, r3
	beq	.L1282
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1348+40
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L1273
	ldr	r3, .L1348+44
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L1273
	ldr	r3, .L1348+48
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L1269
.L1273:
	ldr	r0, [r6]
	movs	r2, #0
	movs	r1, #1
	str	r7, [r0, #4]
	ldr	r5, [r0, #12]
	bl	FlashReadPages
	ldr	r3, [r6]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L1269
	ldr	r1, [r5, #4]
	ldr	r0, [sp]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	bne	.L1269
	movs	r2, #1
	add	r1, sp, #40
	mov	r0, r4
	bl	log2phys
	b	.L1269
.L1349:
	.align	2
.L1348:
	.word	.LANCHOR145
	.word	.LANCHOR112
	.word	.LANCHOR167
	.word	.LANCHOR3
	.word	.LANCHOR19
	.word	.LANCHOR71
	.word	.LANCHOR5
	.word	.LANCHOR166
	.word	.LC1
	.word	.LANCHOR42
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR53
.L1275:
	mov	r1, r4
	ldr	r0, .L1350
	bl	printf
	b	.L1252
.L1256:
	ldr	r3, .L1350+4
	ldr	r3, [r3]
	cmp	r3, #31
	bhi	.L1276
	ldr	r2, .L1350+8
	str	r4, [r2, r3, lsl #2]
	adds	r3, r3, #1
	ldr	r2, .L1350+4
	str	r3, [r2]
.L1276:
	ldrh	r0, [r8]
	bl	decrement_vpc_count
	ldr	r3, .L1350+12
	ldr	r2, [r3]
	adds	r1, r2, #1
	bne	.L1277
	ldr	r2, [sp]
.L1342:
	str	r2, [r3]
	b	.L1252
.L1277:
	ldr	r1, [sp]
	cmp	r1, r2
	bcs	.L1252
	mov	r2, r1
	b	.L1342
.L1255:
	strb	r10, [r8, #6]
	mov	r2, r10
	strh	fp, [r8, #2]	@ movhi
	mov	r1, fp
	b	.L1345
.L1351:
	.align	2
.L1350:
	.word	.LC106
	.word	.LANCHOR168
	.word	.LANCHOR169
	.word	.LANCHOR145
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
	.section	.text.FtlWriteDump_data,"ax",%progbits
	.align	1
	.global	FtlWriteDump_data
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlWriteDump_data, %function
FtlWriteDump_data:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	ldr	r4, .L1371
	ldrh	r2, [r4, #4]
	cmp	r2, #0
	beq	.L1353
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1353
	ldr	r3, .L1371+4
	ldrb	r1, [r4, #7]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r3, r1, r3
	cmp	r2, r3
	beq	.L1353
	ldrb	r7, [r4, #10]	@ zero_extendqisi2
	cbnz	r7, .L1352
	ldr	r3, .L1371+8
	mov	r2, r7
	mov	r1, sp
	ldr	r6, [r3]
	ldr	r3, .L1371+12
	subs	r6, r6, #1
	mov	r0, r6
	ldrh	r8, [r3]
	bl	log2phys
	ldr	r2, .L1371+16
	ldr	r3, [sp]
	str	r6, [sp, #20]
	ldr	r0, [r2]
	ldr	r2, .L1371+20
	str	r3, [sp, #8]
	adds	r3, r3, #1
	str	r0, [sp, #12]
	ldr	r5, [r2]
	str	r5, [sp, #16]
	str	r7, [r5, #4]
	beq	.L1355
	mov	r2, r7
	movs	r1, #1
	add	r0, sp, #4
	bl	FlashReadPages
.L1356:
	ldr	fp, .L1371
	lsl	r8, r8, #2
	ldr	r10, .L1371+28
	movs	r7, #0
	movw	r3, #61589
	strh	r3, [r5]	@ movhi
.L1357:
	cmp	r8, r7
	bne	.L1361
.L1358:
	movs	r3, #1
.L1370:
	strb	r3, [r4, #10]
.L1352:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1355:
	ldr	r3, .L1371+24
	movs	r1, #255
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L1356
.L1361:
	ldrh	r3, [r4, #4]
	cmp	r3, #0
	beq	.L1358
	ldr	r3, [sp, #8]
	mov	r0, fp
	str	r6, [r5, #8]
	adds	r7, r7, #1
	str	r3, [r5, #12]
	ldrh	r3, [r4]
	strh	r3, [r5, #2]	@ movhi
	bl	get_new_active_ppa
	ldr	r3, [r10]
	movs	r1, #1
	str	r0, [sp, #8]
	add	r0, sp, #4
	str	r3, [r5, #4]
	adds	r3, r3, #1
	adds	r2, r3, #1
	it	eq
	moveq	r3, #0
	str	r3, [r10]
	movs	r3, #0
	mov	r2, r3
	bl	FlashProgPages
	ldrh	r0, [r4]
	bl	decrement_vpc_count
	b	.L1357
.L1353:
	movs	r3, #0
	b	.L1370
.L1372:
	.align	2
.L1371:
	.word	.LANCHOR51
	.word	.LANCHOR19
	.word	.LANCHOR61
	.word	.LANCHOR3
	.word	.LANCHOR115
	.word	.LANCHOR123
	.word	.LANCHOR23
	.word	.LANCHOR71
	.size	FtlWriteDump_data, .-FtlWriteDump_data
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
	ldr	r5, .L1377
	ldr	r6, .L1377+4
	bl	FtlWriteDump_data
.L1374:
	ldrh	r3, [r5]
	uxth	r0, r4
	cmp	r3, r0
	bhi	.L1376
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L1376:
	ldr	r2, [r6]
	uxth	r3, r4
	movs	r1, #12
	mla	r3, r1, r3, r2
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L1375
	bl	flush_l2p_region
.L1375:
	adds	r4, r4, #1
	b	.L1374
.L1378:
	.align	2
.L1377:
	.word	.LANCHOR33
	.word	.LANCHOR55
	.size	l2p_flush, .-l2p_flush
	.section	.text.FtlSuperblockPowerLostFix,"ax",%progbits
	.align	1
	.global	FtlSuperblockPowerLostFix
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlSuperblockPowerLostFix, %function
FtlSuperblockPowerLostFix:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	mov	r3, #-1
	sub	sp, sp, #24
	ldr	r2, .L1392
	movs	r6, #0
	mov	r4, r0
	str	r3, [sp, #20]
	ldr	r3, .L1392+4
	ldr	r5, [r2]
	mvn	r2, #2
	ldr	r8, .L1392+16
	ldr	r3, [r3]
	str	r5, [sp, #16]
	str	r3, [sp, #12]
	str	r2, [r5, #8]
	mvn	r2, #1
	str	r2, [r5, #12]
	ldrh	r2, [r0]
	strh	r6, [r5]	@ movhi
	strh	r2, [r5, #2]	@ movhi
	movw	r2, #61589
	str	r2, [r3]
	add	r2, r2, #304087040
	add	r2, r2, #1269760
	addw	r2, r2, #1507
	str	r2, [r3, #4]
	ldrh	r3, [r0, #4]
	tst	r3, #1
	ite	eq
	moveq	r7, #6
	movne	r7, #7
.L1385:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1381
.L1382:
	ldr	r3, .L1392+8
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldr	r3, .L1392+12
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1381:
	mov	r0, r4
	bl	get_new_active_ppa
	str	r0, [sp, #8]
	adds	r0, r0, #1
	beq	.L1382
	ldr	r3, [r8]
	movs	r1, #1
	add	r0, sp, #4
	str	r3, [r5, #4]
	adds	r3, r3, #1
	adds	r2, r3, #1
	it	eq
	moveq	r3, r6
	str	r3, [r8]
	movs	r3, #0
	mov	r2, r3
	bl	FlashProgPages
	ldrh	r0, [r4]
	bl	decrement_vpc_count
	subs	r7, r7, #1
	bne	.L1385
	b	.L1382
.L1393:
	.align	2
.L1392:
	.word	.LANCHOR123
	.word	.LANCHOR115
	.word	.LANCHOR42
	.word	.LANCHOR19
	.word	.LANCHOR71
	.size	FtlSuperblockPowerLostFix, .-FtlSuperblockPowerLostFix
	.section	.text.FtlVendorPartWrite,"ax",%progbits
	.align	1
	.global	FtlVendorPartWrite
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlVendorPartWrite, %function
FtlVendorPartWrite:
	@ args = 0, pretend = 0, frame = 104
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1406
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #104
	str	r2, [sp]
	adds	r2, r0, r1
	mov	r7, r0
	mov	r5, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L1402
	ldr	r3, .L1406+4
	mov	r8, #0
	ldrh	r6, [r3]
	lsr	r6, r0, r6
	lsl	fp, r6, #2
.L1396:
	cbnz	r5, .L1401
.L1394:
	mov	r0, r8
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1401:
	ldr	r3, .L1406+8
	mov	r0, r7
	ldr	r10, .L1406+24
	ldr	r3, [r3]
	ldr	r2, [r3, fp]
	ldr	r3, .L1406+12
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
	cbz	r2, .L1398
	cmp	r4, r3
	beq	.L1398
	ldr	r3, [r10]
	add	r0, sp, #20
	str	r2, [sp, #24]
	movs	r2, #1
	mov	r1, r2
	str	r3, [sp, #28]
	add	r3, sp, #40
	str	r3, [sp, #32]
	bl	FlashReadPages
.L1399:
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
	ldr	r0, .L1406+16
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
	b	.L1396
.L1398:
	ldr	r3, .L1406+20
	movs	r1, #0
	ldr	r0, [r10]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L1399
.L1402:
	mov	r8, #-1
	b	.L1394
.L1407:
	.align	2
.L1406:
	.word	.LANCHOR16
	.word	.LANCHOR22
	.word	.LANCHOR133
	.word	.LANCHOR12
	.word	.LANCHOR158
	.word	.LANCHOR23
	.word	.LANCHOR117
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
	ldr	r2, .L1410
	ldr	r3, .L1410+4
	ldr	r1, [r2]
	cmp	r1, r3
	bne	.L1408
	ldr	r3, .L1410+8
	movs	r1, #1
	movs	r0, #0
	str	r3, [r2, #4]
	ldr	r3, .L1410+12
	ldr	r3, [r3]
	str	r3, [r2, #88]
	ldr	r3, .L1410+16
	ldr	r3, [r3]
	str	r3, [r2, #92]
	ldr	r3, .L1410+20
	ldr	r3, [r3]
	str	r3, [r2, #8]
	ldr	r3, .L1410+24
	ldr	r3, [r3]
	str	r3, [r2, #12]
	ldr	r3, .L1410+28
	ldr	r3, [r3]
	str	r3, [r2, #16]
	ldr	r3, .L1410+32
	ldr	r3, [r3]
	str	r3, [r2, #20]
	ldr	r3, .L1410+36
	ldr	r3, [r3]
	str	r3, [r2, #28]
	ldr	r3, .L1410+40
	ldr	r3, [r3]
	str	r3, [r2, #32]
	ldr	r3, .L1410+44
	ldr	r3, [r3]
	str	r3, [r2, #36]
	ldr	r3, .L1410+48
	ldr	r3, [r3]
	str	r3, [r2, #40]
	ldr	r3, .L1410+52
	ldr	r3, [r3]
	str	r3, [r2, #44]
	ldr	r3, .L1410+56
	ldr	r3, [r3]
	str	r3, [r2, #48]
	b	FtlVendorPartWrite
.L1408:
	bx	lr
.L1411:
	.align	2
.L1410:
	.word	.LANCHOR81
	.word	1179929683
	.word	1342177352
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LANCHOR67
	.word	.LANCHOR64
	.word	.LANCHOR62
	.word	.LANCHOR66
	.word	.LANCHOR73
	.word	.LANCHOR75
	.word	.LANCHOR63
	.word	.LANCHOR65
	.word	.LANCHOR76
	.word	.LANCHOR77
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
	ldr	r2, .L1417
	push	{r3, lr}
	ldrh	r3, [r2]
	cmp	r3, #31
	itett	ls
	addls	r3, r3, #1
	movhi	r3, #32
	strhls	r3, [r2]	@ movhi
	movls	r3, #1
	ldr	r2, .L1417+4
	cbnz	r0, .L1414
	ldr	r1, [r2]
	ldr	r0, [r1, #20]
	ldr	r1, [r1, #16]
	add	r3, r3, r0
	cmp	r1, r3
	bcc	.L1415
.L1414:
	ldr	r2, [r2]
	movs	r0, #64
	ldr	r3, [r2, #16]
	str	r3, [r2, #20]
	ldr	r3, .L1417+8
	str	r3, [r2]
	ldr	r3, .L1417+12
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
.L1415:
	movs	r0, #0
	pop	{r3, pc}
.L1418:
	.align	2
.L1417:
	.word	.LANCHOR170
	.word	.LANCHOR127
	.word	1112818501
	.word	.LANCHOR125
	.size	FtlEctTblFlush, .-FtlEctTblFlush
	.section	.text.sftl_vendor_write,"ax",%progbits
	.align	1
	.global	sftl_vendor_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sftl_vendor_write, %function
sftl_vendor_write:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	add	r0, r0, #256
	b	FtlVendorPartWrite
	.size	sftl_vendor_write, .-sftl_vendor_write
	.section	.text.FtlVendorPartRead,"ax",%progbits
	.align	1
	.global	FtlVendorPartRead
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlVendorPartRead, %function
FtlVendorPartRead:
	@ args = 0, pretend = 0, frame = 104
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1430
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r2
	adds	r2, r0, r1
	sub	sp, sp, #104
	mov	r7, r0
	mov	r6, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L1429
	ldr	r3, .L1430+4
	mov	r8, #0
	ldr	fp, .L1430+28
	ldrh	r5, [r3]
	lsr	r5, r0, r5
	lsls	r3, r5, #2
	str	r3, [sp]
.L1422:
	cbnz	r6, .L1428
.L1420:
	mov	r0, r8
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1428:
	ldr	r3, .L1430+8
	mov	r0, r7
	ldr	r2, [sp]
	ldr	r3, [r3]
	ldr	r3, [r3, r2]
	ldr	r2, .L1430+12
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
	beq	.L1424
	ldr	r2, [fp]
	add	r0, sp, #20
	str	r3, [sp, #24]
	str	r3, [sp, #12]
	str	r2, [sp, #28]
	add	r2, sp, #40
	str	r2, [sp, #32]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [sp, #20]
	ldr	r3, [sp, #12]
	adds	r2, r2, #1
	ldr	r2, .L1430+16
	it	eq
	moveq	r8, #-1
	ldr	r2, [r2]
	cmp	r2, #256
	bne	.L1426
	mov	r2, r3
	mov	r1, r5
	ldr	r0, .L1430+20
	bl	printf
	ldr	r2, [fp]
	mov	r1, r5
	ldr	r0, .L1430+24
	bl	FtlMapWritePage
.L1426:
	ldr	r1, [fp]
	lsls	r2, r4, #9
	ldr	r3, [sp, #4]
	mov	r0, r10
	add	r1, r1, r3, lsl #9
	bl	ftl_memcpy
.L1427:
	ldr	r3, [sp, #8]
	adds	r5, r5, #1
	subs	r6, r6, r4
	add	r7, r7, r4
	add	r10, r10, r3
	ldr	r3, [sp]
	adds	r3, r3, #4
	str	r3, [sp]
	b	.L1422
.L1424:
	lsls	r2, r4, #9
	mov	r1, r3
	mov	r0, r10
	bl	ftl_memset
	b	.L1427
.L1429:
	mov	r8, #-1
	b	.L1420
.L1431:
	.align	2
.L1430:
	.word	.LANCHOR16
	.word	.LANCHOR22
	.word	.LANCHOR133
	.word	.LANCHOR12
	.word	.LANCHOR148
	.word	.LC107
	.word	.LANCHOR158
	.word	.LANCHOR117
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
	ldr	r4, .L1434
	ldr	r5, .L1434+4
	ldr	r2, [r4]
	ldrh	r1, [r5]
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	ldr	r2, [r3]
	ldr	r3, .L1434+8
	cmp	r2, r3
	beq	.L1433
	ldr	r1, .L1434+12
	ldr	r0, .L1434+16
	bl	printf
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r0, [r4]
	lsls	r2, r2, #9
	bl	ftl_memset
.L1433:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L1435:
	.align	2
.L1434:
	.word	.LANCHOR127
	.word	.LANCHOR125
	.word	1112818501
	.word	.LC108
	.word	.LC71
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
	ldr	r4, .L1439
	movs	r0, #0
	ldr	r5, .L1439+4
	mov	r2, r4
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	cmp	r3, r5
	beq	.L1437
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	ftl_memset
	str	r5, [r4]
.L1437:
	ldr	r3, [r4]
	cmp	r3, r5
	ldr	r3, .L1439+8
	bne	.L1438
	ldr	r1, [r4, #88]
	ldr	r2, .L1439+12
	str	r1, [r2]
	ldr	r1, [r4, #92]
	ldr	r2, .L1439+16
	str	r1, [r2]
	ldr	r1, [r4, #8]
	ldr	r2, .L1439+20
	str	r1, [r2]
	ldr	r1, [r4, #12]
	ldr	r2, .L1439+24
	str	r1, [r2]
	ldr	r1, [r4, #16]
	ldr	r2, .L1439+28
	str	r1, [r2]
	ldr	r1, [r4, #20]
	ldr	r2, .L1439+32
	str	r1, [r2]
	ldr	r2, [r4, #28]
	ldr	r1, [r4, #32]
	str	r2, [r3]
	ldr	r2, .L1439+36
	str	r1, [r2]
	ldr	r1, [r4, #36]
	ldr	r2, .L1439+40
	str	r1, [r2]
	ldr	r1, [r4, #40]
	ldr	r2, .L1439+44
	str	r1, [r2]
	ldr	r1, [r4, #44]
	ldr	r2, .L1439+48
	str	r1, [r2]
	ldr	r1, [r4, #48]
	ldr	r2, .L1439+52
	str	r1, [r2]
.L1438:
	ldr	r1, .L1439+56
	ldr	r2, .L1439+60
	ldr	r3, [r3]
	ldr	r0, [r1]
	ldrh	r2, [r2]
	ldr	r1, .L1439+64
	mla	r0, r0, r2, r3
	ldrh	r1, [r1]
	bl	__aeabi_uidiv
	ldr	r3, .L1439+68
	str	r0, [r3]
	pop	{r3, r4, r5, pc}
.L1440:
	.align	2
.L1439:
	.word	.LANCHOR81
	.word	1179929683
	.word	.LANCHOR73
	.word	.LANCHOR68
	.word	.LANCHOR69
	.word	.LANCHOR67
	.word	.LANCHOR64
	.word	.LANCHOR62
	.word	.LANCHOR66
	.word	.LANCHOR75
	.word	.LANCHOR63
	.word	.LANCHOR65
	.word	.LANCHOR76
	.word	.LANCHOR77
	.word	.LANCHOR72
	.word	.LANCHOR14
	.word	.LANCHOR5
	.word	.LANCHOR74
	.size	Ftl_load_ext_data, .-Ftl_load_ext_data
	.section	.text.sftl_vendor_read,"ax",%progbits
	.align	1
	.global	sftl_vendor_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sftl_vendor_read, %function
sftl_vendor_read:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	add	r0, r0, #256
	b	FtlVendorPartRead
	.size	sftl_vendor_read, .-sftl_vendor_read
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
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	fp, #0
	ldr	r3, .L1457
	ldr	r4, .L1457+4
	ldr	r10, .L1457+76
	ldr	r0, [r3]
	ldr	r5, .L1457+8
	ldr	r7, [r10]
	ldrh	r2, [r4]
	str	r0, [r5, #8]
	str	r7, [r5, #12]
	strh	r2, [r7, #2]	@ movhi
	movw	r2, #61604
	strh	r2, [r7]	@ movhi
	ldr	r2, [r4, #8]
	ldr	r6, .L1457+12
	ldr	ip, .L1457+80
	str	r2, [r7, #4]
	ldr	r2, .L1457+16
	str	fp, [r7, #8]
	str	fp, [r7, #12]
	stm	r6, {r2, ip}
	ldrh	r2, [r4, #6]
	str	r3, [sp, #4]
	ldr	r8, .L1457+84
	strh	r2, [r6, #8]	@ movhi
	ldr	r2, .L1457+20
	ldrh	r2, [r2]
	strb	r2, [r6, #10]
	ldr	r2, .L1457+24
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r6, #14]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r6, #11]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1457+28
	strh	r1, [r6, #16]	@ movhi
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r6, #18]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	orr	r1, r1, ip, lsl #6
	strh	r1, [r6, #20]	@ movhi
	strb	r2, [r6, #12]
	ldr	r2, .L1457+32
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r6, #22]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r6, #13]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1457+36
	strh	r1, [r6, #24]	@ movhi
	movs	r1, #255
	ldr	r2, [r2]
	str	r2, [r6, #32]
	ldr	r2, [r8]
	str	r2, [r6, #40]
	ldr	r2, .L1457+40
	ldr	r2, [r2]
	str	r2, [r6, #36]
	ldr	r2, .L1457+44
	ldrh	r2, [r2]
	bl	ftl_memset
	mov	r1, r6
	ldr	r6, .L1457+48
	movs	r2, #48
	ldr	r0, [r5, #8]
	bl	ftl_memcpy
	ldrh	r2, [r6]
	ldr	r0, [r5, #8]
	ldr	r1, .L1457+52
	lsls	r2, r2, #1
	adds	r0, r0, #48
	ldr	r1, [r1]
	bl	ftl_memcpy
	ldrh	r0, [r6]
	ldr	r1, .L1457+56
	ldr	r6, [r5, #8]
	lsrs	r2, r0, #3
	adds	r0, r0, #24
	lsls	r0, r0, #1
	ldr	r1, [r1]
	adds	r2, r2, #4
	bic	r0, r0, #3
	add	r0, r0, r6
	mov	r6, fp
	bl	ftl_memcpy
	mov	r0, fp
	movw	fp, #65535
	bl	FtlUpdateVaildLpn
.L1443:
	ldr	r3, [sp, #4]
	ldrh	r1, [r4, #2]
	ldrh	r2, [r4]
	ldr	r3, [r3]
	str	r3, [r5, #8]
	ldr	r3, [r10]
	str	r3, [r5, #12]
	orr	r3, r1, r2, lsl #10
	str	r3, [r5, #4]
	ldr	r3, .L1457+60
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r1, r3
	blt	.L1444
	movs	r3, #0
	ldrh	fp, [r4, #4]
	strh	r3, [r4, #2]	@ movhi
	strh	r2, [r4, #4]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, [r8]
	strh	r0, [r4]	@ movhi
	adds	r2, r3, #1
	str	r3, [r4, #8]
	str	r2, [r8]
	lsls	r2, r0, #10
	str	r2, [r5, #4]
	str	r3, [r7, #4]
	strh	r0, [r7, #2]	@ movhi
.L1444:
	movs	r3, #1
	ldr	r0, .L1457+8
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	ldr	r2, [r5]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r1, r2, #1
	strh	r3, [r4, #2]	@ movhi
	bne	.L1445
	cmp	r3, #1
	bne	.L1446
	movw	r2, #1135
	ldr	r1, .L1457+64
	ldr	r0, .L1457+68
	bl	printf
.L1446:
	ldrh	r3, [r4, #2]
	adds	r6, r6, #1
	uxth	r6, r6
	cmp	r3, #1
	itttt	eq
	ldreq	r3, .L1457+60
	ldrheq	r3, [r3]
	addeq	r3, r3, #-1
	strheq	r3, [r4, #2]	@ movhi
	cmp	r6, #3
	bls	.L1443
	mov	r2, r6
	ldr	r1, [r5, #4]
	ldr	r0, .L1457+72
	bl	printf
.L1449:
	b	.L1449
.L1445:
	cmp	r3, #1
	beq	.L1443
	cmp	r2, #256
	beq	.L1443
	movw	r3, #65535
	cmp	fp, r3
	beq	.L1450
	movs	r1, #1
	mov	r0, fp
	bl	FtlFreeSysBlkQueueIn
.L1450:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1458:
	.align	2
.L1457:
	.word	.LANCHOR115
	.word	.LANCHOR79
	.word	.LANCHOR148
	.word	.LANCHOR39
	.word	1179929683
	.word	.LANCHOR10
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR72
	.word	.LANCHOR71
	.word	.LANCHOR23
	.word	.LANCHOR5
	.word	.LANCHOR42
	.word	.LANCHOR1
	.word	.LANCHOR20
	.word	.LANCHOR171
	.word	.LC1
	.word	.LC109
	.word	.LANCHOR123
	.word	1342177352
	.word	.LANCHOR70
	.size	FtlVpcTblFlush, .-FtlVpcTblFlush
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
	bl	l2p_flush
	movs	r0, #1
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
	movs	r0, #0
	pop	{r3, pc}
	.size	FtlSysFlush, .-FtlSysFlush
	.section	.text.sftl_deinit,"ax",%progbits
	.align	1
	.global	sftl_deinit
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sftl_deinit, %function
sftl_deinit:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, lr}
	ldr	r3, .L1462
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L1461
	bl	FtlSysFlush
.L1461:
	movs	r0, #0
	pop	{r3, pc}
.L1463:
	.align	2
.L1462:
	.word	.LANCHOR86
	.size	sftl_deinit, .-sftl_deinit
	.section	.text.FtlDiscard,"ax",%progbits
	.align	1
	.global	FtlDiscard
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlDiscard, %function
FtlDiscard:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1479
	adds	r2, r0, r1
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r7, r0
	mov	r5, r1
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L1472
	cmp	r1, #31
	bhi	.L1466
.L1471:
	movs	r0, #0
.L1464:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1466:
	ldr	r8, .L1479+12
	ldrh	r4, [r8]
	mov	r1, r4
	bl	__aeabi_uidiv
	smulbb	r3, r0, r4
	mov	r6, r0
	subs	r7, r7, r3
	uxth	r7, r7
	cbz	r7, .L1467
	subs	r4, r4, r7
	adds	r6, r6, #1
	cmp	r4, r5
	it	cs
	movcs	r4, r5
	uxth	r4, r4
	subs	r5, r5, r4
.L1467:
	ldr	r4, .L1479+4
	mov	r3, #-1
	ldr	r7, .L1479+8
	str	r3, [sp, #4]
.L1468:
	ldrh	r3, [r8]
	cmp	r5, r3
	bcs	.L1470
	ldr	r3, .L1479+4
	ldr	r2, [r3]
	cmp	r2, #32
	bls	.L1471
	movs	r4, #0
	str	r4, [r3]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L1471
.L1470:
	movs	r2, #0
	mov	r1, sp
	mov	r0, r6
	bl	log2phys
	ldr	r3, [sp]
	adds	r3, r3, #1
	beq	.L1469
	ldr	r3, [r4]
	movs	r2, #1
	add	r1, sp, #4
	mov	r0, r6
	adds	r3, r3, #1
	str	r3, [r4]
	ldr	r3, [r7]
	adds	r3, r3, #1
	str	r3, [r7]
	bl	log2phys
	ldr	r0, [sp]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	bl	decrement_vpc_count
.L1469:
	ldrh	r3, [r8]
	adds	r6, r6, #1
	subs	r5, r5, r3
	b	.L1468
.L1472:
	mov	r0, #-1
	b	.L1464
.L1480:
	.align	2
.L1479:
	.word	.LANCHOR34
	.word	.LANCHOR172
	.word	.LANCHOR63
	.word	.LANCHOR12
	.size	FtlDiscard, .-FtlDiscard
	.section	.text.FtlVpcCheckAndModify,"ax",%progbits
	.align	1
	.global	FtlVpcCheckAndModify
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlVpcCheckAndModify, %function
FtlVpcCheckAndModify:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	movs	r4, #0
	ldr	r1, .L1494
	ldr	r0, .L1494+4
	bl	printf
	ldr	r3, .L1494+8
	movs	r1, #0
	ldr	r5, .L1494+12
	ldr	r6, .L1494+16
	ldrh	r2, [r3]
	ldr	r0, [r5]
	lsls	r2, r2, #1
	bl	ftl_memset
.L1482:
	ldr	r3, [r6]
	cmp	r4, r3
	bcc	.L1484
	ldr	r10, .L1494+36
	movs	r7, #0
	ldr	r8, .L1494+40
.L1485:
	ldrh	r3, [r10]
	uxth	r6, r7
	cmp	r3, r6
	bhi	.L1490
	bl	l2p_flush
	bl	FtlVpcTblFlush
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L1484:
	movs	r2, #0
	add	r1, sp, #4
	mov	r0, r4
	bl	log2phys
	ldr	r0, [sp, #4]
	adds	r3, r0, #1
	beq	.L1483
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldr	r2, [r5]
	ldrh	r3, [r2, r0, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r0, lsl #1]	@ movhi
.L1483:
	adds	r4, r4, #1
	b	.L1482
.L1490:
	ldr	r3, [r8]
	uxth	r4, r7
	ldrh	r2, [r3, r4, lsl #1]
	ldr	r3, [r5]
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r2, r3
	beq	.L1487
	movw	r1, #65535
	cmp	r2, r1
	beq	.L1487
	mov	r1, r4
	ldr	r0, .L1494+20
	bl	printf
	ldr	r3, .L1494+24
	ldrh	r3, [r3]
	cmp	r3, r6
	beq	.L1487
	ldr	r3, .L1494+28
	ldrh	r3, [r3]
	cmp	r3, r6
	beq	.L1487
	ldr	r3, .L1494+32
	ldrh	r3, [r3]
	cmp	r3, r6
	beq	.L1487
	ldr	r3, [r8]
	ldrh	r2, [r3, r4, lsl #1]
	cbnz	r2, .L1489
	ldr	r2, [r5]
	ldrh	r2, [r2, r4, lsl #1]
	strh	r2, [r3, r4, lsl #1]	@ movhi
.L1487:
	adds	r7, r7, #1
	b	.L1485
.L1489:
	ldr	r2, [r5]
	mov	r0, r6
	ldrh	r2, [r2, r4, lsl #1]
	strh	r2, [r3, r4, lsl #1]	@ movhi
	bl	update_vpc_list
	b	.L1487
.L1495:
	.align	2
.L1494:
	.word	.LANCHOR173
	.word	.LC94
	.word	.LANCHOR6
	.word	.LANCHOR128
	.word	.LANCHOR61
	.word	.LC110
	.word	.LANCHOR51
	.word	.LANCHOR53
	.word	.LANCHOR52
	.word	.LANCHOR5
	.word	.LANCHOR42
	.size	FtlVpcCheckAndModify, .-FtlVpcCheckAndModify
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
	ldr	r3, .L1506
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r4, [r0]
	ldrh	r3, [r3]
	cmp	r3, r4
	bcs	.L1497
	movw	r2, #2714
	ldr	r1, .L1506+4
	ldr	r0, .L1506+8
	bl	printf
.L1497:
	movw	r3, #65535
	cmp	r4, r3
	beq	.L1498
	ldr	r3, .L1506+12
	mov	r0, r4
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cbz	r3, .L1499
	bl	INSERT_DATA_LIST
.L1498:
	ldr	r5, .L1506+16
	movw	r2, #65535
	movs	r3, #1
	strb	r3, [r6, #8]
	ldrh	r0, [r5]
	cmp	r0, r2
	beq	.L1500
	cmp	r4, r0
	bne	.L1501
	ldr	r3, .L1506+12
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L1502
.L1501:
	bl	update_vpc_list
.L1502:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L1500:
	mov	r0, r6
	bl	allocate_data_superblock
	bl	l2p_flush
	movs	r0, #0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L1499:
	bl	INSERT_FREE_LIST
	b	.L1498
.L1507:
	.align	2
.L1506:
	.word	.LANCHOR5
	.word	.LANCHOR174
	.word	.LC1
	.word	.LANCHOR42
	.word	.LANCHOR142
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r8, .L1522+24
	mov	r4, r3
	movs	r2, #0
	mov	r5, r0
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	mov	r10, r1
	bl	FlashProgPages
.L1509:
	cmp	r6, r10
	beq	.L1516
	ldr	r7, .L1522
	b	.L1517
.L1512:
	ldr	r0, [r5, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r4]
	cmp	r3, r0
	bne	.L1510
	ldr	r1, [r8]
	ldrh	r0, [r4, #4]
	ldrh	r2, [r1, r3, lsl #1]
	subs	r2, r2, r0
	strh	r2, [r1, r3, lsl #1]	@ movhi
	ldrh	r3, [r7]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
.L1510:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1511
	mov	r0, r4
	bl	allocate_new_data_superblock
.L1511:
	ldr	r2, .L1522+4
	ldr	r3, [r2, #96]
	adds	r3, r3, #1
	str	r3, [r2, #96]
	ldr	r0, [r5, #4]
	ubfx	r0, r0, #10, #16
	bl	FtlGcMarkBadPhyBlk
	mov	r0, r4
	bl	get_new_active_ppa
	movs	r2, #0
	str	r0, [r5, #4]
	str	r0, [sp, #4]
	movs	r1, #1
	ldrb	r3, [r4, #9]	@ zero_extendqisi2
	mov	r0, r5
	bl	FlashProgPages
.L1517:
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L1512
	ldr	r3, .L1522+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1513
	movw	r2, #955
	ldr	r1, .L1522+12
	ldr	r0, .L1522+16
	bl	printf
.L1513:
	ldr	r3, [r5, #4]
	add	r1, sp, #8
	movs	r2, #1
	ldr	r0, [r5, #16]
	str	r3, [r1, #-4]!
	bl	log2phys
	ldr	r3, [r5, #12]
	ldr	fp, [r3, #12]
	ubfx	r0, fp, #10, #16
	bl	P2V_block_in_plane
	cmp	fp, #-1
	mov	r7, r0
	beq	.L1514
	ldr	r3, [r8]
	ldrh	r2, [r3, r0, lsl #1]
	cbnz	r2, .L1515
	mov	r1, r0
	ldr	r0, .L1522+20
	bl	printf
.L1515:
	mov	r0, r7
	bl	decrement_vpc_count
.L1514:
	adds	r6, r6, #1
	adds	r5, r5, #20
	b	.L1509
.L1516:
	ldr	r3, .L1522+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1508
	movw	r2, #970
	ldr	r1, .L1522+12
	ldr	r0, .L1522+16
	bl	printf
.L1508:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1523:
	.align	2
.L1522:
	.word	.LANCHOR19
	.word	.LANCHOR81
	.word	.LANCHOR3
	.word	.LANCHOR175
	.word	.LC1
	.word	.LC111
	.word	.LANCHOR42
	.size	FtlProgPages, .-FtlProgPages
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
	movw	r2, #65535
	ldr	r4, .L1550
	ldr	r6, .L1550+4
	ldrh	r5, [r4]
	ldrh	r1, [r6]
	cmp	r5, r2
	bne	.L1525
.L1535:
	ldr	r3, .L1550+8
	movs	r2, #0
	str	r2, [r3]
	movw	r3, #65535
	ldrh	r2, [r4]
	cmp	r2, r3
	bne	.L1548
.L1526:
	movs	r0, #0
.L1524:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1525:
	cbz	r0, .L1528
	ldr	r3, .L1550+12
	ldrh	r0, [r3]
	cmp	r0, r2
	beq	.L1529
.L1530:
	movs	r1, #2
.L1528:
	ldr	r0, .L1550
	bl	FtlGcScanTempBlk
	str	r0, [sp, #12]
	adds	r0, r0, #1
	beq	.L1531
	ldr	r3, .L1550+16
	ldr	r2, [r3]
	ldrh	r3, [r2, r5, lsl #1]
	cmp	r3, #4
	bls	.L1532
	subs	r3, r3, #5
	movs	r0, #1
	strh	r3, [r2, r5, lsl #1]	@ movhi
	bl	FtlEctTblFlush
.L1532:
	ldr	r4, .L1550+8
	ldr	r2, [r4]
	cbnz	r2, .L1533
	ldr	r2, .L1550+20
	ldr	r0, [sp, #12]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L1533:
	movs	r3, #0
	str	r3, [r4]
.L1544:
	movs	r0, #1
	b	.L1524
.L1529:
	movs	r2, #0
	strh	r2, [r3]	@ movhi
	ldr	r3, .L1550+24
	ldrh	r3, [r3]
	cmp	r3, #17
	bhi	.L1530
	b	.L1528
.L1531:
	ldr	r3, .L1550+12
	ldrh	r2, [r3]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1544
	b	.L1535
.L1548:
	ldrb	r1, [r4, #7]	@ zero_extendqisi2
	ldrh	r3, [r6]
	ldr	r5, .L1550+28
	muls	r3, r1, r3
	ldrh	r2, [r5]
	cmp	r2, r3
	beq	.L1536
	movs	r2, #162
	ldr	r1, .L1550+32
	ldr	r0, .L1550+36
	bl	printf
.L1536:
	ldrh	r6, [r6]
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldr	r2, .L1550+40
	ldrh	r0, [r4]
	ldr	fp, .L1550+68
	smulbb	r3, r3, r6
	ldr	r1, [r2]
	movs	r6, #0
	str	r2, [sp, #4]
	strh	r3, [r1, r0, lsl #1]	@ movhi
	ldr	r1, .L1550+44
	ldrh	r3, [r5]
	ldr	r0, [r1]
	add	r3, r3, r0
	str	r3, [r1]
.L1537:
	ldrh	r2, [r5]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L1541
	movw	r0, #65535
	bl	decrement_vpc_count
	ldr	r3, [sp, #4]
	ldrh	r0, [r4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	beq	.L1542
	bl	INSERT_DATA_LIST
.L1543:
	ldr	r3, .L1550+48
	movw	r6, #65535
	strh	r6, [r4]	@ movhi
	movs	r4, #0
	strh	r4, [r5]	@ movhi
	strh	r4, [r3]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	r3, .L1550+52
	strh	r6, [r3]	@ movhi
	ldr	r3, .L1550+24
	ldrh	r2, [r3]
	ldr	r3, .L1550+56
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	cmp	r2, r3, asr #2
	ble	.L1526
	ldr	r3, .L1550+60
	movs	r2, #20
	strh	r2, [r3]	@ movhi
	b	.L1526
.L1541:
	uxth	r3, r6
	movs	r7, #12
	ldr	r2, [fp]
	muls	r7, r3, r7
	ldr	r3, .L1550+64
	ldr	r8, [r3]
	add	r10, r8, r7
	ldr	r1, [r10, #8]
	cmp	r1, r2
	bcc	.L1538
	movs	r2, #168
	ldr	r1, .L1550+32
	ldr	r0, .L1550+36
	bl	printf
.L1538:
	movs	r2, #0
	add	r1, sp, #12
	ldr	r0, [r10, #8]
	bl	log2phys
	ldr	r2, [sp, #12]
	ldr	r0, [r8, r7]
	cmp	r0, r2
	bne	.L1539
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	movs	r2, #1
	mov	r7, r0
	add	r1, r10, #4
	ldr	r0, [r10, #8]
	bl	log2phys
	mov	r0, r7
.L1549:
	bl	decrement_vpc_count
.L1540:
	adds	r6, r6, #1
	b	.L1537
.L1539:
	ldr	r3, [r10, #4]
	cmp	r2, r3
	beq	.L1540
	ldrh	r0, [r4]
	b	.L1549
.L1542:
	bl	INSERT_FREE_LIST
	b	.L1543
.L1551:
	.align	2
.L1550:
	.word	.LANCHOR53
	.word	.LANCHOR19
	.word	.LANCHOR144
	.word	.LANCHOR162
	.word	.LANCHOR43
	.word	.LANCHOR81
	.word	.LANCHOR48
	.word	.LANCHOR97
	.word	.LANCHOR176
	.word	.LC1
	.word	.LANCHOR42
	.word	.LANCHOR67
	.word	.LANCHOR96
	.word	.LANCHOR80
	.word	.LANCHOR78
	.word	.LANCHOR82
	.word	.LANCHOR98
	.word	.LANCHOR61
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
	ldr	r4, .L1554
	ldr	r5, .L1554+4
	ldrh	r1, [r4]
	mov	r0, r5
	bl	FtlGcScanTempBlk
	ldrh	r2, [r5, #2]
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L1552
	ldr	r0, .L1554+8
	bl	FtlMapBlkWriteDump_data
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r3, .L1554+12
	movs	r2, #0
	str	r2, [r3]
.L1552:
	pop	{r3, r4, r5, pc}
.L1555:
	.align	2
.L1554:
	.word	.LANCHOR19
	.word	.LANCHOR53
	.word	.LANCHOR140
	.word	.LANCHOR144
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
	ldr	r5, .L1557
	ldr	r3, .L1557+4
	mov	r0, r5
	str	r4, [r3]
	bl	FtlRecoverySuperblock
	mov	r0, r5
	ldr	r5, .L1557+8
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
.L1558:
	.align	2
.L1557:
	.word	.LANCHOR51
	.word	.LANCHOR168
	.word	.LANCHOR52
	.size	FtlPowerLostRecovery, .-FtlPowerLostRecovery
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
	movs	r3, #0
	ldr	r4, .L1566
	movs	r6, #0
	movs	r7, #20
	mov	r2, r3
	ldr	r5, .L1566+4
	ldr	r1, [r4]
	ldr	r0, [r5]
	bl	FlashProgPages
.L1560:
	ldr	r1, [r4]
	uxth	r3, r6
	cmp	r1, r3
	bhi	.L1563
	ldr	r0, [r5]
	bl	FtlGcBufFree
	ldr	r3, .L1566+8
	movs	r0, #0
	str	r0, [r4]
	ldrh	r3, [r3, #4]
	cbnz	r3, .L1559
	movs	r0, #1
	bl	FtlGcFreeTempBlock
	b	.L1565
.L1563:
	muls	r3, r7, r3
	ldr	r2, [r5]
	adds	r6, r6, #1
	adds	r1, r2, r3
	ldr	r2, [r2, r3]
	adds	r3, r2, #1
	bne	.L1561
	ldr	r3, .L1566+8
	movs	r5, #0
	ldr	r0, .L1566+12
	ldrh	r4, [r3]
	ldr	r0, [r0]
	strh	r5, [r0, r4, lsl #1]	@ movhi
	strh	r2, [r3]	@ movhi
	ldr	r2, .L1566+16
	ldr	r0, [r1, #4]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
.L1565:
	movs	r0, #1
.L1559:
	pop	{r3, r4, r5, r6, r7, pc}
.L1561:
	ldr	r3, [r1, #12]
	ldr	r1, [r1, #4]
	ldr	r2, [r3, #8]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L1560
.L1567:
	.align	2
.L1566:
	.word	.LANCHOR89
	.word	.LANCHOR113
	.word	.LANCHOR53
	.word	.LANCHOR42
	.word	.LANCHOR81
	.size	Ftl_gc_temp_data_write_back, .-Ftl_gc_temp_data_write_back
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
	ldr	r4, .L1571
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L1569
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1570
.L1569:
	movs	r0, #0
	movs	r5, #0
	bl	FtlGcFreeTempBlock
	ldr	r0, .L1571
	strb	r5, [r4, #8]
	bl	allocate_data_superblock
	ldr	r3, .L1571+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L1571+8
	strh	r5, [r3]	@ movhi
	bl	l2p_flush
	mov	r0, r5
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1570:
	ldr	r0, .L1571
	pop	{r3, r4, r5, lr}
	b	get_new_active_ppa
.L1572:
	.align	2
.L1571:
	.word	.LANCHOR53
	.word	.LANCHOR96
	.word	.LANCHOR97
	.size	Ftl_get_new_temp_ppa, .-Ftl_get_new_temp_ppa
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
	ldr	r6, .L1588
	strh	r3, [r6]	@ movhi
	ldr	r3, .L1588+4
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	ldr	r3, .L1588+8
	ldrh	r2, [r3]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1574
.L1576:
	mov	r7, #-1
.L1573:
	mov	r0, r7
	pop	{r3, r4, r5, r6, r7, pc}
.L1574:
	bl	FtlLoadSysInfo
	mov	r7, r0
	cmp	r0, #0
	bne	.L1576
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	movs	r0, #1
	bl	FtlUpdateVaildLpn
	ldr	r3, .L1588+12
	movs	r0, #12
	ldrh	r1, [r3]
	ldr	r3, .L1588+16
	ldr	r2, [r3]
	mov	r3, r7
.L1577:
	cmp	r3, r1
	bge	.L1582
	mla	r4, r0, r3, r2
	ldr	r4, [r4, #4]
	cmp	r4, #0
	bge	.L1578
.L1582:
	ldr	r5, .L1588+20
	cmp	r3, r1
	ldr	r4, .L1588+24
	ldrh	r2, [r5, #28]
	add	r2, r2, #1
	strh	r2, [r5, #28]	@ movhi
	bge	.L1587
.L1579:
	ldr	r6, .L1588+28
	ldr	r0, .L1588+24
	bl	FtlSuperblockPowerLostFix
	mov	r0, r6
	bl	FtlSuperblockPowerLostFix
	ldr	r3, .L1588+32
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	ldr	r0, .L1588+36
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldrh	ip, [r6]
	ldrh	r3, [r0]
	ldrh	lr, [r6, #4]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
	ldrh	r1, [r2, ip, lsl #1]
	sub	r1, r1, lr
	strh	r1, [r2, ip, lsl #1]	@ movhi
	strb	r3, [r6, #6]
	strh	r3, [r6, #4]	@ movhi
	ldrh	r3, [r5, #30]
	ldrh	r2, [r0]
	adds	r3, r3, #1
	strh	r2, [r6, #2]	@ movhi
	strh	r3, [r5, #30]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	bl	FtlVpcTblFlush
	b	.L1583
.L1578:
	adds	r3, r3, #1
	b	.L1577
.L1587:
	ldrh	r3, [r6]
	cmp	r3, #0
	bne	.L1579
.L1583:
	bl	FtlVpcCheckAndModify
	ldrh	r0, [r4]
	movw	r3, #65535
	cmp	r0, r3
	beq	.L1573
	ldrh	r3, [r4, #4]
	cmp	r3, #0
	bne	.L1573
	ldr	r4, .L1588+28
	ldrh	r3, [r4, #4]
	cmp	r3, #0
	bne	.L1573
	bl	FtlGcRefreshBlock
	ldrh	r0, [r4]
	bl	FtlGcRefreshBlock
	bl	FtlVpcTblFlush
	ldr	r0, .L1588+24
	bl	allocate_new_data_superblock
	mov	r0, r4
	bl	allocate_new_data_superblock
	b	.L1573
.L1589:
	.align	2
.L1588:
	.word	.LANCHOR167
	.word	.LANCHOR4
	.word	.LANCHOR79
	.word	.LANCHOR33
	.word	.LANCHOR55
	.word	.LANCHOR39
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR42
	.word	.LANCHOR19
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
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L1713
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #48
	str	r0, [sp, #8]
	ldr	r0, [r3]
	cmp	r0, #0
	bne	.L1667
	ldr	r3, .L1713+4
	ldrh	r3, [r3]
	cmp	r3, #47
	bls	.L1590
	ldr	r3, .L1713+8
	ldrh	r2, [r3]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1592
.L1595:
	ldr	r3, .L1713+12
	movw	r4, #65535
	ldrh	r0, [r3]
	cmp	r0, r4
	bne	.L1593
.L1594:
	bl	FtlReadRefresh
	ldr	r2, .L1713+16
	movw	r5, #65535
	ldr	r6, .L1713+20
	ldr	r1, [sp, #8]
	ldr	r3, [r2]
	ldrh	r0, [r6]
	adds	r3, r3, #1
	add	r3, r3, r1, lsl #7
	cmp	r0, r5
	str	r3, [r2]
	bne	.L1596
	ldr	r1, .L1713+24
	ldrh	r1, [r1]
	cmp	r1, r0
	bne	.L1597
	ldr	r0, .L1713+28
	ldrh	r8, [r0]
	cmp	r8, r1
	bne	.L1598
	ldr	r7, .L1713+32
	ldrh	r1, [r7]
	cmp	r1, #24
	ite	cc
	movcc	r1, #5120
	movcs	r1, #1024
	cmp	r3, r1
	bls	.L1598
	ldr	r3, .L1713+36
	movs	r4, #0
	str	r4, [r2]
	strh	r4, [r3]	@ movhi
	bl	GetSwlReplaceBlock
	cmp	r0, r8
	mov	r5, r0
	bne	.L1671
	ldr	r8, .L1713+96
	ldrh	r2, [r7]
	ldrh	r3, [r8]
	cmp	r2, r3
	bcs	.L1601
	movs	r0, #64
	bl	List_get_gc_head_node
	uxth	r3, r0
	cmp	r3, r5
	beq	.L1603
	mov	r0, r3
	ldr	r3, .L1713+40
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #7
	bhi	.L1604
	mov	r0, r4
	bl	List_get_gc_head_node
	uxth	r4, r0
	movs	r3, #128
	strh	r3, [r8]	@ movhi
	cmp	r4, r5
	bne	.L1600
.L1603:
	bl	FtlGcReFreshBadBlk
	ldr	r3, [sp, #8]
	cmp	r3, #0
	bne	.L1606
	movw	r3, #65535
	cmp	r5, r3
	bne	.L1606
.L1665:
	ldr	r3, .L1713+32
	ldrh	r3, [r3]
	cmp	r3, #24
	bhi	.L1672
	ldr	r2, .L1713+44
	cmp	r3, #16
	ldrh	r4, [r2]
	bls	.L1608
	lsrs	r4, r4, #5
.L1607:
	ldr	r1, .L1713+48
	ldrh	r2, [r1]
	cmp	r2, r3
	mov	r2, r1
	bcs	.L1611
	ldr	r3, .L1713+24
	movw	r0, #65535
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L1612
	ldr	r0, .L1713+28
	ldrh	r0, [r0]
	cmp	r0, r3
	bne	.L1612
	ldr	r3, .L1713+36
	ldrh	r0, [r3]
	cbnz	r0, .L1613
	ldr	r3, .L1713+52
	ldr	r4, .L1713+56
	ldr	r3, [r3]
	ldr	r4, [r4]
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, lsr #2
	bcs	.L1614
.L1613:
	ldr	r3, .L1713+60
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r2]	@ movhi
.L1615:
	ldr	r3, .L1713+64
	movs	r2, #0
	str	r2, [r3]
.L1590:
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1592:
	ldr	r2, .L1713+24
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L1595
	movs	r0, #1
	bl	FtlGcFreeTempBlock
	cmp	r0, #0
	beq	.L1595
	movs	r0, #1
	b	.L1590
.L1593:
	ldr	r1, .L1713+28
	ldrh	r2, [r1]
	cmp	r2, r4
	itt	eq
	strheq	r0, [r1]	@ movhi
	strheq	r2, [r3]	@ movhi
	b	.L1594
.L1604:
	movs	r3, #64
.L1707:
	strh	r3, [r8]	@ movhi
	b	.L1603
.L1601:
	movs	r3, #80
	b	.L1707
.L1671:
	mov	r4, r0
.L1600:
	ldr	r3, .L1713+40
	mov	r5, r4
	ldr	r1, .L1713+48
	ldrh	r2, [r7]
	ldr	r3, [r3]
	ldrh	r1, [r1]
	ldr	r0, .L1713+68
	ldrh	r3, [r3, r4, lsl #1]
	str	r1, [sp, #4]
	ldr	r1, .L1713+72
	ldr	r1, [r1]
	ldrh	r1, [r1, r4, lsl #1]
	str	r1, [sp]
	mov	r1, r4
	bl	printf
	b	.L1603
.L1608:
	cmp	r3, #12
	bls	.L1609
	lsrs	r4, r4, #4
	b	.L1607
.L1609:
	cmp	r3, #8
	bls	.L1607
	lsrs	r4, r4, #2
	b	.L1607
.L1672:
	movs	r4, #1
	b	.L1607
.L1614:
	movs	r3, #18
	strh	r3, [r1]	@ movhi
	b	.L1615
.L1612:
	ldr	r3, .L1713+60
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r2]	@ movhi
.L1611:
	ldr	r3, .L1713+76
	ldrh	r3, [r3]
	cbz	r3, .L1673
	adds	r4, r4, #32
	uxth	r4, r4
.L1673:
	movw	r5, #65535
.L1617:
	ldrh	r3, [r6]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L1626
	cmp	r5, r3
	beq	.L1627
	strh	r5, [r6]	@ movhi
.L1628:
	ldrh	r0, [r6]
	movw	r7, #65535
	movs	r3, #0
	strb	r3, [r6, #8]
	cmp	r0, r7
	beq	.L1626
	bl	IsBlkInGcList
	cbz	r0, .L1631
	strh	r7, [r6]	@ movhi
.L1631:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1626
	ldr	r0, .L1713+20
	bl	make_superblock
	ldr	r2, .L1713+80
	movs	r3, #0
	strh	r3, [r6, #2]	@ movhi
	strb	r3, [r6, #6]
	strh	r3, [r2]	@ movhi
	ldr	r3, .L1713+40
	ldrh	r2, [r6]
	ldr	r3, [r3]
	ldrh	r2, [r3, r2, lsl #1]
	ldr	r3, .L1713+84
	strh	r2, [r3]	@ movhi
.L1626:
	ldr	r2, .L1713+88
	ldrh	r3, [r6]
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L1632
	ldr	r2, .L1713+92
	ldrh	r2, [r2]
	cmp	r2, r3
	bne	.L1633
.L1632:
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
.L1633:
	ldr	fp, .L1713+20
	mov	r6, fp
.L1663:
	ldrh	r2, [fp]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1634
	ldr	r10, .L1713+100
	movs	r2, #0
	ldr	r3, .L1713+64
	mov	r8, r10
	str	r2, [r3]
.L1635:
	ldrh	r7, [r10]
	mov	r0, r7
	bl	List_get_gc_head_node
	uxth	r3, r0
	movw	r1, #65535
	cmp	r3, r1
	strh	r3, [r6]	@ movhi
	bne	.L1636
	movs	r3, #0
	movs	r0, #8
	strh	r3, [r10]	@ movhi
	b	.L1590
.L1714:
	.align	2
.L1713:
	.word	.LANCHOR108
	.word	.LANCHOR45
	.word	.LANCHOR162
	.word	.LANCHOR100
	.word	.LANCHOR84
	.word	.LANCHOR80
	.word	.LANCHOR53
	.word	.LANCHOR99
	.word	.LANCHOR48
	.word	.LANCHOR177
	.word	.LANCHOR42
	.word	.LANCHOR19
	.word	.LANCHOR82
	.word	.LANCHOR61
	.word	.LANCHOR59
	.word	.LANCHOR78
	.word	.LANCHOR87
	.word	.LC112
	.word	.LANCHOR43
	.word	.LANCHOR101
	.word	.LANCHOR178
	.word	.LANCHOR179
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR83
	.word	.LANCHOR85
.L1618:
	ldr	r3, .L1715
	movs	r2, #0
	ldr	r5, .L1715+4
	ldr	r4, .L1715+8
	str	r2, [r3]
	ldrh	r2, [r5]
	ldrh	r3, [r4]
	ldr	r7, .L1715+12
	cmp	r2, r3
	bls	.L1619
	ldrh	r3, [r7]
	cbnz	r3, .L1620
	ldr	r3, .L1715+16
	ldr	r2, .L1715+20
	ldr	r3, [r3]
	ldr	r2, [r2]
	add	r3, r3, r3, lsl #1
	cmp	r2, r3, lsr #2
	bcs	.L1621
.L1620:
	ldr	r3, .L1715+24
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
.L1708:
	strh	r3, [r4]	@ movhi
	bl	FtlReadRefresh
	movs	r0, #0
	bl	List_get_gc_head_node
	ldr	r3, .L1715+28
	uxth	r0, r0
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #4
	bls	.L1619
.L1711:
	ldrh	r0, [r7]
	b	.L1590
.L1621:
	movs	r3, #18
	b	.L1708
.L1619:
	ldrh	r0, [r7]
	cmp	r0, #0
	bne	.L1623
	ldr	r3, .L1715+24
	ldrh	r8, [r3]
	add	r2, r8, r8, lsl #1
	asrs	r2, r2, #2
	strh	r2, [r4]	@ movhi
	bl	List_get_gc_head_node
	ldr	r3, .L1715+28
	uxth	r0, r0
	ldr	r2, .L1715+32
	ldr	r3, [r3]
	ldrh	r2, [r2]
	ldrh	r1, [r3, r0, lsl #1]
	ldr	r3, .L1715+36
	ldrh	r3, [r3]
	muls	r2, r3, r2
	cmp	r1, r2, asr #1
	ble	.L1624
	ldrh	r2, [r5]
	add	r3, r8, #-1
	cmp	r2, r3
	blt	.L1624
	bl	FtlReadRefresh
	b	.L1711
.L1624:
	cmp	r1, #0
	bne	.L1623
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r0, [r5]
	adds	r0, r0, #1
	b	.L1590
.L1627:
	ldr	r3, .L1715+40
	ldrh	r2, [r3]
	cmp	r2, r5
	beq	.L1628
	ldr	r1, .L1715+28
	ldr	r1, [r1]
	ldrh	r2, [r1, r2, lsl #1]
	cbnz	r2, .L1629
	strh	r5, [r3]	@ movhi
.L1629:
	ldrh	r2, [r3]
	strh	r2, [r6]	@ movhi
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
	b	.L1628
.L1636:
	str	r0, [sp, #16]
	mov	r0, r3
	str	r3, [sp, #12]
	adds	r7, r7, #1
	bl	IsBlkInGcList
	ldr	r3, [sp, #12]
	ldr	r2, [sp, #16]
	cbz	r0, .L1637
	strh	r7, [r10]	@ movhi
	b	.L1635
.L1637:
	ldr	lr, .L1715+28
	uxth	r0, r2
	uxth	r7, r7
	ldr	r2, [lr]
	strh	r7, [r10]	@ movhi
	str	lr, [sp, #16]
	ldrh	ip, [r2, r0, lsl #1]
	str	r2, [sp, #12]
	ldr	r2, .L1715+44
	ldrh	r2, [r2]
	mov	r1, r2
	ldr	r2, .L1715+32
	ldrh	r2, [r2]
	muls	r2, r1, r2
	cmp	ip, r2, asr #1
	bgt	.L1639
	cmp	r7, #48
	bls	.L1640
	cmp	ip, #8
	bls	.L1640
	ldr	r7, .L1715+48
	ldrh	r7, [r7]
	cmp	r7, #35
	bhi	.L1640
.L1639:
	movs	r7, #0
	strh	r7, [r8]	@ movhi
.L1640:
	ldr	r1, [sp, #12]
	ldrh	r1, [r1, r0, lsl #1]
	cmp	r2, r1
	bgt	.L1641
	movw	r2, #65535
	cmp	r5, r2
	bne	.L1641
	ldrh	r2, [r8]
	cmp	r2, #3
	bhi	.L1641
	movs	r3, #0
	strh	r5, [r6]	@ movhi
	strh	r3, [r8]	@ movhi
.L1712:
	ldr	r3, .L1715+12
	ldrh	r0, [r3]
	b	.L1590
.L1641:
	cbnz	r1, .L1642
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r3, [r8]
	adds	r3, r3, #1
	strh	r3, [r8]	@ movhi
	b	.L1635
.L1642:
	movs	r2, #0
	strb	r2, [r6, #8]
	ldr	r2, .L1715+52
	ldrh	r2, [r2]
	cmp	r2, r3
	bne	.L1643
	mov	r2, #700
	ldr	r1, .L1715+56
	ldr	r0, .L1715+60
	bl	printf
.L1643:
	ldr	r3, .L1715+64
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1644
	movw	r2, #701
	ldr	r1, .L1715+56
	ldr	r0, .L1715+60
	bl	printf
.L1644:
	ldr	r3, .L1715+68
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1645
	movw	r2, #702
	ldr	r1, .L1715+56
	ldr	r0, .L1715+60
	bl	printf
.L1645:
	mov	r0, fp
	bl	make_superblock
	ldr	r2, .L1715+72
	movs	r3, #0
	ldrh	r1, [r6]
	strh	r3, [r2]	@ movhi
	ldr	r2, [sp, #16]
	ldr	r2, [r2]
	ldrh	r1, [r2, r1, lsl #1]
	ldr	r2, .L1715+76
	strh	r3, [r6, #2]	@ movhi
	strb	r3, [r6, #6]
	strh	r1, [r2]	@ movhi
.L1634:
	ldr	r3, .L1715+80
	movs	r2, #1
	str	r2, [r3]
	ldr	r3, .L1715+44
	ldrh	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, [sp, #8]
	cbz	r3, .L1646
	ldr	r3, .L1715+32
	ldr	r2, [sp, #20]
	ldrh	r1, [r6]
	ldrh	r3, [r3]
	muls	r3, r2, r3
	ldr	r2, .L1715+28
	ldr	r2, [r2]
	ldrh	r2, [r2, r1, lsl #1]
	subs	r3, r3, r2
	it	mi
	addmi	r3, r3, #3
	add	r4, r4, r3, asr #2
	uxth	r4, r4
.L1646:
	ldrh	r3, [r6, #2]
	ldr	r1, [sp, #20]
	adds	r2, r3, r4
	cmp	r2, r1
	itt	gt
	movgt	r2, r1
	subgt	r4, r2, r3
	mov	r3, #0
	it	gt
	uxthgt	r4, r4
.L1710:
	str	r3, [sp, #28]
	ldrh	r3, [sp, #28]
	cmp	r4, r3
	bls	.L1657
	ldr	r3, .L1715+32
	movw	lr, #65535
	ldrh	r1, [fp, #2]
	mov	ip, #20
	ldr	r7, .L1715+84
	ldrh	r8, [r3]
	ldr	r3, .L1715+88
	ldr	r0, [r3]
	ldr	r3, [sp, #28]
	adds	r3, r1, r3
	str	r3, [sp, #16]
	movs	r3, #0
	str	r3, [sp, #12]
	b	.L1658
.L1651:
	ldrh	r2, [r7, #2]!
	cmp	r2, lr
	beq	.L1650
	ldr	r1, [sp, #12]
	mla	r10, ip, r1, r0
	ldr	r1, [sp, #16]
	orr	r2, r1, r2, lsl #10
	str	r2, [r10, #4]
	ldr	r2, [sp, #12]
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #12]
.L1650:
	adds	r3, r3, #1
.L1658:
	uxth	r2, r3
	cmp	r8, r2
	bhi	.L1651
	ldrb	r2, [fp, #8]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	bl	FlashReadPages
	movs	r3, #0
.L1709:
	str	r3, [sp, #24]
	ldr	r2, [sp, #12]
	ldrh	r3, [sp, #24]
	cmp	r2, r3
	bhi	.L1656
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	b	.L1710
.L1716:
	.align	2
.L1715:
	.word	.LANCHOR87
	.word	.LANCHOR48
	.word	.LANCHOR82
	.word	.LANCHOR177
	.word	.LANCHOR61
	.word	.LANCHOR59
	.word	.LANCHOR78
	.word	.LANCHOR42
	.word	.LANCHOR3
	.word	.LANCHOR20
	.word	.LANCHOR99
	.word	.LANCHOR19
	.word	.LANCHOR96
	.word	.LANCHOR51
	.word	.LANCHOR180
	.word	.LC1
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR178
	.word	.LANCHOR179
	.word	.LANCHOR108
	.word	.LANCHOR80+14
	.word	.LANCHOR93
.L1656:
	ldr	r3, [sp, #24]
	movs	r7, #20
	muls	r7, r3, r7
	ldr	r3, .L1717
	ldr	r3, [r3]
	adds	r2, r3, r7
	ldr	r3, [r3, r7]
	adds	r3, r3, #1
	beq	.L1653
	ldr	r3, [r2, #12]
	ldrh	r2, [r3]
	str	r3, [sp, #16]
	movw	r3, #61589
	cmp	r2, r3
	bne	.L1653
	ldr	r3, [sp, #16]
	ldr	r8, [r3, #8]
	cmp	r8, #-1
	bne	.L1654
	mov	r2, #736
	ldr	r1, .L1717+4
	ldr	r0, .L1717+8
	bl	printf
.L1654:
	movs	r2, #0
	add	r1, sp, #44
	mov	r0, r8
	bl	log2phys
	ldr	r3, .L1717
	ldr	r1, [r3]
	ldr	r3, [sp, #44]
	add	r1, r1, r7
	ldr	r2, [r1, #4]
	cmp	r2, r3
	bne	.L1653
	ldr	r3, .L1717+12
	mov	r10, #20
	ldr	r2, .L1717+12
	ldr	r8, .L1717+32
	ldrh	r3, [r3]
	ldr	r1, [r1, #16]
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1717+16
	ldr	r3, [r8]
	ldr	r0, [r2]
	str	r2, [sp, #36]
	mla	r3, r10, r3, r0
	str	r1, [r3, #16]
	str	r3, [sp, #32]
	bl	Ftl_get_new_temp_ppa
	ldr	r3, [sp, #32]
	ldr	r2, [sp, #36]
	ldr	r1, [sp, #16]
	str	r0, [r3, #4]
	ldr	r2, [r2]
	ldr	r3, [r8]
	mla	r10, r10, r3, r2
	ldr	r2, .L1717
	adds	r3, r3, #1
	ldr	r0, [r2]
	add	r0, r0, r7
	ldr	r7, .L1717+20
	ldr	r2, [r0, #8]
	str	r2, [r10, #8]
	ldr	r2, [r0, #12]
	str	r2, [r10, #12]
	ldr	r2, [sp, #44]
	str	r2, [r1, #12]
	ldrh	r2, [r7]
	strh	r2, [r1, #2]	@ movhi
	ldr	r2, .L1717+24
	str	r3, [r8]
	ldr	r2, [r2]
	str	r2, [r1, #4]
	movs	r1, #1
	bl	FtlGcBufAlloc
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldr	r3, [r8]
	cmp	r2, r3
	beq	.L1655
	ldrh	r3, [r7, #4]
	cbnz	r3, .L1653
.L1655:
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L1653
	ldr	r3, .L1717+28
	movs	r2, #0
	str	r2, [r3]
	b	.L1712
.L1653:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	b	.L1709
.L1657:
	ldrh	r3, [fp, #2]
	add	r4, r4, r3
	ldr	r3, [sp, #20]
	uxth	r4, r4
	cmp	r3, r4
	strh	r4, [fp, #2]	@ movhi
	ldr	r4, .L1717+28
	bhi	.L1659
	ldr	r3, .L1717+32
	ldr	r3, [r3]
	cbz	r3, .L1660
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L1660
	movs	r3, #0
	str	r3, [r4]
	b	.L1712
.L1660:
	ldr	r3, .L1717+12
	ldrh	r1, [r3]
	cbnz	r1, .L1661
	ldr	r3, .L1717+36
	ldrh	r2, [fp]
	ldr	r3, [r3]
	ldrh	r0, [r3, r2, lsl #1]
	cbz	r0, .L1661
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [fp]
	bl	update_vpc_list
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1661:
	movw	r3, #65535
	strh	r3, [fp]	@ movhi
.L1659:
	movs	r3, #0
	str	r3, [r4]
	ldr	r3, .L1717+40
	ldrh	r3, [r3]
	cmp	r3, #2
	bhi	.L1662
	ldr	r3, .L1717+44
	ldrh	r4, [r3]
	b	.L1663
.L1662:
	ldr	r2, .L1717+48
	ldrh	r0, [r2]
	cmp	r0, #0
	bne	.L1590
	adds	r0, r3, #1
	b	.L1590
.L1667:
	movs	r0, #0
	b	.L1590
.L1596:
	ldr	r3, [sp, #8]
	cmp	r3, #0
	beq	.L1665
.L1606:
	ldr	r3, .L1717+20
	ldrh	r2, [r3]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1676
.L1666:
	ldr	r3, .L1717+52
	movw	r2, #65535
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L1676
	cmp	r5, r3
	bne	.L1676
	ldrh	r3, [r6]
	cmp	r3, r5
	beq	.L1618
.L1623:
	movw	r5, #65535
.L1676:
	movs	r4, #1
	b	.L1617
.L1598:
	ldr	r3, [sp, #8]
	cmp	r3, #0
	beq	.L1665
	movw	r5, #65535
	b	.L1666
.L1597:
	ldr	r3, [sp, #8]
	cmp	r3, #0
	bne	.L1623
	b	.L1665
.L1718:
	.align	2
.L1717:
	.word	.LANCHOR93
	.word	.LANCHOR180
	.word	.LC1
	.word	.LANCHOR178
	.word	.LANCHOR113
	.word	.LANCHOR53
	.word	.LANCHOR71
	.word	.LANCHOR108
	.word	.LANCHOR89
	.word	.LANCHOR42
	.word	.LANCHOR48
	.word	.LANCHOR19
	.word	.LANCHOR177
	.word	.LANCHOR99
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
	.section	.text.sftl_init,"ax",%progbits
	.align	1
	.global	sftl_init
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sftl_init, %function
sftl_init:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r3, #-1
	ldr	r4, .L1725
	ldr	r1, .L1725+4
	ldr	r0, .L1725+8
	str	r3, [r4]
	bl	printf
	ldr	r0, .L1725+12
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	ldr	r3, .L1725+16
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbnz	r0, .L1723
	bl	FtlSysBlkInit
	cbnz	r0, .L1723
	movs	r3, #1
	str	r3, [r4]
	ldr	r3, .L1725+20
	ldrh	r3, [r3]
	cmp	r3, #15
	bhi	.L1723
	movw	r4, #8129
.L1722:
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	subs	r4, r4, #1
	bne	.L1722
.L1723:
	movs	r0, #0
	pop	{r4, pc}
.L1726:
	.align	2
.L1725:
	.word	.LANCHOR86
	.word	.LC70
	.word	.LC71
	.word	.LANCHOR0
	.word	.LANCHOR4
	.word	.LANCHOR48
	.size	sftl_init, .-sftl_init
	.section	.text.sftl_gc,"ax",%progbits
	.align	1
	.global	sftl_gc
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sftl_gc, %function
sftl_gc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	movs	r1, #1
	mov	r0, r1
	b	rk_ftl_garbage_collect
	.size	sftl_gc, .-sftl_gc
	.section	.text.FtlRead,"ax",%progbits
	.align	1
	.global	FtlRead
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlRead, %function
FtlRead:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r0, #16
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #56
	mov	r6, r1
	mov	r8, r3
	str	r2, [sp, #24]
	bne	.L1729
	mov	r2, r3
	ldr	r1, [sp, #24]
	add	r0, r6, #256
	bl	FtlVendorPartRead
	str	r0, [sp, #4]
.L1728:
	ldr	r0, [sp, #4]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1729:
	ldr	r3, [sp, #24]
	adds	r3, r1, r3
	str	r3, [sp, #12]
	ldr	r3, .L1761
	ldr	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L1750
	ldr	r3, .L1761+4
	ldr	r3, [r3]
	adds	r4, r3, #1
	beq	.L1751
	ldr	r3, .L1761+8
	mov	r0, r6
	movs	r7, #0
	mov	r5, r7
	ldrh	r4, [r3]
	mov	r1, r4
	bl	__aeabi_uidiv
	ldr	r3, [sp, #12]
	mov	r1, r4
	str	r0, [sp, #16]
	subs	r0, r3, #1
	bl	__aeabi_uidiv
	ldr	r3, [sp, #16]
	ldr	r2, .L1761+12
	ldr	r1, [sp, #24]
	rsb	r3, r3, #1
	ldr	r4, [sp, #16]
	add	r3, r3, r0
	str	r0, [sp, #20]
	str	r3, [sp, #8]
	ldr	r3, [r2]
	str	r7, [sp, #32]
	str	r7, [sp, #28]
	add	r3, r3, r1
	ldr	r1, [sp, #8]
	str	r3, [r2]
	ldr	r2, .L1761+16
	str	r7, [sp, #4]
	ldr	r3, [r2]
	add	r3, r3, r1
	str	r3, [r2]
.L1731:
	ldr	r3, [sp, #8]
	cbnz	r3, .L1748
	ldr	r3, .L1761+20
	ldrh	r3, [r3]
	cbnz	r3, .L1749
	ldr	r3, .L1761+24
	ldrh	r3, [r3]
	cmp	r3, #31
	bhi	.L1728
.L1749:
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	b	.L1728
.L1748:
	movs	r2, #0
	add	r1, sp, #52
	mov	r0, r4
	bl	log2phys
	ldr	r3, [sp, #52]
	adds	r0, r3, #1
	bne	.L1732
	ldr	fp, .L1761+8
	mov	r10, #0
.L1733:
	ldrh	r0, [fp]
	cmp	r10, r0
	bcc	.L1735
.L1736:
	ldr	r3, [sp, #8]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #8]
	beq	.L1740
	ldr	r3, .L1761+28
	ldrh	r3, [r3]
	cmp	r5, r3, lsl #2
	bne	.L1731
.L1740:
	cmp	r5, #0
	beq	.L1731
	ldr	r3, .L1761+32
	movs	r2, #0
	mov	r1, r5
	mov	r10, #0
	ldr	r0, [r3]
	bl	FlashReadPages
	lsls	r3, r7, #9
	str	r3, [sp, #44]
	ldr	r3, [sp, #28]
	lsls	r3, r3, #9
	str	r3, [sp, #36]
	ldr	r3, [sp, #32]
	lsls	r3, r3, #9
	str	r3, [sp, #40]
.L1747:
	movs	r3, #20
	mul	fp, r3, r10
	ldr	r3, .L1761+32
	ldr	r2, [r3]
	ldr	r3, [sp, #16]
	add	r2, r2, fp
	ldr	r1, [r2, #16]
	cmp	r3, r1
	bne	.L1742
	ldr	r1, [r2, #8]
	ldr	r2, .L1761+36
	ldr	r2, [r2]
	cmp	r1, r2
	bne	.L1743
	ldr	r3, [sp, #36]
	mov	r0, r8
	ldr	r2, [sp, #40]
	add	r1, r1, r3
.L1760:
	bl	ftl_memcpy
.L1743:
	ldr	r3, .L1761+32
	ldr	r3, [r3]
	add	r2, r3, fp
	ldr	r3, [r3, fp]
	ldr	r0, [r2, #12]
	ldr	r1, [r2, #16]
	ldr	r0, [r0, #8]
	cmp	r1, r0
	itttt	ne
	ldrne	r0, .L1761+40
	ldrne	r1, [r0, #72]
	addne	r1, r1, #1
	strne	r1, [r0, #72]
	adds	r1, r3, #1
	bne	.L1745
	ldr	r1, .L1761+40
	str	r3, [sp, #4]
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L1746:
	add	r10, r10, #1
	cmp	r5, r10
	bne	.L1747
	movs	r5, #0
	b	.L1731
.L1735:
	mla	r0, r0, r4, r10
	cmp	r6, r0
	bhi	.L1734
	ldr	r3, [sp, #12]
	cmp	r3, r0
	bls	.L1734
	subs	r0, r0, r6
	mov	r2, #512
	movs	r1, #0
	add	r0, r8, r0, lsl #9
	bl	ftl_memset
.L1734:
	add	r10, r10, #1
	b	.L1733
.L1732:
	ldr	r2, .L1761+32
	mov	r10, #20
	ldr	r2, [r2]
	mla	r10, r10, r5, r2
	str	r3, [r10, #4]
	ldr	r3, [sp, #16]
	cmp	r4, r3
	ldr	r3, .L1761+8
	bne	.L1737
	ldr	r2, .L1761+36
	mov	r0, r6
	ldrh	fp, [r3]
	ldr	r2, [r2]
	mov	r1, fp
	str	r2, [r10, #8]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #24]
	sub	r3, fp, r1
	str	r1, [sp, #28]
	cmp	r3, r2
	it	cs
	movcs	r3, r2
	cmp	fp, r3
	str	r3, [sp, #32]
	bne	.L1738
	str	r8, [r10, #8]
.L1738:
	ldr	r3, .L1761+44
	ldr	r2, .L1761+48
	str	r4, [r10, #16]
	ldrh	r3, [r3]
	ldr	r2, [r2]
	muls	r3, r5, r3
	adds	r5, r5, #1
	bic	r3, r3, #3
	add	r3, r3, r2
	str	r3, [r10, #12]
	b	.L1736
.L1737:
	ldr	r2, [sp, #20]
	cmp	r4, r2
	bne	.L1739
	ldr	r2, .L1761+52
	ldr	r1, [sp, #12]
	ldr	r2, [r2]
	str	r2, [r10, #8]
	ldrh	r2, [r3]
	mul	r3, r2, r4
	subs	r7, r1, r3
	cmp	r2, r7
	bne	.L1738
.L1759:
	subs	r3, r3, r6
	add	r3, r8, r3, lsl #9
	str	r3, [r10, #8]
	b	.L1738
.L1739:
	ldrh	r3, [r3]
	muls	r3, r4, r3
	b	.L1759
.L1742:
	ldr	r3, [sp, #20]
	cmp	r3, r1
	bne	.L1743
	ldr	r3, .L1761+52
	ldr	r1, [r2, #8]
	ldr	r2, [r3]
	cmp	r1, r2
	bne	.L1743
	ldr	r2, .L1761+8
	ldr	r3, [sp, #20]
	ldrh	r0, [r2]
	ldr	r2, [sp, #44]
	muls	r0, r3, r0
	subs	r0, r0, r6
	add	r0, r8, r0, lsl #9
	b	.L1760
.L1745:
	cmp	r3, #256
	bne	.L1746
	ldr	r0, [r2, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	b	.L1746
.L1750:
	mov	r3, #-1
.L1751:
	str	r3, [sp, #4]
	b	.L1728
.L1762:
	.align	2
.L1761:
	.word	.LANCHOR34
	.word	.LANCHOR86
	.word	.LANCHOR12
	.word	.LANCHOR69
	.word	.LANCHOR62
	.word	.LANCHOR101
	.word	.LANCHOR48
	.word	.LANCHOR3
	.word	.LANCHOR112
	.word	.LANCHOR118
	.word	.LANCHOR81
	.word	.LANCHOR24
	.word	.LANCHOR124
	.word	.LANCHOR119
	.size	FtlRead, .-FtlRead
	.section	.text.sftl_read,"ax",%progbits
	.align	1
	.global	sftl_read
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sftl_read, %function
sftl_read:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, r2
	mov	r2, r1
	mov	r1, r0
	movs	r0, #0
	b	FtlRead
	.size	sftl_read, .-sftl_read
	.section	.text.FtlWrite,"ax",%progbits
	.align	1
	.global	FtlWrite
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlWrite, %function
FtlWrite:
	@ args = 0, pretend = 0, frame = 72
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r0, #16
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #72
	str	r1, [sp, #4]
	str	r2, [sp, #20]
	str	r3, [sp, #16]
	bne	.L1765
	mov	r2, r3
	ldr	r3, [sp, #4]
	ldr	r1, [sp, #20]
	add	r0, r3, #256
	bl	FtlVendorPartWrite
.L1764:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1765:
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #20]
	adds	r4, r3, r2
	ldr	r3, .L1816
	ldr	r3, [r3]
	cmp	r4, r3
	bhi	.L1802
	ldr	r3, .L1816+4
	ldr	r0, [r3]
	adds	r5, r0, #1
	beq	.L1764
	ldr	r3, .L1816+8
	mov	r2, #2048
	ldr	r0, [sp, #4]
	str	r2, [r3]
	ldr	r3, .L1816+12
	ldrh	r5, [r3]
	mov	r1, r5
	bl	__aeabi_uidiv
	mov	r1, r5
	str	r0, [sp, #12]
	subs	r0, r4, #1
	ldr	r5, .L1816+16
	bl	__aeabi_uidiv
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #20]
	str	r0, [sp, #28]
	subs	r3, r0, r2
	ldr	r2, .L1816+20
	str	r3, [sp, #32]
	adds	r3, r3, #1
	str	r3, [sp, #8]
	ldr	r3, [r2]
	add	r3, r3, r1
	ldr	r1, [sp, #8]
	str	r3, [r2]
	ldr	r2, .L1816+24
	ldr	r3, [r2]
	add	r3, r3, r1
	str	r3, [r2]
	ldr	r3, .L1816+28
	ldr	r3, [r3]
	cbz	r3, .L1767
	ldrh	r2, [r5, #4]
	ldr	r3, .L1816+32
	cmp	r2, #0
	it	eq
	moveq	r5, r3
.L1767:
	ldr	r6, [sp, #12]
.L1768:
	ldr	r3, [sp, #8]
	cbnz	r3, .L1797
	ldr	r5, .L1816+36
	mov	r0, r3
	ldr	r1, [sp, #32]
	bl	rk_ftl_garbage_collect
	ldrh	r2, [r5]
	cmp	r2, #5
	bls	.L1798
.L1800:
	movs	r0, #0
	b	.L1764
.L1797:
	ldr	r3, .L1816+40
	ldrb	r2, [r5, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1769
	movw	r2, #1011
	ldr	r1, .L1816+44
	ldr	r0, .L1816+48
	bl	printf
.L1769:
	ldrh	r2, [r5, #4]
	cbnz	r2, .L1770
	ldr	r3, .L1816+16
	ldr	r4, .L1816+28
	cmp	r5, r3
	bne	.L1771
	ldr	r0, .L1816+32
	ldrh	r5, [r0, #4]
	cbnz	r5, .L1772
	bl	allocate_new_data_superblock
	str	r5, [r4]
.L1772:
	ldr	r0, .L1816+16
	bl	allocate_new_data_superblock
	ldr	r5, .L1816+16
	ldr	r2, [r4]
	ldr	r3, .L1816+32
	cmp	r2, #0
	it	ne
	movne	r5, r3
.L1773:
	ldrh	r3, [r5, #4]
	cbnz	r3, .L1770
	mov	r0, r5
	bl	allocate_new_data_superblock
.L1770:
	ldrh	r2, [r5, #4]
	ldr	r3, [sp, #8]
	cmp	r2, r3
	it	cs
	movcs	r2, r3
	ldrb	r3, [r5, #7]	@ zero_extendqisi2
	lsls	r3, r3, #2
	cmp	r2, r3
	it	cs
	movcs	r2, r3
	ldr	r3, .L1816+40
	str	r2, [sp, #44]
	ldrb	r2, [r5, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1774
	movw	r2, #1044
	ldr	r1, .L1816+44
	ldr	r0, .L1816+48
	bl	printf
.L1774:
	ldr	r8, .L1816+52
	mov	fp, #0
.L1775:
	ldr	r3, [sp, #44]
	cmp	fp, r3
	bne	.L1795
.L1776:
	ldr	r0, .L1816+52
	mov	r3, r5
	movs	r2, #0
	mov	r1, fp
	ldr	r0, [r0]
	bl	FtlProgPages
	ldr	r3, [sp, #8]
	cmp	fp, r3
	bls	.L1796
	movw	r2, #1121
	ldr	r1, .L1816+44
	ldr	r0, .L1816+48
	bl	printf
.L1796:
	ldr	r3, [sp, #8]
	sub	r3, r3, fp
	str	r3, [sp, #8]
	b	.L1768
.L1771:
	str	r2, [r4]
	ldrh	r2, [r3, #4]
	cbnz	r2, .L1807
	mov	r0, r5
	bl	allocate_new_data_superblock
	b	.L1773
.L1807:
	mov	r5, r3
	b	.L1770
.L1795:
	ldrh	r2, [r5, #4]
	cmp	r2, #0
	beq	.L1776
	movs	r2, #0
	add	r1, sp, #48
	mov	r0, r6
	movs	r7, #20
	bl	log2phys
	mov	r0, r5
	mul	r7, r7, fp
	bl	get_new_active_ppa
	ldr	r3, .L1816+56
	ldr	r1, [r8]
	ldrh	r2, [r3]
	add	r1, r1, r7
	str	r0, [r1, #4]
	str	r6, [r1, #16]
	mul	r0, r2, fp
	bic	r3, r0, #3
	ldr	r0, .L1816+60
	str	r3, [sp, #36]
	ldr	r3, [r0]
	ldr	r0, [sp, #36]
	str	r3, [sp, #40]
	add	r10, r3, r0
	str	r10, [r1, #12]
	mov	r0, r10
	movs	r1, #0
	bl	ftl_memset
	ldr	r3, [sp, #12]
	ldr	r2, .L1816+12
	cmp	r6, r3
	beq	.L1777
	ldr	r3, [sp, #28]
	cmp	r6, r3
	bne	.L1812
	ldrh	r2, [r2]
	ldr	r3, [sp, #4]
	ldr	r1, [sp, #20]
	smulbb	r2, r2, r6
	adds	r4, r3, r1
	movs	r3, #0
	subs	r4, r4, r2
	str	r3, [sp, #24]
	uxth	r4, r4
	b	.L1780
.L1777:
	ldrh	r4, [r2]
	ldr	r0, [sp, #4]
	mov	r1, r4
	bl	__aeabi_uidivmod
	ldr	r3, [sp, #20]
	subs	r4, r4, r1
	str	r1, [sp, #24]
	cmp	r4, r3
	it	cs
	movcs	r4, r3
.L1780:
	ldr	r2, .L1816+12
	ldr	r3, [sp, #12]
	ldrh	r2, [r2]
	cmp	r4, r2
	ldr	r2, [r8]
	bne	.L1781
	cmp	r6, r3
	add	r7, r7, r2
	ittet	ne
	mulne	r4, r4, r6
	ldrne	r3, [sp, #4]
	ldreq	r3, [sp, #16]
	subne	r4, r4, r3
	itett	ne
	ldrne	r3, [sp, #16]
	streq	r3, [r7, #8]
	addne	r4, r3, r4, lsl #9
	strne	r4, [r7, #8]
.L1783:
	ldr	r3, .L1816+40
	ldrb	r1, [r5, #6]	@ zero_extendqisi2
	ldrh	r2, [r3]
	cmp	r1, r2
	bcc	.L1792
	mov	r2, #1112
	ldr	r1, .L1816+44
	ldr	r0, .L1816+48
	bl	printf
.L1792:
	ldr	r3, [sp, #40]
	movw	r2, #61589
	ldr	r1, [sp, #36]
	add	fp, fp, #1
	strh	r2, [r3, r1]	@ movhi
	ldr	r1, .L1816+64
	str	r6, [r10, #8]
	adds	r6, r6, #1
	ldr	r2, [r1]
	str	r2, [r10, #4]
	adds	r2, r2, #1
	adds	r3, r2, #1
	it	eq
	moveq	r2, #0
	str	r2, [r1]
	ldr	r2, [sp, #48]
	str	r2, [r10, #12]
	ldrh	r2, [r5]
	strh	r2, [r10, #2]	@ movhi
	b	.L1775
.L1817:
	.align	2
.L1816:
	.word	.LANCHOR34
	.word	.LANCHOR86
	.word	.LANCHOR181
	.word	.LANCHOR12
	.word	.LANCHOR51
	.word	.LANCHOR68
	.word	.LANCHOR64
	.word	.LANCHOR182
	.word	.LANCHOR52
	.word	.LANCHOR48
	.word	.LANCHOR3
	.word	.LANCHOR183
	.word	.LC1
	.word	.LANCHOR114
	.word	.LANCHOR24
	.word	.LANCHOR124
	.word	.LANCHOR71
.L1781:
	cmp	r6, r3
	add	r2, r2, r7
	ite	eq
	ldreq	r1, .L1818
	ldrne	r1, .L1818+4
	ldr	r1, [r1]
	str	r1, [r2, #8]
	ldr	r2, [sp, #48]
	adds	r1, r2, #1
	beq	.L1786
	str	r2, [sp, #56]
	add	r0, sp, #52
	ldr	r2, [r8]
	str	r6, [sp, #68]
	add	r2, r2, r7
	ldr	r1, [r2, #8]
	ldr	r2, [r2, #12]
	str	r1, [sp, #60]
	movs	r1, #1
	str	r2, [sp, #64]
	movs	r2, #0
	bl	FlashReadPages
	ldr	r2, [sp, #52]
	adds	r2, r2, #1
	bne	.L1787
	ldr	r1, .L1818+8
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L1790:
	ldr	r3, [sp, #12]
	lsls	r2, r4, #9
	cmp	r6, r3
	bne	.L1791
	ldr	r1, [r8]
	ldr	r3, [sp, #24]
	add	r7, r7, r1
	ldr	r1, [sp, #16]
	ldr	r0, [r7, #8]
	add	r0, r0, r3, lsl #9
.L1814:
	bl	ftl_memcpy
	b	.L1783
.L1787:
	ldr	r1, [r10, #8]
	cmp	r6, r1
	beq	.L1789
	ldr	r0, .L1818+8
	ldr	r2, [r0, #72]
	adds	r2, r2, #1
	str	r2, [r0, #72]
	mov	r2, r6
	ldr	r0, .L1818+12
	bl	printf
.L1789:
	ldr	r2, [r10, #8]
	cmp	r6, r2
	beq	.L1790
	movw	r2, #1097
	ldr	r1, .L1818+16
	ldr	r0, .L1818+20
	bl	printf
	b	.L1790
.L1786:
	ldr	r2, [r8]
	movs	r1, #0
	adds	r0, r2, r7
	ldr	r2, .L1818+24
	ldr	r0, [r0, #8]
	ldrh	r2, [r2]
	bl	ftl_memset
	b	.L1790
.L1791:
	ldr	r1, .L1818+28
	ldr	r3, [sp, #4]
	ldr	r0, [r8]
	ldrh	r1, [r1]
	add	r7, r7, r0
	ldr	r0, [r7, #8]
	muls	r1, r6, r1
	subs	r1, r1, r3
	ldr	r3, [sp, #16]
	add	r1, r3, r1, lsl #9
	b	.L1814
.L1812:
	ldrh	r2, [r2]
	ldr	r3, [sp, #4]
	ldr	r1, [r8]
	muls	r2, r6, r2
	add	r7, r7, r1
	subs	r2, r2, r3
	ldr	r3, [sp, #16]
	add	r2, r3, r2, lsl #9
	str	r2, [r7, #8]
	b	.L1783
.L1798:
	ldr	r6, .L1818+32
	mov	r4, #256
	ldr	r7, .L1818+36
.L1801:
	ldrh	r3, [r6]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L1799
	ldrh	r2, [r7]
	cmp	r2, r3
	bne	.L1799
	movs	r0, #0
	bl	List_get_gc_head_node
	uxth	r0, r0
	bl	FtlGcRefreshBlock
.L1799:
	ldr	r2, .L1818+40
	movs	r3, #128
	movs	r1, #1
	mov	r0, r1
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1818+44
	strh	r3, [r2]	@ movhi
	bl	rk_ftl_garbage_collect
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	ldrh	r3, [r5]
	cmp	r3, #2
	bhi	.L1800
	subs	r4, r4, #1
	bne	.L1801
	b	.L1800
.L1802:
	mov	r0, #-1
	b	.L1764
.L1819:
	.align	2
.L1818:
	.word	.LANCHOR118
	.word	.LANCHOR119
	.word	.LANCHOR81
	.word	.LC113
	.word	.LANCHOR183
	.word	.LC1
	.word	.LANCHOR23
	.word	.LANCHOR12
	.word	.LANCHOR80
	.word	.LANCHOR99
	.word	.LANCHOR83
	.word	.LANCHOR82
	.size	FtlWrite, .-FtlWrite
	.global	__aeabi_idivmod
	.section	.text.sftl_write,"ax",%progbits
	.align	1
	.global	sftl_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sftl_write, %function
sftl_write:
	@ args = 0, pretend = 0, frame = 128
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	adds	r4, r0, r1
	subs	r5, r4, #1
	sub	sp, sp, #136
	cmp	r5, #63
	mov	fp, r0
	str	r1, [sp, #24]
	str	r2, [sp, #44]
	bls	.L1821
	cmp	r0, #576
	bls	.L1822
.L1821:
	ldr	r3, .L1863
	ldr	r3, [r3]
	cbz	r3, .L1823
	ldr	r3, .L1863+4
	ldr	r10, [r3]
	ldr	r3, .L1863+8
	ldr	r2, [r10]
	cmp	r2, r3
	beq	.L1824
.L1841:
	ldr	r3, .L1863
	movs	r2, #0
	str	r2, [r3]
	ldr	r3, .L1863+4
	ldr	r0, [r3]
	bl	free
	ldr	r3, .L1863+12
	ldr	r0, [r3]
	bl	free
.L1823:
	ldr	r3, [sp, #44]
	mov	r1, fp
	ldr	r2, [sp, #24]
	movs	r0, #0
	bl	FtlWrite
	add	sp, sp, #136
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1824:
	ldr	r3, .L1863+16
	add	r0, r10, #262144
	movw	r2, #65535
	ldrh	r4, [r3, #14]
	ldrh	r5, [r3, #10]
	movs	r3, #0
.L1828:
	ldr	r1, [r0, #-4]
	cbnz	r1, .L1825
	ldr	r1, [r10, r3, lsl #2]
	adds	r3, r3, #1
	cmp	r3, #4096
	add	r2, r2, #-1
	it	hi
	movhi	r3, #0
	cmp	r2, #4096
	str	r1, [r0, #-4]!
	bne	.L1828
	mov	r3, #512
	str	r3, [sp, #12]
	b	.L1827
.L1825:
	add	r3, r2, #127
	ldr	r0, .L1863+20
	lsrs	r3, r3, #7
	str	r3, [sp, #12]
	bl	printf
.L1827:
	uxtb	r4, r4
	mov	r8, #0
	smulbb	r5, r4, r5
	uxth	r3, r5
	ldr	r5, .L1863+24
	str	r3, [sp, #16]
	subs	r0, r3, #1
	mov	r1, r3
	ldr	r3, [sp, #12]
	add	r0, r0, r3
	bl	__aeabi_uidiv
	ldr	r2, [sp, #16]
	mov	r3, r0
	str	r0, [sp, #20]
	str	r0, [sp, #40]
	str	r8, [sp, #32]
	muls	r3, r2, r3
	str	r3, [sp, #28]
	ldr	r3, [sp, #12]
	lsls	r3, r3, #7
	str	r3, [sp, #56]
	b	.L1840
.L1848:
	str	r3, [sp, #40]
.L1840:
	ldr	r3, .L1863+12
	mov	r2, #512
	movs	r1, #0
	ldr	r0, [r3]
	bl	memset
	ldr	r3, .L1863+16
	mov	r0, r8
	ldrh	r7, [r3, #14]
	mov	r1, r7
	uxtb	r6, r7
	uxth	r3, r6
	str	r3, [sp, #36]
	ldr	r3, .L1863+16
	ldrh	r4, [r3, #10]
	ldrh	r3, [sp, #36]
	smulbb	r4, r4, r3
	bl	__aeabi_uidiv
	ldr	r3, [r5, #4]
	mov	r1, r0
	movs	r0, #0
	uxth	r4, r4
	blx	r3
	ldr	r3, [sp, #28]
	cmp	r3, r4
	bls	.L1829
	mov	r1, r7
	add	r0, r4, r8
	bl	__aeabi_uidiv
	ldr	r3, [r5, #4]
	mov	r1, r0
	movs	r0, #0
	blx	r3
.L1829:
	mov	r1, r4
	mov	r0, r8
	movs	r4, #0
	bl	__aeabi_uidivmod
	sub	r3, r8, r1
	str	r1, [sp, #48]
	str	r3, [sp, #52]
.L1830:
	ldr	r3, [sp, #28]
	cmp	r3, r4
	bhi	.L1831
	ldr	r3, .L1863+12
	mov	r0, r8
	movs	r4, #0
	ldr	r3, [r3]
	str	r3, [sp, #52]
	ldr	r3, .L1863+16
	ldrb	r7, [r3, #14]	@ zero_extendqisi2
	uxth	r3, r7
	str	r3, [sp, #48]
	ldr	r3, .L1863+16
	ldrh	r1, [r3, #10]
	ldrh	r3, [sp, #48]
	smulbb	r1, r1, r3
	uxth	r1, r1
	bl	__aeabi_uidivmod
	str	r1, [sp, #36]
	sub	r3, r8, r1
	ldrh	r0, [sp, #36]
	mov	r1, r7
	str	r3, [sp, #60]
	bl	__aeabi_idivmod
	uxth	r6, r1
.L1832:
	ldr	r3, [sp, #12]
	cmp	r4, r3
	bcs	.L1836
	ldr	r3, [sp, #48]
	mov	r1, r7
	subs	r3, r3, r6
	uxth	r3, r3
	str	r3, [sp, #64]
	ldr	r3, [sp, #52]
	add	r2, r3, r4, lsl #9
	ldr	r3, [sp, #36]
	str	r2, [sp, #68]
	adds	r0, r3, r4
	bl	__aeabi_uidiv
	ldr	r3, [sp, #60]
	uxth	r0, r0
	mov	r1, r7
	add	r6, r6, r3
	mla	r0, r7, r0, r6
	bl	__aeabi_uidiv
	ldr	r6, [r5, #12]
	mov	r1, r0
	add	r3, sp, #72
	ldr	r2, [sp, #68]
	movs	r0, #0
	blx	r6
	adds	r0, r0, #1
	bne	.L1833
.L1836:
	ldr	r3, .L1863+12
	mov	r1, r10
	movs	r4, #0
	ldr	r0, [r3]
.L1834:
	mov	r7, r1
	ldr	r2, [r0, r4, lsl #2]
	ldr	r3, [r7]
	lsls	r6, r4, #2
	adds	r1, r1, #4
	cmp	r2, r3
	beq	.L1837
	mov	r2, #512
	movs	r1, #0
	bl	memset
	ldr	r3, .L1863+12
	mov	r1, r8
	ldr	r0, .L1863+28
	ldr	r2, [r3]
	str	r4, [sp]
	ldr	r3, [r7]
	ldr	r2, [r2, r6]
	bl	printf
	ldr	r3, [r5, #4]
	mov	r1, r8
	movs	r0, #0
	blx	r3
	ldr	r3, [sp, #20]
	cmp	r3, #1
	bls	.L1847
	ldr	r2, [sp, #16]
	movs	r0, #0
	ldr	r3, [r5, #4]
	add	r1, r2, r8
	blx	r3
.L1847:
	ldr	r2, [sp, #40]
	ldr	r3, [sp, #20]
	add	r3, r3, r2
	ldr	r2, [sp, #28]
	add	r8, r8, r2
	ldr	r2, [sp, #40]
	cmp	r2, #15
	bls	.L1848
	b	.L1841
.L1831:
	ldr	r3, [sp, #48]
	mov	r1, r6
	adds	r0, r3, r4
	bl	__aeabi_uidiv
	uxth	r3, r0
	add	r2, r10, r4, lsl #9
	ldr	r0, [sp, #52]
	mov	r7, r3
	muls	r3, r6, r3
	mov	r1, r6
	str	r2, [sp, #60]
	str	r3, [sp, #72]
	movw	r3, #61424
	str	r3, [sp, #76]
	bl	__aeabi_uidiv
	add	r3, sp, #72
	adds	r1, r0, r7
	ldr	r2, [sp, #60]
	movs	r0, #0
	ldr	r7, [r5, #8]
	blx	r7
	ldr	r3, [sp, #36]
	add	r4, r4, r3
	uxth	r4, r4
	b	.L1830
.L1833:
	ldr	r3, [sp, #64]
	movs	r6, #0
	add	r3, r3, r4
	uxth	r4, r3
	b	.L1832
.L1837:
	ldr	r3, [sp, #56]
	adds	r4, r4, #1
	cmp	r4, r3
	bne	.L1834
	ldr	r3, [sp, #32]
	adds	r3, r3, #1
	cmp	r3, #5
	str	r3, [sp, #32]
	bls	.L1847
	b	.L1841
.L1822:
	cmp	r0, #64
	ldr	r6, .L1863+4
	bne	.L1842
	mov	r0, #262144
	bl	ftl_malloc
	str	r0, [r6]
	mov	r0, #262144
	bl	ftl_malloc
	ldr	r3, .L1863+12
	str	r0, [r3]
	ldr	r3, [r6]
	cbz	r3, .L1843
	cbz	r0, .L1843
	ldr	r2, .L1863
	movs	r1, #1
	mov	r0, r3
	str	r1, [r2]
	mov	r2, #262144
	movs	r1, #0
	bl	ftl_memset
.L1842:
	cmp	fp, #63
	ldr	r0, [r6]
	bhi	.L1844
	ldr	r3, [sp, #24]
	rsb	r1, fp, #64
	subs	r2, r3, r1
	ldr	r3, [sp, #44]
	add	r1, r3, r1, lsl #9
.L1845:
	cmp	r5, #576
	ittt	hi
	subhi	r2, r2, r4
	mvnhi	r3, #446
	addhi	r2, r2, r3
	lsls	r2, r2, #9
	bl	ftl_memcpy
	b	.L1823
.L1864:
	.align	2
.L1863:
	.word	.LANCHOR184
	.word	.LANCHOR185
	.word	-52655045
	.word	.LANCHOR186
	.word	.LANCHOR0
	.word	.LC114
	.word	.LANCHOR105
	.word	.LC115
.L1843:
	ldr	r1, .L1865
	ldr	r0, .L1865+4
	bl	printf
	b	.L1842
.L1844:
	ldr	r3, .L1865+8
	ldr	r1, [sp, #44]
	ldr	r2, [sp, #24]
	add	r3, r3, fp
	add	r0, r0, r3, lsl #9
	b	.L1845
.L1866:
	.align	2
.L1865:
	.word	.LANCHOR187
	.word	.LC116
	.word	8388544
	.size	sftl_write, .-sftl_write
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
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r7, .L1886
	bl	FtlBbtMemInit
	sub	r8, r7, #18
	bl	FtlLoadFactoryBbt
.L1868:
	ldr	r3, .L1886+4
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L1874
	ldr	r5, .L1886+8
	movs	r4, #0
.L1875:
	ldrh	r3, [r5]
	uxth	r0, r4
	adds	r4, r4, #1
	cmp	r3, r0
	bhi	.L1876
	ldr	r4, .L1886+12
	movw	r6, #65535
	ldrh	r5, [r4, #12]
	subs	r5, r5, #1
	uxth	r5, r5
.L1877:
	ldrh	r3, [r4, #12]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L1881
	mov	r0, r5
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L1878
	mov	r0, r5
	bl	FlashTestBlk
	cmp	r0, #0
	beq	.L1879
	mov	r0, r5
	bl	FtlBbmMapBadBlock
.L1878:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L1877
.L1874:
	ldr	r3, .L1886+16
	ldr	r5, .L1886+20
	ldrh	r2, [r8, #2]!
	ldr	r4, .L1886+24
	ldr	r0, [r3]
	movw	r3, #65535
	ldr	r10, [r5]
	cmp	r2, r3
	mov	fp, r4
	ldr	r3, .L1886+28
	str	r0, [r4, #8]
	str	r10, [r4, #12]
	beq	.L1869
	ldrh	r5, [r3]
	mov	r0, r4
	str	r3, [sp]
	mla	r5, r6, r5, r2
	lsls	r2, r5, #10
	str	r2, [r4, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r3, [sp]
	ldr	r1, [r4, #8]
	ldr	r0, [r7]
	ldrh	r2, [r3]
	adds	r2, r2, #7
	asrs	r2, r2, #3
	bl	ftl_memcpy
.L1870:
	uxth	r0, r5
	adds	r6, r6, #1
	adds	r7, r7, #4
	bl	FtlBbmMapBadBlock
	b	.L1868
.L1869:
	mov	r1, r6
	str	r3, [sp]
	bl	FlashGetBadBlockList
	ldr	r0, [r4, #8]
	ldr	r1, [r7]
	bl	FtlBbt2Bitmap
	ldr	r3, [sp]
	str	r5, [sp, #4]
	ldrh	r4, [r3]
	subs	r4, r4, #1
	uxth	r4, r4
.L1871:
	ldr	r3, [sp]
	ldrh	r0, [r3]
	smlabb	r0, r0, r6, r4
	uxth	r0, r0
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L1872
	ldr	r3, [sp, #4]
	movs	r2, #16
	movs	r1, #0
	strh	r4, [r8]	@ movhi
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L1886+16
	mov	r2, #4096
	movs	r1, #0
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [sp]
	movw	r3, #61664
	strh	r3, [r10]	@ movhi
	movs	r3, #0
	str	r3, [r10, #4]
	ldrh	r5, [r2]
	ldrh	r3, [r8]
	ldr	r1, [r7]
	ldr	r0, [fp, #8]
	strh	r3, [r10, #2]	@ movhi
	mla	r5, r6, r5, r3
	lsls	r3, r5, #10
	str	r3, [fp, #4]
	ldr	r3, .L1886+32
	ldrh	r2, [r3]
	lsls	r2, r2, #2
	bl	ftl_memcpy
	movs	r2, #1
	ldr	r0, .L1886+24
	mov	r1, r2
	bl	FlashEraseBlocks
	movs	r3, #1
	ldr	r0, .L1886+24
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r3, [fp]
	adds	r3, r3, #1
	bne	.L1870
	uxth	r0, r5
	bl	FtlBbmMapBadBlock
	b	.L1871
.L1872:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L1871
.L1876:
	bl	FtlBbmMapBadBlock
	b	.L1875
.L1879:
	ldrh	r3, [r4]
	cmp	r3, r6
	bne	.L1880
	strh	r5, [r4]	@ movhi
	b	.L1878
.L1880:
	strh	r5, [r4, #4]	@ movhi
.L1881:
	ldr	r3, .L1886+36
	movs	r5, #0
	str	r5, [r4, #8]
	movs	r1, #1
	movs	r2, #2
	strh	r5, [r4, #2]	@ movhi
	ldr	r0, [r3]
	ldrh	r3, [r4]
	lsls	r3, r3, #10
	str	r3, [r0, #4]
	ldrh	r3, [r4, #4]
	lsls	r3, r3, #10
	str	r3, [r0, #24]
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
	mov	r0, r5
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1887:
	.align	2
.L1886:
	.word	.LANCHOR37+28
	.word	.LANCHOR10
	.word	.LANCHOR25
	.word	.LANCHOR37
	.word	.LANCHOR115
	.word	.LANCHOR123
	.word	.LANCHOR148
	.word	.LANCHOR17
	.word	.LANCHOR137
	.word	.LANCHOR106
	.size	FtlMakeBbt, .-FtlMakeBbt
	.section	.text.ftl_low_format,"ax",%progbits
	.align	1
	.global	ftl_low_format
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	ftl_low_format, %function
ftl_low_format:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r3, #0
	ldr	r6, .L1912
	ldr	r2, .L1912+4
	ldr	r5, .L1912+8
	ldrh	r0, [r6]
	str	r3, [r2]
	str	r3, [r5]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L1889
	bl	FtlMakeBbt
.L1889:
	ldr	r3, .L1912+12
	ldr	r2, .L1912+16
	ldr	ip, .L1912+100
	ldrh	r1, [r3]
	ldr	r4, [r2]
	ldr	r2, .L1912+20
	str	r3, [sp, #4]
	lsls	r1, r1, #7
	ldr	r7, [r2]
	movs	r2, #0
.L1890:
	uxth	r3, r2
	adds	r2, r2, #1
	cmp	r3, r1
	blt	.L1891
	ldr	r3, .L1912+24
	movs	r7, #0
	ldr	r10, .L1912+104
	ldrh	r4, [r3]
	mov	r8, r3
	mov	fp, r10
.L1892:
	ldrh	r3, [r10]
	cmp	r3, r4
	bhi	.L1893
	ldr	r4, .L1912+28
	subs	r3, r7, #2
	ldrh	r1, [r4]
	cmp	r3, r1, lsl #1
	bgt	.L1894
.L1898:
	movs	r6, #0
	mov	r7, r6
.L1895:
	ldrh	r3, [r8]
	uxth	r0, r6
	adds	r6, r6, #1
	cmp	r3, r0
	bhi	.L1899
	ldrh	r2, [fp]
	ldr	r3, .L1912+32
	ldrh	r4, [r4]
	ldr	r6, .L1912+36
	str	r2, [r3]
	ldr	r3, .L1912+40
	mov	r1, r4
	ldr	r2, [r3]
	mov	r0, r2
	str	r2, [sp, #12]
	bl	__aeabi_uidiv
	ubfx	r10, r0, #5, #16
	mov	r3, r0
	str	r0, [r6]
	add	r1, r10, #36
	ldr	r0, .L1912+44
	strh	r1, [r0]	@ movhi
	movs	r1, #24
	muls	r1, r4, r1
	str	r0, [sp]
	cmp	r7, r1
	ble	.L1900
	ldr	r2, [sp, #12]
	mov	r1, r4
	str	r3, [sp, #8]
	subs	r0, r2, r7
	bl	__aeabi_uidiv
	ldr	r3, [sp]
	str	r0, [r6]
	lsrs	r0, r0, #5
	adds	r0, r0, #24
	strh	r0, [r3]	@ movhi
	ldr	r3, [sp, #8]
.L1900:
	ldr	r2, .L1912+48
	ldrh	r2, [r2]
	cbz	r2, .L1902
	ldr	r1, .L1912+44
	ldrh	r0, [r1]
	add	r0, r0, r2, lsr #1
	strh	r0, [r1]	@ movhi
	mul	r0, r4, r2
	cmp	r7, r0
	itttt	lt
	addlt	r2, r2, #32
	strlt	r3, [r6]
	addlt	r2, r2, r10
	strhlt	r2, [r1]	@ movhi
.L1902:
	ldr	r3, [sp]
	ldr	r7, .L1912+52
	ldr	r10, .L1912+108
	ldrh	r2, [r3]
	ldr	r3, [r6]
	subs	r3, r3, r2
	muls	r4, r3, r4
	ldr	r3, .L1912+56
	ldrh	r3, [r3]
	str	r4, [r7]
	muls	r4, r3, r4
	ldr	r3, [sp, #4]
	ldrh	r3, [r3]
	str	r4, [r6]
	ldr	r6, .L1912+60
	muls	r4, r3, r4
	ldr	r3, .L1912+64
	str	r4, [r3]
	movw	r4, #65535
	bl	FtlBbmTblFlush
	ldrh	r2, [fp]
	movs	r1, #0
	ldr	r0, [r10]
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r2, .L1912+68
	movs	r3, #0
	strh	r3, [r6, #2]	@ movhi
	movs	r1, #255
	strb	r3, [r6, #6]
	str	r3, [r2]
	ldr	r2, .L1912+72
	strh	r3, [r6]	@ movhi
	strh	r3, [r2, #2]	@ movhi
	strb	r3, [r2, #6]
	strb	r3, [r2, #8]
	movs	r3, #1
	strh	r4, [r2]	@ movhi
	ldrh	r2, [r8]
	mov	r8, r10
	strb	r3, [r6, #8]
	mov	r10, r6
	ldr	r3, .L1912+76
	lsrs	r2, r2, #3
	ldr	r0, [r3]
	bl	ftl_memset
.L1904:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r6, #7]	@ zero_extendqisi2
	ldrh	r2, [r6]
	cmp	r3, #0
	bne	.L1905
	ldr	r3, [r8]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r6]
	adds	r3, r3, #1
	strh	r3, [r6]	@ movhi
	b	.L1904
.L1891:
	mvns	r0, r3
	orr	r0, r3, r0, lsl #16
	str	r0, [r4, r3, lsl #2]
	str	ip, [r7, r3, lsl #2]
	b	.L1890
.L1893:
	mov	r0, r4
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r4, r4, #1
	add	r7, r7, r0
	uxth	r7, r7
	uxth	r4, r4
	b	.L1892
.L1894:
	mov	r0, r7
	bl	__aeabi_uidiv
	ldr	r3, .L1912+80
	ldr	r3, [r3]
	add	r0, r0, r3
	uxth	r0, r0
	bl	FtlSysBlkNumInit
	ldrh	r0, [r6]
	bl	FtlFreeSysBlkQueueInit
	ldrh	r6, [r8]
.L1896:
	ldrh	r3, [fp]
	cmp	r3, r6
	bls	.L1898
	mov	r0, r6
	movs	r1, #1
	adds	r6, r6, #1
	bl	FtlLowFormatEraseBlock
	uxth	r6, r6
	b	.L1896
.L1899:
	movs	r1, #0
	bl	FtlLowFormatEraseBlock
	add	r7, r7, r0
	uxth	r7, r7
	b	.L1895
.L1905:
	ldr	r3, [r5]
	ldrh	r1, [r6, #4]
	ldr	r4, .L1912+84
	str	r3, [r6, #12]
	adds	r3, r3, #1
	str	r3, [r5]
	ldr	r3, [r8]
	mov	r10, r4
	strh	r1, [r3, r2, lsl #1]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #2]	@ movhi
	strb	r3, [r4, #6]
	ldrh	r3, [r6]
	movw	r6, #65535
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	movs	r3, #1
	strb	r3, [r4, #8]
.L1906:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r4]
	cbnz	r3, .L1907
	ldr	r3, [r8]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L1906
.L1907:
	ldr	r3, [r5]
	ldrh	r1, [r4, #4]
	str	r3, [r4, #12]
	adds	r3, r3, #1
	str	r3, [r5]
	movw	r4, #65535
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L1912+88
	strh	r4, [r3]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L1912+92
	movs	r2, #0
	strh	r2, [r3, #2]	@ movhi
	ldr	r2, [r7]
	strh	r0, [r3]	@ movhi
	strh	r4, [r3, #4]	@ movhi
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, [r5]
	str	r2, [r3, #8]
	adds	r2, r2, #1
	str	r2, [r5]
	bl	FtlVpcTblFlush
	bl	FtlSysBlkInit
	cbnz	r0, .L1908
	ldr	r3, .L1912+96
	movs	r2, #1
	str	r2, [r3]
.L1908:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1913:
	.align	2
.L1912:
	.word	.LANCHOR4
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR12
	.word	.LANCHOR118
	.word	.LANCHOR119
	.word	.LANCHOR5
	.word	.LANCHOR3
	.word	.LANCHOR111
	.word	.LANCHOR61
	.word	.LANCHOR7
	.word	.LANCHOR78
	.word	.LANCHOR15
	.word	.LANCHOR152
	.word	.LANCHOR19
	.word	.LANCHOR51
	.word	.LANCHOR34
	.word	.LANCHOR59
	.word	.LANCHOR80
	.word	.LANCHOR1
	.word	.LANCHOR31
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR79
	.word	.LANCHOR86
	.word	168778952
	.word	.LANCHOR6
	.word	.LANCHOR42
	.size	ftl_low_format, .-ftl_low_format
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
	.global	g_nand_ops
	.global	g_nand_phy_info
	.global	gc_ink_free_return_value
	.global	check_vpc_table
	.global	FtlUpdateVaildLpnCount
	.global	g_ect_tbl_power_up_flush
	.global	power_up_flag
	.global	gFtlInitStatus
	.global	DeviceCapacity
	.global	g_power_lost_recovery_flag
	.global	c_mlc_erase_count_value
	.global	g_recovery_ppa_tbl
	.global	g_recovery_page_min_ver
	.global	g_recovery_page_num
	.global	sftl_nand_check_spare_buf
	.global	sftl_temp_buf
	.global	sftl_nand_check_buf
	.global	g_cur_erase_blk
	.global	g_gc_skip_write_count
	.global	g_gc_head_data_block_count
	.global	g_gc_head_data_block
	.global	g_ftl_nand_free_count
	.global	g_in_swl_replace
	.global	g_in_gc_progress
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
	.section	.bss.DeviceCapacity,"aw",%nobits
	.align	2
	.set	.LANCHOR26,. + 0
	.type	DeviceCapacity, %object
	.size	DeviceCapacity, 4
DeviceCapacity:
	.space	4
	.section	.bss.FtlUpdateVaildLpnCount,"aw",%nobits
	.align	1
	.set	.LANCHOR58,. + 0
	.type	FtlUpdateVaildLpnCount, %object
	.size	FtlUpdateVaildLpnCount, 2
FtlUpdateVaildLpnCount:
	.space	2
	.section	.bss.c_ftl_nand_bbm_buf_size,"aw",%nobits
	.align	1
	.set	.LANCHOR137,. + 0
	.type	c_ftl_nand_bbm_buf_size, %object
	.size	c_ftl_nand_bbm_buf_size, 2
c_ftl_nand_bbm_buf_size:
	.space	2
	.section	.bss.c_ftl_nand_blk_pre_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR6,. + 0
	.type	c_ftl_nand_blk_pre_plane, %object
	.size	c_ftl_nand_blk_pre_plane, 2
c_ftl_nand_blk_pre_plane:
	.space	2
	.section	.bss.c_ftl_nand_blks_per_die,"aw",%nobits
	.align	1
	.set	.LANCHOR17,. + 0
	.type	c_ftl_nand_blks_per_die, %object
	.size	c_ftl_nand_blks_per_die, 2
c_ftl_nand_blks_per_die:
	.space	2
	.section	.bss.c_ftl_nand_blks_per_die_shift,"aw",%nobits
	.align	1
	.set	.LANCHOR18,. + 0
	.type	c_ftl_nand_blks_per_die_shift, %object
	.size	c_ftl_nand_blks_per_die_shift, 2
c_ftl_nand_blks_per_die_shift:
	.space	2
	.section	.bss.c_ftl_nand_byte_pre_oob,"aw",%nobits
	.align	1
	.set	.LANCHOR24,. + 0
	.type	c_ftl_nand_byte_pre_oob, %object
	.size	c_ftl_nand_byte_pre_oob, 2
c_ftl_nand_byte_pre_oob:
	.space	2
	.section	.bss.c_ftl_nand_byte_pre_page,"aw",%nobits
	.align	1
	.set	.LANCHOR23,. + 0
	.type	c_ftl_nand_byte_pre_page, %object
	.size	c_ftl_nand_byte_pre_page, 2
c_ftl_nand_byte_pre_page:
	.space	2
	.section	.bss.c_ftl_nand_data_blks_per_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR5,. + 0
	.type	c_ftl_nand_data_blks_per_plane, %object
	.size	c_ftl_nand_data_blks_per_plane, 2
c_ftl_nand_data_blks_per_plane:
	.space	2
	.section	.bss.c_ftl_nand_data_op_blks_per_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR78,. + 0
	.type	c_ftl_nand_data_op_blks_per_plane, %object
	.size	c_ftl_nand_data_op_blks_per_plane, 2
c_ftl_nand_data_op_blks_per_plane:
	.space	2
	.section	.bss.c_ftl_nand_die_num,"aw",%nobits
	.align	1
	.set	.LANCHOR10,. + 0
	.type	c_ftl_nand_die_num, %object
	.size	c_ftl_nand_die_num, 2
c_ftl_nand_die_num:
	.space	2
	.section	.bss.c_ftl_nand_ext_blk_pre_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR15,. + 0
	.type	c_ftl_nand_ext_blk_pre_plane, %object
	.size	c_ftl_nand_ext_blk_pre_plane, 2
c_ftl_nand_ext_blk_pre_plane:
	.space	2
	.section	.bss.c_ftl_nand_init_sys_blks_per_plane,"aw",%nobits
	.align	2
	.set	.LANCHOR31,. + 0
	.type	c_ftl_nand_init_sys_blks_per_plane, %object
	.size	c_ftl_nand_init_sys_blks_per_plane, 4
c_ftl_nand_init_sys_blks_per_plane:
	.space	4
	.section	.bss.c_ftl_nand_l2pmap_ram_region_num,"aw",%nobits
	.align	1
	.set	.LANCHOR33,. + 0
	.type	c_ftl_nand_l2pmap_ram_region_num, %object
	.size	c_ftl_nand_l2pmap_ram_region_num, 2
c_ftl_nand_l2pmap_ram_region_num:
	.space	2
	.section	.bss.c_ftl_nand_map_blks_per_plane,"aw",%nobits
	.align	1
	.set	.LANCHOR29,. + 0
	.type	c_ftl_nand_map_blks_per_plane, %object
	.size	c_ftl_nand_map_blks_per_plane, 2
c_ftl_nand_map_blks_per_plane:
	.space	2
	.section	.bss.c_ftl_nand_map_region_num,"aw",%nobits
	.align	1
	.set	.LANCHOR32,. + 0
	.type	c_ftl_nand_map_region_num, %object
	.size	c_ftl_nand_map_region_num, 2
c_ftl_nand_map_region_num:
	.space	2
	.section	.bss.c_ftl_nand_max_data_blks,"aw",%nobits
	.align	2
	.set	.LANCHOR7,. + 0
	.type	c_ftl_nand_max_data_blks, %object
	.size	c_ftl_nand_max_data_blks, 4
c_ftl_nand_max_data_blks:
	.space	4
	.section	.bss.c_ftl_nand_max_map_blks,"aw",%nobits
	.align	2
	.set	.LANCHOR30,. + 0
	.type	c_ftl_nand_max_map_blks, %object
	.size	c_ftl_nand_max_map_blks, 4
c_ftl_nand_max_map_blks:
	.space	4
	.section	.bss.c_ftl_nand_max_sys_blks,"aw",%nobits
	.align	2
	.set	.LANCHOR4,. + 0
	.type	c_ftl_nand_max_sys_blks, %object
	.size	c_ftl_nand_max_sys_blks, 4
c_ftl_nand_max_sys_blks:
	.space	4
	.section	.bss.c_ftl_nand_max_vendor_blks,"aw",%nobits
	.align	1
	.set	.LANCHOR27,. + 0
	.type	c_ftl_nand_max_vendor_blks, %object
	.size	c_ftl_nand_max_vendor_blks, 2
c_ftl_nand_max_vendor_blks:
	.space	2
	.section	.bss.c_ftl_nand_page_pre_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR19,. + 0
	.type	c_ftl_nand_page_pre_blk, %object
	.size	c_ftl_nand_page_pre_blk, 2
c_ftl_nand_page_pre_blk:
	.space	2
	.section	.bss.c_ftl_nand_page_pre_slc_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR20,. + 0
	.type	c_ftl_nand_page_pre_slc_blk, %object
	.size	c_ftl_nand_page_pre_slc_blk, 2
c_ftl_nand_page_pre_slc_blk:
	.space	2
	.section	.bss.c_ftl_nand_page_pre_super_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR21,. + 0
	.type	c_ftl_nand_page_pre_super_blk, %object
	.size	c_ftl_nand_page_pre_super_blk, 2
c_ftl_nand_page_pre_super_blk:
	.space	2
	.section	.bss.c_ftl_nand_planes_num,"aw",%nobits
	.align	1
	.set	.LANCHOR3,. + 0
	.type	c_ftl_nand_planes_num, %object
	.size	c_ftl_nand_planes_num, 2
c_ftl_nand_planes_num:
	.space	2
	.section	.bss.c_ftl_nand_planes_per_die,"aw",%nobits
	.align	1
	.set	.LANCHOR11,. + 0
	.type	c_ftl_nand_planes_per_die, %object
	.size	c_ftl_nand_planes_per_die, 2
c_ftl_nand_planes_per_die:
	.space	2
	.section	.bss.c_ftl_nand_reserved_blks,"aw",%nobits
	.align	1
	.set	.LANCHOR25,. + 0
	.type	c_ftl_nand_reserved_blks, %object
	.size	c_ftl_nand_reserved_blks, 2
c_ftl_nand_reserved_blks:
	.space	2
	.section	.bss.c_ftl_nand_sec_pre_page,"aw",%nobits
	.align	1
	.set	.LANCHOR12,. + 0
	.type	c_ftl_nand_sec_pre_page, %object
	.size	c_ftl_nand_sec_pre_page, 2
c_ftl_nand_sec_pre_page:
	.space	2
	.section	.bss.c_ftl_nand_sec_pre_page_shift,"aw",%nobits
	.align	1
	.set	.LANCHOR22,. + 0
	.type	c_ftl_nand_sec_pre_page_shift, %object
	.size	c_ftl_nand_sec_pre_page_shift, 2
c_ftl_nand_sec_pre_page_shift:
	.space	2
	.section	.bss.c_ftl_nand_sys_blks_per_plane,"aw",%nobits
	.align	2
	.set	.LANCHOR2,. + 0
	.type	c_ftl_nand_sys_blks_per_plane, %object
	.size	c_ftl_nand_sys_blks_per_plane, 4
c_ftl_nand_sys_blks_per_plane:
	.space	4
	.section	.bss.c_ftl_nand_totle_phy_blks,"aw",%nobits
	.align	2
	.set	.LANCHOR8,. + 0
	.type	c_ftl_nand_totle_phy_blks, %object
	.size	c_ftl_nand_totle_phy_blks, 4
c_ftl_nand_totle_phy_blks:
	.space	4
	.section	.bss.c_ftl_nand_type,"aw",%nobits
	.align	1
	.set	.LANCHOR9,. + 0
	.type	c_ftl_nand_type, %object
	.size	c_ftl_nand_type, 2
c_ftl_nand_type:
	.space	2
	.section	.bss.c_ftl_nand_vendor_region_num,"aw",%nobits
	.align	1
	.set	.LANCHOR28,. + 0
	.type	c_ftl_nand_vendor_region_num, %object
	.size	c_ftl_nand_vendor_region_num, 2
c_ftl_nand_vendor_region_num:
	.space	2
	.section	.bss.c_ftl_vendor_part_size,"aw",%nobits
	.align	1
	.set	.LANCHOR16,. + 0
	.type	c_ftl_vendor_part_size, %object
	.size	c_ftl_vendor_part_size, 2
c_ftl_vendor_part_size:
	.space	2
	.section	.bss.c_gc_page_buf_num,"aw",%nobits
	.align	2
	.set	.LANCHOR94,. + 0
	.type	c_gc_page_buf_num, %object
	.size	c_gc_page_buf_num, 4
c_gc_page_buf_num:
	.space	4
	.section	.bss.c_mlc_erase_count_value,"aw",%nobits
	.align	1
	.set	.LANCHOR14,. + 0
	.type	c_mlc_erase_count_value, %object
	.size	c_mlc_erase_count_value, 2
c_mlc_erase_count_value:
	.space	2
	.section	.bss.check_vpc_table,"aw",%nobits
	.align	1
	.type	check_vpc_table, %object
	.size	check_vpc_table, 16384
check_vpc_table:
	.space	16384
	.section	.bss.ftl_gc_temp_power_lost_recovery_flag,"aw",%nobits
	.align	2
	.set	.LANCHOR144,. + 0
	.type	ftl_gc_temp_power_lost_recovery_flag, %object
	.size	ftl_gc_temp_power_lost_recovery_flag, 4
ftl_gc_temp_power_lost_recovery_flag:
	.space	4
	.section	.bss.gBbtInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR37,. + 0
	.type	gBbtInfo, %object
	.size	gBbtInfo, 60
gBbtInfo:
	.space	60
	.section	.bss.gL2pMapInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR140,. + 0
	.type	gL2pMapInfo, %object
	.size	gL2pMapInfo, 40
gL2pMapInfo:
	.space	40
	.section	.bss.gSysFreeQueue,"aw",%nobits
	.align	1
	.set	.LANCHOR38,. + 0
	.type	gSysFreeQueue, %object
	.size	gSysFreeQueue, 2056
gSysFreeQueue:
	.space	2056
	.section	.bss.gSysInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR79,. + 0
	.type	gSysInfo, %object
	.size	gSysInfo, 12
gSysInfo:
	.space	12
	.section	.bss.gVendorBlkInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR158,. + 0
	.type	gVendorBlkInfo, %object
	.size	gVendorBlkInfo, 40
gVendorBlkInfo:
	.space	40
	.section	.bss.g_GlobalDataVersion,"aw",%nobits
	.align	2
	.set	.LANCHOR71,. + 0
	.type	g_GlobalDataVersion, %object
	.size	g_GlobalDataVersion, 4
g_GlobalDataVersion:
	.space	4
	.section	.bss.g_GlobalSysVersion,"aw",%nobits
	.align	2
	.set	.LANCHOR70,. + 0
	.type	g_GlobalSysVersion, %object
	.size	g_GlobalSysVersion, 4
g_GlobalSysVersion:
	.space	4
	.section	.bss.g_MaxLbaSector,"aw",%nobits
	.align	2
	.set	.LANCHOR34,. + 0
	.type	g_MaxLbaSector, %object
	.size	g_MaxLbaSector, 4
g_MaxLbaSector:
	.space	4
	.section	.bss.g_MaxLbn,"aw",%nobits
	.align	2
	.set	.LANCHOR152,. + 0
	.type	g_MaxLbn, %object
	.size	g_MaxLbn, 4
g_MaxLbn:
	.space	4
	.section	.bss.g_MaxLpn,"aw",%nobits
	.align	2
	.set	.LANCHOR61,. + 0
	.type	g_MaxLpn, %object
	.size	g_MaxLpn, 4
g_MaxLpn:
	.space	4
	.section	.bss.g_VaildLpn,"aw",%nobits
	.align	2
	.set	.LANCHOR59,. + 0
	.type	g_VaildLpn, %object
	.size	g_VaildLpn, 4
g_VaildLpn:
	.space	4
	.section	.bss.g_active_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR51,. + 0
	.type	g_active_superblock, %object
	.size	g_active_superblock, 48
g_active_superblock:
	.space	48
	.section	.bss.g_buffer_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR52,. + 0
	.type	g_buffer_superblock, %object
	.size	g_buffer_superblock, 48
g_buffer_superblock:
	.space	48
	.section	.bss.g_cur_erase_blk,"aw",%nobits
	.align	2
	.set	.LANCHOR111,. + 0
	.type	g_cur_erase_blk, %object
	.size	g_cur_erase_blk, 4
g_cur_erase_blk:
	.space	4
	.section	.bss.g_ect_tbl_info_size,"aw",%nobits
	.align	1
	.set	.LANCHOR125,. + 0
	.type	g_ect_tbl_info_size, %object
	.size	g_ect_tbl_info_size, 2
g_ect_tbl_info_size:
	.space	2
	.section	.bss.g_ect_tbl_power_up_flush,"aw",%nobits
	.align	1
	.set	.LANCHOR170,. + 0
	.type	g_ect_tbl_power_up_flush, %object
	.size	g_ect_tbl_power_up_flush, 2
g_ect_tbl_power_up_flush:
	.space	2
	.section	.bss.g_ftl_nand_free_count,"aw",%nobits
	.align	2
	.set	.LANCHOR181,. + 0
	.type	g_ftl_nand_free_count, %object
	.size	g_ftl_nand_free_count, 4
g_ftl_nand_free_count:
	.space	4
	.section	.bss.g_gc_bad_block_gc_index,"aw",%nobits
	.align	1
	.set	.LANCHOR103,. + 0
	.type	g_gc_bad_block_gc_index, %object
	.size	g_gc_bad_block_gc_index, 2
g_gc_bad_block_gc_index:
	.space	2
	.section	.bss.g_gc_bad_block_temp_num,"aw",%nobits
	.align	1
	.set	.LANCHOR101,. + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.space	2
	.section	.bss.g_gc_bad_block_temp_tbl,"aw",%nobits
	.align	1
	.set	.LANCHOR102,. + 0
	.type	g_gc_bad_block_temp_tbl, %object
	.size	g_gc_bad_block_temp_tbl, 34
g_gc_bad_block_temp_tbl:
	.space	34
	.section	.bss.g_gc_blk_index,"aw",%nobits
	.align	1
	.set	.LANCHOR85,. + 0
	.type	g_gc_blk_index, %object
	.size	g_gc_blk_index, 2
g_gc_blk_index:
	.space	2
	.section	.bss.g_gc_blk_num,"aw",%nobits
	.align	1
	.set	.LANCHOR96,. + 0
	.type	g_gc_blk_num, %object
	.size	g_gc_blk_num, 2
g_gc_blk_num:
	.space	2
	.section	.bss.g_gc_cur_blk_max_valid_pages,"aw",%nobits
	.align	1
	.set	.LANCHOR179,. + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.space	2
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",%nobits
	.align	1
	.set	.LANCHOR178,. + 0
	.type	g_gc_cur_blk_valid_pages, %object
	.size	g_gc_cur_blk_valid_pages, 2
g_gc_cur_blk_valid_pages:
	.space	2
	.section	.bss.g_gc_free_blk_threshold,"aw",%nobits
	.align	1
	.set	.LANCHOR82,. + 0
	.type	g_gc_free_blk_threshold, %object
	.size	g_gc_free_blk_threshold, 2
g_gc_free_blk_threshold:
	.space	2
	.section	.bss.g_gc_head_data_block,"aw",%nobits
	.align	2
	.set	.LANCHOR109,. + 0
	.type	g_gc_head_data_block, %object
	.size	g_gc_head_data_block, 4
g_gc_head_data_block:
	.space	4
	.section	.bss.g_gc_head_data_block_count,"aw",%nobits
	.align	2
	.set	.LANCHOR110,. + 0
	.type	g_gc_head_data_block_count, %object
	.size	g_gc_head_data_block_count, 4
g_gc_head_data_block_count:
	.space	4
	.section	.bss.g_gc_merge_free_blk_threshold,"aw",%nobits
	.align	1
	.set	.LANCHOR83,. + 0
	.type	g_gc_merge_free_blk_threshold, %object
	.size	g_gc_merge_free_blk_threshold, 2
g_gc_merge_free_blk_threshold:
	.space	2
	.section	.bss.g_gc_next_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR99,. + 0
	.type	g_gc_next_blk, %object
	.size	g_gc_next_blk, 2
g_gc_next_blk:
	.space	2
	.section	.bss.g_gc_next_blk_1,"aw",%nobits
	.align	1
	.set	.LANCHOR100,. + 0
	.type	g_gc_next_blk_1, %object
	.size	g_gc_next_blk_1, 2
g_gc_next_blk_1:
	.space	2
	.section	.bss.g_gc_num_req,"aw",%nobits
	.align	2
	.set	.LANCHOR89,. + 0
	.type	g_gc_num_req, %object
	.size	g_gc_num_req, 4
g_gc_num_req:
	.space	4
	.section	.bss.g_gc_page_offset,"aw",%nobits
	.align	1
	.set	.LANCHOR97,. + 0
	.type	g_gc_page_offset, %object
	.size	g_gc_page_offset, 2
g_gc_page_offset:
	.space	2
	.section	.bss.g_gc_skip_write_count,"aw",%nobits
	.align	2
	.set	.LANCHOR84,. + 0
	.type	g_gc_skip_write_count, %object
	.size	g_gc_skip_write_count, 4
g_gc_skip_write_count:
	.space	4
	.section	.bss.g_gc_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR80,. + 0
	.type	g_gc_superblock, %object
	.size	g_gc_superblock, 48
g_gc_superblock:
	.space	48
	.section	.bss.g_gc_temp_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR53,. + 0
	.type	g_gc_temp_superblock, %object
	.size	g_gc_temp_superblock, 48
g_gc_temp_superblock:
	.space	48
	.section	.bss.g_in_gc_progress,"aw",%nobits
	.align	2
	.set	.LANCHOR108,. + 0
	.type	g_in_gc_progress, %object
	.size	g_in_gc_progress, 4
g_in_gc_progress:
	.space	4
	.section	.bss.g_in_swl_replace,"aw",%nobits
	.align	2
	.set	.LANCHOR87,. + 0
	.type	g_in_swl_replace, %object
	.size	g_in_swl_replace, 4
g_in_swl_replace:
	.space	4
	.section	.bss.g_l2p_last_update_region_id,"aw",%nobits
	.align	1
	.set	.LANCHOR56,. + 0
	.type	g_l2p_last_update_region_id, %object
	.size	g_l2p_last_update_region_id, 2
g_l2p_last_update_region_id:
	.space	2
	.section	.bss.g_max_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR76,. + 0
	.type	g_max_erase_count, %object
	.size	g_max_erase_count, 4
g_max_erase_count:
	.space	4
	.section	.bss.g_min_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR77,. + 0
	.type	g_min_erase_count, %object
	.size	g_min_erase_count, 4
g_min_erase_count:
	.space	4
	.section	.bss.g_nand_ops,"aw",%nobits
	.align	2
	.set	.LANCHOR105,. + 0
	.type	g_nand_ops, %object
	.size	g_nand_ops, 16
g_nand_ops:
	.space	16
	.section	.bss.g_nand_phy_info,"aw",%nobits
	.align	1
	.set	.LANCHOR0,. + 0
	.type	g_nand_phy_info, %object
	.size	g_nand_phy_info, 24
g_nand_phy_info:
	.space	24
	.section	.bss.g_num_data_superblocks,"aw",%nobits
	.align	1
	.set	.LANCHOR45,. + 0
	.type	g_num_data_superblocks, %object
	.size	g_num_data_superblocks, 2
g_num_data_superblocks:
	.space	2
	.section	.bss.g_num_free_superblocks,"aw",%nobits
	.align	1
	.set	.LANCHOR48,. + 0
	.type	g_num_free_superblocks, %object
	.size	g_num_free_superblocks, 2
g_num_free_superblocks:
	.space	2
	.section	.bss.g_power_lost_recovery_flag,"aw",%nobits
	.align	1
	.set	.LANCHOR167,. + 0
	.type	g_power_lost_recovery_flag, %object
	.size	g_power_lost_recovery_flag, 2
g_power_lost_recovery_flag:
	.space	2
	.section	.bss.g_recovery_page_min_ver,"aw",%nobits
	.align	2
	.set	.LANCHOR145,. + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.space	4
	.section	.bss.g_recovery_page_num,"aw",%nobits
	.align	2
	.set	.LANCHOR168,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.space	4
	.section	.bss.g_recovery_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR169,. + 0
	.type	g_recovery_ppa_tbl, %object
	.size	g_recovery_ppa_tbl, 128
g_recovery_ppa_tbl:
	.space	128
	.section	.bss.g_sys_ext_data,"aw",%nobits
	.align	2
	.set	.LANCHOR81,. + 0
	.type	g_sys_ext_data, %object
	.size	g_sys_ext_data, 512
g_sys_ext_data:
	.space	512
	.section	.bss.g_sys_save_data,"aw",%nobits
	.align	2
	.set	.LANCHOR39,. + 0
	.type	g_sys_save_data, %object
	.size	g_sys_save_data, 48
g_sys_save_data:
	.space	48
	.section	.bss.g_tmp_data_superblock_id,"aw",%nobits
	.align	1
	.set	.LANCHOR142,. + 0
	.type	g_tmp_data_superblock_id, %object
	.size	g_tmp_data_superblock_id, 2
g_tmp_data_superblock_id:
	.space	2
	.section	.bss.g_totle_avg_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR74,. + 0
	.type	g_totle_avg_erase_count, %object
	.size	g_totle_avg_erase_count, 4
g_totle_avg_erase_count:
	.space	4
	.section	.bss.g_totle_cache_write_count,"aw",%nobits
	.align	2
	.set	.LANCHOR65,. + 0
	.type	g_totle_cache_write_count, %object
	.size	g_totle_cache_write_count, 4
g_totle_cache_write_count:
	.space	4
	.section	.bss.g_totle_discard_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR63,. + 0
	.type	g_totle_discard_page_count, %object
	.size	g_totle_discard_page_count, 4
g_totle_discard_page_count:
	.space	4
	.section	.bss.g_totle_gc_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR67,. + 0
	.type	g_totle_gc_page_count, %object
	.size	g_totle_gc_page_count, 4
g_totle_gc_page_count:
	.space	4
	.section	.bss.g_totle_l2p_write_count,"aw",%nobits
	.align	2
	.set	.LANCHOR66,. + 0
	.type	g_totle_l2p_write_count, %object
	.size	g_totle_l2p_write_count, 4
g_totle_l2p_write_count:
	.space	4
	.section	.bss.g_totle_map_block,"aw",%nobits
	.align	1
	.set	.LANCHOR141,. + 0
	.type	g_totle_map_block, %object
	.size	g_totle_map_block, 2
g_totle_map_block:
	.space	2
	.section	.bss.g_totle_mlc_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR72,. + 0
	.type	g_totle_mlc_erase_count, %object
	.size	g_totle_mlc_erase_count, 4
g_totle_mlc_erase_count:
	.space	4
	.section	.bss.g_totle_read_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR62,. + 0
	.type	g_totle_read_page_count, %object
	.size	g_totle_read_page_count, 4
g_totle_read_page_count:
	.space	4
	.section	.bss.g_totle_read_sector,"aw",%nobits
	.align	2
	.set	.LANCHOR69,. + 0
	.type	g_totle_read_sector, %object
	.size	g_totle_read_sector, 4
g_totle_read_sector:
	.space	4
	.section	.bss.g_totle_slc_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR73,. + 0
	.type	g_totle_slc_erase_count, %object
	.size	g_totle_slc_erase_count, 4
g_totle_slc_erase_count:
	.space	4
	.section	.bss.g_totle_swl_count,"aw",%nobits
	.align	2
	.set	.LANCHOR143,. + 0
	.type	g_totle_swl_count, %object
	.size	g_totle_swl_count, 4
g_totle_swl_count:
	.space	4
	.section	.bss.g_totle_sys_slc_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR75,. + 0
	.type	g_totle_sys_slc_erase_count, %object
	.size	g_totle_sys_slc_erase_count, 4
g_totle_sys_slc_erase_count:
	.space	4
	.section	.bss.g_totle_vendor_block,"aw",%nobits
	.align	1
	.set	.LANCHOR35,. + 0
	.type	g_totle_vendor_block, %object
	.size	g_totle_vendor_block, 2
g_totle_vendor_block:
	.space	2
	.section	.bss.g_totle_write_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR64,. + 0
	.type	g_totle_write_page_count, %object
	.size	g_totle_write_page_count, 4
g_totle_write_page_count:
	.space	4
	.section	.bss.g_totle_write_sector,"aw",%nobits
	.align	2
	.set	.LANCHOR68,. + 0
	.type	g_totle_write_sector, %object
	.size	g_totle_write_sector, 4
g_totle_write_sector:
	.space	4
	.section	.bss.gc_discard_updated,"aw",%nobits
	.align	2
	.set	.LANCHOR172,. + 0
	.type	gc_discard_updated, %object
	.size	gc_discard_updated, 4
gc_discard_updated:
	.space	4
	.section	.bss.gc_ink_free_return_value,"aw",%nobits
	.align	1
	.set	.LANCHOR177,. + 0
	.type	gc_ink_free_return_value, %object
	.size	gc_ink_free_return_value, 2
gc_ink_free_return_value:
	.space	2
	.section	.bss.gp_ect_tbl_info,"aw",%nobits
	.align	2
	.set	.LANCHOR127,. + 0
	.type	gp_ect_tbl_info, %object
	.size	gp_ect_tbl_info, 4
gp_ect_tbl_info:
	.space	4
	.section	.bss.gp_flash_check_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR186,. + 0
	.type	gp_flash_check_buf, %object
	.size	gp_flash_check_buf, 4
gp_flash_check_buf:
	.space	4
	.section	.bss.gp_gc_page_buf_info,"aw",%nobits
	.align	2
	.set	.LANCHOR90,. + 0
	.type	gp_gc_page_buf_info, %object
	.size	gp_gc_page_buf_info, 4
gp_gc_page_buf_info:
	.space	4
	.section	.bss.gp_last_act_superblock,"aw",%nobits
	.align	2
	.type	gp_last_act_superblock, %object
	.size	gp_last_act_superblock, 4
gp_last_act_superblock:
	.space	4
	.section	.bss.idb_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR185,. + 0
	.type	idb_buf, %object
	.size	idb_buf, 4
idb_buf:
	.space	4
	.section	.bss.idb_need_write_back,"aw",%nobits
	.align	2
	.set	.LANCHOR184,. + 0
	.type	idb_need_write_back, %object
	.size	idb_need_write_back, 4
idb_need_write_back:
	.space	4
	.section	.bss.p_blk_mode_table,"aw",%nobits
	.align	2
	.set	.LANCHOR1,. + 0
	.type	p_blk_mode_table, %object
	.size	p_blk_mode_table, 4
p_blk_mode_table:
	.space	4
	.section	.bss.p_data_block_list_head,"aw",%nobits
	.align	2
	.set	.LANCHOR41,. + 0
	.type	p_data_block_list_head, %object
	.size	p_data_block_list_head, 4
p_data_block_list_head:
	.space	4
	.section	.bss.p_data_block_list_table,"aw",%nobits
	.align	2
	.set	.LANCHOR40,. + 0
	.type	p_data_block_list_table, %object
	.size	p_data_block_list_table, 4
p_data_block_list_table:
	.space	4
	.section	.bss.p_data_block_list_tail,"aw",%nobits
	.align	2
	.set	.LANCHOR44,. + 0
	.type	p_data_block_list_tail, %object
	.size	p_data_block_list_tail, 4
p_data_block_list_tail:
	.space	4
	.section	.bss.p_erase_count_table,"aw",%nobits
	.align	2
	.set	.LANCHOR43,. + 0
	.type	p_erase_count_table, %object
	.size	p_erase_count_table, 4
p_erase_count_table:
	.space	4
	.section	.bss.p_free_data_block_list_head,"aw",%nobits
	.align	2
	.set	.LANCHOR47,. + 0
	.type	p_free_data_block_list_head, %object
	.size	p_free_data_block_list_head, 4
p_free_data_block_list_head:
	.space	4
	.section	.bss.p_gc_blk_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR95,. + 0
	.type	p_gc_blk_tbl, %object
	.size	p_gc_blk_tbl, 4
p_gc_blk_tbl:
	.space	4
	.section	.bss.p_gc_data_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR91,. + 0
	.type	p_gc_data_buf, %object
	.size	p_gc_data_buf, 4
p_gc_data_buf:
	.space	4
	.section	.bss.p_gc_page_info,"aw",%nobits
	.align	2
	.set	.LANCHOR98,. + 0
	.type	p_gc_page_info, %object
	.size	p_gc_page_info, 4
p_gc_page_info:
	.space	4
	.section	.bss.p_gc_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR92,. + 0
	.type	p_gc_spare_buf, %object
	.size	p_gc_spare_buf, 4
p_gc_spare_buf:
	.space	4
	.section	.bss.p_io_data_buf_0,"aw",%nobits
	.align	2
	.set	.LANCHOR118,. + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 4
p_io_data_buf_0:
	.space	4
	.section	.bss.p_io_data_buf_1,"aw",%nobits
	.align	2
	.set	.LANCHOR119,. + 0
	.type	p_io_data_buf_1, %object
	.size	p_io_data_buf_1, 4
p_io_data_buf_1:
	.space	4
	.section	.bss.p_io_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR124,. + 0
	.type	p_io_spare_buf, %object
	.size	p_io_spare_buf, 4
p_io_spare_buf:
	.space	4
	.section	.bss.p_l2p_map_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR136,. + 0
	.type	p_l2p_map_buf, %object
	.size	p_l2p_map_buf, 4
p_l2p_map_buf:
	.space	4
	.section	.bss.p_l2p_ram_map,"aw",%nobits
	.align	2
	.set	.LANCHOR55,. + 0
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
	.set	.LANCHOR130,. + 0
	.type	p_map_block_valid_page_count, %object
	.size	p_map_block_valid_page_count, 4
p_map_block_valid_page_count:
	.space	4
	.section	.bss.p_map_block_ver_table,"aw",%nobits
	.align	2
	.set	.LANCHOR135,. + 0
	.type	p_map_block_ver_table, %object
	.size	p_map_block_ver_table, 4
p_map_block_ver_table:
	.space	4
	.section	.bss.p_map_region_ppn_table,"aw",%nobits
	.align	2
	.set	.LANCHOR134,. + 0
	.type	p_map_region_ppn_table, %object
	.size	p_map_region_ppn_table, 4
p_map_region_ppn_table:
	.space	4
	.section	.bss.p_plane_order_table,"aw",%nobits
	.set	.LANCHOR13,. + 0
	.type	p_plane_order_table, %object
	.size	p_plane_order_table, 32
p_plane_order_table:
	.space	32
	.section	.bss.p_swl_mul_table,"aw",%nobits
	.align	2
	.set	.LANCHOR126,. + 0
	.type	p_swl_mul_table, %object
	.size	p_swl_mul_table, 4
p_swl_mul_table:
	.space	4
	.section	.bss.p_sys_data_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR115,. + 0
	.type	p_sys_data_buf, %object
	.size	p_sys_data_buf, 4
p_sys_data_buf:
	.space	4
	.section	.bss.p_sys_data_buf_1,"aw",%nobits
	.align	2
	.set	.LANCHOR116,. + 0
	.type	p_sys_data_buf_1, %object
	.size	p_sys_data_buf_1, 4
p_sys_data_buf_1:
	.space	4
	.section	.bss.p_sys_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR123,. + 0
	.type	p_sys_spare_buf, %object
	.size	p_sys_spare_buf, 4
p_sys_spare_buf:
	.space	4
	.section	.bss.p_valid_page_count_check_table,"aw",%nobits
	.align	2
	.set	.LANCHOR128,. + 0
	.type	p_valid_page_count_check_table, %object
	.size	p_valid_page_count_check_table, 4
p_valid_page_count_check_table:
	.space	4
	.section	.bss.p_valid_page_count_table,"aw",%nobits
	.align	2
	.set	.LANCHOR42,. + 0
	.type	p_valid_page_count_table, %object
	.size	p_valid_page_count_table, 4
p_valid_page_count_table:
	.space	4
	.section	.bss.p_vendor_block_table,"aw",%nobits
	.align	2
	.set	.LANCHOR36,. + 0
	.type	p_vendor_block_table, %object
	.size	p_vendor_block_table, 4
p_vendor_block_table:
	.space	4
	.section	.bss.p_vendor_block_valid_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR131,. + 0
	.type	p_vendor_block_valid_page_count, %object
	.size	p_vendor_block_valid_page_count, 4
p_vendor_block_valid_page_count:
	.space	4
	.section	.bss.p_vendor_block_ver_table,"aw",%nobits
	.align	2
	.set	.LANCHOR132,. + 0
	.type	p_vendor_block_ver_table, %object
	.size	p_vendor_block_ver_table, 4
p_vendor_block_ver_table:
	.space	4
	.section	.bss.p_vendor_data_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR117,. + 0
	.type	p_vendor_data_buf, %object
	.size	p_vendor_data_buf, 4
p_vendor_data_buf:
	.space	4
	.section	.bss.p_vendor_region_ppn_table,"aw",%nobits
	.align	2
	.set	.LANCHOR133,. + 0
	.type	p_vendor_region_ppn_table, %object
	.size	p_vendor_region_ppn_table, 4
p_vendor_region_ppn_table:
	.space	4
	.section	.bss.req_erase,"aw",%nobits
	.align	2
	.set	.LANCHOR106,. + 0
	.type	req_erase, %object
	.size	req_erase, 4
req_erase:
	.space	4
	.section	.bss.req_gc,"aw",%nobits
	.align	2
	.set	.LANCHOR93,. + 0
	.type	req_gc, %object
	.size	req_gc, 4
req_gc:
	.space	4
	.section	.bss.req_gc_dst,"aw",%nobits
	.align	2
	.set	.LANCHOR113,. + 0
	.type	req_gc_dst, %object
	.size	req_gc_dst, 4
req_gc_dst:
	.space	4
	.section	.bss.req_prgm,"aw",%nobits
	.align	2
	.set	.LANCHOR114,. + 0
	.type	req_prgm, %object
	.size	req_prgm, 4
req_prgm:
	.space	4
	.section	.bss.req_read,"aw",%nobits
	.align	2
	.set	.LANCHOR112,. + 0
	.type	req_read, %object
	.size	req_read, 4
req_read:
	.space	4
	.section	.bss.req_sys,"aw",%nobits
	.align	2
	.set	.LANCHOR148,. + 0
	.type	req_sys, %object
	.size	req_sys, 20
req_sys:
	.space	20
	.section	.bss.sftl_nand_check_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR120,. + 0
	.type	sftl_nand_check_buf, %object
	.size	sftl_nand_check_buf, 4
sftl_nand_check_buf:
	.space	4
	.section	.bss.sftl_nand_check_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR122,. + 0
	.type	sftl_nand_check_spare_buf, %object
	.size	sftl_nand_check_spare_buf, 4
sftl_nand_check_spare_buf:
	.space	4
	.section	.bss.sftl_temp_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR121,. + 0
	.type	sftl_temp_buf, %object
	.size	sftl_temp_buf, 4
sftl_temp_buf:
	.space	4
	.section	.data.ftl_gc_temp_block_bops_scan_page_addr,"aw",%progbits
	.align	1
	.set	.LANCHOR162,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.short	-1
	.section	.data.gFtlInitStatus,"aw",%progbits
	.align	2
	.set	.LANCHOR86,. + 0
	.type	gFtlInitStatus, %object
	.size	gFtlInitStatus, 4
gFtlInitStatus:
	.word	-1
	.section	.data.power_up_flag,"aw",%progbits
	.align	2
	.set	.LANCHOR182,. + 0
	.type	power_up_flag, %object
	.size	power_up_flag, 4
power_up_flag:
	.word	1
	.section	.rodata.FlashEraseBlocks.str1.1,"aMS",%progbits,1
.LC79:
	.ascii	"%s: addr: %x is in id block!!!!!!!!!!\012\000"
.LC80:
	.ascii	"not free: w: d:\000"
.LC81:
	.ascii	"not free: w: s:\000"
	.section	.rodata.FlashProgPages.str1.1,"aMS",%progbits,1
.LC85:
	.ascii	"prog read error: = %x\012\000"
.LC86:
	.ascii	"prog read s error: = %x %x %x\012\000"
.LC87:
	.ascii	"prog read d error: = %x %x %x\012\000"
	.section	.rodata.FtlBbmMapBadBlock.str1.1,"aMS",%progbits,1
.LC0:
	.ascii	"phyBlk = 0x%x die = %d block_in_die = 0x%x 0x%8x\012"
	.ascii	"\000"
	.section	.rodata.FtlBbmTblFlush.str1.1,"aMS",%progbits,1
.LC101:
	.ascii	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\012\000"
.LC102:
	.ascii	"FtlBbmTblFlush error:%x\012\000"
.LC103:
	.ascii	"FtlBbmTblFlush error = %x error count = %d\012\000"
	.section	.rodata.FtlFreeSysBlkQueueOut.str1.1,"aMS",%progbits,1
.LC82:
	.ascii	"FtlFreeSysBlkQueueOut = %x, free count = %d, error\012"
	.ascii	"\000"
	.section	.rodata.FtlGcFreeBadSuperBlk.str1.1,"aMS",%progbits,1
.LC104:
	.ascii	"FtlGcFreeBadSuperBlk 0x%x\012\000"
	.section	.rodata.FtlGcMarkBadPhyBlk.str1.1,"aMS",%progbits,1
.LC74:
	.ascii	"FtlGcMarkBadPhyBlk %d 0x%x\012\000"
	.section	.rodata.FtlGcRefreshBlock.str1.1,"aMS",%progbits,1
.LC73:
	.ascii	"FtlGcRefreshBlock  0x%x\012\000"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",%progbits,1
.LC100:
	.ascii	"FtlGcScanTempBlk Error ID %x %x!!!!!!! \012\000"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",%progbits,1
.LC108:
	.ascii	"no ect\000"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",%progbits,1
.LC88:
	.ascii	"FtlMapWritePage error = %x \012\000"
.LC89:
	.ascii	"FtlMapWritePage error = %x error count = %d\012\000"
	.section	.rodata.FtlMemInit.str1.1,"aMS",%progbits,1
.LC84:
	.ascii	"%s error allocating memory. return -1\012\000"
	.section	.rodata.FtlPrintInfo2buf.str1.1,"aMS",%progbits,1
.LC2:
	.ascii	"FLASH INFO:\012\000"
.LC3:
	.ascii	"Device Capacity: %d MB\012\000"
.LC4:
	.ascii	"FTL INFO:\012\000"
.LC5:
	.ascii	"g_MaxLpn = 0x%x\012\000"
.LC6:
	.ascii	"g_VaildLpn = 0x%x\012\000"
.LC7:
	.ascii	"read_page_count = 0x%x\012\000"
.LC8:
	.ascii	"discard_page_count = 0x%x\012\000"
.LC9:
	.ascii	"write_page_count = 0x%x\012\000"
.LC10:
	.ascii	"cache_write_count = 0x%x\012\000"
.LC11:
	.ascii	"l2p_write_count = 0x%x\012\000"
.LC12:
	.ascii	"gc_page_count = 0x%x\012\000"
.LC13:
	.ascii	"totle_write = %d MB\012\000"
.LC14:
	.ascii	"totle_read = %d MB\012\000"
.LC15:
	.ascii	"GSV = 0x%x\012\000"
.LC16:
	.ascii	"GDV = 0x%x\012\000"
.LC17:
	.ascii	"bad blk num = %d\012\000"
.LC18:
	.ascii	"free_superblocks = 0x%x\012\000"
.LC19:
	.ascii	"mlc_EC = 0x%x\012\000"
.LC20:
	.ascii	"slc_EC = 0x%x\012\000"
.LC21:
	.ascii	"avg_EC = 0x%x\012\000"
.LC22:
	.ascii	"sys_EC = 0x%x\012\000"
.LC23:
	.ascii	"max_EC = 0x%x\012\000"
.LC24:
	.ascii	"min_EC = 0x%x\012\000"
.LC25:
	.ascii	"PLT = 0x%x\012\000"
.LC26:
	.ascii	"POT = 0x%x\012\000"
.LC27:
	.ascii	"MaxSector = 0x%x\012\000"
.LC28:
	.ascii	"init_sys_blks_pp = 0x%x\012\000"
.LC29:
	.ascii	"sys_blks_pp = 0x%x\012\000"
.LC30:
	.ascii	"free sysblock = 0x%x\012\000"
.LC31:
	.ascii	"data_blks_pp = 0x%x\012\000"
.LC32:
	.ascii	"data_op_blks_pp = 0x%x\012\000"
.LC33:
	.ascii	"max_data_blks = 0x%x\012\000"
.LC34:
	.ascii	"Sys.id = 0x%x\012\000"
.LC35:
	.ascii	"Bbt.id = 0x%x\012\000"
.LC36:
	.ascii	"ACT.page = 0x%x\012\000"
.LC37:
	.ascii	"ACT.plane = 0x%x\012\000"
.LC38:
	.ascii	"ACT.id = 0x%x\012\000"
.LC39:
	.ascii	"ACT.mode = 0x%x\012\000"
.LC40:
	.ascii	"ACT.a_pages = 0x%x\012\000"
.LC41:
	.ascii	"ACT VPC = 0x%x\012\000"
.LC42:
	.ascii	"BUF.page = 0x%x\012\000"
.LC43:
	.ascii	"BUF.plane = 0x%x\012\000"
.LC44:
	.ascii	"BUF.id = 0x%x\012\000"
.LC45:
	.ascii	"BUF.mode = 0x%x\012\000"
.LC46:
	.ascii	"BUF.a_pages = 0x%x\012\000"
.LC47:
	.ascii	"BUF VPC = 0x%x\012\000"
.LC48:
	.ascii	"TMP.page = 0x%x\012\000"
.LC49:
	.ascii	"TMP.plane = 0x%x\012\000"
.LC50:
	.ascii	"TMP.id = 0x%x\012\000"
.LC51:
	.ascii	"TMP.mode = 0x%x\012\000"
.LC52:
	.ascii	"TMP.a_pages = 0x%x\012\000"
.LC53:
	.ascii	"GC.page = 0x%x\012\000"
.LC54:
	.ascii	"GC.plane = 0x%x\012\000"
.LC55:
	.ascii	"GC.id = 0x%x\012\000"
.LC56:
	.ascii	"GC.mode = 0x%x\012\000"
.LC57:
	.ascii	"GC.a_pages = 0x%x\012\000"
.LC58:
	.ascii	"WR_CHK = %x %x %x\012\000"
.LC59:
	.ascii	"Read Err Cnt = 0x%x\012\000"
.LC60:
	.ascii	"Prog Err Cnt = 0x%x\012\000"
.LC61:
	.ascii	"gc_free_blk_th= 0x%x\012\000"
.LC62:
	.ascii	"gc_merge_free_blk_th= 0x%x\012\000"
.LC63:
	.ascii	"gc_skip_write_count= 0x%x\012\000"
.LC64:
	.ascii	"gc_blk_index= 0x%x\012\000"
.LC65:
	.ascii	"free min EC= 0x%x\012\000"
.LC66:
	.ascii	"free max EC= 0x%x\012\000"
.LC67:
	.ascii	"GC__SB VPC = 0x%x\012\000"
.LC68:
	.ascii	"%d. [0x%x]=0x%x 0x%x  0x%x\012\000"
.LC69:
	.ascii	"free %d. [0x%x] 0x%x  0x%x\012\000"
	.section	.rodata.FtlProgPages.str1.1,"aMS",%progbits,1
.LC111:
	.ascii	"Ftlwrite decrement_vpc_count %x = %d\012\000"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",%progbits,1
.LC106:
	.ascii	"spuer block %x vpn is 0\012 \000"
	.section	.rodata.FtlVendorPartRead.str1.1,"aMS",%progbits,1
.LC107:
	.ascii	"FtlVendorPartRead refresh = %x phyAddr = %x\012\000"
	.section	.rodata.FtlVpcCheckAndModify.str1.1,"aMS",%progbits,1
.LC110:
	.ascii	"FtlCheckVpc %x = %x  %x\012\000"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",%progbits,1
.LC109:
	.ascii	"FtlVpcTblFlush error = %x error count = %d\012\000"
	.section	.rodata.FtlWrite.str1.1,"aMS",%progbits,1
.LC113:
	.ascii	"FtlWrite: lpa error:%x %x\012\000"
	.section	.rodata.GetSwlReplaceBlock.str1.1,"aMS",%progbits,1
.LC72:
	.ascii	"swblk %x ,avg = %x max= %x vpc= %x,ec=%x ,max ec=%x"
	.ascii	"\012\000"
	.section	.rodata.INSERT_DATA_LIST.str1.1,"aMS",%progbits,1
.LC1:
	.ascii	"\012!!!!! error @ func:%s - line:%d\012\000"
	.section	.rodata.__func__.10026,"a",%progbits
	.set	.LANCHOR176,. + 0
	.type	__func__.10026, %object
	.size	__func__.10026, 19
__func__.10026:
	.ascii	"FtlGcFreeTempBlock\000"
	.section	.rodata.__func__.10137,"a",%progbits
	.set	.LANCHOR180,. + 0
	.type	__func__.10137, %object
	.size	__func__.10137, 23
__func__.10137:
	.ascii	"rk_ftl_garbage_collect\000"
	.section	.rodata.__func__.10399,"a",%progbits
	.set	.LANCHOR147,. + 0
	.type	__func__.10399, %object
	.size	__func__.10399, 15
__func__.10399:
	.ascii	"FlashReadPages\000"
	.section	.rodata.__func__.10417,"a",%progbits
	.set	.LANCHOR153,. + 0
	.type	__func__.10417, %object
	.size	__func__.10417, 15
__func__.10417:
	.ascii	"FlashProgPages\000"
	.section	.rodata.__func__.10440,"a",%progbits
	.set	.LANCHOR104,. + 0
	.type	__func__.10440, %object
	.size	__func__.10440, 17
__func__.10440:
	.ascii	"FlashEraseBlocks\000"
	.section	.rodata.__func__.8806,"a",%progbits
	.set	.LANCHOR138,. + 0
	.type	__func__.8806, %object
	.size	__func__.8806, 11
__func__.8806:
	.ascii	"FtlMemInit\000"
	.section	.rodata.__func__.8930,"a",%progbits
	.set	.LANCHOR175,. + 0
	.type	__func__.8930, %object
	.size	__func__.8930, 13
__func__.8930:
	.ascii	"FtlProgPages\000"
	.section	.rodata.__func__.8958,"a",%progbits
	.set	.LANCHOR183,. + 0
	.type	__func__.8958, %object
	.size	__func__.8958, 9
__func__.8958:
	.ascii	"FtlWrite\000"
	.section	.rodata.__func__.9064,"a",%progbits
	.set	.LANCHOR187,. + 0
	.type	__func__.9064, %object
	.size	__func__.9064, 14
__func__.9064:
	.ascii	"FtlWriteToIDB\000"
	.section	.rodata.__func__.9105,"a",%progbits
	.set	.LANCHOR139,. + 0
	.type	__func__.9105, %object
	.size	__func__.9105, 14
__func__.9105:
	.ascii	"FtlBbt2Bitmap\000"
	.section	.rodata.__func__.9148,"a",%progbits
	.set	.LANCHOR150,. + 0
	.type	__func__.9148, %object
	.size	__func__.9148, 11
__func__.9148:
	.ascii	"FtlLoadBbt\000"
	.section	.rodata.__func__.9263,"a",%progbits
	.set	.LANCHOR49,. + 0
	.type	__func__.9263, %object
	.size	__func__.9263, 17
__func__.9263:
	.ascii	"INSERT_FREE_LIST\000"
	.section	.rodata.__func__.9268,"a",%progbits
	.set	.LANCHOR46,. + 0
	.type	__func__.9268, %object
	.size	__func__.9268, 17
__func__.9268:
	.ascii	"INSERT_DATA_LIST\000"
	.section	.rodata.__func__.9299,"a",%progbits
	.set	.LANCHOR50,. + 0
	.type	__func__.9299, %object
	.size	__func__.9299, 17
__func__.9299:
	.ascii	"List_remove_node\000"
	.section	.rodata.__func__.9331,"a",%progbits
	.set	.LANCHOR54,. + 0
	.type	__func__.9331, %object
	.size	__func__.9331, 22
__func__.9331:
	.ascii	"List_update_data_list\000"
	.section	.rodata.__func__.9340,"a",%progbits
	.set	.LANCHOR156,. + 0
	.type	__func__.9340, %object
	.size	__func__.9340, 16
__func__.9340:
	.ascii	"load_l2p_region\000"
	.section	.rodata.__func__.9373,"a",%progbits
	.set	.LANCHOR107,. + 0
	.type	__func__.9373, %object
	.size	__func__.9373, 26
__func__.9373:
	.ascii	"ftl_map_blk_alloc_new_blk\000"
	.section	.rodata.__func__.9384,"a",%progbits
	.set	.LANCHOR157,. + 0
	.type	__func__.9384, %object
	.size	__func__.9384, 15
__func__.9384:
	.ascii	"ftl_map_blk_gc\000"
	.section	.rodata.__func__.9399,"a",%progbits
	.set	.LANCHOR154,. + 0
	.type	__func__.9399, %object
	.size	__func__.9399, 31
__func__.9399:
	.ascii	"Ftl_write_map_blk_to_last_page\000"
	.section	.rodata.__func__.9413,"a",%progbits
	.set	.LANCHOR155,. + 0
	.type	__func__.9413, %object
	.size	__func__.9413, 16
__func__.9413:
	.ascii	"FtlMapWritePage\000"
	.section	.rodata.__func__.9438,"a",%progbits
	.set	.LANCHOR57,. + 0
	.type	__func__.9438, %object
	.size	__func__.9438, 22
__func__.9438:
	.ascii	"select_l2p_ram_region\000"
	.section	.rodata.__func__.9455,"a",%progbits
	.set	.LANCHOR159,. + 0
	.type	__func__.9455, %object
	.size	__func__.9455, 9
__func__.9455:
	.ascii	"log2phys\000"
	.section	.rodata.__func__.9528,"a",%progbits
	.set	.LANCHOR171,. + 0
	.type	__func__.9528, %object
	.size	__func__.9528, 15
__func__.9528:
	.ascii	"FtlVpcTblFlush\000"
	.section	.rodata.__func__.9550,"a",%progbits
	.set	.LANCHOR149,. + 0
	.type	__func__.9550, %object
	.size	__func__.9550, 14
__func__.9550:
	.ascii	"FtlScanSysBlk\000"
	.section	.rodata.__func__.9607,"a",%progbits
	.set	.LANCHOR151,. + 0
	.type	__func__.9607, %object
	.size	__func__.9607, 15
__func__.9607:
	.ascii	"FtlLoadSysInfo\000"
	.section	.rodata.__func__.9670,"a",%progbits
	.set	.LANCHOR160,. + 0
	.type	__func__.9670, %object
	.size	__func__.9670, 16
__func__.9670:
	.ascii	"FtlReUsePrevPpa\000"
	.section	.rodata.__func__.9704,"a",%progbits
	.set	.LANCHOR166,. + 0
	.type	__func__.9704, %object
	.size	__func__.9704, 22
__func__.9704:
	.ascii	"FtlRecoverySuperblock\000"
	.section	.rodata.__func__.9761,"a",%progbits
	.set	.LANCHOR60,. + 0
	.type	__func__.9761, %object
	.size	__func__.9761, 16
__func__.9761:
	.ascii	"make_superblock\000"
	.section	.rodata.__func__.9782,"a",%progbits
	.set	.LANCHOR146,. + 0
	.type	__func__.9782, %object
	.size	__func__.9782, 18
__func__.9782:
	.ascii	"SupperBlkListInit\000"
	.section	.rodata.__func__.9807,"a",%progbits
	.set	.LANCHOR173,. + 0
	.type	__func__.9807, %object
	.size	__func__.9807, 21
__func__.9807:
	.ascii	"FtlVpcCheckAndModify\000"
	.section	.rodata.__func__.9823,"a",%progbits
	.set	.LANCHOR161,. + 0
	.type	__func__.9823, %object
	.size	__func__.9823, 14
__func__.9823:
	.ascii	"ftl_check_vpc\000"
	.section	.rodata.__func__.9908,"a",%progbits
	.set	.LANCHOR163,. + 0
	.type	__func__.9908, %object
	.size	__func__.9908, 25
__func__.9908:
	.ascii	"allocate_data_superblock\000"
	.section	.rodata.__func__.9929,"a",%progbits
	.set	.LANCHOR174,. + 0
	.type	__func__.9929, %object
	.size	__func__.9929, 29
__func__.9929:
	.ascii	"allocate_new_data_superblock\000"
	.section	.rodata.__func__.9936,"a",%progbits
	.set	.LANCHOR88,. + 0
	.type	__func__.9936, %object
	.size	__func__.9936, 19
__func__.9936:
	.ascii	"get_new_active_ppa\000"
	.section	.rodata.__func__.9949,"a",%progbits
	.set	.LANCHOR164,. + 0
	.type	__func__.9949, %object
	.size	__func__.9949, 16
__func__.9949:
	.ascii	"update_vpc_list\000"
	.section	.rodata.__func__.9956,"a",%progbits
	.set	.LANCHOR165,. + 0
	.type	__func__.9956, %object
	.size	__func__.9956, 20
__func__.9956:
	.ascii	"decrement_vpc_count\000"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",%progbits,1
.LC105:
	.ascii	"decrement_vpc_count %x = %d\012\000"
	.section	.rodata.ftl_check_vpc.str1.1,"aMS",%progbits,1
.LC94:
	.ascii	"...%s enter...\012\000"
.LC95:
	.ascii	"FtlCheckVpc2 %x = %x  %x\012\000"
.LC96:
	.ascii	"free blk vpc error %x = %x  %x\012\000"
	.section	.rodata.ftl_map_blk_alloc_new_blk.str1.1,"aMS",%progbits,1
.LC83:
	.ascii	"FtlFreeSysBlkQueueOut = %x, free count = %d\012\000"
	.section	.rodata.ftl_scan_all_data.str1.1,"aMS",%progbits,1
.LC97:
	.ascii	"ftl_scan_all_data = %x\012\000"
.LC98:
	.ascii	"scan lpa = %x ppa= %x\012\000"
.LC99:
	.ascii	"lba = %x,addr= %x,spare= %x %x %x %x data=%x %x\012"
	.ascii	"\000"
	.section	.rodata.load_l2p_region.str1.1,"aMS",%progbits,1
.LC90:
	.ascii	"region_id = %x phyAddr = %x\012\000"
.LC91:
	.ascii	"spare:\000"
.LC92:
	.ascii	"map_ppn:\000"
.LC93:
	.ascii	"load_l2p_region refresh = %x phyAddr = %x\012\000"
	.section	.rodata.rk_ftl_garbage_collect.str1.1,"aMS",%progbits,1
.LC112:
	.ascii	"SWL %x, FSB = %x vpc= %x,ec=%x th=%x\012\000"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",%progbits,1
.LC75:
	.ascii	"%s 0x%x:\000"
.LC76:
	.ascii	"%x \000"
.LC77:
	.ascii	"%02x \000"
.LC78:
	.ascii	"\012\000"
	.section	.rodata.rknand_proc_ftlread.str1.1,"aMS",%progbits,1
.LC70:
	.ascii	"SFTL version: 5.0.48 20180930\000"
.LC71:
	.ascii	"%s\012\000"
	.section	.rodata.sftl_write.str1.1,"aMS",%progbits,1
.LC114:
	.ascii	"write_idblock fix data %x %x %x\012\000"
.LC115:
	.ascii	"write_idblock fail! %x %x %x %x\012\000"
.LC116:
	.ascii	"%s idb buffer alloc fail\012\000"
	.hidden	free
