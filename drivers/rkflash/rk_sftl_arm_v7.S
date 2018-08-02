/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0
 * date: 2018-08-02
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
	movs	r2, #221
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
	movs	r2, #214
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
	movw	r2, #379
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
	mov	r2, #470
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
	movw	r2, #481
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
	mov	r2, #784
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
	movw	r2, #2097
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
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #1
	strb	r3, [r4, #9]
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
	mov	r8, r0
	ldr	r1, .L257
	bl	sprintf
	ldr	r3, .L257+4
	add	r5, r8, r0
	ldr	r1, .L257+8
	mov	r0, r5
	ldr	r4, .L257+12
	ldr	r2, [r3]
	bl	sprintf
	add	r5, r5, r0
	ldr	r1, .L257+16
	mov	r0, r5
	ldr	r10, .L257+352
	bl	sprintf
	ldr	r3, .L257+20
	add	r5, r5, r0
	ldr	r1, .L257+24
	mov	r0, r5
	ldr	r6, .L257+28
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+32
	add	r5, r5, r0
	ldr	r1, .L257+36
	mov	r0, r5
	ldr	r7, .L257+40
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+44
	add	r5, r5, r0
	ldr	r1, .L257+48
	mov	r0, r5
	ldr	fp, .L257+356
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+52
	add	r5, r5, r0
	ldr	r1, .L257+56
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+60
	add	r5, r5, r0
	ldr	r1, .L257+64
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+68
	add	r5, r5, r0
	ldr	r1, .L257+72
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+76
	add	r5, r5, r0
	ldr	r1, .L257+80
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+84
	add	r5, r5, r0
	ldr	r1, .L257+88
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+92
	add	r5, r5, r0
	ldr	r1, .L257+96
	mov	r0, r5
	ldr	r2, [r3]
	lsrs	r2, r2, #11
	bl	sprintf
	ldr	r3, .L257+100
	add	r5, r5, r0
	ldr	r1, .L257+104
	mov	r0, r5
	ldr	r2, [r3]
	lsrs	r2, r2, #11
	bl	sprintf
	ldr	r3, .L257+108
	add	r5, r5, r0
	ldr	r1, .L257+112
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+116
	add	r5, r5, r0
	ldr	r1, .L257+120
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r4, #6]
	ldr	r1, .L257+124
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r10]
	ldr	r1, .L257+128
	mov	r0, r5
	bl	sprintf
	ldr	r3, .L257+132
	add	r5, r5, r0
	ldr	r1, .L257+136
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+140
	add	r5, r5, r0
	ldr	r1, .L257+144
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+148
	add	r5, r5, r0
	ldr	r1, .L257+152
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+156
	add	r5, r5, r0
	ldr	r1, .L257+160
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+164
	add	r5, r5, r0
	ldr	r1, .L257+168
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+172
	add	r5, r5, r0
	ldr	r1, .L257+176
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r6, #30]
	ldr	r1, .L257+180
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r6, #28]
	ldr	r1, .L257+184
	mov	r0, r5
	bl	sprintf
	ldr	r3, .L257+188
	add	r5, r5, r0
	ldr	r1, .L257+192
	mov	r0, r5
	ldr	r6, .L257+196
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+200
	add	r5, r5, r0
	ldr	r1, .L257+204
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+208
	add	r5, r5, r0
	ldr	r1, .L257+212
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+216
	add	r5, r5, r0
	ldr	r1, .L257+220
	mov	r0, r5
	ldrh	r2, [r3, #6]
	bl	sprintf
	ldr	r3, .L257+224
	add	r5, r5, r0
	ldr	r1, .L257+228
	mov	r0, r5
	ldrh	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+232
	add	r5, r5, r0
	ldr	r1, .L257+236
	mov	r0, r5
	ldrh	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+240
	add	r5, r5, r0
	ldr	r1, .L257+244
	mov	r0, r5
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L257+248
	add	r5, r5, r0
	ldr	r1, .L257+252
	mov	r0, r5
	ldrh	r2, [r3]
	bl	sprintf
	ldrh	r2, [r4]
	add	r5, r5, r0
	ldr	r4, .L257+256
	mov	r0, r5
	ldr	r1, .L257+260
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r4, #2]
	ldr	r1, .L257+264
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldr	r1, .L257+268
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r4]
	ldr	r1, .L257+272
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	ldr	r1, .L257+276
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r4, #4]
	ldr	r1, .L257+280
	mov	r0, r5
	bl	sprintf
	ldr	r3, [r6]
	add	r5, r5, r0
	ldrh	r2, [r4]
	mov	r0, r5
	ldr	r4, .L257+284
	ldr	r1, .L257+288
	ldrh	r2, [r3, r2, lsl #1]
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r4, #2]
	ldr	r1, .L257+292
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldr	r1, .L257+296
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r4]
	ldr	r1, .L257+300
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	ldr	r1, .L257+304
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r4, #4]
	ldr	r1, .L257+308
	mov	r0, r5
	bl	sprintf
	ldr	r3, [r6]
	add	r5, r5, r0
	ldrh	r2, [r4]
	mov	r0, r5
	ldr	r4, .L257+312
	ldr	r1, .L257+316
	ldrh	r2, [r3, r2, lsl #1]
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r4, #2]
	ldr	r1, .L257+320
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldr	r1, .L257+324
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r4]
	ldr	r1, .L257+328
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	ldr	r1, .L257+332
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r4, #4]
	ldr	r1, .L257+336
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r7, #2]
	ldr	r1, .L257+340
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldr	r1, .L257+344
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r7]
	ldr	r1, .L257+348
	mov	r0, r5
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
	.word	.LANCHOR39
	.word	.LANCHOR59
	.word	.LC6
	.word	.LANCHOR80
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
	.word	.LANCHOR34
	.word	.LC27
	.word	.LANCHOR42
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
	.word	.LANCHOR51
	.word	.LC35
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
	.word	.LC50
	.word	.LC51
	.word	.LC52
	.word	.LC53
	.word	.LC54
	.word	.LC55
	.word	.LANCHOR48
	.word	.LANCHOR81
.L258:
	bl	sprintf
	add	r5, r5, r0
	ldrb	r2, [r7, #8]	@ zero_extendqisi2
	ldr	r1, .L260
	mov	r0, r5
	bl	sprintf
	add	r5, r5, r0
	ldrh	r2, [r7, #4]
	ldr	r1, .L260+4
	mov	r0, r5
	bl	sprintf
	ldr	r3, [fp, #76]
	add	r5, r5, r0
	ldr	r1, .L260+8
	mov	r0, r5
	str	r3, [sp]
	ldr	r3, [fp, #84]
	ldr	r2, [fp, #80]
	bl	sprintf
	adds	r4, r5, r0
	ldr	r2, [fp, #72]
	ldr	r1, .L260+12
	mov	r0, r4
	bl	sprintf
	add	r4, r4, r0
	ldr	r2, [fp, #96]
	ldr	r1, .L260+16
	mov	r0, r4
	bl	sprintf
	ldr	r3, .L260+20
	add	r4, r4, r0
	ldr	r1, .L260+24
	mov	r0, r4
	ldrh	r2, [r3]
	bl	sprintf
	ldr	r3, .L260+28
	add	r4, r4, r0
	ldr	r1, .L260+32
	mov	r0, r4
	ldrh	r2, [r3]
	bl	sprintf
	ldr	r3, .L260+36
	add	r4, r4, r0
	ldr	r1, .L260+40
	mov	r0, r4
	ldr	r2, [r3]
	bl	sprintf
	ldr	r3, .L260+44
	add	r4, r4, r0
	ldr	r1, .L260+48
	mov	r0, r4
	ldrh	r2, [r3]
	bl	sprintf
	add	r4, r4, r0
	bl	GetFreeBlockMinEraseCount
	ldr	r1, .L260+52
	mov	r2, r0
	mov	r0, r4
	bl	sprintf
	add	r4, r4, r0
	ldrh	r0, [r10]
	bl	GetFreeBlockMaxEraseCount
	ldr	r1, .L260+56
	mov	r2, r0
	mov	r0, r4
	bl	sprintf
	ldr	r3, .L260+60
	add	r4, r4, r0
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
	ldr	r1, .L260+64
	ldrh	r2, [r2, r3, lsl #1]
	bl	sprintf
	add	r4, r4, r0
.L248:
	movs	r0, #0
	ldr	r5, .L260+68
	ldr	fp, .L260+84
	movs	r7, #0
	bl	List_get_gc_head_node
	uxth	r3, r0
.L250:
	movw	r2, #65535
	cmp	r3, r2
	beq	.L249
	ldr	r2, [fp]
	mov	r10, #6
	mul	r10, r10, r3
	mov	r0, r4
	ldr	r1, .L260+72
	ldrh	r2, [r2, r3, lsl #1]
	str	r2, [sp, #8]
	ldr	r2, [r5]
	add	r2, r2, r10
	ldrh	r2, [r2, #4]
	str	r2, [sp, #4]
	ldr	r2, [r6]
	ldrh	r2, [r2, r3, lsl #1]
	str	r2, [sp]
	mov	r2, r7
	bl	sprintf
	adds	r7, r7, #1
	ldr	r3, [r5]
	cmp	r7, #16
	add	r4, r4, r0
	ldrh	r3, [r3, r10]
	bne	.L250
.L249:
	ldr	r3, .L260+76
	movs	r7, #0
	ldr	r2, [r5]
	ldr	r10, .L260+84
	ldr	r3, [r3]
	ldr	fp, .L260+88
	subs	r3, r3, r2
	ldr	r2, .L260+80
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
	mov	r1, fp
	ldrh	r2, [r2, r3, lsl #1]
	str	r2, [sp, #4]
	ldr	r2, [r5]
	add	r2, r2, r6
	ldrh	r2, [r2, #4]
	str	r2, [sp]
	mov	r2, r7
	adds	r7, r7, #1
	bl	sprintf
	cmp	r7, #4
	add	r4, r4, r0
	beq	.L251
	ldr	r3, [r5]
	ldrh	r3, [r3, r6]
	b	.L252
.L261:
	.align	2
.L260:
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
	push	{r3, r4, r5, lr}
	mov	r5, r0
	ldr	r2, .L263
	ldr	r1, .L263+4
	bl	sprintf
	adds	r4, r5, r0
	mov	r0, r4
	bl	FtlPrintInfo2buf
	add	r0, r0, r4
	subs	r0, r0, r5
	pop	{r3, r4, r5, pc}
.L264:
	.align	2
.L263:
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
	ldr	r3, .L293
	ldr	r6, .L293+4
	ldr	r5, [r3]
	mov	r10, r3
	ldr	r1, [r6]
	cmp	r1, r5
	bcs	.L266
	ldr	r2, .L293+8
	movs	r3, #0
	ldr	r4, .L293+12
	mov	r0, r3
	ldrh	r1, [r2]
	ldr	r2, .L293+16
	str	r3, [r4]
	ldr	r7, [r2]
	mov	r2, r3
.L267:
	cmp	r2, r1
	bcc	.L268
	cbz	r3, .L269
	str	r0, [r4]
.L269:
	ldr	r7, [r4]
	mov	r0, r7
	bl	__aeabi_uidiv
	ldr	r3, .L293+20
	str	r0, [r6]
	ldr	r0, [r3]
	ldr	r3, .L293+24
	subs	r0, r7, r0
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	str	r0, [r4]
.L270:
	ldr	r6, [r6]
	add	r3, r5, #256
	cmp	r3, r6
	bls	.L275
	ldr	r2, .L293+28
	add	r3, r5, #768
	ldr	r2, [r2]
	cmp	r3, r2
	bls	.L275
.L277:
	movw	r4, #65535
.L276:
	mov	r0, r4
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L268:
	ldrh	r3, [r7, r2, lsl #1]
	adds	r2, r2, #1
	add	r0, r0, r3
	movs	r3, #1
	b	.L267
.L266:
	ldr	r2, .L293+28
	ldr	r3, [r2]
	cmp	r1, r3
	bls	.L270
	adds	r3, r3, #1
	ldr	r0, .L293+8
	str	r3, [r2]
	movs	r2, #0
	ldr	r3, .L293+16
	ldr	r3, [r3]
	subs	r3, r3, #2
.L272:
	ldrh	r1, [r0]
	cmp	r2, r1
	bcs	.L270
	ldrh	r1, [r3, #2]
	adds	r2, r2, #1
	adds	r1, r1, #1
	strh	r1, [r3, #2]!	@ movhi
	b	.L272
.L275:
	ldr	r3, .L293+32
	ldrh	r0, [r3]
	add	r0, r0, r0, lsl #1
	ubfx	r0, r0, #2, #16
	bl	GetFreeBlockMaxEraseCount
	add	r3, r5, #64
	mov	r2, r0
	cmp	r0, r3
	bcc	.L277
	ldr	r3, .L293+36
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L277
	ldr	r1, .L293+8
	movs	r0, #0
	mov	fp, #6
	ldrh	r1, [r1]
	str	r1, [sp, #20]
	ldr	r1, .L293+40
	ldr	r8, [r1]
	ldr	r1, .L293+16
	ldr	r7, [r1]
	movw	r1, #65535
	mov	ip, r1
.L278:
	ldrh	lr, [r3]
	movw	r4, #65535
	cmp	lr, r4
	bne	.L281
	mov	r4, ip
.L280:
	movw	r3, #65535
	cmp	r4, r3
	beq	.L277
	ldrh	r7, [r7, r4, lsl #1]
	lsl	r8, r4, #1
	cmp	r5, r7
	bcs	.L282
	bl	GetFreeBlockMinEraseCount
	cmp	r5, r0
	it	cc
	strcc	r1, [r10]
.L282:
	cmp	r6, r7
	bls	.L277
	add	r3, r7, #128
	cmp	r2, r3
	ble	.L277
	add	r3, r7, #256
	ldr	r0, .L293+28
	cmp	r6, r3
	bhi	.L283
	ldr	r1, [r0]
	add	r3, r7, #768
	cmp	r3, r1
	bcs	.L277
.L283:
	ldr	r3, .L293+44
	mov	r1, r4
	str	r2, [sp, #8]
	mov	r2, r6
	str	r7, [sp, #4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r8]
	str	r3, [sp]
	ldr	r3, [r0]
	ldr	r0, .L293+48
	bl	printf
	ldr	r3, .L293+52
	movs	r2, #1
	str	r2, [r3]
	b	.L276
.L281:
	adds	r0, r0, #1
	ldr	r4, [sp, #20]
	uxth	r0, r0
	cmp	r0, r4
	bhi	.L277
	ldrh	r4, [r3, #4]
	cbz	r4, .L279
	ldr	r4, .L293+56
	sub	r3, r3, r8
	asrs	r3, r3, #1
	muls	r3, r4, r3
	uxth	r4, r3
	ldrh	r3, [r7, r4, lsl #1]
	cmp	r5, r3
	bcs	.L280
	cmp	r1, r3
	itt	hi
	movhi	r1, r3
	movhi	ip, r4
.L279:
	mla	r3, fp, lr, r8
	b	.L278
.L294:
	.align	2
.L293:
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
	beq	.L296
	ldr	r2, .L297
	movs	r1, #0
	ldr	r2, [r2]
	strh	r1, [r2, r0, lsl #1]	@ movhi
	bl	INSERT_FREE_LIST
.L296:
	movs	r0, #0
	pop	{r3, pc}
.L298:
	.align	2
.L297:
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
	bne	.L300
	movw	r2, #2710
	ldr	r1, .L313
	ldr	r0, .L313+4
	bl	printf
.L300:
	ldr	r5, .L313+8
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L301
	movw	r2, #2711
	ldr	r1, .L313
	ldr	r0, .L313+4
	bl	printf
.L301:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L302
	movw	r2, #2712
	ldr	r1, .L313
	ldr	r0, .L313+4
	bl	printf
.L302:
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	movs	r3, #0
	strb	r3, [r4, #10]
	movw	r6, #65535
	adds	r2, r2, #8
	ldrh	r0, [r4, r2, lsl #1]
	ldr	r2, .L313+12
	ldrh	r1, [r2]
	mov	r2, r3
.L303:
	cmp	r0, r6
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	beq	.L305
	ldrh	r2, [r4, #4]
	ldrh	r6, [r4, #2]
	subs	r2, r2, #1
	uxth	r2, r2
	orr	r6, r6, r0, lsl #10
	movw	r0, #65535
	strh	r2, [r4, #4]	@ movhi
.L307:
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
	beq	.L307
	strb	r3, [r4, #6]
	ldrh	r1, [r4, #2]
	ldrh	r3, [r5]
	cmp	r1, r3
	bne	.L299
	cbz	r2, .L299
	movw	r2, #2733
	ldr	r1, .L313
	ldr	r0, .L313+4
	bl	printf
.L299:
	mov	r0, r6
	pop	{r3, r4, r5, r6, r7, pc}
.L305:
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
	b	.L303
.L314:
	.align	2
.L313:
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
	ldr	r1, .L320
	mov	fp, #1
	ldr	r2, .L320+4
	ldr	r5, [r1]
	ldr	r1, .L320+8
	str	r3, [r2]
	ldr	r2, .L320+12
	mov	r0, r5
	ldr	r1, [r1]
	ldrh	r2, [r2]
	str	r1, [sp, #4]
	ldr	r1, .L320+16
	ldrh	r1, [r1]
	str	r1, [sp]
	ldr	r1, .L320+20
	ldr	r10, [r1]
	ldr	r1, .L320+24
	ldrh	r7, [r1]
	ldr	r1, .L320+28
	ldr	r4, [r1]
	movs	r1, #12
	mla	r1, r2, r1, r1
	adds	r4, r4, #8
	add	r8, r5, r1
	mov	r1, r3
.L316:
	adds	r0, r0, #12
	ldr	r6, [sp]
	cmp	r0, r8
	add	ip, r3, r7
	add	r4, r4, #20
	add	lr, r1, r6
	bne	.L317
	ldr	r3, .L320+32
	mov	lr, #12
	mov	r8, #0
	ldr	r0, [r3]
	ldr	r3, .L320+8
	ldr	r4, [r3]
	ldr	r3, .L320+20
	ldr	ip, [r3]
.L318:
	cmp	r2, r0
	bcc	.L319
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L317:
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
	b	.L316
.L319:
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
	b	.L318
.L321:
	.align	2
.L320:
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
	ldr	r3, .L329
	mov	ip, #12
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	mov	fp, #20
	mov	lr, r4
	ldr	r7, [r3]
	ldr	r3, .L329+4
	ldr	r5, [r3]
.L323:
	uxth	r3, r4
	cmp	r1, r3
	bls	.L322
	mla	r8, fp, r3, r0
	movs	r2, #0
.L324:
	uxth	r3, r2
	cmp	r7, r3
	bls	.L325
	mul	r3, ip, r3
	ldr	r6, [r8, #8]
	adds	r2, r2, #1
	add	r10, r5, r3
	ldr	r3, [r5, r3]
	cmp	r3, r6
	bne	.L324
	str	lr, [r10, #8]
.L325:
	adds	r4, r4, #1
	b	.L323
.L322:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L330:
	.align	2
.L329:
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
	ldr	r3, .L338
	movs	r2, #0
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	ip, #12
	movs	r7, #1
	mov	lr, #20
	ldr	r4, [r3]
	ldr	r3, .L338+4
	ldr	r5, [r3]
.L332:
	uxth	r8, r2
	cmp	r1, r8
	bhi	.L336
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L336:
	mov	r10, #0
.L333:
	uxth	r3, r10
	cmp	r4, r3
	bls	.L334
	mla	r3, ip, r3, r5
	add	r10, r10, #1
	ldr	r6, [r3, #8]
	cmp	r6, #0
	bne	.L333
	mla	r8, lr, r8, r0
	str	r7, [r3, #8]
	ldr	r6, [r3]
	ldr	r3, [r3, #4]
	str	r6, [r8, #8]
	str	r3, [r8, #12]
.L334:
	adds	r2, r2, #1
	b	.L332
.L339:
	.align	2
.L338:
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
	ldr	r3, .L345
	ldr	r2, .L345+4
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L341:
	cmp	r3, r2
	bne	.L343
	movs	r0, #0
	bx	lr
.L343:
	ldrh	r1, [r3], #2
	cmp	r1, r0
	bne	.L341
	movs	r0, #1
	bx	lr
.L346:
	.align	2
.L345:
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
	ldr	r4, .L351
	ubfx	r0, r0, #10, #16
	mov	r6, r1
	mov	r7, r2
	bl	P2V_block_in_plane
	ldr	r3, .L351+4
	ldrh	r1, [r4]
	ldr	r2, [r3]
	movs	r3, #0
.L348:
	uxth	ip, r3
	cmp	ip, r1
	bcc	.L350
	bne	.L349
	strh	r0, [r2, ip, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L349
.L350:
	adds	r3, r3, #1
	add	ip, r2, r3, lsl #1
	ldrh	ip, [ip, #-2]
	cmp	ip, r0
	bne	.L348
.L349:
	ldr	r2, .L351+8
	movs	r0, #12
	ldr	r1, .L351+12
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
.L352:
	.align	2
.L351:
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
	ldr	r0, .L356
	bl	printf
	ldr	r0, .L356+4
	ldrh	r5, [r0]
	cmp	r4, r5
	beq	.L354
	ldr	r3, .L356+8
	ldrh	r1, [r3]
	cmp	r4, r1
	beq	.L354
	movw	r2, #65535
	cmp	r5, r2
	bne	.L355
	strh	r4, [r0]	@ movhi
.L354:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L355:
	cmp	r1, r2
	it	eq
	strheq	r4, [r3]	@ movhi
	b	.L354
.L357:
	.align	2
.L356:
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
	ldr	r4, .L362
	bl	P2V_block_in_plane
	mov	r2, r5
	mov	r6, r0
	ldrh	r1, [r4]
	ldr	r0, .L362+4
	bl	printf
	mov	r0, r6
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4]
	movs	r2, #0
	ldr	r0, .L362+8
.L359:
	uxth	r1, r2
	cmp	r3, r1
	bhi	.L361
	cmp	r3, #15
	itttt	ls
	addls	r2, r3, #1
	strhls	r2, [r4]	@ movhi
	ldrls	r2, .L362+8
	strhls	r5, [r2, r3, lsl #1]	@ movhi
	b	.L360
.L361:
	adds	r2, r2, #1
	add	r1, r0, r2, lsl #1
	ldrh	r1, [r1, #-2]
	cmp	r1, r5
	bne	.L359
.L360:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L363:
	.align	2
.L362:
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
	ldr	r3, .L370
	push	{r4, lr}
	ldrh	r3, [r3]
	cbz	r3, .L365
	ldr	r2, .L370+4
	ldrh	r1, [r2]
	movw	r2, #65535
	cmp	r1, r2
	bne	.L365
	ldr	r4, .L370+8
	ldrh	r2, [r4]
	cmp	r2, r3
	itt	cs
	movcs	r3, #0
	strhcs	r3, [r4]	@ movhi
	ldr	r3, .L370+12
	ldrh	r2, [r4]
	ldrh	r0, [r3, r2, lsl #1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
.L365:
	movs	r0, #0
	pop	{r4, pc}
.L371:
	.align	2
.L370:
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
.L375:
	cmp	r4, r10
	bcc	.L381
	ldr	r0, .L384
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L381:
	cbnz	r5, .L376
	mov	r2, r6
	mov	r1, fp
	ldr	r0, .L384+4
	bl	printf
.L376:
	cmp	r8, #4
	bne	.L377
	ldr	r1, [r7, r4, lsl #2]
.L383:
	ldr	r0, .L384+8
.L382:
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L380
	movs	r5, #0
	ldr	r0, .L384
	bl	printf
.L380:
	adds	r4, r4, #1
	add	r6, r6, r8
	b	.L375
.L377:
	cmp	r8, #2
	bne	.L379
	ldrsh	r1, [r7, r4, lsl #1]
	b	.L383
.L379:
	ldrb	r1, [r7, r4]	@ zero_extendqisi2
	ldr	r0, .L384+12
	b	.L382
.L385:
	.align	2
.L384:
	.word	.LC78
	.word	.LC75
	.word	.LC76
	.word	.LC77
	.size	rknand_print_hex, .-rknand_print_hex
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
	mov	r8, r1
	ldr	r3, .L404
	mov	r4, r0
	movs	r5, #0
	ldr	fp, .L404+12
	ldrh	r2, [r3, #12]
	mov	r10, r3
	str	r2, [sp, #4]
.L387:
	cmp	r5, r8
	bne	.L394
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L394:
	ldr	r3, [r4, #8]
	cbz	r3, .L388
	ldr	r3, [r4, #12]
	cbnz	r3, .L389
.L388:
	movs	r2, #96
	ldr	r1, .L404+4
	mov	r0, fp
	bl	printf
.L389:
	ldr	r6, .L404+8
	add	r2, sp, #8
	add	r1, sp, #12
	ldr	r0, [r4, #4]
	bl	l2p_addr_tran.isra.0
	ldr	r3, [r4, #12]
	ldr	r2, [r4, #8]
	ldr	r1, [sp, #12]
	ldrb	r0, [sp, #8]	@ zero_extendqisi2
	ldr	r7, [r6, #12]
	blx	r7
	ldrh	r3, [r10, #14]
	str	r0, [r4]
	cmp	r3, #4
	bne	.L391
	ldr	r0, [sp, #4]
	ldr	r3, [r4, #12]
	ldr	r2, [r4, #8]
	ldr	r1, [sp, #12]
	ldr	r6, [r6, #12]
	adds	r3, r3, #8
	add	r2, r2, #2048
	add	r1, r1, r0
	ldrb	r0, [sp, #8]	@ zero_extendqisi2
	blx	r6
	adds	r0, r0, #1
	beq	.L392
	ldr	r3, [r4, #12]
	ldr	r2, [r3, #12]
	adds	r2, r2, #1
	bne	.L391
	ldr	r2, [r3, #8]
	adds	r2, r2, #1
	bne	.L391
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L391
.L392:
	mov	r3, #-1
	str	r3, [r4]
.L391:
	adds	r5, r5, #1
	adds	r4, r4, #20
	b	.L387
.L405:
	.align	2
.L404:
	.word	.LANCHOR0
	.word	.LANCHOR104
	.word	.LANCHOR105
	.word	.LC1
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
	ldr	r3, .L416
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r5, .L416+4
	ldr	r3, [r3]
	ldr	r7, .L416+8
	ldr	r10, .L416+20
	str	r3, [r5, #8]
	ldr	r3, .L416+12
	ldr	r8, [r3]
	str	r8, [r5, #12]
.L407:
	ldr	r3, .L416+16
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L412
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L412:
	ldrh	r4, [r10]
	movw	r3, #65535
	ldr	fp, .L416+4
	strh	r3, [r7, #2]!	@ movhi
	subs	r4, r4, #1
	uxth	r4, r4
.L408:
	ldrh	r3, [r10]
	sub	r2, r3, #15
	cmp	r2, r4
	bgt	.L410
	mla	r3, r6, r3, r4
	movs	r2, #1
	mov	r1, r2
	mov	r0, fp
	lsls	r3, r3, #10
	str	r3, [r5, #4]
	bl	FlashReadPages
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L409
	ldrh	r2, [r8]
	movw	r3, #61664
	cmp	r2, r3
	bne	.L409
	strh	r4, [r7]	@ movhi
.L410:
	adds	r6, r6, #1
	b	.L407
.L409:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L408
.L417:
	.align	2
.L416:
	.word	.LANCHOR107
	.word	.LANCHOR106
	.word	.LANCHOR37+10
	.word	.LANCHOR108
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
	ldreq	r3, .L427
	sub	sp, sp, #88
	lsl	r7, r0, #10
	mov	r2, r1
	it	ne
	ldrne	r3, .L427+4
	mov	r6, r1
	add	r0, sp, #4
	movs	r1, #1
	ldrh	r5, [r3]
	ldr	r3, .L427+8
	subs	r5, r5, #1
	sxth	r5, r5
	str	r3, [sp, #12]
	add	r3, sp, #24
	str	r3, [sp, #16]
	orr	r3, r5, r7
	str	r3, [sp, #8]
	bl	FlashReadPages
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	bne	.L421
	mov	r8, #0
.L422:
	cmp	r8, r5
	ble	.L425
.L421:
	mov	r0, r5
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L425:
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
	bne	.L423
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	bne	.L423
	subs	r4, r4, #1
	sxth	r5, r4
	b	.L422
.L423:
	adds	r4, r4, #1
	sxth	r8, r4
	b	.L422
.L428:
	.align	2
.L427:
	.word	.LANCHOR20
	.word	.LANCHOR19
	.word	ftl_temp_buf
	.size	FtlGetLastWrittenPage, .-FtlGetLastWrittenPage
	.section	.text.FlashProgPages,"ax",%progbits
	.align	1
	.global	FlashProgPages
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashProgPages, %function
FlashProgPages:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	str	r3, [sp]
	mov	r10, r1
	mov	r7, r2
	mov	r4, r0
	ldr	r3, .L459
	mov	r5, r0
	movs	r6, #0
	ldrh	r8, [r3, #12]
	str	r3, [sp, #4]
.L430:
	cmp	r6, r10
	bne	.L438
	ldr	r3, [sp]
	cmp	r3, #0
	bne	.L445
.L458:
	movs	r0, #0
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L438:
	ldr	r3, [r5, #8]
	cbz	r3, .L431
	ldr	r3, [r5, #12]
	cbnz	r3, .L432
.L431:
	movs	r2, #126
	ldr	r1, .L459+4
	ldr	r0, .L459+8
	bl	printf
.L432:
	add	r2, sp, #12
	add	r1, sp, #16
	ldr	r0, [r5, #4]
	bl	l2p_addr_tran.isra.0
	ldr	r3, .L459+12
	ldr	r2, [r5, #8]
	ldr	r1, [sp, #16]
	ldr	fp, [r3, #8]
	ldrb	r0, [sp, #12]	@ zero_extendqisi2
	ldr	r3, [r5, #12]
	blx	fp
	cbnz	r0, .L433
	str	r0, [r5]
.L434:
	ldr	r3, [sp, #4]
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	bne	.L436
	ldr	r1, .L459+12
	ldr	r3, [r5, #12]
	ldr	r2, [r5, #8]
	ldr	fp, [r1, #8]
	ldr	r1, [sp, #16]
	adds	r3, r3, #8
	add	r2, r2, #2048
	ldrb	r0, [sp, #12]	@ zero_extendqisi2
	add	r1, r1, r8
	blx	fp
	cbz	r0, .L436
	mov	r3, #-1
	str	r3, [r5]
.L436:
	adds	r6, r6, #1
	adds	r5, r5, #20
	b	.L430
.L433:
	mov	r3, #-1
	str	r3, [r5]
	b	.L434
.L443:
	movs	r3, #0
	mov	r2, r7
	str	r3, [r8]
	movs	r1, #1
	str	r3, [r10]
	add	r0, sp, #20
	ldr	r3, [r4, #4]
	str	r8, [sp, #28]
	str	r10, [sp, #32]
	str	r3, [sp, #24]
	bl	FlashReadPages
	ldr	fp, [sp, #20]
	cmp	fp, #-1
	bne	.L440
	ldr	r1, [r4, #4]
	ldr	r0, .L459+16
	bl	printf
	str	fp, [r4]
.L440:
	ldr	r3, [r4, #12]
	cbz	r3, .L441
	ldr	r2, [r3]
	ldr	r3, [r10]
	cmp	r2, r3
	beq	.L441
	ldr	r1, [r4, #4]
	ldr	r0, .L459+20
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L441:
	ldr	r3, [r4, #8]
	cbz	r3, .L442
	ldr	r2, [r3]
	ldr	r3, [r8]
	cmp	r2, r3
	beq	.L442
	ldr	r1, [r4, #4]
	ldr	r0, .L459+24
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L442:
	adds	r5, r5, #1
	adds	r4, r4, #20
.L439:
	cmp	r6, r5
	bne	.L443
	b	.L458
.L445:
	movs	r5, #0
	ldr	r8, .L459+28
	ldr	r10, .L459+32
	b	.L439
.L460:
	.align	2
.L459:
	.word	.LANCHOR0
	.word	.LANCHOR109
	.word	.LC1
	.word	.LANCHOR105
	.word	.LC79
	.word	.LC80
	.word	.LC81
	.word	check_buf
	.word	.LANCHOR110
	.size	FlashProgPages, .-FlashProgPages
	.section	.text.FlashEraseBlocks,"ax",%progbits
	.align	1
	.global	FlashEraseBlocks
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FlashEraseBlocks, %function
FlashEraseBlocks:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r4, r5, r6, r7, r8, r10, lr}
	mov	r7, r2
	ldr	r5, .L472
	adds	r4, r0, #4
	movs	r6, #0
	ldr	r10, .L472+4
	ldrh	r8, [r5, #12]
.L462:
	cmp	r6, r7
	bne	.L468
	movs	r0, #0
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L468:
	add	r1, sp, #4
	mov	r2, sp
	ldr	r0, [r4]
	bl	l2p_addr_tran.isra.0
	ldr	r3, [r10, #4]
	ldr	r1, [sp, #4]
	ldrb	r0, [sp]	@ zero_extendqisi2
	blx	r3
	cbnz	r0, .L463
	str	r0, [r4, #-4]
.L464:
	ldrh	r3, [r5, #14]
	cmp	r3, #4
	bne	.L466
	ldr	r1, [sp, #4]
	ldr	r3, [r10, #4]
	ldrb	r0, [sp]	@ zero_extendqisi2
	add	r1, r1, r8
	blx	r3
	cbz	r0, .L466
	mov	r3, #-1
	str	r3, [r4, #-4]
.L466:
	adds	r6, r6, #1
	adds	r4, r4, #20
	b	.L462
.L463:
	mov	r3, #-1
	str	r3, [r4, #-4]
	b	.L464
.L473:
	.align	2
.L472:
	.word	.LANCHOR0
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
	bhi	.L474
	ldr	r4, .L483
	ldrh	r3, [r4, #6]
	cmp	r3, #1024
	beq	.L474
	cbz	r1, .L476
	bl	P2V_block_in_plane
	ldr	r3, .L483+4
	mov	r6, r0
	movs	r2, #1
	mov	r1, r2
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L483+8
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	ldr	r2, .L483+12
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L476:
	ldrh	r3, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #4]
	adds	r2, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	strh	r5, [r4, r2, lsl #1]	@ movhi
	strh	r3, [r4, #4]	@ movhi
.L474:
	pop	{r4, r5, r6, pc}
.L484:
	.align	2
.L483:
	.word	.LANCHOR38
	.word	.LANCHOR111
	.word	.LANCHOR43
	.word	.LANCHOR75
	.size	FtlFreeSysBlkQueueIn, .-FtlFreeSysBlkQueueIn
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
	ldr	r3, .L528
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r6, .L528+4
	mov	fp, #0
	mov	r5, fp
	mov	r4, fp
	str	r0, [r3]
	mov	r10, #20
	ldr	r3, .L528+8
	ldr	r8, [r6]
	str	r0, [sp, #4]
	ldrh	r3, [r3]
	str	r1, [sp]
	str	r3, [sp, #8]
	ldr	r3, .L528+12
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L528+16
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L528+20
	ldrh	r3, [r3]
	str	r3, [sp, #20]
.L486:
	ldr	r3, [sp, #8]
	uxth	r2, fp
	cmp	r3, r2
	bhi	.L490
	cmp	r5, #0
	beq	.L485
	mov	r0, r8
	movs	r7, #0
	mov	r8, #20
	mov	r2, r5
	movs	r1, #0
	bl	FlashEraseBlocks
.L493:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L495
	ldr	r3, [sp]
	cmp	r3, #0
	beq	.L511
	ldr	r3, .L528+24
	mov	r8, #1
	ldrh	r10, [r3]
	lsr	r3, r10, #2
	str	r3, [sp, #12]
.L496:
	movs	r6, #0
.L505:
	ldr	r3, .L528+8
	mov	fp, #0
	mov	r5, fp
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L528+4
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L528+28
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L528+12
	ldr	r3, [r3]
	str	r3, [sp, #24]
	ldr	r3, .L528+20
	ldrh	r3, [r3]
	str	r3, [sp, #28]
.L497:
	ldr	r3, [sp, #16]
	uxth	r2, fp
	cmp	r3, r2
	bhi	.L500
	cbz	r5, .L485
	ldr	fp, .L528+4
	movs	r3, #1
	mov	r2, r8
	mov	r1, r5
	ldr	r0, [sp, #8]
	movs	r7, #0
	bl	FlashProgPages
	movs	r3, #20
.L502:
	uxth	r2, r7
	cmp	r5, r2
	bhi	.L504
	ldr	r3, [sp, #12]
	add	r6, r6, r3
	uxth	r6, r6
	cmp	r10, r6
	bhi	.L505
	ldr	r7, .L528+4
	movs	r6, #0
	mov	r10, #20
.L506:
	uxth	r3, r6
	cmp	r5, r3
	bhi	.L508
	ldr	r3, [sp, #4]
	cmp	r3, #63
	bls	.L509
	ldr	r3, [sp]
	cbz	r3, .L485
.L509:
	ldr	r3, .L528+4
	mov	r2, r5
	mov	r1, r8
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L485:
	mov	r0, r4
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L490:
	mul	r2, r10, fp
	movs	r3, #0
	ldr	r1, [sp, #4]
	str	r3, [r8, r2]
	ldr	r3, .L528+32
	ldrb	r0, [r3, fp]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r3, [sp]
	mov	r7, r0
	cbz	r3, .L487
	bl	IsBlkInVendorPart
	cbnz	r0, .L488
.L487:
	mov	r0, r7
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L489
	mla	r1, r10, r5, r8
	ldr	r3, [sp, #12]
	lsls	r7, r7, #10
	str	r3, [r1, #8]
	ldr	r3, [sp, #20]
	str	r7, [r1, #4]
	mul	r2, r3, r5
	ldr	r3, [sp, #16]
	adds	r5, r5, #1
	uxth	r5, r5
	bic	r2, r2, #3
	add	r2, r2, r3
	str	r2, [r1, #12]
.L488:
	add	fp, fp, #1
	b	.L486
.L489:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L488
.L495:
	mul	r3, r8, r7
	ldr	r2, [r6]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	adds	r3, r3, #1
	bne	.L494
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L494:
	adds	r7, r7, #1
	b	.L493
.L511:
	movs	r3, #6
	ldr	r8, [sp]
	str	r3, [sp, #12]
	mov	r10, #1
	b	.L496
.L500:
	movs	r3, #20
	mul	r2, r3, fp
	ldr	r3, [sp, #8]
	mov	r1, r3
	movs	r3, #0
	str	r3, [r1, r2]
	ldr	r3, .L528+32
	ldr	r1, [sp, #4]
	ldrb	r0, [r3, fp]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r3, [sp]
	mov	r7, r0
	cbz	r3, .L498
	bl	IsBlkInVendorPart
	cbnz	r0, .L499
.L498:
	mov	r0, r7
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L499
	ldr	r3, [sp, #8]
	movs	r2, #20
	add	r7, r6, r7, lsl #10
	mla	r1, r2, r5, r3
	ldr	r3, [sp, #20]
	str	r3, [r1, #8]
	ldr	r3, [sp, #28]
	str	r7, [r1, #4]
	mul	r2, r3, r5
	ldr	r3, [sp, #24]
	adds	r5, r5, #1
	uxth	r5, r5
	bic	r2, r2, #3
	add	r2, r2, r3
	str	r2, [r1, #12]
.L499:
	add	fp, fp, #1
	b	.L497
.L504:
	mul	r2, r3, r7
	ldr	r1, [fp]
	adds	r0, r1, r2
	ldr	r2, [r1, r2]
	cbz	r2, .L503
	ldr	r0, [r0, #4]
	adds	r4, r4, #1
	str	r3, [sp, #8]
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
	ldr	r3, [sp, #8]
.L503:
	adds	r7, r7, #1
	b	.L502
.L508:
	ldr	r3, [sp]
	cbz	r3, .L507
	mul	r3, r10, r6
	ldr	r2, [r7]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbnz	r3, .L507
	ldr	r0, [r1, #4]
	movs	r1, #1
	ubfx	r0, r0, #10, #16
	bl	FtlFreeSysBlkQueueIn
.L507:
	adds	r6, r6, #1
	b	.L506
.L529:
	.align	2
.L528:
	.word	.LANCHOR112
	.word	.LANCHOR111
	.word	.LANCHOR3
	.word	.LANCHOR113
	.word	.LANCHOR114
	.word	.LANCHOR24
	.word	.LANCHOR20
	.word	.LANCHOR115
	.word	.LANCHOR13
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
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
	push	{r3, r4, r5, r6, r7, lr}
	ldr	r4, .L537
	ldr	r6, .L537+4
.L531:
	ldrh	r1, [r4, #6]
	cbz	r1, .L532
	ldrh	r3, [r4, #2]
	subs	r1, r1, #1
	strh	r1, [r4, #6]	@ movhi
	adds	r2, r3, #4
	adds	r3, r3, #1
	ldrh	r5, [r4, r2, lsl #1]
	ubfx	r3, r3, #0, #10
	strh	r3, [r4, #2]	@ movhi
	mov	r0, r5
	bl	P2V_block_in_plane
	mov	r7, r0
	ldr	r0, [r6]
	lsls	r3, r5, #10
	movs	r2, #1
	mov	r1, r2
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L537+8
	ldr	r2, [r3]
	ldrh	r3, [r2, r7, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	ldr	r2, .L537+12
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	subs	r3, r5, #1
	uxth	r3, r3
	movw	r2, #65533
	cmp	r3, r2
	bhi	.L533
	mov	r0, r5
	pop	{r3, r4, r5, r6, r7, pc}
.L532:
	ldr	r0, .L537+16
	bl	printf
.L535:
	b	.L535
.L533:
	ldrh	r2, [r4, #6]
	mov	r1, r5
	ldr	r0, .L537+20
	bl	printf
	b	.L531
.L538:
	.align	2
.L537:
	.word	.LANCHOR38
	.word	.LANCHOR111
	.word	.LANCHOR43
	.word	.LANCHOR75
	.word	.LC82
	.word	.LC83
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
.L540:
	uxth	r5, r3
	cmp	r5, r1
	bcs	.L543
	mov	r7, r2
	adds	r3, r3, #1
	ldrh	r6, [r7]
	adds	r2, r2, #2
	cmp	r6, #0
	bne	.L540
	bl	FtlFreeSysBlkQueueOut
	subs	r3, r0, #1
	movw	r2, #65533
	uxth	r3, r3
	mov	r1, r0
	strh	r0, [r7]	@ movhi
	cmp	r3, r2
	bls	.L541
	ldr	r3, .L547
	ldr	r0, .L547+4
	ldrh	r2, [r3, #6]
	bl	printf
.L542:
	b	.L542
.L541:
	ldr	r3, [r4, #28]
	strh	r6, [r4, #2]	@ movhi
	strh	r5, [r4]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #28]
	ldrh	r3, [r4, #8]
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
.L543:
	ldrh	r3, [r4, #10]
	cmp	r3, r5
	bhi	.L545
	movw	r2, #581
	ldr	r1, .L547+8
	ldr	r0, .L547+12
	bl	printf
.L545:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L548:
	.align	2
.L547:
	.word	.LANCHOR38
	.word	.LC84
	.word	.LANCHOR116
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
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r1, #0
	ldr	r3, .L651
	mov	r8, #12
	ldr	r2, .L651+4
	str	r1, [r3]
	ldr	r3, .L651+8
	ldr	r4, .L651+12
	str	r1, [sp, #4]
	str	r1, [r3]
	ldr	r3, .L651+16
	ldrh	r0, [r4]
	ldr	fp, .L651+288
	str	r1, [r3]
	ldr	r3, .L651+20
	lsls	r0, r0, #1
	ldr	r10, .L651+292
	ldr	r5, .L651+24
	str	r1, [r3]
	ldr	r3, .L651+28
	ldr	r7, .L651+32
	str	r1, [r3]
	ldr	r3, .L651+36
	str	r1, [r3]
	ldr	r3, .L651+40
	str	r1, [r3]
	ldr	r3, .L651+44
	str	r1, [r3]
	ldr	r3, .L651+48
	str	r1, [r3]
	ldr	r3, .L651+52
	str	r1, [r3]
	ldr	r3, .L651+56
	str	r1, [r3]
	ldr	r3, .L651+60
	str	r1, [r3]
	ldr	r3, .L651+64
	str	r1, [r3]
	ldr	r3, .L651+68
	str	r1, [r3]
	ldr	r3, .L651+72
	str	r1, [r3]
	movw	r3, #65535
	str	r3, [r2]
	ldr	r2, .L651+76
	str	r1, [r2]
	ldr	r2, .L651+80
	str	r1, [r2]
	ldr	r2, .L651+84
	str	r1, [r2]
	ldr	r2, .L651+88
	strh	r3, [r2]	@ movhi
	ldr	r2, .L651+92
	strh	r3, [r2]	@ movhi
	movs	r2, #32
	ldr	r3, .L651+96
	strh	r2, [r3]	@ movhi
	movs	r2, #128
	ldr	r3, .L651+100
	strh	r2, [r3]	@ movhi
	ldr	r3, .L651+104
	strh	r1, [r3]	@ movhi
	ldr	r3, .L651+108
	strh	r1, [r3]	@ movhi
	ldr	r3, .L651+112
	strh	r1, [r3]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L651+116
	str	r0, [r3]
	ldrh	r0, [r4]
	movs	r4, #20
	mul	r0, r8, r0
	bl	ftl_malloc
	ldrh	r2, [fp]
	ldr	r3, .L651+120
	muls	r4, r2, r4
	str	r0, [r3]
	lsls	r6, r4, #2
	mov	r0, r6
	bl	ftl_malloc
	ldr	r3, .L651+124
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L651+128
	str	r0, [r3]
	mov	r0, r6
	bl	ftl_malloc
	ldr	r3, .L651+132
	ldr	r6, .L651+136
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	str	r0, [r10]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L651+140
	ldrh	r2, [fp]
	str	r0, [r3]
	ldr	r3, .L651+144
	lsls	r2, r2, #1
	ldrh	r4, [r3]
	adds	r2, r2, #1
	str	r2, [r5]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L651+148
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r3, .L651+152
	str	r0, [r3]
	mov	r0, r4
	bl	ftl_malloc
	str	r0, [r7]
	ldr	r0, [r5]
	muls	r0, r4, r0
	bl	ftl_malloc
	str	r0, [r6]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r2, .L651+156
	str	r0, [r2]
	mov	r0, r4
	bl	ftl_malloc
	ldr	r2, .L651+160
	ldr	r4, .L651+164
	str	r0, [r2]
	ldr	r0, [r5]
	mul	r0, r8, r0
	bl	ftl_malloc
	ldr	r2, .L651+168
	ldrh	r3, [fp]
	str	r0, [r2]
	ldrh	r2, [r4]
	mul	fp, r3, r2
	mov	r0, fp
	bl	ftl_malloc
	ldr	r2, .L651+172
	str	r0, [r2]
	lsl	r0, fp, #2
	bl	ftl_malloc
	ldr	r3, .L651+176
	str	r0, [r3]
	ldrh	r3, [r4]
	ldr	r0, [r5]
	ldr	r4, .L651+180
	ldr	r5, .L651+184
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L651+188
	str	r0, [r3]
	ldrh	r0, [r4]
	lsls	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r5]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L651+192
	str	r0, [r3]
	ldrh	r3, [r5]
	ldr	r0, .L651+196
	addw	r3, r3, #547
	lsrs	r3, r3, #9
	and	r0, r0, r3, lsl #9
	strh	r3, [r5]	@ movhi
	bl	ftl_malloc
	ldrh	fp, [r4]
	ldr	r3, .L651+200
	str	r0, [r3]
	lsl	fp, fp, #1
	ldr	r3, .L651+204
	adds	r0, r0, #32
	str	r0, [r3]
	mov	r0, fp
	bl	ftl_malloc
	ldr	r3, .L651+208
	str	r0, [r3]
	mov	r0, fp
	bl	ftl_malloc
	ldr	fp, .L651+296
	ldr	r3, .L651+212
	str	r0, [r3]
	ldr	r3, [fp]
	lsls	r5, r3, #1
	mov	r0, r5
	bl	ftl_malloc
	ldr	r2, .L651+216
	str	r0, [r2]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L651+220
	ldr	r5, .L651+224
	str	r0, [r3]
	ldrh	r0, [r4]
	lsrs	r0, r0, #3
	adds	r0, r0, #4
	bl	ftl_malloc
	ldr	r3, .L651+228
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r2, .L651+232
	str	r0, [r2]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r2, .L651+236
	str	r0, [r2]
	ldrh	r0, [r5]
	ldr	r5, .L651+120
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L651+240
	str	r0, [r3]
	ldr	r3, .L651+244
	ldrh	r0, [r3]
	str	r3, [sp]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, [sp]
	ldr	r2, .L651+248
	ldr	r1, [sp, #4]
	str	r0, [r2]
	ldrh	r2, [r3]
	lsls	r2, r2, #2
	bl	ftl_memset
	ldr	r3, .L651+252
	ldrh	r0, [r3]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L651+256
	str	r0, [r3]
	ldr	r0, [fp]
	ldr	fp, .L651+300
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L651+260
	str	r0, [r3]
	ldrh	r0, [fp]
	mul	r0, r8, r0
	ldr	r8, .L651+304
	bl	ftl_malloc
	ldr	r2, .L651+144
	ldr	r3, .L651+264
	str	r0, [r3]
	ldrh	r0, [r2]
	ldrh	r3, [fp]
	ldr	fp, .L651+132
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L651+268
	str	r0, [r3]
	movs	r0, #6
	ldrh	r3, [r4]
	ldr	r4, .L651+272
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L651+276
	str	r0, [r3]
	ldr	r3, .L651+280
	ldrh	r0, [r3]
	ldrh	r3, [r8]
	adds	r0, r0, #31
	asrs	r0, r0, #5
	strh	r0, [r4]	@ movhi
	muls	r0, r3, r0
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r2, .L651+284
	str	r5, [sp, #4]
	ldr	r5, .L651+124
	mov	r1, r2
	ldrh	r3, [r8]
	str	r0, [r1, #28]!
	ldrh	r0, [r4]
	ldr	r8, .L651+140
	ldr	lr, .L651+148
	b	.L652
.L653:
	.align	2
.L651:
	.word	.LANCHOR70
	.word	.LANCHOR118
	.word	.LANCHOR71
	.word	.LANCHOR21
	.word	.LANCHOR67
	.word	.LANCHOR64
	.word	.LANCHOR94
	.word	.LANCHOR63
	.word	.LANCHOR124
	.word	.LANCHOR65
	.word	.LANCHOR66
	.word	.LANCHOR62
	.word	.LANCHOR72
	.word	.LANCHOR73
	.word	.LANCHOR75
	.word	.LANCHOR76
	.word	.LANCHOR77
	.word	.LANCHOR117
	.word	.LANCHOR87
	.word	.LANCHOR119
	.word	.LANCHOR84
	.word	.LANCHOR112
	.word	.LANCHOR99
	.word	.LANCHOR100
	.word	.LANCHOR82
	.word	.LANCHOR83
	.word	.LANCHOR85
	.word	.LANCHOR101
	.word	.LANCHOR103
	.word	.LANCHOR95
	.word	.LANCHOR98
	.word	.LANCHOR120
	.word	.LANCHOR121
	.word	.LANCHOR122
	.word	.LANCHOR91
	.word	.LANCHOR93
	.word	.LANCHOR23
	.word	.LANCHOR107
	.word	.LANCHOR123
	.word	.LANCHOR115
	.word	.LANCHOR113
	.word	.LANCHOR24
	.word	.LANCHOR90
	.word	.LANCHOR108
	.word	.LANCHOR114
	.word	.LANCHOR6
	.word	.LANCHOR125
	.word	.LANCHOR92
	.word	.LANCHOR126
	.word	33553920
	.word	.LANCHOR127
	.word	.LANCHOR43
	.word	.LANCHOR128
	.word	.LANCHOR42
	.word	.LANCHOR129
	.word	.LANCHOR130
	.word	.LANCHOR27
	.word	.LANCHOR1
	.word	.LANCHOR36
	.word	.LANCHOR131
	.word	.LANCHOR132
	.word	.LANCHOR28
	.word	.LANCHOR133
	.word	.LANCHOR32
	.word	.LANCHOR134
	.word	.LANCHOR135
	.word	.LANCHOR55
	.word	.LANCHOR136
	.word	.LANCHOR137
	.word	.LANCHOR40
	.word	.LANCHOR17
	.word	.LANCHOR37
	.word	.LANCHOR3
	.word	.LANCHOR111
	.word	.LANCHOR30
	.word	.LANCHOR33
	.word	.LANCHOR10
.L652:
	ldr	ip, .L654+100
	lsls	r0, r0, #2
	str	r5, [sp, #8]
	ldr	r5, .L654
	str	r3, [sp]
	mov	r4, r0
	movs	r3, #1
	str	r5, [sp, #12]
.L551:
	ldr	r5, [sp]
	cmp	r3, r5
	bcc	.L552
	add	r3, r2, r3, lsl #2
	ldr	r1, .L654+4
	movs	r0, #0
	adds	r3, r3, #24
.L553:
	cmp	r1, r3
	bne	.L554
	ldr	r3, .L654+8
	ldr	r3, [r3]
	cbnz	r3, .L555
.L557:
	ldr	r1, .L654+12
	ldr	r0, .L654+16
	bl	printf
	mov	r0, #-1
.L550:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L552:
	ldr	r5, [r2, #28]
	adds	r3, r3, #1
	add	r5, r5, r4
	add	r4, r4, r0
	str	r5, [r1, #4]!
	b	.L551
.L554:
	str	r0, [r3, #4]!
	b	.L553
.L555:
	ldr	r3, .L654+20
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+24
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+28
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+32
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+36
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+40
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, [r2, #28]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+44
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+48
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, [sp, #4]
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, [sp, #8]
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, [fp]
	cmp	r3, #0
	beq	.L557
	ldr	r3, [r10]
	cmp	r3, #0
	beq	.L557
	ldr	r3, [r8]
	cmp	r3, #0
	beq	.L557
	ldr	r3, [sp, #12]
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, [lr]
	cmp	r3, #0
	beq	.L557
	ldr	r3, [ip]
	cmp	r3, #0
	beq	.L557
	ldr	r3, [r7]
	cmp	r3, #0
	beq	.L557
	ldr	r3, [r6]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+52
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+56
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+60
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+64
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+68
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+72
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+76
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+80
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+84
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+88
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+92
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	ldr	r3, .L654+96
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L557
	movs	r0, #0
	b	.L550
.L655:
	.align	2
.L654:
	.word	.LANCHOR121
	.word	.LANCHOR37+56
	.word	.LANCHOR129
	.word	.LANCHOR138
	.word	.LC85
	.word	.LANCHOR130
	.word	.LANCHOR134
	.word	.LANCHOR135
	.word	.LANCHOR55
	.word	.LANCHOR136
	.word	.LANCHOR40
	.word	.LANCHOR42
	.word	.LANCHOR95
	.word	.LANCHOR115
	.word	.LANCHOR113
	.word	.LANCHOR90
	.word	.LANCHOR108
	.word	.LANCHOR114
	.word	.LANCHOR92
	.word	.LANCHOR43
	.word	.LANCHOR126
	.word	.LANCHOR36
	.word	.LANCHOR131
	.word	.LANCHOR132
	.word	.LANCHOR133
	.word	.LANCHOR123
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
	ldr	r3, .L662
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, r0
	ldr	r7, .L662+4
	mov	r6, r1
	subs	r4, r5, #2
	addw	r5, r5, #1022
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r8, .L662+12
	mov	r0, r6
	lsls	r2, r2, #2
	bl	ftl_memset
.L659:
	ldrh	r3, [r4, #2]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L656
	ldrh	r2, [r7]
	cmp	r2, r3
	bhi	.L658
	movs	r2, #74
	mov	r1, r8
	ldr	r0, .L662+8
	bl	printf
.L658:
	ldrh	r3, [r4, #2]!
	movs	r2, #1
	cmp	r5, r4
	lsr	r1, r3, #5
	and	r3, r3, #31
	lsl	r3, r2, r3
	ldr	r2, [r6, r1, lsl #2]
	orr	r2, r2, r3
	str	r2, [r6, r1, lsl #2]
	bne	.L659
.L656:
	pop	{r4, r5, r6, r7, r8, pc}
.L663:
	.align	2
.L662:
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
	ldr	r0, .L665
	movw	r3, #65535
	movs	r2, #16
	movs	r1, #255
	strh	r3, [r0]	@ movhi
	movs	r3, #0
	strh	r3, [r0, #6]	@ movhi
	adds	r0, r0, #12
	b	ftl_memset
.L666:
	.align	2
.L665:
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
	ldr	r3, .L668
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
.L669:
	.align	2
.L668:
	.word	.LANCHOR38
	.size	FtlFreeSysBlkQueueInit, .-FtlFreeSysBlkQueueInit
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
	ldr	r3, .L676
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	mov	r10, r1
	ldrh	r2, [r3]
	str	r3, [sp, #4]
	cmp	r2, r0
	bcs	.L671
	mov	r2, #492
	ldr	r1, .L676+4
	ldr	r0, .L676+8
	bl	printf
.L671:
	ldr	fp, .L676+40
	movs	r4, #12
	ldr	r7, .L676+12
	ldr	r3, [fp]
	ldr	r8, [r3, r5, lsl #2]
	cmp	r8, #0
	bne	.L672
	mul	r4, r4, r10
	ldr	r2, [r7]
	movs	r1, #255
	adds	r0, r2, r4
	ldr	r2, .L676+16
	ldr	r0, [r0, #8]
	ldrh	r2, [r2]
	bl	ftl_memset
	ldr	r2, [r7]
	adds	r1, r2, r4
	strh	r5, [r2, r4]	@ movhi
	str	r8, [r1, #4]
.L673:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L672:
	mul	r4, r4, r10
	ldr	r2, [r7]
	ldr	r6, .L676+20
	add	r2, r2, r4
	mov	r0, r6
	ldr	r2, [r2, #8]
	str	r8, [r6, #4]
	str	r2, [r6, #8]
	ldr	r2, .L676+24
	ldr	r2, [r2]
	str	r2, [r6, #12]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r10, [r6, #12]
	ldrh	r2, [r10, #8]
	cmp	r2, r5
	beq	.L674
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L676+28
	bl	printf
	movs	r3, #4
	ldr	r1, [r6, #12]
	mov	r2, r3
	ldr	r0, .L676+32
	bl	rknand_print_hex
	ldr	r3, [sp, #4]
	movs	r2, #4
	ldr	r1, [fp]
	ldr	r0, .L676+36
	ldrh	r3, [r3]
	bl	rknand_print_hex
.L674:
	ldrh	r3, [r10, #8]
	cmp	r3, r5
	beq	.L675
	movw	r2, #513
	ldr	r1, .L676+4
	ldr	r0, .L676+8
	bl	printf
.L675:
	ldr	r3, [r7]
	movs	r1, #0
	adds	r2, r3, r4
	str	r1, [r2, #4]
	strh	r5, [r3, r4]	@ movhi
	b	.L673
.L677:
	.align	2
.L676:
	.word	.LANCHOR32
	.word	.LANCHOR140
	.word	.LC1
	.word	.LANCHOR55
	.word	.LANCHOR23
	.word	.LANCHOR106
	.word	.LANCHOR108
	.word	.LC86
	.word	.LC87
	.word	.LC88
	.word	.LANCHOR134
	.size	load_l2p_region, .-load_l2p_region
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
.L679:
	ldrh	r1, [r4, #6]
	uxth	r2, r3
	cmp	r1, r2
	bhi	.L683
	ldrh	r3, [r5]
	movs	r6, #0
	ldr	r2, .L692
	mov	fp, r6
.L684:
	ldrh	r0, [r4, #10]
	uxth	r1, r6
	cmp	r0, r1
	bhi	.L688
	mov	r0, fp
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L683:
	uxth	r2, r3
	ldr	r1, [r6, r2, lsl #2]
	movs	r2, #0
	ubfx	r1, r1, #10, #16
.L680:
	ldrh	r7, [r4, #10]
	uxth	r0, r2
	cmp	r7, r0
	bhi	.L682
	adds	r3, r3, #1
	b	.L679
.L682:
	uxth	r0, r2
	adds	r2, r2, #1
	ldrh	r7, [r10, r0, lsl #1]
	cmp	r7, r1
	ittt	eq
	ldrheq	r7, [r5, r0, lsl #1]
	addeq	r7, r7, #1
	strheq	r7, [r5, r0, lsl #1]	@ movhi
	b	.L680
.L688:
	ldrh	r0, [r4]
	uxth	r7, r6
	cmp	r0, r1
	bne	.L685
	ldrh	r0, [r2]
	ldrh	ip, [r4, #2]
	cmp	ip, r0
	it	cc
	strhcc	r0, [r5, r7, lsl #1]	@ movhi
.L685:
	ldrh	r8, [r5, r7, lsl #1]
	cmp	r3, r8
	itt	hi
	movhi	fp, r1
	movhi	r3, r8
	cmp	r8, #0
	bne	.L687
	ldrh	r0, [r10, r7, lsl #1]
	cbz	r0, .L687
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
.L687:
	adds	r6, r6, #1
	b	.L684
.L693:
	.align	2
.L692:
	.word	.LANCHOR20
	.size	ftl_free_no_use_map_blk, .-ftl_free_no_use_map_blk
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
	bne	.L695
	ldrh	r3, [r0, #8]
	cbz	r3, .L696
	movw	r2, #641
	ldr	r1, .L704
	ldr	r0, .L704+4
	bl	printf
.L696:
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
.L697:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L695:
	ldrh	r5, [r5, r3, lsl #1]
	movs	r1, #255
	ldrh	r3, [r0, #2]
	ldr	r2, .L704+8
	ldr	r7, .L704+12
	ldr	r6, [r0, #24]
	orr	r3, r3, r5, lsl #10
	ldr	r0, [r7]
	str	r3, [r2, #4]
	ldr	r3, .L704+16
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
	ldr	r3, .L704+20
	ldrh	r2, [r3]
	lsls	r2, r2, #3
	bl	ftl_memset
	ldrh	ip, [r4, #6]
	movs	r3, #0
	ldr	r1, [r7]
	mov	r2, r3
.L698:
	uxth	r0, r3
	cmp	ip, r0
	bhi	.L700
	movs	r2, #1
	movs	r3, #0
	mov	r1, r2
	ldr	r0, .L704+8
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	mov	r0, r4
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	bl	ftl_map_blk_gc
	b	.L697
.L700:
	ldr	r0, [r6, r3, lsl #2]
	cmp	r5, r0, lsr #10
	bne	.L699
	adds	r2, r2, #1
	uxth	r2, r2
	str	r3, [r1, r2, lsl #3]
	add	r7, r1, r2, lsl #3
	ldr	r0, [r6, r3, lsl #2]
	str	r0, [r7, #4]
.L699:
	adds	r3, r3, #1
	b	.L698
.L705:
	.align	2
.L704:
	.word	.LANCHOR141
	.word	.LC1
	.word	.LANCHOR106
	.word	.LANCHOR107
	.word	.LANCHOR108
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
	ldr	r8, .L725+28
	mov	r7, r1
	movs	r6, #0
	str	r2, [sp, #4]
	mov	fp, r8
.L707:
	ldr	r2, .L725
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	ldrh	r3, [r8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L708
	ldrh	r2, [r4]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L709
.L708:
	mov	r0, r4
	bl	Ftl_write_map_blk_to_last_page
.L709:
	ldrh	r2, [r4]
	ldr	r3, [r4, #12]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L710
	movw	r2, #699
	ldr	r1, .L725+4
	ldr	r0, .L725+8
	bl	printf
.L710:
	ldrh	r2, [r4]
	ldrh	r3, [r4, #10]
	cmp	r2, r3
	bcc	.L711
	mov	r2, #700
	ldr	r1, .L725+4
	ldr	r0, .L725+8
	bl	printf
.L711:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r4, #12]
	ldr	r5, .L725+12
	ldrh	r10, [r3, r2, lsl #1]
	ldrh	r2, [r4, #2]
	ldr	r3, [sp, #4]
	orr	r2, r2, r10, lsl #10
	str	r3, [r5, #8]
	str	r2, [r5, #4]
	ldr	r2, .L725+16
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
	ldr	r3, [r5]
	adds	r2, r2, #1
	uxth	r2, r2
	adds	r3, r3, #1
	strh	r2, [r4, #2]	@ movhi
	bne	.L712
	ldr	r1, [r5, #4]
	adds	r6, r6, #1
	ldr	r0, .L725+20
	uxth	r6, r6
	bl	printf
	ldrh	r2, [r4, #2]
	cmp	r2, #2
	ittt	ls
	ldrhls	r2, [fp]
	addls	r2, r2, #-1
	strhls	r2, [r4, #2]	@ movhi
	cmp	r6, #3
	bls	.L714
	mov	r2, r6
	ldr	r1, [r5, #4]
	ldr	r0, .L725+24
	bl	printf
.L715:
	b	.L715
.L714:
	ldr	r3, [r4, #32]
	cmp	r3, #0
	beq	.L707
.L724:
	b	.L724
.L712:
	cmp	r2, #1
	beq	.L707
	ldr	r2, [r5, #4]
	movs	r0, #0
	ldr	r3, [r4, #24]
	str	r2, [r3, r7, lsl #2]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L726:
	.align	2
.L725:
	.word	.LANCHOR66
	.word	.LANCHOR142
	.word	.LC1
	.word	.LANCHOR106
	.word	.LANCHOR108
	.word	.LC89
	.word	.LC90
	.word	.LANCHOR20
	.size	FtlMapWritePage, .-FtlMapWritePage
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
	blt	.L728
	uxth	r0, r0
	ldrh	r7, [r5, r0, lsl #1]
	cbz	r7, .L728
	ldr	r3, [r4, #32]
	cbnz	r3, .L728
	movs	r2, #1
	str	r2, [r4, #32]
	strh	r3, [r5, r0, lsl #1]	@ movhi
	ldrh	r3, [r4, #8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	ldr	r3, .L739
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L729
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L729:
	ldr	r5, .L739+4
	movs	r6, #0
	ldr	fp, .L739+20
.L730:
	ldrh	r3, [r4, #6]
	uxth	r10, r6
	cmp	r3, r10
	bhi	.L734
	movs	r1, #1
	mov	r0, r7
	bl	FtlFreeSysBlkQueueIn
	movs	r3, #0
	str	r3, [r4, #32]
.L728:
	ldr	r3, .L739
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L735
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L735:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L734:
	ldr	r3, [sp]
	uxth	r8, r6
	ldr	r2, [r3, r8, lsl #2]
	cmp	r7, r2, lsr #10
	bne	.L731
	ldr	r3, [fp]
	str	r2, [r5, #4]
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L739+4
	str	r3, [r5, #8]
	ldr	r3, .L739+8
	ldr	r3, [r3]
	str	r3, [r5, #12]
	str	r3, [sp, #4]
	bl	FlashReadPages
	ldr	r3, [sp, #4]
	ldrh	r3, [r3, #8]
	cmp	r3, r10
	beq	.L732
	movw	r2, #613
	ldr	r1, .L739+12
	ldr	r0, .L739+16
	bl	printf
.L732:
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L733
	ldr	r2, [sp]
	movs	r3, #0
	str	r3, [r2, r8, lsl #2]
.L731:
	adds	r6, r6, #1
	b	.L730
.L733:
	ldr	r2, [r5, #8]
	mov	r1, r8
	mov	r0, r4
	bl	FtlMapWritePage
	b	.L731
.L740:
	.align	2
.L739:
	.word	.LANCHOR20
	.word	.LANCHOR106
	.word	.LANCHOR108
	.word	.LANCHOR143
	.word	.LC1
	.word	.LANCHOR123
	.size	ftl_map_blk_gc, .-ftl_map_blk_gc
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
	ldr	r5, .L742
	muls	r4, r0, r4
	ldr	r0, .L742+4
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
.L743:
	.align	2
.L742:
	.word	.LANCHOR55
	.word	.LANCHOR144
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
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L758
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r1
	mov	r10, r2
	ldrh	r4, [r3]
	adds	r3, r4, #7
	movs	r4, #1
	lsr	r8, r0, r3
	lsls	r4, r4, r3
	ldr	r3, .L758+4
	subs	r4, r4, #1
	uxth	r8, r8
	ands	r4, r4, r0
	ldr	r3, [r3]
	uxth	r4, r4
	cmp	r0, r3
	bcc	.L745
	mov	r2, #808
	ldr	r1, .L758+8
	ldr	r0, .L758+12
	bl	printf
.L745:
	ldr	r6, .L758+16
	mov	fp, #12
	ldr	r3, .L758+20
	ldr	r1, [r6]
	ldrh	r2, [r3]
	movs	r3, #0
.L746:
	uxth	r5, r3
	cmp	r5, r2
	bcc	.L751
	bl	select_l2p_ram_region
	mul	fp, fp, r0
	ldr	r3, [r6]
	mov	r5, r0
	ldrh	r1, [r3, fp]
	add	r2, r3, fp
	movw	r3, #65535
	cmp	r1, r3
	beq	.L752
	ldr	r3, [r2, #4]
	cmp	r3, #0
	bge	.L752
	bl	flush_l2p_region
.L752:
	mov	r1, r5
	mov	r0, r8
	bl	load_l2p_region
	b	.L747
.L751:
	adds	r3, r3, #1
	mla	r0, fp, r3, r1
	ldrh	r0, [r0, #-12]
	cmp	r0, r8
	bne	.L746
.L747:
	ldr	r2, [r6]
	movs	r3, #12
	mla	r3, r3, r5, r2
	cmp	r10, #0
	bne	.L748
	ldr	r3, [r3, #8]
	ldr	r3, [r3, r4, lsl #2]
	str	r3, [r7]
.L749:
	ldr	r2, [r6]
	movs	r3, #12
	mla	r5, r3, r5, r2
	ldr	r3, [r5, #4]
	adds	r2, r3, #1
	beq	.L755
	adds	r3, r3, #1
	str	r3, [r5, #4]
.L755:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L748:
	ldr	r1, [r7]
	ldr	r2, [r3, #8]
	str	r1, [r2, r4, lsl #2]
	ldr	r2, [r3, #4]
	orr	r2, r2, #-2147483648
	str	r2, [r3, #4]
	ldr	r3, .L758+24
	strh	r8, [r3]	@ movhi
	b	.L749
.L759:
	.align	2
.L758:
	.word	.LANCHOR22
	.word	.LANCHOR61
	.word	.LANCHOR145
	.word	.LC1
	.word	.LANCHOR55
	.word	.LANCHOR33
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
	ldr	r5, .L770
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r2, [r5]
	mov	r7, r0
	ldrh	r3, [r2, r0, lsl #1]
	cbnz	r3, .L761
	ldr	r2, .L770+4
	ldr	r4, [r2]
	cmp	r4, #0
	beq	.L762
	ldr	r2, .L770+8
	movw	lr, #65535
	ldr	ip, .L770+24
	ldr	r0, .L770+12
	ldr	r2, [r2]
	ldrh	r1, [r0]
	mov	r8, r0
	subs	r4, r4, r2
	asrs	r4, r4, #1
	mul	r4, ip, r4
	mov	ip, #6
	uxth	r4, r4
.L763:
	uxth	r0, r3
	cmp	r1, r0
	bls	.L762
	cmp	r4, r7
	bne	.L764
	mov	r1, r4
	ldr	r0, .L770+4
	bl	List_remove_node
	ldrh	r3, [r8]
	cbnz	r3, .L765
	mov	r2, #1688
	ldr	r1, .L770+16
	ldr	r0, .L770+20
	bl	printf
.L765:
	ldrh	r3, [r8]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r8]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r2, [r5]
	ldrh	r3, [r2, r7, lsl #1]
.L761:
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	b	.L762
.L764:
	mul	r4, ip, r4
	adds	r3, r3, #1
	ldrh	r4, [r2, r4]
	cmp	r4, lr
	bne	.L763
.L762:
	movs	r2, #1
	add	r1, sp, #4
	mov	r0, r6
	bl	log2phys
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L771:
	.align	2
.L770:
	.word	.LANCHOR42
	.word	.LANCHOR47
	.word	.LANCHOR40
	.word	.LANCHOR48
	.word	.LANCHOR146
	.word	.LC1
	.word	-1431655765
	.size	FtlReUsePrevPpa, .-FtlReUsePrevPpa
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
	ldr	r7, .L786
	sub	sp, sp, #32
	movs	r1, #0
	ldr	r8, .L786+24
	ldr	r0, .L786+4
	bl	printf
.L773:
	ldr	r3, [r7]
	cmp	r5, r3
	bcc	.L779
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L779:
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r5
	bl	log2phys
	ubfx	r3, r5, #0, #11
	cbnz	r3, .L774
	ldr	r2, [sp, #28]
	mov	r1, r5
	mov	r0, r8
	bl	printf
.L774:
	ldr	r3, [sp, #28]
	adds	r2, r3, #1
	beq	.L776
	ldr	r4, .L786+8
	movs	r2, #0
	movs	r1, #1
	str	r3, [r4, #4]
	mov	r0, r4
	ldr	r3, .L786+12
	str	r5, [r4, #16]
	str	r2, [r4]
	ldr	r3, [r3]
	str	r3, [r4, #8]
	ldr	r3, .L786+16
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FlashReadPages
	ldr	r3, [r4]
	cmp	r3, #256
	beq	.L777
	adds	r3, r3, #1
	beq	.L777
	ldr	r3, [r6, #8]
	cmp	r5, r3
	beq	.L776
.L777:
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #12]
	ldr	r0, .L786+20
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
.L776:
	adds	r5, r5, #1
	b	.L773
.L787:
	.align	2
.L786:
	.word	.LANCHOR61
	.word	.LC91
	.word	.LANCHOR106
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LC93
	.word	.LC92
	.size	ftl_scan_all_data, .-ftl_scan_all_data
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
	ldr	r3, .L801
	push	{r4, r5, r6, lr}
	sub	sp, sp, #88
	mov	r4, r3
	ldr	r0, [r3, #80]
	cmp	r0, #0
	beq	.L789
	ldr	r6, .L801+4
	ldr	r0, [r3, #84]
	ldr	r1, [r6]
	cmp	r0, r1
	bcs	.L790
	mov	r5, #2048
.L795:
	ldr	r0, [r4, #84]
	ldr	r3, [r6]
	cmp	r0, r3
	bcs	.L792
	movs	r2, #0
	mov	r1, sp
	bl	log2phys
	ldr	r2, [sp]
	ldr	r3, [r4, #84]
	adds	r1, r2, #1
	add	r3, r3, #1
	str	r3, [r4, #84]
	beq	.L793
	str	r3, [sp, #20]
	add	r0, sp, #88
	ldr	r3, .L801+8
	movs	r1, #1
	str	r2, [sp, #8]
	movs	r2, #0
	str	r2, [r0, #-84]!
	str	r3, [sp, #12]
	add	r3, sp, #24
	str	r3, [sp, #16]
	bl	FlashReadPages
	ldr	r3, [sp, #4]
	cmp	r3, #256
	bne	.L792
	ldr	r0, [sp]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
.L792:
	mov	r0, #-1
.L788:
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, pc}
.L793:
	subs	r5, r5, #1
	bne	.L795
	b	.L792
.L790:
	ldr	r2, .L801+12
	movs	r0, #0
	str	r0, [r3, #80]
	str	r0, [r3, #84]
	ldr	r2, [r2]
	str	r2, [r3, #76]
	b	.L788
.L789:
	ldr	r1, [r3, #76]
	ldr	r3, .L801+12
	ldr	r5, [r3]
	add	r3, r5, #1048576
	cmp	r1, r3
	bhi	.L798
	ldr	r3, .L801+16
	ldr	r2, [r3]
	mov	r3, #33554432
	lsrs	r2, r2, #10
	asrs	r3, r3, r2
	add	r3, r3, r1
	cmp	r5, r3
	bhi	.L798
	ldr	r3, .L801+20
	ldrb	r3, [r3, #28]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L788
.L798:
	movs	r3, #1
	movs	r0, #0
	str	r3, [r4, #80]
	str	r0, [r4, #84]
	str	r5, [r4, #76]
	b	.L788
.L802:
	.align	2
.L801:
	.word	.LANCHOR81
	.word	.LANCHOR61
	.word	ftl_temp_buf
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
	cbz	r3, .L803
	ldrh	r5, [r0, #6]
	movs	r3, #0
	ldr	r2, [r0, #24]
	str	r3, [r0, #36]
	subs	r5, r5, #1
	ldr	r3, .L807
	ldr	r1, .L807+4
	uxth	r5, r5
	ldr	r4, .L807+8
	ldr	r2, [r2, r5, lsl #2]
	ldr	r0, [r3]
	ldr	r1, [r1]
	str	r2, [r4, #4]
	str	r0, [r4, #8]
	str	r1, [r4, #12]
	cbz	r2, .L805
	movs	r2, #1
	mov	r0, r4
	mov	r1, r2
	bl	FlashReadPages
.L806:
	ldr	r2, [r4, #8]
	mov	r1, r5
	mov	r0, r6
	pop	{r4, r5, r6, lr}
	b	FtlMapWritePage
.L805:
	ldr	r3, .L807+12
	movs	r1, #255
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L806
.L803:
	pop	{r4, r5, r6, pc}
.L808:
	.align	2
.L807:
	.word	.LANCHOR123
	.word	.LANCHOR108
	.word	.LANCHOR106
	.word	.LANCHOR23
	.size	FtlMapBlkWriteDump_data, .-FtlMapBlkWriteDump_data
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
	ldr	r5, .L889
	sub	sp, sp, #32
	mov	r1, r4
	ldr	r3, .L889+4
	ldr	r2, [r5]
	ldr	r6, .L889+8
	strh	r4, [r3]	@ movhi
	ldr	r3, .L889+12
	lsls	r2, r2, #2
	strh	r4, [r6]	@ movhi
	ldr	r7, .L889+16
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [r5]
	mov	r1, r4
	ldr	r3, .L889+20
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L889+24
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L889+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	movs	r2, #12
	movs	r1, #255
	ldr	r0, .L889+32
	bl	ftl_memset
	ldr	r3, .L889+36
	str	r6, [sp, #12]
	str	r5, [sp, #16]
	ldrh	r3, [r3]
	str	r3, [sp, #4]
.L810:
	ldr	r3, .L889+40
	ldr	r2, [sp, #4]
	ldrh	r3, [r3]
	cmp	r3, r2
	bls	.L851
	ldr	r3, .L889+44
	movs	r5, #0
	ldr	r1, .L889+48
	mov	fp, r5
	movs	r7, #20
	ldrh	r8, [r3]
	ldr	r3, .L889+52
	ldr	r2, [r1]
	ldr	r1, .L889+56
	ldr	r6, [r3]
	ldr	r3, .L889+60
	str	r2, [sp, #8]
	ldrh	r10, [r1]
	ldr	r3, [r3]
	ldr	r2, .L889+64
	b	.L852
.L812:
	ldrb	r0, [r2, r5]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #28]
	str	r2, [sp, #24]
	bl	V2P_block
	str	r0, [sp, #20]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #28]
	cbnz	r0, .L811
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
.L811:
	adds	r5, r5, #1
.L852:
	uxth	r1, r5
	cmp	r8, r1
	bhi	.L812
	cmp	fp, #0
	bne	.L813
.L850:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #4]
	b	.L810
.L813:
	movs	r7, #0
	movs	r2, #1
	mov	r1, fp
	mov	r0, r6
	bl	FlashReadPages
.L814:
	uxth	r3, r7
	cmp	fp, r3
	bls	.L850
	ldr	r3, .L889+52
	mov	r8, #20
	mul	r8, r8, r7
	ldr	r3, [r3]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	ldr	r5, [r2, #4]
	ldr	r6, [r2, #12]
	adds	r3, r3, #1
	ubfx	r5, r5, #10, #16
	bne	.L817
	mov	r10, #16
.L819:
	ldr	r3, .L889+52
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
	ldr	r3, .L889+52
	ldr	r3, [r3]
	bne	.L816
	mov	r2, #-1
	str	r2, [r3, r8]
	ldr	r3, .L889+52
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	cmp	r3, r2
	bne	.L817
.L818:
	movs	r1, #0
	mov	r0, r5
	bl	FtlFreeSysBlkQueueIn
	b	.L822
.L816:
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L817
	add	r10, r10, #-1
	uxth	r10, r10
	cmp	r10, #0
	bne	.L819
	b	.L818
.L817:
	ldr	r3, .L889+68
	ldr	r2, [r3]
	ldr	r3, [r6, #4]
	adds	r1, r2, #1
	beq	.L820
	cmp	r2, r3
	bhi	.L821
.L820:
	adds	r2, r3, #1
	ittt	ne
	ldrne	r1, .L889+68
	addne	r2, r3, #1
	strne	r2, [r1]
.L821:
	ldrh	r2, [r6]
	movw	r1, #61604
	cmp	r2, r1
	beq	.L823
	bhi	.L824
	movw	r3, #61574
	cmp	r2, r3
	beq	.L825
.L822:
	adds	r7, r7, #1
	b	.L814
.L824:
	movw	r3, #61634
	cmp	r2, r3
	beq	.L826
	movw	r3, #65535
	cmp	r2, r3
	beq	.L818
	b	.L822
.L826:
	ldr	r3, .L889+8
	ldrh	r2, [r3]
	ldr	r3, .L889
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L828
	movw	r2, #1211
	ldr	r1, .L889+72
	ldr	r0, .L889+76
	bl	printf
.L828:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #12]
	ldr	r1, [r3]
	ldrh	r0, [r2]
	ldr	r2, .L889+12
	uxth	r10, r1
	ldr	ip, [r2]
	add	r3, r10, #-1
	sub	r10, r10, r0
	add	r10, r10, #-1
	sxth	r3, r3
	sxth	r10, r10
.L829:
	cmp	r3, r10
	bgt	.L835
	cmp	r3, #0
	bge	.L867
	b	.L822
.L835:
	ldr	r2, [ip, r3, lsl #2]
	add	r8, ip, r3, lsl #2
	ldr	r4, [r6, #4]
	cmp	r4, r2
	bls	.L830
	ldr	r2, [ip]
	cbnz	r2, .L831
	cmp	r1, r0
	ittt	ne
	ldrne	r2, .L889+8
	addne	r0, r0, #1
	strhne	r0, [r2]	@ movhi
.L831:
	ldr	r2, .L889+20
	uxth	r10, r3
	ldr	r0, [r2]
	movs	r2, #0
.L832:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L833
	ldr	r2, [r6, #4]
	cmp	r3, #0
	str	r2, [r8]
	strh	r5, [r0, r3, lsl #1]	@ movhi
	blt	.L822
	ldr	r2, .L889+8
	ldrh	r0, [r2]
	ldr	r2, .L889
	ldr	r2, [r2]
	subs	r2, r2, r0
	subs	r2, r2, #1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L822
.L867:
	ldr	r2, .L889+8
	adds	r0, r0, #1
	strh	r0, [r2]	@ movhi
	ldr	r2, [r6, #4]
	str	r2, [ip, r3, lsl #2]
	ldr	r2, .L889+20
.L887:
	ldr	r2, [r2]
	strh	r5, [r2, r3, lsl #1]	@ movhi
	b	.L822
.L833:
	add	lr, ip, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, r0, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [ip, r1, lsl #2]
	strh	lr, [r0, r1, lsl #1]	@ movhi
	b	.L832
.L830:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L829
.L890:
	.align	2
.L889:
	.word	.LANCHOR30
	.word	.LANCHOR35
	.word	.LANCHOR147
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
	.word	.LANCHOR120
	.word	.LANCHOR24
	.word	.LANCHOR91
	.word	.LANCHOR13
	.word	.LANCHOR70
	.word	.LANCHOR148
	.word	.LC1
.L825:
	ldr	r8, .L891+12
	ldr	r10, .L891+20
	ldrh	r2, [r8]
	ldrh	r3, [r10]
	cmp	r2, r3
	bls	.L838
	movw	r2, #1252
	ldr	r1, .L891
	ldr	r0, .L891+4
	bl	printf
.L838:
	ldr	r2, .L891+8
	ldrh	lr, [r10]
	ldrh	ip, [r8]
	ldr	r0, [r2]
	add	r10, lr, #-1
	sxth	r3, r10
	sub	r10, r10, ip
.L839:
	cmp	r3, r10
	ble	.L844
	ldr	r1, [r6, #4]
	add	r8, r0, r3, lsl #2
	ldr	r2, [r0, r3, lsl #2]
	cmp	r1, r2
	bls	.L840
	ldr	r2, [r0]
	cbnz	r2, .L841
	cmp	lr, ip
	ittt	ne
	ldrne	r2, .L891+12
	addne	ip, ip, #1
	strhne	ip, [r2]	@ movhi
.L841:
	ldr	r2, .L891+16
	uxth	r10, r3
	ldr	ip, [r2]
	movs	r2, #0
.L842:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L843
	ldr	r2, [r6, #4]
	str	r2, [r8]
	strh	r5, [ip, r3, lsl #1]	@ movhi
.L844:
	cmp	r3, #0
	blt	.L822
	ldr	r2, .L891+20
	ldr	ip, .L891+12
	ldrh	r2, [r2]
	ldrh	r1, [ip]
	subs	r2, r2, #1
	subs	r2, r2, r1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L822
	ldr	r2, [r6, #4]
	adds	r1, r1, #1
	strh	r1, [ip]	@ movhi
	str	r2, [r0, r3, lsl #2]
	ldr	r2, .L891+16
	b	.L887
.L843:
	add	lr, r0, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, ip, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [r0, r1, lsl #2]
	strh	lr, [ip, r1, lsl #1]	@ movhi
	b	.L842
.L840:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L839
.L823:
	ldr	r8, .L891+40
	movw	r2, #65535
	ldrh	r1, [r8]
	cmp	r1, r2
	bne	.L846
.L888:
	strh	r5, [r8]	@ movhi
	str	r3, [r8, #8]
	b	.L822
.L846:
	ldrh	r0, [r8, #4]
	cmp	r0, r2
	beq	.L847
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L847:
	ldr	r3, [r6, #4]
	ldr	r2, [r8, #8]
	cmp	r2, r3
	bcs	.L848
	ldrh	r2, [r8]
	strh	r2, [r8, #4]	@ movhi
	b	.L888
.L848:
	strh	r5, [r8, #4]	@ movhi
	b	.L822
.L851:
	ldr	r3, .L891+24
	ldr	r2, [r3]
	ldrh	r3, [r2]
	cbz	r3, .L853
.L856:
	ldr	r3, .L891+16
	ldr	r4, [r3]
	ldrh	r2, [r4]
	cmp	r2, #0
	beq	.L854
.L855:
	ldr	r3, .L891+28
	ldrh	r2, [r3]
	ldr	r3, .L891+32
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L886
	movw	r2, #1377
	ldr	r1, .L891
	ldr	r0, .L891+4
	bl	printf
.L886:
	movs	r0, #0
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L853:
	ldr	r1, .L891+28
	ldrh	r1, [r1]
	cmp	r1, #0
	beq	.L856
	ldr	r5, .L891+32
	ldr	r0, [r5]
.L857:
	sxth	r1, r3
	cmp	r1, r0
	bcs	.L856
	ldrh	r4, [r2, r1, lsl #1]
	adds	r3, r3, #1
	cmp	r4, #0
	beq	.L857
	ldr	r3, .L891+36
	movs	r6, #0
	ldr	r0, [r3]
	mov	r3, r1
.L858:
	ldr	r4, [r5]
	cmp	r3, r4
	bcs	.L856
	ldrh	r7, [r2, r3, lsl #1]
	subs	r4, r3, r1
	strh	r7, [r2, r4, lsl #1]	@ movhi
	ldr	r7, [r0, r3, lsl #2]
	str	r7, [r0, r4, lsl #2]
	strh	r6, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	sxth	r3, r3
	b	.L858
.L854:
	ldr	r3, .L891+12
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L855
	ldr	r5, .L891+20
	ldrh	r1, [r5]
.L863:
	sxth	r3, r2
	cmp	r3, r1
	mov	r6, r3
	bge	.L855
	ldrh	r0, [r4, r3, lsl #1]
	adds	r2, r2, #1
	cmp	r0, #0
	beq	.L863
	ldr	r2, .L891+8
	movs	r0, #0
	ldr	r2, [r2]
.L864:
	ldrh	r1, [r5]
	cmp	r3, r1
	bge	.L855
	ldrh	r7, [r4, r3, lsl #1]
	subs	r1, r3, r6
	strh	r7, [r4, r1, lsl #1]	@ movhi
	ldr	r7, [r2, r3, lsl #2]
	str	r7, [r2, r1, lsl #2]
	adds	r1, r3, #1
	strh	r0, [r4, r3, lsl #1]	@ movhi
	sxth	r3, r1
	b	.L864
.L892:
	.align	2
.L891:
	.word	.LANCHOR148
	.word	.LC1
	.word	.LANCHOR132
	.word	.LANCHOR35
	.word	.LANCHOR36
	.word	.LANCHOR27
	.word	.LANCHOR129
	.word	.LANCHOR147
	.word	.LANCHOR30
	.word	.LANCHOR135
	.word	.LANCHOR79
	.size	FtlScanSysBlk, .-FtlScanSysBlk
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
	ldr	r5, .L920
	str	r3, [sp, #4]
	bl	ftl_memset
	ldr	r3, .L920+4
	str	r6, [r4, #32]
	str	r6, [r4, #28]
	ldr	r2, [r3]
	str	r3, [sp, #8]
	str	r2, [r5, #8]
	ldr	r2, .L920+8
	ldr	r7, [r2]
	movw	r2, #65535
	str	r7, [r5, #12]
	strh	r2, [r4]	@ movhi
	strh	r2, [r4, #2]	@ movhi
	movs	r2, #1
	str	r2, [r4, #36]
.L894:
	ldr	r2, [sp, #4]
	sxth	r3, r6
	cmp	r3, r2
	bge	.L911
	ldr	r2, [sp, #4]
	subs	r2, r2, #1
	cmp	r3, r2
	lsl	r2, r3, #1
	bne	.L895
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
	ldr	r3, .L920
.L896:
	sxth	r2, r6
	cmp	r2, r10
	ble	.L898
.L911:
	mov	r0, r4
	bl	ftl_free_no_use_map_blk
	ldr	r3, .L920+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L900
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L900:
	mov	r0, r4
	bl	ftl_map_blk_gc
	mov	r0, r4
	bl	ftl_map_blk_gc
	movs	r0, #0
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L898:
	ldrh	r1, [r5]
	ldr	r0, .L920
	str	r3, [sp, #4]
	orr	r2, r2, r1, lsl #10
	str	r2, [r3, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r3, [sp, #4]
	ldr	r2, [r3]
	adds	r2, r2, #1
	beq	.L897
	ldrh	r2, [r7, #8]
	cmp	fp, r2
	bls	.L897
	ldrh	r1, [r4, #4]
	ldrh	r0, [r7]
	cmp	r0, r1
	itt	eq
	ldreq	r1, [r3, #4]
	streq	r1, [r8, r2, lsl #2]
.L897:
	adds	r6, r6, #1
	b	.L896
.L895:
	ldr	r1, [sp, #8]
	add	r2, r10, r2
	str	r2, [sp, #16]
	ldr	r0, .L920
	ldr	r1, [r1]
	str	r1, [r5, #8]
	ldrh	r1, [r10, r3, lsl #1]
	ldr	r3, .L920+12
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
	beq	.L913
	ldrh	r1, [r7]
	ldrh	r2, [r4, #4]
	ldr	r3, [sp, #20]
	cmp	r1, r2
	bne	.L913
	ldrh	r1, [r7, #8]
	movw	r2, #64245
	cmp	r1, r2
	beq	.L902
.L913:
	movs	r3, #0
.L903:
	ldr	r1, .L920+12
	sxth	r2, r3
	ldrh	r1, [r1]
	cmp	r2, r1
	bge	.L909
	str	r3, [sp, #20]
	ldr	r3, [sp, #16]
	ldr	r0, .L920
	ldrh	r1, [r3]
	orr	r2, r2, r1, lsl #10
	str	r2, [r5, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [r5]
	ldr	r3, [sp, #20]
	adds	r2, r2, #1
	beq	.L907
	ldrh	r2, [r7, #8]
	cmp	fp, r2
	bls	.L907
	ldrh	r1, [r4, #4]
	ldrh	r0, [r7]
	cmp	r0, r1
	itt	eq
	ldreq	r1, [r5, #4]
	streq	r1, [r8, r2, lsl #2]
.L907:
	adds	r3, r3, #1
	b	.L903
.L902:
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r3, [sp, #8]
	subs	r2, r2, #1
	ldr	ip, [r3]
.L904:
	sxth	r3, r1
	cmp	r3, r2
	blt	.L906
.L909:
	adds	r6, r6, #1
	b	.L894
.L906:
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
	b	.L904
.L921:
	.align	2
.L920:
	.word	.LANCHOR106
	.word	.LANCHOR107
	.word	.LANCHOR108
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
	ldr	r3, .L923
	ldr	r0, .L923+4
	ldrh	r3, [r3]
	strh	r3, [r0, #10]	@ movhi
	movw	r3, #61574
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L923+8
	ldrh	r3, [r3]
	strh	r3, [r0, #8]	@ movhi
	ldr	r3, .L923+12
	ldrh	r3, [r3]
	strh	r3, [r0, #6]	@ movhi
	ldr	r3, .L923+16
	ldr	r3, [r3]
	str	r3, [r0, #12]
	ldr	r3, .L923+20
	ldr	r3, [r3]
	str	r3, [r0, #16]
	ldr	r3, .L923+24
	ldr	r3, [r3]
	str	r3, [r0, #20]
	ldr	r3, .L923+28
	ldr	r3, [r3]
	str	r3, [r0, #24]
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L924:
	.align	2
.L923:
	.word	.LANCHOR27
	.word	.LANCHOR149
	.word	.LANCHOR35
	.word	.LANCHOR28
	.word	.LANCHOR36
	.word	.LANCHOR132
	.word	.LANCHOR131
	.word	.LANCHOR133
	.size	FtlLoadVonderInfo, .-FtlLoadVonderInfo
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
	ldr	r5, .L928
	ldr	r4, .L928+4
	ldr	r2, [r5]
	ldr	r7, .L928+8
	ldr	r6, .L928+12
	ldr	r0, [r4]
	lsls	r2, r2, #1
	ldr	r8, .L928+44
	bl	ftl_memset
	ldrh	r3, [r7]
	movs	r1, #255
	ldrh	r2, [r6]
	ldr	r0, [r8]
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L928+16
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
.L926:
	adds	r2, r2, #12
	adds	r6, r3, r7
	cmp	r2, r1
	bne	.L927
	ldr	r3, .L928+20
	ldr	r2, [r5]
	strh	r0, [r3, #2]	@ movhi
	strh	r2, [r3, #10]	@ movhi
	movw	r2, #61634
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L928+24
	strh	r0, [r3]	@ movhi
	ldrh	r2, [r2]
	strh	r2, [r3, #8]	@ movhi
	ldr	r2, .L928+28
	ldrh	r2, [r2]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, .L928+32
	ldr	r2, [r2]
	str	r2, [r3, #12]
	ldr	r2, .L928+36
	ldr	r2, [r2]
	str	r2, [r3, #16]
	ldr	r2, [r4]
	str	r2, [r3, #20]
	ldr	r2, .L928+40
	ldr	r2, [r2]
	str	r2, [r3, #24]
	pop	{r4, r5, r6, r7, r8, pc}
.L927:
	bic	r3, r3, #3
	str	lr, [r2, #-8]
	add	r3, r3, ip
	strh	r0, [r2, #-12]	@ movhi
	str	r3, [r2, #-4]
	mov	r3, r6
	b	.L926
.L929:
	.align	2
.L928:
	.word	.LANCHOR30
	.word	.LANCHOR130
	.word	.LANCHOR23
	.word	.LANCHOR33
	.word	.LANCHOR55
	.word	.LANCHOR144
	.word	.LANCHOR147
	.word	.LANCHOR32
	.word	.LANCHOR129
	.word	.LANCHOR135
	.word	.LANCHOR134
	.word	.LANCHOR136
	.size	FtlL2PDataInit, .-FtlL2PDataInit
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
	ldr	r0, .L931
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L932:
	.align	2
.L931:
	.word	.LANCHOR144
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
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
	ldr	r3, .L934
	movs	r4, #0
	mov	r1, r4
	ldr	r5, .L934+4
	strh	r2, [r3]	@ movhi
	mov	r2, #-1
	ldr	r3, .L934+8
	str	r4, [r3]
	ldr	r3, .L934+12
	str	r4, [r3]
	ldr	r3, .L934+16
	str	r2, [r3]
	ldr	r3, .L934+20
	strh	r4, [r3]	@ movhi
	ldr	r3, .L934+24
	ldrh	r2, [r3]
	ldr	r3, .L934+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L934+32
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L934+36
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	mov	r1, r4
	movs	r2, #48
	ldr	r0, .L934+40
	bl	ftl_memset
	mov	r2, #512
	mov	r1, r4
	ldr	r0, .L934+44
	bl	ftl_memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L935:
	.align	2
.L934:
	.word	.LANCHOR150
	.word	.LANCHOR6
	.word	.LANCHOR151
	.word	.LANCHOR152
	.word	.LANCHOR153
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
	ldr	r3, .L947
	movs	r1, #0
	movs	r4, #0
	ldr	r5, .L947+4
	mov	r8, r4
	ldrh	r3, [r3]
	mov	r6, r4
	ldr	r0, [r5]
	mov	r10, r5
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L947+8
	ldr	r2, .L947+12
	str	r4, [r3]
	ldr	r3, .L947+16
	strh	r4, [r2]	@ movhi
	str	r2, [sp, #4]
	str	r4, [r3]
	ldr	r3, .L947+20
	str	r4, [r3]
	ldr	r3, .L947+24
	mov	fp, r3
	strh	r4, [r3]	@ movhi
.L937:
	ldr	r3, .L947+28
	uxth	r7, r4
	ldrh	r3, [r3]
	cmp	r7, r3
	bcs	.L943
	ldr	r3, .L947+32
	ldrh	r2, [r3]
	ldr	r3, .L947+36
	ldrh	r3, [r3]
	str	r3, [sp]
	movs	r3, #0
	mov	r5, r3
	b	.L944
.L939:
	str	r2, [sp, #12]
	mov	r1, r7
	ldr	r2, .L947+40
	str	r3, [sp, #8]
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #12]
	cbnz	r0, .L938
	ldr	r1, [sp]
	add	r5, r5, r1
	uxth	r5, r5
.L938:
	adds	r3, r3, #1
.L944:
	uxth	r1, r3
	cmp	r2, r1
	bhi	.L939
	cbz	r5, .L946
	mov	r1, r5
	mov	r0, #32768
	bl	__aeabi_idiv
.L940:
	ldr	r1, [r10]
	uxth	r2, r4
	movs	r3, #6
	mla	r3, r3, r2, r1
	strh	r0, [r3, #4]	@ movhi
	ldr	r3, .L947+44
	ldrh	r3, [r3]
	cmp	r3, r7
	beq	.L941
	ldr	r3, .L947+48
	ldrh	r3, [r3]
	cmp	r3, r7
	beq	.L941
	ldr	r3, .L947+52
	ldrh	r3, [r3]
	cmp	r3, r7
	beq	.L941
	ldr	r3, .L947+56
	ldr	r3, [r3]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L942
	add	r8, r8, #1
	mov	r0, r7
	uxth	r8, r8
	bl	INSERT_FREE_LIST
.L941:
	adds	r4, r4, #1
	b	.L937
.L946:
	mov	r0, r5
	b	.L940
.L942:
	adds	r6, r6, #1
	mov	r0, r7
	uxth	r6, r6
	bl	INSERT_DATA_LIST
	b	.L941
.L943:
	ldr	r2, [sp, #4]
	strh	r8, [fp]	@ movhi
	strh	r6, [r2]	@ movhi
	add	r6, r6, r8
	cmp	r6, r3
	ble	.L945
	movw	r2, #2154
	ldr	r1, .L947+60
	ldr	r0, .L947+64
	bl	printf
.L945:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L948:
	.align	2
.L947:
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
	.word	.LANCHOR154
	.word	.LC1
	.size	SupperBlkListInit, .-SupperBlkListInit
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
	ldr	r6, .L973
	ldr	r5, .L973+4
	ldr	r1, .L973+8
	ldr	r0, .L973+12
	bl	printf
	mov	r2, #8192
	movs	r1, #0
	ldr	r0, .L973+4
	bl	ftl_memset
.L950:
	ldr	r3, [r6]
	cmp	r4, r3
	bcc	.L952
	ldr	r10, .L973+48
	movs	r4, #0
	ldr	r7, .L973+16
	mov	r6, r4
.L953:
	ldrh	r2, [r10]
	uxth	r3, r4
	cmp	r2, r3
	bhi	.L955
	ldr	r3, .L973+20
	ldr	r4, [r3]
	cbz	r4, .L956
	ldr	r3, .L973+24
	mov	r8, #0
	ldr	r5, .L973+28
	ldr	r10, .L973+16
	ldrh	r7, [r3]
	ldr	r3, [r5]
	ldr	fp, .L973+4
	subs	r4, r4, r3
	ldr	r3, .L973+32
	asrs	r4, r4, #1
	muls	r4, r3, r4
	uxth	r4, r4
.L957:
	uxth	r3, r8
	cmp	r7, r3
	bls	.L956
	ldr	r3, [r10]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L958
	movs	r6, #1
	ldrh	r3, [fp, r4, lsl #1]
	mov	r1, r4
	ldr	r0, .L973+36
	bl	printf
.L958:
	movs	r3, #6
	ldr	r2, [r5]
	muls	r4, r3, r4
	movw	r3, #65535
	add	r8, r8, #1
	ldrh	r4, [r2, r4]
	cmp	r4, r3
	bne	.L957
.L956:
	cbz	r6, .L949
	movw	r2, #2321
	ldr	r1, .L973+8
	ldr	r0, .L973+40
	bl	printf
.L949:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L952:
	movs	r2, #0
	add	r1, sp, #4
	mov	r0, r4
	bl	log2phys
	ldr	r0, [sp, #4]
	adds	r3, r0, #1
	beq	.L951
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r5, r0, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r5, r0, lsl #1]	@ movhi
.L951:
	adds	r4, r4, #1
	b	.L950
.L955:
	ldr	r3, [r7]
	uxth	r5, r4
	ldr	r8, .L973+4
	ldrh	r2, [r3, r5, lsl #1]
	ldrh	r3, [r8, r5, lsl #1]
	cmp	r2, r3
	beq	.L954
	mov	r1, r5
	ldr	r0, .L973+44
	bl	printf
	ldr	r3, [r7]
	movw	r2, #65535
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, r2
	beq	.L954
	ldrh	r2, [r8, r5, lsl #1]
	cmp	r2, r3
	it	hi
	movhi	r6, #1
.L954:
	adds	r4, r4, #1
	b	.L953
.L974:
	.align	2
.L973:
	.word	.LANCHOR61
	.word	check_vpc_table
	.word	.LANCHOR155
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
	ldr	r2, .L976
	movs	r3, #0
	push	{r4, lr}
	movs	r1, #255
	ldr	r4, .L976+4
	strh	r3, [r2]	@ movhi
	ldr	r2, .L976+8
	strh	r3, [r2]	@ movhi
	ldrh	r2, [r4]
	ldr	r3, .L976+12
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r2, #12
	movs	r1, #255
	muls	r2, r3, r2
	ldr	r3, .L976+16
	ldr	r0, [r3]
	bl	ftl_memset
	pop	{r4, lr}
	b	FtlGcBufInit
.L977:
	.align	2
.L976:
	.word	.LANCHOR96
	.word	.LANCHOR21
	.word	.LANCHOR97
	.word	.LANCHOR95
	.word	.LANCHOR98
	.size	FtlGcPageVarInit, .-FtlGcPageVarInit
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
	ldr	r3, .L1001
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #24
	mov	r5, r0
	str	r1, [sp, #8]
	ldrh	r4, [r3]
	movw	r3, #65535
	cmp	r4, r3
	beq	.L995
	cbnz	r4, .L979
.L980:
	bl	FtlGcPageVarInit
	b	.L981
.L995:
	movs	r4, #0
.L979:
	ldr	r3, .L1001+4
	ldr	r2, [sp, #8]
	ldrh	r3, [r3]
	cmp	r3, r2
	beq	.L980
.L981:
	movs	r7, #0
.L989:
	ldrh	r2, [r5]
	movw	r3, #65535
	movs	r0, #0
	strb	r0, [r5, #8]
	cmp	r2, r3
	beq	.L982
.L992:
	ldr	r3, .L1001+8
	movs	r2, #0
	add	ip, r5, #16
	mov	r6, r2
	movw	lr, #65535
	mov	r8, #20
	ldrh	fp, [r3]
	ldr	r3, .L1001+12
	ldr	r3, [r3]
	str	r3, [sp, #4]
	ldr	r3, .L1001+16
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1001+20
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L1001+24
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L1001+28
	ldrh	r10, [r3]
.L983:
	uxth	r3, r2
	cmp	fp, r3
	bhi	.L985
	mov	r8, #0
	mov	fp, #20
	movs	r2, #0
	mov	r1, r6
	ldr	r0, [sp, #4]
	bl	FlashReadPages
.L986:
	uxth	r3, r8
	cmp	r6, r3
	bhi	.L990
	ldr	r3, [sp, #8]
	adds	r7, r7, #1
	adds	r4, r4, #1
	ldr	r2, .L1001+4
	uxth	r4, r4
	cmp	r3, r7
	bls	.L991
.L993:
	ldrh	r3, [r2]
	cmp	r3, r4
	bhi	.L992
	movs	r0, #0
	b	.L982
.L985:
	ldrh	r3, [ip], #2
	cmp	r3, lr
	beq	.L984
	ldr	r1, [sp, #4]
	orr	r3, r4, r3, lsl #10
	ldr	r0, [sp, #12]
	mla	r1, r8, r6, r1
	str	r3, [r1, #4]
	ldr	r3, [sp, #16]
	muls	r3, r6, r3
	bic	r3, r3, #3
	add	r3, r3, r0
	ldr	r0, [sp, #20]
	str	r3, [r1, #8]
	mul	r3, r10, r6
	adds	r6, r6, #1
	uxth	r6, r6
	bic	r3, r3, #3
	add	r3, r3, r0
	str	r3, [r1, #12]
.L984:
	adds	r2, r2, #1
	b	.L983
.L990:
	ldr	r3, .L1001+12
	mul	r10, fp, r8
	ldr	r2, [r3]
	add	r3, r2, r10
	str	r2, [sp, #16]
	ldr	r1, [r3, #4]
	str	r3, [sp, #12]
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_plane
	ldr	r2, [sp, #16]
	ldr	r2, [r2, r10]
	cbnz	r2, .L987
	ldr	r3, [sp, #12]
	movw	r2, #65535
	add	r8, r8, #1
	ldr	r1, [sp, #4]
	ldr	r3, [r3, #12]
	ldrh	ip, [r3]
	cmp	ip, r2
	bne	.L988
	ldr	r3, .L1001+32
	movs	r2, #1
	str	r2, [r3]
.L982:
	ldr	r3, .L1001
	movw	r2, #65535
	strb	r0, [r5, #6]
	mov	r1, r4
	strh	r4, [r5, #2]	@ movhi
	strh	r2, [r3]	@ movhi
	mov	r2, r0
	mov	r0, r5
	bl	ftl_sb_update_avl_pages
	b	.L994
.L988:
	ldr	r2, [r3, #8]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L986
.L987:
	ldr	r3, .L1001+36
	movs	r4, #0
	ldrh	r2, [r5]
	ldr	r3, [r3]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5]
	bl	INSERT_FREE_LIST
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
	bl	FtlGcPageVarInit
	b	.L989
.L991:
	ldr	r1, .L1001
	movw	r0, #65535
	ldrh	r3, [r1]
	cmp	r3, r0
	beq	.L993
	add	r3, r3, r7
	strh	r3, [r1]	@ movhi
	ldrh	r3, [r2]
	cmp	r3, r4
	bls	.L993
.L994:
	mov	r0, #-1
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1002:
	.align	2
.L1001:
	.word	.LANCHOR156
	.word	.LANCHOR19
	.word	.LANCHOR3
	.word	.LANCHOR120
	.word	.LANCHOR91
	.word	.LANCHOR23
	.word	.LANCHOR92
	.word	.LANCHOR24
	.word	.LANCHOR152
	.word	.LANCHOR42
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
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
	bls	.L1005
	ldr	r5, .L1006
	add	r0, sp, #24
	movs	r2, #32
	movs	r1, #165
	str	r0, [sp, #16]
	lsls	r4, r4, #10
	str	r5, [sp, #12]
	bl	ftl_memset
	movs	r2, #8
	movs	r1, #90
	mov	r0, r5
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
.L1003:
	mov	r0, r4
	add	sp, sp, #92
	@ sp needed
	pop	{r4, r5, pc}
.L1005:
	movs	r4, #0
	b	.L1003
.L1007:
	.align	2
.L1006:
	.word	ftl_temp_buf
	.size	FlashTestBlk, .-FlashTestBlk
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
	ldr	r3, .L1015
	mov	r1, r5
	mov	r0, r4
	ldr	r3, [r3]
	blx	r3
	uxth	r0, r0
	cmp	r0, #50
	bls	.L1009
	mov	r2, #256
	movs	r1, #255
	mov	r0, r4
	bl	ftl_memset
	movs	r0, #0
.L1009:
	ldr	r3, .L1015+4
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	bne	.L1014
	add	r1, r4, r0, lsl #1
	mov	r3, r4
.L1011:
	cmp	r3, r1
	bne	.L1012
.L1014:
	pop	{r3, r4, r5, pc}
.L1012:
	ldrh	r2, [r3]
	lsrs	r2, r2, #1
	strh	r2, [r3], #2	@ movhi
	b	.L1011
.L1016:
	.align	2
.L1015:
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
	ldr	r7, .L1027
	movs	r1, #0
	ldr	r5, .L1027+4
	ldr	r3, [r7]
	mov	fp, r7
	ldr	r8, .L1027+48
	ldr	r6, .L1027+8
	str	r3, [r5, #12]
	ldr	r7, .L1027+12
	ldr	r3, .L1027+16
	ldr	r10, .L1027+52
	ldr	r0, [r8]
	ldrh	r2, [r3]
	str	r0, [r5, #8]
	bl	ftl_memset
.L1019:
	ldrh	r3, [r7]
	cmp	r4, r3
	blt	.L1020
	ldr	r6, [r5, #12]
	movs	r2, #16
	ldr	r4, .L1027+20
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
	ldr	r3, .L1027+24
	ldr	r3, [r3]
	strh	r3, [r6, #12]	@ movhi
.L1021:
	ldr	r3, [r8]
	ldrh	r1, [r4]
	ldrh	r2, [r4, #2]
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
	ldr	r0, .L1027+28
	bl	printf
	movs	r3, #1
	ldr	r0, .L1027+4
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r3, .L1027+32
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1022
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
	ldr	r2, .L1027+36
	strh	r3, [r4]	@ movhi
	lsls	r3, r3, #10
	ldr	r0, [r2]
	movs	r2, #1
	str	r3, [r5, #4]
	mov	r1, r2
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	movs	r3, #1
	ldr	r0, .L1027+4
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
.L1022:
	ldrh	r3, [r10, #2]
	adds	r3, r3, #1
	strh	r3, [r10, #2]	@ movhi
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L1023
	adds	r7, r7, #1
	ldr	r1, [r5, #4]
	uxth	r7, r7
	ldr	r0, .L1027+40
	bl	printf
	cmp	r7, #3
	bls	.L1021
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L1027+44
	bl	printf
.L1025:
	b	.L1025
.L1020:
	ldrh	r2, [r10]
	ldr	r3, [r5, #8]
	ldr	r1, [r6, #4]!
	mul	r0, r2, r4
	lsls	r2, r2, #2
	adds	r4, r4, #1
	add	r0, r3, r0, lsl #2
	bl	ftl_memcpy
	b	.L1019
.L1026:
	movs	r3, #1
	str	r3, [sp, #12]
	b	.L1021
.L1023:
	ldr	r3, [sp, #12]
	cmp	r3, #0
	beq	.L1026
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1028:
	.align	2
.L1027:
	.word	.LANCHOR108
	.word	.LANCHOR106
	.word	.LANCHOR37+24
	.word	.LANCHOR10
	.word	.LANCHOR23
	.word	.LANCHOR37
	.word	.LANCHOR2
	.word	.LC97
	.word	.LANCHOR20
	.word	.LANCHOR111
	.word	.LC98
	.word	.LC99
	.word	.LANCHOR107
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
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldr	r8, .L1067
.L1030:
	ldr	r3, .L1067
	ldr	r6, .L1067+4
	ldr	fp, .L1067+76
	ldrh	r3, [r3]
	ldrh	r2, [r6]
	add	r3, r3, r2
	ldrh	r2, [fp]
	cmp	r3, r2
	ble	.L1031
	movw	r2, #2588
	ldr	r1, .L1067+8
	ldr	r0, .L1067+12
	bl	printf
.L1031:
	ldr	r3, .L1067+16
	cmp	r4, r3
	bne	.L1056
	ldr	r2, .L1067+20
	ldrh	r3, [r8]
	ldr	r2, [r2]
	lsrs	r1, r3, #1
	muls	r2, r3, r2
	adds	r1, r1, #1
	add	r1, r1, r2, lsr #2
	uxth	r1, r1
	cbz	r1, .L1032
	subs	r1, r1, #1
	uxth	r1, r1
.L1032:
	ldr	r0, .L1067+24
	bl	List_pop_index_node
	ldrh	r3, [r8]
	mov	r5, r0
	uxth	r7, r0
	cbnz	r3, .L1033
	movw	r2, #2597
	ldr	r1, .L1067+8
	ldr	r0, .L1067+12
	bl	printf
.L1033:
	ldrh	r3, [r8]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r8]	@ movhi
	strh	r7, [r4]	@ movhi
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1034
	ldr	r3, .L1067+28
	uxth	r5, r5
	movw	r2, #65535
	mov	r0, r7
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	bl	INSERT_DATA_LIST
	ldrh	r2, [r6]
	ldrh	r3, [r8]
	add	r3, r3, r2
	ldrh	r2, [fp]
	cmp	r3, r2
	ble	.L1030
	mov	r2, #2608
	ldr	r1, .L1067+8
	ldr	r0, .L1067+12
	bl	printf
	b	.L1030
.L1056:
	movs	r1, #0
	b	.L1032
.L1034:
	ldrh	r2, [r6]
	ldrh	r3, [r8]
	add	r3, r3, r2
	ldrh	r2, [fp]
	cmp	r3, r2
	ble	.L1036
	movw	r2, #2611
	ldr	r1, .L1067+8
	ldr	r0, .L1067+12
	bl	printf
.L1036:
	ldr	r3, .L1067+32
	movs	r6, #0
	ldr	r2, .L1067+36
	add	ip, r4, #16
	mov	lr, r6
	movw	r10, #65535
	ldr	r0, [r3]
	ldrh	r1, [r2]
	movs	r2, #20
	str	r2, [sp, #4]
	mov	r3, r0
	mla	r1, r2, r1, r0
	str	r1, [sp]
.L1037:
	ldr	r2, [sp]
	cmp	r2, r3
	bne	.L1039
	cbnz	r6, .L1040
	movw	r2, #2622
	ldr	r1, .L1067+8
	ldr	r0, .L1067+12
	bl	printf
.L1040:
	ldr	r3, .L1067+40
	ldrh	r3, [r3]
	cmp	r3, r7
	bne	.L1041
	mov	r2, #2624
	ldr	r1, .L1067+8
	ldr	r0, .L1067+12
	bl	printf
.L1041:
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	uxth	r5, r5
	ldr	r2, .L1067+44
	ldr	r3, .L1067+48
	ldr	r10, .L1067+80
	cmp	r1, #0
	bne	.L1042
	ldr	r0, [r2]
	ldrh	lr, [r0, r5, lsl #1]
	cmp	lr, #0
	beq	.L1043
	ldr	r1, .L1067+52
	ldrh	ip, [r1]
	add	r1, lr, ip
.L1066:
	strh	r1, [r0, r5, lsl #1]	@ movhi
	mov	r0, r7
	ldr	r1, [r3]
	str	r2, [sp, #4]
	str	r3, [sp]
	adds	r1, r1, #1
	str	r1, [r3]
	movs	r1, #0
	bl	ftl_set_blk_mode
	ldr	r3, [sp]
	ldr	r2, [sp, #4]
.L1045:
	ldr	r2, [r2]
	lsls	r1, r5, #1
	str	r1, [sp]
	ldrh	r0, [r2, r5, lsl #1]
	ldr	r2, .L1067+56
	ldr	r1, [r2]
	cmp	r0, r1
	ldrh	r1, [fp]
	it	hi
	strhi	r0, [r2]
	ldr	r2, .L1067+52
	ldr	r0, [r3]
	ldr	r3, [r10]
	ldrh	r2, [r2]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L1067+60
	ldr	ip, .L1067+84
	str	r0, [r3]
	ldr	r3, .L1067+64
	ldr	r2, [r3]
	ldr	r3, [r2, #16]
	adds	r3, r3, #1
	str	r3, [r2, #16]
	movs	r2, #20
	ldr	r3, .L1067+32
	ldr	r0, [r3]
	adds	r3, r0, #4
	mla	r2, r2, r6, r0
	adds	r2, r2, #24
.L1047:
	adds	r3, r3, #20
	cmp	r2, r3
	bne	.L1048
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	mov	r2, r6
	mov	r10, #0
	bl	FlashEraseBlocks
	mov	r3, r10
	movs	r1, #20
.L1049:
	uxth	r2, r10
	cmp	r6, r2
	bhi	.L1051
	cbz	r3, .L1052
	mov	r0, r7
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L1052:
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	ldr	r1, .L1067+28
	cmp	r2, #0
	bne	.L1053
	ldr	r3, [r1]
	movw	r2, #65535
	mov	r0, r7
	strh	r2, [r3, r5, lsl #1]	@ movhi
	bl	INSERT_DATA_LIST
	b	.L1030
.L1039:
	ldrh	r1, [ip], #2
	str	lr, [r3, #8]
	str	lr, [r3, #12]
	cmp	r1, r10
	beq	.L1038
	ldr	r2, [sp, #4]
	lsls	r1, r1, #10
	mla	r2, r2, r6, r0
	adds	r6, r6, #1
	uxth	r6, r6
	str	r1, [r2, #4]
.L1038:
	adds	r3, r3, #20
	b	.L1037
.L1043:
	movs	r1, #2
	b	.L1066
.L1042:
	ldr	r0, [r2]
	str	r3, [sp, #4]
	str	r2, [sp]
	ldrh	r1, [r0, r5, lsl #1]
	adds	r1, r1, #1
	strh	r1, [r0, r5, lsl #1]	@ movhi
	mov	r0, r7
	ldr	r1, [r10]
	adds	r1, r1, #1
	str	r1, [r10]
	bl	ftl_set_blk_mode.part.6
	ldm	sp, {r2, r3}
	b	.L1045
.L1048:
	ldr	r1, [r3, #-20]
	and	r1, r1, ip
	str	r1, [r3, #-20]
	b	.L1047
.L1051:
	ldr	r0, .L1067+32
	mul	r2, r1, r10
	ldr	r0, [r0]
	add	ip, r0, r2
	ldr	r2, [r0, r2]
	adds	r0, r2, #1
	bne	.L1050
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
.L1050:
	add	r10, r10, #1
	b	.L1049
.L1053:
	ldr	r3, .L1067+68
	ldr	r0, .L1067+72
	ldrh	r3, [r3]
	strh	r7, [r4]	@ movhi
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
	cbz	r3, .L1054
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L1055
.L1054:
	movw	r2, #2677
	ldr	r1, .L1067+8
	ldr	r0, .L1067+12
	bl	printf
.L1055:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1068:
	.align	2
.L1067:
	.word	.LANCHOR48
	.word	.LANCHOR45
	.word	.LANCHOR157
	.word	.LC1
	.word	.LANCHOR53
	.word	.LANCHOR87
	.word	.LANCHOR47
	.word	.LANCHOR42
	.word	.LANCHOR111
	.word	.LANCHOR3
	.word	.LANCHOR80
	.word	.LANCHOR43
	.word	.LANCHOR72
	.word	.LANCHOR14
	.word	.LANCHOR76
	.word	.LANCHOR74
	.word	.LANCHOR127
	.word	.LANCHOR19
	.word	.LANCHOR70
	.word	.LANCHOR5
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
	ldr	r4, .L1081
	ldrh	r3, [r4]
	cbz	r3, .L1070
	ldr	r8, .L1081+16
	movs	r6, #0
.L1071:
	ldr	r3, .L1081+4
	ldrh	r2, [r3]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L1077
	bl	FtlGcReFreshBadBlk
.L1070:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1077:
	ldr	r2, .L1081+8
	uxth	r3, r6
	mov	r1, r10
	movs	r7, #0
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	ldr	r2, .L1081+12
	mov	fp, r0
.L1072:
	ldrh	r3, [r4]
	uxth	r5, r7
	cmp	r3, r5
	bhi	.L1076
	adds	r6, r6, #1
	b	.L1071
.L1076:
	uxth	r3, r7
	ldrh	r1, [r8, r3, lsl #1]
	cmp	r1, fp
	bne	.L1073
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
.L1074:
	cmp	r5, r1
	bcc	.L1075
	subs	r1, r1, #1
	strh	r1, [r4]	@ movhi
.L1073:
	adds	r7, r7, #1
	b	.L1072
.L1075:
	ldrh	r0, [r3, #2]!
	adds	r5, r5, #1
	uxth	r5, r5
	strh	r0, [r3, #-2]	@ movhi
	b	.L1074
.L1082:
	.align	2
.L1081:
	.word	.LANCHOR101
	.word	.LANCHOR3
	.word	.LANCHOR13
	.word	.LC100
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
	ldr	r3, .L1093
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	bne	.L1084
	ldr	r2, .L1093+4
	ldrh	r1, [r2]
	cmp	r1, r0
	bne	.L1085
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L1086:
	ldr	r5, .L1093+8
	mov	r1, r4
	ldr	r0, .L1093+12
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L1088
	movw	r2, #2747
	ldr	r1, .L1093+16
	ldr	r0, .L1093+20
	bl	printf
.L1088:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	free_data_superblock
	mov	r0, r4
	bl	FtlGcFreeBadSuperBlk
	ldr	r3, .L1093+24
	ldrh	r2, [r5]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldr	r2, .L1093+28
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L1092
	movw	r2, #2750
	ldr	r1, .L1093+16
	ldr	r0, .L1093+20
	bl	printf
.L1092:
	movs	r3, #1
	b	.L1083
.L1085:
	ldr	r2, .L1093+32
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1083
	ldr	r2, .L1093+36
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L1083
	ldr	r2, .L1093+40
	ldrh	r2, [r2]
	cmp	r2, r0
	bne	.L1086
.L1083:
	mov	r0, r3
	pop	{r3, r4, r5, pc}
.L1084:
	bl	List_update_data_list
	movs	r3, #0
	b	.L1083
.L1094:
	.align	2
.L1093:
	.word	.LANCHOR42
	.word	.LANCHOR80
	.word	.LANCHOR45
	.word	.LANCHOR41
	.word	.LANCHOR158
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
	beq	.L1096
	ldr	r5, .L1104
	ldr	r3, [r5]
	ldrh	r2, [r3, r0, lsl #1]
	cbnz	r2, .L1097
	mov	r1, r0
	ldr	r0, .L1104+4
	bl	printf
	ldr	r3, [r5]
	ldrh	r5, [r3, r4, lsl #1]
	cbz	r5, .L1098
.L1102:
	movs	r5, #0
.L1095:
	mov	r0, r5
	pop	{r4, r5, r6, pc}
.L1098:
	movw	r2, #2765
.L1103:
	ldr	r1, .L1104+8
	ldr	r0, .L1104+12
	bl	printf
	b	.L1095
.L1097:
	subs	r2, r2, #1
	strh	r2, [r3, r0, lsl #1]	@ movhi
.L1096:
	ldr	r6, .L1104+16
	movw	r3, #65535
	ldrh	r0, [r6]
	cmp	r0, r3
	bne	.L1100
	strh	r4, [r6]	@ movhi
	b	.L1102
.L1100:
	cmp	r4, r0
	beq	.L1102
	bl	update_vpc_list
	ldr	r3, .L1104+20
	adds	r5, r0, #0
	ldr	r2, .L1104+24
	it	ne
	movne	r5, #1
	strh	r4, [r6]	@ movhi
	ldr	r3, [r3]
	ldr	r2, [r2]
	subs	r3, r3, r2
	asrs	r2, r3, #1
	ldr	r3, .L1104+28
	muls	r3, r2, r3
	ldr	r2, .L1104
	ldr	r2, [r2]
	uxth	r1, r3
	ldrh	r2, [r2, r1, lsl #1]
	cmp	r2, #0
	bne	.L1095
	cmp	r4, r1
	beq	.L1095
	movw	r2, #2781
	b	.L1103
.L1105:
	.align	2
.L1104:
	.word	.LANCHOR42
	.word	.LC101
	.word	.LANCHOR159
	.word	.LC1
	.word	.LANCHOR150
	.word	.LANCHOR41
	.word	.LANCHOR40
	.word	-1431655765
	.size	decrement_vpc_count, .-decrement_vpc_count
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
	ldr	r4, .L1125
	ldrh	r2, [r4, #4]
	cmp	r2, #0
	beq	.L1107
	ldrb	r3, [r4, #8]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1107
	ldr	r3, .L1125+4
	ldrb	r1, [r4, #7]	@ zero_extendqisi2
	ldrh	r3, [r3]
	muls	r3, r1, r3
	cmp	r2, r3
	beq	.L1107
	ldrb	r7, [r4, #10]	@ zero_extendqisi2
	cbnz	r7, .L1106
	ldr	r3, .L1125+8
	mov	r2, r7
	mov	r1, sp
	ldr	r6, [r3]
	ldr	r3, .L1125+12
	subs	r6, r6, #1
	mov	r0, r6
	ldrh	r8, [r3]
	bl	log2phys
	ldr	r2, .L1125+16
	ldr	r3, [sp]
	str	r6, [sp, #20]
	ldr	r0, [r2]
	ldr	r2, .L1125+20
	str	r3, [sp, #8]
	adds	r3, r3, #1
	str	r0, [sp, #12]
	ldr	r5, [r2]
	str	r5, [sp, #16]
	str	r7, [r5, #4]
	beq	.L1109
	mov	r2, r7
	movs	r1, #1
	add	r0, sp, #4
	bl	FlashReadPages
.L1110:
	ldr	fp, .L1125
	lsl	r8, r8, #2
	ldr	r10, .L1125+28
	movs	r7, #0
	movw	r3, #61589
	strh	r3, [r5]	@ movhi
.L1111:
	cmp	r8, r7
	bne	.L1115
.L1112:
	movs	r3, #1
.L1124:
	strb	r3, [r4, #10]
.L1106:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1109:
	ldr	r3, .L1125+24
	movs	r1, #255
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L1110
.L1115:
	ldrh	r3, [r4, #4]
	cmp	r3, #0
	beq	.L1112
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
	b	.L1111
.L1107:
	movs	r3, #0
	b	.L1124
.L1126:
	.align	2
.L1125:
	.word	.LANCHOR51
	.word	.LANCHOR19
	.word	.LANCHOR61
	.word	.LANCHOR3
	.word	.LANCHOR107
	.word	.LANCHOR108
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
	ldr	r5, .L1131
	ldr	r6, .L1131+4
	bl	FtlWriteDump_data
.L1128:
	ldrh	r3, [r5]
	uxth	r0, r4
	cmp	r3, r0
	bhi	.L1130
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L1130:
	ldr	r2, [r6]
	uxth	r3, r4
	movs	r1, #12
	mla	r3, r1, r3, r2
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L1129
	bl	flush_l2p_region
.L1129:
	adds	r4, r4, #1
	b	.L1128
.L1132:
	.align	2
.L1131:
	.word	.LANCHOR33
	.word	.LANCHOR55
	.size	l2p_flush, .-l2p_flush
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
	beq	.L1262
	ldrh	r3, [r0, #2]
	str	r3, [sp, #4]
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #20]
	ldr	r3, .L1270
	ldrh	r3, [r3]
	cmp	r3, r1
	mov	r3, #0
	bne	.L1136
	strh	r3, [r0, #4]	@ movhi
.L1268:
	strb	r3, [r8, #6]
.L1262:
	movs	r0, #0
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1136:
	ldrh	r0, [r0, #16]
.L1137:
	cmp	r0, r2
	uxth	r5, r3
	add	r3, r3, #1
	beq	.L1138
	movs	r1, #1
	bl	FtlGetLastWrittenPage
	mov	r4, r0
	adds	r0, r0, #1
	beq	.L1139
	ldr	r3, .L1270+4
	movs	r2, #0
	mov	r5, r2
	movw	fp, #65535
	mov	r10, #20
	ldrh	ip, [r3]
	ldr	r3, .L1270+8
	ldr	r0, [r3]
	ldr	r3, .L1270+12
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1270+16
	ldrh	r7, [r3]
	ldr	r3, .L1270+20
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1270+24
	ldrh	lr, [r3]
	add	r3, r8, #16
	str	r3, [sp, #16]
	str	r3, [sp]
.L1140:
	uxth	r3, r2
	cmp	ip, r3
	bhi	.L1144
	movs	r2, #0
	mov	r1, r5
	bl	FlashReadPages
	ldr	r2, .L1270+28
	uxth	r1, r4
	movw	fp, #65535
	str	r1, [sp, #12]
	ldr	r3, [r2]
	subs	r3, r3, #1
	str	r3, [sp]
	ldr	r3, .L1270+8
	ldr	r10, [r3]
	movs	r3, #0
	mov	r7, r10
.L1145:
	uxth	r1, r3
	cmp	r5, r1
	bhi	.L1150
	bne	.L1148
	adds	r3, r4, #1
	uxth	r3, r3
	str	r3, [sp, #8]
.L1263:
	ldr	r0, [r10, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_plane
	ldr	r3, .L1270
	mov	r10, r0
	ldr	r2, [sp, #8]
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L1152
	ldrh	r3, [sp, #8]
	strh	r3, [r8, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r8, #6]
	strh	r3, [r8, #4]	@ movhi
.L1152:
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #4]
	cmp	r3, r2
	bne	.L1153
	ldr	r3, [sp, #20]
	cmp	r10, r3
	bne	.L1153
	ldr	r1, [sp, #8]
	mov	r2, r10
.L1269:
	mov	r0, r8
	bl	ftl_sb_update_avl_pages
	b	.L1262
.L1138:
	uxth	r1, r3
	adds	r1, r1, #8
	ldrh	r0, [r8, r1, lsl #1]
	b	.L1137
.L1139:
	ldr	r3, [sp, #4]
	cbz	r3, .L1141
	movw	r2, #1755
	ldr	r1, .L1270+32
	ldr	r0, .L1270+36
	bl	printf
.L1141:
	ldr	r3, [sp, #20]
	cbz	r3, .L1142
	cmp	r5, r3
	beq	.L1142
	movw	r2, #1756
	ldr	r1, .L1270+32
	ldr	r0, .L1270+36
	bl	printf
.L1142:
	movs	r3, #0
	strh	r3, [r8, #2]	@ movhi
	b	.L1268
.L1144:
	ldr	r1, [sp]
	ldrh	r3, [r1], #2
	cmp	r3, fp
	str	r1, [sp]
	beq	.L1143
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
.L1143:
	adds	r2, r2, #1
	b	.L1140
.L1150:
	ldr	r1, [r7]
	cbnz	r1, .L1146
	ldr	r1, [r7, #12]
	ldr	r6, [r1, #4]
	str	r1, [sp, #8]
	adds	r1, r6, #1
	beq	.L1147
	ldr	r1, [r2]
	mov	r0, r6
	bl	ftl_cmp_data_ver
	cbz	r0, .L1147
	adds	r6, r6, #1
	str	r6, [r2]
.L1147:
	ldr	r1, [sp, #8]
	ldr	r1, [r1]
	adds	r1, r1, #1
	bne	.L1149
.L1148:
	uxth	r2, r4
	uxth	r3, r3
	str	r2, [sp, #8]
	movs	r2, #20
	mla	r10, r2, r3, r10
	b	.L1263
.L1146:
	ldr	fp, [sp, #12]
.L1149:
	adds	r3, r3, #1
	adds	r7, r7, #20
	b	.L1145
.L1153:
	movw	r3, #65535
	cmp	fp, r3
	bne	.L1154
	ldrb	r3, [r8, #8]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L1155
.L1154:
	ldr	r3, .L1270+40
	uxth	r6, r4
	uxth	r4, r4
	ldr	r7, .L1270+8
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
.L1158:
	cmp	r4, r6
	bhi	.L1168
	ldr	r3, .L1270+4
	movw	lr, #65535
	ldr	r0, [r7]
	mov	ip, #20
	ldrh	fp, [r3]
	ldr	r3, [sp, #16]
	str	r3, [sp, #12]
	movs	r3, #0
	mov	r5, r3
	b	.L1169
.L1160:
	ldr	r1, [sp, #12]
	ldrh	r2, [r1], #2
	cmp	r2, lr
	str	r1, [sp, #12]
	beq	.L1159
	mla	r1, ip, r5, r0
	adds	r5, r5, #1
	orr	r2, r4, r2, lsl #10
	uxth	r5, r5
	str	r2, [r1, #4]
.L1159:
	adds	r3, r3, #1
.L1169:
	uxth	r2, r3
	cmp	fp, r2
	bhi	.L1160
	mov	r1, r5
	movs	r2, #0
	bl	FlashReadPages
	ldr	r3, .L1270+40
	movs	r1, #20
	movs	r0, #0
	movw	ip, #65535
	ldr	r2, [r3]
	ldr	r3, [r7]
	mla	r5, r1, r5, r3
.L1161:
	cmp	r3, r5
	bne	.L1166
	cbz	r0, .L1167
	ldr	r3, .L1270+40
	str	r2, [r3]
.L1167:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L1158
.L1271:
	.align	2
.L1270:
	.word	.LANCHOR19
	.word	.LANCHOR3
	.word	.LANCHOR120
	.word	.LANCHOR91
	.word	.LANCHOR23
	.word	.LANCHOR92
	.word	.LANCHOR24
	.word	.LANCHOR71
	.word	.LANCHOR160
	.word	.LC1
	.word	.LANCHOR153
.L1166:
	ldr	r1, [r3]
	cmp	r1, #0
	beq	.L1162
	cbz	r0, .L1155
.L1264:
	ldr	r3, .L1272
	str	r2, [r3]
.L1155:
	ldr	r3, .L1272+4
	movs	r2, #1
	ldr	r0, .L1272+8
	ldr	r6, .L1272+12
	strh	r2, [r3]	@ movhi
	bl	FtlMapBlkWriteDump_data
	ldr	fp, [sp, #4]
.L1170:
	ldr	r3, .L1272+16
	movw	lr, #65535
	ldr	r0, [r6]
	movs	r7, #20
	ldr	r1, [sp, #16]
	ldrh	r4, [r3]
	movs	r3, #0
	str	r3, [sp, #12]
.L1171:
	uxth	r2, r3
	cmp	r2, r4
	bcc	.L1173
	movs	r2, #0
	ldr	r1, [sp, #12]
	bl	FlashReadPages
	movs	r3, #0
.L1267:
	str	r3, [sp, #24]
	ldr	r2, [sp, #12]
	ldrh	r3, [sp, #24]
	cmp	r2, r3
	bhi	.L1202
	ldr	r3, .L1272+20
	add	fp, fp, #1
	uxth	fp, fp
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L1170
	ldr	r2, .L1272+16
	movw	r0, #65535
	movs	r3, #0
	strh	fp, [r8, #2]	@ movhi
	strh	r3, [r8, #4]	@ movhi
	ldrh	r2, [r2]
.L1203:
	uxth	r1, r3
	cmp	r1, r2
	bcs	.L1262
	ldr	r1, [sp, #16]
	ldrh	r4, [r1], #2
	cmp	r4, r0
	str	r1, [sp, #16]
	add	r1, r3, #1
	bne	.L1268
	mov	r3, r1
	b	.L1203
.L1162:
	ldr	r1, [r3, #12]
	ldrh	lr, [r1]
	cmp	lr, ip
	beq	.L1165
	ldr	r1, [r1, #4]
	cmp	r1, #-1
	itt	ne
	movne	r2, r1
	movne	r0, #1
.L1165:
	adds	r3, r3, #20
	b	.L1161
.L1168:
	mov	r2, #-1
	b	.L1264
.L1173:
	ldrh	r2, [r1], #2
	cmp	r2, lr
	beq	.L1172
	ldr	r5, [sp, #12]
	orr	r2, fp, r2, lsl #10
	mla	ip, r7, r5, r0
	str	r2, [ip, #4]
	mov	r2, r5
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #12]
.L1172:
	adds	r3, r3, #1
	b	.L1171
.L1202:
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
	bcc	.L1175
	ldr	r3, [sp, #28]
	bne	.L1176
	ldr	r2, [sp, #20]
	cmp	r2, r0
	bhi	.L1175
.L1176:
	ldr	r2, [sp, #8]
	cmp	fp, r2
	bne	.L1177
	cmp	r10, r0
	beq	.L1178
.L1177:
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L1179
	ldr	r3, [r7, #12]
	movw	r2, #61589
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L1180
.L1186:
	ldrh	r0, [r8]
.L1266:
	bl	decrement_vpc_count
.L1175:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	b	.L1267
.L1180:
	ldr	r2, [r3, #4]
	str	r2, [sp]
	adds	r2, r2, #1
	beq	.L1181
	ldr	r2, .L1272+24
	ldr	r0, [sp]
	ldr	r1, [r2]
	bl	ftl_cmp_data_ver
	cbz	r0, .L1181
	ldr	r1, [sp]
	adds	r1, r1, #1
	str	r1, [r2]
.L1181:
	ldr	r4, [r3, #8]
	add	r1, sp, #40
	ldr	r3, [r3, #12]
	movs	r2, #0
	mov	r0, r4
	str	r3, [sp, #36]
	bl	log2phys
	ldr	r3, .L1272
	ldr	r1, [r3]
	adds	r3, r1, #1
	beq	.L1182
	ldr	r0, [sp]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1182
	ldr	r3, [sp, #36]
	adds	r7, r3, #1
	beq	.L1183
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
	bne	.L1184
.L1185:
	mov	r3, #-1
	ldrh	r0, [r8]
	str	r3, [sp, #36]
	bl	decrement_vpc_count
.L1193:
	ldr	r7, [sp, #36]
	adds	r0, r7, #1
	beq	.L1175
.L1206:
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1272+28
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L1198
	movw	r2, #2006
	ldr	r1, .L1272+32
	ldr	r0, .L1272+36
	bl	printf
.L1198:
	ldr	r3, .L1272+40
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, #0
	beq	.L1199
	mov	r0, r4
	b	.L1266
.L1183:
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #40]
	cmp	r2, r3
	bne	.L1186
	movs	r2, #1
	add	r1, sp, #36
	mov	r0, r4
	bl	log2phys
	b	.L1186
.L1184:
	ldr	r1, [r7, #8]
	cmp	r4, r1
	bne	.L1185
	ldr	r0, .L1272
	ldr	r1, [r7, #4]
	ldr	r0, [r0]
	str	r1, [sp, #28]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1185
	ldr	r1, [sp, #40]
	ldr	r0, [sp, #44]
	cmp	r1, r0
	bne	.L1188
.L1191:
	ldr	r1, [sp, #36]
	mov	r0, r4
	bl	FtlReUsePrevPpa
	b	.L1185
.L1188:
	ldr	r0, [sp, #36]
	cmp	r1, r0
	beq	.L1185
	adds	r0, r1, #1
	beq	.L1189
	str	r1, [r3, #4]
	movs	r2, #0
	movs	r1, #1
	mov	r0, r3
	ldr	r7, [r3, #12]
	bl	FlashReadPages
.L1190:
	ldr	r3, [r6]
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L1191
	ldr	r3, [r7, #4]
	ldr	r2, .L1272
	mov	r1, r3
	ldr	r0, [r2]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1191
	mov	r1, r3
	ldr	r0, [sp, #28]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1185
	b	.L1191
.L1189:
	str	r1, [r2, r5]
	b	.L1190
.L1273:
	.align	2
.L1272:
	.word	.LANCHOR153
	.word	.LANCHOR161
	.word	.LANCHOR144
	.word	.LANCHOR120
	.word	.LANCHOR3
	.word	.LANCHOR19
	.word	.LANCHOR71
	.word	.LANCHOR5
	.word	.LANCHOR160
	.word	.LC1
	.word	.LANCHOR42
.L1182:
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #40]
	cmp	r2, r3
	beq	.L1193
	movs	r2, #1
	add	r1, sp, #44
	mov	r0, r4
	bl	log2phys
	ldr	r7, [sp, #40]
	adds	r5, r7, #1
	beq	.L1193
	ldr	r3, [sp, #36]
	cmp	r7, r3
	beq	.L1206
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1274
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L1197
	ldr	r3, .L1274+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L1197
	ldr	r3, .L1274+8
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L1193
.L1197:
	ldr	r0, [r6]
	movs	r2, #0
	movs	r1, #1
	str	r7, [r0, #4]
	ldr	r5, [r0, #12]
	bl	FlashReadPages
	ldr	r3, [r6]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L1193
	ldr	r1, [r5, #4]
	ldr	r0, [sp]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	bne	.L1193
	movs	r2, #1
	add	r1, sp, #40
	mov	r0, r4
	bl	log2phys
	b	.L1193
.L1199:
	mov	r1, r4
	ldr	r0, .L1274+12
	bl	printf
	b	.L1175
.L1179:
	ldr	r3, .L1274+16
	ldr	r3, [r3]
	cmp	r3, #31
	bhi	.L1200
	ldr	r2, .L1274+20
	str	r4, [r2, r3, lsl #2]
	adds	r3, r3, #1
	ldr	r2, .L1274+16
	str	r3, [r2]
.L1200:
	ldrh	r0, [r8]
	bl	decrement_vpc_count
	ldr	r3, .L1274+24
	ldr	r2, [r3]
	adds	r1, r2, #1
	bne	.L1201
	ldr	r2, [sp]
.L1265:
	str	r2, [r3]
	b	.L1175
.L1201:
	ldr	r1, [sp]
	cmp	r1, r2
	bcs	.L1175
	mov	r2, r1
	b	.L1265
.L1178:
	strb	r10, [r8, #6]
	mov	r2, r10
	strh	fp, [r8, #2]	@ movhi
	mov	r1, fp
	b	.L1269
.L1275:
	.align	2
.L1274:
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LC102
	.word	.LANCHOR162
	.word	.LANCHOR163
	.word	.LANCHOR153
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
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
	ldr	r2, .L1287
	movs	r6, #0
	mov	r4, r0
	str	r3, [sp, #20]
	movs	r7, #7
	ldr	r3, .L1287+4
	ldr	r5, [r2]
	mvn	r2, #2
	ldr	r8, .L1287+16
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
.L1277:
	subs	r7, r7, #1
	beq	.L1279
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1278
.L1279:
	ldr	r3, .L1287+8
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldr	r3, .L1287+12
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1278:
	mov	r0, r4
	bl	get_new_active_ppa
	str	r0, [sp, #8]
	adds	r0, r0, #1
	beq	.L1279
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
	b	.L1277
.L1288:
	.align	2
.L1287:
	.word	.LANCHOR108
	.word	.LANCHOR107
	.word	.LANCHOR42
	.word	.LANCHOR19
	.word	.LANCHOR71
	.size	FtlSuperblockPowerLostFix, .-FtlSuperblockPowerLostFix
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
	ldr	r8, .L1318+40
	ldr	r4, .L1318
	ldr	r3, [r8]
	ldr	r7, .L1318+4
	mov	r10, r4
	str	r3, [r4, #8]
	ldr	r3, .L1318+8
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FtlBbtMemInit
	ldrh	r5, [r7]
	subs	r5, r5, #1
	uxth	r5, r5
.L1290:
	ldrh	r3, [r7]
	subs	r3, r3, #15
	cmp	r3, r5
	bgt	.L1293
	lsls	r3, r5, #10
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L1291
	ldr	r3, [r4, #4]
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	adds	r3, r3, #1
	str	r3, [r4, #4]
	bl	FlashReadPages
.L1291:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L1292
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L1292
	ldr	r3, .L1318+12
	ldr	r2, [r6, #4]
	strh	r5, [r3]	@ movhi
	str	r2, [r3, #8]
	ldrh	r2, [r6, #8]
	strh	r2, [r3, #4]	@ movhi
.L1293:
	ldr	r5, .L1318+12
	movw	r2, #65535
	ldrh	r3, [r5]
	cmp	r3, r2
	beq	.L1307
	ldrh	r3, [r5, #4]
	cmp	r3, r2
	beq	.L1297
	lsls	r3, r3, #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L1318
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L1297
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L1297
	ldr	r3, [r6, #4]
	ldr	r2, [r5, #8]
	cmp	r3, r2
	bls	.L1297
	ldrh	r2, [r5, #4]
	str	r3, [r5, #8]
	ldrh	r3, [r6, #8]
	strh	r2, [r5]	@ movhi
	strh	r3, [r5, #4]	@ movhi
.L1297:
	ldr	r10, .L1318
	movs	r1, #1
	ldrh	r0, [r5]
	bl	FtlGetLastWrittenPage
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r5, #2]	@ movhi
.L1299:
	cmp	r7, #0
	bge	.L1302
	movs	r2, #254
	ldr	r1, .L1318+16
	ldr	r0, .L1318+20
	bl	printf
.L1301:
	ldrh	r3, [r6, #10]
	ldrh	r0, [r6, #12]
	strh	r3, [r5, #6]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L1304
	ldr	r3, .L1318+24
	ldr	r2, [r3]
	cmp	r0, r2
	beq	.L1304
	ldr	r3, .L1318+28
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	cmp	r2, r3
	bcs	.L1304
	cmp	r0, r3
	bcs	.L1304
	bl	FtlSysBlkNumInit
.L1304:
	ldr	r6, .L1318+32
	movs	r5, #0
	ldr	r7, .L1318+36
	ldr	r8, .L1318+44
.L1305:
	ldrh	r3, [r7]
	cmp	r5, r3
	bcc	.L1306
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1292:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L1290
.L1302:
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
	beq	.L1300
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	beq	.L1301
.L1300:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L1299
.L1306:
	ldrh	r2, [r8]
	ldr	r1, [r4, #8]
	ldr	r0, [r6, #4]!
	lsls	r2, r2, #2
	mla	r1, r5, r2, r1
	adds	r5, r5, #1
	bl	ftl_memcpy
	b	.L1305
.L1307:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1319:
	.align	2
.L1318:
	.word	.LANCHOR106
	.word	.LANCHOR17
	.word	.LANCHOR108
	.word	.LANCHOR37
	.word	.LANCHOR164
	.word	.LC1
	.word	.LANCHOR2
	.word	.LANCHOR6
	.word	.LANCHOR37+24
	.word	.LANCHOR10
	.word	.LANCHOR107
	.word	.LANCHOR137
	.size	FtlLoadBbt, .-FtlLoadBbt
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
	ldr	r7, .L1339
	bl	FtlBbtMemInit
	sub	r8, r7, #18
	bl	FtlLoadFactoryBbt
.L1321:
	ldr	r3, .L1339+4
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L1327
	ldr	r5, .L1339+8
	movs	r4, #0
.L1328:
	ldrh	r3, [r5]
	uxth	r0, r4
	adds	r4, r4, #1
	cmp	r3, r0
	bhi	.L1329
	ldr	r4, .L1339+12
	movw	r6, #65535
	ldrh	r5, [r4, #12]
	subs	r5, r5, #1
	uxth	r5, r5
.L1330:
	ldrh	r3, [r4, #12]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L1334
	mov	r0, r5
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L1331
	mov	r0, r5
	bl	FlashTestBlk
	cmp	r0, #0
	beq	.L1332
	mov	r0, r5
	bl	FtlBbmMapBadBlock
.L1331:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L1330
.L1327:
	ldr	r3, .L1339+16
	ldr	r5, .L1339+20
	ldrh	r2, [r8, #2]!
	ldr	r4, .L1339+24
	ldr	r0, [r3]
	movw	r3, #65535
	ldr	r10, [r5]
	cmp	r2, r3
	mov	fp, r4
	ldr	r3, .L1339+28
	str	r0, [r4, #8]
	str	r10, [r4, #12]
	beq	.L1322
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
.L1323:
	uxth	r0, r5
	adds	r6, r6, #1
	adds	r7, r7, #4
	bl	FtlBbmMapBadBlock
	b	.L1321
.L1322:
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
.L1324:
	ldr	r3, [sp]
	ldrh	r0, [r3]
	smlabb	r0, r0, r6, r4
	uxth	r0, r0
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L1325
	ldr	r3, [sp, #4]
	movs	r2, #16
	movs	r1, #0
	strh	r4, [r8]	@ movhi
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L1339+16
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
	ldr	r3, .L1339+32
	ldrh	r2, [r3]
	lsls	r2, r2, #2
	bl	ftl_memcpy
	movs	r2, #1
	ldr	r0, .L1339+24
	mov	r1, r2
	bl	FlashEraseBlocks
	movs	r3, #1
	ldr	r0, .L1339+24
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r3, [fp]
	adds	r3, r3, #1
	bne	.L1323
	uxth	r0, r5
	bl	FtlBbmMapBadBlock
	b	.L1324
.L1325:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L1324
.L1329:
	bl	FtlBbmMapBadBlock
	b	.L1328
.L1332:
	ldrh	r3, [r4]
	cmp	r3, r6
	bne	.L1333
	strh	r5, [r4]	@ movhi
	b	.L1331
.L1333:
	strh	r5, [r4, #4]	@ movhi
.L1334:
	ldr	r3, .L1339+36
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
.L1340:
	.align	2
.L1339:
	.word	.LANCHOR37+28
	.word	.LANCHOR10
	.word	.LANCHOR25
	.word	.LANCHOR37
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR106
	.word	.LANCHOR17
	.word	.LANCHOR137
	.word	.LANCHOR111
	.size	FtlMakeBbt, .-FtlMakeBbt
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
	ldr	r3, .L1353
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #104
	str	r2, [sp]
	adds	r2, r0, r1
	mov	r7, r0
	mov	r5, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L1349
	ldr	r3, .L1353+4
	mov	r8, #0
	ldrh	r6, [r3]
	lsr	r6, r0, r6
	lsl	fp, r6, #2
.L1343:
	cbnz	r5, .L1348
.L1341:
	mov	r0, r8
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1348:
	ldr	r3, .L1353+8
	mov	r0, r7
	ldr	r10, .L1353+24
	ldr	r3, [r3]
	ldr	r2, [r3, fp]
	ldr	r3, .L1353+12
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
	cbz	r2, .L1345
	cmp	r4, r3
	beq	.L1345
	ldr	r3, [r10]
	add	r0, sp, #20
	str	r2, [sp, #24]
	movs	r2, #1
	mov	r1, r2
	str	r3, [sp, #28]
	add	r3, sp, #40
	str	r3, [sp, #32]
	bl	FlashReadPages
.L1346:
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
	ldr	r0, .L1353+16
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
	b	.L1343
.L1345:
	ldr	r3, .L1353+20
	movs	r1, #0
	ldr	r0, [r10]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L1346
.L1349:
	mov	r8, #-1
	b	.L1341
.L1354:
	.align	2
.L1353:
	.word	.LANCHOR16
	.word	.LANCHOR22
	.word	.LANCHOR133
	.word	.LANCHOR12
	.word	.LANCHOR149
	.word	.LANCHOR23
	.word	.LANCHOR124
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
	ldr	r2, .L1357
	ldr	r3, .L1357+4
	ldr	r1, [r2]
	cmp	r1, r3
	bne	.L1355
	ldr	r3, .L1357+8
	movs	r1, #1
	movs	r0, #0
	str	r3, [r2, #4]
	ldr	r3, .L1357+12
	ldr	r3, [r3]
	str	r3, [r2, #88]
	ldr	r3, .L1357+16
	ldr	r3, [r3]
	str	r3, [r2, #92]
	ldr	r3, .L1357+20
	ldr	r3, [r3]
	str	r3, [r2, #8]
	ldr	r3, .L1357+24
	ldr	r3, [r3]
	str	r3, [r2, #12]
	ldr	r3, .L1357+28
	ldr	r3, [r3]
	str	r3, [r2, #16]
	ldr	r3, .L1357+32
	ldr	r3, [r3]
	str	r3, [r2, #20]
	ldr	r3, .L1357+36
	ldr	r3, [r3]
	str	r3, [r2, #28]
	ldr	r3, .L1357+40
	ldr	r3, [r3]
	str	r3, [r2, #32]
	ldr	r3, .L1357+44
	ldr	r3, [r3]
	str	r3, [r2, #36]
	ldr	r3, .L1357+48
	ldr	r3, [r3]
	str	r3, [r2, #40]
	ldr	r3, .L1357+52
	ldr	r3, [r3]
	str	r3, [r2, #44]
	ldr	r3, .L1357+56
	ldr	r3, [r3]
	str	r3, [r2, #48]
	b	FtlVendorPartWrite
.L1355:
	bx	lr
.L1358:
	.align	2
.L1357:
	.word	.LANCHOR81
	.word	1179929683
	.word	1342177348
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
	ldr	r2, .L1364
	push	{r3, lr}
	ldrh	r3, [r2]
	cmp	r3, #31
	itett	ls
	addls	r3, r3, #1
	movhi	r3, #32
	strhls	r3, [r2]	@ movhi
	movls	r3, #1
	ldr	r2, .L1364+4
	cbnz	r0, .L1361
	ldr	r1, [r2]
	ldr	r0, [r1, #20]
	ldr	r1, [r1, #16]
	add	r3, r3, r0
	cmp	r1, r3
	bcc	.L1362
.L1361:
	ldr	r2, [r2]
	movs	r0, #64
	ldr	r3, [r2, #16]
	str	r3, [r2, #20]
	ldr	r3, .L1364+8
	str	r3, [r2]
	ldr	r3, .L1364+12
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
.L1362:
	movs	r0, #0
	pop	{r3, pc}
.L1365:
	.align	2
.L1364:
	.word	.LANCHOR165
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
	ldr	r3, .L1376
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r2
	adds	r2, r0, r1
	sub	sp, sp, #104
	mov	r6, r0
	mov	r5, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L1375
	ldr	r3, .L1376+4
	movs	r7, #0
	ldr	fp, .L1376+16
	ldrh	r3, [r3]
	lsr	r3, r0, r3
	lsls	r3, r3, #2
	str	r3, [sp, #4]
.L1369:
	cbnz	r5, .L1374
.L1367:
	mov	r0, r7
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1374:
	ldr	r3, .L1376+8
	mov	r0, r6
	ldr	r2, [sp, #4]
	ldr	r3, [r3]
	ldr	r3, [r3, r2]
	ldr	r2, .L1376+12
	str	r3, [sp, #12]
	ldrh	r4, [r2]
	mov	r1, r4
	bl	__aeabi_uidivmod
	subs	r4, r4, r1
	ldr	r3, [sp, #12]
	uxth	r4, r4
	str	r1, [sp, #8]
	cmp	r5, r4
	it	cc
	uxthcc	r4, r5
	lsl	r10, r4, #9
	cbz	r3, .L1371
	str	r3, [sp, #24]
	movs	r2, #1
	ldr	r3, [fp]
	mov	r1, r2
	add	r0, sp, #20
	str	r3, [sp, #28]
	add	r3, sp, #40
	str	r3, [sp, #32]
	bl	FlashReadPages
	ldr	r3, [sp, #20]
	mov	r2, r10
	ldr	r1, [fp]
	mov	r0, r8
	adds	r3, r3, #1
	ldr	r3, [sp, #8]
	it	eq
	moveq	r7, #-1
	add	r1, r1, r3, lsl #9
	bl	ftl_memcpy
.L1373:
	ldr	r3, [sp, #4]
	subs	r5, r5, r4
	add	r6, r6, r4
	add	r8, r8, r10
	adds	r3, r3, #4
	str	r3, [sp, #4]
	b	.L1369
.L1371:
	mov	r2, r10
	mov	r1, r3
	mov	r0, r8
	bl	ftl_memset
	b	.L1373
.L1375:
	mov	r7, #-1
	b	.L1367
.L1377:
	.align	2
.L1376:
	.word	.LANCHOR16
	.word	.LANCHOR22
	.word	.LANCHOR133
	.word	.LANCHOR12
	.word	.LANCHOR124
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
	ldr	r4, .L1380
	ldr	r5, .L1380+4
	ldr	r2, [r4]
	ldrh	r1, [r5]
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	ldr	r2, [r3]
	ldr	r3, .L1380+8
	cmp	r2, r3
	beq	.L1379
	ldr	r1, .L1380+12
	ldr	r0, .L1380+16
	bl	printf
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r0, [r4]
	lsls	r2, r2, #9
	bl	ftl_memset
.L1379:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L1381:
	.align	2
.L1380:
	.word	.LANCHOR127
	.word	.LANCHOR125
	.word	1112818501
	.word	.LC103
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
	ldr	r4, .L1385
	movs	r0, #0
	ldr	r5, .L1385+4
	mov	r2, r4
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	cmp	r3, r5
	beq	.L1383
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	ftl_memset
	str	r5, [r4]
.L1383:
	ldr	r3, [r4]
	cmp	r3, r5
	ldr	r3, .L1385+8
	bne	.L1384
	ldr	r1, [r4, #88]
	ldr	r2, .L1385+12
	str	r1, [r2]
	ldr	r1, [r4, #92]
	ldr	r2, .L1385+16
	str	r1, [r2]
	ldr	r1, [r4, #8]
	ldr	r2, .L1385+20
	str	r1, [r2]
	ldr	r1, [r4, #12]
	ldr	r2, .L1385+24
	str	r1, [r2]
	ldr	r1, [r4, #16]
	ldr	r2, .L1385+28
	str	r1, [r2]
	ldr	r1, [r4, #20]
	ldr	r2, .L1385+32
	str	r1, [r2]
	ldr	r2, [r4, #28]
	ldr	r1, [r4, #32]
	str	r2, [r3]
	ldr	r2, .L1385+36
	str	r1, [r2]
	ldr	r1, [r4, #36]
	ldr	r2, .L1385+40
	str	r1, [r2]
	ldr	r1, [r4, #40]
	ldr	r2, .L1385+44
	str	r1, [r2]
	ldr	r1, [r4, #44]
	ldr	r2, .L1385+48
	str	r1, [r2]
	ldr	r1, [r4, #48]
	ldr	r2, .L1385+52
	str	r1, [r2]
.L1384:
	ldr	r1, .L1385+56
	ldr	r2, .L1385+60
	ldr	r3, [r3]
	ldr	r0, [r1]
	ldrh	r2, [r2]
	ldr	r1, .L1385+64
	mla	r0, r0, r2, r3
	ldrh	r1, [r1]
	bl	__aeabi_uidiv
	ldr	r3, .L1385+68
	str	r0, [r3]
	pop	{r3, r4, r5, pc}
.L1386:
	.align	2
.L1385:
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
	movs	r6, #0
	ldr	r3, .L1400
	movw	fp, #65535
	ldr	r8, .L1400+80
	ldr	r10, .L1400+84
	ldrh	r2, [r3]
	ldr	r0, [r8]
	ldr	r7, [r10]
	ldr	r5, .L1400+4
	ldr	r4, .L1400+8
	ldr	r1, .L1400+12
	str	r0, [r5, #8]
	str	r7, [r5, #12]
	strh	r2, [r7, #2]	@ movhi
	movw	r2, #61604
	strh	r2, [r7]	@ movhi
	ldr	r2, [r3, #8]
	str	r6, [r7, #8]
	str	r6, [r7, #12]
	str	r2, [r7, #4]
	ldr	r2, .L1400+16
	str	r3, [sp, #4]
	stm	r4, {r1, r2}
	ldrh	r2, [r3, #6]
	strh	r2, [r4, #8]	@ movhi
	ldr	r2, .L1400+20
	ldrh	r2, [r2]
	strb	r2, [r4, #10]
	ldr	r2, .L1400+24
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r4, #14]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r4, #11]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1400+28
	strh	r1, [r4, #16]	@ movhi
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r4, #18]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	orr	r1, r1, ip, lsl #6
	strh	r1, [r4, #20]	@ movhi
	strb	r2, [r4, #12]
	ldr	r2, .L1400+32
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r4, #22]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r4, #13]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1400+36
	strh	r1, [r4, #24]	@ movhi
	movs	r1, #255
	ldr	r2, [r2]
	str	r2, [r4, #32]
	ldr	r2, .L1400+40
	ldr	r2, [r2]
	str	r2, [r4, #40]
	ldr	r2, .L1400+44
	ldr	r2, [r2]
	str	r2, [r4, #36]
	ldr	r2, .L1400+48
	ldrh	r2, [r2]
	bl	ftl_memset
	mov	r1, r4
	ldr	r4, .L1400+52
	movs	r2, #48
	ldr	r0, [r5, #8]
	bl	ftl_memcpy
	ldrh	r2, [r4]
	ldr	r0, [r5, #8]
	ldr	r1, .L1400+56
	lsls	r2, r2, #1
	adds	r0, r0, #48
	ldr	r1, [r1]
	bl	ftl_memcpy
	ldrh	r0, [r4]
	ldr	r1, .L1400+60
	ldr	r4, [r5, #8]
	lsrs	r2, r0, #3
	adds	r0, r0, #24
	lsls	r0, r0, #1
	ldr	r1, [r1]
	adds	r2, r2, #4
	bic	r0, r0, #3
	add	r0, r0, r4
	bl	ftl_memcpy
	mov	r0, r6
	bl	FtlUpdateVaildLpn
	ldr	r3, [sp, #4]
	mov	r4, r3
.L1389:
	ldr	r3, [r8]
	ldrh	r2, [r4]
	ldr	r0, .L1400+4
	str	r3, [r5, #8]
	ldr	r3, [r10]
	str	r3, [r5, #12]
	ldrh	r3, [r4, #2]
	orr	r3, r3, r2, lsl #10
	str	r3, [r5, #4]
	movs	r3, #1
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r3, .L1400+64
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L1390
	ldrh	r3, [r4]
	ldrh	fp, [r4, #4]
	strh	r3, [r4, #4]	@ movhi
	movs	r3, #0
	strh	r3, [r4, #2]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r2, .L1400+40
	strh	r0, [r4]	@ movhi
	ldr	r3, [r2]
	adds	r1, r3, #1
	str	r3, [r4, #8]
	str	r1, [r2]
	lsls	r2, r0, #10
	str	r2, [r5, #4]
	str	r3, [r7, #4]
	movs	r3, #1
	strh	r0, [r7, #2]	@ movhi
	mov	r2, r3
	mov	r1, r3
	ldr	r0, .L1400+4
	bl	FlashProgPages
.L1390:
	ldrh	r3, [r4, #2]
	ldr	r2, [r5]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r2, r2, #1
	strh	r3, [r4, #2]	@ movhi
	bne	.L1391
	cmp	r3, #1
	bne	.L1392
	movw	r2, #1124
	ldr	r1, .L1400+68
	ldr	r0, .L1400+72
	bl	printf
.L1392:
	ldrh	r3, [r4, #2]
	adds	r6, r6, #1
	uxth	r6, r6
	cmp	r3, #1
	itttt	eq
	ldreq	r3, .L1400+64
	ldrheq	r3, [r3]
	addeq	r3, r3, #-1
	strheq	r3, [r4, #2]	@ movhi
	cmp	r6, #3
	bls	.L1389
	mov	r2, r6
	ldr	r1, [r5, #4]
	ldr	r0, .L1400+76
	bl	printf
.L1395:
	b	.L1395
.L1391:
	cmp	r3, #1
	beq	.L1389
	movw	r3, #65535
	cmp	fp, r3
	beq	.L1396
	movs	r1, #1
	mov	r0, fp
	bl	FtlFreeSysBlkQueueIn
.L1396:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1401:
	.align	2
.L1400:
	.word	.LANCHOR79
	.word	.LANCHOR106
	.word	.LANCHOR39
	.word	1179929683
	.word	1342177348
	.word	.LANCHOR10
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR72
	.word	.LANCHOR70
	.word	.LANCHOR71
	.word	.LANCHOR23
	.word	.LANCHOR5
	.word	.LANCHOR42
	.word	.LANCHOR1
	.word	.LANCHOR20
	.word	.LANCHOR166
	.word	.LC1
	.word	.LC104
	.word	.LANCHOR107
	.word	.LANCHOR108
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
	ldr	r3, .L1405
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L1404
	bl	FtlSysFlush
.L1404:
	movs	r0, #0
	pop	{r3, pc}
.L1406:
	.align	2
.L1405:
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
	ldr	r3, .L1422
	adds	r2, r0, r1
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r7, r0
	mov	r5, r1
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L1415
	cmp	r1, #31
	bhi	.L1409
.L1414:
	movs	r0, #0
.L1407:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1409:
	ldr	r8, .L1422+12
	ldrh	r4, [r8]
	mov	r1, r4
	bl	__aeabi_uidiv
	smulbb	r3, r0, r4
	mov	r6, r0
	subs	r7, r7, r3
	uxth	r7, r7
	cbz	r7, .L1410
	subs	r4, r4, r7
	adds	r6, r6, #1
	cmp	r4, r5
	it	cs
	movcs	r4, r5
	uxth	r4, r4
	subs	r5, r5, r4
.L1410:
	ldr	r4, .L1422+4
	mov	r3, #-1
	ldr	r7, .L1422+8
	str	r3, [sp, #4]
.L1411:
	ldrh	r3, [r8]
	cmp	r5, r3
	bcs	.L1413
	ldr	r3, .L1422+4
	ldr	r2, [r3]
	cmp	r2, #32
	bls	.L1414
	movs	r4, #0
	str	r4, [r3]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L1414
.L1413:
	movs	r2, #0
	mov	r1, sp
	mov	r0, r6
	bl	log2phys
	ldr	r3, [sp]
	adds	r3, r3, #1
	beq	.L1412
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
.L1412:
	ldrh	r3, [r8]
	adds	r6, r6, #1
	subs	r5, r5, r3
	b	.L1411
.L1415:
	mov	r0, #-1
	b	.L1407
.L1423:
	.align	2
.L1422:
	.word	.LANCHOR34
	.word	.LANCHOR167
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
	movs	r5, #0
	ldr	r1, .L1436
	ldr	r0, .L1436+4
	bl	printf
	ldr	r3, .L1436+8
	movs	r1, #0
	ldr	r4, .L1436+12
	ldr	r6, .L1436+16
	ldrh	r2, [r3]
	ldr	r0, [r4]
	lsls	r2, r2, #1
	bl	ftl_memset
.L1425:
	ldr	r3, [r6]
	cmp	r5, r3
	bcc	.L1427
	ldr	r10, .L1436+36
	movs	r7, #0
	ldr	r8, .L1436+40
.L1428:
	ldrh	r3, [r10]
	uxth	r5, r7
	cmp	r3, r5
	bhi	.L1432
	add	sp, sp, #12
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L1427:
	movs	r2, #0
	add	r1, sp, #4
	mov	r0, r5
	bl	log2phys
	ldr	r0, [sp, #4]
	adds	r3, r0, #1
	beq	.L1426
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldr	r2, [r4]
	ldrh	r3, [r2, r0, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r0, lsl #1]	@ movhi
.L1426:
	adds	r5, r5, #1
	b	.L1425
.L1432:
	ldr	r3, [r8]
	uxth	r6, r7
	ldrh	r2, [r3, r6, lsl #1]
	ldr	r3, [r4]
	ldrh	r3, [r3, r6, lsl #1]
	cmp	r2, r3
	beq	.L1430
	movw	r1, #65535
	cmp	r2, r1
	beq	.L1430
	mov	r1, r6
	ldr	r0, .L1436+20
	bl	printf
	ldr	r3, .L1436+24
	ldrh	r3, [r3]
	cmp	r3, r5
	beq	.L1430
	ldr	r3, .L1436+28
	ldrh	r3, [r3]
	cmp	r3, r5
	beq	.L1430
	ldr	r3, .L1436+32
	ldrh	r3, [r3]
	cmp	r3, r5
	beq	.L1430
	ldr	r3, [r4]
	mov	r0, r5
	ldrh	r2, [r3, r6, lsl #1]
	ldr	r3, [r8]
	strh	r2, [r3, r6, lsl #1]	@ movhi
	bl	update_vpc_list
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1430:
	adds	r7, r7, #1
	b	.L1428
.L1437:
	.align	2
.L1436:
	.word	.LANCHOR168
	.word	.LC94
	.word	.LANCHOR6
	.word	.LANCHOR128
	.word	.LANCHOR61
	.word	.LC105
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
	ldr	r3, .L1448
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r4, [r0]
	ldrh	r3, [r3]
	cmp	r3, r4
	bcs	.L1439
	movw	r2, #2684
	ldr	r1, .L1448+4
	ldr	r0, .L1448+8
	bl	printf
.L1439:
	movw	r3, #65535
	cmp	r4, r3
	beq	.L1440
	ldr	r3, .L1448+12
	mov	r0, r4
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cbz	r3, .L1441
	bl	INSERT_DATA_LIST
.L1440:
	ldr	r5, .L1448+16
	movw	r2, #65535
	movs	r3, #1
	strb	r3, [r6, #8]
	ldrh	r0, [r5]
	cmp	r0, r2
	beq	.L1442
	cmp	r4, r0
	bne	.L1443
	ldr	r3, .L1448+12
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L1444
.L1443:
	bl	update_vpc_list
.L1444:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L1442:
	mov	r0, r6
	bl	allocate_data_superblock
	bl	l2p_flush
	movs	r0, #0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L1441:
	bl	INSERT_FREE_LIST
	b	.L1440
.L1449:
	.align	2
.L1448:
	.word	.LANCHOR5
	.word	.LANCHOR169
	.word	.LC1
	.word	.LANCHOR42
	.word	.LANCHOR150
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
	ldr	r8, .L1464+24
	mov	r4, r3
	movs	r2, #0
	mov	r5, r0
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	mov	r10, r1
	bl	FlashProgPages
.L1451:
	cmp	r6, r10
	beq	.L1458
	ldr	r7, .L1464
	b	.L1459
.L1454:
	ldr	r0, [r5, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r4]
	cmp	r3, r0
	bne	.L1452
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
.L1452:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1453
	mov	r0, r4
	bl	allocate_new_data_superblock
.L1453:
	ldr	r2, .L1464+4
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
.L1459:
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L1454
	ldr	r3, .L1464+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1455
	movw	r2, #933
	ldr	r1, .L1464+12
	ldr	r0, .L1464+16
	bl	printf
.L1455:
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
	beq	.L1456
	ldr	r3, [r8]
	ldrh	r2, [r3, r0, lsl #1]
	cbnz	r2, .L1457
	mov	r1, r0
	ldr	r0, .L1464+20
	bl	printf
.L1457:
	mov	r0, r7
	bl	decrement_vpc_count
.L1456:
	adds	r6, r6, #1
	adds	r5, r5, #20
	b	.L1451
.L1458:
	ldr	r3, .L1464+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1450
	mov	r2, #948
	ldr	r1, .L1464+12
	ldr	r0, .L1464+16
	bl	printf
.L1450:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1465:
	.align	2
.L1464:
	.word	.LANCHOR19
	.word	.LANCHOR81
	.word	.LANCHOR3
	.word	.LANCHOR170
	.word	.LC1
	.word	.LC106
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
	ldr	r4, .L1492
	ldr	r6, .L1492+4
	ldrh	r5, [r4]
	ldrh	r1, [r6]
	cmp	r5, r2
	bne	.L1467
.L1477:
	ldr	r3, .L1492+8
	movs	r2, #0
	str	r2, [r3]
	movw	r3, #65535
	ldrh	r2, [r4]
	cmp	r2, r3
	bne	.L1490
.L1468:
	movs	r0, #0
.L1466:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1467:
	cbz	r0, .L1470
	ldr	r3, .L1492+12
	ldrh	r0, [r3]
	cmp	r0, r2
	beq	.L1471
.L1472:
	movs	r1, #2
.L1470:
	ldr	r0, .L1492
	bl	FtlGcScanTempBlk
	str	r0, [sp, #12]
	adds	r0, r0, #1
	beq	.L1473
	ldr	r3, .L1492+16
	ldr	r2, [r3]
	ldrh	r3, [r2, r5, lsl #1]
	cmp	r3, #4
	bls	.L1474
	subs	r3, r3, #5
	movs	r0, #1
	strh	r3, [r2, r5, lsl #1]	@ movhi
	bl	FtlEctTblFlush
.L1474:
	ldr	r4, .L1492+8
	ldr	r2, [r4]
	cbnz	r2, .L1475
	ldr	r2, .L1492+20
	ldr	r0, [sp, #12]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L1475:
	movs	r3, #0
	str	r3, [r4]
.L1486:
	movs	r0, #1
	b	.L1466
.L1471:
	movs	r2, #0
	strh	r2, [r3]	@ movhi
	ldr	r3, .L1492+24
	ldrh	r3, [r3]
	cmp	r3, #17
	bhi	.L1472
	b	.L1470
.L1473:
	ldr	r3, .L1492+12
	ldrh	r2, [r3]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1486
	b	.L1477
.L1490:
	ldrb	r1, [r4, #7]	@ zero_extendqisi2
	ldrh	r3, [r6]
	ldr	r5, .L1492+28
	muls	r3, r1, r3
	ldrh	r2, [r5]
	cmp	r2, r3
	beq	.L1478
	movs	r2, #162
	ldr	r1, .L1492+32
	ldr	r0, .L1492+36
	bl	printf
.L1478:
	ldrh	r6, [r6]
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldr	r2, .L1492+40
	ldrh	r0, [r4]
	ldr	fp, .L1492+68
	smulbb	r3, r3, r6
	ldr	r1, [r2]
	movs	r6, #0
	str	r2, [sp, #4]
	strh	r3, [r1, r0, lsl #1]	@ movhi
	ldr	r1, .L1492+44
	ldrh	r3, [r5]
	ldr	r0, [r1]
	add	r3, r3, r0
	str	r3, [r1]
.L1479:
	ldrh	r2, [r5]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L1483
	movw	r0, #65535
	bl	decrement_vpc_count
	ldr	r3, [sp, #4]
	ldrh	r0, [r4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	beq	.L1484
	bl	INSERT_DATA_LIST
.L1485:
	ldr	r3, .L1492+48
	movw	r6, #65535
	strh	r6, [r4]	@ movhi
	movs	r4, #0
	strh	r4, [r5]	@ movhi
	strh	r4, [r3]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	r3, .L1492+24
	ldrh	r2, [r3]
	ldr	r3, .L1492+52
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	cmp	r2, r3, asr #2
	ble	.L1468
	ldr	r3, .L1492+56
	movs	r2, #20
	strh	r6, [r3]	@ movhi
	ldr	r3, .L1492+60
	strh	r2, [r3]	@ movhi
	b	.L1468
.L1483:
	uxth	r3, r6
	movs	r7, #12
	ldr	r2, [fp]
	muls	r7, r3, r7
	ldr	r3, .L1492+64
	ldr	r8, [r3]
	add	r10, r8, r7
	ldr	r1, [r10, #8]
	cmp	r1, r2
	bcc	.L1480
	movs	r2, #168
	ldr	r1, .L1492+32
	ldr	r0, .L1492+36
	bl	printf
.L1480:
	movs	r2, #0
	add	r1, sp, #12
	ldr	r0, [r10, #8]
	bl	log2phys
	ldr	r2, [sp, #12]
	ldr	r0, [r8, r7]
	cmp	r0, r2
	bne	.L1481
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	movs	r2, #1
	mov	r7, r0
	add	r1, r10, #4
	ldr	r0, [r10, #8]
	bl	log2phys
	mov	r0, r7
.L1491:
	bl	decrement_vpc_count
.L1482:
	adds	r6, r6, #1
	b	.L1479
.L1481:
	ldr	r3, [r10, #4]
	cmp	r2, r3
	beq	.L1482
	ldrh	r0, [r4]
	b	.L1491
.L1484:
	bl	INSERT_FREE_LIST
	b	.L1485
.L1493:
	.align	2
.L1492:
	.word	.LANCHOR53
	.word	.LANCHOR19
	.word	.LANCHOR152
	.word	.LANCHOR156
	.word	.LANCHOR43
	.word	.LANCHOR81
	.word	.LANCHOR48
	.word	.LANCHOR97
	.word	.LANCHOR171
	.word	.LC1
	.word	.LANCHOR42
	.word	.LANCHOR67
	.word	.LANCHOR96
	.word	.LANCHOR78
	.word	.LANCHOR80
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
	ldr	r4, .L1496
	ldr	r5, .L1496+4
	ldrh	r1, [r4]
	mov	r0, r5
	bl	FtlGcScanTempBlk
	ldrh	r2, [r5, #2]
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L1494
	ldr	r0, .L1496+8
	bl	FtlMapBlkWriteDump_data
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r3, .L1496+12
	movs	r2, #0
	str	r2, [r3]
.L1494:
	pop	{r3, r4, r5, pc}
.L1497:
	.align	2
.L1496:
	.word	.LANCHOR19
	.word	.LANCHOR53
	.word	.LANCHOR144
	.word	.LANCHOR152
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
	ldr	r5, .L1499
	ldr	r3, .L1499+4
	mov	r0, r5
	str	r4, [r3]
	bl	FtlRecoverySuperblock
	mov	r0, r5
	ldr	r5, .L1499+8
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
.L1500:
	.align	2
.L1499:
	.word	.LANCHOR51
	.word	.LANCHOR162
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
	ldr	r4, .L1508
	movs	r6, #0
	movs	r7, #20
	mov	r2, r3
	ldr	r5, .L1508+4
	ldr	r1, [r4]
	ldr	r0, [r5]
	bl	FlashProgPages
.L1502:
	ldr	r1, [r4]
	uxth	r3, r6
	cmp	r1, r3
	bhi	.L1505
	ldr	r0, [r5]
	bl	FtlGcBufFree
	ldr	r3, .L1508+8
	movs	r0, #0
	str	r0, [r4]
	ldrh	r3, [r3, #4]
	cbnz	r3, .L1501
	movs	r0, #1
	bl	FtlGcFreeTempBlock
	b	.L1507
.L1505:
	muls	r3, r7, r3
	ldr	r2, [r5]
	adds	r6, r6, #1
	adds	r1, r2, r3
	ldr	r2, [r2, r3]
	adds	r3, r2, #1
	bne	.L1503
	ldr	r3, .L1508+8
	movs	r5, #0
	ldr	r0, .L1508+12
	ldrh	r4, [r3]
	ldr	r0, [r0]
	strh	r5, [r0, r4, lsl #1]	@ movhi
	strh	r2, [r3]	@ movhi
	ldr	r2, .L1508+16
	ldr	r0, [r1, #4]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
.L1507:
	movs	r0, #1
.L1501:
	pop	{r3, r4, r5, r6, r7, pc}
.L1503:
	ldr	r3, [r1, #12]
	ldr	r1, [r1, #4]
	ldr	r2, [r3, #8]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L1502
.L1509:
	.align	2
.L1508:
	.word	.LANCHOR89
	.word	.LANCHOR121
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
	ldr	r4, .L1513
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L1511
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1512
.L1511:
	movs	r0, #0
	movs	r5, #0
	bl	FtlGcFreeTempBlock
	ldr	r0, .L1513
	strb	r5, [r4, #8]
	bl	allocate_data_superblock
	ldr	r3, .L1513+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L1513+8
	strh	r5, [r3]	@ movhi
	bl	l2p_flush
	mov	r0, r5
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1512:
	ldr	r0, .L1513
	pop	{r3, r4, r5, lr}
	b	get_new_active_ppa
.L1514:
	.align	2
.L1513:
	.word	.LANCHOR53
	.word	.LANCHOR96
	.word	.LANCHOR97
	.size	Ftl_get_new_temp_ppa, .-Ftl_get_new_temp_ppa
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
	ldr	r3, .L1633
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r7, r0
	sub	sp, sp, #48
	ldr	r0, [r3]
	cmp	r0, #0
	bne	.L1590
	ldr	r3, .L1633+4
	ldrh	r3, [r3]
	cmp	r3, #47
	bls	.L1515
	ldr	r3, .L1633+8
	ldrh	r2, [r3]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1517
.L1520:
	ldr	r3, .L1633+12
	movw	r4, #65535
	ldrh	r0, [r3]
	cmp	r0, r4
	bne	.L1518
.L1519:
	ldr	r2, .L1633+16
	movw	r5, #65535
	ldr	r6, .L1633+20
	ldr	r3, [r2]
	ldrh	r0, [r6]
	adds	r3, r3, #1
	add	r3, r3, r7, lsl #7
	cmp	r0, r5
	str	r3, [r2]
	bne	.L1521
	ldr	r1, .L1633+24
	ldrh	r1, [r1]
	cmp	r1, r0
	bne	.L1522
	ldr	r0, .L1633+28
	ldrh	r10, [r0]
	cmp	r10, r1
	bne	.L1523
	ldr	r1, .L1633+32
	ldrh	r0, [r1]
	mov	r8, r1
	cmp	r0, #24
	ite	cc
	movcc	r1, #5120
	movcs	r1, #1024
	cmp	r3, r1
	bls	.L1523
	ldr	r3, .L1633+36
	movs	r4, #0
	str	r4, [r2]
	strh	r4, [r3]	@ movhi
	bl	GetSwlReplaceBlock
	cmp	r0, r10
	mov	r5, r0
	bne	.L1594
	ldr	r10, .L1633+96
	ldrh	r2, [r8]
	ldrh	r3, [r10]
	cmp	r2, r3
	bcs	.L1526
	movs	r0, #64
	bl	List_get_gc_head_node
	uxth	r3, r0
	cmp	r3, r5
	beq	.L1528
	mov	r0, r3
	ldr	r3, .L1633+40
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #7
	bhi	.L1529
	mov	r0, r4
	bl	List_get_gc_head_node
	uxth	r4, r0
	movs	r3, #128
	strh	r3, [r10]	@ movhi
	cmp	r4, r5
	bne	.L1525
.L1528:
	bl	FtlGcReFreshBadBlk
	cmp	r7, #0
	bne	.L1531
	movw	r3, #65535
	cmp	r5, r3
	bne	.L1531
.L1588:
	ldr	r3, .L1633+32
	ldrh	r3, [r3]
	cmp	r3, #24
	bhi	.L1595
	ldr	r2, .L1633+44
	cmp	r3, #16
	ldrh	r4, [r2]
	bls	.L1533
	lsrs	r4, r4, #5
.L1532:
	ldr	r2, .L1633+48
	ldrh	r1, [r2]
	cmp	r1, r3
	mov	r1, r2
	bcs	.L1536
	ldr	r3, .L1633+24
	movw	r0, #65535
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L1537
	ldr	r0, .L1633+28
	ldrh	r0, [r0]
	cmp	r0, r3
	bne	.L1537
	ldr	r3, .L1633+36
	ldrh	r0, [r3]
	cbnz	r0, .L1538
	ldr	r3, .L1633+52
	ldr	r4, .L1633+56
	ldr	r3, [r3]
	ldr	r4, [r4]
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, lsr #2
	bcs	.L1539
.L1538:
	ldr	r3, .L1633+60
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L1540:
	ldr	r3, .L1633+64
	movs	r2, #0
	str	r2, [r3]
.L1515:
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1517:
	ldr	r2, .L1633+24
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L1520
	movs	r0, #1
	bl	FtlGcFreeTempBlock
	cmp	r0, #0
	beq	.L1520
	movs	r0, #1
	b	.L1515
.L1518:
	ldr	r1, .L1633+28
	ldrh	r2, [r1]
	cmp	r2, r4
	itt	eq
	strheq	r0, [r1]	@ movhi
	strheq	r2, [r3]	@ movhi
	b	.L1519
.L1529:
	movs	r3, #64
.L1627:
	strh	r3, [r10]	@ movhi
	b	.L1528
.L1526:
	movs	r3, #80
	b	.L1627
.L1594:
	mov	r4, r0
.L1525:
	ldr	r3, .L1633+40
	mov	r5, r4
	ldr	r1, .L1633+48
	ldrh	r2, [r8]
	ldr	r3, [r3]
	ldrh	r1, [r1]
	ldr	r0, .L1633+68
	ldrh	r3, [r3, r4, lsl #1]
	str	r1, [sp, #4]
	ldr	r1, .L1633+72
	ldr	r1, [r1]
	ldrh	r1, [r1, r4, lsl #1]
	str	r1, [sp]
	mov	r1, r4
	bl	printf
	b	.L1528
.L1533:
	cmp	r3, #12
	bls	.L1534
	lsrs	r4, r4, #4
	b	.L1532
.L1534:
	cmp	r3, #8
	bls	.L1532
	lsrs	r4, r4, #2
	b	.L1532
.L1595:
	movs	r4, #1
	b	.L1532
.L1539:
	movs	r3, #18
	strh	r3, [r2]	@ movhi
	b	.L1540
.L1537:
	ldr	r3, .L1633+60
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L1536:
	ldr	r3, .L1633+76
	ldrh	r3, [r3]
	cbz	r3, .L1596
	adds	r4, r4, #32
	uxth	r4, r4
.L1596:
	movw	r5, #65535
.L1542:
	ldrh	r3, [r6]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L1551
	cmp	r5, r3
	beq	.L1552
	strh	r5, [r6]	@ movhi
.L1553:
	ldrh	r0, [r6]
	movw	r7, #65535
	movs	r3, #0
	strb	r3, [r6, #8]
	cmp	r0, r7
	beq	.L1551
	bl	IsBlkInGcList
	cbz	r0, .L1556
	strh	r7, [r6]	@ movhi
.L1556:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1551
	ldr	r0, .L1633+20
	bl	make_superblock
	ldr	r2, .L1633+80
	movs	r3, #0
	strh	r3, [r6, #2]	@ movhi
	strb	r3, [r6, #6]
	strh	r3, [r2]	@ movhi
	ldr	r3, .L1633+40
	ldrh	r2, [r6]
	ldr	r3, [r3]
	ldrh	r2, [r3, r2, lsl #1]
	ldr	r3, .L1633+84
	strh	r2, [r3]	@ movhi
.L1551:
	ldr	r2, .L1633+88
	ldrh	r3, [r6]
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L1557
	ldr	r2, .L1633+92
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L1557
	ldr	r6, .L1633+20
	mov	fp, r6
.L1558:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1559
	ldr	r8, .L1633+100
	movs	r2, #0
	ldr	r3, .L1633+64
	str	r2, [r3]
.L1560:
	ldrh	r7, [r8]
	mov	r0, r7
	bl	List_get_gc_head_node
	uxth	r3, r0
	movw	r1, #65535
	cmp	r3, r1
	strh	r3, [fp]	@ movhi
	bne	.L1561
	movs	r3, #0
	movs	r0, #8
	strh	r3, [r8]	@ movhi
	b	.L1515
.L1543:
	ldr	r3, .L1633+64
	movs	r2, #0
	ldr	r1, .L1633+48
	ldr	r4, .L1633+32
	str	r2, [r3]
	ldrh	r3, [r1]
	mov	r2, r1
	ldrh	r8, [r4]
	ldr	r5, .L1633+36
	cmp	r3, r8
	bcs	.L1544
	ldrh	r3, [r5]
	cbnz	r3, .L1545
	ldr	r3, .L1633+52
	ldr	r0, .L1633+56
	ldr	r3, [r3]
	ldr	r0, [r0]
	add	r3, r3, r3, lsl #1
	cmp	r0, r3, lsr #2
	bcs	.L1546
.L1545:
	ldr	r3, .L1633+60
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r2]	@ movhi
.L1630:
	bl	FtlReadRefresh
	ldrh	r0, [r5]
	b	.L1515
.L1634:
	.align	2
.L1633:
	.word	.LANCHOR117
	.word	.LANCHOR45
	.word	.LANCHOR156
	.word	.LANCHOR100
	.word	.LANCHOR84
	.word	.LANCHOR80
	.word	.LANCHOR53
	.word	.LANCHOR99
	.word	.LANCHOR48
	.word	.LANCHOR172
	.word	.LANCHOR42
	.word	.LANCHOR19
	.word	.LANCHOR82
	.word	.LANCHOR61
	.word	.LANCHOR59
	.word	.LANCHOR78
	.word	.LANCHOR87
	.word	.LC107
	.word	.LANCHOR43
	.word	.LANCHOR101
	.word	.LANCHOR173
	.word	.LANCHOR174
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR83
	.word	.LANCHOR85
.L1546:
	movs	r3, #18
	strh	r3, [r1]	@ movhi
	b	.L1630
.L1544:
	ldrh	r0, [r5]
	cmp	r0, #0
	bne	.L1548
	ldr	r3, .L1635
	ldrh	r7, [r3]
	add	r2, r7, r7, lsl #1
	asrs	r2, r2, #2
	strh	r2, [r1]	@ movhi
	bl	List_get_gc_head_node
	ldr	r3, .L1635+4
	uxth	r0, r0
	ldr	r2, .L1635+8
	ldr	r3, [r3]
	ldrh	r2, [r2]
	ldrh	r1, [r3, r0, lsl #1]
	ldr	r3, .L1635+12
	ldrh	r3, [r3]
	muls	r2, r3, r2
	cmp	r1, r2, asr #1
	ble	.L1549
	subs	r3, r7, #1
	cmp	r8, r3
	bge	.L1630
.L1549:
	cmp	r1, #0
	bne	.L1548
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r0, [r4]
	adds	r0, r0, #1
	b	.L1515
.L1552:
	ldr	r3, .L1635+16
	ldrh	r2, [r3]
	cmp	r2, r5
	beq	.L1553
	ldr	r1, .L1635+4
	ldr	r1, [r1]
	ldrh	r2, [r1, r2, lsl #1]
	cbnz	r2, .L1554
	strh	r5, [r3]	@ movhi
.L1554:
	ldrh	r2, [r3]
	strh	r2, [r6]	@ movhi
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
	b	.L1553
.L1557:
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
.L1631:
	ldr	r3, .L1635+20
	ldrh	r0, [r3]
	b	.L1515
.L1561:
	str	r0, [sp, #16]
	mov	r0, r3
	str	r3, [sp, #12]
	adds	r7, r7, #1
	bl	IsBlkInGcList
	ldr	r3, [sp, #12]
	ldr	r2, [sp, #16]
	cbz	r0, .L1562
	strh	r7, [r8]	@ movhi
	b	.L1560
.L1562:
	uxth	r0, r2
	ldr	r2, .L1635+24
	ldr	r10, .L1635+4
	uxth	r7, r7
	ldrh	lr, [r2]
	ldr	r2, .L1635+8
	ldr	r1, [r10]
	strh	r7, [r8]	@ movhi
	ldrh	r2, [r2]
	ldrh	ip, [r1, r0, lsl #1]
	mul	lr, r2, lr
	cmp	ip, lr, asr #1
	bgt	.L1564
	cmp	r7, #48
	bls	.L1565
	cmp	ip, #8
	bls	.L1565
	ldr	r7, .L1635+28
	ldrh	r7, [r7]
	cmp	r7, #35
	bhi	.L1565
.L1564:
	ldr	r2, .L1635+32
	movs	r7, #0
	strh	r7, [r2]	@ movhi
.L1565:
	ldrh	r1, [r1, r0, lsl #1]
	cmp	lr, r1
	bgt	.L1566
	movw	r2, #65535
	cmp	r5, r2
	bne	.L1566
	ldr	r2, .L1635+32
	movs	r3, #0
	strh	r5, [fp]	@ movhi
	strh	r3, [r2]	@ movhi
	b	.L1631
.L1566:
	cbnz	r1, .L1567
	movw	r0, #65535
	bl	decrement_vpc_count
	ldr	r3, .L1635+32
	ldr	r2, .L1635+32
	ldrh	r3, [r3]
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	b	.L1560
.L1567:
	movs	r2, #0
	strb	r2, [fp, #8]
	ldr	r2, .L1635+36
	ldrh	r2, [r2]
	cmp	r2, r3
	bne	.L1568
	movw	r2, #658
	ldr	r1, .L1635+40
	ldr	r0, .L1635+44
	bl	printf
.L1568:
	ldr	r3, .L1635+48
	ldrh	r2, [fp]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1569
	movw	r2, #659
	ldr	r1, .L1635+40
	ldr	r0, .L1635+44
	bl	printf
.L1569:
	ldr	r3, .L1635+52
	ldrh	r2, [fp]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1570
	mov	r2, #660
	ldr	r1, .L1635+40
	ldr	r0, .L1635+44
	bl	printf
.L1570:
	mov	r0, r6
	bl	make_superblock
	ldr	r2, .L1635+56
	movs	r3, #0
	ldrh	r1, [fp]
	strh	r3, [r2]	@ movhi
	ldr	r2, [r10]
	ldrh	r1, [r2, r1, lsl #1]
	ldr	r2, .L1635+60
	strh	r3, [fp, #2]	@ movhi
	strb	r3, [fp, #6]
	strh	r1, [r2]	@ movhi
.L1559:
	bl	FtlReadRefresh
	ldr	r3, .L1635+64
	movs	r2, #1
	str	r2, [r3]
	ldr	r3, .L1635+24
	ldrh	r3, [r3]
	str	r3, [sp, #28]
	ldrh	r3, [fp, #2]
	ldr	r1, [sp, #28]
	adds	r2, r3, r4
	cmp	r2, r1
	itt	gt
	movgt	r2, r1
	subgt	r4, r2, r3
	mov	r3, #0
	it	gt
	uxthgt	r4, r4
.L1629:
	str	r3, [sp, #24]
	ldrh	r3, [sp, #24]
	cmp	r4, r3
	bls	.L1580
	ldr	r3, .L1635+8
	movw	r10, #65535
	ldrh	r8, [r6, #2]
	ldr	r1, .L1635+68
	ldrh	ip, [r3]
	ldr	r3, .L1635+72
	ldr	r0, [r3]
	ldr	r3, [sp, #24]
	add	r8, r8, r3
	movs	r3, #0
	str	r3, [sp, #12]
	b	.L1581
.L1574:
	ldrh	r2, [r1, #2]!
	cmp	r2, r10
	beq	.L1573
	ldr	r7, [sp, #12]
	mov	lr, #20
	orr	r2, r8, r2, lsl #10
	mla	lr, lr, r7, r0
	str	r2, [lr, #4]
	mov	r2, r7
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #12]
.L1573:
	adds	r3, r3, #1
.L1581:
	uxth	r2, r3
	cmp	ip, r2
	bhi	.L1574
	ldrb	r2, [r6, #8]	@ zero_extendqisi2
	ldr	r1, [sp, #12]
	bl	FlashReadPages
	movs	r3, #0
.L1628:
	str	r3, [sp, #20]
	ldr	r2, [sp, #12]
	ldrh	r3, [sp, #20]
	cmp	r2, r3
	bhi	.L1579
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	b	.L1629
.L1636:
	.align	2
.L1635:
	.word	.LANCHOR78
	.word	.LANCHOR42
	.word	.LANCHOR3
	.word	.LANCHOR20
	.word	.LANCHOR99
	.word	.LANCHOR172
	.word	.LANCHOR19
	.word	.LANCHOR96
	.word	.LANCHOR85
	.word	.LANCHOR51
	.word	.LANCHOR175
	.word	.LC1
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR173
	.word	.LANCHOR174
	.word	.LANCHOR117
	.word	.LANCHOR80+14
	.word	.LANCHOR93
.L1579:
	ldr	r3, [sp, #20]
	movs	r7, #20
	muls	r7, r3, r7
	ldr	r3, .L1637
	ldr	r3, [r3]
	adds	r2, r3, r7
	ldr	r3, [r3, r7]
	adds	r3, r3, #1
	beq	.L1576
	ldr	r3, [r2, #12]
	ldrh	r2, [r3]
	str	r3, [sp, #16]
	movw	r3, #61589
	cmp	r2, r3
	bne	.L1576
	ldr	r3, [sp, #16]
	ldr	r8, [r3, #8]
	cmp	r8, #-1
	bne	.L1577
	mov	r2, #696
	ldr	r1, .L1637+4
	ldr	r0, .L1637+8
	bl	printf
.L1577:
	movs	r2, #0
	add	r1, sp, #44
	mov	r0, r8
	bl	log2phys
	ldr	r3, .L1637
	ldr	r1, [r3]
	ldr	r3, [sp, #44]
	add	r1, r1, r7
	ldr	r2, [r1, #4]
	cmp	r2, r3
	bne	.L1576
	ldr	r2, .L1637+12
	mov	r10, #20
	ldr	r8, .L1637+36
	ldr	r1, [r1, #16]
	ldrh	r3, [r2]
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1637+16
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
	ldr	r2, .L1637
	adds	r3, r3, #1
	ldr	r0, [r2]
	add	r0, r0, r7
	ldr	r7, .L1637+20
	ldr	r2, [r0, #8]
	str	r2, [r10, #8]
	ldr	r2, [r0, #12]
	str	r2, [r10, #12]
	ldr	r2, [sp, #44]
	str	r2, [r1, #12]
	ldrh	r2, [r7]
	strh	r2, [r1, #2]	@ movhi
	ldr	r2, .L1637+24
	str	r3, [r8]
	ldr	r2, [r2]
	str	r2, [r1, #4]
	movs	r1, #1
	bl	FtlGcBufAlloc
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldr	r3, [r8]
	cmp	r2, r3
	beq	.L1578
	ldrh	r3, [r7, #4]
	cbnz	r3, .L1576
.L1578:
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L1576
.L1632:
	ldr	r3, .L1637+28
	movs	r2, #0
	str	r2, [r3]
	b	.L1631
.L1576:
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	b	.L1628
.L1580:
	ldrh	r3, [r6, #2]
	add	r4, r4, r3
	ldr	r3, [sp, #28]
	uxth	r4, r4
	cmp	r3, r4
	strh	r4, [r6, #2]	@ movhi
	bls	.L1582
	ldr	r3, .L1637+12
	ldrh	r2, [r3]
	ldr	r3, .L1637+32
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1583
.L1582:
	ldr	r3, .L1637+36
	ldr	r3, [r3]
	cbz	r3, .L1584
	bl	Ftl_gc_temp_data_write_back
	cmp	r0, #0
	bne	.L1632
.L1584:
	ldr	r3, .L1637+12
	ldrh	r1, [r3]
	cbnz	r1, .L1585
	ldr	r3, .L1637+40
	ldrh	r2, [r6]
	ldr	r3, [r3]
	ldrh	r0, [r3, r2, lsl #1]
	cbz	r0, .L1585
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r6]
	bl	update_vpc_list
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1585:
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
.L1583:
	ldr	r3, .L1637+44
	ldrh	r3, [r3]
	cmp	r3, #2
	bhi	.L1586
	ldr	r3, .L1637+48
	ldrh	r4, [r3]
	b	.L1558
.L1586:
	ldr	r2, .L1637+28
	movs	r1, #0
	str	r1, [r2]
	ldr	r2, .L1637+52
	ldrh	r0, [r2]
	cmp	r0, #0
	bne	.L1515
	adds	r0, r3, #1
	b	.L1515
.L1590:
	movs	r0, #0
	b	.L1515
.L1521:
	cmp	r7, #0
	beq	.L1588
.L1531:
	ldr	r3, .L1637+20
	ldrh	r2, [r3]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1599
.L1589:
	ldr	r3, .L1637+56
	movw	r2, #65535
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L1599
	cmp	r5, r3
	bne	.L1599
	ldrh	r3, [r6]
	cmp	r3, r5
	beq	.L1543
.L1548:
	movw	r5, #65535
.L1599:
	movs	r4, #1
	b	.L1542
.L1523:
	cmp	r7, #0
	beq	.L1588
	movw	r5, #65535
	b	.L1589
.L1522:
	cmp	r7, #0
	bne	.L1548
	b	.L1588
.L1638:
	.align	2
.L1637:
	.word	.LANCHOR93
	.word	.LANCHOR175
	.word	.LC1
	.word	.LANCHOR173
	.word	.LANCHOR121
	.word	.LANCHOR53
	.word	.LANCHOR71
	.word	.LANCHOR117
	.word	.LANCHOR174
	.word	.LANCHOR89
	.word	.LANCHOR42
	.word	.LANCHOR48
	.word	.LANCHOR19
	.word	.LANCHOR172
	.word	.LANCHOR99
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
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
	str	r2, [sp, #32]
	bne	.L1641
	mov	r2, r3
	ldr	r1, [sp, #32]
	add	r0, r6, #256
	bl	FtlVendorPartRead
	str	r0, [sp, #4]
.L1640:
	ldr	r0, [sp, #4]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1641:
	ldr	r3, [sp, #32]
	adds	r3, r1, r3
	str	r3, [sp, #12]
	ldr	r3, .L1672
	ldr	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L1661
	ldr	r3, .L1672+4
	ldr	r3, [r3]
	adds	r0, r3, #1
	beq	.L1662
	ldr	r3, .L1672+8
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
	ldr	r2, .L1672+12
	ldr	r4, [sp, #16]
	rsb	r3, r3, #1
	str	r0, [sp, #20]
	add	r3, r3, r0
	str	r7, [sp, #28]
	str	r3, [sp, #8]
	ldr	r1, [sp, #8]
	ldr	r3, [r2]
	str	r7, [sp, #24]
	str	r7, [sp, #4]
	add	r3, r3, r1
	str	r3, [r2]
.L1643:
	ldr	r3, [sp, #8]
	cbnz	r3, .L1659
	ldr	r3, .L1672+16
	ldrh	r3, [r3]
	cbnz	r3, .L1660
	ldr	r3, .L1672+20
	ldrh	r3, [r3]
	cmp	r3, #31
	bhi	.L1640
.L1660:
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	b	.L1640
.L1659:
	add	r1, sp, #52
	movs	r2, #0
	mov	r0, r4
	bl	log2phys
	ldr	r3, [sp, #52]
	adds	r1, r3, #1
	bne	.L1644
	ldr	fp, .L1672+8
	mov	r10, #0
.L1645:
	ldrh	r0, [fp]
	cmp	r10, r0
	bcc	.L1647
.L1648:
	ldr	r3, [sp, #8]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #8]
	beq	.L1652
	ldr	r3, .L1672+24
	ldrh	r3, [r3]
	cmp	r5, r3, lsl #2
	bne	.L1643
.L1652:
	cmp	r5, #0
	beq	.L1643
	ldr	r3, .L1672+28
	movs	r2, #0
	mov	r1, r5
	mov	r10, #0
	ldr	r0, [r3]
	bl	FlashReadPages
	lsls	r3, r7, #9
	str	r3, [sp, #44]
	ldr	r3, [sp, #24]
	lsls	r3, r3, #9
	str	r3, [sp, #36]
	ldr	r3, [sp, #28]
	lsls	r3, r3, #9
	str	r3, [sp, #40]
.L1658:
	movs	r3, #20
	mul	fp, r3, r10
	ldr	r3, .L1672+28
	ldr	r2, [r3]
	ldr	r3, [sp, #16]
	add	r2, r2, fp
	ldr	r1, [r2, #16]
	cmp	r3, r1
	bne	.L1654
	ldr	r1, [r2, #8]
	ldr	r2, .L1672+32
	ldr	r2, [r2]
	cmp	r1, r2
	bne	.L1655
	ldr	r3, [sp, #36]
	mov	r0, r8
	ldr	r2, [sp, #40]
	add	r1, r1, r3
.L1671:
	bl	ftl_memcpy
.L1655:
	ldr	r3, .L1672+28
	ldr	r2, [r3]
	ldr	r3, [r2, fp]
	add	r1, r2, fp
	adds	r2, r3, #1
	bne	.L1656
	ldr	r1, .L1672+36
	str	r3, [sp, #4]
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L1657:
	add	r10, r10, #1
	cmp	r5, r10
	bne	.L1658
	movs	r5, #0
	b	.L1643
.L1647:
	mla	r0, r0, r4, r10
	cmp	r6, r0
	bhi	.L1646
	ldr	r3, [sp, #12]
	cmp	r3, r0
	bls	.L1646
	subs	r0, r0, r6
	mov	r2, #512
	movs	r1, #0
	add	r0, r8, r0, lsl #9
	bl	ftl_memset
.L1646:
	add	r10, r10, #1
	b	.L1645
.L1644:
	ldr	r2, .L1672+28
	mov	r10, #20
	ldr	r2, [r2]
	mla	r10, r10, r5, r2
	str	r3, [r10, #4]
	ldr	r3, [sp, #16]
	cmp	r4, r3
	ldr	r3, .L1672+8
	bne	.L1649
	ldr	r2, .L1672+32
	mov	r0, r6
	ldrh	fp, [r3]
	ldr	r2, [r2]
	mov	r1, fp
	str	r2, [r10, #8]
	bl	__aeabi_uidivmod
	ldr	r2, [sp, #32]
	sub	r3, fp, r1
	str	r1, [sp, #24]
	cmp	r3, r2
	it	cs
	movcs	r3, r2
	cmp	fp, r3
	str	r3, [sp, #28]
	bne	.L1650
	str	r8, [r10, #8]
.L1650:
	ldr	r3, .L1672+40
	ldr	r2, .L1672+44
	str	r4, [r10, #16]
	ldrh	r3, [r3]
	ldr	r2, [r2]
	muls	r3, r5, r3
	adds	r5, r5, #1
	bic	r3, r3, #3
	add	r3, r3, r2
	str	r3, [r10, #12]
	b	.L1648
.L1649:
	ldr	r2, [sp, #20]
	cmp	r4, r2
	bne	.L1651
	ldr	r2, .L1672+48
	ldr	r1, [sp, #12]
	ldr	r2, [r2]
	str	r2, [r10, #8]
	ldrh	r2, [r3]
	mul	r3, r2, r4
	subs	r7, r1, r3
	cmp	r2, r7
	bne	.L1650
.L1670:
	subs	r3, r3, r6
	add	r3, r8, r3, lsl #9
	str	r3, [r10, #8]
	b	.L1650
.L1651:
	ldrh	r3, [r3]
	muls	r3, r4, r3
	b	.L1670
.L1654:
	ldr	r3, [sp, #20]
	cmp	r3, r1
	bne	.L1655
	ldr	r3, .L1672+48
	ldr	r1, [r2, #8]
	ldr	r2, [r3]
	cmp	r1, r2
	bne	.L1655
	ldr	r2, .L1672+8
	ldr	r3, [sp, #20]
	ldrh	r0, [r2]
	ldr	r2, [sp, #44]
	muls	r0, r3, r0
	subs	r0, r0, r6
	add	r0, r8, r0, lsl #9
	b	.L1671
.L1656:
	cmp	r3, #256
	bne	.L1657
	ldr	r0, [r1, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	b	.L1657
.L1661:
	mov	r3, #-1
.L1662:
	str	r3, [sp, #4]
	b	.L1640
.L1673:
	.align	2
.L1672:
	.word	.LANCHOR34
	.word	.LANCHOR86
	.word	.LANCHOR12
	.word	.LANCHOR62
	.word	.LANCHOR101
	.word	.LANCHOR48
	.word	.LANCHOR3
	.word	.LANCHOR120
	.word	.LANCHOR115
	.word	.LANCHOR81
	.word	.LANCHOR24
	.word	.LANCHOR114
	.word	.LANCHOR113
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
	bne	.L1676
	mov	r2, r3
	ldr	r3, [sp, #4]
	ldr	r1, [sp, #20]
	add	r0, r3, #256
	bl	FtlVendorPartWrite
.L1675:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1676:
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #20]
	adds	r4, r3, r2
	ldr	r3, .L1726
	ldr	r3, [r3]
	cmp	r4, r3
	bhi	.L1712
	ldr	r3, .L1726+4
	ldr	r0, [r3]
	adds	r5, r0, #1
	beq	.L1675
	ldr	r3, .L1726+8
	mov	r2, #2048
	ldr	r0, [sp, #4]
	str	r2, [r3]
	ldr	r3, .L1726+12
	ldrh	r5, [r3]
	mov	r1, r5
	bl	__aeabi_uidiv
	mov	r1, r5
	str	r0, [sp, #12]
	subs	r0, r4, #1
	ldr	r5, .L1726+16
	bl	__aeabi_uidiv
	ldr	r2, [sp, #12]
	str	r0, [sp, #28]
	subs	r3, r0, r2
	ldr	r2, .L1726+20
	str	r3, [sp, #32]
	adds	r3, r3, #1
	str	r3, [sp, #8]
	ldr	r1, [sp, #8]
	ldr	r3, [r2]
	add	r3, r3, r1
	str	r3, [r2]
	ldr	r3, .L1726+24
	ldr	r3, [r3]
	cbz	r3, .L1678
	ldrh	r2, [r5, #4]
	ldr	r3, .L1726+28
	cmp	r2, #0
	it	eq
	moveq	r5, r3
.L1678:
	ldr	r6, [sp, #12]
.L1679:
	ldr	r3, [sp, #8]
	cbnz	r3, .L1708
	ldr	r4, .L1726+32
	mov	r0, r3
	ldr	r1, [sp, #32]
	bl	rk_ftl_garbage_collect
	ldrh	r2, [r4]
	cmp	r2, #15
	bls	.L1709
.L1711:
	movs	r0, #0
	b	.L1675
.L1708:
	ldr	r3, .L1726+36
	ldrb	r2, [r5, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1680
	mov	r2, #988
	ldr	r1, .L1726+40
	ldr	r0, .L1726+44
	bl	printf
.L1680:
	ldrh	r2, [r5, #4]
	cbnz	r2, .L1681
	ldr	r3, .L1726+16
	ldr	r4, .L1726+24
	cmp	r5, r3
	bne	.L1682
	ldr	r0, .L1726+28
	ldrh	r5, [r0, #4]
	cbnz	r5, .L1683
	bl	allocate_new_data_superblock
	str	r5, [r4]
.L1683:
	ldr	r0, .L1726+16
	bl	allocate_new_data_superblock
	ldr	r5, .L1726+16
	ldr	r2, [r4]
	ldr	r3, .L1726+28
	cmp	r2, #0
	it	ne
	movne	r5, r3
.L1684:
	ldrh	r3, [r5, #4]
	cbnz	r3, .L1681
	mov	r0, r5
	bl	allocate_new_data_superblock
.L1681:
	ldrb	r2, [r5, #7]	@ zero_extendqisi2
	ldrh	r3, [r5, #4]
	ldr	r1, [sp, #8]
	lsls	r2, r2, #2
	cmp	r3, r1
	it	cs
	movcs	r3, r1
	cmp	r2, r3
	it	cs
	movcs	r2, r3
	ldr	r3, .L1726+36
	str	r2, [sp, #44]
	ldrb	r2, [r5, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1685
	movw	r2, #1021
	ldr	r1, .L1726+40
	ldr	r0, .L1726+44
	bl	printf
.L1685:
	ldr	r8, .L1726+48
	mov	fp, #0
.L1686:
	ldr	r3, [sp, #44]
	cmp	fp, r3
	bne	.L1706
.L1687:
	ldr	r0, .L1726+48
	mov	r3, r5
	movs	r2, #0
	mov	r1, fp
	ldr	r0, [r0]
	bl	FtlProgPages
	ldr	r3, [sp, #8]
	cmp	fp, r3
	bls	.L1707
	movw	r2, #1098
	ldr	r1, .L1726+40
	ldr	r0, .L1726+44
	bl	printf
.L1707:
	ldr	r3, [sp, #8]
	sub	r3, r3, fp
	str	r3, [sp, #8]
	b	.L1679
.L1682:
	str	r2, [r4]
	ldrh	r2, [r3, #4]
	cbnz	r2, .L1717
	mov	r0, r5
	bl	allocate_new_data_superblock
	b	.L1684
.L1717:
	mov	r5, r3
	b	.L1681
.L1706:
	ldrh	r2, [r5, #4]
	cmp	r2, #0
	beq	.L1687
	movs	r2, #0
	add	r1, sp, #48
	mov	r0, r6
	movs	r7, #20
	bl	log2phys
	mov	r0, r5
	mul	r7, r7, fp
	bl	get_new_active_ppa
	ldr	r3, .L1726+52
	ldr	r1, [r8]
	ldrh	r2, [r3]
	add	r1, r1, r7
	str	r0, [r1, #4]
	str	r6, [r1, #16]
	mul	r0, r2, fp
	bic	r3, r0, #3
	ldr	r0, .L1726+56
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
	ldr	r2, .L1726+12
	cmp	r6, r3
	beq	.L1688
	ldr	r3, [sp, #28]
	cmp	r6, r3
	bne	.L1721
	ldrh	r2, [r2]
	ldr	r3, [sp, #4]
	ldr	r1, [sp, #20]
	smulbb	r2, r2, r6
	adds	r4, r3, r1
	movs	r3, #0
	subs	r4, r4, r2
	str	r3, [sp, #24]
	uxth	r4, r4
	b	.L1691
.L1688:
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
.L1691:
	ldr	r2, .L1726+12
	ldr	r3, [sp, #12]
	ldrh	r2, [r2]
	cmp	r4, r2
	ldr	r2, [r8]
	bne	.L1692
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
.L1694:
	ldr	r3, .L1726+36
	ldrb	r1, [r5, #6]	@ zero_extendqisi2
	ldrh	r2, [r3]
	cmp	r1, r2
	bcc	.L1703
	movw	r2, #1089
	ldr	r1, .L1726+40
	ldr	r0, .L1726+44
	bl	printf
.L1703:
	ldr	r3, [sp, #40]
	movw	r2, #61589
	ldr	r1, [sp, #36]
	add	fp, fp, #1
	strh	r2, [r3, r1]	@ movhi
	ldr	r1, .L1726+60
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
	b	.L1686
.L1727:
	.align	2
.L1726:
	.word	.LANCHOR34
	.word	.LANCHOR86
	.word	.LANCHOR176
	.word	.LANCHOR12
	.word	.LANCHOR51
	.word	.LANCHOR64
	.word	.LANCHOR177
	.word	.LANCHOR52
	.word	.LANCHOR48
	.word	.LANCHOR3
	.word	.LANCHOR178
	.word	.LC1
	.word	.LANCHOR122
	.word	.LANCHOR24
	.word	.LANCHOR114
	.word	.LANCHOR71
.L1692:
	cmp	r6, r3
	add	r2, r2, r7
	ite	eq
	ldreq	r1, .L1728
	ldrne	r1, .L1728+4
	ldr	r1, [r1]
	str	r1, [r2, #8]
	ldr	r2, [sp, #48]
	adds	r1, r2, #1
	beq	.L1697
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
	bne	.L1698
	ldr	r1, .L1728+8
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L1701:
	ldr	r3, [sp, #12]
	lsls	r2, r4, #9
	cmp	r6, r3
	bne	.L1702
	ldr	r1, [r8]
	ldr	r3, [sp, #24]
	add	r7, r7, r1
	ldr	r1, [sp, #16]
	ldr	r0, [r7, #8]
	add	r0, r0, r3, lsl #9
.L1724:
	bl	ftl_memcpy
	b	.L1694
.L1698:
	ldr	r1, [r10, #8]
	cmp	r6, r1
	beq	.L1700
	ldr	r0, .L1728+8
	ldr	r2, [r0, #72]
	adds	r2, r2, #1
	str	r2, [r0, #72]
	mov	r2, r6
	ldr	r0, .L1728+12
	bl	printf
.L1700:
	ldr	r2, [r10, #8]
	cmp	r6, r2
	beq	.L1701
	movw	r2, #1074
	ldr	r1, .L1728+16
	ldr	r0, .L1728+20
	bl	printf
	b	.L1701
.L1697:
	ldr	r2, [r8]
	movs	r1, #0
	adds	r0, r2, r7
	ldr	r2, .L1728+24
	ldr	r0, [r0, #8]
	ldrh	r2, [r2]
	bl	ftl_memset
	b	.L1701
.L1702:
	ldr	r1, .L1728+28
	ldr	r3, [sp, #4]
	ldr	r0, [r8]
	ldrh	r1, [r1]
	add	r7, r7, r0
	ldr	r0, [r7, #8]
	muls	r1, r6, r1
	subs	r1, r1, r3
	ldr	r3, [sp, #16]
	add	r1, r3, r1, lsl #9
	b	.L1724
.L1721:
	ldrh	r2, [r2]
	ldr	r3, [sp, #4]
	ldr	r1, [r8]
	muls	r2, r6, r2
	add	r7, r7, r1
	subs	r2, r2, r3
	ldr	r3, [sp, #16]
	add	r2, r3, r2, lsl #9
	str	r2, [r7, #8]
	b	.L1694
.L1709:
	ldr	r5, .L1728+32
	ldr	r6, .L1728+36
.L1722:
	ldrh	r3, [r5]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L1710
	ldrh	r2, [r6]
	cmp	r2, r3
	bne	.L1710
	movs	r0, #0
	bl	List_get_gc_head_node
	uxth	r0, r0
	bl	FtlGcRefreshBlock
.L1710:
	ldr	r2, .L1728+40
	movs	r3, #128
	movs	r1, #1
	mov	r0, r1
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1728+44
	strh	r3, [r2]	@ movhi
	bl	rk_ftl_garbage_collect
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	ldrh	r3, [r4]
	cmp	r3, #8
	bls	.L1722
	b	.L1711
.L1712:
	mov	r0, #-1
	b	.L1675
.L1729:
	.align	2
.L1728:
	.word	.LANCHOR115
	.word	.LANCHOR113
	.word	.LANCHOR81
	.word	.LC108
	.word	.LANCHOR178
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
	@ args = 0, pretend = 0, frame = 112
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	adds	r4, r0, r1
	subs	r5, r4, #1
	sub	sp, sp, #120
	cmp	r5, #63
	str	r0, [sp, #8]
	str	r1, [sp, #16]
	str	r2, [sp, #36]
	ldr	r6, .L1762
	bls	.L1731
	cmp	r0, #576
	bls	.L1732
.L1731:
	ldr	r3, [r6]
	cmp	r3, #0
	beq	.L1733
	ldr	r2, .L1762+4
	mov	r0, #512
	ldrh	r3, [r2, #14]
	str	r3, [sp, #20]
	ldrh	r3, [r2, #10]
	ldrb	r1, [sp, #20]	@ zero_extendqisi2
	smulbb	r3, r3, r1
	uxth	r3, r3
	mov	r1, r3
	str	r3, [sp, #24]
	bl	__aeabi_uidiv
	ldr	r2, .L1762+8
	movs	r3, #0
	ldr	r1, .L1762+12
	str	r0, [sp, #12]
	sub	r4, r2, #262144
.L1737:
	ldr	r0, [r2, #-4]
	cmp	r0, #0
	beq	.L1734
.L1738:
	ldr	r3, [sp, #12]
	movs	r4, #0
	ldr	r2, [sp, #24]
	ldr	r6, .L1762+16
	str	r4, [sp, #28]
	muls	r3, r2, r3
	str	r3, [sp, #48]
	ldr	r3, [sp, #12]
	str	r3, [sp, #32]
.L1735:
	mov	r2, #512
	movs	r1, #0
	ldr	r0, .L1762+20
	bl	memset
	ldr	r3, .L1762+4
	mov	r0, r4
	ldrh	r7, [r3, #14]
	mov	r1, r7
	uxtb	r8, r7
	uxth	r3, r8
	str	r3, [sp, #40]
	ldr	r3, .L1762+4
	ldrh	r5, [r3, #10]
	ldrh	r3, [sp, #40]
	smulbb	r5, r5, r3
	bl	__aeabi_uidiv
	uxth	r5, r5
	mov	r1, r0
	ldr	r3, [r6, #4]
	movs	r0, #0
	blx	r3
	cmp	r5, #512
	bcs	.L1739
	mov	r1, r7
	adds	r0, r5, r4
	bl	__aeabi_uidiv
	ldr	r3, [r6, #4]
	mov	r1, r0
	movs	r0, #0
	blx	r3
.L1739:
	mov	r1, r5
	mov	r0, r4
	bl	__aeabi_uidivmod
	movs	r5, #0
	mov	r10, r1
	subs	r3, r4, r1
	str	r3, [sp, #44]
.L1740:
	cmp	r5, #512
	bcc	.L1741
	ldr	r3, .L1762+4
	mov	r0, r4
	movs	r5, #0
	ldrb	r8, [r3, #14]	@ zero_extendqisi2
	uxth	r3, r8
	str	r3, [sp, #40]
	ldr	r3, .L1762+4
	ldrh	r1, [r3, #10]
	ldrh	r3, [sp, #40]
	smulbb	r1, r1, r3
	uxth	r1, r1
	bl	__aeabi_uidivmod
	mov	fp, r1
	subs	r3, r4, r1
	uxth	r0, fp
	mov	r1, r8
	str	r3, [sp, #44]
	bl	__aeabi_idivmod
	uxth	r7, r1
.L1742:
	cmp	r5, #512
	bcs	.L1746
	ldr	r3, [sp, #40]
	mov	r1, r8
	add	r0, fp, r5
	sub	r10, r3, r7
	ldr	r3, .L1762+20
	uxth	r10, r10
	add	r2, r3, r5, lsl #9
	str	r2, [sp, #52]
	bl	__aeabi_uidiv
	ldr	r3, [sp, #44]
	uxth	r0, r0
	mov	r1, r8
	add	r7, r7, r3
	mla	r0, r8, r0, r7
	bl	__aeabi_uidiv
	ldr	r7, [r6, #12]
	mov	r1, r0
	add	r3, sp, #56
	ldr	r2, [sp, #52]
	movs	r0, #0
	blx	r7
	adds	r0, r0, #1
	bne	.L1743
.L1746:
	ldr	r3, .L1762+24
	movs	r5, #0
.L1744:
	ldr	r2, .L1762+20
	mov	r7, r3
	adds	r3, r3, #4
	ldr	r1, [r2, r5, lsl #2]
	ldr	r2, [r7]
	cmp	r1, r2
	beq	.L1747
	mov	r2, #512
	movs	r1, #0
	ldr	r0, .L1762+20
	bl	memset
	ldr	r2, .L1762+20
	mov	r1, r4
	str	r5, [sp]
	ldr	r3, [r7]
	ldr	r2, [r2, r5, lsl #2]
	ldr	r0, .L1762+28
	bl	printf
	ldr	r1, [sp, #20]
	mov	r0, r4
	bl	__aeabi_uidiv
	ldr	r3, [r6, #4]
	mov	r1, r0
	movs	r0, #0
	blx	r3
	ldr	r3, [sp, #12]
	cmp	r3, #1
	bls	.L1748
	ldr	r3, [sp, #24]
	ldr	r1, [sp, #20]
	adds	r0, r3, r4
	bl	__aeabi_uidiv
	ldr	r3, [r6, #4]
	mov	r1, r0
	movs	r0, #0
	blx	r3
.L1748:
	ldr	r2, [sp, #32]
	ldr	r3, [sp, #12]
	add	r3, r3, r2
	ldr	r2, [sp, #48]
	add	r4, r4, r2
	ldr	r2, [sp, #32]
	cmp	r2, #15
	bls	.L1754
.L1753:
	ldr	r3, .L1762
	movs	r2, #0
	str	r2, [r3]
.L1733:
	ldr	r3, [sp, #36]
	movs	r0, #0
	ldr	r2, [sp, #16]
	ldr	r1, [sp, #8]
	bl	FtlWrite
	add	sp, sp, #120
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1734:
	ldr	r0, [r4, r3, lsl #2]
	adds	r3, r3, #1
	cmp	r3, #4096
	it	hi
	movhi	r3, #0
	str	r0, [r2, #-4]!
	cmp	r1, r2
	bne	.L1737
	b	.L1738
.L1754:
	str	r3, [sp, #32]
	b	.L1735
.L1741:
	mov	r1, r8
	add	r0, r10, r5
	bl	__aeabi_uidiv
	uxth	fp, r0
	mov	r1, r8
	ldr	r0, [sp, #44]
	mul	r3, r8, fp
	str	r3, [sp, #56]
	movw	r3, #61424
	str	r3, [sp, #60]
	ldr	r3, .L1762+24
	add	r2, r3, r5, lsl #9
	str	r2, [sp, #52]
	bl	__aeabi_uidiv
	add	r3, sp, #56
	add	r1, r0, fp
	ldr	r2, [sp, #52]
	movs	r0, #0
	ldr	r7, [r6, #8]
	blx	r7
	ldr	r3, [sp, #40]
	add	r5, r5, r3
	uxth	r5, r5
	b	.L1740
.L1743:
	add	r5, r5, r10
	movs	r7, #0
	uxth	r5, r5
	b	.L1742
.L1747:
	adds	r5, r5, #1
	cmp	r5, #65536
	bne	.L1744
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	cmp	r3, #5
	str	r3, [sp, #28]
	bls	.L1748
	b	.L1753
.L1732:
	ldr	r3, [sp, #8]
	ldr	r0, .L1762+24
	cmp	r3, #63
	bhi	.L1750
	rsb	r1, r3, #64
	ldr	r3, [sp, #16]
	subs	r2, r3, r1
	ldr	r3, [sp, #36]
	add	r1, r3, r1, lsl #9
.L1751:
	movs	r3, #1
	cmp	r5, #576
	str	r3, [r6]
	ittt	hi
	subhi	r2, r2, r4
	mvnhi	r3, #446
	addhi	r2, r2, r3
	lsls	r2, r2, #9
	bl	memcpy
	b	.L1733
.L1750:
	ldr	r2, [sp, #8]
	ldr	r3, .L1762+32
	ldr	r1, [sp, #36]
	add	r3, r3, r2
	ldr	r2, [sp, #16]
	add	r0, r0, r3, lsl #9
	b	.L1751
.L1763:
	.align	2
.L1762:
	.word	.LANCHOR179
	.word	.LANCHOR0
	.word	idb_buf+262144
	.word	idb_buf+16388
	.word	.LANCHOR105
	.word	gp_flash_check_buf
	.word	idb_buf
	.word	.LC109
	.word	8388544
	.size	sftl_write, .-sftl_write
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
	ldr	r8, .L1785+136
	ldr	r5, .L1785
	ldr	r3, [r8]
	ldr	r4, .L1785+4
	ldr	r10, .L1785+140
	ldrh	r2, [r5]
	ldr	r7, .L1785+8
	str	r3, [r4, #8]
	ldr	r6, .L1785+12
	ldr	r3, [r10]
	lsls	r2, r2, #1
	ldr	r0, [r7]
	str	r3, [r4, #12]
	bl	ftl_memset
	ldrh	r0, [r6]
	movw	r3, #65535
	str	r7, [sp]
	cmp	r0, r3
	bne	.L1765
.L1773:
	mov	r0, #-1
.L1764:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1765:
	movs	r1, #1
	mov	fp, r4
	bl	FtlGetLastWrittenPage
	ldr	r3, .L1785+16
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r6, #2]	@ movhi
.L1767:
	cmp	r7, #0
	bge	.L1770
	movw	r2, #1437
	ldr	r1, .L1785+20
	ldr	r0, .L1785+24
	bl	printf
.L1769:
	ldr	r2, .L1785+28
	ldrh	r3, [r5]
	ldrh	r2, [r2]
	adds	r3, r3, #24
	cmp	r2, r3, lsl #1
	bcs	.L1772
	movw	r2, #1439
	ldr	r1, .L1785+20
	ldr	r0, .L1785+24
	bl	printf
.L1772:
	ldr	r7, .L1785+32
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
	ldr	r3, .L1785+36
	ldr	r0, [r3]
	bl	ftl_memcpy
	ldr	r2, [r7]
	ldr	r3, .L1785+16
	cmp	r2, r3
	bne	.L1773
	ldr	r3, .L1785+40
	ldrb	r2, [r7, #10]	@ zero_extendqisi2
	ldrh	r5, [r7, #8]
	ldrh	r3, [r3]
	strh	r5, [r6, #6]	@ movhi
	cmp	r2, r3
	bne	.L1773
	ldr	r3, .L1785+44
	ldr	r2, .L1785+48
	str	r5, [r3]
	ldr	r3, .L1785+52
	ldrh	r3, [r3]
	muls	r3, r5, r3
	str	r3, [r2]
	ldr	r2, .L1785+56
	ldrh	r2, [r2]
	muls	r3, r2, r3
	ldr	r2, .L1785+60
	str	r3, [r2]
	ldr	r3, .L1785+64
	ldr	r6, [r3]
	ldr	r3, .L1785+68
	ldrh	r0, [r3, #6]
	ldr	r3, .L1785+72
	subs	r0, r6, r0
	ldrh	r1, [r3]
	subs	r0, r0, r5
	bl	__aeabi_uidiv
	ldr	r3, .L1785+76
	cmp	r5, r6
	strh	r0, [r3]	@ movhi
	bls	.L1774
	movw	r2, #1461
	ldr	r1, .L1785+20
	ldr	r0, .L1785+24
	bl	printf
.L1774:
	ldrh	r2, [r4, #16]
	ldr	r3, .L1785+80
	ldrh	ip, [r4, #14]
	ldr	r7, .L1785+84
	lsrs	r1, r2, #6
	and	r2, r2, #63
	strb	r2, [r3, #6]
	ldrb	r2, [r4, #11]	@ zero_extendqisi2
	strh	r1, [r3, #2]	@ movhi
	ldr	r1, .L1785+88
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
	ldr	r2, .L1785+92
	strh	r5, [r2]	@ movhi
	ldrh	r5, [r4, #24]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r2, #6]
	ldrb	r5, [r4, #13]	@ zero_extendqisi2
	strh	r6, [r2, #2]	@ movhi
	ldr	r6, [r4, #32]
	strb	r5, [r2, #8]
	ldr	r5, .L1785+96
	str	r3, [r5]
	ldr	r5, .L1785+100
	str	r3, [r5]
	ldr	r5, .L1785+104
	str	r3, [r5]
	ldr	r5, .L1785+108
	str	r3, [r5]
	ldr	r5, .L1785+112
	str	r6, [r5]
	mov	r6, r1
	ldr	r5, .L1785+116
	str	r3, [r5]
	ldr	r5, .L1785+120
	str	r3, [r5]
	ldr	r5, .L1785+124
	ldr	lr, [r4, #40]
	str	r3, [r5]
	ldr	r3, .L1785+128
	ldr	r5, [r3]
	cmp	lr, r5
	mov	r5, r2
	it	hi
	strhi	lr, [r3]
	ldr	r3, .L1785+132
	ldr	r2, [r4, #36]
	ldr	r1, [r3]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3]
	movw	r3, #65535
	cmp	ip, r3
	beq	.L1777
	ldr	r0, .L1785+80
	bl	make_superblock
.L1777:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1778
	ldr	r0, .L1785+88
	bl	make_superblock
.L1778:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1779
	ldr	r0, .L1785+92
	bl	make_superblock
.L1779:
	ldrh	r2, [r7]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1780
	ldr	r0, .L1785+84
	bl	make_superblock
.L1780:
	movs	r0, #0
	b	.L1764
.L1770:
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
	beq	.L1768
	ldr	r2, [r8]
	ldr	r2, [r2]
	cmp	r2, r3
	bne	.L1768
	ldr	r2, [r10]
	ldrh	r1, [r2]
	movw	r2, #61604
	cmp	r1, r2
	beq	.L1769
.L1768:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L1767
.L1786:
	.align	2
.L1785:
	.word	.LANCHOR5
	.word	.LANCHOR106
	.word	.LANCHOR42
	.word	.LANCHOR79
	.word	1179929683
	.word	.LANCHOR180
	.word	.LC1
	.word	.LANCHOR23
	.word	.LANCHOR39
	.word	.LANCHOR1
	.word	.LANCHOR10
	.word	.LANCHOR181
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
	.word	.LANCHOR107
	.word	.LANCHOR108
	.size	FtlLoadSysInfo, .-FtlLoadSysInfo
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
	ldr	r6, .L1802
	strh	r3, [r6]	@ movhi
	ldr	r3, .L1802+4
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	ldr	r3, .L1802+8
	ldrh	r2, [r3]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1788
.L1790:
	mov	r7, #-1
.L1787:
	mov	r0, r7
	pop	{r3, r4, r5, r6, r7, pc}
.L1788:
	bl	FtlLoadSysInfo
	mov	r7, r0
	cmp	r0, #0
	bne	.L1790
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	movs	r0, #1
	bl	FtlUpdateVaildLpn
	ldr	r3, .L1802+12
	movs	r0, #12
	ldrh	r1, [r3]
	ldr	r3, .L1802+16
	ldr	r2, [r3]
	mov	r3, r7
.L1791:
	cmp	r3, r1
	bge	.L1796
	mla	r4, r0, r3, r2
	ldr	r4, [r4, #4]
	cmp	r4, #0
	bge	.L1792
.L1796:
	ldr	r4, .L1802+20
	cmp	r3, r1
	ldr	r5, .L1802+24
	ldrh	r2, [r4, #28]
	add	r2, r2, #1
	strh	r2, [r4, #28]	@ movhi
	bge	.L1800
.L1793:
	ldr	r6, .L1802+28
	ldr	r0, .L1802+24
	bl	FtlSuperblockPowerLostFix
	mov	r0, r6
	bl	FtlSuperblockPowerLostFix
	ldr	r3, .L1802+32
	ldrh	r1, [r5]
	ldrh	r0, [r5, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	ldr	r0, .L1802+36
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldrh	ip, [r6]
	ldrh	r3, [r0]
	ldrh	lr, [r6, #4]
	strh	r3, [r5, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r5, #6]
	strh	r3, [r5, #4]	@ movhi
	ldrh	r1, [r2, ip, lsl #1]
	sub	r1, r1, lr
	strh	r1, [r2, ip, lsl #1]	@ movhi
	ldrh	r2, [r0]
	ldr	r0, .L1802+40
	strb	r3, [r6, #6]
	strh	r2, [r6, #2]	@ movhi
	strh	r3, [r6, #4]	@ movhi
	bl	FtlMapBlkWriteDump_data
	ldr	r0, .L1802+44
	bl	FtlMapBlkWriteDump_data
	ldrh	r3, [r4, #30]
	adds	r3, r3, #1
	strh	r3, [r4, #30]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1801:
	bl	FtlVpcTblFlush
	ldrh	r0, [r5]
	movw	r3, #65535
	cmp	r0, r3
	beq	.L1799
	ldrh	r3, [r5, #4]
	cbnz	r3, .L1799
	ldr	r5, .L1802+28
	ldrh	r3, [r5, #4]
	cbnz	r3, .L1799
	bl	FtlGcRefreshBlock
	ldrh	r0, [r5]
	bl	FtlGcRefreshBlock
	ldr	r0, .L1802+24
	bl	allocate_new_data_superblock
	mov	r0, r5
	bl	allocate_new_data_superblock
.L1799:
	ldrh	r3, [r4, #28]
	lsls	r3, r3, #27
	bne	.L1787
	bl	FtlVpcCheckAndModify
	b	.L1787
.L1792:
	adds	r3, r3, #1
	b	.L1791
.L1800:
	ldrh	r3, [r6]
	cmp	r3, #0
	bne	.L1793
	bl	l2p_flush
	b	.L1801
.L1803:
	.align	2
.L1802:
	.word	.LANCHOR161
	.word	.LANCHOR4
	.word	.LANCHOR79
	.word	.LANCHOR33
	.word	.LANCHOR55
	.word	.LANCHOR39
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR42
	.word	.LANCHOR19
	.word	.LANCHOR144
	.word	.LANCHOR149
	.size	FtlSysBlkInit, .-FtlSysBlkInit
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
	ldr	r6, .L1828
	ldr	r2, .L1828+4
	ldr	r5, .L1828+8
	ldrh	r0, [r6]
	str	r3, [r2]
	str	r3, [r5]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L1805
	bl	FtlMakeBbt
.L1805:
	ldr	r3, .L1828+12
	ldr	r2, .L1828+16
	ldr	ip, .L1828+100
	ldrh	r1, [r3]
	ldr	r4, [r2]
	ldr	r2, .L1828+20
	str	r3, [sp, #4]
	lsls	r1, r1, #7
	ldr	r7, [r2]
	movs	r2, #0
.L1806:
	uxth	r3, r2
	adds	r2, r2, #1
	cmp	r3, r1
	blt	.L1807
	ldr	r3, .L1828+24
	movs	r7, #0
	ldr	r10, .L1828+104
	ldrh	r4, [r3]
	mov	r8, r3
	mov	fp, r10
.L1808:
	ldrh	r3, [r10]
	cmp	r3, r4
	bhi	.L1809
	ldr	r4, .L1828+28
	subs	r3, r7, #2
	ldrh	r1, [r4]
	cmp	r3, r1, lsl #1
	bgt	.L1810
.L1814:
	movs	r6, #0
	mov	r7, r6
.L1811:
	ldrh	r3, [r8]
	uxth	r0, r6
	adds	r6, r6, #1
	cmp	r3, r0
	bhi	.L1815
	ldrh	r2, [fp]
	ldr	r3, .L1828+32
	ldrh	r4, [r4]
	ldr	r6, .L1828+36
	str	r2, [r3]
	ldr	r3, .L1828+40
	mov	r1, r4
	ldr	r2, [r3]
	mov	r0, r2
	str	r2, [sp, #12]
	bl	__aeabi_uidiv
	ubfx	r10, r0, #5, #16
	mov	r3, r0
	str	r0, [r6]
	add	r1, r10, #36
	ldr	r0, .L1828+44
	strh	r1, [r0]	@ movhi
	movs	r1, #24
	muls	r1, r4, r1
	str	r0, [sp]
	cmp	r7, r1
	ble	.L1816
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
.L1816:
	ldr	r2, .L1828+48
	ldrh	r2, [r2]
	cbz	r2, .L1818
	ldr	r1, .L1828+44
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
.L1818:
	ldr	r3, [sp]
	ldr	r7, .L1828+52
	ldr	r10, .L1828+108
	ldrh	r2, [r3]
	ldr	r3, [r6]
	subs	r3, r3, r2
	muls	r4, r3, r4
	ldr	r3, .L1828+56
	ldrh	r3, [r3]
	str	r4, [r7]
	muls	r4, r3, r4
	ldr	r3, [sp, #4]
	ldrh	r3, [r3]
	str	r4, [r6]
	ldr	r6, .L1828+60
	muls	r4, r3, r4
	ldr	r3, .L1828+64
	str	r4, [r3]
	movw	r4, #65535
	bl	FtlBbmTblFlush
	ldrh	r2, [fp]
	movs	r1, #0
	ldr	r0, [r10]
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r2, .L1828+68
	movs	r3, #0
	strh	r3, [r6, #2]	@ movhi
	movs	r1, #255
	strb	r3, [r6, #6]
	str	r3, [r2]
	ldr	r2, .L1828+72
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
	ldr	r3, .L1828+76
	lsrs	r2, r2, #3
	ldr	r0, [r3]
	bl	ftl_memset
.L1820:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r6, #7]	@ zero_extendqisi2
	ldrh	r2, [r6]
	cmp	r3, #0
	bne	.L1821
	ldr	r3, [r8]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r6]
	adds	r3, r3, #1
	strh	r3, [r6]	@ movhi
	b	.L1820
.L1807:
	mvns	r0, r3
	orr	r0, r3, r0, lsl #16
	str	r0, [r4, r3, lsl #2]
	str	ip, [r7, r3, lsl #2]
	b	.L1806
.L1809:
	mov	r0, r4
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r4, r4, #1
	add	r7, r7, r0
	uxth	r7, r7
	uxth	r4, r4
	b	.L1808
.L1810:
	mov	r0, r7
	bl	__aeabi_uidiv
	ldr	r3, .L1828+80
	ldr	r3, [r3]
	add	r0, r0, r3
	uxth	r0, r0
	bl	FtlSysBlkNumInit
	ldrh	r0, [r6]
	bl	FtlFreeSysBlkQueueInit
	ldrh	r6, [r8]
.L1812:
	ldrh	r3, [fp]
	cmp	r3, r6
	bls	.L1814
	mov	r0, r6
	movs	r1, #1
	adds	r6, r6, #1
	bl	FtlLowFormatEraseBlock
	uxth	r6, r6
	b	.L1812
.L1815:
	movs	r1, #0
	bl	FtlLowFormatEraseBlock
	add	r7, r7, r0
	uxth	r7, r7
	b	.L1811
.L1821:
	ldr	r3, [r5]
	ldrh	r1, [r6, #4]
	ldr	r4, .L1828+84
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
.L1822:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r4]
	cbnz	r3, .L1823
	ldr	r3, [r8]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L1822
.L1823:
	ldr	r3, [r5]
	ldrh	r1, [r4, #4]
	str	r3, [r4, #12]
	adds	r3, r3, #1
	str	r3, [r5]
	movw	r4, #65535
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L1828+88
	strh	r4, [r3]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L1828+92
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
	cbnz	r0, .L1824
	ldr	r3, .L1828+96
	movs	r2, #1
	str	r2, [r3]
.L1824:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1829:
	.align	2
.L1828:
	.word	.LANCHOR4
	.word	.LANCHOR71
	.word	.LANCHOR70
	.word	.LANCHOR12
	.word	.LANCHOR115
	.word	.LANCHOR113
	.word	.LANCHOR5
	.word	.LANCHOR3
	.word	.LANCHOR112
	.word	.LANCHOR61
	.word	.LANCHOR7
	.word	.LANCHOR78
	.word	.LANCHOR15
	.word	.LANCHOR181
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
	ldr	r4, .L1836
	ldr	r1, .L1836+4
	ldr	r0, .L1836+8
	str	r3, [r4]
	bl	printf
	ldr	r0, .L1836+12
	bl	FtlConstantsInit
	bl	FtlMemInit
	bl	FtlVariablesInit
	ldr	r3, .L1836+16
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbnz	r0, .L1834
	bl	FtlSysBlkInit
	cbnz	r0, .L1834
	movs	r3, #1
	str	r3, [r4]
	ldr	r3, .L1836+20
	ldrh	r3, [r3]
	cmp	r3, #15
	bhi	.L1834
	movw	r4, #8129
.L1833:
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	subs	r4, r4, #1
	bne	.L1833
.L1834:
	movs	r0, #0
	pop	{r4, pc}
.L1837:
	.align	2
.L1836:
	.word	.LANCHOR86
	.word	.LC70
	.word	.LC71
	.word	.LANCHOR0
	.word	.LANCHOR4
	.word	.LANCHOR48
	.size	sftl_init, .-sftl_init
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
	.global	ftl_temp_buf
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
	.section	.bss.check_buf,"aw",%nobits
	.align	2
	.type	check_buf, %object
	.size	check_buf, 4096
check_buf:
	.space	4096
	.section	.bss.check_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR110,. + 0
	.type	check_spare_buf, %object
	.size	check_spare_buf, 512
check_spare_buf:
	.space	512
	.section	.bss.check_vpc_table,"aw",%nobits
	.align	1
	.type	check_vpc_table, %object
	.size	check_vpc_table, 16384
check_vpc_table:
	.space	16384
	.section	.bss.ftl_gc_temp_power_lost_recovery_flag,"aw",%nobits
	.align	2
	.set	.LANCHOR152,. + 0
	.type	ftl_gc_temp_power_lost_recovery_flag, %object
	.size	ftl_gc_temp_power_lost_recovery_flag, 4
ftl_gc_temp_power_lost_recovery_flag:
	.space	4
	.section	.bss.ftl_temp_buf,"aw",%nobits
	.align	2
	.type	ftl_temp_buf, %object
	.size	ftl_temp_buf, 4096
ftl_temp_buf:
	.space	4096
	.section	.bss.gBbtInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR37,. + 0
	.type	gBbtInfo, %object
	.size	gBbtInfo, 60
gBbtInfo:
	.space	60
	.section	.bss.gL2pMapInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR144,. + 0
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
	.set	.LANCHOR149,. + 0
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
	.set	.LANCHOR181,. + 0
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
	.set	.LANCHOR112,. + 0
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
	.set	.LANCHOR165,. + 0
	.type	g_ect_tbl_power_up_flush, %object
	.size	g_ect_tbl_power_up_flush, 2
g_ect_tbl_power_up_flush:
	.space	2
	.section	.bss.g_ftl_nand_free_count,"aw",%nobits
	.align	2
	.set	.LANCHOR176,. + 0
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
	.set	.LANCHOR174,. + 0
	.type	g_gc_cur_blk_max_valid_pages, %object
	.size	g_gc_cur_blk_max_valid_pages, 2
g_gc_cur_blk_max_valid_pages:
	.space	2
	.section	.bss.g_gc_cur_blk_valid_pages,"aw",%nobits
	.align	1
	.set	.LANCHOR173,. + 0
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
	.set	.LANCHOR118,. + 0
	.type	g_gc_head_data_block, %object
	.size	g_gc_head_data_block, 4
g_gc_head_data_block:
	.space	4
	.section	.bss.g_gc_head_data_block_count,"aw",%nobits
	.align	2
	.set	.LANCHOR119,. + 0
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
	.set	.LANCHOR117,. + 0
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
	.set	.LANCHOR161,. + 0
	.type	g_power_lost_recovery_flag, %object
	.size	g_power_lost_recovery_flag, 2
g_power_lost_recovery_flag:
	.space	2
	.section	.bss.g_recovery_page_min_ver,"aw",%nobits
	.align	2
	.set	.LANCHOR153,. + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.space	4
	.section	.bss.g_recovery_page_num,"aw",%nobits
	.align	2
	.set	.LANCHOR162,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.space	4
	.section	.bss.g_recovery_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR163,. + 0
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
	.set	.LANCHOR150,. + 0
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
	.set	.LANCHOR147,. + 0
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
	.set	.LANCHOR151,. + 0
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
	.set	.LANCHOR167,. + 0
	.type	gc_discard_updated, %object
	.size	gc_discard_updated, 4
gc_discard_updated:
	.space	4
	.section	.bss.gc_ink_free_return_value,"aw",%nobits
	.align	1
	.set	.LANCHOR172,. + 0
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
	.type	gp_flash_check_buf, %object
	.size	gp_flash_check_buf, 262144
gp_flash_check_buf:
	.space	262144
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
	.type	idb_buf, %object
	.size	idb_buf, 262144
idb_buf:
	.space	262144
	.section	.bss.idb_need_write_back,"aw",%nobits
	.align	2
	.set	.LANCHOR179,. + 0
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
	.set	.LANCHOR115,. + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 4
p_io_data_buf_0:
	.space	4
	.section	.bss.p_io_data_buf_1,"aw",%nobits
	.align	2
	.set	.LANCHOR113,. + 0
	.type	p_io_data_buf_1, %object
	.size	p_io_data_buf_1, 4
p_io_data_buf_1:
	.space	4
	.section	.bss.p_io_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR114,. + 0
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
	.set	.LANCHOR107,. + 0
	.type	p_sys_data_buf, %object
	.size	p_sys_data_buf, 4
p_sys_data_buf:
	.space	4
	.section	.bss.p_sys_data_buf_1,"aw",%nobits
	.align	2
	.set	.LANCHOR123,. + 0
	.type	p_sys_data_buf_1, %object
	.size	p_sys_data_buf_1, 4
p_sys_data_buf_1:
	.space	4
	.section	.bss.p_sys_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR108,. + 0
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
	.set	.LANCHOR124,. + 0
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
	.set	.LANCHOR111,. + 0
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
	.set	.LANCHOR121,. + 0
	.type	req_gc_dst, %object
	.size	req_gc_dst, 4
req_gc_dst:
	.space	4
	.section	.bss.req_prgm,"aw",%nobits
	.align	2
	.set	.LANCHOR122,. + 0
	.type	req_prgm, %object
	.size	req_prgm, 4
req_prgm:
	.space	4
	.section	.bss.req_read,"aw",%nobits
	.align	2
	.set	.LANCHOR120,. + 0
	.type	req_read, %object
	.size	req_read, 4
req_read:
	.space	4
	.section	.bss.req_sys,"aw",%nobits
	.align	2
	.set	.LANCHOR106,. + 0
	.type	req_sys, %object
	.size	req_sys, 20
req_sys:
	.space	20
	.section	.data.ftl_gc_temp_block_bops_scan_page_addr,"aw",%progbits
	.align	1
	.set	.LANCHOR156,. + 0
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
	.set	.LANCHOR177,. + 0
	.type	power_up_flag, %object
	.size	power_up_flag, 4
power_up_flag:
	.word	1
	.section	.rodata.FlashProgPages.str1.1,"aMS",%progbits,1
.LC79:
	.ascii	"prog read error: = %x\012\000"
.LC80:
	.ascii	"prog read s error: = %x %x %x\012\000"
.LC81:
	.ascii	"prog read d error: = %x %x %x\012\000"
	.section	.rodata.FtlBbmMapBadBlock.str1.1,"aMS",%progbits,1
.LC0:
	.ascii	"phyBlk = 0x%x die = %d block_in_die = 0x%x 0x%8x\012"
	.ascii	"\000"
	.section	.rodata.FtlBbmTblFlush.str1.1,"aMS",%progbits,1
.LC97:
	.ascii	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\012\000"
.LC98:
	.ascii	"FtlBbmTblFlush error:%x\012\000"
.LC99:
	.ascii	"FtlBbmTblFlush error = %x error count = %d\012\000"
	.section	.rodata.FtlFreeSysBlkQueueOut.str1.1,"aMS",%progbits,1
.LC82:
	.ascii	"FtlFreeSysBlkQueueOut free count = %d\012\000"
.LC83:
	.ascii	"FtlFreeSysBlkQueueOut = %x, free count = %d, error\012"
	.ascii	"\000"
	.section	.rodata.FtlGcFreeBadSuperBlk.str1.1,"aMS",%progbits,1
.LC100:
	.ascii	"FtlGcFreeBadSuperBlk 0x%x\012\000"
	.section	.rodata.FtlGcMarkBadPhyBlk.str1.1,"aMS",%progbits,1
.LC74:
	.ascii	"FtlGcMarkBadPhyBlk %d 0x%x\012\000"
	.section	.rodata.FtlGcRefreshBlock.str1.1,"aMS",%progbits,1
.LC73:
	.ascii	"FtlGcRefreshBlock  0x%x\012\000"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",%progbits,1
.LC103:
	.ascii	"no ect\000"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",%progbits,1
.LC89:
	.ascii	"FtlMapWritePage error = %x \012\000"
.LC90:
	.ascii	"FtlMapWritePage error = %x error count = %d\012\000"
	.section	.rodata.FtlMemInit.str1.1,"aMS",%progbits,1
.LC85:
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
.LC106:
	.ascii	"Ftlwrite decrement_vpc_count %x = %d\012\000"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",%progbits,1
.LC102:
	.ascii	"spuer block %x vpn is 0\012 \000"
	.section	.rodata.FtlVpcCheckAndModify.str1.1,"aMS",%progbits,1
.LC105:
	.ascii	"FtlCheckVpc %x = %x  %x\012\000"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",%progbits,1
.LC104:
	.ascii	"FtlVpcTblFlush error = %x error count = %d\012\000"
	.section	.rodata.FtlWrite.str1.1,"aMS",%progbits,1
.LC108:
	.ascii	"FtlWrite: lpa error:%x %x\012\000"
	.section	.rodata.GetSwlReplaceBlock.str1.1,"aMS",%progbits,1
.LC72:
	.ascii	"swblk %x ,avg = %x max= %x vpc= %x,ec=%x ,max ec=%x"
	.ascii	"\012\000"
	.section	.rodata.INSERT_DATA_LIST.str1.1,"aMS",%progbits,1
.LC1:
	.ascii	"\012!!!!! error @ func:%s - line:%d\012\000"
	.section	.rodata.__func__.10016,"a",%progbits
	.set	.LANCHOR171,. + 0
	.type	__func__.10016, %object
	.size	__func__.10016, 19
__func__.10016:
	.ascii	"FtlGcFreeTempBlock\000"
	.section	.rodata.__func__.10122,"a",%progbits
	.set	.LANCHOR175,. + 0
	.type	__func__.10122, %object
	.size	__func__.10122, 23
__func__.10122:
	.ascii	"rk_ftl_garbage_collect\000"
	.section	.rodata.__func__.10389,"a",%progbits
	.set	.LANCHOR104,. + 0
	.type	__func__.10389, %object
	.size	__func__.10389, 15
__func__.10389:
	.ascii	"FlashReadPages\000"
	.section	.rodata.__func__.10406,"a",%progbits
	.set	.LANCHOR109,. + 0
	.type	__func__.10406, %object
	.size	__func__.10406, 15
__func__.10406:
	.ascii	"FlashProgPages\000"
	.section	.rodata.__func__.8796,"a",%progbits
	.set	.LANCHOR138,. + 0
	.type	__func__.8796, %object
	.size	__func__.8796, 11
__func__.8796:
	.ascii	"FtlMemInit\000"
	.section	.rodata.__func__.8920,"a",%progbits
	.set	.LANCHOR170,. + 0
	.type	__func__.8920, %object
	.size	__func__.8920, 13
__func__.8920:
	.ascii	"FtlProgPages\000"
	.section	.rodata.__func__.8948,"a",%progbits
	.set	.LANCHOR178,. + 0
	.type	__func__.8948, %object
	.size	__func__.8948, 9
__func__.8948:
	.ascii	"FtlWrite\000"
	.section	.rodata.__func__.9094,"a",%progbits
	.set	.LANCHOR139,. + 0
	.type	__func__.9094, %object
	.size	__func__.9094, 14
__func__.9094:
	.ascii	"FtlBbt2Bitmap\000"
	.section	.rodata.__func__.9137,"a",%progbits
	.set	.LANCHOR164,. + 0
	.type	__func__.9137, %object
	.size	__func__.9137, 11
__func__.9137:
	.ascii	"FtlLoadBbt\000"
	.section	.rodata.__func__.9254,"a",%progbits
	.set	.LANCHOR49,. + 0
	.type	__func__.9254, %object
	.size	__func__.9254, 17
__func__.9254:
	.ascii	"INSERT_FREE_LIST\000"
	.section	.rodata.__func__.9259,"a",%progbits
	.set	.LANCHOR46,. + 0
	.type	__func__.9259, %object
	.size	__func__.9259, 17
__func__.9259:
	.ascii	"INSERT_DATA_LIST\000"
	.section	.rodata.__func__.9290,"a",%progbits
	.set	.LANCHOR50,. + 0
	.type	__func__.9290, %object
	.size	__func__.9290, 17
__func__.9290:
	.ascii	"List_remove_node\000"
	.section	.rodata.__func__.9322,"a",%progbits
	.set	.LANCHOR54,. + 0
	.type	__func__.9322, %object
	.size	__func__.9322, 22
__func__.9322:
	.ascii	"List_update_data_list\000"
	.section	.rodata.__func__.9331,"a",%progbits
	.set	.LANCHOR140,. + 0
	.type	__func__.9331, %object
	.size	__func__.9331, 16
__func__.9331:
	.ascii	"load_l2p_region\000"
	.section	.rodata.__func__.9364,"a",%progbits
	.set	.LANCHOR116,. + 0
	.type	__func__.9364, %object
	.size	__func__.9364, 26
__func__.9364:
	.ascii	"ftl_map_blk_alloc_new_blk\000"
	.section	.rodata.__func__.9375,"a",%progbits
	.set	.LANCHOR143,. + 0
	.type	__func__.9375, %object
	.size	__func__.9375, 15
__func__.9375:
	.ascii	"ftl_map_blk_gc\000"
	.section	.rodata.__func__.9389,"a",%progbits
	.set	.LANCHOR141,. + 0
	.type	__func__.9389, %object
	.size	__func__.9389, 31
__func__.9389:
	.ascii	"Ftl_write_map_blk_to_last_page\000"
	.section	.rodata.__func__.9403,"a",%progbits
	.set	.LANCHOR142,. + 0
	.type	__func__.9403, %object
	.size	__func__.9403, 16
__func__.9403:
	.ascii	"FtlMapWritePage\000"
	.section	.rodata.__func__.9428,"a",%progbits
	.set	.LANCHOR57,. + 0
	.type	__func__.9428, %object
	.size	__func__.9428, 22
__func__.9428:
	.ascii	"select_l2p_ram_region\000"
	.section	.rodata.__func__.9445,"a",%progbits
	.set	.LANCHOR145,. + 0
	.type	__func__.9445, %object
	.size	__func__.9445, 9
__func__.9445:
	.ascii	"log2phys\000"
	.section	.rodata.__func__.9518,"a",%progbits
	.set	.LANCHOR166,. + 0
	.type	__func__.9518, %object
	.size	__func__.9518, 15
__func__.9518:
	.ascii	"FtlVpcTblFlush\000"
	.section	.rodata.__func__.9540,"a",%progbits
	.set	.LANCHOR148,. + 0
	.type	__func__.9540, %object
	.size	__func__.9540, 14
__func__.9540:
	.ascii	"FtlScanSysBlk\000"
	.section	.rodata.__func__.9597,"a",%progbits
	.set	.LANCHOR180,. + 0
	.type	__func__.9597, %object
	.size	__func__.9597, 15
__func__.9597:
	.ascii	"FtlLoadSysInfo\000"
	.section	.rodata.__func__.9660,"a",%progbits
	.set	.LANCHOR146,. + 0
	.type	__func__.9660, %object
	.size	__func__.9660, 16
__func__.9660:
	.ascii	"FtlReUsePrevPpa\000"
	.section	.rodata.__func__.9694,"a",%progbits
	.set	.LANCHOR160,. + 0
	.type	__func__.9694, %object
	.size	__func__.9694, 22
__func__.9694:
	.ascii	"FtlRecoverySuperblock\000"
	.section	.rodata.__func__.9751,"a",%progbits
	.set	.LANCHOR60,. + 0
	.type	__func__.9751, %object
	.size	__func__.9751, 16
__func__.9751:
	.ascii	"make_superblock\000"
	.section	.rodata.__func__.9772,"a",%progbits
	.set	.LANCHOR154,. + 0
	.type	__func__.9772, %object
	.size	__func__.9772, 18
__func__.9772:
	.ascii	"SupperBlkListInit\000"
	.section	.rodata.__func__.9797,"a",%progbits
	.set	.LANCHOR168,. + 0
	.type	__func__.9797, %object
	.size	__func__.9797, 21
__func__.9797:
	.ascii	"FtlVpcCheckAndModify\000"
	.section	.rodata.__func__.9813,"a",%progbits
	.set	.LANCHOR155,. + 0
	.type	__func__.9813, %object
	.size	__func__.9813, 14
__func__.9813:
	.ascii	"ftl_check_vpc\000"
	.section	.rodata.__func__.9898,"a",%progbits
	.set	.LANCHOR157,. + 0
	.type	__func__.9898, %object
	.size	__func__.9898, 25
__func__.9898:
	.ascii	"allocate_data_superblock\000"
	.section	.rodata.__func__.9919,"a",%progbits
	.set	.LANCHOR169,. + 0
	.type	__func__.9919, %object
	.size	__func__.9919, 29
__func__.9919:
	.ascii	"allocate_new_data_superblock\000"
	.section	.rodata.__func__.9926,"a",%progbits
	.set	.LANCHOR88,. + 0
	.type	__func__.9926, %object
	.size	__func__.9926, 19
__func__.9926:
	.ascii	"get_new_active_ppa\000"
	.section	.rodata.__func__.9939,"a",%progbits
	.set	.LANCHOR158,. + 0
	.type	__func__.9939, %object
	.size	__func__.9939, 16
__func__.9939:
	.ascii	"update_vpc_list\000"
	.section	.rodata.__func__.9946,"a",%progbits
	.set	.LANCHOR159,. + 0
	.type	__func__.9946, %object
	.size	__func__.9946, 20
__func__.9946:
	.ascii	"decrement_vpc_count\000"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",%progbits,1
.LC101:
	.ascii	"decrement_vpc_count %x = %d\012\000"
	.section	.rodata.ftl_check_vpc.str1.1,"aMS",%progbits,1
.LC94:
	.ascii	"...%s enter...\012\000"
.LC95:
	.ascii	"FtlCheckVpc2 %x = %x  %x\012\000"
.LC96:
	.ascii	"free blk vpc error %x = %x  %x\012\000"
	.section	.rodata.ftl_map_blk_alloc_new_blk.str1.1,"aMS",%progbits,1
.LC84:
	.ascii	"FtlFreeSysBlkQueueOut = %x, free count = %d\012\000"
	.section	.rodata.ftl_scan_all_data.str1.1,"aMS",%progbits,1
.LC91:
	.ascii	"ftl_scan_all_data = %x\012\000"
.LC92:
	.ascii	"scan lpa = %x ppa= %x\012\000"
.LC93:
	.ascii	"lba = %x,addr= %x,spare= %x %x %x %x data=%x %x\012"
	.ascii	"\000"
	.section	.rodata.load_l2p_region.str1.1,"aMS",%progbits,1
.LC86:
	.ascii	"region_id = %x phyAddr = %x\012\000"
.LC87:
	.ascii	"spare:\000"
.LC88:
	.ascii	"map_ppn:\000"
	.section	.rodata.rk_ftl_garbage_collect.str1.1,"aMS",%progbits,1
.LC107:
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
	.ascii	"SFTL version: 5.0.44 20180713\000"
.LC71:
	.ascii	"%s\012\000"
	.section	.rodata.sftl_write.str1.1,"aMS",%progbits,1
.LC109:
	.ascii	"write_idblock fail! %x %x %x %x\012\000"
	.hidden	free
