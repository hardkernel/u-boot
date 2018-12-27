/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:    GPL-2.0
 * date: 2018-12-27
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
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r3, r0
	ldrh	r4, [r0]
	ldr	r2, .L25
	ldrh	r5, [r0, #2]
	ldrh	r0, [r0, #4]
	strh	r4, [r2]	@ movhi
	ldr	r2, .L25+4
	ldrh	r1, [r3, #6]
	ldrh	r7, [r3, #14]
	strh	r5, [r2]	@ movhi
	ldr	r2, .L25+8
	ldr	r6, .L25+12
	cmp	r7, #4
	strh	r0, [r2]	@ movhi
	ldr	r2, .L25+16
	strh	r7, [r6]	@ movhi
	ldr	r7, .L25+20
	strh	r1, [r2]	@ movhi
	itttt	eq
	lsreq	r1, r1, #1
	strheq	r1, [r2]	@ movhi
	moveq	r1, #8
	strheq	r1, [r6]	@ movhi
	movs	r1, #0
.L17:
	strb	r1, [r1, r7]
	adds	r1, r1, #1
	cmp	r1, #32
	bne	.L17
	ldr	r1, .L25+24
	cmp	r4, #1
	mov	r7, #5
	smulbb	r5, r5, r0
	mov	ip, #0
	str	r3, [sp, #4]
	strh	r7, [r1]	@ movhi
	it	eq
	strheq	r4, [r1]	@ movhi
	mov	r4, #640
	ldr	r1, .L25+28
	uxth	r5, r5
	ldr	r7, .L25+32
	strh	r4, [r1]	@ movhi
	ldrh	r4, [r2]
	ldr	r1, .L25+36
	ldr	r2, .L25+40
	strh	ip, [r7]	@ movhi
	smulbb	r0, r0, r4
	strh	r5, [r1]	@ movhi
	ldr	r7, .L25+44
	uxth	r0, r0
	strh	r0, [r2]	@ movhi
	bl	Ftl_log2
	ldr	r3, [sp, #4]
	ldr	r2, .L25+48
	ldrh	fp, [r6]
	ldrh	r8, [r3, #12]
	strh	r0, [r2]	@ movhi
	ldr	r2, .L25+52
	mov	r0, fp
	strh	r8, [r7]	@ movhi
	smulbb	r1, r5, r8
	ldr	r6, .L25+56
	strh	r8, [r2]	@ movhi
	ldr	r2, .L25+60
	strh	r1, [r2]	@ movhi
	bl	Ftl_log2
	lsl	r2, fp, #9
	ldr	r1, .L25+64
	ldr	r3, [sp, #4]
	mov	r10, r0
	uxth	r2, r2
	strh	r0, [r6]	@ movhi
	mov	r0, #5120
	strh	r2, [r1]	@ movhi
	lsrs	r2, r2, #8
	ldr	r1, .L25+68
	strh	r2, [r1]	@ movhi
	mul	r1, r8, fp
	ldrh	r2, [r3, #20]
	ldr	r3, .L25+72
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
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L26:
	.align	2
.L25:
	.word	.LANCHOR9
	.word	.LANCHOR10
	.word	.LANCHOR11
	.word	.LANCHOR12
	.word	.LANCHOR6
	.word	.LANCHOR13
	.word	.LANCHOR14
	.word	.LANCHOR16
	.word	.LANCHOR15
	.word	.LANCHOR3
	.word	.LANCHOR17
	.word	.LANCHOR19
	.word	.LANCHOR18
	.word	.LANCHOR20
	.word	.LANCHOR22
	.word	.LANCHOR21
	.word	.LANCHOR23
	.word	.LANCHOR24
	.word	.LANCHOR25
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
	ldr	r3, .L48
	mov	r7, r0
	ldrh	r6, [r3]
	mov	r1, r6
	bl	__aeabi_uidiv
	ldr	r3, .L48+4
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
.L49:
	.align	2
.L48:
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
	ldr	r3, .L51
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r5, [r3]
	ldr	r3, .L51+4
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	smulbb	r4, r0, r5
	mov	r1, r5
	mov	r0, r6
	bl	__aeabi_uidivmod
	add	r1, r1, r4
	uxth	r0, r1
	pop	{r4, r5, r6, pc}
.L52:
	.align	2
.L51:
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
	ldr	r3, .L54
	ldrh	r1, [r3]
	bl	__aeabi_uidivmod
	ldr	r3, .L54+4
	uxth	r0, r1
	ldrh	r1, [r3]
	bl	__aeabi_uidiv
	uxth	r0, r0
	pop	{r3, pc}
.L55:
	.align	2
.L54:
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
	bls	.L57
	subs	r0, r0, r1
	cmp	r0, #-2147483648
	ite	hi
	movhi	r0, #0
	movls	r0, #1
	bx	lr
.L57:
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
	ldr	r3, .L60
	ldrh	r0, [r3, #6]
	clz	r0, r0
	lsrs	r0, r0, #5
	bx	lr
.L61:
	.align	2
.L60:
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
	ldr	r3, .L63
	ldrh	r0, [r3, #6]
	sub	r3, r0, #1024
	rsbs	r0, r3, #0
	adcs	r0, r0, r3
	bx	lr
.L64:
	.align	2
.L63:
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
	ldr	r3, .L74
	push	{r4, r5, r6, lr}
	ldrh	r2, [r3, #6]
	cbz	r2, .L65
	ldr	r2, .L74+4
	movs	r6, #0
	ldrh	r1, [r3, #2]
	mov	r5, r6
	ldrh	r4, [r2, #28]
	ldrh	r2, [r3, #4]
	and	r4, r4, #31
.L67:
	uxth	r0, r6
	adds	r6, r6, #1
	cmp	r4, r0
	bgt	.L68
	cbz	r5, .L65
	strh	r1, [r3, #2]	@ movhi
	strh	r2, [r3, #4]	@ movhi
.L65:
	pop	{r4, r5, r6, pc}
.L68:
	adds	r0, r1, #4
	adds	r1, r1, #1
	ldrh	r5, [r3, r0, lsl #1]
	adds	r0, r2, #4
	ubfx	r1, r1, #0, #10
	strh	r5, [r3, r0, lsl #1]	@ movhi
	movs	r5, #1
	add	r2, r2, r5
	ubfx	r2, r2, #0, #10
	b	.L67
.L75:
	.align	2
.L74:
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
	ldr	r3, .L82
	push	{r4, r5, lr}
	ldrh	r4, [r3, #6]
	cmp	r4, #1024
	beq	.L80
	ldrh	r5, [r3, #2]
	movs	r1, #0
.L78:
	cmp	r1, r4
	bcc	.L79
.L80:
	movs	r0, #0
	pop	{r4, r5, pc}
.L79:
	adds	r2, r1, r5
	ubfx	r2, r2, #0, #10
	adds	r2, r2, #4
	ldrh	r2, [r3, r2, lsl #1]
	cmp	r2, r0
	beq	.L81
	adds	r1, r1, #1
	b	.L78
.L81:
	movs	r0, #1
	pop	{r4, r5, pc}
.L83:
	.align	2
.L82:
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
	ldr	r3, .L100
	ldrh	lr, [r3]
	cmp	lr, r0
	bls	.L86
	ldr	r3, .L100+4
	movs	r5, #6
	ldr	r4, [r3]
	mul	r3, r5, r0
	str	r3, [sp, #4]
	adds	r1, r4, r3
	ldr	r2, [sp, #4]
	movw	r3, #65535
	strh	r3, [r1, #2]	@ movhi
	strh	r3, [r4, r2]	@ movhi
	ldr	r3, .L100+8
	ldr	ip, [r3]
	cmp	ip, #0
	bne	.L87
.L99:
	str	r1, [r3]
.L86:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L87:
	ldr	r3, .L100+12
	lsls	r2, r0, #1
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldrh	r6, [r3, r0, lsl #1]
	ldrh	r3, [r1, #4]
	cbz	r3, .L97
	mul	fp, r3, r6
.L88:
	sub	r3, ip, r4
	asrs	r6, r3, #1
	ldr	r3, .L100+16
	muls	r3, r6, r3
	ldr	r6, .L100+20
	ldr	r8, [r6]
	movs	r6, #0
	uxth	r3, r3
	add	r2, r8, r2
	str	r2, [sp, #12]
	mov	r2, ip
.L95:
	adds	r6, r6, #1
	uxth	r6, r6
	cmp	lr, r6
	bcc	.L86
	cmp	r3, r0
	beq	.L86
	ldr	r7, [sp, #8]
	lsl	r10, r3, #1
	ldrh	r7, [r7, r3, lsl #1]
	mov	r5, r7
	ldrh	r7, [r2, #4]
	cbz	r7, .L98
	muls	r7, r5, r7
.L90:
	cmp	fp, r7
	bne	.L91
	ldr	r5, [sp, #12]
	ldrh	r10, [r8, r10]
	ldrh	r7, [r5]
	cmp	r10, r7
	bcc	.L93
.L92:
	ldr	r5, [sp, #4]
	cmp	r2, ip
	strh	r3, [r4, r5]	@ movhi
	ldrh	r3, [r2, #2]
	strh	r3, [r1, #2]	@ movhi
	bne	.L96
	strh	r0, [r2, #2]	@ movhi
	ldr	r3, .L100+8
	b	.L99
.L97:
	mov	fp, #-1
	b	.L88
.L98:
	mov	r7, #-1
	b	.L90
.L91:
	bcc	.L92
.L93:
	ldrh	r7, [r2]
	movw	r5, #65535
	cmp	r7, r5
	bne	.L94
	strh	r3, [r1, #2]	@ movhi
	strh	r0, [r2]	@ movhi
	ldr	r3, .L100+24
	b	.L99
.L94:
	movs	r3, #6
	mla	r2, r3, r7, r4
	mov	r3, r7
	b	.L95
.L96:
	ldrh	r1, [r2, #2]
	movs	r3, #6
	muls	r3, r1, r3
	strh	r0, [r4, r3]	@ movhi
	strh	r0, [r2, #2]	@ movhi
	b	.L86
.L101:
	.align	2
.L100:
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
	ldr	r2, .L104
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L104+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L102
	movs	r2, #214
	ldr	r1, .L104+8
	ldr	r0, .L104+12
	pop	{r3, lr}
	b	printf
.L102:
	pop	{r3, pc}
.L105:
	.align	2
.L104:
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
	beq	.L107
	ldr	r3, .L113
	mov	r10, #6
	mul	r7, r10, r0
	ldr	r4, [r3]
	ldr	r3, .L113+4
	adds	r5, r4, r7
	ldr	r6, [r3]
	mov	lr, r3
	strh	r1, [r5, #2]	@ movhi
	strh	r1, [r4, r7]	@ movhi
	cbnz	r6, .L108
	str	r5, [r3]
.L107:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L108:
	ldr	r3, .L113+8
	subs	r2, r6, r4
	mov	fp, r1
	ldr	ip, [r3]
	asrs	r3, r2, #1
	ldr	r2, .L113+12
	ldrh	r8, [ip, r0, lsl #1]
	muls	r2, r3, r2
	mov	r3, r6
	uxth	r2, r2
.L111:
	ldrh	r1, [ip, r2, lsl #1]
	cmp	r1, r8
	bcs	.L109
	ldrh	r1, [r3]
	cmp	r1, fp
	bne	.L110
	strh	r2, [r5, #2]	@ movhi
	strh	r0, [r3]	@ movhi
	b	.L107
.L110:
	mla	r3, r10, r1, r4
	mov	r2, r1
	b	.L111
.L109:
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
	b	.L107
.L114:
	.align	2
.L113:
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
	ldr	r2, .L117
	ldrh	r3, [r2]
	adds	r3, r3, #1
	uxth	r3, r3
	strh	r3, [r2]	@ movhi
	ldr	r2, .L117+4
	ldrh	r2, [r2]
	cmp	r2, r3
	bcs	.L115
	movs	r2, #207
	ldr	r1, .L117+8
	ldr	r0, .L117+12
	pop	{r3, lr}
	b	printf
.L115:
	pop	{r3, pc}
.L118:
	.align	2
.L117:
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
	ldr	r5, .L125
	muls	r6, r1, r6
	movw	r3, #65535
	mov	r8, r0
	ldr	r7, [r5]
	adds	r4, r7, r6
	ldrh	r2, [r4, #2]
	cmp	r2, r3
	bne	.L120
	ldr	r3, [r0]
	cmp	r4, r3
	beq	.L120
	mov	r2, #372
	ldr	r1, .L125+4
	ldr	r0, .L125+8
	bl	printf
.L120:
	ldr	r3, [r8]
	movw	r1, #65535
	cmp	r4, r3
	ldrh	r3, [r7, r6]
	bne	.L121
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
.L123:
	movw	r3, #65535
	movs	r0, #0
	strh	r3, [r7, r6]	@ movhi
	strh	r3, [r4, #2]	@ movhi
	pop	{r4, r5, r6, r7, r8, pc}
.L121:
	cmp	r3, r1
	ldrh	r1, [r4, #2]
	bne	.L124
	cmp	r1, r3
	beq	.L123
	movs	r2, #6
	ldr	r0, [r5]
	muls	r1, r2, r1
	strh	r3, [r0, r1]	@ movhi
	b	.L123
.L124:
	ldr	r0, [r5]
	movs	r2, #6
	mla	r5, r2, r3, r0
	strh	r1, [r5, #2]	@ movhi
	ldrh	r1, [r4, #2]
	muls	r2, r1, r2
	strh	r3, [r0, r2]	@ movhi
	b	.L123
.L126:
	.align	2
.L125:
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
	cbz	r3, .L133
	ldr	r2, .L134
	movw	r5, #65535
	movs	r6, #6
	ldr	r2, [r2]
.L129:
	cbnz	r1, .L130
.L132:
	ldr	r4, .L134+4
	subs	r3, r3, r2
	asrs	r3, r3, #1
	muls	r4, r3, r4
	uxth	r1, r4
	bl	List_remove_node
	uxth	r0, r4
	pop	{r4, r5, r6, pc}
.L130:
	ldrh	r4, [r3]
	cmp	r4, r5
	beq	.L132
	subs	r1, r1, #1
	mla	r3, r6, r4, r2
	uxth	r1, r1
	b	.L129
.L133:
	movw	r0, #65535
	pop	{r4, r5, r6, pc}
.L135:
	.align	2
.L134:
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
	ldr	r3, .L143
	push	{r4, lr}
	ldr	r3, [r3]
	cbz	r3, .L142
	ldr	r2, .L143+4
	movs	r4, #6
	ldr	r1, [r2]
	movw	r2, #65535
.L139:
	cbz	r0, .L140
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L141
.L142:
	movw	r0, #65535
	pop	{r4, pc}
.L141:
	subs	r0, r0, #1
	mla	r3, r4, r3, r1
	uxth	r0, r0
	b	.L139
.L140:
	ldr	r0, .L143+8
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r0, r3
	uxth	r0, r3
	pop	{r4, pc}
.L144:
	.align	2
.L143:
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
	ldr	r3, .L156
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L147
	ldr	r3, .L156+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L147
	ldr	r3, .L156+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L147
	ldr	r7, .L156+12
	movs	r6, #6
	ldr	r3, .L156+16
	muls	r6, r0, r6
	ldr	fp, [r7]
	ldr	r3, [r3]
	add	r10, fp, r6
	cmp	r10, r3
	beq	.L147
	ldr	r3, .L156+20
	ldrh	r5, [r10, #4]
	ldr	r2, [r3]
	mov	r8, r3
	ldrh	r2, [r2, r0, lsl #1]
	cmp	r5, #0
	beq	.L154
	muls	r5, r2, r5
.L149:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L150
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	bne	.L150
	movw	r2, #463
	ldr	r1, .L156+24
	ldr	r0, .L156+28
	bl	printf
.L150:
	ldrh	r3, [r10, #2]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L151
	ldrh	r2, [fp, r6]
	cmp	r2, r3
	beq	.L147
.L151:
	movs	r2, #6
	muls	r2, r3, r2
	ldr	r3, .L156+32
	asrs	r1, r2, #1
	muls	r3, r1, r3
	ldr	r1, [r8]
	ldrh	r0, [r1, r3, lsl #1]
	ldr	r1, [r7]
	add	r2, r2, r1
	ldrh	r3, [r2, #4]
	cbz	r3, .L155
	muls	r3, r0, r3
.L152:
	cmp	r5, r3
	bcs	.L147
	ldr	r5, .L156+36
	mov	r1, r4
	ldr	r0, .L156+16
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L153
	mov	r2, #474
	ldr	r1, .L156+24
	ldr	r0, .L156+28
	bl	printf
.L153:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	INSERT_DATA_LIST
.L147:
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L154:
	mov	r5, #-1
	b	.L149
.L155:
	mov	r3, #-1
	b	.L152
.L157:
	.align	2
.L156:
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
	ldr	r3, .L168
	movs	r0, #12
	movw	r5, #65535
	ldrh	r2, [r3]
	ldr	r3, .L168+4
	ldr	r3, [r3]
.L159:
	uxth	r4, r1
	cmp	r4, r2
	bcc	.L161
	mov	r4, r2
	movs	r1, #0
	mov	r6, #-2147483648
	movs	r7, #12
.L162:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L164
	cmp	r4, r2
	bcc	.L160
	ldr	r1, .L168+8
	mov	r4, r2
	mov	r0, #-1
	ldrh	r7, [r1]
	movs	r1, #0
.L165:
	uxth	r5, r1
	cmp	r5, r2
	bcc	.L167
	cmp	r4, r2
	bcc	.L160
	movw	r2, #789
	ldr	r1, .L168+12
	ldr	r0, .L168+16
	bl	printf
	b	.L160
.L161:
	adds	r1, r1, #1
	mla	r6, r0, r1, r3
	ldrh	r6, [r6, #-12]
	cmp	r6, r5
	bne	.L159
.L160:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, pc}
.L164:
	mla	r0, r7, r1, r3
	ldr	r0, [r0, #4]
	cmp	r0, #0
	blt	.L163
	cmp	r6, r0
	itt	hi
	movhi	r6, r0
	movhi	r4, r5
.L163:
	adds	r1, r1, #1
	b	.L162
.L167:
	ldr	r6, [r3, #4]
	cmp	r0, r6
	bls	.L166
	ldrh	ip, [r3]
	cmp	ip, r7
	itt	ne
	movne	r0, r6
	movne	r4, r5
.L166:
	adds	r1, r1, #1
	adds	r3, r3, #12
	b	.L165
.L169:
	.align	2
.L168:
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
	ldr	r2, .L180
	push	{r4, r5, r6, lr}
	mov	r1, r2
	ldrh	r3, [r2]
	cmp	r3, #4
	bhi	.L171
	cbnz	r0, .L171
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	pop	{r4, r5, r6, pc}
.L171:
	movs	r3, #0
	ldr	r0, .L180+4
	strh	r3, [r1]	@ movhi
	movw	r6, #65535
	ldr	r1, .L180+8
	ldrh	r4, [r0]
	mov	r0, r3
	ldr	r2, .L180+12
	ldr	r1, [r1]
	str	r3, [r2]
	add	r4, r1, r4, lsl #1
.L172:
	cmp	r1, r4
	bne	.L174
	cbz	r3, .L170
	str	r0, [r2]
.L170:
	pop	{r4, r5, r6, pc}
.L174:
	ldrh	r5, [r1], #2
	cmp	r5, r6
	itt	ne
	addne	r0, r0, r5
	movne	r3, #1
	b	.L172
.L181:
	.align	2
.L180:
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
	cbz	r1, .L183
	b	ftl_set_blk_mode.part.6
.L183:
	ldr	r2, .L184
	lsrs	r0, r0, #5
	and	r3, r3, #31
	ldr	r1, [r2]
	movs	r2, #1
	lsl	r3, r2, r3
	ldr	r2, [r1, r0, lsl #2]
	bic	r2, r2, r3
	str	r2, [r1, r0, lsl #2]
	bx	lr
.L185:
	.align	2
.L184:
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
	ldr	r3, .L187
	lsrs	r2, r0, #5
	and	r0, r0, #31
	ldr	r3, [r3]
	ldr	r3, [r3, r2, lsl #2]
	lsr	r0, r3, r0
	and	r0, r0, #1
	bx	lr
.L188:
	.align	2
.L187:
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
	ldr	r3, .L196
	ldrh	r4, [r3]
	add	r3, r0, r2, lsl #1
	adds	r3, r3, #14
.L190:
	cmp	r2, r4
	bcc	.L192
	ldr	r3, .L196+4
	add	r5, r0, #16
	movw	r6, #65535
	ldrh	r3, [r3]
	subs	r3, r3, #1
	subs	r1, r3, r1
	movs	r3, #0
	uxth	r1, r1
.L193:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L195
	pop	{r4, r5, r6, pc}
.L192:
	ldrh	r5, [r3, #2]!
	adds	r2, r2, #1
	uxth	r2, r2
	cmp	r5, r6
	ittt	ne
	ldrhne	r5, [r0, #4]
	addne	r5, r5, #1
	strhne	r5, [r0, #4]	@ movhi
	b	.L190
.L195:
	ldrh	r2, [r5], #2
	adds	r3, r3, #1
	cmp	r2, r6
	ittt	ne
	ldrhne	r2, [r0, #4]
	addne	r2, r2, r1
	strhne	r2, [r0, #4]	@ movhi
	b	.L193
.L197:
	.align	2
.L196:
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
	cbz	r3, .L198
	ldrh	r2, [r0]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L198
	ldrb	r2, [r0, #6]	@ zero_extendqisi2
	movs	r5, #0
	adds	r2, r2, #8
	ldrh	r1, [r0, r2, lsl #1]
	ldr	r2, .L204
	ldrh	r4, [r2]
	mov	r2, r3
.L201:
	cmp	r1, r2
	beq	.L203
.L198:
	pop	{r4, r5, pc}
.L203:
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
	b	.L201
.L205:
	.align	2
.L204:
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
	ldr	r3, .L211
	ldrh	r2, [r0]
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L207
	movw	r2, #2156
	ldr	r1, .L211+4
	ldr	r0, .L211+8
	bl	printf
.L207:
	ldr	r3, .L211+12
	add	r6, r4, #16
	ldr	r10, .L211+20
	movw	r7, #65535
	movs	r5, #0
	ldrh	r8, [r3]
	strh	r5, [r4, #4]	@ movhi
	strb	r5, [r4, #7]
.L208:
	uxth	r3, r5
	cmp	r8, r3
	bhi	.L210
	ldr	r2, .L211+16
	movs	r0, #0
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	strb	r0, [r4, #9]
	ldrh	r2, [r2]
	smulbb	r3, r3, r2
	strh	r3, [r4, #4]	@ movhi
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L210:
	ldrh	r1, [r4]
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	strh	r7, [r6]	@ movhi
	mov	fp, r0
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L209
	strh	fp, [r6]	@ movhi
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r4, #7]
.L209:
	adds	r5, r5, #1
	adds	r6, r6, #2
	b	.L208
.L212:
	.align	2
.L211:
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
	ldr	r3, .L219
	mov	r6, r0
	mov	r4, r5
	ldr	r10, .L219+12
	ldrh	r7, [r3]
	ldr	r3, .L219+4
	ldrh	r8, [r3]
.L214:
	uxth	r3, r5
	cmp	r7, r3
	bhi	.L216
	cbz	r4, .L218
	mov	r1, r4
	mov	r0, #32768
	bl	__aeabi_idiv
.L217:
	ldr	r3, .L219+8
	movs	r2, #6
	ldr	r3, [r3]
	mla	r6, r2, r6, r3
	strh	r0, [r6, #4]	@ movhi
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L216:
	mov	r1, r6
	ldrb	r0, [r10, r5]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L215
	add	r4, r4, r8
	uxth	r4, r4
.L215:
	adds	r5, r5, #1
	b	.L214
.L218:
	mov	r0, r4
	b	.L217
.L220:
	.align	2
.L219:
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
	ldr	r3, .L224
	ldr	r0, [r3]
	cbz	r0, .L222
	ldr	r3, .L224+4
	ldr	r3, [r3]
	subs	r0, r0, r3
	ldr	r3, .L224+8
	asrs	r0, r0, #1
	muls	r0, r3, r0
	ldr	r3, .L224+12
	ldr	r3, [r3]
	uxth	r0, r0
	ldrh	r0, [r3, r0, lsl #1]
.L222:
	bx	lr
.L225:
	.align	2
.L224:
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
	ldr	r3, .L234
	push	{r4, r5, r6, lr}
	ldr	r3, [r3]
	cbz	r3, .L232
	ldr	r2, .L234+4
	movs	r5, #6
	movw	r6, #65535
	ldrh	r2, [r2]
	rsb	r2, r2, r2, lsl #3
	asrs	r2, r2, #3
	cmp	r0, r2
	it	gt
	uxthgt	r0, r2
	ldr	r2, .L234+8
	ldr	r1, [r2]
	ldr	r2, .L234+12
	subs	r3, r3, r1
	asrs	r3, r3, #1
	muls	r3, r2, r3
	movs	r2, #0
	uxth	r3, r3
.L229:
	uxth	r4, r2
	cmp	r0, r4
	bls	.L231
	mul	r4, r5, r3
	adds	r2, r2, #1
	ldrh	r4, [r1, r4]
	cmp	r4, r6
	bne	.L233
.L231:
	ldr	r2, .L234+16
	ldr	r2, [r2]
	ldrh	r0, [r2, r3, lsl #1]
	pop	{r4, r5, r6, pc}
.L233:
	mov	r3, r4
	b	.L229
.L232:
	mov	r0, r3
	pop	{r4, r5, r6, pc}
.L235:
	.align	2
.L234:
	.word	.LANCHOR47
	.word	.LANCHOR48
	.word	.LANCHOR40
	.word	-1431655765
	.word	.LANCHOR43
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
	beq	.L237
	ldr	r2, .L238
	movs	r1, #0
	ldr	r2, [r2]
	strh	r1, [r2, r0, lsl #1]	@ movhi
	bl	INSERT_FREE_LIST
.L237:
	movs	r0, #0
	pop	{r3, pc}
.L239:
	.align	2
.L238:
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
	bne	.L241
	movw	r2, #2786
	ldr	r1, .L254
	ldr	r0, .L254+4
	bl	printf
.L241:
	ldr	r5, .L254+8
	ldrh	r2, [r4, #2]
	ldrh	r3, [r5]
	cmp	r2, r3
	bne	.L242
	movw	r2, #2787
	ldr	r1, .L254
	ldr	r0, .L254+4
	bl	printf
.L242:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L243
	movw	r2, #2788
	ldr	r1, .L254
	ldr	r0, .L254+4
	bl	printf
.L243:
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	movs	r3, #0
	strb	r3, [r4, #10]
	movw	r6, #65535
	adds	r2, r2, #8
	ldrh	r0, [r4, r2, lsl #1]
	ldr	r2, .L254+12
	ldrh	r1, [r2]
	mov	r2, r3
.L244:
	cmp	r0, r6
	ldrb	r3, [r4, #6]	@ zero_extendqisi2
	beq	.L246
	ldrh	r2, [r4, #4]
	ldrh	r6, [r4, #2]
	subs	r2, r2, #1
	uxth	r2, r2
	orr	r6, r6, r0, lsl #10
	movw	r0, #65535
	strh	r2, [r4, #4]	@ movhi
.L248:
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
	beq	.L248
	strb	r3, [r4, #6]
	ldrh	r1, [r4, #2]
	ldrh	r3, [r5]
	cmp	r1, r3
	bne	.L240
	cbz	r2, .L240
	movw	r2, #2809
	ldr	r1, .L254
	ldr	r0, .L254+4
	bl	printf
.L240:
	mov	r0, r6
	pop	{r3, r4, r5, r6, r7, pc}
.L246:
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
	b	.L244
.L255:
	.align	2
.L254:
	.word	.LANCHOR61
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
	ldr	r1, .L261
	mov	fp, #1
	ldr	r2, .L261+4
	ldr	r5, [r1]
	ldr	r1, .L261+8
	str	r3, [r2]
	ldr	r2, .L261+12
	mov	r0, r5
	ldr	r1, [r1]
	ldrh	r2, [r2]
	str	r1, [sp, #4]
	ldr	r1, .L261+16
	ldrh	r1, [r1]
	str	r1, [sp]
	ldr	r1, .L261+20
	ldr	r10, [r1]
	ldr	r1, .L261+24
	ldrh	r7, [r1]
	ldr	r1, .L261+28
	ldr	r4, [r1]
	movs	r1, #12
	mla	r1, r2, r1, r1
	adds	r4, r4, #8
	add	r8, r5, r1
	mov	r1, r3
.L257:
	adds	r0, r0, #12
	ldr	r6, [sp]
	cmp	r0, r8
	add	ip, r3, r7
	add	r4, r4, #20
	add	lr, r1, r6
	bne	.L258
	ldr	r3, .L261+32
	mov	lr, #12
	mov	r8, #0
	ldr	r0, [r3]
	ldr	r3, .L261+8
	ldr	r4, [r3]
	ldr	r3, .L261+20
	ldr	ip, [r3]
.L259:
	cmp	r2, r0
	bcc	.L260
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L258:
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
	b	.L257
.L260:
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
	b	.L259
.L262:
	.align	2
.L261:
	.word	.LANCHOR63
	.word	.LANCHOR62
	.word	.LANCHOR64
	.word	.LANCHOR3
	.word	.LANCHOR23
	.word	.LANCHOR65
	.word	.LANCHOR24
	.word	.LANCHOR66
	.word	.LANCHOR67
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
	ldr	r3, .L270
	mov	ip, #12
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	mov	fp, #20
	mov	lr, r4
	ldr	r7, [r3]
	ldr	r3, .L270+4
	ldr	r5, [r3]
.L264:
	uxth	r3, r4
	cmp	r1, r3
	bls	.L263
	mla	r8, fp, r3, r0
	movs	r2, #0
.L265:
	uxth	r3, r2
	cmp	r7, r3
	bls	.L266
	mul	r3, ip, r3
	ldr	r6, [r8, #8]
	adds	r2, r2, #1
	add	r10, r5, r3
	ldr	r3, [r5, r3]
	cmp	r3, r6
	bne	.L265
	str	lr, [r10, #8]
.L266:
	adds	r4, r4, #1
	b	.L264
.L263:
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L271:
	.align	2
.L270:
	.word	.LANCHOR67
	.word	.LANCHOR63
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
	ldr	r3, .L279
	movs	r2, #0
	push	{r4, r5, r6, r7, r8, r10, lr}
	mov	ip, #12
	movs	r7, #1
	mov	lr, #20
	ldr	r4, [r3]
	ldr	r3, .L279+4
	ldr	r5, [r3]
.L273:
	uxth	r8, r2
	cmp	r1, r8
	bhi	.L277
	pop	{r4, r5, r6, r7, r8, r10, pc}
.L277:
	mov	r10, #0
.L274:
	uxth	r3, r10
	cmp	r4, r3
	bls	.L275
	mla	r3, ip, r3, r5
	add	r10, r10, #1
	ldr	r6, [r3, #8]
	cmp	r6, #0
	bne	.L274
	mla	r8, lr, r8, r0
	str	r7, [r3, #8]
	ldr	r6, [r3]
	ldr	r3, [r3, #4]
	str	r6, [r8, #8]
	str	r3, [r8, #12]
.L275:
	adds	r2, r2, #1
	b	.L273
.L280:
	.align	2
.L279:
	.word	.LANCHOR67
	.word	.LANCHOR63
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
	ldr	r3, .L286
	ldr	r2, .L286+4
	ldr	r3, [r3]
	ldrh	r2, [r2]
	add	r2, r3, r2, lsl #1
.L282:
	cmp	r3, r2
	bne	.L284
	movs	r0, #0
	bx	lr
.L284:
	ldrh	r1, [r3], #2
	cmp	r1, r0
	bne	.L282
	movs	r0, #1
	bx	lr
.L287:
	.align	2
.L286:
	.word	.LANCHOR68
	.word	.LANCHOR69
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
	ldr	r4, .L292
	ubfx	r0, r0, #10, #16
	mov	r6, r1
	mov	r7, r2
	bl	P2V_block_in_plane
	ldr	r3, .L292+4
	ldrh	r1, [r4]
	ldr	r2, [r3]
	movs	r3, #0
.L289:
	uxth	ip, r3
	cmp	ip, r1
	bcc	.L291
	bne	.L290
	strh	r0, [r2, ip, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L290
.L291:
	adds	r3, r3, #1
	add	ip, r2, r3, lsl #1
	ldrh	ip, [ip, #-2]
	cmp	ip, r0
	bne	.L289
.L290:
	ldr	r2, .L292+8
	movs	r0, #12
	ldr	r1, .L292+12
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
.L293:
	.align	2
.L292:
	.word	.LANCHOR69
	.word	.LANCHOR68
	.word	.LANCHOR70
	.word	.LANCHOR71
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
	ldr	r4, .L297
	ldrh	r5, [r4]
	cmp	r5, r0
	beq	.L295
	ldr	r3, .L297+4
	ldrh	r1, [r3]
	cmp	r0, r1
	beq	.L295
	movw	r2, #65535
	cmp	r5, r2
	bne	.L296
	strh	r0, [r4]	@ movhi
.L295:
	movs	r0, #0
	pop	{r4, r5, pc}
.L296:
	cmp	r1, r2
	it	eq
	strheq	r0, [r3]	@ movhi
	b	.L295
.L298:
	.align	2
.L297:
	.word	.LANCHOR72
	.word	.LANCHOR73
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
	bl	FtlGcRefreshBlock
	ldr	r2, .L303
	movs	r1, #0
	ldr	r5, .L303+4
	ldrh	r3, [r2]
.L300:
	uxth	r0, r1
	cmp	r3, r0
	bhi	.L302
	cmp	r3, #15
	itttt	ls
	addls	r1, r3, #1
	strhls	r1, [r2]	@ movhi
	ldrls	r2, .L303+4
	strhls	r4, [r2, r3, lsl #1]	@ movhi
	b	.L301
.L302:
	adds	r1, r1, #1
	add	r0, r5, r1, lsl #1
	ldrh	r0, [r0, #-2]
	cmp	r0, r4
	bne	.L300
.L301:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L304:
	.align	2
.L303:
	.word	.LANCHOR74
	.word	.LANCHOR75
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
	ldr	r3, .L311
	push	{r4, lr}
	ldrh	r3, [r3]
	cbz	r3, .L306
	ldr	r2, .L311+4
	ldrh	r1, [r2]
	movw	r2, #65535
	cmp	r1, r2
	bne	.L306
	ldr	r4, .L311+8
	ldrh	r2, [r4]
	cmp	r2, r3
	itt	cs
	movcs	r3, #0
	strhcs	r3, [r4]	@ movhi
	ldr	r3, .L311+12
	ldrh	r2, [r4]
	ldrh	r0, [r3, r2, lsl #1]
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
.L306:
	movs	r0, #0
	pop	{r4, pc}
.L312:
	.align	2
.L311:
	.word	.LANCHOR74
	.word	.LANCHOR72
	.word	.LANCHOR76
	.word	.LANCHOR75
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
.L316:
	cmp	r4, r10
	bcc	.L322
	ldr	r0, .L325
	pop	{r4, r5, r6, r7, r8, r10, fp, lr}
	b	printf
.L322:
	cbnz	r5, .L317
	mov	r2, r6
	mov	r1, fp
	ldr	r0, .L325+4
	bl	printf
.L317:
	cmp	r8, #4
	bne	.L318
	ldr	r1, [r7, r4, lsl #2]
.L324:
	ldr	r0, .L325+8
.L323:
	adds	r5, r5, #1
	bl	printf
	cmp	r5, #15
	bls	.L321
	movs	r5, #0
	ldr	r0, .L325
	bl	printf
.L321:
	adds	r4, r4, #1
	add	r6, r6, r8
	b	.L316
.L318:
	cmp	r8, #2
	bne	.L320
	ldrh	r1, [r7, r4, lsl #1]
	b	.L324
.L320:
	ldrb	r1, [r7, r4]	@ zero_extendqisi2
	ldr	r0, .L325+12
	b	.L323
.L326:
	.align	2
.L325:
	.word	.LC5
	.word	.LC2
	.word	.LC3
	.word	.LC4
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
	ldr	r6, .L343
	add	r8, r0, #4
	movs	r7, #0
	ldr	fp, .L343+20
	ldrh	r10, [r6, #12]
	str	r2, [sp]
	lsl	r3, r10, #3
	str	r3, [sp, #4]
.L328:
	ldr	r3, [sp]
	cmp	r7, r3
	beq	.L342
	add	r2, sp, #8
	add	r1, sp, #12
	ldr	r0, [r8]
	bl	l2p_addr_tran.isra.0
	ldr	r5, [sp, #8]
	cbnz	r5, .L329
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #4]
	cmp	r3, r2
	bls	.L329
	ldr	r6, .L343+4
	ldr	r7, .L343+8
.L330:
	ldr	r3, [sp]
	adds	r4, r4, #20
	cmp	r5, r3
	bne	.L331
.L342:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L331:
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
	ldr	r0, .L343+12
	bl	rknand_print_hex
	movs	r3, #4
	ldr	r1, [r4, #-8]
	mov	r2, r3
	ldr	r0, .L343+16
	bl	rknand_print_hex
	b	.L330
.L329:
	ldr	r2, [fp, #4]
	uxtb	r0, r5
	ldr	r1, [sp, #12]
	blx	r2
	cbnz	r0, .L332
	str	r0, [r8, #-4]
.L333:
	ldrh	r2, [r6, #14]
	cmp	r2, #4
	bne	.L335
	ldr	r1, [sp, #12]
	ldr	r2, [fp, #4]
	ldrb	r0, [sp, #8]	@ zero_extendqisi2
	add	r1, r1, r10
	blx	r2
	cbz	r0, .L335
	mov	r2, #-1
	str	r2, [r8, #-4]
.L335:
	adds	r7, r7, #1
	add	r8, r8, #20
	b	.L328
.L332:
	mov	r2, #-1
	str	r2, [r8, #-4]
	b	.L333
.L344:
	.align	2
.L343:
	.word	.LANCHOR0
	.word	.LANCHOR77
	.word	.LC6
	.word	.LC7
	.word	.LC8
	.word	.LANCHOR78
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
	bhi	.L345
	ldr	r4, .L354
	ldrh	r3, [r4, #6]
	cmp	r3, #1024
	beq	.L345
	cbz	r1, .L347
	bl	P2V_block_in_plane
	ldr	r3, .L354+4
	mov	r6, r0
	movs	r2, #1
	mov	r1, r2
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r3, .L354+8
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	ldr	r2, .L354+12
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L347:
	ldrh	r3, [r4, #6]
	adds	r3, r3, #1
	strh	r3, [r4, #6]	@ movhi
	ldrh	r3, [r4, #4]
	adds	r2, r3, #4
	adds	r3, r3, #1
	ubfx	r3, r3, #0, #10
	strh	r5, [r4, r2, lsl #1]	@ movhi
	strh	r3, [r4, #4]	@ movhi
.L345:
	pop	{r4, r5, r6, pc}
.L355:
	.align	2
.L354:
	.word	.LANCHOR38
	.word	.LANCHOR79
	.word	.LANCHOR43
	.word	.LANCHOR80
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
	ldr	r4, .L361
	ldrh	r2, [r4, #6]
	cbz	r2, .L360
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
	ldr	r3, .L361+4
	ldr	r0, [r3]
	lsls	r3, r5, #10
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
	ldr	r2, .L361+8
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
.L357:
	subs	r3, r5, #1
	movw	r2, #65533
	uxth	r3, r3
	cmp	r3, r2
	bls	.L358
	ldrh	r2, [r4, #6]
	mov	r1, r5
	ldr	r0, .L361+12
	bl	printf
.L359:
	b	.L359
.L360:
	movw	r5, #65535
	b	.L357
.L358:
	mov	r0, r5
	pop	{r3, r4, r5, pc}
.L362:
	.align	2
.L361:
	.word	.LANCHOR38
	.word	.LANCHOR79
	.word	.LANCHOR80
	.word	.LC9
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
.L364:
	uxth	r5, r3
	cmp	r5, r1
	bcs	.L367
	mov	r7, r2
	adds	r3, r3, #1
	ldrh	r6, [r7]
	adds	r2, r2, #2
	cmp	r6, #0
	bne	.L364
	bl	FtlFreeSysBlkQueueOut
	subs	r3, r0, #1
	movw	r2, #65533
	uxth	r3, r3
	mov	r1, r0
	strh	r0, [r7]	@ movhi
	cmp	r3, r2
	bls	.L365
	ldr	r3, .L371
	ldr	r0, .L371+4
	ldrh	r2, [r3, #6]
	bl	printf
.L366:
	b	.L366
.L365:
	ldr	r3, [r4, #28]
	strh	r6, [r4, #2]	@ movhi
	strh	r5, [r4]	@ movhi
	adds	r3, r3, #1
	str	r3, [r4, #28]
	ldrh	r3, [r4, #8]
	adds	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
.L367:
	ldrh	r3, [r4, #10]
	cmp	r3, r5
	bhi	.L369
	movw	r2, #578
	ldr	r1, .L371+8
	ldr	r0, .L371+12
	bl	printf
.L369:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, pc}
.L372:
	.align	2
.L371:
	.word	.LANCHOR38
	.word	.LC10
	.word	.LANCHOR81
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
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, .L379
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r4, #0
	ldr	r2, .L379+4
	movs	r6, #12
	str	r4, [r3]
	ldr	r3, .L379+8
	ldr	r5, .L379+12
	ldr	r10, .L379+292
	str	r4, [r3]
	ldr	r3, .L379+16
	ldrh	r0, [r5]
	ldr	r8, .L379+296
	str	r4, [r3]
	ldr	r3, .L379+20
	lsls	r0, r0, #1
	ldr	fp, .L379+300
	str	r4, [r3]
	ldr	r3, .L379+24
	str	r4, [r3]
	ldr	r3, .L379+28
	str	r4, [r3]
	ldr	r3, .L379+32
	str	r4, [r3]
	ldr	r3, .L379+36
	str	r4, [r3]
	ldr	r3, .L379+40
	str	r4, [r3]
	ldr	r3, .L379+44
	str	r4, [r3]
	ldr	r3, .L379+48
	str	r4, [r3]
	ldr	r3, .L379+52
	str	r4, [r3]
	ldr	r3, .L379+56
	str	r4, [r3]
	ldr	r3, .L379+60
	str	r4, [r3]
	ldr	r3, .L379+64
	str	r4, [r3]
	movw	r3, #65535
	str	r3, [r2]
	ldr	r2, .L379+68
	str	r4, [r2]
	ldr	r2, .L379+72
	str	r4, [r2]
	ldr	r2, .L379+76
	str	r4, [r2]
	ldr	r2, .L379+80
	strh	r3, [r2]	@ movhi
	ldr	r2, .L379+84
	strh	r3, [r2]	@ movhi
	movs	r2, #32
	ldr	r3, .L379+88
	strh	r2, [r3]	@ movhi
	movs	r2, #128
	ldr	r3, .L379+92
	strh	r2, [r3]	@ movhi
	ldr	r3, .L379+96
	strh	r4, [r3]	@ movhi
	ldr	r3, .L379+100
	strh	r4, [r3]	@ movhi
	ldr	r3, .L379+104
	strh	r4, [r3]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L379+108
	str	r0, [r3]
	ldrh	r0, [r5]
	movs	r5, #20
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L379+112
	str	r0, [r3]
	ldrh	r3, [r10]
	muls	r5, r3, r5
	lsls	r7, r5, #2
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L379+116
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L379+120
	str	r0, [r3]
	mov	r0, r7
	bl	ftl_malloc
	ldr	r3, .L379+124
	ldr	r7, .L379+128
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L379+132
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L379+136
	ldrh	r5, [r7]
	str	r0, [r3]
	ldrh	r3, [r10]
	mov	r0, r5
	lsls	r3, r3, #1
	adds	r3, r3, #1
	str	r3, [r8]
	bl	ftl_malloc
	ldr	r3, .L379+140
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L379+144
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L379+148
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r5, r0
	bl	ftl_malloc
	ldr	r3, .L379+152
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L379+156
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L379+160
	str	r0, [r3]
	ldr	r0, [r8]
	muls	r0, r6, r0
	bl	ftl_malloc
	ldr	r3, .L379+164
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L379+168
	str	r0, [r3]
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L379+172
	str	r0, [r3]
	ldr	r3, .L379+176
	ldrh	r0, [r3]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L379+180
	ldrh	r5, [r10]
	ldr	r10, .L379+304
	str	r0, [r3]
	ldrh	r3, [fp]
	muls	r5, r3, r5
	mov	r0, r5
	bl	ftl_malloc
	ldr	r3, .L379+184
	str	r0, [r3]
	lsls	r0, r5, #2
	ldr	r5, .L379+188
	bl	ftl_malloc
	ldr	r3, .L379+192
	str	r0, [r3]
	ldrh	r3, [fp]
	ldr	r0, [r8]
	ldr	r8, .L379+308
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L379+196
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	uxth	r0, r0
	strh	r0, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L379+200
	str	r0, [r3]
	ldrh	r3, [r8]
	ldr	r0, .L379+204
	addw	r3, r3, #547
	lsrs	r3, r3, #9
	and	r0, r0, r3, lsl #9
	strh	r3, [r8]	@ movhi
	bl	ftl_malloc
	ldr	r3, .L379+208
	str	r0, [r3]
	adds	r0, r0, #32
	ldr	r3, .L379+212
	str	r0, [r3]
	ldrh	r0, [r5]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L379+216
	str	r0, [r3]
	ldr	r3, [r10]
	lsl	r8, r3, #1
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L379+220
	str	r0, [r3]
	mov	r0, r8
	bl	ftl_malloc
	ldr	r3, .L379+224
	ldr	r8, .L379+312
	str	r0, [r3]
	ldrh	r0, [r5]
	lsrs	r0, r0, #3
	adds	r0, r0, #4
	bl	ftl_malloc
	ldr	r3, .L379+228
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L379+232
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #1
	bl	ftl_malloc
	ldr	r3, .L379+236
	str	r0, [r3]
	ldrh	r0, [r8]
	ldr	r8, .L379+316
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L379+240
	str	r0, [r3]
	ldrh	r0, [r8]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldrh	r2, [r8]
	mov	r1, r4
	ldr	r3, .L379+244
	ldr	r4, .L379+248
	lsls	r2, r2, #2
	str	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L379+252
	ldrh	r0, [r3]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L379+256
	str	r0, [r3]
	ldr	r0, [r10]
	lsls	r0, r0, #2
	bl	ftl_malloc
	ldr	r3, .L379+260
	str	r0, [r3]
	ldrh	r0, [r4]
	muls	r0, r6, r0
	ldr	r6, .L379+264
	bl	ftl_malloc
	ldr	r3, .L379+268
	str	r0, [r3]
	ldrh	r3, [r4]
	ldrh	r0, [r7]
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L379+272
	str	r0, [r3]
	movs	r0, #6
	ldrh	r3, [r5]
	ldr	r5, .L379+276
	muls	r0, r3, r0
	bl	ftl_malloc
	ldr	r3, .L379+280
	str	r0, [r3]
	ldr	r3, .L379+284
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
	ldr	r3, .L379+288
	ldrh	r6, [r6]
	lsls	r1, r1, #2
	mov	r4, r3
	str	r0, [r4, #28]!
	mov	r0, r1
	b	.L380
.L381:
	.align	2
.L379:
	.word	.LANCHOR82
	.word	.LANCHOR96
	.word	.LANCHOR83
	.word	.LANCHOR21
	.word	.LANCHOR84
	.word	.LANCHOR85
	.word	.LANCHOR86
	.word	.LANCHOR87
	.word	.LANCHOR88
	.word	.LANCHOR89
	.word	.LANCHOR90
	.word	.LANCHOR91
	.word	.LANCHOR80
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR94
	.word	.LANCHOR95
	.word	.LANCHOR97
	.word	.LANCHOR98
	.word	.LANCHOR99
	.word	.LANCHOR72
	.word	.LANCHOR73
	.word	.LANCHOR100
	.word	.LANCHOR101
	.word	.LANCHOR102
	.word	.LANCHOR74
	.word	.LANCHOR76
	.word	.LANCHOR68
	.word	.LANCHOR71
	.word	.LANCHOR103
	.word	.LANCHOR104
	.word	.LANCHOR105
	.word	.LANCHOR23
	.word	.LANCHOR79
	.word	.LANCHOR66
	.word	.LANCHOR106
	.word	.LANCHOR107
	.word	.LANCHOR108
	.word	.LANCHOR64
	.word	.LANCHOR109
	.word	.LANCHOR110
	.word	.LANCHOR63
	.word	.LANCHOR111
	.word	.LANCHOR112
	.word	.LANCHOR12
	.word	.LANCHOR113
	.word	.LANCHOR114
	.word	.LANCHOR6
	.word	.LANCHOR115
	.word	.LANCHOR65
	.word	.LANCHOR117
	.word	33553920
	.word	.LANCHOR118
	.word	.LANCHOR43
	.word	.LANCHOR42
	.word	.LANCHOR119
	.word	.LANCHOR120
	.word	.LANCHOR1
	.word	.LANCHOR36
	.word	.LANCHOR121
	.word	.LANCHOR122
	.word	.LANCHOR123
	.word	.LANCHOR33
	.word	.LANCHOR32
	.word	.LANCHOR124
	.word	.LANCHOR125
	.word	.LANCHOR10
	.word	.LANCHOR55
	.word	.LANCHOR126
	.word	.LANCHOR127
	.word	.LANCHOR40
	.word	.LANCHOR17
	.word	.LANCHOR37
	.word	.LANCHOR3
	.word	.LANCHOR67
	.word	.LANCHOR24
	.word	.LANCHOR30
	.word	.LANCHOR116
	.word	.LANCHOR27
	.word	.LANCHOR28
.L380:
.L375:
	cmp	r2, r6
	bcc	.L376
	add	r3, r3, r2, lsl #2
	ldr	r2, .L382
	movs	r1, #0
	adds	r3, r3, #24
.L377:
	cmp	r3, r2
	bne	.L378
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L376:
	ldr	r5, [r3, #28]
	adds	r2, r2, #1
	add	r5, r5, r0
	add	r0, r0, r1
	str	r5, [r4, #4]!
	b	.L375
.L378:
	str	r1, [r3, #4]!
	b	.L377
.L383:
	.align	2
.L382:
	.word	.LANCHOR37+56
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
	ldr	r3, .L390
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, r0
	ldr	r7, .L390+4
	mov	r6, r1
	subs	r4, r5, #2
	addw	r5, r5, #1022
	ldrh	r2, [r3]
	movs	r1, #0
	ldr	r8, .L390+12
	mov	r0, r6
	lsls	r2, r2, #2
	bl	ftl_memset
.L387:
	ldrh	r3, [r4, #2]
	movw	r2, #65535
	cmp	r3, r2
	beq	.L384
	ldrh	r2, [r7]
	cmp	r2, r3
	bhi	.L386
	movs	r2, #74
	mov	r1, r8
	ldr	r0, .L390+8
	bl	printf
.L386:
	ldrh	r3, [r4, #2]!
	movs	r2, #1
	cmp	r5, r4
	lsr	r1, r3, #5
	and	r3, r3, #31
	lsl	r3, r2, r3
	ldr	r2, [r6, r1, lsl #2]
	orr	r2, r2, r3
	str	r2, [r6, r1, lsl #2]
	bne	.L387
.L384:
	pop	{r4, r5, r6, r7, r8, pc}
.L391:
	.align	2
.L390:
	.word	.LANCHOR127
	.word	.LANCHOR17
	.word	.LC1
	.word	.LANCHOR128
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
	ldr	r0, .L393
	movw	r3, #65535
	movs	r2, #16
	movs	r1, #255
	strh	r3, [r0]	@ movhi
	movs	r3, #0
	strh	r3, [r0, #6]	@ movhi
	adds	r0, r0, #12
	b	ftl_memset
.L394:
	.align	2
.L393:
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
	ldr	r3, .L396
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
.L397:
	.align	2
.L396:
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
.L399:
	ldrh	r1, [r4, #6]
	uxth	r2, r3
	cmp	r1, r2
	bhi	.L403
	ldr	r3, .L418
	movs	r6, #0
	mov	r10, r6
	ldrh	r2, [r3]
	ldrh	r3, [r4]
	strh	r2, [r5, r3, lsl #1]	@ movhi
	mov	r2, r6
	ldrh	fp, [r5]
.L404:
	ldrh	r3, [r4, #10]
	uxth	ip, r6
	cmp	r3, ip
	bhi	.L408
	mov	r0, r10
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L403:
	uxth	r2, r3
	ldr	r1, [r6, r2, lsl #2]
	movs	r2, #0
	ubfx	r1, r1, #10, #16
.L400:
	ldrh	ip, [r4, #10]
	uxth	r0, r2
	cmp	ip, r0
	bhi	.L402
	adds	r3, r3, #1
	b	.L399
.L402:
	uxth	r0, r2
	ldrh	ip, [r7, r0, lsl #1]
	cmp	ip, r1
	bne	.L401
	cbz	r1, .L401
	ldrh	ip, [r5, r0, lsl #1]
	add	ip, ip, #1
	strh	ip, [r5, r0, lsl #1]	@ movhi
.L401:
	adds	r2, r2, #1
	b	.L400
.L408:
	uxth	r1, r6
	ldrh	r3, [r5, r1, lsl #1]
	lsl	r8, r1, #1
	cmp	fp, r3
	bls	.L405
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cbnz	r0, .L406
.L407:
	adds	r6, r6, #1
	b	.L404
.L405:
	cmp	r3, #0
	bne	.L407
	ldrh	r0, [r7, r1, lsl #1]
	add	r8, r8, r7
	cmp	r0, #0
	beq	.L407
.L409:
	movs	r1, #1
	str	r2, [sp, #4]
	bl	FtlFreeSysBlkQueueIn
	ldr	r2, [sp, #4]
	strh	r2, [r8]	@ movhi
	ldrh	r3, [r4, #8]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	b	.L407
.L406:
	mov	r10, ip
	mov	fp, r3
	cmp	r3, #0
	beq	.L409
	b	.L407
.L419:
	.align	2
.L418:
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
	ldr	r5, .L423
	ldr	r4, .L423+4
	ldr	r2, [r5]
	ldr	r7, .L423+8
	ldr	r6, .L423+12
	ldr	r0, [r4]
	lsls	r2, r2, #1
	ldr	r8, .L423+44
	bl	ftl_memset
	ldrh	r3, [r7]
	movs	r1, #255
	ldrh	r2, [r6]
	ldr	r0, [r8]
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L423+16
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
.L421:
	adds	r2, r2, #12
	adds	r6, r3, r7
	cmp	r2, r1
	bne	.L422
	ldr	r3, .L423+20
	ldr	r2, [r5]
	strh	r0, [r3, #2]	@ movhi
	strh	r2, [r3, #10]	@ movhi
	movw	r2, #61634
	strh	r2, [r3, #4]	@ movhi
	ldr	r2, .L423+24
	strh	r0, [r3]	@ movhi
	ldrh	r2, [r2]
	strh	r2, [r3, #8]	@ movhi
	ldr	r2, .L423+28
	ldrh	r2, [r2]
	strh	r2, [r3, #6]	@ movhi
	ldr	r2, .L423+32
	ldr	r2, [r2]
	str	r2, [r3, #12]
	ldr	r2, .L423+36
	ldr	r2, [r2]
	str	r2, [r3, #16]
	ldr	r2, [r4]
	str	r2, [r3, #20]
	ldr	r2, .L423+40
	ldr	r2, [r2]
	str	r2, [r3, #24]
	pop	{r4, r5, r6, r7, r8, pc}
.L422:
	bic	r3, r3, #3
	str	lr, [r2, #-8]
	add	r3, r3, ip
	strh	r0, [r2, #-12]	@ movhi
	str	r3, [r2, #-4]
	mov	r3, r6
	b	.L421
.L424:
	.align	2
.L423:
	.word	.LANCHOR30
	.word	.LANCHOR120
	.word	.LANCHOR23
	.word	.LANCHOR33
	.word	.LANCHOR55
	.word	.LANCHOR129
	.word	.LANCHOR130
	.word	.LANCHOR32
	.word	.LANCHOR119
	.word	.LANCHOR125
	.word	.LANCHOR124
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
	movw	r2, #65535
	ldr	r3, .L426
	movs	r4, #0
	mov	r1, r4
	ldr	r5, .L426+4
	strh	r2, [r3]	@ movhi
	mov	r2, #-1
	ldr	r3, .L426+8
	str	r4, [r3]
	ldr	r3, .L426+12
	str	r4, [r3]
	ldr	r3, .L426+16
	str	r2, [r3]
	ldr	r3, .L426+20
	strh	r4, [r3]	@ movhi
	ldr	r3, .L426+24
	ldrh	r2, [r3]
	ldr	r3, .L426+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L426+32
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r5]
	mov	r1, r4
	ldr	r3, .L426+36
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	mov	r1, r4
	movs	r2, #48
	ldr	r0, .L426+40
	bl	ftl_memset
	mov	r2, #512
	mov	r1, r4
	ldr	r0, .L426+44
	bl	ftl_memset
	bl	FtlGcBufInit
	bl	FtlL2PDataInit
	mov	r0, r4
	pop	{r3, r4, r5, pc}
.L427:
	.align	2
.L426:
	.word	.LANCHOR131
	.word	.LANCHOR6
	.word	.LANCHOR132
	.word	.LANCHOR133
	.word	.LANCHOR134
	.word	.LANCHOR35
	.word	.LANCHOR27
	.word	.LANCHOR36
	.word	.LANCHOR43
	.word	.LANCHOR117
	.word	.LANCHOR39
	.word	.LANCHOR135
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
	ldr	r3, .L439
	movs	r1, #0
	movs	r4, #0
	ldr	r6, .L439+4
	mov	r8, r4
	ldrh	r3, [r3]
	mov	r5, r4
	ldr	r0, [r6]
	mov	r10, r6
	muls	r2, r3, r2
	bl	ftl_memset
	ldr	r3, .L439+8
	ldr	r2, .L439+12
	str	r4, [r3]
	ldr	r3, .L439+16
	strh	r4, [r2]	@ movhi
	str	r2, [sp, #4]
	str	r4, [r3]
	ldr	r3, .L439+20
	str	r4, [r3]
	ldr	r3, .L439+24
	mov	fp, r3
	strh	r4, [r3]	@ movhi
.L429:
	ldr	r3, .L439+28
	uxth	r7, r4
	ldrh	r3, [r3]
	cmp	r7, r3
	bcs	.L436
	ldr	r3, .L439+32
	ldrh	r2, [r3]
	ldr	r3, .L439+36
	ldrh	r3, [r3]
	str	r3, [sp]
	movs	r3, #0
	mov	r6, r3
	b	.L437
.L431:
	str	r2, [sp, #12]
	mov	r1, r7
	ldr	r2, .L439+40
	str	r3, [sp, #8]
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	bl	FtlBbmIsBadBlock
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #12]
	cbnz	r0, .L430
	ldr	r1, [sp]
	add	r6, r6, r1
	uxth	r6, r6
.L430:
	adds	r3, r3, #1
.L437:
	uxth	r1, r3
	cmp	r2, r1
	bhi	.L431
	uxth	r3, r4
	cbz	r6, .L432
	mov	r1, r6
	str	r3, [sp]
	mov	r0, #32768
	bl	__aeabi_idiv
	ldr	r3, [sp]
	uxth	r6, r0
.L433:
	ldr	r1, [r10]
	movs	r2, #6
	mla	r2, r2, r3, r1
	strh	r6, [r2, #4]	@ movhi
	ldr	r2, .L439+44
	ldrh	r2, [r2]
	cmp	r2, r7
	beq	.L434
	ldr	r2, .L439+48
	ldrh	r2, [r2]
	cmp	r2, r7
	beq	.L434
	ldr	r2, .L439+52
	ldrh	r2, [r2]
	cmp	r2, r7
	beq	.L434
	ldr	r2, .L439+56
	ldr	r2, [r2]
	ldrh	r3, [r2, r3, lsl #1]
	cbnz	r3, .L435
	add	r8, r8, #1
	mov	r0, r7
	uxth	r8, r8
	bl	INSERT_FREE_LIST
.L434:
	adds	r4, r4, #1
	b	.L429
.L432:
	ldr	r2, .L439+56
	movw	r1, #65535
	ldr	r2, [r2]
	strh	r1, [r2, r3, lsl #1]	@ movhi
	b	.L433
.L435:
	adds	r5, r5, #1
	mov	r0, r7
	uxth	r5, r5
	bl	INSERT_DATA_LIST
	b	.L434
.L436:
	ldr	r2, [sp, #4]
	strh	r8, [fp]	@ movhi
	strh	r5, [r2]	@ movhi
	add	r5, r5, r8
	cmp	r5, r3
	ble	.L438
	movw	r2, #2216
	ldr	r1, .L439+60
	ldr	r0, .L439+64
	bl	printf
.L438:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L440:
	.align	2
.L439:
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
	.word	.LANCHOR136
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
	ldr	r2, .L442
	movs	r3, #0
	push	{r4, lr}
	movs	r1, #255
	ldr	r4, .L442+4
	strh	r3, [r2]	@ movhi
	ldr	r2, .L442+8
	strh	r3, [r2]	@ movhi
	ldrh	r2, [r4]
	ldr	r3, .L442+12
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r3, [r4]
	movs	r2, #12
	movs	r1, #255
	muls	r2, r3, r2
	ldr	r3, .L442+16
	ldr	r0, [r3]
	bl	ftl_memset
	pop	{r4, lr}
	b	FtlGcBufInit
.L443:
	.align	2
.L442:
	.word	.LANCHOR69
	.word	.LANCHOR21
	.word	.LANCHOR70
	.word	.LANCHOR68
	.word	.LANCHOR71
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
	ldr	r3, .L451
	mov	r1, r5
	mov	r0, r4
	ldr	r3, [r3]
	blx	r3
	uxth	r0, r0
	cmp	r0, #50
	bls	.L445
	mov	r2, #256
	movs	r1, #255
	mov	r0, r4
	bl	ftl_memset
	movs	r0, #0
.L445:
	ldr	r3, .L451+4
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	bne	.L450
	add	r1, r4, r0, lsl #1
	mov	r3, r4
.L447:
	cmp	r3, r1
	bne	.L448
.L450:
	pop	{r3, r4, r5, pc}
.L448:
	ldrh	r2, [r3]
	lsrs	r2, r2, #1
	strh	r2, [r3], #2	@ movhi
	b	.L447
.L452:
	.align	2
.L451:
	.word	.LANCHOR78
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
	ldr	r3, .L482
	mov	r4, r0
	mov	r10, #0
	ldrh	r2, [r3, #12]
	str	r3, [sp, #4]
	str	r2, [sp]
.L455:
	cmp	r10, fp
	bne	.L466
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L466:
	ldr	r3, [r4, #8]
	cbz	r3, .L456
	ldr	r3, [r4, #12]
	cbnz	r3, .L457
.L456:
	movs	r2, #90
	ldr	r1, .L482+4
	ldr	r0, .L482+8
	bl	printf
.L457:
	add	r2, sp, #8
	add	r1, sp, #12
	ldr	r0, [r4, #4]
	bl	l2p_addr_tran.isra.0
	ldr	r0, [sp, #8]
	cmp	r0, #3
	bls	.L458
	mov	r3, #-1
	str	r3, [r4]
.L459:
	add	r10, r10, #1
	adds	r4, r4, #20
	b	.L455
.L458:
	ldr	r5, [r4, #8]
	uxtb	r0, r0
	ldr	r8, .L482+20
	ldr	r7, .L482+12
	tst	r5, #63
	ldr	r3, [r4, #12]
	it	ne
	ldrne	r5, [r8]
	ldr	r1, [sp, #12]
	ldr	r6, [r7, #12]
	mov	r2, r5
	blx	r6
	ldr	r3, [sp, #4]
	str	r0, [r4]
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	bne	.L462
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
	beq	.L463
	ldr	r3, [r4, #12]
	ldr	r2, [r3, #12]
	adds	r2, r2, #1
	bne	.L464
	ldr	r2, [r3, #8]
	adds	r2, r2, #1
	bne	.L464
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L464
.L463:
	mov	r3, #-1
	str	r3, [r4]
.L464:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L462
	cmp	r0, #256
	it	eq
	streq	r0, [r4]
.L462:
	ldr	r3, [r8]
	cmp	r5, r3
	bne	.L459
	ldr	r0, [r4, #8]
	cmp	r5, r0
	beq	.L459
	ldr	r3, .L482+16
	mov	r1, r5
	ldrh	r2, [r3]
	lsls	r2, r2, #9
	bl	ftl_memcpy
	b	.L459
.L483:
	.align	2
.L482:
	.word	.LANCHOR0
	.word	.LANCHOR137
	.word	.LC1
	.word	.LANCHOR78
	.word	.LANCHOR12
	.word	.LANCHOR111
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
	ldr	r3, .L494
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r6, #0
	ldr	r5, .L494+4
	ldr	r3, [r3]
	ldr	r7, .L494+8
	ldr	r10, .L494+20
	str	r3, [r5, #8]
	ldr	r3, .L494+12
	ldr	r8, [r3]
	str	r8, [r5, #12]
.L485:
	ldr	r3, .L494+16
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L490
	movs	r0, #0
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L490:
	ldrh	r4, [r10]
	movw	r3, #65535
	ldr	fp, .L494+4
	strh	r3, [r7, #2]!	@ movhi
	subs	r4, r4, #1
	uxth	r4, r4
.L486:
	ldrh	r3, [r10]
	sub	r2, r3, #15
	cmp	r2, r4
	bgt	.L488
	mla	r3, r6, r3, r4
	movs	r2, #1
	mov	r1, r2
	mov	r0, fp
	lsls	r3, r3, #10
	str	r3, [r5, #4]
	bl	FlashReadPages
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L487
	ldrh	r2, [r8]
	movw	r3, #61664
	cmp	r2, r3
	bne	.L487
	strh	r4, [r7]	@ movhi
.L488:
	adds	r6, r6, #1
	b	.L485
.L487:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L486
.L495:
	.align	2
.L494:
	.word	.LANCHOR106
	.word	.LANCHOR138
	.word	.LANCHOR37+10
	.word	.LANCHOR114
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
	ldreq	r3, .L508
	sub	sp, sp, #88
	lsl	r7, r0, #10
	mov	r2, r1
	it	ne
	ldrne	r3, .L508+4
	mov	r6, r1
	add	r0, sp, #4
	movs	r1, #1
	ldrh	r5, [r3]
	ldr	r3, .L508+8
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
	bne	.L499
	mov	r8, #0
.L500:
	cmp	r8, r5
	ble	.L503
.L499:
	mov	r0, r5
	add	sp, sp, #88
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L503:
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
	bne	.L501
	ldr	r3, [sp, #28]
	adds	r3, r3, #1
	bne	.L501
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	beq	.L501
	subs	r4, r4, #1
	sxth	r5, r4
	b	.L500
.L501:
	adds	r4, r4, #1
	sxth	r8, r4
	b	.L500
.L509:
	.align	2
.L508:
	.word	.LANCHOR20
	.word	.LANCHOR19
	.word	.LANCHOR112
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
	ldr	r5, .L591
	sub	sp, sp, #32
	mov	r1, r4
	ldr	r3, .L591+4
	ldr	r2, [r5]
	ldr	r6, .L591+8
	strh	r4, [r3]	@ movhi
	ldr	r3, .L591+12
	lsls	r2, r2, #2
	strh	r4, [r6]	@ movhi
	ldr	r7, .L591+16
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r2, [r5]
	mov	r1, r4
	ldr	r3, .L591+20
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L591+24
	lsls	r2, r2, #2
	ldr	r0, [r3]
	bl	ftl_memset
	ldrh	r2, [r7]
	mov	r1, r4
	ldr	r3, .L591+28
	lsls	r2, r2, #1
	ldr	r0, [r3]
	bl	ftl_memset
	movs	r2, #16
	movs	r1, #255
	ldr	r0, .L591+32
	bl	ftl_memset
	ldr	r3, .L591+36
	str	r6, [sp, #12]
	str	r5, [sp, #16]
	ldrh	r3, [r3]
	str	r3, [sp, #4]
.L511:
	ldr	r3, .L591+40
	ldr	r2, [sp, #4]
	ldrh	r3, [r3]
	cmp	r3, r2
	bls	.L552
	ldr	r3, .L591+44
	movs	r5, #0
	ldr	r1, .L591+48
	mov	fp, r5
	movs	r7, #20
	ldrh	r8, [r3]
	ldr	r3, .L591+52
	ldr	r2, [r1]
	ldr	r1, .L591+56
	ldr	r6, [r3]
	ldr	r3, .L591+60
	str	r2, [sp, #8]
	ldrh	r10, [r1]
	ldr	r3, [r3]
	ldr	r2, .L591+64
	b	.L553
.L513:
	ldrb	r0, [r2, r5]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #28]
	str	r2, [sp, #24]
	bl	V2P_block
	str	r0, [sp, #20]
	bl	FtlBbmIsBadBlock
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #28]
	cbnz	r0, .L512
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
.L512:
	adds	r5, r5, #1
.L553:
	uxth	r1, r5
	cmp	r8, r1
	bhi	.L513
	cmp	fp, #0
	bne	.L514
.L551:
	ldr	r3, [sp, #4]
	adds	r3, r3, #1
	uxth	r3, r3
	str	r3, [sp, #4]
	b	.L511
.L514:
	movs	r7, #0
	movs	r2, #1
	mov	r1, fp
	mov	r0, r6
	bl	FlashReadPages
.L515:
	uxth	r3, r7
	cmp	fp, r3
	bls	.L551
	ldr	r3, .L591+52
	mov	r8, #20
	mul	r8, r8, r7
	ldr	r3, [r3]
	add	r2, r3, r8
	ldr	r3, [r3, r8]
	ldr	r5, [r2, #4]
	ldr	r6, [r2, #12]
	adds	r3, r3, #1
	ubfx	r5, r5, #10, #16
	bne	.L518
	mov	r10, #16
.L520:
	ldr	r3, .L591+52
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
	ldr	r3, .L591+52
	ldr	r3, [r3]
	bne	.L517
	mov	r2, #-1
	str	r2, [r3, r8]
	ldr	r3, .L591+52
	ldr	r3, [r3]
	ldr	r3, [r3, r8]
	cmp	r3, r2
	bne	.L518
.L519:
	movs	r1, #1
	b	.L590
.L517:
	ldr	r3, [r3, r8]
	adds	r3, r3, #1
	bne	.L518
	add	r10, r10, #-1
	uxth	r10, r10
	cmp	r10, #0
	bne	.L520
	b	.L519
.L518:
	ldr	r3, .L591+68
	ldr	r2, [r3]
	ldr	r3, [r6, #4]
	adds	r1, r2, #1
	beq	.L521
	cmp	r2, r3
	bhi	.L522
.L521:
	adds	r2, r3, #1
	ittt	ne
	ldrne	r1, .L591+68
	addne	r2, r3, #1
	strne	r2, [r1]
.L522:
	ldrh	r2, [r6]
	movw	r1, #61604
	cmp	r2, r1
	beq	.L524
	bhi	.L525
	movw	r3, #61574
	cmp	r2, r3
	beq	.L526
.L523:
	adds	r7, r7, #1
	b	.L515
.L525:
	movw	r3, #61634
	cmp	r2, r3
	beq	.L527
	movw	r3, #65535
	cmp	r2, r3
	bne	.L523
	movs	r1, #0
.L590:
	mov	r0, r5
	bl	FtlFreeSysBlkQueueIn
	b	.L523
.L527:
	ldr	r3, .L591+8
	ldrh	r2, [r3]
	ldr	r3, .L591
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L529
	movw	r2, #1225
	ldr	r1, .L591+72
	ldr	r0, .L591+76
	bl	printf
.L529:
	ldr	r3, [sp, #16]
	ldr	r2, [sp, #12]
	ldr	r1, [r3]
	ldrh	r0, [r2]
	ldr	r2, .L591+12
	uxth	r10, r1
	ldr	ip, [r2]
	add	r3, r10, #-1
	sub	r10, r10, r0
	add	r10, r10, #-1
	sxth	r3, r3
	sxth	r10, r10
.L530:
	cmp	r3, r10
	bgt	.L536
	cmp	r3, #0
	bge	.L568
	b	.L523
.L536:
	ldr	r2, [ip, r3, lsl #2]
	add	r8, ip, r3, lsl #2
	ldr	r4, [r6, #4]
	cmp	r4, r2
	bls	.L531
	ldr	r2, [ip]
	cbnz	r2, .L532
	cmp	r1, r0
	ittt	ne
	ldrne	r2, .L591+8
	addne	r0, r0, #1
	strhne	r0, [r2]	@ movhi
.L532:
	ldr	r2, .L591+20
	uxth	r10, r3
	ldr	r0, [r2]
	movs	r2, #0
.L533:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L534
	ldr	r2, [r6, #4]
	cmp	r3, #0
	str	r2, [r8]
	strh	r5, [r0, r3, lsl #1]	@ movhi
	blt	.L523
	ldr	r2, .L591+8
	ldrh	r0, [r2]
	ldr	r2, .L591
	ldr	r2, [r2]
	subs	r2, r2, r0
	subs	r2, r2, #1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L523
.L568:
	ldr	r2, .L591+8
	adds	r0, r0, #1
	strh	r0, [r2]	@ movhi
	ldr	r2, [r6, #4]
	str	r2, [ip, r3, lsl #2]
	ldr	r2, .L591+20
.L588:
	ldr	r2, [r2]
	strh	r5, [r2, r3, lsl #1]	@ movhi
	b	.L523
.L534:
	add	lr, ip, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, r0, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [ip, r1, lsl #2]
	strh	lr, [r0, r1, lsl #1]	@ movhi
	b	.L533
.L531:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L530
.L592:
	.align	2
.L591:
	.word	.LANCHOR30
	.word	.LANCHOR35
	.word	.LANCHOR130
	.word	.LANCHOR125
	.word	.LANCHOR27
	.word	.LANCHOR119
	.word	.LANCHOR122
	.word	.LANCHOR36
	.word	.LANCHOR139
	.word	.LANCHOR5
	.word	.LANCHOR6
	.word	.LANCHOR3
	.word	.LANCHOR65
	.word	.LANCHOR103
	.word	.LANCHOR24
	.word	.LANCHOR64
	.word	.LANCHOR13
	.word	.LANCHOR82
	.word	.LANCHOR140
	.word	.LC1
.L526:
	ldr	r8, .L593+12
	ldr	r10, .L593+20
	ldrh	r2, [r8]
	ldrh	r3, [r10]
	cmp	r2, r3
	bls	.L539
	movw	r2, #1266
	ldr	r1, .L593
	ldr	r0, .L593+4
	bl	printf
.L539:
	ldr	r2, .L593+8
	ldrh	lr, [r10]
	ldrh	ip, [r8]
	ldr	r0, [r2]
	add	r10, lr, #-1
	sxth	r3, r10
	sub	r10, r10, ip
.L540:
	cmp	r3, r10
	ble	.L545
	ldr	r1, [r6, #4]
	add	r8, r0, r3, lsl #2
	ldr	r2, [r0, r3, lsl #2]
	cmp	r1, r2
	bls	.L541
	ldr	r2, [r0]
	cbnz	r2, .L542
	cmp	lr, ip
	ittt	ne
	ldrne	r2, .L593+12
	addne	ip, ip, #1
	strhne	ip, [r2]	@ movhi
.L542:
	ldr	r2, .L593+16
	uxth	r10, r3
	ldr	ip, [r2]
	movs	r2, #0
.L543:
	uxth	lr, r2
	sxth	r1, r2
	cmp	r10, lr
	bhi	.L544
	ldr	r2, [r6, #4]
	str	r2, [r8]
	strh	r5, [ip, r3, lsl #1]	@ movhi
.L545:
	cmp	r3, #0
	blt	.L523
	ldr	r2, .L593+20
	ldr	ip, .L593+12
	ldrh	r2, [r2]
	ldrh	r1, [ip]
	subs	r2, r2, #1
	subs	r2, r2, r1
	sxth	r2, r2
	cmp	r3, r2
	bgt	.L523
	ldr	r2, [r6, #4]
	adds	r1, r1, #1
	strh	r1, [ip]	@ movhi
	str	r2, [r0, r3, lsl #2]
	ldr	r2, .L593+16
	b	.L588
.L544:
	add	lr, r0, r1, lsl #2
	adds	r2, r2, #1
	ldr	r4, [lr, #4]
	add	lr, ip, r1, lsl #1
	ldrh	lr, [lr, #2]
	str	r4, [r0, r1, lsl #2]
	strh	lr, [ip, r1, lsl #1]	@ movhi
	b	.L543
.L541:
	subs	r3, r3, #1
	sxth	r3, r3
	b	.L540
.L524:
	ldr	r8, .L593+40
	movw	r2, #65535
	ldrh	r1, [r8]
	cmp	r1, r2
	bne	.L547
.L589:
	strh	r5, [r8]	@ movhi
	str	r3, [r8, #8]
	b	.L523
.L547:
	ldrh	r0, [r8, #4]
	cmp	r0, r2
	beq	.L548
	movs	r1, #1
	bl	FtlFreeSysBlkQueueIn
.L548:
	ldr	r3, [r6, #4]
	ldr	r2, [r8, #8]
	cmp	r2, r3
	bcs	.L549
	ldrh	r2, [r8]
	strh	r2, [r8, #4]	@ movhi
	b	.L589
.L549:
	strh	r5, [r8, #4]	@ movhi
	b	.L523
.L552:
	ldr	r3, .L593+24
	ldr	r2, [r3]
	ldrh	r3, [r2]
	cbz	r3, .L554
.L557:
	ldr	r3, .L593+16
	ldr	r4, [r3]
	ldrh	r2, [r4]
	cmp	r2, #0
	beq	.L555
.L556:
	ldr	r3, .L593+28
	ldrh	r2, [r3]
	ldr	r3, .L593+32
	ldr	r3, [r3]
	cmp	r2, r3
	bls	.L587
	movw	r2, #1391
	ldr	r1, .L593
	ldr	r0, .L593+4
	bl	printf
.L587:
	movs	r0, #0
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L554:
	ldr	r1, .L593+28
	ldrh	r1, [r1]
	cmp	r1, #0
	beq	.L557
	ldr	r5, .L593+32
	ldr	r0, [r5]
.L558:
	sxth	r1, r3
	cmp	r1, r0
	bcs	.L557
	ldrh	r4, [r2, r1, lsl #1]
	adds	r3, r3, #1
	cmp	r4, #0
	beq	.L558
	ldr	r3, .L593+36
	movs	r6, #0
	ldr	r0, [r3]
	mov	r3, r1
.L559:
	ldr	r4, [r5]
	cmp	r3, r4
	bcs	.L557
	ldrh	r7, [r2, r3, lsl #1]
	subs	r4, r3, r1
	strh	r7, [r2, r4, lsl #1]	@ movhi
	ldr	r7, [r0, r3, lsl #2]
	str	r7, [r0, r4, lsl #2]
	strh	r6, [r2, r3, lsl #1]	@ movhi
	adds	r3, r3, #1
	sxth	r3, r3
	b	.L559
.L555:
	ldr	r3, .L593+12
	ldrh	r3, [r3]
	cmp	r3, #0
	beq	.L556
	ldr	r5, .L593+20
	ldrh	r1, [r5]
.L564:
	sxth	r3, r2
	cmp	r3, r1
	mov	r6, r3
	bge	.L556
	ldrh	r0, [r4, r3, lsl #1]
	adds	r2, r2, #1
	cmp	r0, #0
	beq	.L564
	ldr	r2, .L593+8
	movs	r0, #0
	ldr	r2, [r2]
.L565:
	ldrh	r1, [r5]
	cmp	r3, r1
	bge	.L556
	ldrh	r7, [r4, r3, lsl #1]
	subs	r1, r3, r6
	strh	r7, [r4, r1, lsl #1]	@ movhi
	ldr	r7, [r2, r3, lsl #2]
	str	r7, [r2, r1, lsl #2]
	adds	r1, r3, #1
	strh	r0, [r4, r3, lsl #1]	@ movhi
	sxth	r3, r1
	b	.L565
.L594:
	.align	2
.L593:
	.word	.LANCHOR140
	.word	.LC1
	.word	.LANCHOR122
	.word	.LANCHOR35
	.word	.LANCHOR36
	.word	.LANCHOR27
	.word	.LANCHOR119
	.word	.LANCHOR130
	.word	.LANCHOR30
	.word	.LANCHOR125
	.word	.LANCHOR139
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
	ldr	r8, .L624+40
	ldr	r4, .L624
	ldr	r3, [r8]
	ldr	r7, .L624+4
	mov	r10, r4
	str	r3, [r4, #8]
	ldr	r3, .L624+8
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FtlBbtMemInit
	ldrh	r5, [r7]
	subs	r5, r5, #1
	uxth	r5, r5
.L596:
	ldrh	r3, [r7]
	subs	r3, r3, #15
	cmp	r3, r5
	bgt	.L599
	lsls	r3, r5, #10
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	bne	.L597
	ldr	r3, [r4, #4]
	movs	r2, #1
	mov	r1, r2
	mov	r0, r10
	adds	r3, r3, #1
	str	r3, [r4, #4]
	bl	FlashReadPages
.L597:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L598
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L598
	ldr	r3, .L624+12
	ldr	r2, [r6, #4]
	strh	r5, [r3]	@ movhi
	str	r2, [r3, #8]
	ldrh	r2, [r6, #8]
	strh	r2, [r3, #4]	@ movhi
.L599:
	ldr	r5, .L624+12
	movw	r2, #65535
	ldrh	r3, [r5]
	cmp	r3, r2
	beq	.L613
	ldrh	r3, [r5, #4]
	cmp	r3, r2
	beq	.L603
	lsls	r3, r3, #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L624
	str	r3, [r4, #4]
	bl	FlashReadPages
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L603
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	bne	.L603
	ldr	r3, [r6, #4]
	ldr	r2, [r5, #8]
	cmp	r3, r2
	bls	.L603
	ldrh	r2, [r5, #4]
	str	r3, [r5, #8]
	ldrh	r3, [r6, #8]
	strh	r2, [r5]	@ movhi
	strh	r3, [r5, #4]	@ movhi
.L603:
	ldr	r10, .L624
	movs	r1, #1
	ldrh	r0, [r5]
	bl	FtlGetLastWrittenPage
	sxth	r7, r0
	adds	r0, r0, #1
	strh	r0, [r5, #2]	@ movhi
.L605:
	cmp	r7, #0
	bge	.L608
	movs	r2, #253
	ldr	r1, .L624+16
	ldr	r0, .L624+20
	bl	printf
.L607:
	ldrh	r3, [r6, #10]
	ldrh	r0, [r6, #12]
	strh	r3, [r5, #6]	@ movhi
	movw	r3, #65535
	cmp	r0, r3
	beq	.L610
	ldr	r3, .L624+24
	ldr	r2, [r3]
	cmp	r0, r2
	beq	.L610
	ldr	r3, .L624+28
	ldrh	r3, [r3]
	lsrs	r3, r3, #2
	cmp	r2, r3
	bcs	.L610
	cmp	r0, r3
	bcs	.L610
	bl	FtlSysBlkNumInit
.L610:
	ldr	r6, .L624+32
	movs	r5, #0
	ldr	r7, .L624+36
	ldr	r8, .L624+44
.L611:
	ldrh	r3, [r7]
	cmp	r5, r3
	bcc	.L612
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L598:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L596
.L608:
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
	beq	.L606
	ldrh	r2, [r6]
	movw	r3, #61649
	cmp	r2, r3
	beq	.L607
.L606:
	subs	r7, r7, #1
	sxth	r7, r7
	b	.L605
.L612:
	ldrh	r2, [r8]
	ldr	r1, [r4, #8]
	ldr	r0, [r6, #4]!
	lsls	r2, r2, #2
	mla	r1, r5, r2, r1
	adds	r5, r5, #1
	bl	ftl_memcpy
	b	.L611
.L613:
	mov	r0, #-1
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L625:
	.align	2
.L624:
	.word	.LANCHOR138
	.word	.LANCHOR17
	.word	.LANCHOR114
	.word	.LANCHOR37
	.word	.LANCHOR141
	.word	.LC1
	.word	.LANCHOR2
	.word	.LANCHOR6
	.word	.LANCHOR37+24
	.word	.LANCHOR10
	.word	.LANCHOR106
	.word	.LANCHOR127
	.size	FtlLoadBbt, .-FtlLoadBbt
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
	ldr	r3, .L666
	mov	r8, #0
	ldr	fp, .L666+48
	str	r2, [sp, #8]
	ldrh	r3, [r3, #12]
	str	r3, [sp]
	lsls	r3, r3, #3
	str	r3, [sp, #4]
.L627:
	cmp	r8, r10
	bne	.L640
	ldr	r3, [sp, #12]
	cmp	r3, #0
	beq	.L658
	ldr	r6, .L666+4
	movs	r5, #0
.L642:
	cmp	r8, r5
	beq	.L658
	ldr	r7, .L666+8
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
	bne	.L643
	ldr	r1, [r4, #4]
	ldr	r0, .L666+12
	bl	printf
	str	r10, [r4]
.L643:
	ldr	r3, [r4, #12]
	cbz	r3, .L644
	ldr	r2, [r3]
	ldr	r3, [r7]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L644
	ldr	r1, [r4, #4]
	ldr	r0, .L666+16
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L644:
	ldr	r3, [r4, #8]
	cbz	r3, .L645
	ldr	r2, [r3]
	ldr	r3, [r6]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L645
	ldr	r1, [r4, #4]
	ldr	r0, .L666+20
	bl	printf
	mov	r3, #-1
	str	r3, [r4]
.L645:
	adds	r5, r5, #1
	adds	r4, r4, #20
	b	.L642
.L640:
	ldr	r3, [r5, #8]
	cbz	r3, .L628
	ldr	r3, [r5, #12]
	cbnz	r3, .L629
.L628:
	movs	r2, #134
	ldr	r1, .L666+24
	ldr	r0, .L666+28
	bl	printf
.L629:
	add	r2, sp, #20
	add	r1, sp, #24
	ldr	r0, [r5, #4]
	bl	l2p_addr_tran.isra.0
	ldr	r6, [sp, #20]
	cmp	r6, #3
	bls	.L630
.L665:
	mov	r3, #-1
	str	r3, [r5]
	b	.L631
.L630:
	cbnz	r6, .L632
	ldr	r3, [sp, #24]
	ldr	r2, [sp, #4]
	cmp	r2, r3
	bls	.L632
	ldr	r5, .L666+24
	ldr	r7, .L666+32
	b	.L664
.L634:
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
	ldr	r0, .L666+36
	bl	rknand_print_hex
	movs	r3, #4
	ldr	r1, [r4, #-8]
	mov	r2, r3
	ldr	r0, .L666+40
	bl	rknand_print_hex
.L664:
	cmp	r6, r10
	add	r4, r4, #20
	bne	.L634
.L658:
	movs	r0, #0
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L632:
	ldr	r1, [r5, #8]
	lsls	r3, r1, #26
	beq	.L647
	ldr	r3, .L666+4
	ldr	r6, [r3]
	cmp	r1, r6
	beq	.L635
	ldr	r3, .L666+44
	mov	r0, r6
	ldrh	r2, [r3]
	lsls	r2, r2, #9
	bl	ftl_memcpy
.L635:
	ldr	r3, [r5, #12]
	mov	r2, r6
	ldr	r1, [sp, #24]
	ldrb	r0, [sp, #20]	@ zero_extendqisi2
	ldr	r7, [fp, #8]
	blx	r7
	cbnz	r0, .L636
	str	r0, [r5]
.L637:
	ldr	r3, .L666
	ldrh	r3, [r3, #14]
	cmp	r3, #4
	bne	.L631
	ldr	r0, [sp]
	add	r2, r6, #2048
	ldr	r3, [r5, #12]
	ldr	r1, [sp, #24]
	ldr	r6, [fp, #8]
	adds	r3, r3, #8
	add	r1, r1, r0
	ldrb	r0, [sp, #20]	@ zero_extendqisi2
	blx	r6
	cmp	r0, #0
	bne	.L665
.L631:
	add	r8, r8, #1
	adds	r5, r5, #20
	b	.L627
.L647:
	mov	r6, r1
	b	.L635
.L636:
	mov	r3, #-1
	str	r3, [r5]
	b	.L637
.L667:
	.align	2
.L666:
	.word	.LANCHOR0
	.word	.LANCHOR111
	.word	.LANCHOR113
	.word	.LC11
	.word	.LC12
	.word	.LC13
	.word	.LANCHOR142
	.word	.LC1
	.word	.LC6
	.word	.LC7
	.word	.LC8
	.word	.LANCHOR12
	.word	.LANCHOR78
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
	ldr	r3, .L711
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #32
	ldr	r7, .L711+4
	mov	r8, #0
	mov	r6, r1
	mov	r5, r8
	str	r0, [r3]
	mov	r4, r8
	ldr	r3, .L711+8
	mov	fp, #20
	ldr	r10, [r7]
	str	r0, [sp, #4]
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L711+12
	ldr	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L711+16
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L711+20
	ldrh	r3, [r3]
	str	r3, [sp, #24]
.L669:
	ldr	r3, [sp, #12]
	uxth	r2, r8
	cmp	r3, r2
	bhi	.L673
	cmp	r5, #0
	beq	.L668
	mov	r0, r10
	mov	r8, #0
	mov	r10, #20
	mov	r2, r5
	movs	r1, #0
	bl	FlashEraseBlocks
.L676:
	uxth	r3, r8
	cmp	r5, r3
	bhi	.L678
	cmp	r6, #0
	beq	.L694
	ldr	r3, .L711+24
	mov	r10, #1
	ldrh	r3, [r3]
	str	r3, [sp, #8]
.L679:
	movs	r7, #0
.L688:
	ldr	r3, .L711+8
	mov	r8, #0
	mov	r5, r8
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L711+4
	ldr	fp, [r3]
	ldr	r3, .L711+28
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, .L711+12
	ldr	r3, [r3]
	str	r3, [sp, #24]
	ldr	r3, .L711+20
	ldrh	r3, [r3]
	str	r3, [sp, #28]
.L680:
	ldr	r3, [sp, #16]
	uxth	r2, r8
	cmp	r3, r2
	bhi	.L683
	cbz	r5, .L668
	mov	r0, fp
	ldr	fp, .L711+4
	movs	r3, #1
	mov	r2, r10
	mov	r1, r5
	mov	r8, #0
	bl	FlashProgPages
	movs	r3, #20
.L685:
	uxth	r2, r8
	cmp	r5, r2
	bhi	.L687
	adds	r7, r7, #1
	ldr	r2, [sp, #8]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L688
	ldr	r8, .L711+4
	movs	r7, #0
	mov	fp, #20
.L689:
	uxth	r3, r7
	cmp	r5, r3
	bhi	.L691
	ldr	r3, [sp, #4]
	cmp	r3, #63
	bls	.L692
	cbz	r6, .L668
.L692:
	ldr	r3, .L711+4
	mov	r2, r5
	mov	r1, r10
	ldr	r0, [r3]
	bl	FlashEraseBlocks
.L668:
	mov	r0, r4
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L673:
	mul	r2, fp, r8
	movs	r3, #0
	ldr	r1, [sp, #4]
	str	r3, [r10, r2]
	ldr	r3, .L711+32
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	V2P_block
	str	r0, [sp, #8]
	cbz	r6, .L670
	bl	IsBlkInVendorPart
	cbnz	r0, .L671
.L670:
	ldr	r0, [sp, #8]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L672
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
.L671:
	add	r8, r8, #1
	b	.L669
.L672:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L671
.L678:
	mul	r3, r10, r8
	ldr	r2, [r7]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	adds	r3, r3, #1
	bne	.L677
	ldr	r0, [r1, #4]
	adds	r4, r4, #1
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
.L677:
	add	r8, r8, #1
	b	.L676
.L694:
	movs	r3, #2
	mov	r10, r6
	str	r3, [sp, #8]
	b	.L679
.L683:
	movs	r3, #20
	ldr	r1, [sp, #4]
	mul	r2, r3, r8
	movs	r3, #0
	str	r3, [fp, r2]
	ldr	r3, .L711+32
	ldrb	r0, [r3, r8]	@ zero_extendqisi2
	bl	V2P_block
	str	r0, [sp, #12]
	cbz	r6, .L681
	bl	IsBlkInVendorPart
	cbnz	r0, .L682
.L681:
	ldr	r0, [sp, #12]
	bl	FtlBbmIsBadBlock
	cbnz	r0, .L682
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
.L682:
	add	r8, r8, #1
	b	.L680
.L687:
	mul	r2, r3, r8
	ldr	r1, [fp]
	adds	r0, r1, r2
	ldr	r2, [r1, r2]
	cbz	r2, .L686
	ldr	r0, [r0, #4]
	adds	r4, r4, #1
	str	r3, [sp, #12]
	uxth	r4, r4
	ubfx	r0, r0, #10, #16
	bl	FtlBbmMapBadBlock
	ldr	r3, [sp, #12]
.L686:
	add	r8, r8, #1
	b	.L685
.L691:
	cbz	r6, .L690
	mul	r3, fp, r7
	ldr	r2, [r8]
	adds	r1, r2, r3
	ldr	r3, [r2, r3]
	cbnz	r3, .L690
	ldr	r0, [r1, #4]
	movs	r1, #1
	ubfx	r0, r0, #10, #16
	bl	FtlFreeSysBlkQueueIn
.L690:
	adds	r7, r7, #1
	b	.L689
.L712:
	.align	2
.L711:
	.word	.LANCHOR99
	.word	.LANCHOR79
	.word	.LANCHOR3
	.word	.LANCHOR110
	.word	.LANCHOR115
	.word	.LANCHOR24
	.word	.LANCHOR20
	.word	.LANCHOR109
	.word	.LANCHOR13
	.size	FtlLowFormatEraseBlock, .-FtlLowFormatEraseBlock
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
	mov	r5, r0
	sub	sp, sp, #92
	bls	.L716
	ldr	r4, .L718
	add	r0, sp, #24
	movs	r2, #32
	movs	r1, #165
	str	r0, [sp, #16]
	lsls	r5, r5, #10
	ldr	r3, [r4]
	str	r3, [sp, #12]
	bl	ftl_memset
	movs	r2, #8
	movs	r1, #90
	ldr	r0, [r4]
	bl	ftl_memset
	movs	r2, #1
	add	r0, sp, #4
	mov	r1, r2
	str	r5, [sp, #8]
	bl	FlashEraseBlocks
	movs	r3, #1
	add	r0, sp, #4
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r3, [sp, #4]
	cbnz	r3, .L717
	adds	r3, r5, #1
	add	r0, sp, #4
	str	r3, [sp, #8]
	movs	r3, #1
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r4, [sp, #4]
	adds	r4, r4, #0
	it	ne
	movne	r4, #1
	negs	r4, r4
.L715:
	movs	r2, #1
	movs	r1, #0
	add	r0, sp, #4
	str	r5, [sp, #8]
	bl	FlashEraseBlocks
.L713:
	mov	r0, r4
	add	sp, sp, #92
	@ sp needed
	pop	{r4, r5, pc}
.L717:
	mov	r4, #-1
	b	.L715
.L716:
	movs	r4, #0
	b	.L713
.L719:
	.align	2
.L718:
	.word	.LANCHOR112
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
	ldr	r7, .L729
	movs	r1, #0
	ldr	r5, .L729+4
	ldr	r3, [r7]
	mov	fp, r7
	ldr	r8, .L729+48
	ldr	r6, .L729+8
	str	r3, [r5, #12]
	ldr	r7, .L729+12
	ldr	r3, .L729+16
	ldr	r10, .L729+52
	ldr	r0, [r8]
	ldrh	r2, [r3]
	str	r0, [r5, #8]
	bl	ftl_memset
.L721:
	ldrh	r3, [r7]
	cmp	r4, r3
	blt	.L722
	ldr	r6, [r5, #12]
	movs	r2, #16
	ldr	r4, .L729+20
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
	ldr	r3, .L729+24
	ldr	r3, [r3]
	strh	r3, [r6, #12]	@ movhi
.L723:
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
	ldr	r0, .L729+28
	bl	printf
	ldr	r3, .L729+32
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r2, r3
	blt	.L724
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
	ldr	r2, .L729+36
	strh	r3, [r4]	@ movhi
	lsls	r3, r3, #10
	ldr	r0, [r2]
	movs	r2, #1
	str	r3, [r5, #4]
	mov	r1, r2
	str	r3, [r0, #4]
	bl	FlashEraseBlocks
.L724:
	movs	r3, #1
	ldr	r0, .L729+4
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldrh	r3, [r10, #2]
	adds	r3, r3, #1
	strh	r3, [r10, #2]	@ movhi
	ldr	r3, [r5]
	adds	r3, r3, #1
	bne	.L725
	adds	r7, r7, #1
	ldr	r1, [r5, #4]
	uxth	r7, r7
	ldr	r0, .L729+40
	bl	printf
	cmp	r7, #3
	bls	.L723
	mov	r2, r7
	ldr	r1, [r5, #4]
	ldr	r0, .L729+44
	bl	printf
.L727:
	b	.L727
.L722:
	ldrh	r2, [r10]
	ldr	r3, [r5, #8]
	ldr	r1, [r6, #4]!
	mul	r0, r2, r4
	lsls	r2, r2, #2
	adds	r4, r4, #1
	add	r0, r3, r0, lsl #2
	bl	ftl_memcpy
	b	.L721
.L728:
	movs	r3, #1
	str	r3, [sp, #12]
	b	.L723
.L725:
	ldr	r3, [sp, #12]
	cmp	r3, #0
	beq	.L728
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L730:
	.align	2
.L729:
	.word	.LANCHOR114
	.word	.LANCHOR138
	.word	.LANCHOR37+24
	.word	.LANCHOR10
	.word	.LANCHOR23
	.word	.LANCHOR37
	.word	.LANCHOR2
	.word	.LC14
	.word	.LANCHOR20
	.word	.LANCHOR79
	.word	.LC15
	.word	.LC16
	.word	.LANCHOR106
	.word	.LANCHOR127
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
.L732:
	ldr	r3, .L771
	ldr	r8, .L771+68
	ldrh	r3, [r3]
	ldr	r10, .L771+72
	ldrh	r2, [r8]
	add	r3, r3, r2
	ldrh	r2, [r10]
	cmp	r3, r2
	ble	.L733
	movw	r2, #2661
	ldr	r1, .L771+4
	ldr	r0, .L771+8
	bl	printf
.L733:
	ldr	r3, .L771+12
	cmp	r4, r3
	bne	.L759
	ldr	r3, .L771
	ldr	r2, .L771+16
	ldrh	r3, [r3]
	ldr	r2, [r2]
	lsrs	r1, r3, #1
	muls	r2, r3, r2
	adds	r1, r1, #1
	add	r1, r1, r2, lsr #2
	uxth	r1, r1
	cbz	r1, .L734
	subs	r1, r1, #1
	uxth	r1, r1
.L734:
	ldr	r0, .L771+20
	bl	List_pop_index_node
	ldr	r3, .L771
	mov	r5, r0
	uxth	r7, r0
	ldrh	r3, [r3]
	cbnz	r3, .L735
	movw	r2, #2670
	ldr	r1, .L771+4
	ldr	r0, .L771+8
	bl	printf
.L735:
	ldr	r3, .L771
	ldr	r2, .L771
	ldrh	r3, [r3]
	subs	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldrh	r3, [r10]
	cmp	r3, r7
	bls	.L732
	uxth	r5, r5
	lsls	r3, r5, #1
	str	r3, [sp]
	ldr	r3, .L771+24
	ldr	r3, [r3]
	ldrh	r6, [r3, r5, lsl #1]
	cmp	r6, #0
	bne	.L732
	strh	r7, [r4]	@ movhi
	mov	r0, r4
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L737
	ldr	r3, .L771+24
	movw	r2, #65535
	mov	r0, r7
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r3, .L771
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r10]
	cmp	r3, r2
	ble	.L732
	movw	r2, #2684
	ldr	r1, .L771+4
	ldr	r0, .L771+8
	bl	printf
	b	.L732
.L759:
	movs	r1, #0
	b	.L734
.L737:
	ldr	r3, .L771
	ldrh	r2, [r8]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldrh	r2, [r10]
	cmp	r3, r2
	ble	.L739
	movw	r2, #2687
	ldr	r1, .L771+4
	ldr	r0, .L771+8
	bl	printf
.L739:
	ldr	r3, .L771+28
	add	lr, r4, #16
	ldr	r2, .L771+32
	mov	r8, #0
	ldr	ip, [r3]
	ldrh	r0, [r2]
	movs	r2, #20
	mov	r3, ip
	mla	r0, r2, r0, ip
.L740:
	cmp	r0, r3
	bne	.L742
	cbnz	r6, .L743
	movw	r2, #2698
	ldr	r1, .L771+4
	ldr	r0, .L771+8
	bl	printf
.L743:
	ldr	r3, .L771+36
	ldrh	r3, [r3]
	cmp	r3, r7
	bne	.L744
	movw	r2, #2700
	ldr	r1, .L771+4
	ldr	r0, .L771+8
	bl	printf
.L744:
	ldrb	r2, [r4, #8]	@ zero_extendqisi2
	ldr	r3, .L771+40
	ldr	fp, .L771+76
	ldr	r8, .L771+80
	ldr	r1, [r3]
	cmp	r2, #0
	bne	.L745
	ldrh	r2, [r1, r5, lsl #1]
	cmp	r2, #0
	beq	.L746
	ldr	r0, .L771+44
	ldrh	r0, [r0]
	add	r2, r2, r0
.L769:
	strh	r2, [r1, r5, lsl #1]	@ movhi
	mov	r0, r7
	ldr	r2, [fp]
	movs	r1, #0
	str	r3, [sp, #4]
	adds	r2, r2, #1
	str	r2, [fp]
	bl	ftl_set_blk_mode
.L770:
	ldr	r3, [sp, #4]
	ldr	r0, [fp]
	ldr	r3, [r3]
	ldrh	r1, [r3, r5, lsl #1]
	ldr	r3, .L771+48
	ldr	r2, [r3]
	cmp	r1, r2
	it	hi
	strhi	r1, [r3]
	ldr	r3, .L771+44
	ldrh	r1, [r10]
	ldrh	r2, [r3]
	ldr	r3, [r8]
	mla	r0, r0, r2, r3
	bl	__aeabi_uidiv
	ldr	r3, .L771+52
	ldr	ip, .L771+84
	str	r0, [r3]
	ldr	r3, .L771+56
	ldr	r2, [r3]
	ldr	r3, [r2, #16]
	adds	r3, r3, #1
	str	r3, [r2, #16]
	movs	r2, #20
	ldr	r3, .L771+28
	ldr	r0, [r3]
	adds	r3, r0, #4
	mla	r2, r2, r6, r0
	adds	r2, r2, #24
.L750:
	adds	r3, r3, #20
	cmp	r2, r3
	bne	.L751
	mov	r2, r6
	ldrb	r1, [r4, #8]	@ zero_extendqisi2
	mov	r8, #0
	bl	FlashEraseBlocks
	mov	r10, r8
	movs	r3, #20
.L752:
	uxth	r2, r8
	cmp	r6, r2
	bhi	.L754
	cmp	r10, #0
	beq	.L755
	mov	r0, r7
	bl	update_multiplier_value
	bl	FtlBbmTblFlush
.L755:
	ldrb	r2, [r4, #7]	@ zero_extendqisi2
	cmp	r2, #0
	bne	.L756
	ldr	r3, .L771+24
	movw	r2, #65535
	ldr	r3, [r3]
	strh	r2, [r3, r5, lsl #1]	@ movhi
	b	.L732
.L742:
	ldrh	r1, [lr], #2
	movw	fp, #65535
	str	r8, [r3, #8]
	str	r8, [r3, #12]
	cmp	r1, fp
	beq	.L741
	mla	fp, r2, r6, ip
	adds	r6, r6, #1
	lsls	r1, r1, #10
	uxth	r6, r6
	str	r1, [fp, #4]
.L741:
	adds	r3, r3, #20
	b	.L740
.L746:
	movs	r2, #2
	b	.L769
.L745:
	ldrh	r2, [r1, r5, lsl #1]
	mov	r0, r7
	str	r3, [sp, #4]
	adds	r2, r2, #1
	strh	r2, [r1, r5, lsl #1]	@ movhi
	ldr	r2, [r8]
	adds	r2, r2, #1
	str	r2, [r8]
	bl	ftl_set_blk_mode.part.6
	b	.L770
.L751:
	ldr	r1, [r3, #-20]
	and	r1, r1, ip
	str	r1, [r3, #-20]
	b	.L750
.L754:
	ldr	r1, .L771+28
	mul	r2, r3, r8
	ldr	r1, [r1]
	ldr	fp, [r1, r2]
	adds	r0, r1, r2
	cmp	fp, #-1
	bne	.L753
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
.L753:
	add	r8, r8, #1
	b	.L752
.L756:
	ldr	r3, .L771+60
	ldr	r1, .L771+64
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
	ldr	r2, .L771+24
	ldr	r1, [sp]
	ldr	r2, [r2]
	strh	r3, [r2, r1]	@ movhi
	ldrh	r3, [r4, #4]
	cbz	r3, .L757
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	cbnz	r3, .L758
.L757:
	movw	r2, #2753
	ldr	r1, .L771+4
	ldr	r0, .L771+8
	bl	printf
.L758:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L772:
	.align	2
.L771:
	.word	.LANCHOR48
	.word	.LANCHOR143
	.word	.LC1
	.word	.LANCHOR53
	.word	.LANCHOR95
	.word	.LANCHOR47
	.word	.LANCHOR42
	.word	.LANCHOR79
	.word	.LANCHOR3
	.word	.LANCHOR144
	.word	.LANCHOR43
	.word	.LANCHOR14
	.word	.LANCHOR92
	.word	.LANCHOR145
	.word	.LANCHOR118
	.word	.LANCHOR19
	.word	.LANCHOR82
	.word	.LANCHOR45
	.word	.LANCHOR5
	.word	.LANCHOR90
	.word	.LANCHOR91
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
	ldr	r4, .L785
	ldrh	r3, [r4]
	cbz	r3, .L774
	ldr	r8, .L785+12
	movs	r7, #0
.L775:
	ldr	r3, .L785+4
	ldrh	r2, [r3]
	uxth	r3, r7
	cmp	r2, r3
	bhi	.L781
	bl	FtlGcReFreshBadBlk
.L774:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L781:
	ldr	r2, .L785+8
	uxth	r3, r7
	mov	r1, r10
	mov	fp, #0
	ldrb	r0, [r2, r3]	@ zero_extendqisi2
	bl	V2P_block
	mov	r1, r0
.L776:
	ldrh	r3, [r4]
	uxth	r5, fp
	cmp	r3, r5
	bhi	.L780
	adds	r7, r7, #1
	b	.L775
.L780:
	uxth	r6, fp
	ldrh	r3, [r8, r6, lsl #1]
	cmp	r3, r1
	bne	.L777
	mov	r0, r1
	str	r1, [sp, #4]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	ldrh	r2, [r4]
	add	r3, r8, r6, lsl #1
	ldr	r1, [sp, #4]
.L778:
	cmp	r5, r2
	bcc	.L779
	subs	r2, r2, #1
	strh	r2, [r4]	@ movhi
.L777:
	add	fp, fp, #1
	b	.L776
.L779:
	ldrh	r0, [r3, #2]!
	adds	r5, r5, #1
	uxth	r5, r5
	strh	r0, [r3, #-2]	@ movhi
	b	.L778
.L786:
	.align	2
.L785:
	.word	.LANCHOR74
	.word	.LANCHOR3
	.word	.LANCHOR13
	.word	.LANCHOR75
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
	ldr	r3, .L797
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	bne	.L788
	ldr	r2, .L797+4
	ldrh	r1, [r2]
	cmp	r1, r0
	bne	.L789
	movw	r3, #65535
	strh	r3, [r2]	@ movhi
.L790:
	ldr	r5, .L797+8
	mov	r1, r4
	ldr	r0, .L797+12
	bl	List_remove_node
	ldrh	r3, [r5]
	cbnz	r3, .L792
	movw	r2, #2823
	ldr	r1, .L797+16
	ldr	r0, .L797+20
	bl	printf
.L792:
	ldrh	r3, [r5]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r5]	@ movhi
	bl	free_data_superblock
	mov	r0, r4
	bl	FtlGcFreeBadSuperBlk
	ldr	r3, .L797+24
	ldrh	r2, [r5]
	ldrh	r3, [r3]
	add	r3, r3, r2
	ldr	r2, .L797+28
	ldrh	r2, [r2]
	cmp	r3, r2
	ble	.L796
	movw	r2, #2826
	ldr	r1, .L797+16
	ldr	r0, .L797+20
	bl	printf
.L796:
	movs	r3, #1
	b	.L787
.L789:
	ldr	r2, .L797+32
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L787
	ldr	r2, .L797+36
	ldrh	r2, [r2]
	cmp	r2, r0
	beq	.L787
	ldr	r2, .L797+40
	ldrh	r2, [r2]
	cmp	r2, r0
	bne	.L790
.L787:
	mov	r0, r3
	pop	{r3, r4, r5, pc}
.L788:
	bl	List_update_data_list
	movs	r3, #0
	b	.L787
.L798:
	.align	2
.L797:
	.word	.LANCHOR42
	.word	.LANCHOR144
	.word	.LANCHOR45
	.word	.LANCHOR41
	.word	.LANCHOR146
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
	beq	.L800
	ldr	r5, .L808
	ldr	r3, [r5]
	ldrh	r2, [r3, r0, lsl #1]
	cbnz	r2, .L801
	mov	r1, r0
	ldr	r0, .L808+4
	bl	printf
	ldr	r3, [r5]
	ldrh	r5, [r3, r4, lsl #1]
	cbz	r5, .L802
.L806:
	movs	r5, #0
.L799:
	mov	r0, r5
	pop	{r4, r5, r6, pc}
.L802:
	movw	r2, #2841
.L807:
	ldr	r1, .L808+8
	ldr	r0, .L808+12
	bl	printf
	b	.L799
.L801:
	subs	r2, r2, #1
	strh	r2, [r3, r0, lsl #1]	@ movhi
.L800:
	ldr	r6, .L808+16
	movw	r3, #65535
	ldrh	r0, [r6]
	cmp	r0, r3
	bne	.L804
	strh	r4, [r6]	@ movhi
	b	.L806
.L804:
	cmp	r4, r0
	beq	.L806
	bl	update_vpc_list
	ldr	r3, .L808+20
	adds	r5, r0, #0
	ldr	r2, .L808+24
	it	ne
	movne	r5, #1
	strh	r4, [r6]	@ movhi
	ldr	r3, [r3]
	ldr	r2, [r2]
	subs	r3, r3, r2
	asrs	r2, r3, #1
	ldr	r3, .L808+28
	muls	r3, r2, r3
	ldr	r2, .L808
	ldr	r2, [r2]
	uxth	r1, r3
	ldrh	r2, [r2, r1, lsl #1]
	cmp	r2, #0
	bne	.L799
	cmp	r4, r1
	beq	.L799
	movw	r2, #2857
	b	.L807
.L809:
	.align	2
.L808:
	.word	.LANCHOR42
	.word	.LC17
	.word	.LANCHOR147
	.word	.LC1
	.word	.LANCHOR131
	.word	.LANCHOR41
	.word	.LANCHOR40
	.word	-1431655765
	.size	decrement_vpc_count, .-decrement_vpc_count
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
	ldr	r2, .L823
	movs	r6, #0
	mov	r4, r0
	str	r3, [sp, #20]
	ldr	r3, .L823+4
	ldr	r5, [r2]
	mvn	r2, #2
	ldr	r8, .L823+16
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
.L816:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L812
.L813:
	ldr	r3, .L823+8
	ldrh	r1, [r4]
	ldrh	r0, [r4, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	strh	r3, [r2, r1, lsl #1]	@ movhi
	ldr	r3, .L823+12
	ldrh	r3, [r3]
	strh	r3, [r4, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L812:
	mov	r0, r4
	bl	get_new_active_ppa
	str	r0, [sp, #8]
	adds	r0, r0, #1
	beq	.L813
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
	bne	.L816
	b	.L813
.L824:
	.align	2
.L823:
	.word	.LANCHOR114
	.word	.LANCHOR106
	.word	.LANCHOR42
	.word	.LANCHOR19
	.word	.LANCHOR83
	.size	FtlSuperblockPowerLostFix, .-FtlSuperblockPowerLostFix
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
	ldr	r7, .L844
	bl	FtlBbtMemInit
	sub	r8, r7, #18
	bl	FtlLoadFactoryBbt
.L826:
	ldr	r3, .L844+4
	ldrh	r3, [r3]
	cmp	r6, r3
	bcc	.L832
	ldr	r5, .L844+8
	movs	r4, #0
.L833:
	ldrh	r3, [r5]
	uxth	r0, r4
	adds	r4, r4, #1
	cmp	r3, r0
	bhi	.L834
	ldr	r4, .L844+12
	movw	r6, #65535
	ldrh	r5, [r4, #12]
	subs	r5, r5, #1
	uxth	r5, r5
.L835:
	ldrh	r3, [r4, #12]
	subs	r3, r3, #47
	cmp	r3, r5
	bgt	.L839
	mov	r0, r5
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L836
	mov	r0, r5
	bl	FlashTestBlk
	cmp	r0, #0
	beq	.L837
	mov	r0, r5
	bl	FtlBbmMapBadBlock
.L836:
	subs	r5, r5, #1
	uxth	r5, r5
	b	.L835
.L832:
	ldr	r3, .L844+16
	ldr	r5, .L844+20
	ldrh	r2, [r8, #2]!
	ldr	r4, .L844+24
	ldr	r0, [r3]
	movw	r3, #65535
	ldr	r10, [r5]
	cmp	r2, r3
	mov	fp, r4
	ldr	r3, .L844+28
	str	r0, [r4, #8]
	str	r10, [r4, #12]
	beq	.L827
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
.L828:
	uxth	r0, r5
	adds	r6, r6, #1
	adds	r7, r7, #4
	bl	FtlBbmMapBadBlock
	b	.L826
.L827:
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
.L829:
	ldr	r3, [sp]
	ldrh	r0, [r3]
	smlabb	r0, r0, r6, r4
	uxth	r0, r0
	bl	FtlBbmIsBadBlock
	cmp	r0, #1
	beq	.L830
	ldr	r3, [sp, #4]
	movs	r2, #16
	movs	r1, #0
	strh	r4, [r8]	@ movhi
	ldr	r0, [r3]
	bl	ftl_memset
	ldr	r3, .L844+16
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
	ldr	r3, .L844+32
	ldrh	r2, [r3]
	lsls	r2, r2, #2
	bl	ftl_memcpy
	movs	r2, #1
	ldr	r0, .L844+24
	mov	r1, r2
	bl	FlashEraseBlocks
	movs	r3, #1
	ldr	r0, .L844+24
	mov	r2, r3
	mov	r1, r3
	bl	FlashProgPages
	ldr	r3, [fp]
	adds	r3, r3, #1
	bne	.L828
	uxth	r0, r5
	bl	FtlBbmMapBadBlock
	b	.L829
.L830:
	subs	r4, r4, #1
	uxth	r4, r4
	b	.L829
.L834:
	bl	FtlBbmMapBadBlock
	b	.L833
.L837:
	ldrh	r3, [r4]
	cmp	r3, r6
	bne	.L838
	strh	r5, [r4]	@ movhi
	b	.L836
.L838:
	strh	r5, [r4, #4]	@ movhi
.L839:
	ldr	r3, .L844+36
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
.L845:
	.align	2
.L844:
	.word	.LANCHOR37+28
	.word	.LANCHOR10
	.word	.LANCHOR25
	.word	.LANCHOR37
	.word	.LANCHOR106
	.word	.LANCHOR114
	.word	.LANCHOR138
	.word	.LANCHOR17
	.word	.LANCHOR127
	.word	.LANCHOR79
	.size	FtlMakeBbt, .-FtlMakeBbt
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
	ldr	r3, .L850
	add	r1, r1, r0
	push	{r4, lr}
.L848:
	cmp	r0, r1
	bne	.L849
	mov	r0, r3
	pop	{r4, pc}
.L849:
	lsrs	r2, r3, #2
	ldrb	r4, [r0], #1	@ zero_extendqisi2
	add	r2, r2, r3, lsl #5
	add	r2, r2, r4
	eors	r3, r3, r2
	b	.L848
.L851:
	.align	2
.L850:
	.word	1204201446
	.size	js_hash, .-js_hash
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
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	movw	r2, #65535
	ldrh	r3, [r0]
	mov	r4, r0
	ldr	r5, [r0, #12]
	cmp	r3, r2
	bne	.L853
	ldrh	r3, [r0, #8]
	cbz	r3, .L854
	movw	r2, #641
	ldr	r1, .L862
	ldr	r0, .L862+4
	bl	printf
.L854:
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
.L855:
	movs	r0, #0
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L853:
	ldrh	r7, [r5, r3, lsl #1]
	movs	r1, #255
	ldrh	r3, [r0, #2]
	ldr	r6, .L862+8
	ldr	r10, .L862+24
	ldr	r8, [r0, #24]
	orr	r3, r3, r7, lsl #10
	ldr	r0, [r10]
	str	r3, [r6, #4]
	ldr	r3, .L862+12
	str	r0, [r6, #8]
	ldr	r5, [r3]
	ldr	r3, [r4, #28]
	str	r5, [r6, #12]
	str	r3, [r5, #4]
	movw	r3, #64245
	strh	r3, [r5, #8]	@ movhi
	ldrh	r3, [r4, #4]
	strh	r7, [r5, #2]	@ movhi
	strh	r3, [r5]	@ movhi
	ldr	r3, .L862+16
	ldrh	r2, [r3]
	lsls	r2, r2, #3
	bl	ftl_memset
	ldrh	ip, [r4, #6]
	movs	r3, #0
	ldr	r1, [r10]
	mov	r2, r3
.L856:
	uxth	r0, r3
	cmp	ip, r0
	bhi	.L858
	ldr	r3, .L862+20
	ldr	r0, [r6, #8]
	ldrh	r1, [r3]
	bl	js_hash
	movs	r2, #1
	str	r0, [r5, #12]
	movs	r3, #0
	mov	r1, r2
	ldr	r0, .L862+8
	bl	FlashProgPages
	ldrh	r3, [r4, #2]
	mov	r0, r4
	adds	r3, r3, #1
	strh	r3, [r4, #2]	@ movhi
	bl	ftl_map_blk_gc
	b	.L855
.L858:
	ldr	r0, [r8, r3, lsl #2]
	cmp	r7, r0, lsr #10
	bne	.L857
	adds	r2, r2, #1
	uxth	r2, r2
	str	r3, [r1, r2, lsl #3]
	add	lr, r1, r2, lsl #3
	ldr	r0, [r8, r3, lsl #2]
	str	r0, [lr, #4]
.L857:
	adds	r3, r3, #1
	b	.L856
.L863:
	.align	2
.L862:
	.word	.LANCHOR148
	.word	.LC1
	.word	.LANCHOR138
	.word	.LANCHOR114
	.word	.LANCHOR20
	.word	.LANCHOR23
	.word	.LANCHOR106
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
	ldr	r8, .L888+32
	mov	r7, r1
	movs	r6, #0
	str	r2, [sp]
	mov	fp, r8
.L865:
	ldr	r2, .L888
	ldr	r3, [r2]
	adds	r3, r3, #1
	str	r3, [r2]
	ldrh	r3, [r8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	cmp	r2, r3
	bge	.L866
	ldrh	r2, [r4]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L867
.L866:
	mov	r0, r4
	bl	Ftl_write_map_blk_to_last_page
.L867:
	ldrh	r2, [r4]
	ldr	r3, [r4, #12]
	ldrh	r3, [r3, r2, lsl #1]
	cbnz	r3, .L868
	mov	r2, #700
	ldr	r1, .L888+4
	ldr	r0, .L888+8
	bl	printf
.L868:
	ldrh	r2, [r4]
	ldrh	r3, [r4, #10]
	cmp	r2, r3
	bcc	.L869
	movw	r2, #701
	ldr	r1, .L888+4
	ldr	r0, .L888+8
	bl	printf
.L869:
	ldrh	r2, [r4]
	movs	r1, #0
	ldr	r3, [r4, #12]
	ldr	r5, .L888+12
	ldrh	r3, [r3, r2, lsl #1]
	ldrh	r2, [r4, #2]
	str	r3, [sp, #4]
	orr	r2, r2, r3, lsl #10
	ldr	r3, [sp]
	str	r2, [r5, #4]
	ldr	r2, .L888+16
	str	r3, [r5, #8]
	ldr	r0, [r2]
	movs	r2, #16
	str	r0, [r5, #12]
	bl	ftl_memset
	ldr	r1, [r4, #28]
	ldr	r10, [r5, #12]
	ldr	r3, [sp, #4]
	ldr	r0, [r5, #8]
	str	r1, [r10, #4]
	ldrh	r1, [r4, #4]
	strh	r3, [r10, #2]	@ movhi
	ldr	r3, .L888+20
	strh	r1, [r10]	@ movhi
	strh	r7, [r10, #8]	@ movhi
	ldrh	r1, [r3]
	bl	js_hash
	movs	r3, #1
	str	r0, [r10, #12]
	mov	r2, r3
	mov	r1, r3
	mov	r0, r5
	bl	FlashProgPages
	ldrh	r2, [r4, #2]
	ldr	r1, [r5]
	adds	r2, r2, #1
	uxth	r2, r2
	adds	r3, r1, #1
	strh	r2, [r4, #2]	@ movhi
	bne	.L870
	ldr	r1, [r5, #4]
	adds	r6, r6, #1
	ldr	r0, .L888+24
	uxth	r6, r6
	bl	printf
	ldrh	r2, [r4, #2]
	cmp	r2, #2
	ittt	ls
	ldrhls	r2, [fp]
	addls	r2, r2, #-1
	strhls	r2, [r4, #2]	@ movhi
	cmp	r6, #3
	bls	.L872
	mov	r2, r6
	ldr	r1, [r5, #4]
	ldr	r0, .L888+28
	bl	printf
.L873:
	b	.L873
.L872:
	ldr	r3, [r4, #32]
	cmp	r3, #0
	beq	.L865
.L887:
	b	.L887
.L870:
	cmp	r2, #1
	beq	.L876
	cmp	r1, #256
	beq	.L876
	ldr	r0, [r4, #36]
	cbz	r0, .L877
.L876:
	movs	r3, #0
	str	r3, [r4, #36]
	b	.L865
.L877:
	ldr	r2, [r5, #4]
	ldr	r3, [r4, #24]
	str	r2, [r3, r7, lsl #2]
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L889:
	.align	2
.L888:
	.word	.LANCHOR88
	.word	.LANCHOR149
	.word	.LC1
	.word	.LANCHOR138
	.word	.LANCHOR114
	.word	.LANCHOR23
	.word	.LC18
	.word	.LC19
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
	ldr	r3, .L897
	push	{r0, r1, r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r5, r0
	mov	r10, r1
	ldrh	r2, [r3]
	str	r3, [sp, #4]
	cmp	r2, r0
	bcs	.L891
	movw	r2, #485
	ldr	r1, .L897+4
	ldr	r0, .L897+8
	bl	printf
.L891:
	ldr	fp, .L897+48
	movs	r4, #12
	ldr	r7, .L897+12
	ldr	r3, [fp]
	ldr	r8, [r3, r5, lsl #2]
	cmp	r8, #0
	bne	.L892
	mul	r4, r4, r10
	ldr	r2, [r7]
	movs	r1, #255
	adds	r0, r2, r4
	ldr	r2, .L897+16
	ldr	r0, [r0, #8]
	ldrh	r2, [r2]
	bl	ftl_memset
	ldr	r2, [r7]
	adds	r1, r2, r4
	strh	r5, [r2, r4]	@ movhi
	str	r8, [r1, #4]
.L893:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L892:
	mul	r4, r4, r10
	ldr	r2, [r7]
	ldr	r6, .L897+20
	add	r2, r2, r4
	mov	r0, r6
	ldr	r2, [r2, #8]
	str	r8, [r6, #4]
	str	r2, [r6, #8]
	ldr	r2, .L897+24
	ldr	r2, [r2]
	str	r2, [r6, #12]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r10, [r6, #12]
	ldrh	r2, [r10, #8]
	cmp	r2, r5
	beq	.L894
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L897+28
	bl	printf
	movs	r3, #4
	ldr	r1, [r6, #12]
	mov	r2, r3
	ldr	r0, .L897+32
	bl	rknand_print_hex
	ldr	r3, [sp, #4]
	movs	r2, #4
	ldr	r1, [fp]
	ldr	r0, .L897+36
	ldrh	r3, [r3]
	bl	rknand_print_hex
.L895:
	ldrh	r3, [r10, #8]
	cmp	r3, r5
	beq	.L896
	mov	r2, #508
	ldr	r1, .L897+4
	ldr	r0, .L897+8
	bl	printf
.L896:
	ldr	r3, [r7]
	movs	r1, #0
	adds	r2, r3, r4
	str	r1, [r2, #4]
	strh	r5, [r3, r4]	@ movhi
	b	.L893
.L894:
	ldr	r2, [r6]
	cmp	r2, #256
	bne	.L895
	mov	r2, r8
	mov	r1, r5
	ldr	r0, .L897+40
	bl	printf
	ldr	r3, [r7]
	mov	r1, r5
	ldr	r0, .L897+44
	add	r3, r3, r4
	ldr	r2, [r3, #8]
	bl	FtlMapWritePage
	b	.L895
.L898:
	.align	2
.L897:
	.word	.LANCHOR32
	.word	.LANCHOR150
	.word	.LC1
	.word	.LANCHOR55
	.word	.LANCHOR23
	.word	.LANCHOR138
	.word	.LANCHOR114
	.word	.LC20
	.word	.LC21
	.word	.LC22
	.word	.LC23
	.word	.LANCHOR129
	.word	.LANCHOR124
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
	blt	.L900
	uxth	r0, r0
	ldrh	r8, [r5, r0, lsl #1]
	cmp	r8, #0
	beq	.L900
	ldr	r3, [r4, #32]
	cbnz	r3, .L900
	movs	r2, #1
	str	r2, [r4, #32]
	strh	r3, [r5, r0, lsl #1]	@ movhi
	ldrh	r3, [r4, #8]
	ldrh	r2, [r4, #2]
	subs	r3, r3, #1
	strh	r3, [r4, #8]	@ movhi
	ldr	r3, .L915
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L901
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L901:
	ldr	r5, .L915+4
	movs	r6, #0
.L902:
	ldrh	r3, [r4, #6]
	uxth	r10, r6
	cmp	r3, r10
	bhi	.L909
	movs	r1, #1
	mov	r0, r8
	bl	FtlFreeSysBlkQueueIn
	movs	r3, #0
	str	r3, [r4, #32]
.L900:
	ldr	r3, .L915
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L910
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L910:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L909:
	ldr	r3, [sp]
	uxth	fp, r6
	add	r3, r3, fp, lsl #2
	str	r3, [sp, #4]
	ldr	r3, [sp]
	ldr	r2, [r3, fp, lsl #2]
	cmp	r8, r2, lsr #10
	bne	.L903
	ldr	r3, .L915+8
	str	r2, [r5, #4]
	movs	r2, #1
	ldr	r0, .L915+4
	ldr	r1, [r3]
	str	r1, [r5, #8]
	ldr	r1, .L915+12
	ldr	r7, [r1]
	mov	r1, r2
	str	r7, [r5, #12]
	bl	FlashReadPages
	ldrh	r2, [r7, #8]
	cmp	r2, r10
	beq	.L904
	movw	r2, #611
	ldr	r1, .L915+16
	ldr	r0, .L915+20
	bl	printf
.L904:
	ldr	r2, [r5]
	adds	r2, r2, #1
	bne	.L905
.L907:
	ldr	r2, [sp, #4]
	movs	r3, #0
	str	r3, [r2]
.L906:
	b	.L906
.L905:
	ldrh	r2, [r7, #8]
	cmp	r2, r10
	bne	.L907
	ldrh	r1, [r7]
	ldrh	r2, [r4, #4]
	cmp	r1, r2
	bne	.L907
	ldr	r2, [r5, #8]
	mov	r1, fp
	mov	r0, r4
	bl	FtlMapWritePage
.L903:
	adds	r6, r6, #1
	b	.L902
.L916:
	.align	2
.L915:
	.word	.LANCHOR20
	.word	.LANCHOR138
	.word	.LANCHOR107
	.word	.LANCHOR114
	.word	.LANCHOR151
	.word	.LC1
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
	ldr	r5, .L918
	muls	r4, r0, r4
	ldr	r0, .L918+4
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
.L919:
	.align	2
.L918:
	.word	.LANCHOR55
	.word	.LANCHOR129
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
	ldr	r5, .L924
	ldr	r6, .L924+4
.L921:
	ldrh	r3, [r5]
	uxth	r0, r4
	cmp	r3, r0
	bhi	.L923
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L923:
	ldr	r2, [r6]
	uxth	r3, r4
	movs	r1, #12
	mla	r3, r1, r3, r2
	ldr	r3, [r3, #4]
	cmp	r3, #0
	bge	.L922
	bl	flush_l2p_region
.L922:
	adds	r4, r4, #1
	b	.L921
.L925:
	.align	2
.L924:
	.word	.LANCHOR33
	.word	.LANCHOR55
	.size	l2p_flush, .-l2p_flush
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
	ldr	r4, .L939
	mov	r10, r0
	mov	r5, r1
	ldr	r3, .L939+4
	ldr	r2, [r4]
	ldrh	fp, [r3]
	cmp	r0, r2
	bcc	.L927
	movw	r2, #813
	ldr	r1, .L939+8
	ldr	r0, .L939+12
	bl	printf
.L927:
	ldr	r3, [r4]
	cmp	r10, r3
	bcs	.L928
	ldr	r3, .L939+16
	add	fp, fp, #7
	lsr	r6, r10, fp
	movs	r2, #0
	ldrh	r1, [r3]
	uxth	r6, r6
	ldr	r3, .L939+20
	ldr	r0, [r3]
	mov	r8, r3
	movs	r3, #12
.L929:
	uxth	r4, r2
	cmp	r4, r1
	bcc	.L934
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
	beq	.L935
	ldr	r3, [r1, #4]
	cmp	r3, #0
	bge	.L935
	bl	flush_l2p_region
.L935:
	mov	r1, r4
	mov	r0, r6
	bl	load_l2p_region
	b	.L931
.L928:
	mov	r0, #-1
	cbnz	r7, .L926
	str	r0, [r5]
.L926:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L934:
	adds	r2, r2, #1
	mla	ip, r3, r2, r0
	ldrh	ip, [ip, #-12]
	cmp	ip, r6
	bne	.L929
.L931:
	movs	r0, #1
	ldr	r2, [r8]
	lsl	r0, r0, fp
	movs	r3, #12
	subs	r0, r0, #1
	and	r0, r0, r10
	uxth	r0, r0
	mla	r3, r3, r4, r2
	cbnz	r7, .L932
	ldr	r3, [r3, #8]
	ldr	r3, [r3, r0, lsl #2]
	str	r3, [r5]
.L933:
	ldr	r2, [r8]
	movs	r3, #12
	mla	r4, r3, r4, r2
	ldr	r3, [r4, #4]
	adds	r2, r3, #1
	beq	.L937
	adds	r3, r3, #1
	str	r3, [r4, #4]
.L937:
	movs	r0, #0
	b	.L926
.L932:
	ldr	r1, [r5]
	ldr	r2, [r3, #8]
	str	r1, [r2, r0, lsl #2]
	ldr	r2, [r3, #4]
	orr	r2, r2, #-2147483648
	str	r2, [r3, #4]
	ldr	r3, .L939+24
	strh	r6, [r3]	@ movhi
	b	.L933
.L940:
	.align	2
.L939:
	.word	.LANCHOR152
	.word	.LANCHOR22
	.word	.LANCHOR153
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
	ldr	r5, .L951
	ubfx	r0, r1, #10, #16
	str	r1, [sp, #4]
	bl	P2V_block_in_plane
	ldr	r2, [r5]
	mov	r7, r0
	ldrh	r3, [r2, r0, lsl #1]
	cbnz	r3, .L942
	ldr	r2, .L951+4
	ldr	r4, [r2]
	cmp	r4, #0
	beq	.L943
	ldr	r2, .L951+8
	movw	lr, #65535
	ldr	ip, .L951+24
	ldr	r0, .L951+12
	ldr	r2, [r2]
	ldrh	r1, [r0]
	mov	r8, r0
	subs	r4, r4, r2
	asrs	r4, r4, #1
	mul	r4, ip, r4
	mov	ip, #6
	uxth	r4, r4
.L944:
	uxth	r0, r3
	cmp	r1, r0
	bls	.L943
	cmp	r4, r7
	bne	.L945
	mov	r1, r4
	ldr	r0, .L951+4
	bl	List_remove_node
	ldrh	r3, [r8]
	cbnz	r3, .L946
	movw	r2, #1733
	ldr	r1, .L951+16
	ldr	r0, .L951+20
	bl	printf
.L946:
	ldrh	r3, [r8]
	mov	r0, r4
	subs	r3, r3, #1
	strh	r3, [r8]	@ movhi
	bl	INSERT_DATA_LIST
	ldr	r2, [r5]
	ldrh	r3, [r2, r7, lsl #1]
.L942:
	adds	r3, r3, #1
	strh	r3, [r2, r7, lsl #1]	@ movhi
	b	.L943
.L945:
	mul	r4, ip, r4
	adds	r3, r3, #1
	ldrh	r4, [r2, r4]
	cmp	r4, lr
	bne	.L944
.L943:
	movs	r2, #1
	add	r1, sp, #4
	mov	r0, r6
	bl	log2phys
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L952:
	.align	2
.L951:
	.word	.LANCHOR42
	.word	.LANCHOR47
	.word	.LANCHOR40
	.word	.LANCHOR48
	.word	.LANCHOR154
	.word	.LC1
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
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	ldrh	r3, [r0]
	movw	r2, #65535
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r8, r0
	sub	sp, sp, #48
	cmp	r3, r2
	beq	.L1081
	ldrh	r3, [r0, #2]
	str	r3, [sp, #4]
	ldrb	r3, [r0, #6]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	str	r3, [sp, #20]
	ldr	r3, .L1091
	ldrh	r3, [r3]
	cmp	r3, r1
	mov	r3, #0
	bne	.L956
	strh	r3, [r0, #4]	@ movhi
.L1089:
	strb	r3, [r8, #6]
.L1081:
	movs	r0, #0
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L956:
	ldrh	r0, [r0, #16]
.L957:
	cmp	r0, r2
	uxth	r5, r3
	add	r3, r3, #1
	beq	.L958
	movs	r1, #1
	bl	FtlGetLastWrittenPage
	mov	r4, r0
	adds	r0, r0, #1
	beq	.L959
	ldr	r3, .L1091+4
	movs	r2, #0
	mov	r5, r2
	movw	fp, #65535
	mov	r10, #20
	ldrh	ip, [r3]
	ldr	r3, .L1091+8
	ldr	r0, [r3]
	ldr	r3, .L1091+12
	ldr	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1091+16
	ldrh	r7, [r3]
	ldr	r3, .L1091+20
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1091+24
	ldrh	lr, [r3]
	add	r3, r8, #16
	str	r3, [sp, #16]
	str	r3, [sp]
.L960:
	uxth	r3, r2
	cmp	ip, r3
	bhi	.L964
	movs	r2, #0
	mov	r1, r5
	bl	FlashReadPages
	ldr	r2, .L1091+28
	uxth	r1, r4
	movw	fp, #65535
	str	r1, [sp, #12]
	ldr	r3, [r2]
	subs	r3, r3, #1
	str	r3, [sp]
	ldr	r3, .L1091+8
	ldr	r10, [r3]
	movs	r3, #0
	mov	r7, r10
.L965:
	uxth	r1, r3
	cmp	r5, r1
	bhi	.L970
	bne	.L968
	adds	r3, r4, #1
	uxth	r3, r3
	str	r3, [sp, #8]
.L1082:
	ldr	r0, [r10, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_plane
	ldr	r3, .L1091
	mov	r10, r0
	ldr	r2, [sp, #8]
	ldrh	r3, [r3]
	cmp	r3, r2
	bne	.L972
	ldrh	r3, [sp, #8]
	strh	r3, [r8, #2]	@ movhi
	movs	r3, #0
	strb	r3, [r8, #6]
	strh	r3, [r8, #4]	@ movhi
.L972:
	ldr	r3, [sp, #8]
	ldr	r2, [sp, #4]
	cmp	r3, r2
	bne	.L973
	ldr	r3, [sp, #20]
	cmp	r10, r3
	bne	.L973
	ldr	r1, [sp, #8]
	mov	r2, r10
.L1090:
	mov	r0, r8
	bl	ftl_sb_update_avl_pages
	b	.L1081
.L958:
	uxth	r1, r3
	adds	r1, r1, #8
	ldrh	r0, [r8, r1, lsl #1]
	b	.L957
.L959:
	ldr	r3, [sp, #4]
	cbz	r3, .L961
	mov	r2, #1800
	ldr	r1, .L1091+32
	ldr	r0, .L1091+36
	bl	printf
.L961:
	ldr	r3, [sp, #20]
	cbz	r3, .L962
	cmp	r5, r3
	beq	.L962
	movw	r2, #1801
	ldr	r1, .L1091+32
	ldr	r0, .L1091+36
	bl	printf
.L962:
	movs	r3, #0
	strh	r3, [r8, #2]	@ movhi
	b	.L1089
.L964:
	ldr	r1, [sp]
	ldrh	r3, [r1], #2
	cmp	r3, fp
	str	r1, [sp]
	beq	.L963
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
.L963:
	adds	r2, r2, #1
	b	.L960
.L970:
	ldr	r1, [r7]
	cbnz	r1, .L966
	ldr	r1, [r7, #12]
	ldr	r6, [r1, #4]
	str	r1, [sp, #8]
	adds	r1, r6, #1
	beq	.L967
	ldr	r1, [r2]
	mov	r0, r6
	bl	ftl_cmp_data_ver
	cbz	r0, .L967
	adds	r6, r6, #1
	str	r6, [r2]
.L967:
	ldr	r1, [sp, #8]
	ldr	r1, [r1]
	adds	r1, r1, #1
	bne	.L969
.L968:
	uxth	r2, r4
	uxth	r3, r3
	str	r2, [sp, #8]
	movs	r2, #20
	mla	r10, r2, r3, r10
	b	.L1082
.L966:
	ldr	fp, [sp, #12]
.L969:
	adds	r3, r3, #1
	adds	r7, r7, #20
	b	.L965
.L973:
	movw	r3, #65535
	cmp	fp, r3
	bne	.L974
	ldrb	r3, [r8, #8]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L975
.L974:
	ldr	r3, .L1091+40
	uxth	r6, r4
	uxth	r4, r4
	ldr	r7, .L1091+8
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
.L978:
	cmp	r4, r6
	bhi	.L988
	ldr	r3, .L1091+4
	movw	lr, #65535
	ldr	r0, [r7]
	mov	ip, #20
	ldrh	fp, [r3]
	ldr	r3, [sp, #16]
	str	r3, [sp, #12]
	movs	r3, #0
	mov	r5, r3
	b	.L989
.L980:
	ldr	r1, [sp, #12]
	ldrh	r2, [r1], #2
	cmp	r2, lr
	str	r1, [sp, #12]
	beq	.L979
	mla	r1, ip, r5, r0
	adds	r5, r5, #1
	orr	r2, r4, r2, lsl #10
	uxth	r5, r5
	str	r2, [r1, #4]
.L979:
	adds	r3, r3, #1
.L989:
	uxth	r2, r3
	cmp	fp, r2
	bhi	.L980
	mov	r1, r5
	movs	r2, #0
	bl	FlashReadPages
	ldr	r3, .L1091+40
	movs	r1, #20
	movs	r0, #0
	movw	ip, #65535
	ldr	r2, [r3]
	ldr	r3, [r7]
	mla	r5, r1, r5, r3
.L981:
	cmp	r5, r3
	bne	.L986
	cbz	r0, .L987
	ldr	r3, .L1091+40
	str	r2, [r3]
.L987:
	adds	r4, r4, #1
	uxth	r4, r4
	b	.L978
.L1092:
	.align	2
.L1091:
	.word	.LANCHOR19
	.word	.LANCHOR3
	.word	.LANCHOR103
	.word	.LANCHOR64
	.word	.LANCHOR23
	.word	.LANCHOR65
	.word	.LANCHOR24
	.word	.LANCHOR83
	.word	.LANCHOR155
	.word	.LC1
	.word	.LANCHOR134
.L986:
	ldr	r1, [r3]
	cmp	r1, #0
	beq	.L982
	cbz	r0, .L975
.L1083:
	ldr	r3, .L1093
	str	r2, [r3]
.L975:
	ldr	fp, [sp, #4]
	movs	r2, #1
	ldr	r6, .L1093+4
	ldr	r3, .L1093+8
	strh	r2, [r3]	@ movhi
.L990:
	ldr	r3, .L1093+12
	movw	lr, #65535
	ldr	r0, [r6]
	movs	r7, #20
	ldr	r1, [sp, #16]
	ldrh	r4, [r3]
	movs	r3, #0
	str	r3, [sp, #12]
.L991:
	uxth	r2, r3
	cmp	r4, r2
	bhi	.L993
	movs	r2, #0
	ldr	r1, [sp, #12]
	bl	FlashReadPages
	movs	r3, #0
.L1088:
	str	r3, [sp, #24]
	ldr	r2, [sp, #12]
	ldrh	r3, [sp, #24]
	cmp	r2, r3
	bhi	.L1024
	ldr	r3, .L1093+16
	add	fp, fp, #1
	uxth	fp, fp
	ldrh	r3, [r3]
	cmp	r3, fp
	bne	.L990
	ldr	r2, .L1093+12
	movw	r0, #65535
	movs	r3, #0
	strh	fp, [r8, #2]	@ movhi
	strh	r3, [r8, #4]	@ movhi
	ldrh	r2, [r2]
.L1025:
	uxth	r1, r3
	cmp	r1, r2
	bcs	.L1081
	ldr	r1, [sp, #16]
	ldrh	r4, [r1], #2
	cmp	r4, r0
	str	r1, [sp, #16]
	add	r1, r3, #1
	bne	.L1089
	mov	r3, r1
	b	.L1025
.L982:
	ldr	r1, [r3, #12]
	ldrh	lr, [r1]
	cmp	lr, ip
	beq	.L985
	ldr	r1, [r1, #4]
	cmp	r1, #-1
	itt	ne
	movne	r2, r1
	movne	r0, #1
.L985:
	adds	r3, r3, #20
	b	.L981
.L988:
	mov	r2, #-1
	b	.L1083
.L993:
	ldrh	r2, [r1], #2
	cmp	r2, lr
	beq	.L992
	ldr	r5, [sp, #12]
	orr	r2, fp, r2, lsl #10
	mla	ip, r7, r5, r0
	str	r2, [ip, #4]
	mov	r2, r5
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #12]
.L992:
	adds	r3, r3, #1
	b	.L991
.L1024:
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
	bcc	.L995
	ldr	r3, [sp, #28]
	bne	.L996
	ldr	r2, [sp, #20]
	cmp	r2, r0
	bhi	.L995
.L996:
	ldr	r2, [sp, #8]
	cmp	fp, r2
	bne	.L997
	cmp	r10, r0
	beq	.L998
.L997:
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L999
	ldr	r3, [r7, #12]
	movw	r2, #61589
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L1000
	ldrh	r0, [r8]
.L1086:
	bl	decrement_vpc_count
	b	.L995
.L1000:
	ldr	r2, [r3, #4]
	str	r2, [sp]
	adds	r2, r2, #1
	beq	.L1001
	ldr	r2, .L1093+20
	ldr	r0, [sp]
	ldr	r1, [r2]
	bl	ftl_cmp_data_ver
	cbz	r0, .L1001
	ldr	r1, [sp]
	adds	r1, r1, #1
	str	r1, [r2]
.L1001:
	ldr	r4, [r3, #8]
	add	r1, sp, #40
	ldr	r3, [r3, #12]
	movs	r2, #0
	mov	r0, r4
	str	r3, [sp, #36]
	bl	log2phys
	ldr	r3, .L1093
	ldr	r1, [r3]
	adds	r3, r1, #1
	beq	.L1002
	ldr	r0, [sp]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1002
	ldr	r3, [sp, #36]
	adds	r7, r3, #1
	beq	.L1003
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
	bne	.L1004
.L1005:
	mov	r3, #-1
	str	r3, [sp, #36]
.L1012:
	ldr	r7, [sp, #36]
	adds	r0, r7, #1
	beq	.L995
.L1028:
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1093+24
	mov	r4, r0
	ldrh	r3, [r3]
	cmp	r3, r0
	bhi	.L1020
	movw	r2, #2065
	ldr	r1, .L1093+28
	ldr	r0, .L1093+32
	bl	printf
.L1020:
	ldr	r3, .L1093+36
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cmp	r3, #0
	beq	.L1021
	mov	r0, r4
	b	.L1086
.L1003:
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #40]
	cmp	r2, r3
	bne	.L995
	movs	r2, #1
	add	r1, sp, #36
	mov	r0, r4
	bl	log2phys
.L995:
	ldr	r3, [sp, #24]
	adds	r3, r3, #1
	b	.L1088
.L1004:
	ldr	r1, [r7, #8]
	cmp	r4, r1
	bne	.L1005
	ldr	r0, .L1093
	ldr	r1, [r7, #4]
	ldr	r0, [r0]
	str	r1, [sp, #28]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1005
	ldr	r1, [sp, #40]
	ldr	r0, [sp, #44]
	cmp	r1, r0
	bne	.L1007
.L1010:
	ldr	r1, [sp, #36]
	mov	r0, r4
	bl	FtlReUsePrevPpa
	b	.L1005
.L1007:
	ldr	r0, [sp, #36]
	cmp	r1, r0
	beq	.L1005
	adds	r0, r1, #1
	beq	.L1008
	str	r1, [r3, #4]
	movs	r2, #0
	movs	r1, #1
	mov	r0, r3
	ldr	r7, [r3, #12]
	bl	FlashReadPages
.L1009:
	ldr	r3, [r6]
	ldr	r3, [r3, r5]
	adds	r3, r3, #1
	beq	.L1010
	ldr	r3, [r7, #4]
	ldr	r2, .L1093
	mov	r1, r3
	ldr	r0, [r2]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1010
	mov	r1, r3
	ldr	r0, [sp, #28]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	beq	.L1005
	b	.L1010
.L1008:
	str	r1, [r2, r5]
	b	.L1009
.L1094:
	.align	2
.L1093:
	.word	.LANCHOR134
	.word	.LANCHOR103
	.word	.LANCHOR156
	.word	.LANCHOR3
	.word	.LANCHOR19
	.word	.LANCHOR83
	.word	.LANCHOR5
	.word	.LANCHOR155
	.word	.LC1
	.word	.LANCHOR42
.L1002:
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #40]
	cmp	r2, r3
	beq	.L1012
	ldr	r2, .L1095
	ldr	r3, [sp, #36]
	ldr	r2, [r2]
	cmp	r2, r3, lsr #10
	bhi	.L1014
	adds	r3, r3, #1
.L1085:
	bne	.L995
	movs	r2, #1
	add	r1, sp, #44
	mov	r0, r4
	bl	log2phys
	ldr	r7, [sp, #40]
	adds	r5, r7, #1
	beq	.L1012
	ldr	r3, [sp, #36]
	cmp	r7, r3
	beq	.L1028
	ubfx	r0, r7, #10, #16
	bl	P2V_block_in_plane
	ldr	r3, .L1095+4
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L1019
	ldr	r3, .L1095+8
	ldrh	r3, [r3]
	cmp	r3, r0
	beq	.L1019
	ldr	r3, .L1095+12
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L1012
.L1019:
	ldr	r0, [r6]
	movs	r2, #0
	movs	r1, #1
	str	r7, [r0, #4]
	ldr	r5, [r0, #12]
	bl	FlashReadPages
	ldr	r3, [r6]
	ldr	r3, [r3]
	adds	r3, r3, #1
	beq	.L1012
	ldr	r1, [r5, #4]
	ldr	r0, [sp]
	bl	ftl_cmp_data_ver
	cmp	r0, #0
	bne	.L1012
	movs	r2, #1
	add	r1, sp, #40
	mov	r0, r4
	bl	log2phys
	b	.L1012
.L1014:
	ldr	r0, [r6]
	movs	r2, #0
	movs	r1, #1
	ldr	r5, [r0, #12]
	str	r3, [r0, #4]
	bl	FlashReadPages
	ldr	r3, [r5, #8]
	cmp	r4, r3
	bne	.L995
	ldrh	r2, [r5]
	movw	r3, #61589
	cmp	r2, r3
	b	.L1085
.L1021:
	mov	r1, r4
	ldr	r0, .L1095+16
	bl	printf
	b	.L995
.L999:
	ldr	r3, .L1095+20
	ldr	r3, [r3]
	cmp	r3, #31
	bhi	.L1022
	ldr	r2, .L1095+24
	str	r4, [r2, r3, lsl #2]
	adds	r3, r3, #1
	ldr	r2, .L1095+20
	str	r3, [r2]
.L1022:
	ldrh	r0, [r8]
	bl	decrement_vpc_count
	ldr	r3, .L1095+28
	ldr	r2, [r3]
	adds	r1, r2, #1
	bne	.L1023
	ldr	r2, [sp]
.L1087:
	str	r2, [r3]
	b	.L995
.L1023:
	ldr	r1, [sp]
	cmp	r1, r2
	bcs	.L995
	mov	r2, r1
	b	.L1087
.L998:
	strb	r10, [r8, #6]
	mov	r2, r10
	strh	fp, [r8, #2]	@ movhi
	mov	r1, fp
	b	.L1090
.L1096:
	.align	2
.L1095:
	.word	.LANCHOR8
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LC24
	.word	.LANCHOR157
	.word	.LANCHOR158
	.word	.LANCHOR134
	.size	FtlRecoverySuperblock, .-FtlRecoverySuperblock
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
	ldr	r6, .L1121
	ldr	r5, .L1121+4
	ldr	r1, .L1121+8
	ldr	r0, .L1121+12
	bl	printf
	mov	r2, #8192
	movs	r1, #0
	ldr	r0, .L1121+4
	bl	ftl_memset
.L1098:
	ldr	r3, [r6]
	cmp	r4, r3
	bcc	.L1100
	ldr	r10, .L1121+48
	movs	r4, #0
	ldr	r7, .L1121+16
	mov	r6, r4
.L1101:
	ldrh	r2, [r10]
	uxth	r3, r4
	cmp	r2, r3
	bhi	.L1103
	ldr	r3, .L1121+20
	ldr	r4, [r3]
	cbz	r4, .L1104
	ldr	r3, .L1121+24
	mov	r8, #0
	ldr	r5, .L1121+28
	ldr	r10, .L1121+16
	ldrh	r7, [r3]
	ldr	r3, [r5]
	ldr	fp, .L1121+4
	subs	r4, r4, r3
	ldr	r3, .L1121+32
	asrs	r4, r4, #1
	muls	r4, r3, r4
	uxth	r4, r4
.L1105:
	uxth	r3, r8
	cmp	r7, r3
	bls	.L1104
	ldr	r3, [r10]
	ldrh	r2, [r3, r4, lsl #1]
	cbz	r2, .L1106
	movs	r6, #1
	ldrh	r3, [fp, r4, lsl #1]
	mov	r1, r4
	ldr	r0, .L1121+36
	bl	printf
.L1106:
	movs	r3, #6
	ldr	r2, [r5]
	muls	r4, r3, r4
	movw	r3, #65535
	add	r8, r8, #1
	ldrh	r4, [r2, r4]
	cmp	r4, r3
	bne	.L1105
.L1104:
	cbz	r6, .L1097
	movw	r2, #2389
	ldr	r1, .L1121+8
	ldr	r0, .L1121+40
	bl	printf
.L1097:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1100:
	movs	r2, #0
	add	r1, sp, #4
	mov	r0, r4
	bl	log2phys
	ldr	r0, [sp, #4]
	adds	r3, r0, #1
	beq	.L1099
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r5, r0, lsl #1]
	adds	r3, r3, #1
	strh	r3, [r5, r0, lsl #1]	@ movhi
.L1099:
	adds	r4, r4, #1
	b	.L1098
.L1103:
	ldr	r3, [r7]
	uxth	r5, r4
	ldr	r8, .L1121+4
	ldrh	r2, [r3, r5, lsl #1]
	ldrh	r3, [r8, r5, lsl #1]
	cmp	r2, r3
	beq	.L1102
	mov	r1, r5
	ldr	r0, .L1121+44
	bl	printf
	ldr	r3, [r7]
	movw	r2, #65535
	ldrh	r3, [r3, r5, lsl #1]
	cmp	r3, r2
	beq	.L1102
	ldrh	r2, [r8, r5, lsl #1]
	cmp	r2, r3
	it	hi
	movhi	r6, #1
.L1102:
	adds	r4, r4, #1
	b	.L1101
.L1122:
	.align	2
.L1121:
	.word	.LANCHOR152
	.word	check_vpc_table
	.word	.LANCHOR159
	.word	.LC25
	.word	.LANCHOR42
	.word	.LANCHOR47
	.word	.LANCHOR48
	.word	.LANCHOR40
	.word	-1431655765
	.word	.LC27
	.word	.LC1
	.word	.LC26
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
	ldr	r7, .L1137
	sub	sp, sp, #32
	movs	r1, #0
	ldr	r8, .L1137+24
	ldr	r0, .L1137+4
	bl	printf
.L1124:
	ldr	r3, [r7]
	cmp	r5, r3
	bcc	.L1130
	add	sp, sp, #32
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1130:
	movs	r2, #0
	add	r1, sp, #28
	mov	r0, r5
	bl	log2phys
	ubfx	r3, r5, #0, #11
	cbnz	r3, .L1125
	ldr	r2, [sp, #28]
	mov	r1, r5
	mov	r0, r8
	bl	printf
.L1125:
	ldr	r3, [sp, #28]
	adds	r2, r3, #1
	beq	.L1127
	ldr	r4, .L1137+8
	movs	r2, #0
	movs	r1, #1
	str	r3, [r4, #4]
	mov	r0, r4
	ldr	r3, .L1137+12
	str	r5, [r4, #16]
	str	r2, [r4]
	ldr	r3, [r3]
	str	r3, [r4, #8]
	ldr	r3, .L1137+16
	ldr	r6, [r3]
	str	r6, [r4, #12]
	bl	FlashReadPages
	ldr	r3, [r4]
	cmp	r3, #256
	beq	.L1128
	adds	r3, r3, #1
	beq	.L1128
	ldr	r3, [r6, #8]
	cmp	r5, r3
	beq	.L1127
.L1128:
	ldr	r2, [r4, #8]
	ldr	r3, [r4, #12]
	ldr	r0, .L1137+20
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
.L1127:
	adds	r5, r5, #1
	b	.L1124
.L1138:
	.align	2
.L1137:
	.word	.LANCHOR152
	.word	.LC28
	.word	.LANCHOR138
	.word	.LANCHOR106
	.word	.LANCHOR114
	.word	.LC30
	.word	.LC29
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
	ldr	r3, .L1169
	movw	r2, #65535
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #48
	mov	r4, r0
	ldrh	r5, [r3]
	str	r3, [sp, #20]
	cmp	r5, r2
	beq	.L1161
	cbnz	r5, .L1140
.L1141:
	bl	FtlGcPageVarInit
	b	.L1142
.L1161:
	movs	r5, #0
.L1140:
	ldr	r3, .L1169+4
	ldrh	r3, [r3]
	cmp	r3, r1
	beq	.L1141
.L1142:
	ldr	fp, .L1169+52
.L1143:
	ldrh	r2, [r4]
	movs	r3, #0
	strb	r3, [r4, #8]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1144
.L1160:
	ldr	r3, .L1169+8
	movs	r2, #0
	ldr	r0, [fp]
	mov	r10, r2
	movw	lr, #65535
	mov	r8, #20
	ldrh	r3, [r3]
	str	r3, [sp, #8]
	ldr	r3, .L1169+12
	ldr	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1169+16
	ldrh	r3, [r3]
	str	r3, [sp, #16]
	ldr	r3, .L1169+20
	ldr	r7, [r3]
	ldr	r3, .L1169+24
	ldrh	ip, [r3]
	add	r3, r4, #16
	str	r3, [sp, #4]
.L1145:
	ldr	r1, [sp, #8]
	uxth	r3, r2
	cmp	r1, r3
	bhi	.L1147
	mov	r8, #0
	movs	r2, #0
	mov	r1, r10
	bl	FlashReadPages
.L1148:
	uxth	r3, r8
	cmp	r10, r3
	bhi	.L1159
	ldr	r3, .L1169+4
	adds	r5, r5, #1
	uxth	r5, r5
	ldrh	r3, [r3]
	cmp	r3, r5
	bhi	.L1160
.L1144:
	ldr	r2, [sp, #20]
	movw	r3, #65535
	mov	r0, r4
	strh	r5, [r4, #2]	@ movhi
	mov	r1, r5
	strh	r3, [r2]	@ movhi
	movs	r2, #0
	strb	r2, [r4, #6]
	bl	ftl_sb_update_avl_pages
	mov	r0, #-1
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1147:
	ldr	r1, [sp, #4]
	ldrh	r3, [r1], #2
	cmp	r3, lr
	str	r1, [sp, #4]
	beq	.L1146
	mla	r1, r8, r10, r0
	orr	r3, r5, r3, lsl #10
	str	r3, [r1, #4]
	ldr	r3, [sp, #16]
	mul	r3, r3, r10
	bic	r3, r3, #3
	mov	r6, r3
	ldr	r3, [sp, #12]
	add	r6, r6, r3
	mul	r3, ip, r10
	str	r6, [r1, #8]
	bic	r3, r3, #3
	add	r3, r3, r7
	str	r3, [r1, #12]
	add	r3, r10, #1
	uxth	r10, r3
.L1146:
	adds	r2, r2, #1
	b	.L1145
.L1159:
	movs	r3, #20
	ldr	r1, [fp]
	mul	r3, r3, r8
	adds	r2, r1, r3
	ldr	r6, [r1, r3]
	ldr	r0, [r2, #4]
	str	r0, [sp, #4]
	cbnz	r6, .L1149
	ldr	r7, [r2, #12]
	movw	r2, #65535
	ldrh	r1, [r7]
	cmp	r1, r2
	beq	.L1149
	ldr	r2, .L1169+28
	ldr	r0, [r7, #8]
	ldr	r2, [r2]
	cmp	r0, r2
	bls	.L1151
.L1149:
	ldr	r3, .L1169+32
	movs	r1, #0
	ldrh	r2, [r4]
	movs	r5, #0
	ldr	r3, [r3]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r4]
	bl	INSERT_FREE_LIST
	movw	r3, #65535
	strh	r3, [r4]	@ movhi
	bl	FtlGcPageVarInit
	b	.L1143
.L1151:
	mov	r2, r6
	add	r1, sp, #24
	str	r3, [sp, #8]
	bl	log2phys
	ldr	r2, [r7, #12]
	ldr	r1, [sp, #24]
	ldr	r3, [sp, #8]
	cmp	r2, r1
	beq	.L1153
.L1154:
	ldr	r2, [r7, #8]
	add	r8, r8, #1
	ldr	r1, [sp, #4]
	ldr	r0, [r7, #12]
	bl	FtlGcUpdatePage
	b	.L1148
.L1153:
	str	r3, [sp, #8]
	adds	r3, r2, #1
	beq	.L1154
	str	r2, [sp, #32]
	movs	r1, #1
	ldr	r2, .L1169+36
	add	r0, sp, #28
	ldr	r2, [r2]
	str	r2, [sp, #36]
	ldr	r2, .L1169+40
	ldr	r2, [r2]
	str	r2, [sp, #40]
	mov	r2, r6
	bl	FlashReadPages
	ldr	r2, .L1169+44
	ldr	r1, [fp]
	ldr	r3, [sp, #8]
	ldrh	r2, [r2]
	ldr	r0, [sp, #36]
	add	ip, r3, r1
	lsls	r2, r2, #7
.L1155:
	cmp	r6, r2
	beq	.L1154
	ldr	r1, [ip, #8]
	ldr	r3, [r0, r6, lsl #2]
	ldr	r1, [r1, r6, lsl #2]
	cmp	r1, r3
	beq	.L1156
	ldr	r2, [sp, #32]
	ldrh	r1, [r4]
	ldr	r0, .L1169+48
	bl	printf
	b	.L1149
.L1156:
	adds	r6, r6, #1
	b	.L1155
.L1170:
	.align	2
.L1169:
	.word	.LANCHOR160
	.word	.LANCHOR19
	.word	.LANCHOR3
	.word	.LANCHOR64
	.word	.LANCHOR23
	.word	.LANCHOR65
	.word	.LANCHOR24
	.word	.LANCHOR152
	.word	.LANCHOR42
	.word	.LANCHOR110
	.word	.LANCHOR115
	.word	.LANCHOR12
	.word	.LC31
	.word	.LANCHOR103
	.size	FtlGcScanTempBlk, .-FtlGcScanTempBlk
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
	ldr	r3, .L1183
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #104
	str	r2, [sp]
	adds	r2, r0, r1
	mov	r7, r0
	mov	r5, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L1179
	ldr	r3, .L1183+4
	mov	r8, #0
	ldrh	r6, [r3]
	lsr	r6, r0, r6
	lsl	fp, r6, #2
.L1173:
	cbnz	r5, .L1178
.L1171:
	mov	r0, r8
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1178:
	ldr	r3, .L1183+8
	mov	r0, r7
	ldr	r10, .L1183+24
	ldr	r3, [r3]
	ldr	r2, [r3, fp]
	ldr	r3, .L1183+12
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
	cbz	r2, .L1175
	cmp	r4, r3
	beq	.L1175
	ldr	r3, [r10]
	add	r0, sp, #20
	str	r2, [sp, #24]
	movs	r2, #1
	mov	r1, r2
	str	r3, [sp, #28]
	add	r3, sp, #40
	str	r3, [sp, #32]
	bl	FlashReadPages
.L1176:
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
	ldr	r0, .L1183+16
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
	b	.L1173
.L1175:
	ldr	r3, .L1183+20
	movs	r1, #0
	ldr	r0, [r10]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L1176
.L1179:
	mov	r8, #-1
	b	.L1171
.L1184:
	.align	2
.L1183:
	.word	.LANCHOR16
	.word	.LANCHOR22
	.word	.LANCHOR123
	.word	.LANCHOR12
	.word	.LANCHOR161
	.word	.LANCHOR23
	.word	.LANCHOR108
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
	ldr	r2, .L1187
	ldr	r3, .L1187+4
	ldr	r1, [r2]
	cmp	r1, r3
	bne	.L1185
	ldr	r3, .L1187+8
	movs	r1, #1
	movs	r0, #0
	str	r3, [r2, #4]
	ldr	r3, .L1187+12
	ldr	r3, [r3]
	str	r3, [r2, #88]
	ldr	r3, .L1187+16
	ldr	r3, [r3]
	str	r3, [r2, #92]
	ldr	r3, .L1187+20
	ldr	r3, [r3]
	str	r3, [r2, #8]
	ldr	r3, .L1187+24
	ldr	r3, [r3]
	str	r3, [r2, #12]
	ldr	r3, .L1187+28
	ldr	r3, [r3]
	str	r3, [r2, #16]
	ldr	r3, .L1187+32
	ldr	r3, [r3]
	str	r3, [r2, #20]
	ldr	r3, .L1187+36
	ldr	r3, [r3]
	str	r3, [r2, #28]
	ldr	r3, .L1187+40
	ldr	r3, [r3]
	str	r3, [r2, #32]
	ldr	r3, .L1187+44
	ldr	r3, [r3]
	str	r3, [r2, #36]
	ldr	r3, .L1187+48
	ldr	r3, [r3]
	str	r3, [r2, #40]
	ldr	r3, .L1187+52
	ldr	r3, [r3]
	str	r3, [r2, #44]
	ldr	r3, .L1187+56
	ldr	r3, [r3]
	str	r3, [r2, #48]
	b	FtlVendorPartWrite
.L1185:
	bx	lr
.L1188:
	.align	2
.L1187:
	.word	.LANCHOR135
	.word	1179929683
	.word	1342177352
	.word	.LANCHOR162
	.word	.LANCHOR163
	.word	.LANCHOR84
	.word	.LANCHOR85
	.word	.LANCHOR89
	.word	.LANCHOR88
	.word	.LANCHOR91
	.word	.LANCHOR80
	.word	.LANCHOR86
	.word	.LANCHOR87
	.word	.LANCHOR92
	.word	.LANCHOR93
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
	ldr	r2, .L1194
	push	{r3, lr}
	ldrh	r3, [r2]
	cmp	r3, #31
	itett	ls
	addls	r3, r3, #1
	movhi	r3, #32
	strhls	r3, [r2]	@ movhi
	movls	r3, #1
	ldr	r2, .L1194+4
	cbnz	r0, .L1191
	ldr	r1, [r2]
	ldr	r0, [r1, #20]
	ldr	r1, [r1, #16]
	add	r3, r3, r0
	cmp	r1, r3
	bcc	.L1192
.L1191:
	ldr	r2, [r2]
	movs	r0, #64
	ldr	r3, [r2, #16]
	str	r3, [r2, #20]
	ldr	r3, .L1194+8
	str	r3, [r2]
	ldr	r3, .L1194+12
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
.L1192:
	movs	r0, #0
	pop	{r3, pc}
.L1195:
	.align	2
.L1194:
	.word	.LANCHOR164
	.word	.LANCHOR118
	.word	1112818501
	.word	.LANCHOR116
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
	ldr	r3, .L1207
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	mov	r10, r2
	adds	r2, r0, r1
	sub	sp, sp, #104
	mov	r7, r0
	mov	r6, r1
	ldrh	r3, [r3]
	cmp	r2, r3
	bhi	.L1206
	ldr	r3, .L1207+4
	mov	r8, #0
	ldr	fp, .L1207+28
	ldrh	r5, [r3]
	lsr	r5, r0, r5
	lsls	r3, r5, #2
	str	r3, [sp]
.L1199:
	cbnz	r6, .L1205
.L1197:
	mov	r0, r8
	add	sp, sp, #104
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1205:
	ldr	r3, .L1207+8
	mov	r0, r7
	ldr	r2, [sp]
	ldr	r3, [r3]
	ldr	r3, [r3, r2]
	ldr	r2, .L1207+12
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
	beq	.L1201
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
	ldr	r2, .L1207+16
	it	eq
	moveq	r8, #-1
	ldr	r2, [r2]
	cmp	r2, #256
	bne	.L1203
	mov	r2, r3
	mov	r1, r5
	ldr	r0, .L1207+20
	bl	printf
	ldr	r2, [fp]
	mov	r1, r5
	ldr	r0, .L1207+24
	bl	FtlMapWritePage
.L1203:
	ldr	r1, [fp]
	lsls	r2, r4, #9
	ldr	r3, [sp, #4]
	mov	r0, r10
	add	r1, r1, r3, lsl #9
	bl	ftl_memcpy
.L1204:
	ldr	r3, [sp, #8]
	adds	r5, r5, #1
	subs	r6, r6, r4
	add	r7, r7, r4
	add	r10, r10, r3
	ldr	r3, [sp]
	adds	r3, r3, #4
	str	r3, [sp]
	b	.L1199
.L1201:
	lsls	r2, r4, #9
	mov	r1, r3
	mov	r0, r10
	bl	ftl_memset
	b	.L1204
.L1206:
	mov	r8, #-1
	b	.L1197
.L1208:
	.align	2
.L1207:
	.word	.LANCHOR16
	.word	.LANCHOR22
	.word	.LANCHOR123
	.word	.LANCHOR12
	.word	.LANCHOR138
	.word	.LC32
	.word	.LANCHOR161
	.word	.LANCHOR108
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
	ldr	r4, .L1211
	ldr	r5, .L1211+4
	ldr	r2, [r4]
	ldrh	r1, [r5]
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	ldr	r2, [r3]
	ldr	r3, .L1211+8
	cmp	r2, r3
	beq	.L1210
	ldr	r1, .L1211+12
	ldr	r0, .L1211+16
	bl	printf
	ldrh	r2, [r5]
	movs	r1, #0
	ldr	r0, [r4]
	lsls	r2, r2, #9
	bl	ftl_memset
.L1210:
	movs	r0, #0
	pop	{r3, r4, r5, pc}
.L1212:
	.align	2
.L1211:
	.word	.LANCHOR118
	.word	.LANCHOR116
	.word	1112818501
	.word	.LC33
	.word	.LC34
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
	ldr	r4, .L1216
	movs	r0, #0
	ldr	r5, .L1216+4
	mov	r2, r4
	bl	FtlVendorPartRead
	ldr	r3, [r4]
	cmp	r3, r5
	beq	.L1214
	mov	r2, #512
	movs	r1, #0
	mov	r0, r4
	bl	ftl_memset
	str	r5, [r4]
.L1214:
	ldr	r3, [r4]
	cmp	r3, r5
	ldr	r3, .L1216+8
	bne	.L1215
	ldr	r1, [r4, #88]
	ldr	r2, .L1216+12
	str	r1, [r2]
	ldr	r1, [r4, #92]
	ldr	r2, .L1216+16
	str	r1, [r2]
	ldr	r1, [r4, #8]
	ldr	r2, .L1216+20
	str	r1, [r2]
	ldr	r1, [r4, #12]
	ldr	r2, .L1216+24
	str	r1, [r2]
	ldr	r1, [r4, #16]
	ldr	r2, .L1216+28
	str	r1, [r2]
	ldr	r1, [r4, #20]
	ldr	r2, .L1216+32
	str	r1, [r2]
	ldr	r2, [r4, #28]
	ldr	r1, [r4, #32]
	str	r2, [r3]
	ldr	r2, .L1216+36
	str	r1, [r2]
	ldr	r1, [r4, #36]
	ldr	r2, .L1216+40
	str	r1, [r2]
	ldr	r1, [r4, #40]
	ldr	r2, .L1216+44
	str	r1, [r2]
	ldr	r1, [r4, #44]
	ldr	r2, .L1216+48
	str	r1, [r2]
	ldr	r1, [r4, #48]
	ldr	r2, .L1216+52
	str	r1, [r2]
.L1215:
	ldr	r1, .L1216+56
	ldr	r2, .L1216+60
	ldr	r3, [r3]
	ldr	r0, [r1]
	ldrh	r2, [r2]
	ldr	r1, .L1216+64
	mla	r0, r0, r2, r3
	ldrh	r1, [r1]
	bl	__aeabi_uidiv
	ldr	r3, .L1216+68
	str	r0, [r3]
	pop	{r3, r4, r5, pc}
.L1217:
	.align	2
.L1216:
	.word	.LANCHOR135
	.word	1179929683
	.word	.LANCHOR91
	.word	.LANCHOR162
	.word	.LANCHOR163
	.word	.LANCHOR84
	.word	.LANCHOR85
	.word	.LANCHOR89
	.word	.LANCHOR88
	.word	.LANCHOR80
	.word	.LANCHOR86
	.word	.LANCHOR87
	.word	.LANCHOR92
	.word	.LANCHOR93
	.word	.LANCHOR90
	.word	.LANCHOR14
	.word	.LANCHOR5
	.word	.LANCHOR145
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
	push	{r3, r4, r5, r6, r7, r8, r10, lr}
	mov	r4, r0
	ldr	r3, [r0, #36]
	cmp	r3, #0
	beq	.L1219
	movs	r3, #0
	ldr	r5, .L1231
	str	r3, [r0, #36]
	ldr	r3, .L1231+4
	ldrh	r6, [r0, #6]
	mov	r7, r5
	ldr	r10, [r0, #24]
	ldr	r3, [r3]
	str	r3, [r5, #8]
	ldr	r3, .L1231+8
	ldr	r8, [r3]
	ldrh	r3, [r0, #2]
	str	r8, [r5, #12]
	cbz	r3, .L1221
	ldr	r2, .L1231+12
	ldrh	r2, [r2]
	subs	r2, r2, #1
	cmp	r3, r2
	bge	.L1221
	ldrh	r2, [r0]
	movw	r1, #65535
	cmp	r2, r1
	beq	.L1221
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
	beq	.L1221
	ldr	r3, [r4, #24]
	ldrh	r1, [r8, #8]
	ldr	r2, [r3, r1, lsl #2]
	ldr	r3, [r5, #4]
	cmp	r2, r3
	bne	.L1221
	ldr	r2, [r5, #8]
.L1230:
	mov	r0, r4
	pop	{r3, r4, r5, r6, r7, r8, r10, lr}
	b	FtlMapWritePage
.L1221:
	subs	r6, r6, #1
	uxth	r6, r6
	ldr	r3, [r10, r6, lsl #2]
	str	r3, [r7, #4]
	cbz	r3, .L1222
	movs	r2, #1
	ldr	r0, .L1231
	mov	r1, r2
	bl	FlashReadPages
.L1223:
	ldr	r2, [r7, #8]
	mov	r1, r6
	b	.L1230
.L1222:
	ldr	r3, .L1231+16
	movs	r1, #255
	ldr	r0, [r7, #8]
	ldrh	r2, [r3]
	bl	ftl_memset
	b	.L1223
.L1219:
	pop	{r3, r4, r5, r6, r7, r8, r10, pc}
.L1232:
	.align	2
.L1231:
	.word	.LANCHOR138
	.word	.LANCHOR107
	.word	.LANCHOR114
	.word	.LANCHOR20
	.word	.LANCHOR23
	.size	FtlMapBlkWriteDump_data, .-FtlMapBlkWriteDump_data
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
	mov	r10, #0
	ldr	r5, .L1248
	ldr	r3, .L1248+4
	ldr	fp, .L1248+76
	ldr	r6, .L1248+8
	ldr	r7, [r3]
	ldr	r0, [fp]
	ldrh	r3, [r5]
	str	r7, [r6, #12]
	str	r0, [r6, #8]
	strh	r3, [r7, #2]	@ movhi
	movw	r3, #61604
	ldr	r4, .L1248+12
	strh	r3, [r7]	@ movhi
	ldr	r2, .L1248+16
	ldr	r3, [r5, #8]
	ldr	ip, .L1248+80
	str	r10, [r7, #8]
	str	r3, [r7, #4]
	stm	r4, {r2, ip}
	ldrh	r2, [r5, #6]
	str	r10, [r7, #12]
	ldr	r8, .L1248+84
	strh	r2, [r4, #8]	@ movhi
	ldr	r2, .L1248+20
	ldr	r3, .L1248+24
	ldrh	r2, [r2]
	strb	r2, [r4, #10]
	ldr	r2, .L1248+28
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r4, #14]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r4, #11]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1248+32
	strh	r1, [r4, #16]	@ movhi
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r4, #18]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r4, #12]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1248+36
	strh	r1, [r4, #20]	@ movhi
	ldrh	r1, [r2]
	ldrh	ip, [r2, #2]
	strh	r1, [r4, #22]	@ movhi
	ldrb	r1, [r2, #6]	@ zero_extendqisi2
	ldrb	r2, [r2, #8]	@ zero_extendqisi2
	strb	r2, [r4, #13]
	orr	r1, r1, ip, lsl #6
	ldr	r2, .L1248+40
	strh	r1, [r4, #24]	@ movhi
	movs	r1, #255
	ldr	r2, [r2]
	str	r2, [r4, #32]
	ldr	r2, [r8]
	str	r2, [r4, #40]
	ldr	r2, .L1248+44
	ldr	r2, [r2]
	str	r2, [r4, #36]
	ldrh	r2, [r3]
	bl	ftl_memset
	mov	r1, r4
	ldr	r4, .L1248+48
	movs	r2, #48
	ldr	r0, [r6, #8]
	bl	ftl_memcpy
	ldrh	r2, [r4]
	ldr	r0, [r6, #8]
	ldr	r1, .L1248+52
	lsls	r2, r2, #1
	adds	r0, r0, #48
	ldr	r1, [r1]
	bl	ftl_memcpy
	ldrh	r0, [r4]
	ldr	r1, .L1248+56
	ldr	r4, [r6, #8]
	lsrs	r2, r0, #3
	adds	r0, r0, #24
	lsls	r0, r0, #1
	ldr	r1, [r1]
	adds	r2, r2, #4
	bic	r0, r0, #3
	add	r0, r0, r4
	mov	r4, r10
	bl	ftl_memcpy
	mov	r0, r10
	ldr	r10, .L1248+4
	bl	FtlUpdateVaildLpn
	movw	r3, #65535
	str	r3, [sp]
	ldr	r3, .L1248+24
	str	r3, [sp, #4]
.L1234:
	ldr	r3, [fp]
	ldrh	r1, [r5, #2]
	ldrh	r2, [r5]
	str	r3, [r6, #8]
	ldr	r3, [r10]
	str	r3, [r6, #12]
	orr	r3, r1, r2, lsl #10
	str	r3, [r6, #4]
	ldr	r3, .L1248+60
	ldrh	r3, [r3]
	subs	r3, r3, #1
	cmp	r1, r3
	blt	.L1235
	ldrh	r3, [r5, #4]
	strh	r2, [r5, #4]	@ movhi
	str	r3, [sp]
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, [r8]
	strh	r0, [r5]	@ movhi
	adds	r2, r3, #1
	str	r3, [r5, #8]
	str	r2, [r8]
	lsls	r2, r0, #10
	str	r2, [r6, #4]
	str	r3, [r7, #4]
	strh	r0, [r7, #2]	@ movhi
.L1235:
	ldr	r3, [sp, #4]
	ldr	r0, [fp]
	ldrh	r1, [r3]
	bl	js_hash
	movs	r3, #1
	str	r0, [r7, #12]
	mov	r2, r3
	mov	r1, r3
	ldr	r0, .L1248+8
	bl	FlashProgPages
	ldrh	r3, [r5, #2]
	ldr	r2, [r6]
	adds	r3, r3, #1
	uxth	r3, r3
	adds	r1, r2, #1
	strh	r3, [r5, #2]	@ movhi
	bne	.L1236
	cmp	r3, #1
	bne	.L1237
	movw	r2, #1138
	ldr	r1, .L1248+64
	ldr	r0, .L1248+68
	bl	printf
.L1237:
	ldrh	r3, [r5, #2]
	adds	r4, r4, #1
	uxth	r4, r4
	cmp	r3, #1
	itttt	eq
	ldreq	r3, .L1248+60
	ldrheq	r3, [r3]
	addeq	r3, r3, #-1
	strheq	r3, [r5, #2]	@ movhi
	cmp	r4, #3
	bls	.L1234
	mov	r2, r4
	ldr	r1, [r6, #4]
	ldr	r0, .L1248+72
	bl	printf
.L1240:
	b	.L1240
.L1236:
	cmp	r3, #1
	beq	.L1234
	cmp	r2, #256
	beq	.L1234
	ldr	r2, [sp]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1241
	movs	r1, #1
	mov	r0, r2
	bl	FtlFreeSysBlkQueueIn
.L1241:
	movs	r0, #0
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1249:
	.align	2
.L1248:
	.word	.LANCHOR139
	.word	.LANCHOR114
	.word	.LANCHOR138
	.word	.LANCHOR39
	.word	1179929683
	.word	.LANCHOR10
	.word	.LANCHOR23
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR90
	.word	.LANCHOR83
	.word	.LANCHOR5
	.word	.LANCHOR42
	.word	.LANCHOR1
	.word	.LANCHOR20
	.word	.LANCHOR165
	.word	.LC1
	.word	.LC35
	.word	.LANCHOR106
	.word	1342177352
	.word	.LANCHOR82
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
	ldr	r3, .L1253
	ldr	r3, [r3]
	cmp	r3, #1
	bne	.L1252
	bl	FtlSysFlush
.L1252:
	movs	r0, #0
	pop	{r3, pc}
.L1254:
	.align	2
.L1253:
	.word	.LANCHOR166
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
	ldr	r3, .L1270
	adds	r2, r0, r1
	push	{r0, r1, r4, r5, r6, r7, r8, lr}
	mov	r7, r0
	mov	r5, r1
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L1263
	cmp	r1, #31
	bhi	.L1257
.L1262:
	movs	r0, #0
.L1255:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L1257:
	ldr	r8, .L1270+12
	ldrh	r4, [r8]
	mov	r1, r4
	bl	__aeabi_uidiv
	smulbb	r3, r0, r4
	mov	r6, r0
	subs	r7, r7, r3
	uxth	r7, r7
	cbz	r7, .L1258
	subs	r4, r4, r7
	adds	r6, r6, #1
	cmp	r4, r5
	it	cs
	movcs	r4, r5
	uxth	r4, r4
	subs	r5, r5, r4
.L1258:
	ldr	r4, .L1270+4
	mov	r3, #-1
	ldr	r7, .L1270+8
	str	r3, [sp, #4]
.L1259:
	ldrh	r3, [r8]
	cmp	r5, r3
	bcs	.L1261
	ldr	r3, .L1270+4
	ldr	r2, [r3]
	cmp	r2, #32
	bls	.L1262
	movs	r4, #0
	str	r4, [r3]
	bl	l2p_flush
	bl	FtlVpcTblFlush
	b	.L1262
.L1261:
	movs	r2, #0
	mov	r1, sp
	mov	r0, r6
	bl	log2phys
	ldr	r3, [sp]
	adds	r3, r3, #1
	beq	.L1260
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
.L1260:
	ldrh	r3, [r8]
	adds	r6, r6, #1
	subs	r5, r5, r3
	b	.L1259
.L1263:
	mov	r0, #-1
	b	.L1255
.L1271:
	.align	2
.L1270:
	.word	.LANCHOR34
	.word	.LANCHOR167
	.word	.LANCHOR86
	.word	.LANCHOR12
	.size	FtlDiscard, .-FtlDiscard
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
	ldr	r3, .L1282
	push	{r4, r5, r6, lr}
	mov	r6, r0
	ldrh	r4, [r0]
	ldrh	r3, [r3]
	cmp	r3, r4
	bcs	.L1273
	movw	r2, #2760
	ldr	r1, .L1282+4
	ldr	r0, .L1282+8
	bl	printf
.L1273:
	movw	r3, #65535
	cmp	r4, r3
	beq	.L1274
	ldr	r3, .L1282+12
	mov	r0, r4
	ldr	r3, [r3]
	ldrh	r3, [r3, r4, lsl #1]
	cbz	r3, .L1275
	bl	INSERT_DATA_LIST
.L1274:
	ldr	r5, .L1282+16
	movw	r2, #65535
	movs	r3, #1
	strb	r3, [r6, #8]
	ldrh	r0, [r5]
	cmp	r0, r2
	beq	.L1276
	cmp	r4, r0
	bne	.L1277
	ldr	r3, .L1282+12
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cbz	r3, .L1278
.L1277:
	bl	update_vpc_list
.L1278:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L1276:
	mov	r0, r6
	bl	allocate_data_superblock
	bl	l2p_flush
	movs	r0, #0
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L1275:
	bl	INSERT_FREE_LIST
	b	.L1274
.L1283:
	.align	2
.L1282:
	.word	.LANCHOR5
	.word	.LANCHOR168
	.word	.LC1
	.word	.LANCHOR42
	.word	.LANCHOR131
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
	ldr	r8, .L1298+24
	mov	r4, r3
	movs	r2, #0
	mov	r5, r0
	ldrb	r3, [r3, #9]	@ zero_extendqisi2
	mov	r10, r1
	bl	FlashProgPages
.L1285:
	cmp	r6, r10
	beq	.L1292
	ldr	r7, .L1298
	b	.L1293
.L1288:
	ldr	r0, [r5, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	ldrh	r3, [r4]
	cmp	r3, r0
	bne	.L1286
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
.L1286:
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1287
	mov	r0, r4
	bl	allocate_new_data_superblock
.L1287:
	ldr	r2, .L1298+4
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
.L1293:
	ldr	r3, [r5]
	adds	r3, r3, #1
	beq	.L1288
	ldr	r3, .L1298+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1289
	mov	r2, #960
	ldr	r1, .L1298+12
	ldr	r0, .L1298+16
	bl	printf
.L1289:
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
	beq	.L1290
	ldr	r3, [r8]
	ldrh	r2, [r3, r0, lsl #1]
	cbnz	r2, .L1291
	mov	r1, r0
	ldr	r0, .L1298+20
	bl	printf
.L1291:
	mov	r0, r7
	bl	decrement_vpc_count
.L1290:
	adds	r6, r6, #1
	adds	r5, r5, #20
	b	.L1285
.L1292:
	ldr	r3, .L1298+8
	ldrb	r2, [r4, #6]	@ zero_extendqisi2
	ldrh	r3, [r3]
	cmp	r2, r3
	bcc	.L1284
	movw	r2, #975
	ldr	r1, .L1298+12
	ldr	r0, .L1298+16
	bl	printf
.L1284:
	add	sp, sp, #8
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1299:
	.align	2
.L1298:
	.word	.LANCHOR19
	.word	.LANCHOR135
	.word	.LANCHOR3
	.word	.LANCHOR169
	.word	.LC1
	.word	.LC36
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
	movw	r3, #65535
	ldr	r0, .L1319
	ldr	r5, .L1319+4
	ldrh	r6, [r0]
	mov	r4, r0
	cmp	r6, r3
	beq	.L1301
	ldr	r3, .L1319+8
	ldrh	r1, [r3]
	bl	FtlGcScanTempBlk
	str	r0, [sp, #12]
	adds	r0, r0, #1
	beq	.L1301
	ldr	r3, .L1319+12
	ldr	r2, [r3]
	ldrh	r3, [r2, r6, lsl #1]
	cmp	r3, #4
	bls	.L1302
	subs	r3, r3, #5
	movs	r0, #1
	strh	r3, [r2, r6, lsl #1]	@ movhi
	bl	FtlEctTblFlush
.L1302:
	ldr	r3, [r5]
	cbnz	r3, .L1303
	ldr	r2, .L1319+16
	ldr	r0, [sp, #12]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
.L1303:
	movs	r0, #1
	movs	r3, #0
	str	r3, [r5]
.L1300:
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1301:
	ldrh	r2, [r4]
	movs	r3, #0
	str	r3, [r5]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1305
.L1314:
	movs	r0, #0
	b	.L1300
.L1305:
	ldr	r6, .L1319+8
	ldrb	r0, [r4, #7]	@ zero_extendqisi2
	ldr	r5, .L1319+20
	ldrh	r2, [r6]
	ldrh	r1, [r5]
	muls	r2, r0, r2
	cmp	r1, r2
	beq	.L1306
	movs	r2, #162
	ldr	r1, .L1319+24
	ldr	r0, .L1319+28
	bl	printf
.L1306:
	ldrh	r6, [r6]
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldr	r2, .L1319+32
	ldrh	r0, [r4]
	ldr	fp, .L1319+64
	smulbb	r3, r3, r6
	ldr	r1, [r2]
	movs	r6, #0
	str	r2, [sp, #4]
	strh	r3, [r1, r0, lsl #1]	@ movhi
	ldr	r1, .L1319+36
	ldrh	r3, [r5]
	ldr	r0, [r1]
	add	r3, r3, r0
	str	r3, [r1]
.L1307:
	ldrh	r2, [r5]
	uxth	r3, r6
	cmp	r2, r3
	bhi	.L1311
	movw	r0, #65535
	bl	decrement_vpc_count
	ldr	r3, [sp, #4]
	ldrh	r0, [r4]
	ldr	r3, [r3]
	ldrh	r3, [r3, r0, lsl #1]
	cmp	r3, #0
	beq	.L1312
	bl	INSERT_DATA_LIST
.L1313:
	ldr	r3, .L1319+40
	movw	r6, #65535
	strh	r6, [r4]	@ movhi
	movs	r4, #0
	strh	r4, [r5]	@ movhi
	strh	r4, [r3]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
	ldr	r3, .L1319+44
	strh	r6, [r3]	@ movhi
	ldr	r3, .L1319+48
	ldrh	r2, [r3]
	ldr	r3, .L1319+52
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	cmp	r2, r3, asr #2
	ble	.L1314
	ldr	r3, .L1319+56
	movs	r2, #20
	mov	r0, r4
	strh	r2, [r3]	@ movhi
	b	.L1300
.L1311:
	uxth	r3, r6
	movs	r7, #12
	ldr	r2, [fp]
	muls	r7, r3, r7
	ldr	r3, .L1319+60
	ldr	r8, [r3]
	add	r10, r8, r7
	ldr	r1, [r10, #8]
	cmp	r1, r2
	bcc	.L1308
	movs	r2, #168
	ldr	r1, .L1319+24
	ldr	r0, .L1319+28
	bl	printf
.L1308:
	movs	r2, #0
	add	r1, sp, #12
	ldr	r0, [r10, #8]
	bl	log2phys
	ldr	r2, [sp, #12]
	ldr	r0, [r8, r7]
	cmp	r0, r2
	bne	.L1309
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	movs	r2, #1
	mov	r7, r0
	add	r1, r10, #4
	ldr	r0, [r10, #8]
	bl	log2phys
	mov	r0, r7
.L1318:
	bl	decrement_vpc_count
.L1310:
	adds	r6, r6, #1
	b	.L1307
.L1309:
	ldr	r3, [r10, #4]
	cmp	r2, r3
	beq	.L1310
	ldrh	r0, [r4]
	b	.L1318
.L1312:
	bl	INSERT_FREE_LIST
	b	.L1313
.L1320:
	.align	2
.L1319:
	.word	.LANCHOR53
	.word	.LANCHOR133
	.word	.LANCHOR19
	.word	.LANCHOR43
	.word	.LANCHOR135
	.word	.LANCHOR70
	.word	.LANCHOR170
	.word	.LC1
	.word	.LANCHOR42
	.word	.LANCHOR84
	.word	.LANCHOR69
	.word	.LANCHOR144
	.word	.LANCHOR48
	.word	.LANCHOR171
	.word	.LANCHOR100
	.word	.LANCHOR71
	.word	.LANCHOR152
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
	ldr	r4, .L1323
	ldr	r5, .L1323+4
	ldrh	r1, [r4]
	mov	r0, r5
	bl	FtlGcScanTempBlk
	ldrh	r2, [r5, #2]
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L1321
	ldr	r0, .L1323+8
	bl	FtlMapBlkWriteDump_data
	movs	r0, #0
	bl	FtlGcFreeTempBlock
	ldr	r3, .L1323+12
	movs	r2, #0
	str	r2, [r3]
.L1321:
	pop	{r3, r4, r5, pc}
.L1324:
	.align	2
.L1323:
	.word	.LANCHOR19
	.word	.LANCHOR53
	.word	.LANCHOR129
	.word	.LANCHOR133
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
	ldr	r5, .L1326
	ldr	r3, .L1326+4
	mov	r0, r5
	str	r4, [r3]
	bl	FtlRecoverySuperblock
	mov	r0, r5
	ldr	r5, .L1326+8
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
.L1327:
	.align	2
.L1326:
	.word	.LANCHOR51
	.word	.LANCHOR157
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
	ldr	r4, .L1335
	movs	r6, #0
	movs	r7, #20
	mov	r2, r3
	ldr	r5, .L1335+4
	ldr	r1, [r4]
	ldr	r0, [r5]
	bl	FlashProgPages
.L1329:
	ldr	r1, [r4]
	uxth	r3, r6
	cmp	r1, r3
	bhi	.L1332
	ldr	r0, [r5]
	bl	FtlGcBufFree
	ldr	r3, .L1335+8
	movs	r0, #0
	str	r0, [r4]
	ldrh	r3, [r3, #4]
	cbnz	r3, .L1328
	movs	r0, #1
	bl	FtlGcFreeTempBlock
	b	.L1334
.L1332:
	muls	r3, r7, r3
	ldr	r2, [r5]
	adds	r6, r6, #1
	adds	r1, r2, r3
	ldr	r2, [r2, r3]
	adds	r3, r2, #1
	bne	.L1330
	ldr	r3, .L1335+8
	movs	r5, #0
	ldr	r0, .L1335+12
	ldrh	r4, [r3]
	ldr	r0, [r0]
	strh	r5, [r0, r4, lsl #1]	@ movhi
	strh	r2, [r3]	@ movhi
	ldr	r2, .L1335+16
	ldr	r0, [r1, #4]
	ldr	r3, [r2, #96]
	ubfx	r0, r0, #10, #16
	adds	r3, r3, #1
	str	r3, [r2, #96]
	bl	FtlBbmMapBadBlock
	bl	FtlBbmTblFlush
	bl	FtlGcPageVarInit
.L1334:
	movs	r0, #1
.L1328:
	pop	{r3, r4, r5, r6, r7, pc}
.L1330:
	ldr	r3, [r1, #12]
	ldr	r1, [r1, #4]
	ldr	r2, [r3, #8]
	ldr	r0, [r3, #12]
	bl	FtlGcUpdatePage
	b	.L1329
.L1336:
	.align	2
.L1335:
	.word	.LANCHOR62
	.word	.LANCHOR104
	.word	.LANCHOR53
	.word	.LANCHOR42
	.word	.LANCHOR135
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
	ldr	r4, .L1340
	ldrh	r2, [r4]
	cmp	r2, r3
	beq	.L1338
	ldrh	r3, [r4, #4]
	cbnz	r3, .L1339
.L1338:
	movs	r0, #0
	movs	r5, #0
	bl	FtlGcFreeTempBlock
	ldr	r0, .L1340
	strb	r5, [r4, #8]
	bl	allocate_data_superblock
	ldr	r3, .L1340+4
	strh	r5, [r3]	@ movhi
	ldr	r3, .L1340+8
	strh	r5, [r3]	@ movhi
	bl	l2p_flush
	mov	r0, r5
	bl	FtlEctTblFlush
	bl	FtlVpcTblFlush
.L1339:
	ldr	r0, .L1340
	pop	{r3, r4, r5, lr}
	b	get_new_active_ppa
.L1341:
	.align	2
.L1340:
	.word	.LANCHOR53
	.word	.LANCHOR69
	.word	.LANCHOR70
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
	ldr	r3, .L1424
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	str	r0, [sp, #20]
	ldr	r0, [r3]
	cmp	r0, #0
	bne	.L1394
	ldr	r3, .L1424+4
	ldrh	r3, [r3]
	cmp	r3, #47
	bls	.L1342
	ldr	r3, .L1424+8
	movw	r4, #65535
	ldrh	r0, [r3]
	cmp	r0, r4
	beq	.L1344
	ldr	r1, .L1424+12
	ldrh	r2, [r1]
	cmp	r2, r4
	itt	eq
	strheq	r0, [r1]	@ movhi
	strheq	r2, [r3]	@ movhi
.L1344:
	ldr	r3, [sp, #20]
	cmp	r3, #0
	bne	.L1396
	ldr	r3, .L1424+16
	ldrh	r3, [r3]
	cmp	r3, #24
	bhi	.L1397
	ldr	r2, .L1424+20
	cmp	r3, #16
	ldrh	r4, [r2]
	bls	.L1347
	lsrs	r4, r4, #5
.L1346:
	ldr	r2, .L1424+24
	ldrh	r1, [r2]
	cmp	r1, r3
	mov	r1, r2
	bcs	.L1350
	ldr	r3, .L1424+28
	movw	r0, #65535
	ldrh	r3, [r3]
	cmp	r3, r0
	bne	.L1351
	ldr	r0, .L1424+12
	ldrh	r0, [r0]
	cmp	r0, r3
	bne	.L1351
	ldr	r3, .L1424+32
	ldrh	r0, [r3]
	cbnz	r0, .L1352
	ldr	r3, .L1424+36
	ldr	r4, .L1424+40
	ldr	r3, [r3]
	ldr	r4, [r4]
	add	r3, r3, r3, lsl #1
	cmp	r4, r3, lsr #2
	bcs	.L1353
.L1352:
	ldr	r3, .L1424+44
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L1354:
	ldr	r3, .L1424+48
	movs	r2, #0
	str	r2, [r3]
.L1342:
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1347:
	cmp	r3, #12
	bls	.L1348
	lsrs	r4, r4, #4
	b	.L1346
.L1348:
	cmp	r3, #8
	bls	.L1346
	lsrs	r4, r4, #2
	b	.L1346
.L1397:
	movs	r4, #1
	b	.L1346
.L1353:
	movs	r3, #18
	strh	r3, [r2]	@ movhi
	b	.L1354
.L1351:
	ldr	r3, .L1424+44
	ldrh	r3, [r3]
	add	r3, r3, r3, lsl #1
	asrs	r3, r3, #2
	strh	r3, [r1]	@ movhi
.L1350:
	ldr	r3, .L1424+52
	ldrh	r3, [r3]
	cbz	r3, .L1345
	adds	r4, r4, #32
	uxth	r4, r4
.L1345:
	ldr	r5, .L1424+56
	movw	r3, #65535
	ldrh	r2, [r5]
	cmp	r2, r3
	bne	.L1357
	ldr	r3, .L1424+12
	ldrh	r1, [r3]
	cmp	r1, r2
	beq	.L1358
	ldr	r0, .L1424+60
	ldr	r0, [r0]
	ldrh	r1, [r0, r1, lsl #1]
	cbnz	r1, .L1359
	strh	r2, [r3]	@ movhi
.L1359:
	ldrh	r2, [r3]
	strh	r2, [r5]	@ movhi
	movw	r2, #65535
	strh	r2, [r3]	@ movhi
.L1358:
	ldrh	r0, [r5]
	movw	r6, #65535
	movs	r3, #0
	strb	r3, [r5, #8]
	cmp	r0, r6
	beq	.L1357
	bl	IsBlkInGcList
	cbz	r0, .L1361
	strh	r6, [r5]	@ movhi
.L1361:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1357
	ldr	r0, .L1424+56
	bl	make_superblock
	ldr	r2, .L1424+64
	movs	r3, #0
	strh	r3, [r5, #2]	@ movhi
	strb	r3, [r5, #6]
	strh	r3, [r2]	@ movhi
	ldr	r3, .L1424+60
	ldrh	r2, [r5]
	ldr	r3, [r3]
	ldrh	r2, [r3, r2, lsl #1]
	ldr	r3, .L1424+68
	strh	r2, [r3]	@ movhi
.L1357:
	ldr	r2, .L1424+72
	ldrh	r3, [r5]
	ldrh	r2, [r2]
	cmp	r2, r3
	beq	.L1362
	ldr	r2, .L1424+76
	ldrh	r2, [r2]
	cmp	r2, r3
	bne	.L1363
.L1362:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L1363:
	ldr	r5, .L1424+56
	mov	r6, r5
.L1393:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1364
	ldr	fp, .L1424+88
	movs	r2, #0
	ldr	r3, .L1424+48
	mov	r8, fp
	str	r2, [r3]
.L1365:
	ldrh	r7, [fp]
	mov	r0, r7
	bl	List_get_gc_head_node
	uxth	r3, r0
	movw	r1, #65535
	cmp	r3, r1
	strh	r3, [r6]	@ movhi
	bne	.L1366
	movs	r3, #0
	movs	r0, #8
	strh	r3, [fp]	@ movhi
	b	.L1342
.L1396:
	movs	r4, #1
	b	.L1345
.L1366:
	str	r0, [sp, #8]
	mov	r0, r3
	str	r3, [sp, #4]
	adds	r7, r7, #1
	bl	IsBlkInGcList
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #8]
	cbz	r0, .L1367
	strh	r7, [fp]	@ movhi
	b	.L1365
.L1367:
	uxth	r0, r2
	ldr	r2, .L1424+20
	ldr	r10, .L1424+60
	uxth	r7, r7
	ldrh	lr, [r2]
	ldr	r2, .L1424+80
	ldr	r1, [r10]
	strh	r7, [fp]	@ movhi
	ldrh	r2, [r2]
	ldrh	ip, [r1, r0, lsl #1]
	mul	r2, r2, lr
	cmp	ip, r2, asr #1
	bgt	.L1369
	cmp	r7, #48
	bls	.L1370
	cmp	ip, #8
	bls	.L1370
	ldr	r7, .L1424+84
	ldrh	r7, [r7]
	cmp	r7, #35
	bhi	.L1370
.L1369:
	movs	r7, #0
	strh	r7, [r8]	@ movhi
.L1370:
	ldrh	r1, [r1, r0, lsl #1]
	cmp	r2, r1
	bgt	.L1371
	ldrh	r2, [r8]
	cmp	r2, #3
	bhi	.L1371
	movw	r3, #65535
	strh	r3, [r6]	@ movhi
	movs	r3, #0
	strh	r3, [r8]	@ movhi
.L1423:
	ldr	r3, .L1424+32
	ldrh	r0, [r3]
	b	.L1342
.L1371:
	cbnz	r1, .L1372
	movw	r0, #65535
	bl	decrement_vpc_count
	ldrh	r3, [r8]
	adds	r3, r3, #1
	strh	r3, [r8]	@ movhi
	b	.L1365
.L1425:
	.align	2
.L1424:
	.word	.LANCHOR94
	.word	.LANCHOR45
	.word	.LANCHOR73
	.word	.LANCHOR72
	.word	.LANCHOR48
	.word	.LANCHOR19
	.word	.LANCHOR100
	.word	.LANCHOR53
	.word	.LANCHOR172
	.word	.LANCHOR152
	.word	.LANCHOR59
	.word	.LANCHOR171
	.word	.LANCHOR95
	.word	.LANCHOR74
	.word	.LANCHOR144
	.word	.LANCHOR42
	.word	.LANCHOR173
	.word	.LANCHOR174
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR3
	.word	.LANCHOR69
	.word	.LANCHOR102
.L1372:
	movs	r2, #0
	strb	r2, [r6, #8]
	ldr	r2, .L1426
	ldrh	r2, [r2]
	cmp	r2, r3
	bne	.L1373
	mov	r2, #700
	ldr	r1, .L1426+4
	ldr	r0, .L1426+8
	bl	printf
.L1373:
	ldr	r3, .L1426+12
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1374
	movw	r2, #701
	ldr	r1, .L1426+4
	ldr	r0, .L1426+8
	bl	printf
.L1374:
	ldr	r3, .L1426+16
	ldrh	r2, [r6]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1375
	movw	r2, #702
	ldr	r1, .L1426+4
	ldr	r0, .L1426+8
	bl	printf
.L1375:
	mov	r0, r5
	bl	make_superblock
	ldr	r2, .L1426+20
	movs	r3, #0
	ldrh	r1, [r6]
	strh	r3, [r2]	@ movhi
	ldr	r2, [r10]
	ldrh	r1, [r2, r1, lsl #1]
	ldr	r2, .L1426+24
	strh	r3, [r6, #2]	@ movhi
	strb	r3, [r6, #6]
	strh	r1, [r2]	@ movhi
.L1364:
	ldr	r3, .L1426+28
	movs	r2, #1
	str	r2, [r3]
	ldr	r3, .L1426+32
	ldrh	r3, [r3]
	str	r3, [sp, #12]
	ldr	r3, [sp, #20]
	cbz	r3, .L1376
	ldr	r3, .L1426+36
	ldr	r2, [sp, #12]
	ldrh	r1, [r6]
	ldrh	r3, [r3]
	muls	r3, r2, r3
	ldr	r2, .L1426+40
	ldr	r2, [r2]
	ldrh	r2, [r2, r1, lsl #1]
	subs	r3, r3, r2
	it	mi
	addmi	r3, r3, #3
	add	r4, r4, r3, asr #2
	uxth	r4, r4
.L1376:
	ldrh	r3, [r6, #2]
	ldr	r1, [sp, #12]
	ldr	fp, .L1426+64
	adds	r2, r3, r4
	cmp	r2, r1
	itt	gt
	movgt	r2, r1
	subgt	r4, r2, r3
	mov	r3, #0
	it	gt
	uxthgt	r4, r4
	str	r3, [sp, #8]
.L1379:
	ldrh	r3, [sp, #8]
	cmp	r4, r3
	bls	.L1387
	ldr	r3, .L1426+36
	movw	r10, #65535
	ldrh	r1, [r5, #2]
	mov	ip, #20
	ldr	r0, [fp]
	ldrh	lr, [r3]
	ldr	r3, [sp, #8]
	ldr	r7, .L1426+44
	adds	r3, r1, r3
	str	r3, [sp, #16]
	movs	r3, #0
	str	r3, [sp, #4]
	b	.L1388
.L1381:
	ldrh	r2, [r7, #2]!
	cmp	r2, r10
	beq	.L1380
	ldr	r1, [sp, #4]
	mla	r8, ip, r1, r0
	ldr	r1, [sp, #16]
	orr	r2, r1, r2, lsl #10
	str	r2, [r8, #4]
	ldr	r2, [sp, #4]
	adds	r2, r2, #1
	uxth	r2, r2
	str	r2, [sp, #4]
.L1380:
	adds	r3, r3, #1
.L1388:
	uxth	r2, r3
	cmp	lr, r2
	bhi	.L1381
	ldrb	r2, [r5, #8]	@ zero_extendqisi2
	ldr	r1, [sp, #4]
	bl	FlashReadPages
	movs	r3, #0
.L1422:
	str	r3, [sp, #16]
	ldr	r2, [sp, #4]
	ldrh	r3, [sp, #16]
	cmp	r2, r3
	bhi	.L1386
	ldr	r3, [sp, #8]
	adds	r3, r3, #1
	str	r3, [sp, #8]
	b	.L1379
.L1386:
	ldr	r3, [sp, #16]
	movs	r7, #20
	muls	r7, r3, r7
	ldr	r3, [fp]
	adds	r2, r3, r7
	ldr	r3, [r3, r7]
	adds	r3, r3, #1
	beq	.L1383
	ldr	r8, [r2, #12]
	movw	r3, #61589
	ldrh	r2, [r8]
	cmp	r2, r3
	bne	.L1383
	ldr	r10, [r8, #8]
	cmp	r10, #-1
	bne	.L1384
	mov	r2, #736
	ldr	r1, .L1426+4
	ldr	r0, .L1426+8
	bl	printf
.L1384:
	movs	r2, #0
	add	r1, sp, #36
	mov	r0, r10
	bl	log2phys
	ldr	r0, [fp]
	ldr	r3, [sp, #36]
	add	r0, r0, r7
	ldr	r2, [r0, #4]
	cmp	r2, r3
	bne	.L1383
	ldr	r2, .L1426+20
	ldr	r10, .L1426+56
	ldr	r1, .L1426+48
	ldrh	r3, [r2]
	str	r1, [sp, #28]
	adds	r3, r3, #1
	strh	r3, [r2]	@ movhi
	ldr	r2, [r1]
	movs	r1, #20
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
	movs	r1, #20
	ldr	r3, [r10]
	ldr	r0, [fp]
	mla	r2, r1, r3, r2
	add	r0, r0, r7
	ldr	r7, .L1426+16
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
	ldr	r2, .L1426+52
	str	r3, [r10]
	ldr	r2, [r2]
	str	r2, [r8, #4]
	bl	FtlGcBufAlloc
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldr	r3, [r10]
	cmp	r2, r3
	beq	.L1385
	ldrh	r3, [r7, #4]
	cbnz	r3, .L1383
.L1385:
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L1383
	ldr	r3, .L1426+28
	movs	r2, #0
	str	r2, [r3]
	b	.L1423
.L1383:
	ldr	r3, [sp, #16]
	adds	r3, r3, #1
	b	.L1422
.L1387:
	ldrh	r3, [r5, #2]
	add	r4, r4, r3
	ldr	r3, [sp, #12]
	uxth	r4, r4
	cmp	r3, r4
	strh	r4, [r5, #2]	@ movhi
	ldr	r4, .L1426+28
	bhi	.L1389
	ldr	r3, .L1426+56
	ldr	r3, [r3]
	cbz	r3, .L1390
	bl	Ftl_gc_temp_data_write_back
	cbz	r0, .L1390
	movs	r3, #0
	str	r3, [r4]
	b	.L1423
.L1390:
	ldr	r3, .L1426+20
	ldrh	r1, [r3]
	cbnz	r1, .L1391
	ldr	r3, .L1426+40
	ldrh	r2, [r5]
	ldr	r3, [r3]
	ldrh	r0, [r3, r2, lsl #1]
	cbz	r0, .L1391
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldrh	r0, [r5]
	bl	update_vpc_list
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1391:
	movw	r3, #65535
	strh	r3, [r5]	@ movhi
.L1389:
	movs	r3, #0
	str	r3, [r4]
	ldr	r3, .L1426+60
	ldrh	r0, [r3]
	cmp	r0, #2
	bhi	.L1392
	ldr	r3, .L1426+32
	ldrh	r4, [r3]
	b	.L1393
.L1392:
	adds	r0, r0, #1
	b	.L1342
.L1394:
	movs	r0, #0
	b	.L1342
.L1427:
	.align	2
.L1426:
	.word	.LANCHOR51
	.word	.LANCHOR175
	.word	.LC1
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR173
	.word	.LANCHOR174
	.word	.LANCHOR94
	.word	.LANCHOR19
	.word	.LANCHOR3
	.word	.LANCHOR42
	.word	.LANCHOR144+14
	.word	.LANCHOR104
	.word	.LANCHOR83
	.word	.LANCHOR62
	.word	.LANCHOR48
	.word	.LANCHOR66
	.size	rk_ftl_garbage_collect, .-rk_ftl_garbage_collect
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
	bne	.L1429
	mov	r2, r3
	ldr	r1, [sp, #24]
	add	r0, r6, #256
	bl	FtlVendorPartRead
	str	r0, [sp, #4]
.L1428:
	ldr	r0, [sp, #4]
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1429:
	ldr	r3, [sp, #24]
	adds	r3, r1, r3
	str	r3, [sp, #12]
	ldr	r3, .L1461
	ldr	r2, [sp, #12]
	ldr	r3, [r3]
	cmp	r2, r3
	bhi	.L1450
	ldr	r3, .L1461+4
	ldr	r3, [r3]
	adds	r4, r3, #1
	beq	.L1451
	ldr	r3, .L1461+8
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
	ldr	r2, .L1461+12
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
	ldr	r2, .L1461+16
	str	r7, [sp, #4]
	ldr	r3, [r2]
	add	r3, r3, r1
	str	r3, [r2]
.L1431:
	ldr	r3, [sp, #8]
	cbnz	r3, .L1448
	ldr	r3, .L1461+20
	ldrh	r3, [r3]
	cbnz	r3, .L1449
	ldr	r3, .L1461+24
	ldrh	r3, [r3]
	cmp	r3, #31
	bhi	.L1428
.L1449:
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	b	.L1428
.L1448:
	movs	r2, #0
	add	r1, sp, #52
	mov	r0, r4
	bl	log2phys
	ldr	r3, [sp, #52]
	adds	r0, r3, #1
	bne	.L1432
	ldr	fp, .L1461+8
	mov	r10, #0
.L1433:
	ldrh	r0, [fp]
	cmp	r10, r0
	bcc	.L1435
.L1436:
	ldr	r3, [sp, #8]
	adds	r4, r4, #1
	subs	r3, r3, #1
	str	r3, [sp, #8]
	beq	.L1440
	ldr	r3, .L1461+28
	ldrh	r3, [r3]
	cmp	r5, r3, lsl #2
	bne	.L1431
.L1440:
	cmp	r5, #0
	beq	.L1431
	ldr	r3, .L1461+32
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
.L1447:
	movs	r3, #20
	mul	fp, r3, r10
	ldr	r3, .L1461+32
	ldr	r2, [r3]
	ldr	r3, [sp, #16]
	add	r2, r2, fp
	ldr	r1, [r2, #16]
	cmp	r3, r1
	bne	.L1442
	ldr	r1, [r2, #8]
	ldr	r2, .L1461+36
	ldr	r2, [r2]
	cmp	r1, r2
	bne	.L1443
	ldr	r3, [sp, #36]
	mov	r0, r8
	ldr	r2, [sp, #40]
	add	r1, r1, r3
.L1460:
	bl	ftl_memcpy
.L1443:
	ldr	r3, .L1461+32
	ldr	r3, [r3]
	add	r2, r3, fp
	ldr	r3, [r3, fp]
	ldr	r0, [r2, #12]
	ldr	r1, [r2, #16]
	ldr	r0, [r0, #8]
	cmp	r1, r0
	itttt	ne
	ldrne	r0, .L1461+40
	ldrne	r1, [r0, #72]
	addne	r1, r1, #1
	strne	r1, [r0, #72]
	adds	r1, r3, #1
	bne	.L1445
	ldr	r1, .L1461+40
	str	r3, [sp, #4]
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L1446:
	add	r10, r10, #1
	cmp	r5, r10
	bne	.L1447
	movs	r5, #0
	b	.L1431
.L1435:
	mla	r0, r0, r4, r10
	cmp	r6, r0
	bhi	.L1434
	ldr	r3, [sp, #12]
	cmp	r3, r0
	bls	.L1434
	subs	r0, r0, r6
	mov	r2, #512
	movs	r1, #0
	add	r0, r8, r0, lsl #9
	bl	ftl_memset
.L1434:
	add	r10, r10, #1
	b	.L1433
.L1432:
	ldr	r2, .L1461+32
	mov	r10, #20
	ldr	r2, [r2]
	mla	r10, r10, r5, r2
	str	r3, [r10, #4]
	ldr	r3, [sp, #16]
	cmp	r4, r3
	ldr	r3, .L1461+8
	bne	.L1437
	ldr	r2, .L1461+36
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
	bne	.L1438
	str	r8, [r10, #8]
.L1438:
	ldr	r3, .L1461+44
	ldr	r2, .L1461+48
	str	r4, [r10, #16]
	ldrh	r3, [r3]
	ldr	r2, [r2]
	muls	r3, r5, r3
	adds	r5, r5, #1
	bic	r3, r3, #3
	add	r3, r3, r2
	str	r3, [r10, #12]
	b	.L1436
.L1437:
	ldr	r2, [sp, #20]
	cmp	r4, r2
	bne	.L1439
	ldr	r2, .L1461+52
	ldr	r1, [sp, #12]
	ldr	r2, [r2]
	str	r2, [r10, #8]
	ldrh	r2, [r3]
	mul	r3, r2, r4
	subs	r7, r1, r3
	cmp	r2, r7
	bne	.L1438
.L1459:
	subs	r3, r3, r6
	add	r3, r8, r3, lsl #9
	str	r3, [r10, #8]
	b	.L1438
.L1439:
	ldrh	r3, [r3]
	muls	r3, r4, r3
	b	.L1459
.L1442:
	ldr	r3, [sp, #20]
	cmp	r3, r1
	bne	.L1443
	ldr	r3, .L1461+52
	ldr	r1, [r2, #8]
	ldr	r2, [r3]
	cmp	r1, r2
	bne	.L1443
	ldr	r2, .L1461+8
	ldr	r3, [sp, #20]
	ldrh	r0, [r2]
	ldr	r2, [sp, #44]
	muls	r0, r3, r0
	subs	r0, r0, r6
	add	r0, r8, r0, lsl #9
	b	.L1460
.L1445:
	cmp	r3, #256
	bne	.L1446
	ldr	r0, [r2, #4]
	ubfx	r0, r0, #10, #16
	bl	P2V_block_in_plane
	bl	FtlGcRefreshBlock
	b	.L1446
.L1450:
	mov	r3, #-1
.L1451:
	str	r3, [sp, #4]
	b	.L1428
.L1462:
	.align	2
.L1461:
	.word	.LANCHOR34
	.word	.LANCHOR166
	.word	.LANCHOR12
	.word	.LANCHOR163
	.word	.LANCHOR89
	.word	.LANCHOR74
	.word	.LANCHOR48
	.word	.LANCHOR3
	.word	.LANCHOR103
	.word	.LANCHOR109
	.word	.LANCHOR135
	.word	.LANCHOR24
	.word	.LANCHOR115
	.word	.LANCHOR110
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
	bne	.L1465
	mov	r2, r3
	ldr	r3, [sp, #4]
	ldr	r1, [sp, #20]
	add	r0, r3, #256
	bl	FtlVendorPartWrite
.L1464:
	add	sp, sp, #72
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1465:
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #20]
	adds	r4, r3, r2
	ldr	r3, .L1508
	ldr	r3, [r3]
	cmp	r4, r3
	bhi	.L1498
	ldr	r3, .L1508+4
	ldr	r0, [r3]
	adds	r5, r0, #1
	beq	.L1464
	ldr	r3, .L1508+8
	mov	r2, #2048
	ldr	r0, [sp, #4]
	ldr	r7, .L1508+12
	str	r2, [r3]
	ldr	r3, .L1508+16
	ldrh	r5, [r3]
	mov	r1, r5
	bl	__aeabi_uidiv
	mov	r1, r5
	str	r0, [sp, #12]
	subs	r0, r4, #1
	bl	__aeabi_uidiv
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #20]
	ldr	r5, [sp, #12]
	subs	r3, r0, r2
	ldr	r2, .L1508+20
	str	r3, [sp, #32]
	adds	r3, r3, #1
	str	r3, [sp, #8]
	ldr	r3, [r2]
	str	r0, [sp, #28]
	add	r3, r3, r1
	ldr	r1, [sp, #8]
	str	r3, [r2]
	ldr	r2, .L1508+24
	ldr	r3, [r2]
	add	r3, r3, r1
	str	r3, [r2]
.L1467:
	ldr	r3, [sp, #8]
	cbnz	r3, .L1493
	ldr	r5, .L1508+28
	mov	r0, r3
	ldr	r1, [sp, #32]
	bl	rk_ftl_garbage_collect
	ldrh	r2, [r5]
	cmp	r2, #5
	bls	.L1494
.L1496:
	movs	r0, #0
	b	.L1464
.L1493:
	ldr	r4, .L1508+32
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L1468
	mov	r2, #1016
	ldr	r1, .L1508+36
	ldr	r0, .L1508+40
	bl	printf
.L1468:
	ldrh	r3, [r7, #4]
	cbnz	r3, .L1469
	mov	r0, r7
	bl	allocate_new_data_superblock
.L1469:
	ldrb	r3, [r7, #7]	@ zero_extendqisi2
	ldrh	r2, [r7, #4]
	lsls	r3, r3, #2
	cmp	r3, r2
	it	cs
	movcs	r3, r2
	ldr	r2, [sp, #8]
	cmp	r3, r2
	it	cs
	movcs	r3, r2
	ldrb	r2, [r7, #6]	@ zero_extendqisi2
	str	r3, [sp, #44]
	ldrh	r3, [r4]
	cmp	r2, r3
	bcc	.L1470
	movw	r2, #1049
	ldr	r1, .L1508+36
	ldr	r0, .L1508+40
	bl	printf
.L1470:
	ldr	r8, .L1508+44
	mov	fp, #0
.L1471:
	ldr	r3, [sp, #44]
	cmp	fp, r3
	bne	.L1491
.L1472:
	ldr	r0, .L1508+44
	mov	r3, r7
	movs	r2, #0
	mov	r1, fp
	ldr	r0, [r0]
	bl	FtlProgPages
	ldr	r3, [sp, #8]
	cmp	fp, r3
	bls	.L1492
	movw	r2, #1126
	ldr	r1, .L1508+36
	ldr	r0, .L1508+40
	bl	printf
.L1492:
	ldr	r3, [sp, #8]
	sub	r3, r3, fp
	str	r3, [sp, #8]
	b	.L1467
.L1491:
	ldrh	r2, [r7, #4]
	cmp	r2, #0
	beq	.L1472
	movs	r2, #0
	add	r1, sp, #48
	mov	r0, r5
	movs	r6, #20
	bl	log2phys
	mov	r0, r7
	mul	r6, r6, fp
	bl	get_new_active_ppa
	ldr	r2, .L1508+48
	ldr	r1, [r8]
	ldrh	r2, [r2]
	add	r1, r1, r6
	str	r0, [r1, #4]
	str	r5, [r1, #16]
	mul	r0, r2, fp
	bic	r3, r0, #3
	ldr	r0, .L1508+52
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
	ldr	r2, .L1508+16
	cmp	r5, r3
	beq	.L1473
	ldr	r3, [sp, #28]
	cmp	r5, r3
	bne	.L1504
	ldrh	r2, [r2]
	ldr	r3, [sp, #4]
	ldr	r1, [sp, #20]
	smulbb	r2, r2, r5
	adds	r4, r3, r1
	movs	r3, #0
	subs	r4, r4, r2
	str	r3, [sp, #24]
	uxth	r4, r4
	b	.L1476
.L1473:
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
.L1476:
	ldr	r2, .L1508+16
	ldr	r3, [sp, #12]
	ldrh	r2, [r2]
	cmp	r4, r2
	ldr	r2, [r8]
	bne	.L1477
	cmp	r5, r3
	add	r6, r6, r2
	ittet	ne
	mulne	r4, r4, r5
	ldrne	r3, [sp, #4]
	ldreq	r3, [sp, #16]
	subne	r4, r4, r3
	itett	ne
	ldrne	r3, [sp, #16]
	streq	r3, [r6, #8]
	addne	r4, r3, r4, lsl #9
	strne	r4, [r6, #8]
.L1479:
	ldr	r2, .L1508+32
	ldrb	r1, [r7, #6]	@ zero_extendqisi2
	ldrh	r2, [r2]
	cmp	r1, r2
	bcc	.L1488
	movw	r2, #1117
	ldr	r1, .L1508+36
	ldr	r0, .L1508+40
	bl	printf
.L1488:
	ldr	r3, [sp, #40]
	movw	r2, #61589
	ldr	r1, [sp, #36]
	add	fp, fp, #1
	strh	r2, [r3, r1]	@ movhi
	ldr	r1, .L1508+56
	str	r5, [r10, #8]
	adds	r5, r5, #1
	ldr	r2, [r1]
	str	r2, [r10, #4]
	adds	r2, r2, #1
	adds	r3, r2, #1
	it	eq
	moveq	r2, #0
	str	r2, [r1]
	ldr	r2, [sp, #48]
	str	r2, [r10, #12]
	ldrh	r2, [r7]
	strh	r2, [r10, #2]	@ movhi
	b	.L1471
.L1477:
	cmp	r5, r3
	add	r2, r2, r6
	ite	eq
	ldreq	r1, .L1508+60
	ldrne	r1, .L1508+64
	ldr	r1, [r1]
	str	r1, [r2, #8]
	ldr	r2, [sp, #48]
	adds	r1, r2, #1
	beq	.L1482
	str	r2, [sp, #56]
	add	r0, sp, #52
	ldr	r2, [r8]
	str	r5, [sp, #68]
	add	r2, r2, r6
	ldr	r1, [r2, #8]
	ldr	r2, [r2, #12]
	str	r1, [sp, #60]
	movs	r1, #1
	str	r2, [sp, #64]
	movs	r2, #0
	bl	FlashReadPages
	ldr	r2, [sp, #52]
	adds	r2, r2, #1
	bne	.L1483
	ldr	r1, .L1508+68
	ldr	r2, [r1, #72]
	adds	r2, r2, #1
	str	r2, [r1, #72]
.L1486:
	ldr	r3, [sp, #12]
	lsls	r2, r4, #9
	cmp	r5, r3
	bne	.L1487
	ldr	r1, [r8]
	ldr	r3, [sp, #24]
	add	r6, r6, r1
	ldr	r1, [sp, #16]
	ldr	r0, [r6, #8]
	add	r0, r0, r3, lsl #9
.L1506:
	bl	ftl_memcpy
	b	.L1479
.L1483:
	ldr	r1, [r10, #8]
	cmp	r5, r1
	beq	.L1485
	ldr	r0, .L1508+68
	ldr	r2, [r0, #72]
	adds	r2, r2, #1
	str	r2, [r0, #72]
	mov	r2, r5
	ldr	r0, .L1508+72
	bl	printf
.L1485:
	ldr	r2, [r10, #8]
	cmp	r5, r2
	beq	.L1486
	movw	r2, #1102
	ldr	r1, .L1508+36
	ldr	r0, .L1508+40
	bl	printf
	b	.L1486
.L1482:
	ldr	r2, [r8]
	movs	r1, #0
	adds	r0, r2, r6
	ldr	r2, .L1508+76
	ldr	r0, [r0, #8]
	ldrh	r2, [r2]
	bl	ftl_memset
	b	.L1486
.L1487:
	ldr	r1, .L1508+16
	ldr	r3, [sp, #4]
	ldr	r0, [r8]
	ldrh	r1, [r1]
	add	r6, r6, r0
	ldr	r0, [r6, #8]
	muls	r1, r5, r1
	subs	r1, r1, r3
	ldr	r3, [sp, #16]
	add	r1, r3, r1, lsl #9
	b	.L1506
.L1509:
	.align	2
.L1508:
	.word	.LANCHOR34
	.word	.LANCHOR166
	.word	.LANCHOR176
	.word	.LANCHOR51
	.word	.LANCHOR12
	.word	.LANCHOR162
	.word	.LANCHOR85
	.word	.LANCHOR48
	.word	.LANCHOR3
	.word	.LANCHOR177
	.word	.LC1
	.word	.LANCHOR105
	.word	.LANCHOR24
	.word	.LANCHOR115
	.word	.LANCHOR83
	.word	.LANCHOR109
	.word	.LANCHOR110
	.word	.LANCHOR135
	.word	.LC37
	.word	.LANCHOR23
.L1504:
	ldrh	r2, [r2]
	ldr	r3, [sp, #4]
	ldr	r1, [r8]
	muls	r2, r5, r2
	add	r6, r6, r1
	subs	r2, r2, r3
	ldr	r3, [sp, #16]
	add	r2, r3, r2, lsl #9
	str	r2, [r6, #8]
	b	.L1479
.L1494:
	ldr	r6, .L1510
	mov	r4, #256
	ldr	r7, .L1510+4
.L1497:
	ldrh	r3, [r6]
	movw	r2, #65535
	cmp	r3, r2
	bne	.L1495
	ldrh	r2, [r7]
	cmp	r2, r3
	bne	.L1495
	movs	r0, #0
	bl	List_get_gc_head_node
	uxth	r0, r0
	bl	FtlGcRefreshBlock
.L1495:
	ldr	r2, .L1510+8
	movs	r3, #128
	movs	r1, #1
	mov	r0, r1
	strh	r3, [r2]	@ movhi
	ldr	r2, .L1510+12
	strh	r3, [r2]	@ movhi
	bl	rk_ftl_garbage_collect
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	ldrh	r3, [r5]
	cmp	r3, #2
	bhi	.L1496
	subs	r4, r4, #1
	bne	.L1497
	b	.L1496
.L1498:
	mov	r0, #-1
	b	.L1464
.L1511:
	.align	2
.L1510:
	.word	.LANCHOR144
	.word	.LANCHOR72
	.word	.LANCHOR101
	.word	.LANCHOR100
	.size	FtlWrite, .-FtlWrite
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
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	movs	r1, #0
	ldr	r8, .L1540+144
	sub	sp, sp, #24
	ldr	r7, .L1540
	ldr	r3, [r8]
	ldr	r4, .L1540+4
	ldr	fp, .L1540+148
	ldrh	r2, [r7]
	ldr	r5, .L1540+8
	str	r3, [r4, #8]
	ldr	r6, .L1540+12
	ldr	r3, [fp]
	lsls	r2, r2, #1
	ldr	r0, [r5]
	str	r3, [r4, #12]
	bl	ftl_memset
	ldrh	r0, [r6]
	movw	r3, #65535
	str	r5, [sp, #16]
	cmp	r0, r3
	bne	.L1514
.L1525:
	mov	r0, #-1
.L1513:
	add	sp, sp, #24
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1514:
	movs	r1, #1
	bl	FtlGetLastWrittenPage
	ldrsh	r10, [r6]
	sxth	r5, r0
	adds	r0, r0, #1
	strh	r0, [r6, #2]	@ movhi
.L1516:
	cmp	r5, #0
	bge	.L1522
	movw	r2, #1465
	ldr	r1, .L1540+16
	ldr	r0, .L1540+20
	bl	printf
	b	.L1521
.L1522:
	orr	r3, r5, r10, lsl #10
	movs	r2, #1
	mov	r1, r2
	ldr	r0, .L1540+4
	str	r3, [r4, #4]
	ldr	r3, [r8]
	str	r3, [r4, #8]
	bl	FlashReadPages
	ldr	r3, [r4, #12]
	ldr	r3, [r3, #12]
	str	r3, [sp, #20]
	cbz	r3, .L1517
	ldr	r2, .L1540+24
	ldr	r0, [r4, #8]
	ldrh	r1, [r2]
	bl	js_hash
	ldr	r3, [sp, #20]
	cmp	r3, r0
	beq	.L1517
	str	r0, [sp, #8]
	mov	r2, r10
	str	r3, [sp, #4]
	ldrh	r3, [r6, #4]
	ldr	r1, .L1540+16
	ldr	r0, .L1540+28
	str	r3, [sp]
	mov	r3, r5
	bl	printf
	cbnz	r5, .L1518
	ldrh	r3, [r6, #4]
	cmp	r10, r3
	beq	.L1518
	sxth	r10, r3
	ldr	r3, .L1540+32
	ldrh	r5, [r3]
.L1520:
	subs	r5, r5, #1
	sxth	r5, r5
	b	.L1516
.L1518:
	mov	r3, #-1
	str	r3, [r4]
.L1517:
	ldr	r3, [r4]
	adds	r3, r3, #1
	beq	.L1520
	ldr	r3, [r8]
	ldr	r2, .L1540+36
	ldr	r3, [r3]
	cmp	r3, r2
	bne	.L1520
	ldr	r3, [fp]
	ldrh	r2, [r3]
	movw	r3, #61604
	cmp	r2, r3
	bne	.L1520
.L1521:
	ldr	r2, .L1540+24
	ldrh	r3, [r7]
	ldrh	r2, [r2]
	adds	r3, r3, #24
	cmp	r2, r3, lsl #1
	bcs	.L1524
	movw	r2, #1467
	ldr	r1, .L1540+16
	ldr	r0, .L1540+20
	bl	printf
.L1524:
	ldr	r5, .L1540+40
	movs	r2, #48
	ldr	r1, [r4, #8]
	mov	r0, r5
	bl	ftl_memcpy
	ldrh	r2, [r7]
	ldr	r1, [r4, #8]
	ldr	r3, [sp, #16]
	lsls	r2, r2, #1
	adds	r1, r1, #48
	ldr	r0, [r3]
	bl	ftl_memcpy
	ldrh	r1, [r7]
	ldr	r3, [r4, #8]
	mov	r4, r5
	lsrs	r2, r1, #3
	adds	r1, r1, #24
	lsls	r1, r1, #1
	adds	r2, r2, #4
	bic	r1, r1, #3
	add	r1, r1, r3
	ldr	r3, .L1540+44
	ldr	r0, [r3]
	bl	ftl_memcpy
	ldr	r2, [r5]
	ldr	r3, .L1540+36
	cmp	r2, r3
	bne	.L1525
	ldr	r3, .L1540+48
	ldrb	r2, [r4, #10]	@ zero_extendqisi2
	ldrh	r5, [r5, #8]
	ldrh	r3, [r3]
	strh	r5, [r6, #6]	@ movhi
	cmp	r2, r3
	bne	.L1525
	ldr	r3, .L1540+52
	ldr	r2, .L1540+56
	str	r5, [r3]
	ldr	r3, .L1540+60
	ldrh	r3, [r3]
	muls	r3, r5, r3
	str	r3, [r2]
	ldr	r2, .L1540+64
	ldrh	r2, [r2]
	muls	r3, r2, r3
	ldr	r2, .L1540+68
	str	r3, [r2]
	ldr	r3, .L1540+72
	ldr	r6, [r3]
	ldr	r3, .L1540+76
	ldrh	r0, [r3, #6]
	ldr	r3, .L1540+80
	subs	r0, r6, r0
	ldrh	r1, [r3]
	subs	r0, r0, r5
	bl	__aeabi_uidiv
	ldr	r3, .L1540+84
	cmp	r5, r6
	strh	r0, [r3]	@ movhi
	bls	.L1526
	movw	r2, #1489
	ldr	r1, .L1540+16
	ldr	r0, .L1540+20
	bl	printf
.L1526:
	ldrh	r2, [r4, #16]
	ldr	r3, .L1540+88
	ldrh	ip, [r4, #14]
	ldr	r7, .L1540+92
	lsrs	r1, r2, #6
	and	r2, r2, #63
	strb	r2, [r3, #6]
	ldrb	r2, [r4, #11]	@ zero_extendqisi2
	strh	r1, [r3, #2]	@ movhi
	ldr	r1, .L1540+96
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
	ldr	r2, .L1540+100
	strh	r5, [r2]	@ movhi
	ldrh	r5, [r4, #24]
	lsrs	r6, r5, #6
	and	r5, r5, #63
	strb	r5, [r2, #6]
	ldrb	r5, [r4, #13]	@ zero_extendqisi2
	strh	r6, [r2, #2]	@ movhi
	ldr	r6, [r4, #32]
	strb	r5, [r2, #8]
	ldr	r5, .L1540+104
	str	r3, [r5]
	ldr	r5, .L1540+108
	str	r3, [r5]
	ldr	r5, .L1540+112
	str	r3, [r5]
	ldr	r5, .L1540+116
	str	r3, [r5]
	ldr	r5, .L1540+120
	str	r6, [r5]
	mov	r6, r1
	ldr	r5, .L1540+124
	str	r3, [r5]
	ldr	r5, .L1540+128
	str	r3, [r5]
	ldr	r5, .L1540+132
	ldr	lr, [r4, #40]
	str	r3, [r5]
	ldr	r3, .L1540+136
	ldr	r5, [r3]
	cmp	lr, r5
	mov	r5, r2
	it	hi
	strhi	lr, [r3]
	ldr	r3, .L1540+140
	ldr	r2, [r4, #36]
	ldr	r1, [r3]
	cmp	r2, r1
	it	hi
	strhi	r2, [r3]
	movw	r3, #65535
	cmp	ip, r3
	beq	.L1529
	ldr	r0, .L1540+88
	bl	make_superblock
.L1529:
	ldrh	r2, [r6]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1530
	ldr	r0, .L1540+96
	bl	make_superblock
.L1530:
	ldrh	r2, [r5]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1531
	ldr	r0, .L1540+100
	bl	make_superblock
.L1531:
	ldrh	r2, [r7]
	movw	r3, #65535
	cmp	r2, r3
	beq	.L1532
	ldr	r0, .L1540+92
	bl	make_superblock
.L1532:
	movs	r0, #0
	b	.L1513
.L1541:
	.align	2
.L1540:
	.word	.LANCHOR5
	.word	.LANCHOR138
	.word	.LANCHOR42
	.word	.LANCHOR139
	.word	.LANCHOR178
	.word	.LC1
	.word	.LANCHOR23
	.word	.LC38
	.word	.LANCHOR20
	.word	1179929683
	.word	.LANCHOR39
	.word	.LANCHOR1
	.word	.LANCHOR10
	.word	.LANCHOR179
	.word	.LANCHOR152
	.word	.LANCHOR19
	.word	.LANCHOR12
	.word	.LANCHOR34
	.word	.LANCHOR7
	.word	.LANCHOR37
	.word	.LANCHOR3
	.word	.LANCHOR171
	.word	.LANCHOR51
	.word	.LANCHOR144
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR84
	.word	.LANCHOR85
	.word	.LANCHOR89
	.word	.LANCHOR88
	.word	.LANCHOR90
	.word	.LANCHOR91
	.word	.LANCHOR92
	.word	.LANCHOR87
	.word	.LANCHOR82
	.word	.LANCHOR83
	.word	.LANCHOR106
	.word	.LANCHOR114
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
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r3, [r0, #24]
	movs	r1, #0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	sub	sp, sp, #40
	mov	r4, r0
	ldr	r8, [r0, #12]
	movs	r7, #0
	str	r3, [sp, #8]
	ldr	r3, [r0, #16]
	ldr	r6, .L1577
	str	r3, [sp, #24]
	ldrh	r3, [r0, #6]
	str	r3, [sp, #12]
	ldrh	r3, [r0, #8]
	ldr	r0, [sp, #8]
	str	r3, [sp, #16]
	ldr	r3, [sp, #12]
	lsls	r2, r3, #2
	bl	ftl_memset
	ldr	r3, .L1577+4
	str	r7, [r4, #32]
	str	r7, [r4, #28]
	ldr	r2, [r3]
	str	r3, [sp, #20]
	str	r2, [r6, #8]
	ldr	r2, .L1577+8
	ldr	fp, [r2]
	movw	r2, #65535
	str	fp, [r6, #12]
	strh	r2, [r4]	@ movhi
	strh	r2, [r4, #2]	@ movhi
	movs	r2, #1
	str	r2, [r4, #36]
.L1543:
	ldr	r3, [sp, #16]
	sxth	r5, r7
	cmp	r5, r3
	bge	.L1562
	ldr	r3, [sp, #16]
	subs	r3, r3, #1
	cmp	r5, r3
	bne	.L1544
	movs	r1, #1
	ldrh	r0, [r8, r5, lsl #1]
	bl	FtlGetLastWrittenPage
	sxth	r3, r0
	ldr	r6, .L1577
	add	r10, r8, r5, lsl #1
	strh	r7, [r4]	@ movhi
	str	r3, [sp, #16]
	movs	r7, #0
	ldr	r3, [sp, #24]
	adds	r0, r0, #1
	strh	r0, [r4, #2]	@ movhi
	ldr	r3, [r3, r5, lsl #2]
	str	r3, [r4, #28]
.L1545:
	ldr	r3, [sp, #16]
	sxth	r8, r7
	cmp	r8, r3
	ble	.L1548
.L1562:
	mov	r0, r4
	bl	ftl_free_no_use_map_blk
	ldr	r3, .L1577+12
	ldrh	r2, [r4, #2]
	ldrh	r3, [r3]
	cmp	r2, r3
	bne	.L1550
	mov	r0, r4
	bl	ftl_map_blk_alloc_new_blk
.L1550:
	mov	r0, r4
	bl	ftl_map_blk_gc
	mov	r0, r4
	bl	ftl_map_blk_gc
	movs	r0, #0
	add	sp, sp, #40
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1548:
	ldrh	r2, [r10]
	ldr	r0, .L1577
	orr	r2, r8, r2, lsl #10
	str	r2, [r6, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [r6, #12]
	ldr	r2, [r2, #12]
	str	r2, [sp, #20]
	cbz	r2, .L1546
	ldr	r3, .L1577+16
	ldr	r0, [r6, #8]
	ldrh	r1, [r3]
	bl	js_hash
	ldr	r2, [sp, #20]
	cmp	r2, r0
	beq	.L1546
	str	r0, [sp, #4]
	mov	r3, r8
	str	r2, [sp]
	mov	r2, r5
	ldr	r1, .L1577+20
	ldr	r0, .L1577+24
	bl	printf
	mov	r3, #-1
	str	r3, [r6]
.L1546:
	ldr	r3, [r6]
	adds	r3, r3, #1
	beq	.L1547
	ldrh	r3, [fp, #8]
	ldr	r2, [sp, #12]
	cmp	r2, r3
	bls	.L1547
	ldrh	r1, [fp]
	ldrh	r2, [r4, #4]
	cmp	r1, r2
	ittt	eq
	ldreq	r2, [r6, #4]
	ldreq	r1, [sp, #8]
	streq	r2, [r1, r3, lsl #2]
.L1547:
	adds	r7, r7, #1
	b	.L1545
.L1544:
	ldr	r3, [sp, #20]
	ldr	r10, .L1577+12
	ldrh	r2, [r8, r5, lsl #1]
	ldr	r3, [r3]
	ldr	r0, .L1577
	str	r3, [r6, #8]
	add	r3, r8, r5, lsl #1
	str	r3, [sp, #28]
	ldrh	r3, [r10]
	subs	r3, r3, #1
	orr	r3, r3, r2, lsl #10
	movs	r2, #1
	mov	r1, r2
	str	r3, [r6, #4]
	bl	FlashReadPages
	ldr	r3, [r6]
	adds	r3, r3, #1
	beq	.L1564
	ldrh	r2, [fp]
	ldrh	r3, [r4, #4]
	cmp	r2, r3
	bne	.L1564
	ldrh	r2, [fp, #8]
	movw	r3, #64245
	cmp	r2, r3
	beq	.L1552
.L1564:
	mov	r10, #0
.L1553:
	ldr	r2, .L1577+12
	sxth	r3, r10
	ldrh	r2, [r2]
	cmp	r3, r2
	bge	.L1560
	ldr	r2, [sp, #28]
	ldr	r0, .L1577
	str	r3, [sp, #36]
	ldrh	r2, [r2]
	orr	r2, r3, r2, lsl #10
	str	r2, [r6, #4]
	movs	r2, #1
	mov	r1, r2
	bl	FlashReadPages
	ldr	r2, [r6, #12]
	ldr	r2, [r2, #12]
	str	r2, [sp, #32]
	cbz	r2, .L1557
	ldr	r1, .L1577+16
	ldr	r0, [r6, #8]
	ldrh	r1, [r1]
	bl	js_hash
	ldr	r2, [sp, #32]
	cmp	r2, r0
	beq	.L1557
	str	r0, [sp, #4]
	str	r2, [sp]
	mov	r2, r5
	ldr	r3, [sp, #36]
	ldr	r1, .L1577+20
	ldr	r0, .L1577+28
	bl	printf
	mov	r3, #-1
	str	r3, [r6]
.L1557:
	ldr	r3, [r6]
	adds	r3, r3, #1
	beq	.L1558
	ldrh	r3, [fp, #8]
	ldr	r2, [sp, #12]
	cmp	r2, r3
	bls	.L1558
	ldrh	r1, [fp]
	ldrh	r2, [r4, #4]
	cmp	r1, r2
	ittt	eq
	ldreq	r2, [r6, #4]
	ldreq	r1, [sp, #8]
	streq	r2, [r1, r3, lsl #2]
.L1558:
	add	r10, r10, #1
	b	.L1553
.L1552:
	ldr	r3, [sp, #20]
	movs	r1, #0
	ldrh	r2, [r10]
	ldr	r0, [r3]
	add	lr, r2, #-1
.L1554:
	sxth	r3, r1
	cmp	r3, lr
	blt	.L1556
.L1560:
	adds	r7, r7, #1
	b	.L1543
.L1556:
	lsls	r5, r3, #3
	ldr	r3, [r0, r3, lsl #3]
	ldr	r2, [sp, #12]
	uxth	ip, r3
	cmp	r2, ip
	bls	.L1555
	add	r5, r5, r0
	ldr	r2, [sp, #8]
	ldr	r5, [r5, #4]
	str	r5, [r2, ip, lsl #2]
.L1555:
	adds	r1, r1, #1
	b	.L1554
.L1578:
	.align	2
.L1577:
	.word	.LANCHOR138
	.word	.LANCHOR106
	.word	.LANCHOR114
	.word	.LANCHOR20
	.word	.LANCHOR23
	.word	.LANCHOR180
	.word	.LC39
	.word	.LC40
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
	ldr	r3, .L1580
	ldr	r0, .L1580+4
	ldrh	r3, [r3]
	strh	r3, [r0, #10]	@ movhi
	movw	r3, #61574
	strh	r3, [r0, #4]	@ movhi
	ldr	r3, .L1580+8
	ldrh	r3, [r3]
	strh	r3, [r0, #8]	@ movhi
	ldr	r3, .L1580+12
	ldrh	r3, [r3]
	strh	r3, [r0, #6]	@ movhi
	ldr	r3, .L1580+16
	ldr	r3, [r3]
	str	r3, [r0, #12]
	ldr	r3, .L1580+20
	ldr	r3, [r3]
	str	r3, [r0, #16]
	ldr	r3, .L1580+24
	ldr	r3, [r3]
	str	r3, [r0, #20]
	ldr	r3, .L1580+28
	ldr	r3, [r3]
	str	r3, [r0, #24]
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L1581:
	.align	2
.L1580:
	.word	.LANCHOR27
	.word	.LANCHOR161
	.word	.LANCHOR35
	.word	.LANCHOR28
	.word	.LANCHOR36
	.word	.LANCHOR122
	.word	.LANCHOR121
	.word	.LANCHOR123
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
	ldr	r0, .L1583
	bl	FtlMapTblRecovery
	movs	r0, #0
	pop	{r3, pc}
.L1584:
	.align	2
.L1583:
	.word	.LANCHOR129
	.size	FtlLoadMapInfo, .-FtlLoadMapInfo
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
	ldr	r4, .L1598
	strh	r3, [r4]	@ movhi
	ldr	r3, .L1598+4
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlScanSysBlk
	ldr	r3, .L1598+8
	ldrh	r2, [r3]
	movw	r3, #65535
	cmp	r2, r3
	bne	.L1586
.L1588:
	mov	r6, #-1
.L1585:
	mov	r0, r6
	pop	{r3, r4, r5, r6, r7, pc}
.L1586:
	bl	FtlLoadSysInfo
	mov	r6, r0
	cmp	r0, #0
	bne	.L1588
	bl	FtlLoadMapInfo
	bl	FtlLoadVonderInfo
	bl	Ftl_load_ext_data
	bl	FtlLoadEctTbl
	bl	FtlFreeSysBLkSort
	bl	SupperBlkListInit
	bl	FtlPowerLostRecovery
	movs	r0, #1
	bl	FtlUpdateVaildLpn
	ldr	r3, .L1598+12
	movs	r0, #12
	ldrh	r1, [r3]
	ldr	r3, .L1598+16
	ldr	r2, [r3]
	mov	r3, r6
.L1589:
	cmp	r3, r1
	bge	.L1594
	mla	r5, r0, r3, r2
	ldr	r5, [r5, #4]
	cmp	r5, #0
	bge	.L1590
.L1594:
	ldr	r0, .L1598+20
	cmp	r3, r1
	ldr	r2, [r0]
	add	r2, r2, #32
	str	r2, [r0]
	bge	.L1596
.L1591:
	ldr	r5, .L1598+24
	ldr	r4, .L1598+28
	mov	r0, r5
	bl	FtlSuperblockPowerLostFix
	mov	r0, r4
	bl	FtlSuperblockPowerLostFix
	ldr	r3, .L1598+32
	ldrh	r1, [r5]
	ldrh	r0, [r5, #4]
	ldr	r2, [r3]
	ldrh	r3, [r2, r1, lsl #1]
	subs	r3, r3, r0
	ldr	r0, .L1598+36
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
	strb	r3, [r4, #6]
	strh	r3, [r4, #4]	@ movhi
	strh	r2, [r4, #2]	@ movhi
	ldr	r2, .L1598+40
	ldrh	r3, [r2, #30]
	adds	r3, r3, #1
	strh	r3, [r2, #30]	@ movhi
	bl	l2p_flush
	bl	FtlVpcTblFlush
.L1597:
	bl	FtlVpcTblFlush
	b	.L1585
.L1590:
	adds	r3, r3, #1
	b	.L1589
.L1596:
	ldrh	r3, [r4]
	cmp	r3, #0
	bne	.L1591
	bl	l2p_flush
	b	.L1597
.L1599:
	.align	2
.L1598:
	.word	.LANCHOR156
	.word	.LANCHOR4
	.word	.LANCHOR139
	.word	.LANCHOR33
	.word	.LANCHOR55
	.word	.LANCHOR83
	.word	.LANCHOR51
	.word	.LANCHOR52
	.word	.LANCHOR42
	.word	.LANCHOR19
	.word	.LANCHOR39
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
	ldr	r6, .L1624
	ldr	r2, .L1624+4
	ldr	r5, .L1624+8
	ldrh	r0, [r6]
	str	r3, [r2]
	str	r3, [r5]
	bl	FtlFreeSysBlkQueueInit
	bl	FtlLoadBbt
	cbz	r0, .L1601
	bl	FtlMakeBbt
.L1601:
	ldr	r3, .L1624+12
	ldr	r2, .L1624+16
	ldr	ip, .L1624+100
	ldrh	r1, [r3]
	ldr	r4, [r2]
	ldr	r2, .L1624+20
	str	r3, [sp, #4]
	lsls	r1, r1, #7
	ldr	r7, [r2]
	movs	r2, #0
.L1602:
	uxth	r3, r2
	adds	r2, r2, #1
	cmp	r3, r1
	blt	.L1603
	ldr	r3, .L1624+24
	movs	r7, #0
	ldr	r10, .L1624+104
	ldrh	r4, [r3]
	mov	r8, r3
	mov	fp, r10
.L1604:
	ldrh	r3, [r10]
	cmp	r3, r4
	bhi	.L1605
	ldr	r4, .L1624+28
	subs	r3, r7, #2
	ldrh	r1, [r4]
	cmp	r3, r1, lsl #1
	bgt	.L1606
.L1610:
	movs	r6, #0
	mov	r7, r6
.L1607:
	ldrh	r3, [r8]
	uxth	r0, r6
	adds	r6, r6, #1
	cmp	r3, r0
	bhi	.L1611
	ldrh	r2, [fp]
	ldr	r3, .L1624+32
	ldrh	r4, [r4]
	ldr	r6, .L1624+36
	str	r2, [r3]
	ldr	r3, .L1624+40
	mov	r1, r4
	ldr	r2, [r3]
	mov	r0, r2
	str	r2, [sp, #12]
	bl	__aeabi_uidiv
	ubfx	r10, r0, #5, #16
	mov	r3, r0
	str	r0, [r6]
	add	r1, r10, #36
	ldr	r0, .L1624+44
	strh	r1, [r0]	@ movhi
	movs	r1, #24
	muls	r1, r4, r1
	str	r0, [sp]
	cmp	r7, r1
	ble	.L1612
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
.L1612:
	ldr	r2, .L1624+48
	ldrh	r2, [r2]
	cbz	r2, .L1614
	ldr	r1, .L1624+44
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
.L1614:
	ldr	r3, [sp]
	ldr	r7, .L1624+52
	ldr	r10, .L1624+108
	ldrh	r2, [r3]
	ldr	r3, [r6]
	subs	r3, r3, r2
	muls	r4, r3, r4
	ldr	r3, .L1624+56
	ldrh	r3, [r3]
	str	r4, [r7]
	muls	r4, r3, r4
	ldr	r3, [sp, #4]
	ldrh	r3, [r3]
	str	r4, [r6]
	ldr	r6, .L1624+60
	muls	r4, r3, r4
	ldr	r3, .L1624+64
	str	r4, [r3]
	movw	r4, #65535
	bl	FtlBbmTblFlush
	ldrh	r2, [fp]
	movs	r1, #0
	ldr	r0, [r10]
	lsls	r2, r2, #1
	bl	ftl_memset
	ldr	r2, .L1624+68
	movs	r3, #0
	strh	r3, [r6, #2]	@ movhi
	movs	r1, #255
	strb	r3, [r6, #6]
	str	r3, [r2]
	ldr	r2, .L1624+72
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
	ldr	r3, .L1624+76
	lsrs	r2, r2, #3
	ldr	r0, [r3]
	bl	ftl_memset
.L1616:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r6, #7]	@ zero_extendqisi2
	ldrh	r2, [r6]
	cmp	r3, #0
	bne	.L1617
	ldr	r3, [r8]
	strh	r4, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r6]
	adds	r3, r3, #1
	strh	r3, [r6]	@ movhi
	b	.L1616
.L1603:
	mvns	r0, r3
	orr	r0, r3, r0, lsl #16
	str	r0, [r4, r3, lsl #2]
	str	ip, [r7, r3, lsl #2]
	b	.L1602
.L1605:
	mov	r0, r4
	movs	r1, #1
	bl	FtlLowFormatEraseBlock
	adds	r4, r4, #1
	add	r7, r7, r0
	uxth	r7, r7
	uxth	r4, r4
	b	.L1604
.L1606:
	mov	r0, r7
	bl	__aeabi_uidiv
	ldr	r3, .L1624+80
	ldr	r3, [r3]
	add	r0, r0, r3
	uxth	r0, r0
	bl	FtlSysBlkNumInit
	ldrh	r0, [r6]
	bl	FtlFreeSysBlkQueueInit
	ldrh	r6, [r8]
.L1608:
	ldrh	r3, [fp]
	cmp	r3, r6
	bls	.L1610
	mov	r0, r6
	movs	r1, #1
	adds	r6, r6, #1
	bl	FtlLowFormatEraseBlock
	uxth	r6, r6
	b	.L1608
.L1611:
	movs	r1, #0
	bl	FtlLowFormatEraseBlock
	add	r7, r7, r0
	uxth	r7, r7
	b	.L1607
.L1617:
	ldr	r3, [r5]
	ldrh	r1, [r6, #4]
	ldr	r4, .L1624+84
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
.L1618:
	mov	r0, r10
	bl	make_superblock
	ldrb	r3, [r4, #7]	@ zero_extendqisi2
	ldrh	r2, [r4]
	cbnz	r3, .L1619
	ldr	r3, [r8]
	strh	r6, [r3, r2, lsl #1]	@ movhi
	ldrh	r3, [r4]
	adds	r3, r3, #1
	strh	r3, [r4]	@ movhi
	b	.L1618
.L1619:
	ldr	r3, [r5]
	ldrh	r1, [r4, #4]
	str	r3, [r4, #12]
	adds	r3, r3, #1
	str	r3, [r5]
	movw	r4, #65535
	ldr	r3, [r8]
	strh	r1, [r3, r2, lsl #1]	@ movhi
	ldr	r3, .L1624+88
	strh	r4, [r3]	@ movhi
	bl	FtlFreeSysBlkQueueOut
	ldr	r3, .L1624+92
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
	cbnz	r0, .L1620
	ldr	r3, .L1624+96
	movs	r2, #1
	str	r2, [r3]
.L1620:
	movs	r0, #0
	add	sp, sp, #16
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1625:
	.align	2
.L1624:
	.word	.LANCHOR4
	.word	.LANCHOR83
	.word	.LANCHOR82
	.word	.LANCHOR12
	.word	.LANCHOR109
	.word	.LANCHOR110
	.word	.LANCHOR5
	.word	.LANCHOR3
	.word	.LANCHOR99
	.word	.LANCHOR152
	.word	.LANCHOR7
	.word	.LANCHOR171
	.word	.LANCHOR15
	.word	.LANCHOR179
	.word	.LANCHOR19
	.word	.LANCHOR51
	.word	.LANCHOR34
	.word	.LANCHOR59
	.word	.LANCHOR144
	.word	.LANCHOR1
	.word	.LANCHOR31
	.word	.LANCHOR52
	.word	.LANCHOR53
	.word	.LANCHOR139
	.word	.LANCHOR166
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
	push	{r4, r5, r6, lr}
	mov	r3, #-1
	ldr	r4, .L1643
	movs	r6, #0
	ldr	r1, .L1643+4
	ldr	r0, .L1643+8
	str	r3, [r4]
	bl	printf
	ldr	r0, .L1643+12
	bl	FtlConstantsInit
	ldr	r5, .L1643+16
	bl	FtlMemInit
	bl	FtlVariablesInit
	ldr	r3, .L1643+20
	ldrh	r0, [r3]
	bl	FtlFreeSysBlkQueueInit
.L1627:
	bl	FtlLoadBbt
	cbz	r0, .L1628
.L1642:
	ldr	r3, [r5]
	cmp	r3, #1
	bne	.L1627
	str	r6, [r5]
	bl	ftl_low_format
	b	.L1627
.L1628:
	bl	FtlSysBlkInit
	cmp	r0, #0
	bne	.L1642
	movs	r3, #1
	str	r3, [r4]
	ldr	r3, .L1643+24
	ldrh	r3, [r3]
	cmp	r3, #15
	bhi	.L1640
	movw	r4, #8129
.L1634:
	movs	r1, #1
	movs	r0, #0
	bl	rk_ftl_garbage_collect
	subs	r4, r4, #1
	bne	.L1634
.L1640:
	movs	r0, #0
	pop	{r4, r5, r6, pc}
.L1644:
	.align	2
.L1643:
	.word	.LANCHOR166
	.word	.LC41
	.word	.LC34
	.word	.LANCHOR0
	.word	.LANCHOR181
	.word	.LANCHOR4
	.word	.LANCHOR48
	.size	sftl_init, .-sftl_init
	.section	.text.FtlWriteToIDB,"ax",%progbits
	.align	1
	.global	FtlWriteToIDB
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	FtlWriteToIDB, %function
FtlWriteToIDB:
	@ args = 0, pretend = 0, frame = 104
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r10, fp, lr}
	add	r8, r1, r0
	add	r10, r8, #-1
	sub	sp, sp, #112
	cmp	r10, #63
	mov	r4, r0
	mov	r6, r1
	mov	r7, r2
	ldr	r5, .L1715
	bls	.L1646
	cmp	r0, #576
	bcc	.L1647
.L1646:
	ldr	r3, [r5]
	cbnz	r3, .L1648
.L1714:
	movs	r4, #0
	b	.L1645
.L1648:
	ldr	r3, .L1715+4
	ldr	r3, [r3]
	ldr	r2, [r3]
	str	r3, [sp, #12]
	ldr	r3, .L1715+8
	cmp	r2, r3
	bne	.L1650
	ldr	r3, .L1715+12
	movs	r2, #0
	ldrh	r1, [r3, #10]
	ldr	r3, [sp, #12]
	add	r0, r3, #262144
	movw	r3, #65535
.L1654:
	ldr	r4, [r0, #-4]
	cbnz	r4, .L1651
	ldr	r4, [sp, #12]
	subs	r3, r3, #1
	ldr	r4, [r4, r2, lsl #2]
	adds	r2, r2, #1
	cmp	r2, #4096
	it	hi
	movhi	r2, #0
	cmp	r3, #4096
	str	r4, [r0, #-4]!
	bne	.L1654
	mov	r3, #512
	b	.L1711
.L1651:
	adds	r3, r3, #127
	lsrs	r3, r3, #7
.L1711:
	str	r3, [sp, #16]
	lsls	r1, r1, #2
	ldr	r3, [sp, #16]
	uxth	r1, r1
	ldr	r4, .L1715+16
	adds	r0, r3, #4
	bl	__aeabi_uidiv
	adds	r3, r0, #1
	str	r3, [sp, #24]
	ldr	r3, [sp, #16]
	lsls	r3, r3, #7
	str	r3, [sp, #36]
	movs	r3, #0
	mov	r10, r3
	str	r3, [sp, #20]
.L1676:
	ldr	r3, .L1715+20
	mov	r2, #512
	movs	r1, #0
	ldr	r0, [r3]
	bl	memset
	ldr	r3, .L1715+12
	ldrh	r6, [r3, #10]
	ldr	r3, [r4, #16]
	mul	fp, r10, r6
	cmp	r3, #0
	beq	.L1684
	ldr	r3, [r4, #20]
	cmp	r3, #0
	ite	eq
	moveq	r3, #6
	movne	r3, #9
.L1712:
	str	r3, [sp, #28]
	mov	r1, fp
	ldr	r3, .L1715+16
	movs	r0, #0
	ldr	r3, [r3, #4]
	blx	r3
	ldr	r3, [sp, #24]
	cmp	r3, #1
	beq	.L1656
	ldr	r3, .L1715+16
	add	r1, r6, fp
	movs	r0, #0
	ldr	r3, [r3, #4]
	blx	r3
.L1656:
	ldr	r3, [sp, #28]
	cmp	r3, #9
	bne	.L1686
	ldr	r3, .L1715+20
	mov	r2, #1024
	movs	r1, #0
	ldr	r5, [r3]
	mov	r0, r5
	bl	ftl_memset
	movs	r2, #4
	ldr	r3, .L1715+24
	strb	r2, [r5, #17]
	movs	r1, #12
	ldr	r2, .L1715+12
	adds	r0, r5, r1
	str	r3, [r5]
	movs	r3, #0
	str	r1, [r5, #4]
	ldrh	r2, [r2, #10]
	str	r3, [r5, #12]
	strb	r3, [r5, #16]
	strh	r2, [r5, #18]	@ movhi
	movs	r2, #16
	strb	r3, [r5, #20]
	strb	r2, [r5, #21]
	strh	r3, [r5, #22]	@ movhi
	bl	js_hash
	str	r0, [r5, #8]
.L1657:
	ldr	r3, [sp, #24]
	mov	r8, fp
	muls	r3, r6, r3
	movs	r6, #0
	str	r3, [sp, #40]
	ldr	r3, [sp, #12]
	str	r3, [sp, #32]
.L1658:
	ldr	r3, [sp, #40]
	cmp	r6, r3
	beq	.L1665
	ldr	r3, [sp, #28]
	cmp	r3, #9
	itet	ne
	addne	r3, fp, r6
	addeq	r3, r8, #1
	lslne	r3, r3, #2
	str	r3, [sp, #48]
	movw	r3, #61424
	str	r3, [sp, #52]
	cmp	r6, #0
	bne	.L1661
	ldr	r3, [sp, #28]
	cmp	r3, #9
	bne	.L1661
	ldr	r3, [r4, #16]
	movs	r0, #70
	blx	r3
	add	r3, sp, #48
	mov	r2, r5
	mov	r1, fp
	mov	r0, r6
	ldr	r7, [r4, #8]
	blx	r7
	ldr	r2, .L1715+12
	str	r0, [sp, #44]
	ldr	r3, [r4, #16]
	ldrb	r0, [r2, #22]	@ zero_extendqisi2
	blx	r3
	ldr	r2, [sp, #44]
	adds	r2, r2, #1
	bne	.L1662
.L1665:
	ldr	r3, .L1715+20
	ldr	r2, [r4, #16]
	ldr	r6, [r3]
	ldr	r3, .L1715+12
	ldrb	r3, [r3, #14]	@ zero_extendqisi2
	str	r3, [sp, #28]
	ldr	r3, .L1715+12
	ldrh	r3, [r3, #10]
	mul	r8, r10, r3
	cmp	r2, #0
	bne	.L1663
	mov	fp, #6
.L1664:
	ldr	r2, [sp, #24]
	movs	r5, #0
	muls	r3, r2, r3
	str	r3, [sp, #32]
.L1667:
	ldr	r3, [sp, #32]
	cmp	r5, r3
	beq	.L1671
	cmp	r5, #0
	bne	.L1668
	cmp	fp, #9
	bne	.L1668
	ldr	r3, [r4, #16]
	movs	r0, #70
	blx	r3
	ldr	r3, [r4, #20]
	movs	r0, #2
	blx	r3
	mov	r2, r6
	mov	r1, r8
	add	r3, sp, #48
	mov	r0, r5
	ldr	r7, [r4, #12]
	blx	r7
	ldr	r3, [r4, #20]
	ldr	r0, [sp, #28]
	blx	r3
	ldr	r2, .L1715+12
	ldr	r3, [r4, #16]
	ldrb	r0, [r2, #22]	@ zero_extendqisi2
	blx	r3
	ldr	r3, [r6]
	ldr	r2, .L1715+24
	cmp	r3, r2
	beq	.L1669
.L1671:
	ldr	r3, .L1715+20
	movs	r5, #0
	ldr	r1, [sp, #12]
	ldr	r0, [r3]
.L1670:
	mov	r8, r1
	ldr	r2, [r0, r5, lsl #2]
	ldr	r3, [r8]
	lsls	r6, r5, #2
	adds	r1, r1, #4
	cmp	r2, r3
	beq	.L1673
	mov	r2, #512
	movs	r1, #0
	bl	memset
	ldr	r3, .L1715+20
	mov	r1, r10
	ldr	r0, .L1715+28
	ldr	r2, [r3]
	str	r5, [sp]
	ldr	r3, [r8]
	ldr	r2, [r2, r6]
	bl	printf
	ldr	r3, .L1715+12
	movs	r0, #0
	ldrh	r1, [r3, #10]
	ldr	r3, [r4, #4]
	mul	r1, r10, r1
	blx	r3
.L1674:
	ldr	r3, [sp, #24]
	add	r10, r10, r3
	cmp	r10, #15
	bls	.L1676
	ldr	r3, [sp, #20]
	cbnz	r3, .L1677
.L1650:
	mov	r3, #-1
	str	r3, [sp, #16]
.L1677:
	ldr	r3, .L1715
	movs	r2, #0
	ldr	r4, [sp, #16]
	str	r2, [r3]
	ldr	r3, .L1715+4
	ldr	r0, [r3]
	bl	free
	ldr	r3, .L1715+20
	ldr	r0, [r3]
	bl	free
.L1645:
	mov	r0, r4
	add	sp, sp, #112
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r10, fp, pc}
.L1684:
	movs	r3, #6
	b	.L1712
.L1686:
	movs	r5, #0
	b	.L1657
.L1661:
	add	r3, sp, #48
	ldr	r2, [sp, #32]
	mov	r1, r8
	movs	r0, #0
	ldr	r7, [r4, #8]
	blx	r7
	adds	r0, r0, #1
	beq	.L1665
	ldr	r3, [sp, #32]
	add	r3, r3, #2048
	str	r3, [sp, #32]
.L1662:
	adds	r6, r6, #1
	add	r8, r8, #1
	b	.L1658
.L1663:
	ldr	r2, [r4, #20]
	cmp	r2, #0
	ite	eq
	moveq	fp, #6
	movne	fp, #9
	b	.L1664
.L1668:
	add	r3, sp, #48
	mov	r2, r6
	add	r1, r8, r5
	movs	r0, #0
	ldr	r7, [r4, #12]
	blx	r7
	adds	r0, r0, #1
	beq	.L1671
	ldr	r2, [sp, #52]
	movw	r3, #61424
	cmp	r2, r3
	bne	.L1671
	add	r6, r6, #2048
.L1669:
	adds	r5, r5, #1
	b	.L1667
.L1716:
	.align	2
.L1715:
	.word	.LANCHOR182
	.word	.LANCHOR183
	.word	-52655045
	.word	.LANCHOR0
	.word	.LANCHOR78
	.word	.LANCHOR184
	.word	1179535694
	.word	.LC42
.L1673:
	ldr	r3, [sp, #36]
	adds	r5, r5, #1
	cmp	r5, r3
	bne	.L1670
	ldr	r3, [sp, #20]
	adds	r3, r3, #1
	cmp	r3, #5
	str	r3, [sp, #20]
	bls	.L1674
	b	.L1677
.L1647:
	cmp	r0, #64
	bne	.L1678
	ldr	fp, .L1717+4
	mov	r0, #262144
	bl	ftl_malloc
	str	r0, [fp]
	mov	r0, #262144
	bl	ftl_malloc
	ldr	r3, .L1717
	str	r0, [r3]
	ldr	r3, [fp]
	cbz	r3, .L1679
	cbz	r0, .L1679
	movs	r2, #1
	movs	r1, #0
	str	r2, [r5]
	mov	r0, r3
	mov	r2, #262144
	bl	ftl_memset
.L1678:
	ldr	r3, [r5]
	cmp	r3, #0
	beq	.L1714
	ldr	r3, .L1717+4
	cmp	r4, #63
	iteee	hi
	ldrhi	r5, .L1717+8
	rsbls	r4, r4, #64
	subls	r6, r6, r4
	addls	r7, r7, r4, lsl #9
	ldr	r1, [r3]
	mov	r2, #262144
	it	hi
	addhi	r5, r5, r4
	ldr	r0, .L1717+12
	ite	ls
	movls	r5, r1
	addhi	r5, r1, r5, lsl #9
	cmp	r10, #576
	itt	cs
	subcs	r6, r6, r8
	subcs	r6, r6, #446
	mov	r3, r5
	str	r6, [sp]
	bl	printf
	lsls	r2, r6, #9
	mov	r1, r7
	mov	r0, r5
	bl	ftl_memcpy
	b	.L1714
.L1679:
	ldr	r1, .L1717+16
	ldr	r0, .L1717+20
	bl	printf
	b	.L1678
.L1718:
	.align	2
.L1717:
	.word	.LANCHOR184
	.word	.LANCHOR183
	.word	8388544
	.word	.LC44
	.word	.LANCHOR185
	.word	.LC43
	.size	FtlWriteToIDB, .-FtlWriteToIDB
	.section	.text.sftl_write,"ax",%progbits
	.align	1
	.global	sftl_write
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	sftl_write, %function
sftl_write:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r5, r1
	mov	r6, r2
	mov	r4, r0
	bl	FtlWriteToIDB
	mov	r3, r6
	mov	r2, r5
	mov	r1, r4
	movs	r0, #0
	pop	{r4, r5, r6, lr}
	b	FtlWrite
	.size	sftl_write, .-sftl_write
	.global	g_nand_ops
	.global	g_nand_phy_info
	.global	gc_ink_free_return_value
	.global	check_vpc_table
	.global	FtlUpdateVaildLpnCount
	.global	g_ect_tbl_power_up_flush
	.global	power_up_flag
	.global	low_format_en
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
	.set	.LANCHOR127,. + 0
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
	.set	.LANCHOR171,. + 0
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
	.set	.LANCHOR67,. + 0
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
	.set	.LANCHOR133,. + 0
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
	.set	.LANCHOR129,. + 0
	.type	gL2pMapInfo, %object
	.size	gL2pMapInfo, 44
gL2pMapInfo:
	.space	44
	.section	.bss.gSysFreeQueue,"aw",%nobits
	.align	1
	.set	.LANCHOR38,. + 0
	.type	gSysFreeQueue, %object
	.size	gSysFreeQueue, 2056
gSysFreeQueue:
	.space	2056
	.section	.bss.gSysInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR139,. + 0
	.type	gSysInfo, %object
	.size	gSysInfo, 16
gSysInfo:
	.space	16
	.section	.bss.gVendorBlkInfo,"aw",%nobits
	.align	2
	.set	.LANCHOR161,. + 0
	.type	gVendorBlkInfo, %object
	.size	gVendorBlkInfo, 44
gVendorBlkInfo:
	.space	44
	.section	.bss.g_GlobalDataVersion,"aw",%nobits
	.align	2
	.set	.LANCHOR83,. + 0
	.type	g_GlobalDataVersion, %object
	.size	g_GlobalDataVersion, 4
g_GlobalDataVersion:
	.space	4
	.section	.bss.g_GlobalSysVersion,"aw",%nobits
	.align	2
	.set	.LANCHOR82,. + 0
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
	.set	.LANCHOR179,. + 0
	.type	g_MaxLbn, %object
	.size	g_MaxLbn, 4
g_MaxLbn:
	.space	4
	.section	.bss.g_MaxLpn,"aw",%nobits
	.align	2
	.set	.LANCHOR152,. + 0
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
	.set	.LANCHOR99,. + 0
	.type	g_cur_erase_blk, %object
	.size	g_cur_erase_blk, 4
g_cur_erase_blk:
	.space	4
	.section	.bss.g_ect_tbl_info_size,"aw",%nobits
	.align	1
	.set	.LANCHOR116,. + 0
	.type	g_ect_tbl_info_size, %object
	.size	g_ect_tbl_info_size, 2
g_ect_tbl_info_size:
	.space	2
	.section	.bss.g_ect_tbl_power_up_flush,"aw",%nobits
	.align	1
	.set	.LANCHOR164,. + 0
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
	.set	.LANCHOR76,. + 0
	.type	g_gc_bad_block_gc_index, %object
	.size	g_gc_bad_block_gc_index, 2
g_gc_bad_block_gc_index:
	.space	2
	.section	.bss.g_gc_bad_block_temp_num,"aw",%nobits
	.align	1
	.set	.LANCHOR74,. + 0
	.type	g_gc_bad_block_temp_num, %object
	.size	g_gc_bad_block_temp_num, 2
g_gc_bad_block_temp_num:
	.space	2
	.section	.bss.g_gc_bad_block_temp_tbl,"aw",%nobits
	.align	1
	.set	.LANCHOR75,. + 0
	.type	g_gc_bad_block_temp_tbl, %object
	.size	g_gc_bad_block_temp_tbl, 34
g_gc_bad_block_temp_tbl:
	.space	34
	.section	.bss.g_gc_blk_index,"aw",%nobits
	.align	1
	.set	.LANCHOR102,. + 0
	.type	g_gc_blk_index, %object
	.size	g_gc_blk_index, 2
g_gc_blk_index:
	.space	2
	.section	.bss.g_gc_blk_num,"aw",%nobits
	.align	1
	.set	.LANCHOR69,. + 0
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
	.set	.LANCHOR100,. + 0
	.type	g_gc_free_blk_threshold, %object
	.size	g_gc_free_blk_threshold, 2
g_gc_free_blk_threshold:
	.space	2
	.section	.bss.g_gc_head_data_block,"aw",%nobits
	.align	2
	.set	.LANCHOR96,. + 0
	.type	g_gc_head_data_block, %object
	.size	g_gc_head_data_block, 4
g_gc_head_data_block:
	.space	4
	.section	.bss.g_gc_head_data_block_count,"aw",%nobits
	.align	2
	.set	.LANCHOR97,. + 0
	.type	g_gc_head_data_block_count, %object
	.size	g_gc_head_data_block_count, 4
g_gc_head_data_block_count:
	.space	4
	.section	.bss.g_gc_merge_free_blk_threshold,"aw",%nobits
	.align	1
	.set	.LANCHOR101,. + 0
	.type	g_gc_merge_free_blk_threshold, %object
	.size	g_gc_merge_free_blk_threshold, 2
g_gc_merge_free_blk_threshold:
	.space	2
	.section	.bss.g_gc_next_blk,"aw",%nobits
	.align	1
	.set	.LANCHOR72,. + 0
	.type	g_gc_next_blk, %object
	.size	g_gc_next_blk, 2
g_gc_next_blk:
	.space	2
	.section	.bss.g_gc_next_blk_1,"aw",%nobits
	.align	1
	.set	.LANCHOR73,. + 0
	.type	g_gc_next_blk_1, %object
	.size	g_gc_next_blk_1, 2
g_gc_next_blk_1:
	.space	2
	.section	.bss.g_gc_num_req,"aw",%nobits
	.align	2
	.set	.LANCHOR62,. + 0
	.type	g_gc_num_req, %object
	.size	g_gc_num_req, 4
g_gc_num_req:
	.space	4
	.section	.bss.g_gc_page_offset,"aw",%nobits
	.align	1
	.set	.LANCHOR70,. + 0
	.type	g_gc_page_offset, %object
	.size	g_gc_page_offset, 2
g_gc_page_offset:
	.space	2
	.section	.bss.g_gc_skip_write_count,"aw",%nobits
	.align	2
	.set	.LANCHOR98,. + 0
	.type	g_gc_skip_write_count, %object
	.size	g_gc_skip_write_count, 4
g_gc_skip_write_count:
	.space	4
	.section	.bss.g_gc_superblock,"aw",%nobits
	.align	2
	.set	.LANCHOR144,. + 0
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
	.set	.LANCHOR94,. + 0
	.type	g_in_gc_progress, %object
	.size	g_in_gc_progress, 4
g_in_gc_progress:
	.space	4
	.section	.bss.g_in_swl_replace,"aw",%nobits
	.align	2
	.set	.LANCHOR95,. + 0
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
	.set	.LANCHOR92,. + 0
	.type	g_max_erase_count, %object
	.size	g_max_erase_count, 4
g_max_erase_count:
	.space	4
	.section	.bss.g_min_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR93,. + 0
	.type	g_min_erase_count, %object
	.size	g_min_erase_count, 4
g_min_erase_count:
	.space	4
	.section	.bss.g_nand_ops,"aw",%nobits
	.align	2
	.set	.LANCHOR78,. + 0
	.type	g_nand_ops, %object
	.size	g_nand_ops, 24
g_nand_ops:
	.space	24
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
	.set	.LANCHOR156,. + 0
	.type	g_power_lost_recovery_flag, %object
	.size	g_power_lost_recovery_flag, 2
g_power_lost_recovery_flag:
	.space	2
	.section	.bss.g_recovery_page_min_ver,"aw",%nobits
	.align	2
	.set	.LANCHOR134,. + 0
	.type	g_recovery_page_min_ver, %object
	.size	g_recovery_page_min_ver, 4
g_recovery_page_min_ver:
	.space	4
	.section	.bss.g_recovery_page_num,"aw",%nobits
	.align	2
	.set	.LANCHOR157,. + 0
	.type	g_recovery_page_num, %object
	.size	g_recovery_page_num, 4
g_recovery_page_num:
	.space	4
	.section	.bss.g_recovery_ppa_tbl,"aw",%nobits
	.align	2
	.set	.LANCHOR158,. + 0
	.type	g_recovery_ppa_tbl, %object
	.size	g_recovery_ppa_tbl, 128
g_recovery_ppa_tbl:
	.space	128
	.section	.bss.g_sys_ext_data,"aw",%nobits
	.align	2
	.set	.LANCHOR135,. + 0
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
	.set	.LANCHOR131,. + 0
	.type	g_tmp_data_superblock_id, %object
	.size	g_tmp_data_superblock_id, 2
g_tmp_data_superblock_id:
	.space	2
	.section	.bss.g_totle_avg_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR145,. + 0
	.type	g_totle_avg_erase_count, %object
	.size	g_totle_avg_erase_count, 4
g_totle_avg_erase_count:
	.space	4
	.section	.bss.g_totle_cache_write_count,"aw",%nobits
	.align	2
	.set	.LANCHOR87,. + 0
	.type	g_totle_cache_write_count, %object
	.size	g_totle_cache_write_count, 4
g_totle_cache_write_count:
	.space	4
	.section	.bss.g_totle_discard_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR86,. + 0
	.type	g_totle_discard_page_count, %object
	.size	g_totle_discard_page_count, 4
g_totle_discard_page_count:
	.space	4
	.section	.bss.g_totle_gc_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR84,. + 0
	.type	g_totle_gc_page_count, %object
	.size	g_totle_gc_page_count, 4
g_totle_gc_page_count:
	.space	4
	.section	.bss.g_totle_l2p_write_count,"aw",%nobits
	.align	2
	.set	.LANCHOR88,. + 0
	.type	g_totle_l2p_write_count, %object
	.size	g_totle_l2p_write_count, 4
g_totle_l2p_write_count:
	.space	4
	.section	.bss.g_totle_map_block,"aw",%nobits
	.align	1
	.set	.LANCHOR130,. + 0
	.type	g_totle_map_block, %object
	.size	g_totle_map_block, 2
g_totle_map_block:
	.space	2
	.section	.bss.g_totle_mlc_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR90,. + 0
	.type	g_totle_mlc_erase_count, %object
	.size	g_totle_mlc_erase_count, 4
g_totle_mlc_erase_count:
	.space	4
	.section	.bss.g_totle_read_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR89,. + 0
	.type	g_totle_read_page_count, %object
	.size	g_totle_read_page_count, 4
g_totle_read_page_count:
	.space	4
	.section	.bss.g_totle_read_sector,"aw",%nobits
	.align	2
	.set	.LANCHOR163,. + 0
	.type	g_totle_read_sector, %object
	.size	g_totle_read_sector, 4
g_totle_read_sector:
	.space	4
	.section	.bss.g_totle_slc_erase_count,"aw",%nobits
	.align	2
	.set	.LANCHOR91,. + 0
	.type	g_totle_slc_erase_count, %object
	.size	g_totle_slc_erase_count, 4
g_totle_slc_erase_count:
	.space	4
	.section	.bss.g_totle_swl_count,"aw",%nobits
	.align	2
	.set	.LANCHOR132,. + 0
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
	.set	.LANCHOR35,. + 0
	.type	g_totle_vendor_block, %object
	.size	g_totle_vendor_block, 2
g_totle_vendor_block:
	.space	2
	.section	.bss.g_totle_write_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR85,. + 0
	.type	g_totle_write_page_count, %object
	.size	g_totle_write_page_count, 4
g_totle_write_page_count:
	.space	4
	.section	.bss.g_totle_write_sector,"aw",%nobits
	.align	2
	.set	.LANCHOR162,. + 0
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
	.set	.LANCHOR118,. + 0
	.type	gp_ect_tbl_info, %object
	.size	gp_ect_tbl_info, 4
gp_ect_tbl_info:
	.space	4
	.section	.bss.gp_flash_check_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR184,. + 0
	.type	gp_flash_check_buf, %object
	.size	gp_flash_check_buf, 4
gp_flash_check_buf:
	.space	4
	.section	.bss.gp_gc_page_buf_info,"aw",%nobits
	.align	2
	.set	.LANCHOR63,. + 0
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
	.set	.LANCHOR183,. + 0
	.type	idb_buf, %object
	.size	idb_buf, 4
idb_buf:
	.space	4
	.section	.bss.idb_need_write_back,"aw",%nobits
	.align	2
	.set	.LANCHOR182,. + 0
	.type	idb_need_write_back, %object
	.size	idb_need_write_back, 4
idb_need_write_back:
	.space	4
	.section	.bss.low_format_en,"aw",%nobits
	.align	2
	.set	.LANCHOR181,. + 0
	.type	low_format_en, %object
	.size	low_format_en, 4
low_format_en:
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
	.set	.LANCHOR68,. + 0
	.type	p_gc_blk_tbl, %object
	.size	p_gc_blk_tbl, 4
p_gc_blk_tbl:
	.space	4
	.section	.bss.p_gc_data_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR64,. + 0
	.type	p_gc_data_buf, %object
	.size	p_gc_data_buf, 4
p_gc_data_buf:
	.space	4
	.section	.bss.p_gc_page_info,"aw",%nobits
	.align	2
	.set	.LANCHOR71,. + 0
	.type	p_gc_page_info, %object
	.size	p_gc_page_info, 4
p_gc_page_info:
	.space	4
	.section	.bss.p_gc_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR65,. + 0
	.type	p_gc_spare_buf, %object
	.size	p_gc_spare_buf, 4
p_gc_spare_buf:
	.space	4
	.section	.bss.p_io_data_buf_0,"aw",%nobits
	.align	2
	.set	.LANCHOR109,. + 0
	.type	p_io_data_buf_0, %object
	.size	p_io_data_buf_0, 4
p_io_data_buf_0:
	.space	4
	.section	.bss.p_io_data_buf_1,"aw",%nobits
	.align	2
	.set	.LANCHOR110,. + 0
	.type	p_io_data_buf_1, %object
	.size	p_io_data_buf_1, 4
p_io_data_buf_1:
	.space	4
	.section	.bss.p_io_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR115,. + 0
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
	.set	.LANCHOR55,. + 0
	.type	p_l2p_ram_map, %object
	.size	p_l2p_ram_map, 4
p_l2p_ram_map:
	.space	4
	.section	.bss.p_map_block_table,"aw",%nobits
	.align	2
	.set	.LANCHOR119,. + 0
	.type	p_map_block_table, %object
	.size	p_map_block_table, 4
p_map_block_table:
	.space	4
	.section	.bss.p_map_block_valid_page_count,"aw",%nobits
	.align	2
	.set	.LANCHOR120,. + 0
	.type	p_map_block_valid_page_count, %object
	.size	p_map_block_valid_page_count, 4
p_map_block_valid_page_count:
	.space	4
	.section	.bss.p_map_block_ver_table,"aw",%nobits
	.align	2
	.set	.LANCHOR125,. + 0
	.type	p_map_block_ver_table, %object
	.size	p_map_block_ver_table, 4
p_map_block_ver_table:
	.space	4
	.section	.bss.p_map_region_ppn_table,"aw",%nobits
	.align	2
	.set	.LANCHOR124,. + 0
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
	.set	.LANCHOR117,. + 0
	.type	p_swl_mul_table, %object
	.size	p_swl_mul_table, 4
p_swl_mul_table:
	.space	4
	.section	.bss.p_sys_data_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR106,. + 0
	.type	p_sys_data_buf, %object
	.size	p_sys_data_buf, 4
p_sys_data_buf:
	.space	4
	.section	.bss.p_sys_data_buf_1,"aw",%nobits
	.align	2
	.set	.LANCHOR107,. + 0
	.type	p_sys_data_buf_1, %object
	.size	p_sys_data_buf_1, 4
p_sys_data_buf_1:
	.space	4
	.section	.bss.p_sys_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR114,. + 0
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
	.set	.LANCHOR121,. + 0
	.type	p_vendor_block_valid_page_count, %object
	.size	p_vendor_block_valid_page_count, 4
p_vendor_block_valid_page_count:
	.space	4
	.section	.bss.p_vendor_block_ver_table,"aw",%nobits
	.align	2
	.set	.LANCHOR122,. + 0
	.type	p_vendor_block_ver_table, %object
	.size	p_vendor_block_ver_table, 4
p_vendor_block_ver_table:
	.space	4
	.section	.bss.p_vendor_data_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR108,. + 0
	.type	p_vendor_data_buf, %object
	.size	p_vendor_data_buf, 4
p_vendor_data_buf:
	.space	4
	.section	.bss.p_vendor_region_ppn_table,"aw",%nobits
	.align	2
	.set	.LANCHOR123,. + 0
	.type	p_vendor_region_ppn_table, %object
	.size	p_vendor_region_ppn_table, 4
p_vendor_region_ppn_table:
	.space	4
	.section	.bss.req_erase,"aw",%nobits
	.align	2
	.set	.LANCHOR79,. + 0
	.type	req_erase, %object
	.size	req_erase, 4
req_erase:
	.space	4
	.section	.bss.req_gc,"aw",%nobits
	.align	2
	.set	.LANCHOR66,. + 0
	.type	req_gc, %object
	.size	req_gc, 4
req_gc:
	.space	4
	.section	.bss.req_gc_dst,"aw",%nobits
	.align	2
	.set	.LANCHOR104,. + 0
	.type	req_gc_dst, %object
	.size	req_gc_dst, 4
req_gc_dst:
	.space	4
	.section	.bss.req_prgm,"aw",%nobits
	.align	2
	.set	.LANCHOR105,. + 0
	.type	req_prgm, %object
	.size	req_prgm, 4
req_prgm:
	.space	4
	.section	.bss.req_read,"aw",%nobits
	.align	2
	.set	.LANCHOR103,. + 0
	.type	req_read, %object
	.size	req_read, 4
req_read:
	.space	4
	.section	.bss.req_sys,"aw",%nobits
	.align	2
	.set	.LANCHOR138,. + 0
	.type	req_sys, %object
	.size	req_sys, 20
req_sys:
	.space	20
	.section	.bss.sftl_nand_check_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR111,. + 0
	.type	sftl_nand_check_buf, %object
	.size	sftl_nand_check_buf, 4
sftl_nand_check_buf:
	.space	4
	.section	.bss.sftl_nand_check_spare_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR113,. + 0
	.type	sftl_nand_check_spare_buf, %object
	.size	sftl_nand_check_spare_buf, 4
sftl_nand_check_spare_buf:
	.space	4
	.section	.bss.sftl_temp_buf,"aw",%nobits
	.align	2
	.set	.LANCHOR112,. + 0
	.type	sftl_temp_buf, %object
	.size	sftl_temp_buf, 4
sftl_temp_buf:
	.space	4
	.section	.data.ftl_gc_temp_block_bops_scan_page_addr,"aw",%progbits
	.align	1
	.set	.LANCHOR160,. + 0
	.type	ftl_gc_temp_block_bops_scan_page_addr, %object
	.size	ftl_gc_temp_block_bops_scan_page_addr, 2
ftl_gc_temp_block_bops_scan_page_addr:
	.short	-1
	.section	.data.gFtlInitStatus,"aw",%progbits
	.align	2
	.set	.LANCHOR166,. + 0
	.type	gFtlInitStatus, %object
	.size	gFtlInitStatus, 4
gFtlInitStatus:
	.word	-1
	.section	.data.power_up_flag,"aw",%progbits
	.align	2
	.type	power_up_flag, %object
	.size	power_up_flag, 4
power_up_flag:
	.word	1
	.section	.rodata.FlashEraseBlocks.str1.1,"aMS",%progbits,1
.LC6:
	.ascii	"%s: addr: %x is in id block!!!!!!!!!!\012\000"
.LC7:
	.ascii	"not free: w: d:\000"
.LC8:
	.ascii	"not free: w: s:\000"
	.section	.rodata.FlashProgPages.str1.1,"aMS",%progbits,1
.LC11:
	.ascii	"prog read error: = %x\012\000"
.LC12:
	.ascii	"prog read s error: = %x %x %x\012\000"
.LC13:
	.ascii	"prog read d error: = %x %x %x\012\000"
	.section	.rodata.FtlBbmMapBadBlock.str1.1,"aMS",%progbits,1
.LC0:
	.ascii	"phyBlk = 0x%x die = %d block_in_die = 0x%x 0x%8x\012"
	.ascii	"\000"
	.section	.rodata.FtlBbmTblFlush.str1.1,"aMS",%progbits,1
.LC14:
	.ascii	"FtlBbmTblFlush id=%x,page=%x,previd=%x cnt=%d\012\000"
.LC15:
	.ascii	"FtlBbmTblFlush error:%x\012\000"
.LC16:
	.ascii	"FtlBbmTblFlush error = %x error count = %d\012\000"
	.section	.rodata.FtlFreeSysBlkQueueOut.str1.1,"aMS",%progbits,1
.LC9:
	.ascii	"FtlFreeSysBlkQueueOut = %x, free count = %d, error\012"
	.ascii	"\000"
	.section	.rodata.FtlGcScanTempBlk.str1.1,"aMS",%progbits,1
.LC31:
	.ascii	"FtlGcScanTempBlk Error ID %x %x!!!!!!! \012\000"
	.section	.rodata.FtlLoadEctTbl.str1.1,"aMS",%progbits,1
.LC33:
	.ascii	"no ect\000"
.LC34:
	.ascii	"%s\012\000"
	.section	.rodata.FtlLoadSysInfo.str1.1,"aMS",%progbits,1
.LC38:
	.ascii	"%s hash error this.id =%x page =%x pre_id =%x hash "
	.ascii	"=%x hash_r =%x\012\000"
	.section	.rodata.FtlMapTblRecovery.str1.1,"aMS",%progbits,1
.LC39:
	.ascii	"%s last blk_id =%x page =%x hash error hash =%x has"
	.ascii	"h_r =%x\012\000"
.LC40:
	.ascii	"%s scan blk_id =%x page =%x hash error hash =%x has"
	.ascii	"h_r =%x\012\000"
	.section	.rodata.FtlMapWritePage.str1.1,"aMS",%progbits,1
.LC18:
	.ascii	"FtlMapWritePage error = %x \012\000"
.LC19:
	.ascii	"FtlMapWritePage error = %x error count = %d\012\000"
	.section	.rodata.FtlProgPages.str1.1,"aMS",%progbits,1
.LC36:
	.ascii	"Ftlwrite decrement_vpc_count %x = %d\012\000"
	.section	.rodata.FtlRecoverySuperblock.str1.1,"aMS",%progbits,1
.LC24:
	.ascii	"spuer block %x vpn is 0\012 \000"
	.section	.rodata.FtlVendorPartRead.str1.1,"aMS",%progbits,1
.LC32:
	.ascii	"FtlVendorPartRead refresh = %x phyAddr = %x\012\000"
	.section	.rodata.FtlVpcTblFlush.str1.1,"aMS",%progbits,1
.LC35:
	.ascii	"FtlVpcTblFlush error = %x error count = %d\012\000"
	.section	.rodata.FtlWrite.str1.1,"aMS",%progbits,1
.LC37:
	.ascii	"FtlWrite: lpa error:%x %x\012\000"
	.section	.rodata.FtlWriteToIDB.str1.1,"aMS",%progbits,1
.LC42:
	.ascii	"write_idblock fail! %x %x %x %x\012\000"
.LC43:
	.ascii	"%s idb buffer alloc fail\012\000"
.LC44:
	.ascii	"%p %x %p %x\012\000"
	.section	.rodata.INSERT_DATA_LIST.str1.1,"aMS",%progbits,1
.LC1:
	.ascii	"\012!!!!! error @ func:%s - line:%d\012\000"
	.section	.rodata.__func__.10015,"a",%progbits
	.set	.LANCHOR175,. + 0
	.type	__func__.10015, %object
	.size	__func__.10015, 23
__func__.10015:
	.ascii	"rk_ftl_garbage_collect\000"
	.section	.rodata.__func__.10277,"a",%progbits
	.set	.LANCHOR137,. + 0
	.type	__func__.10277, %object
	.size	__func__.10277, 15
__func__.10277:
	.ascii	"FlashReadPages\000"
	.section	.rodata.__func__.10296,"a",%progbits
	.set	.LANCHOR142,. + 0
	.type	__func__.10296, %object
	.size	__func__.10296, 15
__func__.10296:
	.ascii	"FlashProgPages\000"
	.section	.rodata.__func__.10320,"a",%progbits
	.set	.LANCHOR77,. + 0
	.type	__func__.10320, %object
	.size	__func__.10320, 17
__func__.10320:
	.ascii	"FlashEraseBlocks\000"
	.section	.rodata.__func__.10435,"a",%progbits
	.set	.LANCHOR185,. + 0
	.type	__func__.10435, %object
	.size	__func__.10435, 14
__func__.10435:
	.ascii	"FtlWriteToIDB\000"
	.section	.rodata.__func__.8940,"a",%progbits
	.set	.LANCHOR169,. + 0
	.type	__func__.8940, %object
	.size	__func__.8940, 13
__func__.8940:
	.ascii	"FtlProgPages\000"
	.section	.rodata.__func__.8968,"a",%progbits
	.set	.LANCHOR177,. + 0
	.type	__func__.8968, %object
	.size	__func__.8968, 9
__func__.8968:
	.ascii	"FtlWrite\000"
	.section	.rodata.__func__.9043,"a",%progbits
	.set	.LANCHOR128,. + 0
	.type	__func__.9043, %object
	.size	__func__.9043, 14
__func__.9043:
	.ascii	"FtlBbt2Bitmap\000"
	.section	.rodata.__func__.9078,"a",%progbits
	.set	.LANCHOR141,. + 0
	.type	__func__.9078, %object
	.size	__func__.9078, 11
__func__.9078:
	.ascii	"FtlLoadBbt\000"
	.section	.rodata.__func__.9193,"a",%progbits
	.set	.LANCHOR49,. + 0
	.type	__func__.9193, %object
	.size	__func__.9193, 17
__func__.9193:
	.ascii	"INSERT_FREE_LIST\000"
	.section	.rodata.__func__.9198,"a",%progbits
	.set	.LANCHOR46,. + 0
	.type	__func__.9198, %object
	.size	__func__.9198, 17
__func__.9198:
	.ascii	"INSERT_DATA_LIST\000"
	.section	.rodata.__func__.9229,"a",%progbits
	.set	.LANCHOR50,. + 0
	.type	__func__.9229, %object
	.size	__func__.9229, 17
__func__.9229:
	.ascii	"List_remove_node\000"
	.section	.rodata.__func__.9261,"a",%progbits
	.set	.LANCHOR54,. + 0
	.type	__func__.9261, %object
	.size	__func__.9261, 22
__func__.9261:
	.ascii	"List_update_data_list\000"
	.section	.rodata.__func__.9270,"a",%progbits
	.set	.LANCHOR150,. + 0
	.type	__func__.9270, %object
	.size	__func__.9270, 16
__func__.9270:
	.ascii	"load_l2p_region\000"
	.section	.rodata.__func__.9303,"a",%progbits
	.set	.LANCHOR81,. + 0
	.type	__func__.9303, %object
	.size	__func__.9303, 26
__func__.9303:
	.ascii	"ftl_map_blk_alloc_new_blk\000"
	.section	.rodata.__func__.9314,"a",%progbits
	.set	.LANCHOR151,. + 0
	.type	__func__.9314, %object
	.size	__func__.9314, 15
__func__.9314:
	.ascii	"ftl_map_blk_gc\000"
	.section	.rodata.__func__.9329,"a",%progbits
	.set	.LANCHOR148,. + 0
	.type	__func__.9329, %object
	.size	__func__.9329, 31
__func__.9329:
	.ascii	"Ftl_write_map_blk_to_last_page\000"
	.section	.rodata.__func__.9343,"a",%progbits
	.set	.LANCHOR149,. + 0
	.type	__func__.9343, %object
	.size	__func__.9343, 16
__func__.9343:
	.ascii	"FtlMapWritePage\000"
	.section	.rodata.__func__.9368,"a",%progbits
	.set	.LANCHOR57,. + 0
	.type	__func__.9368, %object
	.size	__func__.9368, 22
__func__.9368:
	.ascii	"select_l2p_ram_region\000"
	.section	.rodata.__func__.9385,"a",%progbits
	.set	.LANCHOR153,. + 0
	.type	__func__.9385, %object
	.size	__func__.9385, 9
__func__.9385:
	.ascii	"log2phys\000"
	.section	.rodata.__func__.9449,"a",%progbits
	.set	.LANCHOR165,. + 0
	.type	__func__.9449, %object
	.size	__func__.9449, 15
__func__.9449:
	.ascii	"FtlVpcTblFlush\000"
	.section	.rodata.__func__.9471,"a",%progbits
	.set	.LANCHOR140,. + 0
	.type	__func__.9471, %object
	.size	__func__.9471, 14
__func__.9471:
	.ascii	"FtlScanSysBlk\000"
	.section	.rodata.__func__.9527,"a",%progbits
	.set	.LANCHOR178,. + 0
	.type	__func__.9527, %object
	.size	__func__.9527, 15
__func__.9527:
	.ascii	"FtlLoadSysInfo\000"
	.section	.rodata.__func__.9549,"a",%progbits
	.set	.LANCHOR180,. + 0
	.type	__func__.9549, %object
	.size	__func__.9549, 18
__func__.9549:
	.ascii	"FtlMapTblRecovery\000"
	.section	.rodata.__func__.9595,"a",%progbits
	.set	.LANCHOR154,. + 0
	.type	__func__.9595, %object
	.size	__func__.9595, 16
__func__.9595:
	.ascii	"FtlReUsePrevPpa\000"
	.section	.rodata.__func__.9629,"a",%progbits
	.set	.LANCHOR155,. + 0
	.type	__func__.9629, %object
	.size	__func__.9629, 22
__func__.9629:
	.ascii	"FtlRecoverySuperblock\000"
	.section	.rodata.__func__.9686,"a",%progbits
	.set	.LANCHOR60,. + 0
	.type	__func__.9686, %object
	.size	__func__.9686, 16
__func__.9686:
	.ascii	"make_superblock\000"
	.section	.rodata.__func__.9707,"a",%progbits
	.set	.LANCHOR136,. + 0
	.type	__func__.9707, %object
	.size	__func__.9707, 18
__func__.9707:
	.ascii	"SupperBlkListInit\000"
	.section	.rodata.__func__.9734,"a",%progbits
	.set	.LANCHOR159,. + 0
	.type	__func__.9734, %object
	.size	__func__.9734, 14
__func__.9734:
	.ascii	"ftl_check_vpc\000"
	.section	.rodata.__func__.9799,"a",%progbits
	.set	.LANCHOR143,. + 0
	.type	__func__.9799, %object
	.size	__func__.9799, 25
__func__.9799:
	.ascii	"allocate_data_superblock\000"
	.section	.rodata.__func__.9820,"a",%progbits
	.set	.LANCHOR168,. + 0
	.type	__func__.9820, %object
	.size	__func__.9820, 29
__func__.9820:
	.ascii	"allocate_new_data_superblock\000"
	.section	.rodata.__func__.9827,"a",%progbits
	.set	.LANCHOR61,. + 0
	.type	__func__.9827, %object
	.size	__func__.9827, 19
__func__.9827:
	.ascii	"get_new_active_ppa\000"
	.section	.rodata.__func__.9840,"a",%progbits
	.set	.LANCHOR146,. + 0
	.type	__func__.9840, %object
	.size	__func__.9840, 16
__func__.9840:
	.ascii	"update_vpc_list\000"
	.section	.rodata.__func__.9847,"a",%progbits
	.set	.LANCHOR147,. + 0
	.type	__func__.9847, %object
	.size	__func__.9847, 20
__func__.9847:
	.ascii	"decrement_vpc_count\000"
	.section	.rodata.__func__.9917,"a",%progbits
	.set	.LANCHOR170,. + 0
	.type	__func__.9917, %object
	.size	__func__.9917, 19
__func__.9917:
	.ascii	"FtlGcFreeTempBlock\000"
	.section	.rodata.decrement_vpc_count.str1.1,"aMS",%progbits,1
.LC17:
	.ascii	"decrement_vpc_count %x = %d\012\000"
	.section	.rodata.ftl_check_vpc.str1.1,"aMS",%progbits,1
.LC25:
	.ascii	"...%s enter...\012\000"
.LC26:
	.ascii	"FtlCheckVpc2 %x = %x  %x\012\000"
.LC27:
	.ascii	"free blk vpc error %x = %x  %x\012\000"
	.section	.rodata.ftl_map_blk_alloc_new_blk.str1.1,"aMS",%progbits,1
.LC10:
	.ascii	"FtlFreeSysBlkQueueOut = %x, free count = %d\012\000"
	.section	.rodata.ftl_scan_all_data.str1.1,"aMS",%progbits,1
.LC28:
	.ascii	"ftl_scan_all_data = %x\012\000"
.LC29:
	.ascii	"scan lpa = %x ppa= %x\012\000"
.LC30:
	.ascii	"lba = %x,addr= %x,spare= %x %x %x %x data=%x %x\012"
	.ascii	"\000"
	.section	.rodata.load_l2p_region.str1.1,"aMS",%progbits,1
.LC20:
	.ascii	"region_id = %x phyAddr = %x\012\000"
.LC21:
	.ascii	"spare:\000"
.LC22:
	.ascii	"map_ppn:\000"
.LC23:
	.ascii	"load_l2p_region refresh = %x phyAddr = %x\012\000"
	.section	.rodata.rknand_print_hex.str1.1,"aMS",%progbits,1
.LC2:
	.ascii	"%s 0x%x:\000"
.LC3:
	.ascii	"%x \000"
.LC4:
	.ascii	"%02x \000"
.LC5:
	.ascii	"\012\000"
	.section	.rodata.sftl_init.str1.1,"aMS",%progbits,1
.LC41:
	.ascii	"SFTL version: 5.0.50 20181227\000"
	.hidden	free
